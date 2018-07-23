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

--- [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]] is a base class of [[api/icon-data-processor/api-documentation/|IconDataProcessor]] and [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]].
-- 
-- [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]] inherits from [[api/base-classes/icon-component/|IconComponent]], and implicitly from the classes that it inherits. 
-- 
-- [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]] provides a common base for these objects, and some basic functionality shared between the two. 
-- 
-- @class file
-- @name IconDataProcessorComponent.lua


local IconDataProcessorComponent = TMW:NewClass("IconDataProcessorComponent", "IconComponent")
IconDataProcessorComponent.SIUVs = {}

--- Declare upvalues that will be available to the [[api/icon/api-documentation/|Icon]]{{{:SetInfo()}}} method (any therefore avaiable to any [[api/icon-data-processor/api-documentation/|IconDataProcessor]] and any [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]]).
-- @param variables [string] A string that will be on the left side of an assignment operator.
-- @param ... [...] Any number of params (can be zero, but not recommended outside of special circumstances) that will get assigned to {{{variables}}},
-- @usage
-- -- The following calls:
-- IconDataProcessorComponent:DeclareUpValue("varZ")
-- IconDataProcessorComponent:DeclareUpValue("varA, varB", 42)
-- IconDataProcessorComponent:DeclareUpValue("var1, var2, var3, var4", 7, "string", function() DoSomething() end, {"foo", "bar"})
-- 
-- -- Will be translated to the following that will be available to the SetInfo method:
-- local varZ
-- local varA, varB = 42
-- local var1, var2, var3, var4 = 7, "string", <funcref to func passed in>, <tableref to table passed in>
function IconDataProcessorComponent:DeclareUpValue(variables, ...)
	TMW:ValidateType("2 (variables)", "IconDataProcessorComponent:DeclareUpValue(variables, ...)", variables, "string")
	
	self.SIUVs[#self.SIUVs+1] = {
		variables = variables,
		...,
	}
	
	TMW.Classes.Icon:ClearSetInfoFunctionCache()
end
