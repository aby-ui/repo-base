--[[
	currencyTracker.lua
		Shows tracked currencies
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local CurrencyTracker = Addon.Parented:NewClass('CurrencyTracker', 'Frame')

if BackpackTokenFrame then
	function BackpackTokenFrame:GetMaxTokensWatched() return 30 end
end


--[[ Construct ]]--

function CurrencyTracker:New(parent)
	local f = self:Super(CurrencyTracker):New(parent)
	f.buttons = {}
	f:SetScript('OnShow', f.RegisterEvents)
	f:SetScript('OnHide', f.UnregisterAll)
	f:RegisterEvents()
  f:SetHeight(24)

  hooksecurefunc(SetCurrencyBackpack and _G or C_CurrencyInfo, 'SetCurrencyBackpack', function()
    if f:IsVisible() then
        f:Update()
    end
  end)
	return f
end

function CurrencyTracker:RegisterEvents()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'Update')
	self:RegisterFrameSignal('OWNER_CHANGED', 'Layout')
	self:Layout()
end


--[[ Update ]]--

function CurrencyTracker:Update()
	self:Layout()
	self:SendFrameSignal('ELEMENT_RESIZED')
end

local function getCurrency(i) -- temporary till bagbrother expansion
	if GetBackpackCurrencyInfo then
		local name, quantity, icon, id = GetBackpackCurrencyInfo(i)
		return name and {
			name = name, quantity = quantity, iconFileID = icon, currencyTypesID = id,
			iconArgs = tContains(HONOR_POINT_TEXTURES, icon) and ':64:64:0:40:0:40'}
	else
		return C_CurrencyInfo.GetBackpackCurrencyInfo(i)
	end
end

function CurrencyTracker:Layout()
	for _,button in ipairs(self.buttons) do
		button:Hide()
	end

	local w = 0
	for i = 1, BackpackTokenFrame:GetMaxTokensWatched() do -- safety limit
		local data = getCurrency(i)
    if data then
			self.buttons[i] = self.buttons[i] or Addon.Currency(self)
			self.buttons[i]:SetPoint('LEFT', self.buttons[i-1] or self, i > 1 and 'RIGHT' or 'LEFT')
			self.buttons[i]:Set(data)

			w = w + self.buttons[i]:GetWidth()
		else
			break
    end
  end

	self:SetWidth(max(w, 2))
end
