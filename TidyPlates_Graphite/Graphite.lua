-----------------------------------------------------
-- Theme Definition
-----------------------------------------------------
local Theme = {}
local ThemeName = "Graphite"
local CopyTable = TidyPlatesUtility.copyTable
local EmptyTexture = "Interface\\Addons\\TidyPlatesHub\\shared\\Empty"
local path = "Interface\\Addons\\TidyPlates_Graphite\\"
--local font = "Interface\\Addons\\TidyPlatesHub\\shared\\AccidentalPresidency.ttf"
local font = "Interface\\Addons\\TidyPlatesHub\\shared\\RobotoCondensed-Bold.ttf"
--local fontsize = 12;

-- Non-Latin Font Bypass
local NonLatinLocales = { ["koKR"] = true, ["zhCN"] = true, ["zhTW"] = true, }
if NonLatinLocales[GetLocale()] == true then font = STANDARD_TEXT_FONT end


local castoffset = 1

local artwidth = 90
local barwidth = 90
local borderheight = 16
local barheight = 16
local widthfactor = 1 -- .85
local heightfactor = 1

local StyleDefault = {}

StyleDefault.hitbox = {
	width = 100,
	height = 35,
}

StyleDefault.frame = {
	--width = 100,
	--height = 45,
	x = 0,
	y = 0,		-- (-12) To put the bar near the middle
	anchor = "CENTER",
}

StyleDefault.healthbar = {
	texture 				= path.."StatusBar",
	width = barwidth*widthfactor,
	--width = 96*widthfactor,
	height = barheight*heightfactor,
	x = 0,
	y = 0,
}

StyleDefault.healthborder = {
	texture	= path.."HealthBorder",
	width = artwidth*widthfactor,
	height = borderheight*heightfactor,
	x = 0,
	y = 0,
}

StyleDefault.target = {
	texture 			= path.."Target",
	width = 128,
	height = 36,
	x = 0,
	y = -4,
	anchor = "CENTER",
	show = true,
}

StyleDefault.highlight = {
	texture 			= path.."Mouseover",
}

StyleDefault.threatborder = {
	texture = path.."ThreatBorderSingleDot",
	--texture = path.."ThreatBorderDoubleDot",
	--texture = EmptyTexture,
	width = artwidth*widthfactor*2,
	height = borderheight*heightfactor*2,
	x = 0,
	y = 0,
	anchor = "CENTER",
	show = true
}

StyleDefault.castbar = {
	texture 				= path.."StatusBar",
	width = barwidth*widthfactor,
	height = barheight*heightfactor,
	anchor = "CENTER",
	x = 0,
	y = -6+castoffset,
}

StyleDefault.castborder = {
	texture	= path.."HealthBorder",
	width = artwidth*widthfactor,
	height = borderheight*heightfactor,
	anchor = "CENTER",
	x = 0,
	y = -6+castoffset,
}

StyleDefault.castnostop = {
	texture	= path.."HealthBorder",
	width = artwidth*widthfactor,
	height = borderheight*heightfactor,
	anchor = "CENTER",
	x = 0,
	y = -6+castoffset,
}

StyleDefault.name = {
	typeface =					font,
	size = 10,
	width = 175,
	height = 14,
	x = 0,
	y = 7,	-- For OVER the bar
	--y = -7,		-- For UNDER the bar
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	flags = "NONE",
	shadow = true,
	show = true,
}

StyleDefault.level = {
	typeface =					font,
	show = false,
}



StyleDefault.customtext = {
	typeface =					font,
	size = 10,
	width = 175,
	height = 14,
	x = 0,
	y = -1,	-- For OVER the bar
	--y = -7,		-- For UNDER the bar
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	--flags = "",
	shadow = true,
	show = true,
}

StyleDefault.spelltext = {
	typeface =					font,
	size = 10,
	width = 175,
	height = 14,
	x = 0,
	y = -16+castoffset,		-- For UNDER the bar
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	--flags = "",
	shadow = false,
	show = true,
}

StyleDefault.spellicon = {
	height = 12,
	width = 12,
	x = -38,
	y = -4,
	show = false,
}

StyleDefault.eliteicon = {
	show = false,
	texture = EmptyTexture,

	--texture 				= path.."EliteBorder",
	width = barwidth*widthfactor,
	--width = 96*widthfactor,
	height = barheight*heightfactor,
	x = 0,
	y = 0,
	show=false,
}

StyleDefault.raidicon = {
	width = 12,
	height = 12,
	x = 0,
	y = 12,
	anchor = "CENTER",
}

StyleDefault.skullicon = {
	show = false,
}

StyleDefault.threatcolor = {
	LOW = {r = .6, g = 1, b = 0, a = 0,},
	MEDIUM = {r = .6, g = 1, b = 0, a = 1,},
	HIGH = {r = 1, g = 0, b = 0, a= 1,},  }


-- No-Bar Style		(6.2)
local StyleTextOnly = CopyTable(StyleDefault)
StyleTextOnly.threatborder.texture = EmptyTexture
StyleTextOnly.healthborder.texture = EmptyTexture
StyleTextOnly.healthborder.height = 64
StyleTextOnly.healthborder.y = -18
StyleTextOnly.healthbar.texture = EmptyTexture
StyleTextOnly.healthbar.backdrop = EmptyTexture
StyleTextOnly.eliteicon.texture = EmptyTexture
StyleTextOnly.customtext.align = "CENTER"
StyleTextOnly.customtext.size = 9
StyleTextOnly.customtext.y = -2
StyleTextOnly.level.show = false
StyleTextOnly.skullicon.show = false
StyleTextOnly.eliteicon.show = false
StyleTextOnly.highlight.texture = "Interface\\Addons\\TidyPlatesHub\\shared\\Highlight"

-- Active Styles
Theme["Default"] = StyleDefault
Theme["NameOnly"] = StyleTextOnly

local WidgetConfig = {}
WidgetConfig.ClassIcon = { anchor = "TOP" , x = 0,y = 26 }		-- Above Name
WidgetConfig.TotemIcon = { anchor = "TOP" , x = 0 ,y = 26 }
WidgetConfig.ThreatLineWidget = { anchor =  "TOP", x = 0 ,y = 0 }	-- y = 20
--WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 33 ,y = 12 } -- "CENTER", plate, 30, 18
WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 0 ,y = 16 } -- "CENTER", plate, 30, 18
WidgetConfig.ComboWidget = { anchor = "CENTER" , x = 0 ,y = 19 }
WidgetConfig.RangeWidget = { anchor = "CENTER" , x = 0 ,y = 12 }
WidgetConfig.DebuffWidget = { anchor = "TOP" , x = 15 ,y = 18 }
if (UnitClassBase("player") == "Druid") or (UnitClassBase("player") == "Rogue") then
	WidgetConfig.DebuffWidgetPlus = { anchor = "TOP" , x = 15 ,y = 26.5 }
end

WidgetConfig._meta = true		-- tells the parser to ignore this table; ie. don't convert to "style" template
Theme.WidgetConfig = WidgetConfig
local ThemeName = "Graphite"

---------------------------------------------
-- Tidy Plates Hub Integration
---------------------------------------------
TidyPlatesThemeList[ThemeName] = Theme
TidyPlatesHubFunctions.ApplyHubFunctions(Theme)
