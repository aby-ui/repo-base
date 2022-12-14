--[=[
    This file has the functions to get player information
    Dumping them here, make the code of the main file smaller
--]=]



if (not LIB_OPEN_RAID_CAN_LOAD) then
	return
end

local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")

local CONST_TALENT_VERSION_CLASSIC = 1
local CONST_TALENT_VERSION_LEGION = 4
local CONST_TALENT_VERSION_DRAGONFLIGHT = 5

local CONST_BTALENT_VERSION_COVENANTS = 9

local CONST_SPELLBOOK_CLASSSPELLS_TABID = 2
local CONST_SPELLBOOK_GENERAL_TABID = 1

local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats
local GetInventoryItemLink = GetInventoryItemLink

local isTimewalkWoW = function()
    local _, _, _, buildInfo = GetBuildInfo()
    if (buildInfo < 40000) then
        return true
    end
end

local IsDragonflight = function()
	return select(4, GetBuildInfo()) >= 100000
end

local IsShadowlands = function()
    local versionString, revision, launchDate, gameVersion = GetBuildInfo()
    if (gameVersion >= 90000 and gameVersion < 100000) then
        return true
    end
end

--information about the player character to send, each expansion has its own system and data can be different
--it's always a number
function openRaidLib.UnitInfoManager.GetPlayerInfo1()
    if (IsShadowlands()) then
        --return the renown level within the player covenant
        local renown = C_CovenantSanctumUI.GetRenownLevel() or 1
        return renown
    end

    return 0
end

--information about the player character to send, each expansion has its own system and data can be different
--it's always a number
function openRaidLib.UnitInfoManager.GetPlayerInfo2()
    if (IsShadowlands()) then
        --return which covenant the player picked
        local covenant = C_Covenants.GetActiveCovenantID() or 0
        return covenant
    end

    return 0
end

--default player class-spec talent system
function openRaidLib.GetTalentVersion()
    local _, _, _, buildInfo = GetBuildInfo()

    if (buildInfo >= 1 and buildInfo <= 40000) then --vanilla tbc wotlk cataclysm
        return CONST_TALENT_VERSION_CLASSIC
    end

    if (buildInfo >= 70000 and buildInfo <= 100000) then --legion bfa shadowlands
        return CONST_TALENT_VERSION_LEGION
    end

    if (buildInfo >= 100000 and buildInfo <= 200000) then --dragonflight
        return CONST_TALENT_VERSION_DRAGONFLIGHT
    end
end

--secondary talent tree, can be a legendary weapon talent tree, covenant talent tree, etc...
function openRaidLib.GetBorrowedTalentVersion()
    if (IsShadowlands()) then
        return CONST_BTALENT_VERSION_COVENANTS
    end
end

local getDragonflightTalentsExportedString = function()
    local exportStream = ExportUtil.MakeExportDataStream()
	local configId = C_ClassTalents.GetActiveConfigID()
    if (configId) then
        local configInfo = C_Traits.GetConfigInfo(configId)
	    local currentSpecID = PlayerUtil.GetCurrentSpecID()
        local treeInfo = C_Traits.GetTreeInfo(configId, configInfo.treeIDs[1])
        local treeHash = C_Traits.GetTreeHash(treeInfo.ID)
        local serializationVersion = C_Traits.GetLoadoutSerializationVersion()

        
    end
end

local getDragonflightTalentsAsIndexTable = function()
    local allTalents = {}
    local configId = C_ClassTalents.GetActiveConfigID()
    if (not configId) then
        return allTalents
    end

    local configInfo = C_Traits.GetConfigInfo(configId)

    for treeIndex, treeId in ipairs(configInfo.treeIDs) do
        local treeNodes = C_Traits.GetTreeNodes(treeId)

        for nodeIdIndex, treeNodeID in ipairs(treeNodes) do
            local traitNodeInfo = C_Traits.GetNodeInfo(configId, treeNodeID)

            if (traitNodeInfo) then
                local activeEntry = traitNodeInfo.activeEntry
                if (activeEntry) then
                    local entryId = activeEntry.entryID
                    local rank = activeEntry.rank
                    if (rank > 0) then
                        --get the entry info
                        local traitEntryInfo = C_Traits.GetEntryInfo(configId, entryId)
                        local definitionId = traitEntryInfo.definitionID

                        --definition info
                        local traitDefinitionInfo = C_Traits.GetDefinitionInfo(definitionId)
                        local spellId = traitDefinitionInfo.overriddenSpellID or traitDefinitionInfo.spellID
                        local spellName, _, spellTexture = GetSpellInfo(spellId)
                        if (spellName) then
                            allTalents[#allTalents+1] = spellId
                        end
                    end
                end
            end
        end
    end

    return allTalents
end

--creates two tables, one with indexed talents and another with pairs values ([talentId] = true)
function openRaidLib.UnitInfoManager.GetPlayerTalentsAsPairsTable()
    local talentsPairs = {}
    local talentVersion = openRaidLib.GetTalentVersion()

    if (talentVersion == CONST_TALENT_VERSION_DRAGONFLIGHT) then
        local allTalents = getDragonflightTalentsAsIndexTable()
        for i = 1, #allTalents do
            local spellId = allTalents[i]
            talentsPairs[spellId] = true
        end

    elseif (talentVersion == CONST_TALENT_VERSION_LEGION) then
        for i = 1, 7 do
            for o = 1, 3 do
                local talentId, _, _, selected = GetTalentInfo(i, o, 1)
                if (selected) then
                    talentsPairs[talentId] = true
                    break
                end
            end
        end
    end

    return talentsPairs
end

function openRaidLib.UnitInfoManager.GetPlayerTalents()
    local talents = {}
    local talentVersion = openRaidLib.GetTalentVersion()

    if (talentVersion == CONST_TALENT_VERSION_DRAGONFLIGHT) then
        talents = getDragonflightTalentsAsIndexTable()

    elseif (talentVersion == CONST_TALENT_VERSION_LEGION) then
        talents = {0, 0, 0, 0, 0, 0, 0}
        for talentTier = 1, 7 do
            for talentColumn = 1, 3 do
                local talentId, name, texture, selected, available = GetTalentInfo(talentTier, talentColumn, 1)
                if (selected) then
                    talents[talentTier] = talentId
                    break
                end
            end
        end
    end

    return talents
end

function openRaidLib.UnitInfoManager.GetPlayerPvPTalents()
    if (IsDragonflight()) then
        return {}
    end

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

--borrowed talent tree from shadowlands
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

function openRaidLib.UnitInfoManager.GetPlayerBorrowedTalents()
    local borrowedTalentVersion = openRaidLib.GetBorrowedTalentVersion()

    if (borrowedTalentVersion == CONST_BTALENT_VERSION_COVENANTS) then
        return openRaidLib.UnitInfoManager.GetPlayerConduits()
    end

    return {}
end


function openRaidLib.GearManager.GetPlayerItemLevel()
    if (_G.GetAverageItemLevel) then
        local _, itemLevel = GetAverageItemLevel()
        itemLevel = floor(itemLevel)
        return itemLevel
    else
        return 0
    end
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

    local gearWithEnchantIds = {}

    for equipmentSlotId = 1, 17 do
        local itemLink = GetInventoryItemLink("player", equipmentSlotId)
        if (itemLink) then
            --get the information from the item
            local _, itemId, enchantId, gemId1, gemId2, gemId3, gemId4, suffixId, uniqueId, levelOfTheItem, specId, upgradeInfo, instanceDifficultyId, numBonusIds, restLink = strsplit(":", itemLink)
            local gemsIds = {gemId1, gemId2, gemId3, gemId4}

            --enchant
                --check if the slot can receive enchat and if the equipment has an enchant
                local enchantAttribute = LIB_OPEN_RAID_ENCHANT_SLOTS[equipmentSlotId]
                local nEnchantId = 0

                if (enchantAttribute) then --this slot can receive an enchant
                    if (enchantId and enchantId ~= "") then
                        local number = tonumber(enchantId)
                        nEnchantId = number
                        gearWithEnchantIds[#gearWithEnchantIds+1] = nEnchantId
                    else
                        gearWithEnchantIds[#gearWithEnchantIds+1] = 0
                    end

                    --6400 and above is dragonflight enchantId number space
                    if (nEnchantId < 6300 and not LIB_OPEN_RAID_DEATHKNIGHT_RUNEFORGING_ENCHANT_IDS[nEnchantId]) then
                        slotsWithoutEnchant[#slotsWithoutEnchant+1] = equipmentSlotId
                    end
                end

            --gems
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
                        elseif (gemId < 180000) then
                            slotsWithoutGems[#slotsWithoutGems+1] = equipmentSlotId
                        end
                    end
                end
        end
    end

    return slotsWithoutGems, slotsWithoutEnchant
end

function openRaidLib.GearManager.BuildPlayerEquipmentList()
    local equipmentList = {}
    local debug
    for equipmentSlotId = 1, 17 do
        local itemLink = GetInventoryItemLink("player", equipmentSlotId)
        if (itemLink) then
            local itemStatsTable = {}
            local itemID, enchantID, gemID1, gemID2, gemID3, gemID4, suffixID, uniqueID, linkLevel, specializationID, modifiersMask, itemContext = select(2, strsplit(":", itemLink))
            itemID = tonumber(itemID)

            local effectiveILvl, isPreview, baseILvl = GetDetailedItemLevelInfo(itemLink)
            if (not effectiveILvl) then
                openRaidLib.mainControl.scheduleUpdatePlayerData()
                effectiveILvl = 0
                openRaidLib.__errors[#openRaidLib.__errors+1] = "Fail to get Item Level: " .. (itemID or "invalid itemID") .. " " .. (itemLink and itemLink:gsub("|H", "") or "invalid itemLink")
            end

            GetItemStats(itemLink, itemStatsTable)
            local gemSlotsAvailable = itemStatsTable and itemStatsTable.EMPTY_SOCKET_PRISMATIC or 0

            local noPrefixItemLink = itemLink : gsub("^|c%x%x%x%x%x%x%x%x|Hitem", "")
            local linkTable = {strsplit(":", noPrefixItemLink)}
            local numModifiers = linkTable[14]
            numModifiers = numModifiers and tonumber(numModifiers) or 0

            for i = #linkTable, 14 + numModifiers + 1, -1 do
                tremove(linkTable, i)
            end

            local newItemLink = table.concat(linkTable, ":")
            newItemLink = newItemLink
            equipmentList[#equipmentList+1] = {equipmentSlotId, gemSlotsAvailable, effectiveILvl, newItemLink}

            if (equipmentSlotId == 2) then
                debug = {itemLink:gsub("|H", ""), newItemLink}
            end
        end
    end

    --[[ debug
    local str = ""
    for i = 1, #equipmentList do
        local t = equipmentList[i]
        local s = t[1] .. "," .. t[2] .. "," .. t[3] .. "," .. t[4]
        str = str .. s
    end

    table.insert(debug, str)
    dumpt(debug)
    --]]

    return equipmentList
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
    local timeLeft, charges, startTimeOffset, duration, auraDuration = openRaidLib.CooldownManager.GetPlayerCooldownStatus(cooldownSpellId)

    cooldowns[#cooldowns+1] = cooldownSpellId
    cooldowns[#cooldowns+1] = timeLeft
    cooldowns[#cooldowns+1] = charges
    cooldowns[#cooldowns+1] = startTimeOffset
    cooldowns[#cooldowns+1] = duration
    cooldowns[#cooldowns+1] = auraDuration

    cooldownsHash[cooldownSpellId] = {timeLeft, charges, startTimeOffset, duration, timeNow, auraDuration}
end

local canAddCooldown = function(cooldownInfo)
    local petNpcIdNeeded = cooldownInfo.pet
    if (petNpcIdNeeded) then
        if (not playerHasPetOfNpcId(petNpcIdNeeded)) then
            return false
        end
    end
    return true
end

local getSpellListAsHashTableFromSpellBook = function()
    local completeListOfSpells = {}

    --this line might not be compatible with classic
    local specId, specName, _, specIconTexture = GetSpecializationInfo(GetSpecialization())
    --local classNameLoc, className, classId = UnitClass("player") --not in use
    local locPlayerRace, playerRace, playerRaceId = UnitRace("player")

    --get racials from the general tab
    local tabName, tabTexture, offset, numSpells, isGuild, offspecId = GetSpellTabInfo(CONST_SPELLBOOK_GENERAL_TABID)
    offset = offset + 1
    local tabEnd = offset + numSpells
    for entryOffset = offset, tabEnd - 1 do
        local spellType, spellId = GetSpellBookItemInfo(entryOffset, "player")
        if (spellId and LIB_OPEN_RAID_COOLDOWNS_INFO[spellId] and LIB_OPEN_RAID_COOLDOWNS_INFO[spellId].raceid == playerRaceId) then
            spellId = C_SpellBook.GetOverrideSpell(spellId)
            local spellName = GetSpellInfo(spellId)
            local bIsPassive = IsPassiveSpell(spellId, "player")
            if (spellName and not bIsPassive) then
                completeListOfSpells[spellId] = true
            end
        end
    end

	--get spells from the Spec spellbook
    for i = 1, GetNumSpellTabs() do
        local tabName, tabTexture, offset, numSpells, isGuild, offspecId = GetSpellTabInfo(i)
        if (tabTexture == specIconTexture) then
            offset = offset + 1
            local tabEnd = offset + numSpells
            for entryOffset = offset, tabEnd - 1 do
                local spellType, spellId = GetSpellBookItemInfo(entryOffset, "player")
                if (spellId) then
                    if (spellType == "SPELL") then
                        spellId = C_SpellBook.GetOverrideSpell(spellId)
                        local spellName = GetSpellInfo(spellId)
                        local bIsPassive = IsPassiveSpell(spellId, "player")
                        if LIB_OPEN_RAID_MULTI_OVERRIDE_SPELLS[spellId] then
                            for _, overrideSpellId in pairs(LIB_OPEN_RAID_MULTI_OVERRIDE_SPELLS[spellId]) do
                                completeListOfSpells[overrideSpellId] = true
                            end
                        elseif (spellName and not bIsPassive) then
                            completeListOfSpells[spellId] = true
                        end
                    end
                end
            end
        end
    end

    --get class shared spells from the spell book
    local tabName, tabTexture, offset, numSpells, isGuild, offspecId = GetSpellTabInfo(CONST_SPELLBOOK_CLASSSPELLS_TABID)
    offset = offset + 1
    local tabEnd = offset + numSpells
    for entryOffset = offset, tabEnd - 1 do
        local spellType, spellId = GetSpellBookItemInfo(entryOffset, "player")
        if (spellId) then
            if (spellType == "SPELL") then
                spellId = C_SpellBook.GetOverrideSpell(spellId)
                local spellName = GetSpellInfo(spellId)
                local bIsPassive = IsPassiveSpell(spellId, "player")
                if LIB_OPEN_RAID_MULTI_OVERRIDE_SPELLS[spellId] then
                    for _, overrideSpellId in pairs(LIB_OPEN_RAID_MULTI_OVERRIDE_SPELLS[spellId]) do
                        completeListOfSpells[overrideSpellId] = true
                    end
                elseif (spellName and not bIsPassive) then
                    completeListOfSpells[spellId] = true
                end
            end
        end
    end

    local getNumPetSpells = function()
        --'HasPetSpells' contradicts the name and return the amount of pet spells available instead of a boolean
        return HasPetSpells()
    end

    --get pet spells from the pet spellbook 
    local numPetSpells = getNumPetSpells()
    if (numPetSpells) then
        for i = 1, numPetSpells do
            local spellName, _, unmaskedSpellId = GetSpellBookItemName(i, "pet")
            if (unmaskedSpellId) then
                unmaskedSpellId = C_SpellBook.GetOverrideSpell(unmaskedSpellId)
                local bIsPassive = IsPassiveSpell(unmaskedSpellId, "pet")
                if (spellName and not bIsPassive) then
                    completeListOfSpells[unmaskedSpellId] = true
                end
            end
        end
    end

    return completeListOfSpells
end

local updateCooldownAvailableList = function()
    table.wipe(LIB_OPEN_RAID_PLAYERCOOLDOWNS)
    local _, playerClass = UnitClass("player")
    local locPlayerRace, playerRace, playerRaceId = UnitRace("player")
    local spellBookSpellList = getSpellListAsHashTableFromSpellBook()

    --build a list of all spells assigned as cooldowns for the player class
    for spellID, spellData in pairs(LIB_OPEN_RAID_COOLDOWNS_INFO) do
        if (spellData.class == playerClass or spellData.raceid == playerRaceId) then --need to implement here to get the racial as racial cooldowns does not carry a class
            if (spellBookSpellList[spellID]) then
                LIB_OPEN_RAID_PLAYERCOOLDOWNS[spellID] = spellData
            end
        end
    end
end

--build a list with the local player cooldowns
--called only from SendAllPlayerCooldowns()
function openRaidLib.CooldownManager.GetPlayerCooldownList()
    --update the list of cooldowns the player has available
    if (IsDragonflight()) then
        --this fill the global LIB_OPEN_RAID_PLAYERCOOLDOWNS
        updateCooldownAvailableList()

        --get the player specId
        local specId = openRaidLib.GetPlayerSpecId()
        if (specId) then
            --get the cooldowns for the specialization
            local playerCooldowns = LIB_OPEN_RAID_PLAYERCOOLDOWNS
            if (not playerCooldowns) then
                openRaidLib.DiagnosticError("CooldownManager|GetPlayerCooldownList|LIB_OPEN_RAID_PLAYERCOOLDOWNS is nil")
                return {}, {}
            end

            local cooldowns = {} --table to ship on comm
            local cooldownsHash = {} --table with [spellId] = cooldownInfo
            local talentsHash = openRaidLib.UnitInfoManager.GetPlayerTalentsAsPairsTable()
            local timeNow = GetTime()

            for cooldownSpellId, cooldownInfo in pairs(playerCooldowns) do
                --does this cooldown is based on a talent?
                local talentId = cooldownInfo.talent

                --check if the player has a talent which makes this cooldown unavailable
                local ignoredByTalentId = cooldownInfo.ignoredIfTalent
                local bIsIgnoredByTalentId = false
                if (ignoredByTalentId) then
                    if (talentsHash[ignoredByTalentId]) then
                        bIsIgnoredByTalentId = true
                    end
                end

                if (not bIsIgnoredByTalentId) then
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
            return cooldowns, cooldownsHash
        else
            return {}, {}
        end
    end

    return {}
end

--aura frame handles only UNIT_AURA events to grab the duration of the buff placed by the aura
local bIsNewUnitAuraAvailable = C_UnitAuras and C_UnitAuras.GetAuraDataBySlot and true

local auraSpellID
local auraDurationTime

local handleBuffAura = function(aura)
    local auraInfo = C_UnitAuras.GetAuraDataByAuraInstanceID("player", aura.auraInstanceID)
    if (auraInfo) then
        local spellId = auraInfo.spellId
        if (auraSpellID == spellId) then
            auraSpellID = nil
            auraDurationTime = auraInfo.duration
            return true
        end
    end
end

local getAuraDuration = function(spellId)
    --some auras does not have the same spellId of the cast as the spell for its aura duration
    --in these cases, it's necessary to declare the buff spellId which tells the duration of the effect by adding 'durationSpellId = spellId' within the cooldown data
    if (not LIB_OPEN_RAID_PLAYERCOOLDOWNS[spellId]) then
        --local spellname = GetSpellInfo(spellId)
        --print("spell not found:", spellname)
        return 0
    end
    local customBuffDuration = LIB_OPEN_RAID_PLAYERCOOLDOWNS[spellId].durationSpellId
    --spellId = customBuffDuration or spellId --can't replace the spellId by customBuffDurationSpellId has it wount be found in LIB_OPEN_RAID_PLAYERCOOLDOWNS

    if (bIsNewUnitAuraAvailable) then
        local bBatchCount = false
        local bUsePackedAura = true
        auraSpellID = customBuffDuration or spellId
        auraDurationTime = 0 --reset duration

        AuraUtil.ForEachAura("player", "HELPFUL", bBatchCount, handleBuffAura, bUsePackedAura) --check auras to find a buff for the spellId

        if (auraDurationTime == 0) then --if the buff wasn't found, attempt to get the duration from the file
            return LIB_OPEN_RAID_PLAYERCOOLDOWNS[spellId].duration or 0
        end
        return auraDurationTime
    else
        --this is classic
    end
end

function openRaidLib.CooldownManager.GetSpellBuffDuration(spellId)
    return getAuraDuration(spellId)
end

--check if a player cooldown is ready or if is in cooldown
--@spellId: the spellId to check for cooldown
--return timeLeft, charges, startTimeOffset, duration, buffDuration
function openRaidLib.CooldownManager.GetPlayerCooldownStatus(spellId)
    --check if is a charge spell
    local cooldownInfo = LIB_OPEN_RAID_COOLDOWNS_INFO[spellId]
    if (cooldownInfo) then
        local buffDuration = getAuraDuration(spellId)
        local chargesAvailable, chargesTotal, start, duration = GetSpellCharges(spellId)
        if chargesAvailable then
            if (chargesAvailable == chargesTotal) then
                return 0, chargesTotal, 0, 0, 0 --all charges are ready to use
            else
                --return the time to the next charge
                local timeLeft = start + duration - GetTime()
                local startTimeOffset = start - GetTime()
                return ceil(timeLeft), chargesAvailable, startTimeOffset, duration, buffDuration --time left, charges, startTime, duration, buffDuration
            end
        else
            local start, duration = GetSpellCooldown(spellId)
            if (start == 0) then --cooldown is ready
                return 0, 1, 0, 0, 0 --time left, charges, startTime
            else
                local timeLeft = start + duration - GetTime()
                local startTimeOffset = start - GetTime()
                return ceil(timeLeft), 0, ceil(startTimeOffset), duration, buffDuration --time left, charges, startTime, duration, buffDuration
            end
        end
    else
        return openRaidLib.DiagnosticError("CooldownManager|GetPlayerCooldownStatus()|cooldownInfo not found|", spellId)
    end
end

do
    --make new namespace
    openRaidLib.AuraTracker = {}

    function openRaidLib.AuraTracker.ScanCallback(aura)
        local unitId = openRaidLib.AuraTracker.CurrentUnitId
        local thisUnitAuras = openRaidLib.AuraTracker.CurrentAuras[unitId]

        local auraInfo = C_UnitAuras.GetAuraDataByAuraInstanceID(unitId, aura.auraInstanceID)
        if (auraInfo) then
            local spellId = auraInfo.spellId
            if (spellId) then
                thisUnitAuras[spellId] = true
                openRaidLib.AuraTracker.AurasFoundOnScan[spellId] = true
            end
        end
    end

	function openRaidLib.AuraTracker.ScanPlayerAuras(unitId)
		local batchCount = nil
		local usePackedAura = true
        openRaidLib.AuraTracker.CurrentUnitId = unitId

        openRaidLib.AuraTracker.AurasFoundOnScan = {}
		AuraUtil.ForEachAura(unitId, "HELPFUL", batchCount, openRaidLib.AuraTracker.ScanCallback, usePackedAura)

        local thisUnitAuras = openRaidLib.AuraTracker.CurrentAuras[unitId]
        for spellId in pairs(thisUnitAuras) do
            if (not openRaidLib.AuraTracker.AurasFoundOnScan[spellId]) then
                --aura removed
                openRaidLib.internalCallback.TriggerEvent("unitAuraRemoved", unitId, spellId)
            end
        end
	end

    --run when the open raid lib loads
    function openRaidLib.AuraTracker.StartScanUnitAuras(unitId)
        openRaidLib.AuraTracker.CurrentAuras = {
            [unitId] = {}
        }

        local auraFrameEvent = CreateFrame("frame")
        auraFrameEvent:RegisterUnitEvent("UNIT_AURA", unitId)

        auraFrameEvent:SetScript("OnEvent", function()
            openRaidLib.AuraTracker.ScanPlayerAuras(unitId)
        end)
    end

    --test case:
    local debugModule = {}
    function debugModule.AuraRemoved(event, unitId, spellId)
        local spellName = GetSpellInfo(spellId)
        --print("aura removed:", unitId, spellId, spellName)
    end
    openRaidLib.internalCallback.RegisterCallback("unitAuraRemoved", debugModule.AuraRemoved)

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
    },
    ["EVOKER"] = {
        [1467] = 1, --Devastation
        [1468] = 1, --Preservation
    },
}
