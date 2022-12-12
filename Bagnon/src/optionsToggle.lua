--[[
	optionsToggle.lua
		A options frame toggle widget
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Toggle = Addon.Tipped:NewClass('OptionsToggle', 'Button', ADDON .. 'MenuButtonTemplate')


--[[ Construct ]]--

function Toggle:New(parent)
	local b = self:Super(Toggle):New(parent)
	b.Icon:SetTexture('Interface/Icons/Trade_Engineering')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')
	return b
end


--[[ Events ]]--

function Toggle:OnClick()
	if LoadAddOn(ADDON .. '_Config') then
		Addon.FrameOptions.frame = self:GetFrameID()
		Addon.FrameOptions:Open()
	end
end

function Toggle:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetText(L.TipConfigure:format(L.Click))
end
