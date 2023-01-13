
local Details = _G.Details
local DF = _G.DetailsFramework
local C_Timer = _G.C_Timer
local addonName, Details222 = ...

--get the sectionInfo and try to extract the spellID from it
--sectionInfo is always a valid table
local parseSectionInfoForSpellID = function(sectionInfo)
    local spellId = sectionInfo.spellID
    if (spellId) then
        spellId = tonumber(spellId)
        if (spellId) then
            local spellName = GetSpellInfo(spellId)
            if (spellName) then
                return spellId
            end
        end
    end
end


---this function is called when the player clicks on a link in the chat window to open a section in the encounter journal
---Details! then will check if that spell linked did damage to the raid and show a small box with the damage done
---@param tag any tag isn't used
---@param journalTypeString string
---@param idString string
function Details222.EJCache.OnClickEncounterJournalLink(tag, journalTypeString, idString)
    local journalType = tonumber(journalTypeString)
    local id = tonumber(idString)

    local instanceId, encounterId, sectionId, tierIndex = EJ_HandleLinkPath(journalType, id)
    if (sectionId) then
        local sectionInfo = C_EncounterJournal.GetSectionInfo(sectionId)
        if (sectionInfo and type(sectionInfo) == "table") then
            local spellId = parseSectionInfoForSpellID(sectionInfo)
            --spellId is guaranteed to be a valid spellId or nil
            if (spellId) then
                local damageDoneTable = Details222.DamageSpells.GetDamageDoneToPlayersBySpell(spellId)
                local topDamage = damageDoneTable[1] and damageDoneTable[1][2]

                if (topDamage and topDamage > 0) then
                    --build a cooltip with the damage done to players by the spellId
                    local gameCooltip = GameCooltip
                    gameCooltip:Preset(2)
                    gameCooltip:SetType("tooltip")
                    gameCooltip:SetOption("LeftPadding", -5)
                    gameCooltip:SetOption("RightPadding", 5)
                    gameCooltip:SetOption("LinePadding", 1)
                    gameCooltip:SetOption("StatusBarTexture", [[Interface\AddOns\Details\images\bar_hyanda]])

                    for i = 1, #damageDoneTable do
                        local targetName, damageDone = unpack(damageDoneTable[i])
                        local nameWithoutRealm = DF:RemoveRealmName(targetName)
                        local formattedDamage = Details:ToK2(damageDone)
                        local className = Details222.ClassCache.GetClass(targetName)
                        local classTexture, left, right, top, bottom = Details:GetClassIcon(className)
                        gameCooltip:AddLine(nameWithoutRealm, formattedDamage)
                        gameCooltip:AddIcon(classTexture, 1, 1, 14, 14, left, right, top, bottom)

                        gameCooltip:AddStatusBar(damageDone / topDamage * 100, 1, .5, .5, .5, 1, false, {value = 100, color = {.2, .2, .2, 0.9}, texture = [[Interface\AddOns\Details\images\bar_hyanda]]})
                    end

                    local abilityString = DF:MakeStringFromSpellId(spellId)
                    if (abilityString) then
                        abilityString = abilityString .. " (damage to)"
                    end

                    local anchor = {"bottom", "top", 0, 0}
                    gameCooltip:SetBannerImage(1, 2, [[Interface\PetBattles\Weather-Blizzard]], 220, 55, anchor, {0.85, 0.189609375, 1, 0}, {0, 0, 0, 1})
                    gameCooltip:SetBannerText(1, 2, abilityString or "Ability Damage Done", {"bottomleft", "topleft", 0, 2}, "white", 14)
                    gameCooltip:SetOwner(EncounterJournal, "topleft", "topright", 50, -10)
                    gameCooltip:Show()
                end
            end
        end
    end

    if (not Details222.EJCache.HasJournalOnHideHooked) then
        Details222.EJCache.HasJournalOnHideHooked = true
        EncounterJournal:HookScript("OnHide", function()
            GameCooltip:Hide()
        end)
    end
end


--search the damage container within the combatObject index[1] for actor that used the spellId passed and inflicted damage to players
---@param spellId number
---@param combatId any
---@return table
function Details222.DamageSpells.GetDamageDoneToPlayersBySpell(spellId, combatId)
    local combatObject = Details:GetCombat(combatId)
    if (not combatObject) then
        return {}
    end

    local damageContainer = combatObject:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
    if (not damageContainer) then
        return {}
    end

    local damageDoneTable = {}

    for index, actorObject in damageContainer:ListActors() do
        if (actorObject:IsNeutralOrEnemy()) then
            local spellTable = actorObject:GetSpell(spellId)
            if (spellTable) then
                for targetName, damageDone in pairs(spellTable.targets) do
                    damageDoneTable[targetName] = (damageDoneTable[targetName] or 0) + damageDone
                end
            end
        end
    end

    local sortedResult = {}
    for targetName, damageDone in pairs(damageDoneTable) do
        local className = Details222.ClassCache.GetClass(targetName)
        sortedResult[#sortedResult + 1] = {targetName, damageDone, className}
    end
    table.sort(sortedResult, function(a, b) return a[2] > b[2] end)

    return sortedResult
end

    --[=[
["description"] = "Eranog wreathes several players in flames. Upon expiration a Flamerift forms at each player's location, inflicting 144,550 Fire damage to players within 4 yards.

A Flamescale Tarasek spills forth from each Flamerift, leaving behind a Lava Flow.

On Mythic difficulty, Eranog also opens a Greater Flamerift that creates a Flamescale Captain.",
["link"] = "[Flamerift]",
["siblingSectionID"] = 26037,
["startsOpen"] = false,
["creatureDisplayID"] = 0,
["headerType"] = 2,
["title"] = "Flamerift",
["firstChildSectionID"] = 26036,
["uiModelSceneID"] = 0,
["filteredByDifficulty"] = false,
["abilityIcon"] = 134153,
["spellID"] = 390715,

--]=]
