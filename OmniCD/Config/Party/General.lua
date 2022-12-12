local E, L = select(2, ...):unpack()
local P = E.Party

local general = {
	name = GENERAL,
	order = 10,
	type = "group",
	get = function(info) return E.profile.Party[ info[2] ].general[ info[#info] ] end,
	set = function(info, value)
		local key = info[2]
		E.profile.Party[key].general[ info[#info] ] = value
		if P:IsCurrentZone(key) then
			P:Refresh(true)
		end
	end,
	args = {
		zoneSelected = {
			name = L["Copy Settings From:"],
			desc = L["Select the zone you want to copy settings from."],
			order = 1,
			type = "select",
			values = E.L_CFG_ZONE,
			set = function(info, value)
				E.profile.Party[ info[2] ].general.zoneSelected = value
			end,
			disabledItem = function(info) return info[2] end,
		},
		copySelected = {
			disabled = function(info)
				local key = info[2]
				local zoneSelected = E.profile.Party[key].general.zoneSelected
				return not zoneSelected or zoneSelected == key
			end,
			name = L["Copy"],
			desc = L["Copy selected zone settings to the current zone"],
			order = 2,
			type = "execute",
			func = function(info)
				local key = info[2]
				local src = E.profile.Party[key].general.zoneSelected
				if src then
					E.profile.Party[key] = E:DeepCopy(E.profile.Party[src])
					E.profile.Party[key].general.zoneSelected = src
				end
				P:Refresh(true)
			end,
			confirm = E.ConfirmAction,
		},
		resetModule = {
			name = RESET_TO_DEFAULT,
			desc = L["Reset current zone settings to default"],
			order = 3,
			type = "execute",
			func = function(info)
				P:ResetOption(info[2])
				E:RefreshProfile()
			end,
			confirm = E.ConfirmAction,
		},
		lb1 = {
			name = "\n\n", order = 4, type = "description",
		},
		showAnchor = {
			name = L["Show Anchor"],
			desc = L["Show anchor with party/raid numbers"],
			order = 10,
			type = "toggle",
			set = function(info, value)
				local key = info[2]
				E.profile.Party[key].general.showAnchor = value
				P:ConfigBars(key, "showAnchor")
			end,
		},
		showPlayer = {
			name = L["Show Player"],
			desc = L["Show player's spell bar"],
			order = 11,
			type = "toggle",
		},
		showTooltip = {
			name = L["Show Tooltip"],
			desc = format("%s. %s", L["Show spell information when you mouseover an icon"],
			L["Disable to make the icons click through"]),
			order = 13,
			type = "toggle",
			get = P.getIcons,
			set = P.setIcons,
		},
		showRange = {
			name = L["Show Range"],
			desc = format("%s\n\n|cffff2020%s\n\n%sVuhdo, HealBot, GW2_UI, AltzUI.|r",
			L["Fade out icons when the raid frame fades out for out of range units."],
			L["Addons with raid frame scaling will also cause the icons to scale."],
			L["Not Supported:"]),
			order = 14,
			type = "toggle",
		},
	}
}

P:RegisterSubcategory("general", general)
