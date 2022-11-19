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
local CreateFont = _G.CreateFont
local floor = _G.floor
local pairs = _G.pairs
local setmetatable = _G.setmetatable
local type = _G.type
--GLOBALS>

local LSM = LibStub('LibSharedMedia-3.0')
local FONT = LSM.MediaType.FONT
local ALL_FONTS = LSM:HashTable(FONT)

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

local ALL_NAMES = setmetatable({}, {
	__index = function(self, file)
		for n, f in pairs(ALL_FONTS) do
			self[f] = n
			if f == file then
				return n
			end
		end
	end
})

local function GetFontSettings(font)
	local file, size = font:GetFont()
	return ALL_NAMES[file], floor(size), font:GetTextColor()
end

--------------------------------------------------------------------------------
-- Font prototype
--------------------------------------------------------------------------------

local proto = CreateFont(addonName.."BaseFont")
local meta = { __index = proto }

function proto:SetSetting(info, value, ...)
	local name, db = info[#info], self:GetDB()
	if name == "color" then
		local r, g, b = value, ...
		if db.r == r or db.g == g or db.b == b then
			return
		end
		db.r, db.g, db.b = r, g, b
		self:SetTextColor(r, g, b)
	elseif name == "name" or name == "size" then
		if db[name] == value then
			return
		end
		db[name] = value
		self:SetFont(LSM:Fetch(FONT, db.name), db.size, "")
	else
		return
	end
	if type(self.SettingHook) == "function" then
		self:SettingHook()
	end
end

function proto:GetSetting(info)
	local name, db = info[#info], self:GetDB()
	if name == "color" then
		return db.r, db.g, db.b
	else
		return db[name]
	end
end

function proto:ApplySettings()
	local db = self:GetDB()
	self:SetFont(LSM:Fetch(FONT, db.name), db.size, "")
	self:SetTextColor(db.r, db.g, db.b)
end

function proto:ResetSettings()
	local db = self:GetDB()
	db.name, db.size, db.r, db.g, db.b = GetFontSettings(self.template)
	self:ApplySettings()
	if type(self.SettingHook) == "function" then
		self:SettingHook()
	end
end

function proto:IsDefault()
	local db = self:GetDB()
	local name, size, r, g, b = GetFontSettings(self.template)
	return db.name == name and db.size == size and db.r == r and db.g == g and db.b == b
end

--------------------------------------------------------------------------------
-- Public methods
--------------------------------------------------------------------------------

function addon:CreateFont(name, template, dbGetter)
	local font = setmetatable(CreateFont(name), meta)
	font:SetFontObject(template)
	font.template = template
	font.GetDB = dbGetter
	LSM.RegisterCallback(font, 'LibSharedMedia_Registered', 'ApplySettings')
	LSM.RegisterCallback(font, 'LibSharedMedia_SetGlobal', 'ApplySettings')
	return font
end

function addon:GetFontDefaults(font)
	local name, size, r, g, b = GetFontSettings(font)
	return { name = name, size = size, r = r, g = g, b = b }
end

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

function addon:CreateFontOptions(font, title, order)
	local _, mediumSize = font.template:GetFont()
	mediumSize = floor(mediumSize)
	return {
		name = title or L['Text'],
		type = 'group',
		order = order or 0,
		inline = true,
		handler = font,
		set = 'SetSetting',
		get = 'GetSetting',
		disabled = false,
		args = {
			name = {
				name = L['Font'],
				type = 'select',
				order = 10,
				dialogControl = 'LSM30_Font',
				values = ALL_FONTS,
			},
			size = {
				name = L['Size'],
				type = 'range',
				order = 20,
				min = mediumSize - 8,
				max = mediumSize + 8,
				step = 1,
			},
			color = {
				name = L['Color'],
				type = 'color',
				order = 30,
				hasAlpha = false,
			},
			reset = {
				name = L['Reset'],
				type = 'execute',
				order = 40,
				disabled  = 'IsDefault',
				func = 'ResetSettings',
			},
		},
	}
end
