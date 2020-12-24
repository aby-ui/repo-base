
if (true) then
    --return
end

local Details = _G.Details
local bit = _G.bit
local DETAILS_ATTRIBUTE_DAMAGE = _G.DETAILS_ATTRIBUTE_DAMAGE
local DF = _G.DetailsFramework
local tonumber = _G.tonumber
local select = _G.select
local strsplit = _G.strsplit
local floor = _G.floor
local tremove = _G.tremove
local UnitName = _G.UnitName
local tinsert = _G.tinsert
local IsInRaid = _G.IsInRaid
local GetNumGroupMembers = _G.GetNumGroupMembers
local GetRaidRosterInfo = _G.GetRaidRosterInfo
local unpack = _G.unpack

Details.packFunctions = {}

--lookup actor information tables
local actorInformation = {}
local actorInformationIndexes = {}
local actorDamageInfo = {}
local actorHealInfo = {}

--flags
local REACTION_HOSTILE	=	0x00000040
local IS_GROUP_OBJECT 	= 	0x00000007
local REACTION_FRIENDLY	=	0x00000010
local OBJECT_TYPE_MASK =	0x0000FC00
local OBJECT_TYPE_OBJECT =	0x00004000
local OBJECT_TYPE_PETGUARDIAN =	0x00003000
local OBJECT_TYPE_GUARDIAN =	0x00002000
local OBJECT_TYPE_PET =		0x00001000
local OBJECT_TYPE_NPC =		0x00000800
local OBJECT_TYPE_PLAYER =	0x00000400

local INDEX_EXPORT_FLAG = 1
local INDEX_COMBAT_START_TIME = 2
local INDEX_COMBAT_END_TIME = 3
local INDEX_COMBAT_START_DATE = 4
local INDEX_COMBAT_END_DATE = 5
local INDEX_COMBAT_NAME = 6

local TOTAL_INDEXES_FOR_COMBAT_INFORMATION = 6

local entitySerialCounter = 0

local isDebugging = false

function Details.packFunctions.GetAllData()
    local combat = Details:GetCurrentCombat()
    local packedData = Details.packFunctions.PackCombatData(combat, 0x13)
    return packedData
end

--debug
function Details.packFunctions.GetAllDataDebug()
    local combat = Details:GetCurrentCombat()
    local packedData = Details.packFunctions.PackCombatData(combat, 0x13)

    --unpack data
    Details.packFunctions.DeployPackedCombatData(packedData)
end

--pack the combat
function Details.packFunctions.PackCombatData(combatObject, flags)

    --0x1 damage
    --0x2 healing
    --0x4 energy
    --0x8 misc
    --0x10 no combat header

    table.wipe(actorInformation)
    table.wipe(actorInformationIndexes)
    table.wipe(actorDamageInfo)
    table.wipe(actorHealInfo)

    --reset the serial counter
    entitySerialCounter = 0

    local isBossEncouter = combatObject.is_boss
    local startDate, endDate = combatObject:GetDate()

    local startCombatTime = combatObject:GetStartTime() or 0
    local endCombatTime = combatObject:GetEndTime() or 0
    local combatInfo = {
        floor(startCombatTime), --1
        floor(endCombatTime), --2
        startDate, --3
        endDate, --4
        isBossEncouter and isBossEncouter.encounter or "Unknown Enemy" --5
    }

    --if there's no combat information, indexes for combat data is zero
    if (bit.band(flags, 0x10) ~= 0) then
        TOTAL_INDEXES_FOR_COMBAT_INFORMATION = 0
    end

    if (bit.band(flags, 0x1) ~= 0) then
        Details.packFunctions.PackDamage(combatObject)
    end

    if (bit.band(flags, 0x2) ~= 0 and false) then
        Details.packFunctions.PackHeal(combatObject)
    end

    --> prepare data to send over network
        local exportedString = flags .. ","

        --add the combat info
        if (bit.band(flags, 0x10) == 0) then
            for index, data in ipairs(combatInfo) do
                exportedString = exportedString .. data .. ","
            end
        end

        --add the actor references table
        for index, data in ipairs(actorInformation) do
            exportedString = exportedString .. data .. ","
        end

        --add the damage actors data
        if (bit.band(flags, 0x1) ~= 0) then
            exportedString = exportedString .. "!D" .. ","
            for index, data in ipairs(actorDamageInfo) do
                exportedString = exportedString .. data .. ","
            end
        end

        --add the heal actors data
        if (bit.band(flags, 0x2) ~= 0 and false) then
            exportedString = exportedString .. "!H" .. ","
            for index, data in ipairs(actorHealInfo) do
                exportedString = exportedString .. data .. ","
            end
        end

        --main stuff
        --print("finished export (debug):", exportedString) --debug
        --print("uncompressed (debug):", format("%.2f", #exportedString/1024), "KBytes")

--if true then return exportedString end

        if (isDebugging) then
            print(exportedString)
        end

        --Details:Dump({exportedString})

        --compress
        local LibDeflate = _G.LibStub:GetLibrary("LibDeflate")
        local dataCompressed = LibDeflate:CompressDeflate(exportedString, {level = 9})
        local dataEncoded = LibDeflate:EncodeForWoWAddonChannel(dataCompressed)

        --print("encoded for WowAddonChannel (debug):", format("%.2f", #dataEncoded/1024), "KBytes")

        return dataEncoded
end

function Details.packFunctions.GenerateSerialNumber()
    local serialNumber = entitySerialCounter
    entitySerialCounter = entitySerialCounter + 1
    return serialNumber
end

--[[
    actor flag IDs
    1: player friendly
    2: player enemy
    3: enemy npc pet
    4: enemy npc non-pet
    5: friendly npc pet
    6: friendly non-npc
    7: unknown entity type
]]

local packActorFlag = function(actor)
    if (actor.grupo) then
        --it's a player in the group
        return 1
    end

    local flag = actor.flag_original or 0

    --check hostility
    if (bit.band(flag, REACTION_HOSTILE) ~= 0) then
        --is hostile
        if (bit.band(flag, OBJECT_TYPE_PLAYER) == 0) then
            --isn't a player
            if (bit.band(flag, OBJECT_TYPE_PETGUARDIAN) ~= 0) then
                --is pet
                return 3
            else
                --is enemy npc
                return 4
            end
        else
            --is enemy player
            return 2
        end
    else
        --is friendly
        if (bit.band(flag, OBJECT_TYPE_PLAYER) == 0) then
            --is player
            return 1
        else
            --isn't a player
            if (bit.band(flag, OBJECT_TYPE_PETGUARDIAN) ~= 0) then
                --is friendly pet
                return 5
            else
                --is a friendly entity, most likely a npc
                return 6
            end
        end
    end

    return 7
end

local unpackActorFlag = function(flag)
    --convert to integer
    flag = tonumber(flag)

    if (flag == 1) then --player
        return 0x511

    elseif (flag == 2) then --enemy player
        return 0x548

    elseif (flag == 3) then --enemy pet with player or AI controller
        return 0x1A48

    elseif (flag == 4) then --enemy npc
        return 0xA48

    elseif (flag == 5) then --friendly pet
        return 0x1914

    elseif (flag == 6) then --friendly npc
        return 0xA14

    elseif (flag == 7) then --unknown entity
        return 0x4A28
    end
end

local isActorInGroup = function(class, flag)
    if (bit.band (flag, IS_GROUP_OBJECT) ~= 0 and class ~= "UNKNOW" and class ~= "UNGROUPPLAYER" and class ~= "PET") then
        return true
    end
    return false
end

--[[
    actor class IDs
    1-12: player class Id
    20: "PET"
    21: "UNKNOW"
    22: "UNGROUPPLAYER"
    23: "ENEMY"
    24: "MONSTER"
]]

local detailsClassIndexToFileName = {
    [20] = "PET",
    [21] = "UNKNOW",
    [22] = "UNGROUPPLAYER",
    [23] = "ENEMY",
    [24] = "MONSTER",
}

local packActorClass = function(actor)
    local classId = DF.ClassFileNameToIndex[actor.classe]
    if (classId) then
        return classId
    elseif (classId == "PET") then
        return 20
    elseif (classId == "UNKNOW") then
        return 21
    elseif (classId == "UNGROUPPLAYER") then
        return 22
    elseif (classId == "ENEMY") then
        return 23
    elseif (classId == "MONSTER") then
        return 24
    end

    return 21
end

local unpackActorClass = function(classId)
    --convert to integer
    classId = tonumber(classId)

    local classFileName = DF.ClassIndexToFileName[classId]
    if (not classFileName) then
        classFileName = detailsClassIndexToFileName[classId]
    end

    return classFileName
end

--[[
    actor serial
    creature: C12345 (numbers are the npcId)
    player: P
--]]

local packActorSerial = function(actor)
    local serial = actor.serial
    if (serial:match("^C") == "C") then
        local npcId = tonumber(select(6, strsplit("-", serial)) or 0)
        return "C" .. npcId

    elseif (serial:match("^P") == "P") then
        return "P"
    
    elseif (serial == "") then
        return "C12345"
    end
end

local unpackActorSerial = function(serialNumber)
    --player serial
    if (serialNumber:match("^P")) then
        return "Player-1-" .. Details.packFunctions.GenerateSerialNumber()

    elseif (serialNumber:match("^C")) then
        return "Creature-0-0-0-0-" .. serialNumber:gsub("C", "") .."-" .. Details.packFunctions.GenerateSerialNumber()
    end
end

function Details.packFunctions.AddActorInformation(actor)
    --the next index to use on the actor info table
    local currentIndex = #actorInformation + 1

    --calculate where this actor will be placed on the combatData table
    local indexOnCombatDataTable = TOTAL_INDEXES_FOR_COMBAT_INFORMATION + currentIndex + 1

    --add the actor start information index
    actorInformationIndexes[actor.nome] = indexOnCombatDataTable

    --index 1: actor name
    actorInformation[currentIndex] = actor.nome or "unnamed" --[1]

    --index 2: actor flag
    actorInformation[currentIndex + 1] = packActorFlag(actor) --[2]

    --index 3: actor serial
    actorInformation[currentIndex + 2] = packActorSerial(actor) or "" --[3]

    --index 4: actor class
    actorInformation[currentIndex + 3] = packActorClass(actor) --[4]

    --index 5: actor spec
    actorInformation[currentIndex + 4] = actor.spec or 0 --[5]

    return indexOnCombatDataTable
end

function Details.packFunctions.RetriveActorInformation(combatData, index)
    --name [1]
    local actorName = combatData[index]
    if (not actorName) then
        return
    end

    --flag [2]
    local actorFlag = combatData[index + 1]
    actorFlag = unpackActorFlag(actorFlag)

    --serial [3]
    local serialNumber = combatData[index + 2]
    serialNumber = unpackActorSerial(serialNumber)

    --class [4]
    local class = combatData[index + 3]
    class = unpackActorClass(class)

    --spec [5]
    local spec = tonumber(combatData[index + 4])

    --return the values
    return actorName, actorFlag, serialNumber, class, spec
end



--pack damage passes the player damage info + pets the player own
--each player will also send an enemy, the enemy will be in order of raidIndex of the player
function Details.packFunctions.PackDamage(combatObject)

    if (isDebugging) then
        print("PackDamage(): start.")
    end

    --store actorObjects to pack
    local actorsToPack = {}

    --get the player object from the combat > damage container
    local playerName = UnitName("player")
    local playerObject = combatObject:GetActor(DETAILS_ATTRIBUTE_DAMAGE, playerName)
    if (not playerObject) then
        if (isDebugging) then
            print("PackDamage(): return | no player object.")
        end
        return
    end

    tinsert(actorsToPack, playerObject)

    --get the list of pets the player own
    local playerPets = playerObject.pets
    for _, petName in ipairs(playerPets) do
        local petObject = combatObject:GetActor(DETAILS_ATTRIBUTE_DAMAGE, petName)
        if (petObject) then
            tinsert(actorsToPack, petObject)
        end
    end

    local playerIndex = UnitInRaid("player")

    if (not playerIndex) then --no player index
        if (isDebugging) then
            print("PackDamage(): return | no player index found.")
        end
        return
    end

    --get all npc enemies and sort them by their respaw id
    local allActors = combatObject[DETAILS_ATTRIBUTE_DAMAGE]._ActorTable
    local allEnemies = {} --this have subtables, format: {actorObject, spawnId}

    for i = 1, #allActors do
        --get the actor object
        local actor = allActors[i]
        --check if is an enemy or neutral
        if (actor:IsNeutralOrEnemy()) then
            --get the spawnId
            local spawnId = select(7, strsplit("-", actor.serial))
            if (spawnId) then
                --convert hex to number
                spawnId = tonumber(spawnId:sub(1, 10), 16)
                if (spawnId) then
                    --first index is the actorObject, the second index is the spawnId to sort enemies
                    tinsert(allEnemies, {actor, spawnId})
                end
            end
        end
    end
    --sort enemies by their spawnId
    table.sort(allEnemies, Details.Sort2)

    local allPlayerNames = {}
    for i = 1, 20 do
        local name, _, subgroup = GetRaidRosterInfo(i)
        name = Ambiguate(name, "none")
        if (name and subgroup <= 4) then
            tinsert(allPlayerNames, name)
        end
    end
    table.sort(allPlayerNames, function(t1, t2) return t1 < t2 end)

    local playerName = UnitName("player")
    for i = 1, #allPlayerNames do
        if (playerName == allPlayerNames[i]) then
            playerIndex = i
            break
        end
    end

    --this is the enemy that this player has to send
    local enemyObjectToSend = allEnemies[playerIndex] and allEnemies[playerIndex][1]
    if (enemyObjectToSend) then
        tinsert(actorsToPack, enemyObjectToSend)
    end

    --add the actors to actor information table
    for _, actorObject in ipairs(actorsToPack) do
        --check if already has the actor information
        local indexToActorInfo = actorInformationIndexes[actorObject.nome] --actor name
        if (not indexToActorInfo) then
            --need to add the actor general information into the actor information table
            indexToActorInfo = Details.packFunctions.AddActorInformation(actorObject)
        end
    end

    for i = 1, #actorsToPack do
        --get the actor object
        local actor = actorsToPack[i]
        local indexToActorInfo = actorInformationIndexes[actor.nome]

        --where the information of this actor starts
        local currentIndex = #actorDamageInfo + 1

        --[1] index where is stored the this actor info like name, class, spec, etc
        actorDamageInfo[currentIndex] = indexToActorInfo  --[1]

        --[2 - 6]
        actorDamageInfo [currentIndex + 1] = floor(actor.total)              --[2]
        actorDamageInfo [currentIndex + 2] = floor(actor.totalabsorbed)      --[3]
        actorDamageInfo [currentIndex + 3] = floor(actor.damage_taken)       --[4]
        actorDamageInfo [currentIndex + 4] = floor(actor.friendlyfire_total) --[5]
        actorDamageInfo [currentIndex + 5] = floor(actor.total_without_pet)  --[6]

        local spellContainer = actor.spells._ActorTable

        --reserve an index to tell the length of spells
        actorDamageInfo [#actorDamageInfo + 1] = 0
        local reservedSpellSizeIndex = #actorDamageInfo
        local totalSpellIndexes = 0

        for spellId, spellInfo in pairs(spellContainer) do
            local spellDamage = spellInfo.total
            local spellHits = spellInfo.counter
            local spellTargets = spellInfo.targets

            actorDamageInfo [#actorDamageInfo + 1] = floor(spellId)
            actorDamageInfo [#actorDamageInfo + 1] = floor(spellDamage)
            actorDamageInfo [#actorDamageInfo + 1] = floor(spellHits)
            totalSpellIndexes = totalSpellIndexes + 3

            --build targets
            local targetsSize = Details.packFunctions.CountTableEntriesValid(spellTargets) * 2
            actorDamageInfo [#actorDamageInfo + 1] = targetsSize
            totalSpellIndexes = totalSpellIndexes + 1

            for actorName, damageDone in pairs(spellTargets) do
                actorDamageInfo [#actorDamageInfo + 1] = actorName
                actorDamageInfo [#actorDamageInfo + 1] = floor(damageDone)
                totalSpellIndexes = totalSpellIndexes + 2
            end
        end

        --amount of indexes spells are using
        actorDamageInfo[reservedSpellSizeIndex] = totalSpellIndexes
    end

    if (isDebugging) then
        print("PackDamage(): done.")
    end
end

--------------------------------------------------------------------------------------------------------------------------------
--> unpack

--@currentCombat: details! combat object
--@combatData: array with strings with combat information
--@tablePosition: first index of the first damage actor
function Details.packFunctions.UnPackDamage(currentCombat, combatData, tablePosition)
    if (isDebugging) then
        print("UnPackDamage(): start.")
    end

    --get the damage container
    local damageContainer = currentCombat[DETAILS_ATTRIBUTE_DAMAGE]

    --loop from 1 to 199, the amount of actors store is unknown
    --todo: it's only unpacking the first actor from the table, e.g. theres izimode and eye of corruption, after export it only shows the eye of corruption
    --table position does not move forward
    for i = 1, 199 do
        --actor information index in the combatData table
        --this index gives the position where the actor name, class, spec are stored
        local actorReference = tonumber(combatData[tablePosition]) --[1]
        local actorName, actorFlag, serialNumber, class, spec = Details.packFunctions.RetriveActorInformation(combatData, actorReference)

        if (isDebugging) then
            print("UnPackDamage(): Retrivied Data From " .. (actorReference or "nil") .. ":", actorName, actorFlag, serialNumber, class, spec)
        end

        --check if all damage actors has been processed
        --if there's no actor name it means it reached the end
        if (not actorName) then
            if (isDebugging) then
                print("UnPackDamage(): break damage, end index:", i, (actorReference or "nil"), "tablePosition:", tablePosition, "value:", combatData[tablePosition])
            end
            break
        end

        --get or create the actor object
        local actorObject = damageContainer:GetOrCreateActor(serialNumber, actorName, actorFlag, true)
        --set the actor class, spec and group

        actorObject.classe = class
        actorObject.spec = spec
        actorObject.grupo = isActorInGroup(class, actorFlag)
        actorObject.flag_original = actorFlag

        --> copy back the base damage
            actorObject.total =               tonumber(combatData[tablePosition+1]) --[2]
            actorObject.totalabsorbed =       tonumber(combatData[tablePosition+2]) --[3]
            actorObject.damage_taken =        tonumber(combatData[tablePosition+3]) --[4]
            actorObject.friendlyfire_total =  tonumber(combatData[tablePosition+4]) --[5]
            actorObject.total_without_pet  =  tonumber(combatData[tablePosition+5]) --[6]

            tablePosition = tablePosition + 6 --increase table position

        --> copy back the actor spells
            --amount of indexes used to store spells for this actor
            local spellsSize = tonumber(combatData [tablePosition]) --[7]
            if (isDebugging) then
                print("spell size unpack:", spellsSize)
            end

            tablePosition = tablePosition + 1
            local newTargetsTable = {}

            local spellIndex = tablePosition
            while(spellIndex < tablePosition + spellsSize) do
                local spellId = tonumber(combatData [spellIndex]) --[1]
                local spellDamage = tonumber(combatData [spellIndex+1]) --[2]
                local spellHits = tonumber(combatData [spellIndex+2]) --[3]

                local targetsSize = tonumber(combatData[spellIndex+3]) --[4]

                local targetTable = Details.packFunctions.UnpackTable(combatData, spellIndex+3, true)
                local spellObject = actorObject.spells:GetOrCreateSpell(spellId, true) --this one need some translation
                spellObject.total = spellDamage
                spellObject.counter = spellHits
                spellObject.targets = targetTable

                for targetName, amount in pairs (spellObject.targets) do
                    newTargetsTable[targetName] = (newTargetsTable[targetName] or 0) + amount
                end

                spellIndex = spellIndex + targetsSize + 4
            end

            --each iteration need to build a new target table
            actorObject.targets = newTargetsTable
            tablePosition = tablePosition + spellsSize --increase table position
    end

    if (isDebugging) then
        print("UnPackDamage(): done.")
    end

    return tablePosition
end

function Details.packFunctions.PackHeal(combatObject)
    if (isDebugging) then
        print("PackHeal(): start.")
    end

    --store actorObjects to pack
    local actorsToPack = {}

    --get the player object from the combat > damage container
    local playerName = UnitName("player")
    local playerObject = combatObject:GetActor(DETAILS_ATTRIBUTE_HEAL, playerName)
    if (not playerObject) then
        if (isDebugging) then
            print("PackHeal(): return | no player object.")
        end
        return
    end

    tinsert(actorsToPack, playerObject)

    --get the list of pets the player own
    local playerPets = playerObject.pets
    for _, petName in ipairs(playerPets) do
        local petObject = combatObject:GetActor(DETAILS_ATTRIBUTE_HEAL, petName)
        if (petObject) then
            tinsert(actorsToPack, petObject)
        end
    end

    local playerIndex
    --check if this player has to send information about an enemy npc
    if (IsInGroup()) then
        for i = 1, GetNumGroupMembers() do
            local name = GetRaidRosterInfo(i)
            if (name == playerName) then
                playerIndex = i
                break
            end
        end
    end

    if (not playerIndex) then
        if (isDebugging) then
            print("PackHeal(): return | no player index found.")
        end
        return
    end

    --get all npc enemies and sort them by their respaw id
    local allActors = combatObject[DETAILS_ATTRIBUTE_HEAL]._ActorTable
    local allEnemies = {} --this have subtables, format: {actorObject, spawnId}

    for i = 1, #allActors do
        --get the actor object
        local actor = allActors[i]
        --check if is an enemy or neutral
        if (actor:IsNeutralOrEnemy()) then
            --get the spawnId
            local spawnId = select(7, strsplit( "-", actor.serial))
            if (spawnId) then
                spawnId = tonumber(spawnId)
                if (spawnId) then
                    --first index is the actorObject, the second index is the spawnId to sort enemies
                    tinsert(allEnemies, {actor, spawnId})
                end
            end
        end
    end

    --sort enemies by their spawnId
    table.sort(allEnemies, Details.Sort2)

    --this is the enemy that this player has to send
    local enemyObjectToSend = allEnemies[playerIndex]
    if (enemyObjectToSend) then
        tinsert(actorsToPack, enemyObjectToSend)
    end

    --add the actors to actor information table
    for _, actorObject in ipairs(actorsToPack) do
        --check if already has the actor information
        local indexToActorInfo = actorInformationIndexes[actorObject.nome] --actor name
        if (not indexToActorInfo) then
            --need to add the actor general information into the actor information table
            indexToActorInfo = Details.packFunctions.AddActorInformation(actorObject)
        end
    end

    local spellSize = 0

    for i = 1, #actorsToPack do
        --get the actor object
        local actor = actorsToPack[i]
        local indexToActorInfo = actorInformationIndexes[actor.nome]

        --where the information of this actor starts
        local currentIndex = #actorHealInfo + 1

        --[1] index where is stored the this actor general information
        actorHealInfo[currentIndex] = indexToActorInfo                    --[1]

        --[2 - 6]
        actorHealInfo [currentIndex + 1] = floor(actor.total)                    --[2]
        actorHealInfo [currentIndex + 2] = floor(actor.totalabsorb)              --[3]
        actorHealInfo [currentIndex + 3] = floor(actor.totalover)                --[4]
        actorHealInfo [currentIndex + 4] = floor(actor.healing_taken)            --[5]
        actorHealInfo [currentIndex + 5] = floor(actor.totalover_without_pet)    --[6]

        local spellContainer = actor.spells._ActorTable

        --reserve an index to tell the length of spells
        actorHealInfo [#actorHealInfo + 1] = 0
        local reservedSpellSizeIndex = #actorHealInfo
        local totalSpellIndexes = 0

        for spellId, spellInfo in pairs(spellContainer) do
            local spellHealingDone = spellInfo.total
            local spellHits = spellInfo.counter
            local spellTargets = spellInfo.targets

            actorHealInfo [#actorHealInfo + 1] = floor(spellId)
            actorHealInfo [#actorHealInfo + 1] = floor(spellHealingDone)
            actorHealInfo [#actorHealInfo + 1] = floor(spellHits)

            --build targets
            local targetsSize = Details.packFunctions.CountTableEntriesValid(spellTargets) * 2
            actorHealInfo [#actorHealInfo + 1] = targetsSize

            for actorName, damageDone in pairs(spellTargets) do
                local actorInfoIndex = actorInformationIndexes[actorName]
                if (actorInfoIndex) then
                    actorHealInfo [#actorHealInfo + 1] = actorInfoIndex
                    actorHealInfo [#actorHealInfo + 1] = floor(damageDone)
                    spellSize = spellSize + 2
                end
            end

            --+3: spellId, damage, spellHits
            --+1: the index that tell the size of targets
            totalSpellIndexes = totalSpellIndexes + 3 + targetsSize + 1
            spellSize = spellSize + 1 --debug
        end

        --amount of indexes spells are using
        actorDamageInfo[reservedSpellSizeIndex] = totalSpellIndexes
    end

    if (isDebugging) then
        print("PackHeal(): done.")
    end
end

--------------------------------------------------------------------------------------------------------------------------------
--> unpack

function Details.packFunctions.UnPackHeal(currentCombat, combatData, tablePosition)

    if (isDebugging) then
        print("UnPackHeal(): start.")
    end

    --get the healing container
    local healContainer = currentCombat[DETAILS_ATTRIBUTE_HEAL]

    for i = 1, 199 do
        --this is the same as damage, all comments for the code are there
        local actorReference = tonumber(combatData[tablePosition]) --[1]
        local actorName, actorFlag, serialNumber, class, spec = Details.packFunctions.RetriveActorInformation(combatData, actorReference)

        if (isDebugging) then
            print("UnPackHeal(): Retrivied Data From " .. (actorReference or "nil") .. ":", actorName, actorFlag, serialNumber, class, spec)
        end

        --if there's no actor name it means it reached the end
        if (not actorName) then
            if (isDebugging) then
                print("UnPackHeal(): break | Heal loop has been stopped", "index:", i, "tablePosition:", tablePosition, "value:", combatData[tablePosition])
            end
            break
        end

        --creata the actor object
        local actorObject = healContainer:GetOrCreateActor(serialNumber, actorName, actorFlag, true)
        --set the actor class, spec and group
        actorObject.classe = class
        actorObject.spec = spec
        actorObject.grupo = isActorInGroup(class, actorFlag)

        --> copy the base healing
            actorObject.total =                 tonumber(combatData[tablePosition+1]) --[2]
            actorObject.totalabsorb =           tonumber(combatData[tablePosition+2]) --[3]
            actorObject.totalover =             tonumber(combatData[tablePosition+3]) --[4]
            actorObject.healing_taken =         tonumber(combatData[tablePosition+4]) --[5]
            actorObject.totalover_without_pet  = tonumber(combatData[tablePosition+5]) --[6]

            tablePosition = tablePosition + 6

        --> copy back the actor spells
            --amount of indexes used to store spells for this actor
            local spellsSize = tonumber(combatData [tablePosition]) --[7]
            tablePosition = tablePosition + 1

            local spellIndex = tablePosition
            while(spellIndex < tablePosition + spellsSize) do
                local spellId = tonumber(combatData [spellIndex]) --[1]
                local spellDamage = tonumber(combatData [spellIndex+1]) --[2]
                local spellHits = tonumber(combatData [spellIndex+2]) --[3]

                local targetsSize = combatData [spellIndex+3] --[4]
                local targetTable = Details.packFunctions.UnpackTable(combatData, spellIndex+3, true)
                local spellObject = actorObject.spells:GetOrCreateSpell(spellId, true) --this one need some translation
                spellObject.total = spellDamage
                spellObject.counter = spellHits
                spellObject.targets = targetTable

                spellIndex = spellIndex + targetsSize + 4
            end

            tablePosition = tablePosition + spellsSize --increase table position
    end

    if (isDebugging) then
        print("UnPackHeal(): done.")
    end

    return tablePosition
end

--this function does the same as the function above but does not create a new combat, it just add new information
function Details.packFunctions.DeployPackedCombatData(packedCombatData)
    if (isDebugging) then
        print("DeployPackedCombatData(): start.")
    end

    local LibDeflate = _G.LibStub:GetLibrary("LibDeflate")
    local dataCompressed = LibDeflate:DecodeForWoWAddonChannel(packedCombatData)
    local combatDataString = LibDeflate:DecompressDeflate(dataCompressed)

    if (isDebugging) then
        print(combatDataString)
    end

    local function count(text, pattern)
        return select(2, text:gsub(pattern, ""))
    end

    local combatData = {}
    local amountOfIndexes = count(combatDataString, ",") + 1

    while (amountOfIndexes > 0) do
        local splitPart = {strsplit(",", combatDataString, 4000)}
        if (#splitPart == 4000 and amountOfIndexes > 4000) then
            for i = 1, 3999 do
                combatData[#combatData+1] = splitPart[i]
            end
            --get get part that couldn't be read this loop
            combatDataString = splitPart[4000]
            amountOfIndexes = amountOfIndexes - 3999

        else
            for i = 1, #splitPart do
                combatData[#combatData+1] = splitPart[i]
            end
            amountOfIndexes = amountOfIndexes - #splitPart
        end
    end

    local flags = tonumber(combatData[INDEX_EXPORT_FLAG])
    local tablePosition

    if (bit.band(flags, 0x10) ~= 0) then
        tablePosition = 2
        TOTAL_INDEXES_FOR_COMBAT_INFORMATION = 0 --there's no combat info, data starts after the dataFlag on position [1]
    else
        tablePosition = TOTAL_INDEXES_FOR_COMBAT_INFORMATION + 1
    end

    --get the current combat
    local currentCombat = Details:GetCurrentCombat()

    --check if this export has included damage info
    if (bit.band(flags, 0x1) ~= 0) then
        --find the index where the damage information start
        for i = tablePosition, #combatData do
            if (combatData[i] == "!D") then
                tablePosition = i + 1
                break
            end
        end

        if (isDebugging) then
            print("DeployPackedCombatData(): data has damage info, Damage Index:", tablePosition)
        end

        --unpack damage
        tablePosition = Details.packFunctions.UnPackDamage(currentCombat, combatData, tablePosition)
    end

    if (bit.band(flags, 0x2) ~= 0) then
        --find the index where the heal information start
        for i = tablePosition, #combatData do
            if (combatData[i] == "!H") then
                tablePosition = i + 1
                break
            end
        end

        if (isDebugging) then
            print("DeployPackedCombatData(): data has healing info, Heal Index:", tablePosition)
        end

        --unpack heal
        Details.packFunctions.UnPackHeal(currentCombat, combatData, tablePosition)
    end

    if (bit.band(flags, 0x10) == 0) then
        --set the start and end of combat time and date
        currentCombat:SetStartTime(combatData[INDEX_COMBAT_START_TIME])
        currentCombat:SetEndTime(combatData[INDEX_COMBAT_END_TIME])
        currentCombat:SetDate(combatData[INDEX_COMBAT_START_DATE], combatData[INDEX_COMBAT_END_DATE])
        currentCombat.enemy = combatData[INDEX_COMBAT_NAME]
    end

    --refresh container
    currentCombat[DETAILS_ATTRIBUTE_DAMAGE]:Remap()
    currentCombat[DETAILS_ATTRIBUTE_HEAL]:Remap()

    --refresh damage taken
    local damageContainer = currentCombat[DETAILS_ATTRIBUTE_DAMAGE]
    local allActors = damageContainer._ActorTable

    for i = 1, #allActors do --reset damage taken table
        local actor = allActors[i]
        actor.damage_taken = 0
        actor.damage_from = {}
    end

    for i = 1, #allActors do
        local actor = allActors[i]
        for targetName, amount in pairs (actor.targets) do
            local actorIndex = damageContainer._NameIndexTable[targetName]
            if (actorIndex) then
                local targetActor = allActors[actorIndex]
                if (targetActor) then
                    targetActor.damage_taken = targetActor.damage_taken + amount
                    targetActor.damage_from[actor.nome] = (targetActor.damage_from[actor.nome] or 0) + amount
                end
            end
        end
    end

    --refresh windows
    currentCombat[DETAILS_ATTRIBUTE_DAMAGE].need_refresh = true
    currentCombat[DETAILS_ATTRIBUTE_HEAL].need_refresh = true
end

--get the amount of entries of a hash table
function Details.packFunctions.CountTableEntries(hasTable)
    local amount = 0
    for _ in pairs(hasTable) do
        amount = amount + 1
    end
    return amount
end

--get the amount of entries and check for validation
function Details.packFunctions.CountTableEntriesValid(hasTable)
    local amount = 0
    for actorName, _ in pairs(hasTable) do
        --if (actorInformationIndexes[actorName]) then
            amount = amount + 1
        --end
    end
    return amount
end

--stract some indexes of a table
local selectIndexes = function(table, startIndex, amountIndexes)
    local values = {}
    for i = startIndex, amountIndexes do
        values[#values+1] = tonumber(table[i]) or 0
    end
    return unpack(values)
end

function Details.packFunctions.UnpackTable(table, index, isPair, valueAsTable, amountOfValues)
    local result = {}
    local reservedIndexes = tonumber(table[index])
    local indexStart = index+1
    local indexEnd = reservedIndexes+index

    if (isPair) then
        amountOfValues = amountOfValues or 2
        for i = indexStart, indexStart + reservedIndexes - 1, amountOfValues do
            if (valueAsTable) then
                local key = tonumber(table[i])
                result[key] = {selectIndexes(table, i+1, amountOfValues-1)}
            else
                local key = table[i]
                local value = tonumber(table[i+1])
                result[key] = value
            end
        end
    else
        for i = indexStart, indexEnd do
            local value = tonumber(table[i])
            result[#result+1] = value
        end
    end

    return result
end
