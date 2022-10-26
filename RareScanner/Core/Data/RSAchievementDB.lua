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

local cachedAchievements = {}

local function IsAchievementCompleted(achievementID)
	if (cachedAchievements[achievementID]) then
		return false
	end

	local _, _, _, completed, _, _, _, _, _, icon, _, _, _, _, _ = GetAchievementInfo(achievementID)
	if (not completed) then
		cachedAchievements[achievementID] = {}
		cachedAchievements[achievementID].icon = icon
		cachedAchievements[achievementID].link = GetAchievementLink(achievementID)
		return false
	end
	
	return true
end

function RSAchievementDB.GetCachedAchievementInfo(achievementID)
	if (achievementID and cachedAchievements[achievementID]) then
		return cachedAchievements[achievementID]
	end
	
	return nil
end

function RSAchievementDB.GetNotCompletedAchievementIDsByMap(entityID, mapID)
	if (mapID and entityID and private.ACHIEVEMENT_ZONE_IDS[mapID]) then
		local achievementIDs = { }
		for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
			if (RSUtils.Contains(private.ACHIEVEMENT_TARGET_IDS[achievementID], entityID)) then
				if (not IsAchievementCompleted(achievementID)) then
					tinsert(achievementIDs, achievementID);
				end
			end
		end
		
		return achievementIDs
	end

	return nil
end

function RSAchievementDB.GetNotCompletedAchievementLink(entityID)
	if (entityID) then
		for achievementID, entitiesIDs in pairs(private.ACHIEVEMENT_TARGET_IDS) do
			if (RSUtils.Contains(entitiesIDs, entityID)) then
				if (IsAchievementCompleted(achievementID)) then
					return RSAchievementDB.GetCachedAchievementInfo(achievementID).link
				end
			end
		end
	end

	return nil
end
