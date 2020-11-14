-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSLogger = private.NewLib("RareScannerLogger")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")

function RSLogger:PrintMessage(message)
	print("|cFF00FF00[RareScanner]: |cFFFFFFFF"..message)
end

function RSLogger:PrintDebugMessage(message)
	if (RSConstants.DEBUG_MODE) then
		print("|cFFDC143C[RareScanner]: |cFFFFFFFF"..tostring(message))
	end
end

function RSLogger:PrintDebugMessageEntityID(receivedEntityID, message)
	if (RSConstants.DEBUG_MODE and receivedEntityID and RSConstants.MAP_ENTITY_ID) then
		if (receivedEntityID == RSConstants.MAP_ENTITY_ID) then
			RSLogger:PrintDebugMessage(message)
		end
	end
end

function RSLogger:PrintDebugMessageItemID(receivedItemID, message)
	if (RSConstants.DEBUG_MODE and receivedItemID and RSConstants.LOOT_ITEM_ID) then
		if (receivedItemID == RSConstants.LOOT_ITEM_ID) then
			RSLogger:PrintDebugMessage(message)
		end
	end
end
