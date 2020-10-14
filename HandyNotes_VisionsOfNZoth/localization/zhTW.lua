local ADDON_NAME, _ = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhTW", false, true)
if not L then return end

-------------------------------------------------------------------------------
----------------------------------- GENERAL -----------------------------------
-------------------------------------------------------------------------------

L["context_menu_title"] = "HandyNotes 恩若司的幻象"
L["options_title"] = "恩若司的幻象"

-------------------------------------------------------------------------------
------------------------------------ ULDUM ------------------------------------
-------------------------------------------------------------------------------

L["uldum"] = "奧丹姆"
L["uldum_intro_note"] = "完成前置引導任務鏈，以解鎖奧丹姆中的稀有物品，寶藏和攻擊任務。"

L["aqir_flayer"] = "與亞基蟲巢工人以及亞基收割者共用出生點。"
L["aqir_titanus"] = "與亞基巨怪共用出生點。"
L["aqir_warcaster"] = "與亞基虛無法師共用出生點。"
L["atekhramun"] = "壓碎附近的毒鱗幼蠍直到出現。"
L["chamber_of_the_moon"] = "在月之大廳地下。"
L["chamber_of_the_stars"] = "在眾星之間地下。"
L["chamber_of_the_sun"] = "在日陽之間裡面。"
L["dunewalker"] = "在上面的平台上點擊“太陽精華”以釋放他。"
L["friendly_alpaca"] = "餵七次羊駝吉薩爾草，以作為坐騎收藏。 在一個位置出現10分鐘，然後很久後才重生。"
L["gaze_of_nzoth"] = "與汙穢觀察者共用出生點。"
L["gersahl_note"] = "餵給友善的羊駝七次獲得坐騎。 不需要草藥學。"
L["gersahl"] = "吉薩爾草叢"
L["hmiasma"] = "餵食它周圍的軟泥，直到它啟動。"
L["kanebti"] = "從一個珠寶古墓聖甲蟲中收集一個珠寶聖甲蟲小雕像，該雕像與普通的古墓聖甲蟲共用出生點。 將雕像插入聖甲蟲聖壇以召喚稀有怪。"
L["left_eye"] = "放下全知之眼玩具的左半部分。"
L["neferset_rare"] = "這六個稀有怪在奈斐賽特具有相同的三個出生位置。 完成許多“召喚儀式”事件後，將隨機產生三個。"
L["platform"] = "出生在浮動平台頂部。"
L["single_chest"] = "此箱子僅在一個位置產生！ 如果不存在，請稍等一下，它將重新生成。"
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

L["options_icons_alpaca_uldum"] = "躍毛羊駝"
L["options_icons_alpaca_uldum_desc"] = "顯示吉薩爾草叢以及友善的羊駝出生位置。"
L["options_icons_assault_events"] = "突擊事件"
L["options_icons_assault_events_desc"] = "顯示突擊事件可能的位置。"
L["options_icons_coffers"] = "上鎖的大寶箱"
L["options_icons_coffers_desc"] = "顯示上鎖的大寶箱的位置 (每次突擊只能拾取一次)。"

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
L["ritual_ascension"] = "殺死日觸祭儀師。"
L["solar_collector"] = "在收集器的所有側面啟用所有五個單元。 單擊一個單元也會切換所有鄰近的單元。"
L["summoning_ritual"] = "殺死侍僧，然後關閉召喚傳送門。事件多次完成後，奈斐賽特周圍將產生一組三種稀有。"
L["titanus_egg"] = "消滅巨怪卵，然後擊敗精英怪年幼巨蟲，打不過就拉去旁邊階梯下讓NPC幫忙"
L["unearthed_keeper"] = "消滅出土的守衛者。"
L["virnall_front"] = "擊敗一波波的小怪，直到戰爭使者麥尼普塔出現。"
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
L["right_eye"] = "放下全知之眼玩具的右半部分。"
L["tisiphon"] = "點擊丹妮爾的幸運釣竿。"

L["ambered_cache"] = "琥珀化寶箱"
L["ambered_coffer"] = "琥珀寶庫"
L["mantid_relic"] = "需要螳螂人聖物"
L["mogu_plunder"] = "魔古的財寶"
L["mogu_strongbox"] = "魔古寶箱"
L["mogu_relic"] = "需要魔古聖物"

L["abyssal_ritual"] = "殺死沉沒的擁護者然後殺死深淵巨怪。"
L["bound_guardian"] = "殺死三隻淵裔束縛者以釋放純淨水滴。"
L["colored_flames"] = "從火把上收集彩色火焰，並帶到相對應的符文上。"
L["construction_ritual"] = "將猛虎雕像推入光束中。"
L["consuming_maw"] = "淨化生長物和觸手，直到被踢出。"
L["corruption_tear"] = "點擊抓起一旁的巨大信標，在不讓旋轉的眼睛撞到你的情況下關閉裂口。"
L["electric_empower"] = "殺死參天呼換者，然後殺死『灌注者』馬奈可。"
L["empowered_demo"] = "關閉所有靈神聖匣"
L["empowered_wagon"] = "拿起影潘爆彈，將其放在戰車下方。"
L["feeding_grounds"] = "摧毀琥珀瓶和懸浮密室。"
L["font_corruption"] = "旋轉魔古雕像，直到兩個光束都到達後方，然後點擊控制台。"
L["goldbough_guardian"] = "保護族長金枝免受一波波怪物的襲擊。"
L["infested_statue"] = "將所有扭曲之眼從雕像上移開。"
L["kunchong_incubator"] = "摧毀所有力場產生器。"
L["mantid_hatch"] = "拿起影潘火焰噴射器並摧毀幼蟲孵化器。"
L["mending_monstro"] = "摧毀所有三個一組療癒琥珀。"
L["mystery_sacro"] = "摧毀所有可疑墓碑，殺死哀號之魂。"
L["noodle_cart"] = "在阿欽修裡拉麵推車時保護他。"
L["protect_stout"] = "保護洞穴免遭怪物的襲擊。"
L["pulse_mound"] = "殺死周圍的生物，然後殺死成長活體"
L["ravager_hive"] = "摧毀樹上所有的蜂巢。"
L["ritual_wakening"] = "殺死卡拉西喚醒者。"
L["serpent_binding"] = "殺死參天征服者，然後殺死昊風。"
L["stormchosen_arena"] = "清除競技場中的所有小怪，然後殺死氏族將軍。"
L["swarm_caller"] = "摧毀喚蟲者柱子。"
L["vault_of_souls"] = "打開金庫，摧毀所有雕像。"
L["void_conduit"] = "點擊虛空導管並擠壓觀察的眼睛。"
L["war_banner"] = "燃燒戰旗並殺死小怪，直到指揮官出現。"
L["weighted_artifact"] = "拿起古怪的重花瓶，穿越迷宮回到基座放置，中途如果被雕像打中花瓶會掉落。"

-------------------------------------------------------------------------------
----------------------------------- VISIONS -----------------------------------
-------------------------------------------------------------------------------

L["colored_potion"] = "彩色藥水"
L["colored_potion_note"] = [[
％s屍體旁邊的藥水始終指示運行的負面效果藥水的顏色。

+100理智藥水的顏色可以由該藥水的顏色確定（| cFFFF0000壞 | r => | cFF00FF00好 | r）：

黑色 => 綠色
藍色 => 紫色
綠色 => 紅色
紫色 => 黑色
紅色 => 藍色
]]

L["bear_spirit"] = "熊靈"
L["bear_spirit_note"] = "殺死憤怒的熊地毯靈和所有小怪，即可獲得10％的加速增益。"
L["buffs_change"] = "可用的增益每次都會更換。 如果建築物關閉或缺少NPC/物體，則本次該增益沒有提供。"
L["clear_sight"] = "需要清除視線等級 %d。"
L["craggle"] = "將玩具放在地面上（例如玩具火車組）以分散他的注意力。 拉開他的機器人，並先殺死他們。"
L["empowered"] = "賦能"
L["empowered_note"] = "穿過地雷的迷宮，站在樓上的實驗增益礦上，獲得10％的傷害增益。"
L["enriched"] = "充實"
L["enriched_note"] = "殺死被忽視的公會銀行，獲得10％暴擊增益。"
L["ethereal_essence"] = "超凡的精華"
L["ethereal_essence_note"] = "殺死Warpweaver Dushar，獲得10％暴擊增益。(暫譯)"
L["ethereal_note"] = "收集隱藏在整個幻象內的橙色晶體，並將其返回該NPC以獲取額外的獎勵。總計有10個水晶每個區域兩個。\n\n| cFF00FF00別忘了拾取箱子！|r"
L["heroes_bulwark"] = "英雄壁壘"
L["heroes_bulwark_note"] = "在旅館內殺死加蒙，獲得10％的生命增益。"
L["horrific_visions"] = "驚懼幻象"
L["inside_building"] = "在建築物內。"
L["mailbox"] = "郵箱"
L["mail_muncher"] = "開啟以後，郵件咀嚼者有機會出現。(暫譯)"
L["morgan_pestle"] = "Morgan Pestle"
L["odd_crystal"] = "奇怪的水晶"
L["requited_bulwark"] = "退役的壁壘"
L["requited_bulwark_note"] = "殺死Agustus Moulaine，可獲得7％的臨機應變增益。"
L["shave_kit"] = "髮捲的剃髮工具組"
L["shave_kit_note"] = "在理髮店裡面，拾取桌上的箱子。"
L["smiths_strength"] = "Smith's Strength"
L["smiths_strength_note"] = "在鐵匠小屋中殺死納羅斯，取得10％的傷害增益。"
L["spirit_of_wind"] = "風之精靈"
L["spirit_of_wind_note"] = "殺死布旺巴獲得10％的加速和移動速度提升。"
L["void_skull"] = "虛無之觸頭顱"
L["void_skull_note"] = "點擊地面上的頭顱以拾取玩具。"
L["yelmak"] = "Yelmak"

L["c_alley_corner"] = "在小巷的一個角落。"
L["c_bar_upper"] = "在酒吧的上層。"
L["c_behind_bank_counter"] = "在銀行櫃檯的後面。"
L["c_behind_boss"] = "在首領後方的流亡者建築。"
L["c_behind_boxes"] = "在一些盒子後面的角落。"
L["c_behind_cart"] = "在一輛被毀的推車後面。"
L["c_behind_house_counter"] = "在櫃檯後面的房子裡。"
L["c_behind_mailbox"] = "在郵箱後方。"
L["c_behind_pillar"] = "隱藏在使館大樓後方的支柱後面。"
L["c_behind_rexxar"] = "隱藏在雷克薩建築物後面的右側。"
L["c_behind_stables"] = "在肖爾的馬槽後。"
L["c_by_pillar_boxes"] = "在支柱和一些盒子之間的牆上。"
L["c_center_building"] = "在中心建築的底層。"
L["c_forge_corner"] = "在一個鍛造的角落。"
L["c_hidden_boxes"] = "隱藏在索爾建築後方的一些盒子後面。"
L["c_inside_auction"] = "在拍賣行內的右邊。"
L["c_inside_big_tent"] = "在大帳篷裡的左邊。"
L["c_inside_cacti"] = "在拐角處的仙人掌補丁裡。"
L["c_inside_hut"] = "在右邊的第一個小屋內。"
L["c_inside_leatherwork"] = "在製皮建築內。"
L["c_inside_orphanage"] = "在孤兒院裡。"
L["c_inside_transmog"] = "在塑形小屋內。"
L["c_left_cathedral"] = "隱藏在大教堂入口左側。"
L["c_left_inquisitor"] = "階梯左側的審訊官小首領的後面。"
L["c_on_small_hill"] = "在小山頂上。"
L["c_top_building"] = "在建築物的頂層。"
L["c_underneath_bridge"] = "在橋下。"
L["c_walkway_corner"] = "在角落的上層人行道上。"
L["c_walkway_platform"] = "在上走道上方的平台上。"

L["options_icons_visions_buffs"] = "增益"
L["options_icons_visions_buffs_desc"] = "顯示可以造成1小時傷害增強的事件的位置。"
L["options_icons_visions_chest"] = "寶箱"
L["options_icons_visions_chest_desc"] = "在驚懼幻象中顯示可能的寶箱位置。"
L["options_icons_visions_crystals"] = "奇怪的水晶"
L["options_icons_visions_crystals_desc"] = "在驚懼幻象中顯示奇怪的水晶位置。"
L["options_icons_visions_mail"] = "郵箱"
L["options_icons_visions_mail_desc"] = "顯示郵件咀嚼者坐騎的郵箱位置。"
L["options_icons_visions_misc"] = "其他"
L["options_icons_visions_misc_desc"] = "在驚懼幻象中顯示稀有、玩具、藥水和增強的位置。"

-------------------------------------------------------------------------------
----------------------------------- VOLDUN ------------------------------------
-------------------------------------------------------------------------------

L["voldun"] = "沃魯敦"
L["elusive_alpaca"] = "餵羊駝濱海綜合綠色蔬菜以學習坐騎。 在一個位置出現10分鐘，然後很久才重生。"
L["options_icons_alpaca_voldun_desc"] = "顯示玄渺快蹄出現的位置。"
L["options_icons_alpaca_voldun"] = "玄渺快蹄"
