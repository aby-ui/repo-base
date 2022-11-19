

local Details = _G.Details
local addonName, Details222 = ...

--namespace
Details.CurrentDps = {
    Dps = {},
    Hps = {},
}

local currentDpsFrame = CreateFrame("frame", "DetailsCurrentDpsUpdaterFrame", UIParent)
local delayTimeBetweenUpdates = 0.10
local currentDelay = 0
local cacheSize = 40 --4 seconds of data
local dpsTime = delayTimeBetweenUpdates * cacheSize
local cacheOverflowIndex = cacheSize + 1

currentDpsFrame.OnUpdateFunc = function(self, deltaTime)
    currentDelay = currentDelay + deltaTime
    if (currentDelay < delayTimeBetweenUpdates) then
        return
    end

    local combatObject = Details.CurrentDps.CombatObject

    local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
    for index, actorObject in damageContainer:ListActors() do
        if (actorObject:IsPlayer()) then
            local actorTable = Details.CurrentDps.Dps[actorObject.serial]
            if (not actorTable) then
                actorTable = {
                    totalDamage = 0, --hold a sum of all dps done in the latest #cacheSize delayed OnUpdate ticks
                    currentDps = 0,
                    latestDamageAmount = 0,
                    cache = {},
                }
                Details.CurrentDps.Dps[actorObject.serial] = actorTable
            end

            --get the damage done on this tick
            local totalDamageThisTick = actorObject.total - actorTable.latestDamageAmount
            --add the damage to the cache
            tinsert(actorTable.cache, 1, totalDamageThisTick)
            --set the latest damage amount
            actorTable.latestDamageAmount = actorObject.total
            --sum the total damage the actor inflicted
            actorTable.totalDamage = actorTable.totalDamage + totalDamageThisTick

            --cut the damage
            local damageRemoved = tremove(actorTable.cache, cacheOverflowIndex)
            if (damageRemoved) then
                actorTable.totalDamage = actorTable.totalDamage - damageRemoved
                actorTable.totalDamage = max(0, actorTable.totalDamage) --safe guard
            end

            actorTable.currentDps = actorTable.totalDamage / dpsTime
            if (actorObject.nome == "Ditador") then
                local formatToKFunc = Details:GetCurrentToKFunction()
                print(actorTable.totalDamage, #actorTable.cache, dpsTime, formatToKFunc(nil, actorTable.currentDps))
            end

            if (actorObject.nome == "Ditador") then
                --print("Dps:", actorTable.currentDps)
            end
        end
    end

    currentDelay = 0
end

--start the proccess of updating the current dps and hps for each player
function Details.CurrentDps.StartCurrentDpsTracker()
    Details.CurrentDps.CombatObject = Details:GetCurrentCombat()
    wipe(Details.CurrentDps.Dps)
    wipe(Details.CurrentDps.Hps)
    currentDpsFrame:SetScript("OnUpdate", currentDpsFrame.OnUpdateFunc)
end
--stop what the function above started
function Details.CurrentDps.StopCurrentDpsTracker()
    currentDpsFrame:SetScript("OnUpdate", nil)
end

--serial = guid
function Details.CurrentDps.GetCurrentDps(serial)
    local actorTable = Details.CurrentDps.Dps[serial]
    if (actorTable) then
        local currentDps = actorTable.currentDps
        local formatToKFunc = Details:GetCurrentToKFunction()
        return formatToKFunc(nil, currentDps)
    end
end

--handle internal details! events
local eventListener = Details:CreateEventListener()
eventListener:RegisterEvent("COMBAT_PLAYER_ENTER", function()
	--Details.CurrentDps.StartCurrentDpsTracker()
end)
eventListener:RegisterEvent("COMBAT_PLAYER_LEAVE", function()
	--Details.CurrentDps.StopCurrentDpsTracker()
end)
