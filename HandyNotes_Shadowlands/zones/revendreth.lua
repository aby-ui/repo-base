-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Collectible = ns.node.Collectible
local NPC = ns.node.NPC
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Transmog = ns.reward.Transmog
local Toy = ns.reward.Toy

local Arrow = ns.poi.Arrow
local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local VENTHYR = ns.covenants.VEN
local map = Map({ id=1525, settings=true })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[53247300] = Rare({
    id=166393,
    quest=59854,
    note=L["amalgamation_of_filth_note"],
    rewards={
        Achievement({id=14310, criteria=48814}),
        Transmog({item=183729, slot=L["leather"]}) -- Filth-Splattered Headcover
    },
    pois={
        POI({52747386, 53857251, 54537436, 53897368}) -- Rubbish Box
    }
}) -- Amalgamation of Filth

map.nodes[25304850] = Rare({
    id=164388,
    quest=59584,
    note=L["amalgamation_of_light_note"],
    rewards={
        Achievement({id=14310, criteria=48811}),
        Transmog({item=179926, slot=L["cloth"]}), -- Light-Infused Tunic
        Transmog({item=179924, slot=L["leather"]}), -- Light-Infused Jacket
        Transmog({item=179653, slot=L["mail"]}), -- Light-Infused Hauberk
        Transmog({item=179925, slot=L["plate"]}), -- Light-Infused Breastplate
        Item({item=180688}) -- Infused Remnant of Light
    }
}) -- Amalgamation of Light

map.nodes[65782914] = Rare({
    id=170434,
    quest=60836,
    note=L["amalgamation_of_sin_note"],
    rewards={
        Achievement({id=14310, criteria=50029}),
        Transmog({item=183730, slot=L["plate"]}) -- Sinstone-Studded Greathelm
    }
}) -- Amalgamation of Sin

map.nodes[35817052] = Rare({
    id=166576,
    quest=59893,
    rewards={
        Achievement({id=14310, criteria=48816}),
        Transmog({item=183731, slot=L["plate"]}) -- Smolder-Tempered Legplates
    }
}) -- Azgar

map.nodes[35003230] = Rare({
    id=166292,
    quest=59823,
    note=L["bog_beast_note"],
    rewards={
        Achievement({id=14310, criteria=48818}),
        Pet({item=180588, id=2896}) -- Bucket of Primordial Sludge
    }
}) -- Bog Beast

map.nodes[66555946] = Rare({
    id=165206,
    quest=59582,
    note=L["endlurker_note"],
    rewards={
        Achievement({id=14310, criteria=48810}),
        Item({item=179927, note=L["trinket"]}) -- Glowing Endmire Stinger
    }
}) -- Endlurker

map.nodes[37084742] = Rare({
    id=166710,
    quest=59913,
    note=L["executioner_aatron_note"],
    rewards={
        Achievement({id=14310, criteria=48819}),
        Transmog({item=183737, slot=L["plate"]}) -- Aatron's Stone Girdle
    }
}) -- Executioner Aatron

map.nodes[43055183] = Rare({
    id=161310,
    quest=58441,
    rewards={
        Achievement({id=14310, criteria=48807}),
        Transmog({item=180502, slot=L["leather"]}) -- Adrastia's Executioner Gloves
    },
    pois={
        Path({43055183, 41525104, 41264940, 42734893, 44135004, 44435182, 43055183})
    }
}) -- Executioner Adrastia

map.nodes[62484716] = Rare({
    id=166521,
    quest=59869,
    note=L["famu_note"],
    rewards={
        Achievement({id=14310, criteria=48815}),
        Mount({item=180582, id=1379}), -- Endmire Flyer
    }
}) -- Famu the Infinite

map.nodes[32641545] = Rare({
    id=159496,
    quest=61618,
    covenant=VENTHYR,
    requires=ns.requirement.GarrisonTalent(1259, L["anima_channeled"]),
    note=L["madalav_note"],
    rewards={
        Transmog({item=180939, slot=L["cosmetic"]}) -- Mantle of the Forgemaster's Dark Blades
    },
    pois={
        POI({32661483}) -- Madalav's Hammer
    }
}) -- Forgemaster Madalav

map.nodes[20485298] = Rare({
    id=167464,
    quest=60173,
    note=L["grand_arcanist_dimitri_note"],
    rewards={
        Achievement({id=14310, criteria=48821})
    }
}) -- Grand Arcanist Dimitri

map.nodes[45847919] = Rare({
    id=165290,
    quest=59612,
    covenant=VENTHYR,
    requires=ns.requirement.GarrisonTalent(1256, L["anima_channeled"]),
    note=L["harika_note"],
    rewards={
        Transmog({item=183720, slot=L["leather"]}), -- Dredbatskin Jerkin
        Mount({item=180461, id=1310}) -- Horrid Brood Dredwing
    },
    pois={
        POI({43257769}), -- Ballista Bolt
        POI({41187469, 40917690}) -- Dredhollow Tools
    }
}) -- Harika the Horrid

map.nodes[51985179] = Rare({
    id=166679,
    quest=59900,
    rewards={
        Achievement({id=14310, criteria=48817}),
        Mount({item=180581, id=1298, covenant=VENTHYR}) -- Hopecrusher Gargon
    }
}) -- Hopecrusher

map.nodes[61717949] = Rare({
    id=166993,
    quest=60022,
    rewards={
        Achievement({id=14310, criteria=48820}),
        Item({item=180705, class='HUNTER'}) -- Gargon Training Manual
    }
}) -- Huntmaster Petrus

map.nodes[21803590] = Rare({
    id=160640,
    quest=58210,
    requires=ns.requirement.Item(177223),
    note=L["innervus_note"],
    rewards={
        Achievement({id=14310, criteria=48801}),
        Transmog({item=183735, slot=L["cloth"]}) -- Rogue Sinstealer's Mantle
    }
}) -- Innervus

map.nodes[67978179] = Rare({
    id=165152,
    quest=59580,
    note=L["leeched_soul_note"],
    rewards={
        Achievement({id=14310, criteria=48809}),
        Transmog({item=183736, slot=L["cloth"]}), -- Pride Resistant Handwraps
        Pet({item=180585, id=2897}) -- Bottled Up Emotions
    }
}) -- Leeched Soul

map.nodes[75976161] = Rare({
    id=161891,
    quest=58633,
    note=L["lord_mortegore_note"],
    rewards={
        Achievement({id=14310, criteria=48808}),
        Transmog({item=180501, slot=L["mail"]}) -- Skull-Formed Headcage
    }
}) -- Lord Mortegore

map.nodes[49003490] = Rare({
    id=170048,
    quest=60729,
    note=L["manifestation_of_wrath_note"],
    rewards={
        Achievement({id=14310, criteria=48822}),
        Pet({item=180585, id=2897}) -- Bottled Up Emotions
    }
}) -- Manifestation of Wrath

map.nodes[38316914] = Rare({
    id=160675,
    quest=58213,
    note=L["scrivener_lenua_note"],
    rewards={
        Achievement({id=14310, criteria=48800}),
        Pet({item=180587, id=2893}) -- Animated Tome
    }
}) -- Scrivener Lenua

map.nodes[67443048] = Rare({
    id=162481,
    quest=62252,
    note=L["sinstone_hoarder_note"],
    rewards={
        Achievement({id=14310, criteria=50030}),
        Transmog({item=183732, slot=L["mail"]}) -- Sinstone-Linked Greaves
    }
}) -- Sinstone Hoarder

map.nodes[34045555] = Rare({
    id=160857,
    quest=58263,
    note=L["sire_ladinas_note"],
    rewards={
        Achievement({id=14310, criteria=48806}),
        Toy({item=180873}) -- Smolderheart
    }
}) -- Sire Ladinas

map.nodes[78934975] = Rare({
    id=160385,
    quest=58130,
    note=L["soulstalker_doina_note"],
    rewards={
        Achievement({id=14310, criteria=48799})
    }
}) -- Soulstalker Doina

map.nodes[31312324] = Rare({
    id=159503,
    quest=62220,
    rewards={
        Achievement({id=14310, criteria=48803}),
        Transmog({item=180488, slot=L["plate"]}) -- Fist-Forged Breastplate
    }
}) -- Stonefist

map.nodes[66507080] = Rare({
    id=165253,
    quest=59595,
    rewards={
        Achievement({id=14310, criteria=48812}),
        Item({item=179363, quest=60517}) -- The Toll of the Road
    }
}) -- Tollkeeper Varaboss

map.nodes[43007910] = Rare({
    id=155779,
    quest=56877,
    note=L["tomb_burster_note"],
    rewards={
        Achievement({id=14310, criteria=48802}),
        Pet({item=180584, id=2891}) -- Blushing Spiderling
    }
}) -- Tomb Burster

map.nodes[38607200] = Rare({
    id=160821,
    quest=58259,
    requires=ns.requirement.Item(173939),
    note=L["worldedge_gorger_note"],
    rewards={
        Achievement({id=14310, criteria=48805}),
        Item({item=180583, quest=61188}) -- Impressionable Gorger Spawn
    }
}) -- Worldedge Gorger

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[51855954] = Treasure({
    quest=59888,
    rewards={
        Achievement({id=14314, criteria=50902}),
        Item({item=182744}) -- Ornate Belt Buckle
    }
}) -- Abandoned Curios

map.nodes[69327795] = Treasure({
    quest=59833,
    rewards={
        Achievement({id=14314, criteria=50896}),
        Toy({item=179393}) -- Mirror of Envious Dreams
    }
}) -- Chest of Envious Dreams

map.nodes[64187265] = Treasure({
    quest=59883,
    rewards={
        Achievement({id=14314, criteria=50897})
    }
}) -- Filcher's Prize

map.nodes[46395817] = Treasure({
    quest=59886,
    rewards={
        Achievement({id=14314, criteria=50900})
    }
}) -- Fleeing Soul's Bundle

map.nodes[47335536] = Treasure({
    quest=62243,
    note=L["forbidden_chamber_note"],
    rewards={
        Achievement({id=14314, criteria=50084}),
        Toy({item=184075}) -- Stonewrought Sentry
    }
}) -- Forbidden Chamber

map.nodes[75465542] = Treasure({
    quest=59887,
    note=L["gilded_plum_chest_note"],
    rewards={
        Achievement({id=14314, criteria=50901}),
        Item({item=179390}) -- Tantalizingly Large Golden Plum
    },
    pois={
        Path({74625754, 75095665, 75465542, 76015458, 76455372})
    }
}) -- Gilded Plum Chest

map.nodes[37726925] = Treasure({
    quest=61990,
    note=L["lost_quill_note"],
    rewards={
        Achievement({id=14314, criteria=50076}),
        Pet({item=182613, id=3008}) -- Lost Quill
    }
}) -- Lost Quill

map.nodes[29693723] = Treasure({
    quest=62198,
    requires=ns.requirement.Currency(1820, 30),
    rewards={
        Achievement({id=14314, criteria=50081}),
        Toy({item=182780}) -- Muckpool Cookpot
    }
}) -- Makeshift Muckpool

map.nodes[79993697] = Treasure({
    quest=62156,
    note=L["rapier_fearless_note"],
    rewards={
        Achievement({id=14314, criteria=50079})
    }
}) -- Rapier of the Fearless

map.nodes[61525864] = Treasure({
    quest=59885,
    note=L["remlates_cache_note"],
    rewards={
        Achievement({id=14314, criteria=50899})
    }
}) -- Remlate's Hidden Cache

map.nodes[31055506] = Treasure({
    quest=59889,
    note=L["smuggled_cache_note"],
    rewards={
        Achievement({id=14314, criteria=50895}),
        Item({item=182738, quest=62189}) -- Bundle of Smuggled Parasol Components
    }
}) -- Smuggled Cache

map.nodes[38394424] = Treasure({
    quest=61999,
    rewards={
        Achievement({id=14314, criteria=50077}),
        Toy({item=182694}) -- Stylish Black Parasol
    }
}) -- Stylish Parasol

map.nodes[63367398] = Treasure({
    quest=62199,
    note=L["taskmaster_trove_note"],
    rewards={
        Achievement({id=14314, criteria=50082}),
        Toy({item=183986}) -- Bondable Sinstone
    }
}) -- Taskmaster's Trove

map.nodes[57374337] = Treasure({
    quest=62063,
    requires=ns.requirement.Currency(1820, 99),
    note=L["the_count_note"],
    rewards={
        Achievement({id=14314, criteria=50078}),
        Pet({item=182612, id=3009}) -- The Count's Pendant
    }
}) -- The Count

map.nodes[70176005] = Treasure({
    quest=62164,
    note=L["dredglaive_note"],
    rewards={
        Achievement({id=14314, criteria=50080}),
        Transmog({item=177807, slot=L["warglaive"]}) -- Vyrtha's Dredglaive
    }
}) -- Vrytha's Dredglaive

map.nodes[68446445] = Treasure({
    quest=59884,
    rewards={
        Achievement({id=14314, criteria=50898})
    }
}) -- Wayfarer's Abandoned Spoils

-------------------------------------------------------------------------------

map.nodes[73597539] = Treasure({
    quest=62196,
    label=L["forgotten_anglers_rod"],
    rewards={
        Toy({item=180993}) -- Bat Visage Bobber
    }
}) -- Forgotten Angler's Rod

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[25263799] = PetBattle({
    id=173303,
    rewards={
        Achievement({id=14625, criteria=49409})
    }
}) -- Scorch

map.nodes[25662361] = PetBattle({
    id=175781,
    rewards={
        Achievement({id=14881, criteria=51051})
    }
}) -- Sewer Creeper

map.nodes[53004149] = PetBattle({
    id=175782,
    rewards={
        Achievement({id=14881, criteria=51052})
    }
}) -- The Countess

map.nodes[39945249] = PetBattle({
    id=173315,
    note=L["sylla_note"],
    rewards={
        Achievement({id=14625, criteria=49408}),
        ns.reward.Spacer(),
        Achievement({id=14868, criteria=1, oneline=true}), -- Aquatic
        Achievement({id=14869, criteria=1, oneline=true}), -- Beast
        Achievement({id=14870, criteria=1, oneline=true}), -- Critter
        Achievement({id=14871, criteria=1, oneline=true}), -- Dragon
        Achievement({id=14872, criteria=1, oneline=true}), -- Elemental
        Achievement({id=14873, criteria=1, oneline=true}), -- Flying
        Achievement({id=14874, criteria=1, oneline=true}), -- Humanoid
        Achievement({id=14875, criteria=1, oneline=true}), -- Magic
        Achievement({id=14876, criteria=1, oneline=true}), -- Mechanical
        Achievement({id=14877, criteria=1, oneline=true}), -- Undead
    }
}) -- Sylla

map.nodes[61354121] = PetBattle({
    id=173331,
    note=L["addius_note"],
    rewards={
        Achievement({id=14625, criteria=49406}),
        ns.reward.Spacer(),
        Achievement({id=14868, criteria=3, oneline=true}), -- Aquatic
        Achievement({id=14869, criteria=3, oneline=true}), -- Beast
        Achievement({id=14870, criteria=3, oneline=true}), -- Critter
        Achievement({id=14871, criteria=3, oneline=true}), -- Dragon
        Achievement({id=14872, criteria=3, oneline=true}), -- Elemental
        Achievement({id=14873, criteria=3, oneline=true}), -- Flying
        Achievement({id=14874, criteria=3, oneline=true}), -- Humanoid
        Achievement({id=14875, criteria=3, oneline=true}), -- Magic
        Achievement({id=14876, criteria=3, oneline=true}), -- Mechanical
        Achievement({id=14877, criteria=3, oneline=true}), -- Undead
    }
}) -- Addius the Tormentor

map.nodes[67626608] = PetBattle({
    id=173324,
    note=L["eyegor_note"],
    rewards={
        Achievement({id=14625, criteria=49407}),
        ns.reward.Spacer(),
        Achievement({id=14868, criteria=2, oneline=true}), -- Aquatic
        Achievement({id=14869, criteria=2, oneline=true}), -- Beast
        Achievement({id=14870, criteria=2, oneline=true}), -- Critter
        Achievement({id=14871, criteria=2, oneline=true}), -- Dragon
        Achievement({id=14872, criteria=2, oneline=true}), -- Elemental
        Achievement({id=14873, criteria=2, oneline=true}), -- Flying
        Achievement({id=14874, criteria=2, oneline=true}), -- Humanoid
        Achievement({id=14875, criteria=2, oneline=true}), -- Magic
        Achievement({id=14876, criteria=2, oneline=true}), -- Mechanical
        Achievement({id=14877, criteria=2, oneline=true}), -- Undead
    }
}) -- Eyegor

-------------------------------------------------------------------------------
---------------------------------- CARRIAGES ----------------------------------
-------------------------------------------------------------------------------

local Carriage = Class('Carriage', NPC, {
    icon = 'horseshoe_g',
    scale = 1.2,
    group = ns.groups.CARRIAGE
})

map.nodes[50217067] = Carriage({
    id=158365,
    rewards={ Achievement({id=14771, criteria=50170}) },
    pois={
        Path({
            61646948, 61317022, 60747099, 60097166, 59487245, 58747306,
            57937314, 57107308, 56317325, 55527318, 54907229, 54227157,
            53457133, 52567129, 51737135, 51037104, 50217067, 49777078,
            49087176, 48297197, 47527241, 46707290, 45867344, 45057385,
            44307361, 43667254, 43147164, 42447066, 41696959, 40976873,
            40386790, 40606672, 41056578, 41446465, 41596336, 41756230,
            42116124, 42836046, 43485973, 43605910
        })
    }
}) -- Banewood Carriage

map.nodes[54784842] = Carriage({
    id=174750,
    rewards={ Achievement({id=14771, criteria=50168}) },
    pois={
        Path({
            54784842, 53944909, 53044932, 52084962, 51335050, 50535120,
            49945193, 49285216, 48765143, 48035069, 47394964, 46944832,
            46764721, 47104691, 47564794, 47924913, 48475001, 48905053,
            49435025, 50045066, 50774996, 51544918, 52294866, 53184838,
            53994806, 54544773, 54784842
        })
    }
}) -- Chalice Carriage

map.nodes[63865885] = Carriage({
    id=158336,
    rewards={ Achievement({id=14771, criteria=50172}) },
    pois={
        Path({
            62535921, 62426040, 61806117, 61156162, 61326239, 62046252,
            62726224, 63436223, 64086263, 64866323, 65776393, 66626458,
            67516524, 68276591, 68206736, 67676828, 66806772, 65846757,
            65046796, 64276882, 63336907, 62526932, 61796934, 62216827,
            62706719, 63046602, 63436485, 63976392, 64526285, 64706183,
            64566066, 64405968, 63865885, 63015872, 62535921
        })
    }
}) -- Darkhaven Carriage

map.nodes[57263726] = Carriage({
    id=174751,
    rewards={ Achievement({id=14771, criteria=50169}) },
    pois={
        Path({
            57263726, 57513861, 57823963, 58434056, 58944093, 59414007,
            59173914, 58973790, 58983663, 59123533, 59563411, 59973304,
            60483221, 59913144, 59443176, 59063262, 58533367, 58083468,
            57583592, 57263726, 56503725, 55923724, 55293621, 54563601,
            53773623, 53713765, 53843907, 54674041, 55173969, 55593869,
            55923724
        })
    }
}) -- Old Gate Carriage

map.nodes[66727652] = Carriage({
    id=161879,
    rewards={ Achievement({id=14771, criteria=50171}) },
    pois={
        Path({
            73116864, 72506873, 71626856, 70786928, 69946991, 69096963,
            68356880, 67766840, 67166922, 66346979, 65297056, 65067173,
            65217324, 65447461, 66117565, 66727652, 67047776, 67487904,
            68358046, 68348124, 68568163, 68918168, 69188130, 69148075,
            68838042, 68358046
        })
    }
}) -- Pridefall Carriage

map.nodes[47694787] = Carriage({
    id=174754,
    rewards={ Achievement({id=14771, criteria=50173}) },
    pois={
        Path({
            46644671, 45864613, 45784494, 45354378, 44844287, 44374202,
            44394091, 44844006, 45353914, 45743800, 45723704, 45583628,
            46173554, 46853531, 47573540, 48223570, 48883619, 49673623,
            50393626, 51023641, 51573725, 52173818, 52383928, 52404036,
            52634155, 52384269, 52394388, 52024500, 51474591, 50764667,
            49954673, 49174676, 48464699, 47694787, 47134703, 46644671
        })
    }
}) -- The Castle Carriage

-------------------------------------------------------------------------------
------------------------------ CASTLE SINRUNNERS ------------------------------
-------------------------------------------------------------------------------

local Sinrunner = Class('Sinrunner', NPC, {
    icon = 'horseshoe_o',
    scale = 1.2,
    group = ns.groups.SINRUNNER
})

map.nodes[41304731] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria={50175,50176}}) },
    pois={
        Path({
            41304731, 41464669, 42054607, 41874510, 41124495, 40244475,
            39414432, 39064339, 39064170, 39054014, 39093895, 39633808,
            39973739, 39483657, 39063587, 39043502, 39513412, 40053319,
            40363272, 40853196, 41433106, 41833043, 42202985, 42732902,
            43232849, 43872849, 44512868, 45022906, 45063013, 45063112,
            45063208, 45053252, 45383261, 45343344, 45043348, 45053397,
            44853458, 44343536, 44153626, 43983713, 43883809, 43743902,
            44153988, 44034071, 43304079, 42684134, 42354225, 42034311,
            42044416, 42084502, 42054607
        })
    }
}) -- Hole in the Wall => Ramparts => Hole in the Wall

map.nodes[39464455] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria={50175,50176}}) },
    pois={
        Path({
            39464455, 39064339, 39064170, 39054014, 39093895, 39633808,
            39973739, 39483657, 39063587, 39043502, 39513412, 40053319,
            40363272, 40853196, 41433106, 41833043, 42202985, 42732902,
            43232849, 43872849, 44512868, 45022906, 45063013, 45063112,
            45063208, 45053252, 45383261, 45343344, 45043348, 45053397,
            44853458, 44343536, 44153626, 43983713, 43883809, 43743902,
            44153988, 44034071, 43304079, 42684134, 42354225, 42034311,
            42044416, 42084502, 42054607, 41464669, 41304731
        })
    }
}) -- The Abandoned Purlieu => Hole in the Wall

map.nodes[40153776] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria={50175,50176}}) },
    pois={
        Path({
            40153776, 39973739, 39483657, 39063587, 39043502, 39513412,
            40053319, 40363272, 40853196, 41433106, 41833043, 42202985,
            42732902, 43232849, 43872849, 44512868, 45022906, 45063013,
            45063112, 45063208, 45053252, 45383261, 45343344, 45043348,
            45053397, 44853458, 44343536, 44153626, 43983713, 43883809,
            43743902, 44153988, 44034071, 43304079, 42684134, 42354225,
            42034311, 42044416, 42084502, 42054607, 41464669, 41304731
        })
    }
}) -- Dominance Gate => Hole in the Wall

map.nodes[60346271] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50174}) },
    pois={
        Path({
            60346271, 59926265, 59296277, 58786286, 58176293, 57536310,
            56776328, 56156337, 55596351, 55246340, 55096242, 54966141,
            54826032, 54665928, 54485856, 54365781, 54255677, 54525588,
            54895519, 55475485, 56195445, 56775395, 57395347, 57945307,
            58375248, 58805183, 59025103, 58945013, 59014930, 59194847,
            59194760, 59194686, 59124605, 58964517, 58884437, 58824343,
            58794245, 58754166, 58804094, 59234033, 59433974, 59763915,
            60183876, 60633892, 60763966
        })
    }
}) -- Darkhaven => Old Gate

map.nodes[55246221] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50174}) },
    pois={
        Path({
            55246221, 54966141, 54826032, 54665928, 54485856, 54365781,
            54255677, 54525588, 54895519, 55475485, 56195445, 56775395,
            57395347, 57945307, 58375248, 58805183, 59025103, 58945013,
            59014930, 59194847, 59194760, 59194686, 59124605, 58964517,
            58884437, 58824343, 58794245, 58754166, 58804094, 59234033,
            59433974, 59763915, 60183876, 60633892, 60763966
        })
    }
}) -- Wildwall => Old Gate

map.nodes[71624105] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50177}) },
    pois={
        Path({
            71624105, 72164110, 72834061, 73464009, 73894112, 74404207,
            74984302, 75614371, 76374405, 76824489, 77044604, 77064722,
            77454830, 77504953, 77635068, 77265175, 76855266, 76435372,
            76045451, 75505532, 75165648, 74705738, 74095803, 73315796,
            72455795, 71685792, 70935796, 70305858, 69645824, 68525724,
            67825686, 67025699, 66165737, 65455787, 64735861, 64005885,
            63235874, 62585910, 62446025, 62436123, 62936212, 63396186
        })
    }
}) -- Absolution Crypt => Darkhaven

map.nodes[77394882] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50177}) },
    pois={
        Path({
            77394882, 77504953, 77635068, 77265175, 76855266, 76435372,
            76045451, 75505532, 75165648, 74705738, 74095803, 73315796,
            72455795, 71685792, 70935796, 70305858, 69645824, 68525724,
            67825686, 67025699, 66165737, 65455787, 64735861, 64005885,
            63235874, 62585910, 62446025, 62436123, 62936212, 63396186
        })
    }
}) -- Edge of Sin => Darkhaven

map.nodes[76365372] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50177}) },
    pois={
        Path({
            76365372, 76045451, 75505532, 75165648, 74705738, 74095803,
            73315796, 72455795, 71685792, 70935796, 70305858, 69645824,
            68525724, 67825686, 67025699, 66165737, 65455787, 64735861,
            64005885, 63235874, 62585910, 62446025, 62436123, 62936212,
            63396186
        })
    }
}) -- Edge of Sin => Darkhaven

map.nodes[69635800] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50177}) },
    pois={
        Path({
            69635800, 69115793, 68525724, 67825686, 67025699, 66165737,
            65455787, 64735861, 64005885, 63235874, 62585910, 62446025,
            62436123, 62936212, 63396186
        })
    }
}) -- Edge of Sin => Darkhaven

map.nodes[48836885] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50175}) },
    pois={
        Path({
            48836885, 48776937, 49306972, 49847016, 50256959, 50726915,
            51176855, 51566801, 52106783, 52626798, 53026849, 53466892,
            53926909, 54236859, 54266781, 54156698, 54036627, 53986562,
            53936490, 53986407, 54476370, 55086352, 55066266, 54916179,
            54846142, 54676026, 54505916, 54355828, 54195723, 53835626,
            53355546, 52575540, 51845510, 51225437, 50725358, 50225280,
            49595233, 48905194, 48365134, 47715199, 47205278, 46625368,
            46115446, 45655519, 45155587, 44515616, 43715627, 42995614,
            42295630, 41675639, 41035649, 40575560, 40125460, 39955357,
            39485259, 39245155, 39335039, 39724939, 40174839, 40564749,
            40844697
        })
    }
}) -- Wanecrypt Hill => Hole in the Wall

map.nodes[54926234] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50175}) },
    pois={
        Path({
            54926234, 54846142, 54676026, 54505916, 54355828, 54195723,
            53835626, 53355546, 52575540, 51845510, 51225437, 50725358,
            50225280, 49595233, 48905194, 48365134, 47715199, 47205278,
            46625368, 46115446, 45655519, 45155587, 44515616, 43715627,
            42995614, 42295630, 41675639, 41035649, 40575560, 40125460,
            39955357, 39485259, 39245155, 39335039, 39724939, 40174839,
            40564749, 40844697
        })
    }
}) -- Wildwall => Hole in the Wall

map.nodes[53535504] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50175}) },
    pois={
        Path({
            53535504, 52575540, 51845510, 51225437, 50725358, 50225280,
            49595233, 48905194, 48365134, 47715199, 47205278, 46625368,
            46115446, 45655519, 45155587, 44515616, 43715627, 42995614,
            42295630, 41675639, 41035649, 40575560, 40125460, 39955357,
            39485259, 39245155, 39335039, 39724939, 40174839, 40564749,
            40844697
        })
    }
}) -- Briar Gate => Hole in the Wall

map.nodes[44035641] = Sinrunner({
    id=174032,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14770, criteria=50175}) },
    pois={
        Path({
            44035641, 43715627, 42995614, 42295630, 41675639, 41035649,
            40575560, 40125460, 39955357, 39485259, 39245155, 39335039,
            39724939, 40174839, 40564749, 40844697
        })
    }
}) -- Charred Ramparts => Hole in the Wall

-------------------------------------------------------------------------------
------------------------------- DREDBAT STATUES -------------------------------
-------------------------------------------------------------------------------

local Dredbat = Class('Dredbat', NPC, {
    id=161015,
    icon='flight_point_g',
    group=ns.groups.DREDBATS,
    requires=ns.requirement.Currency(1820, 5),
    rewards={ Achievement({id=14769, criteria={id=1, qty=true}}) }
})

map.nodes[25103757] = Dredbat({ pois={ Arrow({25103757, 30024700}) } })
map.nodes[31905920] = Dredbat({ pois={ Arrow({31905920, 38954941}) } })
map.nodes[57246125] = Dredbat({ pois={ Arrow({57246125, 60286116}) } })
map.nodes[60396117] = Dredbat({ pois={ Arrow({60396117, 57495549}) } })
map.nodes[64076201] = Dredbat({ pois={ Arrow({64076201, 70125719}) } })
map.nodes[64076201] = Dredbat({ pois={ Arrow({64076201, 70125719}) } })

-------------------------------------------------------------------------------
------------------------------ ABSOLUTION FOR ALL -----------------------------
-------------------------------------------------------------------------------

local Fugitive = Class('Fugitive', NPC, {
    id=160149,
    icon=236247,
    note=L["fugitive_soul_note"],
    group=ns.groups.FUGITIVES,
    rewards={
        Achievement({id=14274, criteria={id=1, qty=true, suffix=L["souls_absolved"]}})
    }
})

map.nodes[65404450] = Fugitive()
map.nodes[65704610] = Fugitive()
map.nodes[65904250] = Fugitive()
map.nodes[68604460] = Fugitive()
map.nodes[70105630] = Fugitive()
map.nodes[70205500] = Fugitive()
map.nodes[70604340] = Fugitive()
map.nodes[70605200] = Fugitive()
map.nodes[70605200] = Fugitive()
map.nodes[70804400] = Fugitive()
map.nodes[71004180] = Fugitive()
map.nodes[71305350] = Fugitive()
map.nodes[71504690] = Fugitive()
map.nodes[71705440] = Fugitive()
map.nodes[72304440] = Fugitive()
map.nodes[72605510] = Fugitive()

local Ritualist = Class('Ritualist', NPC, {
    id=166150,
    icon=458226,
    note=L["avowed_ritualist_note"],
    group=ns.groups.FUGITIVES,
    rewards={
        Achievement({id=14274, criteria={id=1, qty=true, suffix=L["souls_absolved"]}})
    }
})

map.nodes[72505390] = Ritualist()
map.nodes[71704790] = Ritualist()
map.nodes[72004600] = Ritualist()
map.nodes[69304210] = Ritualist()
map.nodes[67204610] = Ritualist()
map.nodes[69204650] = Ritualist()

-------------------------------------------------------------------------------
------------------------ ITS ALWAYS SINNY IN REVENDRETH -----------------------
-------------------------------------------------------------------------------

local Inquisitor = Class('Inquisitor', Collectible, {
    icon=3528307,
    group=ns.groups.INQUISITORS,
    pois={ POI({72995199}) } -- Archivist Fane
})

map.nodes[76205210] = Inquisitor({
    id=159151,
    note=L["inquisitor_note"],
    requires=ns.requirement.Item(172999),
    rewards={
        Achievement({id=14276, criteria=48136})
    }
}) -- Inquisitor Traian

map.nodes[64704640] = Inquisitor({
    id=156918,
    note=L["inquisitor_note"],
    requires=ns.requirement.Item(172998),
    rewards={
        Achievement({id=14276, criteria=48135})
    }
}) -- Inquisitor Otilia

map.nodes[67304340] = Inquisitor({
    id=156919,
    note=L["inquisitor_note"],
    requires=ns.requirement.Item(172997),
    rewards={
        Achievement({id=14276, criteria=48134})
    }
}) -- Inquisitor Petre

map.nodes[69804720] = Inquisitor({
    id=156916,
    note=L["inquisitor_note"],
    requires=ns.requirement.Item(172996),
    rewards={
        Achievement({id=14276, criteria=48133})
    }
}) -- Inquisitor Sorin

map.nodes[75304420] = Inquisitor({
    id=159152,
    note=L["high_inquisitor_note"],
    requires=ns.requirement.Item(173000),
    rewards={
        Achievement({id=14276, criteria=48137})
    }
}) -- High Inquisitor Gabi

map.nodes[71204240] = Inquisitor({
    id=159153,
    note=L["high_inquisitor_note"],
    requires=ns.requirement.Item(173001),
    rewards={
        Achievement({id=14276, criteria=48138})
    }
}) -- High Inquisitor Radu

map.nodes[72105320] = Inquisitor({
    id=159155,
    note=L["high_inquisitor_note"],
    requires=ns.requirement.Item(173006),
    rewards={
        Achievement({id=14276, criteria=48140})
    }
}) -- High Inquisitor Dacian

map.nodes[69805230] = Inquisitor({
    id=159154,
    note=L["high_inquisitor_note"],
    requires=ns.requirement.Item(173005),
    rewards={
        Achievement({id=14276, criteria=48139})
    }
}) -- High Inquisitor Magda

map.nodes[69704540] = Inquisitor({
    id=159157,
    note=L["grand_inquisitor_note"],
    requires=ns.requirement.Item(173008),
    rewards={
        Achievement({id=14276, criteria=48142})
    }
}) -- Grand Inquisitor Aurica

map.nodes[64505270] = Inquisitor({
    id=159156,
    note=L["grand_inquisitor_note"],
    requires=ns.requirement.Item(173007),
    rewards={
        Achievement({id=14276, criteria=48141})
    }
}) -- Grand Inquisitor Nicu

-------------------------------------------------------------------------------
-------------------------------- LOYAL GORGER ---------------------------------
-------------------------------------------------------------------------------

-- Daily completion: 61843

map.nodes[59305700] = NPC({
    id=173499,
    icon=3601543,
    quest={
        61839, -- Nipping at the Undergrowth
        61840, -- Vineroot on the Menu
        61842, -- Vineroot Will Not Do
        61844, -- Hungry Hungry Gorger
        62044, -- Standing Toe to Toe
        62045, -- Ready for More
        62046  -- A New Pack
    },
    questDeps=61188,
    questCount=true,
    note=L["loyal_gorger_note"],
    rewards={
        Mount({item=182589, id=1391}) -- Loyal Gorger
    }
})

-------------------------------------------------------------------------------
------------------------------ SINRUNNER BLANCHY ------------------------------
-------------------------------------------------------------------------------

-- daily completed: 62107

local Blanchy = Class('Blanchy', NPC, {
    id=173468,
    icon=2143082,
    quest={62038, 62042, 62047, 62049, 62048, 62050},
    questCount=true,
    rewards={
        Mount({item=182614, id=1414}) -- Blanchy's Reins
    }
})

function Blanchy.getters:note ()
    local function status(i)
        if C_QuestLog.IsQuestFlaggedCompleted(self.quest[i]) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L["sinrunner_note"]
    note = note..'\n\n'..status(1)..' '..L["sinrunner_note_day1"]
    note = note..'\n\n'..status(2)..' '..L["sinrunner_note_day2"]
    note = note..'\n\n'..status(3)..' '..L["sinrunner_note_day3"]
    note = note..'\n\n'..status(4)..' '..L["sinrunner_note_day4"]
    note = note..'\n\n'..status(5)..' '..L["sinrunner_note_day5"]
    note = note..'\n\n'..status(6)..' '..L["sinrunner_note_day6"]
    return note
end

map.nodes[62874341] = Blanchy()
