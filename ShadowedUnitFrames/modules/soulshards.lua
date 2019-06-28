if( not ShadowUF.ComboPoints ) then return end

local Souls = setmetatable({}, {__index = ShadowUF.ComboPoints})
ShadowUF:RegisterModule(Souls, "soulShards", ShadowUF.L["Soul Shards"], nil, "WARLOCK")
local soulsConfig = {max = 5, key = "soulShards", colorKey = "SOULSHARDS", powerType = Enum.PowerType.SoulShards, eventType = "SOUL_SHARDS", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\shard"}

function Souls:OnEnable(frame)
	frame.soulShards = frame.soulShards or CreateFrame("Frame", nil, frame)
	frame.soulShards.cpConfig = soulsConfig
	frame.soulShards.cpConfig.max = (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION) and 50 or 5
	frame.soulShards.cpConfig.grouping = (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION) and UnitPowerDisplayMod(soulsConfig.powerType) or 1
	frame.comboPointType = soulsConfig.key

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "UpdateBarBlocks")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "Update")
	frame:RegisterNormalEvent("PLAYER_SPECIALIZATION_CHANGED", self, "SpecChanged")

	frame:RegisterUpdateFunc(self, "Update")
	frame:RegisterUpdateFunc(self, "UpdateBarBlocks")
end

function Souls:OnLayoutApplied(frame, config)
	ShadowUF.ComboPoints.OnLayoutApplied(self, frame, config)
	self:UpdateBarBlocks(frame)
end

function Souls:SpecChanged(frame)
	-- update shard count on spec swap
	if frame and frame.soulShards then
		frame.soulShards.cpConfig.max = (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION) and 50 or 5
		frame.soulShards.cpConfig.grouping = (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION) and UnitPowerDisplayMod(soulsConfig.powerType) or 1
	end
	self:UpdateBarBlocks(frame)
end

function Souls:GetComboPointType()
	return "soulShards"
end

function Souls:GetPoints(unit)
	return UnitPower("player", soulsConfig.powerType, (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION))
end

function Souls:GetMaxPoints(unit)
	return UnitPowerMax("player", soulsConfig.powerType, (GetSpecialization() == SPEC_WARLOCK_DESTRUCTION))
end
