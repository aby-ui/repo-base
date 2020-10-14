local ADDON_NAME, _ = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true, true)
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ GEAR -------------------------------------
-------------------------------------------------------------------------------

L["cloth"] = "Cloth"
L["leather"] = "Leather"
L["mail"] = "Mail"
L["plate"] = "Plate"
L["cosmetic"] = "Cosmetic"

L["1h_mace"] = "1h Mace"
L["1h_sword"] = "1h Sword"
L["1h_axe"] = "1h Axe"
L["2h_mace"] = "2h Mace"
L["2h_axe"] = "2h Axe"
L["2h_sword"] = "2h Sword"
L["shield"] = "Shield"
L["dagger"] = "Dagger"
L["staff"] = "Staff"
L["fist"] = "Fist"
L["polearm"] = "Polearm"
L["bow"] = "Bow"
L["gun"] = "Gun"
L["wand"] = "Wand"
L["crossbow"] = "Crossbow"
L["offhand"] = "Off Hand"
L["warglaive"] = "Warglaive"

L["ring"] = "Ring"
L["neck"] = "Neck"
L["cloak"] = "Cloak"
L["trinket"] = "Trinket"

-------------------------------------------------------------------------------
---------------------------------- TOOLTIPS -----------------------------------
-------------------------------------------------------------------------------

L["activation_unknown"] = "Activation unknown!"
L["requirement_not_found"] = "Requirement location unknown!"

L["Requires"] = "Requires"
L["focus"] = "Focus"
L["retrieving"] = "Retrieving item link ..."
L["in_cave"] = "In a cave."
L["in_small_cave"] = "In a small cave."
L["in_water_cave"] = "In an underwater cave."
L["in_water"] = "In the water."
L["daily"] = "Daily"
L["weekly"] = "Weekly"
L["normal"] = "Normal"
L["hard"] = "Hard"
L["mount"] = "Mount"
L["pet"] = "Pet"
L["toy"] = "Toy"
L["completed"] = "Completed"
L["incomplete"] = "Incomplete"
L["known"] = "Known"
L["missing"] = "Missing"
L["unobtainable"] = "Unobtainable"
L["unlearnable"] = "Unlearnable"
L["A"] = "A" -- available/alive
L["D"] = "D" -- dead/defeated
L["defeated"] = "Defeated"
L["undefeated"] = "Undefeated"

-------------------------------------------------------------------------------
--------------------------------- CONTEXT MENU --------------------------------
-------------------------------------------------------------------------------

L["context_menu_set_waypoint"] = "Set map waypoint"
L["context_menu_add_tomtom"] = "Add to TomTom"
L["context_menu_hide_node"] = "Hide this node"
L["context_menu_restore_hidden_nodes"] = "Restore all hidden nodes"

L["map_button_text"] = "Adjust icon display, alpha and scaling for this map."

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_global"] = "Global"
L["options_zones"] = "Zones"

L["options_general_description"] = "Settings that control the behavior of nodes and their rewards."
L["options_global_description"] = "Settings that control the display of all nodes in all zones."
L["options_zones_description"] = "Settings that control the display of nodes in each individual zone."

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "Icon Settings"
L["options_scale"] = "Scale"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "Opacity"
L["options_opacity_desc"] = "0 = transparent, 1 = opaque"

---------------------------------- VISIBILITY ---------------------------------

L["options_visibility_settings"] = "Visibility"
L["options_general_settings"] = "General"
L["options_show_completed_nodes"] = "Show completed"
L["options_show_completed_nodes_desc"] = "Show all nodes even if they have already been looted or completed today."
L["options_toggle_hide_done_rare"] = "Hide rare, if all loot known"
L["options_toggle_hide_done_rare_desc"] = "Hide all rares for which all loot is known."
L["options_toggle_hide_minimap"] = "Hide all icons on the minimap"
L["options_toggle_hide_minimap_desc"] = "Hides all icons from this addon on the minimap and displays them only on the main map."
L["options_restore_hidden_nodes"] = "Restore hidden nodes"
L["options_restore_hidden_nodes_desc"] = "Restore all nodes hidden using the right-click context menu."

L["options_icons_pet_battles_desc"] = "Display locations of battle pet trainers and NPCs."
L["options_icons_pet_battles"] = "Pet Battles"
L["options_icons_caves_desc"] = "Display cave entrances for other nodes."
L["options_icons_caves"] = "Caves"
L["options_icons_daily_chests_desc"] = "Display locations of chests (lootable daily)."
L["options_icons_daily_chests"] = "Chests"
L["options_icons_daily_quests_desc"] = "Display locations of unmarked daily quests."
L["options_icons_daily_quests"] = "Daily Quests"
L["options_icons_misc"] = "Miscellaneous"
L["options_icons_npcs"] = "NPCs"
L["options_icons_other_desc"] = "Display locations of other uncategorized nodes."
L["options_icons_other"] = "Other"
L["options_icons_quests_desc"] = "Display locations of unmarked quest lines."
L["options_icons_quests"] = "Quests"
L["options_icons_rares_desc"] = "Display locations of rare NPCs."
L["options_icons_rares"] = "Rares"
L["options_icons_supplies_desc"] = "Display all possible locations for war supply crates."
L["options_icons_supplies"] = "War Supply Drops"
L["options_icons_treasures"] = "Treasures"
L["options_icons_treasures_desc"] = "Display locations of hidden treasures."

---------------------------------- FOCUS ---------------------------------

L["options_focus_settings"] = "Points of Interest"
L["options_poi_color"] = "POI color"
L["options_poi_color_desc"] = "Sets the color for points of interest when an icon is in focus."
L["options_path_color"] = "Path color"
L["options_path_color_desc"] = "Sets the color for the paths when an icon is in focus."
L["options_reset_poi_colors"] = "Reset colors"
L["options_reset_poi_colors_desc"] = "Reset the above colors to their defaults."

---------------------------------- TOOLTIP ---------------------------------

L["options_tooltip_settings"] = "Tooltip"
L["options_tooltip_settings_desc"] = "Tooltip"
L["options_toggle_show_loot"] = "Show Loot"
L["options_toggle_show_loot_desc"] = "Add loot information to the tooltip"
L["options_toggle_show_notes"] = "Show Notes"
L["options_toggle_show_notes_desc"] = "Add helpful notes to the tooltip where available"

--------------------------------- DEVELOPMENT ---------------------------------

L["options_dev_settings"] = "Development"
L["options_dev_settings_desc"] = "Development settings"
L["options_toggle_show_debug_map"] = "Debug Map IDs"
L["options_toggle_show_debug_map_desc"] = "Show debug information for maps"
L["options_toggle_show_debug_quest"] = "Debug Quest IDs"
L["options_toggle_show_debug_quest_desc"] = "Show debug info for quest changes"
L["options_toggle_force_nodes"] = "Force Nodes"
L["options_toggle_force_nodes_desc"] = "Force display all nodes"
