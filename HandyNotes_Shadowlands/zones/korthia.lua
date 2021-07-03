-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.RiftMap

local Collectible = ns.node.Collectible
local NPC = ns.node.NPC
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Line = ns.poi.Line
local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local KYRIAN = ns.covenants.KYR
local NECROLORD = ns.covenants.NEC
local NIGHTFAE = ns.covenants.FAE
local VENTHYR = ns.covenants.VEN

local map = Map({ id=1961, settings=true })

function map:CanDisplay(node, coord, minimap)
    local research = select(3,GetFactionInfoByID(2472))
    if node.research and research < node.research then return false end
    return Map.CanDisplay(self, node, coord, minimap)
end

-- https://github.com/Nevcairiel/HereBeDragons/issues/13
-- local gho = Map({ id=2007 }) -- Grommit Hollow

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[58211773] = Rare({
    id=180246,
    quest=64258, -- 64439?
    rewards={
        Achievement({id=15107, criteria=52290}),
        Transmog({item=187370, slot=L["cloth"]}), -- Carriage Crusher's Padded Slippers
        Transmog({item=187391, slot=L["plate"]}) -- Yarxhov's Rib-Cage
    }
}) -- Assault Supply Carriage

map.nodes[39405240] = Rare({
    id=179802,
    quest=64257,
    requires=ns.requirement.Item(186718),
    note=L["chamber_note"],
    rewards={
        Achievement({id=15107, criteria=52295}),
        Achievement({id=15066, criteria=52262}),
        Item({item=187103, quest=63917}), -- Everliving Statuette
        Transmog({item=187366, slot=L["polearm"]}) -- Fallen Vault Guardian's Spire
    }
}) -- Chamber of Knowledge

map.nodes[44983552] = Rare({
    id=179859,
    quest=64278,
    requires=ns.requirement.Item(186718),
    note=L["chamber_note"],
    rewards={
        Achievement({id=15107, criteria=52296}),
        Achievement({id=15066, criteria=52263}),
        Pet({item=186538, id=3140}), -- Gnashtooth
        Item({item=187104, quest=63918}), -- Obelisk of Dark Tidings
        Transmog({item=187387, slot=L["mail"]}) -- Pauldrons of the Unknown Beyond
    }
}) -- Chamber of Wisdom

map.nodes[51164167] = Rare({
    id=179768,
    quest=64243,
    note=L["consumption_note"],
    rewards={
        Achievement({id=15107, criteria=52285}),
        Transmog({item=187245, slot=L["cosmetic"]}), -- Death-Enveloped Spires
        Transmog({item=187246, slot=L["cosmetic"]}), -- Death-Enveloped Pauldrons
        Transmog({item=187247, slot=L["cosmetic"]}) -- Death-Enveloped Shoulder Spikes
    }
}) -- Consumption

map.nodes[59934371] = Rare({
    id=180042,
    quest=64349,
    covenant=NECROLORD,
    note=L["corpse_heap_note"],
    rewards={
        Achievement({id=15107, criteria=52299}),
        Transmog({item=187372, slot=L["cloth"]}), -- Miasma Filtering Headpiece
        Mount({item=186489, id=1449, covenant=NECROLORD}) -- Lord of the Corpseflies
    }
}) -- Corpse Heap

map.nodes[51822081] = Rare({
    id=177903,
    quest=63830,
    rewards={
        Achievement({id=15107, criteria=52277}),
        Transmog({item=187390, slot=L["plate"]}), -- Dominated Protector's Helm
    }
}) -- Dominated Protector

map.nodes[33183938] = Rare({
    id=180014,
    quest=64320,
    covenant=NIGHTFAE,
    note=L["wilderling_note"],
    rewards={
        Achievement({id=15107, criteria=52298}),
        Mount({item=186492, id=1487, covenant=NIGHTFAE}) -- Summer Wilderling
    }
}) -- Escaped Wilderling

map.nodes[44222950] = Rare({
    id=179684,
    quest=64233,
    note=L["hunting_hunter_note"],
    rewards={
        Achievement({id=15107, criteria=52283}),
        Mount({item=186645, id=1506}) -- Crimson Shardhide
    },
    pois={
        POI({60652315}) -- Caretaker Kah-Kay
    }
}) -- Hunting the Hunter

map.nodes[59203580] = Rare({
    id=179108,
    quest=64428,
    rewards={
        Achievement({id=15107, criteria=52304}),
        Transmog({item=187394, slot=L["plate"]}), -- Tormented Giant's Legplates
        Transmog({item=187250, slot=L["cosmetic"]}), -- Kroke's Wingspiked Pauldrons
        Transmog({item=187248, slot=L["cosmetic"]}) -- Kroke's Gleaming Spaulders
    },
    pois={
        Path({
            59203580, 60893687, 62273605, 61313445, 59953388, 59053603,
            58253784, 57033778, 56863623, 57923572, 59203580
        })
    }
}) -- Kroke the Tormented

map.nodes[46507959] = Rare({
    id=179985,
    quest=64313,
    covenant=VENTHYR,
    note=L["no_stoneborne_note"],
    rewards={
        Achievement({id=15107, criteria=52276}),
        Transmog({item=184790,slot=L["leather"]}) -- Archdruid Van-Yali's Greenthumbs
        -- Mount({item=186479, id=, covenant=VENTHYR}) -- Mastercraft Gravewing
    }
}) -- No Stoneborn Left Behind

map.nodes[56873237] = Rare({
    id=180032,
    quest=64338,
    covenant=KYRIAN,
    note=L["popo_note"],
    rewards={
        Achievement({id=15107, criteria=52300}),
        Toy({item=187176}), -- Vesper of Harmony
        Mount({item=186483, id=1493, covenant=KYRIAN}) -- Foresworn Aquilon
    }
}) -- Popo's Potion Patrol

map.nodes[22604140] = Rare({
    id=179931,
    quest=64291,
    rewards={
        Achievement({id=15107, criteria=52291}),
        Transmog({item=187403,slot=L["cloak"]}) -- Relic Breaker's Drape
    }
}) -- Relic Breaker Krelva

map.nodes[56276617] = Rare({
    id=180160,
    quest=64455,
    note=L["reliwik_note"],
    rewards={
        Achievement({id=15107, criteria=52318}),
        Mount({item=186652, id=1509}) -- Garnet Razorwing
    }
}) -- Reliwik the Defiant

map.nodes[27755885] = Rare({
    id=177336,
    quest=64442,
    note=L["in_cave"],
    rewards={
        Achievement({id=15107, criteria=52301}),
        Pet({item=186542, id=3136}) -- Korthian Specimen
    },
    pois={
        POI({30385480}) -- Entrance
    }
}) -- Zelnithop

-------------------------------------------------------------------------------

map.nodes[13007500] = Rare({
    id=179472,
    quest=64246, -- 64280?
    scale=1.5,
    note=L["konthrogz_note"],
    rewards={
        Achievement({id=15107, criteria=52303}),
        Mount({item=187183, id=1514}), -- Rampaging Mauler
        Transmog({item=187375, slot=L["cloth"]}), -- Bound Worldeater Tendrils
        Transmog({item=187378, slot=L["leather"]}), -- Visage of the Obliterator
        Transmog({item=187384, slot=L["mail"]}), -- Konthrogz's Scaled Handguards
        Transmog({item=187397, slot=L["plate"]}) -- Vambraces of the In-Between
    }
}) -- Konthrogz the Obliterator

map.nodes[16007500] = Rare({
    id=179760,
    quest=64245,
    scale=1.5,
    note=L["towering_exterminator_note"],
    rewards={
        Achievement({id=15107, criteria=52302}),
        Transmog({item=187373, slot=L["cloth"]}), -- Soul-Enveloping Leggings
        Transmog({item=187376, slot=L["leather"]}), -- Mawsworn Lieutenant's Treads
        Transmog({item=187241, slot=L["cosmetic"]}), -- Watchful Eye of the Damned
        Transmog({item=187242, slot=L["cosmetic"]}) -- Exterminator's Crest of the Damned
    }
}) -- Towering Exterminator

map.nodes[14507900] = Rare({
    id=180162,
    quest=64457,
    scale=1.5,
    note=L["pop_quiz_note"],
    rewards={
        Achievement({id=15107, criteria=52319}),
        Transmog({item=187369,slot=L["cloth"]}), -- Ve'rayn's Formal Robes
        Item({item=187404, note=L["neck"]}), -- Cartel Ve Amulet
        Item({item=187264, quest=64513}) -- Ve'rayn's Head
    }
}) -- Ve'rayn

-------------------------------------------------------------------------------

map.nodes[59335221] = Rare({
    id=179913,
    quest=64285,
    rift=1,
    rewards={
        Achievement({id=15107, criteria=52275}),
        Toy({item=187174}) -- Shaded Judgement Stone
    }
}) -- Deadsoul Hatcher

map.nodes[50307590] = Rare({
    id=179914,
    quest=64369,
    rift=1,
    rewards={
        Achievement({id=15107, criteria=52294}),
        Toy({item=187420}) -- Maw-Ocular Viewfinder
    }
}) -- Observer Yorik

map.nodes[44604240] = Rare({
    id=179608,
    quest=64263,
    rift=1,
    rewards={
        Achievement({id=15107, criteria=52273})
    }
}) -- Screaming Shade

map.nodes[57607040] = Rare({
    id=179911,
    quest=64284,
    rift=1,
    rewards={
        Achievement({id=15107, criteria=52274})
    }
}) -- Silent Soulstalker

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[29595342] = Treasure({
    quest=64244,
    rewards={
        Achievement({id=15099, criteria=52241}),
        Item({item=187349}) -- Anima Laden Egg
    }
}) -- Anima Laden Egg

map.nodes[47502920] = Treasure({
    quest=64241,
    note=L["dislodged_nest_note"],
    rewards={
        Achievement({id=15099, criteria=52240}),
        Toy({item=187339}) -- Silver Shardhide Whistle
    }
}) -- Dislodged Nest

map.nodes[50478446] = Treasure({
    quest=64252,
    rewards={
        Achievement({id=15099, criteria=52242}),
        Item({item=187350, note=L["num_research"]:format(300)}) --Displaced Relic
    }
}) -- Displaced Relic

map.nodes[68902990] = Treasure({
    quest=64234,
    note=L["forgotten_feather_note"],
    rewards={
        Achievement({id=15099, criteria=52237}),
        Toy({item=187051}) -- Forgotten Feather
    }
}) -- Forgotten Feather

map.nodes[38344296] = Treasure({
    quest=64222,
    rewards={
        Achievement({id=15099, criteria=52236})
    }
}) -- Glittering Nest Materials

map.nodes[40145892] = Treasure({
    quest=64264,
    note=L["in_cave"],
    rewards={
        Achievement({id=15099, criteria=52245}),
        Item({item=187354}) -- Abandoned Broker Satchel
    },
    pois={
        POI({42515596}) -- cave entrance
    }
}) -- Infected Vestige

map.nodes[52991477] = Treasure({
    quest=64238,
    rewards={
        Achievement({id=15099, criteria=52238})
    }
}) -- Lost Momento

map.nodes[45336714] = Treasure({
    quest=64268,
    requires=ns.requirement.Item(187033),
    note=L["offering_box_note"],
    rewards={
        Achievement({id=15099, criteria=52246}),
        Toy({item=187344}) -- Offering Kit Maker
    },
    pois={
        POI({43556770}) -- Small Offering Key
    }
}) -- Offering Box

map.nodes[62065550] = Treasure({
    quest=64247,
    note=L["spectral_bound_note"],
    label=L["spectral_bound_chest"],
    rewards={
        ns.relics.relic_fragment,
        Transmog({item=187240, slot=L["cosmetic"]}) -- Field Warden's Watchful Eye
    },
    pois={
        POI({50505370, 52305320, 52604970, 54205060, quest=64249}), -- west
        POI({59205670, 60305650, 61005870, 62105770, quest=64250}), -- south
        POI({57504930, 58224871, 59284858, 61494733, 62735133, quest=64248}) -- north
    }
}) -- Spectral Bound Chest

-------------------------------------------------------------------------------
----------------------------------- RELICS ------------------------------------
-------------------------------------------------------------------------------

local Relic = Class('Relic', ns.node.Treasure, {
    group=ns.groups.RELIC,
    icon='star_chest_b',
    scale=1.6,
    IsCompleted=function(self)
        if C_QuestLog.IsOnQuest(self.quest[1]) then return true end
        return Treasure.IsCompleted(self)
    end
})

-------------------------------------------------------------------------------

map.nodes[27305670] = Relic({
    quest=63899,
    questDeps=64506,
    note=L["in_cave"],
    rewards={
        Achievement({id=15066, criteria=52131})
    }
}) -- Book of Binding: The Mad Witch

map.nodes[45455607] = Relic({
    quest=63912,
    questDeps=64506,
    rewards={
        Achievement({id=15066, criteria=52258})
    }
}) -- Celestial Shadowlands Chart

map.nodes[62035681] = Relic({
    quest=63911,
    questDeps=64506,
    rewards={
        Achievement({id=15066, criteria=52257})
    }
}) -- Singing Steel Ingot

map.nodes[40534135] = Relic({
    quest=63860,
    questDeps=64506,
    note=L["in_cave"],
    rewards={
        Achievement({id=15066, criteria=52126})
    },
    pois={
        POI({42314094}) -- cave entrance
    }
}) -- Talisman of the Eternal Scholar

-------------------------------------------------------------------------------

map.nodes[41146015] = Relic({
    quest=63924,
    note=L["archivist_key_note"]:format("{item:187614}"),
    research=2,
    requires=ns.requirement.Item(187614),
    rewards={
        Achievement({id=15066, criteria=52268})
    }
}) -- Gorak Claw Fetish

map.nodes[41304330] = Relic({
    quest=63909,
    note=L["archivist_key_note"]:format("{item:186984}"),
    research=2,
    requires=ns.requirement.Item(186984),
    rewards={
        Achievement({id=15066, criteria=52255}),
        Toy({item=187155}) -- Guise of the Changeling
    }
}) -- Guise of the Changeling

map.nodes[33004190] = Relic({
    quest=63910,
    note=L["archivist_key_note"]:format("{item:187612}"),
    research=2,
    requires=ns.requirement.Item(187612),
    rewards={
        Achievement({id=15066, criteria=52256}),
    }
}) -- The Netherstar

map.nodes[43847698] = Relic({
    quest=63921,
    note=L["archivist_key_note"]:format("{item:187613}"),
    research=2,
    requires=ns.requirement.Item(187613),
    rewards={
        Achievement({id=15066, criteria=52265}),
        Toy({item=187140}) -- Ring of Duplicity
    }
}) -- Ring of Self-Reflection

-------------------------------------------------------------------------------

map.nodes[39405241] = Relic({
    quest=63915,
    note=L["chamber_note"],
    requires=ns.requirement.Item(186718),
    rewards={
        Achievement({id=15066, criteria=52269})
    }
}) -- Drum of Driving

map.nodes[45003550] = Relic({
    quest=63916,
    note=L["chamber_note"],
    requires=ns.requirement.Item(186718),
    rewards={
        Achievement({id=15066, criteria=52261})
    }
}) -- Sack of Strange Soil

-------------------------------------------------------------------------------

map.nodes[60803490] = Relic({
    quest=63919,
    rift=1,
    rewards={
        Achievement({id=15066, criteria=52264})
    }
}) -- Book of Binding: The Tormented Sorcerer

map.nodes[29005420] = Relic({
    quest=63914,
    rift=1,
    rewards={
        Achievement({id=15066, criteria=52260})
    }
}) -- Cipher of Understanding

map.nodes[52005260] = Relic({
    quest=63920,
    rift=1,
    rewards={
        Achievement({id=15066, criteria=52270})
    }
}) -- Enigmatic Decrypting Device

map.nodes[51402010] = Relic({
    quest=63913,
    rift=1,
    rewards={
        Achievement({id=15066, criteria=52259})
    }
}) -- Unstable Sin'dorei Explosive

-------------------------------------------------------------------------------

map.nodes[18503800] = Relic({
    quest=63908,
    note=L["korthian_shrine_note"],
    research=5,
    rewards={
        Achievement({id=15066, criteria=52254})
    }
}) -- Bulwark of Divine Intent

map.nodes[24365660] = Relic({
    quest=63923,
    note=L["korthian_shrine_note"],
    research=5,
    rewards={
        Achievement({id=15066, criteria=52267})
    }
}) -- Lang Family Wood-Carving

map.nodes[39404270] = Relic({
    quest=63922,
    note=L["korthian_shrine_note"],
    research=5,
    rewards={
        Achievement({id=15066, criteria=52266}),
        Toy({item=187159}) -- Shadow Slicing Shortsword
    }
}) -- Shadow Slicing Sword

-------------------------------------------------------------------------------
-------------------------------- RIFT PORTALS ---------------------------------
-------------------------------------------------------------------------------

local RiftPortal = Class('RiftPortal', NPC, {
    id=179595,
    scale=1.4,
    group=ns.groups.RIFT_PORTAL,
    icon='portal_gy',
    note=L["rift_portal_note"],
    requires=ns.requirement.Item(186731)
})

map.nodes[41104210] = RiftPortal({pois={POI({42304090})}})
map.nodes[43484699] = RiftPortal()
map.nodes[53707200] = RiftPortal()
map.nodes[56807460] = RiftPortal()
map.nodes[59405370] = RiftPortal()
map.nodes[61804460] = RiftPortal()

-------------------------------------------------------------------------------
------------------------------ RIFTBOUND CACHES -------------------------------
-------------------------------------------------------------------------------

local RiftCache = Class('RiftCache', Treasure, {
    label=L["riftbound_cache"],
    group=ns.groups.RIFTBOUND_CACHE,
    rift=1,
    rewards={
        ns.relics.relic_fragment
    }
})

local RIFT_CACHE1 = RiftCache({quest=64470, icon='chest_rd', note=L["in_cave"]})
local RIFT_CACHE2 = RiftCache({quest=64471, icon='chest_pp'}) -- (also 64705?)
local RIFT_CACHE3 = RiftCache({quest=64472, icon='chest_yw'})
local RIFT_CACHE4 = RiftCache({quest=nil, icon='chest_bl'})

map.nodes[25975582] = RIFT_CACHE1
map.nodes[54105460] = RIFT_CACHE2
map.nodes[54904240] = RIFT_CACHE2
map.nodes[55506510] = RIFT_CACHE2
map.nodes[60903520] = RIFT_CACHE2
map.nodes[61775872] = RIFT_CACHE2
map.nodes[46103190] = RIFT_CACHE3
map.nodes[50703290] = RIFT_CACHE3
map.nodes[56321850] = RIFT_CACHE3
map.nodes[64303040] = RIFT_CACHE3
map.nodes[33503950] = RIFT_CACHE4
map.nodes[38003550] = RIFT_CACHE4

-------------------------------------------------------------------------------
------------------------------ SHARED TREASURES -------------------------------
-------------------------------------------------------------------------------

local Shared = Class('Shared', ns.node.Treasure, {
    group=ns.groups.KORTHIA_SHARED,
    quest={64316,64317,64318,64564,64565},  --Quest IDs 64307/64309 seem to be changed.
    questCount=true,
    scale=0.8,
    note=L['shared_note'],
    fgroup='shared_korthia',
    rewards={
        ns.relics.relic_fragment
    }
})

map.nodes[27204830] = Shared({label=L["pile_of_bones"]})
map.nodes[28205070] = Shared({label=L["pile_of_bones"]})
map.nodes[29304710] = Shared({label=L["pile_of_bones"]})
map.nodes[29514952] = Shared({label=L["pile_of_bones"]})
map.nodes[30904570] = Shared({label=L["pile_of_bones"]})
map.nodes[32704200] = Shared({label=L["pile_of_bones"]})
map.nodes[32804530] = Shared({label=L["pile_of_bones"]})
map.nodes[32805510] = Shared({label=L["pile_of_bones"]})
map.nodes[34104400] = Shared({label=L["pile_of_bones"]})
map.nodes[34505680] = Shared({label=L["pile_of_bones"]})
map.nodes[34704580] = Shared({label=L["pile_of_bones"]})
map.nodes[37105370] = Shared({label=L["pile_of_bones"]})
map.nodes[38205170] = Shared({label=L["pile_of_bones"]})
map.nodes[39605020] = Shared({label=L["pile_of_bones"]})
map.nodes[41005050] = Shared({label=L["pile_of_bones"]})
map.nodes[44015608] = Shared({label=L["relic_cache"]})
map.nodes[44407730] = Shared({label=L["relic_cache"]})
map.nodes[45344950] = Shared({label=L["relic_cache"]})
map.nodes[45608140] = Shared({label=L["relic_cache"]})
map.nodes[46295672] = Shared({label=L["relic_cache"]})
map.nodes[47207680] = Shared({label=L["relic_cache"]})
map.nodes[50606710] = Shared({label=L["relic_cache"]})
map.nodes[53907610] = Shared({label=L["relic_cache"]})
map.nodes[54207200] = Shared({label=L["relic_cache"]})
map.nodes[54905020] = Shared({label=L["relic_cache"]})
map.nodes[55306510] = Shared({label=L["relic_cache"]})
map.nodes[55803730] = Shared({label=L["relic_cache"]})
map.nodes[56306760] = Shared({label=L["relic_cache"]})
map.nodes[56803880] = Shared({label=L["relic_cache"]})
map.nodes[57303490] = Shared({label=L["relic_cache"]})
map.nodes[57344800] = Shared({label=L["relic_cache"]})
map.nodes[58803360] = Shared({label=L["relic_cache"]})
map.nodes[59803590] = Shared({label=L["relic_cache"]})
map.nodes[60303900] = Shared({label=L["relic_cache"]})
map.nodes[60803550] = Shared({label=L["relic_cache"]})
map.nodes[61003290] = Shared({label=L["relic_cache"]})
map.nodes[61403810] = Shared({label=L["relic_cache"]})
map.nodes[62403750] = Shared({label=L["relic_cache"]})
map.nodes[45803010] = Shared({label=L["shardhide_stash"]})
map.nodes[46703060] = Shared({label=L["shardhide_stash"]})
map.nodes[47402620] = Shared({label=L["shardhide_stash"]})
map.nodes[48103320] = Shared({label=L["shardhide_stash"]})
map.nodes[49103010] = Shared({label=L["shardhide_stash"]})
map.nodes[49502670] = Shared({label=L["shardhide_stash"]})
map.nodes[49703330] = Shared({label=L["shardhide_stash"]})
map.nodes[50423124] = Shared({label=L["shardhide_stash"]})
map.nodes[51302970] = Shared({label=L["shardhide_stash"]})
map.nodes[52322701] = Shared({label=L["shardhide_stash"]})

-------------------------------------------------------------------------------

local Mawshroom = Class('Mawshroom', Treasure, {
    group=ns.groups.INVASIVE_MAWSHROOM,
    label=L["invasive_mawshroom"],
    rewards={
        Item({item=187153, quest=64376}), --Tasty Mawshroom
        Item({item=185963, quest=638892}), --Diviner's Rune Chit
        Item({item=186017}), -- Korthite Crystal
        ns.relics.relic_fragment
    }
})

local MAWSH1 = Mawshroom({quest=64351, icon='chest_pp'})
local MAWSH2 = Mawshroom({quest=64354, icon='chest_yw'})
local MAWSH3 = Mawshroom({quest=64355, icon='chest_bl'})
local MAWSH4 = Mawshroom({quest=64356, icon='chest_rd'})
local MAWSH5 = Mawshroom({quest=64357, icon='chest_gn'})

map.nodes[54204120] = MAWSH1
map.nodes[56805150] = MAWSH1
map.nodes[57303940] = MAWSH1
map.nodes[58174048] = MAWSH1
map.nodes[60304160] = MAWSH1
map.nodes[60703820] = MAWSH1
map.nodes[48524115] = MAWSH2
map.nodes[49404070] = MAWSH2
map.nodes[49903250] = MAWSH2
map.nodes[51504690] = MAWSH2
map.nodes[53703790] = MAWSH2
map.nodes[42343469] = MAWSH3
map.nodes[43603660] = MAWSH3
map.nodes[45603430] = MAWSH3
map.nodes[52422496] = MAWSH3
map.nodes[55101641] = MAWSH3
map.nodes[35703110] = MAWSH4
map.nodes[37503480] = MAWSH4
map.nodes[38803370] = MAWSH4
map.nodes[39503070] = MAWSH4
map.nodes[39763505] = MAWSH4
map.nodes[42103250] = MAWSH4
-- map.nodes[39603000] = MAWSH5 (unconfirmed on live wowhead)
map.nodes[41204490] = MAWSH5
map.nodes[43475637] = MAWSH5
map.nodes[45204790] = MAWSH5
map.nodes[46524851] = MAWSH5
map.nodes[54805550] = MAWSH5

-------------------------------------------------------------------------------

local UMNest = Class('UMNest', Treasure, {
    group=ns.groups.NEST_MATERIALS,
    label=L["unusual_nest"],
    icon='chest_bn',
    fgroup='nest_materials',
    rewards={
        Item({item=187442, note=L["bag"]}), --Scholar's Ancient Pack
        Item({item=185963, quest=638892}), --Diviner's Rune Chit
        Item({item=186017}), -- Korthite Crystal
        ns.relics.relic_fragment
    }
})

map.nodes[41003970] = UMNest({quest=64358})
map.nodes[42205590] = UMNest({quest=64359})
map.nodes[51864391] = UMNest({quest=64360})
map.nodes[63703140] = UMNest({quest=64361})
map.nodes[52407270] = UMNest({quest=64362})

-------------------------------------------------------------------------------

local MawswornC = Class('MawswornC', Treasure, {
    group=ns.groups.MAWSWORN_CACHE,
    label=L["mawsworn_cache"],
    rewards={
        Transmog({item=187026, note=L["cloak"]}),
        Item({item=186017}), -- Korthite Crystal
        ns.relics.relic_fragment
    }
})

local MAWC1 = MawswornC({quest=64021, icon='chest_tl'})
local MAWC2 = MawswornC({quest=64363, icon='chest_pk'})
local MAWC3 = MawswornC({quest=64364, icon='chest_lm'})

map.nodes[57563756] = MAWC1
map.nodes[58803360] = MAWC1
map.nodes[60103931] = MAWC1
map.nodes[62903490] = MAWC1
map.nodes[56805610] = MAWC2
map.nodes[58325283] = MAWC2
map.nodes[61105160] = MAWC2
map.nodes[61205790] = MAWC2
map.nodes[62305860] = MAWC2
map.nodes[47707430] = MAWC3
map.nodes[54007280] = MAWC3
map.nodes[56406950] = MAWC3
map.nodes[56507470] = MAWC3

-------------------------------------------------------------------------------
---------------------------------- TRANSPORT ----------------------------------
-------------------------------------------------------------------------------

map.nodes[60832857] = NPC({
    id=178633,
    note=L["flayedwing_transporter_note"],
    icon='flight_point_y',
    scale=1.25,
    fgroup='flayedwing_transporter1',
   pois={Line({60832857, 49356386})}
})

map.nodes[49356386] = NPC({
    id=178637,
    note=L["flayedwing_transporter_note"],
    icon='flight_point_y',
    scale=1.25,
    fgroup='flayedwing_transporter1'
})

-------------------------------------------------------------------------------
--------------------------------- COLLECTIBLES --------------------------------
-------------------------------------------------------------------------------

local function GetMaelieStatus ()
    local count = 0
    for i, quest in ipairs{64293, 64294, 64295, 64296, 64297, 64299} do
        if C_QuestLog.IsQuestFlaggedCompleted(quest) then
            count = count + 1
        end
    end
    return ns.status.Gray(tostring(count)..'/6')
end

local maelie = Class('Maelie', Collectible, {
    id=179912,
    icon=3155422,
    quest={64292, 64298}, -- completed, daily
    questAny=true,
    note=L["maelie_wanderer"],
    pois={POI({
        41103980, 49304170, 59801510, 43003260, 49304170, 50302290,
        39703490, 61304040, 30005560, 42806040, 38403140, 41302750
    })},
    rewards={Mount({item=186643, id=1511})}, -- Reins of the Wanderer
    getters={rlabel=GetMaelieStatus}
})()

map.nodes[60682192] = maelie

map.nodes[42873269] = Collectible({
    id=180063,
    icon=3931157,
    quest=64376,
    note=L["darkmaul_note"],
    rewards={Mount({item=186646, id=1507})} -- Darkmaul
})

map.nodes[25725108] = Collectible({
    id=179871,
    icon=3897746,
    quest=64274,
    note=L["razorwing_note"],
    rewards={Mount({item=186651, id=1510})}-- Dusklight Razorwing
}) -- Razorwing Nest
