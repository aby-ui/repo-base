--[[
	frame.lua
		The window frame object
--]]

local ADDON, Addon = ...
local L = LibStub('AceLocale-3.0'):GetLocale(ADDON)
local Frame = Addon.Frame

Frame.ItemFrame = Addon.ItemFrame
Frame.BagFrame = Addon.BagFrame
Frame.MoneyFrame = Addon.MoneyFrame
Frame.BrokerSpacing = 1
Frame.MoneySpacing = 0


--[[ Constructor ]]--

function Frame:New(id)
	local f = self:Bind(CreateFrame('Frame', ADDON .. 'Frame' .. id, UIParent))
	f.frameID, f.quality = id, 0
	f.profile = f:GetBaseProfile()

	f:Hide()
	f:SetMovable(true)
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:FindRules()
	f:SetBackdrop{
	  bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
	  edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
	  edgeSize = 16,
	  tile = true, tileSize = 16,
	  insets = {left = 4, right = 4, top = 4, bottom = 4}
	}

	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)

	tinsert(UISpecialFrames, f:GetName())
	return f
end

function Frame:RegisterSignals()
	self:RegisterSignal('UPDATE_ALL', 'Update')
	self:RegisterSignal('RULES_LOADED', 'FindRules')
	self:RegisterFrameSignal('BAG_FRAME_TOGGLED', 'Layout')
	self:RegisterFrameSignal('ITEM_FRAME_RESIZED', 'Layout')
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
	local width, height = 24, 36

	--place top menu frames
	width = width + self:PlaceMenuButtons()
	width = width + self:PlaceCloseButton()
	width = width + self:PlaceOptionsToggle()
	width = width + self:PlaceTitleFrame()
	self:PlaceSearchFrame()

	--place middle frames
	local w, h = self:PlaceBagFrame()
	width = max(w, width)
	height = height + h
	self:PlaceItemFrame()

	--place bottom menu frames
	local w, h = self:PlaceMoneyFrame()
	width = max(w, width)
	height = height + h

	local w, h = self:PlaceBrokerDisplayFrame()
	if not self:HasMoneyFrame() then
		height = height + h
	end

	--adjust size
	self:SetWidth(max(max(width, 156), self.itemFrame:GetWidth() - 2) + 16)
	self:SetHeight(height + self.itemFrame:GetHeight())
end


-- menu buttons
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
	return Addon:MultipleOwnersFound()
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
	self.ownerSelector = Addon.OwnerSelector:New(self)
	return self.ownerSelector
end

function Frame:CreateSearchToggle()
	self.searchToggle = Addon.SearchToggle:New(self)
	return self.searchToggle
end

function Frame:CreateBagToggle()
	self.bagToggle = Addon.BagToggle:New(self)
	return self.bagToggle
end

function Frame:CreateSortButton()
	self.sortButton = Addon.SortButton:New(self)
	return self.sortButton
end


-- close button
function Frame:PlaceCloseButton()
	local b = self.closeButton or self:CreateCloseButton()
	b:ClearAllPoints()
	b:SetPoint('TOPRIGHT', -2, -2)
	b:Show()

	return 20, 20
end

function Frame:CreateCloseButton()
	local b = CreateFrame('Button', self:GetName() .. 'CloseButton', self, 'UIPanelCloseButton')
	b:SetScript('OnClick', function() Addon:HideFrame(self.frameID, true) end)
	self.closeButton = b
	return b
end


-- search frame
function Frame:PlaceSearchFrame()
	local menuButtons = self.menuButtons
	local frame = self.searchFrame or self:CreateSearchFrame()
	frame:ClearAllPoints()

	if #menuButtons > 0 then
		frame:SetPoint('LEFT', menuButtons[#menuButtons], 'RIGHT', 2, 0)
	else
		frame:SetPoint('TOPLEFT', self, 'TOPLEFT', 8, -8)
	end

	if self:HasOptionsToggle() then
		frame:SetPoint('RIGHT', self.optionsToggle, 'LEFT', -2, 0)
	else
		frame:SetPoint('RIGHT', self.closeButton, 'LEFT', -2, 0)
	end

	frame:SetHeight(28)

	return frame:GetWidth(), frame:GetHeight()
end

function Frame:CreateSearchFrame()
	local f = Addon.SearchFrame:New(self)
	self.searchFrame = f
	return f
end

-- bag frame
function Frame:CreateBagFrame()
	local f =  self.BagFrame:New(self, 'LEFT', 36, 0)
	self.bagFrame = f
	return f
end

function Frame:IsBagFrameShown()
	return self:GetProfile().showBags
end

function Frame:PlaceBagFrame()
	if self:IsBagFrameShown() then
		local frame = self.bagFrame or self:CreateBagFrame()
		frame:ClearAllPoints()
		frame:Show()

		local menuButtons = self.menuButtons
		if #menuButtons > 0 then
			frame:SetPoint('TOPLEFT', menuButtons[1], 'BOTTOMLEFT', 0, -4)
		else
			frame:SetPoint('TOPLEFT', self.titleFrame, 'BOTTOMLEFT', 0, -4)
		end

		return frame:GetWidth(), frame:GetHeight() + 4
	elseif self.bagFrame then
		self.bagFrame:Hide()
	end

	return 0, 0
end


-- title frame
function Frame:PlaceTitleFrame()
	local frame = self.titleFrame or self:CreateTitleFrame()
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
		frame:SetPoint('RIGHT', self.optionsToggle, 'LEFT', -4, 0)
	else
		frame:SetPoint('RIGHT', self.closeButton, 'LEFT', -4, 0)
	end
	frame:SetHeight(20)

	return w, h
end

function Frame:CreateTitleFrame()
	local f = Addon.TitleFrame:New(self.Title, self)
	self.titleFrame = f
	return f
end


-- item frame
function Frame:PlaceItemFrame()
	local anchor = self:IsBagFrameShown() and self.bagFrame
					or #self.menuButtons > 0 and self.menuButtons[1]
					or self.titleFrame

	local frame = self.itemFrame or self:CreateItemFrame()
	frame:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -4)
end

function Frame:CreateItemFrame()
	local f = self.ItemFrame:New(self, self.Bags)
	self.itemFrame = f
	return f
end


-- money frame
function Frame:HasMoneyFrame()
	return self.profile.money
end

function Frame:PlaceMoneyFrame()
	if self:HasMoneyFrame() then
		local frame = self.moneyFrame or self:CreateMoneyFrame()
		frame:ClearAllPoints()
		frame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -self.MoneySpacing, 4)
		frame:Show()

		return frame:GetSize()
	elseif self.moneyFrame then
		self.moneyFrame:Hide()
	end
	return 0, 0
end

function Frame:CreateMoneyFrame()
	local f = self.MoneyFrame:New(self)
	self.moneyFrame = f
	return f
end


-- databroker display
function Frame:HasBrokerDisplay()
	return self.profile.broker
end

function Frame:PlaceBrokerDisplayFrame()
	if self:HasBrokerDisplay() then
		local x, y = 4 * self.BrokerSpacing, 5 * self.BrokerSpacing
		local frame = self.brokerDisplay or self:CreateBrokerDisplay()
		frame:ClearAllPoints()
		frame:SetPoint('BOTTOMLEFT', self, 'BOTTOMLEFT', x, y)

		if self:HasMoneyFrame() then
			frame:SetPoint('RIGHT', self.moneyFrame, 'LEFT', -3, y)
		else
			frame:SetPoint('BOTTOMRIGHT', self, 'BOTTOMRIGHT', -x, y)
		end

		frame:Show()
		return frame:GetWidth(), 24
	elseif self.brokerDisplay then
		self.brokerDisplay:Hide()
	end

	return 0, 0
end

function Frame:CreateBrokerDisplay()
	local f = Addon.BrokerDisplay:New(self)
	self.brokerDisplay = f
	return f
end


-- options toggle
function Frame:CreateOptionsToggle()
	local f = Addon.OptionsToggle:New(self)
	self.optionsToggle = f
	return f
end

function Frame:PlaceOptionsToggle()
	if self:HasOptionsToggle() then
		local toggle = self.optionsToggle or self:CreateOptionsToggle()
		toggle:ClearAllPoints()
		toggle:SetPoint('TOPRIGHT', self, 'TOPRIGHT', -32, -8)
		toggle:Show()

		return toggle:GetWidth(), toggle:GetHeight()
	elseif self.optionsToggle then
		self.optionsToggle:Hide()
	end

	return 0,0
end

function Frame:HasOptionsToggle()
	return GetAddOnEnableState(UnitName('player'), ADDON .. '_Config') >= 2 and self.profile.options
end
