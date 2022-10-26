if( not ShadowUF.ComboPoints ) then return end

local Essence = setmetatable({}, {__index = ShadowUF.ComboPoints})
ShadowUF:RegisterModule(Essence, "essence", ShadowUF.L["Essence"], nil, "EVOKER")
local essenceConfig = {max = 5, key = "essence", colorKey = "ESSENCE", powerType = Enum.PowerType.Essence, eventType = "ESSENCE", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\combo"}

function Essence:OnEnable(frame)
	frame.essence = frame.essence or CreateFrame("Frame", nil, frame)
	frame.essence.cpConfig = essenceConfig

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "UpdateBarBlocks")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")
	frame:RegisterUpdateFunc(self, "UpdateBarBlocks")

	essenceConfig.max = UnitPowerMax("player", essenceConfig.powerType)
end

function Essence:OnLayoutApplied(frame, config)
	ShadowUF.ComboPoints.OnLayoutApplied(self, frame, config)
	self:UpdateBarBlocks(frame)
end

function Essence:GetComboPointType()
	return "essence"
end

function Essence:GetPoints(unit)
	return UnitPower("player", essenceConfig.powerType)
end
