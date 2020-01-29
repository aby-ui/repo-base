-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local L = ns.locale

local Map = ns.Map
local Node = ns.node.Node
local Rare = ns.node.Rare
local Mount = ns.reward.Mount
local Toy = ns.reward.Toy
local Path = ns.poi.Path

local options = ns.options.args.VisibilityGroup.args
local defaults = ns.optionDefaults.profile

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local orgrimmar = Map({ id=1469 })

function orgrimmar:enabled (node, coord, minimap)
    if not Map.enabled(self, node, coord, minimap) then return false end
    return ns.addon.db.profile.misc_visions
end

local stormwind = Map({ id=1470 })

function stormwind:enabled (node, coord, minimap)
    if not Map.enabled(self, node, coord, minimap) then return false end
    return ns.addon.db.profile.misc_visions
end

-------------------------------------------------------------------------------
----------------------------------- OPTIONS -----------------------------------
-------------------------------------------------------------------------------

defaults['misc_visions'] = true

options.groupVisions = {
    type = "header",
    name = L["horrific_visions"],
    order = 20,
}

options.mailVisions = {
    type = "toggle",
    arg = "misc_visions",
    name = L["options_toggle_misc"],
    desc = L["options_toggle_visions_desc"],
    order = 21,
    width = "normal",
}

-------------------------------------------------------------------------------

local MAIL = Node({icon=133468, label=L["mailbox"], rewards={
    Mount({id=1315, item=174653}) -- Mail Muncher
}, note=L["mail_muncher"]})

-------------------------------------------------------------------------------
---------------------------------- ORGRIMMAR ----------------------------------
-------------------------------------------------------------------------------

orgrimmar.nodes[39304900] = MAIL
orgrimmar.nodes[39708030] = MAIL
orgrimmar.nodes[52707580] = MAIL
orgrimmar.nodes[60105130] = MAIL

orgrimmar.nodes[39906120] = Node({icon=1001616, label=L["shave_kit"], note=L["shave_kit_note"], rewards={
    Toy({item=174920}) -- Coifcurl's Close Shave Kit
}})

-------------------------------------------------------------------------------
---------------------------------- STORMWIND ----------------------------------
-------------------------------------------------------------------------------

stormwind.nodes[49688700] = MAIL
stormwind.nodes[54645752] = MAIL
stormwind.nodes[61687604] = MAIL
stormwind.nodes[62073082] = MAIL
stormwind.nodes[76306430] = MAIL

stormwind.nodes[58905290] = Node({icon=237272, label=L["void_skull"], note=L["void_skull_note"], rewards={
    Toy({item=174921}) -- Void-Touched Skull
}})

stormwind.nodes[59106390] = Rare({id=158284, pois={
    Path({
        58707630, 57507290, 56406950, 56706670, 59106390, 62306130, 64706190,
        67006490, 68406710
    })
}, rewards={
    Toy({item=174926}) -- Overly Sensitive Void Spectacles
}}) -- Craggle Wobbletop

-------------------------------------------------------------------------------

ns.maps[orgrimmar.id] = orgrimmar
ns.maps[stormwind.id] = stormwind
