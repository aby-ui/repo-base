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

function Tab:GetSlot()
	return 'guild' .. self:GetID()
end


--[[ Interaction ]]--

function Tab:OnClick()
	local tab = self:GetID()
	local _,_, viewable = self:GetInfo()

	if viewable then
		SetCurrentGuildBankTab(tab)
		QueryGuildBankTab(tab)
		self:SendMessage('GUILD_TAB_CHANGED')
	end

	self:SetChecked(viewable)
end

--[[ Update ]]--

function Tab:RegisterEvents()
	self:UnregisterEvents()
	self:Update()

	if self:IsCached() then
		self:RegisterMessage('GUILD_TAB_CHANGED', 'UpdateStatus')
	else
		self:RegisterEvent('GUILDBANK_UPDATE_TABS', 'Update')
		self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', 'UpdateStatus')
	end
end

function Tab:Update()
	local name, icon, viewable = self:GetInfo()
	if icon then
		local color = viewable and 1 or 0.1

		self.Icon:SetTexture(tonumber(icon) or icon)
		self.Icon:SetVertexColor(1, color, color)
		self.Icon:SetDesaturated(not viewable)
		self:UpdateStatus()
	end

	self:EnableMouse(icon)
	self:SetAlpha(icon and 1 or 0)
end

function Tab:UpdateStatus()
	self:SetChecked(self:GetID() == GetCurrentGuildBankTab())

	local _,_,_,_,_, numWithdrawals, cached = self:GetInfo()
	if self:GetChecked() and not cached then
		self.Count:SetText(numWithdrawals >= 0 and numWithdrawals or '∞')
	end
end

function Tab:UpdateTooltip()
	local name, icon, _, canDeposit, numWithdrawals = self:GetInfo()
	if name then
		GameTooltip:SetText(name)

		local access
		if not canDeposit and numWithdrawals == 0 then
			access = RED_FONT_COLOR_CODE .. "(" .. GUILDBANK_TAB_LOCKED .. ")" .. FONT_COLOR_CODE_CLOSE;
		elseif not canDeposit then
			access = RED_FONT_COLOR_CODE .."(" .. GUILDBANK_TAB_WITHDRAW_ONLY .. ")" .. FONT_COLOR_CODE_CLOSE;
		elseif numWithdrawals == 0 then
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
