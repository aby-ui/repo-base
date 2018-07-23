local _, GBS = ...

if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then return end

do
	local L = GBS.L

	L["Style"] = "边框样式美化"
	L["Choose a Style"] = "选择样式"
	L["Reload"] = "重载界面"
	L["Reload UI to Apply Style"] = "如果修改设置后存在问题，重载解决"
	L["Frame Shadow"] = "边框阴影"
	L["Turn on/off border shade"] = "阴影开关"
	L["Use class color"] = "使用职业颜色"
	L["Color manabar by class"] = "用职业颜色渲染发力条"

	L["Topleft"] = "左上"
	L["Topright"] = "右上"
	L["Bottomright"] = "右下"
	L["Bottomleft"] = "左下"
	L["Sign"] = "hokohuang @ www.ngacn.cc, 7.0 rewrite by warbaby"

    L["ManaBar Settings"] = "法力条快捷设置"

    L["ElvUI"] = "间隔"
    L["Qulight"] = "并列"
    L["OverlapStyle"] = "悬浮"
    L["LayersStyle"] = "层叠"

    L["Overlap Manabar Width %"] = "悬浮时法力条宽度比"
end