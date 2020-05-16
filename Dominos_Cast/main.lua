--[[
	the main controller of dominos progress
--]]
local _, Addon = ...
local Dominos = LibStub("AceAddon-3.0"):GetAddon("Dominos")
local CastBarModule = Dominos:NewModule("CastBar")

function CastBarModule:OnInitialize()
    CastingBarFrame:UnregisterAllEvents()
    PetCastingBarFrame:UnregisterAllEvents()
    CastingBarFrame.ignoreFramePositionManager = true
end

function CastBarModule:Load()
    self.frame = Addon.CastBar:New("cast_new", {"player", "vehicle"})
end

function CastBarModule:Unload()
    if self.frame then
        self.frame:Free()
        self.frame = nil
    end
end

local MirrorTimerModule = Dominos:NewModule("MirrorTimer", "AceEvent-3.0")

function MirrorTimerModule:OnInitialize()
    UIParent:UnregisterEvent("MIRROR_TIMER_START")

    for i = 1, MIRRORTIMER_NUMTIMERS do
        local timer = _G["MirrorTimer" .. i]
        if timer then
            timer:UnregisterAllEvents()
            timer:Hide()
        end
    end
end

function MirrorTimerModule:Load()
    self.bars = {}

    for i = 1, MIRRORTIMER_NUMTIMERS do
        tinsert(self.bars, Addon.MirrorTimer:New(i))
    end

    self:RegisterEvent("MIRROR_TIMER_PAUSE")
    self:RegisterEvent("MIRROR_TIMER_START")
    self:RegisterEvent("MIRROR_TIMER_STOP")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "UpdateTimers")
    self:UpdateTimers()
end

function MirrorTimerModule:Unload()
    self:UnregisterAllEvents()

    for _, bar in pairs(self.bars) do
        bar:Free()
    end

    self.bars = nil
end

---@param event string
---@param isInitialLogin boolean
---@param isReloadingUi boolean
function MirrorTimerModule:UpdateTimers()
    for _, bar in pairs(self.bars) do
        bar:Update()
    end
end

---@param event string
---@param timerName string
---@param value number
---@param maxValue number
---@param scale number
---@param paused number
---@param timerLabel string
function MirrorTimerModule:MIRROR_TIMER_START(event, timerName, value, maxValue, scale, paused, timerLabel)
    for _, bar in ipairs(self.bars) do
        if bar:Start(timerName, value, maxValue, scale, paused, timerLabel) then
            return
        end
    end
end

---@param timerName string
---@param paused number
function MirrorTimerModule:MIRROR_TIMER_PAUSE(event, timerName, paused)
    for _, bar in ipairs(self.bars) do
        if bar:Pause(timerName, paused) then
            return
        end
    end
end

---@param timerName string
function MirrorTimerModule:MIRROR_TIMER_STOP(event, timerName)
    for _, bar in ipairs(self.bars) do
        if bar:Stop(timerName) then
            return
        end
    end
end
