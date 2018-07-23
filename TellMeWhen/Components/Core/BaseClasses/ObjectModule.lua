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

local pairs = pairs


--- [[api/base-classes/object-module/|ObjectModule]] is a base class of any objects that will be implemented into a [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]]. A [[api/base-classes/object-module/|ObjectModule]] provides frames, script handling, and other functionality to a [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]]. 
-- 
-- ObjectModule provides a common base for these objects, and it provides methods for enabling, disabling, and modifying script handlers. It is an abstract class, and should not be directly instantiated. All classes that inherit from [[api/base-classes/object-module/|ObjectModule]] should not be instantiated outside of the internal code used by a [[api/icon-views/api-documentation/|IconView]]. To create a new module, create a new class and inherit [[api/base-classes/object-module/|ObjectModule]] or another class that directly or indirectly inherits from [[api/base-classes/object-module/|ObjectModule]].
-- 
-- @class file
-- @name ObjectModule.lua


local ObjectModule = TMW:NewClass("ObjectModule")
ObjectModule.ScriptHandlers = {}


function ObjectModule:OnNewInstance_ObjectModule(parent)
	local className = self.className
	
	for script, func in pairs(self.ScriptHandlers) do
		parent:HookScript(script, function(parent, ...)
			local Module = parent.Modules[className]
			if Module and Module.IsEnabled then
				func(Module, parent, ...)
			end
		end)
	end
end

function ObjectModule:OnClassInherit_ObjectModule(newClass)
	newClass.NumberEnabled = 0
	
	newClass:InheritTable(self, "ScriptHandlers")
end

--- Enables an instance of a [[api/base-classes/object-module/|ObjectModule]]. An [[api/base-classes/object-module/|ObjectModule]] should, and will, only function when it is enabled.
function ObjectModule:Enable()
	self:AssertSelfIsInstance()
	
	if not self.IsEnabled then
		self.IsEnabled = true
		self.class.NumberEnabled = self.class.NumberEnabled + 1
		if self.class.NumberEnabled == 1 and self.class.OnUsed then
			TMW.safecall(self.class.OnUsed, self.class)
		end
		
		if self.OnEnable then
			TMW.safecall(self.OnEnable, self)
		end
	end
end

local queuedDisableDelayed = {}
local timerStarted = false
local function OnDisableDelayedHandler()
	timerStarted = false
	for i, module in ipairs(queuedDisableDelayed) do
		if not module.IsEnabled then
			TMW.safecall(module.OnDisableDelayed, module)
		end
	end
	wipe(queuedDisableDelayed)
end
local function QueueDisableDelayed(module)
	queuedDisableDelayed[#queuedDisableDelayed + 1] = module

	if not timerStarted then
		C_Timer.After(0, OnDisableDelayedHandler)
		timerStarted = true
	end
end

--- Disables an instance of a [[api/base-classes/object-module/|ObjectModule]]. An [[api/base-classes/object-module/|ObjectModule]] should, and will, only function when it is enabled.
function ObjectModule:Disable()
	self:AssertSelfIsInstance()
	
	if self.IsEnabled then
		self.IsEnabled = false
		self.class.NumberEnabled = self.class.NumberEnabled - 1
		if self.class.NumberEnabled == 0 and self.class.OnUnused then
			TMW.safecall(self.class.OnUnused, self.class)
		end
		
		if self.OnDisable then
			TMW.safecall(self.OnDisable, self)
		end
		if self.OnDisableDelayed then
			QueueDisableDelayed(self)
		end
	end
end

--- Sets a script handler that interacts with any [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]] that have implemented an instance of this [[api/base-classes/object-module/|ObjectModule]]. This script handler will only be active when {{{ObjectModule.IsEnabled == true}}} for an implemented instance. This method must be called on a class - you cannot set the script handler separately for individual instances of [[api/base-classes/object-module/|ObjectModule]].
-- @param script [string] A script to set, like "OnClick" or "OnDragStart".
-- @param func [function|nil] A function that will be used a script handler. Pass nil to remove any inherited script handlers.
-- @usage -- Example usage from IconModule_RecieveSpellDrags:
--	Module:SetScriptHandler("OnReceiveDrag", function(Module, icon, button)
--		if not TMW.Locked and TMW.IE then
--			TMW.IE:SpellItemToIcon(icon)
--		end
--	end)
function ObjectModule:SetScriptHandler(script, func)
	self:AssertSelfIsClass()
	
	TMW:ValidateType(2, "Module:SetScriptHandler()", script, "string")
	
	self.ScriptHandlers[script] = func
end


--- Provides a wrapper around [[api/icon-views/api-documentation/|IconView]]{{{:ImplementsModule()}}} that allows you to instruct an instance of [[api/icon-views/api-documentation/|IconView]] to implement a module without having direct access to that view instance.
-- @param viewName [string] The identifier of a [[api/icon-views/api-documentation/|IconView]] as passed to the first param of [[api/icon-views/api-documentation/|IconView]]'s constructor.
-- @param order [number] The order that this module should be implemented in, relative to other modules of the same kind (icon or group) implemented by the specified [[api/icon-views/api-documentation/|IconView]]. 
-- @param implementorFunc [function|boolean|nil] See [[api/icon-views/api-documentation/|IconView]]{{{:ImplementsModule()}}}'s documentation for a description of this param.
-- @see http://wow.curseforge.com/addons/tellmewhen/pages/api/icon-views/api-documentation/#w-icon-view-implements-module-module-name-order-implementor
function ObjectModule:SetImplementorForView(viewName, order, implementorFunc)
	self:AssertSelfIsClass()
	
	local IconView = TMW.Views[viewName]
	local moduleName = self.className
	
	if IconView then
		IconView:ImplementsModule(moduleName, order, implementorFunc)
	else
		TMW:RegisterCallback("TMW_VIEW_REGISTERED", function(event, IconView)
			if IconView.view == viewName then
				IconView:ImplementsModule(moduleName, order, implementorFunc)
			end
		end)
	end
end
