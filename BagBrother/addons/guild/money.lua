--[[
	moneyFrame.lua
		A money frame object
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Money = Addon.MoneyFrame:NewClass('GuildMoneyFrame')
Money.Type = 'GUILDBANK'

local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Sushi = LibStub('Sushi-3.1')

function Money:RegisterEvents()
	self:RegisterEvent('GUILDBANK_UPDATE_MONEY', 'Update')
	self:Update()
end

function Money:OnClick(button)
	if self:IsCached() then return end

	local money = GetCursorMoney() or 0
	if money > 0 then
		DepositGuildBankMoney(money)
		DropCursorMoney()

	elseif button == 'LeftButton' and not IsShiftKeyDown() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		Sushi.Popup:Hide('GUILDBANK_WITHDRAW')
		Sushi.Popup:Toggle('GUILDBANK_DEPOSIT')
	elseif CanWithdrawGuildBankMoney() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		Sushi.Popup:Hide('GUILDBANK_DEPOSIT')
		Sushi.Popup:Toggle('GUILDBANK_WITHDRAW')
	end
end

function Money:OnEnter()
	GameTooltip:SetOwner(self, self:GetTop() > (GetScreenHeight() / 2) and 'ANCHOR_BOTTOM' or 'ANCHOR_TOP')
	GameTooltip:SetText(L.GuildFunds)
	GameTooltip:AddLine(L.TipDeposit:format(L.LeftClick), 1, 1, 1)

	if CanWithdrawGuildBankMoney() then
		local money = min(GetGuildBankWithdrawMoney(), GetGuildBankMoney())
		GameTooltip:AddLine(L.TipWithdraw:format(L.RightClick, money > 0 and GetMoneyString(money, true) or NONE:lower()), 1,1,1)
	end

	GameTooltip:Show()
end
