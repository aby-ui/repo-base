local E, L = select(2, ...):unpack()
local P = E.Party

local L_POINTS = {
	["LEFT"] = L["LEFT"],
	["RIGHT"] = L["RIGHT"],
	["TOPLEFT"] = L["TOPLEFT"],
	["TOPRIGHT"] = L["TOPRIGHT"],
	["BOTTOMLEFT"] = L["BOTTOMLEFT"],
	["BOTTOMRIGHT"] = L["BOTTOMRIGHT"],
}

local isPreset = function(info)
	local key = info[2]
	return E.profile.Party[key].position.preset ~= "manual"
end

local isMultiline = function(info)
	local layout = E.profile.Party[ info[2] ].position.layout
	return layout ~= "vertical" and layout ~= "horizontal", layout == "tripleRow" or layout == "tripleColumn"
end

local disabledItems = {}

local function GetDisabledItems(info)
	wipe(disabledItems)
	local db = E.profile.Party[ info[2] ]
	local bp = db.priority[db.position.breakPoint]
	for k in pairs(E.L_PRIORITY) do
		local prio = db.priority[k]
		if prio >= bp then
			disabledItems[k] = true
		end
	end
	return disabledItems
end

local position = {
	name = L["Position"],
	type = "group",
	order = 20,
	get = function(info) return E.profile.Party[ info[2] ].position[ info[#info] ] end,
	set = function(info, value)
		local key = info[2]
		local option = info[#info]
		local db = E.profile.Party[key].position
		db[option] = value

		if option == "preset" then
			if value == "TOPLEFT" then
				db.anchor = "TOPRIGHT"
				db.attach = value
			elseif value == "TOPRIGHT" then
				db.anchor = "TOPLEFT"
				db.attach = value
			else
				db.anchor = db.anchorMore or "LEFT"
				db.attach = db.attachMore or "LEFT"
			end
		elseif option == "anchor" or option == "attach" then
			if db.preset == "manual" then
				db[option .. "More"] = value
			end
		end

		P:ConfigBars(key, option)
	end,
	args = {
		uf = {
			name = ADDONS,
			desc = L["Select addon to override auto anchoring"],
			order = 1,
			type = "select",
			values = function() return E.customUF.optionTable end,
			set = function(info, value)
				local key = info[2]
				local db = E.profile.Party[key].position
				if P:IsCurrentZone(key) then
					if value == "blizz" and not db.detached
						and not ( IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") ) then
						E.StaticPopup_Show("OMNICD_RELOADUI", E.STR.ENABLE_BLIZZARD_CRF)
					else
						if P.isInTestMode then
							P:Test()
							db.uf = value
							P:Test(key)
						else
							db.uf = value
							P:Refresh(true)
						end
					end
				else
					db.uf = value
				end
			end,
		},
		preset = {
			name = L["Position"],
			desc = L["Set the spell bar position"],
			order = 2,
			type = "select",
			values = {
				["TOPLEFT"] = L["LEFT"],
				["TOPRIGHT"] = L["RIGHT"],
				["manual"] = L["More..."],
			},
		},
		anchor = {
			disabled = isPreset,
			name = L["Anchor Point"],
			desc = format("%s\n\n%s", L["Set the anchor point on the spell bar"],
			L["Having \"RIGHT\" in the anchor point, icons grow left, otherwise right"]),
			order = 3,
			type = "select",
			values = L_POINTS,
		},
		attach = {
			disabled = isPreset,
			name = L["Attachment Point"],
			desc = L["Set the anchor attachment point on the party/raid frame"],
			order = 4,
			type = "select",
			values = L_POINTS,
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
			values = {
				["horizontal"] = L["Horizontal"],
				["vertical"] = L["Vertical"],
				["doubleRow"] = L["Use Double Row"],
				["doubleColumn"] = L["Use Double Column"],
				["tripleRow"] = L["Use Triple Row"],
				["tripleColumn"] = L["Use Triple Column"],
			},
			sorting = {"horizontal", "doubleRow", "tripleRow", "vertical", "doubleColumn", "tripleColumn"},
		},
		columns = {
			disabled = isMultiline,
			name = function(info)
				return E.profile.Party[ info[2] ].position.layout == "vertical" and L["Row"] or L["Column"]
			end,
			desc = function(info)
				return E.profile.Party[ info[2] ].position.layout == "vertical" and L["Set the number of icons per column"]
				or L["Set the number of icons per row"]
			end,
			order = 11,
			type = "range",
			min = 1, max = 100, softMax = 20, step = 1,
		},
		breakPoint = {
			disabled = function(info)
				return not isMultiline(info)
			end,
			name = L["Breakpoint"],
			desc = L["Select the highest priority spell type to use as the start of the 2nd row"],
			order = 12,
			type = "select",
			values = E.L_PRIORITY,
			sorting = function(info)
				return E.SortHashToArray(E.L_PRIORITY, E.profile.Party[ info[2] ].priority)
			end,
		},
		breakPoint2 = {
			disabled = function(info)
				local multiline, tripleline = isMultiline(info)
				return not multiline or not tripleline
			end,
			name = L["Breakpoint"] .. " 2",
			desc = L["Select the highest priority spell type to use as the start of the 3rd row"],
			order = 13,
			type = "select",
			values = E.L_PRIORITY,
			sorting = function(info)
				return E.SortHashToArray(E.L_PRIORITY, E.profile.Party[ info[2] ].priority)
			end,
			disabledItem = function(info)
				return GetDisabledItems(info)
			end,
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
			disabled = function(info)
				return info[5] and not E.profile.Party[ info[2] ].position.detached
			end,
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
						E.profile.Party[key].position.detached = state

						if P:IsCurrentZone(key) then
							if not state and not E.customUF.active
								and not ( IsAddOnLoaded("Blizzard_CompactRaidFrames") and IsAddOnLoaded("Blizzard_CUFProfiles") ) then
								E.StaticPopup_Show("OMNICD_RELOADUI", E.STR.ENABLE_BLIZZARD_CRF)
							end
							P:ConfigBars(key, "detached")
							P:UpdatePosition()
						end

						if E.isDF and P.isInTestMode then
							local testZone = P.testZone
							P:Test()
							P:Test(testZone)
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
						for k in pairs(E.profile.Party[key].manualPos) do
							if type(k) == "number" then
								E.profile.Party[key].manualPos[k] = nil
							end
						end

						P:ConfigBars(key, "reset")
					end,
					confirm = E.ConfirmAction,
				},
			}
		},
	}
}

P:RegisterSubcategory("position", position)
