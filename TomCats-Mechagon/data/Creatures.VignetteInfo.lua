local addon = select(2, ...)
local D, _, P = addon.getLocalVars()
D["Creatures by Vignette GUID"] = { }
local creaturesByVignetteGUID = D["Creatures by Vignette GUID"]
D["Creatures by Vignette ID"] = { }
local creaturesByVignetteID = D["Creatures by Vignette ID"]

local vignetteTemplate = {
    hasTooltip = true,
    inFogOfWar = false,
    isDead = false,
    isUnique = true,
    rewardQuestID = 0,
    type = 0,
}

function addon.addOrUpdateVignetteInfo(creature)
    if (creature["Vignette ID"]) then
        if (not creaturesByVignetteID[creature["Vignette ID"]]) then
            creaturesByVignetteID[creature["Vignette ID"]] = creature
        end
        --noinspection UnusedDef
        local STATUS = addon.STATUS
        local vignetteInfo = creature["Vignette Info"] or CreateFromMixins(vignetteTemplate, {
            vignetteID = creature["Vignette ID"],
            name = creature["Name"],
            ("Creature-0-0-0-0-%d"):format(creature["Creature ID"])
        })
        if (creature["Vignette Info"] == vignetteInfo) then
            vignetteInfo = CreateFromMixins(vignetteInfo)
        end
        -- remove old vignette GUID if it exists
        if (vignetteInfo.vignetteGUID) then
            creaturesByVignetteGUID[vignetteInfo.vignetteGUID] = nil
        end
        -- create a new vignette GUID
        vignetteInfo.vignetteGUID = ("Vignette-%s"):format(addon.TomCatsLibs.UUID.getUUID())
        creaturesByVignetteGUID[vignetteInfo.vignetteGUID] = creature
        local status = creature["Status"]
        if (status == STATUS.HIDDEN or status == STATUS.UNAVAILABE) then
            vignetteInfo.onMinimap = false
            vignetteInfo.onWorldMap = false
        else
            vignetteInfo.onMinimap = true
            vignetteInfo.onWorldMap = true
            if (status == STATUS.LOOT_ELIGIBLE) then
                vignetteInfo.atlasName = "VignetteKill"
            else
                vignetteInfo.atlasName = "Capacitance-General-WorkOrderCheckmark"
            end
        end
        creature["Vignette Info"] = vignetteInfo
    end
end

for _, creature in pairs(D.Creatures.records) do
    addon.addOrUpdateVignetteInfo(creature)
end

local function CreaturesVignetteInfo_AfterUpdate()
    for mapcanvas in pairs(D["Map Canvases"]) do
        if (mapcanvas:GetMapID() == P["Vignette MapID"]) then
            mapcanvas:OnEvent("VIGNETTES_UPDATED")
        end
    end
end

D["Creatures"]:SetAfterUpdate("Vignette Info", CreaturesVignetteInfo_AfterUpdate)
