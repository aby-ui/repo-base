--[[
-- File: LibGroupInfo.lua
-- Author: enderneko (enderneko-dev@outlook.com)
-- File Created: 2022/07/29 15:04:31 +0800
-- Last Modified: 2022/10/08 04:55:39 +0800
--]]

local MAJOR, MINOR = "LibGroupInfo", 4
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end -- already loaded

lib.callbacks = LibStub("CallbackHandler-1.0"):New(lib)
if not lib.callbacks then error(MAJOR.." requires CallbackHandler") end

local UPDATE_EVENT = "GroupInfo_Update"
local UPDATE_BASE_EVENT = "GroupInfo_UpdateBase"

local PLAYER_GUID
local RETRY_INTERVAL = 1.5
local MAX_ATTEMPTS = 3
local IS_RETAIL = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
local IS_WRATH = WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC

local debugMode = false
local function Print(...)
    if debugMode then
        print(...)
    end
end

-- store inspect data
local cache = {}
lib.cache = cache

function lib:GetCachedInfo(guid)
    return guid and cache[guid]
end

function lib:GuidToUnit(guid)
    if cache[guid] then
        return cache[guid].unit
    end
end

-- static data
local genders = {"unknown", "male", "female"}
local specData = {}
local specRoles = {
    -- Death Knight
    [250] = "TANK", -- Blood
    [251] = "MELEE", -- Frost
    [252] = "MELEE", -- Unholy
    -- Demon Hunter
    [577] = "MELEE", -- Havoc
    [581] = "TANK", -- Vengeance
    -- Druid
    [102] = "RANGED", -- Balance
    [103] = "MELEE", -- Feral
    [104] = "TANK", -- Guardian
    [105] = "HEALER", -- Restoration
    -- Hunter
    [253] = "RANGED", -- Beast Mastery
    [254] = "RANGED", -- Marksmanship
    [255] = "MELEE", -- Survival
    -- Mage
    [62] = "RANGED", -- Arcane
    [63] = "RANGED", -- Fire
    [64] = "RANGED", -- Frost
    -- Monk
    [268] = "TANK", -- Brewmaster
    [269] = "MELEE", -- Windwalker
    [270] = "HEALER", -- Mistweaver
    -- Paladin
    [65] = "HEALER", -- Holy
    [66] = "TANK", -- Protection
    [70] = "MELEE", -- Retribution
    -- Priest
    [256] = "HEALER", -- Discipline
    [257] = "HEALER", -- Holy
    [258] = "RANGED", -- Shadow
    -- Rogue
    [259] = "MELEE", -- Assassination
    [260] = "MELEE", -- Combat
    [261] = "MELEE", -- Subtlety
    -- Shaman
    [262] = "RANGED", -- Elemental
    [263] = "MELEE", -- Enhancement
    [264] = "HEALER", -- Restoration
    -- Warlock
    [265] = "RANGED", -- Affliction
    [266] = "RANGED", -- Demonology
    [267] = "RANGED", -- Destruction
    -- Warrior
    [71] = "MELEE", -- Arms
    [72] = "MELEE", -- Fury
    [73] = "TANK", -- Protection
}

lib.specData = specData
lib.specRoles = specRoles

-- functions
local NotifyInspect = NotifyInspect
local UnitGUID = UnitGUID
local UnitClassBase = UnitClassBase
local UnitIsUnit = UnitIsUnit
local UnitIsDead = UnitIsDead
local UnitIsConnected = UnitIsConnected
local UnitIsVisible = UnitIsVisible
local CanInspect = CanInspect
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetInspectSpecialization = GetInspectSpecialization
local UnitNameUnmodified = UnitNameUnmodified
local GetNormalizedRealmName = GetNormalizedRealmName
local UnitLevel = UnitLevel
local UnitRace = UnitRace
local UnitSex = UnitSex
local IsInRaid = IsInRaid
local IsInGroup = IsInGroup
local GetNumGroupMembers = GetNumGroupMembers
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid

local GetNumTalentTabs = GetNumTalentTabs
local GetTalentTabInfo = GetTalentTabInfo

-- event frame
local frame = CreateFrame("Frame", MAJOR.."Frame")
frame:Hide()
frame:RegisterEvent("PLAYER_LOGIN")
-- frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

-- prepare spec data (name, icon, role)
local function CacheSpecData()
    for classId = 1, GetNumClasses() do
        for specIndex = 1, GetNumSpecializationsForClassID(classId) do
            local id, name, description, icon, role = GetSpecializationInfoForClassID(classId, specIndex)
            specData[id] = {
                ["name"] = name,
                ["icon"] = icon,
                ["role"] = specRoles[id],
            }
        end
    end
end

local function UpdateBaseInfo(unit, guid)
    if not cache[guid] then cache[guid] = {} end
    if IS_WRATH then
        if not cache[guid]["talents"] then
            cache[guid]["talents"] = {}
        end
    end

    -- general
    cache[guid].unit = unit
    cache[guid].name, cache[guid].realm = UnitNameUnmodified(unit)
    if not cache[guid].realm then
        cache[guid].realm = GetNormalizedRealmName()
    end
    cache[guid].class = UnitClassBase(unit)
    cache[guid].level = UnitLevel(unit)
    cache[guid].race = select(2, UnitRace(unit))
    cache[guid].gender = genders[UnitSex(unit)]
    cache[guid].faction = UnitFactionGroup(unit)

    --! fire
    lib.callbacks:Fire(UPDATE_BASE_EVENT, guid, unit, cache[guid])

    return guid
end

local function BuildAndNotify(unit)
    Print("|cffff7777LGI:BuildAndNotify|r", unit)

    local guid = UnitGUID(unit)
    UpdateBaseInfo(unit, guid)

    local specId, role
    
    if UnitIsUnit(unit, "player") then
        local specIndex = GetSpecialization()
        specId, _, _, _, role = GetSpecializationInfo(specIndex)
    else
        specId = GetInspectSpecialization(unit)
        role = select(5, GetSpecializationInfoByID(specId))
        -- if not (UnitIsConnected(unit) or UnitIsVisible(unit)) then
        --     cache[guid].notVisible = true
        -- else
        --     cache[guid].notVisible = nil
        -- end
    end

    cache[guid].role = role
    
    -- spec
    if specId and specData[specId] then
        cache[guid].specId = specId
        cache[guid].specName = specData[specId].name
        cache[guid].specRole = specData[specId].role
        cache[guid].specIcon = specData[specId].icon
    else
        cache[guid].specId = 0
    end
        
    --! fire
    lib.callbacks:Fire(UPDATE_EVENT, guid, unit, cache[guid])
end

local function BuildAndNotify_Wrath(unit)
    Print("|cffff7777LGI:BuildAndNotify_Wrath|r", unit)

    local guid = UnitGUID(unit)
    UpdateBaseInfo(unit, guid)

    -- spec
    local isInspect = not UnitIsUnit(unit, "player")
    local maxPoints = 0

    if isInspect then
        for i = 1, GetNumTalentTabs(true) do
            local name, texture, pointsSpent, fileName = GetTalentTabInfo(i, true, false)
            cache[guid]["talents"][fileName] = {
                ["points"] = pointsSpent,
                ["name"] = name,
                ["icon"] = texture,
            }
            
            if pointsSpent > maxPoints then
                maxPoints = pointsSpent
                cache[guid].specName = name
                cache[guid].specIcon = texture
            end
        end
    else
        for i = 1, GetNumTalentTabs() do
            local name, texture, pointsSpent, fileName = GetTalentTabInfo(i)
            cache[guid]["talents"][fileName] = {
                ["points"] = pointsSpent,
                ["name"] = name,
                ["icon"] = texture,
            }
            
            if pointsSpent > maxPoints then
                maxPoints = pointsSpent
                cache[guid].specName = name
                cache[guid].specIcon = texture
            end
        end
    end

    --! fire
    lib.callbacks:Fire(UPDATE_EVENT, guid, unit, cache[guid])
end

local function Query(unit)
    -- if InCombatLockdown() then return end
    if UnitIsDead("player") then return end

    if IsInGroup() and not (UnitInParty(unit) or UnitInRaid(unit)) then return end
    
    if IS_RETAIL then
        BuildAndNotify(unit)
    else
        BuildAndNotify_Wrath(unit)
    end
end

---------------------------------------------------------------------
-- login & reload
---------------------------------------------------------------------
function frame:PLAYER_LOGIN()
    PLAYER_GUID = UnitGUID("player")
    
    if IS_RETAIL then
        cache[PLAYER_GUID] = {}
        CacheSpecData()
        frame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
    else
        cache[PLAYER_GUID] = {["talents"]={}}
        -- frame:RegisterEvent("UNIT_AURA")
    end

    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:RegisterEvent("PLAYER_REGEN_DISABLED")
    frame:RegisterEvent("INSPECT_READY")
    frame:RegisterEvent("GROUP_ROSTER_UPDATE")
    frame:RegisterEvent("UNIT_LEVEL")
    frame:RegisterEvent("UNIT_NAME_UPDATE")
    -- frame:RegisterEvent("UNIT_PHASE")
    -- frame:RegisterEvent("PARTY_MEMBER_ENABLE")
end

function frame:PLAYER_ENTERING_WORLD(isLogin, isReload)
    if isLogin or isReload then
        -- update self
        Query("player")

        -- update group
        frame:GROUP_ROSTER_UPDATE()
    end
end

---------------------------------------------------------------------
-- inspection queue
---------------------------------------------------------------------
local order = {}
lib.order = order
local queue = {}
lib.queue = queue
local elapsedTime = 0
frame:SetScript("OnUpdate", function(self, elapsed)
    elapsedTime = elapsedTime + elapsed
    if elapsedTime >= 0.25 then
        elapsedTime = 0
        local guid = order[1]
        if guid then
            if queue[guid] then
                if queue[guid].status == "waiting" then
                    queue[guid].status = "requesting"
                    queue[guid].attempts = queue[guid].attempts + 1
                    queue[guid].lastRequest = time()
                    NotifyInspect(queue[guid].unit)
                elseif queue[guid].status == "requesting" then -- give it another shot
                    if queue[guid].attempts < MAX_ATTEMPTS then
                        if time() - queue[guid].lastRequest >= RETRY_INTERVAL then
                            queue[guid].attempts = queue[guid].attempts + 1
                            queue[guid].lastRequest = time()
                            NotifyInspect(queue[guid].unit)
                        end
                    else -- reach max attempts
                        tremove(order, 1)
                        queue[guid] = nil
                    end
                end
            else -- INSPECT_READY
                tremove(order, 1)
            end 
        else -- none left
            frame:Hide()
            wipe(order)
            wipe(queue)
        end
    end
end)

local function AddToQueue(unit, guid)
    if IS_WRATH then
        if not UnitIsConnected(unit) or not CheckInteractDistance(unit, 1) or not CanInspect(unit) then
            UpdateBaseInfo(unit, guid)
            return
        end
    else
        if not UnitIsConnected(unit) or not CanInspect(unit) then
            UpdateBaseInfo(unit, guid)
            return
        end
    end
    
    Print("|cffffff33LGI:|r", "AddToQueue", guid, unit)
    queue[guid] = {
        ["unit"] = unit,
        ["attempts"] = 0,
        ["status"] = "waiting",
    }
    tinsert(order, guid)

    if not InCombatLockdown() then
        frame:Show()
    end
end

---------------------------------------------------------------------
-- INSPECT_READY: ready to query
---------------------------------------------------------------------
function frame:INSPECT_READY(guid)
    if queue[guid] then
        Print("|cffffff33LGI:|r", "INSPECT_READY", guid, queue[guid].unit)
        Query(queue[guid].unit)
        queue[guid] = nil
    end
end

---------------------------------------------------------------------
-- GROUP_ROSTER_UPDATE: update queue
---------------------------------------------------------------------
local wasInGroup
function frame:GROUP_ROSTER_UPDATE()
    cache[PLAYER_GUID].unit = "player"
    
    if IsInRaid() then
        wasInGroup = true
        for i = 1, GetNumGroupMembers() do
            local unit = "raid"..i
            local guid = UnitGUID(unit)
            if not (UnitIsUnit(unit, "player") or cache[guid] or queue[guid]) then
                AddToQueue(unit, guid)
            end
        end
        cache[PLAYER_GUID].unit = "raid"..UnitInRaid("player")
        
    elseif IsInGroup() then
        wasInGroup = true
        for i = 1, GetNumGroupMembers()-1 do
            local unit = "party"..i
            local guid = UnitGUID(unit)
            if not (cache[guid] or queue[guid]) then
                AddToQueue(unit, guid)
            end
        end
        
    elseif wasInGroup then
        wasInGroup = nil
        for guid in pairs(cache) do
            if guid ~= PLAYER_GUID then
                cache[guid] = nil
            end
        end
        frame:Hide()
        wipe(queue)
        wipe(order)
    end
end

---------------------------------------------------------------------
-- other events: update
---------------------------------------------------------------------
function frame:PLAYER_SPECIALIZATION_CHANGED(unit)
    if not UnitIsPlayer(unit) then return end
    if strfind(unit, "target") or strfind(unit, "nameplate") then return end

    if UnitIsUnit(unit, "player") then
        Query(unit)
    else
        local guid = UnitGUID(unit)
        if queue[guid] then
            queue[guid].attempts = 0 -- reset attempts if exists in queue
        else
            AddToQueue(unit, guid)
        end
    end
end

function frame:UNIT_NAME_UPDATE(unit)
    frame:PLAYER_SPECIALIZATION_CHANGED(unit)
end

-- function frame:UNIT_PHASE(unit)
--     frame:PLAYER_SPECIALIZATION_CHANGED(unit)
-- end

function frame:PARTY_MEMBER_ENABLE(unit)
    frame:PLAYER_SPECIALIZATION_CHANGED(unit)
end

function frame:UNIT_LEVEL(unit)
    local guid = UnitGUID(unit)
    if cache[guid] then
        cache[guid].level = UnitLevel(unit)
    end
end

-- local lastUpdate = {}
-- function frame:UNIT_AURA(unit)
--     print(unit)
--     if InCombatLockdown() then return end
--     if not (strfind(unit, "^party") or strfind(unit, "^raid")) then return end
--     if not UnitIsPlayer(unit) then return end

--     local guid = UnitGUID(unit)
--     if not lastUpdate[guid] or GetTime() - lastUpdate[guid] > 600 then
--         lastUpdate[guid] = GetTime()
--         AddToQueue(unit, guid)
--     end
-- end

---------------------------------------------------------------------
-- combat check
---------------------------------------------------------------------
function frame:PLAYER_REGEN_ENABLED()
    if #order ~= 0 then
        frame:Show()
    end
end

function frame:PLAYER_REGEN_DISABLED()
    frame:Hide()
end