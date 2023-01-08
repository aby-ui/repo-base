
--todo: need to fix this file after pre-patch

local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

--prefix used on sync statistics
local CONST_GUILD_SYNC = "GS"

function Details:InitializeRaidHistoryWindow()
    local DetailsRaidHistoryWindow = CreateFrame("frame", "DetailsRaidHistoryWindow", UIParent,"BackdropTemplate")
    DetailsRaidHistoryWindow.Frame = DetailsRaidHistoryWindow
    DetailsRaidHistoryWindow.__name = Loc ["STRING_STATISTICS"]
    DetailsRaidHistoryWindow.real_name = "DETAILS_STATISTICS"
    DetailsRaidHistoryWindow.__icon = [[Interface\AddOns\Details\images\icons]]
    DetailsRaidHistoryWindow.__iconcoords = {278/512, 314/512, 43/512, 76/512}
    DetailsRaidHistoryWindow.__iconcolor = "DETAILS_STATISTICS_ICON"
    DetailsPluginContainerWindow.EmbedPlugin (DetailsRaidHistoryWindow, DetailsRaidHistoryWindow, true)

    function DetailsRaidHistoryWindow.RefreshWindow()
        Details:OpenRaidHistoryWindow()
        C_Timer.After(1, function()
            Details:OpenRaidHistoryWindow()
        end)
    end
end

function Details:OpenRaidHistoryWindow(raidName, bossEncounterId, difficultyId, playerRole, guildName, playerBase, playerName, historyType)
    if (not DetailsRaidHistoryWindow or not DetailsRaidHistoryWindow.Initialized) then

        DetailsRaidHistoryWindow.Initialized = true

        local statisticsFrame = DetailsRaidHistoryWindow or CreateFrame("frame", "DetailsRaidHistoryWindow", UIParent, "BackdropTemplate")
        statisticsFrame:SetPoint("center", UIParent, "center")
        statisticsFrame:SetFrameStrata("HIGH")
        statisticsFrame:SetToplevel(true)

        statisticsFrame:SetMovable(true)
        statisticsFrame:SetWidth(850)
        statisticsFrame:SetHeight(500)
        tinsert(UISpecialFrames, "DetailsRaidHistoryWindow")

        function statisticsFrame.OpenDB()
            local db = Details.storage:OpenRaidStorage()
            if (not db) then
                Details:Msg(Loc ["STRING_GUILDDAMAGERANK_DATABASEERROR"])
                return
            end
            return db
        end

        local db = statisticsFrame.OpenDB()
        if (not db) then
            return
        end

        statisticsFrame.Mode = 2

        DF:ApplyStandardBackdrop(statisticsFrame)

        --create title bar
        local titlebar = DF:CreateTitleBar(statisticsFrame, "Details! " .. Loc ["STRING_STATISTICS"])
--STRING_GUILDDAMAGERANK_TUTORIAL_DESC
--STRING_OPTIONS_CHART_CLOSE

        --background
        local background = statisticsFrame:CreateTexture("$parentBackgroundImage", "border")
        background:SetAlpha(0.3)
        background:SetPoint("topleft", statisticsFrame, "topleft", 6, -65)
        background:SetPoint("bottomright", statisticsFrame, "bottomright", -10, 28)

        --separate menu and main list
        local div = statisticsFrame:CreateTexture(nil, "artwork")
        div:SetTexture([[Interface\ACHIEVEMENTFRAME\UI-Achievement-MetalBorder-Left]])
        div:SetAlpha(0.1)
        div:SetPoint("topleft", statisticsFrame, "topleft", 180, -64)
        div:SetHeight(574)

        --select history or guild rank
        local options_switch_template = DF:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
        local options_text_template = DF:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
        local options_button_template = DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

        local selectKillTimeline = function()
            statisticsFrame.GuildRankCheckBox:SetValue(false)
            statisticsFrame.HistoryCheckBox:SetValue(true)
            statisticsFrame.Mode = 1
            statisticsFrame:Refresh()
            statisticsFrame.ReportButton:Hide()
        end

        local selectGuildRank = function()
            statisticsFrame.HistoryCheckBox:SetValue(false)
            statisticsFrame.GuildRankCheckBox:SetValue(true)
            statisticsFrame.select_player:Select(1, true)
            statisticsFrame.select_player2:Hide()
            statisticsFrame.select_player2_label:Hide()
            statisticsFrame.Mode = 2
            statisticsFrame:Refresh()
            statisticsFrame.ReportButton:Show()
        end

        --kill timeline
        local HistoryCheckBox, HistoryLabel = DF:CreateSwitch(statisticsFrame, selectKillTimeline, false, 18, 18, "", "", "HistoryCheckBox", nil, nil, nil, nil, Loc ["STRING_GUILDDAMAGERANK_SHOWHISTORY"], options_switch_template) --, options_text_template
        HistoryLabel:ClearAllPoints()
        HistoryCheckBox:ClearAllPoints()
        HistoryCheckBox:SetPoint("topleft", statisticsFrame, "topleft", 100, -34)
        HistoryLabel:SetPoint("left", HistoryCheckBox, "right", 2, 0)
        HistoryCheckBox:SetAsCheckBox()

        --guildrank
        local GuildRankCheckBox, GuildRankLabel = DF:CreateSwitch(statisticsFrame, selectGuildRank, true, 18, 18, "", "", "GuildRankCheckBox", nil, nil, nil, nil, Loc ["STRING_GUILDDAMAGERANK_SHOWRANK"], options_switch_template) --, options_text_template
        GuildRankLabel:ClearAllPoints()
        GuildRankCheckBox:ClearAllPoints()
        GuildRankCheckBox:SetPoint("topleft", statisticsFrame, "topleft", 240, -34)
        GuildRankLabel:SetPoint("left", GuildRankCheckBox, "right", 2, 0)
        GuildRankCheckBox:SetAsCheckBox()

        --guild sync
        local doGuildSync = function()
            statisticsFrame.RequestedAmount = 0
            statisticsFrame.DownloadedAmount = 0
            statisticsFrame.EstimateSize = 0
            statisticsFrame.DownloadedSize = 0
            statisticsFrame.SyncStartTime = time()

            Details.storage:DBGuildSync()
            statisticsFrame.GuildSyncButton:Disable()

            if (not statisticsFrame.SyncTexture) then
                local workingFrame = CreateFrame("frame", nil, statisticsFrame, "BackdropTemplate")
                statisticsFrame.WorkingFrame = workingFrame
                workingFrame:SetSize(1, 1)
                statisticsFrame.SyncTextureBackground = workingFrame:CreateTexture(nil, "border")
                statisticsFrame.SyncTextureBackground:SetPoint("bottomright", statisticsFrame, "bottomright", -5, -1)
                statisticsFrame.SyncTextureBackground:SetTexture([[Interface\COMMON\StreamBackground]])
                statisticsFrame.SyncTextureBackground:SetSize(32, 32)

                statisticsFrame.SyncTextureCircle = workingFrame:CreateTexture(nil, "artwork")
                statisticsFrame.SyncTextureCircle:SetPoint("center", statisticsFrame.SyncTextureBackground, "center", 0, 0)
                statisticsFrame.SyncTextureCircle:SetTexture([[Interface\COMMON\StreamCircle]])
                statisticsFrame.SyncTextureCircle:SetSize(32, 32)

                statisticsFrame.SyncTextureGrade = workingFrame:CreateTexture(nil, "overlay")
                statisticsFrame.SyncTextureGrade:SetPoint("center", statisticsFrame.SyncTextureBackground, "center", 0, 0)
                statisticsFrame.SyncTextureGrade:SetTexture([[Interface\COMMON\StreamFrame]])
                statisticsFrame.SyncTextureGrade:SetSize(32, 32)

                local animationHub = DF:CreateAnimationHub(workingFrame)
                animationHub:SetLooping("Repeat")
                statisticsFrame.WorkingAnimation = animationHub

                local rotation = DF:CreateAnimation(animationHub, "ROTATION", 1, 3, -360)
                rotation:SetTarget(statisticsFrame.SyncTextureCircle)

                statisticsFrame.SyncText = workingFrame:CreateFontString(nil, "border", "GameFontNormal")
                statisticsFrame.SyncText:SetPoint("right", statisticsFrame.SyncTextureBackground, "left", 0, 0)
                statisticsFrame.SyncText:SetText("working")

                local endAnimationHub = DF:CreateAnimationHub(workingFrame, nil, function() workingFrame:Hide() end)
                DF:CreateAnimation(endAnimationHub, "ALPHA", 1, 0.5, 1, 0)
                statisticsFrame.EndAnimationHub = endAnimationHub
            end

            statisticsFrame.WorkingFrame:Show()
            statisticsFrame.WorkingAnimation:Play()

            C_Timer.NewTicker(10, function(self)
                if (not Details.LastGuildSyncReceived) then
                    statisticsFrame.GuildSyncButton:Enable()
                    statisticsFrame.EndAnimationHub:Play()

                elseif (Details.LastGuildSyncReceived+10 < GetTime()) then
                    statisticsFrame.GuildSyncButton:Enable()
                    statisticsFrame.EndAnimationHub:Play()
                    self:Cancel()
                end
            end)
        end

        local guildSyncButton = DF:CreateButton(statisticsFrame, doGuildSync, 130, 20, Loc ["STRING_GUILDDAMAGERANK_SYNCBUTTONTEXT"], nil, nil, nil, "GuildSyncButton", nil, nil, options_button_template, options_text_template)
        guildSyncButton:SetPoint("topright", statisticsFrame, "topright", -20, -34)
        guildSyncButton:SetIcon([[Interface\GLUES\CharacterSelect\RestoreButton]], 12, 12, "overlay", {0.2, .8, 0.2, .8}, nil, 4)

        --listen to comm events
        local eventListener = Details:CreateEventListener()

        function eventListener:OnCommReceived(event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, data)
            if (prefix == CONST_GUILD_SYNC) then
                --print(event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, data)

                --received a list of encounter IDs
                if (guildSyncID == "L") then

                --received one encounter table
                elseif (guildSyncID == "A") then
                    if (not statisticsFrame.RequestedAmount) then
                        --if the receiving player reloads, f.RequestedAmount is nil
                        return
                    end
                    statisticsFrame.DownloadedAmount = (statisticsFrame.DownloadedAmount or 0) + 1

                    --size = 1 byte per characters in the string
                    statisticsFrame.EstimateSize = length * statisticsFrame.RequestedAmount > statisticsFrame.EstimateSize and length * statisticsFrame.RequestedAmount or statisticsFrame.RequestedAmount
                    statisticsFrame.DownloadedSize = statisticsFrame.DownloadedSize + length
                    local downloadSpeed = statisticsFrame.DownloadedSize / (time() - statisticsFrame.SyncStartTime)

                    statisticsFrame.SyncText:SetText("working [downloading " .. statisticsFrame.DownloadedAmount .. "/" .. statisticsFrame.RequestedAmount .. ", " .. format("%.2f", downloadSpeed/1024) .. "Kbps]")
                end
            end
        end

        function eventListener:OnCommSent(event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, missingIDs, arg8, arg9)
            if (prefix == CONST_GUILD_SYNC) then
                --print(event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, missingIDs, arg8, arg9)

                --requested a list of encounters
                if (guildSyncID == "R") then

                --requested to download a selected list of encounter tables
                elseif (guildSyncID == "G") then
                    statisticsFrame.RequestedAmount = statisticsFrame.RequestedAmount + #missingIDs
                    statisticsFrame.SyncText:SetText("working [downloading " .. statisticsFrame.DownloadedAmount .. "/" .. statisticsFrame.RequestedAmount .. "]")
                end
            end
        end

        eventListener:RegisterEvent("COMM_EVENT_RECEIVED", "OnCommReceived")
        eventListener:RegisterEvent("COMM_EVENT_SENT", "OnCommSent")

        --report results
        function statisticsFrame.BuildReport()
            if (statisticsFrame.LatestResourceTable) then
                local reportFunc = function(IsCurrent, IsReverse, AmtLines)
                    local bossName = statisticsFrame.select_boss.label:GetText()
                    local bossDiff = statisticsFrame.select_diff.label:GetText()
                    local guildName = statisticsFrame.select_guild.label:GetText()
                    local reportTable = {"Details!: DPS Rank for: " .. (bossDiff or "") .. " " .. (bossName or "--x--x--") .. " <" .. (guildName or "") .. ">"}
                    local result = {}

                    for i = 1, AmtLines do
                        if (statisticsFrame.LatestResourceTable[i]) then
                            local playerName = statisticsFrame.LatestResourceTable[i][1]
                            playerName = playerName:gsub("%|c%x%x%x%x%x%x%x%x", "")
                            playerName = playerName:gsub("%|r", "")
                            playerName = playerName:gsub(".*%s", "")
                            tinsert(result, {playerName, statisticsFrame.LatestResourceTable[i][2]})
                        else
                            break
                        end
                    end

                    Details:FormatReportLines(reportTable, result)
                    Details:SendReportLines(reportTable)
                end

                Details:SendReportWindow(reportFunc, nil, nil, true)
            end
        end

        local reportButton = DF:CreateButton(statisticsFrame, statisticsFrame.BuildReport, 130, 20, Loc ["STRING_OPTIONS_REPORT_ANCHOR"]:gsub(":", ""), nil, nil, nil, "ReportButton", nil, nil, options_button_template, options_text_template)
        reportButton:SetPoint("right", guildSyncButton, "left", -2, 0)
        reportButton:SetIcon([[Interface\GLUES\CharacterSelect\RestoreButton]], 12, 12, "overlay", {0.2, .8, 0.2, .8}, nil, 4)

        --
        function statisticsFrame:SetBackgroundImage(encounterId)
            local instanceId = Details:GetInstanceIdFromEncounterId(encounterId)
            if (instanceId) then
                local file, L, R, T, B = Details:GetRaidBackground(instanceId)
                --print("file:", file)
                --can't get the image, looks to be restricted
                --[[
                if (file) then
                    background:SetTexture(file)
                    background:SetTexCoord(L, R, T, B)
                else
                    background:SetColorTexture(0.2, 0.2, 0.2, 0.8)
                end
                --]]
                background:SetColorTexture(0.2, 0.2, 0.2, 0.8)
            end
        end

        --window script handlers
        statisticsFrame:SetScript("OnMouseDown", function(self, button)
            if (self.isMoving) then
                return
            end
            if (button == "RightButton") then
                self:Hide()
            else
                self:StartMoving()
                self.isMoving = true
            end
        end)

        statisticsFrame:SetScript("OnMouseUp", function(self, button)
            if (self.isMoving and button == "LeftButton") then
                self:StopMovingOrSizing()
                self.isMoving = nil
            end
        end)

        statisticsFrame:SetScript("OnHide", function()
            --save latest shown state
            statisticsFrame.LatestSelection = statisticsFrame.LatestSelection or {}
            statisticsFrame.LatestSelection.Raid = DetailsRaidHistoryWindow.select_raid.value
            statisticsFrame.LatestSelection.Boss = DetailsRaidHistoryWindow.select_boss.value
            statisticsFrame.LatestSelection.Diff = DetailsRaidHistoryWindow.select_diff.value
            statisticsFrame.LatestSelection.Role = DetailsRaidHistoryWindow.select_role.value
            statisticsFrame.LatestSelection.Guild = DetailsRaidHistoryWindow.select_guild.value
            statisticsFrame.LatestSelection.PlayerBase = DetailsRaidHistoryWindow.select_player.value
            statisticsFrame.LatestSelection.PlayerName = DetailsRaidHistoryWindow.select_player2.value
        end)

        local dropdownWidth = 160
        local icon = [[Interface\FriendsFrame\battlenet-status-offline]]

        local difficultyList = {}
        local raidList = {}
        local bossList = {}
        local guildList = {}

        local sortAlphabetical = function(a,b) return a.value < b.value end

        local onSelect = function()
            if (statisticsFrame.Refresh) then
                statisticsFrame:Refresh()
            end
        end

        --select raid:
        local onRaidSelect = function(_, _, raid)
            Details.rank_window.last_raid = raid
            statisticsFrame:UpdateDropdowns(true)
            onSelect()
        end

        local buildRaidList = function()
            return raidList
        end

        local raidDropdown = DF:CreateDropDown(statisticsFrame, buildRaidList, 1, dropdownWidth, 20, "select_raid")
        local raidString = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_RAID"] .. ":", _, _, "GameFontNormal", "select_raid_label")
        raidDropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select boss:
        local onSelectBoss = function(_, _, boss)
            onSelect()
        end

        local buildBossList = function()
            return bossList
        end

        local bossDropdown = DF:CreateDropDown(statisticsFrame, buildBossList, 1, dropdownWidth, 20, "select_boss")
        local bossString = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_BOSS"] .. ":", _, _, "GameFontNormal", "select_boss_label")
        bossDropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select difficulty:
        local onDifficultySelect = function(_, _, diff)
            Details.rank_window.last_difficulty = diff
            onSelect()
        end

        local buildDifficultyList = function()
            return difficultyList
        end

        local difficultyDropdown = DF:CreateDropDown(statisticsFrame, buildDifficultyList, 1, dropdownWidth, 20, "select_diff")
        local difficultyString = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_DIFF"] .. ":", _, _, "GameFontNormal", "select_diff_label")
        difficultyDropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select role:
        local onRoleSelect = function(_, _, role)
            onSelect()
        end

        local buildRoleList = function()
            return {
                {value = "damage", label = "Damager", icon = icon, onclick = onRoleSelect},
                {value = "healing", label = "Healer", icon = icon, onclick = onRoleSelect}
            }
        end

        local role_dropdown = DF:CreateDropDown (statisticsFrame, buildRoleList, 1, dropdownWidth, 20, "select_role")
        local role_string = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_ROLE"] .. ":", _, _, "GameFontNormal", "select_role_label")
        role_dropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select guild:
        local onGuildSelect = function(_, _, guild)
            onSelect()
        end

        local buildGuildList = function()
            return guildList
        end

        local guildDropdown = DF:CreateDropDown(statisticsFrame, buildGuildList, 1, dropdownWidth, 20, "select_guild")
        local guildString = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_GUILD"] .. ":", _, _, "GameFontNormal", "select_guild_label")
        guildDropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select playerbase:
        local onPlayerSelect = function(_, _, player)
            onSelect()
        end

        local buildPlayerList = function()
            return {
                {value = 1, label = Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_RAID"], icon = icon, onclick = onPlayerSelect},
                {value = 2, label = Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_INDIVIDUAL"], icon = icon, onclick = onPlayerSelect},
            }
        end

        local player_dropdown = DF:CreateDropDown(statisticsFrame, buildPlayerList, 1, dropdownWidth, 20, "select_player")
        local player_string = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE"] .. ":", _, _, "GameFontNormal", "select_player_label")
        player_dropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --select player:
        local onPlayer2Select = function(_, _, player)
            statisticsFrame.latest_player_selected = player
            statisticsFrame:BuildPlayerTable(player)
        end

        local buildPlayer2List = function()
            local encounterTable, guild, role = unpack(statisticsFrame.build_player2_data or {})
            local t = {}
            local alreadyListed = {}
            if (encounterTable) then
                for encounterIndex, encounter in ipairs(encounterTable) do
                    if (encounter.guild == guild) then
                        local roleTable = encounter [role]
                        for playerName, _ in pairs(roleTable) do
                            if (not alreadyListed [playerName]) then
                                tinsert(t, {value = playerName, label = playerName, icon = icon, onclick = onPlayer2Select})
                                alreadyListed [playerName] = true
                            end
                        end
                    end
                end
            end

            table.sort(t, sortAlphabetical)
            return t
        end

        local player2Dropdown = DF:CreateDropDown(statisticsFrame, buildPlayer2List, 1, dropdownWidth, 20, "select_player2")
        local player2String = DF:CreateLabel(statisticsFrame, Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_PLAYER"] .. ":", _, _, "GameFontNormal", "select_player2_label")
        player2Dropdown:SetTemplate(DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        function statisticsFrame:UpdateDropdowns(bDoNotSelectRaid)
            local currentGuild = guildDropdown.value

            --wipe data
            wipe(difficultyList)
            wipe(bossList)
            wipe(raidList)
            wipe(guildList)

            local bossRepeated = {}
            local raidRepeated = {}
            local guildRepeated = {}

            local raidSelected = _G.DetailsRaidHistoryWindow.select_raid:GetValue()
            db = statisticsFrame.OpenDB()
            if (not db) then
                return
            end

            --make a list of raids and bosses that belong to the current expansion
            local bossIndexedTable, bossInfoTable, raidInfoTable = Details:GetExpansionBossList()
            local allowedBosses = {}
            for bossId, bossTable in pairs(bossInfoTable) do
                allowedBosses[bossTable.dungeonEncounterID] = true --dungeonEncounterID is the id used in the encounter_start event
            end

            local allowedKeysForDifficulty = {
                [14] = true, --normal
                [15] = true, --heroic
                [16] = true, --mythic
                --[17] = true, --raid finder
            }

            local playerGuildName = GetGuildInfo("player")
            --local playerGuildName = "Patifaria" --debug

            for difficulty, encounterIdTable in pairs(db) do
                if (type(difficulty) == "number" and allowedKeysForDifficulty[difficulty]) then
                    for dungeonEncounterID, encounterTable in pairs(encounterIdTable) do
                        if (allowedBosses[dungeonEncounterID]) then
                            if (not bossRepeated[dungeonEncounterID]) then
                                local encounter, instance = Details:GetBossEncounterDetailsFromEncounterId(nil, dungeonEncounterID) --deprecated

                                if (encounter) then
                                    local instanceId = Details:GetInstanceIdFromEncounterId(dungeonEncounterID)
                                    if (raidSelected == instanceId) then
                                        tinsert(bossList, {value = dungeonEncounterID, label = encounter.boss, icon = icon, onclick = onSelectBoss})
                                        bossRepeated[dungeonEncounterID] = true
                                    end

                                    if (not raidRepeated[instance.name]) then
                                        local raidData
                                        for raidInstanceID, thisRaidData in pairs(raidInfoTable) do
                                            if (thisRaidData.raidName == instance.name) then
                                                raidData = thisRaidData
                                                break
                                            end
                                        end

                                        if (raidData) then
                                            local instanceName = raidData.raidName
                                            local raidIcon = raidData.raidIcon
                                            local raidIconCoords = raidData.raidIconCoords

                                            tinsert(raidList, {value = instance.id, label = instanceName, icon = raidIcon, texcoord = raidIconCoords, onclick = onRaidSelect})
                                            raidRepeated[instance.name] = true
                                        end
                                    end
                                end
                            end

                            --add guild name to the dropdown
                            if (playerGuildName) then
                                if (not guildRepeated[playerGuildName]) then
                                    tinsert(guildList, {value = playerGuildName, label = playerGuildName, icon = icon, onclick = onGuildSelect})
                                    guildRepeated[playerGuildName] = true
                                end
                            else
                                for index, encounter in ipairs(encounterTable) do
                                    local guild = encounter.guild
                                    if (not guildRepeated[guild]) then
                                        tinsert(guildList, {value = guild, label = guild, icon = icon, onclick = onGuildSelect})
                                        guildRepeated[guild] = true
                                    end
                                end
                            end

                            --add the difficult to the dropdown
                            if (difficulty == 14) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Normal") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, 1, {value = difficulty, label = "Normal", icon = icon, onclick = onDifficultySelect})
                                end

                            elseif (difficulty == 15) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Heroic") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, 1, {value = difficulty, label = "Heroic", icon = icon, onclick = onDifficultySelect})
                                end

                            elseif (difficulty == 16) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Mythic") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, {value = difficulty, label = "Mythic", icon = icon, onclick = onDifficultySelect})
                                end
                            end
                        end
                    end
                end
            end

            table.sort(bossList, function(t1, t2) return t1.label < t2.label end)

            difficultyDropdown:Refresh()
            guildDropdown:Refresh()
            if (not bDoNotSelectRaid) then
                raidDropdown:Refresh()
            end
            bossDropdown:Refresh()

            C_Timer.After(1, function()
                if (not bDoNotSelectRaid) then
                    raidDropdown:Select(1, true)
                end

                difficultyDropdown:Select(1, true)

                if (currentGuild) then
                    guildDropdown:Select(currentGuild)
                else
                    guildDropdown:Select(1, true)
                end

                bossDropdown:Select(1, true)
            end)
        end

        function statisticsFrame.UpdateBossDropdown()
            local allowedKeysForDifficulty = {
                [14] = true, --normal
                [15] = true, --heroic
                [16] = true, --mythic
                --[17] = true, --raid finder
            }

            --make a list of raids and bosses that belong to the current expansion
            local bossIndexedTable, bossInfoTable = Details:GetExpansionBossList()
            local allowedBosses = {}
            for bossId, bossTable in pairs(bossInfoTable) do
                allowedBosses[bossTable.dungeonEncounterID] = true
            end

            local raidSelected = DetailsRaidHistoryWindow.select_raid:GetValue()
            local bossRepeated = {}
            wipe(bossList)
            wipe(difficultyList)

            for difficulty, encounterIdTable in pairs(db) do
                if (type(difficulty) == "number" and allowedKeysForDifficulty[difficulty]) then
                    for dungeonEncounterID, encounterTable in pairs(encounterIdTable) do
                        if (allowedBosses[dungeonEncounterID]) then
                            if (not bossRepeated[dungeonEncounterID]) then
                                local encounter, instance = Details:GetBossEncounterDetailsFromEncounterId(nil, dungeonEncounterID) --deprecated

                                if (encounter) then
                                    local instanceId = Details:GetInstanceIdFromEncounterId(dungeonEncounterID)
                                    if (raidSelected == instanceId) then
                                        tinsert(bossList, {value = dungeonEncounterID, label = encounter.boss, icon = icon, onclick = onSelectBoss})
                                        bossRepeated[dungeonEncounterID] = true
                                    end
                                end
                            end

                            --add the difficult to the dropdown
                            if (difficulty == 14) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Normal") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, 1, {value = difficulty, label = "Normal", icon = icon, onclick = onDifficultySelect})
                                end

                            elseif (difficulty == 15) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Heroic") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, 1, {value = difficulty, label = "Heroic", icon = icon, onclick = onDifficultySelect})
                                end

                            elseif (difficulty == 16) then
                                local alreadyHave = false
                                for i, t in ipairs(difficultyList) do
                                    if (t.label == "Mythic") then
                                        alreadyHave = true
                                    end
                                end
                                if (not alreadyHave) then
                                    tinsert(difficultyList, {value = difficulty, label = "Mythic", icon = icon, onclick = onDifficultySelect})
                                end
                            end
                        end
                    end
                end
            end

            table.sort(bossList, function(t1, t2) return t1.label < t2.label end)
            bossDropdown:Refresh()
        end

        --anchors:
        raidString:SetPoint("topleft", statisticsFrame, "topleft", 10, -70)
        raidDropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -85)

        bossString:SetPoint("topleft", statisticsFrame, "topleft", 10, -110)
        bossDropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -125)

        difficultyString:SetPoint("topleft", statisticsFrame, "topleft", 10, -150)
        difficultyDropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -165)

        role_string:SetPoint("topleft", statisticsFrame, "topleft", 10, -190)
        role_dropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -205)

        guildString:SetPoint("topleft", statisticsFrame, "topleft", 10, -230)
        guildDropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -245)

        player_string:SetPoint("topleft", statisticsFrame, "topleft", 10, -270)
        player_dropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -285)

        player2String:SetPoint("topleft", statisticsFrame, "topleft", 10, -310)
        player2Dropdown:SetPoint("topleft", statisticsFrame, "topleft", 10, -325)
        player2String:Hide()
        player2Dropdown:Hide()

        --refresh the window:

        function statisticsFrame:BuildPlayerTable(playerName)

            local encounterTable, guild, role = unpack(statisticsFrame.build_player2_data or {})
            local data = {}

            if (type(playerName) == "string" and string.len(playerName) > 1) then
                for encounterIndex, encounter in ipairs(encounterTable) do
                    if (encounter.guild == guild) then
                        local roleTable = encounter [role]

                        local date = encounter.date
                        date = date:gsub(".*%s", "")
                        date = date:sub (1, -4)

                        local player = roleTable [playerName]

                        if (player) then

                            --tinsert(data, {text = date, value = player[1], data = player, fulldate = encounter.date, elapsed = encounter.elapsed})
                            tinsert(data, {text = date, value = player[1]/encounter.elapsed, utext = Details:ToK2 (player[1]/encounter.elapsed), data = player, fulldate = encounter.date, elapsed = encounter.elapsed})
                        end
                    end
                end

                --update graphic
                if (not statisticsFrame.gframe) then
                    local onenter = function(self)
                        GameCooltip:Reset()
                        GameCooltip:SetType("tooltip")
                        GameCooltip:Preset(2)

                        GameCooltip:AddLine("Total Done:", Details:ToK2 (self.data.value), 1, "white")
                        GameCooltip:AddLine("Dps:", Details:ToK2 (self.data.value / self.data.elapsed), 1, "white")
                        GameCooltip:AddLine("Item Level:", floor(self.data.data [2]), 1, "white")
                        GameCooltip:AddLine("Date:", self.data.fulldate:gsub(".*%s", ""), 1, "white")

                        GameCooltip:SetOwner(self.ball.tooltip_anchor)
                        GameCooltip:Show()
                    end

                    local onleave = function(self)
                        GameCooltip:Hide()
                    end

                    statisticsFrame.gframe = DF:CreateGFrame(statisticsFrame, 650, 400, 35, onenter, onleave, "gframe", "$parentGF")
                    statisticsFrame.gframe:SetPoint("topleft", statisticsFrame, "topleft", 190, -65)
                end

                statisticsFrame.gframe:Reset()
                statisticsFrame.gframe:UpdateLines(data)
            end
        end

        local fillpanel = DF:NewFillPanel(statisticsFrame, {}, "$parentFP", "fillpanel", 710, 501, false, false, true, nil)
        fillpanel:SetPoint("topleft", statisticsFrame, "topleft", 195, -65)

        function statisticsFrame:BuildGuildRankTable(encounterTable, guild, role)

            local header = {{name = "Player Name", type = "text"}, {name = "Per Second", type = "text"}, {name = "Total", type = "text"}, {name = "Length", type = "text"}, {name = "Item Level", type = "text"}, {name = "Date", type = "text"}}
            local players = {}
            local players_index = {}

            local playerScore = {}

            --get the best of each player
            for encounterIndex, encounter in ipairs(encounterTable) do
                if (encounter.guild == guild) then
                    local roleTable = encounter[role]

                    local date = encounter.date
                    date = date:gsub(".*%s", "")
                    date = date:sub (1, -4)

                    for playerName, playerTable in pairs(roleTable) do
                        if (not playerScore[playerName]) then
                            playerScore [playerName] = {
                                total = 0,
                                ps = 0,
                                ilvl = 0,
                                date = 0,
                                class = 0,
                                length = 0,
                            }
                        end

                        local total = playerTable [1]
                        local dps = total / encounter.elapsed

                        --if (total > playerScore [playerName].total) then
                        if (dps > playerScore[playerName].ps) then
                            playerScore[playerName].total = total
                            playerScore[playerName].ps = total / encounter.elapsed
                            playerScore[playerName].ilvl = playerTable [2]
                            playerScore[playerName].length = encounter.elapsed
                            playerScore[playerName].date = date
                            playerScore[playerName].class = playerTable [3]
                        end
                    end
                end
            end

            local sortTable = {}
            for playerName, t in pairs(playerScore) do
                local className = select(2, GetClassInfo(t.class or 0))
                local classColor = "FFFFFFFF"
                if (className) then
                    classColor = RAID_CLASS_COLORS[className] and RAID_CLASS_COLORS[className].colorStr
                end

                local playerNameFormated = Details:GetOnlyName(playerName)
                tinsert(sortTable, {
                    "|c" .. classColor .. playerNameFormated .. "|r",
                    Details:comma_value (t.ps),
                    Details:ToK2 (t.total),
                    DF:IntegerToTimer(t.length),
                    floor(t.ilvl),
                    t.date,
                    t.total,
                    t.ps,
                })
            end

            table.sort(sortTable, function(a, b) return a[8] > b[8] end)

            --add the number before the player name
            for i = 1, #sortTable do
                local t = sortTable [i]
                t[1] = i .. ". " .. t[1]
            end

            fillpanel:SetFillFunction(function(index) return sortTable [index] end)
            fillpanel:SetTotalFunction(function() return #sortTable end)
            fillpanel:UpdateRows(header)
            fillpanel:Refresh()

            statisticsFrame.LatestResourceTable = sortTable
        end

        function statisticsFrame:BuildRaidTable(encounterTable, guild, role)
            if (statisticsFrame.Mode == 2) then
                statisticsFrame:BuildGuildRankTable(encounterTable, guild, role)
                return
            end

            local header = {{name = "Player Name", type = "text"}} -- , width = 90
            local players = {}
            local players_index = {}
            local player_class = {}
            local amt_encounters = 0

            for encounterIndex, encounter in ipairs(encounterTable) do
                if (encounter.guild == guild) then
                    local roleTable = encounter [role]

                    local date = encounter.date
                    date = date:gsub(".*%s", "")
                    date = date:sub (1, -4)
                    amt_encounters = amt_encounters + 1

                    tinsert(header, {name = date, type = "text"})

                    for playerName, playerTable in pairs(roleTable) do
                        local index = players_index [playerName]
                        local player

                        if (not index) then
                            player = {playerName}
                            player_class [playerName] = playerTable [3]
                            for i = 1, amt_encounters-1 do
                                tinsert(player, "")
                            end
                            tinsert(player, Details:ToK2 (playerTable [1] / encounter.elapsed))
                            tinsert(players, player)
                            players_index [playerName] = #players

                            --print("not index", playerName, amt_encounters, date, 2, amt_encounters-1)
                        else
                            player = players [index]
                            for i = #player+1, amt_encounters-1 do
                                tinsert(player, "")
                            end
                            tinsert(player, Details:ToK2 (playerTable [1] / encounter.elapsed))
                        end

                    end
                end
            end

            --sort alphabetical
            table.sort (players, function(a, b) return a[1] < b[1] end)

            for index, playerTable in ipairs(players) do
                for i = #playerTable, amt_encounters do
                    tinsert(playerTable, "")
                end

                local className = select(2, GetClassInfo (player_class [playerTable [1]] or 0))
                if (className) then
                    local playerNameFormated = Details:GetOnlyName(playerTable[1])
                    local classColor = RAID_CLASS_COLORS [className] and RAID_CLASS_COLORS [className].colorStr
                    playerTable [1] = "|c" .. classColor .. playerNameFormated .. "|r"
                end
            end

            fillpanel:SetFillFunction (function(index) return players [index] end)
            fillpanel:SetTotalFunction (function() return #players end)

            fillpanel:UpdateRows (header)

            fillpanel:Refresh()
            fillpanel:SetPoint("topleft", statisticsFrame, "topleft", 200, -65)
        end

        function statisticsFrame:Refresh (player_name)
            --build the main table
            local diff = difficultyDropdown.value
            local boss = bossDropdown.value
            local role = role_dropdown.value
            local guild = guildDropdown.value
            local player = player_dropdown.value

            local diffTable = db [diff]

            statisticsFrame:SetBackgroundImage(boss)

            if (diffTable) then
                local encounters = diffTable[boss]
                if (encounters) then
                    if (player == 1) then --raid
                        fillpanel:Show()
                        if (statisticsFrame.gframe) then
                            statisticsFrame.gframe:Hide()
                        end
                        player2String:Hide()
                        player2Dropdown:Hide()
                        statisticsFrame:BuildRaidTable(encounters, guild, role)

                    elseif (player == 2) then --only one player
                        fillpanel:Hide()
                        if (statisticsFrame.gframe) then
                            statisticsFrame.gframe:Show()
                        end
                        player2String:Show()
                        player2Dropdown:Show()
                        statisticsFrame.build_player2_data = {encounters, guild, role}
                        player2Dropdown:Refresh()

                        player_name = statisticsFrame.latest_player_selected or player_name

                        if (player_name) then
                            player2Dropdown:Select(player_name)
                        else
                            player2Dropdown:Select(1, true)
                        end

                        statisticsFrame:BuildPlayerTable (player2Dropdown.value)
                    end
                else
                    if (player == 1) then --raid
                        fillpanel:Show()
                        if (statisticsFrame.gframe) then
                            statisticsFrame.gframe:Hide()
                        end
                        player2String:Hide()
                        player2Dropdown:Hide()
                        statisticsFrame:BuildRaidTable ({}, guild, role)

                    elseif (player == 2) then --only one player
                        fillpanel:Hide()
                        if (statisticsFrame.gframe) then
                            statisticsFrame.gframe:Show()
                        end
                        player2String:Show()
                        player2Dropdown:Show()
                        statisticsFrame.build_player2_data = {{}, guild, role}
                        player2Dropdown:Refresh()
                        player2Dropdown:Select(1, true)
                        statisticsFrame:BuildPlayerTable (player2Dropdown.value)
                    end
                end
            end
        end

        statisticsFrame.FirstRun = true
    end --end of DetailsRaidHistoryWindow creation

    local statsWindow = _G.DetailsRaidHistoryWindow

    --table means some button send the request - nil for other ways
        if (type(raidName) == "table" or (not raidName and not bossEncounterId and not difficultyId and not playerRole and not guildName and not playerBase and not playerName)) then
            local f = statsWindow
            if (f.LatestSelection) then
                raidName = f.LatestSelection.Raid
                bossEncounterId = f.LatestSelection.Boss
                difficultyId = f.LatestSelection.Diff
                playerRole = f.LatestSelection.Role
                guildName = f.LatestSelection.Guild
                playerBase = f.LatestSelection.PlayerBase
                playerName = f.LatestSelection.PlayerBase
            end
        end

    if (statsWindow.FirstRun) then
        difficultyId = Details.rank_window.last_difficulty or difficultyId

        if (IsInGuild()) then
            local guildName = GetGuildInfo("player")
            if (guildName) then
                guildName = guildName
            end
        end

        if (Details.rank_window.last_raid ~= "") then
            raidName = Details.rank_window.last_raid or raidName
        end
    end

    if (not statsWindow.UpdateDropdowns) then
        Details:Msg("Failled to load statistics, Details! Storage is disabled?")
        return
    end

    statsWindow:UpdateDropdowns()
    statsWindow:Refresh()
    statsWindow:Show()

    if (historyType == 1 or historyType == 2) then
        statsWindow.Mode = historyType
        if (statsWindow.Mode == 1) then
            --overall
            statsWindow.HistoryCheckBox:SetValue(true)
            statsWindow.GuildRankCheckBox:SetValue(false)
        elseif (statsWindow.Mode == 2) then
            --guild rank
            statsWindow.GuildRankCheckBox:SetValue(true)
            statsWindow.HistoryCheckBox:SetValue(false)
        end
    end

    if (raidName) then
        statsWindow.select_raid:Select(raidName)
        statsWindow:Refresh()
        statsWindow.UpdateBossDropdown()
    end

    if (bossEncounterId) then
        statsWindow.select_boss:Select(bossEncounterId)
        statsWindow:Refresh()
    end

    if (difficultyId) then
        statsWindow.select_diff:Select(difficultyId)
        statsWindow:Refresh()
    end

    if (playerRole) then
        statsWindow.select_role:Select(playerRole)
        statsWindow:Refresh()
    end

    if (guildName) then
        if (type(guildName) == "boolean") then
            guildName = GetGuildInfo("player")
        end
        statsWindow.select_guild:Select(guildName)
        statsWindow:Refresh()
    end

    if (playerBase) then
        statsWindow.select_player:Select(playerBase)
        statsWindow:Refresh()
    end

    if (playerName) then
        statsWindow.select_player2:Refresh()
        statsWindow.select_player2:Select(playerName)
        statsWindow:Refresh (playerName)
    end

    DetailsPluginContainerWindow.OpenPlugin(statsWindow)
end
