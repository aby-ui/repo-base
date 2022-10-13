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
                picons = {
                    type = "description",
                    width = 0.9,
                    name = L["config_picons"],
                    fontSize = "medium",
                    order = 33,
                },
                picons_vendor = {
                    type = "toggle",
                    width = 0.5,
                    name = L["config_vendor"],
                    desc = L["config_picons_vendor_desc"],
                    order = 33.1,
                },
                picons_trainer = {
                    type = "toggle",
                    width = 0.6,
                    name = L["config_trainer"],
                    desc = L["config_picons_trainer_desc"],
                    order = 33.2,
                },
                fmaster_waypoint = {
                    type = "toggle",
                    width = 1.3,
                    name = L["config_fmaster_waypoint"],
                    desc = L["config_fmaster_waypoint_desc"],
                    order = 34,
                },
                fmaster_waypoint_dropdown = {
                    type = "select",
                    values = { L["Blizzard"], L["TomTom"], L["Both"] },
                    disabled = function() return not private.db.fmaster_waypoint end,
                    hidden = function() return not IsAddOnLoaded("TomTom") end,
                    name = L["config_waypoint_dropdown"],
                    desc = L["config_waypoint_dropdown_desc"],
                    width = 0.7,
                    order = 35,
                },
                easy_waypoint = {
                    type = "toggle",
                    width = 1.3,
                    name = L["config_easy_waypoints"],
                    desc = L["config_easy_waypoints_desc"],
                    order = 36,
                },
                easy_waypoint_dropdown = {
                    type = "select",
                    values = { L["Blizzard"], L["TomTom"], L["Both"] },
                    disabled = function() return not private.db.easy_waypoint end,
                    hidden = function() return not IsAddOnLoaded("TomTom") end,
                    name = L["config_waypoint_dropdown"],
                    desc = L["config_waypoint_dropdown_desc"],
                    width = 0.7,
                    order = 37,
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
                        print("Oribos: "..L["config_restore_nodes_print"])
                    end,
                    order = 38,
                },
            },
            },
        },
    },
    SCALEALPHA = {
        type = "group",
        name = L["config_tab_scale_alpha"],
        -- desc = L["config_scale_alpha_desc"],
        order = 1,
        args = {
        },
    },
    },
}

-- create the general config menu
for i, icongroup in ipairs(private.constants.icongroup) do

    config.options.args.ICONDISPLAY.args.display.args["show_"..icongroup] = {
        type = "toggle",
        name = L["config_"..icongroup],
        desc = L["config_"..icongroup.."_desc"],
        order = i+2,
    }

end

-- set some parameters for general config menu points
local gcmp = config.options.args.ICONDISPLAY.args.display.args
gcmp.show_auctioneer["hidden"] = function() return not addon:CharacterHasProfession(202) end

gcmp.show_portal["name"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") and L["config_portal"].." |cFFFF0000(*)|r" or L["config_portal"] end
gcmp.show_portal["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end

gcmp.show_portaltrainer["hidden"] = function() return not (select(2, UnitClass("player")) == "MAGE") end

gcmp.show_tpplatform["name"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") and L["config_tpplatform"].." |cFFFF0000(*)|r" or L["config_tpplatform"] end
gcmp.show_tpplatform["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end

-- create the scale / alpha config menu
for i, icongroup in ipairs(private.constants.icongroup) do

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
        width = 1.07,
        order = i *10 + 1,
    }

    config.options.args.SCALEALPHA.args["icon_alpha_"..icongroup] = {
        type = "range",
        name = L["config_icon_alpha"],
        desc = L["config_icon_alpha_desc"],
        min = 0, max = 1, step = 0.01,
        arg = "icon_alpha_"..icongroup,
        width = 1.07,
        order = i *10 + 2,
    }
end

-- set some parameters for scale / alpha config menu points
local sacmp = config.options.args.SCALEALPHA.args
sacmp.name_auctioneer["hidden"] = function() return not addon:CharacterHasProfession(202) end
sacmp.icon_scale_auctioneer["hidden"] = function() return not addon:CharacterHasProfession(202) end
sacmp.icon_alpha_auctioneer["hidden"] = function() return not addon:CharacterHasProfession(202) end

sacmp.name_portal["name"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") and L["config_portal"].." |cFFFF0000(*)|r" or L["config_portal"] end
sacmp.icon_scale_portal["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end
sacmp.icon_alpha_portal["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end

sacmp.name_portaltrainer["hidden"] = function() return not (select(2, UnitClass("player")) == "MAGE") end
sacmp.icon_scale_portaltrainer["hidden"] = function() return not (select(2, UnitClass("player")) == "MAGE") end
sacmp.icon_alpha_portaltrainer["hidden"] = function() return not (select(2, UnitClass("player")) == "MAGE") end

sacmp.name_tpplatform["name"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") and L["config_tpplatform"].." |cFFFF0000(*)|r" or L["config_tpplatform"] end
sacmp.icon_scale_tpplatform["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end
sacmp.icon_alpha_tpplatform["disabled"] = function() return IsAddOnLoaded("HandyNotes_TravelGuide") end
