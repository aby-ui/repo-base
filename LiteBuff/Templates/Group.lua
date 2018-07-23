------------------------------------------------------------
-- Group.lua
--
-- Abin
-- 2012/2/01
------------------------------------------------------------

local GetTime = GetTime

local _, addon = ...
local L = addon.L
local templates = addon.templates

local function Button_OnTick(self)
	if self.timersChanged then
		self.timersChanged = nil
		self:UpdateTimer()
	else
		local lastUpdated = self.lastUpdated
		local now = GetTime()
		if not lastUpdated or now - lastUpdated > 2 then
			lastUpdated = now
			self.timersChanged = nil
			self:UpdateTimer()
		else
			self:UpdateText()
		end
	end
end

local function Button_OnRosterChanged(self)
	self.timersChanged = 1
end

local VALID_FLAGS = { SPELL_AURA_APPLIED = 1, SPELL_AURA_REFRESH = 1, SPELL_AURA_REMOVED = 1 }

local function Button_OnCombatLogEvent(self)
    local _, flag, _, _, _, _, _, _, _, _, _, _, aura = CombatLogGetCurrentEventInfo()
	if VALID_FLAGS[flag] and self:CompareAura(aura) then
		Button_OnRosterChanged(self)
	end
end

local function Button_OnEnable(self)
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	Button_OnRosterChanged(self)
end

templates.RegisterTemplate("GROUP", function(button)
	button.OnTick = Button_OnTick
	button.COMBAT_LOG_EVENT_UNFILTERED = Button_OnCombatLogEvent
	button:HookMethod("OnEnable", Button_OnEnable)
	button:HookMethod("OnRosterChanged", Button_OnRosterChanged)
end)