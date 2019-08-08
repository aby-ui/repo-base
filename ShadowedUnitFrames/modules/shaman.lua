local Shaman = {}
ShadowUF:RegisterModule(Shaman, "shamanBar", ShadowUF.L["Shaman mana bar"], true, "SHAMAN")

function Shaman:OnEnable(frame)
	frame.shamanBar = frame.shamanBar or ShadowUF.Units:CreateBar(frame)

	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "PowerChanged")

	frame:RegisterUpdateFunc(self, "PowerChanged")
	frame:RegisterUpdateFunc(self, "Update")
end

function Shaman:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Shaman:OnLayoutApplied(frame)
	if( not frame.visibility.shamanBar ) then return end

	local color = ShadowUF.db.profile.powerColors.MANA
	frame:SetBarColor("shamanBar", color.r, color.g, color.b)
end

function Shaman:PowerChanged(frame)
	local visible = UnitPowerType(frame.unit) ~= ADDITIONAL_POWER_BAR_INDEX and not frame.inVehicle
	local type = visible and "RegisterUnitEvent" or "UnregisterSingleEvent"

	frame[type](frame, "UNIT_POWER_FREQUENT", self, "Update")
	frame[type](frame, "UNIT_MAXPOWER", self, "Update")
	ShadowUF.Layout:SetBarVisibility(frame, "shamanBar", visible)

	if( visible ) then self:Update(frame) end
end

function Shaman:Update(frame, event, unit, powerType)
	if( powerType and powerType ~= "MANA" ) then return end
	frame.shamanBar:SetMinMaxValues(0, UnitPowerMax(frame.unit, Enum.PowerType.Mana))
	frame.shamanBar:SetValue(UnitIsDeadOrGhost(frame.unit) and 0 or not UnitIsConnected(frame.unit) and 0 or UnitPower(frame.unit, Enum.PowerType.Mana))
end
