
------------------------------
-- Tank Aura/Role Tracking
------------------------------

local GetGroupInfo = TidyPlatesUtility.GetGroupInfo


-- Interface Functions...
---------------------------
local RaidTankList = {}
local inRaid = false
local playerTankRole = false
local playerTankAura = false

local cachedAura = false
local cachedRole = false

local function IsEnemyTanked(unit)
	local unitid = unit.unitid
	local targetOf = unitid.."target"
	-- GetPartyAssignment("MAINTANK", raidid)
	local targetIsTank = UnitIsUnit(targetOf, "pet") or ("TANK" ==  UnitGroupRolesAssigned(targetOf))

	return targetIsTank
end

local function IsPlayerTank()
--[[
	-- Look at the Player's Specialization
	local specializationIndex = tonumber(GetSpecialization())

	if specializationIndex and GetSpecializationRole(specializationIndex) == "TANK" then
		playerTankRole = true
	else
		playerTankRole = false
	end

	-- Check Stances
	local tankForms = { ["18"] = true, ["23"] = true, }
	if GetShapeshiftFormID() == 18 then -- Defensive Stance (Warrior)
		playerTankAura = true
	elseif GetShapeshiftFormID() == 23 then
	end


	UnitBuff("player", "name")
	--]]


	return (playerTankRole or playerTankAura)
end


local TankAuras = {
	["5487"] = true, 		-- Druid: Bear Form
	["25780"] = true, 		-- Paladin: Righteous Fury
	["48263"] = true, 		-- DK: Blood
	["115069"] = true, 		-- Monk: Stance of the Sturdy Ox
}

local function UpdatePlayerRole()
	local spellID, name, _
	local playerTankAura = false

	-- Look at the Player's Specialization
	local specializationIndex = tonumber(GetSpecialization())

	if specializationIndex and GetSpecializationRole(specializationIndex) == "TANK" then
		playerTankRole = true
	else
		playerTankRole = false
	end

	-- Check Auras
	for i = 1, 40 do
		name, _, _, _, _, _, _, _, _, spellID = UnitBuff("player", i)	-- 10th --aby8
		if TankAuras[tostring(spellID)] then
			playerTankAura = true
		end
	end

	-- Check Stances
	if GetShapeshiftFormID() == 18 then -- Defensive Stance (Warrior)
		playerTankAura = true
	end

	if GetShapeshiftFormID() == 23 then -- Stance of the Sturdy Ox (Monk)
		playerTankAura = true
	end


	local activeTank = (playerTankRole or playerTankAura)

	if TidyPlatesWidgets.IsTankingAuraActive ~= activeTank then
		TidyPlatesWidgets.IsTankingAuraActive = activeTank
		TidyPlates:RequestUpdate()
	end
end


------------------------------------------------------------------------
-- UpdateGroupRoles: Builds a list of tanks and squishies
------------------------------------------------------------------------

local function UpdateGroupRoles()

	RaidTankList = wipe(RaidTankList)

	-- If a player is in a dungeon, no need for multi-tanking
	if UnitInRaid("player") then
		inRaid = true

		local groupType, groupSize = GetGroupInfo()
		local raidIndex

		for raidIndex = 1, groupSize do
			local raidid = "raid"..tostring(raidIndex)
			local guid = UnitGUID(raidid)

			local isTank = GetPartyAssignment("MAINTANK", raidid) or ("TANK" == UnitGroupRolesAssigned(raidid))

			if isTank then
				RaidTankList[guid] = true
			end

		end

	-- If not in a raid, try to use guardian pet
	-- as a tank..
	else
		inRaid = false

		if HasPetUI("player") and UnitName("pet") then
			RaidTankList[UnitGUID("pet")] = true
		end
	end

end

local function TankWatcherEvents(frame, event, ...)

	if event == "UNIT_AURA" or event == "UPDATE_SHAPESHIFT_FORM" then
		-- If the player auras change, check to see if they are still in tanking form
		local unitid = ...
		if unitid == "player" then UpdatePlayerRole() end
		return
	else
		-- Otherwise, check everyone...
		UpdateGroupRoles()
		UpdatePlayerRole()
	end
end

if not TankWatcher then TankWatcher = CreateFrame("Frame") end

--[[
TankWatcher:RegisterEvent("GROUP_ROSTER_UPDATE")
TankWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
-- TankWatcher:RegisterEvent("PARTY_MEMBERS_CHANGED")			-- 8.0
TankWatcher:RegisterEvent("UNIT_PET")
TankWatcher:RegisterEvent("PET_BAR_UPDATE_USABLE")
--TankWatcher:RegisterEvent("PARTY_CONVERTED_TO_RAID")
TankWatcher:RegisterEvent("UNIT_AURA")
TankWatcher:RegisterEvent("UPDATE_SHAPESHIFT_FORM")

--]]


--  8.0
TankWatcher:RegisterEvent("GROUP_ROSTER_UPDATE")
TankWatcher:RegisterEvent("PLAYER_ENTERING_WORLD")
TankWatcher:RegisterEvent("UNIT_PET")
TankWatcher:RegisterEvent("PET_BAR_UPDATE_USABLE")
TankWatcher:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
TankWatcher:RegisterEvent("PLAYER_TALENT_UPDATE")
TankWatcher:RegisterEvent("UPDATE_SHAPESHIFT_FORM")


TankWatcher:SetScript("OnEvent", TankWatcherEvents)




TidyPlatesWidgets.IsEnemyTanked = IsEnemyTanked
TidyPlatesWidgets.IsPlayerTank = IsPlayerTank


--[[
local function Dummy() end
TidyPlatesWidgets.EnableTankWatch = Dummy
TidyPlatesWidgets.DisableTankWatch = Dummy
--]]





