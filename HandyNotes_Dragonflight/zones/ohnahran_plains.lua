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
local ElementalStorm = ns.node.ElementalStorm
local Flag = ns.node.Flag
local LegendaryCharacter = ns.node.LegendaryCharacter
local MagicBoundChest = ns.node.MagicBoundChest
local PM = ns.node.ProfessionMasters
local PrettyNeat = ns.node.PrettyNeat
local PT = ns.node.ProfessionTreasures
local Safari = ns.node.Safari
local Scoutpack = ns.node.Scoutpack
local SignalTransmitter = ns.node.SignalTransmitter
local Squirrel = ns.node.Squirrel

local Achievement = ns.reward.Achievement
local Currency = ns.reward.Currency
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Circle = ns.poi.Circle
local Path = ns.poi.Path
local POI = ns.poi.POI

local DC = ns.DRAGON_CUSTOMIZATIONS

-------------------------------------------------------------------------------

local map = Map({id = 2023, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[31567644] = Rare({
    id = 195186,
    quest = 73950,
    rewards = {Achievement({id = 16677, criteria = 56092})}
}) -- Cinta the Forgotten

map.nodes[30546628] = Rare({
    id = 189652,
    quest = 73872,
    rewards = {
        Achievement({id = 16677, criteria = 56068}),
        Transmog({item = 189055, slot = L['wand']}), -- Ghendish's Backup Talisman
        DC.RenewedProtoDrake.GrayHair
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
    quest = 74063,
    note = L['eaglemaster_niraak_note'],
    rewards = {
        Achievement({id = 16677, criteria = 56077}),
        Transmog({item = 200308, slot = L['bow']}), -- Rellen's Legacy
        Transmog({item = 200441, slot = L['leather']}) -- Jhakan's Horned Cowl
    }
}) -- Eaglemaster Niraak

map.nodes[56718128] = Rare({
    id = 193142,
    quest = 73875,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16677, criteria = 56064})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Enraged Sapphire

map.nodes[74414762] = Rare({ -- reqiured 67030 review
    id = 193170,
    quest = 69856,
    note = L['spawns_hourly'],
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

map.nodes[80544222] = Rare({
    id = 188095,
    quest = 73966,
    note = L['hunter_of_the_deep_note'],
    rewards = {Achievement({id = 16677, criteria = 56083})}
}) -- Hunter of the Deep

map.nodes[80513869] = Rare({
    id = 188124,
    quest = 73967,
    note = L['in_cave'],
    rewards = {Achievement({id = 16677, criteria = 56084})},
    pois = {POI({79143656})} -- Entrance
}) -- Irontree

map.nodes[87556151] = Rare({
    id = 197009,
    quest = 73882,
    rewards = {
        Achievement({id = 16677, criteria = 56067}), --
        Item({item = 200859, note = L['trinket']}), -- Seasoned Hunter's Trophy
        Toy({item = 200249}), -- Mage's Chewed Wand
        DC.RenewedProtoDrake.SharkSnout
    }
}) -- Liskheszaera

map.nodes[32823817] = Rare({ -- review
    id = 195409,
    quest = 73968,
    rewards = {
        Achievement({id = 16677, criteria = 56094})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Makhra the Ashtouched

map.nodes[71694585] = Rare({
    id = 193212,
    quest = 74011,
    note = L['spawns_hourly'],
    rewards = {Achievement({id = 16677, criteria = 56073})}
}) -- Malsegan

map.nodes[63017996] = Rare({ -- reqiured 67030
    id = 193173,
    quest = 69857,
    note = L['spawns_hourly'],
    rewards = {
        Achievement({id = 16677, criteria = 56070}),
        Item({item = 200542, note = L['trinket']}) -- Breezy Companion
    }
}) -- Mikrin of the Raging Winds

map.nodes[58604940] = Rare({
    id = 187219,
    quest = nil,
    rewards = {Achievement({id = 16677, criteria = 56081})}
}) -- Nokhud Warmaster

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
    note = L['spawns_hourly'],
    rewards = {Achievement({id = 16677, criteria = 56074})}
}) -- Oshigol

map.nodes[59686802] = Rare({
    id = 191950,
    quest = 73971,
    note = L['in_small_cave'] .. ' ' .. L['porta_the_overgrown_note'],
    rewards = {
        Achievement({id = 16677, criteria = 56087})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {
        POI({
            59696879, -- Entrance
            50507017, 52137051, 54177150, 52746993 -- Enriched Soil Pile
        })
    }
}) -- Porta the Overgrown

local Quackers = Class('Quackers', Rare, {
    id = 192557,
    quest = 73972,
    rewards = {
        Achievement({id = 16677, criteria = 56091}),
        Achievement({id = 16446, criteria = 55396, note = L['pretty_neat_note']})
    },
    pois = {POI({70406355})} -- item=194740/duck-trap-kit
})

function Quackers.getters:note()
    local function status(id, count)
        if ns.PlayerHasItem(id, count) then
            return ns.status.Green(count .. 'x')
        else
            return ns.status.Red(count .. 'x')
        end
    end
    local note = L['quackers_duck_trap_kit']
    note = note .. '\n' .. status(189541, 1) .. ' {item:189541}' -- Primal Molten Alloy
    note = note .. '\n' .. status(193208, 3) .. ' {item:193208}' -- Resilient Leather
    note = note .. '\n' .. status(192095, 4) .. ' {item:192095}\n\n' -- Spool of Wilderthread
    return note .. L['quackers_spawn']
end

map.nodes[68207920] = Quackers() -- Quackers the Terrible

map.nodes[37005380] = Rare({
    id = 196010,
    quest = 74023,
    note = L['spawns_hourly'],
    rewards = {Achievement({id = 16677, criteria = 56069})}
}) -- Researcher Sneakwing

map.nodes[43405560] = Rare({
    id = 193227,
    quest = 74026,
    note = L['spawns_hourly'],
    rewards = {Achievement({id = 16677, criteria = 56071})}
}) -- Ronsak the Decimator

map.nodes[42804428] = Rare({ -- review
    id = 195223,
    quest = nil,
    rewards = {
        Achievement({id = 16677, criteria = 56093})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Rustlily

map.nodes[20444344] = Rare({
    id = 193215,
    quest = 74073,
    note = L['scaleseeker_mezeri_note'],
    rewards = {Achievement({id = 16677, criteria = 56079})},
    pois = {POI({16605120})} -- Dawnbell
}) -- Scaleseeker Mezeri

map.nodes[50117517] = Rare({
    id = 193136,
    quest = 73893,
    rewards = {Achievement({id = 16677, criteria = 56063})}
}) -- Scav Notail

map.nodes[61801283] = Rare({
    id = 193188,
    quest = 73894,
    rewards = {
        Achievement({id = 16677, criteria = 56065}),
        Transmog({item = 200875, slot = L['plate']}) -- Seeker's Bands
    }
}) -- Seeker Teryx

map.nodes[29964103] = Rare({
    id = 187559,
    quest = 74075,
    note = L['shade_of_grief_note'],
    rewards = {
        Achievement({id = 16677, criteria = 56080}),
        Item({item = 200158, note = L['ring']}), -- Eerie Spectral Ring
        DC.CliffsideWylderdrake.BranchedHorns
    }
}) -- Shade of Grief

map.nodes[21603960] = Rare({
    id = 193165,
    quest = 73896,
    rewards = {
        Achievement({id = 16677, criteria = 56062}),
        Transmog({item = 200234, slot = L['shield']}) -- Vrak's Embossed Aegis
    }
}) -- Sparkspitter Vrak

map.nodes[53627281] = Rare({ -- reqiured 67030 review
    id = 193123,
    quest = 74034,
    note = L['spawns_hourly'],
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

map.nodes[27605560] = Rare({
    id = 195204,
    quest = 73976,
    rewards = {Achievement({id = 16677, criteria = 56088})}
}) -- The Jolly Giant

map.nodes[83786215] = Rare({
    id = 192453,
    quest = nil,
    rewards = {Achievement({id = 16677, criteria = 56090})}
}) -- Vaniik the Stormtouched

map.nodes[84214784] = Rare({
    id = 192364,
    quest = 73979,
    note = L['windscale_the_stormborn_note'],
    rewards = {
        Achievement({id = 16677, criteria = 56089})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Windscale the Stormborn

map.nodes[58596822] = Rare({
    id = 192045,
    quest = 74088,
    rewards = {
        Achievement({id = 16677, criteria = 56076}),
        Transmog({item = 200308, slot = L['bow']}), -- Rellen's Legacy
        Transmog({item = 200441, slot = L['leather']}), -- Jhakan's Horned Cowl
        Item({item = 200141, note = L['ring']}) -- Wind Generating Band
    }
}) -- Windseeker Avash

map.nodes[30206260] = Rare({
    id = 193140,
    quest = 74091,
    note = L['zarizz_note'],
    rewards = {Achievement({id = 16677, criteria = 56078})}
}) -- Zarizz

map.nodes[31456387] = Rare({
    id = 193209,
    quest = 73901,
    rewards = {
        Achievement({id = 16677, criteria = 56066}),
        Achievement({id = 16446, criteria = 55395, note = L['pretty_neat_note']}),
        Mount({item = 198825, id = 1672}), -- Zenet Hatchling
        Transmog({item = 200131, slot = L['dagger']}), -- Reclaimed Survivalist's Dagger
        Transmog({item = 200314, slot = L['cloth']}), -- Skyspeaker's Envelope
        Transmog({item = 200306, slot = L['cloak']}), -- Tempest Shawl
        DC.RenewedProtoDrake.PurpleHair, --
        DC.WindborneVelocidrake.SweptHorns
    }
}) -- Zenet Avis

map.nodes[72232306] = Rare({
    id = 188451,
    quest = 73980,
    rewards = {Achievement({id = 16677, criteria = 56085})}
}) -- Zerimek

map.nodes[90434005] = Rare({
    id = 193128,
    quest = 74096,
    note = L['blightpaw_note'],
    rewards = {Achievement({id = 16679, criteria = 56136})}
}) -- Blightpaw the Depraved

map.nodes[80817770] = Rare({
    id = 197411,
    quest = 74057,
    label = L['large_lunker_sighting'],
    note = L['large_lunker_sighting_note'],
    rewards = {Achievement({id = 16678, criteria = 56130})}
}) -- Astray Splasher

-------------------------------------------------------------------------------

-- These rares/elites are not part of the adventurer achievement for the zone

map.nodes[59926696] = Rare({
    id = 193669,
    quest = 72815,
    rewards = {
        Item({item = 200161, note = L['trinket']}) -- Razorwind Talisman
    }
}) -- Prozela Galeshot

map.nodes[26366533] = Rare({
    id = 193153,
    quest = 72845,
    note = L['in_small_cave'],
    rewards = {
        Transmog({item = 200137, slot = L['dagger']}), -- Chitin Dreadbringer
        Transmog({item = 200193, slot = L['cloth']}) -- Manafrond Sandals
    }
}) -- Ripsaw the Stalker

map.nodes[44894924] = Rare({
    id = 192949,
    quest = 72847, -- 70783
    note = L['in_small_cave'],
    rewards = {
        Transmog({item = 200186, slot = L['mail']}) -- Amberquill Shroud
    }
}) -- Skaara

map.nodes[63034854] = Rare({
    id = 193133,
    quest = 72849, -- 69837
    note = L['in_waterfall_cave'],
    rewards = {
        Toy({item = 198409}) -- Personal Shell
    }
}) -- Sunscale Behemoth

map.nodes[22956670] = Rare({
    id = 193163,
    quest = 72851, -- 66378
    rewards = {
        Transmog({item = 200212, slot = L['mail']}), -- Sand-Encrusted Greaves
        DC.HighlandDrake.ManedHead
    }
}) -- Territorial Coastling

map.nodes[26073412] = Rare({
    id = 191354,
    quest = 72852, -- 66970
    note = L['in_cave'],
    rewards = {
        Transmog({item = 198429, slot = L['staff']}) -- Typhoon Bringer
    },
    pois = {POI({23573442})}
}) -- Ty'foon the Ascended

map.nodes[43105078] = Rare({
    id = 191354,
    quest = 74095,
    note = L['in_cave'],
    rewards = {
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({43724823})}
}) -- Web-Queen Ashkaz

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
        ns.requirement.Quest(70392, '{item:198843}') -- Emerald Gardens Explorer's Notes
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
        ns.requirement.Quest(67046, '{item:194540}') -- Nokhud Armorer's Notes
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

map.nodes[56007870] = ns.node.ElementalChest({
    quest = 71033,
    label = L['chest_of_the_flood'],
    rewards = {
        Item({item = 192055}), -- Dragon Isles Artifact
        Item({item = 200093}), -- Centaur Hunting Trophy
        Item({item = 190454}), -- Primal Chaos
        Item({item = 198542, note = L['trinket']}), -- Shikaari Huntress' Arrowhead
        Item({item = 198539, note = L['trinket']}), -- Breath of the Plains
        Transmog({item = 201443, slot = L['shield']}), -- Primal Revenant's Icewall
        Transmog({item = 201442, slot = L['1h_sword']}) -- Primal Revenant's Frostblade
    }
}) -- Chest of the Flood

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
    quest = 70353,
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

map.nodes[79238374] = PT.Alchemy({
    id = 198710,
    quest = 70305,
    note = L['pt_alch_canteen_of_suspicious_water_note']
}) -- Canteen Of Suspicious Water

map.nodes[81103790] = PT.Blacksmithing({
    id = 201004,
    quest = 70313,
    note = L['pt_smith_ancient_spear_shards_note'],
    pois = {POI({79403650})}
}) -- Ancient Spear Shards

map.nodes[85702520] = PT.Inscription({
    id = 198703,
    quest = 70307,
    note = L['pt_script_sign_language_reference_sheet_note']
}) -- Sign Language Reference Sheet

map.nodes[86405370] = PT.Leatherworking({
    id = 198696,
    quest = 70300,
    note = L['pt_leath_wind_blessed_hide_note']
}) -- Wind-Blessed Hide

-------------------------------------------------------------------------------

map.nodes[82455067] = PM.Leatherworking({
    id = 194842,
    quest = 70256,
    note = L['pm_leath_erden'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2025, note = '5'}) -- Dragon Isles Leatherworking Knowledge
    }
}) -- Erden

map.nodes[58375000] = PM.Herbalism({
    id = 194839,
    quest = 70253,
    note = L['pm_herb_hua_greenpaw'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2034, note = '10'}) -- Dragon Isles Herbalism Knowledge
    }
}) -- Hua Greenpaw

map.nodes[62441868] = PM.Enchanting({
    id = 194837,
    quest = 70251,
    note = L['pm_ench_shalasar_glimmerdusk'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2030, note = '5'}) -- Dragon Isles Enchanting Knowledge
    }
}) -- Shalasar Glimmerdusk

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
------------------ WYRMHOLE GENERATOR - SIGNAL TRANSMITTER --------------------
-------------------------------------------------------------------------------

map.nodes[67688495] = SignalTransmitter({quest = 70578}) -- Mirror of the Sky
map.nodes[28023567] = SignalTransmitter({quest = 70576}) -- Nokhudon Hold
map.nodes[56872889] = SignalTransmitter({quest = 70577}) -- Maarukai

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

map.nodes[22753027] = Disturbeddirt()
map.nodes[25976132] = Disturbeddirt({note = L['in_small_cave']})
map.nodes[29777163] = Disturbeddirt()
map.nodes[29777363] = Disturbeddirt()
map.nodes[36553269] = Disturbeddirt()
map.nodes[38825564] = Disturbeddirt()
map.nodes[39565456] = Disturbeddirt()
map.nodes[88364505] = Disturbeddirt()
map.nodes[41103789] = Disturbeddirt()
map.nodes[42335555] = Disturbeddirt()
map.nodes[42934942] = Disturbeddirt()
map.nodes[62787415] = Disturbeddirt()
map.nodes[43316632] = Disturbeddirt()
map.nodes[46345356] = Disturbeddirt()
map.nodes[48867036] = Disturbeddirt()
map.nodes[49716952] = Disturbeddirt()
map.nodes[50152501] = Disturbeddirt()
map.nodes[51445485] = Disturbeddirt()
map.nodes[51936274] = Disturbeddirt()
map.nodes[54115705] = Disturbeddirt()
map.nodes[55197076] = Disturbeddirt()
map.nodes[87444467] = Disturbeddirt()
map.nodes[55944340] = Disturbeddirt()
map.nodes[62171310] = Disturbeddirt()
map.nodes[63251396] = Disturbeddirt()
map.nodes[65868145] = Disturbeddirt()
map.nodes[66451981] = Disturbeddirt()
map.nodes[69087885] = Disturbeddirt()
map.nodes[71706413] = Disturbeddirt()
map.nodes[75003584] = Disturbeddirt()
map.nodes[76485475] = Disturbeddirt()
map.nodes[78534035] = Disturbeddirt()
map.nodes[78782268] = Disturbeddirt()
map.nodes[78943707] = Disturbeddirt({note = L['in_small_cave']})
map.nodes[79697606] = Disturbeddirt()
map.nodes[80133864] = Disturbeddirt({
    note = L['in_cave'],
    pois = {POI({79403650})}
}) -- Bugged under a rock
map.nodes[81403827] = Disturbeddirt()
map.nodes[82593486] = Disturbeddirt()
map.nodes[83243606] = Disturbeddirt()
map.nodes[82543651] = Disturbeddirt()
map.nodes[83731265] = Disturbeddirt()
map.nodes[85833271] = Disturbeddirt()
map.nodes[86683243] = Disturbeddirt()
map.nodes[86725931] = Disturbeddirt()
map.nodes[78217937] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[21875784] = Scoutpack()
map.nodes[23944019] = Scoutpack()
map.nodes[24745680] = Scoutpack()
map.nodes[25205876] = Scoutpack()
map.nodes[32043887] = Scoutpack()
map.nodes[35925854] = Scoutpack()
map.nodes[42883769] = Scoutpack()
map.nodes[43335647] = Scoutpack()
map.nodes[43486213] = Scoutpack()
map.nodes[44856758] = Scoutpack()
map.nodes[50382904] = Scoutpack()
map.nodes[50856597] = Scoutpack()
map.nodes[51647211] = Scoutpack()
map.nodes[51797550] = Scoutpack()
map.nodes[52403042] = Scoutpack()
map.nodes[56942485] = Scoutpack()
map.nodes[60567702] = Scoutpack()
map.nodes[61301817] = Scoutpack()
map.nodes[61781881] = Scoutpack()
map.nodes[63423235] = Scoutpack()
map.nodes[64028081] = Scoutpack()
map.nodes[65021064] = Scoutpack()
map.nodes[66798258] = Scoutpack()
map.nodes[73618656] = Scoutpack()
map.nodes[78736935] = Scoutpack()
map.nodes[84685647] = Scoutpack()
map.nodes[86084606] = Scoutpack()
map.nodes[91393390] = Scoutpack()

-------------------------------------------------------------------------------
------------------------------ Magic-Bound Chest ------------------------------
-------------------------------------------------------------------------------

map.nodes[31457162] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[38905590] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[39306790] = MagicBoundChest()
map.nodes[53805720] = MagicBoundChest({
    note = L['in_small_cave'],
    pois = {POI({53315684})}
})
map.nodes[55003120] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[55405030] = MagicBoundChest({
    note = L['in_cave'],
    pois = {POI({57575115})}
})
map.nodes[61008020] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[80908080] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[82603290] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[85106640] = MagicBoundChest({
    requires = {
        ns.requirement.Reputation(2507, 16, true),
        ns.requirement.Profession(186)
    },
    note = L['in_small_cave']
})

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
    requires = ns.requirement.Item(199049), -- Fire-Blessed Greatsword
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
    requires = ns.requirement.Item(191470, 5, 2), -- Writhebark (Tier 2)
    rewards = {Achievement({id = 16423, criteria = 55311})},
    pois = {
        POI({85702073}), -- Essence of Awakening
        Path({32967236, 32977116, 32606972, 32356934, 31476857, 31126843})
    }
}) -- The Eternal Kurgans

map.nodes[84692429] = Ancestor({
    id = 197050,
    requires = ns.requirement.Item(199934, 1, 1), -- Enchant Boots - Plainsrunner's Breeze (Tier 1)
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

map.nodes[63743051] = Dragonrace({
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

map.nodes[86263583] = Dragonrace({
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

map.nodes[80887221] = Dragonrace({
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

map.nodes[25715508] = Dragonrace({
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

map.nodes[59933555] = Dragonrace({
    label = '{quest:66921}',
    normal = {2069, 28, 25},
    rewards = {
        Achievement({id = 15918, criteria = 5, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 5, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 5, oneline = true}) -- normal gold
    }
}) -- Maruukai Dash

map.nodes[47487064] = Dragonrace({
    label = '{quest:66933}',
    normal = {2070, 29, 26},
    rewards = {
        Achievement({id = 15918, criteria = 6, oneline = true}), -- normal bronze
        Achievement({id = 15919, criteria = 6, oneline = true}), -- normal silver
        Achievement({id = 15920, criteria = 6, oneline = true}) -- normal gold
    }
}) -- Mirror of Sky Dash

map.nodes[43746678] = Dragonrace({
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
--------------------- TO ALL THE SQUIRRELS HIDDEN TIL NOW ---------------------
-------------------------------------------------------------------------------

map.nodes[23486179] = Squirrel({
    id = 186306,
    rewards = {Achievement({id = 16729, criteria = 4})}
}) -- Frilled Hatchling

map.nodes[51075165] = Squirrel({
    id = 192948,
    rewards = {Achievement({id = 16729, criteria = 5})}
}) -- Thicket Glider

map.nodes[50195179] = Squirrel({
    id = 192942,
    rewards = {Achievement({id = 16729, criteria = 6})}
}) -- Thunderspine Calf

-------------------------------------------------------------------------------
--------------------------- THE DISGRUNTLED HUNTER ----------------------------
-------------------------------------------------------------------------------

local HemetNesingwaryJr = Class('HemetNesingwaryJr', Collectible, {
    id = 194590,
    icon = 236444,
    sublabel = L['hnj_sublabel'],
    group = ns.groups.HEMET_NESINGWARY_JR
}) -- Hemet Nesingwary Jr.

map.nodes[82461392] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55692})}
}) -- Northern Ohn'ahran Plains Hunt

map.nodes[62005400] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55693})}
}) -- Western Ohna'ahran Plains Hunt

map.nodes[82874782] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55694})}
}) -- Eastern Ohna'ahran Plains Hunt

-------------------------------------------------------------------------------
----------------------------- THAT'S PRETTY NEAT! -----------------------------
-------------------------------------------------------------------------------

map.nodes[58602066] = PrettyNeat({
    id = 193356,
    rewards = {Achievement({id = 16446, criteria = 55384})}
}) -- Avis Gryphonheart

map.nodes[74724069] = PrettyNeat({
    id = 190960,
    rewards = {Achievement({id = 16446, criteria = 55401})}
}) -- Feasting Buzzard

map.nodes[59575538] = PrettyNeat({
    id = 187496,
    rewards = {Achievement({id = 16446, criteria = 55402})}
}) -- Glade Ohuna

map.nodes[58632082] = PrettyNeat({
    id = 193354,
    rewards = {Achievement({id = 16446, criteria = 55383})}
}) -- Halia Cloudfeather

map.nodes[60407140] = PrettyNeat({
    id = 195895,
    rewards = {Achievement({id = 16446, criteria = 55400})},
    pois = {
        Path({
            60607560, 59407520, 58407480, 57807360, 58607120, 60407140,
            61807040, 63006980, 65206900, 65206640, 65606220, 65806080,
            67605840, 67805620, 67805400, 68605160
        })
    }
}) -- Nergazurai

map.nodes[58672073] = PrettyNeat({
    id = 193357,
    rewards = {Achievement({id = 16446, criteria = 55385})}
}) -- Palla of the Wing

-------------------------------------------------------------------------------
------------------------------ A LEGENDARY ALBUM ------------------------------
-------------------------------------------------------------------------------

map.nodes[73358131] = LegendaryCharacter({
    id = 38294,
    icon = 1109168,
    rewards = {Achievement({id = 16570, criteria = 55772})}
}) -- Elder Clearwater

map.nodes[48124748] = LegendaryCharacter({
    id = 63721,
    rewards = {Achievement({id = 16570, criteria = 55774})}
}) -- Nat Pagle

-------------------------------------------------------------------------------
-------------------------- ONE OF EVERYTHING, PLEASE --------------------------
-------------------------------------------------------------------------------

map.nodes[28006060] = Collectible({
    label = '{item:201089}',
    icon = 644375,
    note = L['craft_creche_crowler_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55940})}
}) -- Craft Creche Crowler

-------------------------------------------------------------------------------
----------------------------- DRAGON ISLES SAFARI -----------------------------
-------------------------------------------------------------------------------

map.nodes[54005020] = Safari({
    id = 189153,
    rewards = {Achievement({id = 16519, criteria = 55646}), Pet({id = 3313})},
    pois = {
        POI({
            48604940, 50005180, 50604720, 51804820, 54005020, 55404900,
            56205100, 56205660, 57405360, 57605360
        })
    }
}) -- Grassland Stomper

map.nodes[26604460] = Safari({
    id = 189131,
    rewards = {Achievement({id = 16519, criteria = 55649}), Pet({id = 3300})},
    pois = {
        POI({
            26604460, 30405820, 30605820, 32005580, 34005300, 34005900,
            35805340, 38205460, 39406660, 39606660, 40205460, 42204160,
            42604780, 42806560, 45005380, 46406600, 49006860, 50407180,
            50607180, 53402640, 54406640, 54606860, 54806840, 57803660,
            60801980, 63202120, 67403440, 67802940, 67802960, 69207920,
            70003780, 71205040, 71205060, 72004940, 72207640, 74407840,
            74407860, 75002620, 76803620, 76803700, 78403800, 78603800,
            79807200, 82207380, 82603380, 82607460, 83007440, 83403740,
            83607460, 85203180, 86203240
        })
    }
}) -- Ironbeak Duck

map.nodes[55407440] = Safari({
    id = 189122,
    rewards = {Achievement({id = 16519, criteria = 55652}), Pet({id = 3296})},
    pois = {
        POI({
            22206380, 23606800, 24806600, 37605540, 37605560, 37806580,
            42206120, 44206840, 44206860, 47404900, 48406600, 50407540,
            51004320, 51606640, 51806660, 52007100, 53807000, 54207540,
            54807260, 54807780, 55407440, 56007860, 69003900, 70207940,
            71408320, 71806920, 72003540, 74405580, 74605580, 78607940
        })
    }
}) -- Palamanther

map.nodes[76005560] = Safari({
    id = 189103,
    rewards = {Achievement({id = 16519, criteria = 55657}), Pet({id = 3281})},
    pois = {
        POI({
            42005520, 76005560, 77005200, 78005380, 78804040, 78804060,
            79804260, 86005720
        })
    }
}) -- Scruffy Ottuk

map.nodes[73803520] = Safari({
    id = 192254,
    rewards = {Achievement({id = 16519, criteria = 55660}), Pet({id = 3353})},
    pois = {
        POI({
            21806080, 22805680, 25805520, 44003320, 52002600, 54402820,
            56004640, 57404540, 57604540, 59404840, 61204820, 62604720,
            66003700, 66403540, 66404840, 66603540, 66803400, 67603540,
            68204340, 68403160, 68603160, 69804220, 70403140, 70403160,
            72202800, 73803520, 74005960, 75203720, 75602340, 75602360,
            80806920, 81007100, 82401500, 82601500, 82602740, 82802760,
            82803340, 82803740, 83007240, 83007260, 83201960, 83203600,
            83403480, 84403440, 85403120
        })
    }
}) -- Stoneshell

map.nodes[47606100] = Safari({
    id = 189104,
    rewards = {Achievement({id = 16519, criteria = 55661}), Pet({id = 3282})},
    pois = {
        POI({
            29405840, 31205220, 36405260, 39205380, 40204220, 41403800,
            43205900, 45606840, 47406120, 47606100, 49806900, 51606520,
            53007540, 53007560, 56408040, 61805420, 73006240, 73808240,
            73808280, 75207360, 75407340, 75807240, 78207320, 78607220,
            81607160, 81807140, 83807780, 85204480, 86204640, 86204660
        })
    }
}) -- Swoglet

map.nodes[71007200] = Safari({
    id = 189658,
    rewards = {Achievement({id = 16519, criteria = 55662}), Pet({id = 3328})},
    pois = {
        POI({
            71007200, 71607360, 73007600, 73208580, 79004840, 80005020,
            81007820, 81404580
        })
    }
}) -- Tiny Timbertooth

map.nodes[67507260] = Safari({
    id = 189097,
    rewards = {Achievement({id = 16519, criteria = 55663}), Pet({id = 3276})},
    pois = {
        POI({
            28004940, 28004960, 29205400, 29206820, 29606660, 30207480,
            30407380, 30607440, 30607460, 31207680, 31806900, 32007600,
            32203340, 32206280, 32403360, 33805000, 34604460, 34605660,
            35405820, 35803200, 35804180, 36405060, 36406940, 36603820,
            36606920, 37604600, 37803980, 38205000, 38405480, 39603640,
            40805140, 41404340, 43003700, 43403560, 44203680, 44803840,
            45804540, 45804560, 47003600, 48404360, 49003060, 50402560,
            50403120, 50802880, 51203100, 51404000, 53203580, 55403940,
            55604220, 56203820, 56604040, 57203900, 57602340, 57602360,
            57804300, 58603820, 59202080, 59602620, 60004020, 60802340,
            61403040, 61403060, 61603040, 61603840, 61604540, 61801540,
            61801580, 63401080, 63601100, 63603240, 63603260, 64202820,
            64203660, 64404500, 64604500, 64801580, 64804400, 65001920,
            65202020, 65403880, 65403960, 65404280, 65602020, 65603880,
            65603960, 67507260, 66007020, 66007260, 66204300, 70405860,
            79403100, 79603120, 81806000, 82202300, 82606020, 82806160,
            83805760, 84403960, 84404100, 85006040, 85406180, 85606200,
            86001680, 86803520, 87203640, 87203680, 88001360
        })
    }
}) -- Treeflitter

map.nodes[76402740] = Safari({
    id = 189110,
    rewards = {Achievement({id = 16519, criteria = 55664}), Pet({id = 3288})},
    pois = {
        POI({
            54606120, 54806300, 55206520, 56206060, 57006260, 71805340,
            71805360, 72604420, 73804840, 74605080, 75203320, 76401940,
            76402020, 76402740, 76402760, 76602040, 76602720, 76602760,
            77003240, 77801900, 78803520, 79802700, 80002120
        })
    }
}) -- Trunkalumpf

map.nodes[64003480] = Safari({
    id = 189157,
    rewards = {Achievement({id = 16519, criteria = 55668}), Pet({id = 3322})},
    pois = {
        POI({
            60801480, 61005220, 61402380, 61802380, 62203520, 62802560,
            64003480, 64005800, 64401280, 64601280, 64801200, 65001820
        })
    }
}) -- Woodbiter Piculet

-------------------------------------------------------------------------------
--------------------- ELEMENTAL STORMS: ONH'AHRAN PLAINS ----------------------
-------------------------------------------------------------------------------

map.nodes[34153854] = ElementalStorm({
    label = format('%s: %s', L['elemental_storm'],
        L['elemental_storm_nokhudon_hold']),
    mapID = map.id,
    areaPOIs = {7221, 7222, 7223, 7224}
}) -- Elemental Storm: Nokhudon Hold

map.nodes[54367534] = ElementalStorm({
    label = format('%s: %s', L['elemental_storm'],
        L['elemental_storm_ohniri_springs']),
    mapID = map.id,
    areaPOIs = {7225, 7226, 7227, 7228}
}) -- Elemental Storm: Ohn'iri Springs

-------------------------------------------------------------------------------
--------------------------- KNEW YOU NOKHUD DO IT! ----------------------------
-------------------------------------------------------------------------------

map.nodes[34603468] = Collectible({
    label = '{npc:197884}',
    icon = 1103068,
    note = L['knew_you_nokhud_do_it_note'],
    group = ns.groups.NOKHUD_DO_IT,
    rewards = {
        Achievement({id = 16583}) -- Knew You Nokhud Do It!
    },
    pois = {
        Path({Circle({origin = 34943880, radius = 2})}), -- Nokhudon Hold
        Path({
            34693453, 35263463, 35783477, 36133487, 36373508, 36973482,
            37553460, 37813427, 37773397, 37353335, 37203289, 36813235,
            36513218, 36153214, 35753226, 35343241, 35103236, 34973277,
            34963336, 34833385, 34733415, 34693453
        }) -- Training Course Path
    }
}) -- Training Master Turasa

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

-------------------------- MOUNT: LIZI, THUNDERSPINE --------------------------

local Lizi = Class('Lizi', Collectible, {
    id = 190014,
    icon = 4008180,
    quest = {71196, 71197, 71198, 71199, 71195}, -- Dailys
    questCount = true,
    requires = {
        ns.requirement.Quest(66676), -- Sneaking In
        ns.requirement.Reputation(2503, 9, true) -- Maruuk Centaur
    },
    rewards = {Mount({item = 192799, id = 1639})}, -- Lizi's Reins
    pois = {
        POI({57087764, 56727631, 57667231}) -- Day 3, Day 4, Day 5
    }
}) -- Initiate Radiya

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

map.nodes[56207710] = Lizi() -- day 1 and 2

----------------------- MOUNT: DIVINE KISS OF OHN'AHRA ------------------------

local Ohnahra = Class('Ohnahra', Collectible, {
    id = 194796,
    icon = 4094306,
    requires = {
        ns.requirement.Quest(71209), -- Beast of the Plains
        ns.requirement.Reputation(2503, 25, true) -- Maruuk Centaur
    },
    rewards = {
        Mount({item = 198821, id = 1545}), -- Divine Kiss of Ohn'ahra
        Achievement({id = 16446, criteria = 55386, note = L['pretty_neat_note']})
    },
    pois = {
        POI({56207710, 56457327, 60403772}) -- Initiate Radiya, Godoloto, Quatermaster Huseng
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

----------------------------- MISCELLANEOUS NPCs ------------------------------

map.nodes[82327320] = NPC({
    id = 191608,
    icon = 4638725,
    note = L['the_great_swog_note']
}) -- The Great Swog

map.nodes[51803300] =
    NPC({id = 193110, icon = 4643982, note = L['khadin_note']}) -- Khadin

map.nodes[64014104] = NPC({
    id = 195454,
    icon = 2101975,
    note = L['hunt_instructor_basku_note']
}) -- Hunt Instructor Basku (Maruuk Centuar Reputation)

map.nodes[41606220] = Collectible({
    id = 192818,
    icon = 4659336,
    note = L['elder_yusa_note'],
    rewards = {
        Item({item = 197793}) -- Yusa's Hearty Stew
    }
}) -- Elder Yusa

map.nodes[47037119] = Collectible({
    id = 187796,
    icon = 133796,
    note = L['initiate_kittileg_note'],
    rewards = {
        Toy({item = 198039}) -- Rock of Appreciation
    },
    pois = {
        POI({47037037}) -- Entrance
    }
}) -- Initiate Kittileg

-- STOP: DO NOT ADD NEW NODES HERE UNLESS THEY BELONG IN MISCELLANEOUS
