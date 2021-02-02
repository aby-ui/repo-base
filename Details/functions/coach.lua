
local Details = _G.Details

--stop yellow warning on my editor
local IsInRaid = _G.IsInRaid
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

    Server = { --the coach
        enabled = false,
        lastCombatStartTime = 0,
        lastCombatEndTime = 0,
    },

    isInRaidGroup = false,
    isInRaidZone = false,
}

function Details.Coach.AskRLForCoachStatus()
    Details:SendRaidData(DETAILS_PREFIX_COACH, "CIEA")
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] asked the coach the coach status.")
    end
end

function Details.Coach.SendRLCombatStartNotify(coachName)
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CCS"), "WHISPER", coachName)
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] sent to coach a combat start notification.")
    end
end

function Details.Coach.SendRLCombatEndNotify(coachName)
    Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, UnitName("player"), GetRealmName(), Details.realversion, "CCE"), "WHISPER", coachName)
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] sent to coach a combat end notification.")
    end
end

--the coach is no more a coach
function Details.Coach.SendRaidCoachEndNotify()
    Details:SendRaidData(DETAILS_PREFIX_COACH, "CE")
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] sent to raid a coach end notification.")
    end
end

--there's a new coach, notify players
function Details.Coach.SendRaidCoachStartNotify()
    Details:SendRaidData(DETAILS_PREFIX_COACH, "CS")
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] sent to raid a coach start notification.")
    end
end

--player send his death to the coach
function Details.Coach.SendDeathToRL(deathTable)
    Details:SendRaidData(DETAILS_PREFIX_COACH, "CDD", deathTable)
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] your death has been sent to coach.")
    end
end

--send data to coach
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
                --client ask in the raid if Coach is enabled
                if (_detalhes.debug) then
                    Details:Msg("[|cFFAAFFAADetails! Coach|r] sent ask to coach, is coach?")
                end
                Details.Coach.AskRLForCoachStatus()
            end
        end
    end

    local eventListener = Details:CreateEventListener()
    Details.Coach.Listener = eventListener

    function eventListener.OnEnterGroup() --client
        --when entering a group, check is there's a coach
        if (IsInRaid()) then
            if (isInRaidZone()) then
                Details.Coach.AskRLForCoachStatus()
                if (_detalhes.debug) then
                    Details:Msg("[|cFFAAFFAADetails! Coach|r] sent to raid, is there a coach?")
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
        --send a notify to coach telling a new combat has started
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid() and isInRaidZone()) then
                if (UnitIsGroupAssistant("player")) then
                    local coachName = Details.coach.last_coach_name
                    if (coachName) then
                        if (_detalhes.debug) then
                            Details:Msg("[|cFFAAFFAADetails! Coach|r] i'm a raid assistant, sent combat start notification to coach.")
                        end
                        Details.Coach.SendRLCombatStartNotify(coachName)
                    end
                end

                --start a timer to send data to the coach
                if (Details.Coach.Client.UpdateTicker) then
                    Details.Coach.Client.UpdateTicker:Cancel()
                end
                Details.Coach.Client.UpdateTicker = Details.Schedules.NewTicker(1.5, Details.Coach.Client.SendDataToRL)
            end
        end
    end

    function eventListener.OnLeaveCombat()
        --send a notify to coach telling the combat has finished
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid() and isInRaidZone()) then
                if (UnitIsGroupAssistant("player")) then
                    local raidLeaderName = Details.Coach.Client.GetLeaderName()
                    if (raidLeaderName) then
                        if (_detalhes.debug) then
                            Details:Msg("[|cFFAAFFAADetails! Coach|r] i'm a raid assistant, sent combat end notification to coach.")
                        end
                        Details.Coach.SendRLCombatEndNotify(raidLeaderName)
                    end
                end
            end

            Details.Schedules.Cancel(Details.Coach.Client.UpdateTicker)
        end
    end

    function eventListener.OnZoneChanged()
        --if the coach entered in a raid, disable the coach
        if (Details.Coach.Server.IsEnabled()) then
            if (isInRaidZone()) then
                --the coach entered a raid instance
                Details.Coach.Disable()
                if (_detalhes.debug) then
                    Details:Msg("[|cFFAAFFAADetails! Coach|r] Coach feature stopped: you entered in a raid instance.")
                end
            end
            return
        end

        --when entering a new zone, check if there's a coach
        if (not Details.Coach.isInRaidZone and isInRaidZone()) then
            if (IsInRaid()) then
                if (not Details.Coach.Client.IsEnabled()) then
                    if (_detalhes.debug) then
                        Details:Msg("[|cFFAAFFAADetails! Coach|r] sent in the raid, there's a coach?")
                    end
                    Details.Coach.AskRLForCoachStatus()
                    return
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

C_Timer.After(0.1, function()
    --Details.debug = true
end)

--received an answer from server telling if the raidleader has the coach feature enabled
--the request is made when the player enters a new group or reconnects
function Details.Coach.Client.CoachIsEnabled_Response(isCoachEnabled, coachName)
    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] Coach sent response about the status of Coach Mode:", isCoachEnabled, raidLeaderName)
    end

    if (isCoachEnabled) then
        --coach confirmed the coach feature is enabled and running
        Details.Coach.Client.EnableCoach(coachName)
        Details:Msg("[|cFFAAFFAADetails! Coach|r] current coach:", coachName)
    end
end

function Details.Coach.Server.CoachIsEnabled_Answer(sourcePlayer)
    if (Details.Coach.Server.IsEnabled()) then
        --send the answer
        Details:SendCommMessage(_G.DETAILS_PREFIX_NETWORK, Details:Serialize(_G.DETAILS_PREFIX_COACH, sourcePlayer, GetRealmName(), Details.realversion, "CIER", Details.Coach.Server.IsEnabled()), "WHISPER", sourcePlayer)
    end
end

function Details.Coach.Disable()
    Details.coach.enabled = false --profile

    --if the player is the coach and the coach feature is enabled
    if (Details.Coach.Server.IsEnabled()) then
        Details.Coach.SendRaidCoachEndNotify()
    end

    Details.Coach.Server.enabled = false
    Details.Coach.Client.enabled = false
    Details.Coach.Client.coachName = nil
    Details.coach.last_coach_name = false

    Details.Coach.EventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
end

--the player used '/details coach' or it's Details! initialization
function Details.Coach.Server.EnableCoach(fromStartup)
    if (not IsInRaid()) then
        if (_detalhes.debug) then
            Details:Msg("[|cFFAAFFAADetails! Coach|r] cannot enabled coach: not in raid.")
        end
        Details.coach.enabled = false
        Details.Coach.Server.enabled = false
        Details.coach.last_coach_name = false
        return

    elseif (isInRaidZone()) then
        if (_detalhes.debug) then
            Details:Msg("[|cFFAAFFAADetails! Coach|r] cannot enabled coach: you are inside a raid zone.")
        end
        Details.coach.enabled = false
        Details.Coach.Server.enabled = false
        Details.coach.last_coach_name = false
        return
    end

    Details.coach.enabled = true
    Details.Coach.Server.enabled = true
    Details.coach.last_coach_name = UnitName("player")

    --notify players about the new coach
    Details.Coach.SendRaidCoachStartNotify()

    --enable group roster to know if the server isn't coach any more
    Details.Coach.EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    if (fromStartup) then
        if (_detalhes.debug) then
            Details:Msg("[|cFFAAFFAADetails! Coach|r] coach feature enabled, welcome back captain!")
        end
    end
end

--the coach sent a coach end notify
function Details.Coach.Client.CoachEnd()
    Details.Coach.Client.enabled = false
    Details.Coach.Client.coachName = nil
    Details.coach.last_coach_name = false
    Details.Coach.EventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
end

--a player in the raid asked to be the coach of the group
function Details.Coach.Client.EnableCoach(coachName)
    if (not IsInRaid()) then
        if (_detalhes.debug) then
            print("Details Coach can't enable coach on client: isn't in raid")
        end
        return
    end

    Details.Coach.Client.enabled = true
    Details.Coach.Client.coachName = coachName
    Details.coach.last_coach_name = coachName

    --enable group roster to know if the coach has changed
    Details.Coach.EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    if (_detalhes.debug) then
        Details:Msg("[|cFFAAFFAADetails! Coach|r] there's a new coach: ", coachName)
    end

    Details:Msg("[|cFFAAFFAADetails! Coach|r] current coach:", coachName)
end

--coach received a notification that a new combat has started
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

--coach received a notification that the current combat ended
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
        --check who is coach to know if the leader is still the same
        if (Details.Coach.Client.IsEnabled()) then
            if (IsInRaid()) then
                for i = 1, GetNumGroupMembers() do
                    local inRaid = UnitInRaid(Details.Coach.Client.coachName)
                    if (not inRaid) then
                        if (_detalhes.debug) then
                            Details:Msg("[|cFFAAFFAADetails! Coach|r] coach isn't in the raid, coach feature has been disabled.")
                        end
                        Details.Coach.Client.CoachEnd()
                    end
                end
            end
        end
    end
end)

function Details.Coach.Client.SendMyDeath(_, _, _, _, _, _, playerGUID, _, playerFlag, deathTable)
    if (Details.Coach.Client.enabled) then
        if (Details.Coach.Client.coachName) then
            if (Details.in_combat) then
                if (playerGUID == UnitGUID("player")) then
                    Details.Coach.SendDeathToRL({deathTable, playerGUID, playerFlag})
                end
            end
        end
    end
end

function Details.Coach.Server.AddPlayerDeath(playerName, data)
    local currentCombat = Details:GetCurrentCombat()
    local utilityContainer = currentCombat[4]

    local deathLog = data[1]
    local playerGUID = data[2]
    local playerFlag = data[3]

    local utilityActorObject = utilityContainer:GetOrCreateActor(playerGUID, playerName, playerFlag, true)

    if (utilityActorObject) then
        tinsert(currentCombat.last_events_tables, deathLog)
        --tag the misc container as need refresh
        currentCombat[DETAILS_ATTRIBUTE_MISC].need_refresh = true
    end
end

function Details.Coach.WelcomePanel()
    local welcomePanel = _G.DETAILSCOACHPANEL
    if (not welcomePanel) then
		welcomePanel = DetailsFramework:CreateSimplePanel(UIParent)
		welcomePanel:SetSize (400, 280)
		welcomePanel:SetTitle ("Details! Coach")
		welcomePanel:ClearAllPoints()
		welcomePanel:SetPoint ("left", UIParent, "left", 10, 0)
        welcomePanel:Hide()
        DetailsFramework:ApplyStandardBackdrop(welcomePanel)

		local LibWindow = _G.LibStub("LibWindow-1.1")
		welcomePanel:SetScript("OnMouseDown", nil)
		welcomePanel:SetScript("OnMouseUp", nil)
		LibWindow.RegisterConfig(welcomePanel, Details.coach.welcome_panel_pos)
		LibWindow.MakeDraggable(welcomePanel)
        LibWindow.RestorePosition(welcomePanel)

        local imageSize = 26

        local detailsLogo = DetailsFramework:CreateImage(welcomePanel, [[Interface\AddOns\Details\images\logotipo]])
        detailsLogo:SetPoint("topleft", welcomePanel, "topleft", 5, -30)
        detailsLogo:SetSize(200, 50)
        detailsLogo:SetTexCoord(36/512, 380/512, 128/256, 227/256)

        local isLeaderTexture = DetailsFramework:CreateImage(welcomePanel, [[Interface\GLUES\LOADINGSCREENS\DynamicElements]], imageSize, imageSize)
        isLeaderTexture:SetTexCoord(0, 0.5, 0, 0.5)
        isLeaderTexture:SetPoint("topleft", detailsLogo, "topleft", 0, -60)
        local isLeaderText = DetailsFramework:CreateLabel(welcomePanel, "In raid and all members are in the same guild.")
        isLeaderText:SetPoint("left", isLeaderTexture, "right", 10, 0)

        local isOutsideTexture = DetailsFramework:CreateImage(welcomePanel, [[Interface\GLUES\LOADINGSCREENS\DynamicElements]], imageSize, imageSize)
        isOutsideTexture:SetTexCoord(0, 0.5, 0, 0.5)
        isOutsideTexture:SetPoint("topleft", isLeaderTexture, "bottomleft", 0, -5)
        local isOutsideText = DetailsFramework:CreateLabel(welcomePanel, "You're outside of the instance.")
        isOutsideText:SetPoint("left", isOutsideTexture, "right", 10, 0)

        local hasAssistantsTexture = DetailsFramework:CreateImage(welcomePanel, [[Interface\GLUES\LOADINGSCREENS\DynamicElements]], imageSize, imageSize)
        hasAssistantsTexture:SetTexCoord(0, 0.5, 0, 0.5)
        hasAssistantsTexture:SetPoint("topleft", isOutsideTexture, "bottomleft", 0, -5)
        local hasAssistantsText = DetailsFramework:CreateLabel(welcomePanel, "There's an 'raid assistant' inside the raid.")
        hasAssistantsText:SetPoint("left", hasAssistantsTexture, "right", 10, 0)

        local beInGroupSevenTexture = DetailsFramework:CreateImage(welcomePanel, [[Interface\GLUES\LOADINGSCREENS\DynamicElements]], imageSize, imageSize)
        beInGroupSevenTexture:SetTexCoord(0, 0.5, 0, 0.5)
        beInGroupSevenTexture:SetPoint("topleft", hasAssistantsTexture, "bottomleft", 0, -5)
        local beInGroupSevenText = DetailsFramework:CreateLabel(welcomePanel, "Stay in group 7 or 8.")
        beInGroupSevenText:SetPoint("left", beInGroupSevenTexture, "right", 10, 0)

        local allUpdatedTexture = DetailsFramework:CreateImage(welcomePanel, [[Interface\GLUES\LOADINGSCREENS\DynamicElements]], imageSize, imageSize)
        allUpdatedTexture:SetTexCoord(0, 0.5, 0, 0.5)
        allUpdatedTexture:SetPoint("topleft", beInGroupSevenTexture, "bottomleft", 0, -5)
        local allUpdatedText = DetailsFramework:CreateLabel(welcomePanel, "Users with updated Details!.")
        allUpdatedText:SetPoint("left", allUpdatedTexture, "right", 10, 0)

        local startCoachButton = DetailsFramework:CreateButton(welcomePanel, function()
            Details.coach.enabled = true
            Details.Coach.Server.EnableCoach()
            welcomePanel:Hide()
            Details:Msg("welcome aboard commander!")

        end, 80, 20, "Start Coaching!")
        startCoachButton:SetPoint("bottomright", welcomePanel, "bottomright", -10, 10)
        startCoachButton:SetTemplate(DetailsFramework:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))

        function welcomePanel.Update()
            local good = 0
            local numRaidMembers = GetNumGroupMembers()
            local playerName = UnitName("player")
            local sameGuildAmount = 0
            local guildName = GetGuildInfo("player")

            for i = 1, numRaidMembers do
                local unitId = "raid" .. i
                if (guildName == GetGuildInfo(unitId)) then
                    sameGuildAmount = sameGuildAmount +  1
                end
            end

            if (IsInRaid()) then -- and numRaidMembers == sameGuildAmount
                isLeaderTexture:SetTexture([[Interface\COMMON\Indicator-Green]])
                isLeaderTexture:SetTexCoord(0, 1, 0, 1)
                good = good + 1
            else
                isLeaderTexture:SetTexture([[Interface\GLUES\LOADINGSCREENS\DynamicElements]])
                isLeaderTexture:SetTexCoord(0, 0.5, 0, 0.5)
            end

            if (not IsInInstance()) then
                isOutsideTexture:SetTexture([[Interface\COMMON\Indicator-Green]])
                isOutsideTexture:SetTexCoord(0, 1, 0, 1)
                good = good + 1
            else
                isOutsideTexture:SetTexture([[Interface\GLUES\LOADINGSCREENS\DynamicElements]])
                isOutsideTexture:SetTexCoord(0, 0.5, 0, 0.5)
            end

            local hasAssistant = false
            for i = 1, numRaidMembers do
                local name, rank = GetRaidRosterInfo(i)
                if (rank > 0 and name ~= UnitName("player")) then
                    hasAssistant = true
                    break
                end
            end

            if (hasAssistant) then
                hasAssistantsTexture:SetTexture([[Interface\COMMON\Indicator-Green]])
                hasAssistantsTexture:SetTexCoord(0, 1, 0, 1)
                good = good + 1
            else
                hasAssistantsTexture:SetTexture([[Interface\GLUES\LOADINGSCREENS\DynamicElements]])
                hasAssistantsTexture:SetTexCoord(0, 0.5, 0, 0.5)
            end

            local isInCorrectGroup = true --debug
            for i = 1, numRaidMembers do
                local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
                if (name == playerName) then
                    if (subgroup == 7 or subgroup == 8) then
                        isInCorrectGroup = true
                        break
                    end
                end
            end

            if (isInCorrectGroup) then
                beInGroupSevenTexture:SetTexture([[Interface\COMMON\Indicator-Green]])
                beInGroupSevenTexture:SetTexCoord(0, 1, 0, 1)
                good = good + 1
            else
                beInGroupSevenTexture:SetTexture([[Interface\GLUES\LOADINGSCREENS\DynamicElements]])
                beInGroupSevenTexture:SetTexCoord(0, 0.5, 0, 0.5)
            end

            local allUsersUpdated = false

            local numRaidMembers = numRaidMembers
            local updatedUsers = 0
            local usersChecked = {}

            for i = 1, #Details.users do
                local thisUser = Details.users[i]
                local userName = thisUser[1]

                if (not usersChecked[userName]) then
                    local version = thisUser[3]
                    local buildCounter = version:match("%w%d%.%d%.%d%.(%d+)")
                    buildCounter = tonumber(buildCounter)

                    if (buildCounter and buildCounter >= Details.build_counter) then
                        updatedUsers = updatedUsers + 1
                    end

                    usersChecked[userName] = true
                end
            end

            if (updatedUsers >= numRaidMembers) then
                allUsersUpdated = true
            end
            allUsersUpdated = true

            if (allUsersUpdated) then
                allUpdatedTexture:SetTexture([[Interface\COMMON\Indicator-Green]])
                allUpdatedTexture:SetTexCoord(0, 1, 0, 1)
                good = good + 1
            else
                allUpdatedTexture:SetTexture([[Interface\GLUES\LOADINGSCREENS\DynamicElements]])
                allUpdatedTexture:SetTexCoord(0, 0.5, 0, 0.5)
            end

            if (good == 5) then
                startCoachButton:Enable()
            else
                startCoachButton:Disable()
            end
        end
    end

    Details.SendHighFive()

    local nextHighFive = 10
    local nextUpdate = 1

    welcomePanel:SetScript("OnUpdate", function(self, deltaTime)
        nextHighFive = nextHighFive - deltaTime
        nextUpdate = nextUpdate - deltaTime

        if (nextHighFive < 0) then
            Details.SendHighFive()
            nextHighFive = 10
        end

        if (nextUpdate < 0) then
            welcomePanel:Update()
            nextUpdate = 1
        end
    end)

    welcomePanel:Show()
end
