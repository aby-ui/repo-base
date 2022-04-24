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
local GetAddOnMetadata = GetAddOnMetadata
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
    script_version = 11,
    script = [[
        local Combat, CustomContainer, Instance = ...
        local total, top, amount = 0, 0, 0

        if _G.Details_ExplosiveOrbs then
            local CombatNumber = Combat:GetCombatNumber()
            local Container = Combat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
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
EO.CustomDisplayOverall = {
    name = L["Dynamic Overall Explosive Orbs"],
    icon = 2175503,
    source = false,
    attribute = false,
    spellid = false,
    target = false,
    author = "Rhythm",
    desc = L["Show how many explosive orbs players target and hit."],
    script_version = 11,
    script = [[
        local Combat, CustomContainer, Instance = ...
        local total, top, amount = 0, 0, 0

        if _G.Details_ExplosiveOrbs then
            local OverallCombat = Details:GetCombat(-1)
            local CombatNumber = OverallCombat:GetCombatNumber()
            local Container = OverallCombat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
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
            local orbName = _G.Details_ExplosiveOrbs:RequireOrbName()

            local OverallCombat = Details:GetCombat(-1)
            local CurrentCombat = Details:GetCombat(0)

            local OverallContainer = OverallCombat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
            local CurrentContainer = CurrentCombat:GetContainer(DETAILS_ATTRIBUTE_DAMAGE)

            local AllSpells = {}

            -- handle overall
            local Actor = OverallContainer:GetActor(actorName)
            local ActorSpells = Actor:GetSpellList()

            -- handle player
            AllSpells[actorName] = {}
            for spellID, spellTable in pairs(ActorSpells) do
                AllSpells[actorName][spellID] = spellTable.targets[orbName]
            end

            -- handle pet
            for _, petName in ipairs(Actor.pets) do
                local petActor = OverallContainer:GetActor(petName)
                local petActorSpells = petActor:GetSpellList()

                AllSpells[petName] = {}
                for spellID, spellTable in pairs(petActorSpells) do
                    AllSpells[petName][spellID] = spellTable.targets[orbName]
                end
            end

            if Details.in_combat then
                -- handle current
                local Actor = CurrentContainer:GetActor(actorName)
                local ActorSpells = Actor:GetSpellList()

                -- handle player
                for spellID, spellTable in pairs(ActorSpells) do
                    AllSpells[actorName][spellID] = (AllSpells[actorName][spellID] or 0) + (spellTable.targets[orbName] or 0)
                end

                -- handle pet
                for _, petName in ipairs(Actor.pets) do
                    local petActor = CurrentContainer:GetActor(petName)
                    local petActorSpells = petActor:GetSpellList()

                    if not AllSpells[petName] then
                        AllSpells[petName] = {}
                    end

                    for spellID, spellTable in pairs(petActorSpells) do
                        AllSpells[petName][spellID] = (AllSpells[petName][spellID] or 0) + (spellTable.targets[orbName] or 0)
                    end
                end
            end

            local sortedList = {}
            for name, spellTable in pairs(AllSpells) do
                for spellID, amount in pairs(spellTable) do
                    tinsert(sortedList, {spellID, amount, name ~= actorName and name})
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
            return _G.Details_ExplosiveOrbs:GetDisplayText(Details:GetCombat(-1):GetCombatNumber(), Actor.my_actor:guid())
        end
        return ""
    ]],
}

-- Public APIs

local displayTemplate = {
    -- Use Short Text
    [true] = {
        -- Only Show Hit
        [true]  = '%2$d',
        [false] = '%d | %d',
    },
    [false] = {
        -- Only Show Hit
        [true]  = L["Hit: "] .. '%2$d',
        [false] = L["Target: "] .. '%d ' .. L["Hit: "] .. '%d',
    },
}

function Engine:GetRecord(combatID, playerGUID)
    if EO.db[combatID] and EO.db[combatID][playerGUID] then
        return EO.db[combatID][playerGUID].target or 0, EO.db[combatID][playerGUID].hit or 0
    end
    return 0, 0
end

function Engine:GetDisplayText(combatID, playerGUID)
    if EO.db[combatID] and EO.db[combatID][playerGUID] then
        return format(
            displayTemplate[EO.plugin.db.useShortText][EO.plugin.db.onlyShowHit],
            EO.db[combatID][playerGUID].target or 0, EO.db[combatID][playerGUID].hit or 0
        )
    end
    return format(displayTemplate[EO.plugin.db.useShortText][EO.plugin.db.onlyShowHit], 0, 0)
end

function Engine:FormatDisplayText(target, hit)
    return format(displayTemplate[EO.plugin.db.useShortText][EO.plugin.db.onlyShowHit], target or 0, hit or 0)
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
        EO.overall = Details:GetCombat(-1):GetCombatNumber()
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

    Details:InstallCustomObject(self.CustomDisplay)
    Details:InstallCustomObject(self.CustomDisplayOverall)
    self:CleanDiscardCombat()
end

do
    local plugin

    local defaults = {
        onlyShowHit = false,
        useShortText = false,
    }

    local buildOptionsPanel = function()
        local frame = plugin:CreatePluginOptionsFrame('DetailsExplosiveOrbsOptionsWindow', 'Details! Explosive Orbs Options', 1)

        local menu = {
            {
                type = 'toggle',
                name = L["Only Show Hit"],
                desc = L["Only show the hit of Explosive Orbs, without target."],
                get = function() return plugin.db.onlyShowHit end,
                set = function(_, _, v) plugin.db.onlyShowHit = v end,
            },
            {
                type = 'toggle',
                name = L["Use Short Text"],
                desc = L["Use short text for Explosive Orbs."],
                get = function() return plugin.db.useShortText end,
                set = function(_, _, v) plugin.db.useShortText = v end,
            },
        }

        local framework = plugin:GetFramework()
        local options_text_template = framework:GetTemplate('font', 'OPTIONS_FONT_TEMPLATE')
        local options_dropdown_template = framework:GetTemplate('dropdown', 'OPTIONS_DROPDOWN_TEMPLATE')
        local options_switch_template = framework:GetTemplate('switch', 'OPTIONS_CHECKBOX_TEMPLATE')
        local options_slider_template = framework:GetTemplate('slider', 'OPTIONS_SLIDER_TEMPLATE')
        local options_button_template = framework:GetTemplate('button', 'OPTIONS_BUTTON_TEMPLATE')

        framework:BuildMenu(
            frame, menu, 15, -75, 360, true, options_text_template, options_dropdown_template,
            options_switch_template, true, options_slider_template, options_button_template
        )
    end

    local OpenOptionsPanel = function()
        if not _G.DetailsExplosiveOrbsOptionsWindow then
            buildOptionsPanel()
        end

        _G.DetailsExplosiveOrbsOptionsWindow:Show()
    end

    local OnDetailsEvent = function(_, event, ...)
        if event == 'DETAILS_STARTED' then
            EO:LoadHooks()
            return
        elseif event == 'PLUGIN_DISABLED' then
            return
        elseif event == 'PLUGIN_ENABLED' then
            return
        end

        EO:OnDetailsEvent(event, ...)
    end

    function EO:InstallPlugin()
        local version = GetAddOnMetadata(addon, 'Version')

        plugin = Details:NewPluginObject('Details_ExplosiveOrbs', _G.DETAILSPLUGIN_ALWAYSENABLED)
        plugin.OpenOptionsPanel = OpenOptionsPanel
        plugin.OnDetailsEvent = OnDetailsEvent
        self.plugin = plugin

        local MINIMAL_DETAILS_VERSION_REQUIRED = 20
        Details:InstallPlugin(
            'TOOLBAR', L["Explosive Orbs"], 2175503, plugin, 'DETAILS_PLUGIN_EXPLOSIVE_ORBS',
            MINIMAL_DETAILS_VERSION_REQUIRED, 'Rhythm', version, defaults
        )

        Details:RegisterEvent(plugin, 'COMBAT_PLAYER_ENTER')
        Details:RegisterEvent(plugin, 'COMBAT_PLAYER_LEAVE')
        Details:RegisterEvent(plugin, 'DETAILS_DATA_RESET')
    end
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

    self:InstallPlugin()
end
