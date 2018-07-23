local name, addon = ...
local L = CoreBuildLocale()
addon.L = L

if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
    L["Show"] = "锚点"
    L["Show/Hide anchors"] = "显示/隐藏锚点"
    L["Load"] = "读档"
    L["Load saving settings"] = "读取保存的方案"
    L["Save"] = "存档"
    L["Save settings to cache"] = "保存方案到账号"
    L["TrufiGCD"] = "技能序列提示"
    L["Default"] = "默认"
    L["Restore default settings"] = "恢复默认设置"

    L["Scrolling icons"] = "滚动图标"
    L["Enable addon"] = "启用本插件"
    L["Tooltip:"] = "鼠标提示"
    L["Enable"] = "启用"
    L["Stop icons"] = "停止滚动"
    L["Spell ID"] = "技能ID"
    L["Show tooltips when hovering the icon"] = "鼠标移到图标上时, 显示技能信息"
    L["Stop moving icons when hovering the icon"] = "鼠标移到图标上时, 暂停图标滚动"
    L["Write spell ID to the chat when hovering the icon"] = "鼠标移到图标上时, 把技能ID输出到聊天窗口"
    L["Scrolling icons"] = "图标滚动"
    L["Icon will just disappear"] = "是滚动消失还是直接消失"
    L["Enable in:"] = "启用场景: "
    L["World"] = "户外世界"
    L["Party"] = "小队副本"
    L["Raid"] = "团队副本"
    L["Arena"] = "竞技场"
    L["Battleground"] = "战场"
    L["Return to options"] = "返回设置界面"

    L["Hide"] = "隐藏"

    L["Blacklist"] = "忽略的技能"
    L["Fade"] = "消失方向"
    L["Size icons"] = "图标大小"
    L["Number of icons"] = "图标数量"
end
