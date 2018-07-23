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

local floor, min, max, strsub, strfind = 
	  floor, min, max, strsub, strfind
local pairs, ipairs, sort, tremove, CopyTable = 
	  pairs, ipairs, sort, tremove, CopyTable
	  
local CI = TMW.CI

-- GLOBALS: CreateFrame, NONE, NORMAL_FONT_COLOR



local EVENTS = TMW.EVENTS
local Counter = EVENTS:GetEventHandler("Counter")

Counter.handlerName = L["EVENTHANDLER_COUNTER_TAB"]
Counter.handlerDesc = L["EVENTHANDLER_COUNTER_TAB_DESC"]
--Counter.testable = false

local operations = {
	{ text = L["OPERATION_SET"], 		value = "=", },
	{ text = L["OPERATION_PLUS"], 		value = "+", },
	{ text = L["OPERATION_MINUS"], 		value = "-", },
	--{ text = L["OPERATION_MULTIPLY"], 	value = "*", },
	--{ text = L["OPERATION_DIVIDE"], 	value = "/", },
}


---------- Events ----------
function Counter:LoadSettingsForEventID(eventID)
	local eventSettings = EVENTS:GetEventSettings(eventID)

	self.ConfigContainer.Operation:SetUIDropdownText(eventSettings.CounterOperation, operations)
	
	self.ConfigContainer.Header:SetText(TMW.L["EVENTS_SETTINGS_COUNTER_HEADER"])

	self.ConfigContainer.Counter:SetText(eventSettings.Counter)
	self.ConfigContainer.Amt:SetText(eventSettings.CounterAmt)
end

function Counter:GetEventDisplayText(eventID)
	if not eventID then return end

	local eventSettings = EVENTS:GetEventSettings(eventID)


	local Counter = eventSettings.Counter
	local CounterOperation = eventSettings.CounterOperation
	local CounterAmt = eventSettings.CounterAmt

	local str = Counter .. " "
	if Counter == "" then
		str = "|cff808080<No Counter>"
	else
		str = str .. CounterOperation .. " " .. CounterAmt
	end
	
	return ("|cffcccccc" .. L["EVENTHANDLER_COUNTER_TAB"] .. ":|r " .. str)
end



local function OperationMenu_DropDown_OnClick(button, dropdown)
	dropdown:SetUIDropdownText(button.value, operations)
	
	local eventSettings = EVENTS:GetEventSettings()
	eventSettings.CounterOperation = button.value

	dropdown:OnSettingSaved()
end
function Counter.OperationMenu_DropDown(dropdown)
	for k, v in pairs(operations) do
		local info = TMW.DD:CreateInfo()
		info.func = OperationMenu_DropDown_OnClick
		info.text = v.text
		info.value = v.value
		info.checked = v.value == EVENTS:GetEventSettings().CounterOperation
		info.arg1 = dropdown
		TMW.DD:AddButton(info)
	end
end





local SUG = TMW.SUG
local Module = SUG:NewModule("counterName", SUG:GetModule("default"))
Module.noMin = true
Module.noTexture = true
Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]

function Module.Sorter_Counter(a, b)
	local special_a, special_b = strsub(a, 1, 1), strsub(b, 1, 1)
	
	local haveA, haveB = special_a ~= "%", special_b ~= "%"
	if (haveA ~= haveB) then
		return haveA
	end
	
	--sort by alphabetical
	return a < b
end

function Module:Table_GetSorter()
	return self.Sorter_Counter
end
function Module:Entry_AddToList_1(f, name)
	if name == "%A" then
		name = SUG.lastName_unmodified
	end

	f.Name:SetText(name)

	f.tooltiptitle = name

	f.insert = name
end
function Module:Table_GetNormalSuggestions(suggestions, tbl)
	local lastName = SUG.lastName


	for eventSettings in EVENTS:InIconEventSettings() do
		if eventSettings.Type == "Counter"
			and eventSettings.Counter ~= ""
			and strfind(eventSettings.Counter, lastName)
			and not TMW.tContains(suggestions, eventSettings.Counter)
		then
			suggestions[#suggestions + 1] = eventSettings.Counter
		end
	end
end

function Module:Table_GetSpecialSuggestions_1(suggestions)
	if #SUG.lastName > 0 then
		suggestions[#suggestions + 1] = "%A"
	end
end
