--[[
	Copyright (C) 2006-2007 Nymbia
	Copyright (C) 2010-2017 Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License along
	with this program; if not, write to the Free Software Foundation, Inc.,
	51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
]]
local Quartz3 = LibStub("AceAddon-3.0"):GetAddon("Quartz3")
local L = LibStub("AceLocale-3.0"):GetLocale("Quartz3")

local MODNAME = "Range"
local Range = Quartz3:NewModule(MODNAME, "AceEvent-3.0")
local Player = Quartz3:GetModule("Player")

----------------------------
-- Upvalues
local CreateFrame, UIParent = CreateFrame, UIParent
local UnitCastingInfo, UnitChannelInfo, UnitName, IsSpellInRange = UnitCastingInfo, UnitChannelInfo, UnitName, IsSpellInRange
local unpack = unpack

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
if WoWClassic then
	UnitCastingInfo = function(unit)
		if unit ~= "player" then return end
		return CastingInfo()
	end

	UnitChannelInfo = function(unit)
		if unit ~= "player" then return end
		return ChannelInfo()
	end
end

local f, OnUpdate, db, getOptions, spell, target, modified, r, g, b, castBar

local defaults ={ 
	profile = {
		rangecolor = {1, 1, 1},
	}
}

do
	local refreshtime = 0.25
	local sincelast = 0
	function OnUpdate(frame, elapsed)
		sincelast = sincelast + elapsed
		if sincelast >= refreshtime then
			sincelast = 0
			if not castBar:IsVisible() or Player.Bar.fadeOut then
				return f:SetScript("OnUpdate", nil)
			end
			if IsSpellInRange(spell, target) == 0 then
				r, g, b = castBar:GetStatusBarColor()
				modified = true
				castBar:SetStatusBarColor(unpack(db.rangecolor))
			elseif modified then
				castBar:SetStatusBarColor(r,g,b)
				modified, r, g, b = nil, nil, nil, nil
			end
		end
	end
end

function Range:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Range"])

	f = CreateFrame("Frame", nil, UIParent)
end

function Range:OnEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SENT")
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
end

function Range:ApplySettings()
	db = self.db.profile
end

function Range:UNIT_SPELLCAST_START(event, unit)
	if unit ~= "player" then
		return
	end
	if not castBar then
		castBar = Player.Bar.Bar
	end
	if target then
		spell = UnitCastingInfo(unit)
		modified, r, g, b = nil, nil, nil, nil
		f:SetScript("OnUpdate", OnUpdate)
	end
end

function Range:UNIT_SPELLCAST_CHANNEL_START(event, unit)
	if unit ~= "player" then
		return
	end
	if not castBar then
		castBar = Player.Bar.Bar
	end
	if target then
		spell = UnitChannelInfo(unit)
		modified, r, g, b = nil, nil, nil, nil
		f:SetScript("OnUpdate", OnUpdate)
	end
end

function Range:UNIT_SPELLCAST_SENT(event, unit, name)
	if unit ~= "player" then
		return
	end
	if name then
		if name == UnitName("player") then
			target = "player"
		elseif name == UnitName("target") then
			target = "target"
		elseif name == UnitName("focus") then
			target = "focus"
		else
			target = nil
		end
	else
		target = nil
	end
end

do
	local options
	function getOptions()
		if not options then
			options = {
				type = "group",
				name = L["Range"],
				desc = L["Range"],
				order = 600,
				args = {
					toggle = {
						type = "toggle",
						name = L["Enable"],
						desc = L["Enable"],
						get = function()
							return Quartz3:GetModuleEnabled(MODNAME)
						end,
						set = function(info, v)
							Quartz3:SetModuleEnabled(MODNAME, v)
						end,
						order = 100,
					},
					rangecolor = {
						type = "color",
						name = L["Out of Range Color"],
						desc = L["Set the color to turn the cast bar when the target is out of range"],
						get = function() return unpack(db.rangecolor) end,
						set = function(info, ...) db.rangecolor = {...} end,
						order = 101,
					},
				},
			}
		end
		return options
	end
end
