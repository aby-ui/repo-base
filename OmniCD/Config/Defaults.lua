local E, _, C, G = select(2, ...):unpack()

G.loginMessage = false
G.notifyNew = false
G.optionPanelScale = 1

C.Party = {
	["visibility"] = {
		["arena"] = true,
		["pvp"] = false,
		["party"] = true,
		["raid"] = false,
		["scenario"] = false,
		["none"] = false,
		["finder"] = true,
		["size"] = 5,
	},
	["noneZoneSetting"] = "arena",
	["scenarioZoneSetting"] = "arena",
	["customPriority"] = {},
}

C.Party.arena = {
	["general"] = {
		["showAnchor"] = false,
		["showPlayer"] = false,
		["showPlayerEx"] = true,
		["showTooltip"] = false,
		["showRange"] = false,
	},
	["position"] = {
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
	["icons"] = {
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
		["borderColor"] = { r = 0.0, g = 0.0, b = 0.0 },
	},
	["highlight"] = {
		["glow"] = true,
		["glowBuffs"] = true,
		["glowType"] = "wardrobe",
		["glowBuffTypes"] = {
			["pvptrinket"] = false,
			["racial"] = false,
			["trinket"] = false,
			["covenant"] = false,
			["immunity"] = true,
			["externalDefensive"] = true,
			["defensive"] = true,
			["raidDefensive"] = true,
			["offensive"] = false,
			["counterCC"] = false,
			["raidMovement"] = false,
			["other"] = false,
		},
	},
	["priority"] = {
		["consumable"] = 17,
		["pvptrinket"] = 16,
		["racial"] = 15,
		["trinket"] = 14,
		["essence"] = 13,
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
		["custom1"] = 0,
		["custom2"] = 0,
	},
	["extraBars"] = {
		["hideDisabledSpells"] = true,
	},
	["spells"] = { ["*"] = false },
	["raidCDS"] = { ["*"] = false },
	["manualPos"] = {},
}

for i = 0, 8 do
	local key = "raidBar" .. i
	C.Party.arena.extraBars[key] = {
		["enabled"] = false,
		["locked"] = false,
		["layout"] = "vertical",
		["sortBy"] = i == 0 and 2 or 3,
		["sortDirection"] = "asc",
		["spellType"] = {
			["interrupt"] = i == 0,
			["*"] = i == 1,
		},
		["columns"] = 15,
		["scale"] = 0.6,
		["paddingX"] = -1,
		["paddingY"] = -1,
		["showName"] = true,
		["truncateIconName"] = 6,
		["growUpward"] = false,
		["growLeft"] = false,
		["progressBar"] = true,
		["nameBar"] = false,
		["textColors"] = {
			["activeColor"] = { r = 1.0, g = 1.0, b = 1.0 },
			["inactiveColor"] = { r = 1.0, g = 1.0, b = 1.0 },
			["rechargeColor"] = { r = 1.0, g = 1.0, b = 1.0 },
			["useClassColor"] = {
				["active"] = false,
				["inactive"] = false,
				["recharge"] = false,
			},
		},
		["barColors"] = {
			["activeColor"] = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },
			["rechargeColor"] = { r = 1.0, g = 0.7, b = 0.0, a = 1.0 },
			["inactiveColor"] = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },
			["useClassColor"] = {
				["active"] = true,
				["inactive"] = true,
				["recharge"] = true,
			},
		},
		["bgColors"] = {
			["activeColor"] = { r = 0.0, g = 0.0, b = 0.0, a = 0.5 },
			["rechargeColor"] = { r = 1.0, g = 0.7, b = 0.0, a = 1.0 },
			["inactiveColor"] = { r = 0.0, g = 1.0, b = 0.0, a = 0.5 },
			["useClassColor"] = {
				["active"] = false,
				["inactive"] = false,
				["recharge"] = true,
			},
		},
		["reverseFill"] = true,
		["hideSpark"] = false,
		["hideBorder"] = false,
		["showInterruptedSpell"] = true,
		["showRaidTargetMark"] = false,
		["statusBarWidth"] = 205,
		["textOfsX"] = 3,
		["textOfsY"] = 0,
		["truncateStatusBarName"] = 0,
		["manualPos"] = {},
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

for k in pairs(E.L_CFG_ZONE) do
	if k ~= "arena" then
		C.Party[k] = E:DeepCopy(C.Party.arena)
	end
end

C.Party.party.extraBars.raidBar0.enabled = true
C.Party.raid.extraBars.raidBar1.enabled = true
