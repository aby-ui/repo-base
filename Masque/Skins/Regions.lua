--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Skins\Regions.lua
	* Author.: StormFX

	Regions Settings

]]

local _, Core = ...
local WOW_RETAIL = Core.WOW_RETAIL
local WOW_CLASSIC = not WOW_RETAIL

----------------------------------------
-- Region Settings

-- * Key - The string button key that holds the region reference.
-- * Func - The string name of the button method that returns the region reference.
-- * Name - The string suffix of the global key that holds the region reference.
-- * Type - Must match the game's internal type, for validation.

-- * UseColor - Use :SetColorTexture() if the skin provides a color but no texture.
-- * Hide - Region will be hidden if it exists.
-- * CanHide - Allow the region to be hidden.
-- * CanMask - Allow the region to be masked.
-- * NoColor - Do not allow color changes.
-- * NoTexture - Do not allow texture changes.

-- * Ignore - Ignore when looking for regions. @ Core\Group
-- * Iterate - Include in iteration. @ Core\Button
---

local Legacy = {
	-- [ BACKGROUND (-1) ]
	-- Only provided by default for MultiActionBars in Classic.
	Backdrop = {
		Name = "FloatingBG",
		Type = "Texture",
		CanHide = true,
		CanMask = true,
		UseColor = true,
	},
	-- [ BACKGROUND (0) ]
	Icon = {
		Key = "icon",
		Name = "Icon",
		Type = "Texture",
		CanMask = true,
		NoColor = true,
		NoTexture = true,
		Aura = {
			Key = (WOW_RETAIL and "Icon") or nil, -- Retail Only
			Name = "Icon",
			Type = "Texture",
			CanMask = true,
			NoColor = true,
			NoTexture = true,
		},
		Item = {
			Key = "icon",
			Name = "IconTexture",
			Type = "Texture",
			CanMask = true,
			NoColor = true,
			NoTexture = true,
		},
	},
	SlotIcon = {
		CanHide = true,
		Ignore = true,
	},
	-- [ ARTWORK (-1) ]
	Shadow = {
		CanHide = true,
		Ignore = true,
	},
	-- [ ARTWORK (0) ]
	Normal = {
		--Key = "NormalTexture", -- Conflicts with some add-ons.
		Func = "GetNormalTexture",
		Name = "NormalTexture",
		Type = "Texture",
		CanHide = true,
	},
	Disabled = {
		Func = "GetDisabledTexture",
		Type = "Texture",
		CanHide = true,
		Hide = true,
		Iterate = true,
	},
	Pushed = {
		Func = "GetPushedTexture",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	},
	-- [ ARTWORK (1) ]
	Flash = {
		-- Key = "Flash", -- Conflics with item buttons.
		Name = "Flash",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	},
	-- FlyoutBorder = {}, -- Unsupported
	-- FlyoutBorderShadow = {}, -- Unsupported
	-- [ ARTWORK (2) ]
	-- FlyoutArrow = {}, -- Unsupported
	-- [ ARTWORK (*) ]
	HotKey = {
		Key = "HotKey",
		Name = "HotKey",
		Type = "FontString",
		Iterate = true,
		NoColor = true,
	},
	Count = {
		Key = "Count",
		Name = "Count",
		Type = "FontString",
		Iterate = true,
		NoColor = true,
		Aura = {
			Key = "count",
			Name = "Count",
			Type = "FontString",
			Iterate = true,
			NoColor = true,
		},
		Item = {
			Key = "count",
			Name = "Count",
			Type = "FontString",
			Iterate = true,
			NoColor = true,
		},
	},
	Duration = {
		Key = "duration",
		Name = "Duration",
		Type = "FontString",
		Iterate = true,
		NoColor = true,
	},
	-- [ OVERLAY (0) ]
	Checked = {
		Func = "GetCheckedTexture",
		Type = "Texture",
		Iterate = true,
	},
	SlotHighlight = {
		Key = "SlotHighlightTexture",
		Type = "Texture",
		Iterate = true,
	},
	Name = {
		Key = "Name",
		Name = "Name",
		Type = "FontString",
		Iterate = true,
		NoColor = true,
	},
	Border = {
		Key = "Border",
		Name = "Border",
		Type = "Texture",
		Iterate = true,
		NoColor = true,
		Aura = {
			Name = "Border",
			Type = "Texture",
			Iterate = true,
			NoColor = true,
		},
		Debuff = {
			Key = (WOW_RETAIL and "Border") or nil, -- Retail Only
			Name = "Border",
			Type = "Texture",
			Iterate = true,
			NoColor = true,
		},
		Enchant = {
			Key = (WOW_RETAIL and "Border") or nil, -- Retail Only
			Name = "Border",
			Type = "Texture",
			Iterate = true,
		},
	},
	IconBorder = {
		Key = "IconBorder",
		Type = "Texture",
		NoColor = true,
	},
	-- [ OVERLAY (1) ]
	Gloss = {
		Ignore = true,
		CanHide = true,
	},
	NewAction = {
		Key = "NewActionTexture",
		Type = "Texture",
		Iterate = true,
	},
	SpellHighlight = {
		Key = "SpellHighlightTexture",
		Type = "Texture",
		Iterate = true,
	},
	AutoCastable = { -- Only used by Pet buttons.
		Key = "AutoCastable",
		-- Name = "AutoCastable",
		Type = "Texture",
		Iterate = true,
	},
	IconOverlay = {
		Key = "IconOverlay",
		Type = "Texture",
		Iterate = true,
		NoColor = true,
		NoTexture = true,
	},
	UpgradeIcon = {
		Key = "UpgradeIcon",
		Type = "Texture",
		Iterate = true,
	},
	-- [ OVERLAY (2) ]
	IconOverlay2 = {
		Key = "IconOverlay",
		Type = "Texture",
		Iterate = true,
		NoColor = true,
		NoTexture = true,
	},
	QuestBorder = {
		Name = "IconQuestTexture",
		Type = "Texture",
	},
	NewItem = {
		Key = "NewItemTexture",
		Type = "Texture",
		NoColor = true,
	},
	-- LevelLinkLockIcon = {}, -- Unsupported, no reason to.
	-- [ OVERLAY (4) ]
	SearchOverlay = {
		Key = "searchOverlay",
		Name = "SearchOverlay",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	},
	ContextOverlay = {
		Key = "searchOverlay",
		Name = "SearchOverlay",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	},
	-- [ OVERLAY (5) ]
	JunkIcon = {
		Key = "JunkIcon",
		Type = "Texture",
		Iterate = true,
	},
	-- [ HIGHLIGHT (0) ]
	Highlight = {
		Func = "GetHighlightTexture",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	},
	-- [ FRAME ]
	AutoCastShine = { -- Only used by Pet buttons.
		--Key = "AutoCastShine", -- Causes issues with Pet bars.
		Name = "Shine",
		Type = "Frame",
	},
	Cooldown = {
		Key = "cooldown",
		Name = "Cooldown",
		Type = "Cooldown",
	},
	ChargeCooldown = {
		Key = "chargeCooldown",
		Type = "Cooldown",
	},
}

----------------------------------------
-- Retail Only
---

if WOW_RETAIL then
	-- [ OVERLAY (2) ]
	Legacy.IconOverlay2 = {
		Key = "IconOverlay2",
		Type = "Texture",
		Iterate = true,
		NoColor = true,
		NoTexture = true,
	}
	-- [ OVERLAY (4) ]
	Legacy.ContextOverlay = {
		Key = "ItemContextOverlay",
		Type = "Texture",
		CanMask = true,
		Iterate = true,
		UseColor = true,
	}
end

----------------------------------------
-- "Action" Types
---

local Action = {
	Backdrop = Legacy.Backdrop,
	Icon = Legacy.Icon,
	Normal = Legacy.Normal,
	Disabled = Legacy.Disabled, -- Unused
	Pushed = Legacy.Pushed,
	Flash = Legacy.Flash,
	HotKey = Legacy.HotKey,
	Count = Legacy.Count,
	Checked = Legacy.Checked,
	Border = Legacy.Border,
	AutoCastable = Legacy.AutoCastable,
	NewAction = Legacy.NewAction,
	SpellHighlight = Legacy.SpellHighlight,
	Name = Legacy.Name,
	Highlight = Legacy.Highlight,
	AutoCastShine = Legacy.AutoCastShine,
	Cooldown = Legacy.Cooldown,
	ChargeCooldown = Legacy.ChargeCooldown,
}

----------------------------------------
-- "Aura" Types
---

local Aura = {
	Icon = Legacy.Icon.Aura,
	Normal = Legacy.Normal, -- Unused
	Disabled = Legacy.Disabled, -- Unused
	Pushed = Legacy.Pushed, -- Unused
	Count = Legacy.Count.Aura,
	Duration = Legacy.Duration,
	Border = Legacy.Border.Aura,
	Highlight = Legacy.Highlight, -- Unused
	Cooldown = Legacy.Cooldown,
	ChargeCooldown = Legacy.ChargeCooldown,
}

local Debuff = {
	Icon = Legacy.Icon.Aura,
	Normal = Legacy.Normal, -- Unused
	Disabled = Legacy.Disabled, -- Unused
	Pushed = Legacy.Pushed, -- Unused
	Count = Legacy.Count.Aura,
	Duration = Legacy.Duration,
	Border = Legacy.Border.Debuff,
	Highlight = Legacy.Highlight, -- Unused
	Cooldown = Legacy.Cooldown,
	ChargeCooldown = Legacy.ChargeCooldown,
}

local Enchant = {
	Icon = Legacy.Icon.Aura,
	Normal = Legacy.Normal, -- Unused
	Disabled = Legacy.Disabled, -- Unused
	Pushed = Legacy.Pushed, -- Unused
	Count = Legacy.Count.Aura,
	Duration = Legacy.Duration,
	Border = Legacy.Border.Enchant,
	Highlight = Legacy.Highlight, -- Unused
	Cooldown = Legacy.Cooldown,
	ChargeCooldown = Legacy.ChargeCooldown,
}

----------------------------------------
-- "Item" Types
---

local Item = {
	Icon = Legacy.Icon,
	Normal = Legacy.Normal,
	Disabled = Legacy.Disabled,
	Pushed = Legacy.Pushed,
	Count = Legacy.Count,
	Checked = (WOW_CLASSIC and Legacy.Checked) or nil, -- Classic Only
	Border = Legacy.Border, -- Backwards-Compatibility
	IconBorder = Legacy.IconBorder,
	SlotHighlight = (WOW_RETAIL and Legacy.SlotHighlight) or nil, -- Retail Only
	UpgradeIcon = Legacy.UpgradeIcon,
	IconOverlay = Legacy.IconOverlay,
	IconOverlay2 = Legacy.IconOverlay2,
	QuestBorder = Legacy.QuestBorder,
	NewItem = Legacy.NewItem,
	SearchOverlay = Legacy.SearchOverlay,
	ContextOverlay = Legacy.ContextOverlay,
	JunkIcon = Legacy.JunkIcon,
	Highlight = Legacy.Highlight,
	Cooldown = Legacy.Cooldown,
	ChargeCooldown = Legacy.ChargeCooldown,
}

----------------------------------------
-- Types Tables
---

local Types = {
	Legacy = Legacy,
	Action = Action,
	Aura = Aura,
	Backpack = Item,
	BagSlot = Item,
	Buff = Aura,
	Debuff = Debuff,
	Enchant = Enchant,
	Item = Item,
	Pet = Action,
	Possess = Action,
	ReagentBag = Item,
	Stance = Action,
}

local BaseTypes = {
	Action = true,
	Aura = true,
	Item = true,
}

local EmptyTypes = {
	Action = true,
	BagSlot = true,
	Pet = true,
	ReagentBag = true,
	Item = true,
}

----------------------------------------
-- Core
---

Core.RegTypes = Types
Core.BaseTypes = BaseTypes
Core.EmptyTypes = EmptyTypes

Core.ActionTypes = {
	Action = true,
	Pet = true,
	Possess = true,
	Stance = true,
}
Core.AuraTypes = {
	Aura = true,
	Buff = true,
	Debuff = true,
	Enchant = true,
}
Core.ItemTypes = {
	Backpack = true,
	BagSlot = true,
	Item = true,
	ReagentBag = true,
}

----------------------------------------
-- API
---

-- Adds a custom button type.
function Core.API:AddType(Name, List, Type)
	if type(Name) ~= "string" or Types[Name] then
		if Core.Debug then
			error("Bad argument to API method 'AddType'. 'Name' must be a unique string.", 2)
		end
		return
	elseif type(List) ~= "table" or #List < 1 then
		if Core.Debug then
			error("Bad argument to API method 'AddType'. 'List' must be an indexed table.", 2)
		end
		return
	elseif Type and type(Type) ~= "string" then
		if Core.Debug then
			error("Bad argument to API method 'AddType'. 'Type' must be a string.", 2)
		end
		return
	end

	local Cache = {}

	for i = 1, #List do
		local Key = List[i]
		local Root = Legacy[Key]

		if Root then
			Cache[Key] = (Type and Root[Type]) or Root
		end
	end

	Types[Name] = Cache

	if Type then
		if BaseTypes[Type] then
			local TypeList = Core[Type.."Types"]
			TypeList[Name] = true
		end

		EmptyTypes[Name] = EmptyTypes[Type]
	end
end
