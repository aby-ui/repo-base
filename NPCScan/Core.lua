-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
-- Functions
local pairs = _G.pairs

-- Libraries
local string = _G.string
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data
local Enum = private.Enum

local LibStub = _G.LibStub

local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local HereBeDragons = LibStub("HereBeDragons-2.0")
local NPCScan = LibStub("AceAddon-3.0"):NewAddon(AddOnFolderName, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0", "LibSink-2.0", "LibToast-1.0")
local VL = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName .. "Vignette")

-- ----------------------------------------------------------------------------
-- Debugger.
-- ----------------------------------------------------------------------------
do
	local TextDump = LibStub("LibTextDump-1.0")

	local DEBUGGER_WIDTH = 750
	local DEBUGGER_HEIGHT = 800

	local debugger

	local function GetDebugger()
		if not debugger then
			debugger = TextDump:New(("%s Debug Output"):format(AddOnFolderName), DEBUGGER_WIDTH, DEBUGGER_HEIGHT)
		end

		return debugger
	end

	private.GetDebugger = GetDebugger

	function private.Debug(...)
		local message = string.format(...)
		GetDebugger():AddLine(message, "%X")

		return message
	end
end

-- ----------------------------------------------------------------------------
-- Variables.
-- ----------------------------------------------------------------------------
local AchievementLabel = {}

for label, ID in pairs(Enum.AchievementID) do
	AchievementLabel[ID] = label
end

local NPCIDFromName = {}
private.NPCIDFromName = NPCIDFromName

local QuestNPCs = {}
private.QuestNPCs = QuestNPCs

local QuestIDFromName = {}
private.QuestIDFromName = QuestIDFromName

local VignetteNPCs = {}
private.VignetteNPCs = VignetteNPCs

local VignetteIDToNPCMapping = {}
private.VignetteIDToNPCMapping = VignetteIDToNPCMapping

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
local function TryAssignNPCToAchievement(npcDataField, achievement, achievementAssetID, achievementCriteriaID, isCriteriaCompleted)
	local foundMatch = false

	for npcID in pairs(Data.NPCs) do
		local npc = Data.NPCs[npcID]

		if npc[npcDataField] == achievementAssetID then
			foundMatch = true

			npc.achievementID = achievement.ID
			npc.achievementCriteriaID = achievementCriteriaID
			npc.isCriteriaCompleted = isCriteriaCompleted

			achievement.criteriaNPCs[npcID] = true

			break;
		end

	end

	if not foundMatch then
		private.Debug("***** AchievementID.%s - not assigned to an NPC: %s = %d,", AchievementLabel[achievement.ID], npcDataField, achievementAssetID)
	end
end

-- ----------------------------------------------------------------------------
-- AddOn Methods.
-- ----------------------------------------------------------------------------
function NPCScan:OnInitialize()
	-- ----------------------------------------------------------------------------
	-- Data initialization
	-- ----------------------------------------------------------------------------
	local DefaultPreferences = private.DefaultPreferences
	local UIMapType = _G.Enum.UIMapType

	for _, achievementID in pairs(Enum.AchievementID) do
		DefaultPreferences.profile.detection.achievementIDs[achievementID] = Enum.DetectionGroupStatus.Enabled
	end

	for _, continentID in pairs(Enum.ContinentID) do
		local continent = Data.Continents[continentID]

		if not continent then
			continent = {
				Maps = {}
			}

			Data.Continents[continentID] = continent
		end

		continent.ID = continentID
		continent.name = HereBeDragons:GetLocalizedMap(Enum.ContinentMapID[continentID])

		DefaultPreferences.profile.detection.continentIDs[continentID] = Enum.DetectionGroupStatus.Enabled
	end

	for mapID, map in pairs(Data.Maps) do
		local continentInfo = _G.MapUtil.GetMapParentInfo(mapID, _G.Enum.UIMapType.Continent)
		local continentID = continentInfo and Enum.MapContinentID[continentInfo.mapID] or Enum.ContinentID.Cosmic
		local mapInfo = _G.C_Map.GetMapInfo(mapID)

		if mapInfo.mapType == UIMapType.Dungeon or mapInfo.mapType == UIMapType.Orphan then
			map.isDungeon = true
		end

		map.continentID = continentID
		map.ID = mapID
		map.name = HereBeDragons:GetLocalizedMap(mapID) or _G.UNKNOWN

		Data.Continents[continentID].Maps[mapID] = map
	end

	local db = LibStub("AceDB-3.0"):New("NPCScanDB", DefaultPreferences, "Default")
	db.RegisterCallback(self, "OnProfileChanged", "RefreshPreferences")
	db.RegisterCallback(self, "OnProfileCopied", "RefreshPreferences")
	db.RegisterCallback(self, "OnProfileReset", "RefreshPreferences")

	self:DefineSinkToast(AddOnFolderName, [[Interface\LFGFRAME\BattlenetWorking0]])
	self:SetSinkStorage(db.profile.alert.output)

	private.db = db

	-- ----------------------------------------------------------------------------
	-- DB migrations
	-- ----------------------------------------------------------------------------
	local sharedMediaNames = db.profile.alert.sound.sharedMediaNames

	for index = 1, 50 do
		local actualName = sharedMediaNames[index]
		if actualName then
			sharedMediaNames[actualName] = true
			sharedMediaNames[index] = nil
		end
	end

	self:RegisterChatCommand("npcscan", "ChatCommand")
end

function NPCScan:OnEnable()
	-- ----------------------------------------------------------------------------
	-- Build lookup tables.
	-- ----------------------------------------------------------------------------
	for mapID, map in pairs(Data.Maps) do
		for npcID in pairs(map.NPCs) do
			local npc = Data.NPCs[npcID]

			if not npc then
				npc = {}
				Data.NPCs[npcID] = npc
			end

			map.NPCs[npcID] = npc

			npc.mapIDs = npc.mapIDs or {}
			npc.mapIDs[#npc.mapIDs + 1] = mapID
			npc.npcID = npcID

			-- This sets values for NPCIDFromName, which is used for vignette detection.
			self:GetNPCNameFromID(npcID)
		end
	end

	for npcID, npc in pairs(Data.NPCs) do
		table.sort(npc.mapIDs, private.SortByMapNameThenByID)

		if npc.questID then
			local npcIDs = QuestNPCs[npc.questID]
			if not npcIDs then
				npcIDs = {}
				QuestNPCs[npc.questID] = npcIDs
			end

			npcIDs[npcID] = true

			local questName = NPCScan:GetQuestNameFromID(npc.questID)
			if questName and questName ~= _G.UNKNOWN then
				QuestIDFromName[questName] = npc.questID
			end
		end

		if npc.vignetteName then
			local vignetteName = VL[npc.vignetteName]

			local npcIDs = VignetteNPCs[vignetteName]
			if not npcIDs then
				npcIDs = {}
				VignetteNPCs[vignetteName] = npcIDs
			end

			npcIDs[npcID] = true
		end

		if npc.vignetteID then
			VignetteIDToNPCMapping[npc.vignetteID] = npc
		end

		if npc.vignetteIDs then
			for index = 1, #npc.vignetteIDs do
				VignetteIDToNPCMapping[npc.vignetteIDs[index]] = npc
			end
		end
	end

	-- ----------------------------------------------------------------------------
	-- Assign Achievement ID to appropriate NPCData entry.
	-- ----------------------------------------------------------------------------
	local CriteriaType = {
		NPCKill = 0,
		Quest = 27,
		Spell = 28,
		Item = 36,
	}

	for achievementID, achievement in pairs(Data.Achievements) do
		local _, _, _, isAchievementCompleted = _G.GetAchievementInfo(achievementID)

		achievement.ID = achievementID
		achievement.isCompleted = isAchievementCompleted

		for criteriaIndex = 1, _G.GetAchievementNumCriteria(achievementID) do
			local assetName, criteriaType, isCriteriaCompleted, _, _, _, _, assetID, _, criteriaID = _G.GetAchievementCriteriaInfo(achievementID, criteriaIndex)

			if criteriaType == CriteriaType.NPCKill then
				if assetID > 0 then
					local found

					for _, mapData in pairs(Data.Maps) do
						if mapData.NPCs[assetID] then
							found = true
							break
						end
					end

					if found then
						local npc = Data.NPCs[assetID]
						npc.achievementID = achievementID
						npc.achievementCriteriaID = criteriaID
						npc.isCriteriaCompleted = isCriteriaCompleted

						achievement.criteriaNPCs[assetID] = true
					else
						private.Debug("***** AchievementID.%s: NPC %s with assetID %d", AchievementLabel[achievementID], assetName, assetID)
					end
				end
			elseif criteriaType == CriteriaType.Quest then
				if QuestNPCs[assetID] then
					for npcID in pairs(QuestNPCs[assetID]) do
						local npc = Data.NPCs[npcID]
						npc.achievementID = achievementID
						npc.achievementCriteriaID = criteriaID
						npc.isCriteriaCompleted = isCriteriaCompleted

						achievement.criteriaNPCs[npcID] = true
					end
				else
					private.Debug("***** AchievementID.%s: (criteriaID %d) questID = %d, -- %s", AchievementLabel[achievementID], criteriaID, assetID, assetName)
				end
			elseif criteriaType == CriteriaType.Item then
				TryAssignNPCToAchievement("achievementItemID", achievement, assetID, criteriaID, isCriteriaCompleted)
			elseif criteriaType == CriteriaType.Spell then
				TryAssignNPCToAchievement("achievementSpellID", achievement, assetID, criteriaID, isCriteriaCompleted)
			else
				private.Debug("***** AchievementID.%s: Unknown criteria type %d, assetID %d", AchievementLabel[achievementID], criteriaType, assetID)
			end
		end
	end

	for mapID, map in pairs(Data.Maps) do
		local mapHeaderPrinted

		for npcID in pairs(map.NPCs) do
			if mapID >= Enum.MapID.Zuldazar then
				local npc = map.NPCs[npcID]

				if not npc.questID and not npc.achievementID then
					if not mapHeaderPrinted then
						mapHeaderPrinted = true
						private.Debug("-- ----------------------------------------------------------------------------")
						private.Debug("-- %s (%d)", HereBeDragons:GetLocalizedMap(mapID), mapID)
						private.Debug("-- ----------------------------------------------------------------------------")
					end

					private.Debug("NPC %d (%s) has no questID.", npcID, self:GetNPCNameFromID(npcID))
				end
			end
		end
	end

	-- Handle custom additions.
	for npcID, npcName in pairs(private.db.locale.npcNames) do
		NPCIDFromName[npcName] = npcID
	end

	self:SetupOptions()
	self:InitializeTargetButton()

	self:RegisterBucketEvent("CRITERIA_UPDATE", 5)
	self:RegisterEvent("LOOT_CLOSED")
	self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("VIGNETTE_MINIMAP_UPDATED")
	self:RegisterBucketEvent("VIGNETTES_UPDATED", 0.5)

	HereBeDragons.RegisterCallback(NPCScan, "PlayerZoneChanged", "UpdateScanList")

	self:UpdateScanList()
	private.Overlays.Register()
end

function NPCScan:RefreshPreferences()
end

do
	local DatamineTooltip = _G.CreateFrame("GameTooltip", "NPCScanDatamineTooltip", _G.UIParent, "GameTooltipTemplate")
	DatamineTooltip:SetOwner(_G.WorldFrame, "ANCHOR_NONE")

	function NPCScan:GetNPCNameFromID(npcID)
		local npcName = private.db.locale.npcNames[npcID]

		if not npcName then
			DatamineTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(npcID))

			npcName = _G["NPCScanDatamineTooltipTextLeft1"]:GetText()

			if npcName and npcName ~= "" then
				private.db.locale.npcNames[npcID] = npcName
				NPCIDFromName[npcName] = npcID
			else
				npcName = _G.UNKNOWN
			end
		end

		return npcName
	end

	function NPCScan:GetQuestNameFromID(questID)
		local questName = private.db.locale.questNames[questID]

		if not questName then
			DatamineTooltip:SetHyperlink(("quest:%d"):format(questID))

			questName = _G["NPCScanDatamineTooltipTextLeft1"]:GetText()

			if questName and questName ~= "" then
				private.db.locale.questNames[questID] = questName
				private.QuestIDFromName[questName] = questID
			else
				questName = _G.UNKNOWN
			end
		end

		return questName:gsub("Vignette: ", "")
	end
end

do
	local SUBCOMMAND_FUNCS

	 function NPCScan:ChatCommand(input)
		SUBCOMMAND_FUNCS =
			SUBCOMMAND_FUNCS or
			{
				ADD = private.AddUserDefinedNPC,
				COMPARE = private.CompareData,
				REMOVE = private.RemoveUserDefinedNPC,
				SEARCH = function(subject)
					AceConfigDialog:Open(AddOnFolderName)
					AceConfigDialog:SelectGroup(AddOnFolderName, "npcOptions", "search")
					private.PerformNPCSearch(subject)
				end,
				--[===[@debug@
				DEBUG = function()
					local debugger = private.GetDebugger()

					if debugger:Lines() == 0 then
						debugger:AddLine("Nothing to report.")
						debugger:Display()
						debugger:Clear()
						return
					end

					debugger:Display()
				end,
				DUMP = function(dumpType, parameters)
					local func = private.DUMP_COMMANDS[dumpType]

					if func then
						private.TextDump = private.TextDump or _G.LibStub("LibTextDump-1.0"):New(AddOnFolderName)
						func(parameters)
					else
						NPCScan:Print("Unknown dump command. Valid commands:")

						for command in pairs(private.DUMP_COMMANDS) do
							NPCScan:Printf("     %s", command)
						end
					end
				end
				--@end-debug@]===]
			}

		local subcommand, arg1, arg2 = self:GetArgs(input, 3)

		if subcommand then
			local func = SUBCOMMAND_FUNCS[subcommand:upper()]

			if func then
				func(arg1, arg2)
			end
		else
			AceConfigDialog:Open(AddOnFolderName)
		end
	end
end -- do-block
