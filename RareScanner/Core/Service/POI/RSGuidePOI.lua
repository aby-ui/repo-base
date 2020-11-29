-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSGuidePOI = private.NewLib("RareScannerGuidePOI")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- Guide auxiliar functions
---============================================================================

local function GetTexture(pinType)
	if (RSUtils.Contains(pinType, RSConstants.TRANSPORT)) then
		return RSConstants.GUIDE_TRANSPORT_TEXTURE
	elseif (RSUtils.Contains(pinType, RSConstants.ENTRANCE)) then
		return RSConstants.GUIDE_ENTRANCE_TEXTURE
	elseif (pinType == RSConstants.PATH_START) then
		return RSConstants.GUIDE_FLAG_TEXTURE
	elseif (RSUtils.Contains(pinType, RSConstants.DOT)) then
		return RSConstants.GUIDE_DOT_TEXTURE
	elseif (RSUtils.Contains(pinType,RSConstants.FLAG)) then
		return RSConstants.GUIDE_FLAG_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP1)) then
		return RSConstants.GUIDE_STEP1_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP2)) then
		return RSConstants.GUIDE_STEP2_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP3)) then
		return RSConstants.GUIDE_STEP3_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP4)) then
		return RSConstants.GUIDE_STEP4_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP5)) then
		return RSConstants.GUIDE_STEP5_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP6)) then
		return RSConstants.GUIDE_STEP6_TEXTURE
	elseif (RSUtils.StartsWith(pinType,RSConstants.STEP7)) then
		return RSConstants.GUIDE_STEP7_TEXTURE
	end
end

local function GetComment(pinType)
	if (RSUtils.Contains(pinType, RSConstants.TRANSPORT)) then
		return AL["GUIDE_TRANSPORT"]
	elseif (RSUtils.Contains(pinType, RSConstants.ENTRANCE)) then
		return AL["GUIDE_ENTRANCE"]
	elseif (pinType == RSConstants.PATH_START) then
		return AL["GUIDE_PATH_START"]
	end

	return nil
end

---============================================================================
-- Guide Map POIs
---- Manage adding Guide icons to the world map and minimap
---============================================================================

function RSGuidePOI.GetGuidePOI(entityID, pinType, guideInfo)
	local POI = {}
	POI.entityID = entityID
	POI.texture = GetTexture(pinType)
	POI.x = guideInfo.x
	POI.y = guideInfo.y

	-- Comment
	local comment
	if (guideInfo.comment) then
		comment = guideInfo.comment
	else
		comment = GetComment(pinType)
	end

	-- Item
	local itemName
	if (guideInfo.itemID) then
		itemName = RSGeneralDB.GetItemName(guideInfo.itemID)
	end

	-- Tooltip
	if (comment or itemName) then
		POI.tooltip = {}
		POI.tooltip.comment = comment
		POI.tooltip.title = itemName
	end

	return POI
end
