-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSDragonGlyphDB = private.NewLib("RareScannerDragonGlyphDB")

-- RareScanner database libraries
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Collected dragon glyphs database
---============================================================================

function RSDragonGlyphDB.InitDragonGlyphsCollectedDB()
	if (not private.dbchar.dragon_glyphs_collected) then
		private.dbchar.dragon_glyphs_collected = {}
	end
end

function RSDragonGlyphDB.isDragonGlyphCollected(glyphID)
	if (glyphID and private.dbchar.dragon_glyphs_collected[glyphID]) then
		return true;
	else
		local _, _, _, completed, _, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(glyphID)
		if (completed) then
			RSDragonGlyphDB.SetDragonGlyphCollected(glyphID)
			return true
		end
	end

	return false
end

function RSDragonGlyphDB.SetDragonGlyphCollected(glyphID)
	if (glyphID) then
		private.dbchar.dragon_glyphs_collected[glyphID] = RSConstants.ETERNAL_COLLECTED
	end
end

---============================================================================
-- Dragon glyphs internal database
----- Stores information included with the addon
---============================================================================

function RSDragonGlyphDB.GetAllInternalDragonGlyphInfo()
	return private.DRAGON_GLYPHS
end

function RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID)
	if (glyphID) then
		return private.DRAGON_GLYPHS[glyphID]
	end

	return nil
end

function RSDragonGlyphDB.GetInternalDragonGlyphCoordinates(glyphID, mapID)
	if (glyphID and mapID) then
		local dragonGlyphInfo = RSDragonGlyphDB.GetInternalDragonGlyphInfoByMapID(glyphID, mapID)
		if (dragonGlyphInfo and dragonGlyphInfo.x and dragonGlyphInfo.y) then
			return RSUtils.Lpad(dragonGlyphInfo.x, 4, '0'), RSUtils.Lpad(dragonGlyphInfo.y, 4, '0')
		end
	end

	return nil
end

function RSDragonGlyphDB.GetInternalDragonGlyphInfoByMapID(glyphID, mapID)
	if (glyphID and mapID) then
		if (RSDragonGlyphDB.IsInternalDragonGlyphMultiZone(glyphID)) then
			for internalMapID, zoneInfo in pairs (RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID).zoneID) do
				if (internalMapID == mapID or RSMapDB.IsMapInParentMap(mapID, internalMapID)) then
					local dragonGlyphInfo = {}
					RSUtils.CloneTable(RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID), dragonGlyphInfo)
					dragonGlyphInfo.zoneID = internalMapID
					dragonGlyphInfo.x = zoneInfo.x
					dragonGlyphInfo.y = zoneInfo.y
					dragonGlyphInfo.artID = zoneInfo.artID
					return dragonGlyphInfo
				end
			end
		elseif (RSDragonGlyphDB.IsInternalDragonGlyphMonoZone(glyphID)) then
			local dragonGlyphInfo = RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID)
			return dragonGlyphInfo
		end
	end

	return nil
end

function RSDragonGlyphDB.IsInternalDragonGlyphMultiZone(glyphID)
	local dragonGlyphInfo = RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID)
	return dragonGlyphInfo and type(dragonGlyphInfo.zoneID) == "table"
end

function RSDragonGlyphDB.IsInternalDragonGlyphMonoZone(glyphID)
	local dragonGlyphInfo = RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID)
	return dragonGlyphInfo and type(dragonGlyphInfo.zoneID) ~= "table"
end

function RSDragonGlyphDB.IsInternalDragonGlyphInMap(glyphID, mapID)
	if (glyphID and mapID) then
		if (RSDragonGlyphDB.IsInternalDragonGlyphMultiZone(glyphID)) then
			for internalMapID, internalDragonGlyphInfo in pairs(RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID).zoneID) do
				if (internalMapID == mapID and (not internalDragonGlyphInfo.artID or RSUtils.Contains(internalDragonGlyphInfo.artID, C_Map.GetMapArtID(mapID)))) then
					return true;
				end
			end
		elseif (RSDragonGlyphDB.IsInternalDragonGlyphMonoZone(glyphID)) then
			local dragonGlyphInfo = RSDragonGlyphDB.GetInternalDragonGlyphInfo(glyphID)
			if (dragonGlyphInfo.zoneID == mapID and (not dragonGlyphInfo.artID or RSUtils.Contains(dragonGlyphInfo.artID, C_Map.GetMapArtID(mapID)))) then
				return true;
			end
		end
	end

	return false;
end

---============================================================================
-- Dragon glyphs names database
----- Stores names of dragon glyphs included with the addon
---============================================================================

function RSDragonGlyphDB.InitDragonGlyphsNamesDB()
	if (not private.dbglobal.dragon_glyphs_names) then
		private.dbglobal.dragon_glyphs_names = {}
	end

	if (not private.dbglobal.dragon_glyphs_names[GetLocale()]) then
		private.dbglobal.dragon_glyphs_names[GetLocale()] = {}
	end
end

function RSDragonGlyphDB.SetDragonGlyphName(glyphID, name)
	if (glyphID and name) then
		private.dbglobal.dragon_glyphs_names[GetLocale()][glyphID] = name
	end
end

function RSDragonGlyphDB.GetDragonGlyphName(glyphID)
	if (glyphID) then
		if (private.dbglobal.dragon_glyphs_names[GetLocale()][glyphID]) then
			return private.dbglobal.dragon_glyphs_names[GetLocale()][glyphID]
		end
	end

	return nil
end
