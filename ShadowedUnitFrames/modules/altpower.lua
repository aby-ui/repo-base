local AltPower = {}
AltPower.defaultVisibility = false
ShadowUF:RegisterModule(AltPower, "altPowerBar", ShadowUF.L["Alt. Power bar"], true)

function AltPower:OnEnable(frame)
	frame.altPowerBar = frame.altPowerBar or ShadowUF.Units:CreateBar(frame)

	frame:RegisterUnitEvent("UNIT_POWER_BAR_SHOW", self, "UpdateVisibility")
	frame:RegisterUnitEvent("UNIT_POWER_BAR_HIDE", self, "UpdateVisibility")
	frame:RegisterNormalEvent("PLAYER_ENTERING_WORLD", self, "UpdateVisibility")

	frame:RegisterUpdateFunc(self, "UpdateVisibility")
end

function AltPower:OnDisable(frame)
	frame:UnregisterAll(self)
end

local altColor = {}
function AltPower:UpdateVisibility(frame)
	local barID = UnitPowerBarID(frame.unit) or 0
	local barInfo = GetUnitPowerBarInfoByID(barID)
	local visible = false
	if( barInfo and barInfo.barType ) then
		if( ( frame.unitType == "player" or frame.unitType == "pet" ) or not barInfo.hideFromOthers ) then
			visible = true
		elseif( barInfo.showOnRaid and ( UnitInRaid(frame.unit) or UnitInParty(frame.unit) ) ) then
			visible = true
		end
	end

	ShadowUF.Layout:SetBarVisibility(frame, "altPowerBar", visible)

	-- Register or unregister events based on if it's visible
	local type = visible and "RegisterUnitEvent" or "UnregisterSingleEvent"
	frame[type](frame, "UNIT_POWER_FREQUENT", self, "Update")
	frame[type](frame, "UNIT_MAXPOWER", self, "Update")
	frame[type](frame, "UNIT_DISPLAYPOWER", self, "Update")
	if( not visible ) then return end

	local color = ShadowUF.db.profile.powerColors.ALTERNATE
	frame:SetBarColor("altPowerBar", color.r, color.g, color.b)

	AltPower:Update(frame)
end

function AltPower:Update(frame, event, unit, type)
	if( event and type ~= "ALTERNATE" ) then return end
	local barID = UnitPowerBarID(frame.unit) or 0
	local barInfo = GetUnitPowerBarInfoByID(barID)
	local minPower = barInfo and barInfo.minPower or 0

	frame.altPowerBar:SetMinMaxValues(minPower, UnitPowerMax(frame.unit, ALTERNATE_POWER_INDEX) or 0)
	frame.altPowerBar:SetValue(UnitPower(frame.unit, ALTERNATE_POWER_INDEX) or 0)
end
