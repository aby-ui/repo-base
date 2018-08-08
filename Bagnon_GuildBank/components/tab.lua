--[[
	tab.lua
		A tab button object
--]]

local MODULE =  ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local TabFrame = Addon:NewClass('GuildTabFrame', 'Frame', Addon.BagFrame)
local Tab = Addon:NewClass('GuildTab', 'CheckButton', Addon.Bag)
TabFrame.Button = Tab


--[[ Constructor ]]--

function Tab:New(...)
	local tab = Bagnon.Bag.New(self, ...)
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
	end

	self:SetChecked(viewable)
end

--[[ Update ]]--

function Tab:RegisterEvents()
	self:UnregisterSignals()
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
	self:SetChecked(self:GetID() == GetCurrentGuildBankTab())

	local info = self:GetInfo()
	if self:GetChecked() and not info.cached then
		self.Count:SetText(info.numWithdrawals >= 0 and info.numWithdrawals or '∞')
	end
end

function Tab:UpdateTooltip()
	local info = self:GetInfo()
	if info.name then
		GameTooltip:SetText(info.name)

		local access
		if not info.canDeposit and info.numWithdrawals == 0 then
			access = RED_FONT_COLOR_CODE .. "(" .. GUILDBANK_TAB_LOCKED .. ")" .. FONT_COLOR_CODE_CLOSE;
		elseif not info.canDeposit then
			access = RED_FONT_COLOR_CODE .."(" .. GUILDBANK_TAB_WITHDRAW_ONLY .. ")" .. FONT_COLOR_CODE_CLOSE;
		elseif info.numWithdrawals == 0 then
			access = RED_FONT_COLOR_CODE .."(" .. GUILDBANK_TAB_DEPOSIT_ONLY .. ")" .. FONT_COLOR_CODE_CLOSE;
		else
			access = GREEN_FONT_COLOR_CODE .. "(" .. GUILDBANK_TAB_FULL_ACCESS .. ")" .. FONT_COLOR_CODE_CLOSE;
		end

		GameTooltip:AddLine(access)
	else
		GameTooltip:SetText('Unavailable')
	end

	GameTooltip:Show()
end
