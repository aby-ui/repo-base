--[[
	MenuBar, by Goranaws
--]]

--[[ globals ]]--

local _G = _G
local hooksecurefunc = _G.hooksecurefunc
local table = _G.table
local ipairs = _G.ipairs
local pairs = _G.pairs
local LibStub = _G.LibStub
local C_StorePublic = _G.C_StorePublic

local AddonName = ...
local Addon = LibStub('AceAddon-3.0'):GetAddon(AddonName)
local MenuBar = Addon:CreateClass('Frame', Addon.ButtonBar); Addon.MenuBar = MenuBar


--[[ local constants ]]--

local MICRO_BUTTONS = {
	"CharacterMicroButton",
	"SpellbookMicroButton",
	"TalentMicroButton",
	"AchievementMicroButton",
	"QuestLogMicroButton",
	"GuildMicroButton",
	"LFDMicroButton",
	"EJMicroButton",
	"CollectionsMicroButton",
	"StoreMicroButton",
	"MainMenuMicroButton"
}

local MICRO_BUTTON_NAMES = {
	['CharacterMicroButton'] = _G['CHARACTER_BUTTON'],
	['SpellbookMicroButton'] = _G['SPELLBOOK_ABILITIES_BUTTON'],
	['TalentMicroButton'] = _G['TALENTS_BUTTON'],
	['AchievementMicroButton'] = _G['ACHIEVEMENT_BUTTON'],
	['QuestLogMicroButton'] = _G['QUESTLOG_BUTTON'],
	['GuildMicroButton'] = _G['LOOKINGFORGUILD'],
	['LFDMicroButton'] = _G['DUNGEONS_BUTTON'],
	['EJMicroButton'] = _G['ENCOUNTER_JOURNAL'],
	['MainMenuMicroButton'] = _G['MAINMENU_BUTTON'],
	['StoreMicroButton'] = _G['BLIZZARD_STORE'],
	['CollectionsMicroButton'] = _G['COLLECTIONS']
}

--[[ Menu Bar ]]--

function MenuBar:New()
	return MenuBar.proto.New(self, 'menu')
end

function MenuBar:Create(...)
	local bar = MenuBar.proto.Create(self, ...)

	bar.activeButtons = {}
	bar.overrideButtons = {}

	local getOrHook = function(frame, script, action)
		if frame:GetScript(script) then
			frame:HookScript(script, action)
		else
			frame:SetScript(script, action)
		end
	end

	local requestLayoutUpdate
	do
		local frame = Addon:CreateHiddenFrame('Frame')

		frame:SetScript('OnUpdate', function(_, elapsed)
			frame:Hide()
			bar:Layout()
		end)

		requestLayoutUpdate = function()
			frame:Show()
		end
	end

	hooksecurefunc('UpdateMicroButtons', requestLayoutUpdate)

	local petBattleFrame = _G['PetBattleFrame'].BottomFrame.MicroButtonFrame

	getOrHook(petBattleFrame, 'OnShow', function()
		bar.isPetBattleUIShown = true
		requestLayoutUpdate()
	end)

	getOrHook(petBattleFrame, 'OnHide', function()
		bar.isPetBattleUIShown = nil
		requestLayoutUpdate()
	end)


	local overrideActionBar = _G['OverrideActionBar']

	getOrHook(overrideActionBar, 'OnShow', function()
		bar.isOverrideUIShown = Addon:UsingOverrideUI()
		requestLayoutUpdate()
	end)

	getOrHook(overrideActionBar, 'OnHide', function()
		bar.isOverrideUIShown = nil
		requestLayoutUpdate()
	end)

	return bar
end

function MenuBar:GetDefaults()
	return {
		point = 'BOTTOMRIGHT',
		x = -244,
		y = 0,
	}
end

function MenuBar:GetButton(index)
	return self.activeButtons[index]
end

function MenuBar:NumButtons()
	return #self.activeButtons
end

function MenuBar:GetButtonInsets()
	local l, r, t, b = MenuBar.proto.GetButtonInsets(self)

	return l, r + 1, t + 3, b
end

function MenuBar:UpdateActiveButtons()
	table.wipe(self.activeButtons)

	for _, name in ipairs(MICRO_BUTTONS) do
		local button = _G[name]

		if not self:IsMenuButtonDisabled(button) then
			table.insert(self.activeButtons, button)
		end
	end
end

function MenuBar:UpdateOverrideBarButtons()
	table.wipe(self.overrideButtons)

	local isStoreEnabled = C_StorePublic.IsEnabled()

	for _, buttonName in ipairs(MICRO_BUTTONS) do
		local shouldAddButton

		if buttonName == 'HelpMicroButton' then
			shouldAddButton = not isStoreEnabled
		elseif buttonName == 'StoreMicroButton' then
			shouldAddButton = isStoreEnabled
		else
			shouldAddButton = true
		end

		if shouldAddButton then
			table.insert(self.overrideButtons, _G[buttonName])
		end
	end
end

function MenuBar:ReloadButtons()
	self:UpdateActiveButtons()

	MenuBar.proto.ReloadButtons(self)
end

function MenuBar:DisableMenuButton(button, disabled)
	local disabledButtons = self.sets.disabled or {}

	disabledButtons[button:GetName()] = disabled or false
	self.sets.disabled = disabledButtons

	self:ReloadButtons()
end

function MenuBar:IsMenuButtonDisabled(button)
	local disabledButtons = self.sets.disabled

	if disabledButtons then
		return disabledButtons[button:GetName()]
	end

	return false
end

function MenuBar:Layout()
	if self.isPetBattleUIShown then
		self:LayoutPetBattle()
	elseif self.isOverrideUIShown then
		self:LayoutOverrideUI()
	else
		self:LayoutNormal()
	end
end

function MenuBar:LayoutNormal()
	for _, name in pairs(MICRO_BUTTONS) do
		_G[name]:Hide()
	end

	for _, button in pairs(self.buttons) do
		button:Show()
	end

	MenuBar.proto.Layout(self)
end

function MenuBar:LayoutPetBattle()
	self:FixButtonPositions()
end

function MenuBar:LayoutOverrideUI()
	self:FixButtonPositions()
end

function MenuBar:FixButtonPositions()
	self:UpdateOverrideBarButtons()

	local l, r, t, b = self:GetButtonInsets()

	for i, button in ipairs(self.overrideButtons) do
		if i > 1 then
			button:ClearAllPoints()
			if i == 7 then
				button:SetPoint('TOPLEFT', self.overrideButtons[1], 'BOTTOMLEFT', 0, 4 + (t - b))
			else
				button:SetPoint('BOTTOMLEFT', self.overrideButtons[i - 1], 'BOTTOMRIGHT', (l - r), 0)
			end
		end

		button:Show()
	end
end

--[[ Menu Code ]]--

local function Menu_AddLayoutPanel(menu)
	local panel = menu:NewPanel(LibStub('AceLocale-3.0'):GetLocale('Dominos-Config').Layout)

	panel:NewOpacitySlider()
	panel:NewFadeSlider()
	panel:NewScaleSlider()
	panel:NewPaddingSlider()
	panel:NewSpacingSlider()
	panel:NewColumnsSlider()

	return panel
end

local function MenuButtonCheckbox_Create(panel, button, name)
	if not button then return end

	return panel:NewCheckButton{
		name = name or button:GetName(),

		get = function()
			return not panel.owner:IsMenuButtonDisabled(button)
		end,

		set = function(_, enable)
			panel.owner:DisableMenuButton(button, not enable)
		end
	}
end

local function Menu_AddDisableMenuButtonsPanel(menu)
    local l = LibStub('AceLocale-3.0'):GetLocale('Dominos-Config')
	local panel = menu:NewPanel(l.Buttons)
	local prev  = nil
	local width, height = 0, 0

	for _, buttonName in ipairs(MICRO_BUTTONS) do
		local button = MenuButtonCheckbox_Create(panel, _G[buttonName], MICRO_BUTTON_NAMES[buttonName])
		if button then
			if prev then
				button:SetPoint('TOPLEFT', prev, 'BOTTOMLEFT', 0, -2)
			else
				button:SetPoint('TOPLEFT', 0, -2)
			end

			local bWidth, bHeight = button:GetEffectiveSize()
			width = math.max(width, bWidth)
			height = height + (bHeight + 2)
			prev = button
		end
	end

	panel.width = width
	panel.height = height
	return panel
end

function MenuBar:CreateMenu()
	local menu = Addon:NewMenu(self.id)

	if menu then
		Menu_AddLayoutPanel(menu)
		Menu_AddDisableMenuButtonsPanel(menu)
		menu:AddAdvancedPanel()

		self.menu = menu
	end

	return menu
end


--[[ module ]]--

local MenuBarController = Addon:NewModule('MenuBar')

function MenuBarController:OnInitialize()

end

function MenuBarController:Load()
	self.frame = MenuBar:New()
end

function MenuBarController:Unload()
	if self.frame then
		self.frame:Free()
		self.frame = nil
	end
end
