local MAJOR, MINOR = "DRList-1.0", 46 -- Don't forget to change this in DRList-1.0.lua aswell!
local Lib = LibStub(MAJOR)
if Lib.spellListVersion and Lib.spellListVersion >= MINOR then
    return
end

Lib.spellListVersion = MINOR

if Lib.gameExpansion == "retail" then

    -- SpellID list for mainline aka retail WoW
    Lib.spellList = {
        [207167]  = "disorient",       -- Blinding Sleet
        [207685]  = "disorient",       -- Sigil of Misery
        [33786]   = "disorient",       -- Cyclone
        [1513]    = "disorient",       -- Scare Beast
        [31661]   = "disorient",       -- Dragon's Breath
        [198909]  = "disorient",       -- Song of Chi-ji
        [202274]  = "disorient",       -- Incendiary Brew
        [105421]  = "disorient",       -- Blinding Light
        [10326]   = "disorient",       -- Turn Evil
        [605]     = "disorient",       -- Mind Control
        [8122]    = "disorient",       -- Psychic Scream
        [226943]  = "disorient",       -- Mind Bomb
        [2094]    = "disorient",       -- Blind
        [118699]  = "disorient",       -- Fear
        [5484]    = "disorient",       -- Howl of Terror
        [261589]  = "disorient",       -- Seduction (Grimoire of Sacrifice)
        [6358]    = "disorient",       -- Seduction (Succubus)
        [5246]    = "disorient",       -- Intimidating Shout 1
        [316593]  = "disorient",       -- Intimidating Shout 2 (TODO: not sure which one is correct in 9.0.1)
        [316595]  = "disorient",       -- Intimidating Shout 3
        [331866]  = "disorient",       -- Agent of Chaos (Venthyr Covenant)

        [217832]  = "incapacitate",    -- Imprison
        [221527]  = "incapacitate",    -- Imprison (Honor talent)
        [2637]    = "incapacitate",    -- Hibernate
        [99]      = "incapacitate",    -- Incapacitating Roar
        [3355]    = "incapacitate",    -- Freezing Trap
        [203337]  = "incapacitate",    -- Freezing Trap (Honor talent)
        [213691]  = "incapacitate",    -- Scatter Shot
        [118]     = "incapacitate",    -- Polymorph
        [28271]   = "incapacitate",    -- Polymorph (Turtle)
        [28272]   = "incapacitate",    -- Polymorph (Pig)
        [61025]   = "incapacitate",    -- Polymorph (Snake)
        [61305]   = "incapacitate",    -- Polymorph (Black Cat)
        [61780]   = "incapacitate",    -- Polymorph (Turkey)
        [61721]   = "incapacitate",    -- Polymorph (Rabbit)
        [126819]  = "incapacitate",    -- Polymorph (Porcupine)
        [161353]  = "incapacitate",    -- Polymorph (Polar Bear Cub)
        [161354]  = "incapacitate",    -- Polymorph (Monkey)
        [161355]  = "incapacitate",    -- Polymorph (Penguin)
        [161372]  = "incapacitate",    -- Polymorph (Peacock)
        [277787]  = "incapacitate",    -- Polymorph (Baby Direhorn)
        [277792]  = "incapacitate",    -- Polymorph (Bumblebee)
        [321395]  = "incapacitate",    -- Polymorph (Mawrat)
        [82691]   = "incapacitate",    -- Ring of Frost
        [115078]  = "incapacitate",    -- Paralysis
        [357768]  = "incapacitate",    -- Paralysis 2 (Perpetual Paralysis?)
        [20066]   = "incapacitate",    -- Repentance
        [9484]    = "incapacitate",    -- Shackle Undead
        [200196]  = "incapacitate",    -- Holy Word: Chastise
        [1776]    = "incapacitate",    -- Gouge
        [6770]    = "incapacitate",    -- Sap
        [51514]   = "incapacitate",    -- Hex
        [196942]  = "incapacitate",    -- Hex (Voodoo Totem)
        [210873]  = "incapacitate",    -- Hex (Raptor)
        [211004]  = "incapacitate",    -- Hex (Spider)
        [211010]  = "incapacitate",    -- Hex (Snake)
        [211015]  = "incapacitate",    -- Hex (Cockroach)
        [269352]  = "incapacitate",    -- Hex (Skeletal Hatchling)
        [309328]  = "incapacitate",    -- Hex (Living Honey)
        [277778]  = "incapacitate",    -- Hex (Zandalari Tendonripper)
        [277784]  = "incapacitate",    -- Hex (Wicker Mongrel)
        [197214]  = "incapacitate",    -- Sundering
        [710]     = "incapacitate",    -- Banish
        [6789]    = "incapacitate",    -- Mortal Coil
        [107079]  = "incapacitate",    -- Quaking Palm (Pandaren racial)

        [47476]   = "silence",         -- Strangulate
        [204490]  = "silence",         -- Sigil of Silence
--      [78675]   = "silence",         -- Solar Beam (has no DR)
        [202933]  = "silence",         -- Spider Sting
        [356727]  = "silence",         -- Spider Venom
        [354831]  = "silence",         -- Wailing Arrow 1
        [355596]  = "silence",         -- Wailing Arrow 2
        [217824]  = "silence",         -- Shield of Virtue
        [15487]   = "silence",         -- Silence
        [1330]    = "silence",         -- Garrote
        [196364]  = "silence",         -- Unstable Affliction Silence Effect

        [210141]  = "stun",            -- Zombie Explosion
        [334693]  = "stun",            -- Absolute Zero (Breath of Sindragosa)
        [108194]  = "stun",            -- Asphyxiate (Unholy)
        [221562]  = "stun",            -- Asphyxiate (Blood)
        [91800]   = "stun",            -- Gnaw (Ghoul)
        [91797]   = "stun",            -- Monstrous Blow (Mutated Ghoul)
        [287254]  = "stun",            -- Dead of Winter
        [179057]  = "stun",            -- Chaos Nova
        [205630]  = "stun",            -- Illidan's Grasp (Primary effect)
        [208618]  = "stun",            -- Illidan's Grasp (Secondary effect)
        [211881]  = "stun",            -- Fel Eruption
        [200166]  = "stun",            -- Metamorphosis (PvE stun effect)
        [203123]  = "stun",            -- Maim
        [163505]  = "stun",            -- Rake (Prowl)
        [5211]    = "stun",            -- Mighty Bash
        [202244]  = "stun",            -- Overrun
        [325321]  = "stun",            -- Wild Hunt's Charge
        [357021]  = "stun",            -- Consecutive Concussion
        [24394]   = "stun",            -- Intimidation
        [119381]  = "stun",            -- Leg Sweep
        [202346]  = "stun",            -- Double Barrel
        [853]     = "stun",            -- Hammer of Justice
        [255941]  = "stun",            -- Wake of Ashes
        [64044]   = "stun",            -- Psychic Horror
        [200200]  = "stun",            -- Holy Word: Chastise Censure
        [1833]    = "stun",            -- Cheap Shot
        [408]     = "stun",            -- Kidney Shot
        [118905]  = "stun",            -- Static Charge (Capacitor Totem)
        [118345]  = "stun",            -- Pulverize (Primal Earth Elemental)
        [305485]  = "stun",            -- Lightning Lasso
        [89766]   = "stun",            -- Axe Toss
        [171017]  = "stun",            -- Meteor Strike (Infernal)
        [171018]  = "stun",            -- Meteor Strike (Abyssal)
        [30283]   = "stun",            -- Shadowfury
        [46968]   = "stun",            -- Shockwave
        [132168]  = "stun",            -- Shockwave (Protection)
        [145047]  = "stun",            -- Shockwave (Proving Grounds PvE)
        [132169]  = "stun",            -- Storm Bolt
        [199085]  = "stun",            -- Warpath
        [20549]   = "stun",            -- War Stomp (Tauren)
        [255723]  = "stun",            -- Bull Rush (Highmountain Tauren)
        [287712]  = "stun",            -- Haymaker (Kul Tiran)
        [332423]  = "stun",            -- Sparkling Driftglobe Core (Kyrian Covenant)

        [204085]  = "root",            -- Deathchill (Chains of Ice)
        [233395]  = "root",            -- Deathchill (Remorseless Winter)
        [339]     = "root",            -- Entangling Roots
        [235963]  = "root",            -- Entangling Roots (Earthen Grasp)
        [170855]  = "root",            -- Entangling Roots (Nature's Grasp)
        [102359]  = "root",            -- Mass Entanglement
        [117526]  = "root",            -- Binding Shot
        [162480]  = "root",            -- Steel Trap
        [273909]  = "root",            -- Steelclaw Trap
--      [190927]  = "root_harpoon",    -- Harpoon (TODO: confirm)
        [212638]  = "root",            -- Tracker's Net
        [201158]  = "root",            -- Super Sticky Tar
        [122]     = "root",            -- Frost Nova
        [33395]   = "root",            -- Freeze
        [198121]  = "root",            -- Frostbite
        [342375]  = "root",            -- Tormenting Backlash (Torghast PvE)
        [233582]  = "root",            -- Entrenched in Flame
        [116706]  = "root",            -- Disable
        [324382]  = "root",            -- Clash
        [64695]   = "root",            -- Earthgrab (Totem effect)
        [285515]  = "root",            -- Surge of Power
        [39965]   = "root",            -- Frost Grenade (Item)
        [75148]   = "root",            -- Embersilk Net (Item)
        [55536]   = "root",            -- Frostweave Net (Item)
        [268966]  = "root",            -- Hooked Deep Sea Net (Item)

        [209749]  = "disarm",          -- Faerie Swarm (Balance Honor Talent)
        [207777]  = "disarm",          -- Dismantle
        [233759]  = "disarm",          -- Grapple Weapon
        [236077]  = "disarm",          -- Disarm

        [56222]   = "taunt",           -- Dark Command
        [51399]   = "taunt",           -- Death Grip (Taunt Effect)
        [185245]  = "taunt",           -- Torment
        [6795]    = "taunt",           -- Growl (Druid)
        [2649]    = "taunt",           -- Growl (Hunter Pet) (TODO: confirm)
        [20736]   = "taunt",           -- Distracting Shot
        [116189]  = "taunt",           -- Provoke
        [118635]  = "taunt",           -- Provoke (Black Ox Statue)
        [196727]  = "taunt",           -- Provoke (Niuzao)
        [204079]  = "taunt",           -- Final Stand
        [62124]   = "taunt",           -- Hand of Reckoning
        [17735]   = "taunt",           -- Suffering (Voidwalker) (TODO: confirm)
        [355]     = "taunt",           -- Taunt

        -- Experimental
        [108199]  = "knockback",        -- Gorefiend's Grasp
        [202249]  = "knockback",        -- Overrun
        [61391]   = "knockback",        -- Typhoon
        [102793]  = "knockback",        -- Ursol's Vortex
        [186387]  = "knockback",        -- Bursting Shot
        [236777]  = "knockback",        -- Hi-Explosive Trap
        [157981]  = "knockback",        -- Blast Wave
        [237371]  = "knockback",        -- Ring of Peace
        [204263]  = "knockback",        -- Shining Force
        [51490]   = "knockback",        -- Thunderstorm
--      [287712]  = "knockback",        -- Haywire (Kul'Tiran Racial)
    }

    if GetSpellInfo(372245) and GetSpellInfo(372245) ~= "" then -- is Dragonflight Beta (quick temporary fix)
        Lib.spellList[391622]  = "incapacitate"    -- Polymorph (Duck)
        Lib.spellList[355689]  = "root"            -- Landslide
        Lib.spellList[372245]  = "stun"            -- Terror of the Skies
        Lib.spellList[360806]  = "disorient"       -- Sleep Walk
    end

elseif Lib.gameExpansion == "tbc" then

    -- SpellID list for The Burning Crusade
    -- spellID for every rank is used over spell name to avoid name collisions, and faster lookups
    Lib.spellList = {
        [2637]  = "incapacitate", -- Hibernate (Rank 1)
        [18657] = "incapacitate", -- Hibernate (Rank 2)
        [18658] = "incapacitate", -- Hibernate (Rank 3)
        [22570] = "incapacitate", -- Maim
        [3355]  = "incapacitate", -- Freezing Trap Effect (Rank 1)
        [14308] = "incapacitate", -- Freezing Trap Effect (Rank 2)
        [14309] = "incapacitate", -- Freezing Trap Effect (Rank 3)
        [19386] = "incapacitate", -- Wyvern Sting (Rank 1)
        [24132] = "incapacitate", -- Wyvern Sting (Rank 2)
        [24133] = "incapacitate", -- Wyvern Sting (Rank 3)
        [27068] = "incapacitate", -- Wyvern Sting (Rank 4)
        [118]   = "incapacitate", -- Polymorph (Rank 1)
        [12824] = "incapacitate", -- Polymorph (Rank 2)
        [12825] = "incapacitate", -- Polymorph (Rank 3)
        [12826] = "incapacitate", -- Polymorph (Rank 4)
        [28271] = "incapacitate", -- Polymorph: Turtle
        [28272] = "incapacitate", -- Polymorph: Pig
        [20066] = "incapacitate", -- Repentance
        [6770]  = "incapacitate", -- Sap (Rank 1)
        [2070]  = "incapacitate", -- Sap (Rank 2)
        [11297] = "incapacitate", -- Sap (Rank 3)
        [1776]  = "incapacitate", -- Gouge (Rank 1)
        [1777]  = "incapacitate", -- Gouge (Rank 2)
        [8629]  = "incapacitate", -- Gouge (Rank 3)
        [11285] = "incapacitate", -- Gouge (Rank 4)
        [11286] = "incapacitate", -- Gouge (Rank 5)
        [38764] = "incapacitate", -- Gouge (Rank 6)
        [710]   = "incapacitate", -- Banish (Rank 1)
        [18647] = "incapacitate", -- Banish (Rank 2)
        [13327] = "incapacitate", -- Reckless Charge (Rocket Helmet)
        [4064]  = "incapacitate", -- Rough Copper Bomb
        [4065]  = "incapacitate", -- Large Copper Bomb
        [4066]  = "incapacitate", -- Small Bronze Bomb
        [4067]  = "incapacitate", -- Big Bronze Bomb
        [4068]  = "incapacitate", -- Iron Grenade
        [12421] = "incapacitate", -- Mithril Frag Bomb
        [4069]  = "incapacitate", -- Big Iron Bomb
        [12562] = "incapacitate", -- The Big One
        [12543] = "incapacitate", -- Hi-Explosive Bomb
        [19769] = "incapacitate", -- Thorium Grenade
        [19784] = "incapacitate", -- Dark Iron Bomb
        [30216] = "incapacitate", -- Fel Iron Bomb
        [30461] = "incapacitate", -- The Bigger One
        [30217] = "incapacitate", -- Adamantite Grenade

        [33786] = "disorient", -- Cyclone
        [2094]  = "disorient", -- Blind

        [5211]  = "stun", -- Bash (Rank 1)
        [6798]  = "stun", -- Bash (Rank 2)
        [8983]  = "stun", -- Bash (Rank 3)
        [9005]  = "stun", -- Pounce (Rank 1)
        [9823]  = "stun", -- Pounce (Rank 2)
        [9827]  = "stun", -- Pounce (Rank 3)
        [27006] = "stun", -- Pounce (Rank 4)
        [24394] = "stun", -- Intimidation
        [853]   = "stun", -- Hammer of Justice (Rank 1)
        [5588]  = "stun", -- Hammer of Justice (Rank 2)
        [5589]  = "stun", -- Hammer of Justice (Rank 3)
        [10308] = "stun", -- Hammer of Justice (Rank 4)
        [1833]  = "stun", -- Cheap Shot
        [30283] = "stun", -- Shadowfury (Rank 1)
        [30413] = "stun", -- Shadowfury (Rank 2)
        [30414] = "stun", -- Shadowfury (Rank 3)
        [12809] = "stun", -- Concussion Blow
        [7922]  = "stun", -- Charge Stun
        [20253] = "stun", -- Intercept Stun (Rank 1)
        [20614] = "stun", -- Intercept Stun (Rank 2)
        [20615] = "stun", -- Intercept Stun (Rank 3)
        [25273] = "stun", -- Intercept Stun (Rank 4)
        [25274] = "stun", -- Intercept Stun (Rank 5)
        [20549] = "stun", -- War Stomp (Racial)
        [13237] = "stun", -- Goblin Mortar
        [835]   = "stun", -- Tidal Charm

        [16922]   = "random_stun",  -- Celestial Focus (Starfire Stun)
        [19410]   = "random_stun",  -- Improved Concussive Shot
        [12355]   = "random_stun",  -- Impact
        [20170]   = "random_stun",  -- Seal of Justice Stun
        [15269]   = "random_stun",  -- Blackout
        [18093]   = "random_stun",  -- Pyroclasm
        [39796]   = "random_stun",  -- Stoneclaw Stun
        [12798]   = "random_stun",  -- Revenge Stun
        [5530]    = "random_stun",  -- Mace Stun Effect (Mace Specialization)
        [15283]   = "random_stun",  -- Stunning Blow (Weapon Proc)
        [56]      = "random_stun",  -- Stun (Weapon Proc)
        [34510]   = "random_stun",  -- Stormherald/Deep Thunder (Weapon Proc)

        [10326] = "fear", -- Turn Evil (Might be PvE only until wotlk, adding just incase)
        [8122]  = "fear", -- Psychic Scream (Rank 1)
        [8124]  = "fear", -- Psychic Scream (Rank 2)
        [10888] = "fear", -- Psychic Scream (Rank 3)
        [10890] = "fear", -- Psychic Scream (Rank 4)
        [5782]  = "fear", -- Fear (Rank 1)
        [6213]  = "fear", -- Fear (Rank 2)
        [6215]  = "fear", -- Fear (Rank 3)
        [6358]  = "fear", -- Seduction (Succubus)
        [5484]  = "fear", -- Howl of Terror (Rank 1)
        [17928] = "fear", -- Howl of Terror (Rank 2)
        [1513]  = "fear", -- Scare Beast (Rank 1)
        [14326] = "fear", -- Scare Beast (Rank 2)
        [14327] = "fear", -- Scare Beast (Rank 3)
        [5246]  = "fear", -- Intimidating Shout
        [5134]  = "fear", -- Flash Bomb Fear (Item)

        [339]   = "root", -- Entangling Roots (Rank 1)
        [1062]  = "root", -- Entangling Roots (Rank 2)
        [5195]  = "root", -- Entangling Roots (Rank 3)
        [5196]  = "root", -- Entangling Roots (Rank 4)
        [9852]  = "root", -- Entangling Roots (Rank 5)
        [9853]  = "root", -- Entangling Roots (Rank 6)
        [26989] = "root", -- Entangling Roots (Rank 7)
        [19975] = "root", -- Nature's Grasp (Rank 1)
        [19974] = "root", -- Nature's Grasp (Rank 2)
        [19973] = "root", -- Nature's Grasp (Rank 3)
        [19972] = "root", -- Nature's Grasp (Rank 4)
        [19971] = "root", -- Nature's Grasp (Rank 5)
        [19970] = "root", -- Nature's Grasp (Rank 6)
        [27010] = "root", -- Nature's Grasp (Rank 7)
        [122]   = "root", -- Frost Nova (Rank 1)
        [865]   = "root", -- Frost Nova (Rank 2)
        [6131]  = "root", -- Frost Nova (Rank 3)
        [10230] = "root", -- Frost Nova (Rank 4)
        [27088] = "root", -- Frost Nova (Rank 5)
        [33395] = "root", -- Freeze (Water Elemental)
        [39965] = "root", -- Frost Grenade (Item)

        [605]   = "mind_control", -- Mind Control (Rank 1)
        [10911] = "mind_control", -- Mind Control (Rank 2)
        [10912] = "mind_control", -- Mind Control (Rank 3)
        [13181] = "mind_control", -- Gnomish Mind Control Cap

        [14251] = "disarm", -- Riposte
        [34097] = "disarm", -- Riposte 2 (TODO: Check which ID is the correct one)
        [676]   = "disarm", -- Disarm

        [12494] = "random_root",         -- Frostbite
        [23694] = "random_root",         -- Improved Hamstring
        [19229] = "random_root",         -- Improved Wing Clip
        [19185] = "random_root",         -- Entrapment

        [19503] = "scatter",        -- Scatter Shot
        [31661] = "scatter",        -- Dragon's Breath (Rank 1)
        [33041] = "scatter",        -- Dragon's Breath (Rank 2)
        [33042] = "scatter",        -- Dragon's Breath (Rank 3)
        [33043] = "scatter",        -- Dragon's Breath (Rank 4)

        -- Spells that DR with itself only
        [408]   = "kidney_shot",         -- Kidney Shot (Rank 1)
        [8643]  = "kidney_shot",         -- Kidney Shot (Rank 2)
        [43523] = "unstable_affliction", -- Unstable Affliction 1
        [31117] = "unstable_affliction", -- Unstable Affliction 2
        [6789]  = "death_coil",          -- Death Coil (Rank 1)
        [17925] = "death_coil",          -- Death Coil (Rank 2)
        [17926] = "death_coil",          -- Death Coil (Rank 3)
        [27223] = "death_coil",          -- Death Coil (Rank 4)
        [44041] = "chastise",            -- Chastise (Rank 1)
        [44043] = "chastise",            -- Chastise (Rank 2)
        [44044] = "chastise",            -- Chastise (Rank 3)
        [44045] = "chastise",            -- Chastise (Rank 4)
        [44046] = "chastise",            -- Chastise (Rank 5)
        [44047] = "chastise",            -- Chastise (Rank 6)
        [19306] = "counterattack",       -- Counterattack (Rank 1)
        [20909] = "counterattack",       -- Counterattack (Rank 2)
        [20910] = "counterattack",       -- Counterattack (Rank 3)
        [27067] = "counterattack",       -- Counterattack (Rank 4)
    }

elseif Lib.gameExpansion == "wotlk" then

    -- SpellID list for Wrath of the Lich King.
    -- spellID for every rank is used over spell name to avoid name collisions, and faster lookups
    Lib.spellList = {
        [49203] = "incapacitate", -- Hungering Cold
        [2637]  = "incapacitate", -- Hibernate (Rank 1)
        [18657] = "incapacitate", -- Hibernate (Rank 2)
        [18658] = "incapacitate", -- Hibernate (Rank 3)
        [60210] = "incapacitate", -- Freezing Arrow Effect (Rank 1)
        [3355]  = "incapacitate", -- Freezing Trap Effect (Rank 1)
        [14308] = "incapacitate", -- Freezing Trap Effect (Rank 2)
        [14309] = "incapacitate", -- Freezing Trap Effect (Rank 3)
        [19386] = "incapacitate", -- Wyvern Sting (Rank 1)
        [24132] = "incapacitate", -- Wyvern Sting (Rank 2)
        [24133] = "incapacitate", -- Wyvern Sting (Rank 3)
        [27068] = "incapacitate", -- Wyvern Sting (Rank 4)
        [49011] = "incapacitate", -- Wyvern Sting (Rank 5)
        [49012] = "incapacitate", -- Wyvern Sting (Rank 6)
        [118]   = "incapacitate", -- Polymorph (Rank 1)
        [12824] = "incapacitate", -- Polymorph (Rank 2)
        [12825] = "incapacitate", -- Polymorph (Rank 3)
        [12826] = "incapacitate", -- Polymorph (Rank 4)
        [28271] = "incapacitate", -- Polymorph: Turtle
        [28272] = "incapacitate", -- Polymorph: Pig
        [61721] = "incapacitate", -- Polymorph: Rabbit
        [61780] = "incapacitate", -- Polymorph: Turkey
        [61305] = "incapacitate", -- Polymorph: Black Cat
        [20066] = "incapacitate", -- Repentance
        [1776]  = "incapacitate", -- Gouge
        [6770]  = "incapacitate", -- Sap (Rank 1)
        [2070]  = "incapacitate", -- Sap (Rank 2)
        [11297] = "incapacitate", -- Sap (Rank 3)
        [51724] = "incapacitate", -- Sap (Rank 4)
        [710]   = "incapacitate", -- Banish (Rank 1)
        [18647] = "incapacitate", -- Banish (Rank 2)
        [9484]  = "incapacitate", -- Shackle Undead (Rank 1)
        [9485]  = "incapacitate", -- Shackle Undead (Rank 2)
        [10955] = "incapacitate", -- Shackle Undead (Rank 3)
        [51514] = "incapacitate", -- Hex
        [13327] = "incapacitate", -- Reckless Charge (Rocket Helmet)
        [4064]  = "incapacitate", -- Rough Copper Bomb
        [4065]  = "incapacitate", -- Large Copper Bomb
        [4066]  = "incapacitate", -- Small Bronze Bomb
        [4067]  = "incapacitate", -- Big Bronze Bomb
        [4068]  = "incapacitate", -- Iron Grenade
        [12421] = "incapacitate", -- Mithril Frag Bomb
        [4069]  = "incapacitate", -- Big Iron Bomb
        [12562] = "incapacitate", -- The Big One
        [12543] = "incapacitate", -- Hi-Explosive Bomb
        [19769] = "incapacitate", -- Thorium Grenade
        [19784] = "incapacitate", -- Dark Iron Bomb
        [30216] = "incapacitate", -- Fel Iron Bomb
        [30461] = "incapacitate", -- The Bigger One
        [30217] = "incapacitate", -- Adamantite Grenade
        [67769] = "incapacitate", -- Cobalt Frag Bomb
        [67890] = "incapacitate", -- Cobalt Frag Bomb (Frag Belt)
        [54466] = "incapacitate", -- Saronite Grenade

        [47481] = "stun", -- Gnaw (Ghoul Pet)
        [5211]  = "stun", -- Bash (Rank 1)
        [6798]  = "stun", -- Bash (Rank 2)
        [8983]  = "stun", -- Bash (Rank 3)
        [22570] = "stun", -- Maim (Rank 1)
        [49802] = "stun", -- Maim (Rank 2)
        [24394] = "stun", -- Intimidation
        [50519] = "stun", -- Sonic Blast (Pet Rank 1)
        [53564] = "stun", -- Sonic Blast (Pet Rank 2)
        [53565] = "stun", -- Sonic Blast (Pet Rank 3)
        [53566] = "stun", -- Sonic Blast (Pet Rank 4)
        [53567] = "stun", -- Sonic Blast (Pet Rank 5)
        [53568] = "stun", -- Sonic Blast (Pet Rank 6)
        [50518] = "stun", -- Ravage (Pet Rank 1)
        [53558] = "stun", -- Ravage (Pet Rank 2)
        [53559] = "stun", -- Ravage (Pet Rank 3)
        [53560] = "stun", -- Ravage (Pet Rank 4)
        [53561] = "stun", -- Ravage (Pet Rank 5)
        [53562] = "stun", -- Ravage (Pet Rank 6)
        [44572] = "stun", -- Deep Freeze
        [853]   = "stun", -- Hammer of Justice (Rank 1)
        [5588]  = "stun", -- Hammer of Justice (Rank 2)
        [5589]  = "stun", -- Hammer of Justice (Rank 3)
        [10308] = "stun", -- Hammer of Justice (Rank 4)
        [2812]  = "stun", -- Holy Wrath (Rank 1)
        [10318] = "stun", -- Holy Wrath (Rank 2)
        [27139] = "stun", -- Holy Wrath (Rank 3)
        [48816] = "stun", -- Holy Wrath (Rank 4)
        [48817] = "stun", -- Holy Wrath (Rank 5)
        [408]   = "stun", -- Kidney Shot (Rank 1)
        [8643]  = "stun", -- Kidney Shot (Rank 2)
        [58861] = "stun", -- Bash (Spirit Wolves)
        [30283] = "stun", -- Shadowfury (Rank 1)
        [30413] = "stun", -- Shadowfury (Rank 2)
        [30414] = "stun", -- Shadowfury (Rank 3)
        [47846] = "stun", -- Shadowfury (Rank 4)
        [47847] = "stun", -- Shadowfury (Rank 5)
        [12809] = "stun", -- Concussion Blow
        [60995] = "stun", -- Demon Charge
        [30153] = "stun", -- Intercept (Felguard Rank 1)
        [30195] = "stun", -- Intercept (Felguard Rank 2)
        [30197] = "stun", -- Intercept (Felguard Rank 3)
        [47995] = "stun", -- Intercept (Felguard Rank 4)
        [20253] = "stun", -- Intercept Stun (Rank 1)
        [20614] = "stun", -- Intercept Stun (Rank 2)
        [20615] = "stun", -- Intercept Stun (Rank 3)
        [25273] = "stun", -- Intercept Stun (Rank 4)
        [25274] = "stun", -- Intercept Stun (Rank 5)
        [46968] = "stun", -- Shockwave
        [20549] = "stun", -- War Stomp (Racial)

        [16922]   = "random_stun",  -- Celestial Focus (Starfire Stun)
        [28445]   = "random_stun",  -- Improved Concussive Shot
        [12355]   = "random_stun",  -- Impact
        [20170]   = "random_stun",  -- Seal of Justice Stun
        [39796]   = "random_stun",  -- Stoneclaw Stun
        [12798]   = "random_stun",  -- Revenge Stun
        [5530]    = "random_stun",  -- Mace Stun Effect (Mace Specialization)
        [15283]   = "random_stun",  -- Stunning Blow (Weapon Proc)
        [56]      = "random_stun",  -- Stun (Weapon Proc)
        [34510]   = "random_stun",  -- Stormherald/Deep Thunder (Weapon Proc)

        [1513]  = "fear", -- Scare Beast (Rank 1)
        [14326] = "fear", -- Scare Beast (Rank 2)
        [14327] = "fear", -- Scare Beast (Rank 3)
        [10326] = "fear", -- Turn Evil
        [8122]  = "fear", -- Psychic Scream (Rank 1)
        [8124]  = "fear", -- Psychic Scream (Rank 2)
        [10888] = "fear", -- Psychic Scream (Rank 3)
        [10890] = "fear", -- Psychic Scream (Rank 4)
        [2094]  = "fear", -- Blind
        [5782]  = "fear", -- Fear (Rank 1)
        [6213]  = "fear", -- Fear (Rank 2)
        [6215]  = "fear", -- Fear (Rank 3)
        [6358]  = "fear", -- Seduction (Succubus)
        [5484]  = "fear", -- Howl of Terror (Rank 1)
        [17928] = "fear", -- Howl of Terror (Rank 2)
        [5246]  = "fear", -- Intimidating Shout
        [5134]  = "fear", -- Flash Bomb Fear (Item)

        [339]   = "root", -- Entangling Roots (Rank 1)
        [1062]  = "root", -- Entangling Roots (Rank 2)
        [5195]  = "root", -- Entangling Roots (Rank 3)
        [5196]  = "root", -- Entangling Roots (Rank 4)
        [9852]  = "root", -- Entangling Roots (Rank 5)
        [9853]  = "root", -- Entangling Roots (Rank 6)
        [26989] = "root", -- Entangling Roots (Rank 7)
        [53308] = "root", -- Entangling Roots (Rank 8)
        [19975] = "root", -- Nature's Grasp (Rank 1)
        [19974] = "root", -- Nature's Grasp (Rank 2)
        [19973] = "root", -- Nature's Grasp (Rank 3)
        [19972] = "root", -- Nature's Grasp (Rank 4)
        [19971] = "root", -- Nature's Grasp (Rank 5)
        [19970] = "root", -- Nature's Grasp (Rank 6)
        [27010] = "root", -- Nature's Grasp (Rank 7)
        [53312] = "root", -- Nature's Grasp (Rank 8)
        [50245] = "root", -- Pin (Rank 1)
        [53544] = "root", -- Pin (Rank 2)
        [53545] = "root", -- Pin (Rank 3)
        [53546] = "root", -- Pin (Rank 4)
        [53547] = "root", -- Pin (Rank 5)
        [53548] = "root", -- Pin (Rank 6)
        [33395] = "root", -- Freeze (Water Elemental)
        [122]   = "root", -- Frost Nova (Rank 1)
        [865]   = "root", -- Frost Nova (Rank 2)
        [6131]  = "root", -- Frost Nova (Rank 3)
        [10230] = "root", -- Frost Nova (Rank 4)
        [27088] = "root", -- Frost Nova (Rank 5)
        [42917] = "root", -- Frost Nova (Rank 6)
        [39965] = "root", -- Frost Grenade (Item)
        [63685] = "root", -- Freeze (Frost Shock)
        [55536] = "root", -- Frostweave Net (Item)

        [12494] = "random_root",         -- Frostbite
        [55080] = "random_root",         -- Shattered Barrier
        [58373] = "random_root",         -- Glyph of Hamstring
        [23694] = "random_root",         -- Improved Hamstring
        [47168] = "random_root",         -- Improved Wing Clip
        [19185] = "random_root",         -- Entrapment

        [53359] = "disarm", -- Chimera Shot (Scorpid)
        [50541] = "disarm", -- Snatch (Rank 1)
        [53537] = "disarm", -- Snatch (Rank 2)
        [53538] = "disarm", -- Snatch (Rank 3)
        [53540] = "disarm", -- Snatch (Rank 4)
        [53542] = "disarm", -- Snatch (Rank 5)
        [53543] = "disarm", -- Snatch (Rank 6)
        [64346] = "disarm", -- Fiery Payback
        [64058] = "disarm", -- Psychic Horror Disarm Effect
        [51722] = "disarm", -- Dismantle
        [676]   = "disarm", -- Disarm

        [47476] = "silence", -- Strangulate
        [34490] = "silence", -- Silencing Shot
        [35334] = "silence", -- Nether Shock 1 -- TODO: verify
        [44957] = "silence", -- Nether Shock 2 -- TODO: verify
        [18469] = "silence", -- Silenced - Improved Counterspell (Rank 1)
        [55021] = "silence", -- Silenced - Improved Counterspell (Rank 2)
        [63529] = "silence", -- Silenced - Shield of the Templar
        [15487] = "silence", -- Silence
        [1330]  = "silence", -- Garrote - Silence
        [18425] = "silence", -- Silenced - Improved Kick
        [24259] = "silence", -- Spell Lock
        [43523] = "silence", -- Unstable Affliction 1
        [31117] = "silence", -- Unstable Affliction 2
        [18498] = "silence", -- Silenced - Gag Order (Shield Slam)
        [74347] = "silence", -- Silenced - Gag Order (Heroic Throw?)
        [50613] = "silence", -- Arcane Torrent (Racial, Runic Power)
        [28730] = "silence", -- Arcane Torrent (Racial, Mana)
        [25046] = "silence", -- Arcane Torrent (Racial, Energy)

        [64044] = "horror", -- Psychic Horror
        [6789]  = "horror", -- Death Coil (Rank 1)
        [17925] = "horror", -- Death Coil (Rank 2)
        [17926] = "horror", -- Death Coil (Rank 3)
        [27223] = "horror", -- Death Coil (Rank 4)
        [47859] = "horror", -- Death Coil (Rank 5)
        [47860] = "horror", -- Death Coil (Rank 6)

        [1833]  = "opener_stun", -- Cheap Shot
        [9005]  = "opener_stun", -- Pounce (Rank 1)
        [9823]  = "opener_stun", -- Pounce (Rank 2)
        [9827]  = "opener_stun", -- Pounce (Rank 3)
        [27006] = "opener_stun", -- Pounce (Rank 4)
        [49803] = "opener_stun", -- Pounce (Rank 5)

        [31661] = "scatter", -- Dragon's Breath (Rank 1)
        [33041] = "scatter", -- Dragon's Breath (Rank 2)
        [33042] = "scatter", -- Dragon's Breath (Rank 3)
        [33043] = "scatter", -- Dragon's Breath (Rank 4)
        [42949] = "scatter", -- Dragon's Breath (Rank 5)
        [42950] = "scatter", -- Dragon's Breath (Rank 6)
        [19503] = "scatter", -- Scatter Shot

        -- Spells that DR with itself only
        [33786] = "cyclone",        -- Cyclone
        [605]   = "mind_control",   -- Mind Control
        [13181] = "mind_control",   -- Gnomish Mind Control Cap
        [67799] = "mind_control",   -- Mind Amplification Dish
        [7922]  = "charge",         -- Charge Stun
        [19306] = "counterattack",  -- Counterattack 1
        [20909] = "counterattack",  -- Counterattack 2
        [20910] = "counterattack",  -- Counterattack 3
        [27067] = "counterattack",  -- Counterattack 4
        [48998] = "counterattack",  -- Counterattack 5
        [48999] = "counterattack",  -- Counterattack 6
        --Storm, Earth and Fire has no DR
    }

elseif Lib.gameExpansion == "classic" then

    -- SpellID list for Classic Era (vanilla)
    -- In Classic the spell ID payload is gone from the combat log, so we need the key here to be
    -- spell name instead. We also provide spell ID in the table value so it's possible to retrieve
    -- for example spell icon using GetSpellTexture(spellID) later on. (These functions only accept
    -- spell names if the player has the spell in their spell book)
    local GetSpellInfo = _G.GetSpellInfo -- upvalue
    Lib.spellList = {
        -- Controlled roots
        [GetSpellInfo(339)]     = { category = "root", spellID = 339 },      -- Entangling Roots
        [GetSpellInfo(19306)]   = { category = "root", spellID = 19306 },    -- Counterattack
        [GetSpellInfo(122)]     = { category = "root", spellID = 122 },      -- Frost Nova
    --  [GetSpellInfo(13099)]   = { category = "root", spellID = 13099 },    -- Net-o-Matic
    --  [GetSpellInfo(8312)]    = { category = "root", spellID = 8312 },     -- Trap

        -- Controlled stuns
        [GetSpellInfo(5211)]    = { category = "stun", spellID = 5211 },     -- Bash
        [GetSpellInfo(24394)]   = { category = "stun", spellID = 24394 },    -- Intimidation
        [GetSpellInfo(853)]     = { category = "stun", spellID = 853 },      -- Hammer of Justice
        [GetSpellInfo(9005)]    = { category = "stun", spellID = 9005 },     -- Pounce
        [GetSpellInfo(1833)]    = { category = "stun", spellID = 1833 },     -- Cheap Shot
        [GetSpellInfo(12809)]   = { category = "stun", spellID = 12809 },    -- Concussion Blow
        [GetSpellInfo(20253)]   = { category = "stun", spellID = 20253 },    -- Intercept Stun
        [GetSpellInfo(7922)]    = { category = "stun", spellID = 7922 },     -- Charge Stun
        [GetSpellInfo(20549)]   = { category = "stun", spellID = 20549 },    -- War Stomp (Racial)
        [GetSpellInfo(4068)]    = { category = "stun", spellID = 4068 },     -- Iron Grenade
        [GetSpellInfo(19769)]   = { category = "stun", spellID = 19769 },    -- Thorium Grenade
        [GetSpellInfo(13808)]   = { category = "stun", spellID = 13808 },    -- M73 Frag Grenade
        [GetSpellInfo(4069)]    = { category = "stun", spellID = 4069 },     -- Big Iron Bomb
        [GetSpellInfo(12543)]   = { category = "stun", spellID = 12543 },    -- Hi-Explosive Bomb
        [GetSpellInfo(4064)]    = { category = "stun", spellID = 4064 },     -- Rough Copper Bomb
        [GetSpellInfo(12421)]   = { category = "stun", spellID = 12421 },    -- Mithril Frag Bomb
        [GetSpellInfo(19784)]   = { category = "stun", spellID = 19784 },    -- Dark Iron Bomb
        [GetSpellInfo(4067)]    = { category = "stun", spellID = 4067 },     -- Big Bronze Bomb
        [GetSpellInfo(4066)]    = { category = "stun", spellID = 4066 },     -- Small Bronze Bomb
        [GetSpellInfo(4065)]    = { category = "stun", spellID = 4065 },     -- Large Copper Bomb
        [GetSpellInfo(13237)]   = { category = "stun", spellID = 13237 },    -- Goblin Mortar
        [GetSpellInfo(835)]     = { category = "stun", spellID = 835 },      -- Tidal Charm
        [GetSpellInfo(12562)]   = { category = "stun", spellID = 12562 },    -- The Big One

        -- Incapacitates
        [GetSpellInfo(2637)]    = { category = "incapacitate", spellID = 2637 },    -- Hibernate
        [GetSpellInfo(3355)]    = { category = "incapacitate", spellID = 3355 },    -- Freezing Trap
        [GetSpellInfo(19503)]   = { category = "incapacitate", spellID = 19503 },   -- Scatter Shot
        [GetSpellInfo(19386)]   = { category = "incapacitate", spellID = 19386 },   -- Wyvern Sting
        [GetSpellInfo(28271)]   = { category = "incapacitate", spellID = 28271 },   -- Polymorph: Turtle
        [GetSpellInfo(28272)]   = { category = "incapacitate", spellID = 28272 },   -- Polymorph: Pig
        [GetSpellInfo(118)]     = { category = "incapacitate", spellID = 118 },     -- Polymorph
        [GetSpellInfo(20066)]   = { category = "incapacitate", spellID = 20066 },   -- Repentance
        [GetSpellInfo(1776)]    = { category = "incapacitate", spellID = 1776 },    -- Gouge
        [GetSpellInfo(6770)]    = { category = "incapacitate", spellID = 6770 },    -- Sap
        [GetSpellInfo(1090)]    = { category = "incapacitate", spellID = 1090 },    -- Sleep
        [GetSpellInfo(13327)]   = { category = "incapacitate", spellID = 13327 },   -- Reckless Charge (Rocket Helmet)
        [GetSpellInfo(26108)]   = { category = "incapacitate", spellID = 26108 },   -- Glimpse of Madness

        -- Fears
        [GetSpellInfo(1513)]    = { category = "fear", spellID = 1513 },          -- Scare Beast
        [GetSpellInfo(8122)]    = { category = "fear", spellID = 8122 },          -- Psychic Scream
        [GetSpellInfo(5782)]    = { category = "fear", spellID = 5782 },          -- Fear
        [GetSpellInfo(5484)]    = { category = "fear", spellID = 5484 },          -- Howl of Terror
        [GetSpellInfo(6358)]    = { category = "fear", spellID = 6358 },          -- Seduction
        [GetSpellInfo(5246)]    = { category = "fear", spellID = 5246 },          -- Intimidating Shout
        [GetSpellInfo(5134)]    = { category = "fear", spellID = 5134 },          -- Flash Bomb Fear

        -- Random/short roots
        [GetSpellInfo(19229)]   = { category = "random_root", spellID = 19229 },   -- Improved Wing Clip
--      [GetSpellInfo(27868)]   = { category = "random_root", spellID = 12494 },   -- Frostbite
        [GetSpellInfo(23694)]   = { category = "random_root", spellID = 23694 },   -- Improved Hamstring
        [GetSpellInfo(27868)]   = { category = "random_root", spellID = 27868 },   -- Freeze (Item proc and set bonus)

        -- Random/short stuns
        [GetSpellInfo(16922)]   = { category = "random_stun", spellID = 16922 },   -- Improved Starfire
        [GetSpellInfo(19410)]   = { category = "random_stun", spellID = 19410 },   -- Improved Concussive Shot
        [GetSpellInfo(12355)]   = { category = "random_stun", spellID = 12355 },   -- Impact
        [GetSpellInfo(20170)]   = { category = "random_stun", spellID = 20170 },   -- Seal of Justice Stun
        [GetSpellInfo(15269)]   = { category = "random_stun", spellID = 15269 },   -- Blackout
        [GetSpellInfo(18093)]   = { category = "random_stun", spellID = 18093 },   -- Pyroclasm
        [GetSpellInfo(12798)]   = { category = "random_stun", spellID = 12798 },   -- Revenge Stun
        [GetSpellInfo(5530)]    = { category = "random_stun", spellID = 5530 },    -- Mace Stun Effect (Mace Specialization)
        [GetSpellInfo(15283)]   = { category = "random_stun", spellID = 15283 },   -- Stunning Blow (Weapon Proc)
        [GetSpellInfo(56)]      = { category = "random_stun", spellID = 56 },      -- Stun (Weapon Proc)
        [GetSpellInfo(21152)]   = { category = "random_stun", spellID = 21152 },   -- Earthshaker (Weapon Proc)

        -- Spells that DRs with itself only
        [GetSpellInfo(408)]     = { category = "kidney_shot", spellID = 408 },     -- Kidney Shot
        [GetSpellInfo(605)]     = { category = "mind_control", spellID = 605 },    -- Mind Control
        [GetSpellInfo(13181)]   = { category = "mind_control", spellID = 13181 },  -- Gnomish Mind Control Cap
        [GetSpellInfo(8056)]    = { category = "frost_shock", spellID = 8056 },    -- Frost Shock
    }
else
    print("DRList-1.0: Unsupported game expansion loaded.") -- luacheck: ignore
end

-- Alias for DRData-1.0
Lib.spells = Lib.spellList
