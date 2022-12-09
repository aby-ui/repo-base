

local _detalhes	= 	_G._detalhes
local Loc = LibStub("AceLocale-3.0"):GetLocale ( "Details" )
local _
local addonName, Details222 = ...

local CreateFrame = CreateFrame
local pairs = pairs
local UIParent = UIParent
local UnitGUID = UnitGUID
local tonumber= tonumber
local LoggingCombat = LoggingCombat

SLASH_PLAYEDCLASS1 = "/playedclass"
function SlashCmdList.PLAYEDCLASS(msg, editbox)
	print(Details.GetPlayTimeOnClassString())
end

SLASH_DUMPTABLE1 = "/dumpt"
function SlashCmdList.DUMPTABLE(msg, editbox)
	local result = "return function() return " .. msg .. " end"
	local extractValue = loadstring(result)
	return dumpt(extractValue()())
end

SLASH_DETAILS1, SLASH_DETAILS2, SLASH_DETAILS3 = "/details", "/dt", "/de"

function SlashCmdList.DETAILS (msg, editbox)

	local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower(command)

	if (command == Loc ["STRING_SLASH_WIPE"] or command == "wipe") then

	elseif (command == "api") then
		_detalhes.OpenAPI()



	elseif (command == Loc ["STRING_SLASH_NEW"] or command == "new") then
		_detalhes:CriarInstancia(nil, true)

	elseif (command == Loc ["STRING_SLASH_HISTORY"] or command == "history" or command == "score" or command == "rank" or command == "ranking" or command == "statistics" or command == "stats") then
		_detalhes:OpenRaidHistoryWindow()

	elseif (command == Loc ["STRING_SLASH_TOGGLE"] or command == "toggle") then

		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber(instance)
		if (instance) then
			_detalhes:ToggleWindow (instance)
		else
			_detalhes:ToggleWindows()
		end

	elseif (command == Loc ["STRING_SLASH_HIDE"] or command == Loc ["STRING_SLASH_HIDE_ALIAS1"] or command == "hide") then

		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber(instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance(instance)
			if (not this_instance) then
				return _detalhes:Msg(Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:ShutDown()
			end
		else
			_detalhes:ShutDownAllInstances()
		end

	elseif (command == "classtime" or command == "playedclass") then
		Details.played_class_time = not Details.played_class_time
		Details:Msg("played class:", Details.played_class_time and "enabled" or "disabled")

	elseif (command == "stopperfcheck") then
		Details.check_stuttering = not Details.check_stuttering
		Details:Msg("stuttering/freeze checker:", Details.check_stuttering and "enabled" or "disabled")
		if (Details.check_stuttering) then
			_G["UpdateAddOnMemoryUsage"] = Details.UpdateAddOnMemoryUsage_Custom
		else
			_G["UpdateAddOnMemoryUsage"] = Details.UpdateAddOnMemoryUsage_Original
		end

	elseif (command == "perf") then
		local performanceData = Details.performanceData
		local framesLost = ceil(performanceData.deltaTime / 60)
		local callStack = performanceData.callStack

		local returnTable = {}

		returnTable[#returnTable+1] = "Stuttering Information:"
		returnTable[#returnTable+1] = "An addon feature, script is using: " .. performanceData.culpritFunc .. ""

		returnTable[#returnTable+1] = ""

		returnTable[#returnTable+1] = "Description: " .. performanceData.culpritDesc

		returnTable[#returnTable+1] = ""

		returnTable[#returnTable+1] = "You may first: disable the addon feature that uses the functionality."
		returnTable[#returnTable+1] = "Second: disable a script which are using the function call: " .. performanceData.culpritFunc .. "."

		returnTable[#returnTable+1] = ""

		returnTable[#returnTable+1] = "Callstack for Debug:"
		local callStackTable = DetailsFramework:SplitTextInLines(callStack)
		for i = 1, #callStackTable do
			returnTable[#returnTable+1] = callStackTable[i]
		end

		dumpt(returnTable)

	elseif (command == "mergepetspells") then
		Details.merge_pet_abilities = not Details.merge_pet_abilities
		Details:Msg("Merging pet spells:", Details.merge_pet_abilities or "false")

	elseif (command == "softhide") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat(true)
				end
			end
		end

	elseif (command == "softshow") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat(false)
				end
			end
		end

	elseif (command == "softtoggle") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					if (instance.baseframe:GetAlpha() > 0.1) then
						--show
						instance:SetWindowAlphaForCombat(true)
					else
						--hide
						instance:SetWindowAlphaForCombat(false)
					end
				end
			end
		end

	elseif (command == Loc ["STRING_SLASH_SHOW"] or command == Loc ["STRING_SLASH_SHOW_ALIAS1"] or command == "show") then

		_detalhes.LastShowCommand = GetTime()
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber(instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance(instance)
			if (not this_instance) then
				return _detalhes:Msg(Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (not this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:EnableInstance()
			end
		else
			_detalhes:ReabrirTodasInstancias()
		end

	elseif (command == Loc ["STRING_SLASH_WIPECONFIG"] or command == "reinstall") then
		_detalhes:WipeConfig()

	elseif (command == Loc ["STRING_SLASH_RESET"] or command == Loc ["STRING_SLASH_RESET_ALIAS1"] or command == "reset") then
		_detalhes.tabela_historico:resetar()

	elseif (command == Loc ["STRING_SLASH_DISABLE"] or command == "disable") then

		_detalhes:CaptureSet (false, "damage", true)
		_detalhes:CaptureSet (false, "heal", true)
		_detalhes:CaptureSet (false, "energy", true)
		_detalhes:CaptureSet (false, "miscdata", true)
		_detalhes:CaptureSet (false, "aura", true)
		_detalhes:CaptureSet (false, "spellcast", true)

		print(Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREOFF"])

	elseif (command == Loc ["STRING_SLASH_ENABLE"] or command == "enable") then

		_detalhes:CaptureSet (true, "damage", true)
		_detalhes:CaptureSet (true, "heal", true)
		_detalhes:CaptureSet (true, "energy", true)
		_detalhes:CaptureSet (true, "miscdata", true)
		_detalhes:CaptureSet (true, "aura", true)
		_detalhes:CaptureSet (true, "spellcast", true)

		print(Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREON"])

	elseif (command == Loc ["STRING_SLASH_OPTIONS"] or command == "options" or command == "config") then

		if (rest and tonumber(rest)) then
			local instanceN = tonumber(rest)
			if (instanceN > 0 and instanceN <= #_detalhes.tabela_instancias) then
				local instance = _detalhes:GetInstance(instanceN)
				_detalhes:OpenOptionsWindow (instance)
			end
		else
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _detalhes:GetInstance(1)
				_detalhes.CriarInstancia (_, _, 1)
				_detalhes:OpenOptionsWindow (instance)
			else
				_detalhes:OpenOptionsWindow (_detalhes:GetInstance(lower_instance))
			end

		end

	elseif (command == Loc ["STRING_SLASH_WORLDBOSS"] or command == "worldboss") then

		local questIds = {{"Tarlna the Ageless", 81535}, {"Drov the Ruiner ", 87437}, {"Rukhmar", 87493}}
		for _, _table in pairs(questIds) do
			print(format("%s: \124cff%s\124r", _table [1], IsQuestFlaggedCompleted (_table [2]) and "ff0000"..Loc ["STRING_KILLED"] or "00ff00"..Loc ["STRING_ALIVE"]))
		end

	elseif (command == Loc ["STRING_SLASH_CHANGES"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS1"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS2"] or command == "news" or command == "updates") then
		_detalhes:OpenNewsWindow()

	elseif (command == "discord") then
		_detalhes:CopyPaste ("https://discord.gg/AGSzAZX")


	elseif (command == "exitlog") then
		local newT = {}
		for _, str in ipairs(_detalhes_global.exit_log) do
			newT [#newT+1] = str
		end

		newT [#newT+1] = ""

		for _, str in ipairs(_detalhes_global.exit_errors) do
			newT [#newT+1] = str
		end

		newT [#newT+1] = ""

		if (__details_backup._exit_error) then
			for _, str in ipairs(__details_backup._exit_error) do
				newT [#newT+1] = str
			end
		end

		Details:Dump(newT)


	elseif (command == "debugwindow") then

		local window1 = Details:GetWindow(1)
		if (window1) then
			local state = {
				ParentName = window1.baseframe:GetParent():GetName(),
				Alpha = window1.baseframe:GetAlpha(),
				IsShown = window1.baseframe:IsShown(),
				IsOpen = window1:IsEnabled() and true or false,
				NumPoints = window1.baseframe:GetNumPoints(),
			}

			for i = 1, window1.baseframe:GetNumPoints() do
				state ["Point" .. i] = {window1.baseframe:GetPoint(i)}
			end

			local parent = window1.baseframe:GetParent()

			state ["ParentInfo"] = {
				Alpha = parent:GetAlpha(),
				IsShown = parent:IsShown(),
				NumPoints = parent:GetNumPoints(),
			}

			Details:Dump (state)
		else
			Details:Msg("Window 1 not found.")
		end

	elseif (command == "bosstimers" or command == "bosstimer" or command == "timer" or command == "timers") then
		Details.OpenForge()
		DetailsForgePanel.SelectModule (_, _, 4)

	elseif (command == "spells") then
		Details.OpenForge()
		DetailsForgePanel.SelectModule (_, _, 1)

	elseif (msg == "WA" or msg == "wa" or msg == "Wa" or msg == "wA") then
		_G.DetailsPluginContainerWindow.OpenPlugin(_G.DetailsAuraPanel)
		_G.DetailsAuraPanel.RefreshWindow()

	elseif (command == "feedback") then
		_detalhes.OpenFeedbackWindow()

	elseif (command == "profile") then
		if (rest and rest ~= "") then

			local profile = _detalhes:GetProfile (rest)
			if (not profile) then
				return _detalhes:Msg("Profile Not Found.")
			end

			if (not _detalhes:ApplyProfile (rest)) then
				return
			end

			_detalhes:Msg(Loc ["STRING_OPTIONS_PROFILE_LOADED"], rest)
			if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
				_G.DetailsOptionsWindow:Hide()
				GameCooltip:Close()
			end
		else
			_detalhes:Msg("/details profile <profile name>")
		end

-------- debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	elseif (msg == "exitlog") then

		local exitlog = _detalhes_global.exit_log
		local exiterrors = _detalhes_global.exit_errors

		print("EXIT LOG:")
		for index, text in ipairs(exitlog) do
			print(text)
		end
		print("ERRORS:")
		if (exiterrors) then
			for index, text in ipairs(exiterrors) do
				print(text)
			end
		else
			print("|cFF00FF00No error occured!|r")
		end

	elseif (msg == "tr") then

		local f = CreateFrame("frame", nil, UIParent)
		f:SetSize(300, 300)
		f:SetPoint("center")

--		/run TTT:SetTexture("Interface\\1024.tga")
		local texture = f:CreateTexture("TTT", "background")
		texture:SetAllPoints()
		texture:SetTexture("Interface\\1023.tga")

		local A = DetailsFramework:CreateAnimationHub (texture)

		local b = DetailsFramework:CreateAnimation(A, "ROTATION", 1, 40, 360)
		b:SetTarget (texture)
		A:Play()

		C_Timer.NewTicker(1, function()
			texture:SetTexCoord(math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random())
		end)


	elseif (msg == "realmsync") then

		_detalhes.realm_sync = not _detalhes.realm_sync
		_detalhes:Msg("Realm Sync: ", _detalhes.realm_sync and "Enabled" or "Disabled")

		if (not _detalhes.realm_sync) then
			LeaveChannelByName ("Details")
		else
			_detalhes:CheckChatOnLeaveGroup()
		end

	elseif (msg == "load") then

		print(DetailsDataStorage)

		local loaded, reason = LoadAddOn ("Details_DataStorage")
		print(loaded, reason, DetailsDataStorage)


	elseif (msg == "owner2") then

		local tip = CreateFrame('GameTooltip', 'GuardianOwnerTooltip', nil, 'GameTooltipTemplate')
		function GetGuardianOwner(guid)
			tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
			tip:SetHyperlink('unit:' .. guid or '')
			local text = GuardianOwnerTooltipTextLeft2
			--return strmatch(text and text:GetText() or '', "^([^%s']+)'")
			return text:GetText()
		end

		print(GetGuardianOwner(UnitGUID("target")))

	elseif (msg == "chat") then


	elseif (msg == "chaticon") then
		_detalhes:Msg("|TInterface\\AddOns\\Details\\images\\icones_barra:" .. 14 .. ":" .. 14 .. ":0:0:256:32:0:32:0:32|tteste")

	elseif (msg == "align") then
		local c = RightChatPanel
		local w,h = c:GetSize()
		print(w,h)

		local instance1 = _detalhes.tabela_instancias [1]
		local instance2 = _detalhes.tabela_instancias [2]

		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		instance1.baseframe:SetSize(w/2 - 4, h-20-21-8)
		instance2.baseframe:SetSize(w/2 - 4, h-20-21-8)

		instance1.baseframe:SetPoint("bottomleft", RightChatDataPanel, "topleft", 1, 1)
		instance2.baseframe:SetPoint("bottomright", RightChatToggleButton, "topright", -1, 1)

	elseif (msg == "pets") then
		local f = _detalhes:CreateListPanel()

		local i = 1
		for k, v in pairs(_detalhes.tabela_pets.pets) do
			if (v[6] == "Guardian of Ancient Kings") then
				_detalhes.ListPanel:add ( k.. ": " ..  v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[6], i)
				i = i + 1
			end
		end

		f:Show()

	elseif (msg == "savepets") then

		_detalhes.tabela_vigente.saved_pets = {}

		for k, v in pairs(_detalhes.tabela_pets.pets) do
			_detalhes.tabela_vigente.saved_pets [k] = {v[1], v[2], v[3]}
		end

		_detalhes:Msg("pet table has been saved on current combat.")

	elseif (msg == "move") then

		print("moving...")

		local instance = _detalhes.tabela_instancias [1]
		instance.baseframe:ClearAllPoints()
		--instance.baseframe:SetPoint("CENTER", UIParent, "CENTER", 300, 100)
		instance.baseframe:SetPoint("left", DetailsWelcomeWindow, "right", 10, 0)

	elseif (msg == "model") then
		local frame = CreateFrame("PlayerModel");
		frame:SetPoint("center",UIParent,"center");
		frame:SetHeight(600);
		frame:SetWidth(300);
		frame:SetDisplayInfo (49585);

	elseif (msg == "ej2") then

		--[[ get the EJ_ raid id
		local wantRaids = true -- set false to get 5-man list
		for i=1,1000 do
		    instanceID,name,description,bgImage,buttonImage,loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceByIndex(i,wantRaids)
		    if not instanceID then break end
		    DEFAULT_CHAT_FRAME:AddMessage(      instanceID.." "..name ,1,0.7,0.5)
		end
		--]]

		local iid=362

		for i=1, 100 do
		    local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, iid)

		    if not encounterID then break end
		    local msg = encounterID .. " , " ..  name .. ", ".. rootSectionID.. ", "..link
		    DEFAULT_CHAT_FRAME:AddMessage(msg, 1,0.7,0.5)
		end

	elseif (msg == "time") then
		print("GetTime()", GetTime())
		print("time()", time())

	elseif (msg == "copy") then
		_G.DetailsCopy:Show()
		_G.DetailsCopy.MyObject.text:HighlightText()
		_G.DetailsCopy.MyObject.text:SetFocus()

	elseif (msg == "garbage") then
		local a = {}
		for i = 1, 10000 do
			a [i] = {math.random(50000)}
		end
		table.wipe(a)

	elseif (msg == "unitname") then

		local nome, realm = UnitName ("target")
		if (realm) then
			nome = nome.."-"..realm
		end
		print(nome, realm)

	elseif (msg == "raid") then

		local player, realm = "Ditador", "Azralon"

		local actorName
		if (realm ~= GetRealmName()) then
			actorName = player.."-"..realm
		else
			actorName = player
		end

		print(actorName)

		local guid = _detalhes:FindGUIDFromName ("Ditador")
		print(guid)

		for i = 1, GetNumGroupMembers()-1, 1 do
			local name, realm = UnitName ("party"..i)
			print(name, " -- ", realm)
		end

	elseif (msg == "cacheparser") then
		_detalhes:PrintParserCacheIndexes()
	elseif (msg == "parsercache") then
		_detalhes:PrintParserCacheIndexes()

	elseif (msg == "captures") then
		for k, v in pairs(_detalhes.capture_real) do
			print("real -",k,":",v)
		end
		for k, v in pairs(_detalhes.capture_current) do
			print("current -",k,":",v)
		end

	elseif (msg == "slider") then

		local f = CreateFrame("frame", "TESTEDESCROLL", UIParent)
		f:SetPoint("center", UIParent, "center", 200, -2)
		f:SetWidth(300)
		f:SetHeight(150)
		f:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor(0, 0, 0, 1)
		f:EnableMouseWheel(true)

		local rows = {}
		for i = 1, 7 do
			local row = CreateFrame("frame", nil, UIParent)
			row:SetPoint("topleft", f, "topleft", 10, -(i-1)*21)
			row:SetWidth(200)
			row:SetHeight(20)
			row:SetBackdrop({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			local t = row:CreateFontString(nil, "overlay", "GameFontHighlightSmall")
			t:SetPoint("left", row, "left")
			row.text = t
			rows [#rows+1] = row
		end

		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}



	elseif (msg == "bcollor") then

		--local instancia = _detalhes.tabela_instancias [1]
		_detalhes.ResetButton.Middle:SetVertexColor(1, 1, 0, 1)

		--print(_detalhes.ResetButton:GetHighlightTexture())

		local t = _detalhes.ResetButton:GetHighlightTexture()
		t:SetVertexColor(0, 1, 0, 1)
		--print(t:GetObjectType())
		--_detalhes.ResetButton:SetHighlightTexture(t)
		_detalhes.ResetButton:SetNormalTexture(t)

		print("backdrop", _detalhes.ResetButton:GetBackdrop())

		_detalhes.ResetButton:SetBackdropColor(0, 0, 1, 1)

		--Details.VarDump (_detalhes.ResetButton)

	elseif (command == "mini") then
		local instance = _detalhes.tabela_instancias [1]
		--Details.VarDump ()
		--print(instance, instance.StatusBar.options, instance.StatusBar.left)
		print(instance.StatusBar.options [instance.StatusBar.left.mainPlugin.real_name].textSize)
		print(instance.StatusBar.left.options.textSize)

	elseif (command == "owner") then

		local petname = rest:match ("^(%S*)%s*(.-)$")
		local petGUID = UnitGUID("target")

		if (not _G.DetailsScanTooltip) then
			local scanTool = CreateFrame("GameTooltip", "DetailsScanTooltip", nil, "GameTooltipTemplate")
			scanTool:SetOwner(WorldFrame, "ANCHOR_NONE")
		end

		function getPetOwner (petName)
			local scanTool = _G.DetailsScanTooltip
			local scanText = _G ["DetailsScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>

			scanTool:ClearLines()

			print(petName)
			scanTool:SetUnit(petName)

			local ownerText = scanText:GetText()
			if (not ownerText) then
				return nil
			end
			local owner, _ = string.split ("'", ownerText)

			return owner -- This is the pet's owner
		end

		--print(getPetOwner (petname))
		print(getPetOwner (petGUID))


	elseif (command == "buffsof") then

		local playername, segment = rest:match("^(%S*)%s*(.-)$")
		segment = tonumber(segment or 0)
		print("dumping buffs of ", playername, segment)

		local c = _detalhes:GetCombat("current")
		if (c) then

			local playerActor

			if (segment and segment ~= 0) then
				local c = _detalhes:GetCombat(segment)
				playerActor = c (4, playername)
				print("using segment", segment, c, "player actor:", playerActor)
			else
				playerActor = c (4, playername)
			end

			print("actor table: ", playerActor)

			if (not playerActor) then
				print("actor table not found")
				return
			end

			if (playerActor and playerActor.buff_uptime_spells and playerActor.buff_uptime_spells._ActorTable) then
				for spellid, spellTable in pairs(playerActor.buff_uptime_spells._ActorTable) do
					local spellname = GetSpellInfo(spellid)
					if (spellname) then
						print(spellid, spellname, spellTable.uptime)
					end
				end
			end
		end

	elseif (msg == "teste") then

		local a, b = _detalhes:GetEncounterEnd (1098, 3)
		print(a, unpack(b))

	elseif (msg == "yesno") then
		--_detalhes:Show()

	elseif (msg == "imageedit") then

		local callback = function(width, height, overlayColor, alpha, texCoords)
			print(width, height, alpha)
			print("overlay: ", unpack(overlayColor))
			print("crop: ", unpack(texCoords))
		end

		_detalhes.gump:ImageEditor (callback, "Interface\\TALENTFRAME\\bg-paladin-holy", nil, {1, 1, 1, 1}) -- {0.25, 0.25, 0.25, 0.25}

	elseif (msg == "chat") then

		local name, fontSize, r, g, b, a, shown, locked = FCF_GetChatWindowInfo (1);
		print(name,"|",fontSize,"|", r,"|", g,"|", b,"|", a,"|", shown,"|", locked)

		--local fontFile, unused, fontFlags = self:GetFont();
		--self:SetFont(fontFile, fontSize, fontFlags);

	elseif (msg == "error") then
		a = nil + 1

	--debug
	elseif (command == "resetcapture") then
		_detalhes.capture_real = {
			["damage"] = true,
			["heal"] = true,
			["energy"] = true,
			["miscdata"] = true,
			["aura"] = true,
		}
		_detalhes.capture_current = _detalhes.capture_real
		_detalhes:CaptureRefresh()
		print(Loc ["STRING_DETAILS1"] .. "capture has been reseted.")

	--debug
	elseif (command == "barra") then

		local whichRowLine = rest and tonumber(rest) or 1

		local instancia = _detalhes.tabela_instancias [1]
		local barra = instancia.barras [whichRowLine]

		for i = 1, barra:GetNumPoints() do
			local point, relativeTo, relativePoint, xOfs, yOfs = barra:GetPoint(i)
			print(point, relativeTo, relativePoint, xOfs, yOfs)
		end

	elseif (msg == "opened") then
		print("Instances opened: " .. _detalhes.opened_windows)

	--debug, get a guid of something
	elseif (command == "backdrop") then --localize-me
		local f = MacroFrameTextBackground
		local backdrop = MacroFrameTextBackground:GetBackdrop()

		Details.VarDump (backdrop)
		Details.VarDump (backdrop.insets)

		print("bgcolor:",f:GetBackdropColor())
		print("bordercolor",f:GetBackdropBorderColor())

	elseif (command == "myguid") then --localize-me

		local g = UnitGUID("player")
		print(type(g))
		print(g)
		print(string.len(g))
		local serial = g:sub (12, 18)
		serial = tonumber("0x"..serial)
		print(serial)

		--tonumber((UnitGUID("target")):sub(-12, -9), 16))

	elseif (command == "npcid") then
		if (UnitExists("target")) then
			local serial = UnitGUID("target")
			if (serial) then
				local npcId = _G.DetailsFramework:GetNpcIdFromGuid(serial)
				if (npcId) then

					if (not Details.id_frame) then
						local backdrop = {
							bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
							edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
							tile = true, edgeSize = 1, tileSize = 5,
						}

						Details.id_frame = CreateFrame("Frame", "DetailsID", UIParent, "BackdropTemplate")
						Details.id_frame:SetHeight(14)
						Details.id_frame:SetWidth(120)
						Details.id_frame:SetPoint("center", UIParent, "center")
						Details.id_frame:SetBackdrop(backdrop)

						tinsert(UISpecialFrames, "DetailsID")

						Details.id_frame.texto = CreateFrame("editbox", nil, Details.id_frame, "BackdropTemplate")
						Details.id_frame.texto:SetPoint("topleft", Details.id_frame, "topleft")
						Details.id_frame.texto:SetAutoFocus(false)
						Details.id_frame.texto:SetFontObject(GameFontHighlightSmall)
						Details.id_frame.texto:SetHeight(14)
						Details.id_frame.texto:SetWidth(120)
						Details.id_frame.texto:SetJustifyH("CENTER")
						Details.id_frame.texto:EnableMouse(true)
						Details.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
						Details.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
						Details.id_frame.texto:SetText("")
						Details.id_frame.texto.perdeu_foco = nil

						Details.id_frame.texto:SetScript("OnEnterPressed", function()
							Details.id_frame.texto:ClearFocus()
							Details.id_frame:Hide()
						end)

						Details.id_frame.texto:SetScript("OnEscapePressed", function()
							Details.id_frame.texto:ClearFocus()
							Details.id_frame:Hide()
						end)

					end

					C_Timer.After(0.1, function()
						Details.id_frame:Show()
						Details.id_frame.texto:SetFocus()
						Details.id_frame.texto:SetText("" .. npcId)
						Details.id_frame.texto:HighlightText()
					end)
				end
			end
		end


	elseif (command == "guid") then
		if (UnitExists("target")) then
			local serial = UnitGUID("target")
			if (serial) then
				local npcId = serial
				if (not Details.id_frame) then
					local backdrop = {
						bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
						edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
						tile = true, edgeSize = 1, tileSize = 5,
					}

					Details.id_frame = CreateFrame("Frame", "DetailsID", UIParent, "BackdropTemplate")
					Details.id_frame:SetHeight(14)
					Details.id_frame:SetWidth(120)
					Details.id_frame:SetPoint("center", UIParent, "center")
					Details.id_frame:SetBackdrop(backdrop)

					tinsert(UISpecialFrames, "DetailsID")

					Details.id_frame.texto = CreateFrame("editbox", nil, Details.id_frame, "BackdropTemplate")
					Details.id_frame.texto:SetPoint("topleft", Details.id_frame, "topleft")
					Details.id_frame.texto:SetAutoFocus(false)
					Details.id_frame.texto:SetFontObject(GameFontHighlightSmall)
					Details.id_frame.texto:SetHeight(14)
					Details.id_frame.texto:SetWidth(120)
					Details.id_frame.texto:SetJustifyH("CENTER")
					Details.id_frame.texto:EnableMouse(true)
					Details.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
					Details.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
					Details.id_frame.texto:SetText("")
					Details.id_frame.texto.perdeu_foco = nil

					Details.id_frame.texto:SetScript("OnEnterPressed", function()
						Details.id_frame.texto:ClearFocus()
						Details.id_frame:Hide()
					end)

					Details.id_frame.texto:SetScript("OnEscapePressed", function()
						Details.id_frame.texto:ClearFocus()
						Details.id_frame:Hide()
					end)

				end

				C_Timer.After(0.1, function()
					Details.id_frame:Show()
					Details.id_frame.texto:SetFocus()
					Details.id_frame.texto:SetText("" .. npcId)
					Details.id_frame.texto:HighlightText()
				end)
			end
		end

	elseif (command == "profile") then

		local profile = rest:match("^(%S*)%s*(.-)$")

		print("Force apply profile: ", profile)

		_detalhes:ApplyProfile (profile, false)

	elseif (msg == "version") then
		Details.ShowCopyValueFrame(Details.GetVersionString())

	elseif (msg == "users" or msg == "version" or msg == "versioncheck") then
		Details.SendHighFive()

		print(Loc ["STRING_DETAILS1"] .. "highfive sent, HI!")

		C_Timer.After(0.3, function()
			Details.RefreshUserList()
		end)
		C_Timer.After(0.6, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(0.9, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(1.3, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(1.6, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(3, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(4, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(5, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After(8, function()
			Details.RefreshUserList (true)
		end)

	elseif (command == "names") then
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber(t)
		if (not t) then
			return print("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end

		local container = _detalhes.tabela_vigente [t]._NameIndexTable

		local i = 0
		for name, _ in pairs(container) do
			i = i + 1
			f:add (name, i)
		end

		print(i, "names found.")

		f:Show()

	elseif (command == "actors") then

		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber(t)
		if (not t) then
			return print("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end

		local container = _detalhes.tabela_vigente [t]._ActorTable
		print(#container, "actors found.")
		for index, actor in ipairs(container) do
			f:add (actor.nome, index, filter)
		end

		f:Show()

	--debug
	elseif (msg == "save") then
		print("running... this is a debug command, details wont work until next /reload.")
		_detalhes:PrepareTablesForSave()

	elseif (msg == "buffs") then
		for i = 1, 40 do
			local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellid = UnitBuff ("player", i)
			if (not name) then
				return
			end
			print(spellid, name)
		end

	elseif (msg == "id") then
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one ~= "") then
			print("NPC ID:", one:sub(-12, -9), 16)
			print("NPC ID:", tonumber((one):sub(-12, -9), 16))
		else
			print("NPC ID:", tonumber((UnitGUID("target")):sub(-12, -9), 16) )
		end

	--debug
	elseif (command == "debugnet") then
		if (_detalhes.debugnet) then
			_detalhes.debugnet = false
			print(Loc["STRING_DETAILS1"] .. "net diagnostic mode has been turned off.")
			return
		else
			_detalhes.debugnet = true
			print(Loc["STRING_DETAILS1"] .. "net diagnostic mode has been turned on.")
		end

	elseif (command == "debug") then
		if (_detalhes.debug) then
			_detalhes.debug = false
			print(Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned off.")
			return
		else
			_detalhes.debug = true
			print(Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned on.")

			if (rest and rest ~= "") then
				if (rest == "-clear") then
					_detalhes_global.debug_chr_log = ""
					print(Loc ["STRING_DETAILS1"] .. "log for characters has been wiped.")
					return
				end
				_detalhes.debug_chr = rest
				_detalhes_global.debug_chr_log = _detalhes_global.debug_chr_log or ""
				print(Loc ["STRING_DETAILS1"] .. "diagnostic for character " .. rest .. " turned on.")
				return
			end
		end

	--debug combat log
	elseif (msg == "combatlog") then
		if (_detalhes.isLoggingCombat) then
			LoggingCombat (false)
			print("Wow combatlog record turned OFF.")
			_detalhes.isLoggingCombat = nil
		else
			LoggingCombat (true)
			print("Wow combatlog record turned ON.")
			_detalhes.isLoggingCombat = true
		end

	elseif (msg == "gs") then
		_detalhes:teste_grayscale()

	elseif (msg == "bwload") then
		if not BigWigs then LoadAddOn("BigWigs_Core") end
		BigWigs:Enable()

		LoadAddOn ("BigWigs_Highmaul")

		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Enable()

	elseif (msg == "bwsend") then
		local mod = BigWigs:GetBossModule("Imperator Mar'gok")
		mod:Message("stages", "Neutral", "Long", "Phase 2", false)

	elseif (msg == "bwregister") then

		local addon = {}
		BigWigs.RegisterMessage(addon, "BigWigs_Message")
		function addon:BigWigs_Message(event, module, key, text)
		  if module.journalId  == 1197 and text:match("^Phase %d$") then -- 1197 = Margok
		   print("Phase Changed!", event, module, key, text)
		  end
		end

	elseif (msg == "pos") then
		local x, y = GetPlayerMapPosition ("player")

		if (not DetailsPosBox) then
			_detalhes.gump:CreateTextEntry(UIParent, function()end, 200, 20, nil, "DetailsPosBox")
			DetailsPosBox:SetPoint("center", UIParent, "center")
		end

		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one == "2") then
			DetailsPosBox.MyObject.text = "{x2 = " .. x .. ", y2 = " .. y .. "}"
		else
			DetailsPosBox.MyObject.text = "{x1 = " .. x .. ", y1 = " .. y .. "}"
		end
		DetailsPosBox.MyObject:SetFocus()
		DetailsPosBox.MyObject:HighlightText()

	elseif (msg == "outline") then

		local instancia = _detalhes.tabela_instancias [1]
		for _, barra in ipairs(instancia.barras) do
			local _, _, flags = barra.lineText1:GetFont()
			print("outline:",flags)
		end

	elseif (msg == "sell") then

		--sell gray
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				i = {GetContainerItemInfo (b, s)}
				n = i[7]
				if n and string.find(n,"9d9d9d") then
					v = {GetItemInfo(n)}
					q = i[2]
					c = c+v[11]*q
					UseContainerItem (b, s)
					print(n, q)
				end
			end
		end
		print(GetCoinText(c))

		--sell green equip
		local c, i, n, v = 0
		for b = 0, 4 do
			for s = 1, GetContainerNumSlots(b) do
				local texture, itemCount, locked, quality, readable, lootable, itemLink = GetContainerItemInfo (b, s)
				if (quality == 2) then --a green item
					local itemName, itemLink, itemRarity, itemLevel, _, itemType, itemSubType = GetItemInfo (itemLink)
					if (itemType == "Armor" or itemType == "Weapon") then --a weapon or armor
						if (itemLevel < 460) then
							print("Selling", itemName, itemType)
							UseContainerItem (b, s)
						end
					end
				end
			end
		end

	elseif (msg == "forge") then
		_detalhes:OpenForge()

	elseif (msg == "parser") then

		_detalhes:OnParserEvent (
			"COMBAT_LOG_EVENT_UNFILTERED", --evento =
			1548754114, --time =
			"SPELL_DAMAGE", --token =
			nil, --hidding =
			"0000000000000000", --who_serial =
			nil, --who_name =
			0x514, --who_flags =
			0x0, --who_flags2 =
			"Player-3676-06F3C3FA", --alvo_serial =
			"Icybluefur-Area52", --alvo_name =
			0x514, --alvo_flags =
			0x0, --alvo_flags2 =
			157247, --spellid =
			"Reverberations", --spellname =
			0x1, --spelltype =
			4846, --amount =
			-1, --overkill =
			1 --school =
		)

	elseif (msg == "ejloot") then
		DetailsFramework.EncounterJournal.EJ_SelectInstance (669) -- hellfire citadel
		DetailsFramework.EncounterJournal.EJ_SetDifficulty (16)

		local r = {}
		local total = 0

		for i = 1, 100 do
			local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, 669)
			if (name) then
				DetailsFramework.EncounterJournal.EJ_SelectEncounter (encounterID)
				print(name, encounterID, DetailsFramework.EncounterJournal.EJ_GetNumLoot())

				for o = 1, DetailsFramework.EncounterJournal.EJ_GetNumLoot() do
					local name, icon, slot, armorType, itemID, link, encounterID = DetailsFramework.EncounterJournal.EJ_GetLootInfoByIndex (o)
					r[slot] = r[slot] or {}
					tinsert(r[slot], {itemID, encounterID})
					total = total + 1
				end
			end
		end

		print("total loot", total)
		_detalhes_global.ALOOT  = r

	elseif (msg == "ilvl" or msg == "itemlevel" or msg == "ilevel") then

		local item_amount = 16
		local item_level = 0
		local failed = 0
		local unitid = "player"
		local two_hand = {
			["INVTYPE_2HWEAPON"] = true,
			["INVTYPE_RANGED"] = true,
			["INVTYPE_RANGEDRIGHT"] = true,
		}

		_detalhes:Msg("======== Item Level Debug ========")

		for equip_id = 1, 17 do
			if (equip_id ~= 4) then --shirt slot
				local item = GetInventoryItemLink (unitid, equip_id)
				if (item) then
					local _, _, itemRarity, iLevel, _, _, _, _, equipSlot = GetItemInfo (item)
					if (iLevel) then
						item_level = item_level + iLevel
						print(iLevel, item)
						--16 = main hand 17 = off hand
						-- if using a two-hand, ignore the off hand slot
						if (equip_id == 16 and two_hand [equipSlot]) then
							item_amount = 15
							break
						end
					end
				else
					failed = failed + 1
					if (failed > 2) then
						break
					end
				end
			end
		end

		local average = item_level / item_amount
		_detalhes:Msg("gear score: " .. item_level, "| item amount:", item_amount, "| ilvl:", average)

		_detalhes.ilevel:CalcItemLevel ("player", UnitGUID("player"), true)

	elseif (msg == "score") then

		_detalhes:OpenRaidHistoryWindow ("Hellfire Citadel", 1800, 15, "DAMAGER", "Rock Lobster", 2, "Keyspell")

	elseif (msg == "bar") then
		local bar = _G.DetailsTestBar
		if (not bar) then
			bar = Details.gump:CreateBar (UIParent, nil, 600, 200, 100, nil, "DetailsTestBar")
			_G.DetailsTestBar = bar
			bar:SetPoint("center", 0, 0)
			bar.RightTextIsTimer = true
			bar.BarIsInverse = true
		end

		bar.color = "HUNTER"

		local start = GetTime()-45
		local fim = GetTime()+5

		bar:SetTimer (start, fim)

		--C_Timer.After(5, function() bar:CancelTimerBar() end)


	elseif (msg == "q") then

		local myframe = TestFrame
		if (not myframe) then
			myframe = TestFrame or CreateFrame("frame", "TestFrame", UIParent)
			myframe:SetPoint("center", UIParent, "center")
			myframe:SetSize(300, 300)
			myframe.texture = myframe:CreateTexture(nil, "overlay")
			myframe.texture:SetAllPoints()
			myframe.texture:SetTexture([[Interface\AddOns\WorldQuestTracker\media\icon_flag_common]])
		else
			if (myframe.texture:IsShown()) then
				myframe.texture:Hide()
			else
				print(myframe.texture:GetTexture())
				myframe.texture:Show()
				print(myframe.texture:GetTexture())
			end
		end



		if (true) then
			return
		end

		local y = -50
		local allspecs = {}

		for a, b in pairs(_detalhes.class_specs_coords) do
			tinsert(allspecs, a)
		end

		for i = 1, 10 do

			local a = CreateFrame("statusbar", nil, UIParent)
			a:SetPoint("topleft", UIParent, "topleft", i*32, y)
			a:SetSize(32, 32)
			a:SetMinMaxValues(0, 1)

			local texture = a:CreateTexture(nil, "overlay")
			texture:SetSize(32, 32)
			texture:SetPoint("topleft")

			if (i%10 == 0) then
				y = y - 32
			end

--	/run for o=1,10 do local f=CreateFrame("frame");f:SetPoint("center");f:SetSize(300,300); local t=f:CreateTexture(nil,"overlay");t:SetAllPoints();f:SetScript("OnUpdate",function() t:SetTexture("Interface\\1024")end);end;
--	https://www.dropbox.com/s/ulyeqa2z0ummlu7/1024.tga?dl=0

			local elapsedTime = 0
			a:SetScript("OnUpdate", function(self, deltaTime)
				elapsedTime = elapsedTime + deltaTime

				--texture:SetSize(math.random(50, 300), math.random(50, 300))
				--local spec = allspecs [math.random(#allspecs)]
				texture:SetTexture([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture([[Interface\Store\Store-Splash]])
				--texture:SetTexture([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture([[Interface\CHARACTERFRAME\Button_BloodPresence_DeathKnight]])
				--texture:SetTexCoord(unpack(_detalhes.class_specs_coords [spec]))

				--a:SetAlpha(abs(math.sin (time)))
				--a:SetValue(abs(math.sin (time)))
			end)
		end

	elseif (msg == "alert") then
		--local instancia = _detalhes.tabela_instancias [1]
		local f = function(a, b, c, d, e, f, g) print(a, b, c, d, e, f, g) end
		--instancia:InstanceAlert (Loc ["STRING_PLEASE_WAIT"], {[[Interface\COMMON\StreamCircle]], 22, 22, true}, 5, {f, 1, 2, 3, 4, 5})

		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			local instance = _detalhes:GetInstance(lower_instance)
			if (instance) then
				local func = {_detalhes.OpenRaidHistoryWindow, _detalhes, "Hellfire Citadel", 1800, 15, "DAMAGER", "Rock Lobster", 2, "Keyspell"}
				instance:InstanceAlert ("Boss Defeated, Open History! ", {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}, 40, func, true)
			end
		end

	elseif (msg == "teste1") then	-- /de teste1
		_detalhes:OpenRaidHistoryWindow (1530, 1886, 15, "damage", "Rock Lobster", 2, "Keyspell") --, _role, _guild, _player_base, _player_name)

	elseif (msg == "qq") then
		local my_role = "DAMAGER"
		local raid_name = "Tomb of Sargeras"
		local guildName = "Rock Lobster"
		local func = {_detalhes.OpenRaidHistoryWindow, _detalhes, raid_name, 2050, 15, my_role, guildName} --, 2, UnitName ("player")
		--local icon = {[[Interface\AddOns\Details\images\icons]], 16, 16, false, 434/512, 466/512, 243/512, 273/512}
		local icon = {[[Interface\PvPRankBadges\PvPRank08]], 16, 16, false, 0, 1, 0, 1}

		local lower_instance = _detalhes:GetLowerInstanceNumber()
		local instance = _detalhes:GetInstance(lower_instance)

		instance:InstanceAlert ("Boss Defeated! Show Ranking", icon, 10, func, true)

	elseif (msg == "scroll" or msg == "scrolldamage" or msg == "scrolling") then
		Details:ScrollDamage()

	elseif (msg == "me" or msg == "ME" or msg == "Me" or msg == "mE") then
		Details.slash_me_used = true
		local UnitGroupRolesAssigned = DetailsFramework.UnitGroupRolesAssigned
		local role = UnitGroupRolesAssigned("player")
		if (role == "HEALER") then
			Details:OpenPlayerDetails(2)
		else
			Details:OpenPlayerDetails(1)
		end

	elseif (msg == "spec") then

	local spec = DetailsFramework.GetSpecialization()
	if (spec) then
		local specID = DetailsFramework.GetSpecializationInfo(spec)
		if (specID and specID ~= 0) then
			print("Current SpecID: ", specID)
		end
	end

	elseif (msg == "senditemlevel") then
		_detalhes:SendCharacterData()
		print("Item level dispatched.")

	elseif (msg == "talents") then
		local talents = {}
		for i = 1, 7 do
			for o = 1, 3 do
				local talentID, name, texture, selected, available = GetTalentInfo (i, o, 1)
				if (selected) then
					tinsert(talents, talentID)
					break
				end
			end
		end

		print("talentID", "name", "texture", "selected", "available", "spellID", "unknown", "row", "column", "unknown", "unknown")
		for i = 1, #talents do
			print(GetTalentInfoByID (talents [i]))
		end

	elseif (msg == "merge") then

		--at this point, details! should not be in combat
		if (_detalhes.in_combat) then
			_detalhes:Msg("already in combat, closing current segment.")
			_detalhes:SairDoCombate()
		end

		--create a new combat to be the overall for the mythic run
		_detalhes:EntrarEmCombate()

		--get the current combat just created and the table with all past segments
		local newCombat = _detalhes:GetCurrentCombat()
		local segmentHistory = _detalhes:GetCombatSegments()
		local totalTime = 0
		local startDate, endDate = "", ""
		local lastSegment
		local segmentsAdded = 0

		--add all boss segments from this run to this new segment
		for i = 1, 25 do
			local pastCombat = segmentHistory [i]
			if (pastCombat and pastCombat ~= newCombat) then
				newCombat = newCombat + pastCombat
				totalTime = totalTime + pastCombat:GetCombatTime()
				if (i == 1) then
					local _, endedDate = pastCombat:GetDate()
					endDate = endedDate
				end
				lastSegment = pastCombat
				segmentsAdded = segmentsAdded + 1
			end
		end

		if (lastSegment) then
			startDate = lastSegment:GetDate()
		end

		newCombat.is_trash = false
		_detalhes:Msg("done merging, segments: " .. segmentsAdded .. ", total time: " .. DetailsFramework:IntegerToTimer(totalTime))

		--[[ --mythic+ debug
		--tag the segment as mythic overall segment
		newCombat.is_mythic_dungeon = {
			MapID = _detalhes.MythicPlus.Dungeon,
			StartedAt = _detalhes.MythicPlus.StartedAt, --the start of the run
			EndedAt = _detalhes.MythicPlus.EndedAt, --the end of the run
			SegmentID = "overall", --segment number within the dungeon
			--EncounterID = encounterID,
			--EncounterName = encounterName,
			RunID = _detalhes.MythicPlus.RunID,
			OverallSegment = true,
		}
		--]]

		--set some data
		newCombat:SetStartTime (GetTime() - totalTime)
		newCombat:SetEndTime (GetTime())

		newCombat.data_inicio = startDate
		newCombat.data_fim = endDate

		--immediatly finishes the segment just started
		_detalhes:SairDoCombate()

		--cleanup the past segments table
		for i = 25, 1, -1 do
			local pastCombat = segmentHistory [i]
			if (pastCombat and pastCombat ~= newCombat) then
				wipe (pastCombat)
				segmentHistory [i] = nil
			end
		end

		--clear memory
		collectgarbage()

		_detalhes:InstanciaCallFunction(Details.FadeHandler.Fader, "in", nil, "barras")
		_detalhes:InstanciaCallFunction(_detalhes.AtualizaSegmentos)
		_detalhes:InstanciaCallFunction(_detalhes.AtualizaSoloMode_AfertReset)
		_detalhes:InstanciaCallFunction(_detalhes.ResetaGump)
		_detalhes:RefreshMainWindow(-1, true)

	elseif (msg == "ej") then

		local result = {}
		local spellIDs = {}

		--uldir
		DetailsFramework.EncounterJournal.EJ_SelectInstance (1031)

		-- pega o root section id do boss
		local name, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfo (2168) --taloc (primeiro boss de Uldir)

		--overview
		local sectionInfo = C_EncounterJournal.GetSectionInfo (rootSectionID)
		local nextID = {sectionInfo.siblingSectionID}

		while (nextID [1]) do
			--get the deepest section in the hierarchy
			local ID = tremove(nextID)
			local sectionInfo = C_EncounterJournal.GetSectionInfo (ID)

			if (sectionInfo) then
				tinsert(result, sectionInfo)

				if (sectionInfo.spellID and type(sectionInfo.spellID) == "number" and sectionInfo.spellID ~= 0) then
					tinsert(spellIDs, sectionInfo.spellID)
				end

				local nextChild, nextSibling = sectionInfo.firstChildSectionID, sectionInfo.siblingSectionID
				if (nextSibling) then
					tinsert(nextID, nextSibling)
				end
				if (nextChild) then
					tinsert(nextID, nextChild)
				end
			else
				break
			end
		end

		Details:DumpTable (result)

	elseif (msg == "saveskin") then
		local skin = Details.skins["Minimalistic"].instance_cprops
		local instance1 = Details:GetInstance(1)
		if (instance1) then
			local exportedValues = {}
			for key, _ in pairs(skin) do
				local value = instance1[key]
				if (value) then
					exportedValues[key] = value
				end
			end
			Details:Dump(exportedValues)
		end

	elseif (msg == "parselog") then

		local splitLineInArguments = function(lineText)
			local parsedLine = {}
			for piece in lineText:gmatch("([^,]+)") do
				parsedLine[#parsedLine+1] = piece
			end
			return unpack(parsedLine)
		end

		local spellsWithMorePayload = {
			["SPELL_DAMAGE"] = true,
			["SPELL_HEAL"] = true,
			["SWING_DAMAGE"] = true,
			["SWING_DAMAGE_LANDED"] = true,
			["RANGE_DAMAGE"] = true,
			["SPELL_DRAIN"] = true,
			["SPELL_ENERGIZE"] = true,
			["DAMAGE_SPLIT"] = true,
			["SPELL_PERIODIC_ENERGIZE"] = true,
			["SPELL_PERIODIC_DAMAGE"] = true,
			["SPELL_PERIODIC_HEAL"] = true,
		}

		local data = DETAILS_EXTERNAL_LOG
		local t = DetailsFramework:SplitTextInLines(data)
		local a = {}

		local parser = _detalhes.LogParserEvent

		for i = 1, #t do
			print("line:", i)
			local line = t[i]
			line = line:gsub("\"", "")
			local tokenId = line:match("%s%s(.*)"):match("^(.-),")

			if (tokenId == "ENCOUNTER_START") then
				Details:StartCombat()
			end

			if (tokenId == "ENCOUNTER_END") then
				Details:EndCombat()
			end

			local newPayload = {0, tokenId, false}
			local payload = {splitLineInArguments(line)}

			if (spellsWithMorePayload[tokenId]) then
				if (tokenId == "SWING_DAMAGE") then
					for o = 2, 9 do
						newPayload[#newPayload+1] = payload[o]
					end

					for o = 9+17, #payload do
						newPayload[#newPayload+1] = payload[o]
					end
				else
					for o = 2, 12 do
						newPayload[#newPayload+1] = payload[o]
					end

					for o = 12+17, #payload do
						newPayload[#newPayload+1] = payload[o]
					end
				end

				parser(unpack(newPayload))
			else
				for o = 2, #payload do
					newPayload[#newPayload+1] = payload[o]
					print(o, payload[o])
				end
				parser(unpack(newPayload))
			end

			--local payload = {splitLineInArguments(line)}
			--if (#payload > 25) then
			--	a[tokenId] = payload
			--end
		end

		--for tokenId, payload in pairs(a) do
		--	print(tokenId, unpack(payload))
		--end

	elseif (msg == "coach") then
		--if (not UnitIsGroupLeader("player")) then
		--	Details:Msg("you aren't the raid leader.")
		--	return
		--end

		if (not Details.coach.enabled) then
			Details.Coach.WelcomePanel()
		else
			Details:Msg("coach disabled.")
			Details.Coach.Disable()
		end

	elseif (msg == "9") then
		print("skin:", Details.skin)
		print("current profile:", _detalhes:GetCurrentProfileName())
		print("always use profile:", _detalhes.always_use_profile)
		print("profile name:", _detalhes.always_use_profile_name)
		print("version:", _detalhes.build_counter >= _detalhes.alpha_build_counter and _detalhes.build_counter or _detalhes.alpha_build_counter)

	elseif (msg == "record") then


			_detalhes.ScheduleLoadStorage()
			_detalhes.TellDamageRecord = C_Timer.NewTimer(0.6, _detalhes.PrintEncounterRecord)
			_detalhes.TellDamageRecord.Boss = 2032
			_detalhes.TellDamageRecord.Diff = 16

	elseif (msg == "recordtest") then

		local f = DetailsRecordFrameAnimation
		if (not f) then
			f = CreateFrame("frame", "DetailsRecordFrameAnimation", UIParent)

			--estrela no inicio dando um giro
			--Interface\Cooldown\star4
			--efeito de batida?
			--Interface\Artifacts\ArtifactAnim2
			local animationHub = DetailsFramework:CreateAnimationHub (f, function() f:Show() end)

			DetailsFramework:CreateAnimation(animationHub, "Scale", 1, .10, .9, .9, 1.1, 1.1)
			DetailsFramework:CreateAnimation(animationHub, "Scale", 2, .10, 1.2, 1.2, 1, 1)
		end

	--BFA BETA
	--elseif (msg == "update") then
	--	_detalhes:CopyPaste ([[https://www.wowinterface.com/downloads/info23056-DetailsDamageMeter8.07.3.5.html]])

	elseif (msg == "auras") then
		Details.AuraTracker.Open()

	elseif (msg == "ec") then
		if (rest and tonumber(rest)) then
			local combatToErase = tonumber(rest)
			tremove(_detalhes.tabela_historico.tabelas, combatToErase)
			Details:Msg("combat erased.")
		end
		return

	elseif (msg == "generatespelllist") then
		Details.GenerateSpecSpellList()

	elseif (msg == "generateracialslist") then
		Details.GenerateRacialSpellList()

	elseif (msg == "survey") then
		Details.Survey.OpenSurveyPanel()

	elseif (msg == "share") then

		local f = {}

		local elapsed = GetTime()

		local ignoredKeys = {
			minha_barra = true,
			__index = true,
			shadow = true,
			links = true,
			__call = true,
			_combat_table = true,
			previous_combat = true,
			owner = true,
		}

		local keys = {}

		--copy from table2 to table1 overwriting values
		function f.copy(t1, t2)
			if (t1.Timer) then
				t1, t2 = t1.t1, t1.t2
			end
			for key, value in pairs(t2) do
				if (not ignoredKeys [key] and type(value) ~= "function") then
					if (key == "targets") then
						t1 [key] = {}

					elseif (type(value) == "table") then
						t1 [key] = t1 [key] or {}

						--print(key, value)
						--local d = C_Timer.NewTimer(1, f.copy)
						--d.t1 = t1 [key]
						--d.t2 = t2 [key]
						--d.Timer = true

						keys [key] = true

						f.copy(t1 [key], t2 [key])
					else
						t1 [key] = value
					end
				end
			end
			return t1
		end

		--local copySegment = f.copy({}, _detalhes.tabela_vigente)
		local copySegment = f.copy({}, _detalhes.tabela_historico.tabelas [2])

		--the segment received is raw and does not have metatables, need to refresh them
		local zipData = Details:CompressData (copySegment, "print")

		--print(zipData)
		--Details:Dump (keys)
		Details:Dump ({zipData})
	else

		--if (_detalhes.opened_windows < 1) then
		--	_detalhes:CriarInstancia()
		--end

		if (command) then
			--check if the line passed is a parameters in the default profile
			if (_detalhes.default_profile [command]) then
				if (rest and (rest ~= "" and rest ~= " ")) then
					local whichType = type(_detalhes.default_profile [command])

					--attempt to cast the passed value to the same value as the type in the profile
					if (whichType == "number") then
						rest = tonumber(rest)
						if (rest) then
							_detalhes [command] = rest
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to " .. rest)
						else
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects a number")
						end

					elseif (whichType == "string") then
						rest = tostring(rest)
						if (rest) then
							_detalhes [command] = rest
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to " .. rest)
						else
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects a string")
						end

					elseif (whichType == "boolean") then
						if (rest == "true") then
							_detalhes [command] = true
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to true")

						elseif (rest == "false") then
							_detalhes [command] = false
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to false")

						else
							print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects true or false")
						end
					end

				else
					local value = _detalhes [command]
					if (type(value) == "boolean") then
						value = value and "true" or "false"
					end
					print(Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' current value is: " .. value)
				end

				return
			end

		end

		print("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_SHOW"] .. " " .. Loc ["STRING_SLASH_HIDE"] .. " " .. Loc ["STRING_SLASH_TOGGLE"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_SHOWHIDETOGGLE_DESC"])
		print("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_RESET"] .. "|r: " .. Loc ["STRING_SLASH_RESET_DESC"])
		print("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_OPTIONS"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_OPTIONS_DESC"])
		print("|cffffaeae/details|r |cffffff33" .. "API" .. "|r: " .. Loc ["STRING_SLASH_API_DESC"])
		print("|cffffaeae/details|r |cffffff33" .. "me" .. "|r: open the player breakdown for you.") --localize-me
		print("|cffffaeae/details|r |cffffff33" .. "spells" .. "|r: list of spells already saw.") --localize-me

		print("|cFFFFFF00DETAILS! VERSION|r:|cFFFFAA00" .. " " .. Details.GetVersionString())
		print("|cffffaeae/details|r |cffffff33" .. "version" .. "|r: copy version.")

	end
end

function Details.RefreshUserList (ignoreIfHidden)

	if (ignoreIfHidden and DetailsUserPanel and not DetailsUserPanel:IsShown()) then
		return
	end

	local newList = DetailsFramework.table.copy({}, _detalhes.users or {})

	table.sort (newList, function(t1, t2)
		return t1[3] > t2[3]
	end)

	--search for people that didn't answered
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local playerName = UnitName ("raid" .. i)
			local foundPlayer

			for o = 1, #newList do
				if (newList[o][1]:find(playerName)) then
					foundPlayer = true
					break
				end
			end

			if (not foundPlayer) then
				tinsert(newList, {playerName, "--", "--"})
			end
		end
	end

	Details:UpdateUserPanel (newList)
end

function Details:UpdateUserPanel(usersTable)
	if (not Details.UserPanel) then
		local frameWidth, frameHeight = 470, 605
		DetailsUserPanel = DetailsFramework:CreateSimplePanel(UIParent)
		DetailsUserPanel:SetSize(frameWidth, frameHeight)
		DetailsUserPanel:SetTitle("Details! Version Check")
		DetailsUserPanel.Data = {}
		DetailsUserPanel:ClearAllPoints()
		DetailsUserPanel:SetPoint("left", UIParent, "left", 5, 100)
		DetailsUserPanel:Hide()

		DetailsFramework:ApplyStandardBackdrop(DetailsUserPanel)

		Details.UserPanel = DetailsUserPanel

		local scroll_width = frameWidth - 30
		local scroll_height = 605 - 60
		local scroll_lines = 26
		local scroll_line_height = 20

		local backdrop_color = {.2, .2, .2, 0.2}
		local backdrop_color_on_enter = {.8, .8, .8, 0.4}
		local backdrop_color_is_critical = {.4, .4, .2, 0.2}
		local backdrop_color_is_critical_on_enter = {1, 1, .8, 0.4}

		local y = -15
		local headerY = y - 15
		local scrollY = headerY - 20

		--header
		local headerTable = {
			{text = "User Name", width = 160},
			{text = "Realm", width = 130},
			{text = "Version", width = 140},
		}

		local headerOptions = {
			padding = 2,
		}

		DetailsUserPanel.Header = DetailsFramework:CreateHeader (DetailsUserPanel, headerTable, headerOptions)
		DetailsUserPanel.Header:SetPoint("topleft", DetailsUserPanel, "topleft", 5, headerY)

		local scroll_refresh = function(self, data, offset, total_lines)

			--store user names shown
			local userShown = {}
			local lineId = 1
			for i = 1, total_lines do
				local index = i + offset
				local userTable = data [index]

				if (userTable) then
					local userName, userRealm, userVersion = unpack(userTable)
					if (not userShown[userName]) then
						local line = self:GetLine(lineId)
						line.UserNameText.text = userName
						line.RealmText.text = userRealm
						line.VersionText.text = userVersion
						userShown[userName] = true
						lineId = lineId + 1
					end
				end
			end
		end

		local lineOnEnter = function(self)
			if (self.IsCritical) then
				self:SetBackdropColor(unpack(backdrop_color_is_critical_on_enter))
			else
				self:SetBackdropColor(unpack(backdrop_color_on_enter))
			end
		end

		local lineOnLeave = function(self)
			if (self.IsCritical) then
				self:SetBackdropColor(unpack(backdrop_color_is_critical))
			else
				self:SetBackdropColor(unpack(backdrop_color))
			end

			GameTooltip:Hide()
		end

		local scroll_createline = function(self, index)
			local line = CreateFrame("button", "$parentLine" .. index, self, "BackdropTemplate")
			line:SetPoint("topleft", self, "topleft", 3, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize(scroll_width - 2, scroll_line_height)

			line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor(unpack(backdrop_color))

			DetailsFramework:Mixin(line, DetailsFramework.HeaderFunctions)

			line:SetScript("OnEnter", lineOnEnter)
			line:SetScript("OnLeave", lineOnLeave)

			--username
			local userNameText = DetailsFramework:CreateLabel(line)

			--realm
			local realmText = DetailsFramework:CreateLabel(line)

			--version
			local versionText = DetailsFramework:CreateLabel(line)

			line:AddFrameToHeaderAlignment (userNameText)
			line:AddFrameToHeaderAlignment (realmText)
			line:AddFrameToHeaderAlignment (versionText)

			line:AlignWithHeader (DetailsUserPanel.Header, "left")

			line.UserNameText = userNameText
			line.RealmText = realmText
			line.VersionText = versionText

			return line
		end

		local usersScroll = DetailsFramework:CreateScrollBox (DetailsUserPanel, "$parentUsersScroll", scroll_refresh, DetailsUserPanel.Data, scroll_width, scroll_height, scroll_lines, scroll_line_height)
		DetailsFramework:ReskinSlider(usersScroll)
		usersScroll:SetPoint("topleft", DetailsUserPanel, "topleft", 5, scrollY)
		Details.UserPanel.ScrollBox = usersScroll

		--create lines
		for i = 1, scroll_lines do
			usersScroll:CreateLine (scroll_createline)
		end

		DetailsUserPanel:SetScript("OnShow", function()
		end)

		DetailsUserPanel:SetScript("OnHide", function()
		end)
	end

	Details.UserPanel.ScrollBox:SetData (usersTable)
	Details.UserPanel.ScrollBox:Refresh()
	DetailsUserPanel:Show()
end

function _detalhes:CreateListPanel()
	_detalhes.ListPanel = _detalhes.gump:NewPanel(UIParent, nil, "DetailsActorsFrame", nil, 300, 600)
	_detalhes.ListPanel:SetPoint("center", UIParent, "center", 300, 0)
	_detalhes.ListPanel.barras = {}

	tinsert(UISpecialFrames, "DetailsActorsFrame")
	_detalhes.ListPanel.close_with_right = true

	local container_barras_window = CreateFrame("ScrollFrame", "Details_ActorsBarrasScroll", _detalhes.ListPanel.widget)
	local container_barras = CreateFrame("Frame", "Details_ActorsBarras", container_barras_window)
	_detalhes.ListPanel.container = container_barras

	_detalhes.ListPanel.width = 500
	_detalhes.ListPanel.locked = false

	container_barras_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras_window:SetBackdropBorderColor(0, 0, 0, 0)

	container_barras:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras:SetBackdropColor(0, 0, 0, 0)

	container_barras:SetAllPoints(container_barras_window)
	container_barras:SetWidth(500)
	container_barras:SetHeight(150)
	container_barras:EnableMouse(true)
	container_barras:SetResizable(false)
	container_barras:SetMovable(true)

	container_barras_window:SetWidth(460)
	container_barras_window:SetHeight(550)
	container_barras_window:SetScrollChild(container_barras)
	container_barras_window:SetPoint("TOPLEFT", _detalhes.ListPanel.widget, "TOPLEFT", 21, -10)

	_detalhes.gump:NewScrollBar (container_barras_window, container_barras, -10, -17)
	container_barras_window.slider:Altura (560)
	container_barras_window.slider:cimaPoint (0, 1)
	container_barras_window.slider:baixoPoint (0, -3)
	container_barras_window.slider:SetFrameLevel(10)

	container_barras_window.ultimo = 0

	container_barras_window.gump = container_barras

	function _detalhes.ListPanel:add (text, index, filter)
		local row = _detalhes.ListPanel.barras [index]
		if (not row) then
			row = {text = _detalhes.ListPanel.container:CreateFontString(nil, "overlay", "GameFontNormal")}
			_detalhes.ListPanel.barras [index] = row
			row.text:SetPoint("topleft", _detalhes.ListPanel.container, "topleft", 0, -index * 15)
		end

		if (filter and text:find(filter)) then
			row.text:SetTextColor(1, 1, 0)
		else
			row.text:SetTextColor(1, 1, 1)
		end

		row.text:SetText(text)
	end

	return _detalhes.ListPanel
end


if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
	SLASH_KEYSTONE1 = "/keystone"
	SLASH_KEYSTONE2 = "/keys"
	SLASH_KEYSTONE3 = "/key"

	function SlashCmdList.KEYSTONE(msg, editbox)
		local openRaidLib = LibStub:GetLibrary("LibOpenRaid-1.0")
		if (openRaidLib) then
			if (not DetailsKeystoneInfoFrame) then

				local CONST_WINDOW_WIDTH = 614
				local CONST_WINDOW_HEIGHT = 700
				local CONST_SCROLL_LINE_HEIGHT = 20
				local CONST_SCROLL_LINE_AMOUNT = 30

				local backdrop_color = {.2, .2, .2, 0.2}
				local backdrop_color_on_enter = {.8, .8, .8, 0.4}

				local backdrop_color_inparty = {.5, .5, .8, 0.2}
				local backdrop_color_on_enter_inparty = {.5, .5, 1, 0.4}

				local backdrop_color_inguild = {.5, .8, .5, 0.2}
				local backdrop_color_on_enter_inguild = {.5, 1, .5, 0.4}

				local f = DetailsFramework:CreateSimplePanel(UIParent, CONST_WINDOW_WIDTH, CONST_WINDOW_HEIGHT, "M+ Keystones", "DetailsKeystoneInfoFrame")
				f:SetPoint("center", UIParent, "center", 0, 0)

				f:SetScript("OnMouseDown", nil) --disable framework native moving scripts
				f:SetScript("OnMouseUp", nil) --disable framework native moving scripts

				local LibWindow = LibStub("LibWindow-1.1")
				LibWindow.RegisterConfig(f, Details.keystone_frame.position)
				LibWindow.MakeDraggable(f)
				LibWindow.RestorePosition(f)

				local scaleBar = DetailsFramework:CreateScaleBar(f, Details.keystone_frame)
				f:SetScale(Details.keystone_frame.scale)

				local statusBar = DetailsFramework:CreateStatusBar(f)
				statusBar.text = statusBar:CreateFontString(nil, "overlay", "GameFontNormal")
				statusBar.text:SetPoint("left", statusBar, "left", 5, 0)
				statusBar.text:SetText("By Terciob | From Details! Damage Meter|Built with Details! Framework | Data from Open Raid Library")
				DetailsFramework:SetFontSize(statusBar.text, 11)
				DetailsFramework:SetFontColor(statusBar.text, "gray")

				--header
				local headerTable = {
					{text = "Class", width = 40, canSort = true, dataType = "number", order = "DESC", offset = 0},
					{text = "Player Name", width = 140, canSort = true, dataType = "string", order = "DESC", offset = 0},
					{text = "Level", width = 60, canSort = true, dataType = "number", order = "DESC", offset = 0, selected = true},
					{text = "Dungeon", width = 240, canSort = true, dataType = "string", order = "DESC", offset = 0},
					--{text = "Classic Dungeon", width = 120, canSort = true, dataType = "string", order = "DESC", offset = 0},
					{text = "Mythic+ Rating", width = 100, canSort = true, dataType = "number", order = "DESC", offset = 0},
				}

				local headerOnClickCallback = function(headerFrame, columnHeader)
					f.RefreshData()
				end

				local headerOptions = {
					padding = 1,
					header_backdrop_color = {.3, .3, .3, .8},
					header_backdrop_color_selected = {.5, .5, .5, 0.8},
					use_line_separators = true,
					line_separator_color = {.1, .1, .1, .5},
					line_separator_width = 1,
					line_separator_height = CONST_WINDOW_HEIGHT-30,
					line_separator_gap_align = true,
					header_click_callback = headerOnClickCallback,
				}

				f.Header = DetailsFramework:CreateHeader(f, headerTable, headerOptions, "DetailsKeystoneInfoFrameHeader")
				f.Header:SetPoint("topleft", f, "topleft", 5, -25)

				--scroll
				local refreshScrollLines = function(self, data, offset, totalLines)
					local RaiderIO = _G.RaiderIO
					local faction = UnitFactionGroup("player") --this can get problems with 9.2.5 cross faction raiding

					for i = 1, totalLines do
						local index = i + offset
						local unitTable = data[index]

						if (unitTable) then
							local line = self:GetLine(i)

							local unitName, level, mapID, challengeMapID, classID, rating, mythicPlusMapID, classIconTexture, iconTexCoords, mapName, inMyParty, isOnline, isGuildMember = unpack(unitTable)

							local rioProfile
							if (RaiderIO) then
								local playerName, playerRealm = unitName:match("(.+)%-(.+)")
								if (playerName and playerRealm) then
									rioProfile = RaiderIO.GetProfile(playerName, playerRealm, faction == "Horde" and 2 or 1)
									if (rioProfile) then
										rioProfile = rioProfile.mythicKeystoneProfile
									end
								else
									rioProfile = RaiderIO.GetProfile(unitName, GetRealmName(), faction == "Horde" and 2 or 1)
									if (rioProfile) then
										rioProfile = rioProfile.mythicKeystoneProfile
									end
								end
							end

							line.icon:SetTexture(classIconTexture)
							local L, R, T, B = unpack(iconTexCoords)
							line.icon:SetTexCoord(L+0.02, R-0.02, T+0.02, B-0.02)

							line.playerNameText.text = unitName
							line.keystoneLevelText.text = level
							line.dungeonNameText.text = mapName
							DetailsFramework:TruncateText(line.dungeonNameText, 240)
							line.classicDungeonNameText.text = mapNameChallenge or ""
							DetailsFramework:TruncateText(line.classicDungeonNameText, 120)
							line.inMyParty = inMyParty > 0
							line.inMyGuild = isGuildMember

							if (rioProfile) then
								local score = rioProfile.currentScore or 0
								local previousScore = rioProfile.previousScore or 0
								if (previousScore > score) then
									score = previousScore
									line.ratingText.text = rating .. " (" .. score .. ")"
								else
									line.ratingText.text = rating
								end
							else
								line.ratingText.text = rating
							end

							if (line.inMyParty) then
								line:SetBackdropColor(unpack(backdrop_color_inparty))
							elseif (isGuildMember) then
								line:SetBackdropColor(unpack(backdrop_color_inguild))
							else
								line:SetBackdropColor(unpack(backdrop_color))
							end

							if (isOnline) then
								line.playerNameText.textcolor = "white"
								line.keystoneLevelText.textcolor = "white"
								line.dungeonNameText.textcolor = "white"
								line.classicDungeonNameText.textcolor = "white"
								line.ratingText.textcolor = "white"
								line.icon:SetAlpha(1)
							else
								line.playerNameText.textcolor = "gray"
								line.keystoneLevelText.textcolor = "gray"
								line.dungeonNameText.textcolor = "gray"
								line.classicDungeonNameText.textcolor = "gray"
								line.ratingText.textcolor = "gray"
								line.icon:SetAlpha(.6)
							end
						end
					end
				end

				local scrollFrame = DetailsFramework:CreateScrollBox(f, "$parentScroll", refreshScrollLines, {}, CONST_WINDOW_WIDTH-10, CONST_WINDOW_HEIGHT-70, CONST_SCROLL_LINE_AMOUNT, CONST_SCROLL_LINE_HEIGHT)
				DetailsFramework:ReskinSlider(scrollFrame)
				scrollFrame:SetPoint("topleft", f.Header, "bottomleft", -1, -1)
				scrollFrame:SetPoint("topright", f.Header, "bottomright", 0, -1)

				local lineOnEnter = function(self)
					if (self.inMyParty) then
						self:SetBackdropColor(unpack(backdrop_color_on_enter_inparty))
					elseif (self.inMyGuild) then
						self:SetBackdropColor(unpack(backdrop_color_on_enter_inguild))
					else
						self:SetBackdropColor(unpack(backdrop_color_on_enter))
					end
				end
				local lineOnLeave = function(self)
					if (self.inMyParty) then
						self:SetBackdropColor(unpack(backdrop_color_inparty))
					elseif (self.inMyGuild) then
						self:SetBackdropColor(unpack(backdrop_color_inguild))
					else
						self:SetBackdropColor(unpack(backdrop_color))
					end
				end

				local createLineForScroll = function(self, index)
					local line = CreateFrame("frame", "$parentLine" .. index, self, "BackdropTemplate")
					line:SetPoint("topleft", self, "topleft", 1, -((index-1) * (CONST_SCROLL_LINE_HEIGHT + 1)) - 1)
					line:SetSize(scrollFrame:GetWidth() - 2, CONST_SCROLL_LINE_HEIGHT)

					line:SetBackdrop({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
					line:SetBackdropColor(unpack(backdrop_color))

					DetailsFramework:Mixin(line, DetailsFramework.HeaderFunctions)

					line:SetScript("OnEnter", lineOnEnter)
					line:SetScript("OnLeave", lineOnLeave)

					--class icon
					local icon = line:CreateTexture("$parentClassIcon", "overlay")
					icon:SetSize(CONST_SCROLL_LINE_HEIGHT - 2, CONST_SCROLL_LINE_HEIGHT - 2)

					--player name
					local playerNameText = DetailsFramework:CreateLabel(line)

					--keystone level
					local keystoneLevelText = DetailsFramework:CreateLabel(line)

					--dungeon name
					local dungeonNameText = DetailsFramework:CreateLabel(line)

					--classic dungeon name
					local classicDungeonNameText = DetailsFramework:CreateLabel(line)

					--player rating
					local ratingText = DetailsFramework:CreateLabel(line)

					line.icon = icon
					line.playerNameText = playerNameText
					line.keystoneLevelText = keystoneLevelText
					line.dungeonNameText = dungeonNameText
					line.classicDungeonNameText = classicDungeonNameText
					line.ratingText = ratingText

					line:AddFrameToHeaderAlignment(icon)
					line:AddFrameToHeaderAlignment(playerNameText)
					line:AddFrameToHeaderAlignment(keystoneLevelText)
					line:AddFrameToHeaderAlignment(dungeonNameText)
					--line:AddFrameToHeaderAlignment(classicDungeonNameText)
					line:AddFrameToHeaderAlignment(ratingText)

					line:AlignWithHeader(f.Header, "left")
					return line
				end

				--create lines
				for i = 1, CONST_SCROLL_LINE_AMOUNT do
					scrollFrame:CreateLine(createLineForScroll)
				end

				function f.RefreshData()
					local newData = {}
					newData.offlineGuildPlayers = {}
					local keystoneData = openRaidLib.GetAllKeystonesInfo()

					local guildUsers = {}
					local totalMembers, onlineMembers, onlineAndMobileMembers = GetNumGuildMembers()
					local realmName = GetRealmName()
					--create a string to use into the gsub call when removing the realm name from the player name, by default all player names returned from GetGuildRosterInfo() has PlayerName-RealmName format
					local realmNameGsub = "%-" .. realmName
					local guildName = GetGuildInfo("player")

					if (guildName) then
						for i = 1, totalMembers do
							local fullName, rank, rankIndex, level, class, zone, note, officernote, online, isAway, classFileName, achievementPoints, achievementRank, isMobile, canSoR, repStanding, guid = GetGuildRosterInfo(i)
							if (fullName) then
								fullName = fullName:gsub(realmNameGsub, "")
								if (online) then
									guildUsers[fullName] = true
								end
							else
								break
							end
						end
					end

					if (keystoneData) then
						local unitsAdded = {}
						local isOnline = true

						for unitName, keystoneInfo in pairs(keystoneData) do
							local classId = keystoneInfo.classID
							local classIcon = [[Interface\GLUES\CHARACTERCREATE\UI-CharacterCreate-Classes]]
							local coords = CLASS_ICON_TCOORDS
							local _, class = GetClassInfo(classId)

							local mapName = C_ChallengeMode.GetMapUIInfo(keystoneInfo.mythicPlusMapID) or ""

							--local mapInfoChallenge = C_Map.GetMapInfo(keystoneInfo.challengeMapID)
							--local mapNameChallenge = mapInfoChallenge and mapInfoChallenge.name or ""

							local isInMyParty = UnitInParty(unitName) and (string.byte(unitName, 1) + string.byte(unitName, 2)) or 0
							local isGuildMember = guildName and guildUsers[unitName] and true

							if (keystoneInfo.level > 0 or keystoneInfo.rating > 0) then
								local keystoneTable = {
									unitName,
									keystoneInfo.level,
									keystoneInfo.mapID,
									keystoneInfo.challengeMapID,
									keystoneInfo.classID,
									keystoneInfo.rating,
									keystoneInfo.mythicPlusMapID,
									classIcon,
									coords[class],
									mapName, --10
									isInMyParty,
									isOnline, --is false when the unit is from the cache
									isGuildMember, --is a guild member
									--mapNameChallenge,
								}

								newData[#newData+1] = keystoneTable --this is the table added into the keystone cache
								unitsAdded[unitName] = true

								--is this unitName listed as a player in the player's guild?
								if (isGuildMember) then
									--store the player information into a cache
									keystoneTable.guild_name = guildName
									keystoneTable.date = time()
									Details.keystone_cache[unitName] = keystoneTable
								end
							end
						end

						local cutoffDate = time() - (86400 * 7) --7 days
						for unitName, keystoneTable in pairs(Details.keystone_cache) do
							--this unit in the cache isn't shown?
							if (not unitsAdded[unitName] and keystoneTable.guild_name == guildName and keystoneTable.date > cutoffDate) then
								if (keystoneTable[2] > 0 or keystoneTable[6] > 0) then
									keystoneTable[12] = false --isOnline
									newData[#newData+1] = keystoneTable
									unitsAdded[unitName] = true
								end
							end
						end
					end

					--get which column is currently selected and the sort order
					local columnIndex, order = f.Header:GetSelectedColumn()
					local sortByIndex = 2

					--sort by player class
					if (columnIndex == 1) then
						sortByIndex = 5
					--sort by player name
					elseif (columnIndex == 2) then
						sortByIndex = 1
					--sort by keystone level
					elseif (columnIndex == 3) then
						sortByIndex = 2
					--sort by dungeon name
					elseif (columnIndex == 4) then
						sortByIndex = 3
					--sort by classic dungeon name
					elseif (columnIndex == 5) then
						sortByIndex = 4
					--sort by mythic+ ranting
					elseif (columnIndex == 6) then
						sortByIndex = 6
					end

					if (order == "DESC") then
						table.sort(newData, function(t1, t2) return t1[sortByIndex] > t2[sortByIndex] end)
					else
						table.sort(newData, function(t1, t2) return t1[sortByIndex] < t2[sortByIndex] end)
					end

					--remove offline guild players from the list
					for i = #newData, 1, -1 do
						local keystoneTable = newData[i]
						if (not keystoneTable[12]) then
							tremove(newData, i)
							newData.offlineGuildPlayers[#newData.offlineGuildPlayers+1] = keystoneTable
						end
					end

					newData.offlineGuildPlayers = DetailsFramework.table.reverse(newData.offlineGuildPlayers)

					--put players in the group at the top of the list
					if (IsInGroup() and not IsInRaid()) then
						local playersInTheParty = {}
						for i = #newData, 1, -1 do
							local keystoneTable = newData[i]
							if (keystoneTable[11] > 0) then
								playersInTheParty[#playersInTheParty+1] = keystoneTable
								tremove(newData, i)
							end
						end

						if (#playersInTheParty > 0) then
							table.sort(playersInTheParty, function(t1, t2) return t1[11] > t2[11] end)
							for i = 1, #playersInTheParty do
								local keystoneTable = playersInTheParty[i]
								tinsert(newData, 1, keystoneTable)
							end
						end
					end

					--reinsert offline guild players into the data
					local offlinePlayers = newData.offlineGuildPlayers
					for i = 1, #offlinePlayers do
						local keystoneTable = offlinePlayers[i]
						newData[#newData+1] = keystoneTable
					end

					scrollFrame:SetData(newData)
					scrollFrame:Refresh()
				end

				function f.OnKeystoneUpdate(unitId, keystoneInfo, allKeystonesInfo)
					if (f:IsShown()) then
						f.RefreshData()
					end
				end

				f:SetScript("OnHide", function()
					openRaidLib.UnregisterCallback(DetailsKeystoneInfoFrame, "KeystoneUpdate", "OnKeystoneUpdate")
				end)
			end

			--call an update on the guild roster
			if (C_GuildInfo and C_GuildInfo.GuildRoster) then
				C_GuildInfo.GuildRoster()
			end

			--show the frame
			DetailsKeystoneInfoFrame:Show()

			openRaidLib.RegisterCallback(DetailsKeystoneInfoFrame, "KeystoneUpdate", "OnKeystoneUpdate")

			openRaidLib.WipeKeystoneData()

			if (IsInRaid()) then
				openRaidLib.RequestKeystoneDataFromRaid()
			elseif (IsInGroup()) then
				openRaidLib.RequestKeystoneDataFromParty()
			end

			openRaidLib.RequestKeystoneDataFromGuild()

			DetailsKeystoneInfoFrame.RefreshData()
		end
	end
end
