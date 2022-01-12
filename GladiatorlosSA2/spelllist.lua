function GladiatorlosSA:GetSpellList()
	return {
		auraApplied ={					-- aura applied [spellid] = ".ogg file name",
			-- GENERAL

			-- General (Aura Applied)
			[195901] = "trinket1",
			[214027] = "trinket1",
			[336139] = "trinket1",
			[34709] = "shadowSight",
			-- Drinking
			[104270] = "drinking",
			[167152] = "drinking",
			[5006] = "drinking",
			[274194] = "drinking",
			[262568] = "drinking",
			[274913] = "drinking",
			[257427] = "drinking",
			[257428] = "drinking",
			[272819] = "drinking",
			[279739] = "drinking",
			--Was I drunk when I did this??
			[345231] = "battlemaster",

			-- Crowd Controls
			--Polymorph (Mage)
			[118] = "success", -- Sheep
			[28271] = "success", -- Turtle
			[28272] = "success", -- Pig
			[61305] = "success", -- Black Cat
			[61721] = "success", -- Rabbit
			[61025] = "success", -- Serpent
			[61780] = "success", -- Turkey
			[161372] = "success", -- Peacock
			[161355] = "success", -- Penguin
			[161353] = "success", -- Polar Bear Cub
			[161354] = "success", -- Monkey
			[126819] = "success", -- Porcupine
			[277787] = "success", -- Direhorn
			[277792] = "success", -- Bumblebee

			--Hex (Shaman)
			[51514] = "success", -- Frog
			[210873] = "success", -- Compy
			[211004] = "success", -- Spider
			[211015] = "success", -- Cockroach
			[211010] = "success", -- Snake
			[269352] = "success", -- Skeletal Hatchling
			[277778] = "success", -- Zandalari Tendonripper
			[277784] = "success", -- Wicker Mongrel
			[309328] = "success", -- Living Honey
			-- Others
			[5782] = "success", -- Fear (Warlock)
			[118699] = "success", -- Fear (Warlock) because different spellID for some stupid reason
			[33786] = "success", -- Cyclone (Druid)
			--[209753] = "success", -- Cyclone (Druid)
			[19386] = "success", --Wyvern Sting (Hunter)
			[20066] = "success", -- Repentence (Paladin)
			[605] = "success", -- Mind Control (Priest)
			[2637] = "success", -- Hibernate (Druid)
			[1513] = "success", -- Scare Beast (Hunter)
			[339] = "success", -- Entangling Roots
			[235963] = "success", -- Entangling Roots Feral Talent

			-- Covenant Abilities
			[310143] = "soulshape", -- Nightfae Signature
			[319217] = "podtender", -- Nightfae Cheat Death
			[320224] = "podtender", -- Nightfae Cheat Death
			[327676] = "forgeborne", -- Forgeborne (Necrolord Soulbind)
			[323095] = "UltimateForm", -- Necro
			[323524] = "UltimateForm", -- Necro
			[330752] = "AscendantPhial", -- Kyrian Kleia Soulbind debuff immunity for SOME REASON THIS IS A THING
			[331937] = "euphoria",

			-- Backlash (Aura Applied)
			[87204] = "backlashFear", -- Vampiric Touch Dispel (Priest)
			[196364] = "backlashSilence", -- Unstable Affliction Dispel (Warlock)

			-- Death Knight (Aura Applied)
			[48792] = "iceboundFortitude",
			[55233] = "vampiricBlood",
			[51271] = "pillarofFrost",
			[48707] = "antiMagicShell",
			[152279] = "BreathOfSindragosa",
			[219809] = "tombstone",
			[194679] = "runetap",
			[194844] = "bonestorm",
			--[206977] = "bloodmirror",
			--[207256] = "obliteration",
			[207319] = "corpseShield",
			[287254] = "remorselessWinter",
			[212332] = "smash",
			[212337] = "smash",
			[91800] = "smash",
			[91797] = "smash",
			[116888] = "Purgatory", -- Purgatory
			[49039] = "lichborne", -- Lichborne
			[288977] = "transfusion",
			[315443] = "abominationLimb",
			[311648] = "swarmingmist", -- Venthyr

			-- Demon Hunter (Aura Applied)
			[198589] = "blur",
			[212800] = "blur",
			[162264] = "metamorphosis",
			[187827] = "metamorphosis", -- Vengeance
			[188501] = "spectralSight",
			[196555] = "netherwalk",
			--[207810] = "netherBond",

			-- Druid (Aura Applied)
			[102560] = "incarnationElune",
			[102543] = "incarnationKitty",
			[102558] = "incarnationUrsoc",
			[33891] = "incarnationTree",
			[61336] = "survivalInstincts",
			[22812] = "barkskin",
			[1850] = "dash",
			[252216] = "dash", -- Tiger Dash
			[106951] = "berserk",
			[69369] = "PredatorSwiftness",
			[112071] = "celestialAlignment",
			[194223] = "celestialAlignment",
			[102342] = "ironBark",
			[102351] = "cenarionWard",
			[155835] = "BristlingFur",
			[29166] = "innervate",
			--[200851] = "rageOfSleeper",
			--[203727] = "thorns", -- (Resto)
			[236696] = "thorns", -- (Feral/Balance)
			[305497] = "thorns", -- Resto/Feral/Balance 8.2
			[163505] = "rakeStun",
			--[323557] = "ravenousFrenzy", -- Venthyr
			[108291] = "heartOfTheWild", -- Heart of the Wild
			[108292] = "heartOfTheWild", -- Heart of the Wild
			[108293] = "heartOfTheWild", -- Heart of the Wild
			[108294] = "heartOfTheWild", -- Heart of the Wild
			[323546] = "ravenousfrenzy", -- Venthyr
			[22842] = "FrenziedRegen",
			[132158] = "naturesSwiftness",

			-- Hunter (Aura Applied)
			[19263] = "deterrence",
			[186265] = "deterrence", -- Aspect of the Turtle
			[53271] = "mastersCall",
			[53480] = "roarOfSacrifice", -- Pet Skill
			[186257] = "cheetah",
			[212640] = "mendingBandage",
			--[193526] = "trueShot",
			[288613] = "trueShot",
			[193530] = "trueShot",	-- Aspect of the Wild
			[266779] = "trueShot",	-- Coordinated Assault
			--[186289] = "eagle",
			[3355] = "trapped", -- Freezing Trap Success
			[202748] = "survivalTactics", -- Survival Tactics (Honor Talent Feign Death Passive)
			[212704] = "beastWithin", -- The Beast Within; Beastial Wrath Fear/Horror Immunity Honor Talent
			[260402] = "doubletap",
			[356727] = "spiderSting",
			[357021] = "concussion", -- Consecutive Concussion

			-- Mage (Aura Applied)
			[45438] = "iceBlock",
			[12042] = "arcanePower",
			[12472] = "icyVeins",
			[198111] = "temporalShield",
			[198144] = "iceForm",
			[86949] = "cauterize",
			[87024] = "cauterize",
			[190319] = "Combustion",
			[110909] = "alterTime",
			[342246] = "alterTime",
			[108978] = "alterTime",
			[324220] = "deathborne", -- Necrolord
			[353128] = "arcanosphere",
			[82691] = "frozen", -- Ring of Froze Debuff
			[353084] = "burns", -- Ring of Fire Debuff

			-- Monk (Aura Applied)
			[122278] = "dampenHarm",
			[122783] = "diffuseMagic",
			[115203] = "fortifyingBrew", --Fortifying Brew (Brewmaster)
			[201318] = "fortifyingBrew", --Fortifying Brew (Windwalker PvP Talent)
			[243435] = "fortifyingBrew", --Fortifying Brew (Mistweaver)
			[115176] = "zenMeditation", -- Zen Meditation (Brewmaster)
			--[201325] = "zenMoment", --Zen Moment (PvP Talent)
			[116849] = "lifeCocoon",
			--[122470] = "touchOfKarma",
			--[125174] = "touchOfKarma", --Test
			[152173] = "Serenity",
			--[216113] = "fistweaving", --Way of the Crane
			[197908] = "manaTea",
			[209584] = "zenFocusTea",
			[202335] = "doubleBarrel", -- Double Barrel (Brewmaster Honor Talent that stuns)
			[310454] = "weaponoforder", -- Kyrian
			[353361] = "dematerialize",
						
			-- Paladin (Aura Applied)
			[1022] = "handOfProtection", 
			[1044] = "handOfFreedom",
			[305395] = "handOfFreedom", -- PvP talent
			[642] = "divineShield", 
			[31884] = "avengingWrath", -- Protection/Retribution
			--[31842] = "avengingWrath", -- Holy
			[231895] = "crusade",
			--[224668] = "crusade", -- Crusade (Retribution Talent)
			[105809] = "holyAvenger",
			--[204150] = "lightAegis",
			[31850] = "ardentDefender",
			[205191] = "eyeForAnEye",
			[184662] = "vengeanceShield",
			[86659] = "ancientKings", -- Guardian of Ancient Kings
			[212641] = "ancientKings", -- Guardian of Ancient Kings (Glyph)
			[228049] = "forgottenQueens",
			--[182496] = "unbreakableWill",
			[216331] = "AvengingCrusader",
			[210294] = "divineFavor",
			[498] = "divineProtection", -- Divine Protection
			[204018] = "Spellwarding", -- Blessing of Spellwarding
			[215652] = "ShieldOfVirtue", -- Shield of Virtue
			
			-- Priest (Aura Applied)
			[33206] = "painSuppression",
			[47585] = "dispersion",
			[47788] = "guardianSpirit",
			[10060] = "powerInfusion",
			[197862] = "archangelHealing",
			[197871] = "archangelDamage",
			[200183] = "apotheosis",
			[213610] = "holyWard",
			[197268] = "rayOfHope",
			[193223] = "surrenderToMadness",
			[319952] = "surrenderToMadness",
			[47536] = "rapture",
			[109964] = "rapture",
			[194249] = "voidForm",
			[218413] = "voidForm",
			[15286] = "vampiricEmbrace",
			[213602] = "greaterFade",
			--[196762] = "innerFocus",

			-- Rogue (Aura Applied)
			[185313] = "shadowDance",
			[185422] = "shadowDance",
			[2983] = "sprint",
			[31224] = "cloakOfShadows", 
			[5277] = "evasion",
			[51690] = "killingSpree",
			[121471] = "shadowBlades",
			[199754] = "riposte",
			[31230] = "cheatDeath",
			[45182] = "cheatDeath",
			[343142] = "dreadblades",
			[1833] = "cheapShot",
			[1330] = "garrote",
			[6770] = "sap",
			[207736] = "shadowyDuel",
			[1966] = "Feint", -- Feint
			[199027] = "veilOfMidnight",
			
			-- Shaman (Aura Applied)
			--[204288] = "earthShield",
			[79206] = "spiritwalkersGrace",
			--[16166] = "elementalMastery",
			[114050] = "ascendance",
			[114051] = "ascendance",
			[114052] = "ascendance",
			[210918] = "etherealForm",
			[108271] = "astralShift",
			--[204293] = "spiritLink",
			[335903] = "doomWinds",

			
			-- Warlock (Aura Applied)
			[108416] = "darkPact",
			[104773] = "unendingResolve",
			--[196098] = "darkSoul", -- Soul Harvest (Legion's Version)
			[113860] = "darkSoul", -- Dark Soul: Misery (Affliction)
			[113858] = "darkSoul", -- Dark Soul: Instability (Destruction)
			[212295] = "netherWard",

			-- Warrior (Aura Applied)
			[184364] = "enragedRegeneration",
			[871] = "shieldWall", 
			[18499] = "berserkerRage",
			[46924] = "bladestorm", 
			[227847] = "bladestorm",
			[1719] = "battleCry", -- Recklessness (Fury)
			[262228] = "battleCry", -- Deadly Calm (Arms)
			[118038] = "dieByTheSword", 
			[107574] = "avatar",
			--[12292] = "bloodbath",
			[198817] = "sharpenBlade",
			[197690] = "defensestance",
			--[218826] = "trialByCombat",
			[23920] = "spellReflection",
			[330279] = "spellReflection", -- Overwatch PvP talent
			[236273] = "duel",
			[260708] = "sweepingStrikes", -- Sweeping Strikes
			[202147] = "secondWind", -- Second Wind
			[12975] = "lastStand", -- Last Stand
			[223658] = "safeguard", -- Safeguard
			[199086] = "warpath", -- Warpath
			[147833] = "Intervene",
			
			-- Tank Taunts (Aura Applied)
			--[206891] = "tankTauntsON", -- Tank Taunts On
		},
		auraRemoved = {					-- aura removed [spellid] = ".ogg file name",
			[642] = "bubbleDown",				--Divine Shield
			[47585] = "dispersionDown",			--Dispersion
			[1022] = "protectionDown",			--Blessing of Protection
			[31224] = "cloakDown", 				--Cloak of Shadows
			[871] = "shieldWallDown", 			--Shield Wall
			[33206] = "PSDown",					--Pain Suppression
			[5277] = "evasionDown", 			--Evasion
			[45438] = "iceBlockDown", 			--Ice Block
			[48792] = "iceboundFortitudeDown",	--Icebound Fortitude
			[19263] = "deterrenceDown", 		--Deterrence
			[186265] = "deterrenceDown",		--Aspect of the Turtle
			[48707] = "AntiMagicShellDown",		--Anti-Magic Shell
			[51690] = "killingSpreeDown",		--Killing Spree
			[118038] = "dieByTheSwordDown",		--Die by the Sword
			[108271] = "astralShiftDown",		--Astral Shift
			[201318] = "fortifyingBrewDown",	--Fortifying Brew (Windwalker PvP talent)
			[115203] = "fortifyingBrewDown",	--Fortifying Brew (Brewmaster)
			[243435] = "fortifyingBrewDown",	--Fortifying Brew (Mistweaver)
			[115176] = "zenMeditationDown",		--Zen Meditation (Brewmaster)
			[122470] = "karmaDown",				--Touch of Karma
			--[125174] = "karmaDown",				--Touch of Karma (Test)
			[219809] = "tombstoneDown",			--Tombstone
			--[206977] = "mirrorDown",			--Blood Mirror
			[207319] = "corpseDown",			--Corpse Shield
			[198589] = "blurDown",				--Blur
			[212800] = "blurDown",				--Blur (Other ID)
			[162264] = "metamorphDown",			--Metamorphosis
			[187827] = "metamorphDown",			--Metamorphosis (Vengeance)
			[188501] = "sightsDown",			--Spectral Sight
			[196555] = "netherwalkDown",		--Netherwalk
			--[207810] = "bondageDown",			--Nether Bond
			[198111] = "temporalDown",			--Temporal Shield
			[198144] = "iceFormDown",			--Ice Form
			--[216113] = "fistingDown",			--Way of the Crane
			[31850] = "defenderDown",			--Ardent Defender
			[205191] = "eyeDown",				--Eye for an Eye
			[184662] = "vengeanceShieldDown",	--Vengeance Shield
			[213610] = "wardDown",				--Holy Ward
			[197268] = "hopeDown",				--Ray of Hope
			--[193223] = "madnessDown",			--Surrender to Madness
			--[319952] = "madnessDown",			-- It's baaaack
			[210918] = "etherealDown",			--Ethereal Form
			[212295] = "netherWardDown",		--Nether Ward
			[86659] = "kingsDown",				--Guardian of Ancient Kings
			[228049] = "queensDown",			--Guardian of Forgotten Queens
			[116849] = "lifeCocoonDown",		--Life Coccoon
			[102560] = "incarnationDown",		--Incarnation (Boomkin)
			[102543] = "incarnationDown",		--Incarnation (Cat)
			[102558] = "incarnationDown",		--Incarnation (Bear)
			[33891] = "incarnationDown",		--Incarnation (Tree)
			[197690] = "damageStance",			--Defensive Stance (Falling off)
			--[193526] = "trueShotDown",			--Trueshot
			[288613] = "trueShotDown",
			[193530] = "trueShotDown",			--Aspect of the Wild
			[266779] = "trueShotDown",			--Coordinated Assault
			[199754] = "riposteDown",			--Riposte
			--[204293] = "spiritLinkDown",		--Spirit Link
			--[200851] = "rageOfSleeperDown",		--Rage of the Sleeper
			[343142] = "dreadbladesDown",		--Curse of the Dreadblades
			[194249] = "voidFormDown",			--Voidform
			[218413] = "voidFormDown",			--Voidform
			[15286] = "vampiricEmbraceDown",	--Vampiric Embrace
			--[203727] = "thornsDown",			--Thorns (Resto)
			[236696] = "thornsDown",			--Thorns (Feral)
			[305497] = "thornsDown",			--Thorns 8.2
			[209584] = "zenFocusTeaDown",		--Zen Focus Tea
			--[216890] = "SpellreflectionDown", 		-- Arms/Fury
			[23920] = "SpellreflectionDown",			-- Protection
			[330279] = "SpellReflectionDown",			-- Overwatch PvP Talent
			[152279] = "BreathOfSindragosaDown",--Breath of Sindragosa
			[34709] = "shadowSightDown",		-- Shadow Sight Crystal in Arenas
			[25771] = "forbearanceDown",		-- Forbearance
			[216331] = "AvengingCrusaderDown",	-- Avenging Crusader
			[215769] = "redeemerDown",			-- Spirit of the Redeemer (Priest pretend death talent)
			[236273] = "duelDown",				-- Duel (Warrior PvP Talent)
			[213602] = "greaterFadeDown",	-- Greater Fade
			--[196762] = "innerFocusDown",		-- Inner Focus 
			[260708] = "SweepingStrikesDown",-- Sweeping Strikes
			[223658] = "SafeguardDown",		-- Safeguard
			[204018] = "SpellwardingDown",	-- Blessing of Spellwarding
			[212704] = "BeastWithinDown",	-- The Beast Within; Beastial Wrath Fear/Horror Immunity Honor Talent
			[1966] = "FeintDown",			-- Feint
			[210294] = "DivineFavorDown", -- Divine Favor
			[104773] = "UnendingResolveDown", -- Unending Resolve
			[190319] = "combustionDown", -- Combustion
			[12042] = "APDown", -- Arcane Power
			[12472] = "icyVeinsDown", -- Icy Veins
			[29166] = "innervateDown", -- Innervate
			[6940] = "sacrificeDown", -- Blessing of Sacrifice
			[199448] = "sacrificeDown", -- Ultimate Sacrifice
			[199452] = "sacrificeDown", -- Placeholder for Ultimate Sacrifice
			[196098] = "darkSoulDown", -- Dark Soul
			[113860] = "darkSoulDown", -- Dark Soul
			[113858] = "darkSoulDown", -- Dark Soul
			[49039] = "lichborneDown", -- Lichborne
			[288977] = "transfusionDown", -- Transfusion
			[315443] = "abominationLimbDown", -- Abomination's Limb
			[323557] = "ravenousFrenzyDown", -- Ravenous Frenzy
			[108291] = "heartOfTheWildDown", -- Heart of the Wild
			[108292] = "heartOfTheWildDown", -- Heart of the Wild
			[108293] = "heartOfTheWildDown", -- Heart of the Wild
			[108294] = "heartOfTheWildDown", -- Heart of the Wild
			[110909] = "alterTimeDown", -- Alter Time
			[342246] = "alterTimeDown", -- Alter Time again I guess
			[108978] = "alterTimeDown", -- Alter Time again I guess again I guess
			[147833] = "interveneDown",
			[323095] = "UltimateFormDown", -- Necrolord
			[323524] = "UltimateFormDown",
			[345231] = "battlemasterDown",
			[330752] = "AscendantPhialDown", -- Kleia's nonsense
			[132158] = "swiftnessDown",
			[10060] = "infusionDown", -- Power Infusion
			[335903] = "doomwindsDown",
			[199027] = "veilOfMidnightDown",

			-- COVENANTS
			[310143] = "soulshapeDown", -- Nightfae Signature
			[331937] = "euphoriaDown",
			--[324867] = "fleshcraftDown", -- Necrolord Signature
		--TANK TAUNTS
			--[206891] = "tankTauntsOFF", 			-- Tank Taunts Down
			},
		castStart = {					-- cast start [spellid] = ".ogg file name",
		
		--GENERAL
			-- Big Heals
			[2060] = "bigHeal", -- Heal (Holy Priest)
			[82326] = "bigHeal", -- Holy Light (Paladin)
			[77472] = "bigHeal", -- Healing Wave (Shaman)
			--[5185] = "bigHeal", -- Healing Touch (Druid)
			--[116670] = "bigHeal", -- Vivify (Mistweaver)
			[227344] = "bigHeal", -- Surging Mist (Honor Talent)
			[194509] = "bigHeal", -- Power Word: Radiance (Discipline)
			--[204065] = "bigHeal", -- Shadow Covenant (Discipline)
			[152118] = "bigHeal", -- Clarity of Will (Discipline)
			--[186263] = "bigHeal", -- Shadow Mend (Discipline/Shadow Priest)
			--[116694] = "bigHeal", -- Effuse (Mistweaver)
			--[124682] = "bigHeal", -- Enveloping Mists (Mistweaver)
			
			-- Non-Combat Resurrections
			[2006] = "resurrection", -- Resurrection (Priest)
			[7328] = "resurrection", -- Redemption (Paladin)
			[2008] = "resurrection", -- Ancestral Spirit (Shaman)
			[115178] = "resurrection", -- Resusicate (Monk)
			[50769] = "resurrection",  -- Revive (Druid)
			-- Non-Combat Mass Resurrections
			[212040] = "resurrection", -- Revitalize (Druid Mass Rez)
			[212051] = "resurrection", -- Reawaken (Monk Mass Rez)
			[212036] = "resurrection", -- Mass Resurrection (Priest Mass Rez)
			[212056] = "resurrection", -- Absolution (Paladin Mass Rez)
			[212048] = "resurrection", -- Ancestral Vision (Shaman Mass Rez)

			-- Covenants
			[300728] = "doorOfShadows", -- Venthyr signature
			
			-- Death Knight (Spell Casting)
				--None! :D
				
			-- Demon Hunter (Spell Casting)
			[323639] = "theHunt",		-- Nightfae

			-- Druid (Spell Casting)
			[33786] = "cyclone",
			--[209753] = "cyclone", -- SCREAMS LOUDLY Balance Druid Cyclone
			[339] = "entanglingRoots",
			[235963] = "entanglingRoots", -- Feral Druid Honor Talent
			--[202767] = "littleMoon", -- New Moon
			--[202768] = "middleMoon", -- Half Moon
			--[202771] = "fullMoon", -- Full Moon
			-- Above Moons are Artifact Traits
			[274281] = "littleMoon",
			[274282] = "middleMoon",
			[274283] = "fullMoon",
			[2637] = "hibernate", -- Hibernate
			[329042] = "emeraldSlumber",
			
			-- Hunter (Spell Casting)
			[982] = "revivePet",
			[19434] = "aimedShot",
			--[19386] = "wyvernSting",
			[1513] = "scareBeast",
			
			-- Mage (Spell Casting)
			[118] = "polymorph", -- Sheep
			[28271] = "polymorph", -- Turtle
			[28272] = "polymorph", -- Pig
			[61305] = "polymorph", -- Black Cat
			[61721] = "polymorph", -- Rabbit
			[61025] = "polymorph", -- Serpent
			[61780] = "polymorph", -- Turkey
			[161372] = "polymorph", -- Peacock
			[161355] = "polymorph", -- Penguin
			[161353] = "polymorph", -- Polar Bear Cub
			[161354] = "polymorph", -- Monkey
			[126819] = "polymorph", -- Porcupine
			[277787] = "polymorph", -- Direhorn
			[277792] = "polymorph", -- Bumblebee
			[31687] = "waterElemental",
			[203286] = "greaterPyro",
			[199786] = "glacialSpike",
			[113724] = "ringOfFrost",
			[257537] = "ebonbolt",
			[314793] = "mirrorsOfTorment",
			[307443] = "radiantspark", -- Kyrian
			[353082] = "ringOfFire", -- and it burns burns burns
			--[353128] = "arcanosphere",
			[352278] = "iceWall",
			
			-- Monk (Spell Casting)
			[198898] = "craneSong",

			-- Paladin (Spell Casting)
			[20066] = "repentance",
			[10326] = "turnEvil",
			
			-- Priest (Spell Casting)
			[9484] = "shackleUndead", 
			[605] = "MindControl",
			[32375] = "massDispell",
			[265202] = "holyWordSalvation", -- Holy Word Salvation
			[289666] = "greaterHeal", -- >:(
			[325013] = "boonOfTheAscended",
			[323673] = "mindgames",

			-- Rogue (Spell Casting)
				--None! :D
				
			-- Shaman (Spell Casting)
			[51514] = "hex", -- Frog
			[210873] = "hex", -- Compy
			[211004] = "hex", -- Spider
			[211015] = "hex", -- Cockroach
			[211010] = "hex", -- Snake
			[269352] = "hex", -- Skeletal Hatchling
			[277778] = "hex", -- Zandalari Tendonripper
			[277784] = "hex", -- Wicker Mongrel
			[309328] = "hex", -- Living Honey
			[191634] = "stormkeeper",
			[320137] = "stormkeeper",
			[210714] = "Icefury", -- Icefury
			[320674] = "chainharvest", -- Venthyr
			[328923] = "faetransfusion", -- Nightfae
			[117014] = "ElementalBlast", -- oof
			
			-- Warlock (Spell Casting)
			[710] = "banish",
			[5782] = "fear",
			[691] = "summonDemon", -- Felhunter
			[712] = "summonDemon", -- Succubus
			[697] = "summonDemon", -- Voidwalker
			[688] = "summonDemon", -- Imp
			[30146] = "summonDemon", -- Felguard
			[157757] = "summonDemon", -- Doomguard
			[157898] = "summonDemon", -- Infernal
			[112866] = "summonDemon", -- Fel Imp (Glyph)
			[112867] = "summonDemon", -- Void Lord (Glyph)
			[112870] = "summonDemon", -- Wrathguard (Glyph)
			[112868] = "summonDemon", -- Shivarra (Glyph)
			[112869] = "summonDemon", -- Observer (Glyph)
			[152108] = "Cataclysm",
			[30283] = "shadowfury",
			[316099] = "unstableAffliction",
			[116858] = "chaosBolt",
			[6358] = "seduction",
			[115268] = "seduction",
			[265187] = "DemonicTyrant", -- Summon Demonic Tyrant
			[29893] = "CreateHealthstone",
			[183601] = "CreateHealthstone",
			[6201] = "CreateHealthstone",
			[325289] = "decimatingbolt", -- Necrolord
			[321792] = "impendingcatastrophe", -- Venthyr
			[325640] = "soulrot", -- Nightfae
			[264106] = "deathbolt",
			[6353] = "soulFire",
			[353753] = "bondsOfFel",

			-- Warrior (Spell Casting)
			[64382] = "shatteringthrow",
		},
		castSuccess = {					--cast success [spellid] = ".ogg file name",
			-- Cure (DPS Dispel)
			[213644] = "cure", 		-- Cleanse Toxins (Retribution/Protection Paladin)
			[51886] = "cure", 		-- Cleanse Spirit (Enhancement/Elemental Shaman)
			[2782] = "cure", 		-- Remove Corruption (Guardian/Feral/Balance Druid)
			[213634] = "cure", 		-- Purify Disease (Shadow Priest)
			[218164] = "cure", 		-- Detox (Brewmaster/Windwalker Monk)
			[475] = "cure",			-- Remove Curse (Mage)
			
			-- Dispel (Healer (Magic) Dispel)
			[4987] = "dispel", 		-- Cleanse (Holy Paladin)
			[77130] = "dispel", 	-- Purify Spirit (Restoration Shaman)
			[88423] = "dispel", 	-- Nature's Cure (Restoration Druid)
			[527] = "dispel", 		-- Purify (Holy/Discipline Priest)
			[115450] = "dispel", 	-- Detox (Mistweaver Monk)
			-- Warlocks, because they're special snowflakes.
			[89808] = "dispel", 	-- Singe Magic
			[137178] = "dispel",	-- Singe Magic (Green)
			[119905] = "dispel",	-- Singe Magic 2, Electric Boogaloo
			[212623] = "dispel",	-- Singe Magic (PvP Talent)
			[212620] = "dispel",	-- Singe Magic (PvP Talent, looks to be unused)
			
			-- CastSuccess (Major, cast-time CCs that went off)
			[113724] = "success", -- Ring of Frost


			-- Connected (Big Beefy cast-time abilities that successfully connect.)
			[203286] = "connected", -- Greater Pyro
			[116858] = "connected", -- Chaos Bolt
			[323673] = "connected", -- Mind Games
			[323639] = "connected", -- The Hunt
			
			-- Purges
			[528] = "purge",		-- Dispel Magic (Priest)
			[370] = "purge", 		-- Purge (Shaman)
			[19505] = "purge",		-- Devour Magic (Warlock :|)
			[278326] = "purge",		-- Consume Magic (Demon Hunter apparently????)
			[19801] = "purge",		-- Tranquilizing Shot (Hunter)
		
			--GENERAL
			[2825] = "bloodLust",
			[32182] = "bloodLust",
			[80353] = "bloodLust",
			[90355] = "bloodLust",
			[160452] = "bloodLust",
			[178207] = "bloodLust",
			[204361] = "bloodLust",
			[272678] = "bloodLust",	--Primal Rage (Hunter)
			[204362] = "bloodLust",
			[107079] = "quakingPalm",
			[20549] = "warStomp",
			[28730] = "arcaneTorrent",
			[25046] = "arcaneTorrent",
			[50613] = "arcaneTorrent",
			[69179] = "arcaneTorrent",
			[155145] = "arcaneTorrent",
			[129597] = "arcaneTorrent",
			[202719] = "arcaneTorrent",
			[80483] = "arcaneTorrent",
			[232633] = "arcaneTorrent",
			[58984] = "shadowmeld",
			[20594] = "stoneform",
			[7744] = "willOfTheForsaken",
			[59752] = "everyMan", 
			[287712] = "haymaker",
			[295707] = "regeneratin",

			[208683] = "trinket", -- Gladiator's Medallion Legion
			[195710] = "trinket", -- Honorable Medallion Legion
			[336126] = "trinket", -- Gladiator's Medallion Shadowlands
			[42292] = "trinket", -- Inherited Insignias (Heirloom PvP Trinkets)
			[23035] = "battleStandard",
			[23034] = "battleStandard",
			[213664] = "NimbleBrew", -- Nimble Brew consumable
			[6262] = "Healthstone", -- Healthstone consumable
			[265221] = "Fireblood", -- Fireblood (Dark Iron Dwarf)
			[256948] = "SpatialRift", -- Spatial Rift (Void Elf)
			[257040] = "SpatialRift2", -- Spatial Rift Teleport (Spatial Warp) (Void Elf)
			[255654] = "BullRush", -- Bull Rush (Highmountain Racial)
			[356567] = "maledict",

			-- Covenant (Cast Success)
			[324631] = "fleshcraft", -- Necrolord signature
			[323436] = "phialofserenity", -- Kyrian signature
			--[332423] = "driftglobe", -- Mikanikos Stun
			--[331612] = "driftglobe", -- ^
			--[323916] = "sulfuricEmission", -- Emeni Fear
			--[324263] = "sulfuricEmission", -- ^
			--[347684] = "sulfuricEmission", -- ^
			--[352366] = "nimbleSteps", -- Nadjia Root
			--[354051] = "nimbleSteps", -- ^
			--[354052] = "nimbleSteps", -- ^
			
			-- Death Knight (Cast Success)
			[47528] = "mindFreeze",
			[47476] = "strangulate",
			[47568] = "runeWeapon", -- Empowered Rune Weapon
			[207127] = "runeWeapon", -- Hungering Rune Weapon
			[207289] = "unholyAssault", -- Unholy Assault (Unholy)
			[49206] = "gargoyle", 			-- Summon Gargoyle
			[207349] = "gargoyle",			-- Dark Arbiter
			[77606] = "darkSimulacrum",
			[51052] = "antiMagicZone",
			[108194] = "asphyxiate",
			[108199] = "gorefiendGrasp",
			--[196770] = "remorselessWinter", -- Disabled since RW is rotational now, alert applied to succesful stuns.
			[152280] = "Defile",
			[207167] = "blindingSleet",
			[204160] = "chillStreak",
			[305392] = "chillStreak",
			[279302] = "sindragosaFury", -- Frostwyrm's Fury
			[343294] = "soulReaper",
			[275699] = "apocalypse",
			[212468] = "hook",
			[49576] = "deathGrip",
			[212552] = "wraithWalk",
			[49028] = "dancingRuneWeapon", -- Dancing Rune Weapon
			[48265] = "DeathsAdvance", -- Death's Advance
			[203173] = "DeathChain", -- Death Chain
			[48743] = "DeathPact", -- Death Pact
			[46584] = "RaiseDead", -- Raise Dead
			[46585] = "RaiseDead", -- Raise Dead
			[327574] = "sacrificialPact",
			[288853] = "raiseAbomination", -- Raise Abomination
			[324128] = "deathdue", -- Night Fae
			[312202] = "shackletheunworthy", -- Kyrian
			[63560] = "DarkTransformation",
			
			-- Demon Hunter (Cast Success)
			[183752] = "disrupt",
			[179057] = "chaosNova",
			[206649] = "leotherasEye",
			[205604] = "reverseMagic",
			[205629] = "trample",
			[205630] = "illidansGrasp",
			[202138] = "gripSigil",
			[207684] = "fearSigil",
			[202140] = "fearSigil",
			[202137] = "silenceSigil",
			[207682] = "silenceSigil",
			[211881] = "felEruption",
			[203704] = "manaBreak",
			[217832] = "imprison",
			[221527] = "imprison",		-- Honor Talent (on Players)
			[196718] = "darkness",
			[198013] = "eyeBeam",
			--[201467] = "furyOfTheIllidari",
			[235903] = "manaRift",
			[317009] = "sinfulBrand",	-- Venthyr
			[306830] = "elysianDecree", -- Kyrian
			[329554] = "fodderoftheflame", -- Necrolord

			-- Druid (Cast Success)
			[740] = "tranquility",
			[78675] = "solarBeam",
			--[102280] = "displacerBeast",
			[108238] = "renewal",
			[102359] = "massEntanglement",
			[99] = "disorientingRoar",
			[5211] = "mightyBash",
			[102417] = "wildCharge",
			[102383] = "wildCharge",
			[49376] = "wildCharge",
			[16979] = "wildCharge",
			[102416] = "wildCharge",
			[102401] = "wildCharge",
			[106839] = "skullBash",
			[203651] = "overgrowth",
			[201664] = "demoRoar",
			--[208253] = "essenceOfGhanir",
			[61391] = "typhoon",
			[132469] = "typhoon",
			[5215] = "prowl",
			[22570] = "maim",
			[236026] = "maim",
			[209749] = "faerieSwarm",
			--[210722] = "_PHashamanesFrenzy",
			[2908] = "soothe",
			[202246] = "Overrun", -- Overrun Guardian Druid Honor Talent
			[102793] = "UrsolsVortex", -- Ursol's Vortex
			[197721] = "Flourish", -- Flourish
			[325727] = "adaptiveSwarm", -- Necrolord
			[323764] = "convokeTheSpirits", -- Nightfae
			[327071] = "kindredfocus", -- Kyrian 1
			[327022] = "kindredempowerment", -- Kyrian 2
			[327037] = "kindredprotection", -- Kyrian 3
			[18562] = "swiftmend",
			[354654] = "groveProtection",
			[274837] = "FeralFrenzy",
			
			-- Hunter (Cast Success)
			[147362] = "counterShot",
			[109248] = "bindingShot",
			[109304] = "Exhilaration",
			[131894] = "murderOfCrows",
			[121818] = "stampede",
			[201430] = "stampede",
			[208652] = "direHawk",
			[205691] = "direBasilisk",
			[187707] = "muzzle",
			[187650] = "freezingTrap",
			--[191241] = "stickyBomb",
			[213691] = "scatterShot",
			--[201078] = "snakeHunter",
			[186387] = "burstingShot",
			--[120360] = "barrage", 
			--[203415] = "furyOfTheEagle",
			[1543] = "flare",
			[199483] = "camouflage",
			[236776] = "boomTrap", -- Hi-Explosive Trap
			[248518] = "Interlope", -- Interlope
			[325028] = "deathChakram", -- Necrolord
			[308491] = "resonatingArrow", -- Kyrian
			[257284] = "huntersMark",
			[19577] = "intimidation", -- Intimidation
			[324149] = "flayedshot", -- Venthyr
			[328231] = "wildspirits", -- Nightfae
			[212431] = "explosiveShot",
			[19574] = "bestialWrath",
			[356719] = "chimaeralSting",
			[356707] = "wildKingdom",
			[136] = "mendPet",
			
			-- Mage (Cast Success)
			[2139] = "counterspell", 
			[66] = "invisibility", 
			[12051] = "evocation",
			[110959] = "greaterInvisibility",
			--[153595] = "CometStorm",
			[153561] = "Meteor",
			[198158] = "massInvis",
			[30449] = "spellSteal",
			[205021] = "rayOfFrost",
			[235219] = "coldSnap",
			[235450] = "mageShield", -- Prismatic Barrier
			[235313] = "mageShield", -- Blazing Barrier
			[11426] = "mageShield", -- Ice Barrier
			[205025] = "presenceOfMind",
			[108839] = "iceFloes",
			[31661] = "DragonBreath", -- Dragon's Breath
			[55342] = "mirrorImage",
			[122] = "frostNova",
			[314791] = "shiftingpower", -- Nightfae
			
			-- Monk (Cast Success)
			[116841] = "tigersLust",
			[119381] = "legSweep",
			[123904] = "invokeXuen",
			[115078] = "paralysis",
			[116705] = "spearStrike",
			[101643] = "Transcendence",
			[119996] = "transfer",
			[137639] = "stormEarthFire",
			[115310] = "revival",
			[132578] = "invokeOx",
			--[198664] = "invokeCrane",
			[325197] = "fistweaving",
			[322118] = "invokeSerpent",
			--[214326] = "explodingKeg",
			[115080] = "touchOfDeath",
			[322109] = "touchOfDeath",
			[233759] = "grappleWeapon",
			[122470] = "touchOfKarma",
			--[209525] = "soothingMist",
			--[205320] = "strikeOfTheWindlord",
			[116844] = "ringOfPeace",
			[202370] = "MightyOxKick",
			[325216] = "bonedustbrew", -- Necrolord
			[327104] = "faelinestomp", -- Night Fae
			[326860] = "fallenorder", -- Venthyr
			[113656] = "FistsOfFury",
			
			-- Paladin (Cast Success)
			[96231] = "rebuke",
			[853] = "hammerofjustice", 	
			[31821] = "auraMastery", 
			[190784] = "pony",				-- Divine Steed (Was Holy/Ret, now all specs)
			[115750] = "blindingLight",
			--[210220] = "holyWrath",
			[210256] = "sanctuary",
			[633] = "layOnHands",
			[6940] = "sacrifice",				-- Blessing of Sacrifice
			[199448] = "UltimateSacrifice",		-- Blessing of Sacrifice (Ultimate Sacrifice PvP Talent)
			[199452] = "UltimateSacrifice",		-- Placeholder for Ultimate Sacrifice
			--[267798] = "ExecutionSentence",  -- Execution Sentence
			[343527] = "ExecutionSentence",
			[152262] = "Seraphim",
			[343721] = "finalReckoning",
			[316958] = "ashenhallow",
			[328282] = "blessingofspring",
			[328620] = "blessingofsummer",
			[328622] = "blessingofautumn",
			[328281] = "blessingofwinter",
			[304971] = "divinetoll", -- Kyrian
			[328204] = "vanquisherhammer", -- Necrolord
			
			-- Priest (Cast Success)
			[8122] = "fear4", 		-- Psychic Scream
			[34433] = "shadowFiend", 
			[64044] = "PsychicHorror",	-- Psychic Horror
			[15487] = "silence",
			[64843] = "divineHymn",
			[19236] = "desperatePrayer",
			[123040] = "mindbender",
			[204263] = "shiningForce",
			[2050] = "holySerenity",
			[88625] = "chastise",
			[205369] = "mindBomb",
			[211522] = "psyfiend",
			[108968] = "voidshift",
			--[208065] = "lightOfTuure",
			[62618] = "wordBarrier",
			[271466] = "wordBarrier", -- Luminous Barrier
			[263165] = "voidTorrent",
			[73325] = "leapOfFaith",
			[215769] = "redeemer",
			--[305498] = "Premonition", -- Premonition
			[32379] = "ShadowWordDeath", -- Shadow Word: Death
			[289657] = "holywordconcentration",
			[316262] = "thoughtsteal",
			[327661] = "faeGuardians", -- Night Fae
			[325013] = "boonoftheascended", -- Kyrian
			[324724] = "unholynova", -- Necrolord
			[109964] = "spiritShell",
			[64901] = "SymbolOfHope",

			-- Rogue (Cast Success)
			[2094] = "blind",
			[1766] = "kick",
			[1856] = "vanish",
			--[76577] = "smokeBomb",
			[212182] = "smokeBomb",
			[359053] = "smokeBomb",
			[79140] = "vendetta",
			[207777] = "dismantle",
			[200806] = "exsanguinate",
			[408] = "kidney",
			[199804] = "kidney",
			--[185767] = "cannonballBarrage",
			[193316] = "diceRoll",
			--[192759] = "kingsbane",
			[1776] = "gouge",
			[13750] = "adrenalineRush",
			[1784] = "stealth",
			[115191] = "stealth",
			[206328] = "Neurotoxin", -- Neurotoxin Honor Talent
			[328305] = "Sepsis",
			[185311] = "crimsonVial",
			[323547] = "echoingreprimand", -- Kyrian
			[323654] = "flagellation", -- Venthyr
			[328547] = "serratedbonespikes", -- Necrolord
			[5938] = "shiv",

			-- Shaman (Cast Success)
			[108281] = "ancestralGuidance",
			[118345] = "pulverize",
			[57994] = "windShear",
			[198067] = "fireElemental", -- Updated for Legion
			[198103] = "earthElemental", -- Updated for Legion
			[192249] = "stormElemental", -- Updated for Legion
			[204437] = "lightningLasso",
			[305483] = "lightningLasso", -- 8.2
			[51490] = "thunderstorm",
			[320125] = "echoingshock",
			[326059] = "primordialwave", -- Necrolord
			[356824] = "unleashWater", -- Unleash Shield (Water)
			[356738] = "unleashEarth", -- Unleash Shield (Earth)
			
			-- Shaman (Totems)
			[98008] = "spiritLinkTotem",
			[51485] = "earthgrab",
			[108280] = "healingTide",
			[108269] = "capacitor",			
			[152255] = "LiquidMagma",
			[192058] = "capacitor", -- Updated for Legion			
			[192077] = "windRushTotem",
			--[196932] = "hexTotem",
			[192222] = "LiquidMagma", -- Updated for Legion
			[204330] = "skyfuryTotem",
			[204331] = "counterstrikeTotem",
			[8512] = "windfuryTotem",
			[207399] = "reincarnationTotem",
			[198838] = "protectionTotem",
			[204336] = "grounding", -- Updated for Legion
			[8143] = "TremorTotem", -- Tremor Totem!
			[16191] = "manaTideTotem",
			[324386] = "vesperTotem",
			[355580] = "staticFieldTotem",
			
			-- Warlock (Cast Success)
			[6789] = "mortalCoil",
			[5484] = "terrorHowl",
			[19647] = "spellLock",
			[119910] = "spellLock",
			[171140] = "spellLock",
			[171138] = "spellLock",
			[212619] = "spellLock",
			[115781] = "spellLock",
			[132409] = "spellLock",
			[119910] = "spellLock",
			[251523] = "spellLock",
			[251922] = "spellLock",
			[288047] = "spellLock",
			[119898] = "spellLock",
			[119898] = "spellLock",
			[48018] = "DemonicCircle",
			[48020] = "demonicCircleTeleport",
			[111859] = "grimoireOfService",
			[111895] = "grimoireOfService",
			[111896] = "grimoireOfService",
			[111897] = "grimoireOfService",
			[111898] = "grimoireOfService",
			--[196277] = "implosion",
			--[115770] = "felLash",
			--[6360] = "felLash",
			[1122] = "summonInfernal",
			[201996] = "callObserver",
			[205180] = "darkglare",
			[199954] = "CurseOfFragility", -- Curse of Fragility
			[199892] = "CurseOfWeakness", -- Curse of Weakness
			[199890] = "CurseOfTongues", -- Curse of Tongues
			[80240] = "havoc",
			[312321] = "scouringTithe",
			[205179] = "phantomsingularity",
			[344566] = "RapidContagion",
			[234153] = "DrainLife",
			[328774] = "amplifyCurse",
			[353294] = "shadowRift",
			[353601] = "felObelisk",
			[89766] = "AxeToss",

			-- Warrior (Cast Success)
			[97462] = "commandingShout",
			[5246] = "fear3", -- Intimidating Shout
			[6552] = "pummel",
			--[107566] = "staggeringShout",	
			[46968] = "shockwave",
			--[118000] = "dragonRoar",
			[107570] = "stormBolt",
			[152277] = "Ravager", -- Arms
			[228920] = "Ravager", -- Protection
			[1160] = "demoShout",
			[213915] = "massSpellReflection",
			[236077] = "disarm",
			[236236] = "disarm",
			[236320] = "warBanner",
			[6544] = "heroicLeap",
			[206572] = "DragonCharge",
			[325886] = "ancientAftershock",
			[324143] = "conquerorbanner", -- Necrolord
			[307865] = "spearofbastion", -- Kyrian
			[64382] = "ShatteringThrowSuccess",
			[167105] = "colossusSmash",
			[262161] = "colossusSmash", -- Warbreaker Talent
		},
		friendlyInterrupt = {
			[19647] = "lockout", -- Spell Locks begin
			[119910] = "lockout",
			[171140] = "lockout",
			[171138] = "lockout",
			[212619] = "lockout",
			[115781] = "lockout",
			[132409] = "lockout",
			[119910] = "lockout",
			[251523] = "lockout",
			[251922] = "lockout",
			[288047] = "lockout",
			[119898] = "lockout", -- Spell Locks end
			[2139] = "lockout", -- Counterspell
			[1766] = "lockout", -- Kick
			[6552] = "lockout", -- Pummel
			[47528] = "lockout", -- Mind Freeze
			[96231] = "lockout", -- Rebuke
			[93985] = "lockout", -- Skull Bash
			[97547] = "lockout", -- Solar Beam
			[57994] = "lockout", -- Wind Shear
			[116705] = "lockout", -- Spear Hand Strike
			[147362] = "lockout", -- Counter Shot
			[183752] = "lockout", -- Consume Magic (Demon Hunter)
			[187707] = "lockout", -- Muzzle (Survival Hunter)
		},
		friendlyInterrupted = {			--friendly interrupt [spellid] = ".ogg file name",
			[19647] = "interrupted", -- Spell Lock
			[171140] = "interrupted", -- Spell Lock
			[171138] = "interrupted", -- Spell Lock
			[212619] = "interrupted", -- Spell Lock
			[119910] = "interrupted", -- Spell Lock
			[115781] = "interrupted", -- Spell Lock (Optical Blast)
			[119898] = "interrupted", -- Spell Lock YET AGAIN
			[2139] = "interrupted", -- Counterspell
			[1766] = "interrupted", -- Kick
			[6552] = "interrupted", -- Pummel
			[47528] = "interrupted", -- Mind Freeze
			[96231] = "interrupted", -- Rebuke
			[93985] = "interrupted", -- Skull Bash
			[97547] = "interrupted", -- Solar Beam
			[57994] = "interrupted", -- Wind Shear
			[116705] = "interrupted", -- Spear Hand Strike
			[147362] = "interrupted", -- Counter Shot
			[183752] = "interrupted", -- Consume Magic (Demon Hunter)
			[187707] = "interrupted", -- Muzzle (Survival Hunter)
		},
	}
end
