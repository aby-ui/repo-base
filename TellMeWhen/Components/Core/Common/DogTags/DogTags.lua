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

local DogTag = LibStub("LibDogTag-3.0")

local DOGTAG = TMW:NewModule("DogTags")
TMW.DOGTAG = DOGTAG

TMW.DOGTAG.nsList = "Base;TMW;Unit;Stats"

local abs = math.abs


---------------------------------
-- DogTag Helpers & Global Tags
---------------------------------

local DogTagEventHandler = function(event, icon)
	DogTag:FireEvent(event, icon:GetGUID())
end

function TMW:CreateDogTagEventString(...)
	-- We return a function here so that we aren't performing
	-- TMW:RegisterCallback(Processor.changedEvent, DogTagEventHandler)
	-- unless the DogTag ever gets actually used by an icon.
	-- This is a non-trivial performance boost in high-icon-count setups.
	local processors = { ... }
	return function() 
		local eventString = "TMW_GLOBAL_UPDATE_POST"

		for i, dataProcessorName in pairs(processors) do
			local Processor = TMW.Classes.IconDataProcessor.ProcessorsByName[dataProcessorName]
			TMW:RegisterCallback(Processor.changedEvent, DogTagEventHandler)
			
			--if i > 1 then
				eventString = eventString .. ";"
			--end

			eventString = eventString .. Processor.changedEvent .. "#$icon"
		end
		return eventString
	end
end

TMW:RegisterCallback("TMW_GLOBAL_UPDATE_POST", DogTag.FireEvent, DogTag)

DogTag:AddTag("TMW", "TMWFormatDuration", {
	code = TMW:MakeSingleArgFunctionCached(function(seconds)
		return TMW:FormatSeconds(seconds, seconds == 0 or abs(seconds) > 10, true)
	end),
	arg = {
		'seconds', 'number', '@req',
	},
	ret = "string",
	static = true,
	doc = L["DT_DOC_TMWFormatDuration"],
	example = '[0.54:TMWFormatDuration] => "0.5"; [20:TMWFormatDuration] => "20"; [80:TMWFormatDuration] => "1:20"; [10000:TMWFormatDuration] => "2:46:40"',
	category = L["TEXTMANIP"]
})

DogTag:AddTag("TMW", "gsub", {
	code = gsub,
	arg = {
		'value', 'string', '@req',
		'pattern', 'string', '@req',
		'replacement', 'string', '@req',
		'num', 'number;nil', 'nil',
	},
	ret = "string;nil",
	static = true,
	doc = L["DT_DOC_gsub"],
	example = '["Cybeloras - Aerie Peak":gsub(" ?%-.*", "")] => "Cybeloras"',
	category = L["TEXTMANIP"],
})

DogTag:AddTag("TMW", "strfind", {
	code = strfind,
	arg = {
		'value', 'string', '@req',
		'pattern', 'string', '@req',
		'init', 'number', 0,
		'plain', 'boolean', false,
	},
	ret = "number;nil",
	static = true,
	doc = L["DT_DOC_strfind"],
	example = '["Cybeloras - Aerie Peak":strfind("%-")] => "11"',
	category = L["TEXTMANIP"],
})





-- The purpose of this is to remove the code from a function that prevents it from updating its text
-- if the unit kwarg doesn't exist. This happens all the time in TMW, but it doesn't mean we should
-- send the rest of the text to the abyss. I tried making this change to LDT-Unit-3.0, a long time
-- ago, but got yelled at because apparently it broke something for other addons. This solution
-- can only break things for TMW, which is perfect.
DogTag:AddCompilationStep("TMW", "finish", function(t, ast, kwargTypes, extraKwargs)
	if kwargTypes["unit"] then

		for i = 1, #t do
			if t[i] == [=[if ]=]

			-- extraKwargs gets cleared out (seriously? why the fuck would you do that?) before finish steps,
			-- so we can't check for this. It doesn't matter, though, because the next line is unique.
			--and t[i+1] == extraKwargs["unit"][1] 

			and t[i+2] == [=[ ~= "player" and not UnitExists(]=]
			then
				local safety = 0
				while tremove(t, i) ~= [=[end;]=] do
					-- continue deleting
					safety = safety + 1
					if safety > 1000 then
						error("loop went on way too long")
						return
					end
				end
			end
		end

		-- Remove the IsLegitimateUnit check that makes sure the return from the Unit tag is a valid unit.
		for i = 1, #t do
			if t[i] == [=[if ]=]

			--and t[i+1] = compiledKwargs["unit"][1]

			and t[i+2] == [=[ and not DogTag.IsLegitimateUnit[]=]
			then
				local safety = 0
				while tremove(t, i) ~= [=[end;]=] do
					-- continue deleting
					safety = safety + 1
					if safety > 1000 then
						error("loop went on way too long")
						return
					end
				end
			end
		end


		-- Remove the UnitExists check that wraps around the TMWName tag.
		for i = 1, #t do
			if t[i] == "TMWName"
			and t[i-6] == [=[ and UnitExists(]=]
			then
				tremove(t, i-8) -- [=[if ]=]
				tremove(t, i-8) -- compiledKwargs["unit"][1]
				tremove(t, i-8) -- [=[ and UnitExists(]=]
				tremove(t, i-8) -- compiledKwargs["unit"][1]
				tremove(t, i-8) -- [=[) then]=]
				tremove(t, i-8) -- "\n"

				local j = i-6
				while t[j] ~= [=[end;]=] do
					j = j+1
				end
				tremove(t, j)
			end
		end

	end
end)
