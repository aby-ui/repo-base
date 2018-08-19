-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local pairs = _G.pairs
local tonumber = _G.tonumber
local tostring = _G.tostring
local type = _G.type

-- Libraries
local table = _G.table

-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local AddOnFolderName, private = ...
local Data = private.Data
local Enum = private.Enum

-----------------------------------------------------------------------
-- Helpers
-----------------------------------------------------------------------
local function CreateAlphaAnimation(animationGroup, fromAlpha, toAlpha, duration, startDelay, order)
	local animation = animationGroup:CreateAnimation("Alpha")
	animation:SetFromAlpha(fromAlpha)
	animation:SetToAlpha(toAlpha)
	animation:SetDuration(duration)

	if startDelay then
		animation:SetStartDelay(startDelay)
	end

	if order then
		animation:SetOrder(order)
	end

	return animation
end

private.CreateAlphaAnimation = CreateAlphaAnimation

local function CreateScaleAnimation(animationGroup, fromScaleX, fromScaleY, toScaleX, toScaleY, duration, startDelay, order)
	local animation = animationGroup:CreateAnimation("Scale")
	animation:SetFromScale(fromScaleX, fromScaleY)
	animation:SetToScale(toScaleX, toScaleY)
	animation:SetDuration(duration)

	if startDelay then
		animation:SetStartDelay(startDelay)
	end

	if order then
		animation:SetOrder(order)
	end

	return animation
end

private.CreateScaleAnimation = CreateScaleAnimation

local function FormatAtlasTexture(atlasName)
    local filename, width, height, txLeft, txRight, txTop, txBottom = _G.GetAtlasInfo(atlasName)

    if not filename then
        return
    end

    local atlasWidth = width / (txRight - txLeft)
    local atlasHeight = height / (txBottom - txTop)
    local pxLeft = atlasWidth * txLeft
    local pxRight = atlasWidth * txRight
    local pxTop = atlasHeight * txTop
    local pxBottom = atlasHeight * txBottom

    return ("|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|t"):format(filename, 0, 0, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom)
end

private.FormatAtlasTexture = FormatAtlasTexture

local function GetMapOptionDescription(mapID)
	local continentID = Data.Maps[mapID].continentID

	if continentID then
		local continentName = Data.Continents[continentID].name

		if continentName then
			return ("%s %s %s"):format(_G.ID, mapID, _G.PARENS_TEMPLATE:format(continentName))
		end

		private.Debug("GetMapOptionDescription: No continentName for mapID %d", mapID)
	end

	return ("%s %s"):format(_G.ID, mapID)
end

private.GetMapOptionDescription = GetMapOptionDescription

local function GetMapOptionName(mapID)
	local continentID = Data.Maps[mapID].continentID
	local profile = private.db.profile
	local isBlacklisted = profile.blacklist.mapIDs[mapID] or profile.detection.continentIDs[continentID] == Enum.DetectionGroupStatus.Disabled
	local colorCode = isBlacklisted and _G.RED_FONT_COLOR_CODE or _G.GREEN_FONT_COLOR_CODE
	return ("%s%s|r"):format(colorCode, Data.Maps[mapID].name)
end

private.GetMapOptionName = GetMapOptionName

do
	local ValidUnitTypeNames = {
		Creature = true,
		Vehicle = true,
	}

	local function GUIDToCreatureID(GUID)
		local unitTypeName, _, _, _, _, unitID = ("-"):split(GUID)
		if ValidUnitTypeNames[unitTypeName] then
			return tonumber(unitID)
		end
	end

	private.GUIDToCreatureID = GUIDToCreatureID

	local function UnitTokenToCreatureID(unitToken)
		if unitToken then
			local GUID = _G.UnitGUID(unitToken)
			if not GUID then
				return
			end

			return GUIDToCreatureID(GUID)
		end
	end

	private.UnitTokenToCreatureID = UnitTokenToCreatureID
end -- do-block

local function IsNPCAchievementCriteriaComplete(npc)
	if not npc.achievementID then
		return true
	end

	return Data.Achievements[npc.achievementID].isCompleted or npc.isCriteriaCompleted
end

private.IsNPCAchievementCriteriaComplete = IsNPCAchievementCriteriaComplete

local function IsNPCQuestComplete(npc)
	local questID = npc.questID or npc.achievementQuestID

	return questID and _G.IsQuestFlaggedCompleted(questID) or false
end

private.IsNPCQuestComplete = IsNPCQuestComplete

local function NumericSortString(a, b)
	local x, y = tonumber(a), tonumber(b)

	if x and y then
		return x < y
	end

	return a < b
end

local function TableKeyFormat(input)
	return input and input:upper():gsub(" ", "_"):gsub("'", ""):gsub(":", ""):gsub("-", "_"):gsub("%(", ""):gsub("%)", "") or ""
end

do
	local OrderedDataFields = {
		"factionGroup",
		"isTameable",
		"questID",
		"vignetteName",
	}

	local sectionDelimiter = "-- ----------------------------------------------------------------------------"

	function private.DumpNPCData(continentID)
		local NPCScan = _G.LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)
		local continent = Data.Continents[continentID]

		local sortedMapIDs = {}
		local sortedNPCIDs = {}

		for mapID, map in pairs(continent.Maps) do
			local npcIDs = {}
			sortedNPCIDs[mapID] = npcIDs
			sortedMapIDs[#sortedMapIDs + 1] = mapID

			for npcID in pairs(map.NPCs) do
				npcIDs[#npcIDs + 1] = npcID
			end

			table.sort(sortedNPCIDs[mapID])
		end

		table.sort(sortedMapIDs)

		local output = private.TextDump
		output:Clear()

		output:AddLine(sectionDelimiter)
		output:AddLine("-- AddOn namespace")
		output:AddLine(sectionDelimiter)
		output:AddLine("local AddOnFolderName, private = ...")
		output:AddLine("local NPCs = private.Data.NPCs\n")

		for mapIndex = 1, #sortedMapIDs do
			local map = Data.Maps[sortedMapIDs[mapIndex]]
			local addedZoneHeader = false

			for npcIndex = 1, #sortedNPCIDs[map.ID] do
				local npcID = sortedNPCIDs[map.ID][npcIndex]
				local npc = Data.NPCs[npcID]

				local startedEntry = false

				for index = 1, #OrderedDataFields do
					local field = OrderedDataFields[index]
					local fieldInfo = npc[field]

					if fieldInfo then
						if not addedZoneHeader then
							addedZoneHeader = true

							output:AddLine(sectionDelimiter)
							output:AddLine(("-- %s (%d)"):format(map.name, map.ID))
							output:AddLine(sectionDelimiter)
						end

						if not startedEntry then
							startedEntry = true
							output:AddLine(("NPCs[%d] = { -- %s"):format(npcID, NPCScan:GetNPCNameFromID(npcID)))
						end

						local fieldInfoOutput
						if type(fieldInfo) == "string" then
							fieldInfoOutput = ("\"%s\""):format(fieldInfo:gsub("\"", "\\\""))
						else
							fieldInfoOutput = tostring(fieldInfo)
						end

						local fieldInfoComment = field == "questID" and (" -- %s"):format(NPCScan:GetQuestNameFromID(fieldInfo)) or ""
						output:AddLine(("    %s = %s,%s"):format(field, fieldInfoOutput, fieldInfoComment))
					end
				end

				if startedEntry then
					output:AddLine("}\n")
				end
			end
		end

		output:Display()
	end

	private.DUMP_COMMANDS = {
		npcdata = function(parameters)
			private.DumpNPCData(tonumber(parameters))
		end
	}
end -- do-block
