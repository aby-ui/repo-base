-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale

local Map = ns.Map
local NPC = ns.node.NPC
local Mount = ns.reward.Mount
local POI = ns.poi.POI

local options = ns.options.args.VisibilityGroup.args
local defaults = ns.optionDefaults.profile

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local map = Map({ id=864 })
local nodes = map.nodes

function map:enabled (node, coord, minimap)
    if not Map.enabled(self, node, coord, minimap) then return false end

    local profile = ns.addon.db.profile
    if node.alpaca then return profile.alpaca_voldun end

    return true
end

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

defaults['alpaca_voldun'] = true

options.groupVoldun = {
    type = "header",
    name = L["voldun"],
    order = 30,
}

options.alpacaVoldun = {
    type = "toggle",
    arg = "alpaca_voldun",
    name = L["options_toggle_alpaca_voldun"],
    desc = L["options_toggle_alpaca_voldun_desc"],
    order = 31,
    width = "normal",
}

-------------------------------------------------------------------------------
------------------------------ ELUSIVE QUICKHOOF ------------------------------
-------------------------------------------------------------------------------

nodes[43006900] = NPC({id=162681, icon=2916283, alpaca=true, pois={
    POI({
        26405250, 29006600, 31106730, 42006000, 43006900, 51108590, 52508900,
        54008200, 54605320, 55007300
    })
}, rewards={
    Mount({id=1324, item=174860}) -- Elusive Quickhoof
}, note=L["elusive_alpaca"]})

-------------------------------------------------------------------------------

ns.maps[map.id] = map
