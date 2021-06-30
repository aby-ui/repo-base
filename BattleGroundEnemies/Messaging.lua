local addonName, Data = ...
local BattleGroundEnemies = BattleGroundEnemies
local L = Data.L


local CTimerNewTicker = C_Timer.NewTicker
local SendAddonMessage = C_ChatInfo.SendAddonMessage

local BGE_VERSION = "9.0.5.6"
local AddonPrefix = "BGE"
local versionQueryString, versionResponseString = "Q^%s", "V^%s"
local targetCallVolunteerQueryString = "TVQ^%s" -- wil be send to all the viewers to show if you are volunteering vor target calling
local targetCallVolunteerResponseString = "TVR^%s"
local targetCallCallerQueryString = "TCQ" -- wil be send to all the viewers to show if you are volunteering vor target calling
local targetCallCallerResponseString = "TCV^%s" -- wil be send to all the viewers to show if you are volunteering vor target calling

local highestVersion = BGE_VERSION
local versions = {}

versionQueryString = versionQueryString:format(BGE_VERSION)
versionResponseString = versionResponseString:format(BGE_VERSION)

BattleGroundEnemies:RegisterEvent("CHAT_MSG_ADDON")

C_ChatInfo.RegisterAddonMessagePrefix(AddonPrefix)



--[[
    targetcallilng, thoughts:
    The group leader can decice who the target caller will be
    the addon then automatically marks the target of the target caller with a raid icon (can be choosen from the menu) via SetRaidTarget()
    RAID_TARGET_UPDATE fires when a raid target changes. 
    
    
    the addon then reacts to that and shows the icon on the playerbutton as well and notifies the player when the target changed. 
]]

--[[ 
LE_PARTY_CATEGORY_HOME will query information about your "real" group -- the group you were in on your Home realm, before entering any instance/battleground.
LE_PARTY_CATEGORY_INSTANCE will query information about your "fake" group -- the group created by the instance/battleground matching mechanism.
 ]]

SLASH_BattleGroundEnemiesVersion1 = "/bgev"
SLASH_BattleGroundEnemiesVersion2 = "/BGEV"
SlashCmdList.BattleGroundEnemiesVersion = function()
	if not IsInGroup() then
        BattleGroundEnemies:Information(L.MyVersion, BGE_VERSION)
		return
	end

	local function coloredNameVersion(playerDetails, version)
        local coloredName = BattleGroundEnemies:GetColoredName(playerDetails)
		if version ~= "" then
			version = ("|cFFCCCCCC(%s%s)|r"):format(version, "") 
		end
		return (coloredName..version)
	end


    local results = {
        current = {},  --users of the current version
        old = {},-- users of an old version
        none = {} -- no BGE detected
    }
    local texts = {
        current = L.CurrentVersion,
        old = L.OldVersion,
        none = L.NoVersion
    }


    --loop through all of the BattleGroundEnemies.Allies.groupMembers to find out which one of them send us their addon version
    for name, details in pairs(BattleGroundEnemies.Allies.groupMembers) do
  
        if versions[name] then
            if versions[name] < highestVersion then
                results.old[#results.old+1] = coloredNameVersion(details, versions[name])
            else
                results.current[#results.current+1] = coloredNameVersion(details, versions[name])  
            end
        else
            results.none[#results.none+1] = coloredNameVersion(details, "")        
        end
    end

    for k,v in pairs(results) do
        if #v> 0 then
            BattleGroundEnemies:Information(texts[k]..":", unpack(v))
        end
    end
end

local timers = {}
--[[ 
  we use timers to broadcast information, we do this because it may happen that 
many players request the same information in a shortm time due to
 ingame events like GROUP_ROSTER_UPDATE, this way we only send out the information 
once when requested in a 3 second time frame, every new request resets the timer
 ]]


function BattleGroundEnemies:QueryVersions(channel)
    SendAddonMessage(AddonPrefix, versionQueryString, channel)
end

-- function BattleGroundEnemies:QueryTargetCallVolunteers(channel)
--     SendAddonMessage(AddonPrefix, targetCallVolunteerQueryString:format(iWantToDoTargetcalling and "y" or "n"), channel)
-- end

-- function BattleGroundEnemies:QueryTargetCallCaller(channel)
--     SendAddonMessage(AddonPrefix, targetCallCallerQueryString, channel)
-- end


-- --broadcast teh target caller to everyone
-- function BattleGroundEnemies:BroadcastTargetCaller()
--     if self.Allies.TargetCaller then
--         if timers.BroadcastTargetCaller then timers.BroadcastTargetCaller:Cancel() end
--         timers.BroadcastTargetCaller = CTimerNewTicker(3, function() 
--             if IsInGroup() then
--                 SendAddonMessage(AddonPrefix, targetCallVolunteerResponseString:format(self.Allies.TargetCaller.GUID), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
--             end
--             timers.BroadcastTargetCaller = nil
--         end, 1)
--     end
-- end




local wasInGroup = nil
function BattleGroundEnemies:RequestEverythingFromGroupmembers()
    
    local groupType = (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and 3) or (IsInRaid() and 2) or (IsInGroup() and 1)
    if (not wasInGroup and groupType) or (wasInGroup and groupType and wasInGroup ~= groupType) then
        wasInGroup = groupType
       -- local iWantToDoTargetcalling = self.db.profile.targetCallingVolunteer
        local channel = groupType == 3 and "INSTANCE_CHAT" or "RAID"
        --self:QueryTargetCallCaller(channel)
        --self:QueryTargetCallVolunteers(channel)
        self:QueryVersions(channel)

    elseif wasInGroup and not groupType then
        wasInGroup = nil
        versions = {}
    end
end

function BattleGroundEnemies:UpdateVersions(sender, prefix, version)
    if prefix == "Q" then
        if timers.VersionCheck then timers.VersionCheck:Cancel() end
        timers.VersionCheck = CTimerNewTicker(3, function() 
            if IsInGroup() then
                SendAddonMessage(AddonPrefix, versionResponseString, IsInGroup(2) and "INSTANCE_CHAT" or "RAID") -- LE_PARTY_CATEGORY_INSTANCE = 2
            end
            timers.VersionCheck = nil
        end, 1)
    end
    if prefix == "V" or prefix == "Q" then -- V = version response, Q = version query
        if version then
            versions[sender] = version
            if version > highestVersion then highestVersion = version end

            if version > BGE_VERSION then
                if timers.outdatedTimer then timers.outdatedTimer:Cancel() end
                timers.outdatedTimer = CTimerNewTicker(3, function() 
                    BattleGroundEnemies:Information(L.NewVersionAvailable)
                    timers.outdatedTimer = nil
                end, 1)
            end
        end
    end
end


-- function BattleGroundEnemies:UpdateTargetCallingVolunteers(sender, prefix, message)
--     if prefix == "TVQ" then
--         if timers.targetCallingVolunteering then timers.targetCallingVolunteering:Cancel() end
--         timers.targetCallingVolunteering = CTimerNewTicker(3, function() 
--             SendAddonMessage(AddonPrefix, targetCallVolunteerResponseString:format(self.db.profile.targetCallingVolunteer and "y" or "n"), IsInGroup(2) and "INSTANCE_CHAT" or "RAID")
--             timers.targetCallingVolunteering = nil
--         end, 1)
--     end
--     BattleGroundEnemies.TargetCalllingVolunteers[sender] = message == "y" and true or false
-- end

-- function BattleGroundEnemies:UpdateTargetCallingCallers(prefix, sender, message)
--     if prefix == "TCQ" then
--         -- when we query the taret caller we only save the Targetcaller when its send by the group leader

--         if self.PlayerDetails.isGroupLeader then -- i am the groupleader
--             self:BroadcastTargetCaller()
--         end
--     end
--     if sender == self.Allies.groupLeader then
--         self:Information(message == UnitGUID("player") and YOU or message, L.TargetCallerUpdated)
--         BattleGroundEnemies.Allies.TargetCaller = self.Allies.GuidToGroupMember[message]
--     end
-- end

function BattleGroundEnemies:CHAT_MSG_ADDON(addonPrefix, message, channel, sender)  --the sender always contains the realm of the player, even when from same realm
	if channel ~= "RAID" and channel ~= "PARTY" and channel ~= "INSTANCE_CHAT" or addonPrefix ~= AddonPrefix then return end
	
    local msgPrefix, msg = strsplit("^", message)
    sender = Ambiguate(sender, "none")
    if msgPrefix == "V" or msgPrefix == "Q" then
        self:UpdateVersions(sender, msgPrefix, msg)
    end
end




--/run test = {"9.0.7.5", "9.2.7.5", "9.2.7.4"}; table.sort(test); for i =1, #test do print(test[i])end
-- sortiert aufsteigent 