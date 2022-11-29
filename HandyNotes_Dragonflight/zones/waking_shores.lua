-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local BonusBoss = ns.node.BonusBoss
local Collectible = ns.node.Collectible
local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Flag = ns.node.Flag
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure
local PetBattle = ns.node.PetBattle

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
-- local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

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
        Achievement({id = 16496, criteria = 55867}) -- Obsidian Champion
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
    rewards = {
        Achievement({id = 16676, criteria = 56048}),
        Item({item = 200858, note = L['trinket']}) -- Plume of the Forgotten
    }
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

map.nodes[32225193] = Rare({ -- review
    id = 187306,
    quest = nil,
    rewards = {
        Achievement({id = 16676, criteria = 56988}),
        Achievement({id = 16496, criteria = 55868}) -- Obsidian Champion
    }
}) -- Morchok

map.nodes[56004592] = Rare({
    id = 193256,
    quest = nil,
    rewards = {
        Achievement({id = 16676, criteria = 56034}),
        Item({item = 200236, note = L['trinket']}) -- Memory of Nulltheria
    }
}) -- Nulltheria the Void Gazer

map.nodes[81485082] = Rare({ -- required 67030
    id = 193118,
    quest = 70983,
    rewards = {Achievement({id = 16676, criteria = 56043})},
    pois = {
        Path({
            79185296, 80015374, 80215387, 80445368, 80445260, 80555229,
            81385104, 81485082, 81465042, 81314977, 81254941, 81634857,
            81934819, 82554797, 82644782, 82614742
        }) -- 80415250
    }
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

map.nodes[46997332] = Rare({
    id = 193271,
    quest = 70719,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16676, criteria = 56989}),
        Item({item = 200689, note = L['ring']}) -- Rimetalon Band
    }
}) -- Shadeslash Trakken

map.nodes[23755734] = Rare({ -- review -- required 67030
    id = 189822,
    quest = nil,
    note = L['shasith_note'],
    rewards = {
        Achievement({id = 16676, criteria = 56054}),
        Achievement({id = 16496, criteria = 55869}) -- Obsidian Champion
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

map.nodes[24001800] = Rare({ -- review
    id = 193175,
    quest = nil,
    rewards = {Achievement({id = 16676, criteria = 57003})}
}) -- Slurpo, the Incredible Snail

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

map.nodes[30025534] = Rare({
    id = 186859,
    quest = 70763,
    note = L['worldcarver_atir_note'],
    rewards = {
        Achievement({id = 16676, criteria = 56052}),
        Transmog({item = 200213, slot = L['plate']}) -- Lava-Splattered Breastplate
    }
}) -- Worldcarver A'tir

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

map.nodes[54728225] = BonusBoss({
    id = 187209,
    quest = 72841,
    rewards = {
        Transmog({item = 200246, slot = L['staff']}), -- Lost Delving Lamp
        Item({item = 196991, quest = 69191}), -- Cliffside Wylderdrake: Black Horns
        Toy({item = 200198}) -- Primalist Prison
    }
}) -- Klozicc the Ascended

map.nodes[81133794] = BonusBoss({
    id = 184853,
    quest = 72843,
    note = L['in_small_cave'],
    rewards = {
        Item({item = 200445, note = L['neck']}) -- Lucky Hunting Charm
    }
}) -- Primal Scythid Queen

map.nodes[60598285] = BonusBoss({
    id = 193171,
    quest = 72850,
    rewards = {
        Transmog({item = 200208, slot = L['cloth']}) -- Cloud Coalescing Handwraps
    }
}) -- Terillod the Devout

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[40454136] = Treasure({ -- required 65537, 70599, 70527
    quest = 70599,
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Item(199061) -- A Guide to Rare Fish
    },
    note = L['bubble_drifter_note'],
    rewards = {
        Achievement({id = 16297, criteria = 54699}),
        Pet({item = 193852, id = 3269}) -- Azure Frillfish
    }
}) -- Bubble Drifter

map.nodes[69314658] = Treasure({
    quest = 70346,
    note = L['dead_mans_chestplate_note'],
    rewards = {
        Achievement({id = 16297, criteria = 54702}),
        Transmog({item = 202193, slot = L['cosmetic']}) -- Dead Man's Tunic
    }
}) -- Dead Man's Chestplate

map.nodes[58525302] = Treasure({
    quest = 65646,
    note = L['in_waterfall_cave'] .. ' ' .. L['misty_treasure_chest_note'],
    rewards = {
        Achievement({id = 16297, criteria = 55403}),
        Item({item = 202194, note = L['bag']}) -- Misty Satchel
    }
}) -- Misty Treasure Chest

map.nodes[29454699] = Treasure({
    quest = 72020,
    note = L['onyx_gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Item(200738) -- Onyx Gem Cluster Map
    },
    rewards = {
        Achievement({id = 16297, criteria = 55448}), --
        Item({item = 200867}) -- Glimmering Neltharite Cluster
    },
    pois = {POI({46948289})}
}) -- Onyx Gem Cluster

map.nodes[65804182] = Treasure({
    quest = 70600, -- 70409
    note = L['golden_dragon_goblet_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Item(198854) -- Archeologist Artifact Notes
    },
    rewards = {
        Achievement({id = 16297, criteria = 54698}), --
        Toy({item = 202019}) -- Golden Dragon Goblet
    },
    pois = {POI({77992943})}
}) -- Golden Dragon Goblet

map.nodes[61347079] = Treasure({
    quest = 70598,
    note = L['gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Item(199062) -- Ruby Gem Cluster Map
    },
    rewards = {
        Achievement({id = 16297, criteria = 54713}), --
        Item({item = 200864}) -- Glimmering Alexstraszite Cluster
    }
}) -- Ruby Gem Cluster

map.nodes[48488518] = Treasure({
    quest = 70378,
    rewards = {Achievement({id = 16297, criteria = 54703})}
}) -- Torn Riding Pack

map.nodes[46713121] = Treasure({
    quest = 70345,
    rewards = {
        Achievement({id = 16297, criteria = 54701}), --
        Toy({item = 202022}) -- Yennu's Kite
    }
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
map.nodes[46837960] = Disturbeddirt()
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
map.nodes[37859241] = Scoutpack()
map.nodes[38139017] = Scoutpack()
map.nodes[41256689] = Scoutpack()
map.nodes[43345237] = Scoutpack()
map.nodes[43506130] = Scoutpack({note = L['in_small_cave']})
map.nodes[44495926] = Scoutpack()
map.nodes[45663986] = Scoutpack()
map.nodes[46244006] = Scoutpack()
map.nodes[47164139] = Scoutpack()
map.nodes[47383898] = Scoutpack()
map.nodes[48134457] = Scoutpack()
map.nodes[51668253] = Scoutpack()
map.nodes[51824744] = Scoutpack()
map.nodes[52745025] = Scoutpack()
map.nodes[55887676] = Scoutpack()
map.nodes[56857953] = Scoutpack()
map.nodes[58395561] = Scoutpack()
map.nodes[59145368] = Scoutpack()
map.nodes[61886605] = Scoutpack()
map.nodes[66505198] = Scoutpack()
map.nodes[68225004] = Scoutpack()
map.nodes[82055012] = Scoutpack()

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[39028289] = PetBattle({
    id = 196264,
    rewards = {
        Achievement({id = 16464, criteria = 55485}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 4, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 4, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 4, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 4, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 4, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 4, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 4, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 4, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 4, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 4, oneline = true}) -- Undead
    }
}) -- Haniko

map.nodes[26239233] = PetBattle({
    id = 189376,
    rewards = {
        Achievement({id = 16464, criteria = 55488}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 8, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 8, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 8, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 8, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 8, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 8, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 8, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 8, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 8, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 8, oneline = true}) -- Undead
    }
}) -- Swog
