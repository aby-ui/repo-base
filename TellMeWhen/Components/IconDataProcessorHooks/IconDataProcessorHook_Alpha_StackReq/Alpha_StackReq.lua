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


TMW.CONST.STATE.DEFAULT_STACKSFAILED = 101
local STATE = TMW.CONST.STATE.DEFAULT_STACKSFAILED

local floor = floor

local Hook = TMW.Classes.IconDataProcessorHook:New("STATE_STACKREQ", "STACK")

Hook:RegisterConfigPanel_XMLTemplate(225, "TellMeWhen_StackRequirements")

Hook:RegisterIconDefaults{
	StackMin				= 0,
	StackMax				= 0,
	StackMinEnabled			= false,
	StackMaxEnabled			= false,
}

TMW:RegisterUpgrade(80013, {
	icon = function(self, ics)
		ics.States[STATE].Alpha = ics.StackAlpha or 0
		ics.StackAlpha = nil
	end,
})
TMW:RegisterUpgrade(60000, {
	icon = function(self, ics)
		ics.StackMin = floor(tonumber(ics.StackMin)) or 0
		ics.StackMax = floor(tonumber(ics.StackMax)) or 0
	end,
})
TMW:RegisterUpgrade(23000, {
	icon = function(self, ics)
		if ics.StackMin ~= TMW.Icon_Defaults.StackMin then
			ics.StackMinEnabled = true
		end
		if ics.StackMax ~= TMW.Icon_Defaults.StackMax then
			ics.StackMaxEnabled = true
		end
	end,
})
TMW:RegisterUpgrade(60010, {
	icon = function(self, ics)
		ics.StackAlpha = ics.ConditionAlpha
	end,
})



-- Create an IconDataProcessor that will store the result of the stack test
local Processor = TMW.Classes.IconDataProcessor:New("STATE_STACKSFAILED", "state_stackFailed")
Processor.dontInherit = true
Processor:RegisterAsStateArbitrator(30, Hook, false, function(icon)
	local ics = icon:GetSettings()
	if not ics.StackMinEnabled and not ics.StackMaxEnabled then
		return nil
	end

	local text = ""
	if ics.StackMinEnabled then
		text = L["STACKS"] .. " < " .. ics.StackMin
	end
	if ics.StackMaxEnabled then
		if ics.StackMinEnabled then
			text = text .. " " .. L["CONDITIONPANEL_OR"]:lower() .. " "
		end
		text = text .. L["STACKS"] .. " > " .. ics.StackMax
	end
	
	return {
		[STATE] = { text = text, tooltipText = L["STACKALPHA_DESC"]},
	}
end)

Hook:DeclareUpValue("STATE_DEFAULT_STACKSFAILED",  STATE)
Hook:RegisterCompileFunctionSegmentHook("post", function(Processor, t)
	-- GLOBALS: stack
	t[#t+1] = [[
	
	local state_stackFailed = nil
	if
		stack and ((icon.StackMinEnabled and icon.StackMin > stack) or (icon.StackMaxEnabled and stack > icon.StackMax))
	then
		state_stackFailed = icon.States[STATE_DEFAULT_STACKSFAILED]
	end
	
	if attributes.state_stackFailed ~= state_stackFailed then
		icon:SetInfo_INTERNAL("state_stackFailed", state_stackFailed)
		doFireIconUpdated = true
	end
	--]]
end)
