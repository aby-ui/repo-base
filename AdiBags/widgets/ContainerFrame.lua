--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local assert = _G.assert
local BACKPACK_CONTAINER = _G.BACKPACK_CONTAINER or ( Enum.BagIndex and Enum.BagIndex.Backpack ) or 0
local REAGENTBAG_CONTAINER = ( Enum.BagIndex and Enum.BagIndex.REAGENTBAG_CONTAINER ) or 5
local band = _G.bit.band
local BANK_CONTAINER = _G.BANK_CONTAINER or ( Enum.BagIndex and Enum.BagIndex.Bank ) or -1
local ceil = _G.ceil
local CreateFrame = _G.CreateFrame
local format = _G.format
local GetContainerFreeSlots = C_Container and _G.C_Container.GetContainerFreeSlots or _G.GetContainerFreeSlots
local GetContainerItemID = C_Container and _G.C_Container.GetContainerItemID or _G.GetContainerItemID
local GetContainerItemInfo = C_Container and _G.C_Container.GetContainerItemInfo or _G.GetContainerItemInfo
local GetContainerItemLink = C_Container and _G.C_Container.GetContainerItemLink or _G.GetContainerItemLink
local GetContainerNumFreeSlots = C_Container and _G.C_Container.GetContainerNumFreeSlots or _G.GetContainerNumFreeSlots
local GetContainerNumSlots = C_Container and _G.C_Container.GetContainerNumSlots or _G.GetContainerNumSlots
local GetCursorInfo = _G.GetCursorInfo
local GetItemInfo = _G.GetItemInfo
local GetItemGUID = _G.C_Item.GetItemGUID
local GetMerchantItemLink = _G.GetMerchantItemLink
local ipairs = _G.ipairs
local max = _G.max
local min = _G.min
local next = _G.next
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local NUM_REAGENTBAG_SLOTS = _G.NUM_REAGENTBAG_SLOTS
local NUM_TOTAL_EQUIPPED_BAG_SLOTS = _G.NUM_TOTAL_EQUIPPED_BAG_SLOTS
local pairs = _G.pairs
local PlaySound = _G.PlaySound
local select = _G.select
local strjoin = _G.strjoin
local strsplit = _G.strsplit
local tinsert = _G.tinsert
local tostring = _G.tostring
local tremove = _G.tremove
local tsort = _G.table.sort
local UIParent = _G.UIParent
local wipe = _G.wipe
--GLOBALS>

local GetSlotId = addon.GetSlotId
local GetBagSlotFromId = addon.GetBagSlotFromId
local GetItemFamily = addon.GetItemFamily
local BuildSectionKey = addon.BuildSectionKey
local SplitSectionKey = addon.SplitSectionKey

local ITEM_SIZE = addon.ITEM_SIZE
local ITEM_SPACING = addon.ITEM_SPACING
local SECTION_SPACING = addon.SECTION_SPACING
local BAG_INSET = addon.BAG_INSET
local HEADER_SIZE = addon.HEADER_SIZE

local BAG_IDS = addon.BAG_IDS

local LSM = LibStub('LibSharedMedia-3.0')

--------------------------------------------------------------------------------
-- Widget scripts
--------------------------------------------------------------------------------

local function BagSlotButton_OnClick(button)
	button.panel:SetShown(button:GetChecked())
end

--------------------------------------------------------------------------------
-- Bag creation
--------------------------------------------------------------------------------

local containerClass, containerProto, containerParentProto = addon:NewClass("Container", "LayeredRegion", "ABEvent-1.0")

function addon:CreateContainerFrame(...) return containerClass:Create(...) end

local SimpleLayeredRegion = addon:GetClass("SimpleLayeredRegion")

local bagSlots = {}

function containerProto:OnCreate(name, isBank, bagObject)
	self:SetParent(UIParent)
	containerParentProto.OnCreate(self)
	Mixin(self, BackdropTemplateMixin)

	--self:EnableMouse(true)
	self:SetFrameStrata("HIGH")
	local frameLevel = 2 + (isBank and 5 or 0)
	self:SetFrameLevel(frameLevel - 2)

	self:SetScript('OnShow', self.OnShow)
	self:SetScript('OnHide', self.OnHide)

	self.name = name
	self.bagObject = bagObject
	self.isBank = isBank
	self.isReagentBank = false
	self.firstLoad = true

	self.buttons = {}
	self.content = {}
	self.stacks = {}
	self.sections = {}

	self.added = {}
	self.removed = {}
	self.changed = {}
	self.sameChanged = {}

	self.itemGUIDtoItem = {}

	local ids
	for bagId in pairs(BAG_IDS[isBank and "BANK" or "BAGS"]) do
		self.content[bagId] = { size = 0 }
		tinsert(bagSlots, bagId)
		if not addon.itemParentFrames[bagId] then
			local f = CreateFrame("Frame", addonName..'ItemContainer'..bagId, self)
			f.isBank = isBank
			f:SetID(bagId)
			addon.itemParentFrames[bagId] = f
		end
	end

	local button = CreateFrame("Button", nil, self)
	button:SetAllPoints(self)
	button:RegisterForClicks("AnyUp")
	button:SetScript('OnClick', function(_, ...) return self:OnClick(...) end)
	button:SetScript('OnReceiveDrag', function() return self:OnClick("LeftButton") end)
	button:SetFrameLevel(frameLevel - 1)

	local headerLeftRegion = SimpleLayeredRegion:Create(self, "TOPLEFT", "RIGHT", 4)
	headerLeftRegion:SetPoint("TOPLEFT", BAG_INSET, -BAG_INSET)
	self.HeaderLeftRegion = headerLeftRegion
	self:AddWidget(headerLeftRegion)
	headerLeftRegion:SetFrameLevel(frameLevel)

	local headerRightRegion = SimpleLayeredRegion:Create(self, "TOPRIGHT", "LEFT", 4)
	headerRightRegion:SetPoint("TOPRIGHT", -32, -BAG_INSET)
	self.HeaderRightRegion = headerRightRegion
	self:AddWidget(headerRightRegion)
	headerRightRegion:SetFrameLevel(frameLevel)

	local bottomLeftRegion = SimpleLayeredRegion:Create(self, "BOTTOMLEFT", "UP", 4)
	bottomLeftRegion:SetPoint("BOTTOMLEFT", BAG_INSET, BAG_INSET)
	self.BottomLeftRegion = bottomLeftRegion
	self:AddWidget(bottomLeftRegion)
	bottomLeftRegion:SetFrameLevel(frameLevel)

	local bottomRightRegion = SimpleLayeredRegion:Create(self, "BOTTOMRIGHT", "UP", 4)
	bottomRightRegion:SetPoint("BOTTOMRIGHT", -BAG_INSET, BAG_INSET)
	self.BottomRightRegion = bottomRightRegion
	self:AddWidget(bottomRightRegion)
	bottomRightRegion:SetFrameLevel(frameLevel)

	local bagSlotPanel = addon:CreateBagSlotPanel(self, name, bagSlots, isBank)
	bagSlotPanel:Hide()
	self.BagSlotPanel = bagSlotPanel
	wipe(bagSlots)

	local closeButton = CreateFrame("Button", nil, self, "UIPanelCloseButton")
	self.CloseButton = closeButton
	closeButton:SetPoint("TOPRIGHT", -2, -2)
	addon.SetupTooltip(closeButton, L["Close"])
	closeButton:SetFrameLevel(frameLevel)

	local bagSlotButton = CreateFrame("CheckButton", nil, self)
	bagSlotButton:SetNormalTexture([[Interface\Buttons\Button-Backpack-Up]])
	bagSlotButton:SetCheckedTexture([[Interface\Buttons\CheckButtonHilight]])
	bagSlotButton:GetCheckedTexture():SetBlendMode("ADD")
	bagSlotButton:SetScript('OnClick', BagSlotButton_OnClick)
	bagSlotButton.panel = bagSlotPanel
	bagSlotButton:SetWidth(18)
	bagSlotButton:SetHeight(18)
	self.BagSlotButton = bagSlotButton
	addon.SetupTooltip(bagSlotButton, {
		L["Equipped bags"],
		L["Click to toggle the equipped bag panel, so you can change them."]
	}, "ANCHOR_BOTTOMLEFT", -8, 0)
	headerLeftRegion:AddWidget(bagSlotButton, 50)

	local searchBox = CreateFrame("EditBox", self:GetName().."SearchBox", self, "BagSearchBoxTemplate")
	searchBox:SetSize(130, 20)
	searchBox:SetFrameLevel(frameLevel)
	headerRightRegion:AddWidget(searchBox, -10, 130, 0, -1)
	tinsert(_G.ITEM_SEARCHBAR_LIST, searchBox:GetName())

	local title = self:CreateFontString(self:GetName().."Title","OVERLAY")
	self.Title = title
	title:SetFontObject(addon.bagFont)
	title:SetText(L[name])
	title:SetHeight(18)
	title:SetJustifyH("LEFT")
	title:SetPoint("LEFT", headerLeftRegion, "RIGHT", 4, 0)
	title:SetPoint("RIGHT", headerRightRegion, "LEFT", -4, 0)

	local anchor = addon:CreateBagAnchorWidget(self, name, L[name])
	anchor:SetAllPoints(title)
	anchor:SetFrameLevel(self:GetFrameLevel() + 10)
	self.Anchor = anchor

	if addon.isRetail then
		if self.isBank then
			self:CreateReagentTabButton()
			self:CreateDepositButton()
		end
		self:CreateSortButton()
	end

	local toSortSection = addon:AcquireSection(self, L["Recent Items"], self.name)
	toSortSection:SetPoint("TOPLEFT", BAG_INSET, -addon.TOP_PADDING)
	toSortSection:Show()
	self.ToSortSection = toSortSection
	self:AddWidget(toSortSection)

	-- Override toSortSection handlers
	toSortSection.ShowHeaderTooltip = function(self, _ , tooltip)
		tooltip:SetPoint("BOTTOMRIGHT", self.container, "TOPRIGHT", 0, 4)
		tooltip:AddLine(L["Recent items"], 1, 1, 1)
		tooltip:AddLine(L["This special section receives items that have been recently moved, changed or added to the bags."])
	end
	toSortSection.UpdateHeaderScripts = function() end
	toSortSection.Header:RegisterForClicks("AnyUp")
	toSortSection.Header:SetScript("OnClick", function() self:FullUpdate() end)
	local content
	if addon.db.profile.gridLayout then
		content = addon:CreateGridFrame((isBank and "Bank" or "Backpack"), self)
		self:CreateLockButton()
	else
		content = CreateFrame("Frame", nil, self)
	end
	content:SetPoint("TOPLEFT", toSortSection, "BOTTOMLEFT", 0, -ITEM_SPACING)
	self.Content = content
	self:AddWidget(content)

	self:UpdateSkin()
	self.paused = true
	self.forceLayout = true

	LSM.RegisterCallback(self, 'LibSharedMedia_Registered', 'UpdateSkin')
	LSM.RegisterCallback(self, 'LibSharedMedia_SetGlobal', 'UpdateSkin')

	local ForceFullLayout = function() self.forceLayout = true end

	-- Register persitent listeners
	local name = self:GetName()
	local RegisterMessage = LibStub('ABEvent-1.0').RegisterMessage
	RegisterMessage(name, 'AdiBags_FiltersChanged', self.FullUpdate, self)
	RegisterMessage(name, 'AdiBags_LayoutChanged', self.FullUpdate, self)
	RegisterMessage(name, 'AdiBags_ConfigChanged', self.ConfigChanged, self)
	RegisterMessage(name, 'AdiBags_ForceFullLayout', ForceFullLayout)
	RegisterMessage(name, 'AdiBags_GridUpdate', self.OnLayout, self)
	if addon.isRetail then
		LibStub('ABEvent-1.0').RegisterEvent(name, 'EQUIPMENT_SWAP_FINISHED', ForceFullLayout)

		-- Force full layout on sort
		if isBank then
			if C_Container then
				hooksecurefunc(C_Container, 'SortBankBags', ForceFullLayout)
				hooksecurefunc(C_Container, 'SortReagentBankBags', ForceFullLayout)
			else
				hooksecurefunc('SortBankBags', ForceFullLayout)
				hooksecurefunc('SortReagentBankBags', ForceFullLayout)
			end
		else
			if C_Container then
				hooksecurefunc(C_Container,'SortBags', ForceFullLayout)
			else
				hooksecurefunc('SortBags', ForceFullLayout)
			end
		end
	end
end

function containerProto:ToString() return self.name or self:GetName() end

function containerProto:CreateModuleButton(letter, order, onClick, tooltip)
	local button = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
	button:SetText(letter)
	button:SetSize(20, 20)
	button:SetScript("OnClick", onClick)
	button:RegisterForClicks("AnyUp")
	if order then
		self:AddHeaderWidget(button, order)
	end
	if tooltip then
		addon.SetupTooltip(button, tooltip, "ANCHOR_TOPLEFT", 0, 8)
	end
	return button
end

 function containerProto:CreateModuleAutoButton(letter, order, title, description, optionName, onClick, moreTooltip)
	local button
	local statusTexts = {
		[false] = '|cffff0000'..L["disabled"]..'|r',
		[true]  = '|cff00ff00'..L["enabled"]..'|r'
	}
	local Description = description:sub(1, 1):upper() .. description:sub(2)

	button = self:CreateModuleButton(
		letter,
		order,
		function(_, mouseButton)
			if mouseButton == "RightButton" then
				local enable = not addon.db.profile[optionName]
				addon.db.profile[optionName] = enable
				return PlaySound(enable and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
			end
			onClick()
		end,
		function(_, tooltip)
			tooltip:AddLine(title, 1, 1, 1)
			tooltip:AddLine(format(L["%s is: %s."], Description, statusTexts[not not addon.db.profile[optionName]]))
			if moreTooltip then
				tooltip:AddLine(moreTooltip)
			end
			tooltip:AddLine(format(L["Right-click to toggle %s."], description))
		end
	)

	return button
end

function containerProto:CreateDepositButton()
	local button = self:CreateModuleAutoButton(
		"D",
		0,
		REAGENTBANK_DEPOSIT,
		L["auto-deposit"],
		"autoDeposit",
		function()
			DepositReagentBank()
			for bag in pairs(self:GetBagIds()) do
				self:UpdateContent(bag)
			end
		end,
		L["You can block auto-deposit ponctually by pressing a modified key while talking to the banker."]
	)

	if not IsReagentBankUnlocked() then
		button:Hide()
		button:SetScript('OnEvent', button.Show)
		button:RegisterEvent('REAGENTBANK_PURCHASED')
	end
end

function containerProto:CreateSortButton()
	self:CreateModuleButton(
		"S",
		10,
		function()
			addon:CloseAllBags()
			self.bagObject:Sort(self.isReagentBank)
			self.forceLayout = true
		end,
		L["(Blizzard's) Sort items"]
	)
end

function containerProto:CreateLockButton()
	self:CreateModuleButton(
		"L",
		20,
		function()
			self.Content:ToggleCovers()
		end,
		L["Lock/Unlock sections so they can be moved."]
	)
end

function containerProto:CreateReagentTabButton()
	local button
	button = self:CreateModuleButton(
		"R",
		0,
		function()
			if not IsReagentBankUnlocked() then
				PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
				return StaticPopup_Show("CONFIRM_BUY_REAGENTBANK_TAB")
			end
			self:ShowReagentTab(not self.isReagentBank)
		end,
		function(_, tooltip)
			if not IsReagentBankUnlocked() then
				tooltip:AddLine(BANKSLOTPURCHASE, 1, 1, 1)
				tooltip:AddLine(REAGENTBANK_PURCHASE_TEXT)
				SetTooltipMoney(tooltip, GetReagentBankCost(), nil, COSTS_LABEL)
				return
			end
			tooltip:AddLine(
				format(
					L['Click to swap between %s and %s.'],
					REAGENT_BANK:lower(),
					L["Bank"]:lower()
				)
			)
		end
	)
end

--------------------------------------------------------------------------------
-- Scripts & event handlers
--------------------------------------------------------------------------------

function containerProto:GetBagIds()
	if addon.isRetail then
		return BAG_IDS[
			self.isReagentBank and "REAGENTBANK_ONLY" or
			self.isBank and "BANK_ONLY" or
			"BAGS"
		]
	else
		return BAG_IDS[
			self.isBank and "BANK" or
			"BAGS"
		]
	end
end

function containerProto:BagsUpdated(event, bagIds)
	self:Debug('BagsUpdated')
	local showBag = self:GetBagIds()
	for bag in pairs(bagIds) do
		if showBag[bag] then
			self:UpdateContent(bag)
		end
	end
	self:UpdateButtons()
end

function containerProto:CanUpdate()
	return not addon.holdYourBreath and not addon.globalLock and not self.paused and self:IsVisible()
end

function containerProto:ConfigChanged(event, name)
	if strsplit('.', name) == 'skin' then
		self:UpdateSkin()
	end
end

function containerProto:OnShow()
	self:Debug('OnShow')
	PlaySound(self.isBank and SOUNDKIT.IG_MAINMENU_OPEN or SOUNDKIT.IG_BACKPACK_OPEN)
	self:RegisterEvent('EQUIPMENT_SWAP_PENDING', "PauseUpdates")
	self:RegisterEvent('EQUIPMENT_SWAP_FINISHED', "ResumeUpdates")
	self:RegisterEvent('AUCTION_MULTISELL_START', "PauseUpdates")
	self:RegisterEvent('AUCTION_MULTISELL_UPDATE')
	self:RegisterEvent('AUCTION_MULTISELL_FAILURE', "ResumeUpdates")
	self:ResumeUpdates()
	containerParentProto.OnShow(self)
end

function containerProto:OnHide()
	containerParentProto.OnHide(self)
	PlaySound(self.isBank and SOUNDKIT.IG_MAINMENU_CLOSE or SOUNDKIT.IG_BACKPACK_CLOSE)
	self:PauseUpdates()
	self:UnregisterAllEvents()
	self:UnregisterAllMessages()
end

function containerProto:ResumeUpdates()
	if not self.paused then return end
	self.paused = false
	self:RegisterMessage('AdiBags_BagUpdated', 'BagsUpdated')
	self:Debug('ResumeUpdates')
	self:RefreshContents()
end

function containerProto:PauseUpdates()
	if self.paused then return end
	self:Debug('PauseUpdates')
	self:UnregisterMessage('AdiBags_BagUpdated')
	self.paused = true
end

function containerProto:RefreshContents()
	self:Debug('RefreshContents')
	for bag in pairs(self:GetBagIds()) do
		self:UpdateContent(bag)
	end
	self:UpdateButtons()
end

function containerProto:ShowReagentTab(show)
	self:Debug('ShowReagentTab', show)

	self.Title:SetText(show and REAGENT_BANK or L["Bank"])
	self.BagSlotButton:SetEnabled(not show)
	if show and self.BagSlotPanel:IsShown() then
		self.BagSlotPanel:Hide()
		self.BagSlotButton:SetChecked(false)
	end
	BankFrame.selectedTab = show and 2 or 1

	local previousBags = self:GetBagIds()
	self.isReagentBank = show

	for bag in pairs(previousBags) do
		self:UpdateContent(bag)
	end
	self.forceLayout = true
	self:RefreshContents()
	self:UpdateSkin()
end

function containerProto:AUCTION_MULTISELL_UPDATE(event, current, total)
	if current == total then
		self:ResumeUpdates()
	end
end

--------------------------------------------------------------------------------
-- Backdrop click handler
--------------------------------------------------------------------------------

local function FindBagWithRoom(self, itemFamily)
	local fallback
	for bag in pairs(self:GetBagIds()) do
		local numFree, family = GetContainerNumFreeSlots(bag)
		if numFree and numFree > 0 then
			if band(family, itemFamily) ~= 0 then
				return bag
			elseif not fallback then
				fallback = bag
			end
		end
	end
	return fallback
end

local FindFreeSlot
do
	local slots = {}
	FindFreeSlot = function(self, item)
		local bag = FindBagWithRoom(self, GetItemFamily(item))
		if not bag then return end
		wipe(slots)
		GetContainerFreeSlots(bag, slots)
		return GetSlotId(bag, slots[1])
	end
end

function containerProto:OnClick(...)
	local kind, data1, data2 = GetCursorInfo()
	local itemLink
	if kind == "item" then
		itemLink = data2
	elseif kind == "merchant" then
		itemLink = GetMerchantItemLink(data1)
	elseif ... == "RightButton" and addon.db.profile.rightClickConfig then
		return addon:OpenOptions('bags')
	else
		return
	end
	self:Debug('OnClick', kind, data1, data2, '=>', itemLink)
	if itemLink then
		local slotId = FindFreeSlot(self, itemLink)
		if slotId then
			local button = self.buttons[slotId]
			if button then
				local button = button:GetRealButton()
				self:Debug('Redirecting click to', button)
				return button:GetScript('OnClick')(button, ...)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Regions and global layout
--------------------------------------------------------------------------------

function containerProto:AddHeaderWidget(widget, order, width, yOffset, side)
	local region = (side == "LEFT") and self.HeaderLeftRegion or self.HeaderRightRegion
	region:AddWidget(widget, order, width, 0, yOffset)
end

function containerProto:AddBottomWidget(widget, side, order, height, xOffset, yOffset)
	local region = (side == "RIGHT") and self.BottomRightRegion or self.BottomLeftRegion
	region:AddWidget(widget, order, height, xOffset, yOffset)
end

function containerProto:OnLayout()
	self:Debug('OnLayout')
	local hlr, hrr = self.HeaderLeftRegion, self.HeaderRightRegion
	local blr, brr = self.BottomLeftRegion, self.BottomRightRegion
	local minWidth = max(
		self.Title:GetStringWidth() + 32 + (hlr:IsShown() and hlr:GetWidth() or 0) + (hrr:IsShown() and hrr:GetWidth() or 0),
		(blr:IsShown() and blr:GetWidth() or 0) + (brr:IsShown() and brr:GetWidth() or 0)
	)
	local bottomHeight = max(
		blr:IsShown() and (BAG_INSET + blr:GetHeight()) or 0,
		brr:IsShown() and (BAG_INSET + brr:GetHeight()) or 0
	)
	self.minWidth = minWidth
	if self.forceLayout then
		self:FullUpdate()
	end
	self:Debug('OnLayout', self.ToSortSection:GetHeight())
	self:SetSize(
		BAG_INSET * 2 + max(minWidth, self.Content:GetWidth()),
		addon.TOP_PADDING + BAG_INSET + bottomHeight + self.Content:GetHeight() + self.ToSortSection:GetHeight() + ITEM_SPACING
	)
	if addon.db.profile.gridLayout then
		addon.db.profile.gridData = addon.db.profile.gridData or {}
		addon.db.profile.gridData[self.name] = self.Content:GetLayout()
		self:Debug("Saving Grid Layout")
	end
end

--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------

function containerProto:UpdateSkin()
	local backdrop, r, g, b, a = addon:GetContainerSkin(self.name, self.isReagentBank)
	self:SetBackdrop(backdrop)
	self:ApplyBackdrop()
	self:SetBackdropColor(r, g, b, a)
	local m = max(r, g, b)
	if m == 0 then
		self:SetBackdropBorderColor(0.5, 0.5, 0.5, a)
	else
		self:SetBackdropBorderColor(0.5+(0.5*r/m), 0.5+(0.5*g/m), 0.5+(0.5*b/m), a)
	end
end

--------------------------------------------------------------------------------
-- Bag content scanning
--------------------------------------------------------------------------------

function containerProto:UpdateContent(bag)
	self:Debug('UpdateContent', bag)
	local added, removed, changed, sameChanged = self.added, self.removed, self.changed, self.sameChanged
	local content = self.content[bag]
	local newSize = self:GetBagIds()[bag] and GetContainerNumSlots(bag) or 0
	local _, bagFamily = GetContainerNumFreeSlots(bag)
	if bag == REAGENTBAG_CONTAINER then
		bagFamily = 2048
	end
	content.family = bagFamily
	for slot = 1, newSize do
		local itemId = GetContainerItemID(bag, slot)
		local link = GetContainerItemLink(bag, slot)
		local guid = ""
		local itemLocation = ItemLocation:CreateFromBagAndSlot(bag, slot)

		if addon.isRetail then
			if itemLocation and itemLocation:IsValid() then
				guid = GetItemGUID(itemLocation)
				self.itemGUIDtoItem[guid] = itemLocation
			end
		end
		if not itemId or (link and addon.IsValidItemLink(link)) then
			local slotData = content[slot]
			if not slotData then
				slotData = {
					bag = bag,
					slot = slot,
					slotId = GetSlotId(bag, slot),
					bagFamily = bagFamily,
					count = 0,
					isBank = self.isBank,
				}
				content[slot] = slotData
			end

			local name, count, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice
			if link then
				name, _, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(link)
				if not name then
					name, _, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(itemId)
				end
				-- Correctly catch battlepets and store their name.
				if string.match(link, "|Hbattlepet:") then
					local _, speciesID = strsplit(":", link)
					name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
				end
				count = addon:GetContainerItemStackCount(bag, slot) or 0
			else
				link, count = false, 0
			end

			if slotData.guid ~= guid or slotData.texture ~= texture then
				local prevSlotId = slotData.slotId
				local prevLink = slotData.link
				local prevGUID = slotData.guid
				local sameItem
				-- Use the new guid system to detect if an item is actually the same.
				if addon.isRetail then
					sameItem = (prevGUID == guid and not (prevGUID == "" or guid == ""))
				else
					sameItem = addon.IsSameLinkButLevel(slotData.link, link)
				end

				slotData.count = count
				slotData.link = link
				slotData.itemId = itemId
				slotData.guid = guid
				slotData.itemLocation = itemLocation
				slotData.name, slotData.quality, slotData.iLevel, slotData.reqLevel, slotData.class, slotData.subclass, slotData.equipSlot, slotData.texture, slotData.vendorPrice = name, quality, iLevel, reqLevel, class, subclass, equipSlot, texture, vendorPrice
				slotData.maxStack = maxStack or (link and 1 or 0)
				if sameItem then
						changed[slotData.slotId] = slotData
				else
					removed[prevSlotId] = prevLink
					added[slotData.slotId] = slotData
					-- Remove the old item, and add the new item to the
					-- item index.
					if addon.isRetail then
						if prevGUID then
							self.itemGUIDtoItem[prevGUID] = nil
						end
					end
				end
			elseif slotData.count ~= count then
				slotData.count = count
				changed[slotData.slotId] = slotData
			end
		end
	end
	for slot = content.size, newSize + 1, -1 do
		local slotData = content[slot]
		if slotData then
			removed[slotData.slotId] = slotData.link
			content[slot] = nil
		end
	end
	content.size = newSize
end

function containerProto:HasContentChanged()
	return not not (next(self.added) or next(self.removed) or next(self.changed) or next(self.sameChanged))
end

--------------------------------------------------------------------------------
-- Item dispatching
--------------------------------------------------------------------------------

function containerProto:GetStackButton(key)
	local stack = self.stacks[key]
	if not stack then
		stack = addon:AcquireStackButton(self, key)
		self.stacks[key] = stack
	end
	return stack
end

function containerProto:GetSection(name, category)
	local key = BuildSectionKey(name, category)
	local section = self.sections[key]
	if not section then
		section = addon:AcquireSection(self, name, category)
		self.sections[key] = section
		if addon.db.profile.gridLayout then
			self.Content:AddCell(key, section)
		end
	end
	return section
end

local function FilterByBag(slotData)
	local bag = slotData.bag
	local name
	if bag == BACKPACK_CONTAINER then
		name = L['Backpack']
	elseif bag == BANK_CONTAINER then
		name = L['Bank']
	elseif bag == REAGENTBANK_CONTAINER then
		name = REAGENT_BANK
	elseif bag <= NUM_BAG_SLOTS then
		name = format(L["Bag #%d"], bag)
	elseif addon.isRetail then
		if bag == REAGENTBAG_CONTAINER then
			name = format(L["Reagent Bag"])
		else
			name = format(L["Bank bag #%d"], bag - NUM_BAG_SLOTS)
		end
	else
		name = format(L["Bank bag #%d"], bag - NUM_BAG_SLOTS)
	end
	if slotData.link then
		local shouldStack, stackHint = addon:ShouldStack(slotData)
		return name, nil, nil, shouldStack, stackHint and strjoin('#', tostring(stackHint), name)
	else
		return name, nil, nil, addon.db.profile.virtualStacks.freeSpace, name
	end
end

local MISCELLANEOUS = GetItemClassInfo(_G.Enum.ItemClass.Miscellaneous)
local FREE_SPACE = L["Free space"]
-- TODO(lobato): Label the Reagent freespace.
local FREE_SPACE_REAGENT = L["Reagent Free space"]

function containerProto:FilterSlot(slotData)
	if self.BagSlotPanel:IsShown() then
		return FilterByBag(slotData)
	elseif slotData.link then
		local section, category, filterName = addon:Filter(slotData, MISCELLANEOUS)
		return section, category, filterName, addon:ShouldStack(slotData)
	else
		if slotData.bag == REAGENTBAG then
			return FREE_SPACE_REAGENT, nil, nil, addon:ShouldStack(slotData)
		else
			return FREE_SPACE, nil, nil, addon:ShouldStack(slotData)
		end
	end
end

function containerProto:FindExistingButton(slotId, stackKey)
	local button = self.buttons[slotId]

	if not button then
		return
	elseif stackKey then
		if not button:IsStack() or button:GetKey() ~= stackKey then
			return self:RemoveSlot(slotId)
		end
	elseif button:IsStack() then
		return self:RemoveSlot(slotId)
	end

	return button
end

function containerProto:CreateItemButton(stackKey, slotData)
	if not stackKey then
		return addon:AcquireItemButton(self, slotData.bag, slotData.slot)
	end
	local stack = self:GetStackButton(stackKey)
	stack:AddSlot(slotData.slotId)
	return stack
end

function containerProto:DispatchItem(slotData, fullUpdate)
	local slotId = slotData.slotId
	local sectionName, category, filterName, shouldStack, stackHint = self:FilterSlot(slotData)
	assert(sectionName, "sectionName is nil, item: "..(slotData.link or "none"))
	local stackKey = shouldStack and stackHint or nil

	local existing, button = self:FindExistingButton(slotId, stackKey)
	if existing then
		button = existing
	else
		button = self:CreateItemButton(stackKey, slotData)
	end
	button.filterName = filterName
	self.buttons[slotId] = button

	if button:GetSection() == self.ToSortSection then
		return
	end

	if sectionName == L["Recent Items"] or (not fullUpdate and slotData.link) then
		self.ToSortSection:AddItemButton(slotId, button)
		return
	end

	local section = self:GetSection(sectionName, category or sectionName)
	section:AddItemButton(slotId, button)
end

function containerProto:RemoveSlot(slotId)
	local button = self.buttons[slotId]
	if not button then return end
	self.buttons[slotId] = nil

	if button:IsStack() then
		button:RemoveSlot(slotId)
		if not button:IsEmpty() then
			return
		end
		self.stacks[button:GetKey()] = nil
	end

	button:Release()
end

function containerProto:UpdateButtons()
	if self.forceLayout then
		return self:FullUpdate()
	elseif not self:HasContentChanged() then
		return
	end
	self:Debug('UpdateButtons')

	local added, removed, changed, sameChanged = self.added, self.removed, self.changed, self.sameChanged
	self:SendMessage('AdiBags_PreContentUpdate', self, added, removed, changed)

	for slotId in pairs(removed) do
		self:RemoveSlot(slotId)
	end

	if next(added) then
		self:SendMessage('AdiBags_PreFilter', self)
		for slotId, slotData in pairs(added) do
			self:DispatchItem(slotData)
		end
		self:SendMessage('AdiBags_PostFilter', self)
	end

	local buttons = self.buttons
	for slotId in pairs(changed) do
		buttons[slotId]:FullUpdate()
	end

	if next(sameChanged) then
		self:SendMessage('AdiBags_PreFilter', self)
		for slotId, slotData in pairs(sameChanged) do
			self:DispatchItem(slotData)
			buttons[slotId]:FullUpdate()
		end
		self:SendMessage('AdiBags_PostFilter', self)
	end

	self:SendMessage('AdiBags_PostContentUpdate', self, added, removed, changed)
	wipe(added)
	wipe(removed)
	wipe(changed)
	wipe(sameChanged)

	self:ResizeToSortSection()
end

--------------------------------------------------------------------------------
-- Section queries
--------------------------------------------------------------------------------

function containerProto:GetSectionKeys(hidden, t)
	t = t or {}
	for key, section in pairs(self.sections) do
		if hidden or not section:IsCollapsed() then
			if not t[key] then
				tinsert(t, key)
				t[key] = true
			end
		end
	end
	return t
end

function containerProto:GetOrdererSectionKeys(hidden, t)
	t = t or {}
	self:GetSectionKeys(hidden, t)
	tsort(t, addon.CompareSectionKeys)
	return t
end

function containerProto:GetSectionInfo(key)
	local name, category = SplitSectionKey(key)
	local title = (category == name) and name or (name .. " (" .. category .. ")")
	local section = self.sections[key]
	return key, section, name, category, title, section and (not section:IsCollapsed()) or false
end

do
	local t = {}
	function containerProto:IterateSections(hidden)
		wipe(t)
		self:GetOrdererSectionKeys(hidden, t)
		local i = 0
		return function()
			i = i + 1
			local key = t[i]
			if key then
				return self:GetSectionInfo(key)
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Full Layout
--------------------------------------------------------------------------------

function containerProto:ResizeToSortSection(forceLayout)
	local section = self.ToSortSection
	if section.count == 0 then
		section:SetSizeInSlots(0, 0)
		section:Hide()
		return
	end
	local width = max(self.Content:GetWidth(), self.minWidth or 0)
	local numCols = floor((width + ITEM_SPACING) / (ITEM_SIZE + ITEM_SPACING))
	local resized = section:SetSizeInSlots(numCols, ceil(section.count / numCols))
	section:Show()
	if forceLayout or resized or not section:IsShown() then
		section:FullLayout()
	end
end

function containerProto:RedispatchAllItems()
	self:Debug('RedispatchAllItems')
	self:SendMessage('AdiBags_PreContentUpdate', self, self.added, self.removed, self.changed)

	local content = self.content
	for slotId in pairs(self.buttons) do
		local bag, slot = GetBagSlotFromId(slotId)
		if not content[bag][slot] then
			self:RemoveSlot(slotId)
		end
	end

	self:SendMessage('AdiBags_PreFilter', self)
	for bag, content in pairs(self.content) do
		for slot, slotData in ipairs(content) do
			self:DispatchItem(slotData, true)
		end
	end
	self:SendMessage('AdiBags_PostFilter', self)

	self:SendMessage('AdiBags_PostContentUpdate', self, self.added, self.removed, self.changed)
	wipe(self.added)
	wipe(self.removed)
	wipe(self.changed)

	self:ResizeToSortSection()
end

-- Local stateless comparing function for sorting.
local function CompareSections(a, b)
	local orderA, orderB = a:GetOrder(), b:GetOrder()
	if orderA == orderB then
		if a.category == b.category then
			return a.name < b.name
		else
			return a.category < b.category
		end
	else
		return orderA > orderB
	end
end

function containerProto:PrepareSections(columnWidth, sections)
	wipe(sections)
	local maxHeight = 0
	for key, section in pairs(self.sections) do
		if section:IsEmpty() or section:IsCollapsed() then
			section:Hide()
		else
			tinsert(sections, section)
			local count = section.count
			if count > columnWidth then
				section:SetSizeInSlots(columnWidth, ceil(count / columnWidth))
			else
				section:SetSizeInSlots(count, 1)
			end
			section:Show()
			section:FullLayout()
			maxHeight = max(maxHeight, section:GetHeight())
		end
	end

	tsort(sections, CompareSections)
	self:Debug('PrepareSections', 'columnWidth=', columnWidth, '=>', #sections, 'sections')
	return maxHeight
end

local function FindFittingSection(maxWidth, sections)
	local bestScore, bestIndex = math.huge
	for index, section in ipairs(sections) do
		local wasted = maxWidth - section:GetWidth()
		if wasted >= 0 and wasted < bestScore then
			bestScore, bestIndex = wasted, index
		end
	end
	return bestIndex and tremove(sections, bestIndex)
end

local function GetNextSection(maxWidth, sections)
	if sections[1] and sections[1]:GetWidth() <= maxWidth then
		return tremove(sections, 1)
	end
end

local COLUMN_SPACING = ceil((ITEM_SIZE + ITEM_SPACING) / 2)
local ROW_SPACING = ITEM_SPACING*2
local SECTION_SPACING = COLUMN_SPACING / 2

function containerProto:LayoutSections(maxHeight, columnWidth, minWidth, sections)
	if addon.db.profile.gridLayout then
		self.Content:Update()
		return
	end
	self:Debug('LayoutSections', maxHeight, columnWidth, minWidth)
	local heights, widths, rows = { 0 }, {}, {}
	local columnPixelWidth = (ITEM_SIZE + ITEM_SPACING) * columnWidth - ITEM_SPACING + SECTION_SPACING
	local getSection = addon.db.profile.compactLayout and FindFittingSection or GetNextSection

	local numRows, x, y, rowHeight, maxSectionHeight, previous = 0, 0, 0, 0, 0, nil
	while next(sections) do
		local section
		if x > 0 then
			section = getSection(columnPixelWidth - x, sections)
			if section and previous then
				-- Quick hack -- sometimes the same section is inserted twice for unknown reasons.
				if section ~= previous then
					section:SetPoint('TOPLEFT', previous, 'TOPRIGHT', SECTION_SPACING, 0)
				end
			else
				x = 0
				y = y + rowHeight + ROW_SPACING
			end
		end

		if x == 0 then
			section = tremove(sections, 1)
			rowHeight = section:GetHeight()
			numRows = numRows + 1
			heights[numRows] = y
			rows[numRows] = section
			if numRows > 1 then
				section:SetPoint('TOPLEFT', rows[numRows-1], 'BOTTOMLEFT', 0, -ROW_SPACING)
			end
		end

		if section ~= previous then
			x = x + section:GetWidth() + SECTION_SPACING
			widths[numRows] = x - SECTION_SPACING
			previous = section
			maxSectionHeight = max(maxSectionHeight, section:GetHeight())
			rowHeight = max(rowHeight, section:GetHeight())
		end
	end

	local totalHeight = y + rowHeight
	heights[numRows+1] = totalHeight
	local numColumns = max(floor(minWidth / (columnPixelWidth - COLUMN_SPACING)), ceil(totalHeight / maxHeight))
	local maxColumnHeight = max(ceil(totalHeight / numColumns), maxSectionHeight)

	local content = self.Content
	local row, x, contentHeight = 1, 0, 0
	while row <= numRows do
		local yOffset, section = heights[row], rows[row]
		section:SetPoint('TOPLEFT', content, x, 0)
		local maxY, thisColumnWidth = yOffset + maxColumnHeight + ITEM_SIZE + ROW_SPACING, 0
		repeat
			thisColumnWidth = max(thisColumnWidth, widths[row])
			row = row + 1
		until row > numRows or heights[row+1] > maxY
		contentHeight = max(contentHeight, heights[row] - yOffset)
		x = x + thisColumnWidth + COLUMN_SPACING
	end

	return x - COLUMN_SPACING, contentHeight - ITEM_SPACING
end

function containerProto:FullUpdate()
	self:Debug('FullUpdate', self:CanUpdate(), self.minWidth)
	if not self:CanUpdate() or not self.minWidth then
		self.forceLayout = true
		return
	end
	if addon.db.profile.gridLayout then
		self.Content:DeferUpdate()
	end

	self.forceLayout = false
	self:Debug('Do FullUpdate')

	local settings = addon.db.profile
	local columnWidth = settings.columnWidth[self.name]

	self.ToSortSection:Clear()
	self:RedispatchAllItems()

	local sections = {}

	local maxSectionHeight = self:PrepareSections(columnWidth, sections)
	if addon.db.profile.gridLayout and self.firstLoad then
		addon.db.profile.gridData = addon.db.profile.gridData or {}
		self.Content:SetLayout(addon.db.profile.gridData[self.name])
	end
	if #sections == 0 then
		self.Content:SetSize(self.minWidth, 0.5)
	else
		local uiScale, uiWidth, uiHeight = UIParent:GetEffectiveScale(), UIParent:GetSize()
		local selfScale = self:GetEffectiveScale()
		local maxHeight = max(maxSectionHeight, settings.maxHeight * uiHeight * uiScale / selfScale - (ITEM_SIZE + ITEM_SPACING + HEADER_SIZE))
		local contentWidth, contentHeight = self:LayoutSections(maxHeight, columnWidth, self.minWidth, sections)
		if not addon.db.profile.gridLayout then
			self.Content:SetSize(contentWidth, contentHeight)
		end
		--self.Content:SetSize(contentWidth, contentHeight)
	end

	self:ResizeToSortSection(true)
	if addon.db.profile.gridLayout then
		self.Content:DoUpdate()
	end
	self.firstLoad = false
end
