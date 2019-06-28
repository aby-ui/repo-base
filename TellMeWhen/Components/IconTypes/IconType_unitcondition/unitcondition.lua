-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------

local TMW = TMW
if not TMW then return end
local L = TMW.L

local print = TMW.print
local GetSpellBookItemInfo, GetItemIcon = 
	  GetSpellBookItemInfo, GetItemIcon

local Type = TMW.Classes.IconType:New("unitcondition")
Type.name = L["ICONMENU_UNITCNDTIC"]
Type.desc = L["ICONMENU_UNITCNDTIC_DESC"]
Type.menuIcon = "Interface\\Icons\\inv_misc_punchcards_yellow"
Type.AllowNoName = true
Type.hasNoGCD = true
Type.unitType = "unitid"
Type.canControlGroup = true
Type.menuSpaceAfter = true

local STATE_SUCCEED = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_FAIL = TMW.CONST.STATE.DEFAULT_HIDE

-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("unit, GUID")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes



Type:RegisterIconDefaults{
	-- The unit(s) to check
	Unit					= "player", 

	-- Duration of a timer to set on the icon when the conditions start to succeed
	ConditionDur			= 0,

	-- Duration of a timer to set on the icon when the conditions start to fail
	UnConditionDur			= 0,

	-- True if there should be a timer set on the icon when the conditions start to succeed
	ConditionDurEnabled		= false,

	-- True if there should be a timer set on the icon when the conditions start to fail
	UnConditionDurEnabled  	= false,

	-- True if the icon should only show when the timer on it is running. Mutually exclusive with OnlyIfNotCounting.
	OnlyIfCounting			= false,

	-- True if the icon should only show when the timer on it is not running. Mutually exclusive with OnlyIfCounting.
	OnlyIfNotCounting		= false,
}


Type:RegisterConfigPanel_XMLTemplate(105, "TellMeWhen_Unit", {
	implementsConditions = true,
})

Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_SUCCEED] = { text = "|cFF00FF00" .. L["ICONMENU_UNITSUCCEED"], },
	[STATE_FAIL] =    { text = "|cFFFF0000" .. L["ICONMENU_UNITFAIL"],    },
})

Type:RegisterConfigPanel_XMLTemplate(150, "TellMeWhen_ConditionIconSettings")



local function ConditionIcon_OnEvent(icon, event, arg1)
	icon.NextUpdateTime = 0
end

local function ConditionIcon_OnUpdate(icon, time)
	local UnitSet = icon.UnitSet
	local Units = UnitSet.translatedUnits
	local Conditions = UnitSet.ConditionObjects

	local unitStatus = icon.__unitConditionStatus

	-- Use originalUnits as the length because translatedUnits can have holes in it.
	-- We want to iterate over every unit that might have been getting checked,
	-- not just only those units which pass the conditions and are thus exposed on the UnitSet.
	for u = 1, #UnitSet.originalUnits do
		local unit = Units[u]
		if unit and UnitExists(unit) then
			local succeeded = not Conditions or not Conditions[u].Failed
			local status = unitStatus[unit]

			local state = succeeded and STATE_SUCCEED or STATE_FAIL
			if succeeded and not status.succeeded and icon.ConditionDurEnabled then
				-- Start the timer on the icon if the conditions just began succeeding.
				d = icon.ConditionDur
				start, duration = time, d

			elseif not succeeded and status.succeeded and icon.UnConditionDurEnabled then
				-- Start the timer on the icon if the conditions just began failing.
				d = icon.UnConditionDur
				start, duration = time, d

			else
				d = status.duration - (time - status.start)
				d = d > 0 and d or 0
				if d > 0 then
					-- Need these so that the timer doesn't get reset when we call icon:SetInfo()
					start, duration = status.start, status.duration
				else
					-- Reset the timer to 0 if the timer is expired.
					start, duration = 0, 0
				end
			end

			status.succeeded = succeeded
			status.start = start
			status.duration = duration

			if icon.OnlyIfCounting and d <= 0 then
				-- Set the state of the icon to 0 if the timer is not running
				-- and the icon is configured to only show while it is running.
				state = 0
			elseif icon.OnlyIfNotCounting and d > 0 then
				-- Set the state of the icon to 0 if the timer is running
				-- and the icon is configured to only show while it isn't running.
				state = 0
			end

			if state ~= 0 and icon.States[state].Alpha > 0 then
				if not icon:YieldInfo(true, state, start, duration, unit) then
					return
				end
			end

		end
	end

	if not icon:YieldInfo(false, 0, 0, 0, nil) then
		return
	end
end
function Type:HandleYieldedInfo(icon, iconToSet, state, start, duration, unit)
	iconToSet:SetInfo("state; start, duration; unit, GUID",
		state,
		start, duration,
		unit, nil
	)
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	return ""
end


function Type:Setup(icon)

	if not icon.__unitConditionStatus then
		icon.__unitConditionStatus = setmetatable({}, {__index = function(t,k)
			t[k] = {start=0, duration=0, succeeded = false}
			return t[k]
		end })
	end

	local _, UnitSet = TMW:GetUnits(icon, icon.Unit, icon:GetSettings().UnitConditions)
	if icon.UnitSet ~= UnitSet then
		-- If this unitset is not the one that we had previously, reset the condition status table.
		icon.UnitSet = UnitSet
		wipe(icon.__unitConditionStatus)
	end

	icon:SetInfo("texture", "Interface\\Icons\\INV_Misc_QuestionMark")


	-- Setup events and update functions.
	if UnitSet.allUnitsChangeOnEvent then
		icon:SetUpdateMethod("manual")
	
		TMW:RegisterCallback("TMW_UNITSET_UPDATED", ConditionIcon_OnEvent, icon)
	end

	
	icon:SetUpdateFunction(ConditionIcon_OnUpdate)
	icon:Update()
end

function Type:DragReceived(icon, t, data, subType)
	-- Since the icon type itself can't declare its texture, 
	-- redirect icon drag data to icon.CustomTex. This couples separate modules more than I would like,
	-- but oh well. None of this will ever change.
	local ics = icon:GetSettings()

	local _, input
	if t == "spell" then
		_, input = GetSpellBookItemInfo(data, subType)
	elseif t == "item" then
		input = GetItemIcon(data)
	end
	if not input then
		return
	end

	ics.CustomTex = TMW:CleanString(input)
	return true -- signal success
end

function Type:GetIconMenuText(ics)
	local text = Type.name .. " " .. L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"]:format((ics.Conditions and (ics.Conditions.n or #ics.Conditions)) or 0)
	
	return text, "", true
end

Type:Register(301)
