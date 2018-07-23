
local addonName, TidyPlatesInternal = ...
local UseTheme = TidyPlatesInternal.UseTheme

if not TidyPlatesThemeList then TidyPlatesThemeList = {} end

-------------------------------------------------------------------------------------
-- Template
-------------------------------------------------------------------------------------

local TemplateTheme = {}
local defaultArtPath = "Interface\\Addons\\TidyPlates\\Media"
--local font =					"FONTS\\arialn.ttf"
local font =					NAMEPLATE_FONT
local EMPTY_TEXTURE = defaultArtPath.."\\Empty"

TemplateTheme.hitbox = {
	width = 160,
	height = 45,
}

TemplateTheme.highlight = {
	texture =					EMPTY_TEXTURE,
	width = 128,
	height = 64,
}

TemplateTheme.healthborder = {
	texture		 =				EMPTY_TEXTURE,
	width = 0,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = true,
	-- Texture Coordinates
	left = 0,
	right = 1,
	top = 0,
	bottom = 1,
}

TemplateTheme.eliteicon = {
	texture = EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = false,
	-- Texture Coordinates
	left = 0,
	right = 1,
	top = 0,
	bottom = 1,
}

TemplateTheme.threatborder = {
	texture =			EMPTY_TEXTURE,
	--elitetexture =			EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = true,
	-- Texture Coordinates
	left = 0,
	right = 1,
	top = 0,
	bottom = 1,
}


TemplateTheme.castborder = {
	texture =					EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -11,
	anchor = "CENTER",
	show = true,
}

TemplateTheme.castnostop = {
	texture = 				EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -11,
	anchor = "CENTER",
	show = true,
}

TemplateTheme.name = {
	typeface =					font,
	size = 9,
	width = 88,
	height = 10,
	x = 0,
	y = 1,
	align = "LEFT",
	anchor = "LEFT",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

TemplateTheme.level = {
	typeface =					font,
	size = 9,
	width = 25,
	height = 10,
	x = 36,
	y = 1,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = true,
}

TemplateTheme.healthbar = {
	texture =					 EMPTY_TEXTURE,
	backdrop = 				EMPTY_TEXTURE,
	height = 12,
	--width = 101,
	width = 0,
	x = 0,
	y = 10,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

TemplateTheme.castbar = {
	texture =					EMPTY_TEXTURE,
	backdrop = 				EMPTY_TEXTURE,
	height = 12,
	width = 99,
	x = 0,
	y = -19,
	anchor = "CENTER",
	orientation = "HORIZONTAL",
}

TemplateTheme.spelltext = {
	typeface =					font,
	size = 9,
	width = 93,
	height = 10,
	x = 0,
	y = 11,
	align = "RIGHT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = false,
}

TemplateTheme.customtext = {
	typeface =					font,
	size = 8,
	width = 100,
	height = 10,
	x = 1,
	y = -19,
	align = "LEFT",
	anchor = "CENTER",
	vertical = "BOTTOM",
	shadow = true,
	flags = "NONE",
	show = false,
}

TemplateTheme.spellicon = {
	width = 18,
	height = 18,
	x = 62,
	y = -19,
	anchor = "CENTER",
	show = true,
}

TemplateTheme.raidicon = {
	texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
	width = 20,
	height = 20,
	x = -35,
	y = 7,
	anchor = "TOP",
	show = true,
}

TemplateTheme.skullicon = {
	texture = "Interface\\TargetingFrame\\UI-TargetingFrame-Skull",
	width = 14,
	height = 14,
	x = 44,
	y = 3,
	anchor = "CENTER",
	show = true,
}

TemplateTheme.frame = {
	width = 101,
	height = 45,
	x = 0,
	y = 0,
	anchor = "CENTER",
}

TemplateTheme.target = {
	texture = EMPTY_TEXTURE,
	width = 128,
	height = 64,
	x = 0,
	y = -5,
	anchor = "CENTER",
	show = false,
}

TemplateTheme.threatcolor = {
	LOW = { r = .75, g = 1, b = 0, a= 1, },
	MEDIUM = { r = 1, g = 1, b = 0, a = 1, },
	HIGH = { r = 1, g = 0, b = 0, a = 1, },
}

-----------------------------------------------
-- References
-----------------------------------------------
TidyPlatesInternal.ThemeTemplate = TemplateTheme
UseTheme(TemplateTheme)
