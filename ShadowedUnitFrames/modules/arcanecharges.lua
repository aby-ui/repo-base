if( not ShadowUF.ComboPoints ) then return end

local ArcaneCharges = setmetatable({}, {__index = ShadowUF.ComboPoints})
ShadowUF:RegisterModule(ArcaneCharges, "arcaneCharges", ShadowUF.L["Arcane Charges"], nil, "MAGE", SPEC_MAGE_ARCANE)
local arcaneConfig = {max = 5, key = "arcaneCharges", colorKey = "ARCANECHARGES", powerType = Enum.PowerType.ArcaneCharges, eventType = "ARCANE_CHARGES", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\combo"}

function ArcaneCharges:OnEnable(frame)
	frame.arcaneCharges = frame.arcaneCharges or CreateFrame("Frame", nil, frame)
	frame.arcaneCharges.cpConfig = arcaneConfig
	frame.comboPointType = arcaneConfig.key

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "UpdateBarBlocks")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "Update")

	frame:RegisterUpdateFunc(self, "Update")
	frame:RegisterUpdateFunc(self, "UpdateBarBlocks")
end

function ArcaneCharges:OnLayoutApplied(frame, config)
	ShadowUF.ComboPoints.OnLayoutApplied(self, frame, config)
	self:UpdateBarBlocks(frame)
end

function ArcaneCharges:GetComboPointType()
	return "arcaneCharges"
end

function ArcaneCharges:GetPoints(unit)
	return UnitPower("player", arcaneConfig.powerType)
end
