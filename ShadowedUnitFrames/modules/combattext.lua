local Combat = {}
ShadowUF:RegisterModule(Combat, "combatText", ShadowUF.L["Combat text"])

function Combat:OnEnable(frame)
	if( not frame.combatText ) then
		frame.combatText = CreateFrame("Frame", nil, frame.highFrame)
		frame.combatText:SetFrameStrata("HIGH")
		frame.combatText.feedbackText = frame.combatText:CreateFontString(nil, "ARTWORK")
		frame.combatText.feedbackText:SetPoint("CENTER", frame.combatText, "CENTER", 0, 0)
		frame.combatText:SetFrameLevel(frame.topFrameLevel)

		frame.combatText.feedbackStartTime = 0
		frame.combatText:SetScript("OnUpdate", CombatFeedback_OnUpdate)
		frame.combatText:SetHeight(1)
		frame.combatText:SetWidth(1)
	end

	frame:RegisterUnitEvent("UNIT_COMBAT", self, "Update")
end

function Combat:OnLayoutApplied(frame, config)
	-- Update feedback text
	ShadowUF.Layout:ToggleVisibility(frame.combatText, frame.visibility.combatText)
	if( frame.visibility.combatText ) then
		frame.combatText.feedbackFontHeight = ShadowUF.db.profile.font.size + 1
		frame.combatText.fontPath = ShadowUF.Layout.mediaPath.font

		ShadowUF.Layout:SetupFontString(frame.combatText.feedbackText, 1)
		ShadowUF.Layout:AnchorFrame(frame, frame.combatText, config.combatText)
	end
end

function Combat:OnDisable(frame)
	frame:UnregisterAll(self)
end

function Combat:Update(frame, event, unit, type, ...)
	CombatFeedback_OnCombatEvent(frame.combatText, type, ...)
	if( type == "IMMUNE" ) then
		frame.combatText.feedbackText:SetTextHeight(frame.combatText.feedbackFontHeight * 0.75)
	end

	-- Increasing the font size will make the text look pixelated, however scaling it up will make it look smooth and awesome
	local scale = frame.combatText.feedbackText:GetStringHeight() / ShadowUF.db.profile.font.size
	if( scale > 0 ) then
		frame.combatText:SetScale(scale)
		frame.combatText.feedbackText:SetFont(frame.combatText.fontPath, ShadowUF.db.profile.font.size, "OUTLINE")
	end
end
