if( not ShadowUF.ComboPoints ) then return end

local HolyPower = setmetatable({}, {__index = ShadowUF.ComboPoints})
ShadowUF:RegisterModule(HolyPower, "holyPower", ShadowUF.L["Holy Power"], nil, "PALADIN", nil, PALADINPOWERBAR_SHOW_LEVEL)
local holyConfig = {max = 5, key = "holyPower", colorKey = "HOLYPOWER", powerType = Enum.PowerType.HolyPower, eventType = "HOLY_POWER", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\combo"}

function HolyPower:OnEnable(frame)
	frame.holyPower = frame.holyPower or CreateFrame("Frame", nil, frame)
	frame.holyPower.cpConfig = holyConfig

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "UpdateBarBlocks")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")
	frame:RegisterUpdateFunc(self, "UpdateBarBlocks")

	holyConfig.max = UnitPowerMax("player", holyConfig.powerType)
end

function HolyPower:OnLayoutApplied(frame, config)
	ShadowUF.ComboPoints.OnLayoutApplied(self, frame, config)
	self:UpdateBarBlocks(frame)
end

function HolyPower:GetComboPointType()
	return "holyPower"
end

function HolyPower:GetPoints(unit)
	return UnitPower("player", holyConfig.powerType)
end
