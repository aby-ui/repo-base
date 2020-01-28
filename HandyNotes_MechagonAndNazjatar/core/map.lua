-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...
local Class = ns.Class

-------------------------------------------------------------------------------
------------------------------------- MAP -------------------------------------
-------------------------------------------------------------------------------

local Map = Class('Map')

Map.id = 0

function Map:init ()
    self.nodes = {}
end

function Map:prepare () end

function Map:enabled (node, coord, minimap)
    local db = ns.addon.db

    -- Check if we've been hidden by the user
    if db.char[self.id..'_coord_'..coord] then return false end

    return node:enabled(self, coord, minimap)
end

-------------------------------------------------------------------------------

ns.Map = Map
