--- Kaliel's Tracker
--- Copyright (c) 2012-2020, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- This file is part of addon Kaliel's Tracker.

local addonName, KT = ...
local L = KT.L
local M = KT:NewModule(addonName.."_IcecrownRares")
KT.IcecrownRares = M

local _DBG = function(...) if _DBG then _DBG("KT", ...) end end

-- Lua API
local difftime = difftime
local floor = math.floor
local fmod = math.fmod
local ipairs = ipairs
local tinsert = table.insert

local db, dbChar
local OTF = ObjectiveTrackerFrame

local timer = 0
local timerDuration = 5
local eventMapID = 118  -- Icecrown
local mapPoint

local eventFrame
local header, content

OBJECTIVE_TRACKER_UPDATE_MODULE_ICECROWN_RARES = 0x400000
ICECROWN_RARES_TRACKER_MODULE = ObjectiveTracker_GetModuleInfoTable("ICECROWN_RARES_TRACKER_MODULE")

--------------
-- Internal --
--------------

local timeZero = time({ year=2020, month=11, day=11, hour=9 })
local rares = {
    { "Prince Keleseth", { 54.0, 44.7 } },
    { "The Black Knight", { 64.8, 22.1 } },
    { "Bronjahm", { 70.7, 38.4 }, "(34 slot Bag)" },
    { "Scourgelord Tyrannus", { 47.2, 66.1 } },
    { "Forgemaster Garfrost", { 58.6, 72.5 } },
    { "Marwyn", { 58.2, 83.4 } },
    { "Falric", { 50.2, 87.9 } },
    { "The Prophet Tharon'ja", { 80.1, 61.2 } },
    { "Novos the Summoner", { 77.8, 66.1 } },
    { "Trollgore", { 58.3, 39.4 } },
    { "Krik'thir the Gatewatcher", { 67.5, 58.0 } },
    { "Prince Taldaram", { 29.6, 62.2 } },
    { "Elder Nadox", { 44.2, 49.1 } },
    { "Noth the Plaguebringer", { 31.6, 70.5 } },
    { "Patchwerk", { 34.4, 68.5 } },
    { "Blood Queen Lana'thel", { 49.7, 32.7 } },
    { "Professor Putricide", { 57.1, 30.3 } },
    { "Lady Deathwhisper", { 51.1, 78.5 } },
    { "Skadi the Ruthless", { 57.8, 56.1 }, "(Mount)" },
    { "Ingvar the Plunderer", { 52.4, 52.6 } },
}
local numRares = #rares

local function IcecrownRaresTrackerModule_OnUpdate(self, elapsed)
    if not M.used then return end
    timer = timer + elapsed
    if timer >= timerDuration then
        ObjectiveTracker_Update(OBJECTIVE_TRACKER_UPDATE_MODULE_ICECROWN_RARES)
        timer = 0
    end
end

local function SendRareInfo(name, x, y)
    SendChatMessage(format(L"Next Rare... %s at [%.1f, %.1f] %s", name, x, y, C_Map.GetUserWaypointHyperlink()), "CHANNEL", nil, 1)
end

local SetWaypoint = function(self, button)
    if button == "LeftButton" then
        local x, y = unpack(rares[self.id][2])
        if IsModifiedClick("CHATLINK") then
            if not mapPoint then
                local point = UiMapPoint.CreateFromCoordinates(eventMapID, x/100, y/100)
                C_Map.SetUserWaypoint(point)
            end
            SendRareInfo(rares[self.id][1], x, y)
            if not mapPoint then
                C_Map.ClearUserWaypoint()
            end
            PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
        else
            PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CLICK_TO_PLACE)
            mapPoint = UiMapPoint.CreateFromCoordinates(eventMapID, x/100, y/100)
            C_Map.SetUserWaypoint(mapPoint)
            C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        end
    elseif button == "RightButton" then
        C_Map.ClearUserWaypoint()
        C_SuperTrack.SetSuperTrackedUserWaypoint(false)
        PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE)
        mapPoint = nil
    end
end

if IsAddOnLoaded("TomTom") then
    SetWaypoint = function(self, button)
        if button == "LeftButton" then
            local x, y = unpack(rares[self.id][2])
            if IsModifiedClick("CHATLINK") then
                local point = UiMapPoint.CreateFromCoordinates(eventMapID, x/100, y/100)
                C_Map.SetUserWaypoint(point)
                SendRareInfo(rares[self.id][1], x, y)
                C_Map.ClearUserWaypoint()
                PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CHAT_SHARE)
            else
                PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_CLICK_TO_PLACE)
                local mapID = KT.GetCurrentMapAreaID()
                if mapID == eventMapID then
                    if mapID and x and y then
                        mapPoint = TomTom:AddWaypoint(mapID, x/100, y/100, {
                            title = rares[self.id][1],
                            from = KT.title,
                        })
                    end
                end
            end
        elseif button == "RightButton" then
            if mapPoint then
                TomTom:RemoveWaypoint(mapPoint)
                PlaySound(SOUNDKIT.UI_MAP_WAYPOINT_REMOVE)
                mapPoint = nil
            end
        end
    end
end

local function IcecrownRaresTrackerModule_OnMouseUp(self, button)
    SetWaypoint(self, button)
end

local function IcecrownRaresTrackerModule_SetUsed()
    M.used = true
    if KT.inInstance then
        M.used = false
    elseif db.sIcecrownRaresOnlyInZone then
        local mapID = KT.GetCurrentMapAreaID()
        M.used = (mapID == eventMapID)  -- Icecrown
    end
    if M.used and dbChar.collapsed then
        ObjectiveTracker_MinimizeButton_OnClick()
    end
end

local function SetFrames()
    -- Event frame
    eventFrame = CreateFrame("Frame")
    eventFrame:SetScript("OnEvent", function(self, event)
        _DBG("Event - "..event, true)
        if event == "PLAYER_ENTERING_WORLD" then
            IcecrownRaresTrackerModule_SetUsed()
            self:UnregisterEvent(event)
        elseif event == "ZONE_CHANGED_NEW_AREA" then
            IcecrownRaresTrackerModule_SetUsed()
        end
    end)
    eventFrame:SetScript("OnUpdate", IcecrownRaresTrackerModule_OnUpdate)
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

    -- Header frame
    header = CreateFrame("Frame", nil, OTF.BlocksFrame, "ObjectiveTrackerHeaderTemplate")
    header:Hide()

    -- Content frame
    content = CreateFrame("Frame", nil, OTF.BlocksFrame)
    content:SetSize(232 - ICECROWN_RARES_TRACKER_MODULE.blockOffset[ICECROWN_RARES_TRACKER_MODULE.blockTemplate][1], 10)
    content:Hide()
    content.texture = content:CreateTexture()
    content.texture:SetAtlas("legioninvasion-map-icon-portal-large")
    content.texture:SetSize(35, 37)
    content.texture:SetPoint("TOPLEFT", -40, 0)
    content:SetScript("OnMouseUp", IcecrownRaresTrackerModule_OnMouseUp)
end

local function SetHooks()
    hooksecurefunc("ObjectiveTracker_Initialize", function(self)
        tinsert(self.MODULES, ICECROWN_RARES_TRACKER_MODULE)
        tinsert(self.MODULES_UI_ORDER, ICECROWN_RARES_TRACKER_MODULE)
        tinsert(KT.ALL_BLIZZARD_MODULES, "ICECROWN_RARES_TRACKER_MODULE")
    end)
end

--------------
-- External --
--------------

function ICECROWN_RARES_TRACKER_MODULE:GetBlock()
    local block = content
    block.module = self
    block.used = true
    block.height = 0
    block.lineWidth = OBJECTIVE_TRACKER_TEXT_WIDTH - self.blockOffset[self.blockTemplate][1]
    block.currentLine = nil
    if block.lines then
        for _, line in ipairs(block.lines) do
            line.used = nil
        end
    else
        block.lines = {}
    end
    return block
end

function ICECROWN_RARES_TRACKER_MODULE:MarkBlocksUnused()
    content.used = nil
end

function ICECROWN_RARES_TRACKER_MODULE:FreeUnusedBlocks()
    if not content.used then
        content:Hide()
    end
end

function ICECROWN_RARES_TRACKER_MODULE:Update()
    self:BeginLayout()

    if not M.used then
        self:EndLayout()
        return
    end

    local block = self:GetBlock()
    local secDiff = difftime(time(), timeZero) - db.sIcecrownRaresTimerCorrection
    local minDiff = secDiff / 60
    local numPastRares = floor(minDiff / 20) + 1
    local nextRareIndex = fmod(numPastRares, numRares) + 1
    local nextRareRemainTimeSec = 1200 - fmod(secDiff, 1200)
    local nextRareRemainTime = SecondsToTime(nextRareRemainTimeSec)
    local nextRareInfo = rares[nextRareIndex][3] and " |cff00ff00"..rares[nextRareIndex][3] or ""

    self:AddObjective(block, 0, L"Next Rare:", nil, nil, OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE, OBJECTIVE_TRACKER_COLOR["Label"])
    self:AddObjective(block, 1, rares[nextRareIndex][1]..nextRareInfo, nil, nil, OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE)
    self:AddObjective(block, 2, nextRareRemainTime, nil, nil, OBJECTIVE_DASH_STYLE_HIDE_AND_COLLAPSE, OBJECTIVE_TRACKER_COLOR["TimeLeft2"])

    if block.height < 38 then
        block.height = 38
    end
    block:SetHeight(block.height)
    if ObjectiveTracker_AddBlock(block) then
        block:Show()
        self:FreeUnusedLines(block)
        block.texture:SetPoint("LEFT", -40, -2)
    else
        block.used = false
    end
    content.id = nextRareIndex

    timerDuration = nextRareRemainTimeSec <= 60 and 1 or 5

    self:EndLayout()
end

function M:OnInitialize()
    _DBG("|cffffff00Init|r - "..self:GetName(), true)
    db = KT.db.profile
    dbChar = KT.db.char
    self.isLoaded = (db.sIcecrownRares)
    self.used = false

    if self.isLoaded then
        tinsert(KT.db.defaults.profile.modulesOrder, "ICECROWN_RARES_TRACKER_MODULE")
        KT.db:RegisterDefaults(KT.db.defaults)
    else
        for i, module in ipairs(db.modulesOrder) do
            if module == "ICECROWN_RARES_TRACKER_MODULE" then
                tremove(db.modulesOrder, i)
                break
            end
        end
    end
end

function M:OnEnable()
    _DBG("|cff00ff00Enable|r - "..self:GetName(), true)
    ICECROWN_RARES_TRACKER_MODULE.blockOffset[ICECROWN_RARES_TRACKER_MODULE.blockTemplate][1] = 30

    SetFrames()
    SetHooks()

    ICECROWN_RARES_TRACKER_MODULE.updateReasonModule = OBJECTIVE_TRACKER_UPDATE_ALL
    ICECROWN_RARES_TRACKER_MODULE.updateReasonEvents = OBJECTIVE_TRACKER_UPDATE_ALL
    ICECROWN_RARES_TRACKER_MODULE:SetHeader(header, L"Icecrown Rares")
end

function M:SetUsed()
    IcecrownRaresTrackerModule_SetUsed()
end

function M:IsShown()
    return (self.isLoaded and self.used)
end