local E, L = select(2, ...):unpack()

local addOnCommands = {}

local spellTypeStr

E.SlashHandler = function(msg)
	local P = E.Party
	local command, value = msg:match("^(%S*)%s*(.-)$");

	if value then
		command = strlower(command)
		value = strlower(value)
	elseif command then
		command = strlower(command)
	end

	if command == "help" or command == "?" then
		E.write("v" .. E.Version)
		E.write(L["Usage:"])
		E.write("/oc <command> or /omnicd <command>")
		E.write(L["Commands:"])
		E.write("test or t: " .. L["Toggle test frames for current zone."])
		E.write("reload or rl: " .. L["Reload addon."])
		E.write("reset or rt: " .. L["Reset all cooldown timers."])
	elseif command == "rl" or command == "reload" then
		E:Refresh()
	elseif command == "t" or command == "test" then
		if E:GetModuleEnabled("Party") then
			local key = not P.isInTestMode and P.zone
			P:Test(key)
		else
			E.write("Module not enabled!")
		end
	elseif command == "rt" or command == "reset" then
		if value == "" then
			P:ResetAllIcons()
			E.write("Timers reset.")
		elseif value == "db" or value == "database" then

			OmniCDDB = {}
			C_UI.Reload()
		elseif value == "pf" or value == "profile" then
			E.DB:ResetProfile()
			E.write("Profile reset.")
			E:ACR_NotifyChange()
		elseif E.L_ALL_ZONE[value] then
			P:ResetOption(value)
			E.write(value, "-settings reset.")
			E:ACR_NotifyChange()
		else
			E.write("Invalid <value>.", value)
		end
	elseif command == "m" or command =="manual" then
		local key = E.L_CFG_ZONE[value] and value or "arena"
		E.profile.Party[key].position.detached = not E.profile.Party[key].position.detached
		local state = E.profile.Party[key].position.detached and VIDEO_OPTIONS_ENABLED or VIDEO_OPTIONS_DISABLED
		E.write(key, L["Manual Mode"], state)
		P:Refresh()
		E:ACR_NotifyChange()
	elseif command == "s" or command == "spell" or E.L_CFG_ZONE[command] then
		local zone = E.L_CFG_ZONE[command] and command or "arena"
		value = value and strlower(value)
		if value == "?" then
			if not spellTypeStr then
				spellTypeStr = "Spell Types:"
				for k in pairs(E.L_PRIORITY) do
					k = strlower(k)
					spellTypeStr = strjoin(", ", spellTypeStr, k)
				end
			end
			E.write("/oc <zone> <spell type|all|clear|default>")
			E.write("/oc arena cc: enable cc spell types.")
			E.write("/oc arena -cc: disable cc spell types.")
			E.write("/oc r<zone> <spell type|all|clear|default>")
			E.write("/oc rarena cc: add cc spell types to RaidCD.")
			E.write("/oc rarena -cc: remove cc spell types from raidCD.")
			E.write(spellTypeStr)
			return
		end

		if value == "clear" then
			wipe(E.profile.Party[zone].spells)
			for i = 1, #E.spellDefaults do
				local sId = E.spellDefaults[i]
				sId = tostring(sId)
				E.profile.Party[zone].spells[sId] = false
			end
		elseif value == "default" then
			P:ResetOption(zone, "spells")
		else
			local removeType = gsub(value, "-", "")
			for _, t in pairs(E.spell_db) do
				for i = 1, #t do
					local v = t[i]
					local sId = tostring(v.spellID)
					local stype = strlower(v.type)
					if not v.hide and (value == "all" or value == stype) then
						E.profile.Party[zone].spells[sId] = true
					elseif removeType == stype then
						E.profile.Party[zone].spells[sId] = false
					end
				end
			end
		end
		P:UpdateEnabledSpells()
		P:Refresh()
		E:ACR_NotifyChange()
	elseif command == "r" or command == "raidcd" or E.L_CFG_ZONE[gsub(command, "^r", "")] then
		local zone = gsub(command, "^r", "")
		zone = E.L_CFG_ZONE[zone] and zone or "arena"
		value = strlower(value)
		if value == "clear" then
			wipe(E.profile.Party[zone].raidCDS)
			for i = 1, #E.raidDefaults do
				local sId = E.raidDefaults[i]
				sId = tostring(sId)
				E.profile.Party[zone].raidCDS[sId] = false
			end
		elseif value == "default" then
			P:ResetOption(zone, "raidCDS")
		else
			local removeType = gsub(value, "-", "")
			for _, t in pairs(E.spell_db) do
				for i = 1, #t do
					local v = t[i]
					local sId = tostring(v.spellID)
					local stype = strlower(v.type)
					if not v.hide and (value == "all" or value == stype) then
						E.profile.Party[zone].raidCDS[sId] = true
					elseif removeType == stype then
						E.profile.Party[zone].raidCDS[sId] = false
					end
				end
			end
		end
		P:UpdateEnabledSpells()
		P:Refresh()
		E:ACR_NotifyChange()
	elseif addOnCommands[command] then
		addOnCommands[command](value)
	else
		E:OpenOptionPanel()
	end
end

function E:OpenOptionPanel()
	self.Libs.ACD:SetDefaultSize(self.AddOn, 960, 640)
	self.Libs.ACD:Open(self.AddOn)
	self.Libs.ACD.OpenFrames.OmniCD.frame:SetScale(E.global.optionPanelScale)

	self.Libs.ACD:SelectGroup(self.AddOn, "Party")
	self.Libs.ACD:SelectGroup(self.AddOn, "Home")
end

local interfaceOptionPanel = CreateFrame("Frame", nil, UIParent)
interfaceOptionPanel.name = E.AddOn
interfaceOptionPanel:Hide()

interfaceOptionPanel:SetScript("OnShow", function(self)
	local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT")
	title:SetText(E.AddOn)

	local context = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	context:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	context:SetText("Type /oc or /omnicd to open the option panel.")

	local open = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
	open:SetText("Open Option Panel")
	open:SetWidth(177)
	open:SetHeight(24)
	open:SetPoint("TOPLEFT", context, "BOTTOMLEFT", 0, -30)
	open.tooltipText = ""
	open:SetScript("OnClick", function()
		E:OpenOptionPanel()
	end)

	self:SetScript("OnShow", nil)
end)

if Settings and Settings.RegisterCanvasLayoutCategory then
	local category, layout = Settings.RegisterCanvasLayoutCategory(interfaceOptionPanel, E.AddOn)
	Settings.RegisterAddOnCategory(category)
	layout:AddAnchorPoint("TOPLEFT", 16, -16)
	layout:AddAnchorPoint("BOTTOMRIGHT", -16, 16)
else
	InterfaceOptions_AddCategory(interfaceOptionPanel)
end

SLASH_OmniCD1 = "/oc"
SLASH_OmniCD2 = "/omnicd"
SlashCmdList[E.AddOn] = E.SlashHandler

E["addOnCommands"] = addOnCommands
