local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_WarfrontRares", "enUS", true, true)

if not _L then return end

if _L then

--
-- DATA
--

--
--	READ THIS BEFORE YOU TRANSLATE !!!
-- 
--	DO NOT TRANSLATE THE RARE NAMES HERE UNLESS YOU HAVE A GOOD REASON!!!
--	FOR EU KEEP THE RARE PART AS IT IS. CHINA & CO MAY NEED TO ADJUST!!!
--
--	_L["Rarename_search"] must have at least 2 Elements! First is the hardfilter, >=2nd are softfilters
--	Keep the hardfilter as general as possible. If you must, set it to "".
--	These Names are only used for the Group finder!
--	Tooltip names are already localized!
--

_L["Kor'gresh Coldrage_cave"] = "Cave entrance to Kor'gresh Coldrage";
_L["Geomancer Flintdagger_cave"] = "Cave entrance to Geomancer Flintdagger";
_L["Foulbelly_cave"] = "Cave entrance to Foulbelly";
_L["Kovork_cave"] = "Cave entrance to Kovork";
_L["Zalas Witherbark_cave"] = "Cave entrance to Zalas Witherbark";
_L["Overseer Krix_cave"] = "Cave entrance to Overseer Krix";

--
--
-- INTERFACE
--
--

_L["Alliance only"] = "Alliance only";
_L["Horde only"] = "Horde only";
_L["In cave"] = "In cave";

_L["Argus"] = "Argus";
_L["Antoran Wastes"] = "Antoran Wastes";
_L["Krokuun"] = "Krokuun";
_L["Mac'Aree"] = "Mac'Aree";

_L["Shield"] = "Shield";
_L["Cloth"] = "Cloth";
_L["Leather"] = "Leather";
_L["Mail"] = "Mail";
_L["Plate"] = "Plate";
_L["1h Mace"] = "1h Mace";
_L["1h Sword"] = "1h Sword";
_L["1h Axe"] = "1h Axe";
_L["2h Mace"] = "2h Mace";
_L["2h Axe"] = "2h Axe";
_L["2h Sword"] = "2h Sword";
_L["Dagger"] = "Dagger";
_L["Staff"] = "Staff";
_L["Fist"] = "Fist";
_L["Polearm"] = "Polearm";
_L["Bow"] = "Bow";
_L["Gun"] = "Gun";
_L["Wand"] = "Wand";
_L["Crossbow"] = "Crossbow";
_L["Ring"] = "Ring";
_L["Amulet"] = "Amulet";
_L["Cloak"] = "Cloak";
_L["Trinket"] = "Trinket";
_L["Off Hand"] = "Off Hand";

_L["groupBrowserOptionOne"] = "%s - %s Member (%s)";
_L["groupBrowserOptionMore"] = "%s - %s Members (%s)";
_L["chatmsg_no_group_priv"] = "|cFFFF0000Insufficient rights. You are not the group leader.";
_L["chatmsg_group_created"] = "|cFF6CF70FCreated group for %s.";
_L["chatmsg_search_failed"] = "|cFFFF0000Too many search requests, please try again in a few seconds.";
_L["hour_short"] = "h";
_L["minute_short"] = "m";
_L["second_short"] = "s";

-- KEEP THESE 2 ENGLISH IN EU/US
_L["listing_desc_rare"] = "Doing rare encounter against %s on Argus.";
_L["listing_desc_invasion"] = "Doing %s on Argus.";

_L["Pet"] = "Pet";
_L["(Mount known)"] = "(|cFF00FF00Mount known|r)";
_L["(Mount missing)"] = "(|cFFFF0000Mount missing|r)";
_L["(Toy known)"] = "(|cFF00FF00Toy known|r)";
_L["(Toy missing)"] = " (|cFFFF0000Toy missing|r)";
_L["(itemLinkGreen)"] = "(|cFF00FF00%s|r)";
_L["(itemLinkRed)"] = "(|cFFFF0000%s|r)";
_L["Retrieving data ..."] = "Retrieving data ...";
_L["Sorry, no groups found!"] = "Sorry, no groups found!";
_L["Search in Quests"] = "Search in Quests";
_L["Groups found:"] = "Groups found:";
_L["Create new group"] = "Create new group";
_L["Close"] = "Close";

_L["context_menu_title"] = "Handynotes Warfronts";
_L["context_menu_check_group_finder"] = "Check group availability";
_L["context_menu_reset_rare_counters"] = "Reset group counters";
_L["context_menu_add_tomtom"] = "Add to TomTom";
_L["context_menu_hide_node"] = "Hide this node";
_L["context_menu_restore_hidden_nodes"] = "Restore all hidden nodes";

_L["options_title"] = "Argus";

_L["options_icon_settings"] = "Icon Settings";
_L["options_icon_settings_desc"] = "Icon Settings";
_L["options_icons_treasures"] = "Treasure Chest Icons";
_L["options_icons_treasures_desc"] = "Treasure Chest Icons";
_L["options_icons_rares"] = "Rares Icons";
_L["options_icons_rares_desc"] = "Rares Icons";
_L["options_icons_caves"] = "Cave Icons";
_L["options_icons_caves_desc"] = "Cave Icons";
_L["options_icons_pet_battles"] = "Pet Battle Icons";
_L["options_icons_pet_battles_desc"] = "Pet Battle Icons";
_L["options_scale"] = "Scale";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "Opacity";
_L["options_opacity_desc"] = "0 = transparent, 1 = opaque";
_L["options_visibility_settings"] = "Visibility";
_L["options_visibility_settings_desc"] = "Visibility";
_L["options_toggle_treasures"] = "Treasures";
_L["options_toggle_rares"] = "Rares";
_L["options_toggle_battle_pets"] = "Battle Pets";
_L["options_toggle_npcs"] = "NPCs";
_L["options_general_settings"] = "General";
_L["options_general_settings_desc"] = "General";
_L["options_toggle_alreadylooted_rares"] = "Always show all rares";
_L["options_toggle_alreadylooted_rares_desc"] = "Show every rare regardless of looted status";
_L["options_toggle_alreadylooted_treasures"] = "Already looted Treasures";
_L["options_toggle_alreadylooted_treasures_desc"] = "Show every treasure regardless of looted status";
_L["options_tooltip_settings"] = "Tooltip";
_L["options_tooltip_settings_desc"] = "Tooltip";
_L["options_toggle_show_loot"] = "Show Loot";
_L["options_toggle_show_loot_desc"] = "Add loot information to the tooltip";
_L["options_toggle_show_notes"] = "Show Notes";
_L["options_toggle_show_notes_desc"] = "Add helpful notes to the tooltip where available";
_L["options_toggle_caves"] = "Caves";

_L["options_general_settings"] = "General";
_L["options_general_settings_desc"] = "General settings";

_L["options_toggle_show_debug"] = "Debug";
_L["options_toggle_show_debug_desc"] = "Show debug stuff";

_L["options_toggle_hideKnowLoot"] = "Hide rare, if all loot known";
_L["options_toggle_hideKnowLoot_desc"] = "Hide all rares for which all loot is known.";

_L["Shared"] = "Shared";
_L["Somewhere"] = "Somewhere";

end