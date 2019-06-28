if( not ShadowUF.ComboPoints ) then return end

local Chi = setmetatable({}, {__index = ShadowUF.ComboPoints})
ShadowUF:RegisterModule(Chi, "chi", ShadowUF.L["Chi"], nil, "MONK", SPEC_MONK_WINDWALKER)
local chiConfig = {max = 5, key = "chi", colorKey = "CHI", powerType = Enum.PowerType.Chi, eventType = "CHI", icon = "Interface\\AddOns\\ShadowedUnitFrames\\media\\textures\\combo"}

function Chi:OnEnable(frame)
	frame.chi = frame.chi or CreateFrame("Frame", nil, frame)
	frame.chi.cpConfig = chiConfig

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "UpdateBarBlocks")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "Update")
	frame:RegisterUpdateFunc(self, "Update")
end

function Chi:OnLayoutApplied(frame, config)
	ShadowUF.ComboPoints.OnLayoutApplied(self, frame, config)
	self:UpdateBarBlocks(frame)
end

function Chi:GetComboPointType()
	return "chi"
end

function Chi:GetPoints(unit)
	return UnitPower("player", chiConfig.powerType)
end
