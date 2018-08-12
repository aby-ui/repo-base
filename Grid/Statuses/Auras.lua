local n2s,f2s,floor=n2s or tostring,f2s or function(time) return format("%.1f", time) end,floor
--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
------------------------------------------------------------------------
	Auras.lua
	Grid status module for tracking buffs/debuffs.
----------------------------------------------------------------------]]

local IS_WOW_8 = GetBuildInfo():match("^8")

local _, Grid = ...
local L = Grid.L

local strutf8sub = string.utf8sub
local format, gmatch, gsub, pairs, strfind, strlen, strlower, strmatch, strsub, tostring, type
    = format, gmatch, gsub, pairs, strfind, strlen, strlower, strmatch, strsub, tostring, type
local IsPlayerSpell, UnitAura, UnitClass, UnitGUID, UnitIsPlayer, UnitIsVisible
    = IsPlayerSpell, UnitAura, UnitClass, UnitGUID, UnitIsPlayer, UnitIsVisible

local GridFrame = Grid:GetModule("GridFrame")
local GridRoster = Grid:GetModule("GridRoster")

local GridStatusAuras = Grid:NewStatusModule("GridStatusAuras", "AceTimer-3.0")
GridStatusAuras.menuName = L["Auras"]

local _, PLAYER_CLASS = UnitClass("player")
local PlayerCanDispel = {}

local spell_names = {
-- All
	["Ghost"] = GetSpellInfo(8326),
-- Druid
	["Lifebloom"] = GetSpellInfo(33763),
	["Regrowth"] = GetSpellInfo(8936),
	["Rejuvenation"] = GetSpellInfo(774),
	["Rejuvenation (Germination)"] = GetSpellInfo(155777),
	["Wild Growth"] = GetSpellInfo(48438),
-- Monk
	["Enveloping Mist"] = GetSpellInfo(124682),
	["Essence Font"] = GetSpellInfo(191837),
	["Life Cocoon"] = GetSpellInfo(116849),
	["Renewing Mist"] = GetSpellInfo(115151),
	["Soothing Mist"] = GetSpellInfo(115175),
-- Paladin
	["Beacon of Faith"] = GetSpellInfo(156910),
	["Beacon of Light"] = GetSpellInfo(53563),
	["Beacon of Virtue"] = GetSpellInfo(200025),
	["Forbearance"] = GetSpellInfo(25771),
	["Sacred Dawn"] = GetSpellInfo(243174),
	["Tyr's Deliverance"] = GetSpellInfo(200654),
-- Priest
	["Atonement"] = GetSpellInfo(214206),
	["Clarity of Will"] = GetSpellInfo(152118),
	["Guardian Spirit"] = GetSpellInfo(47788),
	["Light of T'uure"] = GetSpellInfo(208065),
	["Power Word: Fortitude"] = GetSpellInfo(21562),
	["Power Word: Shield"] = GetSpellInfo(17),
	["Prayer of Mending"] = GetSpellInfo(33076),
	["Renew"] = GetSpellInfo(139),
-- Shaman
	["Earth Shield"] = GetSpellInfo(204288),
	["Riptide"] = GetSpellInfo(61295),
}

-- data used by aura scanning
local buff_names = {}
local player_buff_names = {}
local debuff_names = {}

local debuff_types = {
	["Curse"] = "dispel_curse",
	["Disease"] = "dispel_disease",
	["Magic"] = "dispel_magic",
	["Poison"] = "dispel_poison",
}

function GridStatusAuras:StatusForSpell(spell, isBuff)
	return format(isBuff and "buff_%s" or "debuff_%s", gsub(spell, " ", ""))
end

function GridStatusAuras:TextForSpell(spell)
	if strfind(spell, "%s") then
		local str = ""
		for word in gmatch(spell, "%S+") do
			str = str .. strutf8sub(word, 1, 1)
		end
		return str
	else
		return strutf8sub(spell, 1, 3)
	end
end

local statusDefaultDB = {
	enable = true,
	priority = 90,
	duration = false,
	color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
	statusText = "name",
	statusColor = "present",
	refresh = 0.5,
	durationTenths = false,
	durationColorLow = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
	durationColorMiddle = { r = 0.35, g = 0.35, b = 0.35, a = 1 },
	durationColorHigh = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
	durationLow = 2,
	durationHigh = 4,
	countColorLow = { r = 1, g = 0, b = 0, a = 1 },
	countColorMiddle = { r = 1, g = 1, b = 0, a = 1 },
	countColorHigh = { r = 0, g = 1, b = 0, a = 1 },
	countLow = 1,
	countHigh = 2,
}

-- Perform a deep copy of defaultDB into the given settings table except into the slots
-- where the value is non-nil (non-default setting).
function GridStatusAuras:CopyDefaults(settings, defaults)
	if type(defaults) ~= "table" then return {} end
	if type(settings) ~= "table" then settings = {} end
	for k, v in pairs(defaults) do
		if type(v) == "table" then
			settings[k] = self:CopyDefaults(settings[k], v)
		elseif type(v) ~= type(settings[k]) then
			settings[k] = v
		end
	end
	return settings
end

GridStatusAuras.defaultDB = {
	advancedOptions = false,
--[[
	["boss_aura"] = {
		desc = L["Boss Aura"],
		color = { r = 1, g = 0, b = 0, a = 1 },
		priority = 90,
		order = 20,
	},
]]
	---------------------
	-- Debuff Types
	---------------------
	["dispel_curse"] = {
		desc = format(L["Debuff type: %s"], L["Curse"]),
		text = DEBUFF_SYMBOL_CURSE,
		color = { r = 0.6, g = 0, b = 1, a = 1 },
		durationColorLow = { r = 0.18, g = 0, b = 0.3, a = 1 },
		durationColorMiddle = { r = 0.42, g = 0, b = 0.7, a = 1 },
		durationColorHigh = { r = 0.6, g = 0, b = 1, a = 1 },
		dispellable = true,
		order = 25,
	},
	["dispel_disease"] = {
		desc = format(L["Debuff type: %s"], L["Disease"]),
		text = DEBUFF_SYMBOL_DISEASE,
		color = { r = 0.6, g = 0.4, b = 0, a = 1 },
		durationColorLow = { r = 0.18, g = 0.12, b = 0, a = 1 },
		durationColorMiddle = { r = 0.42, g = 0.28, b = 0, a = 1 },
		durationColorHigh = { r = 0.6, g = 0.4, b = 0, a = 1 },
		dispellable = true,
		order = 25,
	},
	["dispel_magic"] = {
		desc = format(L["Debuff type: %s"], L["Magic"]),
		text = DEBUFF_SYMBOL_MAGIC,
		color = { r = 0.2, g = 0.6, b = 1, a = 1 },
		durationColorLow = { r = 0.06, g = 0.18, b = 0.3, a = 1 },
		durationColorMiddle = { r = 0.14, g = 0.42, b = 0.7, a = 1 },
		durationColorHigh = { r = 0.2, g = 0.6, b = 1, a = 1 },
		dispellable = true,
		order = 25,
	},
	["dispel_poison"] = {
		desc = format(L["Debuff type: %s"], L["Poison"]),
		text = DEBUFF_SYMBOL_POISON,
		color = { r = 0, g = 0.6, b = 0, a = 1 },
		durationColorLow = { r = 0, g = 0.18, b = 0, a = 1 },
		durationColorMiddle = { r = 0, g = 0.42, b = 0, a = 1 },
		durationColorHigh = { r = 0, g = 0.6, b = 0, a = 1 },
		dispellable = true,
		order = 25,
	},

	---------------------
	-- General Debuffs
	---------------------
	[GridStatusAuras:StatusForSpell("Ghost")] = {
		-- 8326
		desc = format(L["Debuff: %s"], spell_names["Ghost"]),
		debuff = spell_names["Ghost"],
		text = GridStatusAuras:TextForSpell(spell_names["Ghost"]),
		color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
	},

	-- Mythic+ Overflow
	debuff_221772 = GetSpellInfo("221772") and {
		debuffID = 221772,
		desc = format(L["Debuff: %s"], (GetSpellInfo("221772"))),
		text = GetSpellInfo("221772"),
		debuff = GetSpellInfo("221772"),
		color = { r = 1, g = 0.8, b = 0.8, a = 1 },
		priority = 98,
	},

	-- Mythic+ Necrotic Rot 死疽
	debuff_209858 = GetSpellInfo("209858") and {
		debuffID = 209858,
		desc = format(L["Debuff: %s"], (GetSpellInfo("209858"))),
		text = GetSpellInfo("209858"),
		debuff = GetSpellInfo("209858"),
		color = { r = 1, g = 0.8, b = 0.8, a = 1 },
		priority = 99,
		statusText = "dur_count",
	},

	-- Mythic+ 重伤
	debuff_240559 = GetSpellInfo("240559") and {
		debuffID = 240559,
		desc = format(L["Debuff: %s"], (GetSpellInfo("240559"))),
		text = GetSpellInfo("240559"),
		debuff = GetSpellInfo("240559"),
		color = { r = 1, g = 0.8, b = 0.8, a = 1 },
		priority = 99,
		statusText = "count",
	},

    debuff_240443 = GetSpellInfo(240443) and {
        debuffID = 240443,
        desc = format(L["Debuff: %s"], (GetSpellInfo("240443"))),
        text = GetSpellInfo("240443"),
        debuff = GetSpellInfo("240443"),
        color = { r = 1, g = 0.8, b = 0.8, a = 1 },
        priority = 99,
        statusText = "count",
    },

	---------------------
	-- Druid
	---------------------
	[GridStatusAuras:StatusForSpell("Lifebloom", true)] = {
		-- 33763
		desc = format(L["Buff: %s"], spell_names["Lifebloom"]),
		buff = spell_names["Lifebloom"],
		text = GridStatusAuras:TextForSpell(spell_names["Lifebloom"]),
		color = { r = 0.3, g = 0.7, b = 0, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.21, g = 0.49, b = 0, a = 1 },
		durationColorHigh = { r = 0.3, g = 0.7, b = 0, a = 1 },
		countColorLow = { r = 1, g = 0, b = 0, a = 1 },
		countColorMiddle = { r = 1, g = 1, b = 0, a = 1 },
		countColorHigh = { r = 0, g = 1, b = 0, a = 1 },
		countLow = 1,
		countHigh = 2,
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Regrowth", true)] = {
		-- 8936
		desc = format(L["Buff: %s"], spell_names["Regrowth"]),
		buff = spell_names["Regrowth"],
		text = GridStatusAuras:TextForSpell(spell_names["Regrowth"]),
		color = { r = 1, g = 0.7, b = 0.1, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.7, g = 0.49, b = 0.07, a = 1 },
		durationColorHigh = { r = 1, g = 0.7, b = 0.1, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Rejuvenation", true)] = {
		-- 774
		desc = format(L["Buff: %s"], spell_names["Rejuvenation"]),
		buff = spell_names["Rejuvenation"],
		text = GridStatusAuras:TextForSpell(spell_names["Rejuvenation"]),
		color = { r = 0, g = 0.3, b = 0.7, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0, g = 0.21, b = 0.49, a = 1 },
		durationColorHigh = { r = 0, g = 0.3, b = 0.7, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Rejuvenation (Germination)", true)] = {
		-- 155777
		desc = format(L["Buff: %s"], spell_names["Rejuvenation (Germination)"]),
		buff = spell_names["Rejuvenation (Germination)"],
		text = GridStatusAuras:TextForSpell(spell_names["Rejuvenation (Germination)"]),
		color = { r = 0.66, g = 0.55, b = 1, a = 1 },
		durationColorLow = { r = 0.66, g = 0.55, b = 1, a = 1 },
		durationColorMiddle = { r = 0.46, g = 0.38, b = 0.7, a = 1 },
		durationColorHigh = { r = 0.33, g = 0.27, b = 0.5, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Wild Growth", true)] = {
		-- 48438
		desc = format(L["Buff: %s"], spell_names["Wild Growth"]),
		buff = spell_names["Wild Growth"],
		text = GridStatusAuras:TextForSpell(spell_names["Wild Growth"]),
		color = { r = 0.56, g = 0.85, b = 0.62, a = 1 },
		durationColorLow = { r = 0.56, g = 0.85, b = 0.62, a = 1 },
		durationColorMiddle = { r = 0.39, g = 0.55, b = 0.42, a = 1 },
		durationColorHigh = { r = 0.27, g = 0.37, b = 0.29, a = 1 },
		mine = true,
	},

	---------------------
	-- Monk
	---------------------
	[GridStatusAuras:StatusForSpell("Enveloping Mist", true)] = {
		-- 124682
		buff = spell_names["Enveloping Mist"],
		desc = format(L["Buff: %s"], spell_names["Enveloping Mist"]),
		text = GridStatusAuras:TextForSpell(spell_names["Enveloping Mist"]),
		color = { r = 0.2, g = 1, b = 0.2, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Essence Font", true)] = {
		-- 191837
		buff = spell_names["Essence Font"],
		desc = format(L["Buff: %s"], spell_names["Essence Font"]),
		text = GridStatusAuras:TextForSpell(spell_names["Essence Font"]),
		color = { r = 0, g = 0.7, b = 0.7, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Life Cocoon", true)] = {
		-- 116849
		buff = spell_names["Life Cocoon"],
		desc = format(L["Buff: %s"], spell_names["Life Cocoon"]),
		text = GridStatusAuras:TextForSpell(spell_names["Life Cocoon"]),
		color = { r = 0.8, g = 0.8, b = 0.4, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Renewing Mist", true)] = {
		-- 115151
		buff = spell_names["Renewing Mist"],
		desc = format(L["Buff: %s"], spell_names["Renewing Mist"]),
		text = GridStatusAuras:TextForSpell(spell_names["Renewing Mist"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Soothing Mist", true)] = {
		-- 115175
		buff = spell_names["Soothing Mist"],
		desc = format(L["Buff: %s"], spell_names["Soothing Mist"]),
		text = GridStatusAuras:TextForSpell(spell_names["Soothing Mist"]),
		color = { r = 0.8, g = 1, b = 0.3, a = 1 },
		mine = true,
	},

	---------------------
	-- Paladin
	---------------------
	[GridStatusAuras:StatusForSpell("Beacon of Faith", true)] = {
		-- 156910
		desc = format(L["Buff: %s"], spell_names["Beacon of Faith"]),
		buff = spell_names["Beacon of Faith"],
		text = GridStatusAuras:TextForSpell(spell_names["Beacon of Faith"]),
		color = { r = 0.5, g = 0.3, b = 0.5, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.49, g = 0.49, b = 0, a = 1 },
		durationColorHigh = { r = 0.7, g = 0.7, b = 0, a = 1 },
		durationLow = 5,
		durationHigh = 10,
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Beacon of Light", true)] = {
		-- 53563
		desc = format(L["Buff: %s"], spell_names["Beacon of Light"]),
		buff = spell_names["Beacon of Light"],
		text = GridStatusAuras:TextForSpell(spell_names["Beacon of Light"]),
		color = { r = 0.5, g = 0.7, b = 0.3, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.49, g = 0.49, b = 0, a = 1 },
		durationColorHigh = { r = 0.7, g = 0.7, b = 0, a = 1 },
		durationLow = 5,
		durationHigh = 10,
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Beacon of Virtue", true)] = {
		-- 200025
		desc = format(L["Buff: %s"], spell_names["Beacon of Virtue"]),
		buff = spell_names["Beacon of Virtue"],
		text = GridStatusAuras:TextForSpell(spell_names["Beacon of Virtue"]),
		color = { r = 0.95, g = 0.47, b = 0.66, a = 1 },
		durationColorLow = { r = 0.95, g = 0.47, b = 0.66, a = 1 },
		durationColorMiddle = { r = 0.7, g = 0.35, b = 0.49, a = 1 },
		durationColorHigh = { r = 0.5, g = 0.25, b = 0.35, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Sacred Dawn")] = {
		-- 243174
		desc = format(L["Debuff: %s"], spell_names["Sacred Dawn"]),
		debuff = spell_names["Sacred Dawn"],
		text = GridStatusAuras:TextForSpell(spell_names["Sacred Dawn"]),
		color = { r = 0.95, g = 1, b = 0.7, a = 1 },
		durationColorLow = { r = 0.95, g = 1, b = 0.7, a = 1 },
		durationColorMiddle = { r = 0.66, g = 0.7, b = 0.49, a = 1 },
		durationColorHigh = { r = 0.43, g = 0.45, b = 0.32, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Tyr's Deliverance")] = {
		-- 200654
		desc = format(L["Debuff: %s"], spell_names["Tyr's Deliverance"]),
		debuff = spell_names["Tyr's Deliverance"],
		text = GridStatusAuras:TextForSpell(spell_names["Tyr's Deliverance"]),
		color = { r = 0.95, g = 0.82, b = 0.33, a = 1 },
		durationColorLow = { r = 0.95, g = 0.82, b = 0.33, a = 1 },
		durationColorMiddle = { r = 0.65, g = 0.56, b = 0.23, a = 1 },
		durationColorHigh = { r = 0.45, g = 0.38, b = 0.16, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Forbearance")] = {
		-- 25771
		desc = format(L["Debuff: %s"], spell_names["Forbearance"]),
		debuff = spell_names["Forbearance"],
		text = GridStatusAuras:TextForSpell(spell_names["Forbearance"]),
		color = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		durationColorLow = { r = 0.15, g = 0.15, b = 0.15, a = 1 },
		durationColorMiddle = { r = 0.35, g = 0.35, b = 0.35, a = 1 },
		durationColorHigh = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
	},

	---------------------
	-- Priest
	---------------------
	[GridStatusAuras:StatusForSpell("Atonement", true)] = {
		-- 214206
		buff = spell_names["Atonement"],
		desc = format(L["Buff: %s"], spell_names["Atonement"]),
		text = GridStatusAuras:TextForSpell(spell_names["Atonement"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Clarity of Will", true)] = {
		-- 152118
		desc = format(L["Buff: %s"], spell_names["Clarity of Will"]),
		buff = spell_names["Clarity of Will"],
		text = GridStatusAuras:TextForSpell(spell_names["Clarity of Will"]),
		color = { r = 0.8, g = 0.8, b = 0, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.56, g = 0.56, b = 0, a = 1 },
		durationColorHigh = { r = 0.8, g = 0.8, b = 0, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Guardian Spirit", true)] = {
		-- 47788
		desc = format(L["Buff: %s"], spell_names["Guardian Spirit"]),
		buff = spell_names["Guardian Spirit"],
		text = GridStatusAuras:TextForSpell(spell_names["Guardian Spirit"]),
		color = { r = 0.4, g = 0.73, b = 1, a = 1 },
		durationColorLow = { r = 0.4, g = 0.73, b = 1, a = 1 },
		durationColorMiddle = { r = 0.24, g = 0.54, b = 0.8, a = 1 },
		durationColorHigh = { r = 0.13, g = 0.41, b = 0.65, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Light of T'uure", true)] = {
		-- 208065
		desc = format(L["Buff: %s"], spell_names["Light of T'uure"]),
		buff = spell_names["Light of T'uure"],
		text = GridStatusAuras:TextForSpell(spell_names["Light of T'uure"]),
		color = { r = 0.33, g = 0.46, b = 1, a = 1 },
		durationColorLow = { r = 0.33, g = 0.46, b = 1, a = 1 },
		durationColorMiddle = { r = 0.24, g = 0.33, b = 0.7, a = 1 },
		durationColorHigh = { r = 0.17, g = 0.23, b = 0.5, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Power Word: Fortitude", true)] = {
		-- 21562
		desc = format(L["Buff: %s"], spell_names["Power Word: Fortitude"]),
		buff = spell_names["Power Word: Fortitude"],
		text = GridStatusAuras:TextForSpell(spell_names["Power Word: Fortitude"]),
		color = { r = 0, g = 0.7, b = 0.3, a = 1 },
		missing = true,
	},
	[GridStatusAuras:StatusForSpell("Power Word: Shield", true)] = {
		-- 17
		desc = format(L["Buff: %s"], spell_names["Power Word: Shield"]),
		buff = spell_names["Power Word: Shield"],
		text = GridStatusAuras:TextForSpell(spell_names["Power Word: Shield"]),
		color = { r = 0.8, g = 0.8, b = 0, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.56, g = 0.56, b = 0, a = 1 },
		durationColorHigh = { r = 0.8, g = 0.8, b = 0, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Prayer of Mending", true)] = {
		-- 33076, 41635
		buff = spell_names["Prayer of Mending"],
		desc = format(L["Buff: %s"], spell_names["Prayer of Mending"]),
		text = GridStatusAuras:TextForSpell(spell_names["Prayer of Mending"]),
		color = { r = 0.2, g = 0.8, b = 1, a = 1 },
		mine = true,
	},
	[GridStatusAuras:StatusForSpell("Renew", true)] = {
		-- 139
		desc = format(L["Buff: %s"], spell_names["Renew"]),
		buff = spell_names["Renew"],
		text = GridStatusAuras:TextForSpell(spell_names["Renew"]),
		color = { r = 0, g = 0.7, b = 0.3, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0, g = 0.49, b = 0.21, a = 1 },
		durationColorHigh = { r = 0, g = 0.7, b = 0.3, a = 1 },
		mine = true,
	},

	---------------------
	-- Shaman
	---------------------
	[GridStatusAuras:StatusForSpell("Earth Shield", true)] = {
		-- 204288
		desc = format(L["Buff: %s"], spell_names["Earth Shield"]),
		buff = spell_names["Earth Shield"],
		text = GridStatusAuras:TextForSpell(spell_names["Earth Shield"]),
		color = { r = 0.2, g = 1, b = 0.2, a = 1 },
	},
	[GridStatusAuras:StatusForSpell("Riptide", true)] = {
		-- 61295
		desc = format(L["Buff: %s"], spell_names["Riptide"]),
		buff = spell_names["Riptide"],
		text = GridStatusAuras:TextForSpell(spell_names["Riptide"]),
		color = { r = 0.4, g = 0, b = 0.8, a = 1 },
		durationColorLow = { r = 1, g = 0, b = 0, a = 1 },
		durationColorMiddle = { r = 0.28, g = 0, b = 0.56, a = 1 },
		durationColorHigh = { r = 0.4, g = 0, b = 0.8, a = 1 },
		mine = true,
	},
}

local default_auras = {}

GridStatusAuras.extraOptions = {}

function GridStatusAuras:PostInitialize()
    --163ui add AurasByClass and move default_auras setter from outside
    if GridStatusAuras.UpdateDefaultAuras then GridStatusAuras:UpdateDefaultAuras() end
    do
    	for status, settings in pairs(GridStatusAuras.defaultDB) do
    		if type(settings) == "table" and settings.text then
    			GridStatusAuras:CopyDefaults(settings, statusDefaultDB)
    			default_auras[status] = true
    		end
    	end
    end

	self:RegisterStatuses()

	self.options.args["add_buff"] = {
		name = L["Add Buff"],
		desc = L["Create a new buff status."],
		order = 11,
		width = "double",
		type = "input",
		usage = L["<buff name>"],
		get = false,
		set = function(_, v)
			self:AddAura(v, true)
		end,
	}
	self.options.args["add_debuff"] = {
		name = L["Add Debuff"],
		desc = L["Create a new debuff status."],
		order = 31,
		width = "double",
		type = "input",
		usage = L["<debuff name>"],
		get = false,
		set = function(_, v)
			self:AddAura(v, false)
		end,
	}
	self.options.args["delete_aura"] = {
		name = L["Remove Aura"],
		desc = L["Remove an existing buff or debuff status."],
		order = -2,
		type = "group",
		dialogInline = true,
		args = {},
	}
	self.options.args["advancedOptions"] = {
		name = L["Show advanced options"],
		desc = L["Show advanced options for buff and debuff statuses.\n\nBeginning users may wish to leave this disabled until you are more familiar with Grid, to avoid being overwhelmed by complicated options menus."],
		order = -1,
		width = "full",
		type = "toggle",
		get = function()
			return self.db.profile.advancedOptions
		end,
		set = function(_, v)
			self.db.profile.advancedOptions = v
		end,
	}
end

function GridStatusAuras:PostEnable()
	self:CreateRemoveOptions()
	self:UpdateDispellable()
end

function GridStatusAuras:PostReset()
	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:CreateRemoveOptions()
	self:ResetDurationStatuses()
	self:UpdateAuraScanList()
end

function GridStatusAuras:EnabledStatusCount()
	local enable_count = 0

	for status, settings in pairs(self.db.profile) do
		if type(settings) == "table" and settings.enable then
			enable_count = enable_count + 1
		end
	end

	return enable_count
end

function GridStatusAuras:OnStatusEnable(status)
	self:RegisterMessage("Grid_UnitJoined")
	self:RegisterEvent("UNIT_AURA", "ScanUnitAuras")
	self:RegisterEvent("SPELLS_CHANGED", "UpdateDispellable")

	self:DeleteDurationStatus(status)
	self:UpdateDispellable()
	self:UpdateAuraScanList()
	self:UpdateAllUnitAuras()
end

function GridStatusAuras:OnStatusDisable(status)
	self.core:SendStatusLostAllUnits(status)
	self:DeleteDurationStatus(status)
	self:UpdateAuraScanList()

	if self:EnabledStatusCount() == 0 then
		self:UnregisterMessage("Grid_UnitJoined")
		self:UnregisterEvent("UNIT_AURA")
	end
end

function GridStatusAuras:RegisterStatuses()
	local profile = self.db.profile

	for status, settings in pairs(profile) do
		if type(settings) == "table" then
			if settings.desc then
				--self:Debug("Registering status:", status)
				if settings.buff == nil and settings.debuff == nil and not self.defaultDB[status] then
					self:Debug("Upgrading old aura:", settings.desc)
					local aura = strmatch(settings.desc, gsub(L["Buff: %s"], "%%s", "(.+)"))
					if aura then
						settings.aura = aura
						if settings.text == aura then
							settings.text = self:TextForSpell(aura)
						end
						--self:Debug("Upgraded buff:", aura)
					else
						aura = strmatch(settings.desc, gsub(L["Debuff: %s"], "%%s", "(.+)"))
						if aura then
							settings.debuff = aura
							if settings.text == aura then
								settings.text = self:TextForSpell(aura)
							end
							--self:Debug("Upgraded debuff:", aura)
						else
							self:Debug("Upgrade failed!")
						end
					end
				end
				--[[if status == "boss_aura" then
					self:RegisterStatus(status, settings.desc, { text = false }, false, settings.order)

				else]] if settings.buff or settings.debuff or self.defaultDB[status] then
					local name = settings.text
					local desc = settings.desc or name
					local isBuff = not not settings.buff
					local order = settings.order or (isBuff and 15 or 35)

                if not isBuff or GridStatusAuras:ShouldRegisterByClass(settings.buff) then --163ui
					self:Debug("Registering", status, desc)
					if not self.defaultDB[status] then
						self.defaultDB[status] = {}
						self:CopyDefaults(self.defaultDB[status], statusDefaultDB)
					end
					self:CopyDefaults(settings, self.defaultDB[status])
					self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
                end
				end
			else
				-- Can't do this because it screws people who play in multiple languages.
				--self:Debug("Removing invalid status:", status)
				--profile[status] = nil
			end
		end
	end
	self.db:RegisterDefaults({ profile = self.defaultDB or {} })
end

function GridStatusAuras:UnregisterStatuses()
	for status, moduleName, desc in self.core:RegisteredStatusIterator() do
		if moduleName == self.moduleName then
			self:UnregisterStatus(status)
			self.options.args[status] = nil
		end
	end
end

local classes = {}
do
	local t = {}
	FillLocalizedClassList(t, false)
	for token, name in pairs(t) do
		classes[token:lower()] = name
	end
end

function GridStatusAuras:OptionsForStatus(status, isBuff)
	local auraOptions = {
		text = {
			name = L["Text"],
			desc = L["Text to display on text indicators"],
			order = 50,
			type = "input",
			get = function()
				return GridStatusAuras.db.profile[status].text
			end,
			set = function(_, v)
				GridStatusAuras.db.profile[status].text = v
				GridStatusAuras:UpdateAllUnitAuras()
			end,
		},
--[[ -- ##DELETE
		class = {
			name = L["Class Filter"],
			desc = L["Show status for the selected classes."],
			order = 200,
			type = "group",
			dialogInline = true,
			hidden = function()
				return not self.db.profile.advancedOptions
			end,
			args = {
				pet = {
					name = L["Pet"],
					desc = L["Show on pets and vehicles."],
					order = -1,
					width = "double",
					type = "toggle",
					get = function()
						return GridStatusAuras.db.profile[status].pet ~= false
					end,
					set = function(_, v)
						GridStatusAuras.db.profile[status].pet = v
						GridStatusAuras:UpdateAllUnitAuras()
					end,
				},
			},
		},
]]
		statusInfo = {
			name = L["Status Information"],
			desc = L["Change what information is displayed using the status color and text."],
			order = 300,
			type = "group",
			dialogInline = true,
			hidden = function()
					return not self.db.profile.advancedOptions
				end,
			args = {
				colorInfo = {
					name = L["Color"],
					desc = L["Change which information is shown by the status color."],
					order = 310,
					width = "double",
					type = "select",
					values = {
						["present"] = L["Present or missing"],
						["duration"] = L["Time left"],
						["count"] = L["Stack count"],
					},
					get = function()
						return self.db.profile[status].statusColor
					end,
					set = function(_, v)
						self.db.profile[status].statusColor = v
						self:UpdateAllUnitAuras()
					end,
				},
				textInfo = {
					name = L["Text"],
					desc = L["Change which information is shown by the status text."],
					order = 320,
					width = "double",
					type = "select",
					values = {
						["name"] = L["Buff name"],
						["duration"] = L["Time left"],
						["count"] = L["Stack count"],
                        ["dur_count"] = L["Time left"] .. " - " .. L["Stack count"],
					},
					get = function()
						return self.db.profile[status].statusText
					end,
					set = function(_, v)
						self.db.profile[status].statusText = v
						self:UpdateAllUnitAuras()
					end,
					hidden = function()
						return not self.db.profile.advancedOptions
					end,
				},
				durationTenths = {
					name = L["Show time left to tenths"],
					desc = L["Show the time left to tenths of a second, instead of only whole seconds."],
					order = 330,
					width = "double",
					type = "toggle",
					get = function()
						return self.db.profile[status].durationTenths
					end,
					set = function(_, v)
						self.db.profile[status].durationTenths = v
						self:UpdateAllUnitAuras()
					end,
					hidden = function()
						return not self.db.profile.advancedOptions or self.db.profile[status].statusText ~= "duration"
					end,
				},
				countSettings = {
					name = format(L["%s colors"], L["Stack count"]),
					desc = format(L["%s colors and threshold values."], L["Stack count"]),
					order = 350,
					type = "group",
					dialogInline = true,
					get = function(info)
						local optionName = info[#info]
						if (info.type == "color") then
							local color = self.db.profile[status][optionName]
							return color.r, color.g, color.b, color.a
						elseif (info.type == "range") then
							return self.db.profile[status][optionName]
						end
					end,
					set = function(info, r, g, b, a)
						local optionName = info[#info]
						if (info.type == "color") then
							local color = self.db.profile[status][optionName]
							color.r = r
							color.g = g
							color.b = b
							color.a = a or 1
						elseif (info.type == "range") then
							self.db.profile[status][optionName] = r
						end
						self:UpdateAllUnitAuras()
					end,
					hidden = function()
						return not self.db.profile.advancedOptions or self.db.profile[status].statusColor ~= "count"
					end,
					args = {
						countColorLow = {
							name = L["Low color"],
							desc = format(L["Color when %s is below the low threshold value."], L["Stack count"]),
							order = 351,
							type = "color",
						},
						countLow = {
							name = L["Low threshold"],
							desc = format(L["%s is low below this value."], L["Stack count"]),
							order = 352,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
						countColorMiddle = {
							name = L["Middle color"],
							desc = format(L["Color when %s is between the low and high threshold values."], L["Stack count"]),
							order = 353,
							width = "full",
							type = "color",
						},
						countColorHigh = {
							name = L["High color"],
							desc = format(L["Color when %s is above the high threshold value."], L["Stack count"]),
							order = 354,
							type = "color",
						},
						countHigh = {
							name = L["High threshold"],
							desc = format(L["%s is high above this value."], L["Stack count"]),
							order = 355,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
					},
				},
				durationSettings = {
					name = format(L["%s colors"], L["Duration"]),
					desc = format(L["%s colors and threshold values."], L["Duration"]),
					order = 360,
					type = "group",
					dialogInline = true,
					get = function(info)
						local optionName = info[#info]
						if (info.type == "color") then
							local color = self.db.profile[status][optionName]
							return color.r, color.g, color.b, color.a
						elseif (info.type == "range") then
							return self.db.profile[status][optionName]
						end
					end,
					set = function(info, r, g, b, a)
						local optionName = info[#info]
						if (info.type == "color") then
							local color = self.db.profile[status][optionName]
							color.r = r
							color.g = g
							color.b = b
							color.a = a or 1
						elseif (info.type == "range") then
							self.db.profile[status][optionName] = r
						end
						self:UpdateAllUnitAuras()
					end,
					hidden = function()
						return not self.db.profile.advancedOptions or self.db.profile[status].statusColor ~= "duration"
					end,
					args = {
						durationColorLow = {
							name = L["Low color"],
							desc = format(L["Color when %s is below the low threshold value."], L["Duration"]),
							order = 361,
							type = "color",
						},
						durationLow = {
							name = L["Low threshold"],
							desc = format(L["%s is low below this value."], L["Duration"]),
							order = 362,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
						durationColorMiddle = {
							name = L["Middle color"],
							desc = format(L["Color when %s is between the low and high threshold values."], L["Duration"]),
							order = 363,
							width = "full",
							type = "color",
						},
						durationColorHigh = {
							name = L["High color"],
							desc = format(L["Color when %s is above the high threshold value."], L["Duration"]),
							order = 364,
							type = "color",
						},
						durationHigh = {
							name = L["High threshold"],
							desc = format(L["%s is high above this value."], L["Duration"]),
							order = 365,
							type = "range",
							min = 0, softMin = 0, max = 99, softMax = 10, step = 1,
						},
					},
				},
				refresh = {
					name = L["Refresh interval"],
					desc = L["Time in seconds between each refresh of the duration status."],
					order = 390,
					width = "double",
					type = "range",
					min = 0.1,
					max = 0.5,
					step = 0.1,
					get = function()
						return self.db.profile[status].refresh
					end,
					set = function(_, v)
						self.db.profile[status].refresh = v
						self:UpdateAllUnitAuras()
					end,
					hidden = function()
						return not self.db.profile.advancedOptions or self.db.profile[status].statusColor ~= "duration"
					end,
				},
			},
		},
	}
--[[ -- ##DELETE
	for class, name in pairs(classes) do
		local class, name = class, name
		auraOptions.class.args[class] = {
			name = name,
			desc = format(L["Show on %s players."], name),
			type = "toggle",
			get = function()
				return GridStatusAuras.db.profile[status][class] ~= false
			end,
			set = function(_, v)
				GridStatusAuras.db.profile[status][class] = v
				GridStatusAuras:UpdateAllUnitAuras()
			end,
		}
	end
]]
	if isBuff then
		auraOptions.statusInfo.args.textInfo.values["name"] = L["Buff name"]
		auraOptions.mine = {
			name = L["Show if mine"],
			desc = L["Display status only if the buff was cast by you."],
			order = 60,
			width = "double",
			type = "toggle",
			get = function()
				return GridStatusAuras.db.profile[status].mine
			end,
			set = function(_, v)
				GridStatusAuras.db.profile[status].mine = v
				GridStatusAuras:DeleteDurationStatus(status)
				GridStatusAuras:UpdateAuraScanList()
				GridStatusAuras:UpdateAllUnitAuras()
			end,
		}
		auraOptions.missing = {
			name = L["Show if missing"],
			desc = L["Display status only if the buff is not active."],
			order = 70,
			width = "double",
			type = "toggle",
			get = function()
				return GridStatusAuras.db.profile[status].missing
			end,
			set = function(_, v)
				GridStatusAuras.db.profile[status].missing = v
				GridStatusAuras:UpdateAllUnitAuras()
			end,
		}
	end

	-- super inefficient...
	for name, found in pairs(debuff_types) do
		if status == found then
			auraOptions.dispellable = {
				name = L["Show only dispellable"],
				desc = format(L["Show %s debuffs only if you can dispel them."], name),
				order = 60,
				width = "double",
				type = "toggle",
				get = function()
					return GridStatusAuras.db.profile[status].dispellable
				end,
				set = function(_, v)
					GridStatusAuras.db.profile[status].dispellable = v
					GridStatusAuras:UpdateAllUnitAuras()
				end,
			}
			break
		end
	end

	return auraOptions
end

function GridStatusAuras:CreateRemoveOptions()
	for status, settings in pairs(self.db.profile) do
		local status = status
		if type(settings) == "table" and settings.text and not default_auras[status] then
			local debuffName = settings.desc or settings.text
			self.options.args.delete_aura.args[status] = {
				name = debuffName,
				desc = format(L["Remove %s from the menu"], debuffName),
				width = "double",
				type = "execute",
				func = function() return
					self:DeleteAura(status)
				end,
			}
		end
	end
end

function GridStatusAuras:AddAura(name, isBuff)
	if strlen(name) < 1 then
		return self:Debug("AddAura failed, no name entered!")
	end

	local status = GridStatusAuras:StatusForSpell(name, isBuff)

	-- status already exists
	if self.db.profile[status] then
		return self:Debug("AddAura failed, status exists!", name, status)
	end

	local desc = isBuff and format(L["Buff: %s"], name) or format(L["Debuff: %s"], name)

	if not self.defaultDB[status] then
		self.defaultDB[status] = {}
		self:CopyDefaults(self.defaultDB[status], statusDefaultDB)
		self.db:RegisterDefaults({ profile = self.defaultDB or {} })
	end

	local settings = {
		text = self:TextForSpell(name),
		desc = desc,
	}
    --163ui support debuff spellId, originName is spellID
    if name:find("^[0-9]+$") then
        local spellID = tonumber(name)
        name = GetSpellInfo(spellID)
        if not name then
            return DEFAULT_CHAT_FRAME:AddMessage("AddAura failed, no spell for id " .. name, 1, 0, 0)
        end
        desc = isBuff and format(L["Buff: %s"], "ID-"..name) or format(L["Debuff: %s"], "ID-"..name)
        settings.text = self:TextForSpell(name)
        settings.desc = desc
        if isBuff then
            settings.buffID = spellID
        else
            settings.debuffID = spellID
        end
    end
	if isBuff then
		settings.buff = name
	else
		settings.debuff = name
	end
	self:CopyDefaults(settings, self.defaultDB[status])
	self.db.profile[status] = settings

	self.options.args.delete_aura.args[status] = {
		name = desc,
		desc = format(L["Remove %s from the menu"], desc),
		width = "double",
		type = "execute",
		func = function()
			return self:DeleteAura(status)
		end,
	}

	local order = isBuff and 15 or 35

	self:RegisterStatus(status, desc, self:OptionsForStatus(status, isBuff), false, order)
	self:OnStatusEnable(status)
end

function GridStatusAuras:DeleteAura(status)
	self:UnregisterStatus(status)
	self.options.args[status] = nil
	self.options.args.delete_aura.args[status] = nil
	self.db.profile[status] = nil
	for indicator, indicatorTbl in pairs(GridFrame.db.profile.statusmap) do
		indicatorTbl[status] = nil
	end
	self:DeleteDurationStatus(status)
	self:UpdateAuraScanList()
end

function GridStatusAuras:UpdateAllUnitAuras()
	for guid, unitid in GridRoster:IterateRoster() do
		self:ScanUnitAuras("UpdateAllUnitAuras", unitid, guid)
	end
end

function GridStatusAuras:Grid_UnitJoined(event, guid, unitid)
	self:ScanUnitAuras(event, unitid, guid)
end

function GridStatusAuras:UpdateDispellable()
	if PLAYER_CLASS == "DRUID" then
		--  88423   Nature's Cure       Restoration                Curse, Poison, Magic
		--   2782   Remove Corruption   Balance, Feral, Guardian   Curse, Poison
		PlayerCanDispel.Curse   = IsPlayerSpell(88423) or IsPlayerSpell(2782)
		PlayerCanDispel.Magic   = IsPlayerSpell(88423)
		PlayerCanDispel.Poison  = IsPlayerSpell(88423) or IsPlayerSpell(2782)

	elseif PLAYER_CLASS == "MONK" then
		 -- 115450   Detox             Mistweaver                  Disease, Poison, Magic
		 -- 218164   Detox             Brewmaster, Windwalker      Disease, Poison
		PlayerCanDispel.Disease = IsPlayerSpell(115450) or IsPlayerSpell(218164)
		PlayerCanDispel.Magic   = IsPlayerSpell(115450)
		PlayerCanDispel.Poison  = IsPlayerSpell(115450) or IsPlayerSpell(218164)

	elseif PLAYER_CLASS == "PALADIN" then
		--   4987   Cleanse           Holy                        Disease, Poison, Magic
		-- 213644   Cleanse Toxins    Protection, Retribution     Disease, Poison
		PlayerCanDispel.Disease = IsPlayerSpell(4987) or IsPlayerSpell(213644)
		PlayerCanDispel.Magic   = IsPlayerSpell(4987)
		PlayerCanDispel.Poison  = IsPlayerSpell(4987) or IsPlayerSpell(213644)

	elseif PLAYER_CLASS == "PRIEST" then
		--    527   Purify            Discipline, Holy            Disease, Magic
		-- 213634   Purify Disease    Shadow                      Disease
		PlayerCanDispel.Disease = IsPlayerSpell(527) or IsPlayerSpell(213634)
		PlayerCanDispel.Magic   = IsPlayerSpell(527)

	elseif PLAYER_CLASS == "SHAMAN" then
		--  77130   Purify Spirit      Restoration                 Curse, Magic
		--  51886   Cleanse Spirit     Elemental, Enhancement      Curse
		PlayerCanDispel.Curse   = IsPlayerSpell(77130) or IsPlayerSpell(51886)
		PlayerCanDispel.Magic   = IsPlayerSpell(77130)

	elseif PLAYER_CLASS == "WARLOCK" then
		-- 115276   Sear Magic (Fel Imp)
		--  89808   Singe Magic (Imp)
		PlayerCanDispel.Magic   = IsPlayerSpell(115276, true) or IsPlayerSpell(89808, true)
	end
end

-- Unit Aura Driver
--
-- Primary Requirements:
-- * Identify the presence of known buffs by name.
-- * Identify the presence of known buffs by name that are cast by the player.
-- * Identify the presence of known debuffs by name.
-- * Identify the presence of unknown debuffs by dispel type.
--
-- * The ability to filter all of the above by class.
--
-- Optional/Secondary Requirements:
-- * Identify the absence of known buffs by name.
-- * Identify the absence of known buffs by name that are cast by the player.

-- Proposal:
-- * Iterate over known buff names and call UnitAura(unit, name, "HELPFUL") for
--   each one.  It is likely that the list of buff names is shorter than the
--   number of buffs on the unit.
-- * Iterate over known buff names that are cast by the player and call
--   UnitAura(unit, name, "HELPFUL|PLAYER") for each one.  It is likely that the
--   combined list of buff names and buff names that are cast by the player is
--   shorter than the number of buffs on the unit.
-- * Iterate over all debuffs on the unit by calling
--   UnitAura(unit, index, "HARMFUL").  It is likely that the list of debuffs is
--   longer than the number of debuffs on the unit.  While scanning the debuffs
--   keep track of each debuff type seen and information about the last debuff
--   of that type seen.

-- Note:
-- * As of WoW 8.0, UnitAura no longer accepts a name, only an index, so we
--   now necessarily iterate over all buffs on the unit. The above information
--   is preserved for historical interest.

-- durationAuras[status][guid] = { <aura properties> }
GridStatusAuras.durationAuras = {}
GridStatusAuras.durationTimer = {
	timer = nil,
	refresh = nil,
	minRefresh = nil,
}

local GetTime = GetTime
local now = GetTime()

local ICON_TEX_COORDS = { left = 0.06, right = 0.94, top = 0.06, bottom = 0.94 }

-- Simple resource pool implemented as a singly-linked list.
local Pool = {
	pool = nil,
	new = function(self, obj) -- create new Pool object
		obj = obj or {}
		setmetatable(obj, self)
		self.__index = self
		return obj
	end,
	get = function(self) -- get a cleaned item from the pool
		if not self.pool then self.pool = { nextPoolItem = self.pool } end
		local item = self.pool
		self.pool = self.pool.nextPoolItem
		item.nextPoolItem = nil
		if self.clean then
			self:clean(item)
		end
		return item
	end,
	put = function(self, item) -- put an item back into the pool; caller shall remove references to item
		item.nextPoolItem = self.pool
		self.pool = item
	end,
	clean = nil, -- called in Pool:new() to return a "cleaned" pool item
	empty = function(self) -- empty the pool
		while self.pool do
			local l = self.pool
			self.pool = self.pool.nextPoolItem
			l = nil
		end
	end,
}

-- durationAuraPool is a Pool of tables used by durationAuras[status][guid]
local durationAuraPool = Pool:new(
	{
		clean = function(self, item)
			item.duration = nil
			item.expirationTime = nil
		end
	}
)

function GridStatusAuras:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	local timer = self.durationTimer
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and (settings.statusText == "duration" or settings.statusColor == "duration" or settings.statusText == "dur_count") then
		if not self.durationAuras[status] then
			self.durationAuras[status] = {}
		end
		if not self.durationAuras[status][guid] then
			self.durationAuras[status][guid] = durationAuraPool:get()
		end
		self.durationAuras[status][guid] = {
			class = class,
			rank = rank,
			icon = icon,
			count = count,
			debuffType = debuffType,
			duration = duration,
			expirationTime = expirationTime,
			caster = caster,
			isStealable = isStealable,
		}
		if not timer.minRefresh or settings.refresh < timer.minRefresh then
			timer.minRefresh = settings.refresh
		end
	else
		self:UnitLostDurationStatus(status, guid, class, name)
	end
end

function GridStatusAuras:UnitLostDurationStatus(status, guid, class, name)
	local auras = self.durationAuras[status]
	if auras and auras[guid] then
		durationAuraPool:put(auras[guid])
		auras[guid] = nil
	end
end

function GridStatusAuras:DeleteDurationStatus(status)
	local auras = self.durationAuras[status]
	if not auras then return end
	for guid in pairs(auras) do
		durationAuraPool:put(auras[guid])
		auras[guid] = nil
	end
	self.durationAuras[status] = nil
end

function GridStatusAuras:ResetDurationStatuses()
	for status in pairs(self.durationAuras) do
		self:DeleteDurationStatus(status)
	end
	durationAuraPool:empty()
end

function GridStatusAuras:HasActiveDurations()
	for status, auras in pairs(self.durationAuras) do
		for guid in pairs(auras) do
			return true
		end
	end
	return false
end

function GridStatusAuras:ResetDurationTimer(hasActiveDurations)
	local timer = self.durationTimer
	if hasActiveDurations then
		if timer.timer and timer.refresh and timer.minRefresh ~= timer.refresh then
			self:Debug("ResetDurationTimer: cancel timer", timer.minRefresh, timer.refresh)
			self:CancelTimer(timer.timer, true)
		end
		timer.refresh = timer.minRefresh
		if not timer.timer then
			self:Debug("ResetDurationTimer: set timer", timer.refresh)
			timer.timer = self:ScheduleRepeatingTimer("RefreshActiveDurations", timer.refresh)
		end
	else
		if timer.timer then
			self:Debug("ResetDurationTimer: cancel timer")
			self:CancelTimer(timer.timer, true)
		end
		timer.timer = nil
		timer.refresh = nil
	end
end

function GridStatusAuras:StatusTextColor(settings, count, timeLeft)
	local text, color

	count = count or 0
	timeLeft = timeLeft or 0

	if settings.statusText == "name" then
		text = settings.text
	elseif settings.statusText == "count" then
		text = n2s(count)
	elseif settings.statusText == "duration" then
		if settings.durationTenths then
			text = f2s(timeLeft, 1)
		else
			text = n2s(floor(timeLeft+.5))
		end
	elseif settings.statusText == "dur_count" then
		text = n2s(floor(timeLeft+.5)) .. (count > 0 and "-" .. n2s(count) or "")
	end

	if settings.missing or settings.statusColor == "present" then
		color = settings.color
	elseif settings.statusColor == "duration" then
		if timeLeft <= settings.durationLow then
			color = settings.durationColorLow
		elseif timeLeft <= settings.durationHigh then
			color = settings.durationColorMiddle
		else
			color = settings.durationColorHigh
		end
	elseif settings.statusColor == "count" then
		if count <= settings.countLow then
			color = settings.countColorLow
		elseif count <= settings.countHigh then
			color = settings.countColorMiddle
		else
			color = settings.countColorHigh
		end
	end

	return text, color
end

function GridStatusAuras:RefreshActiveDurations()
	now = GetTime()

	self:Debug("RefreshActiveDurations", now)

	for status, guids in pairs(self.durationAuras) do
		local settings = self.db.profile[status]
		if settings and settings.enable and not settings.missing then -- and settings[class] ~= false then -- ##DELETE
			for guid, aura in pairs(guids) do
				local count, duration, expirationTime, icon = aura.count, aura.duration, aura.expirationTime, aura.icon
				local start = expirationTime and (expirationTime - duration)
				local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
				local text, color = self:StatusTextColor(settings, count, timeLeft)
				self.core:SendStatusGained(guid,
					status,
					settings.priority,
					nil,
					color,
					text,
					count,
					nil,
					icon,
					start,
					duration,
					count,
					ICON_TEX_COORDS)
			end
	--	else
	--		self.core:SendStatusLost(guid, status) -- XXX "guid" is undefined=nil here; what is the purpose?!
		end
	end
end

function GridStatusAuras:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedBuff", guid, class, name)

	local status = buff_names[name]
	local settings = status and self.db.profile[status]
	if not settings then return end

	settings.icon = icon

	if settings.enable and not settings.missing then -- and settings[class] ~= false then -- ##DELETE
		local start = expirationTime and (expirationTime - duration)  --and settings.statusText ~= "count" and settings.statusText ~= "dur_count"  --163ui GID Text force show timeleft 
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostBuff(guid, class, name)
	--self:Debug("UnitLostBuff", guid, class, name)

	local status = buff_names[name]
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing then -- and settings[class] ~= false then -- ##DELETE
		local text, color = self:StatusTextColor(settings, 0, 0)
		self:UnitLostDurationStatus(status, guid, class, name)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			nil,
			nil,
			settings.icon,
			nil,
			nil,
			nil,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
	self:Debug("UnitGainedPlayerBuff", guid, name)

	local status = player_buff_names[name]
	local settings = self.db.profile[status]
	if not settings then return end

	settings.icon = icon

	if settings.enable and not settings.missing then -- and settings[class] ~= false then -- ##DELETE
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostPlayerBuff(guid, class, name)
	--self:Debug("UnitLostPlayerBuff", guid, name)

	local status = player_buff_names[name]
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and settings.missing then -- and settings[class] ~= false then -- ##DELETE
		local text, color = self:StatusTextColor(settings, 0, 0)
		self:UnitLostDurationStatus(status, guid, class, name)
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			nil,
			nil,
			settings.icon,
			nil,
			nil,
			nil,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitGainedDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
	self:Debug("UnitGainedDebuff", guid, class, name)

	local status = debuff_names[name]
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable then -- and settings[class] ~= false then -- ##DELETE
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostDebuff(guid, class, name)
	--self:Debug("UnitLostDebuff", guid, class, name)
	local status = debuff_names[name]
	local settings = self.db.profile[status]
	if not settings then return end

	self:UnitLostDurationStatus(status, guid, class, name)
	self.core:SendStatusLost(guid, status)
end

function GridStatusAuras:UnitGainedDebuffType(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
	self:Debug("UnitGainedDebuffType", guid, class, debuffType)

	local status = debuffType and debuff_types[debuffType]
	local settings = self.db.profile[status]
	if not settings then return end

	if settings.enable and (PlayerCanDispel[debuffType] or not settings.dispellable) then -- and settings[class] ~= false then -- ##DELETE
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostDebuffType(guid, class, debuffType)
	--self:Debug("UnitLostDebuffType", guid, class, debuffType)

	local status = debuffType and debuff_types[debuffType]
	local settings = self.db.profile[status]
	if not settings then return end

	self:UnitLostDurationStatus(status, guid, class, debuffType)
	self.core:SendStatusLost(guid, status)
end

function GridStatusAuras:UnitGainedBossDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
	local status = "boss_aura"
	local settings = self.db.profile[status]
	if settings.enable then
		local start = expirationTime and (expirationTime - duration)
		local timeLeft = expirationTime and expirationTime > now and (expirationTime - now) or 0
		local text, color = self:StatusTextColor(settings, count, timeLeft)
		if duration and expirationTime and duration > 0 and expirationTime > 0 then
			self:UnitGainedDurationStatus(status, guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
		end
		self.core:SendStatusGained(guid,
			status,
			settings.priority,
			nil,
			color,
			text,
			count,
			nil,
			icon,
			start,
			duration,
			count,
			ICON_TEX_COORDS)
	else
		self.core:SendStatusLost(guid, status)
	end
end

function GridStatusAuras:UnitLostBossDebuff(guid, class, name)
	--self:Debug("UnitLostBossDebuff", guid, class, name)
	local status = "boss_aura"

	self:UnitLostDurationStatus(status, guid, class, name)
	self.core:SendStatusLost(guid, status)
end

local assigned = {} --163ui if an aura is assign to at least one indicator
function GridStatusAuras:UpdateAuraScanList()
	self:Debug("UpdateAuraScanList")

	wipe(buff_names)
	wipe(player_buff_names)
	wipe(debuff_names)

    wipe(assigned)
    for indicator, tbl in pairs(GridFrame.db.profile.statusmap) do
        for status, v in pairs(tbl) do
            if v then
                assigned[status] = true
            end
        end
    end

	for status, settings in pairs(self.db.profile) do
		if type(settings) == "table" and settings.enable and assigned[status] then
			local name = settings.buff or settings.debuff
			self:Debug(status, name)

			if name and not debuff_types[name] then
				local isBuff = not not settings.buff

				if isBuff then
					if settings.mine then
						self:Debug("Added to player_buff_names")
						player_buff_names[settings.buffID or name] = status
					else
						self:Debug("Added to buff_names")
						buff_names[settings.buffID or name] = status
					end
				else
					self:Debug("Added to debuff_names")
					debuff_names[settings.debuffID or name] = status --163ui
				end
			end
		end
	end
end

-- temp tables
local buff_names_seen = {}
local player_buff_names_seen = {}
local debuff_names_seen = {}
local debuff_types_seen = {}

function GridStatusAuras:ScanUnitAuras(event, unit, guid)
	if not guid then guid = UnitGUID(unit) end
	if not GridRoster:IsGUIDInRaid(guid) then
		return
	end

	local seenBossAura

	local _, class
	--[[ -- ##DELETE
	if UnitIsPlayer(unit) then
		_, class = UnitClass(unit)
		if class then
			class = class:lower()
		end
	else
		class = "pet" -- should catch pets, vehicles, and anything else
	end
	]]

	self:Debug("UNIT_AURA", unit, guid)

	now = GetTime()

	for status, auras in pairs(self.durationAuras) do
		if auras[guid] then
			durationAuraPool:put(auras[guid])
			auras[guid] = nil
		end
	end

	if UnitIsVisible(unit) then
		for i = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, _, spellID
			if IS_WOW_8 then
				name, icon, count, debuffType, duration, expirationTime, caster, isStealable, _, spellID = UnitAura(unit, i, "HELPFUL")
			else
				name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable, _, spellID = UnitAura(unit, i, "HELPFUL")
			end

			if not name then
				break
			end

			-- scan for buffs
			if buff_names[spellID] then
				buff_names[spellID] = true
				self:UnitGainedBuff(guid, class, spellID, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
			elseif buff_names[name] then
				buff_names_seen[name] = true
				self:UnitGainedBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
			end

			-- scan for buffs cast by the player
			if caster == 'player' then
				if player_buff_names[spellID] then
					player_buff_names_seen[spellID] = true
					self:UnitGainedPlayerBuff(guid, class, spellID, nil, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				elseif player_buff_names[name] then
				player_buff_names_seen[name] = true
				self:UnitGainedPlayerBuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, caster, isStealable)
				end
			end
		end

		-- scan for debuffs
		for index = 1, 40 do
			local name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer
			if IS_WOW_8 then
				name, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer = UnitAura(unit, index, "HARMFUL")
			else
				name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer = UnitAura(unit, index, "HARMFUL")
			end

			if not name then
				break
			end

			if debuff_names[spellID] then
                		debuff_names_seen[spellID] = true
                		self:UnitGainedDebuff(guid, class, spellID, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
            		elseif debuff_names[name] then
				debuff_names_seen[name] = true
				self:UnitGainedDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
			--[[
			elseif isBossAura then
				seenBossAura = true
				self:UnitGainedBossDebuff(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
			]]
			elseif debuff_types[debuffType] then
				-- elseif so that a named debuff doesn't trigger the type status
				debuff_types_seen[debuffType] = true
				self:UnitGainedDebuffType(guid, class, name, rank, icon, count, debuffType, duration, expirationTime, casterUnit, canStealOrPurge, shouldConsolidate, spellID, canApply, isBossAura, isCastByPlayer)
			end
		end
	end

	-- handle lost buffs
	for name in pairs(buff_names) do
		if not buff_names_seen[name] then
			self:UnitLostBuff(guid, class, name)
		else
			buff_names_seen[name] = nil
		end
	end

	for name in pairs(player_buff_names) do
		if not player_buff_names_seen[name] then
			self:UnitLostPlayerBuff(guid, class, name)
		else
			player_buff_names_seen[name] = nil
		end
	end

	-- handle lost debuffs
	for name in pairs(debuff_names) do
		if not debuff_names_seen[name] then
			self:UnitLostDebuff(guid, class, name)
		else
			debuff_names_seen[name] = nil
		end
	end

	for debuffType in pairs(debuff_types) do
		if not debuff_types_seen[debuffType] then
			self:UnitLostDebuffType(guid, class, debuffType)
		else
			debuff_types_seen[debuffType] = nil
		end
	end
--[[
	if not seenBossAura then
		self:UnitLostBossDebuff(guid, class)
	end
]]
	self:ResetDurationTimer(self:HasActiveDurations())
end
