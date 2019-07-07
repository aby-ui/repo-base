local addon = select(2,...)
local D = addon.TomCatsLibs.Data
local PlayerFaction = UnitFactionGroup("player")
addon.params = {
    ["Vignette MapID"] = 1462,
    ["Map Name"] = "麦卡贡",
    ["Timer Delay"] = 5,
    -- todo: Create Rares of Mechagon icon
    ["Minimap Icon"] = "mechagon-icon",
    ["Icon BGColor"] = {118/255,18/255,20/255,0.80 },
    ["Title Line 1"] = "麦卡贡稀有精英",
    ["Title Line 2"] = ""
}
addon.rareAchievements = { 13470 } --abyui

-- If ACP is enabled, conditionally hook GetAddOnInfo to set the short name to be displayed in the ACP Group By Name control panel
local _, _, _, ACP_ENABLED = GetAddOnInfo("ACP")
if (ACP_ENABLED) then
    local func = GetAddOnInfo
    --noinspection GlobalCreationOutsideO
    function GetAddOnInfo(indexOrName)
        local addonInfo = { func(indexOrName) }
        --TODO: Make compatible with other locales: Group By Name, and title value
        if ((addonInfo[1] == addon.name) and (ACP_Data) and (ACP_Data.sorter == "Group By Name")) then
            addonInfo[2] = "Rares of Mechagon"
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
