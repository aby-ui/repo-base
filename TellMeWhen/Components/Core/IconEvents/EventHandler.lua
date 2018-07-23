-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

TMW.EVENTS = {}
local EVENTS = TMW.EVENTS
LibStub("AceTimer-3.0"):Embed(EVENTS)


TMW.Icon_Defaults.Events = {
	n					= 0,
	["**"] 				= {
		OnlyShown 		= false,
		Operator 		= "<",
		Value 			= 0,
		CndtJustPassed 	= false,
		PassingCndt		= false,
		PassThrough		= true,
		Frequency		= 1,
		Event			= "", -- the event being handled (e.g "OnDurationChanged")
		Type			= "", -- the event handler handling the event (e.g. "Sound")
	},
}


TMW:RegisterUpgrade(70077, {
	-- OnIconShow and OnIconShow were removed in favor of using OnCondition
	iconEventHandler = function(self, eventSettings)
		local conditions = eventSettings.OnConditionConditions

		if eventSettings.Event == "OnIconShow" then
			eventSettings.Event = "OnCondition"
			-- Reset conditions just in case
			wipe(conditions)
			conditions.n = 1

			local condition = conditions[1]
			condition.Type = "ICON"
			condition.Icon = eventSettings.Icon or ""
			condition.Level = 0
		elseif eventSettings.Event == "OnIconHide" then
			eventSettings.Event = "OnCondition"
			-- Reset conditions just in case
			wipe(conditions)
			conditions.n = 1

			local condition = conditions[1]
			condition.Type = "ICON"
			condition.Icon = eventSettings.Icon or ""
			condition.Level = 1
		end
		eventSettings.Icon = nil
	end,
})
TMW:RegisterUpgrade(50020, {
	-- Upgrade from the old event system that only allowed one event of each type per icon.
	icon = function(self, ics)
		local Events = ics.Events

		local EventsCopy = CopyTable(Events)

		-- If the value of ["n"] is a table (it might have happened accidentally),
		-- reset it to a number so we can start incrementing it.
		if type(rawget(Events, "n") or 0) == "table" then
			Events.n = 0
		end

		-- Dont use InNLengthTable here, because n was not used as the length key for the old settings.
		-- We copy the table because we will start modifying it in the loop.
		for event, eventSettings in pairs(EventsCopy) do
			-- Events used to be stored in this table using keys being the event.
			-- After this upgrade, they are stored with sequential indicies, and event is stored inside eventSettings.
			if type(event) == "string" and event ~= "n" then
				local addedAnEvent
				for identifier, EventHandler in pairs(TMW.Classes.EventHandler.instancesByName) do

					-- Check that these eventSettings have data for the handler.
					local hasHandlerOfType = EventHandler:ProcessIconEventSettings(event, eventSettings)
					if hasHandlerOfType then
						-- Increment n so it keeps accurate to the data.
						Events.n = (rawget(Events, "n") or 0) + 1

						-- Clone the old eventSettings because they might get used again for another handler.
						Events[Events.n] = CopyTable(eventSettings)

						-- Set the new fields that are needed to keep the eventSettings associated with the
						-- proper event and handler.
						Events[Events.n].Type = identifier
						Events[Events.n].Event = event
						Events[Events.n].PassThrough = true

						addedAnEvent = true
						-- DON'T BREAK AFTER WE FIND THE FIRST VALID EVENT!
						-- The old settings could have multiple handlers per event
						-- (all the settings for each handler were stored in the same table together).
					end
				end

				-- the last new event added for each original event should retain
				-- the original PassThrough setting instead of being forced to be true (Events[Events.n].PassThrough = true)
				-- in order to retain previous functionality
				if addedAnEvent then
					Events[Events.n].PassThrough = eventSettings.PassThrough
				end

				-- We have finished creating all the new tables for this event.
				-- Get rid of the old data stored under the old key.
				Events[event] = nil
			end
		end
	end,
})
TMW:RegisterUpgrade(48010, {
	icon = function(self, ics)
		-- OnlyShown was disabled for OnHide (not togglable anymore),
		-- so make sure that icons dont get stuck with it enabled
		local OnHide = rawget(ics.Events, "OnHide")
		if OnHide then
			OnHide.OnlyShown = false
		end
	end,
})
TMW:RegisterUpgrade(47321, {
	icon = function(self, ics)
		ics.Events["**"] = nil -- wtf?
	end,
})
TMW:RegisterUpgrade(47320, {
	iconEventHandler = function(self, eventSettings)
		-- these numbers got really screwy with FP errors (shit like 0.8000000119), put then back to what they should be (0.8)
		eventSettings.Duration 	= eventSettings.Duration  and tonumber(format("%0.1f",	eventSettings.Duration))
		eventSettings.Magnitude = eventSettings.Magnitude and tonumber(format("%1f",	eventSettings.Magnitude))
		eventSettings.Period  	= eventSettings.Period    and tonumber(format("%0.1f",	eventSettings.Period))
	end,
})
TMW:RegisterCallback("TMW_DB_PRE_DEFAULT_UPGRADES", function()
	-- The default value of eventSettings.PassThrough changed from false to true.
	if TellMeWhenDB.profiles and TellMeWhenDB.Version < 50035 then
		for _, p in pairs(TellMeWhenDB.profiles) do
			if p.Groups then
				for _, gs in pairs(p.Groups) do
					if gs.Icons then
						for _, ics in pairs(gs.Icons) do
							if ics.Events then
								for k, eventSettings in pairs(ics.Events) do
									if type(eventSettings) == "table" and eventSettings.PassThrough == nil then
										eventSettings.PassThrough = false
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)


TMW:RegisterCallback("TMW_UPGRADE_PERFORMED", function(event, type, upgradeData, ...)
	if type == "icon" then
		local ics, gs, iconID = ...
		
		-- Delegate the upgrade to eventSettings.
		for eventID, eventSettings in TMW:InNLengthTable(ics.Events) do
			TMW:Upgrade("iconEventHandler", upgradeData, eventSettings, eventID, ics)
		end
	end
end)


local EventHandler = TMW:NewClass("EventHandler")
EventHandler.testable = true
EventHandler.instancesByName = {}
EventHandler.orderedInstances = {}

--- Gets an EventHandler instance by name.
-- @param identifier [string] The identifier of the event handler being requested.
-- @return [EventHandler|nil] The requested EventHandler instance, or nil if it was not found.
function EVENTS:GetEventHandler(identifier)
	return EventHandler.instancesByName[identifier]
end


do	-- EVENTS:InIconEventSettings
	local states = {}
	local function getstate()
		local state = wipe(tremove(states) or {})

		state.currentEventID = 0
		
		state.extIter, state.extIterState = TMW:InIconSettings()

		return state
	end

	local function iter(state)
		state.currentEventID = state.currentEventID + 1

		if not state.currentEvents or state.currentEventID > (state.currentEvents.n or #state.currentEvents) then
			-- We're out of events on the current icon (or we don't have a current icon).
			-- Get the next icon, and start on its events.

			local ics = state.extIter(state.extIterState)
			
			if not ics then
				-- There are no more icons. We're done.
				tinsert(states, state)
				return
			end
			state.currentEvents = ics.Events
			state.currentEventID = 0
			
			-- Call the iter again to start on the first event of the new icon.
			return iter(state)
		end
		
		local eventSettings = rawget(state.currentEvents, state.currentEventID)
		
		if not eventSettings then
			-- There are no event settings when we expected there to be some.
			-- Shrug it off, and call iter again so we can move to the next eventSettings.
			return iter(state)
		end
		
		return eventSettings
	end

	--- Iterates over all event settings of icons in the current profile, and in global groups.
	-- Returns only eventSettings for each event setting.
	function EVENTS:InIconEventSettings()
		return iter, getstate()
	end
end



--- Creates a new EventHandler.
-- @name EventHandler:New
-- @param identifier [string] An identifier for the event handler.
function EventHandler:OnNewInstance_EventHandler(identifier, order)
	self.identifier = identifier
	self.order = order
	self.AllEventHandlerData = {}
	self.NonSpecificEventHandlerData = {}
	
	EventHandler.instancesByName[identifier] = self

	tinsert(EventHandler.orderedInstances, self)
	TMW:SortOrderedTables(EventHandler.orderedInstances)
end

-- [INTERNAL]
function EventHandler:RegisterEventHandlerDataTable(eventHandlerData, ...)
	-- This function simply makes sure that we can keep track of all eventHandlerData that has been registed.
	-- Without it, we would have to search through every single IconComponent when an event is fired to get this data.
	
	-- Feel free to hook this method in instances of EventHandler to make it easier to perform these data lookups.
	-- But, this method should probably never be called by anything except the event core (no third-party calls)
	
	self:AssertSelfIsInstance()
	
	TMW:ValidateType("eventHandlerData.eventHandler", "EventHandler:RegisterEventHandlerDataTable(eventHandlerData, ...)", eventHandlerData.eventHandler, "table")
	TMW:ValidateType("eventHandlerData.identifier", "EventHandler:RegisterEventHandlerDataTable(eventHandlerData, ...)", eventHandlerData.identifier, "string")
	
	TMW.safecall(self.OnRegisterEventHandlerDataTable, self, eventHandlerData, ...)
	
	tinsert(self.AllEventHandlerData, eventHandlerData)
end

--- Registers event handler data that isn't tied to a specific IconComponent.
-- This method may be overwritten in instances of EventHandler with a method that throws an error if nonspecific event handler data (not tied to an IconComponent) isn't supported.
function EventHandler:RegisterEventHandlerDataNonSpecific(...)	
	self:AssertSelfIsInstance()
	
	local eventHandlerData = {
		eventHandler = self,
		identifier = self.identifier
	}
	
	self:RegisterEventHandlerDataTable(eventHandlerData, ...)
	
	tinsert(self.NonSpecificEventHandlerData, eventHandlerData)
end

--- Registers default settings for icon events
-- @param defaults [table] The defaults table that will be merged into {{{TMW.Icon_Defaults.Events["**"]}}}
-- @usage -- Example usage in the Announcements event handler:
--  Announcements:RegisterEventDefaults{
--    Text = "",
--    Channel = "",
--    Location = "",
--    Sticky = false,
--    ShowIconTex = true,
--    r = 1,
--    g = 1,
--    b = 1,
--    Size = 0,
--  }
function EventHandler:RegisterEventDefaults(defaults)
	TMW:ValidateType("defaults", "EventHandler:RegisterEventDefaults(defaults)", defaults, "table")
		
	if TMW.InitializedDatabase then
		error(("Defaults for EventHandler %q are being registered too late. They need to be registered before the database is initialized."):format(self.name or "<??>"))
	end
	
	-- Copy the defaults into the main defaults table.
	TMW:MergeDefaultsTables(defaults, TMW.Icon_Defaults.Events["**"])
end


--- Tests an event for TMW.CI.icon
-- Triggered by clicking on the test button in the config UI.
-- @param eventID [number] The ID of the event you want to test, or nil to test the event that is being configured.
function EventHandler:TestEvent(eventID)
	if not self.testable then
		return
	end
	
	local eventSettings = EVENTS:GetEventSettings(eventID)

	return self:HandleEvent(TMW.CI.icon, eventSettings)
end


local eventSettingsProxies = setmetatable({}, {
	__mode = 'k',
})

--- Generates a unique reference to an eventSettings for the given icon.
function EventHandler:Proxy(eventSettings, icon)
	if eventSettings.__proxyRef then
		eventSettings = eventSettings.__proxyRef
	end
	
	if eventSettingsProxies[eventSettings] then
		return eventSettingsProxies[eventSettings][icon]
	end

	eventSettingsProxies[eventSettings] = setmetatable({}, {
		__index = function(self, k)
			self[k] = setmetatable({
				__proxyRef = eventSettings
			}, {
				__index = eventSettings,
				__newindex = eventSettings
			})

			return self[k]
		end,
	})

	return eventSettingsProxies[eventSettings][icon]
end
	
TMW:RegisterCallback("TMW_ICON_SETUP_PRE", function(_, icon)
	if not TMW.Locked then
		return
	end
	
	-- Setup all of an icon's events.
	wipe(icon.EventHandlersSet)

	for _, eventSettings in TMW:InNLengthTable(icon.Events) do
		local event = eventSettings.Event
		if event then
			local Handler = EVENTS:GetEventHandler(eventSettings.Type)
			
			-- Check if the event actually is configured to do something.
			local thisHasEventHandlers = Handler and Handler:ProcessIconEventSettings(event, eventSettings)

			if thisHasEventHandlers then
				-- The event is good. Fire an event to let people know that the icon has this event.
				TMW:Fire("TMW_ICON_EVENTS_PROCESSED_EVENT_FOR_USE", icon, event, eventSettings)

				icon.EventHandlersSet[event] = true

				-- This table will be used by icon:QueueEvent()
				icon.EventsToFire = icon.EventsToFire or {}
			end
		end
	end
	
	-- Make sure events dont fire while, or shortly after, we are setting up
	-- Don't set nil because that will make it fall back on the class-defined value
	icon.runEvents = false
	
	EVENTS:CancelTimer(icon.runEventsTimerHandler, 1)
	icon.runEventsTimerHandler = EVENTS.ScheduleTimer(icon, "RestoreEvents", TMW.UPD_INTV*2.1)
end)

TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_POST", function(event, time, Locked)
	-- Process all events that were queued in the current update cycle.
	-- This is done all at once because some events (OnCondition) might be triggered by changes in other icons,
	-- and we want everything to happen at the same time so that the firing order makes sense.

	local Icon = TMW.Classes.Icon
	local QueuedIcons = Icon.QueuedIcons
	
	if Locked and QueuedIcons[1] then
		sort(QueuedIcons, Icon.ScriptSort)
		for i = 1, #QueuedIcons do
			local icon = QueuedIcons[i]
			TMW.safecall(icon.ProcessQueuedEvents, icon)
		end
		wipe(QueuedIcons)
	end
end)

TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", function(event, time, Locked)
	-- Wipe all queued events when we do a complete update of TMW
	-- in order to kill any events that got queued while setting up an icon (OnShow, etc).
	
	local QueuedIcons = TMW.Classes.Icon.QueuedIcons

	for i = 1, #QueuedIcons do
		wipe(QueuedIcons[i].EventsToFire)
	end
	
	wipe(QueuedIcons)
end)


-- Base class for EventHandlers that have sub-handlers (e.g. animations and announcements).
TMW:NewClass("EventHandler_ColumnConfig", "EventHandler"){
	OnNewInstance_ColumnConfig = function(self)
	end,
}






-------------------------------------------
-- While Condition Set Passing handling
-------------------------------------------
--[[
While Condition Set Passing (WCSP) is very tightly integrated with TMW.C.EventHandler
because it has very different behavior for different event handlers. Event handlers
need to be aware of what to do when the conditions start passing, and what to do
when they start failing. Animations triggered by WCSP must start/stop based on the
state of conditions, while other event handlers trigger repeatedly while
conditions are passing (EventHandler_WhileConditions_Repetitive)
]]

if TMW.C.IconType then
	error("Bad load order! TMW.C.IconType shouldn't exist at this point!")
end
TMW:RegisterSelfDestructingCallback("TMW_CLASS_NEW", function(event, class)
	-- Register the WCSP event on IconType itself.
	-- This allows it to be available to all icon types, 
	-- since it is independent of all modules.
	if class.className == "IconType" then
		class:RegisterIconEvent(2, "WCSP", {
			category = L["EVENT_CATEGORY_CONDITION"],
			text = L["SOUND_EVENT_WHILECONDITION"],
			desc = L["SOUND_EVENT_WHILECONDITION_DESC"],
			settings = {
				SimplyShown = true,
				IconEventWhileCondition = true,
			}
		})

		return true -- Signal callback destruction
	end
end)


TMW:NewClass("EventHandler_WhileConditions", "EventHandler"){
	supportWCSP = true,

	OnNewInstance_WhileConditions = function(self)
		self.MapConditionObjectToEventSettings = {}
		self.EventSettingsToConditionObject = {}
		self.UpdatesQueued = {}

		TMW:RegisterCallback("TMW_ICON_DISABLE", self)
		TMW:RegisterCallback("TMW_ICON_EVENTS_PROCESSED_EVENT_FOR_USE", self)
		TMW:RegisterCallback("TMW_ICON_SETUP_POST", self)
	end,


	TMW_ICON_DISABLE = function(self, _, icon, soft)
		for ConditionObject, matches in pairs(self.MapConditionObjectToEventSettings) do
			for eventSettings, ic in pairs(matches) do
				if ic == icon then
					ConditionObject:RequestAutoUpdates(eventSettings, false)

					local eventSettingsProxy = self:Proxy(eventSettings, icon)
					matches[eventSettingsProxy] = nil
					self.EventSettingsToConditionObject[eventSettingsProxy] = nil
				end
			end

			if not next(matches) then
				self.MapConditionObjectToEventSettings[ConditionObject] = nil
			end
		end
	end,

	TMW_ICON_EVENTS_PROCESSED_EVENT_FOR_USE = function(self, _, icon, iconEvent, eventSettings)
		if eventSettings.Type ~= self.identifier or eventSettings.Event ~= "WCSP" then
			return
		end

		local ConditionObjectConstructor = icon:Conditions_GetConstructor(eventSettings.OnConditionConditions)

		-- If the OnlyShown setting is enabled, add a condition to check that the icon is shown.
		-- It is possible that the condition set is empty, in which case this will be the only condition.
		if eventSettings.OnlyShown then
			local condition = ConditionObjectConstructor:Modify_WrapExistingAndAppendNew()

			condition.Type = "ICON"
			condition.Icon = icon:GetGUID()
		end

		local ConditionObject = ConditionObjectConstructor:Construct()

		-- ConditionObject is nil if there were no conditions at all.
		if ConditionObject then
			-- We won't request updates manually - let the condition engine take care of updating.
			ConditionObject:RequestAutoUpdates(eventSettings, true)
			
			-- Associate the condition object with the event settings and the icon that the event settings are from.
			local matches = self.MapConditionObjectToEventSettings[ConditionObject]
			if not matches then
				matches = {}
				self.MapConditionObjectToEventSettings[ConditionObject] = matches
			end
			matches[self:Proxy(eventSettings, icon)] = icon

			-- Allow backwards lookups of this, too.
			self.EventSettingsToConditionObject[self:Proxy(eventSettings, icon)] = ConditionObject

			
			-- Listen for changes in condition state so that we can ask
			-- the event handler to do what it needs to do.
			TMW:RegisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", self)


			-- DO NOT check the state right here, since animations might be missing required components. 
			-- just let it happen during the queued update for TMW_ICON_SETUP_POST
			-- self:CheckState(ConditionObject)

			-- Queue an update during TMW_ICON_SETUP_POST, 
			-- because animations might be missing required icon components when this is triggered.
			self.UpdatesQueued[ConditionObject] = true
		end
	end,

	TMW_ICON_SETUP_POST = function(self, _, icon)
		-- Run updates for anything that is queued. 
		-- There should only be one icon worth of ConditionObjects in here,
		-- since TMW_ICON_SETUP_PRE and TMW_ICON_SETUP_POST are always called in pairs.
		for ConditionObject in pairs(self.UpdatesQueued) do
			self:CheckState(ConditionObject)
		end
		wipe(self.UpdatesQueued)
	end,

	TMW_CNDT_OBJ_PASSING_CHANGED = function(self, _, ConditionObject, failed)
		self:CheckState(ConditionObject)
	end,

	CheckState = function(self, ConditionObject)
		local matches = self.MapConditionObjectToEventSettings[ConditionObject]

		if TMW.Locked and matches then
			-- If TMW is locked, and there are eventSettings that are using this ConditionObject,
			-- then have the event handler do what needs to be done for all of the matching eventSettings.

			self:HandleConditionStateChange(matches, ConditionObject.Failed)
		end
	end,
}


TMW:NewClass("EventHandler_WhileConditions_Repetitive", "EventHandler_WhileConditions"){
	frequencyMinimum = 0.2,

	OnNewInstance_WhileConditions_Repetitive = function(self)
		self.RunningTimers = {}

		TMW:RegisterCallback("TMW_ONUPDATE_POST", self)
		TMW:RegisterCallback("TMW_ICON_DISABLE", self, "TMW_ICON_DISABLE_2")
	end,

	TMW_ICON_DISABLE_2 = function(self, _, icon, soft)
		-- Halt all of the timers for an icon when it is disabled.
		for eventSettings, timerTable in pairs(self.RunningTimers) do
			if timerTable.icon == icon then
				timerTable.halted = true
			end
		end
	end,

	TMW_ONUPDATE_POST = function(self, event, time, Locked)
		-- Check all events to see if we should handle them again.
		if Locked then
			for eventSettings, timerTable in pairs(self.RunningTimers) do
				if not timerTable.halted and timerTable.nextRun < time then
					-- Enough time has passed. We need to handle the event again right now.

					-- Increment the timer until it has passed the current time.
					if eventSettings.Frequency > 0 then
						-- Test if Frequency > 0 before starting loop because otherwise it will be infinite.
						while timerTable.nextRun < time do
							timerTable.nextRun = timerTable.nextRun + eventSettings.Frequency
						end
					end

					-- Actually handle the event.
					self:HandleEvent(timerTable.icon, eventSettings)
				end
			end
		end
	end,

	HandleConditionStateChange = function(self, eventSettingsList, failed)
		if not failed then
			-- Conditions are passing.
			-- Start/resume timers for all the eventSettings that are attached to the conditions.
			for eventSettings, icon in pairs(eventSettingsList) do
				local timerTable = self.RunningTimers[eventSettings]

				if not timerTable then
					-- Create a timer if there wasn't already one for the eventSettings.
					self.RunningTimers[eventSettings] = {icon = icon, nextRun = TMW.time}
				else
					-- Resume the timer if it was previously halted due to failing conditions.
					timerTable.halted = false

					-- Fast-foward the timer to right now, so that it triggers immediately.
					if timerTable.nextRun < TMW.time then
						timerTable.nextRun = TMW.time
					end
				end
			end
		else
			-- Conditions are failing.
			-- Halt all the timers for the eventSettings which rely on these conditions.
			for eventSettings, icon in pairs(eventSettingsList) do
				if self.RunningTimers[eventSettings] then
					self.RunningTimers[eventSettings].halted = true
				end
			end
		end
	end,
}


do
	local CNDT = TMW.CNDT
	
	
	local ConditionSet = {
		parentSettingType = "iconEventHandler",
		parentDefaults = TMW.Icon_Defaults.Events["**"],
		
		-- This uses the same settings as the On Condition Set Passing event to prevent clutter.
		settingKey = "OnConditionConditions",
		GetSettings = function(self)
			local currentEventID = TMW.EVENTS.currentEventID
			if currentEventID then
				return TMW.CI.ics.Events[currentEventID].OnConditionConditions
			end
		end,
		
		iterFunc = TMW.EVENTS.InIconEventSettings,
		iterArgs = {TMW.EVENTS},

		useDynamicTab = true,
		ShouldShowTab = function(self)
			local button = TellMeWhen_IconEditor.Pages.Events.EventSettingsContainer.IconEventWhileCondition
			
			return button and button:IsShown()
		end,
		tabText = L["EVENT_WHILECONDITIONS"],
		tabTooltip = L["EVENT_WHILECONDITIONS_TAB_DESC"],
		
	}
	CNDT:RegisterConditionSet("IconEventWhileCondition", ConditionSet)
	
end
