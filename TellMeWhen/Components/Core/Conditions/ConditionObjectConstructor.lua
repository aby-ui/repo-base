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

local CNDT = TMW.CNDT


--- A [[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]] aids in the creation of a [[api/conditions/api-documentation/condition-object/|ConditionObject]]
-- 
-- It provides methods for modifying the settings of conditions before they are created without actually changing a user's settings.
-- 
-- @class file
-- @name ConditionObjectConstructor.lua


local ConditionObjectConstructor = TMW:NewClass("ConditionObjectConstructor")

ConditionObjectConstructor.status = "ready"

--- Loads the parent and the Condition settings that will be used to construct a [[api/conditions/api-documentation/condition-object/|ConditionObject]].
-- @param parent [table] The parent of the [[api/conditions/api-documentation/condition-object/|ConditionObject]] that will be created.
-- @param Conditions [table] The condition settings that will be used to create a [[api/conditions/api-documentation/condition-object/|ConditionObject]].
function ConditionObjectConstructor:LoadParentAndConditions(parent, Conditions)	
	assert(self.status == "ready", "Cannot :LoadParentAndConditions() to a ConditionObjectConstructor whose status is not 'ready'!")
	
	self.parent = parent
	self.Conditions = Conditions
	self.ConditionsToConstructWith = Conditions
	
	self.status = "loaded"
end

--- Returns a copy of the settings table that was loaded through :LoadConditions() that can be modified without changing user settings.
-- This copy of settings will be used to :Construct() the [[api/conditions/api-documentation/condition-object/|ConditionObject]] instead of the originally loaded conditions.
-- @return [table] A copy of the originally loaded condition settings that can be safely modified.
function ConditionObjectConstructor:GetPostUserModifiableConditions()

	if self.ModifiableConditions then
		return self.ModifiableConditions
	end

	self.ModifiableConditions = TMW:CopyWithMetatable(self.Conditions)
	self.ConditionsToConstructWith = self.ModifiableConditions
	
	return self.ModifiableConditions
end

--- Calls :GetPostUserModifiableConditions() and then appends a new condition to the end that can be configured as desired.
-- @return [table] The settings of a new single condition.
function ConditionObjectConstructor:Modify_AppendNew()
	local ModifiableConditions = self:GetPostUserModifiableConditions()
	local mod = ModifiableConditions -- Alias for brevity
	
	mod.n = mod.n + 1
	
	return mod[mod.n]
end

--- Calls :GetPostUserModifiableConditions(), wraps the existing conditions in parenthesis if needed,
-- and then appends a new condition to the start that can be configured as desired.
-- @return [table] The settings of a new single condition.
function ConditionObjectConstructor:Modify_WrapExistingAndPrependNew()	
	local ModifiableConditions = self:GetPostUserModifiableConditions()
	local mod = ModifiableConditions -- Alias for brevity
	
	mod.n = mod.n + 1
	local new = mod[mod.n]
	mod[mod.n] = nil
	tinsert(mod, 1, new)

	if mod.n > 2 then
		mod[2].PrtsBefore = mod[2].PrtsBefore + 1
		mod[mod.n].PrtsAfter = mod[mod.n].PrtsAfter + 1
	end
	
	return new
end

--- Calls :GetPostUserModifiableConditions(), wraps the existing conditions in parenthesis if needed,
-- and then appends a new condition to the end that can be configured as desired.
-- @return [table] The settings of a new single condition.
function ConditionObjectConstructor:Modify_WrapExistingAndAppendNew()	
	local ModifiableConditions = self:GetPostUserModifiableConditions()
	local mod = ModifiableConditions -- Alias for brevity
	
	mod.n = mod.n + 1
	if mod.n > 2 then
		mod[1].PrtsBefore = mod[1].PrtsBefore + 1
		mod[mod.n-1].PrtsAfter = mod[mod.n-1].PrtsAfter + 1
	end
	
	return mod[mod.n]
end

--- Constructs  a [[api/conditions/api-documentation/condition-object/|ConditionObject]] from the conditions that have been loaded into this ConditionObjectConstructor.
-- If :GetPostUserModifiableConditions() was called, that copy of condition settings will be used instead.
-- @return [[[api/conditions/api-documentation/condition-object/|ConditionObject]]] A ConditionObject based on the ConditionObjectConstructor's settings.
function ConditionObjectConstructor:Construct()	
	local ConditionObject = CNDT:GetConditionObject(self.parent, self.ConditionsToConstructWith)
	
	self:Terminate()
	
	return ConditionObject
end

--- Terminates the ConditionObjectConstructor and prepares it for reuse.
-- This is automatically called after performing :Construct().
function ConditionObjectConstructor:Terminate()
	
	self.parent = nil
	self.Conditions = nil
	self.ConditionsToConstructWith = nil
	self.ModifiableConditions = nil
	
	self.status = "ready"
end

