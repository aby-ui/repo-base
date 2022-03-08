-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...

local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local Collectible = ns.node.Collectible
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Arrow = ns.poi.Arrow
local Path = ns.poi.Path
local POI = ns.poi.POI

local NIGHTFAE = ns.covenants.FAE

-------------------------------------------------------------------------------

local map = Map({id = 1970, settings = true})
local bfdry = Map({id = 2027}) -- Blooming Foundry
local esper = Map({id = 2028}) -- Locrian Esper
local gpose = Map({id = 2029}) -- Gravid Repose
local microd = Map({id = 2030}) -- Nexus of Actualization
local cata = Map({id = 2066}) -- Catalyst Wards

-- Sepulcher of the First Ones
local immo = Map({id = 2047}) -- Immortal Hearth

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

-- TODO: Verify - Only one of either Euv'ouk or Vitiane can be up for a given day.
-- TODO: Verify - Helmix is spawned by killing the Annelid Mudborers.

map.nodes[64743369] = Rare({
    id = 179006,
    quest = 65552,
    vignette = 4747,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+15 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52977}), -- Adventurer of Zereth Mortis
        Transmog({item = 189903, slot = L['cloth']}), -- Sand Sifting Sandals
        Transmog({item = 189958, slot = L['plate']}), -- Tunneler's Penetrating Greathelm
        Transmog({item = 190053, slot = L['crossbow']}) -- Underground Circler's Crossbow
    }
}) -- Akkaris

map.nodes[49566751] = Rare({
    id = 183596,
    quest = 65553,
    vignette = 4948,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52978}), -- Adventurer of Zereth Mortis
        Transmog({item = 189947, slot = L['mail']}), -- Majestic Watcher's Girdle
        Transmog({item = 189906, slot = L['cloth']}), -- Mask of the Resolute Cervid
        Transmog({item = 189994, slot = L['2h_mace']}) -- Chitali's Command
    }
}) -- Chitali the Eldest

map.nodes[47486228] = Rare({
    id = 183953,
    quest = 65273,
    vignette = 4989,
    note = L['corrupted_architect_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53047}), -- Adventurer of Zereth Mortis
        Transmog({item = 189907, slot = L['cloth']}), -- Crown of Contorted Thought
        Transmog({item = 189940, slot = L['mail']}), -- Architect's Polluting Touch
        Transmog({item = 190009, slot = L['2h_mace']}) -- Hammer of Shattered Works
    }
}) -- Corrupted Architect

map.nodes[53634435] = Rare({
    id = 180917,
    quest = 64716,
    vignette = 4892,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52974}), -- Adventurer of Zereth Mortis
        Transmog({item = 189910, slot = L['cloth']}), -- Adornment of Jingling Fractals
        Transmog({item = 189930, slot = L['leather']}), -- Restraints of Boundless Chaos
        Transmog({item = 189985, slot = L['cloak']}), -- Curtain of Untold Realms
        Transmog({item = 189999, slot = L['1h_mace']}) -- Dark Sky Gavel
        -- Item({item = 187837}) -- Schematic: Erratic Genesis Matrix (engineering)
    }
}) -- Destabilized Core

map.nodes[47474516] = Rare({
    id = 184409,
    quest = 65555,
    vignette = 4961,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52982}), -- Adventurer of Zereth Mortis
        Transmog({item = 189949, slot = L['mail']}), -- Shackles of the Bound Guardian
        Transmog({item = 189956, slot = L['plate']}), -- Perverse Champion's Handguards
        Transmog({item = 190047, slot = L['staff']}), -- Converted Broker's Staff
        Transmog({item = 189993, slot = L['2h_mace']}) -- Twisted Judicator's Gavel
    }
}) -- Euv'ouk

map.nodes[61826060] = Rare({
    id = 178229,
    quest = 65557,
    vignette = 4740,
    note = L['feasting_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52973}), -- Adventurer of Zereth Mortis
        Transmog({item = 189969, slot = L['mail']}), -- Vespoid's Clanging Legguards
        Transmog({item = 189970, slot = L['plate']}), -- Visor of Visceral Cravings
        Transmog({item = 189936, slot = L['cloak']}) -- Feasting's Feeding Cloak
        -- Item({item = 187848}) -- Recipe: Sustaining Armor Polish
    }
}) -- Feasting

map.nodes[64585865] = Rare({
    id = 183646,
    quest = 65544,
    vignette = 4949,
    note = L['furidian_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53031}), -- Adventurer of Zereth Mortis
        Transmog({item = 189920, slot = L['leather']}), -- Viperid Keeper's Gloves
        Transmog({item = 189932, slot = L['mail']}), -- Slick Scale Chitin
        Transmog({item = 189963, slot = L['plate']}), -- Sculpted Ouroboros Clasp
        Transmog({item = 190004, slot = L['dagger']}) -- Furidian's Inscribed Barb
    },
    pois = {
        POI({
            62595982, -- cube
            64005729, -- asteriks
            64456040 -- sphere
        })
    }
}) -- Furidian

map.nodes[69073662] = Rare({
    id = 180924,
    quest = 64719,
    vignette = 4982,
    note = L['garudeon_note'],
    rlabel = ns.status.LightBlue('+15 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53025}), -- Adventurer of Zereth Mortis
        Transmog({item = 189951, slot = L['plate']}), -- Sunbathed Avian Armor
        Transmog({item = 189937, slot = L['cloak']}) -- Garudeon's Blanket of Feathers
        -- Item({item = 187832}) -- Schematic: Pure-Air Sail Extensions (engineering)
    },
    pois = {
        POI({
            66343802, 66483446, 67153681, 67553892, 67554019, 68013938,
            68153594, 68333834, 68403357
        }) -- Energizing Leporid
    }
}) -- Garudeon

map.nodes[59862111] = Rare({
    id = 182318,
    quest = 65583,
    vignette = 4909,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+15 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52985}), -- Adventurer of Zereth Mortis
        Transmog({item = 189968, slot = L['leather']}), -- Dreadlord General's Tunic
        Transmog({item = 189948, slot = L['mail']}), -- Strangulating Chainlink Lasso
        Transmog({item = 190125, slot = L['dagger']}) -- Kris of Intricate Secrets
    }
}) -- General Zarathura

map.nodes[53089305] = Rare({
    id = 178778,
    quest = 65579,
    vignette = 4742,
    note = L['gluttonous_overgrowth_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52971}), -- Adventurer of Zereth Mortis
        Transmog({item = 189929, slot = L['leather']}), -- Vinebound Strap
        Transmog({item = 189953, slot = L['plate']}), -- Lush-Stained Footguards
        Transmog({item = 190008, slot = L['1h_sword']}), -- Enlightened Botanist's Machete
        Transmog({item = 190049, slot = L['fist']}) -- Perennial Punching Dagger
    },
    pois = {POI({53219302, 54019118, 52019377, 52389280, 53469081})} -- Bulging Root
}) -- Gluttonous Overgrowth

map.nodes[80384706] = Rare({
    id = 178963,
    quest = 63988,
    vignette = 4746,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52986}), -- Adventurer of Zereth Mortis
        Transmog({item = 189960, slot = L['plate']}), -- Crouching Legs of the Bufonid
        Transmog({item = 190001, slot = L['shield']}) -- Gorkek's Glistening Throatguard
    },
    pois = {Path({80324594, 80384706, 80844886}), POI({76004540, 75605960})}
}) -- Gorkek

map.nodes[52612503] = Rare({
    id = 178563,
    quest = 65581,
    vignette = 4738,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52984}), -- Adventurer of Zereth Mortis
        Transmog({item = 189919, slot = L['leather']}), -- Skittering Scarabid Treads
        Transmog({item = 189942, slot = L['mail']}), -- Hadeon's Indomitable Faceguard
        Transmog({item = 190051, slot = L['staff']}), -- Elder's Opulent Stave
        Transmog({item = 190000, slot = L['shield']}) -- Carapace of Gliding Sands
    }
}) -- Hadeon the Stonebreaker

map.nodes[58186837] = Rare({
    id = 183748,
    quest = 65551,
    vignette = 4950,
    note = L['helmix_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53048}), -- Adventurer of Zereth Mortis
        Transmog({item = 189931, slot = L['leather']}), -- Annelid's Hinge Wrappings
        Transmog({item = 189965, slot = L['plate']}), -- Armored Cuffs of Helmix
        Transmog({item = 190054, slot = L['crossbow']}), -- Facet Sharpening Crossbow
        Transmog({item = 190056, slot = L['offhand']}) -- Enlightened Explorer's Lantern
    }
}) -- Helmix

-- Craft/loot Aurelid Lure quest=65039
-- Extra quest for person with lura when Hirukon dies? quest=65785
map.nodes[52287541] = Rare({
    id = 180978,
    quest = 65548,
    vignette = 4984,
    note = L['hirukon_note'],
    requires = ns.requirement.Item(187923),
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52990}), -- Adventurer of Zereth Mortis
        Transmog({item = 189905, slot = L['cloth']}), -- Hirukon's Syrupy Squeezers
        Transmog({item = 189946, slot = L['mail']}), -- Jellied Aurelid Mantle
        Transmog({item = 190005, slot = L['1h_sword']}), -- Hirukon's Radiant Reach
        Mount({id = 1434, item = 187676}) -- Deepstar Aurelid
    }
}) -- Hirukon

map.nodes[58654039] = Rare({
    id = 183814,
    quest = 65257,
    vignette = 4941,
    note = L['in_small_cave'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53046}), -- Adventurer of Zereth Mortis
        Transmog({item = 189909, slot = L['cloth']}), -- Pantaloons of Cold Recesses
        Transmog({item = 189945, slot = L['mail']}), -- Shoulders of the Missing Giant
        Transmog({item = 189957, slot = L['plate']}) -- Colossus' Focusing Headpiece
    },
    pois = {POI({58723789})} -- Cave entrance
}) -- Otaris the Provoked

map.nodes[54083493] = Rare({
    id = 178508,
    quest = 65547,
    vignette = 4739,
    rlabel = ns.status.LightBlue('+15 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53020}), -- Adventurer of Zereth Mortis
        Transmog({item = 189923, slot = L['leather']}), -- Tarachnid's Terrifying Visage
        Transmog({item = 189950, slot = L['mail']}), -- Constrained Prey's Binds
        Transmog({item = 190045, slot = L['staff']}) -- Flowing Sandbender's Staff
    },
    pois = {POI({55963261})} -- Cave entrance
}) -- Mother Phestis

map.nodes[55736915] = Rare({
    id = 179043,
    quest = 65582,
    vignette = 4770,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    note = L['orixal_note'],
    rewards = {
        Achievement({id = 15391, criteria = 52981}), -- Adventurer of Zereth Mortis
        Transmog({item = 189912, slot = L['cloth']}), -- Orixal's Moist Sash
        Transmog({item = 189934, slot = L['mail']}), -- Slime-Wake Sabatons
        Transmog({item = 189952, slot = L['plate']}) -- Celestial Mollusk's Chestshell
    },
    pois = {
        Path({
            55736915, 54926943, 54756897, 55356817, 55826788, 56226828,
            56526887, 56416952, 56026959, 55736915, 55896843, 56226828
        })
    }
}) -- Orixal

map.nodes[43308762] = Rare({
    id = 183746,
    quest = 65556,
    vignette = 4939,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52972}), -- Adventurer of Zereth Mortis
        Transmog({item = 189914, slot = L['cloth']}), -- Otiosen's Regenerative Wristwraps
        Transmog({item = 189925, slot = L['leather']}), -- Amphibian's Nimble Leggings
        Transmog({item = 190046, slot = L['staff']}), -- Broker's Stolen Cane
        Transmog({item = 189995, slot = L['1h_mace']}) -- Builder's Alignment Hammer
    }
}) -- Otiosen

map.nodes[38872762] = Rare({
    id = 180746,
    quest = 64668,
    vignette = 4988,
    note = L['protector_first_ones_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52989}), -- Adventurer of Zereth Mortis
        Transmog({item = 189961, slot = L['plate']}), -- Enduring Protector's Shoulderguards
        Transmog({item = 189984, slot = L['cloak']}), -- Drape of Idolized Symmetry
        Transmog({item = 190002, slot = L['shield']}) -- Bulwark of the Broken
    },
    pois = {POI({40532387, 41352440, 42502685, 43072514})} -- Mysterious Sigil
}) -- Protector of the First Ones

map.nodes[53384707] = Rare({
    id = 183927,
    quest = 65574,
    vignette = 4977,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52975}), -- Adventurer of Zereth Mortis
        Transmog({item = 189927, slot = L['leather']}), -- Broker's Gnawed Spaulders
        Transmog({item = 189955, slot = L['plate']}), -- Scarabid's Clattering Handguards
        Transmog({item = 189998, slot = L['1h_mace']}) -- Ornate Stone Mallet
    }
}) -- Sand Matriarch Ileus

map.nodes[42302099] = Rare({
    id = 184413,
    quest = 65549,
    vignette = 4959,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52988}), -- Adventurer of Zereth Mortis
        Transmog({item = 189908, slot = L['cloth']}), -- Gorger's Leggings of Famine
        Transmog({item = 189916, slot = L['leather']}), -- Mutated Devourer's Harness
        Transmog({item = 189941, slot = L['mail']}), -- Voracious Diadem
        Item({item = 189972, quest = 65505, covenant = NIGHTFAE}) -- Scorpid Soul
    }
}) -- Shifting Stargorger

map.nodes[35877121] = Rare({
    id = 183722,
    quest = 65240,
    vignette = 4937,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52980}), -- Adventurer of Zereth Mortis
        Transmog({item = 189911, slot = L['cloth']}), -- Sublime Fur Mantle
        Transmog({item = 189944, slot = L['mail']}), -- Immovable Stance of the Vombata
        Transmog({item = 189962, slot = L['plate']}) -- Sorranos' Gleaming Pauldrons
        -- Item({item = 187826}) -- Formula: Cosmic Protoweave
    }
}) -- Sorranos

map.nodes[49783914] = Rare({
    id = 183925,
    quest = 65272,
    vignette = 4943,
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52979}), -- Adventurer of Zereth Mortis
        Transmog({item = 189915, slot = L['cloth']}), -- Tahkwitz' Cloth Ribbon
        Transmog({item = 189933, slot = L['mail']}), -- Vigilant Raptora's Crest
        Transmog({item = 189954, slot = L['plate']}) -- Lustrous Sentinel's Sabatons
        -- Item({item = 187832}) -- Schematic: Pure-Air Sail Extensions (engineering)
    }
}) -- Tahkwitz

map.nodes[54507344] = Rare({
    id = 181249,
    quest = 65550,
    vignette = 4903,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52987}), -- Adventurer of Zereth Mortis
        Transmog({item = 189928, slot = L['leather']}), -- Centripetal Waistband
        Transmog({item = 189966, slot = L['plate']}), -- Singing Metal Wristbands
        Transmog({item = 190055, slot = L['offhand']}) -- Coalescing Energy Implement
        -- Item({item = 187830}) -- Design: Aealic Harmonizing Stone
    }
}) -- Tethos

map.nodes[43947530] = Rare({
    id = 183516,
    quest = 65580,
    vignette = 4933,
    note = L['the_engulfer_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53050}), -- Adventurer of Zereth Mortis
        Transmog({item = 189913, slot = L['cloth']}), -- Engulfer's Tightening Cinch
        Transmog({item = 189921, slot = L['leather']}), -- Devourer's Insatiable Grips
        Transmog({item = 190006, slot = L['1h_sword']}) -- Anima-Siphoning Sword
    }
}) -- The Engulfer

map.nodes[39555737] = Rare({
    id = 181360,
    quest = 65239,
    vignette = 4936,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53049}), -- Adventurer of Zereth Mortis
        Transmog({item = 189900, slot = L['cloth']}), -- Vexis' Gentle Heartcloth
        Transmog({item = 189959, slot = L['plate']}), -- Legs of Graceful Landing
        Transmog({item = 189997, slot = L['1h_sword']}), -- The Lupine Prime's Might
        Transmog({item = 190048, slot = L['fist']}) -- Vexis' Wisest Fang
    }
}) -- Vexis

map.nodes[47044698] = Rare({
    id = 183747,
    quest = 65584,
    vignette = 4967,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52983}), -- Adventurer of Zereth Mortis
        Transmog({item = 189901, slot = L['cloth']}), -- Vitiane's Defiled Vestment
        Transmog({item = 189922, slot = L['leather']}), -- Cowl of Shameful Proliferation
        Transmog({item = 189935, slot = L['mail']}) -- Harrowing Hope Squashers
    }
}) -- Vitiane

map.nodes[64054975] = Rare({
    id = 183737,
    quest = 65241,
    vignette = 4938,
    sublabel = L['sl_limited_rare'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 52976}), -- Adventurer of Zereth Mortis
        Transmog({item = 190052, slot = L['dagger']}), -- Xy'rath's Letter Opener
        Transmog({item = 190007, slot = L['1h_sword']}), -- Xy'rath's Signature Saber
        Toy({item = 190238}) -- Xy'rath's Booby-Trapped Cache
        -- Item({item = 187828}) -- Recipe: Infusion: Corpse Purification
    }
}) -- Xy'rath the Covetous

map.nodes[43513294] = Rare({
    id = 183764,
    quest = 65251,
    vignette = 4990,
    note = L['zatojin_note'],
    rlabel = ns.status.LightBlue('+10 ' .. L['rep']),
    rewards = {
        Achievement({id = 15391, criteria = 53044}), -- Adventurer of Zereth Mortis
        Transmog({item = 189902, slot = L['cloth']}), -- Hapless Traveler's Treads
        Transmog({item = 189924, slot = L['leather']}), -- Buzzing Predator's Legs
        Transmog({item = 189939, slot = L['mail']}) -- Zatojin's Paralytic Grip
    }
}) -- Zatojin

------------------------------- DUNE DOMINANCE --------------------------------

-- quest 58013 ??

local ISKA = '{npc:182114}'
local DAMARIS = '{npc:182155}'
local MARZAN = '{npc:182158}'

map.nodes[63202603] = Rare({
    id = 182114,
    label = '{achievement:15392}',
    quest = {65585, 65586, 65587},
    questCount = true,
    note = L['dune_dominance_note'],
    rlabel = ns.status.LightBlue('+15 ' .. L['rep']),
    rewards = {
        Achievement({
            id = 15392,
            criteria = {
                {id = 52992, quest = 65585}, -- Iska, Outrider of Ruin (mount=65706)
                {id = 52993, quest = 65586}, -- High Reaver Damaris (mount=65558)
                {id = 52994, quest = 65587} -- Reanimatrox Marzan
            }
        }), -- Dune Dominance
        Transmog({item = 190050, slot = L['fist']}), -- Entropic Broker's Ripper
        Transmog({item = 190104, slot = L['crossbow']}), -- Deadeye's Spirit Piercer
        Transmog({item = 190107, slot = L['staff']}), -- Staff of Broken Coils
        Transmog({item = 190124, slot = L['dagger']}), -- Interrogator's Vicious Dirk
        Transmog({item = 190463, slot = L['warglaive']}), -- Dismal Mystic's Glaive
        Transmog({item = 190102, slot = L['1h_mace'], note = ISKA}), -- Chains of Infectious Serrations
        Transmog({item = 190103, slot = L['2h_mace'], note = ISKA}), -- Pillar of Noxious Dissemination
        Transmog({item = 190126, slot = L['polearm'], note = ISKA}), -- Rotculler's Encroaching Shears
        Transmog({item = 190458, slot = L['shield'], note = ISKA}), -- Atrophy's Ominous Bulwark
        Transmog({item = 190105, slot = L['1h_mace'], note = DAMARIS}), -- Chilling Domination Mace
        Transmog({item = 190106, slot = L['2h_mace'], note = DAMARIS}), -- Approaching Terror's Torch
        Transmog({item = 190459, slot = L['shield'], note = DAMARIS}), -- Cold Dispiriting Barricade
        Transmog({item = 190460, slot = L['polearm'], note = DAMARIS}), -- High Reaver's Sickle
        Transmog({item = 190108, slot = L['shield'], note = MARZAN}), -- Aegis of Laughing Souls
        Transmog({item = 190109, slot = L['1h_mace'], note = MARZAN}), -- Cudgel of Mortality's Chains
        Transmog({item = 190127, slot = L['polearm'], note = MARZAN}), -- Marzan's Dancing Twin-Scythe
        Transmog({item = 190461, slot = L['2h_mace'], note = MARZAN}), -- Reanimator's Beguiling Baton
        Mount({item = 190765, id = 1584, note = '{npc:182120}'}) -- Iska's Mawrat Leash
    }
})

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- Unknown/Mystery Treasures:
-- Pocopoc costume unlock (first appearance learned) (quest=65531)
-- Glimmer of Serenity (64666343, 60412528)

map.nodes[61153714] = Treasure({
    quest = 65520,
    requires = ns.requirement.GarrisonTalent(1931),
    note = L['architects_reserve_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53053}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53290}), -- Fashion of the First Ones
        Item({item = 187833, quest = 65528}) -- Dapper Pocopoc
    }
}) -- Architect's Reserve

map.nodes[47449524] = Treasure({
    quest = 65573,
    note = L['bushel_of_produce_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53071}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53286}), -- Fashion of the First Ones
        Toy({item = 190853}), -- Bushel of Mysterious Fruit
        Item({item = 189451, quest = 65524}) -- Chef Pocopoc
    }
}) -- Bushel of Progenitor Produce

map.nodes[56746416] = Treasure({
    quest = 65489,
    note = L['crushed_crate_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53054}) -- Treasures of Zereth Mortis
    }
}) -- Crushed Supply Crate

map.nodes[38253724] = Treasure({
    quest = 64667,
    rewards = {
        Achievement({id = 15331, criteria = 52965}), -- Treasures of Zereth Mortis
        Transmog({item = 190637, slot = L['1h_mace']}) -- Percussive Maintenance Instrument
    }
}) -- Damaged Jiro Stash

map.nodes[60011798] = Treasure({
    quest = 65465,
    note = L['domination_cache_note'],
    requires = ns.requirement.Item(189704),
    rewards = {
        Achievement({id = 15331, criteria = 53018}), -- Treasures of Zereth Mortis
        Transmog({item = 190638, slot = L['2h_sword']}) -- Tormented Mawsteel Greatsword
    }
}) -- Domination Cache

map.nodes[35167020] = Treasure({
    quest = 65523,
    note = L['drowned_broker_supplies_note'],
    requires = ns.requirement.GarrisonTalent(1932),
    rewards = {
        Achievement({id = 15331, criteria = 53061}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53288}), -- Fashion of the First Ones
        Item({item = 190059, quest = 65526}) -- Pirate Pocopoc
    },
    pois = {POI({34497053})} -- Coreless Aurelid
}) -- Drowned Broker Supplies

map.nodes[51550989] = Treasure({
    quest = 65487,
    rewards = {
        Achievement({id = 15331, criteria = 53016}) -- Treasures of Zereth Mortis
    }
}) -- Fallen Vault

map.nodes[49758723] = Treasure({
    quest = 65503,
    note = L['sphere_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53052}) -- Treasures of Zereth Mortis
    }
}) -- Filched Artifact

map.nodes[67016935] = Treasure({
    quest = 65178,
    note = L['forgotten_protovault_note'] .. '\n\n' ..
        L['schematic_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52967}), -- Treasures of Zereth Mortis
        Item({item = 189469, quest = 65393}) -- Schematic: Prototype Leaper
    }
}) -- Forgotten Proto-Vault

map.nodes[38977321] = Treasure({
    quest = 65480,
    rewards = {
        Achievement({id = 15331, criteria = 53017}) -- Treasures of Zereth Mortis
    }
}) -- Gnawed Valise

map.nodes[37177832] = Treasure({
    quest = 65545,
    note = L['grateful_boon_note'] .. '\n\n' .. L['schematic_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53066}), -- Treasures of Zereth Mortis
        Item({item = 189478, quest = 65401}) -- Schematic: Adorned Vombata
    }
}) -- Grateful Boon

map.nodes[58847706] = Treasure({
    quest = 65173,
    note = L['in_cave'] .. ' ' .. L['library_vault_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52887}), -- Treasures of Zereth Mortis
        Item({item = 189447, quest = 65360}) -- Schematic: Viperid Menace
    },
    pois = {POI({59238144})} -- Cave entrance
}) -- Library Vault (Lost Scroll)

map.nodes[60593053] = Treasure({
    quest = 65441,
    note = L['schematic_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52969}), -- Treasures of Zereth Mortis
        Item({item = 189456, quest = 65379}) -- Schematic: Sundered Zerethsteed
    }
}) -- Mawsworn Cache

map.nodes[53557223] = Treasure({
    quest = 65522,
    note = L['mistaken_ovoid_note'] .. '\n\n' .. L['schematic_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53060}), -- Treasures of Zereth Mortis
        Item({item = 189435, quest = 65333}) -- Schematic: Multichicken
    },
    pois = {
        POI({
            33964576, 34204869, 34316656, 34494976, 34514971, 34676925,
            35174905, 35204889, 35974620, 36735967, 39345098, 41386931,
            41855715, 43228490, 44565985, 44755183, 46686301, 48157357,
            49187153, 50807081, 52427364, 53836486, 55207685, 55986879,
            58916831, 60847592, 61076515
        })
    }
}) -- Mistaken Ovoid

map.nodes[34815604] = Treasure({
    quest = 65537,
    rlabel = ns.status.LightBlue('+75 ' .. L['rep']),
    rewards = {
        Achievement({id = 15331, criteria = 53062}) -- Treasures of Zereth Mortis
    }
}) -- Offering to the First Ones

map.nodes[35244411] = Treasure({
    quest = 65536,
    rewards = {
        Achievement({id = 15331, criteria = 53056}) -- Treasures of Zereth Mortis
    }
}) -- Overgrown Protofruit

map.nodes[60874295] = Treasure({
    quest = 65542,
    rewards = {
        Achievement({id = 15331, criteria = 53064}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53294}), -- Fashion of the First Ones
        Item({item = 190098, quest = 65538}) -- Pepepec
    }
}) -- Pilfered Curio

map.nodes[52577147] = Treasure({
    quest = 65546,
    rewards = {
        Achievement({id = 15331, criteria = 53067}), -- Treasures of Zereth Mortis
        Transmog({item = 190952, slot = L['offhand']}) -- Protoflora Harvester
    }
}) -- Protoflora Harvester

map.nodes[46643094] = Treasure({
    quest = 65540,
    rewards = {
        Achievement({id = 15331, criteria = 53063}), -- Treasures of Zereth Mortis
        Transmog({item = 190942, slot = L['1h_axe']}) -- Protomineral Extractor
    }
}) -- Protomineral Extractor

bfdry.nodes[65645023] = Treasure({
    quest = 65566,
    parent = map.id,
    note = L['ripened_protopear_note'],
    requires = ns.requirement.GarrisonTalent(1931),
    rewards = {
        Achievement({id = 15331, criteria = 53069}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53287}), -- Fashion of the First Ones
        Item({item = 190058, quest = 65525}) -- Peaceful Pocopoc
    },
    pois = {
        POI({
            23036658, 30336288, 41593238, 42447504, 45233985, 64725877,
            67694623, 70086712, 75467431
        }) -- Pollen Cloud
    }
}) -- Ripened Protopear

map.nodes[37906520] = Treasure({
    quest = 65447,
    note = L['sphere_treasure_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52970}) -- Treasures of Zereth Mortis
    }
}) -- Stolen Relic

map.nodes[34046764] = Treasure({
    quest = 65543,
    rlabel = ns.status.LightBlue('+75 ' .. L['rep']),
    rewards = {
        Achievement({id = 15331, criteria = 53065}) -- Treasures of Zereth Mortis
    },
    pois = {Path({34046764, 33636720, 33566585, 33466475})}
}) -- Stolen Scroll

map.nodes[58727301] = Treasure({
    quest = 64545,
    note = L['submerged_chest_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52964}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53291}), -- Fashion of the First Ones
        Item({item = 190061, quest = 65529}) -- Admiral Pocopoc
    },
    pois = {POI({59427684})} -- Dangerous Orb of Power
}) -- Submerged Chest

-- Not going to give answer in the note for now, instead I explain how to solve it
-- Solution: 183951 (se) => 183950 (nw) => 183948 (sw) => 183952 (ne)
map.nodes[52596297] = Treasure({
    quest = 65270,
    note = L['symphonic_vault_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52968}) -- Treasures of Zereth Mortis
    }
}) -- Symphonic Vault

map.nodes[77535820] = Treasure({
    quest = 65565,
    note = L['syntactic_vault_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53068}), -- Treasures of Zereth Mortis
        Toy({item = 190457}) -- Protopological Cube
    },
    pois = {POI({76924667, 76995879, 77056032, 78065339, 80935626, 81265045})}
}) -- Syntactic Vault

microd.nodes[51618820] = Treasure({
    quest = 65175,
    parent = map.id,
    note = L['template_archive_note'],
    rewards = {
        Achievement({id = 15331, criteria = 52966}), -- Treasures of Zereth Mortis
        Achievement({id = 15508, criteria = 53289}), -- Fashion of the First Ones
        Item({item = 190060, quest = 65527}) -- Adventurous Pocopoc
    },
    pois = {POI({72024882}), Arrow({72024882, 63855973})}
}) -- Template Archive

local function GetLockStatus()
    local count = 0
    for i, quest in ipairs {65589, 65590, 65591, 65592} do
        if C_QuestLog.IsQuestFlaggedCompleted(quest) then
            count = count + 1
        end
    end
    return ns.status.Gray(tostring(count) .. '/4')
end

cata.nodes[49243441] = Class('Foliage', Treasure,
    {getters = {rlabel = GetLockStatus}})({
    quest = 65572,
    parent = {
        id = map.id,
        pois = {POI({50017671, 50988209, 52498344, 53198092})} -- Locks (outside coords)
    },
    note = L['undulating_foliage_note'],
    rewards = {
        Achievement({id = 15331, criteria = 53070}), -- Treasures of Zereth Mortis
        Toy({item = 190926}) -- Infested Automa Core
    },
    pois = {
        POI({39526876, 60228721, 69745245}) -- Teleporter Locks (inside)
    }
}) -- Undulating Foliage

-------------------------------------------------------------------------------

map.nodes[42025181] = Treasure({
    quest = 65183,
    requires = ns.requirement.Item(188231),
    label = L['provis_cache'],
    note = L['provis_cache_note']
}) -- Provis Cache

map.nodes[48016641] = Treasure({
    quest = 65184,
    label = L['prying_eye_discovery'],
    note = L['multiple_spawns'] .. ' ' .. L['prying_eye_discovery_note'],
    rewards = {
        Achievement({id = 15508, criteria = 53293}), -- Fashion of the First Ones
        Item({item = 190096, quest = 65534}) -- Pocobold
    },
    pois = {POI({35244371, 34334431, 51767789})}
}) -- Prying Eye Discovery

map.nodes[53402570] = Treasure({
    quest = 65501,
    label = L['pulp_covered_relic'],
    note = L['multiple_spawns'],
    rewards = {
        Item({item = 189474, quest = 65397}) -- Schematic: Buzz
    },
    pois = {POI({41903400, 50304120, 52804580, 53402570, 64366347})}
}) -- Pulp-Covered Relic

map.nodes[60022583] = Treasure({
    quest = 65611,
    icon = 'chest_yw',
    requires = ns.requirement.Item(190197), -- Sandworn Chest Key
    label = L['sandworn_chest'],
    note = L['multiple_spawns'] .. ' ' .. L['sandworn_chest_note'],
    rewards = {
        Toy({item = 190734}) -- Makaris's Satchel of Mines
    },
    pois = {POI({60863786, 61401763, 63182603, 65972694})}
}) -- Sandworn Chest

-------------------------------------------------------------------------------
-------------------------------- PUZZLE CACHES --------------------------------
-------------------------------------------------------------------------------

local Puzzle = Class('PuzzleCache', ns.node.Node, {
    group = ns.groups.PUZZLE_CACHE,
    requires = ns.requirement.GarrisonTalent(1972),
    icon = 'star_chest_g',
    scale = 1.2
})

map.nodes[38546364] = Puzzle({quest = 65094, label = L['cache_cantaric']})
map.nodes[43662152] = Puzzle({quest = 65094, label = L['cache_cantaric']})
map.nodes[44229011] = Puzzle({quest = 65323, label = L['cache_cantaric']})
map.nodes[44767608] = Puzzle({quest = 65323, label = L['cache_cantaric']})
map.nodes[47504622] = Puzzle({quest = 65323, label = L['cache_cantaric']})
map.nodes[48628747] = Puzzle({quest = 65318, label = L['cache_cantaric']})
map.nodes[52984558] = Puzzle({quest = 65094, label = L['cache_cantaric']}) -- 65418 65416
map.nodes[54964798] = Puzzle({quest = 65318, label = L['cache_cantaric']})
map.nodes[55977960] = Puzzle({quest = 65318, label = L['cache_cantaric']})
map.nodes[65674096] = Puzzle({quest = 65094, label = L['cache_cantaric']}) -- 65418 65406

map.nodes[36475646] = Puzzle({quest = 65322, label = L['cache_fugueal']})
map.nodes[39184665] = Puzzle({quest = 65322, label = L['cache_fugueal']})
map.nodes[42236875] = Puzzle({quest = 65322, label = L['cache_fugueal']})
map.nodes[44303093] = Puzzle({quest = 65317, label = L['cache_fugueal']})
map.nodes[46036461] = Puzzle({quest = 65093, label = L['cache_fugueal']})
map.nodes[47117719] = Puzzle({quest = 65093, label = L['cache_fugueal']})
map.nodes[47603910] = Puzzle({quest = 65317, label = L['cache_fugueal']})
map.nodes[57486576] = Puzzle({quest = 65093, label = L['cache_fugueal']})
map.nodes[59712290] = Puzzle({quest = 65317, label = L['cache_fugueal']})
map.nodes[63103738] = Puzzle({quest = 65093, label = L['cache_fugueal']})

map.nodes[33785427] = Puzzle({quest = 65321, label = L['cache_glissandian']})
map.nodes[39937284] = Puzzle({quest = 65321, label = L['cache_glissandian']})
map.nodes[41843130] = Puzzle({quest = 65092, label = L['cache_glissandian']})
map.nodes[44635053] = Puzzle({quest = 65321, label = L['cache_glissandian']})
map.nodes[45069412] = Puzzle({quest = 65316, label = L['cache_glissandian']})
map.nodes[51282573] = Puzzle({quest = 65412, label = L['cache_glissandian']}) -- 65418
map.nodes[54264279] = Puzzle({quest = 65092, label = L['cache_glissandian']})
map.nodes[56008416] = Puzzle({quest = 65316, label = L['cache_glissandian']})
map.nodes[56636138] = Puzzle({quest = 65316, label = L['cache_glissandian']})
map.nodes[58893634] = Puzzle({quest = 65092, label = L['cache_glissandian']})

map.nodes[35825908] = Puzzle({quest = 65315, label = L['cache_mezzonic']})
map.nodes[38377037] = Puzzle({quest = 65091, label = L['cache_mezzonic']})
map.nodes[38503543] = Puzzle({quest = 65320, label = L['cache_mezzonic']})
map.nodes[39346043] = Puzzle({quest = 65091, label = L['cache_mezzonic']})
map.nodes[43624033] = Puzzle({quest = 65320, label = L['cache_mezzonic']})
map.nodes[49953046] = Puzzle({quest = 65320, label = L['cache_mezzonic']})
map.nodes[52347202] = Puzzle({quest = 65091, label = L['cache_mezzonic']})
map.nodes[55675002] = Puzzle({quest = 65091, label = L['cache_mezzonic']})
map.nodes[57863165] = Puzzle({quest = 65315, label = L['cache_mezzonic']})
map.nodes[64695282] = Puzzle({quest = 65315, label = L['cache_mezzonic']})

map.nodes[32055258] = Puzzle({quest = 64972, label = L['cache_toccatian']}) -- 65418 65402
map.nodes[34606880] = Puzzle({quest = 64972, label = L['cache_toccatian']})
map.nodes[37014645] = Puzzle({quest = 64972, label = L['cache_toccatian']})
map.nodes[46826698] = Puzzle({quest = 64972, label = L['cache_toccatian']})
map.nodes[52435706] = Puzzle({quest = 65314, label = L['cache_toccatian']})
map.nodes[53258687] = Puzzle({quest = 65314, label = L['cache_toccatian']})
map.nodes[62817394] = Puzzle({quest = 65314, label = L['cache_toccatian']})
map.nodes[64286332] = Puzzle({quest = 65319, label = L['cache_toccatian']})
map.nodes[65594762] = Puzzle({quest = 65319, label = L['cache_toccatian']})
map.nodes[67812744] = Puzzle({quest = 65319, label = L['cache_toccatian']})

-------------------------------------------------------------------------------
-------------------------------- CYPHER CACHES --------------------------------
-------------------------------------------------------------------------------

-- Treasures that give 2x cyphers and flip no quest id
-- quest=65115?

local Cache = Class('CypherCache', ns.node.Node, {
    group = ns.groups.ZERETH_CACHE,
    icon = 'chest_gy',
    scale = 0.8
})

local AVIAN_NEST = Cache({label = L['cache_avian_nest']})
local CYPHER_BOUND = Cache({label = L['cache_cypher_bound']})
local DISCARDED_AUTOMA = Cache({label = L['cache_discarded_automa']})
local FORGOTTEN_VAULT = Cache({label = L['cache_forgotten_vault']})
local MAWSWORN_SUPPLY = Cache({
    label = L['cache_mawsworn_supply'],
    rewards = {
        Mount({item = 190766, id = 1585}) -- Spectral Mawrat's Tail
    }
})
local TARACHNID_EGGS = Cache({label = L['cache_tarachnid_eggs']})

map.nodes[35495205] = AVIAN_NEST
map.nodes[40455663] = AVIAN_NEST
map.nodes[40685050] = AVIAN_NEST
map.nodes[42327311] = AVIAN_NEST
map.nodes[43156516] = AVIAN_NEST
map.nodes[43274369] = AVIAN_NEST
map.nodes[44194279] = AVIAN_NEST
map.nodes[48196646] = AVIAN_NEST
map.nodes[49556534] = AVIAN_NEST
map.nodes[51106454] = AVIAN_NEST
map.nodes[54298169] = AVIAN_NEST
map.nodes[54825835] = AVIAN_NEST
map.nodes[55185594] = AVIAN_NEST
map.nodes[56647484] = AVIAN_NEST
map.nodes[59106467] = AVIAN_NEST
map.nodes[62004200] = AVIAN_NEST
map.nodes[66004281] = AVIAN_NEST
map.nodes[76305020] = AVIAN_NEST
map.nodes[76895037] = AVIAN_NEST

map.nodes[36104309] = CYPHER_BOUND
map.nodes[37853246] = CYPHER_BOUND
map.nodes[38044543] = CYPHER_BOUND
map.nodes[38113112] = CYPHER_BOUND
map.nodes[38382956] = CYPHER_BOUND
map.nodes[38464188] = CYPHER_BOUND
map.nodes[39154226] = CYPHER_BOUND
map.nodes[39835646] = CYPHER_BOUND
map.nodes[42627646] = CYPHER_BOUND
map.nodes[42792135] = CYPHER_BOUND
map.nodes[43158972] = CYPHER_BOUND
map.nodes[44682237] = CYPHER_BOUND
map.nodes[44815079] = CYPHER_BOUND
map.nodes[45393141] = CYPHER_BOUND
map.nodes[47044529] = CYPHER_BOUND
map.nodes[47702634] = CYPHER_BOUND
map.nodes[47766683] = CYPHER_BOUND
map.nodes[48976532] = CYPHER_BOUND
map.nodes[48993205] = CYPHER_BOUND
map.nodes[49606573] = CYPHER_BOUND
map.nodes[49970368] = CYPHER_BOUND
map.nodes[50544680] = CYPHER_BOUND
map.nodes[51914364] = CYPHER_BOUND
map.nodes[52045296] = CYPHER_BOUND
map.nodes[52075444] = CYPHER_BOUND
map.nodes[52456163] = CYPHER_BOUND
map.nodes[52707519] = CYPHER_BOUND
map.nodes[52895864] = CYPHER_BOUND
map.nodes[53066373] = CYPHER_BOUND
map.nodes[53469408] = CYPHER_BOUND
map.nodes[54027253] = CYPHER_BOUND
map.nodes[54247629] = CYPHER_BOUND
map.nodes[54326958] = CYPHER_BOUND
map.nodes[55545570] = CYPHER_BOUND
map.nodes[57198183] = CYPHER_BOUND
map.nodes[58462026] = CYPHER_BOUND
map.nodes[58885274] = CYPHER_BOUND
map.nodes[59326420] = CYPHER_BOUND
map.nodes[59603260] = CYPHER_BOUND
map.nodes[59777940] = CYPHER_BOUND
map.nodes[60866960] = CYPHER_BOUND
map.nodes[61444816] = CYPHER_BOUND
map.nodes[62931954] = CYPHER_BOUND
map.nodes[63386843] = CYPHER_BOUND
map.nodes[65553675] = CYPHER_BOUND
map.nodes[66843569] = CYPHER_BOUND
map.nodes[77574508] = CYPHER_BOUND
map.nodes[77934573] = CYPHER_BOUND

map.nodes[40657591] = DISCARDED_AUTOMA
map.nodes[44089028] = DISCARDED_AUTOMA
map.nodes[48834480] = DISCARDED_AUTOMA
map.nodes[52344688] = DISCARDED_AUTOMA
map.nodes[53958854] = DISCARDED_AUTOMA
map.nodes[58966093] = DISCARDED_AUTOMA
map.nodes[59625113] = DISCARDED_AUTOMA
map.nodes[65764042] = DISCARDED_AUTOMA
map.nodes[67604043] = DISCARDED_AUTOMA
map.nodes[70013420] = DISCARDED_AUTOMA

map.nodes[36707142] = FORGOTTEN_VAULT
map.nodes[40434117] = FORGOTTEN_VAULT
map.nodes[41196109] = FORGOTTEN_VAULT
map.nodes[46459579] = FORGOTTEN_VAULT
map.nodes[46854450] = FORGOTTEN_VAULT
map.nodes[48891010] = FORGOTTEN_VAULT
map.nodes[49567522] = FORGOTTEN_VAULT
map.nodes[50559346] = FORGOTTEN_VAULT
map.nodes[50632668] = FORGOTTEN_VAULT
map.nodes[51177705] = FORGOTTEN_VAULT
map.nodes[52002941] = FORGOTTEN_VAULT
map.nodes[52315560] = FORGOTTEN_VAULT
map.nodes[53875975] = FORGOTTEN_VAULT
map.nodes[56542540] = FORGOTTEN_VAULT
map.nodes[58582110] = FORGOTTEN_VAULT
map.nodes[58585707] = FORGOTTEN_VAULT
map.nodes[65236419] = FORGOTTEN_VAULT
map.nodes[69083683] = FORGOTTEN_VAULT
map.nodes[75766263] = FORGOTTEN_VAULT
map.nodes[78215435] = FORGOTTEN_VAULT

map.nodes[45820524] = MAWSWORN_SUPPLY
map.nodes[47394352] = MAWSWORN_SUPPLY
map.nodes[57562297] = MAWSWORN_SUPPLY
map.nodes[58444036] = MAWSWORN_SUPPLY
map.nodes[59841661] = MAWSWORN_SUPPLY
map.nodes[60963061] = MAWSWORN_SUPPLY
map.nodes[62952498] = MAWSWORN_SUPPLY

map.nodes[54253357] = TARACHNID_EGGS
map.nodes[55263288] = TARACHNID_EGGS

-------------------------------------------------------------------------------

microd.nodes[62764399] = Cache({
    label = L['cache_cypher_bound'],
    parent = map.id
})

-------------------------------------------------------------------------------
----------------------------- PROTOFORM SCHEMATICS ----------------------------
-------------------------------------------------------------------------------

local PetSchematic = Class('PetSchematic', ns.node.Item, {
    sublabel = '{spell:366368}',
    icon = 132599,
    group = ns.groups.PROTOFORM_SCHEMATICS
})

-------------------------------------------------------------------------------

map.nodes[78175317] = PetSchematic({
    id = 189418,
    quest = 65327,
    note = L['schematic_ambystan_darter_note']
}) -- Ambystan Darter

map.nodes[61234258] = PetSchematic({
    id = 189434,
    quest = 65332,
    note = L['schematic_fierce_scarabid_note']
}) -- Fierce Scarabid

map.nodes[58407440] = PetSchematic({
    id = 189444,
    quest = 65357,
    note = L['schematic_leaping_leporid_note']
}) -- Leaping Leporid

map.nodes[28135001] = PetSchematic({
    id = 189445,
    quest = 65358,
    note = L['schematic_microlicid_note']
}) -- Microlicid

map.nodes[53777246] = PetSchematic({
    id = 189435,
    quest = 65333,
    note = L['in_cave'] .. '\n\n' .. L['schematic_treasure_pet_note']
}) -- Multichicken

-- Waiting for access to the Rondure Alcove on live, which I could not access on PTR
-- map.nodes[] = PetSchematic({
--     id = 189440,
--     quest = 65348,
--     note = L['schematic_omnipotential_core_note']
-- }) -- Omnipotential Core

map.nodes[52237533] = PetSchematic({
    id = 189442,
    quest = 65354,
    note = L['schematic_prototickles_note']
}) -- Prototickles

map.nodes[77605900] = PetSchematic({
    id = 189441,
    quest = 65351,
    note = L['schematic_resonant_echo_note'],
    pois = {POI({58608990, 77404530, 77605900, 77606040, 78205440, 78305310})}
}) -- Resonant Echo

map.nodes[57837783] = PetSchematic({
    id = 189446,
    quest = 65359,
    note = L['schematic_shelly_note'],
    pois = {POI({59328128})}
}) -- Shelly

map.nodes[83215337] = PetSchematic({
    id = 189437,
    quest = 65336,
    note = L['schematic_stabilized_geomental_note']
}) -- Stabilized Geomental

map.nodes[67223261] = PetSchematic({
    id = 189443,
    quest = 65355,
    note = L['schematic_terror_jelly_note']
}) -- Terror Jelly

esper.nodes[74745037] = PetSchematic({
    id = 189448,
    quest = 65361,
    parent = {id = map.id, pois = {POI({55755347})}},
    note = L['schematic_tunneling_vombata_note']
}) -- Tunneling Vombata

map.nodes[34224865] = PetSchematic({
    id = 189436,
    quest = 65334,
    note = L['schematic_violent_poultrid_note']
}) -- Violent Poultrid

-- Currently no fallback "Protoform Schematic" object for this one, it will always be
-- obtained from the Library Vault treasure even if you have not unlocked the pet
-- synthesizer yet.
-- map.nodes[] = PetSchematic({
--     id = 189447,
--     quest = 65360,
--     note = L['schematic_viperid_menace_note']
-- }) -- Viperid Menace

-------------------------------------------------------------------------------

local MountSchematic = Class('MountSchematic', ns.node.Item, {
    sublabel = '{spell:366367}',
    icon = 134060,
    group = ns.groups.PROTOFORM_SCHEMATICS
})

-------------------------------------------------------------------------------

map.nodes[36947826] = MountSchematic({
    id = 189478,
    quest = 65401,
    note = L['schematic_treasure_mount_note']
}) -- Adorned Vombata

map.nodes[34986475] = MountSchematic({
    id = 189462,
    quest = 65385,
    note = L['schematic_bronze_helicid_note']
}) -- Bronze Helicid

gpose.nodes[48974050] = MountSchematic({
    id = 189473,
    quest = 65396,
    parent = {id = map.id, pois = {POI({50543218})}},
    note = L['schematic_bronzewing_vespoid_note']
}) -- Bronzewing Vespoid

map.nodes[52804580] = MountSchematic({
    id = 189474,
    quest = 65397,
    note = L['schematic_buzz_note'] .. ' ' .. L['multiple_spawns'],
    pois = {POI({41903400, 50304120, 52804580, 53402570, 64366347})}
}) -- Buzz

-- map.nodes[] = MountSchematic({
--     id = 189476,
--     quest = 65399,
--     note = L['schematic_curious_crystalsniffer_note']
-- }) -- Curious Crystalsniffer

map.nodes[64223562] = MountSchematic({
    id = 189477,
    quest = 65400,
    note = L['schematic_darkened_vombata_note']
}) -- Darkened Vombata

map.nodes[70212856] = MountSchematic({
    id = 189457,
    quest = 65380,
    note = L['schematic_deathrunner_note']
}) -- Deathrunner

map.nodes[62024352] = MountSchematic({
    id = 189458,
    quest = 65381,
    note = L['schematic_desertwing_hunter_note']
}) -- Desertwing Hunter

map.nodes[53302560] = MountSchematic({
    id = 189475,
    quest = 65398,
    note = L['schematic_forged_spiteflyer_note']
}) -- Forged Spiteflyer

map.nodes[31485032] = MountSchematic({
    id = 189465,
    quest = 65388,
    note = L['schematic_genesis_crawler_note']
}) -- Genesis Crawler

map.nodes[76125219] = MountSchematic({
    id = 189468,
    quest = 65391,
    note = L['schematic_goldplate_bufonid_note'],
    pois = {
        POI({
            49777243, 49817585, 51087420, 51857585, 74666083, 75234631,
            76125219, 76704651, 77054511, 77245268, 78734687, 78864567,
            79355986, 79674548, 79784714, 79845938, 80304549, 80435734,
            80694698, 80965840
        }) -- Accelerated Bufonid
    }
}) -- Goldplate Bufonid

map.nodes[53166386] = MountSchematic({
    id = 190585,
    quest = 65680,
    note = L['in_cave'] .. ' ' .. L['schematic_heartbond_lupine_note']
}) -- Heartbond Lupine

-- map.nodes[] = MountSchematic({
--     id = 189467,
--     quest = 65390,
--     note = L['schematic_ineffable_skitterer_note']
-- }) -- Ineffable Skitterer

-- Wowhead claims this drops from Dune Dominance, need more confirmation
-- map.nodes[] = MountSchematic({
--     id = 189459,
--     quest = 65382,
--     note = L['schematic_mawdapted_raptora_note']
-- }) -- Mawdapted Raptora

map.nodes[33754950] = MountSchematic({
    id = 189455,
    quest = 65375,
    note = L['schematic_pale_regal_cervid_note']
}) -- Pale Regal Cervid

map.nodes[66966942] = MountSchematic({
    id = 189469,
    quest = 65393,
    note = L['schematic_treasure_mount_note']
}) -- Prototype Leaper

map.nodes[67394025] = MountSchematic({
    id = 189460,
    quest = 65383,
    note = L['schematic_raptora_swooper_note'],
    pois = {POI({65893620})}
}) -- Raptora Swooper

map.nodes[34756413] = MountSchematic({
    id = 189471,
    quest = 65394,
    note = L['schematic_russet_bufonid_note']
}) -- Russet Bufonid

map.nodes[47680954] = MountSchematic({
    id = 189464,
    quest = 65387,
    note = L['schematic_scarlet_helicid_note']
}) -- Scarlet Helicid

immo.nodes[45623070] = MountSchematic({
    id = 189461,
    quest = 65384,
    parent = map.id,
    note = L['schematic_serenade_note']
}) -- Serenade

map.nodes[60603052] = MountSchematic({
    id = 189456,
    quest = 65379,
    note = L['schematic_treasure_mount_note']
}) -- Sundered Zerethsteed

map.nodes[63032149] = MountSchematic({
    id = 189466,
    quest = 65389,
    note = L['schematic_tarachnid_creeper_note']
}) -- Tarachnid Creeper

-- Waiting for access to the Camber Alcove room
-- map.nodes[] = MountSchematic({
--     id = 189463,
--     quest = 65386,
--     note = L['schematic_prototype_fleetpod_note']
-- }) -- Unsuccessful Prototype Fleetpod

map.nodes[50312704] = MountSchematic({
    id = 189472,
    quest = 65395,
    note = L['schematic_vespoid_flutterer_note']
}) -- Vespoid Flutterer

-------------------------------------------------------------------------------
------------------------------ LORE CONCORDANCES ------------------------------
-------------------------------------------------------------------------------

-- NOTE: Quests may flip after you have read enough of them and are not necessarily
-- attached to individual objects. I wasn't initially marking them so we'll have to
-- learn more.

local Lore = Class('Concordance', ns.node.Node, {
    group = ns.groups.CONCORDANCES,
    icon = 4238797,
    note = L['concordance_note']
})

map.nodes[31775466] = Lore({quest = 65179, label = L['concordance_excitable']})
map.nodes[38953127] = Lore({quest = 65213, label = L['concordance_excitable']})
map.nodes[50405096] = Lore({quest = 65216, label = L['concordance_excitable']})
map.nodes[64616035] = Lore({quest = 65210, label = L['concordance_excitable']})
map.nodes[35037144] = Lore({quest = 65180, label = L['concordance_mercurial']})
map.nodes[39702572] = Lore({quest = 65214, label = L['concordance_mercurial']})
map.nodes[51579134] = Lore({quest = 65211, label = L['concordance_mercurial']})
map.nodes[64262397] = Lore({quest = 65217, label = L['concordance_mercurial']})
map.nodes[32196281] = Lore({quest = 64940, label = L['concordance_tranquil']})
map.nodes[38844857] = Lore({quest = 65212, label = L['concordance_tranquil']})
map.nodes[49367149] = Lore({quest = 65209, label = L['concordance_tranquil']})
map.nodes[60204707] = Lore({quest = 65215, label = L['concordance_tranquil']})

-------------------------------------------------------------------------------
--------------------------------- ECHOED JIRO ---------------------------------
-------------------------------------------------------------------------------

-- Creatian (Metrial talent)
-- Rank 1 = SW
-- Rank 2 = SE
-- Rank 3 = NW
-- Rank 4 = NE

local Jiro = Class('Jiro', ns.node.NPC, {
    group = ns.groups.ECHOED_JIROS,
    scale = 1.5,
    note = L['echoed_jiro_note']
})

local Creatii = Class('Creatii', Jiro,
    {spellID = 361831, icon = 'peg_gn', fgroup = 'creatii'})

local Genesii = Class('Genesii', Jiro,
    {spellID = 362022, icon = 'peg_bl', fgroup = 'genesii'})

local Nascii_ = Class('Nascii', Jiro,
    {spellID = 362023, icon = 'peg_rd', fgroup = 'nascii'})

local CREATIAN_SW = ns.requirement.GarrisonTalentRank(1976, 1)
local CREATIAN_SE = ns.requirement.GarrisonTalentRank(1976, 2)
local CREATIAN_NW = ns.requirement.GarrisonTalentRank(1976, 3)
local CREATIAN_NE = ns.requirement.GarrisonTalentRank(1976, 4)

--------------------------------- SOUTH-WEST ----------------------------------

map.nodes[40516076] = Creatii({id = 181571, requires = CREATIAN_SW})
map.nodes[43638656] = Creatii({id = 181571, requires = CREATIAN_SW})
map.nodes[34635635] = Genesii({id = 183262, requires = CREATIAN_SW})
map.nodes[46656747] = Genesii({id = 183262, requires = CREATIAN_SW})
map.nodes[33185415] = Nascii_({id = 183263, requires = CREATIAN_SW})
map.nodes[43806451] = Nascii_({id = 183263, requires = CREATIAN_SW})

--------------------------------- SOUTH-EAST ----------------------------------

map.nodes[52406156] = Creatii({id = 184939, requires = CREATIAN_SE})
map.nodes[54485576] = Creatii({id = 184939, requires = CREATIAN_SE})
map.nodes[49787650] = Genesii({id = 184940, requires = CREATIAN_SE})
map.nodes[63675613] = Genesii({id = 184940, requires = CREATIAN_SE})
map.nodes[54158396] = Nascii_({id = 184941, requires = CREATIAN_SE})
map.nodes[57116139] = Nascii_({id = 184941, requires = CREATIAN_SE})

--------------------------------- NORTH-WEST ----------------------------------

map.nodes[39144256] = Creatii({id = 184942, requires = CREATIAN_NW})
map.nodes[39995148] = Creatii({id = 184942, requires = CREATIAN_NW})
map.nodes[38313215] = Genesii({id = 184943, requires = CREATIAN_NW})
map.nodes[45363878] = Genesii({id = 184943, requires = CREATIAN_NW})
map.nodes[42744478] = Nascii_({id = 184944, requires = CREATIAN_NW})
map.nodes[44902980] = Nascii_({id = 184944, requires = CREATIAN_NW})

--------------------------------- NORTH-EAST ----------------------------------

map.nodes[53634382] = Creatii({id = 184945, requires = CREATIAN_NE})
map.nodes[56732609] = Creatii({id = 184945, requires = CREATIAN_NE})
map.nodes[52482899] = Genesii({id = 184946, requires = CREATIAN_NE})
map.nodes[63121948] = Genesii({id = 184946, requires = CREATIAN_NE})
map.nodes[59713736] = Nascii_({id = 184947, requires = CREATIAN_NE})
map.nodes[69743354] = Nascii_({id = 184947, requires = CREATIAN_NE})

-------------------------------------------------------------------------------
----------------------------- COMPLETING THE CODE -----------------------------
-------------------------------------------------------------------------------

local Code = Class('CodeCreature', Collectible, {
    icon = 348545,
    group = ns.groups.CODE_CREATURE,
    requires = ns.requirement.Item(187909)
})

map.nodes[41436244] = Code({
    id = 181352,
    rewards = {Achievement({id = 15211, criteria = 52577})}
}) -- Bitterbeak

map.nodes[38855862] = Code({
    id = 181349,
    rewards = {Achievement({id = 15211, criteria = 52576})}
}) -- Cipherclad

map.nodes[50645692] = Code({
    id = 181290,
    rewards = {Achievement({id = 15211, criteria = 52569})},
    pois = {
        Path({
            50705800, 51165859, 51305951, 51366073, 50866172, 50406290,
            50446398, 50496434, 50076425, 49646430, 49426392, 49126279,
            48816221, 48856169, 48496165, 48246080, 48235959, 47785988,
            47396044, 47165964, 46645907, 46495877, 46275786, 46645733,
            47345720, 47595752, 47965704, 48525661, 49185632, 49675570,
            50305514, 50475423, 51025395, 51305495, 51215621, 51365649,
            51415684, 50645692, 50705800
        })
    }
}) -- Corrupted Runehoarder

map.nodes[48651368] = Code({
    id = 184819,
    note = L['dominated_irregular_note'],
    rewards = {Achievement({id = 15211, criteria = 52568})},
    pois = {
        POI({
            45770851, 45920755, 46000761, 46091230, 46240788, 46411218,
            47011083, 47011084, 47121061, 47131060, 47300415, 47600388,
            48511204, 48511204, 48691370, 48721147, 48721147, 48761199,
            48761199, 48801185, 48801185, 48951382, 50791030, 50940999,
            51730691, 51730702
        })
    }
}) -- Dominated Irregular

map.nodes[63322636] = Code({
    id = 181208,
    rewards = {Achievement({id = 15211, criteria = 52567})}
}) -- Enchained Servitor

map.nodes[60756476] = Code({
    id = 181223,
    note = L['gaiagantic_note'],
    rewards = {Achievement({id = 15211, criteria = 52553})}
}) -- Gaiagantic

map.nodes[36143848] = Code({
    id = 181287,
    rewards = {Achievement({id = 15211, criteria = 52566})}
}) -- Gorged Runefeaster

map.nodes[60794826] = Code({
    id = 181292,
    note = L['misaligned_enforcer_note'],
    rewards = {Achievement({id = 15211, criteria = 52570})},
    pois = {
        Path({
            60794826, 60414778, 60044835, 59854737, 59444808, 58844786,
            58404850, 58044839, 57584924, 57145015, 56455059, 56425154,
            56745240, 57485211, 57565092, 57364975, 57474846, 56594804,
            56164806, 55514760, 55014653, 55084540, 55774507, 56244507,
            56274382, 55754314, 55754174, 55124093, 54364097, 53834108,
            53174181, 52414243, 51894163, 51514095, 52244053, 52683985,
            53274025, 53424132, 53194270, 53694330, 54134385, 54464543,
            55064588, 55494699, 56204691, 56994674, 57814679, 58214630,
            57964453, 58124430
        }), POI({58124430})
    }
}) -- Misaligned Enforcer

map.nodes[50669442] = Code({
    id = 181219,
    rewards = {Achievement({id = 15211, criteria = 52554})},
    pois = {POI({43609019, 45889522, 50669442, 52969310, 53709341})}
}) -- Moss-Choked Guardian

map.nodes[62816832] = Code({
    id = 179007,
    note = L['bygone_elemental_note'],
    rewards = {Achievement({id = 15211, criteria = {52552, 52565}})},
    pois = {
        POI({
            59397203, 60037679, 60587324, 60646548, 61036488, 61186714,
            61876864, 61996774, 62407295, 62597017, 62646830, 62987355,
            63177133, 63477140, 63927169
        })
    }
}) -- Overgrown Geomental

map.nodes[63225801] = Code({
    id = 181222,
    note = L['overcharged_vespoid_note'],
    rewards = {Achievement({id = 15211, criteria = 52606})},
    pois = {
        POI({
            63955769, 62205921, 62416022, 64616041, 64625862, 63225801,
            64015760, 64405861, 64415980
        })
    }
}) -- Over-charged Vespoid

map.nodes[39795203] = Code({
    id = 181344,
    rewards = {Achievement({id = 15211, criteria = 52575})}
}) -- Runefur

map.nodes[50276015] = Code({
    id = 181294,
    rewards = {Achievement({id = 15211, criteria = 52572})}
}) -- Runegorged Bufonid

map.nodes[61855178] = Code({
    id = 181295,
    note = L['runethief_xylora_note'],
    rewards = {Achievement({id = 15211, criteria = 52574})},
    pois = {POI({60055152, 61805240, 61815261, 61855190, 64014961})}
}) -- Runethief Xy'lora

map.nodes[53567521] = Code({
    id = 178835,
    rewards = {Achievement({id = 15211, criteria = 52573})}
}) -- Sharpeye Collector

map.nodes[35066376] = Code({
    id = 181293,
    rewards = {Achievement({id = 15211, criteria = 52571})}
}) -- Suspicious Nesmin

map.nodes[45212191] = Code({
    id = 182798,
    rewards = {Achievement({id = 15211, criteria = 52686})}
}) -- Twisted Warpcrafter

-------------------------------------------------------------------------------
----------------------------- TALES OF THE EXILE ------------------------------
-------------------------------------------------------------------------------

local Tale = Class('Tale', ns.node.Collectible,
    {group = ns.groups.EXILE_TALES, icon = 4072784})

map.nodes[35755546] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53299})} -- Part 1
})
map.nodes[41796247] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53300})} -- Part 2
})
map.nodes[37544601] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53301})} -- Part 3
})
map.nodes[49827656] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53302})} -- Part 4
})
map.nodes[39033109] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53303})} -- Part 5
})
map.nodes[67422518] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53304})} -- Part 6
})
map.nodes[64833364] = Tale({
    rewards = {Achievement({id = 15509, criteria = 53305})} -- Part 7
})

-------------------------------------------------------------------------------
--------------------------- TRAVERSING THE SPHERES ----------------------------
-------------------------------------------------------------------------------

local Proto = Class('ProtoMaterial', ns.node.Collectible, {
    icon = 838813,
    group = ns.groups.PROTO_MATERIALS,
    requires = ns.requirement.Item(187908)
})

map.nodes[36735353] = Proto({
    icon = 134580,
    note = L['anima_charged_yolk_note'],
    rewards = {Achievement({id = 15229, criteria = 52612})}
}) -- Anima-charged Yolk

map.nodes[50007400] = Proto({
    icon = 132859,
    note = L['proto_material_zone_chance'],
    rewards = {Achievement({id = 15229, criteria = 52614})},
    pois = {
        POI({
            45507301, 46296840, 50007400, 51008500, 50837051, 52005600,
            53008400, 63003100
        })
    }
}) -- Empyrean Essence

map.nodes[50662947] = Proto({
    icon = 897131,
    note = L['energized_firmament_note'],
    rewards = {Achievement({id = 15229, criteria = 52617})},
    pois = {
        POI({
            48143016, 48842748, 49143379, 49192978, 49982844, 49992843,
            50452709, 50662947, 50842956, 51102949, 51292772, 51933010,
            52972907, 53133097
        })
    }
}) -- Energized Firmament

map.nodes[63446035] = Proto({
    icon = 3066347,
    note = L['honeycombed_lattice_note'],
    rewards = {Achievement({id = 15229, criteria = 52611})},
    pois = {POI({62285726, 62605728, 63446035, 63835714, 64255914, 64256046})}
}) -- Honeycombed Lattice

map.nodes[57802759] = Proto({
    icon = 134382,
    note = L['incorporeal_sand_note'],
    rewards = {Achievement({id = 15229, criteria = 52615})},
    pois = {
        POI({
            39193824, 41032531, 41934267, 42183341, 42932896, 43062981,
            43122789, 44813812, 45042846, 45132824, 50314468, 50474694,
            56833592, 57205120, 57802759, 58132516, 59082436, 59272455,
            59392534, 60233539, 62913145, 67422871, 69013318
        })
    }
}) -- Incorporeal Sand

map.nodes[59507360] = Proto({
    icon = 613602,
    note = L['pollinated_extraction_note'],
    rewards = {Achievement({id = 15229, criteria = 52610})},
    pois = {POI({56907630, 58607790, 59507360, 60717617, 61107330, 62826772})}
}) -- Pollinated Extraction

map.nodes[34324669] = Proto({
    icon = 463521,
    note = L['serene_pigment_note'],
    rewards = {Achievement({id = 15229, criteria = 53058})}
}) -- Serene Pigment

map.nodes[46306815] = Proto({
    icon = 2065561,
    note = L['proto_material_zone_chance'],
    rewards = {Achievement({id = 15229, criteria = 52613})},
    pois = {
        POI({
            35404428, 37397020, 45098347, 45483140, 45837107, 46306815,
            49037071, 50017243
        })
    }
}) -- Unstable Agitant

map.nodes[48365949] = Proto({
    icon = 796637,
    note = L['volatile_precursor_note'],
    rewards = {Achievement({id = 15229, criteria = 52616})}
}) -- Volatile Precursor

map.nodes[32814036] = Proto({
    icon = 132837,
    note = L['wayward_essence_note'],
    rewards = {Achievement({id = 15229, criteria = 53057})}
}) -- Wayward Essence

-------------------------------------------------------------------------------
------------------------------- PATIENT BUFONID -------------------------------
-------------------------------------------------------------------------------

local Bufonid = Class('Bufonid', Collectible, {
    id = 185798,
    icon = 3778581,
    quest = {65727, 65725, 65726, 65728, 65729, 65730, 65731}, -- daily: 65724
    questCount = true,
    rewards = {Mount({item = 188808, id = 1569})}
})

function Bufonid.getters:note()
    local function status(i)
        if C_QuestLog.IsQuestFlaggedCompleted(self.quest[i]) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L['patient_bufonid_note']
    note = note .. '\n\n' .. status(1) .. ' ' .. L['patient_bufonid_note_day1']
    note = note .. '\n\n' .. status(2) .. ' ' .. L['patient_bufonid_note_day2']
    note = note .. '\n\n' .. status(3) .. ' ' .. L['patient_bufonid_note_day3']
    note = note .. '\n\n' .. status(4) .. ' ' .. L['patient_bufonid_note_day4']
    note = note .. '\n\n' .. status(5) .. ' ' .. L['patient_bufonid_note_day5']
    note = note .. '\n\n' .. status(6) .. ' ' .. L['patient_bufonid_note_day6']
    note = note .. '\n\n' .. status(7) .. ' ' .. L['patient_bufonid_note_day7']
    return note
end

map.nodes[34506548] = Bufonid()
