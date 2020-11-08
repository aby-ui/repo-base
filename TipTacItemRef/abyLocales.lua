--[[------------------------------------------------------------
zhCN locale by AbyUI
---------------------------------------------------------------]]
local name, private = ...
local L = CoreBuildLocale()
private.L = L

if GetLocale() == "zhCN" then
    L["|cFFFFFFFFTarget|r"] = "|cFFFFFFFF目标|r";
    L["|cFFFFFFFFYour Group|r"] = "|cFFFFFFFF本队|r";
    L["(Group %s)"] = "(%s队)";
    L["(Group %s:%s)"] = "(%s队:%s)";
    L["SpellID: %d"] = "法术ID：%d";
    L["Cast By: %s"] = "施放自：%s";
    L["Caster: %s"] = "施法者：%s";
    L["ItemLevel: %d"] = "物品等级：%d";
    L["ItemLevel: %d, ItemID: %d"] = "物品等级：%d, 物品ID：%d";
    L["CurrentLevel: %d, Upgrade: %s"] = "当前等级：%d, 升级情况：%s";
    L["SpellID: "] = "法术ID：";
    L["QuestLevel: %d, QuestID: %d"] = "任务等级：%d, 任务ID：%d";
    L["CurrencyID: %d"] = "货币ID：%d";
    L["Achievement Criteria |cff00ff00%d|r / |cffffffff%d|r"] = "成就目标 |cff00ff00%d|r / |cffffffff%d|r";
    L["AchievementID: %d, CategoryID: %d"] = "成就ID：%d, 分类ID：%d";
    L["ItemID: %d"] = "物品ID：%d";
    L["Stack: %d"] = "堆叠：%d";
elseif GetLocale() == "zhTW" then
    L["|cFFFFFFFFTarget|r"] = "|cFFFFFFFF目標|r";
    L["|cFFFFFFFFYour Group|r"] = "|cFFFFFFFF本隊|r";
    L["(Group %s)"] = "(%s隊)";
    L["(Group %s:%s)"] = "(%s隊:%s)";
    L["SpellID: %d"] = "法術ID: %d";
    L["Cast By: %s"] = "施放自: %s";
    L["Caster: %s"] = "施法者: %s";
    L["ItemLevel: %d"] = "物品等級: %d";
    L["ItemLevel: %d, ItemID: %d"] = "物品等級: %d, 物品ID: %d";
    L["CurrentLevel: %d, Upgrade: %s"] = "當前等級: %d, 提升等级: %s";
    L["SpellID: "] = "法術ID: ";
    L["QuestLevel: %d, QuestID: %d"] = "任務等級: %d, 任務ID: %d";
    L["CurrencyID: %d"] = "貨幣ID: %d";
    L["Achievement Criteria |cff00ff00%d|r / |cffffffff%d|r"] = "成就目標 |cff00ff00%d|r / |cffffffff%d|r";
    L["AchievementID: %d, CategoryID: %d"] = "成就ID: %d, 分類ID: %d";
    L["ItemID: %d"] = "物品ID: %d";
    L["Stack: %d"] = "堆疊: %d";
end
