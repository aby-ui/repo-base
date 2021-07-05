local E, L, C = select(2, ...):unpack()

local tremove = table.remove
local tinsert = table.insert
local P = E["Party"]

local unusedOverlayGlows = {}
local numOverlays = 0

local function GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows)
	if not overlay then
		numOverlays = numOverlays + 1
		overlay = CreateFrame("Frame", "OmniCDOverlayGlow".. numOverlays, UIParent, "OmniCDButtonSpellActivationAlert") -- [65]
	end

	return overlay
end
E.GetOverlayGlow = GetOverlayGlow

local function ShowOverlayGlowNoAnim(frame)
	local frameWidth, frameHeight = frame:GetSize()
	frame.spark:SetSize(frameWidth, frameHeight)
	frame.spark:SetAlpha(0)
	frame.innerGlow:SetSize(frameWidth, frameHeight)
	frame.innerGlow:SetAlpha(0)
	frame.innerGlowOver:SetAlpha(0)
	frame.outerGlow:SetSize(frameWidth, frameHeight)
	frame.outerGlow:SetAlpha(1.0)
	frame.outerGlowOver:SetAlpha(0)
	frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
	frame.ants:SetAlpha(1.0)
	frame:Show()
end

local removeHighlightByTimer = function(icon)
	local guid = icon.guid
	local info = P.groupInfo[icon.guid]
	if info and icon.isHighlighted then
		local duration = P:GetBuffDuration(info.unit, icon.buff) -- TODO: cancel timer
		if not duration then
			P:RemoveHighlight(icon)
		end
	end
end

local function ShowOverlayGlow(icon, d, isRefresh)
	if E.db.highlight.glowType == "wardrobe" then
		if not icon.isHighlighted then
			icon.isHilightRemoved = nil
			icon.PendingFrame:Show()
			if not isRefresh then
				icon.AnimFrame:Show()
				icon.AnimFrame.Anim:Play()
			end
		end
	elseif icon.overlay then
		if ( icon.overlay.animOut:IsPlaying() ) then
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
	icon.isHighlighted = true

	E.TimerAfter(d + 0.2, removeHighlightByTimer, icon)
end

function P:HideOverlayGlow(icon)
	if ( icon.overlay ) then
		if ( icon.overlay.animIn:IsPlaying() ) then
			icon.overlay.animIn:Stop()
		end

		if ( icon:IsVisible() ) then
			icon.overlay.animOut:Play()
		else
			OmniCD_OverlayGlowAnimOutFinished(icon.overlay.animOut)
		end
	elseif ( icon.isHighlighted ) then
		icon.PendingFrame:Hide()
		if ( icon:IsVisible() ) then
			icon.isHilightRemoved = true
			icon.AnimFrame:Show()
			icon.AnimFrame.Anim:Play()
		else
			icon.AnimFrame:Hide()
			icon.isHighlighted = nil
		end
	end
end

function OmniCD_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent()
	local icon = overlay:GetParent()
	overlay:Hide()
	tinsert(unusedOverlayGlows, overlay)
	icon.overlay = nil
	icon.isHighlighted = nil
end

function OmniCD_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
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

	-- End ResetAllIcons

	local active = icon.active and info.active[icon.spellID]
	if active then
		if info.preActiveIcons[icon.spellID] then -- [66]
			icon.icon:SetVertexColor(0.4, 0.4, 0.4)
		end

		self:SetCooldownElements(icon, active.charges)
		if E.OmniCC then -- [91]
			icon.cooldown:SetCooldown(active.startTime, active.duration, info.modRate)
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
		--if E.buffFixNoCLEU[buff] and (E.isBCC or not P.isInArena) then -- Patch 9.1 HSA removed
		if E.buffFixNoCLEU[buff] then
			local f = info.bar
			f:RegisterUnitEvent("UNIT_AURA", unit)
		end

		ShowOverlayGlow(icon, duration, isRefresh)

		self:SetCooldownElements(icon, nil, true)

		info.glowIcons[buff] = icon

		return true
	end
end

--[[
function P:SetGlow(icon)
	local flash = icon.flashAnim
	local newItemAnim = icon.newitemglowAnim
	if not flash:IsPlaying() and not newItemAnim:IsPlaying() then
		flash:Play()
		newItemAnim:Play()
	end
end
]]

