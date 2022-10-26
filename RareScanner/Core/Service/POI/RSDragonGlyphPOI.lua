-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSDragonGlyphPOI = private.NewLib("RareScannerDragonGlyphPOI")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSDragonGlyphDB = private.ImportLib("RareScannerDragonGlyphDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSDragonGlyphDB = private.ImportLib("RareScannerDragonGlyphDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSLogger = private.ImportLib("RareScannerLogger")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Event POIs
---- Manage adding Event icons to the world map and minimap
---============================================================================

function RSDragonGlyphPOI.GetDragonGlyphPOI(glyphID, mapID, glyphInfo)
	local POI = {}
	POI.entityID = glyphID
	POI.isDragonGlyph = true
	POI.grouping = false
	POI.name = RSDragonGlyphDB.GetDragonGlyphName(glyphID) or AL["DRAGON_GLYPH"]
	POI.mapID = mapID
	POI.x, POI.y = RSDragonGlyphDB.GetInternalDragonGlyphCoordinates(glyphID, mapID)
	POI.achievementLink = GetAchievementLink(glyphID)
	
	-- Textures
	POI.Texture = RSConstants.DRAGON_GLYPH_TEXTURE
	return POI
end

function RSDragonGlyphPOI.GetDragonGlyphPOIs(mapID)
	-- Skip if not showing dragon glyphs icons
	if (not RSConfigDB.IsShowingDragonGlyphs()) then
		return
	end

	local POIs = {}
	for glyphID, glyphInfo in pairs(RSDragonGlyphDB.GetAllInternalDragonGlyphInfo()) do
		local filtered = false

		-- Skip if already completed
		if (RSDragonGlyphDB.isDragonGlyphCollected(glyphID)) then
			RSLogger:PrintDebugMessageEntityID(glyphID, string.format("Saltado Glifo [%s]: Ya completado.", glyphID))
			filtered = true
		end

		-- Skip if the entity belong to a different mapID/artID that the one displaying
		if (not filtered and not RSDragonGlyphDB.IsInternalDragonGlyphInMap(glyphID, mapID)) then
			RSLogger:PrintDebugMessageEntityID(glyphID, string.format("Saltado Glifo [%s]: En distinta zona.", glyphID))
			filtered = true
		end

		-- If not filtered
		if (not filtered) then
			tinsert(POIs, RSDragonGlyphPOI.GetDragonGlyphPOI(glyphID, mapID, glyphInfo))
		end
	end

	return POIs
end