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

local media = LibStub("LibSharedMedia-3.0")
local lsmlist = AceGUIWidgetLSMlists

----------------------------
-- Upvalues
local min, type, format, unpack, setmetatable = math.min, type, string.format, unpack, setmetatable
local CreateFrame, GetTime, UIParent = CreateFrame, GetTime, UIParent
local UnitName, UnitCastingInfo, UnitChannelInfo = UnitName, UnitCastingInfo, UnitChannelInfo

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

local CastBarTemplate = CreateFrame("Frame")
local CastBarTemplate_MT = {__index = CastBarTemplate}

local TimeFmt = Quartz3.Util.TimeFormat

local playerName = UnitName("player")

local function call(obj, method, ...)
	if type(obj.parent[method]) == "function" then
		return obj.parent[method](obj.parent, obj, ...)
	end
end

----------------------------
-- Frame Scripts

-- OnShow and OnHide are not used by the template
-- But forward the call to the embeding module, they might use it.
local function OnShow(self)
	call(self, "OnShow")
end

local function OnHide(self)
	call(self, "OnHide")
end

-- OnUpdate handles the bar movement and the text updates
local function OnUpdate(self)
	local currentTime = GetTime()
	local startTime, endTime, delay = self.startTime, self.endTime, self.delay
	local db = self.config
	if self.channeling or self.casting then
		local perc, remainingTime, delayFormat, delayFormatTime
		if self.casting then
			local showTime = min(currentTime, endTime)
			remainingTime = endTime - showTime
			perc = (showTime - startTime) / (endTime - startTime)

			delayFormat, delayFormatTime = "|cffff0000+%.1f|cffffffff %s", "|cffff0000+%.1f|cffffffff %s / %s"
		elseif self.channeling then
			remainingTime = endTime - currentTime
			perc = remainingTime / (endTime - startTime)
			
			delayFormat, delayFormatTime = "|cffff0000-%.1f|cffffffff %s", "|cffff0000-%.1f|cffffffff %s / %s"
		end

		self.Bar:SetValue(perc)
		self.Spark:ClearAllPoints()
		self.Spark:SetPoint("CENTER", self.Bar, "LEFT", perc * self.Bar:GetWidth(), 0)

		if delay and delay ~= 0 then
			if db.hidecasttime then
				self.TimeText:SetFormattedText("|cffff0000+%.1f|cffffffff %s", delay, format(TimeFmt(remainingTime)))
			else
				self.TimeText:SetFormattedText("|cffff0000+%.1f|cffffffff %s / %s", delay, format(TimeFmt(remainingTime)), format(TimeFmt(endTime - startTime, true)))
			end
		else
			if db.hidecasttime then
				self.TimeText:SetFormattedText(TimeFmt(remainingTime))
			else
				self.TimeText:SetFormattedText("%s / %s", format(TimeFmt(remainingTime)), format(TimeFmt(endTime - startTime, true)))
			end
		end

		if currentTime > endTime then
			self.casting, self.channeling = nil, nil
			self.fadeOut = true
			self.stopTime = currentTime
		end
	elseif self.fadeOut then
		self.Spark:Hide()
		local alpha
		local stopTime = self.stopTime
		if stopTime then
			alpha = stopTime - currentTime + 1
		else
			alpha = 0
		end
		if alpha >= 1 then
			alpha = 1
		end
		if alpha <= 0 then
			self.stopTime = nil
			self:Hide()
		else
			self:SetAlpha(alpha*db.alpha)
		end
	else
		self:Hide()
	end
end
CastBarTemplate.OnUpdate = OnUpdate

local function OnEvent(self, event, ...)
	if self[event] then
		self[event](self, event, ...)
	end
end

----------------------------
-- Template Methods

local function SetNameText(self, name)
	if self.config.targetname and self.targetName and self.targetName ~= "" then
		self.Text:SetFormattedText("%s -> %s", name, self.targetName)
	else
		self.Text:SetText(name)
	end
end
CastBarTemplate.SetNameText = SetNameText

local function ToggleCastNotInterruptible(self, notInterruptible, init)
	if self.unit == "player" and not init then return end
	local db = self.config

	if notInterruptible and db.noInterruptChangeColor then
		self.Bar:SetStatusBarColor(unpack(db.noInterruptColor))
	end

	local r, g, b, a
	if notInterruptible and db.noInterruptChangeBorder then
		self.backdrop.edgeFile = media:Fetch("border", db.noInterruptBorder)
		r,g,b = unpack(db.noInterruptBorderColor)
		a = db.noInterruptBorderAlpha
	else
		self.backdrop.edgeFile = media:Fetch("border", db.border)
		r,g,b = unpack(Quartz3.db.profile.bordercolor)
		a = Quartz3.db.profile.borderalpha
	end
	self:SetBackdrop(self.backdrop)
	self:SetBackdropBorderColor(r, g, b, a)

	r, g, b = unpack(Quartz3.db.profile.backgroundcolor)
	self:SetBackdropColor(r, g, b, Quartz3.db.profile.backgroundalpha)

	if self.Shield then
		if notInterruptible and db.noInterruptShield and not db.hideicon then
			self.Shield:Show()
		else
			self.Shield:Hide()
		end
	end

	self.lastNotInterruptible = notInterruptible
end
CastBarTemplate.ToggleCastNotInterruptible = ToggleCastNotInterruptible

----------------------------
-- Event Handlers

function CastBarTemplate:UNIT_SPELLCAST_SENT(event, unit, target, guid, spellID)
	if unit ~= self.unit and not (self.unit == "player" and unit == "vehicle") then
		return
	end
	if target then
		self.targetName = target
	else
		-- auto selfcast? is this needed, even?
		self.targetName = playerName
	end

	call(self, "UNIT_SPELLCAST_SENT", unit, target, guid, spellID)
end

function CastBarTemplate:UNIT_SPELLCAST_START(event, unit, guid, spellID)
	if (unit ~= self.unit and not (self.unit == "player" and unit == "vehicle")) or call(self, "PreShowCondition", unit) then
		return
	end
	local db = self.config
	if event == "UNIT_SPELLCAST_START" then
		self.casting, self.channeling = true, nil
	else
		self.casting, self.channeling = nil, true
	end

	local spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible
	if self.casting then
		spell, displayName, icon, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit)
	else -- self.channeling
		spell, displayName, icon, startTime, endTime, isTradeSkill, notInterruptible = UnitChannelInfo(unit)
		-- channeling spells sometimes just display "Channeling" - this is not wanted
		displayName = spell
	end
	-- in case this returned nothing
	if not startTime or not endTime then return end

	startTime = startTime / 1000
	endTime = endTime / 1000
	self.startTime = startTime
	self.endTime = endTime
	self.delay = 0
	self.fadeOut = nil

	self.Bar:SetStatusBarColor(unpack(self.casting and Quartz3.db.profile.castingcolor or Quartz3.db.profile.channelingcolor))

	self.Bar:SetValue(self.casting and 0 or 1)
	self:Show()
	self:SetAlpha(db.alpha)

	SetNameText(self, displayName)

	self.Spark:Show()

	if (icon == "Interface\\Icons\\Temp" or icon == 136235) and Quartz3.db.profile.hidesamwise then
		icon = nil
	end
	self.Icon:SetTexture(icon)

	local position = db.timetextposition
	if position == "caststart" or position == "castend" then
		if (position == "caststart" and self.casting) or (position == "castend" and self.channeling) then
			self.TimeText:SetPoint("LEFT", self.Bar, "LEFT", db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("LEFT")
		else
			self.TimeText:SetPoint("RIGHT", self.Bar, "RIGHT", -1 * db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("RIGHT")
		end
	end

	ToggleCastNotInterruptible(self, notInterruptible)

	call(self, "UNIT_SPELLCAST_START", unit, guid, spellID)
end
CastBarTemplate.UNIT_SPELLCAST_CHANNEL_START = CastBarTemplate.UNIT_SPELLCAST_START

function CastBarTemplate:UNIT_SPELLCAST_STOP(event, unit)
	if not (self.channeling or self.casting) or (unit ~= self.unit and not (self.unit == "player" and unit == "vehicle")) then
		return
	end

	self.Bar:SetValue(self.casting and 1.0 or 0)
	self.Bar:SetStatusBarColor(unpack(Quartz3.db.profile.completecolor))

	self.casting, self.channeling = nil, nil
	self.fadeOut = true
	self.stopTime = GetTime()

	self.TimeText:SetText("")

	call(self, "UNIT_SPELLCAST_STOP", unit)
end
CastBarTemplate.UNIT_SPELLCAST_CHANNEL_STOP = CastBarTemplate.UNIT_SPELLCAST_STOP

function CastBarTemplate:UNIT_SPELLCAST_FAILED(event, unit)
	if self.channeling or self.casting or (unit ~= self.unit and not (self.unit == "player" and unit == "vehicle")) then
		return
	end
	self.fadeOut = true
	if not self.stopTime then
		self.stopTime = GetTime()
	end
	self.Bar:SetValue(1.0)
	self.Bar:SetStatusBarColor(unpack(Quartz3.db.profile.failcolor))

	self.TimeText:SetText("")

	call(self, "UNIT_SPELLCAST_FAILED", unit)
end

function CastBarTemplate:UNIT_SPELLCAST_INTERRUPTED(event, unit)
	if unit ~= self.unit and not (self.unit == "player" and unit == "vehicle") then
		return
	end
	self.casting, self.channeling = nil, nil
	self.fadeOut = true
	if not self.stopTime then
		self.stopTime = GetTime()
	end
	self.Bar:SetValue(1.0)
	self.Bar:SetStatusBarColor(unpack(Quartz3.db.profile.failcolor))

	self.TimeText:SetText("")

	call(self, "UNIT_SPELLCAST_INTERRUPTED", unit)
end

function CastBarTemplate:UNIT_SPELLCAST_DELAYED(event, unit)
	if unit ~= self.unit and not (self.unit == "player" and unit == "vehicle") or call(self, "PreShowCondition", unit) then
		return
	end
	local oldStart = self.startTime
	local spell, displayName, icon, startTime, endTime
	if self.casting then
		spell, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
	else
		spell, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
	end

	if not startTime or not endTime then
		return self:Hide()
	end

	startTime = startTime / 1000
	endTime = endTime / 1000
	self.startTime = startTime
	self.endTime = endTime

	if self.casting then
		self.delay = (self.delay or 0) + (startTime - (oldStart or startTime))
	else
		self.delay = (self.delay or 0) + ((oldStart or startTime) - startTime)
	end

	call(self, "UNIT_SPELLCAST_DELAYED", unit)
end
CastBarTemplate.UNIT_SPELLCAST_CHANNEL_UPDATE = CastBarTemplate.UNIT_SPELLCAST_DELAYED


function CastBarTemplate:UNIT_SPELLCAST_INTERRUPTIBLE(event, unit)
	if unit ~= self.unit then
		return
	end
	ToggleCastNotInterruptible(self, false)
end

function CastBarTemplate:UNIT_SPELLCAST_NOT_INTERRUPTIBLE(event, unit)
	if unit ~= self.unit then
		return
	end
	ToggleCastNotInterruptible(self, true)
end

function CastBarTemplate:UpdateUnit()
	if UnitCastingInfo(self.unit) then
		self:UNIT_SPELLCAST_START("UNIT_SPELLCAST_START", self.unit)
	elseif UnitChannelInfo(self.unit) then
		self:UNIT_SPELLCAST_START("UNIT_SPELLCAST_CHANNEL_START", self.unit)
	else
		self:Hide()
	end
end

function CastBarTemplate:SetConfig(config)
	self.config = config
end

function CastBarTemplate:ApplySettings()
	local db = self.config

	self:ClearAllPoints()
	if not db.x then
		db.x = (UIParent:GetWidth() / 2 - (db.w * db.scale) / 2) / db.scale
	end
	self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", db.x, db.y)
	self:SetWidth(db.w + 10)
	self:SetHeight(db.h + 10)
	self:SetAlpha(db.alpha)
	self:SetScale(db.scale)

	ToggleCastNotInterruptible(self, self.lastNotInterruptible, true)

	local iconwidth = db.h + db.icongap
	local iconoffset = db.hideicon and 0 or (iconwidth/2 * (db.iconposition == "left" and 1 or -1))
	local castbarwidth = db.hideicon and db.w or db.w-iconwidth
	self.Bar:ClearAllPoints()
	self.Bar:SetPoint("CENTER",self,"CENTER", iconoffset, 0)
	self.Bar:SetWidth(castbarwidth)
	self.Bar:SetHeight(db.h)
	self.Bar:SetStatusBarTexture(media:Fetch("statusbar", db.texture))
	self.Bar:SetMinMaxValues(0, 1)

	if db.hidetimetext then
		self.TimeText:Hide()
	else
		self.TimeText:Show()
		self.TimeText:ClearAllPoints()
		self.TimeText:SetWidth(castbarwidth)
		local position = db.timetextposition
		if position == "left" then
			self.TimeText:SetPoint("LEFT", self.Bar, "LEFT", db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("LEFT")
		elseif position == "center" then
			self.TimeText:SetPoint("CENTER", self.Bar, "CENTER", db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("CENTER")
		elseif position == "centerback" then
			self.TimeText:SetPoint("CENTER", self, "CENTER", db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("CENTER")
		elseif position == "right" then
			self.TimeText:SetPoint("RIGHT", self.Bar, "RIGHT", -1 * db.timetextx, db.timetexty)
			self.TimeText:SetJustifyH("RIGHT")
		end -- L["Cast Start Side"], L["Cast End Side"] -- handled at runtime
	end
	self.TimeText:SetFont(media:Fetch("font", db.font), db.timefontsize)
	self.TimeText:SetShadowColor( 0, 0, 0, 1)
	self.TimeText:SetShadowOffset( 0.8, -0.8 )
	self.TimeText:SetTextColor(unpack(Quartz3.db.profile.timetextcolor))
	self.TimeText:SetNonSpaceWrap(false)
	self.TimeText:SetHeight(db.h)

	local temptext = self.TimeText:GetText()
	if db.hidecasttime then
		self.TimeText:SetFormattedText(TimeFmt(10))
	else
		self.TimeText:SetFormattedText("%s / %s", format(TimeFmt(10)), format(TimeFmt(10, true)))
	end
	local normaltimewidth = self.TimeText:GetStringWidth()
	self.TimeText:SetText(temptext)

	if db.hidenametext then
		self.Text:Hide()
	else
		self.Text:Show()
		self.Text:ClearAllPoints()
		local position = db.nametextposition
		if position == "left" then
			self.Text:SetPoint("LEFT", self.Bar, "LEFT", db.nametextx, db.nametexty)
			self.Text:SetJustifyH("LEFT")
			if db.hidetimetext or db.timetextposition ~= "right" then
				self.Text:SetWidth(castbarwidth)
			else
				self.Text:SetWidth(castbarwidth - normaltimewidth - 5)
			end
		elseif position == "center" then
			self.Text:SetPoint("CENTER", self.Bar, "CENTER", db.nametextx, db.nametexty)
			self.Text:SetJustifyH("CENTER")
		elseif position == "centerback" then
			self.Text:SetPoint("CENTER", self, "CENTER", db.nametextx, db.nametexty)
			self.Text:SetJustifyH("CENTER")
		else -- L["Right"]
			self.Text:SetPoint("RIGHT", self.Bar, "RIGHT", -1 * db.nametextx, db.nametexty)
			self.Text:SetJustifyH("RIGHT")
			if db.hidetimetext or db.timetextposition ~= "left" then
				self.Text:SetWidth(castbarwidth)
			else
				self.Text:SetWidth(castbarwidth - normaltimewidth - 5)
			end
		end
	end
	self.Text:SetFont(media:Fetch("font", db.font), db.fontsize)
	self.Text:SetShadowColor( 0, 0, 0, 1)
	self.Text:SetShadowOffset( 0.8, -0.8 )
	self.Text:SetTextColor(unpack(Quartz3.db.profile.spelltextcolor))
	self.Text:SetNonSpaceWrap(false)
	self.Text:SetHeight(db.h)

	if db.hideicon then
		self.Icon:Hide()
	else
		self.Icon:Show()
		self.Icon:ClearAllPoints()
		if db.iconposition == "left" then
			self.Icon:SetPoint("RIGHT", self.Bar, "LEFT", -1 * db.icongap, 0)
		else --L["Right"]
			self.Icon:SetPoint("LEFT", self.Bar, "RIGHT", db.icongap, 0)
		end
		self.Icon:SetWidth(db.h)
		self.Icon:SetHeight(db.h)
		self.Icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		self.Icon:SetAlpha(db.iconalpha)
	end

	self.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	self.Spark:SetVertexColor(unpack(Quartz3.db.profile.sparkcolor))
	self.Spark:SetBlendMode("ADD")
	self.Spark:SetWidth(20)
	self.Spark:SetHeight(db.h*2.2)

	if self.Shield then
		local scale = (db.h/25)
		self.Shield:SetWidth(36 * scale)
		self.Shield:SetHeight(64 * scale)
		self.Shield:ClearAllPoints()
		self.Shield:SetPoint("CENTER", self.Icon, "CENTER", -2 * scale, -1 * scale)
	end
end

function CastBarTemplate:RegisterEvents()
	if self.unit == "player" then
		self:RegisterEvent("UNIT_SPELLCAST_SENT")
	end
	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("UNIT_SPELLCAST_STOP")
	self:RegisterEvent("UNIT_SPELLCAST_FAILED")
	self:RegisterEvent("UNIT_SPELLCAST_DELAYED")
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
	self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
	if self.unit ~= "player" then
		self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTIBLE")
		self:RegisterEvent("UNIT_SPELLCAST_NOT_INTERRUPTIBLE")
	end

	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			self.Bar:SetStatusBarTexture(media:Fetch("statusbar", override))
		end
	end)

	media.RegisterCallback(self, "LibSharedMedia_Registered", function(mtype, key)
		if mtype == "statusbar" and key == self.config.texture then
			self.Bar:SetStatusBarTexture(media:Fetch("statusbar", self.config.texture))
		end
	end)
end

function CastBarTemplate:UnregisterEvents()
	self:UnregisterAllEvents()
	media.UnregisterCallback(self, "LibSharedMedia_SetGlobal")
	media.UnregisterCallback(self, "LibSharedMedia_Registered")
end

do
	local function dragstart(self)
		self:StartMoving()
	end

	local function dragstop(self)
		self.config.x = self:GetLeft()-UIParent:GetLeft()
		self.config.y = self:GetBottom()-UIParent:GetBottom()
		self:StopMovingOrSizing()
	end

	local function nothing(self)
		self:SetAlpha(self.config.alpha)
	end

	function CastBarTemplate:Unlock()
		self:Show()
		self:EnableMouse(true)
		self:SetScript("OnDragStart", dragstart)
		self:SetScript("OnDragStop", dragstop)
		self:SetAlpha(1)
		self.Hide = nothing
		self.Icon:SetTexture("Interface\\Icons\\Temp")
		self.Text:SetText(self.unit)
	end

	function CastBarTemplate:Lock()
		self.Hide = nil
		self:EnableMouse(false)
		self:SetScript("OnDragStart", nil)
		self:SetScript("OnDragStop", nil)
		if not (self.channeling or self.casting) then
			self:Hide()
		end
	end
end


----------------------------
-- Options

do
	local function getBar(info)
		return Quartz3.CastBarTemplate.bars[info[1]]
	end

	local function hideiconoptions(info)
		local db = getBar(info).config
		return db.hideicon
	end

	local function hidetimetextoptions(info)
		local db = getBar(info).config
		return db.hidetimetext
	end

	local function hidecasttimeprecision(info)
		local db = getBar(info).config
		return db.hidetimetext or db.hidecasttime
	end

	local function hidenametextoptions(info)
		local db = getBar(info).config
		return db.hidenametext
	end

	local function noInterruptChangeBorder(info)
		local db = getBar(info).config
		return not db.noInterruptChangeBorder
	end

	local function noInterruptChangeColor(info)
		local db = getBar(info).config
		return not db.noInterruptChangeColor
	end
	
	local function icondisabled(info)
		local db = getBar(info).config
		return db.hideicon
	end

	local function snapToCenter(info, v)
		local bar = getBar(info)
		local scale = bar.config.scale
		if v == "horizontal" then
			bar.config.x = (UIParent:GetWidth() / 2 - (bar.config.w * scale) / 2) / scale
		else -- L["Vertical"]
			bar.config.y = (UIParent:GetHeight() / 2 - (bar.config.h * scale) / 2) / scale
		end
		bar:ApplySettings()
	end

	local function copySettings(info, v)
		local bar = getBar(info)
		local from = Quartz3:GetModule(v)
		Quartz3:CopySettings(from.db.profile, bar.config)
		bar:ApplySettings()
	end

	local function getEnabled(info)
		local bar = getBar(info)
		return Quartz3:GetModuleEnabled(bar.modName)
	end

	local function setEnabled(info, v)
		local bar = getBar(info)
		return Quartz3:SetModuleEnabled(bar.modName, v)
	end

	local function getOpt(info)
		local db = getBar(info).config
		return db[info[#info]]
	end

	local function setOpt(info, value)
		local bar = getBar(info)
		bar.config[info[#info]] = value
		bar:ApplySettings()
	end

	local function getColor(info)
		return unpack(getOpt(info))
	end

	local function setColor(info, ...)
		setOpt(info, {...})
	end

	function CastBarTemplate:CreateOptions()
		local options = {
			type = "group",
			name = self.localizedName,
			get = getOpt,
			set = setOpt,
			args = {
				toggle = {
					type = "toggle",
					name = L["Enable"],
					desc = L["Enable"],
					get = getEnabled,
					set = setEnabled,
					order = 99,
					width = "full",
				},
				h = {
					type = "range",
					name = L["Height"],
					desc = L["Height"],
					min = 10, max = 50, step = 1,
					order = 200,
				},
				w = {
					type = "range",
					name = L["Width"],
					desc = L["Width"],
					min = 50, max = 1500, bigStep = 5,
					order = 200,
				},
				x = {
					type = "range",
					name = L["X"],
					desc = L["Set an exact X value for this bar's position."],
					min = -2560, max = 2560, bigStep = 1,
					order = 200,
				},
				y = {
					type = "range",
					name = L["Y"],
					desc = L["Set an exact Y value for this bar's position."],
					min = -1600, max = 1600, bigStep = 1,
					order = 200,
				},
				scale = {
					type = "range",
					name = L["Scale"],
					desc = L["Scale"],
					min = 0.2, max = 1, bigStep = 0.025,
					order = 201,
				},
				alpha = {
					type = "range",
					name = L["Alpha"],
					desc = L["Alpha"],
					isPercent = true,
					min = 0.1, max = 1, bigStep = 0.025,
					order = 202,
				},
				icon = {
					type = "header",
					name = L["Icon"],
					order = 300,
				},
				hideicon = {
					type = "toggle",
					name = L["Hide Icon"],
					desc = L["Hide Spell Cast Icon"],
					order = 301,
				},
				iconposition = {
					type = "select",
					name = L["Icon Position"],
					desc = L["Set where the Spell Cast icon appears"],
					disabled = hideiconoptions,
					values = {["left"] = L["Left"], ["right"] = L["Right"]},
					order = 301,
				},
				iconalpha = {
					type = "range",
					name = L["Icon Alpha"],
					desc = L["Set the Spell Cast icon alpha"],
					isPercent = true,
					min = 0.1, max = 1, bigStep = 0.025,
					order = 302,
					disabled = hideiconoptions,
				},
				icongap = {
					type = "range",
					name = L["Icon Gap"],
					desc = L["Space between the cast bar and the icon."],
					min = -35, max = 35, bigStep = 1,
					order = 302,
					disabled = hideiconoptions,
				},
				fonthead = {
					type = "header",
					name = L["Font and Text"],
					order = 398,
				},
				font = {
					type = "select",
					dialogControl = "LSM30_Font",
					name = L["Font"],
					desc = L["Set the font used in the Name and Time texts"],
					values = lsmlist.font,
					order = 399,
				},
				nlfont = {
					type = "description",
					name = "",
					order = 400,
				},
				hidenametext = {
					type = "toggle",
					name = L["Hide Spell Name"],
					desc = L["Disable the text that displays the spell name"],
					order = 401,
				},
				nlname = {
					type = "description",
					name = "",
					order = 403,
				},
				nametextposition = {
					type = "select",
					name = L["Spell Name Position"],
					desc = L["Set the alignment of the spell name text"],
					values = {["left"] = L["Left"], ["right"] = L["Right"], ["center"] = L["Center (CastBar)"], ["centerback"] = L["Center (Backdrop)"]},
					disabled = hidenametextoptions,
					order = 404,
				},
				fontsize = {
					type = "range",
					name = L["Spell Name Font Size"],
					desc = L["Set the size of the spell name text"],
					min = 7, max = 20, step = 1,
					order = 405,
					disabled = hidenametextoptions,
				},
				nametextx = {
					type = "range",
					name = L["Spell Name X Offset"],
					desc = L["Adjust the X position of the spell name text"],
					min = -35, max = 35, step = 1,
					disabled = hidenametextoptions,
					order = 406,
				},
				nametexty = {
					type = "range",
					name = L["Spell Name Y Offset"],
					desc = L["Adjust the Y position of the name text"],
					min = -35, max = 35, step = 1,
					disabled = hidenametextoptions,
					order = 407,
				},
				hidetimetext = {
					type = "toggle",
					name = L["Hide Time Text"],
					desc = L["Disable the text that displays the time remaining on your cast"],
					order = 411,
				},
				hidecasttime = {
					type = "toggle",
					name = L["Hide Cast Time"],
					desc = L["Disable the text that displays the total cast time"],
					disabled = hidetimetextoptions,
					order = 412,
				},
				timefontsize = {
					type = "range",
					name = L["Time Font Size"],
					desc = L["Set the size of the time text"],
					min = 7, max = 20, step = 1,
					order = 414,
					disabled = hidetimetextoptions,
				},
				timetextposition = {
					type = "select",
					name = L["Time Text Position"],
					desc = L["Set the alignment of the time text"],
					values = {["left"] = L["Left"], ["right"] = L["Right"], ["center"] = L["Center (CastBar)"], ["centerback"] = L["Center (Backdrop)"], ["caststart"] = L["Cast Start Side"], ["castend"] = L["Cast End Side"]},
					disabled = hidetimetextoptions,
					order = 415,
				},
				timetextx = {
					type = "range",
					name = L["Time Text X Offset"],
					desc = L["Adjust the X position of the time text"],
					min = -35, max = 35, step = 1,
					disabled = hidetimetextoptions,
					order = 416,
				},
				timetexty = {
					type = "range",
					name = L["Time Text Y Offset"],
					desc = L["Adjust the Y position of the time text"],
					min = -35, max = 35, step = 1,
					disabled = hidetimetextoptions,
					order = 417,
				},
				textureheader = {
					type = "header",
					name = L["Texture and Border"],
					order = 450,
				},
				texture = {
					type = "select",
					dialogControl = "LSM30_Statusbar",
					name = L["Texture"],
					desc = L["Set the Cast Bar Texture"],
					values = lsmlist.statusbar,
					order = 451,
				},
				border = {
					type = "select",
					dialogControl = "LSM30_Border",
					name = L["Border"],
					desc = L["Set the border style"],
					values = lsmlist.border,
					order = 452,
				},
				noInterruptGroup = {
					type = "group",
					name = L["No interrupt cast bars"],
					dialogInline = true,
					order = 455,
					args = {
						noInterruptChangeBorder = {
							type = "toggle",
							name = L["Change Border Style"],
							desc = L["Adjust the Border Style for non-interruptible Cast Bars"],
							order = 1,
						},
						noInterruptBorder = {
							type = "select",
							name = L["Border"],
							desc = L["Set the border style for no interrupt casting bars"],
							dialogControl = "LSM30_Border",
							values = lsmlist.border,
							order = 2,
							disabled = noInterruptChangeBorder,
						},
						noInterruptBorderColor = {
							type = "color",
							name = L["Border Color"],
							desc = L["Set the color of the no interrupt casting bar border"],
							get = getColor,
							set = setColor,
							order = 3,
							disabled = noInterruptChangeBorder,
						},
						noInterruptBorderAlpha = {
							type = "range",
							name = L["Border Alpha"],
							desc = L["Set the alpha of the no interrupt casting bar border"],
							isPercent = true,
							min = 0, max = 1, bigStep = 0.025,
							order = 4,
							disabled = noInterruptChangeBorder,
						},
						noInterruptChangeColor = {
							type = "toggle",
							name = L["Change Color"],
							desc = L["Change the color of non-interruptible Cast Bars"],
							order = 10,
						},
						noInterruptColor = {
							type = "color",
							name = L["Cast Bar Color"],
							desc = L["Configure the color of the cast bar."],
							disabled = noInterruptChangeColor,
							set = setColor,
							get = getColor,
							order = 11,
						},
						noInterruptShield = {
							type = "toggle",
							name = L["Show Shield Icon"],
							desc = L["Show the Shield Icon on non-interruptible Cast Bars"],
							disabled = icondisabled,
						},
					},
				},
				toolheader = {
					type = "header",
					name = L["Tools"],
					order = 500,
				},
				snaptocenter = {
					type = "select",
					name = L["Snap to Center"],
					desc = L["Move the CastBar to center of the screen along the specified axis"],
					get = false,
					set = snapToCenter,
					values = {["horizontal"] = L["Horizontal"], ["vertical"] = L["Vertical"]},
					order = 503,
				},
				copysettings = {
					type = "select",
					name = L["Copy Settings From"],
					desc = L["Select a bar from which to copy settings"],
					get = false,
					set = copySettings,
					values = {["Target"] = L["Target"], ["Focus"] = L["Focus"], ["Pet"] = L["Pet"], ["Player"] = L["Player"]},
					order = 504
				}
			}
		}
		return options
	end
end

Quartz3.CastBarTemplate = {}
Quartz3.CastBarTemplate.defaults = {
	--x =  -- applied automatically in applySettings()
	y = 180,
	h = 25,
	w = 250,
	scale = 1,
	texture = "Blizzard",
	hideicon = false,
	alpha = 1,
	iconalpha = 0.9,
	iconposition = "left",
	icongap = 1,
	hidenametext = false,
	nametextposition = "left",
	timetextposition = "right",
	font = "Friz Quadrata TT",
	fontsize = 14,
	hidetimetext = false,
	hidecasttime = false,
	timefontsize = 12,
	targetname = false,
	border = "Blizzard Tooltip",
	nametextx = 3,
	nametexty = 0,
	timetextx = 3,
	timetexty = 0,

	noInterruptBorderChange = false,
	noInterruptBorder = "Tooltip enlarged",
	noInterruptBorderColor = {0.71, 0.73, 0.71}, -- Default color chosen by playing around with settings, rounded to 2 significant digits
	noInterruptBorderAlpha = 1,
	noInterruptColorChange = false,
	noInterruptColor = {1.0, 0.49, 0},
	noInterruptShield = true,
}
Quartz3.CastBarTemplate.template = CastBarTemplate
Quartz3.CastBarTemplate.bars = {}
function Quartz3.CastBarTemplate:new(parent, unit, name, localizedName, config)
	local frameName = "Quartz3CastBar" .. name
	local bar = setmetatable(CreateFrame("Frame", frameName, UIParent), CastBarTemplate_MT)
	bar.unit = unit
	bar.parent = parent
	bar.config = config
	bar.modName = name
	bar.localizedName = localizedName
	bar.locked = true

	Quartz3.CastBarTemplate.bars[name] = bar

	bar:SetFrameStrata("MEDIUM")
	bar:SetScript("OnShow", OnShow)
	bar:SetScript("OnHide", OnHide)
	bar:SetScript("OnUpdate", OnUpdate)
	bar:SetScript("OnEvent", OnEvent)
	bar:SetMovable(true)
	bar:RegisterForDrag("LeftButton")
	bar:SetClampedToScreen(true)

	bar.Bar      = Quartz3:CreateStatusBar(nil, bar) --CreateFrame("StatusBar", nil, bar)
	bar.Text     = bar.Bar:CreateFontString(nil, "OVERLAY")
	bar.TimeText = bar.Bar:CreateFontString(nil, "OVERLAY")
	bar.Icon     = bar.Bar:CreateTexture(nil, "DIALOG")
	bar.Spark    = bar.Bar:CreateTexture(nil, "OVERLAY")
	if unit ~= "player" then
		bar.Shield = bar.Bar:CreateTexture(nil, "ARTWORK")
		bar.Shield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield")
		bar.Shield:SetTexCoord(0, 36/256, 0, 1)
		bar.Shield:SetWidth(36)
		bar.Shield:SetHeight(64)
		bar.Shield:SetPoint("CENTER", bar.Icon, "CENTER", -2, -1)
		bar.Shield:Hide()
	end

	bar.lastNotInterruptible = false

	bar.backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	                 tile = true, tileSize = 16, edgeSize = 16, --edgeFile = "", -- set by ApplySettings
	                 insets = {left = 4, right = 4, top = 4, bottom = 4} }
	bar:Hide()

	return bar
end
