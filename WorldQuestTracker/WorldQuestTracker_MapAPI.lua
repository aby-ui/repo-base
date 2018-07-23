

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

local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame

local _
local GetQuestsForPlayerByMapID = C_TaskQuest.GetQuestsForPlayerByMapID
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







--return the list of quests on the tracker
function WorldQuestTracker.GetTrackedQuests()
	return WorldQuestTracker.QuestTrackList
end


--does the the zone have world quests?
function WorldQuestTracker.ZoneHaveWorldQuest (mapID)
	--print (WorldQuestTracker.MapData, WorldQuestTracker.MapData.WorldQuestZones)
	return WorldQuestTracker.MapData.WorldQuestZones [mapID or WorldQuestTracker.GetCurrentMapAreaID()]
end

--is a argus zone?
function WorldQuestTracker.IsArgusZone (mapID)
	if (WorldQuestTracker.MapData.ZoneIDs.ANTORAN == mapID) then
		return true
	elseif (WorldQuestTracker.MapData.ZoneIDs.KROKUUN == mapID) then
		return true
	elseif (WorldQuestTracker.MapData.ZoneIDs.MCCAREE == mapID) then
		return true
	end
end

--is the current map zone a world quest hub?
function WorldQuestTracker.IsWorldQuestHub (mapID)
	return WorldQuestTracker.MapData.QuestHubs [mapID]
end

--is the current map a quest hub? (wait why there's two same functions?)
function WorldQuestTracker.IsCurrentMapQuestHub()
	local currentMap = WorldQuestTracker.GetCurrentMapAreaID()
	return WorldQuestTracker.MapData.QuestHubs [currentMap]
end

--return if the zone is a quest hub or if a common zone
function WorldQuestTracker.GetCurrentZoneType()
	if (WorldQuestTracker.ZoneHaveWorldQuest (WorldQuestTracker.GetCurrentMapAreaID())) then
		return "zone"
	elseif (WorldQuestTracker.IsWorldQuestHub (WorldMapFrame.mapID) or WorldQuestTracker.IsCurrentMapQuestHub()) then
		return "world"
	end
end

function WorldQuestTracker.GetMapInfo (uiMapId)
	if (not uiMapId) then
		uiMapId = C_Map.GetBestMapForUnit ("player")
		if (uiMapId) then
			return C_Map.GetMapInfo (uiMapId)
		else
			--print ("C_Map.GetBestMapForUnit ('player1'): returned NIL")
		end
	else
		return C_Map.GetMapInfo (uiMapId)
	end
end

function WorldQuestTracker.GetMapName (uiMapId)
	local mapInfo = C_Map.GetMapInfo (uiMapId)
	if (mapInfo) then
		local mapName = mapInfo and mapInfo.name or "wrong map id"
		return mapName
	end
end

--verifica se pode mostrar os widgets de broken isles
function WorldQuestTracker.CanShowWorldMapWidgets (noFade)
	if (WorldQuestTracker.IsWorldQuestHub (WorldMapFrame.mapID) or WorldQuestTracker.IsCurrentMapQuestHub()) then
		if (noFade) then
			WorldQuestTracker.UpdateWorldQuestsOnWorldMap()
		else
			WorldQuestTracker.UpdateWorldQuestsOnWorldMap (false, true)
		end
	else
		WorldQuestTracker.HideWorldQuestsOnWorldMap()
	end
end

--return which are the current bounty quest id selected
function WorldQuestTracker.GetCurrentBountyQuest()
	return WorldQuestTracker.DataProvider.bountyQuestID or 0
end



--return a map table with quest ids as key and true as value
function WorldQuestTracker.GetAllWorldQuests_Ids()
	local allQuests, dataUnavaliable = {}, false
	for mapId, configTable in pairs (WorldQuestTracker.mapTables) do
		--local taskInfo = GetQuestsForPlayerByMapID (mapId, 1007)
		local taskInfo = GetQuestsForPlayerByMapID (mapId)
		if (taskInfo and #taskInfo > 0) then
			for i, info  in ipairs (taskInfo) do
				local questID = info.questId
				if (HaveQuestData (questID)) then
					local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
					if (isWorldQuest) then
						allQuests [questID] = true
						if (not HaveQuestRewardData (questID)) then
							C_TaskQuest.RequestPreloadRewardData (questID)
						end						
					end
				else
					dataUnavaliable = true
				end
			end
		else
			dataUnavaliable = true
		end
	end
	
	return allQuests, dataUnavaliable
end

--pega o nome da zona
function WorldQuestTracker.GetZoneName (mapID)
	if (not mapID) then
		return ""
	end
	
	local mapInfo = WorldQuestTracker.GetMapInfo (mapID)
	
	return mapInfo and mapInfo.name or ""
end

--8.0 doesnt work
function WorldQuestTracker.IsASubLevel()
	--local level, x1 = GetCurrentMapDungeonLevel()
	--[[
	if (level and level >  0 and x1) then
		x1 = floor (x1)
		--vindicar antoran
		if (level == 5 and floor (x1) == 8479) then
			return true
		end
		
		--vindicar krokuun
		if (level == 1 and floor (x1) == 1302) then
			return true
		end
		
		--vindicar mccree
		if (level == 3 and floor (x1) == 9689) then
			return true
		end
	end
	--]]
	
	--if (level and level > 0 and x1 and level < 8) then
	--	return true
	--end
end

function WorldQuestTracker.GetOrLoadQuestData (questID, canCache)
	local data = WorldQuestTracker.CachedQuestData [questID]
	if (data) then
		return unpack (data)
	end

	local tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical = GetQuestTagInfo (questID)
	local gold, goldFormated = WorldQuestTracker.GetQuestReward_Gold (questID)
	local rewardName, rewardTexture, numRewardItems = WorldQuestTracker.GetQuestReward_Resource (questID)
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)

	local itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount = WorldQuestTracker.GetQuestReward_Item (questID)
	
	if (WorldQuestTracker.CanCacheQuestData and canCache) then
		WorldQuestTracker.CachedQuestData [questID] = {title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount}
	end
	
	return title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex, allowDisplayPastCritical, gold, goldFormated, rewardName, rewardTexture, numRewardItems, itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, isArtifact, artifactPower, isStackable, stackAmount
end

function WorldQuestTracker.GetCurrentStandingMapAreaID()
	if (C_Map) then
		local mapId = C_Map.GetBestMapForUnit ("player")
		if (mapId) then
			return mapId
		else
			return 0
		end
	else
		return GetCurrentMapAreaID()
	end
end

--return the current map the map is showing
function WorldQuestTracker.GetCurrentMapAreaID()
	--local mapID = WorldQuestTracker.DataProvider:GetMap():GetMapID()
	local mapID = WorldMapFrame.mapID
	
	if (mapID) then
		return mapID
	else
		if (C_Map) then
			local mapId = C_Map.GetBestMapForUnit ("player")
			if (mapId) then
				return mapId
			else
				return 0
			end
		else
			return GetCurrentMapAreaID()
		end
	end
end

function WorldQuestTracker.CanShowQuest (info)
	local canShowQuest = WorldQuestTracker.DataProvider:ShouldShowQuest (info)
	return canShowQuest
	--return not WorldQuestTracker.DataProvider.focusedQuestID and not WorldQuestTracker.DataProvider:IsQuestSuppressed(info.questId);
	--return canShowQuest
end

-- ~filter
function WorldQuestTracker.GetQuestFilterTypeAndOrder (worldQuestType, gold, rewardName, itemName, isArtifact, stackAmount, numRewardItems, rewardTexture)
	local filter, order
	
	--[=[
		/run for key, value in pairs (_G) do if type(key) == "string" and key:find ("LE_QUEST_TAG") then print (key, value) end end
	
		LE_QUEST_TAG_TYPE_PVP = 3
		LE_QUEST_TAG_TYPE_PET_BATTLE = 4
		LE_QUEST_TAG_TYPE_NORMAL = 2
		LE_QUEST_TAG_TYPE_PROFESSION = 1
		LE_QUEST_TAG_TYPE_DUNGEON = 6
		LE_QUEST_TAG_TYPE_RAID = 8
		LE_QUEST_TAG_TYPE_TAG = 0
		LE_QUEST_TAG_TYPE_BOUNTY = 5
		LE_QUEST_TAG_TYPE_INVASION = 7
		LE_QUEST_TAG_TYPE_INVASION_WRAPPER = 11
	--]=]

--debug	
	if (worldQuestType == LE_QUEST_TAG_TYPE_NORMAL) then
	--	print (LE_QUEST_TAG_TYPE_NORMAL, gold, rewardName, itemName, isArtifact, stackAmount, numRewardItems, rewardTexture)
	end
	
	if (worldQuestType == LE_QUEST_TAG_TYPE_PET_BATTLE) then
		return FILTER_TYPE_PET_BATTLES, WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_PETBATTLE]
		
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_PVP) then
		return FILTER_TYPE_PVP, WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_PVP]
		
	
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_PROFESSION) then
		return FILTER_TYPE_PROFESSION, WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_PROFESSION]
		
	elseif (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
		filter = FILTER_TYPE_DUNGEON
		order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_DUNGEON]
	end
	
	if (gold and gold > 0) then
		order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_GOLD]
		filter = FILTER_TYPE_GOLD
		
	end	

	if (rewardName) then
		--resources
		if (WorldQuestTracker.MapData.ResourceIcons [rewardTexture]) then
			order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_RESOURCE]
			filter = FILTER_TYPE_GARRISON_RESOURCE
		
		--reputation
		elseif (WorldQuestTracker.MapData.ReputationIcons [rewardTexture]) then
			order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_RESOURCE]
			filter = FILTER_TYPE_REPUTATION_TOKEN
		
		--trade skill
		elseif (WorldQuestTracker.MapData.TradeSkillIcons [rewardTexture]) then
			order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_TRADE]
			filter = FILTER_TYPE_TRADESKILL

		end
	end	
	
	if (isArtifact) then
		order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_APOWER]
		filter = FILTER_TYPE_ARTIFACT_POWER
		
	elseif (itemName) then
		if (stackAmount > 1) then
			order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_TRADE]
			filter = FILTER_TYPE_TRADESKILL
		else
			order = WorldQuestTracker.db.profile.sort_order [WQT_QUESTTYPE_EQUIPMENT]
			filter = FILTER_TYPE_EQUIPMENT
		end
	end
	
	--> if dungeons are disabled, override the quest type to dungeon
	if (worldQuestType == LE_QUEST_TAG_TYPE_DUNGEON) then
		if (not WorldQuestTracker.db.profile.filters [FILTER_TYPE_DUNGEON]) then
			filter = FILTER_TYPE_DUNGEON
		end
	end
	
	if (not filter) then
		filter = FILTER_TYPE_GARRISON_RESOURCE
		order = 9
	end
	
	return filter, order
end


--create a tooltip scanner
local GameTooltipFrame = CreateFrame ("GameTooltip", "WorldQuestTrackerScanTooltip", nil, "GameTooltipTemplate")
local GameTooltipFrameTextLeft1 = _G ["WorldQuestTrackerScanTooltipTextLeft2"]
local GameTooltipFrameTextLeft2 = _G ["WorldQuestTrackerScanTooltipTextLeft3"]
local GameTooltipFrameTextLeft3 = _G ["WorldQuestTrackerScanTooltipTextLeft4"]
local GameTooltipFrameTextLeft4 = _G ["WorldQuestTrackerScanTooltipTextLeft5"]

--attempt to get the item level of the item
function WorldQuestTracker.RewardRealItemLevel (questID)
	GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
	--GameTooltipFrame:SetHyperlink (itemLink)
	GameTooltipFrame:SetQuestLogItem ("reward", 1, questID)
	
	local Text = GameTooltipFrameTextLeft1:GetText() or GameTooltipFrameTextLeft2:GetText() or ""
	local itemLevel = tonumber (Text:match ("%d+"))
	
	return itemLevel or 1
end

--try to guess the amount of artifact power the item can give �rtifact ~artifact
	
	--asia
	function WorldQuestTracker.RewardIsArtifactPowerAsian (itemLink) -- thanks @yuk6196 on curseforge

		GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
		GameTooltipFrame:SetHyperlink (itemLink)
		local text = GameTooltipFrameTextLeft1:GetText()

		if (text and text:match ("|cFFE6CC80")) then
			local power = GameTooltipFrameTextLeft3:GetText()
			if (power) then
				local n = tonumber (power:match ("[%d.]+"))
				if (power:find (SECOND_NUMBER)) then
					n = n * 10000
				elseif (power:find (THIRD_NUMBER)) then
					n = n * 100000000
				elseif (power:find (FOURTH_NUMBER)) then
					n = n * 1000000000000
				end
				return true, n or 0
			end
		end

		local text2 = GameTooltipFrameTextLeft2:GetText()
		if (text2 and text2:match ("|cFFE6CC80")) then
			local power = GameTooltipFrameTextLeft4:GetText()
			if (power) then
				local n = tonumber (power:match ("[%d.]+"))
				if (power:find (SECOND_NUMBER)) then
					n = n * 10000
				elseif (power:find (THIRD_NUMBER)) then
					n = n * 100000000
				elseif (power:find (FOURTH_NUMBER)) then
						n = n * 1000000000000
					end
					return true, n or 0
				end
			end
		end

		--german
		function WorldQuestTracker.RewardIsArtifactPowerGerman (itemLink) -- thanks @Superanuki on curseforge

			local w1, w2, w3, w4 = "Millionen", "Million", "%d+,%d+", "([^,]+),([^,]+)" --works for German

			if (WorldQuestTracker.GameLocale == "ptBR") then
				w1, w2, w3, w4 = "milh", "milh", "%d+,%d+", "([^,]+).([^,]+)" --@tercio 11 october 2017: replaced the dot with a comma on "%d+,%d+"
			elseif (WorldQuestTracker.GameLocale == "frFR") then
				w1, w2, w3, w4 = "million", "million", "%d+,%d+", "([^,]+),([^,]+)"
			end

			GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
			GameTooltipFrame:SetHyperlink (itemLink)
			local text = GameTooltipFrameTextLeft1:GetText()
			
			if (text and text:match ("|cFFE6CC80")) then
				local power = GameTooltipFrameTextLeft3:GetText()
				if (power) then
					if (power:find (w1) or power:find (w2)) then

						local n=power:match(w3)
						if n then 
							local one,two=n:match(w4) n=one.."."..two 
						end
						n = tonumber (n)

						if (not n) then
							n = power:match (" %d+ ") --thanks @Arwarld_ on curseforge - ticket #427
							n = tonumber (n)

							if (n) then
								n=n..".0"
								n = tonumber (n)
							end
						end
						
						if (n) then
							n = n * 1000000
							return true, n or 0
						end
					end
					
					if (WorldQuestTracker.GameLocale == "frFR") then
						power = power:gsub ("%s", ""):gsub ("%p", ""):match ("%d+")
					else
						power = power:gsub ("%p", ""):match ("%d+")
					end
					
					power = tonumber (power)
					return true, power or 0
				end
			end
			
			local text2 = GameTooltipFrameTextLeft2:GetText()
			if (text2 and text2:match ("|cFFE6CC80")) then
				local power = GameTooltipFrameTextLeft4:GetText()
				if (power) then
				
					if (power:find (w1) or power:find (w2)) then
						local n=power:match(w3)
						
						if n then 
							local one,two=n:match(w4) n=one.."."..two 
						end
						n = tonumber (n)
						if (not n) then
							n = power:match (" %d+ ")
							n = tonumber (n)
							n=n..".0"
							n = tonumber (n)
						end
						
						if (n) then
							n = n * 1000000
							return true, n or 0
						end
					end
					
					if (WorldQuestTracker.GameLocale == "frFR") then
						power = power:gsub ("%s", ""):gsub ("%p", ""):match ("%d+")
					else
						power = power:gsub ("%p", ""):match ("%d+")
					end
					
					power = tonumber (power)
					return true, power or 0
				end
			end
		end

-- /run for a, b in pairs (_G) do if(b=="Artifact Power") then print (a, b) end end

		--global
		function WorldQuestTracker.RewardIsArtifactPower (itemLink)

			if (WorldQuestTracker.GameLocale == "koKR" or WorldQuestTracker.GameLocale == "zhTW" or WorldQuestTracker.GameLocale == "zhCN") then
				return WorldQuestTracker.RewardIsArtifactPowerAsian (itemLink)
			
			elseif (WorldQuestTracker.GameLocale == "deDE" or WorldQuestTracker.GameLocale == "ptBR" or WorldQuestTracker.GameLocale == "frFR") then
				return WorldQuestTracker.RewardIsArtifactPowerGerman (itemLink)
			end

			GameTooltipFrame:SetOwner (WorldFrame, "ANCHOR_NONE")
			GameTooltipFrame:SetHyperlink (itemLink)

			local text = GameTooltipFrameTextLeft1:GetText()
			local power = GameTooltipFrameTextLeft3:GetText()
			
			if ((text and text:match ("|cFFE6CC80")) or (power and power:match (ARTIFACT_POWER))) then
			
				if (power) then
					if (power:find (SECOND_NUMBER)) then
						local n = power:match (" %d+%.%d+ ")
						n = tonumber (n)
						if (not n) then
							n = power:match (" %d+ ")
							n = tonumber (n)
						end
						if (n) then
							n = n * 1000000
							return true, n or 0
						end
						
					elseif (power:find (THIRD_NUMBER)) then
						local n = power:match (" %d+%.%d+ ")
						n = tonumber (n)
						if (not n) then
							n = power:match (" %d+ ")
							n = tonumber (n)
						end
						if (n) then
							n = n * 1000000000
							return true, n or 0
						end
					end

					if (WorldQuestTracker.GameLocale == "frFR") then
						power = power:gsub ("%s", ""):gsub ("%p", ""):match ("%d+")
					else
						power = power:gsub ("%p", ""):match ("%d+")
					end
					
					power = tonumber (power)
					return true, power or 0
				end
			end

			local text2 = GameTooltipFrameTextLeft2:GetText() --thanks @Prejudice182 on curseforge
			if (text2 and text2:match ("|cFFE6CC80")) then
				local power = GameTooltipFrameTextLeft4:GetText()
				if (power) then
				
					if (power:find (SECOND_NUMBER)) then
						local n = power:match (" %d+%.%d+ ")
						n = tonumber (n)
						if (not n) then
							n = power:match (" %d+ ")
							n = tonumber (n)
						end
						if (n) then
							n = n * 1000000
							return true, n or 0
						end
					end
				
					if (WorldQuestTracker.GameLocale == "frFR") then
						power = power:gsub ("%s", ""):gsub ("%p", ""):match ("%d+")
					else
						power = power:gsub ("%p", ""):match ("%d+")
					end
					power = tonumber (power)
					return true, power or 0
				end
			end
		end

	--gold amount
	function WorldQuestTracker.GetQuestReward_Gold (questID)
		local gold = GetQuestLogRewardMoney  (questID) or 0
		local formated
		if (gold > 10000000) then
			formated = gold / 10000 --remove os zeros
			formated = string.format ("%.1fK", formated / 1000)
		else
			formated = floor (gold / 10000)
		end
		return gold, formated
	end

	--resource amount
	function WorldQuestTracker.GetQuestReward_Resource (questID)
		local numQuestCurrencies = GetNumQuestLogRewardCurrencies (questID)
		if (numQuestCurrencies == 2) then
		
			for i = 1, numQuestCurrencies do
				local name, texture, numItems = GetQuestLogRewardCurrencyInfo (i, questID)
				--legion invasion quest
				if (texture and 
					(
						(type (texture) == "number" and texture == 132775) or
						(type (texture) == "string" and (texture:find ("inv_datacrystal01") or texture:find ("inv_misc_summonable_boss_token")))
					)   
				) then -- [[Interface\Icons\inv_datacrystal01]]
				else
					return name, texture, numItems
				end
			end
		else
			for i = 1, numQuestCurrencies do
				local name, texture, numItems = GetQuestLogRewardCurrencyInfo (i, questID)
				return name, texture, numItems
			end
		end
	end

	--local ItemTooltipScan = CreateFrame ("GameTooltip", "WQTItemTooltipScan", UIParent, "EmbeddedItemTooltip")
	local ItemTooltipScan = CreateFrame ("GameTooltip", "WQTItemTooltipScan", UIParent, "InternalEmbeddedItemTooltipTemplate")
	ItemTooltipScan.texts = {
		_G ["WQTItemTooltipScanTooltipTextLeft1"],
		_G ["WQTItemTooltipScanTooltipTextLeft2"],
		_G ["WQTItemTooltipScanTooltipTextLeft3"],
		_G ["WQTItemTooltipScanTooltipTextLeft4"],
	}
	ItemTooltipScan.patern = ITEM_LEVEL:gsub ("%%d", "(%%d+)") --from LibItemUpgradeInfo-1.0

	--pega o premio item da quest
	function WorldQuestTracker.GetQuestReward_Item (questID)
		if (not HaveQuestData (questID)) then
			return
		end
		
		--artifact power - 8.0 version
		local numQuestCurrencies = GetNumQuestLogRewardCurrencies (questID)
		if (numQuestCurrencies == 1) then
			--is artifact power?
			local name, texture, numItems = GetQuestLogRewardCurrencyInfo (1, questID)
			
			if (texture == 1830317 or texture == 2065624) then
				GameTooltip_AddQuestRewardsToTooltip (WorldMapTooltip, questID)
				
				local amount
				local t2 = WorldMapTooltipTooltipTextLeft2 and WorldMapTooltipTooltipTextLeft2:GetText()
				if (t2) then
					amount = tonumber (t2:match (" %d+ "))
				end
				
				return name, texture, 0, 1, 1, false, 0, true, amount or 0, false, 1
			end
		end
		
		local numQuestRewards = GetNumQuestLogRewards (questID)
		if (numQuestRewards > 0) then
			local itemName, itemTexture, quantity, quality, isUsable, itemID = GetQuestLogRewardInfo (1, questID)
			if (itemID) then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice, itemClassID, itemSubClassID = GetItemInfo (itemID)

				if (itemName) then
					EmbeddedItemTooltip_SetItemByQuestReward (ItemTooltipScan, 1, questID)
					for i = 1, 4 do
						local text = ItemTooltipScan.texts [i]:GetText()
						if (text and text ~= "") then
							local ilvl = tonumber (text:match (ItemTooltipScan.patern))
							if (ilvl) then
								itemLevel = ilvl
								break
							end
						end
					end
				
					local icon = WorldQuestTracker.MapData.EquipmentIcons [itemEquipLoc]
					if (not icon and itemClassID == 3 and itemSubClassID == 11) then
						icon = WorldQuestTracker.MapData.EquipmentIcons ["Relic"]
					end
					
					if (icon and not WorldQuestTracker.db.profile.use_old_icons) then
						itemTexture = icon
					end
				
					local isArtifact, artifactPower = WorldQuestTracker.RewardIsArtifactPower (itemLink)

					local hasUpgrade = WorldQuestTracker.RewardRealItemLevel (questID)
					itemLevel = itemLevel > hasUpgrade and itemLevel or hasUpgrade
					
					if (isArtifact) then
						return itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, true, artifactPower, itemStackCount > 1, itemStackCount
					else
						--Returning an equipment
						return itemName, itemTexture, itemLevel, quantity, quality, isUsable, itemID, false, 0, itemStackCount > 1, itemStackCount
					end
				else
					--ainda n�o possui info do item
					return
				end
			else
				--ainda n�o possui info do item
				return
			end
		end
	end
