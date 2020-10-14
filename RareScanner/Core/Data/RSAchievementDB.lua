-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local RSAchievementDB = private.NewLib("RareScannerAchievementDB")

-- RareScanner internal libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")


---============================================================================
-- Achievements database
---============================================================================

function RSAchievementDB.HasAchievement(entityID, mapID)
	if (mapID and private.ACHIEVEMENT_ZONE_IDS[mapID]) then
		local hasAchievement = false
		for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
			if (RSUtils.Contains(private.ACHIEVEMENT_TARGET_IDS[achievementID], entityID)) then
				return true
			end
		end
	end
	
	return false
end

function RSAchievementDB.GetNotCompletedAchievementLink(entityID, mapID)
	if (mapID and private.ACHIEVEMENT_ZONE_IDS[mapID]) then
		for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
			local _, _, _, completed, _, _, _, _, _, _, _, _, wasEarnedByMe, _ = GetAchievementInfo(achievementID)
			if (not completed or not wasEarnedByMe) then
				for _, achievementEntityID in ipairs(private.ACHIEVEMENT_TARGET_IDS[achievementID]) do
					if (achievementEntityID == entityID) then
						return GetAchievementLink(achievementID)
					end
				end
			end
		end
	end
	
	return nil
end