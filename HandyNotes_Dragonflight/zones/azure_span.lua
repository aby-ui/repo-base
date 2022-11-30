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
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure
local PetBattle = ns.node.PetBattle

local Achievement = ns.reward.Achievement
local Item = ns.reward.Item
local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2024, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[53013563] = Rare({
    id = 194270,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56099})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Arcane Devourer

-- map.nodes[] = Rare({
--     id = 193255,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56123}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Archmage Cleary

-- map.nodes[] = Rare({
--     id = 197411,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56130}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Astray Splasher

map.nodes[55823132] = Rare({
    id = 194210,
    quest = nil,
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
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56106})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Beogoka

map.nodes[13584855] = Rare({
    id = 197557,
    quest = 70893,
    note = L['Bisquis_Note'],
    rewards = {
        Achievement({id = 16678, criteria = 55381}),
        Achievement({id = 16444, criteria = 1})
    }
}) -- Bisquius

-- map.nodes[] = Rare({
--     id = 193178,
--     quest = 69858,
--     rewards = {
--         Achievement({id = 16678, criteria = 56122}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Blightfur

map.nodes[14053096] = Rare({
    id = 197353,
    quest = nil,
    fgroup = 'blackhide',
    note = L['blisterhide_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56126})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Blisterhide

map.nodes[16622798] = Rare({
    id = 193259,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56108}),
        Item({item = 197595, quest = 69799}) -- Windborne Velocidrake: Finned Ears
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Blue Terror

-- map.nodes[] = Rare({
--     id = 194392,
--     quest = 70165,
--     rewards = {
--         Achievement({id = 16678, criteria = 56103}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Brackle

map.nodes[27214490] = Rare({
    id = 193157,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56098}),
        Item({item = 197005, quest = 69205}) -- Cliffside Wylderdrake: Horned Nose
        -- Transmog({item = , slot = L['']}) -- Name
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
    quest = 72254, -- wrong id?
    note = L['fisherman_tinnak_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56115}),
        Transmog({item = 199026, slot = L['1h_sword']}), -- Fire-Blessed Blade
        Item({item = 197382, quest = 69583}), -- Renewed Proto-Drake: White Horns
        Item({item = 198070}) -- Tattered Seavine
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({50523672, 49973821, 49223842})}
}) -- Fisherman Tinnak

map.nodes[64992995] = Rare({
    id = 193698,
    quest = 69985,
    note = L['in_small_cave'],
    rewards = {
        Achievement({id = 16678, criteria = 56104})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Frigidpelt Den Mother

-- map.nodes[] = Rare({
--     id = 191356,
--     quest = 67148,
--     rewards = {
--         Achievement({id = 16678, criteria = 56101}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Frostpaw

map.nodes[14083747] = Rare({
    id = 197354,
    quest = nil,
    fgroup = 'blackhide',
    note = L['gnarls_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56127})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Gnarls

map.nodes[32682911] = Rare({ -- review -- required 67030
    id = 193251,
    quest = 69885,
    rewards = {
        Achievement({id = 16678, criteria = 56111})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Gruffy

map.nodes[19234362] = Rare({ -- required 67030
    id = 193269,
    quest = 69892,
    rewards = {
        Achievement({id = 16678, criteria = 56112}),
        Transmog({item = 200206, slot = L['bow']}) -- Behemoth Slayer Greatbow
    }
}) -- Grumbletrunk

map.nodes[16213364] = Rare({
    id = 197356,
    quest = nil,
    fgroup = 'blackhide',
    note = L['high_shaman_rotknuckle_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56128})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- High Shaman Rotknuckle

map.nodes[36243573] = Rare({
    id = 190244,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56109})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {Path({35873621, 36243573, 36543508, 36863479})}
}) -- Mahg the Trampler

map.nodes[40514797] = Rare({
    id = 198004,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56100}),
        Item({item = 197150, quest = 69351}) -- Highland Drake: Spiked Club Tail
    }
}) -- Mange the Outcast

-- map.nodes[] = Rare({
--     id = 193735,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56119}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Moth'go Deeploom

map.nodes[58095471] = Rare({ -- review
    id = 193201,
    quest = nil,
    rewards = {
        Achievement({id = 16678, criteria = 56102}),
        Item({item = 200445, note = L['neck']}) -- Lucky Hunting Charm
    }
}) -- Mucka the Raker

map.nodes[34362779] = Rare({ -- review location in cave map 2132 Kargpaw's Den
    id = 193225,
    quest = nil,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 16678, criteria = 56107}), Toy({item = 200160}) -- Notfar's Favorite Food
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({34023076, 34933000})} -- Entrance
}) -- Notfar the Unbearable

-- map.nodes[] = Rare({
--     id = 197371,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56129}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Ravenous Tundra Bear

-- map.nodes[] = Rare({
--     id = 193693,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56113}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Rusthide

-- map.nodes[] = Rare({
--     id = 193710,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56118}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Seereel, the Spring

map.nodes[26494939] = Rare({ -- review -- required 67030
    id = 193149,
    quest = 72154,
    rewards = {
        Achievement({id = 16678, criteria = 56110})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Skag the Thrower

-- map.nodes[] = Rare({
--     id = 193708,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56117}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Skald the Impaler

map.nodes[10863229] = Rare({
    id = 197344,
    quest = nil,
    fgroup = 'blackhide',
    note = L['snarglebone_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56125})
        -- Transmog({item = , slot = L['']}) -- Name
    }
}) -- Snarglebone

-- map.nodes[] = Rare({
--     id = 193706,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56116}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Snufflegust

map.nodes[55033405] = Rare({
    id = 193238,
    quest = nil, -- 69879 ?
    note = L['spellwrought_snowman_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56124}),
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

-- map.nodes[] = Rare({
--     id = 193634,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16678, criteria = 56120}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Swog'ranka

map.nodes[70222532] = Rare({
    id = 193196,
    quest = nil, -- 69861 ?
    note = L['trilvarus_loreweaver_note'],
    rewards = {
        Achievement({id = 16678, criteria = 56114})
        -- Transmog({item = , slot = L['']}) -- Name
    },
    pois = {POI({70432369})}
}) -- Trilvarus Loreweaver

-- map.nodes[] = Rare({
--     id = 193632,
--     quest = 69948,
--     rewards = {
--         Achievement({id = 16678, criteria = 56097}),
--         Transmog({item = , slot = L['']}) -- Name
--     }
-- }) -- Wilrive

-------------------------------------------------------------------------------
---------------------------- BONUS OBJECTIVE BOSSES ---------------------------
-------------------------------------------------------------------------------

map.nodes[28564743] = BonusBoss({
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
        })
    }
}) -- Breezebiter

map.nodes[23503317] = BonusBoss({
    id = 186962,
    quest = 72836,
    rewards = {
        Transmog({item = 200135, slot = L['2h_sword']}), -- Corroded Greatsword
        Transmog({item = 200187, slot = L['staff']}), -- Rod of Glacial Force
        Item({item = 197098, quest = 69299}) -- Highland Drake: Finned Back
    }
}) -- Cascade

map.nodes[38155901] = BonusBoss({
    id = 193214,
    quest = 72840, -- 69864
    note = L['in_cave'],
    rewards = {
        Item({item = 200210, note = L['neck']}) -- Amnesia
    },
    pois = {POI({38625988})}
}) -- Forgotten Creation

map.nodes[70143327] = BonusBoss({
    id = 193288,
    quest = 72848,
    rewards = {
        Item({item = 198048}), -- Titan Training Matrix I
        Item({item = 200868, note = L['trinket']}) -- Intefrated Primal Fire
    }
}) -- Summoned Destroyer

-- map.nodes[17254144] = BonusBoss({id = 193223, quest = nil}) -- Vakril

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[45125940] = Treasure({
    quest = 70603,
    note = L['forgotten_jewel_box_note'],
    requires = {
        ns.requirement.Quest(72709), -- Funding a Treasure Hunt
        ns.requirement.Item(199065) -- Sorrowful Letter
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
        ns.requirement.Item(199066) -- Letter of Caution
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
        ns.requirement.Item(199067) -- Precious Plans
    },
    rewards = {
        Achievement({id = 16300, criteria = 54806}), --
        Item({item = 200866}) -- Glimmering Malygite Cluster
    }
}) -- Sapphire Gem Cluster

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
map.nodes[71986162] = Flag({quest = 71221})
map.nodes[77431837] = Flag({quest = 71217})

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[13503833] = Disturbeddirt({note = L['in_small_cave']})
map.nodes[19214047] = Disturbeddirt()
map.nodes[23716772] = Disturbeddirt()
map.nodes[33704685] = Disturbeddirt()
map.nodes[34234591] = Disturbeddirt()
map.nodes[57775352] = Disturbeddirt()
map.nodes[65516163] = Disturbeddirt()
map.nodes[70724381] = Disturbeddirt()
map.nodes[73374059] = Disturbeddirt()
map.nodes[78753394] = Disturbeddirt()
map.nodes[78903087] = Disturbeddirt()

-------------------------------------------------------------------------------
---------------------------- LEY LINE IN THE SPAN -----------------------------
-------------------------------------------------------------------------------

local LayLine = Class('LayLine', Collectible, {
    id = 198260,
    icon = 1033908,
    note = L['in_small_cave'] .. '\n' .. L['leyline_note'],
    rlabel = ns.status.LightBlue('+20 ' .. select(1, GetFactionInfoByID(2510))), -- Valdrakken Accord
    group = ns.groups.LAYLINE
})

map.nodes[43476224] = LayLine({
    quest = 72138,
    rewards = {Achievement({id = 16638, criteria = 55972})}
}) -- Azure Archives

map.nodes[26533590] = LayLine({
    quest = 72139,
    rewards = {Achievement({id = 16638, criteria = 55973})}
}) -- Ancient Outlook

map.nodes[65885066] = LayLine({
    requires = ns.requirement.Profession(5, 186), -- Mining
    quest = 72136,
    rewards = {Achievement({id = 16638, criteria = 55974})}
}) -- Rustpine Den

map.nodes[66395950] = LayLine({
    quest = 72141,
    rewards = {Achievement({id = 16638, criteria = 55975})}
}) -- Ruins of Karnthar

map.nodes[65732814] = LayLine({
    quest = 72140,
    rewards = {Achievement({id = 16638, criteria = 55976})}
}) -- Slyvern Plunge

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
map.nodes[66784934] = Scoutpack()
map.nodes[72154242] = Scoutpack({note = L['in_cave']})
map.nodes[72604263] = Scoutpack({note = L['in_cave']})
map.nodes[78953094] = Scoutpack()
map.nodes[79823175] = Scoutpack()

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
