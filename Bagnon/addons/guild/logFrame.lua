--[[
	itemGroup.lua
		A guild bank tab log messages scrollframe
--]]

local MODULE = ...
local ADDON, Addon = MODULE:match('[^_]+'), _G[MODULE:match('[^_]+')]
local Log = Addon.Parented:NewClass('LogFrame', 'ScrollingMessageFrame')

local MESSAGE_PREFIX, _ = '|cff009999   '
local MAX_TRANSACTIONS = 22


--[[ Construct ]]--

function Log:New(parent)
	local f = self:Super(Log):New(parent)
	f:RegisterFrameSignal('LOG_SELECTED', 'OnLogSelected')
	f:SetScript('OnHyperlinkClick', f.OnHyperlink)
	f:SetMaxLines(MAX_TRANSACTIONS)
	f:SetFontObject(GameFontHighlight)
	f:SetJustifyH('LEFT')
	f:SetFading(false)
	return f
end


--[[ Events ]]--

function Log:OnLogSelected(_, logID)
	if logID == 1 or logID == 2 then
		self.isMoney = logID == 2
		self:RegisterSignal('GUILD_TAB_CHANGED', 'Update')
		self:RegisterEvent('GUILDBANKLOG_UPDATE', 'UpdateContent')
		self:Update()
	else
		self:UnregisterSignal('GUILD_TAB_CHANGED')
		self:UnregisterEvent('GUILDBANKLOG_UPDATE')
	end
end

function Log:OnHyperlink(...)
	SetItemRef(...)
end


--[[ Update ]]--

function Log:Update()
	if self.isMoney then
		QueryGuildBankLog(MAX_GUILDBANK_TABS + 1)
	else
		QueryGuildBankLog(GetCurrentGuildBankTab())
	end

	self:UpdateContent()
end

function Log:UpdateContent()
	self.numTransactions = self.isMoney and GetNumGuildBankMoneyTransactions() or GetNumGuildBankTransactions(GetCurrentGuildBankTab())
	self.oldestTransaction = max(self.numTransactions - MAX_TRANSACTIONS, 1)
	self:Clear()

	if self.isMoney then
		self:PrintMoney()
	else
		self:PrintTransactions()
	end

	for i = self.numTransactions, MAX_TRANSACTIONS do
		self:AddMessage(' ')
	end
end


--[[ Write ]]--

function Log:PrintTransactions()
	for i = self.numTransactions, self.oldestTransaction, -1 do
		local type, name, itemLink, count, tab1, tab2, year, month, day, hour = self:ProcessLine(GetGuildBankTransaction(GetCurrentGuildBankTab(), i))
		local msg

		if type == 'deposit' then
			msg = format(GUILDBANK_DEPOSIT_FORMAT, name, itemLink)
			if count > 1 then
				msg = msg..format(GUILDBANK_LOG_QUANTITY, count)
			end
		elseif type == 'withdraw' then
			msg = format(GUILDBANK_WITHDRAW_FORMAT, name, itemLink)
			if count > 1 then
				msg = msg .. format(GUILDBANK_LOG_QUANTITY, count)
			end
		elseif type == 'move' then
			msg = format(GUILDBANK_MOVE_FORMAT, name, itemLink, count, GetGuildBankTabInfo(tab1), GetGuildBankTabInfo(tab2))
		end

		self:AddLine(msg, year, month, day, hour)
	end
end

function Log:PrintMoney()
	for i = self.numTransactions, self.oldestTransaction, -1 do
		local type, name, amount, year, month, day, hour = self:ProcessLine(GetGuildBankMoneyTransaction(i))
		local money = GetDenominationsFromCopper(amount)

		local msg
		if type == 'deposit' then
			msg = format(GUILDBANK_DEPOSIT_MONEY_FORMAT, name, money)
		elseif type == 'withdraw' then
			msg = format(GUILDBANK_WITHDRAW_MONEY_FORMAT, name, money)
		elseif type == 'repair' then
			msg = format(GUILDBANK_REPAIR_MONEY_FORMAT, name, money)
		elseif type == 'withdrawForTab' then
			msg = format(GUILDBANK_WITHDRAWFORTAB_MONEY_FORMAT, name, money)
		elseif type == 'buyTab' then
			msg = amount > 0 and GUILDBANK_BUYTAB_MONEY_FORMAT:format(name, money) or GUILDBANK_UNLOCKTAB_FORMAT:format(name)
		elseif type == 'depositSummary' then
			msg = format(GUILDBANK_AWARD_MONEY_SUMMARY_FORMAT, money)
		end

		self:AddLine(msg, year, month, day, hour)
	end
end

function Log:AddLine(msg, ...)
	if msg then
		self:AddMessage(msg .. MESSAGE_PREFIX .. format(GUILD_BANK_LOG_TIME, RecentTimeDate(...)))
	end
end

function Log:ProcessLine(type, name, ...)
	return type, NORMAL_FONT_COLOR_CODE .. (name or UNKNOWN) .. FONT_COLOR_CODE_CLOSE, ...
end
