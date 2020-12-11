----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...
local addon = LibStub("AceAddon-3.0"):GetAddon(FOLDER_NAME)
local L = private.locale

addon.pluginName  = L["config_plugin_name"]
addon.description = L["config_plugin_desc"]

----------------------------------------------------------------------------------------------------
-----------------------------------------------CONFIG-----------------------------------------------
----------------------------------------------------------------------------------------------------

local config = {}
private.config = config

config.options = {
    type = "group",
    name = addon.pluginName,
    desc = addon.description,
    childGroups = "tab",
    get = function(info) return private.db[info[#info]] end,
    set = function(info, v)
        private.db[info[#info]] = v
        addon:SendMessage("HandyNotes_NotifyUpdate", addon.pluginName)
    end,
    args = {
    ICONDISPLAY = {
        type = "group",
        name = L["config_tab_general"],
--      desc = L[""],
        order = 0,
        args = {
            display = {
            type = "group",
            name = L["config_what_to_display"],
            inline = true,
            order = 10,
            args = {
                desc = {
                    type = "description",
                    name = L["config_what_to_display_desc"],
                    order = 1,
                },
                icon_scale = {
                    type = "range",
                    name = L["config_icon_scale"],
                    desc = L["config_icon_scale_desc"],
                    min = 0.25, max = 3, step = 0.01,
                    width = 1,
                    order = 2,
                },
                icon_alpha = {
                    type = "range",
                    name = L["config_icon_alpha"],
                    desc = L["config_icon_alpha_desc"],
                    min = 0, max = 1, step = 0.01,
                    width = 1,
                    order = 2.1,
                },
                show_auctioneer = {
                    type = "toggle",
                    name = L["config_auctioneer"],
                    desc = L["config_auctioneer_desc"],
                    order = 3,
                    hidden = function() return not addon:CharacterHasProfession(202) end,
                },
                show_portal = {
                    type = "toggle",
                    name = function()
                        if not IsAddOnLoaded("HandyNotes_TravelGuide") then
                            return L["config_portal"]
                        else
                            return L["config_portal"].." |cFFFF0000(*)|r"
                        end
                    end,
                    desc = L["config_portal_desc"],
                    order = 28,
                    disabled = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end,
                },
                show_tpplatform = {
                    type = "toggle",
                    name = function()
                        if not IsAddOnLoaded("HandyNotes_TravelGuide") then
                            return L["config_tpplatforms"]
                        else
                            return L["config_tpplatforms"].." |cFFFF0000(*)|r"
                        end
                    end,
                    desc = L["config_tpplatforms_desc"],
                    order = 29,
                    disabled = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end,
                },
                desc2 = {
                    type = "description",
                    name = L["config_travelguide_note"],
                    hidden = function()
                        return not IsAddOnLoaded("HandyNotes_TravelGuide")
                    end,
                    order = 30,
                },
                other_line = {
                    type = "header",
                    name = "",
                    order = 31,
                },
                show_onlymytrainers = {
                    type = "toggle",
                    width = "full",
                    name = L["config_onlymytrainers"],
                    desc = L["config_onlymytrainers_desc"],
                    order = 32,
                },
                fmaster_waypoint = {
                    type = "toggle",
                    width = 1.3,
                    name = L["config_fmaster_waypoint"],
                    desc = L["config_fmaster_waypoint_desc"],
                    order = 33,
                },
                fmaster_waypoint_dropdown = {
                    type = "select",
                    values = { L["Blizzard"], L["TomTom"], L["Both"] },
                    disabled = function() return not private.db.fmaster_waypoint end,
                    hidden = function() return not IsAddOnLoaded("TomTom") end,
                    name = L["config_fmaster_waypoint_dropdown"],
                    desc = L["config_fmaster_waypoint_dropdown_desc"],
                    width = 0.7,
                    order = 34,
                },
                easy_waypoint = {
                    type = "toggle",
                    width = "full",
                    name = function()
                        if IsAddOnLoaded("TomTom") then
                            return L["config_easy_waypoints"]
                        else
                            return L["config_easy_waypoints"].." |cFFFF0000("..L["handler_tooltip_requires"].." TomTom)|r"
                        end
                    end,
                    disabled = function() return not IsAddOnLoaded("TomTom") end,
                    desc = L["config_easy_waypoints_desc"],
                    order = 35,
                },
                unhide = {
                    type = "execute",
                    width = "full",
                    name = L["config_restore_nodes"],
                    desc = L["config_restore_nodes_desc"],
                    func = function()
                        for map,coords in pairs(private.hidden) do
                            wipe(coords)
                        end
                        addon:Refresh()
                        print("Covenant Sanctum: "..L["config_restore_nodes_print"])
                    end,
                    order = 36,
                },
            },
            },
        },
    },
--    SCALEALPHA = {
--        type = "group",
--        name = L["config_tab_scale_alpha"],
--        desc = L["config_scale_alpha_desc"],
--        order = 1,
--        args = {
--
--        },
--    },
    },
}

local icongroup = {
    "banker", "barber", "innkeeper", "mail", "reforge", "stablemaster",
    "trainer", "transmogrifier", "vendor", "void", "others"
}

for i, icongroup in ipairs(icongroup) do

    config.options.args.ICONDISPLAY.args.display.args["show_"..icongroup] = {
        type = "toggle",
        name = L["config_"..icongroup],
        desc = L["config_"..icongroup.."_desc"],
        order = i+2,
    }

end

--[[
for i, icongroup in ipairs(icongroup) do

    config.options.args.SCALEALPHA.args["name_"..icongroup] = {
        type = "header",
        name = L["config_"..icongroup],
        order = i *10,
    }

    config.options.args.SCALEALPHA.args["icon_scale_"..icongroup] = {
        type = "range",
        name = L["config_icon_scale"],
        desc = L["config_icon_scale_desc"],
        min = 0.25, max = 3, step = 0.01,
        arg = "icon_scale_"..icongroup,
        width = 1.13,
        order = i *10 + 1,
    }

    config.options.args.SCALEALPHA.args["icon_alpha_"..icongroup] = {
        type = "range",
        name = L["config_icon_alpha"],
        desc = L["config_icon_alpha_desc"],
        min = 0, max = 1, step = 0.01,
        arg = "icon_alpha_"..icongroup,
        width = 1.13,
        order = i *10 + 2,
    }
end
]]