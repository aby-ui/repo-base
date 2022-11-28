-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local Collectible = ns.node.Collectible
local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Flag = ns.node.Flag
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure
-- local PetBattle = ns.node.PetBattle

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
-- local Mount = ns.reward.Mount
local Pet = ns.reward.Pet

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2022, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[63695509] = Rare({ -- required 67030
    id = 193132,
    quest = 69838,
    note = L['in_cave'],
    rewards = {Achievement({id = 16676, criteria = 56045})}
}) -- Amethyzar the Glittering

map.nodes[58634021] = Rare({
    id = 187945,
    quest = nil,
    rewards = {
        Achievement({id = 16676, criteria = 56035}),
        Item({item = 197098, quest = 69299}) -- Highland Drake: Finned Back
    }
}) -- Anhydros the Tidetaker

map.nodes[54517174] = Rare({ -- review -- required 67030
    id = 193135,
    quest = 69839,
    rewards = {Achievement({id = 16676, criteria = 56041})}
}) -- Azra's Prized Peony

map.nodes[28635882] = Rare({ -- review
    id = 190986,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56059})}
}) -- Battlehorn Pyrhus

map.nodes[52916529] = Rare({
    id = 192738,
    quest = nil,
    note = L['brundin_the_dragonbane_note'],
    rewards = {Achievement({id = 16676, criteria = 56038})},
    pois = {
        Path({
            52916529, 53126596, 52996668, 51666681, 49796541, 48726550,
            48326651, 47886773, 47946932, 47937123, 46887338, 46507372,
            45637384, 43397311, 42667232, 42037065, 41256910, 40906872,
            39516811, 35897202, 33547067, 33146983
        })
    }
}) -- Brundin the Dragonbane (Qalashi War Party)

map.nodes[26847642] = Rare({
    id = 193198,
    quest = 72127,
    rewards = {Achievement({id = 16676, criteria = 56050})}
}) -- Captain Lancer

map.nodes[26285788] = Rare({
    id = 186783,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56056})},
    pois = {
        Path({
            26285788, 26545827, 25985955, 26315995, 26585932, 27316007,
            27396026, 29306229
        })
    }
}) -- Cauldronbearer Blakor

map.nodes[29485272] = Rare({ -- review
    id = 190991,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56060})}
}) -- Char

map.nodes[31785474] = Rare({ -- review -- required 67030
    id = 190985,
    quest = nil,
    rewards = {
        Achievement({id = 16676, criteria = 56053}),
        Achievement({id = 16496, criteria = 55867})
    }
}) -- Death's Shadow

map.nodes[60204535] = Rare({
    id = 193217,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56039})},
    pois = {
        Path({
            47267713, 48927495, 50076925, 50996592, 51946323, 52556211,
            53726071, 54705959, 55135843, 55195735, 54725544, 53785350,
            52485131, 51054858, 49934614, 49384420, 49114158, 49643971,
            50543803, 52013559, 53703482, 55473549, 58333718, 59883845,
            60373937, 60524059, 60414206, 60204535, 59984844, 60105101,
            60435274, 61375479, 63175769, 64575919, 66316022, 67826035,
            68615989, 69305901, 69425829, 68855485, 68285247, 67565009,
            67344710, 67924499, 68794338, 69324289, 70294270, 71674307,
            72304359, 73174490, 73394565, 73214666, 72874714, 71474819,
            70444873, 69284969, 68655076, 68265244
        })
    }
}) -- Drakewing

map.nodes[21626478] = Rare({ -- review
    id = 193134,
    quest = 72128,
    rewards = {Achievement({id = 16676, criteria = 56049})}
}) -- Enkine the Voracious

map.nodes[33127632] = Rare({
    id = 193154,
    quest = 72130,
    rewards = {Achievement({id = 16676, criteria = 56048})}
}) -- Forgotten Gryphon

map.nodes[52345829] = Rare({ -- review
    id = 196056,
    quest = 70718,
    rewards = {Achievement({id = 16676, criteria = 56033})}
}) -- Gushgut the Beaksinker

map.nodes[43007465] = Rare({ -- review
    id = 193263,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56037})}
}) -- Helmet Missingway

map.nodes[20001800] = Rare({ -- review
    id = 193266,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56055})}
}) -- Lepidoralia the Resplendent

map.nodes[39596353] = Rare({ -- review -- required 67030
    id = 186827,
    quest = 70979,
    rewards = {Achievement({id = 16676, criteria = 56046})}
}) -- Magmaton

map.nodes[22207649] = Rare({ -- review -- required 67030
    id = 193152,
    quest = 69848,
    rewards = {Achievement({id = 16676, criteria = 56047})}
}) -- Massive Magmashell

map.nodes[56004592] = Rare({
    id = 193256,
    quest = nil,
    rewards = {
        Achievement({id = 16676, criteria = 56034}),
        Item({item = 200236, note = L['trinket']}) -- Memory of Nulltheria
    }
}) -- Nulltheria the Void Gazer

map.nodes[81634820] = Rare({ -- review -- required 67030
    id = 193118,
    quest = 70983,
    rewards = {Achievement({id = 16676, criteria = 56043})}
}) -- O'nank Shorescour

map.nodes[64926956] = Rare({ -- review
    id = 192362,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56051})}
}) -- Possessive Hornswog

map.nodes[30226045] = Rare({ -- review
    id = 193232,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56061})}
}) -- Rasnar the War Ender

map.nodes[25366070] = Rare({
    id = 187598,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56057})}
}) -- Rohzor Forgesmash

map.nodes[23755734] = Rare({ -- review -- required 67030
    id = 189822,
    quest = nil,
    note = L['shasith_note'],
    rewards = {
        Achievement({id = 16676, criteria = 56054}),
        Achievement({id = 16496, criteria = 55869})
    },
    pois = {POI({27226096})} -- Entrance
}) -- Shas'ith

map.nodes[42892832] = Rare({
    id = 193181,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 56036})},
    pois = {
        Path({
            47741892, 48481794, 48731762, 48851677, 48681620, 48321588,
            48011600, 47831641, 47761746, 47741892, 47222080, 47242098,
            47102230, 46842285, 46482317, 45862342, 43072780, 42892832,
            42743062, 42533165, 42243219, 40893341, 40363406, 40043547,
            40263915, 40193965, 39734056, 39264098, 38614106, 38324066,
            38143991, 38243859, 38563789, 39213679, 40043547
        })
    }
}) -- Skewersnout

map.nodes[69486653] = Rare({ -- review -- required 67030
    id = 193120,
    quest = 69668,
    rewards = {Achievement({id = 16676, criteria = 56044})}
}) -- Smogswog the Firebreather

map.nodes[78514999] = Rare({ -- required 67030
    id = 193228,
    quest = 69874,
    rewards = {Achievement({id = 16676, criteria = 56042})},
    pois = {Path({78825133, 78575081, 78475028, 78514999, 78684964, 78674926})}
}) -- Snappy (Gorjo the Crab Shackler)

map.nodes[45453540] = Rare({
    id = 193148,
    quest = 69841,
    rewards = {
        Achievement({id = 16676, criteria = 56040}),
        Item({item = 197111, quest = 69312}) -- Highland Drake: Maned Head
    }
}) -- Thunderous Matriarch

map.nodes[33525576] = Rare({
    id = 187886,
    quest = nil,
    note = L['in_small_cave'],
    rewards = {Achievement({id = 16676, criteria = 56058})}
}) -- Turboris

map.nodes[18002200] = Rare({ -- review
    id = 186859,
    quest = 70763,
    rewards = {Achievement({id = 16676, criteria = 56052})}
}) -- Worldcarver A'tir

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- https://www.wowhead.com/beta/achievement=16297/treasures-of-the-waking-shores#comments

map.nodes[40454136] = Treasure({ -- required 65537, 70599, 70527
    quest = 70599,
    requires = ns.requirement.Item(199061), -- A Guide to Rare Fish
    note = L['bubble_drifter_note'],
    rewards = {
        Achievement({id = 16297, criteria = 54699}),
        Pet({item = 193852, id = 3269}) -- Azure Frillfish
    }
}) -- Bubble Drifter

map.nodes[69314658] = Treasure({
    quest = 70346,
    rewards = {Achievement({id = 16297, criteria = 54702})}
}) -- Dead Man's Chestplate

map.nodes[20002200] = Treasure({
    quest = nil,
    rewards = {Achievement({id = 16297, criteria = 55403})}
}) -- Misty Treasure Chest

map.nodes[22002200] = Treasure({ -- required 72021, 72020
    quest = nil,
    note = L['onyx_gem_cluster_note'],
    requires = ns.requirement.Item(200738), -- Onyx Gem Cluster Map
    rewards = {Achievement({id = 16297, criteria = 55448})},
    pois = {POI({46948289})}
}) -- Onyx Gem Cluster

map.nodes[48865180] = Treasure({
    quest = 70600, -- 70409
    note = L['replica_dragon_goblet_note'],
    requires = ns.requirement.Item(198854), -- Archeologist Artifact Notes
    rewards = {Achievement({id = 16297, criteria = 54698})},
    pois = {POI({75423397})}
}) -- Replica Dragon Goblet

map.nodes[24002200] = Treasure({ -- required 70528, 70598
    quest = nil,
    requires = ns.requirement.Item(199062), -- Ruby Gem Cluster Map
    rewards = {Achievement({id = 16297, criteria = 54713})}
}) -- Ruby Gem Cluster

map.nodes[48488518] = Treasure({
    quest = 70378,
    rewards = {Achievement({id = 16297, criteria = 54703})}
}) -- Torn Riding Pack

map.nodes[46713121] = Treasure({
    quest = 70345,
    rewards = {Achievement({id = 16297, criteria = 54701})}
}) -- Yennu's Kite

-------------------------------------------------------------------------------

map.nodes[64926959] = Treasure({
    quest = 67048,
    label = L['hidden_hornswog_hoard'],
    note = L['hidden_hornswog_hoard_note'],
    rewards = {
        Pet({item = 199916, id = 3365}) -- Roseate Hopper
    },
    pois = {POI({66165529, 39638468, 47728360})}
}) -- Hidden Hornswog Hoard

map.nodes[43156737] = Treasure({
    quest = nil,
    requires = ns.requirement.Item(191122), -- Fullsails Supply Chest Key
    label = L['fullsails_supply_chest']
}) -- Fullsails Supply Chest

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

map.nodes[57655483] = Dragonglyph({rewards = {Achievement({id = 15991})}}) -- Dragon Glyphs: Crumbling Life Archway
map.nodes[69184623] = Dragonglyph({rewards = {Achievement({id = 16051})}}) -- Dragon Glyphs: Dragonheart Outpost
map.nodes[58097858] = Dragonglyph({rewards = {Achievement({id = 16669})}}) -- Dragon Glyphs: Flashfrost Enclave
map.nodes[74375751] = Dragonglyph({rewards = {Achievement({id = 16668})}}) -- Dragon Glyphs: Life-Binder Observatory Rostrum
map.nodes[52601712] = Dragonglyph({rewards = {Achievement({id = 15990})}}) -- Dragon Glyphs: Life-Binder Observatory Tower
map.nodes[40987191] = Dragonglyph({rewards = {Achievement({id = 15987})}}) -- Dragon Glyphs: Obsidian Bulwark
map.nodes[21915141] = Dragonglyph({rewards = {Achievement({id = 16053})}}) -- Dragon Glyphs: Obsidian Throne
map.nodes[54437422] = Dragonglyph({rewards = {Achievement({id = 15988})}}) -- Dragon Glyphs: Ruby Life Pools
map.nodes[48828664] = Dragonglyph({rewards = {Achievement({id = 16670})}}) -- Dragon Glyphs: Rubyscale Outpost (Ohn'ahran Plains)
map.nodes[73212051] = Dragonglyph({rewards = {Achievement({id = 16052})}}) -- Dragon Glyphs: Scalecracker Peak
map.nodes[75265707] = Dragonglyph({rewards = {Achievement({id = 15985})}}) -- Dragon Glyphs: Skytop Observatory
map.nodes[46395207] = Dragonglyph({rewards = {Achievement({id = 15989})}}) -- Dragon Glyphs: The Overflowing Spring
map.nodes[74943750] = Dragonglyph({rewards = {Achievement({id = 15986})}}) -- Dragon Glyphs: Wingrest Embassy

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

map.nodes[23835308] = Flag({quest = 70826})
map.nodes[43976294] = Flag({quest = 70825})
map.nodes[54797412] = Flag({quest = 71204})
map.nodes[56534513] = Flag({quest = 70823})
map.nodes[73353884] = Flag({quest = 70824})

-------------------------------------------------------------------------------
------------------------------- SYMBOLS OF HOPE -------------------------------
-------------------------------------------------------------------------------

local Kite = Class('Kite', Collectible, {
    icon = 133837,
    label = '{npc:198118}',
    group = ns.groups.KITE
})

map.nodes[73193776] = Kite({
    quest = 72096,
    rewards = {Achievement({id = 16584, criteria = 55841})}
})
map.nodes[73035292] = Kite({
    quest = 72097,
    rewards = {Achievement({id = 16584, criteria = 55845})}
})
map.nodes[56735799] = Kite({
    quest = 72098,
    rewards = {Achievement({id = 16584, criteria = 55843})}
})
map.nodes[61698083] = Kite({
    quest = 72099,
    rewards = {Achievement({id = 16584, criteria = 55844})}
})
map.nodes[43556382] = Kite({
    quest = 72100,
    rewards = {Achievement({id = 16584, criteria = 55845})}
})
map.nodes[24048994] = Kite({
    quest = 72101,
    rewards = {Achievement({id = 16584, criteria = 55846})}
})
map.nodes[50275562] = Kite({
    quest = 72102,
    rewards = {Achievement({id = 16584, criteria = 55847})}
})
map.nodes[48863994] = Kite({
    quest = 72104,
    rewards = {Achievement({id = 16584, criteria = 55849})}
})
map.nodes[57124639] = Kite({
    quest = 72103,
    rewards = {Achievement({id = 16584, criteria = 55848})}
})
map.nodes[57011998] = Kite({
    quest = 72105,
    rewards = {Achievement({id = 16584, criteria = 55850})}
})

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[40674138] = Disturbeddirt()
map.nodes[44743555] = Disturbeddirt()
map.nodes[45468064] = Disturbeddirt()
map.nodes[47278699] = Disturbeddirt()
map.nodes[50073813] = Disturbeddirt()
map.nodes[50834912] = Disturbeddirt()
map.nodes[52354997] = Disturbeddirt()
map.nodes[54398542] = Disturbeddirt()
map.nodes[54895103] = Disturbeddirt()
map.nodes[57548174] = Disturbeddirt()
map.nodes[57858225] = Disturbeddirt()
map.nodes[58124968] = Disturbeddirt()
map.nodes[61815501] = Disturbeddirt()
map.nodes[70746975] = Disturbeddirt()
map.nodes[71863677] = Disturbeddirt()
map.nodes[75580798] = Disturbeddirt()
map.nodes[78502992] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[26628764] = Scoutpack()
map.nodes[41256689] = Scoutpack()
map.nodes[43345237] = Scoutpack()
map.nodes[44495926] = Scoutpack()
map.nodes[45663986] = Scoutpack()
map.nodes[51668253] = Scoutpack()
map.nodes[51824744] = Scoutpack()
map.nodes[52745025] = Scoutpack()
map.nodes[56857953] = Scoutpack()
map.nodes[58395561] = Scoutpack()
map.nodes[61886605] = Scoutpack()
map.nodes[66505198] = Scoutpack()
map.nodes[68225004] = Scoutpack()
map.nodes[82055012] = Scoutpack()

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

-- map.nodes[] = PetBattle({
--     id = 196264,
--     rewards = {Achievement({id = 16464, criteria = 55485})}
-- }) -- Haniko

-- map.nodes[] = PetBattle({
--     id = 189376,
--     rewards = {Achievement({id = 16464, criteria = 55488})}
-- }) -- Swog
