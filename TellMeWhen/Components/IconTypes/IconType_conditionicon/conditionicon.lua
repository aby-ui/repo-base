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

local Type = TMW.Classes.IconType:New("conditionicon")
Type.name = L["ICONMENU_CNDTIC"]
Type.desc = L["ICONMENU_CNDTIC_DESC"]
Type.menuIcon = "Interface\\Icons\\inv_misc_punchcards_yellow"
Type.menuSpaceBefore = true
Type.AllowNoName = true
Type.hasNoGCD = true

local STATE_SUCCEED = TMW.CONST.STATE.DEFAULT_SHOW
local STATE_FAIL = TMW.CONST.STATE.DEFAULT_HIDE


-- AUTOMATICALLY GENERATED: UsesAttributes
Type:UsesAttributes("state")
Type:UsesAttributes("start, duration")
Type:UsesAttributes("state_conditionFailed")
Type:UsesAttributes("texture")
-- END AUTOMATICALLY GENERATED: UsesAttributes

-- Not automatically generated, but still needed.
Type:UsesAttributes("conditionFailed", false)



Type:RegisterIconDefaults{
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

TMW:RegisterUpgrade(47204, {
	icon = function(self, ics)
		-- Condition icons no longer have ChooseName to be able to set their own texture.
		-- Custom Texture is now the only texture setting for the icon.
		if ics.Type == "conditionicon" then
			ics.CustomTex = ics.Name or ""
			ics.Name = ""
		end
	end,
})

TMW:RegisterUpgrade(45013, {
	icon = function(self, ics)
		if ics.Type == "conditionicon" then
			ics.Alpha = 1
			ics.UnAlpha = ics.ConditionAlpha or 0
			ics.ConditionAlpha = 0
		end
	end,
})


Type:RegisterConfigPanel_XMLTemplate(165, "TellMeWhen_IconStates", {
	[STATE_SUCCEED] = { text = "|cFF00FF00" .. L["ICONMENU_SUCCEED2"], },
	[STATE_FAIL] =    { text = "|cFFFF0000" .. L["ICONMENU_FAIL2"],    },
})

Type:RegisterConfigPanel_XMLTemplate(150, "TellMeWhen_ConditionIconSettings")



local function ConditionIcon_OnUpdate(icon, time)
	local ConditionObject = icon.ConditionObject
	if ConditionObject then
		local succeeded = not ConditionObject.Failed
		
		local state = succeeded and STATE_SUCCEED or STATE_FAIL

		local d, start, duration

		if succeeded and not icon.__succeeded and icon.ConditionDurEnabled then
			-- Start the timer on the icon if the conditions just began succeeding.
			d = icon.ConditionDur
			start, duration = time, d

		elseif not succeeded and icon.__succeeded and icon.UnConditionDurEnabled then
			-- Start the timer on the icon if the conditions just began failing.
			d = icon.UnConditionDur
			start, duration = time, d

		else
			local attributes = icon.attributes
			d = attributes.duration - (time - attributes.start)
			d = d > 0 and d or 0
			if d > 0 then
				-- Need these so that the timer doesn't get reset when we call icon:SetInfo()
				start, duration = attributes.start, attributes.duration
			else
				-- Reset the timer to 0 if the timer is expired.
				start, duration = 0, 0
			end
		end

		if icon.OnlyIfCounting and d <= 0 then
			-- Set the state of the icon to 0 if the timer is not running
			-- and the icon is configured to only show while it is running.
			state = 0
		elseif icon.OnlyIfNotCounting and d > 0 then
			-- Set the state of the icon to 0 if the timer is running
			-- and the icon is configured to only show while it isn't running.
			state = 0
		end
		
		-- We set state_conditionFailed to override the automatic state handling of ConditionObjects.
		-- We want to set the alpha on our own (though the icon's state).
		icon:SetInfo(
			"state_conditionFailed; state; start, duration",
			nil,
			state,
			start, duration
		)

		-- Record the passing state of the icon's condition object so we can detect when it changes.
		icon.__succeeded = succeeded
	else
		icon:SetInfo("state_conditionFailed; state", nil, STATE_SUCCEED)
	end
end

function Type:FormatSpellForOutput(icon, data, doInsertLink)
	return ""
end


function Type:Setup(icon)
	icon:SetInfo("texture", "Interface\\Icons\\INV_Misc_QuestionMark")

	-- Icon updates will automatically get scheduled by the icon update engine
	-- when the icon's condition object changes and schedules an icon update.
	-- So we don't need to register any events at all, and we can update manually!

	icon:SetUpdateMethod("manual")
	
	icon:SetUpdateFunction(ConditionIcon_OnUpdate)
	--icon:Update() -- dont do this!
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

Type:Register(300)
