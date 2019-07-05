-- a pulse finish effect
local Addon = _G[...]
local L = _G.OMNICC_LOCALS
local PULSE_SCALE = 2.5
local PULSE_DURATION = 0.6

local Pulse = Addon.FX:Create("pulse", L.Pulse, L.PulseTip)

function Pulse:Run(cooldown)
	local parent = cooldown:GetParent()
	if parent:IsForbidden() then
		return
	end

	local icon = Addon:GetButtonIcon(parent)

	if parent and icon then
		self:Start(self:Get(parent) or self:Create(parent), icon)
	end
end

function Pulse:Start(pulse, icon)
	if pulse.animation:IsPlaying() then
		pulse.animation:Stop()
	end

	local r, g, b = icon:GetVertexColor()
	pulse.icon:SetVertexColor(r, g, b, 0.7)
	pulse.icon:SetTexture(icon:GetTexture())

	pulse:Show()
	pulse.animation:Play()
end

function Pulse:Get(owner)
	return self.effects and self.effects[owner]
end

do
	local function animation_OnFinished(self)
		local parent = self:GetParent()

		if parent:IsShown() then
			parent:Hide()
		end
	end

	local function pulseFrame_OnHide(self)
		if self.animation:IsPlaying() then
			self.animation:Stop()
		end

		self:Hide()
	end

	local function pulseFrame_CreateIcon(self)
		local icon = self:CreateTexture(nil, "OVERLAY")
		icon:SetBlendMode("ADD")
		icon:SetAllPoints(self)

		return icon
	end

	local function pulseFrame_CreateAnimation(self)
		local group = self:CreateAnimationGroup()
		group:SetScript("OnFinished", animation_OnFinished)

		local grow = group:CreateAnimation("Scale")
		grow:SetScale(PULSE_SCALE, PULSE_SCALE)
		grow:SetDuration(PULSE_DURATION/2)
		grow:SetOrder(1)

		local shrink = group:CreateAnimation("Scale")
		shrink:SetScale(-PULSE_SCALE, -PULSE_SCALE)
		shrink:SetDuration(PULSE_DURATION/2)
		shrink:SetOrder(2)

		return group
	end

	function Pulse:Create(owner)
		local pulse = Addon:CreateHiddenFrame("Frame", nil, owner)

		pulse:SetAllPoints(owner)
		pulse:SetToplevel(true)
		pulse:SetScript("OnHide", pulseFrame_OnHide)
		pulse.icon = pulseFrame_CreateIcon(pulse)
		pulse.animation = pulseFrame_CreateAnimation(pulse)

		local effects = self.effects
		if effects then
			effects[owner] = pulse
		else
			self.effects = { [owner] = pulse }
		end

		return pulse
	end
end
