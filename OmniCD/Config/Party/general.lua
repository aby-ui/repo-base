local E, L, C = select(2, ...):unpack()

local P = E["Party"]

local general = {
	name = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t " .. GENERAL,
	order = 10,
	type = "group",
	get = function(info) return E.DB.profile.Party[info[2]].general[info[#info]] end,
	set = function(info, value)
		local key = info[2]
		E.DB.profile.Party[key].general[info[#info]] = value

		if E.db == E.DB.profile.Party[key] then
			P:Refresh(true)
		end
	end,
	args = {
		zoneSelected = {
			name = L["Copy Settings From:"],
			desc = L["Select the zone you want to copy settings from."],
			order = 1,
			type = "select",
			values = E.CFG_ZONE,
			set = function(info, value)
				E.DB.profile.Party[info[2]].general.zoneSelected = value
			end,
			disabledItem = function(info) return info[2] end,
		},
		copySelected = {
			disabled = function(info)
				local key = info[2]
				return not E.DB.profile.Party[key].general.zoneSelected or E.DB.profile.Party[key].general.zoneSelected == key
			end,
			name = L["Copy"],
			desc = L["Copy selected zone settings to the current zone"],
			order = 2,
			type = "execute",
			func = function(info)
				local key = info[2]
				local src = E.DB.profile.Party[key].general.zoneSelected
				if src then
					E.DB.profile.Party[key] = E.DeepCopy(E.DB.profile.Party[src])
					E.DB.profile.Party[key].general.zoneSelected = src
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
			func = function(info) P:ResetOptions(info[2]) P:Refresh(true) end,
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
			set = function(info, value) local key = info[2] E.DB.profile.Party[key].general.showAnchor = value P:ConfigBars(key, "showAnchor") end,
		},
		showPlayer = {
			name = L["Show Player"],
			desc = L["Show player's spell bar"],
			order = 11,
			type = "toggle",
		},






		showTooltip = {
			name = L["Show Tooltip"],
			desc = L["Show spell information when you mouseover an icon"] .. ". " .. L["Disable to make the icons click through"],
			order = 13,
			type = "toggle",
			get = P.getIcons,
			set = P.setIcons,
		},
		showRange = {
			name = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t " .. L["Show Range"],
			desc = format("%s\n\n|cffff2020%s\n\n%sVuhdo, HealBot, GW2_UI, AltzUI.|r",
				L["Fade out icons when the raid frame fades out for out of range units."],
				L["Addons with raid frame scaling will also cause the icons to scale."],
				L["Not Supported:"]),
			order = 14,
			type = "toggle",
		},
	}
}

function P:AddGeneralOption(key)
	self.options.args[key].args.general = general
end
