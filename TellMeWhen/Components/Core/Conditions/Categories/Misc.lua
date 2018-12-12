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

local date = date

local CNDT = TMW.CNDT
local Env = CNDT.Env


local ConditionCategory = CNDT:GetCategory("MISC", 10, L["CNDTCAT_MISC"], false, false)

ConditionCategory:RegisterCondition(0,	 "", {
	text = L["CONDITIONPANEL_DEFAULT"],
	hidden = true,
	noslide = true,
	unit = false,
	nooperator = true,
	min = 0,
	max = 100,
	funcstr = [[true]],
	events = function()
		-- Returning false (as a string, not a boolean) won't cause responses to any events,
		-- and it also won't make the ConditionObject default to being OnUpdate driven.
		
		return "false"
	end,
})


ConditionCategory:RegisterCondition(1,	 "ICON", {
	text = L["CONDITIONPANEL_ICON"],
	tooltip = L["CONDITIONPANEL_ICON_DESC"],
	min = 0,
	max = 1,
	texttable = {
		[0] = L["CONDITIONPANEL_ICON_SHOWN"],
		[1] = L["CONDITIONPANEL_ICON_HIDDEN"],
	},
	levelChecks = true,
	
	isicon = true,
	nooperator = true,
	unit = false,
	icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c, icon)
		if c.Icon == "" or c.Icon == icon:GetGUID() then
			--return [[true]]
		end

		TMW:QueueValidityCheck(icon, c.Icon, L["VALIDITY_CONDITION_DESC"])

		local str = [[( c.Icon and c.Icon.attributes.shown and not c.Icon:Update())]]
		if c.Level == 0 then
			str = str .. [[and c.Icon.attributes.realAlpha > 0]]
		else
			str = str .. [[and c.Icon.attributes.realAlpha == 0]]
		end
		return str
	end,
	--[[events = function(ConditionObject, c)
		local event = TMW.Classes.IconDataProcessor.ProcessorsByName.REALALPHA.changedEvent
		ConditionObject:RequestEvent(event)
		ConditionObject:SetNumEventArgs(1)
		return
			"event == '" .. event .. "' and arg1:GetGUID() == " .. format("%q", c.Icon)
	end,]]
})

local function RegisterShownHiddenTimerCallback()
	TMW:RegisterCallback(TMW.Classes.IconDataProcessor.ProcessorsByName.REALALPHA.changedEvent, function(event, icon, realAlpha, oldalpha)
		if realAlpha == 0 then
			icon.__CNDT__ICONSHOWNTME = 0
			icon.__CNDT__ICONHIDDENTME = TMW.time
		elseif oldalpha == 0 then
			icon.__CNDT__ICONSHOWNTME = TMW.time
			icon.__CNDT__ICONHIDDENTME = 0
		end
	end)
	
	RegisterShownHiddenTimerCallback = TMW.NULLFUNC
end

ConditionCategory:RegisterCondition(1.2,	"ICONSHOWNTME", {
	old = true,

	text = L["CONDITIONPANEL_ICONSHOWNTIME"],
	tooltip = L["CONDITIONPANEL_ICONSHOWNTIME_DESC"],
	range = 30,
	step = 0.1,
	formatter = TMW.C.Formatter.TIME_YDHMS,
	isicon = true,
	unit = false,
	icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c, icon)
		if c.Icon == "" then
			return [[true]]
		end
		
		TMW:QueueValidityCheck(icon, c.Icon, L["VALIDITY_CONDITION_DESC"])

		RegisterShownHiddenTimerCallback()
		
		local str = [[c.Icon and c.Icon.attributes.shown and not c.Icon:Update() and c.Icon.attributes.realAlpha > 0 and time - (c.Icon.__CNDT__ICONSHOWNTME or 0) c.Operator c.Level]]
		return str
	end,
})
ConditionCategory:RegisterCondition(1.3,	"ICONHIDDENTME", {
	old = true,
	
	text = L["CONDITIONPANEL_ICONHIDDENTIME"],
	tooltip = L["CONDITIONPANEL_ICONHIDDENTIME_DESC"],
	range = 30,
	step = 0.1,
	formatter = TMW.C.Formatter.TIME_YDHMS,
	isicon = true,
	unit = false,
	icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c, icon)
		if c.Icon == "" then
			return [[true]]
		end
		
		TMW:QueueValidityCheck(icon, c.Icon, L["VALIDITY_CONDITION_DESC"])

		RegisterShownHiddenTimerCallback()
		
		local str = [[c.Icon and c.Icon.attributes.shown and not c.Icon:Update() and c.Icon.attributes.realAlpha == 0 and time - (c.Icon.__CNDT__ICONHIDDENTME or 0) c.Operator c.Level]]
		return str
	end,
})


ConditionCategory:RegisterCondition(3,	 "MOUSEOVER", {
	text = L["MOUSEOVERCONDITION"],
	tooltip = L["MOUSEOVERCONDITION_DESC"],
	
	bool = true,

	unit = false,
	icon = "Interface\\Icons\\Ability_Marksmanship",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c, parent)
		return [[BOOLCHECK( ]] .. parent:GetName() .. [[:IsMouseOver() )]]
	end,
	-- events = -- there is no good way to handle events for this condition
})



ConditionCategory:RegisterSpacer(10)




ConditionCategory:RegisterCondition(11,	 "WEEKDAY", {
	text = L["CONDITION_WEEKDAY"],
	tooltip = L["CONDITION_WEEKDAY_DESC"],
	min = 1,
	max = 7,
	texttable = function(k)
		-- July 2012 started on a sunday, so we can represent the day as (k) to get the weekday easily.
		return _G["WEEKDAY_" .. date("%A", time{year=2012, month=7, day=k, hour=0}):upper() ]
	end,
	unit = false,
	icon = "Interface\\Icons\\Spell_Nature_TimeStop",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		date = date,
	},
	funcstr = function(c, parent)
		return [[tonumber(date("%w")) + 1 c.Operator c.Level]]
	end,
	events = "false",
	anticipate = function(c)
		-- This is kinda horrible, but calculating the exact time until the day changes over takes more CPU.
		-- Just make sure the condition updates at least once per minute. That is infrequent enough to not matter at all.
		return [[VALUE = time + 60]]
	end,
})

ConditionCategory:RegisterCondition(12,	 "TIMEOFDAY", {
	text = L["CONDITION_TIMEOFDAY"],
	tooltip = L["CONDITION_TIMEOFDAY_DESC"],
	min = 0,
	max = 24*60-1,
	texttable = function(k)
		return GameTime_GetFormattedTime(floor(k/60), k%60, true)
		--return CNDT.COMMON.formatSeconds(k*60)
	end,
	unit = false,
	icon = "Interface\\Icons\\Ability_Racial_TimeIsMoney",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		GetDaysElapsedMinutes = function()
			local h, m = strsplit(" ", date("%H %M"))
			local h, m = tonumber(h), tonumber(m)
			
			return h*60 + m
		end,
	},
	funcstr = function(c, parent)
		return [[GetDaysElapsedMinutes() c.Operator c.Level]]
	end,
	events = "false",
	anticipate = function(c)
		-- This is kinda horrible, but calculating the exact time until the minute changes over takes more CPU.
		-- Just make sure the condition updates at least once per 10 seconds. That is infrequent enough to not matter at all.
		return [[VALUE = time + 10]]
	end,
})



ConditionCategory:RegisterSpacer(19.5)



ConditionCategory:RegisterCondition(21,	 "QUESTCOMPLETE", {
	text = L["CONDITION_QUESTCOMPLETE"],
	tooltip = L["CONDITION_QUESTCOMPLETE_DESC"],

	bool = true,
	
	name = function(editbox)
		editbox:SetTexts(L["CONDITION_QUESTCOMPLETE"], L["CONDITION_QUESTCOMPLETE_EB_DESC"])
		editbox:SetLabel(L["QUESTIDTOCHECK"])
	end,
	unit = false,
	icon = "Interface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon",
	Env = {
		IsQuestFlaggedCompleted = IsQuestFlaggedCompleted,
		GetQuestResetTime = GetQuestResetTime,
	},
	funcstr = function(c)
		if c.Name ~= "" then
			return [[BOOLCHECK( IsQuestFlaggedCompleted(c.NameFirst) )]]
		else
			return [[false]]
		end
	end,
	events = function(ConditionObject, c)
		return
			ConditionObject:GenerateNormalEventString("PLAYER_ENTERING_WORLD"),
			ConditionObject:GenerateNormalEventString("QUEST_FINISHED"),
			ConditionObject:GenerateNormalEventString("QUEST_LOG_UPDATE")
	end,
	anticipate = function(c)
		return [[VALUE = time + GetQuestResetTime()]]
	end,
})



ConditionCategory:RegisterSpacer(29.5)




ConditionCategory:RegisterCondition(30,	 "MACRO", {
	text = L["MACROCONDITION"],
	tooltip = L["MACROCONDITION_DESC"],
	min = 0,
	max = 1,
	nooperator = true,
	noslide = true,
	name = function(editbox)
		editbox:SetTexts(L["MACROCONDITION"], L["MACROCONDITION_EB_DESC"])
		editbox:SetLabel(L["MACROTOEVAL"])
	end,
	unit = false,
	icon = "Interface\\Icons\\inv_misc_punchcards_yellow",
	tcoords = CNDT.COMMON.standardtcoords,
	Env = {
		SecureCmdOptionParse = SecureCmdOptionParse,
	},
	funcstr = function(c)
		local text = c.Name
		text = (not strfind(text, "^%[") and ("[" .. text)) or text
		text = (not strfind(text, "%]$") and (text .. "]")) or text
		return [[SecureCmdOptionParse("]] .. text .. [[")]]
	end,
	-- events = absolutely no events
})



local Functions = {}

local function GetCompiledFunction(luaCode)
	local key
	if Functions[luaCode] then
		key = tostring(Functions[luaCode]):gsub("function: ", "LF_")
		return Functions[luaCode], key
	end
	
	local func, err = loadstring("return " .. luaCode)
	if err then
		func, err = loadstring(luaCode)
	end
	
	if func then
		setfenv(func, TMW.CNDT.Env)
		key = tostring(func):gsub("function: ", "LF_")
		Functions[luaCode] = func
		Env[key] = func
	end
	
	return func, key, err
end
ConditionCategory:RegisterCondition(31,	 "LUA", {
	text = L["LUACONDITION"],
	tooltip = L["LUACONDITION_DESC"],
	min = 0,
	max = 1,
	nooperator = true,
	noslide = true,
	unit = false,
	icon = "Interface\\Icons\\INV_Misc_Gear_01",
	tcoords = CNDT.COMMON.standardtcoords,
	funcstr = function(c, parent)
		setmetatable(CNDT.Env, CNDT.EnvMeta)

		local lua = c.Name
		if lua:find("thisobj") then
			if parent.GetName and parent:GetName() then
				if _G[parent:GetName()] == parent then
					lua = lua:gsub("thisobj", parent:GetName())
				else
					error("Error with `thisobj` substitution: _G[thisobj:GetName()] ~= thisobj for " .. parent:GetName())
				end
			else
				error("Attempted use of `thisobj` in conditions that don't support it.")
			end
		end

		if lua:find("thisunit") then
			if c.Unit and c.Unit ~= "" then
				lua = lua:gsub("thisunit", "(" .. CNDT:GetConditionUnitSubstitution(c.Unit) .. ")")
			else
				error("Attempted use of `thisunit` in conditions without units.")
			end

		end

		local func, key, err = GetCompiledFunction(lua)
		
		return func and key .. "()" or format("error(%q)", err)
	end,
})

TMW:RegisterLuaImportDetector(function(table)
	if rawget(table, "Type") == "LUA" and rawget(table, "Name") ~= "" then
		return table.Name, L["LUACONDITION2"]
	end
end)


