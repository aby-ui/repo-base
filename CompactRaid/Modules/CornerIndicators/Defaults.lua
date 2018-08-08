------------------------------------------------------------
-- Defaults.lua
--
-- Abin
-- 2010/10/30
------------------------------------------------------------

local type = type
local pairs = pairs
local wipe = wipe
local strfind = strfind
local tonumber = tonumber
local GetSpellInfo = GetSpellInfo

local module = CompactRaid:GetModule("CornerIndicators")
if not module then return end

module.DEFAULT_SPELLS = {
	HUNTER = {
		34477, -- Misdirection
		136, -- Heal pet
	},

	PRIEST = {
		139, -- Renew
		17, -- Power Word: Shield
		33076, -- Prayer of Mending
	},

	DRUID = {
		774, -- Rejuvenation
		8936, -- Regrowth
		22812, -- Barkskin
		33763, -- Lifebloom
		48438, -- Wild Growth
		29166, -- Innervate
		102342, -- Ironbark
		155777, -- Germination
	},

	SHAMAN = {
		974, -- Earth Shield
		61295, -- Riptide
	},

	PALADIN = {
		53563, -- Beacon of Light
		203539, -- Blessing of wisdom
		203528, -- Blessing of might
		203538, -- Blessing of Kings
		1038, -- Hand of Salvation
		1044, -- Hand of Freedom
		1022, -- Hand of Protection
		6940, -- Hand of Sacrifice
	},

	WARRIOR = {
		114030, -- Vigilance
	},

	MAGE = {
		130, -- Slow Fall
	},

	WARLOCK = {
		5697, -- Unending Breath
		20707, -- Soulstone Resurrection
	},

	DEATHKNIGHT = {
	},

	MONK = {
		115151, -- Renewing Mist
		124682, -- Enveloping Mist
		116849, -- Life Cocoon
	},

	DEMONHUNTER = {
	},
}

local CLASS_DEFAULTS = {
	HUNTER = {
		TOPLEFT = { spell = 136, numeric = 1 }, -- Heal pet
		TOPRIGHT = { spell = 34477, other = 1 }, -- Misdirection
	},

	PRIEST = {
		TOPLEFT = { spell = 139, numeric = 1 }, -- Renew
		BOTTOMLEFT = { spell = 33076, other = 1 }, -- Prayer of Mending
		TOPRIGHT = { spell = 17, other = 1 }, -- Power Word: Shield
		--BOTTOMRIGHT = { spell = 21562, other = 1, lacks = 1 }, -- Power Word: Fortitude
	},

	DRUID = {
		TOPLEFT = { spell = 774, numeric = 1 }, -- Rejuvenation
		BOTTOMLEFT = { spell = 33763, numeric = 1 }, -- Lifebloom
		TOPRIGHT = { spell = 48438, numeric = 1 }, -- Wild Growth
		BOTTOMRIGHT = { spell = 1126, other = 1, lacks = 1 }, -- Mark of the Wild
	},

	SHAMAN = {
		TOPLEFT = { spell = 974 }, -- Earth Shield
		TOPRIGHT = { spell = 61295, numeric = 1 }, -- Riptide
	},

	PALADIN = {
		TOPLEFT = { spell = 53563, numeric = 1 }, -- Beacon of Light
		--TOPRIGHT = { spell = 203538, other = 1, lacks = 1 }, -- Blessing of Kings
		--BOTTOMLEFT = { spell = 203528, other = 1, lacks = 1 }, -- Blessing of Might
		--BOTTOMRIGHT = { spell = 203539, other = 1, lacks = 1 }, -- Blessing of wisdom
	},

	WARRIOR = {
		TOPLEFT = { spell = 50720, other = 1 }, -- Vigilance
	},

	MAGE = {
		TOPLEFT = { spell = 130, other = 1 }, -- Slow fall
	},

	WARLOCK = {
		TOPLEFT = { spell = 20707, other = 1 }, -- Soulstone Resurrection
		TOPRIGHT = { spell = 5697, other = 1 }, -- Unending Breath
	},

	DEATHKNIGHT = {
	},

	MONK = {
		TOPLEFT = { spell = 115151, numeric = 1 }, -- Renewing Mist
		TOPRIGHT = { spell = 124682, numeric = 1 }, -- Enveloping Mist
		BOTTOMLEFT = { spell = 116849, other = 1 }, -- Life Cocoon
	},

	DEMONHUNTER = {
	},
}

local DEFAULTS_INDICATOR = {
	style = 1,
	ignoreOutRanged = 1,
	r = 0, g = 1, b = 0,
	["1"] = { threshold = 50, r = 1, g = 1, b = 0, },
	["2"] = { threshold = 3, r = 1, g = 0, b = 0, },
}

local OPTION_KEYS = {
	aura = "string",
	style = 1,
	selfcast = "1/nil",
	showlacks = "1/nil",
	ignorePhysical = "1/nil",
	ignoreMagical = "1/nil",
	ignoreVehicle = "1/nil",
	scale = 100,
	xoffset = 0,
	yoffset = 0,
	r1 = 0,
	g1 = 1,
	b1 = 0,
	threshold2 = 50,
	r2 = 1,
	g2 = 1,
	b2 = 0,
	threshold3 = 5,
	r3 = 1,
	g3 = 0,
	b3 = 0,
}

function module:EncodeData(db)
	if type(db) ~= "table" or not db.aura or db.aura == "" then
		return
	end

	local key, def, text
	for key, def in pairs(OPTION_KEYS) do
		local value = db[key]
		local isColor = type(value) == "number" and strlen(key) == 2 and strfind(key, "(.+)(%d+)")
		if isColor then
			value = format("%.1f", value)
		end

		if value and value ~= def then
			if text then
				text = text.."["..key.."]#"..value.."#"
			else
				text = "["..key.."]#"..value.."#"
			end
		end
	end

	return text
end

function module:DecodeData(text, db)
	if type(db) == "table" then
		wipe(db)
	else
		db = {}
	end

	if type(text) ~= "string" then
		text = ""
	end

	local key, def
	for key, def in pairs(OPTION_KEYS) do
		local _, _, value = strfind(text, "%["..key.."%]#(.-)#")
		if value then
			if key == "aura" then
				db[key] = value
			else
				db[key] = tonumber(value)
			end
		elseif type(def) == "number" then
			db[key] = def
		end
	end

	return db
end

local CLASS = select(2, UnitClass("player"))

function GetClassDefaults(corner)
	local data = CLASS_DEFAULTS[CLASS]
	data = data and data[corner]
	if data then
		return data.spell, data.numeric, data.other, data.lacks, data.ignorePhysical, data.ignoreMagical
	end
end

local defaultdb = {}

local _, key
for _, key in ipairs(module.INDICATOR_KEYS) do
	local data = {}
	CompactRaid.tcopy(DEFAULTS_INDICATOR, data)
	local spell, numeric, other, lacks, ignorePhysical, ignoreMagical = GetClassDefaults(key)
	if spell then
		data.aura = GetSpellInfo(spell)
		data.style = numeric and 2 or 1
		data.selfcast = not other and 1 or nil
		data.showlacks = lacks
		data.ignorePhysical = ignorePhysical
		data.ignoreMagical = ignoreMagical
		data.ignoreVehicle = other or lacks or ignorePhysical or ignoreMagical
	end

	defaultdb[key] = module:EncodeData(data)
end

function module:GetDefaultDB(key)
	if key == "talent" then
		return defaultdb
	end
end
