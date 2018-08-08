local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_Argus", "zhCN")

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

_L["Watcher Aival"] = "监视者艾瓦";
_L["Watcher Aival_search"] = { "监视者艾瓦", "艾瓦", "watcher aival" };
_L["Watcher Aival_note"] = "";
_L["Puscilla"] = "普希拉";
_L["Puscilla_search"] = { "普希拉", "puscilla" };
_L["Puscilla_note"] = "洞穴入口在东南方 - 从东面的桥到达那里。";
_L["Vrax'thul"] = "弗拉克苏尔";
_L["Vrax'thul_search"] = { "弗拉克苏尔", "vrax'thul" };
_L["Vrax'thul_note"] = "";
_L["Ven'orn"] = "维农";
_L["Ven'orn_search"] = { "维农", "ven'orn" };
_L["Ven'orn_note"] = "洞穴入口在东北方，从蜘蛛区域 66, 54.1";
_L["Varga"] = "瓦加";
_L["Varga_search"] = { "瓦加", "varga" };
_L["Varga_note"] = "";
_L["Lieutenant Xakaar"] = "萨卡尔中尉";
_L["Lieutenant Xakaar_search"] = { "萨卡尔中尉", "中尉", "lieutenant xakaar" };
_L["Lieutenant Xakaar_note"] = "";
_L["Wrath-Lord Yarez"] = "愤怒领主亚雷兹";
_L["Wrath-Lord Yarez_search"] = { "愤怒领主亚雷兹", "愤怒领主", "wrath-lord yarez" };
_L["Wrath-Lord Yarez_note"] = "";
_L["Inquisitor Vethroz"] = "审判官维斯洛兹";
_L["Inquisitor Vethroz_search"] = { "审判官维斯洛兹", "inquisitor vethroz" };
_L["Inquisitor Vethroz_note"] = "";
_L["Portal to Commander Texlaz"] = "传送到指挥官泰克拉兹";
_L["Portal to Commander Texlaz_note"] = "";
_L["Commander Texlaz"] = "指挥官泰克拉兹";
_L["Commander Texlaz_search"] = { "指挥官泰克拉兹", "泰克拉兹", "commander texlaz" };
_L["Commander Texlaz_note"] = "使用偏西的传送门位于 80.2, 62.3 到达船上";
_L["Admiral Rel'var"] = "雷尔瓦将军";
_L["Admiral Rel'var_search"] = { "雷尔瓦将军", "将军", "admiral rel'var" };
_L["Admiral Rel'var_note"] = "";
_L["All-Seer Xanarian"] = "全知者萨纳里安";
_L["All-Seer Xanarian_search"] = { "全知者萨纳里安", "全知者", "all-seer xanarian" };
_L["All-Seer Xanarian_note"] = "";
_L["Worldsplitter Skuul"] = "裂世者斯库尔";
_L["Worldsplitter Skuul_search"] = { "裂世者斯库尔", "裂世者", "worldsplitter skuul" };
_L["Worldsplitter Skuul_note"] = "会在天上盘旋。偶尔也会降落。不是每次盘旋都这样。";
_L["Houndmaster Kerrax"] = "驯犬大师克拉克斯";
_L["Houndmaster Kerrax_search"] = { "驯犬大师克拉克斯", "驯犬大师", "houndmaster kerrax" };
_L["Houndmaster Kerrax_note"] = "";
_L["Void Warden Valsuran"] = "虚空守望者瓦苏";
_L["Void Warden Valsuran_search"] = { "虚空守望者瓦苏", "虚空守望者", "void warden valsuran" };
_L["Void Warden Valsuran_note"] = "";
_L["Chief Alchemist Munculus"] = "首席炼金师蒙库鲁斯";
_L["Chief Alchemist Munculus_search"] = { "首席炼金师蒙库鲁斯", "首席炼金师", "chief alchemist munculus" };
_L["Chief Alchemist Munculus_note"] = "";
_L["The Many-Faced Devourer"] = "千面吞噬者";
_L["The Many-Faced Devourer_search"] = { "千面吞噬者", "千面", "the many-faced devourer" };
_L["The Many-Faced Devourer_note"] = "可以永远召唤。但必须从周围怪身上找到“吞噬者的召唤”，然后找到3个骨头才能召唤。";
_L["Portal to Squadron Commander Vishax"] = "传送到中队指挥官维沙克斯";
_L["Portal to Squadron Commander Vishax_note"] = "第一步先从不朽虚无行者身上找到碎裂的传送门发生器。然后从艾瑞达战术顾问、魔誓侍从身上收集导电护套，弧光电路，能量电池，使用碎裂的传送门发生器把它们组合起来打开去往维沙克斯的传送门。";
_L["Squadron Commander Vishax"] = "中队指挥官维沙克斯";
_L["Squadron Commander Vishax_search"] = { "中队指挥官维沙克斯", "中队指挥官", "squadron commander vishax" };
_L["Squadron Commander Vishax_note"] = "使用传送门位于 77.2, 73.2 上船";
_L["Doomcaster Suprax"] = "末日法师苏帕克斯";
_L["Doomcaster Suprax_search"] = { "末日法师苏帕克斯", "末日法师", "doomcaster suprax" };
_L["Doomcaster Suprax_note"] = "三个符文上站人召唤他。如果失败了5分钟后刷新！";
_L["Mother Rosula"] = "主母罗苏拉";
_L["Mother Rosula_search"] = { "主母罗苏拉", "罗苏拉", "mother rosula" };
_L["Mother Rosula_note"] = "洞穴内 - 从东面的桥到达那里。收集洞里小鬼掉的100个小鬼的肉。使用它做一份黑暗料理扔进绿池子里召唤主母。";
_L["Rezira the Seer"] = "先知雷兹拉";
_L["Rezira the Seer_search"] = { "先知雷兹拉", "先知", "rezira the seer" };
_L["Rezira the Seer_note"] = "使用观察者之地共鸣器打开传送门。收集500个恶魔之眼把它交给位于 60.2, 45.4 的全视者奥利克斯换取。";
_L["Blistermaw"] = "疱喉";
_L["Blistermaw_search"] = { "疱喉", "blistermaw" };
_L["Blistermaw_note"] = "";
_L["Mistress Il'thendra"] = "妖女伊森黛拉";
_L["Mistress Il'thendra_search"] = { "妖女伊森黛拉", "伊森黛拉", "mistress il'thendra" };
_L["Mistress Il'thendra_note"] = "";
_L["Gar'zoth"] = "加尔佐斯";
_L["Gar'zoth_search"] = { "加尔佐斯", "gar'zoth" };
_L["Gar'zoth_note"] = "";

_L["One-of-Many"] = "小乌祖";
_L["One-of-Many_note"] = "";
_L["Minixis"] = "小型克西斯号";
_L["Minixis_note"] = "";
_L["Watcher"] = "凝视者";
_L["Watcher_note"] = "";
_L["Bloat"] = "小胖";
_L["Bloat_note"] = "";
_L["Earseeker"] = "啮耳者";
_L["Earseeker_note"] = "";
_L["Pilfer"] = "小贼";
_L["Pilfer_note"] = "";

_L["Orix the All-Seer"] = "全视者奥利克斯";
_L["Orix the All-Seer_note"] = "找到绿色恶魔之眼。点击它们。会失去90%血量并开始从此地图上全部恶魔怪身上收集眼球。";

_L["Forgotten Legion Supplies"] = "被遗忘的军团补给";
_L["Forgotten Legion Supplies_note"] = "岩石挡住了道路。使用光铸战争机甲跳起破坏岩石。";
_L["Ancient Legion War Cache"] = "古老的军团战争储物箱";
_L["Ancient Legion War Cache_note"] = "小心跳下到小洞穴。滑翔会很有帮助。使用圣光裁决者移除岩石。";
_L["Fel-Bound Chest"] = "邪能缠绕的宝箱";
_L["Fel-Bound Chest_note"] = "开始点在东南方一点位于 53.7, 30.9。跳上岩石到达洞穴。岩石挡住了洞穴。使用圣光裁决者移除岩石。";
_L["Legion Treasure Hoard"] = "军团财宝";
_L["Legion Treasure Hoard_note"] = "邪能瀑布后方。捡取它就行。";
_L["Timeworn Fel Chest"] = "历时久远的邪能宝箱";
_L["Timeworn Fel Chest_note"] = "起点位于全知者萨纳里安。从左侧穿过他的建筑物。沿着几块岩石跳下到达被绿色软泥围绕的宝箱。";
_L["Missing Augari Chest"] = "丢失的奥古雷宝箱";
_L["Missing Augari Chest_note"] = "宝箱在下方绿软区域。使用奥术回响遮罩后打开宝箱。";

-- 48382
_L["48382_67546980_note"] = "建筑物内";
_L["48382_67466226_note"] = "";
_L["48382_71326946_note"] = "在哈多克斯边上";
_L["48382_58066806_note"] = "";
_L["48382_68026624_note"] = "军团建筑物内";
_L["48382_64506868_note"] = "外面";
_L["48382_62666823_note"] = "建筑物内";
_L["48382_60096945_note"] = "外面，建筑物后方";
_L["48382_62146938_note"] = "";
_L["48382_69496785_note"] = "";
_L["48382_58806467_note"] = "建筑物内";
_L["48382_57796495_note"] = "";
-- 48383
_L["48383_56903570_note"] = "";
_L["48383_57633179_note"] = "";
_L["48383_52182918_note"] = "";
_L["48383_58174021_note"] = "";
_L["48383_51863409_note"] = "";
_L["48383_55133930_note"] = "";
_L["48383_58413097_note"] = "建筑物内，第一层";
_L["48383_53753556_note"] = "";
_L["48383_51703529_note"] = "悬崖的高处";
_L["48383_59853583_note"] = "";
_L["48383_58273570_note"] = "建筑物内，入口在妖女伊森黛拉平台";
-- 48384
_L["48384_60872900_note"] = "";
_L["48384_61332054_note"] = "首席炼金师蒙库鲁斯建筑物内";
_L["48384_59081942_note"] = "建筑物内";
_L["48384_64152305_note"] = "驯犬大师克拉克斯洞穴内";
_L["48384_66621709_note"] = "小鬼洞穴内，主母罗苏拉旁边";
_L["48384_63682571_note"] = "驯犬大师克拉克斯洞穴前方";
_L["48384_61862236_note"] = "外面，首席炼金师蒙库鲁斯旁边";
_L["48384_64132738_note"] = "";
_L["48384_63522090_note"] = "驯犬大师克拉克斯洞穴后面";
-- 48385
_L["48385_50605720_note"] = "";
_L["48385_55544743_note"] = "";
_L["48385_57135124_note"] = "";
_L["48385_55915425_note"] = "";
_L["48385_48195451_note"] = "";
_L["48385_57825901_note"] = "";
-- 48387
_L["48387_69403965_note"] = "";
_L["48387_66643654_note"] = "";
_L["48387_68983342_note"] = "";
_L["48387_65522831_note"] = "桥下";
_L["48387_73404669_note"] = "跳过软泥";
_L["48387_67954006_note"] = "";
_L["48387_63603642_note"] = "";
_L["48387_72404207_note"] = "";
-- 48388
_L["48388_51502610_note"] = "";
_L["48388_59261743_note"] = "";
_L["48388_55921387_note"] = "";
_L["48388_55841722_note"] = "";
_L["48388_55622042_note"] = "虚空守望者瓦苏拉边上，跳上岩石斜坡";
_L["48388_59661398_note"] = "";
_L["48388_54102803_note"] = "艾瓦平台旁边";
_L["48388_55922675_note"] = "";
-- 48389
_L["48389_64305040_note"] = "瓦加洞穴内";
_L["48389_60254351_note"] = "";
_L["48389_65514081_note"] = "";
_L["48389_60304675_note"] = "";
_L["48389_65345192_note"] = "瓦加后方的洞穴内";
_L["48389_64114242_note"] = "岩石下";
_L["48389_58734323_note"] = "软泥之中的小空地上";
_L["48389_62955007_note"] = "在绿软边上";
_L["48389_64254720_note"] = "";
-- 48390
_L["48390_81306860_note"] = "在船上";
_L["48390_80406152_note"] = "";
_L["48390_82566503_note"] = "在船上";
_L["48390_73316858_note"] = "雷尔瓦将军上层边上";
_L["48390_77127529_note"] = "维沙克斯传送门旁边";
_L["48390_72527293_note"] = "雷尔瓦将军后方";
_L["48390_77255876_note"] = "斜坡";
_L["48390_72215680_note"] = "建筑物内";
_L["48390_73277299_note"] = "雷尔瓦将军后方";
_L["48390_77975620_note"] = "下斜坡到更远的悬崖上";
_L["48390_77246412_note"] = "返回时小心，别跳崖！";
_L["48390_76595659_note"] = "全知者萨纳里安建筑物内";
-- 48391
_L["48391_64135867_note"] = "在维农的巢穴内";
_L["48391_67404790_note"] = "蜘蛛区域，在北方出口旁的小洞穴内";
_L["48391_63615622_note"] = "在维农的巢穴内";
_L["48391_65005049_note"] = "蜘蛛区域外";
_L["48391_63035762_note"] = "在维农的巢穴内";
_L["48391_65185507_note"] = "到蜘蛛区域的上入口";
_L["48391_68095075_note"] = "蜘蛛区域小洞穴内";
_L["48391_69815522_note"] = "蜘蛛区域外";
_L["48391_71205441_note"] = "蜘蛛区域外";
_L["48391_66544668_note"] = "出了蜘蛛区域北方有绿软泥区域。跳上岩石。";
_L["48391_65164951_note"] = "蜘蛛区域小洞穴内";

-- Krokuun
_L["Khazaduum"] = "卡扎杜姆";
_L["Khazaduum_search"] = { "卡扎杜姆", "khazaduum" };
_L["Khazaduum_note"] = "入口在东南位于 50.3, 17.3";
_L["Commander Sathrenael"] = "指挥官萨森纳尔";
_L["Commander Sathrenael_search"] = { "指挥官萨森纳尔", "萨森纳尔", "commander sathrenael" };
_L["Commander Sathrenael_note"] = "";
_L["Commander Endaxis"] = "指挥官安达西斯";
_L["Commander Endaxis_search"] = { "指挥官安达西斯", "安达西斯", "commander endaxis" };
_L["Commander Endaxis_note"] = "";
_L["Sister Subversia"] = "苏薇西娅姐妹";
_L["Sister Subversia_search"] = { "苏薇西娅姐妹", "姐妹", "sister subversia" };
_L["Sister Subversia_note"] = "";
_L["Siegemaster Voraan"] = "攻城大师沃兰";
_L["Siegemaster Voraan_search"] = { "攻城大师沃兰", "攻城大师", "siegemaster voraan" };
_L["Siegemaster Voraan_note"] = "";
_L["Talestra the Vile"] = "恶毒者泰勒斯塔";
_L["Talestra the Vile_search"] = { "恶毒者泰勒斯塔", "恶毒者", "talestra the vile" };
_L["Talestra the Vile_note"] = "";
_L["Commander Vecaya"] = "指挥官维卡娅";
_L["Commander Vecaya_search"] = { "指挥官维卡娅", "维卡娅", "commander vecaya" };
_L["Commander Vecaya_note"] = "路径起始点在东，位于 42, 57.1";
_L["Vagath the Betrayed"] = "背弃者瓦加斯";
_L["Vagath the Betrayed_search"] = { "背弃者瓦加斯", "背弃者", "vagath the betrayed" };
_L["Vagath the Betrayed_note"] = "";
_L["Tereck the Selector"] = "分选者泰瑞克";
_L["Tereck the Selector_search"] = { "分选者泰瑞克", "分选者", "tereck the selector" };
_L["Tereck the Selector_note"] = "";
_L["Tar Spitter"] = "焦油喷吐者";
_L["Tar Spitter_search"] = { "焦油喷吐者", "焦油", "tar spitter" };
_L["Tar Spitter_note"] = "";
_L["Imp Mother Laglath"] = "鬼母拉格拉丝";
_L["Imp Mother Laglath_search"] = { "鬼母拉格拉丝", "拉格拉丝", "imp mother laglath" };
_L["Imp Mother Laglath_note"] = "";
_L["Naroua"] = "纳罗瓦";
_L["Naroua_search"] = { "纳罗瓦", "naroua" };
_L["Naroua_note"] = "";

_L["Baneglow"] = "梦魇之焰";
_L["Baneglow_note"] = "";
_L["Foulclaw"] = "污染之爪";
_L["Foulclaw_note"] = "";
_L["Ruinhoof"] = "毁灭之蹄";
_L["Ruinhoof_note"] = "";
_L["Deathscreech"] = "死亡之啸";
_L["Deathscreech_note"] = "";
_L["Gnasher"] = "小牙";
_L["Gnasher_note"] = "";
_L["Retch"] = "小脏";
_L["Retch_note"] = "";

-- Shoot First, Loot Later
_L["Krokul Emergency Cache"] = "克罗库紧急储物箱";
_L["Krokul Emergency Cache_note"] = "洞穴在悬崖上。岩石挡住了道路。使用光铸战争机甲跳起破坏岩石。";
_L["Legion Tower Chest"] = "军团塔楼宝箱";
_L["Legion Tower Chest_note"] = "在通往纳罗瓦的路上有被巨石挡住的宝箱。使用圣光裁决者移除岩石。";
_L["Lost Krokul Chest"] = "丢失的克罗库宝箱";
_L["Lost Krokul Chest_note"] = "道路延伸到小洞穴。使用圣光裁决者移除岩石。";
_L["Long-Lost Augari Treasure"] = "失落已久的奥古雷宝藏";
_L["Long-Lost Augari Treasure_note"] = "使用奥术回响遮罩后打开宝箱。";
_L["Precious Augari Keepsakes"] = "珍贵的奥古雷信物";
_L["Precious Augari Keepsakes_note"] = "使用奥术回响遮罩后打开宝箱。";

-- 47752
_L["47752_55555863_note"] = "跳上岩石，起点偏西";
_L["47752_52185431_note"] = "位于第一次看到奥蕾莉亚的上方";
_L["47752_50405122_note"] = "位于第一次看到奥蕾莉亚的上方";
_L["47752_53265096_note"] = "位于第一次看到奥蕾莉亚的上方。在绿色软泥的另一边。邪能很疼！";
_L["47752_57005472_note"] = "岩层下方，窄小地面上";
_L["47752_59695196_note"] = "泽斯塔尔旁边，岩石后方。";
_L["47752_51425958_note"] = "";
_L["47752_55525237_note"] = "区域下层。需要跳过绿软。烦人的宝箱，从泽斯塔尔开始。";
_L["47752_58375051_note"] = "";
-- 47753
_L["47753_53167308_note"] = "";
_L["47753_55228114_note"] = "";
_L["47753_59267341_note"] = "";
_L["47753_56118037_note"] = "恶毒者泰勒斯塔建筑物外";
_L["47753_58597958_note"] = "恶魔尖塔后方";
_L["47753_58197157_note"] = "";
_L["47753_52737591_note"] = "岩石后方";
_L["47753_58048036_note"] = "";
_L["47753_60297610_note"] = "";
_L["47753_56827212_note"] = "";
-- 47997
_L["47997_45876777_note"] = "岩石下，桥旁边";
_L["47997_45797753_note"] = "";
_L["47997_43858139_note"] = "起点位于 49.1, 69.3。沿着向南方的山脊到达宝箱。";
_L["47997_43816689_note"] = "岩石下。桥旁边跳下。";
_L["47997_40687531_note"] = "";
_L["47997_46996831_note"] = "在龙头骨上";
_L["47997_41438003_note"] = "爬上岩石到达被摧毁的军团战舰";
_L["47997_41548379_note"] = "";
_L["47997_46458665_note"] = "跳过岩石到达宝箱。";
_L["47997_40357414_note"] = "";
_L["47997_44198653_note"] = "";
_L["47997_46787984_note"] = "";
_L["47997_42737546_note"] = "";
-- 47999
_L["47999_62592581_note"] = "";
_L["47999_59763951_note"] = "";
_L["47999_59071884_note"] = "上方，岩石后方";
_L["47999_61643520_note"] = "";
_L["47999_61463580_note"] = "建筑物内";
_L["47999_59603052_note"] = "桥面上";
_L["47999_60891852_note"] = "背弃者瓦加斯后方小屋内";
_L["47999_49063350_note"] = "";
_L["47999_65992286_note"] = "";
_L["47999_64632319_note"] = "建筑物内";
_L["47999_51533583_note"] = "建筑物外，越过小软泥湖";
_L["47999_60422354_note"] = "";
_L["47999_62763812_note"] = "建筑物内";
_L["47999_60492781_note"] = "";
_L["47999_46768337_note"] = "";
_L["47999_59433273_note"] = "悬崖上";
_L["47999_58442866_note"] = "建筑物内";
_L["47999_48613092_note"] = "";
_L["47999_57642617_note"] = "悬崖上";
-- 48000
_L["48000_70907370_note"] = "";
_L["48000_74136790_note"] = "";
_L["48000_75166435_note"] = "洞穴尽头";
_L["48000_69605772_note"] = "";
_L["48000_69787836_note"] = "跳上斜坡到达";
_L["48000_68566054_note"] = "分选者泰瑞克洞穴前方";
_L["48000_72896482_note"] = "";
_L["48000_71827536_note"] = "";
_L["48000_73577146_note"] = "";
_L["48000_71846166_note"] = "爬上斜状柱子";
_L["48000_67886231_note"] = "柱子后方";
_L["48000_74996922_note"] = "";
_L["48000_62946824_note"] = "上方洞穴内。爬上东面岩石到达上方洞穴。";
_L["48000_69386278_note"] = "";
_L["48000_67656999_note"] = "沿斜坡和倾斜的柱子到达宝箱。";
_L["48000_69218397_note"] = "";
-- 48336
_L["48336_33575511_note"] = "泽尼达尔内上层，外面";
_L["48336_32047441_note"] = "";
_L["48336_27196668_note"] = "";
_L["48336_31936750_note"] = "";
_L["48336_35415637_note"] = "地面，在去往泽尼达尔入口下方的前方";
_L["48336_29645761_note"] = "洞穴内";
_L["48336_40526067_note"] = "黄色小屋内";
_L["48336_36205543_note"] = "泽尼达尔内，上层";
_L["48336_25996814_note"] = "";
_L["48336_37176401_note"] = "残骸下方";
_L["48336_28247134_note"] = "";
_L["48336_30276403_note"] = "位于逃生平台";
_L["48336_34566305_note"] = "";
_L["48336_36605881_note"] = "泽尼达尔上层，外面";
-- 48339
_L["48339_68533891_note"] = "";
_L["48339_63054240_note"] = "";
_L["48339_64964156_note"] = "";
_L["48339_73393438_note"] = "";
_L["48339_72213234_note"] = "巨大头骨后方";
_L["48339_65983499_note"] = "";
_L["48339_64934217_note"] = "在树干内";
_L["48339_67713454_note"] = "";
_L["48339_72493605_note"] = "";
_L["48339_44864342_note"] = "";
_L["48339_46094082_note"] = "";
_L["48339_70503063_note"] = "";
_L["48339_61876413_note"] = "";

-- Mac'Aree
_L["Shadowcaster Voruun"] = "暗影法师沃伦";
_L["Shadowcaster Voruun_search"] = { "暗影法师沃伦", "暗影法师", "shadowcaster voruun" };
_L["Shadowcaster Voruun_note"] = "";
_L["Soultwisted Monstrosity"] = "灵魂扭曲的畸体";
_L["Soultwisted Monstrosity_search"] = { "灵魂扭曲的畸体", "畸体", "soultwisted monstrosity" };
_L["Soultwisted Monstrosity_note"] = "";
_L["Wrangler Kravos"] = "牧羊人卡沃斯";
_L["Wrangler Kravos_search"] = { "牧羊人卡沃斯", "牧羊人", "wrangler kravos" };
_L["Wrangler Kravos_note"] = "";
_L["Kaara the Pale"] = "苍白的卡拉";
_L["Kaara the Pale_search"] = { "苍白的卡拉", "苍白", "kaara the pale" };
_L["Kaara the Pale_note"] = "";
_L["Feasel the Muffin Thief"] = "松饼大盗费舍尔";
_L["Feasel the Muffin Thief_search"] = { "松饼大盗费舍尔", "松饼大盗", "feasel the muffin thief" };
_L["Feasel the Muffin Thief_note"] = "打断钻地";
_L["Vigilant Thanos"] = "警卫泰诺斯";
_L["Vigilant Thanos_search"] = { "警卫泰诺斯", "泰诺斯", "vigilant thanos" };
_L["Vigilant Thanos_note"] = "";
_L["Vigilant Kuro"] = "警卫库洛";
_L["Vigilant Kuro_search"] = { "警卫库洛", "库洛", "vigilant kuro" };
_L["Vigilant Kuro_note"] = "";
_L["Venomtail Skyfin"] = "毒尾天鳍鳐";
_L["Venomtail Skyfin_search"] = { "毒尾天鳍鳐", "毒尾", "venomtail skyfin" };
_L["Venomtail Skyfin_note"] = "";
_L["Turek the Lucid"] = "清醒者图瑞克";
_L["Turek the Lucid_search"] = { "清醒者图瑞克", "清醒者", "turek the lucid" };
_L["Turek the Lucid_note"] = "下楼进入建筑物";
_L["Captain Faruq"] = "法鲁克队长";
_L["Captain Faruq_search"] = { "法鲁克队长", "法鲁克", "captain faruq" };
_L["Captain Faruq_note"] = "";
_L["Umbraliss"] = "乌伯拉利斯";
_L["Umbraliss_search"] = { "乌伯拉利斯", "umbraliss" };
_L["Umbraliss_note"] = "";
_L["Sorolis the Ill-Fated"] = "厄运者索洛里斯";
_L["Sorolis the Ill-Fated_search"] = { "厄运者索洛里斯", "厄运者", "sorolis the ill-fated" };
_L["Sorolis the Ill-Fated_note"] = "";
_L["Herald of Chaos"] = "混沌先驱";
_L["Herald of Chaos_search"] = { "混沌先驱", "herald of chaos" };
_L["Herald of Chaos_note"] = "位于第二层。";
_L["Sabuul"] = "沙布尔";
_L["Sabuul_search"] = { "沙布尔", "sabuul" };
_L["Sabuul_note"] = "";
_L["Jed'hin Champion Vorusk"] = "杰德尼勇士沃鲁斯克";
_L["Jed'hin Champion Vorusk_search"] = { "杰德尼勇士沃鲁斯克", "杰德尼勇士", "jed'hin champion vorusk" };
_L["Jed'hin Champion Vorusk_note"] = "";
_L["Overseer Y'Beda"] = "监视者伊比达";
_L["Overseer Y'Beda_search"] = { "监视者伊比达", "伊比达", "overseer y'beda" };
_L["Overseer Y'Beda_note"] = "";
_L["Overseer Y'Sorna"] = "监视者伊索纳";
_L["Overseer Y'Sorna_search"] = { "监视者伊索纳", "伊索纳", "overseer y'sorna" };
_L["Overseer Y'Sorna_note"] = "";
_L["Overseer Y'Morna"] = "监视者伊莫拉";
_L["Overseer Y'Morna_search"] = { "监视者伊莫拉", "伊莫拉", "overseer y'morna" };
_L["Overseer Y'Morna_note"] = "";
_L["Instructor Tarahna"] = "导师塔拉娜";
_L["Instructor Tarahna_search"] = { "导师塔拉娜", "塔拉娜", "instructor tarahna" };
_L["Instructor Tarahna_note"] = "";
_L["Zul'tan the Numerous"] = "万千之主祖尔坦";
_L["Zul'tan the Numerous_search"] = { "万千之主祖尔坦", "万千之主", "zul'tan the numerous" };
_L["Zul'tan the Numerous_note"] = "建筑物内";
_L["Commander Xethgar"] = "指挥官泽斯加尔";
_L["Commander Xethgar_search"] = { "指挥官泽斯加尔", "泽斯加尔", "commander xethgar" };
_L["Commander Xethgar_note"] = "";
_L["Skreeg the Devourer"] = "吞噬者斯克里格";
_L["Skreeg the Devourer_search"] = { "吞噬者斯克里格", "斯克里格", "skreeg the devourer" };
_L["Skreeg the Devourer_note"] = "";
_L["Baruut the Bloodthirsty"] = "嗜血的巴鲁特";
_L["Baruut the Bloodthirsty_search"] = { "嗜血的巴鲁特", "巴鲁特", "baruut the bloodthirsty" };
_L["Baruut the Bloodthirsty_note"] = "";
_L["Ataxon"] = "阿塔克松";
_L["Ataxon_search"] = { "阿塔克松", "ataxon" };
_L["Ataxon_note"] = "";
_L["Slithon the Last"] = "最后的希里索恩";
_L["Slithon the Last_search"] = { "最后的希里索恩", "希里索恩", "slithon the last" };
_L["Slithon the Last_note"] = "";

_L["Gloamwing"] = "烁光之翼";
_L["Gloamwing_note"] = "";
_L["Bucky"] = "巴基";
_L["Bucky_note"] = "";
_L["Mar'cuus"] = "马库斯";
_L["Mar'cuus_note"] = "";
_L["Snozz"] = "鼠鼠";
_L["Snozz_note"] = "";
_L["Corrupted Blood of Argus"] = "阿古斯的腐化之血";
_L["Corrupted Blood of Argus_note"] = "";
_L["Shadeflicker"] = "曳影兽";
_L["Shadeflicker_note"] = "";

_L["Nabiru"] = "纳毕鲁";
_L["Nabiru_note"] = "他在洞穴里。上缴900资源换取职业大厅追随者。";

-- Shoot First, Loot Later
_L["Eredar Treasure Cache"] = "艾瑞达宝箱";
_L["Eredar Treasure Cache_note"] = "在小洞穴内。使用光铸战争机甲跳上并移除岩石。";
_L["Chest of Ill-Gotten Gains"] = "来路不明的箱子";
_L["Chest of Ill-Gotten Gains_note"] = "使用圣光裁决者移除岩石。";
_L["Student's Surprising Surplus"] = "学徒的惊喜留念";
_L["Student's Surprising Surplus_note"] = "宝箱在山洞内。入口在 62.2, 72.2。使用圣光裁决者移除岩石。";
_L["Void-Tinged Chest"] = "虚空回荡的宝箱";
_L["Void-Tinged Chest_note"] = "在地下区域。使用光铸战争机甲跳上并移除岩石。";
_L["Augari Secret Stash"] = "奥古雷隐秘存储箱";
_L["Augari Secret Stash_note"] = "到 68.0, 56.9。到这里可以看到宝箱。上坐骑跳跃过去。立刻使用滑翔装备到宝箱会更安全些。";
_L["Desperate Eredar's Cache"] = "绝望的艾瑞达的储物箱";
_L["Desperate Eredar's Cache_note"] = "起点在 57.1, 74.3，接着跳到塔上后到后方。";
_L["Shattered House Chest"] = "房屋废墟宝箱";
_L["Shattered House Chest_note"] = "到 to 31.2, 44.9，这里东南一点。跳下深渊并使用滑翔装备到达宝箱。";
_L["Doomseeker's Treasure"] = "末日追寻者的宝藏";
_L["Doomseeker's Treasure_note"] = "宝箱在地下。东面是一个流水瀑布深洞。跳下深洞运气好能到达。可以使用坐骑跳跃，但是滑翔设备会帮你更多到达有宝箱的小屋。";
_L["Augari-Runed Chest"] = "奥古雷符文宝箱";
_L["Augari-Runed Chest_note"] = "宝箱在树下。使用奥术回响遮罩后打开宝箱。";
_L["Secret Augari Chest"] = "隐秘奥古雷宝箱";
_L["Secret Augari Chest_note"] = "小屋内。使用奥术回响遮罩后打开宝箱。";
_L["Augari Goods"] = "奥古雷货物";
_L["Augari Goods_note"] = "宝箱在小屋内。使用奥术回响遮罩后打开宝箱。";
-- Ancient Eredar Cache
-- 48346
_L["48346_55167766_note"] = "";
_L["48346_59386372_note"] = "透明的红色帐篷内";
_L["48346_57486159_note"] = "牧羊人卡沃斯旁边的建筑物内";
_L["48346_50836729_note"] = "";
_L["48346_52868241_note"] = "";
_L["48346_47186234_note"] = "";
_L["48346_50107580_note"] = "";
_L["48346_53328001_note"] = "地下室内";
_L["48346_55297347_note"] = "";
_L["48346_52696161_note"] = "";
_L["48346_54806710_note"] = "";
_L["48346_51677163_note"] = "";
_L["48346_57397517_note"] = "";
_L["48346_61047074_note"] = "树下";
-- 48350
_L["48350_59622088_note"] = "建筑物内楼梯下";
_L["48350_60493338_note"] = "建筑物内";
_L["48350_53912335_note"] = "建筑物内";
_L["48350_55063508_note"] = "";
_L["48350_62202636_note"] = "阳台上。进入建筑物后上楼梯右边。";
_L["48350_53332740_note"] = "树下";
_L["48350_58574078_note"] = "";
_L["48350_63262000_note"] = "建筑物内";
_L["48350_54952484_note"] = "";
_L["48350_63332255_note"] = "红色小屋内";
-- 48351
_L["48351_43637134_note"] = "";
_L["48351_34205929_note"] = "在第二层，混沌先驱旁边。";
_L["48351_43955630_note"] = "树下";
_L["48351_46917346_note"] = "藏在树下";
_L["48351_36296646_note"] = "";
_L["48351_42645361_note"] = "洞穴内。入口在西南。";
_L["48351_38126342_note"] = "清醒者图瑞克地下室内";
_L["48351_42395752_note"] = "建筑物内";
_L["48351_39175934_note"] = "建筑物废墟内";
_L["48351_43555993_note"] = "纳毕鲁洞穴内";
_L["48351_35535717_note"] = "在第二层";
_L["48351_43666847_note"] = "建筑物废墟内";
_L["48351_38386704_note"] = "";
_L["48351_35635604_note"] = "位于第二层";
_L["48351_33795558_note"] = "";
-- 48357
_L["48357_49412387_note"] = "";
_L["48357_47672180_note"] = "";
_L["48357_48482115_note"] = "";
_L["48357_57881053_note"] = "";
_L["48357_52871676_note"] = "楼梯上";
_L["48357_47841956_note"] = "";
_L["48357_51802871_note"] = "在北边楼梯上方区域";
_L["48357_49912946_note"] = "";
_L["48357_54951750_note"] = "";
_L["48357_46381509_note"] = "";
_L["48357_50021442_note"] = "";
_L["48357_52631644_note"] = "";
_L["48357_45981325_note"] = "";
_L["48357_44571860_note"] = "";
_L["48357_53491281_note"] = "";
_L["48357_45241327_note"] = "";
_L["48357_48251289_note"] = "底层，吞噬者斯克里格旁边";
_L["48357_44952483_note"] = "";
-- 48371
_L["48371_48604971_note"] = "";
_L["48371_49865494_note"] = "";
_L["48371_47023655_note"] = "楼梯上";
_L["48371_49623585_note"] = "楼梯上";
_L["48371_51094790_note"] = "树下";
_L["48371_35535718_note"] = "第二层，混沌先驱旁边";
_L["48371_25383016_note"] = "";
_L["48371_53594211_note"] = "";
_L["48371_59405863_note"] = "";
_L["48371_19694227_note"] = "建筑物内";
_L["48371_24763858_note"] = "建筑物废墟内";
_L["48371_50575594_note"] = "";
_L["48371_28913361_note"] = "";
_L["48371_32644686_note"] = "";
-- 48362
_L["48362_66682786_note"] = "建筑物内，万千之主祖尔坦旁边";
_L["48362_62134077_note"] = "建筑物内";
_L["48362_67254608_note"] = "建筑物内";
_L["48362_68355322_note"] = "建筑物内";
_L["48362_65966017_note"] = "";
_L["48362_62053268_note"] = "地面上层";
_L["48362_60964354_note"] = "建筑物内";
_L["48362_64445956_note"] = "建筑物内";
_L["48362_65354194_note"] = "";
_L["48362_63924532_note"] = "";
_L["48362_67893170_note"] = "";
_L["48362_65974679_note"] = "建筑物内";
_L["48362_68404122_note"] = "";
_L["48362_61924258_note"] = "建筑物内";
_L["48362_67235673_note"] = "建筑物内";
_L["48362_70243379_note"] = "";
_L["48362_69304993_note"] = "建筑物内，位于中层";
_L["48362_61395555_note"] = "建筑物内";
-- Void-Seeped Cache / Treasure Chest
-- 49264
_L["49264_38143985_note"] = "";
_L["49264_37613608_note"] = "";
_L["49264_37812344_note"] = "";
_L["49264_33972078_note"] = "";
_L["49264_33312952_note"] = "";
_L["49264_37102005_note"] = "";
_L["49264_33592361_note"] = "藏在树下";
_L["49264_31582553_note"] = "";
_L["49264_32332131_note"] = "藏在角落里";
_L["49264_35293848_note"] = "";
-- 48361
_L["48361_37664221_note"] = "洞里柱子后方";
_L["48361_25824471_note"] = "";
_L["48361_20674033_note"] = "";
_L["48361_29503999_note"] = "";
_L["48361_29455043_note"] = "树下";
_L["48361_18794171_note"] = "外面，建筑物后方";
_L["48361_25293498_note"] = "";
_L["48361_35283586_note"] = "乌伯拉利斯后方";
_L["48361_24654126_note"] = "";
_L["48361_37754868_note"] = "下方的洞穴区域";
_L["48361_39174733_note"] = "下方的洞穴区域";
_L["48361_28784425_note"] = "";
_L["48361_32583679_note"] = "";
_L["48361_19804660_note"] = "";

--
--	KEEP THESE ENGLISH FOR THE GROUP BROWSER IN EU/US!! CHINA & CO ADJUST
--	SEARCH ARRAY AS BEFORE, MUST HAVE MINIMUM 2 ELEMENTS
--

_L["Invasion Point: Val"] = "侵入点：瓦尔";
_L["Invasion Point: Aurinor"] = "侵入点：奥雷诺";
_L["Invasion Point: Sangua"] = "侵入点：萨古亚";
_L["Invasion Point: Naigtal"] = "侵入点：奈格塔尔";
_L["Invasion Point: Bonich"] = "侵入点：博尼克";
_L["Invasion Point: Cen'gar"] = "侵入点：森加";
_L["Greater Invasion Point: Mistress Alluradel"] = "大型侵入点：妖女奥露拉黛儿";
_L["Greater Invasion Point: Matron Folnuna"] = "大型侵入点：主母芙努娜";
_L["Greater Invasion Point: Sotanathor"] = "大型侵入点：索塔纳索尔";
_L["Greater Invasion Point: Inquisitor Meto"] = "大型侵入点：审判官梅托";
_L["Greater Invasion Point: Pit Lord Vilemus"] = "大型侵入点：深渊领主维尔姆斯";
_L["Greater Invasion Point: Occularus"] = "大型侵入点：奥库拉鲁斯";

_L["invasion_val_search"] = { "侵入点：瓦尔", "瓦尔" };
_L["invasion_aurinor_search"] = { "侵入点：奥雷诺", "奥雷诺" };
_L["invasion_sangua_search"] = { "侵入点：萨古亚", "萨古亚" };
_L["invasion_naigtal_search"] = { "侵入点：奈格塔尔", "奈格塔尔" };
_L["invasion_bonich_search"] = { "侵入点：博尼克", "博尼克" };
_L["invasion_cengar_search"] = { "侵入点：森加", "森加" };
_L["invasion_alluradel_search"] = { "大型侵入点：妖女奥露拉黛儿", "妖女奥露拉黛儿", "mistress alluradel" };
_L["invasion_folnuna_search"] = { "大型侵入点：主母芙努娜", "主母芙努娜", "matron folnuna" };
_L["invasion_sotanathor_search"] = { "大型侵入点：索塔纳索尔", "索塔纳索尔", "sotanathor" };
_L["invasion_meto_search"] = { "大型侵入点：审判官梅托", "审判官梅托", "meto" };
_L["invasion_vilemus_search"] = { "大型侵入点：深渊领主维尔姆斯", "深渊领主维尔姆斯", "pit lord vilemus" };
_L["invasion_occularus_search"] = { "大型侵入点：奥库拉鲁斯", "奥库拉鲁斯", "occularus"  };

_L["Dreadblade Annihilator"] = "恐刃歼灭者";
_L["bsrare_dreadbladeannihilator_search"] = { "恐刃歼灭者", "dreadblade annihilator" };
_L["Salethan the Broodwalker"] = "巢行者萨尔杉";
_L["bsrare_salethan_search"] = { "巢行者萨尔杉", "salethan the broodwalker", };
_L["Corrupted Bonebreaker"] = "腐化的碎骨者";
_L["bsrare_corruptedbonebreaker_search"] = { "腐化的碎骨者", "corrupted bonebreaker" };
_L["Flllurlokkr"] = "弗鲁洛克";
_L["bsrare_flllurlokkr_search"] = { "弗鲁洛克", "flllurlokkr" };
_L["Grossir"] = "格罗希尔";
_L["bsrare_grossir_search"] = { "格罗希尔", "grossir" };
_L["Eye of Gurgh"] = "格尔之眼";
_L["bsrare_eyeofgurgh_search"] = { "格尔之眼", "eye of gurgh" };
_L["Somber Dawn"] = "阴郁黎明";
_L["bsrare_somberdawn_search"] = { "阴郁黎明", "somber dawn" };
_L["Felcaller Zelthae"] = "邪能召唤者泽尔萨";
_L["bsrare_zelthae_search"] = { "邪能召唤者泽尔萨", "felcaller zelthae" };
_L["Duke Sithizi"] = "西塞兹公爵";
_L["bsrare_dukesithizi_search"] = { "西塞兹公爵", "duke sithizi" };
_L["Lord Hel'Nurath"] = "赫尔努拉斯";
_L["bsrare_helnurath_search"] = { "赫尔努拉斯", "lord hel'nurath" };
_L["Imp Mother Bruva"] = "鬼母布鲁瓦";
_L["bsrare_bruva_search"] = { "鬼母布鲁瓦", "imp mother bruva" };
_L["Potionmaster Gloop"] = "药剂大师格洛普";
_L["bsrare_gloop_search"] = { "药剂大师格洛普", "potionmaster gloop" };
_L["Dreadeye"] = "恐眼";
_L["bsrare_dreadeye_search"] = { "恐眼", "dreadeye" };
_L["Malorus the Soulkeeper"] = "囚魂者玛洛鲁斯";
_L["bsrare_malorus_search"] = { "囚魂者玛洛鲁斯", "malorus the soulkeeper" };
_L["Brother Badatin"] = "巴达丁大师";
_L["bsrare_badatin_search"] = { "巴达丁大师", "brother badatin" };
_L["Felbringer Xar'thok"] = "邪能使者萨尔索克";
_L["bsrare_xarthok_search"] = { "邪能使者萨尔索克", "felbringer xar'thok" };
_L["Malgrazoth"] = "玛尔戈拉佐斯";
_L["bsrare_malgrazoth_search"] = { "玛尔戈拉佐斯", "malgrazoth" };
_L["Emberfire"] = "烬火";
_L["bsrare_emberfire_search"] = { "烬火", "emberfire" };
_L["Xorogun the Flamecarver"] = "刻焰者克索诺古恩";
_L["bsrare_xorogun_search"] = { "刻焰者克索诺古恩", "xorogun the flamecarver" };
_L["Lady Eldrathe"] = "艾黛拉丝夫人";
_L["bsrare_eldrathe_search"] = { "艾黛拉丝夫人", "lady eldrathe" };
_L["Aqueux"] = "阿奎克斯";
_L["bsrare_aqueux_search"] = { "阿奎克斯", "aqueux" };
_L["Doombringer Zar'thoz"] = "末日使者扎索斯";
_L["bsrare_zarthoz_search"] = { "末日使者扎索斯", "doombringer zar'thoz" };
_L["Felmaw Emberfiend"] = "魔喉烬魔";
_L["bsrare_felmawemberfiend_search"] = { "魔喉烬魔", "felmaw emberfiend" };
_L["Inquisitor Chillbane"] = "审判官奇尔班";
_L["bsrare_chillbane_search"] = { "审判官奇尔班", "inquisitor chillbane" };
_L["Brood Mother Nix"] = "巢母妮克丝";
_L["bsrare_broodmothernix_search"] = { "巢母妮克丝", "brood mother nix" };

_L["Lord Kazzak"] = "末日领主卡扎克";
_L["kazzak_search"] = { "末日领主卡扎克", "lord kazzak" };
_L["Azuregos"] = "艾索雷葛斯";
_L["azuregos_search"] = { "艾索雷葛斯", "azuregos" };
_L["Dragons of Nightmare"] = "梦魇之龙";
_L["dragonsofnightmare_search"] = { "梦魇之龙", "伊森德雷", "莱索恩", "艾莫莉丝", "泰拉尔", "梦魇" };
_L["Ysondre"] = "伊森德雷";
_L["ysondre_search"] = { "伊森德雷", "ysondre" };
_L["Lethon"] = "莱索恩";
_L["lethon_search"] = { "莱索恩", "lethon" };
_L["Emeriss"] = "艾莫莉丝";
_L["emeriss_search"] = { "艾莫莉丝", "emeriss" };
_L["Taerar"] = "泰拉尔";
_L["taerar_search"] = { "泰拉尔", "taerar" };

--
--
-- INTERFACE
--
--

_L["Argus"] = "阿古斯";
_L["Antoran Wastes"] = "安托兰废土";
_L["Krokuun"] = "克罗库恩";
_L["Mac'Aree"] = "玛凯雷";

_L["Shield"] = "盾牌";
_L["Cloth"] = "布甲";
_L["Leather"] = "皮甲";
_L["Mail"] = "锁甲";
_L["Plate"] = "板甲";
_L["1h Mace"] = "单手锤";
_L["1h Sword"] = "单手剑";
_L["1h Axe"] = "单手斧";
_L["2h Mace"] = "双手锤";
_L["2h Axe"] = "双手斧";
_L["2h Sword"] = "双手剑";
_L["Dagger"] = "匕首";
_L["Staff"] = "法杖";
_L["Fist"] = "拳套";
_L["Polearm"] = "长柄武器";
_L["Bow"] = "弓";
_L["Gun"] = "枪";
_L["Wand"] = "魔杖";
_L["Crossbow"] = "弩";
_L["Ring"] = "戒指";
_L["Amulet"] = "项链";
_L["Cloak"] = "披风";
_L["Trinket"] = "饰品";
_L["Off Hand"] = "副手";

_L["groupBrowserOptionOne"] = "%s - %s 人(%d秒)";
_L["groupBrowserOptionMore"] = "%s - %s 人(%d秒)";
_L["chatmsg_no_group_priv"] = "|cFFFF0000权限不足。你不是队长。";
_L["chatmsg_group_created"] = "|cFF6CF70F已创建队伍：%s。";
_L["chatmsg_search_failed"] = "|cFFFF0000太多查询请求，请稍后尝试。";
_L["hour_short"] = "时";
_L["minute_short"] = "分";
_L["second_short"] = "秒";

-- KEEP THESE 2 ENGLISH IN EU/US
_L["listing_desc_rare"] = "阿古斯稀有“%s”的战斗。";
_L["listing_desc_invasion"] = "阿古斯 %s。";

_L["Pet"] = "宠物";
_L["(Mount known)"] = "(|cFF00FF00已学会坐骑|r)";
_L["(Mount missing)"] = "(|cFFFF0000未学坐骑|r)";
_L["(Toy known)"] = "(|cFF00FF00已学会玩具|r)";
_L["(Toy missing)"] = " (|cFFFF0000未学玩具|r)";
_L["(itemLinkGreen)"] = "(|cFF00FF00%s|r)";
_L["(itemLinkRed)"] = "(|cFFFF0000%s|r)";
_L["Retrieving data ..."] = "检索数据…";
_L["Sorry, no groups found!"] = "抱歉，没找到队伍！";
_L["Search in Quests"] = "在任务中查找";
_L["Groups found:"] = "找到队伍：";
_L["Create new group"] = "创建新队伍";
_L["Close"] = "关闭";

_L["context_menu_title"] = "Handynotes 阿古斯";
_L["context_menu_check_group_finder"] = "检查团队查找器";
_L["context_menu_reset_rare_counters"] = "重置稀有队伍战斗";
_L["context_menu_add_tomtom"] = "在 TomTom 添加此路径点位置";
_L["context_menu_hide_node"] = "隐藏此物件";
_L["context_menu_restore_hidden_nodes"] = "恢复全部隐藏物件";

_L["options_title"] = "阿古斯";

_L["options_icon_settings"] = "图标设置";
_L["options_icon_settings_desc"] = "图标设置";
_L["options_icons_treasures"] = "宝箱图标";
_L["options_icons_treasures_desc"] = "宝箱图标";
_L["options_icons_rares"] = "稀有图标";
_L["options_icons_rares_desc"] = "稀有图标";
_L["options_icons_pet_battles"] = "战斗宠物图标";
_L["options_icons_pet_battles_desc"] = "战斗宠物图标";
_L["options_icons_sfll"] = "打砸抢图标";
_L["options_icons_sfll_desc"] = "打砸抢图标";
_L["options_scale"] = "大小";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "透明度";
_L["options_opacity_desc"] = "0 = 透明, 1 = 不透明";
_L["options_visibility_settings"] = "可见性";
_L["options_visibility_settings_desc"] = "可见性";
_L["options_toggle_treasures"] = "宝箱";
_L["options_toggle_rares"] = "稀有";
_L["options_toggle_battle_pets"] = "战斗宠物";
_L["options_toggle_sfll"] = "打砸抢";
_L["options_toggle_npcs"] = "NPC";
_L["options_toggle_portals"] = "传送门";
_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用";
_L["options_toggle_alreadylooted_rares"] = "已拾取稀有";
_L["options_toggle_alreadylooted_rares_desc"] = "显示每个稀有无论是否已拾取状态";
_L["options_toggle_alreadylooted_treasures"] = "已拾取宝箱";
_L["options_toggle_alreadylooted_treasures_desc"] = "显示每个宝箱无论是否已拾取状态";
_L["options_toggle_alreadylooted_sfll"] = "已拾取“打砸抢”宝箱";
_L["options_toggle_alreadylooted_sfll_desc"] = "显示每个成就宝箱忽略已拾取状态";
_L["options_toggle_nodeRareGlow"] = "稀有图标光晕";
_L["options_toggle_nodeRareGlow_desc"] = "根据队伍可用性添加稀有图标光晕。没光晕 = 没队伍，红光晕 = 低可用性，绿光晕 = 高可用性。";
_L["options_tooltip_settings"] = "提示";
_L["options_tooltip_settings_desc"] = "提示";
_L["options_toggle_show_loot"] = "显示拾取";
_L["options_toggle_show_loot_desc"] = "在提示上添加拾取信息";
_L["options_toggle_show_notes"] = "显示注释";
_L["options_toggle_show_notes_desc"] = "当可用时在提示上添加有帮助的注释";

_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用设置";
_L["options_toggle_leave_group_on_search"] = "离开队伍";
_L["options_toggle_leave_group_on_search_desc"] = "退出队伍并尝试查找队伍。小心使用！";
_L["chatmsg_old_group_delisted_create"] = "|cFFF7C92A旧队伍已从列表移除。再次点击创建一个新的队伍：%s。";
_L["chatmsg_left_group_create"] = "|cFFF7C92A离开队伍。再次点击创建一个新的队伍：%s。";
_L["chatmsg_old_group_delisted_search"] = "|cFFF7C92A旧队伍已移除。再次点击搜索队伍：%s。";
_L["chatmsg_left_group_search"] = "|cFFF7C92A离开队伍。再次点击搜索队伍：%s。";

_L["options_toggle_include_player_seen"] = "包含玩家见到稀有";
_L["options_toggle_include_player_seen_desc"] = "不要使用。";
_L["options_toggle_show_debug"] = "除错";
_L["options_toggle_show_debug_desc"] = "显示除错信息";

_L["options_toggle_hideKnowLoot"] = "隐藏稀有，如果全部拾取收集完毕";
_L["options_toggle_hideKnowLoot_desc"] = "当全部拾取收集完毕时隐藏全部稀有。";

_L["options_toggle_alwaysTrackCoA"] = "总是追踪阿古斯指挥官";
_L["options_toggle_alwaysTrackCoA_desc"] = "总是追踪阿古斯指挥官成就，帐号完成成就仍追踪，但不是根据角色。";
_L["Missing for CoALink"] = "%s缺少的";

_L["options_toggle_birthday13"] = "魔兽世界13周年世界首领";
_L["options_toggle_birthday13_desc"] = "切换艾索雷葛斯，末日领主卡扎克和梦魇之龙";
_L["options_toggle_alwaysShowBirthday13"] = "- 忽略今日已拾取";
_L["options_toggle_alwaysShowBirthday13_desc"] = "";
_L["Shared"] = "共享";
_L["Somewhere"] = "某处";

end
