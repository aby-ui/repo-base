local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("HandyNotes_CovenantSanctum", "enUS", true, true)


if L then
----------------------------------------------------------------------------------------------------
-----------------------------------------------CONFIG-----------------------------------------------
----------------------------------------------------------------------------------------------------

L["config_plugin_name"] = "Covenant Sanctum"
L["config_plugin_desc"] = "Displays the NPC and POI locations in your covenant sanctum on the world map and minimap."

L["config_tab_general"] = "General"
L["config_tab_scale_alpha"] = "Scale / Alpha"
--L["config_scale_alpha_desc"] = "PH"
L["config_icon_scale"] = "Icon Scale"
L["config_icon_scale_desc"] = "The scale of the icons"
L["config_icon_alpha"] = "Icon Alpha"
L["config_icon_alpha_desc"] = "The alpha transparency of the icons"
L["config_what_to_display"] = "What to display?"
L["config_what_to_display_desc"] = "These settings control what type of icons to be displayed."

L["config_innkeeper"] = "Innkeeper"
L["config_innkeeper_desc"] = "Show the innkeeper locations."

L["config_mail"] = "Mailbox"
L["config_mail_desc"] = "Show the mailbox locations."

L["config_portal"] = "Portal"
L["config_portal_desc"] = "Show the portal locations."

L["config_travelguide_note"] = "|cFFFF0000*Already active through HandyNotes: TravelGuide.|r"

L["config_reforge"] = "Armor Enhancer"
L["config_reforge_desc"] = "Show the armor enhancer locations."

L["config_renown"] = "Keeper of Renown"
L["config_renown_desc"] = "Show the keeper of renown locations."

L["config_stablemaster"] = "Stable Master"
L["config_stablemaster_desc"] = "Show the stable master locations."

L["config_vendor"] = "Vendor"
L["config_vendor_desc"] = "Show the vendor locations."

L["config_weaponsmith"] = "Weaponsmith"
L["config_weaponsmith_desc"] = "Show the weaponsmith locations."

L["config_easy_waypoints"] = "Easy Waypoints"
L["config_easy_waypoints_desc"] = "Activates simplified waypoint creation. \nAllows you to set a waypoint by right-clicking and access to more options by CTRL + right-clicking."
L["config_waypoint_dropdown"] = "Choose"
L["config_waypoint_dropdown_desc"] = "Choose how the waypoint should be created."
L["Blizzard"] = true
L["TomTom"] = true
L["Both"] = true

L["config_others"] = "Others"
L["config_others_desc"] = "Show all the other POIs."

L["config_restore_nodes"] = "Restore hidden nodes"
L["config_restore_nodes_desc"] = "Restore all nodes that were hidden via the context menu."
L["config_restore_nodes_print"] = "All hidden nodes have been restored"

----------------------------------------------------------------------------------------------------
-------------------------------------------------DEV------------------------------------------------
----------------------------------------------------------------------------------------------------

L["dev_config_tab"] = "DEV"

L["dev_config_force_nodes"] = "Force Nodes"
L["dev_config_force_nodes_desc"] = "Force the display of all nodes regardless of class, faction or covenant."

L["dev_config_show_prints"] = "Show print()"
L["dev_config_show_prints_desc"] = "Show print() messages in the chat window."

----------------------------------------------------------------------------------------------------
-----------------------------------------------HANDLER----------------------------------------------
----------------------------------------------------------------------------------------------------

--==========================================CONTEXT_MENU==========================================--

L["handler_context_menu_addon_name"] = "HandyNotes: Covenant Sanctum"
L["handler_context_menu_add_tomtom"] = "Add to TomTom"
L['handler_context_menu_add_map_pin'] = "Set map waypoint"
L["handler_context_menu_hide_node"] = "Hide this node"

--============================================TOOLTIPS============================================--

L["handler_tooltip_requires"] = "Requires"
L["handler_tooltip_sanctum_feature"] = "a Sanctum Upgrade"
L["handler_tooltip_TNTIER"] = "Tier %s of the travel network."

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

L["Portal to Oribos"] = true
L["Mailbox"] = true

end