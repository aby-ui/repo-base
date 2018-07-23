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

local assert
	= assert

--- [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]] is the class of all IconDataProcessorHooks. A IconDataProcessorHook hooks into a [[api/icon-data-processor/api-documentation/|IconDataProcessor]], giving it a chance to modify icon attributes before they are given to their normal [[api/icon-data-processor/api-documentation/|IconDataProcessor]]. An IconDataProcessorHook can also get access to icon attributes quicker than any other Icon Component, allowing them to read these attributes and set other attributes based on their value (this can be seen in the second usage example of {{{:RegisterCompileFunctionSegmentHook}}})
-- 
-- [[api/icon-data-processor/api-documentation/|IconDataProcessor]] inherits from [[api/base-classes/icon-data-processor-component/|IconDataProcessorComponent]], and implicitly from the classes that it inherits. 
-- 
-- @class file
-- @name IconDataProcessorHook.lua


local IconDataProcessorHook = TMW:NewClass("IconDataProcessorHook", "IconDataProcessorComponent")


--- Constructor - Creates a new [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]].
-- @name IconDataProcessorHook:New
-- @param name [string] A name for this [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]]. Should be brief, and should be all capital letters.
-- @param processorToHook [string] The name of a [[api/icon-data-processor/api-documentation/|IconDataProcessor]] (as passed to the first param of its constructor) to hook.
-- @return [[[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]]] An instance of a new IconDataProcessorHook.
-- @usage
-- local Hook = TMW.Classes.IconDataProcessorHook:New("TEXTURE_CUSTOMTEX", "TEXTURE")
function IconDataProcessorHook:OnNewInstance(name, processorToHook)
	TMW:ValidateType(2, "IconDataProcessorHook:New()", name, "string")
	TMW:ValidateType(3, "IconDataProcessorHook:New()", processorToHook, "string")
	
	local Processor = TMW.Classes.IconDataProcessor.ProcessorsByName[processorToHook]
	assert(Processor, "IconDataProcessorHook:New() unable to find IconDataProcessor named " .. processorToHook)
	
	self.name = name
	self.processorToHook = processorToHook
	self.Processor = Processor
	self.Processor.hooks[#self.Processor.hooks+1] = self
	self.funcs = {}
	self.processorRequirements = {}
	
	self:RegisterProcessorRequirement(processorToHook)
end

--- Registers a CompileFunctionSegment function (similar behavior to [[api/icon-data-processor/api-documentation/|IconDataProcessor]]{{{:CompileFunctionSegment()}}} that will be called when the segment of [[api/icon/api-documentation/|Icon]]{{{:SetInfo()}}} for the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] that this [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]] is hooking is being compiled.
-- @param order [string] Must be "pre" or "post". "pre" will cause this hook to be compiled before the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] that it is hooking gets compiled. "post" will cause this hook to be compiled afterwords.
-- @param func [function] A function that will be called to compile part of [[api/icon/api-documentation/|Icon]]{{{:SetInfo()}}}. Called with signature {{{(Processor, t)}}}. {{{Processor}}} is the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] instance hooked by this IconDataProcessorHook. {{{t}}} is the string table that will be concatenated to form the whole :SetInfo() method.
-- @usage
--	-- Example usage from TEXTURE_CUSTOMTEX:
--	Hook:RegisterCompileFunctionSegmentHook("pre", function(Processor, t)
--		t[#t+1] = [[
--		texture = icon.CustomTex_OverrideTex or texture -- if a texture override is specified, then use it instead
--		]]
--	end)
-- 
--	-- Example usage from ALPHA_DURATIONREQ:
--	Hook:RegisterCompileFunctionSegmentHook("post", function(Processor, t)
--		t[#t+1] = [[
--	
--		local d = duration - (TMW.time - start)
--		
--		local alpha_durationFailed = nil
--		if
--			d > 0 and ((icon.DurationMinEnabled and icon.DurationMin > d) or (icon.DurationMaxEnabled and d > icon.DurationMax))
--		then
--			alpha_durationFailed = icon.DurationAlpha
--		end
--		
--		if attributes.alpha_durationFailed ~= alpha_durationFailed then
--			icon:SetInfo_INTERNAL("alpha_durationFailed", alpha_durationFailed)
--			doFireIconUpdated = true
--		end
--		]]
--	end)
function IconDataProcessorHook:RegisterCompileFunctionSegmentHook(order, func)
	self:AssertSelfIsInstance()
	-- These hooks are not much of hooks at all,
	-- since they go directly in the body of the function
	-- and can modify input variables before they are processed.
	
	assert(order == "pre" or order == "post", "RegisterCompileFunctionSegmentHook: arg2 must be either 'pre' or 'post'")
	
	self.funcs[func] = order
	
	TMW.Classes.Icon:ClearSetInfoFunctionCache()
end

--- Require that a [[api/icon-data-processor/api-documentation/|IconDataProcessor]] must be implemented into a [[api/icon/api-documentation/|Icon]] before this [[api/icon-data-processor-hook/api-documentation/|IconDataProcessorHook]] will be allowed to implement into the icon. This is called by default for the [[api/icon-data-processor/api-documentation/|IconDataProcessor]] that is being hooked, but you may need to require other [[api/icon-data-processor/api-documentation/|IconDataProcessor]]s as well for your specific needs.
-- @param processorName [string] The name of a [[api/icon-data-processor/api-documentation/|IconDataProcessor]] (as passed to the first param of its constructor) that is required.
-- @usage Hook:RegisterProcessorRequirement("DURATION")
function IconDataProcessorHook:RegisterProcessorRequirement(processorName)
	self:AssertSelfIsInstance()
	self.processorRequirements[processorName] = true
end


