--[[
	general.lua
		A gui for general addon configuration settings
--]]

local AddonName, Addon = ...
local ParentAddonName, ParentAddon = GetAddOnDependencies(AddonName)
local ParentAddon = _G[ParentAddonName]
local L = LibStub('AceLocale-3.0'):GetLocale(ParentAddonName .. '-Config')

local GeneralPanel = Addon.AddonOptions:NewPanel(L.General)
do
	local lockButton = GeneralPanel:Add('Button', {
		name = L.EnterConfigMode,
		width = 136,
		height = 22,
		click = function()
			ParentAddon:ToggleLockedFrames()
			HideUIPanel(InterfaceOptionsFrame)
		end
	})
	lockButton:SetPoint('TOPLEFT', 0, -2)

	local bindButton = GeneralPanel:Add('Button', {
		name = L.EnterBindingMode,
		width = 136,
		height = 22,
		click = function()
			ParentAddon:ToggleBindingMode()
			HideUIPanel(InterfaceOptionsFrame)
		end
	})
	bindButton:SetPoint('LEFT', lockButton, 'RIGHT', 4, 0)


	--[[ General Settings ]]--

	local stickyBarsToggle = GeneralPanel:Add('CheckButton', {
		name = L.StickyBars,
		get = function() return ParentAddon:Sticky() end,
		set = function(_, enable) ParentAddon:SetSticky(enable) end
	})
	stickyBarsToggle:SetPoint('TOPLEFT', lockButton, 'BOTTOMLEFT', 0, -10)

	local linkedOpacityToggle = GeneralPanel:Add('CheckButton',{
		name = L.LinkedOpacity,
		small = true,
		get = function() return ParentAddon:IsLinkedOpacityEnabled() end,
		set = function(_, enable) ParentAddon:SetLinkedOpacity(enable) end
	})
	linkedOpacityToggle:SetPoint('TOP', stickyBarsToggle, 'BOTTOM', 8, -2)

	local showMinimapButtonToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowMinimapButton,
		get = function() return ParentAddon:ShowingMinimap() end,
		set = function(_, enable) ParentAddon:SetShowMinimap(enable) end
	})
	showMinimapButtonToggle:SetPoint('TOP', linkedOpacityToggle, 'BOTTOM', -8, -10)

	-- --[[ Action Bar Settings ]]--

	--lock action button positions
	--this option causes taint, but only for the session that the option is set in
	local lockButtonsToggle = GeneralPanel:Add('CheckButton', {
		name = L.LockActionButtons,
		get = function() return LOCK_ACTIONBAR == '1' end,
		set = function() _G['InterfaceOptionsActionBarsPanelLockActionBars']:Click() end
	})
	lockButtonsToggle:SetPoint('TOP', showMinimapButtonToggle, 'BOTTOM', 0, -10)

	--show empty buttons
	local showEmptyButtonsToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowEmptyButtons,
		get = function() return ParentAddon:ShowGrid() end,
		set = function(_, enable) ParentAddon:SetShowGrid(enable) end
	})
	showEmptyButtonsToggle:SetPoint('TOP', lockButtonsToggle, 'BOTTOM', 0, -10)

	--show keybinding text
	local showBindingsButtonToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowBindingText,
		get = function() return ParentAddon:ShowBindingText() end,
		set = function(_, enable) ParentAddon:SetShowBindingText(enable) end
	})
	showBindingsButtonToggle:SetPoint('TOP', showEmptyButtonsToggle, 'BOTTOM', 0, -10)

	--show macro text
	local showMacroTextToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowMacroText,
		get = function() return ParentAddon:ShowMacroText() end,
		set = function(_, enable) ParentAddon:SetShowMacroText(enable) end
	})
	showMacroTextToggle:SetPoint('TOP', showBindingsButtonToggle, 'BOTTOM', 0, -10)

	--show macro text
	local showCountsToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowCountText,
		get = function() return ParentAddon:ShowCounts() end,
		set = function(_, enable) ParentAddon:SetShowCounts(enable) end
	})
	showCountsToggle:SetPoint('TOP', showMacroTextToggle, 'BOTTOM', 0, -10)

	--show equipped item borders
	local showEquippedToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowEquippedItemBorders,
		get = function() return ParentAddon:ShowEquippedItemBorders() end,
		set = function(_, enable) ParentAddon:SetShowEquippedItemBorders(enable) end
	})
	showEquippedToggle:SetPoint('TOP', showCountsToggle, 'BOTTOM', 0, -10)

	--show tooltips
	local showTooltipsToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowTooltips,
		get = function() return ParentAddon:ShowTooltips() end,
		set = function(_, enable) ParentAddon:SetShowTooltips(enable) end
	})
	showTooltipsToggle:SetPoint('TOP', showEquippedToggle, 'BOTTOM', 0, -10)

	--show tooltips in combat
	local showTooltipsInCombatToggle = GeneralPanel:Add('CheckButton', {
		name = L.ShowTooltipsCombat,
		small = true,
		get = function() return ParentAddon:ShowCombatTooltips() end,
		set = function(_, enable) ParentAddon:SetShowCombatTooltips(enable) end
	})
	showTooltipsInCombatToggle:SetPoint('TOP', showTooltipsToggle, 'BOTTOM', 8, -2)

	-- theme action bttons
	local themeButtons = GeneralPanel:Add('CheckButton', {
		name = L.ThemeActionButtons,
		get = function() return ParentAddon:ThemeButtons() end,
		set = function(_, enable) ParentAddon:SetThemeButtons(enable) end
	})
	themeButtons:SetPoint('TOP', showTooltipsInCombatToggle, 'BOTTOM', -8, -10)

	--show override ui
	if ParentAddon:IsBuild("retail") then
		local useBlizzardOverrideUIToggle = GeneralPanel:Add('CheckButton', {
			name = L.ShowOverrideUI,
			get = function() return ParentAddon:UsingOverrideUI() end,
			set = function(_, enable) ParentAddon:SetUseOverrideUI(enable) end
		})
		useBlizzardOverrideUIToggle:SetPoint('TOP', themeButtons, 'BOTTOM', 0, -10)
	end

	--right click unit
	local rightClickUnitSelector = GeneralPanel:Add('Dropdown', {
		name = L.RightClickUnit,

		get = function()
			return ParentAddon:GetRightClickUnit() or 'NONE'
		end,

		set = function(_, value)
			ParentAddon:SetRightClickUnit(value ~= 'NONE' and value or nil)
		end,

		items = {
			{text = L.RCUPlayer, value = 'player'},
			{text = L.RCUFocus, value = 'focus'},
			{text = L.RCUToT, value = 'targettarget'},
			{text = NONE_KEY, value = 'NONE'},
		}
	})

	rightClickUnitSelector:SetPoint('TOP', lockButton, 'BOTTOM', 0, -10)
	rightClickUnitSelector:SetPoint('RIGHT')

	--right click unit
	local possessBarSelector = GeneralPanel:Add('Dropdown', {
		name = L.PossessBar,

		get = function()
			local bar = ParentAddon:GetOverrideBar()

			return bar and bar.id or 1
		end,

		set = function(_, value)
			ParentAddon:SetOverrideBar(value)
		end,

		items = function()
			local items = {}

			for i = 1, ParentAddon:NumBars() do
				table.insert(items, { text = ('Action Bar %d'):format(i), value = i })
			end

			return items
		end
	})

	possessBarSelector:SetPoint('TOP', rightClickUnitSelector, 'BOTTOM', 0, -10)
end
