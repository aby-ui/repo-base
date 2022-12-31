-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local Collectible = ns.node.Collectible
local NPC = ns.node.NPC
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Dragonrace = ns.node.Dragonrace
local Flag = ns.node.Flag
local Fragment = ns.node.Fragment
local LegendaryCharacter = ns.node.LegendaryCharacter
local MagicBoundChest = ns.node.MagicBoundChest
local PM = ns.node.ProfessionMasters
local PrettyNeat = ns.node.PrettyNeat
local PT = ns.node.ProfessionTreasures
local RareElite = ns.node.RareElite
local Safari = ns.node.Safari
local Scoutpack = ns.node.Scoutpack
local Squirrel = ns.node.Squirrel

local Achievement = ns.reward.Achievement
local Currency = ns.reward.Currency
local Item = ns.reward.Item
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

local DC = ns.DRAGON_CUSTOMIZATIONS

-------------------------------------------------------------------------------

local map = Map({id = 2025, settings = true})
local val = Map({id = 2112, settings = false}) -- Valdrakken
local tpf = Map({id = 2085, settings = false}) -- The Primalist Future

-------------------------------------------------------------------------------

-- war supplies 41974893

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[59075874] = RareElite({
    id = 193664,
    quest = 74055,
    note = L['ancient_protector_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56158}),
        Transmog({item = 200138, slot = L['polearm']}), -- Ancient Dancer's Longspear
        Transmog({item = 200299, slot = L['1h_sword']}), -- Strange Clockwork Gladius
        Transmog({item = 200303, slot = L['staff']}), -- Dreamweaver Acolyte's Staff
        Transmog({item = 200758, slot = L['plate']}), -- Breastplate of Storied Antiquity
        DC.WindborneVelocidrake.SpikedBack, --
        DC.HighlandDrake.StripedPattern, --
        DC.HighlandDrake.CrestedBrow
    },
    pois = {POI({60755543, 60736211, 59225648, 59266104})} -- Titanic Reactors
}) -- Ancient Protector

map.nodes[31097121] = Rare({
    id = 193128,
    quest = 74096,
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
    quest = 74060,
    note = L['in_cave'] .. ' ' .. L['corrupted_proto_dragon_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56156}),
        -- Transmog({item = 199020, slot = L['gun']}), -- Drake Race Starting Rifle of the Fireflash
        Transmog({item = 200166, slot = L['offhand']}) -- Drake Race Starting Rifle of the Fireflash
    },
    pois = {POI({44616780})} -- Entrance
}) -- Corrupted Proto-Dragon

local CRAGGRAVATEDELEMENTAL = Rare({
    id = 193663,
    quest = 74061,
    fgroup = 'craggravated',
    focusable = true,
    rewards = {Achievement({id = 16679, criteria = 56154})}
}) -- Craggravated Elemental

map.nodes[45458518] = CRAGGRAVATEDELEMENTAL
map.nodes[52746732] = CRAGGRAVATEDELEMENTAL

map.nodes[47675115] = Rare({ -- required 67030
    id = 193234,
    quest = 73990,
    rewards = {
        Achievement({id = 16446, criteria = 55398, note = L['pretty_neat_note']}),
        Achievement({id = 16679, criteria = 56147})
    }
}) -- Eldoren the Reborn

map.nodes[53374092] = Rare({
    id = 193125,
    quest = 73878,
    rewards = {
        Achievement({id = 16679, criteria = 56138}),
        Transmog({item = 200436, slot = L['mail']}) -- Gorestained Hauberk
    }
}) -- Goremaul the Gluttonous

map.nodes[57828380] = Rare({ -- review
    id = 193126,
    quest = 73881,
    rewards = {
        Achievement({id = 16679, criteria = 56135}), --
        Toy({item = 200148}) -- A Collection Of Me
    }
}) -- Innumerable Ruination

map.nodes[62298177] = Rare({
    id = 193241,
    quest = 74066,
    note = L['lord_epochbrgl_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56157}), --
        Toy({item = 200148}) -- A Collection Of Me
    },
    pois = {POI({61708120})} -- Entrance
}) -- Lord Epochbrgl

map.nodes[52895903] = Rare({
    id = 193246,
    quest = 74013,
    rewards = {Achievement({id = 16679, criteria = 56141})}
}) -- Matriarch Remalla

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
    rewards = {
        Achievement({id = 16679, criteria = 56142}), --
        Toy({item = 200148}) -- A Collection Of Me
    }
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

map.nodes[37607780] = Rare({ -- reqiured 67030
    id = 193176,
    quest = 69859,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 16679, criteria = 56150}), --
        Toy({item = 200148}) -- A Collection Of Me
    },
    pois = {POI({38507640})} -- Cave entrance
}) -- Sandana the Tempest

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
    quest = 74085,
    rewards = {
        Achievement({id = 16679, criteria = 56155}), --
        Toy({item = 200999}) -- The Super Shellkhan Gang
    }
}) -- The Great Shellkhan

map.nodes[46267317] = Rare({
    id = 183984,
    quest = 74086,
    note = L['in_cave'] .. ' ' .. L['weeping_vilomah_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56153}),
        Transmog({item = 200214, slot = L['mail']}) -- Grasp of the Weeping Widow
    },
    pois = {POI({47547180})} -- Cave entrance
}) -- The Weeping Vilomah

map.nodes[35027001] = Rare({ -- reqiured 67030 review
    id = 193146,
    quest = 74036,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16679, criteria = 56146}),
        Transmog({item = 200291, slot = L['leather']}) -- Waterlogged Racing Grips
    },
    pois = {POI({34896938})} -- Entrance
}) -- Treasure-Mad Trambladd

map.nodes[47884976] = Rare({
    id = 193161,
    quest = 74089,
    note = L['woofang_note'],
    rewards = {
        Achievement({id = 16679, criteria = 56152}),
        Transmog({item = 200186, slot = L['mail']}), -- Amberquill Shroud
        Transmog({item = 200174, slot = L['leather']}), -- Bonesigil Shoulderguards
        Item({item = 200445, note = L['neck']}) -- Lucky Hunting Charm
    }
}) -- Woolfang

-------------------------------------------------------------------------------

-- These rares/elites are not part of the adventurer achievement for the zone

map.nodes[55647727] = Rare({
    id = 193229,
    quest = 72814, -- 69873
    rewards = {
        Item({item = 200880, note = L['trinket']}) -- Wind-Sealed Mana Capsule
    }
}) -- Henlare

map.nodes[36757287] = Rare({
    id = 193273,
    quest = 72842,
    rewards = {
        Achievement({id = 16446, criteria = 55399, note = L['pretty_neat_note']}),
        Transmog({item = 200131, slot = L['dagger']}), -- Reclaimed Survivalist's Dagger
        Transmog({item = 200193, slot = L['cloth']}) -- Manafrond Sandals
    }
}) -- Liskron the Dazzling

map.nodes[36798556] = Rare({
    id = 193668,
    quest = 72813,
    rewards = {
        Transmog({item = 200182, slot = L['cloak']}), -- Riveted Drape
        DC.WindborneVelocidrake.ClusterHorns, DC.RenewedProtoDrake.ImpalerHorns,
        DC.HighlandDrake.ToothyMouth, DC.RenewedProtoDrake.HeavyHorns,
        Item({item = 198048}) -- Titan Training Matrix I
    }
}) -- Lookout Mordren

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[49436289] = Treasure({
    quest = 70611,
    note = L['acorn_harvester_note'],
    rewards = {
        Achievement({id = 16301, criteria = 54815}), -- Treasures of Thaldraszus
        Pet({item = 193066, id = 3275}) -- Chestnut
    }
}) -- Acorn Harvester

map.nodes[52607673] = Treasure({
    quest = 70408,
    note = L['gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Quest(70407, '{item:198852}') -- Bear Termination Orders
    },
    rewards = {
        Achievement({id = 16301, criteria = 54812}), -- Treasures of Thaldraszus
        Item({item = 200863}) -- Glimmering Nozdorite Cluster
    }
}) -- Amber Gem Cluster

map.nodes[33967695] = Treasure({
    quest = 70607,
    note = L['cracked_hourglass_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Quest(70537, '{item:199068}') -- Time-Lost Memo
    },
    rewards = {
        Achievement({id = 16301, criteria = 54810}), -- Treasures of Thaldraszus
        Item({item = 169951, note = '3x'}) -- Broken Hourglass
    }
}) -- Cracked Hourglass

map.nodes[60244164] = Treasure({
    quest = 70609,
    rewards = {
        Achievement({id = 16301, criteria = 54813}), -- Treasures of Thaldraszus
        Item({item = 203206}) -- Elegant Canvas Brush
    }
}) -- Elegant Canvas Brush

map.nodes[58168007] = Treasure({
    quest = 70608,
    note = L['sandy_wooden_duck_note'],
    requires = ns.requirement.Quest(70538, '{item:199069}'), -- Yennu's Map
    rewards = {
        Achievement({id = 16301, criteria = 54811}), -- Treasures of Thaldraszus
        Item({item = 200827, note = '5x'}) -- Weathered Sculpture
    },
    pois = {POI({54937543})} -- Yennu's Map
}) -- Sandy Wooden Duck (Sand Pile)

map.nodes[64851655] = Treasure({
    quest = 70610,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 16301, criteria = 54814}), Item({item = 193036}) -- Left-Handed Magnifying Glass
    }
}) -- Surveyor's Magnifying Glass

-------------------------------------------------------------------------------

map.nodes[52458361] = Treasure({
    quest = 72355,
    label = '{npc:198604}',
    note = L['in_cave'],
    requires = ns.requirement.Profession(186), -- Mining
    rewards = {
        Pet({item = 201463, id = 3415}) -- Cubbly
    }
}) -- Strange Bear Cub

val.nodes[09535629] = Treasure({
    quest = 70731,
    label = '{item:197769}',
    note = L['tasty_hatchling_treat_note'],
    parent = map.id,
    rewards = {
        Item({item = 198106}) -- Recipe: Tasty Hatchling's Treat
    }
}) -- Tasty Hatchling's Treat

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
----------------------------- PROFESSION TREASURES ----------------------------
-------------------------------------------------------------------------------

map.nodes[52208050] = PT.Blacksmithing({
    id = 201006,
    quest = nil,
    note = L['pt_smith_draconic_flux_note']
}) -- Draconic Flux

map.nodes[55203050] = PT.Alchemy({
    id = 201003,
    quest = 70278,
    note = L['pt_alch_furry_gloop_note']
}) -- Furry Gloop

map.nodes[56104090] = PT.Inscription({
    id = 201015,
    quest = 70287,
    note = L['pt_script_counterfeit_darkmoon_deck_note']
}) -- Counterfeit Darkmoon Deck

map.nodes[56304120] = PT.Inscription({
    id = 198659,
    quest = 70264,
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
    quest = 70301,
    note = L['pt_alch_contraband_concoction_note']
}) -- Contraband Concoction

map.nodes[59806520] = PT.Jewelcrafting({
    id = 198682,
    quest = 70285,
    note = L['pt_jewel_alexstraszite_cluster_note']
}) -- Alexstraszite Cluster

map.nodes[59897033] = PT.Enchanting({
    id = 198800,
    quest = 70342,
    note = L['pt_ench_fractured_titanic_sphere_note']
}) -- Fractured Titanic Sphere

map.nodes[60407970] = PT.Tailoring({
    id = 198684,
    quest = 70288,
    note = L['pt_tailor_miniature_bronze_dragonflight_banner_note']
}) -- Miniature Bronze Dragonflight Banner

val.nodes[13206368] = PT.Inscription({
    id = 198669,
    quest = nil,
    parent = map.id,
    note = L['pt_script_how_to_train_your_whelpling_note']
}) -- How to Train Your Whelpling

-------------------------------------------------------------------------------

map.nodes[61437687] = PM.Mining({
    id = 194843,
    quest = 70258,
    note = L['pm_mining_bridgette_holdug'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2035, note = '10'}) -- Dragon Isles Mining Knowledge
    }
}) -- Bridgette Holdug

val.nodes[27894576] = PM.Tailoring({
    id = 194845,
    quest = 70260,
    note = L['pm_tailor_elysa_raywinder'],
    parent = map.id,
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2026, note = '5'}) -- Dragon Isles Tailoring Knowledge
    }
}) -- Elysa Raywinder

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
val.nodes[59293792] = Dragonglyph({
    parent = map.id,
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
---------------------------- FRAGMENTS OF HISTORY -----------------------------
-------------------------------------------------------------------------------

map.nodes[38904500] = Fragment({
    sublabel = L['golden_claw_note'],
    rewards = {
        Achievement({id = 16323, criteria = 55031}),
        Item({item = 198540, quest = 70204})
    }
}) -- Golden Claw

map.nodes[57126460] = Fragment({
    sublabel = L['precious_stone_fragment_note'],
    rewards = {
        Achievement({id = 16323, criteria = 55032}),
        Item({item = 199893, quest = 70805})
    }
}) -- Precious Stone Fragment

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[34006488] = Disturbeddirt()
map.nodes[34646179] = Disturbeddirt()
map.nodes[35406995] = Disturbeddirt()
map.nodes[37667615] = Disturbeddirt()
map.nodes[38188192] = Disturbeddirt()
map.nodes[39058408] = Disturbeddirt()
map.nodes[39768205] = Disturbeddirt()
map.nodes[46767747] = Disturbeddirt()
map.nodes[49514830] = Disturbeddirt()
map.nodes[49894474] = Disturbeddirt()
map.nodes[53398748] = Disturbeddirt()
map.nodes[53997921] = Disturbeddirt()
map.nodes[54273978] = Disturbeddirt()
map.nodes[54433376] = Disturbeddirt()
map.nodes[55588459] = Disturbeddirt()
map.nodes[55756743] = Disturbeddirt()
map.nodes[55918384] = Disturbeddirt()
map.nodes[56957403] = Disturbeddirt()
map.nodes[59532835] = Disturbeddirt()
map.nodes[62226638] = Disturbeddirt()
map.nodes[62296972] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[35517551] = Scoutpack()
map.nodes[37637740] = Scoutpack()
map.nodes[38796831] = Scoutpack()
map.nodes[38806831] = Scoutpack()
map.nodes[41234798] = Scoutpack()
map.nodes[50844623] = Scoutpack()
map.nodes[52758333] = Scoutpack()
map.nodes[55456797] = Scoutpack()
map.nodes[55873598] = Scoutpack()
map.nodes[55875138] = Scoutpack()
map.nodes[58046702] = Scoutpack()
map.nodes[59198794] = Scoutpack()
map.nodes[59496912] = Scoutpack()

-------------------------------------------------------------------------------
------------------------------ Magic-Bound Chest ------------------------------
-------------------------------------------------------------------------------

map.nodes[35107050] = MagicBoundChest({
    note = L['in_small_cave'],
    pois = {POI({34926940})}
})
map.nodes[42606660] = MagicBoundChest({
    requires = {
        ns.requirement.Reputation(2507, 16, true),
        ns.requirement.Profession(186)
    },
    note = L['in_small_cave']
})
map.nodes[42907900] = MagicBoundChest({
    note = L['in_cave'],
    pois = {POI({40957754})}
})
map.nodes[50205200] = MagicBoundChest({
    requires = {
        ns.requirement.Reputation(2507, 16, true),
        ns.requirement.Profession(186)
    },
    note = L['in_small_cave']
})
map.nodes[53005690] = MagicBoundChest()
map.nodes[54108390] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[54803270] = MagicBoundChest({
    requires = {
        ns.requirement.Reputation(2507, 16, true),
        ns.requirement.Profession(186)
    },
    note = L['in_small_cave']
})
map.nodes[58606750] = MagicBoundChest({
    note = L['in_cave'],
    pois = {POI({56916717})}
})
map.nodes[61305400] = MagicBoundChest({
    note = L['in_cave'],
    pois = {POI({59755371})}
})
map.nodes[62207180] = MagicBoundChest()

-------------------------------------------------------------------------------
--------------------------------- DRAGONRACES ---------------------------------
-------------------------------------------------------------------------------

map.nodes[57767501] = Dragonrace({
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

map.nodes[57256690] = Dragonrace({
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

map.nodes[37654894] = Dragonrace({
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

map.nodes[60264179] = Dragonrace({
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

map.nodes[39487621] = Dragonrace({
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

map.nodes[58043367] = Dragonrace({
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

-------------------------------------------------------------------------------
--------------------- TO ALL THE SQUIRRELS HIDDEN TIL NOW ---------------------
-------------------------------------------------------------------------------

map.nodes[55636757] = Squirrel({
    id = 195869,
    rewards = {Achievement({id = 16729, criteria = 10})}
}) -- Diminuitive Boghopper

map.nodes[51695797] = Squirrel({
    id = 196652,
    rewards = {Achievement({id = 16729, criteria = 11})}
}) -- Reservoir Filly

map.nodes[51307286] = Squirrel({
    id = 185148,
    rewards = {Achievement({id = 16729, criteria = 12})}
}) -- Rocdrop Scarab

-------------------------------------------------------------------------------
--------------------------- THE DISGRUNTLED HUNTER ----------------------------
-------------------------------------------------------------------------------

local HemetNesingwaryJr = Class('HemetNesingwaryJr', Collectible, {
    id = 194590,
    icon = 236444,
    sublabel = L['hnj_sublabel'],
    group = ns.groups.HEMET_NESINGWARY_JR
}) -- Hemet Nesingwary Jr.

map.nodes[34676541] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55701})}
}) -- Southern Thaldraszus Hunt

map.nodes[50674562] = HemetNesingwaryJr({
    note = L['hnj_northern_thaldraszus_hunt'],
    rewards = {Achievement({id = 16542, criteria = 55702})}
}) -- Northern Thaldraszus Hunt

-------------------------------------------------------------------------------
-------------------------- ONE OF EVERYTHING, PLEASE --------------------------
-------------------------------------------------------------------------------

val.nodes[60921096] = Collectible({
    label = '{item:200904}',
    icon = 237358,
    note = L['picante_pomfruit_cake_note'],
    group = ns.groups.SPECIALTIES,
    parent = map.id,
    rewards = {Achievement({id = 16621, criteria = 55733})}
}) -- Picante Pompfruit Cake

val.nodes[29046503] = Collectible({
    label = '{item:201045}',
    icon = 133994,
    note = L['icecrown_bleu_note'],
    group = ns.groups.SPECIALTIES,
    parent = map.id,
    rewards = {Achievement({id = 16621, criteria = 55931})}
}) -- Icecrown Bleu

map.nodes[50054267] = Collectible({
    label = '{item:201046}',
    icon = 132802,
    note = L['dreamwarding_dripbrew_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55933})}
}) -- Dreamwarding Dripbrew

tpf.nodes[61555322] = Collectible({
    label = '{item:201047}',
    icon = 134043,
    note = L['arcanostabilized_provisions_note'],
    group = ns.groups.SPECIALTIES,
    parent = map.id,
    rewards = {Achievement({id = 16621, criteria = 55934})}
}) -- Arcanostabilized Provisions

map.nodes[38944629] = Collectible({
    label = '{item:200871}',
    icon = 4639581,
    note = L['steamed_scarab_steak_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55936})}
}) -- Steamed Scarab Steak

map.nodes[58138299] = Collectible({
    label = '{item:201089}',
    icon = 644375,
    note = L['craft_creche_crowler_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55940})}
}) -- Craft Creche Crowler

map.nodes[52416987] = Collectible({
    label = '{item:201090}',
    icon = 134022,
    note = L['bivigosas_blood_sausages_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55941})}
}) -- Bivigosa's Blood Sausages

-------------------------------------------------------------------------------
----------------------------- THAT'S PRETTY NEAT! -----------------------------
-------------------------------------------------------------------------------

map.nodes[43567208] = PrettyNeat({
    id = 187280,
    rewards = {Achievement({id = 16446, criteria = 55388})}
}) -- Chef Fry-Aerie

map.nodes[54285271] = PrettyNeat({
    id = 192383,
    rewards = {Achievement({id = 16446, criteria = 55389})}
}) -- Iridescent Peafowl

-------------------------------------------------------------------------------
------------------------------ A LEGENDARY ALBUM ------------------------------
-------------------------------------------------------------------------------

map.nodes[52934483] = LegendaryCharacter({
    id = 187284,
    rewards = {Achievement({id = 16570, criteria = 55775})},
    pois = {
        Path({52934483, 52634333, 52244259, 51764224, 51164188}) -- Flight Path
    }
}) -- Wrathion

map.nodes[36036939] = LegendaryCharacter({
    id = 195633,
    rewards = {Achievement({id = 16570, criteria = 55773})}
}) -- Time-Warped Mysterious Fisher

-------------------------------------------------------------------------------
-------------------------- FRAMING A NEW PERSPECTIVE --------------------------
-------------------------------------------------------------------------------

local NewPerspective = Class('NewPerspective', Collectible, {
    icon = 1109100,
    note = L['new_perspective_note'],
    group = ns.groups.NEW_PERSPECTIVE
}) -- Framing a New Perspective

function NewPerspective.getters:rewards()
    return {Achievement({id = 16634, criteria = self.criteria})}
end

val.nodes[56094447] = NewPerspective({criteria = 55994, parent = map.id}) -- The Seat of the Aspects
map.nodes[38967040] = NewPerspective({criteria = 55995}) -- The Cascades
map.nodes[55737324] = NewPerspective({criteria = 55996}) -- Passage of Time -- On the Stone Arch
map.nodes[68275833] = NewPerspective({criteria = 55997}) -- Vault of the Incarnates
map.nodes[57175871] = NewPerspective({criteria = 55998}) -- Tyrhold
map.nodes[50284031] = NewPerspective({criteria = 55999}) -- Algeth'era Court
map.nodes[63431347] = NewPerspective({criteria = 56000}) -- Veiled Ossuary
map.nodes[39434692] = NewPerspective({criteria = 56001}) -- Serene Dreams Spa
map.nodes[48286682] = NewPerspective({criteria = 56002}) -- Shadow Ledge -- Edge of the Waterfall
val.nodes[56674327] = NewPerspective({criteria = 56003, parent = map.id}) -- Valdrakken's Portal Room
map.nodes[46955951] = NewPerspective({criteria = 56004}) -- Tyrhold Reservoir

-------------------------------------------------------------------------------
----------------------------- DRAGON ISLES SAFARI -----------------------------
-------------------------------------------------------------------------------

map.nodes[62401520] = Safari({
    id = 197629,
    rewards = {Achievement({id = 16519, criteria = 55644}), Pet({id = 3403})},
    pois = {
        POI({
            32206920, 33406700, 34207160, 34806400, 35007320, 35407080,
            36406540, 37007680, 37807980, 38207280, 39407820, 39607820,
            40408100, 40808080, 41008180, 42208300, 42407880, 44408440,
            44408460, 53803620, 61001500, 61801680, 62401520, 63001380,
            63601520, 63601960, 64401320
        })
    }
}) -- Blue Dasher

map.nodes[60403800] = Safari({
    id = 192268,
    rewards = {Achievement({id = 16519, criteria = 55656}), Pet({id = 3358})},
    pois = {POI({60403800, 60603800})}
}) -- Crimsonspine

map.nodes[50204780] = Safari({
    id = 189153,
    rewards = {Achievement({id = 16519, criteria = 55646}), Pet({id = 3313})},
    pois = {
        POI({
            48005020, 49205220, 49205280, 49404780, 49805020, 50204780,
            51404700, 51604700
        })
    }
}) -- Grassland Stomper

map.nodes[47606160] = Safari({
    id = 194720,
    rewards = {Achievement({id = 16519, criteria = 55647}), Pet({id = 3351})},
    pois = {
        POI({
            38208140, 47406200, 47606160, 48005600, 48005680, 48805560, 48806220
        })
    }
}) -- Grizzlefur Cub

map.nodes[52404860] = Safari({
    id = 189121,
    rewards = {Achievement({id = 16519, criteria = 55648}), Pet({id = 3295})},
    pois = {
        POI({
            46406380, 46606420, 47006300, 47606180, 48205740, 48205760,
            48405940, 48405960, 49205780, 49605760, 50005600, 50405140,
            51005040, 51005060, 51405740, 51405760, 51605740, 52404860,
            52804940, 53004840, 53604760, 53804660, 54004620, 54204920
        })
    }
}) -- Igneoid

map.nodes[39804580] = Safari({
    id = 193000,
    rewards = {Achievement({id = 16519, criteria = 55650}), Pet({id = 3366})}
}) -- Kindlet

map.nodes[50205900] = Safari({
    id = 189122,
    rewards = {Achievement({id = 16519, criteria = 55652}), Pet({id = 3296})},
    pois = {
        POI({
            38404840, 38804540, 38804940, 39204580, 39204820, 40204480,
            40604760, 41004740, 41204860, 41604840, 41604860, 48405940,
            48805940, 49005780, 49006040, 49206060, 49405680, 49806060,
            50005980, 50205900, 50605840
        })
    }
}) -- Palamanther

map.nodes[43208360] = Safari({
    id = 197637,
    rewards = {Achievement({id = 16519, criteria = 55653}), Pet({id = 3404})},
    pois = {
        POI({
            34206840, 35806640, 36607180, 37406740, 37606740, 37606760,
            38206900, 43208340, 43208360, 43608140, 43608340, 43608360,
            53404180, 54803940, 60002980, 61402960
        })
    }
}) -- Polliswog

map.nodes[44006480] = Safari({
    id = 191323,
    rewards = {Achievement({id = 16519, criteria = 55666}), Pet({id = 3336})},
    pois = {
        POI({
            32807300, 38007860, 41008140, 41406780, 42206560, 42806720,
            42808280, 43806440, 44006480, 45006440, 45206180, 45606180,
            46206560, 46606240, 46806400, 48206480, 49206240, 49406260,
            49806380, 50006220, 51206500, 52006220, 52006340, 52006360,
            53404040, 53406120, 53604040, 54005540
        })
    }
}) -- Vorquin Runt

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

---------------- ACHIEVEMENT: GREAT GOURMAND OF THE RUBY FEAST ----------------

val.nodes[61261096] = Collectible({
    icon = 629060,
    parent = map.id,
    label = '{achievement:16556}',
    note = L['ruby_feast_gourmand'],
    rewards = {
        Achievement({
            id = 16556,
            criteria = {
                55714, 55715, 55716, 55717, 55718, 55719, 55720, 55721, 55722,
                55723, 55724, 55725, 55726, 55728, 55729, 55730, 55731, 55732,
                55733, 55734
            }
        })
    }
}) -- Great Gourmand of the Ruby Feast

val.nodes[43757494] = Collectible({
    icon = 4048815,
    parent = map.id,
    id = 187783,
    requires = {
        ns.requirement.Item(197792, 3), ns.requirement.Item(197788, 1),
        ns.requirement.Item(197789, 1)
    },
    rewards = {Pet({item = 193571, id = 3303})}
}) -- Mallard Ducklin

----------------------------- MISCELLANEOUS NPCs ------------------------------

val.nodes[25994004] = NPC({
    id = 195768,
    icon = 4638429,
    note = L['sorotis_note'],
    parent = map.id
}) -- Sorotis (Valdrakken Accord Reputation)

val.nodes[35182459] = NPC({
    id = 197095,
    icon = 4638531,
    note = L['lillian_brightmoon_note'],
    parent = map.id
}) -- Lillian Brightmoon (Dragonscale Expedition Reputation)

-- STOP: DO NOT ADD NEW NODES HERE UNLESS THEY BELONG IN MISCELLANEOUS
