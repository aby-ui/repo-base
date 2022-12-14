local E = select(2, ...):unpack()
local P = E.Party

local tinsert = table.insert
local tremove = table.remove

local unusedOverlayGlows = {}
local numOverlays = 0

local function OmniCDOverlayGlow_AnimOutFinished(animGroup)
	local overlay = animGroup:GetParent()
	local icon = overlay:GetParent()
	overlay:Hide()
	tinsert(unusedOverlayGlows, overlay)
	icon.overlay = nil
end

local function OmniCDOverlay_OnHide(self)
	if self.animOut:IsPlaying() then
		self.animOut:Stop()
		OmniCDOverlayGlow_AnimOutFinished(self.animOut)
	end
end

local function GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows)
	if not overlay then
		numOverlays = numOverlays + 1
		overlay = CreateFrame("Frame", "OmniCDOverlayGlow".. numOverlays, UIParent, "OmniCDButtonSpellActivationAlert")
		overlay.animOut:SetScript("OnFinished", OmniCDOverlayGlow_AnimOutFinished)
		overlay:SetScript("OnHide", OmniCDOverlay_OnHide)
	end
	return overlay
end

local function ShowOverlayGlowNoAnim(overlay)
	local frameWidth, frameHeight = overlay:GetSize()
	overlay.spark:SetSize(frameWidth, frameHeight)
	overlay.spark:SetAlpha(0)
	overlay.innerGlow:SetSize(frameWidth, frameHeight)
	overlay.innerGlow:SetAlpha(0)
	overlay.innerGlowOver:SetAlpha(0)
	overlay.outerGlow:SetSize(frameWidth, frameHeight)
	overlay.outerGlow:SetAlpha(1.0)
	overlay.outerGlowOver:SetAlpha(0)
	overlay.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
	overlay.ants:SetAlpha(1.0)
	overlay:Show()
end

local RemoveHighlight_OnTimerEnd
RemoveHighlight_OnTimerEnd = function(icon)
	local info = P.groupInfo[icon.guid]
	if info and icon.isHighlighted then
		local duration = P:GetBuffDuration(info.unit, icon.buff)
		if not duration then
			P:RemoveHighlight(icon)
		elseif duration > 0 then
			icon.isHighlighted = E.TimerAfter(duration + 0.1, RemoveHighlight_OnTimerEnd, icon)
		end
	end
end

local function ShowOverlayGlow(icon, duration, isRefresh)
	if E.db.highlight.glowType == "wardrobe" then
		if not icon.isHighlighted then
			icon.PendingFrame:Show()
			if not isRefresh then
				icon.AnimFrame.animIn:Play()
			end
		end
	elseif icon.overlay then
		if icon.overlay.animOut:IsPlaying() then
			icon.overlay.animOut:Stop()
			if isRefresh then
				ShowOverlayGlowNoAnim(icon.overlay)
			else
				icon.overlay.animIn:Play()
			end
		end
	else
		icon.overlay = GetOverlayGlow()
		local frameWidth, frameHeight = icon:GetSize()
		icon.overlay:SetParent(icon)
		icon.overlay:ClearAllPoints()
		icon.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
		icon.overlay:SetPoint("TOPLEFT", icon, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2)
		icon.overlay:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2)
		if isRefresh then
			ShowOverlayGlowNoAnim(icon.overlay)
		else
			icon.overlay.animIn:Play()
		end
	end
	if type(icon.isHighlighted) == "table" then
		icon.isHighlighted:Cancel()
	end
	icon.isHighlighted = (E.isClassic or icon.guid == E.userGUID) and true or E.TimerAfter(duration + 0.1, RemoveHighlight_OnTimerEnd, icon)
end

function P:HideOverlayGlow(icon)
	if icon.overlay then
		if icon.overlay.animIn:IsPlaying() then
			icon.overlay.animIn:Stop()
		end

		if icon:IsVisible() then
			icon.overlay.animOut:Play()
		else
			OmniCDOverlayGlow_AnimOutFinished(icon.overlay.animOut)
		end
	elseif icon.isHighlighted then
		icon.PendingFrame:Hide()
		if icon:IsVisible() then
			icon.AnimFrame.animOut:Play()
		else
			icon.AnimFrame:Hide()
		end
	end

	if type(icon.isHighlighted) == "table" then
		icon.isHighlighted:Cancel()
	end
	icon.isHighlighted = nil
end

function P:RemoveHighlight(icon)
	local guid = icon.guid
	local buff = icon.buff
	local info = self.groupInfo[guid]

	if not info or not info.glowIcons[buff] then
		return
	end

	info.glowIcons[buff] = nil

	self:HideOverlayGlow(icon)


	local active = icon.active and info.active[icon.spellID]
	if active then
		if info.preactiveIcons[icon.spellID] then
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)
		end

		self:SetCooldownElements(icon, active.charges)
		if E.OmniCC then
			icon.cooldown:SetCooldown(active.startTime, active.duration, active.iconModRate)
		end
		icon.icon:SetDesaturated(E.db.icons.desaturateActive and (not active.charges or active.charges == 0))
	end
end

function P:HighlightIcon(icon, isRefresh)
	if not E.db.highlight.glowBuffs or not E.db.highlight.glowBuffTypes[icon.type] then
		return
	end

	local buff = icon.buff
	if buff == 0 then
		return
	end

	local info = self.groupInfo[icon.guid]
	local unit = info.unit
	local duration = info and self:GetBuffDuration(unit, buff)

	if duration then
		if E.buffFixNoCLEU[buff] and (not E.isBFA or not self.isInArena) then
			info.bar:RegisterUnitEvent('UNIT_AURA', unit)
		end

		ShowOverlayGlow(icon, duration, isRefresh)

		self:SetCooldownElements(icon, nil)

		info.glowIcons[buff] = icon

		return true
	end
end

function P:SetGlow(icon)
	icon.AnimFrame.animIn:Play()
end

E.GetOverlayGlow = GetOverlayGlow
