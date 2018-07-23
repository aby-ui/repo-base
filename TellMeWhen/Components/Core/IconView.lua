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

local rawget, date, tinsert, ipairs, error, ceil
	= rawget, date, tinsert, ipairs, error, ceil


--- [[api/icon-views/api-documentation/|IconView]] is the class of all Icon Views.
-- IconView inherits explicitly from [[api/base-classes/group-component/|GroupComponent]] and [[api/base-classes/icon-component/|IconComponent]], and implicitly from the classes that they inherit. 
-- 
-- Icon Views allows users to customize the way that an icon's information is displayed on a macroscopic level. The default Icon View (also used as the fallback when a requested IconView cannot be found) is "icon". To create a new IconView, make a new instance of the IconView class.
-- 
-- Instructions on how to use this API can be found at [[api/icon-views/how-to-use/]]
-- 
-- @class file
-- @name IconView.lua



--- The fields avaiable to instances of TMW.Classes.IconView. TMW.Classes.IconView Inherits TMW.Classes.GroupComponent and TMW.Classes.IconComponent.
-- @class table
-- @name TMW.Classes.IconView
-- @field name [string] [REQUIRED] A localized string that names the IconView.
-- @field desc [string] [REQUIRED] A localized string that describes the IconView.
-- @field view [string] A short string that will identify the IconView across the addon. Set through the constructor, and should not be modified.
-- @field order [number] A number that determines the display order of the IconView in configuration UIs. Set through IconView:Register and should not be modified.

local IconView = TMW:NewClass("IconView", "GroupComponent", "IconComponent")
IconView.ModuleImplementors = {}

IconView.DefaultPanelSet = "group"




------------------------------------
-- Constructor
------------------------------------

--- Constructor - Creates a new IconView
-- @name IconView:New
-- @param view [string] A short string that will identify the IconView across the addon.
-- @usage IconView = TMW.Classes.IconView:New("icon")
function IconView:OnNewInstance(view)
	self.view = view
	
	--TMW.Icon_Defaults.SettingsPerView[view] = {}
	self:InheritTable(self.class, "ModuleImplementors")
end



------------------------------------
-- Provided Methods
------------------------------------

--- Register the IconView for use in TellMeWhen. IconViews cannot be used or accessed until this method is called. Should be the very last line of code in the file that defines an IconView.
-- @param order [number] The order of this IconView relative to other IconViews in configuration UI.
-- @return self [TMW.Classes.IconView] The IconView this method was called on.
-- @usage IconView:Register(10)
function IconView:Register(order)
	self:AssertSelfIsInstance()
	TMW:ValidateType("IconView.name", "IconView:Register(order)", self.name, "string")
	TMW:ValidateType("IconView.desc", "IconView:Register(order)", self.desc, "string")
	TMW:ValidateType("2 (order)", "IconView:Register(order)", order, "number")

	local viewkey = self.view
	
	self.order = order

	if TMW.debug and rawget(TMW.Views, viewkey) then
		-- for tweaking and recreating icon views inside of WowLua so that I don't have to change the viewkey every time.
		viewkey = viewkey .. " - " .. date("%X")
		self.view = viewkey
		self.name = viewkey
	end

	TMW.Views[viewkey] = self -- put it in the main Views table
	tinsert(TMW.OrderedViews, self)
	TMW:SortOrderedTables(TMW.OrderedViews)

	TMW:Fire("TMW_VIEW_REGISTERED", self)
	
	return self -- why not?
end


local function DefaultImplementorFunc(Module)
	Module:Enable()
end
local doneImplementingDefaults

--- Declare that the IconView should implement a specified IconModule or GroupModule.
-- @param moduleName [string] A string that identifies the requested module's class. The module doesn't have to exist when {{{:ImplementsModule()}}} is called, and if the module class does not exist when it comes time to implement it, no error will be thrown.
-- @param order [number] The order that this module should be implemented in, relative to other modules of the same kind (icon or group) implemented by this IconView. 
-- @param implementorFunc [function|boolean|nil] One of the following:
-- 		* [function] A function that will be called when the module is implemented into a group or icon. Should be used when a module requires some sort of setup (like anchoring to its parent GenericModuleImplementor) to function correctly. Signature of this method is (Module, ModuleImplementor).
--		* [true] True to use the default implementor function, which is equivalent to {{{function(Module) Module:Enable() end}}}.
--		* [false] False if the module should not implement. Should only be used as an override to disable the implementation of a module.
--		* [nil] Nil if the module should implement, but no action should be taken when it is implemented (no implementorFunc will be called).
-- @usage 
--	IconView:ImplementsModule("GroupModule_GroupPosition", 1, true)
--	
--	IconView:ImplementsModule("IconModule_CooldownSweep", 20, function(Module, icon)
--		-- icon.ShowTimer and icon.ShowTimerText are defined on icon because this method is called after implementation is complete.
--		if icon.ShowTimer or icon.ShowTimerText then
--			Module:Enable()
--		end
--		
--		-- Configure the module. ICON_SIZE is defined elsewhere.
--		Module.cooldown:ClearAllPoints()
--		Module.cooldown:SetSize(ICON_SIZE, ICON_SIZE)
--		Module.cooldown:SetPoint("CENTER", icon)
--	end)
function IconView:ImplementsModule(moduleName, order, implementorFunc)
	if doneImplementingDefaults then
		self:AssertSelfIsInstance()
	end
	
	TMW:ValidateType(2, "IconView:ImplementsModule()", moduleName, "string")
	TMW:ValidateType(3, "IconView:ImplementsModule()", order, "number")
	
	if implementorFunc == true then
		implementorFunc = DefaultImplementorFunc
	end
	
	self.ModuleImplementors[#self.ModuleImplementors+1] = {
		order = order,
		moduleName = moduleName,
		implementorFunc = implementorFunc,
	}
	
	TMW:SortOrderedTables(self.ModuleImplementors)
end

--- Query if an IconView implements a specified module.
-- @param moduleName [string] A string that identifies the queried module.
-- @return [boolean] Boolean indicating if the IconView does implement the queried module.
-- @usage 
-- -- Check if a module is implemented by a specific IconView.
-- implements = TMW.Views.icon:DoesImplementModule("IconModule_CooldownSweep")
-- 
-- -- Check if a module is implemented by default to all IconViews (can be overridden on a per-IconView basis).
-- implements = TMW.Classes.IconView:DoesImplementModule("IconModule_CooldownSweep")
function IconView:DoesImplementModule(moduleName)
	for i, implementationData in ipairs(self.ModuleImplementors) do
		if moduleName == implementationData.moduleName then
			return implementationData.implementorFunc ~= false
		end
	end
	
	return false
end

--- Sets whether the IconType will function when this IconView is used by the icon's group.
-- @param viewName [string] A string that identifies the type.
-- @param allow [boolean] True if the type should function when this IconView is used by the icon. Otherwise false. Cannot be nil.
-- @usage View:SetTypeAllowance("cooldown", false)
function IconView:SetTypeAllowance(typeName, allow)
	local IconType = rawget(TMW.Types, typeName)
	
	if IconType and IconType.SetViewAllowance then
		IconType:SetViewAllowance(self.view, allow)
		
	elseif not IconType then
		TMW:RegisterSelfDestructingCallback("TMW_CLASS_IconType_INTANCE_NEW", function(event, instance)
			if instance.type == typeName and instance.SetViewAllowance then
				instance:SetViewAllowance(self.view, allow)

				return true -- Signal callback destruction
			end
		end)
	end
end


------------------------------------
-- Required Method Definitions 
------------------------------------

--- [**Required Method Definition**] Method that will be called immediately before the IconView (and all its requested IconModules) has been implemented into an icon. Should be used to preform actions like setting the size of the icon and other things that the icon's modules depend upon.
-- @param icon [TMW.Classes.Icon] The icon the IconView was just implemented into.
function IconView:Icon_Setup(icon)
	self:AssertSelfIsInstance()
	error("IconView:Icon_Setup(icon) is a required method, but the default was called!")
end

--- [**Required Method Definition**] Method that will return the size of the icon. This is used to determine positioning information.
-- @param icon [TMW.Classes.Icon] The icon whose size is being queried.
-- @return x [number] The width of the icon.
-- @return y [number] The height of the icon.
function IconView:Icon_GetSize(icon)
	self:AssertSelfIsInstance()
	error("IconView:Icon_GetSize(icon) is a required method, but the default was called!")
end

--- [**Required Method Definition**] Method that will be called immediately after the IconView (and all its requested GroupModules) has been implemented into a group. Can be used to preform actions like setting the size of the group, or other things that aren't already done by any of the group's modules.
-- @param group [TMW.Classes.Group] The group the IconView was just implemented into.
function IconView:Group_Setup(group)
	self:AssertSelfIsInstance()
	error("IconView:Group_Setup(group) is a required method, but the default was called!")
end



------------------------------------
-- Optional Method Definitions 
------------------------------------

--- [**Optional Method Definition**] Method that will be called when a new group that uses this IconView is manually created by the user. Does not happen for importing a group. Should be used to modify the default settings of a group to better fit the view. 
-- @param gs [TMW.Group_Defaults] The settings of the group that was just created. This method does not provide access to an actual TMW.Classes.Group since one will not have been created before this is called.
-- @usage
--	function IconView:Group_OnCreate(gs)
--		-- Switch the default number of rows with the number of columns. This is the default behavior for TMW.Views.bar
--		gs.Rows, gs.Columns = gs.Columns, gs.Rows
--	end
function IconView:Group_OnCreate(gs)
	-- Optional method. Default implementation is no action.
end

--- [**Optional Method Definition**] Method that will be called immediately after the IconView (and all its requested IconModules) has been implemented into an icon. Can be used to preform actions that depend on the icon's modules being implemented.
-- @param icon [TMW.Classes.Icon] The icon the IconView was just implemented into.
function IconView:Icon_Setup_Post(icon)
	self:AssertSelfIsInstance()
end



------------------------------------
-- Internal Methods
------------------------------------

-- [INTERNAL] Method called when the IconView is implemented into an icon. Should not be called manually. Should not be overriden. Purpose is to implement all the IconView's requested modules into the icon.
function IconView:OnImplementIntoIcon(icon)
	for i, implementationData in ipairs(self.ModuleImplementors) do
		local moduleName = implementationData.moduleName
		local implementorFunc = implementationData.implementorFunc
		
		-- implementorFunc is:
			-- nil if no function is defined, but the module should still implement
			-- function that should be called when the midle is implement (Module.OnImplementIntoIcon handles the calling)
			-- false if the module should not implement.
		
		-- Get the class of the module that we might be implementing.
		local ModuleClass = moduleName:find("IconModule") and TMW.Classes[moduleName]
			
		-- If the class exists and the module should be implemented, then proceed to check Processor requirements.
		if implementorFunc ~= false and ModuleClass then
		
			-- Check to see if an instance of the Module already exists for the icon before creating one.
			local Module = icon.Modules[moduleName]
			
			-- Don't create the module if it is disallowed for the default icon type and the icon uses the default icon type.
			if not Module and not (icon:GetSettings().Type == "" and not ModuleClass:IsAllowedByType("")) then
				Module = ModuleClass:New(icon)
			end


			if Module then
			
				Module.implementationData = implementationData
				
				-- Implement the module into the icon.
				Module:ImplementIntoIcon(icon)
			end
		end
	end
end

-- [INTERNAL] Method called when the IconView is unimplemented from an icon. Should not be called manually. Should not be overriden. Purpose is to unimplement all the IconView's requested modules from the icon.
function IconView:OnUnimplementFromIcon(icon)
	for i, implementationData in ipairs(self.ModuleImplementors) do
		local moduleName = implementationData.moduleName
		
		-- Make sure that the module is a IconModule
		local Module = moduleName:find("IconModule") and icon.Modules[moduleName]
		
		if Module then
			Module:UnimplementFromIcon(icon)
			Module.implementationData = nil
		end
	end
end


-- [INTERNAL] Method called when the IconView is implemented into a group. Should not be called manually. Should not be overriden. Purpose is to implement all the IconView's requested modules into the group.
function IconView:OnImplementIntoGroup(group)
	for i, implementationData in ipairs(self.ModuleImplementors) do
		local moduleName = implementationData.moduleName
		local implementorFunc = implementationData.implementorFunc
		
		-- implementorFunc is:
			-- nil if no function is defined, but the module should still implement
			-- function that should be called when the midle is implement (Module.OnImplementIntoIcon handles the calling)
			-- false if the module should not implement.
		
		-- Get the class of the module that we might be implementing.
		local ModuleClass = moduleName:find("GroupModule") and TMW.Classes[moduleName]
		
		-- If the class exists and the module should be implemented, then do it.
		if implementorFunc and ModuleClass then
		
			-- Check to see if an instance of the Module already exists for the group before creating one.
			local Module = group.Modules[moduleName]
			if not Module then
				Module = ModuleClass:New(group)
			end
			
			Module.implementationData = implementationData
			
			-- Implement the Module into the group
			Module:ImplementIntoGroup(group)
		end
	end
end

-- [INTERNAL] Method called when the IconView is implemented into a group. Should not be called manually. Should not be overriden. Purpose is to implement all the IconView's requested modules into the group.
function IconView:OnUnimplementFromGroup(group)
	for i, implementationData in ipairs(self.ModuleImplementors) do
		local moduleName = implementationData.moduleName
		
		-- Make sure that the module is a GroupModule		
		local Module = moduleName:find("GroupModule") and group.Modules[moduleName]
		
		if Module then
			Module:UnimplementFromGroup(group)
			Module.implementationData = nil
		end
	end
end


-- Default modules
IconView:ImplementsModule("GroupModule_BaseConfig", 0.5, true)
IconView:ImplementsModule("GroupModule_GroupPosition", 1, true)
IconView:ImplementsModule("GroupModule_Alpha", 1.5, true)

IconView:ImplementsModule("IconModule_Self", 0, true)
IconView:ImplementsModule("IconModule_IconEventClickHandler", 2, true)
IconView:ImplementsModule("IconModule_IconEventOtherShowHideHandler", 2.5, true)
IconView:ImplementsModule("IconModule_IconEventConditionHandler", 2.7, true)
IconView:ImplementsModule("IconModule_RecieveSpellDrags", 3, true)
IconView:ImplementsModule("IconModule_IconDragger", 4, true)
IconView:ImplementsModule("IconModule_GroupMover", 5, true)
IconView:ImplementsModule("IconModule_Tooltip", 6, true)
IconView:ImplementsModule("IconModule_IconEditorLoader", 7, true)

doneImplementingDefaults = true
