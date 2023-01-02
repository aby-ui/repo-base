-- ~disabled

--world quest tracker object
local WorldQuestTracker = WorldQuestTrackerAddon
if (not WorldQuestTracker) then
	return
end

--framework
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00World Quest Tracker: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end

--localization
local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
if (not L) then
	return
end

local GameCooltip = GameCooltip2

local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame

local _

rf.RecentlySpotted = {}
rf.LastPartyRareShared = 0
rf.FullRareListSendCooldown = 0
rf.CommGlobalCooldown = 0
rf.RareSpottedSendCooldown = {}
rf.MinimapScanCooldown = {}

rf.COMM_IDS = {
	RARE_SPOTTED = "RS1",
	RARE_REQUEST = "RR1",
	RARE_LIST = "RL1",
}

--> enum spotted comm indexes
rf.COMM_RARE_SPOTTED = {

	WHOSPOTTED = 2,
	SOURCECHANNEL = 3,
	RARENAME = 4,
	RARESERIAL = 5,
	MAPID = 6,
	PLAYERX = 7,
	PLAYERY = 8,
	ISRELIABLE = 9,
	LOCALTIME = 10,
}

--> enum rare list received comm indexes
rf.COMM_RARE_LIST = {
	--[1] PREFIX (always)
	WHOSENT = 2,
	RARELIST = 3,
	SOURCECHANNEL = 4,
}

--> enum raretable indexes
rf.RARETABLE = {
	TIMESPOTTED = 1;
	MAPID = 2;
	PLAYERX = 3;
	PLAYERY = 4;
	RARESERIAL = 5;
	RARENAME = 6;
	WHOSPOTTED = 7;
	SERVERTIME = 8;
	FROMPREMADE = 9;
}

WorldQuestTracker.RareWidgets = {}