-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
-- local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local BonusBoss = ns.node.BonusBoss
-- local Collectible = ns.node.Collectible
local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Flag = ns.node.Flag
local PetBattle = ns.node.PetBattle
local PT = ns.node.ProfessionTreasures
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
-- local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2025, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[59075874] = Rare({
    id = 193664,
    quest = 69963,
    rewards = {Achievement({id = 16679, criteria = 56158})}
}) -- Ancient Protector

map.nodes[31097121] = Rare({ -- requirement ?
    id = 193128,
    quest = nil,
    note = L['blightpaw_note'],
    rewards = {Achievement({id = 16679, criteria = 56136})}
}) -- Blightpaw the Depraved

map.nodes[59847057] = Rare({ -- required 67030
    id = 193220,
    quest = 69868,
    rewards = {
        Achievement({id = 16679, criteria = 56149}),
        Transmog({item = 200138, slot = L['polearm']}) -- Ancient Dancer's Longspear
    }
}) -- Broodweaver Araznae

map.nodes[44886910] = Rare({
    id = 193658,
    quest = 69962,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 16679, criteria = 56156}),
        Transmog({item = 199020, slot = L['gun']}) -- Drake Race Starting Rifle of the Fireflash
    },
    pois = {POI({44616780})} -- Entrance
}) -- Corrupted Proto-Dragon

local CRAGGRAVATEDELEMENTAL = Rare({
    id = 193663,
    quest = 69964,
    fgroup = 'craggravated',
    focusable = true,
    rewards = {Achievement({id = 16679, criteria = 56154})}
}) -- Craggravated Elemental

map.nodes[45458518] = CRAGGRAVATEDELEMENTAL
map.nodes[52746732] = CRAGGRAVATEDELEMENTAL

map.nodes[47675115] = Rare({ -- required 67030
    id = 193234,
    quest = 69875,
    rewards = {Achievement({id = 16679, criteria = 56147})}
}) -- Eldoren the Reborn

map.nodes[53374092] = Rare({
    id = 193125,
    quest = nil,
    rewards = {
        Achievement({id = 16679, criteria = 56138}),
        Transmog({item = 200436, slot = L['mail']}) -- Gorestained Hauberk
    }
}) -- Goremaul the Gluttonous

map.nodes[57828380] = Rare({ -- review
    id = 193126,
    quest = nil,
    rewards = {Achievement({id = 16679, criteria = 56135})}
}) -- Innumerable Ruination

-- map.nodes[] = Rare({
--     id = 193241,
--     quest = 69882,
--     rewards = {
--         Achievement({id = 16679, criteria = 56157}),
--     }
-- }) -- Lord Epochbrgl

-- map.nodes[] = Rare({
--     id = 193246,
--     quest = 69883,
--     rewards = {
--         Achievement({id = 16679, criteria = 56141}),
--     }
-- }) -- Matriarch Remalla

-- map.nodes[] = Rare({ -- reqired 67030
--     id = 193688,
--     quest = 69976,
--     rewards = {
--         Achievement({id = 16679, criteria = 56140}),
--     }
-- }) -- Phenran

map.nodes[57218420] = Rare({ -- reqired 67030 review
    id = 193210,
    quest = 69866,
    rewards = {Achievement({id = 16679, criteria = 56142})}
}) -- Phleep

-- map.nodes[] = Rare({
--     id = 193130,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16679, criteria = 56137}),
--     }
-- }) -- Pleasant Alpha

-- map.nodes[] = Rare({
--     id = 193143,
--     quest = 69853,
--     rewards = {
--         Achievement({id = 16679, criteria = 56133}),
--     }
-- }) -- Razk'vex the Untamed

map.nodes[40087014] = Rare({ -- reqiured 67030
    id = 193240,
    quest = 69880,
    rewards = {Achievement({id = 16679, criteria = 56148})}
}) -- Riverwalker Tamopo

map.nodes[50005180] = Rare({ -- reqiured 67030 review
    id = 193666,
    quest = 69966,
    rewards = {Achievement({id = 16679, criteria = 56151})}
}) -- Rokmur

-- map.nodes[] = Rare({ -- reqiured 67030
--     id = 193176,
--     quest = 69859,
--     rewards = {
--         Achievement({id = 16679, criteria = 56150}),
--     }
-- }) -- Sandana the Tempest

map.nodes[47207895] = Rare({ -- review -- reqiured 67030
    id = 193258,
    quest = 69886,
    rewards = {Achievement({id = 16679, criteria = 56144})},
    pois = {
        Path({
            48897782, 48557735, 48407739, 47977782, 47177827, 47307994,
            47998002, 48277973, 49507949, 49947917
        })
    }
}) -- Tempestrian

map.nodes[38466826] = Rare({
    id = 191305,
    quest = 72121,
    rewards = {Achievement({id = 16679, criteria = 56155})}
}) -- The Great Shellkhan

-- map.nodes[] = Rare({
--     id = 183984,
--     quest = 65365,
--     rewards = {
--         Achievement({id = 16679, criteria = 56153}),
--     }
-- }) -- The Weeping Vilomah

map.nodes[35027001] = Rare({ -- reqiured 67030 review
    id = 193146,
    quest = 70947,
    note = L['in_small_cave'],
    rewards = {Achievement({id = 16679, criteria = 56146})},
    pois = {POI({34896938})} -- Entrance
}) -- Treasure-Mad Trambladd

map.nodes[47884976] = Rare({
    id = 193161,
    quest = 69850,
    note = L['woofang_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56152}),
        Item({item = 200445, note = L['neck']}), -- Lucky Hunting Charm
        Transmog({item = 200174, slot = L['leather']}) -- Bonesigil Shoulderguards
    }
}) -- Woolfang

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[49436289] = Treasure({
    quest = 70611,
    note = L['acorn_harvester_note'],
    rewards = {
        Achievement({id = 16301, criteria = 54815}),
        Pet({item = 193066, id = 3275}) -- Chestnut
    }
}) -- Acorn Harvester

map.nodes[52607673] = Treasure({
    quest = 70408,
    note = L['gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Item(198852) -- Bear Termination Orders
    },
    rewards = {
        Achievement({id = 16301, criteria = 54812}), --
        Item({item = 200863}) -- Glimmering Nozdorite Cluster
    }
}) -- Amber Gem Cluster

map.nodes[33967695] = Treasure({ -- add loot
    quest = 70607,
    note = L['cracked_hourglass_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Item(199068) -- Time-Lost Memo
    },
    rewards = {Achievement({id = 16301, criteria = 54810})}
}) -- Cracked Hourglass

map.nodes[60244164] = Treasure({ -- add loot
    quest = 70609,
    rewards = {Achievement({id = 16301, criteria = 54813})}
}) -- Elegant Canvas Brush

map.nodes[58168007] = Treasure({ -- add loot
    quest = 70608,
    note = L['sandy_wooden_duck_note'],
    requires = ns.requirement.Item(199069), -- Yennu's Map
    rewards = {Achievement({id = 16301, criteria = 54811})},
    pois = {POI({54937543})} -- Yennu's Map
}) -- Sandy Wooden Duck (Sand Pile)

map.nodes[64851655] = Treasure({ -- add loot
    quest = 70610,
    note = L['in_cave'],
    rewards = {Achievement({id = 16301, criteria = 54814})}
}) -- Surveyor's Magnifying Glass

-------------------------------------------------------------------------------

map.nodes[52458361] = Treasure({
    quest = 72355,
    label = '{npc:198604}',
    note = L['in_cave'],
    requires = ns.requirement.Profession(5, 186), -- Mining
    rewards = {
        Pet({item = 201463, id = 3415}) -- Cubbly
    }
}) -- Strange Bear Cub

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[39467359] = PetBattle({
    id = 197336,
    rewards = {
        Achievement({id = 16464, criteria = 55490}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 3, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 3, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 3, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 3, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 3, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 3, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 3, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 3, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 3, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 3, oneline = true}) -- Undead
    }
}) -- Enyobon

map.nodes[56274924] = PetBattle({
    id = 197350,
    rewards = {
        Achievement({id = 16464, criteria = 55493}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 6, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 6, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 6, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 6, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 6, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 6, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 6, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 6, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 6, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 6, oneline = true}) -- Undead
    }
}) -- Setimothes

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

map.nodes[55647727] = BonusBoss({
    id = 193229,
    quest = 72814, -- 69873
    rewards = {
        Item({item = 200880, note = L['trinket']}) -- Wind-Sealed Mana Capsule
    }
}) -- Henlare

map.nodes[36757287] = BonusBoss({
    id = 193273,
    quest = 72842,
    rewards = {
        Transmog({item = 200131, slot = L['dagger']}), -- Reclaimed Survivalist's Dagger
        Transmog({item = 200193, slot = L['cloth']}) -- Manafrond Sandals
    }
}) -- Liskron the Dazzling

-------------------------------------------------------------------------------
----------------------------- PROFESSION TREASURES ----------------------------
-------------------------------------------------------------------------------

map.nodes[52208050] = PT.Blacksmithing({
    id = 201006,
    quest = nil,
    note = L['pt_smith_draconic_flux_note']
}) -- Draconic Flux

map.nodes[55203050] = PT.Alchemy({
    id = 201003,
    quest = nil,
    note = L['pt_alch_furry_gloop_note']
}) -- Furry Gloop

map.nodes[56104090] = PT.Inscription({
    id = 201015,
    quest = nil,
    note = L['pt_script_counterfeit_darkmoon_deck_note']
}) -- Counterfeit Darkmoon Deck

map.nodes[56304120] = PT.Inscription({
    id = 198659,
    quest = nil,
    note = L['pt_script_forgetful_apprentices_tome_note']
}) -- Forgetful Apprentice's Tome

map.nodes[56803050] = PT.Leatherworking({
    id = 198690,
    quest = nil,
    note = L['pt_leath_decayed_scales_note']
}) -- Decayed Scales

map.nodes[56914372] = PT.Jewelcrafting({
    id = 198656,
    quest = 70261,
    note = L['pt_jewel_painters_pretty_jewel_note']
}) -- Painter's Pretty Jewel

map.nodes[58604580] = PT.Tailoring({
    id = 201019,
    quest = 70372,
    note = L['pt_tailor_ancient_dragonweave_bolt_note']
}) -- Ancient Dragonweave Bolt

map.nodes[59503840] = PT.Alchemy({
    id = 198697,
    quest = nil,
    note = L['pt_alch_contraband_concoction_note']
}) -- Contraband Concoction

map.nodes[59806520] = PT.Jewelcrafting({
    id = 198682,
    quest = 70285,
    note = L['pt_jewel_alexstraszite_cluster_note']
}) -- Alexstraszite Cluster

map.nodes[59907040] = PT.Enchanting({
    id = 198800,
    quest = 70342,
    note = L['pt_ench_fractured_titanic_sphere_note']
}) -- Fractured Titanic Sphere

map.nodes[60407970] = PT.Tailoring({
    id = 198684,
    quest = nil,
    note = L['pt_tailor_miniature_bronze_dragonflight_banner_note']
}) -- Miniature Bronze Dragonflight Banner

local valdrakken = Map({id = 2112, settings = false})
valdrakken.nodes[13206368] = PT.Inscription({
    id = 198669,
    quest = nil,
    note = L['pt_script_how_to_train_your_whelpling_note']
}) -- How to Train Your Whelpling

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

map.nodes[62414050] = Dragonglyph({rewards = {Achievement({id = 16104})}}) -- Dragon Glyphs: Algeth'ar Academy
map.nodes[49944032] = Dragonglyph({rewards = {Achievement({id = 16102})}}) -- Dragon Glyphs: Algeth'era
map.nodes[37639338] = Dragonglyph({rewards = {Achievement({id = 16673})}}) -- Dragon Glyphs: Fallen Course (Azure Span)
map.nodes[52676742] = Dragonglyph({rewards = {Achievement({id = 16666})}}) -- Dragon Glyphs: Gelikyr Overlook
map.nodes[55737225] = Dragonglyph({rewards = {Achievement({id = 16667})}}) -- Dragon Glyphs: Passage of Time
map.nodes[35608551] = Dragonglyph({rewards = {Achievement({id = 16100})}}) -- Dragon Glyphs: South Hold Gate
map.nodes[46107410] = Dragonglyph({rewards = {Achievement({id = 16099})}}) -- Dragon Glyphs: Stormshroud Peak
map.nodes[66108230] = Dragonglyph({rewards = {Achievement({id = 16098})}}) -- Dragon Glyphs: Temporal Conflux
map.nodes[72906921] = Dragonglyph({rewards = {Achievement({id = 16107})}}) -- Dragon Glyphs: Thaldrazsus Apex
map.nodes[61615661] = Dragonglyph({rewards = {Achievement({id = 16103})}}) -- Dragon Glyphs: Tyrhold
map.nodes[41285813] = Dragonglyph({
    parent = 2112,
    rewards = {Achievement({id = 16101})}
}) -- Dragon Glyphs: Valdrakken
map.nodes[72125131] = Dragonglyph({rewards = {Achievement({id = 16106})}}) -- Dragon Glyphs: Vault of the Incarnates
map.nodes[67121181] = Dragonglyph({rewards = {Achievement({id = 16105})}}) -- Dragon Glyphs: Veiled Ossuary

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

map.nodes[34048484] = Flag({quest = 71222})
map.nodes[46107397] = Flag({quest = 70024})
map.nodes[50168163] = Flag({quest = 70039})
map.nodes[65727498] = Flag({quest = 71223})
map.nodes[64635672] = Flag({quest = 71224})

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[38188192] = Disturbeddirt()
map.nodes[49894474] = Disturbeddirt()
map.nodes[55588459] = Disturbeddirt()
map.nodes[55756743] = Disturbeddirt()
map.nodes[55918384] = Disturbeddirt()
map.nodes[59532835] = Disturbeddirt()
map.nodes[62226638] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[37637740] = Scoutpack()
map.nodes[38796831] = Scoutpack()
map.nodes[38806831] = Scoutpack()
map.nodes[50844623] = Scoutpack()
map.nodes[52758333] = Scoutpack()
map.nodes[55456797] = Scoutpack()
map.nodes[55873598] = Scoutpack()
map.nodes[59198794] = Scoutpack()

-------------------------------------------------------------------------------
--------------------------------- DRAGONRACES ---------------------------------
-------------------------------------------------------------------------------

map.nodes[57767501] = ns.node.Dragonrace({
    label = '{quest:67095}',
    normal = {2080, 52, 49},
    advanced = {2081, 45, 40},
    rewards = {
        Achievement({id = 15924, criteria = 1, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 1, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 1, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 1, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 1, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 1, oneline = true}) -- advanced gold
    }
}) -- Flowing Forest Flight

map.nodes[57256690] = ns.node.Dragonrace({
    label = '{quest:69957}',
    normal = {2092, 84, 81},
    advanced = {2093, 80, 75},
    rewards = {
        Achievement({id = 15924, criteria = 2, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 2, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 2, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 2, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 2, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 2, oneline = true}) -- advanced gold
    }
}) -- Tyrhold Trial

map.nodes[37654894] = ns.node.Dragonrace({
    label = '{quest:70051}',
    normal = {2096, 72, 69},
    advanced = {2097, 71, 66},
    rewards = {
        Achievement({id = 15924, criteria = 3, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 3, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 3, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 3, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 3, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 3, oneline = true}) -- advanced gold
    }
}) -- Cliffside Circuit

map.nodes[60264179] = ns.node.Dragonrace({
    label = '{quest:70059}',
    normal = {2098, 57, 54},
    advanced = {2099, 57, 52},
    rewards = {
        Achievement({id = 15924, criteria = 4, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 4, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 4, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 4, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 4, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 4, oneline = true}) -- advanced gold
    }
}) -- Academy Ascent

map.nodes[39487621] = ns.node.Dragonrace({
    label = '{quest:70157}',
    normal = {2101, 64, 61},
    advanced = {2102, 59, 54},
    rewards = {
        Achievement({id = 15924, criteria = 5, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 5, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 5, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 5, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 5, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 5, oneline = true}) -- advanced gold
    }
}) -- Garden Gallivant

map.nodes[58043367] = ns.node.Dragonrace({
    label = '{quest:70161}',
    normal = {2103, 53, 50},
    advanced = {2104, 50, 45},
    rewards = {
        Achievement({id = 15924, criteria = 6, oneline = true}), -- normal bronze
        Achievement({id = 15925, criteria = 6, oneline = true}), -- normal silver
        Achievement({id = 15926, criteria = 6, oneline = true}), -- normal gold
        Achievement({id = 15936, criteria = 6, oneline = true}), -- advanced bronze
        Achievement({id = 15937, criteria = 6, oneline = true}), -- advanced silver
        Achievement({id = 15938, criteria = 6, oneline = true}) -- advanced gold
    }
}) -- Caverns Criss-Cross
