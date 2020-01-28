local _L = LibStub("AceLocale-3.0"):NewLocale("HandyNotes_WarfrontRares", "zhCN")

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
_L["Geomancer Flintdagger_cave"] = "到地占师弗林塔格的洞穴入口";
_L["Foulbelly_cave"] = "到弗尔伯利的洞穴入口";
_L["Kovork_cave"] = "到考沃克的洞穴入口";
_L["Zalas Witherbark_cave"] = "到扎拉斯·枯木的洞穴入口";
_L["Overseer Krix_cave"] = "到监工克里克斯的洞穴入口";

--
--
-- INTERFACE
--
--

_L["Alliance only"] = "仅联盟";
_L["Horde only"] = "仅部落";
_L["In cave"] = "在洞穴";

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
_L["listing_desc_rare"] = "战争前线稀有“%s”的战斗。";
_L["listing_desc_invasion"] = "战争前线 %s。";

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

_L["context_menu_title"] = "Handynotes 战争前线";
_L["context_menu_check_group_finder"] = "检查团队查找器";
_L["context_menu_reset_rare_counters"] = "重置稀有队伍战斗";
_L["context_menu_add_tomtom"] = "在 TomTom 添加此路径点位置";
_L["context_menu_hide_node"] = "隐藏此物件";
_L["context_menu_restore_hidden_nodes"] = "恢复全部隐藏物件";

_L["options_title"] = "战争前线";

_L["options_icon_settings"] = "图标设置";
_L["options_icon_settings_desc"] = "图标设置";
_L["options_icons_treasures"] = "宝箱图标";
_L["options_icons_treasures_desc"] = "宝箱图标";
_L["options_icons_rares"] = "稀有图标";
_L["options_icons_rares_desc"] = "稀有图标";
_L["options_icons_caves"] = "洞穴图标";
_L["options_icons_caves_desc"] = "洞穴图标";
_L["options_icons_pet_battles"] = "战斗宠物图标";
_L["options_icons_pet_battles_desc"] = "战斗宠物图标";
_L["options_scale"] = "大小";
_L["options_scale_desc"] = "1 = 100%";
_L["options_opacity"] = "透明度";
_L["options_opacity_desc"] = "0 = 透明, 1 = 不透明";
_L["options_visibility_settings"] = "可见性";
_L["options_visibility_settings_desc"] = "可见性";
_L["options_toggle_treasures"] = "宝箱";
_L["options_toggle_rares"] = "稀有";
_L["options_toggle_battle_pets"] = "战斗宠物";
_L["options_toggle_npcs"] = "NPC";
_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用";
_L["options_toggle_alreadylooted_rares"] = "已拾取稀有";
_L["options_toggle_alreadylooted_rares_desc"] = "显示每个稀有无论是否已拾取状态";
_L["options_toggle_alreadylooted_treasures"] = "已拾取宝箱";
_L["options_toggle_alreadylooted_treasures_desc"] = "显示每个宝箱无论是否已拾取状态";
_L["options_tooltip_settings"] = "提示";
_L["options_tooltip_settings_desc"] = "提示";
_L["options_toggle_show_loot"] = "显示拾取";
_L["options_toggle_show_loot_desc"] = "在提示上添加拾取信息";
_L["options_toggle_show_notes"] = "显示注释";
_L["options_toggle_show_notes_desc"] = "当可用时在提示上添加有帮助的注释";
_L["options_toggle_caves"] = "洞穴";

_L["options_general_settings"] = "通用";
_L["options_general_settings_desc"] = "通用设置";

_L["options_toggle_show_debug"] = "除错";
_L["options_toggle_show_debug_desc"] = "显示除错信息";

_L["options_toggle_hideKnowLoot"] = "隐藏稀有，如果全部拾取收集完毕";
_L["options_toggle_hideKnowLoot_desc"] = "当全部拾取收集完毕时隐藏全部稀有。";

_L["Shared"] = "已共享";
_L["Somewhere"] = "某处";

_L["Warfronts"] = "战争前线";
end