local ActionButton_GetOverlayGlow, ActionButton_ShowOverlayGlow, ActionButton_HideOverlayGlow, ActionButton_OverlayGlowAnimOutFinished, ActionButton_OverlayGlowOnUpdate
--[[------------------------------------------------------------
copy from ActionButton, abyuiActionButtonOverlay(N) self.overlay -> self.abyui_overlay
Masque 没有效果
---------------------------------------------------------------]]

--Overlay stuff
local unusedOverlayGlows = {};
local numOverlays = 0;
function ActionButton_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "abyuiActionButtonOverlay"..numOverlays, UIParent, "abyuiActionBarButtonSpellActivationAlert");
	end
	return overlay;
end

function ActionButton_ShowOverlayGlow(self)
	if ( self.abyui_overlay ) then
		if ( self.abyui_overlay.animOut:IsPlaying() ) then
			self.abyui_overlay.animOut:Stop();
			self.abyui_overlay.animIn:Play();
		end
	else
		self.abyui_overlay = ActionButton_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.abyui_overlay:SetParent(self);
		self.abyui_overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.abyui_overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		self.abyui_overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2);
		self.abyui_overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2);
		self.abyui_overlay.animIn:Play();
	end
end

function ActionButton_HideOverlayGlow(self)
	if ( self.abyui_overlay ) then
		if ( self.abyui_overlay.animIn:IsPlaying() ) then
			self.abyui_overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.abyui_overlay.animOut:Play();
		else
			ActionButton_OverlayGlowAnimOutFinished(self.abyui_overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end

function ActionButton_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.abyui_overlay = nil;
end

function ActionButton_OverlayGlowOnUpdate(self, elapsed)
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

--[[------------------------------------------------------------
export
---------------------------------------------------------------]]
CoreUIShowOverlayGlow = ActionButton_ShowOverlayGlow
CoreUIHideOverlayGlow = ActionButton_HideOverlayGlow
CoreUIOverlayGlowAnimOutFinished = ActionButton_OverlayGlowAnimOutFinished
CoreUIOverlayGlowOnUpdate = ActionButton_OverlayGlowOnUpdate