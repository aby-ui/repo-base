--stat category in short
--RATING_SUMMARY_MELEE_CRIT = "M.CR:"
--RATING_SUMMARY_SPELL_CRIT = "S.CR:"
--RATING_SUMMARY_MANA_REGEN = "MP/5:"
--RATING_SUMMARY_STA_NO_BONUS = "NO TALENT BONUS"
RATING_SUMMARY_GEM = "Gem"
RATING_SUMMARY_ENCHANT = _G["ENCHANTS"]
RATING_SUMMARY_EXTRA_SOCKET = "Extra Socket"
--RATING_SUMMARY_TINKER = "Tinker"
RS_STATS_ONLY_FROM_GEARS = "Stats: (Gears Only)"
RATING_SUMMARY_ITEM_LEVEL_TITLE = _G["STAT_AVERAGE_ITEM_LEVEL"]
RATING_SUMMARY_ITEM_LIST_TITLE = "Item List"
RATING_SUMMARY_ITEM_LEVEL_SHORT = "ilv"
RATING_SUMMARY_ITEM_LEVEL_FORMAT = "%2d * %3d lvl"
RATING_SUMMARY_ITEM_SUIT = "Suit:"
RATING_SUMMARY_ITEM_SUIT_FORMAT = '.+%s%(%d%/%d%)';
RATING_SUMMARY_ITEM_QUANLITY_NAME = {
	[7] = _G["ITEM_QUALITY7_DESC"],
	[6] = _G["ITEM_QUALITY6_DESC"],
	[5] = _G["ITEM_QUALITY5_DESC"],
	[4] = _G["ITEM_QUALITY4_DESC"],
	[3] = _G["ITEM_QUALITY3_DESC"],
	[2] = _G["ITEM_QUALITY2_DESC"],
}

RATING_SUMMARY_ENCHANTABLES = {
	--	[INVSLOT_BACK] = "Back ",
	--	[INVSLOT_CHEST] = "Chest ",
	--	[INVSLOT_FEET] = "Feet ",
	--	[INVSLOT_HAND] = "Hands ",
	--	[INVSLOT_LEGS] = "Legs ",
	--	[INVSLOT_NECK] = "Neck",
		[INVSLOT_MAINHAND] = "MainHand",
	--	[INVSLOT_OFFHAND] = "OffHand",
	--	[INVSLOT_WRIST] = "Wrist ",
		--HeadSlot = "Head ",
	--	[INVSLOT_SHOULDER] = "Shoulder",
		[INVSLOT_FINGER1] = "Finger1 ",
		[INVSLOT_FINGER2] = "Finger2 ",
}
RATING_SUMMARY_BLACKSMITH = {
	--	[INVSLOT_WAIST] = "Waist ",
	--	[INVSLOT_WRIST] = "Wrist ",
	--	[INVSLOT_HAND] = "Hands ",
}
-- RATING_SUMMARY_ENGINEERING = {
		-- [INVSLOT_WAIST] = "Waist ",
		-- [INVSLOT_BACK] = "Back ",
		-- [INVSLOT_HAND] = "Hands",
-- }
if(GetLocale()=="zhTW") then
	--RATING_SUMMARY_ANNOUNCE = "|cffFFCC66RatingSummary|r-裝備屬性統計,|cffFFCC66Warbaby|r@|cffFF00FF聖光之願<冰封十字軍>|r"
	--stat category in short
	--RATING_SUMMARY_MELEE_CRIT = "物理致命:"
	--RATING_SUMMARY_SPELL_CRIT = "法術致命:"
	--RATING_SUMMARY_MANA_REGEN = "回蓝:"

	--RATING_SUMMARY_ITEM_LEVEL_TITLE = "裝備等級"
	RATING_SUMMARY_ITEM_LIST_TITLE = "裝備列表"
	RATING_SUMMARY_ITEM_LEVEL_SHORT = "裝等"
	RATING_SUMMARY_ITEM_LEVEL_FORMAT = "%2d 件 %3d 級"
	RS_STATS_ONLY_FROM_GEARS = "屬性合計:（僅供參考）"
	--RATING_SUMMARY_STA_NO_BONUS = "無天賦加成"
	RATING_SUMMARY_GEM = "寶石"
	RATING_SUMMARY_EXTRA_SOCKET = "插槽"
	RATING_SUMMARY_ITEM_SUIT = "套裝:"
	RATING_SUMMARY_ITEM_SUIT_FORMAT = '.+%(%d/%d%)';
	-- RATING_SUMMARY_TINKER = "修補"
	RATING_SUMMARY_ENCHANTABLES = {
	--	[INVSLOT_BACK] = "披",
	--	[INVSLOT_CHEST] = "胸",
	--	[INVSLOT_FEET] = "腳",
	--	[INVSLOT_HAND] = "手",
	--	[INVSLOT_LEGS] = "腿",
	--	[INVSLOT_NECK] = "頸",
        [INVSLOT_MAINHAND] = "武",
	--	[INVSLOT_OFFHAND] = "副",
	--	[INVSLOT_WRIST] = "腕",
	--  HeadSlot = "頭",
	--	[INVSLOT_SHOULDER] = "肩",

		[INVSLOT_FINGER1] = "戒",
		[INVSLOT_FINGER2] = "戒",
	}
	RATING_SUMMARY_BLACKSMITH = {
	--	[INVSLOT_WAIST] = "腰",
	--	[INVSLOT_WRIST] = "腕",
	--	[INVSLOT_HAND] = "手",
	}
	-- RATING_SUMMARY_ENGINEERING = {
		-- [INVSLOT_WAIST] = "腰",
		-- [INVSLOT_BACK] = "披",
		-- [INVSLOT_HAND] = "手",
	-- }
elseif(GetLocale()=="zhCN") then
	--RATING_SUMMARY_ANNOUNCE = "|cffFFCC66RatingSummary|r-裝備屬性統計,|cffFFCC66Warbaby|r@|cffFF00FF聖光之願<冰封十字軍>|r"
	--stat category in short
	--RATING_SUMMARY_MELEE_CRIT = "物爆:"
	--RATING_SUMMARY_SPELL_CRIT = "法爆:"
	--RATING_SUMMARY_MANA_REGEN = "回蓝:"
    RS_STATS_ONLY_FROM_GEARS = "属性合计:（仅供参考）"
	--RATING_SUMMARY_STA_NO_BONUS = "无天赋加成"
	--RATING_SUMMARY_ITEM_LEVEL_TITLE = "装备等级"
	RATING_SUMMARY_ITEM_LIST_TITLE = "装备列表"
	RATING_SUMMARY_ITEM_LEVEL_SHORT = "装等"
	RATING_SUMMARY_ITEM_LEVEL_FORMAT = "%2d 件 %3d 级"
	RATING_SUMMARY_GEM = "宝石"
	RATING_SUMMARY_EXTRA_SOCKET = "插槽"
	RATING_SUMMARY_ITEM_SUIT = "套装:"
	RATING_SUMMARY_ITEM_SUIT_FORMAT = '.+%（%d%/%d%）';
	-- RATING_SUMMARY_TINKER = "修补"
	RATING_SUMMARY_ENCHANTABLES = {
	--	[INVSLOT_BACK] = "披",
	--	[INVSLOT_CHEST] = "胸",
	--	[INVSLOT_FEET] = "脚",
	--	[INVSLOT_HAND] = "手",
	--	[INVSLOT_LEGS] = "腿",
	--	[INVSLOT_NECK] = "颈",
		[INVSLOT_MAINHAND] = "武",
	--	[INVSLOT_OFFHAND] = "副",
	--	[INVSLOT_WRIST] = "腕",
	--  HeadSlot = "头",
	--	[INVSLOT_SHOULDER] = "肩",
		[INVSLOT_FINGER1] = "戒",
		[INVSLOT_FINGER2] = "戒",
	}
	RATING_SUMMARY_BLACKSMITH = {
	--	[INVSLOT_WAIST] = "腰",
	--	[INVSLOT_WRIST] = "腕",
	--	[INVSLOT_HAND] = "手",
	}
	-- RATING_SUMMARY_ENGINEERING = {
		-- [INVSLOT_WAIST] = "腰",
		-- [INVSLOT_BACK] = "披",
		-- [INVSLOT_HAND] = "手",
	-- }
else
	
end