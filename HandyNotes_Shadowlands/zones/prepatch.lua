-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------
local ADDON_NAME, ns = ...
local L = ns.locale
local Map = ns.Map

local NPC = ns.node.NPC

local Achievement = ns.reward.Achievement
local Heirloom = ns.reward.Heirloom
local Spacer = ns.reward.Spacer
local Toy = ns.reward.Toy
local Transmog = ns.reward.Transmog

-------------------------------------------------------------------------------

local org = Map({id = 1})
local stw = Map({id = 84})

-------------------------------------------------------------------------------
----------------------------------- EVENTS ------------------------------------
-------------------------------------------------------------------------------

local TRINKET = Heirloom({item = 199686}) -- Unstable Elemental Confluence

local EARTH = {Achievement({id = 16431, criteria = 55368}), Spacer(), TRINKET}
local FIRE = {Achievement({id = 16431, criteria = 55369}), Spacer(), TRINKET}
local STORM = {Achievement({id = 16431, criteria = 55367}), Spacer(), TRINKET}
local WATER = {Achievement({id = 16431, criteria = 55370}), Spacer(), TRINKET}

local function RenderEventRewards(rewards)
    GameTooltip:AddLine(' ')
    for i, reward in ipairs(rewards) do
        if reward:IsEnabled() then reward:Render(GameTooltip) end
    end
    GameTooltip:Show()
end

local function AddRewardsToTooltip(atlasName)
    if atlasName then
        if atlasName:match('ElementalStorm%-%a+%-Earth') then
            RenderEventRewards(EARTH)
        elseif atlasName:match('ElementalStorm%-%a+%-Fire') then
            RenderEventRewards(FIRE)
        elseif atlasName:match('ElementalStorm%-%a+%-Air') then
            RenderEventRewards(STORM)
        elseif atlasName:match('ElementalStorm%-%a+%-Water') then
            RenderEventRewards(WATER)
        end
    end
end

-- Main event is shown with an AreaPOI
hooksecurefunc(AreaPOIPinMixin, 'TryShowTooltip', function(self)
    if self and self.areaPoiID then
        local mapID = self:GetMap().mapID
        local info = C_AreaPoiInfo.GetAreaPOIInfo(mapID, self.areaPoiID)
        if info and info.atlasName then
            AddRewardsToTooltip(info.atlasName)
        end
    end
end)

-- Auxilary locations are shown using Vignettes
-- hooksecurefunc(VignettePinMixin, 'OnMouseEnter', function(self)
--     if self and self.vignetteInfo and self.vignetteInfo.atlasName then
--         AddRewardsToTooltip(self.vignetteInfo.atlasName)
--     end
-- end)

-------------------------------------------------------------------------------
----------------------------------- VENDORS -----------------------------------
-------------------------------------------------------------------------------

local VENDOR_ITEMS = {
    Transmog({item = 199402, slot = L['crossbow']}), -- Galepiercer Ballista
    Transmog({item = 199416, slot = L['1h_axe']}), -- Galerider Crescent
    Transmog({item = 199406, slot = L['1h_mace']}), -- Galerider Mallet
    Transmog({item = 199399, slot = L['polearm']}), -- Galerider Poleaxe
    Transmog({item = 199407, slot = L['dagger']}), -- Galerider Shank
    Transmog({item = 199400, slot = L['2h_sword']}), -- Squallbreaker Greatsword
    Transmog({item = 199408, slot = L['1h_sword']}), -- Squallbreaker Longblade
    Transmog({item = 199404, slot = L['shield']}), -- Squallbreaker Shield
    Transmog({item = 199403, slot = L['1h_mace']}), -- Stormbender Maul
    Transmog({item = 199405, slot = L['staff']}), -- Stormbender Rod
    Transmog({item = 199409, slot = L['1h_sword']}), -- Stormbender Saber
    Transmog({item = 199401, slot = L['offhand']}), -- Stormbender Scroll
    Spacer(), --
    Transmog({item = 199351, slot = L['cloth']}), -- Cloudburst Hood
    Transmog({item = 199348, slot = L['cloth']}), -- Cloudburst Robes
    Transmog({item = 199352, slot = L['cloth']}), -- Cloudburst Breeches
    Transmog({item = 199353, slot = L['cloth']}), -- Cloudburst Mantle
    Transmog({item = 199349, slot = L['cloth']}), -- Cloudburst Slippers
    Transmog({item = 199350, slot = L['cloth']}), -- Cloudburst Mitts
    Transmog({item = 199354, slot = L['cloth']}), -- Cloudburst Sash
    Transmog({item = 199355, slot = L['cloth']}), -- Cloudburst Bindings
    Transmog({item = 199359, slot = L['leather']}), -- Dust Devil Mask
    Transmog({item = 199356, slot = L['leather']}), -- Dust Devil Raiment
    Transmog({item = 199360, slot = L['leather']}), -- Dust Devil Leggings
    Transmog({item = 199361, slot = L['leather']}), -- Dust Devil Epaulets
    Transmog({item = 199357, slot = L['leather']}), -- Dust Devil Treads
    Transmog({item = 199358, slot = L['leather']}), -- Dust Devil Gloves
    Transmog({item = 199362, slot = L['leather']}), -- Dust Devil Cincture
    Transmog({item = 199363, slot = L['leather']}), -- Dust Devil Wristbands
    Transmog({item = 199367, slot = L['mail']}), -- Cyclonic Cowl
    Transmog({item = 199364, slot = L['mail']}), -- Cyclonic Chainmail
    Transmog({item = 199368, slot = L['mail']}), -- Cyclonic Kilt
    Transmog({item = 199369, slot = L['mail']}), -- Cyclonic Spaulders
    Transmog({item = 199365, slot = L['mail']}), -- Cyclonic Striders
    Transmog({item = 199366, slot = L['mail']}), -- Cyclonic Gauntlets
    Transmog({item = 199370, slot = L['mail']}), -- Cyclonic Cinch
    Transmog({item = 199371, slot = L['mail']}), -- Cyclonic Bracers
    Transmog({item = 199375, slot = L['plate']}), -- Firestorm Greathelm
    Transmog({item = 199372, slot = L['plate']}), -- Firestorm Chestplate
    Transmog({item = 199376, slot = L['plate']}), -- Firestorm Greaves
    Transmog({item = 199377, slot = L['plate']}), -- Firestorm Pauldrons
    Transmog({item = 199373, slot = L['plate']}), -- Firestorm Stompers
    Transmog({item = 199374, slot = L['plate']}), -- Firestorm Crushers
    Transmog({item = 199378, slot = L['plate']}), -- Firestorm Girdle
    Transmog({item = 199379, slot = L['plate']}), -- Firestorm Vambraces
    Transmog({item = 199384, slot = L['cloak']}), -- Cloudburst Wrap
    Transmog({item = 199385, slot = L['cloak']}), -- Dust Devil Cloak
    Transmog({item = 199380, slot = L['cloak']}), -- Cyclonic Drape
    Transmog({item = 199386, slot = L['cloak']}), -- Firestorm Cape
    Spacer(), --
    Toy({item = 199337}) -- Bag of Furious Winds
}

stw.nodes[36874340] = NPC({
    id = 195912,
    icon = 237016,
    parent = {13, 37}, -- Elwynn Forest, EK
    note = L['prepatch_vendor_note'],
    faction = 'Alliance',
    rewards = VENDOR_ITEMS
}) -- Storm Hunter William

org.nodes[55941231] = NPC({
    id = 195899,
    icon = 237016,
    parent = 12, -- Kalimdor
    note = L['prepatch_vendor_note'],
    faction = 'Horde',
    rewards = VENDOR_ITEMS
}) -- Storm Huntress Suhrakka

-------------------------------------------------------------------------------

-- This is a hack to raise the frame level of these vendor pins. Otherwise they
-- have trouble rendering their tooltips on hover when competing against the
-- nearby city and zeppelin icons.

hooksecurefunc(HandyNotesWorldMapPinMixin, 'OnAcquired', function(self, ...)
    if self.texture:GetTexture() == 237016 then
        self:UseFrameLevelType('PIN_FRAME_LEVEL_WAYPOINT_LOCATION')
    else
        self:UseFrameLevelType('PIN_FRAME_LEVEL_AREA_POI')
    end
end)
