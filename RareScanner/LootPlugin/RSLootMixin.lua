-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local function IsEquipable(itemClassID, itemSubClassID, itemEquipLoc) 
	local _, _, classIndex = UnitClass("player");
	for categoryID, subcategories in pairs(private.CLASS_PROFICIENCIES[classIndex]) do
		if (categoryID == itemClassID and not RS_tContains(subcategories, itemSubClassID)) then
			return false
		end
	end
	-- check if cloth and not cloak
	if (itemClassID == 4 and itemSubClassID == 1 and not RS_tContains(private.CLOTH_CHARACTERES, classIndex) and itemEquipLoc ~= "INVTYPE_CLOAK") then --check if its cloth and not cloak
		return false
	end
	
	return true
end

-- Tooltip for scanning
local scanTip = CreateFrame("GAMETOOLTIP", "RSToolTipScan", nil, "GameTooltipTemplate")

local function ScanToolTipFor(itemLink, value)
	scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
	scanTip:SetHyperlink(itemLink)
			
	local foundText = false
	for i=1, scanTip:NumLines() do
		local toolTipText = _G["RSToolTipScanTextLeft"..i]:GetText()
		if (toolTipText and RS_tContains(toolTipText, value)) then
			foundText = true
			break
		end
	end
	
	return foundText
end

function RareScanner:RSGetItemInfo(itemID)
	if (not private.dbglobal.loot_info) then
		private.dbglobal.loot_info = {}
	end
	
	if (not private.dbglobal.loot_info[itemID]) then
		local retOk, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = pcall(GetItemInfo, itemID)
		if (itemLink and itemRarity and itemEquipLoc and iconFileDataID and itemClassID and itemSubClassID) then
			private.dbglobal.loot_info[itemID] = { itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID }
			return unpack(private.dbglobal.loot_info[itemID])
		end
		return itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID
	else
		return unpack(private.dbglobal.loot_info[itemID])
	end
end
	
RSLootMixin = { };

function RSLootMixin:OnLoad()
	self:EnableKeyboard(true)
end

function RSLootMixin:OnEnter()
	if (self:GetParent() and self:GetParent():GetParent()) then
		--local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(self.itemID)
		local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RareScanner:RSGetItemInfo(self.itemID)
		--print("itemName "..(itemName or "nil")..", itemLink "..(itemLink or "nil")..", itemRarity "..(itemRarity or "nil")..", itemLevel "..(itemLevel or "nil")..", itemMinLevel "..(itemMinLevel or "nil")..", itemType "..(itemType or "nil")..", itemSubType "..(itemSubType or "nil")..", itemStackCount "..(itemStackCount or "nil")..", itemEquipLoc "..(itemEquipLoc or "nil")..", iconFileDataID "..(iconFileDataID or "nil")..", itemSellPrice "..(itemSellPrice or "nil")..", itemClassID "..(itemClassID or "nil")..", itemSubClassID "..(itemSubClassID or "nil")..", bindType "..(bindType or "nil")..", expacID "..(expacID or "nil")..", itemSetID "..(itemSetID or "nil")..", isCraftingReagent "..(isCraftingReagent and "true" or "false"))
		--RareScanner:PrintDebugMessage("DEBUG: itemID "..self.itemID..", itemEquipLoc "..(itemEquipLoc or "nil")..", itemClassID "..(itemClassID or "nil")..", itemSubClassID "..(itemSubClassID or "nil"))

		local toolTip = self:GetParent().LootBarToolTip
		toolTip:SetOwner(self:GetParent():GetParent(), private.db.loot.lootTooltipPosition)
		toolTip:SetHyperlink(self.itemLink)
		toolTip:SetParent(self)
		toolTip:AddLine("RareScanner: "..AL["LOOT_TOGGLE_FILTER"], 1,1,0)
		toolTip:AddDoubleLine(GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID), 1, 1, 0, 1 ,1, 0);
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
	elseif (IsAltKeyDown()) then
		if (private.db.loot.filteredLootCategories[self.itemClassID][self.itemSubClassID]) then
			private.db.loot.filteredLootCategories[self.itemClassID][self.itemSubClassID] = false
			RareScanner:PrintMessage(string.format(AL["LOOT_CATEGORY_FILTERED"], GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID)))
		else
			private.db.loot.filteredLootCategories[self.itemClassID][self.itemSubClassID] = true
			RareScanner:PrintMessage(string.format(AL["LOOT_CATEGORY_NOT_FILTERED"], GetItemClassInfo(self.itemClassID), GetItemSubClassInfo(self.itemClassID, self.itemSubClassID)))
		end
	end
end

function RSLootMixin:AddItem(itemID, numActive)
	local itemLink, itemRarity, itemEquipLoc, iconFileDataID, itemClassID, itemSubClassID = RareScanner:RSGetItemInfo(itemID)
	if (not iconFileDataID) then
		self.itemID = itemID
		-- It will be refired after recieving the item info
		return true
	-- If we have already more items than wanted
	elseif (numActive > private.db.loot.numItems) then
		return false
	end
	
	-- Apply filters
	local filtersPassed = RareScanner:ApplyLootFilters(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)
	if (not filtersPassed) then
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
	local rowNum = floor(numActive/private.db.loot.numItemsPerRow)
	if (floor(numActive%private.db.loot.numItemsPerRow) == 0) then
		rowNum = floor(numActive/private.db.loot.numItemsPerRow) - 1
	else
		rowNum = floor(numActive/private.db.loot.numItemsPerRow)
	end
	if (rowNum > 0) then
		colNum = numActive - (private.db.loot.numItemsPerRow * rowNum)
	end
	self:SetPoint("TOPLEFT", (self:GetWidth() * (colNum - 1)), -(self:GetHeight() * rowNum))
	
	-- Recenter parent
	local maxWidth
	if (numActive < private.db.loot.numItemsPerRow) then
		maxWidth = numActive
	else
		maxWidth = private.db.loot.numItemsPerRow
	end
	
	self:GetParent():SetSize(self:GetWidth() * maxWidth, 20 * (floor(numActive/private.db.loot.numItemsPerRow) + 1))
	self:GetParent():SetPoint("TOP", self:GetParent():GetParent(), "BOTTOM", 0, -3)
	
	return true
end

function RareScanner:ApplyLootFilters(itemID, itemLink, itemRarity, itemEquipLoc, itemClassID, itemSubClassID)
	-- Quality filter
	if (itemRarity < tonumber(private.db.loot.lootMinQuality)) then
		--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por estar filtrado por calidad.")
		return false
	-- Category filter
	elseif (private.db.loot.filteredLootCategories[itemClassID] and private.db.loot.filteredLootCategories[itemClassID][itemSubClassID] == false) then
		--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por estar filtrado por categoria.")
		return false
	-- Completed quests
	elseif (private.db.loot.filterItemsCompletedQuest and itemClassID == 12) then --quest item
		if (not private.LOOT_QUEST_IDS[itemID] or IsQuestFlaggedCompleted(private.LOOT_QUEST_IDS[itemID])) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por ser un objeto de mision que ya esta completada (IsQuestFlaggedCompleted)")
			return false
		end
	-- Equipable filter
	elseif (private.db.loot.filterNotEquipableItems and (itemClassID == 2 or itemClassID == 4)) then --weapons or armor
		if (not IsEquipable(itemClassID, itemSubClassID, itemEquipLoc)) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por no ser equipable. Categoria "..itemClassID..", subcategoria "..itemSubClassID)
			return false;
		end
	-- Character class filter
	elseif (private.db.loot.filterNotMatchingClass and ScanToolTipFor(itemLink, string.gsub(ITEM_CLASSES_ALLOWED, ": %%s", ""))) then
		local localizedClass, _, _ = UnitClass("player")
		if (not ScanToolTipFor(itemLink, localizedClass)) then
			return false;
		end
	-- Transmog filter
	elseif (private.db.loot.showOnlyTransmogItems and (itemClassID == 2 or (itemClassID == 4 and itemSubClassID ~= 0))) then --weapons or armor (not rings, necks, etc.)	
		if (not IsEquipable(itemClassID, itemSubClassID, itemEquipLoc)) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por no ser equipable y por lo tanto transfigurable. Categoria "..itemClassID..", subcategoria "..itemSubClassID)
			return false
		elseif (C_TransmogCollection.PlayerHasTransmog(itemID)) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por no ser transfigurable (PlayerHasTransmog)")
			return false
		else 
			if (not ScanToolTipFor(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) then
				--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por no ser transfigurable (ToolTip)")
				return false
			end
		end
	-- Collection mount filter
	elseif (private.db.loot.filterCollectedItems and itemClassID == 15 and itemSubClassID == 5) then --mount
		if (ScanToolTipFor(itemLink, ITEM_SPELL_KNOWN)) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por tenerlo ya en la coleccion de monturas (ToolTip)")
			return false
		end
	-- Collection pet filter
	-- Unique pets
	elseif (private.db.loot.filterCollectedItems and itemClassID == 15 and itemSubClassID == 2) then --pets
		if (ScanToolTipFor(itemLink, format(ITEM_PET_KNOWN, "1", "1"))) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por tenerlo ya en la coleccion de mascotas (ToolTip)")
			return false
		end
	-- Collection toy filter
	-- Toys have different categories under miscelanious
	elseif (private.db.loot.filterCollectedItems) then --toy
		if (ScanToolTipFor(itemLink, TOY) and ScanToolTipFor(itemLink, ITEM_SPELL_KNOWN)) then
			--RareScanner:PrintDebugMessage("DEBUG: Filtrado el objeto "..itemID.." por tenerlo ya en la coleccion de juguetes (ToolTip)")
			return false
		end
	end
	
	return true
end