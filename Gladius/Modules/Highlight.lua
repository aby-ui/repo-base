local Gladius = _G.Gladius
if not Gladius then
	DEFAULT_CHAT_FRAME:AddMessage(format("Module %s requires Gladius", "Highlight"))
end
local L = Gladius.L
local LSM

-- Global Functions
local abs = abs
local pairs = pairs
local strfind = string.find

local CreateFrame = CreateFrame
local IsInRaid = IsInRaid
local UnitGUID = UnitGUID

local Highlight = Gladius:NewModule("Highlight", false, false, {
	highlightHover = true,
	highlightHoverColor = {r = 1.0, g = 1.0, b = 1.0, a = 1.0},
	highlightTarget = true,
	highlightTargetColor = {r = 1, g = .7, b = 0, a = 1},
	highlightTargetPriority = 10,
	highlightFocus = true,
	highlightFocusColor = {r = 1, g = 0, b = 0, a = 1},
	highlightFocusPriority = 0,
	highlightAssist = true,
	highlightAssistColor = {r = 0, g = 1, b = 0, a = 1},
	highlightAssistPriority = 9,
	highlightRaidIcon1 = false,
	highlightRaidIcon1Color = {r = 1, g = 1, b = 0, a = 1},
	highlightRaidIcon1Priority = 8,
	highlightRaidIcon2 = false,
	highlightRaidIcon2Color = {r = 1, g = 0.55, b = 0, a = 1},
	highlightRaidIcon2Priority = 7,
	highlightRaidIcon3 = false,
	highlightRaidIcon3Color = {r = 1, g = 0.08, b = 0.58, a = 1},
	highlightRaidIcon3Priority = 6,
	highlightRaidIcon4 = false,
	highlightRaidIcon4Color = {r = 0.13, g = 0.55, b = 0.13, a = 1},
	highlightRaidIcon4Priority = 5,
	highlightRaidIcon5 = false,
	highlightRaidIcon5Color = {r = 0.86, g = 0.86, b = 0.86, a = 1},
	highlightRaidIcon5Priority = 4,
	highlightRaidIcon6 = false,
	highlightRaidIcon6Color = {r = 0.12, g = 0.56, b = 1.0, a = 1},
	highlightRaidIcon6Priority = 3,
	highlightRaidIcon7 = false,
	highlightRaidIcon7Color = {r = 1, g = 0.27, b = 0, a = 1},
	highlightRaidIcon7Priority = 2,
	highlightRaidIcon8 = false,
	highlightRaidIcon8Color = {r = 1, g = 1, b = 1, a = 1},
	highlightRaidIcon8Priority = 1,
	highlightWidth = 1,
	highlightInset = false
})

function Highlight:OnEnable()
	self:RegisterEvent("UNIT_TARGET")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED", "UNIT_TARGET")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "UNIT_TARGET")
	LSM = Gladius.LSM
	-- frame
	if not self.frame then
		self.frame = { }
	end
end

function Highlight:OnDisable()
	for unit in pairs(self.frame) do
		local button = Gladius.buttons[unit]
		local secure = button.secure
		button:SetScript("OnEnter", nil)
		button:SetScript("OnLeave", nil)
		secure:SetScript("OnEnter", nil)
		secure:SetScript("OnLeave", nil)
		self.frame[unit]:SetAlpha(0)
	end
end

function Highlight:UpdateColors(unit)
	if Gladius.test then
		if Gladius.db.highlightTarget and unit == "arena1" then
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightTargetColor.r, Gladius.db.highlightTargetColor.g, Gladius.db.highlightTargetColor.b, Gladius.db.highlightTargetColor.a)
		elseif Gladius.db.highlightFocus and unit == "arena2" then
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightFocusColor.r, Gladius.db.highlightFocusColor.g, Gladius.db.highlightFocusColor.b, Gladius.db.highlightFocusColor.a)
		end
	else
		if Gladius.db.highlightTarget and UnitGUID(unit) == UnitGUID("target") then
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightTargetColor.r, Gladius.db.highlightTargetColor.g, Gladius.db.highlightTargetColor.b, Gladius.db.highlightTargetColor.a)
		elseif Gladius.db.highlightFocus and UnitGUID(unit) == UnitGUID("focus") then
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightFocusColor.r, Gladius.db.highlightFocusColor.g, Gladius.db.highlightFocusColor.b, Gladius.db.highlightFocusColor.a)
		end
	end
end

function Highlight:GetAttachTo()
	return ""
end

function Highlight:GetFrame(unit)
	return ""
end

function Highlight:UNIT_TARGET(event, unit)
	local unit = unit or ""
	if (unit ~= "" and ((not IsInRaid()) or strfind(unit, "pet") or (not strfind(unit, "raid") and not strfind(unit, "party")))) then
		return
	end
	local playerTargetGUID = UnitGUID("target")
	local focusGUID = UnitGUID("focus")
	local targetGUID = UnitGUID(unit.."target")
	for arenaUnit, frame in pairs(self.frame) do
		-- reset
		self:Reset(arenaUnit)
		--[[if targetGUID and UnitGUID(arenaUnit) == targetGUID and unit ~= "" then
			-- main assist
			if Gladius.db.highlightAssist and GetPartyAssignment("MAINASSIST", unit) == 1 then
				if frame.priority < Gladius.db.highlightTargetPriority then
					frame.priority = Gladius.db.highlightTargetPriority
					frame:SetBackdropBorderColor(Gladius.db.highlightAssistColor.r, Gladius.db.highlightAssistColor.g, Gladius.db.highlightAssistColor.b, Gladius.db.highlightAssistColor.a)
				end
			end
			-- raid target icon
			local icon = GetRaidTargetIndex(unit)
			if icon and Gladius.db["highlightRaidIcon"..icon] then
				if frame.priority < Gladius.db["highlightRaidIcon"..icon.."Priority"] then
					frame.priority = Gladius.db["highlightRaidIcon"..icon.."Priority"]
					frame:SetBackdropBorderColor(Gladius.db["highlightRaidIcon"..icon.."Color"].r, Gladius.db["highlightRaidIcon"..icon.."Color"].g, Gladius.db["highlightRaidIcon"..icon.."Color"].b, Gladius.db["highlightRaidIcon"..icon.."Color"].a)
				end
			end
		end]]
		-- player target
		if playerTargetGUID and UnitGUID(arenaUnit) == playerTargetGUID then
			if frame.priority < Gladius.db.highlightTargetPriority then
				frame.priority = Gladius.db.highlightTargetPriority
				frame:SetBackdropBorderColor(Gladius.db.highlightTargetColor.r, Gladius.db.highlightTargetColor.g, Gladius.db.highlightTargetColor.b, Gladius.db.highlightTargetColor.a)
			end
		end
		-- player focus
		if focusGUID and UnitGUID(arenaUnit) == focusGUID then
			if frame.priority < Gladius.db.highlightFocusPriority then
				frame.priority = Gladius.db.highlightFocusPriority
				frame:SetBackdropBorderColor(Gladius.db.highlightFocusColor.r, Gladius.db.highlightFocusColor.g, Gladius.db.highlightFocusColor.b, Gladius.db.highlightFocusColor.a)
			end
		end
	end
end

function Highlight:CreateFrame(unit)
	local button = Gladius.buttons[unit]
	if not button then
		return
	end
	-- create frame
	self.frame[unit] = CreateFrame("Frame", "Gladius"..self.name..unit, button, BackdropTemplateMixin and "BackdropTemplate")
	-- set priority
	self.frame[unit].priority = -1
end

function Highlight:Update(unit)
	-- create frame
	if not self.frame[unit] then
		self:CreateFrame(unit)
	end
	-- update frame
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	self.frame[unit]:ClearAllPoints()
	self.frame[unit]:SetPoint("TOPLEFT", Gladius.buttons[unit], "TOPLEFT", left - 3, top + 3)
	self.frame[unit]:SetBackdrop({edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = Gladius.db.highlightWidth,})
	self.frame[unit]:SetBackdropBorderColor(0, 0, 0, 0)
	self.frame[unit]:SetFrameStrata("MEDIUM")
	-- update highlight
	local button = Gladius.buttons[unit]
	local secure = button.secure
	if Gladius.db.highlightHover then
		-- set scripts
		button:SetScript("OnEnter", function(f, motion)
			if motion and f:GetAlpha() > 0 then
				for _, m in pairs(Gladius.modules) do
					if m:IsEnabled() and m.frame and m.frame[unit].highlight then
						-- set color
						m.frame[unit].highlight:SetVertexColor(Gladius.db.highlightHoverColor.r, Gladius.db.highlightHoverColor.g, Gladius.db.highlightHoverColor.b, Gladius.db.highlightHoverColor.a)
						-- set alpha
						m.frame[unit].highlight:SetAlpha(0.5)
					end
				end
			end
		end)
		button:SetScript("OnLeave", function(f, motion)
			if motion then
				for _, m in pairs(Gladius.modules) do
					if m:IsEnabled() and m.frame and m.frame[unit].highlight then
						m.frame[unit].highlight:SetAlpha(0)
					end
				end
			end
		end)
		secure:SetScript("OnEnter", function(f, motion)
			if motion and f:GetAlpha() > 0 then
				for _, m in pairs(Gladius.modules) do
					if m:IsEnabled() and m.frame and m.frame[unit].highlight then
						-- set color
						m.frame[unit].highlight:SetVertexColor(Gladius.db.highlightHoverColor.r, Gladius.db.highlightHoverColor.g, Gladius.db.highlightHoverColor.b, Gladius.db.highlightHoverColor.a)
						-- set alpha
						m.frame[unit].highlight:SetAlpha(0.5)
					end
				end
			end
		end)
		secure:SetScript("OnLeave", function(f, motion)
			if motion then
				for _, m in pairs(Gladius.modules) do
					if m:IsEnabled() and m.frame and m.frame[unit].highlight then
						m.frame[unit].highlight:SetAlpha(0)
					end
				end
			end
		end)
	else
		button:SetScript("OnEnter", nil)
		button:SetScript("OnLeave", nil)
		secure:SetScript("OnEnter", nil)
		secure:SetScript("OnLeave", nil)
	end
	-- hide
	self.frame[unit]:SetAlpha(0)
end

function Highlight:Show(unit)
	-- show
	self.frame[unit]:SetAlpha(1)
	local left, right, top, bottom = Gladius.buttons[unit]:GetHitRectInsets()
	local offs = Gladius.db.highlightInset and 0 or 2

	self.frame[unit]:ClearAllPoints()
	self.frame[unit]:SetPoint("TOPLEFT", Gladius.buttons[unit], "TOPLEFT", left - offs, top + offs)
	self.frame[unit]:SetWidth(Gladius.buttons[unit]:GetWidth() + abs(left) + abs(right) + offs*2)
	self.frame[unit]:SetHeight(Gladius.buttons[unit]:GetHeight() + abs(bottom) + abs(top) + offs*2)
end

function Highlight:Reset(unit)
	if not self.frame[unit] then
		return
	end
	if Gladius.test then
		return
	end
	-- set priority
	self.frame[unit].priority = -1
	-- hide border
	self.frame[unit]:SetBackdropBorderColor(0, 0, 0, 0)
end

function Highlight:Test(unit)
	if Gladius.db.highlightTarget then
		if unit == "arena1" then
			self:Show(unit)
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightTargetColor.r, Gladius.db.highlightTargetColor.g, Gladius.db.highlightTargetColor.b, Gladius.db.highlightTargetColor.a)
		end
	else
		if unit == "arena1" then
			self.frame[unit]:SetBackdropBorderColor(0, 0, 0, 0)
		end
	end
	if Gladius.db.highlightFocus then
		if unit == "arena2" then
			self:Show(unit)
			self.frame[unit]:SetBackdropBorderColor(Gladius.db.highlightFocusColor.r, Gladius.db.highlightFocusColor.g, Gladius.db.highlightFocusColor.b, Gladius.db.highlightFocusColor.a)
		end
	else
		if unit == "arena2" then
			self.frame[unit]:SetBackdropBorderColor(0, 0, 0, 0)
		end
	end
end

function Highlight:GetOptions()
	local options = {
		general = {
			type = "group",
			name = L["General"],
			order = 1,
			args = {
				position = {
					type = "group",
					name = L["Position"],
					desc = L["Position settings"],
					inline = true,
					order = 1,
					hidden = function()
						return not Gladius.db.advancedOptions
					end,
					args = {
						highlightWidth = {
							type = "range",
							name = L["Highlight Border Width"],
							desc = L["Highlight Border Width"],
							min = 0, max = 10, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						highlightInset = {
							type = "toggle",
							name = L["Highlight Border Inset"],
							desc = L["Inset the highlight border"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 10,
						},
					},
				},
				hover = {
					type = "group",
					name = L["Hover"],
					desc = L["Hover settings"],
					inline = true,
					order = 2,
					args = {
						highlightHover = {
							type = "toggle",
							name = L["Highlight On Mouseover"],
							desc = L["Highlight frame on mouseover"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						highlightHoverColor = {
							type = "color",
							name = L["Highlight Color"],
							desc = L["Color of the highlight frame"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightAssist
							end,
							order = 10,
						},
					},
				},
				target = {
					type = "group",
					name = L["Player Target"],
					desc = L["Player target settings"],
					inline = true,
					order = 10,
					args = {
						highlightTarget = {
							type = "toggle",
							name = L["Highlight Target"],
							desc = L["Show border around player target"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						highlightTargetColor = {
							type = "color",
							name = L["Highlight Target Color"],
							desc = L["Color of the target border"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightTarget
							end,
							order = 10,
						},
						highlightTargetPriority = {
							type = "range",
							name = L["Highlight Target Priority"],
							desc = L["Priority of the target border"],
							min = 0, max = 10, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightTarget
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							width = "double",
							order = 15,
						},
					},
				},
				focus = {
					type = "group",
					name = L["Player Focus Target"],
					desc = L["Player focus target settings"],
					inline = true,
					order = 20,
					args = {
						highlightFocus = {
							type = "toggle",
							name = L["Highlight Focus Target"],
							desc = L["Show border around player target"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						highlightFocusColor = {
							type = "color",
							name = L["Highlight Focus Target Color"],
							desc = L["Color of the focus target border"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightFocus
							end,
							order = 10,
						},
						highlightFocusPriority = {
							type = "range",
							name = L["Highlight Focus Target Priority"],
							desc = L["Priority of the focus target border"],
							min = 0, max = 10, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightFocus
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							width = "double",
							order = 15,
						},
					},
				},
				--[[assist = {
					type = "group",
					name = L["Raid Assist Target"],
					desc = L["Raid assist settings"],
					inline = true,
					order = 30,
					args = {
						highlightAssist = {
							type = "toggle",
							name = L["Highlight Raid Assist"],
							desc = L["Show border around raid assist"],
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name]
							end,
							order = 5,
						},
						highlightAssistColor = {
							type = "color",
							name = L["Highlight Raid Assist Color"],
							desc = L["Color of the raid assist border"],
							hasAlpha = true,
							get = function(info)
								return Gladius:GetColorOption(info)
							end,
							set = function(info, r, g, b, a)
								return Gladius:SetColorOption(info, r, g, b, a)
							end,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightAssist
							end,
							order = 10,
						},
						highlightAssistPriority = {
							type = "range",
							name = L["Highlight Raid Assist Priority"],
							desc = L["Priority of the raid assist border"],
							min = 0, max = 10, step = 1,
							disabled = function()
								return not Gladius.dbi.profile.modules[self.name] or not Gladius.db.highlightAssist
							end,
							hidden = function()
								return not Gladius.db.advancedOptions
							end,
							width = "double",
							order = 15,
						},
					},
				},]]
			},
		},
		--[[raidTargets = {
			type = "group",
			name = L["Raid Icon Targets"],
			hidden = function()
				return not Gladius.db.advancedOptions
			end,
			order = 2,
			args = { },
		},]]
	}
	-- raid targets
	--[[for i = 1, 8 do
		options.raidTargets.args["raidTarget"..i] = {
			type = "group",
			name = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_"..i..".blp:0|t"..L["Raid Icon Target "..i],
			desc = L["Raid Icon target "..i.." settings"],
			inline = true,
			order = i,
			args = {
				highlightRaidIcon = {
					type = "toggle",
					name = L["Highlight Raid Target "..i],
					desc = L["Show border around raid target "..i],
					disabled = function()
						return not Gladius.dbi.profile.modules[self.name]
					end,
					arg = "highlightRaidIcon"..i,
					order = 5,
				},
				highlightRaidIconColor = {
					type = "color",
					name = L["Highlight Raid Assist Color"],
					desc = L["Color of the raid assist border"],
					hasAlpha = true,
					get = function(info)
						return Gladius:GetColorOption(info)
					end,
					set = function(info, r, g, b, a)
						return Gladius:SetColorOption(info, r, g, b, a)
					end,
					disabled = function()
						return not Gladius.dbi.profile.modules[self.name]
					end,
					arg = "highlightRaidIcon"..i.."Color",
					order = 10,
				},
				highlightRaidIconPriority = {
					type = "range",
					name = L["Highlight Raid Assist Priority"],
					desc = L["Priority of the raid assist border"],
					min = 0,
					max = 10,
					step = 1,
					disabled = function()
						return not Gladius.dbi.profile.modules[self.name]
					end,
					hidden = function()
						return not Gladius.db.advancedOptions
					end,
					arg = "highlightRaidIcon"..i.."Priority",
					width = "double",
					order = 15,
				},
			},
		}
	end]]
	return options
end
