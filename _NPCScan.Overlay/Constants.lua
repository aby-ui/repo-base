-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)


-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
local FOLDER_NAME, private = ...


-------------------------------------------------------------------------------
-- General constants.
-------------------------------------------------------------------------------
private.KeyToggleIconTexture_Enabled = [[Interface\Icons\INV_Enchant_FormulaSuperior_01]]
private.KeyToggleIconTexture_Disabled = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Icons\Key_Off]]
private.PathToggleIconTexture_Enabled = [[Interface\Icons\INV_Misc_Map02]]
private.PathToggleIconTexture_Disabled = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Icons\Path_Off]]


--private.KeyFont = CreateFont("_NPCScanOverlayWorldMapKeyFont")
--private.KeyFont:SetFontObject(ChatFontNormal)
private.DEFAULT_FONT_NAME = "ChatFontNormal"
private.DEFAULT_FONT_PATH, private.DEFAULT_FONT_SIZE = ChatFontNormal:GetFont()

--http://wowprogramming.com/BlizzArt/Interface/ICONS/INV_MISC_NOTE_06.png
--http://wowprogramming.com/BlizzArt/Interface/ICONS/Ability_Hunter_MasterMarksman.png
--http://wowprogramming.com/BlizzArt/Interface/ICONS/INV_Misc_EngGizmos_20.png

private.NPCsFoundIgnored = {
	[32487] = true, -- Putridus the Ancient
	[50009] = true, -- Mobus
}

private.NPCAliases = {
	-- (Key) NPC shows (Value) NPC's path instead
	-- Note: Circular references will lock client!
	-- Madexx (Brown)
	[51401] = 50154, -- Madexx (Red)
	[51402] = 50154, -- Madexx (Green)
	[51403] = 50154, -- Madexx (Black)
	[51404] = 50154, -- Madexx (Blue)
	[79692] = 79686, -- Silverleaf Ancient
	[79693] = 79686, -- Silverleaf Ancient
	[77828] = 77795, -- Echo of Murmer
	[82676] = 82742, -- Enavra
}

private.Achievements = {
	-- Achievements whos criteria mobs are all mapped
	[1312] = true, -- Bloody Rare (Outlands)
	[2257] = true, -- Frostbitten (Northrend)
	[7317] = true, -- One Of Many
	[7439] = true, -- Glorious! (Pandaria)
	[8103] = true, -- Champions of Lei Shen
	[8714] = true, --Timeless Champion
}

--Number of Colors needed for the key
private.KeyColorTotal = 70;

--Colors used for the paths.  Need to revisit to replace the duplicated colors if possible
private.OverlayKeyColors = {
	{
		["b"] = 0.87,
		["colorStr"] = "ff0070de",
		["g"] = 0.44,
		["r"] = 0,
	}, -- [1]
	RAID_CLASS_COLORS.SHAMAN,
	UnitPopupButtons.RAID_TARGET_3.color,
	{
		["b"] = 0.7686274509803921,
		["colorStr"] = "ffc41f3b",
		["g"] = 0,
		["r"] = 0.6745098039215687,
	}, -- [2]
	{
		["b"] = 0.807843137254902,
		["g"] = 0,
		["r"] = 1,
	}, -- [3]
	RAID_CLASS_COLORS.DEATHKNIGHT,
	{
		["b"] = 0.3215686274509804,
		["colorStr"] = "ffff7d0a",
		["g"] = 0,
		["r"] = 1,
	}, -- [4]
	{
		["b"] = 0,
		["colorStr"] = "fff58cba",
		["g"] = 0.01176470588235294,
		["r"] = 0.9607843137254902,
	}, -- [5]
	RAID_CLASS_COLORS.DRUID,
	{
		["b"] = 0,
		["g"] = 0.2862745098039216,
		["r"] = 1,
	}, 
	{
		["b"] = 0,
		["g"] = 0.788235294117647,
		["r"] = 0.8745098039215686,
	},
	UnitPopupButtons.RAID_TARGET_1.color,
	{
		["b"] = 0,
		["g"] = 1,
		["r"] = 0.407843137254902,
	},
	GREEN_FONT_COLOR,
	{
		["b"] = 0.1686274509803922,
		["g"] = 0.9019607843137255,
		["r"] = 0,
	},
	{
		["a"] = 1,
		["colorStr"] = "ff00ff96",
		["r"] = 0.0196078431372549,
		["g"] = 1,
		["b"] = 0.4823529411764706,
	},
	{
		["b"] = 0.8313725490196078,
		["colorStr"] = "ffabd473",
		["g"] = 0.7529411764705882,
		["r"] = 0,
	},
	{
		["b"] = 1,
		["colorStr"] = "ff0070de",
		["g"] = 0.5176470588235294,
		["r"] = 0.3647058823529412,
	},
	{
		["b"] = 1,
		["colorStr"] = "ffc41f3b",
		["g"] = 0.4509803921568628,
		["r"] = 0.7058823529411764,
	},
	{
		["b"] = 0.8274509803921568,
		["g"] = 0.4509803921568628,
		["r"] = 1,
	},
	{
		["b"] = 0.5411764705882353,
		["colorStr"] = "ffff7d0a",
		["g"] = 0.4509803921568628,
		["r"] = 1,
	},
	{
		["b"] = 0.4431372549019608,
		["colorStr"] = "fff58cba",
		["g"] = 0.7607843137254902,
		["r"] = 1,
	},
	{
		["b"] = 0.4431372549019608,
		["g"] = 1,
		["r"] = 0.996078431372549,
	},
	{
		["b"] = 0.4431372549019608,
		["g"] = 1,
		["r"] = 0.5137254901960784,
	},
	{
		["b"] = 0.9411764705882353,
		["g"] = 1,
		["r"] = 0.4431372549019608,
	},
	{
		["b"] = 1,
		["g"] = 0.6823529411764706,
		["r"] = 0.7254901960784314,
	},
	{
		["a"] = 1,
		["colorStr"] = "ff00ff96",
		["r"] = 1,
		["g"] = 0.6509803921568628,
		["b"] = 0.9176470588235294,
	},
	{
		["b"] = 0.7098039215686275,
		["colorStr"] = "ffabd473",
		["g"] = 0.7372549019607844,
		["r"] = 1,
	},
	{
		["b"] = 0.6588235294117647,
		["colorStr"] = "ff0070de",
		["g"] = 1,
		["r"] = 0.9607843137254902,
	},
	{
		["b"] = 0.7137254901960785,
		["colorStr"] = "ffc41f3b",
		["g"] = 1,
		["r"] = 0.7098039215686275,
	},
	{
		["b"] = 1,
		["g"] = 1,
		["r"] = 0.8823529411764706,
	},
	{
		["b"] = 0.8431372549019608,
		["colorStr"] = "ffff7d0a",
		["g"] = 0.9764705882352941,
		["r"] = 0.8588235294117647,
	},
	{
		["b"] = 0.9686274509803922,
		["colorStr"] = "fff58cba",
		["g"] = 0.9372549019607843,
		["r"] = 1,
	},	
--Start to repeate

}

-- This is required, at the moment, to allow users to set their own colors.
_NPCScanOverlayKeyColors = private.OverlayKeyColors
