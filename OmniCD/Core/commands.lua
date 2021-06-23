local E, L, C = select(2, ...):unpack()

local addOnCommands = {}

local spelltypeStr

E.SlashHandler = function(msg)
	local P = E["Party"]
	local command, value = msg:match("^(%S*)%s*(.-)$");

	if value then
		command = string.lower(command)
		value = string.lower(value)
	elseif command then
		command = string.lower(command)
	end

	if (command == "help" or command == "?") then
		E.Write("v" .. E.Version)
		E.Write(L["Usage:"])
		E.Write("/oc <command> or /omnicd <command>")
		E.Write(L["Commands:"])
		E.Write("test or t: " .. L["Toggle test frames for current zone."])
		E.Write("reload or rl: " ..  L["Reload addon."])
		E.Write("reset or rt: " .. L["Reset all cooldown timers."])
	elseif (command == "rl" or command == "reload") then
		E:Refresh(true)
	elseif (command == "rt" or command == "reset") then
		if (value == "") then
			P:ResetAllIcons()
			E.Write("Timers reset.")
		elseif (value == "db" or value == "database") then
			OmniCDDB = {} --E.DB:ResetDB("Default")
			C_UI.Reload()
		elseif (value == "pf" or value == "profile") then
			E.DB:ResetProfile()
			E.Write("Profile reset.")
			E.Libs.ACR:NotifyChange("OmniCD")
		elseif E.L_ZONE[value] then
			P:ResetOptions(value)
			E.Write(value, "-settings reset.")
			E.Libs.ACR:NotifyChange("OmniCD")
		else
			E.Write("Invalid <value>.", value)
		end
	elseif (command == "t" or command == "test") then
		if E.GetModuleEnabled("Party") then
			local key = not P.test and (P.zone or select(2, IsInInstance()))
			P:Test(key)
		else
			E.Write("Module not enabled!")
		end
	elseif (command == "m" or command =="manual") then
		local key = E.CFG_ZONE[value] and value or "arena"
		E.DB.profile.Party[key].position.detached = not E.DB.profile.Party[key].position.detached
		local state = E.DB.profile.Party[key].position.detached and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED
		E.Write(key, L["Manual Mode"], state)
		P:Refresh()
		E.Libs.ACR:NotifyChange("OmniCD")
	elseif (command == "devsync") then -- toggle sync for CDR by power spent only.
		E.DB.profile.Party.sync = not E.DB.profile.Party.sync
		local state = E.DB.profile.Party.sync and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED
		E.Write(L["Synchronize"], state)
		if E.Comms.enabled then
			E.Comms:RegisterEventUnitPower()
		end
		E.Libs.ACR:NotifyChange("OmniCD")
	elseif (command == "s" or command == "spell" or E.CFG_ZONE[command]) then
		local zone = E.CFG_ZONE[command] and command or "arena"
		value = value and string.lower(value)
		if value == "?" then
			if not spelltypeStr then
				for k in pairs(E.L_PRIORITY) do
					k = string.lower(k)
					if not spelltypeStr then
						spelltypeStr = k
					else
						spelltypeStr = strjoin(", ", spelltypeStr, k)
					end
				end
			end
			E.Write("/oc <zone> <spell type>")
			E.Write("Pepend 'r' to zone to set Raid CD")
			E.Write(L["Spell Types"] .. ": ", spelltypeStr)
			E.Write("Pepend \'-\' to remove spell type, e.g., /oc arena -cc")
			E.Write("Select all, Clear all, Reset to default: all, clear, default")

			return
		end

		if value == "clear" then
			wipe(E.DB.profile.Party[zone].spells)
			for i = 1, #E.spellDefaults do
				local id = E.spellDefaults[i]
				id = tostring(id)
				E.DB.profile.Party[zone].spells[id] = false
			end
		elseif value == "default" then
			P:ResetOptions(zone, "spells")
		else
			local removeType = gsub(value, "-", "")
			for _, v in pairs(E.spell_db) do
				for i = 1, #v do
					local spell = v[i]
					local spellID = spell.spellID
					local sid = tostring(spellID)
					local stype = string.lower(spell.type)
					if not spell.hide and (value == "all" or value == stype) then
						E.DB.profile.Party[zone].spells[sid] = true
					elseif removeType == stype then
						E.DB.profile.Party[zone].spells[sid] = false
					end
				end
			end
		end
		P:UpdateEnabledSpells()
		P:Refresh()
		E.Libs.ACR:NotifyChange("OmniCD")
	elseif (command == "r" or command == "raidcd" or E.CFG_ZONE[gsub(command, "^r", "")]) then
		local zone = gsub(command, "^r", "")
		zone = E.CFG_ZONE[zone] and zone or "arena"
		value = string.lower(value)
		if value == "clear" then
			wipe(E.DB.profile.Party[zone].raidCDS)
			for i = 1, #E.raidDefaults do
				local id = E.raidDefaults[i]
				id = tostring(id)
				E.DB.profile.Party[zone].raidCDS[id] = false
			end
		elseif value == "default" then
			P:ResetOptions(zone, "raidCDS")
		else
			local removeType = gsub(value, "-", "")
			for _, v in pairs(E.spell_db) do
				for i = 1, #v do
					local spell = v[i]
					local spellID = spell.spellID
					local sid = tostring(spellID)
					local stype = string.lower(spell.type)
					if not spell.hide and (value == "all" or value == stype) then
						E.DB.profile.Party[zone].raidCDS[sid] = true
					elseif removeType == stype then
						E.DB.profile.Party[zone].raidCDS[sid] = false
					end
				end
			end
		end
		P:UpdateEnabledSpells()
		P:Refresh()
		E.Libs.ACR:NotifyChange("OmniCD")
	elseif addOnCommands[command] then
		addOnCommands[command](value)
	else
		E.OpenOptionPanel()
	end
end

E.OpenOptionPanel = function()
	E.Libs.ACD:SetDefaultSize("OmniCD", 960, 650)
	E.Libs.ACD:Open("OmniCD")

	for modName in pairs(E.moduleOptions) do -- [47]*
		E.Libs.ACD:SelectGroup(E.AddOn, modName)
	end
	E.Libs.ACD:SelectGroup(E.AddOn, "")
end

SLASH_OmniCD1 = "/oc"
SLASH_OmniCD2 = "/omnicd"
SlashCmdList.OmniCD = E.SlashHandler

E["addOnCommands"] = addOnCommands
