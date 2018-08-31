local _, addon = ...
local L = CoreBuildLocale()
addon.L = L

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L["AzeriteTooltip"] = "装备特质显示"
    L["Show traits for your current specialization only"] = "仅显示当前专精适用的特质"
    L["Compact Mode (only icons)"] = "简洁模式（仅显示图标）"
    L["Level %d"] = "%d级解锁 "
    L[" Level %d"] = "%d级解锁的特质"
    L["Requesting description ..."] = "数据获取中..."
end