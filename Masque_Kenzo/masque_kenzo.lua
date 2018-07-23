--[[
	Kenzo
	Skin for Masque
]]

local Masque = LibStub("Masque", true)
if not Masque then return end

-- kenzo -- basic
Masque:AddSkin("kenzo", {
	Author = "icw82",
	Version = "2.0.0",
	Masque_Version = 60000,
	Shape = "Square",
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.06,0.94,0.06,0.94},
	},
	Backdrop = {
		Width = 64,
		Height = 64,
		BlendMode = "BLEND",
		Color = {50,50,50, 1},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Backdrop]],
	},
	Normal = {
		Width = 64,
		Height = 64,
		Static = true,
		BlendMode = "BLEND",
		--Color = {0.5, 0.5, 0.5, 1},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Normal]],
	},
	-- Αλερκ
	Gloss = {
		Width = 64,
		Height = 64,
		Color = {1, 1, 1, 0.3},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Gloss]],
	},
	Highlight = {
		Width = 64,
		Height = 64,
		Color = {0, 0.5, 1, 1},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Highlight]],
	},
	Checked = {
		Width = 64,
		Height = 64,
		BlendMode = "ADD",
		Color = {1, 0.8, 0.2, 1},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Checked]],
	},
	Border = {
		Width = 64,
		Height = 64,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.5},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Highlight]],
	},
	Pushed = {
		Width = 64,
		Height = 64,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\Pushed]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCastable = {
		Width = 64,
		Height = 64,
		--OffsetX = 0.5,
		--OffsetY = -0.5,
		Texture = [[Interface\AddOns\Masque_kenzo\Textures\AutoCastable]],
	},

	Flash = {
		Width = 64,
		Height = 64,
		Color = {1, 0, 0, 1},
	},
	Disabled = {
		Width = 64,
		Height = 64,
		Static = true,
		Color = {1, 1, 1, 0.5},
	},

	Name = {
		Width = 32,
		Height = 10,
		OffsetY = 3,
	},
	Count = {
		Width = 32,
		Height = 10,
		OffsetX = -2,
		OffsetY = 3,
	},
	HotKey = {
		Width = 32,
		Height = 10,
		OffsetX = -1,
		OffsetY = -4,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 0.5,
		OffsetY = -0.5,
	},
}, true)