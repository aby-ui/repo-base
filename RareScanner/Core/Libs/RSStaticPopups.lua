-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSCollectionsDB = private.ImportLib("RareScannerCollectionsDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")

---============================================================================
-- Start collections scan
---============================================================================

StaticPopupDialogs[RSConstants.START_COLLECTIONS_SCAN] = {
	text = AL["START_COLLECTIONS_SCAN"],
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) 
		RSCollectionsDB.ApplyCollectionsEntitiesFilters()	
	end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
}
---============================================================================
-- Apply collections filters to loot displayed
---============================================================================

StaticPopupDialogs[RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS] = {
	text = AL["APPLY_COLLECTIONS_LOOT_FILTERS"],
	button1 = YES,
	button2 = NO,
	OnAccept = function (self) 
		RSConfigDB.ApplyCollectionsLootFilters(); 
		RSLogger:PrintMessage(AL["LOG_LOOT_FILTERS_APPLIED"])
	end,
	OnCancel = function (self) end,
	hideOnEscape = 1,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
}