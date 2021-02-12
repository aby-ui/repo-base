local E, L, C = select(2, ...):unpack()

local addOnCommands = {}

local spelltypeStr

E.SlashHandler = function(msg)
	local AceRegistry = LibStub("AceConfigRegistry-3.0")
	local command, value = msg:match("^(%S*)%s*(.-)$");
	local P = E["Party"]

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
			ReloadUI()
		elseif (value == "pf" or value == "profile") then
			E.DB:ResetProfile()
			E.Write("Profile reset.")
			AceRegistry:NotifyChange("OmniCD")
		elseif E.L_ZONE[value] then
			P:ResetOptions(value)
			E.Write(value, "-settings reset.")
			AceRegistry:NotifyChange("OmniCD")
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
		AceRegistry:NotifyChange("OmniCD")
	elseif (command == "sync") then
		-- Toggles sync for cooldown reduction by spending resources only. Talent changes etc are unaffected.
		E.DB.profile.Party.sync = not E.DB.profile.Party.sync
		local state = E.DB.profile.Party.sync and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED
		E.Write(L["Synchronize"], state)
		if E.Comms.enabled then
			E.Comms:RegisterEventUnitPower()
		end
		AceRegistry:NotifyChange("OmniCD")
	elseif (command == "s" or command == "spell" or E.CFG_ZONE[command]) then
		local zone = E.CFG_ZONE[command] and command or "arena"
		if value == "?" then
			if not spelltypeStr then
				for k in pairs(E.L_PRIORITY) do
					if not spelltypeStr then
						spelltypeStr = k
					else
						spelltypeStr = strjoin(", ", spelltypeStr, k)
					end
				end
			end
			E.Write(L["Spell Types"] .. ": ", spelltypeStr)
			E.Write("prepend \'-\' to remove spell type")
			E.Write(SYSTEMOPTIONS_MENU, ": all, clear, default")
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
					if not spell.hide and (value == "all" or value == spell.type) then
						E.DB.profile.Party[zone].spells[sid] = true
					elseif removeType == spell.type then
						E.DB.profile.Party[zone].spells[sid] = false
					end
				end
			end
		end
		E.UpdateEnabledSpells(P)
		P:Refresh()
		AceRegistry:NotifyChange("OmniCD")
	elseif (command == "r" or command == "raidcd" or E.CFG_ZONE[gsub(command, "^r", "")]) then
		local zone = gsub(command, "^r", "")
		zone = E.CFG_ZONE[zone] and zone or "arena"
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
					if not spell.hide and (value == "all" or value == spell.type) then
						E.DB.profile.Party[zone].raidCDS[sid] = true
					elseif removeType == spell.type then
						E.DB.profile.Party[zone].raidCDS[sid] = false
					end
				end
			end
		end
		E.UpdateEnabledSpells(P)
		P:Refresh()
		AceRegistry:NotifyChange("OmniCD")
	elseif addOnCommands[command] then
		addOnCommands[command](value)
	else
		local AceDialog = LibStub("AceConfigDialog-3.0")
		AceDialog:SetDefaultSize("OmniCD", 960,650)
		AceDialog:Open("OmniCD")

		for modName in pairs(E.moduleOptions) do -- [47]*
			AceDialog:SelectGroup(E.AddOn, modName)
		end
		AceDialog:SelectGroup(E.AddOn, "")
	end
end

SLASH_OmniCD1 = "/oc"
SLASH_OmniCD2 = "/omnicd"
SlashCmdList.OmniCD = E.SlashHandler

E["addOnCommands"] = addOnCommands
