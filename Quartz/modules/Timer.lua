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

local MODNAME = "Timer"
local Timer = Quartz3:NewModule(MODNAME, "AceEvent-3.0")
local Mirror = Quartz3:GetModule("Mirror")

----------------------------
-- Upvalues
local GetTime = GetTime
local unpack, pairs, ipairs, tonumber = unpack, pairs, ipairs, tonumber
local table_remove = table.remove

local external = Mirror.ExternalTimers
local thistimers = {}

local getOptions

function Timer:ChatHandler(msg)
	if self:IsEnabled() then
		if msg:match("^kill") then
			local name = msg:match("^kill (.+)$")
			if name then
				external[name] = nil
				for k, v in ipairs(thistimers) do
					if v == name then
						table_remove(thistimers, k)
						break
					end
				end
				self:SendMessage("Quartz3Mirror_UpdateCustom")
			else
				return Quartz3:Print(L["Usage: /quartztimer timername 60 or /quartztimer kill timername"])
			end
		else
		local duration = tonumber(msg:match("^(%d+)"))
		local name
		if duration then
			name = msg:match("^%d+ (.+)$")
		else
			duration = tonumber(msg:match("(%d+)$"))
			if not duration then
				return Quartz3:Print(L["Usage: /quartztimer timername 60 or /quartztimer 60 timername"])
			end
			name = msg:match("^(.+) %d+$")
		end
		if not name then
			return Quartz3:Print(L["Usage: /quartztimer timername 60 or /quartztimer kill timername"])
		end

		local currentTime = GetTime()
		external[name].startTime = currentTime
		external[name].endTime = currentTime + duration
		for k, v in ipairs(thistimers) do
			if v == name then
				table_remove(thistimers, k)
				break
				end
			end
			thistimers[#thistimers+1] = name
			self:SendMessage("Quartz3Mirror_UpdateCustom")
		end
	end
end

function Timer:OnDisable()
	for k, v in pairs(thistimers) do
		external[v] = nil
		thistimers[k] = nil
	end
	self:SendMessage("Quartz3Mirror_UpdateCustom")
end

local function chatHandler(message)
	Timer:ChatHandler(message)
end

function Timer:OnInitialize()
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Timer"])

	Quartz3:RegisterChatCommand("qt", chatHandler)
	Quartz3:RegisterChatCommand("quartzt", chatHandler)
	Quartz3:RegisterChatCommand("quartztimer", chatHandler)
end


do
	local newname, newlength

	local options
	function getOptions()
		if not options then
			options = {
				type = "group",
				name = L["Timer"],
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
						order = 99,
						width = "full",
					},
					newtimername = {
						type = "input",
						name = L["New Timer Name"],
						desc = L["Set a name for the new timer"],
						get = function()
							return newname or ""
						end,
						set = function(info, v)
							newname = v
						end,
						order = 100,
					},
					newtimerlength = {
						type = "input",
						name = L["New Timer Length"],
						desc = L["Length of the new timer, in seconds"],
						get = function()
							return newlength or 0
						end,
						set = function(info, v)
							newlength = tonumber(v)
						end,
						usage = L["<Time in seconds>"],
						order = 101,
					},
					makenewtimer = {
						type = "execute",
						name = L["Make Timer"],
						desc = L["Make a new timer using the above settings.  NOTE: it may be easier for you to simply use the command line to make timers, /qt"],
						func = function()
							local currentTime = GetTime()
							external[newname].startTime = currentTime
							external[newname].endTime = currentTime + newlength
							for k, v in ipairs(thistimers) do
								if v == newname then
									table_remove(thistimers, k)
									break
								end
							end
							thistimers[#thistimers+1] = newname
							Timer:SendMessage("Quartz3Mirror_UpdateCustom")
							newname = nil
							newlength = nil
						end,
						disabled = function()
							return not (newname and newlength)
						end,
						order = -3,
					},
					nl = {
						type = "description",
						name = "",
						order = -2,
					},
					killtimer = {
						type = "select",
						name = L["Stop Timer"],
						desc = L["Select a timer to stop"],
						get = function()
							return ""
						end,
						set = function(info, name)
							if name then
								external[name] = nil
								for k, v in ipairs(thistimers) do
									if v == name then
										table_remove(thistimers, k)
										break
									end
								end
								Timer:SendMessage("Quartz3Mirror_UpdateCustom")
							end
						end,
						values = thistimers,
						order = -1,
					},
				},
			}
		end
		return options
	end
end
