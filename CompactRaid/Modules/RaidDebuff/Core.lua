------------------------------------------------------------
-- RaidDebuff.lua
--
-- Abin
-- 2010/10/16
------------------------------------------------------------

local wipe = wipe
local UnitDebuff = UnitDebuff
local UnitGUID = UnitGUID

local L = CompactRaid:GetLocale("RaidDebuff")
local module = CompactRaid:CreateModule("RaidDebuff", "ACCOUNT", L["raid debuff"], L["raid debuff desc"])
if not module then return end

local activeDebuffs

--module.debugList = { [GetSpellInfo(6788)] = { level = 5 } } -- Debug using Weaken Soul

local DEFAULT_DB = { scale = 100, xoffset = 0, yoffset = 0, customDebuffs = {}, userLevels = {} }
function module:GetDefaultDB(key)
	if key == "account" then
		return DEFAULT_DB
	end
end

function module:GetActiveDebuffs()
	return activeDebuffs
end

function module:OnInitialize(db, chardb, firstTime)
	self:InitAPI()
	if type(db.customDebuffs) ~= "table" then
		CompactRaid.tcopy(DEFAULT_DB, db)
	end
	self:ApplyCustomDebuffs()
	self:ApplyUserLevels()
end

function module:OnRestoreDefaults()
	self:ClearUserLevels()
	self:ClearCustomDebuffs()
	self:InitOptions()
end

function module:OnUnitChange(frame, displayedUnit, unit, inVehicle, class)
	local visual = self:GetVisual(frame)
	visual.guid = displayedUnit and UnitGUID(displayedUnit)
	visual.unit = displayedUnit
	visual:UpdateDebuff()
end

function module:OnEnable()
	self:InitOptions()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED_NEW_AREA")
	self:ZONE_CHANGED_NEW_AREA()
end

function module:OnDisable()
	activeDebuffs = nil
end

function module:ZONE_CHANGED_NEW_AREA()
	activeDebuffs = self:GetZoneDebuffs() or self.debugList
	self:ShowVisuals(activeDebuffs)
end

function module:FindTopDebuff(unit)
	if not unit or not activeDebuffs then
		return
	end

	local i, data, maxLevel, maxName, maxIcon, maxCount, maxDisType, maxExpires
	for i = 1, 40 do
		local name, icon, count, dispelType, _, expires = UnitDebuff(unit, i)
		if not name then
			break
		end

		data = activeDebuffs[name]
		if data then
			if name == maxName and count > maxCount then
				maxCount = count
			end

			local level = data.level
			if level > (maxLevel or 0) then
				maxLevel, maxName, maxIcon, maxCount, maxDisType, maxExpires = level, name, icon, count, dispelType, expires
			end
		end
	end

	return maxLevel, maxIcon, maxCount, maxDisType, maxExpires
end
