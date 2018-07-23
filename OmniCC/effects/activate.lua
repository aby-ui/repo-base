--[[
	activate.lua
		mimics the default effect that shows up when an ability "procs"
--]]


local L = OMNICC_LOCALS
local Activate = OmniCC:RegisterEffect {
	id = 'activate',
	name = L.Activate,
	desc = L.ActivateTip,
}

function Activate:Setup(cooldown)
	if self:Get(cooldown) then
		return
	end

	local button = cooldown:GetParent()
	local width, height = button:GetSize()
	local overlay = CreateFrame('Frame', '$parentOmniCCActivate', button, 'ActionBarButtonSpellActivationAlert')

	overlay:SetSize(width * 1.4, height * 1.4)
	overlay:SetFrameLevel(overlay:GetFrameLevel() + 5)
	overlay:SetPoint('TOPLEFT', button, 'TOPLEFT', -width * 0.2, height * 0.2)
	overlay:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', width * 0.2, -height * 0.2)
	overlay.animIn:HookScript('OnFinished', self.OnFinish)
	cooldown.omniccActivate = overlay
end

function Activate:Run(cooldown)
	local overlay = self:Get(cooldown)
	if overlay then
		if overlay.animOut:IsPlaying() then
			overlay.animOut:Stop()
		end

		overlay.animIn:Play()
	end
end

function Activate:OnFinish()
	self:Stop()
	self:GetParent().animOut:Play()
end

function Activate:Get(cooldown)
	return cooldown.omniccActivate
end