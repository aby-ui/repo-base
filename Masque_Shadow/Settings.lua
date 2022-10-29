----------------------------------------- Shadow skin for 6.2.2 ------------------------------------------

local MSQ = LibStub("Masque", true)
if not MSQ then return end
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Masque: Shadow 1 --------------------------------------------
----------------------------------------------------------------------------------------------------------
MSQ:AddSkin("Masque: Shadow 1", 
{
	Author = "Fedorenko R.D. Афем-ЧерныйШрам",
	Version = "6.2.2",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 1\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Masque: Shadow 2 --------------------------------------------
----------------------------------------------------------------------------------------------------------
MSQ:AddSkin("Masque: Shadow 2", 
{
	Author = "Fedorenko R.D. Афем-ЧерныйШрам",
	Version = "6.2.2",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 40,
		Height = 40,
		Color = {1, 0, 0, 1},
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	Pushed = {
		Width = 40,
		Height = 40,
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Overlay]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.2},
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Highlight]],
	},
	Border = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Border]],
	},
	Gloss = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Gloss]],
	},
	AutoCastable = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 40,
		Height = 40,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\AddOns\Masque_Shadow\Textures\Shadow 2\Highlight]],
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Duration = {
		Width = 40,
		Height = 10,
		OffsetY = -2,
	},
	AutoCast = {
		Width = 38,
		Height = 38,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Masque: Shadow 3 --------------------------------------------
----------------------------------------------------------------------------------------------------------
MSQ:AddSkin("Masque: Shadow 3", 
{
	Author = "Fedorenko R.D. Афем-ЧерныйШрам",
	Version = "6.2.2",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 42,
		Height = 42,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 42,
		Height = 42,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Normal]],
	},
	Pushed = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Highlight]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Border]],
	},
	Disabled = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Border]],
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Border]],
	},
	AutoCastable = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Highlight]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 3\Gloss]],
	},
	HotKey = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 42,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 42,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Masque: Shadow 4 --------------------------------------------
----------------------------------------------------------------------------------------------------------
MSQ:AddSkin("Masque: Shadow 4", 
{
	Author = "Fedorenko R.D. Афем-ЧерныйШрам",
	Version = "6.2.2",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 32,
		Height = 32,
		Color = {0.3, 0.3, 0.3, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Backdrop]],
	},
	Icon = {
		Width = 32,
		Height = 32,
		TexCoords = {0.08, 0.92, 0.08, 0.92},
	},
	Flash = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 0.6},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Overlay]],
	},
	Cooldown = {
		Width = 32,
		Height = 32,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
	},
	Normal = {
		Width = 32,
		Height = 32,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Normal]],
	},
	Pushed = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Highlight]],
	},
	Border = {
		Width = 32,
		Height = 32,
		BlendMode = "BLEND",
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Border]],
	},
	Disabled = {
		Width = 32,
		Height = 32,
		BlendMode = "BLEND",
		Color = {0.77, 0.12, 0.23, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Border]],
	},
	Checked = {
		Width = 32,
		Height = 32,
		BlendMode = "BLEND",
		Color = {0, 0.12, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Border]],
	},
	AutoCastable = {
		Width = 32,
		Height = 32,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {0.5, 0, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Highlight]],
	},
	Gloss = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Color = {1, 1, 1, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 4\Gloss]],
	},
	HotKey = {
		Width = 32,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "TOP",
		OffsetX = -2,
		OffsetY = -2,
	},
	Count = {
		Width = 32,
		Height = 10,
		JustifyH = "RIGHT",
		JustifyV = "BOTTOM",
		OffsetY = 1,
	},
	Name = {
		Width = 32,
		Height = 10,
		JustifyH = "CENTER",
		JustifyV = "BOTTOM",
		OffsetY = 2,
	},
}, true)
----------------------------------------------------------------------------------------------------------
-------------------------------------------- Masque: Shadow 5 --------------------------------------------
----------------------------------------------------------------------------------------------------------
MSQ:AddSkin("Masque: Shadow 5",  
{
	Author = "Fedorenko R.D. Афем-ЧерныйШрам",
	Version = "6.2.2",
	Shape = "Square",
	Masque_Version = 60200,
	Backdrop = {
		Width = 40,
		Height = 40,
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Backdrop]],
	},
	Icon = {
		Width = 26,
		Height = 26,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 42,
		Height = 42,
		Color = {1, 0, 0, 0.3},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Overlay]],
	},
	Cooldown = {
		Width = 26,
		Height = 26,
	},
	Pushed = {
		Width = 42,
		Height = 42,
		Color = {0, 0, 0, 0.5},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Overlay]],
	},
	Normal = {
		Width = 40,
		Height = 40,
		Color = {0, 0, 0, 1},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Normal]],
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {0, 0.8, 1, 0.0},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Border]],
	},
	Border = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Border]],
	},
	Gloss = {
		Width = 42,
		Height = 42,
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Gloss]],
	},
	AutoCastable = {
		Width = 64,
		Height = 64,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 42,
		Height = 42,
		BlendMode = "ADD",
		Color = {1, 1, 1, 0.0},
		Texture = [[Interface\Addons\Masque_Shadow\Textures\Shadow 5\Highlight]],
	},
	Name = {
		Width = 42,
		Height = 10,
		OffsetY = 2,
	},
	Count = {
		Width = 42,
		Height = 10,
		OffsetY = 2,
	},
	HotKey = {
		Width = 42,
		Height = 10,
		OffsetX = -6,
		OffsetY = -3,
	},
	Duration = {
		Width = 42,
		Height = 10,
		OffsetY = -3,
	},
	AutoCast = {
		Width = 32,
		Height = 32,
		OffsetX = 1,
		OffsetY = -1,
	},
}, true)