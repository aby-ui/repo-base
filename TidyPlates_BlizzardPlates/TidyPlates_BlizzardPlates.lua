-------------------------------------------------------------------------------
-- Tidy Plates: BlizzardPlates 1.5b (7.1) - Dic/01/2016
-------------------------------------------------------------------------------

local path = "Interface\\Addons\\TidyPlates_BlizzardPlates\\media\\"
local font = STANDARD_TEXT_FONT
local VerticalAdjustment = 12

local vert = -20

local NonLatinLocales = { ["koKR"] = true, ["zhCN"] = true, ["zhTW"] = true, ["ruRU"] = true, }
if NonLatinLocales[GetLocale()] == true then font = STANDARD_TEXT_FONT end


local Theme = {}
local StyleDefault = {}

StyleDefault.highlight = {
	texture = 					"Interface\\Tooltips\\Nameplate-Glow",
}

StyleDefault.target = {
}

StyleDefault.healthborder = {
	texture		 =				path.."Nameplate-Border",
	width = 128,
	height = 32,
	anchor = "CENTER",
	y = 8,
	show = true,
}

StyleDefault.healthbar = {
	texture =					"Interface\\TARGETINGFRAME\\UI-StatusBar",
	backdrop = 					path.."backdrop",
	height = 9.5,
	width = 103,
	x = -9,
	y = 0,
	orientation = "HORIZONTAL",
}

StyleDefault.eliteicon = {
	texture = 					path.."EliteNameplateIcon",
	width = 64,
	height = 32,
	x = 48,
	y = -3, 
	anchor = "RIGHT",
}

StyleDefault.threatborder = {
	texture =					"Interface\\TargetingFrame\\UI-TargetingFrame-Flash",
	width = 140,
	height = 32,
	x = 0,
	y = -2,
	left = 0,
	right = .555,
	top = .53,
	bottom = .6,
	show = true,
}

StyleDefault.castborder = {
	texture =					"Interface\\Tooltips\\Nameplate-CastBar",
	width = 128,
	height = 32,
	x = 0,
	y = vert,
	show = true,
}

StyleDefault.castnostop = {
	texture = 					"Interface\\Tooltips\\Nameplate-CastBar-Shield",
	width = 128,
	height = 32,
	x = 0,
	y = vert,
	show = true,
}

StyleDefault.name = {
	typeface =	font,
	size = 10,
	width = 200,
	height = 16,
	y = 20,
	align = "CENTER",
	anchor = "CENTER",
	vertical = "BOTTOM",
	flags = "NONE",
	shadow = true,
}

StyleDefault.level = {
	typeface =					font,
	size = 8.5,
	x = 11.5,
	y = 1.5,
	width = 20,
	align = "CENTER",
	anchor = "RIGHT",
	shadow = true,
	flags = "NONE",
}

StyleDefault.castbar = {
	texture =					"Interface\\TARGETINGFRAME\\UI-StatusBar",
	backdrop = 					EMPTY_TEXTURE,
	height = 10,
	width = 104,
	x = 9, 
	y = vert,
	show = true,
}

StyleDefault.spellicon = {
	width = 14,
	height = 13,
	x = -8.5,
	y = vert,
	anchor = "LEFT",
}

StyleDefault.spelltext = {
	typeface =					font,
	size = 7,
	x = 5,
	y = vert+2,
	width = 140,
	align = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

StyleDefault.skullicon = {
	texture =					"Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull",
	width = 13,
	height = 12,
	x = 8.5,
	y = 0.5,
	anchor = "RIGHT",
}

StyleDefault.customtext = {
	typeface =					font,
	width = 90,
	x = -3,
	y = 1.5,
	align = "CENTER",
	shadow = false,
	show = true,
}

StyleDefault.frame = {
	width = 101,
	height = 45,
	x = 0,
	y = 0,
	anchor = "CENTER",
}

StyleDefault.raidicon = {
	width = 14,
	height = 14,
	x = -70,
	y = 30,
	anchor = "CENTER",
}

local CopyTable = TidyPlatesUtility.copyTable

-- No Bar
local StyleTextOnly = CopyTable(StyleDefault)

StyleTextOnly.threatborder.texture = EmptyTexture
StyleTextOnly.healthborder.texture = EmptyTexture
StyleTextOnly.healthbar.texture = EmptyTexture
StyleTextOnly.healthbar.backdrop = EmptyTexture
StyleTextOnly.eliteicon.texture = EmptyTexture
StyleTextOnly.name.align = "CENTER"
StyleTextOnly.name.anchor = "CENTER"
StyleTextOnly.name.size = 12
StyleTextOnly.name.y = 17
StyleTextOnly.customtext.show = true
StyleTextOnly.customtext.align = "CENTER"
StyleTextOnly.customtext.anchor = "CENTER"
StyleTextOnly.customtext.vertical = "BOTTOM"
StyleTextOnly.customtext.size = 11
StyleTextOnly.customtext.width = 500
StyleTextOnly.customtext.x = 0
StyleTextOnly.customtext.y = 0
StyleTextOnly.level.show = false
StyleTextOnly.raidicon.x = -66
StyleTextOnly.raidicon.y = 15
StyleTextOnly.raidicon.height = 14
StyleTextOnly.raidicon.width = 14
StyleTextOnly.raidicon.anchor = "TOP"
StyleTextOnly.highlight.texture = EmptyTexture


Theme["Default"] = StyleDefault
Theme["NameOnly"] = StyleTextOnly


local WidgetConfig = {}
WidgetConfig.ClassIcon =			{ anchor = "RIGHT", x = 40, y = -1 }
WidgetConfig.TotemIcon =			{ anchor = "RIGHT", x = 25, y = -1 }
WidgetConfig.ThreatLineWidget =		{ anchor="CENTER", x = 0 , y = 7 }
WidgetConfig.ThreatWheelWidget =	{ anchor =  "CENTER", x = 36 ,y = 12 }
WidgetConfig.ComboWidget =			{ anchor = "CENTER", x = 0, y = -10 }
WidgetConfig.RangeWidget =			{ anchor="BOTTOM", x = 0, y = 0 }
WidgetConfig.DebuffWidget =			{ anchor = "TOP", x = 12, y = 26 }
--if (UnitClassBase("player") == "Druid") or (UnitClassBase("player") == "Rogue") then
	WidgetConfig.DebuffWidgetPlus = { anchor="TOP", x = 12 , y = 26 }
--end

WidgetConfig._meta = true		-- tells the parser to ignore this table; ie. don't convert to "style" template
Theme.WidgetConfig = WidgetConfig
local ThemeName = "Blizzard"

---------------------------------------------
-- Tidy Plates Hub Integration
---------------------------------------------
TidyPlatesThemeList[ThemeName] = Theme
TidyPlatesHubFunctions.ApplyHubFunctions(Theme)