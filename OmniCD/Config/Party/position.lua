local E, L, C = select(2, ...):unpack()

local P = E["Party"]

local isPreset = function(info) local key = info[2] return E.DB.profile.Party[key].position.preset ~= "manual" end
local isMultiline = function(info)
	local layout = E.DB.profile.Party[info[2]].position.layout
	return layout ~= "vertical" and layout ~= "horizontal", layout == "tripleRow" or layout == "tripleColumn"
end

local extraBarInfo = {
	enabled = {
		disabled = false,
		name = ENABLE,
		desc = P.extraBarDesc,
		order = 1,
		type = "toggle",
		set = P.setExBar,
	},
	locked = {
		name = LOCK_FRAME,
		desc = L["Lock frame position"],
		order = 2,
		type = "toggle",
		set = P.setExBar,
	},
	settings = {
		name = SETTINGS,
		desc = L["Jump to Extra Bars settings"],
		order = 3,
		type = "execute",
		func = function(info) E.Libs.ACD:SelectGroup("OmniCD", "Party", info[2], "extraBars", info[#info-1]) end,
	},
}

local position = {
	name = L["Position"],
	type = "group",
	order = 20,
	get = function(info) return E.DB.profile.Party[info[2]].position[info[#info]] end,
	set = function(info, value)
		local key = info[2]
		local option = info[#info]

		E.DB.profile.Party[key].position[option] = value

		if option == "preset" then
			if value == "TOPLEFT" then
				E.DB.profile.Party[key].position.anchor = "TOPRIGHT"
				E.DB.profile.Party[key].position.attach = value
			elseif value == "TOPRIGHT" then
				E.DB.profile.Party[key].position.anchor = "TOPLEFT"
				E.DB.profile.Party[key].position.attach = value
			else
				E.DB.profile.Party[key].position.anchor = E.DB.profile.Party[key].position.anchorMore or "LEFT"
				E.DB.profile.Party[key].position.attach = E.DB.profile.Party[key].position.attachMore or "LEFT"
			end
		elseif option == "anchor" or option == "attach" then
			if E.DB.profile.Party[key].position.preset == "manual" then
				E.DB.profile.Party[key].position[option .. "More"] = value
			end
		end

		P:ConfigBars(key, option)
	end,
	args = {
		uf = {
			--disabled = function(info) local key = info[2] return E.DB.profile.Party[key].position.detached or not E.customUF.enabled end,
			name = ADDONS,
			desc = L["Select addon to override auto anchoring"],
			order = 1,
			type = "select",
			values = function() return E.customUF.optionTable end,
			set = function(info, value) -- TODO: ?
				local key = info[2]
				if E.db == E.DB.profile.Party[key] then
					if value == "blizz" and not E.DB.profile.Party[key].position.detached and not ( IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") ) then
						E.StaticPopup_Show("OMNICD_RELOADUI", E.STR.ENABLE_BLIZZARD_CRF)
					else
						if P.test then
							P:Test()
							E.DB.profile.Party[key].position.uf = value
							P:Test(key)
						else
							E.DB.profile.Party[key].position.uf = value
							P:Refresh(true) -- [82]
						end
					end
				else
					E.DB.profile.Party[key].position.uf = value
				end
			end,
		},
		preset = {
			name = L["Position"],
			desc = L["Set the spell bar position"],
			order = 2,
			type = "select",
			values = E.L_PRESETS,
		},
		anchor = {
			disabled = isPreset,
			name = L["Anchor Point"],
			desc = L["Set the anchor point on the spell bar"] .. "\n\n" .. L["Having \"RIGHT\" in the anchor point, icons grow left, otherwise right"],
			order = 3,
			type = "select",
			values = E.L_POINTS,
		},
		attach = {
			disabled = isPreset,
			name = L["Attachment Point"],
			desc = L["Set the anchor attachment point on the party/raid frame"],
			order = 4,
			type = "select",
			values = E.L_POINTS,
		},
		offsetX = {
			name = L["Offset X"],
			desc = E.STR.MAX_RANGE,
			order = 5,
			type = "range",
			min = -999, max = 999, softMin = -100, softMax = 100, step = 1,
		},
		offsetY = {
			name = L["Offset Y"],
			desc = E.STR.MAX_RANGE,
			order = 6,
			type = "range",
			min = -999, max = 999, softMin = -100, softMax = 100, step = 1,
		},
		lb1 = {
			name = "\n", order = 7, type = "description",
		},
		layout = {
			name = L["Layout"],
			desc = L["Select the icon layout"],
			order = 10,
			type = "select",
			values = E.L_LAYOUT,
		},
		columns = {
			disabled = isMultiline,
			name = function(info) return E.DB.profile.Party[info[2]].position.layout == "vertical" and L["Row"] or L["Column"] end,
			desc = function(info) return E.DB.profile.Party[info[2]].position.layout == "vertical" and L["Set the number of icons per column"] or L["Set the number of icons per row"] end,
			order = 11,
			type = "range",
			min = 1, max = 100, softMax = 20, step = 1,
		},
		breakPoint = {
			disabled = function(info) return not isMultiline(info) end,
			name = L["Breakpoint"],
			desc = L["Select the highest priority spell type to use as the start of the 2nd row"],
			order = 12,
			type = "select",
			values = E.L_PRIORITY,
			sorting = function(info) return E.SortHashToArray(E.L_PRIORITY, E.DB.profile.Party[info[2]].priority) end,
		},
		breakPoint2 = {
			disabled = function(info) local multiline, tripleline = isMultiline(info) return not multiline or not tripleline end,
			name = L["Breakpoint"] .. " 2",
			desc = L["Select the highest priority spell type to use as the start of the 3rd row"],
			order = 13,
			type = "select",
			values = E.L_PRIORITY,
			sorting = function(info) return E.SortHashToArray(E.L_PRIORITY, E.DB.profile.Party[info[2]].priority) end,
			disabledItem = function(info) return E.DB.profile.Party[info[2]].position.breakPoint end, -- this must be a function
		},
		paddingX = {
			name = L["Padding X"],
			desc = L["Set the padding space between icon columns"],
			order = 14,
			type = "range",
			min = -5, max = 100, softMin = 0, softMax = 10, step = 1,
		},
		paddingY = {
			name = L["Padding Y"],
			desc = L["Set the padding space between icon rows"],
			order = 15,
			type = "range",
			min = -5, max = 100, softMin = 0, softMax = 10, step = 1,
		},
		displayInactive = {
			name = L["Display Inactive Icons"],
			desc = L["Display icons not on cooldown"],
			order = 16,
			type = "toggle",
		},
		growUpward = {
			name = L["Grow Rows Upward"],
			desc = L["Toggle the grow direction of icon rows"],
			order = 17,
			type = "toggle",
		},
		lb2 = {
			name = "\n\n", order = 19, type = "description"
		},
		manualMode = {
			disabled = function(info) return info[5] and not E.DB.profile.Party[info[2]].position.detached end,
			name = L["Manual Mode"],
			order = 20,
			type = "group",
			args = {
				detached = {
					disabled = false,
					name = ENABLE,
					desc = L["Detach from raid frames and set position manually"],
					order = 1,
					type = "toggle",
					set = function(info, state)
						local key = info[2]
						E.DB.profile.Party[key].position.detached = state

						if E.db == E.DB.profile.Party[key] then
							if not state and E.customUF.active == "blizz" and not ( IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") ) then
								E.StaticPopup_Show("OMNICD_RELOADUI", E.STR.ENABLE_BLIZZARD_CRF)
							end
							P:ConfigBars(key, "detached") -- [48]
							P:UpdatePosition()
						end
					end,
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
						local key = info[2]
						for k, v in pairs(E.DB.profile.Party[key].manualPos) do
							if type(k) == "number" then
								E.DB.profile.Party[key].manualPos[k] = nil
							end
						end

						P:ConfigBars(key, "reset")
					end,
					confirm = E.ConfirmAction,
				},
			}
		},
		interruptBar = {
			disabled = P.isExBarDisabled,
			name = L["Interrupt Bar"],
			order = 30,
			type = "group",
			get = P.getExBar,
			args = extraBarInfo
		},
		raidCDBar = {
			disabled = P.isExBarDisabled,
			name = L["Raid Bar"],
			order = 40,
			type = "group",
			get = P.getExBar,
			args = extraBarInfo
		},
	}
}

function P:AddPositionOption(key)
	self.options.args[key].args.position = position
end
