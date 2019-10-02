-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------

local TMW = TMW
if not TMW then return end
local L = TMW.L

local print = TMW.print
local tonumber, pairs =
	  tonumber, pairs
local UnitAura, UnitIsDeadOrGhost =
	  UnitAura, UnitIsDeadOrGhost

local GetSpellTexture = TMW.GetSpellTexture
local strlowerCache = TMW.strlowerCache
local isNumber = TMW.isNumber


local Type = TMW.Classes.IconType:New("buffcheck")
Type.name = L["ICONMENU_BUFFCHECK"]
Type.desc = L["ICONMENU_BUFFCHECK_DESC"]
Type.menuIcon = GetSpellTexture(111922)
Type.usePocketWatch = 1
Type.unitType = "unitid"
Type.hasNoGCD = true
Type.canControlGroup = true

local STATE_PRESENT = TMW.CONST.STATE.DEFAULT_HIDE
local STATE_ABSENT = TMW.CONST.STATE.DEFAULT_SHOW

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("spell")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("reverse")
Type:UsesAttributes("auraSourceUnit, auraSourceGUID")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("stack, stackText")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes


Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)



Type:RegisterIconDefaults{
	-- The unit(s) to check for auras
	Unit					= "player", 

	-- What type of aura to check for. Values are "HELPFUL" or "HARMFUL".
	-- "EITHER" is not supported by this icon type, although this setting is shared with Buff/Debuff icon types.
	BuffOrDebuff			= "HELPFUL", 

	-- Only check auras casted by the player. Appends "|PLAYER" to the UnitAura filter.
	OnlyMine				= false,
}


Type:RegisterConfigPanel_XMLTemplate(100, "TellMeWhen_ChooseName", {
	SUGType = "buffNoDS",
})

Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_Unit", {
	implementsConditions = true,
})

Type:RegisterConfigPanel_ConstructorFunc(120, "TellMeWhen_BuffOrDebuff2", function(self)
	self:SetTitle(TMW.L["ICONMENU_BUFFTYPE"])
	self:BuildSimpleCheckSettingFrame({
		numPerRow = 2,
		function(check)
			check:SetTexts("|cFF00FF00" .. L["ICONMENU_BUFF"], nil)
			check:SetSetting("BuffOrDebuff", "HELPFUL")
		end,
		function(check)
			check:SetTexts("|cFFFF0000" .. L["ICONMENU_DEBUFF"], nil)
			check:SetSetting("BuffOrDebuff", "HARMFUL")
		end,
	})
end)

Type:RegisterConfigPanel_ConstructorFunc(125, "TellMeWhen_BuffCheckSettings", function(self)
	self:SetTitle(Type.name)
	self:BuildSimpleCheckSettingFrame({
		function(check)
			check:SetTexts(L["ICONMENU_ONLYMINE"], L["ICONMENU_ONLYMINE_DESC"])
			check:SetSetting("OnlyMine")
		end,
	})
end)

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_ABSENT] =  { text = "|cFFFF0000" .. L["ICONMENU_ABSENTONANY"],	tooltipText = L["ICONMENU_ABSENTONANY_DESC"],	},
	[STATE_PRESENT] = { text = "|cFF00FF00" .. L["ICONMENU_PRESENTONALL"],	tooltipText = L["ICONMENU_PRESENTONALL_DESC"], 	},
})



local function Buff_OnEvent(icon, event, arg1)
	if event == "UNIT_AURA" and icon.UnitSet.UnitsLookup[arg1] then
		-- If the icon is checking the unit, schedule an update for the icon.
		icon.NextUpdateTime = 0
	elseif event == "TMW_UNITSET_UPDATED" and arg1 == icon.UnitSet then
		-- A unit was just added or removed from icon.Units, so schedule an update.
		icon.NextUpdateTime = 0
	end
end

local huge = math.huge
local function BuffCheck_OnUpdate(icon, time)

	-- Upvalue things that will be referenced a lot in our loops.
	local Units, NameArray, NameStringArray, NameHash, Filter
	= icon.Units, icon.Spells.Array, icon.Spells.StringArray, icon.Spells.Hash, icon.Filter
	
	local AbsentAlpha = icon.States[STATE_ABSENT].Alpha
	local PresentAlpha = icon.States[STATE_PRESENT].Alpha

	-- These variables will hold all the attributes that we pass to YieldInfo().
	local iconTexture, id, count, duration, expirationTime, caster, useUnit
	local curSortDur = huge

	for u = 1, #Units do
		local unit = Units[u]
		-- UnitSet:UnitExists(unit) is an improved UnitExists() that returns early if the unit
		-- is known by TMW.UNITS to definitely exist.
		-- Also don't check dead units since the point of this icon type is to check for
		-- raid members that are missing raid buffs.
		if icon.UnitSet:UnitExists(unit) and not UnitIsDeadOrGhost(unit) then
			
			local foundOnUnit = false
			for index = 1, huge do
				local _buffName, _iconTexture, _count, _, _duration, _expirationTime, _caster, _, _, _id = UnitAura(unit, index, Filter)
				if not _id then
					-- No more auras on the unit. Break spell loop.
					break
				elseif NameHash[_id] or NameHash[strlowerCache[_buffName]] then
					foundOnUnit = true
					local remaining = (_expirationTime == 0 and huge) or _expirationTime - time

					-- This icon type automatically sorts by lowest duration.
					if not id or remaining < curSortDur then
						-- If we haven't found anything yet, or if this aura beats the previous by sort order, then use it.
						iconTexture,  count,  duration,  expirationTime,  caster,  id,  useUnit, curSortDur =
						_iconTexture, _count, _duration, _expirationTime, _caster, _id,  unit,    remaining
					end

					if PresentAlpha == 0 then
						-- We aren't displaying present auras,
						-- so don't bother continuing to look after we've found something.
						break
					end
				end
			end

			if not foundOnUnit and AbsentAlpha > 0 and not icon:YieldInfo(true, unit) then
				-- If we didn't find a matching aura, and the icon is set to show when we don't find something
				-- then report what unit it was. This is the primary point of the icon - to find units that are missing everything.
				-- If icon:YieldInfo() returns false, it means we don't need to keep harvesting data.
				return
			end
		end
	end

	-- We didn't find any units that were missing all the auras being checked.
	-- So, report the lowest duration aura that we did find.
	icon:YieldInfo(false, useUnit, iconTexture, count, duration, expirationTime, caster, id)
end

function Type:HandleYieldedInfo(icon, iconToSet, unit, iconTexture, count, duration, expirationTime, caster, id)
	if not unit then
		-- Unit is nil if the icon didn't check any living units.
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			0,
			icon.FirstTexture,
			0, 0,
			nil, nil,
			icon.Spells.First,
			nil, nil,
			nil, nil
		)
	elseif not id then
		-- ID is nil if we found a unit that is missing all of the auras that are being checked for.
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			STATE_ABSENT,
			icon.FirstTexture,
			0, 0,
			nil, nil,
			icon.Spells.First,
			unit, nil,
			nil, nil
		)
	elseif id then
		-- ID is defined if we didn't find any units that are missing all the auras being checked for.
		-- In this case, the data is for the first matching aura found on the first unit checked.
		iconToSet:SetInfo("state; texture; start, duration; stack, stackText; spell; unit, GUID; auraSourceUnit, auraSourceGUID",
			STATE_PRESENT,
			iconTexture,
			expirationTime - duration, duration,
			count, count,
			id,
			unit, nil,
			caster, nil
		)
	end
end


function Type:Setup(icon)
	icon.Spells = TMW:GetSpells(icon.Name, false)
	
	icon.Units, icon.UnitSet = TMW:GetUnits(icon, icon.Unit, icon:GetSettings().UnitConditions)


	-- This icon can't check both buffs and debuffs, but it reuses this setting from buff/debuff icons.
	-- So, if it is set to EITHER, then reset it to HELPFUL.
	if icon.BuffOrDebuff == "EITHER" then
		icon:GetSettings().BuffOrDebuff = "HELPFUL"
		icon.BuffOrDebuff = "HELPFUL"
	end
	

	-- Setup the filter that will be used by UnitAura in the icon's update function.
	icon.Filter = icon.BuffOrDebuff
	if icon.OnlyMine then
		icon.Filter = icon.Filter .. "|PLAYER"
	end



	icon.FirstTexture = GetSpellTexture(icon.Spells.First)

	icon:SetInfo("texture; reverse", Type:GetConfigIconTexture(icon), true)
	


	-- Setup events and update functions.
	if icon.UnitSet.allUnitsChangeOnEvent then
		icon:SetUpdateMethod("manual")
	
		icon:RegisterEvent("UNIT_AURA")
	
		icon:SetScript("OnEvent", Buff_OnEvent)
		TMW:RegisterCallback("TMW_UNITSET_UPDATED", Buff_OnEvent, icon)
	end

	icon:SetUpdateFunction(BuffCheck_OnUpdate)

	icon:Update()
end
	
Type:Register(101)

