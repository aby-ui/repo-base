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

-- Don't load this file at all unless AdiBags is in retail.
if not addon.isRetail then
	return
end

--<GLOBALS
local _G = _G
local BreakUpLargeNumbers = _G.BreakUpLargeNumbers
local CreateFont = _G.CreateFont
local CreateFrame = _G.CreateFrame
local ExpandCurrencyList = _G.C_CurrencyInfo.ExpandCurrencyList
local format = _G.format
local GetCurrencyListInfo = _G.C_CurrencyInfo.GetCurrencyListInfo
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo
local GetCurrencyListSize = _G.C_CurrencyInfo.GetCurrencyListSize
local hooksecurefunc = _G.hooksecurefunc
local ipairs = _G.ipairs
local IsAddOnLoaded = _G.IsAddOnLoaded
local tconcat = _G.table.concat
local tinsert = _G.tinsert
local unpack = _G.unpack
local wipe = _G.wipe
--GLOBALS>

local UpdateTable = addon.UpdateTable

local mod = addon:NewModule('CurrencyFrame', 'ABEvent-1.0')
mod.uiName = L['Currency']
mod.uiDesc = L['Display character currency at bottom left of the backpack.']

function mod:OnInitialize()
	self.currencyToCell = {}
	self.columns = {}
	self.db = addon.db:RegisterNamespace(
		self.moduleName,
		{
			profile = {
				shown = {
					['*'] = false,  --[GetCurrencyInfo(1191)] = true, --not work
					Honor = true
				},
				hideZeroes = true,
				text = addon:GetFontDefaults(NumberFontNormalLarge),
				width = 4,
			}
		}
	)
	self.font = addon:CreateFont(
		self.name..'Font',
		NumberFontNormalLarge,
		function() return self.db.profile.text end
	)
	self.font.SettingHook = function() return self:Update() end
end

function mod:OnEnable()
	addon:HookBagFrameCreation(self, 'OnBagFrameCreated')
	if self.widget then
		self.widget:Show()
	end

	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', "Update")
	if not self.hooked then
		if IsAddOnLoaded('Blizzard_TokenUI') then
			self:ADDON_LOADED('OnEnable', 'Blizzard_TokenUI')
		else
			self:RegisterEvent('ADDON_LOADED')
		end
	end
	self.font:ApplySettings()
	self:Update()
end

function mod:ADDON_LOADED(_, name)
	if name ~= 'Blizzard_TokenUI' then return end
	self:UnregisterEvent('ADDON_LOADED')
	hooksecurefunc('TokenFrame_Update', function() self:Update() end)
	self.hooked = true
end

function mod:OnDisable()
	if self.widget then
		self.widget:Hide()
	end
end

function mod:OnBagFrameCreated(bag)
	if bag.bagName ~= "Backpack" then return end
	local frame = bag:GetFrame()

	local widget = CreateFrame("Button", addonName.."CurrencyFrame", frame)
	self.widget = widget
	widget:SetHeight(16)

	-- Create the columns used for currency display. Each column has the maximum amount
	-- of possible cells for the minimum width / the max number of currencies.
	for i = 1, 10 do
		local columnFrame = CreateFrame("Button", string.format("%sCurrencyColumnFrame%d", addonName, i), widget)
		columnFrame:Show()
		if i == 1 then
			columnFrame:SetPoint("TOPLEFT", widget, "TOPLEFT")
		else
			columnFrame:SetPoint("TOPLEFT", self.columns[i-1].frame, "TOPRIGHT")
		end
		local column = {
			frame = columnFrame,
			cells = {}
		}

		for ii = 1, ceil(GetCurrencyListSize() / 3)+1 do
			local cellFrame = CreateFrame("Button", string.format("%sCurrencyCellFrame%d%d", addonName, i, ii), columnFrame)
			if ii == 1 then
				cellFrame:SetPoint("TOPLEFT", columnFrame, "TOPLEFT")
			else
				cellFrame:SetPoint("TOPLEFT", column.cells[ii-1].frame, "BOTTOMLEFT")
			end

			cellFrame:Show()
			local fs = cellFrame:CreateFontString(nil, "OVERLAY")
			fs:SetFontObject(self.font)
			fs:SetPoint("BOTTOMLEFT", 0, 1)
			table.insert(column.cells, {
				frame = cellFrame,
				fs = fs,
				text = "",
				icon = "",
				name = "",
			})
		end
		table.insert(self.columns, column)
	end
	self:Update()
	frame:AddBottomWidget(widget, "LEFT", 50)
end

local IterateCurrencies
do
	local function iterator(collapse, index)
		if not index then return end
		repeat
			index = index + 1
			local currencyListInfo = GetCurrencyListInfo(index)
			if currencyListInfo then
				if currencyListInfo.name then
					if currencyListInfo.isHeader then
						if not currencyListInfo.isHeaderExpanded then
							tinsert(collapse, 1, index)
							ExpandCurrencyList(index, true)
						end
					else
						return index, currencyListInfo
					end
				end
			end
		until index > GetCurrencyListSize()
		for i, index in ipairs(collapse) do
			ExpandCurrencyList(index, false)
		end
	end

	local collapse = {}
	function IterateCurrencies()
		wipe(collapse)
		return iterator, collapse, 0
	end
end

local ICON_STRING = " \124T%s:0:0:0:0:64:64:5:59:5:59\124t  "

local values = {}
local updating
function mod:Update(event, currencyType, currencyQuantity)
	if not self.widget or updating then return end
	updating = true

	local info
	local updateCell
	if currencyType ~= nil then
		info = GetCurrencyInfo(currencyType)
		updateCell = self.currencyToCell[info.name]
	end

	-- Refresh only the affected cell.
	if updateCell ~= nil then
		updateCell.text = updateCell.icon .. BreakUpLargeNumbers(currencyQuantity)
		updateCell.fs:SetText(updateCell.text)
		updateCell.frame:SetSize(
			updateCell.fs:GetStringWidth(),
			ceil(updateCell.fs:GetStringHeight())+3
		)
		local column = updateCell.frame:GetParent()
		if column:GetWidth() < updateCell.frame:GetWidth() then
			column:SetWidth(updateCell.frame:GetWidth())
		end
		updating = false
		return
	end

	-- This is a full refresh of all cells, called on first load or layout changes.

	-- Clear the currency -> cell map.
	wipe(self.currencyToCell)

	-- Clear all cells and columns completely.
	for i, column in ipairs(self.columns) do
		for ii, cell in ipairs(column.cells) do
			cell.fs:SetText("")
			cell.text = ""
			cell.name = ""
			cell.icon = ""
			addon.RemoveTooltip(cell.frame)
		end
		column.frame:SetSize(0,0)
	end

	-- Get all the currency information from the player and store it.
	local shown, hideZeroes = self.db.profile.shown, self.db.profile.hideZeroes
	for i, currencyListInfo in IterateCurrencies() do
		if shown[currencyListInfo.name] and (currencyListInfo.quantity > 0 or not hideZeroes) then
			tinsert(values, {
				quantity = BreakUpLargeNumbers(currencyListInfo.quantity),
				icon = format(ICON_STRING, currencyListInfo.iconFileID),
				name = currencyListInfo.name
			})
		end
	end

	local widget, fs = self.widget, self.fontstring
	-- Set the cell values.
	if #values > 0 then
		for i, value in ipairs(values) do
			local columnPosition = ((i-1) % self.db.profile.width)+1
			local rowPosition = ceil(i / self.db.profile.width)
			local column = self.columns[columnPosition]
			local cell = column.cells[rowPosition]
			cell.icon = value.icon
			cell.name = value.name
			cell.text = value.icon .. value.quantity
			cell.fs:SetText(cell.text)
			cell.frame:SetSize(
				cell.fs:GetStringWidth(),
				ceil(cell.fs:GetStringHeight())+3
			)
			-- Set the cell's tooltip.
			addon.SetupTooltip(cell.frame, cell.name, "ANCHOR_BOTTOMLEFT")

			-- Resize the columns as needed.
			if column.frame:GetWidth() < cell.frame:GetWidth() then
				column.frame:SetWidth(cell.frame:GetWidth())
			end
			column.frame:SetHeight(column.frame:GetHeight() + cell.frame:GetHeight())
			self.currencyToCell[value.name] = cell
		end

		-- Loop over every active column and get the total width
		-- of all columns for the parent widget.
		local totalWidth = 0
		for i = 1, self.db.profile.width do
			totalWidth = totalWidth + self.columns[i].frame:GetWidth()
		end

		-- The first column will always be the longest column, so get the height
		-- of the first column and set the parent widget to this size.
		widget:SetSize(totalWidth, self.columns[1].frame:GetHeight())
		wipe(values)
	else
		widget:Hide()
	end
	widget:Show()
	updating = false
end

function mod:GetOptions()
	local values = {}
	return {
		shown = {
			name = L['Currencies to show'],
			type = 'multiselect',
			order = 10,
			values = function()
				wipe(values)
				for i, currencyListInfo in IterateCurrencies() do
					values[currencyListInfo.name] = format(ICON_STRING, currencyListInfo.iconFileID)..currencyListInfo.name
				end
				return values
			end,
			width = 'double',
		},
		hideZeroes = {
			name = L['Hide zeroes'],
			desc = L['Ignore currencies with null amounts.'],
			type = 'toggle',
			order = 20,
		},
		text = addon:CreateFontOptions(self.font, nil, 30),
		layout = {
			name = L['Layout'],
			type = 'group',
			order = 100,
			inline = true,
			args = {
				width = {
					name = L['Currencies per row'],
					type = 'range',
					min = 3,
					max = 10,
					step = 1
				}
			}
		},
	}, addon:GetOptionHandler(self, false, function() return self:Update() end)
end
