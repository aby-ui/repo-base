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

local format = format
local isNumber = TMW.isNumber







-- SHOWN: "shown"
do
	local Processor = TMW.Classes.IconDataProcessor:New("SHOWN", "shown")
	Processor.dontInherit = true

	-- Processor:CompileFunctionSegment(t) is default.

	-- The default state is hidden, so reflect this.
	TMW.Classes.Icon.attributes.shown = false
end






-- STATE: "state"
do
	local Processor = TMW.Classes.IconDataProcessor:New("STATE", "state")
	Processor:DeclareUpValue("stateDataNone", {Alpha = 0, Color = "ffffffff", Texture=""})
	Processor.dontInherit = true
	Processor:RegisterAsStateArbitrator(100, nil, false, function(icon, panelInfo)
		return panelInfo.supplementalData
	end)

	-- Processor:CompileFunctionSegment(t) is default.

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: state
		t[#t+1] = [[
		--if state ~= nil then
			local stateData = type(state) == 'table' and state or (state == 0 and stateDataNone or icon.States[state])
			if attributes.state ~= stateData then
				attributes.state = stateData

				TMW:Fire(STATE.changedEvent, icon, stateData, state)
				doFireIconUpdated = true
			end
		--end
		--]]
	end

	TMW:RegisterCallback("TMW_ICON_SETUP_PRE", function(event, icon)
		icon:SetInfo("state", 0)
	end)
end


-- CALCULATEDSTATE: "calculatedState"
do
	local Processor = TMW.Classes.IconDataProcessor:New("CALCULATEDSTATE", "calculatedState")
	Processor.dontInherit = true
end






-- ALPHAOVERRIDE: "alphaOverride"
do
	-- This is used for force-show icons in config mode.
	-- Note that alphaOverride is also used to hide controlled icons that don't have data.
	-- This is required because otherwise, meta icon controller unused icons would never hide
	-- because the state arbitrator would pick the meta icon state over the icon's own state.
	-- So, we use this property to absolutely override all other possible state inputs.
	-- Using alphaOverride for controlled icons fixes commit 1172c2092 which broke behavior (ticket 1298).

	local Processor = TMW.Classes.IconDataProcessor:New("ALPHAOVERRIDE", "alphaOverride")
	Processor:RegisterAsStateArbitrator(0, nil, true)
	Processor.dontInherit = true

	Processor:DeclareUpValue("alphaOverrideStates", setmetatable({}, {
		__index = function(self, k)
			if not k then return nil end
			self[k] = {Alpha = k, Color = "ffffffff", Texture=""}
			return self[k]
		end
	}))

	-- Processor:CompileFunctionSegment(t) is default.

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: alphaOverride
		t[#t+1] = [[
			local stateData = type(alphaOverride) == 'table' and alphaOverride or alphaOverrideStates[alphaOverride]
			if attributes.alphaOverride ~= stateData then
				attributes.alphaOverride = stateData

				TMW:Fire(STATE.changedEvent, icon, stateData, alphaOverride)
				doFireIconUpdated = true
			end
		--]]
	end
end






-- REALALPHA: "realAlpha"
do
	local Processor = TMW.Classes.IconDataProcessor:New("REALALPHA", "realAlpha")
	Processor.dontInherit = true
	Processor:AssertDependency("SHOWN")

	TMW.Classes.Icon.attributes.realAlpha = 0

	Processor:RegisterIconEvent(11, "OnShow", {
		category = L["EVENT_CATEGORY_VISIBILITY"],
		text = L["SOUND_EVENT_ONSHOW"],
		desc = L["SOUND_EVENT_ONSHOW_DESC"],
	})
	Processor:RegisterIconEvent(12, "OnHide", {
		category = L["EVENT_CATEGORY_VISIBILITY"],
		text = L["SOUND_EVENT_ONHIDE"],
		desc = L["SOUND_EVENT_ONHIDE_DESC"],
		settings = {
			OnlyShown = false,
		},
		applyDefaultsToSetting = function(EventSettings)
			EventSettings.OnlyShown = false
		end,
	})
	Processor:RegisterIconEvent(13, "OnAlphaInc", {
		category = L["EVENT_CATEGORY_VISIBILITY"],
		text = L["SOUND_EVENT_ONALPHAINC"],
		desc = L["SOUND_EVENT_ONALPHAINC_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = true,
			PassingCndt = true,
		},
		valueName = L["ALPHA"],
		valueSuffix = "%",
		conditionChecker = function(icon, eventSettings)
			return TMW.CompareFuncs[eventSettings.Operator](icon.attributes.realAlpha * 100, eventSettings.Value)
		end,
	})
	Processor:RegisterIconEvent(14, "OnAlphaDec", {
		category = L["EVENT_CATEGORY_VISIBILITY"],
		text = L["SOUND_EVENT_ONALPHADEC"],
		desc = L["SOUND_EVENT_ONALPHADEC_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = true,
			PassingCndt = true,
		},
		valueName = L["ALPHA"],
		valueSuffix = "%",
		conditionChecker = function(icon, eventSettings)
			return TMW.CompareFuncs[eventSettings.Operator](icon.attributes.realAlpha * 100, eventSettings.Value)
		end,
	})

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: realAlpha
		t[#t+1] = [[
		if realAlpha ~= attributes.realAlpha then
			local oldalpha = attributes.realAlpha or 0

			attributes.realAlpha = realAlpha

			-- detect events that occured, and handle them if they did
			if realAlpha == 0 then
				if EventHandlersSet.OnHide then
					icon:QueueEvent("OnHide")
				end
			elseif oldalpha == 0 then
				if EventHandlersSet.OnShow then
					icon:QueueEvent("OnShow")
				end
			elseif realAlpha > oldalpha then
				if EventHandlersSet.OnAlphaInc then
					icon:QueueEvent("OnAlphaInc")
				end
			else -- it must be less than, because it isnt greater than and it isnt the same
				if EventHandlersSet.OnAlphaDec then
					icon:QueueEvent("OnAlphaDec")
				end
			end

			TMW:Fire(REALALPHA.changedEvent, icon, realAlpha, oldalpha)
			doFireIconUpdated = true
		end
		--]]
	end


	TMW:RegisterCallback("TMW_INITIALIZE", function()
		local IconPosition_Sortable = TMW.C.GroupModule_IconPosition_Sortable
		if IconPosition_Sortable then
			IconPosition_Sortable:RegisterIconSorter("alpha", {
				DefaultOrder = -1,
				[1] = L["UIPANEL_GROUPSORT_alpha_1"],
				[-1] = L["UIPANEL_GROUPSORT_alpha_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				local a, b = attributesA.realAlpha, attributesB.realAlpha
				if a ~= b then
					return a*order < b*order
				end
			end)

			IconPosition_Sortable:RegisterIconSorter("shown", {
				DefaultOrder = -1,
				[1] = L["UIPANEL_GROUPSORT_shown_1"],
				[-1] = L["UIPANEL_GROUPSORT_shown_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				local a, b = (attributesA.shown and attributesA.realAlpha > 0) and 1 or 0, (attributesB.shown and attributesB.realAlpha > 0) and 1 or 0
				if a ~= b then
					return a*order < b*order
				end
			end)

			IconPosition_Sortable:RegisterIconSortPreset(L["UIPANEL_GROUP_QUICKSORT_SHOWN"], {
				{ Method = "fakehidden", Order = 1 },
				{ Method = "shown", Order = -1 },
				{ Method = "id", Order = 1 }
			})
		end
	end)

	
	Processor:RegisterDogTag("TMW", "IsShown", {	
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]

			if icon then
				local attributes = icon.attributes
				return not not attributes.shown and attributes.realAlpha > 0
			else
				return false
			end
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("SHOWN", "REALALPHA"),
		ret = "boolean",
		doc = L["DT_DOC_IsShown"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[IsShown] => "true"; [IsShown(icon="TMW:icon:1I7MnrXDCz8T")] => "false"',
		category = L["ICON"],
	})
	Processor:RegisterDogTag("TMW", "Opacity", {	
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			if icon then
				return icon.attributes.realAlpha
			else
				return 0
			end
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("REALALPHA"),
		ret = "number",
		doc = L["DT_DOC_Opacity"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[Opacity] => "1"; [Opacity(icon="TMW:icon:1I7MnrXDCz8T")] => "0.42"',
		category = L["ICON"],
	})
end






-- CONDITION: "conditionFailed"
do
	local Processor = TMW.Classes.IconDataProcessor:New("CONDITION", "conditionFailed")
	Processor.dontInherit = true

	-- Processor:CompileFunctionSegment(t) is default.
end






-- DURATION: "start, duration"
do
	local Processor = TMW.Classes.IconDataProcessor:New("DURATION", "start, duration")
	Processor:DeclareUpValue("OnGCD", TMW.OnGCD)

	TMW.Classes.Icon.attributes.start = 0
	TMW.Classes.Icon.attributes.duration = 0
	TMW.Classes.Icon.__realDuration = 0

	Processor:RegisterIconEvent(21, "OnStart", {
		category = L["EVENT_CATEGORY_TIMER"],
		text = L["SOUND_EVENT_ONSTART"],
		desc = L["SOUND_EVENT_ONSTART_DESC"],
	})

	Processor:RegisterIconEvent(22, "OnFinish", {
		category = L["EVENT_CATEGORY_TIMER"],
		text = L["SOUND_EVENT_ONFINISH"],
		desc = L["SOUND_EVENT_ONFINISH_DESC"],
	})

	Processor:RegisterIconEvent(23, "OnDuration", {
		category = L["EVENT_CATEGORY_TIMER"],
		text = L["SOUND_EVENT_ONDURATION"],
		desc = L["SOUND_EVENT_ONDURATION_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = function(check)
				check:Disable()
				check:SetAlpha(1)
			end,
			PassingCndt = function(check)
				check:Disable()
				check:SetAlpha(1)
			end,
		},
		blacklistedOperators = {
			["~="] = true,
			["=="] = true,
		},
		valueName = L["DURATION"],
		conditionChecker = function(icon, eventSettings)
			local attributes = icon.attributes
			local d = attributes.duration - (TMW.time - attributes.start)
			d = d > 0 and d or 0

			return TMW.CompareFuncs[eventSettings.Operator](d, eventSettings.Value)
		end,
		applyDefaultsToSetting = function(EventSettings)
			EventSettings.CndtJustPassed = true
			EventSettings.PassingCndt = true
		end,
	})

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: start, duration
		t[#t+1] = [[
		duration = duration or 0
		start = start or 0
		
		if duration == 0.001 then duration = 0 end -- hardcode fix for tricks of the trade. nice hardcoding on your part too, blizzard

		if EventHandlersSet.OnDuration then
			local d = duration - (TMW.time - start)
			d = d > 0 and d or 0
			
			if d ~= icon.__lastDur then
				icon:QueueEvent("OnDuration")
				icon.__lastDur = d
			end
		end

		if attributes.start ~= start or attributes.duration ~= duration then

			local realDuration = icon:OnGCD(duration) and 0 or duration -- the duration of the cooldown, ignoring the GCD
			if icon.__realDuration ~= realDuration then
				-- detect events that occured, and handle them if they did
				if realDuration == 0 then
					if EventHandlersSet.OnFinish then
						icon:QueueEvent("OnFinish")
					end
				else
					if EventHandlersSet.OnStart then
						icon:QueueEvent("OnStart")
					end
				end
				icon.__realDuration = realDuration
			end

			attributes.start = start
			attributes.duration = duration

			TMW:Fire(DURATION.changedEvent, icon, start, duration)
			doFireIconUpdated = true
		end
		--]]
	end


	function Processor:OnImplementIntoIcon(icon)
		if icon.EventHandlersSet.OnDuration then
			for _, EventSettings in TMW:InNLengthTable(icon.Events) do
				if EventSettings.Event == "OnDuration" then
					self:RegisterDurationTrigger(icon, EventSettings.Value)
				end
			end
		end
	end





	---------------------------------
	-- Duration triggers
	---------------------------------

	-- Duration triggers. Register a duration trigger to cause a call to
	-- icon:SetInfo("start, duration", icon.attributes.start, icon.attributes.duration)
	-- when the icon reaches the specified duration.
	local DurationTriggers = {}
	Processor.DurationTriggers = DurationTriggers
	function Processor:RegisterDurationTrigger(icon, duration)
		if not DurationTriggers[icon] then
			DurationTriggers[icon] = {}
		end

		if not TMW.tContains(DurationTriggers[icon], duration) then
			tinsert(DurationTriggers[icon], duration)
		end
	end

	function Processor:OnUnimplementFromIcon(icon)
		if DurationTriggers[icon] then
			wipe(DurationTriggers[icon])
		end
	end

	TMW:RegisterCallback("TMW_ONUPDATE_TIMECONSTRAINED_PRE", function(event, time, Locked)
		for icon, durations in pairs(DurationTriggers) do
			if #durations > 0 then
				local lastCheckedDuration = durations.last or 0

				local currentIconDuration = icon.attributes.duration - (time - icon.attributes.start)
				if currentIconDuration < 0 then currentIconDuration = 0 end
				
				-- If the duration didn't change (i.e. it is 0) then don't even try.
				if currentIconDuration ~= lastCheckedDuration then

					for i = 1, #durations do
						local durationToCheck = durations[i]
					--	print(icon, currentIconDuration, lastCheckedDuration, durationToCheck)
						if currentIconDuration <= durationToCheck and -- Make sure we are at or have passed the duration we want to trigger at
							(lastCheckedDuration > durationToCheck -- Make sure that we just reached this duration (so it doesn't continually fire)
							or lastCheckedDuration < currentIconDuration -- or make sure that the duration increased since the last time we checked the triggers.
						) then
							if icon:IsControlled() then
								icon.group.Controller.NextUpdateTime = 0
							else
								icon.NextUpdateTime = 0
							end
						--	print(icon, "TRIGGER")
							--icon:Update()
							--icon:SetInfo("start, duration", icon.attributes.start, icon.attributes.duration)
							break
						end
					end
				end
				durations.last = currentIconDuration
			end
		end
	end)


	TMW:RegisterCallback("TMW_INITIALIZE", function()
		local IconPosition_Sortable = TMW.C.GroupModule_IconPosition_Sortable
		if IconPosition_Sortable then
			IconPosition_Sortable:RegisterIconSorter("duration", {
				DefaultOrder = 1,
				[1] = L["UIPANEL_GROUPSORT_duration_1"],
				[-1] = L["UIPANEL_GROUPSORT_duration_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				local time = TMW.time
				
				local durationA = attributesA.duration
				local durationB = attributesB.duration

				durationA = iconA:OnGCD(durationA) and 0 or durationA - (time - attributesA.start)
				durationB = iconB:OnGCD(durationB) and 0 or durationB - (time - attributesB.start)

				if durationA ~= durationB then
					return durationA*order < durationB*order
				end
			end)

			IconPosition_Sortable:RegisterIconSortPreset(L["UIPANEL_GROUP_QUICKSORT_DURATION"], {
				{ Method = "shown", Order = -1 },
				{ Method = "duration", Order = 1 },
				{ Method = "id", Order = 1 }
			})
		end
	end)




	TMW:RegisterCallback("TMW_ICON_SETUP_POST", function(event, icon)
		if not TMW.Locked then
			icon:SetInfo("start, duration", 0, 0)
		end
	end)
end





-- REVERSE: "reverse"
do
	local Processor = TMW.Classes.IconDataProcessor:New("REVERSE", "reverse")
	-- Processor:CompileFunctionSegment(t) is default.

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("reverse", nil)
	end)
end






-- SPELL: "spell"
do
	local Processor = TMW.Classes.IconDataProcessor:New("SPELL", "spell")

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: spell
		t[#t+1] = [[
		if attributes.spell ~= spell then
			attributes.spell = spell
			
			if EventHandlersSet.OnSpell then
				icon:QueueEvent("OnSpell")
			end

			TMW:Fire(SPELL.changedEvent, icon, spell)
			doFireIconUpdated = true
		end
		--]]
	end

	Processor:RegisterIconEvent(31, "OnSpell", {
		category = L["EVENT_CATEGORY_CHANGED"],
		text = L["SOUND_EVENT_ONSPELL"],
		desc = L["SOUND_EVENT_ONSPELL_DESC"],
	})
		
	Processor:RegisterDogTag("TMW", "Spell", {
		code = function(icon, link)
			icon = TMW.GUIDToOwner[icon]

			if icon then
				local name, checkcase = icon.typeData:FormatSpellForOutput(icon, icon.attributes.spell, link)
				name = name or ""
				if checkcase and name ~= "" then
					name = TMW:RestoreCase(name)
				end
				return name
			else
				return ""
			end
		end,
		arg = {
			'icon', 'string', '@req',
			'link', 'boolean', false,
		},
		events = TMW:CreateDogTagEventString("SPELL"),
		ret = "string",
		doc = L["DT_DOC_Spell"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = ('[Spell] => %q; [Spell(link=true)] => %q; [Spell(icon="TMW:icon:1I7MnrXDCz8T")] => %q; [Spell(icon="TMW:icon:1I7MnrXDCz8T", link=true)] => %q'):format(GetSpellInfo(2139), GetSpellLink(2139), GetSpellInfo(1766), GetSpellLink(1766)),
		category = L["ICON"],
	})

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("spell", nil)
	end)
end






-- SPELLCHARGES: "charges, maxCharges, chargeStart, chargeDur"
do
	local Processor = TMW.Classes.IconDataProcessor:New("SPELLCHARGES", "charges, maxCharges, chargeStart, chargeDur")

	Processor:RegisterIconEvent(26, "OnChargeGained", {
		category = L["EVENT_CATEGORY_CHARGES"],
		text = L["SOUND_EVENT_ONCHARGEGAINED"],
		desc = L["SOUND_EVENT_ONCHARGEGAINED_DESC"],
	})

	Processor:RegisterIconEvent(27, "OnChargeLost", {
		category = L["EVENT_CATEGORY_CHARGES"],
		text = L["SOUND_EVENT_ONCHARGELOST"],
		desc = L["SOUND_EVENT_ONCHARGELOST_DESC"],
	})

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: charges, maxCharges, chargeStart, chargeDur
		t[#t+1] = [[
		
		if charges == maxCharges then
			chargeStart, chargeDur = 0, 0
		end
			
		if attributes.charges ~= charges
		or attributes.maxCharges ~= maxCharges
		or attributes.chargeStart ~= chargeStart
		or attributes.chargeDur ~= chargeDur then

			local oldCharges = attributes.charges
			if charges and oldCharges then
				if oldCharges > charges then
					if EventHandlersSet.OnChargeLost then
						icon:QueueEvent("OnChargeLost")
					end
				elseif oldCharges < charges then
					if EventHandlersSet.OnChargeGained then
						icon:QueueEvent("OnChargeGained")
					end
				end
			end

			attributes.charges = charges
			attributes.maxCharges = maxCharges
			attributes.chargeStart = chargeStart
			attributes.chargeDur = chargeDur
			
			TMW:Fire(SPELLCHARGES.changedEvent, icon, charges, maxCharges, chargeStart, chargeDur)
			doFireIconUpdated = true
		end
		--]]
	end

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("charges, maxCharges, chargeStart, chargeDur", nil, nil, nil, nil)
	end)
	TMW:RegisterCallback("TMW_ICON_SETUP_POST", function(event, icon)
		if not TMW.Locked then
			icon:SetInfo("charges, maxCharges, chargeStart, chargeDur", nil, nil, nil, nil)
		end
	end)
end






-- shared DogTags (SPELLCHARGES & DURATION)
do
	local OnGCD = TMW.OnGCD
	TMW.C.IconComponent:RegisterDogTag("TMW", "Duration", {
		code = function(icon, gcd, ignoreCharges)
			icon = TMW.GUIDToOwner[icon]

			if icon then
				local attributes = icon.attributes

				local chargeDur = attributes.chargeDur
				if not ignoreCharges and chargeDur and chargeDur > 0 then

					local remaining = chargeDur - (TMW.time - attributes.chargeStart)
					if remaining > 0 then
						return isNumber[format("%.1f", remaining)] or 0
					end
				end

				local duration = attributes.duration
				
				local remaining = duration - (TMW.time - attributes.start)
				if remaining <= 0 or (not gcd and icon:OnGCD(duration)) then
					return 0
				end

				-- cached version of tonumber()
				return isNumber[format("%.1f", remaining)] or 0
			else
				return 0
			end
		end,
		arg = {
			'icon', 'string', '@req',
			'gcd', 'boolean', true,
			'ignorecharges', 'boolean', false,
		},
		events = "FastUpdate",
		ret = "number",
		doc = L["DT_DOC_Duration"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[Duration] => "1.435"; [Duration(gcd=false)] => "0"; [Duration(ignorecharges=true)] => "0"; [Duration:TMWFormatDuration] => "1.4"; [Duration(icon="TMW:icon:1I7MnrXDCz8T")] => "97.32156"; [Duration(icon="TMW:icon:1I7MnrXDCz8T"):TMWFormatDuration] => "1:37"',
		category = L["ICON"],
	})
	
	TMW.C.IconComponent:RegisterDogTag("TMW", "MaxDuration", {
		code = function(icon, ignoreCharges)
			icon = TMW.GUIDToOwner[icon]

			if icon then
				local attributes = icon.attributes

				local duration = attributes.duration
				
				local chargeDur = attributes.chargeDur
				if not ignoreCharges and chargeDur and chargeDur > 0 then
					duration = chargeDur;
				end

				if duration <= 0 then
					return 0
				end

				-- cached version of tonumber()
				return isNumber[format("%.1f", duration)] or 0
			else
				return 0
			end
		end,
		arg = {
			'icon', 'string', '@req',
			'ignorecharges', 'boolean', false,
		},
		events = "FastUpdate",
		ret = "number",
		doc = L["DT_DOC_MaxDuration"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[MaxDuration] => "3"; [MaxDuration:TMWFormatDuration] => "3.0"; [MaxDuration(icon="TMW:icon:1I7MnrXDCz8T")] => "60"',
		category = L["ICON"],
	})
end






-- VALUE: "value, maxValue, valueColor"
do
	local Processor = TMW.Classes.IconDataProcessor:New("VALUE", "value, maxValue, valueColor")

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: value, maxValue, valueColor
		t[#t+1] = [[
		
		if attributes.value ~= value or attributes.maxValue ~= maxValue or attributes.valueColor ~= valueColor then

			attributes.value = value
			attributes.maxValue = maxValue
			attributes.valueColor = valueColor
			
			TMW:Fire(VALUE.changedEvent, icon, value, maxValue, valueColor)
			doFireIconUpdated = true
		end
		--]]
	end

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("value, maxValue, valueColor", nil, nil, nil)
	end)
		

	TMW:RegisterCallback("TMW_INITIALIZE", function()
		local IconPosition_Sortable = TMW.C.GroupModule_IconPosition_Sortable
		if IconPosition_Sortable then
			IconPosition_Sortable:RegisterIconSorter("value", {
				DefaultOrder = -1,
				[1] = L["UIPANEL_GROUPSORT_value_1"],
				[-1] = L["UIPANEL_GROUPSORT_value_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				local a, b = attributesA.value, attributesB.value
				if a ~= b then
					return (a or 0)*order < (b or 0)*order
				end
			end)

			IconPosition_Sortable:RegisterIconSorter("valuep", {
				DefaultOrder = -1,
				[1] = L["UIPANEL_GROUPSORT_valuep_1"],
				[-1] = L["UIPANEL_GROUPSORT_valuep_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				
				local a, b = attributesA.maxValue == 0 and 0 or attributesA.value / attributesA.maxValue,
				             attributesB.maxValue == 0 and 0 or attributesB.value / attributesB.maxValue
				if a ~= b then
					return (a or 0)*order < (b or 0)*order
				end
			end)
		end
	end)

	Processor:RegisterDogTag("TMW", "Value", {
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			local value = icon and icon.attributes.value or 0
			
			return isNumber[value] or value
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("VALUE"),
		ret = "number",
		doc = L["DT_DOC_Value"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[Value] => "256891"; [Value(icon="TMW:icon:1I7MnrXDCz8T")] => "2"',
		category = L["ICON"],
	})
		
	Processor:RegisterDogTag("TMW", "ValueMax", {
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			local maxValue = icon and icon.attributes.maxValue or 0
			
			return isNumber[maxValue] or maxValue
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("VALUE"),
		ret = "number",
		doc = L["DT_DOC_ValueMax"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[ValueMax] => "312856"; [ValueMax(icon="TMW:icon:1I7MnrXDCz8T")] => "3"',
		category = L["ICON"],
	})
end






-- STACK: "stack, stackText"
do
	local Processor = TMW.Classes.IconDataProcessor:New("STACK", "stack, stackText")

	function Processor:CompileFunctionSegment(t)
		--GLOBALS: stack, stackText
		t[#t+1] = [[
		if attributes.stack ~= stack or attributes.stackText ~= stackText then
			local old = attributes.stack
			attributes.stack = stack
			attributes.stackText = stackText

			if EventHandlersSet.OnStack then
				icon:QueueEvent("OnStack")
			end
			if (not old or (stack and stack > old)) and EventHandlersSet.OnStackIncrease then
				icon:QueueEvent("OnStackIncrease")
			elseif (not stack or (old and stack < old)) and EventHandlersSet.OnStackDecrease then
				icon:QueueEvent("OnStackDecrease")
			end

			TMW:Fire(STACK.changedEvent, icon, stack, stackText)
			doFireIconUpdated = true
		end
		--]]
	end

	Processor:RegisterIconEvent(51, "OnStack", {
		category = L["EVENT_CATEGORY_STACKS"],
		text = L["SOUND_EVENT_ONSTACK"],
		desc = L["SOUND_EVENT_ONSTACK_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = true,
			PassingCndt = true,
		},
		valueName = L["STACKS"],
		conditionChecker = function(icon, eventSettings)
			local count = icon.attributes.stack or 0
			return TMW.CompareFuncs[eventSettings.Operator](count, eventSettings.Value)
		end,
	})

	Processor:RegisterIconEvent(51.1, "OnStackIncrease", {
		category = L["EVENT_CATEGORY_STACKS"],
		text = L["SOUND_EVENT_ONSTACKINC"],
		desc = L["SOUND_EVENT_ONSTACK_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = true,
			PassingCndt = true,
		},
		valueName = L["STACKS"],
		conditionChecker = function(icon, eventSettings)
			local count = icon.attributes.stack or 0
			return TMW.CompareFuncs[eventSettings.Operator](count, eventSettings.Value)
		end,
	})

	Processor:RegisterIconEvent(51.2, "OnStackDecrease", {
		category = L["EVENT_CATEGORY_STACKS"],
		text = L["SOUND_EVENT_ONSTACKDEC"],
		desc = L["SOUND_EVENT_ONSTACK_DESC"],
		settings = {
			Operator = true,
			Value = true,
			CndtJustPassed = true,
			PassingCndt = true,
		},
		valueName = L["STACKS"],
		conditionChecker = function(icon, eventSettings)
			local count = icon.attributes.stack or 0
			return TMW.CompareFuncs[eventSettings.Operator](count, eventSettings.Value)
		end,
	})
		
	Processor:RegisterDogTag("TMW", "Stacks", {
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			local stacks = icon and icon.attributes.stackText or 0
			
			return isNumber[stacks] or stacks
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("STACK"),
		ret = "number",
		doc = L["DT_DOC_Stacks"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[Stacks] => "9"; [Stacks(icon="TMW:icon:1I7MnrXDCz8T")] => "3"',
		category = L["ICON"],
	})

	TMW:RegisterCallback("TMW_INITIALIZE", function()
		local IconPosition_Sortable = TMW.C.GroupModule_IconPosition_Sortable
		if IconPosition_Sortable then
			IconPosition_Sortable:RegisterIconSorter("stacks", {
				DefaultOrder = -1,
				[1] = L["UIPANEL_GROUPSORT_stacks_1"],
				[-1] = L["UIPANEL_GROUPSORT_stacks_-1"],
			}, function(iconA, iconB, attributesA, attributesB, order)
				local a, b = attributesA.stack or 0, attributesB.stack or 0
				if a ~= b then
					return a*order < b*order
				end
			end)
		end
	end)

	TMW:RegisterCallback("TMW_ICON_SETUP_POST", function(event, icon)
		if not TMW.Locked then
			icon:SetInfo("stack, stackText", nil, nil)
		end
	end)

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("stack, stackText", nil, nil)
	end)
end






-- TEXTURE: "texture"
do
	local Processor = TMW.Classes.IconDataProcessor:New("TEXTURE", "texture")

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: texture
		t[#t+1] = [[
		if texture ~= nil and attributes.texture ~= texture then
			attributes.texture = texture

			TMW:Fire(TEXTURE.changedEvent, icon, texture)
			doFireIconUpdated = true
		end
		--]]
	end
end






-- UNIT: "unit, GUID"
do
	local Processor = TMW.Classes.IconDataProcessor:New("UNIT", "unit, GUID")
	Processor:DeclareUpValue("UnitGUID", UnitGUID)
	Processor:DeclareUpValue("playerGUID", UnitGUID('player'))

	function Processor:CompileFunctionSegment(t)
		-- GLOBALS: unit, GUID
		t[#t+1] = [[
		
		GUID = GUID or (unit and (unit == "player" and playerGUID or UnitGUID(unit)))
		
		if attributes.unit ~= unit or attributes.GUID ~= GUID then
			local previousUnit = attributes.unit
			attributes.previousUnit = previousUnit
			attributes.unit = unit
			attributes.GUID = GUID

			if EventHandlersSet.OnUnit then
				icon:QueueEvent("OnUnit")
			end
			
			TMW:Fire(UNIT.changedEvent, icon, unit, previousUnit, GUID)
			doFireIconUpdated = true
		end
		--]]
	end

	Processor:RegisterIconEvent(41, "OnUnit", {
		category = L["EVENT_CATEGORY_CHANGED"],
		text = L["SOUND_EVENT_ONUNIT"],
		desc = L["SOUND_EVENT_ONUNIT_DESC"],
	})

	Processor:RegisterDogTag("TMW", "Unit", {
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			if icon then
				return icon.attributes.unit or ""
			else
				return ""
			end
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("UNIT"),
		ret = "string",
		doc = L["DT_DOC_Unit"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[Unit] => "target"; [Unit:Name] => "Kobold"; [Unit(icon="TMW:icon:1I7MnrXDCz8T")] => "focus"; [Unit(icon="TMW:icon:1I7MnrXDCz8T"):Name] => "Gamon"',
		category = L["ICON"],
	})
	Processor:RegisterDogTag("TMW", "PreviousUnit", {
		code = function(icon)
			icon = TMW.GUIDToOwner[icon]
			
			if icon then
				return icon.__lastUnitChecked or ""
			else
				return ""
			end
		end,
		arg = {
			'icon', 'string', '@req',
		},
		events = TMW:CreateDogTagEventString("UNIT"),
		ret = "string",
		doc = L["DT_DOC_PreviousUnit"] .. "\r\n \r\n" .. L["DT_INSERTGUID_GENERIC_DESC"],
		example = '[PreviousUnit] => "target"; [PreviousUnit:Name] => "Kobold"; [PreviousUnit(icon="TMW:icon:1I7MnrXDCz8T")] => "focus"; [PreviousUnit(icon="TMW:icon:1I7MnrXDCz8T"):Name] => "Gamon"',
		category = L["ICON"],
	})

	TMW:RegisterCallback("TMW_ICON_DISABLE", function(event, icon)
		icon:SetInfo("unit, GUID", nil, nil)
	end)
end






-- DOGTAGUNIT: "dogTagUnit"
do
	local DogTag = LibStub("LibDogTag-3.0")

		
	local Processor = TMW.Classes.IconDataProcessor:New("DOGTAGUNIT", "dogTagUnit")
	Processor:AssertDependency("UNIT")


	--Here's the hook (the whole point of this thing)

	local Hook = TMW.Classes.IconDataProcessorHook:New("UNIT_DOGTAGUNIT", "UNIT")

	Hook:DeclareUpValue("DogTag", DogTag)
	Hook:DeclareUpValue("TMW_UNITS", TMW.UNITS)

	Hook:RegisterCompileFunctionSegmentHook("post", function(Processor, t)
		-- GLOBALS: unit

		-- We shouldn't do this for meta icons.
		-- If we do, the typeData.unitType will be wrong.
		-- Instead, just let this be inherited normally from the DOGTAGUNIT processor.
		-- I don't like coupling meta icons to this, but I can't see any other way that won't require
		-- sweeping changes to the way that attribute inheriting works.
		t[#t+1] = [[
		if icon.Type ~= "meta" then
			local dogTagUnit
			local typeData = icon.typeData

			if not typeData or typeData.unitType == "unitid" then
				dogTagUnit = unit
				if not DogTag.IsLegitimateUnit[dogTagUnit] then
					dogTagUnit = dogTagUnit and TMW_UNITS:TestUnit(dogTagUnit)
					if not DogTag.IsLegitimateUnit[dogTagUnit] then
						dogTagUnit = "player"
					end
				end
			else
				dogTagUnit = "player"
			end
			
			if attributes.dogTagUnit ~= dogTagUnit then
				doFireIconUpdated = icon:SetInfo_INTERNAL("dogTagUnit", dogTagUnit) or doFireIconUpdated
			end
		end
		--]]
	end)
end


