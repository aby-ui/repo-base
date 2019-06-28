local _, addon = ...
local L = CoreBuildLocale()
addon.L = L

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L["AzeriteTooltip"] = "装备特质显示"
    L["Replace Blizzard Azerite Text"] = "移除暴雪默认的特质说明"
    L["Show traits for your current specialization only"] = "仅显示当前专精适用的特质"
    L["Show selected traits in Character Frame"] = "在角色面板的装备栏上显示特质图标"
    L["Show selected traits in Bags"] = "背包里的装备上显示特质图标"
    L["Compact Mode (only icons)"] = "简洁模式（仅显示图标）"
    L["Level %d"] = "%d级解锁 "
    L[" Level %d"] = "%d级解锁的特质"
    L["Requesting description ..."] = "数据获取中..."
end