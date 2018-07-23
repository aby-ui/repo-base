------------------------------------------------------------
-- Core.lua
--
-- Abin
-- 2017/8/27
------------------------------------------------------------

local UnitName = UnitName
local wipe = wipe
local GetTime = GetTime
local pairs = pairs

local addon = CompactRaid
local module = addon:GetModule("RaidDebuff")
if not module then return end

local overrideDebuffs = {}

function module:SetOverrideDebuff(guid, icon, count, dispelType, expires)
	local hasContents
	local visual = self:FindVisual(guid, 1)
	local data = overrideDebuffs[guid]
	if data then
		if icon and visual then
			hasContents = 1
			data.icon, data.count, data.dispelType, data.expires = icon, count, dispelType, expires
		else
			overrideDebuffs[guid] = nil
		end
	else
		if icon and visual then
			hasContents = 1
			overrideDebuffs[guid] = { icon = icon, count = count, dispelType = dispelType, expires = expires }
		end
	end

	if visual then
		visual:UpdateDebuff()
	end

	if hasContents then
		self:RegisterTick()
	end
end

function module:GetOverrideDebuff(guid)
	local data = overrideDebuffs[guid]
	if data then
		return data.icon, data.count, data.dispelType, data.expires
	end
end

-- We are responsible to cleanup all overrides
function module:OnTick()
	local hasContents
	local now = GetTime()
	local guid, data
	for guid, data in pairs(overrideDebuffs) do
		if data.expires < now then
			overrideDebuffs[guid] = nil
			local visual = self:FindVisual(guid, 1)
			if visual then
				visual:UpdateDebuff()
			end
		else
			hasContents = 1
		end
	end

	if not hasContents then
		self:UnregisterTick()
	end
end

hooksecurefunc(module, "ShowVisuals", function(self, show)
	if show then
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	else
		self:UnregisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
		self:UnregisterTick()
		wipe(overrideDebuffs)
	end
end)

function module:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	local bossName = UnitName("boss1")
	if not self.bossName and bossName then
		self.bossName = bossName
		addon:BroadcastEvent("RaidDebuff_OnEncounterBegin", bossName)
	elseif self.bossName and not bossName then
		addon:BroadcastEvent("RaidDebuff_OnEncounterEnd", bossName)
		self.bossName = nil
	end
end