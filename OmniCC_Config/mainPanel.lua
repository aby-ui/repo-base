--[[
	mainPanel.lua
		the main container panel for omnicc
		provides ways of switching between tabs & groups
--]]

local L = OMNICC_LOCALS

local function createGroup(groupId)
	if OmniCC:AddGroup(groupId) then
		OmniCCOptions:SetGroupId(groupId)
	end
end

StaticPopupDialogs['OmniCC_CONFIG_CREATE_GROUP'] = {
	text = 'Enter Group Name',
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 24,
	
	OnAccept = function(self)
		local groupId = _G[self:GetName()..'EditBox']:GetText()
		if groupId ~= '' then
			createGroup(groupId)
		end
	end,
	
	EditBoxOnEnterPressed = function(self)
		local groupId = self:GetText()
		if groupId ~= '' then
			createGroup(groupId)
		end
		self:GetParent():Hide()
	end,
	
	OnShow = function(self)
		_G[self:GetName()..'EditBox']:SetFocus()
	end,
	
	OnHide = function(self)
		_G[self:GetName()..'EditBox']:SetText('')
	end,
	
	timeout = 0, exclusive = 1, hideOnEscape = 1, preferredIndex = STATICPOPUP_NUMDIALOGS
}

--[[ utility functions of champions ]]--

local function sort(...)
	table.sort(...)
	return ...
end

local function map(t, f)
	local newtbl = {}
	for i, v in pairs(t) do
		newtbl[i] = f(v)
	end
	return newtbl
end


--[[
	group settings selector
--]]

local function selectGroup(self)
	self.owner:SetSavedValue(self.value)
end

local function deleteGroup(self, groupId)
	self.owner:SetSavedValue('base')

	OmniCC:RemoveGroup(groupId)

	--hide the previous dropdown menus (hack)
	for i = 1, UIDROPDOWNMENU_MENU_LEVEL-1 do
		_G["DropDownList"..i]:Hide()
	end
end

local function addGroup(self)
	StaticPopup_Show('OmniCC_CONFIG_CREATE_GROUP')
end

local function groupSelector_Create(parent, size, onSetGroup)
	local dd =  CreateFrame('Frame', parent:GetName() .. 'GroupSelector', parent, 'UIDropDownMenuTemplate')

	dd.SetSavedValue = function(self, value)
		onSetGroup(parent, value)
	end

	dd.GetSavedValue = function(self)
		return parent.selectedGroup or 'base'
	end

	--delete button for custom groups
	local function init_levelTwo(self, level)
		local info = UIDropDownMenu_CreateInfo()
		info.text = DELETE
		info.arg1 = UIDROPDOWNMENU_MENU_VALUE
		info.func = deleteGroup
		info.owner = self
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)
	end

	local function init_levelOne(self, level)
		local groups = sort(map(OmniCC.sets.groups, function(g) return g.id end))
		
		--base group
		local info = UIDropDownMenu_CreateInfo()
		info.text = L['Group_base']
		info.value = 'base'
		info.func = selectGroup
		info.owner = self
		info.hasArrow = false
		UIDropDownMenu_AddButton(info, level)

		--custom groups (add delete button)
		for i, g in ipairs(groups) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = L['Group_' .. g] or g
			info.value = g
			info.func = selectGroup
			info.owner = self
			info.hasArrow = true
			UIDropDownMenu_AddButton(info, level)
		end

		--new group button
		local info = UIDropDownMenu_CreateInfo()
		info.text = L.AddGroup
		info.func = addGroup
		info.owner = self
		info.notCheckable = true
		UIDropDownMenu_AddButton(info, level)
	end

	UIDropDownMenu_Initialize(dd, function(self, level)
		level = level or 1
		if level == 1 then
			init_levelOne(self, level)
		else
			init_levelTwo(self, level)
		end
	end)

	UIDropDownMenu_SetWidth(dd, 120)
	UIDropDownMenu_SetSelectedValue(dd, dd:GetSavedValue())

	dd:SetPoint('TOPRIGHT', 4, -8)
	return dd
end

--[[
	title portion of the main frame
--]]

local function title_Create(parent, text, subtext, icon)
	local title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	title:SetPoint('TOPLEFT', 16, -16)

	if icon then
		title:SetFormattedText('|T%s:%d|t %s', icon, 32, name)
	else
		title:SetText(text)
	end

	if subtext then
		local subTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
		subTitle:SetPoint('BOTTOMLEFT', title, 'BOTTOMRIGHT', 4, 0)
		subTitle:SetTextColor(0.8, 0.8, 0.8)
		subTitle:SetText(subtext)
	end
end

--[[
	main frame tabs
--]]

local function tab_OnClick(self)
	local parent = self:GetParent()

	--update tab selection
	PanelTemplates_Tab_OnClick(self, parent)
	PanelTemplates_UpdateTabs(parent)

	--hide any visible panels/tabs
	for i, tab in pairs(parent.tabs) do
		if tab ~= self then
			tab.panel:Hide()
			tab.sl:Hide()
			tab.sr:Hide()
		end
	end

	--show the top of the panel texture from our tab
	self.sl:Show()
	self.sr:Show()

	--show selected tab's panel
	self.panel:Show()
end

local function tab_Create(parent, id, name, panel)
	parent.tabs = parent.tabs or {}

	local t = CreateFrame('Button', parent:GetName() .. 'Tab' .. (#parent.tabs + 1), parent, 'OptionsFrameTabButtonTemplate')
	table.insert(parent.tabs, t)

	t.panel = panel
	t.id = id
	t:SetText(name)
	t:SetScript('OnClick', tab_OnClick)

	--this is the texture that makes up the top border around the main panel area
	--its here because each tab needs one to create the illusion of the tab popping out in front of the player
	t.sl = t:CreateTexture(nil, 'BACKGROUND')
	t.sl:SetTexture([[Interface\OptionsFrame\UI-OptionsFrame-Spacer]])
	t.sl:SetPoint('BOTTOMRIGHT', t, 'BOTTOMLEFT', 11, -6)
	t.sl:SetPoint('BOTTOMLEFT', parent, 'TOPLEFT', 16, -(34 + t:GetHeight() + 7))

	t.sr = t:CreateTexture(nil, 'BACKGROUND')
	t.sr:SetTexture([[Interface\OptionsFrame\UI-OptionsFrame-Spacer]])
	t.sr:SetPoint('BOTTOMLEFT', t, 'BOTTOMRIGHT', -11, -6)
	t.sr:SetPoint('BOTTOMRIGHT', parent, 'TOPRIGHT', -16, -(34 + t:GetHeight() + 11))

	--place the new tab
	--if its the first tab, anchor to the main frame
	--if not, anchor to the right of the last tab
	local numTabs = #parent.tabs
	if numTabs > 1 then
		t:SetPoint('TOPLEFT', parent.tabs[numTabs - 1], 'TOPRIGHT', -8, 0)
		t.sl:Hide()
		t.sr:Hide()
	else
		t:SetPoint('TOPLEFT', parent, 'TOPLEFT', 12, -34)
		t.sl:Show()
		t.sr:Show()
	end
	t:SetID(numTabs)

	--adjust tab sizes and other blizzy required things
	PanelTemplates_TabResize(t, 0)
	PanelTemplates_SetNumTabs(parent, numTabs)

	--display the first tab, if its not already displayed
	PanelTemplates_SetTab(parent, 1)

	--place the panel associated with the tab
	parent.panelArea:Add(panel)

	return t
end

--[[
	main frame content area
--]]

local function panelArea_Add(self, panel)
	panel:SetParent(self)
	panel:SetAllPoints(self)

	if self:GetParent():GetCurrentPanel() == panel then
		panel:Show()
	else
		panel:Hide()
	end
end

local function panelArea_Create(parent)
	local f = CreateFrame('Frame', parent:GetName() .. '_PanelArea', parent, 'OmniCC_TabPanelTemplate')
	f:SetPoint('TOPLEFT', 4, -56)
	f:SetPoint('BOTTOMRIGHT', -4, 4)
	f.Add = panelArea_Add

	parent.panelArea = f
	return f
end

--[[
	the main frame
--]]


local function optionsPanel_GetCurrentPanel(self)
	return self.tabs[PanelTemplates_GetSelectedTab(self)].panel
end

local function optionsPanel_GetTabById(self, tabId)
	for i, tab in pairs(self.tabs) do
		if tab.id == tabId then
			return tab
		end
	end
end

local function optionsPanel_GetCurrentTab(self)
	return self.tabs[PanelTemplates_GetSelectedTab(self)]
end

local function optionsPanel_SetGroup(self, groupId)
	self.selectedGroup = groupId or 'base'
	UIDropDownMenu_SetSelectedValue(self.dropdown, groupId)
	UIDropDownMenu_SetText(self.dropdown, L['Group_' .. groupId] or groupId)

	--special handling for the base tab
	--since we don't want the user to mess with the rules tab
	if groupId == 'base' then
		--if we're on the rules tab, then move to the general tab
		if optionsPanel_GetCurrentTab(self).id == 'rules' then
			tab_OnClick(optionsPanel_GetTabById(self, 'general'))
		end

		--disable the rules tab
		local tab = optionsPanel_GetTabById(self, 'rules')
		if tab then
			PanelTemplates_DisableTab(self, tab:GetID())
		end
	else
		--enable the rules tab
		local tab = optionsPanel_GetTabById(self, 'rules')
		if tab then
			PanelTemplates_EnableTab(self, tab:GetID())
		end
	end
	
	--force the current panel to refresh
	local panel = optionsPanel_GetCurrentPanel(self)
	if panel.UpdateValues then
		panel:UpdateValues()
	end
end

local function optionsPanel_Create(title, subtitle)
	local f = OmniCC_Config
	f.GetCurrentPanel = optionsPanel_GetCurrentPanel

	title_Create(f, title, subtitle)
	f.dropdown = groupSelector_Create(f, 130, optionsPanel_SetGroup)
	panelArea_Create(f)

	return f
end



--[[ build the main options panel ]]--

local f = optionsPanel_Create('OmniCC')

OmniCCOptions.AddTab = function(self, id, name, panel)
	tab_Create(f, id, name, panel)
	optionsPanel_SetGroup(f, self:GetGroupId())
end

OmniCCOptions.GetGroupSets = function(self)
	return OmniCC:GetGroupSettings(f.selectedGroup or 'base')
end

OmniCCOptions.GetGroupId = function(self)
	return f.selectedGroup or 'base'
end

OmniCCOptions.SetGroupId = function(self, groupId)
	optionsPanel_SetGroup(f, groupId)
end