--[[

	This file is part of 'Masque: Gears', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Gears.lua
	* Author.: StormFX

]]

local MSQ = LibStub("Masque", true)
if not MSQ then return end

local AddOn, _ = ...
local Version = GetAddOnMetadata(AddOn, "Version")

-- Gears
MSQ:AddSkin("Gears", {
	Author = "StormFX, Unknown",
	Version = Version,
	Shape = "Circle",
	Masque_Version = 70200,
	Backdrop = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Backdrop]],
	},
	Icon = {
		Width = 24,
		Height = 24,
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 0.8},
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Overlay]],
	},
	Cooldown = {
		Width = 24,
		Height = 24,
		Color = {0, 0, 0, 0.7},
	},
	ChargeCooldown = {
		Width = 24,
		Height = 24,
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 0.8},
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Overlay]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "BLEND",
		Color = {0, 0.7, 0.9, 0.7},
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Border]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "BLEND",
		Color = {0, 1, 0, 0.5},
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = 36,
		Height = 36,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.8},
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Highlight]],
	},
	Name = {
		Width = 40,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = 40,
		Height = 10,
		OffsetY = 4,
	},
	HotKey = {
		Width = 40,
		Height = 10,
		JustifyH = "CENTER",
	},
	Duration = {
		Width = 40,
		Height = 10,
	},
	Shine = {
		Width = 16,
		Height = 16,
	},
}, true)

-- Gears - Black
MSQ:AddSkin("Gears - Black", {
	Template = "Gears",
	Normal = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Black]],
	},
}, true)

-- Gears - Random
MSQ:AddSkin("Gears - Random", {
	Template = "Gears",
	Normal = {
		Width = 40,
		Height = 40,
		Random = true,
		Textures = {
			[[Interface\AddOns\Masque_Gears\Textures\Normal]],
			[[Interface\AddOns\Masque_Gears\Textures\Black]],
			[[Interface\AddOns\Masque_Gears\Textures\Spark]],
		},
	},
}, true)

-- Gears - Spark
MSQ:AddSkin("Gears - Spark", {
	Template = "Gears",
	Normal = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Gears\Textures\Spark]],
	},
}, true)
