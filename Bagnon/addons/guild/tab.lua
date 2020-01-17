--[[
	tab.lua
		A tab button object
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local TabGroup = Addon.BagGroup:NewClass('GuildTabGroup')
local Tab = Addon.Bag:NewClass('GuildTab')
TabGroup.Button = Tab


--[[ Construct ]]--

function Tab:New(...)
	local tab = self:Super(Tab):New(...)
	tab:SetScript('OnReceiveDrag', nil)
	tab:SetScript('OnDragStart', nil)
	return tab
end


--[[ Interaction ]]--

function Tab:OnClick()
	local tab = self:GetID()
	local info = self:GetInfo()

	if info.viewable then
		SetCurrentGuildBankTab(tab)
		QueryGuildBankTab(tab)
		self:SendSignal('GUILD_TAB_CHANGED')
	else
		self:SetChecked(nil)
	end
end


--[[ Update ]]--

function Tab:RegisterEvents()
	self:UnregisterAll()
	self:Update()

	if self:IsCached() then
		self:RegisterSignal('GUILD_TAB_CHANGED', 'UpdateStatus')
	else
		self:RegisterEvent('GUILDBANK_UPDATE_TABS', 'Update')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'UpdateStatus')
	end
end

function Tab:Update()
	local info = self:GetInfo()
	if info.icon then
		local color = info.viewable and 1 or 0.1

		self.Icon:SetTexture(tonumber(info.icon) or info.icon)
		self.Icon:SetVertexColor(1, color, color)
		self.Icon:SetDesaturated(not info.viewable)
		self:UpdateStatus()
	end

	self:EnableMouse(info.icon)
	self:SetAlpha(info.icon and 1 or 0)
end

function Tab:UpdateStatus()
	local info = self:GetInfo()
	local remaining = info.remaining

	self:SetChecked(self:GetID() == GetCurrentGuildBankTab())
	self.Count:SetText(not info.viewable or not remaining and '' or remaining >= 0 and remaining or '∞')
end

function Tab:UpdateTooltip()
	local info = self:GetInfo()
	if info.name then
		GameTooltip:SetText(info.name)

		if not info.viewable or not info.deposit and info.withdraw == 0 then
			GameTooltip:AddLine(GUILDBANK_TAB_LOCKED, RED_FONT_COLOR:GetRGB())
		elseif not info.deposit and info.withdraw and info.withdraw > 0 then
			GameTooltip:AddLine(GUILDBANK_TAB_WITHDRAW_ONLY, HIGHLIGHT_FONT_COLOR:GetRGB())
		elseif info.withdraw == 0 then
			GameTooltip:AddLine(GUILDBANK_TAB_DEPOSIT_ONLY, HIGHLIGHT_FONT_COLOR:GetRGB())
		elseif info.withdraw then
			GameTooltip:AddLine(GUILDBANK_TAB_FULL_ACCESS, GREEN_FONT_COLOR:GetRGB())
		end

		local remaining = info.remaining
		if info.viewable and remaining and remaining >= 0 then
			GameTooltip:AddLine(L.NumRemainingWithdrawals:format(remaining > 0 and remaining or remaining == 0 and NONE or UNLIMITED), 1,1,1)
		end

		GameTooltip:Show()
	end
end
