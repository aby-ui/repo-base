--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName, addon = ...
local L = addon.L

--<GLOBALS
local _G = _G
local CLOSE = _G.CLOSE
local CreateFrame = _G.CreateFrame
local format = _G.format
local ipairs = _G.ipairs
local pairs = _G.pairs
local tinsert = _G.tinsert
local ToggleDropDownMenu = _G.ToggleDropDownMenu
local tsort = _G.table.sort
local UIDropDownMenu_AddButton = _G.UIDropDownMenu_AddButton
local wipe = _G.wipe
--GLOBALS>

local SplitSectionKey = addon.SplitSectionKey

local mod = addon:NewModule('SectionVisibilityDropdown', 'ABEvent-1.0')
mod.uiName = L['Section visibility button']
mod.uiDesc = L['Add a dropdown menu to bags that allow to hide the sections.']

local buttons = {}
local frame
local Button_OnClick

function mod:OnEnable()
	addon:HookBagFrameCreation(self, 'OnBagFrameCreated')
	for button in pairs(buttons) do
		button:Show()
	end
end

function mod:OnDisable()
	for button in pairs(buttons) do
		button:Hide()
	end
end

function mod:OnBagFrameCreated(bag)
	local container = bag:GetFrame()
	local button = container:CreateModuleButton("V", 5, Button_OnClick, {
		L["Section visibility"],
		L["Click to select which sections should be shown or hidden. Section visibility is common to all bags."]
	})
	button.container = container
	buttons[button] = true
end

local function CollapseDropDownMenu_ToggleSection(button, key, container)
	local section = container.sections[key]
	if section then
		section:SetCollapsed(not section:IsCollapsed())
	else
		addon.db.char.collapsedSections[key] = not addon.db.char.collapsedSections[key]
		mod:SendMessage('AdiBags_LayoutChanged')
	end
end

local info = {}
local function CollapseDropDownMenu_Initialize(self, level)
	if not level then return end

	-- Title
	wipe(info)
	info.isTitle = true
	info.text = L['Section visibility']
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, level)

	-- Add an entry for each section
	local currentCat = nil
	wipe(info)
	for key, section, name, category, title, visible in self.container:IterateSections(true) do
		info.text = title
		info.isNotRadio = true
		info.tooltipTitle = format(L['Show %s'], name)
		info.tooltipText = L['Check this to show this section. Uncheck to hide it.']
		info.checked = not addon.db.char.collapsedSections[key]
		info.keepShownOnClick = true
		info.arg1 = key
		info.arg2 = self.container
		info.func = CollapseDropDownMenu_ToggleSection
		UIDropDownMenu_AddButton(info, level)
	end

	-- Add menu close entry
	wipe(info)
	info.text = CLOSE
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, level)
end

function Button_OnClick(button, buttonDown)
	if buttonDown == "RightButton" then
		return addon:OpenOptions()
	end
	if not frame then
		frame = CreateFrame("Frame", addonName.."CollapseDropDownMenu")
		frame.displayMode = "MENU"
		frame.initialize = CollapseDropDownMenu_Initialize
		frame.point = "BOTTOMRIGHT"
		frame.relativePoint = "BOTTOMLEFT"
	end
	frame.container = button.container
	ToggleDropDownMenu(1, nil, frame, 'cursor')
end
