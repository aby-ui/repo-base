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
local QuestMapFrame_IsQuestWorldQuest = QuestMapFrame_IsQuestWorldQuest or QuestUtils_IsQuestWorldQuest
local GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local GetQuestTagInfo = GetQuestTagInfo
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

-- /run WorldQuestTrackerAddon.debug = true;

--> rare finder frame
rf:RegisterEvent ("VIGNETTES_UPDATED")
rf:RegisterEvent ("PLAYER_TARGET_CHANGED")

rf.RecentlySpotted = {}
rf.LastPartyRareShared = 0
rf.FullRareListSendCooldown = 0
rf.CommGlobalCooldown = 0
rf.RareSpottedSendCooldown = {}
rf.MinimapScanCooldown = {}

function ff.GetItemLevelRequirement()
	return 0
end

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

function WorldQuestTracker.RequestRares()
	if (IsInGuild()) then
		if (WorldQuestTracker.db.profile.rarescan.show_icons) then
			local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_REQUEST, UnitName ("player")})
			WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "GUILD")
			WorldQuestTracker.Debug ("RequestRares() > requested list of rares COMM_IDS.RARE_REQUEST")
		end
	end
end

function rf.SendRareList (channel)
	--> check if the list is in cooldown
	if (rf.FullRareListSendCooldown + 10 > time()) then
		WorldQuestTracker.Debug ("SendRareList () > cound't send full rare list: cooldown.")
		return
	end

	--> if this has been called from C_Timer, the param will be the ticker object
	if (type (channel) == "table") then
		channel = "GUILD"
	else
		channel = channel or "GUILD"
	end
	
	--> make sure the player is in a local group
	if (channel == "PARTY") then
		if (not IsInGroup (LE_PARTY_CATEGORY_HOME)) then
			WorldQuestTracker.Debug ("SendRareList () > player not in a home party, aborting rare sharing in the group.")
			return
		end
		
		--> if the player is in a raid, send the comm on the raid channel instead
		if (IsInRaid (LE_PARTY_CATEGORY_HOME)) then
			WorldQuestTracker.Debug ("SendRareList () > player is in raid, sending comm on RAID channel.")
			channel = "RAID"
		end
	end
	
	--> make sure the player is in a guild
	if (channel == "GUILD") then
		if (not IsInGuild()) then
			return
		end
	end

	--> build the list to be shared
	local listToSend = {}
	
	--> do not share rares found on premade groups, they aren't reliable
	for npcId, rareTable in ipairs (WorldQuestTracker.db.profile.rarescan.recently_spotted) do
		if (not rareTable [rf.RARETABLE.FROMPREMADE]) then
			listToSend [npcId] = rareTable
		end
	end
	
	local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_LIST, UnitName ("player"), listToSend, channel})
	WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, channel)
	rf.FullRareListSendCooldown = time()
	WorldQuestTracker.Debug ("SendRareList () > sent list of rares > COMM_IDS.RARE_LIST on channel " .. (channel or "invalid channel"))
end

--/run WorldQuestTrackerAddon.debug = true;

function rf.ShareInWorldQuestParty()
	--> check if is realy in a world quest group
	if (IsInGroup (LE_PARTY_CATEGORY_HOME)) then
		if (time() > rf.LastPartyRareShared + 30) then
			rf.SendRareList ("PARTY")
			rf.LastPartyRareShared = time()
			WorldQuestTracker.Debug ("ShareInWorldQuestParty() > group updated, sending rare list to the party")
		end
	end
end

function rf.ScheduleGroupShareRares()
	if (rf.ShareRaresTimer_Party and not rf.ShareRaresTimer_Party._cancelled) then
		rf.ShareRaresTimer_Party:Cancel()
	end
	rf.ShareRaresTimer_Party = C_Timer.NewTimer (3, rf.ShareInWorldQuestParty)
end

function rf.ValidateCommData (validData, commType)
	if (commType == rf.COMM_IDS.RARE_SPOTTED) then
		if (not validData [2] or type (validData[2]) ~= "string") then --whoSpotted
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [2]")
			return
		elseif (not validData [3] or type (validData[3]) ~= "string") then --sourceChannel
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [3]")
			return
		elseif (not validData [4] or type (validData[4]) ~= "string") then --rareName
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [4]")
			return
		elseif (not validData [5] or type (validData[5]) ~= "string") then --rareSerial
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [5]")
			return
		elseif (not validData [6] or type (validData[6]) ~= "number") then --mapID
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [6]")
			return
		elseif (not validData [7] or type (validData[7]) ~= "number") then --playerX
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [7]")
			return
		elseif (not validData [8] or type (validData[8]) ~= "number") then --playerY
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [8]")
			return
		elseif (not validData [10] or type (validData[10]) ~= "number") then --time()
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_SPOTTED: [10]")
			return
		end
	
		return true
	end
	
	if (commType == rf.COMM_IDS.RARE_LIST) then
		if (not validData [2] or type (validData[2]) ~= "string") then --whoSent
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_LIST: [2]")
			return
		elseif (not validData [3] or type (validData[3]) ~= "table") then --theList
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_LIST: [3]")
			return
		elseif (not validData [4] or type (validData[4]) ~= "string") then --channel
			WorldQuestTracker.Debug ("ValidateCommData() > received invalid data on comm ID RARE_LIST: [4]")
			return
		end
		
		return true
	end
end

function rf.HasValidTime (timeReceived)
	local currentTime = time()
	if (timeReceived+2400 < currentTime or currentTime+3600 < timeReceived) then
		return false
	end
	return true
end

--/run WorldQuestTrackerAddon.debug = true;
--WorldQuestTracker.debug = true;

function WorldQuestTracker:CommReceived (_, data)
	local dataReceived = {LibStub ("AceSerializer-3.0"):Deserialize (data)}

	if (dataReceived [1]) then
		local validData = dataReceived [2]
		
		local prefix = validData [1]
		
		if (prefix == rf.COMM_IDS.RARE_SPOTTED) then
			
			--> reliable from clicking on a rare or a rare spotted on the minimap
			--> not relible from party/raid sending to guild
			--> not reliable from party/raid spotted
			
			if (not rf.ValidateCommData (validData, rf.COMM_IDS.RARE_SPOTTED)) then
				return
			end
			
			local whoSpotted = validData [rf.COMM_RARE_SPOTTED.WHOSPOTTED]
			local sourceChannel = validData [rf.COMM_RARE_SPOTTED.SOURCECHANNEL]
			local rareName = validData [rf.COMM_RARE_SPOTTED.RARENAME]
			local rareSerial = validData [rf.COMM_RARE_SPOTTED.RARESERIAL]
			local mapID = validData [rf.COMM_RARE_SPOTTED.MAPID]
			local playerX = validData [rf.COMM_RARE_SPOTTED.PLAYERX]
			local playerY = validData [rf.COMM_RARE_SPOTTED.PLAYERY]
			local isReliable = validData [rf.COMM_RARE_SPOTTED.ISRELIABLE]
			local localTime = validData [rf.COMM_RARE_SPOTTED.LOCALTIME]
			
			--> local time is a new index, lock the spotted rare within a 1 hour timezone
			if (not rf.HasValidTime (localTime)) then
				WorldQuestTracker.Debug ("CommReceived() > received a rare with an invalid time COMM_IDS.RARE_SPOTTED from " .. (whoSpotted or "invalid whoSpotted") .. " on " .. (sourceChannel or "invalid sourceChannel"), 2)
				return
			end
			
			WorldQuestTracker.Debug ("CommReceived() > received spot COMM_IDS.RARE_SPOTTED from " .. (whoSpotted or "invalid whoSpotted") .. " on " .. (sourceChannel or "invalid sourceChannel"))
			rf.RareSpotted (whoSpotted, sourceChannel, rareName, rareSerial, mapID, playerX, playerY, isReliable, localTime)
			
		elseif (prefix == rf.COMM_IDS.RARE_REQUEST) then
			--> check if the request didn't came from the owner
			local whoRequested = validData [2]
			if (whoRequested == UnitName ("player")) then
				return
			end
			
			--> check if a timer already exists
			if (rf.ShareRaresTimer_Guild and not rf.ShareRaresTimer_Guild._cancelled) then
				return
			end
			
			--> assign a random timer to share, with that only 1 person of the guild will share
			rf.ShareRaresTimer_Guild = C_Timer.NewTimer (math.random (15), rf.SendRareList)
			WorldQuestTracker.Debug ("CommReceived() > received request COMM_IDS.RARE_REQUEST from " .. (whoRequested or "invalid whoRequested"))
			
		elseif (prefix == rf.COMM_IDS.RARE_LIST) then
			--> if received from someone else, cancel our share timer
			if (rf.ShareRaresTimer_Guild and not rf.ShareRaresTimer_Guild._cancelled) then
				rf.ShareRaresTimer_Guild:Cancel()
				rf.ShareRaresTimer_Guild = nil
			end
			
			if (not rf.ValidateCommData (validData, rf.COMM_IDS.RARE_LIST)) then
				return
			end
			
			--> add the rares to our list
			local whoSent = validData [rf.COMM_RARE_LIST.WHOSENT]
			local fromChannel = validData [rf.COMM_RARE_LIST.SOURCECHANNEL]
			
			WorldQuestTracker.Debug ("CommReceived() > received list COMM_IDS.RARE_LIST from " .. (whoSent or "invalid whoSent") .. " on " .. fromChannel)
			
			--> ignore if who sent is the player
			if (whoSent == UnitName ("player")) then
				WorldQuestTracker.Debug ("CommReceived() > the list is from the player it self, ignoring.")
				return
			end
			
			local rareList = validData [rf.COMM_RARE_LIST.RARELIST]
			
			--> list of rare spotted on the player that received the list
			local localList = WorldQuestTracker.db.profile.rarescan.recently_spotted
			
			local newRares, justUpdated = 0, 0
			
			--> iterate on the list received
			for npcId, receivedRareTable in pairs (rareList) do
				--> add to the name cache
				WorldQuestTracker.db.profile.rarescan.name_cache [receivedRareTable [rf.RARETABLE.RARENAME]] = npcId

				if (rf.HasValidTime (receivedRareTable [rf.RARETABLE.TIMESPOTTED])) then --> -40 min or +60 min
					--> check if rare already is in the player rare list
					local localRareTable = localList [npcId]
					if (localRareTable) then
						--> already exists
						if (receivedRareTable [rf.RARETABLE.TIMESPOTTED] > localRareTable [rf.RARETABLE.TIMESPOTTED] and (localRareTable [rf.RARETABLE.TIMESPOTTED]+900 > receivedRareTable [rf.RARETABLE.TIMESPOTTED])) then
							--> update the timer
							localRareTable [rf.RARETABLE.TIMESPOTTED] = receivedRareTable [rf.RARETABLE.TIMESPOTTED]
							localRareTable [rf.RARETABLE.WHOSPOTTED] = receivedRareTable [rf.RARETABLE.WHOSPOTTED]
							justUpdated = justUpdated + 1
						end
					else
						--> the local player doesn't have this rare - only accept if the rare has spotted up to 30min ago
						if (receivedRareTable [rf.RARETABLE.TIMESPOTTED] + 1800 > time()) then
							--> add it to the list if the rare was spotted up to 20 min ago
							localList [npcId] = receivedRareTable
							newRares = newRares + 1
							
							--> if the player doesn't have the rare and he received it from a party, broadcast the rare to his guild as a rare spotted
							if (IsInGuild() and (fromChannel == "PARTY" or fromChannel == "RAID")) then
								--> don't share if both players are in the same guild
								local guildName = GetGuildInfo (whoSent)
								if (guildName ~= GetGuildInfo ("player")) then
								
									--adding cooldown here won't share more than 1 rare
									
									--if (rf.CommGlobalCooldown + 10 > time()) then
									--	WorldQuestTracker.Debug ("CommReceived() > received a new rare from group, cannot share with the guild: comm on cooldown.", 1)
									--else
										local timeSpotted, mapID,  playerX, playerY, rareSerial, rareName, whoSpotted, serverTime = unpack (receivedRareTable)
										--> sending with the timesSpotted from the user who shared the rare location
										local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_SPOTTED, whoSpotted, "GUILD", rareName, rareSerial, mapID, playerX, playerY, false, timeSpotted})
										WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "GUILD")
										WorldQuestTracker.Debug ("CommReceived() > received a new rare from group, shared within the guild.", 2)
										--rf.CommGlobalCooldown = time()
									--end
								end
							end
						else
							--print ("rare ignored:", receivedRareTable [rf.RARETABLE.RARENAME], receivedRareTable [rf.RARETABLE.TIMESPOTTED] - time())
						end
					end
				else
					--print ("rare ignored !HasValidTime():", receivedRareTable [rf.RARETABLE.RARENAME], receivedRareTable [rf.RARETABLE.TIMESPOTTED] - time())
				end
			end
			
			WorldQuestTracker.Debug ("CommReceived() > added: " .. newRares .. " updated: " .. justUpdated)
			
		else
			WorldQuestTracker.HandleComm (validData)
			
		end
	end
end
WorldQuestTracker:RegisterComm (WorldQuestTracker.COMM_PREFIX, "CommReceived")

function rf.GetMyNpcKilledList()
	local t = WorldQuestTracker.db.profile.rarescan.recently_killed
	local chrGUID = UnitGUID ("player")
	
	if (not chrGUID) then
		return
	end
	
	if (t [chrGUID]) then
		return t [chrGUID]
	else
		t [chrGUID] = {}
		return t [chrGUID]
	end
end

function rf.RareSpotted (whoSpotted, sourceChannel, rareName, rareSerial, mapID, playerX, playerY, isReliable, localTime, fromPreMade)
	local npcId = WorldQuestTracker:GetNpcIdFromGuid (rareSerial)
	
	--> add to the name cache
	WorldQuestTracker.db.profile.rarescan.name_cache [rareName] = npcId
	
	--> announce on chat
	if (not rf.RecentlySpotted [npcId] or rf.RecentlySpotted [npcId] + 800 < time()) then
		--print ("|cFFFF9900WQT|r: rare '|cFFFFFF00" .. rareName .. "|r' spotted.")
		rf.RecentlySpotted [npcId] = time()
	end
	
	--> add to the rare table
	local rareTable = WorldQuestTracker.db.profile.rarescan.recently_spotted [npcId]
	if (not rareTable) then
		--> do not have any reference of this rare, add a new table
		rareTable = {isReliable and time() or (localTime or time()), mapID, playerX, playerY, rareSerial, rareName, whoSpotted, GetServerTime(), fromPreMade}
		WorldQuestTracker.db.profile.rarescan.recently_spotted [npcId] = rareTable
		WorldQuestTracker.Debug ("RareSpotted() > added new npc: " .. rareName)
	else
		--> already have this rare, just update the time that has been spotted
		rareTable [rf.RARETABLE.TIMESPOTTED] = isReliable and time() or (localTime or time())
		rareTable [rf.RARETABLE.WHOSPOTTED] = whoSpotted
		rareTable [rf.RARETABLE.SERVERTIME] = GetServerTime()
		
		if (isReliable) then
			rareTable [rf.RARETABLE.PLAYERX] = playerX
			rareTable [rf.RARETABLE.PLAYERY] = playerY
		end
		WorldQuestTracker.Debug ("RareSpotted() > npc updated: " .. rareName)
	end
	
	if (time() > rf.CommGlobalCooldown+10) then
		--> if the rare information came from the party or raid, share the info with the guild
		if (sourceChannel == "PARTY" or sourceChannel == "RAID") then
			if (IsInGuild()) then
				local guildName1 = GetGuildInfo (whoSpotted)
				local guildName2 = GetGuildInfo ("player")
				
				WorldQuestTracker.Debug ("RareSpotted() > sourceChannel is group, trying to share with the guild.", guildName1 ~= guildName2)
				
				if (guildName1 ~= guildName2) then
					local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_SPOTTED, whoSpotted, "GUILD", rareName, rareSerial, mapID, playerX, playerY, isReliable, localTime})
					--> check cooldown for this rare
					rf.RareSpottedSendCooldown [npcId] = rf.RareSpottedSendCooldown [npcId] or 0
					if (rf.RareSpottedSendCooldown [npcId] + 10 > time()) then
						WorldQuestTracker.Debug ("RareSpotted() > cound't send rare to guild: send is on cooldown.", 1)
						return
					end

					WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "GUILD")
					WorldQuestTracker.Debug ("RareSpotted() > successfully sent a rare from a group to player guild.", 2)
					rf.CommGlobalCooldown = time()
				end
			end
		
		--> if the information came from the guild, share with the group
		elseif (sourceChannel == "GUILD") then
			if (IsInGroup (LE_PARTY_CATEGORY_HOME) or IsInRaid (LE_PARTY_CATEGORY_HOME)) then
				--> do not want to share inside a dungeon, battleground or raid instance
				if (not IsInInstance()) then
					local channel = IsInRaid (LE_PARTY_CATEGORY_HOME) and "RAID" or "PARTY"
					local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_SPOTTED, whoSpotted, channel, rareName, rareSerial, mapID, playerX, playerY, isReliable, localTime})
					WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, channel)
					rf.CommGlobalCooldown = time()
				end
			end
		end
	else
		WorldQuestTracker.Debug ("RareSpotted() > cound't send rare: comm is on cooldown.", 1)
	end
end

function rf.IsRareAWorldQuest (rareName)
	--> get the cache of widgets currently shown on map
	local cache = WorldQuestTracker.Cache_ShownWidgetsOnZoneMap
	local isWorldQuest = false
	
	--> do the iteration
	for i = 1, #cache do 
		local widget = cache [i]
		if (widget.questName == rareName) then
			return true
		end
	end
end

--/run WorldQuestTrackerAddon.debug = true;

local safeDisableCLEU = function()
	rf:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
end

function rf.IsTargetARare()

	if (UnitExists ("target")) then -- and not UnitIsDead ("target")
		local serial = UnitGUID ("target")
		local npcId = WorldQuestTracker:GetNpcIdFromGuid (serial)
	
		if (npcId) then
		
			--> check if is a non registered rare
			if (not WorldQuestTracker.MapData.RaresToScan [npcId]) then
				if (WorldQuestTracker.IsNewEXPZone (WorldQuestTracker.GetCurrentMapAreaID())) then
					local unitClassification = UnitClassification ("target")
					if (unitClassification == "rareelite") then
						WorldQuestTracker.db.profile.raredetected [npcId or 0] = true
						WorldQuestTracker.MapData.RaresToScan [npcId] = true
						--print ("|cFFFF9900[WQT]|r " .. L["S_RAREFINDER_NPC_NOTREGISTERED"] .. ":", UnitName ("target"), "NpcID:", npcId)
					end
				end
			end
			
			--> is a rare npc?
			if (WorldQuestTracker.MapData.RaresToScan [npcId]) then
			
				--> check is the npc is flagged as rare
				local unitClassification = UnitClassification ("target")
				if (unitClassification == "rareelite" or unitClassification == "rare") then

					--> send comm
					local mapPosition = C_Map.GetPlayerMapPosition (WorldQuestTracker.GetCurrentStandingMapAreaID(), "player")
					if (not mapPosition) then
						return
					end
					local x, y = mapPosition.x, mapPosition.y
					
					local map = WorldQuestTracker.GetCurrentMapAreaID()
					local rareName = UnitName ("target")
					local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_SPOTTED, UnitName ("player"), "GUILD", rareName, serial, map, x, y, true, time()})
					
					if (IsInGuild()) then
						--> check cooldown for this rare
						rf.RareSpottedSendCooldown [npcId] = rf.RareSpottedSendCooldown [npcId] or 0
						if (rf.RareSpottedSendCooldown [npcId] + 10 > time()) then
							WorldQuestTracker.Debug ("IsTargetARare() > cound't send rare spotted: cooldown.", 1)
							return
						end
						
						WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "GUILD")
						
						if (IsInGroup (LE_PARTY_CATEGORY_HOME) or IsInRaid (LE_PARTY_CATEGORY_HOME)) then
							WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, IsInRaid (LE_PARTY_CATEGORY_HOME) and "RAID" or "PARTY")
							WorldQuestTracker.Debug ("IsTargetARare() > sent to the group as well.", 2)
						end
						
						rf.RareSpottedSendCooldown [npcId] = time()
					end
					
					--> add to the name cache
					WorldQuestTracker.db.profile.rarescan.name_cache [rareName] = npcId
					
					--
					rf:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
					if (rf.DisableCLEUTimer and not rf.DisableCLEUTimer._cancelled) then
						rf.DisableCLEUTimer:Cancel()
					end
					rf.DisableCLEUTimer = C_Timer.NewTimer (300, safeDisableCLEU)
					
					rf.LastRareSerial = serial
					rf.LastRareName = rareName
					
					-- ~disabled
					if (true) then
						--return
					end
					
					--find group or create a group for this rare
					if (not ff:IsShown() and not IsInGroup() and not QueueStatusMinimapButton:IsShown()) then --> is already searching?
						--> is search for group enabled?
						if (WorldQuestTracker.db.profile.rarescan.search_group) then
							--> check if the rare isn't a world quest
							local isWorldQuest = rf.IsRareAWorldQuest (rareName)
							if (not isWorldQuest) then
								local callback = nil
								local EnglishRareName = WorldQuestTracker.MapData.RaresENNames [npcId]
								local itemLevelRequired = ff.GetItemLevelRequirement()
								
								if (EnglishRareName and WorldQuestTracker.db.profile.rarescan.always_use_english) then
									--WorldQuestTracker.FindGroupForCustom (EnglishRareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH_RARENPC"], "Doing rare encounter against " .. rareName .. ". Group created with World Quest Tracker #NPCID" .. npcId .. "#LOC " .. (rareName or "") .. " ", itemLevelRequired, callback)
									--print (1)
								else
									--WorldQuestTracker.FindGroupForCustom (rareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH_RARENPC"], "Doing rare encounter against " .. rareName .. ". Group created with World Quest Tracker #NPCID" .. npcId .. "#LOC " .. (EnglishRareName or "") .. " ", itemLevelRequired, callback)
									--ff:PlayerEnteredWorldQuestZone (nil, npcId)
								end
								
								ff:PlayerEnteredWorldQuestZone (nil, npcId, UnitName ("target"))
							end
						end
					end
				else
					WorldQuestTracker.Debug ("IsTargetARare() > unit isn't rareelite classification.")
				end
			else
				if (WorldQuestTracker.MapData.InvasionBosses [npcId]) then
					--already searching?
					if (not ff:IsShown() and not IsInGroup() and not QueueStatusMinimapButton:IsShown()) then
						--> search for a group?
						if (WorldQuestTracker.db.profile.rarescan.search_group) then
							--> check if the rare isn't a world quest
							local rareName = UnitName ("target")
							local callback= nil
							
							local EnglishRareName = WorldQuestTracker.MapData.RaresENNames [npcId]
							if (EnglishRareName and WorldQuestTracker.db.profile.rarescan.always_use_english) then
								--WorldQuestTracker.FindGroupForCustom (EnglishRareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH"], "Doing Argus World Boss against " .. rareName .. " Group created with World Quest Tracker #NPCID" .. npcId .. "#LOC " .. (rareName or "") .. " ", 0, callback)
								WorldQuestTracker.Debug ("IsTargetARare() > invasion boss detected and using english name.")
							else
								--WorldQuestTracker.FindGroupForCustom (rareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH"], "Doing Invasion Point boss encounter against " .. rareName .. " Group created with World Quest Tracker #NPCID" .. npcId, 0, callback)
								WorldQuestTracker.Debug ("IsTargetARare() > invasion boss detected and cannot english name.")
							end
						end
					end
				end
			end
		else
			WorldQuestTracker.Debug ("IsTargetARare() > invalid npcId.")
		end
	end
end

rf:SetScript ("OnEvent", function (self, event, ...)

	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then

		local _, token, hidding, who_serial, who_name, who_flags, who_flags2, alvo_serial, alvo_name, alvo_flags, alvo_flags2 = CombatLogGetCurrentEventInfo()
		
		if (token == "UNIT_DIED") then
			if (alvo_serial == rf.LastRareSerial) then
				--> current rare got killed
				rf.LastRareSerial = nil
				rf.LastRareName = nil
				rf:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")

				--> check if the group finder window is shown with the mob we just killed
				if (ff:IsShown()) then
					ff:HideFrame (true)
				end
				
				--> ask to leave the group
				if (ff.QuestName2Text.text == alvo_name and IsInGroup()) then
					ff.WorldQuestFinished (0, true)
				end
				
				local killed = rf.GetMyNpcKilledList()
				if (not killed) then
					return
				else
					local npcId = WorldQuestTracker:GetNpcIdFromGuid (alvo_serial)
					if (npcId) then
						local resetTime = time() + GetQuestResetTime()
						killed [npcId] = resetTime
					end
				end
			end
		end
		
	elseif (event == "PLAYER_TARGET_CHANGED") then
		rf.IsTargetARare()
		
	elseif (event == "VIGNETTES_UPDATED") then
		rf.ScanMinimapForRares()
	end
end)

function WorldQuestTracker.RareWidgetOnEnter (self)
	local parent = self:GetParent()
	
	if (parent.IsRare) then
		local t = time() - parent.RareTime
		local timeColor = abs ((t/3600)-1)
		timeColor = Saturate (timeColor)
		local colorR, colorG = WorldQuestTracker.ColorScaleByPercent (timeColor)
		
		GameCooltip:Preset (2)
		GameCooltip:SetOwner (self)
		
		GameCooltip:SetOption ("ButtonsYMod", -2)
		GameCooltip:SetOption ("YSpacingMod", -2)
		GameCooltip:SetOption ("IgnoreButtonAutoHeight", true)
		GameCooltip:SetOption ("TextSize", 10)
		GameCooltip:SetOption ("FixedWidth", false)
		
		GameCooltip:AddLine (parent.RareName, "", 1, "WQT_ORANGE_YELLOW_RARE_TITTLE", nil, 11)
		GameCooltip:AddLine (L["S_RAREFINDER_TOOLTIP_SPOTTEDBY"] .. ": ", "" .. (parent.RareOwner or ""), 1, nil, parent.RareOwner:find ("%-") and "gray" or nil)
		GameCooltip:AddLine ("" .. floor (t/60) .. ":" .. format ("%02.f", t%60) .. " " .. L["S_RAREFINDER_TOOLTIP_TIMEAGO"] .. "", "", 1, {colorR/255, colorG/255, 0})
		
		GameCooltip:AddLine ("", "", 1, {colorR/255, colorG/255, 0})
		
		GameCooltip:AddLine (L["S_RAREFINDER_TOOLTIP_SEACHREALM"], "", 1, "WQT_ORANGE_YELLOW_RARE_TITTLE")
		GameCooltip:AddIcon ("Interface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME", 1, 1, 12, 12, 0/512, 70/512, 224/512, 306/512)
		
		GameCooltip:AddLine (L["S_RAREFINDER_TOOLTIP_REMOVE"], "", 1, "WQT_ORANGE_YELLOW_RARE_TITTLE")
		GameCooltip:AddIcon ("Interface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME", 1, 1, 12, 12, 0/512, 70/512, 328/512, 409/512)
		
		GameCooltip:Show()
		GameTooltip:Hide()
		
		parent.TextureCustom:SetBlendMode ("ADD")
	end
	 
end

function WorldQuestTracker.RareWidgetOnLeave (self)
	GameCooltip:Hide()
	if (not WorldMapFrame.isMaximized) then
		GameCooltipFrame1:SetParent (UIParent)
	end
	self:GetParent().TextureCustom:SetBlendMode ("BLEND")
end

function WorldQuestTracker.RareWidgetOnClick (self, button)
	if (button == "LeftButton") then
		local parent = self:GetParent()
		local npcId = WorldQuestTracker:GetNpcIdFromGuid (parent.RareSerial)
		if (npcId) then
			local callback = nil
			local EnglishRareName = WorldQuestTracker.MapData.RaresENNames [npcId]
			local rareName = parent.RareName
			
			local itemLevelRequired = ff.GetItemLevelRequirement()
			
			--if (EnglishRareName and WorldQuestTracker.db.profile.rarescan.always_use_english) then
			--	WorldQuestTracker.FindGroupForCustom (EnglishRareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH_RARENPC"], "Doing rare encounter against " .. rareName .. ". Group created with World Quest Tracker #NPCID" .. npcId .. "#LOC " .. (rareName or "") .. " ", itemLevelRequired, callback)
			--else
			--	WorldQuestTracker.FindGroupForCustom (rareName, rareName, L["S_GROUPFINDER_ACTIONS_SEARCH_RARENPC"], "Doing rare encounter against " .. rareName .. ". Group created with World Quest Tracker #NPCID" .. npcId .. "#LOC " .. (EnglishRareName or "") .. " ", itemLevelRequired, callback)
			--end
			
			ff:PlayerEnteredWorldQuestZone (nil, npcId, rareName)
		end
		
	elseif (button == "RightButton") then
		local parent = self:GetParent()
		local npcId = WorldQuestTracker:GetNpcIdFromGuid (parent.RareSerial)
		if (npcId and WorldQuestTracker.db.profile.rarescan.recently_spotted [npcId]) then
			WorldQuestTracker.db.profile.rarescan.recently_spotted [npcId] = nil
			parent:Hide()
		end
	end
end

WorldQuestTracker.RareWidgets = {}

function WorldQuestTracker.UpdateRareIcons (mapID)

	if (not WorldQuestTracker.db.profile.rarescan.show_icons) then
		return
	end

	local alreadyKilled = rf.GetMyNpcKilledList()
	if (not alreadyKilled) then
		--> player serial or database not available at the moment
		return
	end

	local map = WorldQuestTrackerDataProvider:GetMap()
	for pin in map:EnumeratePinsByTemplate ("WorldQuestTrackerRarePinTemplate") do
		pin.RareWidget:Hide()
		map:RemovePin (pin)
	end
	
	for npcId, rareTable in pairs (WorldQuestTracker.db.profile.rarescan.recently_spotted) do
		local timeSpotted = rareTable [rf.RARETABLE.TIMESPOTTED]
		
		--alreadyKilled [npcId] = nil --debug
			
		if (timeSpotted + 3600 > time() and not alreadyKilled [npcId] and not WorldQuestTracker.MapData.RaresIgnored [npcId]) then
		
			local questCompleted = false
			local npcQuestCompletedID = WorldQuestTracker.MapData.RaresQuestIDs [npcId]
			if (npcQuestCompletedID and IsQuestFlaggedCompleted (npcQuestCompletedID)) then
				questCompleted = true
			end

			local rareMapID = rareTable [rf.RARETABLE.MAPID]
			if (rareMapID == mapID and not questCompleted) then
			
				local rareName = rareTable [rf.RARETABLE.RARENAME]
			
				--> check if the rare isn't part of a world quest
				local isWorldQuest = rf.IsRareAWorldQuest (rareName)
				if (not isWorldQuest and rareTable [rf.RARETABLE.WHOSPOTTED]) then
					
					local positionX = rareTable [rf.RARETABLE.PLAYERX]
					local positionY = rareTable [rf.RARETABLE.PLAYERY]
					local rareSerial = rareTable [rf.RARETABLE.RARESERIAL]
					local rareOwner = rareTable [rf.RARETABLE.WHOSPOTTED]
					
					local npcId = WorldQuestTracker:GetNpcIdFromGuid (rareSerial)
					local position = WorldQuestTracker.MapData.RaresLocations [npcId]
					
					if (position and position.x ~= 0) then
						positionX = position.x/100;
						positionY = position.y/100;
					end
					
					local pin = WorldQuestTrackerDataProvider:GetMap():AcquirePin ("WorldQuestTrackerRarePinTemplate", "rarePin")
					pin:SetSize (1, 1)
					
					if (not pin.InitializedForRare) then
						pin.InitializedForRare = true
						local widget = WorldQuestTracker.GetOrCreateZoneWidget (math.random (1, 99999999))
						WorldQuestTracker.ResetWorldQuestZoneButton (widget)
						widget:SetPoint ("center", pin, "center")
						pin.RareWidget = widget
					end
					
					pin.RareWidget.mapID = mapID
					pin.RareWidget.questID = 0
					pin.RareWidget.numObjectives = 0
					pin.RareWidget.Order = 0
					pin.RareWidget.IsRare = true
					pin.RareWidget.RareName = rareName
					pin.RareWidget.RareSerial = rareSerial
					pin.RareWidget.RareTime = timeSpotted
					pin.RareWidget.RareOwner = rareOwner
					
					pin.RareWidget.RareOverlay:Show()
					
					pin.RareWidget.Texture:Hide()
					pin.RareWidget.TextureCustom:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_star]])
					pin.RareWidget.TextureCustom:SetSize (22, 22)
					pin.RareWidget.TextureCustom:Show()
					
					pin.RareWidget:Show()
					
					pin:SetPosition (positionX, positionY)
				end
			end
		end
	end
end

-- /dump WorldQuestTrackerAddon.db.profile.rarescan.recently_killed
function WorldQuestTracker.CheckForOldRareFinderData()
	--> check for daily reset timers
	local now = time()
	local t = WorldQuestTracker.db.profile.rarescan.recently_killed
	
	for playerSerial, timeTable in pairs (t) do
		--> is a valid player guid and table?
		if (type (playerSerial) == "string" and type (timeTable) == "table") then
			for npcId, timeLeft in pairs (timeTable) do
				if (timeLeft < now) then
					timeTable [npcId] = nil
					WorldQuestTracker.Debug ("CheckForOldRareFinderData > daily reset: " .. npcId)
				end
			end
		end
	end
	
	--> check for outdated spotted rares
	for npcId, rareTable in pairs (WorldQuestTracker.db.profile.rarescan.recently_spotted) do
		if (rareTable [rf.RARETABLE.TIMESPOTTED] + 3600 < now or now + 3600 < rareTable [rf.RARETABLE.TIMESPOTTED]) then
			--> remove the npc from the list
			WorldQuestTracker.db.profile.rarescan.recently_spotted [npcId] = nil
			WorldQuestTracker.Debug ("CheckForOldRareFinderData > outdated entry removed: " .. rareTable [6] .. " ID: " .. npcId)
		end
	end
end

C_Timer.NewTicker (60, function (ticker)
	if (WorldQuestTracker.db and WorldQuestTracker.db.profile) then
		WorldQuestTracker.CheckForOldRareFinderData()
	end
end)

function rf.ScanMinimapForRares()

	if (not IsInGuild()) then
		return
	end
	
	-- vignetteInfo.atlasName == "VignetteKill"
	for i, vignetteID in ipairs (C_VignetteInfo.GetVignettes()) do
		local vignetteInfo = C_VignetteInfo.GetVignetteInfo (vignetteID)
		
		if (vignetteInfo) then
			local serial = vignetteInfo.objectGUID

			if (serial) then
				local name = vignetteInfo.name
				local objectIcon = vignetteInfo.atlasName
				
				if (objectIcon and (objectIcon == "VignetteKill")) then
				
					local npcId = WorldQuestTracker.db.profile.rarescan.name_cache [name]
					
					if (npcId and WorldQuestTracker.MapData.RaresToScan [npcId]) then
						if (not rf.MinimapScanCooldown [npcId] or rf.MinimapScanCooldown [npcId]+10 < time()) then
							local isWorldQuest = rf.IsRareAWorldQuest (name)
							if (not isWorldQuest) then
								--> make sure the spotted minimap rare isn't the player target
								local targetSerial = UnitGUID ("target") or ""
								local targetNpcId = WorldQuestTracker:GetNpcIdFromGuid (targetSerial)
							
								if (npcId ~= targetNpcId) then
									local mapPosition = C_Map.GetPlayerMapPosition (WorldQuestTracker.GetCurrentStandingMapAreaID(), "player")
									if (not mapPosition) then
										return
									end
									local x, y = mapPosition.x, mapPosition.y
									
									local map = WorldQuestTracker.GetCurrentMapAreaID()
									local rareName = name
									serial = "Creature-0-0000-0000-00000-" .. npcId .. "-0000000000"
									
									local data = LibStub ("AceSerializer-3.0"):Serialize ({rf.COMM_IDS.RARE_SPOTTED, UnitName ("player"), "GUILD", rareName, serial, map, x, y, true, time()})
									
									WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "GUILD")
									
									if (WorldQuestTracker.db.profile.rarescan.playsound and (not rf.MinimapScanCooldown [npcId] or rf.MinimapScanCooldown [npcId]+60 < time())) then
										PlaySoundFile ("Interface\\AddOns\\WorldQuestTracker\\media\\rare_found" .. WorldQuestTracker.db.profile.rarescan.playsound_volume .. ".ogg", WorldQuestTracker.db.profile.rarescan.use_master and "Master" or "SFX")
										if (WorldQuestTracker.db.profile.rarescan.playsound_warnings < 3) then
											WorldQuestTracker.db.profile.rarescan.playsound_warnings = WorldQuestTracker.db.profile.rarescan.playsound_warnings + 1
											WorldQuestTracker:Msg (L["S_RAREFINDER_SOUNDWARNING"])
										end
									end
									
									rf.MinimapScanCooldown [npcId] = time()
									
									WorldQuestTracker.Debug ("ScanMinimapForRares > added npc from minimap: " .. rareName .. " ID: " .. npcId)
								end
							end
						end
					end
				end
			end
		end
	end
end
