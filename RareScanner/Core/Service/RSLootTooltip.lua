-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSLootTooltip = private.NewLib("RareScannerLootTooltip")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSCollectionsDB = private.ImportLib("RareScannerCollectionsDB")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTooltipScanners = private.ImportLib("RareScannerTooltipScanners")

---============================================================================
-- Adds extra information to loot tooltips
---============================================================================

function RSLootTooltip.AddRareScannerInformation(tooltip, itemLink, itemID, itemClassID, itemSubClassID)
	-- Adds transmog unknown appearance message if the game doesnt add it
	if (not RSTooltipScanners.ScanLoot(itemLink, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN) and RSCollectionsDB.IsNotcollectedAppearance(itemID)) then
		GameTooltip_AddColoredLine(tooltip, TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN, LIGHTBLUE_FONT_COLOR);
	end

	-- Adds commands	
	if (itemClassID and itemSubClassID and RSConfigDB.IsShowingLootTooltipsCommands()) then
		tooltip:AddLine(string.format(AL["LOOT_TOGGLE_FILTER"], GetItemClassInfo(itemClassID), GetItemSubClassInfo(itemClassID, itemSubClassID)), 1,1,0)
		tooltip:AddLine(AL["LOOT_TOGGLE_INDIVIDUAL_FILTER"], 1,1,0)
	end
	
	-- Adds covenant requirement
	if (RSConfigDB.IsShowingCovenantRequirement()) then
		if (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_NECROLORD, itemID)) then
			tooltip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_NECROLORDS"]), 0.3,0.7,0.2)
		elseif (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_NIGHT_FAE, itemID)) then
			tooltip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_NIGHT_FAE"]), 0.6,0.2,0.7)
		elseif (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_VENTHYR, itemID)) then
			tooltip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_VENTHYR"]), 0.7,0,0)
		elseif (RSUtils.Contains(RSConstants.ITEMS_REQUIRE_KYRIAN, itemID)) then
			tooltip:AddLine(string.format(AL["LOOT_COVENANT_REQUIREMENT"], AL["NOTE_KYRIAN"]), 0,0.7,1)
		end
	end
	
	-- Adds DEBUG information
	if (RSConstants.DEBUG_MODE) then
		tooltip:AddLine(itemID, 1,1,0)
	end
	
	-- Other addons support
	if (CanIMogIt and RSConfigDB.IsShowingLootCanimogitTooltip()) then
		tooltip:AddLine(CanIMogIt:GetTooltipText(itemLink))
	end
end