--[[
	searchToggle.lua
		A searcn toggle widget
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local SearchToggle = Addon:NewClass('SearchToggle', 'CheckButton')


--[[ Constructor ]]--

function SearchToggle:New(parent)
	local b = self:Bind(CreateFrame('CheckButton', nil, parent, ADDON .. 'MenuCheckButtonTemplate'))
	b.Icon:SetTexture([[Interface\Icons\INV_Misc_Spyglass_03]])
	b:SetScript('OnHide', b.UnregisterSignals)
	b:SetScript('OnShow', b.OnShow)
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:RegisterForClicks('anyUp')

	return b
end


--[[ Events ]]--

function SearchToggle:OnShow()
	self:RegisterSignal('SEARCH_TOGGLED', 'OnToggle')
	self:OnToggle()
end

function SearchToggle:OnToggle()
	self:SetChecked(Addon.canSearch)
end

function SearchToggle:OnClick()
	Addon.canSearch = self:GetChecked()
	Addon:SendSignal('SEARCH_TOGGLED', self:GetChecked() and self:GetFrameID())
end

function SearchToggle:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	if self:GetChecked() then
		GameTooltip:SetText(L.TipHideSearch)
	else
		GameTooltip:SetText(L.TipShowSearch)
	end
end

function SearchToggle:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
