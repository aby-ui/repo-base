local addon = select(2,...)
local D = addon.TomCatsLibs.Data
local PlayerFaction = UnitFactionGroup("player")
addon.params = {
    ["Vignette MapID"] = 62,
    ["Map Name"] = "黑海岸",
    ["Timer Delay"] = 5,
    ["Minimap Icon"] = "darnassus-icon",
    ["Icon BGColor"] = {68/255,34/255,68/255,0.80 },
    ["Title Line 1"] = "黑海岸稀有精英",
    ["Title Line 2"] = "战争前线-黑海岸"
}

-- If ACP is enabled, conditionally hook GetAddOnInfo to set the short name to be displayed in the ACP Group By Name control panel
local _, _, _, ACP_ENABLED = GetAddOnInfo("ACP")
if (ACP_ENABLED) then
    local func = GetAddOnInfo
    --noinspection GlobalCreationOutsideO
    function GetAddOnInfo(indexOrName)
        local addonInfo = { func(indexOrName) }
        --TODO: Make compatible with other locales: Group By Name, and title value
        if ((addonInfo[1] == addon.name) and (ACP_Data) and (ACP_Data.sorter == "Group By Name")) then
            addonInfo[2] = "Rares of Darkshore / Warfront on Darkshore"
        end
        return unpack(addonInfo)
    end
end

function addon.getLocalVars()
    return addon.TomCatsLibs.Data, addon.TomCatsLibs.Locales, addon.params
end

addon.playerFaction = UnitFactionGroup("player")
if (addon.playerFaction == "Horde") then
    addon.enemyFaction, addon.embassyContinentMapID = "Alliance", 875
else
    addon.enemyFaction, addon.embassyContinentMapID = "Horde", 876
end

function addon.getWarfrontPhase()
    local contributionCollectorID = D.ContributionCollectorIDs[PlayerFaction]
    local state = C_ContributionCollector.GetState(contributionCollectorID)
    if (state <= 2) then
        return addon.enemyFaction
    else
        return addon.playerFaction
    end
end

addon.TomCatsLibs.Data["Map Canvases"] = {}
local MapCanvasMixinOnEvent_ORIG = MapCanvasMixin.OnEvent

function MapCanvasMixin:OnEvent(...)
    MapCanvasMixinOnEvent_ORIG(self, ...)
    addon.TomCatsLibs.Data["Map Canvases"][self] = true
end
