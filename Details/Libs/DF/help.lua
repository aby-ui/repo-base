

local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

local _
local _rawset = rawset --> lua local
local _rawget = rawget --> lua local

local APIHelpFunctions = false
local HelpMetaFunctions = {}

	local get_members_function_index = {}

	HelpMetaFunctions.__index = function (_table, _member_requested)

		local func = get_members_function_index [_member_requested]
		if (func) then
			return func (_table, _member_requested)
		end
		
		local fromMe = _rawget (_table, _member_requested)
		if (fromMe) then
			return fromMe
		end
		
		return HelpMetaFunctions [_member_requested]
	end
	
	local set_members_function_index = {}
	
	HelpMetaFunctions.__newindex = function (_table, _key, _value)
		local func = set_members_function_index [_key]
		if (func) then
			return func (_table, _value)
		else
			return _rawset (_table, _key, _value)
		end
	end
	
function HelpMetaFunctions:AddHelp (width, height, x, y, buttonX, buttonY, text, anchor)
	self.helpTable [#self.helpTable + 1] = {
		HighLightBox = {x = x, y = y, width = width, height = height},
		ButtonPos = { x = buttonX, y = buttonY},
		ToolTipDir = anchor or "RIGHT",
		ToolTipText = text
	}
end

function HelpMetaFunctions:SetPoint (v1, v2, v3, v4, v5)
	v1, v2, v3, v4, v5 = DF:CheckPoints (v1, v2, v3, v4, v5, self)
	if (not v1) then
		print ("Invalid parameter for SetPoint")
		return
	end
	return self.widget:SetPoint (v1, v2, v3, v4, v5)
end

function HelpMetaFunctions:ShowHelp()
	if (not HelpPlate_IsShowing (self.helpTable)) then
		HelpPlate_Show (self.helpTable, self.frame, self.button, true)
	else
		HelpPlate_Hide (true)
	end
end

local nameCounter = 1
function DF:NewHelp (parent, width, height, x, y, buttonWidth, buttonHeight, name)

	local help = {}
	
	if (parent.dframework) then
		parent = parent.widget
	end	
	
	local helpButton = CreateFrame ("button", name or "DetailsFrameworkHelpButton"..nameCounter, parent, "MainHelpPlateButton")
	nameCounter = nameCounter + 1
	
	if (not APIHelpFunctions) then
		APIHelpFunctions = true
		local idx = getmetatable (helpButton).__index
		for funcName, funcAddress in pairs (idx) do 
			if (not HelpMetaFunctions [funcName]) then
				HelpMetaFunctions [funcName] = function (object, ...)
					local x = loadstring ( "return _G."..object.button:GetName()..":"..funcName.."(...)")
					return x (...)
				end
			end
		end
	end	
	
	if (buttonWidth and buttonHeight) then
		helpButton:SetWidth (buttonWidth)
		helpButton:SetHeight (buttonHeight)
		helpButton.I:SetWidth (buttonWidth*0.8)
		helpButton.I:SetHeight (buttonHeight*0.8)
		helpButton.Ring:SetWidth (buttonWidth)
		helpButton.Ring:SetHeight (buttonHeight)
		helpButton.Ring:SetPoint ("center", buttonWidth*.2, -buttonWidth*.2)
	end
	
	help.helpTable = {
		FramePos = {x = x, y = y},
		FrameSize = {width = width, height = height}
	}
	
	help.frame = parent
	help.button = helpButton
	help.widget = helpButton
	help.I = helpButton.I
	help.Ring = helpButton.Ring
	
	helpButton:SetScript ("OnClick", function() 
		help:ShowHelp()
	end)

	setmetatable (help, HelpMetaFunctions)
	
	return help
	
end
