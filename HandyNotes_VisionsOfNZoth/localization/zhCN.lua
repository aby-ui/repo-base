local ADDON_NAME, _ = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN", false, true)
if not L then return end

-------------------------------------------------------------------------------
------------------------------------ ULDUM ------------------------------------
-------------------------------------------------------------------------------

L["uldum"] = "奥丹姆"
L["uldum_intro_note"] = "完成奥丹姆引导任务解锁稀有、宝藏及突袭任务！"

L["aqir_flayer"] = ""
L["aqir_titanus"] = ""
L["aqir_warcaster"] = ""
L["atekhramun"] = "踩死碎坑上的幼蝎直到稀有出现"
L["chamber_of_the_moon"] = "在月亮密室下面。"
L["chamber_of_the_stars"] = "在群星密室下面。"
L["chamber_of_the_sun"] = "在太阳密室里面。"
L["friendly_alpaca"] = "在一个位置只出现10分钟，然后在一个较长的刷新时间后再次出现。每天可以喂食羊驼一个基萨尔野菜，7天(次)后会获得坐骑"
L["gersahl"] = "基萨尔野菜"
L["gersahl_note"] = "用于喂食友善的羊驼，可以获得坐骑：春袭羊驼。不需要草药学即可采摘。模型较小，可被草药学追踪，建议调低环境细节和地表景观两项设置参数以防伤眼"
L["hmiasma"] = "喂食它周围的软泥直到启动。"
L["left_eye"] = "掉落全视双眼玩具的左半部分"
L["platform"] = "刷新在浮空平台顶部。"
L["reshef"] = ""
L["spirit_cave"] = "黑暗仪祭师的洞穴入口。"
L["tomb_widow"] = "当柱子上出现白色卵囊时，杀死看不见的蜘蛛召唤"
L["uatka"] = "需要三个人分别点击神秘的装置，消耗一个日灼护符，出自阿玛塞特圣箱。注意：一个人也可以点击，护符并不返还，别问我怎么知道的"
L["wastewander"] = ""

L["amathet_cache"] = "阿玛赛特之箱"
L["black_empire_cache"] = "黑暗帝国宝箱"
L["black_empire_coffer"] = "黑暗帝国宝匣"
L["infested_cache"] = "感染宝箱"
L["infested_strongbox"] = "感染的保险箱"
L["amathet_reliquary"] = "阿玛赛特圣箱"

L["cursed_relic"] = "需要诅咒圣物"
L["tolvir_relic"] = "需要托维尔圣物"

L["options_toggle_alpaca_uldum"] = "春袭羊驼"
L["options_toggle_alpaca_uldum_desc"] = "显示友善的羊驼的位置"
L["options_toggle_assault_events"] = "突袭事件"
L["options_toggle_assault_events_desc"] = "显示可能的突袭事件的位置"
L["options_toggle_coffers"] = "上锁的箱子"
L["options_toggle_coffers_desc"] = "显示上锁的箱子（每次突袭拾取一次）"

L["ambush_settlers"] = "保护NPC"
L["combust_cocoon"] = "捡起自制火焰炸弹，然后丢到空中的卵上"
L["obsidian_extract"] = "摧毁所有虚化黑曜石"
L["purging_flames"] = "捡起尸体，丢进火里"
L["dormant_destroyer"] = "点击所有虚空浮石"
L["titanus_egg"] = "摧毁巨虫之卵，然后击杀大怪。注意：击杀中间的巨虫之卵！不然把旁边的卵给杀了，出现的小怪伤害极高且会不断击飞和击晕！"
L["hardened_hive"] = "拾取废土喷火器然后烧毁所有的虫卵。废土喷火器在地上，略微有点费眼。"
L["burrowing_terrors"] = "跳上挖洞的圣甲虫将它们压扁，注意：一定要跳！"

L["beacon_of_sun_king"] = "向内旋转三个雕像"
L["engine_of_ascen"] = "将四个雕像分别挡住激光"
L["lightblade_training"] = "杀死所有场上小怪直到精英出现"
L["raiding_fleet"] = "使用任务物品烧掉所有船只"
L["slave_camp"] = "打开所有奴隶笼子"
L["unsealed_tomb"] = "保护NPC"
L["voidflame_ritual"] = "扑灭所有虚触蜡烛"
L["call_of_void"] = "清除仪式晶塔周围所有的怪物"
L["executor_nzoth"] = "杀死恩佐斯的执行者，然后摧毁执行者之锚"
L["gaze_of_nzoth"] = "和眼球怪共享刷新，不断击杀眼球怪即可"
L["pyre_amalgamated"] = "地上有个融合者的火堆，点击之后击杀小怪直到稀有出现，火堆刷的不是很快"
L["summoning_ritual"] = "杀怪关门。每有一个玩家过来完成事件关门，就有几率在(50,78)，(50,88)和(55,79)这三个点随机刷新六种稀有，一次刷新三种。它们分别是癫狂伪装者阿弗罗姆、心能吞噬者拉亚斯、现实消化者罗约洛克、血肉饕餮者舒格舒尔、意志破坏者伊弗里姆、神智掠夺者佐斯拉姆。\n其中意志破坏者伊弗里姆有几率掉落玩具：廉价的克熙尔伪装。"
L["neferset_rare"] = "出现召唤仪式事件(坐标(50,78)，(50,88)和(55,79))的当天，每有一个玩家过来完成事件关门，就有几率在(50,78)，(50,88)和(55,79)这三个点随机刷新六种稀有，一次刷新三种"
L["solar_collector"] = "启用太阳能收集器四个方向上所有的能量水晶。点击每一个能量水晶会使其旁边的能量水晶反转。\n译者注（来源网上，并非最优解）：\n首先按上三下二的样式将能量水晶命名为\n1  2  3\n 4  5\n第一步：让1和3亮起来，哪个不亮点哪个\n第二步：观察245中哪些不亮\n第三步：全不亮:425\n              2不亮:213\n              4不亮:53\n              5不亮:21\n              45不亮:213425\n              24不亮:521\n              25不亮:53425"
L["unearthed_keeper"] = "摧毁出土的守护者"
L["ritual_ascension"] = "击杀日灼祭师"


-------------------------------------------------------------------------------
------------------------------------ VALE -------------------------------------
-------------------------------------------------------------------------------

L["vale"] = "锦绣谷"
L["vale_intro_note"] = "完成锦绣谷引导任务解锁稀有、宝藏及突袭任务！"

L["big_blossom_mine"] = "在矿洞里面，入口在东北方向。"
L["guolai"] = "在郭莱古厅里面"
L["guolai_left"] = "在郭莱古厅里面（左边通道）"
L["guolai_center"] = "在郭莱古厅里面（中间通道）"
L["guolai_right"] = "在郭莱古厅里面（右边通道）"
L["jadec"] = "在郭莱古厅里面，走到楼梯底部向左"
L["pools_of_power"] = "在能量池中，入口在鎏金亭（地图中间雕像）。"
L["right_eye"] = "掉落全视双眼玩具的右半部分"
L["tisiphon"] = "点击丹妮尔的好运鱼竿"

L["ambered_cache"] = "琥珀宝箱"
L["ambered_coffer"] = "琥珀制成的箱子"
L["mantid_relic"] = "需要螳螂妖圣物"
L["mogu_plunder"] = "魔古掠夺品"
L["mogu_strongbox"] = "魔古保险箱"
L["mogu_relic"] = "需要魔古圣物"


L["colored_flames"] = "四周的墙上有四色火炬，点击他们然后与雕像四周对应颜色的符文交互"
L["construction_ritual"] = "推动老虎雕像去挡住射线"
L["corruption_tear"] = "场地周围有个宝珠（泰坦信标），持有宝珠与场中泪滴交互，别让旋转的眼睛碰到你"
L["consuming_maw"] = "净化触手和和卵泡，直到被吐出去"
L["empowered_demo"] = "关闭所有幽魂圣瓮"
L["infested_statue"] = "把眼睛从雕像上挪开"
L["void_conduit"] = "点击柱子然后进去踩眼睛"
L["goldbough_guardian"] = "保护NPC"
L["protect_stout"] = "保护NPC"
L["bound_guardian"] = "杀怪救NPC"
L["abyssal_ritual"] = "杀完小怪杀大怪"
L["pulse_mound"] = "杀怪"
L["kunchong_incubator"] = "摧毁所有力场生成器"
L["mending_monstro"] = "摧毁所有愈疗琥珀"
L["war_banner"] = "燃烧战旗然后杀怪"
L["feeding_grounds"] = "销毁静滞容器"
L["swarm_caller"] = "销毁虫群召唤器"
L["empowered_wagon"] = "捡起影踪派军需品然后放在强化的战车下面"
L["mantid_hatch"] = "拾取影踪派喷火器烧毁所有螳螂妖虫卵"
L["ritual_wakening"] = "杀死卡拉克西唤醒者"
L["font_corruption"] = "旋转魔古雕像将光束连接到泰坦控制台左右两边的小圆柱上，然后点击泰坦控制台"
L["ravager_hive"] = "消灭树上所有的蜂巢"
L["noodle_cart"] = "保护胖熊猫"
L["serpent_binding"] = "杀怪"
L["stormchosen_arena"] = "杀怪"
L["mystery_sacro"] = "摧毁所有可疑的墓碑，然后杀死尖叫之魂"
L["weighted_artifact"] = "捡起沉得出奇的花瓶，然后替换掉桌子上沉重的魔古神器。被雕像击中花瓶会掉落！"
L["vault_of_souls"] = "打开千魂窟，然后击杀所有宝库雕像"
L["electric_empower"] = "杀怪"
L["in_flames"] = "拾取水桶灭火"

-------------------------------------------------------------------------------
----------------------------------- VISIONS -----------------------------------
-------------------------------------------------------------------------------

L["horrific_visions"] = "惊魂幻象"
L["mailbox"] = "邮箱"
L["mail_muncher"] = "打开邮箱会随机刷新邮件吞噬者"
L["options_toggle_visions_misc_desc"] = "显示惊魂幻象内的奖励位置"
L["shave_kit"] = "Coifcurl's Close Shave Kit"
L["shave_kit_note"] = "Inside the barber shop."
L["void_skull"] = "Void-Touched Skull"
L["void_skull_note"] = "Click the skull on the ground to loot the toy."

-------------------------------------------------------------------------------
----------------------------------- VOLDUN ------------------------------------
-------------------------------------------------------------------------------

L["voldun"] = "沃顿"
L["elusive_alpaca"] = "将\"海滩叶蔬沙拉\"喂食\"轻盈的迅蹄驼\"以获得坐骑。羊驼刷新时间很长，每次存在10分钟。大部分8.0的食物供应商（比如雷龙）会出售该食物。"
L["options_toggle_alpaca_voldun_desc"] = "显示轻盈的迅蹄驼的位置"
L["options_toggle_alpaca_voldun"] = "轻盈的迅蹄驼"

-------------------------------------------------------------------------------
------------------------------------ GEAR -------------------------------------
-------------------------------------------------------------------------------

L["cloth"] = "布甲"
L["leather"] = "皮甲"
L["mail"] = "锁甲"
L["plate"] = "板甲"

L["1h_mace"] = "单手锤"
L["1h_sword"] = "单手剑"
L["1h_axe"] = "单手斧"
L["2h_mace"] = "双手锤"
L["2h_axe"] = "双手斧"
L["2h_sword"] = "双手剑"
L["shield"] = "盾牌"
L["dagger"] = "匕首"
L["staff"] = "法杖"
L["fist"] = "拳套"
L["polearm"] = "长柄武器"
L["bow"] = "弓"
L["gun"] = "枪"
L["wand"] = "魔杖"
L["crossbow"] = "弩"
L["offhand"] = "副手"
L["warglaive"] = "战刃"

L["ring"] = "戒指"
L["amulet"] = "项链"
L["cloak"] = "披风"
L["trinket"] = "饰品"

-------------------------------------------------------------------------------
---------------------------------- TOOLTIPS -----------------------------------
-------------------------------------------------------------------------------

L["retrieving"] = "正在获取此项信息"
L["in_cave"] = "在洞穴。"
L["in_small_cave"] = "在小洞穴。"
L["in_water_cave"] = "在水下洞穴。"
L["weekly"] = "每周"
L["normal"] = "普通"
L["hard"] = "困难"
L["mount"] = "坐骑"
L["pet"] = "宠物"
L["toy"] = "玩具"
L["completed"] = "已完成"
L["incomplete"] = "未完成"
L["known"] = "已获得"
L["missing"] = "未获得"
L["unobtainable"] = "无法获得"
L["unlearnable"] = "无法解锁（相对当前职业、专精或其它原因）"

-------------------------------------------------------------------------------
--------------------------------- CONTEXT MENU --------------------------------
-------------------------------------------------------------------------------

L["context_menu_title"] = "HandyNotes 恩佐斯的幻象"
L["context_menu_add_tomtom"] = "加入到TomTom"
L["context_menu_hide_node"] = "隐藏此项"
L["context_menu_restore_hidden_nodes"] = "恢复所有隐藏项"

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

L["options_title"] = "恩佐斯的幻象"

------------------------------------ ICONS ------------------------------------

L["options_icon_settings"] = "图标设置"
L["options_icons_treasures"] = "宝藏图标"
L["options_icons_assaultevents"] = "事件图标"
L["options_icons_rares"] = "稀有图标"
L["options_icons_caves"] = "洞穴图标"
L["options_icons_pet_battles"] = "战斗宠物图标"
L["options_icons_other"] = "其他图标"
L["options_scale"] = "縮放"
L["options_scale_desc"] = "1 = 100%"
L["options_opacity"] = "透明度"
L["options_opacity_desc"] = "0 = 透明, 1 = 不透明"

---------------------------------- VISIBILITY ---------------------------------

L["options_visibility_settings"] = "可见性"
L["options_general_settings"] = "一般"
L["options_toggle_looted_rares"] = "永远显示所有稀有"
L["options_toggle_looted_rares_desc"] = "显示所有稀有（不论当日是否已拾取其掉落）"
L["options_toggle_looted_treasures"] = "显示已拾取的宝藏"
L["options_toggle_looted_treasures_desc"] = "显示所有宝藏（不论当日是否已拾取其掉落）"
L["options_toggle_hide_done_rare"] = "隐藏已解锁所有掉落的稀有"
L["options_toggle_hide_done_rare_desc"] = "隐藏已解锁所有掉落的稀有，这意味着如果该稀有你没有需求，则不会显示在地图上"
L["options_toggle_hide_minimap"] = "隐藏小地图上的所有图标"
L["options_toggle_hide_minimap_desc"] = "在小地图上隐藏此插件的所有图标，当启用此选项时，插件只会在世界地图上显示"

L["options_toggle_battle_pets_desc"] = "显示宠物训练师的位置"
L["options_toggle_battle_pets"] = "战斗宠物"
L["options_toggle_caves_desc"] = "显示其它项的洞穴入口"
L["options_toggle_caves"] = "洞穴"
L["options_toggle_chests_desc"] = "显示宝箱位置 (每日刷新)。"
L["options_toggle_chests"] = "宝箱"
L["options_toggle_misc"] = "杂项"
L["options_toggle_npcs"] = "NPC"
L["options_toggle_rares_desc"] = "显示稀有位置"
L["options_toggle_rares"] = "稀有"
L["options_toggle_supplies_desc"] = "显示战争补给箱（空投）的位置"
L["options_toggle_supplies"] = "战争补给箱（空投）"
L["options_toggle_treasures"] = "宝藏"

---------------------------------- TOOLTIP ---------------------------------

L["options_tooltip_settings"] = "鼠标提示"
L["options_tooltip_settings_desc"] = "鼠标提示"
L["options_toggle_show_loot"] = "显示掉落"
L["options_toggle_show_loot_desc"] = "在鼠标提示中加入掉落信息"
L["options_toggle_show_notes"] = "显示注解"
L["options_toggle_show_notes_desc"] = "在鼠标提示中添加注解"

--------------------------------- DEVELOPMENT ---------------------------------

L["options_dev_settings"] = "开发"
L["options_dev_settings_desc"] = "开发者选项"
L["options_toggle_show_debug"] = "调试"
L["options_toggle_show_debug_desc"] = "显示调试内容"
L["options_toggle_force_nodes"] = "强制显示节点"
L["options_toggle_force_nodes_desc"] = "强制显示所有节点"
