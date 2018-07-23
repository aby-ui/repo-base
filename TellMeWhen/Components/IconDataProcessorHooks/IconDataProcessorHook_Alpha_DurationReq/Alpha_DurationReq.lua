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


TMW.CONST.STATE.DEFAULT_DURATIONFAILED = 100
local STATE = TMW.CONST.STATE.DEFAULT_DURATIONFAILED

local Hook = TMW.Classes.IconDataProcessorHook:New("STATE_DURATIONREQ", "DURATION")

Hook:RegisterConfigPanel_XMLTemplate(222, "TellMeWhen_DurationRequirements")

Hook:RegisterIconDefaults{
	DurationMin				= 0,
	DurationMax				= 0,
	DurationMinEnabled		= false,
	DurationMaxEnabled		= false,
}

TMW:RegisterUpgrade(80013, {
	icon = function(self, ics)
		ics.States[STATE].Alpha = ics.DurationAlpha or 0
		ics.DurationAlpha = nil
	end,
})
TMW:RegisterUpgrade(60010, {
	icon = function(self, ics)
		ics.DurationAlpha = ics.ConditionAlpha

		ics.DurationMin = tonumber(ics.DurationMin) or 0
		ics.DurationMax = tonumber(ics.DurationMax) or 0
	end,
})


-- Create an IconDataProcessor that will store the result of the duration test
local Processor = TMW.Classes.IconDataProcessor:New("STATE_DURATIONFAILED", "state_durationFailed")
Processor.dontInherit = true
Processor:RegisterAsStateArbitrator(20, Hook, false, function(icon)
	local ics = icon:GetSettings()
	if not ics.DurationMinEnabled and not ics.DurationMaxEnabled then
		return nil
	end

	local text = ""
	if ics.DurationMinEnabled then
		text = L["DURATION"] .. " < " .. TMW:FormatSeconds(ics.DurationMin)
	end
	if ics.DurationMaxEnabled then
		if ics.DurationMinEnabled then
			text = text .. " " .. L["CONDITIONPANEL_OR"]:lower() .. " "
		end
		text = text .. L["DURATION"] .. " > " .. TMW:FormatSeconds(ics.DurationMax)
	end

	return {
		[STATE] = { text = text, tooltipText = L["DURATIONALPHA_DESC"]},
	}
end)


Hook:DeclareUpValue("STATE_DEFAULT_DURATIONFAILED", STATE)
Hook:RegisterCompileFunctionSegmentHook("post", function(Processor, t)
	-- GLOBALS: start, duration
	t[#t+1] = [[

	local d = duration - (TMW.time - start)
	
	local state_durationFailed = nil
	if
		d > 0 and ((icon.DurationMinEnabled and icon.DurationMin > d) or (icon.DurationMaxEnabled and d > icon.DurationMax))
	then
		state_durationFailed = icon.States[STATE_DEFAULT_DURATIONFAILED]
	end
	
	if attributes.state_durationFailed ~= state_durationFailed then
		icon:SetInfo_INTERNAL("state_durationFailed", state_durationFailed)
		doFireIconUpdated = true
	end
	--]]
end)



local DURATION = Processor.ProcessorsByName.DURATION

function Hook:OnImplementIntoIcon(icon)
	icon:SetInfo("state_durationFailed", nil)

	if icon.DurationMaxEnabled then
		DURATION:RegisterDurationTrigger(icon, icon.DurationMax)
	end
	
	if icon.DurationMinEnabled then
		DURATION:RegisterDurationTrigger(icon, icon.DurationMin)
	end
end

function Hook:OnUnimplementFromIcon(icon)
	icon:SetInfo("state_durationFailed", nil)
end

