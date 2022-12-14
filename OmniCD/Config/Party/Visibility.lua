local E, L = select(2, ...):unpack()
local P = E.Party

local sliderTimer

local visibility = {
	name = L["Visibility"],
	order = 0,
	type = "group",
	get = function(info) return E.profile.Party.visibility[ info[#info] ] end,
	set = function(info, value) E.profile.Party.visibility[ info[#info] ] = value P:Refresh(true) end,
	args = {
		zone = {
			name = ZONE,
			order = 10,
			type = "multiselect",
			width = "full",
			values = E.L_ALL_ZONE,
			get = function(_, k) return E.profile.Party.visibility[k] end,
			set = function(_, k, value)
				E.profile.Party.visibility[k] = value
				if P.isInTestMode and P.testZone == k then
					P:Test()
				end
				P:Refresh(true)
			end,
		},
		groupType = {
			name = DUNGEONS_BUTTON,
			order = 20,
			type = "group",
			inline = true,
			args = {
				finder = {
					name = ENABLE,
					desc = format("%s (%s, %s, ...)", L["Enable in automated instance groups"] ,LOOKING_FOR_DUNGEON_PVEFRAME, SKIRMISH),
					type = "toggle",
				},
			}
		},
		groupSize = {
			name = L["Group Size"],
			order = 30,
			type = "group",
			inline = true,
			args = {
				size = {
					name = L["Max number of group members"],
					width = "double",
					type = "range",
					min = 2, max = 40, step = 1,
					set = function(info, value)
						E.profile.Party.visibility[ info[#info] ] = value
						if not sliderTimer then
							local func = function()
								P:Refresh(true)
								sliderTimer = nil
							end
							sliderTimer = C_Timer.NewTimer(2, func)
						end
					end,
				},
			}
		},
	}
}

P.options.args["visibility"] = visibility
