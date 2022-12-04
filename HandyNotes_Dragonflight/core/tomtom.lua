-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local _, ns = ...

-------------------------------------------------------------------------------
----------------------------------- TOM TOM -----------------------------------
-------------------------------------------------------------------------------

local function AddSingleWaypoint(node, mapID, coord)
    local x, y = HandyNotes:getXY(coord)
    TomTom:AddWaypoint(mapID, x, y, {
        title = ns.RenderLinks(node.label, true),
        from = ns.plugin_name,
        persistent = nil,
        minimap = true,
        world = true
    })
end

local function AddGroupWaypoints(node, mapID, coord)
    local map = ns.maps[mapID]
    for peerCoord, peerNode in pairs(map.nodes) do
        if peerNode.group == node.group and peerNode:IsEnabled() then
            AddSingleWaypoint(peerNode, mapID, peerCoord)
        end
    end
end

ns.tomtom = {
    AddSingleWaypoint = AddSingleWaypoint,
    AddGroupWaypoints = AddGroupWaypoints
}
