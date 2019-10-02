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

if WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then return end

local MODNAME = "EnemyCasts"
local Enemy = Quartz3:NewModule(MODNAME, "AceEvent-3.0")

local Player = Quartz3:GetModule("Player")
local Focus = Quartz3:GetModule("Focus", true)
local Target = Quartz3:GetModule("Target", true)

local TimeFmt = Quartz3.Util.TimeFormat

local media = LibStub("LibSharedMedia-3.0")
local lsmlist = AceGUIWidgetLSMlists

----------------------------
-- Upvalues
-- GLOBALS: CastingBarFrame
local tsort, tinsert = table.sort, table.insert
local bit_band, bit_bor = bit.band, bit.bor

local locked = true
local db, getOptions, castBar

local defaults = {
	profile = {
		icons = true,
		iconside = "left",

		anchor = "free", -- "free"

		x = 500,
		y = 700,
		growdirection = "down", -- "up"

		position = "topleft",

		gap = 1,
		spacing = 1,
		offset = 3,

		nametext = true,
		timetext = true,

		texture = "Minimalist",
		width = 150,
		height = 16,
		font = "Friz Quadrata TT",
		fontsize = 10,
		alpha = 1,

		textcolor = {1, 1, 1},
		barcolor = {0.71, 0, 1},

		instanceonly = true,
	}
}

local function OnHide(frame)
	frame:SetScript("OnUpdate", nil)
end
local castbars = setmetatable({}, {
	__index = function(t,k)
		local bar = Quartz3:CreateStatusBar(nil, UIParent)
		t[k] = bar
		bar:SetFrameStrata("MEDIUM")
		bar:Hide()
		bar:SetScript("OnHide", OnHide)
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
		Enemy:ApplySettings()
		return bar
	end
})

local casts = {}
local new, del
do
	local tblCache = setmetatable({}, {__mode="k"})
	function new()
		local entry = next(tblCache)
		if entry then tblCache[entry] = nil else entry = {} end
		return entry
	end
	
	function del(t)
		wipe(t)
		tblCache[t] = true
	end
end

function Enemy:OnInitialize()
	self.db = Quartz3.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self:SetEnabledState(Quartz3:GetModuleEnabled(MODNAME))
	Quartz3:RegisterModuleOptions(MODNAME, getOptions, L["Enemy CastBars"])
end

function Enemy:OnEnable()
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "CLEUHandler")
	media.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			for i, v in pairs(castbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", override))
			end
		end
	end)

	media.RegisterCallback(self, "LibSharedMedia_Registered", function(mtype, key)
		if mtype == "statusbar" and key == db.texture then
			for i, v in pairs(castbars) do
				v:SetStatusBarTexture(media:Fetch("statusbar", db.texture))
			end
		end
	end)

	self:ApplySettings()
end

function Enemy:OnDisable()
	castbars[1].Hide = nil
	castbars[1]:EnableMouse(false)
	castbars[1]:SetScript("OnDragStart", nil)
	castbars[1]:SetScript("OnDragStop", nil)

	for _, v in pairs(castbars) do
		v:Hide()
	end

	media.UnregisterCallback(self, "LibSharedMedia_SetGlobal")
	media.UnregisterCallback(self, "LibSharedMedia_Registered")
end

function Enemy:CLEUHandler()
	if db.instanceonly and not IsInInstance() then return end
	local timestamp, event, hideCaster, sGUID, sName, sFlags, sRaidFlags, dGUID, dName, dFlags, dRaidFlags, spellId, spellName = CombatLogGetCurrentEventInfo()
	if 
		bit_band(sFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) == COMBATLOG_OBJECT_REACTION_FRIENDLY or 
		bit_band(sFlags, COMBATLOG_OBJECT_CONTROL_NPC) == 0
	then
		return
	end
	if event == "SPELL_CAST_START" then
		if not casts[sGUID] then
			casts[sGUID] = new()
		end
		local _, _, texture, castTime = GetSpellInfo(spellId)
		casts[sGUID].name = sName
		casts[sGUID].spellName = spellName
		casts[sGUID].spellId = spellId
		casts[sGUID].texture = texture
		casts[sGUID].duration = castTime / 1000 * (1 + (GetCombatRatingBonus(CR_HASTE_SPELL) / 100))
		casts[sGUID].startTime = GetTime()
		casts[sGUID].endTime = casts[sGUID].startTime + casts[sGUID].duration

		self:UpdateBars()
	elseif event == "SPELL_CAST_FAILED" or event == "SPELL_CAST_SUCCESS" and casts[sGUID] then
		del(casts[sGUID])
		casts[sGUID] = nil
		self:UpdateBars()
	end
end

do
	local function onUpdate(bar)
		local currentTime = GetTime()
		local endTime = bar.endTime
		
		if currentTime > endTime then
			Enemy:UpdateBars()
		else
			bar:SetValue(currentTime)
			bar.TimeText:SetFormattedText(TimeFmt(endTime - currentTime))
		end
	end

	local function barSorter(a, b)
		return a.endTime < b.endTime
	end

	function Enemy:UpdateBars()
		local tmp = new()
		local currentTime = GetTime()
		for guid, details in pairs(casts) do
			if details.endTime > currentTime then
				tinsert(tmp, details)
			end
		end
		tsort(tmp, barSorter)
		for i=1,#tmp do
			local v = tmp[i]
			local bar = castbars[i]

			bar.Text:SetText(v.spellName)
			bar.Icon:SetTexture(v.texture)
			bar:SetMinMaxValues(v.startTime, v.endTime)
			bar.startTime = v.startTime
			bar.endTime = v.endTime
			bar:Show()
			bar:SetScript("OnUpdate", onUpdate)
		end
		
		for i = #tmp+1, #castbars do
			castbars[i]:Hide()
		end
		del(tmp)
	end
end

do
	local function apply(i, bar, db, direction)
		local position, showicons, iconside, gap, spacing, offset
		local qpdb = Player.db.profile 
		
		position = db.position
		showicons = db.icons
		iconside = db.iconside
		gap = db.gap
		spacing = db.spacing
		offset = db.offset
		
		bar:ClearAllPoints()
		bar:SetStatusBarTexture(media:Fetch("statusbar", db.texture))
		bar:SetStatusBarColor(unpack(db.barcolor))
		bar:SetWidth(db.width)
		bar:SetHeight(db.height)
		bar:SetScale(qpdb.scale)
		bar:SetAlpha(db.alpha)
		
		if db.anchor == "free" then
			if i == 1 then
				bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", db.x, db.y)
				if db.growdirection == "up" then
					direction = 1
				else --L["Down"]
					direction = -1
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", castbars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", castbars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		else
			if i == 1 then
				local anchorframe
				local anchor = db.anchor
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
						offset = offset + db.height
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMRIGHT", anchorframe, "BOTTOMLEFT", -1 * offset, gap)
				elseif position == "leftdown" then
					if iconside == "right" and showicons then
						offset = offset + db.height
					end
					if qpdb.iconposition == "left" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPRIGHT", anchorframe, "TOPLEFT", -3 * offset, -1 * gap)
				elseif position == "rightup" then
					if iconside == "left" and showicons then
						offset = offset + db.height
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = 1
					bar:SetPoint("BOTTOMLEFT", anchorframe, "BOTTOMRIGHT", offset, gap)
				elseif position == "rightdown" then
					if iconside == "left" and showicons then
						offset = offset + db.height
					end
					if qpdb.iconposition == "right" and not qpdb.hideicon then
						offset = offset + qpdb.h
					end
					direction = -1
					bar:SetPoint("TOPLEFT", anchorframe, "TOPRIGHT", offset, -1 * gap)
				end
			else
				if direction == 1 then
					bar:SetPoint("BOTTOMRIGHT", castbars[i-1], "TOPRIGHT", 0, spacing)
				else -- -1
					bar:SetPoint("TOPRIGHT", castbars[i-1], "BOTTOMRIGHT", 0, -1 * spacing)
				end
			end
		end
		
		local timetext = bar.TimeText
		if db.timetext then
			timetext:Show()
			timetext:ClearAllPoints()
			timetext:SetWidth(db.width)
			timetext:SetPoint("RIGHT", bar, "RIGHT", -2, 0)
			timetext:SetJustifyH("RIGHT")
		else
			timetext:Hide()
		end
		timetext:SetFont(media:Fetch("font", db.font), db.fontsize)
		timetext:SetShadowColor( 0, 0, 0, 1)
		timetext:SetShadowOffset( 0.8, -0.8 )
		timetext:SetTextColor(unpack(db.textcolor))
		timetext:SetNonSpaceWrap(false)
		timetext:SetHeight(db.height)
		
		local temptext = timetext:GetText()
		timetext:SetText("10.0")
		local normaltimewidth = timetext:GetStringWidth()
		timetext:SetText(temptext)
		
		local text = bar.Text
		if db.nametext then
			text:Show()
			text:ClearAllPoints()
			text:SetPoint("LEFT", bar, "LEFT", 2, 0)
			text:SetJustifyH("LEFT")
			if db.timetext then
				text:SetWidth(db.width - normaltimewidth)
			else
				text:SetWidth(db.width)
			end
		else
			text:Hide()
		end
		text:SetFont(media:Fetch("font", db.font), db.fontsize)
		text:SetShadowColor( 0, 0, 0, 1)
		text:SetShadowOffset( 0.8, -0.8 )
		text:SetTextColor(unpack(db.textcolor))
		text:SetNonSpaceWrap(false)
		text:SetHeight(db.height)
		
		local icon = bar.Icon
		if showicons then
			icon:Show()
			icon:SetWidth(db.height-1)
			icon:SetHeight(db.height-1)
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

	function Enemy:ApplySettings()
		db = self.db.profile
		if self:IsEnabled() then
			local direction
			if db.anchor ~= "free" then
				castbars[1].Hide = nil
				castbars[1]:EnableMouse(false)
				castbars[1]:SetScript("OnDragStart", nil)
				castbars[1]:SetScript("OnDragStop", nil)
			end
			for i, v in pairs(castbars) do
				direction = apply(i, v, db, direction)
			end
		end
	end
end

do

	local function getfreeoptionshidden()
		return db.anchor ~= "free"
	end

	local function getnotfreeoptionshidden()
		return db.anchor == "free"
	end

	local function dragstart()
		castbars[1]:StartMoving()
	end

	local function dragstop()
		db.x = castbars[1]:GetLeft()
		db.y = castbars[1]:GetBottom()
		castbars[1]:StopMovingOrSizing()
	end

	local function nothing()
		castbars[1]:SetAlpha(db.alpha)
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
		Enemy:ApplySettings()
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
				name = L["Enemy CastBars"],
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
							anchor = {
								type = "select",
								name = L["Anchor Frame"],
								desc = L["Select where to anchor the bars"],
								values = {["player"] = L["Player"], ["free"] = L["Free"], ["target"] = L["Target"], ["focus"] = L["Focus"]},
							},
							-- free
							lock = {
								type = "toggle",
								name = L["Lock"],
								desc = L["Toggle bar lock"],
								get = function()
									return locked
								end,
								set = function(info, v)
									if v then
										castbars[1].Hide = nil
										castbars[1]:EnableMouse(false)
										castbars[1]:SetScript("OnDragStart", nil)
										castbars[1]:SetScript("OnDragStop", nil)
										Enemy:UpdateBars()
									else
										castbars[1]:Show()
										castbars[1]:EnableMouse(true)
										castbars[1]:SetScript("OnDragStart", dragstart)
										castbars[1]:SetScript("OnDragStop", dragstop)
										castbars[1]:SetAlpha(1)
										castbars[1].Hide = nothing
									end
									locked = v
								end,
								hidden = getfreeoptionshidden,
								order = 98,
							},
							instanceonly = {
								type = "toggle",
								name = L["Only in Instances"],
								desc = L["Only show the casts of enemys when inside an instance (dungeon or raid)"],
								order = 99,
							},
							growdirection = {
								type = "select",
								name = L["Grow Direction"],
								desc = L["Set the grow direction of the bars"],
								values = {["up"] = L["Up"], ["down"] = L["Down"]},
								hidden = getfreeoptionshidden,
								order = 102,
							},
							x = {
								type = "range",
								name = L["X"],
								desc = L["Set an exact X value for this bar's position."],
								min = 0, max = 2560, bigStep = 1,
								order = 103,
								hidden = getfreeoptionshidden,
							},
							y = {
								type = "range",
								name = L["Y"],
								desc = L["Set an exact Y value for this bar's position."],
								min = 0, max = 1600, bigStep = 1,
								order = 103,
								hidden = getfreeoptionshidden,
							},
							-- anchored to a cast bar
							position = {
								type = "select",
								name = L["Position"],
								desc = L["Position the bars"],
								values = positions,
								hidden = getnotfreeoptionshidden,
								order = 101,
							},
							gap = {
								type = "range",
								name = L["Gap"],
								desc = L["Tweak the vertical position of thebars"],
								min = -35, max = 35, step = 1,
								hidden = getnotfreeoptionshidden,
								order = 102,
							},
							offset = {
								type = "range",
								name = L["Offset"],
								desc = L["Tweak the horizontal position of the bars"],
								min = -35, max = 35, step = 1,
								hidden = getnotfreeoptionshidden,
								order = 103,
							},
							spacing = {
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
							icons = {
								type = "toggle",
								name = L["Show Icons"],
								desc = L["Show icons on the bars"],
								order = 110,
							},
							iconside = {
								type = "select",
								name = L["Icon Position"],
								desc = L["Set the side of the bar that the icon appears on"],
								values = {["left"] = L["Left"], ["right"] = L["Right"]},
								order = 111,
							},
							texture = {
								type = "select",
								dialogControl = "LSM30_Statusbar",
								name = L["Texture"],
								desc = L["Set the bar Texture"],
								values = lsmlist.statusbar,
								order = 112,
							},
							barcolor = {
								type = "color",
								name = L["Bar Color"],
								desc = L["Set the color of the bars"],
								get = getColor,
								set = setColor,
								order = 113,
							},
							nl5 = {
								type = "description",
								name = "",
								order = 114,
							},
							width = {
								type = "range",
								name = L["Bar Width"],
								desc = L["Set the width of the bars"],
								min = 50, max = 300, step = 1,
								order = 115,
							},
							height = {
								type = "range",
								name = L["Bar Height"],
								desc = L["Set the height of the bars"],
								min = 4, max = 25, step = 1,
								order = 116,
							},
							alpha = {
								type = "range",
								name = L["Alpha"],
								desc = L["Set the alpha of the bars"],
								min = 0.05, max = 1, bigStep = 0.05,
								isPercent = true,
								order = 117,
							},
							nl6 = {
								type = "description",
								name = "",
								order = 119,
							},
							nametext = {
								type = "toggle",
								name = L["Spell Name"],
								desc = L["Display the name of the spell on the bars"],
								order = 120,
							},
							timetext = {
								type = "toggle",
								name = L["Remaining Time"],
								desc = L["Display the time remaining on the bars"],
								order = 121,
							},
							font = {
								type = "select",
								dialogControl = "LSM30_Font",
								name = L["Font"],
								desc = L["Set the font used in the bars"],
								values = lsmlist.font,
								order = 122,
							},
							fontsize = {
								type = "range",
								name = L["Font Size"],
								desc = L["Set the font size for the bars"],
								min = 3, max = 15, step = 1,
								order = 123,
							},
							textcolor = {
								type = "color",
								name = L["Text Color"],
								desc = L["Set the color of the text for the bars"],
								get = getColor,
								set = setColor,
								order = 124,
							},
						}
					},
				},
			}
		end
		return options
	end
end
