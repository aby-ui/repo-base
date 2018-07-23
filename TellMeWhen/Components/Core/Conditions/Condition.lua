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
local get = TMW.get

local CNDT = TMW.CNDT


--- [[api/conditions/api-documentation/condition/|Condition]] provides the data that describes the configuration and evaluation of a condition. It is sometimes refered to as "condition data", which is not to be confused with "condition settings".
-- 
-- It should not be directly instantiated - use ConditionCategory:RegisterCondition() to create a condition.
-- 
-- @class file
-- @name Condition.lua


local Condition = TMW:NewClass("Condition")

function Condition:OnNewInstance(category, order, identifier)

	TMW:ValidateType("2 (category)", "Condition:New()", category, "ConditionCategory")
	TMW:ValidateType("3 (order)", "Condition:New()", order, "number")
	TMW:ValidateType("4 (identifier)", "Condition:New()", identifier, "string")

	TMW:ValidateType("funcstr", "conditionData", self.funcstr, "string;function")
	
	if CNDT.ConditionsByType[identifier] then
		error(("Condition %q already exists."):format(identifier), 2)
	end

	self.category = category
	self.identifier = identifier
	self.order = order


	if self.texttable and not self.formatter then
		self.formatter = TMW.C.Formatter:New(self.texttable)
		self.texttable = nil
	end
	
	if self.bool then
		self.min = 0
		self.max = 1
		self.formatter = self.formatter or TMW.C.Formatter.BOOL
		self.nooperator = true
		self.levelChecks = true
	end

	if not self.formatter then
		self.formatter = TMW.C.Formatter.COMMANUMBER
	end

	if self.old then
		self.text = L["CONDITIONPANEL_OLD"] .. " " .. self.text
		if self.tooltip then
			self.tooltip = self.tooltip .. "\r\n\r\n" .. L["CONDITIONPANEL_OLD_DESC"]
		else
			self.tooltip = L["CONDITIONPANEL_OLD_DESC"]
		end
		self.hidden = true
	end

	if self.bitFlags then
		self.nooperator = true
		self.noslide = true
	end

	if not self.noslide and not self.range and not self.max then
		error("max must be specified if range is not for condition " .. identifier)
	end	

	CNDT.ConditionsByType[identifier] = self
end

function Condition:GetCondition(identifier)
	return CNDT.ConditionsByType[identifier]
end

function Condition:ShouldList()
	return not self:ShouldHide() and not self:IsDeprecated()
end

function Condition:ShouldHide()
	if CNDT.CurrentConditionSet.ConditionTypeFilter then
		if not CNDT.CurrentConditionSet:ConditionTypeFilter(self) then
			return true
		end
	end

	return get(self.hidden, self)			
end

function Condition:IsDeprecated()
	return self.funcstr == "DEPRECATED"
end

function Condition:UsesTabularBitflags() 
	if not self.bitFlags then return false end
	for index, _ in pairs(self.bitFlags) do
		if type(index) ~= "number" or index >= 32 or index < 1 then
			return true
		end
	end
end

function Condition:PrepareEnv()

	-- Add in anything that the condition wants to include in Env
	if self.Env then
		for k, v in pairs(self.Env) do
			local existingValue = rawget(CNDT.Env, k)
			if existingValue ~= nil and existingValue ~= v then
				TMW:Error("Condition " .. (self.identifier or "??") .. " tried to write values to Env different than those that were already in it.")
			else
				CNDT.Env[k] = v
			end
		end
		
		-- We don't need this after it gets merged, so nil it.
		self.Env = nil
	end
end
