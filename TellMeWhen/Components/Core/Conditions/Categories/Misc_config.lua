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

local CNDT = TMW.CNDT

local TMW = TMW
local L = TMW.L
local print = TMW.print



-- Lua condition icon editor
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	CndtGroup.Lua:Hide()
	if conditionData and conditionData.identifier == "LUA" then
		CndtGroup.Lua:Show()
		CndtGroup:AddRow(CndtGroup.Lua)
	end
end)


-- Add as icon shown condition
TMW.IconDragger:RegisterIconDragHandler(210, 
	function(IconDragger, info)
		if IconDragger.desticon then
			if IconDragger.srcicon:IsValid() then
				info.text = L["ICONMENU_APPENDCONDT"]
				info.tooltipTitle = nil
				info.tooltipText = nil
				return true
			end
		end
	end,
	function(IconDragger)
		-- add a condition to the destination icon
		local Condition = CNDT:AddCondition(IconDragger.desticon:GetSettings().Conditions)

		-- set the settings
		Condition.Type = "ICON"
		Condition.Icon = IconDragger.srcicon:GetGUID(true)
	end
)
