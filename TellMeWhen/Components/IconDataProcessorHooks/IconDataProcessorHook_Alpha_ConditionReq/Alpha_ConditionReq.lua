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


TMW.CONST.STATE.DEFAULT_CONDITIONFAILED = 102
local STATE = TMW.CONST.STATE.DEFAULT_CONDITIONFAILED




local Hook = TMW.Classes.IconDataProcessorHook:New("STATE_CONDITIONREQ", "CONDITION")

TMW:RegisterUpgrade(80013, {
	icon = function(self, ics)
		ics.States[STATE].Alpha = ics.ConditionAlpha or 0
		ics.ConditionAlpha = nil
	end,
})
TMW:RegisterUpgrade(41005, {
	icon = function(self, ics)
		ics.ConditionAlpha = 0
	end,
})

local Processor = TMW.Classes.IconDataProcessor:New("STATE_CONDITIONFAILED", "state_conditionFailed")
Processor.dontInherit = true
Processor:RegisterAsStateArbitrator(10, Hook, false, function(icon)
	local ics = icon:GetSettings()
	if ics.Conditions.n == 0 then
		return nil
	end

	return {
		[STATE] = { text = L["CONDITIONALPHA_METAICON"], tooltipText = L["CONDITIONALPHA_METAICON_DESC"]},
	}
end)

-- This IconDataProcessorHook does not RegisterCompileFunctionSegmentHook(). 
-- Since it only really matters when conditionFailed changes, we listen to CONDITION's changedEvent,
-- and call SetInfo_INTERNAL to set state_conditionFailed as needed.
TMW:RegisterCallback(TMW.Classes.IconDataProcessor.ProcessorsByName.CONDITION.changedEvent, function(event, icon, conditionFailed)
	if conditionFailed then
		icon:SetInfo_INTERNAL("state_conditionFailed", icon.States[STATE])
	else
		icon:SetInfo_INTERNAL("state_conditionFailed", nil)
	end
end)


function Hook:OnImplementIntoIcon(icon)
	if icon.attributes.conditionFailed then
		icon:SetInfo("state_conditionFailed", icon.States[STATE])
	else
		icon:SetInfo("state_conditionFailed", nil)
	end
end

function Hook:OnUnimplementFromIcon(icon)
	icon:SetInfo("state_conditionFailed", nil)
end

