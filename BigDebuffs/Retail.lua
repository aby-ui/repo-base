local addonName, addon = ...

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then return end

local BUFF_DEFENSIVE = "buffs_defensive"
local BUFF_OFFENSIVE = "buffs_offensive"
local BUFF_OTHER = "buffs_other"
local INTERRUPT = "interrupts"
local CROWD_CONTROL = "cc"
local ROOT = "roots"
local IMMUNITY = "immunities"
local IMMUNITY_SPELL = "immunities_spells"

addon.Units = {
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

-- Show one of these when a big debuff is displayed
addon.WarningDebuffs = {
    212183, -- Smoke Bomb
    81261, -- Solar Beam
    233490, -- Unstable Affliction
    233496, -- Unstable Affliction
    233497, -- Unstable Affliction
    233498, -- Unstable Affliction
    233499, -- Unstable Affliction
    34914, -- Vampiric Touch
}

-- Make sure we always see these debuffs, but don't make them bigger
addon.PriorityDebuffs = {
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

addon.Spells = {

    -- Interrupts

    [1766] = { type = INTERRUPT, duration = 5 }, -- Kick (Rogue)
    [2139] = { type = INTERRUPT, duration = 6 }, -- Counterspell (Mage)
    [6552] = { type = INTERRUPT, duration = 4 }, -- Pummel (Warrior)
    [19647] = { type = INTERRUPT, duration = 6 }, -- Spell Lock (Warlock)
    [47528] = { type = INTERRUPT, duration = 3 }, -- Mind Freeze (Death Knight)
    [57994] = { type = INTERRUPT, duration = 3 }, -- Wind Shear (Shaman)
    [91802] = { type = INTERRUPT, duration = 2 }, -- Shambling Rush (Death Knight)
    [96231] = { type = INTERRUPT, duration = 4 }, -- Rebuke (Paladin)
    [106839] = { type = INTERRUPT, duration = 4 }, -- Skull Bash (Feral)
        [93985] = { type = INTERRUPT, duration = 4, parent = 106839}, -- Skull Bash (Feral)
    [115781] = { type = INTERRUPT, duration = 6 }, -- Optical Blast (Warlock)
    [116705] = { type = INTERRUPT, duration = 4 }, -- Spear Hand Strike (Monk)
    [132409] = { type = INTERRUPT, duration = 6 }, -- Spell Lock (Warlock)
    [147362] = { type = INTERRUPT, duration = 3 }, -- Countershot (Hunter)
    [171138] = { type = INTERRUPT, duration = 6 }, -- Shadow Lock (Warlock)
    [183752] = { type = INTERRUPT, duration = 3 }, -- Consume Magic (Demon Hunter)
    [187707] = { type = INTERRUPT, duration = 3 }, -- Muzzle (Hunter)
    [212619] = { type = INTERRUPT, duration = 6 }, -- Call Felhunter (Warlock)
    [231665] = { type = INTERRUPT, duration = 3 }, -- Avengers Shield (Paladin)

    -- Death Knight

    [47476] = { type = CROWD_CONTROL }, -- Strangulate
    [48707] = { type = IMMUNITY_SPELL }, -- Anti-Magic Shell
    [48265] = { type = BUFF_DEFENSIVE }, -- Death's Advance
    [48792] = { type = BUFF_DEFENSIVE }, -- Icebound Fortitude
    [81256] = { type = BUFF_DEFENSIVE }, -- Dancing Rune Weapon
    [51271] = { type = BUFF_OFFENSIVE }, -- Pillar of Frost
    [55233] = { type = BUFF_DEFENSIVE }, -- Vampiric Blood
    [77606] = { type = BUFF_OTHER }, -- Dark Simulacrum
    [91797] = { type = CROWD_CONTROL }, -- Monstrous Blow
    [91800] = { type = CROWD_CONTROL }, -- Gnaw
    [108194] = { type = CROWD_CONTROL }, -- Asphyxiate
        [221562] = { type = CROWD_CONTROL, parent = 108194 }, -- Asphyxiate (Blood)
    [152279] = { type = BUFF_OFFENSIVE }, -- Breath of Sindragosa
    [194679] = { type = BUFF_DEFENSIVE }, -- Rune Tap
    [194844] = { type = BUFF_DEFENSIVE }, -- Bonestorm
    [204080] = { type = ROOT }, -- Frostbite
    [206977] = { type = BUFF_DEFENSIVE }, -- Blood Mirror
    [207127] = { type = BUFF_OFFENSIVE }, -- Hungering Rune Weapon
    [207167] = { type = CROWD_CONTROL }, -- Blinding Sleet
    [207171] = { type = CROWD_CONTROL }, -- Winter is Coming
    [207256] = { type = BUFF_OFFENSIVE }, -- Obliteration
    [207289] = { type = BUFF_OFFENSIVE }, -- Unholy Frenzy
    [207319] = { type = BUFF_DEFENSIVE }, -- Corpse Shield
    [212332] = { type = CROWD_CONTROL }, -- Smash
        [212337] = { type = CROWD_CONTROL, parent = 212332 }, -- Powerful Smash
    [212552] = { type = BUFF_DEFENSIVE }, -- Wraith Walk
    [219809] = { type = BUFF_DEFENSIVE }, -- Tombstone
    [223929] = { type = BUFF_OTHER }, -- Necrotic Wound

    -- Demon Hunter

    [179057] = { type = CROWD_CONTROL }, -- Chaos Nova
    [187827] = { type = BUFF_DEFENSIVE }, -- Metamorphosis
    [188499] = { type = BUFF_DEFENSIVE }, -- Blade Dance
    [188501] = { type = BUFF_OFFENSIVE }, -- Spectral Sight
    [204490] = { type = CROWD_CONTROL }, -- Sigil of Silence
    [205629] = { type = BUFF_DEFENSIVE }, -- Demonic Trample
    [205630] = { type = CROWD_CONTROL }, -- Illidan's Grasp
    [206649] = { type = BUFF_OTHER }, -- Eye of Leotheras
    [207685] = { type = CROWD_CONTROL }, -- Sigil of Misery
    [207810] = { type = BUFF_DEFENSIVE }, -- Nether Bond
    [211048] = { type = BUFF_OFFENSIVE }, -- Chaos Blades
    [211881] = { type = CROWD_CONTROL }, -- Fel Eruption
    [212800] = { type = BUFF_DEFENSIVE }, -- Blur
        [196555] = { type = BUFF_DEFENSIVE }, -- Netherwalk
    [218256] = { type = BUFF_DEFENSIVE }, -- Empower Wards
    [221527] = { type = CROWD_CONTROL }, -- Imprison (Detainment Honor Talent)
        [217832] = { type = CROWD_CONTROL, parent = 221527 }, -- Imprison (Baseline Undispellable)
    [227225] = { type = BUFF_DEFENSIVE }, -- Soul Barrier

    -- Druid

    [99] = { type = CROWD_CONTROL }, -- Incapacitating Roar
    [339] = { type = ROOT }, -- Entangling Roots
    [740] = { type = BUFF_DEFENSIVE }, -- Tranquility
    [1850] = { type = BUFF_OTHER }, -- Dash
        [252216] = { type = BUFF_OTHER, parent = 1850 }, -- Tiger Dash
    [2637] = { type = CROWD_CONTROL }, -- Hibernate
    [5211] = { type = CROWD_CONTROL }, -- Mighty Bash
    [5217] = { type = BUFF_OFFENSIVE }, -- Tiger's Fury
    [22812] = { type = BUFF_DEFENSIVE }, -- Barkskin
    [22842] = { type = BUFF_DEFENSIVE }, -- Frenzied Regeneration
    [29166] = { type = BUFF_OFFENSIVE }, -- Innervate
    [33891] = { type = BUFF_OFFENSIVE }, -- Incarnation: Tree of Life
    [45334] = { type = ROOT }, -- Wild Charge
    [61336] = { type = BUFF_DEFENSIVE }, -- Survival Instincts
    [81261] = { type = CROWD_CONTROL }, -- Solar Beam
    [102342] = { type = BUFF_DEFENSIVE }, -- Ironbark
    [102359] = { type = ROOT }, -- Mass Entanglement
    [279642] = { type = BUFF_OFFENSIVE }, -- Lively Spirit
    [102543] = { type = BUFF_OFFENSIVE }, -- Incarnation: King of the Jungle
    [102558] = { type = BUFF_OFFENSIVE }, -- Incarnation: Guardian of Ursoc
    [102560] = { type = BUFF_OFFENSIVE }, -- Incarnation: Chosen of Elune
    [106951] = { type = BUFF_OFFENSIVE }, -- Berserk
    [155835] = { type = BUFF_DEFENSIVE }, -- Bristling Fur
    [192081] = { type = BUFF_DEFENSIVE }, -- Ironfur
    [163505] = { type = CROWD_CONTROL }, -- Rake
    [170855] = { type = ROOT }, -- Entangling Roots
    [194223] = { type = BUFF_OFFENSIVE }, -- Celestial Alignment
    [200851] = { type = BUFF_DEFENSIVE }, -- Rage of the Sleeper
    [202425] = { type = BUFF_OFFENSIVE }, -- Warrior of Elune
    [204399] = { type = CROWD_CONTROL }, -- Earthfury
    [204437] = { type = CROWD_CONTROL }, -- Lightning Lasso
        [305483] = { parent = 204437 },
        [305484] = { parent = 204437 },
        [305485] = { parent = 204437 },
    [209749] = { type = CROWD_CONTROL }, -- Faerie Swarm (Slow/Disarm)
    [209753] = { type = CROWD_CONTROL, priority = true }, -- Cyclone
        [33786] = { type = CROWD_CONTROL, parent = 209753 }, -- Cyclone
    [22570] = { type = CROWD_CONTROL }, -- Maim
        [203123] = { type = CROWD_CONTROL, parent = 22570 }, -- Maim
        [236025] = { type = CROWD_CONTROL, parent = 22570 }, -- Enraged Maim (Feral Honor Talent)
    [236696] = { type = BUFF_DEFENSIVE }, -- Thorns (PvP Talent)
        [305497] = { parent = 236696 },

    -- Hunter

    [136] = { type = BUFF_DEFENSIVE }, -- Mend Pet
    [3355] = { type = CROWD_CONTROL }, -- Freezing Trap
        [203340] = { type ="cc" }, -- Diamond Ice (Survival Honor Talent)
    [5384] = { type = BUFF_DEFENSIVE }, -- Feign Death
    [19386] = { type = CROWD_CONTROL }, -- Wyvern Sting
    [19574] = { type = BUFF_OFFENSIVE }, -- Bestial Wrath
    [19577] = { type = CROWD_CONTROL }, -- Intimidation
        [24394] = { type = CROWD_CONTROL, parent = 19577 }, -- Intimidation
    [53480] = { type = BUFF_DEFENSIVE }, -- Roar of Sacrifice (Hunter Pet Skill)
    [117526] = { type = ROOT }, -- Binding Shot
    [131894] = { type = BUFF_OFFENSIVE }, -- A Murder of Crows (Beast Mastery, Marksmanship)
        [206505] = { type = BUFF_OFFENSIVE, parent = 131894 }, -- A Murder of Crows (Survival)
    [186265] = { type = BUFF_DEFENSIVE }, -- Aspect of the Turtle
    [186289] = { type = BUFF_OFFENSIVE }, -- Aspect of the Eagle
    [238559] = { type = CROWD_CONTROL }, -- Bursting Shot
        [186387] = { type = CROWD_CONTROL, parent = 238559 }, -- Bursting Shot
    [193526] = { type = BUFF_OFFENSIVE }, -- Trueshot
    [193530] = { type = BUFF_OFFENSIVE }, -- Aspect of the Wild
    [199483] = { type = BUFF_DEFENSIVE }, -- Camouflage
    [202914] = { type = CROWD_CONTROL }, -- Spider Sting (Armed)
        [202933] = { type = CROWD_CONTROL, parent = 202914 }, -- Spider Sting (Silenced)
        [233022] = { type = CROWD_CONTROL, parent = 202914 }, -- Spider Sting (Silenced)
    [209790] = { type = CROWD_CONTROL }, -- Freezing Arrow
    [209997] = { type = BUFF_DEFENSIVE }, -- Play Dead
    [212638] = { type = ROOT }, -- Tracker's Net
    [213691] = { type = CROWD_CONTROL }, -- Scatter Shot
    [272682] = { type = BUFF_DEFENSIVE }, -- Master's Call

    -- Mage

    [66] = { type = BUFF_OFFENSIVE }, -- Invisibility
        [110959] = { type = BUFF_OFFENSIVE, parent = 66 }, -- Greater Invisibility
    [118] = { type = CROWD_CONTROL }, -- Polymorph
        [28271] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Turtle
        [28272] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Pig
        [61025] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Serpent
        [61305] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Black Cat
        [61721] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Rabbit
        [61780] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Turkey
        [126819] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Porcupine
        [161353] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Polar Bear Cub
        [161354] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Monkey
        [161355] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Penguin
        [161372] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Peacock
        [277787] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Direhorn
        [277792] = { type = CROWD_CONTROL, parent = 118 }, -- Polymorph Bumblebee
    [122] = { type = ROOT }, -- Frost Nova
        [33395] = { type = ROOT, parent = 122 }, -- Freeze
    [11426] = { type = BUFF_DEFENSIVE }, -- Ice Barrier
    [12042] = { type = BUFF_OFFENSIVE }, -- Arcane Power
    [12051] = { type = BUFF_OFFENSIVE }, -- Evocation
    [12472] = { type = BUFF_OFFENSIVE }, -- Icy Veins
        [198144] = { type = BUFF_OFFENSIVE, parent = 12472 }, -- Ice Form
    [31661] = { type = CROWD_CONTROL }, -- Dragon's Breath
    [45438] = { type = IMMUNITY }, -- Ice Block
        [41425] = { type = BUFF_OTHER }, -- Hypothermia
    [80353] = { type = BUFF_OFFENSIVE }, -- Time Warp
    [82691] = { type = CROWD_CONTROL }, -- Ring of Frost
    [108839] = { type = BUFF_OFFENSIVE }, -- Ice Floes
    [157997] = { type = ROOT }, -- Ice Nova
    [190319] = { type = BUFF_OFFENSIVE }, -- Combustion
    [198111] = { type = BUFF_DEFENSIVE }, -- Temporal Shield
    [198158] = { type = BUFF_OFFENSIVE }, -- Mass Invisibility
    [198064] = { type = BUFF_DEFENSIVE }, -- Prismatic Cloak
        [198065] = { type = BUFF_DEFENSIVE, parent = 198064 }, -- Prismatic Cloak
    [205025] = { type = BUFF_OFFENSIVE }, -- Presence of Mind
    [228600] = { type = ROOT }, -- Glacial Spike Root

    -- Monk

    [115078] = { type = CROWD_CONTROL }, -- Paralysis
    [115080] = { type = BUFF_OFFENSIVE }, -- Touch of Death
    [115203] = { type = BUFF_DEFENSIVE }, -- Fortifying Brew (Brewmaster)
        [201318] = { type = BUFF_DEFENSIVE, parent = 115203 }, -- Fortifying Brew (Windwalker Honor Talent)
        [243435] = { type = BUFF_DEFENSIVE, parent = 115203 }, -- Fortifying Brew (Mistweaver)
    [116706] = { type = ROOT }, -- Disable
    [116849] = { type = BUFF_DEFENSIVE }, -- Life Cocoon
    [119381] = { type = CROWD_CONTROL }, -- Leg Sweep
    [122278] = { type = BUFF_DEFENSIVE }, -- Dampen Harm
    [122470] = { type = BUFF_DEFENSIVE }, -- Touch of Karma
    [122783] = { type = BUFF_DEFENSIVE }, -- Diffuse Magic
    [137639] = { type = BUFF_DEFENSIVE }, -- Storm, Earth, and Fire
    [198909] = { type = CROWD_CONTROL }, -- Song of Chi-Ji
    [201325] = { type = BUFF_DEFENSIVE }, -- Zen Meditation
        [115176] = { type = BUFF_DEFENSIVE, parent = 201325 }, -- Zen Meditation
    [202162] = { type = BUFF_DEFENSIVE }, -- Guard
    [202274] = { type = CROWD_CONTROL }, -- Incendiary Brew
    [216113] = { type = BUFF_DEFENSIVE }, -- Way of the Crane
    [232055] = { type = CROWD_CONTROL }, -- Fists of Fury
        [120086] = { type = CROWD_CONTROL, parent = 232055 }, -- Fists of Fury
    [233759] = { type = CROWD_CONTROL }, -- Grapple Weapon

    -- Paladin

    [498] = { type = BUFF_DEFENSIVE }, -- Divine Protection
    [642] = { type = IMMUNITY }, -- Divine Shield
    [853] = { type = CROWD_CONTROL }, -- Hammer of Justice
    [1022] = { type = BUFF_DEFENSIVE }, -- Blessing of Protection
        [204018] = { type = BUFF_DEFENSIVE }, -- Blessing of Spellwarding
    [1044] = { type = BUFF_DEFENSIVE }, -- Blessing of Freedom
    [6940] = { type = BUFF_DEFENSIVE }, -- Blessing of Sacrifice
        [199448] = { type = BUFF_DEFENSIVE, parent = 6940 }, -- Blessing of Sacrifice (Ultimate Sacrifice Honor Talent)
    [20066] = { type = CROWD_CONTROL }, -- Repentance
    [31821] = { type = BUFF_DEFENSIVE }, -- Aura Mastery
    [31850] = { type = BUFF_DEFENSIVE }, -- Ardent Defender
    [31884] = { type = BUFF_OFFENSIVE }, -- Avenging Wrath (Protection/Retribution)
        [31842] = { type = BUFF_OFFENSIVE, parent = 31884 }, -- Avenging Wrath (Holy)
        [216331] = { type = BUFF_OFFENSIVE, parent = 31884 }, -- Avenging Crusader (Holy Honor Talent)
        [231895] = { type = BUFF_OFFENSIVE, parent = 31884 }, -- Crusade (Retribution Talent)
    [31935] = { type = CROWD_CONTROL }, -- Avenger's Shield
    [86659] = { type = BUFF_DEFENSIVE }, -- Guardian of Ancient Kings
        [212641] = { type = BUFF_DEFENSIVE }, -- Guardian of Ancient Kings (Glyphed)
        [228049] = { type = BUFF_DEFENSIVE }, -- Guardian of the Forgotten Queen
    [105809] = { type = BUFF_OFFENSIVE }, -- Holy Avenger
    [115750] = { type = CROWD_CONTROL }, -- Blinding Light
        [105421] = { type = CROWD_CONTROL, parent = 115750 }, -- Blinding Light
    [152262] = { type = BUFF_OFFENSIVE }, -- Seraphim
    [184662] = { type = BUFF_DEFENSIVE }, -- Shield of Vengeance
    [204150] = { type = BUFF_DEFENSIVE }, -- Aegis of Light
    [205191] = { type = BUFF_DEFENSIVE }, -- Eye for an Eye
    [210256] = { type = BUFF_DEFENSIVE }, -- Blessing of Sanctuary
    [210294] = { type = IMMUNITY_SPELL }, -- Divine Favor
    [215652] = { type = BUFF_OFFENSIVE }, -- Shield of Virtue


    -- Priest

    [586] = { type = BUFF_DEFENSIVE }, -- Fade
        [213602] = { type = BUFF_DEFENSIVE }, -- Greater Fade
    [605] = { type = CROWD_CONTROL, priority = true }, -- Mind Control
    [8122] = { type = CROWD_CONTROL }, -- Psychic Scream
    [9484] = { type = CROWD_CONTROL }, -- Shackle Undead
    [10060] = { type = BUFF_OFFENSIVE }, -- Power Infusion
    [15487] = { type = CROWD_CONTROL }, -- Silence
        [199683] = { type = CROWD_CONTROL, parent = 15487 }, -- Last Word
    [33206] = { type = BUFF_DEFENSIVE }, -- Pain Suppression
    [47536] = { type = BUFF_DEFENSIVE }, -- Rapture
    [47585] = { type = BUFF_DEFENSIVE }, -- Dispersion
    [47788] = { type = BUFF_DEFENSIVE }, -- Guardian Spirit
    [64044] = { type = CROWD_CONTROL }, -- Psychic Horror
    [64843] = { type = BUFF_DEFENSIVE }, -- Divine Hymn
    [81782] = { type = BUFF_DEFENSIVE }, -- Power Word: Barrier
        [271466] = { type = BUFF_DEFENSIVE, parent = 81782 }, -- Luminous Barrier (Disc Talent)
    [87204] = { type = CROWD_CONTROL }, -- Sin and Punishment
    [193223] = { type = BUFF_OFFENSIVE }, -- Surrender to Madness
    [194249] = { type = BUFF_OFFENSIVE }, -- Voidform
    [196762] = { type = BUFF_DEFENSIVE }, -- Inner Focus
    [197268] = { type = BUFF_DEFENSIVE }, -- Ray of Hope
    [197862] = { type = BUFF_DEFENSIVE }, -- Archangel
    [197871] = { type = BUFF_OFFENSIVE }, -- Dark Archangel
    [200183] = { type = BUFF_DEFENSIVE }, -- Apotheosis
    [200196] = { type = CROWD_CONTROL }, -- Holy Word: Chastise
        [200200] = { type = CROWD_CONTROL, parent = 200196 }, -- Holy Word: Chastise (Stun)
    [205369] = { type = CROWD_CONTROL }, -- Mind Bomb
        [226943] = { type = CROWD_CONTROL, parent = 205369 }, -- Mind Bomb (Disorient)
    [213610] = { type = BUFF_DEFENSIVE }, -- Holy Ward
    [215769] = { type = BUFF_DEFENSIVE }, -- Spirit of Redemption
    [221660] = { type = IMMUNITY_SPELL }, -- Holy Concentration

    -- Rogue

    [408] = { type = CROWD_CONTROL }, -- Kidney Shot
    [1330] = { type = CROWD_CONTROL }, -- Garrote - Silence
    [1776] = { type = CROWD_CONTROL }, -- Gouge
    [1833] = { type = CROWD_CONTROL }, -- Cheap Shot
    [1966] = { type = BUFF_DEFENSIVE }, -- Feint
    [2094] = { type = CROWD_CONTROL }, -- Blind
        [199743] = { type = CROWD_CONTROL, parent = 2094 }, -- Parley
    [5277] = { type = BUFF_DEFENSIVE }, -- Evasion
    [6770] = { type = CROWD_CONTROL }, -- Sap
    [13750] = { type = BUFF_OFFENSIVE }, -- Adrenaline Rush
    [31224] = { type = IMMUNITY_SPELL }, -- Cloak of Shadows
    [51690] = { type = BUFF_OFFENSIVE }, -- Killing Spree
    [79140] = { type = BUFF_OFFENSIVE }, -- Vendetta
    [121471] = { type = BUFF_OFFENSIVE }, -- Shadow Blades
    [199754] = { type = BUFF_DEFENSIVE }, -- Riposte
    [199804] = { type = CROWD_CONTROL }, -- Between the Eyes
    [207736] = { type = BUFF_OFFENSIVE }, -- Shadowy Duel
    [212183] = { type = CROWD_CONTROL }, -- Smoke Bomb

    -- Shaman

    [2825] = { type = BUFF_OFFENSIVE }, -- Bloodlust
        [32182] = { type = BUFF_OFFENSIVE, parent = 2825 }, -- Heroism
    [51514] = { type = CROWD_CONTROL }, -- Hex
        [196932] = { type = CROWD_CONTROL, parent = 51514 }, -- Voodoo Totem
        [210873] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Compy)
        [211004] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Spider)
        [211010] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Snake)
        [211015] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Cockroach)
        [269352] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Skeletal Hatchling)
        [277778] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Zandalari Tendonripper)
        [277784] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Wicker Mongrel)
    [79206] = { type = BUFF_DEFENSIVE }, -- Spiritwalker's Grace 60 * OTHER
    [108281] = { type = BUFF_DEFENSIVE }, -- Ancestral Guidance
    [16166] = { type = BUFF_OFFENSIVE }, -- Elemental Mastery
    [64695] = { type = ROOT }, -- Earthgrab Totem
    [77505] = { type = CROWD_CONTROL }, -- Earthquake (Stun)
    [98008] = { type = BUFF_DEFENSIVE }, -- Spirit Link Totem
    [108271] = { type = BUFF_DEFENSIVE }, -- Astral Shift
        [210918] = { type = BUFF_DEFENSIVE, parent = 108271 }, -- Ethereal Form
    [114050] = { type = BUFF_DEFENSIVE }, -- Ascendance (Elemental)
        [114051] = { type = BUFF_OFFENSIVE, parent = 114050 }, -- Ascendance (Enhancement)
        [114052] = { type = BUFF_DEFENSIVE, parent = 114050 }, -- Ascendance (Restoration)
    [118345] = { type = CROWD_CONTROL }, -- Pulverize
    [118905] = { type = CROWD_CONTROL }, -- Static Charge
    [197214] = { type = CROWD_CONTROL }, -- Sundering
    [204293] = { type = BUFF_DEFENSIVE }, -- Spirit Link
    [204366] = { type = BUFF_OFFENSIVE }, -- Thundercharge
    [204945] = { type = BUFF_OFFENSIVE }, -- Doom Winds
    [260878] = { type = BUFF_DEFENSIVE }, -- Spirit Wolf
    [8178] = { type = IMMUNITY_SPELL }, -- Grounding
        [255016] = { type = IMMUNITY_SPELL, parent = 8178 }, -- Grounding
        [204336] = { type = IMMUNITY_SPELL, parent = 8178 }, -- Grounding
        [34079] = { type = IMMUNITY_SPELL, parent = 8178 }, -- Grounding

    -- Warlock

    [710] = { type = CROWD_CONTROL }, -- Banish
    [5484] = { type = CROWD_CONTROL }, -- Howl of Terror
    [6358] = { type = CROWD_CONTROL }, -- Seduction
        [115268] = { type = CROWD_CONTROL, parent = 6358 }, -- Mesmerize
    [6789] = { type = CROWD_CONTROL }, -- Mortal Coil
    [20707] = { type = BUFF_DEFENSIVE }, -- Soulstone
    [22703] = { type = CROWD_CONTROL }, -- Infernal Awakening
    [30283] = { type = CROWD_CONTROL }, -- Shadowfury
    [89751] = { type = BUFF_OFFENSIVE }, -- Felstorm
        [115831] = { type = BUFF_OFFENSIVE, parent = 89751 }, -- Wrathstorm
    [89766] = { type = CROWD_CONTROL }, -- Axe Toss
    [104773] = { type = IMMUNITY_SPELL }, -- Unending Resolve
    [108416] = { type = BUFF_DEFENSIVE }, -- Dark Pact
    [113860] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Misery (Affliction)
    [113858] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Instability (Demonology)
    [118699] = { type = CROWD_CONTROL }, -- Fear
        [130616] = { type = CROWD_CONTROL, parent = 118699 }, -- Fear (Glyph of Fear)
    [171017] = { type = CROWD_CONTROL }, -- Meteor Strike
    [196098] = { type = BUFF_OFFENSIVE }, -- Soul Harvest
    [196364] = { type = CROWD_CONTROL }, -- Unstable Affliction (Silence)
    [212284] = { type = BUFF_OFFENSIVE }, -- Firestone
    [212295] = { type = IMMUNITY_SPELL }, -- Nether Ward
    [233582] = { type = ROOT }, -- Entrenched in Flame


    -- Warrior

    [871] = { type = BUFF_DEFENSIVE }, -- Shield Wall
    [1719] = { type = BUFF_OFFENSIVE }, -- Recklessness
    [5246] = { type = CROWD_CONTROL }, -- Intimidating Shout
    [12975] = { type = BUFF_DEFENSIVE }, -- Last Stand
    [18499] = { type = BUFF_OTHER }, -- Berserker Rage
    [23920] = { type = IMMUNITY_SPELL }, -- Spell Reflection
        [213915] = { type = IMMUNITY_SPELL, parent = 23920 }, -- Mass Spell Reflection
        [216890] = { type = IMMUNITY_SPELL, parent = 23920 }, -- Spell Reflection (Arms, Fury)
    [46968] = { type = CROWD_CONTROL }, -- Shockwave
    [97462] = { type = BUFF_DEFENSIVE }, -- Rallying Cry
    [105771] = { type = ROOT }, -- Charge (Warrior)
    [107574] = { type = BUFF_OFFENSIVE }, -- Avatar
    [118038] = { type = BUFF_DEFENSIVE }, -- Die by the Sword
    [132169] = { type = CROWD_CONTROL }, -- Storm Bolt
    [184364] = { type = BUFF_DEFENSIVE }, -- Enraged Regeneration
    [197690] = { type = BUFF_DEFENSIVE }, -- Defensive Stance
    [213871] = { type = BUFF_DEFENSIVE }, -- Bodyguard
    [227847] = { type = IMMUNITY }, -- Bladestorm (Arms)
        [46924] = { type = IMMUNITY, parent = 227847 }, -- Bladestorm (Fury)
        [152277] = { type = IMMUNITY, parent = 227847 }, -- Ravager
    [228920] = { type = BUFF_DEFENSIVE }, -- Ravager
    [236077] = { type = CROWD_CONTROL }, -- Disarm
        [236236] = { type = CROWD_CONTROL, parent = 236077 }, -- Disarm

    -- Other

    [20549] = { type = CROWD_CONTROL }, -- War Stomp
    [107079] = { type = CROWD_CONTROL }, -- Quaking Palm
    [129597] = { type = CROWD_CONTROL }, -- Arcane Torrent
        [25046] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [28730] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [50613] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [69179] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [80483] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [155145] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [202719] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [202719] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
        [232633] = { type = CROWD_CONTROL, parent = 129597 }, -- Arcane Torrent
    [192001] = { type = BUFF_OTHER }, -- Drink
        [167152] = { type = BUFF_OTHER, parent = 192001 }, -- Refreshment
    [256948] = { type = BUFF_OTHER }, -- Spatial Rift
    [255654] = { type = CROWD_CONTROL }, --Bull Rush
    [305252] = { type = CROWD_CONTROL }, -- Gladiator's Maledict
    [313148] = { type = CROWD_CONTROL }, -- Forbidden Obsidian Claw

    -- Legacy (may be deprecated)

    [178858] = { type = BUFF_DEFENSIVE }, -- Contender (Draenor Garrison Ability)

    -- Special
    --[6788] = { type = "special", nounitFrames = true, noraidFrames = true }, -- Weakened Soul

}
