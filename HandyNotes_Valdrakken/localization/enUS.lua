local AceLocale = LibStub:GetLibrary("AceLocale-3.0")
local L = AceLocale:NewLocale("HandyNotes_Valdrakken", "enUS", true, true)


if L then
----------------------------------------------------------------------------------------------------
-----------------------------------------------CONFIG-----------------------------------------------
----------------------------------------------------------------------------------------------------

L["config_plugin_name"] = "Valdrakken"
L["config_plugin_desc"] = "Displays the NPC and POI locations in Valdrakken on the world map and minimap."

L["config_tab_general"] = "General"
L["config_tab_scale_alpha"] = "Scale / Alpha"
--L["config_scale_alpha_desc"] = "PH"
L["config_icon_scale"] = "Icon Scale"
L["config_icon_scale_desc"] = "The scale of the icons"
L["config_icon_alpha"] = "Icon Alpha"
L["config_icon_alpha_desc"] = "The alpha transparency of the icons"
L["config_what_to_display"] = "What to display?"
L["config_what_to_display_desc"] = "These settings control what type of icons to be displayed."

L["config_auctioneer"] = "Auctioneer"
L["config_auctioneer_desc"] = "Show the auctioneer locations."

L["config_banker"] = "Banker"
L["config_banker_desc"] = "Show the banker locations."

L["config_barber"] = "Barber"
L["config_barber_desc"] = "Show the barber location."

L["config_craftingorders"] = "Crafting Orders"
L["config_craftingorders_desc"] = "Show the crafting orders locations."

L["config_flightmaster"] = "Flightmaster"
L["config_flightmaster_desc"] = "Show the flightmaster location."

L["config_guildvault"] = "Guild Vault"
L["config_guildvault_desc"] = "Show the guild vault location."

L["config_innkeeper"] = "Innkeeper"
L["config_innkeeper_desc"] = "Show the innkeeper locations."

L["config_mail"] = "Mailbox"
L["config_mail_desc"] = "Show the mailbox locations."

L["config_portal"] = "Portal"
L["config_portal_desc"] = "Show the portal locations."

L["config_portaltrainer"] = "Portal Trainer"
L["config_portaltrainer_desc"] = "Show the Mage portal trainer location."

L["config_tpplatform"] = "Teleport Platform"
L["config_tpplatform_desc"] = "Show the teleport platform location."

L["config_travelguide_note"] = "|cFFFF0000*Already active through HandyNotes: TravelGuide.|r"

L["config_reforge"] = "Armor Enhancer"
L["config_reforge_desc"] = "Show the armor enhancer location."

L["config_rostrum"] = "Rostrum of Transformation"
L["config_rostrum_desc"] = "Show the Rostrum of Transformation location."

L["config_stablemaster"] = "Stable Master"
L["config_stablemaster_desc"] = "Show the stable master location."

L["config_trainer"] = "Profession Trainer"
L["config_trainer_desc"] = "Show the profession trainer locations."

L["config_transmogrifier"] = "Transmogrifier"
L["config_transmogrifier_desc"] = "Show the transmogrifier location."

L["config_vendor"] = "Vendor"
L["config_vendor_desc"] = "Show the vendor locations."

L["config_void"] = "Void Storage"
L["config_void_desc"] = "Show the void storage location."

L["config_others"] = "Others"
L["config_others_desc"] = "Show all the other POIs."

L["config_onlymytrainers"] = "Show only the trainers and vendors for my professions"
L["config_onlymytrainers_desc"] = [[
Only affects the trainer and vendor of main professions.

|cFFFF0000NOTE: Only affects when two main professions are learned.|r
]]

L["config_fmaster_waypoint"] = "Flightmaster Waypoint"
L["config_fmaster_waypoint_desc"] = "Sets automatically a waypoint to the flightmaster if you enter the Ring of Transference."

L["config_easy_waypoints"] = "Easy Waypoints"
L["config_easy_waypoints_desc"] = "Activates simplified waypoint creation. \nAllows you to set a waypoint by right-clicking and access to more options by CTRL + right-clicking."

L["config_waypoint_dropdown"] = "Choose"
L["config_waypoint_dropdown_desc"] = "Choose how the waypoint should be created."
L["Blizzard"] = true
L["TomTom"] = true
L["Both"] = true

L["config_picons"] = "Show profession icons for:"
L["config_picons_vendor_desc"] = "Show profession icons for vendors instead of the vendor icons."
L["config_picons_trainer_desc"] = "Show profession icons for trainers instead of the trainer icons."
L["config_use_old_picons"] = "Show the old profession icons"
L["config_use_old_picons_desc"] = "Show the old profession icons again instead of the new ones (before Dragonflight)."

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

L["handler_context_menu_addon_name"] = "HandyNotes: Valdrakken"
L["handler_context_menu_add_tomtom"] = "Add to TomTom"
L['handler_context_menu_add_map_pin'] = "Set map waypoint"
L["handler_context_menu_hide_node"] = "Hide this node"

--============================================TOOLTIPS============================================--

L["handler_tooltip_requires"] = "Requires"
L["handler_tooltip_requires_level"] = "Requires at least player level"
L["handler_tooltip_data"] = "RETRIEVING DATA..."
L["handler_tooltip_quest"] = "Unlocked with quest"

----------------------------------------------------------------------------------------------------
----------------------------------------------DATABASE----------------------------------------------
----------------------------------------------------------------------------------------------------

L["Crafting Orders"] = true
L["Mailbox"] = true
L["Portal to Dalaran"] = true
L["Portal to Jade Forest"] = true
L["Portal to Orgrimmar"] = true
L["Portal to Shadowmoon Valley"] = true
L["Portal to Stormwind"] = true
L["Rostrum of Transformation"] = true
L["Teleport to Seat of the Aspects"] = true
L["Visage of True Self"] = true

end