--[[
	the main controller of dominos progress
--]]

local AddonName, Addon = ...
local Dominos = LibStub('AceAddon-3.0'):GetAddon('Dominos')
local CastBarModule = Dominos:NewModule('CastBar')

function CastBarModule:OnInitialize()
	_G.CastingBarFrame.ignoreFramePositionManager = true
	_G.CastingBarFrame:UnregisterAllEvents()
	_G.PetCastingBarFrame:UnregisterAllEvents()
end

function CastBarModule:Load()
	self.frame = Addon.CastBar:New('cast_new', {'player', 'vehicle'})
end

function CastBarModule:Unload()
	if self.frame then
		self.frame:Free()
		self.frame = nil
	end
end

local MirrorTimerModule = Dominos:NewModule("MirrorTimer", "AceEvent-3.0")

local MIRRORTIMER_NUMTIMERS = MIRRORTIMER_NUMTIMERS
function MirrorTimerModule:OnInitialize()
    --[===[@debug@
    MirrorTimer1:ClearAllPoints()
    MirrorTimer1:SetPoint("TOP", 0, -200)
    --@end-debug@]===]
    --@non-debug@
    for i = 1, MIRRORTIMER_NUMTIMERS do _G["MirrorTimer" .. i]:UnregisterAllEvents() end
	UIParent:UnregisterEvent("MIRROR_TIMER_START")
	--@end-non-debug@
end

function MirrorTimerModule:Load()
    self.bars = {}
    for i = 1, MIRRORTIMER_NUMTIMERS do self.bars[i] = Addon.MirrorTimer:New(i) end

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("MIRROR_TIMER_START")

    self:PLAYER_ENTERING_WORLD()
end

function MirrorTimerModule:Unload()
    self:UnregisterAllEvents()

    if self.bars then for i = 1, #self.bars do self.bars[i]:Free() end end
    self.bars = nil
end

---@param event string
---@param isInitialLogin boolean
---@param isReloadingUi boolean
function MirrorTimerModule:PLAYER_ENTERING_WORLD(event, isInitialLogin, isReloadingUi)
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local bar = self.bars[i]
        local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
        if timer ~= "UNKNOWN" then
            bar:Start(timer, value, maxvalue, scale, paused, label)
        else
            bar:Reset()
        end
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
    for i = 1, MIRRORTIMER_NUMTIMERS do
        local bar = self.bars[i]

        if bar.timer == timerName then
            bar:Start(timerName, value, maxValue, scale, paused, timerLabel)
            return
        end
    end

    for i = 1, MIRRORTIMER_NUMTIMERS do
        local bar = self.bars[i]

        if not bar.timer then
            bar:Start(timerName, value, maxValue, scale, paused, timerLabel)
            return
        end
    end
end
