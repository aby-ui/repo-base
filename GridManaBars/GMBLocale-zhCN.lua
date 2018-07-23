
do
	if GetLocale() ~= "zhCN" then return end
	local L = GridManaBarsLocale

	L["Mana"] = "法力"
	L["Mana Bar"] = "法力条"
	L["Mana Bar options."] = "法力条选项。"

	L["Size"] = "大小"
	L["Percentage of frame for mana bar"] = "法力条所占 Grid 框体的比例"
	L["Side"] = "位置"
	L["Side of frame manabar attaches to"] = "法力条所在的位置"
	L["Left"] = "左侧"
	L["Top"] = "顶部"
	L["Right"] = "右侧"
	L["Bottom"] = "底部"

	L["Colours"] = "颜色"
	L["Colours for the various powers"] = "不同种类能力条的颜色"
	L["Mana color"] = "法力颜色"
	L["Color for mana"] = "法力颜色"
	L["Energy color"] = "能量颜色"
	L["Color for energy"] = "能量颜色"
	L["Rage color"] = "怒气颜色"
	L["Color for rage"] = "怒气颜色"
	L["Runic power color"] = "符文能量颜色"
	L["Color for runic power"] = "符文能量颜色"

	L["Ignore Non-Mana"] = "忽略非法力条"
	L["Don't track power for non-mana users"] = "不显示非法力条"
	L["Ignore Pets"] = "忽略宠物"
	L["Don't track power for pets"] = "不监视宠物"
end

