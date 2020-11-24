
local Details = _G.Details

--stop yellow warning on my editor
local IsInRaid = _G.IsInRaid
local UnitIsGroupLeader = _G.UnitIsGroupLeader
local UnitIsGroupAssistant = _G.UnitIsGroupAssistant
local UnitName = _G.UnitName
local GetRealmName = _G.GetRealmName
local GetTime = _G.GetTime
local GetNumGroupMembers = _G.GetNumGroupMembers

--return if the player is inside a raid zone
local isInRaidZone = function()
    return Details.zone_type == "raid"
end

--create a namespace using capital letter 'C' for coach feature, the profile entry is lower character .coach
Details.Coach = {
    Client = { --regular player
        enabled = false,
        coachName = "",
    },

    Server = { --the raid leader
        enabled = false,
        lastCombatStartTime = 0,
        lastCombatEndTime = 0,
    },

    isInRaidGroup = false,
    isInRaidZone = false,
}

function Details.Coach.AskRLForCoachStatus(raidLeaderName)
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CIEA"), "WHISPER", raidLeaderName)
    if (_detalhes.debug) then
        Details:Msg("asked the raid leader the coach status.")
    end
end

function Details.Coach.SendRLCombatStartNotify(raidLeaderName)
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CCS"), "WHISPER", raidLeaderName)
    if (_detalhes.debug) then
        Details:Msg("sent to raid leader a combat start notification.")
    end
end

function Details.Coach.SendRLCombatEndNotify(raidLeaderName)
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CCE"), "WHISPER", raidLeaderName)
    if (_detalhes.debug) then
        Details:Msg("sent to raid leader a combat end notification.")
    end
end

--the coach is no more a coach
function Details.Coach.SendRaidCoachEndNotify()
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CE"), "RAID")
    if (_detalhes.debug) then
        Details:Msg("sent to raid a coach end notification.")
    end
end

--there's a new coach, notify players
function Details.Coach.SendRaidCoachStartNotify()
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CS"), "RAID")
    if (_detalhes.debug) then
        Details:Msg("sent to raid a coach start notification.")
    end
end

--send data to raid leader
function Details.Coach.Client.SendDataToRL()
    if (_detalhes.debug) then
        print("Details Coach sending data to RL.")
    end
    
    local data = Details.packFunctions.GetAllData()
    if (data and Details.Coach.Client.coachName) then
        Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CDT", data), "WHISPER", Details.Coach.Client.coachName)
    end
end

--on details startup
function Details.Coach.StartUp()

    Details.Coach.isInRaidGroup = IsInRaid()
    Details.Coach.isInRaidZone = select(2, _G.GetInstanceInfo())

    --server
    if (Details.coach.enabled) then --profile
        Details.Coach.Server.EnableCoach(true)

    elseif (not Details.coach.enabled) then --profile
        if (IsInRaid()) then
            if (isInRaidZone()) then
                local raidLeaderName = Details:GetRaidLeader()
                if (raidLeaderName) then
                    --client ask for the raid leader if the Coach is enabled, GetRaidLeader returns nil is the user isn't in raid
                    if (_detalhes.debug) then
                        Details:Msg("sent ask to raid leader, is coach?")
                    end
                    Details.Coach.AskRLForCoachStatus(raidLeaderName)
                end
            end
        end
    end

    local eventListener = Details:CreateEventListener()
    Details.Coach.Listener = eventListener

    function eventListener.OnEnterGroup() --client
        --when entering a group, check if the player isn't the raid leader
        if (not UnitIsGroupLeader("player")) then
            if (IsInRaid()) then
                if (isInRaidZone()) then
                    local raidLeaderName = Details:GetRaidLeader()
                    if (raidLeaderName) then
                        if (_detalhes.debug) then
                            Details:Msg("sent ask to raid leader, is coach?")
                        end
                        Details.Coach.AskRLForCoachStatus(raidLeaderName)
                    end
                end
            end
        end

        Details.Coach.isInRaidGroup = true
    end

    function eventListener.OnLeaveGroup()
        --disable coach feature on server and client if the player leaves the group
        Details.Coach.Disable()
        Details.Coach.isInRaidGroup = false
    end

    function eventListener.OnEnterCombat()
        --send a notify to raid leader telling a new combat has started
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid() and isInRaidZone()) then
                if (UnitIsGroupAssistant("player")) then
                    local raidLeaderName = Details.Coach.Client.GetLeaderName()
                    if (raidLeaderName) then
                        if (_detalhes.debug) then
                            Details:Msg("i'm a raid assistant, sent combat start notification to raid leader.")
                        end
                        Details.Coach.SendRLCombatStartNotify(raidLeaderName)
                    end
                end

                --start a timer to send data to the raid leader
                if (Details.Coach.Client.UpdateTicker) then
                    Details.Coach.Client.UpdateTicker:Cancel()
                end
                Details.Coach.Client.UpdateTicker = Details.Schedules.NewTicker(1.5, Details.Coach.Client.SendDataToRL)
            end
        end
    end

    function eventListener.OnLeaveCombat()
        --send a notify to raid leader telling the combat has finished
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid() and isInRaidZone()) then
                if (UnitIsGroupAssistant("player")) then
                    local raidLeaderName = Details.Coach.Client.GetLeaderName()
                    if (raidLeaderName) then
                        if (_detalhes.debug) then
                            Details:Msg("i'm a raid assistant, sent combat end notification to raid leader.")
                        end
                        Details.Coach.SendRLCombatEndNotify(raidLeaderName)
                    end
                end
            end

            Details.Schedules.Cancel(Details.Coach.Client.UpdateTicker)
        end
    end

    function eventListener.OnZoneChanged()
        --if the raid leader entered in a raid, disable the coach
        if (Details.Coach.Server.IsEnabled()) then
            if (isInRaidZone()) then
                --the raid leader entered a raid instance
                Details.Coach.Disable()
                if (_detalhes.debug) then
                    Details:Msg("Coach feature stopped: you entered in a raid instance.")
                end
            end
            return
        else
            --check if the raid leader just left the raid to be a coach
            if (Details.Coach.IsEnabled()) then --profile coach feature is enabled
                if (UnitIsGroupLeader("player")) then --player is the raid leader
                    if (not Details.Coach.Server.IsEnabled()) then --the coach feature isn't running
                        Details.Coach.Server.EnableCoach()
                        if (_detalhes.debug) then
                            Details:Msg("Coach feature is now running, if this come as surprise, use '/details coach' to disable.")
                        end
                    end
                end
                return
            end
        end

        --when entering a new zone, check if there's a coach
        if (not Details.Coach.isInRaidZone and isInRaidZone()) then
            if (not UnitIsGroupLeader("player")) then
                if (IsInRaid()) then
                    if (not Details.Coach.Client.IsEnabled()) then
                        local raidLeaderName = Details:GetRaidLeader()
                        if (raidLeaderName) then
                            if (_detalhes.debug) then
                                Details:Msg("sent ask to raid leader, is coach?")
                            end
                            Details.Coach.AskRLForCoachStatus(raidLeaderName)
                            return
                        end
                    end
                end
            end
        end

        --check if the player has left the raid zone
        if (Details.Coach.isInRaidZone and Details.Coach.Client.IsEnabled()) then
            if (not isInRaidZone()) then
                --player left the raid zone
                Details.Schedules.Cancel(Details.Coach.Client.UpdateTicker)
                Details.Coach.Disable()
            end
        end

        Details.Coach.isInRaidZone = isInRaidZone()
    end

    eventListener:RegisterEvent("GROUP_ONENTER", "OnEnterGroup")
    eventListener:RegisterEvent("GROUP_ONLEAVE", "OnLeaveGroup")
    eventListener:RegisterEvent("COMBAT_PLAYER_ENTER", "OnEnterCombat")
    eventListener:RegisterEvent("COMBAT_PLAYER_LEAVE", "OnLeaveCombat")
    eventListener:RegisterEvent("ZONE_TYPE_CHANGED", "OnZoneChanged")
end

--received an answer from server telling if the raidleader has the coach feature enabled
--the request is made when the player enters a new group or reconnects
function Details.Coach.Client.CoachIsEnabled_Response(isCoachEnabled, raidLeaderName)
    if (isCoachEnabled) then
        --raid leader confirmed the coach feature is enabled and running
        Details.Coach.Client.EnableCoach(raidLeaderName)
    end
end

function Details.Coach.Disable()
    Details.coach.enabled = false --profile

    --if the player is the raid leader and the coach feature is enabled
    if (Details.Coach.Server.IsEnabled()) then
        Details.Coach.SendRaidCoachEndNotify()
    end

    Details.Coach.Server.enabled = false
    Details.Coach.Client.enabled = false
    Details.Coach.Client.coachName = nil

    Details.Coach.EventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
end

--the player used '/details coach' or it's Details! initialization
function Details.Coach.Server.EnableCoach(fromStartup)
    if (not IsInRaid()) then
        if (_detalhes.debug) then
            Details:Msg("cannot enabled coach: not in raid.")
        end
        Details.coach.enabled = false
        Details.Coach.Server.enabled = false
        return

    elseif (not UnitIsGroupLeader("player")) then
        if (_detalhes.debug) then
            Details:Msg("cannot enabled coach: you aren't the raid leader.")
        end
        Details.coach.enabled = false
        Details.Coach.Server.enabled = false
        return

    elseif (isInRaidZone()) then
        if (_detalhes.debug) then
            Details:Msg("cannot enabled coach: you are inside a raid zone.")
        end
        Details.coach.enabled = false
        Details.Coach.Server.enabled = false
        return
    end

    Details.coach.enabled = true
    Details.Coach.Server.enabled = true

    --notify players about the new coach
    Details.Coach.SendRaidCoachStartNotify()

    --enable group roster to know if the server isn't raid leader any more
    Details.Coach.EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    if (fromStartup) then
        if (_detalhes.debug) then
            Details:Msg("coach feature enabled, welcome back captain!")
        end
    end
end

--the raid leader sent a coach end notify
function Details.Coach.Client.CoachEnd()
    Details.Coach.Client.enabled = false
    Details.Coach.Client.coachName = nil
    Details.Coach.EventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
end

--a player in the raid asked to be the coach of the group
function Details.Coach.Client.EnableCoach(raidLeaderName)
    if (not IsInRaid()) then
        if (_detalhes.debug) then
            print("Details Coach can't enable coach on client: isn't in raid")
        end
        return

    elseif (not UnitIsGroupLeader(raidLeaderName)) then
        if (_detalhes.debug) then
            print("Details Coach can't enable coach on client: the unit passed isn't the raid leader")
        end
        return
    end

    Details.Coach.Client.enabled = true
    Details.Coach.Client.coachName = raidLeaderName

    --enable group roster to know if the raid leader has changed
    Details.Coach.EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    if (_detalhes.debug) then
        Details:Msg("there's a new coach: ", raidLeaderName)
    end
end

--raid leader received a notification that a new combat has started
function Details.Coach.Server.CombatStarted()
    if (Details.Coach.Server.lastCombatStartTime > GetTime()) then
        return
    else
        Details.Coach.Server.lastCombatStartTime = GetTime() + 10
    end

    --stop the combat if already in one
    if (Details.in_combat) then
        Details:EndCombat()
    end

    --start a new combat
    Details:StartCombat()
end

--raid leader received a notification that the current combat ended
function Details.Coach.Server.CombatEnded()
    if (Details.Coach.Server.lastCombatEndTime > GetTime()) then
        return
    else
        Details.Coach.Server.lastCombatEndTime = GetTime() + 10
    end

    Details:EndCombat()
end

--profile
function Details.Coach.IsEnabled()
    return Details.coach.enabled
end
--server
function Details.Coach.Server.IsEnabled()
    return Details.Coach.Server.enabled
end
--client
function Details.Coach.Client.IsEnabled()
    return Details.Coach.Client.enabled
end
function Details.Coach.Client.GetLeaderName()
    return Details.Coach.Client.coachName
end

Details.Coach.EventFrame = _G.CreateFrame("frame")
Details.Coach.EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
Details.Coach.EventFrame:SetScript("OnEvent", function(event, ...)
    if (event == "GROUP_ROSTER_UPDATE") then
        --check who is raid leader to know if the leader is still the same
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid()) then
                for i = 1, GetNumGroupMembers() do
                    if (UnitIsGroupLeader("raid" .. i)) then
                        local unitName = UnitName("raid" .. i)
                        if (_G.Ambiguate(unitName .. "-" .. GetRealmName(), "none") ~= Details.Coach.Client.coachName) then
                            --the raid leader has changed, finish the coach feature on the client
                            if (_detalhes.debug) then
                                Details:Msg("raid leader has changed, coach feature has been disabled.")
                            end
                            Details.Coach.Client.CoachEnd()
                        end
                        break
                    end
                end
            end
        end

        --check if the player is the new raid leader
        if (UnitIsGroupLeader("player")) then
            if (Details.Coach.IsEnabled()) then
                if (not Details.Coach.Server.IsEnabled()) then
                    if (IsInRaid()) then
                        if (not isInRaidZone()) then
                            if (_detalhes.debug) then
                                Details:Msg("you're now the coach of the group.")
                            end
                            --delay to set the new leader to give time for SendRaidCoachEndNotify()
                            _G.C_Timer.After(3, Details.Coach.Server.EnableCoach)
                        end
                    end
                end
            end
        else
            --player isn't the raid leader, check if the player is the coach and disable the feature
            if (Details.Coach.IsEnabled()) then
                if (Details.Coach.Server.IsEnabled()) then
                    if (_detalhes.debug) then
                        Details:Msg("you're not the raid leader, disabling the coach feature.")
                    end
                    Details.Coach.Disable()
                end
            end
        end
    end
end)
