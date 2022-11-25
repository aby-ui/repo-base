

local Details = _G.Details
local DF = _G.DetailsFramework
local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)
local addonName, Details222 = ...

--namespace
Details222.CooldownTracking = {
    cooldownPanels = {},
}

--return truen if the cooldown tracker is enabled
function Details222.CooldownTracking.IsEnabled()
    return Details.ocd_tracker.enabled
end

--return a hash table with all cooldown panels created [filterName] = Frame
function Details222.CooldownTracking.GetAllPanels()
    return Details222.CooldownTracking.cooldownPanels
end

--enable the cooldown tracker
function Details222.CooldownTracking.EnableTracker()
    if (not Details.ocd_tracker.show_options) then
        return
    end

    Details.ocd_tracker.enabled = true

    --register callbacks with the openRaidLib
    openRaidLib.RegisterCallback(Details222.CooldownTracking, "CooldownListUpdate", "OnReceiveUnitFullCooldownList")
    openRaidLib.RegisterCallback(Details222.CooldownTracking, "CooldownUpdate", "OnReceiveSingleCooldownUpdate")
    openRaidLib.RegisterCallback(Details222.CooldownTracking, "CooldownListWipe", "OnCooldownListWipe")
    openRaidLib.RegisterCallback(Details222.CooldownTracking, "CooldownAdded", "OnCooldownAdded")
    openRaidLib.RegisterCallback(Details222.CooldownTracking, "CooldownRemoved", "OnCooldownRemoved")

    Details222.CooldownTracking.RefreshCooldownFrames()
end

--disable the cooldown tracker
function Details222.CooldownTracking.DisableTracker()
    Details.ocd_tracker.enabled = false

    --hide the panel
    local allPanels = Details222.CooldownTracking.GetAllPanels()
    for filterName, frameObject in pairs(allPanels) do
        frameObject:Hide()
    end

    --unregister callbacks
    openRaidLib.UnregisterCallback(Details222.CooldownTracking, "CooldownListUpdate", "OnReceiveUnitFullCooldownList")
    openRaidLib.UnregisterCallback(Details222.CooldownTracking, "CooldownUpdate", "OnReceiveSingleCooldownUpdate")
    openRaidLib.UnregisterCallback(Details222.CooldownTracking, "CooldownListWipe", "OnCooldownListWipe")
end


--Library Open Raid Callbacks
    --callback on the event 'CooldownListUpdate', this is triggered when a player in the group sent the list of cooldowns
    --@unitId: which unit got updated
    --@unitCooldows: a table with [spellId] = cooldownInfo
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details222.CooldownTracking.OnReceiveUnitFullCooldownList(unitId, unitCooldows, allUnitsCooldowns)
        --print("|cFFFFFF00received full cooldown list|r from:", unitId)
        Details222.CooldownTracking.RefreshCooldownFrames()
    end

    --callback on the event 'CooldownUpdate', this is triggered when a player uses a cooldown or a cooldown got updated (time left reduced, etc)
    --@unitId: which unit got updated
    --@spellId: which cooldown spell got updated
    --@cooldownInfo: cooldown information table to be passed with other functions
    --@unitCooldows: a table with [spellId] = cooldownInfo
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details222.CooldownTracking.OnReceiveSingleCooldownUpdate(unitId, spellId, cooldownInfo, unitCooldows, allUnitsCooldowns)
        --TODO: make a function inside lib open raid to get the filters the cooldown is in
        --I dont known which panel will be used
        --need to get the filter name which that spell belong
        --and then check if that filter is enabled
        local allPanels = Details222.CooldownTracking.GetAllPanels()

        local screenPanel = allPanels["main"] --this should be replaced with the cooldown panel
        local gotUpdated = false
        local unitName = GetUnitName(unitId, true)

        if (screenPanel) then
            local cooldownFrame = screenPanel.playerCache[unitName] and screenPanel.playerCache[unitName][spellId]
            if (cooldownFrame) then
                --get the cooldown time from the lib, it return data ready to use on statusbar
                local isReady, normalizedPercent, timeLeft, charges, minValue, maxValue, currentValue = openRaidLib.GetCooldownStatusFromCooldownInfo(cooldownInfo)
                if (not isReady) then
                    cooldownFrame:SetTimer(currentValue, minValue, maxValue)
                else
                    cooldownFrame:SetTimer()
                end
                gotUpdated = true
            end
        end

        if (not gotUpdated) then
            Details222.CooldownTracking.RefreshCooldownFrames()
        end
    end

    --when the list of cooldowns got wiped, usually happens when the player left a group
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details222.CooldownTracking.OnCooldownListWipe(allUnitsCooldowns)
        Details222.CooldownTracking.RefreshCooldownFrames()
    end

    --when a cooldown has been added to an unit
    function Details222.CooldownTracking.OnCooldownAdded(unitId, spellId, cooldownInfo, unitCooldows, allUnitsCooldowns)
        --here could update the cooldown of the unit, but I'm too lazy so it update all units
        Details222.CooldownTracking.RefreshCooldownFrames()
    end

    --when a cooldown has been removed from an unit
    function Details222.CooldownTracking.OnCooldownRemoved(unitId, spellId, unitCooldows, allUnitsCooldowns)
        Details222.CooldownTracking.RefreshCooldownFrames()
    end


--Frames
    --hide all bars created
    function Details222.CooldownTracking.HideAllBars(filterName)
        filterName = filterName or "main"
        local allPanels = Details222.CooldownTracking.GetAllPanels()
        for _, bar in ipairs(allPanels[filterName].bars) do
            bar:ClearAllPoints()
            bar:Hide()

            bar.cooldownInfo = nil
            bar.spellId = nil
            bar.class = nil
            bar.unitName = nil
        end
    end

    --get a cooldown frame
    function Details222.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, frameId)
        local cooldownFrame = screenPanel.bars[frameId]
        if (cooldownFrame) then
            return cooldownFrame
        end
        local cooldownFrame = DF:CreateTimeBar(screenPanel, [[Interface\AddOns\Details\images\bar_serenity]], Details.ocd_tracker.width-2, Details.ocd_tracker.height-2, 100, nil, screenPanel:GetName() .. "CDFrame" .. frameId)
        tinsert(screenPanel.bars, cooldownFrame)
        cooldownFrame:EnableMouse(false)
        return cooldownFrame
    end

    local eventFrame = CreateFrame("frame")
    eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    eventFrame:SetScript("OnShow", function()
        eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    end)

    eventFrame:SetScript("OnHide", function()
        eventFrame:UnregisterEvent("GROUP_ROSTER_UPDATE")
    end)

    eventFrame:SetScript("OnEvent", function(self, event)
        if (event == "GROUP_ROSTER_UPDATE") then
            if (eventFrame.scheduleRosterUpdate) then
                return
            end
            --eventFrame.scheduleRosterUpdate = C_Timer.NewTimer(1, Details222.CooldownTracking.RefreshCooldownFrames)
        end
    end)

    --create the screen panel, goes into the UIParent and show cooldowns
    function Details222.CooldownTracking.CreateScreenFrame(filterName)
        filterName = filterName or "main"
        local frameName = "DetailsOnlineCDTrackerScreenPanel" .. filterName
        local cooldownPanel = CreateFrame("frame", frameName, UIParent, "BackdropTemplate")
        cooldownPanel:Hide()
        cooldownPanel:SetSize(Details.ocd_tracker.width, Details.ocd_tracker.height)
        cooldownPanel:SetPoint("center", 0, 0)
        DetailsFramework:ApplyStandardBackdrop(cooldownPanel)
        cooldownPanel:EnableMouse(true)

        --register on libwindow
        local libWindow = LibStub("LibWindow-1.1")
        Details.ocd_tracker.frames[filterName] = Details.ocd_tracker.frames[filterName] or {}
        libWindow.RegisterConfig(cooldownPanel, Details.ocd_tracker.frames[filterName])
        libWindow.MakeDraggable(cooldownPanel)
        libWindow.RestorePosition(cooldownPanel)

        cooldownPanel.bars = {}
        cooldownPanel.cooldownCache = Details.ocd_tracker.current_cooldowns
        cooldownPanel.playerCache = {}
        cooldownPanel.statusBarFrameIndex = 1

        local allPanels = Details222.CooldownTracking.GetAllPanels()
        allPanels[filterName] = cooldownPanel

        return cooldownPanel
    end



    function Details222.CooldownTracking.SetupCooldownFrame(cooldownFrame)
        local spellIcon = GetSpellTexture(cooldownFrame.spellId)
        if (spellIcon) then
            cooldownFrame:SetIcon(spellIcon, .1, .9, .1, .9)

            local classColor = C_ClassColor.GetClassColor(cooldownFrame.class)
            cooldownFrame:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            cooldownFrame:SetLeftText(DF:RemoveRealmName(cooldownFrame.unitName))
            cooldownFrame:SetSize(Details.ocd_tracker.width, Details.ocd_tracker.height)
        end
    end

    function Details222.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
        if (unitCooldowns) then
            local unitInfo = openRaidLib.GetUnitInfo(unitId)
            local filterName = false
            if (unitInfo) then
                local allPanels = Details222.CooldownTracking.GetAllPanels()
                local screenPanel = allPanels[filterName or "main"]
                for spellId, cooldownInfo in pairs(unitCooldowns) do
                    --get a bar
                    local cooldownFrame = Details222.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, screenPanel.statusBarFrameIndex)
                    cooldownFrame.cooldownInfo = cooldownInfo
                    local isReady, normalizedPercent, timeLeft, charges, minValue, maxValue, currentValue = openRaidLib.GetCooldownStatusFromCooldownInfo(cooldownInfo)

                    cooldownFrame.spellId = spellId
                    cooldownFrame.class = unitInfo.class
                    cooldownFrame.unitName = unitInfo.nameFull

                    --setup the cooldown in the bar
                    Details222.CooldownTracking.SetupCooldownFrame(cooldownFrame)
                    --add the cooldown into the organized by class table
                    tinsert(cooldownsOrganized[unitInfo.classId], cooldownFrame)
                    --iterate to the next cooldown frame
                    screenPanel.statusBarFrameIndex = screenPanel.statusBarFrameIndex + 1

                    --store the cooldown frame into a cache to get the cooldown frame quicker when a cooldown receives updates
                    screenPanel.playerCache[unitInfo.nameFull] = screenPanel.playerCache[unitInfo.nameFull] or {}
                    screenPanel.playerCache[unitInfo.nameFull][spellId] = cooldownFrame
                end
            end
        end
    end

--update cooldown frames based on the amount of players in the group or raid
    function Details222.CooldownTracking.RefreshCooldownFrames(filterName)
        if (not Details.ocd_tracker.enabled) then
            Details222.CooldownTracking.DisableTracker()
            return
        end

        local allPanels = Details222.CooldownTracking.GetAllPanels()
        local screenPanel = allPanels[filterName or "main"]

        if (not screenPanel) then
            screenPanel = Details222.CooldownTracking.CreateScreenFrame()
        end

        if (Details.ocd_tracker.framme_locked) then
            screenPanel:EnableMouse(false)
        else
            screenPanel:EnableMouse(true)
        end

        Details222.CooldownTracking.HideAllBars()
        screenPanel.scheduleRosterUpdate = nil
        wipe(screenPanel.playerCache)
        screenPanel.statusBarFrameIndex = 1

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
        for classId = 1, 13 do --13 classes
            cooldownsOrganized[classId] = {}
        end

        local numGroupMembers = GetNumGroupMembers()

        local filter = ""
        for filterName, isEnabled in pairs(Details.ocd_tracker.filters) do
            if (isEnabled) then
                filter = filter .. filterName ..  ","
            end
        end

        if (IsInRaid()) then
            for i = 1, numGroupMembers do
                local unitId = "raid"..i
                local unitCooldowns = openRaidLib.GetUnitCooldowns(unitId, filter)
                Details222.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
            end

        elseif (IsInGroup()) then
            for i = 1, numGroupMembers - 1 do
                local unitId = "party"..i
                local unitCooldowns = openRaidLib.GetUnitCooldowns(unitId, filter)
                Details222.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
            end

            --player
            local unitCooldowns = openRaidLib.GetUnitCooldowns("player", filter)
            Details222.CooldownTracking.ProcessUnitCooldowns("player", unitCooldowns, cooldownsOrganized)

        else
            --player
            local unitCooldowns = openRaidLib.GetUnitCooldowns("player", filter)
            Details222.CooldownTracking.ProcessUnitCooldowns("player", unitCooldowns, cooldownsOrganized)
        end

        for classId = 1, 13 do --13 classes
            table.sort(cooldownsOrganized[classId], function(t1, t2) return t1.spellId < t2.spellId end)
        end

        local xPos = 1
        local yPos = 0
        local maxHeight = 0
        local maxWidth = Details.ocd_tracker.width + 2
        local cooldownFrameIndex = 1

        for classId = 1, 13 do
            local cooldownFrameList = cooldownsOrganized[classId]
            for index, cooldownFrame in ipairs(cooldownFrameList) do
                local cooldownInfo = cooldownFrame.cooldownInfo
                local isReady, normalizedPercent, timeLeft, charges, minValue, maxValue, currentValue = openRaidLib.GetCooldownStatusFromCooldownInfo(cooldownInfo)
                --local isReady, normalizedPercent, timeLeft, charges, minValue, maxValue, currentValue = openRaidLib.GetCooldownStatusFromUnitSpellID(cooldownFrame.unitName, cooldownFrame.spellId)

                if (not isReady) then
                    cooldownFrame:SetTimer(currentValue, minValue, maxValue)
                else
                    cooldownFrame:SetTimer()
                end

                --positioning
                if (cooldownFrameIndex % Details.ocd_tracker.lines_per_column == 0) then
                    xPos = xPos + Details.ocd_tracker.width + 2
                    maxWidth = xPos + Details.ocd_tracker.width + 2
                    yPos = 0
                end
                cooldownFrame:SetPoint("topleft", screenPanel, "topleft", xPos, yPos)
                yPos = yPos - Details.ocd_tracker.height - 1
                if (yPos < maxHeight)  then
                    maxHeight = yPos
                end

                cooldownFrameIndex = cooldownFrameIndex + 1
            end
        end

        maxHeight = abs(maxHeight)

        if (maxHeight == 0) then
            screenPanel:Hide()
            return
        end

        screenPanel:SetSize(maxWidth, maxHeight)
        screenPanel:Show()
    end


--Options panel

    --initialize the cooldown options window and embed it to Details! options panel
    function Details:InitializeCDTrackerWindow()
        if (not Details.ocd_tracker.show_options) then
            return
        end
        local DetailsCDTrackerWindow = CreateFrame("frame", "DetailsCDTrackerWindow", UIParent, "BackdropTemplate")
        DetailsCDTrackerWindow:SetSize(700, 480)
        DetailsCDTrackerWindow.Frame = DetailsCDTrackerWindow
        DetailsCDTrackerWindow.__name = "Cooldown Tracker"
        DetailsCDTrackerWindow.real_name = "DETAILS_CDTRACKERWINDOW"
        DetailsCDTrackerWindow.__icon = [[Interface\TUTORIALFRAME\UI-TUTORIALFRAME-SPIRITREZ]]
        DetailsCDTrackerWindow.__iconcoords = {130/512, 256/512, 0, 1}
        DetailsCDTrackerWindow.__iconcolor = "white"
        _G.DetailsPluginContainerWindow.EmbedPlugin(DetailsCDTrackerWindow, DetailsCDTrackerWindow, true)

        function DetailsCDTrackerWindow.RefreshWindow()
            Details222.CooldownTracking.OpenCDTrackerWindow()
        end

        --check if is enabled at startup
        if (Details222.CooldownTracking.IsEnabled()) then
            Details222.CooldownTracking.EnableTracker()
        end

        DetailsCDTrackerWindow:Hide()
    end

    function Details222.CooldownTracking.OpenCDTrackerWindow()
        if (not Details.ocd_tracker.show_options) then
            return
        end

        --check if the window exists, if not create it
        if (not _G.DetailsCDTrackerWindow or not _G.DetailsCDTrackerWindow.Initialized) then
            local f = _G.DetailsCDTrackerWindow or DF:CreateSimplePanel(UIParent, 700, 480, "Details! Online CD Tracker", "DetailsCDTrackerWindow")
            _G.DetailsCDTrackerWindow.Initialized = true
            DF:ApplyStandardBackdrop(f)
            --enabled with a toggle button
            --execute to reset position
            --misc configs
            local options_text_template = DF:GetTemplate("font", "OPTIONS_FONT_TEMPLATE")
            local options_dropdown_template = DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
            local options_switch_template = DF:GetTemplate("switch", "OPTIONS_CHECKBOX_TEMPLATE")
            local options_slider_template = DF:GetTemplate("slider", "OPTIONS_SLIDER_TEMPLATE")
            local options_button_template = DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE")

            local generalOptions = {
                {--enable ocd
                    type = "toggle",
                    get = function() return Details.ocd_tracker.enabled end,
                    set = function(self, fixedparam, value)
                        if (value) then
                            if (not Details.ocd_tracker.show_options) then
                                return
                            end
                            Details222.CooldownTracking.EnableTracker()
                        else
                            Details222.CooldownTracking.DisableTracker()
                        end
                    end,
                    name = "Enable Experimental Cooldown Tracker",
                    desc = "Enable Experimental Cooldown Tracker",
                },

                {--show only in group
                    type = "toggle",
                    get = function() return Details.ocd_tracker.show_conditions.only_in_group end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.show_conditions.only_in_group = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Only in Group",
                    desc = "Only in Group",
                },

                {--show only inside instances
                    type = "toggle",
                    get = function() return Details.ocd_tracker.show_conditions.only_inside_instance end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.show_conditions.only_inside_instance = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Only Inside Instances",
                    desc = "Only Inside Instances",
                },
                {--lock frame
                    type = "toggle",
                    get = function() return Details.ocd_tracker.framme_locked end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.framme_locked = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Lock Frame",
                    desc = "Lock Frame",
                },

                {type = "breakline"},

                {--filter: show raid wide defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-raid"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-raid"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Raid",
                    desc = "Exanple: druid tranquility.",
                },

                {--filter: show target defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-target"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-target"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Target",
                    desc = "Exanple: priest pain suppression.",
                },

                {--filter: show personal defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-personal"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-personal"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Personal",
                    desc = "Exanple: mage ice block.",
                },

                {--filter: show ofensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["ofensive"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["ofensive"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Offensive Cooldowns",
                    desc = "Exanple: priest power infusion.",
                },

                {--filter: show utility cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["utility"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["utility"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Utility Cooldowns",
                    desc = "Exanple: druid roar.",
                },

                {--filter: show interrupt cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["interrupt"] end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.filters["interrupt"] = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Interrupt Cooldowns",
                    desc = "Exanple: rogue kick.",
                },                

                {type = "breakline"},

                {--bar width
                    type = "range",
                    get = function() return Details.ocd_tracker.width end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.width = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    min = 10,
                    max = 200,
                    step = 1,
                    name = "Width",
                    desc = "Width",
                },

                {--bar height
                    type = "range",
                    get = function() return Details.ocd_tracker.height end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.height = value
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    min = 10,
                    max = 200,
                    step = 1,
                    name = "Height",
                    desc = "Height",
                },
                
                {--bar height
                    type = "range",
                    get = function() return Details.ocd_tracker.lines_per_column end,
                    set = function(self, fixedparam, value)
                        Details.ocd_tracker.lines_per_column = floor(value)
                        Details222.CooldownTracking.RefreshCooldownFrames()
                    end,
                    min = 1,
                    max = 30,
                    step = 1,
                    name = "Lines Per Column",
                    desc = "Lines Per Column",
                },

            }

            generalOptions.always_boxfirst = true
            DF:BuildMenu(f, generalOptions, 5, -30, 150, false, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

            --cooldown selection
            local cooldownProfile = Details.ocd_tracker.cooldowns

            local cooldownSelectionFrame = CreateFrame("frame", "$parentCooldownSelectionFrame", f, "BackdropTemplate")
            cooldownSelectionFrame:SetPoint("topleft", f, "topleft", 0, -150)
            cooldownSelectionFrame:SetPoint("bottomright", f, "bottomright", 0, 10)
            DF:ApplyStandardBackdrop(cooldownSelectionFrame)

            --lib test test warning texts
            local warning1 = cooldownSelectionFrame:CreateFontString(nil, "overlay", "GameFontNormal", 5)
            warning1:SetPoint("center", f, "center", 0, 0)
            warning1:SetText("A cooldown tracker on Details!?\nWhat's next, a Caw counter for Elwynn Forest?")
            DF:SetFontColor(warning1, "silver")
            DF:SetFontSize(warning1, 14)
            local animationHub = DF:CreateAnimationHub(warning1)
            local anim1 = DF:CreateAnimation(animationHub, "rotation", 1, 0, 35)
            anim1:SetEndDelay(10000000)
            anim1:SetSmoothProgress(1)
            animationHub:Play()
            animationHub:Pause()

            local warning2 = cooldownSelectionFrame:CreateFontString(nil, "overlay", "GameFontNormal", 5)
            warning2:SetJustifyH("left")
            warning2:SetPoint("topleft", f, "topleft", 5, -160)
            DF:SetFontColor(warning2, "lime")
            warning2:SetText("This is a concept of a cooldown tracker using the new library 'Open Raid' which uses comms to update cooldown timers.\nThe code to implement is so small that can fit inside a weakaura\nIf you're a coder, the implementation is on Details/frames/window_cdtracker.lua")
        end

        _G.DetailsPluginContainerWindow.OpenPlugin(_G.DetailsCDTrackerWindow)
        _G.DetailsCDTrackerWindow:Show()
    end
