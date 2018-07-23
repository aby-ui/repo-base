--[[
	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file.

	* File...: Skins\Dream.lua
	* Author.: StormFX, JJSheets

]]

local _, Core = ...

Core:AddSkin("Dream", {
	Author = "JJSheets, StormFX",
	Version = Core.Version,
	Masque_Version = 70200,
	Shape = "Square",
	Backdrop = {
		Width = 36,
		Height = 36,
		Color = {0, 0, 0, 0.6},
		Texture = [[Interface\Tooltips\UI-Tooltip-Background]],
	},
	Icon = {
		Width = 30,
		Height = 30,
		TexCoords = {0.07,0.93,0.07,0.93},
	},
	Flash = {
		Width = 30,
		Height = 30,
		TexCoords = {0.2, 0.8, 0.2, 0.8},
		Texture = [[Interface\Buttons\UI-QuickslotRed]],
	},
	Cooldown = {
		Width = 30,
		Height = 30,
	},
	ChargegCooldown = {
		Width = 30,
		Height = 30,
	},
	Pushed = {
		Width = 34,
		Height = 34,
		Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
	},
	Normal = {
		Hide = true,
	},
	Disabled = {
		Hide = true,
	},
	Checked = {
		Width = 32,
		Height = 32,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\CheckButtonHilight]],
	},
	Border = {
		Width = 54,
		Height = 54,
		OffsetY = 0.5,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\UI-ActionButton-Border]],
	},
	Gloss = {
		Hide = true,
	},
	AutoCastable = {
		Width = 56,
		Height = 56,
		OffsetX = 0.5,
		OffsetY = -0.5,
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
	},
	Highlight = {
		Width = 30,
		Height = 30,
		BlendMode = "ADD",
		Texture = [[Interface\Buttons\ButtonHilight-Square]],
	},
	Name = {
		Width = 36,
		Height = 10,
		OffsetY = 5,
	},
	Count = {
		Width = 36,
		Height = 10,
		OffsetX = -3,
		OffsetY = 5,
	},
	HotKey = {
		Width = 36,
		Height = 10,
		OffsetX = -3,
		OffsetY = -6,
	},
	Duration = {
		Width = 36,
		Height = 10,
		OffsetY = -2,
	},
	Shine = {
		Width = 28,
		Height = 28,
		OffsetX = 0.5,
		OffsetY = -0.5,
	},
})
