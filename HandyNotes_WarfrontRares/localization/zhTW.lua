--- 简转繁 by abyui
local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_WarfrontRares", "zhTW")

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

_L["Kor'gresh Coldrage_cave"] = "到考格雷什的洞穴入口";
_L["Geomancer Flintdagger_cave"] = "到地占師弗林塔格的洞穴入口";
_L["Foulbelly_cave"] = "到弗爾伯利的洞穴入口";
_L["Kovork_cave"] = "到考沃克的洞穴入口";
_L["Zalas Witherbark_cave"] = "到紮拉斯•枯木的洞穴入口";
_L["Overseer Krix_cave"] = "到監工克裡克斯的洞穴入口";

--
--
-- INTERFACE
--
--

_L["Alliance only"] = "僅聯盟";
_L["Horde only"] = "僅部落";
_L["In cave"] = "在洞穴";

_L["Argus"] = "阿古斯";
_L["Antoran Wastes"] = "安托蘭廢土";
_L["Krokuun"] = "克羅庫恩";
_L["Mac'Aree"] = "瑪凱雷";

_L["Shield"] = "盾牌";
_L["Cloth"] = "布甲";
_L["Leather"] = "皮甲";
_L["Mail"] = "鎖甲";
_L["Plate"] = "板甲";
_L["1h Mace"] = "單手錘";
_L["1h Sword"] = "單手劍";
_L["1h Axe"] = "單手斧";
_L["2h Mace"] = "雙手錘";
_L["2h Axe"] = "雙手斧";
_L["2h Sword"] = "雙手劍";
_L["Dagger"] = "匕首";
_L["Staff"] = "法杖";
_L["Fist"] = "拳套";
_L["Polearm"] = "長柄武器";
_L["Bow"] = "弓";
_L["Gun"] = "槍";
_L["Wand"] = "魔杖";
_L["Crossbow"] = "弩";
_L["Ring"] = "戒指";
_L["Amulet"] = "項鍊";
_L["Cloak"] = "披風";
_L["Trinket"] = "飾品";
_L["Off Hand"] = "副手";

_L["groupBrowserOptionOne"] = "%s - %s 人(%d秒)";
_L["groupBrowserOptionMore"] = "%s - %s 人(%d秒)";
_L["chatmsg_no_group_priv"] = "|cFFFF0000許可權不足。你不是隊長。";
_L["chatmsg_group_created"] = "|cFF6CF70F已創建隊伍：%s。";
_L["chatmsg_search_failed"] = "|cFFFF0000太多查詢請求，請稍後嘗試。";
_L["hour_short"] = "時";
_L["minute_short"] = "分";
_L["second_short"] = "秒";

-- KEEP THESE 2 ENGLISH IN EU/US
_L["listing_desc_rare"] = "戰爭前線稀有“%s”的戰鬥。";
_L["listing_desc_invasion"] = "戰爭前線 %s。";

_L["Pet"] = "寵物";
_L["(Mount known)"] = "(|cFF00FF00已學會坐騎|r)";
_L["(Mount missing)"] = "(|cFFFF0000未學坐騎|r)";
_L["(Toy known)"] = "(|cFF00FF00已學會玩具|r)";
_L["(Toy missing)"] = " (|cFFFF0000未學玩具|r)";
_L["(itemLinkGreen)"] = "(|cFF00FF00%s|r)";
_L["(itemLinkRed)"] = "(|cFFFF0000%s|r)";
_L["Retrieving data ..."] = "檢索資料…";
_L["Sorry, no groups found!"] = "抱歉，沒找到隊伍！";
_L["Search in Quests"] = "在任務中查找";
_L["Groups found:"] = "找到隊伍：";
_L["Create new group"] = "創建新隊伍";
_L["Close"] = "關閉";

_L["context_menu_title"] = "Handynotes 戰爭前線";
_L["context_menu_check_group_finder"] = "檢查團隊查找器";
_L["context_menu_reset_rare_counters"] = "重置稀有隊伍戰鬥";
_L["context_menu_add_tomtom"] = "在 TomTom 添加此路徑點位置";
_L["context_menu_hide_node"] = "隱藏此物件";
_L["context_menu_restore_hidden_nodes"] = "恢復全部隱藏物件";

_L["options_title"] = "戰爭前線";

_L["options_icon_settings"] = "圖示設置";
_L["options_icon_settings_desc"] = "圖示設置";
_L["options_icons_treasures"] = "寶箱圖示";
_L["options_icons_treasures_desc"] = "寶箱圖示";
_L["options_icons_rares"] = "稀有圖示";
_L["options_icons_rares_desc"] = "稀有圖示";
_L["options_icons_caves"] = "洞穴圖示";
_L["options_icons_caves_desc"] = "洞穴圖示";
_L["options_icons_pet_battles"] = "戰鬥寵物圖示";
_L["options_icons_pet_battles_desc"] = "戰鬥寵物圖示";
_L["options_scale"] = "大小";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "透明度";
_L["options_opacity_desc"] = "0 = 透明, 1 = 不透明";
_L["options_visibility_settings"] = "可見性";
_L["options_visibility_settings_desc"] = "可見性";
_L["options_toggle_treasures"] = "寶箱";
_L["options_toggle_rares"] = "稀有";
_L["options_toggle_battle_pets"] = "戰鬥寵物";
_L["options_toggle_npcs"] = "NPC";
_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用";
_L["options_toggle_alreadylooted_rares"] = "已拾取稀有";
_L["options_toggle_alreadylooted_rares_desc"] = "顯示每個稀有無論是否已拾取狀態";
_L["options_toggle_alreadylooted_treasures"] = "已拾取寶箱";
_L["options_toggle_alreadylooted_treasures_desc"] = "顯示每個寶箱無論是否已拾取狀態";
_L["options_tooltip_settings"] = "提示";
_L["options_tooltip_settings_desc"] = "提示";
_L["options_toggle_show_loot"] = "顯示拾取";
_L["options_toggle_show_loot_desc"] = "在提示上添加拾取資訊";
_L["options_toggle_show_notes"] = "顯示注釋";
_L["options_toggle_show_notes_desc"] = "當可用時在提示上添加有幫助的注釋";
_L["options_toggle_caves"] = "洞穴";

_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用設置";

_L["options_toggle_show_debug"] = "除錯";
_L["options_toggle_show_debug_desc"] = "顯示除錯資訊";

_L["options_toggle_hideKnowLoot"] = "隱藏稀有，如果全部拾取收集完畢";
_L["options_toggle_hideKnowLoot_desc"] = "當全部拾取收集完畢時隱藏全部稀有。";

_L["Shared"] = "已共用";
_L["Somewhere"] = "某處";

_L["Warfronts"] = "戰爭前線";
end