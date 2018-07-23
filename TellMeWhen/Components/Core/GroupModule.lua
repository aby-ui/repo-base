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

local type
	= type

--- [[api/group-module/api-documentation/|GroupModule]] is a base class of any modules that will be implemented into a [[api/group/api-documentation/|Group]]. A [[api/group-module/api-documentation/|GroupModule]] provides frames, script handling, and other functionality to classes that inherit from it.
-- 
-- [[api/group-module/api-documentation/|GroupModule]] inherits from [[api/base-classes/group-component/|GroupComponent]] and [[api/base-classes/object-module/|ObjectModule]].
-- 
-- [[api/group-module/api-documentation/|GroupModule]] provides a common base for these objects. **It does not provide any methods beyond those inherited from its subclasses**. It is an abstract class, and should not be directly instantiated. All classes that inherit from [[api/group-module/api-documentation/|GroupModule]] should not be instantiated outside of the internal code used by a [[api/icon-views/api-documentation/|IconView]]. To create a new module, create a new class and inherit [[api/group-module/api-documentation/|GroupModule]] or another class that directly or indirectly inherits from [[api/group-module/api-documentation/|GroupModule]]. 
-- 
-- @class file
-- @name GroupModule.lua


local GroupModule = TMW:NewClass("GroupModule", "GroupComponent", "ObjectModule")

GroupModule.DefaultPanelColumnIndex = 2


function GroupModule:OnNewInstance_1_GroupModule(group)
	group.Modules[self.className] = self
	self.group = group
end

function GroupModule:OnImplementIntoGroup(group)
	local implementationData = self.implementationData
	local implementorFunc = implementationData.implementorFunc
	
	if type(implementorFunc) == "function" then
		implementorFunc(self, group)
	end
end
