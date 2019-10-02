--[[
	moneyFrame.lua
		A money frame object
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local MoneyFrame = Addon:NewClass('GuildMoneyFrame', 'Frame', Addon.MoneyFrame)
MoneyFrame.Type = 'GUILDBANK'


--[[ Update ]]--

function MoneyFrame:RegisterEvents()
	self:RegisterEvent('GUILDBANK_UPDATE_MONEY', 'Update')
	self:Update()
end

function MoneyFrame:GetMoney()
	return GetGuildBankMoney()
end


--[[ Frame Events ]]--

function MoneyFrame:OnClick(button)
	if self:IsCached() then
		return
	end

	local money = GetCursorMoney() or 0
	if money > 0 then
		DepositGuildBankMoney(money)
		DropCursorMoney()

	elseif button == 'LeftButton' and not IsShiftKeyDown() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		StaticPopup_Hide('GUILDBANK_WITHDRAW')

		if StaticPopup_Visible('GUILDBANK_DEPOSIT') then
			StaticPopup_Hide('GUILDBANK_DEPOSIT')
		else
			StaticPopup_Show('GUILDBANK_DEPOSIT')
		end
	elseif CanWithdrawGuildBankMoney() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		StaticPopup_Hide('GUILDBANK_DEPOSIT')

		if StaticPopup_Visible('GUILDBANK_WITHDRAW') then
			StaticPopup_Hide('GUILDBANK_WITHDRAW')
		else
			StaticPopup_Show('GUILDBANK_WITHDRAW')
		end
	end
end

function MoneyFrame:OnEnter()
	GameTooltip:SetOwner(self, self:GetTop() > (GetScreenHeight() / 2) and 'ANCHOR_BOTTOM' or 'ANCHOR_TOP')
	GameTooltip:SetText(L.GuildFunds)
	GameTooltip:AddLine(L.TipDeposit:format(L.LeftClick), 1, 1, 1)

	if CanWithdrawGuildBankMoney() then
		local money = min(GetGuildBankWithdrawMoney(), GetGuildBankMoney())
		GameTooltip:AddLine(L.TipWithdraw:format(L.RightClick, money > 0 and GetMoneyString(money, true) or NONE:lower()), 1,1,1)
	end

	GameTooltip:Show()
end

function MoneyFrame:OnLeave()
	if GameTooltip:IsOwned(self) then
		GameTooltip:Hide()
	end
end
