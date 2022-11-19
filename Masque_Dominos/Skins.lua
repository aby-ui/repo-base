--[[

	This file is part of 'Masque: Dominos', an add-on for World of Warcraft. For bug reports,
	documentation and license information, please visit https://github.com/SFX-WoW/Masque_Dominos.

	* File...: Skins.lua
	* Author.: StormFX, Tuller

	Dominos Skin

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
local Authors = {"StormFX", "Tuller"}
local Websites = {
	"https://github.com/SFX-WoW/Masque_Dominos",
	"https://www.curseforge.com/wow/addons/masque-dominos",
	"https://addons.wago.io/addons/masque-dominos",
	--"https://www.wowinterface.com/downloads/info8869",
}

----------------------------------------
-- Dominos
---

MSQ:AddSkin("Dominos", {
	Template = "Default (Classic)",
	API_VERSION = API_VERSION,
	Shape = "Square",

	-- Info
	Description = L["A port of the original Dominos skin for Masque."],
	Authors = Authors,
	Version = Version,
	Websites = Websites,

	-- Skin
	-- Mask = Template.Mask,
	-- Backdrop = Template.Backdrop,
	Icon = {
		TexCoords = {0.06, 0.94, 0.06, 0.94},
		DrawLayer = "BACKGROUND",
		DrawLevel = 0,
		Width = 36,
		Height = 36,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SlotIcon = {
		Texture = [[Interface\Icons\INV_Misc_Bag_08]],
		TexCoords = {0.06, 0.94, 0.06, 0.94},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "BACKGROUND",
		DrawLevel = 0,
		Width = 36,
		Height = 36,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	Normal = {
		Texture = [[Interface\Buttons\UI-Quickslot2]],
		-- TexCoords = {0, 1, 0, 1},
		Color = { 1, 1, 1, 0.5 },
		-- EmptyTexture = [[Interface\Buttons\UI-Quickslot2]],
		-- EmptyCoords = {0, 1, 0, 1},
		-- EmptyColor = {1, 1, 1, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 0,
		Width = 66,
		Height = 66,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		UseStates = true,
	},
	-- Disabled = Template.Disabled,
	-- Pushed = Template.Pushed,
	-- Flash = Template.Flash,
	-- HotKey = Template.HotKey,
	-- Count = Template.Count,
	-- Duration = Template.Duration,
	-- Checked = Template.Checked,
	-- SlotHighlight = Template.SlotHighlight,
	-- Name = Template.Name,
	-- Border = Template.Border,
	-- IconBorder = Template.IconBorder,
	-- Gloss = Template.Gloss,
	-- NewAction = Template.NewAction,
	-- SpellHighlight = Template.SpellHighlight,
	-- AutoCastable = Template.AutoCastable,
	-- IconOverlay = Template.IconOverlay,
	-- UpgradeIcon = Template.UpgradeIcon,
	-- IconOverlay2 = Template.IconOverlay2,
	-- QuestBorder = Template.QuestBorder,
	-- NewItem = Template.NewItem,
	-- SearchOverlay = Template.SearchOverlay,
	-- ContextOverlay = Template.ContextOverlay,
	-- JunkIcon = Template.JunkIcon,
	-- Highlight = Template.Highlight,
	-- AutoCastShine = Template.AutoCastShine,
	-- Cooldown = Template.Cooldown,
	-- ChargeCooldown = Template.ChargeCooldown,
	-- JunkIcon = Template.JunkIcon,
})
