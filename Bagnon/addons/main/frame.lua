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
Frame.BrokerSpacing = 1
Frame.MoneySpacing = 0


--[[ Construct ]]--

function Frame:New(id)
	local f = self:Super(Frame):New(UIParent)
	f.frameID, f.quality = id, 0
	f.profile = f:GetBaseProfile()
	f.searchFrame = Addon.SearchFrame(f)
	f.title = Addon.Title(f, f.Title)
	f.itemGroup = self.ItemGroup(f, f.Bags)

	f.closeButton = CreateFrame('Button', nil, f, 'UIPanelCloseButtonNoScripts')
	f.closeButton:SetScript('OnClick', function() Addon.Frames:Hide(f.frameID, true) end)
	f.closeButton:SetPoint('TOPRIGHT', -2, -2)

	f:Hide()
	f:FindRules()
	f:SetMovable(true)
	f:SetToplevel(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:SetScript('OnShow', self.OnShow)
	f:SetScript('OnHide', self.OnHide)
	f:SetBackdrop{
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
	local width, height = 44, 36

	--place top menu frames
	width = width + self:PlaceMenuButtons()
	width = width + self:PlaceOptionsToggle()
	width = width + self:PlaceTitle()
	self:PlaceSearchFrame()

	--place middle frames
	local w, h = self:PlaceBagGroup()
	width = max(w, width)
	height = height + h

	local w, h = self:PlaceItemGroup()
	width = max(w, width)
	height = height + h

	--place bottom menu frames
	local w, h = self:PlaceMoneyFrame()
	width = max(w, width)
	height = height + h

	local w, h = self:PlaceBrokerDisplayFrame()
	if not self:HasMoneyFrame() then
		height = height + h
	end

	--adjust size
	self:SetSize(max(width, 156) + 16, height)
	--self:SetWidth(max(max(width, 156), self.itemGroup:GetWidth() - 2) + 16)
	--self:SetHeight(height + self.itemGroup:GetHeight())
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


-- search frame
function Frame:PlaceSearchFrame()
	local frame, menuButtons = self.searchFrame, self.menuButtons
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
	return frame:GetSize()
end

function Frame:CreateSearchFrame()
	self.searchFrame = Addon.SearchFrame(self)
	return self.searchFrame
end


-- bag frame
function Frame:PlaceBagGroup()
	if self:IsBagGroupShown() then
		local frame = self.bagGroup or self:CreateBagGroup()
		frame:ClearAllPoints()
		frame:Show()

		local menuButtons = self.menuButtons
		if #menuButtons > 0 then
			frame:SetPoint('TOPLEFT', menuButtons[1], 'BOTTOMLEFT', 0, -4)
		else
			frame:SetPoint('TOPLEFT', self.title, 'BOTTOMLEFT', 0, -4)
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


-- mandatories
function Frame:PlaceTitle()
	local frame = self.title
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

function Frame:PlaceItemGroup()
	local anchor = self:IsBagGroupShown() and self.bagGroup
					or #self.menuButtons > 0 and self.menuButtons[1]
					or self.title

	self.itemGroup:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -4)
	return self.itemGroup:GetWidth() - 2, self.itemGroup:GetHeight()
end


-- money frame
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
	self.moneyFrame = self.MoneyFrame(self)
	return self.moneyFrame
end

function Frame:HasMoneyFrame()
	return self.profile.money
end


-- databroker display
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
	self.brokerDisplay = Addon.BrokerDisplay(self)
	return self.brokerDisplay
end

function Frame:HasBrokerDisplay()
	return self.profile.broker
end


-- options toggle
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

function Frame:CreateOptionsToggle()
	self.optionsToggle = Addon.OptionsToggle(self)
	return self.optionsToggle
end

function Frame:HasOptionsToggle()
	return GetAddOnEnableState(UnitName('player'), ADDON .. '_Config') >= 2 and self.profile.options
end
