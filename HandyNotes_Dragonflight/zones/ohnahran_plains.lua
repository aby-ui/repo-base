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
local PetBattle = ns.node.PetBattle
local PT = ns.node.ProfessionTreasures
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2023, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

-- map.nodes[] = Rare({
--     id = 195186,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56092}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Cinta the Forgotten

map.nodes[30546628] = Rare({
    id = 189652,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56068}),
        Transmog({item = 189055, slot = L['wand']}) -- Ghendish's Backup Talisman
    },
    pois = {
        Path({
            31686814, 31426810, 31206769, 30796652, 30546628, 30246637,
            29586720, 29286786, 29186827
        })
    }
}) -- Deadwaker Ghendish

map.nodes[49866673] = Rare({
    id = 192020,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56077})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Eaglemaster Niraak

map.nodes[49866673] = Rare({
    id = 192020,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56077})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Eaglemaster Niraak

map.nodes[56718128] = Rare({
    id = 193142,
    quest = 69840,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16677, criteria = 56064})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Enraged Sapphire

map.nodes[74414762] = Rare({ -- reqiured 67030 review
    id = 193170,
    quest = 69856,
    rewards = {
        Achievement({id = 16677, criteria = 56075})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Fulgurb

map.nodes[85221544] = Rare({ -- review
    id = 187781,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56082})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Hamett

-- map.nodes[] = Rare({
--     id = 188095,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56083}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Hunter of Deep

map.nodes[80413867] = Rare({ -- review
    id = 188124,
    quest = 66356,
    rewards = {Achievement({id = 16677, criteria = 56084})}
}) -- Irontree

map.nodes[87556151] = Rare({
    id = 197009,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56067}), --
        Toy({item = 200249}) -- Mage's Chewed Wand
    }
}) -- Liskheszaera

map.nodes[32823817] = Rare({ -- review
    id = 195409,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56094})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Makhra the Ashtouched

map.nodes[71694585] = Rare({
    id = 193212,
    quest = 69871,
    rewards = {Achievement({id = 16677, criteria = 56073})}
}) -- Malsegan

map.nodes[63017996] = Rare({ -- reqiured 67030
    id = 193173,
    quest = 69857,
    rewards = {
        Achievement({id = 16677, criteria = 56070}),
        Item({item = 200542, note = L['trinket']}) -- Breezy Companion
    }
}) -- Mikrin of the Raging Winds

-- map.nodes[] = Rare({
--     id = 187219,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56081}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Nokhud Warmaster

-- map.nodes[] = Rare({
--     id = 196350,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56096}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Old Stormhide

map.nodes[61212950] = Rare({ -- reqiured 67030
    id = 193235,
    quest = 69877,
    rewards = {Achievement({id = 16677, criteria = 56074})}
}) -- Oshigol

-- map.nodes[] = Rare({
--     id = 191950,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56087}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Porta the Overgrown

-- map.nodes[] = Rare({
--     id = 192557,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56091}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Quackers the Terrible

-- map.nodes[] = Rare({ -- reqiured 67030
--     id = 196010,
--     quest = 70698,
--     rewards = {
--         Achievement({id = 16677, criteria = 56069}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Researcher Sneakwing

-- map.nodes[] = Rare({ -- reqiured 67030
--     id = 193227,
--     quest = 69878,
--     rewards = {
--         Achievement({id = 16677, criteria = 56071}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Ronsak the Decimator

map.nodes[42804428] = Rare({ -- review
    id = 195223,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56093})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Rustlily

-- map.nodes[] = Rare({
--     id = 193215,
--     quest = 69865,
--     rewards = {
--         Achievement({id = 16677, criteria = 56079}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Scaleseeker Mezeri

map.nodes[50117517] = Rare({
    id = 193136,
    quest = 69863,
    rewards = {Achievement({id = 16677, criteria = 56063})}
}) -- Scav Notail

map.nodes[61801283] = Rare({
    id = 193188,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56065})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Seeker Teryx

map.nodes[29964103] = Rare({
    id = 187559,
    quest = 69854,
    note = L['shade_of_grief_note'],
    rewards = {
        Achievement({id = 16677, criteria = 56080})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Shade of Grief

-- map.nodes[] = Rare({
--     id = 193165,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56062}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Sparkspitter Vrak

map.nodes[53627281] = Rare({ -- reqiured 67030 review
    id = 193123,
    quest = 69667,
    rewards = {
        Achievement({id = 16677, criteria = 56072}),
        Transmog({item = 200216, slot = L['cloth']}) -- Water Heating Cord
    }
}) -- Steamgill

map.nodes[78298276] = Rare({
    id = 191842,
    quest = nil,
    rewards = {Achievement({id = 16677, criteria = 56086})}
}) -- Sulfurion

-- map.nodes[] = Rare({
--     id = 196334,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56095}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- The Great Enla

-- map.nodes[] = Rare({
--     id = 195204,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56088}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- The Jolly Giant

-- map.nodes[] = Rare({
--     id = 192453,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56090}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Vaniik the Stormtouched

map.nodes[84214784] = Rare({
    id = 192364,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56089})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Windscale the Stormborn

map.nodes[58596822] = Rare({ -- review
    id = 192045,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56076})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Windseeker Avash

-- map.nodes[] = Rare({
--     id = 193140,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16677, criteria = 56078}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Zarizz

map.nodes[31456387] = Rare({
    id = 193209,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56066}),
        Transmog({item = 200314, slot = L['cloth']}), -- Skyspeaker's Envelope
        Item({item = 197372, quest = 69573}), -- Renewed Proto-Drake: Purple Hair
        Mount({item = 198825, id = 1672}) -- Zenet Hatchling
    }
}) -- Zenet Avis

map.nodes[72232306] = Rare({
    id = 188451,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56085})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Zerimek

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[73495613] = Treasure({
    quest = 70402,
    rewards = {
        Achievement({id = 16299, criteria = 54709}), --
        Toy({item = 200869}) -- Ohn Lite Branded Horn
    }
}) -- Cracked Centaur Horn

map.nodes[33205532] = Treasure({
    quest = 70391,
    note = L['gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Item(198843) -- Emerald Gardens Explorer's Notes
    },
    rewards = {
        Achievement({id = 16299, criteria = 54700}), --
        Item({item = 200865}) -- Glimmering Ysemerald Cluster
    }
}) -- Emerald Gem Cluster

map.nodes[82327339] = Treasure({
    quest = 70379,
    note = L['gold_swong_coin_note'],
    rewards = {
        Achievement({id = 16299, criteria = 54710}), --
        Item({item = 199338}) -- Copper Coin of the Isles
    },
    pois = {POI({81847223})}
}) -- Gold Swog Coin

map.nodes[32423817] = Treasure({
    quest = 67049,
    note = L['nokhud_warspear_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Item(194540) -- Nokhud Armorer's Notes
    },
    rewards = {Achievement({id = 16299, criteria = 54707})}
}) -- Nokhud Warspear

map.nodes[70603543] = Treasure({
    quest = 67950, -- 67718
    note = L['slightly_chewed_duck_egg_note'],
    requires = ns.requirement.Item(195453), -- Ludo's Stash Map
    rewards = {
        Achievement({id = 16299, criteria = 54708}),
        Pet({item = 199172, id = 3309}) -- Viridescent Duck
    },
    pois = {Path({61044337, 61274149, 61524124, 61754141, 61864232})}
}) -- Slightly Chewed Duck Egg (Dirt Mound)

map.nodes[51985839] = Treasure({
    quest = {70400, 72063}, -- Treasure, Return Yennu's Toy Boat
    label = L['yennus_boat'],
    note = L['yennus_boat_note'],
    rewards = {
        Achievement({id = 16299, criteria = 54711}), --
        Toy({item = 200878}) -- Wheeled Floaty Boaty Controller
    }
}) -- Yennu's Boat

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[24384234] = PetBattle({
    id = 197447,
    rewards = {
        Achievement({id = 16464, criteria = 55486}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 7, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 7, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 7, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 7, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 7, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 7, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 7, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 7, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 7, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 7, oneline = true}) -- Undead
    }
}) -- Stormamu

map.nodes[61964159] = PetBattle({
    id = 197102,
    rewards = {
        Achievement({id = 16464, criteria = 55492}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 2, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 2, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 2, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 2, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 2, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 2, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 2, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 2, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 2, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 2, oneline = true}) -- Undead
    }
}) -- Bakhushek

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

map.nodes[59926696] = BonusBoss({
    id = 193669,
    quest = 72815,
    rewards = {
        Item({item = 200161, note = L['trinket']}) -- Razorwind Talisman
    }
}) -- Prozela Galeshot

map.nodes[26366533] = BonusBoss({
    id = 193153,
    quest = 72845,
    note = L['in_small_cave'],
    rewards = {
        Transmog({item = 200137, slot = L['dagger']}), -- Chitin Dreadbringer
        Transmog({item = 200193, slot = L['cloth']}) -- Manafrond Sandals
    }
}) -- Ripsaw the Stalker

map.nodes[44894924] = BonusBoss({
    id = 192949,
    quest = 72847, -- 70783
    note = L['in_small_cave'],
    rewards = {
        Transmog({item = 200186, slot = L['mail']}) -- Amberquill Shroud
    }
}) -- Skaara

map.nodes[63034854] = BonusBoss({
    id = 193133,
    quest = 72849, -- 69837
    note = L['in_waterfall_cave'],
    rewards = {
        Toy({item = 198409}) -- Personal Shell
    }
}) -- Sunscale Behemoth

map.nodes[22956670] = BonusBoss({
    id = 193163,
    quest = 72851, -- 66378
    rewards = {
        Transmog({item = 200212, slot = L['mail']}), -- Sand-Encrusted Greaves
        Item({item = 197111, quest = 69312}) -- Highland Drake: Maned Head
    }
}) -- Territorial Coastling

map.nodes[26073412] = BonusBoss({
    id = 191354,
    quest = 72852, -- 66970
    note = L['in_cave'],
    rewards = {
        Transmog({item = 198429, slot = L['staff']}) -- Typhoon Bringer
    },
    pois = {POI({23573442})}
}) -- Ty'foon the Ascended

-------------------------------------------------------------------------------
----------------------------- PROFESSION TREASURES ----------------------------
-------------------------------------------------------------------------------

map.nodes[25203540] = PT.Jewelcrafting({
    id = 198670,
    quest = 70282,
    note = L['pt_jewel_lofty_malygite_note']
}) -- Lofty Malygite

map.nodes[35344012] = PT.Tailoring({
    id = 198692,
    quest = 70295,
    note = L['pt_tailor_noteworthy_scrap_of_carpet_note']
}) -- Noteworthy Scrap of Carpet

map.nodes[50906650] = PT.Blacksmithing({
    id = 201009,
    quest = nil,
    note = L['pt_smith_falconer_gauntlet_drawings_note']
}) -- Falconer Gauntlet Drawings

map.nodes[61406760] = PT.Enchanting({
    id = 198689,
    quest = 70291,
    note = L['pt_ench_stormbound_horn_note']
}) -- Stormbound Horn

map.nodes[61801300] = PT.Jewelcrafting({
    id = 198660,
    quest = 70263,
    note = L['pt_jewel_fragmented_key_note']
}) -- Fragmented Key

map.nodes[66105290] = PT.Tailoring({
    id = 201020,
    quest = 70303,
    note = L['pt_tailor_silky_surprise_note']
}) -- Silky Surprise

map.nodes[79208380] = PT.Alchemy({
    id = 198710,
    quest = nil,
    note = L['pt_alch_canteen_of_suspicious_water_note']
}) -- Canteen Of Suspicious Water

map.nodes[81103790] = PT.Blacksmithing({
    id = 201004,
    quest = nil,
    note = L['pt_smith_ancient_spear_shards_note'],
    pois = {POI({79403650})}
}) -- Ancient Spear Shards

map.nodes[85702520] = PT.Inscription({
    id = 198703,
    quest = nil,
    note = L['pt_script_sign_language_reference_sheet_note']
}) -- Sign Language Reference Sheet

map.nodes[86405370] = PT.Leatherworking({
    id = 198696,
    quest = nil,
    note = L['pt_leath_wind_blessed_hide_note']
}) -- Wind-Blessed Hide

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

map.nodes[84577779] = Dragonglyph({rewards = {Achievement({id = 16061})}}) -- Dragon Glyphs: Dragonsprings Summit
map.nodes[30126135] = Dragonglyph({rewards = {Achievement({id = 16056})}}) -- Dragon Glyphs: Emerald Gardens
map.nodes[70108668] = Dragonglyph({rewards = {Achievement({id = 16672})}}) -- Dragon Glyphs: Forkriver Crossing (Azure Span)
map.nodes[78312131] = Dragonglyph({rewards = {Achievement({id = 16671})}}) -- Dragon Glyphs: Mirewood Fen
map.nodes[46977284] = Dragonglyph({rewards = {Achievement({id = 16059})}}) -- Dragon Glyphs: Mirror of the Sky
map.nodes[30713557] = Dragonglyph({rewards = {Achievement({id = 16055})}}) -- Dragon Glyphs: Nokhudon Hold
map.nodes[57973111] = Dragonglyph({rewards = {Achievement({id = 16054})}}) -- Dragon Glyphs: Ohn'ahra's Roost
map.nodes[57088047] = Dragonglyph({rewards = {Achievement({id = 16060})}}) -- Dragon Glyphs: Ohn'iri Springs
map.nodes[80011306] = Dragonglyph({rewards = {Achievement({id = 16670})}}) -- Dragon Glyphs: Rubyscale Outpost
map.nodes[86513940] = Dragonglyph({rewards = {Achievement({id = 16062})}}) -- Dragon Glyphs: Rusza'thar Reach
map.nodes[44616457] = Dragonglyph({rewards = {Achievement({id = 16058})}}) -- Dragon Glyphs: Szar Skeleth
map.nodes[29447572] = Dragonglyph({rewards = {Achievement({id = 16057})}}) -- Dragon Glyphs: The Eternal Kurgans
map.nodes[61486436] = Dragonglyph({rewards = {Achievement({id = 16063})}}) -- Dragon Glyphs: Windsong Rise

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

map.nodes[28317764] = Flag({quest = 71200})
map.nodes[30393646] = Flag({quest = 71207})
map.nodes[57753080] = Flag({quest = 70827})
map.nodes[86313928] = Flag({quest = 71208})

-------------------------------------------------------------------------------
----------------------------- WHO'S A GOOD BAKAR? -----------------------------
-------------------------------------------------------------------------------

local Bakar = Class('Bakar', Collectible, {
    icon = 930453,
    note = L['bakar_note'],
    group = ns.groups.BAKAR
})

map.nodes[40925653] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55348})}
}) -- Alli

map.nodes[84242474] = Bakar({
    requires = ns.requirement.Quest(66006), -- Return to Roscha
    rewards = {Achievement({id = 16424, criteria = 55316})}
}) -- Baba

map.nodes[49014111] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55329})}
}) -- Baga

map.nodes[60643982] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55326})}
}) -- Berrel

map.nodes[85142247] = Bakar({
    requires = ns.requirement.Quest(65954), -- Release the Hounds
    rewards = {Achievement({id = 16424, criteria = 55317})}
}) -- Elaichi

map.nodes[76683051] = Bakar({ -- review requirement
    note = L['bakar_note'] .. '\n\n' .. L['bakar_ellam_note'],
    rewards = {Achievement({id = 16424, criteria = 55321})}
}) -- Ellam

map.nodes[84592461] = Bakar({
    requires = ns.requirement.Quest(65954), -- Release the Hounds
    rewards = {
        Achievement({
            id = 16424,
            criteria = {
                {id = 55315}, -- Fogl
                {id = 55314} -- Zephyr
            }
        })
    }
})

map.nodes[83882587] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55320})}
}) -- Gentara

map.nodes[70616361] = Bakar({
    note = L['bakar_note'] .. '\n\n' .. L['bakar_hugo_note'],
    rewards = {Achievement({id = 16424, criteria = 55327})},
    pois = {POI({71103149, 55635248})}
}) -- Hugo

map.nodes[64024123] = Bakar({
    rewards = {
        Achievement({
            id = 16424,
            criteria = {
                {id = 55323}, -- Katei
                {id = 55322} -- Vinyu
            }
        })
    }
})

map.nodes[80685891] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55331})}
}) -- Laila

map.nodes[60985226] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55328})}
}) -- Nahma

map.nodes[84182715] = Bakar({
    requires = ns.requirement.Quest(65954), -- Release the Hounds
    rewards = {Achievement({id = 16424, criteria = 55319})}
}) -- Pesca

map.nodes[81115841] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55330})}
}) -- Rotti

map.nodes[71644967] = Bakar({
    requires = ns.requirement.Quest(67772), -- The Trouble with Taivan
    rewards = {Achievement({id = 16424, criteria = 55347})},
    pois = {POI({61164002})} -- questline start
}) -- Soyoo

map.nodes[61833862] = Bakar({
    requires = ns.requirement.Quest(69096), -- Taivan's Purpose
    rewards = {Achievement({id = 16424, criteria = 55325})},
    pois = {POI({61164002})} -- questline start
}) -- Taivan

map.nodes[84012295] = Bakar({
    requires = ns.requirement.Quest(65954), -- Release the Hounds
    rewards = {Achievement({id = 16424, criteria = 55318})}
}) -- Tseg

map.nodes[81035952] = Bakar({
    rewards = {Achievement({id = 16424, criteria = 55324})}
}) -- Wish

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[36553269] = Disturbeddirt()
map.nodes[41103789] = Disturbeddirt()
map.nodes[42335555] = Disturbeddirt()
map.nodes[43316632] = Disturbeddirt()
map.nodes[49716952] = Disturbeddirt()
map.nodes[55197076] = Disturbeddirt()
map.nodes[51936274] = Disturbeddirt()
map.nodes[62171310] = Disturbeddirt()
map.nodes[63251396] = Disturbeddirt()
map.nodes[65868145] = Disturbeddirt()
map.nodes[66451981] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[21875784] = Scoutpack()
map.nodes[24745680] = Scoutpack()
map.nodes[25205876] = Scoutpack()
map.nodes[32043887] = Scoutpack()
map.nodes[43486213] = Scoutpack()
map.nodes[44856758] = Scoutpack()
map.nodes[51647211] = Scoutpack()
map.nodes[51797550] = Scoutpack()
map.nodes[60567702] = Scoutpack()
map.nodes[61301817] = Scoutpack()
map.nodes[61781881] = Scoutpack()
map.nodes[64028081] = Scoutpack()
map.nodes[65021064] = Scoutpack()
map.nodes[66798258] = Scoutpack()
map.nodes[91393390] = Scoutpack()
map.nodes[43335647] = Scoutpack()
map.nodes[23944019] = Scoutpack()

-------------------------------------------------------------------------------
----------------------------- HONOR OUR ANCESTORS -----------------------------
-------------------------------------------------------------------------------

local Ancestor = Class('Ancestor', Collectible, {
    icon = 135946,
    note = L['ancestor_note'],
    group = ns.groups.ANCESTOR,
    pois = {POI({85702073})} -- Essence of Awakening
})

map.nodes[75934205] = Ancestor({
    id = 197051,
    requires = ns.requirement.Item(194690), -- Horn o' Mead
    rewards = {Achievement({id = 16423, criteria = 55304})}
}) -- Horn of Drusahl

map.nodes[60323806] = Ancestor({
    id = 197048,
    requires = ns.requirement.Item(197776), -- Thrice-Spiced Mammoth Kabob
    rewards = {Achievement({id = 16423, criteria = 55302})}
}) -- Maruukai

map.nodes[54377841] = Ancestor({
    id = 197056,
    requires = ns.requirement.Item(202071), -- Elemental Mote
    rewards = {Achievement({id = 16423, criteria = 55309})}
}) -- Ohn'iri Springs

map.nodes[85174935] = Ancestor({
    id = 197053,
    requires = ns.requirement.Item(193470), -- Feral Hide Drums
    rewards = {Achievement({id = 16423, criteria = 55306})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({84504840, 84874867, 85174935, 85905011})
    }
}) -- Shikaar Highlands

map.nodes[63275731] = Ancestor({
    id = 197055,
    requires = ns.requirement.Item(197788, 2), --  Braised Bruffalon Brisket
    rewards = {Achievement({id = 16423, criteria = 55308})}
}) -- Sylvan Glade

map.nodes[41655690] = Ancestor({
    id = 197057,
    requires = ns.requirement.Item(190501), -- Primal Molten Greatbelt
    rewards = {Achievement({id = 16423, criteria = 55310})}
}) -- Teerakai

map.nodes[74057046] = Ancestor({
    id = 197054,
    requires = ns.requirement.Item(190327), -- Awakened Air
    rewards = {Achievement({id = 16423, criteria = 55307})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({
            74427207, 74267178, 74307116, 74697041, 74747013, 74686969,
            74386964, 74266983, 74247031, 74057046, 73787063, 73667084,
            73617122, 73927161, 74147214, 74427207
        })
    }
}) -- The Carving Winds

map.nodes[32356934] = Ancestor({
    id = 197058,
    requires = ns.requirement.Item(191470, 5), -- Writhebark
    rewards = {Achievement({id = 16423, criteria = 55311})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({32967236, 32977116, 32606972, 32356934, 31476857, 31126843})
    }
}) -- The Eternal Kurgans

map.nodes[84692429] = Ancestor({
    id = 197050,
    requires = ns.requirement.Item(200018), -- Enchant Boots - Plainsrunner's Breeze
    rewards = {Achievement({id = 16423, criteria = 55303})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({
            84692279, 84662303, 84932349, 84902372, 84692429, 84812453,
            84952466, 85192541, 85182565, 84892587, 84572629, 84172642, 84022698
        })
    }
}) -- Timberstep Outpost

map.nodes[73305513] = Ancestor({
    id = 197052,
    requires = ns.requirement.Item(202070), -- Exceptional Pelt
    rewards = {Achievement({id = 16423, criteria = 55305})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({
            72675702, 72725683, 72575648, 72375653, 72225633, 72285582,
            72495567, 72775575, 73175517, 73305513, 73875547, 74325605
        })
    }
}) -- Toghusuq Village

-------------------------------------------------------------------------------
----------------------------- SLEEPING ON THE JOB -----------------------------
-------------------------------------------------------------------------------

local Dreamguard = Class('Dreamguard', Collectible, {
    icon = 341763,
    note = L['dreamguard_note'],
    group = ns.groups.DREAMGUARD
})

map.nodes[29796222] = Dreamguard({
    id = 198068,
    rewards = {Achievement({id = 16574, criteria = 55777})},
    pois = {
        POI({29696022}) -- Entrance
    }
}) -- Dreamguard Erezsra

map.nodes[25256527] = Dreamguard({
    id = 198069,
    rewards = {Achievement({id = 16574, criteria = 55778})}
}) -- Dreamguard Sayliasra

map.nodes[19128296] = Dreamguard({
    id = 198073,
    rewards = {Achievement({id = 16574, criteria = 55780})}
}) -- Dreamguard Lucidra

map.nodes[18125388] = Dreamguard({
    id = 198074,
    rewards = {Achievement({id = 16574, criteria = 55779})}
}) -- Dreamguard Aiyelasra

map.nodes[29434138] = Dreamguard({
    id = 198075,
    rewards = {Achievement({id = 16574, criteria = 55781})}
}) -- Dreamguard Taelyasra

map.nodes[33555322] = Dreamguard({
    id = 198064,
    rewards = {Achievement({id = 16574, criteria = 55776})}
}) -- Dreamguard Felyasra

-------------------------------------------------------------------------------
--------------------------------- DRAGONRACES ---------------------------------
-------------------------------------------------------------------------------

map.nodes[63743051] = ns.node.Dragonrace({
    label = '{quest:66835}',
    normal = {2060, 52, 44},
    advanced = {2061, 46, 41},
    rewards = {
        Achievement({id = 15918, criteria = 1, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 1, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 1, oneline = true}), -- normal gold
        Achievement({id = 15930, criteria = 1, oneline = true}), -- advanced bronze
        Achievement({id = 15931, criteria = 1, oneline = true}), -- advanced silver
        Achievement({id = 15932, criteria = 1, oneline = true}) -- advanced gold
    }
}) -- Sundapple Copse Circuit

map.nodes[86263583] = ns.node.Dragonrace({
    label = '{quest:66877}',
    normal = {2062, 51, 44},
    advanced = {2063, 46, 41},
    rewards = {
        Achievement({id = 15918, criteria = 2, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 2, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 2, oneline = true}), -- normal gold
        Achievement({id = 15930, criteria = 2, oneline = true}), -- advanced bronze
        Achievement({id = 15931, criteria = 2, oneline = true}), -- advanced silver
        Achievement({id = 15932, criteria = 2, oneline = true}) -- advanced gold
    }
}) -- Fen Flythrough

map.nodes[80887221] = ns.node.Dragonrace({
    label = '{quest:66880}',
    normal = {2064, 52, 50},
    advanced = {2065, 52, 47},
    rewards = {
        Achievement({id = 15918, criteria = 3, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 3, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 3, oneline = true}), -- normal gold
        Achievement({id = 15930, criteria = 3, oneline = true}), -- advanced bronze
        Achievement({id = 15931, criteria = 3, oneline = true}), -- advanced silver
        Achievement({id = 15932, criteria = 3, oneline = true}) -- advanced gold
    }
}) -- Ravine River Run

map.nodes[25715508] = ns.node.Dragonrace({
    label = '{quest:66885}',
    normal = {2066, 66, 59},
    advanced = {2067, 60, 55},
    rewards = {
        Achievement({id = 15918, criteria = 4, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 4, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 4, oneline = true}), -- normal gold
        Achievement({id = 15930, criteria = 4, oneline = true}), -- advanced bronze
        Achievement({id = 15931, criteria = 4, oneline = true}), -- advanced silver
        Achievement({id = 15932, criteria = 4, oneline = true}) -- advanced gold
    }
}) -- Emerald Garden Ascent

map.nodes[59933555] = ns.node.Dragonrace({
    label = '{quest:66921}',
    normal = {2069, 28, 25},
    rewards = {
        Achievement({id = 15918, criteria = 5, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 5, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 5, oneline = true}) -- normal gold
    }
}) -- Maruukai Dash

map.nodes[47487064] = ns.node.Dragonrace({
    label = '{quest:66933}',
    normal = {2070, 29, 26},
    rewards = {
        Achievement({id = 15918, criteria = 6, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 6, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 6, oneline = true}) -- normal gold
    }
}) -- Mirror of Sky Dash

map.nodes[43746678] = ns.node.Dragonrace({
    label = '{quest:70710}',
    normal = {2119, 51, 46},
    advanced = {2120, 48, 43},
    rewards = {
        Achievement({id = 15918, criteria = 7, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 7, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 7, oneline = true}), -- normal gold
        Achievement({id = 15930, criteria = 5, oneline = true}), -- advanced bronze
        Achievement({id = 15931, criteria = 5, oneline = true}), -- advanced silver
        Achievement({id = 15932, criteria = 5, oneline = true}) -- advanced gold
    }
}) -- River Rapids Route

-------------------------------------------------------------------------------
------------------------- LIZI, THUNDERSPINE TRAMPLER -------------------------
-------------------------------------------------------------------------------

-- https://www.wowhead.com/news/lizi-thunderspine-trampler-nurse-a-thunderspine-to-health-for-a-mount-in-328734
-- Daily completion: 71203

local Lizi = Class('Lizi', Collectible, {
    id = 190014, -- Initiate Radiya
    icon = 4008180, -- Inv_thunderlizardprimal_brown
    quest = {71196, 71197, 71198, 71199, 71195}, -- dailys
    questCount = true,
    requires = {
        ns.requirement.Quest(66676), -- Sneaking In
        ns.requirement.Reputation(2503, 9, true) -- Maruuk Centaur
    },
    rewards = {Mount({item = 192799, id = 1639})} -- Lizi's Reins
})

function Lizi.getters:note()
    local function status(i)
        if C_QuestLog.IsQuestFlaggedCompleted(self.quest[i]) then
            return ns.status.Green(i)
        else
            return ns.status.Red(i)
        end
    end

    local note = L['lizi_note']
    note = note .. '\n\n' .. status(1) .. ' ' .. L['lizi_note_day1'] -- Fluorescent Fluid
    note = note .. '\n\n' .. status(2) .. ' ' .. L['lizi_note_day2'] -- High-Fiber Leaf
    note = note .. '\n\n' .. status(3) .. ' ' .. L['lizi_note_day3'] -- Thousandbine Piranha
    note = note .. '\n\n' .. status(4) .. ' ' .. L['lizi_note_day4'] -- Woolly Mountain Pelt
    note = note .. '\n\n' .. status(5) .. ' ' .. L['lizi_note_day5'] -- Meluun's Green Curry
    return note
end

map.nodes[56207710] = Lizi()

-------------------------------------------------------------------------------
---------------------- OHN'AHRA, DIVINE KISS OF OHN'AHRA ----------------------
-------------------------------------------------------------------------------

-- https://www.wowhead.com/news/divine-kiss-of-ohnahra-ohuna-transformation-mount-in-dragonflight-329817

local Ohnahra = Class('Ohnahra', Collectible, {
    id = 194796, -- Ohn'ahra
    icon = 4094306, -- Inv_eagle2windmount_white
    requires = {
        ns.requirement.Quest(66676), -- Sneaking In
        ns.requirement.Reputation(2503, 9, true) -- Maruuk Centaur
    },
    rewards = {
        Mount({item = 198821, id = 1545}) -- Divine Kiss of Ohn'ahra
    },
    pois = {
        POI({56257595, 56457327, 60403772}) -- Initiate Radiya, Godoloto, Quatermaster Huseng
    }
}) -- Ohn'ahra

function Ohnahra.getters:note()
    local function status(id, count)
        if ns.PlayerHasItem(id, count) then
            return ns.status.Green(count .. 'x')
        else
            return ns.status.Red(count .. 'x')
        end
    end

    local note = L['ohnahra_note_start']
    note = note .. '\n\n' .. status(201929, 3) .. ' ' .. L['ohnahra_note_item1'] -- Stolen Breath of Ohn'ahra
    note = note .. '\n\n' .. status(201323, 1) .. ' ' .. L['ohnahra_note_item2'] -- Essence of Awakening
    note = note .. '\n\n' .. status(191507, 1) .. ' ' .. L['ohnahra_note_item3'] -- Exultant Incense
    return note .. '\n\n' .. L['ohnahra_note_end']
end

map.nodes[57473193] = Ohnahra()
