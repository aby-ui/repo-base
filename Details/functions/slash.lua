

local _detalhes	= 	_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local CreateFrame = CreateFrame
local pairs = pairs 
local UIParent = UIParent
local UnitGUID = UnitGUID 
local tonumber= tonumber 
local LoggingCombat = LoggingCombat

SLASH_DETAILS1, SLASH_DETAILS2, SLASH_DETAILS3 = "/details", "/dt", "/de"

function SlashCmdList.DETAILS (msg, editbox)

	local command, rest = msg:match("^(%S*)%s*(.-)$")
	command = string.lower (command)
	
	if (command == Loc ["STRING_SLASH_WIPE"] or command == "wipe") then
	
	elseif (command == "api") then
		_detalhes.OpenAPI()
		
		
	
	elseif (command == Loc ["STRING_SLASH_NEW"] or command == "new") then
		_detalhes:CriarInstancia (nil, true)
		
	elseif (command == Loc ["STRING_SLASH_HISTORY"] or command == "history" or command == "score" or command == "rank" or command == "ranking" or command == "statistics" or command == "stats") then
		_detalhes:OpenRaidHistoryWindow()
	
	elseif (command == Loc ["STRING_SLASH_TOGGLE"] or command == "toggle") then
		
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			_detalhes:ToggleWindow (instance)
		else
			_detalhes:ToggleWindows()
		end
		
	elseif (command == Loc ["STRING_SLASH_HIDE"] or command == Loc ["STRING_SLASH_HIDE_ALIAS1"] or command == "hide") then
	
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance (instance)
			if (not this_instance) then
				return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
			end
			if (this_instance:IsEnabled() and this_instance.baseframe) then
				this_instance:ShutDown()
			end
		else
			_detalhes:ShutDownAllInstances()
		end
	
	elseif (command == "softhide") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat (true)
				end
			end
		end
	
	elseif (command == "softshow") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					instance:SetWindowAlphaForCombat (false)
				end
			end
		end
	
	elseif (command == "softtoggle") then
		for instanceID, instance in _detalhes:ListInstances() do
			if (instance:IsEnabled()) then
				if (instance.hide_in_combat_type > 1) then
					if (instance.baseframe:GetAlpha() > 0.1) then
						--show
						instance:SetWindowAlphaForCombat (true)
					else
						--hide
						instance:SetWindowAlphaForCombat (false)
					end
				end
			end
		end
	
	elseif (command == Loc ["STRING_SLASH_SHOW"] or command == Loc ["STRING_SLASH_SHOW_ALIAS1"] or command == "show") then
	
		_detalhes.LastShowCommand = GetTime()
		local instance = rest:match ("^(%S*)%s*(.-)$")
		instance = tonumber (instance)
		if (instance) then
			local this_instance = _detalhes:GetInstance (instance)
			if (not this_instance) then
				return _detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
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
		
		print (Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREOFF"])
	
	elseif (command == Loc ["STRING_SLASH_ENABLE"] or command == "enable") then
	
		_detalhes:CaptureSet (true, "damage", true)
		_detalhes:CaptureSet (true, "heal", true)
		_detalhes:CaptureSet (true, "energy", true)
		_detalhes:CaptureSet (true, "miscdata", true)
		_detalhes:CaptureSet (true, "aura", true)
		_detalhes:CaptureSet (true, "spellcast", true)
		
		print (Loc ["STRING_DETAILS1"] .. Loc ["STRING_SLASH_CAPTUREON"])
	
	elseif (command == Loc ["STRING_SLASH_OPTIONS"] or command == "options" or command == "config") then
	
		if (rest and tonumber (rest)) then
			local instanceN = tonumber (rest)
			if (instanceN > 0 and instanceN <= #_detalhes.tabela_instancias) then
				local instance = _detalhes:GetInstance (instanceN)
				_detalhes:OpenOptionsWindow (instance)
			end
		else
			local lower_instance = _detalhes:GetLowerInstanceNumber()
			if (not lower_instance) then
				local instance = _detalhes:GetInstance (1)
				_detalhes.CriarInstancia (_, _, 1)
				_detalhes:OpenOptionsWindow (instance)
			else
				_detalhes:OpenOptionsWindow (_detalhes:GetInstance (lower_instance))
			end
			
		end

	elseif (command == Loc ["STRING_SLASH_WORLDBOSS"] or command == "worldboss") then
		
		local questIds = {{"Tarlna the Ageless", 81535}, {"Drov the Ruiner ", 87437}, {"Rukhmar", 87493}}
		for _, _table in pairs (questIds) do 
			print (format ("%s: \124cff%s\124r", _table [1], IsQuestFlaggedCompleted (_table [2]) and "ff0000"..Loc ["STRING_KILLED"] or "00ff00"..Loc ["STRING_ALIVE"]))
		end
		
	elseif (command == Loc ["STRING_SLASH_CHANGES"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS1"] or command == Loc ["STRING_SLASH_CHANGES_ALIAS2"] or command == "news" or command == "updates") then
		_detalhes:OpenNewsWindow()
	
	elseif (command == "discord") then
		_detalhes:CopyPaste ("https://discord.gg/AGSzAZX")
	
	
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
				state ["Point" .. i] = {window1.baseframe:GetPoint (i)}
			end
			
			local parent = window1.baseframe:GetParent()
			
			state ["ParentInfo"] = {
				Alpha = parent:GetAlpha(),
				IsShown = parent:IsShown(),
				NumPoints = parent:GetNumPoints(),
			}
			
			Details:Dump (state)
		else
			Details:Msg ("Window 1 not found.")
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
				return _detalhes:Msg ("Profile Not Found.")
			end
			
			if (not _detalhes:ApplyProfile (rest)) then
				return
			end
			
			_detalhes:Msg (Loc ["STRING_OPTIONS_PROFILE_LOADED"], rest)
			if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
				_G.DetailsOptionsWindow:Hide()
				GameCooltip:Close()
			end
		else
			_detalhes:Msg ("/details profile <profile name>")
		end
	
-------- debug ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	
	elseif (msg == "exitlog") then
	
		local exitlog = _detalhes_global.exit_log
		local exiterrors = _detalhes_global.exit_errors
		
		print ("EXIT LOG:")
		for index, text in ipairs (exitlog) do
			print (text)
		end
		print ("ERRORS:")
		if (exiterrors) then
			for index, text in ipairs (exiterrors) do
				print (text)
			end
		else
			print ("|cFF00FF00No error occured!|r")
		end
	
	elseif (msg == "tr") then
		
		local f = CreateFrame ("frame", nil, UIParent)
		f:SetSize (300, 300)
		f:SetPoint ("center")
		
--		/run TTT:SetTexture ("Interface\\1024.tga")
		local texture = f:CreateTexture ("TTT", "background")
		texture:SetAllPoints()
		texture:SetTexture ("Interface\\1023.tga")
		
		local A = DetailsFramework:CreateAnimationHub (texture)
		
		local b = DetailsFramework:CreateAnimation (A, "ROTATION", 1, 40, 360)
		b:SetTarget (texture)
		A:Play()
		
		C_Timer.NewTicker (1, function()
			texture:SetTexCoord (math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random(), math.random())
		end)
		
	
	elseif (msg == "realmsync") then
		
		_detalhes.realm_sync = not _detalhes.realm_sync
		_detalhes:Msg ("Realm Sync: ", _detalhes.realm_sync and "Enabled" or "Disabled")
		
		if (not _detalhes.realm_sync) then
			LeaveChannelByName ("Details")
		else
			_detalhes:CheckChatOnLeaveGroup()
		end

	elseif (msg == "load") then
		
		print (DetailsDataStorage)
		
		local loaded, reason = LoadAddOn ("Details_DataStorage")
		print (loaded, reason, DetailsDataStorage)
		
	
	elseif (msg == "owner2") then
	
		local tip = CreateFrame('GameTooltip', 'GuardianOwnerTooltip', nil, 'GameTooltipTemplate')
		function GetGuardianOwner(guid)
			tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
			tip:SetHyperlink('unit:' .. guid or '')
			local text = GuardianOwnerTooltipTextLeft2
			--return strmatch(text and text:GetText() or '', "^([^%s']+)'")
			return text:GetText()
		end
	
		print (GetGuardianOwner(UnitGUID ("target")))
	
	elseif (msg == "chat") then
	
	
	elseif (msg == "chaticon") then
		_detalhes:Msg ("|TInterface\\AddOns\\Details\\images\\icones_barra:" .. 14 .. ":" .. 14 .. ":0:0:256:32:0:32:0:32|tteste")
	
	elseif (msg == "align") then
		local c = RightChatPanel
		local w,h = c:GetSize()
		print (w,h)
		
		local instance1 = _detalhes.tabela_instancias [1]
		local instance2 = _detalhes.tabela_instancias [2]
		
		instance1.baseframe:ClearAllPoints()
		instance2.baseframe:ClearAllPoints()

		instance1.baseframe:SetSize (w/2 - 4, h-20-21-8)
		instance2.baseframe:SetSize (w/2 - 4, h-20-21-8)
		
		instance1.baseframe:SetPoint ("bottomleft", RightChatDataPanel, "topleft", 1, 1)
		instance2.baseframe:SetPoint ("bottomright", RightChatToggleButton, "topright", -1, 1)
		
	elseif (msg == "addcombat") then
		
		local combat = _detalhes.combate:NovaTabela (true, _detalhes.tabela_overall, 1)
		local self = combat[1]:PegarCombatente (UnitGUID ("player"), UnitName ("player"), 1297, true)
		self.total = 100000
		self.total_without_pet = 100000
		
		if (not _detalhes.um___) then
			_detalhes.um___ = 0
			_detalhes.next_um = 3
		end
		
		local cima = true
		
		_detalhes.um___ = _detalhes.um___ + 1
		
		if (_detalhes.um___ == _detalhes.next_um) then
			_detalhes.next_um = _detalhes.next_um + 3
			cima = false
		end
		
		if (cima) then
			local frostbolt = self.spells:PegaHabilidade (116, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (44614, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (30455, true, "SPELL_DAMAGE")
			
			self.spells._ActorTable [116].total = 50000
			self.spells._ActorTable [44614].total = 25000
			self.spells._ActorTable [30455].total = 25000
		else
			local frostbolt = self.spells:PegaHabilidade (84721, true, "SPELL_DAMAGE")
			local frostfirebolt = self.spells:PegaHabilidade (113092, true, "SPELL_DAMAGE")
			local icelance = self.spells:PegaHabilidade (122, true, "SPELL_DAMAGE")
			
			self.spells._ActorTable [84721].total = 50000
			self.spells._ActorTable [113092].total = 25000
			self.spells._ActorTable [122].total = 25000
		end
		
		combat.start_time = GetTime()-30
		combat.end_time = GetTime()
		
		combat.totals_grupo [1] = 100000
		combat.totals [1] = 100000
	
		--combat.instance_type = "raid"
		--combat.is_trash = true
	
		_detalhes.tabela_vigente = combat
		
		_detalhes.tabela_historico:adicionar (combat)
	
		_detalhes:InstanciaCallFunction (_detalhes.gump.Fade, "in", nil, "barras")
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos) -- atualiza o instancia.showing para as novas tabelas criadas
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSoloMode_AfertReset) -- verifica se precisa zerar as tabela da janela solo mode
		_detalhes:InstanciaCallFunction (_detalhes.ResetaGump) --_detalhes:ResetaGump ("de todas as instancias")
		_detalhes:RefreshMainWindow (-1, true) --atualiza todas as instancias
		
		

	elseif (msg == "pets") then
		local f = _detalhes:CreateListPanel()
		
		local i = 1
		for k, v in pairs (_detalhes.tabela_pets.pets) do
			if (v[6] == "Guardian of Ancient Kings") then
				_detalhes.ListPanel:add ( k.. ": " ..  v[1] .. " | " .. v[2] .. " | " .. v[3] .. " | " .. v[6], i)
				i = i + 1
			end
		end
		
		f:Show()
		
	elseif (msg == "savepets") then
		
		_detalhes.tabela_vigente.saved_pets = {}
		
		for k, v in pairs (_detalhes.tabela_pets.pets) do
			_detalhes.tabela_vigente.saved_pets [k] = {v[1], v[2], v[3]}
		end
		
		_detalhes:Msg ("pet table has been saved on current combat.")

	elseif (msg == "move") then
	
		print ("moving...")
		
		local instance = _detalhes.tabela_instancias [1]
		instance.baseframe:ClearAllPoints()
		--instance.baseframe:SetPoint ("CENTER", UIParent, "CENTER", 300, 100)
		instance.baseframe:SetPoint ("left", DetailsWelcomeWindow, "right", 10, 0)
	
	elseif (msg == "model") then
		local frame = CreateFrame ("PlayerModel");
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
		print ("GetTime()", GetTime())
		print ("time()", time())

	elseif (msg == "copy") then
		_G.DetailsCopy:Show()
		_G.DetailsCopy.MyObject.text:HighlightText()
		_G.DetailsCopy.MyObject.text:SetFocus()
	
	elseif (msg == "garbage") then
		local a = {}
		for i = 1, 10000 do 
			a [i] = {math.random (50000)}
		end
		table.wipe (a)
	
	elseif (msg == "unitname") then
	
		local nome, realm = UnitName ("target")
		if (realm) then
			nome = nome.."-"..realm
		end
		print (nome, realm)
	
	elseif (msg == "raid") then
	
		local player, realm = "Ditador", "Azralon"
	
		local actorName
		if (realm ~= GetRealmName()) then
			actorName = player.."-"..realm
		else
			actorName = player
		end
		
		print (actorName)
	
		local guid = _detalhes:FindGUIDFromName ("Ditador")
		print (guid)
		
		for i = 1, GetNumGroupMembers()-1, 1 do 
			local name, realm = UnitName ("party"..i)
			print (name, " -- ", realm)
		end

	elseif (msg == "cacheparser") then
		_detalhes:PrintParserCacheIndexes()
	elseif (msg == "parsercache") then
		_detalhes:PrintParserCacheIndexes()
	
	elseif (msg == "captures") then
		for k, v in pairs (_detalhes.capture_real) do 
			print ("real -",k,":",v)
		end
		for k, v in pairs (_detalhes.capture_current) do 
			print ("current -",k,":",v)
		end
	
	elseif (msg == "slider") then
		
		local f = CreateFrame ("frame", "TESTEDESCROLL", UIParent)
		f:SetPoint ("center", UIParent, "center", 200, -2)
		f:SetWidth (300)
		f:SetHeight (150)
		f:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		f:SetBackdropColor (0, 0, 0, 1)
		f:EnableMouseWheel (true)
		
		local rows = {}
		for i = 1, 7 do 
			local row = CreateFrame ("frame", nil, UIParent)
			row:SetPoint ("topleft", f, "topleft", 10, -(i-1)*21)
			row:SetWidth (200)
			row:SetHeight (20)
			row:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16, insets = {left = 0, right = 0, top = 0, bottom = 0}})
			local t = row:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			t:SetPoint ("left", row, "left")
			row.text = t
			rows [#rows+1] = row
		end
		
		local data = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
		
		
	
	elseif (msg == "bcollor") then
	
		--local instancia = _detalhes.tabela_instancias [1]
		_detalhes.ResetButton.Middle:SetVertexColor (1, 1, 0, 1)
		
		--print (_detalhes.ResetButton:GetHighlightTexture())
		
		local t = _detalhes.ResetButton:GetHighlightTexture()
		t:SetVertexColor (0, 1, 0, 1)
		--print (t:GetObjectType())
		--_detalhes.ResetButton:SetHighlightTexture (t)
		_detalhes.ResetButton:SetNormalTexture (t)
		
		print ("backdrop", _detalhes.ResetButton:GetBackdrop())
		
		_detalhes.ResetButton:SetBackdropColor (0, 0, 1, 1)
		
		--vardump (_detalhes.ResetButton)
	
	elseif (command == "mini") then
		local instance = _detalhes.tabela_instancias [1]
		--vardump ()
		--print (instance, instance.StatusBar.options, instance.StatusBar.left)
		print (instance.StatusBar.options [instance.StatusBar.left.mainPlugin.real_name].textSize)
		print (instance.StatusBar.left.options.textSize)
	
	elseif (command == "owner") then
	
		local petname = rest:match ("^(%S*)%s*(.-)$")
		local petGUID = UnitGUID ("target")

		if (not _G.DetailsScanTooltip) then
			local scanTool = CreateFrame ("GameTooltip", "DetailsScanTooltip", nil, "GameTooltipTemplate")
			scanTool:SetOwner (WorldFrame, "ANCHOR_NONE")
		end
		
		function getPetOwner (petName)
			local scanTool = _G.DetailsScanTooltip
			local scanText = _G ["DetailsScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>
			
			scanTool:ClearLines()
			
			print (petName)
			scanTool:SetUnit (petName)
			
			local ownerText = scanText:GetText()
			if (not ownerText) then 
				return nil 
			end
			local owner, _ = string.split ("'", ownerText)

			return owner -- This is the pet's owner
		end
		
		--print (getPetOwner (petname))
		print (getPetOwner (petGUID))

	
	elseif (command == "buffsof") then
		
		local playername, segment = rest:match("^(%S*)%s*(.-)$")
		segment = tonumber (segment or 0)
		print ("dumping buffs of ", playername, segment)
		
		local c = _detalhes:GetCombat ("current")
		if (c) then
		
			local playerActor
		
			if (segment and segment ~= 0) then
				local c = _detalhes:GetCombat (segment)
				playerActor = c (4, playername)
				print ("using segment", segment, c, "player actor:", playerActor)
			else
				playerActor = c (4, playername)
			end
			
			print ("actor table: ", playerActor)
			
			if (not playerActor) then
				print ("actor table not found")
				return
			end
			
			if (playerActor and playerActor.buff_uptime_spells and playerActor.buff_uptime_spells._ActorTable) then
				for spellid, spellTable in pairs (playerActor.buff_uptime_spells._ActorTable) do 
					local spellname = GetSpellInfo (spellid)
					if (spellname) then
						print (spellid, spellname, spellTable.uptime)
					end
				end
			end
		end
	
	elseif (msg == "teste") then
		
		local a, b = _detalhes:GetEncounterEnd (1098, 3)
		print (a, unpack (b))
		
	elseif (msg == "yesno") then
		--_detalhes:Show()
	
	elseif (msg == "imageedit") then
		
		local callback = function (width, height, overlayColor, alpha, texCoords)
			print (width, height, alpha)
			print ("overlay: ", unpack (overlayColor))
			print ("crop: ", unpack (texCoords))
		end
		
		_detalhes.gump:ImageEditor (callback, "Interface\\TALENTFRAME\\bg-paladin-holy", nil, {1, 1, 1, 1}) -- {0.25, 0.25, 0.25, 0.25}

	elseif (msg == "chat") then
	
		local name, fontSize, r, g, b, a, shown, locked = FCF_GetChatWindowInfo (1);
		print (name,"|",fontSize,"|", r,"|", g,"|", b,"|", a,"|", shown,"|", locked)
		
		--local fontFile, unused, fontFlags = self:GetFont();
		--self:SetFont(fontFile, fontSize, fontFlags);
	
	elseif (msg == "error") then
		a = nil + 1
		
	--> debug
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
		print (Loc ["STRING_DETAILS1"] .. "capture has been reseted.")

	--> debug
	elseif (command == "barra") then 
	
		local whichRowLine = rest and tonumber (rest) or 1
	
		local instancia = _detalhes.tabela_instancias [1]
		local barra = instancia.barras [whichRowLine]
		
		for i = 1, barra:GetNumPoints() do 
			local point, relativeTo, relativePoint, xOfs, yOfs = barra:GetPoint (i)
			print (point, relativeTo, relativePoint, xOfs, yOfs)
		end
	
	elseif (msg == "opened") then 
		print ("Instances opened: " .. _detalhes.opened_windows)
	
	--> debug, get a guid of something
	elseif (command == "backdrop") then --> localize-me
		local f = MacroFrameTextBackground
		local backdrop = MacroFrameTextBackground:GetBackdrop()
		
		vardump (backdrop)
		vardump (backdrop.insets)
		
		print ("bgcolor:",f:GetBackdropColor())
		print ("bordercolor",f:GetBackdropBorderColor())
	
	elseif (command == "myguid") then --> localize-me
	
		local g = UnitGUID ("player")
		print (type (g))
		print (g)
		print (string.len (g))
		local serial = g:sub (12, 18)
		serial = tonumber ("0x"..serial)
		print (serial)
		
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
					
						Details.id_frame = CreateFrame ("Frame", "DetailsID", UIParent, "BackdropTemplate")
						Details.id_frame:SetHeight(14)
						Details.id_frame:SetWidth(120)
						Details.id_frame:SetPoint ("center", UIParent, "center")
						Details.id_frame:SetBackdrop(backdrop)
						
						tinsert(UISpecialFrames, "DetailsID")
						
						Details.id_frame.texto = CreateFrame ("editbox", nil, Details.id_frame, "BackdropTemplate")
						Details.id_frame.texto:SetPoint ("topleft", Details.id_frame, "topleft")
						Details.id_frame.texto:SetAutoFocus(false)
						Details.id_frame.texto:SetFontObject (GameFontHighlightSmall)
						Details.id_frame.texto:SetHeight(14)
						Details.id_frame.texto:SetWidth(120)
						Details.id_frame.texto:SetJustifyH("CENTER")
						Details.id_frame.texto:EnableMouse(true)
						Details.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
						Details.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
						Details.id_frame.texto:SetText ("")
						Details.id_frame.texto.perdeu_foco = nil
						
						Details.id_frame.texto:SetScript ("OnEnterPressed", function ()
							Details.id_frame.texto:ClearFocus()
							Details.id_frame:Hide()
						end)
						
						Details.id_frame.texto:SetScript ("OnEscapePressed", function()
							Details.id_frame.texto:ClearFocus()
							Details.id_frame:Hide()
						end)
						
					end
					
					C_Timer.After(0.1, function()
						Details.id_frame:Show()
						Details.id_frame.texto:SetFocus()
						Details.id_frame.texto:SetText ("" .. npcId)
						Details.id_frame.texto:HighlightText()
					end)
				end
			end
		end


	elseif (command == "guid") then
	
		local pass_guid = rest:match("^(%S*)%s*(.-)$")
	
		if (not _detalhes.id_frame) then 
		
			local backdrop = {
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			}
		
			_detalhes.id_frame = CreateFrame ("Frame", "DetailsID", UIParent)
			_detalhes.id_frame:SetHeight(14)
			_detalhes.id_frame:SetWidth(120)
			_detalhes.id_frame:SetPoint ("center", UIParent, "center")
			_detalhes.id_frame:SetBackdrop(backdrop)
			
			tinsert (UISpecialFrames, "DetailsID")
			
			_detalhes.id_frame.texto = CreateFrame ("editbox", nil, _detalhes.id_frame)
			_detalhes.id_frame.texto:SetPoint ("topleft", _detalhes.id_frame, "topleft")
			_detalhes.id_frame.texto:SetAutoFocus(false)
			_detalhes.id_frame.texto:SetFontObject (GameFontHighlightSmall)			
			_detalhes.id_frame.texto:SetHeight(14)
			_detalhes.id_frame.texto:SetWidth(120)
			_detalhes.id_frame.texto:SetJustifyH("CENTER")
			_detalhes.id_frame.texto:EnableMouse(true)
			_detalhes.id_frame.texto:SetBackdrop(ManualBackdrop)
			_detalhes.id_frame.texto:SetBackdropColor(0, 0, 0, 0.5)
			_detalhes.id_frame.texto:SetBackdropBorderColor(0.3, 0.3, 0.30, 0.80)
			_detalhes.id_frame.texto:SetText ("") --localize-me
			_detalhes.id_frame.texto.perdeu_foco = nil
			
			_detalhes.id_frame.texto:SetScript ("OnEnterPressed", function () 
				_detalhes.id_frame.texto:ClearFocus()
				_detalhes.id_frame:Hide() 
			end)
			
			_detalhes.id_frame.texto:SetScript ("OnEscapePressed", function() 
				_detalhes.id_frame.texto:ClearFocus()
				_detalhes.id_frame:Hide() 
			end)
			
		end
		
		_detalhes.id_frame:Show()
		_detalhes.id_frame.texto:SetFocus()
		
		if (pass_guid == "-") then
			local guid = UnitGUID ("target")
			if (guid) then 
				local g = _detalhes:GetNpcIdFromGuid (guid)
				_detalhes.id_frame.texto:SetText ("" .. g)
				_detalhes.id_frame.texto:HighlightText()
			end
		
		else
			print (pass_guid.. " -> " .. tonumber (pass_guid:sub(6, 10), 16))
			_detalhes.id_frame.texto:SetText (""..tonumber (pass_guid:sub(6, 10), 16))
			_detalhes.id_frame.texto:HighlightText()
		end
		
	--> debug
	
	elseif (msg == "auras") then
		if (IsInRaid()) then
			for raidIndex = 1, GetNumGroupMembers() do 
				for buffIndex = 1, 41 do
					local name, _, _, _, _, _, _, unitCaster, _, _, spellid  = UnitAura ("raid"..raidIndex, buffIndex, nil, "HELPFUL")
					print (name, unitCaster, "==", "raid"..raidIndex)
					if (name and unitCaster == "raid"..raidIndex) then
						
						local playerName, realmName = UnitName ("raid"..raidIndex)
						if (realmName and realmName ~= "") then
							playerName = playerName .. "-" .. realmName
						end
						
						_detalhes.parser:add_buff_uptime (nil, GetTime(), UnitGUID ("raid"..raidIndex), playerName, 0x00000417, UnitGUID ("raid"..raidIndex), playerName, 0x00000417, spellid, name, in_or_out)
						
					else
						--break
					end
				end
			end
		end
		
	elseif (command == "profile") then
	
		local profile = rest:match("^(%S*)%s*(.-)$")
		
		print ("Force apply profile: ", profile)
		
		_detalhes:ApplyProfile (profile, false)
	
	elseif (msg == "users" or msg == "version" or msg == "versioncheck") then
		_detalhes.users = {{UnitName("player"), GetRealmName(), (_detalhes.userversion or "") .. " (" .. _detalhes.APIVersion .. ")"}}
		_detalhes.sent_highfive = GetTime()
		_detalhes:SendRaidData (_detalhes.network.ids.HIGHFIVE_REQUEST)

		print (Loc ["STRING_DETAILS1"] .. "highfive sent, HI!")
	
		C_Timer.After (0.3, function()
			Details.RefreshUserList()
		end)
		C_Timer.After (0.6, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (0.9, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (1.3, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (1.6, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (3, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (4, function()
			Details.RefreshUserList (true)
		end)	
		C_Timer.After (5, function()
			Details.RefreshUserList (true)
		end)
		C_Timer.After (8, function()
			Details.RefreshUserList (true)
		end)
	
	elseif (command == "names") then
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end
		
		local container = _detalhes.tabela_vigente [t]._NameIndexTable
		
		local i = 0
		for name, _ in pairs (container) do 
			i = i + 1
			f:add (name, i)
		end
		
		print (i, "names found.")
	
		f:Show()
		
	elseif (command == "actors") then
	
		local t, filter = rest:match("^(%S*)%s*(.-)$")

		t = tonumber (t)
		if (not t) then
			return print ("not T found.")
		end

		local f = _detalhes.ListPanel
		if (not f) then
			f = _detalhes:CreateListPanel()
		end
		
		local container = _detalhes.tabela_vigente [t]._ActorTable
		print (#container, "actors found.")
		for index, actor in ipairs (container) do 
			f:add (actor.nome, index, filter)
		end
	
		f:Show()
	
	--> debug
	elseif (msg == "save") then
		print ("running... this is a debug command, details wont work until next /reload.")
		_detalhes:PrepareTablesForSave()
	
	elseif (msg == "buffs") then
		for i = 1, 40 do
			local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellid = UnitBuff ("player", i)
			if (not name) then
				return
			end
			print (spellid, name)
		end
	
	elseif (msg == "id") then
		local one, two = rest:match("^(%S*)%s*(.-)$")
		if (one ~= "") then
			print("NPC ID:", one:sub(-12, -9), 16)
			print("NPC ID:", tonumber((one):sub(-12, -9), 16))
		else
			print("NPC ID:", tonumber((UnitGUID("target")):sub(-12, -9), 16) )
		end

	--> debug
	elseif (command == "debug") then
		if (_detalhes.debug) then
			_detalhes.debug = false
			print (Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned off.")
			return
		else
			_detalhes.debug = true
			print (Loc ["STRING_DETAILS1"] .. "diagnostic mode has been turned on.")
			
			if (rest and rest ~= "") then
				if (rest == "-clear") then
					_detalhes_global.debug_chr_log = ""
					print (Loc ["STRING_DETAILS1"] .. "log for characters has been wiped.")
					return
				end
				_detalhes.debug_chr = rest
				_detalhes_global.debug_chr_log = _detalhes_global.debug_chr_log or ""
				print (Loc ["STRING_DETAILS1"] .. "diagnostic for character " .. rest .. " turned on.")
				return
			end
			
			local current_combat = _detalhes.tabela_vigente
			
			if (not _detalhes.DebugWindow) then
				_detalhes.DebugWindow = _detalhes.gump:CreateSimplePanel (UIParent, 800, 600, "Details! Debug", "DetailsDebugPanel")
				local TextBox = _detalhes.gump:NewSpecialLuaEditorEntry (_detalhes.DebugWindow, 760, 560, "text", "$parentTextEntry", true)
				TextBox:SetPoint ("center", _detalhes.DebugWindow, "center", 0, -10)
				TextBox:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				TextBox:SetBackdropColor (0, 0, 0, 0.9)
				TextBox:SetBackdropBorderColor (0, 0, 0, 1)
				_detalhes.DebugWindow.TextBox = TextBox
			end
			
			local text = [[
Hello World!
Details! Damage Meter Debug
Release Version: @VERSION Core Version: @CORE

Update Thread Status:
Tick Rate: @TICKRATE
Threat Health: @TICKHEALTH
Last Tick: @TICKLAST
Next Tick In: @TICKNEXT

Current Combat Status:
ID: @COMBATID
Container Status: @COMBATCONTAINERS
Damage Container Actors: @COMBATDAMAGEACTORS actors found

Parser Status:
Parser Health: @PARSERHEALTH
Parser Capture Status: @PARSERCAPTURE

Lower Instance Status (window 1):
Is Shown: @INSTANCESHOWN
Segment Status: @INSTANCESEGMENT
Damage Update Status: @INSTANCEDAMAGESTATUS

]]
			
			text = text:gsub ([[@VERSION]], _detalhes.userversion)
			text = text:gsub ([[@CORE]], _detalhes.realversion)

			text = text:gsub ([[@TICKRATE]], _detalhes.update_speed)
			text = text:gsub ([[@TICKHEALTH]], _detalhes:TimeLeft (_detalhes.atualizador) ~= 0 and "|cFF22FF22good|r" or "|cFFFF2222bad|r")
			text = text:gsub ([[@TICKLAST]], _detalhes.LastUpdateTick .. " (" .. _detalhes._tempo - _detalhes.LastUpdateTick .. " seconds ago)")
			text = text:gsub ([[@TICKNEXT]], _detalhes:TimeLeft (_detalhes.atualizador))
			
			text = text:gsub ([[@COMBATID]], _detalhes.combat_id)
			text = text:gsub ([[@COMBATCONTAINERS]], _detalhes.tabela_vigente[1] and _detalhes.tabela_vigente[2] and _detalhes.tabela_vigente[3] and _detalhes.tabela_vigente[4] and "|cFF22FF22good|r" or "|cFFFF2222bad|r")
			text = text:gsub ([[@COMBATDAMAGEACTORS]], #_detalhes.tabela_vigente[1] and _detalhes.tabela_vigente[1]._ActorTable and #_detalhes.tabela_vigente[1]._ActorTable)
			
			text = text:gsub ([[@PARSERHEALTH]], _detalhes.parser_frame:GetScript ("OnEvent") == _detalhes.OnParserEvent and "|cFF22FF22good|r" or "|cFFFF2222bad|r")
			
			local captureStr = ""
			for _ , captureName in ipairs (_detalhes.capture_types) do
				if (_detalhes.capture_current [captureName]) then
					captureStr = captureStr .. " " .. captureName .. ": |cFF22FF22okay|r"
				else
					captureStr = captureStr .. " " .. captureName .. ": |cFFFF2222X|r"
				end
			end
			text = text:gsub ([[@PARSERCAPTURE]], captureStr)
			
			local instance = _detalhes:GetLowerInstanceNumber()
			if (instance) then
				instance = _detalhes:GetInstance (instance)
			end
			
			if (instance) then
				if (instance:IsEnabled()) then
					text = text:gsub ([[@INSTANCESHOWN]], "|cFF22FF22good|r")
				else
					text = text:gsub ([[@INSTANCESHOWN]], "|cFFFFFF22not visible|r")
				end
				
				text = text:gsub ([[@INSTANCESEGMENT]], (instance.showing == _detalhes.tabela_vigente and "|cFF22FF22good|r" or "|cFFFFFF22isn't the current combat object|r") .. (" window segment: " .. instance:GetSegment()))
				
				text = text:gsub ([[@INSTANCEDAMAGESTATUS]], (_detalhes._tempo - (_detalhes.LastFullDamageUpdate or 0)) < 3 and "|cFF22FF22good|r" or "|cFFFF2222last update registered is > than 3 seconds, is there actors to show?|r")
			else
				text = text:gsub ([[@INSTANCESHOWN]], "|cFFFFFF22not found|r")
				text = text:gsub ([[@INSTANCESEGMENT]], "|cFFFFFF22not found|r")
				text = text:gsub ([[@INSTANCEDAMAGESTATUS]], "|cFFFFFF22not found|r")
				
			end

			_detalhes.DebugWindow.TextBox:SetText (text)
			
			_detalhes.DebugWindow:Show()
		end
	
	--> debug combat log
	elseif (msg == "combatlog") then
		if (_detalhes.isLoggingCombat) then
			LoggingCombat (false)
			print ("Wow combatlog record turned OFF.")
			_detalhes.isLoggingCombat = nil
		else
			LoggingCombat (true)
			print ("Wow combatlog record turned ON.")
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
		   print ("Phase Changed!", event, module, key, text)
		  end
		end
	
	elseif (msg == "pos") then
		local x, y = GetPlayerMapPosition ("player")
		
		if (not DetailsPosBox) then
			_detalhes.gump:CreateTextEntry (UIParent, function()end, 200, 20, nil, "DetailsPosBox")
			DetailsPosBox:SetPoint ("center", UIParent, "center")
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
		for _, barra in ipairs (instancia.barras) do 
			local _, _, flags = barra.lineText1:GetFont()
			print ("outline:",flags)
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
					print (n, q)
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
							print ("Selling", itemName, itemType)
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
				print (name, encounterID, DetailsFramework.EncounterJournal.EJ_GetNumLoot())

				for o = 1, DetailsFramework.EncounterJournal.EJ_GetNumLoot() do
					local name, icon, slot, armorType, itemID, link, encounterID = DetailsFramework.EncounterJournal.EJ_GetLootInfoByIndex (o)
					r[slot] = r[slot] or {}
					tinsert (r[slot], {itemID, encounterID})
					total = total + 1
				end
			end
		end	
	
		print ("total loot", total)
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
		
		local ItemUpgradeInfo = LibStub ("LibItemUpgradeInfo-1.0")
		
		_detalhes:Msg ("======== Item Level Debug ========")
		
		for equip_id = 1, 17 do
			if (equip_id ~= 4) then --shirt slot
				local item = GetInventoryItemLink (unitid, equip_id)
				if (item) then
					local _, _, itemRarity, iLevel, _, _, _, _, equipSlot = GetItemInfo (item)
					if (iLevel) then
						if (ItemUpgradeInfo) then
							local ilvl = ItemUpgradeInfo:GetUpgradedItemLevel (item)
							item_level = item_level + (ilvl or iLevel)
							print (ilvl, item)
						else
							item_level = item_level + iLevel
							print (iLevel, item)
						end
						
						--> 16 = main hand 17 = off hand
						-->  if using a two-hand, ignore the off hand slot
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
		_detalhes:Msg ("gear score: " .. item_level, "| item amount:", item_amount, "| ilvl:", average)

		_detalhes.ilevel:CalcItemLevel ("player", UnitGUID("player"), true)
		
	elseif (msg == "score") then
		
		_detalhes:OpenRaidHistoryWindow ("Hellfire Citadel", 1800, 15, "DAMAGER", "Rock Lobster", 2, "Keyspell")
	
	elseif (msg == "bar") then
		local bar = _G.DetailsTestBar
		if (not bar) then
			bar = Details.gump:CreateBar (UIParent, nil, 600, 200, 100, nil, "DetailsTestBar")
			_G.DetailsTestBar = bar
			bar:SetPoint ("center", 0, 0)
			bar.RightTextIsTimer = true
			bar.BarIsInverse = true
		end
		
		bar.color = "HUNTER"
		
		local start = GetTime()-45
		local fim = GetTime()+5
		
		bar:SetTimer (start, fim)
		
		--C_Timer.After (5, function() bar:CancelTimerBar() end)
	
	
	elseif (msg == "q") then
	
		local myframe = TestFrame
		if (not myframe) then
			myframe = TestFrame or CreateFrame ("frame", "TestFrame", UIParent)
			myframe:SetPoint ("center", UIParent, "center")
			myframe:SetSize (300, 300)
			myframe.texture = myframe:CreateTexture (nil, "overlay")
			myframe.texture:SetAllPoints()
			myframe.texture:SetTexture ([[Interface\AddOns\WorldQuestTracker\media\icon_flag_common]])
		else
			if (myframe.texture:IsShown()) then
				myframe.texture:Hide()
			else
				print (myframe.texture:GetTexture())
				myframe.texture:Show()
				print (myframe.texture:GetTexture())
			end
		end
		
		
		
		if (true) then
			return
		end
	
		local y = -50
		local allspecs = {}
		
		for a, b in pairs (_detalhes.class_specs_coords) do
			tinsert (allspecs, a)
		end
		
		for i = 1, 10 do
	
			local a = CreateFrame ("statusbar", nil, UIParent)
			a:SetPoint ("topleft", UIParent, "topleft", i*32, y)
			a:SetSize (32, 32)
			a:SetMinMaxValues (0, 1)
			
			local texture = a:CreateTexture (nil, "overlay")
			texture:SetSize (32, 32)
			texture:SetPoint ("topleft")
			
			if (i%10 == 0) then
				y = y - 32
			end

--	/run for o=1,10 do local f=CreateFrame("frame");f:SetPoint("center");f:SetSize(300,300); local t=f:CreateTexture(nil,"overlay");t:SetAllPoints();f:SetScript("OnUpdate",function() t:SetTexture("Interface\\1024")end);end;
--	https://www.dropbox.com/s/ulyeqa2z0ummlu7/1024.tga?dl=0

			local time = 0
			a:SetScript ("OnUpdate", function (self, deltaTime)
				time = time + deltaTime
				
				--texture:SetSize (math.random (50, 300), math.random (50, 300))
				--local spec = allspecs [math.random (#allspecs)]
				texture:SetTexture ([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture ([[Interface\Store\Store-Splash]])
				--texture:SetTexture ([[Interface\AddOns\Details\images\options_window]])
				--texture:SetTexture ([[Interface\CHARACTERFRAME\Button_BloodPresence_DeathKnight]])
				--texture:SetTexCoord (unpack (_detalhes.class_specs_coords [spec]))
				
				--a:SetAlpha (abs (math.sin (time)))
				--a:SetValue (abs (math.sin (time)))
			end)
		end
	
	elseif (msg == "alert") then
		--local instancia = _detalhes.tabela_instancias [1]
		local f = function (a, b, c, d, e, f, g) print (a, b, c, d, e, f, g) end
		--instancia:InstanceAlert (Loc ["STRING_PLEASE_WAIT"], {[[Interface\COMMON\StreamCircle]], 22, 22, true}, 5, {f, 1, 2, 3, 4, 5})
	
		local lower_instance = _detalhes:GetLowerInstanceNumber()
		if (lower_instance) then
			local instance = _detalhes:GetInstance (lower_instance)
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
		local instance = _detalhes:GetInstance (lower_instance)
		
		instance:InstanceAlert ("Boss Defeated! Show Ranking", icon, 10, func, true)
	
	elseif (msg == "scroll" or msg == "scrolldamage" or msg == "scrolling") then
		Details:ScrollDamage()

	elseif (msg == "me" or msg == "ME" or msg == "Me" or msg == "mE") then
		local role = UnitGroupRolesAssigned("player")
		if (role == "HEALER") then
			Details:OpenPlayerDetails(2)
		else
			Details:OpenPlayerDetails(1)
		end

	elseif (msg == "spec") then
	
	local spec = DetailsFramework.GetSpecialization()
	if (spec) then
		local specID = DetailsFramework.GetSpecializationInfo (spec)
		if (specID and specID ~= 0) then
			print ("Current SpecID: ", specID)
		end
	end
	
	elseif (msg == "senditemlevel") then
		_detalhes:SendCharacterData()
		print ("Item level dispatched.")
	
	elseif (msg == "talents") then
		local talents = {}
		for i = 1, 7 do
			for o = 1, 3 do
				local talentID, name, texture, selected, available = GetTalentInfo (i, o, 1)
				if (selected) then
					tinsert (talents, talentID)
					break
				end
			end
		end
		
		print ("talentID", "name", "texture", "selected", "available", "spellID", "unknown", "row", "column", "unknown", "unknown")
		for i = 1, #talents do
			print (GetTalentInfoByID (talents [i]))
		end
	
	elseif (msg == "merge") then
		
		--> at this point, details! should not be in combat
		if (_detalhes.in_combat) then
			_detalhes:Msg ("already in combat, closing current segment.")
			_detalhes:SairDoCombate()
		end
		
		--> create a new combat to be the overall for the mythic run
		_detalhes:EntrarEmCombate()
		
		--> get the current combat just created and the table with all past segments
		local newCombat = _detalhes:GetCurrentCombat()
		local segmentHistory = _detalhes:GetCombatSegments()
		local totalTime = 0
		local startDate, endDate = "", ""
		local lastSegment
		local segmentsAdded = 0
		
		--> add all boss segments from this run to this new segment
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
		_detalhes:Msg ("done merging, segments: " .. segmentsAdded .. ", total time: " .. DetailsFramework:IntegerToTimer (totalTime))

		--[[ --mythic+ debug
		--> tag the segment as mythic overall segment
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
		
		--> set some data
		newCombat:SetStartTime (GetTime() - totalTime)
		newCombat:SetEndTime (GetTime())
		
		newCombat.data_inicio = startDate
		newCombat.data_fim = endDate
		
		--> immediatly finishes the segment just started
		_detalhes:SairDoCombate()
		
		--> cleanup the past segments table
		for i = 25, 1, -1 do
			local pastCombat = segmentHistory [i]
			if (pastCombat and pastCombat ~= newCombat) then
				wipe (pastCombat)
				segmentHistory [i] = nil
			end
		end
		
		--> clear memory
		collectgarbage()		

		_detalhes:InstanciaCallFunction (_detalhes.gump.Fade, "in", nil, "barras")
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSegmentos)
		_detalhes:InstanciaCallFunction (_detalhes.AtualizaSoloMode_AfertReset)
		_detalhes:InstanciaCallFunction (_detalhes.ResetaGump)
		_detalhes:RefreshMainWindow (-1, true)
	
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
			--> get the deepest section in the hierarchy
			local ID = tremove (nextID)
			local sectionInfo = C_EncounterJournal.GetSectionInfo (ID)
			
			if (sectionInfo) then
				tinsert (result, sectionInfo)
				
				if (sectionInfo.spellID and type (sectionInfo.spellID) == "number" and sectionInfo.spellID ~= 0) then
					tinsert (spellIDs, sectionInfo.spellID)
				end
				
				local nextChild, nextSibling = sectionInfo.firstChildSectionID, sectionInfo.siblingSectionID
				if (nextSibling) then
					tinsert (nextID, nextSibling)
				end
				if (nextChild) then
					tinsert (nextID, nextChild)
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
			for key, _ in pairs (skin) do
				local value = instance1[key]
				if (value) then
					exportedValues[key] = value
				end
			end
			Details:Dump(exportedValues)
		end

	elseif (msg == "coach") then
		if (not UnitIsGroupLeader("player")) then
			Details:Msg("you aren't the raid leader.")
			return
		end

		Details.coach.enabled = not Details.coach.enabled

		if (Details.coach.enabled) then
			Details:Msg("coach enabled, good luck!")
			Details:Msg("[raid leader] stay outside the raid.")
			Details:Msg("[assistants] at least one player inside the raid need to have assistant.")
			Details:Msg("[players] have an updated version of Details!.")
			Details.Coach.Server.EnableCoach()
			
		else
			Details:Msg("coach disabled.")
			Details.Coach.Disable()
		end

	elseif (msg == "9") then
		print ("skin:", Details.skin)
		print ("current profile:", _detalhes:GetCurrentProfileName())
		print ("always use profile:", _detalhes.always_use_profile)
		print ("profile name:", _detalhes.always_use_profile_name)
		print ("version:", _detalhes.build_counter >= _detalhes.alpha_build_counter and _detalhes.build_counter or _detalhes.alpha_build_counter)

	elseif (msg == "record") then
			
			
			_detalhes.ScheduleLoadStorage()
			_detalhes.TellDamageRecord = C_Timer.NewTimer (0.6, _detalhes.PrintEncounterRecord)
			_detalhes.TellDamageRecord.Boss = 2032
			_detalhes.TellDamageRecord.Diff = 16
	
	elseif (msg == "recordtest") then	

		local f = DetailsRecordFrameAnimation 
		if (not f) then
			f = CreateFrame ("frame", "DetailsRecordFrameAnimation", UIParent)
			
			--estrela no inicio dando um giro
			--Interface\Cooldown\star4
			--efeito de batida?
			--Interface\Artifacts\ArtifactAnim2
			local animationHub = DetailsFramework:CreateAnimationHub (f, function() f:Show() end)

			DetailsFramework:CreateAnimation (animationHub, "Scale", 1, .10, .9, .9, 1.1, 1.1)
			DetailsFramework:CreateAnimation (animationHub, "Scale", 2, .10, 1.2, 1.2, 1, 1)
		end
	
	--BFA BETA
	elseif (msg == "update") then
		_detalhes:CopyPaste ([[https://www.wowinterface.com/downloads/info23056-DetailsDamageMeter8.07.3.5.html]])
	
	
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
		
		--> copy from table2 to table1 overwriting values
		function f.copy (t1, t2)
			if (t1.Timer) then
				t1, t2 = t1.t1, t1.t2
			end
			for key, value in pairs (t2) do 
				if (not ignoredKeys [key] and type (value) ~= "function") then
					if (key == "targets") then
						t1 [key] = {}
					
					elseif (type (value) == "table") then
						t1 [key] = t1 [key] or {}
						
						--print (key, value)
						--local d = C_Timer.NewTimer (1, f.copy)
						--d.t1 = t1 [key]
						--d.t2 = t2 [key]
						--d.Timer = true
						
						keys [key] = true
						
						f.copy (t1 [key], t2 [key])
					else
						t1 [key] = value
					end
				end
			end
			return t1
		end
		
		--local copySegment = f.copy ({}, _detalhes.tabela_vigente)
		local copySegment = f.copy ({}, _detalhes.tabela_historico.tabelas [2])
		
		--the segment received is raw and does not have metatables, need to refresh them
		local zipData = Details:CompressData (copySegment, "print")
		
		--print (zipData)
		--Details:Dump (keys)
		Details:Dump ({zipData})
	else
		
		--if (_detalhes.opened_windows < 1) then
		--	_detalhes:CriarInstancia()
		--end
		
		if (command) then
			--> check if the line passed is a parameters in the default profile
			if (_detalhes.default_profile [command]) then
				if (rest and (rest ~= "" and rest ~= " ")) then
					local whichType = type (_detalhes.default_profile [command])
					
					--> attempt to cast the passed value to the same value as the type in the profile
					if (whichType == "number") then
						rest = tonumber (rest)
						if (rest) then
							_detalhes [command] = rest
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to " .. rest)
						else
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects a number")
						end
						
					elseif (whichType == "string") then
						rest = tostring (rest)
						if (rest) then
							_detalhes [command] = rest
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to " .. rest)
						else
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects a string")
						end
						
					elseif (whichType == "boolean") then
						if (rest == "true") then
							_detalhes [command] = true
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to true")
							
						elseif (rest == "false") then
							_detalhes [command] = false
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' set to false")
							
						else
							print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' expects true or false")
						end
					end
				
				else
					local value = _detalhes [command]
					if (type (value) == "boolean") then
						value = value and "true" or "false"
					end
					print (Loc ["STRING_DETAILS1"] .. "config '" .. command .. "' current value is: " .. value)
				end
				
				return
			end
			
		end
		
		print (" ")
		--local v = _detalhes.game_version .. "." .. (_detalhes.build_counter >= _detalhes.alpha_build_counter and _detalhes.build_counter or _detalhes.alpha_build_counter)
		--print (Loc ["STRING_DETAILS1"] .. "" .. v .. " [|cFFFFFF00CORE: " .. _detalhes.realversion .. "|r] " ..  Loc ["STRING_COMMAND_LIST"] .. ":")
		
		--print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_NEW"] .. "|r: " .. Loc ["STRING_SLASH_NEW_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_SHOW"] .. " " .. Loc ["STRING_SLASH_HIDE"] .. " " .. Loc ["STRING_SLASH_TOGGLE"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_SHOWHIDETOGGLE_DESC"])
		--print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_ENABLE"] .. " " .. Loc ["STRING_SLASH_DISABLE"] .. "|r: " .. Loc ["STRING_SLASH_CAPTURE_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_RESET"] .. "|r: " .. Loc ["STRING_SLASH_RESET_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_OPTIONS"] .. "|r|cfffcffb0 <" .. Loc ["STRING_WINDOW_NUMBER"] .. ">|r: " .. Loc ["STRING_SLASH_OPTIONS_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. "API" .. "|r: " .. Loc ["STRING_SLASH_API_DESC"])
		--print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_CHANGES"] .. "|r: " .. Loc ["STRING_SLASH_CHANGES_DESC"])
		--print ("|cffffaeae/details|r |cffffff33" .. Loc ["STRING_SLASH_WIPECONFIG"] .. "|r: " .. Loc ["STRING_SLASH_WIPECONFIG_DESC"])
		print ("|cffffaeae/details|r |cffffff33" .. "me" .. "|r: open the player breakdown for you.") --localize-me
		print ("|cffffaeae/details|r |cffffff33" .. "spells" .. "|r: list of spells already saw.") --localize-me
		
		
		--print ("|cffffaeae/details " .. Loc ["STRING_SLASH_WORLDBOSS"] .. "|r: " .. Loc ["STRING_SLASH_WORLDBOSS_DESC"])
		print (" ")

		local v = _detalhes.game_version .. "." .. (_detalhes.build_counter >= _detalhes.alpha_build_counter and _detalhes.build_counter or _detalhes.alpha_build_counter)
		print (Loc ["STRING_DETAILS1"] .. "|cFFFFFF00DETAILS! VERSION|r: |cFFFFAA00R" .. (_detalhes.build_counter >= _detalhes.alpha_build_counter and _detalhes.build_counter or _detalhes.alpha_build_counter))
		print (Loc ["STRING_DETAILS1"] .. "|cFFFFFF00GAME VERSION|r: |cFFFFAA00" .. _detalhes.game_version)

	end
end

function Details.RefreshUserList (ignoreIfHidden)

	if (ignoreIfHidden and DetailsUserPanel and not DetailsUserPanel:IsShown()) then
		return
	end

	local newList = DetailsFramework.table.copy ({}, _detalhes.users or {})

	table.sort (newList, function(t1, t2)
		return t1[3] > t2[3]
	end)

	--search for people that didn't answered
	if (IsInRaid()) then
		for i = 1, GetNumGroupMembers() do
			local playerName = UnitName ("raid" .. i)
			local foundPlayer

			for o = 1, #newList do
				if (newList[o][1]:find (playerName)) then
					foundPlayer = true
					break
				end
			end

			if (not foundPlayer) then
				tinsert (newList, {playerName, "--", "--"})
			end
		end
	end

	Details:UpdateUserPanel (newList)
end

function Details:UpdateUserPanel (usersTable)

	if (not Details.UserPanel) then
		DetailsUserPanel = DetailsFramework:CreateSimplePanel (UIParent)
		DetailsUserPanel:SetSize (707, 505)
		DetailsUserPanel:SetTitle ("Details! Version Check")
		DetailsUserPanel.Data = {}
		DetailsUserPanel:ClearAllPoints()
		DetailsUserPanel:SetPoint ("left", UIParent, "left", 10, 0)
		DetailsUserPanel:Hide()

		Details.UserPanel = DetailsUserPanel
		
		local scroll_width = 675
		local scroll_height = 450
		local scroll_lines = 21
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
			{text = "User Name", width = 200},
			{text = "Realm", width = 200},
			{text = "Version", width = 200},
		}

		local headerOptions = {
			padding = 2,
		}
		
		DetailsUserPanel.Header = DetailsFramework:CreateHeader (DetailsUserPanel, headerTable, headerOptions)
		DetailsUserPanel.Header:SetPoint ("topleft", DetailsUserPanel, "topleft", 5, headerY)
		
		local scroll_refresh = function (self, data, offset, total_lines)
			for i = 1, total_lines do
				local index = i + offset
				local userTable = data [index]
				
				if (userTable) then
				
					local line = self:GetLine (i)
					local userName, userRealm, userVersion = unpack (userTable)

					line.UserNameText.text = userName
					line.RealmText.text = userRealm
					line.VersionText.text = userVersion
				end
			end
		end		
		
		local lineOnEnter = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor (unpack (backdrop_color_is_critical_on_enter))
			else
				self:SetBackdropColor (unpack (backdrop_color_on_enter))
			end
		end
		
		local lineOnLeave = function (self)
			if (self.IsCritical) then
				self:SetBackdropColor (unpack (backdrop_color_is_critical))
			else
				self:SetBackdropColor (unpack (backdrop_color))
			end
			
			GameTooltip:Hide()
		end
		
		local scroll_createline = function (self, index)
			local line = CreateFrame ("button", "$parentLine" .. index, self, "BackdropTemplate")
			line:SetPoint ("topleft", self, "topleft", 3, -((index-1)*(scroll_line_height+1)) - 1)
			line:SetSize (scroll_width - 2, scroll_line_height)
			
			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor (unpack (backdrop_color))
			
			DetailsFramework:Mixin (line, DetailsFramework.HeaderFunctions)
			
			line:SetScript ("OnEnter", lineOnEnter)
			line:SetScript ("OnLeave", lineOnLeave)
			
			--username
			local userNameText = DetailsFramework:CreateLabel (line)
			
			--realm
			local realmText = DetailsFramework:CreateLabel (line)
			
			--version
			local versionText = DetailsFramework:CreateLabel (line)
			
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
		DetailsFramework:ReskinSlider (usersScroll)
		usersScroll:SetPoint ("topleft", DetailsUserPanel, "topleft", 5, scrollY)
		Details.UserPanel.ScrollBox = usersScroll
		
		--create lines
		for i = 1, scroll_lines do 
			usersScroll:CreateLine (scroll_createline)
		end
		
		DetailsUserPanel:SetScript ("OnShow", function()
		end)

		DetailsUserPanel:SetScript ("OnHide", function()
		end)
	end

	Details.UserPanel.ScrollBox:SetData (usersTable)
	Details.UserPanel.ScrollBox:Refresh()
	DetailsUserPanel:Show()
end

function _detalhes:CreateListPanel()
	_detalhes.ListPanel = _detalhes.gump:NewPanel (UIParent, nil, "DetailsActorsFrame", nil, 300, 600)
	_detalhes.ListPanel:SetPoint ("center", UIParent, "center", 300, 0)
	_detalhes.ListPanel.barras = {}
	
	tinsert (UISpecialFrames, "DetailsActorsFrame")
	_detalhes.ListPanel.close_with_right = true

	local container_barras_window = CreateFrame ("ScrollFrame", "Details_ActorsBarrasScroll", _detalhes.ListPanel.widget) 
	local container_barras = CreateFrame ("Frame", "Details_ActorsBarras", container_barras_window)
	_detalhes.ListPanel.container = container_barras

	_detalhes.ListPanel.width = 500
	_detalhes.ListPanel.locked = false
	
	container_barras_window:SetBackdrop({
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-gold-Border", tile = true, tileSize = 16, edgeSize = 5,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})
	container_barras_window:SetBackdropBorderColor (0, 0, 0, 0)
	
	container_barras:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 0, bottom = 1},})		
	container_barras:SetBackdropColor (0, 0, 0, 0)

	container_barras:SetAllPoints (container_barras_window)
	container_barras:SetWidth (500)
	container_barras:SetHeight (150)
	container_barras:EnableMouse (true)
	container_barras:SetResizable (false)
	container_barras:SetMovable (true)
	
	container_barras_window:SetWidth (460)
	container_barras_window:SetHeight (550)
	container_barras_window:SetScrollChild (container_barras)
	container_barras_window:SetPoint ("TOPLEFT", _detalhes.ListPanel.widget, "TOPLEFT", 21, -10)

	_detalhes.gump:NewScrollBar (container_barras_window, container_barras, -10, -17)
	container_barras_window.slider:Altura (560)
	container_barras_window.slider:cimaPoint (0, 1)
	container_barras_window.slider:baixoPoint (0, -3)
	container_barras_window.slider:SetFrameLevel (10)

	container_barras_window.ultimo = 0
	
	container_barras_window.gump = container_barras
	
	function _detalhes.ListPanel:add (text, index, filter)
		local row = _detalhes.ListPanel.barras [index]
		if (not row) then
			row = {text = _detalhes.ListPanel.container:CreateFontString (nil, "overlay", "GameFontNormal")}
			_detalhes.ListPanel.barras [index] = row
			row.text:SetPoint ("topleft", _detalhes.ListPanel.container, "topleft", 0, -index * 15)
		end
		
		if (filter and text:find (filter)) then
			row.text:SetTextColor (1, 1, 0)
		else
			row.text:SetTextColor (1, 1, 1)
		end
		
		row.text:SetText (text)
	end	
	
	return _detalhes.ListPanel
end
