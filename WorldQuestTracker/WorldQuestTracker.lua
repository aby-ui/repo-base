
--/dump BrokenIslesArgusButton:IsProtected()

--[=[
--WorldMapButton:HookScript ("PreClick", deny_auto_switch)

doesnt existst any more:

WorldMapButton
WorldMap_CreatePOI
WorldMap_GetOrCreateTaskPOI
WorldMap_UpdateQuestBonusObjectives

WorldMapScrollFrame - sub by WorldMapFrame.ScrollContainer
WorldMapFrame_InWindowedMode - sub by WorldMapFrame.isMaximized

/run WorldQuestTrackerAddon.UpdateZoneWidgets (true)


function WorldMapMixin:AddOverlayFrame(templateName, templateType, anchorPoint, relativeTo, relativePoint, offsetX, offsetY)
this return the bounty board frame, just check if templatename is "WorldMapBountyBoardTemplate"



--]=]

hooksecurefunc (WorldQuestDataProviderMixin, "RefreshAllData", function (self, fromOnShow)
	--is triggering each 0.5 seconds
	--print ("WorldQuestDataProviderMixin.RefreshAllData", "fromOnShow", fromOnShow)
end)

hooksecurefunc (WorldQuestPinMixin, "RefreshVisuals", function (pin)
	--print ("WorldQuestDataProviderMixin.RefreshVisuals", "pin id:", pin.questID)
end)



--details! framework
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00World Quest Tracker: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end

local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
if (not L) then
	print ("|cFFFFAA00World Quest Tracker|r: Reopen your client to finish updating the addon.|r")
	print ("|cFFFFAA00World Quest Tracker|r: Reopen your client to finish updating the addon.|r")
	print ("|cFFFFAA00World Quest Tracker|r: Reopen your client to finish updating the addon.|r")
	return
end

if (true) then
	--return - nah, not today
end


local WorldQuestTracker = WorldQuestTrackerAddon
local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame



-- 219978
-- /run SetSuperTrackedQuestID(44033);
-- TaskPOI_OnClick
 


local GameCooltip = GameCooltip2
--local Saturate = Saturate
local floor = floor
--local ceil = ceil
--local ipairs = ipairs
local GetItemInfo = GetItemInfo
local GetCurrentMapZone = GetCurrentMapZone
local GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsForPlayerByMapID
local HaveQuestData = HaveQuestData
local QuestMapFrame_IsQuestWorldQuest = QuestMapFrame_IsQuestWorldQuest or QuestUtils_IsQuestWorldQuest
local GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local GetQuestTagInfo = GetQuestTagInfo
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID
local GetQuestTimeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

--importing FindLookAtRotation
if (not FindLookAtRotation) then
	FindLookAtRotation = function (_, x1, y1, x2, y2)
		return atan2 (y2 - y1, x2 - x1) + pi
	end
end

local _

-------------------------------------------------------------------------------------------------------------------
--search checkpoint: ~8 ~bfa ~kultiras ~zandalar


--[=[
	8.0 notepad
	
	- which zones will have world quests?
	- what's the garrison resource for this expansion?
	- check for new rewards
	
	
	need new functions for:
		- check for the player current standing map	
		- get the current map shown in the map frame
	
	notes:
		WorldMapFrame.currentStandingZone > might need changes
		
		Check if self <WorldMapFrame>.mapID still keep the mapID
		
		WorldQuestTracker.IsASubLevel() might need to be updated
		
		All argus and broken shore related functions can be removed
		
		WorldQuestTracker.GetCurrentMapAreaID() might have to be replaced
		
		Cleanup removing all these locals with the zone name and mapId
	
		Remove the filter exceptions
		
--> BfA world quest zones:
local PLACEHOLDER_MAPID = 0

local BATTLE_FOR_AZEROTH_ZONES = {
	--Zandalar horde zones
		--Nazmir
		[PLACEHOLDER_MAPID] = true,
		--Zuldazar
		[PLACEHOLDER_MAPID] = true,
		--Voldun
		[PLACEHOLDER_MAPID] = true,
	
	--Kul Tiras aliance zones
		--Stormsong Valley
		[PLACEHOLDER_MAPID] = true,
		--Drustvar
		[PLACEHOLDER_MAPID] = true,
		--Tiragarde Sound
		[PLACEHOLDER_MAPID] = true,
}


--]=]
-------------------------------------------------------------------------------------------------------------------

WorldQuestTracker.QuestTrackList = {} --place holder until OnInit is triggered
WorldQuestTracker.AllTaskPOIs = {}
WorldQuestTracker.JustAddedToTracker = {}
WorldQuestTracker.Cache_ShownQuestOnWorldMap = {}
WorldQuestTracker.Cache_ShownQuestOnZoneMap = {}
WorldQuestTracker.Cache_ShownWidgetsOnZoneMap = {}
WorldQuestTracker.WorldMapSupportWidgets = {}
WorldQuestTracker.PartyQuestsPool = {}
WorldQuestTracker.CurrentZoneQuests = {}
WorldQuestTracker.CachedQuestData = {}
WorldQuestTracker.CurrentMapID = 0
WorldQuestTracker.LastWorldMapClick = 0
WorldQuestTracker.MapSeason = 0
WorldQuestTracker.MapOpenedAt = 0
WorldQuestTracker.QueuedRefresh = 1
WorldQuestTracker.WorldQuestButton_Click = 0
WorldQuestTracker.Temp_HideZoneWidgets = 0
WorldQuestTracker.lastZoneWidgetsUpdate = 0
WorldQuestTracker.lastMapTap = 0
WorldQuestTracker.LastGFSearch = 0
WorldQuestTracker.SoundPitch = math.random (2)
WorldQuestTracker.RarityColors = {
	[3] = "|cff2292FF",
	[4] = "|cffc557FF",
}
WorldQuestTracker.GameLocale = GetLocale()
WorldQuestTracker.COMM_PREFIX = "WQTC"

local LibWindow = LibStub ("LibWindow-1.1")
if (not LibWindow) then
	print ("|cFFFFAA00World Quest Tracker|r: libwindow not found, did you just updated the addon? try reopening the client.|r")
end

local ARROW_UPDATE_FREQUENCE = 0.016

local WorldMapScrollFrame = WorldMapFrame.ScrollContainer




----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> initialize the addon

local reGetTrackerList = function()
	C_Timer.After (.2, WorldQuestTracker.GetTrackedQuestsOnDB)
end
function WorldQuestTracker.GetTrackedQuestsOnDB()
	local GUID = UnitGUID ("player")
	if (not GUID) then
		reGetTrackerList()
		WorldQuestTracker.QuestTrackList = {}
		return
	end
	local questList = WorldQuestTracker.db.profile.quests_tracked [GUID]
	if (not questList) then
		questList = {}
		WorldQuestTracker.db.profile.quests_tracked [GUID] = questList
	end
	WorldQuestTracker.QuestTrackList = questList
	
	--> faz o cliente carregar as quests antes de realmente verificar o tempo restante
	
	if (not WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load) then
		
		print ("WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load MISSING")
		return
		
	end
	
	C_Timer.After (3, WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load)
	C_Timer.After (4, WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load)
	C_Timer.After (6, WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker_Load)
	C_Timer.After (10, WorldQuestTracker.CheckTimeLeftOnQuestsFromTracker)
	
	WorldQuestTracker.RefreshTrackerWidgets()
end

function WorldQuestTracker.Debug (message, color)
	if (WorldQuestTracker.debug) then
		if (color == 1) then
			print ("|cFFFFFF44[WQT]|r", "|cFFDDDDDD(debug)|r", "|cFFFF8800" .. message .. "|r")
		elseif (color == 2) then
			print ("|cFFFFFF44[WQT]|r", "|cFFDDDDDD(debug)|r", "|cFFFFFF00" .. message .. "|r")
		else
			print ("|cFFFFFF44[WQT]|r", "|cFFDDDDDD(debug)|r", message)
		end
	end
end

function WorldQuestTracker:OnInit()
	WorldQuestTracker.InitAt = GetTime()
	WorldQuestTracker.LastMapID = WorldQuestTracker.GetCurrentMapAreaID()
	WorldQuestTracker.GetTrackedQuestsOnDB()
	
	WorldQuestTracker.CreateLoadingIcon()
	
	WQTrackerDBChr = WQTrackerDBChr or {}
	WorldQuestTracker.dbChr = WQTrackerDBChr
	WorldQuestTracker.dbChr.ActiveQuests = WorldQuestTracker.dbChr.ActiveQuests or {}
	
	local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")
	SharedMedia:Register ("statusbar", "Iskar Serenity", [[Interface\AddOns\WorldQuestTracker\media\bar_serenity]])
	
	C_Timer.After (2, function()
		if (WorldQuestTracker.db:GetCurrentProfile() ~= "Default") then
			WorldQuestTracker.db:SetProfile ("Default")
			if (LibWindow) then
				if (WorldQuestTracker.db:GetCurrentProfile() == "Default") then
					LibWindow.RegisterConfig (WorldQuestTrackerScreenPanel, WorldQuestTracker.db.profile)
					if (WorldQuestTracker.db.profile.tracker_is_movable) then
						LibWindow.RestorePosition (WorldQuestTrackerScreenPanel)
						WorldQuestTrackerScreenPanel.RegisteredForLibWindow = true
					end
				end
			end
		end
	end)

	if (LibWindow) then
		if (WorldQuestTracker.db:GetCurrentProfile() == "Default") then
			LibWindow.RegisterConfig (WorldQuestTrackerScreenPanel, WorldQuestTracker.db.profile)
			if (WorldQuestTracker.db.profile.tracker_is_movable) then
				LibWindow.RestorePosition (WorldQuestTrackerScreenPanel)
				WorldQuestTrackerScreenPanel.RegisteredForLibWindow = true
			end
			
			if (not WorldQuestTrackerFinderFrame.IsRegistered) then
				WorldQuestTracker.RegisterGroupFinderFrameOnLibWindow()
			end
		end
	end
	
	function WorldQuestTracker:CleanUpJustBeforeGoodbye()
		WorldQuestTracker.AllCharactersQuests_CleanUp()
	end
	WorldQuestTracker.db.RegisterCallback (WorldQuestTracker, "OnDatabaseShutdown", "CleanUpJustBeforeGoodbye") --more info at https://www.youtube.com/watch?v=GXFnT4YJLQo
	
	local save_player_name = function()
		local guid = UnitGUID ("player")
		local name = UnitName ("player")
		local realm = GetRealmName()
		if (guid and name and name ~= "" and realm and realm ~= "") then
			local playerTable = WorldQuestTracker.db.profile.player_names [guid]
			if (not playerTable) then
				playerTable = {}
				WorldQuestTracker.db.profile.player_names [guid] = playerTable
			end
			playerTable.name = name
			playerTable.realm = realm
			playerTable.class = playerTable.class or select (2, UnitClass ("player"))
		end
	end
	
	C_Timer.After (3, save_player_name)
	C_Timer.After (10, save_player_name)
	C_Timer.After (11, WorldQuestTracker.RequestRares)
	C_Timer.After (12, WorldQuestTracker.CheckForOldRareFinderData)
	
	local canLoad = IsQuestFlaggedCompleted (WORLD_QUESTS_AVAILABLE_QUEST_ID)
	
	local re_ZONE_CHANGED_NEW_AREA = function()
		WorldQuestTracker:ZONE_CHANGED_NEW_AREA()
	end
	
	function WorldQuestTracker.IsInvasionPoint()
		if (ff:IsShown()) then
			return
		end
		
		local mapInfo = WorldQuestTracker.GetMapInfo()
		local mapFileName = mapInfo and mapInfo.name
		
		--> we are using where the map file name which always start with "InvasionPoint"
		--> this makes easy to localize group between different languages on the group finder
		--> this won't work with greater invasions which aren't scenarios
		
		if (mapFileName and mapFileName:find ("InvasionPoint")) then
			--the player is inside a invasion
			local invasionName = C_Scenario.GetInfo()
			if (invasionName) then
				--> is search for invasions enabled?
				if (WorldQuestTracker.db.profile.groupfinder.invasion_points) then
					--> can queue?
					if (not IsInGroup() and not QueueStatusMinimapButton:IsShown()) then
						local callback = nil
						local ENNameFromMapFileName = mapFileName:gsub ("InvasionPoint", "")
						if (ENNameFromMapFileName and WorldQuestTracker.db.profile.rarescan.always_use_english) then
							WorldQuestTracker.FindGroupForCustom ("Invasion Point: " .. (ENNameFromMapFileName or ""), invasionName, L["S_GROUPFINDER_ACTIONS_SEARCH"], "Doing Invasion Point " .. invasionName .. ". Group created with World Quest Tracker #EN Invasion Point: " .. (ENNameFromMapFileName or "") .. " ", 0, callback)
						else
							WorldQuestTracker.FindGroupForCustom (invasionName, invasionName, L["S_GROUPFINDER_ACTIONS_SEARCH"], "Doing Invasion Point " .. invasionName .. ". Group created with World Quest Tracker #EN Invasion Point: " .. (ENNameFromMapFileName or "") .. " ", 0, callback)
						end
					else
						WorldQuestTracker:Msg (L["S_GROUPFINDER_QUEUEBUSY2"])
					end
				end
			end
		end
	end
	
	function WorldQuestTracker:ZONE_CHANGED_NEW_AREA()
		if (IsInInstance()) then
			WorldQuestTracker:FullTrackerUpdate()
		else
			WorldQuestTracker:FullTrackerUpdate()
			
			if (WorldMapFrame:IsShown()) then
				return WorldQuestTracker:WaitUntilWorldMapIsClose()
			else
				C_Timer.After (.5, WorldQuestTracker.UpdateCurrentStandingZone)
			end
		end
		
		local mapInfo = WorldQuestTracker.GetMapInfo()
		local mapFileName = mapInfo and mapInfo.name
		
		if (not mapFileName) then
			C_Timer.After (3, WorldQuestTracker.IsInvasionPoint)
		else
			WorldQuestTracker.IsInvasionPoint()
			--> trigger once more since on some clientes MapInfo() is having a delay on update the correct map
			C_Timer.After (1, WorldQuestTracker.IsInvasionPoint)
			C_Timer.After (2, WorldQuestTracker.IsInvasionPoint)
		end
	end
	
	-- ~reward ~questcompleted
	local oneday = 60*60*24
	local days_amount = {
		[WQT_DATE_1WEEK] = 8,
		[WQT_DATE_2WEEK] = 15,
		[WQT_DATE_MONTH] = 30,
	}
	
	function WorldQuestTracker.GetDateString (t)
		if (t == WQT_DATE_TODAY) then
			return date ("%y%m%d")
		elseif (t == WQT_DATE_YESTERDAY) then
			return date ("%y%m%d", time() - oneday)
		elseif (t == WQT_DATE_1WEEK or t == WQT_DATE_2WEEK or t == WQT_DATE_MONTH) then
			local days = days_amount [t]
			local result = {}
			for i = 1, days do
				tinsert (result, date ("%y%m%d", time() - (oneday * (i-1) )))
			end
			return result
		else
			return t
		end
	end
	
	function WorldQuestTracker.GetCharInfo (guid)
		local t = WorldQuestTracker.db.profile.player_names [guid]
		if (t) then
			return t.name, t.realm, t.class
		else
			return "Unknown", "Unknown", "PRIEST"
		end
	end
	
	function WorldQuestTracker.QueryHistory (queryType, dbLevel, arg1, arg2, arg3)
		local db = WorldQuestTracker.db.profile.history
		db = db [queryType]
		db = db [dbLevel]

		if (dbLevel == WQT_QUERYDB_LOCAL) then
			db = db [UnitGUID ("player")]
			if (not db) then
				return
			end
		end
		
		if (not arg1) then
			return db
		end
		
		if (queryType == WQT_QUERYTYPE_REWARD) then
			return db [arg1] --arg1 = the reward type (gold, resource, artifact)
			
		elseif (queryType == WQT_QUERYTYPE_QUEST) then
			return db [arg1] --arg1 = the questID
			
		elseif (queryType == WQT_QUERYTYPE_PERIOD) then
			
			local dateString = WorldQuestTracker.GetDateString (arg1)
			
			if (type (dateString) == "table") then --mais de 1 dia
				--quer saber da some total ou quer dia a dia para fazer um gr�fico
				local result = {}
				local total = 0
				local dayTable = dateString

				for i = 1, #dayTable do --table com v�rias strings representando dias
					local day = db [dayTable [i]]
					if (day) then
						if (arg2) then
							total = total + (day [arg2] or 0)
						else
							tinsert (result, {["day"] = dayTable [i], ["table"] = day})
						end
					end
				end
				
				if (arg2) then
					return total
				else
					return result
				end
				
			else --um unico dia
				if (arg2) then --pediu apenas 1 reward
					db = db [dateString] --tabela do dia
					if (db) then
						return db [arg2] --quantidade de recursos
					end
					return
				end
				return db [dateString] --arg1 = data0 / retorna a tabela do dia com todos os rewards
			end
		end
	
	end
	
	-- ~completed ~questdone
	function WorldQuestTracker:QUEST_TURNED_IN (event, questID, XP, gold)

		--> Court of Farondis 42420
		--> The Dreamweavers 42170
		--print ("world quest:", questID, QuestMapFrame_IsQuestWorldQuest (questID), XP, gold)
	
		if (QuestMapFrame_IsQuestWorldQuest (questID)) then
			--print (event, questID, XP, gold)
			--QUEST_TURNED_IN 44300 0 772000
			-- QINFO: 0 nil nil Petrified Axe Haft true 370
			
			WorldQuestTracker.AllCharactersQuests_Remove (questID)
			WorldQuestTracker.RemoveQuestFromTracker (questID)
			
			FlashClientIcon()
			
			if (QuestMapFrame_IsQuestWorldQuest (questID)) then --wait, is this inception?
				--local title, questType, texture, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, selected, isSpellTarget, timeLeft, isCriteria, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable = WorldQuestTracker:GetQuestFullInfo (questID)
				local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount = WorldQuestTracker.GetOrLoadQuestData (questID)
				
				--print (title, questType, texture, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex)
				--Retake the Skyhorn 8 Interface\AddOns\WorldQuestTracker\media\icon_artifactpower_redT_round 1828 109 World Quest 3 1 false nil				
				
				--print ("QINFO:", goldFormated, rewardName, numRewardItems, itemName, isArtifact, artifactPower)
				
				local questHistory = WorldQuestTracker.db.profile.history
				
				local guid = UnitGUID ("player")
				local today = date ("%y%m%d") -- YYMMDD
				
				local itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable = WorldQuestTracker.GetQuestReward_Item (questID)
				--print ("WQT", itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable)
				--WQT Blood of Sargeras 1417744 110 1 3 true 124124 false 0 true
				
				--quanto de gold recursos e poder de artefato ganho na conta e no personagem (� o total)
				local rewardHistory = questHistory.reward
					local _global = rewardHistory.global
					local _local = rewardHistory.character [guid]
					if (not _local) then
						_local = {}
						rewardHistory.character [guid] = _local
					end
					
					if (gold and gold > 0) then
						_global ["gold"] = _global ["gold"] or 0
						_local ["gold"] = _local ["gold"] or 0
						_global ["gold"] = _global ["gold"] + gold
						_local ["gold"] = _local ["gold"] + gold
						
						--print ("Gold added:", _global ["gold"], _local ["gold"])
					end
					
					if (isArtifact) then
						_global ["artifact"] = _global ["artifact"] or 0
						_local ["artifact"] = _local ["artifact"] or 0
						_global ["artifact"] = _global ["artifact"] + artifactPower
						_local ["artifact"] = _local ["artifact"] + artifactPower
						
						--print ("Artifact added:", _global ["artifact"], _local ["artifact"])
					end
					
					if (rewardName) then --class hall resource
						_global ["resource"] = _global ["resource"] or 0
						_local ["resource"] = _local ["resource"] or 0
						_global ["resource"] = _global ["resource"] + numRewardItems
						_local ["resource"] = _local ["resource"] + numRewardItems
						
						--print ("Resource added:", _global ["resource"], _local ["resource"])
					end
					
					--trade skill - blood of sargeras
					if (itemID == 124124) then
						_global ["blood"] = (_global ["blood"] or 0) + quantity
						_local ["blood"] = (_local ["blood"] or 0) + quantity
					end
					
					--professions
					--print ("itemID:", itemID)
					if (tradeskillLineIndex) then
						--print ("eh profissao 1", tradeskillLineIndex)
						local tradeskillLineID = tradeskillLineIndex and select (7, GetProfessionInfo(tradeskillLineIndex))
						if (tradeskillLineID) then
							--print ("eh profissao 2", tradeskillLineID)
							if (itemID) then
								--print ("eh profissao 3", itemID)
								_global ["profession"] = _global ["profession"] or {}
								_local ["profession"] = _local ["profession"] or {}
								_global ["profession"] [itemID] = (_global ["profession"] [itemID] or 0) + 1
								_local ["profession"] [itemID] = (_local ["profession"] [itemID] or 0) + 1
								--print ("local global 3", _local ["profession"] [itemID], _global ["profession"] [itemID])
							end
						end
					end
				
				--quais quest ja foram completadas e quantas vezes
				local questDoneHistory = questHistory.quest
					local _global = questDoneHistory.global
					local _local = questDoneHistory.character [guid]
					if (not _local) then
						_local = {}
						questDoneHistory.character [guid] = _local
					end
					_global [questID] = (_global [questID] or 0) + 1
					_local [questID] = (_local [questID] or 0) + 1
					_global ["total"] = (_global ["total"] or 0) + 1
					_local ["total"] = (_local ["total"] or 0) + 1
				
				--estat�sticas dia a dia
				local periodHistory = questHistory.period
					local _global = periodHistory.global
					local _local = periodHistory.character [guid]
					if (not _local) then
						_local = {}
						periodHistory.character [guid] = _local
					end
					
					local _globalToday = _global [today]
					local _localToday = _local [today]
					if (not _globalToday) then
						_globalToday = {}
						_global [today] = _globalToday
					end
					if (not _localToday) then
						_localToday = {}
						_local [today] = _localToday
					end
					
					_globalToday ["quest"] = (_globalToday ["quest"] or 0) + 1
					_localToday ["quest"] = (_localToday ["quest"] or 0) + 1
					
					if (itemID == 124124) then
						_globalToday ["blood"] = (_globalToday ["blood"] or 0) + quantity
						_localToday ["blood"] = (_localToday ["blood"] or 0) + quantity
					end
					
					if (tradeskillLineIndex) then
						--print ("eh profissao today 4", tradeskillLineIndex)
						local tradeskillLineID = tradeskillLineIndex and select (7, GetProfessionInfo (tradeskillLineIndex))
						if (tradeskillLineID) then
							--print ("eh profissao today 5", tradeskillLineID)
							if (itemID) then
								--print ("eh profissao today 6", itemID)
								_globalToday ["profession"] = _globalToday ["profession"] or {}
								_localToday ["profession"] = _localToday ["profession"] or {}
								_globalToday ["profession"] [itemID] = (_globalToday ["profession"] [itemID] or 0) + 1
								_localToday ["profession"] [itemID] = (_localToday ["profession"] [itemID] or 0) + 1
								--print ("local global today 6", _localToday ["profession"] [itemID], _globalToday ["profession"] [itemID])
							end
						end
					end
					
					if (gold and gold > 0) then
						_globalToday ["gold"] = _globalToday ["gold"] or 0
						_localToday ["gold"] = _localToday ["gold"] or 0
						_globalToday ["gold"] = _globalToday ["gold"] + gold
						_localToday ["gold"] = _localToday ["gold"] + gold
					end
					if (isArtifact) then
						_globalToday ["artifact"] = _globalToday ["artifact"] or 0
						_localToday ["artifact"] = _localToday ["artifact"] or 0
						_globalToday ["artifact"] = _globalToday ["artifact"] + artifactPower
						_localToday ["artifact"] = _localToday ["artifact"] + artifactPower
					end
					if (rewardName) then --class hall resource
						_globalToday ["resource"] = _globalToday ["resource"] or 0
						_localToday ["resource"] = _localToday ["resource"] or 0
						_globalToday ["resource"] = _globalToday ["resource"] + numRewardItems
						_localToday ["resource"] = _localToday ["resource"] + numRewardItems
					end
				
			end
		end
	end
	
	function WorldQuestTracker:QUEST_LOOT_RECEIVED (event, questID, item, amount, ...)
		--print ("LOOT", questID, item, amount, ...)
		if (QuestMapFrame_IsQuestWorldQuest (questID)) then
		--	local title, questType, texture, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, selected, isSpellTarget, timeLeft, isCriteria, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable = WorldQuestTracker:GetQuestFullInfo (questID)
		--	print ("QINFO:", goldFormated, rewardName, numRewardItems, itemName, isArtifact, artifactPower)
		end
	end
	
    WorldQuestTracker.TAXIMAP_OPENED = noop
    WorldQuestTracker.TAXIMAP_CLOSED = noop  --aby8 disable WorldQuestTracker_Taxi.lua
	WorldQuestTracker:RegisterEvent ("TAXIMAP_OPENED")
	WorldQuestTracker:RegisterEvent ("TAXIMAP_CLOSED")
	WorldQuestTracker:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
	WorldQuestTracker:RegisterEvent ("QUEST_TURNED_IN")
	WorldQuestTracker:RegisterEvent ("QUEST_LOOT_RECEIVED")
	WorldQuestTracker:RegisterEvent ("PLAYER_STARTED_MOVING")
	WorldQuestTracker:RegisterEvent ("PLAYER_STOPPED_MOVING")
	
	C_Timer.After (.5, WorldQuestTracker.ZONE_CHANGED_NEW_AREA)
	C_Timer.After (.5, WorldQuestTracker.UpdateArrowFrequence)
	C_Timer.After (5, WorldQuestTracker.UpdateArrowFrequence)
	C_Timer.After (10, WorldQuestTracker.UpdateArrowFrequence)
end

local onStartClickAnimation = function (self)
	self:GetParent():Show()
end
local onEndClickAnimation = function (self)
	self:GetParent():Hide()
end


	--formata o tempo restante que a quest tem
	local D_HOURS = "%dH"
	local D_DAYS = "%dD"
	function WorldQuestTracker.GetQuest_TimeLeft (questID, formated)
		local timeLeftMinutes = GetQuestTimeLeftMinutes (questID)
		if (formated) then
			local timeString
			if ( timeLeftMinutes <= WORLD_QUESTS_TIME_CRITICAL_MINUTES ) then
				timeString = SecondsToTime (timeLeftMinutes * 60)
			elseif timeLeftMinutes <= 60 + WORLD_QUESTS_TIME_CRITICAL_MINUTES then
				timeString = SecondsToTime ((timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) * 60)
			elseif timeLeftMinutes < 24 * 60 + WORLD_QUESTS_TIME_CRITICAL_MINUTES then
				timeString = D_HOURS:format(math.floor(timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) / 60)
			else
				timeString = D_DAYS:format(math.floor(timeLeftMinutes - WORLD_QUESTS_TIME_CRITICAL_MINUTES) / 1440)
			end
			
			return timeString
		else
			return timeLeftMinutes
		end
	end

	--pega os dados da quest
	function WorldQuestTracker.GetQuest_Info (questID)
		if (not HaveQuestData (questID)) then
			return
		end
		local title, factionID = GetQuestInfoByQuestID (questID)
		local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = GetQuestTagInfo (questID)
		return title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex
	end

	--pega o icone para as quest que dao goild
	local goldCoords = {0, 1, 0, 1}
	function WorldQuestTracker.GetGoldIcon()
		return [[Interface\GossipFrame\auctioneerGossipIcon]], goldCoords
	end



	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--saved quests on other characters
	
	--pega a lista de quests que o jogador tem dispon�vel
	function WorldQuestTracker.SavedQuestList_GetList()
		return WorldQuestTracker.dbChr.ActiveQuests
	end
	-- ~saved ~pool ~data ~allquests �ll
	local map_seasons = {}
	function WorldQuestTracker.SavedQuestList_IsNew (questID)
		if (WorldQuestTracker.MapSeason == 0) then
			--o mapa esta carregando e n�o mandou o primeiro evento ainda
			return false
		end

		local ActiveQuests = WorldQuestTracker.SavedQuestList_GetList()
		
		if (ActiveQuests [questID]) then --a quest esta armazenada
			if (map_seasons [questID] == WorldQuestTracker.MapSeason) then
				--a quest j� esta na lista por�m foi adicionada nesta season do mapa
				return true
			else
				--apenas retornar que n�o � nova
				return false
			end
		else --a quest n�o esta na lista
			local timeLeft = WorldQuestTracker.GetQuest_TimeLeft (questID)
			if (timeLeft and timeLeft > 0) then
				--adicionar a quest a lista de quets
				ActiveQuests [questID] = time() + (timeLeft*60)
				map_seasons [questID] = WorldQuestTracker.MapSeason
				--retornar que a quest � nova
				return true
			else
				--o tempo da quest expirou.
				return false
			end
		end
	end

	function WorldQuestTracker.SavedQuestList_CleanUp()
		local ActiveQuests = WorldQuestTracker.SavedQuestList_GetList()
		local now = time()
		for questID, expireAt in pairs (ActiveQuests) do
			if (expireAt < now) then
				ActiveQuests [questID] = nil
			end
		end
	end

	------------

	function WorldQuestTracker.AllCharactersQuests_Add (questID, timeLeft, iconTexture, iconText)
		local guid = UnitGUID ("player")
		local t = WorldQuestTracker.db.profile.quests_all_characters [guid]
		if (not t) then
			t = {}
			WorldQuestTracker.db.profile.quests_all_characters [guid] = t
		end
		
		local questInfo = t [questID]
		if (not questInfo) then
			questInfo = {}
			t [questID] = questInfo
		end
		
		questInfo.expireAt = time() + (timeLeft*60) --timeLeft = minutes left
		questInfo.rewardTexture = iconTexture or ""
		questInfo.rewardAmount = iconText or ""
	end

	function WorldQuestTracker.AllCharactersQuests_Remove (questID)
		local guid = UnitGUID ("player")
		local t = WorldQuestTracker.db.profile.quests_all_characters [guid]
		
		if (t) then
			t [questID] = nil
		end
	end

	function WorldQuestTracker.AllCharactersQuests_CleanUp()
		local guid = UnitGUID ("player")
		local t = WorldQuestTracker.db.profile.quests_all_characters [guid]
		
		if (t) then
			local now = time()
			for questID, questInfo in pairs (t) do
				if (questInfo.expireAt < now) then
					t [questID] = nil
				end
			end
		end
	end

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> build up our standing frame

--point of interest frame ~poiframe ~frame ~start
--local worldFramePOIs = CreateFrame ("frame", "WorldQuestTrackerWorldMapPOI", WorldMapFrame.BorderFrame)
local worldFramePOIs = CreateFrame ("frame", "WorldQuestTrackerWorldMapPOI", WorldMapFrame.ScrollContainer)
worldFramePOIs:SetAllPoints()
worldFramePOIs:SetFrameLevel (6701)
local fadeInAnimation = worldFramePOIs:CreateAnimationGroup()
local step1 = fadeInAnimation:CreateAnimation ("Alpha")
step1:SetOrder (1)
step1:SetFromAlpha (0)
step1:SetToAlpha (1)
step1:SetDuration (0.3)
worldFramePOIs.fadeInAnimation = fadeInAnimation
fadeInAnimation:SetScript ("OnFinished", function()
	worldFramePOIs:SetAlpha (1)
end)

--[=[
	local textureTest = worldFramePOIs:CreateTexture (nil, "overlay")
	textureTest:SetSize (128, 128)
	textureTest:SetColorTexture (1, 0, 0)
	textureTest:SetPoint ("center", worldFramePOIs, "center")
--]=]

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> zone map widgets

--C_Timer.After (2, function()
--	function WorldMap_DoesWorldQuestInfoPassFilters (info, ignoreTypeFilters, ignoreTimeRequirement)
--		print (info, ignoreTypeFilters, ignoreTimeRequirement)
--		return true
--	end
--end)

--[=[
WorldMapScrollFrame:HookScript ("OnMouseWheel", function (self, delta)
	--> update widget anchors if the map is a world quest zone
	if (WorldQuestTracker.ZoneHaveWorldQuest()) then
		WorldQuestTracker.UpdateZoneWidgetAnchors()
	end
end)
--]=]


----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> tutorials

--WorldQuestTracker.db.profile.TutorialPopupID = nil
-- ~tutorial
local re_ShowTutorialAlert = function()
	WorldQuestTracker ["ShowTutorialAlert"]()
end
local hook_AlertCloseButton = function (self) 
	re_ShowTutorialAlert()
end
local wait_ShowTutorialAlert = function()
	WorldQuestTracker.TutorialAlertOnHold = nil
	WorldQuestTracker.ShowTutorialAlert()
end
function WorldQuestTracker.ShowTutorialAlert()
	
	WorldQuestTracker.db.profile.TutorialPopupID = WorldQuestTracker.db.profile.TutorialPopupID or 1
	
	--WorldQuestTracker.db.profile.TutorialPopupID = 3
	
	if (WorldQuestTracker.db.profile.TutorialPopupID == 1) then
	
		if (WorldQuestTracker.TutorialAlertOnHold) then
			return
		end
	
		if (not WorldMapFrame:IsShown() or not IsQuestFlaggedCompleted (WORLD_QUESTS_AVAILABLE_QUEST_ID or 1) or InCombatLockdown()) then
			C_Timer.After (10, wait_ShowTutorialAlert)
			WorldQuestTracker.TutorialAlertOnHold = true
			return
		end
		
		if (GetExpansionLevel() == 6 or UnitLevel ("player") == 110) then --legion
			WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.BROKENISLES)
		elseif (GetExpansionLevel() == 7 or UnitLevel ("player") == 120) then --bfa
			WorldMapFrame:SetMapID (WorldQuestTracker.MapData.ZoneIDs.KULTIRAS)
		end
		
		WorldQuestTracker.UpdateWorldQuestsOnWorldMap (true)
		
		if (WorldQuestTracker.db.profile.disable_world_map_widgets) then
			WorldQuestTrackerToggleQuestsButton:Click()
		end
	
		local alert = CreateFrame ("frame", "WorldQuestTrackerTutorialAlert1", worldFramePOIs, "MicroButtonAlertTemplate")
		alert:SetFrameLevel (302)
		alert.label = L["S_TUTORIAL_CLICKTOTRACK"]
		alert.Text:SetSpacing (4)
		MicroButtonAlert_SetText (alert, alert.label)
		
		if (WorldQuestTracker.WorldMapFrameReference and WorldQuestTracker.WorldMapFrameReference:IsShown()) then
			alert:SetPoint ("bottom", WorldQuestTracker.WorldMapFrameReference, "top", 0, 28)
		else
			alert:SetPoint ("topleft", worldFramePOIs, "topleft", 64, -270)
		end
		
		alert.CloseButton:HookScript ("OnClick", hook_AlertCloseButton)
		alert:Show()
		
		WorldQuestTracker.db.profile.TutorialPopupID = WorldQuestTracker.db.profile.TutorialPopupID + 1
		
	elseif (WorldQuestTracker.db.profile.TutorialPopupID == 2) then
	
		if (not WorldQuestTracker.db.profile.disable_world_map_widgets) then
			WorldQuestTrackerToggleQuestsButton:Click()
		end
	
		local alert = CreateFrame ("frame", "WorldQuestTrackerTutorialAlert2", worldFramePOIs, "MicroButtonAlertTemplate")
		alert:SetFrameLevel (302)
		alert.label = "Use this button to toggle quests in the World Map. Faction icons switch to Kul'Tiras, Zandalar or Broken Isles map."
		alert.Text:SetSpacing (4)
		MicroButtonAlert_SetText (alert, alert.label)
		
		alert:SetPoint ("bottom", WorldQuestTrackerToggleQuestsButton, "top", 0, 28)
		
		alert.CloseButton:HookScript ("OnClick", hook_AlertCloseButton)
		alert.Arrow:ClearAllPoints()
		alert.Arrow:SetPoint ("topleft", alert, "bottomleft", 70, 0)
		alert:Show()
		
		WorldQuestTracker.db.profile.TutorialPopupID = WorldQuestTracker.db.profile.TutorialPopupID + 1
		
	elseif (WorldQuestTracker.db.profile.TutorialPopupID == 3) then
		local alert = CreateFrame ("frame", "WorldQuestTrackerTutorialAlert3", worldFramePOIs, "MicroButtonAlertTemplate")
		alert:SetFrameLevel (302)
		alert.label = "Click on Summary to see statistics and a saved list of quests on other characters."
		alert.Text:SetSpacing (4)
		MicroButtonAlert_SetText (alert, alert.label)
		alert:SetPoint ("bottomleft", WorldQuestTrackerRewardHistoryButton, "topleft", 0, 32)
		alert.Arrow:ClearAllPoints()
		alert.Arrow:SetPoint ("topleft", alert, "bottomleft", 10, 0)
		alert.CloseButton:HookScript ("OnClick", hook_AlertCloseButton)
		alert:Show()
		
		WorldQuestTracker.db.profile.TutorialPopupID = WorldQuestTracker.db.profile.TutorialPopupID + 1

	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--loading icon


function WorldQuestTracker.UpdateLoadingIconAnchor()
	local adjust_anchor = false
	if (GetCVarBool ("questLogOpen")) then
		if (not WorldMapFrame.isMaximized) then
			adjust_anchor = true
		end
	end
	
	if (adjust_anchor) then
		WorldQuestTracker.LoadingAnimation:SetPoint ("bottom", WorldMapScrollFrame, "top", 0, -75)
	else
		WorldQuestTracker.LoadingAnimation:SetPoint ("bottom", WorldMapScrollFrame, "top", 0, -75)
	end
end
function WorldQuestTracker.NeedUpdateLoadingIconAnchor()
	if (WorldQuestTracker.LoadingAnimation.FadeIN:IsPlaying()) then
		WorldQuestTracker.UpdateLoadingIconAnchor()
	elseif (WorldQuestTracker.LoadingAnimation.FadeOUT:IsPlaying()) then
		WorldQuestTracker.UpdateLoadingIconAnchor()
	elseif (WorldQuestTracker.LoadingAnimation.Loop:IsPlaying()) then
		WorldQuestTracker.UpdateLoadingIconAnchor()
	end
end
hooksecurefunc ("QuestMapFrame_Open", function()
	WorldQuestTracker.NeedUpdateLoadingIconAnchor()
end)

hooksecurefunc ("QuestMapFrame_Close", function()
	WorldQuestTracker.NeedUpdateLoadingIconAnchor()
end)


--C_Timer.NewTicker (5, function()WorldQuestTracker.PlayLoadingAnimation()end)
function WorldQuestTracker.CreateLoadingIcon()
	local f = CreateFrame ("frame", nil, WorldMapFrame)
	f:SetSize (48, 48)
	f:SetPoint ("bottom", WorldMapScrollFrame, "top", 0, -75) --289/2 = 144
	f:SetFrameLevel (3000)
	
	local animGroup1 = f:CreateAnimationGroup()
	local anim1 = animGroup1:CreateAnimation ("Alpha")
	anim1:SetOrder (1)
	anim1:SetFromAlpha (0)
	anim1:SetToAlpha (1)
	anim1:SetDuration (2)
	f.FadeIN = animGroup1
	
	local animGroup2 = f:CreateAnimationGroup()
	local anim2 = animGroup2:CreateAnimation ("Alpha")
	f.FadeOUT = animGroup2
	anim2:SetOrder (2)
	anim2:SetFromAlpha (1)
	anim2:SetToAlpha (0)
	anim2:SetDuration (4)
	animGroup2:SetScript ("OnFinished", function()
		f:Hide()
	end)
	
	f.Text = f:CreateFontString (nil, "overlay", "GameFontNormal")
	f.Text:SetText ("please wait...")
	f.Text:SetPoint ("left", f, "right", -5, 1)
	f.TextBackground = f:CreateTexture (nil, "background")
	f.TextBackground:SetPoint ("left", f, "right", -20, 0)
	f.TextBackground:SetSize (160, 14)
	f.TextBackground:SetTexture ([[Interface\COMMON\ShadowOverlay-Left]])
	
	f.Text:Hide()
	f.TextBackground:Hide()
	
	f.CircleAnimStatic = CreateFrame ("frame", nil, f)
	f.CircleAnimStatic:SetAllPoints()
	f.CircleAnimStatic.Alpha = f.CircleAnimStatic:CreateTexture (nil, "overlay")
	f.CircleAnimStatic.Alpha:SetTexture ([[Interface\COMMON\StreamFrame]])
	f.CircleAnimStatic.Alpha:SetAllPoints()
	f.CircleAnimStatic.Background = f.CircleAnimStatic:CreateTexture (nil, "background")
	f.CircleAnimStatic.Background:SetTexture ([[Interface\COMMON\StreamBackground]])
	f.CircleAnimStatic.Background:SetAllPoints()
	
	f.CircleAnim = CreateFrame ("frame", nil, f)
	f.CircleAnim:SetAllPoints()
	f.CircleAnim.Spinner = f.CircleAnim:CreateTexture (nil, "artwork")
	f.CircleAnim.Spinner:SetTexture ([[Interface\COMMON\StreamCircle]])
	f.CircleAnim.Spinner:SetVertexColor (.5, 1, .5, 1)
	f.CircleAnim.Spinner:SetAllPoints()
	f.CircleAnim.Spark = f.CircleAnim:CreateTexture (nil, "overlay")
	f.CircleAnim.Spark:SetTexture ([[Interface\COMMON\StreamSpark]])
	f.CircleAnim.Spark:SetAllPoints()

	local animGroup3 = f.CircleAnim:CreateAnimationGroup()
	animGroup3:SetLooping ("Repeat")
	local animLoop = animGroup3:CreateAnimation ("Rotation")
	f.Loop = animGroup3
	animLoop:SetOrder (1)
	animLoop:SetDuration (6)
	animLoop:SetDegrees (-360)
	animLoop:SetTarget (f.CircleAnim)
	
	WorldQuestTracker.LoadingAnimation = f
	WorldQuestTracker.UpdateLoadingIconAnchor()
	
	f:Hide()
end

function WorldQuestTracker.IsPlayingLoadAnimation()
	return WorldQuestTracker.LoadingAnimation.IsPlaying
end
function WorldQuestTracker.PlayLoadingAnimation()
	if (not WorldQuestTracker.IsPlayingLoadAnimation()) then
		WorldQuestTracker.LoadingAnimation:Show()
		WorldQuestTracker.LoadingAnimation.FadeIN:Play()
		WorldQuestTracker.LoadingAnimation.Loop:Play()
		WorldQuestTracker.LoadingAnimation.IsPlaying = true
	end
end
function WorldQuestTracker.StopLoadingAnimation()
	WorldQuestTracker.LoadingAnimation.FadeOUT:Play()
	WorldQuestTracker.LoadingAnimation.IsPlaying = false
end


----------------------------------------------------------------------------------------------------------------------------------------------------------------
--> faction bounty

--function WorldMapMixin:AddOverlayFrame(templateName, templateType, anchorPoint, relativeTo, relativePoint, offsetX, offsetY)
--this return the bounty board frame, just check if templatename is "WorldMapBountyBoardTemplate"
--[=[
hooksecurefunc (WorldMapFrame, "AddOverlayFrame", function (...)
	print ("Hi ya", ...)
end)


--coloca a quantidade de quests completas para cada fac��o em cima do icone da fac��o
function WorldQuestTracker.SetBountyAmountCompleted (self, numCompleted, numTotal)
	if (not self.objectiveCompletedText) then
		self.objectiveCompletedText = self:CreateFontString (nil, "overlay", "GameFontNormal")
		self.objectiveCompletedText:SetPoint ("bottom", self, "top", 1, 0)
		self.objectiveCompletedBackground = self:CreateTexture (nil, "background")
		self.objectiveCompletedBackground:SetPoint ("bottom", self, "top", 0, -1)
		self.objectiveCompletedBackground:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\background_blackgradientT]])
		self.objectiveCompletedBackground:SetSize (42, 12)
	end
	if (numCompleted) then
		self.objectiveCompletedText:SetText (numCompleted .. "/" .. numTotal)
		self.objectiveCompletedBackground:SetAlpha (.4)
	else
		self.objectiveCompletedText:SetText ("")
		self.objectiveCompletedBackground:SetAlpha (0)
	end
end

--quando selecionar uma fac��o, atualizar todas as quests no world map para que seja atualiza a quiantidade de quests que ha em cada mapa para esta fac�ao
hooksecurefunc (WorldMapFrame.UIElementsFrame.BountyBoard, "SetSelectedBountyIndex", function (self)
	if (WorldQuestTracker.IsWorldQuestHub (WorldMapFrame.mapID)) then
		WorldQuestTracker.UpdateWorldQuestsOnWorldMap (false, false, false, true)
	end
end)

--> do not switch the map if we are in the world map
--world quest tracker is replacing the function "FindBestMapForSelectedBounty"
--if you need to use this function, call directly from the mixin: WorldMapBountyBoardMixin.FindBestMapForSelectedBounty
--or WorldQuestTrackerAddon.FindBestMapForSelectedBounty_Original()

WorldQuestTracker.FindBestMapForSelectedBounty_Original = WorldMapFrame.UIElementsFrame.BountyBoard.FindBestMapForSelectedBounty
WorldMapFrame.UIElementsFrame.BountyBoard.FindBestMapForSelectedBounty = function()end

hooksecurefunc (WorldMapFrame.UIElementsFrame.BountyBoard, "OnTabClick", function (...)
	if (WorldQuestTrackerAddon.GetCurrentZoneType() == "zone") then
		WorldQuestTracker.FindBestMapForSelectedBounty_Original (...)
		WorldQuestTracker.LastMapID = WorldQuestTracker.GetCurrentMapAreaID()
		WorldQuestTracker.ScheduleZoneMapUpdate (0.5, true)
	end
end)

hooksecurefunc (WorldMapFrame.UIElementsFrame.BountyBoard, "AnchorBountyTab", function (self, tab)
	local bountyData = self.bounties [tab.bountyIndex]
	if (bountyData) then
		local numCompleted, numTotal = self:CalculateBountySubObjectives (bountyData)
		if (numCompleted and numTotal) then
			WorldQuestTracker.SetBountyAmountCompleted (tab, numCompleted, numTotal)
		end
	else
		WorldQuestTracker.SetBountyAmountCompleted (tab, false)
	end
end)
--]=]

-- stop auto complete doq dow endf thena


