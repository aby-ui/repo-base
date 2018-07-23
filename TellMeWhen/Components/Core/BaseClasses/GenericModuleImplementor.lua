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

local pairs, error
	= pairs, error


--- [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]] is a base class of any objects that implement any instances of [[api/base-classes/object-module/|ObjectModule]]
-- 
-- [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]] inherits explicitly from [[api/base-classes/generic-component-implementor/|GenericComponentImplementor]], and implicitly from the classes that it inherits. 
-- 
-- GenericModuleImplementor provides a common base for these objects, and it provides the {{{self.Modules}}} table to its instances. It is an abstract class, and should not be directly instantiated.
-- 
-- @class file
-- @name GenericModuleImplementor.lua


-- @class table
-- @name TMW.Classes.GenericModuleImplementor
-- @field Modules [table] An array of all the [[api/base-classes/object-module/|ObjectModule]] that have been implemented into this [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]]. No modifications to this table should be made outside of methods that belong to classes that explicitly inherit from [[api/base-classes/object-module/|ObjectModule]].
local GenericModuleImplementor = TMW:NewClass("GenericModuleImplementor", "GenericComponentImplementor")

-- [INHERITED CTOR]
function GenericModuleImplementor:OnNewInstance_GenericModuleImplementor()
	self.Modules = {}
end

--- Searches for an instance of a specified [[api/base-classes/object-module/|ObjectModule]], or any instances that inherit from the specified [[api/base-classes/object-module/|ObjectModule]], that has been implemented into this [[api/base-classes/generic-module-implementor/|GenericModuleImplementor]].
-- @param moduleName [string] Class name of a [[api/base-classes/object-module/|ObjectModule]] to search for. An error is thrown if {{{TMW.Classes[moduleName] == nil}}}.
-- @param allowDisabled [boolean|nil] True if the method should return an [[api/base-classes/object-module/|ObjectModule]] instance that was found even if {{{ObjectModule.IsEnabled == false}}} for the instance.
-- @param allowUnimplemented [boolean|nil] True if the method should return an [[api/base-classes/object-module/|ObjectModule]] instance that was found even if the module is not implemented.
-- @return [[[api/base-classes/object-module/|ObjectModule]]|nil] A matching [[api/base-classes/object-module/|ObjectModule]], or nil if none was found.
function GenericModuleImplementor:GetModuleOrModuleChild(moduleName, allowDisabled, allowUnimplemented)
	local Modules = self.Modules
	
	local Module = Modules[moduleName]
	if Module and (allowUnimplemented or self.ComponentsLookup[Module]) and (allowDisabled or Module.IsEnabled) then
		return Module
	else
		local ModuleClassToSearchFor = TMW.Classes[moduleName]
		
		if not ModuleClassToSearchFor then
			error(("Class %q does not exist! (ModuleImplementor:GetModuleOrModuleChild(moduleName))"):format(moduleName), 2)
		end
		
		for _, Module in pairs(Modules) do
			if Module.class.inherits[ModuleClassToSearchFor] and (allowUnimplemented or self.ComponentsLookup[Module]) and (allowDisabled or Module.IsEnabled) then
				return Module
			end
		end
	end
end

-- [INTERNAL] disables all modules implemented by this GenericModuleImplementor.
function GenericModuleImplementor:DisableAllModules()
	for moduleName, Module in pairs(self.Modules) do
		Module:Disable()
	end
end
