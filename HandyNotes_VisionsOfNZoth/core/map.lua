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
Map.intro = nil
Map.phased = true

function Map:init ()
    self.nodes = {}
end

function Map:prepare ()
    for coord, node in pairs(self.nodes) do
        ns.NameResolver:Prepare(node.label)
    end
end

function Map:enabled (node, coord, minimap)
    local db = ns.addon.db

    -- Check if the zone is still phased
    if node ~= self.intro and not self.phased then return false end

    -- Check if we've been hidden by the user
    if db.char[self.id..'_coord_'..coord] then return false end

    -- Check minimap, faction and quest completion
    if not node:enabled(self, coord, minimap) then return false end

    return true
end

-------------------------------------------------------------------------------
---------------------------- MINIMAP DATA PROVIDER ----------------------------
-------------------------------------------------------------------------------

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")
local MinimapPinsKey = ADDON_NAME.."MinimapPins"
local MinimapDataProvider = CreateFrame("Frame", ADDON_NAME.."MinimapDP")

MinimapDataProvider.facing = GetPlayerFacing()
MinimapDataProvider.indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
MinimapDataProvider.pins = {}
MinimapDataProvider.pool = {}

-- The HBD author has already figured out the scale values for each zoom level
MinimapDataProvider.scales = {
    indoor = {1, 1.25, 5/3, 2.5, 3.75, 6},
    outdoor = {1, 7/6, 1.4, 1.75, 7/3, 3.5}
}

-- These values for width/height seem to render the minimap POIs correctly. I
-- still haven't figured out how to get these values out of the API, these were
-- manually found by tweaking values at a 1.5 width/height ratio until things
-- looked right =/.
MinimapDataProvider.sizes = {
    [1527] = {1750, 1312},   -- Uldum
    [1530] = {700, 466}     -- Vale
}

function MinimapDataProvider:ReleasePin(pin)
    pin:Hide()
    self.pool[pin] = true
end

function MinimapDataProvider:ReleaseAllPins()
    for i, pin in ipairs(self.pins) do
        self:ReleasePin(pin)
    end
end

function MinimapDataProvider:AcquirePin(mapID, poi, ...)
    local pin = next(self.pool)
    if pin then
        self.pool[pin] = nil -- remove it from the pool
    else
        pin = self:CreatePin()
    end

    local scale = self.scales[self.indoors][Minimap:GetZoom()+1]
    local sizes = self.sizes[mapID] or {750, 500}
    pin.parentWidth = sizes[1] * scale
    pin.parentHeight = sizes[2] * scale

    local x, y = poi:draw(pin, ...)
    if GetCVar('rotateMinimap') == '1' then
        pin.texture:SetRotation(pin.texture:GetRotation() + math.pi*2 - self.facing)
    end
    HBDPins:AddMinimapIconMap(MinimapPinsKey, pin, mapID, x, y, true)
end

function MinimapDataProvider:CreatePin()
    local name = ADDON_NAME.."Pin"..(#self.pins + 1)
    local pin = CreateFrame("Button", name, Minimap)
    local texture = pin:CreateTexture(nil, "OVERLAY")
    pin:SetFrameLevel(Minimap:GetFrameLevel() + 3)
    pin:SetFrameStrata(Minimap:GetFrameStrata())
    pin:SetParent(Minimap)
    pin:SetWidth(12)
    pin:SetHeight(12)
    pin.minimap = true
    pin.texture = texture
    texture:SetAllPoints(pin)
    texture:SetTexelSnappingBias(0)
    texture:SetSnapToPixelGrid(false)
    pin:Hide()
    self.pins[#self.pins + 1] = pin
    return pin
end

function MinimapDataProvider:RefreshAllData()
    self.lastRefresh = GetTime()
    HBDPins:RemoveAllMinimapIcons(MinimapPinsKey)
    self:ReleaseAllPins()

    local map = ns.maps[HBD:GetPlayerZone()]
    if not map then return end

    for coord, node in pairs(map.nodes) do
        if (node._focus or node._hover) and map:enabled(node, coord, true) then
            for i, poi in ipairs(node.pois or {}) do
                poi:render(self, map.id)
            end
        end
    end
end

function MinimapDataProvider:OnUpdate()
    local facing = GetPlayerFacing()
    if facing ~= self.facing then
        if GetCVar('rotateMinimap') == '1' then
            self:RefreshAllData()
        end
        self.facing = facing
    end
end

MinimapDataProvider:SetScript('OnUpdate', function ()
    MinimapDataProvider:OnUpdate()
end)

ns.addon:RegisterEvent('MINIMAP_UPDATE_ZOOM', function (...)
    local zoom = Minimap:GetZoom()
    if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
        Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
    end
    MinimapDataProvider.indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
    Minimap:SetZoom(zoom)
end)

hooksecurefunc(Minimap, "SetZoom", function ()
    MinimapDataProvider:RefreshAllData()
end)

-------------------------------------------------------------------------------
--------------------------- WORLD MAP DATA PROVIDER ---------------------------
-------------------------------------------------------------------------------

local WorldMapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin)
local WorldMapPinTemplate = ADDON_NAME..'WorldMapPinTemplate'
local WorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin)

_G[ADDON_NAME..'WorldMapPinMixin'] = WorldMapPinMixin

function WorldMapDataProvider:RemoveAllData()
    if self:GetMap() then
        self:GetMap():RemoveAllPinsByTemplate(WorldMapPinTemplate)
    end
end

function WorldMapDataProvider:RefreshAllData(fromOnShow)
    self:RemoveAllData()

    if not self:GetMap() then return end
    local map = ns.maps[self:GetMap():GetMapID()]
    if not map then return end

    for coord, node in pairs(map.nodes) do
        if (node._focus or node._hover) and map:enabled(node, coord, false) then
            for i, poi in ipairs(node.pois or {}) do
                poi:render(self:GetMap(), WorldMapPinTemplate)
            end
        end
    end
end

function WorldMapPinMixin:OnLoad()
    -- The MAP_HIGHLIGHT frame level is well below the level standard
    -- HandyNotes pins use, preventing mouseover conflicts
    self:UseFrameLevelType("PIN_FRAME_LEVEL_MAP_HIGHLIGHT")
end

function WorldMapPinMixin:OnAcquired(poi, ...)
    local l, b, w, h = self:GetParent():GetRect()
    self.parentWidth = w
    self.parentHeight = h
    if (w and h) then
        local x, y = poi:draw(self, ...)
        self:SetPosition(x, y)
    end
end

-------------------------------------------------------------------------------
------------------------------ HANDYNOTES HOOKS -------------------------------
-------------------------------------------------------------------------------

-- HandyNotes removes its data provider from the world map when the global
-- enable/disable checkbox is toggled at the top of its UI window. We need
-- to do the same thing here or our paths will still display.

local OnEnable = HandyNotes.OnEnable
local OnDisable = HandyNotes.OnDisable

function HandyNotes:OnEnable()
    OnEnable(self)
    if not HandyNotes.db.profile.enabled then return end
    WorldMapFrame:AddDataProvider(WorldMapDataProvider)
end

function HandyNotes:OnDisable()
    OnDisable(self)
    if WorldMapFrame.dataProviders[WorldMapDataProvider] then
        WorldMapFrame:RemoveDataProvider(WorldMapDataProvider)
    end
end

-------------------------------------------------------------------------------

ns.Map = Map
ns.MinimapDataProvider = MinimapDataProvider
ns.WorldMapDataProvider = WorldMapDataProvider
