-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local Class = ns.Class
local L = ns.locale
local Map = ns.Map

local Collectible = ns.node.Collectible
local Node = ns.node.Node
local NPC = ns.node.NPC
local PetBattle = ns.node.PetBattle
local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Dragonrace = ns.node.Dragonrace
local ElementalStorm = ns.node.ElementalStorm
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
local SignalTransmitter = ns.node.SignalTransmitter
local Squirrel = ns.node.Squirrel
local TuskarrTacklebox = ns.node.TuskarrTacklebox

local Achievement = ns.reward.Achievement
local Currency = ns.reward.Currency
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

local DC = ns.DRAGON_CUSTOMIZATIONS

-------------------------------------------------------------------------------

local map = Map({id = 2024, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[53013563] = Rare({
    id = 194270,
    quest = 73866,
    rewards = {
        Achievement({id = 16678, criteria = 56099})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Arcane Devourer

map.nodes[55823132] = Rare({
    id = 194210,
    quest = 73867,
    rewards = {
        Achievement({id = 16678, criteria = 56105})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {
        Path({
            49173845, 49533814, 50533616, 51263539, 51733489, 51983461,
            52423353, 53223285, 55823132, 56433052, 56963022, 57373056,
            57943094, 58233093, 59133081, 59423098, 61263135
        })
    }
}) -- Azure Pathfinder

map.nodes[73032680] = Rare({
    id = 193116,
    quest = 73868,
    rewards = {
        Achievement({id = 16678, criteria = 56106}),
        Transmog({item = 200254, slot = L['mail']}) -- Totemic Cinch
    }
}) -- Beogoka

map.nodes[13584855] = Rare({
    id = 197557,
    quest = 74097,
    note = L['bisquis_note'],
    rewards = {
        Achievement({id = 16678, criteria = 55381}), --
        Achievement({id = 16444}) -- Leftovers' Revenge
    }
}) -- Bisquius

map.nodes[13432270] = Rare({
    id = 193178,
    quest = 74058,
    note = L['in_small_cave'] .. ' ' .. L['blightfur_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56122}),
        DC.RenewedProtoDrake.FinnedTail
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Blightfur

map.nodes[14053096] = RareElite({
    id = 197353,
    quest = 73985,
    fgroup = 'brackenhide',
    note = L['brackenhide_rare_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56126}),
        Transmog({item = 200131, slot = L['dagger']}), -- Reclaimed Survivalist's Dagger
        Transmog({item = 200232, slot = L['warglaive']}), -- Raptor Talonglaive
        Transmog({item = 200195, slot = L['plate']}), -- Thunderscale Legguards
        Transmog({item = 200442, slot = L['leather']}), -- Basilisk Hide Jerkin
        Transmog({item = 200193, slot = L['cloth']}), -- Manafrond Sandals
        Item({item = 200859, note = L['trinket']}), -- Seasoned Hunter's Trophy
        Item({item = 200563, note = L['trinket']}) -- Primal Ritual Shell
    }
}) -- Blisterhide

map.nodes[16622798] = Rare({
    id = 193259,
    quest = 73870,
    rewards = {
        Achievement({id = 16678, criteria = 56108}),
        Achievement({id = 16446, criteria = 55397, note = L['pretty_neat_note']}),
        Transmog({item = 200131, slot = L['dagger']}), -- Reclaimed Survivalist's Dagger
        DC.WindborneVelocidrake.FinnedEars
    }
}) -- Blue Terror

map.nodes[08944852] = Rare({
    id = 194392,
    quest = 73871,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16678, criteria = 56103}) --
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({08584883})}
}) -- Brackle

map.nodes[27214490] = Rare({
    id = 193157,
    quest = 73873,
    rewards = {
        Achievement({id = 16678, criteria = 56098}),
        Transmog({item = 200302, slot = L['1h_sword']}), -- Magmaforged Scimitar
        DC.CliffsideWylderdrake.HornedNose
    },
    pois = {
        Path({
            26834541, 26554557, 26314548, 25854568, 25844609, 26214609,
            26644613, 26834619, 26834640, 27044644, 27144627, 27374654,
            27604656, 27724633, 27614620, 27654565, 27414532, 27214490, 26834541
        })
    }
}) -- Dragonhunter Gorund

map.nodes[50043631] = Rare({ -- review
    id = 193691,
    quest = 72254, -- wrong id? 72730, 74064?
    note = L['fisherman_tinnak_note'],
    requires = {
        ns.requirement.Reputation(2511, 7, true) -- Iskaara Tuskarr
    },
    rewards = {
        Achievement({id = 16678, criteria = 56115}),
        Transmog({item = 199026, slot = L['1h_sword']}), -- Fire-Blessed Blade
        Transmog({item = 200310, slot = L['cloak']}), -- Stole of the Iron Phantom
        DC.RenewedProtoDrake.WhiteHorns, DC.CliffsideWylderdrake.HornedJaw,
        Item({item = 198070}) -- Tattered Seavine
    },
    pois = {POI({50523672, 49973821, 49223842})}
}) -- Fisherman Tinnak

map.nodes[64992995] = Rare({
    id = 193698,
    quest = 73876, -- 69985?
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16678, criteria = 56104})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Frigidpelt Den Mother

map.nodes[58264391] = Rare({
    id = 191356,
    quest = 73877,
    note = L['frostpaw_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56101})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({58664339})}
}) -- Frostpaw

map.nodes[14083747] = RareElite({
    id = 197354,
    quest = 73996,
    fgroup = 'brackenhide',
    note = L['brackenhide_rare_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56127}),
        Transmog({item = 200259, slot = L['shield']}), -- Forest Dweller's Shield
        Transmog({item = 200267, slot = L['plate']}), -- Reinforced Garden Tenders
        DC.RenewedProtoDrake.SnubSnout, DC.HighlandDrake.TanHorns
    }
}) -- Gnarls

map.nodes[32682911] = RareElite({ -- review -- required 67030
    id = 193251,
    quest = 74001,
    note = L['spawns_periodically'],
    rewards = {
        Achievement({id = 16678, criteria = 56111})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Gruffy

map.nodes[19234362] = Rare({ -- required 67030
    id = 193269,
    quest = 74002,
    note = L['spawns_periodically'],
    rewards = {
        Achievement({id = 16678, criteria = 56112}),
        Transmog({item = 200206, slot = L['bow']}) -- Behemoth Slayer Greatbow
    }
}) -- Grumbletrunk

map.nodes[16213364] = RareElite({
    id = 197356,
    quest = 74004,
    fgroup = 'brackenhide',
    note = L['brackenhide_rare_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56128}),
        Transmog({item = 200266, slot = L['crossbow']}), -- Gnollish Chewtoy Launcher
        Transmog({item = 200283, slot = L['leather']}), -- Gnoll-Gnawed Breeches
        Toy({item = 200178}), -- Infected Ichor
        DC.CliffsideWylderdrake.Ears, DC.CliffsideWylderdrake.DualHornedChin
    }
}) -- High Shaman Rotknuckle

map.nodes[36243573] = Rare({
    id = 190244,
    quest = 73883,
    rewards = {
        Achievement({id = 16678, criteria = 56109}), --
        DC.HighlandDrake.ClubTail, DC.WindborneVelocidrake.GrayHorns
    },
    pois = {Path({35873621, 36243573, 36543508, 36863479})}
}) -- Mahg the Trampler

map.nodes[40514797] = Rare({
    id = 198004,
    quest = 73884,
    rewards = {
        Achievement({id = 16678, criteria = 56100}),
        Transmog({item = 200283, slot = L['leather']}), -- Gnoll-Gnawed Breeches
        DC.HighlandDrake.SpikedClubTail
    }
}) -- Mange the Outcast

map.nodes[58095471] = Rare({ -- review
    id = 193201,
    quest = 73885, -- 73886 both?
    rewards = {
        Achievement({id = 16678, criteria = 56102}),
        Transmog({item = 200195, slot = L['plate']}), -- Thunderscale Legguards
        Item({item = 200445, note = L['neck']}) -- Lucky Hunting Charm
    }
}) -- Mucka the Raker

map.nodes[20584943] = Rare({
    id = 193225,
    quest = 73887,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16678, criteria = 56107}), --
        Toy({item = 200160}) -- Notfar's Favorite Food
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({34023076, 34933000})} -- Entrance
}) -- Notfar the Unbearable

map.nodes[58813260] = Rare({
    id = 197371,
    quest = {73891, 74080},
    label = L['large_lunker_sighting'],
    note = L['large_lunker_sighting_note'],
    rewards = {
        Achievement({
            id = 16678,
            criteria = {
                {id = 56129, quest = 73891}, -- Ravenous Tundra Bear
                {id = 56116, quest = 74080} -- Snufflegust
            }
        })
    }
}) -- Lunker Rares

-- map.nodes[] = Rare({
--     id = 193693,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56113}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Rusthide

map.nodes[26494939] = Rare({ -- review -- required 67030
    id = 193149,
    quest = 74030,
    note = L['spawns_periodically'],
    rewards = {
        Achievement({id = 16678, criteria = 56110}),
        Transmog({item = 200279, slot = L['plate']}) -- Competitive Throwing Gauntlets
    }
}) -- Skag the Thrower

map.nodes[10863229] = RareElite({
    id = 197344,
    quest = 74032,
    fgroup = 'brackenhide',
    note = L['brackenhide_rare_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56125}),
        Transmog({item = 200266, slot = L['crossbow']}), -- Gnollish Chewtoy Launcher
        Transmog({item = 200283, slot = L['leather']}), -- Gnoll-Gnawed Breeches
        DC.HighlandDrake.SpikedClubTail, DC.CliffsideWylderdrake.Ears
    }
}) -- Snarglebone

map.nodes[55033405] = RareElite({
    id = 193238,
    quest = 74082, -- 69879 ?
    note = L['spellwrought_snowman_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56124}),
        Transmog({item = 200187, slot = L['staff']}), -- Rod of Glacial Force
        Transmog({item = 200211, slot = L['cloth']}) -- Snowman's Icy Gaze
    },
    pois = {
        POI({
            53873559, 54003628, 54073717, 53393655, 52923709, 52203733,
            51673681, 51953564, 54163466, 53483474
        })
    }
}) -- Spellwrought Snowman

-- map.nodes[] = Rare({
--     id = 193167,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56121}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Swagraal the Swollen

map.nodes[70222532] = Rare({
    id = 193196,
    quest = 74087,
    note = L['trilvarus_loreweaver_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56114})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({70432369})}
}) -- Trilvarus Loreweaver

map.nodes[59405520] = Rare({
    id = 193632,
    quest = 73900,
    rewards = {
        Achievement({id = 16678, criteria = 56097}),
        Transmog({item = 200195, slot = L['plate']}), -- Thunderscale Legguards
        Transmog({item = 200193, slot = L['cloth']}), -- Manafrond Sandals
        Item({item = 200859, note = L['trinket']}) -- Seasoned Hunter's Trophy
    }
}) -- Wilrive

-------------------------------------------------------------------------------

-- These rares/elites are not part of the adventurer achievement for the zone

map.nodes[28564743] = Rare({
    id = 195353,
    quest = nil,
    note = L['breezebiter_note'],
    rewards = {
        Mount({item = 201440, id = 1553}) -- Liberated Slyvern
    },
    pois = {
        Path({
            28564743, 28304800, 27944822, 26974854, 26364841, 26074796,
            25824706, 25764642, 26134540, 26374491, 27124437, 27554428,
            28164470, 28614643, 28564743
        }), POI({29804622}) -- Cave
    }
}) -- Breezebiter

map.nodes[23503317] = Rare({
    id = 186962,
    quest = 72836,
    rewards = {
        Transmog({item = 200135, slot = L['2h_sword']}), -- Corroded Greatsword
        Transmog({item = 200245, slot = L['2h_mace']}), -- Leviathan Lure
        Transmog({item = 200187, slot = L['staff']}), -- Rod of Glacial Force
        DC.HighlandDrake.FinnedBack, DC.CliffsideWylderdrake.FinnedCheek
    }
}) -- Cascade

map.nodes[38155901] = Rare({
    id = 193214,
    quest = 72840, -- 69864
    note = L['in_cave'],
    rewards = {
        Item({item = 200210, note = L['neck']}) -- Amnesia
    },
    pois = {POI({38625988})}
}) -- Forgotten Creation

map.nodes[70143327] = Rare({
    id = 193288,
    quest = 72848, -- 69895
    rewards = {
        Item({item = 198048}), -- Titan Training Matrix I
        Item({item = 200868, note = L['trinket']}) -- Intefrated Primal Fire
    }
}) -- Summoned Destroyer

map.nodes[17254144] = Rare({
    id = 193223,
    quest = 72853, -- 69872
    rewards = {
        Item({item = 201728}), -- Vakril's Strongbox
        DC.CliffsideWylderdrake.FinnedCheek
    }
}) -- Vakril

map.nodes[36723247] = Rare({
    id = 192749,
    quest = 72846, -- 67173
    note = L['sharpfang_note'],
    rewards = {
        Transmog({item = 200283, slot = L['leather']}), -- Gnoll-Gnawed Breeches
        Transmog({item = 200266, slot = L['crossbow']}), -- Gnollish Chewtoy Launcher
        DC.HighlandDrake.SpikedClubTail, DC.CliffsideWylderdrake.Ears,
        Item({item = 198048}) -- Titan Training Matrix I
    }
}) -- Sharpfang

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[45125940] = Treasure({
    quest = 70603,
    note = L['forgotten_jewel_box_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Quest(70534, '{item:199065}') -- Sorrowful Letter
    },
    rewards = {
        Achievement({id = 16300, criteria = 54804}), --
        Toy({item = 201927}) -- Gleaming Arcanocrystal
    }
}) -- Forgotten Jewel Box

map.nodes[53934372] = Treasure({
    quest = 70604,
    note = L['in_small_cave'] .. ' ' .. L['gnoll_fiend_flail_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Quest(70535, '{item:199066}') -- Letter of Caution
    },
    rewards = {
        Achievement({id = 16300, criteria = 54805}),
        Transmog({item = 202692, slot = L['1h_mace']}) -- Gnoll Fiend Flail
    }
}) -- Gnoll Fiend Flail

map.nodes[74895501] = Treasure({
    quest = 70606,
    rewards = {
        Achievement({id = 16300, criteria = 54807}), --
        Toy({item = 202711}) -- Lost Compass
    }
}) -- Lost Compass

map.nodes[26544626] = Treasure({
    quest = 70441,
    note = L['pepper_hammer_note'],
    rewards = {
        Achievement({id = 16300, criteria = 54809}),
        Pet({item = 193834, id = 3321}) -- Blackfeather Nester
    }
}) -- Pepper Hammer

map.nodes[54612932] = Treasure({
    quest = 70380,
    rewards = {
        Achievement({id = 16300, criteria = 54808}), --
        Item({item = 202712}) -- Rubber Fish
    }
}) -- Rubber Fish

map.nodes[48632466] = Treasure({
    quest = 70605,
    note = L['gem_cluster_note'],
    requires = {
        ns.requirement.Reputation(2507, 21, true), -- Dragonscale Expedition
        ns.requirement.Quest(70833), -- Rumors of the Jeweled Whelplings
        ns.requirement.Quest(70536, '{item:199067}') -- Precious Plans
    },
    rewards = {
        Achievement({id = 16300, criteria = 54806}), --
        Item({item = 200866}) -- Glimmering Malygite Cluster
    }
}) -- Sapphire Gem Cluster

-------------------------------------------------------------------------------

map.nodes[58024201] = Treasure({
    quest = 70237,
    label = L['snow_covered_scroll'],
    rewards = {
        Item({item = 198103}) -- Recipe: Snow in a Cone
    }
}) -- Snow Covered Scroll

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[40985940] = PetBattle({
    id = 197417,
    rewards = {
        Achievement({id = 16464, criteria = 55487}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 1, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 1, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 1, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 1, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 1, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 1, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 1, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 1, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 1, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 1, oneline = true}) -- Undead
    }
}) -- Arcantus

map.nodes[13884986] = PetBattle({
    id = 196069,
    rewards = {
        Achievement({id = 16464, criteria = 55489}), -- Battle on the Dragon Isles
        ns.reward.Spacer(),
        Achievement({id = 16501, criteria = 5, oneline = true}), -- Aquatic
        Achievement({id = 16503, criteria = 5, oneline = true}), -- Beast
        Achievement({id = 16504, criteria = 5, oneline = true}), -- Critter
        Achievement({id = 16505, criteria = 5, oneline = true}), -- Dragon
        Achievement({id = 16506, criteria = 5, oneline = true}), -- Elemental
        Achievement({id = 16507, criteria = 5, oneline = true}), -- Flying
        Achievement({id = 16508, criteria = 5, oneline = true}), -- Humanoid
        Achievement({id = 16509, criteria = 5, oneline = true}), -- Magic
        Achievement({id = 16510, criteria = 5, oneline = true}), -- Mechanical
        Achievement({id = 16511, criteria = 5, oneline = true}) -- Undead
    }
}) -- Patchu

-------------------------------------------------------------------------------
----------------------------- PROFESSION TREASURES ----------------------------
-------------------------------------------------------------------------------

map.nodes[12504940] = PT.Leatherworking({
    id = 201018,
    quest = 70269,
    note = L['pt_leath_well_danced_drum_note']
}) -- Well-Danced Drum

map.nodes[16203880] = PT.Tailoring({
    id = 198680,
    quest = 70284,
    note = L['pt_tailor_decaying_brackenhide_blanket_note']
}) -- Decaying Brackenhide Blanket

map.nodes[16303849] = PT.Alchemy({
    id = 198599,
    quest = 70208,
    note = L['pt_alch_experimental_decay_sample_note']
}) -- Experimental Decay Sample

map.nodes[16703880] = PT.Leatherworking({
    id = 198658,
    quest = 70266,
    note = L['pt_leath_decay_infused_tanning_oil_note']
}) -- Decay-Infused Tanning Oil

map.nodes[21564555] = PT.Enchanting({
    id = 198694,
    quest = 70298,
    note = L['pt_ench_enriched_earthen_shard_note']
}) -- Enriched Earthen Shard

map.nodes[38505920] = PT.Enchanting({
    id = 198799,
    quest = 70336,
    note = L['pt_ench_forgotten_arcane_tome_note']
}) -- Forgotten Arcane Tome

map.nodes[40705450] = PT.Tailoring({
    id = 198662,
    quest = 70267,
    note = L['pt_tailor_intriguing_bolt_of_blue_cloth_note']
}) -- Intriguing Bolt of Blue Cloth

map.nodes[43703090] = PT.Inscription({
    id = 198686,
    quest = 70293,
    note = L['pt_script_frosted_parchment_note']
}) -- Frosted Parchment

map.nodes[44606120] = PT.Jewelcrafting({
    id = 201016,
    quest = 70271,
    note = L['pt_jewel_harmonic_crystal_harmonizer_note'],
    pois = {POI({44726215, 44176203, 44686017})}
}) -- Harmonic Crystal Harmonizer

map.nodes[45006130] = PT.Jewelcrafting({
    id = 198664,
    quest = 70277,
    note = L['pt_jewel_crystalline_overgrowth_note']
}) -- Crystalline Overgrowth

map.nodes[45106120] = PT.Enchanting({
    id = 201013,
    quest = 70290,
    note = L['pt_ench_faintly_enchanted_remains_note']
}) -- Faintly Enchanted Remains

map.nodes[46202390] = PT.Inscription({
    id = 198693,
    quest = 70297,
    note = L['pt_script_dusty_darkmoon_card_note']
}) -- Dusty Darkmoon Card

map.nodes[53146614] = PT.Blacksmithing({
    id = 201011,
    quest = 70314,
    note = L['pt_smith_spelltouched_tongs_note'],
    requires = {
        ns.requirement.Profession(186), ns.requirement.Profession(164, 2822, 25)
    },
    pois = {POI({53106530})}
}) -- Spelltouched Tongs

map.nodes[57504130] = PT.Leatherworking({
    id = 198683,
    quest = 70286,
    note = L['pt_leath_treated_hides_note']
}) -- Treated Hides

map.nodes[67061316] = PT.Alchemy({
    id = 198712,
    quest = 70309,
    note = L['pt_alch_firewater_powder_sample_note']
}) -- Firewater Powder Sample

-------------------------------------------------------------------------------vvv

map.nodes[17762167] = PM.Engineering({
    id = 194838,
    quest = 70252,
    note = L['pm_engi_frizz_buzzcrank'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2027, note = '5'}) -- Dragon Isles Engineering Knowledge
    }
}) -- Frizz Buzzcrank

map.nodes[40146434] = PM.Inscription({
    id = 194840,
    quest = 70254,
    note = L['pm_script_lydiara_whisperfeather'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2028, note = '5'}) -- Dragon Isles Inscription Knowledge
    }
}) -- Lydiara Whisperfeather

map.nodes[46244076] = PM.Jewelcrafting({
    id = 194841,
    quest = 70255,
    note = L['pm_jewel_pluutar'],
    rewards = {
        Item({item = 190456, note = '25'}), -- Artisan's Mettle
        Currency({id = 2029, note = '5'}) -- Dragon Isles Jewelcrafting Knowledge
    }
}) -- Pluutar

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

map.nodes[39306312] = Dragonglyph({rewards = {Achievement({id = 16065})}}) -- Dragon Glyphs: Azure Archive
map.nodes[10403589] = Dragonglyph({rewards = {Achievement({id = 16068})}}) -- Dragon Glyphs: Brackenhide Hollow
map.nodes[45832573] = Dragonglyph({rewards = {Achievement({id = 16064})}}) -- Dragon Glyphs: Cobalt Assembly
map.nodes[26743167] = Dragonglyph({rewards = {Achievement({id = 16069})}}) -- Dragon Glyphs: Creektooth Den
map.nodes[56811612] = Dragonglyph({rewards = {Achievement({id = 16673})}}) -- Dragon Glyphs: Fallen Course
map.nodes[36582796] = Dragonglyph({rewards = {Achievement({id = 16672})}}) -- Dragon Glyphs: Forkriver Crossing (Ohn'ahran Plains)
map.nodes[60587025] = Dragonglyph({rewards = {Achievement({id = 16070})}}) -- Dragon Glyphs: Imbu
map.nodes[67642913] = Dragonglyph({rewards = {Achievement({id = 16072})}}) -- Dragon Glyphs: Kalthraz Fortress
map.nodes[70584626] = Dragonglyph({rewards = {Achievement({id = 16067})}}) -- Dragon Glyphs: Lost Ruins
map.nodes[68646026] = Dragonglyph({rewards = {Achievement({id = 16066})}}) -- Dragon Glyphs: Ruins of Karnthar
map.nodes[72623978] = Dragonglyph({rewards = {Achievement({id = 16073})}}) -- Dragon Glyphs: Vakthros Range
map.nodes[52954909] = Dragonglyph({rewards = {Achievement({id = 16071})}}) -- Dragon Glyphs: Zelthrak Outpost

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

map.nodes[31912703] = Flag({quest = 71215})
map.nodes[37466620] = Flag({quest = 71216})
map.nodes[46142498] = Flag({quest = 71218})
map.nodes[63084867] = Flag({quest = 71220})
map.nodes[74844324] = Flag({quest = 71221})
map.nodes[77431837] = Flag({quest = 71217})

-------------------------------------------------------------------------------
------------------ WYRMHOLE GENERATOR - SIGNAL TRANSMITTER --------------------
-------------------------------------------------------------------------------

map.nodes[71054788] = SignalTransmitter({quest = 70581}) -- Camp Nowhere
map.nodes[45766525] = SignalTransmitter({quest = 70580}) -- Azure Archives
map.nodes[27562645] = SignalTransmitter({quest = 70579}) -- Brakenhide Hollow

-------------------------------------------------------------------------------
---------------------------- FRAGMENTS OF HISTORY -----------------------------
-------------------------------------------------------------------------------

map.nodes[66066012] = Fragment({
    sublabel = L['chunk_of_sculpture_note'],
    rewards = {
        Achievement({id = 16323, criteria = 55028}),
        Item({item = 199895, quest = 70806})
    }
}) -- Chunk of Sculpture

map.nodes[47833893] = Fragment({
    sublabel = L['in_water'],
    rewards = {
        Achievement({id = 16323, criteria = 55029}),
        Item({item = 199843, quest = 70791})
    }
}) -- Coldwashed Dragonclaw

map.nodes[69174757] = Fragment({
    sublabel = L['stone_dragontooth_note'],
    rewards = {
        Achievement({id = 16323, criteria = 55033}),
        Item({item = 199842, quest = 70790})
    }
}) -- Stone Dragontooth

map.nodes[47342459] = Fragment({
    sublabel = L['wrapped_gold_band_note'],
    rewards = {
        Achievement({id = 16323, criteria = 55034}),
        Item({item = 199840, quest = 70788})
    }
}) -- Wrapped Gold Band

-------------------------------------------------------------------------------
---------------------------- LEY LINE IN THE SPAN -----------------------------
-------------------------------------------------------------------------------

local LeyLine = Class('LeyLine', Collectible, {
    id = 198260,
    icon = 1033908,
    note = L['in_small_cave'] .. '\n' .. L['leyline_note'],
    rlabel = ns.status.LightBlue('+20 ' .. select(1, GetFactionInfoByID(2510))), -- Valdrakken Accord
    group = ns.groups.LEYLINE
})

map.nodes[43476224] = LeyLine({
    quest = 72138,
    rewards = {Achievement({id = 16638, criteria = 55972})}
}) -- Azure Archives

map.nodes[26533590] = LeyLine({
    quest = 72139,
    rewards = {Achievement({id = 16638, criteria = 55973})}
}) -- Ancient Outlook

map.nodes[65885066] = LeyLine({
    requires = ns.requirement.Profession(186), -- Mining
    quest = 72136,
    rewards = {Achievement({id = 16638, criteria = 55974})}
}) -- Rustpine Den

map.nodes[66395950] = LeyLine({
    quest = 72141,
    rewards = {Achievement({id = 16638, criteria = 55975})}
}) -- Ruins of Karnthar

map.nodes[65732814] = LeyLine({
    quest = 72140,
    rewards = {Achievement({id = 16638, criteria = 55976})}
}) -- Slyvern Plunge

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[13503833] = Disturbeddirt({note = L['in_small_cave']})
map.nodes[19214047] = Disturbeddirt()
map.nodes[19225097] = Disturbeddirt()
map.nodes[23716772] = Disturbeddirt()
map.nodes[29872621] = Disturbeddirt()
map.nodes[33704685] = Disturbeddirt()
map.nodes[34234591] = Disturbeddirt()
map.nodes[50284428] = Disturbeddirt()
map.nodes[57775352] = Disturbeddirt()
map.nodes[65193151] = Disturbeddirt()
map.nodes[65516163] = Disturbeddirt()
map.nodes[66733144] = Disturbeddirt({note = L['in_cave']})
map.nodes[68291742] = Disturbeddirt()
map.nodes[70724381] = Disturbeddirt()
map.nodes[72404272] = Disturbeddirt({note = L['in_small_cave']})
map.nodes[73374059] = Disturbeddirt()
map.nodes[78753394] = Disturbeddirt()
map.nodes[78903087] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[14143645] = Scoutpack()
map.nodes[14943299] = Scoutpack()
map.nodes[15183187] = Scoutpack()
map.nodes[33864679] = Scoutpack()
map.nodes[33864679] = Scoutpack()
map.nodes[34334607] = Scoutpack()
map.nodes[43005294] = Scoutpack()
map.nodes[58115454] = Scoutpack()
map.nodes[58145373] = Scoutpack()
map.nodes[65702841] = Scoutpack({note = L['in_small_cave']})
map.nodes[66733050] = Scoutpack({note = L['in_cave']})
map.nodes[66783133] = Scoutpack({note = L['in_cave']})
map.nodes[66784934] = Scoutpack()
map.nodes[72154242] = Scoutpack({note = L['in_cave']})
map.nodes[72604263] = Scoutpack({note = L['in_cave']})
map.nodes[78953094] = Scoutpack()
map.nodes[79823175] = Scoutpack()

-------------------------------------------------------------------------------
------------------------------ Magic-Bound Chest ------------------------------
-------------------------------------------------------------------------------

map.nodes[09104840] = MagicBoundChest({
    note = L['in_small_cave'],
    pois = {POI({08584883})}
})
map.nodes[14002990] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[29904570] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[43306260] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[49204090] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[53006610] = MagicBoundChest({
    requires = {
        ns.requirement.Reputation(2507, 16, true),
        ns.requirement.Profession(186)
    },
    note = L['in_small_cave']
})
map.nodes[65702780] = MagicBoundChest({note = L['in_small_cave']})
map.nodes[65905560] = MagicBoundChest()
map.nodes[72304210] = MagicBoundChest({
    note = L['in_cave'],
    pois = {POI({71674371})}
})

-------------------------------------------------------------------------------
------------------------------ TUSKARR TACKLEBOX ------------------------------
-------------------------------------------------------------------------------

map.nodes[30512493] = TuskarrTacklebox()

-------------------------------------------------------------------------------
--------------------------------- DRAGONRACES ---------------------------------
-------------------------------------------------------------------------------

map.nodes[47914077] = Dragonrace({
    label = '{quest:66946}',
    normal = {2074, 66, 63},
    advanced = {2075, 63, 58},
    rewards = {
        Achievement({id = 15921, criteria = 1, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 1, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 1, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 1, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 1, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 1, oneline = true}) -- advanced gold
    }
}) -- Azure Span Sprint

map.nodes[20952262] = Dragonrace({
    label = '{quest:67002}',
    normal = {2076, 61, 58},
    advanced = {2077, 61, 56},
    rewards = {
        Achievement({id = 15921, criteria = 2, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 2, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 2, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 2, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 2, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 2, oneline = true}) -- advanced gold
    }
}) -- Azure Span Slalom

map.nodes[71292466] = Dragonrace({
    label = '{quest:67031}',
    normal = {2078, 61, 58},
    advanced = {2079, 61, 56},
    rewards = {
        Achievement({id = 15921, criteria = 3, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 3, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 3, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 3, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 3, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 3, oneline = true}) -- advanced gold
    }
}) -- Vakthros Ascent

map.nodes[16574937] = Dragonrace({
    label = '{quest:67296}',
    normal = {2083, 78, 75},
    advanced = {2084, 75, 70},
    rewards = {
        Achievement({id = 15921, criteria = 4, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 4, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 4, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 4, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 4, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 4, oneline = true}) -- advanced gold
    }
}) -- Iskaara Tour

map.nodes[48473578] = Dragonrace({
    label = '{quest:67565}',
    normal = {2085, 79, 76},
    advanced = {2086, 77, 72},
    rewards = {
        Achievement({id = 15921, criteria = 5, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 5, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 5, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 5, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 5, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 5, oneline = true}) -- advanced gold
    }
}) -- Frostland Flyover

map.nodes[42265676] = Dragonrace({
    label = '{quest:67741}',
    normal = {2089, 94, 91},
    advanced = {2090, 86, 81},
    rewards = {
        Achievement({id = 15921, criteria = 6, oneline = true}), -- normal bronze
        Achievement({id = 15922, criteria = 6, oneline = true}), -- normal silver
        Achievement({id = 15923, criteria = 6, oneline = true}), -- normal gold
        Achievement({id = 15933, criteria = 6, oneline = true}), -- advanced bronze
        Achievement({id = 15934, criteria = 6, oneline = true}), -- advanced silver
        Achievement({id = 15935, criteria = 6, oneline = true}) -- advanced gold
    }
}) -- Archive Ambit

-------------------------------------------------------------------------------
--------------------- TO ALL THE SQUIRRELS HIDDEN TIL NOW ---------------------
-------------------------------------------------------------------------------

map.nodes[58695326] = Squirrel({
    id = 193594,
    rewards = {Achievement({id = 16729, criteria = 7})}
}) -- Timbertooth Kit

map.nodes[49975755] = Squirrel({
    id = 186481,
    rewards = {Achievement({id = 16729, criteria = 8})}
}) -- Frosty Spiderling

map.nodes[29244368] = Squirrel({
    id = 197718,
    rewards = {Achievement({id = 16729, criteria = 9})}
}) -- Crimson Knocker

-------------------------------------------------------------------------------
--------------------------- THE DISGRUNTLED HUNTER ----------------------------
-------------------------------------------------------------------------------

local HemetNesingwaryJr = Class('HemetNesingwaryJr', Collectible, {
    id = 194590,
    icon = 236444,
    sublabel = L['hnj_sublabel'],
    group = ns.groups.HEMET_NESINGWARY_JR
}) -- Hemet Nesingwary Jr.

map.nodes[36533481] = HemetNesingwaryJr({
    note = L['hnj_western_azure_span_hunt'],
    rewards = {Achievement({id = 16542, criteria = 55698})}
}) -- Western Azure Span Hunt

map.nodes[68112353] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55699})}
}) -- Eastern Azure Span Hunt

map.nodes[69204987] = HemetNesingwaryJr({
    rewards = {Achievement({id = 16542, criteria = 55700})}
}) -- Southern Azure Span Hunt

-------------------------------------------------------------------------------
----------------------------- THAT'S PRETTY NEAT! -----------------------------
-------------------------------------------------------------------------------

map.nodes[36673652] = PrettyNeat({
    id = 190218,
    rewards = {Achievement({id = 16446, criteria = 55393})}
}) -- Horned Filcher

map.nodes[38193815] = PrettyNeat({
    id = 190221,
    rewards = {Achievement({id = 16446, criteria = 55390})}
}) -- Pine Flicker

map.nodes[16622798 + 1] = PrettyNeat({
    id = 193259,
    isRare = true,
    mapID = map.id,
    rewards = {Achievement({id = 16446, criteria = 55397})}
}) -- Blue Terror (node coords must be off by 00000001 from Rare)

-------------------------------------------------------------------------------
------------------------------ A LEGENDARY ALBUM ------------------------------
-------------------------------------------------------------------------------

map.nodes[44506011] = LegendaryCharacter({
    id = 131443,
    rewards = {Achievement({id = 16570, criteria = 55771})}
}) -- Chief Telemancer Oculeth

-------------------------------------------------------------------------------
-------------------------- ONE OF EVERYTHING, PLEASE --------------------------
-------------------------------------------------------------------------------

map.nodes[63005780] = Collectible({
    label = '{item:201089}',
    icon = 644375,
    note = L['craft_creche_crowler_note'],
    group = ns.groups.SPECIALTIES,
    rewards = {Achievement({id = 16621, criteria = 55940})}
}) -- Craft Creche Crowler

-------------------------------------------------------------------------------
----------------------------- DRAGON ISLES SAFARI -----------------------------
-------------------------------------------------------------------------------

map.nodes[15202400] = Safari({
    id = 192265,
    rewards = {Achievement({id = 16519, criteria = 55642}), Pet({id = 3357})},
    pois = {
        POI({
            14802620, 15004520, 15202400, 17202500, 17604440, 17802900,
            18202400, 19004660, 19803760, 21602540, 21603780, 22602720,
            25203860, 25803320, 27203400, 27204380, 33803540, 33803560,
            34003220, 35603200, 37403120, 39006080, 40403460, 41806280,
            43605960, 43805200, 43805940, 43806060, 44405000, 44604840,
            44805820, 45003980, 45206240, 45206260, 45404220, 46405220,
            46604080, 46605240, 46802980, 46803520, 47002320, 47603140,
            47603160, 48404920, 48605140, 48605160, 49002780, 49204740,
            50204620, 50205220, 50405100, 50602280, 50803660, 51004420,
            51205380, 52002260, 53002640, 54204400, 54402240, 54402260,
            56603960, 57002480, 57005180, 57405780, 57803680, 58201940,
            58201960, 58806620, 59002960, 59604240, 60601620, 61001920,
            61205040, 61205060, 61205680, 61606060, 64006180, 64601680,
            64803140, 65001940, 65005320, 65005720, 66205500, 66205840,
            66601540, 66601560, 67402380, 67806040, 68201300, 68203080,
            68602460, 69605220, 69801040, 69801060, 69801820, 70205320, 71002700
        })
    }
}) -- Azure Crystalspine

map.nodes[60403800] = Safari({
    id = 192268,
    rewards = {Achievement({id = 16519, criteria = 55656}), Pet({id = 3358})},
    pois = {POI({60403800, 60603800})}
}) -- Crimsonspine

map.nodes[37203300] = Safari({
    id = 194720,
    rewards = {Achievement({id = 16519, criteria = 55647}), Pet({id = 3351})},
    pois = {
        POI({
            27403120, 29203240, 30804700, 31404460, 32203540, 34403720,
            35204960, 36203400, 36803000, 37203300, 38003020, 41204880,
            42803840, 42804480, 67205080, 71605360
        })
    }
}) -- Grizzlefur Cub

map.nodes[23603720] = Safari({
    id = 189122,
    rewards = {Achievement({id = 16519, criteria = 55652}), Pet({id = 3296})},
    pois = {
        POI({
            11004180, 11004440, 11004460, 11404320, 11804640, 23404040,
            23603720, 27603700, 34204600, 34204840, 34204860, 39405020, 41204920
        })
    }
}) -- Palamanther

map.nodes[12004740] = Safari({
    id = 189103,
    rewards = {Achievement({id = 16519, criteria = 55657}), Pet({id = 3281})},
    pois = {
        POI({
            12004740, 13604800, 14004980, 15405040, 15604880, 23807140,
            24806980, 25207160, 44005460, 45005400, 46205340, 50405440,
            59606820, 59805620, 68205340, 68605200
        })
    }
}) -- Scruffy Ottuk

map.nodes[48606480] = Safari({
    id = 189107,
    rewards = {Achievement({id = 16519, criteria = 55659}), Pet({id = 3283})},
    pois = {
        POI({
            47203940, 47203960, 48606480, 49006200, 55202120, 59404480,
            66601140, 66601160, 67201300, 67601900, 70003620, 70604380,
            71604380, 72204320, 72402540, 72402560, 72602560, 72604040,
            73003640, 75202360, 78403240
        })
    }
}) -- Snowlemental

map.nodes[40803180] = Safari({
    id = 189104,
    rewards = {Achievement({id = 16519, criteria = 55661}), Pet({id = 3282})},
    pois = {
        POI({
            10404120, 11604040, 11804140, 13804360, 17003000, 18002220,
            18202740, 18804940, 19202440, 20002420, 20604040, 20804460,
            22003920, 23403420, 23803420, 24803040, 32604740, 33803140,
            33803160, 33804800, 34603100, 35805020, 39803180, 40803180,
            41403360, 42003440, 43003600, 44003800, 45803660, 46003640,
            50002160, 50601940, 53001900, 56206540, 58406460, 64801520,
            66001680, 66805940, 67005960, 68804940, 68804960, 74405420
        })
    }
}) -- Swoglet

map.nodes[59405740] = Safari({
    id = 189658,
    rewards = {Achievement({id = 16519, criteria = 55661}), Pet({id = 3328})},
    pois = {
        POI({
            11603480, 12803820, 15003440, 15003540, 15003560, 19604720,
            20404300, 21603880, 21803960, 25403680, 43403620, 43603640,
            58205220, 58805540, 59005220, 59405740, 59605740, 67405560
        })
    }
}) -- Tiny Timbertooth

map.nodes[68402720] = Safari({
    id = 189110,
    rewards = {Achievement({id = 16519, criteria = 55664}), Pet({id = 3288})},
    pois = {
        POI({
            22404580, 23804620, 26403940, 64405620, 65205480, 68402720,
            69002800, 69402660, 70402920, 70602940
        })
    }
}) -- Trunkalumpf

map.nodes[34204160] = Safari({
    id = 191323,
    rewards = {Achievement({id = 16519, criteria = 55666}), Pet({id = 3336})},
    pois = {
        POI({
            16602560, 16602800, 18802760, 20603220, 21003420, 22803020,
            32203900, 33404000, 34204140, 34204160, 35204060, 36803520,
            37004280, 38803580, 40003740
        })
    }
}) -- Vorquin Runt

-------------------------------------------------------------------------------
------------------------ ELEMENTAL STORMS: AZURE SPAN -------------------------
-------------------------------------------------------------------------------

map.nodes[11983718] = ElementalStorm({
    label = format('%s: %s', L['elemental_storm'],
        L['elemental_storm_brakenhide_hollow']),
    mapID = map.id,
    areaPOIs = {7229, 7230, 7231, 7232}
}) -- Elemental Storm: Brakenhide Hollow

map.nodes[47372200] = ElementalStorm({
    label = format('%s: %s', L['elemental_storm'],
        L['elemental_storm_cobalt_assembly']),
    mapID = map.id,
    areaPOIs = {7233, 7234, 7235, 7236}
}) -- Elemental Storm: Cobalt Assembly

map.nodes[58506660] = ElementalStorm({
    label = format('%s: %s', L['elemental_storm'], L['elemental_storm_imbu']),
    mapID = map.id,
    areaPOIs = {7237, 7238, 7239, 7240}
}) -- Elemental Storm: Imbu

-------------------------------------------------------------------------------
-------------------------------- MISCELLANEOUS --------------------------------
-------------------------------------------------------------------------------

------------------------ MOUNT: TEMPERAMENTAL SKYCLAW -------------------------

local TemperamentalSkyclaw = Class('TemperamentalSkyclaw', Collectible, {
    id = 190892,
    icon = 4218760,
    rewards = {
        Mount({item = 201454, id = 1674}) -- Temperamental Skyclaw
    },
    pois = {POI({58234353, 23074372, 32004400})}
}) -- Temperamental Skyclaw

function TemperamentalSkyclaw.getters:note()
    local function status(id, itemsNeed)
        local itemsHave = GetItemCount(id, true);
        if ns.PlayerHasItem(id, itemsNeed) then
            return ns.status.Green(itemsHave .. '/' .. itemsNeed)
        else
            return ns.status.Red(itemsHave .. '/' .. itemsNeed)
        end
    end

    local note = L['temperamental_skyclaw_note_start']
    note = note .. '\n\n' .. status(201420, 20) .. ' {item:201420}' -- Gnolan's House Special
    note = note .. '\n\n' .. status(201421, 20) .. ' {item:201421}' -- Tuskarr Jerky
    note = note .. '\n\n' .. status(201422, 20) .. ' {item:201422}' -- Flash Frozen Meat
    return note .. '\n\n' .. L['temperamental_skyclaw_note_end']
end

map.nodes[19042397] = TemperamentalSkyclaw()

--------------------------- ACHIEVEMENT: SEEING BLUE --------------------------

map.nodes[40116156] = Collectible({
    label = '{achievement:16581}',
    note = L['seeing_blue_note'],
    icon = 2103880,
    rewards = {Achievement({id = 16581})},
    pois = {ns.poi.Arrow({40116156, 46112646}), POI({46112646})}
}) -- Seeing Blue

----------------- ACHIEVEMENT: DO YOU WANNA BUILD A SNOWMAN? ------------------

map.nodes[50935561] = Collectible({
    label = '{achievement:16474}',
    note = L['snowman_note'],
    icon = 655957,
    rewards = {Achievement({id = 16474})},
    pois = {POI({50955481, 50985611})}
}) -- Do You Wanna Build a Snowman?

--------------------- ACHIEVEMENT: RIVER RAPIDS WRANGLER ----------------------

map.nodes[45025405] = Collectible({
    label = '{achievement:15889}',
    note = L['river_rapids_wrangler_note'],
    icon = 134325,
    requires = ns.requirement.Quest(66155), -- Ruriq's River Rapids Ride
    rewards = {Achievement({id = 15889})}
}) -- River Rapids Wrangler

------------------------------ PET: SNOWCLAW CUB ------------------------------

local SnowclawCub = Class('SnowclawCub', Collectible, {
    id = 196768,
    icon = 4532351,
    requires = ns.requirement.Quest(67606), -- A Dryadic Remedy
    rewards = {
        Pet({item = 201838, id = 3359}) -- Snowclaw Cub
    }
}) -- Snowclaw Cub

function SnowclawCub.getters:note()
    local function status(id, itemsNeed)
        local itemsHave = GetItemCount(id, true);
        if ns.PlayerHasItem(id, itemsNeed) then
            return ns.status.Green(itemsHave .. '/' .. itemsNeed)
        else
            return ns.status.Red(itemsHave .. '/' .. itemsNeed)
        end
    end

    local note = L['snowclaw_cub_note_start']
    note = note .. '\n\n' .. status(197744, 3) .. ' ' ..
               L['snowclaw_cub_note_item1'] -- Hornswog Hunk
    note = note .. '\n\n' .. status(198356, 1) .. ' ' ..
               L['snowclaw_cub_note_item2'] -- Honey Snack
    return note .. '\n\n' .. L['snowclaw_cub_note_end']
end

map.nodes[67431840] = SnowclawCub()

------------------------ ITEM: TOME OF POLYMORPH: DUCK ------------------------

map.nodes[66333211] = Collectible({
    label = '{item:200205}',
    icon = 133739,
    note = L['tome_of_polymoph_duck'],
    class = 'MAGE',
    rewards = {
        Item({item = 200205}) -- Tome of Polymoph: Duck
    },
    pois = {POI({66453173})}
}) -- Tome of Polymorph: Duck

------------------- ACHIEVEMENT: THREE MINUTES OR IT'S FREE -------------------

map.nodes[45635482] = Node({
    label = '{item:200949}',
    note = L['the_great_shellkhan_note'],
    icon = 133920,
    quest = 72110,
    rewards = {
        Item({item = 200949}) -- Case of Fresh Gleamfish
    }
}) -- Case of Fresh Gleamfish

------------------------- ITEM: MAGICAL SALT CRYSTAL --------------------------

map.nodes[11604106] = Node({
    label = '{item:201033}',
    note = L['in_small_cave'] .. ' ' .. L['slurpo_snail_note'],
    icon = 132780,
    quest = 74079,
    rewards = {
        Item({item = 201033}) -- Magical Salt Crystal
    },
    pois = {POI({11084139})} -- Entrance
}) -- Magical Salt Crystal

----------------------------- TOY: ARTIST'S EASEL -----------------------------

local Ranpiata = Class('Ranpiata', Collectible, {
    id = 194425,
    icon = 237053,
    rewards = {
        Toy({item = 198474}) -- Artist's Easel
    },
    pois = {
        POI({22133677}) -- Rauvros
    }
}) -- Ranpiata

function Ranpiata.getters:note()
    local function status(questID, questLeg)
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            return ns.status.Green(questLeg)
        else
            return ns.status.Red(questLeg)
        end
    end

    local note = '\n' .. status(70166, 1) .. ' ' ..
                     L['artists_easel_note_step1'] -- The Joy of Painting
    note = note .. '\n\n' .. status(70168, 2) .. ' ' ..
               L['artists_easel_note_step2'] -- Sad Little Accidents
    note = note .. '\n\n' .. status(70170, 3) .. ' ' ..
               L['artists_easel_note_step3'] -- Beat the Demons Out of It
    return note .. '\n\n' .. L['artists_easel_note_step4']
end

map.nodes[07855348] = Ranpiata()

----------------------- TOY: SOMEWHAT-STABILIZED ARCANA -----------------------

map.nodes[46202580] = Collectible({
    label = '{item:200628}',
    icon = 136116,
    note = L['somewhat_stabilized_arcana_note'],
    quest = {71094, 71095, 71096, 71097},
    questCount = true,
    rewards = {
        Toy({item = 200628}) -- Somewhat-Stabilized Arcana
    }
})

----------------------------- MISCELLANEOUS NPCs ------------------------------

map.nodes[12404920] = NPC({
    id = 186448,
    icon = 4638464,
    note = L['elder_poa_note'],
    pois = {
        POI({12814934}) -- Entrance
    }
}) -- Elder Poa (Iskaara Tuskarr Reputation)

-- STOP: DO NOT ADD NEW NODES HERE UNLESS THEY BELONG IN MISCELLANEOUS
