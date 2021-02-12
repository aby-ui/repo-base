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

		if db.layout == "vertical" and db.progressBar or E.db.icons.displayBorder then
			if slider then
				if not timers[key] then
					timers[key] = E.TimerAfter(0.5, updatePixelObj, key)
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
			if db.layout == "vertical" and db.progressBar then
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
		elseif arg == "barColors" or arg == "bgColors" or arg == "textColors" or arg == "reverseFill" then
			local CastingBar = icon.statusBar.CastingBar
			P.CastingBarFrame_OnLoad(CastingBar, key, icon)
			P:SetExStatusBarColor(icon, key)
		elseif arg == "statusBarWidth" then
			local statusBar = icon.statusBar
			P:SetExStatusBarWidth(statusBar, key)
		end
	end

	local sortOrder = arg == "sortBy" or arg == "growUpward" or arg == "sortDirection"
	local noDelay = arg == "layout" or sortOrder
	if noDelay or arg == "progressBar" or arg == "columns" or arg == "paddingX" or arg == "paddingY" or arg == "statusBarWidth" then
		P:UpdateExPositionValues()
		P:SetExIconLayout(key, noDelay, sortOrder, true)
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
		[1] = L["Cooldown"] ..  " > " .. CLASS .. " > " .. NAME,
		[2] = L["Cooldown Remaining"] .. " > " ..  L["Cooldown"] ..  " > " .. CLASS .. " > " .. NAME,
	},
	raidCDBar = {
		[3] = L["Priority"] .. " > " .. CLASS .. " > " .. L["Spell ID"],
		[4] = CLASS .. " > " .. L["Priority"] .. " > " .. L["Spell ID"],
	}
}
local interruptBarDesc = sortByValues.interruptBar[1] .. ".\n" .. sortByValues.interruptBar[2] .. "."
local raidCDBarDesc = sortByValues.raidCDBar[3] .. ".\n" .. sortByValues.raidCDBar[4] .. "."

local progressBarColorInfo = {
	lb1 = {
		name = function(info) return temp[info[#info-1]] end,
		order = 0,
		type = "description",
		width = 0.4
	},
	activeColor = {
		name = "",
		order = 1,
		type = "color",
		hasAlpha = function(info) return info[#info-1] == "bgColors" end,
		width = 0.35,

	},
	rechargeColor = {
		name = "",
		order = 2,
		type = "color",
		hasAlpha = function(info) return info[#info-1] == "bgColors" end,
		width = 0.35,
	},
	inactiveColor = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or not db.progressBar or db.layout == "horizontal" or info[#info-1] == "bgColors"
		end,
		name = "",
		order = 3,
		type = "color",
		hasAlpha = function(info) return info[#info-1] == "barColors" end,
		width = 0.35,
	},
	classColor = {
		name = "",
		order = 4,
		type = "toggle",
		width = 0.4,
		get = function(info) return E.DB.profile.Party[info[2]].extraBars[info[4]][info[#info-1]].classColor end,
		set = function(info, state)
			local key, bar = info[2], info[4]
			E.DB.profile.Party[key].extraBars[bar][info[#info-1]].classColor = state

			if E.db == E.DB.profile.Party[key] then
				ConfigExBar(bar, "barColors")
			end
		end,
	},
}

P.extraBarDesc = function(info)
	if info[#info-1] == "interruptBar" then
		return L["Move your group's Interrupt spells to the Interrupt Bar."]
	else
		return L["Move your group's Raid Cooldowns to the Raid Bar."]
	end
end

local isRaidCDBar = function(info) return info[#info-1] ~= "interruptBar" end

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
		name = L["Layout"],
		desc = L["Select the icon layout"],
		order = 10,
		type = "select",
		values = {
			horizontal = L["Horizontal"],
			vertical = L["Vertical"],
		},
	},
	sortBy = {
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
		name = function(info) return E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout == "vertical" and L["Rows"] or L["Columns"] end,
		desc = function(info) return E.DB.profile.Party[info[2]].extraBars[info[#info-1]].layout == "vertical" and L["Set the number of icons per column"] or L["Set the number of icons per row"] end,
		order = 13,
		type = "range",
		min = 1, max = 100, softMax = 20, step = 1,
	},
	paddingX = {
		name = L["Padding X"],
		desc = L["Set the padding space between icon columns"],
		order = 14,
		type = "range",
		min = -5, max = 100, softMax = 10, step = 1,
	},
	paddingY = {
		name = L["Padding Y"],
		desc = L["Set the padding space between icon rows"],
		order = 15,
		type = "range",
		min = -5, max = 100, softMax = 10, step = 1,
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
			return not db.enabled or (db.layout == "vertical" and db.progressBar)
		end,
		name = NAME,
		desc = L["Show name on icons"],
		order = 17,
		type = "toggle",
	},
	growUpward = {
		hidden = isRaidCDBar,
		name = L["Grow Rows Upward"],
		desc = L["Toggle the grow direction of icon rows"],
		order = 18,
		type = "toggle",
	},
	lb2 = {
		name = "\n", order = 19, type = "description"
	},
	progressBar = {
		disabled = function(info)
			local db = E.DB.profile.Party[info[2]].extraBars[info[4]]
			return not db.enabled or not db.progressBar or db.layout == "horizontal"
		end,
		name = L["Status Bar Timer"],
		order = 20,
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
					lb0 = { name = "", order = 0, type = "description", width = 0.4},
					lb1 = { name = L["Active"], order = 1, type = "description", width = 0.35},
					lb2 = { name = L["Recharge"], order = 2, type = "description", width = 0.35},
					lb3 = { name = L["Inactive"], order = 3, type = "description", width = 0.35},
					lb4 = { name = CLASS_COLORS, order = 4, type = "description", width = 0.4},
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
			lb2 = {
				name = "\n\n", order = 53, type = "description"
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
