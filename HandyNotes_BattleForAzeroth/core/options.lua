-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale

-------------------------------------------------------------------------------
---------------------------------- DEFAULTS -----------------------------------
-------------------------------------------------------------------------------

ns.optionDefaults = {
    profile = {
        show_worldmap_button = true,

        -- visibility
        hide_done_rares = false,
        hide_minimap = false,
        maximized_enlarged = true,
        show_completed_nodes = false,
        use_char_achieves = false,
        per_map_settings = false,

        -- tooltip
        show_loot = true,
        show_notes = true,

        -- rewards
        show_mount_rewards = true,
        show_pet_rewards = true,
        show_toy_rewards = true,
        show_transmog_rewards = true,

        -- development
        development = false,
        show_debug_map = false,
        show_debug_quest = false,
        force_nodes = false,

        -- poi/path scale
        poi_scale = 1,

        -- poi color
        poi_color_R = 0,
        poi_color_G = 0.5,
        poi_color_B = 1,
        poi_color_A = 1,

        -- path color
        path_color_R = 0,
        path_color_G = 0.5,
        path_color_B = 1,
        path_color_A = 1
    },
}

-------------------------------------------------------------------------------
----------------------------------- HELPERS -----------------------------------
-------------------------------------------------------------------------------

function ns:GetOpt(n) return ns.addon.db.profile[n] end
function ns:SetOpt(n, v) ns.addon.db.profile[n] = v; ns.addon:Refresh() end

function ns:GetColorOpt(n)
    local db = ns.addon.db.profile
    return db[n..'_R'], db[n..'_G'], db[n..'_B'], db[n..'_A']
end

function ns:SetColorOpt(n, r, g, b, a)
    local db = ns.addon.db.profile
    db[n..'_R'], db[n..'_G'], db[n..'_B'], db[n..'_A'] = r, g, b, a
    ns.addon:Refresh()
end

-------------------------------------------------------------------------------
--------------------------------- OPTIONS UI ----------------------------------
-------------------------------------------------------------------------------

ns.options = {
    type = "group",
    name = nil, -- populated in core.lua
    childGroups = "tab",
    get = function(info) return ns:GetOpt(info.arg) end,
    set = function(info, v) ns:SetOpt(info.arg, v) end,
    args = {
        GeneralTab = {
            type = "group",
            name = L["options_general_settings"],
            desc = L["options_general_description"],
            order = 0,
            args = {
                GeneralHeader = {
                    type = "header",
                    name = L["options_general_settings"],
                    order = 1,
                },
                show_worldmap_button = {
                    type = "toggle",
                    arg = "show_worldmap_button",
                    name = L["options_show_worldmap_button"],
                    desc = L["options_show_worldmap_button_desc"],
                    set = function(info, v)
                        ns:SetOpt(info.arg, v)
                        ns.world_map_button:Refresh()
                    end,
                    order = 2,
                    width = "full",
                },
                maximized_enlarged = {
                    type = "toggle",
                    arg = "maximized_enlarged",
                    name = L["options_toggle_maximized_enlarged"],
                    desc = L["options_toggle_maximized_enlarged_desc"],
                    order = 3,
                    width = "full",
                },
                per_map_settings = {
                    type = "toggle",
                    arg = "per_map_settings",
                    name = L["options_toggle_per_map_settings"],
                    desc = L["options_toggle_per_map_settings_desc"],
                    order = 4,
                    width = "full",
                },
                RewardsHeader = {
                    type = "header",
                    name = L["options_rewards_settings"],
                    order = 10,
                },
                show_mount_rewards = {
                    type = "toggle",
                    arg = "show_mount_rewards",
                    name = L["options_mount_rewards"],
                    desc = L["options_mount_rewards_desc"],
                    order = 11,
                    width = "full",
                },
                show_pet_rewards = {
                    type = "toggle",
                    arg = "show_pet_rewards",
                    name = L["options_pet_rewards"],
                    desc = L["options_pet_rewards_desc"],
                    order = 11,
                    width = "full",
                },
                show_toy_rewards = {
                    type = "toggle",
                    arg = "show_toy_rewards",
                    name = L["options_toy_rewards"],
                    desc = L["options_toy_rewards_desc"],
                    order = 11,
                    width = "full",
                },
                show_transmog_rewards = {
                    type = "toggle",
                    arg = "show_transmog_rewards",
                    name = L["options_transmog_rewards"],
                    desc = L["options_transmog_rewards_desc"],
                    order = 11,
                    width = "full",
                },
                VisibilityHeader = {
                    type = "header",
                    name = L["options_visibility_settings"],
                    order = 20,
                },
                show_completed_nodes = {
                    type = "toggle",
                    arg = "show_completed_nodes",
                    name = L["options_show_completed_nodes"],
                    desc = L["options_show_completed_nodes_desc"],
                    order = 21,
                    width = "full",
                },
                hide_done_rare = {
                    type = "toggle",
                    arg = "hide_done_rares",
                    name = L["options_toggle_hide_done_rare"],
                    desc = L["options_toggle_hide_done_rare_desc"],
                    order = 22,
                    width = "full",
                },
                hide_minimap = {
                    type = "toggle",
                    arg = "hide_minimap",
                    name = L["options_toggle_hide_minimap"],
                    desc = L["options_toggle_hide_minimap_desc"],
                    order = 23,
                    width = "full",
                },
                use_char_achieves = {
                    type = "toggle",
                    arg = "use_char_achieves",
                    name = L["options_toggle_use_char_achieves"],
                    desc = L["options_toggle_use_char_achieves_desc"],
                    order = 24,
                    width = "full",
                },
                restore_all_nodes = {
                    type = "execute",
                    name = L["options_restore_hidden_nodes"],
                    desc = L["options_restore_hidden_nodes_desc"],
                    order = 25,
                    width = "full",
                    func = function ()
                        wipe(ns.addon.db.char)
                        ns.addon:Refresh()
                    end
                },
                FocusHeader = {
                    type = "header",
                    name = L["options_focus_settings"],
                    order = 30,
                },
                POI_scale = {
                    type = "range",
                    name = L["options_scale"],
                    desc = L["options_scale_desc"],
                    min = 1, max = 3, step = 0.01,
                    arg = "poi_scale",
                    width = "full",
                    order = 31,
                },
                POI_color = {
                    type = "color",
                    name = L["options_poi_color"],
                    desc = L["options_poi_color_desc"],
                    hasAlpha = true,
                    set = function(_, ...) ns:SetColorOpt('poi_color', ...) end,
                    get = function() return ns:GetColorOpt('poi_color') end,
                    order = 32,
                },
                PATH_color = {
                    type = "color",
                    name = L["options_path_color"],
                    desc = L["options_path_color_desc"],
                    hasAlpha = true,
                    set = function(_, ...) ns:SetColorOpt('path_color', ...) end,
                    get = function() return ns:GetColorOpt('path_color') end,
                    order = 33,
                },
                restore_poi_colors = {
                    type = "execute",
                    name = L["options_reset_poi_colors"],
                    desc = L["options_reset_poi_colors_desc"],
                    order = 34,
                    width = "full",
                    func = function ()
                        local df = ns.optionDefaults.profile
                        ns:SetColorOpt('poi_color', df.poi_color_R, df.poi_color_G, df.poi_color_B, df.poi_color_A)
                        ns:SetColorOpt('path_color', df.path_color_R, df.path_color_G, df.path_color_B, df.path_color_A)
                    end
                },
                TooltipsHeader = {
                    type = "header",
                    name = L["options_tooltip_settings"],
                    order = 40,
                },
                show_loot = {
                    type = "toggle",
                    arg = "show_loot",
                    name = L["options_toggle_show_loot"],
                    desc = L["options_toggle_show_loot_desc"],
                    order = 41,
                },
                show_notes = {
                    type = "toggle",
                    arg = "show_notes",
                    name = L["options_toggle_show_notes"],
                    desc = L["options_toggle_show_notes_desc"],
                    order = 42,
                }
            }
        },
        GlobalTab = {
            type = "group",
            name = L["options_global"],
            desc = L["options_global_description"],
            disabled = function () return ns:GetOpt('per_map_settings') end,
            order = 1,
            args = {}
        },
        ZonesTab = {
            type = "group",
            name = L["options_zones"],
            desc = L["options_zones_description"],
            childGroups = "select",
            order = 2,
            args = {}
        }
    }
}

-- Display these groups in the global settings tab. They are the most common
-- group options that players might want to customize.

function ns.CreateGlobalGroupOptions()
    for i, group in ipairs({
        ns.groups.RARE,
        ns.groups.TREASURE,
        ns.groups.PETBATTLE,
        ns.groups.MISC
    }) do
        ns.options.args.GlobalTab.args['group_icon_'..group.name] = {
            type = "header",
            name = function () return ns.RenderLinks(group.label, true) end,
            order = i * 10,
        }

        ns.options.args.GlobalTab.args['icon_scale_'..group.name] = {
            type = "range",
            name = L["options_scale"],
            desc = L["options_scale_desc"],
            min = 0.3, max = 3, step = 0.01,
            arg = group.scaleArg,
            width = 1.13,
            order = i * 10 + 1,
        }

        ns.options.args.GlobalTab.args['icon_alpha_'..group.name] = {
            type = "range",
            name = L["options_opacity"],
            desc = L["options_opacity_desc"],
            min = 0, max = 1, step = 0.01,
            arg = group.alphaArg,
            width = 1.13,
            order = i * 10 + 2,
        }
    end
end

-------------------------------------------------------------------------------
------------------------------- OPTIONS HELPERS -------------------------------
-------------------------------------------------------------------------------

local _INITIALIZED = {}

function ns.CreateGroupOptions (map, group)
    -- Check if we've already initialized this group
    if _INITIALIZED[group.name..map.id] then return end
    _INITIALIZED[group.name..map.id] = true

    -- Check if map info exists (ignore if PTR/beta zone)
    local map_info = C_Map.GetMapInfo(map.id)
    if not map_info then return end

    -- Create map options group under zones tab
    local options = ns.options.args.ZonesTab.args['Zone_'..map.id]
    if not options then
        options = {
            type = "group",
            name = map_info.name,
            args = {
                OpenWorldMap = {
                    type = "execute",
                    name = L["options_open_world_map"],
                    desc = L["options_open_world_map_desc"],
                    order = 1,
                    width = "full",
                    func = function ()
                        if not WorldMapFrame:IsShown() then
                            InterfaceOptionsFrame:Hide()
                            HideUIPanel(GameMenuFrame)
                        end
                        OpenWorldMap(map.id)
                    end
                },
                IconsGroup = {
                    type = "group",
                    name = L["options_icon_settings"],
                    inline = true,
                    order = 2,
                    args = {}
                },
                VisibilityGroup = {
                    type = "group",
                    name = L["options_visibility_settings"],
                    inline = true,
                    order = 3,
                    args = {}
                }
            }
        }
        ns.options.args.ZonesTab.args['Zone_'..map.id] = options
    end

    map._icons_order = map._icons_order or 0
    map._visibility_order = map._visibility_order or 0

    options.args.IconsGroup.args["icon_toggle_"..group.name] = {
        type = "toggle",
        get = function () return group:GetDisplay(map.id) end,
        set = function (info, v) group:SetDisplay(v, map.id) end,
        name = function () return ns.RenderLinks(group.label, true) end,
        desc = function () return ns.RenderLinks(group.desc) end,
        disabled = function () return not group:IsEnabled() end,
        width = 0.9,
        order = map._icons_order
    }

    options.args.VisibilityGroup.args["header_"..group.name] = {
        type = "header",
        name = function () return ns.RenderLinks(group.label, true) end,
        order = map._visibility_order
    }

    options.args.VisibilityGroup.args['icon_scale_'..group.name] = {
        type = "range",
        name = L["options_scale"],
        desc = L["options_scale_desc"],
        get = function () return group:GetScale(map.id) end,
        set = function (info, v) group:SetScale(v, map.id) end,
        disabled = function () return not (group:IsEnabled() and group:GetDisplay(map.id)) end,
        min = 0.3, max = 3, step = 0.01,
        width = 0.95,
        order = map._visibility_order + 1
    }

    options.args.VisibilityGroup.args['icon_alpha_'..group.name] = {
        type = "range",
        name = L["options_opacity"],
        desc = L["options_opacity_desc"],
        get = function () return group:GetAlpha(map.id) end,
        set = function (info, v) group:SetAlpha(v, map.id) end,
        disabled = function () return not (group:IsEnabled() and group:GetDisplay(map.id)) end,
        min = 0, max = 1, step = 0.01,
        width = 0.95,
        order = map._visibility_order + 2
    }

    map._icons_order = map._icons_order + 1
    map._visibility_order = map._visibility_order + 3
end
