local ADDON_NAME, ns = ...
local L = ns.NewLocale("zhTW")
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ GEAR -------------------------------------
-------------------------------------------------------------------------------

L["bag"] = "背包"
L["cloth"] = "布甲"
L["leather"] = "皮甲"
L["mail"] = "鎖甲"
L["plate"] = "鎧甲"
L["cosmetic"] = "裝飾品"

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

L["activation_unknown"] = "啟動條件未知"
L["requirement_not_found"] = "所需位置未知"

L["Requires"] = "需要"
L["focus"] = "專注"
L["retrieving"] = "接收物品連結 ..."
L["in_cave"] = "在洞穴。"
L["in_small_cave"] = "在小洞穴。"
L["in_water_cave"] = "在水下洞穴。"
L["in_waterfall_cave"] = "在瀑布後面洞穴內。"
L["in_water"] = "在水下。"
L["hourly"] = "每小時"
L["daily"] = "每日"
L["weekly"] = "每週"
L["normal"] = "普通"
L["hard"] = "困難"
L["mount"] = "坐騎"
L["pet"] = "戰寵"
L["spell"] = "法術"
L["toy"] = "玩具"
L["rep"] = "聲望"
L["completed"] = "已完成"
L["incomplete"] = "未完成"
L["known"] = "已獲得"
L["missing"] = "未獲得"
L["unobtainable"] = "無法獲得"
L["unlearnable"] = "無法解鎖"
L["defeated"] = "已擊敗"
L["undefeated"] = "未擊敗"

-------------------------------------------------------------------------------
--------------------------------- CONTEXT MENU --------------------------------
-------------------------------------------------------------------------------

L["context_menu_set_waypoint"] = "設定地圖路徑點"
L["context_menu_add_tomtom"] = "加入到TomTom"
L["context_menu_hide_node"] = "隱藏此節點"
L["context_menu_restore_hidden_nodes"] = "恢復所有隱藏節點"

L["map_button_text"] = "調整此地圖上的圖示顯示、透明度與縮放"

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_global"] = "整體"
L["options_zones"] = "區域"

L["options_general_description"] = "控制節點行為和獎勵的設定"
L["options_global_description"] = "控制全部區域節點顯示的設定"
L["options_zones_description"] = "控制每個單獨區域節點顯示的設定"

L["options_open_settings_panel"] = "打開設定面板…"
L["options_open_world_map"] = "打開世界地圖"
L["options_open_world_map_desc"] = "在世界地圖中開啟此區域"

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "圖示設定"
L["options_scale"] = "縮放"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "透明度"
L["options_opacity_desc"] = "0 = 透明, 1 = 不透明"

---------------------------------- VISIBILITY ---------------------------------

L["options_show_worldmap_button"] = "顯示世界地圖按鈕"
L["options_show_worldmap_button_desc"] = "在世界地圖右上角新增一個快速切換內容的下拉式選單"

L["options_visibility_settings"] = "可視性"
L["options_general_settings"] = "一般"
L["options_show_completed_nodes"] = "顯示已完成"
L["options_show_completed_nodes_desc"] = "顯示所有的節點，即使它今天已被拾取或完成。"
L["options_toggle_hide_done_rare"] = "隱藏所有戰利品已收藏的稀有"
L["options_toggle_hide_done_rare_desc"] = "隱藏所有戰利品已收藏的稀有。"
L["options_toggle_hide_minimap"] = "隱藏小地圖上的所有圖示"
L["options_toggle_hide_minimap_desc"] = "在小地圖上隱藏此插件的所有圖示，並只在主地圖上顯示它們。"
L["options_toggle_maximized_enlarged"] = "當世界地圖時最大化時放大圖示"
L["options_toggle_maximized_enlarged_desc"] = "當世界地圖放到最大時，放大所有的圖示。"
L["options_toggle_use_char_achieves"] = "使用角色成就"
L["options_toggle_use_char_achieves_desc"] = "用此角色的成就進度來替代顯示整個帳號的進度。"
L["options_toggle_per_map_settings"] = "使用區域個別設定"
L["options_toggle_per_map_settings_desc"] = "只使用各個地圖各自獨立的切換、縮放和透明度設定"
L["options_restore_hidden_nodes"] = "恢復隱藏的節點"
L["options_restore_hidden_nodes_desc"] = "恢復所有使用右鍵選單隱藏的節點。"

L["options_rewards_settings"] = "獎勵"
L["options_reward_types"] = "顯示獎勵類型"
L["options_mount_rewards"] = "顯示坐騎獎勵"
L["options_mount_rewards_desc"] = "在提示顯示坐騎獎勵並追蹤收集狀態"
L["options_pet_rewards"] = "顯示戰寵獎勵"
L["options_pet_rewards_desc"] = "在提示顯示戰寵獎勵並追蹤收集狀態"
L["options_toy_rewards"] = "顯示玩具獎勵"
L["options_toy_rewards_desc"] = "在提示顯示玩具獎勵並追蹤收集狀態"
L["options_transmog_rewards"] = "顯示塑形獎勵"
L["options_transmog_rewards_desc"] = "在提示顯示塑型獎勵並追蹤收集狀態"

L["options_icons_misc_desc"] = "顯示其他節點的位置。"
L["options_icons_misc"] = "其他"
L["options_icons_pet_battles_desc"] = "顯示戰寵訓練師與NPC的位置。"
L["options_icons_pet_battles"] = "戰寵"
L["options_icons_rares_desc"] = "顯示稀有NPC的位置。"
L["options_icons_rares"] = "稀有"
L["options_icons_treasures_desc"] = "顯示隱藏寶藏的位置。"
L["options_icons_treasures"] = "寶藏"

------------------------------------ FOCUS ------------------------------------

L["options_focus_settings"] = "興趣點"
L["options_poi_color"] = "興趣點顏色"
L["options_poi_color_desc"] = "設定被設為專注的興趣點圖示顏色"
L["options_path_color"] = "路徑顏色"
L["options_path_color_desc"] = "設定圖示被設為專注的路徑顏色"
L["options_reset_poi_colors"] = "重置顏色"
L["options_reset_poi_colors_desc"] = "重置以上的顏色為預設值"

----------------------------------- TOOLTIP -----------------------------------

L["options_tooltip_settings"] = "工具提示"
L["options_toggle_show_loot"] = "顯示戰利品"
L["options_toggle_show_loot_desc"] = "在工具提示中加入戰利品資訊"
L["options_toggle_show_notes"] = "顯示註記"
L["options_toggle_show_notes_desc"] = "在可用的工具提示中加入有用的註記"

--------------------------------- DEVELOPMENT ---------------------------------

L["options_dev_settings"] = "開發"
L["options_toggle_show_debug_map"] = "偵錯地圖ID"
L["options_toggle_show_debug_map_desc"] = "顯示地圖的偵錯資訊"
L["options_toggle_show_debug_quest"] = "偵錯任務ID"
L["options_toggle_show_debug_quest_desc"] = "顯示任務變換的偵錯資訊"
L["options_toggle_force_nodes"] = "強制節點"
L["options_toggle_force_nodes_desc"] = "強制顯示全部節點"
