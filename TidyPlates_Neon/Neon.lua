
---------------------------------------------
-- Style Definition
---------------------------------------------
local ArtworkPath = "Interface\\Addons\\TidyPlates_Neon\\"
--local font = "Interface\\Addons\\TidyPlatesHub\\shared\\AccidentalPresidency.ttf"; local fontsize = 12;
local font = "Interface\\Addons\\TidyPlatesHub\\shared\\RobotoCondensed-Bold.ttf"
local fontsize = 10
--print(font, fontsize)
--local fontsize = 12;
local EmptyTexture = "Interface\\Addons\\TidyPlatesHub\\shared\\Empty"
local VerticalAdjustment = 12
local CastBarHorizontalAdjustment = 22
local CastBarVerticalAdjustment = VerticalAdjustment - 18
local NameTextVerticalAdjustment = VerticalAdjustment - 9

-- Non-Latin Font Bypass
local NonLatinLocales = { ["koKR"] = true, ["zhCN"] = true, ["zhTW"] = true, }
if NonLatinLocales[GetLocale()] == true then font = STANDARD_TEXT_FONT end


--   /run print(TidyPlates.ActiveThemeTable["Default"].frame.y)
---------------------------------------------
-- Default Style
---------------------------------------------
local Theme = {}
local StyleDefault = {}

StyleDefault.highlight = {
	texture =					ArtworkPath.."Neon_Highlight",
}

StyleDefault.healthborder = {
	texture		 =				ArtworkPath.."Neon_HealthOverlay",
	width = 128,
	_width = 128,
	height = 32,
	y = VerticalAdjustment,
	show = true,
}

StyleDefault.healthbar = {
	texture =					 ArtworkPath.."Neon_Bar",
	backdrop =					 ArtworkPath.."Neon_Bar_Backdrop",
	width = 102,
	_width = 102,
	height = 32,
	x = 0,
	y = VerticalAdjustment,
}

StyleDefault.castborder = {
	--texture =					ArtworkPath.."Cast_Normal",
	texture =					ArtworkPath.."Neon_CastOverlay",
	width = 128,
	height = 32,
	x = CastBarHorizontalAdjustment,
	y = CastBarVerticalAdjustment,
	show = true,
}

StyleDefault.castnostop = {
	--texture =					ArtworkPath.."Cast_Shield",
	texture =					ArtworkPath.."Neon_CastOverlayNoInt",
	width = 128,
	height = 32,
	x = CastBarHorizontalAdjustment,
	y = CastBarVerticalAdjustment,
	show = true,
}


StyleDefault.castbar = {
	texture =					 ArtworkPath.."Neon_Bar",
	width = 100,
	height = 32,
	x = CastBarHorizontalAdjustment-10,
	y = CastBarVerticalAdjustment-6,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

StyleDefault.spellicon = {
	width = 16,
	height = 18,
	x = CastBarHorizontalAdjustment+48,
	y = CastBarVerticalAdjustment-.7,
	anchor = "CENTER",
	show = true,
	coords = {left = 0.15,right = .85,top = 0.15,bottom = .85}, 		-- Does nothing, at the moment
}

StyleDefault.spelltext = {
	typeface = font,
	size = fontsize,
	width = 150,
	height = 11,
	x = CastBarHorizontalAdjustment - 10,
	--NameTextVerticalAdjustment +
	y = CastBarVerticalAdjustment - 16,
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	shadow = true,
	show = true,
}

--]]

StyleDefault.threatborder = {
	texture =				ArtworkPath.."Neon_AggroOverlayWhite",
	width = 256,
	_width = 256,
	height = 64,
	y = VerticalAdjustment + 1,
	x = 0,
	show = true,
}


StyleDefault.target = {
	texture = "Interface\\Addons\\TidyPlates_Neon\\Neon_Select",
	width = 128,
	_width = 128,
	height = 32,
	x = 0,
	y = VerticalAdjustment,
	anchor = "CENTER",
	show = true,
}

StyleDefault.raidicon = {
	width = 22,
	height = 22,
	x = -64,
	y = VerticalAdjustment - 3,
	anchor = "CENTER",
	texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
	show = true,
}

-- [[
StyleDefault.eliteicon = {
	texture = ArtworkPath.."Neon_EliteStar",
	width = 13,
	height = 13,
	x = -44,
	y = VerticalAdjustment + 6,
	anchor = "CENTER",
	show = true,
}
--]]

--[[
StyleDefault.eliteicon = {
	texture = ArtworkPath.."Neon_EliteIcon",
	width = 17,
	height = 17,
	x = -40,
	y = VerticalAdjustment + 6,
	anchor = "CENTER",
	show = true,
}
--]]

--[[
StyleDefault.eliteicon = {
	texture		 =				ArtworkPath.."Neon_HealthOverlayElite",
	width = 128,
	height = 32,
	y = VerticalAdjustment,
	show = true,
	anchor = "CENTER",
}
--]]

StyleDefault.skullicon = {
	texture = ArtworkPath.."Skull_Icon_White",
	width = 13,
	height = 13,
	x = -32,
	y = VerticalAdjustment + 5.5,
	anchor = "CENTER",
	show = true,
}


StyleDefault.name = {
	typeface = font,
	size = fontsize,
	width = 200,
	height = 11,
	x = 0,
	y = NameTextVerticalAdjustment,
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	shadow = true,
	flags = "NONE",
}
--[[
StyleDefault.level = {
	typeface = font,
	size = fontsize,
	width = 40,
	height = 11,
	--x = 5,		-- for Star
	x = 12,		-- For Echelon
	--y = VerticalAdjustment + 5,		-- For star
	y = VerticalAdjustment + 6,		-- For echelon
	align = "LEFT",
	anchor = "LEFT",
	vertical = "TOP",
	flags = "OUTLINE",
	shadow = false,
	show = false,
}
--]]

StyleDefault.level = {
	typeface = font,
	size = fontsize,
	width = 40,
	height = 12,
	--x = 5,		-- for Star
	x = -18,		-- For Echelon
	--y = VerticalAdjustment + 5,		-- For star
	y = VerticalAdjustment + 4,		-- For echelon
	align = "LEFT",
	anchor = "CENTER",
	vertical = "TOP",
	flags = "OUTLINE",
	shadow = false,
	show = false,
}


StyleDefault.customart = {
	width = 14,
	height = 14,
	x = -44,
	y = VerticalAdjustment + 5,
	anchor = "CENTER",
	--show = true,
}

StyleDefault.customtext = {
	typeface = font,
	size = 11,
	width = 150,
	height = 11,
	x = 0,
	y = VerticalAdjustment + 1,
	align = "CENTER",
	anchor = "CENTER",
	vertical = "CENTER",
	shadow = false,
	flags = "OUTLINE",
	show = true,
}

StyleDefault.frame = {
	y = 0,
}

local CopyTable = TidyPlatesUtility.copyTable

-- No Bar
local StyleTextOnly = CopyTable(StyleDefault)
StyleTextOnly.threatborder.texture = EmptyTexture

-- Just testing
--[[
StyleTextOnly.threatborder.texture = ArtworkPath.."WarningGlowCircle"
StyleTextOnly.threatborder.width = 40
StyleTextOnly.threatborder.height = 40
StyleTextOnly.threatborder.y = VerticalAdjustment
--]]

--[[
StyleTextOnly.threatborder.texture = "Interface\\Addons\\TidyPlatesHub\\shared\\Aggro"
StyleTextOnly.threatborder.width = 128
StyleTextOnly.threatborder.height = 64
StyleTextOnly.threatborder.y = VerticalAdjustment -8 -16
--]]

StyleTextOnly.healthborder.y = VerticalAdjustment - 24
StyleTextOnly.healthborder.height = 64
StyleTextOnly.healthborder.texture = EmptyTexture
StyleTextOnly.healthbar.texture = EmptyTexture
StyleTextOnly.healthbar.backdrop = EmptyTexture
StyleTextOnly.eliteicon.texture = EmptyTexture
StyleTextOnly.customtext.size = fontsize - 2
StyleTextOnly.customtext.flags = "NONE"
StyleTextOnly.customtext.y = VerticalAdjustment-8
StyleTextOnly.name.size = fontsize
StyleTextOnly.name.y = VerticalAdjustment + 1
StyleTextOnly.level.show = false
StyleTextOnly.skullicon.show = false
StyleTextOnly.eliteicon.show = false
StyleTextOnly.highlight.texture = "Interface\\Addons\\TidyPlatesHub\\shared\\Highlight"
StyleTextOnly.target.texture = "Interface\\Addons\\TidyPlatesHub\\shared\\Target"
StyleTextOnly.target.height = 72
StyleTextOnly.target.y = VerticalAdjustment -8 -18

StyleTextOnly.raidicon.x = 0
StyleTextOnly.raidicon.y = VerticalAdjustment - 25


--[[
-- Styles
local DefaultNoAura = CopyTable(StyleDefault)
local TextNoAura = CopyTable(StyleTextOnly)
local TextNoDescription = CopyTable(StyleTextOnly)

DefaultNoAura.raidicon = {
	width = 22,
	height = 22,
	x = 0,
	y = VerticalAdjustment + 20,
	anchor = "CENTER",
	texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
	show = true,
}

TextNoAura.raidicon = DefaultNoAura.raidicon

TextNoDescription.target.height = 55
TextNoDescription.target.y = VerticalAdjustment - 17
TextNoDescription.raidicon.x = 0
TextNoDescription.raidicon.y = VerticalAdjustment - 22

--]]

-- Active Styles
Theme["Default"] = StyleDefault
Theme["NameOnly"] = StyleTextOnly

--[[
Theme["Default-NoAura"] = DefaultNoAura

Theme["NameOnly-NoAura"] = TextNoAura
Theme["NameOnly-NoDescription"] = TextNoDescription
--]]

-- Widget
local WidgetConfig = {}
WidgetConfig.ClassIcon = { anchor = "TOP" , x = 30 ,y = VerticalAdjustment -1 }
WidgetConfig.TotemIcon = { anchor = "TOP" , x = 0 ,y = VerticalAdjustment + 2 }
WidgetConfig.ThreatLineWidget = { anchor =  "CENTER", x = 0 ,y = VerticalAdjustment + 4 }
WidgetConfig.ThreatWheelWidget = { anchor =  "CENTER", x = 36 ,y = VerticalAdjustment + 12 } -- "CENTER", plate, 30, 18
WidgetConfig.ComboWidget = { anchor = "CENTER" , x = 0 ,y = VerticalAdjustment + 9.5 }
WidgetConfig.RangeWidget = { anchor = "CENTER" , x = 0 ,y = VerticalAdjustment + 0 }
WidgetConfig.DebuffWidget = { anchor = "CENTER" , x = 15 ,y = VerticalAdjustment + 17 }
--if (UnitClassBase("player") == "Druid") or (UnitClassBase("player") == "Rogue") then
	WidgetConfig.DebuffWidgetPlus = { anchor = "CENTER" , x = 15 ,y = VerticalAdjustment + 24 }
--end

WidgetConfig._meta = true		-- tells the parser to ignore this table; ie. don't convert to "style" template
Theme.WidgetConfig = WidgetConfig
local ThemeName = "Neon"

---------------------------------------------
-- Tidy Plates Hub Integration
---------------------------------------------
TidyPlatesThemeList[ThemeName] = Theme
TidyPlatesHubFunctions.ApplyHubFunctions(Theme)





