local ADDON_NAME, ns = ...
local L = ns.NewLocale("zhTW")
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ GEAR -------------------------------------
-------------------------------------------------------------------------------

L["bag"] = nil
L["cloth"] = "布甲"
L["leather"] = "皮甲"
L["mail"] = "鎖甲"
L["plate"] = "鎧甲"
L["cosmetic"] = nil

L["1h_mace"] = "單手錘"
L["1h_sword"] = "單手劍"
L["1h_axe"] = "單手斧"
L["2h_mace"] = "雙手錘"
L["2h_axe"] = "雙手斧"
L["2h_sword"] = "雙手劍"
L["shield"] = "盾牌"
L["dagger"] = "匕首"
L["staff"] = "法杖"
L["fist"] = "拳套"
L["polearm"] = "長柄武器"
L["bow"] = "弓"
L["gun"] = "槍"
L["wand"] = "魔杖"
L["crossbow"] = "弩"
L["offhand"] = "副手"
L["warglaive"] = "戰刃"

L["ring"] = "戒指"
L["neck"] = "項鍊"
L["cloak"] = "披風"
L["trinket"] = "飾品"

-------------------------------------------------------------------------------
---------------------------------- TOOLTIPS -----------------------------------
-------------------------------------------------------------------------------

L["activation_unknown"] = nil
L["requirement_not_found"] = nil

L["Requires"] = nil
L["focus"] = nil
L["retrieving"] = "檢索項目連結 ..."
L["in_cave"] = "在洞穴。"
L["in_small_cave"] = "在小洞穴。"
L["in_water_cave"] = "在水下洞穴。"
L["in_waterfall_cave"] = nil
L["in_water"] = "在水下。"
L["hourly"] = nil
L["daily"] = nil
L["weekly"] = "每週"
L["normal"] = "普通"
L["hard"] = "困難"
L["mount"] = "坐騎"
L["pet"] = "寵物"
L["spell"] = nil
L["toy"] = "玩具"
L["completed"] = "已完成"
L["incomplete"] = "未完成"
L["known"] = "已收藏"
L["missing"] = "缺少"
L["unobtainable"] = "無法獲得"
L["unlearnable"] = "無法學習"
L["A"] = nil
L["D"] = nil
L["defeated"] = nil
L["undefeated"] = nil

-------------------------------------------------------------------------------
--------------------------------- CONTEXT MENU --------------------------------
-------------------------------------------------------------------------------

L["context_menu_set_waypoint"] = nil
L["context_menu_add_tomtom"] = "加入到TomTom"
L["context_menu_hide_node"] = "隱藏此節點"
L["context_menu_restore_hidden_nodes"] = "恢復所有隱藏節點"

L["map_button_text"] = nil

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_global"] = nil
L["options_zones"] = nil

L["options_general_description"] = nil
L["options_global_description"] = nil
L["options_zones_description"] = nil

L["options_open_settings_panel"] = nil
L["options_open_world_map"] = nil
L["options_open_world_map_desc"] = nil

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "圖示設定"
L["options_scale"] = "縮放"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "透明度"
L["options_opacity_desc"] = "0 = 透明, 1 = 不透明"

---------------------------------- VISIBILITY ---------------------------------

L["options_visibility_settings"] = "可視性"
L["options_general_settings"] = "一般"
L["options_show_completed_nodes"] = nil
L["options_show_completed_nodes_desc"] = nil
L["options_toggle_hide_done_rare"] = "如果戰利品已收藏，隱藏稀有"
L["options_toggle_hide_done_rare_desc"] = "隱藏所有戰利品已收藏的稀有。"
L["options_toggle_hide_minimap"] = "隱藏小地圖上的所有圖示"
L["options_toggle_hide_minimap_desc"] = "在小地圖上隱藏此插件的所有圖示，並只在主地圖上顯示它們。"
L["options_toggle_maximized_enlarged"] = nil
L["options_toggle_maximized_enlarged_desc"] = nil
L["options_toggle_use_char_achieves"] = nil
L["options_toggle_use_char_achieves_desc"] = nil
L["options_restore_hidden_nodes"] = "恢復隱藏的節點"
L["options_restore_hidden_nodes_desc"] = "恢復所有使用右鍵選單隱藏的節點。"

L["options_icons_misc_desc"] = nil
L["options_icons_misc"] = "其他"
L["options_icons_pet_battles_desc"] = "顯示戰寵訓練師與NPC的位置。"
L["options_icons_pet_battles"] = "戰寵"
L["options_icons_rares_desc"] = "顯示稀有NPC的位置。"
L["options_icons_rares"] = "稀有"
L["options_icons_treasures_desc"] = nil
L["options_icons_treasures"] = "寶藏"

------------------------------------ FOCUS ------------------------------------

L["options_focus_settings"] = nil
L["options_poi_color"] = nil
L["options_poi_color_desc"] = nil
L["options_path_color"] = nil
L["options_path_color_desc"] = nil
L["options_reset_poi_colors"] = nil
L["options_reset_poi_colors_desc"] = nil

----------------------------------- TOOLTIP -----------------------------------

L["options_tooltip_settings"] = "工具提示"
L["options_tooltip_settings_desc"] = "工具提示"
L["options_toggle_show_loot"] = "顯示戰利品"
L["options_toggle_show_loot_desc"] = "在工具提示中加入戰利品資訊"
L["options_toggle_show_notes"] = "顯示註記"
L["options_toggle_show_notes_desc"] = "在可用的工具提示中加入有用的註記"

--------------------------------- DEVELOPMENT ---------------------------------

L["options_dev_settings"] = "開發"
L["options_dev_settings_desc"] = "開發設定"
L["options_toggle_show_debug_map"] = "偵錯地圖ID"
L["options_toggle_show_debug_map_desc"] = "顯示地圖的偵錯資訊"
L["options_toggle_show_debug_quest"] = "偵錯任務ID"
L["options_toggle_show_debug_quest_desc"] = "顯示任務變換的偵錯資訊"
L["options_toggle_force_nodes"] = "強制節點"
L["options_toggle_force_nodes_desc"] = "強制顯示全部節點"
