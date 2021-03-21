local E, L, C = select(2, ...):unpack()

local P = E["Party"]

local timer

local forceRefresh = function(info, value)
	P:Refresh(true)
	timer = nil
end

local function ConfigGroupSize(info, value)
	E.DB.profile.Party.visibility[info[#info]] = value
	if not timer then
		timer = E.TimerAfter(2, forceRefresh)
	end
end

local visibility = {
	name = L["Visibility"],
	order = 0,
	type = "group",
	get = function(info) return E.DB.profile.Party.visibility[info[#info]] end,
	set = function(info, value) E.DB.profile.Party.visibility[info[#info]] = value P:Refresh(true) end,
	args = {
		title = {
			name = L["Visibility"],
			order = 0,
			type = "description",
			fontSize = "large",
		},
		zone = {
			name = ZONE,
			order = 10,
			type = "multiselect",
			width = "full",
			values = E.L_ZONE,
			--descStyle = "inline",
			get = function(_, k) return E.DB.profile.Party.visibility[k] end,
			set = function(_, k, value)
				E.DB.profile.Party.visibility[k] = value
				if P.test and P.testZone == k then
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
					desc = L["Enable in automated instance groups"] .. " (" .. LOOKING_FOR_DUNGEON_PVEFRAME .. ", " .. SKIRMISH .. "...) ",
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
					--descStyle = "inline",
					set = ConfigGroupSize,
				},
			}
		},
	}
}

P.options.args["visibility"] = visibility
