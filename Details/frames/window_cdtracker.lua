

local Details = _G.Details
local DF = _G.DetailsFramework
local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0", true)

--namespace
Details.CooldownTracking = {}

--return if the cooldown tracker is enabled
function Details.CooldownTracking.IsEnabled()
    return Details.ocd_tracker.enabled
end

--enable the cooldown tracker
function Details.CooldownTracking.EnableTracker()
    Details.ocd_tracker.enabled = true

    --register callbacks with the openRaidLib
    openRaidLib.RegisterCallback(Details.CooldownTracking, "CooldownListUpdate", "OnReceiveUnitFullCooldownList")
    openRaidLib.RegisterCallback(Details.CooldownTracking, "CooldownUpdate", "OnReceiveSingleCooldownUpdate")
    openRaidLib.RegisterCallback(Details.CooldownTracking, "CooldownListWipe", "OnCooldownListWipe")
    openRaidLib.RegisterCallback(Details.CooldownTracking, "CooldownAdded", "OnCooldownAdded")
    openRaidLib.RegisterCallback(Details.CooldownTracking, "CooldownRemoved", "OnCooldownRemoved")

    Details.CooldownTracking.RefreshCooldownFrames()
end

--disable the cooldown tracker
function Details.CooldownTracking.DisableTracker()
    Details.ocd_tracker.enabled = false

    --hide the panel
    if (DetailsOnlineCDTrackerScreenPanel) then
        DetailsOnlineCDTrackerScreenPanel:Hide()
    end

    --unregister callbacks
    openRaidLib.UnregisterCallback(Details.CooldownTracking, "CooldownListUpdate", "OnReceiveUnitFullCooldownList")
    openRaidLib.UnregisterCallback(Details.CooldownTracking, "CooldownUpdate", "OnReceiveSingleCooldownUpdate")
    openRaidLib.UnregisterCallback(Details.CooldownTracking, "CooldownListWipe", "OnCooldownListWipe")
end


--> Library Open Raid Callbacks
    --callback on the event 'CooldownListUpdate', this is triggered when a player in the group sent the list of cooldowns
    --@unitId: which unit got updated
    --@unitCooldows: a table with [spellId] = cooldownInfo
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details.CooldownTracking.OnReceiveUnitFullCooldownList(unitId, unitCooldows, allUnitsCooldowns)
        --print("|cFFFFFF00received full cooldown list|r from:", unitId)
        Details.CooldownTracking.RefreshCooldownFrames()
    end

    --callback on the event 'CooldownUpdate', this is triggered when a player uses a cooldown or a cooldown got updated (time left reduced, etc)
    --@unitId: which unit got updated
    --@spellId: which cooldown spell got updated
    --@cooldownInfo: cooldown information table to be passed with other functions
    --@unitCooldows: a table with [spellId] = cooldownInfo
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details.CooldownTracking.OnReceiveSingleCooldownUpdate(unitId, spellId, cooldownInfo, unitCooldows, allUnitsCooldowns)
        local screenPanel = DetailsOnlineCDTrackerScreenPanel
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
            Details.CooldownTracking.RefreshCooldownFrames()
        end
    end

    --when the list of cooldowns got wiped, usually happens when the player left a group
    --@allUnitsCooldowns: a table containing all units [unitName] = {[spellId] = cooldownInfo}
    function Details.CooldownTracking.OnCooldownListWipe(allUnitsCooldowns)
        Details.CooldownTracking.RefreshCooldownFrames()
    end

    --when a cooldown has been added to an unit
    function Details.CooldownTracking.OnCooldownAdded(unitId, spellId, cooldownInfo, unitCooldows, allUnitsCooldowns)
        --here could update the cooldown of the unit, but I'm too lazy so it update all units
        Details.CooldownTracking.RefreshCooldownFrames()
    end

    --when a cooldown has been removed from an unit
    function Details.CooldownTracking.OnCooldownRemoved(unitId, spellId, unitCooldows, allUnitsCooldowns)
        Details.CooldownTracking.RefreshCooldownFrames()
    end


--> Frames
    --hide all bars created
    function Details.CooldownTracking.HideAllBars()
        for _, bar in ipairs (DetailsOnlineCDTrackerScreenPanel.bars) do
            bar:ClearAllPoints()
            bar:Hide()

            bar.cooldownInfo = nil
            bar.spellId = nil
            bar.class = nil
            bar.unitName = nil
        end
    end

    --get a cooldown frame
    function Details.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, frameId)
        local cooldownFrame = screenPanel.bars[frameId]
        if (cooldownFrame) then
            return cooldownFrame
        end
        local cooldownFrame = DF:CreateTimeBar(screenPanel, [[Interface\AddOns\Details\images\bar_serenity]], Details.ocd_tracker.width-2, Details.ocd_tracker.height-2, 100, nil, screenPanel:GetName() .. "CDFrame" .. frameId)
        tinsert(screenPanel.bars, cooldownFrame)
        cooldownFrame:EnableMouse(false)
        return cooldownFrame
    end

    --create the screen panel, goes into the UIParent and show cooldowns
    function Details.CooldownTracking.CreateScreenFrame()
        DetailsOnlineCDTrackerScreenPanel = CreateFrame("frame", "DetailsOnlineCDTrackerScreenPanel", UIParent, "BackdropTemplate")
        local screenPanel = DetailsOnlineCDTrackerScreenPanel
        screenPanel:Hide()
        screenPanel:SetSize(Details.ocd_tracker.width, Details.ocd_tracker.height)
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
        screenPanel.statusBarFrameIndex = 1

        return screenPanel
    end

    function Details.CooldownTracking.SetupCooldownFrame(cooldownFrame)
        local spellIcon = GetSpellTexture(cooldownFrame.spellId)
        if (spellIcon) then
            cooldownFrame:SetIcon(spellIcon, .1, .9, .1, .9)
            local classColor = C_ClassColor.GetClassColor(cooldownFrame.class)
            cooldownFrame:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
            cooldownFrame:SetLeftText(DF:RemoveRealmName(cooldownFrame.unitName))
            cooldownFrame:SetSize(Details.ocd_tracker.width, Details.ocd_tracker.height)
        end
    end

    function Details.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
        if (unitCooldowns) then
            local unitInfo = openRaidLib.GetUnitInfo(unitId)
            if (unitInfo) then
                local screenPanel = DetailsOnlineCDTrackerScreenPanel
                for spellId, cooldownInfo in pairs(unitCooldowns) do
                    --get a bar
                    local cooldownFrame = Details.CooldownTracking.GetOrCreateNewCooldownFrame(screenPanel, screenPanel.statusBarFrameIndex)
                    cooldownFrame.cooldownInfo = cooldownInfo
                    local isReady, normalizedPercent, timeLeft, charges, minValue, maxValue, currentValue = openRaidLib.GetCooldownStatusFromCooldownInfo(cooldownInfo)

                    cooldownFrame.spellId = spellId
                    cooldownFrame.class = unitInfo.class
                    cooldownFrame.unitName = unitInfo.nameFull

                    --setup the cooldown in the bar
                    Details.CooldownTracking.SetupCooldownFrame(cooldownFrame)
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

--> update cooldown frames based on the amount of players in the group or raid
    function Details.CooldownTracking.RefreshCooldownFrames()
        local screenPanel = DetailsOnlineCDTrackerScreenPanel

        if (not screenPanel) then
            screenPanel = Details.CooldownTracking.CreateScreenFrame()
        end

        if (Details.ocd_tracker.framme_locked) then
            screenPanel:EnableMouse(false)
        else
            screenPanel:EnableMouse(true)
        end

        Details.CooldownTracking.HideAllBars()
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
        for classId = 1, 12 do --12 classes
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
                Details.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
            end

        elseif (IsInGroup()) then
            for i = 1, numGroupMembers - 1 do
                local unitId = "party"..i
                local unitCooldowns = openRaidLib.GetUnitCooldowns(unitId, filter)
                Details.CooldownTracking.ProcessUnitCooldowns(unitId, unitCooldowns, cooldownsOrganized)
            end

            --player
            local unitCooldowns = openRaidLib.GetUnitCooldowns("player", filter)
            Details.CooldownTracking.ProcessUnitCooldowns("player", unitCooldowns, cooldownsOrganized)

        else
            --player
            local unitCooldowns = openRaidLib.GetUnitCooldowns("player", filter)
            Details.CooldownTracking.ProcessUnitCooldowns("player", unitCooldowns, cooldownsOrganized)
        end

        for classId = 1, 12 do --12 classes
            table.sort(cooldownsOrganized[classId], function(t1, t2) return t1.spellId < t2.spellId end)
        end

        local xPos = 1
        local yPos = 0
        local maxHeight = 0
        local maxWidth = Details.ocd_tracker.width + 2
        local cooldownFrameIndex = 1

        for classId = 1, 12 do
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


--> Options panel

    --initialize the cooldown options window and embed it to Details! options panel
    function Details:InitializeCDTrackerWindow()
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
            Details.OpenCDTrackerWindow()
        end

        --check if is enabled at startup
        if (Details.CooldownTracking.IsEnabled()) then
            Details.CooldownTracking.EnableTracker()
        end

        DetailsCDTrackerWindow:Hide()
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
                    name = "Enable Experimental Cooldown Tracker",
                    desc = "Enable Experimental Cooldown Tracker",
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
                {--lock frame
                    type = "toggle",
                    get = function() return Details.ocd_tracker.framme_locked end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.framme_locked = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Lock Frame",
                    desc = "Lock Frame",
                },

                {type = "breakline"},

                {--filter: show raid wide defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-raid"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-raid"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Raid",
                    desc = "Exanple: druid tranquility.",
                },

                {--filter: show target defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-target"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-target"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Target",
                    desc = "Exanple: priest pain suppression.",
                },

                {--filter: show personal defensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["defensive-personal"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["defensive-personal"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Defensive: Personal",
                    desc = "Exanple: mage ice block.",
                },

                {--filter: show ofensive cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["ofensive"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["ofensive"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Offensive Cooldowns",
                    desc = "Exanple: priest power infusion.",
                },

                {--filter: show utility cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["utility"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["utility"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Utility Cooldowns",
                    desc = "Exanple: druid roar.",
                },

                {--filter: show interrupt cooldowns
                    type = "toggle",
                    get = function() return Details.ocd_tracker.filters["interrupt"] end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.filters["interrupt"] = value
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    name = "Interrupt Cooldowns",
                    desc = "Exanple: rogue kick.",
                },                

                {type = "breakline"},

                {--bar width
                    type = "range",
                    get = function() return Details.ocd_tracker.width end,
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.width = value
                        Details.CooldownTracking.RefreshCooldownFrames()
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
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.height = value
                        Details.CooldownTracking.RefreshCooldownFrames()
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
                    set = function (self, fixedparam, value)
                        Details.ocd_tracker.lines_per_column = floor(value)
                        Details.CooldownTracking.RefreshCooldownFrames()
                    end,
                    min = 1,
                    max = 30,
                    step = 1,
                    name = "Lines Per Column",
                    desc = "Lines Per Column",
                },

            }

            DF:BuildMenu(f, generalOptions, 5, -30, 150, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

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
            anim1:SetEndDelay(math.huge)
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
