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

local MODNAME = "Flight"
local Flight = Quartz3:NewModule(MODNAME, "AceHook-3.0", "AceEvent-3.0")
local Player = Quartz3:GetModule("Player")

----------------------------
-- Upvalues
local GetTime = GetTime
local unpack = unpack

local db, getOptions

local defaults = {
	profile = {
		color = {0.7, 1, 0.7},
		deplete = false,
		},
	}

do
	local options
	function getOptions() 
	options = options or {
		type = "group",
		name = L["Flight"],
		order = 600,
		args = {
			toggle = {
				type = "toggle",
				name = L["Enable"],
				get = function()
					return Quartz3:GetModuleEnabled(MODNAME)
				end,
				set = function(info, v)
					Quartz3:SetModuleEnabled(MODNAME, v)
				end,
				order = 100,
			},
			color = {
				type = "color",
				name = L["Flight Map Color"],
				desc = L["Set the color to turn the cast bar when taking a flight path"],
				get = function() return unpack(db.color) end,
				set = function(info, ...) db.color = {...} end,
				order = 101,
			},
			deplete = {
				type = "toggle",
				name = L["Deplete"],
				desc = L["Deplete"],
				get = function() return db.deplete end,
				set = function(info, v) db.deplete = v end,
				order = 102,
			},
		},
	}
	return options
	end
end


function Flight:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Flight"])
end

function Flight:ApplySettings()
	db = self.db.profile
end

--[[
if InFlight then
	function Flight:OnEnable()
		self:RawHook(InFlight, "StartTimer")
	end

	function Flight:StartTimer(object, ...)
		self.hooks[object].StartTimer(object, ...)
		
		local f = InFlightBar
		local _, duration = f:GetMinMaxValues()
		local _, locText = f:GetRegions()
		local destination = locText:GetText()

		self:BeginFlight(duration, destination)
	end
else ]]
if FlightMapTimes_BeginFlight then
	function Flight:OnEnable()
		self:RawHook("FlightMapTimes_BeginFlight")
	end

	function Flight:FlightMapTimes_BeginFlight(duration, destination)
		if duration and duration > 0 then
			self:BeginFlight(duration, destination)
		end
		return self.hooks.FlightMapTimes_BeginFlight(duration, destination)
	end
end

function Flight:BeginFlight(duration, destination)
	Player.Bar.casting = true
	Player.Bar.startTime = GetTime()
	Player.Bar.endTime = GetTime() + duration
	Player.Bar.delay = 0
	Player.Bar.fadeOut = nil
	if db.deplete then
		Player.Bar.casting = nil
		Player.Bar.channeling = true
	else
		Player.Bar.casting = true
		Player.Bar.channeling = nil
	end
	
	Player.Bar.Bar:SetStatusBarColor(unpack(db.color))
	
	Player.Bar.Bar:SetValue(0)
	Player.Bar:Show()
	Player.Bar:SetAlpha(Player.db.profile.alpha)
	
	Player.Bar.Spark:Show()
	Player.Bar.Icon:SetTexture(nil)
	Player.Bar.Text:SetText(destination)
	
	local position = Player.db.profile.timetextposition
	if position == "caststart" then
		Player.Bar.TimeText:SetPoint("LEFT", Player.Bar.Bar, "LEFT", Player.db.profile.timetextx, Player.db.profile.timetexty)
		Player.Bar.TimeText:SetJustifyH("LEFT")
	elseif position == "castend" then
		Player.Bar.TimeText:SetPoint("RIGHT", Player.Bar.Bar, "RIGHT", -1 * Player.db.profile.timetextx, Player.db.profile.timetexty)
		Player.Bar.TimeText:SetJustifyH("RIGHT")
	end
end
