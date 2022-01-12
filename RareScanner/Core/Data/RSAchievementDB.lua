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

local cachedAchievementLinks = {}

local function IsAchievementCompleted(achievementID)
	if (cachedAchievementLinks[achievementID]) then
		if (cachedAchievementLinks[achievementID] == 0) then
			return nil
		else
			return cachedAchievementLinks[achievementID]
		end
	end

	local _, _, _, completed, _, _, _, _, _, _, _, _, _, _ = GetAchievementInfo(achievementID)
	if (not completed) then
		local achievementLink = GetAchievementLink(achievementID)
		cachedAchievementLinks[achievementID] = achievementLink
		return achievementLink
	else
		cachedAchievementLinks[achievementID] = 0
	end
	
	return nil
end

function RSAchievementDB.GetNotCompletedAchievementLinkByMap(entityID, mapID)
	if (mapID and entityID and private.ACHIEVEMENT_ZONE_IDS[mapID]) then
		for _, achievementID in ipairs(private.ACHIEVEMENT_ZONE_IDS[mapID]) do
			if (RSUtils.Contains(private.ACHIEVEMENT_TARGET_IDS[achievementID], entityID)) then
				return IsAchievementCompleted(achievementID)
			end
		end
	end

	return nil
end

function RSAchievementDB.GetNotCompletedAchievementLink(entityID)
	if (entityID) then
		for achievementID, entitiesIDs in pairs(private.ACHIEVEMENT_TARGET_IDS) do
			if (RSUtils.Contains(entitiesIDs, entityID)) then
				return IsAchievementCompleted(achievementID)
			end
		end
	end

	return nil
end
