--[=[
    This file has the functions to get player information
    Dumping them here, make the code of the main file smaller
--]=]



if (not LIB_OPEN_RAID_CAN_LOAD) then
	return
end

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

local isTimewalkWoW = function()
    local gameVersion = GetBuildInfo()
    if (gameVersion:match("%d") == "1" or gameVersion:match("%d") == "2") then
        return true
    end
end

--creates two tables, one with indexed talents and another with pairs values ([talentId] = true)
function openRaidLib.UnitInfoManager.GetPlayerTalentsAsPairsTable()
    local talentsPairs = {}
    for i = 1, 7 do
        for o = 1, 3 do
            local talentId, _, _, selected = GetTalentInfo(i, o, 1)
            if (selected) then
                talentsPairs[talentId] = true
                break
            end
        end
    end
    return talentsPairs
end

function openRaidLib.UnitInfoManager.GetPlayerTalents()
    local talents = {0, 0, 0, 0, 0, 0, 0}
    for talentTier = 1, 7 do
        for talentColumn = 1, 3 do
            local talentId, name, texture, selected, available = GetTalentInfo(talentTier, talentColumn, 1)
            if (selected) then
                talents[talentTier] = talentId
                break
            end
        end
    end
    return talents
end

function openRaidLib.UnitInfoManager.GetPlayerPvPTalents()
    local talentsPvP = {0, 0, 0}
    local talentList = C_SpecializationInfo.GetAllSelectedPvpTalentIDs()
    for talentIndex, talentId in ipairs(talentList) do
        local doesExists = GetPvpTalentInfoByID(talentId)
        if (doesExists) then
            talentsPvP[talentIndex] = talentId
        end
    end
    return talentsPvP
end

--return the current specId of the player
function openRaidLib.GetPlayerSpecId()
    if (isTimewalkWoW()) then
        return 0
    end

    local spec = GetSpecialization()
    if (spec) then
        local specId = GetSpecializationInfo(spec)
        if (specId and specId > 0) then
            return specId
        end
    end
end

function openRaidLib.UnitInfoManager.GetPlayerConduits()
    local conduits = {}
    local soulbindID = C_Soulbinds.GetActiveSoulbindID()

    if (soulbindID ~= 0) then
        local soulbindData = C_Soulbinds.GetSoulbindData(soulbindID)
        if (soulbindData ~= 0) then
            local tree = soulbindData.tree
            local nodes = tree.nodes

            table.sort(nodes, function(t1, t2) return t1.row < t2.row end)
            local C_Soulbinds_GetConduitCollectionData = C_Soulbinds.GetConduitCollectionData
            for nodeId, nodeInfo in ipairs(nodes) do
                --check if the node is a conduit placed by the player
                
                if (nodeInfo.state == Enum.SoulbindNodeState.Selected)  then
                    local conduitId = nodeInfo.conduitID
                    local conduitRank = nodeInfo.conduitRank
                    
                    if (conduitId and conduitRank) then
                        --have spell id when it's a default conduit from the game
                        local spellId = nodeInfo.spellID
                        --have conduit id when is a conduid placed by the player
                        local conduitId  = nodeInfo.conduitID
                        
                        if (spellId == 0) then
                            --is player conduit
                            spellId = C_Soulbinds.GetConduitSpellID(nodeInfo.conduitID, nodeInfo.conduitRank)
                            conduits[#conduits+1] = spellId
                            local collectionData = C_Soulbinds_GetConduitCollectionData(conduitId)
                            conduits[#conduits+1] = collectionData and collectionData.conduitItemLevel or 0         
                        else
                            --is default conduit
                            conduits[#conduits+1] = spellId
                            conduits[#conduits+1] = 0
                        end
                    end
                end
            end
        end
    end

    return conduits
end

function openRaidLib.GearManager.GetPlayerItemLevel()
    if (_G.GetAverageItemLevel) then
        local _, _itemLevel = GetAverageItemLevel()
        itemLevel = floor(_itemLevel)
    else
        itemLevel = 0
    end
    return itemLevel
end

--return an integer between zero and one hundret indicating the player gear durability
function openRaidLib.GearManager.GetPlayerGearDurability()
    local durabilityTotalPercent, totalItems = 0, 0
    for i = INVSLOT_FIRST_EQUIPPED, INVSLOT_LAST_EQUIPPED do
        local durability, maxDurability = GetInventoryItemDurability(i)
        if (durability and maxDurability) then
            local itemDurability = durability / maxDurability * 100
            durabilityTotalPercent = durabilityTotalPercent + itemDurability
            totalItems = totalItems + 1
        end
    end

    if (totalItems == 0) then
        return 100
    end

    return floor(durabilityTotalPercent / totalItems)
end

function openRaidLib.GearManager.GetPlayerWeaponEnchant()
    local weaponEnchant = 0
    local _, _, _, mainHandEnchantId, _, _, _, offHandEnchantId = GetWeaponEnchantInfo()
    if (LIB_OPEN_RAID_WEAPON_ENCHANT_IDS[mainHandEnchantId]) then
        weaponEnchant = 1

    elseif(LIB_OPEN_RAID_WEAPON_ENCHANT_IDS[offHandEnchantId]) then
        weaponEnchant = 1
    end
    return weaponEnchant
end

function openRaidLib.GearManager.GetPlayerGemsAndEnchantInfo()
    --hold equipmentSlotId of equipment with a gem socket but it's empty
    local slotsWithoutGems = {}
    --hold equipmentSlotId of equipments without an enchant
    local slotsWithoutEnchant = {}

    for equipmentSlotId = 1, 17 do
        local itemLink = GetInventoryItemLink("player", equipmentSlotId)
        if (itemLink) then
            --get the information from the item
            local _, itemId, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, levelOfTheItem, specId, upgradeInfo, instanceDifficultyId, numBonusIds, restLink = strsplit(":", itemLink)
            local gemsIds = {gemId1, gemId2, gemId3, gemId4}

            --> enchant
                --check if the slot can receive enchat and if the equipment has an enchant
                local enchantAttribute = LIB_OPEN_RAID_ENCHANT_SLOTS[equipmentSlotId]
                if (enchantAttribute) then --this slot can receive an enchat

                    --check if this slot is relevant for the class, some slots can have enchants only for Agility which won't matter for Priests as an example
                    --if the value is an integer it points to an attribute (int, dex, str), otherwise it's true (boolean)
                    local slotIsRelevant = true
                    if (type (enchantAttribute) == "number") then
                        if (specMainAttribute ~= enchantAttribute) then
                            slotIsRelevant = false
                        end
                    end

                    if (slotIsRelevant) then
                        --does the slot has any enchant?
                        if (not enchantId or enchantId == "0" or enchantId == "") then
                            slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                        else
                            --convert to integer
                            local enchantIdInt = tonumber(enchantId)
                            if (enchantIdInt) then
                                --does the enchant is relevent for the character?
                                if (not LIB_OPEN_RAID_ENCHANT_IDS[enchantIdInt]) then
                                    slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                                end
                            else
                                --the enchat has an invalid id
                                slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                            end
                        end
                    end
                end

            --> gems
                local itemStatsTable = {}
                --fill the table above with information about the item
                GetItemStats(itemLink, itemStatsTable)

                --check if the item has a socket
                if (itemStatsTable.EMPTY_SOCKET_PRISMATIC) then
                    --check if the socket is empty
                    for i = 1, itemStatsTable.EMPTY_SOCKET_PRISMATIC do
                        local gemId = tonumber(gemsIds[i])
                        if (not gemId or gemId == 0) then
                            slotsWithoutGems[#slotsWithoutGems+1] = equipmentSlotId

                        --check if the gem is not a valid gem (deprecated gem)
                        elseif (not LIB_OPEN_RAID_GEM_IDS[gemId]) then
                            slotsWithoutGems[#slotsWithoutGems+1] = equipmentSlotId
                        end
                    end
                end
        end
    end

    return slotsWithoutGems, slotsWithoutEnchant
end

local playerHasPetOfNpcId = function(npcId)
    if (UnitExists("pet") and UnitHealth("pet") >= 1) then
        local guid = UnitGUID("pet")
        if (guid) then
            local split = {strsplit("-", guid)}
            local playerPetNpcId = tonumber(split[6])
            if (playerPetNpcId) then
                if (npcId == playerPetNpcId) then
                    return true
                end
            end
        end
    end
end

local addCooldownToTable = function(cooldowns, cooldownsHash, cooldownSpellId, timeNow)
    cooldowns[#cooldowns+1] = cooldownSpellId
    local timeLeft, charges, startTimeOffset, duration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(cooldownSpellId)
    cooldowns[#cooldowns+1] = timeLeft
    cooldowns[#cooldowns+1] = charges
    cooldowns[#cooldowns+1] = startTimeOffset
    cooldowns[#cooldowns+1] = duration
    cooldownsHash[cooldownSpellId] = {timeLeft, charges, startTimeOffset, duration, timeNow}
end

local canAddCooldown = function(cooldownInfo)
        local needPetNpcId = cooldownInfo.pet
    if (needPetNpcId) then
        if (not playerHasPetOfNpcId(needPetNpcId)) then
            return false
        end
    end
    return true
end

--build a list with the local player cooldowns
--called only from SendAllPlayerCooldowns()
function openRaidLib.CooldownManager.GetPlayerCooldownList()
    --get the player specId
    local specId = openRaidLib.GetPlayerSpecId()
    if (specId) then
        --get the cooldowns for the specialization
        local playerCooldowns = LIB_OPEN_RAID_COOLDOWNS_BY_SPEC[specId]
        if (not playerCooldowns) then
            openRaidLib.DiagnosticError("CooldownManager|GetPlayerCooldownList|can't find player cooldowns for specId:", specId)
            return {}, {}
        end

        local cooldowns = {} --table to ship on comm
        local cooldownsHash = {} --table with [spellId] = cooldownInfo
        local talentsHash = openRaidLib.UnitInfoManager.GetPlayerTalentsAsPairsTable()
        local timeNow = GetTime()

        for cooldownSpellId, cooldownType in pairs(playerCooldowns) do
            --get all the information about this cooldow
            local cooldownInfo = LIB_OPEN_RAID_COOLDOWNS_INFO[cooldownSpellId]
            if (cooldownInfo) then
                --does this cooldown is based on a talent?
                local talentId = cooldownInfo.talent

                --check if the player has a talent which makes this cooldown unavailable
                local ignoredByTalentId = cooldownInfo.ignoredIfTalent
                local isIgnoredByTalentId = false
                if (ignoredByTalentId) then
                    if (talentsHash[ignoredByTalentId]) then
                        isIgnoredByTalentId = true
                    end
                end

                if (not isIgnoredByTalentId) then
                    if (talentId) then
                        --check if the player has the talent selected
                        if (talentsHash[talentId]) then
                            if (canAddCooldown(cooldownInfo)) then
                                addCooldownToTable(cooldowns, cooldownsHash, cooldownSpellId, timeNow)
                            end
                        end
                    else
                        if (canAddCooldown(cooldownInfo)) then
                            addCooldownToTable(cooldowns, cooldownsHash, cooldownSpellId, timeNow)
                        end
                    end
                end
            end
        end
        return cooldowns, cooldownsHash
    else
        return {}, {}
    end
end

--check if a player cooldown is ready or if is in cooldown
--@spellId: the spellId to check for cooldown
function openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)
    --check if is a charge spell
    local cooldownInfo = LIB_OPEN_RAID_COOLDOWNS_INFO[spellId]
    if (cooldownInfo) then
        if (cooldownInfo.charges and cooldownInfo.charges > 1) then
            local chargesAvailable, chargesTotal, start, duration = GetSpellCharges(spellId)

            if (chargesAvailable == chargesTotal) then
                return 0, chargesTotal, 0, 0 --all charges are ready to use
            else
                --return the time to the next charge
                local timeLeft = start + duration - GetTime()
                local startTimeOffset = start - GetTime()
                return ceil(timeLeft), chargesAvailable, startTimeOffset, duration --time left, charges, startTime
            end

        else
            local start, duration = GetSpellCooldown(spellId)
            if (start == 0) then --cooldown is ready
                return 0, 1, 0, 0 --time left, charges, startTime
            else
                local timeLeft = start + duration - GetTime()
                local startTimeOffset = start - GetTime()
                return ceil(timeLeft), 0, ceil(startTimeOffset), duration --time left, charges, startTime, duration
            end
        end
    else
        return openRaidLib.DiagnosticError("CooldownManager|GetPlayerCooldownStatus()|cooldownInfo not found|", spellId)
    end
end

--which is the main attribute of each spec
--1 Intellect
--2 Agility
--3 Strenth
openRaidLib.specAttribute = {
	["DEMONHUNTER"] = {
		[577] = 2,
		[581] = 2,
	},
	["DEATHKNIGHT"] = {
		[250] = 3,
		[251] = 3,
		[252] = 3,
	},
	["WARRIOR"] = {
		[71] = 3,
		[72] = 3,
		[73] = 3,
	},
	["MAGE"] = {
		[62] = 1,
		[63] = 1,
		[64] = 1,
	},
	["ROGUE"] = {
		[259] = 2,
		[260] = 2,
		[261] = 2,
	},
	["DRUID"] = {
		[102] = 1,
		[103] = 2,
		[104] = 2,
		[105] = 1,
	},
	["HUNTER"] = {
		[253] = 2,
		[254] = 2,
		[255] = 2,
	},
	["SHAMAN"] = {
		[262] = 1,
		[263] = 2,
		[264] = 1,
	},
	["PRIEST"] = {
		[256] = 1,
		[257] = 1,
		[258] = 1,
	},
	["WARLOCK"] = {
		[265] = 1,
		[266] = 1,
		[267] =1 ,
	},
	["PALADIN"] = {
		[65] = 1,
		[66] = 3,
		[70] = 3,
	},
	["MONK"] = {
		[268] = 2,
		[269] = 2,
		[270] = 1,
    }
}
