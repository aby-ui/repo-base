-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")

-- RareScanner libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSTimeUtils = private.ImportLib("RareScannerTimeUtils")
local RSConstants = private.ImportLib("RareScannerConstants")

-- RareScanner services libraries
local RSTooltip = private.ImportLib("RareScannerTooltip")
local RSEntityStateHandler = private.ImportLib("RareScannerEntityStateHandler")

-- Next spawn timer
local NEXT_RESPAWN = 600 --10 minutes

-- Icecrown rares order (pre-patch 9.0.1)
local SHADOWLANDS_RARES_SPAWNING_ORDER = {174065,174064,174063,174062,174061,174060,174059,174058,174057,174056,174055,174054,174053,174052,174051,174050,174049,174048,174067,174066};

local function ShadowlandsPrePatch_CalculateSpawningTimers(npcID)
	local nextSpawningNPC = nil
	if (npcID and RSUtils.Contains(SHADOWLANDS_RARES_SPAWNING_ORDER, npcID)) then
		private.dbglobal.shadowlandsSpawningTimers = {}

		local nextSpawning = time() + NEXT_RESPAWN
		local initFound = false
		for i, orderNpcID in ipairs (SHADOWLANDS_RARES_SPAWNING_ORDER) do
			if (not initFound and orderNpcID == npcID) then
				initFound = true
			elseif (initFound) then
				if (not nextSpawningNPC) then
					nextSpawningNPC = orderNpcID
				end
				private.dbglobal.shadowlandsSpawningTimers[orderNpcID] = nextSpawning
				nextSpawning = nextSpawning + NEXT_RESPAWN
			end
		end

		for i, orderNpcID in ipairs (SHADOWLANDS_RARES_SPAWNING_ORDER) do
			if (orderNpcID ~= npcID) then
				if (not nextSpawningNPC) then
					nextSpawningNPC = orderNpcID
				end
				private.dbglobal.shadowlandsSpawningTimers[orderNpcID] = nextSpawning
				nextSpawning = nextSpawning + NEXT_RESPAWN
			else
				break
			end
		end

		private.dbglobal.shadowlandsSpawningTimers[npcID] = nextSpawning
	end

	return nextSpawningNPC
end

local function ShadowlandsPrePatch_PrintNextSpawn(npcID)
	local nextSpawningNPC = ShadowlandsPrePatch_CalculateSpawningTimers(npcID)
	if (nextSpawningNPC) then
		local name = RSNpcDB.GetNpcName(nextSpawningNPC)
		if (name) then
			RSLogger:PrintMessage(string.format(AL["SHADOWLANDS_PRE_PATCH_NEXTSPAWN"], name))
			RSGeneralDB.SetRecentlySeen(nextSpawningNPC)
		end
	end
end

local function ShadowlandsPrePatch_AddNextSpawningTimerCell(tooltip, npcID)
	if (private.dbglobal.shadowlandsSpawningTimers and private.dbglobal.shadowlandsSpawningTimers[npcID]) then
		local timeLeft = private.dbglobal.shadowlandsSpawningTimers[npcID] - time()
		if (timeLeft > 0) then
			local line = tooltip:AddLine()
			tooltip:SetCell(line, 1, string.format(AL["SHADOWLANDS_PRE_PATCH_SPAWNINGTIMER"], RSUtils.TextColor(RSTimeUtils.TimeStampToClock(timeLeft), "FF8000")), nil, "LEFT", 10)
		end
	end
end

function RareScanner:ShadowlandsPrePatch_Initialize()
	-- Add hooks wherever we need them
	if (not RSConstants.EVENTS[RSConstants.SHADOWLANDS_PRE_PATCH_EVENT]) then
		return
	end

	local original_SetVignetteFound = self.SetVignetteFound
	function self:SetVignetteFound(vignetteID, isNavigating, npcID)
		original_SetVignetteFound(self, vignetteID, isNavigating, npcID);
		ShadowlandsPrePatch_CalculateSpawningTimers(npcID);
	end

	local original_SetDeadNpcByZone = RSEntityStateHandler.SetDeadNpcByZone
	function RSEntityStateHandler.SetDeadNpcByZone(npcID, zoneID, forzed)
		original_SetDeadNpcByZone(self, npcID, zoneID, forzed)
		ShadowlandsPrePatch_PrintNextSpawn(npcID)
	end

	local original_AddSpecialEventsLines = RSTooltip.AddSpecialEventsLines
	function RSTooltip.AddSpecialEventsLines(pin, tooltip)
		original_AddSpecialEventsLines(self, pin, tooltip);
		ShadowlandsPrePatch_AddNextSpawningTimerCell(tooltip, pin.POI.entityID)
	end
end
