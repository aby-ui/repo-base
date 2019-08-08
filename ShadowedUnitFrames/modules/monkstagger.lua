local Stagger = {}
ShadowUF:RegisterModule(Stagger, "staggerBar", ShadowUF.L["Stagger bar"], true, "MONK", SPEC_MONK_BREWMASTER)

function Stagger:OnEnable(frame)
	frame.staggerBar = frame.staggerBar or ShadowUF.Units:CreateBar(frame)
	frame.staggerBar.timeElapsed = 0
	frame.staggerBar.parent = frame
	frame.staggerBar:SetScript("OnUpdate", function(f, elapsed)
		f.timeElapsed = f.timeElapsed + elapsed
		if( f.timeElapsed < 0.25 ) then return end
		f.timeElapsed = f.timeElapsed - 0.25

		Stagger:Update(f.parent)
	end)

	frame:RegisterUnitEvent("UNIT_MAXHEALTH", self, "UpdateMinMax")
	frame:RegisterUpdateFunc(self, "UpdateMinMax")
end

function Stagger:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Stagger:OnLayoutApplied(frame)
	if( frame.staggerBar ) then
		frame.staggerBar.colorState = nil
	end
end

function Stagger:UpdateMinMax(frame)
	frame.staggerBar.maxHealth = UnitHealthMax(frame.unit)
	frame.staggerBar:SetMinMaxValues(0, frame.staggerBar.maxHealth)

	self:Update(frame)
end

function Stagger:Update(frame)
	local stagger = UnitStagger(frame.unit)
	if( not stagger ) then return end

	-- Figure out how screwed they are
	local percent = stagger / frame.staggerBar.maxHealth
	local state
	if( percent < STAGGER_YELLOW_TRANSITION ) then
		state = "STAGGER_GREEN"
	elseif( percent < STAGGER_RED_TRANSITION ) then
		state = "STAGGER_YELLOW"
	else
		state = "STAGGER_RED"
	end

	frame:SetBarColor("staggerBar", ShadowUF.db.profile.powerColors[state].r, ShadowUF.db.profile.powerColors[state].g, ShadowUF.db.profile.powerColors[state].b)
	frame.staggerBar:SetValue(stagger)
end
