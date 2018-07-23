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

local pairs, tinsert, error, type, tostring
	= pairs, tinsert, error, type, tostring
local tDeleteItem = TMW.tDeleteItem

local DogTag = LibStub("LibDogTag-3.0", true)


--- [[api/base-classes/icon-component/|IconComponent]] is a base class of any objects that will be implemented into a [[api/icon/api-documentation/|Icon]]
-- 
-- IconComponent provides a common base for these objects, and it provides various methods for registering default icon settings, Icon Editor configuration panels, and Icon events. It is an abstract class, and should not be directly instantiated.
-- 
-- @class file
-- @name IconComponent.lua


local IconComponent = TMW:NewClass("IconComponent", "GenericComponent")

IconComponent.DefaultPanelSet = "icon"
IconComponent.DefaultPanelColumnIndex = 2

IconComponent.IconSettingDefaults = {}
IconComponent.EventHandlerData = {}
IconComponent.IconEvents = {}

function IconComponent:OnClassInherit_IconComponent(newClass)
	newClass:InheritTable(self, "IconSettingDefaults")
	newClass:InheritTable(self, "EventHandlerData")
	newClass:InheritTable(self, "IconEvents")
end

function IconComponent:OnNewInstance_IconComponent()
	if self.class.InstancesAreSingletons then
		self:InheritTable(self.class, "IconSettingDefaults")
		self:InheritTable(self.class, "IconEvents")
	end
end

--- Register some icon event handler data with a {{{TMW.Classes.EventHandler}}}. This event handler data will only be avaialable to a {{{TMW.Classes.EventHandler}}} when the [[api/icon/api-documentation/|Icon]] for which an event is being handled implements this [[api/base-classes/icon-component/|IconComponent]].
-- @param identifier [string] name of an instance of {{{TMW.Classes.EventHandler}}} that the data should be registered and validated with. The instance does not have to exist before this method is called.
-- @param ... [...] Data as required by the {{{TMW.Classes.EventHandler}}} that it is being registered with. See the documentation of the {{{OnRegisterEventHandlerDataTable}}} method of individual {{{TMW.Classes.EventHandler}}} instances for more information.
-- @usage
--  IconComponent:RegisterEventHandlerData("Animations", 60, "ACTVTNGLOW", {
--    text = L["ANIM_ACTVTNGLOW"],
--    desc = L["ANIM_ACTVTNGLOW_DESC"],
--    ConfigFrames = {
--      "Duration",
--      "Infinite",
--    },
--    Play = function(icon, eventSettings)
--      -- ... function body withheld for brevity.
--    end
--    OnUpdate = function(icon, table)
--      -- ... function body withheld for brevity.
--    end
--    OnStart = function(icon, table)
--      -- ... function body withheld for brevity.
--    end
--    OnStop = function(icon, table)
--      -- ... function body withheld for brevity.
--    end
--  })
function IconComponent:RegisterEventHandlerData(identifier, ...)
	local EventHandler = TMW.EVENTS:GetEventHandler(identifier)
	
	local eventHandlerData = {
		eventHandler = EventHandler,
		identifier = identifier,
	}
	
	if EventHandler then
		EventHandler:RegisterEventHandlerDataTable(eventHandlerData, ...)
		
		tinsert(self.EventHandlerData, eventHandlerData)
	else
		local data = {...}
		TMW:RegisterSelfDestructingCallback("TMW_CLASS_EventHandler_INSTANCE_NEW", function(event, class, EventHandler)
			if EventHandler.identifier == identifier then
				eventHandlerData.eventHandler = EventHandler
	
				EventHandler:RegisterEventHandlerDataTable(eventHandlerData, unpack(data))
				
				tinsert(self.EventHandlerData, eventHandlerData)

				return true -- Signal callback destruction
			end
		end)
	end
end

--- Register a set of icon defaults with an [[api/base-classes/icon-component/|IconComponent]]. These defaults will be merged into {{{TMW.Icon_Defaults}}} and the value of their settings for each icon will be avaialable as {{{TMW.Classes.Icon[settingKey]}}} when this [[api/base-classes/icon-component/|IconComponent]] has been implemented into a [[api/icon/api-documentation/|Icon]].
-- @param defaults [table] A table of default settings that will be merged into {{{TMW.Icon_Defaults}}}.
-- @usage -- Taken from TMW.Types.meta:
--  Type:RegisterIconDefaults{
--    Sort          = false,
--    CheckNext        = false,
--    Icons          = {
--      [1]          = "",
--    },   
--  }
function IconComponent:RegisterIconDefaults(defaults)
	TMW:ValidateType("2 (defaults)", "IconComponent:RegisterIconDefaults(defaults)", defaults, "table")
	
	if not TMW.InitializedDatabase then
		-- Copy the defaults into the main defaults table.
		TMW:MergeDefaultsTables(defaults, TMW.Icon_Defaults)
	else
		TMW:Error("Defaults for component %q (%q) are being registered too late. They need to be registered before the database is initialized.", self.name, self.className)
	end
	
	
	-- Copy the defaults into defaults for this component. Used to implement relevant settings.
	TMW:MergeDefaultsTables(defaults, self.IconSettingDefaults)
end

--- Registers an icon event with an [[api/base-classes/icon-component/|IconComponent]]. This event will be available for use with an [[api/icon/api-documentation/|Icon]] when this [[api/base-classes/icon-component/|IconComponent]] has been implemented into a [[api/icon/api-documentation/|Icon]].
-- @param order [number] The order of this icon event relative to other events when displayed in configuration UIs.
-- @param event [string] The identifier of the event that will be used across TMW to refer to the event being registered.
-- @param eventData [table] A table containing the following fields that describe the event:
-- 	* table.text [string] - The localized, human-readable name of the event.
-- 	* table.desc [string] - The localized, human-readable description of the event that will be shown in tooltips.
-- 	* table.settings [table|nil] - An optional table that contains the list of extra settings that are used by the event.
-- 	* table.valueName [string|nil] - An optional string that describes what kind of data is being checked by conditionChecker.
-- 	* table.valueSuffix [string|nil] - An optional string that describes what kind of data is being checked by conditionChecker.
-- 	* table.conditionChecker [function|nil] - An optional function with signature (icon, eventSettings) that will return a boolean that indicates if the condition set for the event has succeeded based on the icon's current state.
-- @usage -- Taken from IconDataProcessor_Alpha_Real
--  Processor:RegisterIconEvent(12, "OnHide", {
--    text = L["SOUND_EVENT_ONHIDE"],
--    desc = L["SOUND_EVENT_ONHIDE_DESC"],
--    settings = {
--      OnlyShown = "FORCEDISABLED",
--    },
--  })
--  Processor:RegisterIconEvent(13, "OnAlphaInc", {
--    text = L["SOUND_EVENT_ONALPHAINC"],
--    desc = L["SOUND_EVENT_ONALPHAINC_DESC"],
--    settings = {
--      Operator = true,
--      Value = true,
--      CndtJustPassed = true,
--      PassingCndt = true,
--    },
--    valueName = L["ALPHA"],
--    valueSuffix = "%",
--    conditionChecker = function(icon, eventSettings)
--      return TMW.CompareFuncs[eventSettings.Operator](icon.attributes.realAlpha * 100, eventSettings.Value)
--    end,
--  })
function IconComponent:RegisterIconEvent(order, event, eventData)
	TMW:ValidateType("2 (order)", "IconComponent:RegisterIconEvent()", order, "number")
	TMW:ValidateType("3 (event)", "IconComponent:RegisterIconEvent()", event, "string")
	TMW:ValidateType("4 (eventData)", "IconComponent:RegisterIconEvent()", eventData, "table")
	
	TMW:ValidateType("event", "eventData", eventData.event, "nil")
	TMW:ValidateType("order", "eventData", eventData.order, "nil")
	
	TMW:ValidateType("text", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.text, "string")
	TMW:ValidateType("desc", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.desc, "string")
	TMW:ValidateType("settings", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.settings, "table;nil")
	TMW:ValidateType("valueName", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.valueName, "string;nil")
	TMW:ValidateType("valueSuffix", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.valueSuffix, "string;nil")
	TMW:ValidateType("category", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.category, "string;nil")
	TMW:ValidateType("conditionChecker", "IconComponent:RegisterIconEvent() arg4 (eventData)", eventData.conditionChecker, "function;nil")
	
	eventData.event = event
	eventData.order = order
	
	if TMW.EventList[event] then
		error(("An event with the event identifier %q already exists!"):format(event), 2)
	end
	
	TMW.EventList[#TMW.EventList + 1] = eventData
	TMW.EventList[event] = eventData
	
	self.IconEvents[#self.IconEvents + 1] = eventData
end


-- [INTERNAL]
function IconComponent:ImplementIntoIcon(icon)
	if not icon.ComponentsLookup[self] then
		local ics = icon:GetSettings()
		
		for setting in pairs(self.IconSettingDefaults) do
			if icon[setting] ~= nil and type(ics[setting]) ~= "table" then
				TMW:Error("Possible setting conflict detected! Setting %q, with value %q, trying to be implemented by %q, already exists as %q", setting, tostring(ics[setting]), self.name or self.className or "??", tostring(icon[setting]))
			end
			icon[setting] = ics[setting]
		end
		
		icon.Components[#icon.Components+1] = self
		icon.ComponentsLookup[self] = true
		
		if self.OnImplementIntoIcon then
			TMW.safecall(self.OnImplementIntoIcon, self, icon)
		end
	end
end

-- [INTERNAL]
function IconComponent:ShouldShowConfigPanels(icon)
	return icon.ComponentsLookup[self] 
end

-- [INTERNAL]
function IconComponent:UnimplementFromIcon(icon)
	if icon.ComponentsLookup[self] then
	
		tDeleteItem(icon.Components, self, true)
		icon.ComponentsLookup[self] = nil
		
		if self.OnUnimplementFromIcon then
			self:OnUnimplementFromIcon(icon)
		end
	end
end

--- Wrapper for LibStub("LibDogTag-3.0", true):AddTag(...) so you don't have to LibStub for DogTag all over the place.
-- @param ... [...] Args that will be passed to LibStub("LibDogTag-3.0", true):AddTag(...)
function IconComponent:RegisterDogTag(...)
	-- just a wrapper so that i don't have to LibStub DogTag everywhere
	
	if not DogTag then
		return
	end
	
	DogTag:AddTag(...)
end
