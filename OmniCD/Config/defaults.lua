local E, L, C = select(2, ...):unpack()

C["loginMsg"] = false
C["notifyNew"] = false

C["Party"] = {
	visibility = {
		["arena"] = true,
		["pvp"] = false,
		["party"] = true,
		["raid"] = false,
		["scenario"] = false,
		["none"] = false,
		["size"] = 5,
	},
	arena = {
		general = {
			["showAnchor"] = false,
			["showPlayer"] = false,
			["showPlayerEx"] = true,
			["showTooltip"] = false,
		},
		position = {
			["uf"] = "auto",
			["preset"] = "TOPRIGHT",
			["anchor"] = "TOPLEFT",
			["attach"] = "TOPRIGHT",
			["offsetX"] = 4,
			["offsetY"] = 0,
			["layout"] = "horizontal",
			["columns"] = 6,
			["paddingX"] = 3,
			["paddingY"] = 3,
			["breakPoint"] = "offensive",
			["breakPoint2"] = "other",
			["displayInactive"] = true,
			["growUpward"] = false,
			["detached"] = false,
		},
		icons = {
			["showCounter"] = true,
			["reverse"] = false,
			["desaturateActive"] = false,
			["markEnhanced"] = true,
			["showForbearanceCounter"] = true,
			["scale"] = 0.80,
			["chargeScale"] = 1.1,
			["counterScale"] = 0.85,
			["swipeAlpha"] = 0.8,
			["inactiveAlpha"] = 1,
			["activeAlpha"] = 1,
			["displayBorder"] = true,
			["borderPixels"] = 1,
			["borderColor"] = { r = 0, g = 0, b = 0 },
		},
		highlight = {
			["glow"] = true,
			["glowColor"] = "bags-glow-white", -- 2.6.02 removed
			["glowBuffs"] = true,
			["glowType"] = "wardrobe",
			["glowBuffTypes"] = {
				["defensive"] = true,
				["externalDefensive"] = true,
				["raidDefensive"] = true,
				["immunity"] = true,
				["offensive"] = false,
				["counterCC"] = false,
				["raidMovement"] = false,
				["other"] = false,
			},
			["markedSpells"] = {},
		},
		priority = {
			["pvptrinket"] = 16,
			["racial"] = 15,
			["trinket"] = 14,
			["covenant"] = 13,
			["interrupt"] = 12,
			["dispel"] = 11,
			["cc"] = 10,
			["disarm"] = 9,
			["immunity"] = 8,
			["externalDefensive"] = 7,
			["defensive"] = 6,
			["raidDefensive"] = 5,
			["offensive"] = 4,
			["counterCC"] = 3,
			["raidMovement"] = 2,
			["other"] = 1,
		},
		extraBars = {
			["interruptBar"] = {
				["enabled"] = false,
				["locked"] = false,
				["layout"] = "vertical",
				["sortBy"] = 2,
				["sortDirection"] = "asc",
				["columns"] = 15,
				["scale"] = 0.6,
				["paddingX"] = -1,
				["paddingY"] = -1,
				["showName"] = true,
				["growUpward"] = false,
				["progressBar"] = true,
				["textColors"] = {
					["activeColor"] = {r=1,g=1,b=1},
					["inactiveColor"] = {r=1,g=1,b=1},
					["rechargeColor"] = {r=1,g=1,b=1},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = false,
					},
				},
				["barColors"] = {
					["activeColor"] = {r=1,g=0,b=0,a=1}, -- A
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1}, -- A
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = true,
						["recharge"] = false,
					},
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = false,
					},
				},
				["statusBarWidth"] = 205,
				["reverseFill"] = true,
				["useIconAlpha"] = false,
				["hideSpark"] = false,
			},
			["raidCDBar"] = {
				["enabled"] = false,
				["locked"] = false,
				["layout"] = "vertical",
				["sortBy"] = 3,
				["columns"] = 15,
				["group1"] = {},
				["group2"] = {},
				["group3"] = {},
				["group4"] = {},
				["group5"] = {},
				["group6"] = {},
				["group7"] = {},
				["group8"] = {},
				--["groupDetached"] = {},
				["groupPadding"] = 0,
				["scale"] = 0.5,
				["paddingX"] = -1,
				["paddingY"] = -1,
				["showName"] = true,
				["growUpward"] = false,
				["progressBar"] = true,
				["textColors"] = {
					["activeColor"] = {r=1,g=1,b=1},
					["rechargeColor"] = {r=1,g=1,b=1},
					["inactiveColor"] = {r=1,g=1,b=1},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = false,
					},
				},
				["barColors"] = {
					["activeColor"] = {r=1,g=0,b=0},
					["rechargeColor"] = {r=1,g=0.7,b=0},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = false,
					},
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = false,
					},
				},
				["statusBarWidth"] = 205,
				["reverseFill"] = true,
				["useIconAlpha"] = false,
				["hideSpark"] = false,
				["hideDisabledSpells"] = true,
			},
		},
		spells = {},
		raidCDS = {},
		manualPos = {},
	},
	noneZoneSetting = "arena",
	scenarioZoneSetting = "arena",
	sync = true,
	customPriority = {},
}

if E.isBCC then
	E.spellDefaults = {
		42292,
		28730,  26297,  28880,  20594,  20549,  7744,
		16979,  5211,   22812,  22842,  740,    33831,  17116,
		1499,   19577,  19503,  19386,  34490,  19263,  23989,  19574,  3045,
		2139,   45438,  11958,  12042,  11129,  12472,  12043,
		853,    20066,  642,    1022,   6940,   19752,  20216,  633,    31884,
		8122,   44041,  15487,  33206,  13908,  2651,   2944,   13896,  724,    14751,  10060,  34433,  6346,
		1766,   2094,   408,    31224,  5277,   14185,  1856,   13750,  13877,  14177,  14183,
		8042,   30823,  2825,   16166,  2894,   8177,   16188,
		19244,  19505,  6789,   5484,   30283,  18288,  1122,
		6552,   72,     12809,  5246,   676,    12975,  871,    12292,  1719,   20230,  18499,  3411,   23920,
	}

	E.raidDefaults = {
		740,
	}
else
	E.spellDefaults = {
		336135, 336126, 196029,
		59752,
		323436,
		47482,  47528,  48707,  48792,  114556, 51052,
		183752, 196555, 198589, 209258, 187827, 196718, 200166, 205604,
		106839, 78675,  22812,  102342, 108238, 61336,  33891,
		147362, 187707, 187650, 186265, 109304, 53480,
		2139,   45438,  108978, 342245, 86949,  235219, 198111, 190319,
		116705, 116849, 122470, 122783, 122278, 115203, 243435, 115310,
		31935,  96231,  215652, 853,    115750, 642,    228049, 199452, 1022,   216331, 31884,  231895, 210256,
		15487,  64044,  8122,   213602, 197268, 19236,  47585,  47788,  33206,  20711,  215982, 108968, 62618,  47536, 109964,
		1766,   2094,   31230,  31224,  5277,   1856,   79140,
		57994,  108271, 198838, 210918, 30884,  114052, 98008,  204336, 8143,
		212619, 119898, 6789,   48020,  104773, 212295,
		6552,   5246,   118038, 184364, 871,    97462,  23920,  236320,
	}

	E.raidDefaults = {
		51052,
		196718,
		740,
		115310,
		31812,
		64843,  265202, 62618,  15286,
		108280, 98008,
		97462,
	}
end

for i = 1, #E.spellDefaults do
	local id = E.spellDefaults[i]
	id = tostring(id)
	C.Party.arena.spells[id] = true
end

for i = 1, #E.raidDefaults do
	local id = E.raidDefaults[i]
	id = tostring(id)
	C.Party.arena.raidCDS[id] = true
end

for k in pairs(E.CFG_ZONE) do
	if k ~= "arena" then
		C.Party[k] = E.DeepCopy(C.Party.arena)
	end
end

C.Party.party.extraBars.interruptBar.enabled = true
C.Party.party.extraBars.raidCDBar.enabled = true

C.Party.raid.extraBars.interruptBar.enabled = true
C.Party.raid.extraBars.raidCDBar.enabled = true
