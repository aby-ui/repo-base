local Power = {}
local powerMap = ShadowUF.Tags.powerMap
ShadowUF:RegisterModule(Power, "powerBar", ShadowUF.L["Power bar"], true)

function Power:OnEnable(frame)
	frame.powerBar = frame.powerBar or ShadowUF.Units:CreateBar(frame)

	frame:RegisterUnitEvent("UNIT_POWER_FREQUENT", self, "Update")
	frame:RegisterUnitEvent("UNIT_MAXPOWER", self, "Update")
	frame:RegisterUnitEvent("UNIT_CONNECTION", self, "Update")
	frame:RegisterUnitEvent("UNIT_POWER_BAR_SHOW", self, "Update")
	frame:RegisterUnitEvent("UNIT_POWER_BAR_HIDE", self, "Update")
	frame:RegisterUnitEvent("UNIT_DISPLAYPOWER", self, "UpdateColor")
	frame:RegisterUnitEvent("UNIT_CLASSIFICATION_CHANGED", self, "UpdateClassification")

	-- run an update after returning to life
	if ( frame.unit == "player" ) then
		frame:RegisterNormalEvent("PLAYER_UNGHOST", self, "Update")
	end

	-- UNIT_MANA fires after repopping at a spirit healer, make sure to update powers then
	frame:RegisterUnitEvent("UNIT_MANA", self, "Update")

	frame:RegisterUpdateFunc(self, "UpdateClassification")
	frame:RegisterUpdateFunc(self, "UpdateColor")
	frame:RegisterUpdateFunc(self, "Update")
end

function Power:OnDisable(frame)
	frame:UnregisterAll(self)
end

local altColor = {}
function Power:UpdateColor(frame)
	local powerID, currentType, altR, altG, altB = UnitPowerType(frame.unit)
	frame.powerBar.currentType = currentType

	-- Overridden power types like Warlock pets, or Ulduar vehicles use "POWER_TYPE_#####" but triggers power events with "ENERGY", so this fixes that
	-- by using the powerID to figure out the event type
	if( not powerMap[currentType] ) then
		frame.powerBar.currentType = powerMap[powerID] or "ENERGY"
	end

	if( ShadowUF.db.profile.units[frame.unitType].powerBar.onlyMana ) then
		ShadowUF.Layout:SetBarVisibility(frame, "powerBar", currentType == "MANA")
		if( currentType ~= "MANA" ) then return end
	end


	local color
	if( frame.powerBar.minusMob ) then
		color = ShadowUF.db.profile.healthColors.offline
	elseif( ShadowUF.db.profile.units[frame.unitType].powerBar.colorType == "class" and UnitIsPlayer(frame.unit) ) then
		local class = frame:UnitClassToken()
		color = class and ShadowUF.db.profile.classColors[class]
	end

	if( not color ) then
		color = ShadowUF.db.profile.powerColors[frame.powerBar.currentType]
		if( not color ) then
			if( altR ) then
				altColor.r, altColor.g, altColor.b = altR, altG, altB
				color = altColor
			else
				color = ShadowUF.db.profile.powerColors.MANA
			end
		end
	end

	frame:SetBarColor("powerBar", color.r, color.g, color.b)

	self:Update(frame)
end

function Power:UpdateClassification(frame, event, unit)
	local classif = UnitClassification(frame.unit)
	local minus = nil
	if( classif == "minus" ) then
		minus = true

		frame.powerBar:SetMinMaxValues(0, 1)
		frame.powerBar:SetValue(0)
	end

	if( minus ~= frame.powerBar.minusMob ) then
		frame.powerBar.minusMob = minus

		-- Only need to force an update if it was event driven, otherwise the update func will hit color/etc next
		if( event ) then
			self:UpdateColor(frame)
		end
	end
end

function Power:Update(frame, event, unit, powerType)
	if( event and powerType and powerType ~= frame.powerBar.currentType ) then return end
	if( frame.powerBar.minusMob ) then return end

	frame.powerBar.currentPower = UnitPower(frame.unit)
	frame.powerBar:SetMinMaxValues(0, UnitPowerMax(frame.unit))
	frame.powerBar:SetValue(UnitIsDeadOrGhost(frame.unit) and 0 or not UnitIsConnected(frame.unit) and 0 or frame.powerBar.currentPower)
end
