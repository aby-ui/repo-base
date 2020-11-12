-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

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
        Transmog({item=179924, slot=L["leather"]}), -- Light-Infused Jacket
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
    quest=nil,
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
        Item({item=180696}), -- Legion Wing Insignia
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
        Mount({item=180581, id=1298}) -- Harnessed Hopecrusher
    }
}) -- Hopecrusher

map.nodes[61717949] = Rare({
    id=166993,
    quest=60022,
    rewards={
        Achievement({id=14310, criteria=48820}),
        Item({item=180705}), -- Gargon Training Manual
        Item({item=180704}) -- Infused Pet Biscuit
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
        Transmog({item=183736, slot=L["cloth"]}),
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
        Item({item=180677}), -- Discarded Medal of Valor
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
        Achievement({id=14310, criteria=48799}),
        Item({item=180692}) -- Box of Stalker Traps
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
        Pet({item=180584, id=2891}) -- Rose Spiderling
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

-- Stoneguard Satchel (76226410) (60896,60939)
-- Reliquary of Remembrance (79763376) (item=180403)
-- Unimplemented treasure? (50244910)

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
        Achievement({id=14314, criteria=50897}),
        Item({item=179392}) -- Orb of Burgeoning Ambition
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
        Achievement({id=14314, criteria=50084})
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
    quest=nil,
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

-- Not at this location for me -Zar
-- map.nodes[30342472] = Treasure({
--     quest=60665,
--     label=L["bleakwood_chest"],
--     rewards={
--         Pet({item=180592, id=2901}), -- Trapped Stonefiend
--         Transmog({item=182720, slot=L["mail"]}), -- Mail Courier's Tunic
--         Transmog({item=180398, slot=L["polearm"]}) -- Stonewrought Legion Halberd
--     }
-- }) -- Bleakwood Chest

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

map.nodes[39945249] = PetBattle({
    id=173315,
    rewards={
        Achievement({id=14625, criteria=49408})
    }
}) -- Sylla

map.nodes[61354121] = PetBattle({
    id=173331,
    rewards={
        Achievement({id=14625, criteria=49406})
    }
}) -- Addius the Tormentor

map.nodes[67626608] = PetBattle({
    id=173324,
    rewards={
        Achievement({id=14625, criteria=49407})
    }
}) -- Eyegor

-------------------------------------------------------------------------------
---------------------------- THE AFTERLIFE EXPRESS ----------------------------
-------------------------------------------------------------------------------

local Carriage = Class('Carriage', NPC, {
    icon = 'horseshoe',
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

map.nodes[52634155] = Carriage({
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
    local note = L["sinrunner_note"]
    local status
    for i, quest in ipairs(self.quest) do
        if C_QuestLog.IsQuestFlaggedCompleted(quest) then
            status = ns.status.Green(i)
        else
            status = ns.status.Red(i)
        end
        note = note..'\n\n'..status..' '..L["sinrunner_note_day"..i]
    end
    return note
end

map.nodes[62874341] = Blanchy()
