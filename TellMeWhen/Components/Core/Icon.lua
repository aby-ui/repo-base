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

local next, pairs, error, rawget, next, wipe, tinsert, sort, strsplit, table, assert, loadstring, ipairs, tostring, assert, strmatch
	= next, pairs, error, rawget, next, wipe, tinsert, sort, strsplit, table, assert, loadstring, ipairs, tostring, assert, strmatch


--- [[api/icon/api-documentation/|Icon]] is the class of all Icons.
-- 
-- Icon inherits explicitly from {{{Blizzard.Button}}} and from [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]], and implicitly from the classes that it inherits. 
-- 
-- Icon is the class of all TMW icons, which are the very heart of what TMW is and what it does. Icons provide the methods and functionality that Icon Types need to do their jobs. They also provide other API, like icon event handling, and they provide all the methods needed for setup and updating. Icons themselves do not create or provide any appearance, child frames, or layers - this is functionality that is given to Icon Modules.
-- 
-- @class file
-- @name Icon.lua


local bitband = bit.band

local function ClearScripts(f)
	f:SetScript("OnEvent", nil)
	f:SetScript("OnUpdate", nil)
end

local UPD_INTV
TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	UPD_INTV = TMW.UPD_INTV
end)



local Icon = TMW:NewClass("Icon", "Button", "UpdateTableManager", "GenericModuleImplementor")
Icon:UpdateTable_Set(TMW.IconsToUpdate)
Icon.IsIcon = true
Icon.attributes = {}
Icon.runEvents = true
Icon.QueuedIcons = {}
Icon.NextUpdateTime = math.huge
local QueuedIcons = Icon.QueuedIcons

do
	local tab
	
	TMW.CNDT:RegisterConditionSetImplementingClass("Icon")
	TMW.CNDT:RegisterConditionSet("Icon", {
		parentSettingType = "icon",
		parentDefaults = TMW.Icon_Defaults,
		
		settingKey = "Conditions",
		GetSettings = function(self)
			if TMW.CI.ics then
				return TMW.CI.ics.Conditions
			end
		end,
		
		iterFunc = TMW.InIconSettings,
		iterArgs = {
			[1] = TMW,
		},
		
		GetTab = function(self)
			return tab
		end,
		tabText = L["CONDITIONS"],
		tabTooltip = L["ICONCONDITIONS_DESC"],
	})
	
	TMW:RegisterCallback("TMW_OPTIONS_LOADED", function()
		tab = TMW.IE:RegisterTab("ICON", "CNDTICON", "Conditions", 5)
		tab:SetText(L["CONDITIONS"])
		tab:SetHistorySet(TMW.C.HistorySet:GetHistorySet("ICON"))
		
		tab:HookScript("OnClick", function()
			TMW.CNDT:LoadConfig("Icon")
		end)

		TMW.IconDragger:RegisterIconDragHandler(110, -- Copy Conditions
			function(IconDragger, info)
				local n = IconDragger.srcicon:GetSettings().Conditions.n
				
				if IconDragger.desticon and n > 0 then
					info.text = L["ICONMENU_COPYCONDITIONS"]:format(n)
					info.tooltipTitle = info.text
					info.tooltipText = L["ICONMENU_COPYCONDITIONS_DESC"]:format(
						IconDragger.srcicon:GetIconName(true), n, IconDragger.desticon:GetIconName(true))

					return true
				end
			end,
			function(IconDragger)
				-- copy the settings
				local srcics = IconDragger.srcicon:GetSettings()
				
				IconDragger.desticon:GetSettings().Conditions = TMW:CopyWithMetatable(srcics.Conditions)
			end
		)

		TMW.IconDragger:RegisterIconDragHandler(111, -- Copy Unit Conditions
			function(IconDragger, info)
				local n = IconDragger.srcicon:GetSettings().UnitConditions.n
				
				if IconDragger.desticon and n > 0 then
					info.text = L["ICONMENU_COPYCONDITIONS_UNIT"]:format(n)
					info.tooltipTitle = info.text
					info.tooltipText = L["ICONMENU_COPYCONDITIONS_DESC"]:format(
						IconDragger.srcicon:GetIconName(true), n, IconDragger.desticon:GetIconName(true))

					return true
				end
			end,
			function(IconDragger)
				-- copy the settings
				local srcics = IconDragger.srcicon:GetSettings()
				
				IconDragger.desticon:GetSettings().UnitConditions = TMW:CopyWithMetatable(srcics.UnitConditions)
			end
		)

	end)

end

-- [INTERNAL]
function Icon.OnNewInstance(icon)
	local group = icon:GetParent()
	local iconID = icon:GetID()

	icon.group = group
	icon.ID = iconID
	group[iconID] = icon
	
	icon.EventHandlersSet = {}
	icon.lmbButtonData = {}
	icon.position = {}
	
	icon.attributes = icon:InheritTable(Icon, "attributes")
end

-- [INTERNAL]
function Icon.__lt(icon1, icon2)
	local g1 = icon1.group.ID
	local g2 = icon2.group.ID
	if g1 ~= g2 then
		return g1 < g2
	else
		return icon1.ID < icon2.ID
	end
end

-- [INTERNAL]
function Icon.__tostring(icon)
	return icon:GetName()
end

function Icon.ScriptSort(iconA, iconB)
	local gOrder = 1 -- -TMW.db.profile.CheckOrder
	local gA = iconA.group.ID
	local gB = iconB.group.ID
	if gA == gB then
		local iOrder = 1 -- -iconA.group.CheckOrder
		return iconA.ID*iOrder < iconB.ID*iOrder
	end
	return gA*gOrder < gB*gOrder
end
Icon:UpdateTable_SetAutoSort(Icon.ScriptSort)
TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", Icon, "UpdateTable_PerformAutoSort")

-- [WRAPPER] (no documentation needed)
Icon.SetScript_Blizz = Icon.SetScript
function Icon.SetScript(icon, handler, func)

	if icon.cpu_startTime and handler == "OnEvent" and func then
		local origFunc = func
		func = function(...) 
			local start = TMW:CpuProfilePush()

			origFunc(...)

			local currentUsage = TMW:CpuProfilePop()
			if icon.cpu_eventPeak < currentUsage then
				icon.cpu_eventPeak = currentUsage
			end
			icon.cpu_eventCount = icon.cpu_eventCount + 1
			icon.cpu_eventTotal = icon.cpu_eventTotal + currentUsage
		end
	end

	icon[handler] = func
	icon:SetScript_Blizz(handler, func)
end

-- [INTERNAL]
function Icon.CheckUpdateTableRegistration(icon)
	if icon.UpdateFunction then
		icon:UpdateTable_Register()
	else
		icon:UpdateTable_Unregister()
	end
end

--- Sets the function that will be called when the icon needs to be updated.
-- 
-- Func will be called with signature (icon, time). Time is equal to TMW.time and GetTime().
-- @name Icon:SetUpdateFunction
-- @paramsig func
-- @param func [function|nil] The function that will be called when the icon needs to be updated. Nil to stop the icon from being updated. An error may be thrown if icon:Update() is called manually when the update function has been set nil.
-- @usage icon:SetUpdateFunction(MultiStateCD_OnUpdate)
function Icon.SetUpdateFunction(icon, func)
	icon.UpdateFunction = func
	
	if not icon.IsSettingUp then
		icon:CheckUpdateTableRegistration()
	end
end

-- [WRAPPER] (no documentation needed)
Icon.RegisterEvent_Blizz = Icon.RegisterEvent
function Icon.RegisterEvent(icon, event)
	if not icon.registeredEvents then
		icon.registeredEvents = {}
	end
	icon.registeredEvents[event] = true

	icon:RegisterEvent_Blizz(event)
end

-- [WRAPPER] (no documentation needed)
Icon.UnregisterAllEvents_Blizz = Icon.UnregisterAllEvents
function Icon.UnregisterAllEvents(icon, event)
	-- UnregisterAllEvents_Blizz uses a metric fuckton of CPU, so don't do it.
	-- Instead, keep track of events that we register, and unregister them by hand.
	
	if icon.registeredEvents then
		for event in pairs(icon.registeredEvents) do
			icon:UnregisterEvent(event)
		end
		wipe(icon.registeredEvents)
	end
end

-- [SCRIPT HANDLER] (no documentation needed)
function Icon.OnShow(icon)
	icon:SetInfo("shown", true)
	icon.NextUpdateTime = 0
end
-- [SCRIPT HANDLER] (no documentation needed)
function Icon.OnHide(icon)
	icon:SetInfo("shown", false)
	icon.NextUpdateTime = 0
end

--- Returns the settings table that holds the settings for the icon. If the icon is controlled, will return the settings of its controller.
-- @name Icon:GetSettings
-- @paramsig
-- @return [{{{TMW.Icon_Defaults}}}] The settings table that holds the settings for the icon.
-- @usage local ics = icon:GetSettings()
-- print(icon:GetName() .. "'s enabled setting is set to " .. ics.Enabled)
function Icon.GetSettings(icon)
	if icon:IsControlled() then
		return icon.group.Controller:GetSettings()
	else
		return icon:GetRealSettings()
	end
end

--- Returns the settings table that holds the settings for the icon, ignoring any overrides that result from the icon's group being a controlled group.
-- @name Icon:GetRealSettings
-- @paramsig
-- @return [{{{TMW.Icon_Defaults}}}] The settings table that holds the settings for the icon.
function Icon.GetRealSettings(icon)
	return icon.group:GetSettings().Icons[icon:GetID()]
end

--- Gets the GUID of the icon. This may be a session-temporary GUID or a permanant GUID.
-- @name Icon:GetGUID
-- @paramsig generate
-- @param generate [boolean|nil] True if a permanant GUID should be generated and stored
-- with the icon's settings if there isn't already a permanant GUID for the icon.
-- A permanant GUID should always be generated when creating a reference to an icon that
-- needs to persist between sessions.
-- @return [String] The GUID of the icon.
-- @usage local GUID = icon:GetGUID()
function Icon.GetGUID(icon, generate)
	local GUID = icon:GetRealSettings().GUID
	if GUID == "" then
		GUID = nil
	end

	if not GUID then
		if not icon.TempGUID then
			icon.TempGUID = TMW:GenerateGUID("icon", TMW.CONST.GUID_SIZE)
			GUID = icon.TempGUID
		end
		if generate then
			GUID = icon.TempGUID
			icon.TempGUID = nil

			icon:GetRealSettings().GUID = GUID
			icon.GUID = GUID
			icon:Setup()
		else
			return icon.TempGUID
		end
	else
		-- Nil this out for icons that are imported that have a GUID.
		-- There will be a tempGUID already for the icon, but it won't match
		-- the imported GUID.
		icon.TempGUID = nil
	end

	return GUID
end

--- Returns the settings table that holds the view-specific settings for the icon.
-- @name Icon:GetSettingsPerView
-- @paramsig view
-- @param [string|nil] The identifier of the [[api/icon-views/api-documentation/|IconView]] to get settings for, or nil to use the icon's current view.
-- @return [{{{TMW.Icon_Defaults.SettingsPerView[view]}}}] The settings table that holds the view-specific settings for the icon.
-- @usage local icspv = icon:GetSettingsPerView()
-- 
-- local icspv = icon:GetSettingsPerView("bar")
function Icon.GetSettingsPerView(icon, view)
	view = view or icon.group:GetSettings().View
	return icon:GetSettings().SettingsPerView[view]
end

--- Determines if the icon is currently being edited in the Icon Editor.
-- @name Icon:IsBeingEdited
-- @paramsig
-- @return [string|nil] If the icon is being edited, returns the identifier string of the currently active Icon Editor tab. Returns nil if the icon is not being edited in the Icon Editor.
function Icon.IsBeingEdited(icon)
	if TMW.IE and TMW.CI.icon == icon and TMW.IE.CurrentTab and TMW.IE:IsVisible() then
		return TMW.IE.CurrentTab.identifier
	end
end

function Icon.IsMouseOver(icon)
	-- Ignore mouseover checks that fail due to the frame being restricted.
	local success, isOver = pcall(UIParent.IsMouseOver, icon)
	if not success then return false end
	return isOver
end

--- Returns a string that contains the texture of the icon plus the name of the group and the ID of the icon.
-- @name Icon:GetIconName
-- @paramsig texture
-- @param texture [boolean] True if the texture should be prepended to the output, otherwise false or nil.
-- @return [string] The string containing the texture of the icon plus the name of the group and the ID of the icon.
function Icon.GetIconName(icon, texture)
	local name = L["GROUPICON"]:format(icon.group:GetGroupName(1), icon.ID)
	
	if icon.group.Domain == "global" then
		name = L["DOMAIN_GLOBAL"] .. " " .. name
	end

	if texture and icon.attributes.texture and icon.attributes.texture ~= nil then
		return ("|T%s:0|t %s"):format(icon.attributes.texture, name)
	else
		return name
	end
end

--- Alias for icon:GetIconName(1). Exists so that groups and icons both have a obj:GetFullName() method.
-- @name Icon:GetFullName
-- @paramsig 
-- @return [string] The string containing the texture of the icon plus the name of the group and the ID of the icon.
function Icon.GetFullName(icon)
	return icon:GetIconName(1)
end

--- Returns information about the icon that should be included when listing it in a dropdown menu. Wrapper around TMW:GetIconMenuText() with the groupID and iconID added to the tooltip.
-- @name Icon:GetIconMenuText
-- @paramsig 
-- @return [string] The string that should be used as the tooltip title for the menu item.
-- @return [string] The string that should be used as the text for the menu item. This is a tuncation of the first return.
-- @return [string] The string that should be used as the tooltip text for the menu item.
function Icon.GetIconMenuText(icon)
	local text, textshort, tooltip = TMW:GetIconMenuText(icon:GetSettings())
	tooltip = icon:GetIconName() .. "\r\n" .. tooltip

	return text, textshort, tooltip
end

--- Queues an icon event to be fired.
-- 
-- The event must have been registed through [[api/base-classes/icon-component/|IconComponent]]{{{:RegisterIconEvent()}}}.
-- @name Icon:QueueEvent
-- @paramsig eventInfo
-- @param eventInfo [string|table] Either a string that identifies the event (as registered with [[api/base-classes/icon-component/|IconComponent]]{{{:RegisterIconEvent()}}}) that will be fired (all events of that type will be attempted to be fire), or a table of event settings that is in {{{icon:GetSettings().Events}}} (only that specific event and its settings will be fired). The event will not actually be fired until {{{icon:ProcessQueuedEvents()}}} is called.
-- @usage -- From IconDataProcessor_Alpha_Real: (An example of calling by passing an event identifier)
--  if icon.EventHandlersSet.OnHide then
--    icon:QueueEvent("OnHide")
--  end
-- 
-- 
-- -- From IconModule_IconEventConditionHandler: (An example of calling by passing in an eventSettings table)
--  local function TMW_CNDT_OBJ_PASSING_CHANGED(event, ConditionObject, failed)
--    if not failed then
--      local matches = MapConditionObjectToEventSettings[ConditionObject]
--      -- MapConditionObjectToEventSettings maps TMW.CLasses.ConditionObject instances to the eventSettings they were created for.
--      -- matches is a table that contains {[eventSettings] = icon} pairs. These tables were setup in the module's :OnEnable() method.
--      -- See IconModule_IconEventConditionHandler's code for complete implementation.
--      if matches then
--        for eventSettings, icon in pairs(matches) do
--          icon:QueueEvent(eventSettings.__proxyRef)
--          icon:ProcessQueuedEvents()
--        end
--      end
--    end
--  end
function Icon.QueueEvent(icon, eventInfo)
	-- Events that get queued will be processed when icon:ProcessQueuedEvents() is called.
	-- This can be done manually if an event needs to be processed immediately in an OnEvent handler,
	-- but it will be done automatically for all icons during TMW_ONUPDATE_TIMECONSTRAINED_POST (in EventHandler.lua)

	icon.EventsToFire[eventInfo] = true
	icon.eventIsQueued = true
	
	QueuedIcons[#QueuedIcons + 1] = icon
end

-- [INTERNAL] (no documentation needed)
function Icon.RestoreEvents(icon)
	icon.runEvents = true
	icon.runEventsTimerHandler = nil
	if icon.EventHandlersSet.OnEventsRestored and TMW.Locked then
		icon:QueueEvent("OnEventsRestored")
		icon:ProcessQueuedEvents()
	end
end

local EventSettingsWasPassingConditionMap = {}
--- Triggers processing of all icon events that have been queued through {{{icon:QueueEvent()}}}.
-- 
-- Icon events will only be fired if their conditions pass (if they have any) and if limitations like the "Continue to lower events" user setting don't prevent more than one event from being fired.
-- Events are fired in the order that they are configured by the user, not in the order that they are queued.
-- 
-- This method is automatically called at the end of a TMW update cycle for all icons that have queued an event,
-- so it should only be called after an event is queued outside of normal icon updating (like in an OnEvent handler or in a script handler).
-- 
-- Search TellMeWhen's source for calls of this method and of {{{icon:QueueEvent()}}} for examples of proper usage.
-- @name Icon:ProcessQueuedEvents
-- @paramsig 
function Icon.ProcessQueuedEvents(icon)
	local EventsToFire = icon.EventsToFire
	if EventsToFire and icon.eventIsQueued then
		local handledOne
		for i = 1, (icon.Events.n or 0) do
			-- settings to check for in EventsToFire
			local EventSettingsFromIconSettings = icon.Events[i]
			local event = EventSettingsFromIconSettings.Event
			
			local EventSettings
			if EventsToFire[EventSettingsFromIconSettings] or EventsToFire[event] then
				-- we should process EventSettingsFromIconSettings
				EventSettings = EventSettingsFromIconSettings
			end
			local eventData = TMW.EventList[event]
			if eventData and EventSettings then
				local shouldProcess = true
				if EventSettings.OnlyShown and icon.attributes.realAlpha <= 0 then
					shouldProcess = false

				elseif EventSettings.PassingCndt then
					local conditionChecker = eventData.conditionChecker
					local conditionResult = true
					
					if conditionChecker then
						conditionResult = conditionChecker(icon, EventSettings)
						
						if EventSettings.CndtJustPassed then
							local uniqueKey = tostring(icon) .. tostring(EventSettings)
							if conditionResult ~= EventSettingsWasPassingConditionMap[uniqueKey] then
								EventSettingsWasPassingConditionMap[uniqueKey] = conditionResult
							else
								conditionResult = false
							end
						end
					end
					
					shouldProcess = conditionResult
				end

				if shouldProcess and icon.runEvents and icon.attributes.shown then
					local EventHandler = TMW.EVENTS:GetEventHandler(EventSettings.Type)
					if EventHandler then
						local handled = EventHandler:HandleEvent(icon, EventSettings)
						if handled then
							if not EventSettings.PassThrough then
								break
							end
							handledOne = true
						end
					end
				end
			end
		end

		wipe(EventsToFire)
		icon.eventIsQueued = nil
		if handledOne then
			TMW:Fire("TMW_ICON_UPDATED", icon)
		end
	end
end

--- Checks if the icon is within the maximum number of icons that will be shown by its parent group.
-- @name Icon:IsInRange
-- @paramsig 
-- @return [boolean] True if the icon's ID is within the maximum number of icons allowed by its parent group, otherwise false.
function Icon.IsInRange(icon)
	return icon:GetID() <= icon.group.Rows*icon.group.Columns
end

--- Wrapper around [[api/icon-type/api-documentation/|IconType]]{{{:OnGCD(icon, duration)}}}.
-- @name Icon:OnGCD
-- @paramsig duration
-- @param duration [number] The duration to check. This should be the total duration of the cooldown (e.g. the second return from GetSpellCooldown()), not the remaining duration.
-- @return [boolean] True if the duration passed in is a global cooldown, otherwise false.
function Icon.OnGCD(icon, duration)
	return icon.typeData:OnGCD(icon, duration)
end

--- Checks if the icon is a valid icon for being in things like the list of icons that can be checked in metas/conditions.
-- @name Icon:IsValid
-- @paramsig 
-- @return [boolean] True if the icon is valid, otherwise false.
function Icon.IsValid(icon)
	-- checks if the icon should be in the list of icons that can be checked in metas/conditions

	return icon.Enabled and icon:IsInRange() and icon.group:IsValid()
end

Icon.Update_Method = "auto"
--- Sets the update method that will be used by the icon.
-- 
-- Setting to "auto" causes the icon to be updated every single update cycle (within the limits of the Update Interval user setting). "auto" is the default value.
-- 
-- Setting to "manual" causes the icon to be updated only when {{{icon.NextUpdateTime < TMW.time}}}, or when {{{icon:Update(true)}}} is called (this should not be done outside of special circumstances. Manual updating should be restricted to using only icon.NextUpdateTime).
-- @name Icon:SetUpdateMethod
-- @paramsig method
-- @param method [string] A string the indicates the update method that will be used for the icon. Must be either "auto" or "manual".
-- @usage icon:SetUpdateMethod("manual")
function Icon.SetUpdateMethod(icon, method)
	icon.Update_Method = method

	if method == "auto" then
		-- do nothing for now.
	elseif method == "manual" then
		icon.NextUpdateTime = 0
	else
		error("Unknown update method " .. method)
	end
end

-- [INTERNAL] (no documentation needed)
function Icon.ScheduleNextUpdate(icon)
	local time = TMW.time
	
	local duration
	if icon:IsGroupController() then
		duration = math.huge

		for icon in icon.group:InIcons() do
			local attributes = icon.attributes
			
			if not attributes.shown then
				break
			end

			local d = attributes.duration - (time - attributes.start)

			if d > 0 and d < duration then
				duration = d
			end
		end

		if duration == math.huge then
			duration = 0
		end
	else
		local attributes = icon.attributes

		duration = attributes.duration - (time - attributes.start)
		if duration < 0 then duration = 0 end
	end

	if duration == 0 then
		icon.NextUpdateTime = math.huge
	else
		icon.NextUpdateTime = time + duration
	end
end


local IconEventUpdateEngine = CreateFrame("Frame")
TMW.IconEventUpdateEngine = IconEventUpdateEngine
IconEventUpdateEngine.UpdateEvents = setmetatable({}, {__index = function(self, event)
	self[event] = {}
	return self[event]
end})
function IconEventUpdateEngine:OnEvent(event, arg1)
	if TMW.profilingEnabled then
		
		-- We start outside the loop so that we can include the loop execution time in our costs.
		local start = TMW:CpuProfilePush()

		for icon, arg1ToMatch in next, self.UpdateEvents[event] do

			if icon.NextUpdateTime ~= 0 and (arg1ToMatch == true or arg1ToMatch == arg1) then
				icon.NextUpdateTime = 0
			end

			local currentUsage = TMW:CpuProfilePop()
			if icon.cpu_startTime then
				if icon.cpu_eventPeak < currentUsage then
					icon.cpu_eventPeak = currentUsage
				end
				icon.cpu_eventCount = icon.cpu_eventCount + 1
				icon.cpu_eventTotal = icon.cpu_eventTotal + currentUsage
			end
			start = TMW:CpuProfilePush()
		end

		TMW:CpuProfilePop()

	else
		for icon, arg1ToMatch in next, self.UpdateEvents[event] do
			if icon.NextUpdateTime ~= 0 and (arg1ToMatch == true or arg1ToMatch == arg1) then
				icon.NextUpdateTime = 0
			end
		end
	end
end
IconEventUpdateEngine:SetScript("OnEvent", IconEventUpdateEngine.OnEvent)

--- Registers a Blizzard event that will, upon being fired, trigger the icon to schedule a manual update for the next TMW update cycle.
-- @name Icon:RegisterSimpleUpdateEvent
-- @paramsig event, arg1
-- @param event [string] A Blizzard event.
-- @param arg1 [//any//] An optional arg that must match the first arg of the Blizzard event for the icon update to be triggered. Nil to cause the icon to be updated for any firings of the event, regardless of its first arg. Any event handling that requires checking more than just the first arg should be done manually by the [[api/icon-type/api-documentation/|IconType]] that needs it (use {{{icon:RegisterEvent(event)}}} and {{{icon:SetScript("OnEvent", func)}}} where func is a function that will parse the event args and sets {{{icon.NextUpdateTime}}} to the value of TMW.time at which the icon should be update next, or 0 if an immediate update should happen.
-- @usage icon:RegisterSimpleUpdateEvent("SPELL_UPDATE_COOLDOWN")
-- icon:RegisterSimpleUpdateEvent("UNIT_POWER_FREQUENT", "player")
function Icon.RegisterSimpleUpdateEvent(icon, event, arg1)
	if arg1 == nil then
		arg1 = true
	end
	
	local iconsForEvent = IconEventUpdateEngine.UpdateEvents[event]
	local existing = iconsForEvent[icon]
	if existing and existing ~= arg1 then
		error("Can't change the arg that you are checking for an event without unregistering first", 2)
	end
	iconsForEvent[icon] = arg1
	if strmatch(event, "^TMW_") then
		TMW:RegisterCallback(event, IconEventUpdateEngine, "OnEvent")
	else
		IconEventUpdateEngine:RegisterEvent(event)
	end
end

--- Unregisters a simple update event that has been registed for the icon with Icon:RegisterSimpleUpdateEvent().
-- @name Icon:UnregisterSimpleUpdateEvent
-- @paramsig event
-- @param event [string] A Blizzard event that should be unregisted from the SimpleUpdateEvent system as was previously registered through {{{icon:RegisterSimpleUpdateEvent()}}}.
function Icon.UnregisterSimpleUpdateEvent(icon, event)
	local iconsForEvent = rawget(IconEventUpdateEngine.UpdateEvents, event)
	if iconsForEvent then
		iconsForEvent[icon] = nil
		if not next(iconsForEvent) then
			if strmatch(event, "^TMW_") then
				TMW:UnregisterCallback(event, IconEventUpdateEngine, "OnEvent")
			else
				IconEventUpdateEngine:UnregisterEvent(event)
			end
		end
	end
end

--- Unregisters all simple update events that have been registed for the icon with Icon:RegisterSimpleUpdateEvent().
-- 
-- This is done automatically every time an icon is setup, and should not be called manually outside of exceptional circumstances.
-- @name Icon:UnregisterAllSimpleUpdateEvents
-- @paramsig 
function Icon.UnregisterAllSimpleUpdateEvents(icon)
	for event, iconsForEvent in pairs(IconEventUpdateEngine.UpdateEvents) do
		iconsForEvent[icon] = nil
		if not next(iconsForEvent) then
			if strmatch(event, "^TMW_") then
				TMW:UnregisterCallback(event, IconEventUpdateEngine, "OnEvent")
			else
				IconEventUpdateEngine:UnregisterEvent(event)
			end
		end
	end
end

--- Attempts to update an icon.
-- 
-- This should normally only be called at the end of a [[api/icon-type/api-documentation/|IconType]]{{{:Setup()}}} method (unless your IconTypes's proper functionality requires that you not do so). 
-- You may also call it anywhere else as you deem appropriate, but in most normal situations, there is no need to do so. 
-- 
-- It is automatically called for every valid icon that has an update function defined (through {{{icon:SetUpdateFunction()}}}) each update cycle in the TMW icon update engine.
-- 
-- It is limited to the updating only as often as the Update Interval user-setting allows (maximum of once per frame/per OnUpdate script call) (unless the force param is used).
-- It updates the icon's conditions as needed and then calls the icon's update function to trigger the chain of updating from icon type -> icon data processor (and hooks) -> icon modules & icon events.
-- @name Icon:Update
-- @paramsig force
-- @param force [boolean|nil] True to force an immediate update of the icon, disregarding both the Update Interval user-setting (and the related once-per-frame constraint) and the value of {{{icon.NextUpdateTime}}}.
-- This should only be used in exceptional circumstances, like when the source of an icon's attributes and its {{{icon:SetInfo}}} calls are from an event (see the Combat Log icon type for an example of this).
function Icon.Update(icon, force)
	local time = TMW.time 
	
	if icon.attributes.shown and icon.UpdateFunction and (force or icon.LastUpdate <= time - UPD_INTV) then
		icon.LastUpdate = time

		local profilingOn = icon.cpu_startTime
		local Update_Method = icon.Update_Method

		-- The condition check needs to come before we determine iconUpdateNeeded because
		-- checking a condition may set NextUpdateTime to 0 if the condition passing state changes.
		local ConditionObject = icon.ConditionObject
		if ConditionObject and (ConditionObject.UpdateNeeded or ConditionObject.NextUpdateTime < time) then

			if profilingOn then
				-- I'm going to profile the ConditionObject:Check() as part of the icon for now.
				-- Technically it should be measured on its own because it can be shared between multiple icons/groups,
				-- but I don't know how to display the stats in a true-to-reality way.
				-- I could just sum condition time + icon time, but then the condition could be double counted.
				-- So, I'm electing to just let a random icon take the hit if it ends up being responsible for checking a condition.
				
				TMW:CpuProfilePush()

				ConditionObject:Check()

				local currentUsage = TMW:CpuProfilePop()
				icon.cpu_cndtCount = icon.cpu_cndtCount + 1
				icon.cpu_cndtTotal = icon.cpu_cndtTotal + currentUsage
			else
				ConditionObject:Check()
			end

		end

		local iconUpdateNeeded = force or Update_Method == "auto" or icon.NextUpdateTime < time

		if iconUpdateNeeded then
			if profilingOn then
				TMW:CpuProfilePush()
			end

			icon.__yieldHandledOnce = false
			if not icon:IsGroupController() then
				icon:UpdateFunction(time)
			else
				icon.__controlledIconIndex = 0
				icon:UpdateFunction(time)

				if TMW.Locked then
					for i = icon.__controlledIconIndex+1, icon.group.numIcons do
						local ic = icon.group[i]
						if ic and ic.attributes.realAlpha > 0 then
							-- This allows for correct handling of states & opacities in all cases.
							ic:SetInfo("alphaOverride", 0)

							-- The following won't work for this:
							-- ic:SetInfo("state", 0), because it breaks meta icon controller groups (meta icon state overrides local state).
							-- ic:Hide(), because it breaks OnShow/OnHide animations on controlled icons.
						end
					end
				end
			end

			if Update_Method == "manual" then
				icon:ScheduleNextUpdate()
			end

			if profilingOn then
				local currentUsage = TMW:CpuProfilePop()

				if icon.cpu_updatePeak < currentUsage then
					icon.cpu_updatePeak = currentUsage
				end
				icon.cpu_updateCount = icon.cpu_updateCount + 1
				icon.cpu_updateTotal = icon.cpu_updateTotal + currentUsage
			end
		end
	end
end


--- Yields info harvested from an icon's UpdateFunction. This info will be passed to the icon type's Type:HandeInfo(icon, iconToSet, ...) method if appropriate.
-- More specifically, the info passed to icon:YieldInfo() will be passed on to Type:HandeInfo if either the icon is not a group controller (i.e. it is a normal icon), or if there are mor icons in the group that may be filled with the attributes harvested by the icon type. A call to icon:YieldInfo(false, ...) will only pass its parameters to Type:HandeInfo() if no calls to icon:YieldInfo(true, ...) have been made during this run of the icon's UpdateFunction. Behavior is unpredictable if there are no call to icon:YieldInfo() before an UpdateFunction returns. Therefore, an UpdateFunction should always conclude with a call to icon:YieldInfo(false, ...)
-- @name Icon:YieldInfo
-- @paramsig isNotDone, ...
-- @param isNotDone [boolean] true if there might be more calls to Icon:YieldInfo(true, ...) before the UpdateFunction is finished. false if this call is the last one before the UpdateFunction returns. 
-- @param ... [vararg] The parameters to be passed to the call to Type:HandeInfo(icon, iconToSet, ...) if it is appropriate to do so. This can be empty if isNotDone is false. It should never be empty if isNotDone is true.
function Icon.YieldInfo(icon, isNotDone, ...)
	if not isNotDone and icon.__yieldHandledOnce then
		return nil
	end
	icon.__yieldHandledOnce = true

	if not icon:IsGroupController() then
		icon.typeData:HandleYieldedInfo(icon, icon, ...)
		return nil
	else
		local nextIconIndex = (icon.__controlledIconIndex or 0) + 1
		if nextIconIndex > icon.group.numIcons then
			return nil
		end

		
		icon.__controlledIconIndex = nextIconIndex
		local destIcon = icon.group[nextIconIndex]
		if not destIcon then
			return
		end
		destIcon:SetInfo("alphaOverride", nil)

		icon.typeData:HandleYieldedInfo(icon, destIcon, ...)

		if not isNotDone or not TMW.Locked then
			return nil
		end

		return true
	end
end

--- Returns whether or not an icon is controlling an entire group.
-- @name Icon:IsGroupController
-- @paramsig
-- @return isController [boolean] True if this icon is controlling its group, otherwise false.
function Icon.IsGroupController(icon)
	return icon.group.Controller ~= nil and icon.group.Controller == icon
end

--- Returns whether or not an icon is controlled by the first icon in its group.
-- @name Icon:IsControlled
-- @paramsig
-- @return isController [boolean] True if this icon is controlled by its group's first icon, otherwise false.
function Icon.IsControlled(icon)
	return icon.group.Controller ~= nil and icon.group.Controller ~= icon
end


-- [EVENT HANDLER] (no documentation needed)
function Icon.TMW_CNDT_OBJ_PASSING_CHANGED(icon, event, ConditionObject, failed)
	-- failed is boolean, never nil. nil is used for the conditionFailed attribute if there are no conditions on the icon.
	if icon.ConditionObject == ConditionObject then
		icon.NextUpdateTime = 0
		
		icon:SetInfo("conditionFailed", failed)
	end
end

--- Completely disables and resets an icon to a near-default state.
-- 
-- Unimplements all [[api/base-classes/icon-component/|IconComponent]]s, resets update function and method, unregisters all events, and hides the icon.
-- @name Icon:DisableIcon
-- @paramsig soft
-- @param soft [boolean] True if the icon might not be getting permanantly disabled (in which case this method just serves as a reset)
function Icon.DisableIcon(icon, soft)
	
	icon:UnregisterAllEvents()
	icon:UnregisterAllSimpleUpdateEvents()
	ClearScripts(icon)
	icon:SetUpdateMethod("auto")
	icon:SetUpdateFunction(nil)
	icon:Hide()

	if not soft then
		local iconGUID = icon:GetGUID()
		if iconGUID then
			TMW:DeclareDataOwner(iconGUID, nil)
		end
	end
	
	TMW:Fire("TMW_ICON_DISABLE", icon, soft)

	-- Reset condition stuff
	if icon.ConditionObject then
		icon.ConditionObject:DeclareExternalUpdater(icon, false)
		icon.ConditionObject = nil
	end
	TMW:UnregisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", icon)
	icon:SetInfo("conditionFailed", nil)

	icon:DisableAllModules()
	

	if icon.typeData then
		icon.typeData:UnimplementFromIcon(icon)
	end
	
	if icon.viewData then
		icon.viewData:UnimplementFromIcon(icon)
	end
end


--- Completely sets up an icon.
-- 
-- Implements all requested [[api/base-classes/icon-component/|IconComponent]]s, processes settings, sets up conditions, calls [[api/icon-type/api-documentation/|IconType]]{{{:Setup()}}}, and prepares the icon to be updated or configured.
-- 
-- This method should not be called manually while TellMeWhen is locked. It may be called liberally from wherever you see fit when in configuration mode.
-- @name Icon:Setup
-- @paramsig 
function Icon.Setup(icon)
	if not icon or not icon[0] then return end
	
	local group = icon.group
	local ics = icon:GetSettings()
	local typeData = TMW.Types[ics.Type]
	local viewData = group.viewData
	local iconGUID = icon:GetGUID()	

	if not typeData then
		error("TellMeWhen: Critical error: Couldn't find type data or fallback type data for " ..
			ics.Type .. " (Where is the default icon type? Things broke badly!)")
	end

	-- Check if the group should update its icons in case
	-- an update was called specifically for this icon.
	if not group:ShouldUpdateIcons() then
		return
	end
	

	-- Determine if this icon is a group controller, and setup the entire group if it is.
	if icon.ID == 1 then
		local newController

		if group:GetSettings().Controlled and typeData.canControlGroup then
			newController = icon
		else
			group:GetSettings().Controlled = false
			newController = nil
		end

		-- Only perform a group setup if the group's controller has changed.
		-- If we didn't check for this, we would stack overflow by repeatedly doing this.
		if newController ~= group.Controller then
			group.Controller = newController
			group:Setup() -- Don't tail call here, because if something goes wrong then we WANT to stack overflow.
			return
		end
	end


	-- Set this so that we can prevent update table registration checks from happening
	-- until the end of this method (its a slightly intensive process that adds up if done a ton of times)
	-- This is also used externally (in some IconModules, for eg) to prevent other thigns from happening
	-- during setup. Listen for TMW_ICON_SETUP_POST to find when this gets set to nil.
	icon.IsSettingUp = true
	

	-- Perform a soft reset on the icon.
	icon:DisableIcon(true)
	

	-- Store all of the icon's relevant settings on the icon,
	-- and nil out any settings that aren't relevant.
	-- TODO: (really big TODO) get rid of this behavior.
	for k in pairs(TMW.Icon_Defaults) do
		if typeData.RelevantSettings[k] then
			icon[k] = ics[k]
		else
			icon[k] = nil
		end
	end

	-- Store these on the icon for convenience
	icon.typeData = typeData
	icon.viewData = viewData

	
	if icon.Enabled or not TMW.Locked then
		icon:Show()

		-- Associate the icon's GUID with the icon in a global context
		-- so that it can be referred to by GUID.
		TMW:DeclareDataOwner(iconGUID, icon)


		-- Lame framelevel fix: Sometimes, icons end up with dramatically different frame levels than their group.
		icon:SetFrameLevel(group:GetFrameLevel() + 1)


		-- Notify that we've begun setting up this icon (we're past all the basic stuff now,
		-- and at the point where other parties might be interested in doing anything before we go further)
		TMW:Fire("TMW_ICON_SETUP_PRE", icon)



		------------ Icon View ------------
		viewData:Icon_Setup(icon)
		viewData:ImplementIntoIcon(icon)
		viewData:Icon_Setup_Post(icon)
	

		------------ Icon Type ------------
		typeData:ImplementIntoIcon(icon)
			
		-- Only perform a setup for icons that aren't controlled.
		-- Controlled icons shouldn't be setup because they aren't autonomous.
		if not icon:IsControlled() then 
			icon.LastUpdate = 0
			icon.NextUpdateTime = 0
			TMW.safecall(typeData.Setup, typeData, icon)
		end


		------------ Conditions ------------
		-- Don't setup conditions to untyped icons.
		if icon.typeData.type ~= "" then
			-- Create our condition object for the icon.
			local ConditionObjectConstructor = icon:Conditions_GetConstructor(icon.Conditions)
			icon.ConditionObject = ConditionObjectConstructor:Construct()
			
			if icon.ConditionObject then
				-- If this icon has valid conditions, listen for updates to them.
				icon.ConditionObject:DeclareExternalUpdater(icon, true)
				TMW:RegisterCallback("TMW_CNDT_OBJ_PASSING_CHANGED", icon)
				icon:SetInfo("conditionFailed", icon.ConditionObject.Failed)
			end
		end
	else
		local iconGUID = icon:GetGUID()
		if iconGUID then
			TMW:DeclareDataOwner(iconGUID, nil)
		end

		icon:Hide()
		-- Disable icons that aren't enabled when we're locked.
		--icon:DisableIcon()
	end


	-- Queue another immediate update.
	icon.NextUpdateTime = 0


	if TMW.Locked then
		-- Clear out configuration mode properties from the icon.
		icon:SetInfo("alphaOverride", nil)
		if icon.attributes.texture == "Interface\\AddOns\\TellMeWhen\\Textures\\Disabled" then
			icon:SetInfo("texture", "")
		end
		icon:EnableMouse(false)
	else
		-- Put the icon in a configurable state.
		icon:Show()
		ClearScripts(icon)
		icon:SetUpdateFunction(nil)
		
		icon:SetInfo(
			"alphaOverride; start, duration; stack, stackText",
			icon.Enabled and 1 or 0.5,
			0, 0,
			nil, nil
		)
		
		if icon.attributes.texture == "" then
			icon:SetInfo("texture", "Interface\\AddOns\\TellMeWhen\\Textures\\Disabled")
		end

		icon:EnableMouse(true)
	end


	if icon:IsControlled() then
		if TMW.Locked then
			-- Inherit the controller's attributes icon the controlled icon
			-- in order to copy things like timer sweep reverse 
			-- (which is set statically in the IconType's Setup method, and IconType:Setup() isn't performed for controller icons)
			icon:InheritDataFromIcon(icon.group.Controller)
		else
			-- In config mode, give controller icons the special texture,
			-- and make them slightly transparent for the hell of it.
			icon:SetInfo("texture; alphaOverride",
				"Interface\\AddOns\\TellMeWhen\\Textures\\Controlled",
				icon.Enabled and 0.95 or 0.5
			)
		end
	end
	
	-- Now that we're done setting up, we can call this manually
	-- (icon.IsSettingUp == true prevents it from being called to save on CPU usage)
	icon:CheckUpdateTableRegistration()
	icon.IsSettingUp = nil

	-- Let everyone know that we're done setting up this icon.
	TMW:Fire("TMW_ICON_SETUP_POST", icon)
end















-- [INTERNAL] (no documentation needed)
function Icon.SetupAllModulesForIcon(icon, sourceIcon)
	for moduleName, Module in pairs(icon.Modules) do
		if Module.SetupForIcon and Module.IsEnabled and not Module.dontInherit then
			TMW.safecall(Module.SetupForIcon, Module, sourceIcon)
		end
	end
end

-- [INTERNAL] (no documentation needed)
function Icon.SetModulesToEnabledStateOfIcon(icon, sourceIcon)
	local sourceModules = sourceIcon.Modules
	for moduleName, Module in pairs(icon.Modules) do
		if Module.IsImplemented and not Module.dontInherit then
			local sourceModule = sourceModules[moduleName]
			if sourceModule then
				if sourceModule.IsEnabled then
					Module:Enable(true)
				else
					Module:Disable()
				end
			else
				Module:Disable()
			end
		end
	end
end


-- If you want me to explain wtf this is, send me (Cybeloras) a PM on CurseForge.
TMW.IconStateArbitrator = {
	StateHandlers = {},
	
	UPDATE = function(self, event, icon)
		local attributes = icon.attributes
		local StateHandlers = self.StateHandlers
		
		local handlerToUse
		
		for i = 1, #StateHandlers do
			local handler = StateHandlers[i]
			
			local stateData = attributes[handler.attribute]
			
			if stateData and stateData.Alpha == 0 then
				-- If an alpha is set to 0, then the icon should be hidden no matter what, 
				-- so use it as the final alpha value and stop looking for more.
				-- This functionality has existed in TMW since practically day one, by the way. So don't be clever and remove it.
				handlerToUse = handler
				break
			elseif stateData ~= nil then
				if not handlerToUse then
					-- If we found a state that isn't nil and we haven't figured out
					-- a state to use yet, use this one, but keep looking for 0 values.
					handlerToUse = handler
				end
				if handler.haltImmediatelyIfFound then
					break
				end
			end
		end
		
		if handlerToUse then			
			-- calculatedState stores the state that the icon should be showing, before FakeHidden.
			-- realAlpha does the same for the alpha. We use it on top of calculatedState in favor of backwards compatibility.
			local state = attributes[handlerToUse.attribute]

			if not state.Alpha then
				-- Attempting to catch an elusive bug. Remove this if it doesn't seem to be happening anymore.

				-- One case I've seen is doing an undo/redo while TMW is locked. 
				-- The underlying data on the setting table that gets passed as a state gets nilled out,
				-- so there may be no value.
				-- This happens when undoing to a blank icon from a non-blank icon, for example.
				print("NO ALPHA ON STATE:", handlerToUse.attribute, icon, icon:GetName(), state.Alpha, state)
			end
			icon:SetInfo_INTERNAL("realAlpha", state.Alpha or 0)
			icon:SetInfo_INTERNAL("calculatedState", state)
		end
	end,

	GetConfigData = function(handler, icon, panelInfo)
		if not handler.configGetter then
			return nil
		end

		local configData = handler.configGetter(icon, panelInfo)
		if not configData then
			return nil
		end

		local icon = TMW.CI.icon
		local dependant = handler.dependant
		if dependant and not dependant:ShouldShowConfigPanels(icon) then
			return nil
		end

		return configData
	end,

	-- PUBLIC METHOD (ish)
	AddHandler = function(self, IconDataProcessor, order, dependant, haltImmediatelyIfFound, configGetter)
		TMW:ValidateType(1, "IconStateArbitrator:AddHandler()", IconDataProcessor, "IconDataProcessor")
		TMW:ValidateType(2, "IconStateArbitrator:AddHandler()", order, "number")
		TMW:ValidateType(3, "IconStateArbitrator:AddHandler()", dependant, "IconDataProcessorComponent;nil")
		TMW:ValidateType(4, "IconStateArbitrator:AddHandler()", haltImmediatelyIfFound, "boolean;nil")
		TMW:ValidateType(5, "IconStateArbitrator:AddHandler()", configGetter, "function;nil")
		

		if IconDataProcessor.NumAttributes ~= 1 then
			error("IconStateArbitrator handlers cannot check IconDataProcessors that have more than one attribute!")
		end

		local handler = {
			order = order,
			processor = IconDataProcessor,
			attribute = IconDataProcessor.attributesStringNoSpaces,
			dependant = dependant,
			haltImmediatelyIfFound = haltImmediatelyIfFound,
			configGetter = configGetter,
			GetConfigData = self.GetConfigData,
		}
		
		tinsert(self.StateHandlers, handler)
		sort(self.StateHandlers, TMW.OrderSort)
		
		TMW:RegisterCallback(IconDataProcessor.changedEvent, self, "UPDATE")
	end,	
}





-- [INTERNAL] (no documentation needed)
local InheritAllFunc
function Icon.InheritDataFromIcon(iconDestination, iconSource)
	if not InheritAllFunc then
		local attributes = {}
		local attributesSplit = {}
	
		for _, Processor in pairs(TMW.Classes.IconDataProcessor.instances) do
			if not Processor.dontInherit then
				attributes[#attributes+1] = Processor.attributesStringNoSpaces
				for _, attribute in TMW:Vararg(strsplit(",", Processor.attributesStringNoSpaces)) do
					attributesSplit[#attributesSplit+1] = attribute
				end
			end
		end
		
		local t = {}
		t[#t+1] = "local iconDestination, iconSource = ..."
		t[#t+1] = "\n"
		t[#t+1] = "local attributes = iconSource.attributes"
		t[#t+1] = "\n"
		t[#t+1] = "iconDestination:SetInfo('"
		t[#t+1] = table.concat(attributes, "; ")
		t[#t+1] = "', "
		t[#t+1] = "attributes."
		t[#t+1] = table.concat(attributesSplit, ", attributes.")
		t[#t+1] = ")"
		
		local funcstr = table.concat(t)
		
		InheritAllFunc = assert(loadstring(funcstr))
	end
	
	InheritAllFunc(iconDestination, iconSource)
end

local function SetInfo_GenerateFunction(signature, isInternal)
	local originalSignature = signature
	
	signature = signature:gsub(" ", "")
	
	local t = {} -- taking a page from DogTag's book on compiling functions
	
	-- Declare all upvalues
	for UVSetID, UVSet in ipairs(TMW.Classes.IconDataProcessor.SIUVs) do
		t[#t+1] = "local "
		t[#t+1] = UVSet.variables
		t[#t+1] = " = "
		for referenceID, reference in ipairs(UVSet) do
			t[#t+1] = "TMW.Classes.IconDataProcessor.SIUVs["
			t[#t+1] = UVSetID
			t[#t+1] = "]["
			t[#t+1] = referenceID
			t[#t+1] = "]"
			t[#t+1] = ", "
		end
		t[#t] = nil -- remove the final ", " (if there were any references) or the " = " (if there weren't)
		t[#t+1] = "\n"
	end
		
	t[#t+1] = "\n"
	
	t[#t+1] = "\n"
	t[#t+1] = "return function(icon, "
	t[#t+1] = originalSignature:trim(" ,;"):gsub("  ", " "):gsub(";", ",")
	t[#t+1] = ")"
	t[#t+1] = "\n\n"
	t[#t+1] = [[
		local attributes, EventHandlersSet = icon.attributes, icon.EventHandlersSet
		local doFireIconUpdated
	]]
	
	while #signature > 0 do
		local match
		for _, Processor in ipairs(TMW.Classes.IconDataProcessor.instances) do
		
			match = signature:match("^(" .. Processor.attributesStringNoSpaces .. ")$") -- The attribute string is the only one in the signature
				 or	signature:match("^(" .. Processor.attributesStringNoSpaces .. ";)") -- The attribute string is the first one in the signature
				 or	signature:match("(;" .. Processor.attributesStringNoSpaces .. ")$") -- The attribute string is the last one in the signature
				 or	signature:match(";(" .. Processor.attributesStringNoSpaces .. ";)") -- The attribute string is in the middle of the signature
				 
			if match then
				t[#t+1] = "local Processor = "
				t[#t+1] = Processor.name
				t[#t+1] = "\n"
				
				-- Process any hooks that should go before the main function segment
				Processor:CompileFunctionHooks(t, "pre")
				
				Processor:CompileFunctionSegment(t)
				
				-- Process any hooks that should go after the main function segment
				Processor:CompileFunctionHooks(t, "post")
				
				t[#t+1] = "\n\n"  
				
				signature = signature:gsub(match, "", 1)
				
				break
			end
		end
		if not match then
			error(("Couldn't find a signature match for the beginning of signature %q from %q"):format(signature, originalSignature), 4)
		end
	end
	
	if isInternal then
		t[#t+1] = [[
			return doFireIconUpdated
		end -- "return function(icon, ...)"
		]]
	else
		t[#t+1] = [[
			if doFireIconUpdated then
				TMW:Fire("TMW_ICON_UPDATED", icon)
			end
		end -- "return function(icon, ...)"
		]]
	end
	
	local funcstr = table.concat(t)
	if TMW.debug then
		funcstr = TMW.debug.enumLines(funcstr)
		TMW.debug.SetInfoFuncsToFuncStrs[tostring(isInternal) .. originalSignature] = funcstr
	end
	local func = assert(loadstring(funcstr, "SetInfo " .. originalSignature))()
	
	return func
end

local SetInfoFuncs = setmetatable({}, { __index = function(self, signature)
	-- Check and see if we already made a function for this signature, just with different spacing.
	local signature_no_spaces = signature:gsub(" ", "")
	if rawget(self, signature_no_spaces) then
		local func = self[signature_no_spaces]
		
		-- If there was a function, cache it for the original signature also so that we don't go through this lookup process every time.
		self[signature] = func
		return func
	end
	
	local func = SetInfo_GenerateFunction(signature, nil)
	
	self[signature] = func
	self[signature:gsub(" ", "")] = func
	
	return func
end})


--- Sets attributes of an icon.
-- 
-- The attributes passed to this function will be processed by a [[api/icon-data-processor/api-documentation/|IconDataProcessor]] (and possibly one or more [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]]) and interested [[api/icon-module/api-documentation/|IconModule]]s will be notified of any changes to the attributes.
-- @name Icon:SetInfo
-- @paramsig signature, ...
-- @param signature [string] A semicolon-delimited string of attribute strings as passed to the constructor of a [[api/icon-data-processor/api-documentation/|IconDataProcessor]].
-- @param ... [...] Any number of params that will match up one-for-one with the signature passed in.
-- @usage icon:SetInfo("texture", "Interface\\AddOns\\TellMeWhen\\Textures\\Disabled")
--  
--  -- From IconTypes/IconType_wpnenchant:
--  icon:SetInfo("state; start, duration; spell",
--    STATE_ABSENT,
--    0, 0,
--    nil
--  )
-- 
--  -- From IconTypes/IconType_reactive:
--  icon:SetInfo("state; texture; start, duration; charges, maxCharges, chargeStart, chargeDur; stack, stackText; spell",
--    STATE_USABLE,
--    GetSpellTexture(iName),
--    start, duration,
--    charges, maxCharges, chargeStart, chargeDur
--    stack, stack,
--    iName			
-- )
function Icon.SetInfo(icon, signature, ...)
	SetInfoFuncs[signature](icon, ...)
end

local SetInfoInternalFuncs = setmetatable({}, { __index = function(self, signature)
	-- Check and see if we already made a function for this signature, just with different spacing.
	local signature_no_spaces = signature:gsub(" ", "")
	if rawget(self, signature_no_spaces) then
		local func = self[signature_no_spaces]
		
		-- If there was a function, cache it for the original signature also so that we don't go through this lookup process every time.
		self[signature] = func
		return func
	end
	
	local func = SetInfo_GenerateFunction(signature, true)
	
	self[signature] = func
	self[signature:gsub(" ", "")] = func
	
	return func
end})

--- icon:SetInfo_INTERNAL() is a slightly modified version of icon:SetInfo() that doesn't fire TMW_ICON_UPDATED at the end.
-- It must only be called from within SetInfo (inside IconDataProcessorHooks).
-- SetInfo will fire TMW_ICON_UPDATED at the end (and only once, isntead of multiple times), so SetInfo_INTERNAL won't fire it at all to prevent excessive firings.
-- 
-- When in doubt, don't use this method - use a regular icon:SetInfo() call instead.
-- @name Icon:SetInfo_INTERNAL
-- @paramsig signature, ...
-- @see Icon:SetInfo()
-- @returns [boolean] If true, and if SetInfo_INTERNAL is being called from within the body of an [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]], {{{doFireIconUpdated}}} (local variable within the {{{icon:SetInfo()}}} method) should be set to true.
-- @usage -- An example from Components/Core/IconDataProcessors/IconDataProcessor_Unit_DogTag/Unit_DogTag.lua:
--  Hook:RegisterCompileFunctionSegmentHook("post", function(Processor, t)
--    t[#t+1] = [[
--    local dogTagUnit
--    
--    if icon.typeData.unitType == "unitid" then
--      dogTagUnit = unit
--      if not DogTag.IsLegitimateUnit[dogTagUnit] then
--        dogTagUnit = dogTagUnit and TMW_UNITS:TestUnit(dogTagUnit)
--        if not DogTag.IsLegitimateUnit[dogTagUnit] then
--          dogTagUnit = "player"
--        end
--      end
--    else
--      dogTagUnit = "player"
--    end
--    
--    if attributes.dogTagUnit ~= dogTagUnit then
--      doFireIconUpdated = icon:SetInfo_INTERNAL("dogTagUnit", dogTagUnit) or doFireIconUpdated
--    end
--    --]]
--  end)
function Icon.SetInfo_INTERNAL(icon, signature, ...)
	SetInfoInternalFuncs[signature](icon, ...)
end

-- [INTERNAL] (no documentation needed)
function Icon:ClearSetInfoFunctionCache()
	self:AssertSelfIsClass()
	
	wipe(SetInfoFuncs)
	wipe(SetInfoInternalFuncs)
	InheritAllFunc = nil
end


