local E, L, C = select(2, ...):unpack()

local P = E["Party"]

do
	local timers = {}

	local updatePixelObj = function(key, noDelay)
		local f = P.extraBars[key]
		P:UpdateExBarBackdrop(f, key)
		P:UpdateExPositionValues()
		P:SetExIconLayout(key, true)
		P:SetExAnchor(key)

		if not noDelay then
			timers[key] = nil
		end
	end

	function P:ConfigExSize(key, slider)
		local db = E.db.extraBars[key]
		local f = self.extraBars[key]
		f.container:SetScale(db.scale)

		if E.db.icons.displayBorder or (db.layout ~= "horizontal" and db.layout ~= "multirow" and db.progressBar) then
			if slider then
				if not timers[key] then
					timers[key] = E.TimerAfter(0.3, updatePixelObj, key)
				end
			else
				updatePixelObj(key, true)
			end
		end
	end
end

local function ConfigExBar(key, arg)
	local db = E.db.extraBars[key]
	local f = P.extraBars[key]
	for i = 1, f.numIcons do
		local icon = f.icons[i]
		local statusBar = icon.statusBar
		if arg == "layout" or arg == "progressBar" then
			if db.layout ~= "horizontal" and db.layout ~= "multirow" and db.progressBar then
				statusBar = statusBar or P.GetStatusBar(icon, key)
				P:SetExBorder(icon, key)
				P:SetExStatusBarWidth(statusBar, key)
				P:SetExStatusBarColor(icon, key)
			elseif statusBar then
				P.RemoveStatusBar(statusBar)
				icon.statusBar = nil
			end
			P:SetExIconName(icon, key)
			P:SetAlpha(icon)
		elseif arg == "showName" then
			P:SetExIconName(icon, key)

		elseif arg == "useIconAlpha" then
			P:SetExStatusBarColor(icon, key)
			P:SetAlpha(icon)
		elseif arg == "barColors" or arg == "bgColors" or arg == "textColors" or arg == "reverseFill" or arg == "hideSpark" then
			P.CastingBarFrame_OnLoad(statusBar.CastingBar, key, icon)
			P:SetExStatusBarColor(icon, key)
		elseif arg == "statusBarWidth" or arg == "textOfsX" or arg == "textOfsY" then
			P:SetExStatusBarWidth(statusBar, key)
		elseif arg == "hideBorder" then
			P:SetExBorder(icon, key)
		elseif arg == "hideBar" then
			P:SetExBorder(icon, key)
			P.CastingBarFrame_OnLoad(statusBar.CastingBar, key, icon)
			P:SetExStatusBarColor(icon, key)
			P:SetSwipe(icon)
			P:SetCounter(icon)
		end
	end

	local sortOrder = arg == "sortBy" or arg == "growUpward" or arg == "sortDirection" or arg == "layout" or arg == "growLeft"
	if sortOrder or arg == "progressBar" or arg == "columns" or arg == "paddingX" or arg == "paddingY" or arg == "statusBarWidth" or arg == "groupPadding" or arg == "groupDetached" then
		P:UpdateExPositionValues()
		P:SetExIconLayout(key, true, sortOrder, true)
	end
end

P.isExBarDisabled = function(info) return info[5] and not E.DB.profile.Party[info[2]].extraBars[info[#info-1]].enabled end
P.getExBar = function(info) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info]] end
P.setExBar = function(info, state)
	local key, bar, option = info[2], info[4], info[#info]
	E.DB.profile.Party[key].extraBars[bar][option] = state

	if E.db == E.DB.profile.Party[key] then
		if option == "locked" then
			P:SetExAnchor(bar)
		elseif option == "scale" then
			P:ConfigExSize(bar, true)

		elseif option == "enabled" then
			P:Refresh(true)
		else
			ConfigExBar(bar, option)
		end
	end
end

local getColor = function(info)
	local ele, option, c = info[#info-1], info[#info]
	if ele == "bgColors" and option == "inactiveColor" then
		c = E.DB.profile.Party[info[2]].extraBars[info[4]].barColors.inactiveColor
	else
		c = E.DB.profile.Party[info[2]].extraBars[info[4]][ele][option]
	end
	return c.r, c.g, c.b, c.a
end

local setColor = function(info, r, g, b, a)
	local key, bar, option = info[2], info[4], info[#info-1]
	local c = E.DB.profile.Party[key].extraBars[bar][option][info[#info]]
	c.r = r
	c.g = g
	c.b = b
	c.a = a

	if E.db == E.DB.profile.Party[key] then
		ConfigExBar(bar, option)
	end
end

local temp = {
	textColors = NAME,
	barColors = L["Bar"],
	bgColors = L["BG"],
}

local sortByValues = {
	interruptBar = {
		[1] = format("%s > %s > %s", L["Cooldown"], CLASS, NAME),
		[2] = format("%s > %s > %s > %s", L["Cooldown Remaining"], L["Cooldown"], CLASS, NAME),
	},
	raidCDBar = {
		[3] = format("%s > %s > %s > %s", L["Priority"], CLASS, L["Spell ID"], NAME),
		[4] = format("%s > %s > %s > %s", CLASS, L["Priority"], L["Spell ID"], NAME),
	}
}
local interruptBarDesc = sortByValues.interruptBar[1] .. ".\n" .. sortByValues.interruptBar[2] .. "."
local raidCDBarDesc = sortByValues.raidCDBar[3] .. ".\n" .. sortByValues.raidCDBar[4] .. "."

local classColorValues = {
	active = L["Active"],
	inactive = L["Inactive"],
	recharge = L["Recharge"],
}

local progressBarColorInfo = {
	lb1 = {
		name = function(info) return temp[info[#info-1]] end,
		order = 0,
		type = "description",
		width = 0.5
	},
	activeColor = {
		name = "",
		order = 1,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = function(info) return info[#info-1] ~= "textColors" end,
		width = 0.5,

	},
	rechargeColor = {
		name = "",
		order = 2,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = function(info) return info[#info-1] ~= "textColors" end,
		width = 0.5,
	},
	inactiveColor = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or not db.progressBar or db.layout == "horizontal" or db.layout == "multirow" or info[#info-1] == "bgColors" or (info[#info-1] == "barColors" and db.hideBar)
		end,
		name = "",
		order = 3,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = function(info) return info[#info-1] == "barColors" end,
		width = 0.5,
	},
	useClassColor = {
		name = "",
		order = 4,
		type = "multiselect",
		dialogControl = "Dropdown-OmniCD",
		values = classColorValues,
		get = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info-1]].useClassColor[k] end,
		set = function(info, k, value)
			local key, bar = info[2], info[4]
			E.DB.profile.Party[key].extraBars[bar][info[#info-1]].useClassColor[k] = value

			if E.db == E.DB.profile.Party[key] then
				ConfigExBar(bar, "barColors")
			end
		end,
		disabledItem = function(info) return info[#info-1] == "bgColors" and "inactive" end,
	},
}

P.extraBarDesc = function(info)
	if info[#info-1] == "interruptBar" then
		return L["Move your group's Interrupt spells to the Interrupt Bar."]
	else
		return L["Move your group's Raid Cooldowns to the Raid Bar."]
	end
end

local isInterruptBar = function(info) return info[4] == "interruptBar" end
local isRaidCDBar = function(info) return info[4] ~= "interruptBar" end
local isRaidMultline = function(info)
	local bar = info[4]
	local layout = E.DB.profile.Party[info[2]].extraBars[bar].layout
	return bar == "raidCDBar" and (layout == "multicolumn" or layout == "multirow")
end
local isDisabledOrNameBar = function(info)
	local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
	return not db.enabled or not db.progressBar or db.layout == "horizontal" or db.layout == "multirow" or db.hideBar
end

local disabledItems = {}
local function GetDisabledItems(info)
	wipe(disabledItems)
	for i = 1, 8 do
		local item = E.DB.profile.Party[info[2]].extraBars[info[4]].groupDetached[i]
		if not item then
			disabledItems[i] = true
		end
	end
	return disabledItems
end

local disableGroupLayout = function(info)
	local layout = E.DB.profile.Party[info[2]].extraBars.raidCDBar.layout
	if layout ~= "multicolumn" and layout ~= "multirow" then
		return true
	end
	for i = 1, 8 do
		local item = disabledItems[i]
		if not item then return false end
	end
	return true
end

local getGroupLayout = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info]][k] end
local setGroupLayout = function(info, k, value)
	local key, bar = info[2], info[4]
	E.DB.profile.Party[key].extraBars[bar][info[#info]][k] = value

	if E.db == E.DB.profile.Party[key] then
		ConfigExBar(bar, "groupDetached")
	end
end

local setDisabledItem = function(info) return GetDisabledItems(info) end

local extraBarsInfo = {
	enabled = {
		disabled = false,
		name = ENABLE,
		desc = P.extraBarDesc,
		order = 1,
		type = "toggle",
	},
	locked = {
		name = LOCK_FRAME,
		desc = L["Lock frame position"],
		order = 2,
		type = "toggle",
	},
	reset = {
		name = RESET_POSITION,
		desc = L["Reset frame position"],
		order = 3,
		type = "execute",
		func = function(info)
			local key, bar = info[2], info[4]
			local f = P.extraBars[bar]
			local isRaidCDBar = bar == "raidCDBar"
			if f then
				if E.DB.profile.Party[key].manualPos[bar] then
					table.wipe(E.DB.profile.Party[key].manualPos[bar])
					if isRaidCDBar then
						for i = 1, 8 do
							local sv = E.DB.profile.Party[key].manualPos[bar .. i]
							if sv then
								table.wipe(sv)
							end
						end
					end
				end

				if E.db == E.DB.profile.Party[key] then
					E.LoadPosition(f)
					if isRaidCDBar then
						for i = 1, 8 do
							local g = _G["OmniCDraidCDBar" .. i]
							if g then
								E.LoadPosition(g)
							end
						end
					end
				end
			end
		end,
		confirm = E.ConfirmAction,
	},
	lb1 = {
		name = "\n", order = 4, type = "description"
	},
	layout = {
		name = L["Layout"],
		desc = L["Select the icon layout"],
		order = 10,
		type = "select",
		values = {
			horizontal = L["Horizontal"],
			vertical = L["Vertical"],
			multicolumn = L["Vertical + CD Groups"],
			multirow = L["Horizontal + CD Groups"],
		},
		sorting = {"horizontal", "multirow", "vertical", "multicolumn"},
		disabledItem = function(info) return not isRaidCDBar(info) and {multicolumn=true, multirow=true} end,
	},
	sortBy = {
		disabled = function(info)
			local bar = info[4]
			local db = E.DB.profile.Party[info[2]].extraBars[bar]
			return not db.enabled or (bar == "raidCDBar" and (db.layout == "multicolumn" or db.layout == "multirow"))
		end,
		name = COMPACT_UNIT_FRAME_PROFILE_SORTBY,
		desc = function(info) return info[#info-1] == "interruptBar" and interruptBarDesc or raidCDBarDesc end,
		order = 11,
		type = "select",
		values = function(info) return sortByValues[info[#info-1]] end,
	},
	sortDirection = {
		disabled = function(info) return not E.DB.profile.Party[info[2]].extraBars[info[4]].enabled or isRaidCDBar(info) end,
		name = L["Sort Direction"],
		order = 12,
		type = "select",
		values = {
			asc = L["Ascending"],
			dsc = L["Descending"],
		}
	},
	columns = {
		name = function(info) local layout = E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout return (layout == "horizontal" or layout == "multirow") and L["Column"] or L["Row"] end,
		desc = function(info) local layout = E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout return (layout == "horizontal" or layout == "multirow") and L["Set the number of icons per row"] or L["Set the number of icons per column"] end,
		order = 13,
		type = "range",
		min = 1, max = 100, softMax = 30, step = 1,
	},
	paddingX = {
		name = L["Padding X"],
		desc = L["Set the padding space between icon columns"],
		order = 14,
		type = "range",
		min = -5, max = 100, softMin = -1, softMax = 20, step = 1,
	},
	paddingY = {
		name = L["Padding Y"],
		desc = L["Set the padding space between icon rows"],
		order = 15,
		type = "range",
		min = -5, max = 100, softMin = -1, softMax = 20, step = 1,
	},
	scale = {
		name = L["Icon Size"],
		desc = L["Set the size of icons"],
		order = 16,
		type = "range",
		min = 0.2, max = 2.0, step = 0.01, isPercent = true,
	},
	showName = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or (db.layout ~= "horizontal" and db.layout ~= "multirow" and db.progressBar)
		end,
		name = NAME,
		desc = L["Show name on icons"],
		order = 17,
		type = "toggle",
	},
	growUpward = {
		name = L["Grow Rows Upward"],
		desc = L["Toggle the grow direction of icon rows"],
		order = 18,
		type = "toggle",
	},
	growLeft = {
		name = L["Grow Columns Left"],
		desc = L["Toggle the grow direction of icon columns"],
		order = 19,
		type = "toggle",
	},
	groupColumns = {
		hidden = isInterruptBar,
		disabled = function(info)
			local bar = info[4]
			local db = E.DB.profile.Party[info[2]].extraBars[bar]
			return not db.enabled or (bar == "raidCDBar" and db.layout ~= "multicolumn" and db.layout ~= "multirow")
		end,
		name = "",
		order = 20,
		type ="group",
		inline = true,
		get = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info]][k] end,
		set = function(info, k, value)
			local key, bar, opt = info[2], info[4], info[#info]

			if value then
				E.DB.profile.Party[key].extraBars[bar][opt][k] = value
				for i = 1, 8 do
					local col = "group" .. i
					if col ~= opt then
						E.DB.profile.Party[key].extraBars[bar][col][k] = nil
					end
				end

				local column = gsub(opt, "group", "")
				column = tonumber(column)
				P:UpdateRaidPriority(k, column)
			else
				E.DB.profile.Party[key].extraBars[bar][opt][k] = nil
				P:UpdateRaidPriority(k, nil)
			end

			if E.db == E.DB.profile.Party[key] then
				ConfigExBar(bar, "layout")
			end
		end,
		args = {
			groupDetached = {
				hidden = isInterruptBar,
				name = L["Detach CD-Group"],
				desc = format("|cffff2020[%s]|r %s", L["Multiselect"], L["Select the column(s) that you want to detach and position manually."]),
				order = 11,
				type = "multiselect",
				dialogControl = "Dropdown-OmniCD",
				values = { 1, 2, 3, 4, 5, 6, 7, 8 },
				disabledItem = 1,
				get = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]].groupDetached[k] end,
				set = function(info, k, value)
					local key, bar = info[2], info[4]
					E.DB.profile.Party[key].extraBars[bar].groupDetached[k] = value

					if E.db == E.DB.profile.Party[key] then
						ConfigExBar(bar, "groupDetached")
					end
				end,
			},
			groupGrowUpward = {
				hidden = isInterruptBar,
				disabled = disableGroupLayout,
				name = L["Grow Rows Upward"],
				desc = format("|cffff2020[%s]|r %s", L["Multiselect"], L["Select the column(s) that you want the rows to grow upwards."]),
				order = 12,
				type = "multiselect",
				dialogControl = "Dropdown-OmniCD",
				values = { 1, 2, 3, 4, 5, 6, 7, 8 },
				get = getGroupLayout,
				set = setGroupLayout,
				disabledItem = setDisabledItem,
			},
			groupGrowLeft = {
				hidden = isInterruptBar,
				disabled = disableGroupLayout,
				name = L["Grow Columns Left"],
				desc = format("|cffff2020[%s]|r %s", L["Multiselect"], L["Select the column(s) that you want the rows to grow upwards."]),
				order = 13,
				type = "multiselect",
				dialogControl = "Dropdown-OmniCD",
				values = { 1, 2, 3, 4, 5, 6, 7, 8 },
				get = getGroupLayout,
				set = setGroupLayout,
				disabledItem = setDisabledItem,
			},
			groupPadding = {
				hidden = isInterruptBar,
				disabled = function(info) local layout = E.DB.profile.Party[info[2]].extraBars.raidCDBar.layout return layout ~= "multicolumn" and layout ~= "multirow" end,
				name = L["CD-Group Padding"],
				desc = L["Set the padding space between CD-groups"],
				order = 14,
				type = "range",
				min = 0, max = 100, step = 1,
				get = P.getExBar,
				set = P.setExBar,
			},
		},
	},
	lb2 = {
		name = "\n", order = 21, type = "description"
	},
	progressBar = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or not db.progressBar or db.layout == "horizontal" or db.layout == "multirow"
		end,
		name = L["Status Bar Timer"] .. " / " .. L["Name Bar"],
		order = 30,
		type = "group",
		inline = true,
		args = {
			progressBar = {
				disabled = function(info)
					local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
					return not db.enabled or db.layout == "horizontal" or db.layout == "multirow"
				end,
				name = ENABLE,
				desc = L["Replace default timers with a status bar timer."],
				order = 1,
				type = "toggle",
			},
			hideBar = {
				name = L["Convert to Name Bar"],
				desc = L["Convert the status bar timer to a simple name display by disabling all timer functions. The \'Name\' color scheme will be retained."],
				order = 2,
				type = "toggle",
			},
			lb1 = {
				name = "", order = 4, type = "description"
			},
			colField = {
				name = "",
				order = 10,
				type = "group",
				inline = true,
				args = {
					lb0 = { name = "", order = 0, type = "description", width = 0.5},
					lb1 = { name = L["Active"], order = 1, type = "description", width = 0.5},
					lb2 = { name = L["Recharge"], order = 2, type = "description", width = 0.5},
					lb3 = { name = L["Inactive"], order = 3, type = "description", width = 0.5},
					lb4 = { name = format("%s (%s)", CLASS_COLORS, L["Multiselect"]), order = 4, type = "description", width = 1},
				}
			},
			textColors = {
				name = "",
				order = 20,
				type = "group",
				inline = true,
				get = getColor,
				set = setColor,
				args = progressBarColorInfo,
			},
			barColors = {
				disabled = isDisabledOrNameBar,
				name = "",
				order = 30,
				type = "group",
				inline = true,
				get = getColor,
				set = setColor,
				args = progressBarColorInfo,
			},
			bgColors = {
				disabled = isDisabledOrNameBar,
				name = "",
				order = 40,
				type = "group",
				inline = true,
				get = getColor,
				set = setColor,
				args = progressBarColorInfo,
			},
			lb2 = {
				name = "\n\n", order = 41, type = "description"
			},
			reverseFill = {
				disabled = isDisabledOrNameBar,
				name = L["Reverse Fill"],
				desc = L["Timer will progress from right to left"],
				order = 51,
				type = "toggle",
			},
			useIconAlpha = {
				name = L["Use Icon Alpha"],
				desc = L["Apply \'Icons\' alpha settings to the status bar"],
				order = 52,
				type = "toggle",
			},
			hideSpark = {
				disabled = isDisabledOrNameBar,
				name = L["Hide Spark"],
				desc = L["Hide the leading spark texture."],
				order = 53,
				type = "toggle",
			},
			hideBorder = {
				disabled = isDisabledOrNameBar,
				name = L["Hide Border"],
				desc = L["Hide status bar border"],
				order = 54,
				type = "toggle",
			},
			showInterruptedSpell = {
				hidden = function(info) return E.isPreWOTLKC or isRaidCDBar(info) end,
				disabled = isDisabledOrNameBar,
				name = L["Interrupted Spell Icon"],
				desc = format("%s\n\n|cffff2020%s", L["Show the interrupted spell icon."], L["Mouseovering the icon will show the interrupted spell information regardless of \'Show Tooltip\' option."]),
				order = 55,
				type = "toggle",
			},
			showRaidTargetMark = {
				hidden = function(info) return E.isPreWOTLKC or isRaidCDBar(info) end,
				disabled = isDisabledOrNameBar,
				name = L["Interrupted Target Marker"] .. E.RAID_TARGET_MARKERS[1],
				desc = L["Show the interrupted unit's target marker if it exists."],
				order = 56,
				type = "toggle",
			},
			lb3 = {
				name = "", order = 57, type = "description"
			},
			statusBarWidth = {
				name = L["Bar width"],
				desc = L["Set the status bar width. Adjust height with \'Icon Size\'."] .. "\n\n" .. E.STR.MAX_RANGE,
				order = 60,
				type = "range",
				min = 50, max = 999, softMax = 300, step = 1,
			},
			textOfsX = {
				name = L["Name Offset X"],
				order = 61,
				type = "range",
				min = 1, max = 20, step = 1,
			},
			textOfsY = {
				name = L["Name Offset Y"],
				order = 62,
				type = "range",
				min = -6, max = 6, step = 1,
			},
			lb4 = {
				name = "\n\n", order = 63, type = "description"
			},
			resetBar = {
				name = RESET_TO_DEFAULT,
				desc = L["Reset Status Bar Timer settings to default"],
				order = 70,
				type = "execute",
				func = function(info)
					local key, bar = info[2], info[4]
					E.DB.profile.Party[key].extraBars[bar].progressBar = C.Party[key].extraBars[bar].progressBar
					E.DB.profile.Party[key].extraBars[bar].hideBar = C.Party[key].extraBars[bar].hideBar
					E.DB.profile.Party[key].extraBars[bar].textColors = E.DeepCopy(C.Party[key].extraBars[bar].textColors)
					E.DB.profile.Party[key].extraBars[bar].barColors = E.DeepCopy(C.Party[key].extraBars[bar].barColors)
					E.DB.profile.Party[key].extraBars[bar].bgColors = E.DeepCopy(C.Party[key].extraBars[bar].bgColors)
					E.DB.profile.Party[key].extraBars[bar].reverseFill = C.Party[key].extraBars[bar].reverseFill
					E.DB.profile.Party[key].extraBars[bar].useIconAlpha = C.Party[key].extraBars[bar].useIconAlpha
					E.DB.profile.Party[key].extraBars[bar].hideSpark = C.Party[key].extraBars[bar].hideSpark
					E.DB.profile.Party[key].extraBars[bar].hideBorder = C.Party[key].extraBars[bar].hideBorder
					E.DB.profile.Party[key].extraBars[bar].showInterruptedSpell = C.Party[key].extraBars[bar].showInterruptedSpell
					E.DB.profile.Party[key].extraBars[bar].showRaidTargetMark = C.Party[key].extraBars[bar].showRaidTargetMark
					E.DB.profile.Party[key].extraBars[bar].statusBarWidth = C.Party[key].extraBars[bar].statusBarWidth
					E.DB.profile.Party[key].extraBars[bar].textOfsX = C.Party[key].extraBars[bar].textOfsX
					E.DB.profile.Party[key].extraBars[bar].textOfsY = C.Party[key].extraBars[bar].textOfsY
					if E.db == E.DB.profile.Party[key] then
						P:Refresh()
					end
				end,
			},
		}
	},
}

for i = 1, 8 do
	local name = format(L["CD-Group %d"], i)
	local key = "group" .. i
	extraBarsInfo.groupColumns.args[key] = {
		name = name,
		desc = format("|cffff2020[%s]|r %s", L["Multiselect"], L["Select the spell types you want to display on this column."]),
		order = i,
		type = "multiselect",
		dialogControl = "Dropdown-OmniCD",
		values = E.L_PRIORITY,
	}
end

local extraBars = {
	name = L["Extra Bars"],
	type = "group",
	childGroups = "tab",
	order = 70,
	get = P.getExBar,
	set = P.setExBar,
	args = {
		interruptBar = {
			disabled = P.isExBarDisabled,
			name = L["Interrupt Bar"],
			order = 1,
			type = "group",
			args = extraBarsInfo
		},
		raidCDBar = {
			disabled = P.isExBarDisabled,
			name = L["Raid Bar"],
			order = 2,
			type = "group",
			args = extraBarsInfo
		},
	}
}

function P:AddExBarOption(key)
	self.options.args[key].args.extraBars = extraBars
end
