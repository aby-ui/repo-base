-- ----------------------------------------------------------------------------
-- AddOn namespace.
-- ----------------------------------------------------------------------------
local AddOnFolderName, private = ...

-- ----------------------------------------------------------------------------
-- Constants
-- ----------------------------------------------------------------------------
local DefaultPreferences = {
	locale = {
		npcNames = {},
		questNames = {},
	},
	profile = {
		alert = {
			output = {
				sink20OutputSink = "None",
			},
			screenFlash = {
				color = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
				isEnabled = true,
				texture = "Blizzard Low Health",
			},
			sound = {
				channel = "Master",
				ignoreMute = false,
				isEnabled = true,
				sharedMediaNames = {
					["NPCScan Chimes"] = true,
					["NPCScan Ogre War Drums"] = true,
				},
			}
		},
		blacklist = {
			mapIDs = {},
			npcIDs = {},
		},
		detection = {
			achievementIDs = {},
			continentIDs = {},
			ignoreCompletedAchievementCriteria = true,
			ignoreCompletedQuestObjectives = true,
			ignoreDeadNPCs = true,
			ignoreMinimap = false,
			ignoreWorldMap = false,
			intervalSeconds = 600,
			raidMarker = {
				add = true,
				addInGroup = false,
			},
			rares = true,
			tameables = true,
			userDefined = true,
			whileOnTaxi = false,
		},
		targetButtonGroup = {
			durationSeconds = 60,
			hideDuringCombat = false,
			isEnabled = true,
			point = "TOPRIGHT",
			scale = 1,
			x = -300,
			y = -150,
		},
		userDefined = {
			continentNPCs = {},
			mapNPCs = {},
			npcIDs = {},
		},
	},
}

private.DefaultPreferences = DefaultPreferences
