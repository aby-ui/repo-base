--[[
	mainPanel.lua
		the main container panel for omnicc
		provides ways of switching between tabs & groups
--]]

local L = _G.OMNICC_LOCALS

StaticPopupDialogs['OmniCC_CONFIG_CREATE_GROUP'] = {
	text = 'Enter Group Name',
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 24,

	OnAccept = function(self)
		local groupId = _G[self:GetName()..'EditBox']:GetText()
		if groupId ~= '' then
			OmniCCOptions:AddGroup(groupId)
		end
	end,

	EditBoxOnEnterPressed = function(self)
		local groupId = self:GetText()
		if groupId ~= '' then
			OmniCCOptions:AddGroup(groupId)
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

--[[
	group settings selector
--]]

local function groupSelector_Create(parent)
	local f = CreateFrame('Frame', nil, parent)

	local title = f:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	title:SetPoint('LEFT')
	title:SetText(_G.GROUP)
	f.title = title

	local picker = _G.OmniCCOptions.Dropdown:New{
		parent = parent,

		get = function()
			return OmniCCOptions:GetGroupId()
		end,

		set = function(self, value)
			OmniCCOptions:SetGroupId(value)
		end,

		items = function()
			local t = {
				{ value = "base", text = L['Group_base'] }
			}

			for _, v in ipairs(_G.OmniCC.sets.groups) do
				tinsert(t, { value = v.id, text = v.id })
			end

			return t
		end
	}
	f.picker = picker

	local add = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	add:SetText(_G.ADD)
	add:SetWidth(add:GetTextWidth() + 16)
	add:SetScript('OnClick', function() StaticPopup_Show('OmniCC_CONFIG_CREATE_GROUP') end)
	f.add = add

	local remove = CreateFrame('Button', nil, f, 'UIPanelButtonTemplate')
	remove:SetText(_G.REMOVE)
	remove:SetWidth(remove:GetTextWidth() + 16)
	remove:SetScript('OnClick', function()
		OmniCCOptions:RemoveGroup(OmniCCOptions:GetGroupId())
	end)
	f.remove = remove

	f.Refresh = function(self)
		picker:UpdateText()

		if OmniCCOptions:GetGroupId() == "base" then
			remove:Disable()
		else
			remove:Enable()
		end
	end

	local width, height = 0, 0
	local prev
	for i, frame in ipairs{ title, add, remove, picker } do
		if i == 1 then
			frame:SetPoint("LEFT", f, 0, 0)
			width = width + frame:GetWidth()
			height = max(height, frame:GetHeight())
		else
			frame:SetPoint("LEFT", prev, "RIGHT", 2, 0)
			width = width + frame:GetWidth() + 2
			height = max(height, frame:GetHeight())
		end
		prev = frame
	end

	f:SetSize(width, height)
	f:SetScript('OnShow', f.Refresh)

	return f
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

local function optionsPanel_Create(name)
	local f = CreateFrame('Frame', 'OmniCC_Config', InterfaceOptionsFrame)
	f.name = name

	f.GetCurrentPanel = optionsPanel_GetCurrentPanel

	local title = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText(name)
	f.title = title

	local selector = groupSelector_Create(f)
	selector:SetPoint('TOPRIGHT', -8, -8)
	f.selector = selector

	panelArea_Create(f)

	InterfaceOptions_AddCategory(f)
	return f
end


--[[ build the main options panel ]]--

do
	local f = optionsPanel_Create('OmniCC')

	OmniCCOptions.AddTab = function(self, id, name, panel)
		tab_Create(f, id, name, panel)
		optionsPanel_SetGroup(f, self:GetGroupId())
	end

	OmniCCOptions.GetGroupSets = function(self)
		return OmniCC:GetGroupSettings(f.selectedGroup or 'base')
	end

	OmniCCOptions.AddGroup = function(self, groupId)
		if OmniCC:AddGroup(groupId) then
			self:SetGroupId(groupId)
		end
	end

	OmniCCOptions.RemoveGroup = function(self, groupId)
		if groupId and groupId ~= "base" then
			self.SetGroupId('base')
			OmniCC:RemoveGroup(groupId)
		end
	end

	OmniCCOptions.GetGroupId = function(self)
		return f.selectedGroup or 'base'
	end

	OmniCCOptions.SetGroupId = function(self, groupId)
		optionsPanel_SetGroup(f, groupId)
		f.selector:Refresh()
	end

	OmniCC.ShowOptionsMenu = function()
		InterfaceOptionsFrame:Show()
		InterfaceOptionsFrame_OpenToCategory(f)
	end
end