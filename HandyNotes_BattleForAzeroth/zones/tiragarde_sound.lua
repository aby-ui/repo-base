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
local Transmog = ns.reward.Transmog
local Toy = ns.reward.Toy

local Arrow = ns.poi.Arrow
local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({ id=895, settings=true })
local bor = Map({ id=1161 })

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[74917894] = Rare({
    id=132182,
    quest=50156,
    rewards={
        Achievement({id=12939, criteria=41793})
    }
}) -- Auditor Dolp

map.nodes[76098287] = Rare({
    id=129181,
    quest=50233,
    rewards={
        Achievement({id=12939, criteria=41795}),
        Achievement({id=13057, criteria=41544}),
        Transmog({item=160451, slot=L["dagger"]}), -- Barman Skewer
        Item({item=163717}) -- Forbidden Sea Shanty of Josephus
    }
}) -- Barman Bill

map.nodes[34503035] = Rare({
    id=132068,
    quest=50094,
    rewards={
        Achievement({id=12939, criteria=41796}),
        Transmog({item=160467, slot=L["mail"]}) -- Hydra-Hunter Legguards
    }
}) -- Bashmu

map.nodes[56296997] = Rare({
    id=132086,
    quest=50096,
    rewards={
        Achievement({id=12939, criteria=41797}),
        Achievement({id=13057, criteria=41545}),
        Transmog({item=158650, slot=L["2h_sword"]}), -- Sea-Scourge Greatblade
        Item({item=163718}) -- Forbidden Sea Shanty of the Black Sphere
    }
}) -- Black-Eyed Bart

map.nodes[85267342] = Rare({
    id=139145,
    quest=51808,
    rewards={
        Achievement({id=12939, criteria=41798}),
        Transmog({item=154411, slot=L["gun"]}) -- Vlaros Corps Rifle
    }
}) -- Blackthorne

map.nodes[83544482] = Rare({
    id=130508,
    quest=49999,
    rewards={
        Achievement({id=12939, criteria=41800}),
        Transmog({item=160460, slot=L["leather"]}) -- Thick Sauroskin Gloves
    }
}) -- Broodmother Razora

map.nodes[38442070] = Rare({
    id=132088,
    quest=50097,
    note=L["in_cave"]..' '..L["wintersail_note"],
    rewards={
        Achievement({id=12939, criteria=41806}),
        Transmog({item=155422, slot=L["crossbow"]}) -- Pirate Chief's Speargun
    }
}) -- Captain Wintersail

map.nodes[72498104] = Rare({
    id=139152,
    quest=51809,
    rewards={
        Achievement({id=12939, criteria=41812}),
        Transmog({item=155271, slot=L["1h_axe"]}) -- Monkey's Paw Chopper
    }
}) -- Carla Smirk

map.nodes[90507736] = Rare({
    id=132211,
    quest=50155,
    rewards={
        Achievement({id=12939, criteria=41813}),
        Transmog({item=154467, slot=L["leather"]}) -- Parrot-Trainer Mantle
    }
}) -- Fowlmouth

map.nodes[60102220] = Rare({
    id=132127,
    quest=50137,
    rewards={
        Achievement({id=12939, criteria=41814}),
        Transmog({item=160454, slot=L["cloth"]}) -- Foxhollow Falconer's Bracers
    }
}) -- Foxhollow Skyterror

map.nodes[61705154] = Rare({
    id=130350,
    quest=49963, -- 49983 (ride)
    note=L["hay_covered_chest_note"],
    rewards={
        Achievement({id=12852, criteria=41012}),
        Transmog({item=155571, slot=L["cloak"]}) -- Garyl's Riding Blanket
    },
    pois={
        Path({
            61705154, 62145219, 62805261, 63395202, 64025146, 64755138,
            65465164, 66235200, 67005203, 67365163
        }) -- Path to the treasure
    }
}) -- Guardian of the Spring

map.nodes[57845590] = Rare({
    id=139233,
    quest=53373,
    rewards={
        Achievement({id=12939, criteria=41819}),
        Transmog({item=158338, slot=L["cloth"]}) -- Swift-Travel Gloves
    }
}) -- Gulliver

map.nodes[64301936] = Rare({
    id=137183,
    quest=51321,
    note=L["honey_slitherer_note"],
    rewards={
        Achievement({id=12939, criteria=41823}),
        Transmog({item=160472, slot=L["plate"]}) -- Honey-Glazed Gauntlets
    }
}) -- Honey-Coated Slitherer

map.nodes[47832223] = Rare({
    id=131520,
    quest=49984,
    rewards={
        Achievement({id=12939, criteria=41820}),
        Transmog({item=158597, slot=L["shield"]}) -- Silvershell Defender
    }
}) -- Kulett the Ornery

map.nodes[67951999] = Rare({
    id=134106,
    quest=50525,
    rewards={
        Achievement({id=12939, criteria=41821}),
        Transmog({item=155524, slot=L["1h_axe"]}) -- Cursetouched Lumberjack's Axe
    }
}) -- Lumbergrasp Sentinel

map.nodes[58164931] = Rare({
    id=139290,
    quest=51880,
    rewards={
        Achievement({id=12939, criteria=41822}),
        Transmog({item=154458, slot=L["plate"]}) -- Shellbreaker Warhelm
    }
}) -- Maison the Portable

map.nodes[43031675] = Rare({
    id=131252,
    quest=49921,
    note=L["in_waterfall_cave"],
    rewards={
        Achievement({id=12939, criteria=41824}),
        Transmog({item=160461, slot=L["leather"]}) -- Thick Sauroskin Pants
    }
}) -- Merianae

map.nodes[64316330] = Rare({
    id=139205,
    quest=51833,
    rewards={
        Achievement({id=12939, criteria=41825}),
        Transmog({item=161599, slot=L["fist"]}) -- Mechano-Cat Claw
    }
}) -- P4-N73R4

map.nodes[38891530] = Rare({
    id=131262,
    quest=49923,
    note=L["in_cave"],
    rewards={
        Achievement({id=12939, criteria=41826}),
        Item({item=160263, note=L["trinket"]}) -- Snowpelt Mangler
    },
    pois={
        POI({39851491}) -- Cave entrance
    }
}) -- Pack Leader Asenya

map.nodes[64765863] = Rare({
    id=132179,
    quest=50148,
    rewards={
        Achievement({id=12939, criteria=41827}),
        Item({item=161446, note=L["ring"]}) -- Blistering Seawater Seal
    }
}) -- Raging Swell

map.nodes[68306356] = Rare({
    id=139278,
    quest=51872,
    rewards={
        Achievement({id=12939, criteria=41828}),
        Transmog({item=154478, slot=L["leather"]}) -- Ranja-Hide Bracers
    }
}) -- Ranja

map.nodes[58651480] = Rare({
    id=127290,
    quest=48806,
    rewards={
        Achievement({id=12939, criteria=41829}),
        Transmog({item=154416, slot=L["2h_mace"]}) -- Trogg Saurolisk-Breaker
    }
}) -- Saurolisk Tamer Mugg

bor.nodes[80594456] = Rare({
    id=139287,
    quest=51877,
    parent=map.id,
    rewards={
        Achievement({id=12939, criteria=41830}),
        Transmog({item=155273, slot=L["1h_axe"]}) -- Sharktooth Hatchet
    },
    pois={
        Path({
            76143832, 78343810, 79844112, 80594456, 80394854, 78485012,
            76764657, 76024247, 76143832
        })
    }
}) -- Sawtooth

map.nodes[55123241] = Rare({
    id=139285,
    quest=51876,
    rewards={
        Achievement({id=12939, criteria=41831}),
        Transmog({item=155278, slot=L["dagger"]}) -- Shiverscale Spellknife
    }
}) -- Shiverscale the Toxic

map.nodes[80918284] = Rare({
    id=132280,
    quest=50160,
    rewards={
        Achievement({id=12939, criteria=41832}),
        Transmog({item=160455, slot=L["cloth"]}) -- Parrot-Trainer Sash
    }
}) -- Squacks

map.nodes[48883702] = Rare({
    id=139135,
    quest=51807,
    rewards={
        Achievement({id=12939, criteria=41833}),
        Transmog({item=155551, slot=L["wand"]}) -- Squirgle's Deepstone Wand
    }
}) -- Squirgle of the Depths

map.nodes[66611382] = Rare({
    id=139280,
    quest=51873,
    rewards={
        Achievement({id=12939, criteria=41834}),
        Transmog({item=154474, slot=L["leather"]}) -- Sythian Swiftbelt
    }
}) -- Sythian the Swift

map.nodes[60521753] = Rare({
    id=133356,
    quest=50301,
    note=L["tempestria_note"],
    rewards={
        Achievement({id=12939, criteria=41835}),
        Transmog({item=160466, slot=L["mail"]}) -- Saurolisk Broodmother Boots
    }
}) -- Tempestria

map.nodes[55315156] = Rare({
    id=139289,
    quest=51879,
    rewards={
        Achievement({id=12939, criteria=41836}),
        Transmog({item=154448, slot=L["mail"]}) -- Medusa-Drifter's Chainmail
    }
}) -- Tentulos the Drifter

map.nodes[63655035] = Rare({
    id=131389,
    quest=49942,
    rewards={
        Achievement({id=12939, criteria=41837}),
        Item({item=158556, note=L["trinket"]}) -- Siren's Tongue
    }
}) -- Teres

map.nodes[70405573] = Rare({
    id=139235,
    quest=51835,
    rewards={
        Achievement({id=12939, criteria=41838}),
        Transmog({item=159349, slot=L["mail"]}) -- Dragon Turtle Handlers
    }
}) -- Tort Jaw

map.nodes[46842064] = Rare({
    id=132076,
    quest=50095,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12939, criteria=41839}),
        Item({item=160452, note=L["bag"]}) -- Goat's Tote
    }
}) -- Totes

map.nodes[70331248] = Rare({
    id=131984,
    quest=50073,
    note=L["twin_hearted_note"],
    rewards={
        Achievement({id=12939, criteria=41840}),
        Transmog({item=160473, slot=L["plate"]}) -- Wickerthorn Stompers
    }
}) -- Twin-hearted Construct

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- 36983061 48598 Small Treasure Chest
-- 66941635 48619 Small Treasure Chest
-- 66698023 50952 Small Treasure Chest
-- 67346402 48609 Small Treasure Chest
-- 73328244 48596 Small Treasure Chest
-- 76106733 48608 Small Treasure Chest
-- 76368091 48595 Small Treasure Chest
-- 83643572 53631 Dusty Marine Supplies (Scrimshaw Cache on minimap)

-------------------------------------------------------------------------------

map.nodes[72495814] = Treasure({
    quest=50442,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12852, criteria=41013}),
        Item({item=155381, note=L["ring"]}) -- Cutwater-Captain's Sapphire Ring
    }
}) -- Cutwater Treasure Chest

map.nodes[61786275] = Treasure({
    quest=52867,
    note=L["in_small_cave"],
    rewards={
        Achievement({id=12852, criteria=41015})
    }
}) -- Forgotten Smuggler's Stash

map.nodes[67365163] = Treasure({
    quest=49963,
    note=L["hay_covered_chest_note"],
    rewards={
        Achievement({id=12852, criteria=41012}),
        Transmog({item=155571, slot=L["cloak"]}) -- Garyl's Riding Blanket
    },
    pois={
        Path({
            61705154, 62145219, 62805261, 63395202, 64025146, 64755138,
            65465164, 66235200, 67005203, 67365163
        }) -- Path to the treasure
    }
}) -- Hay Covered Chest

map.nodes[56033319] = Treasure({
    quest=52866,
    rewards={
        Achievement({id=12852, criteria=41014})
    }
}) -- Precarious Noble Cache

bor.nodes[63270617] = Treasure({
    quest=52870,
    note=L["in_small_cave"],
    parent=map.id,
    rewards={
        Achievement({id=12852, criteria=41016})
    }
}) -- Scrimshaw Cache

-------------------------------- TREASURE MAPS --------------------------------

map.nodes[29222534] = Treasure({
    quest=52833,
    note=L["pirate_treasure_note"],
    rewards={
        Achievement({id=12852, criteria=41019}),
        Item({item=162580, quest=52854})
    }
}) -- Fading Treasure Map

map.nodes[48983759] = Treasure({
    quest=52845,
    note=L["pirate_treasure_note"],
    rewards={
        Achievement({id=12852, criteria=41021}),
        Item({item=162584, quest=52860})
    }
}) -- Singed Treasure Map

map.nodes[54994608] = Treasure({
    quest=52807,
    note=L["pirate_treasure_note"],
    rewards={
        Achievement({id=12852, criteria=41018}),
        Item({item=162571, quest=52853})
    }
}) -- Soggy Treasure Map

map.nodes[90507551] = Treasure({
    quest=52836,
    note=L["pirate_treasure_note"],
    rewards={
        Achievement({id=12852, criteria=41020}),
        Item({item=162581, quest=52859})
    }
}) -- Yellowed Treasure Map

---------------------------- SECRET OF THE DEPTHS -----------------------------

local Scroll = Class('Scroll', Treasure, {
    icon='scroll',
    label=L["damp_scroll"],
    rewards={
        Achievement({id=12852, criteria=41017}),
        Toy({item=161342}) -- Gem of Acquiescence
    }
})

bor.nodes[55989130] = Scroll({
    quest=52134,
    note=L["in_water_cave"]..' '..L["damp_scroll_note_1"],
    pois={
        POI({61258420}) -- Cave entrance
    }
}) -- A Damp Scroll

bor.nodes[61177788] = Scroll({quest=52135, note=L["damp_scroll_note_2"]}) -- A Damp Scroll
bor.nodes[63078186] = Scroll({quest=52136, note=L["damp_scroll_note_3"]}) -- A Damp Scroll
bor.nodes[70328576] = Scroll({quest=52137, note=L["damp_scroll_note_4"]}) -- A Damp Scroll
bor.nodes[67147982] = Scroll({quest=52138, note=L["damp_scroll_note_5"]}) -- A Damp Scroll

bor.nodes[55699108] = Treasure({
    quest=52195,
    questDeps={52134, 52135, 52136, 52137, 52138},
    label=L["ominous_altar"],
    note=L["in_water_cave"]..' '..L["ominous_altar_note"],
    rewards=Scroll.rewards,
    pois={
        POI({61258420}) -- Cave entrance
    }
}) -- Ominous Altar

map.nodes[73103950] = Treasure({
    quest=52195,
    note=L["secret_of_the_depths_note"],
    rewards=Scroll.rewards
}) -- Secret of the Depths

-------------------------------------------------------------------------------
----------------------------- SECRET SUPPLY CHESTS ----------------------------
-------------------------------------------------------------------------------

local SECRET_CHEST = ns.node.SecretSupply({
    quest=55347,
    rewards={
        Achievement({id=13317, criteria=43934})
    }
}) -- quest = 54714 (looted ever) 55347 (looted today)

map.nodes[74784443] = SECRET_CHEST
map.nodes[79303730] = SECRET_CHEST
map.nodes[82903650] = SECRET_CHEST

-------------------------------------------------------------------------------
------------------------------ WAR SUPPLY CHESTS ------------------------------
-------------------------------------------------------------------------------

map.nodes[40442072] = Supply({
    quest=55411,
    fgroup='supply_path_1',
    pois={Arrow({30002033, 70002183})}
})
map.nodes[43802080] = Supply({
    quest=55411,
    fgroup='supply_path_1'
})
map.nodes[49482106] = Supply({
    quest=55411,
    fgroup='supply_path_1'
})

map.nodes[76667659] = Supply({
    quest=55411,
    fgroup='supply_path_2',
    pois={Arrow({78809426, 73004645})}
})
map.nodes[77538379] = Supply({
    quest=55411,
    fgroup='supply_path_2'
})
map.nodes[78278989] = Supply({
    quest=55411,
    fgroup='supply_path_2'
})

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[88628019] = PetBattle({
    id=141215,
    rewards={
        Achievement({id=12936, criteria=44218})
    }
}) -- Unbreakable (Chitara)

map.nodes[59583330] = PetBattle({
    id=141292,
    note=L["delia_hanako_note"],
    rewards={
        Achievement({id=12936, criteria=44219}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=9, oneline=true}), -- Beast
        Achievement({id=13271, criteria=9, oneline=true}), -- Critter
        Achievement({id=13272, criteria=9, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=9, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=9, oneline=true}), -- Flying
        Achievement({id=13275, criteria=9, oneline=true}), -- Magic
        Achievement({id=13277, criteria=9, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=9, oneline=true}), -- Undead
        Achievement({id=13280, criteria=9, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=9, oneline=true})  -- Humanoid
    }
}) -- That's a Big Carcass (Delia Hanako)

map.nodes[67711285] = PetBattle({
    id=141479,
    note=L["burly_note"],
    rewards={
        Achievement({id=12936, criteria=44220}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=10, oneline=true}), -- Beast
        Achievement({id=13271, criteria=10, oneline=true}), -- Critter
        Achievement({id=13272, criteria=10, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=10, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=10, oneline=true}), -- Flying
        Achievement({id=13275, criteria=10, oneline=true}), -- Magic
        Achievement({id=13277, criteria=10, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=10, oneline=true}), -- Undead
        Achievement({id=13280, criteria=10, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=10, oneline=true})  -- Humanoid
    }
}) -- Strange Looking Dogs (Burly)

map.nodes[86213862] = PetBattle({
    id=141077,
    note=L["kwint_note"],
    rewards={
        Achievement({id=12936, criteria=44217}),
        ns.reward.Spacer(),
        Achievement({id=13270, criteria=8, oneline=true}), -- Beast
        Achievement({id=13271, criteria=8, oneline=true}), -- Critter
        Achievement({id=13272, criteria=8, oneline=true}), -- Dragon
        Achievement({id=13273, criteria=8, oneline=true}), -- Elemental
        Achievement({id=13274, criteria=8, oneline=true}), -- Flying
        Achievement({id=13275, criteria=8, oneline=true}), -- Magic
        Achievement({id=13277, criteria=8, oneline=true}), -- Mechanical
        Achievement({id=13278, criteria=8, oneline=true}), -- Undead
        Achievement({id=13280, criteria=8, oneline=true}), -- Aquatic
        Achievement({id=13281, criteria=8, oneline=true})  -- Humanoid
    }
}) -- Not So Bad Down Here (Kwint)

-------------------------------------------------------------------------------
------------------------------- SAUSAGE SAMPLER -------------------------------
-------------------------------------------------------------------------------

bor.nodes[70622130] = Collectible({
    id=142167,
    icon=133200,
    note=L["sausage_sampler_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    parent=map.id,
    rewards={
        Achievement({id=13087, criteria={
            41648, -- Goldshire Farms Smoked Sausage
            41651, -- Roland's Famous Frankfurter
            41652, -- Rosco Fryer's Mostly-Meat Brat
            41653, -- Timmy Gene Sunrise Pork
        }})
    }
}) -- Charisse Payton

bor.nodes[72606841] = Collectible({
    id=135525,
    icon=133200,
    note=L["sausage_sampler_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    parent=map.id,
    rewards={
        Achievement({id=13087, criteria={
            41652, -- Rosco Fryer's Mostly-Meat Brat
            41653, -- Timmy Gene Sunrise Pork
        }})
    }
}) -- Jaela Billman

bor.nodes[47454604] = Collectible({
    id=137407,
    icon=133200,
    note=L["sausage_sampler_note"],
    group=ns.groups.SAUSAGE_SAMPLER,
    parent=map.id,
    rewards={
        Achievement({id=13087, criteria={
            41648, -- Goldshire Farms Smoked Sausage
            41651, -- Roland's Famous Frankfurter
            41652, -- Rosco Fryer's Mostly-Meat Brat
            41653, -- Timmy Gene Sunrise Pork
        }})
    }
}) -- Edward Stephens

-------------------------------------------------------------------------------
--------------------------------- SHANTY RAID ---------------------------------
-------------------------------------------------------------------------------

bor.nodes[72426942] = Collectible({
    icon=1500866,
    note=L["shanty_lively_note"],
    group=ns.groups.SHANTY_RAID,
    parent=map.id,
    rewards={
        Achievement({id=13057, criteria=41541}),
        Item({item=163714})
    }
}) -- Shanty of the Lively Men

bor.nodes[53141767] = Collectible({
    icon=1500866,
    note=L["shanty_inebriation_note"],
    group=ns.groups.SHANTY_RAID,
    parent=map.id,
    rewards={
        Achievement({id=13057, criteria=41543}),
        Item({item=163716})
    }
}) -- Shanty of Inebriation

map.nodes[43482559] = Collectible({
    icon=1500866,
    note=L["shanty_fruit_note"],
    group=ns.groups.SHANTY_RAID,
    rewards={
        Achievement({id=13057, criteria=41542}),
        Item({item=163715})
    }
}) -- Shanty of Fruit Counting

map.nodes[73218414] = Collectible({
    icon=1500866,
    note=L["shanty_horse_note"],
    group=ns.groups.SHANTY_RAID,
    rewards={
        Achievement({id=13057, criteria=41546}),
        Item({item=163719})
    }
}) -- Shanty of the Horse

-------------------------------------------------------------------------------
--------------------------- THREE SHEETS TO THE WIND --------------------------
-------------------------------------------------------------------------------

bor.nodes[47744734] = Collectible({
    id=137411,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41396, -- "Aurora Borealis"
            41400, -- Blacktooth Bloodwine
            41403, -- Dark and Stormy
            41406, -- Hook Point Porter
            41415, -- Thornspeaker Moonshine
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Joseph Stephens

bor.nodes[58177024] = Collectible({
    id=143487,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41398, -- Arathor Single Cask
            41402  -- Corlain Estate 12 Year
        }})
    }
}) -- Nicolas Moal

bor.nodes[69262986] = Collectible({
    id=142189,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41397, -- Admiralty-Issued Grog
            41406, -- Hook Point Porter
            41411, -- Patina Pale Ale
            41414, -- Snowberry Berliner
            41416, -- Tradewinds Kolsch
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Ruddy the Rat

bor.nodes[75331442] = Collectible({
    id=123639,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41396, -- "Aurora Borealis"
            41399, -- Bitter Darkroot Vodka
            41400, -- Blacktooth Bloodwine
            41401, -- Brennadam Apple Brandy
            41407, -- Hook Point Schnapps
            41410, -- Mildenhall Mead
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Harold Atkey

bor.nodes[74241776] = Collectible({
    id=142188,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41396, -- "Aurora Borealis"
            41399, -- Bitter Darkroot Vodka
            41400, -- Blacktooth Bloodwine
            41401, -- Brennadam Apple Brandy
            41407, -- Hook Point Schnapps
            41415, -- Thornspeaker Moonshine
        }})
    }
}) -- Allison Weber

bor.nodes[71186089] = Collectible({
    id=149397,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41396, -- "Aurora Borealis"
            41399, -- Bitter Darkroot Vodka
            41400, -- Blacktooth Bloodwine
            41401, -- Brennadam Apple Brandy
            41407, -- Hook Point Schnapps
            41415, -- Thornspeaker Moonshine
        }})
    }
}) -- Kul Tiran Attendant

bor.nodes[54994361] = Collectible({
    id=134729,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41397, -- Admiralty-Issued Grog
            41406, -- Hook Point Porter
            41411, -- Patina Pale Ale
            41414, -- Snowberry Berliner
            41416, -- Tradewinds Kolsch
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Crimper Mirjam

bor.nodes[75451861] = Collectible({
    id=143246,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41397, -- Admiralty-Issued Grog
            41400, -- Blacktooth Bloodwine
        }})
    }
}) -- Garrett Elmendorf

bor.nodes[74121265] = Collectible({
    id=135153,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41399, -- Bitter Darkroot Vodka
            41404, -- Drop Anchor Dunkel
            41406, -- Hook Point Porter
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Wesley Rockhold

bor.nodes[66516137] = Collectible({
    id=144115,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41399, -- Bitter Darkroot Vodka
            41404, -- Drop Anchor Dunkel
            41406, -- Hook Point Porter
            41417, -- Whitegrove Pale Ale
        }})
    }
}) -- Diana Seafinch

bor.nodes[72141491] = Collectible({
    id=143244,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41404, -- Drop Anchor Dunkel
            41406, -- Hook Point Porter
            41407, -- Hook Point Schnapps
            41408, -- Kul Tiran Tripel
            41412, -- Pontoon Pilsner
            41416, -- Tradewinds Kolsch
        }})
    },
    pois={
        Path({
            73881267, 73411449, 74791580, 75411818, 74051785, 72651602,
            71101619, 72141491, 73411449
        })
    }
}) -- Victor Esquivias

bor.nodes[53987523] = Collectible({
    id=139113,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria={
            41404, -- Drop Anchor Dunkel
            41407, -- Hook Point Schnapps
            41408, -- Kul Tiran Tripel
        }})
    }
}) -- Bored Barkeep

bor.nodes[65463929] = Collectible({
    id=135216,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    parent=map.id,
    rewards={
        Achievement({id=13061, criteria=41404}) -- Drop Anchor Dunkel
    }
}) -- Ron Mahogany <The Anchor Man>

-------------------------------------------------------------------------------

map.nodes[49792529] = Collectible({
    id=126601,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    faction='Alliance',
    rewards={
        Achievement({id=13061, criteria={
            41404, -- Drop Anchor Dunkel
            41406, -- Hook Point Porter
            41407, -- Hook Point Schnapps
            41408, -- Kul Tiran Tripel
            41412, -- Pontoon Pilsner
            41416, -- Tradewinds Kolsch
        }})
    }
}) -- Sarella Griffin

map.nodes[77198426] = Collectible({
    id=129044,
    icon=135999,
    note=L["three_sheets_note"],
    group=ns.groups.THREE_SHEETS,
    rewards={
        Achievement({id=13061, criteria={
            41397, -- Admiralty-Issued Grog
            41400, -- Blacktooth Bloodwine
        }})
    }
}) -- Martha Mae

-------------------------------------------------------------------------------
------------------------------ UPRIGHT CITIZENS -------------------------------
-------------------------------------------------------------------------------

local Citizen = Class('UprightCitizen', Collectible, {
    icon=516667,
    group=ns.groups.UPRIGHT_CITIZENS,
    note=L["upright_citizens_node"]
})

bor.nodes[66806410] = Citizen({
    id=145107,
    rewards={
        Achievement({id=13285, criteria=43720}),
        Toy({item=166247}) -- Citizens Brigade Whistle
    }
}) -- Leeroy Jenkins

bor.nodes[72306160] = Citizen({
    id=146295,
    rewards={
        Achievement({id=13285, criteria=43719}),
        Toy({item=166247}) -- Citizens Brigade Whistle
    }
}) -- Flynn Fairwind

bor.nodes[72706920] = Citizen({
    id=145101,
    rewards={
        Achievement({id=13285, criteria=43718}),
        Toy({item=166247}) -- Citizens Brigade Whistle
    }
}) -- Russel the Bard