

local Details = _G.Details
local DF = _G.DetailsFramework

--namespace
Details.CooldownTracking = {}

function Details:InitializeCDTrackerWindow()
    local DetailsCDTrackerWindow = DF:CreateSimplePanel(UIParent, 700, 480, "Details! Online CD Tracker", "DetailsCDTrackerWindow")
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
        Details.CooldownTracking.RefreshScreenPanel()
    end

    DetailsCDTrackerWindow:Hide()
end

function Details.CooldownTracking.IsEnabled()
    return Details.cd_tracker.enabled
end

function Details.CooldownTracking.EnableTracker()
    Details.CooldownTracking.RefreshScreenPanel()
end

function Details.CooldownTracking.DisableTracker()
    --hide the panel
    if (DetailsOnlineCDTrackerScreenPanel) then
        DetailsOnlineCDTrackerScreenPanel:Hide()
    end

    --unregister callbacks
    local libRaidStatus = LibStub("LibRaidStatus-1.0")
    libRaidStatus.UnregisterCallback(Details.CooldownTracking, "CooldownListUpdate", "CooldownListUpdateFunc")
    libRaidStatus.UnregisterCallback(Details.CooldownTracking, "CooldownListWiped", "CooldownListWipedFunc")
    libRaidStatus.UnregisterCallback(Details.CooldownTracking, "CooldownUpdate", "CooldownUpdateFunc")

    --unregister events

end

function Details.CooldownTracking.CooldownListUpdateFunc()

end

function Details.CooldownTracking.CooldownListWipedFunc()

end

function Details.CooldownTracking.CooldownUpdateFunc()

end

function Details.CooldownTracking.RefreshScreenPanel()
    if (not DetailsOnlineCDTrackerScreenPanel) then
        --screen panel (goes into the UIParent and show cooldowns there)
        local screenPanel = CreateFrame("frame", "DetailsOnlineCDTrackerScreenPanel", UIParent)
        screenPanel:Hide()

        --register on libwindow
        local libWindow = LibStub("LibWindow-1.1")
        libWindow.RegisterConfig(screenPanel, _detalhes.cd_tracker.pos)
        libWindow.MakeDraggable(screenPanel)
        libWindow.RestorePosition(screenPanel)
    end

    local screenPanel = _G.DetailsOnlineCDTrackerScreenPanel

    if (Details.cd_tracker.show_conditions.only_in_group) then
        if (not IsInGroup()) then
            screenPanel:Hide()
            return
        end
    end

    if (Details.cd_tracker.show_conditions.only_inside_instance) then
        local isInInstanceType = select(2, GetInstanceInfo())
        if (isInInstanceType ~= "party" and isInInstanceType ~= "raid" and isInInstanceType ~= "scenario" and isInInstanceType ~= "arena") then
            screenPanel:Hide()
            return
        end
    end

    --register callbacks from LibRaidStatus
    local libRaidStatus = LibStub("LibRaidStatus-1.0")
    if (libRaidStatus) then
        libRaidStatus.RegisterCallback(Details.CooldownTracking, "CooldownListUpdate", "CooldownListUpdateFunc")
        libRaidStatus.RegisterCallback(Details.CooldownTracking, "CooldownListWiped", "CooldownListWipedFunc")
        libRaidStatus.RegisterCallback(Details.CooldownTracking, "CooldownUpdate", "CooldownUpdateFunc")
    end

    --parei aqui, precisa pegar a tabela de cooldowns da library e atualizar as statusbars
end

function Details.OpenCDTrackerWindow()

    --check if the window exists, if not create it
    if (not _G.DetailsCDTrackerWindow or not _G.DetailsCDTrackerWindow.Initialized) then
        _G.DetailsCDTrackerWindow.Initialized = true
        local f = _G.DetailsCDTrackerWindow or DF:CreateSimplePanel(UIParent, 700, 480, "Details! Online CD Tracker", "DetailsCDTrackerWindow")

        --enabled with a toggle button
        --execute to reset position
        --misc configs
        local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
        local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
        local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
        local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
        local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

        local generalOptions = {
            {--enable tracking
                type = "toggle",
                get = function() return Details.cd_tracker.enabled end,
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
        }
        DF:BuildMenu(generalOptions, f, 5, -5, 150, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)


        --cooldown selection
        local cooldownProfile = Details.cd_tracker.cds_enabled

        local cooldownSelectionFrame = CreateFrame("frame", "$parentCooldownSelectionFrame", f, "BackdropTemplate")
        cooldownSelectionFrame:SetPoint("topleft", f, "topleft", 0, -150)
        cooldownSelectionFrame:SetPoint("bottomright", f, "bottomright", 0, 10)
        DF:ApplyStandardBackdrop(cooldownSelectionFrame)

        --list of cooldowns to show, each one with a toggle button
        local cooldownList = {}
        if (LIB_RAID_STATUS_COOLDOWNS_BY_SPEC) then
            for specId, cooldownTable in pairs(LIB_RAID_STATUS_COOLDOWNS_BY_SPEC) do
                cooldownList[#cooldownList+1] = {type = "label", get = function() return "" .. specId end}

                for spellId, cooldownType in pairs(cooldownTable) do
                    local spellName, _, spellicon = GetSpellInfo(spellId)

                    if (spellName) then
                        if (cooldownType == 3 or cooldownType == 4) then
                            cooldownList[#cooldownList+1] = {
                                type = "toggle",
                                get = function()
                                        if (cooldownProfile[spellId] == nil) then
                                            if (cooldownType == 3 or cooldownType == 4) then
                                                cooldownProfile[spellId] = true
                                            else
                                                cooldownProfile[spellId] = false
                                            end
                                        end
                                        return cooldownProfile[spellId]
                                end,
                                set = function (self, fixedparam, value)
                                    cooldownProfile[spellId] = value
                                end,
                                name = spellName,
                                desc = spellName,
                                boxfirst = true,
                            }
                        end
                    end
                end

                cooldownList[#cooldownList+1] = {type = "blank"}
            end
        end

        DF:BuildMenu(cooldownSelectionFrame, cooldownList, 5, -5, cooldownSelectionFrame:GetHeight(), false, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)



    end

    _G.DetailsPluginContainerWindow.OpenPlugin(_G.DetailsCDTrackerWindow)
    _G.DetailsCDTrackerWindow:Show()

end
