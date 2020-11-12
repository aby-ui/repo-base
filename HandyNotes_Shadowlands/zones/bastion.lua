-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local Node = ns.node.Node
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

local KYRIAN = ns.covenants.KYR

local map = Map({ id = 1533, settings=true })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[32592336] = Rare({
    id=171211,
    quest=61083,
    requires=ns.requirement.Item(180613),
    note=L["aspirant_eolis_note"],
    rewards={
        Achievement({id=14307, criteria=50613}),
        Transmog({item=183607, slot=L["polearm"]}) -- Uncertain Aspirant's Spear
    },
    pois={
        POI({
            31412295, 31412386, 32052123, 32122305, 32332113, 32562449,
            32762035, 33062071, 33172321,
        }) -- Fragile Humility Scroll
    }
}) -- Aspirant Eolis

map.nodes[51344080] = Rare({
    id=160629,
    quest={58648,62192},
    note=L["baedos_note"],
    rewards={
        Achievement({id=14307, criteria=50592})
    }
}) -- Baedos

map.nodes[48985031] = Rare({
    id=170659,
    quest={60897,62158},
    note=L["basilofos_note"],
    rewards={
        Achievement({id=14307, criteria=50602}),
        Toy({item=182655}) -- Hill King's Roarbox
    }
}) -- Basilofos, King of the Hill

map.nodes[55358024] = Rare({
    id=161527,
    label=L["beasts_of_bastion"],
    note=L["beasts_of_bastion_note"],
    quest={60570, 60571, 60569, 58526},
    questCount=true,
    rewards = {
        Achievement({id=14307, criteria={
            {id=50597, quest=60570}, -- Sigilback
            {id=50598, quest=60571}, -- Cloudtail
            {id=50599, quest=60569}, -- Nemaeus
            {id=50617, quest=58526}, -- Aethon
        }}),
        Toy({item=174445}), -- Glimmerfly Cocoon
        Transmog({item=179485, slot=L["dagger"]}), -- Fang of Nemaeus
        Transmog({item=179486, slot=L["1h_mace"]}), -- Sigilback's Smashshell
        Transmog({item=179487, slot=L["warglaive"]}), -- Aethon's Horn
        Transmog({item=179488, slot=L["fist"]}), -- Cloudtail's Paw
    }
}) -- Beasts of Bastion

map.nodes[55826249] = Rare({
    id=171189,
    quest={59022,62167},
    note=L["bookkeeper_mnemis_note"],
    rewards={
        Achievement({id=14307, criteria=50612}),
        Item({item=182682, note=L["trinket"]}) -- Book-Borrower Identification
    }
}) -- Bookkeeper Mnemis

map.nodes[50435804] = Rare({
    id=170932,
    quest={60978,62191},
    note=L["cloudfeather_patriarch_note"],
    rewards={
        Achievement({id=14307, criteria=50604}),
        Pet({item=180812, id=2925}) -- Golden Teroclaw
    }
}) -- Cloudfeather Guardian

map.nodes[66004367] = Rare({
    id=171014,
    quest=61002,
    note=L["collector_astor_note"],
    rewards={
        Achievement({id=14307, criteria=50610})
    },
    pois={
        POI({
            -- 66194411, Mercia's Legacy: Chapter One
            -- 65904411, Mercia's Legacy: Chapter Two
            -- 65734396, Mercia's Legacy: Chapter Three
            -- 65734345, Mercia's Legacy: Chapter Four
            -- 65934316, Mercia's Legacy: Chapter Five
            -- 66204327, Mercia's Legacy: Chapter Six
            64174218 -- Mercia's Legacy: Chapter Seven
        })
    }
}) -- Collector Astorestes

map.nodes[56904778] = Rare({
    id=171010,
    quest=60999,
    requires=ns.requirement.Item(180651),
    note=L["corrupted_clawguard_note"],
    rewards={
        Achievement({id=14307, criteria=50615})
    },
    pois={
        POI({55004125}) -- Forgefire Outpost
    }
}) -- Corrupted Clawguard

map.nodes[27823014] = Rare({
    id=170623,
    quest=60883,
    note=L["dark_watcher_note"],
    rewards={
        Achievement({id=14307, criteria=50603})
        -- also dropped class-specific finesse conduits
    }
}) -- Dark Watcher

map.nodes[37004180] = Rare({
    id=171011,
    quest={61069,61000},
    note=L["demi_hoarder_note"],
    rewards={
        Achievement({id=14307, criteria=50611})
    },
    pois={
        Path({
            37004180, 37714171, 37944069, 38484042, 39004077, 39354145,
            39854155, 40334106, 40424024, 40733931, 41233883
        })
    }
}) -- Demi the Relic Hoarder

map.nodes[41354887] = Rare({
    id=163460,
    quest=62650,
    note=L["in_small_cave"]..' '..L["dionae_note"],
    rewards={
        Achievement({id=14307, criteria=50595})
    }
}) -- Dionae

map.nodes[45546459] = Rare({
    id=171255,
    quest={61082,61091,62251},
    rewards={
        Achievement({id=14307, criteria=50614}),
        Item({item=180062}) -- Heavenly Drum
    },
    pois={
        Path({45546459, 44656486, 44766596, 45366670, 45866643, 45616562})
    }
}) -- Echo of Aella <Hand of Courage>

map.nodes[51151953] = Rare({
    id=171009,
    quest=60998,
    rewards={
        Achievement({id=14307, criteria=50605})
    },
    pois={
        Path({
            51151953, 50761914, 50681837, 50731769, 50931703, 51351673,
            51881686, 52251724, 52451799, 52351868, 52051918, 51651962,
            51151953
        })
    }
}) -- Enforcer Aegeon

map.nodes[60427305] = Rare({
    id=160721,
    quest=58222,
    rewards={
        Achievement({id=14307, criteria=50596}),
        Transmog({item=180444, slot=L["leather"]}) -- Harmonia's Chosen Belt
    },
    pois={
        Path({60137285, 60427305, 60597376})
    }
}) -- Fallen Acolyte Erisne

map.nodes[42908265] = Rare({
    id=158659,
    quest={57705,57708},
    note=L["herculon_note"],
    requires=ns.requirement.Item(172451, 10),
    rewards={
        Achievement({id=14307, criteria=50582})
    }
}) -- Herculon

map.nodes[51456859] = Rare({
    id=160882,
    quest=58319,
    note=L["nikara_note"],
    rewards={
        Achievement({id=14307, criteria=50594}),
        Transmog({item=183608, slot=L["offhand"]}) -- Evernote Vesper
    }
}) -- Nikara Blackheart

map.nodes[30365517] = Rare({
    id=171327,
    quest=nil,
    note=L["activation_unknown"],
    rewards={
        Achievement({id=14307, criteria=50616}),
    }
}) -- Reekmonger

map.nodes[61295090] = Rare({
    id=160985,
    quest=58320,
    note=L["nikara_note"],
    rewards={
        Achievement({id=14307, criteria=50593}),
        Transmog({item=183608, slot=L["offhand"]}) -- Evernote Vesper
    }
}) -- Selena the Reborn

local Sotirstus = Class('Sotirstus', Rare)

function Sotirstus.getters:label ()
    return GetAchievementCriteriaInfoByID(14307, 50618) or UNKNOWN
end

map.nodes[22432285] = Sotirstus({
   id=156339,
   quest=61634,
   covenant=KYRIAN,
   requires=ns.requirement.GarrisonTalent(1241, L["anima_channeled"]),
   note=L["sotiros_orstus_note"],
   rewards={
       Achievement({id=14307, criteria=50618})
   }
}) -- Orstus and Sotiros

map.nodes[61409050] = Rare({
    id=170548,
    quest=nil,
    note=L["sundancer_note"],
    rewards={
        Achievement({id=14307, criteria=50601}),
        Mount({item=180773, id=1307}) -- Sundancer
    },
    pois={
        Path({
            58209700, 61009560, 61609340, 61409050,
            61708710, 62808430, 62508060, 61107910
        }),
        POI({60049398}) -- Buff?
    }
}) -- Sundancer

map.nodes[63503590] = Rare({
    id=171012,
    quest={61001,61046,61047},
    questCount=true,
    note=L["swelling_tear_note"],
    rewards={
        Achievement({id=14307, criteria={
            {id=50607, quest=61001}, -- Embodied Hunger
            {id=50609, quest=61047}, -- Worldfeaster Chronn
            {id=50608, quest=61046}, -- Xixin the Ravening
        }}),
        Transmog({item=183605, slot=L["warglaive"]}) -- Devourer Wrought Warglaive
    },
    pois={
        POI({47434282, 52203280, 56031463, 59825165, 63503590})
    }
}) -- Swelling Tear

map.nodes[43482524] = Rare({
    id=171008,
    quest=60997,
    note=L["unstable_memory_note"],
    rewards={
        Achievement({id=14307, criteria=50606})
    }
}) -- Unstable Memory

map.nodes[40635306] = Rare({
    id=167078,
    quest={60314,62197},
    covenant=KYRIAN,
    requires=ns.requirement.GarrisonTalent(1238, L["anima_channeled"]),
    note=L["wingflayer_note"],
    rewards={
        Achievement({id=14307, criteria=50600}),
        Item({item=182749}) -- Regurgitated Kyrian Wings
    }
}) -- Wingflayer the Cruel

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- Treasure of Courage (27051932)
-- Treasure of Purity (26852473)
-- Treasure of Humility (24662039)
-- Treasure of Wisdom (23652548)

map.nodes[46114536] = Treasure({
    quest=61006,
    note=L["in_cave"],
    rewards={
        Achievement({id=14311, criteria=50053})
    },
    pois={
            POI({46454661}) -- Entrance
    }
}) -- Abandoned Stockpile

map.nodes[35834811] = Treasure({
    quest=61053,
    requires=ns.requirement.Item(180536),
    note=L["broken_flute"],
    rewards={
        Achievement({id=14311, criteria=50055}),
        Item({item=180064}) -- Ascended Flute
    }
}) -- Broken Flute

map.nodes[53498880] = Treasure({
    quest=60977, -- 60933 makes the chest visible
    label=L["cache_of_the_ascended"],
    note=L["cache_of_the_ascended_note"],
    rewards={
        Achievement({id=14307, criteria=50619}),
        ns.reward.Spacer(),
        Achievement({id=14734, criteria={49818, 49815, 49816, 49819, 49817} }),
        Mount({item=183741, id=1426}) -- Ascended Skymane
    },
    pois={
        POI({
            64326980, -- Vesper of Purity
            33325980, -- Vesper of Courage
            71933896, -- Vesper of Humility
            39132038, -- Vesper of Wisdom
            32171776, -- Vesper of Loyalty
        })
    }
}) -- Cache of the Ascended

map.nodes[51471795] = Treasure({
    quest=61052,
    requires=ns.requirement.Item(180534),
    note=L["experimental_construct_part"],
    rewards={
        Achievement({id=14311, criteria=50054}),
        Transmog({item=183609, slot=L["fist"]}) -- Re-Powered Golliath Fists
    },
    pois={
        POI({53541715, 53141903}) -- Unstable Anima Core
    }
}) -- Experimental Construct Part

map.nodes[35085805] = Treasure({
    quest=60893,
    requires=ns.requirement.Spell(333063),
    note=L["gift_of_agthia"],
    rewards={
        Achievement({id=14311, criteria=50058}),
        Item({item=180063}) -- Unearthly Chime
    },
    pois={
        Path({39085448, 38455706, 37405674, 37115684, 35165822})
    }
}) -- Gift of Agthia

map.nodes[70473645] = Treasure({
    quest=60892,
    requires=ns.requirement.Spell(333045),
    note=L["gift_of_chyrus"],
    rewards={
        Achievement({id=14311, criteria=50060})
    },
    pois={
        POI({69374031})
    }
}) -- Gift of Chyrus

map.nodes[27602179] = Treasure({
    quest=60895,
    requires=ns.requirement.Spell(333070),
    note=L["gift_of_devos"],
    rewards={
        Achievement({id=14311, criteria=50062}),
        Item({item=179977}) -- Benevolent Gong
    },
    pois={
        Path({
            23932482, 24712512, 25232402, 25832329, 25792226, 25192140,
            25732097, 26552137, 27122130, 27102031, 27452003, 27702102,
            27602179
        }) -- Suggested path
    }
}) -- Gift of Devos

map.nodes[40601890] = Treasure({
    quest=60894,
    requires=ns.requirement.Spell(333068),
    note=L["gift_of_thenios"],
    rewards={
        Achievement({id=14311, criteria=50061})
    },
    pois={
        POI({41662331, 39551900}) -- Transport platform
}}) -- Gift of Thenios

map.nodes[64877114] = Treasure({
    quest=60890,
    requires=ns.requirement.Spell(332785),
    note=L["gift_of_vesiphone"],
    rewards={
        Achievement({id=14311, criteria=50059}),
        Pet({item=180859, id=2935}) -- White Vulpin
    }
}) -- Gift of Vesiphone

map.nodes[58233999] = Treasure({
    quest=61049,
    note=L["larion_harness"],
    rewards={
        Achievement({id=14311, criteria=50051}),
        Item({item=182652})
    },
    pois={
        POI({55694287}) -- Entrance
    }
}) -- Larion Tamer's Harness

map.nodes[59336092] = Treasure({
    quest=61048,
    rewards={
        Achievement({id=14311, criteria=50050}),
        Item({item=182693, quest=62170}) -- You'll Never Walk Alone
    }
}) -- Lost Disciple's Notes

map.nodes[56481714] = Treasure({
    quest=61150,
    requires=ns.requirement.Item(180797),
    note=L["memorial_offering"],
    rewards={
        Achievement({id=14311, criteria=50056})
    },
    pois={
        POI({
            56851899, -- Drink Tray
        })
    }
}) -- Memorial Offering
--Kobri coordinate 47967389

map.nodes[52038607] = Treasure({
    quest=58329,
    rewards={
        Achievement({id=14311, criteria=50049}),
        Item({item=174007})
    }
}) -- Purifying Draught

-- 58292 (purians), 58294 (first offer), 58293 (second offer)
map.nodes[53508037] = Treasure({
    quest=58298,
    note=L["scroll_of_aeons"],
    rewards={
        Achievement({id=14311, criteria=50047}),
        Toy({item=173984}) -- Scroll of Aeons
    },
    pois={
        POI({54428387, 56168305})
    }
}) -- Scroll of Aeons

map.nodes[40504980] = Treasure({
    quest=61044,
    rewards={
        Achievement({id=14311, criteria=50052}),
        Transmog({item=182561, slot=L["cloak"]}) -- Fallen Disciple's Cloak
    }
}) -- Stolen Equipment

map.nodes[36012652] = Treasure({
    quest=61183,
    requires=ns.requirement.Item(180858),
    note=L["vesper_of_silver_wind"],
    rewards={
        Mount({item=180772, id=1404}) -- Silverwind Larion
    }
}) -- Vesper of the Silver Wind
-- 61229 (mallet forged)
-- 61191 (vesper rung)

map.nodes[58667135] = Treasure({
    quest=60478,
    rewards={
        Achievement({id=14311, criteria=50048}),
        Item({item=179982}) -- Kyrian Bell
    }
}) -- Vesper of Virtues

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[34806280] = PetBattle({
    id=173131,
    rewards={
        Achievement({id=14625, criteria=49416})
    }
}) -- Stratios

map.nodes[36603180] = PetBattle({
    id=173133,
    rewards={
        Achievement({id=14625, criteria=49417})
    }
}) -- Jawbone

map.nodes[51393833] = PetBattle({
    id=173130,
    rewards={
        Achievement({id=14625, criteria=49415})
    }
}) -- Zolla

map.nodes[54555609] = PetBattle({
    id=173129,
    rewards={
        Achievement({id=14625, criteria=49414})
    }
}) -- Thenia

-------------------------------------------------------------------------------
----------------------------- ANIMA CRYSTAL SHARDS ----------------------------
-------------------------------------------------------------------------------

local AnimaShard = Class('AnimaShard', Node, {
    label = L["anima_shard"],
    icon = 'crystal_b',
    scale = 1.5,
    group = ns.groups.ANIMA_SHARD,
    rewards = {
        Achievement({id=14339, criteria={
            {id=0, qty=true, suffix=L["anima_shard"]}
        }})
    }
})

map.nodes[39057704] = AnimaShard({quest=61225, note=L["anima_shard_61225"]})
map.nodes[43637622] = AnimaShard({quest=61235, note=L["anima_shard_61235"]})
map.nodes[48427273] = AnimaShard({quest=61236, note=L["anima_shard_61236"]})
map.nodes[52677555] = AnimaShard({quest=61237, note=L["anima_shard_61237"]})
map.nodes[53317362] = AnimaShard({quest=61238, note=L["anima_shard_61238"]})
map.nodes[53498060] = AnimaShard({quest=61239, note=L["anima_shard_61239"]})
map.nodes[55968666] = AnimaShard({quest=61241, note=L["anima_shard_61241"]})
map.nodes[61048566] = AnimaShard({quest=61244, note=L["anima_shard_61244"]})
map.nodes[58108008] = AnimaShard({quest=61245, note=L["anima_shard_61245"]})
map.nodes[56877498] = AnimaShard({quest=61247, note=L["anima_shard_61247"]})
map.nodes[65527192] = AnimaShard({quest=61249, note=L["anima_shard_61249"],
    pois={
        POI({63467240}) -- Transport platform
    }
})
map.nodes[58156391] = AnimaShard({quest=61250, note=L["anima_shard_61250"]})
map.nodes[54005970] = AnimaShard({quest=61251, note=L["anima_shard_61251"]})
map.nodes[46706595] = AnimaShard({quest=61253, note=L["anima_shard_61253"]})
map.nodes[50685614] = AnimaShard({quest=61254, note=L["anima_shard_61254"]})
map.nodes[34846578] = AnimaShard({quest=61257, note=L["anima_shard_61257"]})
map.nodes[51674802] = AnimaShard({quest=61258, note=L["anima_shard_61258"]})
map.nodes[47084923] = AnimaShard({quest=61260, note=L["anima_shard_61260"]})
map.nodes[41394663] = AnimaShard({quest=61261, note=L["anima_shard_61261"]})
map.nodes[40045912] = AnimaShard({quest=61263, note=L["anima_shard_61263"]})
map.nodes[38525326] = AnimaShard({quest=61264, note=L["anima_shard_61264"]})
map.nodes[57645567] = AnimaShard({quest=61270, note=L["anima_shard_61270"]})
map.nodes[65254288] = AnimaShard({quest=61271, note=L["anima_shard_61271"]})
map.nodes[72384029] = AnimaShard({quest=61273, note=L["anima_shard_61273"]})
map.nodes[66892692] = AnimaShard({quest=61274, note=L["anima_shard_61274"]})
map.nodes[57553827] = AnimaShard({quest=61275, note=L["anima_shard_61275"],
    pois={
        POI({55694287}) -- Entrance
    }
})
map.nodes[52163939] = AnimaShard({quest=61277, note=L["anima_shard_61277"]})
map.nodes[49993826] = AnimaShard({quest=61278, note=L["anima_shard_61278"]})
map.nodes[48483491] = AnimaShard({quest=61279, note=L["anima_shard_61279"]})
map.nodes[56722884] = AnimaShard({quest=61280, note=L["anima_shard_61280"]})
map.nodes[56201731] = AnimaShard({quest=61281, note=L["anima_shard_61281"]})
map.nodes[59881391] = AnimaShard({quest=61282, note=L["anima_shard_61282"]})
map.nodes[52440942] = AnimaShard({quest=61283, note=L["anima_shard_61283"],
    pois={
        POI({53650953}) -- Entrance
    }
})
map.nodes[46691804] = AnimaShard({quest=61284, note=L["anima_shard_61284"]})
map.nodes[44942845] = AnimaShard({quest=61285, note=L["anima_shard_61285"]})
map.nodes[42302402] = AnimaShard({quest=61286, note=L["anima_shard_61286"]})
map.nodes[37102468] = AnimaShard({quest=61287, note=L["anima_shard_61287"]})
map.nodes[42813321] = AnimaShard({quest=61288, note=L["anima_shard_61288"]})
map.nodes[42713940] = AnimaShard({quest=61289, note=L["anima_shard_61289"]})
map.nodes[33033762] = AnimaShard({quest=61290, note=L["anima_shard_61290"]})
map.nodes[31002747] = AnimaShard({quest=61291, note=L["anima_shard_61291"]})
map.nodes[30612373] = AnimaShard({quest=61292, note=L["anima_shard_61292"]})
map.nodes[24642298] = AnimaShard({quest=61293, note=L["anima_shard_61293"]})
map.nodes[26152262] = AnimaShard({quest=61294, note=L["anima_shard_61294"]})
map.nodes[24371821] = AnimaShard({quest=61295, note=L["anima_shard_61295"]})

-------------------------------------------------------------------------------

local gardens = Map({ id=1693 })
local font = Map({ id=1694 })
local wake = Map({ id=1666 })

wake.nodes[52508860] = AnimaShard({quest=61296, note=L["anima_shard_61296"], parent=map.id})
wake.nodes[36202280] = AnimaShard({quest=61297, note=L["anima_shard_61297"], parent=map.id})
gardens.nodes[46605310] = AnimaShard({quest=61298, note=L["anima_shard_61298"]})
gardens.nodes[69403870] = AnimaShard({quest=61299, note=L["anima_shard_61299"]})
font.nodes[49804690] = AnimaShard({quest=61300, note=L["anima_shard_61300"]})
