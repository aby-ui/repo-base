--print("|cff00dfff[BigDebuffs-v4.9]|r原作者|c00FF9900Curse:Jordon|r,由|c00FF9900NGA:伊甸外|r于7.23日翻译修改,输入|cff33ff99/bd|r设置.")
--翻译汉化修改：NGA  @伊甸外  barristan@sina.com  http://bbs.ngacn.cc/nuke.php?func=ucp&uid=7350579
-- BigDebuffs by Jordon

BigDebuffs = LibStub("AceAddon-3.0"):NewAddon("BigDebuffs", "AceEvent-3.0", "AceHook-3.0")

-- Defaults
local defaults = {
	profile = {
		raidFrames = {
			maxDebuffs = 2,
			anchor = "INNER",
			enabled = true,
			cooldownCount = false,
			hideBliz = true,
			redirectBliz = true,
			increaseBuffs = true,
			cc = 60,
			dispellable = {
				cc = 60,
				roots = 50,
			},
			interrupts = 55,
			roots = 40,
			warning = 30,
			default = 30,
			special = 30,
			pve = 50,
			warningList = {
				[212183] = true, -- Smoke Bomb
				[81261] = true, -- Solar Beam
				[233490] = true, -- Unstable Affliction
				[34914] = true, -- Vampiric Touch
			},
		},
		unitFrames = {
			enabled = true,
			cooldownCount = true,
			tooltips = true,
			player = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			focus = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			target = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			pet = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			party = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			arena = {
				enabled = true,
				anchor = "auto",
				size = 50,
			},
			cc = true,
			interrupts = true,
			immunities = true,
			immunities_spells = true,
			buffs_defensive = true,
			buffs_offensive = true,
			buffs_other = true,
			roots = true,
		},
		priority = {
			immunities = 80,
			immunities_spells = 70,
			cc = 60,
			interrupts = 55,
			buffs_defensive = 50,
			buffs_offensive = 40,
			buffs_other = 30,
			roots = 51,
			special = 19,
		},
		spells = {},
	}
}

-- Show one of these when a big debuff is displayed
BigDebuffs.WarningDebuffs = {
	212183, -- Smoke Bomb
	81261, -- Solar Beam
	233490, -- Unstable Affliction
	233496, -- Unstable Affliction
	233497, -- Unstable Affliction
	233498, -- Unstable Affliction
	233499, -- Unstable Affliction
	34914, -- Vampiric Touch
}

BigDebuffs.Spells = {

	-- Interrupts

	[1766] = { type = "interrupts", duration = 5 }, -- Kick (Rogue)
	[2139] = { type = "interrupts", duration = 6 }, -- Counterspell (Mage)
	[6552] = { type = "interrupts", duration = 4 }, -- Pummel (Warrior)
	[19647] = { type = "interrupts", duration = 6 }, -- Spell Lock (Warlock)
	[47528] = { type = "interrupts", duration = 3 }, -- Mind Freeze (Death Knight)
	[57994] = { type = "interrupts", duration = 3 }, -- Wind Shear (Shaman)
	[91802] = { type = "interrupts", duration = 2 }, -- Shambling Rush (Death Knight)
	[96231] = { type = "interrupts", duration = 4 }, -- Rebuke (Paladin)
	[106839] = { type = "interrupts", duration = 4 }, -- Skull Bash (Feral)
	[115781] = { type = "interrupts", duration = 6 }, -- Optical Blast (Warlock)
	[116705] = { type = "interrupts", duration = 4 }, -- Spear Hand Strike (Monk)
	[132409] = { type = "interrupts", duration = 6 }, -- Spell Lock (Warlock)
	[147362] = { type = "interrupts", duration = 3 }, -- Countershot (Hunter)
	[171138] = { type = "interrupts", duration = 6 }, -- Shadow Lock (Warlock)
	[183752] = { type = "interrupts", duration = 3 }, -- Consume Magic (Demon Hunter)
	[187707] = { type = "interrupts", duration = 3 }, -- Muzzle (Hunter)
	[212619] = { type = "interrupts", duration = 6 }, -- Call Felhunter (Warlock)
	[231665] = { type = "interrupts", duration = 3 }, -- Avengers Shield (Paladin)

	-- Death Knight

	[47476] = { type = "cc" }, -- Strangulate
	[48707] = { type = "immunities_spells" }, -- Anti-Magic Shell
	[48792] = { type = "buffs_defensive" }, -- Icebound Fortitude
	[49028] = { type = "buffs_offensive" }, -- Dancing Rune Weapon
	[51271] = { type = "buffs_offensive" }, -- Pillar of Frost
	[55233] = { type = "buffs_defensive" }, -- Vampiric Blood
	[77606] = { type = "buffs_other" }, -- Dark Simulacrum
	[91797] = { type = "cc" }, -- Monstrous Blow
	[91800] = { type = "cc" }, -- Gnaw
	[108194] = { type = "cc" }, -- Asphyxiate
		[221562] = { type = "cc", parent = 108194 }, -- Asphyxiate (Blood)
	[152279] = { type = "buffs_offensive" }, -- Breath of Sindragosa
	[194679] = { type = "buffs_defensive" }, -- Rune Tap
	[194844] = { type = "buffs_defensive" }, -- Bonestorm
	[204080] = { type = "roots" }, -- Frostbite
	[206977] = { type = "buffs_defensive" }, -- Blood Mirror
	[207127] = { type = "buffs_offensive" }, -- Hungering Rune Weapon
	[207167] = { type = "cc" }, -- Blinding Sleet
	[207171] = { type = "cc" }, -- Winter is Coming
	[207256] = { type = "buffs_offensive" }, -- Obliteration
	[207319] = { type = "buffs_defensive" }, -- Corpse Shield
	[212332] = { type = "cc" }, -- Smash
		[212337] = { type = "cc", parent = 212332 }, -- Powerful Smash
	[212552] = { type = "buffs_defensive" }, -- Wraith Walk
	[219809] = { type = "buffs_defensive" }, -- Tombstone
	[223929] = { type = "buffs_other" }, -- Necrotic Wound

	-- Demon Hunter

	[179057] = { type = "cc" }, -- Chaos Nova
	[187827] = { type = "buffs_defensive" }, -- Metamorphosis
	[188499] = { type = "buffs_defensive" }, -- Blade Dance
	[188501] = { type = "buffs_offensive" }, -- Spectral Sight
	[204490] = { type = "cc" }, -- Sigil of Silence
	[205629] = { type = "buffs_defensive" }, -- Demonic Trample
	[205630] = { type = "cc" }, -- Illidan's Grasp
	[206649] = { type = "buffs_other" }, -- Eye of Leotheras
	[207685] = { type = "cc" }, -- Sigil of Misery
	[207810] = { type = "buffs_defensive" }, -- Nether Bond
	[211048] = { type = "buffs_offensive" }, -- Chaos Blades
	[211881] = { type = "cc" }, -- Fel Eruption
	[212800] = { type = "buffs_defensive" }, -- Blur
		[196555] = { type = "buffs_defensive" }, -- Netherwalk
	[218256] = { type = "buffs_defensive" }, -- Empower Wards
	[221527] = { type = "cc" }, -- Imprison (Detainment Honor Talent)
		[217832] = { type = "cc", parent = 221527 }, -- Imprison (Baseline Undispellable)
	[227225] = { type = "buffs_defensive" }, -- Soul Barrier

	-- Druid

	[99] = { type = "cc" }, -- Incapacitating Roar
	[339] = { type = "roots" }, -- Entangling Roots
	[740] = { type = "buffs_defensive" }, -- Tranquility
	[1850] = { type = "buffs_other" }, -- Dash
	[5211] = { type = "cc" }, -- Mighty Bash
	[5217] = { type = "buffs_offensive" }, -- Tiger's Fury
	[22812] = { type = "buffs_defensive" }, -- Barkskin
	[22842] = { type = "buffs_defensive" }, -- Frenzied Regeneration
	[29166] = { type = "buffs_offensive" }, -- Innervate
	[33891] = { type = "buffs_offensive" }, -- Incarnation: Tree of Life
	[45334] = { type = "roots" }, -- Wild Charge
	[61336] = { type = "buffs_defensive" }, -- Survival Instincts
	[81261] = { type = "cc" }, -- Solar Beam
	[102342] = { type = "buffs_defensive" }, -- Ironbark
	[102359] = { type = "roots" }, -- Mass Entanglement
	[102543] = { type = "buffs_offensive" }, -- Incarnation: King of the Jungle
	[102558] = { type = "buffs_offensive" }, -- Incarnation: Guardian of Ursoc
	[102560] = { type = "buffs_offensive" }, -- Incarnation: Chosen of Elune
	[106951] = { type = "buffs_offensive" }, -- Berserk
	[155835] = { type = "buffs_defensive" }, -- Bristling Fur
	[163505] = { type = "cc" }, -- Rake
	[194223] = { type = "buffs_offensive" }, -- Celestial Alignment
	[200851] = { type = "buffs_defensive" }, -- Rage of the Sleeper
	[202425] = { type = "buffs_offensive" }, -- Warrior of Elune
	[204399] = { type = "cc" }, -- Earthfury
	[204437] = { type = "cc" }, -- Lightning Lasso

	[209749] = { type = "cc" }, -- Faerie Swarm (Slow/Disarm)
	[209753] = { type = "cc", priority = true }, -- Cyclone
		[33786] = { type = "cc", parent = 209753 }, -- Cyclone
	[22570] = { type = "cc" }, -- Maim
		[203123] = { type = "cc", parent = 22570 }, -- Maim
		[236025] = { type = "cc", parent = 22570 }, -- Enraged Maim (Feral Honor Talent)

	-- Hunter

	[136] = { type = "buffs_defensive" }, -- Mend Pet
	[3355] = { type = "cc" }, -- Freezing Trap
	[5384] = { type = "buffs_defensive" }, -- Feign Death
	[19386] = { type = "cc" }, -- Wyvern Sting
	[19574] = { type = "buffs_offensive" }, -- Bestial Wrath
	[19577] = { type = "cc" }, -- Intimidation
		[24394] = { type = "cc", parent = 19577 }, -- Intimidation
	[53480] = { type = "buffs_defensive" }, -- Roar of Sacrifice (Hunter Pet Skill)
	[117526] = { type = "cc" }, -- Binding Shot Stun
	[131894] = { type = "buffs_offensive" }, -- A Murder of Crows (Beast Mastery, Marksmanship)
		[206505] = { type = "buffs_offensive", parent = 131894 }, -- A Murder of Crows (Survival)
	[186265] = { type = "buffs_defensive" }, -- Aspect of the Turtle
	[186289] = { type = "buffs_offensive" }, -- Aspect of the Eagle
	[238559] = { type = "cc" }, -- Bursting Shot
	[193526] = { type = "buffs_offensive" }, -- Trueshot
	[193530] = { type = "buffs_offensive" }, -- Aspect of the Wild
	[199483] = { type = "buffs_defensive" }, -- Camouflage
	[202914] = { type = "cc" }, -- Spider Sting (Armed)
		[202933] = { type = "cc", parent = 202914 }, -- Spider Sting (Silenced)
		[233022] = { type = "cc", parent = 202914 }, -- Spider Sting (Silenced)
	[209790] = { type = "cc" }, -- Freezing Arrow
	[209997] = { type = "buffs_defensive" }, -- Play Dead
	[213691] = { type = "cc" }, -- Scatter Shot

	-- Mage

	[66] = { type = "buffs_offensive" }, -- Invisibility
		[110959] = { type = "buffs_offensive", parent = 66 }, -- Greater Invisibility
	[118] = { type = "cc" }, -- Polymorph
		[28271] = { type = "cc", parent = 118 }, -- Polymorph Turtle
		[28272] = { type = "cc", parent = 118 }, -- Polymorph Pig
		[61025] = { type = "cc", parent = 118 }, -- Polymorph Serpent
		[61305] = { type = "cc", parent = 118 }, -- Polymorph Black Cat
		[61721] = { type = "cc", parent = 118 }, -- Polymorph Rabbit
		[61780] = { type = "cc", parent = 118 }, -- Polymorph Turkey
		[126819] = { type = "cc", parent = 118 }, -- Polymorph Porcupine
		[161353] = { type = "cc", parent = 118 }, -- Polymorph Polar Bear Cub
		[161354] = { type = "cc", parent = 118 }, -- Polymorph Monkey
		[161355] = { type = "cc", parent = 118 }, -- Polymorph Penguin
		[161372] = { type = "cc", parent = 118 }, -- Polymorph Peacock
	[122] = { type = "roots" }, -- Frost Nova
		[33395] = { type = "roots", parent = 122 }, -- Freeze
	[11426] = { type = "buffs_defensive" }, -- Ice Barrier
	[12042] = { type = "buffs_offensive" }, -- Arcane Power
	[12051] = { type = "buffs_offensive" }, -- Evocation
	[12472] = { type = "buffs_offensive" }, -- Icy Veins
		[198144] = { type = "buffs_offensive", parent = 12472 }, -- Ice Form
	[31661] = { type = "cc" }, -- Dragon's Breath
	[45438] = { type = "immunities" }, -- Ice Block
		[41425] = { type = "buffs_other" }, -- Hypothermia
	[80353] = { type = "buffs_offensive" }, -- Time Warp
	[82691] = { type = "cc" }, -- Ring of Frost
	[108839] = { type = "buffs_offensive" }, -- Ice Floes
	[157997] = { type = "roots" }, -- Ice Nova
	[190319] = { type = "buffs_offensive" }, -- Combustion
	[198111] = { type = "buffs_defensive" }, -- Temporal Shield
	[198158] = { type = "buffs_offensive" }, -- Mass Invisibility
	[198064] = { type = "buffs_defensive" }, -- Prismatic Cloak
		[198065] = { type = "buffs_defensive", parent = 198064 }, -- Prismatic Cloak
	[205025] = { type = "buffs_offensive" }, -- Presence of Mind
	[228600] = { type = "roots" }, -- Glacial Spike Root

	-- Monk

	[115078] = { type = "cc" }, -- Paralysis
	[115203] = { type = "buffs_defensive" }, -- Fortifying Brew (Brewmaster)
		[201318] = { type = "buffs_defensive", parent = 115203 }, -- Fortifying Brew (Windwalker Honor Talent)
		[243435] = { type = "buffs_defensive", parent = 115203 }, -- Fortifying Brew (Mistweaver)
	[116706] = { type = "roots" }, -- Disable
	[116849] = { type = "buffs_defensive" }, -- Life Cocoon
	[119381] = { type = "cc" }, -- Leg Sweep
	[122278] = { type = "buffs_defensive" }, -- Dampen Harm
	[122470] = { type = "buffs_defensive" }, -- Touch of Karma
	[122783] = { type = "buffs_defensive" }, -- Diffuse Magic
	[137639] = { type = "buffs_defensive" }, -- Storm, Earth, and Fire
	[198909] = { type = "cc" }, -- Song of Chi-Ji
	[201325] = { type = "buffs_defensive" }, -- Zen Meditation
		[115176] = { type = "buffs_defensive", parent = 201325 }, -- Zen Meditation
	[202162] = { type = "buffs_defensive" }, -- Guard
	[202274] = { type = "cc" }, -- Incendiary Brew
	[216113] = { type = "buffs_defensive" }, -- Way of the Crane
	[232055] = { type = "cc" }, -- Fists of Fury
		[120086] = { type = "cc", parent = 232055 }, -- Fists of Fury
	[233759] = { type = "cc" }, -- Grapple Weapon

	-- Paladin

	[498] = { type = "buffs_defensive" }, -- Divine Protection
	[642] = { type = "immunities" }, -- Divine Shield
	[853] = { type = "cc" }, -- Hammer of Justice
	[1022] = { type = "buffs_defensive" }, -- Blessing of Protection
		[204018] = { type = "buffs_defensive" }, -- Blessing of Spellwarding
	[1044] = { type = "buffs_defensive" }, -- Blessing of Freedom
	[6940] = { type = "buffs_defensive" }, -- Blessing of Sacrifice
		[199448] = { type = "buffs_defensive", parent = 6940 }, -- Blessing of Sacrifice (Ultimate Sacrifice Honor Talent)
	[20066] = { type = "cc" }, -- Repentance
	[31821] = { type = "buffs_defensive" }, -- Aura Mastery
	[31850] = { type = "buffs_defensive" }, -- Ardent Defender
	[31884] = { type = "buffs_offensive" }, -- Avenging Wrath (Protection/Retribution)
		[31842] = { type = "buffs_offensive", parent = 31884 }, -- Avenging Wrath (Holy)
		[216331] = { type = "buffs_offensive", parent = 31884 }, -- Avenging Crusader (Holy Honor Talent)
		[231895] = { type = "buffs_offensive", parent = 31884 }, -- Crusade (Retribution Talent)
	[31935] = { type = "cc" }, -- Avenger's Shield
	[86659] = { type = "buffs_defensive" }, -- Guardian of Ancient Kings
		[212641] = { type = "buffs_defensive" }, -- Guardian of Ancient Kings (Glyphed)
		[228049] = { type = "buffs_defensive" }, -- Guardian of the Forgotten Queen
	[105809] = { type = "buffs_offensive" }, -- Holy Avenger
	[115750] = { type = "cc" }, -- Blinding Light
		[105421] = { type = "cc", parent = 115750 }, -- Blinding Light
	[152262] = { type = "buffs_offensive" }, -- Seraphim
	[184662] = { type = "buffs_defensive" }, -- Shield of Vengeance
	[204150] = { type = "buffs_defensive" }, -- Aegis of Light
	[205191] = { type = "buffs_defensive" }, -- Eye for an Eye
	[210256] = { type = "buffs_defensive" }, -- Blessing of Sanctuary
	[210294] = { type = "immunities_spells" }, -- Divine Favor
	[215652] = { type = "buffs_offensive" }, -- Shield of Virtue


	-- Priest

	[586] = { type = "buffs_defensive" }, -- Fade
		[213602] = { type = "buffs_defensive" }, -- Greater Fade
	[605] = { type = "cc", priority = true }, -- Mind Control
	[8122] = { type = "cc" }, -- Psychic Scream
	[9484] = { type = "cc" }, -- Shackle Undead
	[10060] = { type = "buffs_offensive" }, -- Power Infusion
	[15487] = { type = "cc" }, -- Silence
		[199683] = { type = "cc", parent = 15487 }, -- Last Word
	[33206] = { type = "buffs_defensive" }, -- Pain Suppression
	[47536] = { type = "buffs_defensive" }, -- Rapture
	[47585] = { type = "buffs_defensive" }, -- Dispersion
	[47788] = { type = "buffs_defensive" }, -- Guardian Spirit
	[64843] = { type = "buffs_defensive" }, -- Divine Hymn
	[81782] = { type = "buffs_defensive" }, -- Power Word: Barrier
	[87204] = { type = "cc" }, -- Sin and Punishment
	[193223] = { type = "buffs_offensive" }, -- Surrender to Madness
	[194249] = { type = "buffs_offensive" }, -- Voidform
	[196762] = { type = "buffs_defensive" }, -- Inner Focus
	[197268] = { type = "buffs_defensive" }, -- Ray of Hope
	[197862] = { type = "buffs_defensive" }, -- Archangel
	[197871] = { type = "buffs_offensive" }, -- Dark Archangel
	[200183] = { type = "buffs_defensive" }, -- Apotheosis
	[200196] = { type = "cc" }, -- Holy Word: Chastise
		[200200] = { type = "cc", parent = 200196 }, -- Holy Word: Chastise (Stun)
	[205369] = { type = "cc" }, -- Mind Bomb
		[226943] = { type = "cc", parent = 205369 }, -- Mind Bomb (Stun)
	[213610] = { type = "buffs_defensive" }, -- Holy Ward
	[215769] = { type = "buffs_defensive" }, -- Spirit of Redemption
	[221660] = { type = "immunities_spells" }, -- Holy Concentration

	-- Rogue

	[408] = { type = "cc" }, -- Kidney Shot
	[1330] = { type = "cc" }, -- Garrote - Silence
	[1776] = { type = "cc" }, -- Gouge
	[1833] = { type = "cc" }, -- Cheap Shot
	[1966] = { type = "buffs_defensive" }, -- Feint
	[2094] = { type = "cc" }, -- Blind
		[199743] = { type = "cc", parent = 2094 }, -- Parley
	[5277] = { type = "buffs_defensive" }, -- Evasion
	[6770] = { type = "cc" }, -- Sap
	[13750] = { type = "buffs_offensive" }, -- Adrenaline Rush
	[31224] = { type = "immunities_spells" }, -- Cloak of Shadows
	[51690] = { type = "buffs_offensive" }, -- Killing Spree
	[79140] = { type = "buffs_offensive" }, -- Vendetta
	[121471] = { type = "buffs_offensive" }, -- Shadow Blades
	[199754] = { type = "buffs_defensive" }, -- Riposte
	[199804] = { type = "cc" }, -- Between the Eyes
	[207736] = { type = "buffs_offensive" }, -- Shadowy Duel
	[212183] = { type = "cc" }, -- Smoke Bomb

	-- Shaman

	[2825] = { type = "buffs_offensive" }, -- Bloodlust
		[32182] = { type = "buffs_offensive", parent = 2825 }, -- Heroism
	[51514] = { type = "cc" }, -- Hex
		[196932] = { type = "cc", parent = 51514 }, -- Voodoo Totem
		[210873] = { type = "cc", parent = 51514 }, -- Hex (Compy)
		[211004] = { type = "cc", parent = 51514 }, -- Hex (Spider)
		[211010] = { type = "cc", parent = 51514 }, -- Hex (Snake)
		[211015] = { type = "cc", parent = 51514 }, -- Hex (Cockroach)
	[79206] = { type = "buffs_defensive" }, -- Spiritwalker's Grace 60 * OTHER
	[108281] = { type = "buffs_defensive" }, -- Ancestral Guidance
	[16166] = { type = "buffs_offensive" }, -- Elemental Mastery
	[64695] = { type = "roots" }, -- Earthgrab Totem
	[77505] = { type = "cc" }, -- Earthquake (Stun)
	[98008] = { type = "buffs_defensive" }, -- Spirit Link Totem
	[108271] = { type = "buffs_defensive" }, -- Astral Shift
		[210918] = { type = "buffs_defensive", parent = 108271 }, -- Ethereal Form
	[114050] = { type = "buffs_defensive" }, -- Ascendance (Elemental)
		[114051] = { type = "buffs_offensive", parent = 114050 }, -- Ascendance (Enhancement)
		[114052] = { type = "buffs_defensive", parent = 114050 }, -- Ascendance (Restoration)
	[118345] = { type = "cc" }, -- Pulverize
	[118905] = { type = "cc" }, -- Static Charge
	[197214] = { type = "cc" }, -- Sundering
	[204293] = { type = "buffs_defensive" }, -- Spirit Link
	[204366] = { type = "buffs_offensive" }, -- Thundercharge
	[204945] = { type = "buffs_offensive" }, -- Doom Winds


	-- Warlock

	[710] = { type = "cc" }, -- Banish
	[5484] = { type = "cc" }, -- Howl of Terror
	[6358] = { type = "cc" }, -- Seduction
		[115268] = { type = "cc", parent = 6358 }, -- Mesmerize
	[6789] = { type = "cc" }, -- Mortal Coil
	[20707] = { type = "buffs_defensive" }, -- Soulstone
	[22703] = { type = "cc" }, -- Infernal Awakening
	[30283] = { type = "cc" }, -- Shadowfury
	[89751] = { type = "buffs_offensive" }, -- Felstorm
		[115831] = { type = "buffs_offensive", parent = 89751 }, -- Wrathstorm
	[89766] = { type = "cc" }, -- Axe Toss
	[104773] = { type = "immunities_spells" }, -- Unending Resolve
	[108416] = { type = "buffs_defensive" }, -- Dark Pact
	[118699] = { type = "cc" }, -- Fear
		[130616] = { type = "cc", parent = 118699 }, -- Fear (Glyph of Fear)
	[171017] = { type = "cc" }, -- Meteor Strike
	[196098] = { type = "buffs_offensive" }, -- Soul Harvest
	[196364] = { type = "cc" }, -- Unstable Affliction (Silence)
	[212284] = { type = "buffs_offensive" }, -- Firestone
	[212295] = { type = "immunities_spells" }, -- Nether Ward


	-- Warrior

	[871] = { type = "buffs_defensive" }, -- Shield Wall
	[1719] = { type = "buffs_offensive" }, -- Battle Cry
	[5246] = { type = "cc" }, -- Intimidating Shout
	[12975] = { type = "buffs_defensive" }, -- Last Stand
	[18499] = { type = "buffs_other" }, -- Berserker Rage
	[23920] = { type = "immunities_spells" }, -- Spell Reflection
		[213915] = { type = "immunities_spells", parent = 23920 }, -- Mass Spell Reflection
		[216890] = { type = "immunities_spells", parent = 23920 }, -- Spell Reflection (Arms, Fury)
	[46968] = { type = "cc" }, -- Shockwave
	[97462] = { type = "buffs_defensive" }, -- Commanding Shout
	[105771] = { type = "roots" }, -- Charge (Warrior)
	[107574] = { type = "buffs_offensive" }, -- Avatar
	[118038] = { type = "buffs_defensive" }, -- Die by the Sword
	[132169] = { type = "cc" }, -- Storm Bolt
	[184364] = { type = "buffs_defensive" }, -- Enraged Regeneration
	[197690] = { type = "buffs_defensive" }, -- Defensive Stance
	[213871] = { type = "buffs_defensive" }, -- Bodyguard
	[227847] = { type = "immunities" }, -- Bladestorm (Arms)
		[46924] = { type = "immunities", parent = 227847 }, -- Bladestorm (Fury)
		[152277] = { type = "immunities", parent = 227847 }, -- Ravager
	[228920] = { type = "buffs_defensive" }, -- Ravager
	[236077] = { type = "cc" }, -- Disarm
		[236236] = { type = "cc", parent = 236077 }, -- Disarm

	-- Other

	[20549] = { type = "cc" }, -- War Stomp
	[107079] = { type = "cc" }, -- Quaking Palm
	[129597] = { type = "cc" }, -- Arcane Torrent
		[25046] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[28730] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[50613] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[69179] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[80483] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[155145] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[202719] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[202719] = { type = "cc", parent = 129597 }, -- Arcane Torrent
		[232633] = { type = "cc", parent = 129597 }, -- Arcane Torrent
	[192001] = { type = "buffs_other" }, -- Drink
		[167152] = { type = "buffs_other", parent = 192001 }, -- Refreshment

	-- Legacy (may be deprecated)

	[178858] = { type = "buffs_defensive" }, -- Contender (Draenor Garrison Ability)

	-- Special
	--[6788] = { type = "special", nounitFrames = true, noraidFrames = true }, -- Weakened Soul
}

local specDispel = {
	[65] = { -- Holy Paladin
		Magic = true,
		Poison = true,
		Disease = true,
	},
	[66] = { -- Protection Paladin
		Poison = true,
		Disease = true,
	},
	[70] = { -- Retribution Paladin
		Poison = true,
		Disease = true,
	},
	[102] = { -- Balance Druid
		Curse = true,
		Poison = true,
	},
	[103] = { -- Feral Druid
		Curse = true,
		Poison = true,
	},
	[104] = { -- Guardian Druid
		Curse = true,
		Poison = true,
	},
	[105] = { -- Restoration Druid
		Magic = true,
		Curse = true,
		Poison = true,
	},
	[256] = { -- Discipline Priest
		Magic = true,
		Disease = true,
	},
	[257] = { -- Holy Priest
		Magic = true,
		Disease = true,
	},
	[258] = { -- Shadow Priest
		Magic = true,
		Disease = true,
	},
	[262] = { -- Elemental Shaman
		Curse = true,
	},
	[263] = { -- Enhancement Shaman
		Curse = true,
	},
	[264] = { -- Restoration Shaman
		Magic = true,
		Curse = true,
	},
	[268] = { -- Brewmaster Monk
		Poison = true,
		Disease = true,
	},
	[269] = { -- Windwalker Monk
		Poison = true,
		Disease = true,
	},
	[270] = { -- Mistweaver Monk
		Magic = true,
		Poison = true,
		Disease = true,
	},
	[577] = {
		Magic = function() return GetSpellInfo(205604) end, -- Reverse Magic
	},
	[581] = {
		Magic = function() return GetSpellInfo(205604) end, -- Reverse Magic
	},
}

-- Make sure we always see these debuffs, but don't make them bigger
BigDebuffs.PriorityDebuffs = {
	233490, -- Unstable Affliction
	233496, -- Unstable Affliction
	233497, -- Unstable Affliction
	233498, -- Unstable Affliction
	233499, -- Unstable Affliction
	34914, -- Vampiric Touch
	102355, -- Faerie Swarm
	117405, -- Binding Shot
	122470, -- Touch of Karma
	208997, -- Counterstrike Totem
	770, -- Faerie Fire
	130736, -- Soul Reaper (Unholy)
}

-- Store interrupt spellId and start time
BigDebuffs.units = {}

local units = {
	"player",
	"pet",
	"target",
	"focus",
	"party1",
	"party2",
	"party3",
	"party4",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
}

local unitsWithRaid = {
	"player",
	"pet",
	"target",
	"focus",
	"party1",
	"party2",
	"party3",
	"party4",
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
}

for i = 1, 40 do
	table.insert(unitsWithRaid, "raid" .. i)
end

local UnitDebuff, UnitBuff = UnitDebuff, UnitBuff

local GetAnchor = {
	ShadowedUnitFrames = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame.portrait and frame.portrait:IsShown() then
			return frame.portrait, frame
		else
			return frame, frame, true
		end
	end,
	ZPerl = function(anchor)
		local frame = _G[anchor]
		if not frame then return end
		if frame:IsShown() then
			return frame, frame
		else
			frame = frame:GetParent()
			return frame, frame, true
		end
	end,
}

local anchors = {
	["ElvUI"] = {
		noPortait = true,
		units = {
			player = "ElvUF_Player",
			pet = "ElvUF_Pet",
			target = "ElvUF_Target",
			focus = "ElvUF_Focus",
			party1 = "ElvUF_PartyGroup1UnitButton1",
			party2 = "ElvUF_PartyGroup1UnitButton2",
			party3 = "ElvUF_PartyGroup1UnitButton3",
			party4 = "ElvUF_PartyGroup1UnitButton4",
		},
	},
	["bUnitFrames"] = {
		noPortait = true,
		alignLeft = true,
		units = {
			player = "bplayerUnitFrame",
			pet = "bpetUnitFrame",
			target = "btargetUnitFrame",
			focus = "bfocusUnitFrame",
			arena1 = "barena1UnitFrame",
			arena2 = "barena2UnitFrame",
			arena3 = "barena3UnitFrame",
			arena4 = "barena4UnitFrame",
		},
	},
	["Shadowed Unit Frames"] = {
		func = GetAnchor.ShadowedUnitFrames,
		units = {
			player = "SUFUnitplayer",
			pet = "SUFUnitpet",
			target = "SUFUnittarget",
			focus = "SUFUnitfocus",
			party1 = "SUFHeaderpartyUnitButton1",
			party2 = "SUFHeaderpartyUnitButton2",
			party3 = "SUFHeaderpartyUnitButton3",
			party4 = "SUFHeaderpartyUnitButton4",
		},
	},
	["ZPerl"] = {
		func = GetAnchor.ZPerl,
		units = {
			player = "XPerl_PlayerportraitFrame",
			pet = "XPerl_Player_PetportraitFrame",
			target = "XPerl_TargetportraitFrame",
			focus = "XPerl_FocusportraitFrame",
			party1 = "XPerl_party1portraitFrame",
			party2 = "XPerl_party2portraitFrame",
			party3 = "XPerl_party3portraitFrame",
			party4 = "XPerl_party4portraitFrame",
		},
	},
	["Blizzard"] = {
		units = {
			player = "PlayerPortrait",
			pet = "PetPortrait",
			target = "TargetFramePortrait",
			focus = "FocusFramePortrait",
			party1 = "PartyMemberFrame1Portrait",
			party2 = "PartyMemberFrame2Portrait",
			party3 = "PartyMemberFrame3Portrait",
			party4 = "PartyMemberFrame4Portrait",
			arena1 = "ArenaEnemyFrame1ClassPortrait",
			arena2 = "ArenaEnemyFrame2ClassPortrait",
			arena3 = "ArenaEnemyFrame3ClassPortrait",
			arena4 = "ArenaEnemyFrame4ClassPortrait",
			arena5 = "ArenaEnemyFrame5ClassPortrait",
		},
	},
}

function BigDebuffs:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BigDebuffsDB", defaults, true)

	-- Upgrade old database
	if type(self.db.profile.raidFrames.dispellable) == "number" then
		self.db.profile.raidFrames.dispellable = {
			cc = self.db.profile.raidFrames.dispellable,
			roots = self.db.profile.raidFrames.roots
		}
	end
	for i = 1, #units do
		local key = units[i]:gsub("%d", "")
		if type(self.db.profile.unitFrames[key]) == "boolean" then
			self.db.profile.unitFrames[key] = {
				enabled = self.db.profile.unitFrames[key],
				anchor = "auto",
			}
		end
	end

	self.db.RegisterCallback(self, "OnProfileChanged", "Refresh")
	self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
	self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
	self.frames = {}
	self.UnitFrames = {}
	self:SetupOptions()
end

local function HideBigDebuffs(frame)
	if not frame.BigDebuffs then return end
	for i = 1, #frame.BigDebuffs do
		frame.BigDebuffs[i]:Hide()
	end
end

function BigDebuffs:Refresh()
	for frame, _ in pairs(self.frames) do
		if frame:IsVisible() then CompactUnitFrame_UpdateDebuffs(frame) end
		if frame and frame.BigDebuffs then self:AddBigDebuffs(frame) end
	end
	for unit, frame in pairs(self.UnitFrames) do
		frame:Hide()
		frame.current = nil
		frame.cooldown:SetHideCountdownNumbers(not self.db.profile.unitFrames.cooldownCount)
		frame.cooldown.noCooldownCount = not self.db.profile.unitFrames.cooldownCount
		self:UNIT_AURA(unit)
	end
end

function BigDebuffs:AttachUnitFrame(unit)
	if InCombatLockdown() then return end

	local frame = self.UnitFrames[unit]
	local frameName = "BigDebuffs" .. unit .. "UnitFrame"

	if not frame then
		frame = CreateFrame("Button", frameName, UIParent, "BigDebuffsUnitFrameTemplate")
		self.UnitFrames[unit] = frame
		frame:SetScript("OnEvent", function() self:UNIT_AURA(unit) end)
		frame.icon:SetDrawLayer("BORDER")
		frame:RegisterUnitEvent("UNIT_AURA", unit)
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame.unit = unit
	end

	frame:EnableMouse(self.test)

	_G[frameName.."Name"]:SetText(self.test and not frame.anchor and unit)

	frame.anchor = nil
	frame.blizzard = nil

	local config = self.db.profile.unitFrames[unit:gsub("%d", "")]

	if config.anchor == "auto" then
		-- Find a frame to attach to
		for k,v in pairs(anchors) do
			local anchor, parent, noPortait
			if v.units[unit] then
				if v.func then
					anchor, parent, noPortait = v.func(v.units[unit])
				else
					anchor = _G[v.units[unit]]
				end

				if anchor then
					frame.anchor, frame.parent, frame.noPortait = anchor, parent, noPortait
					if v.noPortait then frame.noPortait = true end
					frame.alignLeft = v.alignLeft
					frame.blizzard = k == "Blizzard"
					if not frame.blizzard then break end
				end
			end
		end
	end

	if frame.anchor then
		if frame.blizzard then
			-- Blizzard Frame
			frame:SetParent(frame.anchor:GetParent())
			frame:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.cooldown:SetFrameLevel(frame.anchor:GetParent():GetFrameLevel())
			frame.anchor:SetDrawLayer("BACKGROUND")
			frame.cooldown:SetSwipeTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMaskSmall")
		else
			frame:SetParent(frame.parent and frame.parent or frame.anchor)
			frame:SetFrameLevel(99)
		end

		frame:ClearAllPoints()

		if frame.noPortait then
			-- No portrait, so attach to the side
			if frame.alignLeft then
				frame:SetPoint("TOPRIGHT", frame.anchor, "TOPLEFT")
			else
				frame:SetPoint("TOPLEFT", frame.anchor, "TOPRIGHT")
			end
			local height = frame.anchor:GetHeight()
			frame:SetSize(height, height)
		else
			frame:SetAllPoints(frame.anchor)
		end
	else
		-- Manual
		frame:SetParent(UIParent)
		frame:ClearAllPoints()

		if not self.db.profile.unitFrames[unit] then self.db.profile.unitFrames[unit] = {} end

		if self.db.profile.unitFrames[unit].position then
			frame:SetPoint(unpack(self.db.profile.unitFrames[unit].position))
		else
			-- No saved position, anchor to the blizzard position
			LoadAddOn("Blizzard_ArenaUI")
			local relativeFrame = _G[anchors.Blizzard.units[unit]] or UIParent
			frame:SetPoint("CENTER", relativeFrame, "CENTER")
		end

		frame:SetSize(config.size, config.size)
	end

end

function BigDebuffs:SaveUnitFramePosition(frame)
	self.db.profile.unitFrames[frame.unit].position = { frame:GetPoint() }
end

function BigDebuffs:Test()
	self.test = not self.test
	self:Refresh()
end

local TestDebuffs = {}

local function InsertTestDebuff(spellID, dispelType)
	local texture = GetSpellTexture(spellID)
	table.insert(TestDebuffs, { spellID, texture, 0, dispelType })
end

local function UnitDebuffTest(unit, index)
	local debuff = TestDebuffs[index]
	if not debuff then return end
	return "Test", debuff[2], 0, debuff[4], 9, GetTime() + 9, nil, nil, nil, debuff[1]
end

function BigDebuffs:OnEnable()
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("UNIT_PET")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	self:PLAYER_TALENT_UPDATE()

	-- Prevent OmniCC finish animations
	if OmniCC then
		self:RawHook(OmniCC, "TriggerEffect", function(object, cooldown)
			local name = cooldown:GetName()
			if name and name:find("BigDebuffs") then return end
			self.hooks[OmniCC].TriggerEffect(object, cooldown)
		end, true)
	end

	InsertTestDebuff(8122, "Magic") -- Psychic Scream
	InsertTestDebuff(408, nil) -- Kidney Shot
	InsertTestDebuff(233490, "Magic") -- Unstable Affliction
	InsertTestDebuff(339, "Magic") -- Entangling Roots
	InsertTestDebuff(114404, nil) -- Void Tendrils
	InsertTestDebuff(589, "Magic") -- Shadow Word: Pain
	InsertTestDebuff(772, nil) -- Rend

end

function BigDebuffs:PLAYER_ENTERING_WORLD()
	for i = 1, #units do
		self:AttachUnitFrame(units[i])
	end
end

function BigDebuffs:COMBAT_LOG_EVENT_UNFILTERED(_, _, event, ...)

	-- SPELL_INTERRUPT doesn't fire for some channeled spells
	if event ~= "SPELL_INTERRUPT" and event ~= "SPELL_CAST_SUCCESS" then return end

	local _,_,_,_,_, destGUID, _,_,_, spellId = CombatLogGetCurrentEventInfo()
	local spell = self.Spells[spellId]

	if not spell or spell.type ~= "interrupts" then return end

	-- Find unit
	for i = 1, #unitsWithRaid do
		local unit = unitsWithRaid[i]
		if destGUID == UnitGUID(unit) and (event ~= "SPELL_CAST_SUCCESS" or select(7, UnitChannelInfo(unit)) == false) then
			local duration = spell.duration
			local _, class = UnitClass(unit)

			if class == "PRIEST" or class == "SHAMAN" or class == "WARLOCK" then
				duration = duration * 0.7
			end

			if UnitBuff(unit, "Burning Determination") or UnitBuff(unit, "Calming Waters") or UnitBuff(unit, "Casting Circle") then
				duration = duration * 0.3
			end

			self.units[destGUID] = self.units[destGUID] or {}
			self.units[destGUID].expires = GetTime() + duration
			self.units[destGUID].spellId = spellId

			-- Make sure we clear it after the duration
			C_Timer.After(duration, function()
				self:UNIT_AURA_ALL_UNITS()
			end)

			self:UNIT_AURA_ALL_UNITS()

			return

		end
	end
end

function BigDebuffs:UNIT_AURA_ALL_UNITS()
	for i = 1, #unitsWithRaid do
		local unit = unitsWithRaid[i]

		if self.AttachedFrames[unit] then
			self:ShowBigDebuffs(self.AttachedFrames[unit])
		end

		if not unit:match("^raid") then
			self:UNIT_AURA(unit)
		end
	end
end

BigDebuffs.AttachedFrames = {}

local MAX_BUFFS = 6

function BigDebuffs:AddBigDebuffs(frame)
	if not frame or not frame.displayedUnit or not UnitIsPlayer(frame.displayedUnit) then return end
	local frameName = frame:GetName()
	if self.db.profile.raidFrames.increaseBuffs then
		for i = 4, MAX_BUFFS do
			local buffPrefix = frameName .. "Buff"
			local buffFrame = _G[buffPrefix .. i] or CreateFrame("Button", buffPrefix .. i, frame, "CompactBuffTemplate")
			buffFrame:ClearAllPoints()
			if math.fmod(i - 1, 3) == 0 then
				buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 3], "TOPRIGHT")
			else
				buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 1], "BOTTOMLEFT")
			end
		end
	end

	self.AttachedFrames[frame.displayedUnit] = frame

	frame.BigDebuffs = frame.BigDebuffs or {}
	local max = self.db.profile.raidFrames.maxDebuffs + 1 -- add a frame for warning debuffs
	for i = 1, max do
		local big = frame.BigDebuffs[i] or
			CreateFrame("Button", frameName .. "BigDebuffsRaid" .. i, frame, "CompactDebuffTemplate")
		big:ClearAllPoints()
		if i > 1 then
			if self.db.profile.raidFrames.anchor == "INNER" then
				big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "LEFT" then
				big:SetPoint("BOTTOMRIGHT", frame.BigDebuffs[i-1], "BOTTOMLEFT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "RIGHT" then
				big:SetPoint("BOTTOMLEFT", frame.BigDebuffs[i-1], "BOTTOMRIGHT", 0, 0)
			end
		else
			if self.db.profile.raidFrames.anchor == "INNER" then
				big:SetPoint("BOTTOMLEFT", frame.debuffFrames[1], "BOTTOMLEFT", 0, 0)
			elseif self.db.profile.raidFrames.anchor == "LEFT" then
				big:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 0, 1)
			elseif self.db.profile.raidFrames.anchor == "RIGHT" then
				big:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 1)
			end
		end

		big.cooldown:SetHideCountdownNumbers(not self.db.profile.raidFrames.cooldownCount)
		big.cooldown.noCooldownCount = not self.db.profile.raidFrames.cooldownCount

		big.cooldown:SetDrawEdge(false)
		frame.BigDebuffs[i] = big
		big:Hide()
		self.frames[frame] = true
		self:ShowBigDebuffs(frame)
	end
	return true
end

local pending = {}

hooksecurefunc("CompactUnitFrame_UpdateAll", function(frame)
	if frame:IsForbidden() then return end
	local name = frame:GetName()
	if not name or not name:match("^Compact") then return end
	if InCombatLockdown() and not frame.BigDebuffs then
		if not pending[frame] then pending[frame] = true end
	else
		BigDebuffs:AddBigDebuffs(frame)
	end
end)

function BigDebuffs:PLAYER_TALENT_UPDATE()
	local specID = GetSpecializationInfo(GetSpecialization() or 1)
	self.specDispel = specID and specDispel[specID] and specDispel[specID]
end

function BigDebuffs:PLAYER_REGEN_ENABLED()
	for frame,_ in pairs(pending) do
		BigDebuffs:AddBigDebuffs(frame)
		pending[frame] = nil
	end
end

local function IsPriorityDebuff(id)
	for i = 1, #BigDebuffs.PriorityDebuffs do
		if id == BigDebuffs.PriorityDebuffs[i] then
			return true
		end
	end
end

hooksecurefunc("CompactUnitFrame_HideAllDebuffs", HideBigDebuffs)

function BigDebuffs:IsDispellable(dispelType)
	if not dispelType or not self.specDispel then return end
	if type(self.specDispel[dispelType]) == "function" then return self.specDispel[dispelType]() end
	return self.specDispel[dispelType]
end

function BigDebuffs:GetDebuffSize(id, dispellable)
	if self.db.profile.raidFrames.pve > 0 then
		local _, instanceType = IsInInstance()
		if dispellable and instanceType and (instanceType == "raid" or instanceType == "party") then
			return self.db.profile.raidFrames.pve
		end
	end

	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID

	local category = self.Spells[id].type

	if not category or not self.db.profile.raidFrames[category] then return end

	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].raidFrames and self.db.profile.spells[id].raidFrames == 0 then return end
		if self.db.profile.spells[id].size then return self.db.profile.spells[id].size end
	end

	if self.Spells[id].noraidFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].raidFrames) then
		return
	end

	local dispellableSize = self.db.profile.raidFrames.dispellable[category]
	if dispellable and dispellableSize and dispellableSize > 0 then return dispellableSize end

	if self.db.profile.raidFrames[category] > 0 then
		return self.db.profile.raidFrames[category]
	end
end

-- For raid frames
function BigDebuffs:GetDebuffPriority(id)
	if not self.Spells[id] then return 0 end
	id = self.Spells[id].parent or id -- Check for parent spellID

	return self.db.profile.spells[id] and self.db.profile.spells[id].priority or
		self.db.profile.priority[self.Spells[id].type] or 0
end

-- For unit frames
function BigDebuffs:GetAuraPriority(id)
	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID
    if not self.Spells[id] then return end

	-- Make sure category is enabled
	if not self.db.profile.unitFrames[self.Spells[id].type] then return end

	-- Check for user set
	if self.db.profile.spells[id] then
		if self.db.profile.spells[id].unitFrames and self.db.profile.spells[id].unitFrames == 0 then return end
		if self.db.profile.spells[id].priority then return self.db.profile.spells[id].priority end
	end

	if self.Spells[id].nounitFrames and (not self.db.profile.spells[id] or not self.db.profile.spells[id].unitFrames) then
		return
	end

	return self.db.profile.priority[self.Spells[id].type] or 0
end

-- Copy this function to check for testing mode
local function CompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff, test)
	local UnitDebuff = test and UnitDebuffTest or UnitDebuff
	-- make sure you are using the correct index here!
	--isBossAura says make this look large.
	--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId;

	if index == -1 then
		-- it's an interrupt
		local spell = BigDebuffs.units[UnitGUID(unit)]
		spellId = spell.spellId
		icon = GetSpellTexture(spellId)
		count = 1
		duration = BigDebuffs.Spells[spellId].duration
		expirationTime = spell.expires
	else
		if (isBossBuff) then
			name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId = UnitBuff(unit, index, filter);
		else
			name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, shouldConsolidate, spellId = UnitDebuff(unit, index, filter);
		end
	end

	debuffFrame.filter = filter;
	debuffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 10 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame:SetID(index);
	if ( expirationTime and expirationTime ~= 0 ) then
		local startTime = expirationTime - duration;
		debuffFrame.cooldown:SetCooldown(startTime, duration);
		debuffFrame.cooldown:Show();
	else
		debuffFrame.cooldown:Hide();
	end

	local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

	debuffFrame.isBossBuff = isBossBuff;
	if ( isBossAura ) then
		debuffFrame:SetSize(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE);
	else
		debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize);
	end

	debuffFrame:Show();
end

function BigDebuffs:ShowBigDebuffs(frame)

	if not self.db.profile.raidFrames.enabled or not frame.debuffFrames or not frame.BigDebuffs then return end

	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end

	local UnitDebuff = self.test and UnitDebuffTest or UnitDebuff

	HideBigDebuffs(frame)

	local debuffs = {}
	local big
	local now = GetTime()
	local warning, warningId

	for i = 1, 40 do
		local _,_,_, dispelType, _, time, caster, _,_, id = UnitDebuff(frame.displayedUnit, i)
		if id then
			local reaction = caster and UnitReaction("player", caster) or 0
			local friendlySmokeBomb = id == 212183 and reaction > 4
			local size = self:GetDebuffSize(id, self:IsDispellable(dispelType))
			if size and not friendlySmokeBomb then
				big = true
				local duration = time and time - now or 0
				tinsert(debuffs, { i, size, duration, self:GetDebuffPriority(id) })
			elseif self.db.profile.raidFrames.redirectBliz or
			(self.db.profile.raidFrames.anchor == "INNER" and not self.db.profile.raidFrames.hideBliz) then
				if not frame.optionTable.displayOnlyDispellableDebuffs or self:IsDispellable(dispelType) then
					tinsert(debuffs, { i, self.db.profile.raidFrames.default, 0, 0 }) -- duration 0 to preserve Blizzard order
				end
			end

			-- Set warning debuff
			local k
			for j = 1, #self.WarningDebuffs do
				if id == self.WarningDebuffs[j] and
				self.db.profile.raidFrames.warningList[id] and
				not friendlySmokeBomb and
				(not k or j < k) then
					k = j
					warning = i
					warningId = id
				end
			end
		end
	end

	-- check for interrupts
	local guid = UnitGUID(frame.displayedUnit)
	if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
		local spellId = self.units[guid].spellId
		local size = self:GetDebuffSize(spellId, false)
		if size then
			big = true
			tinsert(debuffs, { -1, size, 0, self:GetDebuffPriority(id) })
		end
	end

	if #debuffs > 0 then
		-- insert the warning debuff if it exists and we have a big debuff
		if big and warning then
			local size = self.db.profile.raidFrames.warning
			-- remove duplicate
			for k,v in pairs(debuffs) do
				if v[1] == warning then
					if self.Spells[warningId] then size = v[2] end -- preserve the size
					table.remove(debuffs, k)
					break
				end
			end
			tinsert(debuffs, { warning, size, 0, 0, true })
		else
			warning = nil
		end

		-- sort by priority > size > duration > index
		table.sort(debuffs, function(a, b)
			if a[4] == b[4] then
				if a[2] == b[2] then
					if a[3] < b[3] then return true end
					if a[3] == b[3] then return a[1] < b[1] end
				end
				return a[2] > b[2]
			end
			return a[4] > b[4]
		end)

		local index = 1

		if self.db.profile.raidFrames.hideBliz or
		self.db.profile.raidFrames.anchor == "INNER" or
		self.db.profile.raidFrames.redirectBliz then
			CompactUnitFrame_HideAllDebuffs(frame)
		end

		for i = 1, #debuffs do
			if index <= self.db.profile.raidFrames.maxDebuffs or debuffs[i][1] == warning then
				if not frame.BigDebuffs[index] then break end
				frame.BigDebuffs[index].baseSize = frame:GetHeight() * debuffs[i][2] * 0.01
				CompactUnitFrame_UtilSetDebuff(frame.BigDebuffs[index], frame.displayedUnit, debuffs[i][1], nil, false, false, self.test)
				frame.BigDebuffs[index].cooldown:SetSwipeColor(0, 0, 0, 0.7)
				index = index + 1
			end
		end

	end

end

-- We need to copy the entire function to avoid taint
hooksecurefunc("CompactUnitFrame_UpdateDebuffs", function(frame)
	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end

	if ( not frame.optionTable.displayDebuffs ) then
		CompactUnitFrame_HideAllDebuffs(frame);
		return;
	end
	local test = BigDebuffs.test
	local UnitDebuff = test and UnitDebuffTest or UnitDebuff
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	local maxDebuffs = frame.maxDebuffs;
	--Show both Boss buffs & debuffs in the debuff location
	--First, we go through all the debuffs looking for any boss flagged ones.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) ) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, false, test);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	--Then we go through all the buffs looking for any boss flagged ones.
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitBuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, true, true, test);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end

	--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName, _,_,_,_,_,_,_,_, id = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if ( CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) or IsPriorityDebuff(id)) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false, test);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end

	if ( frame.optionTable.displayOnlyDispellableDebuffs ) then
		filter = "RAID";
	end

	index = 1;
	--Now, we display all normal debuffs.
	if ( frame.optionTable.displayNonBossDebuffs ) then
	while ( frameNum <= maxDebuffs ) do
		local debuffName, _,_,_,_,_,_,_,_, id = UnitDebuff(frame.displayedUnit, index, filter);
		if ( debuffName ) then
			if BigDebuffs.test or (( CompactUnitFrame_UtilShouldDisplayDebuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, false) and
				not CompactUnitFrame_UtilIsPriorityDebuff(frame.displayedUnit, index, filter) and not IsPriorityDebuff(id))) then
				local debuffFrame = frame.debuffFrames[frameNum];
				CompactUnitFrame_UtilSetDebuff(debuffFrame, frame.displayedUnit, index, filter, false, false, test);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	end

	for i=frameNum, frame.maxDebuffs do
		local debuffFrame = frame.debuffFrames[i];
		debuffFrame:Hide();
	end

	BigDebuffs:ShowBigDebuffs(frame)
end)

function BigDebuffs:IsPriorityBigDebuff(id)
	if not self.Spells[id] then return end
	id = self.Spells[id].parent or id -- Check for parent spellID
	return self.Spells[id].priority
end

function BigDebuffs:UNIT_AURA(unit)
	if not self.db.profile.unitFrames.enabled or not self.db.profile.unitFrames[unit:gsub("%d", "")].enabled then return end

	self:AttachUnitFrame(unit)

	local frame = self.UnitFrames[unit]
	if not frame then return end

	local UnitDebuff = BigDebuffs.test and UnitDebuffTest or UnitDebuff

	local now = GetTime()
	local left, priority, duration, expires, icon, debuff, buff, interrupt = 0, 0

	for i = 1, 40 do
		-- Check debuffs
		local _, n, _,_, d, e, caster, _,_, id = UnitDebuff(unit, i)
		if id then
			if self.Spells[id] then
				local reaction = caster and UnitReaction("player", caster) or 0
				local friendlySmokeBomb = id == 212183 and reaction > 4
				local p = self:GetAuraPriority(id)
				if p and p >= priority and not friendlySmokeBomb then
					if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
						left = e - now
						duration = d
						debuff = i
						priority = p
						expires = e
						icon = n
					end
				end
			end
		end

		-- Check buffs
		local _, n, _,_, d, e, _,_,_, id = UnitBuff(unit, i)
		if id then
			if self.Spells[id] then
				local p = self:GetAuraPriority(id)
				if p and p >= priority then
					if p > priority or self:IsPriorityBigDebuff(id) or e == 0 or e - now > left then
						left = e - now
						duration = d
						debuff = i
						priority = p
						expires = e
						icon = n
						buff = true
					end
				end
			end
		end
	end

	-- Check for interrupt
	local guid = UnitGUID(unit)
	if guid and self.units[guid] and self.units[guid].expires and self.units[guid].expires > GetTime() then
		local spell = self.units[guid]
		local spellId = spell.spellId
		local p = self:GetAuraPriority(spellId)
		if p and p >= priority then
			left = spell.expires - now
			duration = self.Spells[spellId].duration
			debuff = spellId
			expires = spell.expires
			icon = GetSpellTexture(spellId)
			interrupt = spellId
		end
	end


	if debuff then
		if duration < 1 then duration = 1 end -- auras like Solar Beam don't have a duration

		if frame.current ~= icon then
			if frame.blizzard then
				-- Blizzard Frame
				SetPortraitToTexture(frame.icon, icon)

				-- Adapt
				if frame.anchor and Adapt and Adapt.portraits[frame.anchor] then
					Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("BACKGROUND")
				end
			else
				frame.icon:SetTexture(icon)
			end
		end

		frame.cooldown:SetCooldown(expires - duration, duration)
		frame:Show()
		frame.cooldown:SetSwipeColor(0, 0, 0, 0.6)

		-- set for tooltips
		frame:SetID(debuff)
		frame.buff = buff
		frame.interrupt = interrupt
		frame.current = icon
        if GridStatusBigDebuffs then GridStatusBigDebuffs:SendGained(unit, icon, expires, duration) end
	else
		-- Adapt
		if frame.anchor and frame.blizzard and Adapt and Adapt.portraits[frame.anchor] then
			Adapt.portraits[frame.anchor].modelLayer:SetFrameStrata("LOW")
		end

		frame:Hide()
		frame.current = nil
        if GridStatusBigDebuffs then GridStatusBigDebuffs:SendLost(unit) end
	end
end

function BigDebuffs:PLAYER_FOCUS_CHANGED()
	self:UNIT_AURA("focus")
end

function BigDebuffs:PLAYER_TARGET_CHANGED()
	self:UNIT_AURA("target")
end

function BigDebuffs:UNIT_PET()
	self:UNIT_AURA("pet")
end

-- Show extra buffs
-- Setting frame.maxBuffs causes taint, so we need to copy entire function (FrameXML/CompactUnitFrame.lua)
hooksecurefunc("CompactUnitFrame_UpdateBuffs", function(frame)

	if not UnitIsPlayer(frame.displayedUnit) then
		return
	end

	if not BigDebuffs.db.profile.raidFrames.increaseBuffs then return end

	if ( not frame.optionTable.displayBuffs ) then
		CompactUnitFrame_HideAllBuffs(frame);
		return;
	end

	local index = 1;
	local frameNum = 1;
	local filter = nil;
	while ( frameNum <= MAX_BUFFS ) do
		local buffName = UnitBuff(frame.displayedUnit, index, filter);
		if ( buffName ) then
			if ( CompactUnitFrame_UtilShouldDisplayBuff(frame.displayedUnit, index, filter) and not CompactUnitFrame_UtilIsBossAura(frame.displayedUnit, index, filter, true) ) then
				local buffFrame = frame.buffFrames[frameNum];
				if buffFrame then CompactUnitFrame_UtilSetBuff(buffFrame, frame.displayedUnit, index, filter); end
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	for i=frameNum, MAX_BUFFS do
		local buffFrame = frame.buffFrames[i];
		if buffFrame then buffFrame:Hide() end
	end
end)

SLASH_BigDebuffs1 = "/bd"
SLASH_BigDebuffs2 = "/bigdebuffs"
SlashCmdList.BigDebuffs = function(msg)
	InterfaceOptionsFrame_OpenToCategory("BigDebuffs")
	InterfaceOptionsFrame_OpenToCategory("BigDebuffs")
end
