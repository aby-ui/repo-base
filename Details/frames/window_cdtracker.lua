

local Details = _G.Details
local DF = _G.DetailsFramework
local raidStatusLib = LibStub:GetLibrary("LibRaidStatus-1.0")

local width = 170
local height = 300
local bar_height = 20

--namespace
Details.CooldownTracking = {}

function Details:InitializeCDTrackerWindow()
    local DetailsCDTrackerWindow = CreateFrame("frame", "DetailsCDTrackerWindow", UIParent, "BackdropTemplate")
    DetailsCDTrackerWindow:SetSize(700, 480)
    DetailsCDTrackerWindow.Frame = DetailsCDTrackerWindow
    DetailsCDTrackerWindow.__name = "OCD Tracker"
    DetailsCDTrackerWindow.real_name = "DETAILS_CDTRACKERWINDOW"
    DetailsCDTrackerWindow.__icon = [[Interface\TUTORIALFRAME\UI-TUTORIALFRAME-SPIRITREZ]]
    DetailsCDTrackerWindow.__iconcoords = {130/512, 256/512, 0, 1}
    DetailsCDTrackerWindow.__iconcolor = "white"
    _G.DetailsPluginContainerWindow.EmbedPlugin(DetailsCDTrackerWindow, DetailsCDTrackerWindow, true)

    function DetailsCDTrackerWindow.RefreshWindow()
        Details.OpenCDTrackerWindow()
    end

    --check if is enabled at startup
    if (Details.CooldownTracking.IsEnabled()) then
        Details.CooldownTracking.EnableTracker()
    end

    DetailsCDTrackerWindow:Hide()
end

function Details.CooldownTracking.IsEnabled()
    return Details.ocd_tracker.enabled
end

function Details.CooldownTracking.EnableTracker()
    Details.ocd_tracker.enabled = true

    --register callbacks
    raidStatusLib.RegisterCallback(Details.CooldownTracking, "CooldownListUpdate", "CooldownListUpdateFunc")
    raidStatusLib.RegisterCallback(Details.CooldownTracking, "CooldownListWiped", "CooldownListWipedFunc")
    raidStatusLib.RegisterCallback(Details.CooldownTracking, "CooldownUpdate", "CooldownUpdateFunc")

    Details.CooldownTracking.RefreshCooldownFrames()
end

function Details.CooldownTracking.DisableTracker()
    Details.ocd_tracker.enabled = false

    --hide the panel
    if (DetailsOnlineCDTrackerScreenPanel) then
        DetailsOnlineCDTrackerScreenPanel:Hide()
    end

    --unregister callbacks
    raidStatusLib.UnregisterCallback(Details.CooldownTracking, "CooldownListUpdate", "CooldownListUpdateFunc")
    raidStatusLib.UnregisterCallback(Details.CooldownTracking, "CooldownListWiped", "CooldownListWipedFunc")
    raidStatusLib.UnregisterCallback(Details.CooldownTracking, "CooldownUpdate", "CooldownUpdateFunc")
end

function Details.CooldownTracking.CooldownListUpdateFunc()
    --print("CooldownListUpdate")
    Details.CooldownTracking.RefreshCooldowns()
end

function Details.CooldownTracking.CooldownListWipedFunc()
    --print("CooldownListWiped")
    Details.CooldownTracking.RefreshCooldowns()
end

function Details.CooldownTracking.CooldownUpdateFunc()
    print("CooldownUpdate")
    Details.CooldownTracking.RefreshCooldowns()
end

function Details.CooldownTracking.HideAllBars()
    for _, bar in ipairs (DetailsOnlineCDTrackerScreenPanel.bars) do
        bar:ClearAllPoints()
        bar:Hide()
    end
end

function Details.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, frameId)
    local cooldownFrame = screenPanel.bars[frameId]
    if (cooldownFrame) then
        return cooldownFrame
    end

    local cooldownFrame = DF:CreateTimeBar(screenPanel, [[Interface\AddOns\Details\images\bar_serenity]], width-2, bar_height-2, 100, nil, screenPanel:GetName() .. "CDFrame" .. frameId)
    tinsert(screenPanel.bars, cooldownFrame)
    return cooldownFrame
end

function Details.CooldownTracking.SetupCooldownFrame(cooldownFrame, unitName, class, spellId)
    local spellIcon = GetSpellTexture(spellId)
    if (spellIcon) then
        cooldownFrame:SetIcon(spellIcon, .1, .9, .1, .9)

        local classColor = C_ClassColor.GetClassColor(class)
        cooldownFrame:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

        cooldownFrame:SetLeftText(DF:RemoveRealmName(unitName))

        cooldownFrame.spellId = spellId
        cooldownFrame.class = class
        cooldownFrame.unitName = unitName
    end
end


function Details.CooldownTracking.SetupCooldownFrameTimer(cooldownFrame, startTime, endTime, currentTime)
    if (currentTime == 0) then
        cooldownFrame:StopTimer()

    else
        cooldownFrame:SetTimer(currentTime, startTime, endTime)
    end
end

function Details.CooldownTracking.ProcessUnitCooldowns(unitId, statusBarFrameId, cooldownsOrganized)
    local screenPanel = DetailsOnlineCDTrackerScreenPanel
    if (not screenPanel) then
        return
    end

    local playerInfo = raidStatusLib.playerInfoManager.GetPlayerInfo()
    local allCooldownsFromLib = LIB_RAID_STATUS_COOLDOWNS_BY_SPEC
    local cooldownsEnabled = Details.ocd_tracker.cooldowns

    local unitName = UnitName(unitId)
    local thisPlayerInfo = playerInfo[unitName]
    local GUID = UnitGUID(unitId)
    local _, unitClassEng, classId = UnitClass(unitId)
    local unitSpec = (thisPlayerInfo and thisPlayerInfo.specId) or (Details:GetSpecFromSerial(GUID)) or 0

    if (unitSpec and unitSpec ~= 0) then
        local unitCooldowns = allCooldownsFromLib[unitSpec]
        for spellId, cooldownType in pairs(unitCooldowns) do
            if (cooldownsEnabled[spellId]) then

                local spellName = GetSpellInfo(spellId)
                --print("CD:", spellName, unitName) --problema com shadowfiend do shadowpriest the mostra 2 vezes

                local cooldownFrame = Details.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, statusBarFrameId)
                Details.CooldownTracking.SetupCooldownFrame(cooldownFrame, unitName, unitClassEng, spellId)
                tinsert(cooldownsOrganized[classId], cooldownFrame)
                statusBarFrameId =  statusBarFrameId + 1

                screenPanel.playerCache[unitName] = screenPanel.playerCache[unitName] or {}
                screenPanel.playerCache[unitName][spellId] = cooldownFrame
            end
        end
    end
end

function Details.CooldownTracking.RefreshCooldownFrames()
    local screenPanel = DetailsOnlineCDTrackerScreenPanel

    if (not screenPanel) then
        --screen panel (goes into the UIParent and show cooldowns there)
        DetailsOnlineCDTrackerScreenPanel = CreateFrame("frame", "DetailsOnlineCDTrackerScreenPanel", UIParent, "BackdropTemplate")
        screenPanel = DetailsOnlineCDTrackerScreenPanel
        screenPanel:Hide()
        screenPanel:SetSize(width, height)
        screenPanel:SetPoint("center", 0, 0)
        screenPanel:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
        screenPanel:SetBackdropColor(0, 0, 0, .55)
        screenPanel:SetBackdropBorderColor(0, 0, 0, .3)
        screenPanel:EnableMouse(true)

        --register on libwindow
        local libWindow = LibStub("LibWindow-1.1")
        libWindow.RegisterConfig(screenPanel, _detalhes.ocd_tracker.pos)
        libWindow.MakeDraggable(screenPanel)
        libWindow.RestorePosition(screenPanel)

        screenPanel:RegisterEvent("GROUP_ROSTER_UPDATE")
        screenPanel:SetScript("OnShow", function()
            screenPanel:RegisterEvent("GROUP_ROSTER_UPDATE")
        end)
        screenPanel:SetScript("OnHide", function()
            screenPanel:UnregisterEvent("GROUP_ROSTER_UPDATE")
        end)

        screenPanel:SetScript("OnEvent", function(self, event)
            if (event == "GROUP_ROSTER_UPDATE") then
                if (screenPanel.scheduleRosterUpdate) then
                    return
                end
                screenPanel.scheduleRosterUpdate = C_Timer.NewTimer(1, Details.CooldownTracking.RefreshCooldownFrames)
            end
        end)

        screenPanel.bars = {}
        screenPanel.cooldownCache = Details.ocd_tracker.current_cooldowns
        screenPanel.playerCache = {}
    end

    screenPanel.scheduleRosterUpdate = nil

    if (Details.ocd_tracker.show_conditions.only_in_group) then
        if (not IsInGroup()) then
            screenPanel:Hide()
            return
        end
    end

    if (Details.ocd_tracker.show_conditions.only_inside_instance) then
        local isInInstanceType = select(2, GetInstanceInfo())
        if (isInInstanceType ~= "party" and isInInstanceType ~= "raid" and isInInstanceType ~= "scenario" and isInInstanceType ~= "arena") then
            screenPanel:Hide()
            return
        end
    end

    local cooldownsOrganized = {}
    for classId = 1, 12 do --12 classes
        cooldownsOrganized[classId] = {}
    end
    local numGroupMembers = GetNumGroupMembers()
    local statusBarFrameId = 1

    wipe(screenPanel.playerCache)

    if (IsInRaid()) then
        for i = 1, numGroupMembers do
            local unitId = "raid"..i
            Details.CooldownTracking.ProcessUnitCooldowns(unitId, statusBarFrameId, cooldownsOrganized)
        end

    elseif (IsInGroup()) then
        for i = 1, numGroupMembers - 1 do
            local unitId = "party"..i
            Details.CooldownTracking.ProcessUnitCooldowns(unitId, statusBarFrameId, cooldownsOrganized)
        end

        --player
        Details.CooldownTracking.ProcessUnitCooldowns("player", statusBarFrameId, cooldownsOrganized)
    end

    for classId = 1, 12 do --12 classes
        table.sort(cooldownsOrganized[classId], function(t1, t2) return t1.spellId < t2.spellId end)
    end

    Details.CooldownTracking.RefreshCooldowns()
end

--esta passando NIL no startTime para o SetTimer
--o numero de frames criados é menor que o numero de frames mostrados, esta dando erro em local bar = screenPanel.bars[barIndex] 381

function Details.CooldownTracking.RefreshCooldowns()
    local screenPanel = DetailsOnlineCDTrackerScreenPanel
    if (not screenPanel) then
        return
    end

    --local cache saved with the character savedVariables
    local cooldownCache = screenPanel.cooldownCache
    local cooldownStatus = raidStatusLib.cooldownManager.GetCooldownTable()
    local cooldownIndex = 1

    for unitName, allPlayerCooldowns in pairs(cooldownStatus) do
        for spellId, cooldownInfo in pairs(allPlayerCooldowns) do
            local cooldownFrame = screenPanel.playerCache[unitName] and screenPanel.playerCache[unitName][spellId]
            if (cooldownFrame) then

                local cooldownCache = cooldownCache[unitName] and cooldownCache[unitName][spellId]
                if (not cooldownCache) then
                    --a cache with cooldown timers is saved within the host addon
                    screenPanel.cooldownCache[unitName] = screenPanel.cooldownCache[unitName] or {}
                    screenPanel.cooldownCache[unitName][spellId] = screenPanel.cooldownCache[unitName][spellId] or {}
                    cooldownCache = screenPanel.cooldownCache[unitName][spellId]
                end

                local timeLeft = cooldownInfo[1]
                local charges = cooldownInfo[2]
                local startTime = GetTime() - cooldownInfo[3]
                local duration = cooldownInfo[4]
                local endTime = startTime + duration

                --save the cooldown data in the host addon
                cooldownCache[1] = timeLeft
                cooldownCache[2] = charges
                cooldownCache[3] = startTime
                cooldownCache[4] = endTime

                cooldownFrame:Show()

                if (cooldownFrame.spellId ~= spellId or unitName ~= cooldownFrame.unitName) then
                    --there's a different spell showing or player using this frame
                    if (timeLeft ~= 0) then
                        local spellName = GetSpellInfo(spellId)
                        --print("set timer 3", spellName, startTime + timeLeft, startTime, endTime)
                        --cooldownFrame:SetTimer(startTime + timeLeft, startTime, endTime)
                    end
                else
                    --spell and player are the same
                    if (timeLeft ~= 0) then
                        if (cooldownFrame:HasTimer()) then
                            if (cooldownFrame.timeLeft ~= timeLeft) then
                                local spellName = GetSpellInfo(spellId)
                                --print("set timer 1", spellName, startTime + timeLeft, startTime, endTime)
                                --cooldownFrame:SetTimer(startTime + timeLeft, startTime, endTime)
                            end
                        else
                            if (timeLeft ~= 0) then
                                local spellName = GetSpellInfo(spellId)
                                --print("set timer 2", spellName, startTime + timeLeft, startTime, endTime)
                                --cooldownFrame:SetTimer(startTime + timeLeft, startTime, endTime)
                            end
                        end
                    else
                        if (cooldownFrame:GetValue() ~= 100) then
                            cooldownFrame:StopTimer()
                        end
                    end
                end

                cooldownIndex = cooldownIndex + 1
            end
        end
    end

    --[=[]]

    local cooldownIndex = 1

    for classId = 1, 12 do --12 classes
        local t = cooldownsOrganized[classId]
        for i = 1, #t do
            local bar = screenPanel.bars[cooldownIndex]
            cooldownIndex = cooldownIndex + 1
            bar:Show()
            local cooldownTable = t[i]

            local classColor = C_ClassColor.GetClassColor(cooldownTable[6])
            bar:SetStatusBarColor(classColor.r, classColor.g, classColor.b)

            local spellNameDebug, _, spellIcon = GetSpellInfo(cooldownTable[5])
            bar:SetIcon(spellIcon, .1, .9, .1, .9)
            bar:SetLeftText(DF:RemoveRealmName(cooldownTable[1]))

            local timeLeft = cooldownTable[2]
            if (timeLeft > 0) then
                bar.spellId = cooldownTable[5]
                bar:SetTimer(timeLeft)
                --print("timeLeft:", timeLeft, spellNameDebug)
            else
                bar:SetMinMaxValues(0, 100)
                bar:SetTimer(0)
                --print(spellNameDebug)
                C_Timer.After(1, function()
                   -- bar:SetMinMaxValues(0, 100)
                   -- bar:SetTimer(0)
                end)
            end
        end
    end
    --]=]

    cooldownIndex = cooldownIndex - 1
    print("total frames:", cooldownIndex)

    local xAnchor = 1
    local defaultY = 0
    local xPos = 1
    local yPos = 0
    local maxHeight = 0

    for barIndex = 1, cooldownIndex do
        if (barIndex % 11 == 0) then
            xPos = xPos + width + 2
            yPos = 0
        end

        local bar = screenPanel.bars[barIndex]
        bar:SetPoint("topleft", screenPanel, "topleft", xPos, yPos)
        yPos = yPos - bar_height
        if (yPos < maxHeight)  then
            maxHeight = yPos
        end
    end

    maxHeight = abs(maxHeight)

    if (maxHeight == 0) then
        screenPanel:Hide()
        return
    end

    screenPanel:SetSize(width + xAnchor, abs(maxHeight))
    screenPanel:Show()
end

function Details.OpenCDTrackerWindow()

    --check if the window exists, if not create it
    if (not _G.DetailsCDTrackerWindow or not _G.DetailsCDTrackerWindow.Initialized) then
        _G.DetailsCDTrackerWindow.Initialized = true
        local f = _G.DetailsCDTrackerWindow or DF:CreateSimplePanel(UIParent, 700, 480, "Details! Online CD Tracker", "DetailsCDTrackerWindow")
        DF:ApplyStandardBackdrop(f)
        --enabled with a toggle button
        --execute to reset position
        --misc configs
        local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
        local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
        local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
        local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
        local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

        local generalOptions = {
            {--enable ocd
                type = "toggle",
                get = function() return Details.ocd_tracker.enabled end,
                set = function (self, fixedparam, value)
                    if (value) then
                        Details.CooldownTracking.EnableTracker()
                    else
                        Details.CooldownTracking.DisableTracker()
                    end
                end,
                name = "Enable Online Cooldown Tracker",
                desc = "Enable Online Cooldown Tracker",
            },

            {--show only in group
                type = "toggle",
                get = function() return Details.ocd_tracker.show_conditions.only_in_group end,
                set = function (self, fixedparam, value)
                    Details.ocd_tracker.show_conditions.only_in_group = value
                    Details.CooldownTracking.RefreshCooldownFrames()
                end,
                name = "Only in Group",
                desc = "Only in Group",
            },

            {--show only inside instances
                type = "toggle",
                get = function() return Details.ocd_tracker.show_conditions.only_inside_instance end,
                set = function (self, fixedparam, value)
                    Details.ocd_tracker.show_conditions.only_inside_instance = value
                    Details.CooldownTracking.RefreshCooldownFrames()
                end,
                name = "Only Inside Instances",
                desc = "Only Inside Instances",
            },
        }

        DF:BuildMenu(f, generalOptions, 5, -35, 150, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

        --cooldown selection
        local cooldownProfile = Details.ocd_tracker.cooldowns

        local cooldownSelectionFrame = CreateFrame("frame", "$parentCooldownSelectionFrame", f, "BackdropTemplate")
        cooldownSelectionFrame:SetPoint("topleft", f, "topleft", 0, -150)
        cooldownSelectionFrame:SetPoint("bottomright", f, "bottomright", 0, 10)
        DF:ApplyStandardBackdrop(cooldownSelectionFrame)

        --list of cooldowns to show, each one with a toggle button
        local cooldownList = {}
        local alreadyAdded = {}
        if (LIB_RAID_STATUS_COOLDOWNS_BY_SPEC) then
            for specId, cooldownTable in pairs(LIB_RAID_STATUS_COOLDOWNS_BY_SPEC) do

                local currentIndex = #cooldownList+1
                local cooldownAdded = false

                for spellId, cooldownType in pairs(cooldownTable) do
                    if (not alreadyAdded[spellId]) then
                        if (cooldownType == 3 or cooldownType == 4 or cooldownType == 1 or cooldownType == 2) then
                            local spellName, _, spellIcon = GetSpellInfo(spellId)
                            if (spellName) then
                                cooldownList[#cooldownList+1] = {
                                    type = "toggle",
                                    get = function()
                                            if (cooldownProfile[spellId] == nil) then
                                                if (cooldownType == 3 or cooldownType == 4 or cooldownType == 1 or cooldownType == 2) then
                                                    cooldownProfile[spellId] = true
                                                end
                                            end
                                            return cooldownProfile[spellId]
                                    end,
                                    set = function (self, fixedparam, value)
                                        if (value) then
                                            cooldownProfile[spellId] = value
                                        else
                                            cooldownProfile[spellId] = nil
                                        end
                                    end,
                                    name = "|T" .. spellIcon .. ":" .. (16) .. ":" .. (16) .. ":0:0:64:64:" .. 0.1*64 .. ":" .. 0.9*64 .. ":" .. 0.1*64 .. ":" .. 0.9*64 .. "|t" .. spellName,
                                    desc = spellName,
                                    boxfirst = true,
                                }

                                alreadyAdded[spellId] = true
                                cooldownAdded = true
                            end
                        end
                    end
                end

                if (cooldownAdded) then
                    local _, spenName, _, specIcon = GetSpecializationInfoByID(specId)
                    local iconString = "|T" .. specIcon .. ":" .. (16) .. ":" .. (16) .. ":0:0:64:64:" .. 0.1*64 .. ":" .. 0.9*64 .. ":" .. 0.1*64 .. ":" .. 0.9*64 .. "|t"
                    
                    tinsert(cooldownList, currentIndex, {type = "label", get = function() return iconString .. " " .. spenName end})
                    if (currentIndex > 1) then
                        tinsert(cooldownList, currentIndex, {type = "blank"})
                    end
                end
            end
        end

        DF:BuildMenu(cooldownSelectionFrame, cooldownList, 5, -5, cooldownSelectionFrame:GetHeight() - 40, false, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)



    end

    _G.DetailsPluginContainerWindow.OpenPlugin(_G.DetailsCDTrackerWindow)
    _G.DetailsCDTrackerWindow:Show()
end
