local ADDON_NAME, _ = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW", false, true)
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ GEAR -------------------------------------
-------------------------------------------------------------------------------

L["cloth"] = "布甲"
L["leather"] = "皮甲"
L["mail"] = "鎖甲"
L["plate"] = "鎧甲"

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
L["amulet"] = "項鍊"
L["cloak"] = "披風"
L["trinket"] = "飾品"

-------------------------------------------------------------------------------
---------------------------------- TOOLTIPS -----------------------------------
-------------------------------------------------------------------------------

L["retrieving"] = "檢索項目連結 ..."
L["in_cave"] = "在洞穴。"
L["in_small_cave"] = "在小洞穴。"
L["in_water_cave"] = "在水下洞穴。"
L["in_water"] = "在水下。"
L["weekly"] = "每週"
L["normal"] = "普通"
L["hard"] = "困難"
L["mount"] = "坐騎"
L["pet"] = "寵物"
L["toy"] = "玩具"
L["completed"] = "已完成"
L["incomplete"] = "未完成"
L["known"] = "已收藏"
L["missing"] = "缺少"
L["unobtainable"] = "無法獲得"
L["unlearnable"] = "無法學習"

-------------------------------------------------------------------------------
--------------------------------- CONTEXT MENU --------------------------------
-------------------------------------------------------------------------------

L["context_menu_add_tomtom"] = "加入到TomTom"
L["context_menu_hide_node"] = "隱藏此節點"
L["context_menu_restore_hidden_nodes"] = "恢復所有隱藏節點"

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_global"] = "Global"
L["options_zones"] = "Zones"

L["options_general_description"] = "Settings that control the behavior of nodes and their rewards."
L["options_global_description"] = "Settings that control the display of all nodes in all zones."
L["options_zones_description"] = "Settings that control the display of nodes in each individual zone."

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "圖示設定"
L["options_scale"] = "縮放"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "透明度"
L["options_opacity_desc"] = "0 = 透明, 1 = 不透明"

---------------------------------- VISIBILITY ---------------------------------

L["options_visibility_settings"] = "可視性"
L["options_general_settings"] = "一般"
L["options_toggle_hide_done_rare"] = "如果戰利品已收藏，隱藏稀有"
L["options_toggle_hide_done_rare_desc"] = "隱藏所有戰利品已收藏的稀有。"
L["options_toggle_hide_minimap"] = "隱藏小地圖上的所有圖示"
L["options_toggle_hide_minimap_desc"] = "在小地圖上隱藏此插件的所有圖示，並只在主地圖上顯示它們。"
L["options_restore_hidden_nodes"] = "恢復隱藏的節點"
L["options_restore_hidden_nodes_desc"] = "恢復所有使用右鍵選單隱藏的節點。"

L["options_icons_pet_battles_desc"] = "顯示戰寵訓練師與NPC的位置。"
L["options_icons_pet_battles"] = "戰寵"
L["options_icons_caves_desc"] = "顯示其他節點的洞穴入口。"
L["options_icons_caves"] = "洞穴"
L["options_icons_daily_chests_desc"] = "顯示寶箱位置 (每日可拾取的)。"
L["options_icons_daily_chests"] = "寶箱"
L["options_icons_misc"] = "其他"
L["options_icons_npcs"] = "NPC"
L["options_icons_other"] = "其他圖示"
L["options_icons_rares_desc"] = "顯示稀有NPC的位置。"
L["options_icons_rares"] = "稀有"
L["options_icons_supplies_desc"] = "顯示戰爭補給箱的所有可能位置。"
L["options_icons_supplies"] = "戰爭補給空投"
L["options_icons_treasures"] = "寶藏"

---------------------------------- TOOLTIP ---------------------------------

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
