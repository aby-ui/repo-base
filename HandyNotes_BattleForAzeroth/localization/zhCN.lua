local ADDON_NAME, ns = ...
local L = ns.NewLocale("zhCN")
if not L then return end

-------------------------------------------------------------------------------
----------------------------------- DRUSTVAR ----------------------------------
-------------------------------------------------------------------------------

L["ancient_sarco_note"] = "打开古代石棺来召唤数波 {npc:128181}。"
L["beshol_note"] = "打开显然很安全的宝箱来召唤稀有。"
L["cottontail_matron_note"] = "研究骇人的仪式颅骨来召唤稀有。"
L["gluttonous_yeti_note"] = "此 {npc:127979} 注定…"
L["idej_note"] = "昏迷他施放的 {spell:274005} 否则他会杀了 {npc:139380}！"
L["seething_cache_note"] = "打开沸燃之箱来召唤数波 {npc:129031}。"
L["the_caterer_note"] = "研究被砸烂的婚礼蛋糕来激活。"
L["vicemaul_note"] = "点击 {npc:127652} 来钓出稀有。"

L["merchants_chest_note"] = "击杀附近持有钥匙的 {npc:137468} 以获得 {item:163710}。"
L["wicker_pup_note"] = [[
点亮未激活的 {npc:143609} 来激活宝箱。组合所有四个箱子中的物品创建一个 {npc:143189}。

• 咒蛊：{item:163790}
• 附魔：{item:163796}
• 迷惑：{item:163791}
• 妖术：{item:163789}
]]

local runebound = "激活 {npc:143688} 按照宝箱后面金属板上显示的顺序：\n\n"
L["runebound_cache_note"] = runebound.."左 -> 下 -> 上 -> 右"
L["runebound_chest_note"] = runebound.."左 -> 右 -> 下 -> 上"
L["runebound_coffer_note"] = runebound.."右 -> 上 -> 左 -> 下"

L["captain_hermes_note"] = "耶！尝尝甲壳之力！"
L["dilbert_mcclint_note"] = "嗨，害虫防治专家呆伯特·麦克林特向您报道。非常高兴能和一位像我一样的蜘蛛爱好者一较高下。"
L["fizzie_spark_note"] = "你觉得你的宠物有机会打败我注入了艾泽里特的队伍？想得美！"
L["michael_skarn_note"] = "一旦我们开始战斗，你得记住这是你自找的。"

L["drust_facts_note"] = "阅读全部石碑获得成就。"
L["stele_forest_note"] = "奥尔法的兽穴内。"
L["options_icons_drust_facts_desc"] = "显示 {achievement:13064} 成就中石碑的位置。"
L["options_icons_drust_facts"] = "{achievement:13064}"

L["embers_crossbow_note"] = "两棵树中间的地上拾取 {item:163749}，然后把它带回戈尔瓦遗迹。"
L["embers_flask_note"] = "两块岩石中间的水里拾取 {item:163746}，然后把它带回戈尔瓦遗迹。"
L["embers_hat_note"] = "一堆骨头中拾取 {item:163748}，然后把它带回戈尔瓦遗迹。"
L["embers_knife_note"] = "从树干中拉出 {item:163747}，然后把它带回戈尔瓦遗迹。"
L["embers_golvar_note"] = "把每个古物放回戈尔瓦遗迹后完成成就。"
L["golvar_ruins"] = "戈尔瓦遗迹"
L["options_icons_ember_relics_desc"] = "显示 {achievement:13082} 成就中古物的位置。"
L["options_icons_ember_relics"] = "{achievement:13082}"

L["linda_deepwater_note"] = "要获得访问权限，必须完成就在安利港外面 {npc:136458} 的任务线。"

-------------------------------------------------------------------------------
----------------------------------- MECHAGON ----------------------------------
-------------------------------------------------------------------------------

L["avenger_note"] = "当 {npc:155254} 是访客时，击杀 {npc:151159}（在全地图跑）来刷新。"
L["beastbot_note"] = "在 {npc:150359} 制作一个 {item:168045} 来激活。"
L["cogstar_note"] = "在任意区域内击 {npc:150667} 直到他传送来加强它们。"
L["crazed_trogg_note"] = "在邦多的大杂院使用 {npc:154573} 或颜料囊袋，把自己染色成他大喊的颜色然后去找他。"
L["deepwater_note"] = "在 {npc:150359} 制作一个 {item:167649} 来召唤。"
L["doppel_note"] = "与其他两名玩家，使用 {daily:56405} 获得的 {item:169470} 来激活。"
L["foul_manifest_note"] = "连接三个断路器到水中的能量塔。"
L["furor_note"] = "在 {daily:55463} 期间，点击蓝色小 {npc:135497} 直到它刷新。"
L["killsaw_note"] = "在瀑溪森林任何地方出现，似乎因为击杀 {npc:151871} 后比较容易刷新。不会在风险投资公司在森林里时刷新，那时候没有 {npc:151871}。"
L["leachbeast_note"] = "使用 {item:168961} 来激活天气更迭器。"
L["nullifier_note"] = [[
侵入 {npc:152174} 使用其一：

• {npc:151625} 掉落的 {item:168435}。

• 钻机JD41与JD99的小怪掉落的 {item:168023} 。
]]
L["scrapclaw_note"] = "远离岸边的水中。"
L["sparkqueen_note"] = "只在 {daily:55765} 期间刷新。"
L["rusty_note"] = "在 {npc:150359} 制作一个 {item:169114} 进入平行未来时空。只在 {npc:153993} *不是*锈栓镇访客期间才会刷新。"
L["vaultbot_note"] = "风筝到邦多的大杂院的电磁圈或在 {npc:150359} 制作一个 {item:167062} 来打开它。"

L["iron_chest"] = "铁潮保险箱"
L["mech_chest"] = "机械化的宝箱"
L["msup_chest"] = "机械补给箱"
L["rust_chest"] = "生锈的旧箱子"
L["iron_chest_note"] = "西浪岩的怪掉落开启铁潮保险箱的钥匙。"
L["msup_chest_note"] = "西浪岩的怪掉落开启机械化的宝箱的钥匙。"
L["rust_chest_note"] = "西浪岩的怪掉落开启生锈的旧箱子的钥匙。"

L["rec_rig_note"] = "要激活困难模式，使用 {spell:292352} 武器將所有 {npc:150825} 转换为 {npc:151049}。宠物可以在两种难度获得。"

L["grease_bot_note"] = "点击 {npc:155911} 获取急速提高5%，移动速度提高10%持续2小时。"
L["shock_bot_note"] = "点击 {npc:155909} 获取闪电链伤害持续2小时。"
L["welding_bot_note"] = "点击 {npc:155910} 增加生命值和承受治疗效果提高10%持续2小时。"

L["options_icons_mech_buffs"] = "增益机器人"
L["options_icons_mech_buffs_desc"] = "显示 {npc:155911}、{npc:155909} 和 {npc:155910} 在地下城内地图上的位置。"
L["options_icons_mech_chest"] = "机械补给箱"
L["options_icons_mech_chest_desc"] = "显示机械补给箱的位置。有10个独立的箱子可以每日拾取一次，每个箱子有4-5个刷新位置。位置按颜色分组。"
L["options_icons_locked_chest"] = "锁住的箱子"
L["options_icons_locked_chest_desc"] = "在西浪岩显示锁住的箱子的位置。"
L["options_icons_recrig"] = "{npc:150448}"
L["options_icons_recrig_desc"] = "显示 {npc:150448} 的位置和奖励。"

-------------------------------------------------------------------------------
----------------------------------- NAZJATAR ----------------------------------
-------------------------------------------------------------------------------

L["naz_intro_note"] = "完成纳沙塔尔引导任务解锁稀有、宝藏及世界任务！"

L["alga_note"] = "注意：隐形并有四个增援！"
L["allseer_note"] = "在卡梅希尔低层的任何地方刷新。"
L["anemonar_note"] = "在它上方击杀 {npc:150467} 来激活。"
L["avarius_note"] = "使用 {item:167012} 收集并将彩色水晶放在基座上。你不必是一个矿工！"
L["banescale_note"] = "有很小的几率在击杀 {npc:152359} 后立即刷新。"
L["elderunu_note"] = "在卡梅希尔高层的任何地方刷新。"
L["gakula_note"] = "驱赶 {npc:152275} 直到它刷新。"
L["glimmershell_note"] = "有小几率在 {npc:152426} 的位置刷新。"
L["kelpwillow_note"] = "使用 {item:167893} 魅惑 {npc:154725} 到它身边来激活。"
L["lasher_note"] = "在土壤中种植 {item:166888} 并喂给它海萤。"
L["matriarch_note"] = "与另外两个鳞母共享刷新计时器。"
L["needle_note"] = "通常在女王之扉区域刷新。"
L["oronu_note"] = "召唤 {npc:154849} 来激活。"
L["rockweed_note"] = "击杀整个区域的 {npc:152549} 和 {npc:151166} 直到它刷新。建议组团，因为这可能需要很长时间。"
L["sandcastle_note"] = "使用 {item:167077} 在区域内任何地方探测宝箱直到它刷新。"
L["tidelord_note"] = "击杀三个 {npc:145326} 和被召唤的 {npc:153999} 直到海潮领主被召唤出来。"
L["tidemistress_note"] = "点击原状标本直到她刷新。"
L["urduu_note"] = "击杀一个 {npc:152563} 在它面前来激活。"
L["voice_deeps_notes"] = "使用一个 {item:168161} 来打碎岩石。"
L["vorkoth_note"] = "丢出 {item:167059} 到水池直到它刷新。"
L["area_spawn"] = "在周围地区刷新。"
L["cora_spawn"] = "在赤珊森林任意地方刷新。"
L["cave_spawn"] = "在洞穴中刷新。"
L["east_spawn"] = "在任何区域的东半部分刷新。"
L["ucav_spawn"] = "在水下的洞穴刷新。"
L["zone_spawn"] = "在整个区域刷新。"

L["assassin_looted"] = "充当刺客时拾取。"

L["arcane_chest"] = "奥术宝箱"
L["glowing_chest"] = "发光的奥能宝箱"
L["arcane_chest_01"] = "在一些海藻下。"
L["arcane_chest_02"] = "在建筑內部的上层。"
L["arcane_chest_03"] = "在第二层。"
L["arcane_chest_04"] = "在瀑布上方的水中。"
L["arcane_chest_05"] = "在废墟中。"
L["arcane_chest_06"] = "" -- in the open
L["arcane_chest_07"] = "在洞穴的后面。入口位于赞齐尔海床东侧。"
L["arcane_chest_08"] = "藏在一些海星下面。"
L["arcane_chest_09"] = "在珠躯爬蟹后面一个洞穴里。"
L["arcane_chest_10"] = "在一个蜕下的壳下面。"
L["arcane_chest_11"] = "在山顶。"
L["arcane_chest_12"] = "在瀑布顶部。"
L["arcane_chest_13"] = "在悬崖顶部，树后面。"
L["arcane_chest_14"] = "在艾露罗神殿內部。"
L["arcane_chest_15"] = "在建筑物右侧。"
L["arcane_chest_16"] = "在水下的洞穴。入口在南边。"
L["arcane_chest_17"] = "在瀑布顶部。"
L["arcane_chest_18"] = "在路径下方的一个洞穴里。"
L["arcane_chest_19"] = "在岩石拱门顶部。使用滑翔器。"
L["arcane_chest_20"] = "在山顶。"
L["glowing_chest_1"] = "在水下洞穴的后面，保护塔。"
L["glowing_chest_2"] = "解开连线。"
L["glowing_chest_3"] = "在洞穴的后面。保护塔。"
L["glowing_chest_4"] = "消掉三个红色符文。"
L["glowing_chest_5"] = "在洞穴内，保护塔。"
L["glowing_chest_6"] = "解开连线。"
L["glowing_chest_7"] = "消掉四个蓝色符文。"
L["glowing_chest_8"] = "在屋顶。保护塔。"

L["prismatic_crystal_note"] = "用它喂食小动物给纳沙塔尔的 {npc:151782}。"
L["strange_crystal"] = "奇怪的水晶"
L["strange_crystal_note"] = "解锁 {item:167893} 刷新，必须在此位置先拾取 {item:169778} 并把它上交 {quest:56560}。"
L["options_icons_prismatics"] = "{item:167893}"
L["options_icons_prismatics_desc"] = "显示喂食 {npc:151782} 的 {item:167893} 的位置。"

L["slimy_cocoon"] = "粘糊糊的茧"
L["ravenous_slime_note"] = "使用 {item:167893} 魅惑小动物喂养茧。重复五天直到它刷新一个宠物的蛋。茧会消失直到下周重置。"
L["slimy_cocoon_note"] = "一只宠物可以从茧中收集！如果它没有出现，茧在这个位面正在冷却，更换位面或稍后再来检查。"

L["cat_figurine"] = "水晶猫咪雕像"
L["cat_figurine_01"] = "在一个水下洞穴。雕像在露天的地板上。入口在东侧。"
L["cat_figurine_02"] = "在附近瀑布下的一个洞穴里。雕像在墙上的海星下面。"
L["cat_figurine_03"] = "在一个水下洞穴。雕像被藏在某些破碎的贝壳下。"
L["cat_figurine_04"] = "在一个水下洞穴。雕像在露天的地板上。"
L["cat_figurine_05"] = "在一个小洞穴。雕像隐藏在地板上的植物后面。"
L["cat_figurine_06"] = "在一个充满敌对的礁石行者的水下洞穴中。小雕像在墙上。入口在北侧。"
L["cat_figurine_07"] = "在一个小洞穴。雕像在一些珊瑚的墙上。"
L["cat_figurine_08"] = "在一个小洞穴。躲避奥术陷阱。雕像在后面的高大的岩石上。"
L["cat_figurine_09"] = "在一个水下洞穴。雕像位于天花板的岩石拱门上。"
L["cat_figurine_10"] = "在路径下方的一个洞穴里。雕像在三个桶之间。"
L["figurines_found"] = "已找到水晶猫咪雕像"

L["mardivas_lab"] = "马蒂瓦斯的实验室"
L["no_reagent"] = "不使用材料"
L["swater"] = "小水"
L["gwater"] = "大水"
L["sfire"] = "小火"
L["gfire"] = "大火"
L["searth"] = "小土"
L["gearth"] = "大土"
L["Arcane"] = "奥术融合体"
L["Watery"] ="水色融合体"
L["Burning"] ="燃炎融合体"
L["Dusty"] ="尘土融合体"
L["Zomera"] ="卓梅拉"
L["Omus"] ="奥姆斯"
L["Osgen"] ="奥斯吉恩"
L["Moghiea"] ="莫基艾"
L["Xue"] ="祖厄"
L["Ungormath"] ="安戈马斯"
L["Spawn"] ="索尔苟斯之嗣"
L["Herald"] ="索尔苟斯的使徒"
L["Salgos"] ="永恒的索尔苟斯"
L["tentacle_taco"] = "出售 {item:170100}，如果你穿着底栖 {item:169489}。"

L["options_icons_slimes_nazj"] = "{npc:151782}"
L["options_icons_slimes_nazj_desc"] = "显示四个喂食一次可获得宠物的贪婪的粘液位置。"
L["options_icons_cats_nazj"] = "{achievement:13836}"
L["options_icons_cats_nazj_desc"] = "显示 {achievement:13836} 成就水晶猫咪雕像位置。"
L["options_icons_misc_nazj"] = "杂项"
L["options_icons_misc_nazj_desc"] = "显示莫洛戈藏身处以及马蒂瓦斯的实验室的位置。"

-------------------------------------------------------------------------------
------------------------------------ NAZMIR -----------------------------------
-------------------------------------------------------------------------------

L["captain_mukala_note"] = "尝试拾取诅咒宝箱来召唤 {npc:125232}。"
L["enraged_water_note"] = "检查 {npc:134295} 来召唤 {npc:134294}。"
L["lucille_note"] = "和 {npc:134297} 交谈来召唤稀有。"
L["offering_to_bwonsamdi_note"] = "跑到附近的树上然后跳进破碎的建筑中。"
L["shambling_ambusher_note"] = "尝试拾取 {npc:124473} 来激活稀有。"
L["zaamar_note"] = "在冥宫古墓内，入口在南侧。"

L["grady_prett_note"] = "是时候下场战斗了！来吧！"
L["korval_dark_note"] = "这地方真吓人，我们快点打完吧。"
L["lozu_note"] = "我们来荣耀地战斗吧，陌生人。"

L["tales_bwonsamdi_note"] = "在被毁的柱子上。"
L["tales_hireek_note"] = "桌子上的卷轴。"
L["tales_kragwa_note"] = "在被毁的墙上。"
L["tales_torga_note"] = "水下被毁的柱子上。"

L["carved_in_stone_41860"] = "在山附近一栋被毁的建筑物内。"
L["carved_in_stone_41861"] = "在被毁的柱子上。"
L["carved_in_stone_41862"] = "在被毁的墙上，在巨大的柱子前面。"
L["carved_in_stone_42116"] = "{npc:126126} 旁边的柱子上。"
L["options_icons_carved_in_stone"] = "{achievement:13024}"
L["options_icons_carved_in_stone_desc"] = "显示 {achievement:13024} 成就中象形图画的位置。"

L["hoppin_sad_53419"] = "两棵树后面巨大树根下面。"
L["hoppin_sad_53420"] = "废墟内。"
L["hoppin_sad_53424"] = "悬崖上。"
L["hoppin_sad_53425"] = "瀑布旁边的树上。"
L["hoppin_sad_53426"] = "一些树根下。"

L["options_icons_hoppin_sad"] = "{achievement:13028}"
L["options_icons_hoppin_sad_desc"] = "显示 {achievement:13028} 成就中 {npc:143317} 的位置。"

-------------------------------------------------------------------------------
------------------------------- STORMSONG VALLEY ------------------------------
-------------------------------------------------------------------------------

L["in_basement"] = "在地下室。"
L["jakala_note"] = "和 {npc:140925} 交谈。"
L["nestmother_acada_note"] = "点击阿卡达之巢来刷新此稀有。"
L["sabertron_note"] = "击杀 {npc:139334} 来激活 {npc:139328} 其中之一。"
L["whiplash_note"] = "只在 {wq:食肉笞} 激活时刷新。"

L["discarded_lunchbox_note"] = "建筑物内书架顶上。"
L["hidden_scholars_chest_note"] = "建筑物屋顶上。"
L["honey_vat"] =  "蜂蜜大桶"
L["smugglers_stash_note"] = "平台下面水中。"
L["sunken_strongbox_note"] = "船下面水中。"
L["venture_co_supply_chest_note"] = "爬上船上的梯子。"
L["weathered_treasure_chest_note"] = "此洞穴藏在一群树后面。"

L["curious_grain_sack"] = "奇怪的谷物袋"
L["small_treasure_chest"] = "小宝箱"
L["small_treasure_51927"] = "建筑物内楼梯下。"
L["small_treasure_51940"] = "建筑物内。"

L["eddie_fixit_note"] = "准备面对我的高度定制版改装机器人小队吧！"
L["ellie_vern_note"] = "但我有海洋中最强的生物为我而战，你根本不可能赢。"
L["leana_darkwind_note"] = "我怀疑这片大陆的奇怪生物也会带来奇怪的战斗。"

L["honeyback_harvester_note"] = "和 {npc:155193} 交谈开始事件。新鲜的蜜胶块每小时可以拾取一次，一小时后重置。"
L["options_icons_honeybacks"] = "{npc:155193}"
L["options_icons_honeybacks_desc"] = "显示收割蜜背蜂群声望的 {npc:155193} 事件位置。"

L["lets_bee_friends_note"] = "完成 {daily:53371} 七次后获得成就和宠物。并解锁日常："
L["lets_bee_friends_step_1"] = "完成米登霍尔蜜酒庄任务线直到 {quest:50553}。"
L["lets_bee_friends_step_2"] = "在米登霍尔蜜酒庄击杀 {npc:133429} 和 {npc:131663} 直到找到 {item:163699}。"
L["lets_bee_friends_step_3"] = "把 {item:163699} 交给位于伯拉勒斯 {npc:143128}。"
L["lets_bee_friends_step_4"] = "把 {item:163702} 交给位于米登霍尔蜜酒庄 {npc:133907}。"
L["lets_bee_friends_step_5"] = "完成 {npc:133907} 的 {quest:53347}。"

local luncheon = (UnitFactionGroup('player') == 'Alliance') and '{npc:138221} 位于布伦纳丹' or '{npc:138096} 位于战牙要塞'
L["these_hills_sing_note"] = "在这里打开 {item:160485}。从"..luncheon.."购买或者从布伦纳丹的“被丢弃的午餐盒”拾取宝藏。"

L["ancient_tidesage_scroll"] = "古代海潮贤者卷轴"
L["ancient_tidesage_scroll_note"] = "阅读全部8个海潮贤者卷轴获得成就。"
L["options_icons_tidesage_legends"] = "{achievement:13051}"
L["options_icons_tidesage_legends_desc"] = "显示 {achievement:13051} 成就中古代卷轴的位置。"

L["long_forgotten_rum_note"] = "要进入洞穴，必须完成位于死亡浅滩 {npc:134710} 的 {quest:50697}。德鲁斯瓦 {npc:137040} 也出售。"

-------------------------------------------------------------------------------
------------------------------- TIRAGARDE SOUND -------------------------------
-------------------------------------------------------------------------------

L["honey_slitherer_note"] = "和 {npc:137176} 交谈来召唤稀有。"
L["tempestria_note"] = "检查可疑的肉堆来召唤稀有。"
L["twin_hearted_note"] = "惊动仪式雕像来激活构造体。"
L["wintersail_note"] = "摧毁走私者的箱子来召唤船长。"

L["hay_covered_chest_note"] = "骑上 {npc:130350} 沿路往下走到达 {npc:131453} 来刷新宝藏。"
L["pirate_treasure_note"] = [[
需要对应的藏宝图。

地图从任意的库尔提拉斯的海盗怪物掉落。自由镇（开放世界）是个收割海盗的好地点。
]]

local damp_note =  "\n\n阅读全部五个卷轴以获得宝藏权限。"

L["damp_scroll"] = "受潮的卷轴"
L["damp_scroll_note_1"] = "入口在斯托颂修道院。"..damp_note
L["damp_scroll_note_2"] = "地下室 {npc:136343}后面的地上。"..damp_note
L["damp_scroll_note_3"] = "楼上 {npc:136343} 旁边的地上。"..damp_note
L["damp_scroll_note_4"] = "地下室 {npc:136343}旁边的地上。"..damp_note
L["damp_scroll_note_5"] = "在木板路下的一个角落。"..damp_note
L["ominous_altar"] = "不祥祭坛"
L["ominous_altar_note"] = "和不祥祭坛交谈会被传送到宝藏。"
L["secret_of_the_depths_note"] = "阅读全部五个卷轴，然后和不祥祭坛交谈会被传送到宝藏。"

L["burly_note"] = "这些小家伙很奇怪，但确实强而有力。你确定要进行战斗？"
L["delia_hanako_note"] = "在我们开始之前，我想要提醒你，当我的队伍把你的碾压了之后，可不要哭鼻子。"
L["kwint_note"] = "一个人对一头鲨鱼，可能还算是一场公平的较量。但是一对三？你可真是疯了。"

L["shanty_fruit_note"] = "拾取布满灰尘的歌谱，在小洞穴内的地面上。"
L["shanty_horse_note"] = "拾取痞子的歌谱，在酒馆内的吧台上。"
L["shanty_inebriation_note"] = "拾取杰伊的歌谱，在 {npc:141066} 后面地面上。"
L["shanty_lively_note"] = "拾取罗素的歌谱，在壁炉架顶上。"
L["options_icons_shanty_raid"] = "{achievement:13057}"
L["options_icons_shanty_raid_desc"] = "显示 {achievement:13057} 成就中禁忌船歌的位置。"

L["upright_citizens_node"] = [[
每当 {wq:烂醉市民旅团} 突袭任务激活时，以下三个 NPC 之一就会出现。

• {npc:146295}
• {npc:145107}
• {npc:145101}

招募每个人来完成成就。突袭时期需要多次检查区域，世界任务和准确的 NPC 处于激活状态。
]]
L["options_icons_upright_citizens"] = "{achievement:13285}"
L["options_icons_upright_citizens_desc"] = "显示 {achievement:13285} 成就中 NPC 的位置。"

-------------------------------------------------------------------------------
------------------------------------ ULDUM ------------------------------------
-------------------------------------------------------------------------------

L["uldum_intro_note"] = "完成奥丹姆引导任务解锁稀有、宝藏及突袭任务！"

L["aqir_flayer"] = "与 {npc:163114} 和 {npc:154365} 共享刷新点。"
L["aqir_titanus"] = "与 {npc:154353} 共享刷新点。"
L["aqir_warcaster"] = "与 {npc:154352} 共享刷新点。"
L["atekhramun"] = "踩死周围的 {npc:152765} 直到稀有出现。"
L["chamber_of_the_moon"] = "在月亮密室下面。"
L["chamber_of_the_stars"] = "在群星密室下面。"
L["chamber_of_the_sun"] = "在太阳密室里面。"
L["dunewalker"] = "点击平台上方的太阳精华释放它。"
L["friendly_alpaca"] = "每天可以喂食 {npc:162765} 一个 {item:174858}，7天(次)后会获得坐骑。在一个位置只出现10分钟，然后在一个较长的刷新时间后再次出现。"
L["gaze_of_nzoth"] = "与 {npc:156890} 共享刷新。"
L["gersahl_note"] = "用于喂食 {npc:162765} 七次后可以获得坐骑。不需要草药学。"
L["gersahl"] = "基萨尔野菜"
L["hmiasma"] = "喂食它周围的软泥直到激活。"
L["kanebti"] = "从 {npc:152427} 身上收集 {item:168160}，与一般的 {npc:151859} 共享刷新。把雕像插入甲虫神龛召唤稀有。"
L["neferset_rare"] = "这六个稀有在尼斐塞特具有共享三个刷新点。 完成召唤仪式事件后，将随机刷新三个。"
L["platform"] = "刷新在浮空平台顶部。"
L["right_eye"] = "掉落 {item:175140} 玩具的 {item:175142}。"
L["single_chest"] = "此宝箱只在一处刷新！如果没有在这没有发现，等待一会儿将会刷新。"
L["tomb_widow"] = "当柱子上出现白色卵囊时，杀死看不见的蜘蛛召唤。"
L["uatka"] = "需要三个人分别同时点击 {npc:152777}，消耗一个 {item:171208} 出自阿玛塞特圣箱。"
L["wastewander"] = "与 {npc:154369} 共享刷新点。"

L["amathet_cache"] = "阿玛赛特之箱"
L["black_empire_cache"] = "黑暗帝国宝箱"
L["black_empire_coffer"] = "黑暗帝国宝匣"
L["infested_cache"] = "感染宝箱"
L["infested_strongbox"] = "感染的保险箱"
L["amathet_reliquary"] = "阿玛赛特圣箱"

L["options_icons_assault_events"] = "突袭事件"
L["options_icons_assault_events_desc"] = "显示可能的突袭事件的位置。"
L["options_icons_coffers"] = "上锁的箱子"
L["options_icons_coffers_desc"] = "显示上锁的箱子（每次突袭拾取一次）。"

L["ambush_settlers"] = "击败几波怪物直到事件结束。"
L["burrowing_terrors"] = "踩死 {npc:162073}。"
L["call_of_void"] = "净化仪式晶塔。"
L["combust_cocoon"] = "捡起自制火焰炸弹，然后丢到空中的卵上。"
L["dormant_destroyer"] = "点击全部虚空浮石水晶。"
L["executor_nzoth"] = "击杀 {npc:157680}，然后摧毁执行者之锚。"
L["hardened_hive"] = "拾取 {spell:317550} 然后烧毁所有的虫卵。"
L["in_flames"] = "拿起水桶扑灭火焰。"
L["monstrous_summon"] = "击杀全部 {npc:160914} 停止召唤。"
L["obsidian_extract"] = "摧毁所有虚化黑曜石水晶。"
L["purging_flames"] = "捡起尸体，丢进火里。"
L["pyre_amalgamated"] = "地上有个融合者的火堆，点击之后击杀小怪直到稀有出现。"
L["ritual_ascension"] = "击杀 {npc:152233}。"
L["solar_collector"] = "使收集器开启所有周边的全部5个模块。点击一个模块也会切换与它相邻的模块。"
L["summoning_ritual"] = "击杀侍战者后传送门关闭。几次事件完成后，尼斐塞特周围将刷新一组三种稀有怪。"
L["titanus_egg"] = "摧毁 {npc:163257}，然后击杀 {npc:163268}。"
L["unearthed_keeper"] = "摧毁 {npc:156849}。"
L["virnall_front"] = "击败几波怪物之后 {npc:152163} 刷新。"
L["voidflame_ritual"] = "扑灭所有虚触蜡烛。"

L["beacon_of_sun_king"] = "向内旋转三个雕像。"
L["engine_of_ascen"] = "将四个雕像分别挡住激光。"
L["lightblade_training"] = "击杀导师和学徒直到 {npc:152197} 刷新。"
L["raiding_fleet"] = "使用任务物品烧掉所有船只。"
L["slave_camp"] = "打开周围所有奴隶笼子。"
L["unsealed_tomb"] = "在几波怪中保护 {npc:152439}。"

-------------------------------------------------------------------------------
------------------------------------ VALE -------------------------------------
-------------------------------------------------------------------------------

L["vale_intro_note"] = "完成锦绣谷引导任务解锁稀有、宝藏及突袭任务！"

L["big_blossom_mine"] = "在繁盛矿洞里面，入口在东北方向。"
L["guolai"] = "在郭莱古厅里面。"
L["guolai_left"] = "进入郭莱古厅（左侧通道）。"
L["guolai_center"] = "进入郭莱古厅（中间通道）。"
L["guolai_right"] = "进入郭莱古厅（右侧通道）。"
L["left_eye"] = "掉落 {item:175140} 玩具的 {item:175141}。"
L["pools_of_power"] = "在能量池中，入口在鎏金亭。"
L["tisiphon"] = "点击丹妮尔的好运鱼竿。"

L["ambered_cache"] = "琥珀宝箱"
L["ambered_coffer"] = "琥珀制成的箱子"
L["mogu_plunder"] = "魔古掠夺品"
L["mogu_strongbox"] = "魔古保险箱"

L["abyssal_ritual"] = "击杀 {npc:153179} 之后再杀 {npc:153171}。"
L["bound_guardian"] = "击杀3个 {npc:154329} 解救 {npc:154328}。"
L["colored_flames"] = "从火把上收集彩色火焰，并带到相符的符文上。"
L["construction_ritual"] = "将老虎雕像推入光线中。"
L["consuming_maw"] = "净化生长物和触须，直到被踢出。"
L["corruption_tear"] = "抓住 {spell:305470}，在不让旋转的眼睛撞到你的情况下关闭眼泪。"
L["electric_empower"] = "击杀 {npc:153095}，然后击杀 {npc:156549}。"
L["empowered_demo"] = "关闭所有精神补给品。"
L["empowered_wagon"] = "捡起 {npc:156300} 然后放在强化的战车下面。"
L["feeding_grounds"] = "销毁琥珀容器和静滞容器。"
L["font_corruption"] = "旋转魔古雕像将光束连接到泰坦控制台左右两边的小圆柱上，然后点击泰坦控制台。"
L["goldbough_guardian"] = "从多波怪中保护 {npc:156623}。"
L["infested_statue"] = "把眼睛从雕像上拽开。"
L["kunchong_incubator"] = "摧毁所有力场生成器。"
L["mantid_hatch"] = "拾取 {spell:305301} 烧毁所有螳螂妖虫卵。"
L["mending_monstro"] = "摧毁所有愈疗琥珀。"
L["mystery_sacro"] = "摧毁全部可疑的墓碑，然后击杀 {npc:157298}。"
L["noodle_cart"] = "在 {npc:157615} 修理购物车时保卫他。"
L["protect_stout"] = "从多波怪物中保护洞穴。"
L["pulse_mound"] = "击杀周围全部怪物，然后击杀 {npc:157529}。"
L["ravager_hive"] = "摧毁树上全部蜂巢。"
L["ritual_wakening"] = "击杀 {npc:157942}。"
L["serpent_binding"] = "击杀 {npc:157345}，然后击杀 {npc:157341}。"
L["stormchosen_arena"] = "清除竞技场全部怪物，然后击杀氏族将军。"
L["swarm_caller"] = "销毁虫群召唤器。"
L["vault_of_souls"] = "打开宝库，摧毁所有雕像。"
L["void_conduit"] = "点击虚空浮石后去踩眼睛。"
L["war_banner"] = "燃烧战旗然后杀怪，直到指挥官出现。"
L["weighted_artifact"] = "拾取沉得出奇的花瓶并迷宫返回到基座。被雕像晕住花瓶会掉。"

-------------------------------------------------------------------------------
----------------------------------- VISIONS -----------------------------------
-------------------------------------------------------------------------------

L["colored_potion"] = "彩色药水"
L["colored_potion_note"] = [[
%s尸体旁边的药水始终暗示进程中负面效果药水的颜色。

+100理智药水的颜色可以由该药水的颜色确定（|cFFFF0000坏|r => |cFF00FF00好|r）：

黑 => 绿
蓝 => 紫
绿 => 红
紫 => 黑
红 => 蓝
]]

L["bear_spirit_note"] = "击杀 {npc:160404} 和全部波数怪物获得10%急速增益。"
L["buffs_change"] = "可用增益每次更换。如果建筑物关闭或没有 NPC 与物体，则本次没有此增益。"
L["clear_sight"] = "需要 {spell:307519} 等级%d。"
L["craggle"] = "丢下一个玩具到地上（比如 {item:44606}）分散他的注意力。拉开并优先击杀机器人。"
L["empowered_note"] = "穿过地雷阵并站在楼上的 {npc:161324} 获得10%伤害增益。"
L["enriched_note"] = "击杀 {npc:161293} 获得10%爆击率增益。"
L["ethereal_essence_note"] = "击杀 {npc:161198} 获得10%爆击率增益。"
L["ethereal_note"] = "收集隐藏在整个视野中的橙色水晶，并将其交还给 {npc:162358} 以获取额外的纪念品。总共有10个水晶，每个区域2个。\n\n|cFF00FF00别忘了拾取宝箱！|r"
L["heroes_bulwark_note"] = "击杀旅店的 {npc:158588} 获得10%生命值增益。"
L["inside_building"] = "建筑物内。"
L["mailbox"] = "邮箱"
L["mail_muncher"] = "打开邮箱有机会刷新 {npc:160708}。"
L["odd_crystal"] = "怪异水晶"
L["requited_bulwark_note"] = "击杀 {npc:157700} 获得7%全能增益。"
L["shave_kit_note"] = "理发店内。拾取桌子上的箱子。"
L["smiths_strength_note"] = "击杀铁匠小屋的 {npc:158565} 获得10%伤害增益。"
L["spirit_of_wind_note"] = "击杀 {npc:161140} 获得10%急速和移动速度增益。"
L["void_skull_note"] = "点击地面上的骷髅拾取玩具。"

L["c_alley_corner"] = "在小巷的一个角落。"
L["c_bar_upper"] = "在酒吧内上层。"
L["c_behind_bank_counter"] = "在银行柜台后面的后面。"
L["c_behind_boss"] = "在难民建筑首领的后面。"
L["c_behind_boxes"] = "在一些箱子后面角落。"
L["c_behind_cart"] = "在一辆被毁的车后面。"
L["c_behind_house_counter"] = "在房子里的柜台后面。"
L["c_behind_mailbox"] = "在邮箱后面。"
L["c_behind_pillar"] = "隐藏在使馆建筑后面的柱子后面。"
L["c_behind_rexxar"] = "隐藏在 {npc:155098} 建筑后面的右侧。"
L["c_behind_stables"] = "在 {npc:158157} 马厩的后面。"
L["c_by_pillar_boxes"] = "在柱子和一些箱子之间的墙上。"
L["c_center_building"] = "在中心建筑的底层。"
L["c_forge_corner"] = "在锻造的角落。"
L["c_hidden_boxes"] = "隐藏在 {npc:152089} 建筑后面的一些箱子后面。"
L["c_inside_auction"] = "在拍卖行内右侧。"
L["c_inside_big_tent"] = "在大帐篷里的左边。"
L["c_inside_cacti"] = "在仙人掌叶片内附近角落。"
L["c_inside_hut"] = "在右边的第一个小屋内。"
L["c_inside_leatherwork"] = "在制皮建筑内。"
L["c_inside_orphanage"] = "在孤儿院里。"
L["c_inside_transmog"] = "在幻化小屋内。"
L["c_left_cathedral"] = "隐藏在大教堂入口左侧。"
L["c_left_inquisitor"] = "在审讯官小首领的后面阶梯左侧。"
L["c_on_small_hill"] = "在小山顶上。"
L["c_top_building"] = "在建筑物顶层。"
L["c_underneath_bridge"] = "在桥下。"
L["c_walkway_corner"] = "在上层行道的角落。"
L["c_walkway_platform"] = "在行道上面的平台上。"

L["options_icons_visions_buffs"] = "增益"
L["options_icons_visions_buffs_desc"] = "显示获得1小时伤害增益的事件位置。"
L["options_icons_visions_chest"] = "宝箱"
L["options_icons_visions_chest_desc"] = "显示惊魂幻象内可能的宝箱位置。"
L["options_icons_visions_crystals"] = "怪异水晶"
L["options_icons_visions_crystals_desc"] = "显示惊魂幻象内怪异水晶可能的位置。"
L["options_icons_visions_mail"] = "邮箱"
L["options_icons_visions_mail_desc"] = "显示 {item:174653} 坐骑的邮箱位置。"
L["options_icons_visions_misc"] = "杂项"
L["options_icons_visions_misc_desc"] = "显示惊魂幻象内稀有，玩具，药水和虚灵的位置。"

-------------------------------------------------------------------------------
----------------------------------- VOLDUN ------------------------------------
-------------------------------------------------------------------------------

L["bloodwing_bonepicker_note"] = "拾取山顶的 {npc:136390} 来召唤秃鹫。"
L["nezara_note"] = "切断拴在 {npc:128952} 上的绳子释放稀有。"
L["vathikur_note"] = "击杀 {npc:126894} 召唤稀有。"
L["zunashi_note"] = "入口在北方巨大头骨的嘴里。"

L["ashvane_spoils_note"] = "坐上 {npc:132662} 下山来刷新下面的宝箱。"
L["excavators_greed_note"] = "在倒塌的隧道内。"
L["grayals_offering_note"] = "完成 {quest:50702} 后，进入阿图阿曼并点击上古祭坛来刷新宝箱。"
L["kimbul_offerings_note"] = "在吉布尔神殿上方的山上。"
L["sandsunken_note"] = "点击被遗弃的浮标把宝箱从沙子里拉出来。"

L["keeyo_note"] = "是时候开始一场精彩的冒险了！"
L["kusa_note"] = "我正保持连胜，你不可能战胜我和我的队伍。"
L["sizzik_note"] = "我一直很欣赏能和新的挑战者来一场精彩的战斗。"

L["tales_akunda_note"] = "在池塘里。"
L["tales_kimbul_note"] = "在枯树旁。"
L["tales_sethraliss_note"] = "在桌子旁边的地面上。"

L["plank_1"] = "沙漠边缘的山顶。"
L["plank_2"] = "损坏的建筑物旁边。"
L["plank_3"] = "在金字塔的一侧。路径从附近的另一个木板开始。"
L["plank_4"] = "在金字塔侧面的沙丘顶部。"
L["plank_5"] = "沿着蛇的尾巴找到木板。"
L["planks_ridden"] = "骑上摇晃的木板"
L["options_icons_dune_rider"] = "{achievement:13018}"
L["options_icons_dune_rider_desc"] = "显示 {achievement:13018} 成就中摇晃的木板的位置。"

L["options_icons_scavenger_of_the_sands"] = "{achievement:13016}"
L["options_icons_scavenger_of_the_sands_desc"] = "显示 {achievement:13016} 成就中垃圾物品的位置。"

L["elusive_alpaca"] = "将 {item:161128} 喂给 {npc:162681} 以获得坐骑。一个位置存在10分钟，很长时间刷新。"

-------------------------------------------------------------------------------
---------------------------------- WARFRONTS ----------------------------------
-------------------------------------------------------------------------------

L["boulderfist_outpost"] = "进入石拳岗哨（一个大洞穴）。入口在东北方。"
L["burning_goliath_note"] = "击杀后，一个 {npc:141663} 将在 {npc:141668} 附近刷新。"
L["cresting_goliath_note"] = "击杀后，一个 {npc:141658} 将在 {npc:141668} 附近刷新。"
L["rumbling_goliath_note"] = "击杀后，一个 {npc:141659} 将在 {npc:141668} 附近刷新。"
L["thundering_goliath_note"] = "击杀后，一个 {npc:141648} 将在 {npc:141668} 附近刷新。"
L["echo_of_myzrael_note"] = "一旦四个元素巨怪被击杀后，{npc:141668} 将出现。"
L["frightened_kodo_note"] = "几分钟后会消失。服务器重启后肯定刷新。"

-------------------------------------------------------------------------------
----------------------------------- ZULDAZAR ----------------------------------
-------------------------------------------------------------------------------

L["murderbeak_note"] = "把鱼饵扔进海里，然后击杀数只 {npc:134780} 直到 {npc:134782} 刷新。"
L["vukuba_note"] = "调查 {npc:134049}，然后击杀数波 {npc:134047} 直到 {npc:134048} 刷新。"

L["cache_of_secrets_note"] = "瀑布后面的洞穴内一个 {npc:137234} 拿着。"
L["da_white_shark_note"] = "站在 {npc:133208} 附近直到她变为敌对。"
L["dazars_forgotten_chest_note"] = "路径开始于 {npc:134738} 附近。"
L["gift_of_the_brokenhearted_note"] = "放置熏香刷新宝箱。"
L["offerings_of_the_chosen_note"] = "位于赞枢尔第二层。"
L["riches_of_tornowa_note"] = "在悬崖边上。"
L["spoils_of_pandaria_note"] = "在船的下层甲板。"
L["tiny_voodoo_mask_note"] = "在 {npc:141617} 棚子的上方。"
L["warlords_cache_note"] = "在船舵顶层。"

L["karaga_note"] = "我已经很久没战斗过了，不过我仍然很有机会战胜你。"
L["talia_spark_note"] = "这片大陆上的小动物很凶猛，我希望你准备好了。"
L["zujai_note"] = "你居然到我家来找我战斗？祝你好运。"

L["kuafon_note"] = [[
从赞达拉的任意翼手龙拾取一个 {item:157782} 开始任务线。一些任务将花费数天来完成。

最好收割的怪物是赞枢尔的 {npc:126618} 或位于塔尔格拉布南侧裂天者林地的 {npc:122113}。
]]
L["torcali_note"] = "在战兽栏完成任务直到 {quest:47261} 变为可用。一些任务将花费数天来完成。"

L["totem_of_paku_note"] = "和巨擘封印北侧的 {npc:137510} 交谈选择帕库为你的祖达萨洛阿神灵。"
L["options_icons_paku_totems"] = "帕库图腾"
L["options_icons_paku_totems_desc"] = "显示达萨罗 {npc:131154} 和他的旅行路径。"

L["tales_gonk_note"] = "在毯子上。"
L["tales_gral_note"] = "在树的根部。"
L["tales_jani_note"] = "在被毁的柱子上。"
L["tales_paku_note"] = "建筑物顶上，水旁边的岩石上。"
L["tales_rezan_note"] = "{npc:136428} 洞穴的上面。"
L["tales_shadra_note"] = "入口旁边，火炬后面。"
L["tales_torcali_note"] = "在几个桶和楼梯之间。"
L["tales_zandalar_note"] = "{npc:132989} 后面。"

local shared_dinos = "从 {npc:133680} 的任务线 {daily:50860} 日常必须激活（四个可能的日常之一）让他们出现，任何人可以在这些天看到他们。"
L["azuresail_note"] = "与 {npc:135512} 和 {npc:135508} 共享刷新计时器。\n\n"..shared_dinos
L["thunderfoot_note"] = "与 {npc:135510} 和 {npc:135508} 共享刷新计时器。\n\n"..shared_dinos
L["options_icons_life_finds_a_way"] = "{achievement:13048}"
L["options_icons_life_finds_a_way_desc"] = "显示 {achievement:13048} 成就中可怕恐龙的位置。"

-------------------------------------------------------------------------------
--------------------------------- ACROSS ZONES --------------------------------
-------------------------------------------------------------------------------

L["goramor_note"] = "从位于悲伤之地附近的小洞穴内的 {npc:126833} 购买一个 {item:163563} 并喂给 {npc:143644}。"
L["makafon_note"] = "从位于鳞商驿站的 {npc:124034} 购买一个 {item:163564} 并喂给 {npc:130922}。"
L["stompy_note"] = "从位于风花绿洲北侧的 {npc:133833} 购买一个 {item:163567} 并喂给 {npc:143332}。"
L["options_icons_brutosaurs"] = "{achievement:13029}"
L["options_icons_brutosaurs_desc"] = "显示 {achievement:13029} 成就中雷龙的位置。"

local hekd_note = "\n\n要获得 {npc:126334} 访问权限，必须完成任务 %s。"
if UnitFactionGroup('player') == 'Horde' then
    hekd_note = hekd_note:format("位于达萨罗 {npc:127665} 的 {quest:47441} 然后是 {npc:126334} 的 {quest:47442}")
else
    hekd_note = hekd_note:format("位于沃顿 {npc:136562} 的 {quest:51142} 然后是 {npc:136559} 的 {quest:51145}")
end
local hekd_quest = "从 {npc:126334} 完成任务 %s。"..ns.color.Orange(hekd_note)
local hekd_item = "从垃圾堆附近的 %s 拾取 %s 并带给 {npc:126334}。"..ns.color.Orange(hekd_note)

L["charged_junk_note"] = format(hekd_item, "球潮虫", "{item:158910}")
L["feathered_junk_note"] = format(hekd_item, "{npc:132410}", "{item:157794}")
L["golden_junk_note"] = format(hekd_item, "暴掠龙", "{item:156963}")
L["great_hat_junk_note"] = format(hekd_quest, "{quest:50381}")
L["hunter_junk_note"] = format(hekd_quest, "{quest:50332}")
L["loa_road_junk_note"] = format(hekd_quest, "{quest:50444}")
L["nazwathan_junk_note"] = format(hekd_item, "纳兹瓦萨亡灵", "{item:157802}")
L["redrock_junk_note"] = format(hekd_item, "赤岩土狼", "{item:158916}")
L["ringhorn_junk_note"] = format(hekd_item, "{npc:130321}", "{item:158915}")
L["saurid_junk_note"] = format(hekd_quest, "{quest:50901}")
L["snapjaw_junk_note"] = format(hekd_item, "钳嘴鳄鱼", "{item:157801}")
L["vilescale_junk_note"] = format(hekd_item, "邪鳞纳迦", "{item:157797}")
L["options_icons_get_hekd"] = "{achievement:12482}"
L["options_icons_get_hekd_desc"] = "显示 {achievement:12482} 成就中 {npc:126334} 任务的位置。"

L["options_icons_mushroom_harvest"] = "{achievement:13027}"
L["options_icons_mushroom_harvest_desc"] = "显示 {achievement:13027} 成就中真菌人的位置。"

L["options_icons_tales_of_de_loa"] = "{achievement:13036}"
L["options_icons_tales_of_de_loa_desc"] = "显示 {achievement:13036} 成就中洛阿神灵传说的位置。"

L["jani_note"] = "点击神秘垃圾堆显露 {npc:126334}。"
L["rezan_note"] = ns.color.Red("位于阿塔达萨地下城。")
L["bow_to_your_masters_note"] = "向赞达拉洛阿神灵鞠躬（"..ns.color.Orange('/bow（/鞠躬）').."）。"
L["options_icons_bow_to_your_masters"] = "{achievement:13020}"
L["options_icons_bow_to_your_masters_desc"] = "显示 {achievement:13020} 成就中洛阿神灵的位置。"

L["alisha_note"] = "此供应商需要德鲁斯瓦的任务进度。"
L["elijah_note"] = "此供应商需要德鲁斯瓦的任务进度。完成 {quest:47945} 后他开始出售香肠。"
L["raal_note"] = ns.color.Red("维克雷斯庄园地下城内。")
L["sausage_sampler_note"] = "品尝每种香肠获得成就。"
L["options_icons_sausage_sampler"] = "{achievement:13087}"
L["options_icons_sausage_sampler_desc"] = "显示 {achievement:13087} 成就中供应商的位置。"

-- For Horde, include a note about drinks that must be purchased on the AH
local horde_sheets = (UnitFactionGroup('player') == 'Horde') and [[ 以下饮料部落不提供，必须在拍卖行购买：

• {item:163639}
• {item:163638}
• {item:158927}
• {item:162026}
• {item:162560}
• {item:163098}
]] or ''
L["three_sheets_note"] = "获得所有饮料中的每一种获得成就。"..horde_sheets
L["options_icons_three_sheets"] = "{achievement:13061}"
L["options_icons_three_sheets_desc"] = "显示 {achievement:13061} 成就中供应商的位置。"

L["options_icons_daily_chests_desc"] = "显示宝箱位置（每日可拾取）。"
L["options_icons_daily_chests"] = "宝箱"

L["supply_chest"] = "战争补给箱"
L["supply_chest_note"] = "一个 {npc:135181} 或 {npc:138694} 每隔45分钟就会在头顶飞过一次，并空投一个 {npc:135238} 到潜在可能的三个位置之一。"
L["supply_single_drop"] = ns.color.Orange("该飞行路线总是将补给箱空投到此位置。")
L["options_icons_supplies_desc"] = "显示全部可能出现战争补给箱的位置。"
L["options_icons_supplies"] = "{npc:135238}"

L["secret_supply_chest"] = "秘密补给箱"
L["secret_supply_chest_note"] = "当阵营入侵激活时，"..ns.color.Yellow("秘密补给箱").." 可能短时间出现在这些位置之一。"
L["options_icons_secret_supplies"] = "秘密补给箱"
L["options_icons_secret_supplies_desc"] = "显示 {achievement:13317} 成就中 "..ns.color.Yellow("秘密补给箱").." 的位置。"