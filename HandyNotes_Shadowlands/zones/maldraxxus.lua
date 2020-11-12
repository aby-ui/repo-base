-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale
local Class = ns.Class
local Map = ns.Map

local Collectible = ns.node.Collectible
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Transmog = ns.reward.Transmog
local Toy = ns.reward.Toy

local POI = ns.poi.POI

-------------------------------------------------------------------------------

local NECROLORD = ns.covenants.NEC

local map = Map({ id=1536, settings=true })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[52663542] = Rare({
    id=162727,
    quest=58870,
    rewards={
        Achievement({id=14308, criteria=48876})
    }
}) -- Bubbleblood

map.nodes[49012351] = Rare({
    id=159105,
    quest=58005,
    rewards={
        Achievement({id=14308, criteria=48866})
    }
}) -- Collector Kash

map.nodes[26392633] = Rare({
    id=157058,
    quest=58335,
    rewards={
        Achievement({id=14308, criteria=48872})
    }
}) -- Corpsecutter (Bonebreaker) Moroc

map.nodes[76835707] = Rare({
    id=162711,
    quest=58868,
    rewards={
        Achievement({id=14308, criteria=48851}),
        Pet({id=2953, item=181263}) -- Shy Melvin
    }
}) -- Deadly Dapperling

map.nodes[46734550] = Rare({
    id=162797,
    quest=58878,
    note=L["deepscar_note"],
    rewards={
        Achievement({id=14308, criteria=48852}),
        Transmog({item=182191, slot=L["1h_mace"]}) -- Slobber-Soaked Chew Toy
    },
    pois={
        POI({48125190, 53974548})
    }
}) -- Deepscar

map.nodes[45052842] = Rare({
    id=162669,
    quest=58835,
    rewards={
        Achievement({id=14308, criteria=48855})
    }
}) -- Devour'us

map.nodes[31603540] = Rare({
    id=162741,
    quest=58872,
    covenant=NECROLORD,
    requires=ns.requirement.GarrisonTalent(1250, L["anima_channeled"]),
    note=L["gieger_note"],
    rewards={
        Mount({item=182080, id=1411}) -- Predatory Bonejowl
    }
}) -- Gieger

map.nodes[57795155] = Rare({
    id=162588,
    quest=58837,
    note=L["gristlebeak_note"],
    rewards={
        Achievement({id=14308, criteria=48853}),
        Transmog({item=182196, slot=L["crossbow"]}) -- Arbalest of the Colossal Predator
    }
}) -- Gristlebeak

map.nodes[38794333] = Rare({
    id=161105,
    quest=58332,
    note=L["schmitd_note"],
    rewards={
        Achievement({id=14308, criteria=48848}),
        Transmog({item=182192, slot=L["plate"]}) -- Knee-Obstructing Legguards
    }
}) -- Indomitable Schmitd

map.nodes[72872891] = Rare({
    id=174108,
    quest=62369,
    rewards={
        Achievement({id=14308, criteria=49724})
    }
}) -- Necromantic Anomaly

map.nodes[66023532] = Rare({
    id=162690,
    quest=58851,
    rewards={
        Achievement({id=14308, criteria=49723}),
        Mount({item=182084, id=1373}) -- Gorespine
    }
}) -- Nerissa Heartless

map.nodes[53726132] = Rare({
    id=162767,
    quest=58875,
    rewards={
        Achievement({id=14308, criteria=48849}),
        Transmog({item=182205, slot=L["mail"]}) -- Scarab-Shell Faceguard
    }
}) -- Nirvaska the Summoner

map.nodes[50346328] = Rare({
    id=161857,
    quest=58629,
    rewards={
        Achievement({id=14308, criteria=48868})
    }
}) -- Pesticide

map.nodes[53841877] = Rare({
    id=159753,
    quest=58004,
    rewards={
        Achievement({id=14308, criteria=48865}),
        Pet({item=181283, id=2964}) -- Foulwing Hatchling
    }
}) -- Ravenomous

map.nodes[51744439] = Rare({
    id=168147,
    quest=58784,
    covenant=NECROLORD,
    requires=ns.requirement.GarrisonTalent(1253, L["anima_channeled"]),
    note=L["sabriel_note"],
    rewards={
        Achievement({id=14308, criteria=48874}),
        Achievement({id=14802, criteria=48874}),
        Mount({item=182083, id=1374}), -- Bonecleaver's Skullboar
        Mount({item=182075, id=1374}) -- Bonehoof Tauralus
    }
}) -- Sabriel the Bonecleaver

map.nodes[62107580] = Rare({
    id=158406,
    quest=58006,
    rewards={
        Achievement({id=14308, criteria=48857}),
        Pet({item=181267, id=2957}) -- Writhing Spine
    }
}) -- Scunner

map.nodes[55502361] = Rare({
    id=159886,
    quest=58003,
    note=L["chelicerae_note"],
    rewards={
        Achievement({id=14308, criteria=48873}),
        Pet({item=181172, id=2948}) -- Boneweave Hatchling
    }
}) -- Sister Chelicerae

map.nodes[42465345] = Rare({
    id=162528,
    quest=58768,
    rewards={
        Achievement({id=14308, criteria=48869}),
        Pet({item=181266, id=2956}), -- Bloodlouse Hatchling
        Pet({item=181265, id=2955}) -- Corpselouse Hatchling
    }
}) -- Smorgas the Feaster

map.nodes[44215132] = Rare({
    id=162586,
    quest=58783,
    rewards={
        Achievement({id=14308, criteria=48850}),
        Transmog({item=182190, slot=L["leather"]}), -- Tauralus Hide Collar
        Mount({item=181815, id=1370,}) -- Armored Bonehoof Tauralus
    }
}) -- Tahonta

map.nodes[50562011] = Rare({
    id=160059,
    quest=58091,
    note=L["taskmaster_xox_note"],
    rewards={
        Achievement({id=14308, criteria=48867})
    }
}) -- Taskmaster Xox

map.nodes[24184297] = Rare({
    id=162180,
    quest=58678,
    note=L["leeda_note"],
    rewards={
        Achievement({id=14308, criteria=48870}),
        Transmog({item=184180, slot=L["cloth"]})
    }
}) -- Thread Mistress Leeda

map.nodes[33538086] = Rare({
    id=162819,
    quest=nil,
    note=L["malkorak_note"],
    rewards={
        Achievement({id=14308, criteria=48875}),
        Mount({item=182085, id=1372}) -- Umbral Bloodtusk
    }
}) -- Warbringer Mal'Korak

map.nodes[28965138] = Rare({
    id=157125,
    quest=62079,
    requires=ns.requirement.Item(175841),
    note=L["zargox_the_reborn_note"],
    rewards={
        Achievement({id=14308, criteria=48864})
    },
    pois={
        POI({26314280})
    }
}) -- Zargox the Reborn

------------------------- POOL OF MIXED MONSTROSITIES -------------------------

local OOZE = "|T646670:0|t"
local GOO = "|T136007:0|t"
local OIL = "|T136124:0|t"

map.nodes[58197421] = Rare({
    id=157226,
    quest={61718, 61719, 61720, 61721, 61722, 61723, 61724},
    questCount=true,
    note=L["mixed_pool_note"],
    rewards = {
        Achievement({id=14721, criteria={
            {id=48858, quest=61721, note=OOZE..' > '..GOO..' '..OIL}, -- Gelloh
            {id=48863, quest=61719, note=GOO..' > '..OOZE..' '..OIL}, -- Corrupted Sediment
            {id=48854, quest=61718, note=OIL..' > '..OOZE..' '..GOO}, -- Pulsing Leech
            {id=48860, quest=61722, note='('..OOZE..' = '..GOO..') > '..OIL}, -- Boneslurp
            {id=48862, quest=61723, note='('..OOZE..' = '..OIL..') > '..GOO}, -- Burnblister
            {id=48861, quest=61720, note='('..GOO..' = '..OIL..') > '..OOZE}, -- Violet Mistake
            {id=48859, quest=61724, note=OOZE..' = '..GOO..' = '..OIL}, -- Oily Invertebrate
        }}),
        Mount({item=182079, id=1410, note=L["Violet"]}), -- Slime-Covered Reins of the Hulking Deathroc
        Pet({item=181270, id=2960, note=L["Oily"]}) -- Decaying Oozewalker
    }
})

------------------------------- THEATER OF PAIN -------------------------------

map.nodes[50354728] = Rare({
    id=162853,
    quest=62786,
    label=C_Map.GetMapInfo(1683).name,
    rewards = {
        Achievement({id=14802, criteria={
            50397, -- Azmogal
            50398, -- Unbreakable Urtz
            50399, -- Xantuth the Blighted
            50400, -- Mistress Dyrax
            50402, -- Devmorta
            50403, -- Ti'or
            48874  -- Sabriel the Bonecleaver
        }})
    }
})

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[44083989] = Treasure({
    quest=60368,
    label=L["blackhound_cache"]
}) -- Blackhound Cache

map.nodes[36797862] = Treasure({
    label=L["bladesworn_supply_cache"]
}) -- Bladesworn Supply Cache

map.nodes[54011234] = Treasure({
    quest=nil,
    label=L["cache_of_eyes"],
    note=L["cache_of_eyes_note"],
    rewards={
        -- Achievement({id=14312, criteria=50070}),
        Pet({item=181171, id=2947}) -- Luminous Webspinner
    }
}) -- Cache of Eyes

map.nodes[49441509] = Treasure({
    quest=59244,
    rewards={
        Achievement({id=14312, criteria=50070}),
        Item({item=183696}) -- Sp-eye-glass
    }
}) -- Chest of Eyes

Map({id=1649}).nodes[34565549] = Treasure({
    quest=58710,
    note=L["forgotten_mementos"],
    parent=map.id,
    rewards={
        Achievement({id=14312, criteria=50069})
    },
    pois={
        POI({25815353}) -- Vault Portcullis Chain
    }
}) -- Forgotten Mementos

map.nodes[41511953] = Treasure({
    quest=62602, -- Currently account-wide? Spinebug is lootable on alts but treasure is gone
    label=L["giant_cache_of_epic_treasure"],
    note=L["spinebug_note"],
    rewards={
        Pet({id=3047}) -- Spinebug
    }
}) -- Giant Cache of Epic Treasure

map.nodes[72895365] = Treasure({
    quest=61484,
    note=L["glutharns_note"],
    rewards={
        Achievement({id=14312, criteria=50072})
    }
}) -- Glutharn's Stash

map.nodes[30792874] = Treasure({
    quest=60730,
    rewards={
        Achievement({id=14312, criteria=50065})
    }
}) -- Halis's Lunch Pail

map.nodes[32742127] = Treasure({
    quest=60587,
    note=L["kyrian_keepsake_note"],
    rewards={
        Achievement({id=14312, criteria=50064}),
        Item({item=180085}),
        Item({item=175708, note=L["neck"]})
    }
}) -- Kyrian Keepsake

map.nodes[62505990] = Treasure({
    quest=59245,
    note=L["misplaced_supplies"],
    rewards={
        Achievement({id=14312, criteria=50071}),
    },
    pois={
        POI({61925851}) -- Way up
    }
}) -- Misplaced Supplies

map.nodes[42382333] = Treasure({
    quest=61470,
    note=L["necro_tome_note"],
    rewards={
        Achievement({id=14312, criteria=50068}),
        Toy({item=182732}) -- The Necronom-i-nom
    },
    pois={
        POI({40693305}) -- NPC location
    }
}) -- Necro Tome

map.nodes[47236216] = Treasure({
    quest=59358,
    rewards={
        Achievement({id=14312, criteria=50063}),
        Transmog({item=180749, slot=L["shield"]}) -- Hauk's Battle-Scarred Bulwark
    }
}) -- Ornate Bone Shield

map.nodes[57667581] = Treasure({
    quest=61474,
    note=L["plaguefallen_chest_note"],
    rewards={
        Achievement({id=14312, criteria=50074}),
        Pet({item=183515, id=3045}) -- Reanimated Plague
    },
    pois={
        POI({62487656})
    }
}) -- Plaguefallen Chest

map.nodes[64672475] = Treasure({
    quest=61514,
    requires=ns.requirement.Spell(337041),
    note=L["ritualists_cache_note"],
    rewards={
        Achievement({id=14312, criteria=50075}),
        Item({item=183517, quest=62372}) -- Page 76 of the Necronom-i-nom
    },
    pois={
        POI({69873103, 69073250, 71473663}), -- Bone Pile
        POI({71733540}) -- Book of Binding Ritials
    }
}) -- Ritualist's Cache

map.nodes[31737004] = Treasure({
    quest=61491,
    requires=ns.requirement.Item(181777),
    note=L["runespeakers_trove_note"],
    rewards={
        Achievement({id=14312, criteria=50073}),
        Transmog({item=183516, slot=L['cloth']}) -- Stained Bonefused Mantle
    },
    pois={
        POI({37867013})
    }
}) -- Runespeaker's Trove

map.nodes[73564986] = Treasure({
    quest=61451,
    note=L["stolen_jar_note"],
    rewards={
        Achievement({id=14312, criteria=50067}),
        Item({item=182618, quest=62085}) -- ... Why Me?
    }
}) -- Stolen Jar

map.nodes[55893897] = Treasure({
    quest={59428,59429},
    label='{npc:165037}',
    note=L["strange_growth_note"],
    rewards={
        --Item({item=182607}), -- Hairy Egg
        Pet({item=182606, id=3013}) -- Bloodlouse Larva
    }
}) -- Strange Growth

map.nodes[59867906] = Treasure({
    quest=61444,
    note=L["vat_of_slime_note"],
    rewards={
        Achievement({id=14312, criteria=50066}),
        Toy({item=181825}) -- Phial of Ravenous Slime
    }
}) -- Vat of Conspicuous Slime

map.nodes[51444848] = Treasure({
    quest={61127,61128}, -- {arm, sword}
    questCount=true,
    note=L["oonar_sorrowbane_note"],
    rewards={
        Achievement({id=14626, criteria=0}),
        Pet({item=181164, id=2944}), -- Oonar's Arm
        Transmog({item=180273, slot=L["2h_sword"]}), --Sorrowbane
    },
    pois={
        POI({50945317, 37114699, 53634792, 76445672})
    }
}) -- Oonar's Arm and Sorrowbane

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[34005526] = PetBattle({
    id=173263,
    rewards={
        Achievement({id=14625, criteria=49412})
    }
}) -- Rotgut

map.nodes[46865000] = PetBattle({
    id=173257,
    rewards={
        Achievement({id=14625, criteria=49413})
    }
}) -- Caregiver Maximillian

map.nodes[54062806] = PetBattle({
    id=173274,
    rewards={
        Achievement({id=14625, criteria=49410})
    }
}) -- Gorgemouth

map.nodes[63234687] = PetBattle({
    id=173267,
    rewards={
        Achievement({id=14625, criteria=49411})
    }
}) -- Dundley Stickyfingers

-------------------------------------------------------------------------------
------------------------------- NINE AFTERLIVES -------------------------------
-------------------------------------------------------------------------------

local Kitten = Class('Kitten', Collectible, {
    sublabel = L["pet_cat"],
    icon = 3732497, -- inv_catslime
    group = ns.groups.SLIME_CAT
})

map.nodes[65225065] = Kitten({id=174224, rewards={
    Achievement({id=14634, criteria=49428})
}}) -- Envy

map.nodes[51002750] = Kitten({id=174230, rewards={
    Achievement({id=14634, criteria=49430})
}, note=L["lime"]}) -- Lime

map.nodes[49461761] = Kitten({id=174234, rewards={
    Achievement({id=14634, criteria=49431})
}}) -- Mayhem

map.nodes[34305310] = Kitten({id=174237, rewards={
    Achievement({id=14634, criteria=49433})
}}) -- Meowmalade

map.nodes[47533375] = Kitten({id=174236, rewards={
    Achievement({id=14634, criteria=49432})
}, note=L["moldstopheles"]}) -- Moldstopheles

map.nodes[64802240] = Kitten({id=174226, rewards={
    Achievement({id=14634, criteria=49429})
}}) -- Mr. Jigglesworth

map.nodes[50246027] = Kitten({id=174223, rewards={
    Achievement({id=14634, criteria=49427})
}, note=L["pus_in_boots"]}) -- Pus-In-Boots

map.nodes[32005700] = Kitten({id=174221, rewards={
    Achievement({id=14634, criteria=49426})
}}) -- Snots

Map({id=1697}).nodes[45203680] = Kitten({id=174195, parent=map.id, rewards={
    Achievement({id=14634, criteria=49425})
}, note=L["hairball"]}) -- Hairball
