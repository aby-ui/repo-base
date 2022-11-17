--[[

	This file is part of 'Masque: Entropy', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Entropy.

	* File...: Skins.lua
	* Author.: StormFX

	Entropy Skins

]]

local MSQ = LibStub and LibStub("Masque", true)
if not MSQ then return end

local AddOn, Core = ...

----------------------------------------
-- Internal
---

local L = Core.Locale

----------------------------------------
-- Local
---

local API_VERSION = 100002

-- Skin Info
local Version = GetAddOnMetadata(AddOn, "Version")
local Websites = {
	"https://github.com/SFX-WoW/Masque_Entropy",
	"https://www.curseforge.com/wow/addons/masque-entropy",
	"https://addons.wago.io/addons/masque-entropy",
	"https://www.wowinterface.com/downloads/info8873",
}

-- Description
local SKIN_DESC = L["A metallic version of Apathy in the color of %s ore."]

----------------------------------------
-- Silver
---

MSQ:AddSkin("Entropy - Silver", {
	API_VERSION = API_VERSION,
	Shape = "Square",

	-- Info
	Author = "StormFX",
	Description = SKIN_DESC:format("Silver"),
	Version = Version,
	Websites = Websites,

	-- UI
	Group = "Entropy",
	Order = 11,
	Title = "Silver",

	-- Skin
	-- Mask = nil,
	Backdrop = {
		Texture = [[Interface\AddOns\Masque\Textures\Backdrop\Action]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "BACKGROUND",
		DrawLevel = -1,
		Width = 26,
		Height = 26,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseColor = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque\Textures\Backdrop\Item]],
			-- TexCoords = {0, 1, 0, 1},
			-- Color = {1, 1, 1, 1},
			BlendMode = "BLEND",
			DrawLayer = "BACKGROUND",
			DrawLevel = -1,
			Width = 26,
			Height = 26,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
			-- UseColor = nil,
		},
		Pet = {
			Texture = [[Interface\AddOns\Masque\Textures\Backdrop\Pet]],
			-- TexCoords = {0, 1, 0, 1},
			-- Color = {1, 1, 1, 1},
			BlendMode = "BLEND",
			DrawLayer = "BACKGROUND",
			DrawLevel = -1,
			Width = 26,
			Height = 26,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
			-- UseColor = nil,
		},
	},
	Icon = {
		TexCoords = {0.03, 0.97, 0.03, 0.97},
		DrawLayer = "BACKGROUND",
		DrawLevel = 0,
		Width = 27,
		Height = 27,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SlotIcon = {
		Texture = [[Interface\Icons\INV_Misc_Bag_08]],
		TexCoords = {0.03, 0.97, 0.03, 0.97},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "BACKGROUND",
		DrawLevel = 0,
		Width = 27,
		Height = 27,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	Shadow = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Shadow]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = -1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {1, 1, 1, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseStates = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			-- Color = {1, 1, 1, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
			-- UseStates = nil,
		},
	},
	-- Disabled = Default.Disabled,
	Pushed = {
		-- Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "BORDER",
		DrawLevel = 1,
		Width = 25,
		Height = 25,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		UseColor = true,
	},
	Flash = {
		-- Texture = [[Interface\Buttons\UI-QuickslotRed]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 0, 0, 0.4},
		BlendMode = "ADD",
		DrawLayer = "BORDER",
		DrawLevel = 0,
		Width = 25,
		Height = 25,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		UseColor = true,
	},
	HotKey = {
		JustifyH = "RIGHT",
		JustifyV = "MIDDLE",
		DrawLayer = "ARTWORK",
		Width = 27,
		Height = 0,
		Anchor = "Icon",
		Point = "TOPRIGHT",
		RelPoint = "TOPRIGHT",
		OffsetX = 0,
		OffsetY = -1,
	},
	Count = {
		JustifyH = "RIGHT",
		JustifyV = "MIDDLE",
		DrawLayer = "ARTWORK",
		Width = 0,
		Height = 0,
		Anchor = "Icon",
		Point = "BOTTOMRIGHT",
		RelPoint = "BOTTOMRIGHT",
		OffsetX = 0,
		OffsetY = 1,
	},
	Duration = {
		JustifyH = "CENTER",
		JustifyV = "MIDDLE",
		DrawLayer = "ARTWORK",
		Width = 27,
		Height = 0,
		Anchor = "Icon",
		Point = "TOP",
		RelPoint = "BOTTOM",
		OffsetX = 0,
		OffsetY = -2,
	},
	Checked = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0.7, 0.9, 0.7},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SlotHighlight = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0.7, 0.9, 0.7},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	Name = {
		JustifyH = "CENTER",
		JustifyV = "MIDDLE",
		DrawLayer = "OVERLAY",
		Width = 27,
		Height = 0,
		Anchor = "Icon",
		Point = "BOTTOM",
		RelPoint = "BOTTOM",
		OffsetX = 0,
		OffsetY = 1,
	},
	Border = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- TexCoords = {0, 1, 0, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		Enchant = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.6, 0.2, 0.9, 1},
			BlendMode = "BLEND",
			DrawLayer = "OVERLAY",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
		},
	},
	IconBorder = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- RelicTexture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	Gloss = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Gloss]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 1, 1, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	NewAction = {
		-- Atlas = "bags-newitem",
		-- UseAtlasSize = false,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Glow]],
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SpellHighlight = {
		-- Atlas = "bags-newitem",
		-- UseAtlasSize = false,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Glow]],
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	AutoCastable = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Indicator]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 1, 0, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	IconOverlay = {
		-- Atlas = "AzeriteIconFrame",
		-- UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	UpgradeIcon = {
		Atlas = "bags-greenarrow",
		UseAtlasSize = false, -- true
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 15,
		Height = 16,
		Point = "TOPLEFT",
		RelPoint = "TOPLEFT",
		OffsetX = 3,
		OffsetY = -4,
		-- SetAllPoints = nil,
	},
	IconOverlay2 = {
		-- Atlas = "ConduitIconFrame-Corners",
		-- UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	QuestBorder = {
		Border = [[Interface\AddOns\Masque_Entropy\Textures\Quest]],
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		Color = {1, 0.8, 0, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	NewItem = {
		-- Atlas = "bags-glow-white",
		-- UseAtlasSize = false,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Glow]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SearchOverlay = {
		-- Texture = nil,
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.7},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 4,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		UseColor = true,
	},
	ContextOverlay = {
		-- Texture = nil,
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.7},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 4,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		UseColor = true,
	},
	JunkIcon = {
		Atlas = "bags-junkcoin",
		UseAtlasSize = false, -- true
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 3,
		Width = 16,
		Height = 16,
		Point = "TOPLEFT",
		RelPoint = "TOPLEFT",
		OffsetX = 5,
		OffsetY = -4,
		-- SetAllPoints = nil,
	},
	Highlight = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 1, 1, 0.3},
		BlendMode = "ADD",
		DrawLayer = "HIGHLIGHT",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseColor = nil,
	},
	AutoCastShine = {
		Width = 26,
		Height = 26,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 1,
		OffsetY = -1,
		-- SetAllPoints = nil,
	},
	Cooldown = {
		-- Texture = nil,
		-- EdgeTexture = [[Interface\AddOns\Masque\Textures\Cooldown\Edge]],
		-- PulseTexture = [[Interface\Cooldown\star4]],
		Color = {0, 0, 0, 0.7},
		Width = 25,
		Height = 25,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	ChargeCooldown = {
		-- EdgeTexture = [[Interface\AddOns\Masque\Textures\Cooldown\Edge]],
		-- PulseTexture = [[Interface\Cooldown\star4]],
		Width = 24,
		Height = 24,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		--SetAllPoints = nil,
	},
})

----------------------------------------
-- Adamantite
---

MSQ:AddSkin("Entropy - Adamantite", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Adamantite"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 1,
	Title = "Adamantite",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.7, 0.8, 0.9, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.7, 0.8, 0.9, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.7, 0.8, 0.9, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Bronze
---

MSQ:AddSkin("Entropy - Bronze", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Bronze"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 2,
	Title = "Bronze",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 0.8, 0, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {1, 0.8, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {1, 0.8, 0, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Cobalt
---

MSQ:AddSkin("Entropy - Cobalt", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Cobalt"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 3,
	Title = "Cobalt",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.3, 0.7, 0.9, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.3, 0.7, 0.9, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.3, 0.7, 0.9, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Copper
---

MSQ:AddSkin("Entropy - Copper", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Copper"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 4,
	Title = "Copper",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.8, 0.5, 0, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.8, 0.5, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.8, 0.5, 0, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Fel Iron
---

MSQ:AddSkin("Entropy - Fel Iron", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Fel Iron"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 5,
	Title = "Fel Iron",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.8, 1, 0.8, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.8, 1, 0.8, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.8, 1, 0.8, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Gold
---

MSQ:AddSkin("Entropy - Gold", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Gold"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 6,
	Title = "Gold",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.8, 0.8, 0, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.8, 0.8, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.8, 0.8, 0, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Iron
---

MSQ:AddSkin("Entropy - Iron", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Iron"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 7,
	Title = "Iron",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.5, 0.5, 0.5, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.5, 0.5, 0.5, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.5, 0.5, 0.5, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Khorium
---

MSQ:AddSkin("Entropy - Khorium", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Khorium"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 8,
	Title = "Khorium",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 0.8, 0.9, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {1, 0.8, 0.9, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {1, 0.8, 0.9, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Obsidium
---

MSQ:AddSkin("Entropy - Obsidium", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Obsidium"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 9,
	Title = "Obsidium",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.3, 0.3, 0.3, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.3, 0.3, 0.3, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.3, 0.3, 0.3, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Saronite
---

MSQ:AddSkin("Entropy - Saronite", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Saronite"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 10,
	Title = "Saronite",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0.3, 0.9, 0.7, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {0.3, 0.9, 0.7, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {0.3, 0.9, 0.7, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})

----------------------------------------
-- Titanium
---

MSQ:AddSkin("Entropy - Titanium", {
	-- API_VERSION = Template.API_VERSION,
	-- Shape = Template.Shape,
	Template = "Entropy - Silver",

	-- Info
	-- Author = Template.Author,
	Description = SKIN_DESC:format("Titanium"),
	-- Version = Template.Version,
	-- Websites = Template.Websites,

	-- UI
	-- Group = Template.Group,
	Order = 12,
	Title = "Titanium",

	-- Skin
	Normal = {
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {1, 1, 0.7, 1},
		-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {1, 1, 0.7, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- UseStates = nil,
		-- SetAllPoints = nil,
		Item = {
			Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- TexCoords = {0, 1, 0, 1},
			Color = {1, 1, 0.7, 1},
			-- EmptyTexture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
			-- EmptyCoords = {0, 1, 0, 1},
			EmptyColor = {0.3, 0.3, 0.3, 0.5},
			BlendMode = "BLEND",
			DrawLayer = "ARTWORK",
			DrawLevel = 0,
			Width = 32,
			Height = 32,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- UseStates = nil,
			-- SetAllPoints = nil,
		},
	},
})
