local HealAbsorb = setmetatable({["frameKey"] = "healAbsorb", ["colorKey"] = "healAbsorb", ["frameLevelMod"] = 1}, {__index = ShadowUF.IncHeal})
ShadowUF:RegisterModule(HealAbsorb, "healAbsorb", ShadowUF.L["Healing absorb"])

function HealAbsorb:OnEnable(frame)
	frame.healAbsorb = frame.healAbsorb or ShadowUF.Units:CreateBar(frame)

	frame:RegisterUnitEvent("UNIT_MAXHEALTH", self, "UpdateFrame")
	frame:RegisterUnitEvent("UNIT_HEALTH", self, "UpdateFrame")
	frame:RegisterUnitEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED", self, "UpdateFrame")

	frame:RegisterUpdateFunc(self, "UpdateFrame")
end

function HealAbsorb:UpdateFrame(frame)
	if( not frame.visibility[self.frameKey] or not frame.visibility.healthBar ) then return end

	self:PositionBar(frame, UnitGetTotalHealAbsorbs(frame.unit) or 0)
end
