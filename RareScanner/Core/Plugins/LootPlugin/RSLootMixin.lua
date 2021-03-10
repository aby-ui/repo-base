-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")

-- RareScanner services
local RSLoot = private.ImportLib("RareScannerLoot")


RSLootMixin = { };

function RSLootMixin:OnLoad()
	self:EnableKeyboard(true)
end

function RSLootMixin:OnEnter()
	if (self:GetParent() and self:GetParent():GetParent()) then
		local itemLink, _, _, _, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(self.itemID)

		local toolTip = self:GetParent().LootBarToolTip
		toolTip:SetOwner(self:GetParent():GetParent(), RSConfigDB:GetLootTooltipPosition())
		toolTip:SetHyperlink(self.itemLink)
		toolTip:SetParent(self)
		
		-- Other addons support
		if (CanIMogIt and RSConfigDB.IsShowingLootCanimogitTooltip()) then
			toolTip:AddLine(CanIMogIt:GetTooltipText(itemLink))
		end
		
		if (RSConfigDB.IsShowingLootTooltipsCommands()) then
			toolTip:AddLine(string.format(AL["LOOT_TOGGLE_FILTER"], GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID)), 1,1,0)
			toolTip:AddLine(AL["LOOT_TOGGLE_INDIVIDUAL_FILTER"], 1,1,0)
		end
	
		if (RSConfigDB.IsShowingCovenantRequirement()) then
			if (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_NECROLORD, self.itemID)) then
				toolTip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_NECROLORDS"]), 0.3,0.7,0.2)
			elseif (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_NIGHT_FAE, self.itemID)) then
				toolTip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_NIGHT_FAE"]), 0.6,0.2,0.7)
			elseif (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_VENTHYR, self.itemID)) then
				toolTip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_VENTHYR"]), 0.7,0,0)
			end
		end
		
		if (RSConstants.DEBUG_MODE) then
			toolTip:AddLine(self.itemID, 1,1,0)
		end
		toolTip:Show()

		self.Icon.Anim:Play();
	end
end

function RSLootMixin:OnLeave()
	self:GetParent().LootBarToolTip:Hide()
	self.Icon.Anim:Stop();
end

function RSLootMixin:OnKeyUp()
	self:SetPropagateKeyboardInput(true)
	local toolTip = self:GetParent().LootBarToolTip
	GameTooltip_HideShoppingTooltips(toolTip)
end

function RSLootMixin:OnKeyDown()
	self:SetPropagateKeyboardInput(true)
	local toolTip = self:GetParent().LootBarToolTip
	if (IsShiftKeyDown() and toolTip:IsShown()) then
		GameTooltip_OnTooltipSetShoppingItem(toolTip)
		GameTooltip_ShowCompareItem(toolTip)
	end
end

function RSLootMixin:OnMouseDown()
	if (IsControlKeyDown()) then
		DressUpItemLink(self.itemLink)
		DressUpBattlePetLink(self.itemLink)
		DressUpMountLink(self.itemLink)
	elseif (IsAltKeyDown()) then
		if (IsShiftKeyDown()) then
			if (not RSConfigDB.GetItemFiltered(self.itemID)) then
				RSConfigDB.SetItemFiltered(self.itemID, true)
				RSLogger:PrintMessage(string.format(AL["LOOT_INDIVIDUAL_FILTERED"], self.itemLink))
			else
				RSConfigDB.SetItemFiltered(self.itemID, false)
				RSLogger:PrintMessage(string.format(AL["LOOT_INDIVIDUAL_NOT_FILTERED"], self.itemLink))
			end
			-- Refresh options panel (if its being initialized)
			if (private.loadFilteredItems) then
				private.loadFilteredItems()
			end
		else
			if (RSConfigDB.GetLootFilterByCategory(self.itemClassID, self.itemSubClassID)) then
				RSConfigDB.SetLootFilterByCategory(self.itemClassID, self.itemSubClassID, false)
				RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_FILTERED"], GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID)))
			else
				RSConfigDB.SetLootFilterByCategory(self.itemClassID, self.itemSubClassID, true)
				RSLogger:PrintMessage(string.format(AL["LOOT_CATEGORY_NOT_FILTERED"], GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID)))
			end
		end
	end
end

function RSLootMixin:AddItem(itemID, numActive)
	local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RSGeneralDB.GetItemInfo(itemID)
	if (not iconFileDataID) then
		self.itemID = itemID
		-- It will be refired after recieving the item info
		return true
			-- If we have already more items than wanted
	elseif (numActive > RSConfigDB.GetMaxNumItemsToShow()) then
		return false
	end

	-- Apply filters
	if (RSLoot.IsFiltered(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)) then
		return false;
	end

	-- Set item icon
	self.Icon:SetTexture(iconFileDataID)
	self.itemID = itemID
	self.itemLink = itemLink
	self.itemClassID = itemClassID
	self.itemSubClassID = itemSubClassID
	self:Show()

	-- Add frame and position icons
	local colNum = numActive
	local rowNum = floor(numActive/RSConfigDB.GetNumItemsPerRow())
	if (floor(numActive%RSConfigDB.GetNumItemsPerRow()) == 0) then
		rowNum = floor(numActive/RSConfigDB.GetNumItemsPerRow()) - 1
	else
		rowNum = floor(numActive/RSConfigDB.GetNumItemsPerRow())
	end
	if (rowNum > 0) then
		colNum = numActive - (RSConfigDB.GetNumItemsPerRow() * rowNum)
	end
	self:SetPoint("TOPLEFT", (self:GetWidth() * (colNum - 1)), -(self:GetHeight() * rowNum))

	-- Recenter parent
	local maxWidth
	if (numActive < RSConfigDB.GetNumItemsPerRow()) then
		maxWidth = numActive
	else
		maxWidth = RSConfigDB.GetNumItemsPerRow()
	end

	self:GetParent():SetSize(self:GetWidth() * maxWidth, 20 * (floor(numActive/RSConfigDB.GetNumItemsPerRow()) + 1))
	self:GetParent():SetPoint("TOP", self:GetParent():GetParent(), "BOTTOM", 0, -3)

	return true
end
