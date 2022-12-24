local E, L, C = select(2, ...):unpack()
local P = E.Party

local getColor = function(info)
	local ele, option, c = info[#info-1], info[#info]
	if ele == "bgColors" and option == "inactiveColor" then
		c = E.profile.Party[ info[2] ].extraBars[ info[4] ].barColors.inactiveColor
	else
		c = E.profile.Party[ info[2] ].extraBars[ info[4] ][ele][option]
	end
	return c.r, c.g, c.b, c.a
end

local setColor = function(info, r, g, b, a)
	local key, bar, ele, option = info[2], info[4], info[#info-1], info[#info]
	local c = E.profile.Party[key].extraBars[bar][ele][option]
	c.r = r
	c.g = g
	c.b = b
	c.a = a

	if P:IsCurrentZone(key) then
		P:ConfigExBar(bar, ele)
	end
end

local isRaidCDBar = function(info)
	return info[4] ~= "raidBar0"
end

local isDisabledProgressBarOrNameBar = function(info)
	local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
	return not db.enabled or not db.progressBar or db.layout == "horizontal" or db.nameBar
end

local isEnabledProgressBar = function(info)
	local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
	return not db.enabled or (db.layout == "vertical" and db.progressBar)
end

local sortByValues = {
	raidBar0 = {
		[1] = format("%s>%s>%s", L["Cooldown"], CLASS, NAME),
		[2] = format("%s>%s>%s>%s", L["Cooldown Remaining"], L["Cooldown"], CLASS, NAME),
	},
	raidBar1 = {
		[3] = format("%s>%s>%s>%s", L["Priority"], CLASS, L["Spell ID"], NAME),
		[4] = format("%s>%s>%s>%s", CLASS, L["Priority"], L["Spell ID"], NAME),
	},
}
local interruptBarSortByDesc = format("%s.\n%s.", sortByValues.raidBar0[1], sortByValues.raidBar0[2])
local raidBarSortByDesc = format("%s.\n%s.", sortByValues.raidBar1[3], sortByValues.raidBar1[4])

local notTextColor = function(info) return info[#info-1] ~= "textColors" end

local progressBarColorInfo = {
	lb1 = {
		name = function(info)
			local opt = info[#info-1]
			return opt == "textColors" and NAME
			or (opt == "barColors" and L["Bar"])
			or (opt == "bgColors" and L["BG"])
		end,
		order = 0,
		type = "description",
		width = 0.5
	},
	activeColor = {
		name = "",
		order = 1,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = notTextColor,
		width = 0.5,

	},
	rechargeColor = {
		name = "",
		order = 2,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = notTextColor,
		width = 0.5,
	},
	inactiveColor = {
		disabled = function(info)
			local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
			return not db.enabled
			or not db.progressBar
			or db.layout == "horizontal"
			or info[#info-1] == "bgColors"
			or (info[#info-1] == "barColors" and db.nameBar)
		end,
		name = "",
		order = 3,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = notTextColor,
		width = 0.5,
	},
	useClassColor = {
		name = "",
		order = 4,
		type = "multiselect",
		dialogControl = "Dropdown-OmniCD",
		values = {
			active = L["Active"],
			inactive = L["Inactive"],
			recharge = L["Recharge"],
		},
		get = function(info, k)
			return E.profile.Party[ info[2] ].extraBars[ info[4] ][ info[#info-1] ].useClassColor[k]
		end,
		set = function(info, k, value)
			local key, bar = info[2], info[4]
			E.profile.Party[key].extraBars[bar][ info[#info-1] ].useClassColor[k] = value

			if P:IsCurrentZone(key) then
				P:ConfigExBar(bar, "barColors")
			end
		end,
		disabledItem = function(info)
			return info[#info-1] == "bgColors" and "inactive"
		end,
	},
}

local extraBarsInfo = {
	disabled = function(info)
		return info[5] and not E.profile.Party[ info[2] ].extraBars[ info[4] ].enabled
	end,
	name = function(info)
		local bar = info[4]
		return bar == "raidBar0" and L["Interrupt Bar"] or P.extraBars[bar].index
	end,
	order = function(info)
		return P.extraBars[ info[4] ].index
	end,
	type = "group",
	args = {
		enabled = {
			disabled = false,
			name = ENABLE,
			desc = function(info)
				return info[4] == "raidBar0" and format("%s\n\n|cffffd200%s", L["Move your group's Interrupt spells to the Interrupt Bar."], L["Interrupt spell types are automatically added to this bar."])
				or format("%s\n\n|cffffd200%s", L["Move your group's Raid Cooldowns to the Raid Bar."], L["Select the spells you want to move from the \'Raid CD\' tab. The spell must be enabled from the \'Spells\' tab first."])
			end,
			order = 1,
			type = "toggle",
		},
		locked = {
			name = LOCK_FRAME,
			desc = L["Lock frame position"],
			order = 2,
			type = "toggle",
		},
		lb1 = {
			name = "", order = 3, type = "description"
		},
		spellType = {
			hidden = function(info)
				return info[4] == "raidBar0"
			end,
			name = L["Spell Types"],
			desc = format("|cffff2020[%s]|r %s", L["Multiselect"], L["Select the spell types you want to display on this column."]),
			order = 11,
			type = "multiselect",
			dialogControl = "Dropdown-OmniCD",
			values = E.L_PRIORITY,
			get = function(info, k) return E.DB.profile.Party[ info[2] ].extraBars[ info[4] ].spellType[k] end,
			set = function(info, k, state)
				local key = info[2]
				for bar in pairs(P.extraBars) do
					E.DB.profile.Party[key].extraBars[bar].spellType[k] = state and bar == info[4]
				end
				if P:IsCurrentZone(key) then
					P:UpdateEnabledSpells()
					P:Refresh()
				end
			end,
			disabledItem = function() return "interrupt" end,
		},
		layout = {
			name = L["Layout"],
			desc = L["Select the icon layout"],
			order = 12,
			type = "select",
			values = {
				horizontal = L["Horizontal"],
				vertical = L["Vertical"],
			},
		},
		sortBy = {
			name = COMPACT_UNIT_FRAME_PROFILE_SORTBY,
			desc = function(info)
				return info[4] == "raidBar0" and interruptBarSortByDesc or raidBarSortByDesc
			end,
			order = 13,
			type = "select",
			values = function(info)
				return sortByValues[ info[4] ] or sortByValues.raidBar1
			end,
		},
		sortDirection = {
			name = L["Sort Direction"],
			order = 14,
			type = "select",
			values = {
				asc = L["Ascending"],
				dsc = L["Descending"],
			}
		},
		lb2 = {
			name = "", order = 15, type = "description"
		},
		columns = {
			name = function(info)
				return E.profile.Party[ info[2] ].extraBars[ info[4] ].layout == "horizontal"
				and L["Column"] or L["Row"]
			end,
			desc = function(info)
				return E.profile.Party[ info[2] ].extraBars[ info[4] ].layout == "horizontal"
				and L["Set the number of icons per row"] or L["Set the number of icons per column"]
			end,
			order = 21,
			type = "range",
			min = 1, max = 100, softMax = 30, step = 1,
		},
		paddingX = {
			name = L["Padding X"],
			desc = L["Set the padding space between icon columns"],
			order = 22,
			type = "range",
			min = -5, max = 100, softMin = -1, softMax = 20, step = 1,
		},
		paddingY = {
			name = L["Padding Y"],
			desc = L["Set the padding space between icon rows"],
			order = 23,
			type = "range",
			min = -5, max = 100, softMin = -1, softMax = 20, step = 1,
		},
		scale = {
			name = L["Icon Size"],
			desc = L["Set the size of icons"],
			order = 24,
			type = "range",
			min = 0.2, max = 2.0, step = 0.01, isPercent = true,
		},
		growUpward = {
			name = L["Grow Rows Upward"],
			desc = L["Toggle the grow direction of icon rows"],
			order = 31,
			type = "toggle",
		},
		growLeft = {
			name = L["Grow Columns Left"],
			desc = L["Toggle the grow direction of icon columns"],
			order = 32,
			type = "toggle",
		},
		showName = {
			disabled = isEnabledProgressBar,
			name = L["Show Name"],
			desc = L["Show name on icons"],
			order = 33,
			type = "toggle",
		},
		truncateIconName = {
			disabled = isEnabledProgressBar,
			name = L["Truncate Name"],
			desc = L["Adjust value until the truncate symbol [...] disappears.\n|cffff20200: Disable option"],
			order = 34,
			type = "range",
			min = 0, max = 20, step = 1,
		},
		lb3 = {
			name = "\n", order = 35, type = "description"
		},
		progressBar = {
			disabled = function(info)
				local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
				return not db.enabled or not db.progressBar or db.layout == "horizontal"
			end,
			name = format("%s / %s", L["Status Bar Timer"], L["Name Bar"]),
			order = 40,
			type = "group",
			inline = true,
			args = {
				progressBar = {
					disabled = function(info)
						local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
						return not db.enabled or db.layout == "horizontal"
					end,
					name = ENABLE,
					desc = L["Replace default timers with a status bar timer."],
					order = 1,
					type = "toggle",
				},
				lb1 = {
					name = "\n", order = 4, type = "description"
				},
				colField = {
					name = "",
					order = 11,
					type = "group",
					inline = true,
					args = {
						lb0 = { name = "", order = 0, type = "description", width = 0.5 },
						lb1 = { name = L["Active"], order = 1, type = "description", width = 0.5 },
						lb2 = { name = L["Recharge"], order = 2, type = "description", width = 0.5 },
						lb3 = { name = L["Inactive"], order = 3, type = "description", width = 0.5 },
						lb4 = { name = format("%s (%s)", CLASS_COLORS, L["Multiselect"]),
							order = 4, type = "description", width = 1 },
					}
				},
				textColors = {
					name = "",
					order = 12,
					type = "group",
					inline = true,
					get = getColor,
					set = setColor,
					args = progressBarColorInfo,
				},
				barColors = {
					disabled = isDisabledProgressBarOrNameBar,
					name = "",
					order = 13,
					type = "group",
					inline = true,
					get = getColor,
					set = setColor,
					args = progressBarColorInfo,
				},
				bgColors = {
					disabled = isDisabledProgressBarOrNameBar,
					name = "",
					order = 14,
					type = "group",
					inline = true,
					get = getColor,
					set = setColor,
					args = progressBarColorInfo,
				},
				lb2 = {
					name = "\n\n", order = 15, type = "description"
				},
				nameBar = {
					name = L["Convert to Name Bar"],
					desc = L["Convert the status bar timer to a simple name display by disabling all timer functions. The \'Name\' color scheme will be retained."],
					order = 21,
					type = "toggle",
				},
				invertNameBar = {
					disabled = function(info)
						local db = E.profile.Party[ info[2] ].extraBars[ info[4] ]
						return not db.enabled or not db.progressBar or db.layout == "horizontal" or not db.nameBar
					end,
					name = L["Invert Name Bar"],
					desc = L["Attach Name Bar to the left of icon"],
					order = 22,
					type = "toggle",
				},
				reverseFill = {
					disabled = isDisabledProgressBarOrNameBar,
					name = L["Reverse Fill"],
					desc = L["Timer will progress from right to left"],
					order = 23,
					type = "toggle",
				},
				hideSpark = {
					disabled = isDisabledProgressBarOrNameBar,
					name = L["Hide Spark"],
					desc = L["Hide the leading spark texture."],
					order = 24,
					type = "toggle",
				},
				hideBorder = {
					disabled = isDisabledProgressBarOrNameBar,
					name = L["Hide Border"],
					desc = L["Hide status bar border"],
					order = 25,
					type = "toggle",
				},
				showInterruptedSpell = {
					hidden = function(info)
						return E.preCata or isRaidCDBar(info)
					end,
					disabled = isDisabledProgressBarOrNameBar,
					name = L["Interrupted Spell Icon"],
					desc = format("%s\n\n|cffff2020%s",
					L["Show the interrupted spell icon."],
					L["Mouseovering the icon will show the interrupted spell information regardless of \'Show Tooltip\' option."]),
					order = 26,
					type = "toggle",
				},
				showRaidTargetMark = {
					hidden = function(info)
						return E.preCata or isRaidCDBar(info)
					end,
					disabled = isDisabledProgressBarOrNameBar,
					name = L["Interrupted Target Marker"] .. E.RAID_TARGET_MARKERS[1],
					desc = L["Show the interrupted unit's target marker if it exists."],
					order = 27,
					type = "toggle",
				},
				lb3 = {
					name = "\n", order = 28, type = "description"
				},
				statusBarWidth = {
					name = L["Bar width"],
					desc = format("%s\n\n%s", L["Set the status bar width. Adjust height with \'Icon Size\'."], E.STR.MAX_RANGE),
					order = 31,
					type = "range",
					min = 50, max = 999, softMax = 300, step = 1,
				},

				textOfsX = {
					name = L["Name Offset X"],
					order = 32,
					type = "range",
					min = 1, max = 30, step = 1,
				},
				textOfsY = {
					name = L["Name Offset Y"],
					order = 33,
					type = "range",
					min = -10, max = 10, step = 1,
				},
				truncateStatusBarName = {
					name = L["Truncate Name"],
					desc = L["Adjust value until the truncate symbol [...] disappears.\n|cffff20200: Disable option"],
					order = 34,
					type = "range",
					min = 0, max = 20, step = 1,
					get = function(info) return E.profile.Party[ info[2] ].extraBars[ info[4] ].truncateStatusBarName end,
					set = function(info, value)
						local key, bar = info[2], info[4]
						E.profile.Party[key].extraBars[bar].truncateStatusBarName = value
						if P:IsCurrentZone(key) then
							for _, icon in pairs(P.extraBars[bar].icons) do
								local name = P.groupInfo[icon.guid].name
								if value > 0 then
									name = string.utf8sub(name, 1, value)
								end
								local statusBar = icon.statusBar
								local castingBar = statusBar.CastingBar
								statusBar.name = name
								castingBar.name = name
								statusBar.Text:SetText(name)
								castingBar.Text:SetText(name)
							end
						end
					end,
				},
			}
		},
		lb4 = {
			name = "\n", order = 41, type = "description"
		},
		reset = {
			name = RESET_POSITION,
			desc = L["Reset frame position"],
			order = 51,
			type = "execute",
			func = function(info)
				local key, bar = info[2], info[4]
				local frame = P.extraBars[bar]
				if frame then
					if E.profile.Party[key].extraBars[bar].manualPos[bar] then
						wipe(E.profile.Party[key].extraBars[bar].manualPos[bar])
					end
					if P:IsCurrentZone(key) then
						E.LoadPosition(frame)
					end
				end
			end,
			confirm = E.ConfirmAction,
		},
		resetBar = {
			name = RESET_TO_DEFAULT,
			desc = L["Reset current bar settings to default"],
			order = 52,
			type = "execute",
			func = function(info)
				local key, bar = info[2], info[4]
				E.profile.Party[key].extraBars[bar] = E:DeepCopy(C.Party[key].extraBars[bar])
				E:RefreshProfile()
			end,
			confirm = E.ConfirmAction,
		},
	}
}

local extraBars = {
	name = L["Extra Bars"],
	type = "group",
	childGroups = "tab",
	order = 70,
	get = function(info) return E.profile.Party[ info[2] ].extraBars[ info[4] ][ info[#info] ] end,
	set = function(info, value)
		local key, bar, option = info[2], info[4], info[#info]
		E.profile.Party[key].extraBars[bar][option] = value

		if P:IsCurrentZone(key) then
			if option == "locked" then
				P:SetExAnchor(bar)
			elseif option == "scale" then
				P:ConfigExSize(bar, true)
			elseif option == "enabled" then
				P:Refresh(true)
			else
				P:ConfigExBar(bar, option)
			end
		end
	end,
	args = {}
}

for i = 0, 8 do
	local bar = "raidBar" .. i
	extraBars.args[bar] = extraBarsInfo
end

function P:ConfigExBar(key, arg)
	local db = E.db.extraBars[key]
	local frame = self.extraBars[key]
	for i = 1, frame.numIcons do
		local icon = frame.icons[i]
		local statusBar = icon.statusBar
		if arg == "layout" or arg == "progressBar" then
			if db.layout == "vertical" and db.progressBar then
				statusBar = statusBar or self:GetStatusBar(icon, key)
				self:SetExBorder(icon, key)
				self:SetExStatusBarWidth(statusBar, key)
				self:SetExStatusBarColor(icon, key)
			elseif statusBar then
				self:RemoveStatusBar(statusBar)
				icon.statusBar = nil
			end
			self:SetExIconName(icon, key)
			self:SetOpacity(icon)
		elseif arg == "showName" or arg == "truncateIconName" then
			self:SetExIconName(icon, key)
		elseif arg == "barColors" or arg == "bgColors" or arg == "textColors" or arg == "reverseFill" or arg == "hideSpark" then
			self.CastingBarFrame_OnLoad(statusBar.CastingBar, db, icon)
			self:SetExStatusBarColor(icon, key)
		elseif arg == "statusBarWidth" or arg == "textOfsX" or arg == "textOfsY" or arg == "invertNameBar" then
			self:SetExStatusBarWidth(statusBar, key)
		elseif arg == "hideBorder" then
			P:SetExBorder(icon, key)
		elseif arg == "nameBar" then
			self:SetExBorder(icon, key)
			self.CastingBarFrame_OnLoad(statusBar.CastingBar, db, icon)
			self:SetExStatusBarColor(icon, key)
			self:SetSwipeCounter(icon)
			self:SetExStatusBarWidth(statusBar, key)
		end
	end

	local sortOrder = arg == "sortBy" or arg == "growUpward" or arg == "sortDirection" or arg == "layout" or arg == "growLeft"
	if sortOrder or arg == "progressBar" or arg == "columns" or arg == "paddingX" or arg == "paddingY"
		or arg == "statusBarWidth" or arg == "groupPadding" then
		self:UpdateExBarPositionValues()
		self:SetExIconLayout(key, true, sortOrder, true)
	end
end

local sliderTimer = {}

local updatePixelObj = function(key, noDelay)
	local frame = P.extraBars[key]
	P:UpdateExBarBackdrop(frame, key)
	P:UpdateExBarPositionValues()
	P:SetExIconLayout(key, true)
	P:SetExAnchor(key)

	if not noDelay then
		sliderTimer[key] = nil
	end
end

function P:ConfigExSize(key, slider)
	local db = E.db.extraBars[key]
	local frame = self.extraBars[key]
	frame.container:SetScale(db.scale)

	if E.db.icons.displayBorder or (db.layout == "vertical" and db.progressBar) then
		if slider then
			if not sliderTimer[key] then
				sliderTimer[key] = E.TimerAfter(0.3, updatePixelObj, key)
			end
		else
			updatePixelObj(key, true)
		end
	end
end



function P:SetExAnchor(key)
	local frame = self.extraBars[key]
	local db = frame.db
	if db.locked then
		frame.anchor:Hide()
	else
		frame.anchor:ClearAllPoints()
		frame.anchor:SetPoint(frame.anchorPoint, frame, frame.point, 0, frame.anchorOfsY)
		if frame.shouldShowProgressBar then
			frame.anchor:SetWidth((E.BASE_ICON_SIZE + db.statusBarWidth) * db.scale)
		else
			local width = math.max(frame.anchor.text:GetWidth() + 20, E.BASE_ICON_SIZE * db.scale)
			frame.anchor:SetWidth(width)
		end
		frame.anchor:Show()
	end
end

function P:SetExScale(key)
	local frame = self.extraBars[key]
	local db = frame.db
	frame.container:SetScale(db.scale)

	if E.db.icons.displayBorder or (db.layout == "vertical" and db.progressBar) then
		self:UpdateExBarBackdrop(frame, key)
	end
end

function P:UpdateExBarBackdrop(frame, key)
	local icons = frame.icons
	for i = 1, frame.numIcons do
		local icon = icons[i]
		self:SetExBorder(icon, key)
	end
end

function P:SetExBorder(icon, key)
	local db = E.db.extraBars[key]
	local db_icon = E.db.icons
	local edgeSize = E.PixelMult / db.scale
	local r, g, b = db_icon.borderColor.r, db_icon.borderColor.g, db_icon.borderColor.b
	local shouldShowProgressBar = db.layout == "vertical" and db.progressBar

	if db_icon.displayBorder or shouldShowProgressBar then
		icon.borderTop:ClearAllPoints()
		icon.borderBottom:ClearAllPoints()
		icon.borderLeft:ClearAllPoints()
		icon.borderRight:ClearAllPoints()
		icon.borderTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
		icon.borderTop:SetPoint("BOTTOMRIGHT", icon, "TOPRIGHT", 0, -edgeSize)
		icon.borderBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
		icon.borderBottom:SetPoint("TOPRIGHT", icon, "BOTTOMRIGHT", 0, edgeSize)
		icon.borderLeft:SetPoint("TOPLEFT", icon, "TOPLEFT")
		icon.borderLeft:SetPoint("BOTTOMRIGHT", icon, "BOTTOMLEFT", edgeSize, 0)
		icon.borderRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
		icon.borderRight:SetPoint("BOTTOMLEFT", icon, "BOTTOMRIGHT", -edgeSize, 0)
		icon.borderTop:SetColorTexture(r, g, b)
		icon.borderBottom:SetColorTexture(r, g, b)
		icon.borderLeft:SetColorTexture(r, g, b)
		icon.borderRight:SetColorTexture(r, g, b)
		icon.borderTop:Show()
		icon.borderBottom:Show()
		icon.borderLeft:Show()
		icon.borderRight:Show()
		icon.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	else
		icon.borderTop:Hide()
		icon.borderBottom:Hide()
		icon.borderRight:Hide()
		icon.borderLeft:Hide()
		icon.icon:SetTexCoord(0, 1, 0, 1)
	end

	local statusBar = icon.statusBar
	if shouldShowProgressBar then
		if db.nameBar then
			statusBar:DisableDrawLayer("BORDER")
		else
			statusBar:EnableDrawLayer("BORDER")
			statusBar.borderTop:ClearAllPoints()
			statusBar.borderBottom:ClearAllPoints()
			statusBar.borderRight:ClearAllPoints()
			statusBar.borderTop:SetPoint("TOPLEFT", statusBar, "TOPLEFT")
			statusBar.borderTop:SetPoint("BOTTOMRIGHT", statusBar, "TOPRIGHT", 0, -edgeSize)
			statusBar.borderBottom:SetPoint("BOTTOMLEFT", statusBar, "BOTTOMLEFT")
			statusBar.borderBottom:SetPoint("TOPRIGHT", statusBar, "BOTTOMRIGHT", 0, edgeSize)
			statusBar.borderRight:SetPoint("TOPRIGHT", statusBar.borderTop, "BOTTOMRIGHT")
			statusBar.borderRight:SetPoint("BOTTOMLEFT", statusBar.borderBottom, "TOPRIGHT", -edgeSize, 0)
			statusBar.borderTop:SetColorTexture(r, g, b)
			statusBar.borderBottom:SetColorTexture(r, g, b)
			statusBar.borderRight:SetColorTexture(r, g, b)
			if db.hideBorder then
				statusBar.borderTop:Hide()
				statusBar.borderBottom:Hide()
				statusBar.borderRight:Hide()
			else
				statusBar.borderTop:SetColorTexture(r, g, b)
				statusBar.borderBottom:SetColorTexture(r, g, b)
				statusBar.borderRight:SetColorTexture(r, g, b)
				statusBar.borderTop:Show()
				statusBar.borderBottom:Show()
				statusBar.borderRight:Show()
			end
		end
	end
end

function P:SetExIconName(icon, key)
	local db = E.db.extraBars[key]
	if db.layout == "vertical" and db.progressBar or not db.showName then
		icon.name:Hide()
	else
		local unitName = self.groupInfo[icon.guid].name
		local numChar = db.truncateIconName
		if numChar > 0 then
			unitName = string.utf8sub(unitName, 1, numChar)
		end
		icon.name:SetText(unitName)
		icon.name:Show()
	end
end

function P:SetExStatusBarWidth(statusBar, key)
	local db = E.db.extraBars[key]
	statusBar:SetWidth(db.statusBarWidth)

	statusBar.Text:ClearAllPoints()
	if db.nameBar and db.invertNameBar then
		statusBar.Text:SetPoint("TOPLEFT", statusBar.icon, "TOPLEFT", -db.statusBarWidth + db.textOfsX, db.textOfsY)
		statusBar.Text:SetPoint("BOTTOMRIGHT", statusBar.icon, "BOTTOMLEFT", -db.textOfsX, db.textOfsY)
		statusBar.Text:SetJustifyH("RIGHT")
	else
		statusBar.Text:SetPoint("LEFT", statusBar, db.textOfsX, db.textOfsY)
		statusBar.Text:SetPoint("RIGHT", statusBar, -3, db.textOfsY)
		statusBar.Text:SetJustifyH("LEFT")
	end
	statusBar.CastingBar.Text:SetPoint("LEFT", statusBar.CastingBar, db.textOfsX, db.textOfsY)
	statusBar.CastingBar.Timer:SetPoint("RIGHT", statusBar.CastingBar, -3, db.textOfsY)
end

function P:SetExStatusBarColor(icon, key)
	local info = self.groupInfo[icon.guid]
	if not info then return end

	local db = E.db.extraBars[key]
	local c, r, g, b, a = RAID_CLASS_COLORS[icon.class]
	local statusBar = icon.statusBar




	if not db.nameBar or not icon.active then
		if info.isDeadOrOffline then
			r, g, b = 0.3, 0.3, 0.3
		elseif db.textColors.useClassColor.inactive then
			r, g, b = c.r, c.g, c.b
		else
			local text_c = db.textColors.inactiveColor
			r, g, b = text_c.r, text_c.g, text_c.b
		end
		statusBar.Text:SetTextColor(r, g, b)
	end

	statusBar.BG:SetShown(not db.nameBar and not icon.active)
	statusBar.Text:SetShown(db.nameBar or not icon.active)


	local bar_c = db.barColors.inactiveColor
	local alpha = bar_c.a
	local spellID = icon.spellID
	if info.isDeadOrOffline then
		r, g, b, a = 0.3, 0.3, 0.3, alpha
	elseif info.preactiveIcons[spellID] and spellID ~= 1022 and spellID ~= 204018 then
		r, g, b, a = 0.7, 0.7, 0.7, alpha
	elseif db.barColors.useClassColor.inactive then
		r, g, b, a = c.r, c.g, c.b, alpha
	else
		r, g, b, a =  bar_c.r, bar_c.g, bar_c.b, alpha
	end
	statusBar.BG:SetVertexColor(r, g, b, a)


end

P:RegisterSubcategory("extraBars", extraBars)
