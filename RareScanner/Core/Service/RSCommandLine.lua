-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local RSCommandLine = private.NewLib("RareScannerCommandLine")

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner internal libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSLogger = private.ImportLib("RareScannerLogger")

-- RareScanner services
local RSWaypoints = private.ImportLib("RareScannerWaypoints")

-- RareScanner other addons integration services
local RSTomtom = private.ImportLib("RareScannerTomtom")

---============================================================================
-- Command line options
---============================================================================

SLASH_RARESCANNER_CMD1 = "/rarescanner"

SlashCmdList["RARESCANNER_CMD"] = function(command, ...)
	if (command == RSConstants.CMD_TOGGLE_MAP_ICONS) then
		if (not private.db.map.cmdToggle) then
			RSCommandLine.CmdHide()
			private.db.map.cmdToggle = true
		else
			RSCommandLine.CmdShow()
			private.db.map.cmdToggle = false
		end
	elseif (command == RSConstants.CMD_TOGGLE_ALERTS) then
		if (not private.db.general.cmdToggleAlerts) then
			RSCommandLine.CmdDisableAlerts()
			private.db.general.cmdToggleAlerts = true
		else
			RSCommandLine.CmdEnableAlerts()
			private.db.general.cmdToggleAlerts = false
		end
	elseif (command == RSConstants.CMD_TOGGLE_RARES) then
		RSCommandLine.CmdToggleRares()
	elseif (command == RSConstants.CMD_TOGGLE_RARES_ALERTS) then
		RSCommandLine.CmdToggleRaresAlerts()
	elseif (command == RSConstants.CMD_TOGGLE_EVENTS) then
		RSCommandLine.CmdToggleEvents()
	elseif (command == RSConstants.CMD_TOGGLE_EVENTS_ALERTS) then
		RSCommandLine.CmdToggleEventsAlerts()
	elseif (command == RSConstants.CMD_TOGGLE_TREASURES) then
		RSCommandLine.CmdToggleTreasures()
	elseif (command == RSConstants.CMD_TOGGLE_TREASURES_ALERTS) then
		RSCommandLine.CmdToggleTreasuresAlerts()
	elseif (command == RSConstants.CMD_TOGGLE_SCANNING_WORLD_MAP_VIGNETTES) then
		RSCommandLine.CmdToggleScanningWorldmapVignettes()
	elseif (RSUtils.Contains(command, RSConstants.CMD_TOMTOM_WAYPOINT)) then
		local _, npcID, name = strsplit(";", command)
		if (RSConfigDB.IsTomtomSupportEnabled() and not RSConfigDB.IsAddingTomtomWaypointsAutomatically()) then
			RSTomtom.AddTomtomWaypoint(tonumber(npcID), name)
		end
		if (RSConfigDB.IsWaypointsSupportEnabled() and not RSConfigDB.IsAddingWaypointsAutomatically()) then
			RSWaypoints.AddWaypoint(tonumber(npcID))
		end
	else
		print("|cFFFBFF00"..AL["CMD_HELP1"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_MAP_ICONS.." |cFF00FFFB"..AL["CMD_HELP2"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_EVENTS.." |cFF00FFFB"..AL["CMD_HELP3"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_TREASURES.." |cFF00FFFB"..AL["CMD_HELP4"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_RARES.." |cFF00FFFB"..AL["CMD_HELP5"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_ALERTS.." |cFF00FFFB"..AL["CMD_HELP6"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_EVENTS_ALERTS.." |cFF00FFFB"..AL["CMD_HELP7"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_TREASURES_ALERTS.." |cFF00FFFB"..AL["CMD_HELP8"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_RARES_ALERTS.." |cFF00FFFB"..AL["CMD_HELP9"])
		print("|cFFFBFF00   "..SLASH_RARESCANNER_CMD1.." "..RSConstants.CMD_TOGGLE_SCANNING_WORLD_MAP_VIGNETTES.." |cFF00FFFB"..AL["CMD_HELP10"])
	end
end

function RSCommandLine.CmdHide()
	private.db.map.displayNpcIcons = false
	private.db.map.displayContainerIcons = false
	private.db.map.displayEventIcons = false
	RSLogger:PrintMessage(AL["CMD_HIDE"])
end

function RSCommandLine.CmdShow()
	private.db.map.displayNpcIcons = true
	private.db.map.displayContainerIcons = true
	private.db.map.displayEventIcons = true
	RSLogger:PrintMessage(AL["CMD_SHOW"])
end

function RSCommandLine.CmdDisableAlerts()
	private.db.general.scanRares = false
	private.db.general.scanEvents = false
	private.db.general.scanContainers = false
	RSLogger:PrintMessage(AL["CMD_DISABLE_ALERTS"])
end

function RSCommandLine.CmdEnableAlerts()
	private.db.general.scanRares = true
	private.db.general.scanEvents = true
	private.db.general.scanContainers = true
	RSLogger:PrintMessage(AL["CMD_ENABLE_ALERTS"])
end

function RSCommandLine.CmdToggleRares()
	if (private.db.map.displayNpcIcons) then
		private.db.map.displayNpcIcons = false
		RSLogger:PrintMessage(AL["CMD_HIDE_RARES"])
	else
		private.db.map.displayNpcIcons = true
		RSLogger:PrintMessage(AL["CMD_SHOW_RARES"])
	end
end

function RSCommandLine.CmdToggleRaresAlerts()
	if (private.db.general.scanRares) then
		private.db.general.scanRares = false
		RSLogger:PrintMessage(AL["CMD_DISABLE_RARES_ALERTS"])
	else
		private.db.general.scanRares = true
		RSLogger:PrintMessage(AL["CMD_ENABLE_RARES_ALERTS"])
	end
end

function RSCommandLine.CmdToggleEvents()
	if (private.db.map.displayEventIcons) then
		private.db.map.displayEventIcons = false
		RSLogger:PrintMessage(AL["CMD_HIDE_EVENTS"])
	else
		private.db.map.displayEventIcons = true
		RSLogger:PrintMessage(AL["CMD_SHOW_EVENTS"])
	end
end

function RSCommandLine.CmdToggleEventsAlerts()
	if (private.db.general.scanEvents) then
		private.db.general.scanEvents = false
		RSLogger:PrintMessage(AL["CMD_DISABLE_EVENTS_ALERTS"])
	else
		private.db.general.scanEvents = true
		RSLogger:PrintMessage(AL["CMD_ENABLE_EVENTS_ALERTS"])
	end
end

function RSCommandLine.CmdToggleTreasures()
	if (private.db.map.displayContainerIcons) then
		private.db.map.displayContainerIcons = false
		RSLogger:PrintMessage(AL["CMD_HIDE_TREASURES"])
	else
		private.db.map.displayContainerIcons = true
		RSLogger:PrintMessage(AL["CMD_SHOW_TREASURES"])
	end
end

function RSCommandLine.CmdToggleTreasuresAlerts()
	if (private.db.general.scanContainers) then
		private.db.general.scanContainers = false
		RSLogger:PrintMessage(AL["CMD_DISABLE_CONTAINERS_ALERTS"])
	else
		private.db.general.scanContainers = true
		RSLogger:PrintMessage(AL["CMD_ENABLE_CONTAINERS_ALERTS"])
	end
end

function RSCommandLine.CmdToggleScanningWorldmapVignettes()
	if (private.db.general.scanWorldmapVignette) then
		private.db.general.scanWorldmapVignette = false
		RSLogger:PrintMessage(AL["CMD_DISABLE_SCANNING_WORLDMAP_VIGNETTES"])
	else
		private.db.general.scanWorldmapVignette = true
		RSLogger:PrintMessage(AL["CMD_ENABLE_SCANNING_WORLDMAP_VIGNETTES"])
	end
end
