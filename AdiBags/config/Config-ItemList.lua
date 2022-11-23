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

local addonName = "AdiBags"
local addon = LibStub('AceAddon-3.0'):GetAddon(addonName)
local L = addon.L

--<GLOBALS
local _G = _G
local ClearCursor = _G.ClearCursor
local CreateFrame = _G.CreateFrame
local GameTooltip = _G.GameTooltip
local GetCursorInfo = _G.GetCursorInfo
local GetItemInfo = _G.GetItemInfo
local pairs = _G.pairs
local PickupItem = _G.PickupItem
local PlaySound = _G.PlaySound
local tinsert = _G.tinsert
local tonumber = _G.tonumber
local tsort = _G.table.sort
local UIParent = _G.UIParent
local wipe = _G.wipe
--GLOBALS>

local AceGUI = LibStub("AceGUI-3.0")

--------------------------------------------------------------------------------
-- Item list element
--------------------------------------------------------------------------------

do
	local Type, Version = "ItemListElement", 1

	local function Button_OnClick(frame, ...)
		AceGUI:ClearFocus()
		local widget = frame.obj
		local listWidget = widget:GetUserData('listwidget')
		if not listWidget then return end
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
		local previousId = widget.itemId
		if previousId then
			listWidget:Fire("OnValueChanged", previousId, false)
		end
		local kind, newId = GetCursorInfo()
		if kind == "item" and tonumber(newId) then
			listWidget:Fire("OnValueChanged", newId, true)
			if previousId then
				PickupItem(previousId)
			else
				ClearCursor()
			end
		end
	end

	local function Button_OnDragStart(frame)
		local widget = frame.obj
		local listWidget = widget:GetUserData('listwidget')
		if not listWidget or not widget.itemId then return end
		PickupItem(widget.itemId)
		listWidget:Fire("OnValueChanged", widget.itemId, false)
	end

	local function Button_OnEnter(frame)
		local listWidget = frame.obj:GetUserData('listwidget')
		if listWidget then
			listWidget:Fire("OnEnter")
			if frame.obj.itemId then
				local _, link = GetItemInfo(frame.obj.itemId)
				if link then
					GameTooltip:AddLine(link)
				end
				GameTooltip:AddLine(L["Click or drag this item to remove it."], 1, 1, 1)
			else
				GameTooltip:AddLine(L["Drop an item there to add it to the list."], 1, 1, 1)
			end
			GameTooltip:Show()
		end
	end

	local function Button_OnLeave(frame)
		local listWidget = frame.obj:GetUserData('listwidget')
		if listWidget then
			listWidget:Fire("OnLeave")
		end
	end

	local methods = {}

	function methods:OnAcquire()
		self:SetWidth(24)
		self:SetHeight(24)
	end

	function methods:OnRelease()
		self:SetUserData('listwidget', nil)
	end

	function methods:SetDisabled(disabled)
		if disabled then
			self.frame:Disable()
		else
			self.frame:Enable()
		end
	end

	function methods:SetItemId(itemId)
		self.itemId = itemId
		if itemId then
			local _, _, _, _, _, _, _, _, _, texture = GetItemInfo(itemId)
			self.frame:SetNormalTexture(texture or [[Interface\\Icons\\INV_Misc_QuestionMark]])
			self.frame:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
		else
			self.frame:SetNormalTexture([[Interface\Buttons\UI-Slot-Background]])
			self.frame:GetNormalTexture():SetTexCoord(0, 41/64, 0, 41/64)
		end
	end

	local function Constructor()
		local name = "AceGUI30ItemListElement" .. AceGUI:GetNextWidgetNum(Type)
		local frame = CreateFrame("Button", name, UIParent)
		frame:Hide()

		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton", "RightButton")
		frame:SetScript("OnClick", Button_OnClick)
		frame:SetScript("OnReceiveDrag", Button_OnClick)
		frame:SetScript("OnDragStart", Button_OnDragStart)
		frame:SetScript("OnEnter", Button_OnEnter)
		frame:SetScript("OnLeave", Button_OnLeave)

		frame:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]], "ADD")

		local widget = {
			frame = frame,
			type  = Type
		}
		for method, func in pairs(methods) do
			widget[method] = func
		end

		return AceGUI:RegisterAsWidget(widget)
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

--------------------------------------------------------------------------------
-- Item list
--------------------------------------------------------------------------------

do
	local Type, Version = "ItemList", 1

	local methods = {}

	function methods:SetMultiselect(flag)
		-- Do not care
	end

	function methods:SetLabel(name)
		self:SetTitle(name)
	end

	function methods:SetDisabled(disabled)
		for _, child in pairs(self.children) do
			child:SetDisabled(disabled)
		end
	end

	local function AddItem(self, itemId)
		local widget = AceGUI:Create('ItemListElement')
		widget:SetUserData('listwidget', self)
		widget:SetItemId(itemId)
		self:AddChild(widget)
		return widget
	end

	local t = {}
	function methods:SetList(values)
		self:PauseLayout()
		self:ReleaseChildren()
		wipe(t)
		for itemId in pairs(values) do
			tinsert(t, itemId)
		end
		tsort(t)
		for _, itemId in pairs(t) do
			AddItem(self, itemId)
		end
		AddItem(self, nil)
		self:SetLayout("Flow")
		self:ResumeLayout()
		self:DoLayout()
	end

	function methods:SetItemValue(key, value)
		-- Do not care
	end

	local function Constructor()
		-- Create a InlineGroup widget an "promote" it to ItemList
		local widget = AceGUI.WidgetRegistry.InlineGroup()
		widget.type = Type
		for method, func in pairs(methods) do
			widget[method] = func
		end
		return widget
	end

	AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
