local E, L, C = select(2, ...):unpack()

C["Party"] = {
	sync = true,
	general = {
		["loginMsg"] = false,
		["notifyNew"] = false,
	},
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
			["displayInactive"] = true,
			["growUpward"] = false,
			["detached"] = false,
		},
		manualPos = {},
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
			--[[ xml
			["modRowEnabled"] = true,
			["modRowCropped"] = true,
			["modRowScale"] = 0.7,
			["modRowOfsX"] = 0,
			--]]
		},
		highlight = {
			["glow"] = true,
			["glowColor"] = "bags-glow-white",
			["glowBuffs"] = true,
			["glowType"] = "wardrobe",
			["glowBuffTypes"] = {
				["defensive"] = true,
				["raidDefensive"] = true,
				["immunity"] = true,
				["offensive"] = false,
				["counterCC"] = false,
				["other"] = false,
			},
			["markedSpells"] = {},
		},
		priority = {
			["pvptrinket"] = 14,
			["racial"] = 13,
			["trinket"] = 12,
			["covenant"] = 11,
			["interrupt"] = 10,
			["dispel"] = 9,
			["cc"] = 8,
			["disarm"] = 7,
			["immunity"] = 6,
			["defensive"] = 5,
			["raidDefensive"] = 4,
			["offensive"] = 3,
			["counterCC"] = 2,
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
					["classColor"] = false,
				},
				["barColors"] = {
					["activeColor"] = {r=1,g=0,b=0},
					["rechargeColor"] = {r=1,g=0.7,b=0},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["classColor"] = true,
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["classColor"] = false,
				},
				["statusBarWidth"] = 205,
				["reverseFill"] = true,
				["useIconAlpha"] = false,
			},
			["raidCDBar"] = {
				["enabled"] = false,
				["locked"] = false,
				["layout"] = "vertical",
				["sortBy"] = 3,
				["columns"] = 15,
				["breakPoint"] = "other",
				["scale"] = 0.5,
				["paddingX"] = -1,
				["paddingY"] = -1,
				["showName"] = true,
				["progressBar"] = true,
				["textColors"] = {
					["activeColor"] = {r=1,g=1,b=1},
					["rechargeColor"] = {r=1,g=1,b=1},
					["inactiveColor"] = {r=1,g=1,b=1},
					["classColor"] = false,
				},
				["barColors"] = {
					["activeColor"] = {r=1,g=0,b=0},
					["rechargeColor"] = {r=1,g=0.7,b=0},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["classColor"] = false,
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["classColor"] = false,
				},
				["statusBarWidth"] = 205,
				["reverseFill"] = true,
				["useIconAlpha"] = false,
				["hideDiabledSpells"] = true,
			},
		},
		spells = {},
		raidCDS = {},
	},
	noneZoneSetting = "arena",
	scenarioZoneSetting = "arena",
	customPriority = {},
}

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
