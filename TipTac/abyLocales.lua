--[[------------------------------------------------------------
zhCN locale by AbyUI
---------------------------------------------------------------]]
local name, private = ...
local L = CoreBuildLocale()
private.L = L

if GetLocale() == "zhCN" then
    L["Not specified"] = "未指定";
    L["Tapped"] = "已被接触";
    L["TipTacAnchor"] = "TipTac锚点";
    L["Could not open TicTac Options: |1"] = "无法打开 TicTac 选项: |1";
    L["|r. Please make sure the addon is enabled from the character selection screen."] = "|r. 请确定插件已在角色选择界面启动.";
    L["All |2"] = "全部 |2"
    L["|r settings has been reset to their default values."] = "|r 设置已被重置为默认值。"
    L[" |2reset|r = Resets all settings back to their default values"] = " |2reset|r = 重置所有设置为默认值"
    L["The following |2parameters|r are valid for this addon:"] = "以下 |2指令|r 可用于此插件:";
    L[" |2anchor|r = Shows the anchor where the tooltip appears"] = " |2anchor|r = 显示提示信息出现的锚点";
    L[" <DC>"] = " <离线>";
    L[" <AFK>"] = " <暂离>";
    L[" <DND>"] = " <请勿打扰>";
    L["Targeting"] = "目标";
    L["Targeted By (|cffffffff%d|r): %s"] = "被以下选中 (|cffffffff%d|r): %s";
    L["%.1fWan"] = "%.1f万";
    L["%.2fYi"] = "%.2f亿";

elseif GetLocale() == "zhTW" then
    L["Not specified"] = "未指定";
    L["Tapped"] = "已被接觸";
    L["TipTacAnchor"] = "TipTac錨點";
    L["Could not open TicTac Options: |1"] = "無法打開 TicTac 選項: |1";
    L["|r. Please make sure the addon is enabled from the character selection screen."] = "|r. 請確定插件已在角色選擇界面啓動.";
    L["All |2"] = "全部 |2"
    L["|r settings has been reset to their default values."] = "|r 設置已被重置為缺省值。"
    L[" |2reset|r = Resets all settings back to their default values"] = " |2reset|r = 重置所有設置為缺省值"
    L["The following |2parameters|r are valid for this addon:"] = "以下 |2指令|r 可用于此插件:";
    L[" |2anchor|r = Shows the anchor where the tooltip appears"] = " |2anchor|r = 顯示提示訊息出現的錨點";
    L[" <DC>"] = " <離線>";
    L[" <AFK>"] = " <暫離>";
    L[" <DND>"] = " <請勿打擾>";
    L["Targeting"] = "目標";
    L["Targeted By (|cffffffff%d|r): %s"] = "被以下選中 (|cffffffff%d|r): %s";
    L["%.1fWan"] = "%.1f萬";
    L["%.2fYi"] = "%.2f億";

end
