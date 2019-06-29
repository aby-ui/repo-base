local addon = select(2, ...)
local D, _, P = addon.getLocalVars()

local dataMineTooltipName = ("%sDatamineTooltip"):format(addon.name)
local dataMineTooltip = _G.CreateFrame("GameTooltip", dataMineTooltipName, UIParent, "GameTooltipTemplate")
local dataMineTitleText = _G[("%sDatamineTooltipTextLeft1"):format(addon.name)]

local isCreatureNamesLoaded, getRareNameByCreatureID

function addon.getRareNameByCreatureID(creatureID)
    local creature = D["Creatures"][creatureID]
    if (not creature) then return end
    if (not D["Creatures"][creatureID]["Name"]) then
        dataMineTooltip:SetOwner(UIParent, "ANCHOR_NONE")
        dataMineTooltip:SetHyperlink(("unit:Creature-0-0-0-0-%d"):format(creatureID))
        local name = dataMineTitleText:GetText()
        if (name) then
            creature["Name"] = name
            return name
        end
        return
    end
    return creature["Name"]
end

function isCreatureNamesLoaded()
    if(addon.creatureNamesLoaded) then return true end
    for _, creature in pairs(D["Creatures"].records) do
        if (not creature["Name"]) then
            return false
        end
    end
    addon.creatureNamesLoaded = true
    return true
end

function addon.loadCreatureNames()
    for k in pairs(D["Creatures"].records) do
        addon.getRareNameByCreatureID(k)
    end
    return isCreatureNamesLoaded()
end

addon.loadCreatureNames()

local function CreaturesName_AfterUpdate(record)
    if (record["Vignette Info"]) then
        record["Vignette Info"].name = record["Name"]
        for mapcanvas in pairs(D["Map Canvases"]) do
            if (mapcanvas:GetMapID() == P["Vignette MapID"]) then
                mapcanvas:OnEvent("VIGNETTES_UPDATED")
            end
        end
    end
end

D["Creatures"]:SetAfterUpdate("Name", CreaturesName_AfterUpdate)
