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

local CI = TMW.CI
local get = TMW.get

local _G = _G
local pairs, ipairs, wipe, tinsert, tremove, rawget, tonumber, tostring, type = 
	  pairs, ipairs, wipe, tinsert, tremove, rawget, tonumber, tostring, type
local strtrim, gsub, min, max = 
	  strtrim, gsub, min, max



TMW.HELP:NewCode("CNDT_UNIT_MISSING", 10, false)
TMW.HELP:NewCode("CNDT_UNIT_ONLYONE", 20, false)


local CNDT = TMW.CNDT -- created in TellMeWhen/conditions.lua


--TODO: there needs to be a way for condition config to intelligently run a setup on a parent object using the current ConditionSet.
--TODO: try to get rid of all manual calls to LoadConfig (on other TMW modules too), and have these functions only be called from ReloadRequsted.



---------- Interface/Data ----------
function CNDT:LoadConfig(conditionSetName)
	local ConditionSet
	if conditionSetName then
		ConditionSet = CNDT.ConditionSets[conditionSetName]
	else
		ConditionSet = CNDT.CurrentConditionSet
	end
	
	CNDT.CurrentConditionSet = ConditionSet
	if not ConditionSet then return end
	
	if ConditionSet.useDynamicTab then
		if conditionSetName then
			TMW.IE:RefreshTabs()
		
			-- Only click the tab if we are manually loading the conditionSet (should only happen on user input/hardware event)
			CNDT.DynamicConditionTab:Click()			
		end
	else
		TMW.IE:RefreshTabs()
	end
	
	
	if not CNDT:GetSettings() then
		return
	end
	
	
	TMW.HELP:Hide("CNDT_UNIT_MISSING")
	
	local n = CNDT:GetSettings().n
	
	for i = n + 1, #CNDT do
		CNDT[i]:Hide()
	end
		
	if n > 0 then
		-- We create an extra so we can anchor the AddCondition button to it.
		CNDT:CreateGroups(n+1)

		for i in TMW:InNLengthTable(CNDT:GetSettings()) do
			CNDT[i]:Show()
			CNDT[i]:RequestReload()
		end
	end
	
	local AddCondition = TellMeWhen_IconEditor.Pages.Conditions.Groups.AddCondition
	AddCondition:SetPoint("TOPLEFT", CNDT[n+1])
	AddCondition:SetPoint("TOPRIGHT", CNDT[n+1])
	
	CNDT:ColorizeParentheses()
end

function CNDT:GetSettings()
	if not CNDT.CurrentConditionSet then
		return nil
	end

	return CNDT.CurrentConditionSet:GetSettings()
end

-- Dynamic Conditions Tab handling

CNDT.DynamicConditionTab = TMW.IE:RegisterTab("ICON", "CNDTDYN", "Conditions", 25)

CNDT.DynamicConditionTab.ShouldShowTab = function(self)
	local ConditionSet = CNDT.CurrentConditionSet

	if ConditionSet
	and ConditionSet.useDynamicTab
	and ConditionSet.ShouldShowTab
	and ConditionSet:ShouldShowTab() then
		return true
	end

	return false
end

TMW:RegisterCallback("TMW_CONFIG_ICON_LOADED_CHANGED", function(event, icon)
	if TMW.IE.CurrentTab == CNDT.DynamicConditionTab then
		TMW.IE.TabGroups.ICON.MAIN:Click()
	end
end)

TMW:RegisterCallback("TMW_CONFIG_TAB_CLICKED", function(event, currentTab, oldTab)
	if oldTab == CNDT.DynamicConditionTab and currentTab ~= CNDT.DynamicConditionTab then
		CNDT.CurrentConditionSet = nil
		TMW.IE:RefreshTabs()
	end
end)



function CNDT:GetTabText(conditionSetName)
	local ConditionSet = CNDT.CurrentConditionSet
	if conditionSetName then
		ConditionSet = CNDT.ConditionSets[conditionSetName]
	end
	
	if not ConditionSet then
		return "<ERROR: SET NOT FOUND!>"
	end
	
	local Conditions = ConditionSet:GetSettings()
	local tabText = ConditionSet.tabText
	
	if not Conditions then
		return tabText .. ": 0"
	end
	
	local parenthesesAreValid, errorMessage = CNDT:CheckParentheses(Conditions)
		
	if parenthesesAreValid then
		TMW.HELP:Hide("CNDT_PARENTHESES_ERROR")
	else
		TMW.HELP:Show{
			code = "CNDT_PARENTHESES_ERROR",
			icon = nil,
			relativeTo = TellMeWhen_IconEditor.Pages.Conditions,
			x = 0,
			y = 0,
			text = format(errorMessage)
		}
	end
	
	local n = Conditions.n

	if n > 0 then
		local prefix = (not parenthesesAreValid and "|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t|cFFFF0000" or "")
		return prefix .. tabText .. ": |cFFFF5959" .. n
	else
		return tabText .. ": 0"
	end
end

function CNDT:SetTabText(conditionSetName)
	local ConditionSet = CNDT.ConditionSets[conditionSetName] or CNDT.CurrentConditionSet
	
	local tab = ConditionSet.useDynamicTab and CNDT.DynamicConditionTab or ConditionSet:GetTab()
	
	tab:SetText(CNDT:GetTabText(conditionSetName))
	TMW:TT(tab, ConditionSet.tabText, ConditionSet.tabTooltip, 1, 1)
end






---------- Dropdowns ----------
local function TypeMenu_DropDown_OnClick(button, dropdown, conditionData)
	local CndtGroup = dropdown:GetParent()

	CndtGroup:SelectType(conditionData)
end
local function AddConditionToDropDown(dropdown, conditionData)
	local CndtGroup = dropdown:GetParent()
	local conditionSettings = CndtGroup:GetSettingTable()

	local append = TMW.debug and not conditionData:ShouldList() and "(DBG)" or ""
	
	local info = TMW.DD:CreateInfo()
	
	local text = get(conditionData.text)
	info.func = TypeMenu_DropDown_OnClick
	info.text = (text or "??") .. append
	
	info.tooltipTitle = text
	info.tooltipText = get(conditionData.tooltip)
	
	info.value = conditionData.identifier
	info.arg1 = dropdown
	info.arg2 = conditionData
	info.icon = get(conditionData.icon)
	info.atlas = get(conditionData.atlas)

	info.disabled = get(conditionData.disabled)

	info.checked = conditionData.identifier == conditionSettings.Type
	
	if conditionData.tcoords then
		info.tCoordLeft = conditionData.tcoords[1]
		info.tCoordRight = conditionData.tcoords[2]
		info.tCoordTop = conditionData.tcoords[3]
		info.tCoordBottom = conditionData.tcoords[4]
	end
	
	TMW.DD:AddButton(info)
end

function CNDT.TypeMenu_DropDown(dropdown)
	if TMW.DD.MENU_LEVEL == 1 then
		local canAddSpacer
		for k, categoryData in ipairs(CNDT.Categories) do
			
			if categoryData.spaceBefore and canAddSpacer then
				TMW.DD:AddSpacer()
			end

			local shouldAddCategory
			local CurrentConditionSet = CNDT.CurrentConditionSet
			
			for k, conditionData in ipairs(categoryData.conditionData) do
				if not conditionData.IS_SPACER then
					local shouldAdd = conditionData:ShouldList()
					
					if shouldAdd then
						shouldAddCategory = true
						break
					end
				end
			end
			
			local info = TMW.DD:CreateInfo()
			info.text = categoryData.name
			info.value = categoryData.identifier
			info.notCheckable = true
			info.hasArrow = shouldAddCategory
			info.disabled = not shouldAddCategory
			TMW.DD:AddButton(info)
			canAddSpacer = true
			
			if categoryData.spaceAfter and canAddSpacer then
				TMW.DD:AddSpacer()
				canAddSpacer = false
			end
		end
		
	elseif TMW.DD.MENU_LEVEL == 2 then
		local categoryData = CNDT.CategoriesByID[TMW.DD.MENU_VALUE]
		
		local queueSpacer
		local hasAddedOneCondition
		local lastButtonWasSpacer

		local conditionSettings = dropdown:GetSettingTable()
		
		local CurrentConditionSet = CNDT.CurrentConditionSet
		
		for k, conditionData in ipairs(categoryData.conditionData) do
			if conditionData.IS_SPACER then
				queueSpacer = true
			else
				local selected = conditionData.identifier == conditionSettings.Type
				local shouldAdd = selected or conditionData:ShouldList() --or TMW.debug
				
				if shouldAdd then
					if hasAddedOneCondition and queueSpacer then
						TMW.DD:AddSpacer()
						queueSpacer = false
					end
					
					AddConditionToDropDown(dropdown, conditionData)
					hasAddedOneCondition = true
				end
			end
		end
	end
end



local function IconMenu_DropDown_OnClick(button, dropdown)
	local icon = button.value
	local GUID = icon:GetGUID(true)

	local conditionSettings = dropdown:GetSettingTable()
	conditionSettings.Icon = GUID

	dropdown:OnSettingSaved()

	TMW.DD:CloseDropDownMenus()
end
function CNDT.IconMenu_DropDown(dropdown)
	if TMW.DD.MENU_LEVEL == 2 then
		local conditionSettings = dropdown:GetSettingTable()

		for icon in TMW.DD.MENU_VALUE:InIcons() do
			if icon:IsValid() then
				local info = TMW.DD:CreateInfo()

				local text, textshort, tooltip = icon:GetIconMenuText()
				info.text = textshort
				info.tooltipTitle = text
				info.tooltipText = tooltip

				info.arg1 = dropdown
				info.value = icon
				info.func = IconMenu_DropDown_OnClick

				info.checked = conditionSettings.Icon == icon:GetGUID()

				info.tCoordLeft = 0.07
				info.tCoordRight = 0.93
				info.tCoordTop = 0.07
				info.tCoordBottom = 0.93
				info.icon = icon.attributes.texture

				TMW.DD:AddButton(info)
			end
		end

	elseif TMW.DD.MENU_LEVEL == 1 then
		for group in TMW:InGroups() do
			if group:ShouldUpdateIcons() then
				local info = TMW.DD:CreateInfo()

				info.text = group:GetGroupName()
				info.hasArrow = true
				info.notCheckable = true
				info.value = group

				TMW.DD:AddButton(info)
			end
		end
	end
end

local function OperatorMenu_DropDown_OnClick(button, dropdown)
	local conditionSettings = dropdown:GetSettingTable()
	conditionSettings.Operator = button.value

	dropdown:OnSettingSaved()
end
function CNDT.OperatorMenu_DropDown(dropdown)
	local CndtGroup = dropdown:GetParent()
	local conditionData = CndtGroup:GetConditionData()
	local conditionSettings = CndtGroup:GetSettingTable()

	for k, v in pairs(TMW.operators) do
		if (not conditionData.specificOperators or conditionData.specificOperators[v.value]) then
			local info = TMW.DD:CreateInfo()
			info.func = OperatorMenu_DropDown_OnClick
			info.text = v.text .. strrep("  ", 2 - #v.text) .. "    " .. v.tooltipText
			info.value = v.value
			info.font = "Interface/Addons/TellMeWhen/Fonts/OpenSans-Regular.ttf"
			info.checked = conditionSettings.Operator == v.value
			info.tooltipTitle = v.tooltipText
			info.arg1 = dropdown
			TMW.DD:AddButton(info)
		end
	end
end

local function BitFlags_DropDown_OnClick(button, dropdown)
	local conditionSettings = dropdown:GetSettingTable()

	local index = button.value

	CNDT:ToggleBitFlag(conditionSettings, index)

	dropdown:OnSettingSaved()
end
function CNDT.BitFlags_DropDown(dropdown)
	local CndtGroup = dropdown:GetParent()
	local conditionData = CndtGroup:GetConditionData()
	local conditionSettings = CndtGroup:GetSettingTable()

	for index, data in CNDT:InBitflags(conditionData.bitFlags) do
		local info = TMW.DD:CreateInfo()

		if type(data) == "table" then
			info.text = data.text
			info.tooltipTitle = data.text
			info.tooltipText = data.tooltip

			info.icon = data.icon
			info.atlas = data.atlas
			if data.tcoords then
				info.tCoordLeft = data.tcoords[1]
				info.tCoordRight = data.tcoords[2]
				info.tCoordTop = data.tcoords[3]
				info.tCoordBottom = data.tcoords[4]
			end
		else
			info.text = data
		end

		info.value = index
		info.checked = CNDT:GetBitFlag(conditionSettings, index)
		info.keepShownOnClick = true
		info.isNotRadio = true
		info.func = BitFlags_DropDown_OnClick
		info.arg1 = dropdown

		TMW.DD:AddButton(info)

		if type(data) == "table" and data.space then
			TMW.DD:AddSpacer()
		end
	end
end




function CNDT:InBitflags(bitFlags)
	local tableValues = type(select(2, next(bitFlags))) == "table"
	return TMW:OrderedPairs(bitFlags, tableValues and TMW.OrderSort or nil, tableValues)
end



---------- Parentheses ----------
local parenthesisColors = setmetatable(
	{ -- hardcode the first few colors to make sure they look good
		"|cff00ff00",
		--"|cff0026ff",
		"|cffff004d",
		"|cff009bff",
		"|cffe9ff00",
		--"|cff00ff7c",
		"|cffff6700",
		"|cffaf79ff",
		"|cffff00c2",
	},
	{ __index = function(t, k)
		-- start reusing colors
		if k < 1 then return "" end
		while k >= #t do
			k = k - #t
		end
		return rawget(t, k) or ""
end})

function CNDT:ColorizeParentheses()
	if not TellMeWhen_IconEditor.Pages.Conditions:IsShown() then return end

	CNDT.Parens = wipe(CNDT.Parens or {})

	for k, v in ipairs(CNDT) do
		if v:IsShown() then
			if v.OpenParenthesis:IsShown() then
				for k, v in ipairs(v.OpenParenthesis.parens) do
					v.text:SetText("|cff222222" .. v.type)
					if v:GetChecked() then
						tinsert(CNDT.Parens, v)
					end
				end
			end

			if v.CloseParenthesis:IsShown() then
				for k = #v.CloseParenthesis.parens, 1, -1 do
					local v = v.CloseParenthesis.parens[k]
					v.text:SetText("|cff222222" .. v.type)
					if v:GetChecked() then
						tinsert(CNDT.Parens, v)
					end
				end
			end
		end
	end

	while true do
		local numopen, nestinglevel, open, currentcolor = 0, 0
		for i, v in ipairs(CNDT.Parens) do
			if v == true then
				nestinglevel = nestinglevel + 1
			elseif v == false then
				nestinglevel = nestinglevel - 1
			elseif v.type == "(" then
				numopen = numopen + 1
				nestinglevel = nestinglevel + 1
				if not open then
					open = i
					CNDT.Parens[open].text:SetText(parenthesisColors[nestinglevel] .. "(")
					currentcolor = nestinglevel
				end
			else
				numopen = numopen - 1
				nestinglevel = nestinglevel - 1
				if open and numopen == 0 then
					CNDT.Parens[i].text:SetText(parenthesisColors[currentcolor] .. ")")
					CNDT.Parens[i] = false
					break
				end
			end
		end
		if open then
			CNDT.Parens[open] = true
		else
			break
		end
	end
	for i, v in ipairs(CNDT.Parens) do
		if type(v) == "table" then
			v.text:SetText(v.type)
		end
	end

	CNDT:SetTabText()
end

TMW:NewClass("Config_Conditions_Paren", "Config_CheckButton") {
	OnNewInstance_Paren = function(self)
		local parent = self:GetParent()
		parent.parens = parent.parens or {}

		self.text:SetFont("Interface/Addons/TellMeWhen/Fonts/OpenSans-Regular.ttf", 16, "THINOUTLINE")

		parent.parens[self:GetID()] = self

		if self:GetID() == 1 then
			self:Show()
		end

		self.type = parent.parenType

		self.text:SetText(self.type)
	end,

	GetNext = function(self)
		local parent = self:GetParent()
		local paren = parent.parens[self:GetID() + 1]

		if paren then
			return paren
		elseif self:GetID() < 13 then
			paren = CreateFrame("CheckButton", nil, parent, "TellMeWhen_ConditionEditorParenthesisTemplate", self:GetID() + 1)
			parent.parens[self:GetID() + 1] = paren

			paren:SetPoint(parent.childPoint, self, parent.childRelativePoint, parent.childXOffs, 0)
			paren:SetChecked(false)

			return paren
		end

	end,

	METHOD_EXTENSIONS  = {
		SetChecked = function(self, checked)
			local parent = self:GetParent()

			if checked then
				local nextParen = self:GetNext()
				if nextParen then
					nextParen:Show()
				end
			else
				for i = self:GetID() + 1, #parent.parens do
					parent.parens[i]:SetChecked(false)
					parent.parens[i]:Hide()
				end
			end
		end,
	},

	OnClick = function(self)
		TMW:ClickSound()

		TMW.HELP:Hide("CNDT_PARENTHESES_FIRSTSEE")

		self:SetChecked(self:GetChecked())
		
		local n = 0
		if self:GetParent():IsShown() then
			for k, frame in ipairs(self:GetParent().parens) do
				if frame:GetChecked() then
					n = n + 1
				end
			end
		end
		
		local settings = self:GetSettingTable()

		if self.type == "(" then
			settings.PrtsBefore = n
		else
			settings.PrtsAfter = n
		end

		self:OnSettingSaved()

		TMW.CNDT:ColorizeParentheses()
	end,

	OnEnter = function(self)
		self.text:SetText(gsub(self.text:GetText(), "|cff%x%x%x%x%x%x", "|cffffffff"))
	end,

	OnLeave = function(self)
		TMW.CNDT:ColorizeParentheses()
	end,
}


---------- Condition Groups ----------
function CNDT:CreateGroups(num)
	local start = #CNDT + 1

	for i=start, num do
		TMW.Classes.CndtGroup:New("Frame", "TellMeWhen_IconEditorConditionsGroupsGroup" .. i, TellMeWhen_IconEditor.Pages.Conditions.Groups, "TellMeWhen_ConditionGroup", i)
	end
end

function CNDT:AddCondition(Conditions)
	Conditions.n = Conditions.n + 1
	
	TMW:Fire("TMW_CNDT_CONDITION_ADDED", Conditions[Conditions.n])
	
	return Conditions[Conditions.n]
end

function CNDT:DeleteCondition(Conditions, n)
	TMW.DD:CloseDropDownMenus()
	TMW.IE:SaveSettings()

	Conditions.n = Conditions.n - 1
	
	TMW:Fire("TMW_CNDT_CONDITION_DELETED", n)
	
	return tremove(Conditions, n)
end


---------- CndtGroup Class ----------
local CndtGroup = TMW:NewClass("CndtGroup", "Config_Frame")

function CndtGroup:OnNewInstance()
	local ID = self:GetID()
	CNDT[ID] = self

	if ID > 1 then
		self:SetPoint("TOP", CNDT[ID-1], "BOTTOM", 0, -20)
	end
	self:Hide()

	self:SetMinAdjustHeight(68)
	self:SetAdjustHeightExclusion(self.OpenParenthesis, true)
	self:SetAdjustHeightExclusion(self.CloseParenthesis, true)
	self:SetAdjustHeightExclusion(self.AndOr, true)


	self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)
	self:CScriptAdd("ReloadRequested", self.LoadAndDraw)
end

function CndtGroup:SettingTableRequested()
	local settings = CNDT:GetSettings()
	if settings and self:GetID() <= settings.n then
		return settings[self:GetID()]
	end

	-- Needed to stop propagation of the CScript.
	return false
end

function CndtGroup:LoadAndDraw()
	local conditionData = self:GetConditionData()
	local conditionSettings = self:GetSettingTable()

	self.prevRowFrame = self.Type

	if conditionSettings then
		TMW:Fire("TMW_CNDT_GROUP_DRAWGROUP", self, conditionData, conditionSettings)
	end

	self:AdjustHeight(5)
end

function CndtGroup:AddRow(child, yOffs)
	child:SetPoint("TOP", self.prevRowFrame, "BOTTOM", 0, yOffs or -10)

	self.prevRowFrame = child
end

function CndtGroup:UpOrDown(delta)
	local ID = self:GetID()
	local settings = CNDT:GetSettings()

	local curdata = settings[ID]
	local destinationdata = settings[ID+delta]

	settings[ID] = destinationdata
	settings[ID+delta] = curdata

	CNDT:LoadConfig()
end

function CndtGroup:DeleteHandler()
	CNDT:DeleteCondition(CNDT:GetSettings(), self:GetID())
	CNDT:LoadConfig()
end

function CndtGroup:GetConditionData()
	local conditionSettings = self:GetSettingTable()
	if conditionSettings then
		return CNDT.ConditionsByType[conditionSettings.Type]
	end
end

function CndtGroup:SelectType(conditionData)
	local conditionSettings = self:GetSettingTable()

	if conditionData.defaultUnit and conditionSettings.Unit == "player" then
		conditionSettings.Unit = conditionData.defaultUnit
	end

	get(conditionData.applyDefaults, conditionData, conditionSettings)

	if conditionSettings.Type ~= conditionData.identifier then
		conditionSettings.Type = conditionData.identifier

		-- wipe this, since flags mean totally different things for different conditions.
		-- and having some flags set that a condition doesn't know about could screw things up.
		conditionSettings.BitFlags = 0
	end
	
	self:OnSettingSaved()
	
	TMW.DD:CloseDropDownMenus()
end

function CndtGroup:OnSizeChanged()
	self:AdjustHeight(5)
end


-- LoadAndDraw handlers:
-- Unit
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	
	CndtGroup.Unit:Hide()
	CndtGroup.TextUnitDef:SetText(nil)
	CndtGroup.Unit:SetWidth(120)

	if conditionData then
		local unit = conditionData.unit
	
		if unit == nil then
			-- Normal unit input and configuration
			CndtGroup.Unit:Show()
			
			-- Reset suggestion list module. This might get modified by unit conditions.
			TMW.SUG:EnableEditBox(CndtGroup.Unit, "units", true)
			
		elseif unit == false then
			-- No unit, keep editbox and static text hidden
			
		elseif type(unit) == "string" then
			-- Static text in place of the editbox			
			CndtGroup.TextUnitDef:SetText(unit)
		end
	end
end)

-- Type
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	CndtGroup.Type:Show()


	local text = conditionData and get(conditionData.text) or conditionSettings.Type
	local tooltip = conditionData and get(conditionData.tooltip)

	if not conditionData or conditionData.identifier ~= "" then
		CndtGroup.Type.EditBox:SetText(text)
		CndtGroup.Type.EditBox:SetCursorPosition(0)
	else
		CndtGroup.Type.EditBox:SetText("")
	end

	TMW:TT(CndtGroup.Type, text, tooltip, 1, 1)
	TMW:TT(CndtGroup.Type.EditBox, text, tooltip, 1, 1)
end)

-- Operator
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	if not conditionData or conditionData.nooperator then
		CndtGroup.Operator:Hide()
	else
		CndtGroup.Operator:Show()

		local v = CndtGroup.Operator:SetUIDropdownText(conditionSettings.Operator, TMW.operators)
		if v then
			TMW:TT(CndtGroup.Operator, v.tooltipText, nil, 1)
		end
	end
end)

-- Icon
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)

	if conditionData and conditionData.isicon then
		local GUID = conditionSettings.Icon
		CndtGroup.Icon:SetGUID(GUID)

		CndtGroup.Icon:Show()
		if conditionData.nooperator then
			CndtGroup.Icon:SetWidth(196)
		else
			CndtGroup.Icon:SetWidth(134)
		end
	else
		CndtGroup.Icon:Hide()
	end
end)

-- Parentheses
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)

	for k, paren in ipairs(CndtGroup.OpenParenthesis.parens) do
		paren:SetChecked(conditionSettings.PrtsBefore >= k)
	end
	for k, paren in ipairs(CndtGroup.CloseParenthesis.parens) do
		paren:SetChecked(conditionSettings.PrtsAfter >= k)
	end
	
	if CNDT:GetSettings().n >= 3 then
		CndtGroup.CloseParenthesis:Show()
		CndtGroup.OpenParenthesis:Show()
	else
		CndtGroup.CloseParenthesis:Hide()
		CndtGroup.OpenParenthesis:Hide()
	end
	
	if CndtGroup:GetID() == 3 and CndtGroup:IsVisible() then
		TMW.HELP:Show{
			code = "CNDT_PARENTHESES_FIRSTSEE",
			icon = nil,
			relativeTo = CNDT[1].OpenParenthesis,
			x = 0,
			y = 0,
			text = format(TMW.L["HELP_CNDT_PARENTHESES_FIRSTSEE"])
		}
	end
end)
TMW.HELP:NewCode("CNDT_PARENTHESES_FIRSTSEE", 101, true)

-- Up/Down
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)

	local ID = CndtGroup:GetID()
	local numConditions = CNDT:GetSettings().n
	
	CndtGroup.Up:SetEnabled(ID ~= 1)
	CndtGroup.Down:SetEnabled(ID ~= numConditions)
end)

-- And/Or
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	if CndtGroup:GetID() == 2 and CndtGroup:IsVisible() then
		TMW.HELP:Show{
			code = "CNDT_ANDOR_FIRSTSEE",
			icon = nil,
			relativeTo = CndtGroup.AndOr,
			x = 0,
			y = 0,
			text = format(TMW.L["HELP_CNDT_ANDOR_FIRSTSEE"])
		}
	end
end)
TMW.HELP:NewCode("CNDT_ANDOR_FIRSTSEE", 100, true)

-- Editboxes and checks
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	if conditionData then
		CndtGroup.EditBox:SetPoint("RIGHT", -15, 0)

		for _, suffix in TMW:Vararg("", "2") do
			local EditBox = CndtGroup["EditBox" .. suffix]
			local Check = CndtGroup["Check" .. suffix]

			local dataName = conditionData["name" .. suffix]
			local dataCheck = conditionData["check" .. suffix]

			TMW.SUG:DisableEditBox(EditBox)
			Check:Hide()

			if dataName then
				EditBox:Show()
				EditBox:SetLabel(nil)
				EditBox:SetTooltip(nil, nil)
			
				if type(dataName) == "function" then
					dataName(EditBox)
					EditBox:UpdateLabel()
				end

				if dataCheck then
					Check:Show()
					Check:SetLabel(nil)
					Check:SetTooltip(nil, nil)
					dataCheck(Check)

					CndtGroup.EditBox:SetPoint("RIGHT", CndtGroup.Operator)
				end

				TMW.SUG:EnableEditBox(EditBox, conditionData.useSUG, not conditionData.allowMultipleSUGEntires)

				CndtGroup:AddRow(EditBox)
			else
				EditBox:Hide()
			end
		end		
	else
		CndtGroup.Check:Hide()
		CndtGroup.EditBox:Hide()
		CndtGroup.Check2:Hide()
		CndtGroup.EditBox2:Hide()
	end		
end)

-- Slider
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	CndtGroup.LevelChecks:Hide()
	CndtGroup.ValText:Hide()

	if conditionData then
		if conditionData.noslide then
			CndtGroup.Slider:Hide()
			CndtGroup.LevelChecks:Hide()

		else
			local step = get(conditionData.step) or 1
			local min = get(conditionData.min) or 0
			local max = get(conditionData.max)
			local range = get(conditionData.range)

			-- Constrain the level to the min/max/step of the condition.
			local level = conditionSettings.Level
			if max and level > max then
				conditionSettings.Level = max
			elseif level < min then
				conditionSettings.Level = min
			else
				-- If we just set the value to the min or the max, the step can't possibly be wrong,
				-- so we only need to check the step for error if the level was already within min/max.
				local stepErrorAmount = conditionSettings.Level % step

				-- If the step error amount is greater than half the step
				-- (ie it is closer to the next value than the previous value),
				-- we should round up instead of down.
				if stepErrorAmount > step/2 then
					stepErrorAmount = -(step - stepErrorAmount)
				end

				conditionSettings.Level = conditionSettings.Level - stepErrorAmount
			end

			if conditionData.levelChecks then
				local LevelChecks = CndtGroup.LevelChecks

				CndtGroup.Slider:Hide()
				LevelChecks:Show()

				CndtGroup:AddRow(LevelChecks, -7)

				if step ~= 1 then
					error("levelChecks doesn't support value steps that arent 1")
				end

				local frameID = 0
				for level = min, max do
					frameID = frameID + 1
					local frame = LevelChecks.frames[frameID]
					if not frame then
						frame = TMW.C.Config_CheckButton:New("CheckButton", nil, LevelChecks, "TellMeWhen_CheckTemplate", frameID)
						LevelChecks.frames[frameID] = frame
						frame:SetPoint("TOP", 0, 5)
					end

					frame:SetSetting("Level", level)
					local text = conditionData.formatter:Format(level)
					frame:SetTexts(text, nil)
					frame:SetLabel(text)
					frame:Show()
				end
				for i = frameID + 1, #LevelChecks.frames do
					LevelChecks.frames[i]:Hide()
				end

				TMW.IE:DistributeCheckAnchorsEvenly(LevelChecks, unpack(LevelChecks.frames, 1, frameID))
			else
				CndtGroup.LevelChecks:Hide()
				CndtGroup.Slider:Show()


				-- Don't try and format text while changing parameters because we might get some errors trying
				-- to format unexpected values
				CndtGroup.Slider:SetTextFormatter(nil)
				if range then
					CndtGroup.Slider:SetMode(CndtGroup.Slider.MODE_ADJUSTING)
					CndtGroup.Slider:SetRange(range)
				else
					CndtGroup.Slider:SetMode(CndtGroup.Slider.MODE_STATIC)
				end

				CndtGroup.Slider:SetValueStep(step)
				CndtGroup.Slider:SetMinMaxValues(min, max)

				CndtGroup.Slider:SetWidth(522)
				CndtGroup:AddRow(CndtGroup.Slider, -7)

				CndtGroup.Slider:SetTextFormatter(conditionData.formatter)
			end

			local val = conditionSettings.Level
			conditionData.formatter:SetFormattedText(CndtGroup.ValText, val)
			CndtGroup.ValText:Show()
		end

	else
		CndtGroup.Slider:Hide()
	end
end)

-- BitFlags dropdown
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)

	if conditionData and conditionData.bitFlags then
		CndtGroup.BitFlags:Show()
		CndtGroup.BitFlagsCheck:Show()
		CndtGroup.BitFlagsSelectedText:Show()

		CndtGroup.BitFlagsCheck:SetChecked(conditionSettings.Checked)
		CndtGroup.BitFlags:SetText(conditionData.bitFlagTitle or L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_VALUES"])

		CndtGroup.BitFlags:ClearAllPoints()
		if CndtGroup.Unit:IsShown() then
			CndtGroup.BitFlags:SetPoint("LEFT", CndtGroup.Unit, "RIGHT", 8, 0)
			CndtGroup.BitFlags:SetWidth(150)
			CndtGroup.Unit:SetWidth(90)
		else
			CndtGroup.BitFlags:SetPoint("TOPLEFT", CndtGroup.Type, "TOPRIGHT", 15, 0)
			CndtGroup.BitFlags:SetWidth(190)
		end

		-- Auto switch to a table if there are too many options for numeric bit flags.
		if type(conditionSettings.BitFlags) == "number" then

			if conditionData:UsesTabularBitflags() then
				CNDT:ConvertBitFlagsToTable(conditionSettings, conditionData)
			end
		end

		local text = ""
		for index, data in CNDT:InBitflags(conditionData.bitFlags) do
			local name = get(data, "text")
			local flagSet = CNDT:GetBitFlag(conditionSettings, index)

			if flagSet then
				if conditionSettings.Checked then
					local Not = L["CONDITIONPANEL_BITFLAGS_NOT"]
					if text ~= "" then
						Not = Not:lower()
					end

					name = Not .. " " .. name
				end

				if text == "" then
					text = name
				else
					text = text .. ", " .. name
				end
			end
		end

		local operator = conditionSettings.Checked and L["CONDITIONPANEL_AND"] or L["CONDITIONPANEL_OR"]
		text = text:gsub(", ([^,]*)$", ", " .. operator:lower() .. " %1")

		if text == "" then
			if conditionSettings.Checked then
				text = L["CONDITIONPANEL_BITFLAGS_ALWAYS"]
			else
				text = L["CONDITIONPANEL_BITFLAGS_NEVER"]
			end
			text = "<|cffaaaaaa" .. text .. "|r>"
		end
		CndtGroup.BitFlagsSelectedText:SetText(L["CONDITIONPANEL_BITFLAGS_SELECTED"] .. " " .. text)

		CndtGroup:AddRow(CndtGroup.BitFlagsSelectedText)
	else
		CndtGroup.BitFlags:Hide()
		CndtGroup.BitFlagsCheck:Hide()
		CndtGroup.BitFlagsSelectedText:Hide()
	end

end)

-- Deprecated/Unknown
TMW:RegisterCallback("TMW_CNDT_GROUP_DRAWGROUP", function(event, CndtGroup, conditionData, conditionSettings)
	CndtGroup.Unknown:SetText()
	CndtGroup.Deprecated:Hide()

	if conditionData then
		local text

		if conditionData.funcstr == "DEPRECATED" then
			if conditionData.customDeprecated then
				text = conditionData.customDeprecated(conditionSettings)
			else
				text = TMW.L["CNDT_DEPRECATED_DESC"]:format(get(conditionData.text))
			end
		elseif conditionData.customDeprecated then
			text = conditionData.customDeprecated(conditionSettings)
		end

		if text and text ~= "" then
			CndtGroup.Deprecated:SetText(text)
			CndtGroup.Deprecated:Show()

			CndtGroup:AddRow(CndtGroup.Deprecated)
		end
	else
		CndtGroup.Unknown:SetFormattedText(TMW.L["CNDT_UNKNOWN_DESC"], conditionSettings.Type)
	end
end)


TMW:NewClass("Config_Conditions_AndOr", "Config_Button") {
	value = nil,

	OnNewInstance = function(self)
		self:SetValue("AND")
	end,

	SetValue = function(self, value)
		local AND, OR = L["CONDITIONPANEL_AND"], L["CONDITIONPANEL_OR"]
		local GRAY = "|cff222222"
		local SLASH = "/"
		local WHITE = "|r"

		local text

		if value == "AND" then
			text = WHITE .. AND .. GRAY .. SLASH .. OR
		elseif value == "OR" then
			text = GRAY .. AND .. SLASH .. WHITE .. OR
		else
			error("Invalid value to Config_Conditions_AndOr")
		end

		self.text:SetText(text)
		self.value = value
		self:SetWidth(self.text:GetWidth())
	end,

	GetValue = function(self)
		return self.value
	end,

	OnClick = function(self)
		TMW:ClickSound()

		TMW.HELP:Hide("CNDT_ANDOR_FIRSTSEE")
		
		if self.value == "AND" then
			self:SetValue("OR")
		elseif self.value == "OR" then
			self:SetValue("AND")
		else
			error("Old value of Config_Conditions_AndOr was invalid")
		end

		local settings = self:GetSettingTable()

		if settings and self.setting then
			settings[self.setting] = self:GetValue()

			self:OnSettingSaved()
		end
	end,

	ReloadSetting = function(self)
		local settings = self:GetSettingTable()

		if settings and self.setting then
			self:SetValue(settings[self.setting])
		end
	end,
}








local SUG = TMW.SUG
local strfindsug = SUG.strfindsug

local Module = SUG:NewModule("conditions", SUG:GetModule("default"), "AceEvent-3.0")

Module.showColorHelp = false
Module.helpText = L["SUG_TOOLTIPTITLE_GENERIC"]

function Module:Table_Get()
	return CNDT.ConditionsByType
end

function Module.Sorter_ByName(a, b)
	local nameA, nameB = get(CNDT.ConditionsByType[a].text), get(CNDT.ConditionsByType[b].text)
	if nameA == nameB then
		--sort identical names by ID
		return a < b
	else
		--sort by name
		return nameA < nameB
	end
end

function Module:Table_GetSorter()
	return self.Sorter_ByName
end

function Module:Table_GetNormalSuggestions(suggestions, tbl)
	for identifier, conditionData in pairs(tbl) do
		local text = get(conditionData.text)
		text = text and text:lower()
		if conditionData:ShouldList() and text and (strfindsug(text) or strfind(text, SUG.lastName)) then
			suggestions[#suggestions + 1] = identifier
		end
	end
end

function Module:Entry_AddToList_1(f, identifier)
	local conditionData = CNDT.ConditionsByType[identifier]

	f.Name:SetText(get(conditionData.text))

	f.insert = identifier

	f.tooltiptitle = get(conditionData.text)
	f.tooltiptext = conditionData.category.name
	if conditionData.tooltip then
		f.tooltiptext = f.tooltiptext .. "\r\n\r\n" .. get(conditionData.tooltip)
	end

	if conditionData.atlas then
		f.Icon:SetAtlas(get(conditionData.atlas))
	else
		f.Icon:SetTexture(get(conditionData.icon))
	end
	if conditionData.tcoords then
		f.Icon:SetTexCoord(unpack(conditionData.tcoords))
	end
end

function Module:Entry_OnClick(frame, button)
	local CndtGroup = SUG.Box:GetParent():GetParent()

	CndtGroup:SelectType(CNDT.ConditionsByType[frame.insert])
	
	SUG.Box:ClearFocus()
end

