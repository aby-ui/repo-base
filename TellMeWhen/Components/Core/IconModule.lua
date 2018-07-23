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

local pairs, type, rawget, assert, tostring
	= pairs, type, rawget, assert, tostring
	

--- [[api/icon-module/api-documentation/|IconModule]] is a base class of any modules that will be implemented into a [[api/icon/api-documentation/|Icon]]. A [[api/icon-module/api-documentation/|IconModule]] provides frames, script handling, and other functionality to classes that inherit from it.
-- 
-- [[api/icon-module/api-documentation/|IconModule]] inherits from [[api/base-classes/icon-component/|IconComponent]] and [[api/base-classes/object-module/|ObjectModule]], and implicitly from the classes that they inherit. 
-- 
-- [[api/icon-module/api-documentation/|IconModule]] provides a common base for these objects. It provides methods for event handling, data handling, component skinning with Masque, and exposing frames for anchoring purposes. It is an abstract class, and should not be directly instantiated. All classes that inherit from [[api/icon-module/api-documentation/|IconModule]] should not be instantiated outside of the internal code used by a [[api/icon-views/api-documentation/|IconView]]. To create a new module, create a new class and inherit [[api/icon-module/api-documentation/|IconModule]] or another class that directly or indirectly inherits from [[api/icon-module/api-documentation/|IconModule]]. 
-- 
-- @class file
-- @name IconModule.lua


local IconModule = TMW:NewClass("IconModule", "IconComponent", "ObjectModule")
IconModule.InstancesAreSingletons = false

IconModule.EventListners = {}
IconModule.TypeAllowances = {}
IconModule.anchorableChildren = {}

IconModule.defaultAllowanceForTypes = true

function IconModule:OnNewInstance_1_IconModule(icon)
	icon.Modules[self.className] = self
	self.icon = icon
end
function IconModule:OnFirstInstance_IconModule()
	local className = self.className
	
	for event, func in pairs(self.EventListners) do
		if type(func) == "function" then

			TMW:RegisterCallback(event, function(event, icon, ...)
				local Module = icon.Modules[className]
				
				if Module and Module.IsEnabled then
					func(Module, icon, ...)
				end
			end)
			
		end
	end
	
	for name in pairs(self.anchorableChildren) do
		local identifier = className .. name
		
		local localizedName = rawget(L, identifier)
		if not localizedName then
			TMW:Error("Localized name for %q is missing! (TMW.L[%q])", identifier, identifier)
		end
		
		self.anchorableChildren[name] = localizedName
	end
end
function IconModule:OnClassInherit_IconModule(newClass)		
	newClass:InheritTable(self, "EventListners")
	newClass:InheritTable(self, "TypeAllowances")
	newClass:InheritTable(self, "anchorableChildren")
	
	newClass.defaultAllowanceForTypes = self.defaultAllowanceForTypes
end

function IconModule:OnImplementIntoIcon(icon)
	self.IsImplemented = true
	
	local implementationData = self.implementationData
	local implementorFunc = implementationData.implementorFunc
	
	if type(implementorFunc) == "function" then
		implementorFunc(self, icon)
	end
	
	if self.IsEnabled then
		TMW.safecall(self.SetupForIcon, self, icon)
	end
end

function IconModule:OnUnimplementFromIcon(icon)
	self.IsImplemented = nil
end

--- Sets up a module for a certain icon. This method should be overridden as needed by subclasses of [[api/icon-module/api-documentation/|IconModule]]. Please be aware that you cannot assume that {{{self.icon == icon}}} will always be true - this method is also used to setup a meta icon's modules to match the behavior of another icon. See implementations of this method in the [[api/icon-module/api-documentation/|IconModule]]s provided in TellMeWhen.
-- @param icon [[[api/icon/api-documentation/|Icon]]] An icon that this module should be setup for.
-- @usage -- Example implementations of this method:
--	
--	-- From IconModule_Alpha:
--	function Alpha:SetupForIcon(icon)
--		self.FakeHidden = icon.FakeHidden
--		
--		local attributes = icon.attributes
--		
--		self:REALALPHA(icon, icon.attributes.realAlpha)
--	end
--	
--	-- From IconModule_IconContainer_Masque:
--	function IconContainer_Masque:SetupForIcon(icon)
--		if icon ~= self.icon then
--			local icnt = icon.normaltex
--			local iconnt = self.icon.normaltex
--			if icnt and iconnt then
--				iconnt:SetVertexColor(icnt:GetVertexColor())
--			end
--		end
--	end
function IconModule:SetupForIcon(icon)
	-- Default is to do nothing.
end

--- Create an event listener for TMW events that are fired with icon as their first arg (these events are always prefixed with "TMW_ICON_"). The function will only be called if the icon that the event was fired for is the icon that an instance of this [[api/icon-module/api-documentation/|IconModule]] has been implemented into, and if {{{IconModule.IsEnabled == true}}} for that instance. This method must be called on a class - you cannot set icon event handlers separately for individual instances of [[api/icon-module/api-documentation/|IconModule]] using this method.
-- @param event [string] An event. Should be prefixed with "TMW_ICON_".
-- @param func [function|false] A function that will be called in response to firings of the event for the icon that this [[api/icon-module/api-documentation/|IconModule]] is implemented into. Called with signature (Module, icon). If false, the event handler will be removed from the module. 
-- @usage
-- -- Example usage from IconModule_PowerBar_Overlay:
--	PowerBar_Overlay:SetIconEventListner("TMW_ICON_SETUP_POST", function(Module, icon)
--		if TMW.Locked then
--			Module:UpdateTable_Register()
--			
--			Module.bar:SetAlpha(.9)
--		else
--			Module:UpdateTable_Unregister()
--			
--			Module.bar:SetValue(Module.Max)
--			Module.bar:SetAlpha(.6)
--		end
--	end)
function IconModule:SetIconEventListner(event, func)
	self:AssertSelfIsClass()
	
	assert(event)
	
	self.EventListners[event] = func
end


--- Creates an event handler that listens to changes in data from the specified [[api/icon-data-processor/api-documentation/|IconDataProcessor]]. This method is essentially a wrapper for {{{TMW.Classes.IconModule:SetIconEventListner( TMW.Classes.IconDataProcessor.ProcessorsByName[processorName].changedEvent [,func])}}}
-- @param processorName [string] Identifier of a [[api/icon-data-processor/api-documentation/|IconDataProcessor]] as was passed as the first arg to the consturctor of [[api/icon-data-processor/api-documentation/|IconDataProcessor]].
-- @param func [function|false|nil]:
-- * A function that will be called when the data of the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] has changed for the icon that an instance of this [[api/icon-module/api-documentation/|IconModule]] is implemented into, and if {{{IconModule.IsEnabled == true}}} for that instance. 
-- * If false, the data listener for the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] will be removed from the module. 
-- * If nil, the function used will be {{{self[processorName]}}}. Signature of the function is {{{(icon, ...)}}} where the vararg represents each attribute handled by the [[api/icon-data-processor/api-documentation/|IconDataProcessor]].
-- @usage
-- -- Example usage from IconModule_Texture:
--	function IconModule_Texture:TEXTURE(icon, texture)
--		self.texture:SetTexture(texture)
--	end
--	IconModule_Texture:SetDataListener("TEXTURE")
function IconModule:SetDataListener(processorName, func)
	-- func: false to remove the data listner; nil to search for it 
	self:AssertSelfIsClass()
	
	local Processor = TMW.Classes.IconDataProcessor.ProcessorsByName[processorName]
	assert(Processor, ("Couldn't find IconDataProcessor named %q"):format(tostring(processorName)))			
	
	if func == nil then
		func = self[processorName]
	end
	
	self:SetIconEventListner(Processor.changedEvent, func)
end


--- Declares a frame or layer of a module as being skinnable with Masque. This method should be called in a module's {{{OnNewInstance}}} method. 
-- @param component [string] The identifier of the component that will be the key for [[http://www.wowace.com/addons/masque/pages/api/button-data/|Masque's ButtonData table]].
-- @param frame [table(frame)] The frame or layer object that will be the value [[http://www.wowace.com/addons/masque/pages/api/button-data/|Masque's ButtonData table]].
-- @usage -- Example usage from IconModule_CooldownSweep:
--	function TMW.Classes.IconModule_CooldownSweep:OnNewInstance(icon)
--		self.cooldown = CreateFrame("Cooldown", self:GetChildNameBase() .. "Cooldown", icon, "CooldownFrameTemplate")
--		
--		self:SetSkinnableComponent("Cooldown", self.cooldown)
--	end
function IconModule:SetSkinnableComponent(component, frame)
	self:AssertSelfIsInstance()
	
	assert(not self.icon.lmbButtonData[component])
	self.icon.lmbButtonData[component] = frame
end

--- Gets the base of the name that should be used for frames created by a module.
-- @return [string] The first part of the name of any child frame of a module. Equivalent to {{{self.icon:GetName() .. self.className}}}.
-- @usage -- Example usage from IconModule_CooldownSweep:
--	function TMW.Classes.IconModule_CooldownSweep:OnNewInstance(icon)
--		self.cooldown = CreateFrame("Cooldown", self:GetChildNameBase() .. "Cooldown", icon, "CooldownFrameTemplate")
--		
--		-- <...>
--	end
function IconModule:GetChildNameBase()
	self:AssertSelfIsInstance()
	
	return self.icon:GetName() .. self.className
end

--- Declare a frame or layer as being anchorable so that components across TMW can be user-configured to use it as an anchor (for things like animation and text strings). The localized name must be defined to TMW.L as {{{self.className .. name}}}.
-- @param name [string] The part of the name of the frame or layer that was appended to {{{IconModule:GetChildNameBase()}}}.
-- @usage -- Example usage from IconModule_CooldownSweep:
--	local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "enUS", true)
--	L["IconModule_CooldownSweepCooldown"] = "Cooldown Sweep"
-- 
--	-- <...>
-- 
--	TMW.Classes.IconModule_CooldownSweep:RegisterAnchorableFrame("Cooldown")
--	
--	function TMW.Classes.IconModule_CooldownSweep:OnNewInstance(icon)
--		self.cooldown = CreateFrame("COOLDOWN", self:GetChildNameBase() .. "Cooldown", icon, "CooldownFrameTemplate")
--		
--		-- <...>
--	end
function IconModule:RegisterAnchorableFrame(name)
	self:AssertSelfIsClass()
	TMW:ValidateType("2 (name)", "IconModule:RegisterAnchorableFrame(name)", name, "string")
	
	self.anchorableChildren[name] = true
end


--- Sets whether or not instances of this [[api/icon-module/api-documentation/|IconModule]] will be allowed to implement into an icon that implements a specified [[api/icon-type/api-documentation/|IconType]]. This method is also wrapped by the [[api/icon-type/api-documentation/|IconType]] method {{{SetModuleAllowance}}}.
-- @param typeName [string] The identifier of a [[api/icon-type/api-documentation/|IconType]] as passed to the first param of [[api/icon-type/api-documentation/|IconType]]'s constructor.
-- @param allow [boolean] Whether or not the [[api/icon-module/api-documentation/|IconModule]] should be allowed to implement into an icon that also implements the specified [[api/icon-type/api-documentation/|IconType]].
-- @usage
-- -- Prevents a custom IconModule from implementing into meta icons:
-- IconModule:SetAllowanceForType("meta", false)
function IconModule:SetAllowanceForType(typeName, allow)
	self:AssertSelfIsClass()
	
	TMW:ValidateType(2, "IconModule:SetAllowanceForType()", typeName, "string")
	
	-- allow cannot be nil
	TMW:ValidateType(3, "IconModule:SetAllowanceForType()", allow, "boolean")
	
	if self.TypeAllowances[typeName] == nil then
		self.TypeAllowances[typeName] = allow
	else
		TMW:Error("A module's type allowance cannot be set once it has already been declared by either a module or an icon type.")
	end
end

--- Sets the default allowance for implementing instances of this [[api/icon-module/api-documentation/|IconModule]]. Default value is {{{true}}}, meaning that modules will be implemented as requested unless it has been set otherwise by a call to {{{:SetAllowanceForType(typeName, false)}}}. Set to {{{false}}} to prevent instances of this [[api/icon-module/api-documentation/|IconModule]] from implementing unless they have been explicitly allowed by a call to {{{:SetAllowanceForType(typeName, true)}}}.
-- @param allow [boolean] The default type allowance for instances of this [[api/icon-module/api-documentation/|IconModule]].
-- @usage
-- -- Example of usage by PowerBar_Overlay, which should only be explicitly allowed by icons
-- -- that export something that is likely to be a spell to the SPELL IconDataProcessor.
-- TMW.Classes.IconModule_PowerBar_Overlay:SetDefaultAllowanceForTypes(false)
-- 
-- -- Icon types that wish to allow PowerBar_Overlay should call the following:
-- Type:SetModuleAllowance("IconModule_PowerBar_Overlay", true)
function IconModule:SetDefaultAllowanceForTypes(allow)
	self:AssertSelfIsClass()
	
	TMW:ValidateType(2, "IconModule:SetDefaultAllowanceForTypes()", allow, "boolean")
	
	self.defaultAllowanceForTypes = allow
end

--- Checks whether instances of this [[api/icon-module/api-documentation/|IconModule]] will be allowed to implement into icons that implements a specified [[api/icon-type/api-documentation/|IconType]].
-- @param typeName [string] The identifier of a [[api/icon-type/api-documentation/|IconType]] instance as passed to the first param of [[api/icon-type/api-documentation/|IconType]]'s constructor.
-- @return [boolean] True if instances of a [[api/icon-module/api-documentation/|IconModule]] will be allowed to implement alongside the specified [[api/icon-type/api-documentation/|IconType]] instance.
-- @usage isAllowed = IconModule_PowerBar_Overlay:IsAllowedByType("meta")
function IconModule:IsAllowedByType(typeName)
	local typeAllowance = self.TypeAllowances[typeName]
	if typeAllowance ~= nil then
		return typeAllowance
	else
		return self.defaultAllowanceForTypes
	end
end

-- There is no reason to document this, since it is effectively the same as the one inherited from ObjectModule.
-- Passing true to this is reserved exclusively for the code that handles meta icon inheritance.
IconModule.Enable_base = IconModule.Enable
function IconModule:Enable(ignoreTypeAllowances)
	self:AssertSelfIsInstance()
	
	if ignoreTypeAllowances or self:IsAllowedByType(self.icon.Type) then
		self:Enable_base()
	end
end

-- Not going to document this. See the base declaration of this method IconComponent.lua for an explanation.
function IconModule:ShouldShowConfigPanels(icon)
	assert(icon == self.icon)
	
	return self:IsAllowedByType(icon.Type)
end
