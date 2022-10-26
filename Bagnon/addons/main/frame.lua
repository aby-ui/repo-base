--[[
	frame.lua
		The window frame object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Frame

Frame.ItemGroup = Addon.ItemGroup
Frame.BagGroup = Addon.BagGroup
Frame.MoneyFrame = Addon.MoneyFrame
Frame.BrokerSpacing = 2
Frame.MoneySpacing = 8


--[[ Construct ]]--

function Frame:New(id)
	local f = self:Super(Frame):New(UIParent)
	f.frameID, f.quality = id, 0
	f.profile = f:GetBaseProfile()

	f.SearchFrame = Addon.SearchFrame(f)
	f.Title = Addon.Title(f, f.Title)
	f.ItemGroup = self.ItemGroup(f, f.Bags)
	f.CloseButton = CreateFrame('Button', nil, f, 'UIPanelCloseButtonNoScripts')
	f.CloseButton:SetScript('OnClick', function() Addon.Frames:Hide(f.frameID, true) end)
	f.CloseButton:SetPoint('TOPRIGHT', -2, -2)

	f:Hide()
	f:FindRules()
	f:SetMovable(true)
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetBackdrop {
	  bgFile = 'Interface/ChatFrame/ChatFrameBackground',
	  edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
		insets = {left = 4, right = 4, top = 4, bottom = 4},
		tile = true, tileSize = 16,
	  edgeSize = 16,
	}

	tinsert(UISpecialFrames, f:GetName())
	return f
end

function Frame:RegisterSignals()
	self:RegisterSignal('UPDATE_ALL', 'Update')
	self:RegisterSignal('RULES_LOADED', 'FindRules')
	self:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'Layout')
	self:RegisterFrameSignal('ELEMENT_RESIZED', 'Layout')
	self:Update()
end


--[[ Update ]]--

function Frame:Update()
	self.profile = self:GetBaseProfile()
	self:UpdateAppearance()
	self:UpdateBackdrop()
	self:Layout()
end

function Frame:UpdateBackdrop()
	local back = self.profile.color
	local border = self.profile.borderColor

	self:SetBackdropColor(back[1], back[2], back[3], back[4])
	self:SetBackdropBorderColor(border[1], border[2], border[3], border[4])
end

function Frame:Layout()
	local width, height = 44, 36
	local grow = function(w, h)
		width = max(width, w)
		height = height + h
	end

	--place top menu frames
	width = width + self:PlaceMenuButtons()
	width = width + self:PlaceOptionsToggle()
	width = width + self:PlaceTitle()
	self:PlaceSearchBar()

	--place middle content frames
	grow(self:PlaceBagGroup())
	grow(self:PlaceItemGroup())

	--place bottom display frames
	grow(self:PlaceMoney())
	grow(self:PlaceCurrencies(width, height))
	self:PlaceBrokerCarrousel(width, height)

	--adjust size
	self:SetSize(max(width, 156) + 16, height)
end


--[[ Essentials ]]--

function Frame:PlaceTitle()
	local frame = self.Title
	local menuButtons = self.menuButtons
	local w, h = 0, 0

	frame:ClearAllPoints()
	if #menuButtons > 0 then
		frame:SetPoint('LEFT', menuButtons[#menuButtons], 'RIGHT', 4, 0)
		w = frame:GetTextWidth() / 2 + 4
		h = 20
	else
		frame:SetPoint('TOPLEFT', self, 'TOPLEFT', 8, -8)
		w = frame:GetTextWidth() + 8
		h = 20
	end

	if self:HasOptionsToggle() then
		frame:SetPoint('RIGHT', self.OptionsToggle, 'LEFT', -4 - 20, 0)
	else
		frame:SetPoint('RIGHT', self.CloseButton, 'LEFT', -4 - 20, 0)
	end
	frame:SetHeight(20)

	return w, h
end

function Frame:PlaceItemGroup()
	local anchor = self:IsBagGroupShown() and self.bagGroup
					or #self.menuButtons > 0 and self.menuButtons[1]
					or self.Title

	self.ItemGroup:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -4)
	return self.ItemGroup:GetWidth() - 2, self.ItemGroup:GetHeight()
end


--[[ Menu Buttons ]]--

function Frame:PlaceMenuButtons()
	for i, button in pairs(self.menuButtons or {}) do
		button:Hide()
	end

	self.menuButtons = {}
	self:ListMenuButtons()

	for i, button in ipairs(self.menuButtons) do
		button:ClearAllPoints()
		if i == 1 then
			button:SetPoint('TOPLEFT', self, 'TOPLEFT', 8, -8)
		else
			button:SetPoint('TOPLEFT', self.menuButtons[i-1], 'TOPRIGHT', 4, 0)
		end
		button:Show()
	end

	return 20 * #self.menuButtons, 20
end

function Frame:ListMenuButtons()
	if self:HasOwnerSelector() then
		tinsert(self.menuButtons, self.ownerSelector or self:CreateOwnerSelector())
	end

	if self:HasBagToggle() then
		tinsert(self.menuButtons, self.bagToggle or self:CreateBagToggle())
	end

	if self:HasSortButton() then
		tinsert(self.menuButtons, self.sortButton or self:CreateSortButton())
	end

	if self:HasSearchToggle() then
		tinsert(self.menuButtons, self.searchToggle or self:CreateSearchToggle())
	end
end

function Frame:HasOwnerSelector()
	return Addon.Owners:MultipleFound()
end

function Frame:HasSearchToggle()
	return self.profile.search
end

function Frame:HasBagToggle()
	return self.profile.bagToggle
end

function Frame:HasSortButton()
	return self.profile.sort
end

function Frame:CreateOwnerSelector()
	self.ownerSelector = Addon.OwnerSelector(self)
	return self.ownerSelector
end

function Frame:CreateSearchToggle()
	self.searchToggle = Addon.SearchToggle(self)
	return self.searchToggle
end

function Frame:CreateBagToggle()
	self.bagToggle = Addon.BagToggle(self)
	return self.bagToggle
end

function Frame:CreateSortButton()
	self.sortButton = Addon.SortButton(self)
	return self.sortButton
end


--[[ Remainder Top ]]--

function Frame:PlaceSearchBar()
	local frame, menuButtons = self.SearchFrame, self.menuButtons
	frame:ClearAllPoints()

	if #menuButtons > 0 then
		frame:SetPoint('LEFT', menuButtons[#menuButtons], 'RIGHT', 2, 0)
	else
		frame:SetPoint('TOPLEFT', self, 'TOPLEFT', 8, -8)
	end

	if self:HasOptionsToggle() then
		frame:SetPoint('RIGHT', self.OptionsToggle, 'LEFT', -2, 0)
	else
		frame:SetPoint('RIGHT', self.CloseButton, 'LEFT', -2, 0)
	end

	frame:SetHeight(28)
end

function Frame:PlaceOptionsToggle()
	if self:HasOptionsToggle() then
		self.OptionsToggle = self.OptionsToggle or Addon.OptionsToggle(self)
		self.OptionsToggle:ClearAllPoints()
		self.OptionsToggle:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -32, -8)
		self.OptionsToggle:Show()

		return self.OptionsToggle:GetWidth(), self.OptionsToggle:GetHeight()
	elseif self.OptionsToggle then
		self.OptionsToggle:Hide()
	end

	return 0,0
end

function Frame:HasOptionsToggle()
	return GetAddOnEnableState(UnitName('player'), ADDON .. '_Config') >= 2 and self.profile.options
end


--[[ Bag Frame ]]--

function Frame:PlaceBagGroup()
	if self:IsBagGroupShown() then
		local frame = self.bagGroup or self:CreateBagGroup()
		frame:ClearAllPoints()
		frame:Show()

		local menuButtons = self.menuButtons
		if #menuButtons > 0 then
			frame:SetPoint('TOPLEFT', menuButtons[1], 'BOTTOMLEFT', 0, -4)
		else
			frame:SetPoint('TOPLEFT', self.Title, 'BOTTOMLEFT', 0, -4)
		end

		return frame:GetWidth(), frame:GetHeight() + 4
	elseif self.bagGroup then
		self.bagGroup:Hide()
	end

	return 0, 0
end

function Frame:CreateBagGroup()
	self.bagGroup = self.BagGroup(self, 'LEFT', 36, 0)
	return self.bagGroup
end

function Frame:IsBagGroupShown()
	return self:GetProfile().showBags
end


--[[ Bottom Displays ]]--

function Frame:PlaceMoney()
	if self:HasMoney() then
		self.Money = self.Money or self.MoneyFrame(self)
		self.Money:SetPoint('TOPRIGHT', self.ItemGroup, 'BOTTOMRIGHT', self.MoneySpacing, 0)
		self.Money:Show()

		return self.Money:GetSize()
	elseif self.Money then
		self.Money:Hide()
	end
	return 0,0
end

function Frame:PlaceCurrencies(width)
	if self:HasCurrencies() then
		self.Currency = self.Currency or Addon.CurrencyTracker(self)
		self.Currency:ClearAllPoints()
		self.Currency:Show()

		if self:HasMoney() and self.Currency:GetWidth() < (width - self.Money:GetWidth() - (self:HasBrokerCarrousel() and 24 or 2)) then
			self.Currency:SetPoint('TOPLEFT', self.ItemGroup, 'BOTTOMLEFT')
		else
			self.Currency:SetPoint('TOPRIGHT', self:HasMoney() and self.Money or self, 'BOTTOMRIGHT', -7,0)
			return self.Currency:GetSize()
		end
	elseif self.Currency then
		self.Currency:Hide()
	end
	return 0,0
end

function Frame:PlaceBrokerCarrousel()
	if self:HasBrokerCarrousel() then
		local right = self:HasMoney() and {'RIGHT', self.Money, 'LEFT', -5, self.BrokerSpacing} or
																			{'BOTTOMRIGHT', self, 'BOTTOMRIGHT', -4,4}
		local left = self:HasCurrencies() and self.Currency:GetPoint(1) == 'TOPLEFT' and
																			{'LEFT', self.Currency, 'RIGHT', -2,0} or
																			{'TOPLEFT', self.ItemGroup, 'BOTTOMLEFT', 0, self.BrokerSpacing}

		self.Broker = self.Broker or Addon.BrokerCarrousel(self)
		self.Broker:ClearAllPoints()
		self.Broker:SetPoint(unpack(right))
		self.Broker:SetPoint(unpack(left))
		self.Broker:Show()
		return 48, 24
	elseif self.Broker then
		self.Broker:Hide()
	end
	return 0, 0
end

function Frame:HasMoney()
	return self.profile.money
end

function Frame:HasCurrencies()
	return self.profile.currency and BackpackTokenFrame
end

function Frame:HasBrokerCarrousel()
	return self.profile.broker
end
