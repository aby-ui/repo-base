-- Prevent tainting global _.
local _
local _G = _G

--Overlay stuff
local EA_unusedOverlayGlows = {};
local EA_numOverlays = 0;
function EA_ActionButton_GetOverlayGlow()
	local overlay = tremove(EA_unusedOverlayGlows);
	if ( not overlay ) then
		EA_numOverlays = EA_numOverlays + 1;
		overlay = CreateFrame("Frame", "EA_ActionButtonOverlay"..EA_numOverlays, UIParent, "EA_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

function EA_ActionButton_UpdateOverlayGlow(self)
	local spellType, id, subType  = GetActionInfo(self.action);
	if ( spellType == "spell" and IsSpellOverlayed(id) ) then
		EA_ActionButton_ShowOverlayGlow(self);
	elseif ( spellType == "macro" ) then
		local spellId = GetMacroSpell(id);
		if ( spellId and IsSpellOverlayed(spellId) ) then
			EA_ActionButton_ShowOverlayGlow(self);
		else
			EA_ActionButton_HideOverlayGlow(self);
		end
	else
		EA_ActionButton_HideOverlayGlow(self);
	end
end

function EA_ActionButton_ShowOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = EA_ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.4, frameHeight * 0.4);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.4, -frameHeight * 0.4);
		self.overlay.animIn:Play();
	end
end

function EA_ActionButton_HideOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			EA_ActionButton_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

function EA_ActionButton_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(EA_unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function EA_ActionButton_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
	local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
		self:SetAlpha(0.5);
	else
		self:SetAlpha(1.0);
	end
end