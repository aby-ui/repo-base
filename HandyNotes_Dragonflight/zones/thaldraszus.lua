-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
-- local Class = ns.Class
local L = ns.locale
local Map = ns.Map

-- local Collectible = ns.node.Collectible
local Disturbeddirt = ns.node.Disturbeddirt
local Dragonglyph = ns.node.Dragonglyph
local Flag = ns.node.Flag
local Rare = ns.node.Rare
local Scoutpack = ns.node.Scoutpack
local Treasure = ns.node.Treasure
local PetBattle = ns.node.PetBattle

local Achievement = ns.reward.Achievement
-- local Mount = ns.reward.Mount
local Pet = ns.reward.Pet
local Transmog = ns.reward.Transmog

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2025, settings = true})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[59545917] = Rare({ -- review
    id = 193664,
    quest = 69963,
    rewards = {Achievement({id = 16679, criteria = 56158})}
}) -- Ancient Protector

-- map.nodes[] = Rare({
--     id = 193128,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16679, criteria = 56136}),
--     }
-- }) -- Blightpaw the Depraved

map.nodes[59847057] = Rare({ -- required 67030
    id = 193220,
    quest = 69868,
    rewards = {
        Achievement({id = 16679, criteria = 56149}),
        Transmog({item = 200138, slot = L['polearm']}) -- Ancient Dancer's Longspear
    }
}) -- Broodweaver Araznae

map.nodes[44886910] = Rare({
    id = 193658,
    quest = 69962,
    note = L['in_cave'],
    rewards = {
        Achievement({id = 16679, criteria = 56156}),
        Transmog({item = 199020, slot = L['gun']}) -- Drake Race Starting Rifle of the Fireflash
    },
    pois = {POI({44616780})} -- Entrance
}) -- Corrupted Proto-Dragon

local CRAGGRAVATEDELEMENTAL = Rare({
    id = 193663,
    quest = 69964,
    fgroup = 'craggravated',
    focusable = true,
    rewards = {Achievement({id = 16679, criteria = 56154})}
}) -- Craggravated Elemental

map.nodes[45458518] = CRAGGRAVATEDELEMENTAL
map.nodes[52746732] = CRAGGRAVATEDELEMENTAL

map.nodes[47675115] = Rare({ -- required 67030
    id = 193234,
    quest = 69875,
    rewards = {Achievement({id = 16679, criteria = 56147})}
}) -- Eldoren the Reborn

-- map.nodes[] = Rare({
--     id = 193125,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16679, criteria = 56138}),
--     }
-- }) -- Goremaul the Gluttonous

map.nodes[57828380] = Rare({ -- review
    id = 193126,
    quest = nil,
    rewards = {Achievement({id = 16679, criteria = 56135})}
}) -- Innumerable Ruination

-- map.nodes[] = Rare({
--     id = 193241,
--     quest = 69882,
--     rewards = {
--         Achievement({id = 16679, criteria = 56157}),
--     }
-- }) -- Lord Epochbrgl

-- map.nodes[] = Rare({
--     id = 193246,
--     quest = 69883,
--     rewards = {
--         Achievement({id = 16679, criteria = 56141}),
--     }
-- }) -- Matriarch Remalla

-- map.nodes[] = Rare({ -- reqired 67030
--     id = 193688,
--     quest = 69976,
--     rewards = {
--         Achievement({id = 16679, criteria = 56140}),
--     }
-- }) -- Phenran

map.nodes[57218420] = Rare({ -- reqired 67030 review
    id = 193210,
    quest = 69866,
    rewards = {Achievement({id = 16679, criteria = 56142})}
}) -- Phleep

-- map.nodes[] = Rare({
--     id = 193130,
--     quest = nil,
--     rewards = {
--         Achievement({id = 16679, criteria = 56137}),
--     }
-- }) -- Pleasant Alpha

-- map.nodes[] = Rare({
--     id = 193143,
--     quest = 69853,
--     rewards = {
--         Achievement({id = 16679, criteria = 56133}),
--     }
-- }) -- Razk'vex the Untamed

map.nodes[40087014] = Rare({ -- reqiured 67030
    id = 193240,
    quest = 69880,
    rewards = {Achievement({id = 16679, criteria = 56148})}
}) -- Riverwalker Tamopo

map.nodes[50005180] = Rare({ -- reqiured 67030 review
    id = 193666,
    quest = 69966,
    rewards = {Achievement({id = 16679, criteria = 56151})}
}) -- Rokmur

-- map.nodes[] = Rare({ -- reqiured 67030
--     id = 193176,
--     quest = 69859,
--     rewards = {
--         Achievement({id = 16679, criteria = 56150}),
--     }
-- }) -- Sandana the Tempest

map.nodes[47207895] = Rare({ -- review -- reqiured 67030
    id = 193258,
    quest = 69886,
    rewards = {Achievement({id = 16679, criteria = 56144})},
    pois = {
        Path({
            48897782, 48557735, 48407739, 47977782, 47177827, 47307994,
            47998002, 48277973, 49507949, 49947917
        })
    }
}) -- Tempestrian

map.nodes[38466826] = Rare({
    id = 191305,
    quest = 72121,
    rewards = {Achievement({id = 16679, criteria = 56155})}
}) -- The Great Shellkhan

-- map.nodes[] = Rare({
--     id = 183984,
--     quest = 65365,
--     rewards = {
--         Achievement({id = 16679, criteria = 56153}),
--     }
-- }) -- The Weeping Vilomah

map.nodes[35027001] = Rare({ -- reqiured 67030 review
    id = 193146,
    quest = 70947,
    rewards = {Achievement({id = 16679, criteria = 56146})}
}) -- Treasure-Mad Trambladd

-- map.nodes[] = Rare({
--     id = 193161,
--     quest = 69850,
--     rewards = {
--         Achievement({id = 16679, criteria = 56152}),
--     }
-- }) -- Woolfang

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

-- https://www.wowhead.com/beta/achievement=16301/treasures-of-thaldraszus#comments

map.nodes[49436289] = Treasure({
    quest = 70611,
    note = L['acorn_harvester_note'],
    rewards = {
        Achievement({id = 16301, criteria = 54815}),
        Pet({item = 193066, id = 3275}) -- Chestnut
    }
}) -- Acorn Harvester

map.nodes[78001400] = Treasure({ -- required 70407, 70408
    quest = nil,
    requires = ns.requirement.Item(198852), -- Bear Termination Orders
    rewards = {Achievement({id = 16301, criteria = 54812})}
}) -- Amber Gem Cluster

map.nodes[33967695] = Treasure({
    quest = 70607,
    note = L['cracked_hourglass_note'],
    requires = ns.requirement.Item(199068), -- Time-Lost Memo
    rewards = {Achievement({id = 16301, criteria = 54810})}
}) -- Cracked Hourglass

map.nodes[60244164] = Treasure({
    quest = 70609,
    rewards = {Achievement({id = 16301, criteria = 54813})}
}) -- Elegant Canvas Brush

map.nodes[58168007] = Treasure({ -- required 70538, 70608
    quest = 70608,
    note = L['sandy_wooden_duck_note'],
    requires = ns.requirement.Item(199069), -- Yennu's Map
    rewards = {Achievement({id = 16301, criteria = 54811})},
    pois = {POI({54937543})} -- Yennu's Map
}) -- Sandy Wooden Duck (Sand Pile)

map.nodes[64851655] = Treasure({
    quest = 70610,
    note = L['in_cave'],
    rewards = {Achievement({id = 16301, criteria = 54814})}
}) -- Surveyor's Magnifying Glass

-------------------------------------------------------------------------------

map.nodes[52458361] = Treasure({
    quest = 72355,
    label = '{npc:198604}',
    note = L['in_cave'],
    requires = ns.requirement.Profession(5, 186), -- Mining
    rewards = {
        Pet({item = 201463, id = 3415}) -- Cubbly
    }

}) -- Strange Bear Cub

-------------------------------------------------------------------------------
-------------------------------- DRAGON GLYPHS --------------------------------
-------------------------------------------------------------------------------

map.nodes[62414050] = Dragonglyph({rewards = {Achievement({id = 16104})}}) -- Dragon Glyphs: Algeth'ar Academy
map.nodes[49944032] = Dragonglyph({rewards = {Achievement({id = 16102})}}) -- Dragon Glyphs: Algeth'era
map.nodes[37639338] = Dragonglyph({rewards = {Achievement({id = 16673})}}) -- Dragon Glyphs: Fallen Course (Azure Span)
map.nodes[52676742] = Dragonglyph({rewards = {Achievement({id = 16666})}}) -- Dragon Glyphs: Gelikyr Overlook
map.nodes[55737225] = Dragonglyph({rewards = {Achievement({id = 16667})}}) -- Dragon Glyphs: Passage of Time
map.nodes[35608551] = Dragonglyph({rewards = {Achievement({id = 16100})}}) -- Dragon Glyphs: South Hold Gate
map.nodes[46107410] = Dragonglyph({rewards = {Achievement({id = 16099})}}) -- Dragon Glyphs: Stormshroud Peak
map.nodes[66108230] = Dragonglyph({rewards = {Achievement({id = 16098})}}) -- Dragon Glyphs: Temporal Conflux
map.nodes[72906921] = Dragonglyph({rewards = {Achievement({id = 16107})}}) -- Dragon Glyphs: Thaldrazsus Apex
map.nodes[61615661] = Dragonglyph({rewards = {Achievement({id = 16103})}}) -- Dragon Glyphs: Tyrhold
map.nodes[41285813] = Dragonglyph({
    parent = 2112,
    rewards = {Achievement({id = 16101})}
}) -- Dragon Glyphs: Valdrakken
map.nodes[72125131] = Dragonglyph({rewards = {Achievement({id = 16106})}}) -- Dragon Glyphs: Vault of the Incarnates
map.nodes[67121181] = Dragonglyph({rewards = {Achievement({id = 16105})}}) -- Dragon Glyphs: Veiled Ossuary

-------------------------------------------------------------------------------
------------------ DRAGONSCALE EXPEDITION: THE HIGHEST PEAKS ------------------
-------------------------------------------------------------------------------

map.nodes[34048484] = Flag({quest = 71222})
map.nodes[46107397] = Flag({quest = 70024})
map.nodes[50168163] = Flag({quest = 70039})
map.nodes[65727498] = Flag({quest = 71223})
map.nodes[66195378] = Flag({quest = 71224})

-------------------------------------------------------------------------------
------------------------------- DISTURBED DIRT --------------------------------
-------------------------------------------------------------------------------

map.nodes[38188192] = Disturbeddirt()
map.nodes[49894474] = Disturbeddirt()
map.nodes[55588459] = Disturbeddirt()
map.nodes[55756743] = Disturbeddirt()
map.nodes[55918384] = Disturbeddirt()
map.nodes[59532835] = Disturbeddirt()
map.nodes[62226638] = Disturbeddirt()

-------------------------------------------------------------------------------
-------------------------- EXPEDITION SCOUT'S PACKS ---------------------------
-------------------------------------------------------------------------------

map.nodes[37637740] = Scoutpack()
map.nodes[38796831] = Scoutpack()
map.nodes[38806831] = Scoutpack()
map.nodes[50844623] = Scoutpack()
map.nodes[52758333] = Scoutpack()
map.nodes[55456797] = Scoutpack()
map.nodes[55873598] = Scoutpack()

-------------------------------------------------------------------------------
--------------------------------- BATTLE PETS ---------------------------------
-------------------------------------------------------------------------------

map.nodes[39467359] = PetBattle({
    id = 197336,
    rewards = {Achievement({id = 16464, criteria = 55490})}
}) -- Enyobon

map.nodes[56274924] = PetBattle({
    id = 197350,
    rewards = {Achievement({id = 16464, criteria = 55493})}
}) -- Setimothes
