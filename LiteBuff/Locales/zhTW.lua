------------------------------------------------------------
-- zhTW.lua
--
-- Abin
-- 2010/10/3
------------------------------------------------------------

if GetLocale() ~= "zhTW" then return end
BINDING_HEADER_LITEBUFF_MOUNT = "智能坐騎快速鍵";
BINDING_NAME_LITEBUFF_MOUNT_NORMAL = "智能坐騎";
BINDING_NAME_LITEBUFF_MOUNT_PASSENGER = "載客坐騎";
BINDING_NAME_LITEBUFF_MOUNT_SURFACE = "水面坐騎";
BINDING_NAME_LITEBUFF_MOUNT_VENDOR = "修理坐騎";
BINDING_NAME_LITEBUFF_MOUNT_UNDERWATER = "水下坐騎";
BINDING_NAME_LITEBUFF_MOUNT_NOFLY = "地面坐騎";

local _, addon = ...
addon.L = {
	["lock frames"] = "鎖定框體",
	["simple tooltip"] = "使用簡短提示標籤",
	["scale"] = "框體縮放",
	["button spacing"] = "按鈕間距",
	["all have"] = "全有",
	["none has"] = "全無",
	["misses"] = "缺少(%d): ",
	["left click"] = "左鍵: ",
	["right click"] = "右鍵: ",
	["cast at player"] = "對自己施放",
	["cast at target"] = "對目標施放",
	["mouse wheel choose"] = "滑鼠滾輪: 選擇",
	["auras"] = "光環",
	["seals"] = "聖印",
	["blessings"] = "祝福",
	["flask effects"] = "藥劑效果",
	["armor spells"] = "護甲法術",
	["damage poisons"] = "傷害型毒藥",
	["utility poisons"] = "功能型毒藥",
	["drink"] = "飲用",
	["use"] = "使用",
	["spells"] = "法術",
	["presences"] = "領域",
	["stances"] = "姿態",
	["aspects"] = "守護",
	["legacies"] = "傳承法術",
	["fly protecting"] = "飛行保護中",
	["weapon"] = "武器: %s",
	["remove weapon poison"] = "清除武器上的毒藥",
	["remove weapon enchant"] = "清除武器上的增益",
	["enchants"] = "增益",
	["enchant16"] = "主手增益",
	["enchant17"] = "副手增益",
	["shields"] = "護盾",
	["subtitle"] = "LiteBuff介面設置",
	["effects"] = "效果",
	["effect"] = "效果: ",
	["talents"] = "天賦",
	["switch talents"] = "切換天賦",
	["pets"] = "寵物",
	["affected target"] = "作用目標: ",
	["totems"] = "圖騰",
	["traps"] = "陷阱",
	["alchemy flask"] = "煉金合劑",
	["mana gem"] = "法力寶石",
	["shouts"] = "怒吼",
	["general options"] = "一般選項",
	["disable buttons"] = "禁用按鈕",
	["crystal of insanity"] = "精神錯亂水晶",
    ["Lightforged Augment Rune"] = "光鑄增強符文"
}