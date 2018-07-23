--[[
	pulse.lua
		a pulsing finish effect
--]]

local L = OMNICC_LOCALS
local PULSE_SCALE = 2.5
local PULSE_DURATION = 0.6

local Pulse = LibStub('Classy-1.0'):New('Frame')
Pulse.name = L.Pulse
Pulse.desc = L.PulseTip
Pulse.id = 'pulse'
Pulse.active = {}


--[[ Run ]]--

function Pulse:Run(cooldown)
	if self.active[cooldown] then
		local button = cooldown:GetParent()
		local icon = OmniCC:GetButtonIcon(button)
		
		if icon then
			self.active[cooldown]:Start(icon)
		end
	end
end

function Pulse:Start(texture)
	if self.animation:IsPlaying() then
		self.animation:Stop()
	end

	local icon = self.icon
	local r, g, b = icon:GetVertexColor()
	icon:SetVertexColor(r, g, b, 0.7)
	icon:SetTexture(texture:GetTexture())

	self:Show()
	self.animation:Play()
end


--[[ Setup ]]--

function Pulse:Setup(cooldown)
	if self.active[cooldown] then
		return
	end
	
	local parent = cooldown:GetParent()
	if parent then
		local pulse = self:Bind(CreateFrame('Frame', nil, parent))
		pulse:Hide()
		pulse:SetAllPoints(parent)
		pulse:SetToplevel(true)
		pulse:SetScript('OnHide', pulse.OnHide)

		local icon = pulse:CreateTexture(nil, 'OVERLAY')
		icon:SetBlendMode('ADD')
		icon:SetAllPoints()
	
		pulse.animation = pulse:CreatePulseAnimation()
		pulse.icon = icon
	
		self.active[cooldown] = pulse
	end
end

do
	local function animation_OnFinished(self)
		local parent = self:GetParent()
		if parent:IsShown() then
			parent:Hide()
		end
	end
	
	local function scale_OnFinished(self)
		if self.reverse then
			self.reverse = nil
			self:GetParent():Finish()
		else
			self.reverse = true
		end
	end

	function Pulse:CreatePulseAnimation()
		local g = self:CreateAnimationGroup()
		g:SetLooping('BOUNCE')
		g:SetScript('OnFinished', animation_OnFinished)

		local grow = g:CreateAnimation('Scale')
		grow:SetScript('OnFinished', scale_OnFinished)
		grow:SetScale(PULSE_SCALE, PULSE_SCALE)
		grow:SetDuration(PULSE_DURATION/2)
		grow:SetOrigin('CENTER', 0, 0)
		grow:SetOrder(0)

		return g
	end
end

function Pulse:OnHide()
	if self.animation:IsPlaying() then
		self.animation:Stop()
	end
	self:Hide()
end

OmniCC:RegisterEffect(Pulse)