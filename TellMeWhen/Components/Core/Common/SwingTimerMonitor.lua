-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------

-- This code is inspiried by Whammy! by Olidaine/Oddjorb [Argent Dawn]

--[[

-- To use the module, access SwingTimerMonitor.SwingTimers[weaponSlot]
-- where weaponSlot is either MAINHAND_SLOT or OFFHAND_SLOT (currently 16 or 17)
-- to get a SwingTimer object. Use the SwingTimer.duration and SwingTimer.startTime
-- to get data about it, and use event TMW_COMMON_SWINGTIMER_CHANGED to listen for swing time starts

]]

if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print


local strsub, pairs
	= strsub, pairs
local UnitGUID, GetNetStats, GetInventorySlotInfo, IsDualWielding, UnitAttackSpeed
	= UnitGUID, GetNetStats, GetInventorySlotInfo, IsDualWielding, UnitAttackSpeed

-- Module creation
TMW.COMMON.SwingTimerMonitor = CreateFrame("Frame")

-- Constants
local MAINHAND_SLOT = GetInventorySlotInfo("MainHandSlot")
local OFFHAND_SLOT = GetInventorySlotInfo("SecondaryHandSlot")

-- Upvalues
local SwingTimers
local SwingTimerMonitor = TMW.COMMON.SwingTimerMonitor

-- Initialize module-wide variables
SwingTimerMonitor.DualWield = nil
SwingTimerMonitor.Latency = 0
SwingTimerMonitor.Initialized = false



-- ---------------------------------
-- Swing update functions
-- ---------------------------------

local function MainHandEvent()
	local _, event, _, src_guid = CombatLogGetCurrentEventInfo()

	if strsub(event, 1, 5) == "SWING" and src_guid == UnitGUID("player") then
		SwingTimers[MAINHAND_SLOT]:Start()
	end
end

local function DualWieldEvent()
	local _, event, _, src_guid = CombatLogGetCurrentEventInfo()

	-- Dual wield is done all funky like this because
	-- the combat log doesn't distinguish between MH and OH hits.
	-- we have to guess at what weapon it was that was hit based on the current swing timers.
	if strsub(event, 1, 5) == "SWING" and src_guid == UnitGUID("player") then
		
		for slot, frame in pairs(SwingTimers) do
			frame:CheckTime()
		end
		
		-- This handles the case when lag throws timers out of sync.
		-- Both timers get reset, and they should work themselves out within a few swings
		if SwingTimers[MAINHAND_SLOT].active and SwingTimers[OFFHAND_SLOT].active then
			SwingTimers[MAINHAND_SLOT].active = false
			SwingTimers[OFFHAND_SLOT].active = false
		end
			
		if SwingTimers[MAINHAND_SLOT].active then
			SwingTimers[OFFHAND_SLOT]:Start()
		else
			SwingTimers[MAINHAND_SLOT]:Start()
		end
			
	end
end


-- ---------------------------------
-- Misc state update functions
-- ---------------------------------

local function SetLatency()
	local _, _, Latency = GetNetStats()
	
	SwingTimerMonitor.Latency = Latency / 1000
end

local function InventoryWatch()
	local wasDualWield = SwingTimerMonitor.DualWield
	
	SwingTimerMonitor.DualWield = IsDualWielding()
		
	if SwingTimerMonitor.DualWield ~= wasDualWield then
	
		if SwingTimerMonitor.DualWield then
			SwingTimerMonitor.EventFunc = DualWieldEvent
		else
			SwingTimerMonitor.EventFunc = MainHandEvent
		end
	
		for slot, SwingTimer in pairs(SwingTimers) do
			SwingTimer:Reset()
			SwingTimer:FireChanged()
		end
	end
	
end



-- ---------------------------------
-- SwingTimer class
-- ---------------------------------

local SwingTimer = TMW:NewClass("SwingTimer"){

	active = false,
	duration = 0,
	startTime = 0,
	
	OnNewInstance_SwingTimer = function(self, slot)
		self.slot = slot
		
		SwingTimers[slot] = self
	end,
	
	GetSwingEndTime = function(self)
		return self.startTime + self.duration
	end,
	
	CheckTime = function(self)
		local elapsed = TMW.time - self.startTime
		
		-- It should be safe at the current time to allow the timer to be
		-- overwritten with the next swing that is seen, so set it as inactive.
		if elapsed > (self.duration - SwingTimerMonitor.Latency) then
			self.active = false
		end
		
		-- The time that has passed since the duration of the last swing
		-- has exceeded the swing timer, so reset it.
		if elapsed > self.duration then
			self:Reset()
		end
		
		-- Notify any interested implementers
		self:FireChanged()
	end,
	
	FireChanged = function(self)
		TMW:Fire("TMW_COMMON_SWINGTIMER_CHANGED", self)
	end,
	
	Reset = function(self)
		self.active = false
	end,
	
	Start = function(self)
		self:Reset()
	
		self:SetSwingSpeed()
		SetLatency()
		
		self.active = true
		self.startTime = TMW.time
		
		self:CheckTime()
	end,
	

	SetSwingSpeed = function(self)
		local mainhand, offhand = UnitAttackSpeed("player")
		
		if SwingTimerMonitor.DualWield and self.slot == OFFHAND_SLOT then
			self.duration = offhand
		else
			self.duration = mainhand
		end
	end,
}


SwingTimerMonitor:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_INVENTORY_CHANGED" and ... == "player" then
		InventoryWatch()
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		if SwingTimerMonitor.EventFunc then
			SwingTimerMonitor.EventFunc(self, event)
		end
	end
end)


SwingTimerMonitor.SwingTimers = setmetatable({},
{__index = function(self, k)

	-- THIS TMW COMMON MODULE IS INITIALIZED HERE
	
	setmetatable(self, nil)
	
	-- Create the swing timers
	SwingTimer:New(MAINHAND_SLOT)
	SwingTimer:New(OFFHAND_SLOT)
	
	SwingTimerMonitor:RegisterEvent("UNIT_INVENTORY_CHANGED")
	SwingTimerMonitor:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

	InventoryWatch()

	SwingTimerMonitor.Initialized = true

	return SwingTimers[k]
end}) SwingTimers = SwingTimerMonitor.SwingTimers
