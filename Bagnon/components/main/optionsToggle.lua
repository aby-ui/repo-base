--[[
	optionsToggle.lua
		A options frame toggle widget
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local OptionsToggle = Addon:NewClass('OptionsToggle', 'Button')


--[[ Constructor ]]--

function OptionsToggle:New(parent)
	local b = self:Bind(CreateFrame('Button', nil, parent, ADDON .. 'MenuButtonTemplate'))
	b.Icon:SetTexture([[Interface\Icons\Trade_Engineering]])
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')

	return b
end


--[[ Interaction ]]--

function OptionsToggle:OnClick()
	if LoadAddOn(ADDON .. '_Config') then
		Addon.FrameOptions.frameID = self:GetFrameID()
		Addon.FrameOptions:Open()
	end
end

function OptionsToggle:OnEnter()
	GameTooltip:SetOwner(self, (self:GetRight() > (GetScreenWidth() / 2)) and 'ANCHOR_LEFT' or 'ANCHOR_RIGHT')
	GameTooltip:SetText(L.TipConfigure:format(L.Click))
end

function OptionsToggle:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
