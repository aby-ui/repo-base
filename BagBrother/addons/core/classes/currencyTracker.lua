--[[
	currencyTracker.lua
		Shows tracked currencies
--]]

local ADDON, Addon = ...
local C = LibStub('C_Everywhere').CurrencyInfo
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

	C.hooksecurefunc('SetCurrencyBackpack', function()
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
	local data = C.GetBackpackCurrencyInfo(i)
	if data then
		data.iconArgs = HONOR_POINT_TEXTURES and tContains(HONOR_POINT_TEXTURES, data.iconFileID) and ':64:64:0:40:0:40'
		data.index = i
	end
	return data
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
