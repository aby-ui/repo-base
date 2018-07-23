--[[
	playerSelector.lua
		A player selector button
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local PlayerSelector = Addon:NewClass('PlayerSelector', 'Button')


--[[ Constructor ]]--

function PlayerSelector:New(parent)
	local b = self:Bind(CreateFrame('Button', nil, parent, ADDON .. 'MenuButtonTemplate'))
	b:RegisterFrameMessage('PLAYER_CHANGED', 'Update')
	b:SetScript('OnClick', b.OnClick)
	b:SetScript('OnEnter', b.OnEnter)
	b:SetScript('OnLeave', b.OnLeave)
	b:SetScript('OnShow', b.Update)
	b:RegisterForClicks('anyUp')
	b:Update()

	return b
end


--[[ Frame Events ]]--

function PlayerSelector:OnClick(button)
	if button == 'RightButton' then
		self:GetFrame():SetPlayer(Addon.Cache.PLAYER)
	else
		Addon:TogglePlayerDropdown(self, self:GetFrame(), -4, -2)
	end
end

function PlayerSelector:OnEnter()
	if self:GetRight() > (GetScreenWidth() / 2) then
		GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
	else
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
	end

	local current = self:GetFrame():GetPlayer()
	GameTooltip:SetText(CHARACTER)
	GameTooltip:AddLine(L.TipChangePlayer, 1, 1, 1)
	GameTooltip:AddLine(L.TipResetPlayer, 1, 1, 1)
	GameTooltip:Show()
end

function PlayerSelector:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end


--[[ Update ]]--

function PlayerSelector:Update()
	self.Icon:SetTexture(Addon:GetPlayerIcon(self:GetPlayer()))
end
