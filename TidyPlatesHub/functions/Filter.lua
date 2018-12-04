
local AddonName, HubData = ...;
local LocalVars = TidyPlatesHubDefaults

local GetUnitSubtitle = TidyPlatesUtility.GetUnitSubtitle
local GetUnitQuestInfo = TidyPlatesUtility.GetUnitQuestInfo

------------------------------------------------------------------------------
-- Unit Filter
------------------------------------------------------------------------------
local function UnitFilter(unit)

	if LocalVars.OpacityFilterLookup[unit.name] then return true
	elseif LocalVars.OpacityFilterNeutralUnits and unit.reaction == "NEUTRAL" then return true
	elseif LocalVars.OpacityFilterUntitledFriendlyNPC and unit.type == "NPC" and unit.reaction == "FRIENDLY" and (not (GetUnitSubtitle(unit) or GetUnitQuestInfo(unit)))  then return true
	elseif LocalVars.OpacityFilterFriendlyNPC and unit.type == "NPC" and unit.reaction == "FRIENDLY" then return true
	elseif LocalVars.OpacityFilterEnemyNPC and unit.type == "NPC" and unit.reaction == "HOSTILE" then return true
	elseif LocalVars.OpacityFilterPlayers and unit.type == "PLAYER" then return true
	elseif LocalVars.OpacityFilterMini and unit.isMini then return true
	elseif LocalVars.OpacityFilterNonElite and (not unit.isElite) then return true
	elseif LocalVars.OpacityFilterInactive then

		if unit.reaction ~= "FRIENDLY" then
			
			if not IsInInstance() and GetUnitQuestInfo(unit) then return false end	-- ie. Quest Units are considered Active in the World.  Excludes instances

			--if not (unit.isMarked or unit.isInCombat or unit.threatValue > 0 or unit.health < unit.healthmax) then
			if not (unit.isMarked or unit.isInCombat or unit.threatValue > 0 or (LocalVars.OpacityFilterInactiveOnlyInCombat and (not InCombatLockdown() or UnitExists("boss1"))) or (not LocalVars.OpacityFilterInactiveOnlyInCombat and unit.health < unit.healthmax)) then
				return true
			end
		end
	end
end

------------------------------------------------------------------------------
-- Local Variable
------------------------------------------------------------------------------

local function OnVariableChange(vars) LocalVars = vars end
HubData.RegisterCallback(OnVariableChange)

------------------------------------------------------------------------------
-- Add References
------------------------------------------------------------------------------
TidyPlatesHubFunctions.UnitFilter = UnitFilter

