local Priest = {}
ShadowUF:RegisterModule(Priest, "priestBar", ShadowUF.L["Priest mana bar"], true, "PRIEST", SPEC_PRIEST_SHADOW)

function Priest:OnEnable(frame)
	frame.priestBar = frame.priestBar or ShadowUF.Units:CreateBar(frame)

	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "PowerChanged")

	frame:RegisterUpdateFunc(self, "PowerChanged")
	frame:RegisterUpdateFunc(self, "Update")
end

function Priest:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Priest:OnLayoutApplied(frame)
	if( not frame.visibility.priestBar ) then return end

	local color = ShadowUF.db.profile.powerColors.MANA
	frame:SetBarColor("priestBar", color.r, color.g, color.b)
end

function Priest:PowerChanged(frame)
	local visible = UnitPowerType(frame.unit) ~= ADDITIONAL_POWER_BAR_INDEX and not frame.inVehicle
	local type = visible and "RegisterUnitEvent" or "UnregisterSingleEvent"

	frame[type](frame, "UNIT_POWER_FREQUENT", self, "Update")
	frame[type](frame, "UNIT_MAXPOWER", self, "Update")
	ShadowUF.Layout:SetBarVisibility(frame, "priestBar", visible)

	if( visible ) then self:Update(frame) end
end

function Priest:Update(frame, event, unit, powerType)
	if( powerType and powerType ~= "MANA" ) then return end
	frame.priestBar:SetMinMaxValues(0, UnitPowerMax(frame.unit, Enum.PowerType.Mana))
	frame.priestBar:SetValue(UnitIsDeadOrGhost(frame.unit) and 0 or not UnitIsConnected(frame.unit) and 0 or UnitPower(frame.unit, Enum.PowerType.Mana))
end
