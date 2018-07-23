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

local GetSpellInfo, GetSpellLink, GetSpellBookItemInfo, GetSpellBookItemName
	= GetSpellInfo, GetSpellLink, GetSpellBookItemInfo, GetSpellBookItemName
local pairs, ipairs, setmetatable, rawget, date, tinsert, type
	= pairs, ipairs, setmetatable, rawget, date, tinsert, type
	

local GetSpellTexture = TMW.GetSpellTexture
local tContains = TMW.tContains
local tDeleteItem = TMW.tDeleteItem
local OnGCD = TMW.OnGCD

local RelevantToAll = {
	__index = {
		GUID = true,
		SettingsPerView = true,
		Enabled = true,
		Name = true,
		Type = true,
		Events = true,
		Conditions = true,
		UnitConditions = true,
		States = true,
	}
}



--- [[api/icon-type/api-documentation/|IconType]] is the class of all Icon Types.
-- 
-- IconType inherits explicitly from [[api/base-classes/icon-component/|IconComponent]], and implicitly from the classes that they inherit. 
-- 
-- Icon Types take data from the WoW API, filter and manipulate it, and then pass it on to one or more [[api/icon-data-processor/api-documentation/|IconDataProcessor]] through the icon:SetInfo method. The default Icon Type (also used as the fallback when a requested IconView cannot be found) is identified by a blank string (""). To create a new IconType, make a new instance of the IconType class.
-- 
-- Instructions on how to use this API can be found at [[api/icon-type/how-to-use/]]
-- 
-- @class file
-- @name IconType.lua


--- The fields avaiable to instances of TMW.Classes.IconType. TMW.Classes.IconType inherits from TMW.Classes.IconComponent.
-- @class table
-- @name TMW.Classes.IconType
-- @field name [function->|string] A localized string that names the IconType.
-- @field desc [function->|string|nil] A localized string that describes the IconType.
-- @field tooltipTitle [function->|string|nil] A localized string that will be used as the title of the description tooltip for the IconType. Defaults to {{{IconType.name}}}.
-- @field menuIcon [function->|string|nil] Path to the texture that will be displayed in the type selection menu.
-- @field menuSpaceBefore [boolean|nil] True if there should be an empty row displayed before this IconType in the type selection menu.
-- @field menuSpaceAfter [boolean|nil] True if there should be an empty row displayed after this IconType in the type selection menu.
-- @field hidden [function->|boolean|nil] True if the IconType should not be displayed in the type selection menu.
-- @field hasNoGCD [boolean|nil] True if timers/durations reported by the IconType are able to be on the global cooldown, otherwise nil. Default is nil.
-- @field canControlGroup [boolean|nil] True if the icon type is capable of being a group controller. You must implement IconType:HandleYieldedInfo() if true, and use icon:YieldInfo() in your type's update methods instead of icon:SetInfo().
-- 
-- @field Icons [table] [READ-ONLY] Array of icons that use this IconType. Automatically updated, and should not be modified.
-- @field type [string] [READ-ONLY] A short string that will identify the IconType across the addon. Set through the constructor, and should not be modified.
-- @field order [number] [READ-ONLY] A number that determines the display order of the IconType in configuration UIs. Set through {{{IconType:Register()}}} and should not be modified.

local IconType = TMW:NewClass("IconType", "IconComponent")
IconType.UsedAttributes = {}
IconType.DefaultPanelColumnIndex = 1

--- Constructor - Creates a new IconType
-- @name IconType:New
-- @param type [string] A short string that will identify the IconType across the addon.
-- @return [TMW.Classes.IconType] A new IconType instance.
-- @usage IconType = TMW.Classes.IconType:New("cooldown")
function IconType:OnNewInstance(type)
	self.type = type
	self.Icons = {}
	self.UsedProcessors = {}

	self.ViewAllowances = {}
	self.defaultAllowanceForViews = true
	
	self:InheritTable(self.class, "UsedAttributes")
end

--- Performs TMW.Classes.Icon:Setup() on all icons that use this icon type.
function IconType:SetupIcons()
	self:AssertSelfIsInstance()
	
	for i = 1, #self.Icons do
		self.Icons[i]:Setup()
	end
end

-- [REQUIRED, FALLBACK]
--- Formats a spell, as passed to {{{icon:SetInfo("spell", spell)}}}, for human-readable output. This is a base method written for handling spells. It should be overridden for IconTypes that don't take spell input for their ics.Name setting.
-- @param icon [TMW.Classes.Icon] The icon that the spell is being formatted for.
-- @param data [.*] The data that needs to be formatted, as it was passed to {{{icon:SetInfo("spell", data)}}}.
-- @param doInsertLink [boolean] Whether or not a [[http://wowprogramming.com/docs/api_types#hyperlink|clickable link]] should be returned.
-- @return [string] The formatted data. suitable for human-readable output.
-- @return [boolean|nil] True if the formatted data might not have proper capitalization (caller will attempt to correct capitalization if this is true).
-- @usage -- This method should only be called internally by TellMeWhen and some of its components.
-- texture = TMW.Types.cooldown:FormatSpellForOutput(icon, icon.attributes.spell, true)
function IconType:FormatSpellForOutput(icon, data, doInsertLink)
	self:AssertSelfIsInstance()
	
	if data then
		local name
		if doInsertLink then
			name = GetSpellLink(data)
		else
			name = GetSpellInfo(data)
		end
		if name then
			return name
		end
	end
	
	return data, true
end

-- [REQUIRED, FALLBACK]
--- Attempts to figure out what the configuration texture of an icon will be without actually creating the icon. This is a base method written for handling spells. It should be overridden for IconTypes that don't take spell input for their ics.Name setting. It is acceptable to delay the declaration of overrides of this method until after TellMeWhen_Options has loaded if needed.
-- @param ics [TMW.Icon_Defaults] The settings of the icon that the texture is being guessed for.
-- @return [string] The guessed texture of the icon. 
-- @usage -- This method should only be called internally by TellMeWhen and some of its components. 
-- texture = TMW.Types[ics.Type]:GuessIconTexture(ics)
function IconType:GuessIconTexture(ics)
	self:AssertSelfIsInstance()
	
	if ics.Name and ics.Name ~= "" then

		local name = TMW:GetSpells(ics.Name).First
		if name then
			return GetSpellTexture(name)
		end
	end

	if self.usePocketWatch then
		return "Interface\\Icons\\INV_Misc_PocketWatch_01"
	end
end



-- [FALLBACK]
--- Gets the icon texture that will be used for the icon in configuration mode. This is a base method written for handling spells. It should be overridden for IconTypes that don't take spell input for their ics.Name setting. It is acceptable to delay the declaration of overrides of this method until after TellMeWhen_Options has loaded if needed.
-- @param icon [TMW.Classes.Icon] The icon to get the config mode texture for.
-- @return [string] The texture path of the texture to use.
-- @usage icon:SetInfo("texture", Type:GetConfigIconTexture(icon))
function IconType:GetConfigIconTexture(icon)
	if icon.Name == "" and not self.AllowNoName then
		return "Interface\\Icons\\INV_Misc_QuestionMark", nil
	else
	
		if icon.Name ~= "" then

			local tbl = TMW:GetSpells(icon.Name).Array

			for _, name in ipairs(tbl) do
				local t = GetSpellTexture(name)
				if t then
					return t, true
				end
			end
		end
		
		if self.usePocketWatch then
			if icon:IsBeingEdited() == "MAIN" then
				TMW.HELP:Show{
					code = "ICON_POCKETWATCH_FIRSTSEE",
					icon = nil,
					relativeTo = TMW.IE.icontexture,
					x = 0,
					y = 0,
					text = L["HELP_POCKETWATCH"],
				}
			end
			return "Interface\\Icons\\INV_Misc_PocketWatch_01", false
		else
			return "Interface\\Icons\\INV_Misc_QuestionMark", false
		end
	end
end


-- [REQUIRED, FALLBACK]
--- Handles dragging spells, items, and other things onto an icon. This is a base method written for handling spells. It should be overridden for IconTypes that don't take spell input for their ics.Name setting. It is acceptable to delay the declaration of overrides of this method until after TellMeWhen_Options has loaded if needed.
-- @paramsig icon, ...
-- @param icon [TMW.Classes.Icon] The icon that the dragged data was released onto.
-- @param ... [...] The return values from [[http://wowprogramming.com/docs/api/GetCursorInfo|GetCursorInfo()]]. Don't call GetCursorInfo yourself in your definition, because TMW will pass in its own data in special cases that can't be obtained from GetCursorInfo.
-- @return [boolean|nil] Should return true if data from the drag was succesfully added to the icon, otherwise nil.
function IconType:DragReceived(icon, t, data, subType, param4)
	self:AssertSelfIsInstance()
	
	local ics = icon:GetSettings()

	if t ~= "spell" then
		return
	end

	local input
	if data == 0 and type(param4) == "number" then
		-- I don't remember the purpose of this anymore.
		-- It handles some special sort of spell, though, and is required.
		input = GetSpellInfo(param4)
	else
		local type, baseSpellID = GetSpellBookItemInfo(data, subType)
		
		if not baseSpellID or type ~= "SPELL" then
			return
		end
		
		
		local currentSpellName = GetSpellBookItemName(data, subType)		
		local baseSpellName = GetSpellInfo(baseSpellID)
		
		input = baseSpellName or currentSpellName
	end

	ics.Name = TMW:CleanString(ics.Name .. ";" .. input)
	return true -- signal success
end

-- [REQUIRED, FALLBACK]
--- Returns brief information about what an icon is configured to track. Used mainly in import/export menus. This is a default method, and may be overridden if it does not provide the desired functionality for an IconType. It is acceptable to delay the declaration of overrides of this method until after TellMeWhen_Options has loaded if needed.
-- @param ics [TMW.Icon_Defaults] The settings of the icon that information is being requested about.
-- @return [string] The title text that can be displayed in a tooltip.
-- @return [string] The body text that can be displayed in a tooltip.
function IconType:GetIconMenuText(ics)
	self:AssertSelfIsInstance()
	
	local text = ics.Name or ""
	local tooltip =	""

	return text, tooltip
end

-- [REQUIRED, FALLBACK]
--- Returns true if the duration provided is a global cooldown. This is a default method, and may be overridden if it does not provide the desired functionality for an IconType. To declare that an icon type does not handle global cooldowns, set {{{IconType.hasNoGCD = true}}}. In contexts where the icon type is static, you may use TMW.OnGCD(duration) to provide the same functionality. {{{Icon:OnGCD(duration)}}} is a wrapper around this method.
-- @param icon [TMW.Classes.Icon] The icon that the GCD is being checked for.
-- @param duration [number] The duration to check. This should be the total duration of the cooldown (e.g. the second return from GetSpellCooldown()), not the remaining duration.
-- @return [boolean] True if the duration passed in is a global cooldown, otherwise false.
function IconType:OnGCD(icon, duration)
	if self.hasNoGCD then
		return false
	end

	return OnGCD(duration)
end

--- Register the IconType for use in TellMeWhen. IconTypes cannot be used or accessed until this method is called. Should be the very last line of code in the file that defines an IconType.
-- @param order [number] The order of this IconType relative to other IconTypes in configuration UI.
-- @return self [TMW.Classes.IconType] The IconType this method was called on.
-- @usage IconType:Register(10)
function IconType:Register(order)
	self:AssertSelfIsInstance()
	
	TMW:ValidateType("IconType.name", "IconType:Register(order)", self.name, "function;string")
	TMW:ValidateType("IconType.desc", "IconType:Register(order)", self.desc, "function;string;nil")
	TMW:ValidateType("IconType.tooltipTitle", "IconType:Register(order)", self.tooltipTitle, "function;string;nil")
	TMW:ValidateType("IconType.menuIcon", "IconType:Register(order)", self.menuIcon, "function;string;number;nil")
	TMW:ValidateType("IconType.menuSpaceBefore", "IconType:Register(order)", self.menuSpaceBefore, "boolean;nil")
	TMW:ValidateType("IconType.menuSpaceAfter", "IconType:Register(order)", self.menuSpaceAfter, "boolean;nil")
	TMW:ValidateType("IconType.hidden", "IconType:Register(order)", self.menuSpaceAfter, "function;boolean;nil")
	
	TMW:ValidateType("2 (order)", "IconType:Register(order)", order, "number")
	
	local typekey = self.type 
	
	self.order = order
	
	self.RelevantSettings = self.RelevantSettings or {}
	setmetatable(self.RelevantSettings, RelevantToAll)

	if TMW.debug and rawget(TMW.Types, typekey) then
		-- for tweaking and recreating icon types inside of WowLua so that I don't have to change the typekey every time.
		typekey = typekey .. " - " .. date("%X")
		self.name = typekey
		self.type = typekey
	end

	TMW.Types[typekey] = self -- put it in the main Types table
	tinsert(TMW.OrderedTypes, self) -- put it in the ordered table (used to order the type selection dropdown in the icon editor)
	TMW:SortOrderedTables(TMW.OrderedTypes)
	
	-- Try to find processors for the attributes declared for the icon type.
	-- It should find most since default processors are loaded before icon types.
	self:UpdateUsedProcessors()
	
	-- Listen for any new processors, too, and update when they are created.
	TMW:RegisterCallback("TMW_CLASS_IconDataProcessor_INSTANCE_NEW", self, "UpdateUsedProcessors")
	
	return self -- why not?
end

local doneImplementingDefaults
--- Declare that an IconType uses a specified attributesString.
-- @param attributesString [string] The attributesString whose usage state is being set. (an attributesString is passed as a segment of the first arg to {{{icon:SetInfo(attributesStrings, ...)}}}, and also as the second arg to the constructor of a TMW.Classes.IconDataProcessor).
-- @param uses [boolean|nil] False if the IconType does NOT use the specified attributesString. True or nil if it does use the attributesString.
-- @usage IconType:UsesAttributes("start, duration")
-- IconType:UsesAttributes("conditionFailed", false)
function IconType:UsesAttributes(attributesString, uses)
	if doneImplementingDefaults then
		self:AssertSelfIsInstance()
	end
	
	TMW:ValidateType("3 (uses)", "IconView:Register(attributesString, uses)", uses, "boolean;nil")
	
	if uses == false then
		self.UsedAttributes[attributesString] = nil
	else
		self.UsedAttributes[attributesString] = true
	end
end

-- [INTERNAL]
function IconType:UpdateUsedProcessors()
	self:AssertSelfIsInstance()
	
	for _, Processor in ipairs(TMW.Classes.IconDataProcessor.instances) do
		if self.UsedAttributes[Processor.attributesString] then
			self.UsedAttributes[Processor.attributesString] = nil
			self.UsedProcessors[Processor] = true
		end
	end
end

-- [INTERNAL]
function IconType:OnImplementIntoIcon(icon)	
	self.Icons[#self.Icons + 1] = icon

	-- Implement all of the Processors that the Icon Type uses into the icon.
	for Processor in pairs(self.UsedProcessors) do
		Processor:ImplementIntoIcon(icon)
	end
	
	
	-- ProcessorHook:ImplementIntoIcon() needs to happen in a separate loop, 
	-- and not as a method extension of Processor:ImplementIntoIcon(),
	-- because ProcessorHooks need to check and see if the icon is implementing
	-- all of the Processors that the hook has required for the hook to implement itself.
	-- If this were to happen in the first loop here, then it would frequently fail because
	-- dependencies might not be implemented before the hook would get implemented.
	for Processor in pairs(self.UsedProcessors) do
		for _, ProcessorHook in ipairs(Processor.hooks) do
		
			-- Assume that we have found all of the Processors that we need until we can't find one.
			local foundAllProcessors = true
			
			-- Loop over all Processor requirements for this ProcessorHook
			for processorRequirementName in pairs(ProcessorHook.processorRequirements) do
				-- Get the actual Processor instance
				local Processor = TMW.Classes.IconDataProcessor.ProcessorsByName[processorRequirementName]
				
				-- If the Processor doesn't exist or the icon doesn't implement it,
				-- fail the test and break the loop.
				if not Processor or not tContains(icon.Components, Processor) then
					foundAllProcessors = false
					break
				end
			end
			
			-- Everything checked out, so implement it into the icon.
			if foundAllProcessors then
				ProcessorHook:ImplementIntoIcon(icon)
			end
		end
	end
end

-- [INTERNAL]
function IconType:OnUnimplementFromIcon(icon)
	tDeleteItem(self.Icons, icon)
	
	-- Unimplement all of the Processors that the Icon Type uses from the icon.
	for Processor in pairs(self.UsedProcessors) do
	
		-- ProcessorHooks are fine being unimplemented in the same loop since there
		-- is no verification or anything like there is when imeplementing them
		for _, ProcessorHook in ipairs(Processor.hooks) do
			ProcessorHook:UnimplementFromIcon(icon)
		end
		
		Processor:UnimplementFromIcon(icon)
	end
end

--- Sets whether a certain IconModule can be implemented into an icon when the IconType is used by the icon.
-- @param moduleName [string] A string that identifies the module.
-- @param allow [boolean] True if the module should be allowed to implement when the IconType is used by the icon. Otherwise false. Cannot be nil.
-- @usage Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)
function IconType:SetModuleAllowance(moduleName, allow)
	local IconModule = TMW.Classes[moduleName]
	
	if IconModule and IconModule.SetAllowanceForType then
		IconModule:SetAllowanceForType(self.type, allow)

	elseif not IconModule then
		TMW:RegisterSelfDestructingCallback("TMW_CLASS_NEW", function(event, class)
			if class.className == moduleName and class.SetAllowanceForType then
				local IconModule = class
				IconModule:SetAllowanceForType(self.type, allow)

				return true -- Signal callback destruction
			end
		end)
	end
end

--- Sets whether the icon type will function when a certain IconView is used by the icon's group.
-- @param viewName [string] A string that identifies the view.
-- @param allow [boolean] True if the type should function when the IconView is used by the icon. Otherwise false. Cannot be nil.
-- @usage Type:SetAllowanceForView("icon", false)
function IconType:SetAllowanceForView(viewName, allow)
	self:AssertSelfIsInstance()
	
	TMW:ValidateType(2, "IconType:SetAllowanceForView()", viewName, "string")
	
	-- allow cannot be nil
	TMW:ValidateType(3, "IconType:SetAllowanceForView()", allow, "boolean")
	
	if self.ViewAllowances[viewName] == nil then
		self.ViewAllowances[viewName] = allow
	else
		TMW:Error("An icon type's view allowance cannot be set once it has already been declared by either a view or an icon type.")
	end
end

--- Sets the default allowance for implementing this [[api/icon-type/api-documentation/|IconType]]. Default value is {{{true}}}, meaning that types can be implemented unless it has been set otherwise by a call to {{{:SetViewAllowance(viewName, false)}}}. Set to {{{false}}} to prevent this [[api/icon-type/api-documentation/|IconType]] from functioning unless it has been explicitly allowed by a call to {{{:SetViewAllowance(viewName, true)}}}.
-- @param allow [boolean] The default view allowance for this [[api/icon-type/api-documentation/|IconType]].
-- @usage
-- -- Example of usage by "resource", which should only be explicitly allowed by views that implement a
-- -- descendant of IconModule_TimerBar that is the primary feature of the icon.
-- 
-- TMW.Types.resouce:SetDefaultAllowanceForTypes(false)
-- 
-- -- Icon views that wish to allow "resource" should call the following:
-- View:SetTypeAllowance("resource", true)
function IconType:SetDefaultAllowanceForViews(allow)
	self:AssertSelfIsInstance()
	
	TMW:ValidateType(2, "IconType:SetDefaultAllowanceForViews()", allow, "boolean")
	
	self.defaultAllowanceForViews = allow
end

--- Checks whether this [[api/icon-type/api-documentation/|IconType]] will be allowed to function in icons that implement a specified [[api/icon-view/api-documentation/|IconView]].
-- @param viewName [string] The identifier of a [[api/icon-view/api-documentation/|IconView]] instance as passed to the first param of [[api/icon-view/api-documentation/|IconView]]'s constructor.
-- @return [boolean] True if this [[api/icon-type/api-documentation/|IconType]] will be allowed to implement alongside the specified [[api/icon-view/api-documentation/|IconView]].
-- @usage isAllowed = TMW.Types.resource:IsAllowedByType("icon")
function IconType:IsAllowedByView(viewName)
	local viewAllowance = self.ViewAllowances[viewName]
	if viewAllowance ~= nil then
		return viewAllowance
	else
		return self.defaultAllowanceForViews
	end
end

IconType:RegisterConfigPanel_ConstructorFunc(1, "TellMeWhen_IsViewAllowed", function(self)
	self:SetTitle(L["ICONMENU_VIEWREQ"])

	self.text = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	self.text:SetWordWrap(true)
	self.text:SetPoint("TOP", 0, -10)
	self.text:SetText(L["ICONMENU_VIEWREQ_DESC"])
	self.text:SetWidth(self:GetWidth() - 15)
	self:SetHeight(self.text:GetStringHeight() + 20)

	self:SetScript("OnSizeChanged", function()
		self:SetHeight(self.text:GetStringHeight() + 20)
	end)

	self:CScriptAdd("PanelSetup", function()
		if TMW.CI.icon.typeData:IsAllowedByView(TMW.CI.icon.group.View) then
			self:Hide()
		end
	end)
end)


-- [REQUIRED IF USED, FALLBACK]
--- Processes data passed from icon:YieldInfo(hasInfo, ...) and sets it on iconToSet. You must override this method if your icon type's methods call icon:YieldInfo().
-- @param icon [TMW.Classes.Icon] The icon that yielded the info.
-- @param iconToSet  [TMW.Classes.Icon] The icon that should recieve the yielded info.
-- @param ... [vararg] The parameters passed info icon:YieldInfo(hasInfo, ...).
function IconType:HandleYieldedInfo(icon, iconToSet, ...)
	TMW:Error("If your icon type %q calls icon:YieldInfo(hasInfo, ...), you must define an IconType:HandleYieldedInfo(icon, iconToSet, ...) method.", self.type)
end

IconType:RegisterIconEvent(100, "OnEventsRestored", {
	category = L["EVENT_CATEGORY_MISC"],
	text = L["SOUND_EVENT_ONEVENTSRESTORED"],
	desc = L["SOUND_EVENT_ONEVENTSRESTORED_DESC"],
})

IconType:UsesAttributes("alphaOverride")
IconType:UsesAttributes("realAlpha")
IconType:UsesAttributes("calculatedState")
IconType:UsesAttributes("conditionFailed")

doneImplementingDefaults = true
