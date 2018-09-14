-- ----------------------------------------------------------------------------
-- Upvalued Lua API.
-- ----------------------------------------------------------------------------
-- Functions
local getmetatable = _G.getmetatable
local setmetatable = _G.setmetatable

-- Libraries
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

local LibStub = _G.LibStub

local Data = private.Data
local NPCs = Data.NPCs

-- ----------------------------------------------------------------------------
-- Constants
-- ----------------------------------------------------------------------------
local QuestNPCs = {}
private.QuestNPCs = QuestNPCs

local VignetteIDToNPCMapping = {}
private.VignetteIDToNPCMapping = VignetteIDToNPCMapping

-- ----------------------------------------------------------------------------
-- Prototype
-- ----------------------------------------------------------------------------
local NPCPrototype = {
	HasQuest = function(self)
		local questID = self.questID or self.achievementQuestID

		return questID and questID >= 0
	end,
	IsAchievementCriteriaComplete = function(self)
		if not self.achievementID then
			return true
		end

		return Data.Achievements[self.achievementID].isCompleted or self.isCriteriaCompleted
	end,
	IsQuestComplete = function(self)
		local questID = self.questID or self.achievementQuestID

		return questID and questID >= 0 and _G.IsQuestFlaggedCompleted(questID)
	end,
}

local NPCMetatable = {
	__index = NPCPrototype,
}

private.NPCMetatable = NPCMetatable

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------
local function AssignNPCToQuest(npc, questFieldName)
	if npc[questFieldName] then
		local npcs = QuestNPCs[npc[questFieldName]]

		if not npcs then
			npcs = {}
			QuestNPCs[npc[questFieldName]] = npcs
		end

		npcs[npc.npcID] = npc

		local questName = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName):GetQuestNameFromID(npc[questFieldName])

		if questName and questName ~= _G.UNKNOWN then
			private.QuestIDFromName[questName] = npc[questFieldName]
		end
	end
end

local function InitializeNPC(npcID)
	local npc = NPCs[npcID]

	if npc then
		if getmetatable(npc) then
			-- Already initialized.
			return npc
		end
	else
		npc = {}
		NPCs[npcID] = npc
	end

	setmetatable(npc, NPCMetatable)

	npc.npcID = npcID

	-- Sets value for NPCIDFromName.
	LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName):GetNPCNameFromID(npcID)

	AssignNPCToQuest(npc, "questID")
	AssignNPCToQuest(npc, "achievementQuestID")

	if npc.vignetteID then
		VignetteIDToNPCMapping[npc.vignetteID] = VignetteIDToNPCMapping[npc.vignetteID] or {}

		table.insert(VignetteIDToNPCMapping[npc.vignetteID], npc)
	end

	return npc
end

private.InitializeNPC = InitializeNPC
