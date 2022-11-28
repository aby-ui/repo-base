-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...

local L = ns.locale
local Map = ns.Map

local Rare = ns.node.Rare
local Treasure = ns.node.Treasure

local Item = ns.reward.Item

local Path = ns.poi.Path
local POI = ns.poi.POI

-------------------------------------------------------------------------------

local map = Map({id = 2118, settings = true})
local creche = Map({id = 2109, settings = false})

-------------------------------------------------------------------------------
------------------------------------ RARES ------------------------------------
-------------------------------------------------------------------------------

map.nodes[32914104] = Rare({
    id = 191729,
    note = L['in_small_cave'],
    quest = 66966,
    rewards = {
        Item({item = 197725, note = L['ring']}) -- Deathrip's Curied Claw
    },
    pois = {POI({33724344})} -- Entrance
}) -- Deathrip

map.nodes[28473653] = Rare({
    id = 191713,
    note = L['in_small_cave'],
    quest = 66967,
    rewards = {
        Item({item = 196435, note = L['neck']}) -- Scytherin's Barbed Necklace
    },
    pois = {POI({33653370})} -- Entrance
}) -- Scytherin

map.nodes[54964307] = Rare({id = 181427, quest = 64859}) -- Stormspine

map.nodes[56496548] = Rare({id = 191746, quest = 66975}) -- Ketess the Pillager

-------------------------------------------------------------------------------
---------------------------------- TREASURES ----------------------------------
-------------------------------------------------------------------------------

map.nodes[42043442] = Treasure({
    label = L['bag_of_enchanted_wind'],
    note = L['bag_of_enchanted_wind_note'],
    quest = 65909,
    rewards = {
        Item({item = 193840}) -- Bag of Enchanted Winds
    },
    pois = ({
        Path({
            41353512, 41163475, 41653383, 42133318, 42823238, 42333126,
            41733062, 41123049, 40663090
        })
    })
}) -- Bag of Enchanted Wind

map.nodes[41772301] = Treasure({
    label = '{npc:191992}',
    note = L['in_small_cave'],
    quest = 67013,
    rewards = {
        Item({item = 194511}) -- Living Ration
    }
}) -- Lost Draconic Hourglass

map.nodes[35576977] = Treasure({
    label = L['hessethiash_treasure'],
    note = L['in_small_cave'],
    quest = 66876,
    rewards = {
        Item({item = 195885, note = L['cloak']}) -- Black Dragon's Scale Cloak
    }
}) -- Hessethiash's Poorly Hidden Treasure

map.nodes[30536442] = Treasure({
    label = L['lost_draconic_hourglass'],
    quest = 66974
}) -- Lost Draconic Hourglass

creche.nodes[38297451] = Treasure({
    label = L['mysterious_wand'],
    note = L['mysterious_wand_note'],
    quest = 66010,
    rewards = {
        Item({item = 193861}) -- Blue Magic Wand
    },
    pois = {POI({35887398})} -- Entrance
}) -- Mysterious Wand
