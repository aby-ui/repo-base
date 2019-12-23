local L = ShadowUF.L
local playerClass = select(2, UnitClass("player"))

local function finalizeData(config, useMerge)
	local self = ShadowUF
	-- Merges all of the parentUnit options into the child if they weren't set.
	-- if it's a table, it recurses inside the table and copies any nil values in too
	local function mergeToChild(parent, child, forceMerge)
		for key, value in pairs(parent) do
			if( type(child[key]) == "table" ) then
				mergeToChild(value, child[key], forceMerge)
			elseif( type(value) == "table" ) then
				child[key] = CopyTable(value)
			elseif( forceMerge or ( value ~= nil and child[key] == nil ) ) then
				child[key] = value
			end
		end
	end

	-- This makes sure that the unit has no values it shouldn't, for example if the defaults do not set incHeal for targettarget
	-- and I try to set incHeal table here, then it'll remove it since it can't do that.
	local function verifyTable(tbl, checkTable)
		for key, value in pairs(tbl) do
			if( type(value) == "table" ) then
				if( not checkTable[key] ) then
					tbl[key] = nil
				else
					for subKey, subValue in pairs(value) do
						if( type(subValue) == "table" ) then
							verifyTable(value, checkTable[key])
						end
					end
				end
			end
		end
	end

	-- Set everything
	for unit, child in pairs(config.units) do
		if( self.defaults.profile.units[unit] ) then
			if( not useMerge or ( useMerge and not self.db.profile.units[unit].enabled and self.db.profile.units[unit].height == 0 and self.db.profile.units[unit].width == 0 and self.db.profile.positions[unit].anchorPoint == "" and self.db.profile.positions[unit].point == "" ) ) then
				-- Merge the primary parent table
				mergeToChild(config.parentUnit, child)
				-- Strip any invalid tables
				verifyTable(child, self.defaults.profile.units[unit])
				-- Merge the new child table into the actual units
				mergeToChild(child, self.db.profile.units[unit], true)

				-- Merge position in too
				if( useMerge and self.db.profile.positions[unit].point == "" and self.db.profile.positions[unit].relativePoint == "" and self.db.profile.positions[unit].anchorPoint == "" and self.db.profile.positions[unit].x == 0 and self.db.profile.positions[unit].y == 0 ) then
					self.db.profile.positions[unit] = config.positions[unit]
				end
			end
		end
	end

	self.db.profile.loadedLayout = true

	if( not useMerge ) then
		config.parentUnit = nil
		config.units = nil

		for key, data in pairs(config) do
			self.db.profile[key] = data
		end
	else
		for key, data in pairs(config) do
			if( key ~= "parentUnit" and key ~= "units" and key ~= "positions" and key ~= "hidden" ) then
				if( self.db.profile[key] == nil ) then
					self.db.profile[key] = data
				else
					for subKey, subValue in pairs(data) do
						if( self.db.profile[key][subKey] == nil ) then
							self.db.profile[key][subKey] = subValue
						end
					end
				end
			end
		end
	end
end

function ShadowUF:LoadDefaultLayout(useMerge)
	local config = {}
	config.bars = {
		texture = "Minimalist",
		spacing = -1.25,
		alpha = 1.0,
		backgroundAlpha = 0.20,
	}
	config.auras = {
		borderType = "light",
	}
	config.backdrop = {
		tileSize = 1,
		edgeSize = 5,
		clip = 1,
		inset = 3,
		backgroundTexture = "Chat Frame",
		backgroundColor = {r = 0, g = 0, b = 0, a = 0.80},
		borderTexture = "None",
		borderColor = {r = 0.30, g = 0.30, b = 0.50, a = 1},
	}
	config.hidden = {
		cast = false, buffs = false, party = true, player = true, pet = true, target = true, focus = true, boss = true, arena = true, playerAltPower = false, playerPower = true
	}
	config.font = {
		name = "Myriad Condensed Web",
		size = 11,
		extra = "",
		shadowColor = {r = 0, g = 0, b = 0, a = 1},
		color = {r = 1, g = 1, b = 1, a = 1},
		shadowX = 1.00,
		shadowY = -1.00,
	}

	-- Some localizations do not work with Myriad Condensed Web, need to automatically swap it to a localization that will work for it
	local SML = LibStub:GetLibrary("LibSharedMedia-3.0")
	if( GetLocale() == "koKR" or GetLocale() == "zhCN" or GetLocale() == "zhTW" ) then
		config.font.name = SML.DefaultMedia.font
	end

	config.auraColors = {
		removable = {r = 1, g = 1, b = 1}
	}

	config.classColors = {
		HUNTER = {r = 0.67, g = 0.83, b = 0.45},
		WARLOCK = {r = 0.58, g = 0.51, b = 0.79},
		PRIEST = {r = 1.0, g = 1.0, b = 1.0},
		PALADIN = {r = 0.96, g = 0.55, b = 0.73},
		MAGE = {r = 0.41, g = 0.8, b = 0.94},
		ROGUE = {r = 1.0, g = 0.96, b = 0.41},
		DRUID = {r = 1.0, g = 0.49, b = 0.04},
		SHAMAN = {r = 0.14, g = 0.35, b = 1.0},
		WARRIOR = {r = 0.78, g = 0.61, b = 0.43},
		DEATHKNIGHT = {r = 0.77, g = 0.12 , b = 0.23},
		MONK = {r = 0.0, g = 1.00 , b = 0.59},
		DEMONHUNTER = {r = 0.64, g = 0.19, b = 0.79},
		PET = {r = 0.20, g = 0.90, b = 0.20},
		VEHICLE = {r = 0.23, g = 0.41, b = 0.23},
	}
	config.powerColors = {
		MANA = {r = 0.30, g = 0.50, b = 0.85},
		RAGE = {r = 0.90, g = 0.20, b = 0.30},
		FOCUS = {r = 1.0, g = 0.50, b = 0.25},
		ENERGY = {r = 1.0, g = 0.85, b = 0.10},
		RUNES = {r = 0.50, g = 0.50, b = 0.50},
		RUNIC_POWER = {b = 0.60, g = 0.45, r = 0.35},
		AMMOSLOT = {r = 0.85, g = 0.60, b = 0.55},
		FUEL = {r = 0.85, g = 0.47, b = 0.36},
		COMBOPOINTS = {r = 1.0, g = 0.80, b = 0.0},
		INSANITY = {r = 0.40, g = 0, b = 0.80},
		MAELSTROM = {r = 0.00, g = 0.50, b = 1.00},
		LUNAR_POWER = {r = 0.30, g = 0.52, b = 0.90},
		HOLYPOWER = {r = 0.95, g = 0.90, b = 0.60},
		SOULSHARDS = {r = 0.58, g = 0.51, b = 0.79},
		ARCANECHARGES = {r = 0.1, g = 0.1, b = 0.98},
		ALTERNATE = {r = 0.815, g = 0.941, b = 1},
		CHI = {r = 0.71, g = 1.0, b = 0.92},
		FURY = {r = 0.788, g = 0.259, b = 0.992},
		PAIN = {r = 1, g = 0, b = 0},
		STATUE = {r = 0.35, g = 0.45, b = 0.60},
		RUNEOFPOWER = {r = 0.35, g = 0.45, b = 0.60},
		MUSHROOMS = {r = 0.20, g = 0.90, b = 0.20},
		AURAPOINTS = {r = 1.0, g = 0.80, b = 0.0},
		STAGGER_GREEN = {r = 0.52, g = 1.0, b = 0.52},
		STAGGER_YELLOW = {r = 1.0, g = 0.98, b = 0.72},
		STAGGER_RED = {r = 1.0, g = 0.42, b = 0.42},
	}
	config.healthColors = {
		tapped = {r = 0.5, g = 0.5, b = 0.5},
		red = {r = 0.90, g = 0.0, b = 0.0},
		green = {r = 0.20, g = 0.90, b = 0.20},
		static = {r = 0.70, g = 0.20, b = 0.90},
		yellow = {r = 0.93, g = 0.93, b = 0.0},
		inc = {r = 0, g = 0.35, b = 0.23},
		incAbsorb = {r = 0.93, g = 0.75, b = 0.09},
		healAbsorb = {r = 0.68, g = 0.47, b = 1},
		enemyUnattack = {r = 0.60, g = 0.20, b = 0.20},
		hostile = {r = 0.90, g = 0.0, b = 0.0},
		aggro = {r = 0.90, g = 0.0, b = 0.0},
		friendly = {r = 0.20, g = 0.90, b = 0.20},
		neutral = {r = 0.93, g = 0.93, b = 0.0},
		offline = {r = 0.50, g = 0.50, b = 0.50}
	}
	config.castColors = {
		channel = {r = 0.25, g = 0.25, b = 1.0},
		cast = {r = 1.0, g = 0.70, b = 0.30},
		interrupted = {r = 1, g = 0, b = 0},
		uninterruptible = {r = 0.71, g = 0, b = 1},
		finished = {r = 0.10, g = 1.0, b = 0.10},
	}
	config.xpColors = {
		normal = {r = 0.58, g = 0.0, b = 0.55},
		rested = {r = 0.0, g = 0.39, b = 0.88},
	}

	config.positions = {
		targettargettarget = {anchorPoint = "RC", anchorTo = "#SUFUnittargettarget", x = 0, y = 0},
		targettarget = {anchorPoint = "TL", anchorTo = "#SUFUnittarget", x = 0, y = 0},
		focustarget = {anchorPoint = "TL", anchorTo = "#SUFUnitfocus", x = 0, y = 0},
		party = {point = "TOPLEFT", anchorTo = "#SUFUnitplayer", relativePoint = "TOPLEFT", movedAnchor = "TL", x = 0, y = -60},
		focus = {anchorPoint = "RB", anchorTo = "#SUFUnittarget", x = 35, y = -4},
		target = {anchorPoint = "RC", anchorTo = "#SUFUnitplayer", x = 50, y = 0},
		player = {point = "TOPLEFT", anchorTo = "UIParent", relativePoint = "TOPLEFT", y = -25, x = 20},
		pet = {anchorPoint = "TL", anchorTo = "#SUFUnitplayer", x = 0, y = 0},
		pettarget = {anchorPoint = "C", anchorTo = "UIParent", x = 0, y = 0},
		partypet = {anchorPoint = "RB", anchorTo = "$parent", x = 0, y = 0},
		partytarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		partytargettarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		raid = {anchorPoint = "C", anchorTo = "UIParent", x = 0, y = 0},
		raidpet = {anchorPoint = "C", anchorTo = "UIParent", x = 0, y = 0},
		maintank = {anchorPoint = "C", anchorTo = "UIParent", x = 0, y = 0},
		maintanktarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		maintanktargettarget = {anchorPoint = "RT", anchorTo = "$parent", x = 150, y = 0},
		mainassist = {anchorPoint = "C", anchorTo = "UIParent", x = 0, y = 0},
		mainassisttarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		mainassisttargettarget = {anchorPoint = "RT", anchorTo = "$parent", x = 150, y = 0},
		arena = {anchorPoint = "C", anchorTo = "UIParent", point = "", relativePoint = "", x = 0, y = 0},
		arenapet = {anchorPoint = "RB", anchorTo = "$parent", x = 0, y = 0},
		arenatarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		arenatargettarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		battleground = {anchorPoint = "C", anchorTo = "UIParent", point = "", relativePoint = "", x = 0, y = 0},
		battlegroundpet = {anchorPoint = "RB", anchorTo = "$parent", x = 0, y = 0},
		battlegroundtarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		battlegroundtargettarget = {anchorPoint = "RT", anchorTo = "$parent", x = 0, y = 0},
		boss = {anchorPoint = "C", anchorTo = "UIParent", point = "", relativePoint = "", x = 0, y = 0},
		bosstarget = {anchorPoint = "RB", anchorTo = "$parent", x = 0, y = 0},
		bosstargettarget = {anchorPoint = "RB", anchorTo = "$parent", x = 0, y = 0},
	}

	-- Parent unit options that all the children will inherit unless they override it
	config.parentUnit = {
		portrait = {enabled = false, type = "3D", alignment = "LEFT", width = 0.22, height = 0.50, order = 15, fullBefore = 0, fullAfter = 100},
		auras = {
			buffs = {enabled = false, anchorPoint = "BL", size = 16, perRow = 10, x = 0, y = 0, show = {player = true, boss = true, raid = true, misc = true}, enlarge = {}, timers = {ALL = true}},
			debuffs = {enabled = false, anchorPoint = "BL", size = 16, perRow = 10, x = 0, y = 0, show = {player = true, boss = true, raid = true, misc = true}, enlarge = {SELF = true}, timers = {ALL = true}},
		},
		text = {
			{width = 0.50, name = L["Left text"], anchorTo = "$healthBar", anchorPoint = "CLI", x = 3, y = 0, size = 0, default = true},
			{width = 0.60, name = L["Right text"], anchorTo = "$healthBar", anchorPoint = "CRI", x = -3, y = 0, size = 0, default = true},

			{width = 0.50, name = L["Left text"], anchorTo = "$powerBar", anchorPoint = "CLI", x = 3, y = 0, size = 0, default = true},
			{width = 0.60, name = L["Right text"], anchorTo = "$powerBar", anchorPoint = "CRI", x = -3, y = 0, size = 0, default = true},

			{width = 0.50, name = L["Left text"], anchorTo = "$emptyBar", anchorPoint = "CLI", x = 3, y = 0, size = 0, default = true},
			{width = 0.60, name = L["Right text"], anchorTo = "$emptyBar", anchorPoint = "CRI", x = -3, y = 0, size = 0, default = true},
		},
		indicators = {
			raidTarget = {anchorTo = "$parent", anchorPoint = "C", size = 20, x = 0, y = 0},
			class = {anchorTo = "$parent", anchorPoint = "BL", size = 16, x = 0, y = 0},
			masterLoot = {anchorTo = "$parent", anchorPoint = "TL", size = 12, x = 16, y = -10},
			leader = {anchorTo = "$parent", anchorPoint = "TL", size = 14, x = 2, y = -12},
			pvp = {anchorTo = "$parent", anchorPoint = "TR", size = 22, x = 11, y = -21},
			ready = {anchorTo = "$parent", anchorPoint = "LC", size = 24, x = 35, y = 0},
			role = {anchorTo = "$parent", anchorPoint = "TL", size = 14, x = 30, y = -11},
			status = {anchorTo = "$parent", anchorPoint = "LB", size = 16, x = 12, y = -2},
			lfdRole = {enabled = true, anchorPoint = "BR", size = 14, x = 3, y = 14, anchorTo = "$parent"}
		},
		highlight = {size = 10},
		combatText = {anchorTo = "$parent", anchorPoint = "C", x = 0, y = 0},
		emptyBar = {background = true, height = 1, reactionType = "none", order = 0},
		healthBar = {background = true, colorType = "class", reactionType = "npc", height = 1.20, order = 10},
		powerBar = {background = true, height = 1.0, order = 20, colorType = "type"},
		xpBar = {background = true, height = 0.25, order = 55},
		castBar = {background = true, height = 0.60, order = 40, icon = "HIDE", name = {enabled = true, size = 0, anchorTo = "$parent", rank = true, anchorPoint = "CLI", x = 1, y = 0}, time = {enabled = true, size = 0, anchorTo = "$parent", anchorPoint = "CRI", x = -1, y = 0}},
		altPowerBar = {background = true, height = 0.40, order = 100},
	}

	-- Units configuration
	config.units = {
		raid = {
			width = 100,
			height = 30,
			scale = 0.85,
			unitsPerColumn = 8,
			maxColumns = 8,
			columnSpacing = 5,
			groupsPerRow = 8,
			groupSpacing = 0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			healthBar = {reactionType = "none"},
			powerBar = {height = 0.30},
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
				masterLoot = {anchorTo = "$parent", anchorPoint = "TR", size = 12, x = -2, y = -10},
				role = {enabled = false, anchorTo = "$parent", anchorPoint = "BR", size = 14, x = 0, y = 14},
				ready = {anchorTo = "$parent", anchorPoint = "LC", size = 24, x = 25, y = 0},
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[missinghp]"},
				{text = ""},
				{text = ""},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		raidpet = {
			width = 90,
			height = 30,
			scale = 0.85,
			unitsPerColumn = 8,
			maxColumns = 8,
			columnSpacing = 5,
			groupsPerRow = 8,
			groupSpacing = 0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			healthBar = {reactionType = "none"},
			powerBar = {height = 0.30},
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
				masterLoot = {anchorTo = "$parent", anchorPoint = "TR", size = 12, x = -2, y = -10},
				role = {enabled = false, anchorTo = "$parent", anchorPoint = "BR", size = 14, x = 0, y = 14},
				ready = {anchorTo = "$parent", anchorPoint = "LC", size = 24, x = 25, y = 0},
			},
			text = {
				{text = "[name]"},
				{text = "[missinghp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		player = {
			width = 190,
			height = 45,
			scale = 1.0,
			portrait = {enabled = true, fullAfter = 50},
			castBar = {order = 60},
			xpBar = {order = 55},
			fader = {enabled = false, combatAlpha = 1.0, inactiveAlpha = 0.6},
			runeBar = {enabled = true, background = false, height = 0.40, order = 70},
			totemBar = {enabled = true, background = false, height = 0.40, order = 70},
			druidBar = {enabled = true, background = true, height = 0.40, order = 70},
			priestBar = {enabled = true, background = true, height = 0.40, order = 70},
			shamanBar = {enabled = true, background = true, height = 0.40, order = 70},
			comboPoints = {enabled = true, anchorTo = "$parent", order = 60, anchorPoint = "BR", x = -3, y = 8, size = 14, spacing = -4, growth = "LEFT", isBar = true, height = 0.40},
			auraPoints = {enabled = false, showAlways = true, anchorTo = "$parent", order = 60, anchorPoint = "BR", x = -3, y = 8, size = 14, spacing = -4, growth = "LEFT", isBar = true, height = 0.40},
			staggerBar = {enabled = true, background = true, height = 0.30, order = 70},
			soulShards = {anchorTo = "$parent", order = 60, height = 0.40, anchorPoint = "BR", x = -8, y = 6, size = 12, spacing = -2, growth = "LEFT", isBar = true, showAlways = true},
			holyPower = {anchorTo = "$parent", order = 60, height = 0.40, anchorPoint = "BR", x = -3, y = 6, size = 14, spacing = -4, growth = "LEFT", isBar = true, showAlways = true},
			chi = {anchorTo = "$parent", order = 60, height = 0.40, anchorPoint = "BR", x = -3, y = 6, size = 14, spacing = -4, growth = "LEFT", isBar = true, showAlways = true},
			arcaneCharges = {anchorTo = "$parent", order = 60, height = 0.40, anchorPoint = "BR", x = -8, y = 6, size = 12, spacing = -2, growth = "LEFT", isBar = true, showAlways = true},
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			indicators = {
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
			},
			auras = {
				buffs = {enabled = false, maxRows = 1},
				debuffs = {enabled = false, maxRows = 1},
			},
			text = {
				{text = "[(()afk() )][name][( ()group())]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[(()afk() )][name][( ()group())]"},
				{text = ""},
				{enabled = true, width = 1, name = L["Timer Text"], text = "[totem:timer]", anchorTo = "$totemBar", anchorPoint = "C", x = 0, y = 0, size = 0, default = true, block = true},
				{enabled = true, width = 1, name = L["Timer Text"], text = "[rune:timer]", anchorTo = "$runeBar", anchorPoint = "C", size = 0, x = 0, y = 0, default = true, block = true},
				{enabled = true, width = 1, name = L["Text"], text = "[monk:abs:stagger]", anchorTo = "$staggerBar", anchorPoint = "C", size = 0, x = 0, y = 0, default = true}
			},
		},
		party = {
			width = 190,
			height = 45,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			unitsPerColumn = 5,
			columnSpacing = 30,
			portrait = {enabled = true, fullAfter = 50},
			castBar = {order = 60},
			offset = 23,
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			indicators = {
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
				phase = {enabled = true, anchorPoint = "RC", size = 14, x = -11, y = 0, anchorTo = "$parent"}
			},
			auras = {
				buffs = {enabled = true, maxRows = 1},
				debuffs = {enabled = true, maxRows = 1},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[level( )][perpp]"},
				{text = "[curmaxpp]"},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		boss = {
			enabled = true,
			width = 160,
			height = 40,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			offset = 20,
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			auras = {
				buffs = {enabled = true, maxRows = 1, perRow = 8},
				debuffs = {enabled = true, maxRows = 1, perRow = 8},
			},
			text = {
				{text = "[name]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[name]"},
				{text = ""},
			},
			portrait = {enabled = false},
		},
		bosstarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			healAbsorb = {cap = 1},
			powerBar = {height = 0.60},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
			},
		},
		bosstargettarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			healAbsorb = {cap = 1},
			powerBar = {height = 0.60},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		arena = {
			enabled = true,
			width = 170,
			height = 45,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			portrait = {enabled = true, type = "class", fullAfter = 50},
			altPower = {enabled = false},
			castBar = {order = 60},
			offset = 25,
			healAbsorb = {cap = 1},
			auras = {
				buffs = {enabled = true, maxRows = 1, perRow = 9},
				debuffs = {enabled = true, maxRows = 1, perRow = 9},
			},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
				arenaSpec = {anchorTo = "$parent", anchorPoint = "LC", size = 28, x = 0, y = 0}
			},
			text = {
				{text = "[name]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[name]"},
				{text = ""},
			},
		},
		arenapet = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
			},
		},
		arenatarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		arenatargettarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		battleground = {
			enabled = true,
			width = 140,
			height = 35,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			portrait = {enabled = false, type = "class", fullAfter = 50},
			powerBar = {height = 0.5},
			altPower = {enabled = false},
			castBar = {order = 60},
			healAbsorb = {cap = 1},
			offset = 0,
			auras = {
				buffs = {enabled = false, maxRows = 1, perRow = 9},
				debuffs = {enabled = false, maxRows = 1, perRow = 9},
			},
			indicators = {
				pvp = {enabled = true, anchorTo = "$parent", anchorPoint = "LC", size = 40, x = 16, y = -8},
			},
			text = {
				{text = "[name]"},
				{text = "[curmaxhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		battlegroundpet = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		battlegroundtarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		battlegroundtargettarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			altPower = {enabled = false},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		maintank = {
			width = 150,
			height = 40,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			offset = 5,
			unitsPerColumn = 5,
			maxColumns = 1,
			columnSpacing = 5,
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			portrait = {enabled = false, fullAfter = 50},
			castBar = {order = 60},
			indicators = {
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
			},
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		maintanktarget = {
			width = 150,
			height = 40,
			scale = 1.0,
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[classification( )][perpp]", width = 0.50},
				{text = "[curmaxpp]", anchorTo = "$powerBar", width = 0.60},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		maintanktargettarget = {
			width = 150,
			height = 40,
			scale = 1.0,
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[classification( )][perpp]", width = 0.50},
				{text = "[curmaxpp]", anchorTo = "$powerBar", width = 0.60},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		mainassist = {
			width = 150,
			height = 40,
			scale = 1.0,
			attribPoint = "TOP",
			attribAnchorPoint = "LEFT",
			offset = 5,
			unitsPerColumn = 5,
			maxColumns = 1,
			columnSpacing = 5,
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			portrait = {enabled = false, fullAfter = 50},
			castBar = {order = 60},
			indicators = {
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
			},
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[level( )][perpp]"},
				{text = "[curmaxpp]"},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		mainassisttarget = {
			width = 150,
			height = 40,
			scale = 1.0,
			healAbsorb = {cap = 1},
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[level( )][classification( )][perpp]", width = 0.50},
				{text = "[curmaxpp]", anchorTo = "$powerBar", width = 0.60},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		mainassisttargettarget = {
			width = 150,
			height = 40,
			scale = 1.0,
			healAbsorb = {cap = 1},
			auras = {
				buffs = {enabled = false},
				debuffs = {enabled = false},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[level( )][classification( )][perpp]", width = 0.50},
				{text = "[curmaxpp]", anchorTo = "$powerBar", width = 0.60},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		partypet = {
			width = 90,
			height = 25,
			scale = 1.0,
			healAbsorb = {cap = 1},
			powerBar = {height = 0.60},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
			},
		},
		partytarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		partytargettarget = {
			width = 90,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			healAbsorb = {cap = 1},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = 0, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[name]"},
				{text = ""},
			},
		},
		target = {
			width = 190,
			height = 45,
			scale = 1.0,
			portrait = {enabled = true, alignment = "RIGHT", fullAfter = 50},
			incHeal = {cap = 1},
			incAbsorb = {cap = 1},
			healAbsorb = {cap = 1},
			castBar = {order = 60},
			comboPoints = {enabled = false, anchorTo = "$parent", order = 60, anchorPoint = "BR", x = -3, y = 8, size = 14, spacing = -4, growth = "LEFT", isBar = true, height = 0.40},
			indicators = {
				lfdRole = {enabled = false},
				resurrect = {enabled = true, anchorPoint = "RC", size = 28, x = -39, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
				questBoss = {enabled = true, anchorPoint = "BR", size = 22, x = 9, y = 24, anchorTo = "$parent"},
				petBattle = {enabled = true, anchorPoint = "BL", size = 18, x = -6, y = 14, anchorTo = "$parent"}
			},
			auras = {
				buffs = {enabled = true},
				debuffs = {enabled = true},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curmaxhp]"},
				{text = "[level( )][classification( )][perpp]", width = 0.50},
				{text = "[curmaxpp]", anchorTo = "$powerBar", width = 0.60},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		pet = {
			width = 190,
			height = 30,
			scale = 1.0,
			powerBar = {height = 0.70},
			healAbsorb = {cap = 1},
			healthBar = {reactionType = "none"},
			portrait = {enabled = false, fullAfter = 50},
			castBar = {order = 60},
			text = {
				{text = "[name]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[name]"},
				{text = ""},
			},
		},
		pettarget = {
			width = 190,
			height = 30,
			scale = 1.0,
			healAbsorb = {cap = 1},
			powerBar = {height = 0.70},
			indicators = {
			},
			text = {
				{text = "[name]"},
				{text = "[curmaxhp]"},
				{text = "[perpp]"},
				{text = "[curmaxpp]"},
				{text = "[name]"},
				{text = ""},
			},
		},
		focus = {
			width = 120,
			height = 28,
			scale = 1.0,
			powerBar = {height = 0.60},
			healAbsorb = {cap = 1},
			portrait = {enabled = false, fullAfter = 50},
			castBar = {order = 60},
			indicators = {
				lfdRole = {enabled = false},
				resurrect = {enabled = true, anchorPoint = "LC", size = 28, x = 37, y = -1, anchorTo = "$parent"},
				sumPending = {enabled = true, anchorPoint = "C", size = 40, x = 0, y = 0, anchorTo = "$parent"},
				questBoss = {enabled = false, anchorPoint = "BR", size = 22, x = 7, y = 14, anchorTo = "$parent"},
				petBattle = {enabled = false, anchorPoint = "BL", size = 18, x = -6, y = 12, anchorTo = "$parent"}
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curhp]"},
				{text = "[perpp]"},
				{text = "[curpp]"},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		focustarget = {
			width = 120,
			height = 25,
			scale = 1.0,
			powerBar = {height = 0.60},
			healAbsorb = {cap = 1},
			portrait = {alignment = "RIGHT"},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = -3, y = 11},
			},
			text = {
				{text = "[(()afk() )][name]"},
				{text = "[curhp]"},
				{text = ""},
				{text = ""},
				{text = "[(()afk() )][name]"},
				{text = ""},
			},
		},
		targettarget = {
			width = 110,
			height = 30,
			scale = 1.0,
			powerBar = {height = 0.6},
			healAbsorb = {cap = 1},
			portrait = {alignment = "RIGHT"},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = -3, y = 11},
			},
			text = {
				{text = "[name]"},
				{text = "[curhp]"},
				{text = "[perpp]"},
				{text = "[curpp]"},
				{text = ""},
				{text = ""},
			},
		},
		targettargettarget = {
			width = 80,
			height = 30,
			scale = 1.0,
			powerBar = {height = 0.6},
			healAbsorb = {cap = 1},
			portrait = {alignment = "RIGHT"},
			indicators = {
				pvp = {anchorTo = "$parent", anchorPoint = "BL", size = 22, x = -3, y = 11},
			},
			text = {
				{text = "[name]", width = 1.0},
				{text = ""},
				{text = ""},
				{text = ""},
				{text = ""},
				{text = ""},
			},
		},
	}

	finalizeData(config, useMerge)
end

