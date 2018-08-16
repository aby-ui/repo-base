-- ----------------------------------------------------------------------------
-- Localized Lua globals.
-- ----------------------------------------------------------------------------
-- Functions
local pairs = _G.pairs

-- Libraries
local table = _G.table

-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

local Data = private.Data
local Enum = private.Enum

local LibStub = _G.LibStub

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local NPCScan = LibStub("AceAddon-3.0"):GetAddon(AddOnFolderName)
local L = LibStub("AceLocale-3.0"):GetLocale(AddOnFolderName)

-- ----------------------------------------------------------------------------
-- Variables.
-- ----------------------------------------------------------------------------
local profile

-- ----------------------------------------------------------------------------
-- Helpers.
-- ----------------------------------------------------------------------------
-- ----------------------------------------------------------------------------
-- Ignored continent options.
-- ----------------------------------------------------------------------------
local AlphabeticalContinentMaps = {}
local ContinentAndMapOptions = {}
local ContinentIDs = {}

local function UpdateContinentAndMapOptions()
	table.wipe(ContinentAndMapOptions)

	if #ContinentIDs == 0 then
		for index = 1, #Enum.ContinentMapID do
			ContinentIDs[#ContinentIDs + 1] = index
		end

		table.sort(
			ContinentIDs,
			function(a, b)
				return Data.Continents[a].name < Data.Continents[b].name
			end
		)
	end

	if #AlphabeticalContinentMaps == 0 then
		for mapID, mapData in pairs(Data.Maps) do
			local continentID = mapData.continentID

			AlphabeticalContinentMaps[continentID] = AlphabeticalContinentMaps[continentID] or {}
			AlphabeticalContinentMaps[continentID][#AlphabeticalContinentMaps[continentID] + 1] = mapID
		end

		for index = 1, #AlphabeticalContinentMaps do
			table.sort(AlphabeticalContinentMaps[index], private.SortByMapNameThenByID)
		end
	end

	for continentIndex = 1, #ContinentIDs do
		local continentID = ContinentIDs[continentIndex]
		local continentStatus = profile.detection.continentIDs[continentID]
		local continent = Data.Continents[continentID]

		local continentOptionsTable = {
			order = continentIndex,
			name = ("%s%s|r"):format(private.DetectionGroupStatusColors[continentStatus], continent.name),
			descStyle = "inline",
			type = "group",
			childGroups = "tab",
			args = {
				status = {
					order = 1,
					name = _G.STATUS,
					type = "select",
					values = private.DetectionGroupStatusLabels,
					get = function()
						return profile.detection.continentIDs[continentID]
					end,
					set = function(_, value)
						profile.detection.continentIDs[continentID] = value

						if value ~= Enum.DetectionGroupStatus.UserDefined then
							for mapID in pairs(continent.Maps) do
								profile.blacklist.mapIDs[mapID] = nil
							end
						end

						UpdateContinentAndMapOptions()

						private.UpdateRareNPCOptions()
						private.UpdateTameableRareNPCOptions()

						if continentID == Data.Scanner.continentID then
							NPCScan:UpdateScanList()
						end
					end
				},
				zoneMapIDs = {
					order = 2,
					name = _G.ZONE,
					type = "group",
					args = {}
				}
			}
		}

		for mapIDIndex = 1, AlphabeticalContinentMaps[continentID] and #AlphabeticalContinentMaps[continentID] or 0 do
			local mapID = AlphabeticalContinentMaps[continentID][mapIDIndex]

			local mapOptions = {
				order = mapIDIndex,
				name = private.GetMapOptionName(mapID),
				desc = ("%s %s"):format(_G.ID, mapID),
				type = "toggle",
				width = "full",
				descStyle = "inline",
				disabled = function()
					return profile.detection.continentIDs[continentID] ~= Enum.DetectionGroupStatus.UserDefined
				end,
				get = function()
					return not profile.blacklist.mapIDs[mapID]
				end,
				set = function()
					profile.blacklist.mapIDs[mapID] = not profile.blacklist.mapIDs[mapID] and true or nil

					UpdateContinentAndMapOptions()

					private.UpdateRareNPCOptions()
					private.UpdateTameableRareNPCOptions()

					AceConfigRegistry:NotifyChange(AddOnFolderName)

					if mapID == Data.Scanner.mapID then
						NPCScan:UpdateScanList()
					end
				end
			}

			if Data.Maps[mapID].isDungeon then
				local dungeonOptionsTable = continentOptionsTable.args.dungeonMapIDs

				if not dungeonOptionsTable then
					dungeonOptionsTable = {
						order = 3,
						name = _G.DUNGEONS,
						type = "group",
						args = {}
					}

					continentOptionsTable.args.dungeonMapIDs = dungeonOptionsTable
				end

				dungeonOptionsTable.args["mapID" .. mapID] = mapOptions
			else
				continentOptionsTable.args.zoneMapIDs.args["mapID" .. mapID] = mapOptions
			end
		end

		ContinentAndMapOptions["continentID" .. continentID] = continentOptionsTable
	end

	AceConfigRegistry:NotifyChange(AddOnFolderName)
end

-- ----------------------------------------------------------------------------
-- Initialization.
-- ----------------------------------------------------------------------------
local DetectionOptions

local function GetDetectionOptions()
	profile = private.db.profile

	DetectionOptions =
		DetectionOptions or
		{
			name = L["Detection"],
			order = 2,
			type = "group",
			childGroups = "tab",
			args = {
				general = {
					order = 1,
					name = _G.GENERAL_LABEL,
					type = "group",
					args = {
						interval = {
							order = 1,
							name = L["Interval"],
							desc = L["The number of minutes before an NPC will be detected again."],
							type = "range",
							width = "full",
							min = 0.5,
							max = 60,
							get = function()
								return profile.detection.intervalSeconds / 60
							end,
							set = function(_, value)
								profile.detection.intervalSeconds = value * 60
							end
						},
						ignore = {
							order = 2,
							name = _G.IGNORE,
							type = "group",
							guiInline = true,
							args = {
								completedAchievementCriteria = {
									order = 1,
									type = "toggle",
									name = L["Completed Achievement Criteria"],
									descStyle = "inline",
									width = "full",
									get = function()
										return profile.detection.ignoreCompletedAchievementCriteria
									end,
									set = function(_, value)
										profile.detection.ignoreCompletedAchievementCriteria = value
										NPCScan:UpdateScanList()
									end
								},
								completedQuestObjectives = {
									order = 2,
									type = "toggle",
									name = L["Completed Quest Objectives"],
									descStyle = "inline",
									width = "full",
									get = function()
										return profile.detection.ignoreCompletedQuestObjectives
									end,
									set = function(_, value)
										profile.detection.ignoreCompletedQuestObjectives = value
										NPCScan:UpdateScanList()
									end
								},
								deadNPCs = {
									order = 3,
									type = "toggle",
									name = L["Dead NPCs"],
									descStyle = "inline",
									width = "full",
									get = function()
										return profile.detection.ignoreDeadNPCs
									end,
									set = function(_, value)
										profile.detection.ignoreDeadNPCs = value
										NPCScan:UpdateScanList()
									end
								},
								miniMap = {
									order = 4,
									type = "toggle",
									name = _G.MINIMAP_LABEL,
									descStyle = "inline",
									width = "full",
									get = function()
										return profile.detection.ignoreMiniMap
									end,
									set = function(_, value)
										profile.detection.ignoreMiniMap = value
										NPCScan:UpdateScanList()
									end
								},
								worldMap = {
									order = 5,
									type = "toggle",
									name = _G.WORLD_MAP,
									descStyle = "inline",
									width = "full",
									get = function()
										return profile.detection.ignoreWorldMap
									end,
									set = function(_, value)
										profile.detection.ignoreWorldMap = value
										NPCScan:UpdateScanList()
									end
								}
							}
						}
					}
				},
				continentsAndMaps = {
					order = 2,
					name = _G.CONTINENT,
					type = "group",
					childGroups = "tree",
					args = ContinentAndMapOptions
				}
			}
		}

	UpdateContinentAndMapOptions()

	return DetectionOptions
end

private.GetDetectionOptions = GetDetectionOptions
