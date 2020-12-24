if (true) then
    --return
end

--[[
    search '~10' to go directly to tooltips settings

    ~01 - display
    ~02 - skins
    ~03 - bars general
    ~04 - bars texts
    ~05 - title bar
    ~06 - body setings
    ~07 - status bar
    ~08 - plugins
    ~09 - profiles
    ~10 - tooltips
    ~11 - datafeed
    ~12 - wallpaper
    ~13 - automation
    ~14 - raid tools
    ~15 - broadcaster
    ~16 - custom spells
    ~17 - charts data
    ~18 - mythic dungeon
--]]


local Details = _G.Details
local DF = _G.DetailsFramework
local Loc = _G.LibStub("AceLocale-3.0"):GetLocale("Details")
local SharedMedia = _G.LibStub:GetLibrary("LibSharedMedia-3.0")
local LDB = _G.LibStub ("LibDataBroker-1.1", true)
local LDBIcon = LDB and _G.LibStub("LibDBIcon-1.0", true)
local _
local unpack = _G.unpack

local tinsert = _G.tinsert

local startX = 200
local startY = -40
local heightSize = 540
local optionsWidth, optionsHeight = 1100, 650
local mainHeightSize = 800
local presetVersion = 3

--templates
local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

local subSectionTitleTextTemplate = DF:GetTemplate ("font", "ORANGE_FONT_TEMPLATE")

local font_select_icon, font_select_texcoord = [[Interface\AddOns\Details\images\icons]], {472/512, 513/512, 186/512, 230/512}
local texture_select_icon, texture_select_texcoord = [[Interface\AddOns\Details\images\icons]], {472/512, 513/512, 186/512, 230/512}

--store the current instance being edited
local currentInstance

function Details.options.SetCurrentInstance(instance)
    currentInstance = instance
end

function Details.options.SetCurrentInstanceAndRefresh(instance)
    currentInstance = instance
    _G.DetailsOptionsWindow.instance = instance

    --get all the frames created and update the options
    for i = 1, Details.options.maxSectionIds do
        local sectionFrame = Details.options.GetOptionsSection(i)
        if (sectionFrame.RefreshOptions) then
            sectionFrame:RefreshOptions()
        end
    end
end

function Details.options.UpdateAutoHideSettings(instance)
    for contextId, line in ipairs(_G.DetailsOptionsWindowTab13.AutoHideOptions) do --tab13 = automation settings
        line.enabledCheckbox:SetValue(instance.hide_on_context[contextId].enabled)
        line.reverseCheckbox:SetValue(instance.hide_on_context[contextId].inverse)
        line.alphaSlider:SetValue(instance.hide_on_context[contextId].value)
    end
end

function Details.options.RefreshInstances(instance)
    if (instance) then
        Details:InstanceGroupCall(instance, "InstanceRefreshRows")
        instance:InstanceReset()
    else
        Details:InstanceGroupCall(instance, "InstanceRefreshRows")
        Details:InstanceGroupCall(instance, "InstanceReset")
    end
end

function Details.options.GetCurrentInstanceInOptionsPanel()
    return currentInstance
end

local afterUpdate = function(instance)
    _detalhes:SendOptionsModifiedEvent(instance or currentInstance)
end

local isGroupEditing = function()
    return _detalhes.options_group_edit
end

local editInstanceSetting = function(instance, funcName, ...)
    if (Details[funcName]) then
        if (isGroupEditing()) then
            Details:InstanceGroupCall(instance, funcName, ...)
        else
            instance[funcName](instance, ...)
        end
    else
        local keyName =  funcName
        local value1, value2, value3 = ...

        if (value2 == nil) then
            if (isGroupEditing()) then
                Details:InstanceGroupEditSetting(instance, keyName, value1)
            else
                instance[keyName] = value1
            end
        else
            if (value3 == nil) then
                if (isGroupEditing()) then
                    Details:InstanceGroupEditSettingOnTable(instance, keyName, value1, value2)
                else
                    instance[keyName][value1] = value2
                end
            else
                if (isGroupEditing()) then
                    Details:InstanceGroupEditSettingOnTable(instance, keyName, value1, value2, value3)
                else
                    instance[keyName][value1][value2] = value3
                end
            end
        end
    end
end

-- ~01 - display
do
    local buildSection = function(sectionFrame)

        --> abbreviation options
            local icon = [[Interface\COMMON\mini-hourglass]]
            local iconcolor = {1, 1, 1, .5}
            local iconsize = {14, 14}

            local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
                _detalhes.ps_abbreviation = abbreviationtype
                _detalhes:UpdateToKFunctions()
                afterUpdate()
            end

            local abbreviationOptions = {
                {value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = Loc ["STRING_EXAMPLE"] .. ": 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
            }
            local buildAbbreviationMenu = function()
                return abbreviationOptions
            end

        --> number system
            local onSelectNumeralSystem = function (_, _, systemNumber)
                _detalhes:SelectNumericalSystem(systemNumber)
            end

            local asian1K, asian10K, asian1B = DF:GetAsianNumberSymbols()
            local asianNumerals = {value = 2, label = Loc ["STRING_NUMERALSYSTEM_MYRIAD_EASTASIA"], desc = "1" .. asian1K .. " = 1.000 \n1" .. asian10K .. " = 10.000 \n10" .. asian10K .. " = 100.000 \n100" .. asian10K .. " = 1.000.000", onclick = onSelectNumeralSystem, icon = icon, iconcolor = iconcolor, iconsize = iconsize}

            --if region is western it'll be using Korean symbols, set a font on the dropdown so it won't show ?????
            local clientRegion = DF:GetClientRegion()
            if (clientRegion == "western" or clientRegion == "russia") then
                asianNumerals.descfont = DF:GetBestFontForLanguage("koKR")
            end

            local numeralSystems = {
                {value = 1, label = Loc ["STRING_NUMERALSYSTEM_ARABIC_WESTERN"], desc = "1K = 1.000 \n10K = 10.000 \n100K = 100.000 \n1M = 1.000.000", onclick = onSelectNumeralSystem, icon = icon, iconcolor = iconcolor, iconsize = iconsize},
                asianNumerals
            }

            local buildNumeralSystemsMenu = function()
                return numeralSystems
            end

        --> time measure type
            local onSelectTimeType = function (_, _, timetype)
                _detalhes.time_type = timetype
                _detalhes.time_type_original = timetype
                _detalhes:RefreshMainWindow(-1, true)
                afterUpdate()
            end
            local timetypeOptions = {
                --localize-me
                {value = 1, label = "Activity Time", onclick = onSelectTimeType, icon = "Interface\\Icons\\Achievement_Quests_Completed_Daily_08", iconcolor = {1, .9, .9}, texcoord = {0.078125, 0.921875, 0.078125, 0.921875}},
                {value = 2, label = "Effective Time", onclick = onSelectTimeType, icon = "Interface\\Icons\\Achievement_Quests_Completed_08"},
            }
            local buildTimeTypeMenu = function()
                return timetypeOptions
            end

        --> auto erase | erase data
            local onSelectEraseData = function (_, _, eraseType)
                _detalhes.segments_auto_erase = eraseType
                afterUpdate()
            end

            local eraseDataOptions = {
                {value = 1, label = Loc ["STRING_OPTIONS_ED1"], onclick = onSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
                {value = 2, label = Loc ["STRING_OPTIONS_ED2"], onclick = onSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
                {value = 3, label = Loc ["STRING_OPTIONS_ED3"], onclick = onSelectEraseData, icon = [[Interface\Addons\Details\Images\reset_button2]]},
            }
            local buildEraseDataMenu = function()
                return eraseDataOptions
            end

        --> deathlog limit
            local onSelectDeathLogLimit = function(_, _, limitAmount)
                _detalhes:SetDeathLogLimit(limitAmount)
            end
            local DeathLogLimitOptions = {
                {value = 16, label = "16 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
                {value = 32, label = "32 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
                {value = 45, label = "45 Records", onclick = onSelectDeathLogLimit, icon = [[Interface\WorldStateFrame\ColumnIcon-GraveyardDefend0]]},
            }
            local buildDeathLogLimitMenu = function()
                return DeathLogLimitOptions
            end

        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_OPTIONS_GENERAL_ANCHOR"] end, text_template = subSectionTitleTextTemplate},
            {--segments locked
                type = "toggle",
                get = function() return Details.instances_segments_locked end,
                set = function (self, fixedparam, value)
                    Details.instances_segments_locked = value
                end,
                name = Loc ["STRING_OPTIONS_LOCKSEGMENTS"],
                desc = Loc ["STRING_OPTIONS_LOCKSEGMENTS_DESC"],
            },
            {--scroll speed
                type = "range",
                get = function() return _detalhes.scroll_speed end,
                set = function (self, fixedparam, value)
                    _detalhes.scroll_speed = value
                end,
                min = 1,
                max = 3,
                step = 1,
                name = Loc ["STRING_OPTIONS_WHEEL_SPEED"],
                desc = Loc ["STRING_OPTIONS_WHEEL_SPEED_DESC"],
            },
            {--instances amount
                type = "range",
                get = function() return _detalhes.instances_amount end,
                set = function (self, fixedparam, value)
                    _detalhes.instances_amount = value
                end,
                min = 1,
                max = 30,
                step = 1,
                name = Loc ["STRING_OPTIONS_MAXINSTANCES"],
                desc = Loc ["STRING_OPTIONS_MAXINSTANCES_DESC"],
            },
            {--abbreviation type
                type = "select",
                get = function() return _detalhes.ps_abbreviation end,
                values = function()
                    return buildAbbreviationMenu()
                end,
                name = Loc ["STRING_OPTIONS_PS_ABBREVIATE"],
                desc = Loc ["STRING_OPTIONS_PS_ABBREVIATE_DESC"],
            },
            {--number system
                type = "select",
                get = function() return _detalhes.numerical_system end,
                values = function()
                    return buildNumeralSystemsMenu()
                end,
                name = Loc ["STRING_NUMERALSYSTEM"],
                desc = Loc ["STRING_NUMERALSYSTEM_DESC"],
            },
            {--animate bars
                type = "toggle",
                get = function() return _detalhes.use_row_animations end,
                set = function (self, fixedparam, value)
                    _detalhes:SetUseAnimations(value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_ANIMATEBARS"],
                desc = Loc ["STRING_OPTIONS_ANIMATEBARS_DESC"],
            },
            {--update speed
                type = "range",
                get = function() return _detalhes.update_speed end,
                set = function (self, fixedparam, value)
                    _detalhes:SetWindowUpdateSpeed(value)
                    afterUpdate()
                end,
                min = 0.05,
                max = 3,
                step = 0.05,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_WINDOWSPEED"],
                desc = Loc ["STRING_OPTIONS_WINDOWSPEED_DESC"],
            },
            {--time measure
                type = "select",
                get = function() return _detalhes.time_type end,
                values = function()
                    return buildTimeTypeMenu()
                end,
                name = Loc ["STRING_OPTIONS_TIMEMEASURE"],
                desc = Loc ["STRING_OPTIONS_TIMEMEASURE_DESC"],
            },

            {type = "blank"},

            {--auto erase settings | erase data
                type = "select",
                get = function() return _detalhes.segments_auto_erase end,
                values = function()
                    return buildEraseDataMenu()
                end,
                name = Loc ["STRING_OPTIONS_ED"],
                desc = Loc ["STRING_OPTIONS_ED_DESC"],
            },
            {--auto erase trash segments
                type = "toggle",
                get = function() return _detalhes.overall_clear_logout end,
                set = function (self, fixedparam, value)
                    _detalhes:SetOverallResetOptions(nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_CLEANUP"],
                desc = Loc ["STRING_OPTIONS_CLEANUP_DESC"],
            },
            {--auto erase world segments
                type = "toggle",
                get = function() return _detalhes.world_combat_is_trash end,
                set = function (self, fixedparam, value)
                    _detalhes.world_combat_is_trash = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_PERFORMANCE_ERASEWORLD"],
                desc = Loc ["STRING_OPTIONS_PERFORMANCE_ERASEWORLD_DESC"],
            },
            {--erase chart data
                type = "toggle",
                get = function() return _detalhes.clear_graphic end,
                set = function (self, fixedparam, value)
                    _detalhes.clear_graphic = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_ERASECHARTDATA"],
                desc = Loc ["STRING_OPTIONS_ERASECHARTDATA_DESC"],
            },

            {--max segments
                type = "range",
                get = function() return _detalhes.segments_amount end,
                set = function (self, fixedparam, value)
                    _detalhes.segments_amount = value
                    afterUpdate()
                end,
                min = 1,
                max = 30,
                step = 1,
                name = Loc ["STRING_OPTIONS_MAXSEGMENTS"],
                desc = Loc ["STRING_OPTIONS_MAXSEGMENTS_DESC"],
            },

            {--max segments saved
                type = "range",
                get = function() return _detalhes.segments_amount_to_save end,
                set = function (self, fixedparam, value)
                    _detalhes.segments_amount_to_save = value
                    afterUpdate()
                end,
                min = 1,
                max = 30,
                step = 1,
                name = Loc ["STRING_OPTIONS_SEGMENTSSAVE"],
                desc = Loc ["STRING_OPTIONS_SEGMENTSSAVE_DESC"],
            },

            {--battleground remote parser
                type = "toggle",
                get = function() return _detalhes.use_battleground_server_parser end,
                set = function (self, fixedparam, value)
                    _detalhes.use_battleground_server_parser = value
                 end,
                name = Loc ["STRING_OPTIONS_BG_UNIQUE_SEGMENT"],
                desc = Loc ["STRING_OPTIONS_BG_UNIQUE_SEGMENT_DESC"],
            },
            {--battleground show enemies
                type = "toggle",
                get = function() return _detalhes.pvp_as_group end,
                set = function (self, fixedparam, value)
                    _detalhes.pvp_as_group = value
                 end,
                name = Loc ["STRING_OPTIONS_BG_ALL_ALLY"],
                desc = Loc ["STRING_OPTIONS_BG_ALL_ALLY_DESC"],
            },

            {type = "blank"},

            {--pvp frags
                type = "toggle",
                get = function() return _detalhes.only_pvp_frags end,
                set = function (self, fixedparam, value)
                    _detalhes.only_pvp_frags = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_PVPFRAGS"],
                desc = Loc ["STRING_OPTIONS_PVPFRAGS_DESC"],
            },

            {--death log size
                type = "select",
                get = function() return _detalhes.deadlog_events end,
                values = function()
                    return buildDeathLogLimitMenu()
                end,
                name = Loc ["STRING_OPTIONS_DEATHLIMIT"],
                desc = Loc ["STRING_OPTIONS_DEATHLIMIT_DESC"],
            },
            {--death log min healing
                type = "range",
                get = function() return _detalhes.deathlog_healingdone_min end,
                set = function (self, fixedparam, value)
                    _detalhes.deathlog_healingdone_min = value
                    afterUpdate()
                end,
                min = 0,
                max = 100000,
                step = 1,
                name = Loc ["STRING_OPTIONS_DEATHLOG_MINHEALING"],
                desc = Loc ["STRING_OPTIONS_DEATHLOG_MINHEALING_DESC"],
            },

            {--pvp frags
                type = "toggle",
                get = function() return _detalhes.damage_taken_everything end,
                set = function (self, fixedparam, value)
                    _detalhes.damage_taken_everything = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DTAKEN_EVERYTHING"],
                desc = Loc ["STRING_OPTIONS_DTAKEN_EVERYTHING_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_OVERALL_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--erase overall data on new boss
                type = "toggle",
                get = function() return _detalhes.overall_clear_newboss end,
                set = function (self, fixedparam, value)
                    _detalhes:SetOverallResetOptions(value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_OVERALL_NEWBOSS"],
                desc = Loc ["STRING_OPTIONS_OVERALL_NEWBOSS_DESC"],
            },
            {--erase overall data on mythic plus
                type = "toggle",
                get = function() return _detalhes.overall_clear_newchallenge end,
                set = function (self, fixedparam, value)
                    _detalhes:SetOverallResetOptions(nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_OVERALL_MYTHICPLUS"],
                desc = Loc ["STRING_OPTIONS_OVERALL_MYTHICPLUS_DESC"],
            },
            {--erase overall data on logout
                type = "toggle",
                get = function() return _detalhes.overall_clear_logout end,
                set = function (self, fixedparam, value)
                    _detalhes:SetOverallResetOptions(nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_OVERALL_LOGOFF"],
                desc = Loc ["STRING_OPTIONS_OVERALL_LOGOFF_DESC"],
            },

            {type = "blank"},

            {type = "label", get = function() return "Window Control:" end, text_template = DF:GetTemplate("font", "ORANGE_FONT_TEMPLATE")}, --localize-me
            {--lock instance
                type = "execute",
                func = function(self)
                    local instanceLockButton = currentInstance.baseframe.lock_button
                    _detalhes.lock_instance_function(instanceLockButton, "leftclick", true, true)
                end,
                icontexture = [[Interface\PetBattles\PetBattle-LockIcon]],
                icontexcoords = {0.0703125, 0.9453125, 0.0546875, 0.9453125},
                name = Loc ["STRING_OPTIONS_WC_LOCK"],
                desc = Loc ["STRING_OPTIONS_WC_LOCK_DESC"],
            },
            {--ungroup instance
                type = "execute",
                func = function(self)
                    currentInstance:UngroupInstance()
                end,
                icontexture = [[Interface\AddOns\Details\images\icons]],
                icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = Loc ["STRING_OPTIONS_WC_UNSNAP"],
                desc = Loc ["STRING_OPTIONS_WC_UNSNAP_DESC"],
            },
            {--close instance close window
                type = "execute",
                func = function(self)
                    currentInstance:Shutdown()
                end,
                icontexture = [[Interface\Buttons\UI-Panel-MinimizeButton-Up]],
                icontexcoords = {0.143125, 0.8653125, 0.1446875, 0.8653125},
                name = Loc ["STRING_OPTIONS_WC_CLOSE"],
                desc = Loc ["STRING_OPTIONS_WC_CLOSE_DESC"],
            },
            {--create instance
                type = "execute",
                func = function(self)
                    _detalhes:CreateInstance()
                end,
                icontexture = [[Interface\Buttons\UI-AttributeButton-Encourage-Up]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = Loc ["STRING_OPTIONS_WC_CREATE"],
                desc = Loc ["STRING_OPTIONS_WC_CREATE_DESC"],
            },
            {--class colors
                type = "execute",
                func = function(self)
                    _detalhes:OpenClassColorsConfig()
                end,
                icontexture = [[Interface\AddOns\Details\images\icons]],
                icontexcoords = {432/512, 464/512, 276/512, 309/512},
                name = Loc ["STRING_OPTIONS_CHANGE_CLASSCOLORS"],
                desc = Loc ["STRING_OPTIONS_CHANGE_CLASSCOLORS_DESC"],
            },
            {--bookmarks
                type = "execute",
                func = function(self)
                    _detalhes:OpenBookmarkConfig()
                end,
                icontexture = [[Interface\LootFrame\toast-star]],
                icontexcoords = {0.1, .64, 0.1, .69},
                name = Loc ["STRING_OPTIONS_WC_BOOKMARK"],
                desc = Loc ["STRING_OPTIONS_WC_BOOKMARK_DESC"],
            },

            {--click through
                type = "toggle",
                get = function() return currentInstance.clickthrough_window end,
                set = function (self, fixedparam, value)
                    Details:InstanceGroupCall(currentInstance, "UpdateClickThroughSettings", nil, value, value, value)
                    afterUpdate()
                end,
                name = "Click Through",
                desc = "Click Through",
            },
            {--click only in combat
                type = "toggle",
                get = function() return currentInstance.clickthrough_incombatonly end,
                set = function (self, fixedparam, value)
                    Details:InstanceGroupCall(currentInstance, "UpdateClickThroughSettings", value)
                    afterUpdate()
                end,
                name = "Click Through Only in Combat",
                desc = "Click Through Only in Combat",
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_SOCIAL"] end, text_template = subSectionTitleTextTemplate},
            {--nickname
                type = "textentry",
                get = function() return _detalhes:GetNickname(_G.UnitName("player"), _G.UnitName("player"), true) or "" end,
                func = function(self, _, text)
                    local accepted, errortext = _detalhes:SetNickname(text)
                    if (not accepted) then
                        Details:ResetPlayerPersona()
                        Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    end
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_NICKNAME"],
                desc = Loc ["STRING_OPTIONS_NICKNAME"],
            },
            {--remove nickname
                type = "execute",
                func = function(self)
                    Details:ResetPlayerPersona()
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                end,
                icontexture = [[Interface\GLUES\LOGIN\Glues-CheckBox-Check]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = "Reset Nickname",
                desc = "Reset Nickname",
            },
            {--ignore nicknames
                type = "toggle",
                get = function() return _detalhes.ignore_nicktag end,
                set = function (self, fixedparam, value)
                    _detalhes.ignore_nicktag = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_IGNORENICKNAME"],
                desc = Loc ["STRING_OPTIONS_IGNORENICKNAME_DESC"],
            },

            {--remove realm name
                type = "toggle",
                get = function() return _detalhes.remove_realm_from_name end,
                set = function (self, fixedparam, value)
                    _detalhes.remove_realm_from_name = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_REALMNAME"],
                desc = Loc ["STRING_OPTIONS_REALMNAME_DESC"],
            },

            {type = "blank"},

            {type = "label", get = function() return "Immersion" end, text_template = subSectionTitleTextTemplate}, --localize-me
            {--show pets when solo
                type = "toggle",
                get = function() return Details.immersion_pets_on_solo_play end,
                set = function (self, fixedparam, value)
                    Details.immersion_pets_on_solo_play = value
                    afterUpdate()
                end,
                name = "Show pets when solo", --localize-me
                desc = "Show pets when solo",
            },

            {--always show players even on stardard mode
                type = "toggle",
                get = function() return _detalhes.all_players_are_group end,
                set = function (self, fixedparam, value)
                    _detalhes.all_players_are_group = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_ALWAYSSHOWPLAYERS"],
                desc = Loc ["STRING_OPTIONS_ALWAYSSHOWPLAYERS_DESC"],
            },

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection) --optionsSection is declared on boot.lua
end

-- ~02 - skins
do
    local buildSection = function(sectionFrame)

            function Details:OptionPanelOnChangeSkin(skinName)
                self:ChangeSkin(skinName)
                if (self._ElvUIEmbed) then
                    local AS, ASL = unpack(_G.AddOnSkins)
                    AS:Embed_Details()
                end
            end

        --> skin selection
            local onSelectSkin = function (_, _, skinName)
                if (isGroupEditing()) then
                    Details:InstanceGroupCall(currentInstance, "OptionPanelOnChangeSkin", skinName)
                else
                    currentInstance:OptionPanelOnChangeSkin(skinName)
                end
                afterUpdate()
            end

            local buildSkinMenu = function()
                local skinOptions = {}
                for skin_name, skin_table in pairs (_detalhes.skins) do
                    local file = skin_table.file:gsub ([[Interface\AddOns\Details\images\skins\]], "")
                    local desc = "Author: |cFFFFFFFF" .. skin_table.author .. "|r\nVersion: |cFFFFFFFF" .. skin_table.version .. "|r\nSite: |cFFFFFFFF" .. skin_table.site .. "|r\n\nDesc: |cFFFFFFFF" .. skin_table.desc .. "|r\n\nFile: |cFFFFFFFF" .. file .. ".tga|r"
                    skinOptions [#skinOptions+1] = {value = skin_name, label = skin_name, onclick = onSelectSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", desc = desc}
                end
                return skinOptions
            end

        --> save skin
            local saveAsSkin = function(skinName, dontSave)
                local fileName = skinName or ""

                if (fileName == "") then
                    return
                end
                
                local savedObject = {
                    version = presetVersion,
                    name = skinName,
                }
                
                for key, value in pairs (currentInstance) do
                    if (_detalhes.instance_defaults[key] ~= nil) then
                        if (type (value) == "table") then
                            savedObject[key] = table_deepcopy(value)
                        else
                            savedObject[key] = value
                        end
                    end
                end
                
                if (not dontSave) then
                    _detalhes.savedStyles[#_detalhes.savedStyles+1] = savedObject
                end

                return savedObject
            end

        --> load skin
		local loadSkin = function(instance, skinObject)
            function Details:LoadSkinFromOptionsPanel(skinObject)
                --set skin preset
                local instance = self
                local skin = skinObject.skin
                instance.skin = ""
                instance:ChangeSkin(skin)

                --overwrite all instance parameters with saved ones
                for key, value in pairs (skinObject) do
                    if (key ~= "skin" and not _detalhes.instance_skin_ignored_values[key]) then
                        if (type (value) == "table") then
                            instance[key] = table_deepcopy (value)
                        else
                            instance[key] = value
                        end
                    end
                end

                --apply all changed attributes
                instance:ChangeSkin()
            end

            if (isGroupEditing()) then
                Details:InstanceGroupCall(instance, "LoadSkinFromOptionsPanel", skinObject)
            else
                instance:LoadSkinFromOptionsPanel(skinObject)
            end
        end

        --> import skin string
            local importSaved = function()
                --when clicking in the okay button in the import window, it send the text in the first argument
                _detalhes:ShowImportWindow("", function (skinString)
                    if (type (skinString) ~= "string" or string.len(skinString) < 2) then
                        return
                    end

                    skinString = DF:Trim(skinString)

                    local dataTable = Details:DecompressData (skinString, "print")
                    if (dataTable) then
                        --add the new skin
                        _detalhes.savedStyles [#_detalhes.savedStyles+1] = dataTable
                        _detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_IMPORT_OKEY"])
                        Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                        afterUpdate()
                    else
                        Details:Msg (Loc ["STRING_CUSTOM_IMPORT_ERROR"])
                    end
                
                end, "Details! Import Skin (paste string)") --localize-me
            end

        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_OPTIONS_SKIN_SELECT_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--skin selection
                type = "select",
                get = function() return currentInstance.skin end,
                values = function()
                    return buildSkinMenu()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_SKIN"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_SKIN_DESC"],
            },

            {--custom skin file
                type = "textentry",
                get = function() return currentInstance.skin_custom or "" end,
                func = function(self, _, text)
                    local fileName = text or ""
                    Details:InstanceGroupCall(currentInstance, "SetUserCustomSkinFile", fileName)
                    afterUpdate()
                end,
                name = Loc ["STRING_CUSTOM_SKIN_TEXTURE"],
                desc = Loc ["STRING_CUSTOM_SKIN_TEXTURE_DESC"],
            },

            {--remove custom skin file
                type = "execute",
                func = function(self)
                    Details:InstanceGroupCall(currentInstance, "SetUserCustomSkinFile", "")
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                end,
                icontexture = [[Interface\GLUES\LOGIN\Glues-CheckBox-Check]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = "Reset Custom Skin",
                desc = "Reset Custom Skin",
            },

            {--save as skin
                type = "textentry",
                get = function() return "" end,
                set = function(self, _, text)
                    saveAsSkin(text)
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    _detalhes:Msg(Loc ["STRING_OPTIONS_SAVELOAD_SKINCREATED"])
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_SAVELOAD_SAVE"],
                desc = Loc ["STRING_OPTIONS_SAVELOAD_CREATE_DESC"],
            },

            {--apply to all
                type = "execute",
                func = function(self)
                    local tempPreset = saveAsSkin("temp", true)

                    for instanceId, instance in _detalhes:ListInstances() do
                        if (instance ~= currentInstance) then
                            if (not instance:IsStarted()) then
                                instance:RestoreWindow()
                                loadSkin(instance, tempPreset)
                                instance:Shutdown()
                            else
                                loadSkin(instance, tempPreset)
                                afterUpdate(instance)
                            end
                        end
                    end
                    
                    _detalhes:Msg (Loc ["STRING_OPTIONS_SAVELOAD_APPLYALL"])
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                end,
                icontexture = [[Interface\Buttons\UI-HomeButton]],
                icontexcoords = {1/16, 14/16, 0, 1},
                name = Loc ["STRING_OPTIONS_SAVELOAD_APPLYTOALL"],
                desc = Loc ["STRING_OPTIONS_SAVELOAD_APPLYALL_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_SKIN_PRESETS_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--apply custom skin
                type = "select",
                get = function()
                    return 0
                end,
                values = function()
                    local loadtable = {}
                    for index, _table in ipairs (_detalhes.savedStyles) do
                        tinsert (loadtable, {value = index, label = _table.name, onclick = function() loadSkin(currentInstance, _table) end,
                        icon = "Interface\\GossipFrame\\TabardGossipIcon", iconcolor = {.7, .7, .5, 1}})
                    end
                    return loadtable
                end,
                name = Loc ["STRING_OPTIONS_SKIN_SELECT"],
                desc = Loc ["STRING_OPTIONS_SKIN_SELECT"],
            },

            {--erase custom skin
                type = "select",
                get = function()
                    return 0
                end,
                values = function()
                    local loadtable = {}
                    for index, _table in ipairs (_detalhes.savedStyles) do
                        tinsert (loadtable, {value = index, label = _table.name, onclick = function(_, _, index)
                            table.remove (_detalhes.savedStyles, index)
                            Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                            afterUpdate()
                            _detalhes:Msg(Loc ["STRING_OPTIONS_SKIN_REMOVED"])
                        end,
                        icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}})
                    end
                    return loadtable
                end,
                name = Loc ["STRING_OPTIONS_SAVELOAD_REMOVE"],
                desc = Loc ["STRING_OPTIONS_SAVELOAD_REMOVE"],
            },

            {--export custom skin
                type = "select",
                get = function()
                    return 0
                end,
                values = function()
                    local loadtable = {}
                    for index, _table in ipairs (_detalhes.savedStyles) do
                        tinsert (loadtable, {value = index, label = _table.name, onclick = function(_, _, index)
                            local compressedData = Details:CompressData(_detalhes.savedStyles[index], "print")
                            if (compressedData) then
                                _detalhes:ShowImportWindow(compressedData, nil, "Details! Export Skin")
                            else
                                Details:Msg ("failed to export skin.") --localize-me
                            end
                            Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                            afterUpdate()
                        end,
                        icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}, texcoord = {1, 0, 0, 1}})
                    end
                    return loadtable
                end,
                name = Loc ["STRING_OPTIONS_SAVELOAD_EXPORT"],
                desc = Loc ["STRING_OPTIONS_SAVELOAD_EXPORT_DESC"],
            },

            {--import custom skin string
                type = "execute",
                func = function(self)
                    importSaved()
                end,
                icontexture = [[Interface\Buttons\UI-GuildButton-MOTD-Up]],
                icontexcoords = {1, 0, 0, 1},
                name = Loc ["STRING_OPTIONS_SAVELOAD_IMPORT"],
                desc = Loc ["STRING_OPTIONS_SAVELOAD_IMPORT_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TABEMB_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--chat tab embed enabled
                type = "toggle",
                get = function() return _detalhes.chat_tab_embed.enabled end,
                set = function (self, fixedparam, value)
                    _detalhes.chat_embed:SetTabSettings(nil, value)
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_TABEMB_ENABLED_DESC"],
            },

            {--tab name
                type = "textentry",
                get = function() return _detalhes.chat_tab_embed.tab_name or "" end,
                func = function(self, _, text)
                    _detalhes.chat_embed:SetTabSettings(text)
                end,
                name = Loc ["STRING_OPTIONS_TABEMB_TABNAME"],
                desc = Loc ["STRING_OPTIONS_TABEMB_TABNAME_DESC"],
            },

            {--single window
                type = "toggle",
                get = function() return _detalhes.chat_tab_embed.single_window end,
                set = function (self, fixedparam, value)
                    _detalhes.chat_embed:SetTabSettings (nil, nil, value)
                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TABEMB_SINGLE"],
                desc = Loc ["STRING_OPTIONS_TABEMB_SINGLE_DESC"],
            },

            {--chat tab width offset
                type = "range",
                get = function() return tonumber (_detalhes.chat_tab_embed.x_offset) end,
                set = function (self, fixedparam, value)
                    _detalhes.chat_tab_embed.x_offset = value
                    if (_detalhes.chat_embed.enabled) then
                        _detalhes.chat_embed:DoEmbed()
                    end
                    afterUpdate()
                end,
                min = -100,
                max = 100,
                step = 1,
                name = "Width Offset", --localize-me
                desc = "Fine tune the size of the window while embeded in the chat.", --localize-me
            },

            {--chat tab height offset
                type = "range",
                get = function() return tonumber (_detalhes.chat_tab_embed.y_offset) end,
                set = function (self, fixedparam, value)
                    _detalhes.chat_tab_embed.y_offset = value
                    if (_detalhes.chat_embed.enabled) then
                        _detalhes.chat_embed:DoEmbed()
                    end
                    afterUpdate()
                end,
                min = -100,
                max = 100,
                step = 1,
                name = "Height Offset", --localize-me
                desc = "Fine tune the size of the window while embeded in the chat.", --localize-me
            },
        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end

-- ~03 - bars general
do

    --bar grow direction
    local set_bar_grow_direction = function (_, instance, value)
        editInstanceSetting(currentInstance, "SetBarGrowDirection", value)
        afterUpdate()
    end
    
    local grow_icon_size = {14, 14}
    local orientation_icon_size = {14, 14}
    
    local grow_options = {
        {value = 1, label = Loc ["STRING_TOP_TO_BOTTOM"], iconsize = orientation_icon_size, onclick = set_bar_grow_direction, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0, 0.7}},
        {value = 2, label = Loc ["STRING_BOTTOM_TO_TOP"], iconsize = orientation_icon_size, onclick = set_bar_grow_direction, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0.7, 0}}
    }
    local growMenu = function()
        return grow_options
    end

    --bar orientation
    local set_bar_orientation = function (_, instance, value)
        editInstanceSetting(currentInstance, "SetBarOrientationDirection", value)
        afterUpdate()
    end
    
    local orientation_options = {
        {value = false, label = Loc ["STRING_LEFT_TO_RIGHT"], iconsize = orientation_icon_size, onclick = set_bar_orientation, icon = [[Interface\CHATFRAME\ChatFrameExpandArrow]]},
        {value = true, label = Loc ["STRING_RIGHT_TO_LEFT"], iconsize = orientation_icon_size, onclick = set_bar_orientation, icon = [[Interface\CHATFRAME\ChatFrameExpandArrow]], texcoord = {1, 0, 0, 1}}
    }
    local orientation_menu = function() 
        return orientation_options
    end

    --sort direction
    local set_bar_sorting = function(_, instance, value)
        editInstanceSetting(currentInstance, "bars_sort_direction", value)
        _detalhes:RefreshMainWindow(-1, true)
        afterUpdate()
    end

    local sorting_options = {
        {value = 1, label = Loc ["STRING_DESCENDING"], iconsize ={14, 14}, onclick = set_bar_sorting, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0, 0.7}},
        {value = 2, label = Loc ["STRING_ASCENDING"], iconsize = {14, 14}, onclick = set_bar_sorting, icon = [[Interface\Calendar\MoreArrow]], texcoord = {0, 1, 0.7, 0}}
    }
    local sorting_menu = function()
        return sorting_options
    end

    --select texture
    local texture_icon = [[Interface\TARGETINGFRAME\UI-PhasingIcon]]
    local texture_icon = [[Interface\AddOns\Details\images\icons]]
    local texture_icon_size = {14, 14}
    local texture_texcoord = {469/512, 505/512, 249/512, 284/512}

    local onSelectTexture = function (_, instance, textureName)
        editInstanceSetting(currentInstance, "SetBarSettings", nil, textureName)
        afterUpdate()
    end

    local buildTextureMenu = function()
        local textures = SharedMedia:HashTable("statusbar")
        local texTable = {}
        for name, texturePath in pairs (textures) do 
            texTable[#texTable+1] = {value = name, label = name, iconsize = texture_icon_size, statusbar = texturePath,  onclick = onSelectTexture, icon = texture_icon, texcoord = texture_texcoord}
        end
        table.sort (texTable, function (t1, t2) return t1.label < t2.label end)
        return texTable
    end

    --select background texture
    local onSelectTextureBackground = function (_, instance, textureName)
        editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, textureName)
        afterUpdate()
    end

    local buildTextureMenu2 = function()
        local textures2 = SharedMedia:HashTable ("statusbar")
        local texTable2 = {}
        for name, texturePath in pairs (textures2) do
            texTable2[#texTable2+1] = {value = name, label = name, iconsize = texture_icon_size, statusbar = texturePath,  onclick = onSelectTextureBackground, icon = texture_icon, texcoord = texture_texcoord}
        end
        table.sort (texTable2, function (t1, t2) return t1.label < t2.label end)
        return texTable2
    end

    --select icon file from dropdown
    local OnSelectIconFileSpec = function (_, _, iconpath)
        editInstanceSetting(currentInstance, "SetBarSpecIconSettings", true, iconpath, true)
        afterUpdate()
    end

    local OnSelectIconFile = function (_, _, iconpath)
        editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, iconpath)
        if (currentInstance.row_info.use_spec_icons) then
            editInstanceSetting(currentInstance, "SetBarSpecIconSettings", false)
        end
        afterUpdate()
    end

    local iconsize = {16, 16}
    local icontexture = [[Interface\WorldStateFrame\ICONS-CLASSES]]
    local iconcoords = {0.25, 0.50, 0, 0.25}
    local list = {
        {value = [[]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE1"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize, iconcolor = {1, 1, 1, .3}},
        {value = [[Interface\AddOns\Details\images\classes_small]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE2"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\spec_icons_normal]], label = "Specialization", onclick = OnSelectIconFileSpec, icon = [[Interface\AddOns\Details\images\icons]], texcoord = {2/512, 32/512, 480/512, 510/512}, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\spec_icons_normal_alpha]], label = "Specialization Alpha", onclick = OnSelectIconFileSpec, icon = [[Interface\AddOns\Details\images\icons]], texcoord = {2/512, 32/512, 480/512, 510/512}, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\classes_small_bw]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE3"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\classes_small_alpha]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE4"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\classes_small_alpha_bw]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE6"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
        {value = [[Interface\AddOns\Details\images\classes]], label = Loc ["STRING_OPTIONS_BAR_ICONFILE5"], onclick = OnSelectIconFile, icon = icontexture, texcoord = iconcoords, iconsize = iconsize},
    }
    local builtIconList = function()
        return list
    end

    local buildSection = function(sectionFrame)
        local sectionOptions = {
            {--line height
                type = "range",
                get = function() return tonumber (currentInstance.row_info.height) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarSettings", value)
                    afterUpdate()
                end,
                min = 10,
                max = 30,
                step = 1,
                name = Loc ["STRING_OPTIONS_BAR_HEIGHT"],
                desc = Loc ["STRING_OPTIONS_BAR_HEIGHT_DESC"],
            },

            {--padding
                type = "range",
                get = function() return tonumber (currentInstance.row_info.space.between) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                min = -2,
                max = 10,
                step = 1,
                name = Loc ["STRING_OPTIONS_BAR_SPACING"],
                desc = Loc ["STRING_OPTIONS_BAR_SPACING_DESC"],
            },            

            {--disable highlight
                type = "toggle",
                get = function() return _detalhes.instances_disable_bar_highlight end,
                set = function (self, fixedparam, value)
                    _detalhes.instances_disable_bar_highlight = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_BARHIGHLIGHT"],
                desc = Loc ["STRING_OPTIONS_DISABLE_BARHIGHLIGHT_DESC"],
            },

            {--fast dps updates
                type = "toggle",
                get = function() return currentInstance.row_info.fast_ps_update end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "row_info", "fast_ps_update", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BARUR_ANCHOR"],
                desc = Loc ["STRING_OPTIONS_BARUR_DESC"],
            },

            {--always show me
                type = "toggle",
                get = function() return currentInstance.following.enabled end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "following", "enabled", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BAR_FOLLOWING"],
                desc = Loc ["STRING_OPTIONS_BAR_FOLLOWING_DESC"],
            },

            {--grow direction
                type = "select",
                get = function() return currentInstance.bars_grow_direction end,
                values = function()
                    return growMenu()
                end,
                name = Loc ["STRING_OPTIONS_BAR_GROW"],
                desc = Loc ["STRING_OPTIONS_BAR_GROW_DESC"],
            },

            {--bar orientation
                type = "select",
                get = function() return currentInstance.bars_inverted and 2 or 1 end,
                values = function()
                    return orientation_menu()
                end,
                name = Loc ["STRING_OPTIONS_BARORIENTATION"],
                desc = Loc ["STRING_OPTIONS_BARORIENTATION_DESC"],
            },

            {--bar sort direction
                type = "select",
                get = function() return currentInstance.bars_sort_direction end,
                values = function()
                    return sorting_menu()
                end,
                name = Loc ["STRING_OPTIONS_BARSORT"],
                desc = Loc ["STRING_OPTIONS_BARSORT_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TEXT_TEXTUREU_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--select texture
                type = "select",
                get = function() return currentInstance.row_info.texture end,
                values = function()
                    return buildTextureMenu()
                end,
                name = Loc ["STRING_TEXTURE"],
                desc = Loc ["STRING_OPTIONS_BAR_TEXTURE_DESC"],
            },

            {--custom texture
                type = "textentry",
                get = function() return currentInstance.row_info.texture_custom end,
                func = function(self, _, text)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, text)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BARS_CUSTOM_TEXTURE"],
                desc = Loc ["STRING_OPTIONS_BARS_CUSTOM_TEXTURE_DESC"],
            },

            {--remove custom texture
                type = "execute",
                func = function(self)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, "")
                    afterUpdate()
                end,
                icontexture = [[Interface\Buttons\UI-GroupLoot-Pass-Down]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = "Remove Custom Texture", --localize-me
                desc = "Remove Custom Texture",
            },

			{--bar color
				type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.row_info.fixed_texture_color)
                    local alpha = currentInstance.row_info.alpha
                    return {r, g, b, a}
				end,
				set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, {r, g, b})
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, a)
                    afterUpdate()
				end,
				name = Loc ["STRING_COLOR"],
				desc = Loc ["STRING_OPTIONS_BAR_COLOR_DESC"],
            },

            {--use class colors
                type = "toggle",
                get = function() return currentInstance.row_info.texture_class_colors end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"],
                desc = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TEXT_TEXTUREL_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--select background texture
                type = "select",
                get = function() return currentInstance.row_info.texture_background end,
                values = function()
                    return buildTextureMenu2()
                end,
                name = Loc ["STRING_TEXTURE"],
                desc = Loc ["STRING_OPTIONS_BAR_BTEXTURE_DESC"],
            },

			{--background color
                type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.row_info.fixed_texture_background_color)
                    local alpha = currentInstance.row_info.alpha
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, {r, g, b, a})
                    afterUpdate()
                end,
                name = Loc ["STRING_COLOR"],
                desc = Loc ["STRING_OPTIONS_BAR_COLOR_DESC"],
            },

            {--background uses class colors
                type = "toggle",
                get = function() return currentInstance.row_info.texture_background_class_color end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"],
                desc = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TEXT_ROWICONS_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--select icon file
                type = "select",
                get = function(self)
                    local default
                    if (currentInstance.row_info.use_spec_icons) then
                        default = currentInstance.row_info.spec_file
                    else
                        default = currentInstance.row_info.icon_file
                    end
                    return default
                end,
                values = function()
                    return builtIconList()
                end,
                name = Loc ["STRING_TEXTURE"],
                desc = Loc ["STRING_OPTIONS_BAR_ICONFILE_DESC2"],
            },

            {--custom icon path
                type = "textentry",
                get = function()
                    local default
                    if (currentInstance.row_info.use_spec_icons) then
                        default = currentInstance.row_info.spec_file
                    else
                        default = currentInstance.row_info.icon_file
                    end
                    return default
                end,
                func = function(self, _, text)
                    if (text:find ("spec_")) then
                        editInstanceSetting(currentInstance, "SetBarSpecIconSettings", true, text, true)
                    else
                        if (currentInstance.row_info.use_spec_icons) then
                            editInstanceSetting(currentInstance, "SetBarSpecIconSettings", false)
                        end
                        editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, text)
                    end

                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                end,
                name = "Enter the path for a custom icon file",
                desc = "Enter the path for a custom icon file",
            },

            {--bar start at
                type = "toggle",
                get = function() return currentInstance.row_info.start_after_icon end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BARSTART"],
                desc = Loc ["STRING_OPTIONS_BARSTART_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_BAR_BACKDROP_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--border enabled
                type = "toggle",
                get = function() return currentInstance.row_info.backdrop.enabled end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarBackdropSettings", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_BAR_BACKDROP_ENABLED_DESC"],
            },

			{--border color
                type = "color",
                get = function()
                    local r, g, b, a = unpack(currentInstance.row_info.backdrop.color)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarBackdropSettings", nil, nil, {r, g, b, a})
                    afterUpdate()
                end,
                name = Loc ["STRING_COLOR"],
                desc = Loc ["STRING_OPTIONS_BAR_BACKDROP_COLOR_DESC"],
            },

            {--border size
                type = "range",
                get = function() return tonumber (currentInstance.row_info.backdrop.size) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarBackdropSettings", nil, value)
                    afterUpdate()
                end,
                min = 0,
                max = 10,
                step = 1,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_SIZE"],
                desc = Loc ["STRING_OPTIONS_BAR_BACKDROP_SIZE_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return "Inline Text (need better name)" end, text_template = subSectionTitleTextTemplate}, --localize-me

            {--inline text enabled
                type = "toggle",
                get = function() return currentInstance.use_multi_fontstrings end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "use_multi_fontstrings", value)
                    editInstanceSetting(currentInstance, "InstanceRefreshRows")
                    _detalhes:RefreshMainWindow(-1, true)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = "Vertically align texts in the right side as a vertical line.",
            },

            {--lineText2 (left, usuali is the 'done' amount)
                type = "range",
                get = function() return tonumber (currentInstance.fontstrings_text2_anchor) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "fontstrings_text2_anchor", value)
                    editInstanceSetting(currentInstance, "InstanceRefreshRows")
                    afterUpdate()
                end,
                min = 0,
                max = 125,
                step = 1,
                name = "Text 1 Position",
                desc = "Text 1 Position",
            },

            {--lineText3 (in the middle)
                type = "range",
                get = function() return tonumber (currentInstance.fontstrings_text3_anchor) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "fontstrings_text3_anchor", value)
                    editInstanceSetting(currentInstance, "InstanceRefreshRows")
                    afterUpdate()
                end,
                min = 0,
                max = 75,
                step = 1,
                name = "Text 2 Position",
                desc = "Text 2 Position",
            },

            {--lineText4 (closest to the right)
                type = "range",
                get = function() return tonumber (currentInstance.fontstrings_text4_anchor) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "fontstrings_text4_anchor", value)
                    editInstanceSetting(currentInstance, "InstanceRefreshRows")
                    afterUpdate()
                end,
                min = 0,
                max = 50,
                step = 1,
                name = "Text 3 Position",
                desc = "Text 3 Position",
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TOTALBAR_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--enabled
                type = "toggle",
                get = function() return currentInstance.total_bar.enabled end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "total_bar", "enabled", value)
                    afterUpdate()
                    Details.options.RefreshInstances(currentInstance)
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_SHOW_TOTALBAR_DESC"],
            },
            {--only in group
                type = "toggle",
                get = function() return currentInstance.total_bar.only_in_group end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "total_bar", "only_in_group", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP"],
                desc = Loc ["STRING_OPTIONS_SHOW_TOTALBAR_INGROUP_DESC"],
            },
			{--color
                type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.total_bar.color)
                    return {r, g, b, 1}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "total_bar", "color", {r, g, b, 1})
                    afterUpdate()
                end,
                name = Loc ["STRING_COLOR"],
                desc = Loc ["STRING_OPTIONS_SHOW_TOTALBAR_COLOR_DESC"],
            },
        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end

-- ~04 bars texts
do

    --> text font selection
        local onSelectFont = function (_, instance, fontName)
            editInstanceSetting(currentInstance, "SetBarTextSettings", nil, fontName)
            afterUpdate()
        end

        local buildFontMenu = function()
            local fontObjects = SharedMedia:HashTable("font")
            local fontTable = {}
            for name, fontPath in pairs (fontObjects) do 
                fontTable[#fontTable+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = onSelectFont, font = fontPath, descfont = name, desc = Loc ["STRING_MUSIC_DETAILS_ROBERTOCARLOS"]}
            end
            table.sort (fontTable, function (t1, t2) return t1.label < t2.label end)
            return fontTable
        end

	--> percent type
        local onSelectPercent = function (_, instance, percentType)
            editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, percentType)
            afterUpdate()
        end
        
        local buildPercentMenu = function()
            local percentTable = {
                {value = 1, label = "Relative to Total", onclick = onSelectPercent, icon = [[Interface\GROUPFRAME\UI-GROUP-MAINTANKICON]]},
                {value = 2, label = "Relative to Top Player", onclick = onSelectPercent, icon = [[Interface\GROUPFRAME\UI-Group-LeaderIcon]]}
            }
            return percentTable
        end

    --> brackets
        local onSelectBracket = function (_, instance, value)
            editInstanceSetting(currentInstance, "SetBarRightTextSettings", nil, nil, nil, value)
            afterUpdate()
		end
		
		local BracketTable = {
			{value = "(", label = "(", onclick = onSelectBracket, icon = ""},
			{value = "{", label = "{", onclick = onSelectBracket, icon = ""},
			{value = "[", label = "[", onclick = onSelectBracket, icon = ""},
			{value = "<", label = "<", onclick = onSelectBracket, icon = ""},
			{value = "NONE", label = "no bracket", onclick = onSelectBracket, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]},
		}
		local buildBracketMenu = function()
			return BracketTable
        end
    
    --> separators
        local onSelectSeparator = function (_, instance, value)
            editInstanceSetting(currentInstance, "SetBarRightTextSettings", nil, nil, nil, nil, value)
            afterUpdate()
		end
		
		local separatorTable = {
			{value = ",", label = ",", onclick = onSelectSeparator, icon = ""},
			{value = ".", label = ".", onclick = onSelectSeparator, icon = ""},
			{value = ";", label = ";", onclick = onSelectSeparator, icon = ""},
			{value = "-", label = "-", onclick = onSelectSeparator, icon = ""},
			{value = "|", label = "|", onclick = onSelectSeparator, icon = ""},
			{value = "/", label = "/", onclick = onSelectSeparator, icon = ""},
			{value = "\\", label = "\\", onclick = onSelectSeparator, icon = ""},
			{value = "~", label = "~", onclick = onSelectSeparator, icon = ""},
			{value = "NONE", label = "no separator", onclick = onSelectSeparator, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]},
		}
		local buildSeparatorMenu = function()
			return separatorTable
		end


    local buildSection = function(sectionFrame)
        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_OPTIONS_GENERAL_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

			{--text color
                type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.row_info.fixed_text_color)
                    return {r, g, b, 1}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, {r, g, b, 1})
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_FIXEDCOLOR"],
                desc = Loc ["STRING_OPTIONS_TEXT_FIXEDCOLOR_DESC"],
            },
            {--text size
                type = "range",
                get = function() return currentInstance.row_info.font_size end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", value)
                    afterUpdate()
                end,
                min = 5,
                max = 32,
                step = 1,
                name = Loc ["STRING_OPTIONS_TEXT_SIZE"],
                desc = Loc ["STRING_OPTIONS_TEXT_SIZE_DESC"],
            },
            {--text font
                type = "select",
                get = function() return currentInstance.row_info.font_face end,
                values = function()
                    return buildFontMenu()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_FONT"],
                desc = Loc ["STRING_OPTIONS_TEXT_FONT_DESC"],
            },
            {--percent type
                type = "select",
                get = function() return currentInstance.row_info.percent_type end,
                values = function()
                    return buildPercentMenu()
                end,
                name = Loc ["STRING_OPTIONS_PERCENT_TYPE"],
                desc = Loc ["STRING_OPTIONS_PERCENT_TYPE_DESC"],
            },
            

            {type = "blank"},
            --left text options
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TEXT_LEFT_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--use class colors
                type = "toggle",
                get = function() return currentInstance.row_info.textL_class_colors end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"],
                desc = Loc ["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"],
            },
            {--outline
                type = "toggle",
                get = function() return currentInstance.row_info.textL_outline end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LOUTILINE"],
                desc = Loc ["STRING_OPTIONS_TEXT_LOUTILINE_DESC"],
            },
            {--outline small
                type = "toggle",
                get = function() return currentInstance.row_info.textL_outline_small end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = "Outline", --localize-me
                desc = "Text Outline",
            },
			{--outline small color
                type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.row_info.textL_outline_small_color)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
                    afterUpdate()
                end,
                name = "Outline Color",
                desc = "Outline Color",
            },
            {--position number
                type = "toggle",
                get = function() return currentInstance.row_info.textL_show_number end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LPOSITION"],
                desc = Loc ["STRING_OPTIONS_TEXT_LPOSITION_DESC"],
            },
            {--translit text
                type = "toggle",
                get = function() return currentInstance.row_info.textL_translit_text end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LTRANSLIT"],
                desc = Loc ["STRING_OPTIONS_TEXT_LTRANSLIT_DESC"],
            },

            {type = "blank"},

            {--custom left text
                type = "toggle",
                get = function() return currentInstance.row_info.textL_enable_custom_text end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM"],
                desc = Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"],
            },
            {--open custom text editor
                type = "execute",
                func = function(self)
                    local callback = function(text)
                        text = text:gsub("||", "|")
                        text = DF:Trim(text)
                        editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, text)
                        afterUpdate()
                    end
                    _G.DetailsWindowOptionsBarTextEditor:Open (currentInstance.row_info.textL_custom_text, callback, _G.DetailsOptionsWindow, _detalhes.instance_defaults.row_info.textL_custom_text)
                end,
                icontexture = [[Interface\GLUES\LOGIN\Glues-CheckBox-Check]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = "Edit Custom Text", --localize-me
                desc = Loc ["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"],
            },

            {type = "breakline"},
            --right text options
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TEXT_RIGHT_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--use class colors
                type = "toggle",
                get = function() return currentInstance.row_info.textR_class_colors end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BAR_COLORBYCLASS"],
                desc = Loc ["STRING_OPTIONS_TEXT_LCLASSCOLOR_DESC"],
            },
            {--outline
                type = "toggle",
                get = function() return currentInstance.row_info.textR_outline end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LOUTILINE"],
                desc = Loc ["STRING_OPTIONS_TEXT_LOUTILINE_DESC"],
            },
            {--outline small
                type = "toggle",
                get = function() return currentInstance.row_info.textR_outline_small end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = "Outline", --localize-me
                desc = "Text Outline",
            },
			{--outline small color
                type = "color",
                get = function()
                    local r, g, b = unpack(currentInstance.row_info.textR_outline_small_color)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, {r, g, b, a})
                    afterUpdate()
                end,
                name = "Outline Color",
                desc = "Outline Color",
            },

            {type = "blank"},

            {--show total
                type = "toggle",
                get = function() return currentInstance.row_info.textR_show_data[1] end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarRightTextSettings", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_SHOW_TOTAL"],
                desc = Loc ["STRING_OPTIONS_TEXT_SHOW_TOTAL_DESC"],
            },
            {--show per second
                type = "toggle",
                get = function() return currentInstance.row_info.textR_show_data[2] end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarRightTextSettings", nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_SHOW_PS"],
                desc = Loc ["STRING_OPTIONS_TEXT_SHOW_PS_DESC"],
            },
            {--show percent
                type = "toggle",
                get = function() return currentInstance.row_info.textR_show_data[3] end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarRightTextSettings", nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_SHOW_PERCENT"],
                desc = Loc ["STRING_OPTIONS_TEXT_SHOW_PERCENT_DESC"],
            },

            {type = "blank"},

            {--separator
                type = "select",
                get = function() return currentInstance.row_info.textR_separator end,
                values = function()
                    return buildSeparatorMenu()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_SHOW_SEPARATOR"],
                desc = Loc ["STRING_OPTIONS_TEXT_SHOW_SEPARATOR_DESC"],
            },
            {--brackets
                type = "select",
                get = function() return currentInstance.row_info.textR_bracket end,
                values = function()
                    return buildBracketMenu()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_SHOW_BRACKET"],
                desc = Loc ["STRING_OPTIONS_TEXT_SHOW_BRACKET_DESC"],
            },

            {type = "blank"},

            {--custom right text
                type = "toggle",
                get = function() return currentInstance.row_info.textR_enable_custom_text end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM"],
                desc = Loc ["STRING_OPTIONS_BARLEFTTEXTCUSTOM_DESC"],
            },
            {--open custom text editor
                type = "execute",
                func = function(self)
                    local callback = function(text)
                        text = text:gsub("||", "|")
                        text = DF:Trim(text)
                        editInstanceSetting(currentInstance, "SetBarTextSettings", nil, nil, nil, nil, nil, nil, nil, nil, text)
                        afterUpdate()
                    end
                    _G.DetailsWindowOptionsBarTextEditor:Open (currentInstance.row_info.textL_custom_text, callback, _G.DetailsOptionsWindow, _detalhes.instance_defaults.row_info.textL_custom_text)
                end,
                icontexture = [[Interface\GLUES\LOGIN\Glues-CheckBox-Check]],
                --icontexcoords = {160/512, 179/512, 142/512, 162/512},
                name = "Edit Custom Text", --localize-me
                desc = Loc ["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"],
            },
        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end

-- ~05 - title bar
do

    local func = function (menu_button)
        editInstanceSetting(currentInstance, "menu_icons", menu_button, not currentInstance.menu_icons[menu_button])
        editInstanceSetting(currentInstance, "ToolbarMenuSetButtons")
        afterUpdate()
    end

    --> menu text face
        local onSelectFont = function (_, _, fontName)
            _detalhes.font_faces.menus = fontName
        end
        
        local buildFontMenu = function()
            local fontObjects = SharedMedia:HashTable ("font")
            local fontTable = {}
            for name, fontPath in pairs (fontObjects) do 
                fontTable[#fontTable+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = onSelectFont, font = fontPath, descfont = name, desc = Loc ["STRING_MUSIC_DETAILS_ROBERTOCARLOS"]}
            end
            table.sort (fontTable, function (t1, t2) return t1.label < t2.label end)
            return fontTable
        end

    --> attribute text font
        local on_select_attribute_font = function (self, instance, fontName)
            editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, fontName)
            afterUpdate()
        end
        
        local build_font_menu = function()
            local fonts = {}
            for name, fontPath in pairs (SharedMedia:HashTable ("font")) do 
                fonts [#fonts+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = on_select_attribute_font, font = fontPath, descfont = name, desc = "Our thoughts strayed constantly\nAnd without boundary\nThe ringing of the division bell had began."}
            end
            table.sort (fonts, function (t1, t2) return t1.label < t2.label end)
            return fonts
        end

    --> icon set menu
        local on_select_icon_set = function(self, instance, texturePath)
            editInstanceSetting(currentInstance, "toolbar_icon_file", texturePath)
            editInstanceSetting(currentInstance, "ChangeSkin")
            afterUpdate()
        end
        
        local buildIconStyleMenu = function()
            local iconMenu = {
                {value = "Interface\\AddOns\\Details\\images\\toolbar_icons", label = "Set 1", icon = "Interface\\AddOns\\Details\\images\\toolbar_icons", texcoord = {0, 0.125, 0, 1}, onclick = on_select_icon_set},
                {value = "Interface\\AddOns\\Details\\images\\toolbar_icons_shadow", label = "Set 2", icon = "Interface\\AddOns\\Details\\images\\toolbar_icons_shadow", texcoord = {0, 0.125, 0, 1}, onclick = on_select_icon_set},
                {value = "Interface\\AddOns\\Details\\images\\toolbar_icons_2", label = "Set 3", icon = "Interface\\AddOns\\Details\\images\\toolbar_icons_2", texcoord = {0, 0.125, 0, 1}, onclick = on_select_icon_set},
                {value = "Interface\\AddOns\\Details\\images\\toolbar_icons_2_shadow", label = "Set 4", icon = "Interface\\AddOns\\Details\\images\\toolbar_icons_2_shadow", texcoord = {0, 0.125, 0, 1}, onclick = on_select_icon_set},
            }
            return iconMenu
        end

    local buttonWidth = 25

    local buildSection = function(sectionFrame)
        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_OPTIONS_ROW_SETTING_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {type = "label", get = function() return Loc ["STRING_OPTIONS_MENU_SHOWBUTTONS"] end, text_template = options_text_template},
            {--button orange gear
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(1)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {0/256, 32/256, 0, 1},
            },

            {--button segments
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(2)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {33/256, 64/256, 0, 1},
            },

            {--button sword
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(3)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {64/256, 96/256, 0, 1},
            },

            {--button report
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(4)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {96/256, 128/256, 0, 1},
            },

            {--button clear
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(5)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {128/256, 160/256, 0, 1},
            },

            {--button clear
                type = "execute",
                get = function() return "" end,
                func = function(self, fixedparam, value)
                    func(6)
                end,
                width = buttonWidth,
                height = 20,
                inline = true,
                name = "",
                --desc = "",
                icontexture = [[Interface\AddOns\Details\images\toolbar_icons]],
                icontexcoords = {160/256, 192/256, 0, 1},
            },

            {--icon set icon style
                type = "select",
                get = function() return currentInstance.toolbar_icon_file end,
                values = function()
                    return buildIconStyleMenu()
                end,
                name = "Icon Set",
                desc = "Icon Set",
            },

            {--title bar icons size
                type = "range",
                get = function() return currentInstance.menu_icons_size end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "ToolbarMenuButtonsSize", value)
                    afterUpdate()
                end,
                min = 0.4,
                max = 1.6,
                step = 0.05,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_SIZE"],
                desc = Loc ["STRING_OPTIONS_MENU_BUTTONSSIZE_DESC"],
            },

            {--title bar icons spacing
                type = "range",
                get = function() return currentInstance.menu_icons.space end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "ToolbarMenuSetButtonsOptions", value)
                    afterUpdate()
                end,
                min = -5,
                max = 10,
                step = 1,
                name = Loc ["STRING_OPTIONS_MENUS_SPACEMENT"],
                desc = Loc ["STRING_OPTIONS_MENUS_SPACEMENT_DESC"],
            },

            {--title bar icons position X
                type = "range",
                get = function() return currentInstance.menu_anchor[1] end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "MenuAnchor", value)
                    afterUpdate()
                end,
                min = -200,
                max = 200,
                step = 1,
                name = Loc ["STRING_OPTIONS_MENU_X"],
                desc = Loc ["STRING_OPTIONS_MENU_X_DESC"],
            },

            {--title bar icons position Y
                type = "range",
                get = function() return currentInstance.menu_anchor[2] end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "MenuAnchor", nil, value)
                    afterUpdate()
                end,
                min = -200,
                max = 200,
                step = 1,
                name = Loc ["STRING_OPTIONS_MENU_Y"],
                desc = Loc ["STRING_OPTIONS_MENU_X_DESC"],
            },

            {--icons desaturated
                type = "toggle",
                get = function() return currentInstance.desaturated_menu end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "DesaturateMenu", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DESATURATE_MENU"],
                desc = Loc ["STRING_OPTIONS_DESATURATE_MENU_DESC"],
            },

            {--hide main icon
                type = "toggle",
                get = function() return currentInstance.hide_icon end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "HideMainIcon", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_HIDE_ICON"],
                desc = Loc ["STRING_OPTIONS_HIDE_ICON_DESC"],
            },

            {--button attach to right
                type = "toggle",
                get = function() return currentInstance.menu_anchor.side == 2 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "LeftMenuAnchorSide", value and 2 or 1)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_ANCHOR"],
                desc = Loc ["STRING_OPTIONS_MENU_ANCHOR_DESC"],
            },

            {--plugins button attach to right
                type = "toggle",
                get = function() return currentInstance.plugins_grow_direction == 2 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "plugins_grow_direction", value and 2 or 1)
                    editInstanceSetting(currentInstance, "ToolbarMenuSetButtons")
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_PICONS_DIRECTION"],
                desc = Loc ["STRING_OPTIONS_PICONS_DIRECTION_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_LEFT_MENU_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--menu text size
                type = "range",
                get = function() return Details.font_sizes.menus end,
                set = function (self, fixedparam, value)
                    Details.font_sizes.menus = value
                    afterUpdate()
                end,
                min = 5,
                max = 32,
                step = 1,
                name = Loc ["STRING_OPTIONS_TEXT_SIZE"],
                desc = Loc ["STRING_OPTIONS_MENU_FONT_SIZE_DESC"],
            },

            {--menu text font
                type = "select",
                get = function() return Details.font_faces.menus end,
                values = function()
                    return buildFontMenu()
                end,
                name = Loc ["STRING_OPTIONS_MENU_FONT_FACE"],
                desc = Loc ["STRING_OPTIONS_MENU_FONT_FACE_DESC"],
            },

            {--disable reset button
                type = "toggle",
                get = function() return _detalhes.disable_reset_button end,
                set = function (self, fixedparam, value)
                    _detalhes.disable_reset_button = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_RESET"],
                desc = Loc ["STRING_OPTIONS_DISABLE_RESET_DESC"],
            },

            {--click to open menus
                type = "toggle",
                get = function() return _detalhes.instances_menu_click_to_open end,
                set = function (self, fixedparam, value)
                    _detalhes.instances_menu_click_to_open = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_CLICK_TO_OPEN_MENUS"],
                desc = Loc ["STRING_OPTIONS_CLICK_TO_OPEN_MENUS_DESC"],
            },

            {--auto hide buttons
                type = "toggle",
                get = function() return currentInstance.auto_hide_menu.left end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetAutoHideMenu", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_AUTOHIDE_LEFT"],
                desc = Loc ["STRING_OPTIONS_MENU_AUTOHIDE_DESC"],
            },

            {--disable all displays
                type = "toggle",
                get = function() return currentInstance.disable_alldisplays_window end,
                set = function (self, fixedparam, value)
                    _detalhes.disable_alldisplays_window = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW"],
                desc = Loc ["STRING_OPTIONS_DISABLE_ALLDISPLAYSWINDOW_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_ATTRIBUTE_TEXT"] end, text_template = subSectionTitleTextTemplate},
            
            {--enable text
                type = "toggle",
                get = function() return currentInstance.attribute_text.enabled end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENABLED_DESC"],
            },

            {--encounter time
                type = "toggle",
                get = function() return currentInstance.attribute_text.show_timer and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ENCOUNTERTIMER_DESC"],
            },

            {--text size
                type = "range",
                get = function() return tonumber(currentInstance.attribute_text.text_size) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                min = 5,
                max = 32,
                step = 1,
                name = Loc ["STRING_OPTIONS_TEXT_SIZE"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTSIZE_DESC"],
            },

            {--text font
                type = "select",
                get = function() return currentInstance.attribute_text.text_face end,
                values = function()
                    return build_font_menu()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_FONT"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_FONT_DESC"],
            },

			{--text color
                type = "color",
                get = function()
                    local r, g, b = unpack (currentInstance.attribute_text.text_color)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, nil, nil, {r, g, b, a})
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_TEXTCOLOR_DESC"],
            },

            {--text shadow
                type = "toggle",
                get = function() return currentInstance.attribute_text.shadow end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, nil, nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LOUTILINE"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SHADOW_DESC"],
            },

            {--text X
                type = "range",
                get = function() return tonumber(currentInstance.attribute_text.anchor[1]) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, value)
                    afterUpdate()
                end,
                min = -30,
                max = 300,
                step = 1,
                name = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORX_DESC"],
            },

            {--text Y
                type = "range",
                get = function() return tonumber(currentInstance.attribute_text.anchor[2]) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, value)
                    afterUpdate()
                end,
                min = -100,
                max = 50,
                step = 1,
                name = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_ANCHORY_DESC"],
            },

            {--anchor to top
                type = "toggle",
                get = function() return currentInstance.attribute_text.side == 1 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "AttributeMenu", nil, nil, nil, nil, nil, nil, value and 1 or 2)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE"],
                desc = Loc ["STRING_OPTIONS_MENU_ATTRIBUTE_SIDE_DESC"],
            },

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end

-- ~06 - body setings
do

    --> frame strata options
        local strata = {
            ["BACKGROUND"] = "Background",
            ["LOW"] = "Low",
            ["MEDIUM"] = "Medium",
            ["HIGH"] = "High",
            ["DIALOG"] = "Dialog"
        }

        local onStrataSelect = function (_, instance, strataName)
            editInstanceSetting(currentInstance, "SetFrameStrata", strataName)
            afterUpdate()
        end

        local strataTable = {
            {value = "BACKGROUND", label = "Background", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Green]], iconcolor = {0, .5, 0, .8}, texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
            {value = "LOW", label = "Low", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Green]] , texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
            {value = "MEDIUM", label = "Medium", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Yellow]] , texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
            {value = "HIGH", label = "High", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Yellow]] , iconcolor = {1, .7, 0, 1}, texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
            {value = "DIALOG", label = "Dialog", onclick = onStrataSelect, icon = [[Interface\Buttons\UI-MicroStream-Red]] , iconcolor = {1, 0, 0, 1},  texcoord = nil}, --Interface\Buttons\UI-MicroStream-Green UI-MicroStream-Red UI-MicroStream-Yellow
        }
        local buildStrataMenu = function() return strataTable end

    --> backdrop texture
        local onBackdropSelect = function (_, instance, backdropName)
            editInstanceSetting(currentInstance, "SetBackdropTexture", backdropName)
            afterUpdate()
        end

        local backdrop_icon_size = {16, 16}
        local backdrop_icon_color = {.6, .6, .6}
        
        local buildBackdropMenu = function()
            local backdropTable = {}
            for name, backdropPath in pairs (SharedMedia:HashTable ("background")) do 
                backdropTable[#backdropTable+1] = {value = name, label = name, onclick = onBackdropSelect, icon = [[Interface\ITEMSOCKETINGFRAME\UI-EMPTYSOCKET]], iconsize = backdrop_icon_size, iconcolor = backdrop_icon_color}
            end
            return backdropTable
        end

    --> instance selector selection
        local onSelectInstance = function() end

        local buildInstanceMenu = function()
            local instanceList = {}
            for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount) do
                local instance = _detalhes.tabela_instancias[index]

                --what the window is showing
                local atributo = instance.atributo
                local sub_atributo = instance.sub_atributo
                
                if (atributo == 5) then --custom
                    local CustomObject = _detalhes.custom [sub_atributo]
                    if (not CustomObject) then
                        instance:ResetAttribute()
                        atributo = instance.atributo
                        sub_atributo = instance.sub_atributo
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
                    else
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. CustomObject.name, onclick = onSelectInstance, icon = CustomObject.icon}
                    end
                else
                    local modo = instance.modo
                    
                    if (modo == 1) then --solo plugin
                        atributo = _detalhes.SoloTables.Mode or 1
                        local SoloInfo = _detalhes.SoloTables.Menu [atributo]
                        if (SoloInfo) then
                            instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. SoloInfo [1], onclick = onSelectInstance, icon = SoloInfo [2]}
                        else
                            instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                        end
                        
                    elseif (modo == 4) then --raid plugin
                        local plugin_name = instance.current_raid_plugin or instance.last_raid_plugin
                        if (plugin_name) then
                            local plugin_object = _detalhes:GetPlugin (plugin_name)
                            if (plugin_object) then
                                instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. plugin_object.__name, onclick = onSelectInstance, icon = plugin_object.__icon}
                            else
                                instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                            end
                        else
                            instanceList [#instanceList+1] = {value = index, label = "#".. index .. " unknown", onclick = onSelectInstance, icon = ""}
                        end
                    else
                        instanceList [#instanceList+1] = {value = index, label = "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], onclick = onSelectInstance, icon = _detalhes.sub_atributos [atributo].icones[sub_atributo] [1], texcoord = _detalhes.sub_atributos [atributo].icones[sub_atributo] [2]}
                    end
                end
            end
            return instanceList
        end


    local buildSection = function(sectionFrame)
        local sectionOptions = {

			{--window color
                type = "color",
                get = function()
                    local r, g, b = unpack (currentInstance.color)
                    return {r, g, b, 1}
                end,

                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "InstanceColor", r, g, b, a, nil, true)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_COLOR"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_COLOR_DESC"],
            },

			{--background color
                type = "color",
                get = function()
                    return {currentInstance.bg_r, currentInstance.bg_g, currentInstance.bg_b, currentInstance.bg_alpha}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "SetBackgroundColor", r, g, b)
                    editInstanceSetting(currentInstance, "SetBackgroundAlpha", a)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_ALPHA2"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_ALPHA2_DESC"],
            },

            {--window scale
                type = "range",
                get = function() return tonumber(currentInstance.window_scale) end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetWindowScale", value, true)
                    afterUpdate()
                end,
                min = 0.65,
                max = 1.5,
                step = 0.02,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_WINDOW_SCALE"],
                desc = Loc ["STRING_OPTIONS_WINDOW_SCALE_DESC"],
            },

            {--show borders
                type = "toggle",
                get = function() return currentInstance.show_sidebars end,
                set = function (self, fixedparam, value)
                    if (value) then
                        editInstanceSetting(currentInstance, "ShowSideBars")
                    else
                        editInstanceSetting(currentInstance, "HideSideBars")
                    end

                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_SHOW_SIDEBARS"],
                desc = Loc ["STRING_OPTIONS_SHOW_SIDEBARS_DESC"],
            },

            {--ignore on mass hide
                type = "toggle",
                get = function() return currentInstance.ignore_mass_showhide end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "ignore_mass_showhide", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE"],
                desc = Loc ["STRING_OPTIONS_WINDOW_IGNOREMASSTOGGLE_DESC"],
            },

            {--frame strata
                type = "select",
                get = function() return strata[currentInstance.strata] or "Low" end,
                values = function()
                    return buildStrataMenu()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_STRATA"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_STRATA_DESC"],
            },

            {--backdrop texture
                type = "select",
                get = function() return currentInstance.backdrop_texture end,
                values = function()
                    return buildBackdropMenu()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_BACKDROP"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_BACKDROP_DESC"],
            },

            {type = "blank"},

            {--disable grouping
                type = "toggle",
                get = function() return _detalhes.disable_window_groups end,
                set = function (self, fixedparam, value)
                    _detalhes.disable_window_groups = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_GROUPS"],
                desc = Loc ["STRING_OPTIONS_DISABLE_GROUPS_DESC"],
            },

            {--disable resize buttons
                type = "toggle",
                get = function() return _detalhes.disable_lock_ungroup_buttons end,
                set = function (self, fixedparam, value)
                    _detalhes.disable_lock_ungroup_buttons = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_LOCK_RESIZE"],
                desc = Loc ["STRING_OPTIONS_DISABLE_LOCK_RESIZE_DESC"],
            },

            {--disable stretch button
                type = "toggle",
                get = function() return _detalhes.disable_stretch_button end,
                set = function (self, fixedparam, value)
                    _detalhes.disable_stretch_button = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DISABLE_STRETCH_BUTTON"],
                desc = Loc ["STRING_OPTIONS_DISABLE_STRETCH_BUTTON_DESC"],
            },

            {type = "blank"},

            {--title bar on top side
                type = "toggle",
                get = function() return currentInstance.toolbar_side == 1 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "ToolbarSide", value and 1 or 2)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TOOLBARSIDE"],
                desc = Loc ["STRING_OPTIONS_TOOLBARSIDE_DESC"],
            },

            {--stretch button always on top
                type = "toggle",
                get = function() return currentInstance.grab_on_top end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "grab_on_top", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_STRETCHTOP"],
                desc = Loc ["STRING_OPTIONS_STRETCHTOP_DESC"],
            },
            
            {--stretch button on top side
                type = "toggle",
                get = function() return currentInstance.stretch_button_side == 1 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "StretchButtonAnchor", value and 1 or 2)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_STRETCH"],
                desc = Loc ["STRING_OPTIONS_STRETCH_DESC"],
            },

            {type = "blank"},

            {--delete window
                type = "select",
                get = function() return 0 end,
                values = function()
                    return buildInstanceMenu()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_DELETE"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_DELETE_DESC"],
            },

            {--delete window
                type = "execute",
                func = function(self)
                    local profileDropdown = sectionFrame.widget_list_by_type.dropdown[3]
                    local selectedWindow = profileDropdown:GetValue()

                    if (selectedWindow) then
                        _detalhes:DeleteInstance(selectedWindow)
                        ReloadUI()
                    end
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_DELETE"],
                --icontexture = [[Interface\Buttons\UI-GuildButton-MOTD-Up]],
                --icontexcoords = {1, 0, 0, 1},
            },
            
        }
        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)

end

-- ~07 - status bar
do
    local buildSection = function(sectionFrame)

    --> update micro displays
        local updateMicroFrames = function()
            local instance = currentInstance
        
            local hideLeftButton = sectionFrame.MicroDisplayLeftDropdown.hideLeftMicroFrameButton
            if (instance.StatusBar ["left"].options.isHidden) then
                hideLeftButton:GetNormalTexture():SetDesaturated (false)
            else
                hideLeftButton:GetNormalTexture():SetDesaturated (true)
            end
            
            local hide_center_button = sectionFrame.MicroDisplayCenterDropdown.HideCenterMicroFrameButton
            if (instance.StatusBar ["center"].options.isHidden) then
                hide_center_button:GetNormalTexture():SetDesaturated (false)
            else
                hide_center_button:GetNormalTexture():SetDesaturated (true)
            end
            
            local hide_right_button = sectionFrame.MicroDisplayRightDropdown.HideRightMicroFrameButton
            if (instance.StatusBar ["right"].options.isHidden) then
                hide_right_button:GetNormalTexture():SetDesaturated (false)
            else
                hide_right_button:GetNormalTexture():SetDesaturated (true)
            end
            
            local left = instance.StatusBar ["left"].__name
            local center = instance.StatusBar ["center"].__name
            local right = instance.StatusBar ["right"].__name
            
            _G[sectionFrame:GetName() .. "MicroDisplayLeftDropdown"].MyObject:Select (left)
            _G[sectionFrame:GetName() .. "MicroDisplayCenterDropdown"].MyObject:Select (center)
            _G[sectionFrame:GetName() .. "MicroDisplayRightDropdown"].MyObject:Select (right)

            if (not instance.show_statusbar and instance.micro_displays_side == 2) then
                sectionFrame.MicroDisplayWarningLabel:Show()
            else
                sectionFrame.MicroDisplayWarningLabel:Hide()
            end
        end

        sectionFrame:GetParent().updateMicroFrames = updateMicroFrames

        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_OPTIONS_INSTANCE_STATUSBAR_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--show statusbar
                type = "toggle",
                get = function() return currentInstance.show_statusbar end,
                set = function (self, fixedparam, value)
                    if (value) then
                        editInstanceSetting(currentInstance, "ShowStatusBar")
                    else
                        editInstanceSetting(currentInstance, "HideStatusBar")
                    end

                    --editInstanceSetting(currentInstance, "BaseFrameSnap") --was causing issues 09/Aug/2020
                    updateMicroFrames()
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_SHOW_STATUSBAR"],
                desc = Loc ["STRING_OPTIONS_SHOW_STATUSBAR_DESC"],
            },

			{--color
                type = "color",
                get = function()
                    local r, g, b = unpack (currentInstance.statusbar_info.overlay)
                    local alpha = currentInstance.statusbar_info.alpha
                    return {r, g, b, alpha}
                end,
                set = function (self, r, g, b, a)
                    editInstanceSetting(currentInstance, "StatusBarColor", r, g, b, a)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_STATUSBARCOLOR_DESC"],
            },

            {--lock micro displays
                type = "toggle",
                get = function() return currentInstance.micro_displays_locked end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "MicroDisplaysLock", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MICRODISPLAY_LOCK"],
                desc = Loc ["STRING_OPTIONS_MICRODISPLAY_LOCK_DESC"],
            },

            {--anchor on top side
                type = "toggle",
                get = function() return currentInstance.micro_displays_side == 1 and true or false end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "MicroDisplaysSide", value and 1 or 2, true)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MICRODISPLAYSSIDE"],
                desc = Loc ["STRING_OPTIONS_MICRODISPLAYSSIDE_DESC"],
            },

        }
        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

        do --> micro displays
            
            --statics texts
            DF:NewLabel (sectionFrame, _, "$parentMicroDisplaysAnchor", "MicroDisplaysAnchor", Loc ["STRING_OPTIONS_MICRODISPLAY_ANCHOR"], "GameFontNormal")
            DF:NewLabel (sectionFrame, _, "$parentMicroDisplayLeftLabel", "MicroDisplayLeftLabel", Loc ["STRING_ANCHOR_LEFT"], "GameFontHighlightLeft")
            DF:NewLabel (sectionFrame, _, "$parentMicroDisplayCenterLabel", "MicroDisplayCenterLabel", Loc ["STRING_CENTER_UPPER"], "GameFontHighlightLeft")
            DF:NewLabel (sectionFrame, _, "$parentMicroDisplayRightLabel", "MicroDisplayRightLabel", Loc ["STRING_ANCHOR_RIGHT"], "GameFontHighlightLeft")
            DF:NewLabel (sectionFrame, _, "$parentMicroDisplayWarningLabel", "MicroDisplayWarningLabel", Loc ["STRING_OPTIONS_MICRODISPLAYS_WARNING"], "GameFontHighlightSmall", 10, "orange")

            --dropdown on select option
            local onMicroDisplaySelect = function (_, _, micro_display)
                local anchor, index = unpack (micro_display)

                if (index == -1) then
                    return _detalhes.StatusBar:SetPlugin (currentInstance, -1, anchor)
                end
                
                local absolute_name = _detalhes.StatusBar.Plugins [index].real_name
                _detalhes.StatusBar:SetPlugin (currentInstance, absolute_name, anchor)
                
                updateMicroFrames() -- in development
                afterUpdate()
            end
            
            --dropdown options
            local buildLeftMicroMenu = function()
                local options = {}
                for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
                    options [#options+1] = {value = {"left", index}, label = _name_and_icon [1], onclick = onMicroDisplaySelect, icon = _name_and_icon [2]}
                end
                return options
            end
            local buildCenterMicroMenu = function()
                local options = {}
                for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
                    options [#options+1] = {value = {"center", index}, label = _name_and_icon [1], onclick = onMicroDisplaySelect, icon = _name_and_icon [2]}
                end
                return options
            end
            local buildRightMicroMenu = function()
                local options = {}
                for index, _name_and_icon in ipairs (_detalhes.StatusBar.Menu) do 
                    options [#options+1] = {value = {"right", index}, label = _name_and_icon [1], onclick = onMicroDisplaySelect, icon = _name_and_icon [2]}
                end
                return options
            end

            local DROPDOWN_WIDTH = 160
            local dropdown_height = 18

            --create dropdowns
            DF:NewDropDown (sectionFrame, _, "$parentMicroDisplayLeftDropdown", "MicroDisplayLeftDropdown", DROPDOWN_WIDTH, dropdown_height, buildLeftMicroMenu, nil, options_dropdown_template)
            DF:NewDropDown (sectionFrame, _, "$parentMicroDisplayCenterDropdown", "MicroDisplayCenterDropdown", DROPDOWN_WIDTH, dropdown_height, buildCenterMicroMenu, nil, options_dropdown_template)
            DF:NewDropDown (sectionFrame, _, "$parentMicroDisplayRightDropdown", "MicroDisplayRightDropdown", DROPDOWN_WIDTH, dropdown_height, buildRightMicroMenu, nil, options_dropdown_template)
            
            sectionFrame.MicroDisplayLeftDropdown:SetPoint ("left", sectionFrame.MicroDisplayLeftLabel, "right", 2)
            sectionFrame.MicroDisplayCenterDropdown:SetPoint ("left", sectionFrame.MicroDisplayCenterLabel, "right", 2)
            sectionFrame.MicroDisplayRightDropdown:SetPoint ("left", sectionFrame.MicroDisplayRightLabel, "right", 2)
            
            sectionFrame.MicroDisplayLeftDropdown.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"]
            sectionFrame.MicroDisplayCenterDropdown.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"]
            sectionFrame.MicroDisplayRightDropdown.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_DROPDOWN_TOOLTIP"]
            

            local hideLeftMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayLeftDropdown, _, "$parenthideLeftMicroFrameButton", "hideLeftMicroFrameButton", 22, 22, function (self, button)
                if (currentInstance.StatusBar ["left"].options.isHidden) then
                    _detalhes.StatusBar:SetPlugin (currentInstance, currentInstance.StatusBar ["left"].real_name, "left")
                else
                    _detalhes.StatusBar:SetPlugin (currentInstance, -1, "left")
                end
                if (currentInstance.StatusBar ["left"].options.isHidden) then
                    self:GetNormalTexture():SetDesaturated (false)
                else
                    self:GetNormalTexture():SetDesaturated (true)
                end
            end)

            hideLeftMicroFrameButton:SetPoint ("left", sectionFrame.MicroDisplayLeftDropdown, "right", 2, 0)
            hideLeftMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
            hideLeftMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
            hideLeftMicroFrameButton:GetNormalTexture():SetDesaturated (true)
            hideLeftMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
            hideLeftMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("ADD")
            end)
            hideLeftMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("BLEND")
            end)

            local HideCenterMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayCenterDropdown, _, "$parentHideCenterMicroFrameButton", "HideCenterMicroFrameButton", 22, 22, function (self)
                if (currentInstance.StatusBar ["center"].options.isHidden) then
                    _detalhes.StatusBar:SetPlugin (currentInstance, currentInstance.StatusBar ["center"].real_name, "center")
                else
                    _detalhes.StatusBar:SetPlugin (currentInstance, -1, "center")
                end
                
                if (currentInstance.StatusBar ["center"].options.isHidden) then
                    self:GetNormalTexture():SetDesaturated (false)
                else
                    self:GetNormalTexture():SetDesaturated (true)
                end
            end)
            HideCenterMicroFrameButton:SetPoint ("left", sectionFrame.MicroDisplayCenterDropdown, "right", 2, 0)
            HideCenterMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
            HideCenterMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
            HideCenterMicroFrameButton:GetNormalTexture():SetDesaturated (true)
            HideCenterMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
            HideCenterMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("ADD")
            end)
            HideCenterMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("BLEND")
            end)
            
            local HideRightMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayRightDropdown, _, "$parentHideRightMicroFrameButton", "HideRightMicroFrameButton", 20, 20, function (self)
                if (currentInstance.StatusBar ["right"].options.isHidden) then
                    _detalhes.StatusBar:SetPlugin (currentInstance, currentInstance.StatusBar ["right"].real_name, "right")
                else
                    _detalhes.StatusBar:SetPlugin (currentInstance, -1, "right")
                end
                if (currentInstance.StatusBar ["right"].options.isHidden) then
                    self:GetNormalTexture():SetDesaturated (false)
                else
                    self:GetNormalTexture():SetDesaturated (true)
                end
            end)
            HideRightMicroFrameButton:SetPoint ("left", sectionFrame.MicroDisplayRightDropdown, "right", 2, 0)
            HideRightMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
            HideRightMicroFrameButton:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
            HideRightMicroFrameButton:GetNormalTexture():SetDesaturated (true)
            HideRightMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_SHOWHIDE_TOOLTIP"]
            HideRightMicroFrameButton:SetHook ("OnEnter", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("ADD")
            end)
            HideRightMicroFrameButton:SetHook ("OnLeave", function (self, capsule)
                self:GetNormalTexture():SetBlendMode("BLEND")
            end)

            local configRightMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayRightDropdown, _, "$parentconfigRightMicroFrameButton", "configRightMicroFrameButton", 18, 18, function (self)
                currentInstance.StatusBar ["right"]:Setup()
                currentInstance.StatusBar ["right"]:Setup()
            end)
            configRightMicroFrameButton:SetPoint ("left", HideRightMicroFrameButton, "right", 1, -1)
            configRightMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
            configRightMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
            configRightMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]
            
            local configCenterMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayCenterDropdown, _, "$parentconfigCenterMicroFrameButton", "configCenterMicroFrameButton", 18, 18, function (self)
                currentInstance.StatusBar ["center"]:Setup()
                currentInstance.StatusBar ["center"]:Setup()
            end)
            configCenterMicroFrameButton:SetPoint ("left", HideCenterMicroFrameButton, "right", 1, -1)
            configCenterMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
            configCenterMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
            configCenterMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]
            
            local configLeftMicroFrameButton = DF:NewButton (sectionFrame.MicroDisplayLeftDropdown, _, "$parentconfigLeftMicroFrameButton", "configLeftMicroFrameButton", 18, 18, function (self)
                currentInstance.StatusBar ["left"]:Setup()
                currentInstance.StatusBar ["left"]:Setup()
            end)
            configLeftMicroFrameButton:SetPoint ("left", hideLeftMicroFrameButton, "right", 1, -1)
            configLeftMicroFrameButton:SetNormalTexture ([[Interface\Buttons\UI-OptionsButton]])
            configLeftMicroFrameButton:SetHighlightTexture ([[Interface\Buttons\UI-OptionsButton]])
            configLeftMicroFrameButton.tooltip = Loc ["STRING_OPTIONS_MICRODISPLAYS_OPTION_TOOLTIP"]

            local x = startX
            local y = startY - 20 - 120

            sectionFrame.MicroDisplaysAnchor:SetPoint(x, y)
            y = y - 20
            sectionFrame.MicroDisplayLeftLabel:SetPoint(x, y)
            y = y - 20
            sectionFrame.MicroDisplayCenterLabel:SetPoint(x, y)
            y = y - 20
            sectionFrame.MicroDisplayRightLabel:SetPoint(x, y)
            y = y - 20
			sectionFrame.MicroDisplayWarningLabel:SetPoint(x, y)
            y = y - 20
        end


    end

    tinsert(Details.optionsSection, buildSection)

end


-- ~08 - plugins
do
    local buildSection = function(sectionFrame)

        local CreateFrame = _G.CreateFrame
        local button_color_rgb = {1, 0.93, 0.74}

        local anchorFrame = CreateFrame("frame", "$parentAnchorFrame", sectionFrame)
        anchorFrame:SetPoint("topleft", sectionFrame, "topleft", startX - 10, startY)
        anchorFrame.plugin_widgets = {}
        anchorFrame:SetSize(1, 1)
        
        local on_enter = function (self)
        
            self:SetBackdropColor (.5, .5, .5, .8)
            
            if (self ["toolbarPluginsIcon" .. self.id]) then
                self ["toolbarPluginsIcon" .. self.id]:SetBlendMode ("ADD")
            elseif (self ["raidPluginsIcon" .. self.id]) then
                self ["raidPluginsIcon" .. self.id]:SetBlendMode ("ADD")
            elseif (self ["soloPluginsIcon" .. self.id]) then
                self ["soloPluginsIcon" .. self.id]:SetBlendMode ("ADD")
            end
    
            if (self.plugin) then
                local desc = self.plugin:GetPluginDescription()
                if (desc) then
                    GameCooltip:Preset (2)
                    GameCooltip:AddLine (desc)
                    GameCooltip:SetType ("tooltip")
                    GameCooltip:SetOwner (self, "bottomleft", "topleft", 150, -2)
                    GameCooltip:Show()
                end
            end
    
            if (self.hasDesc) then
                GameCooltip:Preset (2)
                GameCooltip:AddLine (self.hasDesc)
                GameCooltip:SetType ("tooltip")
                GameCooltip:SetOwner (self, "bottomleft", "topleft", 150, -2)
                GameCooltip:Show()
            end
        end
        
        local on_leave = function (self)
            self:SetBackdropColor (.3, .3, .3, .3)
            
            if (self ["toolbarPluginsIcon" .. self.id]) then
                self ["toolbarPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
            elseif (self ["raidPluginsIcon" .. self.id]) then
                self ["raidPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
            elseif (self ["soloPluginsIcon" .. self.id]) then
                self ["soloPluginsIcon" .. self.id]:SetBlendMode ("BLEND")
            end
    
            GameCooltip:Hide()
        end
        
        local y = -20
        
        --> toolbar
        DF:NewLabel (anchorFrame, _, "$parentToolbarPluginsLabel", "toolbarLabel", Loc ["STRING_OPTIONS_PLUGINS_TOOLBAR_ANCHOR"], "GameFontNormal", 16)
        anchorFrame.toolbarLabel:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
        y = y - 30
        
        do
            local descbar = anchorFrame:CreateTexture (nil, "artwork")
            descbar:SetTexture (.3, .3, .3, .8)
            descbar:SetPoint ("topleft", anchorFrame, "topleft", 5, y+3)
            descbar:SetSize (650, 20)
            DF:NewLabel (anchorFrame, _, "$parentDescNameLabel", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
            anchorFrame.descNameLabel:SetPoint ("topleft", anchorFrame, "topleft", 15, y)
            DF:NewLabel (anchorFrame, _, "$parentDescAuthorLabel", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
            anchorFrame.descAuthorLabel:SetPoint ("topleft", anchorFrame, "topleft", 180, y)
            DF:NewLabel (anchorFrame, _, "$parentDescVersionLabel", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
            anchorFrame.descVersionLabel:SetPoint ("topleft", anchorFrame, "topleft", 290, y)
            DF:NewLabel (anchorFrame, _, "$parentDescEnabledLabel", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
            anchorFrame.descEnabledLabel:SetPoint ("topleft", anchorFrame, "topleft", 400, y)
            DF:NewLabel (anchorFrame, _, "$parentDescOptionsLabel", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
            anchorFrame.descOptionsLabel:SetPoint ("topleft", anchorFrame, "topleft", 510, y)
        end
        
        y = y - 30
        
        --> toolbar plugins loop
        local i = 1
        local allplugins_toolbar = _detalhes.ToolBar.NameTable --where is store all plugins for the title bar
    
        --first loop and see which plugins isn't installed
        --then add a 'ghost' plugin so the player can download
    
        local allExistentToolbarPlugins = {
            {"DETAILS_PLUGIN_CHART_VIEWER", "Details_ChartViewer", "Chart Viewer", "View combat data in handsome charts.", "https://www.curseforge.com/wow/addons/details-chart-viewer-plugin"},
            {"DETAILS_PLUGIN_DEATH_GRAPHICS", "Details_DeathGraphs", "Advanced Death Logs", "Encounter endurance per player (who's dying more), deaths timeline by enemy spells and regular death logs.", "https://www.curseforge.com/wow/addons/details-advanced-death-logs-plug"},
            --{"Details_RaidPowerBars", "Raid Power Bars", "Alternate power bar in a details! window", "https://www.curseforge.com/wow/addons/details_raidpowerbars/"},
            --{"Details_TargetCaller", "Target Caller", "Show raid damage done to an entity since you targetted it.", "https://www.curseforge.com/wow/addons/details-target-caller-plugin"},
            {"DETAILS_PLUGIN_TIME_LINE", "Details_TimeLine", "Time Line", "View raid cooldowns usage, debuff gain, boss casts in a fancy time line.", "https://www.curseforge.com/wow/addons/details_timeline"},
        }
    
        local allExistentRaidPlugins = {
            --{"DETAILS_PLUGIN_CHART_VIEWER", "Details_ChartViewer", "Chart Viewer", "View combat data in handsome charts.", "https://www.curseforge.com/wow/addons/details-chart-viewer-plugin"},
            --{"DETAILS_PLUGIN_DEATH_GRAPHICS", "Details_DeathGraphs", "Advanced Death Logs", "Encounter endurance per player (who's dying more), deaths timeline by enemy spells and regular death logs.", "https://www.curseforge.com/wow/addons/details-advanced-death-logs-plug"},
            {"DETAILS_PLUGIN_RAID_POWER_BARS", "Details_RaidPowerBars", "Raid Power Bars", "Alternate power bar in a details! window", "https://www.curseforge.com/wow/addons/details_raidpowerbars/"},
            {"DETAILS_PLUGIN_TARGET_CALLER", "Details_TargetCaller", "Target Caller", "Show raid damage done to an entity since you targetted it.", "https://www.curseforge.com/wow/addons/details-target-caller-plugin"},
            --{"DETAILS_PLUGIN_TIME_LINE", "Details_TimeLine", "Time Line", "View raid cooldowns usage, debuff gain, boss casts in a fancy time line.", "https://www.curseforge.com/wow/addons/details_timeline"},
        }
    
        local installedToolbarPlugins = {}
        local installedRaidPlugins = {}
    
        for absName, pluginObject in pairs (allplugins_toolbar) do
        
            local bframe = CreateFrame("frame", "OptionsPluginToolbarBG", anchorFrame, "BackdropTemplate")
            bframe:SetSize (640, 20)
            bframe:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
            bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
            bframe:SetBackdropColor (.3, .3, .3, .3)
            bframe:SetScript ("OnEnter", on_enter)
            bframe:SetScript ("OnLeave", on_leave)
            bframe.plugin = pluginObject
            bframe.id = i
            
            DF:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
            bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
            DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
            bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
            
            DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
            bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", anchorFrame, "topleft", 180, y-4)
            
            DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
            bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", anchorFrame, "topleft", 290, y-4)
            
            local plugin_stable = _detalhes:GetPluginSavedTable (absName)
            local plugin = _detalhes:GetPlugin (absName)
            DF:NewSwitch (bframe, _, "$parentToolbarSlider"..i, "toolbarPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
            bframe ["toolbarPluginsSlider"..i].PluginName = absName
            tinsert (anchorFrame.plugin_widgets, bframe ["toolbarPluginsSlider"..i])
            bframe ["toolbarPluginsSlider"..i]:SetPoint ("topleft", anchorFrame, "topleft", 415, y)
            bframe ["toolbarPluginsSlider"..i]:SetAsCheckBox()
            bframe ["toolbarPluginsSlider"..i].OnSwitch = function (self, _, value)
                plugin_stable.enabled = value
                plugin.__enabled = value
                if (value) then
                    _detalhes:SendEvent ("PLUGIN_ENABLED", plugin)
                else
                    _detalhes:SendEvent ("PLUGIN_DISABLED", plugin)
                end
            end
            
            if (pluginObject.OpenOptionsPanel) then
                DF:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 120, 20, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
                bframe ["OptionsButton"..i]:SetPoint ("topleft", anchorFrame, "topleft", 510, y-0)
                bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
                bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
            end
            
            i = i + 1
            y = y - 20
    
            --plugins installed, adding their abs name
            DF.table.addunique (installedToolbarPlugins, absName)
        
        end
    
        local notInstalledColor = "gray"
    
        for o = 1, #allExistentToolbarPlugins do
            local pluginAbsName = allExistentToolbarPlugins [o] [1]
            if (not DF.table.find (installedToolbarPlugins, pluginAbsName)) then
    
                local absName = pluginAbsName
                local pluginObject = {
                    __icon = "",
                    __name = allExistentToolbarPlugins [o] [3],
                    __author = "Not Installed",
                    __version = "",
                    OpenOptionsPanel = false,
                }
    
                local bframe = CreateFrame ("frame", "OptionsPluginToolbarBG", anchorFrame,"BackdropTemplate")
                bframe:SetSize (640, 20)
                bframe:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
                bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
                bframe:SetBackdropColor (.3, .3, .3, .3)
                bframe:SetScript ("OnEnter", on_enter)
                bframe:SetScript ("OnLeave", on_leave)

                bframe.id = i
                bframe.hasDesc = allExistentToolbarPlugins [o] [4]
                
                DF:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
                bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
            
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
                bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
                bframe ["toolbarPluginsLabel"..i].color = notInstalledColor
                
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
                bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", anchorFrame, "topleft", 180, y-4)
                bframe ["toolbarPluginsLabel2"..i].color = notInstalledColor
                
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
                bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", anchorFrame, "topleft", 290, y-4)
                bframe ["toolbarPluginsLabel3"..i].color = notInstalledColor
    
                local installButton = DF:CreateButton (bframe, function() Details:CopyPaste (allExistentToolbarPlugins [o] [5]) end, 120, 20, "Install")
                installButton:SetTemplate (options_button_template)
                installButton:SetPoint ("topleft", anchorFrame, "topleft", 510, y-0)
                
                i = i + 1
                y = y - 20
            end
        end
        
        y = y - 10
        
        --raid
        DF:NewLabel (anchorFrame, _, "$parentRaidPluginsLabel", "raidLabel", Loc ["STRING_OPTIONS_PLUGINS_RAID_ANCHOR"], "GameFontNormal", 16)
        anchorFrame.raidLabel:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
        y = y - 30
        
        do
            local descbar = anchorFrame:CreateTexture (nil, "artwork")
            descbar:SetTexture (.3, .3, .3, .8)
            descbar:SetPoint ("topleft", anchorFrame, "topleft", 5, y+3)
            descbar:SetSize (650, 20)
            DF:NewLabel (anchorFrame, _, "$parentDescNameLabel2", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
            anchorFrame.descNameLabel:SetPoint ("topleft", anchorFrame, "topleft", 15, y)
            DF:NewLabel (anchorFrame, _, "$parentDescAuthorLabel2", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
            anchorFrame.descAuthorLabel:SetPoint ("topleft", anchorFrame, "topleft", 180, y)
            DF:NewLabel (anchorFrame, _, "$parentDescVersionLabel2", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
            anchorFrame.descVersionLabel:SetPoint ("topleft", anchorFrame, "topleft", 290, y)
            DF:NewLabel (anchorFrame, _, "$parentDescEnabledLabel2", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
            anchorFrame.descEnabledLabel:SetPoint ("topleft", anchorFrame, "topleft", 400, y)
            DF:NewLabel (anchorFrame, _, "$parentDescOptionsLabel2", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
            anchorFrame.descOptionsLabel:SetPoint ("topleft", anchorFrame, "topleft", 510, y)
        end
        
        y = y - 30
        
        local i = 1
        local allplugins_raid = _detalhes.RaidTables.NameTable
        for absName, pluginObject in pairs (allplugins_raid) do 
    
            local bframe = CreateFrame ("frame", "OptionsPluginRaidBG", anchorFrame, "BackdropTemplate")
            bframe:SetSize (640, 20)
            bframe:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
            bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
            bframe:SetBackdropColor (.3, .3, .3, .3)
            bframe:SetScript ("OnEnter", on_enter)
            bframe:SetScript ("OnLeave", on_leave)
            bframe.plugin = pluginObject
            bframe.id = i
            
            DF:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "raidPluginsIcon"..i, "$parentRaidPluginsIcon"..i)
            bframe ["raidPluginsIcon"..i]:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
            DF:NewLabel (bframe, _, "$parentRaidPluginsLabel"..i, "raidPluginsLabel"..i, pluginObject.__name)
            bframe ["raidPluginsLabel"..i]:SetPoint ("left", bframe ["raidPluginsIcon"..i], "right", 2, 0)
            
            DF:NewLabel (bframe, _, "$parentRaidPluginsLabel2"..i, "raidPluginsLabel2"..i, pluginObject.__author)
            bframe ["raidPluginsLabel2"..i]:SetPoint ("topleft", anchorFrame, "topleft", 180, y-4)
            
            DF:NewLabel (bframe, _, "$parentRaidPluginsLabel3"..i, "raidPluginsLabel3"..i, pluginObject.__version)
            bframe ["raidPluginsLabel3"..i]:SetPoint ("topleft", anchorFrame, "topleft", 290, y-4)
            
            local plugin_stable = _detalhes:GetPluginSavedTable (absName)
            local plugin = _detalhes:GetPlugin (absName)
            DF:NewSwitch (bframe, _, "$parentRaidSlider"..i, "raidPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
            tinsert (anchorFrame.plugin_widgets, bframe ["raidPluginsSlider"..i])
            bframe ["raidPluginsSlider"..i].PluginName = absName
            bframe ["raidPluginsSlider"..i]:SetPoint ("topleft", anchorFrame, "topleft", 415, y+1)
            bframe ["raidPluginsSlider"..i]:SetAsCheckBox()
            bframe ["raidPluginsSlider"..i].OnSwitch = function (self, _, value)
                plugin_stable.enabled = value
                plugin.__enabled = value
                if (not value) then
                    for index, instancia in ipairs (_detalhes.tabela_instancias) do
                        if (instancia.modo == 4) then -- 4 = raid
                            if (instancia:IsEnabled()) then
                                _detalhes:TrocaTabela (instancia, 0, 1, 1, nil, 2)
                            else
                                instancia.modo = 2 -- group mode
                            end
                        end
                    end
                end
            end
            
            if (pluginObject.OpenOptionsPanel) then
                DF:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 86, 18, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
                bframe ["OptionsButton"..i]:SetPoint ("topleft", anchorFrame, "topleft", 510, y-0)
                bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
                bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
            end
    
            --plugins installed, adding their abs name
            DF.table.addunique (installedRaidPlugins, absName)
            
            i = i + 1
            y = y - 20
        end
    
        for o = 1, #allExistentRaidPlugins do
            local pluginAbsName = allExistentRaidPlugins [o] [1]
            if (not DF.table.find (installedRaidPlugins, pluginAbsName)) then
    
                local absName = pluginAbsName
                local pluginObject = {
                    __icon = "",
                    __name = allExistentRaidPlugins [o] [3],
                    __author = "Not Installed",
                    __version = "",
                    OpenOptionsPanel = false,
                }
    
                local bframe = CreateFrame ("frame", "OptionsPluginToolbarBG", anchorFrame,"BackdropTemplate")
                bframe:SetSize (640, 20)
                bframe:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
                bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
                bframe:SetBackdropColor (.3, .3, .3, .3)
                bframe:SetScript ("OnEnter", on_enter)
                bframe:SetScript ("OnLeave", on_leave)

                bframe.id = i
                bframe.hasDesc = allExistentRaidPlugins [o] [4]
                
                DF:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "toolbarPluginsIcon"..i, "$parentToolbarPluginsIcon"..i)
                bframe ["toolbarPluginsIcon"..i]:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
            
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel"..i, "toolbarPluginsLabel"..i, pluginObject.__name)
                bframe ["toolbarPluginsLabel"..i]:SetPoint ("left", bframe ["toolbarPluginsIcon"..i], "right", 2, 0)
                bframe ["toolbarPluginsLabel"..i].color = notInstalledColor
                
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel2"..i, "toolbarPluginsLabel2"..i, pluginObject.__author)
                bframe ["toolbarPluginsLabel2"..i]:SetPoint ("topleft", anchorFrame, "topleft", 180, y-4)
                bframe ["toolbarPluginsLabel2"..i].color = notInstalledColor
                
                DF:NewLabel (bframe, _, "$parentToolbarPluginsLabel3"..i, "toolbarPluginsLabel3"..i, pluginObject.__version)
                bframe ["toolbarPluginsLabel3"..i]:SetPoint ("topleft", anchorFrame, "topleft", 290, y-4)
                bframe ["toolbarPluginsLabel3"..i].color = notInstalledColor
    
                local installButton = DF:CreateButton (bframe, function() Details:CopyPaste (allExistentRaidPlugins [o] [5]) end, 120, 20, "Install")
                installButton:SetTemplate (options_button_template)
                installButton:SetPoint ("topleft", anchorFrame, "topleft", 510, y-0)
                
                i = i + 1
                y = y - 20
            end
        end	
        
        y = y - 10
    
        -- solo
        DF:NewLabel (anchorFrame, _, "$parentSoloPluginsLabel", "soloLabel", Loc ["STRING_OPTIONS_PLUGINS_SOLO_ANCHOR"], "GameFontNormal", 16)
        anchorFrame.soloLabel:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
        y = y - 30
        
        do
            local descbar = anchorFrame:CreateTexture (nil, "artwork")
            descbar:SetTexture (.3, .3, .3, .8)
            descbar:SetPoint ("topleft", anchorFrame, "topleft", 5, y+3)
            descbar:SetSize (650, 20)
            DF:NewLabel (anchorFrame, _, "$parentDescNameLabel3", "descNameLabel", Loc ["STRING_OPTIONS_PLUGINS_NAME"], "GameFontNormal", 12)
            anchorFrame.descNameLabel:SetPoint ("topleft", anchorFrame, "topleft", 15, y)
            DF:NewLabel (anchorFrame, _, "$parentDescAuthorLabel3", "descAuthorLabel", Loc ["STRING_OPTIONS_PLUGINS_AUTHOR"], "GameFontNormal", 12)
            anchorFrame.descAuthorLabel:SetPoint ("topleft", anchorFrame, "topleft", 180, y)
            DF:NewLabel (anchorFrame, _, "$parentDescVersionLabel3", "descVersionLabel", Loc ["STRING_OPTIONS_PLUGINS_VERSION"], "GameFontNormal", 12)
            anchorFrame.descVersionLabel:SetPoint ("topleft", anchorFrame, "topleft", 290, y)
            DF:NewLabel (anchorFrame, _, "$parentDescEnabledLabel3", "descEnabledLabel", Loc ["STRING_ENABLED"], "GameFontNormal", 12)
            anchorFrame.descEnabledLabel:SetPoint ("topleft", anchorFrame, "topleft", 400, y)
            DF:NewLabel (anchorFrame, _, "$parentDescOptionsLabel3", "descOptionsLabel", Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], "GameFontNormal", 12)
            anchorFrame.descOptionsLabel:SetPoint ("topleft", anchorFrame, "topleft", 510, y)
        end
        
        y = y - 30
        
        local i = 1
        local allplugins_solo = _detalhes.SoloTables.NameTable
        for absName, pluginObject in pairs (allplugins_solo) do 
        
            local bframe = CreateFrame ("frame", "OptionsPluginSoloBG", anchorFrame,"BackdropTemplate")
            bframe:SetSize (640, 20)
            bframe:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
            bframe:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, insets = {left = 1, right = 1, top = 0, bottom = 1}})
            bframe:SetBackdropColor (.3, .3, .3, .3)
            bframe:SetScript ("OnEnter", on_enter)
            bframe:SetScript ("OnLeave", on_leave)
            bframe.plugin = pluginObject
            bframe.id = i
            
            DF:NewImage (bframe, pluginObject.__icon, 18, 18, nil, nil, "soloPluginsIcon"..i, "$parentSoloPluginsIcon"..i)
            bframe ["soloPluginsIcon"..i]:SetPoint ("topleft", anchorFrame, "topleft", 10, y)
        
            DF:NewLabel (bframe, _, "$parentSoloPluginsLabel"..i, "soloPluginsLabel"..i, pluginObject.__name)
            bframe ["soloPluginsLabel"..i]:SetPoint ("left", bframe ["soloPluginsIcon"..i], "right", 2, 0)
            
            DF:NewLabel (bframe, _, "$parentSoloPluginsLabel2"..i, "soloPluginsLabel2"..i, pluginObject.__author)
            bframe ["soloPluginsLabel2"..i]:SetPoint ("topleft", anchorFrame, "topleft", 180, y-4)
            
            DF:NewLabel (bframe, _, "$parentSoloPluginsLabel3"..i, "soloPluginsLabel3"..i, pluginObject.__version)
            bframe ["soloPluginsLabel3"..i]:SetPoint ("topleft", anchorFrame, "topleft", 290, y-4)
            
            local plugin_stable = _detalhes:GetPluginSavedTable (absName)
            local plugin = _detalhes:GetPlugin (absName)
            DF:NewSwitch (bframe, _, "$parentSoloSlider"..i, "soloPluginsSlider"..i, 60, 20, _, _, plugin_stable.enabled, nil, nil, nil, nil, options_switch_template)
            tinsert (anchorFrame.plugin_widgets, bframe ["soloPluginsSlider"..i])
            bframe ["soloPluginsSlider"..i].PluginName = absName
            bframe ["soloPluginsSlider"..i]:SetPoint ("topleft", anchorFrame, "topleft", 415, y+1)
            bframe ["soloPluginsSlider"..i]:SetAsCheckBox()
            bframe ["soloPluginsSlider"..i].OnSwitch = function (self, _, value)
                plugin_stable.enabled = value
                plugin.__enabled = value
                if (not value) then
                    for index, instancia in ipairs (_detalhes.tabela_instancias) do
                        if (instancia.modo == 1 and instancia.baseframe) then -- 1 = solo
                            _detalhes:TrocaTabela (instancia, 0, 1, 1, nil, 2)
                        end
                    end
                end
            end
            
            if (pluginObject.OpenOptionsPanel) then
                DF:NewButton (bframe, nil, "$parentOptionsButton"..i, "OptionsButton"..i, 86, 18, pluginObject.OpenOptionsPanel, nil, nil, nil, Loc ["STRING_OPTIONS_PLUGINS_OPTIONS"], nil, options_button_template)
                bframe ["OptionsButton"..i]:SetPoint ("topleft", anchorFrame, "topleft", 510, y-0)
                bframe ["OptionsButton"..i]:SetTextColor (button_color_rgb)
                bframe ["OptionsButton"..i]:SetIcon ([[Interface\Buttons\UI-OptionsButton]], 14, 14, nil, {0, 1, 0, 1}, nil, 3)
            end
            
            i = i + 1
            y = y - 20
        end

        local sectionOptions = {

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~09 - profiles
do
   
    local buildSection = function(sectionFrame)

        --build profile menu for "always use this profile" feature
		local profile_selected_alwaysuse = function (_, instance, profile_name)
			_detalhes.always_use_profile_name = profile_name
			local unitname = UnitName ("player")
			_detalhes.always_use_profile_exception [unitname] = nil
			
			_detalhes:ApplyProfile (profile_name)
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], profile_name)
			afterUpdate()
		end
		local buildProfileMenuForAlwaysUse = function()
			local menu = {}
			for index, profile_name in ipairs (_detalhes:GetProfileList()) do 
				menu [#menu+1] = {value = profile_name, label = profile_name, onclick = profile_selected_alwaysuse, icon = "Interface\\MINIMAP\\Vehicle-HammerGold-3"}
			end
			return menu
		end

        local selectProfile = function (_, _, profileName)
            _detalhes:ApplyProfile(profileName)
            _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], profileName)
            --Details.options.SetCurrentInstanceAndRefresh(currentInstance)
            --afterUpdate()
            _G.DetailsOptionsWindow:Hide()
            Details:OpenOptionsWindow(currentInstance, false, 9)
        end
        
		local buildProfileMenu = function(func)
			local menu = {}
			for index, profileName in ipairs (_detalhes:GetProfileList()) do
				menu [#menu+1] = {value = profileName, label = profileName, onclick = selectProfile, icon = "Interface\\MINIMAP\\Vehicle-HammerGold-3"}
			end
			return menu
        end
        
		local buildProfileMenuToDelete = function()
			local menu = {}
            for index, profileName in ipairs (_detalhes:GetProfileList()) do
                if (profileName ~= _detalhes:GetCurrentProfileName()) then
                    menu [#menu+1] = {value = profileName, label = profileName, onclick = function()end, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], color = {1, 1, 1}, iconcolor = {1, .9, .9, 0.8}}
                end
			end
			return menu
		end

        local sectionOptions = {
            {type = "label", get = function() return Loc["STRING_OPTIONS_PROFILES_CURRENT"] .. " |cFFFFFFFF" .. _detalhes_database.active_profile end, text_template = options_text_template},

            {--select profile
                type = "select",
                get = function() return _detalhes:GetCurrentProfileName() end,
                values = function() return buildProfileMenu() end,
                name = Loc ["STRING_OPTIONS_PROFILES_SELECT"],
                desc = Loc ["STRING_OPTIONS_PROFILES_SELECT"],
            },

            {type = "blank"},

            {--save size and positioning
                type = "toggle",
                get = function() return _detalhes.profile_save_pos end,
                set = function (self, fixedparam, value)
                    _detalhes.profile_save_pos = value
                    _detalhes:SetProfileCProp (nil, "profile_save_pos", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_PROFILE_POSSIZE"],
                desc = Loc ["STRING_OPTIONS_PROFILE_POSSIZE_DESC"],
            },

            {type = "blank"},

            {--profile name
                type = "textentry",
                get = function() return "profile name" end,
                func = function(self, _, text) end,
                name = Loc ["STRING_OPTIONS_PROFILES_CREATE"],
                --desc = Loc ["STRING_OPTIONS_NICKNAME"],
            },

            {--create new profile
                type = "execute",
                func = function(self)
                    local profileNameString = sectionFrame.widget_list_by_type.textentry[1]
                    local profileName = profileNameString:GetText()

                    if (profileName == "") then
                        return _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_FIELDEMPTY"])
                    end
                    
                    profileNameString:SetText ("")
                    profileNameString:ClearFocus()

                    local new_profile = _detalhes:CreateProfile(profileName)
                    if (new_profile) then
                        _detalhes:ApplyProfile(profileName)
                        afterUpdate()
                        Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    else
                        return _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_NOTCREATED"])
                    end
                end,
                --icontexture = [[Interface\PetBattles\PetBattle-LockIcon]],
                --icontexcoords = {0.0703125, 0.9453125, 0.0546875, 0.9453125},
                name = Loc ["STRING_OPTIONS_PROFILES_CREATE"],
            },

            {type = "blank"},

            {--delete profile
                type = "select",
                get = function() return "" end,
                values = function() return buildProfileMenuToDelete() end,
                name = Loc ["STRING_OPTIONS_PROFILES_ERASE"],
                desc = Loc ["STRING_OPTIONS_PROFILES_ERASE"],
            },

            {--delete profile
                type = "execute",
                func = function(self)
                    local profileDropdown = sectionFrame.widget_list_by_type.dropdown[2]
                    local profileName = profileDropdown:GetValue()

                    if (profileName == "") then
                        return _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_FIELDEMPTY"])
                    end

                    if (#_detalhes:GetProfileList() == 1) then
                        return Details:Msg("There's only one profile.")
                    end

                    if (profileName == _detalhes:GetCurrentProfileName()) then
                        return Details:Msg("Can't delete current profile.")
                    end

                    _detalhes:EraseProfile(profileName)

                    Details.options.SetCurrentInstanceAndRefresh(currentInstance)
                    afterUpdate()
                    _detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_REMOVEOKEY"])
                end,
                name = Loc ["STRING_OPTIONS_PROFILES_ERASE"],
            },

            {type = "blank"},

            {--export profile
                type = "execute",
                func = function(self)
                    local str = Details:ExportCurrentProfile()
                    if (str) then
                        _detalhes:ShowImportWindow (str, nil, "Details! Export Profile")
                    end
                end,
                name = "Export Profile", --localize-me
                icontexture = [[Interface\Buttons\UI-GuildButton-MOTD-Up]],
                icontexcoords = {1, 0, 0, 1},
            },
            {--import profile
                type = "execute",
                func = function(self)
                    _detalhes:ShowImportWindow("", function (profileString)
                        if (type (profileString) ~= "string" or string.len (profileString) < 2) then
                            return
                        end
                        
                        --prompt text panel returns what the user inserted in the text field in the first argument
                        DF:ShowTextPromptPanel("Insert a Name for the New Profile:", function (newProfileName) --localize-me
                            Details:ImportProfile (profileString, newProfileName)
                        end)
                    end, "Details! Import Profile (paste string)") --localize-me
                end,
                name = "Import Profile", --localize-me
                icontexture = [[Interface\BUTTONS\UI-GuildButton-OfficerNote-Up]],
                icontexcoords = {0, 1, 0, 1},
            },

            {type = "blank"},

            {--use on all characters
                type = "toggle",
                get = function() return _detalhes.always_use_profile end,
                set = function (self, fixedparam, value)
                    _detalhes.always_use_profile = value
                    
                    if (value) then
                        _detalhes.always_use_profile = true
                        _detalhes.always_use_profile_name = sectionFrame.widget_list_by_type.dropdown[3]:GetValue()
                        
                        --enable the dropdown
                        sectionFrame.widget_list_by_type.dropdown[3]:Enable()
                        
                        --set the dropdown value to the current profile selected
                        sectionFrame.widget_list_by_type.dropdown[3]:Select(_detalhes.always_use_profile_name)
                        
                        --remove this character from the exception list
                        local unitname = UnitName ("player")
                        _detalhes.always_use_profile_exception [unitname] = nil
                    else
                        _detalhes.always_use_profile = false
                        --disable the dropdown
                        sectionFrame.widget_list_by_type.dropdown[3]:Disable()
                        
                        --remove this character from the exception list
                        local unitname = UnitName ("player")
                        _detalhes.always_use_profile_exception [unitname] = nil
                    end

                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_ALWAYS_USE"],
                desc = Loc ["STRING_OPTIONS_ALWAYS_USE_DESC"],
            },

            {--select a profile to use on all characters
                type = "select",
                get = function() return _detalhes.always_use_profile_name end,
                values = function() return buildProfileMenuForAlwaysUse() end,
                name = "Select Profile",
                desc = Loc ["STRING_OPTIONS_PROFILE_GLOBAL"],
            },


        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~10 ~tooltips
do
    local buildSection = function(sectionFrame)

        --button for anchor toggle
        local refreshToggleAnchor = function()
            local buttonToggleAnchor = sectionFrame.widget_list_by_type.button[1]
            if (_detalhes.tooltip.anchored_to == 1) then
                buttonToggleAnchor:Disable()
            else
                buttonToggleAnchor:Enable()
            end
        end

		--text face
            local on_select_tooltip_font = function (self, _, fontName)
                _detalhes.tooltip.fontface = fontName
                _detalhes:SendOptionsModifiedEvent (DetailsOptionsWindow.instance)
            end
            
            local buildTooltipFontOptions = function()
                local fonts = {}
                for name, fontPath in pairs (SharedMedia:HashTable ("font")) do 
                
                    fonts [#fonts+1] = {value = name, icon = font_select_icon, texcoord = font_select_texcoord, label = name, onclick = on_select_tooltip_font, font = fontPath, descfont = name, desc = "Our thoughts strayed constantly\nAnd without boundary\nThe ringing of the division bell had began."}
                end
                table.sort (fonts, function (t1, t2) return t1.label < t2.label end)
                return fonts
            end
        
        --number format
            local icon = [[Interface\COMMON\mini-hourglass]]
            local iconcolor = {1, 1, 1, .5}
            local iconsize = {14, 14}
        
            local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
                _detalhes.tooltip.abbreviation = abbreviationtype
                
                _detalhes.atributo_damage:UpdateSelectedToKFunction()
                _detalhes.atributo_heal:UpdateSelectedToKFunction()
                _detalhes.atributo_energy:UpdateSelectedToKFunction()
                _detalhes.atributo_misc:UpdateSelectedToKFunction()
                _detalhes.atributo_custom:UpdateSelectedToKFunction()
                
                afterUpdate()
            end

            local abbreviationOptions = {
                {value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = "Example: 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = "Example: 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = "Example: 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = "Example: 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = "Example: 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = "Example: 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = "Example: 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
                {value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = "Example: 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
            }
            local buildAbbreviationMenu = function()
                return abbreviationOptions
            end

        --maximize method
            local onSelectMaximize = function (_, _, maximizeType)
                _detalhes.tooltip.maximize_method = maximizeType
                _detalhes.atributo_damage:UpdateSelectedToKFunction()
                _detalhes.atributo_heal:UpdateSelectedToKFunction()
                _detalhes.atributo_energy:UpdateSelectedToKFunction()
                _detalhes.atributo_misc:UpdateSelectedToKFunction()
                _detalhes.atributo_custom:UpdateSelectedToKFunction()
                
                afterUpdate()
            end
            
            local icon = [[Interface\Buttons\UI-Panel-BiggerButton-Up]]
            local iconcolor = {1, 1, 1, 1}
            local iconcord = {0.1875, 0.78125+0.109375, 0.78125+0.109375+0.03, 0.21875-0.109375-0.03}
            
            local maximizeOptions = {
                {value = 1, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE1"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
                {value = 2, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE2"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
                {value = 3, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE3"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
                {value = 4, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE4"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
                {value = 5, label = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE5"], onclick = onSelectMaximize, icon = icon, iconcolor = iconcolor, texcoord = iconcord}, --, desc = ""
            }
            local buildMaximizeMenu = function()
                return maximizeOptions
            end

        --tooltip side
            local onSelectAnchorPoint = function (_, _, selected_anchor)
                _detalhes.tooltip.anchor_point = selected_anchor
                afterUpdate()
            end
            
            local anchorPointOptions = {
                {value = "top", label = Loc ["STRING_ANCHOR_TOP"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.8125, 0.1875, 0.875}},
                {value = "bottom", label = Loc ["STRING_ANCHOR_BOTTOM"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.875, 1, 0.1875}},
                {value = "left", label = Loc ["STRING_ANCHOR_LEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0.5, 0, 0, 0.8125}},
                {value = "right", label = Loc ["STRING_ANCHOR_RIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0, 0.5, 0, 0.8125}},
                {value = "topleft", label = Loc ["STRING_ANCHOR_TOPLEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.1875, 0.375}},
                {value = "bottomleft", label = Loc ["STRING_ANCHOR_BOTTOMLEFT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.375, 0.1875}},
                {value = "topright", label = Loc ["STRING_ANCHOR_TOPRIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.1875, 0.375}},
                {value = "bottomright", label = Loc ["STRING_ANCHOR_BOTTOMRIGHT"], onclick = onSelectAnchorPoint, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.375, 0.1875}},
            }
            
            local buildAnchorPointMenu = function()
                return anchorPointOptions
            end

        --tooltip relative side
			local onSelectAnchorRelative = function (_, _, selected_anchor)
				_detalhes.tooltip.anchor_relative = selected_anchor
                afterUpdate()
			end
			
			local anchorRelativeOptions = {
				{value = "top", label = Loc ["STRING_ANCHOR_TOP"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.8125, 0.1875, 0.875}},
				{value = "bottom", label = Loc ["STRING_ANCHOR_BOTTOM"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\Arrow-Up-Up]], texcoord = {0, 0.875, 1, 0.1875}},
				{value = "left", label = Loc ["STRING_ANCHOR_LEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0.5, 0, 0, 0.8125}},
				{value = "right", label = Loc ["STRING_ANCHOR_RIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\CHATFRAME\UI-InChatFriendsArrow]], texcoord = {0, 0.5, 0, 0.8125}},
				{value = "topleft", label = Loc ["STRING_ANCHOR_TOPLEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.1875, 0.375}},
				{value = "bottomleft", label = Loc ["STRING_ANCHOR_BOTTOMLEFT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.796875, 0.609375, 0.375, 0.1875}},
				{value = "topright", label = Loc ["STRING_ANCHOR_TOPRIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.1875, 0.375}},
				{value = "bottomright", label = Loc ["STRING_ANCHOR_BOTTOMRIGHT"], onclick = onSelectAnchorRelative, icon = [[Interface\Buttons\UI-AutoCastableOverlay]], texcoord = {0.609375, 0.796875, 0.375, 0.1875}},
			}
			
			local buildAnchorRelativeMenu = function()
				return anchorRelativeOptions
			end            

        --anchor
            local onSelectAnchor = function (_, _, selected_anchor)
                _detalhes.tooltip.anchored_to = selected_anchor
                refreshToggleAnchor()
                afterUpdate()
            end
            
            local anchorOptions = {
                {value = 1, label = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO1"], onclick = onSelectAnchor, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]]},
                {value = 2, label = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO2"], onclick = onSelectAnchor, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]]},
            }
            local buildAnchorMenu = function()
                return anchorOptions
            end

        local sectionOptions = {
            {type = "label", get = function() return Loc["STRING_OPTIONS_TOOLTIP_ANCHORTEXTS"] end, text_template = subSectionTitleTextTemplate},

            {--text shadow
                type = "toggle",
                get = function() return _detalhes.tooltip.fontshadow end,
                set = function (self, fixedparam, value)
                    _detalhes.tooltip.fontshadow = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_LOUTILINE"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_FONTSHADOW_DESC"],
            },

            {type = "label", get = function() return Loc["STRING_OPTIONS_TOOLTIPS_FONTCOLOR"] end},

			{--text color left
                type = "color",
                get = function()
                    local r, g, b, a = unpack(_detalhes.tooltip.fontcolor)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    local color = _detalhes.tooltip.fontcolor
                    color[1] = r
                    color[2] = g
                    color[3] = b
                    color[4] = a
                    afterUpdate()
                end,
                name = Loc ["STRING_LEFT"],
                desc = Loc ["STRING_LEFT"],
            },

			{--text color right
                type = "color",
                get = function()
                    local r, g, b, a = unpack(_detalhes.tooltip.fontcolor_right)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    local color = _detalhes.tooltip.fontcolor_right
                    color[1] = r
                    color[2] = g
                    color[3] = b
                    color[4] = a
                    afterUpdate()
                end,
                name = Loc ["STRING_RIGHT"],
                desc = Loc ["STRING_RIGHT"],
            },

			{--text color header
                type = "color",
                get = function()
                    local r, g, b, a = unpack(_detalhes.tooltip.header_text_color)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    local color = _detalhes.tooltip.header_text_color
                    color[1] = r
                    color[2] = g
                    color[3] = b
                    color[4] = a
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHORCOLOR"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHORCOLOR"],
            },

            {--text size
                type = "range",
                get = function() return _detalhes.tooltip.fontsize end,
                set = function (self, fixedparam, value)
                    _detalhes.tooltip.fontsize = value
                    afterUpdate()
                end,
                min = 5,
                max = 32,
                step = 1,
                name = Loc ["STRING_OPTIONS_TEXT_SIZE"],
                desc = Loc ["STRING_OPTIONS_TEXT_SIZE_DESC"],
            },

            {--text font
                type = "select",
                get = function() return _detalhes.tooltip.fontface end,
                values = function()
                    return buildTooltipFontOptions()
                end,
                name = Loc ["STRING_OPTIONS_TEXT_FONT"],
                desc = Loc ["STRING_OPTIONS_TEXT_FONT_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_MENU_ATTRIBUTESETTINGS_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

			{--background color
                type = "color",
                get = function()
                    local r, g, b, a = unpack(_detalhes.tooltip.background)
                    return {r, g, b, a}
                end,
                set = function (self, r, g, b, a)
                    local color = _detalhes.tooltip.background
                    color[1] = r
                    color[2] = g
                    color[3] = b
                    color[4] = a
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_BACKGROUNDCOLOR"],
            },

            {--show amount
                type = "toggle",
                get = function() return _detalhes.tooltip.show_amount end,
                set = function (self, fixedparam, value)
                    _detalhes.tooltip.show_amount = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_SHOWAMT"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_SHOWAMT_DESC"],
            },

            {--number system
                type = "select",
                get = function() return _detalhes.tooltip.abbreviation end,
                values = function()
                    return buildAbbreviationMenu()
                end,
                name = Loc ["STRING_OPTIONS_PS_ABBREVIATE"],
                desc = Loc ["STRING_OPTIONS_PS_ABBREVIATE_DESC"],
            },

            {--maximize method
                type = "select",
                get = function() return _detalhes.tooltip.maximize_method end,
                values = function()
                    return buildMaximizeMenu()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_MAXIMIZE_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_POINT"] end, text_template = subSectionTitleTextTemplate},

            {--anchor
                type = "select",
                get = function() return _detalhes.tooltip.anchored_to end,
                values = function()
                    return buildAnchorMenu()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_DESC"],
            },

            {--toggle anchor point
                type = "execute",
                func = function(self)
                    _G.DetailsTooltipAnchor:MoveAnchor()
                end,
                icontexture = [[Interface\PetBattles\PetBattle-LockIcon]],
                icontexcoords = {0.0703125, 0.9453125, 0.0546875, 0.9453125},
                name = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TO_CHOOSE_DESC"],
            },

            {type = "blank"},

            {--tooltip anchor side
                type = "select",
                get = function() return _detalhes.tooltip.anchor_point end,
                values = function()
                    return buildAnchorPointMenu()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_ATTACH_DESC"],
            },

            {--tooltip anchor side
                type = "select",
                get = function() return _detalhes.tooltip.anchor_relative end,
                values = function()
                    return buildAnchorRelativeMenu()
                end,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_RELATIVE_DESC"],
            },

            {--anchor offset x
                type = "range",
                get = function() return _detalhes.tooltip.anchor_offset[1] end,
                set = function (self, fixedparam, value)
                    _detalhes.tooltip.anchor_offset[1] = value
                    afterUpdate()
                end,
                min = -100,
                max = 100,
                step = 1,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETX"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETX_DESC"],
            },

            {--anchor offset y
                type = "range",
                get = function() return _detalhes.tooltip.anchor_offset[2] end,
                set = function (self, fixedparam, value)
                    _detalhes.tooltip.anchor_offset[2] = value
                    afterUpdate()
                end,
                min = -100,
                max = 100,
                step = 1,
                name = Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETY"],
                desc = Loc ["STRING_OPTIONS_TOOLTIPS_OFFSETY_DESC"],
            },

            
        }
        
        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
        refreshToggleAnchor()
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~11 ~datafeed
do
    local buildSection = function(sectionFrame)

        local onSelectMinimapAction = function (_, _, option)
            _detalhes.minimap.onclick_what_todo = option
            afterUpdate()
        end
        local menu = {
                {value = 1, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION1"], onclick = onSelectMinimapAction, icon = [[Interface\FriendsFrame\FriendsFrameScrollIcon]]},
                {value = 2, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION2"], onclick = onSelectMinimapAction, icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Up]], iconcolor = {1, .8, 0, 1}},
                {value = 3, label = Loc ["STRING_OPTIONS_MINIMAP_ACTION3"], onclick = onSelectMinimapAction, icon = [[Interface\Buttons\UI-CheckBox-Up]], texcoord = {0.1, 0.9, 0.1, 0.9}},
            }
        local buildMiniMapButtonAction = function()
            return menu
        end

		local onSelectTimeAbbreviation = function (_, _, abbreviationtype)
			_detalhes.tooltip.abbreviation = abbreviationtype
			_detalhes:BrokerTick()
			afterUpdate()
		end
		local icon = [[Interface\COMMON\mini-hourglass]]
		local iconcolor = {1, 1, 1, .5}
		local iconsize = {14, 14}
		local abbreviationOptions = {
			{value = 1, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_NONE"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 2, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 3, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305K", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 4, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25M", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 5, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOKMIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305.5k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 6, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK2MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 305.500 -> 305k", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 7, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_TOK0MIN"], desc = Loc ["STRING_EXAMPLE"] .. ": 25.305.500 -> 25m", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize}, --, desc = ""
			{value = 8, label = Loc ["STRING_OPTIONS_PS_ABBREVIATE_COMMA"], desc = Loc ["STRING_EXAMPLE"] .. ": 25305500 -> 25.305.500", onclick = onSelectTimeAbbreviation, icon = icon, iconcolor = iconcolor, iconsize = iconsize} --, desc = ""
		}
		local buildAbbreviationMenu = function()
			return abbreviationOptions
		end

        local sectionOptions = {
            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_MINIMAP_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--minimap icon enabled
                type = "toggle",
                get = function() return not _detalhes.minimap.hide end,
                set = function (self, fixedparam, value)
                    _detalhes.minimap.hide = not value

                    local LDBIcon = LDB and LibStub("LibDBIcon-1.0", true)

                    LDBIcon:Refresh("Details", _detalhes.minimap)
                    if (_detalhes.minimap.hide) then
                        LDBIcon:Hide("Details")
                    else
                        LDBIcon:Show("Details")
                    end
                    
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MINIMAP"],
                desc = Loc ["STRING_OPTIONS_MINIMAP_DESC"],
            },

            {--minimap button on click
                type = "select",
                get = function() return _detalhes.minimap.onclick_what_todo end,
                values = function()
                    return buildMiniMapButtonAction()
                end,
                name = Loc ["STRING_OPTIONS_MINIMAP_ACTION"],
                desc = Loc ["STRING_OPTIONS_MINIMAP_ACTION_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_DATABROKER"] end, text_template = subSectionTitleTextTemplate},

            {--broker text
                type = "textentry",
                get = function() return _detalhes.data_broker_text or "" end,
                func = function(self, _, text)
                    local brokerText = text or ""
                    _detalhes:SetDataBrokerText (brokerText)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_DATABROKER_TEXT"],
                desc = Loc ["STRING_OPTIONS_DATABROKER_TEXT1_DESC"],
            },

            {--open broker text editor
                type = "execute",
                func = function(self)
                    _detalhes:OpenBrokerTextEditor()
                end,
                icontexture = [[Interface\HELPFRAME\OpenTicketIcon]],
                icontexcoords = {.1, .9, .1, .9},
                name = "Open Broker Text Editor", --localize-me
                desc = Loc ["STRING_OPTIONS_OPEN_ROWTEXT_EDITOR"],
            },

            {--broker text format
                type = "select",
                get = function() return _detalhes.minimap.text_format end,
                values = function()
                    return buildAbbreviationMenu()
                end,
                name = Loc ["STRING_OPTIONS_PS_ABBREVIATE"],
                desc = Loc ["STRING_OPTIONS_PS_ABBREVIATE_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_ILVL_TRACKER"] end, text_template = subSectionTitleTextTemplate},

            {--item level tracker enabled
                type = "toggle",
                get = function() return _detalhes.ilevel:IsTrackerEnabled() end,
                set = function (self, fixedparam, value)
                    _detalhes.ilevel:TrackItemLevel(value)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_ILVL_TRACKER_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_REPORT_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--enabled heal spell links
                type = "toggle",
                get = function() return _detalhes.report_heal_links end,
                set = function (self, fixedparam, value)
                    _detalhes.report_heal_links = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_REPORT_HEALLINKS"],
                desc = Loc ["STRING_OPTIONS_REPORT_HEALLINKS_DESC"],
            },
        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~12 ~wallpaper
do
    local buildSection = function(sectionFrame)

		--> callback from the image editor
			local callmeback = function (width, height, overlayColor, alpha, texCoords)
                editInstanceSetting(currentInstance, "InstanceWallpaper", nil, nil, alpha, texCoords, width, height, overlayColor)
				sectionFrame:UpdateWallpaperInfo()
				afterUpdate()
			end
 
        --> select wallpaper
            local onSelectSecTexture = function (self, instance, texturePath)
                    
                local textureOptions = sectionFrame.wallpaperOptions
                local selectedTextureOption = texturePath
                
                if (texturePath:find ("TALENTFRAME")) then
                    editInstanceSetting(currentInstance, "InstanceWallpaper", texturePath, nil, nil, {0, 1, 0, 0.703125}, nil, nil, {1, 1, 1, 1})
                    afterUpdate()
                    
                    if (_G.DetailsImageEdit and _G.DetailsImageEdit:IsShown()) then
                        local wp = currentInstance.wallpaper
                        if (wp.anchor == "all") then
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
                        else
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
                        end
                    end
                
                elseif (texturePath:find("EncounterJournal")) then
                
                    editInstanceSetting(currentInstance, "InstanceWallpaper", texturePath, nil, nil, {0.06, 0.68, 0.1, 0.57}, nil, nil, {1, 1, 1, 1})
                    afterUpdate()
                    
                    if (_G.DetailsImageEdit and _G.DetailsImageEdit:IsShown()) then
                        local wp = currentInstance.wallpaper
                        if (wp.anchor == "all") then
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
                        else
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
                        end
                    end
                
                else
                    local texCoords = selectedTextureOption and selectedTextureOption.texcoord
                    editInstanceSetting(currentInstance, "InstanceWallpaper", texturePath, nil, nil, texCoords or {0, 1, 0, 1}, nil, nil, {1, 1, 1, 1})
                    afterUpdate()

                    if (_G.DetailsImageEdit and _G.DetailsImageEdit:IsShown()) then
                        local wp = currentInstance.wallpaper
                        if (wp.anchor == "all") then
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha, true)
                        else
                            DF:ImageEditor (callmeback, wp.texture, wp.texcoord, wp.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wp.alpha)
                        end
                    end
                end
                
                sectionFrame:UpdateWallpaperInfo()
            end

            sectionFrame.wallpaperOptions = {
                {value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]], label = "Horizontal Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-HorizontalShadow]], texcoord = nil},
                {value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Highlight]], label = "Golden Highlight", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Parchment-Highlight]], texcoord = {0.35, 0.655, 0.0390625, 0.859375}},
                {value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Stat-Buttons]], label = "Gray Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Stat-Buttons]], texcoord = {0, 1, 97/128, 1}},
                {value = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Borders]], label = "Orange Gradient", onclick = onSelectSecTexture, icon = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-Borders]], texcoord = {160/512, 345/512, 80/256, 130/256}},
                {value = [[Interface\ARCHEOLOGY\Arch-BookCompletedLeft]], label = "Book Wallpaper", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-BookCompletedLeft]], texcoord = nil},
                {value = [[Interface\ARCHEOLOGY\Arch-BookItemLeft]], label = "Book Wallpaper 2", onclick = onSelectSecTexture, icon = [[Interface\ARCHEOLOGY\Arch-BookItemLeft]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-deathknight-blood]], label = "Blood", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_BloodPresence]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-deathknight-frost]], label = "Frost", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_FrostPresence]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-deathknight-unholy]], label = "Unholy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\Spell_Deathknight_UnholyPresence]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-druid-bear]], label = "Guardian", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_racial_bearform]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-druid-restoration]], label = "Restoration", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_healingtouch]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-druid-cat]], label = "Feral", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_vampiricaura]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-druid-balance]], label = "Balance", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_starfall]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-hunter-beastmaster]], label = "Beast Mastery", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_bestialdiscipline]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-hunter-marksman]], label = "Marksmanship", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_focusedaim]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-hunter-survival]], label = "Survival", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_hunter_camouflage]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-mage-arcane]], label = "Arcane", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_magicalsentry]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-mage-fire]], label = "Fire", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_fire_firebolt02]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-mage-frost]], label = "Frost", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_frost_frostbolt02]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-monk-brewmaster]], label = "Brewmaster", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_drunkenox]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-monk-mistweaver]], label = "Mistweaver", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_wiseserpent]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-monk-battledancer]], label = "Windwalker", onclick = onSelectSecTexture, icon = [[Interface\ICONS\monk_stance_whitetiger]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-paladin-holy]], label = "Holy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_holybolt]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-paladin-protection]], label = "Protection", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_paladin_shieldofthetemplar]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-paladin-retribution]], label = "Retribution", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_auraoflight]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-priest-discipline]], label = "Discipline", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_powerwordshield]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-priest-holy]], label = "Holy", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_holy_guardianspirit]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-priest-shadow]], label = "Shadow", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_shadowwordpain]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-rogue-assassination]], label = "Assassination", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_rogue_eviscerate]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-rogue-combat]], label = "Combat", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_backstab]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-rogue-subtlety]], label = "Subtlety", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_stealth]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-shaman-elemental]], label = "Elemental", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_lightning]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-shaman-enhancement]], label = "Enhancement", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_lightningshield]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-shaman-restoration]], label = "Restoration", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_nature_magicimmunity]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warlock-affliction]], label = "Affliction", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_deathcoil]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warlock-demonology]], label = "Demonology", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_metamorphosis]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warlock-destruction]], label = "Destruction", onclick = onSelectSecTexture, icon = [[Interface\ICONS\spell_shadow_rainoffire]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warrior-arms]], label = "Arms", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_savageblow]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warrior-fury]], label = "Fury", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_innerrage]], texcoord = nil},
                {value = [[Interface\TALENTFRAME\bg-warrior-protection]], label = "Protection", onclick = onSelectSecTexture, icon = [[Interface\ICONS\ability_warrior_defensivestance]], texcoord = nil},
            }

        --create preview
            local previewX, previewY = 460, -60

            local preview = sectionFrame:CreateTexture (nil, "overlay")
            preview:SetDrawLayer ("artwork", 3)
            preview:SetSize (256, 128)
            preview:SetPoint ("topleft", sectionFrame, "topleft", previewX, previewY)
            
            --background white
            local whiteBackground = sectionFrame:CreateTexture(nil, "overlay")
            whiteBackground:SetDrawLayer("background")
            whiteBackground:SetSize (255, 128)
            whiteBackground:SetPoint ("topleft", sectionFrame, "topleft", previewX, previewY)
            whiteBackground:SetColorTexture(1, 1, 1, 1)

            --background grid
            local icon1 = DF:NewImage (sectionFrame, nil, 128, 64, "artwork", nil, nil, "$parentIcon1")
            icon1:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            icon1:SetPoint ("topleft", sectionFrame, "topleft", previewX, previewY)
            icon1:SetDrawLayer ("artwork", 1)
            icon1:SetTexCoord (0.337890625, 0.5859375, 0.59375, 0.716796875-0.0009765625) --173 304 300 367
            
            local icon2 = DF:NewImage (sectionFrame, nil, 128, 64, "artwork", nil, nil, "$parentIcon2")
            icon2:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            icon2:SetPoint ("left", icon1.widget, "right", -1, 0)
            icon2:SetDrawLayer ("artwork", 1)
            icon2:SetTexCoord (0.337890625, 0.5859375, 0.59375, 0.716796875-0.0009765625) --173 304 300 367
            
            local icon3 = DF:NewImage (sectionFrame, nil, 128, 64, "artwork", nil, nil, "$parentIcon3")
            icon3:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            icon3:SetPoint ("top", icon1.widget, "bottom")
            icon3:SetDrawLayer ("artwork", 1)
            icon3:SetTexCoord (0.337890625, 0.5859375, 0.59375+0.0009765625, 0.716796875) --173 304 300 367
            
            local icon4 = DF:NewImage (sectionFrame, nil, 128, 64, "artwork", nil, nil, "$parentIcon4")
            icon4:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            icon4:SetPoint ("left", icon3.widget, "right", -1, 0)
            icon4:SetDrawLayer ("artwork", 1)
            icon4:SetTexCoord (0.337890625, 0.5859375, 0.59375+0.0009765625, 0.716796875) --173 304 300 367
            
            icon1:SetVertexColor (.15, .15, .15, 1)
            icon2:SetVertexColor (.15, .15, .15, 1)
            icon3:SetVertexColor (.15, .15, .15, 1)
            icon4:SetVertexColor (.15, .15, .15, 1)

            --corners
            local w, h = 20, 20
            
            local L1 = sectionFrame:CreateTexture (nil, "overlay")
            L1:SetPoint ("topleft", preview, "topleft")
            L1:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            L1:SetTexCoord (0.13671875+0.0009765625, 0.234375, 0.29296875, 0.1953125+0.0009765625)
            L1:SetSize (w, h)
            L1:SetDrawLayer ("overlay", 2)
            L1:SetVertexColor (1, 1, 1, .8)
            
            local L2 = sectionFrame:CreateTexture (nil, "overlay")
            L2:SetPoint ("bottomleft", preview, "bottomleft")
            L2:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            L2:SetTexCoord (0.13671875+0.0009765625, 0.234375, 0.1953125+0.0009765625, 0.29296875)
            L2:SetSize (w, h)
            L2:SetDrawLayer ("overlay", 2)
            L2:SetVertexColor (1, 1, 1, .8)
            
            local L3 = sectionFrame:CreateTexture (nil, "overlay")
            L3:SetPoint ("bottomright", preview, "bottomright", 0, 0)
            L3:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            L3:SetTexCoord (0.234375, 0.13671875-0.0009765625, 0.1953125+0.0009765625, 0.29296875)
            L3:SetSize (w, h)
            L3:SetDrawLayer ("overlay", 5)
            L3:SetVertexColor (1, 1, 1, .8)
            
            local L4 = sectionFrame:CreateTexture (nil, "overlay")
            L4:SetPoint ("topright", preview, "topright", 0, 0)
            L4:SetTexture ("Interface\\AddOns\\Details\\images\\icons")
            L4:SetTexCoord (0.234375, 0.13671875-0.0009765625, 0.29296875, 0.1953125+0.0009765625)
            L4:SetSize (w, h)
            L4:SetDrawLayer ("overlay", 5)
            L4:SetVertexColor (1, 1, 1, .8)

        --update preview
		function sectionFrame:UpdateWallpaperInfo()
            local wallpaper = currentInstance.wallpaper
            
			preview:SetTexture (wallpaper.texture)
			preview:SetTexCoord (unpack (wallpaper.texcoord))
			preview:SetVertexColor (unpack (wallpaper.overlay))
			preview:SetAlpha (wallpaper.alpha)
        end
        
        --> wallpaper alignment
            local onSelectAnchor = function (_, instance, anchor)
                editInstanceSetting(currentInstance, "InstanceWallpaper", nil, anchor)
                afterUpdate()
                sectionFrame:UpdateWallpaperInfo()
            end

            local anchorMenu = {
                {value = "all", label = "Fill", onclick = onSelectAnchor},
                {value = "center", label = "Center", onclick = onSelectAnchor},
                {value = "stretchLR", label = "Stretch Left-Right", onclick = onSelectAnchor},
                {value = "stretchTB", label = "Stretch Top-Bottom", onclick = onSelectAnchor},
                {value = "topleft", label = "Top Left", onclick = onSelectAnchor},
                {value = "bottomleft", label = "Bottom Left", onclick = onSelectAnchor},
                {value = "topright", label = "Top Right", onclick = onSelectAnchor},
                {value = "bottomright", label = "Bottom Right", onclick = onSelectAnchor},
            }
            local buildWallpaperAnchorMenu = function()
                return anchorMenu
            end

        --> open image editor
            local startImageEdit = function()
                if (not currentInstance.wallpaper.texture) then
                    Details:Msg("no texture to edit.")
                    return
                end

                local wallpaper = currentInstance.wallpaper

                if (wallpaper.texture:find ("TALENTFRAME")) then
                    if (wallpaper.anchor == "all") then
                        DF:ImageEditor (callmeback, wallpaper.texture, wallpaper.texcoord, wallpaper.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wallpaper.alpha, true)
                    else
                        DF:ImageEditor (callmeback, wallpaper.texture, wallpaper.texcoord, wallpaper.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wallpaper.alpha)
                    end
                else
                    if (wallpaper.anchor == "all") then
                        DF:ImageEditor (callmeback, wallpaper.texture, wallpaper.texcoord, wallpaper.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wallpaper.alpha, true)
                    else
                        DF:ImageEditor (callmeback, wallpaper.texture, wallpaper.texcoord, wallpaper.overlay, currentInstance.baseframe.wallpaper:GetWidth(), currentInstance.baseframe.wallpaper:GetHeight(), nil, wallpaper.alpha)
                    end
                end
            end

        --> open image to use as wallpaper
            local loadImage = function()
                if (not DetailsLoadWallpaperImage) then
                    
                    local f = CreateFrame ("frame", "DetailsLoadWallpaperImage", UIParent, "BackdropTemplate")
                    f:SetPoint ("center", UIParent, "center")
                    f:SetFrameStrata ("FULLSCREEN")
                    f:SetSize (550, 170)
                    f:EnableMouse (true)
                    f:SetMovable (true)
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
                    
                    DF:ApplyStandardBackdrop(f)
                    DF:CreateTitleBar(f, "Load Your Image") --localize-me
                    
                    tinsert (_G.UISpecialFrames, "DetailsLoadWallpaperImage")
                    
                    local t = f:CreateFontString (nil, "overlay", "GameFontNormal")
                    t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
                    t:SetPoint ("topleft", f, "topleft", 15, -25)
                    t:SetJustifyH ("left")
                    f.t = t
                    
                    local filename = f:CreateFontString (nil, "overlay", "GameFontHighlightLeft")
                    filename:SetPoint ("topleft", f, "topleft", 15, -128)
                    filename:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME"])
                    
                    local editbox = DF:NewTextEntry (f, nil, "$parentFileName", "FileName", 160, 20, function() end, nil, nil, nil, nil, options_dropdown_template)
                    editbox:SetPoint ("left", filename, "right", 2, 0)
                    editbox.tooltip = Loc ["STRING_OPTIONS_WALLPAPER_LOAD_FILENAME_DESC"]
                    
                    local okey_func = function() 
                        local text = editbox:GetText()
                        if (text == "") then
                            return
                        end
                        
                        local instance = _G.DetailsOptionsWindow.instance
                        local path = "Interface\\" .. text
                        editbox:ClearFocus()
                        instance:InstanceWallpaper (path, "all", 0.50, {0, 1, 0, 1}, 256, 256, {1, 1, 1, 1})
                        _detalhes:OpenOptionsWindow (instance)
                        sectionFrame:UpdateWallpaperInfo()
                    end
                    local okey = DF:NewButton (f, _, "$parentOkeyButton", nil, 105, 20, okey_func, nil, nil, nil, Loc ["STRING_OPTIONS_WALLPAPER_LOAD_OKEY"], 1, options_button_template)
                    okey:SetPoint ("left", editbox.widget, "right", 2, 0)
                    
                    local throubleshoot_func = function() 
                        if (t:GetText() == Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"]) then
                            t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT_TEXT"])
                        else
                            _G.DetailsLoadWallpaperImage.t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
                        end
                    end
                    local throubleshoot = DF:NewButton (f, _, "$parentThroubleshootButton", nil, 105, 20, throubleshoot_func, nil, nil, nil, Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TROUBLESHOOT"], 1, options_button_template)
                    throubleshoot:SetPoint ("left", okey, "right", 2, 0)
                    --throubleshoot:InstallCustomTexture()
                end
                
                _G.DetailsLoadWallpaperImage.t:SetText (Loc ["STRING_OPTIONS_WALLPAPER_LOAD_EXCLAMATION"])
                _G.DetailsLoadWallpaperImage:Show()
            end

        local sectionOptions = {
            {type = "label", get = function() return Loc["STRING_OPTIONS_WALLPAPER_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--enable wallpaper
                type = "toggle",
                get = function() return currentInstance.wallpaper.enabled end,
                set = function (self, fixedparam, value)

                    currentInstance.wallpaper.enabled = value

                    if (value) then
                        --first time using a wallpaper
                        if (not currentInstance.wallpaper.texture) then
                            currentInstance.wallpaper.texture = "Interface\\AddOns\\Details\\images\\background"
                        end
                        editInstanceSetting(currentInstance, "InstanceWallpaper", true)
                    else
                        editInstanceSetting(currentInstance, "InstanceWallpaper", false)
                    end

                    afterUpdate()

                    sectionFrame:UpdateWallpaperInfo()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_ILVL_TRACKER_DESC"],
            },

            {--select wallpaper
                type = "select",
                get = function()
                    return currentInstance.wallpaper.texture or ""
                end,
                values = function()
                    return sectionFrame.wallpaperOptions
                end,
                name = Loc ["STRING_OPTIONS_WP_GROUP2"],
                desc = Loc ["STRING_OPTIONS_WP_GROUP2_DESC"],
            },

            {--align wallpaper
                type = "select",
                get = function() return currentInstance.wallpaper.anchor or "" end,
                values = function()
                    return buildWallpaperAnchorMenu()
                end,
                name = Loc ["STRING_OPTIONS_WP_ALIGN"],
                desc = Loc ["STRING_OPTIONS_WP_ALIGN"],
            },

            {--edit wallpaper
                type = "execute",
                func = function(self)
                    startImageEdit()
                end,
                icontexture = [[Interface\AddOns\Details\images\icons]],
                icontexcoords = {469/512, 505/512, 290/512, 322/512},
                name = Loc ["STRING_OPTIONS_EDITIMAGE"],
                desc = Loc ["STRING_OPTIONS_EDITIMAGE"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_WALLPAPER_LOAD_TITLE"] end, text_template = subSectionTitleTextTemplate},

            {--load wallpaper
                type = "execute",
                func = function(self)
                    loadImage()
                end,
                icontexture = [[Interface\AddOns\Details\images\icons]],
                icontexcoords = {437/512, 467/512, 191/512, 239/512},
                name = Loc ["STRING_OPTIONS_WALLPAPER_LOAD"],
                desc = Loc ["STRING_OPTIONS_WALLPAPER_LOAD"],
            },

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)

        sectionFrame:SetScript("OnShow", function()
            sectionFrame:UpdateWallpaperInfo()
        end)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~13 ~automation ~auto hide
do
    local buildSection = function(sectionFrame)

    --> auto switch options
        local Current_Switch_Func = function()end

        local buildSwitchMenu = function()
            sectionFrame.lastSwitchList = {}
            local t = {
                {value = 0, label = "do not switch", color = {.7, .7, .7, 1}, onclick = Current_Switch_Func, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]]}
            }
            
            local attributes = _detalhes.sub_atributos
            local i = 1
            
            for atributo, sub_atributo in ipairs (attributes) do
                local icones = sub_atributo.icones
                for index, att_name in ipairs (sub_atributo.lista) do
                    local texture, texcoord = unpack (icones [index])
                    tinsert (t, {value = i, label = att_name, onclick = Current_Switch_Func, icon = texture, texcoord = texcoord})
                    sectionFrame.lastSwitchList [i] = {atributo, index, i}
                    i = i + 1
                end
            end
            
            for index, ptable in ipairs (_detalhes.RaidTables.Menu) do
                tinsert (t, {value = i, label = ptable [1], onclick = Current_Switch_Func, icon = ptable [2]})
                sectionFrame.lastSwitchList [i] = {"raid", ptable [4], i}
                i = i + 1
            end
        
            return t
        end

        local autoSwitchFrame = CreateFrame("frame", "$parentSwitchMenu", sectionFrame)
        autoSwitchFrame:SetSize(300, 700)
        autoSwitchFrame:SetPoint("topleft", 0, 0)

        --damager not in combat
        local onSelectAutoSwitchDamagerNoCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_damager = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_damager = selected
            afterUpdate()
        end

        --damager in combat
        local onSelectAutoSwitchDamagerInCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_damager_in_combat = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_damager_in_combat = selected
            afterUpdate()
        end

        --healer not in combat
        local onSelectAutoSwitchHealerNoCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_healer = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_healer = selected
            afterUpdate()
        end

        --healer in combat
        local onSelectAutoSwitchHealerInCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_healer_in_combat = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_healer_in_combat = selected
            afterUpdate()
        end

        --tank not in combat
        local onSelectAutoSwitchTankNoCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_tank = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_tank = selected
            afterUpdate()
        end

        --tank in combat
        local onSelectAutoSwitchTankInCombat = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_tank_in_combat = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_tank_in_combat = selected
            afterUpdate()
        end

        --after wipe
        local onSelectAutoSwitchAfterWipe = function (_, _, switchTo)
            if (switchTo == 0) then
                currentInstance.switch_all_roles_after_wipe = false
                afterUpdate()
                return
            end
            local selected = sectionFrame.lastSwitchList [switchTo]
            currentInstance.switch_all_roles_after_wipe = selected
            afterUpdate()
        end

        local getSelectedSwitch = function(switchName)
            local switchTable = currentInstance[switchName]
            if (switchTable) then
                if (switchTable[1] == "raid") then
                    local pluginObject = _detalhes:GetPlugin(switchTable[2])
                    if (pluginObject) then
                        return pluginObject.__name
                    else
                        return 0
                    end
                else
                    return switchTable[3]-- + 1
                end
            else
                return 0
            end
        end

        local sectionOptions = {

            {type = "label", get = function() return "Switch by Role Out of Combat" end, text_template = subSectionTitleTextTemplate},

            {--DAMAGER role out of combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_damager")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchDamagerNoCombat
                    return buildSwitchMenu() 
                end,
                name = _detalhes:AddRoleIcon("", "DAMAGER", 18),
            },

            {--HEALER role out of combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_healer")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchHealerNoCombat
                    return buildSwitchMenu()
                end,
                name = _detalhes:AddRoleIcon("", "HEALER", 18),
            },

            {--TANK role out of combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_tank")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchTankNoCombat
                    return buildSwitchMenu()
                end,
                name = _detalhes:AddRoleIcon("", "TANK", 18),
            },

            {type = "blank"},
            {type = "label", get = function() return "Switch by Role In Combat" end, text_template = subSectionTitleTextTemplate},

            {--DAMAGER role in combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_damager_in_combat")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchDamagerInCombat
                    return buildSwitchMenu() 
                end,
                name = _detalhes:AddRoleIcon("", "DAMAGER", 18),
            },

            {--HEALER role in combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_healer_in_combat")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchHealerInCombat
                    return buildSwitchMenu()
                end,
                name = _detalhes:AddRoleIcon("", "HEALER", 18),
            },

            {--TANK role in combat
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_tank_in_combat")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchTankInCombat
                    return buildSwitchMenu()
                end,
                name = _detalhes:AddRoleIcon("", "TANK", 18),
            },

            {type = "blank"},

            {--switch after a wipe
                type = "select",
                get = function() 
                    return getSelectedSwitch("switch_all_roles_after_wipe")
                end,
                values = function() 
                    Current_Switch_Func = onSelectAutoSwitchAfterWipe
                    return buildSwitchMenu()
                end,
                name = Loc ["STRING_OPTIONS_AUTO_SWITCH_WIPE"],
                desc = Loc ["STRING_OPTIONS_AUTO_SWITCH_WIPE_DESC"],
            },

            {type = "blank"},

            {--auto current segment
                type = "toggle",
                get = function() return currentInstance.auto_current end,
                set = function (self, fixedparam, value)
                    currentInstance.auto_current = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_INSTANCE_CURRENT"],
                desc = Loc ["STRING_OPTIONS_INSTANCE_CURRENT_DESC"],
            },

            {--trash suppression
                type = "range",
                get = function() return _detalhes.instances_suppress_trash end,
                set = function (self, fixedparam, value)
                    _detalhes:SetTrashSuppression(value)
                    afterUpdate()
                end,
                min = 0,
                max = 180,
                step = 1,
                name = Loc ["STRING_OPTIONS_TRASH_SUPPRESSION"],
                desc = Loc ["STRING_OPTIONS_TRASH_SUPPRESSION_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_MENU_ALPHA"] end, text_template = subSectionTitleTextTemplate},
            
            {--enabled
                type = "toggle",
                get = function() return currentInstance.menu_alpha.enabled end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetMenuAlpha", value)
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_MENU_ALPHAENABLED_DESC"],
            },

            {--ignore bars
                type = "toggle",
                get = function() return currentInstance.menu_alpha.ignorebars end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetMenuAlpha", nil, nil, nil, value)
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_MENU_IGNOREBARS"],
                desc = Loc ["STRING_OPTIONS_MENU_IGNOREBARS_DESC"],
            },

            {--on hover over alpha
                type = "range",
                get = function() return currentInstance.menu_alpha.onenter end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetMenuAlpha", nil, value)
                    afterUpdate()
                end,
                min = 0,
                max = 1,
                step = 0.05,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_MENU_ALPHAENTER"],
                desc = Loc ["STRING_OPTIONS_MENU_ALPHAENTER_DESC"],
            },

            {--no interaction
                type = "range",
                get = function() return currentInstance.menu_alpha.onleave end,
                set = function (self, fixedparam, value)
                    editInstanceSetting(currentInstance, "SetMenuAlpha", nil, nil, value)
                    afterUpdate()
                end,
                min = 0,
                max = 1,
                step = 0.05,
                usedecimals = true,
                name = Loc ["STRING_OPTIONS_MENU_ALPHALEAVE"],
                desc = Loc ["STRING_OPTIONS_MENU_ALPHALEAVE_DESC"],
            },            

        }

        DF:BuildMenu(autoSwitchFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)


	--> combat alpha modifier
        local right_start_at = 450

		--anchor
		DF:NewLabel (sectionFrame, _, "$parentHideInCombatAnchor", "hideInCombatAnchor", Loc ["STRING_OPTIONS_ALPHAMOD_ANCHOR"], "GameFontNormal")
		sectionFrame.hideInCombatAnchor:SetPoint("topleft", sectionFrame, "topleft", right_start_at, startY - 20)
		
		--> hide in combat
		DF:NewLabel (sectionFrame, _, "$parentCombatAlphaLabel", "combatAlphaLabel", Loc ["STRING_OPTIONS_COMBAT_ALPHA"], "GameFontHighlightLeft")
		
		local texCoords = {.9, 0.1, 0.1, .9}
		local typeCombatAlpha = {
			Loc["STRING_OPTIONS_COMBAT_ALPHA_2"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_3"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_4"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_5"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_6"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_7"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_8"],
			Loc["STRING_OPTIONS_COMBAT_ALPHA_9"],
		}

		local optionsOrder = {3, 4, 5, 6, 7, 8, 1, 2}

		local header1Label = _G.DetailsFramework:CreateLabel(sectionFrame, Loc["STRING_CONTEXT"])
		local header2Label = _G.DetailsFramework:CreateLabel(sectionFrame, Loc["STRING_ENABLED"])
		local header3Label = _G.DetailsFramework:CreateLabel(sectionFrame, Loc["STRING_INVERT_RULE"])
		local header4Label = _G.DetailsFramework:CreateLabel(sectionFrame, Loc["STRING_ALPHA"])

		local yyy = startY - 40
		header1Label:SetPoint("topleft", sectionFrame, "topleft", right_start_at, yyy)
		header2Label:SetPoint("topleft", sectionFrame, "topleft", right_start_at + 96, yyy)
		header3Label:SetPoint("topleft", sectionFrame, "topleft", right_start_at + 140, yyy)
		header4Label:SetPoint("topleft", sectionFrame, "topleft", right_start_at + 270, yyy)

        local onEnableHideContext = function(self, contextId, value)
            editInstanceSetting(currentInstance, "hide_on_context", contextId, "enabled", value)
            editInstanceSetting(currentInstance, "AdjustAlphaByContext")
            afterUpdate()
		end

        local onInverseValue = function(self, contextId, value)
            editInstanceSetting(currentInstance, "hide_on_context", contextId, "inverse", value)
            editInstanceSetting(currentInstance, "AdjustAlphaByContext")
            afterUpdate()
		end

        local onAlphaChanged = function(self, contextId, value)
            value = floor(value)
            editInstanceSetting(currentInstance, "hide_on_context", contextId, "value", value)
            editInstanceSetting(currentInstance, "AdjustAlphaByContext")
            afterUpdate()
		end

		sectionFrame.AutoHideOptions = {}

		for id, i in ipairs(optionsOrder) do
			local line = _G.CreateFrame("frame", nil, sectionFrame,"BackdropTemplate")
			line:SetSize(300, 22)
			line:SetPoint("topleft", sectionFrame, "topleft", right_start_at, yyy + ((id) * -23) + 4)
			_G.DetailsFramework:ApplyStandardBackdrop(line)

			local contextLabel = _G.DetailsFramework:CreateLabel(line, typeCombatAlpha[i])
			contextLabel:SetPoint("left", line, "left", 2, 0)

			local enabledCheckbox = _G.DetailsFramework:NewSwitch(line, nil, nil, nil, 20, 20, nil, nil, false, nil, nil, nil, nil, options_switch_template)
			enabledCheckbox:SetPoint("left", line, "left", 118, 0)
			enabledCheckbox:SetAsCheckBox()
			enabledCheckbox.OnSwitch = onEnableHideContext
			enabledCheckbox:SetFixedParameter(i)

			local reverseCheckbox = _G.DetailsFramework:NewSwitch(line, nil, nil, nil, 20, 20, nil, nil, false, nil, nil, nil, nil, options_switch_template)
			reverseCheckbox:SetPoint("left", line, "left", 140, 0)
			reverseCheckbox:SetAsCheckBox()
			reverseCheckbox.OnSwitch = onInverseValue
			reverseCheckbox:SetFixedParameter(i)

			local alphaSlider = _G.DetailsFramework:CreateSlider(line, 138, 20, 0, 100, 1, 100, false, nil, nil, nil, options_slider_template)
			alphaSlider:SetPoint("left", line, "left", 162, 0)
			alphaSlider:SetHook("OnValueChanged", onAlphaChanged)
			alphaSlider:SetFixedParameter(i)

			line.contextLabel = contextLabel
			line.enabledCheckbox = enabledCheckbox
			line.reverseCheckbox = reverseCheckbox
			line.alphaSlider = alphaSlider

			--disable the invert checkbox for some options
			if (i == 1 or i == 2 or i == 4 or i == 5 or i == 6) then
				reverseCheckbox:Disable()
			end

			sectionFrame.AutoHideOptions[i] = line
        end

        Details.options.UpdateAutoHideSettings(currentInstance)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~14 ~raidtools ~tools
do --raid tools
    local buildSection = function(sectionFrame)

        --on select channel for interrip announcer
		local on_select_channel = function (self, _, channel)
            _detalhes.announce_interrupts.channel = channel
            C_Timer.After(0, function()
                if (channel == "WHISPER") then
                    sectionFrame.widget_list_by_type.textentry[1]:Enable()
                else
                    sectionFrame.widget_list_by_type.textentry[1]:Disable()
                end
            end)
			afterUpdate()
        end
		local channel_list = {
			{value = "PRINT", icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = "SAY", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, label = Loc ["STRING_CHANNEL_SAY"], onclick = on_select_channel},
			{value = "YELL", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, iconcolor = {1, 0.3, 0, 1}, label = Loc ["STRING_CHANNEL_YELL"], onclick = on_select_channel},
			{value = "RAID", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_INSTANCE_CHAT"], onclick = on_select_channel},
			{value = "WHISPER", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 1}, iconsize = {14, 14}, texcoord = {0.0546875, 0.1953125, 0.625, 0.890625}, label = Loc ["STRING_CHANNEL_WHISPER"], onclick = on_select_channel},
		}
		local buildInterruptChannelMenu = function() 
			return channel_list
        end
        
		--on select channel for cooldown announcer
		local on_select_channel = function (self, _, channel)
			_detalhes.announce_cooldowns.channel = channel
			afterUpdate()
		end
		
		local channel_list = {
			{value = "PRINT", icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = "SAY", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, label = Loc ["STRING_CHANNEL_SAY"], onclick = on_select_channel},
			{value = "YELL", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconsize = {14, 14}, texcoord = {0.0390625, 0.203125, 0.09375, 0.375}, iconcolor = {1, 0.3, 0, 1}, label = Loc ["STRING_CHANNEL_YELL"], onclick = on_select_channel},
			{value = "RAID", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_INSTANCE_CHAT"], onclick = on_select_channel},
			{value = "WHISPER", icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 1}, iconsize = {14, 14}, texcoord = {0.0546875, 0.1953125, 0.625, 0.890625}, label = Loc ["STRING_CHANNEL_WHISPER_TARGET_COOLDOWN"], onclick = on_select_channel},
		}
		local buildCooldownsChannelMenu = function() 
			return channel_list
        end

        --on select channel for report deaths
		local on_select_channel = function (self, _, channel)
			_detalhes.announce_deaths.where = channel
			afterUpdate()
		end
		
		local officer = _detalhes.GetReportIconAndColor ("OFFICER")
		
		local channel_list = {
			{value = 1, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0, 1}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE1"], onclick = on_select_channel},
			{value = 2, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {1, 0.49, 0}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE2"], onclick = on_select_channel},
			{value = 3, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], iconcolor = {0.66, 0.65, 1}, iconsize = {14, 14}, texcoord = {0.53125, 0.7265625, 0.078125, 0.40625}, label = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE3"], onclick = on_select_channel},
			{value = 4, icon = [[Interface\LFGFRAME\BattlenetWorking2]], iconsize = {14, 14}, iconcolor = {1, 1, 1, 1}, texcoord = {12/64, 53/64, 11/64, 53/64}, label = Loc ["STRING_CHANNEL_PRINT"], onclick = on_select_channel},
			{value = 5, icon = officer.icon, iconsize = {14, 14}, iconcolor = officer.color, texcoord = officer.coords, label = officer.label, onclick = on_select_channel},
		}
		local buildDeathLogAnnouncerMenu = function()
			return channel_list
		end
        
        local openCooldownIgnoreWindow = function()
			if (not DetailsAnnounceSelectCooldownIgnored) then
				DetailsAnnounceSelectCooldownIgnored = CreateFrame("frame", "DetailsAnnounceSelectCooldownIgnored", UIParent, "BackdropTemplate")
				local f = DetailsAnnounceSelectCooldownIgnored
				f:SetSize (400, 500)
				f:SetPoint ("center", UIParent, "center", 0, 0)

                DF:ApplyStandardBackdrop(f)
                DF:CreateTitleBar(f, Loc ["STRING_OPTIONS_RT_IGNORE_TITLE"])

                f:SetFrameStrata ("FULLSCREEN")
				f:EnableMouse()
				f:SetMovable (true)
				f:SetScript ("OnMouseDown", function (self, button)
					if (button == "RightButton") then
						if (f.IsMoving) then
							f.IsMoving = false
							f:StopMovingOrSizing()
						end
						f:Hide()
						return
					end
					
					f.IsMoving = true
					f:StartMoving()
                end)
                
				f:SetScript ("OnMouseUp", function (self, button)
					if (f.IsMoving) then
						f.IsMoving = false
						f:StopMovingOrSizing()
					end
                end)

				f.labels = {}
                local on_switch_func = function (self, spellid, value)
                    if (spellid) then
                        if (not value) then
                            _detalhes.announce_cooldowns.ignored_cooldowns [spellid] = nil
                        else
                            _detalhes.announce_cooldowns.ignored_cooldowns [spellid] = true
                        end
                    end
				end
				
				f:SetScript ("OnHide", function (self)
					self:Clear()
				end)
				
				function f:Clear()
					for _, label in ipairs (self.labels) do
						label.icon:Hide()
						label.text:Hide()
						label.switch:Hide()
					end
				end
				
				function f:CreateLabel()
					local L = {
						icon = DF:CreateImage (f, nil, 16, 16, "overlay", {0.1, 0.9, 0.1, 0.9}),
						text = DF:CreateLabel (f, "", 10, "white", "GameFontHighlightSmall"),
                    }

                    L.switch = DF:CreateSwitch (f, on_switch_func, false)

                    L.switch:SetPoint ("topleft", f, "topleft", 10, ((#f.labels*20)*-1)-55)
					L.icon:SetPoint ("left", L.switch, "right", 2, 0)
					L.text:SetPoint ("left", L.icon, "right", 2, 0)
                    
                    L.switch:SetAsCheckBox()
                    L.switch:SetTemplate(options_switch_template)
                    L.switch:SetFixedParameter(1)
                    L.switch:SetValue(false)

					tinsert (f.labels, L)
					return L
				end
				
				function f:Open()
					local _GetSpellInfo = _detalhes.getspellinfo --details api
					
					for index, spellid in ipairs (_detalhes:GetCooldownList()) do
						local name, _, icon = _GetSpellInfo (spellid)
						if (name) then
							local label = f.labels [index] or f:CreateLabel()
							label.icon.texture = icon
                            label.text.text = name

							label.switch:SetFixedParameter(spellid)
							label.switch:SetValue(_detalhes.announce_cooldowns.ignored_cooldowns[spellid])
							label.icon:Show()
							label.text:Show()
							label.switch:Show()
						end
					end
					f:Show()
				end
			end
			DetailsAnnounceSelectCooldownIgnored:Open()
		end

        local sectionOptions = {

            {type = "label", get = function() return Loc ["STRING_OPTIONS_RT_INTERRUPT_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--auto current segment
                type = "toggle",
                get = function() return Details.announce_interrupts.enabled end,
                set = function (self, fixedparam, value)
                    if (value) then
                        _detalhes:EnableInterruptAnnouncer()
                    else
                        _detalhes:DisableInterruptAnnouncer()
                    end
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_RT_INTERRUPTS_ONOFF_DESC"],
            },

            {--channel to report
                type = "select",
                get = function() return _detalhes.announce_interrupts.channel end,
                values = function() 
                    return buildInterruptChannelMenu()
                end,
                name = Loc ["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL"],
                desc = Loc ["STRING_OPTIONS_RT_INTERRUPTS_CHANNEL_DESC"],
            },
            
            {--target player to whisper
                type = "textentry",
                get = function() 
                    C_Timer.After(0, function()
                        if (_detalhes.announce_interrupts.channel ~= "WHISPER") then
                            sectionFrame.widget_list_by_type.textentry[1]:Disable()
                        end
                    end)
                    return _detalhes.announce_interrupts.whisper 
                end,
                func = function(_, _, text)
                    _detalhes.announce_interrupts.whisper = text or ""
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"],
                desc = Loc ["STRING_OPTIONS_RT_INTERRUPTS_WHISPER"],
            },

            {--next player to cut, whisper the person
                type = "textentry",
                get = function() 
                    return _detalhes.announce_interrupts.next
                end,
                func = function(_, _, text)
                    _detalhes.announce_interrupts.next = text or ""
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_RT_INTERRUPTS_NEXT"],
                desc = Loc ["STRING_OPTIONS_RT_INTERRUPTS_NEXT_DESC"],
            },

            {--custom text field
                type = "textentry",
                get = function() 
                    return _detalhes.announce_interrupts.custom
                end,
                func = function(_, _, text)
                    _detalhes.announce_interrupts.custom = text or ""
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM"],
                desc = Loc ["STRING_OPTIONS_RT_INTERRUPTS_CUSTOM_DESC"],
            },
            {--test custom text
                type = "execute",
                func = function(self)
                    local text = sectionFrame.widget_list_by_type.textentry[3]:GetText()
                    local channel = _detalhes.announce_interrupts.channel
                    _detalhes.announce_interrupts.channel = "PRINT"
                    _detalhes:interrupt_announcer (nil, nil, nil, _detalhes.playername, nil, nil, "A Monster", nil, 1766, "Kick", nil, 106523, "Cataclysm", nil)
                    _detalhes.announce_interrupts.channel = channel
                end,
                icontexture = [[Interface\CHATFRAME\ChatFrameExpandArrow]],
                name = "Test",
                desc = "Click to test!", --localize-me
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_RT_COOLDOWNS_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--enable cooldown announcer
                type = "toggle",
                get = function() return _detalhes.announce_cooldowns.enabled end,
                set = function (self, fixedparam, value)
                    if (value) then
                        _detalhes:EnableCooldownAnnouncer()
                    else
                        _detalhes:DisableCooldownAnnouncer()
                    end
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_RT_COOLDOWNS_ONOFF_DESC"],
            },

            {--channel to report
                type = "select",
                get = function() return _detalhes.announce_cooldowns.channel end,
                values = function() 
                    return buildCooldownsChannelMenu()
                end,
                name = Loc ["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL"],
                desc = Loc ["STRING_OPTIONS_RT_COOLDOWNS_CHANNEL_DESC"],
            },

            {--custom text field
                type = "textentry",
                get = function() 
                    return _detalhes.announce_cooldowns.custom
                end,
                func = function(_, _, text)
                    _detalhes.announce_cooldowns.custom = text or ""
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM"],
                desc = Loc ["STRING_OPTIONS_RT_COOLDOWNS_CUSTOM_DESC"],
            },

            {--test custom text
                type = "execute",
                func = function(self)
                    local text = sectionFrame.widget_list_by_type.textentry[4]:GetText()
                    local channel = _detalhes.announce_cooldowns.channel
                    _detalhes.announce_cooldowns.channel = "PRINT"
                    _detalhes:cooldown_announcer (nil, nil, nil, _detalhes.playername, nil, nil, "Tyrande Whisperwind", nil, 47788, "Guardian Spirit")
                    _detalhes.announce_cooldowns.channel = channel
                end,
                icontexture = [[Interface\CHATFRAME\ChatFrameExpandArrow]],
                name = "Test",
                desc = "Click to test!", --localize-me
            },

            {--ignored cooldowns
                type = "execute",
                func = function(self)
                    openCooldownIgnoreWindow()
                end,
                icontexture = [[Interface\COMMON\UI-DropDownRadioChecks]],
                icontexcoords = {0, 0.5, 0, 0.5},
                name = Loc ["STRING_OPTIONS_RT_IGNORE_TITLE"],
                desc = Loc ["STRING_OPTIONS_RT_COOLDOWNS_SELECT_DESC"],
            },

            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_OPTIONS_RT_DEATHS_ANCHOR"] end, text_template = subSectionTitleTextTemplate},

            {--enable death announcer
                type = "toggle",
                get = function() return _detalhes.announce_deaths.enabled end,
                set = function (self, fixedparam, value)
                    if (value) then
                        _detalhes:EnableDeathAnnouncer()
                    else
                        _detalhes:DisableDeathAnnouncer()
                    end
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = Loc ["STRING_OPTIONS_RT_DEATHS_ONOFF_DESC"],
            },

            {--max hits to show
                type = "range",
                get = function() return _detalhes.announce_deaths.last_hits end,
                set = function (self, fixedparam, value)
                    _detalhes.announce_deaths.last_hits = value
                    afterUpdate()
                end,
                min = 1,
                max = 5,
                step = 1,
                name = Loc ["STRING_OPTIONS_RT_DEATHS_HITS"],
                desc = Loc ["STRING_OPTIONS_RT_DEATHS_HITS_DESC"],
            },

            {--max hits to show
                type = "range",
                get = function() return _detalhes.announce_deaths.only_first end,
                set = function (self, fixedparam, value)
                    _detalhes.announce_deaths.only_first = value
                    afterUpdate()
                end,
                min = 1,
                max = 30,
                step = 1,
                name = Loc ["STRING_OPTIONS_RT_DEATHS_FIRST"],
                desc = Loc ["STRING_OPTIONS_RT_DEATHS_FIRST_DESC"],
            },

            {--death report channel
                type = "select",
                get = function() return _detalhes.announce_deaths.where end,
                values = function() 
                    return buildDeathLogAnnouncerMenu()
                end,
                name = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE"],
                desc = Loc ["STRING_OPTIONS_RT_DEATHS_WHERE_DESC"],
            },

            {type = "breakline"},
            {type = "label", get = function() return "Death Recap:" end, text_template = subSectionTitleTextTemplate}, --localize-me

            {--enable death recap
                type = "toggle",
                get = function() return _detalhes.death_recap.enabled end,
                set = function (self, fixedparam, value)
                    _detalhes.death_recap.enabled = value
                    afterUpdate()
                end,
                name = Loc ["STRING_ENABLED"],
                desc = "Modify the Blizzard's Death Recap screen.", --localize-me
            },

            {--relevance time
                type = "range",
                get = function() return _detalhes.death_recap.relevance_time end,
                set = function (self, fixedparam, value)
                    _detalhes.death_recap.relevance_time = value
                    afterUpdate()
                end,
                min = 1,
                max = 12,
                step = 1,
                name = "Relevance Time", --localize-me
                desc = "Attempt to fill the Death Recap with high damage (discart low hits) in the relevant time before death.", --localize-me
            },

            {--show life percent
                type = "toggle",
                get = function() return _detalhes.death_recap.show_life_percent end,
                set = function (self, fixedparam, value)
                    _detalhes.death_recap.show_life_percent = value
                    afterUpdate()
                end,
                name = "Life Percent", --localize-me
                desc = "Show the percent of life the player had when received the hit.", --localize-me
            },

            {--show segment list
                type = "toggle",
                get = function() return _detalhes.death_recap.show_segments end,
                set = function (self, fixedparam, value)
                    _detalhes.death_recap.show_segments = value
                    afterUpdate()
                end,
                name = "Segment List", --localize-me
                desc = "Show a list of the latest segments in case you want to see recaps from previous fights.", --localize-me
            },
            
            {type = "blank"},
            {type = "label", get = function() return Loc ["STRING_GERAL"] .. ":" end, text_template = subSectionTitleTextTemplate},

            {--show first hit
                type = "toggle",
                get = function() return _detalhes.announce_firsthit.enabled end,
                set = function (self, fixedparam, value)
                    _detalhes.announce_firsthit.enabled = value
                    afterUpdate()
                end,
                name = Loc ["STRING_OPTIONS_RT_FIRST_HIT"],
                desc = Loc ["STRING_OPTIONS_RT_FIRST_HIT_DESC"],
            },

            {--show death menu
                type = "toggle",
                get = function() return _detalhes.on_death_menu end,
                set = function (self, fixedparam, value)
                    _detalhes.on_death_menu = value
                    afterUpdate()
                end,
                name = "Show Death Menu", --localize-me
                desc = "Show a panel below the Release / Death Recap panel with some shortcuts for Raid Leaders.", --localize-me
            },
        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~15 ~broadcaster
do
    local buildSection = function(sectionFrame)

        local button_width = 160

        --> streamer plugin - a.k.a. player spell tracker 
			--> title anchor
            DF:NewLabel (sectionFrame, _, "$parentStreamerPluginAnchor", "streamerPluginAnchor", "Action Tracker", "GameFontNormal")
            sectionFrame.streamerPluginAnchor:SetPoint("topleft", sectionFrame, "topleft", startX, startY - 20)

			local streamerTitleDesc = DF:NewLabel (sectionFrame, _, "$parentStreamerTitleDescText", "StreamerTitleDescTextLabel", "Show the spells you are casting, allowing the viewer to follow your decision making and learn your rotation.", "GameFontNormal", 10, "white")
			streamerTitleDesc:SetSize (270, 40)
			streamerTitleDesc:SetJustifyV ("top")
			streamerTitleDesc:SetPoint ("topleft", sectionFrame.streamerPluginAnchor, "bottomleft", 0, -4)
			
			local streamerTitleImage = DF:CreateImage (sectionFrame, [[Interface\AddOns\Details\images\icons2]], 256, 41, "overlay", {0.5, 1, 0.49, 0.57})
			streamerTitleImage:SetPoint ("topleft", sectionFrame.streamerPluginAnchor, "bottomleft", 0, -40)
			
			--> get the plugin object
			local StreamerPlugin = _detalhes:GetPlugin ("DETAILS_PLUGIN_STREAM_OVERLAY")
			if (StreamerPlugin) then
				--> get the plugin settings table
				local tPluginSettings = _detalhes:GetPluginSavedTable ("DETAILS_PLUGIN_STREAM_OVERLAY")
				if (tPluginSettings) then
					local bIsPluginEnabled = tPluginSettings.enabled
					--> plugin already enabled
					if (bIsPluginEnabled) then
						--> config button
						local configure_streamer_plugin = function()
							StreamerPlugin.OpenOptionsPanel (true)
							C_Timer.After (0.2, function()
								_G.DetailsOptionsWindow:Hide()
							end)
						end
						local configurePluginButton = DF:NewButton (sectionFrame, _, "$parentConfigureStreamerPluginButton", "configureStreamerPlugin", 100, 20, configure_streamer_plugin, nil, nil, nil, "Action Tracker Options", nil, options_button_template)
						configurePluginButton:SetWidth (button_width)
						configurePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -7)
						
						--> text telling how to disable
						local pluginAlreadyEnabled = DF:NewLabel (sectionFrame, _, "$parentStreamerAlreadyEnabledText", "StreamerAlreadyEnabledTextLabel", "Plugin is enabled. You may disable it on Plugin Management section.", "GameFontNormal", 10, "white")
						pluginAlreadyEnabled:SetJustifyV ("top")
						pluginAlreadyEnabled:SetSize (270, 40)
						pluginAlreadyEnabled:SetPoint ("topleft", configurePluginButton, "bottomleft", 0, -7)
					else
						--> plugin isnt enabled, create the enable button
						local enable_streamer_plugin = function()
							tPluginSettings.enabled = true
							StreamerPlugin.__enabled = true
							_detalhes:SendEvent ("PLUGIN_ENABLED", StreamerPlugin)
							
							sectionFrame.enableStreamerPluginButton:Hide()
							
							--> config button
							local configure_streamer_plugin = function()
								StreamerPlugin.OpenOptionsPanel()
							end
							local configurePluginButton = DF:NewButton (sectionFrame, _, "$parentConfigureStreamerPluginButton", "configureStreamerPlugin", 100, 20, configure_streamer_plugin, nil, nil, nil, "Action Tracker Options", nil, options_button_template)
							configurePluginButton:SetWidth (button_width)
							configurePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -7)
							
							--> text telling how to disable
							local pluginAlreadyEnabled = DF:NewLabel (sectionFrame, _, "$parentStreamerAlreadyEnabledText", "StreamerAlreadyEnabledTextLabel", "Plugin is enabled. You may disable it on Plugin Management section.", "GameFontNormal", 10, "white")
							pluginAlreadyEnabled:SetJustifyV ("top")
							pluginAlreadyEnabled:SetSize (270, 40)
							pluginAlreadyEnabled:SetPoint ("topleft", configurePluginButton, "bottomleft", 0, -7)
						end
						
						local enablePluginButton = DF:NewButton (sectionFrame, _, "$parentEnableStreamerPluginButton", "enableStreamerPluginButton", 100, 20, enable_streamer_plugin, nil, nil, nil, "Enable Plugin", nil, options_button_template)
						enablePluginButton:SetWidth (button_width)
						enablePluginButton:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -5)
					end
				end
			else
				--> plugin is disabled at the addon control panel
				local pluginDisabled = DF:NewLabel (sectionFrame, _, "$parentStreamerDisabledText", "StreamerDisabledTextLabel", "Details!: Streamer Plugin is disabled on the AddOns Control Panel.", "GameFontNormal", 10, "red")
				pluginDisabled:SetSize (270, 40)
				pluginDisabled:SetPoint ("topleft", streamerTitleImage, "bottomleft", 0, -2)
			end
		
		
		--> event tracker
            DF:NewLabel (sectionFrame, _, "$parentEventTrackerAnchor", "eventTrackerAnchor", "Event Tracker", "GameFontNormal")
            sectionFrame.eventTrackerAnchor:SetPoint("topleft", sectionFrame, "topleft", startX, startY - 180)

			local eventTrackerTitleDesc = DF:NewLabel (sectionFrame, _, "$parentEventTrackerTitleDescText", "EventTrackerTitleDescTextLabel", "Show what's happening near you so the viewer can follow what's going on. Show cooldowns, CC, spell interruption. Useful on any group content.", "GameFontNormal", 10, "white")
			eventTrackerTitleDesc:SetJustifyV ("top")
			eventTrackerTitleDesc:SetSize (270, 40)
			eventTrackerTitleDesc:SetPoint ("topleft", sectionFrame.eventTrackerAnchor, "bottomleft", 0, -4)
			
			local eventTrackerTitleImage = DF:CreateImage (sectionFrame, [[Interface\AddOns\Details\images\icons2]], 256, 50, "overlay", {0.5, 1, 134/512, 184/512})
			eventTrackerTitleImage:SetPoint ("topleft", sectionFrame.eventTrackerAnchor, "bottomleft", 0, -40)
			
			--> enable feature checkbox
				DF:NewLabel (sectionFrame, _, "$parentEnableEventTrackerLabel", "EventTrackerLabel", "Enable Event Tracker", "GameFontHighlightLeft")
				DF:NewSwitch (sectionFrame, _, "$parentEventTrackerSlider", "EventTrackerSlider", 60, 20, _, _, _detalhes.event_tracker.enabled, nil, nil, nil, nil, options_switch_template)

				sectionFrame.EventTrackerSlider:SetPoint ("left", sectionFrame.EventTrackerLabel, "right", 2)
				sectionFrame.EventTrackerSlider:SetAsCheckBox()
				sectionFrame.EventTrackerSlider.OnSwitch = function (_, _, value)
					_detalhes.event_tracker.enabled = not _detalhes.event_tracker.enabled
					Details:LoadFramesForBroadcastTools()
					afterUpdate()
				end
				sectionFrame.EventTrackerLabel:SetPoint ("topleft", eventTrackerTitleImage, "bottomleft", 0, -20)
				sectionFrame.EventTrackerSlider:SetPoint ("left", sectionFrame.EventTrackerLabel, "right", 2, 0)
				
			--> configure feature button
				local configure_event_tracker = function()
					_detalhes:OpenEventTrackerOptions (true)
					C_Timer.After (0.2, function()
						_G.DetailsOptionsWindow:Hide()
					end)
				end
				local configureEventTrackerButton = DF:NewButton (sectionFrame, _, "$parentConfigureEventTrackerButton", "configureEventTracker", 100, 20, configure_event_tracker, nil, nil, nil, "Event Tracker Options", nil, options_button_template)
				configureEventTrackerButton:SetWidth (button_width)
				configureEventTrackerButton:SetPoint ("topleft", sectionFrame.EventTrackerLabel, "bottomleft", 0, -7)


		--> current dps
            DF:NewLabel (sectionFrame, _, "$parentCurrentDPSAnchor", "currentDPSAnchor", "The Real Current DPS", "GameFontNormal")
            sectionFrame.currentDPSAnchor:SetPoint("topleft", sectionFrame, "topleft", startX + 350, startY - 20)

			local currentDPSTitleDesc = DF:NewLabel (sectionFrame, _, "$parentCurrentDPSTitleDescText", "CurrentDPSTitleDescTextLabel", "Show a frame with DPS done only in the last 5 seconds. Useful for arena matches and mythic dungeons.", "GameFontNormal", 10, "white")
			currentDPSTitleDesc:SetJustifyV ("top")
			currentDPSTitleDesc:SetSize (270, 40)
			currentDPSTitleDesc:SetPoint ("topleft", sectionFrame.currentDPSAnchor, "bottomleft", 0, -4)
			
			local currentDPSTitleImage = DF:CreateImage (sectionFrame, [[Interface\AddOns\Details\images\icons2]], 250, 61, "overlay", {259/512, 509/512, 186/512, 247/512})
			currentDPSTitleImage:SetPoint ("topleft", sectionFrame.currentDPSAnchor, "bottomleft", 0, -40)
			
			--> enable feature checkbox
				DF:NewLabel (sectionFrame, _, "$parentEnableCurrentDPSLabel", "CurrentDPSLabel", "Enable The Real Current Dps", "GameFontHighlightLeft")
				DF:NewSwitch (sectionFrame, _, "$parentCurrentDPSSlider", "CurrentDPSSlider", 60, 20, _, _, _detalhes.current_dps_meter.enabled, nil, nil, nil, nil, options_switch_template)

				sectionFrame.CurrentDPSSlider:SetPoint ("left", sectionFrame.CurrentDPSLabel, "right", 2)
				sectionFrame.CurrentDPSSlider:SetAsCheckBox()
				sectionFrame.CurrentDPSSlider.OnSwitch = function (_, _, value)
					_detalhes.current_dps_meter.enabled = not _detalhes.current_dps_meter.enabled
					Details:LoadFramesForBroadcastTools()
					afterUpdate()
				end
				
				sectionFrame.CurrentDPSLabel:SetPoint ("topleft", currentDPSTitleImage, "bottomleft", 0, -10)
				sectionFrame.CurrentDPSSlider:SetPoint ("left", sectionFrame.CurrentDPSLabel, "right", 2, 0)
				
			--> configure feature button
				local configure_current_dps = function()
					_detalhes:OpenCurrentRealDPSOptions (true)
					C_Timer.After (0.2, function()
						_G.DetailsOptionsWindow:Hide()
					end)
				end
				local configureCurrentDPSButton = DF:NewButton (sectionFrame, _, "$parentConfigureCurrentDPSButton", "configureCurrentDPS", 100, 20, configure_current_dps, nil, nil, nil, "Current Real DPS Options", nil, options_button_template)
				configureCurrentDPSButton:SetWidth (button_width)
				configureCurrentDPSButton:SetPoint ("topleft", sectionFrame.CurrentDPSLabel, "bottomleft", 0, -7)



        local sectionOptions = {
            {type = "label", get = function() return Loc ["STRING_GERAL"] .. ":" end, text_template = subSectionTitleTextTemplate},

            {--no window alerts
                type = "toggle",
                get = function() return _detalhes.streamer_config.no_alerts end,
                set = function (self, fixedparam, value)
                    _detalhes.streamer_config.no_alerts = value
                    afterUpdate()
                end,
                name = "Suppress Alerts", --localize-me
                desc = "Suppress Alerts",
            },

            {--60hz updates
                type = "toggle",
                get = function() return _detalhes.streamer_config.faster_updates end,
                set = function (self, fixedparam, value)
                    _detalhes.streamer_config.faster_updates = value
                    _detalhes:RefreshUpdater()
                    afterUpdate()
                end,
                name = "60 Updates per Second", --localize-me
                desc = "60 Updates per Second",
            },

            {--quick player info
                type = "toggle",
                get = function() return _detalhes.streamer_config.quick_detection end,
                set = function (self, fixedparam, value)
                    _detalhes.streamer_config.quick_detection = value
                    afterUpdate()
                end,
                name = "Quick Player Info Detection", --localize-me
                desc = "Quick Player Info Detection",
            },

            {--disable M+ shenanigans
                type = "toggle",
                get = function() return _detalhes.streamer_config.disable_mythic_dungeon end,
                set = function (self, fixedparam, value)
                    _detalhes.streamer_config.disable_mythic_dungeon = value
                    afterUpdate()
                end,
                name = "Disable Mythic+ Stuff", --localize-me
                desc = "Disable Mythic+ Stuff",
            },

            {--disable M+ charts
                type = "toggle",
                get = function() return _detalhes.mythic_plus.show_damage_graphic end,
                set = function (self, fixedparam, value)
                    _detalhes.mythic_plus.show_damage_graphic = value
                    afterUpdate()
                end,
                name = "Disable Mythic+ Chart", --localize-me
                desc = "Disable Mythic+ Chart",
            },

            {--clear cache regurlary
                type = "toggle",
                get = function() return _detalhes.mythic_plus.show_damage_graphic end,
                set = function (self, fixedparam, value)
                    _detalhes.mythic_plus.show_damage_graphic = value
                    afterUpdate()
                end,
                name = "Clear Cache Regularly", --localize-me
                desc = "Clear Cache Regularly",
            },

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX + 350, startY - 20 - 200, heightSize + 300, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~16 ~customspells ~spells
do
    local buildSection = function(sectionFrame)

		local name_entry_func = function (index, text)
			_detalhes:UserCustomSpellUpdate (index, text) 
		end
		local icon_func = function (index, icon)
			_detalhes:UserCustomSpellUpdate (index, nil, icon)
		end
		local remove_func = function (index)
			_detalhes:UserCustomSpellRemove (index)
		end
		local reset_func = function (index)
			_detalhes:UserCustomSpellReset (index)
		end
	
	--> custom spells panel
		local header = {
			{name = Loc ["STRING_OPTIONS_SPELL_INDEX"], width = 55, type = "text"}, 
			{name = Loc ["STRING_OPTIONS_SPELL_NAME"], width = 310, type = "entry", func = name_entry_func}, 
			{name = Loc ["STRING_OPTIONS_SPELL_ICON"], width = 50, type = "icon", func = icon_func},
			{name = Loc ["STRING_OPTIONS_SPELL_SPELLID"], width = 100, type = "text"},
			{name = Loc ["STRING_OPTIONS_SPELL_RESET"], width = 50, type = "button", func = reset_func, icon = [[Interface\Buttons\UI-RefreshButton]], notext = true, iconalign = "center"}, 
			{name = Loc ["STRING_OPTIONS_SPELL_REMOVE"], width = 75, type = "button", func = remove_func, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], notext = true, iconalign = "center"}, 
		}

		local total_lines = function()
			return #_detalhes.savedCustomSpells
		end
		local fill_row = function (index)
			local data = _detalhes.savedCustomSpells [index]
			if (data) then
				return {index, data [2], data [3], data [1], ""}
			else
				return {nil, nil, nil, nil, nil}
			end
		end
		
		local panel = DF:NewFillPanel (sectionFrame, header, "$parentCustomSpellsFillPanel", "customSpellsFillPanel", 640, 462, total_lines, fill_row, false)
		panel:Refresh()
	
	--> add
		--> add panel
			local addframe = DF:NewPanel (sectionFrame, nil, "$parentCustomSpellsAddPanel", "customSpellsAddPanel", 644, 462)
			addframe:SetPoint (startX, startY - 40)
			addframe:SetFrameLevel (7)
			DF:ApplyStandardBackdrop(addframe)
			addframe:Hide()			

			local spellid = DF:NewLabel (addframe, nil, "$parentSpellidLabel", "spellidLabel", Loc ["STRING_OPTIONS_SPELL_ADDSPELLID"])
			local spellname = DF:NewLabel (addframe, nil, "$parentSpellnameLabel", "spellnameLabel", Loc ["STRING_OPTIONS_SPELL_ADDNAME"])
			local spellicon = DF:NewLabel (addframe, nil, "$parentSpelliconLabel", "spelliconLabel", Loc ["STRING_OPTIONS_SPELL_ADDICON"])
		
			local spellname_entry_func = function() end
			local spellname_entry = DF:NewTextEntry (addframe, nil, "$parentSpellnameEntry", "spellnameEntry", 160, 20, spellname_entry_func, nil, nil, nil, nil, options_dropdown_template)
			spellname_entry:SetPoint ("left", spellname, "right", 2, 0)

			local spellid_entry_func = function (arg1, arg2, spellid) 
				local spellname, _, icon = GetSpellInfo (spellid)
				if (spellname) then
					spellname_entry:SetText (spellname) 
					addframe.spellIconButton.icon.texture = icon
				else
					_detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_NOTFOUND"])
				end
			end
			local spellid_entry = DF:NewSpellEntry (addframe, spellid_entry_func, 160, 20, nil, nil, "spellidEntry", "$parentSpellidEntry")
			spellid_entry:SetTemplate (options_dropdown_template)
			spellid_entry:SetPoint ("left", spellid, "right", 2, 0)
			
			local icon_button_func = function (texture)
				addframe.spellIconButton.icon.texture = texture
			end
			local icon_button = DF:NewButton (addframe, nil, "$parentSpellIconButton", "spellIconButton", 20, 20, function() DF:IconPick (icon_button_func, true) end)
			local icon_button_icon = DF:NewImage (icon_button, [[Interface\ICONS\TEMP]], 19, 19, "background", nil, "icon", "$parentSpellIcon")
			icon_button_icon:SetPoint (0, 0)
			icon_button:InstallCustomTexture()
			icon_button:SetPoint ("left", spellicon, "right", 2, 0)
			
		--> close button
			local closebutton = DF:NewButton (addframe, nil, "$parentAddCloseButton", "addClosebutton", 120, 20, function() addframe:Hide() end, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_CLOSE"], nil, options_button_template)
			
		--> confirm add spell
			local addspell = function()
				local id = spellid_entry.text
				if (id == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_IDERROR"])
				end
				local name = spellname_entry.text
				if (name == "") then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_NAMEERROR"])
				end
				local icon = addframe.spellIconButton.icon.texture
				
				id = tonumber (id)
				if (not id) then
					return _detalhes:Msg (Loc ["STRING_OPTIONS_SPELL_IDERROR"])
				end
				
				_detalhes:UserCustomSpellAdd (id, name, icon)
				
				panel:Refresh()
				
				spellid_entry.text = ""
				spellname_entry.text = ""
				addframe.spellIconButton.icon.texture = [[Interface\ICONS\TEMP]]
				
				if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
					DetailsIconPickFrame:Hide()
				end
				addframe:Hide()
			end
			
			local addspellbutton = DF:NewButton (addframe, nil, "$parentAddSpellButton", "addSpellbutton", 120, 20, addspell, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_ADD"], nil, options_button_template)

			addspellbutton:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], 18, 18, nil, nil, nil, 4)
			closebutton:SetIcon ([[Interface\PetBattles\DeadPetIcon]], 14, 14, nil, nil, nil, 4)
			
			addspellbutton:SetPoint ("bottomright", addframe, "bottomright", -5, 5)
			closebutton:SetPoint ("right", addspellbutton, "left", -4, 0)

			spellid:SetPoint (50, -10)
			spellname:SetPoint (50, -35)
			spellicon:SetPoint (50, -60)
		
		--> open add panel button
			local add = function() 
				addframe:Show()
			end
			local addbutton = DF:NewButton (sectionFrame, nil, "$parentAddButton", "addbutton", 120, 20, add, nil, nil, nil, Loc ["STRING_OPTIONS_SPELL_ADDSPELL"], nil, options_button_template)
			addbutton:SetPoint ("bottomright", panel, "topright", -00, 1)
			addbutton:SetIcon ([[Interface\PaperDollInfoFrame\Character-Plus]], 12, 12, nil, nil, nil, 4)

		panel:SetPoint (startX, startY - 40)
		
	--> consilidade spells
		DF:NewLabel (sectionFrame, _, "$parentConsolidadeSpellsLabel", "ConsolidadeSpellsLabel", Loc ["STRING_OPTIONSMENU_SPELLS_CONSOLIDATE"], "GameFontHighlightLeft")
		DF:NewSwitch (sectionFrame, _, "$parentConsolidadeSpellsSwitch", "ConsolidadeSpellsSwitch", 60, 20, nil, nil, _detalhes.override_spellids, nil, nil, nil, nil, options_switch_template)
		sectionFrame.ConsolidadeSpellsLabel:SetPoint ("left", sectionFrame.ConsolidadeSpellsSwitch, "right", 3)
		sectionFrame.ConsolidadeSpellsSwitch:SetAsCheckBox()
		sectionFrame.ConsolidadeSpellsSwitch.OnSwitch = function (self, instance, value)
			_detalhes.override_spellids = value
			_detalhes:UpdateParserGears()
		end

		sectionFrame.ConsolidadeSpellsSwitch:SetPoint (startX, startY - 20)
        _detalhes:SetFontSize (sectionFrame.ConsolidadeSpellsLabel, 12)
        
        local sectionOptions = {

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


-- ~17 ~charts data
do
    local buildSection = function(sectionFrame)

	--> title
    local titulo_datacharts = DF:NewLabel (sectionFrame, _, "$parentTituloDataChartsText", "DataChartsLabel", Loc ["STRING_OPTIONS_DATACHARTTITLE"], "GameFontNormal", 16)
    local titulo_datacharts_desc = DF:NewLabel (sectionFrame, _, "$parentDataChartsText2", "DataCharts2Label", Loc ["STRING_OPTIONS_DATACHARTTITLE_DESC"], "GameFontNormal", 10, "white")
    titulo_datacharts_desc.width = 350

--> warning
    if (not _detalhes:GetPlugin ("DETAILS_PLUGIN_CHART_VIEWER")) then
        local label = DF:NewLabel (sectionFrame, _, "$parentPluginWarningLabel", "PluginWarningLabel", Loc ["STRING_OPTIONS_CHART_PLUGINWARNING"], "GameFontNormal")
        local image = DF:NewImage (sectionFrame, [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]])
        label:SetPoint ("topright", sectionFrame, "topright", -42, -10)
        label:SetJustifyH ("left")
        label:SetWidth (160)
        image:SetPoint ("right", label, "left", -7, 0)	
        image:SetSize (32, 32)
    end

--> panel
    local edit_name = function (index, name)
        _detalhes:TimeDataUpdate (index, name)
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    
    local big_code_editor = DF:NewSpecialLuaEditorEntry (sectionFrame, 683, 422, "bigCodeEditor", "$parentBigCodeEditor")
    big_code_editor:SetPoint ("topleft", sectionFrame, "topleft", startX, startY - 70)
    big_code_editor:SetFrameLevel (sectionFrame:GetFrameLevel()+6)
    big_code_editor:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
    DF:ReskinSlider (big_code_editor.scroll)
    big_code_editor:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
    big_code_editor:SetBackdropBorderColor (0, 0, 0, 1)
    big_code_editor:Hide()
    
    local accept = function()
        big_code_editor:ClearFocus()
        if (not big_code_editor.is_export) then
            _detalhes:TimeDataUpdate (big_code_editor.index, nil, big_code_editor:GetText())
        end
        big_code_editor:Hide()
    end
    local cancel = function()
        big_code_editor:ClearFocus()
        big_code_editor:Hide()
    end

    local accept_changes = DF:NewButton (big_code_editor, nil, "$parentAccept", "acceptButton", 120, 20, accept, nil, nil)
    accept_changes:SetPoint (0, 20)
    accept_changes:SetIcon([[Interface\Buttons\UI-CheckBox-Check]])
    accept_changes:SetTemplate(options_button_template)
    accept_changes:SetText(Loc ["STRING_OPTIONS_CHART_SAVE"])
    
    local cancel_changes = DF:NewButton (big_code_editor, nil, "$parentCancel", "CancelButton", 120, 20, cancel, nil, nil)
    cancel_changes:SetPoint ("left", accept_changes, "right", 2, 0)
    cancel_changes:SetIcon([[Interface\PetBattles\DeadPetIcon]])
    cancel_changes:SetTemplate(options_button_template)
    cancel_changes:SetText(Loc ["STRING_OPTIONS_CHART_CANCEL"])

    local edit_code = function (index)
        local data = _detalhes.savedTimeCaptures [index]
        if (data) then
            local func = data [2]
            
            if (type (func) == "function") then
                return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_CODELOADED"])
            end
            
            big_code_editor:SetText (func)
            big_code_editor.original_code = func
            big_code_editor.index = index
            big_code_editor.is_export = nil
            big_code_editor:Show()
            
            sectionFrame.userTimeCaptureAddPanel:Hide()
            sectionFrame.importEditor:ClearFocus()
            sectionFrame.importEditor:Hide()
            if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
                DetailsIconPickFrame:Hide()
            end
        end
    end
    
    local edit_icon = function (index, icon)
        _detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, icon)
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    local edit_author = function (index, author)
        _detalhes:TimeDataUpdate (index, nil, nil, nil, author)
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    local edit_version = function (index, version)
        _detalhes:TimeDataUpdate (index, nil, nil, nil, nil, version)
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    
    local big_code_editor2 = DF:NewSpecialLuaEditorEntry (sectionFrame, 643, 402, "exportEditor", "$parentExportEditor", true)
    big_code_editor2:SetPoint ("topleft", sectionFrame, "topleft", 7, -70)
    big_code_editor2:SetFrameLevel (sectionFrame:GetFrameLevel()+6)
    big_code_editor2:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
    DF:ReskinSlider (big_code_editor2.scroll)
    big_code_editor2:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
    big_code_editor2:SetBackdropBorderColor (0, 0, 0, 1)
    big_code_editor2:Hide()
    
    local close_export_box = function()
        big_code_editor2:ClearFocus()
        big_code_editor2:Hide()
    end
    
    local close_export = DF:NewButton (big_code_editor2, nil, "$parentClose", "closeButton", 120, 20, close_export_box)
    close_export:SetPoint (10, 18)
    close_export:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]])
    close_export:SetText (Loc ["STRING_OPTIONS_CHART_CLOSE"])
    close_export:SetTemplate (options_button_template)
    
    local export_function = function (index)
        local data = _detalhes.savedTimeCaptures [index]
        if (data) then
            local encoded = Details:CompressData (data, "print")
            if (encoded) then
                big_code_editor2:SetText (encoded)
                
                big_code_editor2:Show()
                big_code_editor2.editbox:HighlightText()
                big_code_editor2.editbox:SetFocus (true)
            else
                Details:Msg ("error exporting the time capture.") --localize-me
            end
        end
    end
    
    local remove_capture = function (index)
        _detalhes:TimeDataUnregister (index)
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    
    local edit_enabled = function (index, enabled, a, b)
        if (enabled) then
            _detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, nil, false)
        else
            _detalhes:TimeDataUpdate (index, nil, nil, nil, nil, nil, nil, true)
        end
        
        sectionFrame.userTimeCaptureFillPanel:Refresh()
    end
    
    local header = {
        {name = Loc ["STRING_OPTIONS_CHART_NAME"], width = 175, type = "entry", func = edit_name},
        {name = Loc ["STRING_OPTIONS_CHART_EDIT"], width = 55, type = "button", func = edit_code, icon = [[Interface\Buttons\UI-GuildButton-OfficerNote-Disabled]], notext = true, iconalign = "center"},
        {name = Loc ["STRING_OPTIONS_CHART_ICON"], width = 50, type = "icon", func = edit_icon},
        {name = Loc ["STRING_OPTIONS_CHART_AUTHOR"], width = 125, type = "text", func = edit_author},
        {name = Loc ["STRING_OPTIONS_CHART_VERSION"], width = 65, type = "entry", func = edit_version},
        {name = Loc ["STRING_ENABLED"], width = 50, type = "button", func = edit_enabled, icon = [[Interface\COMMON\Indicator-Green]], notext = true, iconalign = "center"},
        {name = Loc ["STRING_OPTIONS_CHART_EXPORT"], width = 50, type = "button", func = export_function, icon = [[Interface\Buttons\UI-GuildButton-MOTD-Up]], notext = true, iconalign = "center"},
        {name = Loc ["STRING_OPTIONS_CHART_REMOVE"], width = 70, type = "button", func = remove_capture, icon = [[Interface\Glues\LOGIN\Glues-CheckBox-Check]], notext = true, iconalign = "center"},
    }
    
    local total_lines = function()
        return #_detalhes.savedTimeCaptures
    end
    local fill_row = function (index)
        local data = _detalhes.savedTimeCaptures [index]
        if (data) then
        
            local enabled_texture
            if (data[7]) then
                enabled_texture = [[Interface\COMMON\Indicator-Green]]
            else
                enabled_texture = [[Interface\COMMON\Indicator-Red]]
            end

            return {
                data[1], --name
                "", --func
                data[6], --icon
                data[4], -- author
                data[5], --version
                {func = edit_enabled, icon = enabled_texture, value = data[7]} --enabled
            }
        else
            return {nil, nil, nil, nil, nil, nil}
        end
    end

    --DetailsOptionsWindowtab17UserTimeCapturesFillPanel
    local panel = DF:NewFillPanel (sectionFrame, header, "$parentUserTimeCapturesFillPanel", "userTimeCaptureFillPanel", 640, 382, total_lines, fill_row, false)

    panel:SetHook ("OnMouseDown", function()
        if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
            DetailsIconPickFrame:Hide()
        end
    end)
    
    panel:Refresh()
    
    --> add panel
        local addframe = DF:NewPanel (sectionFrame, nil, "$parentUserTimeCapturesAddPanel", "userTimeCaptureAddPanel", 683, 422)
        addframe:SetPoint ("topleft", sectionFrame, "topleft", startX, startY - 70)
        addframe:SetFrameLevel (7)
        addframe:Hide()

        addframe:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
        addframe:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
        addframe:SetBackdropBorderColor (0, 0, 0, 1)

        --> name
            local capture_name = DF:NewLabel (addframe, nil, "$parentNameLabel", "nameLabel", Loc ["STRING_OPTIONS_CHART_ADDNAME"])
            local capture_name_entry = DF:NewTextEntry (addframe, nil, "$parentNameEntry", "nameEntry", 160, 20, function() end, nil, nil, nil, nil, options_dropdown_template)
            capture_name_entry:SetMaxLetters (16)
            capture_name_entry:SetPoint ("left", capture_name, "right", 2, 0)
        
        --> function
            local capture_func = DF:NewLabel (addframe, nil, "$parentFunctionLabel", "functionLabel", Loc ["STRING_OPTIONS_CHART_ADDCODE"])
            local capture_func_entry = DF:NewSpecialLuaEditorEntry (addframe.widget, 300, 200, "funcEntry", "$parentFuncEntry")
            capture_func_entry:SetPoint ("topleft", capture_func.widget, "topright", 2, 0)
            capture_func_entry:SetSize (500, 220)
            capture_func_entry:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
            capture_func_entry:SetBackdropBorderColor (0, 0, 0, 1)
            capture_func_entry:SetBackdropColor (0, 0, 0, .5)
            DF:ReskinSlider (capture_func_entry.scroll)
            
        --> icon
            local capture_icon = DF:NewLabel (addframe, nil, "$parentIconLabel", "iconLabel", Loc ["STRING_OPTIONS_CHART_ADDICON"])
            local icon_button_func = function (texture)
                addframe.iconButton.iconTexture = texture
                addframe.iconButton:SetIcon(texture)
            end
            local capture_icon_button = DF:NewButton (addframe, nil, "$parentIconButton", "iconButton", 20, 20, function() DF:IconPick (icon_button_func, true) end, nil, nil, nil, nil, nil, options_button_template)
            capture_icon_button:SetIcon([[Interface\ICONS\TEMP]])
            capture_icon_button:SetTemplate(options_button_template)
            capture_icon_button:SetPoint ("left", capture_icon, "right", 2, 0)
        
        --> author
            local capture_author = DF:NewLabel (addframe, nil, "$parentAuthorLabel", "authorLabel", Loc ["STRING_OPTIONS_CHART_ADDAUTHOR"])
            local capture_author_entry = DF:NewTextEntry (addframe, nil, "$parentAuthorEntry", "authorEntry", 160, 20, function() end, nil, nil, nil, nil, options_dropdown_template)
            capture_author_entry:SetPoint ("left", capture_author, "right", 2, 0)
            
        --> version
            local capture_version = DF:NewLabel (addframe, nil, "$parentVersionLabel", "versionLabel", Loc ["STRING_OPTIONS_CHART_ADDVERSION"])
            local capture_version_entry = DF:NewTextEntry (addframe, nil, "$parentVersionEntry", "versionEntry", 160, 20, function() end, nil, nil, nil, nil, options_dropdown_template)
            capture_version_entry:SetPoint ("left", capture_version, "right", 2, 0)
    
    --> open add panel button
        local add = function() 
            addframe:Show()
            sectionFrame.importEditor:ClearFocus()
            sectionFrame.importEditor:Hide()
            big_code_editor:ClearFocus()
            big_code_editor:Hide()
            big_code_editor2:ClearFocus()
            big_code_editor2:Hide()
            if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
                DetailsIconPickFrame:Hide()
            end
        end
        
        local addbutton = DF:NewButton (sectionFrame, nil, "$parentAddButton", "addbutton", 120, 20, add, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_ADD"], nil, options_button_template)
        addbutton:SetPoint ("bottomright", panel, "topright", -30, 0)
        addbutton:SetIcon ([[Interface\PaperDollInfoFrame\Character-Plus]], 12, 12, nil, nil, nil, 4)
        
    --> open import panel button
    
        local importframe = DF:NewSpecialLuaEditorEntry (sectionFrame, 683, 422, "importEditor", "$parentImportEditor", true)
        local font, size, flag = importframe.editbox:GetFont()
        importframe.editbox:SetFont (font, 9, flag)
        importframe:SetPoint ("topleft", sectionFrame, "topleft", startX, startY - 70)
        importframe:SetFrameLevel (sectionFrame:GetFrameLevel()+6)
        importframe:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1,tile = 1, tileSize = 16})
        DF:ReskinSlider(importframe.scroll)
        importframe:SetBackdropColor (0.5, 0.5, 0.5, 0.95)
        importframe:SetBackdropBorderColor (0, 0, 0, 1)
        importframe:Hide()
        
        local doimport = function()
            local text = importframe:GetText()
            
            text = DF:Trim (text)

            local dataTable = Details:DecompressData (text, "print")
            if (dataTable) then
                local unserialize = dataTable
                
                if (type (unserialize) == "table") then
                    if (unserialize[1] and unserialize[2] and unserialize[3] and unserialize[4] and unserialize[5]) then
                        local register = _detalhes:TimeDataRegister (unpack (unserialize))
                        if (type (register) == "string") then
                            _detalhes:Msg (register)
                        end
                    else
                        _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_IMPORTERROR"])
                    end
                else
                    _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_IMPORTERROR"])
                end
                
                importframe:Hide()
                panel:Refresh()
            else
                _detalhes:Msg (Loc ["STRING_CUSTOM_IMPORT_ERROR"])
                return
            end
        end

        local accept_import = DF:NewButton (importframe, nil, "$parentAccept", "acceptButton", 120, 20, doimport)
        accept_import:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]])
        accept_import:SetPoint (10, 18)
        accept_import:SetText (Loc ["STRING_OPTIONS_CHART_IMPORT"])
        accept_import:SetTemplate (options_button_template)
        
        local cancelimport = function()
            importframe:ClearFocus()
            importframe:Hide()
        end
        
        local cancel_changes = DF:NewButton (importframe, nil, "$parentCancel", "CancelButton", 120, 20, cancelimport)
        cancel_changes:SetIcon ([[Interface\PetBattles\DeadPetIcon]])
        cancel_changes:SetText (Loc ["STRING_OPTIONS_CHART_CANCEL"])
        cancel_changes:SetPoint (132, 18)
        cancel_changes:SetTemplate (options_button_template)
    
        local import = function() 
            importframe:Show()
            importframe:SetText ("")
            importframe:SetFocus (true)
            addframe:Hide()
            big_code_editor:ClearFocus()
            big_code_editor:Hide()
            big_code_editor2:ClearFocus()
            big_code_editor2:Hide()
            if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
                DetailsIconPickFrame:Hide()
            end
        end
        
        local importbutton = DF:NewButton (sectionFrame, nil, "$parentImportButton", "importbutton", 120, 20, import, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_IMPORT"], nil, options_button_template)
        importbutton:SetPoint ("right", addbutton, "left", -4, 0)
        importbutton:SetIcon ([[Interface\Buttons\UI-GuildButton-PublicNote-Up]], 14, 14, nil, nil, nil, 4)

    --> close button
        local closebutton = DF:NewButton (addframe, nil, "$parentAddCloseButton", "addClosebutton", 120, 20, function() addframe:Hide() end, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_CLOSE"], nil, options_button_template)
        --closebutton:InstallCustomTexture()
        
    --> confirm add capture
        local addcapture = function()
            local name = capture_name_entry.text
            if (name == "") then
                return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_NAMEERROR"])
            end
            
            local author = capture_author_entry.text
            if (author == "") then
                return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_AUTHORERROR"])
            end
            
            local icon = addframe.iconButton.iconTexture
            
            local version = capture_version_entry.text
            if (version == "") then
                return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_VERSIONERROR"])
            end
            
            local func = capture_func_entry:GetText()
            if (func == "") then
                return _detalhes:Msg (Loc ["STRING_OPTIONS_CHART_FUNCERROR"])
            end
            
            _detalhes:TimeDataRegister (name, func, nil, author, version, icon, true)
            
            panel:Refresh()
            
            capture_name_entry.text = ""
            capture_author_entry.text = ""
            capture_version_entry.text = ""
            capture_func_entry:SetText ("")
            addframe.iconButton:SetTexture([[Interface\ICONS\TEMP]])
            
            if (DetailsIconPickFrame and DetailsIconPickFrame:IsShown()) then
                DetailsIconPickFrame:Hide()
            end
            addframe:Hide()

        end
        
        local addcapturebutton = DF:NewButton (addframe, nil, "$parentAddCaptureButton", "addCapturebutton", 120, 21, addcapture, nil, nil, nil, Loc ["STRING_OPTIONS_CHART_ADD2"], nil, options_button_template)

    --> anchors
        local start = 25
        capture_name:SetPoint (start, startY)
        capture_icon:SetPoint (start, -55)
        capture_author:SetPoint (start, -80)
        capture_version:SetPoint (start, -105)
        capture_func:SetPoint (start, -130)
        
        addcapturebutton:SetIcon ([[Interface\Buttons\UI-CheckBox-Check]], 18, 18, nil, nil, nil, 4)
        closebutton:SetIcon ([[Interface\PetBattles\DeadPetIcon]], 14, 14, nil, nil, nil, 4)
        
        addcapturebutton:SetTemplate (options_button_template)
        closebutton:SetTemplate (options_button_template)
        
        addcapturebutton:SetPoint ("bottomright", addframe, "bottomright", -5, 5)
        closebutton:SetPoint ("right", addcapturebutton, "left", -4, 0)			

--> anchors
        titulo_datacharts:SetPoint (startX, startY)
        titulo_datacharts_desc:SetPoint (startX, startY - 20)
        panel:SetPoint (startX, startY - 70)

        local sectionOptions = {

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end

do
    local buildSection = function(sectionFrame)

        local sectionOptions = {
            {type = "label", get = function() return Loc["STRING_OPTIONS_GENERAL_ANCHOR"] end, text_template = subSectionTitleTextTemplate},
            {--always in combat
                type = "toggle",
                get = function() return Details.mythic_plus.always_in_combat end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.always_in_combat = value
                end,
                name = "Always in Combat",
                desc = "Details won't create new segments for trash or boss and treat the run as a single segment.",
            },

            {--dedicated segment for bosses
                type = "toggle",
                get = function() return Details.mythic_plus.boss_dedicated_segment end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.boss_dedicated_segment = value
                end,
                name = "Boss Dedicated Segment",
                desc = "If a boss is pulled while in combat, Details! close the combat and start a new one for the boss.",
            },

            {--make overall when done
                type = "toggle",
                get = function() return Details.mythic_plus.make_overall_when_done end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.make_overall_when_done = value
                end,
                name = "Make Overall Segment",
                desc = "When the run is done, make an overall segment.",
            },

            {--overall only with bosses
                type = "toggle",
                get = function() return Details.mythic_plus.make_overall_boss_only end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.make_overall_boss_only = value
                end,
                name = "Overall Segment Boss Only",
                desc = "Only add boss segments on the overall.",
            },

            {--merge trash
                type = "toggle",
                get = function() return Details.mythic_plus.merge_boss_trash end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.merge_boss_trash = value
                end,
                name = "Merge Trash",
                desc = "Merge Trash",
            },

            {--delete merged trash
                type = "toggle",
                get = function() return Details.mythic_plus.delete_trash_after_merge end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.delete_trash_after_merge = value
                end,
                name = "Delete Merged Trash Segments",
                desc = "After have the segment merged, if this option is enabled it'll delete those merged segments.",
            },            

            {--show chart popup
                type = "toggle",
                get = function() return Details.mythic_plus.show_damage_graphic end,
                set = function (self, fixedparam, value)
                    Details.mythic_plus.show_damage_graphic = value
                end,
                name = "Show Damage Charts",
                desc = "Show Damage Charts",
            },


        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end


--[[]
do
    local buildSection = function(sectionFrame)

        local sectionOptions = {

        }

        DF:BuildMenu(sectionFrame, sectionOptions, startX, startY-20, heightSize, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
    end

    tinsert(Details.optionsSection, buildSection)
end
--]]
