--[[
	currency.lua
		A currency button
--]]



local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Currency = Addon.Tipped:NewClass('Currency', 'Button')

function Currency:New(parent)
	local b = self:Super(Currency):New(parent)
	b:SetNormalFontObject('NumberFontNormalRight')
	b:SetScript('OnClick', self.OnClick)
	b:SetScript('OnEnter', self.OnEnter)
	b:SetScript('OnLeave', self.OnLeave)
	b:SetHeight(24)
	return b
end

function Currency:Set(data)
	self:SetText(format('%s|T%s:14:14:2:0%s|t  ', data.quantity, data.iconFileID, data.iconArgs or ''))
	self.data = data
	self:Show()
  self:SetWidth(self:GetTextWidth() + 2)
end

function Currency:OnClick()
	if IsModifiedClick('CHATLINK') then
		HandleModifiedItemClick((GetCurrencyLink or C_CurrencyInfo.GetCurrencyLink)(self.data.currencyTypesID, self.data.quantity))
	elseif not self:IsCached() then
		ToggleCharacter('TokenFrame')
	end
end

function Currency:OnEnter()
	GameTooltip:SetOwner(self:GetTipAnchor())
	GameTooltip:SetCurrencyTokenByID(self.data.currencyTypesID)
end
