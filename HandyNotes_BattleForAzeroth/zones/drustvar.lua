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
local Supply = ns.node.Supply
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Pet = ns.reward.Pet
local Transmog = ns.reward.Transmog
local Toy = ns.reward.Toy

local Arrow = ns.poi.Arrow
local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({ id=896, settings=true })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[41953647] = Rare({
    id=128181,
    quest=49137,
    label=GetAchievementCriteriaInfoByID(12941, 41714),
    note=L["in_small_cave"]..' '..L["ancient_sarco_note"],
    rewards={
        Achievement({id=12941, criteria=41714})
    }
}) -- Ancient Sarcophagus

map.nodes[29226901] = Rare({
    id=137824,
    quest=51470,
    rewards={
        Achievement({id=12941, criteria=41733}),
        Transmog({item=160469, slot=L["mail"]}) -- Arclight Jumpers
    }
}) -- Arclight

map.nodes[34886921] = Rare({
    id=137529,
    quest=51383,
    rewards={
        Achievement({id=12941, criteria=41732}),
        Transmog({item=160449, slot=L["warglaive"]}) -- Spectral Revenger
    }
}) -- Arvon the Betrayed

map.nodes[43768802] = Rare({
    id=137825,
    quest=51471,
    rewards={
        Achievement({id=12941, criteria=41736}),
        Transmog({item=154447, slot=L["plate"]}) -- Gryphon-Rider's Breastplate
    }
}) -- Avalanche

map.nodes[55472882] = Rare({
    id=130143,
    quest=49602,
    rewards={
        Achievement({id=12941, criteria=41726}),
        Transmog({item=160475, slot=L["plate"]}) -- Barksnapper Girdle
    },
    pois={
        Path({
            55472882, 56102946, 56762915, 57662950, 58572980, 58932879,
            59262784, 59182660, 58382635, 57652668, 56922702, 56352754,
            55752805, 55472882
        })
    }
}) -- Balethorn

map.nodes[59101676] = Rare({
    id=127333,
    quest=48842,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12941, criteria=41708}),
        Transmog({item=155425, slot=L["fist"]}) -- Barbthorn Queen's Stinger
    }
}) -- Barbthorn Queen

map.nodes[50543005] = Rare({
    id=129805,
    quest=49481,
    note=L["in_small_cave"]..' '..L["beshol_note"],
    rewards={
        Achievement({id=12941, criteria=41722}),
        Transmog({item=158363, slot=L["cloth"]}) -- Spiderhair Circlet
    }
}) -- Beshol

map.nodes[58463317] = Rare({
    id=124548,
    quest=47884,
    rewards={
        Achievement({id=12941, criteria=41706}),
        Transmog({item=160463, slot=L["leather"]}) -- Blue-Ribbon Belt
    }
}) -- Betsy

map.nodes[35053326] = Rare({
    id=132319,
    quest=50163,
    note=L["in_cave"],
    rewards={
        Achievement({id=12941, criteria=41727}),
        Transmog({item=155284, slot=L["1h_mace"]}) -- Bleak Hills Swatter
    },
    pois={
            POI({35943156}) -- Cave Entrance
    }
}) -- Bilefang Mother

map.nodes[66585068] = Rare({
    id=126621,
    quest=48978,
    rewards={
        Achievement({id=12941, criteria=41711}),
        Transmog({item=154376, slot=L["plate"]}) -- Bonecurse Guantlets
    }
}) -- Bonesquall

map.nodes[27635958] = Rare({
    id=139321,
    quest=51922,
    rewards={
        Achievement({id=12941, criteria=41750}),
        Transmog({item=154500, slot=L["staff"]}) -- Moonwood Bramblespire
    }
}) -- Braedan Whitewall

map.nodes[27561420] = Rare({
    id=135796,
    quest=50939,
    rewards={
        Achievement({id=12941, criteria=41730}),
        Transmog({item=160450, slot=L["gun"]}) -- Leadshot Heavy Rifle
    },
    pois={
        Path({28301415, 27561420, 26781427})
    }
}) -- Captain Leadfist

map.nodes[52074697] = Rare({
    id=129904,
    quest=49216,
    note=L["in_small_cave"]..' ' ..L["cottontail_matron_note"],
    rewards={
        Achievement({id=12941, criteria=41715})
    }
}) -- Cottontail Matron

map.nodes[18716138] = Rare({
    id=134706,
    quest=50669,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12941, criteria=42342}),
        Item({item=158555, note=L["trinket"]}) -- Doom Shroom
    }
}) -- Deathcap

map.nodes[63404009] = Rare({
    id=129995,
    quest=49530,
    rewards={
        Achievement({id=12941, criteria=41724}),
        Transmog({item=160447, slot=L["offhand"]}) -- Soul-Pillar Lantern
    }
}) -- Emily Mayville

map.nodes[30881839] = Rare({
    id=134213,
    quest=50546,
    rewards={
        Achievement({id=12941, criteria=41728}),
        Transmog({item=155055, slot=L["2h_axe"]}) -- Soul-Curse Executioner
    }
}) -- Executioner Blackwell

map.nodes[24462195] = Rare({
    id=138866,
    quest=51749,
    label=GetAchievementCriteriaInfoByID(12941, 41748),
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12941, criteria=41748}),
        Transmog({item=154217, slot=L["dagger"]}) -- Pearly-White Jackknife
    }
}) -- Fungi Trio

map.nodes[63036963] = Rare({
    id=127844,
    quest=48979,
    note=L["gluttonous_yeti_note"],
    rewards={
        Achievement({id=12941, criteria=41712}),
        Transmog({item=158683, slot=L["shield"]}) -- Giant Yeti's Bowl
    }
}) -- Gluttonous Yeti

map.nodes[57124431] = Rare({
    id=129835,
    quest=49480,
    rewards={
        Achievement({id=12941, criteria=41721}),
        Transmog({item=158710, slot=L["1h_mace"]}) -- Gorehorn's Rack
    }
}) -- Gorehorn

map.nodes[28002593] = Rare({
    id=138675,
    quest=51700,
    rewards={
        Achievement({id=12941, criteria=41742}),
        Transmog({item=154461, slot=L["leather"]}) -- Cursed Boarhide Helm
    }
}) -- Gorged Boar

map.nodes[50332063] = Rare({
    id=127129,
    quest=49388,
    rewards={
        Achievement({id=12941, criteria=41720}),
        Transmog({item=160457, slot=L["cloth"]}) -- Lava-Starched Britches
    }
}) -- Grozgore

map.nodes[24073029] = Rare({
    id=138618,
    quest=51698,
    rewards={
        Achievement({id=12941, criteria=41739}),
        Transmog({item=155362, slot=L["polearm"]}) -- Wickerbeast Mulcher
    }
}) -- Haywire Golem

map.nodes[22934948] = Rare({
    id=134754,
    quest=50688,
    rewards={
        Achievement({id=12941, criteria=41729}),
        Transmog({item=160462, slot=L["leather"]}) -- Hyo'gi Basket Binders
    }
}) -- Hyo'gi

map.nodes[64928327] = Rare({
    id=131735,
    quest=52061,
    note=L["idej_note"],
    rewards={
        Pet({id=2198, item=161081}) -- Taptaf
    }
}) -- Idej the Wise

map.nodes[59245526] = Rare({
    id=127877,
    quest=48981,
    rewards={
        Achievement({id=12941, criteria=41713}),
        Transmog({item=159518, slot=L["dagger"]}) -- Long Fang
    }
}) -- Longfang & Henry Breakwater

map.nodes[59934547] = Rare({
    id=130138,
    quest=49601,
    rewards={
        Achievement({id=12941, criteria=41725}),
        Transmog({item=160456, slot=L["cloth"]}) -- Blanched Ravenfeather Gloves
    }
}) -- Nevermore

map.nodes[66574273] = Rare({
    id=125453,
    quest=48178,
    rewards={
        Achievement({id=12941, criteria=41707}),
        Transmog({item=158583, slot=L["cloak"]}) -- Quillstitch Greatcloak
    }
}) -- Quillrat Matriarch

map.nodes[59617183] = Rare({
    id=128707,
    quest=49269,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12941, criteria=41717}),
        Transmog({item=158345, slot=L["mail"]}) -- Coldsnap Pauldrons
    }
}) -- Rimestone

map.nodes[67986688] = Rare({
    id=129031,
    quest=49341,
    label=GetAchievementCriteriaInfoByID(12941, 41719),
    note=L["seething_cache_note"],
    rewards={
        Achievement({id=12941, criteria=41719}),
        Item({item=158598, note=L["ring"]}) -- Band of Seething Manifest
    }
}) -- Seething Cache

map.nodes[32985711] = Rare({
    id=138863,
    quest=51748,
    rewards={
        Achievement({id=12941, criteria=41745}),
        Transmog({item=155299, slot=L["wand"]}) -- Sister Martha's Soulstealer
    }
}) -- Sister Martha

map.nodes[31934061] = Rare({
    id=129950,
    quest=49528,
    rewards={
        Achievement({id=12941, criteria=41723}),
        Transmog({item=161444, slot=L["cloth"]}) -- Frosted Talonfeather Mantle
    }
}) -- Talon

map.nodes[25101624] = Rare({
    id=139358,
    quest=51949,
    note=L["the_caterer_note"],
    rewards={
        Item({item=155560, note=L["ring"]}) -- Lazy-Baker's Ring
    }
}) -- The Caterer

map.nodes[72856047] = Rare({
    id=127651,
    quest=48928,
    note=L["vicemaul_note"],
    rewards={
        Achievement({id=12941, criteria=41709}),
        Transmog({item=160474, slot=L["plate"]}) -- Vicemaul Wristpinchers
    }
}) -- Vicemaul

map.nodes[64952147] = Rare({
    id=128973,
    quest=49311,
    rewards={
        Achievement({id=12941, criteria=41718}),
        Transmog({item=155543, slot=L["polearm"]}) -- Tuskarr Whaler's Harpoon
    }
}) -- Whargarble the Ill-Tempered

map.nodes[29506410] = Rare({
    id=139322,
    quest=51923,
    rewards={
        Achievement({id=12941, criteria=41751}),
        Transmog({item=154315, slot=L["fist"]}) -- Rusty Steelclaw
    }
}) -- Whitney "Steelclaw" Ramsay

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- 18245922 51912
-- 26673167 51907
-- 28255916 51913
-- 29872746 51907
-- 32001821 box despawned on approach
-- 34311949 51902
-- 58963042 51875
-- 64706195 51896
-- 69576674 51899
-- 72046008 51899

-------------------------------------------------------------------------------

map.nodes[55605181] = Treasure({
    quest=53472,
    note=L["wicker_pup_note"],
    rewards={
        Achievement({id=12995, criteria=41703}),
        Item({item=163790}), -- Spooky Incantation
        Pet({item=163497, id=2411}) -- Wicker Pup
    }
}) -- Bespelled Chest

map.nodes[25452417] = Treasure({
    quest=53474,
    note=L["in_small_cave"]..' '..L["wicker_pup_note"],
    rewards={
        Achievement({id=12995, criteria=41705}),
        Item({item=163796}), -- Wolf Pup Spine
        Pet({item=163497, id=2411}) -- Wicker Pup
    }
}) -- Enchanted Chest

map.nodes[67767367] = Treasure({
    quest=53473,
    note=L["wicker_pup_note"],
    rewards={
        Achievement({id=12995, criteria=41704}),
        Item({item=163791}), -- Miniature Stag Skull
        Pet({item=163497, id=2411}) -- Wicker Pup
    }
}) -- Ensorcelled Chest

map.nodes[18515133] = Treasure({
    quest=53471,
    note=L["wicker_pup_note"],
    rewards={
        Achievement({id=12995, criteria=41702}),
        Item({item=163789}), -- Bundle of Wicker Sticks
        Pet({item=163497, id=2411}) -- Wicker Pup
    }
}) -- Hexed Chest

map.nodes[25751995] = Treasure({
    quest=53357,
    requires=ns.requirement.Item(163710),
    note=L["merchants_chest_note"],
    rewards={
        Achievement({id=12995, criteria=41698}),
        Item({item=163036, note='x5'})
    }
}) -- Merchant's Chest

map.nodes[63306585] = Treasure({
    quest=53385,
    note=L["in_small_cave"]..' '..L["runebound_cache_note"],
    rewards={
        Achievement({id=12995, criteria=41699}),
        Item({item=163743}) -- Drust Soulcatcher
    }
}) -- Runebound Cache

map.nodes[44222770] = Treasure({
    quest=53386,
    note=L["runebound_chest_note"],
    rewards={
        Achievement({id=12995, criteria=41700}),
        Toy({item=163742}) -- Heartsbane Grimoire
    }
}) -- Runebound Chest

map.nodes[33687173] = Treasure({
    quest=53387,
    note=L["runebound_coffer_note"],
    rewards={
        Achievement({id=12995, criteria=41701}),
        Toy({item=163740}) -- Drust Ritual Knife
    }
}) -- Runebound Coffer

map.nodes[24264830] = Treasure({
    quest=53475,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12995, criteria=41752}),
        Item({item=163036, note='x5'})
    }
}) -- Stolen Thornspeaker Cache

map.nodes[33713008] = Treasure({
    quest=53356,
    rewards={
        Achievement({id=12995, criteria=41697})
    }
}) -- Web-Covered Chest

-------------------------------------------------------------------------------
----------------------------- SECRET SUPPLY CHESTS ----------------------------
-------------------------------------------------------------------------------

local SECRET_CHEST = ns.node.SecretSupply({
    quest=55375,
    rewards={
        Achievement({id=13317, criteria=43931})
    }
}) -- quest = 54715 (looted ever) 55375 (looted today)

map.nodes[29674100] = SECRET_CHEST
-- map.nodes[30003300] = SECRET_CHEST
map.nodes[33704075] = SECRET_CHEST
map.nodes[33804930] = SECRET_CHEST

-------------------------------------------------------------------------------
------------------------------ WAR SUPPLY CHESTS ------------------------------
-------------------------------------------------------------------------------

map.nodes[30223362] = Supply({
    quest=55408,
    fgroup='supply_path_1'
})
map.nodes[31812232] = Supply({
    quest=55408,
    fgroup='supply_path_1',
    pois={Arrow({33750842, 27005679})}
})
map.nodes[33051346] = Supply({
    quest=55408,
    fgroup='supply_path_1'
})

map.nodes[53422897] = Supply({
    quest=55408,
    fgroup='supply_path_2'
})
map.nodes[58104270] = Supply({
    quest=55408,
    fgroup='supply_path_2',
    pois={Arrow({66006663, 50001873})}
})
map.nodes[62825711] = Supply({
    quest=55408,
    fgroup='supply_path_2'
})

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[21406645] = PetBattle({
    id=139489,
    note=L["captain_hermes_note"],
    rewards={
        Achievement({id=12936, criteria=44208}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=1, oneline=true}), -- Beast
        Achievement({id=13271, criteria=1, oneline=true}), -- Critter
        Achievement({id=13272, criteria=1, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=1, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=1, oneline=true}), -- Flying
        Achievement({id=13275, criteria=1, oneline=true}), -- Magic
        Achievement({id=13277, criteria=1, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=1, oneline=true}), -- Undead
        Achievement({id=13280, criteria=1, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=1, oneline=true})  -- Humanoid
    }
}) -- Crab People (Captain Hermes)

map.nodes[38153860] = PetBattle({
    id=140813,
    note=L["fizzie_spark_note"],
    rewards={
        Achievement({id=12936, criteria=44213}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=4, oneline=true}), -- Beast
        Achievement({id=13271, criteria=4, oneline=true}), -- Critter
        Achievement({id=13272, criteria=4, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=4, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=4, oneline=true}), -- Flying
        Achievement({id=13275, criteria=4, oneline=true}), -- Magic
        Achievement({id=13277, criteria=4, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=4, oneline=true}), -- Undead
        Achievement({id=13280, criteria=4, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=4, oneline=true})  -- Humanoid
    }
}) -- Rogue Azerite (Fizzie Sparkwhistle)

map.nodes[61061771] = PetBattle({
    id=140880,
    note=L["michael_skarn_note"],
    rewards={
        Achievement({id=12936, criteria=44214}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=5, oneline=true}), -- Beast
        Achievement({id=13271, criteria=5, oneline=true}), -- Critter
        Achievement({id=13272, criteria=5, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=5, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=5, oneline=true}), -- Flying
        Achievement({id=13275, criteria=5, oneline=true}), -- Magic
        Achievement({id=13277, criteria=5, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=5, oneline=true}), -- Undead
        Achievement({id=13280, criteria=5, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=5, oneline=true})  -- Humanoid
    }
}) -- What's the Buzz? (Michael Skarn)

map.nodes[63605971] = PetBattle({
    id=140461,
    note=L["dilbert_mcclint_note"],
    rewards={
        Achievement({id=12936, criteria=44212}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=3, oneline=true}), -- Beast
        Achievement({id=13271, criteria=3, oneline=true}), -- Critter
        Achievement({id=13272, criteria=3, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=3, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=3, oneline=true}), -- Flying
        Achievement({id=13275, criteria=3, oneline=true}), -- Magic
        Achievement({id=13277, criteria=3, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=3, oneline=true}), -- Undead
        Achievement({id=13280, criteria=3, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=3, oneline=true})  -- Humanoid
    }
}) -- Night Horrors (Dilbert McClint)

-------------------------------------------------------------------------------
--------------------------- DRUST THE FACTS, MA'AM ----------------------------
-------------------------------------------------------------------------------

local Stele = Class('Stele', Collectible, {
    icon=2101971,
    group=ns.groups.DRUST_FACTS,
    sublabel=L["drust_facts_note"]
})

map.nodes[19065787] = Stele({
    rewards={
        Achievement({id=13064, criteria=41443})
    }
}) -- Drust Stele: The Cycle

map.nodes[27354833] = Stele({
    rewards={
        Achievement({id=13064, criteria=41438})
    }
}) -- Drust Stele: The Tree

map.nodes[27605760] = Stele({
    rewards={
        Achievement({id=13064, criteria=41441})
    }
}) -- Drust Stele: Sacrifice

map.nodes[36806450] = Stele({
    rewards={
        Achievement({id=13064, criteria=41436})
    }
}) -- Drust Stele: The Circle

map.nodes[44584566] = Stele({
    note=L["stele_forest_note"],
    rewards={
        Achievement({id=13064, criteria=41449})
    },
    pois={
        POI({46094528}) -- Ulfar's Den
    }
}) -- Drust Stele: Protectors of the Forest

map.nodes[46453723] = Stele({
    rewards={
        Achievement({id=13064, criteria=41445})
    }
}) -- Drust Stele: Conflict

map.nodes[50144232] = Stele({
    rewards={
        Achievement({id=13064, criteria=41442})
    }
}) -- Drust Stele: Constructs

map.nodes[50777371] = Stele({
    rewards={
        Achievement({id=13064, criteria=41437})
    }
}) -- Drust Stele: The Ritual

map.nodes[56558583] = Stele({
    rewards={
        Achievement({id=13064, criteria=41446})
    }
}) -- Drust Stele: The Flayed Man

map.nodes[59396668] = Stele({
    rewards={
        Achievement({id=13064, criteria=41439})
    }
}) -- Drust Stele: Breath Into Stone

-------------------------------------------------------------------------------
------------------------- EVERYTHING OLD IS NEW AGAIN -------------------------
-------------------------------------------------------------------------------

local Relic = Class('OrderRelic', Collectible, {
    icon=514016,
    group=ns.groups.EMBER_RELICS,
    pois={
        POI({44892743}) -- Gol Var entrance
    },
    IsCompleted = function (self)
        if ns.PlayerHasItem(self.item) then return true end
        return Collectible.IsCompleted(self)
    end
})

map.nodes[32585891] = Relic({
    item=163747,
    note=L["embers_knife_note"],
    rewards={
        Achievement({id=13082, criteria=41639})
    }
}) -- Order of Embers Knife

map.nodes[35525187] = Relic({
    item=163749,
    note=L["embers_crossbow_note"],
    rewards={
        Achievement({id=13082, criteria=41636})
    }
}) -- Order of Embers Crossbow

map.nodes[55432714] = Relic({
    item=163748,
    note=L["embers_hat_note"],
    rewards={
        Achievement({id=13082, criteria=41638})
    }
}) -- Order of Embers Hat

map.nodes[64876779] = Relic({
    item=163746,
    note=L["embers_flask_note"],
    rewards={
        Achievement({id=13082, criteria=41637})
    }
}) -- Order of Embers Flask

map.nodes[42432548] = Collectible({
    icon=514016,
    label=L["golvar_ruins"],
    note=L["embers_golvar_note"],
    group=ns.groups.EMBER_RELICS,
    rewards={
        Achievement({id=13082, criteria={
            41636, -- Old Crossbow
            41637, -- Old Flask
            41638, -- Old Hat
            41639, -- Old Knife
        }})
    },
    pois={
        POI({44892743}) -- Gol Var entrance
    }
})

-------------------------------------------------------------------------------
------------------------------- SAUSAGE SAMPLER -------------------------------
-------------------------------------------------------------------------------

map.nodes[55563479] = Collectible({
    id=128467,
    icon=133200,
    note=L["sausage_sampler_note"]..' '..L["elijah_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    rewards={
        Achievement({id=13087, criteria={
            41648, -- Goldshire Farms Smoked Sausage
            41651, -- Roland's Famous Frankfurter
            41652, -- Rosco Fryer's Mostly-Meat Brat
            41653, -- Timmy Gene Sunrise Pork
        }})
    }
}) -- Elijah Eggleton

map.nodes[37894905] = Collectible({
    id=137031,
    icon=133200,
    note=L["sausage_sampler_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    rewards={
        Achievement({id=13087, criteria={
            41651, -- Roland's Famous Frankfurter
        }})
    }
}) -- Jake Storm

map.nodes[26677253] = Collectible({
    id=136655,
    icon=133200,
    note=L["sausage_sampler_note"]..' '..L["alisha_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    rewards={
        Achievement({id=13087, criteria={
            41649, -- Fried Boar Sausage
            41652, -- Rosco Fryer's Mostly-Meat Brat
        }})
    }
}) -- Alisha Darkwater

local raal = Collectible({
    id=131863,
    icon=133200,
    note=L["sausage_sampler_note"]..'\n\n'..L["raal_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    rewards={
        Achievement({id=13087, criteria={
            41650, -- Heartsbane Hexwurst
        }}),
        Item({item=163833}) -- Recipe: Heartsbane Hexwurst
    }
}) -- Raal the Gluttonous

map.nodes[34581008] = raal
Map({id=1015}).nodes[67434813] = raal

-------------------------------------------------------------------------------
--------------------------- THREE SHEETS TO THE WIND --------------------------
-------------------------------------------------------------------------------

map.nodes[21146615] = Collectible({
    id=139638,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    rewards={
        Achievement({id=13061, criteria={
            41400, -- Blacktooth Bloodwine
            41408, -- Kul Tiran Tripel
            41413, -- Sausage Martini
            41414, -- Snowberry Berliner
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Barkeep Cotner

map.nodes[21474360] = Collectible({
    id=137040,
    icon=135999,
    note=L["three_sheets_note"]..'\n\n'..L["linda_deepwater_note"],
    group=ns.groups.THREE_SHEETS,
    rewards={
        Achievement({id=13061, criteria={
            41397, -- Admiralty-Issued Grog
            41399, -- Bitter Darkroot Vodka
            41400, -- Blacktooth Bloodwine
            41407, -- Hook Point Schnapps
            41408, -- Kul Tiran Tripel
            41409, -- Long Forgotten Rum
            41410, -- Mildenhall Mead
            41415, -- Thornspeaker Moonshine
            41417, -- Whitegrove Pale Ale
        }})
    },
    pois={
        POI({22884623}) -- Cesi Loosecannon
    }
}) -- Linda Deepwater
