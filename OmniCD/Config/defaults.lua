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
			--["glowType0"] = "wardrobe", -- old glow
			["glowColor"] = "bags-glow-white", -- 2.6.02 removed
			["glowBuffs"] = true,
			["glowType"] = "wardrobe",
			["glowBuffTypes"] = {
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
				["growLeft"] = false,
				["progressBar"] = true,
				["hideBar"] = false,
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
					["activeColor"] = {r=1,g=0,b=0,a=1},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = true,
						["inactive"] = true,
						["recharge"] = true,
					},
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = true,
					},
				},
				["reverseFill"] = true,
				["useIconAlpha"] = false,
				["hideSpark"] = false,
				["hideBorder"] = false,
				["showInterruptedSpell"] = true,
				["showRaidTargetMark"] = false,
				["statusBarWidth"] = 205,
				["textOfsX"] = 3,
				["textOfsY"] = 0,
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
				["groupDetached"] = {},
				["groupGrowUpward"] = {},
				["groupGrowLeft"] = {},
				["groupPadding"] = 0,
				["scale"] = 0.6,
				["paddingX"] = -1,
				["paddingY"] = -1,
				["showName"] = true,
				["growUpward"] = false,
				["growLeft"] = false,
				["progressBar"] = true,
				["hideBar"] = false,
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
						["active"] = true,
						["inactive"] = true,
						["recharge"] = true,
					},
				},
				["bgColors"] = {
					["activeColor"] = {r=0,g=0,b=0,a=0.9},
					["rechargeColor"] = {r=1,g=0.7,b=0,a=1},
					["inactiveColor"] = {r=0,g=1,b=0,a=0.9},
					["useClassColor"] = {
						["active"] = false,
						["inactive"] = false,
						["recharge"] = true,
					},
				},
				["reverseFill"] = true,
				["useIconAlpha"] = false,
				["hideSpark"] = false,
				["hideBorder"] = false,
				["statusBarWidth"] = 205,
				["textOfsX"] = 3,
				["textOfsY"] = 0,
				["hideDisabledSpells"] = true,
			},
		},
		spells = {},
		raidCDS = {},
		manualPos = {},
	},
	noneZoneSetting = "arena",
	scenarioZoneSetting = "arena",
	customPriority = {},
}

if E.isPreBCC then
	E.spellDefaults = {
		42292,  -- PvP Trinket
		28730,  -- Arcane Torrent
		26297,  -- Berserking
		28880,  -- Gift of the Naaru
		20594,  -- Stoneform
		20549,  -- War Stomp
		7744,   -- Will of the Forsaken
		-- Druid
		16979,  -- Feral Charge
		5211,   -- Mighty Bash
		22812,  -- Barkskin
		22842,  -- Frenzied Regen
		740,    -- Tranquility
		33831,  -- Force of Nature
		17116,  -- Nature's Swiftness
		-- Hunter
		1499,   -- Freezing Trap (Rank 1)
		19577,  -- Intimidation
		19503,  -- Scatter Shot
		19386,  -- Wyvern Sting (Rank 1)
		34490,  -- Silencing Shot
		19263,  -- Deterrence
		23989,  -- Readiness
		19574,  -- Bestial Wrath
		3045,   -- Rapid Fire
		-- Mage
		2139,   -- Counterspell
		45438,  -- Ice Block
		11958,  -- Purifying Brew
		12042,  -- Arcane Power
		11129,  -- Combustion
		12472,  -- Icy Veins
		12043,  -- Presence of Mind
		-- Paladin
		853,    -- Hammer of Justice (Rank 1)
		20066,  -- Repentance
		642,    -- Divine Shield
		1022,   -- Blessing of Protection (Rank 1)
		6940,   -- Blessing of Sacrifice (Rank 1)
		19752,  -- Divine Intervention
		20216,  -- Divine Favor
		633,    -- Lay on Hands (Rank 1)
		31884,  -- Avenging Wrath
		-- Priest
		8122,   -- Psychic Scream (Rank 1)
		44041,  -- Chastise (Rank 1)
		15487,  -- Silence
		33206,  -- Pain Suppression
		13908,  -- Desperate Prayer (Rank 1)
		2651,   -- Elune's Grace
		2944,   -- Devouring Plague (Rank 1)
		13896,  -- Feedback (Rank 1)
		724,    -- Lightwell (Rank 1)
		14751,  -- Inner Focus
		10060,  -- Power Infusion
		34433,  -- Shadowfiend
		6346,   -- Fear Ward
		-- Rogue
		1766,   -- Kick (Rank 1)
		2094,   -- Blind
		408,    -- Kidney Shot (Rank 1)
		31224,  -- Cloak of Shadows
		5277,   -- Evasion (Rank 1)
		14185,  -- Preparation
		1856,   -- Vanish (Rank 1)
		13750,  -- Adrenaline Rush
		13877,  -- Blade Flurry
		14177,  -- Cold Blood
		14183,  -- Premeditation
		-- Shaman
		8042,   -- Earth Shock (Rank 1)
		30823,  -- Shamanistic Rage
		2825,   -- Bloodlust
		16166,  -- Elemental Mastery
		2894,   -- Fire Elemetal Totem
		8177,   -- Grounding Totem
		16188,  -- Nature's Swiftness
		-- Warlock
		19244,  -- Spell Lock (Rank 1)
		19505,  -- Devour Magic (Rank 1)
		6789,   -- Death Coil (Rank 1)
		5484,   -- Howl of Terror (Rank 1)
		30283,  -- Shadowfury (Rank 1)
		18288,  -- Amplify Curse
		1122,   -- Inferno
		-- Warrior
		6552,   -- Pummel (Rank 1)
		72,     -- Shield Bash (Rank 1)
		12809,  -- Concussion Blow
		5246,   -- Intimidating Shout
		676,    -- Disarm
		12975,  -- Last Stand
		871,    -- Shield Wall
		12292,  -- Death Wish
		1719,   -- Recklessness
		20230,  -- Retaliation
		18499,  -- Berserker Rage
		3411,   -- Intervene
		23920,  -- Spell Reflection
	}

	E.raidDefaults = {
		740,    -- Tranquility (Rank 1)
	}
else
	E.spellDefaults = {
		336135, -- Sinful Gladiator's Sigil of Adaptation
		336126, -- Sinful Gladiator's Medallion (item2 = Aspirant)
		196029, -- Sinful Gladiator's Relentless Brooch
		59752,  -- Will to Survive
		-- Covenant
		323436, -- Purify Soul
		319217, -- Podtender
		-- DK
		47482,  -- Leap & Shambling Rush (91807)
		47528,  -- Mind Freeze
		48707,  -- Anti-Magic Shell
		48792,  -- Icebound Fortitude
		114556, -- Purgatory (dummy spell)
		51052,  -- Anti-Magic Zone
		-- DH
		183752, -- Disrupt
		196555, -- Netherwalk
		198589, -- Blur
		209258, -- Last Resort (dummy spell)
		187827, -- Metamorphosis (V)
		196718, -- Darkness
		200166, -- Metamorphosis
		205604, -- Reverse Magic
		-- Druid
		106839, -- Skull Bash
		78675,  -- Solar Beam
		22812,  -- Barkskin
		102342, -- Ironbark
		108238, -- Renewal
		61336,  -- Survival Instincts
		33891,  -- Incarnation: Tree of Life
		-- Hunter
		147362, -- Countershot
		187707, -- Muzzle
		187650, -- Freezing Trap
		186265, -- Aspect of the Turtle
		109304, -- Exhilaration
		53480,  -- Roar of Sacrifice
		-- Mage
		2139,   -- Counterspell
		45438,  -- Ice Block
		108978, -- Alter Time (FF) (dummy spell)
		342245, -- Alter Time (A) (dummy spell)
		86949,  -- Cauterized (dummy spell)
		235219, -- Cold Snap
		198111, -- Temporal Shield
		190319, -- Combustion
		-- Monk
		116705, -- Spear Hand strike
		116849, -- Life Cocoon
		122470, -- Touch of Karma
		122783, -- Diffuse Magic
		122278, -- Dampen Harm
		115203, -- Fortifying Brew (BM)
		243435, -- Fortifying Brew (MW, WW)
		115310, -- Revival
		-- Paladin
		31935,  -- Avenger's Shield
		96231,  -- Rebuke
		215652, -- Shield of Virtue
		853,    -- Hammer of Justice
		115750, -- Blinding Light
		642,    -- Divine Shield
		228049, -- Guardian of the Forgotten Queen
		199452, -- Ultimate Sacrifice
		1022,   -- Blessing of Protection
		216331, -- Avenging Crusader
		31884,  -- Avenging Wrath
		231895, -- Crusade
		210256, -- Blessing of Sanctuary
		-- Priest
		15487,  -- Silence
		64044,  -- Psychic Horror
		8122,   -- Psychic Scream
		213602, -- Greater Fade
		197268, -- Ray of Hope
		19236,  -- Desperate Prayer
		47585,  -- Dispersion
		47788,  -- Guardian Spirit
		33206,  -- Pain Suppression
		20711,  -- Spirit of the Redemption (passive)
		215982, -- Spirit of the Redeemer
		108968, -- Void Shift
		62618,  -- Power Word: Barrier
		47536,  -- Rapture
		109964, -- Spirit Shell
		-- Rogue
		1766,   -- Kick
		2094,   -- Blind
		31230,  -- Cheat Death (dummy spell)
		31224,  -- Cloak of Shadows
		5277,   -- Evasion
		1856,   -- Vanish
		79140,  -- Vendetta
		-- Shaman
		57994,  -- Wind Shear
		108271, -- Astral Shift
		198838, -- Earthen Wall Totem
		210918, -- Astral Shift
		30884,  -- Nature's Guardian (dummy spell)
		114052, -- Ascendance (Res)
		98008,  -- Spirit Link Totem
		204336, -- Grounding Totem
		8143,   -- Tremor Totem
		-- Warlock
		212619, -- Call Felhunter
		119898, -- Command Demon
		6789,   -- Mortal Coil
		48020,  -- Demonic Circle: Teleport
		104773, -- Unending Resolve
		212295, -- Nether Ward
		-- Warrior
		6552,   -- Pummel
		5246,   -- Intimidating Shout
		118038, -- Die by the Sword
		184364, -- Enraged Regeneration
		871,    -- Shield Wall
		97462,  -- Rallying Cry
		23920,  -- Spell Reflection
		236320, -- War Banner
	}

	E.raidDefaults = {
		51052,  -- Anti-Magic Zone
		196718, -- Cover of Darkness
		740,    -- Tranquility
		115310, -- Revival
		31821,  -- Aura Mastery
		64843,  -- Divine Hymn
		265202, -- Holy Word: Salvation
		62618,  -- Power Word: Barrier
		15286,  -- Vampiric Embrace
		108280, -- Healing Tide Totem
		98008,  -- Spirit Link Totem
		97462,  -- Rallying Cry
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
C.Party.raid.extraBars.raidCDBar.enabled = true
