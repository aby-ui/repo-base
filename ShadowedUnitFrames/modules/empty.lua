local Empty = {}
local fallbackColor
ShadowUF:RegisterModule(Empty, "emptyBar", ShadowUF.L["Empty bar"], true)

function Empty:OnEnable(frame)
	frame.emptyBar = frame.emptyBar or ShadowUF.Units:CreateBar(frame)
	frame.emptyBar:SetMinMaxValues(0, 1)
	frame.emptyBar:SetValue(0)

	fallbackColor = fallbackColor or {r = 0, g = 0, b = 0}
end

function Empty:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Empty:OnLayoutApplied(frame)
	if( frame.visibility.emptyBar ) then
		local color = frame.emptyBar.background.overrideColor or fallbackColor
		frame.emptyBar.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.alpha)

		if( ShadowUF.db.profile.units[frame.unitType].emptyBar.reactionType or ShadowUF.db.profile.units[frame.unitType].emptyBar.class ) then
			frame:RegisterUnitEvent("UNIT_FACTION", self, "UpdateColor")
			frame:RegisterUpdateFunc(self, "UpdateColor")
		else
			self:OnDisable(frame)
		end
	end
end

function Empty:UpdateColor(frame)
	local color
	local reactionType = ShadowUF.db.profile.units[frame.unitType].emptyBar.reactionType

	if( ( reactionType == "npc" or reactionType == "both" ) and not UnitPlayerControlled(frame.unit) and UnitIsTapDenied(frame.unit) and UnitCanAttack("player", frame.unit) ) then
		color = ShadowUF.db.profile.healthColors.tapped
	elseif( not UnitPlayerOrPetInRaid(frame.unit) and not UnitPlayerOrPetInParty(frame.unit) and ( ( ( reactionType == "player" or reactionType == "both" ) and UnitIsPlayer(frame.unit) and not UnitIsFriend(frame.unit, "player") ) or ( ( reactionType == "npc" or reactionType == "both" ) and not UnitIsPlayer(frame.unit) ) ) ) then
		if( not UnitIsFriend(frame.unit, "player") and UnitPlayerControlled(frame.unit) ) then
			if( UnitCanAttack("player", frame.unit) ) then
				color = ShadowUF.db.profile.healthColors.hostile
			else
				color = ShadowUF.db.profile.healthColors.enemyUnattack
			end
		elseif( UnitReaction(frame.unit, "player") ) then
			local reaction = UnitReaction(frame.unit, "player")
			if( reaction > 4 ) then
				color = ShadowUF.db.profile.healthColors.friendly
			elseif( reaction == 4 ) then
				color = ShadowUF.db.profile.healthColors.neutral
			elseif( reaction < 4 ) then
				color = ShadowUF.db.profile.healthColors.hostile
			end
		end
	elseif( ShadowUF.db.profile.units[frame.unitType].emptyBar.class and ( UnitIsPlayer(frame.unit) or UnitCreatureFamily(frame.unit) ) ) then
		local class = UnitCreatureFamily(frame.unit) or frame:UnitClassToken()
		color = class and ShadowUF.db.profile.classColors[class]
	end

	color = color or frame.emptyBar.background.overrideColor or fallbackColor
	frame.emptyBar.background:SetVertexColor(color.r, color.g, color.b, ShadowUF.db.profile.bars.alpha)
end

