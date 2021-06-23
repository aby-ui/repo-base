local addonName, addon = ...

if WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE then return end

local BUFF_DEFENSIVE = "buffs_defensive"
local BUFF_OFFENSIVE = "buffs_offensive"
local BUFF_OTHER = "buffs_other"
local BUFF_SPEED_BOOST = "buffs_speed_boost"
local DEBUFF_OFFENSIVE = "debuffs_offensive"
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
    316099, -- Unstable Affliction
    342938, -- Unstable Affliction
    34914, -- Vampiric Touch
    323673, -- Mindgames
}

-- Make sure we always see these debuffs, but don't make them bigger
addon.PriorityDebuffs = {
    316099, -- Unstable Affliction
    342938, -- Unstable Affliction
    34914, -- Vampiric Touch
    209749, -- Faerie Swarm
    117405, -- Binding Shot
    122470, -- Touch of Karma
    208997, -- Counterstrike Totem
    343294, -- Soul Reaper (Unholy)
    323673, -- Mindgames
}

addon.Spells = {

    -- Interrupts

    [1766] = { type = INTERRUPT, duration = 5 }, -- Kick (Rogue)
    [2139] = { type = INTERRUPT, duration = 6 }, -- Counterspell (Mage)
    [6552] = { type = INTERRUPT, duration = 4 }, -- Pummel (Warrior)
    [19647] = { type = INTERRUPT, duration = 6 }, -- Spell Lock (Warlock)
        [132409] = { type = INTERRUPT, duration = 6, parent = 19647 }, -- Spell Lock (Warlock)
        [171138] = { type = INTERRUPT, duration = 6, parent = 19647 }, -- Shadow Lock (Warlock)
    [47528] = { type = INTERRUPT, duration = 3 }, -- Mind Freeze (Death Knight)
    [57994] = { type = INTERRUPT, duration = 3 }, -- Wind Shear (Shaman)
    [91802] = { type = INTERRUPT, duration = 2 }, -- Shambling Rush (Death Knight)
    [96231] = { type = INTERRUPT, duration = 4 }, -- Rebuke (Paladin)
    [106839] = { type = INTERRUPT, duration = 4 }, -- Skull Bash (Feral)
        [93985] = { type = INTERRUPT, duration = 4, parent = 106839 }, -- Skull Bash (Feral)
    [115781] = { type = INTERRUPT, duration = 6 }, -- Optical Blast (Warlock)
    [116705] = { type = INTERRUPT, duration = 4 }, -- Spear Hand Strike (Monk)
    [147362] = { type = INTERRUPT, duration = 3 }, -- Countershot (Hunter)
    [183752] = { type = INTERRUPT, duration = 3 }, -- Disrupt (Demon Hunter)
    [187707] = { type = INTERRUPT, duration = 3 }, -- Muzzle (Hunter)
    [212619] = { type = INTERRUPT, duration = 6 }, -- Call Felhunter (Warlock)
    [231665] = { type = INTERRUPT, duration = 3 }, -- Avengers Shield (Paladin)

    -- Death Knight

    [47476] = { type = CROWD_CONTROL }, -- Strangulate
    [48707] = { type = IMMUNITY_SPELL }, -- Anti-Magic Shell
    [48265] = { type = BUFF_SPEED_BOOST }, -- Death's Advance
    [48792] = { type = BUFF_DEFENSIVE }, -- Icebound Fortitude
    [49039] = { type = BUFF_OTHER }, -- Lichborne
    [81256] = { type = BUFF_DEFENSIVE }, -- Dancing Rune Weapon
    [51271] = { type = BUFF_OFFENSIVE }, -- Pillar of Frost
    [55233] = { type = BUFF_DEFENSIVE }, -- Vampiric Blood
    [77606] = { type = DEBUFF_OFFENSIVE }, -- Dark Simulacrum
    [91797] = { type = CROWD_CONTROL }, -- Monstrous Blow
    [91800] = { type = CROWD_CONTROL }, -- Gnaw
    [108194] = { type = CROWD_CONTROL }, -- Asphyxiate
        [221562] = { type = CROWD_CONTROL, parent = 108194 }, -- Asphyxiate (Blood)
    [152279] = { type = BUFF_OFFENSIVE }, -- Breath of Sindragosa
    [194679] = { type = BUFF_DEFENSIVE }, -- Rune Tap
    [194844] = { type = BUFF_DEFENSIVE }, -- Bonestorm
    [204080] = { type = ROOT }, -- Deathchill
        [233395] = { type = ROOT, parent = 204080 }, -- when applied by Remorseless Winter
        [204085] = { type = ROOT, parent = 204080 }, -- when applied by Chains of Ice
    [47568] = { type = BUFF_OFFENSIVE }, -- Empower Rune Weapon
    [207167] = { type = CROWD_CONTROL }, -- Blinding Sleet
    [287254] = { type = CROWD_CONTROL }, -- Dead of Winter
    [207289] = { type = BUFF_OFFENSIVE }, -- Unholy Assault
    [212552] = { type = BUFF_SPEED_BOOST }, -- Wraith Walk
    [219809] = { type = BUFF_DEFENSIVE }, -- Tombstone
    [223929] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Necrotic Wound
    [321995] = { type = BUFF_OFFENSIVE }, -- Hypothermic Presence
    [334693] = { type = CROWD_CONTROL }, -- Absolute Zero
    [91807] = { type = ROOT }, -- Shambling Rush
    [210141] = { type = CROWD_CONTROL}, -- Zombie Explosion (Reanimation Unholy PvP Talent)
    [288849] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Crypt Fever (Necromancer's Bargain Unholy PvP Talent)
    [3714] = { type = BUFF_OTHER }, -- Path of Frost
    [315443] = { type = BUFF_OFFENSIVE }, -- Abomination Limb

    -- Demon Hunter

    [179057] = { type = CROWD_CONTROL }, -- Chaos Nova
    [187827] = { type = BUFF_DEFENSIVE }, -- Metamorphosis - Vengeance
    [162264] = { type = BUFF_OFFENSIVE }, -- Metamorphosis - Havoc
    [188501] = { type = BUFF_OFFENSIVE }, -- Spectral Sight
    [204490] = { type = CROWD_CONTROL }, -- Sigil of Silence
    [205629] = { type = BUFF_DEFENSIVE }, -- Demonic Trample
    [213491] = { type = CROWD_CONTROL }, -- Demonic Trample (short stun on targets)
        [208645] = { type = CROWD_CONTROL, parent = 213491 }, -- Demonic Trample (short stun on targets)
    [205630] = { type = CROWD_CONTROL }, -- Illidan's Grasp - Grab
        [208618] = { type = CROWD_CONTROL, parent = 205630 }, -- Illidan's Grasp - Stun
    [206649] = { type = DEBUFF_OFFENSIVE }, -- Eye of Leotheras
    [206804] = { type = BUFF_OFFENSIVE }, -- Rain from Above (down)
        [206803] = { type = IMMUNITY, parent = 206804 }, -- Rain from Above (up)
    [207685] = { type = CROWD_CONTROL }, -- Sigil of Misery
    [209426] = { type = BUFF_DEFENSIVE }, -- Darkness
    [211881] = { type = CROWD_CONTROL }, -- Fel Eruption
    [212800] = { type = BUFF_DEFENSIVE }, -- Blur
    [196555] = { type = BUFF_DEFENSIVE }, -- Netherwalk
    [217832] = { type = CROWD_CONTROL }, -- Imprison
        [221527] = { type = CROWD_CONTROL, parent = 217832 }, -- Imprison (PvP Talent)
    [203704] = { type = DEBUFF_OFFENSIVE }, -- Mana Break

    -- Druid

    [99] = { type = CROWD_CONTROL }, -- Incapacitating Roar
    [339] = { type = ROOT }, -- Entangling Roots
        [170855] = { type = ROOT, parent = 339 }, -- Entangling Roots (Nature's Grasp)
    [740] = { type = BUFF_DEFENSIVE }, -- Tranquility
    [1850] = { type = BUFF_SPEED_BOOST }, -- Dash
        [252216] = { type = BUFF_SPEED_BOOST, parent = 1850 }, -- Tiger Dash
    [2637] = { type = CROWD_CONTROL }, -- Hibernate
    [5211] = { type = CROWD_CONTROL }, -- Mighty Bash
    [5217] = { type = BUFF_OFFENSIVE }, -- Tiger's Fury
    [22812] = { type = BUFF_DEFENSIVE }, -- Barkskin
    [22842] = { type = BUFF_DEFENSIVE }, -- Frenzied Regeneration
    [29166] = { type = BUFF_OFFENSIVE }, -- Innervate
    [33786] = { type = CROWD_CONTROL }, -- Cyclone
    [117679] = { type = BUFF_OFFENSIVE }, -- Incarnation (grants access to Tree of Life form)
    [45334] = { type = ROOT }, -- Immobilized (Wild Charge in Bear Form)
    [61336] = { type = BUFF_DEFENSIVE }, -- Survival Instincts
    [81261] = { type = CROWD_CONTROL }, -- Solar Beam
    [102342] = { type = BUFF_DEFENSIVE }, -- Ironbark
    [102359] = { type = ROOT }, -- Mass Entanglement
    [102543] = { type = BUFF_OFFENSIVE }, -- Incarnation: King of the Jungle
    [102558] = { type = BUFF_OFFENSIVE }, -- Incarnation: Guardian of Ursoc
    [102560] = { type = BUFF_OFFENSIVE }, -- Incarnation: Chosen of Elune
    [106951] = { type = BUFF_OFFENSIVE }, -- Berserk
    [132158] = { type = BUFF_OFFENSIVE }, -- Nature's Swiftness
    [155835] = { type = BUFF_DEFENSIVE }, -- Bristling Fur
    [192081] = { type = BUFF_DEFENSIVE }, -- Ironfur
    [163505] = { type = CROWD_CONTROL }, -- Rake
    [194223] = { type = BUFF_OFFENSIVE }, -- Celestial Alignment
    [202425] = { type = BUFF_OFFENSIVE }, -- Warrior of Elune
    [209749] = { type = CROWD_CONTROL }, -- Faerie Swarm (Slow/Disarm)
    [22570] = { type = CROWD_CONTROL }, -- Maim
        [203123] = { type = CROWD_CONTROL, parent = 22570 }, -- Maim
    [305497] = { type = BUFF_DEFENSIVE }, -- Thorns (PvP Talent)
    [50334] = { type = BUFF_DEFENSIVE }, -- Berserk (Guardian)
    [127797] = { type = CROWD_CONTROL, nounitFrames = true, nonameplates = true }, -- Ursol's Vortex
    [202244] = { type = CROWD_CONTROL }, -- Overrun (Guardian PvP Talent)
    [247563] = { type = BUFF_DEFENSIVE }, -- Nature's Grasp (Resto Entangling Bark PvP Talent)
    [106898] = { type = BUFF_SPEED_BOOST }, -- Stampeding Roar (from Human Form)
        [77764] = { type = BUFF_SPEED_BOOST, parent = 106898 }, -- from Cat Form
        [77761] = { type = BUFF_SPEED_BOOST, parent = 106898 }, -- from Bear Form
    [319454] = { type = BUFF_OFFENSIVE }, -- Heart of the Wild
        [108291] = { type = BUFF_OFFENSIVE, parent = 319454 }, -- with Balance Affinity
        [108292] = { type = BUFF_OFFENSIVE, parent = 319454 }, -- with Feral Affinity
        [108293] = { type = BUFF_OFFENSIVE, parent = 319454 }, -- with Guardian Affinity
        [108294] = { type = BUFF_OFFENSIVE, parent = 319454 }, -- with Resto Affinity
    [5215] = { type = BUFF_OTHER }, -- Prowl
    [323764] = { type = BUFF_OFFENSIVE }, -- Convoke the Spirits

    -- Hunter

    [136] = { type = BUFF_DEFENSIVE }, -- Mend Pet
    [1513] = { type = CROWD_CONTROL }, -- Scare Beast
    [3355] = { type = CROWD_CONTROL }, -- Freezing Trap
        [203337] = { type = CROWD_CONTROL, parent = 3355 }, -- Diamond Ice (Survival PvP Talent)
    [5384] = { type = BUFF_DEFENSIVE }, -- Feign Death
    [19574] = { type = BUFF_OFFENSIVE }, -- Bestial Wrath
        [186254] = { type = BUFF_OFFENSIVE, parent = 19574 }, -- Bestial Wrath buff on the pet
    [19577] = { type = CROWD_CONTROL }, -- Intimidation
        [24394] = { type = CROWD_CONTROL, parent = 19577 }, -- Intimidation
    [53480] = { type = BUFF_DEFENSIVE }, -- Roar of Sacrifice (Hunter Pet Skill)
    [54216] = { type = BUFF_DEFENSIVE }, -- Master's Call
    [117526] = { type = ROOT }, -- Binding Shot
        [117405] = { type = ROOT, parent = 117526 }, -- Binding Shot - aura when you're in the area
    [118922] = { type = BUFF_SPEED_BOOST }, -- Posthaste
    [131894] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- A Murder of Crows
    [162480] = { type = ROOT }, -- Steel Trap
    [186257] = { type = BUFF_SPEED_BOOST }, -- Aspect of the Cheetah
        [203233] = { type = BUFF_SPEED_BOOST, parent = 186257 }, -- Hunting Pack PvP Talent
    [186265] = { type = BUFF_DEFENSIVE }, -- Aspect of the Turtle
    [186289] = { type = BUFF_OFFENSIVE }, -- Aspect of the Eagle
    [238559] = { type = CROWD_CONTROL }, -- Bursting Shot
        [186387] = { type = CROWD_CONTROL, parent = 238559 }, -- Bursting Shot
    [193530] = { type = BUFF_OFFENSIVE }, -- Aspect of the Wild
    [199483] = { type = BUFF_DEFENSIVE }, -- Camouflage
    [202914] = { type = CROWD_CONTROL }, -- Spider Sting (Armed)
        [202933] = { type = CROWD_CONTROL, parent = 202914 }, -- Spider Sting (Silenced)
        [233022] = { type = CROWD_CONTROL, parent = 202914 }, -- Spider Sting (Silenced)
    [209997] = { type = BUFF_DEFENSIVE }, -- Play Dead
    [212638] = { type = ROOT }, -- Tracker's Net
    [213691] = { type = CROWD_CONTROL }, -- Scatter Shot
    [260402] = { type = BUFF_OFFENSIVE }, -- Double Tap
    [264667] = { type = BUFF_OFFENSIVE }, -- Primal Rage
    [266779] = { type = BUFF_OFFENSIVE }, -- Coordinated Assault
    [288613] = { type = BUFF_OFFENSIVE }, -- Trueshot
    [190925] = { type = ROOT }, -- Harpoon
    [202748] = { type = BUFF_DEFENSIVE }, -- Survival Tactics
    [248519] = { type = BUFF_DEFENSIVE }, -- Interlope (PvP Talent)

    -- Mage

    [66] = { type = BUFF_OFFENSIVE }, -- Invisibility
        [32612] = { type = BUFF_OFFENSIVE, parent = 66 }, -- Invisibility
        [110960] = { type = BUFF_OFFENSIVE, parent = 66 }, -- Greater Invisibility
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
    [33395] = { type = ROOT }, -- Freeze
    --[11426] = { type = BUFF_DEFENSIVE }, -- Ice Barrier (covers up combustion, doesn't provide much information)
    [12042] = { type = BUFF_OFFENSIVE }, -- Arcane Power
    [12051] = { type = BUFF_OFFENSIVE }, -- Evocation
    [12472] = { type = BUFF_OFFENSIVE }, -- Icy Veins
        [198144] = { type = BUFF_OFFENSIVE, parent = 12472 }, -- Ice Form
    [31661] = { type = CROWD_CONTROL }, -- Dragon's Breath
    [45438] = { type = IMMUNITY }, -- Ice Block
        [41425] = { type = BUFF_OTHER }, -- Hypothermia
    [80353] = { type = BUFF_OFFENSIVE }, -- Time Warp
    [342242] = { type = BUFF_OFFENSIVE }, -- Time Warp procced by Time Anomality (Arcane Talent)
    [82691] = { type = CROWD_CONTROL }, -- Ring of Frost
    [87023] = { type = BUFF_OTHER }, -- Cauterize
    [108839] = { type = BUFF_OFFENSIVE }, -- Ice Floes
    [342246] = { type = BUFF_DEFENSIVE }, -- Alter Time (Arcane)
        [110909] = { type = BUFF_DEFENSIVE, parent = 342246 }, -- Alter Time (Fire/Frost)
    [157997] = { type = ROOT }, -- Ice Nova
    [190319] = { type = BUFF_OFFENSIVE }, -- Combustion
    [198111] = { type = BUFF_DEFENSIVE }, -- Temporal Shield
    [198158] = { type = BUFF_OFFENSIVE }, -- Mass Invisibility
    [198064] = { type = BUFF_DEFENSIVE }, -- Prismatic Cloak
        [198065] = { type = BUFF_DEFENSIVE, parent = 198064 }, -- Prismatic Cloak
    [205025] = { type = BUFF_OFFENSIVE }, -- Presence of Mind
    [228600] = { type = ROOT }, -- Glacial Spike Root
    [317589] = { type = CROWD_CONTROL }, -- Tormenting Backlash (Venthyr Ability)
    [198121] = { type = ROOT }, -- Frostbite (PvP Talent)
    [130] = { type = BUFF_OTHER }, -- Slow Fall

    -- Monk

    [115078] = { type = CROWD_CONTROL }, -- Paralysis
    [115176] = { type = BUFF_DEFENSIVE }, -- Zen Meditation
    [120954] = { type = BUFF_DEFENSIVE }, -- Fortifying Brew (Brewmaster)
        [243435] = { type = BUFF_DEFENSIVE, parent = 120954 }, -- Fortifying Brew (Windwalker/Mistweaver)
    [116706] = { type = ROOT }, -- Disable
    [116841] = { type = BUFF_SPEED_BOOST }, -- Tiger's Lust
    [116849] = { type = BUFF_DEFENSIVE }, -- Life Cocoon
    [119381] = { type = CROWD_CONTROL }, -- Leg Sweep
    [122278] = { type = BUFF_DEFENSIVE }, -- Dampen Harm
    [122470] = { type = BUFF_DEFENSIVE }, -- Touch of Karma (Debuff)
        [125174] = { type = BUFF_DEFENSIVE, parent = 122470 }, -- Touch of Karma (Buff)
    [122783] = { type = BUFF_DEFENSIVE }, -- Diffuse Magic
    [137639] = { type = BUFF_OFFENSIVE }, -- Storm, Earth, and Fire
    [152173] = { type = BUFF_OFFENSIVE }, -- Serenity
    [198909] = { type = CROWD_CONTROL }, -- Song of Chi-Ji
    [202162] = { type = BUFF_DEFENSIVE }, -- Avert Harm
    [202274] = { type = CROWD_CONTROL }, -- Incendiary Brew
    [209584] = { type = BUFF_DEFENSIVE }, -- Zen Focus Tea
    [233759] = { type = CROWD_CONTROL }, -- Grapple Weapon
    [247483] = { type = BUFF_OFFENSIVE }, -- Tigereye Brew
    [310454] = { type = BUFF_OFFENSIVE }, -- Weapons of Order (Kyrian Ability)
    [202346] = { type = CROWD_CONTROL }, -- Double Barrel (Brew PvP Talent)
    [325153] = { type = CROWD_CONTROL }, -- Exploding Keg
    [202248] = { type = BUFF_DEFENSIVE }, -- Guided Meditation (Brew PvP Talent)
    [213664] = { type = BUFF_DEFENSIVE }, -- Nimble Brew (Brew PvP Talent)
    [132578] = { type = BUFF_DEFENSIVE }, -- Invoke Niuzao, the Black Ox

    -- Paladin

    [498] = { type = BUFF_DEFENSIVE }, -- Divine Protection
    [642] = { type = IMMUNITY }, -- Divine Shield
    [853] = { type = CROWD_CONTROL }, -- Hammer of Justice
    [1022] = { type = BUFF_DEFENSIVE }, -- Blessing of Protection
        [204018] = { type = BUFF_DEFENSIVE }, -- Blessing of Spellwarding
    [1044] = { type = BUFF_DEFENSIVE }, -- Blessing of Freedom
        [305395] = { type = BUFF_DEFENSIVE, parent = 1044 }, -- Blessing of Freedom with Unbound Freedom (PvP Talent)
    [6940] = { type = BUFF_DEFENSIVE }, -- Blessing of Sacrifice
        [199448] = { type = BUFF_DEFENSIVE, parent = 6940 }, -- Blessing of Sacrifice (Ultimate Sacrifice PvP Talent)
        [199450] = { type = BUFF_DEFENSIVE, parent = 6940 }, -- Blessing of Sacrifice (Ultimate Sacrifice Damage)
    [20066] = { type = CROWD_CONTROL }, -- Repentance
    [25771] = { type = BUFF_OTHER }, -- Forbearance
    [31821] = { type = BUFF_DEFENSIVE }, -- Aura Mastery
    [31850] = { type = BUFF_DEFENSIVE }, -- Ardent Defender
    [31884] = { type = BUFF_OFFENSIVE }, -- Avenging Wrath
        [216331] = { type = BUFF_OFFENSIVE, parent = 31884 }, -- Avenging Crusader (Holy Talent)
        [231895] = { type = BUFF_OFFENSIVE, parent = 31884 }, -- Crusade (Retribution Talent)
    [31935] = { type = CROWD_CONTROL }, -- Avenger's Shield
    [86659] = { type = BUFF_DEFENSIVE }, -- Guardian of Ancient Kings
        [212641] = { type = BUFF_DEFENSIVE, parent = 86659 }, -- Guardian of Ancient Kings (Glyphed)
        [228050] = { type = IMMUNITY }, -- Guardian of the Forgotten Queen
    [105809] = { type = BUFF_OFFENSIVE }, -- Holy Avenger
    [115750] = { type = CROWD_CONTROL }, -- Blinding Light
        [105421] = { type = CROWD_CONTROL, parent = 115750 }, -- Blinding Light
    [152262] = { type = BUFF_OFFENSIVE }, -- Seraphim
    [184662] = { type = BUFF_DEFENSIVE }, -- Shield of Vengeance
    [199545] = { type = BUFF_DEFENSIVE }, -- Steed of Glory (Protection PvP Talent)
    [205191] = { type = BUFF_DEFENSIVE }, -- Eye for an Eye
    [210256] = { type = BUFF_DEFENSIVE }, -- Blessing of Sanctuary
    [210294] = { type = BUFF_DEFENSIVE }, -- Divine Favor
    [215652] = { type = BUFF_OFFENSIVE }, -- Shield of Virtue (Buff)
        [217824] = { type = CROWD_CONTROL, parent = 215652 }, -- Shield of Virtue (Debuff)
    [221883] = { type = BUFF_SPEED_BOOST }, -- Divine Steed (Human?) (Each race has its own buff, pulled from wowhead - some might be incorrect)
        [221885] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (Tauren?)
        [221886] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (Blood Elf?)
        [221887] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (Lightforged Draenei)
        [254471] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (?)
        [254472] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (?)
        [254473] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (?)
        [254474] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (?)
        [276111] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (Dwarf?)
        [276112] = { type = BUFF_SPEED_BOOST, parent =  221883 }, -- Divine Steed (Dark Iron Dwarf?)
    [343721] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Final Reckoning
    [255941] = { type = CROWD_CONTROL }, -- Wake of Ashes stun
    [157128] = { type = BUFF_DEFENSIVE }, -- Saved by the Light

    -- Priest

    [337661] = { type = BUFF_DEFENSIVE }, -- Translucent Image (Fade defensive Conduit)
    [213602] = { type = BUFF_DEFENSIVE }, -- Greater Fade
    [605] = { type = CROWD_CONTROL, priority = true }, -- Mind Control
    [8122] = { type = CROWD_CONTROL }, -- Psychic Scream
    [9484] = { type = CROWD_CONTROL }, -- Shackle Undead
    [10060] = { type = BUFF_OFFENSIVE }, -- Power Infusion
    [15487] = { type = CROWD_CONTROL }, -- Silence
    [33206] = { type = BUFF_DEFENSIVE }, -- Pain Suppression
    [47536] = { type = BUFF_DEFENSIVE }, -- Rapture
        [109964] = { type = BUFF_DEFENSIVE, parent = 47536 }, -- Spirit Shell
    [47585] = { type = BUFF_DEFENSIVE }, -- Dispersion
    [47788] = { type = BUFF_DEFENSIVE }, -- Guardian Spirit
    [64044] = { type = CROWD_CONTROL }, -- Psychic Horror
    [64843] = { type = BUFF_DEFENSIVE }, -- Divine Hymn
    [81782] = { type = BUFF_DEFENSIVE }, -- Power Word: Barrier
    [87204] = { type = CROWD_CONTROL }, -- Sin and Punishment
    [194249] = { type = BUFF_OFFENSIVE }, -- Voidform
    [232707] = { type = BUFF_DEFENSIVE }, -- Ray of Hope
    [197862] = { type = BUFF_DEFENSIVE }, -- Archangel
    [197871] = { type = BUFF_OFFENSIVE }, -- Dark Archangel (on the priest)
    [197874] = { type = BUFF_OFFENSIVE }, -- Dark Archangel (on others)
    [200183] = { type = BUFF_DEFENSIVE }, -- Apotheosis
    [200196] = { type = CROWD_CONTROL }, -- Holy Word: Chastise
        [200200] = { type = CROWD_CONTROL, parent = 200196 }, -- Holy Word: Chastise (Stun)
    [205369] = { type = CROWD_CONTROL }, -- Mind Bomb
        [226943] = { type = CROWD_CONTROL, parent = 205369 }, -- Mind Bomb (Disorient)
    [213610] = { type = BUFF_DEFENSIVE }, -- Holy Ward
    [27827] = { type = BUFF_DEFENSIVE }, -- Spirit of Redemption
        [215769] = { type = BUFF_DEFENSIVE, parent = 27827 }, -- Spirit of the Redeemer PvP Talent
    [211336] = { type = BUFF_DEFENSIVE }, -- Archbishop Benedictus' Restitution (Holy Priest Revive Legendary)
    [289655] = { type = BUFF_DEFENSIVE }, -- Holy Word: Concentration
    [319952] = { type = BUFF_OFFENSIVE }, -- Surrender to Madness
    [322431] = { type = BUFF_OFFENSIVE, nounitFrames = true, noraidFrames = true, nonameplates = true }, -- Thoughtsteal (Buff)
    [322459] = { type = DEBUFF_OFFENSIVE }, -- Thoughtstolen (Shaman)
        [322464] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Mage)
        [322442] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Druid)
        [322462] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Priest - Holy)
        [322457] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Paladin)
        [322463] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Warlock)
        [322461] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Priest - Discipline)
        [322458] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Monk)
        [322460] = { type = DEBUFF_OFFENSIVE, parent = 322459 }, -- Thoughtstolen (Priest - Shadow)
    [323673] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Mindgames
    [329543] = { type = BUFF_DEFENSIVE }, -- Divine Ascension
        [328530] = { type = IMMUNITY, parent = 329543 }, -- Divine Ascension
    [335467] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Devouring Plague
    [453] = { type = DEBUFF_OFFENSIVE, noraidFrames = true }, -- Mind Soothe
    [15286] = { type = BUFF_DEFENSIVE }, -- Vampiric Embrace
    [19236] = { type = BUFF_DEFENSIVE }, -- Desperate Prayer
    [111759] = { type = BUFF_OTHER }, -- Levitate
    [325013] = { type = BUFF_OFFENSIVE }, -- Boon of the Ascended (Kyrian)
    [65081] = { type = BUFF_SPEED_BOOST }, -- Body and Soul
    [121557] = { type = BUFF_SPEED_BOOST }, -- Angelic Feather
    [199845] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Psyflay (Psyfiend) debuff

    -- Rogue

    [408] = { type = CROWD_CONTROL }, -- Kidney Shot
    [1330] = { type = CROWD_CONTROL }, -- Garrote - Silence
    [1776] = { type = CROWD_CONTROL }, -- Gouge
    [1833] = { type = CROWD_CONTROL }, -- Cheap Shot
    [1966] = { type = BUFF_DEFENSIVE }, -- Feint
    [2094] = { type = CROWD_CONTROL }, -- Blind
    [2983] = { type = BUFF_SPEED_BOOST }, -- Sprint
    [5277] = { type = BUFF_DEFENSIVE }, -- Evasion
    [6770] = { type = CROWD_CONTROL }, -- Sap
    [11327] = { type = BUFF_DEFENSIVE }, -- Vanish
    [13750] = { type = BUFF_OFFENSIVE }, -- Adrenaline Rush
    [31224] = { type = IMMUNITY_SPELL }, -- Cloak of Shadows
    [45182] = { type = BUFF_DEFENSIVE }, -- Cheating Death
    [51690] = { type = BUFF_OFFENSIVE }, -- Killing Spree
    [79140] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Vendetta
    [121471] = { type = BUFF_OFFENSIVE }, -- Shadow Blades
    [185422] = { type = BUFF_OFFENSIVE }, -- Shadow Dance
    [207736] = { type = BUFF_OFFENSIVE }, -- Shadowy Duel
    [207777] = { type = CROWD_CONTROL }, -- Dismantle
    [212183] = { type = CROWD_CONTROL }, -- Smoke Bomb
    [212150] = { type = CROWD_CONTROL }, -- Cheap Tricks (Outlaw PvP Talent, Blind effect)
    [197091] = { type = CROWD_CONTROL }, -- Neurotoxin (Assa PvP Talent)
    [199027] = { type = BUFF_DEFENSIVE }, -- Veil of Midnight (Subtlety PvP Talent)
    [197003] = { type = BUFF_DEFENSIVE }, -- Maneuverability (PvP Talent)
    [1784] = { type = BUFF_OTHER }, -- Stealth
        [115191] = { type = BUFF_OTHER, parent = 1784 }, -- Stealth (with Subterfuge talented)

    -- Shaman

    [2645] = { type = BUFF_SPEED_BOOST, nounitFrames = true, nonameplates = true }, -- Ghost Wolf
    [2825] = { type = BUFF_OFFENSIVE }, -- Bloodlust
        [32182] = { type = BUFF_OFFENSIVE, parent = 2825 }, -- Heroism
    [8178] = { type = IMMUNITY_SPELL }, -- Grounding Totem
    [51514] = { type = CROWD_CONTROL }, -- Hex
        [196932] = { type = CROWD_CONTROL, parent = 51514 }, -- Voodoo Totem
        [210873] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Compy)
        [211004] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Spider)
        [211010] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Snake)
        [211015] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Cockroach)
        [269352] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Skeletal Hatchling)
        [277778] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Zandalari Tendonripper)
        [277784] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Wicker Mongrel)
        [309328] = { type = CROWD_CONTROL, parent = 51514 }, -- Hex (Living Honey)
    [58875] = { type = BUFF_SPEED_BOOST }, -- Spirit Walk
    [79206] = { type = BUFF_OTHER }, -- Spiritwalker's Grace
    [108281] = { type = BUFF_DEFENSIVE }, -- Ancestral Guidance
    [64695] = { type = ROOT }, -- Earthgrab Totem
    [77505] = { type = CROWD_CONTROL }, -- Earthquake (Stun)
    [325174] = { type = BUFF_DEFENSIVE }, -- Spirit Link Totem
        [204293] = { type = BUFF_DEFENSIVE, parent = 325174 }, -- Spirit Link (PvP Talent)
    [108271] = { type = BUFF_DEFENSIVE }, -- Astral Shift
        [210918] = { type = BUFF_DEFENSIVE, parent = 108271 }, -- Ethereal Form
    [114049] = { type = BUFF_OFFENSIVE }, -- Ascendance
        [114050] = { type = BUFF_DEFENSIVE, parent = 114049 }, -- Ascendance (Elemental)
        [114051] = { type = BUFF_OFFENSIVE, parent = 114049 }, -- Ascendance (Enhancement)
        [114052] = { type = BUFF_DEFENSIVE, parent = 114049 }, -- Ascendance (Restoration)
    [118345] = { type = CROWD_CONTROL }, -- Pulverize
    [118905] = { type = CROWD_CONTROL }, -- Static Charge
    [191634] = { type = BUFF_OFFENSIVE }, -- Stormkeeper (Ele)
    [320137] = { type = BUFF_OFFENSIVE }, -- Stormkeeper (Enh)
    [197214] = { type = CROWD_CONTROL }, -- Sundering
    [201633] = { type = BUFF_DEFENSIVE }, -- Earthen Wall Totem
    [204366] = { type = BUFF_OFFENSIVE }, -- Thundercharge
    [204945] = { type = BUFF_OFFENSIVE }, -- Doom Winds
    [260878] = { type = BUFF_DEFENSIVE }, -- Spirit Wolf
    [290641] = { type = BUFF_DEFENSIVE }, -- Ancestral Gift
    [305485] = { type = CROWD_CONTROL }, -- Lightning Lasso (Player)
          [305484] = { type = CROWD_CONTROL, parent = 305485 }, -- Lightning Lasso (NPC)
    [320125] = { type = BUFF_OFFENSIVE }, -- Echoing Shock
    [546] = { type = BUFF_OTHER }, -- Water Walking
    [333957] = { type = BUFF_OFFENSIVE }, -- Feral Spirit
    [204361] = { type = BUFF_OFFENSIVE }, -- Bloodlust (Enhancement PvP Talent)
        [204362] = { type = BUFF_OFFENSIVE, parent = 204361 }, -- Heroism (Enhancement PvP Talent)
    [192082] = { type = BUFF_SPEED_BOOST }, -- Windrush Totem

    -- Warlock

    [710] = { type = CROWD_CONTROL }, -- Banish
    [5484] = { type = CROWD_CONTROL }, -- Howl of Terror
    [6358] = { type = CROWD_CONTROL }, -- Seduction
    [6789] = { type = CROWD_CONTROL }, -- Mortal Coil
    [20707] = { type = BUFF_OTHER }, -- Soulstone
    [22703] = { type = CROWD_CONTROL }, -- Infernal Awakening
    [30283] = { type = CROWD_CONTROL }, -- Shadowfury
    [89751] = { type = BUFF_OFFENSIVE }, -- Felstorm
    [89766] = { type = CROWD_CONTROL }, -- Axe Toss
    [104773] = { type = BUFF_DEFENSIVE }, -- Unending Resolve
    [108416] = { type = BUFF_DEFENSIVE }, -- Dark Pact
    [111400] = { type = BUFF_SPEED_BOOST }, -- Burning Rush
    [113860] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Misery (Affliction)
    [113858] = { type = BUFF_OFFENSIVE }, -- Dark Soul: Instability (Destruction)
    [118699] = { type = CROWD_CONTROL }, -- Fear
    [196364] = { type = CROWD_CONTROL }, -- Unstable Affliction (Silence)
    [212295] = { type = IMMUNITY_SPELL }, -- Nether Ward
    [1098] = { type = CROWD_CONTROL }, -- Subjugate Demon
    [234877] = { type = DEBUFF_OFFENSIVE }, -- Bane of Shadows (Affliction PvP Talent)
    [30213] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Legion Strike
    [200587] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Fel Fissure
    [212580] = { type = DEBUFF_OFFENSIVE }, -- Eye of the Observer
    [221705] = { type = BUFF_DEFENSIVE }, -- Casting Circle
    [333889] = { type = BUFF_DEFENSIVE }, -- Fel Domination
    [344566] = { type = BUFF_OFFENSIVE }, -- Rapid Contagion (Affliction PvP Talent)
    [267171] = { type = BUFF_OFFENSIVE }, -- Demonic Strength
    [267218] = { type = BUFF_OFFENSIVE }, -- Nether Portal

    -- Warrior

    [871] = { type = BUFF_DEFENSIVE }, -- Shield Wall
    [1719] = { type = BUFF_OFFENSIVE }, -- Recklessness
    [5246] = { type = CROWD_CONTROL }, -- Intimidating Shout
        [316593] = { type = CROWD_CONTROL, parent = 5246 }, -- Menace (Prot Talent), main target
        [316595] = { type = CROWD_CONTROL, parent = 5246 }, -- Menace (Prot Talent), other targets
    [12975] = { type = BUFF_DEFENSIVE }, -- Last Stand
    [18499] = { type = BUFF_OTHER }, -- Berserker Rage
    [23920] = { type = IMMUNITY_SPELL }, -- Spell Reflection
        [330279] = { type = IMMUNITY_SPELL, parent = 23920 }, -- Overwatch (Intervene Reflect)
    [132168] = { type = CROWD_CONTROL }, -- Shockwave
    [97463] = { type = BUFF_DEFENSIVE }, -- Rallying Cry
    [105771] = { type = ROOT }, -- Charge (Warrior)
    [107574] = { type = BUFF_OFFENSIVE }, -- Avatar
    [118038] = { type = BUFF_DEFENSIVE }, -- Die by the Sword
    [132169] = { type = CROWD_CONTROL }, -- Storm Bolt
    [147833] = { type = BUFF_DEFENSIVE }, -- Intervene
    [184364] = { type = BUFF_DEFENSIVE }, -- Enraged Regeneration
    [197690] = { type = BUFF_DEFENSIVE }, -- Defensive Stance
    [199261] = { type = BUFF_OFFENSIVE }, -- Death Wish
    [208086] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Colossus Smash
    [213871] = { type = BUFF_DEFENSIVE }, -- Bodyguard
    [227847] = { type = IMMUNITY }, -- Bladestorm (Arms)
        [46924] = { type = IMMUNITY, parent = 227847 }, -- Bladestorm (Fury)
    [236077] = { type = CROWD_CONTROL }, -- Disarm
        [236236] = { type = CROWD_CONTROL, parent = 236077 }, -- Disarm
    [236273] = { type = CROWD_CONTROL }, -- Duel
    [236321] = { type = BUFF_DEFENSIVE }, -- War Banner
    [262228] = { type = BUFF_OFFENSIVE }, -- Deadly Calm
    [199085] = { type = CROWD_CONTROL }, -- Warpath (Prot PvP Talent)
    [198817] = { type = BUFF_OFFENSIVE }, -- Sharpen Blade
        [198819] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Mortal Strike when applied with Sharpen Blade (50% healing reduc)

    -- Other

    [115804] = { type = DEBUFF_OFFENSIVE, nounitFrames = true, nonameplates = true }, -- Mortal Wounds

    [34709] = { type = BUFF_OTHER }, -- Shadow Sight
    [345231] = { type = BUFF_DEFENSIVE }, -- Gladiator's Emblem
    [314646] = { type = BUFF_OTHER }, -- Drink (40k mana vendor item)
        [348436] = { type = BUFF_OTHER, parent = 314646 }, -- (20k mana vendor item)
        [167152] = { type = BUFF_OTHER, parent = 314646 }, -- Refreshment (mage food)

    -- Racials

    [20549] = { type = CROWD_CONTROL }, -- War Stomp
    [107079] = { type = CROWD_CONTROL }, -- Quaking Palm
    [255654] = { type = CROWD_CONTROL }, -- Bull Rush
    [287712] = { type = CROWD_CONTROL }, -- Haymaker
    [256948] = { type = BUFF_OTHER }, -- Spatial Rift
    [65116] = { type = BUFF_DEFENSIVE }, -- Stoneform
    [265221] = { type = BUFF_DEFENSIVE }, -- Fireblood
    [58984] = { type = BUFF_DEFENSIVE }, -- Shadowmeld

    -- Shadowlands: Covenant/Soulbind

    [310143] = { type = BUFF_SPEED_BOOST }, -- Soulshape
    [320224] = { type = BUFF_DEFENSIVE }, -- Podtender (Night Fae - Dreamweaver Trait)
    [323524] = { type = IMMUNITY }, -- Ultimate Form (Necrolord - Marileth Trait)
    [324263] = { type = CROWD_CONTROL }, -- Sulfuric Emission (Necrolord - Emeni Trait)
    [327140] = { type = BUFF_OTHER }, -- Forgeborne Reveries (Necrolord - Bonesmith Heirmir Trait)
    [329776] = { type = BUFF_DEFENSIVE }, -- Ascendant Phial (Kyrian - Kleia Trait)
    [331866] = { type = CROWD_CONTROL }, -- Agent of Chaos (Venthyr - Nadjia Trait)
    [332505] = { type = BUFF_DEFENSIVE }, -- Soulsteel Clamps (Kyrian - Mikanikos Trait)
    [332423] = { type = CROWD_CONTROL }, -- Sparkling Driftglobe Core (Kyrian - Mikanikos Trait)

    -- Legacy (may be deprecated)

    [305252] = { type = CROWD_CONTROL }, -- Gladiator's Maledict
    [313148] = { type = CROWD_CONTROL }, -- Forbidden Obsidian Claw

    -- Special
    --[6788] = { type = "special", nounitFrames = true, noraidFrames = true }, -- Weakened Soul

}
