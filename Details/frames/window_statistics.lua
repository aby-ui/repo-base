

--todo: need to fix this file after pre-patch

local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")

--prefix used on sync statistics
local CONST_GUILD_SYNC = "GS"

function Details:InitializeRaidHistoryWindow()
    local DetailsRaidHistoryWindow = CreateFrame ("frame", "DetailsRaidHistoryWindow", UIParent,"BackdropTemplate")
    DetailsRaidHistoryWindow.Frame = DetailsRaidHistoryWindow
    DetailsRaidHistoryWindow.__name = Loc ["STRING_STATISTICS"]
    DetailsRaidHistoryWindow.real_name = "DETAILS_STATISTICS"
    DetailsRaidHistoryWindow.__icon = [[Interface\AddOns\Details\images\icons]]
    DetailsRaidHistoryWindow.__iconcoords = {278/512, 314/512, 43/512, 76/512}
    DetailsRaidHistoryWindow.__iconcolor = "DETAILS_STATISTICS_ICON"
    DetailsPluginContainerWindow.EmbedPlugin (DetailsRaidHistoryWindow, DetailsRaidHistoryWindow, true)

    function DetailsRaidHistoryWindow.RefreshWindow()
        Details:OpenRaidHistoryWindow()
        C_Timer.After(3, function()
            Details:OpenRaidHistoryWindow()
        end)
    end
end

function Details:OpenRaidHistoryWindow (_raid, _boss, _difficulty, _role, _guild, _player_base, _player_name, _history_type)

    if (not DetailsRaidHistoryWindow or not DetailsRaidHistoryWindow.Initialized) then
    
        local db = Details.storage:OpenRaidStorage()
        if (not db) then
            return Details:Msg (Loc ["STRING_GUILDDAMAGERANK_DATABASEERROR"])
        end
        
        DetailsRaidHistoryWindow.Initialized = true
        
        local f = DetailsRaidHistoryWindow or CreateFrame ("frame", "DetailsRaidHistoryWindow", UIParent,"BackdropTemplate") --, "ButtonFrameTemplate"
        f:SetPoint ("center", UIParent, "center")
        f:SetFrameStrata ("HIGH")
        f:SetToplevel (true)
        
        f:SetMovable (true)
        f:SetWidth (850)
        f:SetHeight (500)
        tinsert (UISpecialFrames, "DetailsRaidHistoryWindow")
        
        f.Mode = 2
        
        f.bg1 = f:CreateTexture (nil, "background")
        f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
        f.bg1:SetAlpha (0.7)
        f.bg1:SetVertexColor (0.27, 0.27, 0.27)
        f.bg1:SetVertTile (true)
        f.bg1:SetHorizTile (true)
        f.bg1:SetSize (790, 454)
        f.bg1:SetAllPoints()
        
        f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
        f:SetBackdropColor (.5, .5, .5, .5)
        f:SetBackdropBorderColor (0, 0, 0, 1)
        
        --> menu title bar
            local titlebar = CreateFrame ("frame", nil, f,"BackdropTemplate")
            titlebar:SetPoint ("topleft", f, "topleft", 2, -3)
            titlebar:SetPoint ("topright", f, "topright", -2, -3)
            titlebar:SetHeight (20)
            titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
            titlebar:SetBackdropColor (.5, .5, .5, 1)
            titlebar:SetBackdropBorderColor (0, 0, 0, 1)
            
        --> menu title
            local titleLabel = DF:NewLabel (titlebar, titlebar, nil, "titulo", "Details! " .. Loc ["STRING_STATISTICS"], "GameFontNormal", 12) --{227/255, 186/255, 4/255}
            titleLabel:SetPoint ("center", titlebar , "center")
            titleLabel:SetPoint ("top", titlebar , "top", 0, -4)
            
        --> close button
            f.Close = CreateFrame ("button", "$parentCloseButton", f)
            f.Close:SetPoint ("right", titlebar, "right", -2, 0)
            f.Close:SetSize (16, 16)
            f.Close:SetNormalTexture (DF.folder .. "icons")
            f.Close:SetHighlightTexture (DF.folder .. "icons")
            f.Close:SetPushedTexture (DF.folder .. "icons")
            f.Close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
            f.Close:SetAlpha (0.7)
            f.Close:SetScript ("OnClick", function() f:Hide() end)
            
        if (not Details:GetTutorialCVar ("HISTORYPANEL_TUTORIAL")) then
            local tutorialFrame = CreateFrame ("frame", "$parentTutorialFrame",f,"BackdropTemplate")
            tutorialFrame:SetPoint ("center", f, "center")
            tutorialFrame:SetFrameStrata ("DIALOG")
            tutorialFrame:SetSize (400, 300)
            tutorialFrame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
            insets = {left = 0, right = 0, top = 0, bottom = 0}, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize=1})
            tutorialFrame:SetBackdropColor (0, 0, 0, 1)
            
            tutorialFrame.Title = DF:CreateLabel (tutorialFrame, "Statistics" , 12, "orange") --curse localization isn't adding new strings (and I deleted the old one)
            tutorialFrame.Title:SetPoint ("top", tutorialFrame, "top", 0, -5)
            
            tutorialFrame.Desc = DF:CreateLabel (tutorialFrame, Loc ["STRING_GUILDDAMAGERANK_TUTORIAL_DESC"], 12)
            tutorialFrame.Desc.width = 370
            tutorialFrame.Desc:SetPoint ("topleft", tutorialFrame, "topleft", 10, -45)
            
            local closeButton = DF:CreateButton (tutorialFrame, function() Details:SetTutorialCVar ("HISTORYPANEL_TUTORIAL", true); tutorialFrame:Hide() end, 80, 20, Loc ["STRING_OPTIONS_CHART_CLOSE"])
            closeButton:SetPoint ("bottom", tutorialFrame, "bottom", 0, 10)
            closeButton:SetTemplate (DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
        end
        
        --wallpaper
            local background = f:CreateTexture ("$parentBackgroundImage", "border")
            background:SetAlpha (0.3)
            background:SetPoint ("topleft", f, "topleft", 6, -65)
            background:SetPoint ("bottomright", f, "bottomright", -10, 28)

        --separate menu and main list
            local div = f:CreateTexture (nil, "artwork")
            div:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-Achievement-MetalBorder-Left]])
            div:SetAlpha (0.1)
            div:SetPoint ("topleft", f, "topleft", 180, -64)
            div:SetHeight (574)
        
        --select history or guild rank
        local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
        local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
        local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
        
        local select_history = function()
            f.GuildRankCheckBox:SetValue (false)
            f.HistoryCheckBox:SetValue (true)
            f.Mode = 1
            _G.DetailsRaidHistoryWindow:Refresh()
            f.ReportButton:Hide()
        end
        
        local select_guildrank = function()
            f.HistoryCheckBox:SetValue (false)
            f.GuildRankCheckBox:SetValue (true)
            DetailsRaidHistoryWindow.select_player:Select (1, true)
            f.select_player2:Hide()
            f.select_player2_label:Hide()
            f.Mode = 2
            _G.DetailsRaidHistoryWindow:Refresh()
            f.ReportButton:Show()
        end

        local HistoryCheckBox, HistoryLabel = DF:CreateSwitch (f, select_history, false, 18, 18, "", "", "HistoryCheckBox", nil, nil, nil, nil, Loc ["STRING_GUILDDAMAGERANK_SHOWHISTORY"], options_switch_template) --, options_text_template
        HistoryLabel:ClearAllPoints()
        HistoryCheckBox:ClearAllPoints()
        HistoryCheckBox:SetPoint ("topleft", f, "topleft", 100, -34)
        HistoryLabel:SetPoint ("left", HistoryCheckBox, "right", 2, 0)
        HistoryCheckBox:SetAsCheckBox()
        
        local GuildRankCheckBox, GuildRankLabel = DF:CreateSwitch (f, select_guildrank, true, 18, 18, "", "", "GuildRankCheckBox", nil, nil, nil, nil, Loc ["STRING_GUILDDAMAGERANK_SHOWRANK"], options_switch_template) --, options_text_template
        GuildRankLabel:ClearAllPoints()
        GuildRankCheckBox:ClearAllPoints()
        GuildRankCheckBox:SetPoint ("topleft", f, "topleft", 240, -34)
        GuildRankLabel:SetPoint ("left", GuildRankCheckBox, "right", 2, 0)
        GuildRankCheckBox:SetAsCheckBox()
        
        local guild_sync = function()
            
            f.RequestedAmount = 0
            f.DownloadedAmount = 0
            f.EstimateSize = 0
            f.DownloadedSize = 0
            f.SyncStartTime = time()
            
            Details.storage:DBGuildSync()
            f.GuildSyncButton:Disable()
            
            if (not f.SyncTexture) then
                local workingFrame = CreateFrame ("frame", nil, f,"BackdropTemplate")
                f.WorkingFrame = workingFrame
                workingFrame:SetSize (1, 1)
                f.SyncTextureBackground = workingFrame:CreateTexture (nil, "border")
                f.SyncTextureBackground:SetPoint ("bottomright", f, "bottomright", -5, -1)
                f.SyncTextureBackground:SetTexture ([[Interface\COMMON\StreamBackground]])
                f.SyncTextureBackground:SetSize (32, 32)
                f.SyncTextureCircle = workingFrame:CreateTexture (nil, "artwork")
                f.SyncTextureCircle:SetPoint ("center", f.SyncTextureBackground, "center", 0, 0)
                f.SyncTextureCircle:SetTexture ([[Interface\COMMON\StreamCircle]])
                f.SyncTextureCircle:SetSize (32, 32)
                f.SyncTextureGrade = workingFrame:CreateTexture (nil, "overlay")
                f.SyncTextureGrade:SetPoint ("center", f.SyncTextureBackground, "center", 0, 0)
                f.SyncTextureGrade:SetTexture ([[Interface\COMMON\StreamFrame]])
                f.SyncTextureGrade:SetSize (32, 32)
                
                local animationHub = DF:CreateAnimationHub (workingFrame)
                animationHub:SetLooping ("Repeat")
                f.WorkingAnimation = animationHub
                
                local rotation = DF:CreateAnimation (animationHub, "ROTATION", 1, 3, -360)
                rotation:SetTarget (f.SyncTextureCircle)
                --DF:CreateAnimation (animationHub, "ALPHA", 1, 0.5, 0, 1)
                
                f.SyncText = workingFrame:CreateFontString (nil, "border", "GameFontNormal")
                f.SyncText:SetPoint ("right", f.SyncTextureBackground, "left", 0, 0)
                f.SyncText:SetText ("working")
                
                local endAnimationHub = DF:CreateAnimationHub (workingFrame, nil, function() workingFrame:Hide() end)
                DF:CreateAnimation (endAnimationHub, "ALPHA", 1, 0.5, 1, 0)
                f.EndAnimationHub = endAnimationHub
            end
            
            f.WorkingFrame:Show()
            f.WorkingAnimation:Play()
            
            C_Timer.NewTicker (10, function (self)
                if (not Details.LastGuildSyncReceived) then
                    f.GuildSyncButton:Enable()
                    f.EndAnimationHub:Play()

                elseif (Details.LastGuildSyncReceived+10 < GetTime()) then
                    f.GuildSyncButton:Enable()
                    f.EndAnimationHub:Play()
                    self:Cancel()
                end
            end)
            
        end
        
        local GuildSyncButton = DF:CreateButton (f, guild_sync, 130, 20, Loc ["STRING_GUILDDAMAGERANK_SYNCBUTTONTEXT"], nil, nil, nil, "GuildSyncButton", nil, nil, options_button_template, options_text_template)
        GuildSyncButton:SetPoint ("topright", f, "topright", -20, -34)
        GuildSyncButton:SetIcon ([[Interface\GLUES\CharacterSelect\RestoreButton]], 12, 12, "overlay", {0.2, .8, 0.2, .8}, nil, 4)
        
        --> listen to comm events
            local eventListener = Details:CreateEventListener()

            function eventListener:OnCommReceived (event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, data)
                if (prefix == CONST_GUILD_SYNC) then
                    --received a list of encounter IDs
                    if (guildSyncID == "L") then
                        
                    --received one encounter table
                    elseif (guildSyncID == "A") then
                        f.DownloadedAmount = (f.DownloadedAmount or 0) + 1
                        
                        --size = 1 byte per characters in the string
                        f.EstimateSize = length * f.RequestedAmount > f.EstimateSize and length * f.RequestedAmount or f.RequestedAmount
                        f.DownloadedSize = f.DownloadedSize + length
                        local downloadSpeed = f.DownloadedSize / (time() - f.SyncStartTime) 
                        
                        f.SyncText:SetText ("working [downloading " .. f.DownloadedAmount .. "/" .. f.RequestedAmount .. ", " .. format ("%.2f", downloadSpeed/1024) .. "Kbps]")
                    end
                end
            end
            
            function eventListener:OnCommSent (event, length, prefix, playerName, realmName, detailsVersion, guildSyncID, missingIDs, arg8, arg9)
                if (prefix == CONST_GUILD_SYNC) then
                    --requested a list of encounters
                    if (guildSyncID == "R") then
                        
                    
                    --requested to download a selected list of encounter tables
                    elseif (guildSyncID == "G") then
                        f.RequestedAmount = f.RequestedAmount + #missingIDs
                        f.SyncText:SetText ("working [downloading " .. f.DownloadedAmount .. "/" .. f.RequestedAmount .. "]")
                    end
                end
            end
            
            eventListener:RegisterEvent ("COMM_EVENT_RECEIVED", "OnCommReceived")
            eventListener:RegisterEvent ("COMM_EVENT_SENT", "OnCommSent")
        
        function f.BuildReport()
            if (f.LatestResourceTable) then
                local reportFunc = function (IsCurrent, IsReverse, AmtLines)
                    local bossName = f.select_boss.label:GetText()
                    local bossDiff = f.select_diff.label:GetText()
                    local guildName = f.select_guild.label:GetText()
                    
                    local reportTable = {"Details!: DPS Rank for: " .. (bossDiff or "") .. " " .. (bossName or "--x--x--") .. " <" .. (guildName or "") .. ">"}
                    local result = {}
                    
                    for i = 1, AmtLines do
                        if (f.LatestResourceTable[i]) then
                            local playerName = f.LatestResourceTable[i][1]
                            playerName = playerName:gsub ("%|c%x%x%x%x%x%x%x%x", "")
                            playerName = playerName:gsub ("%|r", "")
                            playerName = playerName:gsub (".*%s", "")
                            tinsert (result, {playerName, f.LatestResourceTable[i][2]})
                        else
                            break
                        end
                    end
                
                    Details:FormatReportLines (reportTable, result)
                    Details:SendReportLines (reportTable)
                end
                
                Details:SendReportWindow (reportFunc, nil, nil, true)
            end
        end
        
        local ReportButton = DF:CreateButton (f, f.BuildReport, 130, 20, Loc ["STRING_OPTIONS_REPORT_ANCHOR"]:gsub (":", ""), nil, nil, nil, "ReportButton", nil, nil, options_button_template, options_text_template)
        ReportButton:SetPoint ("right", GuildSyncButton, "left", -2, 0)
        ReportButton:SetIcon ([[Interface\GLUES\CharacterSelect\RestoreButton]], 12, 12, "overlay", {0.2, .8, 0.2, .8}, nil, 4)			

        --
        function f:SetBackgroundImage (encounterId)
            local instanceId = Details:GetInstanceIdFromEncounterId (encounterId)
            if (instanceId) then
                local file, L, R, T, B = Details:GetRaidBackground (instanceId)
                --print ("file:", file)
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
        
        f:SetScript ("OnMouseDown", function(self, button)
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
        f:SetScript ("OnMouseUp", function(self, button) 
            if (self.isMoving and button == "LeftButton") then
                self:StopMovingOrSizing()
                self.isMoving = nil
            end
        end)
        
        f:SetScript ("OnHide", function()
            --> save latest shown state
            f.LatestSelection = f.LatestSelection or {}
            f.LatestSelection.Raid = DetailsRaidHistoryWindow.select_raid.value
            f.LatestSelection.Boss = DetailsRaidHistoryWindow.select_boss.value
            f.LatestSelection.Diff = DetailsRaidHistoryWindow.select_diff.value
            f.LatestSelection.Role = DetailsRaidHistoryWindow.select_role.value
            f.LatestSelection.Guild = DetailsRaidHistoryWindow.select_guild.value
            f.LatestSelection.PlayerBase = DetailsRaidHistoryWindow.select_player.value
            f.LatestSelection.PlayerName = DetailsRaidHistoryWindow.select_player2.value
        end)
        
        local dropdown_size = 160
        local icon = [[Interface\FriendsFrame\battlenet-status-offline]]
        
        local diff_list = {}
        local raid_list = {}
        local boss_list = {}
        local guild_list = {}

        local sort_alphabetical = function(a,b) return a[1] < b[1] end
        local sort_alphabetical2 = function(a,b) return a.value < b.value end
        
        local on_select = function()
            if (f.Refresh) then
                f:Refresh()
            end
        end
        
        --> select raid:
        local on_raid_select = function (_, _, raid)
            Details.rank_window.last_raid = raid
            f:UpdateDropdowns (true)
            on_select()
        end
        local build_raid_list = function()
            return raid_list
        end
        local raid_dropdown = DF:CreateDropDown (f, build_raid_list, 1, dropdown_size, 20, "select_raid")
        local raid_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_RAID"] .. ":", _, _, "GameFontNormal", "select_raid_label")
        raid_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        
        --> select boss:
        local on_boss_select = function (_, _, boss)
            on_select()
        end
        local build_boss_list = function()
            return boss_list
        end
        local boss_dropdown = DF:CreateDropDown (f, build_boss_list, 1, dropdown_size, 20, "select_boss")
        local boss_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_BOSS"] .. ":", _, _, "GameFontNormal", "select_boss_label")
        boss_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --> select difficulty:
        local on_diff_select = function (_, _, diff)
            Details.rank_window.last_difficulty = diff
            on_select()
        end
        
        local build_diff_list = function()
            return diff_list
        end
        local diff_dropdown = DF:CreateDropDown (f, build_diff_list, 1, dropdown_size, 20, "select_diff")
        local diff_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_DIFF"] .. ":", _, _, "GameFontNormal", "select_diff_label")
        diff_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        
        --> select role:
        local on_role_select = function (_, _, role)
            on_select()
        end
        local build_role_list = function()
            return {
                {value = "damage", label = "Damager", icon = icon, onclick = on_role_select},
                {value = "healing", label = "Healer", icon = icon, onclick = on_role_select}
            }
        end
        local role_dropdown = DF:CreateDropDown (f, build_role_list, 1, dropdown_size, 20, "select_role")
        local role_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_ROLE"] .. ":", _, _, "GameFontNormal", "select_role_label")
        role_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        
        --> select guild:
        local on_guild_select = function (_, _, guild)
            on_select()
        end
        local build_guild_list = function()
            return guild_list
        end
        local guild_dropdown = DF:CreateDropDown (f, build_guild_list, 1, dropdown_size, 20, "select_guild")
        local guild_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_GUILD"] .. ":", _, _, "GameFontNormal", "select_guild_label")
        guild_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        
        --> select playerbase:
        local on_player_select = function (_, _, player)
            on_select()
        end
        local build_player_list = function()
            return {
                {value = 1, label = Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_RAID"], icon = icon, onclick = on_player_select},
                {value = 2, label = Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_INDIVIDUAL"], icon = icon, onclick = on_player_select},
            }
        end
        local player_dropdown = DF:CreateDropDown (f, build_player_list, 1, dropdown_size, 20, "select_player")
        local player_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE"] .. ":", _, _, "GameFontNormal", "select_player_label")
        player_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))

        --> select player:
        local on_player2_select = function (_, _, player)
            f.latest_player_selected = player
            f:BuildPlayerTable (player)
        end
        local build_player2_list = function()
            local encounterTable, guild, role = unpack (f.build_player2_data or {})
            local t = {}
            local already_listed = {}
            if (encounterTable) then
                for encounterIndex, encounter in ipairs (encounterTable) do
                    if (encounter.guild == guild) then
                        local roleTable = encounter [role]
                        for playerName, _ in pairs (roleTable) do
                            if (not already_listed [playerName]) then
                                tinsert (t, {value = playerName, label = playerName, icon = icon, onclick = on_player2_select})
                                already_listed [playerName] = true
                            end
                        end
                    end
                end
            end
            
            table.sort (t, sort_alphabetical2)
            
            return t
        end
        local player2_dropdown = DF:CreateDropDown (f, build_player2_list, 1, dropdown_size, 20, "select_player2")
        local player2_string = DF:CreateLabel (f, Loc ["STRING_GUILDDAMAGERANK_PLAYERBASE_PLAYER"] .. ":", _, _, "GameFontNormal", "select_player2_label")
        player2_dropdown:SetTemplate (DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
        
        function f:UpdateDropdowns (DoNotSelectRaid)
            
            local currentGuild = guild_dropdown.value
            
            --difficulty
            wipe (diff_list)
            wipe (boss_list)
            wipe (raid_list)
            wipe (guild_list)
            
            local boss_repeated = {}
            local raid_repeated = {}
            local guild_repeated = {}
            
            local raidSelected = DetailsRaidHistoryWindow.select_raid:GetValue()
            
            for difficulty, encounterIdTable in pairs (db) do
            
                if (type (difficulty) == "number") then
                    if (difficulty == 14) then
                        --tinsert (diff_list, {value = 14, label = "Normal", icon = icon, onclick = on_diff_select})
                        --print ("has normal encounter")
                    elseif (difficulty == 15) then
                        local alreadyHave = false
                        for i, t in ipairs (diff_list) do
                            if (t.label == "Heroic") then
                                alreadyHave = true
                            end
                        end
                        if (not alreadyHave) then
                            tinsert (diff_list, 1, {value = 15, label = "Heroic", icon = icon, onclick = on_diff_select})
                        end
                    elseif (difficulty == 16) then
                        local alreadyHave = false
                        for i, t in ipairs (diff_list) do
                            if (t.label == "Mythic") then
                                alreadyHave = true
                            end
                        end
                        if (not alreadyHave) then
                            tinsert (diff_list, {value = 16, label = "Mythic", icon = icon, onclick = on_diff_select})
                        end
                    end

                    for encounterId, encounterTable in pairs (encounterIdTable) do 
                        if (not boss_repeated [encounterId]) then
                            local encounter, instance = Details:GetBossEncounterDetailsFromEncounterId (_, encounterId)
                            if (encounter) then
                                local InstanceID = Details:GetInstanceIdFromEncounterId (encounterId)
                                if (raidSelected == InstanceID) then
                                    --[=[
                                    local bossIndex = Details:GetBossIndex (InstanceID, encounterId)
                                    if (bossIndex) then
                                        local l, r, t, b, texturePath = Details:GetBossIcon (InstanceID, bossIndex)
                                        if (texturePath) then
                                            tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = texturePath, texcoord = {l, r, t, b}, onclick = on_boss_select})
                                        else
                                            tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                        end
                                    else
                                        tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                    end
                                    --]=]
                                    
                                    tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                    boss_repeated [encounterId] = true
                                end
                                
                                if (not raid_repeated [instance.name]) then
                                    tinsert (raid_list, {value = instance.id, label = instance.name, icon = icon, onclick = on_raid_select})
                                    raid_repeated [instance.name] = true
                                end
                                
                            end
                        end
                        
                        for index, encounter in ipairs (encounterTable) do
                            local guild = encounter.guild
                            if (not guild_repeated [guild]) then
                                tinsert (guild_list, {value = guild, label = guild, icon = icon, onclick = on_guild_select})
                                guild_repeated [guild] = true
                            end
                        end
                    end
                end
            end
            
            table.sort (boss_list, function (t1, t2) return t1.label < t2.label end)
            
            
            diff_dropdown:Refresh()
            diff_dropdown:Select (1, true)
            boss_dropdown:Refresh()
            boss_dropdown:Select (1, true)
            if (not DoNotSelectRaid) then
                raid_dropdown:Refresh()
                raid_dropdown:Select (1, true)
            end
            
            guild_dropdown:Refresh()
            if (currentGuild) then
                guild_dropdown:Select (currentGuild)
            else
                guild_dropdown:Select (1, true)
            end
        end
        
        function f.UpdateBossDropdown()
        
            local raidSelected = DetailsRaidHistoryWindow.select_raid:GetValue()
            local boss_repeated = {}
            wipe (boss_list)
            
            for difficulty, encounterIdTable in pairs (db) do
                if (type (difficulty) == "number") then
                    if (difficulty == 14) then
                        --tinsert (diff_list, {value = 14, label = "Normal", icon = icon, onclick = on_diff_select})
                        --print ("has normal encounter")
                    elseif (difficulty == 15) then
                        local alreadyHave = false
                        for i, t in ipairs (diff_list) do
                            if (t.label == "Heroic") then
                                alreadyHave = true
                            end
                        end
                        if (not alreadyHave) then
                            tinsert (diff_list, 1, {value = 15, label = "Heroic", icon = icon, onclick = on_diff_select})
                        end
                    elseif (difficulty == 16) then
                        local alreadyHave = false
                        for i, t in ipairs (diff_list) do
                            if (t.label == "Mythic") then
                                alreadyHave = true
                            end
                        end
                        if (not alreadyHave) then
                            tinsert (diff_list, {value = 16, label = "Mythic", icon = icon, onclick = on_diff_select})
                        end
                    end

                    for encounterId, encounterTable in pairs (encounterIdTable) do 
                        if (not boss_repeated [encounterId]) then
                            local encounter, instance = Details:GetBossEncounterDetailsFromEncounterId (_, encounterId)
                            if (encounter) then
                                local InstanceID = Details:GetInstanceIdFromEncounterId (encounterId)
                                if (raidSelected == InstanceID) then
                                --[=[
                                    local bossIndex = Details:GetBossIndex (InstanceID, encounterId)
                                    if (bossIndex) then
                                        local l, r, t, b, texturePath = Details:GetBossIcon (InstanceID, bossIndex)
                                        if (texturePath) then
                                            tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = texturePath, texcoord = {l, r, t, b}, onclick = on_boss_select})
                                        else
                                            tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                        end
                                    else
                                        tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                    end									
                                --]=]
                                    tinsert (boss_list, {value = encounterId, label = encounter.boss, icon = icon, onclick = on_boss_select})
                                    boss_repeated [encounterId] = true
                                end
                            end
                        end
                    end
                end
            end
            
            table.sort (boss_list, function (t1, t2) return t1.label < t2.label end)
            boss_dropdown:Refresh()
        end
        
        --> anchors:
        raid_string:SetPoint ("topleft", f, "topleft", 10, -70)
        raid_dropdown:SetPoint ("topleft", f, "topleft", 10, -85)
        
        boss_string:SetPoint ("topleft", f, "topleft", 10, -110)
        boss_dropdown:SetPoint ("topleft", f, "topleft", 10, -125)
        
        diff_string:SetPoint ("topleft", f, "topleft", 10, -150)
        diff_dropdown:SetPoint ("topleft", f, "topleft", 10, -165)
        
        role_string:SetPoint ("topleft", f, "topleft", 10, -190)
        role_dropdown:SetPoint ("topleft", f, "topleft", 10, -205)
        
        guild_string:SetPoint ("topleft", f, "topleft", 10, -230)
        guild_dropdown:SetPoint ("topleft", f, "topleft", 10, -245)
        
        player_string:SetPoint ("topleft", f, "topleft", 10, -270)
        player_dropdown:SetPoint ("topleft", f, "topleft", 10, -285)
        
        player2_string:SetPoint ("topleft", f, "topleft", 10, -310)
        player2_dropdown:SetPoint ("topleft", f, "topleft", 10, -325)
        player2_string:Hide()
        player2_dropdown:Hide()
        
        --> refresh the window:
        
        function f:BuildPlayerTable (playerName)
            
            local encounterTable, guild, role = unpack (f.build_player2_data or {})
            local data = {}
            
            if (type (playerName) == "string" and string.len (playerName) > 1) then
                for encounterIndex, encounter in ipairs (encounterTable) do
                    
                    if (encounter.guild == guild) then
                        local roleTable = encounter [role]
                        
                        local date = encounter.date
                        date = date:gsub (".*%s", "")
                        date = date:sub (1, -4)

                        local player = roleTable [playerName]
                        
                        if (player) then
                        
                            --tinsert (data, {text = date, value = player[1], data = player, fulldate = encounter.date, elapsed = encounter.elapsed})
                            tinsert (data, {text = date, value = player[1]/encounter.elapsed, utext = Details:ToK2 (player[1]/encounter.elapsed), data = player, fulldate = encounter.date, elapsed = encounter.elapsed})
                        end
                    end
                end
                
                --> update graphic
                if (not f.gframe) then
                    
                    local onenter = function (self)
                        GameCooltip:Reset()
                        GameCooltip:SetType ("tooltip")
                        GameCooltip:Preset (2)

                        GameCooltip:AddLine ("Total Done:", Details:ToK2 (self.data.value), 1, "white")
                        GameCooltip:AddLine ("Dps:", Details:ToK2 (self.data.value / self.data.elapsed), 1, "white")
                        GameCooltip:AddLine ("Item Level:", floor (self.data.data [2]), 1, "white")
                        GameCooltip:AddLine ("Date:", self.data.fulldate:gsub (".*%s", ""), 1, "white")

                        GameCooltip:SetOwner (self.ball.tooltip_anchor)
                        GameCooltip:Show()
                    end
                    local onleave = function (self)
                        GameCooltip:Hide()
                    end
                    f.gframe = DF:CreateGFrame (f, 650, 400, 35, onenter, onleave, "gframe", "$parentGF")
                    f.gframe:SetPoint ("topleft", f, "topleft", 190, -65)
                end
                
                f.gframe:Reset()
                f.gframe:UpdateLines (data)
                
            end
        end
        
        local fillpanel = DF:NewFillPanel (f, {}, "$parentFP", "fillpanel", 710, 501, false, false, true, nil)
        fillpanel:SetPoint ("topleft", f, "topleft", 195, -65)

        
        function f:BuildGuildRankTable (encounterTable, guild, role)
            
            local header = {{name = "Player Name", type = "text"}, {name = "Per Second", type = "text"}, {name = "Total", type = "text"}, {name = "Length", type = "text"}, {name = "Item Level", type = "text"}, {name = "Date", type = "text"}}
            local players = {}
            local players_index = {}
            
            local playerScore = {}
            
            --get the best of each player
            for encounterIndex, encounter in ipairs (encounterTable) do
                if (encounter.guild == guild) then
                    local roleTable = encounter [role]
                    
                    local date = encounter.date
                    date = date:gsub (".*%s", "")
                    date = date:sub (1, -4)
                    
                    for playerName, playerTable in pairs (roleTable) do
                    
                        if (not playerScore [playerName]) then
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
                        if (dps > playerScore [playerName].ps) then
                            playerScore [playerName].total = total
                            playerScore [playerName].ps = total / encounter.elapsed
                            playerScore [playerName].ilvl = playerTable [2]
                            playerScore [playerName].length = encounter.elapsed
                            playerScore [playerName].date = date
                            playerScore [playerName].class = playerTable [3]
                        end
                    end
                end
            end
            
            local sortTable = {}
            for playerName, t in pairs (playerScore) do
                local className = select (2, GetClassInfo (t.class or 0))
                local classColor = "FFFFFFFF"
                if (className) then
                    classColor = RAID_CLASS_COLORS [className] and RAID_CLASS_COLORS [className].colorStr
                end
            
                local playerNameFormated = Details:GetOnlyName (playerName)
                tinsert (sortTable, {
                    "|c" .. classColor .. playerNameFormated .. "|r",
                    Details:comma_value (t.ps),
                    Details:ToK2 (t.total),
                    DF:IntegerToTimer (t.length),
                    floor (t.ilvl),
                    t.date,
                    t.total,
                    t.ps,
                })
            end
            
            table.sort (sortTable, function(a, b) return a[8] > b[8] end)
            
            --> add the number before the player name
            for i = 1, #sortTable do
                local t = sortTable [i]
                t [1] = i .. ". " .. t [1]
            end
            
            fillpanel:SetFillFunction (function (index) return sortTable [index] end)
            fillpanel:SetTotalFunction (function() return #sortTable end)
            fillpanel:UpdateRows (header)
            fillpanel:Refresh()
            
            f.LatestResourceTable = sortTable
        end
        
        function f:BuildRaidTable (encounterTable, guild, role)
            
            if (f.Mode == 2) then
                f:BuildGuildRankTable (encounterTable, guild, role)
                return
            end
            
            local header = {{name = "Player Name", type = "text"}} -- , width = 90
            local players = {}
            local players_index = {}
            local player_class = {}
            local amt_encounters = 0
            
            for encounterIndex, encounter in ipairs (encounterTable) do
                if (encounter.guild == guild) then
                    local roleTable = encounter [role]
                    
                    local date = encounter.date
                    date = date:gsub (".*%s", "")
                    date = date:sub (1, -4)
                    amt_encounters = amt_encounters + 1
                    
                    tinsert (header, {name = date, type = "text"})
                    
                    for playerName, playerTable in pairs (roleTable) do
                        local index = players_index [playerName]
                        local player
                        
                        if (not index) then
                            player = {playerName}
                            player_class [playerName] = playerTable [3]
                            for i = 1, amt_encounters-1 do
                                tinsert (player, "")
                            end
                            tinsert (player, Details:ToK2 (playerTable [1] / encounter.elapsed))
                            tinsert (players, player)
                            players_index [playerName] = #players
                            
                            --print ("not index", playerName, amt_encounters, date, 2, amt_encounters-1)
                        else
                            player = players [index]
                            for i = #player+1, amt_encounters-1 do
                                tinsert (player, "")
                            end
                            tinsert (player, Details:ToK2 (playerTable [1] / encounter.elapsed))
                        end
                        
                    end
                end
            end
            
            --> sort alphabetical
            table.sort (players, function(a, b) return a[1] < b[1] end)
            
            for index, playerTable in ipairs (players) do
                for i = #playerTable, amt_encounters do
                    tinsert (playerTable, "")
                end

                local className = select (2, GetClassInfo (player_class [playerTable [1]] or 0))
                if (className) then
                    local playerNameFormated = Details:GetOnlyName (playerTable[1])
                    local classColor = RAID_CLASS_COLORS [className] and RAID_CLASS_COLORS [className].colorStr
                    playerTable [1] = "|c" .. classColor .. playerNameFormated .. "|r"
                end
            end
            
            fillpanel:SetFillFunction (function (index) return players [index] end)
            fillpanel:SetTotalFunction (function() return #players end)
            
            fillpanel:UpdateRows (header)
            
            fillpanel:Refresh()
            fillpanel:SetPoint ("topleft", f, "topleft", 200, -65)
        end
        
        function f:Refresh (player_name)
            --> build the main table
            local diff = diff_dropdown.value
            local boss = boss_dropdown.value
            local role = role_dropdown.value
            local guild = guild_dropdown.value
            local player = player_dropdown.value
            
            local diffTable = db [diff]
            
            f:SetBackgroundImage (boss)
            --Details:OpenRaidHistoryWindow (_raid, _boss, _difficulty, _role, _guild, _player_base, _player_name)
            
            if (diffTable) then
                local encounters = diffTable [boss]
                if (encounters) then
                    if (player == 1) then --> raid
                        fillpanel:Show()
                        if (f.gframe) then
                            f.gframe:Hide()
                        end
                        player2_string:Hide()
                        player2_dropdown:Hide()
                        f:BuildRaidTable (encounters, guild, role)

                    elseif (player == 2) then --> only one player
                        fillpanel:Hide()
                        if (f.gframe) then
                            f.gframe:Show()
                        end
                        player2_string:Show()
                        player2_dropdown:Show()
                        f.build_player2_data = {encounters, guild, role}
                        player2_dropdown:Refresh()
                        
                        player_name = f.latest_player_selected or player_name
                        
                        if (player_name) then
                            player2_dropdown:Select (player_name)
                        else
                            player2_dropdown:Select (1, true)
                        end
                        
                        f:BuildPlayerTable (player2_dropdown.value)
                    end
                else
                    if (player == 1) then --> raid
                        fillpanel:Show()
                        if (f.gframe) then
                            f.gframe:Hide()
                        end
                        player2_string:Hide()
                        player2_dropdown:Hide()
                        f:BuildRaidTable ({}, guild, role)

                    elseif (player == 2) then --> only one player
                        fillpanel:Hide()
                        if (f.gframe) then
                            f.gframe:Show()
                        end
                        player2_string:Show()
                        player2_dropdown:Show()
                        f.build_player2_data = {{}, guild, role}
                        player2_dropdown:Refresh()
                        player2_dropdown:Select (1, true)
                        f:BuildPlayerTable (player2_dropdown.value)
                    end
                end
            end
        end
        
        f.FirstRun = true
    end
    
    --> table means some button send the request - nil for other ways
    
    if (type (_raid) == "table" or (not _raid and not _boss and not _difficulty and not _role and not _guild and not _player_base and not _player_name)) then
        local f = _G.DetailsRaidHistoryWindow
        if (f.LatestSelection) then
            _raid = f.LatestSelection.Raid
            _boss = f.LatestSelection.Boss
            _difficulty = f.LatestSelection.Diff
            _role = f.LatestSelection.Role
            _guild = f.LatestSelection.Guild
            _player_base = f.LatestSelection.PlayerBase
            _player_name = f.LatestSelection.PlayerBase
        end
    end
    
    if (_G.DetailsRaidHistoryWindow.FirstRun) then
        _difficulty = Details.rank_window.last_difficulty or _difficulty
        if (IsInGuild()) then
            local guildName = GetGuildInfo ("player")
            if (guildName) then
                _guild = guildName
            end
        end
        if (Details.rank_window.last_raid ~= "") then
            _raid = Details.rank_window.last_raid or _raid
        end
        
        _G.DetailsRaidHistoryWindow.FirstRun = nil
    end
    
    _G.DetailsRaidHistoryWindow:UpdateDropdowns()
    _G.DetailsRaidHistoryWindow:UpdateDropdowns()
    
    _G.DetailsRaidHistoryWindow:Refresh()
    _G.DetailsRaidHistoryWindow:Show()
    
    if (_history_type == 1 or _history_type == 2) then
        DetailsRaidHistoryWindow.Mode = _history_type
        if (DetailsRaidHistoryWindow.Mode == 1) then
            --overall
            DetailsRaidHistoryWindow.HistoryCheckBox:SetValue (true)
            DetailsRaidHistoryWindow.GuildRankCheckBox:SetValue (false)
        elseif (DetailsRaidHistoryWindow.Mode == 2) then
            --guild rank
            DetailsRaidHistoryWindow.GuildRankCheckBox:SetValue (true)
            DetailsRaidHistoryWindow.HistoryCheckBox:SetValue (false)
        end
    end
    
    if (_raid) then
        DetailsRaidHistoryWindow.select_raid:Select (_raid)
        _G.DetailsRaidHistoryWindow:Refresh()
        DetailsRaidHistoryWindow.UpdateBossDropdown()
    end
    if (_boss) then
        DetailsRaidHistoryWindow.select_boss:Select (_boss)
        _G.DetailsRaidHistoryWindow:Refresh()
    end
    if (_difficulty) then
        DetailsRaidHistoryWindow.select_diff:Select (_difficulty)
        _G.DetailsRaidHistoryWindow:Refresh()
    end
    if (_role) then
        DetailsRaidHistoryWindow.select_role:Select (_role)
        _G.DetailsRaidHistoryWindow:Refresh()
    end
    if (_guild) then
        if (type (_guild) == "boolean") then
            _guild = GetGuildInfo ("player")
        end
        DetailsRaidHistoryWindow.select_guild:Select (_guild)
        _G.DetailsRaidHistoryWindow:Refresh()
    end
    if (_player_base) then
        DetailsRaidHistoryWindow.select_player:Select (_player_base)
        _G.DetailsRaidHistoryWindow:Refresh()
    end
    if (_player_name) then
        DetailsRaidHistoryWindow.select_player2:Refresh()
        DetailsRaidHistoryWindow.select_player2:Select (_player_name)
        _G.DetailsRaidHistoryWindow:Refresh (_player_name)
    end

    DetailsPluginContainerWindow.OpenPlugin (DetailsRaidHistoryWindow)
end
