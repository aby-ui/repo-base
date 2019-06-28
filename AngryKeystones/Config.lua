local ADDON, Addon = ...
local Config = Addon:NewModule('Config')

local configVersion = 1
local configDefaults = {
	progressTooltip = true,
	progressFormat = 3,
	autoGossip = true,
	silverGoldTimer = false,
	splitsFormat = 1,
	completionMessage = true,
	smallAffixes = true,
	deathTracker = true,
	recordSplits = false,
	showLevelModifier = false,
	hideTalkingHead = true,
	resetPopup = false,
	announceKeystones = true,
}
local callbacks = {}

local My_UIDropDownMenu_SetSelectedValue, My_UIDropDownMenu_GetSelectedValue, My_UIDropDownMenu_CreateInfo, My_UIDropDownMenu_AddButton, My_UIDropDownMenu_Initialize, My_UIDropDownMenuTemplate
function Config:InitializeDropdown()
	My_UIDropDownMenu_SetSelectedValue = Lib_UIDropDownMenu_SetSelectedValue or UIDropDownMenu_SetSelectedValue
	My_UIDropDownMenu_GetSelectedValue = Lib_UIDropDownMenu_GetSelectedValue or UIDropDownMenu_GetSelectedValue
	My_UIDropDownMenu_CreateInfo = Lib_UIDropDownMenu_CreateInfo or UIDropDownMenu_CreateInfo
	My_UIDropDownMenu_AddButton = Lib_UIDropDownMenu_AddButton or UIDropDownMenu_AddButton
	My_UIDropDownMenu_Initialize = Lib_UIDropDownMenu_Initialize or UIDropDownMenu_Initialize
	My_UIDropDownMenuTemplate = Lib_UIDropDownMenu_Initialize and "Lib_UIDropDownMenuTemplate" or "UIDropDownMenuTemplate"
end

local progressFormatValues = { 1, 2, 3, 4, 5, 6 }
local splitsFormatValues = { 0, 1, 2 }

setmetatable(Config, {
	__index = function(self, key)
		if configDefaults[key] ~= nil then
			return self:Get(key)
		else
			return Addon.ModulePrototype[key]
		end
	end,
	-- __newindex = function(self, key, value)
	-- 	if configDefaults[key] ~= nil then
	-- 		self:Set(key, value)
	-- 	else
	-- 		self[key] = value
	-- 	end
	-- end,
})

function Config:Get(key)
	if self:CharacterConfig() then
		if AngryKeystones_CharacterConfig == nil or AngryKeystones_CharacterConfig[key] == nil then
			return configDefaults[key]
		else
			return AngryKeystones_CharacterConfig[key]
		end
	else
		if AngryKeystones_Config == nil or AngryKeystones_Config[key] == nil then
			return configDefaults[key]
		else
			return AngryKeystones_Config[key]
		end
	end
end

function Config:Set(key, newValue, silent)
	if self:CharacterConfig() then
		if configDefaults[key] == newValue then
			AngryKeystones_CharacterConfig[key] = nil
		else
			AngryKeystones_CharacterConfig[key] = newValue
		end
	else
		if configDefaults[key] == newValue then
			AngryKeystones_Config[key] = nil
		else
			AngryKeystones_Config[key] = newValue
		end
	end
	if callbacks[key] and not silent then
		for _, func in ipairs(callbacks[key]) do
			func(key, newValue)
		end
	end
end

function Config:RegisterCallback(key, func)
	if type(key) == "table" then
		for _, key2 in ipairs(key) do
			if callbacks[key2] then
				table.insert(callbacks, func)
			else
				callbacks[key2] = { func }
			end
		end
	else
		if callbacks[key] then
			table.insert(callbacks, func)
		else
			callbacks[key] = { func }
		end
	end
end

function Config:UnregisterCallback(key, func)
	if callbacks[key] then
		local table = callbacks[key]
		for i=1, #table do
			if table[i] == func then
				table.remove(table, 1)
				i = i - 1
			end
		end
		if #table == 0 then callbacks[key] = nil end
	end
end

function Config:CharacterConfig()
	return AngryKeystones_CharacterConfig and AngryKeystones_CharacterConfig['__enabled']
end

function Config:SetCharacterConfig(enabled)
	AngryKeystones_CharacterConfig['__enabled'] = enabled
	if not AngryKeystones_CharacterConfig['__init'] then
		AngryKeystones_CharacterConfig['__init'] = true
		for key,value in pairs(AngryKeystones_Config) do
			AngryKeystones_CharacterConfig[key] = value
		end
	end
end

local panelOriginalConfig = {}
local optionPanel

local Panel_OnRefresh

local function Panel_OnSave(self)
	wipe(panelOriginalConfig)
end

local function Panel_OnCancel(self)
	-- for key, value in pairs(panelOriginalConfig) do
	-- 	if key == "disabledFilters" then AngryKeystones_Config["selectedFilters"] = nil end
	-- 	Config:Set(key, value)
	-- end
	wipe(panelOriginalConfig)
end

local function Panel_OnDefaults(self)
	AngryKeystones_Config = { __version = configVersion }
	for key,callbacks_key in pairs(callbacks) do
		for _, func in ipairs(callbacks_key) do
			func(key, configDefaults[key])
		end
	end
	wipe(panelOriginalConfig)
end

local function CheckBox_Update(self)
	self:SetChecked( Config:Get(self.configKey) )
end

local function CheckBox_OnClick(self)
	local key = self.configKey
	if panelOriginalConfig[key] == nil then
		panelOriginalConfig[key] = Config[key]
	end
	Config:Set(key, self:GetChecked())
end

local function CharConfigCheckBox_OnClick(self)
	local status = Config:CharacterConfig()
	Config:SetCharacterConfig( not status )

	for key,callbacks_key in pairs(callbacks) do
		for _, func in ipairs(callbacks_key) do
			func(key, Config:Get(key))
		end
	end
	Panel_OnRefresh(optionPanel)
end

local function DropDown_OnClick(self, dropdown)
	local key = dropdown.configKey
	if panelOriginalConfig[key] == nil then
		panelOriginalConfig[key] = Config[key]
	end
	Config:Set(key, self.value)
	My_UIDropDownMenu_SetSelectedValue( dropdown, self.value )
end

local function DropDown_Initialize(self)
	local key = self.configKey
	local selectedValue = My_UIDropDownMenu_GetSelectedValue(self)
	local info = My_UIDropDownMenu_CreateInfo()
	info.func = DropDown_OnClick
	info.arg1 = self

	if key == 'progressFormat' then
		for i, value in ipairs(progressFormatValues) do
			info.text = Addon.Locale['config_progressFormat_'..i]
			info.value = value
			if ( selectedValue == info.value ) then
				info.checked = 1
			else
				info.checked = nil
			end
			My_UIDropDownMenu_AddButton(info)
		end
	elseif key == 'splitsFormat' then
		for i, value in ipairs(splitsFormatValues) do
			info.text = Addon.Locale['config_splitsFormat_'..i]
			info.value = value
			if ( selectedValue == info.value ) then
				info.checked = 1
			else
				info.checked = nil
			end
			My_UIDropDownMenu_AddButton(info)
		end
	end
end

local DropDown_Index = 0
local function DropDown_Create(self)
	DropDown_Index = DropDown_Index + 1
	local dropdown = CreateFrame("Frame", ADDON.."ConfigDropDown"..DropDown_Index, self, My_UIDropDownMenuTemplate)
	_G[ADDON.."ConfigDropDown"..DropDown_Index.."Middle"]:SetWidth(200)
	
	local label = dropdown:CreateFontString(ADDON.."ConfigDropLabel"..DropDown_Index, "BACKGROUND", "GameFontNormal")
	label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 16, 3)
	dropdown.Label = label
	
	return dropdown
end

local panelInit, checkboxes, dropdowns, charConfigCheckbox
Panel_OnRefresh = function(self)
	if not panelInit then
		local footer = self:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
		footer:SetPoint('BOTTOMRIGHT', -16, 16)
		footer:SetText( Addon.Version or "Dev" )

		charConfigCheckbox = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
		charConfigCheckbox:SetScript("OnClick", CharConfigCheckBox_OnClick)
		charConfigCheckbox.Text:SetFontObject("GameFontHighlightSmall")
		charConfigCheckbox.Text:SetPoint("LEFT", charConfigCheckbox, "RIGHT", 0, 1)
		charConfigCheckbox.Text:SetText( Addon.Locale.config_characterConfig )
		charConfigCheckbox:SetPoint("BOTTOMLEFT", 14, 12)

		local label = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
		label:SetPoint("TOPLEFT", 16, -16)
		label:SetJustifyH("LEFT")
		label:SetJustifyV("TOP")
		label:SetText( Addon.Name )

		checkboxes = {}
		dropdowns = {}

		local checkboxes_order = { "silverGoldTimer", "autoGossip", "progressTooltip", "completionMessage", "hideTalkingHead", "resetPopup", "announceKeystones" }

		for i,key in ipairs(checkboxes_order) do
			checkboxes[i] = CreateFrame("CheckButton", nil, self, "InterfaceOptionsCheckButtonTemplate")
			checkboxes[i]:SetScript("OnClick", CheckBox_OnClick)
			checkboxes[i].configKey = key
			checkboxes[i].Text:SetText( Addon.Locale['config_'..key] )
			if i == 1 then
				checkboxes[i]:SetPoint("TOPLEFT", label, "BOTTOMLEFT", -2, -8)
			else
				checkboxes[i]:SetPoint("TOPLEFT", checkboxes[i-1], "BOTTOMLEFT", 0, -8)
			end
		end

		local dropdowns_order = { "progressFormat", "splitsFormat" }

		for i,key in ipairs(dropdowns_order) do
			dropdowns[i] = DropDown_Create(self)
			dropdowns[i].Label:SetText( Addon.Locale['config_'..key] )
			dropdowns[i].configKey = key		
			if i == 1 then
				dropdowns[i]:SetPoint("TOPLEFT", checkboxes[#checkboxes], "BOTTOMLEFT", -13, -24)
			else
				dropdowns[i]:SetPoint("TOPLEFT", dropdowns[i-1], "BOTTOMLEFT", 0, -24)
			end
		end

		panelInit = true
	end
	
	charConfigCheckbox:SetChecked( Config:CharacterConfig() )
	
	for _, check in ipairs(checkboxes) do
		CheckBox_Update(check)
	end

	for _, dropdown in ipairs(dropdowns) do
		My_UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
		My_UIDropDownMenu_SetSelectedValue(dropdown, Config:Get(dropdown.configKey))
	end

end

function Config:CreatePanel()
	self:InitializeDropdown()
	local panel = CreateFrame("FRAME")
	panel.name = Addon.Name
	panel.okay = Panel_OnSave
	panel.cancel = Panel_OnCancel
	panel.default  = Panel_OnDefaults
	panel.refresh  = Panel_OnRefresh
	InterfaceOptions_AddCategory(panel)

	return panel
end

function Config:BeforeStartup()
	if AngryKeystones_Config == nil then AngryKeystones_Config = {} end
	if AngryKeystones_CharacterConfig == nil then AngryKeystones_CharacterConfig = {} end

	if not AngryKeystones_Config['__version'] then
		AngryKeystones_Config['__version'] = configVersion
	end
	if not AngryKeystones_CharacterConfig['__version'] then
		AngryKeystones_CharacterConfig['__version'] = configVersion
	end

	AngryKeystones_Config['__version'] = configVersion
	AngryKeystones_CharacterConfig['__version'] = configVersion

	optionPanel = self:CreatePanel(ADDON)
end

SLASH_AngryKeystones1 = "/akeys"
SLASH_AngryKeystones2 = "/angrykeystones"
function SlashCmdList.AngryKeystones(msg, editbox)
	if optionPanel then
		InterfaceOptionsFrame_OpenToCategory(optionPanel)
		InterfaceOptionsFrame_OpenToCategory(optionPanel)
	end
end
