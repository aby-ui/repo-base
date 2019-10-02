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

local MODNAME = "Mirror"
local Mirror = Quartz3:NewModule(MODNAME, "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local Player = Quartz3:GetModule("Player")
local Focus = Quartz3:GetModule("Focus", true)
local Target = Quartz3:GetModule("Target", true)

local TimeFmt = Quartz3.Util.TimeFormat

local media = LibStub("LibSharedMedia-3.0")
local lsmlist = AceGUIWidgetLSMlists

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

----------------------------
-- Upvalues
-- GLOBALS: MIRRORTIMER_NUMTIMERS
local _G = _G
local CreateFrame, GetTime, UIParent, StaticPopupDialogs = CreateFrame, GetTime, UIParent, StaticPopupDialogs
local GetMirrorTimerProgress, GetMirrorTimerInfo, GetCorpseRecoveryDelay = GetMirrorTimerProgress, GetMirrorTimerInfo, GetCorpseRecoveryDelay
local UnitHealth = UnitHealth
local pairs, unpack, next, wipe, error = pairs, unpack, next, wipe, error
local table_sort = table.sort


local gametimebase, gametimetostart
local lfgshowbase, readycheckshowbase, readycheckshowduration
local locked = true

local db, getOptions

local new, del

local defaults = {
	profile = {
		mirroricons = true,
		mirroriconside = "left",
		
		mirroranchor = "player",--L["Free"], L["Target"], L["Focus"]
		
		mirrorx = 500,
		mirrory = 700,
		mirrorgrowdirection = "up", --L["Down"]
		
		mirrorposition = "topleft",
		
		mirrorgap = 1,
		mirrorspacing = 1,
		mirroroffset = 3,
		
		mirrornametext = true,
		mirrortimetext = true,
		
		mirrortexture = "LiteStep",
		mirrorwidth = 120,
		mirrorheight = 12,
		mirrorfont = "Friz Quadrata TT",
		mirrorfontsize = 9,
		mirroralpha = 1,
		
		mirrortextcolor = {1, 1, 1},
		BREATH = {0, 0.5, 1},
		EXHAUSTION = {1.00, 0.9, 0},
		FEIGNDEATH = {1, 0.7, 0},
		CAMP = {1, 0.7, 0},
		DEATH = {1, 0.1, 0.1},
		QUIT = {1, 0.7, 0},
		DUEL_OUTOFBOUNDS = {0.2, 0.8, 0.2},
		INSTANCE_BOOT = {1, 0, 0},
		CONFIRM_SUMMON = {1, 0.3, 1},
		AREA_SPIRIT_HEAL = {0, 0.22, 1},
		REZTIMER = {1, 0, 0.5},
		RESURRECT_NO_SICKNESS = {0.47, 1, 0},
		RESURRECT_NO_TIMER = {0.47, 1, 0},
		PARTY_INVITE = {1, 0.9, 0},
		DUEL_REQUESTED = {1, 0.13, 0},
		GAMESTART = {0,1,0},
		READYCHECK = {0,1,0},

		hideblizzmirrors = true,

		showmirror = true,
		showstatic = true,
		showpvp = true,
		showreadycheck = true,
	}
}

local icons = {
	BREATH = "Interface\\Icons\\Spell_Shadow_DemonBreath",
	EXHAUSTION = "Interface\\Icons\\Ability_Suffocate",
	FEIGNDEATH = "Interface\\Icons\\Ability_Rogue_FeignDeath",
	CAMP = "Interface\\Icons\\INV_Misc_GroupLooking",
	DEATH = "Interface\\Icons\\Ability_Vanish",
	QUIT = "Interface\\Icons\\INV_Misc_GroupLooking",
	DUEL_OUTOFBOUNDS = "Interface\\Icons\\Ability_Rogue_Sprint",
	INSTANCE_BOOT = "Interface\\Icons\\INV_Misc_Rune_01",
	CONFIRM_SUMMON = "Interface\\Icons\\Spell_Shadow_Twilight",
	AREA_SPIRIT_HEAL = "Interface\\Icons\\Spell_Holy_Resurrection",
	REZTIMER = "",
	RESURRECT_NO_SICKNESS = "",
	PARTY_INVITE = "",
	DUEL_REQUESTED = "",
	GAMESTART = "",
	READYCHECK = "",
}

local popups = {
	CAMP = L["Logout"],
	DEATH = L["Release"],
	QUIT = L["Quit"],
	DUEL_OUTOFBOUNDS = L["Forfeit Duel"],
	INSTANCE_BOOT = L["Instance Boot"],
	CONFIRM_SUMMON = L["Summon"],
	AREA_SPIRIT_HEAL = L["AOE Rez"],
	REZTIMER = L["Resurrect Timer"], --GetCorpseRecoveryDelay
	RESURRECT_NO_SICKNESS = L["Resurrect"], --only show if timeleft < delay
	RESURRECT_NO_TIMER = L["Resurrect"],
	PARTY_INVITE = L["Party Invite"],
	DUEL_REQUESTED = L["Duel Request"],
	GAMESTART = L["Game Start"],
	READYCHECK = READY_CHECK,
}

local timeoutoverrides = {
	DEATH = 360,
	AREA_SPIRIT_HEAL = 30,
	INSTANCE_BOOT = 60,
	CONFIRM_SUMMON = 120,
	GAMESTART = 60,
	READYCHECK = 40,
}

Mirror.ExternalTimers = setmetatable({}, {__index = function(t,k)
	local v = new()
	t[k] = v
	return v
	--[[
	startTime
	endTime
	icon
	color
	]]
end})

local mirrorOnUpdate, fakeOnUpdate
do
	function mirrorOnUpdate(frame)
		local progress = GetMirrorTimerProgress(frame.mode) / 1000
		progress = progress > frame.duration and frame.duration or progress
		frame:SetValue(progress)
		frame.TimeText:SetFormattedText(TimeFmt(progress))
	end

	function fakeOnUpdate(frame)
		local currentTime = GetTime()
		local endTime = frame.endTime

		if frame.framenum > 0 then
			local popup = _G["StaticPopup"..frame.framenum] -- hate to do this, but I can"t think of a better way.
			if popup.which ~= frame.which or not popup:IsVisible() then
				return Mirror:UpdateBars()
			end
		end

		if currentTime > endTime then
			Mirror:UpdateBars()
		else
			local remaining = currentTime - frame.startTime
			frame:SetValue(endTime - remaining)
			frame.TimeText:SetFormattedText(TimeFmt(endTime - currentTime))
		end
	end
end

local mirrorbars = setmetatable({}, {
	__index = function(t,k)
		if k == nil then return nil end
		local bar = Quartz3:CreateStatusBar("QuartzMirrorBar" .. tostring(k), UIParent)
		t[k] = bar
		bar:SetFrameStrata("MEDIUM")
		bar:Hide()
		bar:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		bar:SetBackdropColor(0,0,0)
		bar.Text = bar:CreateFontString(nil, "OVERLAY")
		bar.TimeText = bar:CreateFontString(nil, "OVERLAY")
		bar.Icon = bar:CreateTexture(nil, "DIALOG")
		if k == 1 then
			bar:SetMovable(true)
			bar:RegisterForDrag("LeftButton")
			bar:SetClampedToScreen(true)
		end
		Mirror:ApplySettings()
		return bar
	end
})

function Mirror:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile
	
	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Mirror"])

end

function Mirror:OnEnable()
	self:RegisterEvent("MIRROR_TIMER_PAUSE", "UpdateBars")
	self:RegisterEvent("MIRROR_TIMER_START", "UpdateBars")
	self:RegisterEvent("MIRROR_TIMER_STOP", "UpdateBars")
	self:RegisterEvent("PLAYER_UNGHOST", "UpdateBars")
	self:RegisterEvent("PLAYER_ALIVE", "UpdateBars")
	self:RegisterMessage("Quartz3Mirror_UpdateCustom", "UpdateBars")
	self:RegisterEvent("CHAT_MSG_BG_SYSTEM_NEUTRAL")
	if not WoWClassic then
		self:RegisterEvent("LFG_PROPOSAL_SHOW")
		self:RegisterEvent("LFG_PROPOSAL_FAILED", "LFG_PROPOSAL_End")
		self:RegisterEvent("LFG_PROPOSAL_SUCCEEDED", "LFG_PROPOSAL_End")
	end
	self:RegisterEvent("READY_CHECK")
	self:RegisterEvent("READY_CHECK_FINISHED")
	self:SecureHook("StaticPopup_Show", "UpdateBars")
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			for i, v in pairs(mirrorbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", override))
			end
		end
	end)

	media.RegisterCallback(self, "LibSharedMedia_Registered", function(mtype, key)
		if mtype == "statusbar" and key == self.config.mirrortexture then
			for i, v in pairs(mirrorbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", self.config.mirrortexture))
			end
		end
	end)

	self:ApplySettings()
end

function Mirror:OnDisable()
	mirrorbars[1].Hide = nil
	mirrorbars[1]:EnableMouse(false)
	mirrorbars[1]:SetScript("OnDragStart", nil)
	mirrorbars[1]:SetScript("OnDragStop", nil)

	for _, v in pairs(mirrorbars) do
		v:Hide()
		v:SetScript("OnUpdate", nil)
	end

	for i = 1, 3 do
		_G["MirrorTimer"..i]:RegisterEvent("MIRROR_TIMER_PAUSE")
		_G["MirrorTimer"..i]:RegisterEvent("MIRROR_TIMER_STOP")
	end
	UIParent:RegisterEvent("MIRROR_TIMER_START")

	media.UnregisterCallback(self, "LibSharedMedia_SetGlobal")
	media.UnregisterCallback(self, "LibSharedMedia_Registered")
end

do
	local tblCache = setmetatable({}, {__mode="k"})
	function new()
		local entry = next(tblCache)
		if entry then tblCache[entry] = nil else entry = {} end
		return entry
	end
	function del(tbl)
		wipe(tbl)
		tblCache[tbl] = true
	end
	
	local function sort(a,b)
		return a.name < b.name
	end
	
	local tmp = {}
	local reztimermax = 0
	local function update()
		Mirror.updateMirrorBar = nil
		local currentTime = GetTime()
		for k in pairs(tmp) do
			tmp[k] = del(tmp[k])
		end
		
		if db.showpvp then
			if gametimebase then
				local endTime = gametimebase + gametimetostart
				if endTime > currentTime then
					local which = "GAMESTART"
					local t = new()
					tmp[#tmp+1] = t
					t.name = popups[which]
					t.texture = icons[which]
					t.mode = which
					t.startTime = endTime - timeoutoverrides[which]
					t.endTime = endTime
					t.isfake = true
					t.framenum = 0
				else
					gametimebase = nil
					gametimetostart = nil
				end
			end
		end

		if db.showreadycheck then
			if lfgshowbase or readycheckshowbase then
				local which = "READYCHECK"
				local endTime
				if readycheckshowbase then
					endTime = readycheckshowbase + readycheckshowduration
				else
					endTime = lfgshowbase + timeoutoverrides[which]
				end
				if endTime > currentTime then
					local t = new()
					tmp[#tmp+1] = t
					t.name = popups[which]
					t.texture = icons[which]
					t.mode = which
					t.startTime = lfgshowbase or readycheckshowbase
					t.endTime = endTime
					t.isfake = true
					t.framenum = 0
				else
					lfgshowbase = nil
					readycheckshowbase = nil
					readycheckshowduration = nil
				end
			end
		end

		if db.showmirror then
			for i = 1, MIRRORTIMER_NUMTIMERS do
				local timer, value, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
				if timer ~= "UNKNOWN" then
					local t = new()
					tmp[#tmp+1] = t
					t.name = label
					t.texture = icons[timer]
					t.mode = timer
					t.duration = maxvalue / 1000
					t.isfake = false
				end
			end
		end
		
		if db.showstatic then
			local recoverydelay = GetCorpseRecoveryDelay()
			if recoverydelay > 0 and UnitHealth("player") < 2 then
				if reztimermax == 0 then
					reztimermax = recoverydelay
				end
				local which = "REZTIMER"
				local t = new()
				tmp[#tmp+1] = t
				t.name = popups[which]
				t.texture = icons[which]
				t.mode = which
				t.startTime = currentTime - (reztimermax - recoverydelay)
				t.endTime = currentTime + recoverydelay
				t.isfake = true
				t.framenum = 0
			else
				reztimermax = 0
			end
			
			for i = 1, 4 do
				local popup = _G["StaticPopup"..i]
				local which = popup.which
				local timeleft = popup.timeleft
				local name = popups[which]
				
				--special case for a timered rez
				if which == "RESURRECT_NO_SICKNESS" then
					if timeleft > 60 then
						name = nil
					end
				end
				
				if popup:IsVisible() and name and timeleft and timeleft > 0 then
					local t = new()
					tmp[#tmp+1] = t
					t.name = name
					t.texture = icons[which]
					t.mode = which
					local timeout = StaticPopupDialogs[which].timeout
					if not timeout or timeout == 0 then
						timeout = timeoutoverrides[which]
					end
					t.startTime = currentTime - (timeout - timeleft)
					t.endTime = currentTime + timeleft
					t.isfake = true
					t.framenum = i
				end
			end
		end
		
		local external = Mirror.ExternalTimers
		for name, v in pairs(external) do
			local endTime = v.endTime
			if not v.startTime or not endTime then
				error("bad custom table")
			end
			if endTime > currentTime then
				local t = new()
				tmp[#tmp+1] = t
				t.name = name
				t.texture = v.icon or icons[name]
				t.startTime = v.startTime
				t.endTime = v.endTime
				t.isfake = true
				t.framenum = 0
				if v.color then
					t.color = v.color
				end
			else
				external[name] = del(v)
			end
		end
		
		table_sort(tmp, sort)
		local maxindex = 0
		for k=1,#tmp do
			local v = tmp[k]
			maxindex = k
			local bar = mirrorbars[k]
			bar.Text:SetText(v.name)
			bar.Icon:SetTexture(v.texture)
			bar.mode = v.mode
			if v.isfake then
				local startTime, endTime = v.startTime, v.endTime
				bar:SetMinMaxValues(startTime, endTime)
				bar.startTime = startTime
				bar.endTime = endTime
				bar.framenum = v.framenum
				bar.which = v.mode
				bar:Show()
				bar:SetScript("OnUpdate", fakeOnUpdate)
				if v.mode then
					bar:SetStatusBarColor(unpack(db[v.mode]))
				elseif v.color then
					bar:SetStatusBarColor(unpack(v.color))
				else
					bar:SetStatusBarColor(1,1,1) --!! add option
				end
			else
				local duration = v.duration
				bar:SetMinMaxValues(0, duration)
				bar.duration = duration
				bar:Show()
				bar:SetScript("OnUpdate", mirrorOnUpdate)
				bar:SetStatusBarColor(unpack(db[v.mode]))
			end
		end
		for i = maxindex+1, #mirrorbars do
			mirrorbars[i]:Hide()
			mirrorbars[i]:SetScript("OnUpdate", nil)
		end
	end
	
	function Mirror:UpdateBars()
		if not self.updateMirrorBar then
			self.updateMirrorBar = self:ScheduleTimer(update, 0) -- API funcs dont return helpful crap until after the event.
		end
	end
end
function Mirror:CHAT_MSG_BG_SYSTEM_NEUTRAL(event, msg)
	if msg:match(L["1 minute"]) or msg:match(L["One minute until"]) then
		gametimebase = GetTime()
		gametimetostart = 60
	elseif msg:match(L["30 seconds"]) or msg:match(L["Thirty seconds until"]) then
		gametimebase = GetTime()
		gametimetostart = 30
	elseif msg:match(L["15 seconds"]) or msg:match(L["Fifteen seconds until"]) then
		gametimebase = GetTime()
		gametimetostart = 15
	end
	self:UpdateBars()
end

function Mirror:LFG_PROPOSAL_SHOW(event, msg)
	lfgshowbase = GetTime()
	self:UpdateBars()
end
function Mirror:LFG_PROPOSAL_End(event, msg)
	lfgshowbase = nil
	self:UpdateBars()
end
function Mirror:READY_CHECK(event, msg, duration)
	readycheckshowbase = GetTime()
	readycheckshowduration = duration
	self:UpdateBars()
end
function Mirror:READY_CHECK_FINISHED(event, msg)
	readycheckshowbase = nil
	self:UpdateBars()
end
do
	local function apply(i, bar, db, direction)
		local position, showicons, iconside, gap, spacing, offset
		local qpdb = Player.db.profile 
		
		position = db.mirrorposition
		showicons = db.mirroricons
		iconside = db.mirroriconside
		gap = db.mirrorgap
		spacing = db.mirrorspacing
		offset = db.mirroroffset
		
		bar:ClearAllPoints()
		bar:SetStatusBarTexture(media:Fetch("statusbar", db.mirrortexture))
		bar:SetWidth(db.mirrorwidth)
		bar:SetHeight(db.mirrorheight)
		bar:SetScale(qpdb.scale)
		bar:SetAlpha(db.mirroralpha)
		
		if db.mirroranchor == "free" then
			if i == 1 then
				bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", db.mirrorx, db.mirrory)
				if db.mirrorgrowdirection == "up" then
					direction = 1
				else --L["Down"]
					direction = -1
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", mirrorbars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", mirrorbars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		else
			if i == 1 then
				local anchorframe
				local anchor = db.mirroranchor
				if anchor == "focus" and Focus and Focus.Bar then
					anchorframe = Focus.Bar
				elseif anchor == "target" and Target and Target.Bar then
					anchorframe = Target.Bar
				else -- L["Player"]
					anchorframe = Player.Bar
				end
				
				if position == "top" then
					direction = 1
					bar:SetPoint("BOTTOM", anchorframe, "TOP", 0, gap)
				elseif position == "bottom" then
					direction = -1
					bar:SetPoint("TOP", anchorframe, "BOTTOM", 0, -1 * gap)
				elseif position == "topright" then
					direction = 1
					bar:SetPoint("BOTTOMRIGHT", anchorframe, "TOPRIGHT", -1 * offset, gap)
				elseif position == "bottomright" then
					direction = -1
					bar:SetPoint("TOPRIGHT", anchorframe, "BOTTOMRIGHT", -1 * offset, -1 * gap)
				elseif position == "topleft" then
					direction = 1
					bar:SetPoint("BOTTOMLEFT", anchorframe, "TOPLEFT", offset, gap)
				elseif position == "bottomleft" then
					direction = -1
					bar:SetPoint("TOPLEFT", anchorframe, "BOTTOMLEFT", offset, -1 * gap)
				elseif position == "leftup" then
					if iconside == "right" and showicons then
						offset = offset + db.mirrorheight
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMRIGHT", anchorframe, "BOTTOMLEFT", -1 * offset, gap)
				elseif position == "leftdown" then
					if iconside == "right" and showicons then
						offset = offset + db.mirrorheight
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPRIGHT", anchorframe, "TOPLEFT", -3 * offset, -1 * gap)
				elseif position == "rightup" then
					if iconside == "left" and showicons then
						offset = offset + db.mirrorheight
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMLEFT", anchorframe, "BOTTOMRIGHT", offset, gap)
				elseif position == "rightdown" then
					if iconside == "left" and showicons then
						offset = offset + db.mirrorheight
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPLEFT", anchorframe, "TOPRIGHT", offset, -1 * gap)
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", mirrorbars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", mirrorbars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		end
		
		local timetext = bar.TimeText
		if db.mirrortimetext then
			timetext:Show()
			timetext:ClearAllPoints()
			timetext:SetWidth(db.mirrorwidth)
			timetext:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
			timetext:SetJustifyH("RIGHT")
		else
			timetext:Hide()
		end
		timetext:SetFont(media:Fetch("font", db.mirrorfont), db.mirrorfontsize)
		timetext:SetShadowColor( 0, 0, 0, 1)
		timetext:SetShadowOffset( 0.8, -0.8 )
		timetext:SetTextColor(unpack(db.mirrortextcolor))
		timetext:SetNonSpaceWrap(false)
		timetext:SetHeight(db.mirrorheight)
		
		local temptext = timetext:GetText()
		timetext:SetText("10.0")
		local normaltimewidth = timetext:GetStringWidth()
		timetext:SetText(temptext)
		
		local text = bar.Text
		if db.mirrornametext then
			text:Show()
			text:ClearAllPoints()
			text:SetPoint("LEFT", bar, "LEFT", 2, 0)
			text:SetJustifyH("LEFT")
			if db.mirrortimetext then
				text:SetWidth(db.mirrorwidth - normaltimewidth)
			else
				text:SetWidth(db.mirrorwidth)
			end
		else
			text:Hide()
		end
		text:SetFont(media:Fetch("font", db.mirrorfont), db.mirrorfontsize)
		text:SetShadowColor( 0, 0, 0, 1)
		text:SetShadowOffset( 0.8, -0.8 )
		text:SetTextColor(unpack(db.mirrortextcolor))
		text:SetNonSpaceWrap(false)
		text:SetHeight(db.mirrorheight)
		
		local icon = bar.Icon
		if showicons then
			icon:Show()
			icon:SetWidth(db.mirrorheight-1)
			icon:SetHeight(db.mirrorheight-1)
			icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			icon:ClearAllPoints()
			if iconside == "left" then
				icon:SetPoint("RIGHT", bar, "LEFT", -1, 0)
			else
				icon:SetPoint("LEFT", bar, "RIGHT", 1, 0)
			end
		else
			icon:Hide()
		end
		
		return direction
	end

	function Mirror:ApplySettings()
		db = self.db.profile
		if self:IsEnabled() then
			local direction
			if db.mirroranchor ~= "free" then
				mirrorbars[1].Hide = nil
				mirrorbars[1]:EnableMouse(false)
				mirrorbars[1]:SetScript("OnDragStart", nil)
				mirrorbars[1]:SetScript("OnDragStop", nil)
			end
			for i, v in pairs(mirrorbars) do
				direction = apply(i, v, db, direction)
			end
			if db.hideblizzmirrors then
				for i = 1, 3 do
					_G["MirrorTimer"..i]:UnregisterAllEvents()
					_G["MirrorTimer"..i]:Hide()
				end
				UIParent:UnregisterEvent("MIRROR_TIMER_START")
			else
				for i = 1, 3 do
					_G["MirrorTimer"..i]:RegisterEvent("MIRROR_TIMER_PAUSE")
					_G["MirrorTimer"..i]:RegisterEvent("MIRROR_TIMER_STOP")
				end
				UIParent:RegisterEvent("MIRROR_TIMER_START")
			end
			db.RESURRECT_NO_TIMER = db.RESURRECT_NO_SICKNESS
			self:UpdateBars()
		end
	end
end

do
	local function getmirrorhidden()
		return not db.showmirror
	end
	
	local function getstatichidden()
		return not db.showstatic
	end
	
	local function getpvphidden()
		return not db.showpvp
	end

	local function getreadycheckhidden()
		return not db.showreadycheck
	end

	local function getfreeoptionshidden()
		return db.mirroranchor ~= "free"
	end
	
	local function getnotfreeoptionshidden()
		return db.mirroranchor == "free"
	end
	
	local function dragstart()
		mirrorbars[1]:StartMoving()
	end
	
	local function dragstop()
		db.mirrorx = mirrorbars[1]:GetLeft()
		db.mirrory = mirrorbars[1]:GetBottom()
		mirrorbars[1]:StopMovingOrSizing()
	end
	
	local function nothing()
		mirrorbars[1]:SetAlpha(db.mirroralpha)
	end
	
	local positions = {
		["bottom"] = L["Bottom"],
		["top"] = L["Top"],
		["topleft"] = L["Top Left"],
		["topright"] = L["Top Right"],
		["bottomleft"] = L["Bottom Left"],
		["bottomright"] = L["Bottom Right"],
		["leftup"] = L["Left (grow up)"],
		["leftdown"] = L["Left (grow down)"],
		["rightup"] = L["Right (grow up)"],
		["rightdown"] = L["Right (grow down)"],
	}
	
	local function setOpt(info, value)
		db[info[#info]] = value
		Mirror:ApplySettings()
	end

	local function getOpt(info)
		return db[info[#info]]
	end

	local function getColor(info)
		return unpack(getOpt(info))
	end

	local function setColor(info, r, g, b, a)
		setOpt(info, {r, g, b, a})
	end

	local options
	function getOptions()
		if not options then
			options = {
				type = "group",
				name = L["Mirror"],
				order = 600,
				set = setOpt,
				get = getOpt,
				childGroups = "tab",
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
						order = 96,
						width = "full",
					},
					settings = {
						type = "group",
						name = L["Settings"],
						args = {
							mirroranchor = {
								type = "select",
								name = L["Anchor Frame"],
								desc = L["Select where to anchor the bars"],
								values = {["player"] = L["Player"], ["free"] = L["Free"], ["target"] = L["Target"], ["focus"] = L["Focus"]},
							},
							-- free
							mirrorlock = {
								type = "toggle",
								name = L["Lock"],
								desc = L["Toggle bar lock"],
								get = function()
									return locked
								end,
								set = function(info, v)
									if v then
										mirrorbars[1].Hide = nil
										mirrorbars[1]:EnableMouse(false)
										mirrorbars[1]:SetScript("OnDragStart", nil)
										mirrorbars[1]:SetScript("OnDragStop", nil)
										Mirror:UpdateBars()
									else
										mirrorbars[1]:Show()
										mirrorbars[1]:EnableMouse(true)
										mirrorbars[1]:SetScript("OnDragStart", dragstart)
										mirrorbars[1]:SetScript("OnDragStop", dragstop)
										mirrorbars[1]:SetAlpha(1)
										mirrorbars[1].Hide = nothing
									end
									locked = v
								end,
								hidden = getfreeoptionshidden,
								order = 98,
							},
							mirrorgrowdirection = {
								type = "select",
								name = L["Grow Direction"],
								desc = L["Set the grow direction of the bars"],
								values = {["up"] = L["Up"], ["down"] = L["Down"]},
								hidden = getfreeoptionshidden,
								order = 102,
							},
							mirrorx = {
								type = "range",
								name = L["X"],
								desc = L["Set an exact X value for this bar's position."],
								min = 0, max = 2560, bigStep = 1,
								order = 103,
								hidden = getfreeoptionshidden,
							},
							mirrory = {
								type = "range",
								name = L["Y"],
								desc = L["Set an exact Y value for this bar's position."],
								min = 0, max = 1600, bigStep = 1,
								order = 103,
								hidden = getfreeoptionshidden,
							},
							-- anchored to a cast bar
							mirrorposition = {
								type = "select",
								name = L["Position"],
								desc = L["Position the bars"],
								values = positions,
								hidden = getnotfreeoptionshidden,
								order = 101,
							},
							mirrorgap = {
								type = "range",
								name = L["Gap"],
								desc = L["Tweak the vertical position of the bars"],
								min = -35, max = 35, step = 1,
								hidden = getnotfreeoptionshidden,
								order = 102,
							},
							mirroroffset = {
								type = "range",
								name = L["Offset"],
								desc = L["Tweak the horizontal position of the bars"],
								min = -35, max = 35, step = 1,
								hidden = getnotfreeoptionshidden,
								order = 103,
							},
							mirrorspacing = {
								type = "range",
								name = L["Spacing"],
								desc = L["Tweak the space between bars"],
								min = -35, max = 35, step = 1,
								order = 104,
							},
							nl4 = {
								type = "description",
								name = "",
								order = 109,
							},
							mirroricons = {
								type = "toggle",
								name = L["Show Icons"],
								desc = L["Show icons on the bars"],
								order = 110,
							},
							mirroriconside = {
								type = "select",
								name = L["Icon Position"],
								desc = L["Set the side of the bar that the icon appears on"],
								values = {["left"] = L["Left"], ["right"] = L["Right"]},
								order = 111,
							},
							mirrortexture = {
								type = "select",
								dialogControl = "LSM30_Statusbar",
								name = L["Texture"],
								desc = L["Set the bar Texture"],
								values = lsmlist.statusbar,
								order = 112,
							},
							nl5 = {
								type = "description",
								name = "",
								order = 113,
							},
							mirrorwidth = {
								type = "range",
								name = L["Mirror Bar Width"],
								desc = L["Set the width of the bars"],
								min = 50, max = 300, step = 1,
								order = 114,
							},
							mirrorheight = {
								type = "range",
								name = L["Mirror Bar Height"],
								desc = L["Set the height of the bars"],
								min = 4, max = 25, step = 1,
								order = 115,
							},
							mirroralpha = {
								type = "range",
								name = L["Alpha"],
								desc = L["Set the alpha of the bars"],
								min = 0.05, max = 1, bigStep = 0.05,
								isPercent = true,
								order = 116,
							},
							nl6 = {
								type = "description",
								name = "",
								order = 119,
							},
							mirrornametext = {
								type = "toggle",
								name = L["Name Text"],
								desc = L["Display the names of Mirror Bar Types on their bars"],
								order = 120,
							},
							mirrortimetext = {
								type = "toggle",
								name = L["Time Text"],
								desc = L["Display the time remaining on the bars"],
								order = 121,
							},
							mirrorfont = {
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								desc = L["Set the font used in the bars"],
								values = lsmlist.font,
								order = 122,
							},
							mirrorfontsize = {
								type = "range",
								name = L["Font Size"],
								desc = L["Set the font size for the bars"],
								min = 3, max = 15, step = 1,
								order = 123,
							},
							mirrortextcolor = {
								type = "color",
								name = L["Text Color"],
								desc = L["Set the color of the text for the bars"],
								get = getColor,
								set = setColor,
								order = 124,
							},
							hideblizzmirrors = {
								type = "toggle",
								name = L["Hide Blizz Mirror Bars"],
								desc = L["Hide Blizzard's mirror bars"],
								order = 130,
							},
						}
					},
					bars = {
						type = "group",
						name = L["Bars and Colors"],
						order = -1,
						args = {
							-- mirror
							showmirror = {
								type = "toggle",
								name = L["Show Mirror"],
								desc = L["Show mirror bars such as breath and feign death"],
								order = 97,
								width = "full",
							},
							BREATH = {
								type = "color",
								name = L["%s Color"]:format(L["Breath"]),
								desc = L["Set the color of the bars for %s"]:format(L["Breath"]),
								get = getColor,
								set = setColor,
								disabled = getmirrorhidden,
								order = 101,
							},
							EXHAUSTION = {
								type = "color",
								name = L["%s Color"]:format(L["Exhaustion"]),
								desc = L["Set the color of the bars for %s"]:format(L["Exhaustion"]),
								get = getColor,
								set = setColor,
								disabled = getmirrorhidden,
								order = 101,
							},
							FEIGNDEATH = {
								type = "color",
								name = L["%s Color"]:format(L["Feign Death"]),
								desc = L["Set the color of the bars for %s"]:format(L["Feign Death"]),
								get = getColor,
								set = setColor,
								disabled = getmirrorhidden,
								order = 101,
							},
							-- static
							showstatic = {
								type = "toggle",
								name = L["Show Static"],
								desc = L["Show bars for static popup items such as rez and summon timers"],
								order = 200,
								width = "full",
							},
							CAMP = {
								type = "color",
								name = L["%s Color"]:format(L["Logout"]),
								desc = L["Set the color of the bars for %s"]:format(L["Logout"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							DEATH = {
								type = "color",
								name = L["%s Color"]:format(L["Release"]),
								desc = L["Set the color of the bars for %s"]:format(L["Release"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							QUIT = {
								type = "color",
								name = L["%s Color"]:format(L["Quit"]),
								desc = L["Set the color of the bars for %s"]:format(L["Quit"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							DUEL_OUTOFBOUNDS = {
								type = "color",
								name = L["%s Color"]:format(L["Forfeit Duel"]),
								desc = L["Set the color of the bars for %s"]:format(L["Forfeit Duel"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							INSTANCE_BOOT = {
								type = "color",
								name = L["%s Color"]:format(L["Instance Boot"]),
								desc = L["Set the color of the bars for %s"]:format(L["Instance Boot"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							CONFIRM_SUMMON = {
								type = "color",
								name = L["%s Color"]:format(L["Summon"]),
								desc = L["Set the color of the bars for %s"]:format(L["Summon"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							AREA_SPIRIT_HEAL = {
								type = "color",
								name = L["%s Color"]:format(L["AOE Rez"]),
								desc = L["Set the color of the bars for %s"]:format(L["AOE Rez"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							REZTIMER = {
								type = "color",
								name = L["%s Color"]:format(L["Resurrect Timer"]),
								desc = L["Set the color of the bars for %s"]:format(L["Resurrect Timer"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							RESURRECT_NO_SICKNESS = {
								type = "color",
								name = L["%s Color"]:format(L["Resurrect"]),
								desc = L["Set the color of the bars for %s"]:format(L["Resurrect"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							PARTY_INVITE = {
								type = "color",
								name = L["%s Color"]:format(L["Party Invite"]),
								desc = L["Set the color of the bars for %s"]:format(L["Party Invite"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							DUEL_REQUESTED = {
								type = "color",
								name = L["%s Color"]:format(L["Duel Request"]),
								desc = L["Set the color of the bars for %s"]:format(L["Duel Request"]),
								get = getColor,
								set = setColor,
								disabled = getstatichidden,
								order = 201,
							},
							--pvp
							showpvp = {
								type = "toggle",
								name = L["Show PvP"],
								desc = L["Show bar for start of arena and battleground games"],
								order = 300,
								width = "full",
							},
							GAMESTART = {
								type = "color",
								name = L["%s Color"]:format(L["Game Start"]),
								desc = L["Set the color of the bars for %s"]:format(L["Game Start"]),
								get = getColor,
								set = setColor,
								disabled = getpvphidden,
								order = 301,
							},
							--ready check
							showreadycheck = {
								type = "toggle",
								name = L["Show Ready Check"],
								desc = L["Show bar for Ready Checks"],
								order = 500,
								width = "full",
							},
							READYCHECK = {
								type = "color",
								name = L["%s Color"]:format(READY_CHECK),
								desc = L["Set the color of the bars for %s"]:format(READY_CHECK),
								get = getColor,
								set = setColor,
								disabled = getreadycheckhidden,
								order = 501,
							},
						},
					},
				},
			}
		end
		return options
	end
end
