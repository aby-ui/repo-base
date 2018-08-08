local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_Argus", "zhTW")

if not _L then return end

if _L then

--
-- DATA
--

--
--    READ THIS BEFORE YOU TRANSLATE !!!
-- 
--    DO NOT TRANSLATE THE RARE NAMES HERE UNLESS YOU HAVE A GOOD REASON!!!
--    FOR EU KEEP THE RARE PART AS IT IS. CHINA & CO MAY NEED TO ADJUST!!!
--
--    _L["Rarename_search"] must have at least 2 Elements! First is the hardfilter, >=2nd are softfilters
--    Keep the hardfilter as general as possible. If you must, set it to "".
--    These Names are only used for the Group finder!
--    Tooltip names are already localized!
--

_L["Watcher Aival"] = "看守者埃瓦爾";
_L["Watcher Aival_search"] = { "看守者埃瓦爾", "埃瓦爾" };
_L["Watcher Aival_note"] = "";
_L["Puscilla"] = "普西拉";
_L["Puscilla_search"] = { "普西拉" };
_L["Puscilla_note"] = "入口在東南部，可以由西面的橋到達";
_L["Vrax'thul"] = "維拉克茲蘇";
_L["Vrax'thul_search"] = { "維拉克茲蘇" };
_L["Vrax'thul_note"] = "";
_L["Ven'orn"] = "威諾恩";
_L["Ven'orn_search"] = { "威諾恩" };
_L["Ven'orn_note"] = "洞穴入口在蜘蛛區（圖標的東北） 坐標︰66, 54.1";
_L["Varga"] = "瓦加";
_L["Varga_search"] = { "瓦加" };
_L["Varga_note"] = "";
_L["Lieutenant Xakaar"] = "撒卡爾中尉";
_L["Lieutenant Xakaar_search"] = { "撒卡爾中尉", "中尉" };
_L["Lieutenant Xakaar_note"] = "";
_L["Wrath-Lord Yarez"] = "憤怒領主亞瑞茲";
_L["Wrath-Lord Yarez_search"] = { "憤怒領主亞瑞茲", "憤怒領主" };
_L["Wrath-Lord Yarez_note"] = "";
_L["Inquisitor Vethroz"] = "審判者維洛斯";
_L["Inquisitor Vethroz_search"] = { "審判者維洛斯", "審判者" };
_L["Inquisitor Vethroz_note"] = "";
_L["Portal to Commander Texlaz"] = "通往指揮官泰克斯拉茲藏身地點的傳送門";
_L["Portal to Commander Texlaz_note"] = "";
_L["Commander Texlaz"] = "指揮官泰克斯拉茲";
_L["Commander Texlaz_search"] = { "指揮官泰克斯拉茲", "泰克斯拉茲" };
_L["Commander Texlaz_note"] = "使用坐標︰80.2, 62.3的傳送門來到達船上";
_L["Admiral Rel'var"] = "瑞爾法上將";
_L["Admiral Rel'var_search"] = { "瑞爾法上將", "上將" };
_L["Admiral Rel'var_note"] = "";
_L["All-Seer Xanarian"] = "『全視者』薩納里安";
_L["All-Seer Xanarian_search"] = { "『全視者』薩納里安", "全視者" };
_L["All-Seer Xanarian_note"] = "";
_L["Worldsplitter Skuul"] = "裂界者斯庫歐";
_L["Worldsplitter Skuul_search"] = { "裂界者斯庫歐", "裂界者" };
_L["Worldsplitter Skuul_note"] = "在上空飛行，有時會接近地面。在世界任務出現時會飛到地面";
_L["Houndmaster Kerrax"] = "馴犬者克拉剋斯";
_L["Houndmaster Kerrax_search"] = { "馴犬者克拉剋斯", "克拉剋斯" };
_L["Houndmaster Kerrax_note"] = "";
_L["Void Warden Valsuran"] = "虛無看守者瓦蘇朗";
_L["Void Warden Valsuran_search"] = { "虛無", "瓦蘇朗" };
_L["Void Warden Valsuran_note"] = "";
_L["Chief Alchemist Munculus"] = "首席鍊金師孟庫勒斯";
_L["Chief Alchemist Munculus_search"] = { "首席鍊金師孟庫勒斯", "首席鍊金師" };
_L["Chief Alchemist Munculus_note"] = "";
_L["The Many-Faced Devourer"] = "多面者";
_L["The Many-Faced Devourer_search"] = { "多面者", "多面" };
_L["The Many-Faced Devourer_note"] = "要召喚多面者先到靈魂魔爐的埃雷達爾身上拿到[多面者之喚]然後去撿以下物品，52.33, 35.33的[犬魔骸骨]，50.33, 55.98的[厄祖獸骸骨]，65.50, 27.38的[小鬼骸骨]，集齊物品後就能召喚";
_L["Portal to Squadron Commander Vishax"] = "通往小隊指揮官維夏克斯藏身地點的傳送門";
_L["Portal to Squadron Commander Vishax_note"] = "首先從不朽虛空行者身上拿到[損壞的傳送門產生器]，然後從魔誓部屬和埃雷達爾戰略師身上拿到[傳導護套]，[弧形迴路和蓄能器]和[蓄能器]，就能解鎖通往小隊指揮官維夏克斯藏身地點的傳送門";
_L["Squadron Commander Vishax"] = "小隊指揮官維夏克斯";
_L["Squadron Commander Vishax_search"] = { "小隊指揮官維夏克斯", "小隊指揮官" };
_L["Squadron Commander Vishax_note"] = "使用坐標︰77.2, 73.2的傳送門來到達船上";
_L["Doomcaster Suprax"] = "末日施法者蘇普雷克斯";
_L["Doomcaster Suprax_search"] = { "末日施法者蘇普雷克斯", "末日施法者" };
_L["Doomcaster Suprax_note"] = "站在3個符文上來召喚他，5分鐘刷新時間";
_L["Mother Rosula"] = "鬼母羅素拉";
_L["Mother Rosula_search"] = { "鬼母羅素拉", "羅素拉" };
_L["Mother Rosula_note"] = "在洞穴中，需要用100個[小鬼肉]合成[噁心盛宴]，然後在圖標處的綠色水池召喚";
_L["Rezira the Seer"] = "『注視者』瑞吉拉";
_L["Rezira the Seer_search"] = { "『注視者』瑞吉拉", "瑞吉拉" };
_L["Rezira the Seer_note"] = "使用[觀察者之域共振器]開啟傳送門到它的藏身之處，[觀察者之域共振器]可以用500個[完整的惡魔眼球]來跟『全視者』歐瑞克斯(坐標：60.2, 45.4)交換";
_L["Blistermaw"] = "泡嘴";
_L["Blistermaw_search"] = { "泡嘴" };
_L["Blistermaw_note"] = "";
_L["Mistress Il'thendra"] = "伊珊卓拉女士";
_L["Mistress Il'thendra_search"] = { "伊珊卓拉女士", "女士" };
_L["Mistress Il'thendra_note"] = "";
_L["Gar'zoth"] = "加爾梭斯";
_L["Gar'zoth_search"] = { "加爾梭斯" };
_L["Gar'zoth_note"] = "";

_L["One-of-Many"] = "眾合體";
_L["One-of-Many_note"] = "";
_L["Minixis"] = "迷你派拉西斯";
_L["Minixis_note"] = "";
_L["Watcher"] = "看守者";
_L["Watcher_note"] = "";
_L["Bloat"] = "膨腫";
_L["Bloat_note"] = "";
_L["Earseeker"] = "尋耳魔翼";
_L["Earseeker_note"] = "";
_L["Pilfer"] = "竊魔";
_L["Pilfer_note"] = "";

_L["Orix the All-Seer"] = "『全視者』歐瑞克斯";
_L["Orix the All-Seer_note"] = "點擊綠色惡魔眼睛，然後去刷這區域的惡魔（你會損失90%生命值）";

_L["Forgotten Legion Supplies"] = "被遺忘的燃燒軍團補給品";
_L["Forgotten Legion Supplies_note"] = "被岩石擋住，用[光鑄機甲]的[十字軍躍擊]跳過去";
_L["Ancient Legion War Cache"] = "古老燃燒軍團戰爭寶箱";
_L["Ancient Legion War Cache_note"] = "在崖下的山洞內，先從上方小心地跳下來，再用[聖光審判]打破岩石";
_L["Fel-Bound Chest"] = "魔縛寶箱";
_L["Fel-Bound Chest_note"] = "在山洞內，從53.7, 30.9的石崖開始跳過去，再用[聖光審判]打破岩石";
_L["Legion Treasure Hoard"] = "燃燒軍團囤積的財寶";
_L["Legion Treasure Hoard_note"] = "在魔化瀑布後面";
_L["Timeworn Fel Chest"] = "古舊的魔化箱";
_L["Timeworn Fel Chest_note"] = "從『全視者』薩納里安房子旁邊的石崖跳下去，寶箱就在綠色水池旁邊";
_L["Missing Augari Chest"] = "遺失的奧加利寶箱";
_L["Missing Augari Chest_note"] = "箱子在綠池區，用[秘法回音屏蔽術]來打開箱子";

-- 48382
_L["48382_67546980_note"] = "在房子裡";
_L["48382_67466226_note"] = "";
_L["48382_71326946_note"] = "在哈卓克斯旁邊";
_L["48382_58066806_note"] = "";
_L["48382_68026624_note"] = "在軍團建築物裡";
_L["48382_64506868_note"] = "在外面";
_L["48382_62666823_note"] = "在房子裡";
-- 48383
_L["48383_56903570_note"] = "";
_L["48383_57633179_note"] = "";
_L["48383_52182918_note"] = "";
_L["48383_58174021_note"] = "";
_L["48383_51863409_note"] = "";
_L["48383_55133930_note"] = "";
_L["48383_58413097_note"] = "在房子裡面的底層";
_L["48383_53753556_note"] = "";
_L["48383_51703529_note"] = "在懸崖上";
_L["48383_59853583_note"] = "";
-- 48384
_L["48384_60872900_note"] = "";
_L["48384_61332054_note"] = "在首席鍊金師孟庫勒斯的房子裡";
_L["48384_59081942_note"] = "在房子裡";
_L["48384_64152305_note"] = "在馴犬者克拉剋斯的洞穴裡";
_L["48384_66621709_note"] = "在小鬼洞穴裡，在鬼母羅素拉旁邊";
_L["48384_63682571_note"] = "在馴犬者克拉剋斯的洞穴前面";
_L["48384_61862236_note"] = "在外面，首席鍊金師孟庫勒斯的旁邊";
_L["48384_64132738_note"] = "";
-- 48385
_L["48385_50605720_note"] = "";
_L["48385_55544743_note"] = "";
_L["48385_57135124_note"] = "";
_L["48385_55915425_note"] = "";
_L["48385_48195451_note"] = "";
-- 48387
_L["48387_69403965_note"] = "";
_L["48387_66643654_note"] = "";
_L["48387_68983342_note"] = "";
_L["48387_65522831_note"] = "在橋下";
_L["48387_63613643_note"] = "";
_L["48387_73404669_note"] = "跳過綠水";
_L["48387_67954006_note"] = "";
-- 48388
_L["48388_51502610_note"] = "";
_L["48388_59261743_note"] = "";
_L["48388_55921387_note"] = "";
_L["48388_55841722_note"] = "";
_L["48388_55622042_note"] = "在虛無看守者瓦蘇朗旁邊，需要跳上石坡上";
_L["48388_59661398_note"] = "";
_L["48388_54102803_note"] = "在平台附近的岩石上";
-- 48389
_L["48389_64305040_note"] = "在瓦加的洞穴內";
_L["48389_60254351_note"] = "";
_L["48389_65514081_note"] = "";
_L["48389_60304675_note"] = "";
_L["48389_65345192_note"] = "在洞穴中，瓦加的旁邊";
_L["48389_64114242_note"] = "岩石下面";
_L["48389_58734323_note"] = "魔化熔岩的小土地上";
-- 48390
_L["48390_81306860_note"] = "在船上";
_L["48390_80406152_note"] = "";
_L["48390_82566503_note"] = "在船上";
_L["48390_73316858_note"] = "在頂層，瑞爾法上將的旁邊";
_L["48390_77127529_note"] = "維夏克斯的傳送門的旁邊";
_L["48390_72527293_note"] = "在維夏克斯的後面";
_L["48390_77255876_note"] = "在斜坡下";
_L["48390_72215680_note"] = "在房子裡";
_L["48390_73277299_note"] = "在瑞爾法上將後面";
_L["48390_77975620_note"] = "下斜坡再走過懸崖"
-- 48391
_L["48391_64135867_note"] = "在威諾恩的蜘蛛洞裡";
_L["48391_67404790_note"] = "在蜘蛛區北邊出口旁的小洞穴內";
_L["48391_63615622_note"] = "在威諾恩的蜘蛛洞裡";
_L["48391_65005049_note"] = "在蜘蛛區的外面";
_L["48391_63035762_note"] = "在威諾恩的蜘蛛洞裡";
_L["48391_65185507_note"] = "在蜘蛛區的上方入口";
_L["48391_68095075_note"] = "在蜘蛛區的小洞穴內";
_L["48391_69815522_note"] = "在蜘蛛區的外面";
_L["48391_71205441_note"] = "在蜘蛛區的外面";
_L["48391_66544668_note"] = "連接綠色區域的北邊蜘蛛區出口，跳上石頭上";

-- Krokuun
_L["Khazaduum"] = "卡薩頓";
_L["Khazaduum_search"] = { "卡薩頓" };
_L["Khazaduum_note"] = "入口在東南，坐標：50.3, 17.3";
_L["Commander Sathrenael"] = "指揮官薩斯倫奈";
_L["Commander Sathrenael_search"] = { "指揮官薩斯倫奈", "薩斯倫奈" };
_L["Commander Sathrenael_note"] = "";
_L["Commander Endaxis"] = "指揮官安德克希斯";
_L["Commander Endaxis_search"] = { "指揮官安德克希斯", "安德克希斯" };
_L["Commander Endaxis_note"] = "";
_L["Sister Subversia"] = "薩布維希亞姊妹";
_L["Sister Subversia_search"] = { "薩布維希亞姊妹", "姊妹" };
_L["Sister Subversia_note"] = "";
_L["Siegemaster Voraan"] = "攻城大師沃蘭";
_L["Siegemaster Voraan_search"] = { "攻城大師沃蘭", "攻城大師" };
_L["Siegemaster Voraan_note"] = "";
_L["Talestra the Vile"] = "『邪惡魔女』泰莉絲塔";
_L["Talestra the Vile_search"] = { "『邪惡魔女』泰莉絲塔", "泰莉絲塔" };
_L["Talestra the Vile_note"] = "";
_L["Commander Vecaya"] = "指揮官維卡雅";
_L["Commander Vecaya_search"] = { "指揮官維卡雅", "維卡雅" };
_L["Commander Vecaya_note"] = "從坐標：42, 57.1的路過去";
_L["Vagath the Betrayed"] = "『背叛者』瓦卡斯";
_L["Vagath the Betrayed_search"] = { "『背叛者』瓦卡斯", "瓦卡斯" };
_L["Vagath the Betrayed_note"] = "";
_L["Tereck the Selector"] = "『決選者』泰瑞克";
_L["Tereck the Selector_search"] = { "『決選者』泰瑞克", "泰瑞克" };
_L["Tereck the Selector_note"] = "";
_L["Tar Spitter"] = "瀝青噴吐者";
_L["Tar Spitter_search"] = { "瀝青噴吐者", "瀝青" };
_L["Tar Spitter_note"] = "";
_L["Imp Mother Laglath"] = "鬼母拉格萊斯";
_L["Imp Mother Laglath_search"] = { "鬼母拉格萊斯", "拉格萊斯" };
_L["Imp Mother Laglath_note"] = "";
_L["Naroua"] = "那洛亞";
_L["Naroua_search"] = { "那洛亞" };
_L["Naroua_note"] = "";

_L["Baneglow"] = "禍光";
_L["Baneglow_note"] = "";
_L["Foulclaw"] = "穢爪";
_L["Foulclaw_note"] = "";
_L["Ruinhoof"] = "墟蹄";
_L["Ruinhoof_note"] = "";
_L["Deathscreech"] = "死亡尖嘯";
_L["Deathscreech_note"] = "";
_L["Gnasher"] = "嚙咬者";
_L["Gnasher_note"] = "";
_L["Retch"] = "芻嘔";
_L["Retch_note"] = "";

-- Shoot First, Loot Later
_L["Krokul Emergency Cache"] = "克庫緊急藏寶箱";
_L["Krokul Emergency Cache_note"] = "山洞在崖上被石頭擋住，用[破碎的萊迪納克斯控制寶石]或[光鑄機甲]跳過石頭";
_L["Legion Tower Chest"] = "軍團高塔寶箱";
_L["Legion Tower Chest_note"] = "入口在通從那洛亞林地的路上，有石頭擋住，用[聖光審判]打破岩石";
_L["Lost Krokul Chest"] = "遺失的克庫藏寶箱";
_L["Lost Krokul Chest_note"] = "山洞在路邊，用[聖光審判]打破岩石";
_L["Long-Lost Augari Treasure"] = "被遺忘已久的奧加利寶藏";
_L["Long-Lost Augari Treasure_note"] = "用[秘法回音屏蔽術]來打開箱子";
_L["Precious Augari Keepsakes"] = "貴重的的奧加利寶藏";
_L["Precious Augari Keepsakes_note"] = "用[秘法回音屏蔽術]來打開箱子";

-- 47752
_L["47752_55555863_note"] = "由西邊開始跳石頭過去";
_L["47752_52185431_note"] = "由看到卡拉厄茲的路走上去";
_L["47752_50405122_note"] = "由看到卡拉厄茲的路走上去";
_L["47752_53265096_note"] = "由看到卡拉厄茲的路走上去，再綠池的另一邊";
_L["47752_57005472_note"] = "在岩石下，熔岩旁邊";
_L["47752_59695196_note"] = "在瑟塔魯旁邊，岩石後面";
_L["47752_51425958_note"] = "";
-- 47753
_L["47753_53167308_note"] = "";
_L["47753_55228114_note"] = "";
_L["47753_59267341_note"] = "";
_L["47753_56118037_note"] = "在『邪惡魔女』泰莉絲塔的房子外";
_L["47753_58597958_note"] = "在惡魔尖塔後面";
_L["47753_58197157_note"] = "";
_L["47753_52737591_note"] = "在石頭後";
_L["47753_58048036_note"] = "";
-- 47997
_L["47997_45876777_note"] = "在岩石下，橋的旁邊";
_L["47997_45797753_note"] = "";
_L["47997_43858139_note"] = "從49.1, 69.3的路開始沿著南方山脊走";
_L["47997_43816689_note"] = "在岩石下，從橋邊的路跳下去";
_L["47997_40687531_note"] = "";
_L["47997_46996831_note"] = "在龍骨的頂部";
_L["47997_41438003_note"] = "爬上墜毀的軍團戰艦上的石頭";
_L["47997_41548379_note"] = "";
_L["47997_46458665_note"] = "跳過石頭來拾取箱子";
_L["47997_40357414_note"] = "";
-- 47999
_L["47999_62592581_note"] = "";
_L["47999_59763951_note"] = "";
_L["47999_59071884_note"] = "在上面，岩石的後面";
_L["47999_61643520_note"] = "";
_L["47999_61463580_note"] = "在房子裡";
_L["47999_59603052_note"] = "橋底";
_L["47999_60891852_note"] = "在『背叛者』瓦卡斯後面的小屋裡";
_L["47999_49063350_note"] = "";
_L["47999_65992286_note"] = "";
_L["47999_64632319_note"] = "在房子裡";
_L["47999_51533583_note"] = "在房子外，要越過魔化池";
_L["47999_60422354_note"] = "";
-- 48000
_L["48000_70907370_note"] = "";
_L["48000_74136790_note"] = "";
_L["48000_75166435_note"] = "在洞穴的盡頭";
_L["48000_69605772_note"] = "";
_L["48000_69787836_note"] = "跳上旁邊的斜坡";
_L["48000_68566054_note"] = "在『決選者』泰瑞克的洞穴前面";
_L["48000_72896482_note"] = "";
_L["48000_71827536_note"] = "";
_L["48000_73577146_note"] = "";
_L["48000_71846166_note"] = "需要爬上斜狀的柱子";
_L["48000_67886231_note"] = "柱子後面";
_L["48000_74996922_note"] = "";
-- 48336
_L["48336_33575511_note"] = "瑟納達爾的上層，在外面";
_L["48336_32047441_note"] = "";
_L["48336_27196668_note"] = "";
_L["48336_31936750_note"] = "";
_L["48336_35415637_note"] = "在瑟納達爾前方入口前面的地面";
_L["48336_29645761_note"] = "在洞穴內";
_L["48336_40526067_note"] = "在黃色小屋裡";
_L["48336_36205543_note"] = "在瑟納達爾的上層";
_L["48336_25996814_note"] = "";
_L["48336_37176401_note"] = "在瓦礫下";
_L["48336_28247134_note"] = "";
_L["48336_30276403_note"] = "在逃生艙內";
-- 48339
_L["48339_68533891_note"] = "";
_L["48339_63054240_note"] = "";
_L["48339_64964156_note"] = "";
_L["48339_73393438_note"] = "";
_L["48339_72213234_note"] = "在巨大頭骨後面";
_L["48339_65983499_note"] = "";
_L["48339_64934217_note"] = "在樹幹內";
_L["48339_67713454_note"] = "";
_L["48339_72493605_note"] = "";
_L["48339_44864342_note"] = "";

-- Mac'Aree
_L["Shadowcaster Voruun"] = "暗影施法者沃魯恩";
_L["Shadowcaster Voruun_search"] = { "暗影施法者沃魯恩", "暗影施法者" };
_L["Shadowcaster Voruun_note"] = "";
_L["Soultwisted Monstrosity"] = "曲魂巨怪";
_L["Soultwisted Monstrosity_search"] = { "曲魂巨怪", "曲魂" };
_L["Soultwisted Monstrosity_note"] = "";
_L["Wrangler Kravos"] = "馴獸師克拉弗斯";
_L["Wrangler Kravos_search"] = { "馴獸師克拉弗斯", "馴獸師" };
_L["Wrangler Kravos_note"] = "";
_L["Kaara the Pale"] = "蒼白的卡厄拉";
_L["Kaara the Pale_search"] = { "蒼白的卡厄拉", "蒼白" };
_L["Kaara the Pale_note"] = "";
_L["Feasel the Muffin Thief"] = "『瑪芬蛋糕盜賊』費索";
_L["Feasel the Muffin Thief_search"] = { "『瑪芬蛋糕盜賊』費索", "費索" };
_L["Feasel the Muffin Thief_note"] = "要打斷鑽地";
_L["Vigilant Thanos"] = "警戒傀儡山諾斯";
_L["Vigilant Thanos_search"] = { "警戒傀儡山諾斯", "山諾斯" };
_L["Vigilant Thanos_note"] = "";
_L["Vigilant Kuro"] = "警戒傀儡庫羅";
_L["Vigilant Kuro_search"] = { "警戒傀儡庫羅", "庫羅" };
_L["Vigilant Kuro_note"] = "";
_L["Venomtail Skyfin"] = "毒尾天鰭魟魚";
_L["Venomtail Skyfin_search"] = { "毒尾天鰭魟魚", "毒尾" };
_L["Venomtail Skyfin_note"] = "";
_L["Turek the Lucid"] = "清醒的圖瑞克";
_L["Turek the Lucid_search"] = { "清醒的圖瑞克", "清醒" };
_L["Turek the Lucid_note"] = "下樓梯進到房子裡";
_L["Captain Faruq"] = "法魯克隊長";
_L["Captain Faruq_search"] = { "法魯克隊長", "法魯克" };
_L["Captain Faruq_note"] = "";
_L["Umbraliss"] = "昂卜利絲";
_L["Umbraliss_search"] = { "昂卜利絲" };
_L["Umbraliss_note"] = "";
_L["Sorolis the Ill-Fated"] = "不幸的梭羅利斯";
_L["Sorolis the Ill-Fated_search"] = { "不幸的梭羅利斯", "梭羅利斯" };
_L["Sorolis the Ill-Fated_note"] = "";
_L["Herald of Chaos"] = "混沌信使";
_L["Herald of Chaos_search"] = { "混沌信使" };
_L["Herald of Chaos_note"] = "他在二樓";
_L["Sabuul"] = "薩布歐";
_L["Sabuul_search"] = { "薩布歐" };
_L["Sabuul_note"] = "";
_L["Jed'hin Champion Vorusk"] = "傑頂摔角冠軍沃魯斯克";
_L["Jed'hin Champion Vorusk_search"] = { "傑頂摔角冠軍沃魯斯克", "傑頂摔角冠軍" };
_L["Jed'hin Champion Vorusk_note"] = "";
_L["Overseer Y'Beda"] = "監督者伊貝塔";
_L["Overseer Y'Beda_search"] = { "監督者伊貝塔", "伊貝塔" };
_L["Overseer Y'Beda_note"] = "";
_L["Overseer Y'Sorna"] = "監督者伊索娜";
_L["Overseer Y'Sorna_search"] = { "監督者伊索娜", "伊索娜" };
_L["Overseer Y'Sorna_note"] = "";
_L["Overseer Y'Morna"] = "監督者伊摩娜";
_L["Overseer Y'Morna_search"] = { "監督者伊摩娜", "伊摩娜" };
_L["Overseer Y'Morna_note"] = "";
_L["Instructor Tarahna"] = "講師塔拉娜";
_L["Instructor Tarahna_search"] = { "講師塔拉娜", "塔拉娜" };
_L["Instructor Tarahna_note"] = "";
_L["Zul'tan the Numerous"] = "『眾相一體』祖爾潭";
_L["Zul'tan the Numerous_search"] = { "『眾相一體』祖爾潭", "祖爾潭" };
_L["Zul'tan the Numerous_note"] = "在房子裡";
_L["Commander Xethgar"] = "指揮官榭斯加爾";
_L["Commander Xethgar_search"] = { "指揮官榭斯加爾", "榭斯加爾" };
_L["Commander Xethgar_note"] = "";
_L["Skreeg the Devourer"] = "『吞噬者』斯奎里格";
_L["Skreeg the Devourer_search"] = { "『吞噬者』斯奎里格", "斯奎里格" };
_L["Skreeg the Devourer_note"] = "";
_L["Baruut the Bloodthirsty"] = "嚐血的巴魯特";
_L["Baruut the Bloodthirsty_search"] = { "嚐血的巴魯特", "嚐血" };
_L["Baruut the Bloodthirsty_note"] = "";
_L["Ataxon"] = "亞泰克森";
_L["Ataxon_search"] = { "亞泰克森" };
_L["Ataxon_note"] = "";
_L["Slithon the Last"] = "『末裔』斯里頌";
_L["Slithon the Last_search"] = { "『末裔』斯里頌", "斯里頌" };
_L["Slithon the Last_note"] = "";

_L["Gloamwing"] = "晦翼";
_L["Gloamwing_note"] = "";
_L["Bucky"] = "小巴克";
_L["Bucky_note"] = "";
_L["Mar'cuus"] = "馬柯爾斯";
_L["Mar'cuus_note"] = "";
_L["Snozz"] = "斯洛茲";
_L["Snozz_note"] = "";
_L["Corrupted Blood of Argus"] = "阿古斯腐化之血";
_L["Corrupted Blood of Argus_note"] = "";
_L["Shadeflicker"] = "影爍";
_L["Shadeflicker_note"] = "";

-- Shoot First, Loot Later
_L["Eredar Treasure Cache"] = "埃雷達爾藏寶箱";
_L["Eredar Treasure Cache_note"] = "在山洞內，用[光鑄機甲]移走岩石";
_L["Chest of Ill-Gotten Gains"] = "不義之財寶箱";
_L["Chest of Ill-Gotten Gains_note"] = "用[聖光審判]打破岩石";
_L["Student's Surprising Surplus"] = "學生意外遺留的物資";
_L["Student's Surprising Surplus_note"] = "寶箱在山洞內，入口在坐標：62.2, 72.2，用[聖光審判]打破岩石";
_L["Void-Tinged Chest"] = "沽染虛無的寶箱";
_L["Void-Tinged Chest_note"] = "在地下，用[光鑄機甲]移走岩石";
_L["Augari Secret Stash"] = "奧加利秘密寶物";
_L["Augari Secret Stash_note"] = "走到坐標：68.0, 56.9可以看到寶箱，上坐騎跳過去，立即使用滑翔翼會比較安全";
_L["Desperate Eredar's Cache"] = "窮途末路埃雷達爾的寶箱";
_L["Desperate Eredar's Cache_note"] = "從57.1, 74.3跳到塔的後面";
_L["Shattered House Chest"] = "破碎的家中寶箱";
_L["Shattered House Chest_note"] = "走到坐標：31.2, 44.9，在這裡的東南一點，跳下去然後使用滑翔翼";
_L["Doomseeker's Treasure"] = "末日尋者的寶藏";
_L["Doomseeker's Treasure_note"] = "寶箱在地底，東面是一個流水向洞穴的瀑布，運氣好的話跳下去就能到達，用坐騎跳下去後用滑翔翼會比較安全";
_L["Augari-Runed Chest"] = "奧加利符文寶箱";
_L["Augari-Runed Chest_note"] = "寶箱在樹下，用[秘法回音屏蔽術]來打開箱子";
_L["Secret Augari Chest"] = "奧加利秘密寶箱";
_L["Secret Augari Chest_note"] = "用[秘法回音屏蔽術]來打開箱子";
_L["Augari Goods"] = "奧加利物資";
_L["Augari Goods_note"] = "寶箱在小房子內，用[秘法回音屏蔽術]來打開箱子";
-- Ancient Eredar Cache
-- 48346
_L["48346_55167766_note"] = "";
_L["48346_59386372_note"] = "在透明的紅色帳篷裡" ;
_L["48346_57486159_note"] = "在馴獸師克拉弗斯旁邊的房子內" ;
_L["48346_50836729_note"] = "";
_L["48346_52868241_note"] = "";
_L["48346_47186234_note"] = "";
-- 48350
_L["48350_59622088_note"] = "在房子內的樓梯下";
_L["48350_60493338_note"] = "在房子裡";
_L["48350_53912335_note"] = "在房子裡";
_L["48350_55063508_note"] = "";
_L["48350_62202636_note"] = "進到陽台上，走進房子內再起上樓梯然後向右走";
_L["48350_53332740_note"] = "在樹下";
-- 48351
_L["48351_43637134_note"] = "";
_L["48351_34205929_note"] = "在二樓，混沌信使旁邊";
_L["48351_43955630_note"] = "在樹下";
_L["48351_46917346_note"] = "藏在樹下";
_L["48351_36296646_note"] = "";
_L["48351_42645361_note"] = "在洞穴內，入口在這裡的西南邊";
-- 48357
_L["48357_49412387_note"] = "";
_L["48357_47672180_note"] = "";
_L["48357_48482115_note"] = "";
_L["48357_57881053_note"] = "";
_L["48357_52871676_note"] = "上樓梯";
_L["48357_47841956_note"] = "";
-- 48371
_L["48371_48604971_note"] = "";
_L["48371_49865494_note"] = "";
_L["48371_47023655_note"] = "上樓梯";
_L["48371_49623585_note"] = "上樓梯";
_L["48371_51094790_note"] = "在樹下";
_L["48371_35535718_note"] = "在二樓，混沌信使的旁邊";
-- 48362
_L["48362_66682786_note"] = "在房子內，『眾相一體』祖爾潭的旁邊";
_L["48362_62134077_note"] = "在房子裡";
_L["48362_67254608_note"] = "在房子裡";
_L["48362_68355322_note"] = "在房子裡";
_L["48362_65966017_note"] = "";
_L["48362_62053268_note"] = "在崖上";
-- Void-Seeped Cache / Treasure Chest
-- 49264
_L["49264_38143985_note"] = "";
_L["49264_37613608_note"] = "";
_L["49264_37812344_note"] = "";
_L["49264_33972078_note"] = "";
_L["49264_33312952_note"] = "";
-- 48361
_L["48361_37664221_note"] = "在洞穴內柱子後";
_L["48361_25824471_note"] = "";
_L["48361_20674033_note"] = "";
_L["48361_29503999_note"] = "";
_L["48361_29455043_note"] = "在樹下";
_L["48361_18794171_note"] = "在外面，房子的後面";

--
--    KEEP THESE ENGLISH FOR THE GROUP BROWSER IN EU/US!! CHINA & CO ADJUST
--    SEARCH ARRAY AS BEFORE, MUST HAVE MINIMUM 2 ELEMENTS
--

_L["Invasion Point: Val"] = "侵略點：衛爾";
_L["Invasion Point: Aurinor"] = "侵略點：奧里諾";
_L["Invasion Point: Sangua"] = "侵略點：薩恩古瓦";
_L["Invasion Point: Naigtal"] = "侵略點：奈格塔";
_L["Invasion Point: Bonich"] = "侵略點：波尼克";
_L["Invasion Point: Cen'gar"] = "侵略點：申迦爾";
_L["Greater Invasion Point: Mistress Alluradel"] = "大型侵略點：魔女雅露拉黛兒";
_L["Greater Invasion Point: Matron Folnuna"] = "大型侵略點：鬼母佛努娜";

_L["invasion_val_search"] = { "衛爾", "侵略點.*衛爾" };
_L["invasion_aurinor_search"] = "奧里諾";
_L["invasion_sangua_search"] = "薩恩古瓦";
_L["invasion_naigtal_search"] = "奈格塔";
_L["invasion_bonich_search"] = "波尼克";
_L["invasion_cengar_search"] = "申迦爾";
_L["invasion_alluradel_search"] = "雅露拉黛兒";
_L["invasion_folnuna_search"] = "鬼母佛努娜";

--
--
-- INTERFACE
--
--

_L["Argus"] = "阿古斯稀有和寶藏";
_L["Antoran Wastes"] = "安托洛斯荒原";
_L["Krokuun"] = "克庫恩";
_L["Mac'Aree"] = "麥克艾瑞";

_L["Shield"] = "盾牌";
_L["Cloth"] = "布甲";
_L["Leather"] = "皮甲";
_L["Mail"] = "鎖甲";
_L["Plate"] = "鎧甲";
_L["1h Mace"] = "單手錘";
_L["1h Sword"] = "單手劍";
_L["1h Axe"] = "單手斧";
_L["2h Mace"] = "雙手錘";
_L["2h Sword"] = "雙手劍";
_L["2h Axe"] = "雙手斧";
_L["Dagger"] = "匕首";
_L["Staff"] = "法杖";
_L["Fist"] = "拳套";
_L["Polearm"] = "長柄武器";
_L["Bow"] = "弓";
_L["Gun"] = "槍械";
_L["Crossbow"] = "弩";

_L["groupBrowserOptionOne"] = "%s - %s 人 (%d秒)";
_L["groupBrowserOptionMore"] = "%s - %s 人 (%d秒)";
_L["chatmsg_no_group_priv"] = "|cFFFF0000權限不足，你不是隊長";
_L["chatmsg_group_created"] = "|cFF6CF70F編組隊伍 - %s.";
_L["chatmsg_search_failed"] = "|cFFFF0000過多搜尋指令，請再幾秒後再嘗試";
_L["hour_short"] = "時";
_L["minute_short"] = "分";
_L["second_short"] = "秒";

-- KEEP THESE 2 ENGLISH IN EU/US
_L["listing_desc_rare"] = "檢查阿古斯 - %s 的稀有隊伍中";
_L["listing_desc_invasion"] = "%s 在阿古斯";

_L["Pet"] = "寵物";
_L["(Mount known)"] = "(|cFF00FF00已學會坐騎|r)";
_L["(Mount missing)"] = "(|cFFFF0000未學會坐騎|r)";
_L["(Toy known)"] = "(|cFF00FF00已學會玩具|r)";
_L["(Toy missing)"] = " (|cFFFF0000未學會玩具|r)";
_L["(itemLinkGreen)"] = "(|cFF00FF00%s|r)";
_L["(itemLinkRed)"] = "(|cFFFF0000%s|r)";
_L["Retrieving data ..."] = "檢索數據中...";
_L["Sorry, no groups found!"] = "抱歉！未能找到隊伍";
_L["Search in Quests"] = "在任務中搜索";
_L["Groups found:"] = "找到隊伍︰";
_L["Create new group"] = "編組隊伍";
_L["Close"] = "關閉";

_L["context_menu_title"] = "Handynotes Argus";
_L["context_menu_check_group_finder"] = "搜尋隊伍可用性";
_L["context_menu_reset_rare_counters"] = "重置隊伍搜尋器";
_L["context_menu_add_tomtom"] = "為這地點增加TomTom航點";
_L["context_menu_hide_node"] = "從地圖上移除此圖標";
_L["context_menu_restore_hidden_nodes"] = "還原已移除的圖標";

_L["options_title"] = "阿古斯寶藏";

_L["options_icon_settings"] = "圖標設定";
_L["options_icon_settings_desc"] = "圖標設定";
_L["options_icons_treasures"] = "寶藏圖標";
_L["options_icons_treasures_desc"] = "寶藏圖標";
_L["options_icons_rares"] = "稀有圖標";
_L["options_icons_rares_desc"] = "稀有圖標";
_L["options_icons_pet_battles"] = "寵物對戰圖標";
_L["options_icons_pet_battles_desc"] = "寵物對戰圖標";
_L["options_icons_sfll"] = "[先斬後搜]圖標";
_L["options_icons_sfll_desc"] = "[先斬後搜]圖標";
_L["options_scale"] = "大小";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "透明度";
_L["options_opacity_desc"] = "0 = 透明，1 = 不透明";
_L["options_visibility_settings"] = "可見性設定";
_L["options_visibility_settings_desc"] = "可見性設定";
_L["options_toggle_treasures"] = "寶藏";
_L["options_toggle_rares"] = "稀有";
_L["options_toggle_battle_pets"] = "寵物對戰";
_L["options_toggle_sfll"] = "[先斬後搜]";
_L["options_toggle_npcs"] = "NPCs";
_L["options_toggle_portals"] = "傳送門";
_L["options_general_settings"] = "一般";
_L["options_general_settings_desc"] = "一般";
_L["options_toggle_alreadylooted_rares"] = "仍然顯示已經擊殺的稀有怪物";
_L["options_toggle_alreadylooted_rares_desc"] = "顯示每個稀有不論拾取狀態";
_L["options_toggle_alreadylooted_treasures"] = "仍然顯示已經拾取的寶藏";
_L["options_toggle_alreadylooted_treasures_desc"] = "顯示每個寶藏不論拾取狀態";
_L["options_toggle_alreadylooted_sfll"] = "仍然顯示已經拾取的成就[先斬後搜]所需要的寶藏";
_L["options_toggle_alreadylooted_sfll_desc"] = "顯示每個成就[先斬後搜]所需要的寶藏不論拾取狀態";
_L["options_toggle_nodeRareGlow"] = "稀有圖標發光"
_L["options_toggle_nodeRareGlow_desc"] = "讓稀有圖標發光來檢查隊伍可用性. 沒有發光 = 沒有隊伍, 紅色 = 低可用性, 綠色 = 高可用性."
_L["options_tooltip_settings"] = "工具";
_L["options_tooltip_settings_desc"] = "工具";
_L["options_toggle_show_loot"] = "顯示掉落";
_L["options_toggle_show_loot_desc"] = "顯示每個寶藏/稀有怪物的掉落";
_L["options_toggle_show_notes"] = "顯示註記";
_L["options_toggle_show_notes_desc"] = "顯示每個寶藏/稀有怪物的註記如果可用的話";

_L["options_general_settings"] = "一般";
_L["options_general_settings_desc"] = "一般設定";
_L["options_toggle_leave_group_on_search"] = "離開隊伍";
_L["options_toggle_leave_group_on_search_desc"] = "當嘗試尋找隊伍的時候離開隊伍，請小心使用！";
_L["chatmsg_old_group_delisted_create"] = "|cFFF7C92A舊隊伍已從列表移除，再次點擊創建一個新的隊伍：%s."
_L["chatmsg_left_group_create"] = "|cFFF7C92A離開隊伍，再次點擊創建一個新的隊伍：%s.";
_L["chatmsg_old_group_delisted_search"] = "|cFFF7C92A舊隊伍已失效，再次點擊搜尋隊伍 - %s."
_L["chatmsg_left_group_search"] = "|cFFF7C92A離開隊伍，再次點擊搜尋隊伍：%s.";

end
