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

local pairs, error, strsplit, ipairs
	= pairs, error, strsplit, ipairs
	

--- [[api/icon-data-processor/api-documentation/|IconDataProcessor]] is the class of all IconDataProcessors. IconDataProcessors handle the input to [[api/icon/api-documentation/|Icon]]{{{:SetInfo()}}}, process the data (performing validation and other manipulation), and then expose it for use by instances of [[api/icon-module/api-documentation/|IconModule]], [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]]s, and other [[api/icon-data-processor/api-documentation/|IconDataProcessor]]s.
-- 
-- [[api/icon-data-processor/api-documentation/|IconDataProcessor]] inherits from [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]], and implicitly from the classes that it inherits. 
-- 
-- @class file
-- @name IconDataProcessor.lua




local IconDataProcessor = TMW:NewClass("IconDataProcessor", "IconDataProcessorComponent")
IconDataProcessor.UsedTokens = {}
IconDataProcessor.NumAttributes = 0

IconDataProcessor.ProcessorsByName = {}


--- Constructor - Creates a new [[api/icon-data-processor/api-documentation/|IconDataProcessor]].
-- @name IconDataProcessor:New
-- @param name [string] A name for this [[api/icon-data-processor/api-documentation/|IconDataProcessor]]. Should be brief, and should be all capital letters.
-- @param attributes [string] A comma-delimited string of attributes that will be passed as part of the first param to [[api/icon/api-documentation/|Icon]]{{{:SetInfo(attributesString, ...)}}}. If multiple attributes are given, they must always be passed to :SetInfo together, and always in the same order. Each attribute token may only be used in one IconDataProcessor across TellMeWhen.
-- @return [[[api/icon-data-processor/api-documentation/|IconDataProcessor]]] An instance of a new IconDataProcessor.
-- @usage
-- local Processor = TMW.Classes.IconDataProcessor:New("STATE", "state")
-- 
-- local Processor = TMW.Classes.IconDataProcessor:New("DURATION", "start, duration")
function IconDataProcessor:OnNewInstance(name, attributes)
	TMW:ValidateType("2 (name)", "IconDataProcessor:New(name, attributes)", name, "string")
	TMW:ValidateType("3 (attributes)", "IconDataProcessor:New(name, attributes)", attributes, "string")
	
	self.hooks = {}
	
	for i, instance in pairs(self.class.instances) do
		if instance.name == name then
			error(("Processor %q already exists!"):format(self.name))
		elseif instance.attributesString == attributes then
			error(("Processor with attributes %q already exists!"):format(self.name))
		end
	end
	
	self.name = name
	self.attributesString = attributes
	self.attributesStringNoSpaces = attributes:gsub(" ", "")
	
	for _, attribute in TMW:Vararg(strsplit(",", self.attributesStringNoSpaces)) do
		if self.UsedTokens[attribute] then
			error(("Attribute token %q is already in use by %q!"):format(attribute, self.UsedTokens[attribute].name))
		else
			self.UsedTokens[attribute] = self
			self.NumAttributes = self.NumAttributes + 1
		end
	end
	
	self.ProcessorsByName[self.name] = self
	self:DeclareUpValue(name, self)
	self:DeclareUpValue(attributes) -- do this to prevent accidental leaked global accessing
	
	self.changedEvent = "TMW_ICON_DATA_CHANGED_" .. name
	
	TMW.Classes.Icon:ClearSetInfoFunctionCache()
end

--- Asserts if another [[api/icon-data-processor/api-documentation/|IconDataProcessor]] exists. Throws an error if it does not exist.
-- @param name [string] The name of a [[api/icon-data-processor/api-documentation/|IconDataProcessor]], as passed as the first param to its constructor, that is is a dependency of another.
-- @usage Processor:AssertDependency("UNIT")
function IconDataProcessor:AssertDependency(name)
	if not self.ProcessorsByName[name] then
		error(("Dependency %q of processor %q was not found!"):format(name, self.name), 2)
	end
end

-- [INTERNAL]
function IconDataProcessor:CompileFunctionHooks(t, orderRequested)
	for _, ProcessorHook in ipairs(self.hooks) do
		for func, order in pairs(ProcessorHook.funcs) do
			if order == orderRequested then
				t[#t+1] = "\n"
				TMW.safecall(func, self, t)
				t[#t+1] = "\n"
			end
		end
	end
end

--- Wrapper method around TMW.IconStateArbitrator:AddHandler().
function IconDataProcessor:RegisterAsStateArbitrator(...)
	TMW.IconStateArbitrator:AddHandler(self, ...)
end

--- Compiles the segment of the [[api/icon/api-documentation/|Icon]]{{{:SetInfo()}}} method that will be used to process the data for this [[api/icon-data-processor/api-documentation/|IconDataProcessor]]. This method should be overridden for any IconDataProcessors that process more than one attribute, or any IconDataProcessors that do more than simply record and notify changes to a single attribute. If changes are many to any attributes, the processor's {{{.changedEvent}}} should be fired (see usage below), and doFireIconUpdated should be set true. IconDataProcessors are also commonly used to trigger icon events (seen in the second usage example below).
-- 
-- Local variables are provided for:
-- * Each incoming attribute that is being processed,
-- * {{{icon = self}}}
-- * {{{attributes = icon.attributes}}}
-- * {{{EventHandlersSet = icon.EventHandlersSet}}}
-- * A reference, by name, to every IconDataProcessor (E.g. {{{DURATION = TMW.Classes.IconDataProcessor.ProcessorsByName.DURATION}}})
-- * Any other local variables that have been set through [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]]{{{:DeclareUpValue()}}}.
-- @param t [table] An array of strings that will be concatenated together to form the body of the :SetInfo() method.
-- @usage
-- 
-- -- Example usage in the SPELL IconDataProcessor:
--	function Processor:CompileFunctionSegment(t)
--		t[#t+1] = [[
--		if attributes.spell ~= spell then
--			attributes.spell = spell
--			
--			if EventHandlersSet.OnSpell then
--				icon:QueueEvent("OnSpell")
--			end
--	
--			TMW:Fire(SPELL.changedEvent, icon, spell)
--			doFireIconUpdated = true
--		end
--		]]
--	end
function IconDataProcessor:CompileFunctionSegment(t)
	self:AssertSelfIsInstance()
	
	if self.NumAttributes ~= 1 then
		error(("IconDataProcessor %q MUST declare its own CompileFunctionSegment method if it has more than one attribute"):format(self.name))
	end
	
	local attribute = self.attributesStringNoSpaces
	
	t[#t+1] = [[if attributes.]]
	t[#t+1] = attribute
	t[#t+1] = [[ ~= ]]
	t[#t+1] = attribute
	t[#t+1] = [[ then
		attributes.]]
		t[#t+1] = attribute
		t[#t+1] = [[ = ]]
		t[#t+1] = attribute
		t[#t+1] = [[

		TMW:Fire("]]
		t[#t+1] = self.changedEvent
		t[#t+1] = [[", icon, ]]
		t[#t+1] = attribute
		t[#t+1] = [[)
		doFireIconUpdated = true
	end
	--]]
end

-- Default upvalue declarations.
IconDataProcessor:DeclareUpValue("TMW", TMW)
IconDataProcessor:DeclareUpValue("print", print)
IconDataProcessor:DeclareUpValue("ProcessorsByName", IconDataProcessor.ProcessorsByName)
IconDataProcessor:DeclareUpValue("type", type)
