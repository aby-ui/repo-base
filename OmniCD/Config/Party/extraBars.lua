local E, L, C = select(2, ...):unpack()

local P = E["Party"]

do
	local timers = {}

	local updatePixelObj = function(key, noDelay)
		local f = P.extraBars[key]
		P:UpdateExBarBackdrop(f, key)
		P:UpdateExPositionValues()
		P:SetExIconLayout(key, true)

		if not noDelay then
			timers[key] = nil
		end
	end

	function P:ConfigExSize(key, slider)
		local db = E.db.extraBars[key]
		local f = self.extraBars[key]
		f.container:SetScale(db.scale)

		if db.layout ~= "horizontal" and db.progressBar or E.db.icons.displayBorder then
			if slider then
				if not timers[key] then
					timers[key] = E.TimerAfter(0.5, updatePixelObj, key) -- this feels fine, as it's just the border and padding
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
		if arg == "layout" or arg == "progressBar" then
			local statusBar = icon.statusBar
			if db.layout ~= "horizontal" and db.progressBar then
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
			P:SetExStatusBarColor(icon, key) -- [79]
			P:SetAlpha(icon)
		elseif arg == "barColors" or arg == "bgColors" or arg == "textColors" or arg == "reverseFill" or arg == "hideSpark" then
			local CastingBar = icon.statusBar.CastingBar
			P.CastingBarFrame_OnLoad(CastingBar, key, icon)
			P:SetExStatusBarColor(icon, key)
		elseif arg == "statusBarWidth" then
			local statusBar = icon.statusBar
			P:SetExStatusBarWidth(statusBar, key)
		end
	end

	local sortOrder = arg == "sortBy" or arg == "growUpward" or arg == "sortDirection" or arg == "layout" -- added layout for multicolumn
	local noDelay = arg == "layout" or sortOrder
	if noDelay or arg == "progressBar" or arg == "columns" or arg == "paddingX" or arg == "paddingY" or arg == "statusBarWidth" or "groupPadding" then
		P:UpdateExPositionValues()
		--P:SetExIconLayout(key, noDelay, sortOrder, true)
		P:SetExIconLayout(key, true, sortOrder, true)  -- changed to nodelay. we don't want a slouchy response
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
			P:Refresh(true) -- [82]
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
			return not db.enabled or not db.progressBar or db.layout == "horizontal" or info[#info-1] == "bgColors"
		end,
		name = "",
		order = 3,
		type = "color",
		dialogControl = "ColorPicker-OmniCD",
		hasAlpha = function(info) return info[#info-1] == "barColors" end, -- bgColors is disabled
		width = 0.5,
	},
	useClassColor = { -- reminent db 'classColor'
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
local isRaidMultline = function(info) local bar = info[4] return bar == "raidCDBar" and E.DB.profile.Party[info[2]].extraBars[bar].layout == "multicolumn" end

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
			if f then
				if E.DB.profile.Party[key].manualPos[bar] then
					table.wipe(E.DB.profile.Party[key].manualPos[bar])
				end

				if E.db == E.DB.profile.Party[key] then
					E.LoadPosition(f)
				end
			end
		end,
		confirm = E.ConfirmAction,
	},
	lb1 = {
		name = "\n", order = 4, type = "description"
	},
	layout = {
		name = function(info) return info[4] == "raidCDBar" and L["Layout"] or L["Layout"] end,
		desc = L["Select the icon layout"],
		order = 10,
		type = "select",
		values = {
			horizontal = L["Horizontal"],
			vertical = L["Vertical"],
			multicolumn = L["New Column per Group"],
		},
		disabledItem = function(info) return not isRaidCDBar(info) and "multicolumn" end,
	},
	sortBy = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or (info[4] == "raidCDBar" and db.layout == "multicolumn")
		end,
		name = COMPACT_UNIT_FRAME_PROFILE_SORTBY,
		desc = function(info) return info[#info-1] == "interruptBar" and interruptBarDesc or raidCDBarDesc end,
		order = 11,
		type = "select",
		values = function(info) return sortByValues[info[#info-1]] end,
	},
	sortDirection = {
		hidden = isRaidCDBar,
		name = L["Sort Direction"],
		order = 12,
		type = "select",
		values = {
			asc = L["Ascending"],
			dsc = L["Descending"],
		}
	},
	columns = {
		--[=[ use in combination
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or (info[4] == "raidCDBar" and db.layout == "multicolumn")
		end,
		--]=]
		name = function(info) return E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout == "horizontal" and L["Column"] or L["Row"] end,
		desc = function(info) return E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout == "horizontal" and L["Set the number of icons per row"] or L["Set the number of icons per column"] end,
		order = 13,
		type = "range",
		min = 1, max = 100, softMax = 30, step = 1,
	},
	groupColumns = {
		hidden = isInterruptBar,
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or (info[4] == "raidCDBar" and db.layout ~= "multicolumn")
		end,
		name = "",
		order = 20,
		type ="group",
		inline = true,
		get = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info]][k] end,
		set = function(info, k, value)
			local key, bar, opt = info[2], info[4], info[#info]
			-- don't disableItem, instead overwrite selection on other groups
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
			-- TODO: scrap this and add option to create additional raidbars next major update
			--[==[
			groupDetached = {
				hidden = isInterruptBar,
				name = "Detach Group(s)" .. "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t",
				desc = format("|cffff2020[%s]|r %s", L["Multiselect"], "Select the group(s) you want to detach."),
				order = 11,
				type = "multiselect",
				dialogControl = "Dropdown-OmniCD",
				values = {[0] = ALL, 1, 2, 3, 4, 5, 6, 7, 8},
				get = function(info, k) return E.DB.profile.Party[info[2]].extraBars[info[4]].groupDetached[k] end,
				set = function(info, k, value)
					local key, bar = info[2], info[4]
					E.DB.profile.Party[key].extraBars[bar].groupDetached[k] = value

					if E.db == E.DB.profile.Party[key] then
						ConfigExBar(bar, "layout")
					end
				end,
			},
			--]==]
			groupPadding = {
				hidden = isInterruptBar,
				disabled = function(info) return E.DB.profile.Party[info[2]].extraBars.raidCDBar.layout ~= "multicolumn" end,
				name = L["Group Padding"],
				desc = L["Set the padding space between group columns"],
				order = 12,
				type = "range",
				min = 0, max = 100, step = 1,
				get = P.getExBar,
				set = P.setExBar,
			},
		},
	},
	paddingX = {
		name = L["Padding X"],
		desc = L["Set the padding space between icon columns"],
		order = 31,
		type = "range",
		min = -5, max = 100, softMin = -1, softMax = 10, step = 1,
	},
	paddingY = {
		name = L["Padding Y"],
		desc = L["Set the padding space between icon rows"],
		order = 32,
		type = "range",
		min = -5, max = 100, softMin = -1, softMax = 10, step = 1,
	},
	scale = {
		name = L["Icon Size"],
		desc = L["Set the size of icons"],
		order = 33,
		type = "range",
		min = 0.2, max = 2.0, step = 0.01, isPercent = true,
	},
	showName = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or (db.layout ~= "horizontal" and db.progressBar)
		end,
		name = NAME,
		desc = L["Show name on icons"],
		order = 34,
		type = "toggle",
	},
	growUpward = {
		name = L["Grow Rows Upward"],
		desc = L["Toggle the grow direction of icon rows"],
		order = 35,
		type = "toggle",
	},
	lb2 = {
		name = "\n", order = 39, type = "description"
	},
	progressBar = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or not db.progressBar or db.layout == "horizontal"
		end,
		name = L["Status Bar Timer"],
		order = 40,
		type = "group",
		inline = true,
		args = {
			progressBar = {
				disabled = function(info)
					local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
					return not db.enabled or db.layout == "horizontal"
				end,
				name = ENABLE,
				desc = L["Replace default timers with a status bar timer."],
				order = 1,
				type = "toggle",
			},
			lb1 = {
				name = "", order = 2, type = "description"
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
				name = "",
				order = 30,
				type = "group",
				inline = true,
				get = getColor,
				set = setColor,
				args = progressBarColorInfo,
			},
			bgColors = {
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
			statusBarWidth = {
				name = L["Bar width"],
				desc = L["Set the status bar width. Adjust height with \'Icon Size\'."] .. "\n\n" .. E.STR.MAX_RANGE,
				order = 50,
				type = "range",
				min = 100, max = 999, softMax = 300, step = 1,
			},
			reverseFill = {
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
				name = L["Hide Spark"],
				desc = L["Hide the leading spark texture."],
				order = 53,
				type = "toggle",
				width = 0.8, -- cram this in
			},
			lb3 = {
				name = "\n\n", order = 59, type = "description"
			},
			resetBar = {
				name = RESET_TO_DEFAULT,
				desc = L["Reset Status Bar Timer settings to default"],
				order = 60,
				type = "execute",
				func = function(info)
					local key, bar = info[2], info[4]
					E.DB.profile.Party[key].extraBars[bar].progressBar = C.Party[key].extraBars[bar].progressBar
					E.DB.profile.Party[key].extraBars[bar].textColors = E.DeepCopy(C.Party[key].extraBars[bar].textColors)
					E.DB.profile.Party[key].extraBars[bar].barColors = E.DeepCopy(C.Party[key].extraBars[bar].barColors)
					E.DB.profile.Party[key].extraBars[bar].bgColors = E.DeepCopy(C.Party[key].extraBars[bar].bgColors)
					E.DB.profile.Party[key].extraBars[bar].statusBarWidth = C.Party[key].extraBars[bar].statusBarWidth
					E.DB.profile.Party[key].extraBars[bar].reverseFill = C.Party[key].extraBars[bar].reverseFill
					E.DB.profile.Party[key].extraBars[bar].useIconAlpha = C.Party[key].extraBars[bar].useIconAlpha
					if E.db == E.DB.profile.Party[key] then
						P:Refresh()
					end
				end,
			},
		}
	}
}

for i = 1, 8 do
	local name = format("%s %s", i, L["Column"])
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
			order = 10,
			type = "group",
			args = extraBarsInfo
		},
		raidCDBar = {
			disabled = P.isExBarDisabled,
			name = L["Raid Bar"],
			order = 20,
			type = "group",
			args = extraBarsInfo
		},
	}
}

function P:AddExBarOption(key)
	self.options.args[key].args.extraBars = extraBars
end
