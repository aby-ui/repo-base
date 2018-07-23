------------------------------------------------------------
-- zhCN.lua
--
-- Abin
-- 2010/10/3
------------------------------------------------------------

if GetLocale() ~= "zhCN" then return end
BINDING_HEADER_LITEBUFF_MOUNT = "智能坐骑快捷键";
BINDING_NAME_LITEBUFF_MOUNT_NORMAL = "智能坐骑";
BINDING_NAME_LITEBUFF_MOUNT_PASSENGER = "载客坐骑";
BINDING_NAME_LITEBUFF_MOUNT_SURFACE = "水面坐骑";
BINDING_NAME_LITEBUFF_MOUNT_VENDOR = "修理坐骑";
BINDING_NAME_LITEBUFF_MOUNT_UNDERWATER = "水下坐骑";
BINDING_NAME_LITEBUFF_MOUNT_NOFLY = "地面坐骑";

local _, addon = ...
addon.L = {
	["lock frames"] = "锁定框体",
	["simple tooltip"] = "使用简短提示标签",
	["scale"] = "框体缩放",
	["button spacing"] = "按钮间距",
	["all have"] = "全有",
	["none has"] = "全无",
	["misses"] = "缺少(%d): ",
	["left click"] = "左键: ",
	["right click"] = "右键: ",
	["cast at player"] = "对自己施放",
	["cast at target"] = "对目标施放",
	["mouse wheel choose"] = "鼠标滚轮: 选择",
	["auras"] = "光环",
	["seals"] = "圣印",
	["blessings"] = "祝福",
	["flask effects"] = "药剂效果",
	["armor spells"] = "护甲法术",
	["damage poisons"] = "伤害型毒药",
	["utility poisons"] = "功能型毒药",
	["drink"] = "饮用",
	["use"] = "使用",
	["spells"] = "法术",
	["presences"] = "灵气",
	["stances"] = "姿态",
	["aspects"] = "守护",
	["legacies"] = "传承法术",
	["fly protecting"] = "飞行保护中",
	["weapon"] = "武器: %s",
	["remove weapon poison"] = "清除武器上的毒药",
	["remove weapon enchant"] = "清除武器上的增益",
	["enchants"] = "增益",
	["enchant16"] = "主手增益",
	["enchant17"] = "副手增益",
	["shields"] = "护盾",
	["subtitle"] = "LiteBuff界面设置",
	["effects"] = "效果",
	["effect"] = "效果: ",
	["talents"] = "天赋",
	["switch talents"] = "切换天赋",
	["pets"] = "宠物",
	["affected target"] = "作用目标: ",
	["totems"] = "图腾",
	["traps"] = "陷阱",
	["alchemy flask"] = "炼金合剂",
	["mana gem"] = "法力宝石",
	["shouts"] = "怒吼",
	["general options"] = "一般选项",
	["disable buttons"] = "禁用按钮",
	["crystal of insanity"] = "低语水晶",
    ["Lightforged Augment Rune"] = "光铸调和符文"
}