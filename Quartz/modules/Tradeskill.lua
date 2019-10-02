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

local MODNAME = "Tradeskill"
local Tradeskill = Quartz3:NewModule(MODNAME, "AceEvent-3.0", "AceHook-3.0")
local Player = Quartz3:GetModule("Player")

local TimeFmt = Quartz3.Util.TimeFormat

----------------------------
-- Upvalues
local GetTime, UnitCastingInfo = GetTime, UnitCastingInfo
local unpack, tonumber, format = unpack, tonumber, format

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
if WoWClassic then
	UnitCastingInfo = function(unit)
		if unit ~= "player" then return end
		return CastingInfo()
	end
end

local getOptions

local castBar, castBarText, castBarTimeText, castBarIcon, castBarSpark, castBarParent

local repeattimes, castSpellID, duration, totaltime, starttime, casting, bail
local completedcasts = 0
local restartdelay = 1

local function tradeskillOnUpdate()
	local currentTime = GetTime()
	if casting then
		local elapsed = duration * completedcasts + currentTime - starttime
		castBar:SetValue(elapsed)
		
		local perc = (currentTime - starttime) / duration
		castBarSpark:ClearAllPoints()
		castBarSpark:SetPoint("CENTER", castBar, "LEFT", perc * castBar:GetWidth(), 0)
		
		if Player.db.profile.hidecasttime then
			castBarTimeText:SetFormattedText(TimeFmt(totaltime - elapsed))
		else
			castBarTimeText:SetFormattedText("%s / %s", format(TimeFmt(totaltime - elapsed)), format(TimeFmt(totaltime)))
		end
	else
		if (starttime + duration + restartdelay < currentTime) or (completedcasts >= repeattimes) or bail or completedcasts == 0 then
			Player.Bar.fadeOut = true
			Player.Bar.stopTime = currentTime
			castBar:SetValue(duration * repeattimes)
			castBarTimeText:SetText("")
			castBarSpark:Hide()
			castBarParent:SetScript("OnUpdate", Player.Bar.OnUpdate)
			castBar:SetMinMaxValues(0, 1)
		else
			local elapsed = duration * completedcasts
			castBar:SetValue(elapsed)
			
			castBarSpark:ClearAllPoints()
			castBarSpark:SetPoint("CENTER", castBar, "LEFT", castBar:GetWidth(), 0)
			
			if Player.db.profile.hidecasttime then
				castBarTimeText:SetFormattedText(TimeFmt(totaltime - elapsed))
			else
				castBarTimeText:SetFormattedText("%s / %s", format(TimeFmt(totaltime - elapsed)), format(TimeFmt(totaltime)))
			end
		end
	end
end

function Tradeskill:OnInitialize()
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Tradeskill Merge"])
end


function Tradeskill:OnEnable()
	self:RawHook(Player, "UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	if WoWClassic then
		self:SecureHook("DoTradeSkill")
	else
		self:SecureHook(C_TradeSkillUI, "CraftRecipe", "DoTradeSkill")
	end
end

function Tradeskill:UNIT_SPELLCAST_START(object, bar, unit, guid, spellID)
	if unit ~= "player" then
		return self.hooks[object].UNIT_SPELLCAST_START(object, bar, unit, guid, spellID)
	end
	local spell, displayName, icon, startTime, endTime, isTradeskill = UnitCastingInfo(unit)
	if isTradeskill then
		repeattimes = repeattimes or 1
		duration = (endTime - startTime) / 1000
		totaltime = duration * repeattimes
		starttime = GetTime()
		casting = true
		Player.Bar.fadeOut = nil
		castSpellID = spellID
		bail = nil
		Player.Bar.endTime = nil
		
		castBar:SetStatusBarColor(unpack(Quartz3.db.profile.castingcolor))
		castBar:SetMinMaxValues(0, totaltime)
		
		castBar:SetValue(0)
		castBarParent:Show()
		castBarParent:SetScript("OnUpdate", tradeskillOnUpdate)
		castBarParent:SetAlpha(Player.db.profile.alpha)
		
		local numleft = repeattimes - completedcasts
		if numleft <= 1 then
			castBarText:SetText(displayName)
		else
			castBarText:SetFormattedText("%s (%s)", displayName, numleft)
		end
		castBarSpark:Show()
		castBarIcon:SetTexture(icon)
	else
		castBar:SetMinMaxValues(0, 1)
		return self.hooks[object].UNIT_SPELLCAST_START(object, bar, unit, guid, spellID)
	end
end

function Tradeskill:UNIT_SPELLCAST_STOP(event, unit)
	if unit ~= "player" then
		return
	end
	casting = false
end

function Tradeskill:UNIT_SPELLCAST_SUCCEEDED(event, unit, guid, spell)
	if unit ~= "player" then
		return
	end
	if castSpellID == spell then
		completedcasts = completedcasts + 1
	end
end

function Tradeskill:UNIT_SPELLCAST_INTERRUPTED(event, unit)
	if unit ~= "player" then
		return
	end
	bail = true
end

function Tradeskill:DoTradeSkill(index, num)
	completedcasts = 0
	repeattimes = tonumber(num) or 1
end

function Tradeskill:ApplySettings()
	castBarParent = Player.Bar
	castBar = Player.Bar.Bar
	castBarText = Player.Bar.Text
	castBarTimeText = Player.Bar.TimeText
	castBarIcon = Player.Bar.Icon
	castBarSpark = Player.Bar.Spark
end

do
	local options
	function getOptions()
		if not options then
			options = {
				type = "group",
				name = L["Tradeskill Merge"],
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
					},
				},
			}
		end
		return options
	end
end
