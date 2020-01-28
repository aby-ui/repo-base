local ADDON_NAME, _ = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW", false, true)
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ ULDUM ------------------------------------
-------------------------------------------------------------------------------

L["uldum"] = "奧丹姆"
L["uldum_intro_note"] = "完成前置引導任務鏈，以解鎖奧丹姆中的稀有物品，寶藏和攻擊任務。"

L["aqir_flayer"] = "與亞基蟲巢工人以及亞基收割者共用出生點。"
L["aqir_titanus"] = "與亞基甲蟲共用出生點。"
L["aqir_warcaster"] = "與亞基虛無法師共用出生點。"
L["atekhramun"] = "壓碎附近的毒鱗幼蠍直到出現。"
L["chamber_of_the_moon"] = "在月之大廳地下。"
L["chamber_of_the_stars"] = "在眾星之間地下。"
L["chamber_of_the_sun"] = "在日陽之間裡面。"
L["dunewalker"] = "在上面的平台上點擊“太陽精華”以釋放他。"
L["friendly_alpaca"] = "餵七次羊駝吉薩爾草，以作為坐騎收藏。 在一個位置出現10分鐘，然後很久後才重生。"
L["gaze_of_nzoth"] = "與汙穢觀察者共用出生點。"
L["gersahl_note"] = "餵給友善的羊駝七次獲得坐騎。 不需要草藥。"
L["gersahl"] = "吉薩爾草叢"
L["hmiasma"] = "餵食它周圍的軟泥，直到它啟動。"
L["kanebti"] = "從一個珠寶古墓聖甲蟲中收集一個珠寶聖甲蟲小雕像，該雕像與普通的古墓聖甲蟲共用出生點。 將雕像插入聖甲蟲聖壇以召喚稀有怪。"
L["left_eye"] = "放下全視之眼玩具的左半部分。"
L["neferset_rare"] = "這六個稀有怪在奈斐賽特具有相同的三個出生位置。 完成許多“召喚儀式”事件後，將隨機產生三個。"
L["platform"] = "出生在浮動平台頂部。"
L["spirit_cave"] = "黑暗祭儀師扎坎恩之魂的洞穴入口。"
L["tomb_widow"] = "當柱子上出現白色卵囊時，殺死隱形的蜘蛛來召喚。"
L["uatka"] = "與其他兩個玩家一起，點擊每個神秘設備。 需要來自阿瑪賽特聖匣的觸日者護符。"
L["wastewander"] = "與廢土漫遊者隊長共用出生點。"

L["amathet_cache"] = "阿瑪賽特寶箱"
L["black_empire_cache"] = "黑暗帝國寶箱"
L["black_empire_coffer"] = "黑暗帝國大寶箱"
L["infested_cache"] = "被感染的儲藏箱"
L["infested_strongbox"] = "被感染的保險箱"
L["amathet_reliquary"] = "阿瑪賽特聖匣"

L["cursed_relic"] = "需要詛咒聖物"
L["tolvir_relic"] = "需要托維爾聖物"

L["options_toggle_alpaca_uldum"] = "躍毛羊駝"
L["options_toggle_alpaca_uldum_desc"] = "顯示吉薩爾草叢以及友善的羊駝出生位置。"
L["options_toggle_assault_events"] = "突擊事件"
L["options_toggle_assault_events_desc"] = "顯示突擊事件可能的位置。"
L["options_toggle_coffers"] = "上鎖的大寶箱"
L["options_toggle_coffers_desc"] = "顯示上鎖的大寶箱的位置 (每次突擊只能拾取一次)。"

L["ambush_settlers"] = "打敗一波波的怪物，直到事件結束。"
L["burrowing_terrors"] = "跳起來將穴居甲蟲它們壓扁。"
L["call_of_void"] = "淨化儀式柱。"
L["combust_cocoon"] = "將土製火焰彈扔在天花板上的繭上。"
L["dormant_destroyer"] = "點擊所有虛空導管晶體。"
L["executor_nzoth"] = "殺死恩若司的執行者，然後摧毀執行者之錨。"
L["hardened_hive"] = "拿起地上的廢土火焰噴射器並燃燒所有的卵囊。"
L["in_flames"] = "拿起水桶，撲滅火焰。"
L["monstrous_summon"] = "殺死所有深淵先驅者以停止召喚。"
L["obsidian_extract"] = "摧毀所有虛空形成的黑曜石晶體。"
L["purging_flames"] = "撿起屍體，扔進火裡。"
L["pyre_amalgamated"] = "淨化材堆，然後殺死所有的小怪直到血肉融合體出現。"
L["summoning_ritual"] = "殺死侍僧，然後關閉召喚傳送門。事件多次完成後，奈斐賽特周圍將產生一組三種稀有。"
L["titanus_egg"] = "消滅巨怪卵，然後擊敗精英怪年幼巨蟲，打不過就拉去旁邊階梯下讓NPC幫忙"
L["voidflame_ritual"] = "熄滅所有虛無之觸蠟燭。"

L["beacon_of_sun_king"] = "向內旋轉所有三個雕像。"
L["engine_of_ascen"] = "將所有四個雕像移入光束。"
L["lightblade_training"] = "殺死導師和新進者，直到『拂曉之刃』卡姆斯出生為止。"
L["raiding_fleet"] = "使用任務物品燃燒所有船隻。"
L["slave_camp"] = "打開附近的所有籠子。"
L["unsealed_tomb"] = "保護黑魯免遭怪物的襲擊。"

-------------------------------------------------------------------------------
------------------------------------ VALE -------------------------------------
-------------------------------------------------------------------------------

L["vale"] = "恆春谷"
L["vale_intro_note"] = "完成前置引導任務鏈，以解鎖恆春谷中的稀有物品，寶藏和攻擊任務。"

L["big_blossom_mine"] = "在繁花礦坑內，入口在東北。"
L["guolai"] = "在郭萊院中。"
L["guolai_left"] = "在郭萊院中 (左邊通道)。"
L["guolai_center"] = "在郭萊院中 (中央通道)。"
L["guolai_right"] = "在郭萊院中 (右邊通道)。"
L["pools_of_power"] = "在能量之池中，入口在黃金寶塔。"
L["right_eye"] = "放下全視之眼玩具的右半部分。"
L["tisiphon"] = "點擊丹妮爾的幸運釣竿。"

L["ambered_cache"] = "琥珀化寶箱"
L["ambered_coffer"] = "琥珀寶庫"
L["mantid_relic"] = "需要螳螂人聖物"
L["mogu_plunder"] = "魔古的財寶"
L["mogu_strongbox"] = "魔古保險箱"
L["mogu_relic"] = "需要魔古聖物"

L["abyssal_ritual"] = "殺死沉沒的擁護者然後殺死深淵巨怪。"
L["bound_guardian"] = "殺死三隻淵裔束縛者以釋放純淨水滴。"
L["colored_flames"] = "從火把上收集彩色火焰，並帶到相對應的符文上。"
L["construction_ritual"] = "將猛虎雕像推入光束中。"
L["consuming_maw"] = "淨化生長物和觸手，直到被踢出。"
L["corruption_tear"] = "點擊抓起一旁的巨大信標，在不讓旋轉的眼睛撞到你的情況下關閉裂口。"
L["electric_empower"] = "殺死參天召喚者，然後殺死灌注者莫內克。(暫譯)"
L["empowered_demo"] = "關閉所有靈神聖匣"
L["empowered_wagon"] = "拿起影潘爆彈，將其放在戰車下方。"
L["feeding_grounds"] = "摧毀琥珀瓶和懸浮密室。"
L["font_corruption"] = "旋轉魔古雕像，直到兩個光束都到達後方，然後點擊控制台。"
L["goldbough_guardian"] = "保護族長金枝免受一波波怪物的襲擊。"
L["infested_statue"] = "將所有扭曲之眼從雕像上移開。"
L["mantid_hatch"] = "拿起影潘火焰噴射器並摧毀幼蟲孵化器。(暫譯)"
L["mending_monstro"] = "摧毀所有三個修補琥珀水晶。(暫譯)"
L["mystery_sacro"] = "摧毀所有可疑墓碑，殺死哀號之魂。"
L["noodle_cart"] = "在阿欽修裡麵車時保護他。"
L["protect_stout"] = "保護洞穴免遭怪物的襲擊。"
L["pulse_mound"] = "殺死周圍的生物，然後殺死成長活體"
L["ravager_hive"] = "摧毀樹上所有的蜂巢。"
L["ritual_wakening"] = "殺死卡拉西喚醒者。"
L["serpent_binding"] = "殺死參天征服者，然後殺死昊風。"
L["stormchosen_arena"] = "清除競技場中的所有小怪，然後殺死氏族將軍。"
L["swarm_caller"] = "摧毀喚蟲者柱子。"
L["vault_of_souls"] = "打開金庫，摧毀所有雕像。"
L["void_conduit"] = "點擊虛空導管並擠壓觀察的眼睛。"
L["war_banner"] = "燃燒旗幟並殺死小怪，直到指揮官出現。"
L["weighted_artifact"] = "拿起古怪的重花瓶，穿越迷宮回到基座放置，中途如果被雕像打中花瓶會掉落。"

-------------------------------------------------------------------------------
----------------------------------- VISIONS -----------------------------------
-------------------------------------------------------------------------------

L["horrific_visions"] = "驚懼幻象"
L["mailbox"] = "郵箱"
L["mail_muncher"] = "開啟以後，郵件咀嚼者有機會出現。(暫譯)"
L["options_toggle_visions_desc"] = "在驚懼幻象內時顯示獎勵品位置。"
L["void_skull"] = "虛無之觸頭顱"
L["void_skull_note"] = "點擊地面上的頭顱以拾取玩具。"

-------------------------------------------------------------------------------
----------------------------------- VOLDUN ------------------------------------
-------------------------------------------------------------------------------

L["voldun"] = "沃魯敦"
L["elusive_alpaca"] = "餵羊駝濱海綜合綠色蔬菜以學習坐騎。 在一個位置出現10分鐘，然後很久才重生。"
L["options_toggle_alpaca_voldun_desc"] = "顯示玄渺快蹄出現的位置。"
L["options_toggle_alpaca_voldun"] = "玄渺快蹄"

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

L["context_menu_title"] = "HandyNotes 恩若司的幻象"
L["context_menu_add_tomtom"] = "加入到TomTom"
L["context_menu_hide_node"] = "隱藏此節點"
L["context_menu_restore_hidden_nodes"] = "恢復所有隱藏節點"

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_title"] = "恩若司的幻象"

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "圖示設定"
L["options_icons_treasures"] = "寶藏圖示"
L["options_icons_rares"] = "稀有圖示"
L["options_icons_caves"] = "洞穴圖示"
L["options_icons_pet_battles"] = "戰寵圖示"
L["options_icons_other"] = "其他圖示"
L["options_scale"] = "縮放"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "透明度"
L["options_opacity_desc"] = "0 = 透明, 1 = 不透明"

---------------------------------- VISIBILITY ---------------------------------

L["options_visibility_settings"] = "可視性"
L["options_general_settings"] = "一般"
L["options_toggle_looted_rares"] = "永遠顯示所有稀有"
L["options_toggle_looted_rares_desc"] = "不論拾取狀態顯示所有稀有"
L["options_toggle_looted_treasures"] = "已經拾取的寶藏"
L["options_toggle_looted_treasures_desc"] = "不論拾取狀態顯示所有寶藏"
L["options_toggle_hide_done_rare"] = "如果戰利品已收藏，隱藏稀有"
L["options_toggle_hide_done_rare_desc"] = "隱藏所有戰利品已收藏的稀有。"
L["options_toggle_hide_minimap"] = "隱藏小地圖上的所有圖示"
L["options_toggle_hide_minimap_desc"] = "在小地圖上隱藏此插件的所有圖示，並只在主地圖上顯示它們。"

L["options_toggle_battle_pets_desc"] = "顯示戰寵訓練師與NPC的位置。"
L["options_toggle_battle_pets"] = "戰寵"
L["options_toggle_caves_desc"] = "顯示其他節點的洞穴入口。"
L["options_toggle_caves"] = "洞穴"
L["options_toggle_chests_desc"] = "顯示寶箱位置 (每日可拾取的)。"
L["options_toggle_chests"] = "寶箱"
L["options_toggle_misc"] = "其他"
L["options_toggle_npcs"] = "NPC"
L["options_toggle_rares_desc"] = "顯示稀有NPC的位置。"
L["options_toggle_rares"] = "稀有"
L["options_toggle_supplies_desc"] = "顯示戰爭補給箱的所有可能位置。"
L["options_toggle_supplies"] = "戰爭補給空投"
L["options_toggle_treasures"] = "寶藏"

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
