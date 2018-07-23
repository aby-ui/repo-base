
do
	if GetLocale() ~= "zhTW" then return end
	local L = GridManaBarsLocale

	L["Mana"] = "法力"
	L["Mana Bar"] = "法力條"
	L["Mana Bar options."] = "法力條選項。"

	L["Size"] = "大小"
	L["Percentage of frame for mana bar"] = "法力條所佔 Grid 框架的比例"
	L["Side"] = "邊緣"
	L["Side of frame manabar attaches to"] = "法力條依附的邊緣"
	L["Left"] = "左"
	L["Top"] = "上"
	L["Right"] = "右"
	L["Bottom"] = "下"

	L["Colours"] = "顏色"
	L["Colours for the various powers"] = "設定不同能力條的顏色"
	L["Mana color"] = "法力顏色"
	L["Color for mana"] = "法力顏色"
	L["Energy color"] = "能量顏色"
	L["Color for energy"] = "能量顏色"
	L["Rage color"] = "怒氣顏色"
	L["Color for rage"] = "怒氣顏色"
	L["Runic power color"] = "符能顏色"
	L["Color for runic power"] = "符能顏色"

	L["Ignore Non-Mana"] = "忽略無法力者"
	L["Don't track power for non-mana users"] = "不顯示無法力職業法力條"
	L["Ignore Pets"] = "忽略寵物"
	L["Don't track power for pets"] = "不監視寵物"
end

