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

local MODNAME = "Player"
local Player = Quartz3:NewModule(MODNAME, "AceEvent-3.0")

local UnitCastingInfo, UnitChannelInfo = UnitCastingInfo, UnitChannelInfo

local WOW_INTERFACE_VER = select(4, GetBuildInfo())
local WoWRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
local WoWBC = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) and WOW_INTERFACE_VER >= 20500 and WOW_INTERFACE_VER < 30000
local WoWWrath = (WOW_PROJECT_ID ~= WOW_PROJECT_MAINLINE) and WOW_INTERFACE_VER >= 30400 and WOW_INTERFACE_VER < 40000

----------------------------
-- Upvalues
-- GLOBALS: CastingBarFrame
local unpack = unpack


local db, getOptions, castBar

local defaults = {
	profile = Quartz3:Merge(Quartz3.CastBarTemplate.defaults,
	{
		hideblizz = true,
		showticks = true,
		-- no interrupt is pointless for player, disable all options
		noInterruptBorderChange = false,
		noInterruptColorChange = false,
		noInterruptShield = false,
		targetnamestyle = "default"
	})
}

do
	local function setOpt(info, value)
		db[info[#info]] = value
		Player:ApplySettings()
	end

	local options
	function getOptions()
		if not options then
			options = Player.Bar:CreateOptions()
			options.args.hideblizz = {
				type = "toggle",
				name = L["Disable Blizzard Cast Bar"],
				desc = L["Disable and hide the default UI's casting bar"],
				set = setOpt,
				order = 101,
			}
			options.args.showticks = {
				type = "toggle",
				name = L["Show channeling ticks"],
				desc = L["Show damage / mana ticks while channeling spells like Drain Life or Blizzard"],
				order = 102,
			}
			options.args.targetname = {
				type = "toggle",
				name = L["Show Target Name"],
				desc = L["Display target name of spellcasts after spell name"],
				disabled = function() return db.hidenametext end,
				order = 402,
			}
			options.args.targetnamestyle = {
				type = "select",
				name = L["Target Name Style"],
				desc = L["How to display target name of spellcasts after spell name"],
				values = {["default"] = L["Spell -> Target"], ["on"] = L["Spell on Target"]},
				disabled = function() return not db.targetname or db.hidenametext end,
				order = 402,
			}
			options.args.noInterruptGroup = nil
		end
		return options
	end
end

function Player:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Player"])

	self.Bar = Quartz3.CastBarTemplate:new(self, "player", MODNAME, L["Player"], db)
	castBar = self.Bar.Bar
end


function Player:OnEnable()
	if WoWRetail then
		self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", "UpdateChannelingTicks")
	end

	self.Bar:RegisterEvents()
	self:ApplySettings()

	self:UpdateChannelingTicks()
end

function Player:OnDisable()
	self.Bar:UnregisterEvents()
	self.Bar:Hide()
end

function Player:ApplySettings()
	db = self.db.profile

	-- obey the hideblizz setting no matter if disabled or not
	if PlayerCastingBarFrame then
		if db.hideblizz then
			PlayerCastingBarFrame.RegisterEvent = function() end
			PlayerCastingBarFrame:UnregisterAllEvents()
			PlayerCastingBarFrame:Hide()
		else
			self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTED", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_DELAYED", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_START", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_START", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_UPDATE", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_EMPOWER_STOP", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_INTERRUPTIBLE", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
			self:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
			self:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
	else
		if db.hideblizz then
			CastingBarFrame.RegisterEvent = function() end
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame:Hide()
		else
			CastingBarFrame.RegisterEvent = nil
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame:RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
			CastingBarFrame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
			CastingBarFrame:RegisterUnitEvent("UNIT_SPELLCAST_FAILED", "player")
			CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
			CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_DELAYED")
			CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
			CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
			if WoWRetail then
				CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
				CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
			end
			CastingBarFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		end
	end

	self.Bar:SetConfig(db)
	if self:IsEnabled() then
		self.Bar:ApplySettings()
	end
end

function Player:Unlock()
	self.Bar:Unlock()
end

function Player:Lock()
	self.Bar:Lock()
end

----------------------------
-- Cast Bar Hooks

function Player:OnHide()
	local Latency = Quartz3:GetModule("Latency", true)
	if Latency then
		if Latency:IsEnabled() and Latency.lagbox then
			Latency.lagbox:Hide()
			Latency.lagtext:Hide()
		end
	end
end

local sparkfactory = {
	__index = function(t,k)
		local spark = castBar:CreateTexture(nil, 'OVERLAY')
		t[k] = spark
		spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
		spark:SetVertexColor(unpack(Quartz3.db.profile.sparkcolor))
		spark:SetBlendMode('ADD')
		spark:SetWidth(20)
		spark:SetHeight(db.h*2.2)
		return spark
	end
}
local barticks = setmetatable({}, sparkfactory)

local function setBarTicks(ticknum, duration, ticks)
	if( ticknum and ticknum > 0) then
		local width = castBar:GetWidth()
		for k = 1, ticknum do
			local t = barticks[k]
			t:ClearAllPoints()
			local x = ticks[k] / duration
			t:SetPoint("CENTER", castBar, "RIGHT", -width * x, 0 )
			t:Show()
		end
		for k = ticknum+1,#barticks do
			barticks[k]:Hide()
		end
	else
		barticks[1].Hide = nil
		for i=1,#barticks do
			barticks[i]:Hide()
		end
	end
end

local channelingTicks = WoWWrath and {
	--- Wrath
	-- druid
	[GetSpellInfo(740)] = 4, -- tranquility
	[GetSpellInfo(16914)] = 10, -- hurricane
	-- hunter
	[GetSpellInfo(1510)] = 6, -- volley
	-- mage
	[GetSpellInfo(10)] = 8, -- blizzard
	[5143] = 3, -- arcane missiles r1
	[5144] = 4, -- arcane missiles r2
	[GetSpellInfo(5145)] = 5, -- arcane missiles
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	-- warlock
	[GetSpellInfo(1949)] = 15, -- hellfire
	[GetSpellInfo(5740)] = 4, -- rain of fire
	[GetSpellInfo(5138)] = 5, -- drain mana
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(1120)] = 5, -- drain soul
	[GetSpellInfo(755)] = 10, -- health funnel
} or WoWBC and {
	--- BCC
	-- druid
	[GetSpellInfo(740)] = 4, -- tranquility
	[GetSpellInfo(16914)] = 10, -- hurricane
	-- hunter
	[GetSpellInfo(1510)] = 6, -- volley
	-- mage
	[GetSpellInfo(10)] = 8, -- blizzard
	[5143] = 3, -- arcane missiles r1
	[5144] = 4, -- arcane missiles r2
	[GetSpellInfo(5145)] = 5, -- arcane missiles
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(10797)] = 5, -- star shards
	-- warlock
	[GetSpellInfo(1949)] = 15, -- hellfire
	[GetSpellInfo(5740)] = 4, -- rain of fire
	[GetSpellInfo(5138)] = 5, -- drain mana
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(1120)] = 5, -- drain soul
	[GetSpellInfo(755)] = 10, -- health funnel
} or WoWRetail and {
	--- Retail
	-- warlock
	[GetSpellInfo(234153)] = 5, -- drain life
	[GetSpellInfo(198590)] = 5, -- drain soul
	[GetSpellInfo(217979)] = 5, -- health funnel
	-- druid
	[GetSpellInfo(740)] = 4, -- tranquility
	-- priest
	[GetSpellInfo(64843)] = 4, -- divine hymn
	[GetSpellInfo(15407)] = 6, -- mind flay
	[GetSpellInfo(47540)] = 3, -- penance
	[GetSpellInfo(205065)] = 5, -- void torrent
	[GetSpellInfo(48045)] = 6, -- mind sear
	[GetSpellInfo(64901)] = 5, -- symbol of hope
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(205021)] = 5, -- ray of frost
	[GetSpellInfo(314791)] = 4, -- covenant: shifting power
	-- monk
	[GetSpellInfo(117952)] = 4, -- crackling jade lightning
	[GetSpellInfo(191837)] = 3, -- essence font
	[GetSpellInfo(115175)] = 8, -- soothing mist
} or {}


local function getChannelingTicks(spell, spellid)
	if not db.showticks then
		return 0
	end
	return channelingTicks[spellid] or channelingTicks[spell] or 0
end

local function isTalentKnown(talentID)
	return (select(4, GetTalentInfoByID(19752, GetActiveSpecGroup())))
end

function Player:UpdateChannelingTicks()
	local playerClass = select(2, UnitClass("player"))
	if WoWRetail then
		if playerClass == "PRIEST" then
			-- Castigation talent adds a tick to penance
			channelingTicks[GetSpellInfo(47540)] = isTalentKnown(19752) and 4 or 3
		end
	end
end

function Player:UNIT_SPELLCAST_START(bar, unit)
	if bar.channeling then
		local spell, _, _, _, _, _, _, spellid = UnitChannelInfo(unit)
		bar.channelingEnd = bar.endTime
		bar.channelingDuration = bar.endTime - bar.startTime
		bar.channelingTicks = getChannelingTicks(spell, spellid)
		bar.channelingTickTime = bar.channelingTicks > 0 and (bar.channelingDuration / bar.channelingTicks) or 0
		bar.ticks = bar.ticks or {}
		for i = 1, bar.channelingTicks do
			bar.ticks[i] = bar.channelingDuration - (i - 1) * bar.channelingTickTime
		end
		setBarTicks(bar.channelingTicks, bar.channelingDuration, bar.ticks)
	else
		setBarTicks(0)
		bar.channelingDuration = nil
	end
end

function Player:UNIT_SPELLCAST_STOP(bar, unit)
	setBarTicks(0)
	bar.channelingDuration = nil
end

function Player:UNIT_SPELLCAST_FAILED(bar, unit)
	setBarTicks(0)
	bar.channelingDuration = nil
end

function Player:UNIT_SPELLCAST_INTERRUPTED(bar, unit)
	setBarTicks(0)
	bar.channelingDuration = nil
end

function Player:UNIT_SPELLCAST_DELAYED(bar, unit)
	if bar.channeling and bar.endTime > bar.channelingEnd then
		local duration = bar.endTime - bar.startTime
		if bar.channelingDuration and duration > bar.channelingDuration and bar.channelingTicks > 0 then
			local extraTime = (duration - bar.channelingDuration)
			for i = 1, bar.channelingTicks do
				bar.ticks[i] = bar.ticks[i] + extraTime
			end
			while bar.ticks[bar.channelingTicks] > bar.channelingTickTime do
				bar.channelingTicks = bar.channelingTicks + 1
				bar.ticks[bar.channelingTicks] = bar.ticks[bar.channelingTicks-1] - bar.channelingTickTime
			end
			bar.channelingDuration = duration
			bar.channelingEnd = bar.endTime
			setBarTicks(bar.channelingTicks, bar.channelingDuration, bar.ticks)
		end
	end
end
