-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local _, ns = ...
local L = ns.locale;

-------------------------------------------------------------------------------
---------------------------------- DEFAULTS -----------------------------------
-------------------------------------------------------------------------------

ns.optionDefaults = {
    profile = {
        -- icon scales
        icon_scale_caves = 1,
        icon_scale_other = 1,
        icon_scale_pet_battles = 1,
        icon_scale_rares = 0.75,
        icon_scale_treasures = 1,

        -- icon alphas
        icon_alpha_caves = 0.75,
        icon_alpha_other = 1.0,
        icon_alpha_pet_battles = 1.0,
        icon_alpha_rares = 0.75,
        icon_alpha_treasures = 0.75,

        -- visibility
        always_show_rares = false,
        always_show_treasures = false,
        hide_done_rare = false,
        hide_minimap = false,

        -- tooltip
        show_loot = true,
        show_notes = true,

        -- development
        development = false,
        show_debug = false,
        ignore_quests = false,
        force_nodes = false
    },
};

-------------------------------------------------------------------------------
--------------------------------- OPTIONS UI ----------------------------------
-------------------------------------------------------------------------------

ns.options = {
    type = "group",
    name = L["options_title"],
    get = function(info) return ns.addon.db.profile[info.arg] end,
    set = function(info, v) ns.addon.db.profile[info.arg] = v; ns.addon:Refresh() end,
    args = {}
}

ns.options.args.IconOptions = {
    type = "group",
    name = L["options_icon_settings"],
    inline = true,
    order = 0,
    args = {}
}

for i, group in ipairs{'treasures', 'rares', 'pet_battles', 'caves', 'other'} do
    ns.options.args.IconOptions.args['group_icon_'..group] = {
        type = "header",
        name = L["options_icons_"..group],
        order = i * 10,
    }

    ns.options.args.IconOptions.args['icon_scale_'..group] = {
        type = "range",
        name = L["options_scale"],
        desc = L["options_scale_desc"],
        min = 0.25, max = 3, step = 0.01,
        arg = "icon_scale_"..group,
        order = i * 10 + 1,
    }

    ns.options.args.IconOptions.args['icon_alpha_'..group] = {
        type = "range",
        name = L["options_opacity"],
        desc = L["options_opacity_desc"],
        min = 0, max = 1, step = 0.01,
        arg = "icon_alpha_"..group,
        order = i * 10 + 2,
    }
end

ns.options.args.VisibilityGroup = {
    type = "group",
    order = 10,
    name = L["options_visibility_settings"],
    inline = true,
    args = {
        groupGeneral = {
            type = "header",
            name = L["options_general_settings"],
            order = 30,
        },
        always_show_rares = {
            type = "toggle",
            arg = "always_show_rares",
            name = L["options_toggle_looted_rares"],
            desc = L["options_toggle_looted_rares_desc"],
            order = 31,
            width = "full",
        },
        always_show_treasures = {
            type = "toggle",
            arg = "always_show_treasures",
            name = L["options_toggle_looted_treasures"],
            desc = L["options_toggle_looted_treasures_desc"],
            order = 32,
            width = "full",
        },
        hide_done_rare = {
            type = "toggle",
            arg = "hide_done_rare",
            name = L["options_toggle_hide_done_rare"],
            desc = L["options_toggle_hide_done_rare_desc"],
            order = 35,
            width = "full",
        },
        hide_minimap = {
            type = "toggle",
            arg = "hide_minimap",
            name = L["options_toggle_hide_minimap"],
            desc = L["options_toggle_hide_minimap_desc"],
            order = 36,
            width = "full",
        },
    },
}

ns.options.args.TooltipGroup = {
    type = "group",
    order = 20,
    name = L["options_tooltip_settings"],
    inline = true,
    args = {
        show_loot = {
            type = "toggle",
            arg = "show_loot",
            name = L["options_toggle_show_loot"],
            desc = L["options_toggle_show_loot_desc"],
            order = 102,
        },
        show_notes = {
            type = "toggle",
            arg = "show_notes",
            name = L["options_toggle_show_notes"],
            desc = L["options_toggle_show_notes_desc"],
            order = 103,
        }
    }
}

ns.add_dev_options = function ()
    -- To enable these options, manually set "development = true" in your
    -- settings file for this addon
    ns.options.args.DevelopmentGroup = {
        type = "group",
        order = 30,
        name = L["options_dev_settings"],
        desc = L["options_dev_settings_desc"],
        inline = true,
        args = {
            show_debug = {
                type = "toggle",
                arg = "show_debug",
                name = L["options_toggle_show_debug"],
                desc = L["options_toggle_show_debug_desc"],
                order = 1,
            },
            ignore_quests = {
                type = "toggle",
                arg = "ignore_quests",
                name = L["options_toggle_ignore_quests"],
                desc = L["options_toggle_ignore_quests_desc"],
                order = 2,
            },
            force_nodes = {
                type = "toggle",
                arg = "force_nodes",
                name = L["options_toggle_force_nodes"],
                desc = L["options_toggle_force_nodes_desc"],
                order = 3,
            }
        }
    }
end
