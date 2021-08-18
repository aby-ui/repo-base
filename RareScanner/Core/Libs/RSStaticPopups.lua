-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local LibDialog = LibStub("LibDialog-1.0")

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

LibDialog:Register(RSConstants.START_COLLECTIONS_SCAN, {
	text = AL["START_COLLECTIONS_SCAN"],
	no_close_button = true,
    buttons = {
        {
            text = YES,
            on_click = function(self, mouseButton, down)
                RSCollectionsDB.ApplyCollectionsEntitiesFilters()	
            end,
        },
        {
            text = NO,
            on_click = function(self, mouseButton, down)
                LibDialog:Dismiss(RSConstants.START_COLLECTIONS_SCAN)
            end,
        },
    },          
})

---============================================================================
-- Apply collections filters to loot displayed
---============================================================================

LibDialog:Register(RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS, {
	text = AL["APPLY_COLLECTIONS_LOOT_FILTERS"],
	no_close_button = true,
    buttons = {
        {
            text = YES,
            on_click = function(self, mouseButton, down)
				RSConfigDB.ApplyCollectionsLootFilters(); 
				RSLogger:PrintMessage(AL["LOG_LOOT_FILTERS_APPLIED"])
            end,
        },
        {
            text = NO,
            on_click = function(self, mouseButton, down)
                LibDialog:Dismiss(RSConstants.APPLY_COLLECTIONS_LOOT_FILTERS)
            end,
        },
    },          
})