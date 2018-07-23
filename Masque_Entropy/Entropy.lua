--[[

	This file is part of 'Masque: Entropy', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Entropy.lua
	* Author.: StormFX

]]

local MSQ = LibStub("Masque", true)
if not MSQ then return end

local AddOn, _ = ...
local Version = GetAddOnMetadata(AddOn, "Version")

-- Entropy - Silver
MSQ:AddSkin("Entropy - Silver", {
	Author = "StormFX",
	Version = Version,
	Shape = "Square",
	Masque_Version = 70200,
	Backdrop = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Backdrop]],
	},
	Icon = {
		Width = 28,
		Height = 28,
	},
	Flash = {
		Width = 32,
		Height = 32,
		Color = {1, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Overlay]],
	},
	Cooldown = {
		Width = 28,
		Height = 28,
		Color = {0, 0, 0, 0.7},
	},
	ChargeCooldown = {
		Width = 28,
		Height = 28,
	},
	Pushed = {
		Width = 32,
		Height = 32,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Overlay]],
	},
	Normal = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 32,
		Height = 32,
		BlendMode = "BLEND",
		Color = {0, 0.7, 0.9, 0.7},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
	},
	Border = {
		Width = 32,
		Height = 32,
		BlendMode = "BLEND",
		Color = {0, 1, 0, 0.5},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Border]],
	},
	Gloss = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Gloss]],
	},
	AutoCastable = {
		Width = 54,
		Height = 54,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Highlight]],
	},
	Name = {
		Width = 32,
		Height = 10,
		OffsetX = 1,
		OffsetY = 6,
	},
	Count = {
		Width = 32,
		Height = 10,
		OffsetX = -4,
		OffsetY = 7,
	},
	HotKey = {
		Width = 32,
		Height = 10,
		OffsetY = -7,
	},
	Duration = {
		Width = 32,
		Height = 10,
		OffsetY = -2,
	},
	Shine = {
		Width = 26,
		Height = 26,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)

-- Entropy - Adamantite
MSQ:AddSkin("Entropy - Adamantite", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.7, 0.8, 0.9, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Bronze
MSQ:AddSkin("Entropy - Bronze", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {1, 0.8, 0, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Cobalt
MSQ:AddSkin("Entropy - Cobalt", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.3, 0.7, 0.9, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Copper
MSQ:AddSkin("Entropy - Copper", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.8, 0.5, 0, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Fel Iron
MSQ:AddSkin("Entropy - Fel Iron", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.8, 1, 0.8, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Gold
MSQ:AddSkin("Entropy - Gold", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.8, 0.8, 0, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Iron
MSQ:AddSkin("Entropy - Iron", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.5, 0.5, 0.5, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Khorium
MSQ:AddSkin("Entropy - Khorium", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {1, 0.8, 0.9, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Obsidium
MSQ:AddSkin("Entropy - Obsidium", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Saronite
MSQ:AddSkin("Entropy - Saronite", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0.3, 0.9, 0.7, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)

-- Entropy - Titanium
MSQ:AddSkin("Entropy - Titanium", {
	Template = "Entropy - Silver",
	Normal = {
		Width = 32,
		Height = 32,
		Color = {1, 1, 0.7, 1},
		Texture = [[Interface\AddOns\Masque_Entropy\Textures\Normal]],
	},
}, true)
