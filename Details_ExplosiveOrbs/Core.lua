local addon, Engine = ...
local EO = LibStub('AceAddon-3.0'):NewAddon(addon, 'AceEvent-3.0', 'AceHook-3.0')
local L = Engine.L

Engine.Core = EO
_G[addon] = Engine

-- Lua functions
local _G = _G
local format, ipairs, pairs, select, strmatch, tonumber, type = format, ipairs, pairs, select, strmatch, tonumber, type
local bit_band = bit.band

-- WoW API / Variables
local C_ChallengeMode_GetActiveKeystoneInfo = C_ChallengeMode.GetActiveKeystoneInfo
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo
local CreateFrame = CreateFrame
local UnitGUID = UnitGUID

local tContains = tContains

local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET

local Details = _G.Details

-- GLOBALS: ExplosiveOrbsLog

EO.debug = false
EO.orbID = 120651 -- Explosive
EO.CustomDisplay = {
    name = L["Explosive Orbs"],
    icon = 2175503,
    source = false,
    attribute = false,
    spellid = false,
    target = false,
    author = "Rhythm",
    desc = L["Show how many explosive orbs players target and hit."],
    script_version = 4,
    script = [[
        local Combat, CustomContainer, Instance = ...
        local total, top, amount = 0, 0, 0

        if _G.Details_ExplosiveOrbs then
            local CombatNumber = Combat:GetCombatNumber()
            local Container = Combat:GetContainer(DETAILS_ATTRIBUTE_MISC)
            for _, Actor in Container:ListActors() do
                if Actor:IsGroupPlayer() then
                    -- we only record the players in party
                    local target, hit = _G.Details_ExplosiveOrbs:GetRecord(CombatNumber, Actor:guid())
                    if target > 0 or hit > 0 then
                        CustomContainer:AddValue(Actor, hit)
                    end
                end
            end

            total, top = CustomContainer:GetTotalAndHighestValue()
            amount = CustomContainer:GetNumActors()
        end

        return total, top, amount
    ]],
    tooltip = [[
        local Actor, Combat, Instance = ...
        local GameCooltip = GameCooltip

        if _G.Details_ExplosiveOrbs then
            local actorName = Actor:name()
            local Actor = Combat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE):GetActor(actorName)
            if not Actor then return end

            local sortedList = {}
            local orbName = _G.Details_ExplosiveOrbs:RequireOrbName()
            local Container = Combat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)

            for spellID, spellTable in pairs(Actor:GetSpellList()) do
                local amount = spellTable.targets[orbName]
                if amount then
                    tinsert(sortedList, {spellID, amount})
                end
            end

            -- handle pet
            for _, petName in ipairs(Actor.pets) do
                local petActor = Container:GetActor(petName)
                for spellID, spellTable in pairs(petActor:GetSpellList()) do
                    local amount = spellTable.targets[orbName]
                    if amount then
                        tinsert(sortedList, {spellID, amount, petName})
                    end
                end
            end

            sort(sortedList, Details.Sort2)

            local format_func = Details:GetCurrentToKFunction()
            for _, tbl in ipairs(sortedList) do
                local spellID, amount, petName = unpack(tbl)
                local spellName, _, spellIcon = Details.GetSpellInfo(spellID)
                if petName then
                    spellName = spellName .. ' (' .. petName .. ')'
                end

                GameCooltip:AddLine(spellName, format_func(_, amount))
                Details:AddTooltipBackgroundStatusbar()
                GameCooltip:AddIcon(spellIcon, 1, 1, _detalhes.tooltip.line_height, _detalhes.tooltip.line_height)
            end
        end
    ]],
    total_script = [[
        local value, top, total, Combat, Instance, Actor = ...

        if _G.Details_ExplosiveOrbs then
            return _G.Details_ExplosiveOrbs:GetDisplayText(Combat:GetCombatNumber(), Actor.my_actor:guid())
        end
        return ""
    ]],
}

-- Public APIs

function Engine:GetRecord(combatID, playerGUID)
    if EO.db[combatID] and EO.db[combatID][playerGUID] then
        return EO.db[combatID][playerGUID].target or 0, EO.db[combatID][playerGUID].hit or 0
    end
    return 0, 0
end

function Engine:GetDisplayText(combatID, playerGUID)
    if EO.db[combatID] and EO.db[combatID][playerGUID] then
        return L["Target: "] .. (EO.db[combatID][playerGUID].target or 0) .. " " .. L["Hit: "] .. (EO.db[combatID][playerGUID].hit or 0)
    end
    return L["Target: "] .. "0 " .. L["Hit: "] .. "0"
end

function Engine:FormatDisplayText(target, hit)
    return L["Target: "] .. (target or 0) .. " " .. L["Hit: "] .. (hit or 0)
end

function Engine:RequireOrbName()
    if not EO.orbName then
        EO.orbName = Details:GetSourceFromNpcId(EO.orbID)
    end
    return EO.orbName
end

-- Private Functions

function EO:Debug(...)
    if self.debug then
        _G.DEFAULT_CHAT_FRAME:AddMessage("|cFF70B8FFDetails Explosive Orbs:|r " .. format(...))
    end
end

function EO:ParseNPCID(unitGUID)
    return tonumber(strmatch(unitGUID or '', 'Creature%-.-%-.-%-.-%-.-%-(.-)%-') or '')
end

local function targetChanged(self, _, unitID)
    local targetGUID = UnitGUID(unitID .. 'target')
    if not targetGUID then return end

    local npcID = EO:ParseNPCID(targetGUID)
    if npcID == EO.orbID then
        -- record pet's target to its owner
        EO:RecordTarget(UnitGUID(self.unitID), targetGUID)
    end
end

function EO:COMBAT_LOG_EVENT_UNFILTERED()
    local _, subEvent, _, sourceGUID, sourceName, sourceFlag, _, destGUID = CombatLogGetCurrentEventInfo()
    if (
        subEvent == 'SPELL_DAMAGE' or subEvent == 'RANGE_DAMAGE' or subEvent == 'SWING_DAMAGE' or
        subEvent == 'SPELL_PERIODIC_DAMAGE' or subEvent == 'SPELL_BUILDING_DAMAGE'
    ) then
        local npcID = self:ParseNPCID(destGUID)
        if npcID == self.orbID then
            if bit_band(sourceFlag, COMBATLOG_OBJECT_TYPE_PET) > 0 then
                -- source is pet, don't track guardian which is automaton
                local Combat = Details:GetCombat(0)
                if Combat then
                    local Container = Combat:GetContainer(_G.DETAILS_ATTRIBUTE_DAMAGE)
                    local ownerActor = select(2, Container:PegarCombatente(sourceGUID, sourceName, sourceFlag, true))
                    if ownerActor then
                        -- Details implements two cache method of pet and its owner,
                        -- one is in parser which is shared inside parser (damage_cache_petsOwners),
                        -- it will be wiped in :ClearParserCache, but I have no idea when,
                        -- the other is in container,
                        -- which :PegarCombatente will try to fetch owner from it first,
                        -- so in this case, simply call :PegarCombatente and use its cache,
                        -- and no need to implement myself like parser
                        sourceGUID = ownerActor:guid()
                    end
                end
            end
            EO:RecordHit(sourceGUID, destGUID)
        end
    end
end

function EO:RecordTarget(unitGUID, targetGUID)
    if not self.current then return end

    -- self:Debug("%s target %s in combat %s", unitGUID, targetGUID, self.current)

    if not self.db[self.current] then self.db[self.current] = {} end
    if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {} end
    if not self.db[self.current][unitGUID][targetGUID] then self.db[self.current][unitGUID][targetGUID] = 0 end

    if self.db[self.current][unitGUID][targetGUID] ~= 1 and self.db[self.current][unitGUID][targetGUID] ~= 3 then
        self.db[self.current][unitGUID][targetGUID] = self.db[self.current][unitGUID][targetGUID] + 1
        self.db[self.current][unitGUID].target = (self.db[self.current][unitGUID].target or 0) + 1

        -- update overall
        if not self.db[self.overall] then self.db[self.overall] = {} end
        if not self.db[self.overall][unitGUID] then self.db[self.overall][unitGUID] = {} end

        self.db[self.overall][unitGUID].target = (self.db[self.overall][unitGUID].target or 0) + 1
    end
end

function EO:RecordHit(unitGUID, targetGUID)
    if not self.current then return end

    -- self:Debug("%s hit %s in combat %s", unitGUID, targetGUID, self.current)

    if not self.db[self.current] then self.db[self.current] = {} end
    if not self.db[self.current][unitGUID] then self.db[self.current][unitGUID] = {} end
    if not self.db[self.current][unitGUID][targetGUID] then self.db[self.current][unitGUID][targetGUID] = 0 end

    if self.db[self.current][unitGUID][targetGUID] ~= 2 and self.db[self.current][unitGUID][targetGUID] ~= 3 then
        self.db[self.current][unitGUID][targetGUID] = self.db[self.current][unitGUID][targetGUID] + 2
        self.db[self.current][unitGUID].hit = (self.db[self.current][unitGUID].hit or 0) + 1

        -- update overall
        if not self.db[self.overall] then self.db[self.overall] = {} end
        if not self.db[self.overall][unitGUID] then self.db[self.overall][unitGUID] = {} end

        self.db[self.overall][unitGUID].hit = (self.db[self.overall][unitGUID].hit or 0) + 1
    end
end

function EO:CheckAffix()
    local affix = select(2, C_ChallengeMode_GetActiveKeystoneInfo())
    if affix and tContains(affix, 13) then
        self:Debug("Explosive active")
        self:RegisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        for _, frame in ipairs(self.eventFrames) do
            frame:RegisterUnitEvent('UNIT_TARGET', frame.unitID, frame.unitID .. 'pet')
        end
    else
        self:Debug("Explosive inactive")
        self:UnregisterEvent('COMBAT_LOG_EVENT_UNFILTERED')
        for _, frame in ipairs(self.eventFrames) do
            frame:UnregisterEvent('UNIT_TARGET')
        end
    end
end

function EO:MergeCombat(to, from)
    if self.db[from] then
        self:Debug("Merging combat %s into %s", from, to)
        if not self.db[to] then self.db[to] = {} end
        for playerGUID, tbl in pairs(self.db[from]) do
            if type(tbl) == 'table' then
                if not self.db[to][playerGUID] then
                    self.db[to][playerGUID] = {}
                end
                self.db[to][playerGUID].target = (self.db[to][playerGUID].target or 0) + (tbl.target or 0)
                self.db[to][playerGUID].hit = (self.db[to][playerGUID].hit or 0) + (tbl.hit or 0)
            end
        end
    end
end

function EO:MergeSegmentsOnEnd()
    self:Debug("on Details MergeSegmentsOnEnd")

    -- at the end of a Mythic+ Dungeon
    -- Details Combat:
    -- n+1 - other combat
    -- n   - first combat
    -- ...
    -- 3   - combat (likely final boss trash)
    -- 2   - combat (likely final boss)
    -- 1   - overall combat

    local overallCombat = Details:GetCombat(1)
    local overall = overallCombat:GetCombatNumber()
    local runID = select(2, overallCombat:IsMythicDungeon())
    for i = 2, 25 do
        local combat = Details:GetCombat(i)
        if not combat then break end

        local combatRunID = select(2, combat:IsMythicDungeon())
        if not combatRunID or combatRunID ~= runID then break end

        self:MergeCombat(overall, combat:GetCombatNumber())
    end

    self:CleanDiscardCombat()
end

function EO:MergeTrashCleanup()
    self:Debug("on Details MergeTrashCleanup")

    -- after boss fight
    -- Details Combat:
    -- 3   - other combat
    -- 2   - boss trash combat
    -- 1   - boss combat

    local runID = select(2, Details:GetCombat(1):IsMythicDungeon())

    local baseCombat = Details:GetCombat(2)
    -- killed boss before any combat
    if not baseCombat then return end

    local baseCombatRunID = select(2, baseCombat:IsMythicDungeon())
    -- killed boss before any trash combats
    if not baseCombatRunID or baseCombatRunID ~= runID then return end

    local base = baseCombat:GetCombatNumber()
    local prevCombat = Details:GetCombat(3)
    if prevCombat then
        local prev = prevCombat:GetCombatNumber()
        for i = prev + 1, base - 1 do
            if i ~= self.overall then
                self:MergeCombat(base, i)
            end
        end
    else
        -- fail to find other combat, merge all combat with same run id in database
        for combatID, data in pairs(self.db) do
            if data.runID and data.runID == runID then
                self:MergeCombat(base, combatID)
            end
        end
    end

    self:CleanDiscardCombat()
end

function EO:MergeRemainingTrashAfterAllBossesDone()
    self:Debug("on Details MergeRemainingTrashAfterAllBossesDone")

    -- before the end of a Mythic+ Dungeon, and finish all trash after final boss fight
    -- Details Combat:
    -- 3   - prev boss combat
    -- 2   - final boss trash combat
    -- 1   - final boss combat
    -- current combat is removed

    local prevTrash = Details:GetCombat(2)
    if prevTrash then
        local prev = prevTrash:GetCombatNumber()
        self:MergeCombat(prev, self.current)
    end

    self:CleanDiscardCombat()
end

function EO:OnResetOverall()
    self:Debug("on Details Reset Overall")

    if self.overall and self.db[self.overall] then
        self.db[self.overall] = nil
    end
    self.overall = Details:GetCombat(-1):GetCombatNumber()
end

function EO:CleanDiscardCombat()
    local remain = {}
    remain[self.overall] = true

    for i = 1, 25 do
        local combat = Details:GetCombat(i)
        if not combat then break end

        remain[combat:GetCombatNumber()] = true
    end

    for key in pairs(self.db) do
        if not remain[key] then
            self.db[key] = nil
        end
    end
end

function EO:OnDetailsEvent(event, combat)
    -- self here is not EO, this function is called from EO.EventListener
    if event == 'COMBAT_PLAYER_ENTER' then
        EO.current = combat:GetCombatNumber()
        EO:Debug("COMBAT_PLAYER_ENTER: %s", EO.current)
    elseif event == 'COMBAT_PLAYER_LEAVE' then
        EO.current = combat:GetCombatNumber()
        EO:Debug("COMBAT_PLAYER_LEAVE: %s", EO.current)

        if not EO.current or not EO.db[EO.current] then return end
        for _, list in pairs(EO.db[EO.current]) do
            for key in pairs(list) do
                if key ~= 'target' and key ~= 'hit' then
                    list[key] = nil
                end
            end
        end
        EO.db[EO.current].runID = select(2, combat:IsMythicDungeon())
    elseif event == 'DETAILS_DATA_RESET' then
        EO:Debug("DETAILS_DATA_RESET")
        self.overall = Details:GetCombat(-1):GetCombatNumber()
        EO:CleanDiscardCombat()
    end
end

function EO:LoadHooks()
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeSegmentsOnEnd')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeTrashCleanup')
    self:SecureHook(_G.DetailsMythicPlusFrame, 'MergeRemainingTrashAfterAllBossesDone')

    local originResetOverall = Details.historico.resetar_overall
    Details.historico.resetar_overall = function(...)
        originResetOverall(...)

        EO:OnResetOverall()
    end
    if Details.tabela_historico then
        self:SecureHook(Details.tabela_historico, 'resetar_overall', 'OnResetOverall')
    end
    self.overall = Details:GetCombat(-1):GetCombatNumber()

    self.EventListener = Details:CreateEventListener()
    self.EventListener:RegisterEvent('COMBAT_PLAYER_ENTER')
    self.EventListener:RegisterEvent('COMBAT_PLAYER_LEAVE')
    self.EventListener:RegisterEvent('DETAILS_DATA_RESET')
    self.EventListener.OnDetailsEvent = self.OnDetailsEvent

    Details:InstallCustomObject(self.CustomDisplay)
    self:CleanDiscardCombat()
end

function EO:OnInitialize()
    -- load database
    self.db = ExplosiveOrbsLog or {}
    ExplosiveOrbsLog = self.db

    -- unit event frames
    self.eventFrames = {}
    for i = 1, 5 do
        self.eventFrames[i] = CreateFrame('frame')
        self.eventFrames[i]:SetScript('OnEvent', targetChanged)
        self.eventFrames[i].unitID = (i == 5 and 'player' or ('party' .. i))
    end

    self:RegisterEvent('PLAYER_ENTERING_WORLD', 'CheckAffix')
    self:RegisterEvent('CHALLENGE_MODE_START', 'CheckAffix')

    self:SecureHook(Details, 'StartMeUp', 'LoadHooks')
end
