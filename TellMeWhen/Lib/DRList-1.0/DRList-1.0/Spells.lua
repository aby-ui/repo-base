local Lib, version = LibStub("DRList-1.0")
if Lib.spellList and version >= 23 then return end

if Lib.gameExpansion == "retail" then

    -- SpellID list for Retail WoW (always latest expansion)
    Lib.spellList = {
        -- Disorients
        [207167]  = "disorient",       -- Blinding Sleet
        [207685]  = "disorient",       -- Sigil of Misery
        [33786]   = "disorient",       -- Cyclone
        [1513]    = "disorient",       -- Scare Beast
        [31661]   = "disorient",       -- Dragon's Breath
        [198909]  = "disorient",       -- Song of Chi-ji
        [202274]  = "disorient",       -- Incendiary Brew
        [105421]  = "disorient",       -- Blinding Light
        [10326]   = "disorient",       -- Turn Evil (For Lichborne?)
        [605]     = "disorient",       -- Mind Control
        [8122]    = "disorient",       -- Psychic Scream
        [226943]  = "disorient",       -- Mind Bomb
        [2094]    = "disorient",       -- Blind
        [118699]  = "disorient",       -- Fear
        [5484]    = "disorient",       -- Howl of Terror
        [261589]  = "disorient",       -- Seduction (Grimoire of Sacrifice)
        [6358]    = "disorient",       -- Seduction (Succubus)
        [5246]    = "disorient",       -- Intimidating Shout
        [316593]  = "disorient",       -- Intimidating Shout 2 (not sure which one is correct in 9.0.1)
        [316595]  = "disorient",       -- Intimidating Shout 3
        [35474]   = "disorient",       -- Drums of Panic (Item)
        [269186]  = "disorient",       -- Holographic Horror Projector (Item)
        [280062]  = "disorient",       -- Unluckydo (Item)
        [267026]  = "disorient",       -- Giant Flower (Item)
        [243576]  = "disorient",       -- Sticky Starfish (Item)
        [331866]  = "disorient",       -- Agent of Chaos (Venthyr Covenant)

        -- Incapacitates
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
        [82691]   = "incapacitate",    -- Ring of Frost
        [115078]  = "incapacitate",    -- Paralysis
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
        [89637]   = "incapacitate",    -- Big Daddy (Item)
        [255228]  = "incapacitate",    -- Polymorphed (Organic Discombobulation Grenade) (Item)
        [71988]   = "incapacitate",    -- Vile Fumes (Item)

        -- Silences
        [47476]   = "silence",         -- Strangulate
        [204490]  = "silence",         -- Sigil of Silence
--      [78675]   = "silence",         -- Solar Beam (doesn't seem to DR)
        [202933]  = "silence",         -- Spider Sting
        [217824]  = "silence",         -- Shield of Virtue
        [15487]   = "silence",         -- Silence
        [1330]    = "silence",         -- Garrote
        [196364]  = "silence",         -- Unstable Affliction Silence Effect

        -- Stuns
        [210141]  = "stun",            -- Zombie Explosion
        [334693]  = "stun",            -- Absolute Zero (Breath of Sindragosa)
        [108194]  = "stun",            -- Asphyxiate (Unholy)
        [221562]  = "stun",            -- Asphyxiate (Blood)
        [91800]   = "stun",            -- Gnaw (Ghoul)
        [91797]   = "stun",            -- Monstrous Blow (Mutated Ghoul)
        [287254]  = "stun",            -- Dead of Winter
        [179057]  = "stun",            -- Chaos Nova
--      [213491]  = "stun",            -- Demonic Trample (Only DRs with itself once)
        [205630]  = "stun",            -- Illidan's Grasp (Primary effect)
        [208618]  = "stun",            -- Illidan's Grasp (Secondary effect)
        [211881]  = "stun",            -- Fel Eruption
        [200166]  = "stun",            -- Metamorphosis (PvE stun effect)
        [203123]  = "stun",            -- Maim
        [163505]  = "stun",            -- Rake (Prowl)
        [5211]    = "stun",            -- Mighty Bash
        [202244]  = "stun",            -- Overrun
        [325321]  = "stun",            -- Wild Hunt's Charge
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
--      [22703]   = "stun",            -- Infernal Awakening (doesn't seem to DR)
        [30283]   = "stun",            -- Shadowfury
        [46968]   = "stun",            -- Shockwave
        [132168]  = "stun",            -- Shockwave (Protection)
        [145047]  = "stun",            -- Shockwave (Proving Grounds PvE)
        [132169]  = "stun",            -- Storm Bolt
        [199085]  = "stun",            -- Warpath
--      [213688]  = "stun",            -- Fel Cleave (doesn't seem to DR)
        [20549]   = "stun",            -- War Stomp (Tauren)
        [255723]  = "stun",            -- Bull Rush (Highmountain Tauren)
        [287712]  = "stun",            -- Haymaker (Kul Tiran)
        [280061]  = "stun",            -- Brainsmasher Brew (Item)
        [245638]  = "stun",            -- Thick Shell (Item)
        [332423]  = "stun",            -- Sparkling Driftglobe Core

        -- Roots
        -- Note: Short roots (<= 2s) usually have no DR, e.g Thunderstruck.
        [204085]  = "root",            -- Deathchill (Chains of Ice)
        [233395]  = "root",            -- Deathchill (Remorseless Winter)
        [339]     = "root",            -- Entangling Roots
        [170855]  = "root",            -- Entangling Roots (Nature's Grasp)
--      [45334]   = "root",            -- Immobilized (Wild Charge, doesn't seem to DR)
        [102359]  = "root",            -- Mass Entanglement
        [117526]  = "root",            -- Binding Shot (Note: debuff says stun but it's actually a root)
        [162480]  = "root",            -- Steel Trap
--      [190927]  = "root_harpoon",    -- Harpoon (TODO: check if DRs with itself)
        [212638]  = "root",            -- Tracker's Net
        [201158]  = "root",            -- Super Sticky Tar
        [122]     = "root",            -- Frost Nova
        [33395]   = "root",            -- Freeze
        [198121]  = "root",            -- Frostbite
        [220107]  = "root",            -- Frostbite (Water Elemental? needs testing)
        [342375]  = "root",            -- Tormenting Backlash (Torghast pve, needs confirmation)
        [233582]  = "root",            -- Entrenched in Flame
        [116706]  = "root",            -- Disable
        [324382]  = "root",            -- Clash
        [64695]   = "root",            -- Earthgrab (Totem effect)
        [285515]  = "root",            -- Surge of Power
        [39965]   = "root",            -- Frost Grenade (Item)
        [75148]   = "root",            -- Embersilk Net (Item)
        [55536]   = "root",            -- Frostweave Net (Item)
        [268966]  = "root",            -- Hooked Deep Sea Net (Item)
        [270399]  = "root",            -- Unleashed Roots (Item)
        [270196]  = "root",            -- Chains of Light (Item)
        [267024]  = "root",            -- Stranglevines (Item)

        -- Disarms
        [209749]  = "disarm",          -- Faerie Swarm (Balance Honor Talent)
        [207777]  = "disarm",          -- Dismantle
        [233759]  = "disarm",          -- Grapple Weapon
        [236077]  = "disarm",          -- Disarm

        -- Taunts (PvE)
        [56222]   = "taunt",           -- Dark Command
        [51399]   = "taunt",           -- Death Grip
        [185245]  = "taunt",           -- Torment
        [6795]    = "taunt",           -- Growl (Druid)
        [2649]    = "taunt",           -- Growl (Hunter Pet) -- TODO: verify if DRs
        [20736]   = "taunt",           -- Distracting Shot
        [116189]  = "taunt",           -- Provoke
        [118635]  = "taunt",           -- Provoke (Black Ox Statue)
        [196727]  = "taunt",           -- Provoke (Niuzao)
        [204079]  = "taunt",           -- Final Stand
        [62124]   = "taunt",           -- Hand of Reckoning
        [17735]   = "taunt",           -- Suffering (Voidwalker)
        [355]     = "taunt",           -- Taunt
--      [36213]   = "taunt",           -- Angered Earth (Earth Elemental, has no debuff)

        -- Knockbacks (Experimental)
        [108199]  = "knockback",        -- Gorefiend's Grasp (Note: has no debuff)
        [202249]  = "knockback",        -- Overrun TODO: verify
        [61391]   = "knockback",        -- Typhoon
        [102793]  = "knockback",        -- Ursol's Vortex (Warning: May only be tracked on SPELL_AURA_REFRESH afaik)
        [186387]  = "knockback",        -- Bursting Shot
        [236777]  = "knockback",        -- Hi-Explosive Trap
        [157981]  = "knockback",        -- Blast Wave
        [237371]  = "knockback",        -- Ring of Peace (Note: has no debuff)
        [204263]  = "knockback",        -- Shining Force
        [51490]   = "knockback",        -- Thunderstorm
--      [287712]  = "knockback",        -- Haywire (Kul'Tiran Racial)
    }

elseif Lib.gameExpansion == "tbc" then


    -- Spells for TBC, including each rank.
    -- Note: categories are still largely unconfirmed.
    Lib.spellList = {
        -- Incaps:
        [22570] = "incapacitate", -- Maim
        [118]   = "incapacitate", -- Polymorph (Rank 1)
        [12824] = "incapacitate", -- Polymorph (Rank 2)
        [12825] = "incapacitate", -- Polymorph (Rank 3)
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
        [13327] = "incapacitate", -- Reckless Charge (Rocket Helmet)

        -- Disorients
        [33786] = "disorient", -- Cyclone
        [31661] = "disorient", -- Dragon's Breath (Rank 1) -- TODO: confirm category
        [33041] = "disorient", -- Dragon's Breath (Rank 2)
        [33042] = "disorient", -- Dragon's Breath (Rank 3)
        [33043] = "disorient", -- Dragon's Breath (Rank 4)
        [2094]  = "disorient", -- Blind

        -- Controlled Stuns
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
        [22703] = "stun", -- Inferno Effect
        [12809] = "stun", -- Concussion Blow
        [7922]  = "stun", -- Charge Stun
        [30153] = "stun", -- Intercept Stun (Rank 1)
        [30195] = "stun", -- Intercept Stun (Rank 2)
        [30197] = "stun", -- Intercept Stun (Rank 3)
        [20549] = "stun", -- War Stomp (Racial)
        [4064]  = "stun", -- Rough Copper Bomb
        [4065]  = "stun", -- Large Copper Bomb
        [4066]  = "stun", -- Small Bronze Bomb
        [4067]  = "stun", -- Big Bronze Bomb
        [4068]  = "stun", -- Iron Grenade
        [12421] = "stun", -- Mithril Frag Bomb
        [4069]  = "stun", -- Big Iron Bomb
        [12562] = "stun", -- The Big One
        [12543] = "stun", -- Hi-Explosive Bomb
        [19769] = "stun", -- Thorium Grenade
        [19784] = "stun", -- Dark Iron Bomb
        [30216] = "stun", -- Fel Iron Bomb
        [30461] = "stun", -- The Bigger One
        [30217] = "stun", -- Adamantite Grenade
        [13237] = "stun", -- Goblin Mortar
        [835]   = "stun", -- Tidal Charm

        -- Random/short stuns
        [16922]   = "random_stun",  -- Celestial Focus (Starfire Stun)
        [19410]   = "random_stun",  -- Improved Concussive Shot
        [12355]   = "random_stun",  -- Impact
        [20170]   = "random_stun",  -- Seal of Justice Stun
        [15269]   = "random_stun",  -- Blackout
        [18093]   = "random_stun",  -- Pyroclasm
        [12798]   = "random_stun",  -- Revenge Stun
        [5530]    = "random_stun",  -- Mace Stun Effect (Mace Specialization)
        [15283]   = "random_stun",  -- Stunning Blow (Weapon Proc)
        [56]      = "random_stun",  -- Stun (Weapon Proc)

        -- Sleep Effects
        [1090]  = "sleep", -- Sleep
        [2637]  = "sleep", -- Hibernate (Rank 1)
        [18657] = "sleep", -- Hibernate (Rank 2)
        [18658] = "sleep", -- Hibernate (Rank 3)
        [19386] = "sleep", -- Wyvern Sting (Rank 1)
        [24132] = "sleep", -- Wyvern Sting (Rank 2)
        [24133] = "sleep", -- Wyvern Sting (Rank 3)
        [27068] = "sleep", -- Wyvern Sting (Rank 4)

        -- Fears
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
        [14326] = "fear", -- Scare Beast (Rank 1)
        [14327] = "fear", -- Scare Beast (Rank 1)
        [5246]  = "fear", -- Intimidating Shout
        [5134]  = "fear", -- Flash Bomb Fear

        -- Roots
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
        --[16979] = "root", -- Feral Charge
        [19306] = "root", -- Counterattack (Rank 1)
        [20909] = "root", -- Counterattack (Rank 2)
        [20910] = "root", -- Counterattack (Rank 3)
        [27067] = "root", -- Counterattack (Rank 4)
        --[19185] = "root", -- Entrapment
        [122]   = "root", -- Frost Nova (Rank 1)
        [865]   = "root", -- Frost Nova (Rank 2)
        [6131]  = "root", -- Frost Nova (Rank 3)
        [10230] = "root", -- Frost Nova (Rank 4)
        [27088] = "root", -- Frost Nova (Rank 5)
        [33395] = "root", -- Freeze (Water Elemental)
        --[12494] = "root", -- Frostbite
        --[44047] = "root", -- Chastise TODO: confirm
        [39965] = "root", -- Frost Grenade

        -- Mind Controls
        [605]   = "mind_control", -- Mind Control (Rank 1)
        [10911] = "mind_control", -- Mind Control (Rank 2)
        [10912] = "mind_control", -- Mind Control (Rank 3)
        [13181] = "mind_control", -- Gnomish Mind Control Cap

        -- Disarms
        [41392] = "disarm", -- Riposte
        [676]   = "disarm", -- Disarm

        -- Spells that DR with itself only
        [408]   = "kidney_shot",         -- Kidney Shot (Rank 1)
        [8643]  = "kidney_shot",         -- Kidney Shot (Rank 2)
        [43523] = "unstable_affliction", -- Unstable Affliction 1 TODO: confirm
        [31117] = "unstable_affliction", -- Unstable Affliction 2
        [6789]  = "death_coil",          -- Death Coil (Rank 1)
        [17925] = "death_coil",          -- Death Coil (Rank 2)
        [17926] = "death_coil",          -- Death Coil (Rank 3)
        [27223] = "death_coil",          -- Death Coil (Rank 4)
        [3355]  = "freezing_trap",       -- Freezing Trap Effect (Rank 1)
        [14308] = "freezing_trap",       -- Freezing Trap Effect (Rank 2)
        [14309] = "freezing_trap",       -- Freezing Trap Effect (Rank 3)
        [19503] = "scatter_shot",        -- Scatter Shot
        [12494] = "random_root",         -- Frostbite (Seems to only be Frostbite for random_root)
    }

elseif Lib.gameExpansion == "classic" then

    -- Spell list for Classic (WIP)
    -- In Classic the spell ID payload is gone from the combat log, so we need the key here to be
    -- spell name instead. We also provide spell ID in the table value so it's possible to retrieve
    -- for example spell icon using GetSpellTexture(spellID) later on. (These functions only accept
    -- spell names if the player has the spell in their spell book)
    Lib.spellList = {
        -- Controlled roots
        [GetSpellInfo(339)]     = { category = "root", spellID = 339 },      -- Entangling Roots
        [GetSpellInfo(19306)]   = { category = "root", spellID = 19306 },    -- Counterattack
        [GetSpellInfo(122)]     = { category = "root", spellID = 122 },      -- Frost Nova
    --  [GetSpellInfo(13099)]   = { category = "root", spellID = 13099 },    -- Net-o-Matic (These doesn't seem to DR here, maybe only with itself?)
    --  [GetSpellInfo(8312)]    = { category = "root", spellID = 8312 },     -- Trap

        -- Controlled stuns
        [GetSpellInfo(5211)]    = { category = "stun", spellID = 5211 },     -- Bash
        [GetSpellInfo(24394)]   = { category = "stun", spellID = 24394 },    -- Intimidation
        [GetSpellInfo(853)]     = { category = "stun", spellID = 853 },      -- Hammer of Justice
        [GetSpellInfo(22703)]   = { category = "stun", spellID = 22703 },    -- Inferno Effect (Summon Infernal) TODO: confirm
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

        -- Random/short roots (TODO: confirm category exists)
        [GetSpellInfo(19229)]   = { category = "random_root", spellID = 19229 },   -- Improved Wing Clip
        [GetSpellInfo(23694)]   = { category = "random_root", spellID = 23694 },   -- Improved Hamstring
        [GetSpellInfo(27868)]   = { category = "random_root", spellID = 27868 },   -- Freeze (Item proc and set bonus)

        -- Random/short stuns (TODO: confirm category exists)
        [GetSpellInfo(16922)]   = { category = "random_stun", spellID = 16922 },   -- Improved Starfire
        [GetSpellInfo(19410)]   = { category = "random_stun", spellID = 19410 },   -- Improved Concussive Shot
        [GetSpellInfo(12355)]   = { category = "random_stun", spellID = 12355 },   -- Impact
        [GetSpellInfo(20170)]   = { category = "random_stun", spellID = 20170 },   -- Seal of Justice Stun
        --[GetSpellInfo(15269)]   = { category = "random_stun", spellID = 15269 }, -- Blackout
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
    error("DRList-1.0: Unsupported game expansion loaded.")
end

-- Alias for DRData-1.0
Lib.spells = Lib.spellList
