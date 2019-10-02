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

local MODNAME = "Buff"
local Buff = Quartz3:NewModule(MODNAME, "AceEvent-3.0", "AceBucket-3.0", "AceTimer-3.0")
local Player = Quartz3:GetModule("Player")
local Focus = Quartz3:GetModule("Focus", true)
local Target = Quartz3:GetModule("Target", true)

local TimeFmt = Quartz3.Util.TimeFormat

local media = LibStub("LibSharedMedia-3.0")
local lsmlist = AceGUIWidgetLSMlists

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

----------------------------
-- Upvalues
-- GLOBALS: 
local CreateFrame, GetTime, UIParent = CreateFrame, GetTime, UIParent
local UnitIsUnit, UnitBuff, UnitDebuff = UnitIsUnit, UnitBuff, UnitDebuff
local unpack, pairs, next, unpack, sort = unpack, pairs, next, unpack, sort



local targetlocked = true
local focuslocked = true

local OnUpdate
local showicons

local db, getOptions

local defaults = {
	profile = {
		target = true,
		targetbuffs = true,
		targetdebuffs = true,
		targetfixedduration = 0,
		targeticons = true,
		targeticonside = "right",
		
		targetanchor = "player",--L["Free"], L["Target"], L["Focus"]
		targetx = 500,
		targety = 350,
		targetgrowdirection = "up", --L["Down"]
		targetposition = "topright",
		
		targetgap = 1,
		targetspacing = 1,
		targetoffset = 3,
		
		targetwidth = 120,
		targetheight = 12,
		
		focus = true,
		focusbuffs = true,
		focusdebuffs = true,
		focusfixedduration = 0,
		focusicons = true,
		focusiconside = "left",
		
		focusanchor = "player",--L["Free"], L["Target"], L["Focus"]
		focusx = 400,
		focusy = 350,
		focusgrowdirection = "up", --L["Down"]
		focusposition = "bottomleft",
		
		focusgap = 1,
		focusspacing = 1,
		focusoffset = 3,
		
		focuswidth = 120,
		focusheight = 12,
		
		buffnametext = true,
		bufftimetext = true,
		
		bufftexture = "LiteStep",
		bufffont = "Friz Quadrata TT",
		bufffontsize = 9,
		buffalpha = 1,
		
		buffcolor = {0,0.49, 1},
		
		debuffsbytype = true,
		debuffcolor = {1.0, 0.7, 0},
		Poison = {0, 1, 0},
		Magic = {0, 0, 1},
		Disease = {.55, .15, 0},
		Curse = {1, 0, 1},
		
		bufftextcolor = {1,1,1},
		
		timesort = true,
	}
}

do
	function OnUpdate(frame)
		local currentTime = GetTime()
		local endTime = frame.endTime
		if currentTime > endTime then
			Buff:UpdateBars()
		else
			local remaining = (currentTime - frame.startTime)
			frame:SetValue(endTime - remaining)
			frame.timetext:SetFormattedText(TimeFmt(endTime - currentTime))
		end
	end
end

local function OnShow(frame)
	frame:SetScript("OnUpdate", OnUpdate)
end

local function OnHide(frame)
	frame:SetScript("OnUpdate", nil)
end

local framefactory = {
	__index = function(t,k)
		local bar = Quartz3:CreateStatusBar(nil, UIParent)
		t[k] = bar
		bar:SetFrameStrata("MEDIUM")
		bar:Hide()
		bar:SetScript("OnShow", OnShow)
		bar:SetScript("OnHide", OnHide)
		bar:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16})
		bar:SetBackdropColor(0,0,0)
		bar.text = bar:CreateFontString(nil, "OVERLAY")
		bar.timetext = bar:CreateFontString(nil, "OVERLAY")
		bar.icon = bar:CreateTexture(nil, "DIALOG")
		if k == 1 then
			bar:SetMovable(true)
			bar:RegisterForDrag("LeftButton")
			bar:SetClampedToScreen(true)
		end
		Buff:ApplySettings()
		return bar
	end
}
local targetbars = setmetatable({}, framefactory)
local focusbars = setmetatable({}, framefactory)

local getOptions
do
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
	
	local function hidedebuffsbytype()
		return not db.debuffsbytype
	end
	
	local function hidedebuffsnottype()
		return db.debuffsbytype
	end
	
	local function gettargetfreeoptionshidden()
		return db.targetanchor ~= "free"
	end
	
	local function gettargetnotfreeoptionshidden()
		return db.targetanchor == "free"
	end
	
	local function targetdragstart()
		targetbars[1]:StartMoving()
	end
	
	local function targetdragstop()
		db.targetx = targetbars[1]:GetLeft()
		db.targety = targetbars[1]:GetBottom()
		targetbars[1]:StopMovingOrSizing()
	end
	local function targetnothing()
		targetbars[1]:SetAlpha(db.buffalpha)
	end
	local function getfocusfreeoptionshidden()
		return db.focusanchor ~= "free"
	end
	local function getfocusnotfreeoptionshidden()
		return db.focusanchor == "free"
	end
	local function focusdragstart()
		focusbars[1]:StartMoving()
	end
	local function focusdragstop()
		db.focusx = focusbars[1]:GetLeft()
		db.focusy = focusbars[1]:GetBottom()
		focusbars[1]:StopMovingOrSizing()
	end
	local function focusnothing()
		focusbars[1]:SetAlpha(db.buffalpha)
	end
	
	local function setOpt(info, value)
		db[info.arg or info[#info]] = value
		Buff:ApplySettings()
	end

	local function getOpt(info)
		return db[info.arg or info[#info]]
	end
	
	local function setOptFocus(info, value)
		db[info.arg or ("focus"..info[#info])] = value
		Buff:ApplySettings()
	end

	local function getOptFocus(info)
		return db[info.arg or ("focus"..info[#info])]
	end
	
	local function setOptTarget(info, value)
		db[info.arg or ("target"..info[#info])] = value
		Buff:ApplySettings()
	end

	local function getOptTarget(info)
		return db[info.arg or ("target"..info[#info])]
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
				name = L["Buff"],
				order = 600,
				get = getOpt,
				set = setOpt,
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
						order = 100,
					},
					focus = {
						type = "group",
						name = L["Focus"],
						desc = L["Focus"],
						order = 101,
						get = getOptFocus,
						set = setOptFocus,
						args = {
							show = {
								type = "toggle",
								name = L["Enable %s"]:format(L["Focus"]),
								desc = L["Show buffs/debuffs for your %s"]:format(L["Focus"]),
								arg = "focus",
								order = 90,
								width = "full",
								disabled = false,
							},
							buffs = {
								type = "toggle",
								name = L["Enable Buffs"],
								desc = L["Show buffs for your %s"]:format(L["Focus"]),
								order = 91,
							},
							debuffs = {
								type = "toggle",
								name = L["Enable Debuffs"],
								desc = L["Show debuffs for your %s"]:format(L["Focus"]),
								order = 92,
							},
							fixedduration = {
								type = "range",
								name = L["Fixed Duration"],
								desc = L["Fix bars to a specified duration"],
								min = 0, max = 60, step = 1,
								order = 93,
							},
							nlf = {
								type = "description",
								name = "",
								order = 100,
							},
							width = {
								type = "range",
								name = L["Buff Bar Width"],
								desc = L["Set the width of the buff bars"],
								min = 50, max = 300, step = 1,
								order = 101,
							},
							height = {
								type = "range",
								name = L["Buff Bar Height"],
								desc = L["Set the height of the buff bars"],
								min = 4, max = 25, step = 1,
								order = 101,
							},
							anchor = {
								type = "select",
								name = L["Anchor Frame"],
								desc = L["Select where to anchor the %s bars"]:format(L["Focus"]),
								values = {["player"] = L["Player"], ["free"] = L["Free"], ["target"] = L["Target"], ["focus"] = L["Focus"]},
								order = 102,
							},
							-- free
							focuslock = {
								type = "toggle",
								name = L["Lock"],
								desc = L["Toggle %s bar lock"]:format(L["Focus"]),
								get = function()
									return focuslocked
								end,
								set = function(info, v)
									local bar = focusbars[1]
									if v then
										bar.Hide = nil
										bar:EnableMouse(false)
										bar:SetScript("OnDragStart", nil)
										bar:SetScript("OnDragStop", nil)
										Buff:UpdateBars()
									else
										bar:Show()
										bar:EnableMouse(true)
										bar:SetScript("OnDragStart", focusdragstart)
										bar:SetScript("OnDragStop", focusdragstop)
										bar:SetAlpha(1)
										bar.endTime = bar.endTime or 0
										bar.Hide = focusnothing
									end
									focuslocked = v
								end,
								hidden = getfocusfreeoptionshidden,
								order = 103,
							},
							x = {
								type = "range",
								name = L["X"],
								desc = L["Set an exact X value for this bar's position."],
								min = 0, max = 2560, step = 1,
								hidden = getfocusfreeoptionshidden,
								order = 104,
							},
							y = {
								type = "range",
								name = L["Y"],
								desc = L["Set an exact Y value for this bar's position."],
								min = 0, max = 1600, step = 1,
								hidden = getfocusfreeoptionshidden,
								order = 104,
							},
							growdirection = {
								type = "select",
								name = L["Grow Direction"],
								desc = L["Set the grow direction of the %s bars"]:format(L["Focus"]),
								values = {["up"] = L["Up"], ["down"] = L["Down"]},
								hidden = getfocusfreeoptionshidden,
								order = 105,
							},
							-- anchored to a cast bar
							position = {
								type = "select",
								name = L["Position"],
								desc = L["Position the bars for your %s"]:format(L["Focus"]),
								values = positions,
								hidden = getfocusnotfreeoptionshidden,
								order = 103,
							},
							gap = {
								type = "range",
								name = L["Gap"],
								desc = L["Tweak the vertical position of the bars for your %s"]:format(L["Focus"]),
								min = -35, max = 35, step = 1,
								hidden = getfocusnotfreeoptionshidden,
								order = 104,
							},
							offset = {
								type = "range",
								name = L["Offset"],
								desc = L["Tweak the horizontal position of the bars for your %s"]:format(L["Focus"]),
								min = -35, max = 35,step = 1,
								hidden = getfocusnotfreeoptionshidden,
								order = 106,
							},
							spacing = {
								type = "range",
								name = L["Spacing"],
								desc = L["Tweak the space between bars for your %s"]:format(L["Focus"]),
								min = -35, max = 35, step = 1,
								order = 107,
							},
							nli = {
								type = "description",
								name = "",
								order = 108,
							},
							icons = {
								type = "toggle",
								name = L["Show Icons"],
								desc = L["Show icons on buffs and debuffs for your %s"]:format(L["Focus"]),
								order = 109,
							},
							iconside = {
								type = "select",
								name = L["Icon Position"],
								desc = L["Set the side of the buff bar that the icon appears on"],
								values = {["left"] = L["Left"], ["right"] = L["Right"]},
								order = 110,
							},
						},
					},
					target = {
						type = "group",
						name = L["Target"],
						desc = L["Target"],
						order = 102,
						get = getOptTarget,
						set = setOptTarget,
						args = {
							show = {
								type = "toggle",
								name = L["Enable %s"]:format(L["Target"]),
								desc = L["Show buffs/debuffs for your %s"]:format(L["Target"]),
								arg = "target",
								disabled = false,
								width = "full",
								order = 90,
							},
							buffs = {
								type = "toggle",
								name = L["Enable Buffs"],
								desc = L["Show buffs for your %s"]:format(L["Target"]),
								order = 91,
							},
							debuffs = {
								type = "toggle",
								name = L["Enable Debuffs"],
								desc = L["Show debuffs for your %s"]:format(L["Target"]),
								order = 92,
							},
							fixedduration = {
								type = "range",
								name = L["Fixed Duration"],
								desc = L["Fix bars to a specified duration"],
								min = 0, max = 60, step = 1,
								order = 93,
							},
							nlf = {
								type = "description",
								name = "",
								order = 100,
							},
							width = {
								type = "range",
								name = L["Buff Bar Width"],
								desc = L["Set the width of the buff bars"],
								min = 50, max = 300, step = 1,
								order = 101,
							},
							height = {
								type = "range",
								name = L["Buff Bar Height"],
								desc = L["Set the height of the buff bars"],
								min = 4, max = 25, step = 1,
								order = 101,
							},
							anchor = {
								type = "select",
								name = L["Anchor Frame"],
								desc = L["Select where to anchor the %s bars"]:format(L["Target"]),
								values = {["player"] = L["Player"], ["free"] = L["Free"], ["target"] = L["Target"], ["focus"] = L["Focus"]},
								order = 102,
							},
							-- free
							targetlock = {
								type = "toggle",
								name = L["Lock"],
								desc = L["Toggle %s bar lock"]:format(L["Target"]),
								get = function()
									return targetlocked
								end,
								set = function(info, v)
									local bar = targetbars[1]
									if v then
										bar.Hide = nil
										bar:EnableMouse(false)
										bar:SetScript("OnDragStart", nil)
										bar:SetScript("OnDragStop", nil)
										Buff:UpdateBars()
									else
										bar:Show()
										bar:EnableMouse(true)
										bar:SetScript("OnDragStart", targetdragstart)
										bar:SetScript("OnDragStop", targetdragstop)
										bar:SetAlpha(1)
										bar.endTime = bar.endTime or 0
										bar.Hide = targetnothing
									end
									targetlocked = v
								end,
								hidden = gettargetfreeoptionshidden,
								order = 103,
							},
							x = {
								type = "range",
								name = L["X"],
								desc = L["Set an exact X value for this bar's position."],
								min = 0, max = 2560, bigStep = 1,
								hidden = gettargetfreeoptionshidden,
								order = 104,
							},
							y = {
								type = "range",
								name = L["Y"],
								desc = L["Set an exact Y value for this bar's position."],
								min = 0, max = 1600, bigStep = 1,
								hidden = gettargetfreeoptionshidden,
								order = 104,
							},
							growdirection = {
								type = "select",
								name = L["Grow Direction"],
								desc = L["Set the grow direction of the %s bars"]:format(L["Target"]),
								values = {["up"] = L["Up"], ["down"] = L["Down"]},
								hidden =  gettargetfreeoptionshidden,
								order = 105,
							},
							-- anchored to a cast bar
							position = {
								type = "select",
								name = L["Position"],
								desc = L["Position the bars for your %s"]:format(L["Target"]),
								values = positions,
								hidden = gettargetnotfreeoptionshidden,
								order = 103,
							},
							gap = {
								type = "range",
								name = L["Gap"],
								desc = L["Tweak the vertical position of the bars for your %s"]:format(L["Target"]),
								min = -35, max = 35, step = 1,
								order = 101,
								hidden = gettargetnotfreeoptionshidden,
								order = 104,
							},
							offset = {
								type = "range",
								name = L["Offset"],
								desc = L["Tweak the horizontal position of the bars for your %s"]:format(L["Target"]),
								min = -35, max = 35, step = 1,
								hidden = gettargetnotfreeoptionshidden,
								order = 106,
							},
							spacing = {
								type = "range",
								name = L["Spacing"],
								desc = L["Tweak the space between bars for your %s"]:format(L["Target"]),
								min = -35, max = 35, step = 1,
								order = 107,
							},
							nli = {
								type = "description",
								name = "",
								order = 108,
							},
							icons = {
								type = "toggle",
								name = L["Show Icons"],
								desc = L["Show icons on buffs and debuffs for your %s"]:format(L["Target"]),
								order = 109,
							},
							iconside = {
								type = "select",
								name = L["Icon Position"],
								desc = L["Set the side of the buff bar that the icon appears on"],
								values = {["left"] = L["Left"], ["right"] = L["Right"]},
								order = 110,
							},
						},
					},
					settings = {
						type = "group",
						name = L["Settings"],
						order = 1,
						args = {
							timesort = {
								type = "toggle",
								name = L["Sort by Remaining Time"],
								desc = L["Sort the buffs and debuffs by time remaining.  If unchecked, they will be sorted alphabetically."],
								order = 103,
								width = "full",
							},
							buffnametext = {
								type = "toggle",
								name = L["Buff Name Text"],
								desc = L["Display the names of buffs/debuffs on their bars"],
								order = 106,
							},
							bufftimetext = {
								type = "toggle",
								name = L["Buff Time Text"],
								desc = L["Display the time remaining on buffs/debuffs on their bars"],
								order = 107,
							},
							bufffont = {
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								desc = L["Set the font used in the buff bars"],
								values = lsmlist.font,
								order = 108,
							},
							bufftexture = {
								type = "select",
								dialogControl = "LSM30_Statusbar", 
								name = L["Texture"],
								desc = L["Set the buff bar Texture"],
								values = lsmlist.statusbar,
								order = 109,
							},
							bufftextcolor = {
								type = "color",
								name = L["Text Color"],
								desc = L["Set the color of the text for the buff bars"],
								order = 110,
								width = "full",
								get = getColor,
								set = setColor,
							},
							bufffontsize = {
								type = "range",
								name = L["Font Size"],
								desc = L["Set the font size for the buff bars"],
								min = 3, max = 15, step = 1,
								order = 111,
							},
							buffalpha = {
								type = "range",
								name = L["Alpha"],
								desc = L["Set the alpha of the buff bars"],
								min = 0.05, max = 1, step = 0.05,
								isPercent = true,
								order = 112,
							},
						},
					},
					colors = {
						type = "group",
						name = L["Colors"],
						desc = L["Colors"],
						order = -1,
						args = {
							buffcolor = {
								type = "color",
								name = L["Buff Color"],
								desc = L["Set the color of the bars for buffs"],
								get = getColor,
								set = setColor,
							},
							debuffsbytype = {
								type = "toggle",
								name = L["Debuffs by Type"],
								desc = L["Color debuff bars according to their dispel type"],
								order = 101,
							},
							debuffcolor = {
								type = "color",
								name = L["Debuff Color"],
								desc = L["Set the color of the bars for debuffs"],
								get = getColor,
								set = setColor,
								disabled = hidedebuffsnottype,
								order = 102,
							},
							physcolor = {
								type = "color",
								name = L["Undispellable Color"],
								desc = L["Set the color of the bars for undispellable debuffs"],
								get = getColor,
								set = setColor,
								arg = "debuffcolor",
								disabled = hidedebuffsbytype,
								order = 102,
							},
							Curse = {
								type = "color",
								name = L["Curse Color"],
								desc = L["Set the color of the bars for curses"],
								get = getColor,
								set = setColor,
								disabled = hidedebuffsbytype,
								order = 103,
							},
							Disease = {
								type = "color",
								name = L["Disease Color"],
								desc = L["Set the color of the bars for diseases"],
								get = getColor,
								set = setColor,
								disabled = hidedebuffsbytype,
								order = 104,
							},
							Magic = {
								type = "color",
								name = L["Magic Color"],
								desc = L["Set the color of the bars for magic"],
								get = getColor,
								set = setColor,
								disabled = hidedebuffsbytype,
								order = 105,
							},
							Poison = {
								type = "color",
								name = L["Poison Color"],
								desc = L["Set the color of the bars for poisons"],
								get = getColor,
								set = setColor,
								disabled = hidedebuffsbytype,
								order = 106,
							},
						},
					},
				}
			}
		end
		return options
	end
end

function Buff:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	-- fix broken buff text color
	if type(db.bufftextcolor) ~= "table" then
		db.bufftextcolor = {1,1,1}
	end

	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Buff"])
end

function Buff:OnEnable()
	self:RegisterBucketEvent("UNIT_AURA", 0.5)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateBars")
	if not WoWClassic then
		self:RegisterEvent("PLAYER_FOCUS_CHANGED", "UpdateBars")
	end
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			for i, v in pairs(targetbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", override))
			end
			for i, v in pairs(focusbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", override))
			end
		end
	end)

	media.RegisterCallback(self, "LibSharedMedia_Registered", function(mtype, key)
		if mtype == "statusbar" and key == self.config.bufftexture then
			for i, v in pairs(targetbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", self.config.bufftexture))
			end
			for i, v in pairs(focusbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", self.config.bufftexture))
			end
		end
	end)

	self:ApplySettings()
end

function Buff:OnDisable()
	targetbars[1].Hide = nil
	targetbars[1]:EnableMouse(false)
	targetbars[1]:SetScript("OnDragStart", nil)
	targetbars[1]:SetScript("OnDragStop", nil)
	for _, v in pairs(targetbars) do
		v:Hide()
	end

	focusbars[1].Hide = nil
	focusbars[1]:EnableMouse(false)
	focusbars[1]:SetScript("OnDragStart", nil)
	focusbars[1]:SetScript("OnDragStop", nil)
	for _, v in pairs(focusbars) do
		v:Hide()
	end

	media.UnregisterCallback(self, "LibSharedMedia_SetGlobal")
	media.UnregisterCallback(self, "LibSharedMedia_Registered")
end

function Buff:UNIT_AURA(units)
	for unit in pairs(units) do
		if unit == "target" then
			self:UpdateTargetBars()
		end
		if unit == "focus" or UnitIsUnit("focus", unit) then
			self:UpdateFocusBars()
		end
	end
end

function Buff:CheckForUpdate()
	if targetbars[1]:IsShown() then
		self:UpdateTargetBars()
	end
	if focusbars[1]:IsShown() then
		self:UpdateFocusBars()
	end
end

function Buff:UpdateBars()
	self:UpdateTargetBars()
	self:UpdateFocusBars()
end

do
	local tblCache = setmetatable({}, {__mode="k"})
	local function new()
		local entry = next(tblCache)
		if entry then tblCache[entry] = nil else entry = {} end
		return entry
	end
	local function del(tbl)
		-- these 2 values are not in every table, clear them
		tbl.isbuff, tbl.dispeltype = nil, nil
		tblCache[tbl] = true
	end
	
	local function mysort(a,b)
		if db.timesort then
			if a.isbuff == b.isbuff then
				return a.remaining < b.remaining
			else
				return a.isbuff
			end
		else
			if a.isbuff == b.isbuff then
				return a.name < b.name
			else
				return a.isbuff
			end
		end
	end
	
	local tmp = {}
	local called = false -- prevent recursive calls when new bars are created.
	function Buff:UpdateTargetBars()
		if called then
			return
		end
		called = true
		if db.target then
			local currentTime = GetTime()
			for k in pairs(tmp) do
				tmp[k] = del(tmp[k])
			end
			if db.targetbuffs then
				for i = 1, 32 do
					local name, texture, applications, _, duration, expirationTime, caster = UnitBuff("target", i)
					local remaining = expirationTime and (expirationTime - GetTime()) or nil
					if not name then
						break
					end
					if (caster=="player" or caster=="pet" or caster=="vehicle") and duration > 0 then
						local t = new()
						tmp[#tmp+1] = t
						t.name = name
						t.texture = texture
						t.duration = duration
						t.remaining = remaining
						t.isbuff = true
						t.applications = applications
					end
				end
			end
			if db.targetdebuffs then
				for i = 1, 40 do
					local name, texture, applications, dispeltype, duration, expirationTime, caster = UnitDebuff("target", i)
					local remaining =  expirationTime and (expirationTime - GetTime()) or nil
					if not name then
						break
					end
					if (caster=="player" or caster=="pet" or caster=="vehicle") and duration > 0 then
						local t = new()
						tmp[#tmp+1] = t
						t.name = name
						t.texture = texture
						t.duration = duration
						t.remaining = remaining
						t.dispeltype = dispeltype
						t.applications = applications
					end
				end
			end
			sort(tmp, mysort)
			local maxindex = 0
			for k=1,#tmp do
				local v = tmp[k]
				maxindex = k
				local bar = targetbars[k]
				if v.applications > 1 then
					bar.text:SetFormattedText("%s (%s)", v.name, v.applications)
				else
					bar.text:SetText(v.name)
				end
				bar.icon:SetTexture(v.texture)
				local elapsed = (v.duration - v.remaining)
				local startTime, endTime = (currentTime - elapsed), (currentTime + v.remaining)
				if db.targetfixedduration > 0 then
					startTime = endTime - db.targetfixedduration
				end
				bar.startTime = startTime
				bar.endTime = endTime
				bar:SetMinMaxValues(startTime, endTime)
				bar:Show()
				if v.isbuff then
					bar:SetStatusBarColor(unpack(db.buffcolor))
				else
					if db.debuffsbytype then
						local dispeltype = v.dispeltype
						if dispeltype then
							bar:SetStatusBarColor(unpack(db[dispeltype]))
						else
							bar:SetStatusBarColor(unpack(db.debuffcolor))
						end
					else
						bar:SetStatusBarColor(unpack(db.debuffcolor))
					end
				end
			end
			for i = maxindex+1, #targetbars do
				targetbars[i]:Hide()
			end
		else
			targetbars[1].Hide = nil
			targetbars[1]:EnableMouse(false)
			targetbars[1]:SetScript("OnDragStart", nil)
			targetbars[1]:SetScript("OnDragStop", nil)
			for i=1,#targetbars do
				targetbars[i]:Hide()
			end
		end
		if targetbars[1]:IsShown() then
			if not self.autoUpdateTimer then
				self.autoUpdateTimer = self:ScheduleRepeatingTimer("CheckForUpdate", 3)
			end
		elseif not focusbars[1]:IsShown() then
			if self.autoUpdateTimer then
				self:CancelTimer(self.autoUpdateTimer)
				self.autoUpdateTimer = nil
			end
		end
		called = false
	end
	function Buff:UpdateFocusBars()
		if called then
			return
		end
		called = true
		if db.focus then
			local currentTime = GetTime()
			for k in pairs(tmp) do
				tmp[k] = del(tmp[k])
			end
			if db.focusbuffs then
				for i = 1, 32 do
					local name, texture, applications, dispeltype, duration, expirationTime, caster = UnitBuff("focus", i)
					local remaining =  expirationTime and (expirationTime - GetTime()) or nil
					if not name then
						break
					end
					if (caster=="player" or caster=="pet" or caster=="vehicle") and duration > 0 then
						local t = new()
						tmp[#tmp+1] = t
						t.name = name
						t.texture = texture
						t.duration = duration
						t.remaining = remaining
						t.isbuff = true
						t.applications = applications
					end
				end
			end
			if db.focusdebuffs then
				for i = 1, 40 do
					local name, texture, applications, dispeltype, duration, expirationTime, caster = UnitDebuff("focus", i)
					local remaining =  expirationTime and (expirationTime - GetTime()) or nil
					if not name then
						break
					end
					if (caster=="player" or caster=="pet" or caster=="vehicle") and duration > 0 then
						local t = new()
						tmp[#tmp+1] = t
						t.name = name
						t.texture = texture
						t.duration = duration
						t.remaining = remaining
						t.dispeltype = dispeltype
						t.applications = applications
					end
				end
			end
			sort(tmp, mysort)
			local maxindex = 0
			for k=1,#tmp do
				local v = tmp[k]
				maxindex = k
				local bar = focusbars[k]
				if v.applications > 1 then
					bar.text:SetFormattedText("%s (%s)", v.name, v.applications)
				else
					bar.text:SetText(v.name)
				end
				bar.icon:SetTexture(v.texture)
				local elapsed = (v.duration - v.remaining)
				local startTime, endTime = (currentTime - elapsed), (currentTime + v.remaining)
				if db.focusfixedduration > 0 then
					startTime = endTime - db.focusfixedduration
				end
				bar.startTime = startTime
				bar.endTime = endTime
				bar:SetMinMaxValues(startTime, endTime)
				bar:Show()
				if v.isbuff then
					bar:SetStatusBarColor(unpack(db.buffcolor))
				else
					if db.debuffsbytype then
						local dispeltype = v.dispeltype
						if dispeltype then
							bar:SetStatusBarColor(unpack(db[dispeltype]))
						else
							bar:SetStatusBarColor(unpack(db.debuffcolor))
						end
					else
						bar:SetStatusBarColor(unpack(db.debuffcolor))
					end
				end
			end
			for i = maxindex+1, #focusbars do
				focusbars[i]:Hide()
			end
		else
			focusbars[1].Hide = nil
			focusbars[1]:EnableMouse(false)
			focusbars[1]:SetScript("OnDragStart", nil)
			focusbars[1]:SetScript("OnDragStop", nil)
			for i=1,#focusbars do
				focusbars[i]:Hide()
			end
		end
		if focusbars[1]:IsShown() then
			if not self.autoUpdateTimer then
				self.autoUpdateTimer = self:ScheduleRepeatingTimer("CheckForUpdate", 3)
			end
		elseif not targetbars[1]:IsShown() then
			if self.autoUpdateTimer then
				self:CancelTimer(self.autoUpdateTimer)
				self.autoUpdateTimer = nil
			end
		end
		called = false
	end
end
do
	local function apply(unit, i, bar, db, direction)
		local bars, position, icons, iconside, gap, spacing, offset, anchor, x, y, grow, height, width
		local qpdb = Player.db.profile
		if unit == "target" then
			bars = targetbars
			position = db.targetposition
			icons = db.targeticons
			iconside = db.targeticonside
			gap = db.targetgap
			spacing = db.targetspacing
			offset = db.targetoffset
			anchor = db.targetanchor
			x = db.targetx
			y = db.targety
			grow = db.targetgrowdirection
			width = db.targetwidth
			height = db.targetheight
		else
			bars = focusbars
			position = db.focusposition
			icons = db.focusicons
			iconside = db.focusiconside
			gap = db.focusgap
			spacing = db.focusspacing
			offset = db.focusoffset
			anchor = db.focusanchor
			x = db.focusx
			y = db.focusy
			grow = db.focusgrowdirection
			width = db.focuswidth
			height = db.focusheight
		end
		bar:ClearAllPoints()
		bar:SetStatusBarTexture(media:Fetch("statusbar", db.bufftexture))
		bar:SetWidth(width)
		bar:SetHeight(height)
		bar:SetScale(qpdb.scale)
		bar:SetAlpha(db.buffalpha)
		
		if anchor == "free" then
			if i == 1 then
				bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
				if grow == "up" then
					direction = 1
				else --L["Down"]
					direction = -1
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		else
			if i == 1 then
				local anchorframe
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
						offset = offset + height
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMRIGHT", anchorframe, "BOTTOMLEFT", -1 * offset, gap)
				elseif position == "leftdown" then
					if iconside == "right" and showicons then
						offset = offset + height
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPRIGHT", anchorframe, "TOPLEFT", -3 * offset, -1 * gap)
				elseif position == "rightup" then
					if iconside == "left" and showicons then
						offset = offset + height
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMLEFT", anchorframe, "BOTTOMRIGHT", offset, gap)
				elseif position == "rightdown" then
					if iconside == "left" and showicons then
						offset = offset + height
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPLEFT", anchorframe, "TOPRIGHT", offset, -1 * gap)
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		end
		
		local timetext = bar.timetext
		if db.bufftimetext then
			timetext:Show()
			timetext:ClearAllPoints()
			timetext:SetWidth(width)
			timetext:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
			timetext:SetJustifyH("RIGHT")
		else
			timetext:Hide()
		end
		timetext:SetFont(media:Fetch("font", db.bufffont), db.bufffontsize)
		timetext:SetShadowColor( 0, 0, 0, 1)
		timetext:SetShadowOffset( 0.8, -0.8 )
		timetext:SetTextColor(unpack(db.bufftextcolor))
		timetext:SetNonSpaceWrap(false)
		timetext:SetHeight(height)
		
		local temptext = timetext:GetText()
		timetext:SetText("10.0")
		local normaltimewidth = timetext:GetStringWidth()
		timetext:SetText(temptext)
		
		local text = bar.text
		if db.buffnametext then
			text:Show()
			text:ClearAllPoints()
			text:SetPoint("LEFT", bar, "LEFT", 2, 0)
			text:SetJustifyH("LEFT")
			if db.bufftimetext then
				text:SetWidth(width - normaltimewidth)
			else
				text:SetWidth(width)
			end
		else
			text:Hide()
		end
		text:SetFont(media:Fetch("font", db.bufffont), db.bufffontsize)
		text:SetShadowColor( 0, 0, 0, 1)
		text:SetShadowOffset( 0.8, -0.8 )
		text:SetTextColor(unpack(db.bufftextcolor))
		text:SetNonSpaceWrap(false)
		text:SetHeight(height)
		
		local icon = bar.icon
		if icons then
			icon:Show()
			icon:SetWidth(height-1)
			icon:SetHeight(height-1)
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
	function Buff:ApplySettings()
		db = self.db.profile
		if self:IsEnabled() then
			local direction
			if db.targetanchor ~= "free" then
				targetbars[1].Hide = nil
				targetbars[1]:EnableMouse(false)
				targetbars[1]:SetScript("OnDragStart", nil)
				targetbars[1]:SetScript("OnDragStop", nil)
			end
			if db.focusanchor ~= "free" then
				focusbars[1].Hide = nil
				focusbars[1]:EnableMouse(false)
				focusbars[1]:SetScript("OnDragStart", nil)
				focusbars[1]:SetScript("OnDragStop", nil)
			end
			for i, v in pairs(targetbars) do
				direction = apply("target", i, v, db, direction)
			end
			direction = nil
			for i, v in pairs(focusbars) do
				direction = apply("focus", i, v, db, direction)
			end
			self:UpdateBars()
		end
	end
end

