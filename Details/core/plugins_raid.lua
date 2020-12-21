	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _math_floor = math.floor --lua local
	local _cstr = string.format --lua local
	local _UnitClass = UnitClass
	
	local gump = _detalhes.gump --details local
	
	local _GetSpellInfo = _detalhes.getspellinfo --details api
	
	local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local modo_raid = _detalhes._detalhes_props["MODO_RAID"]
	local modo_alone = _detalhes._detalhes_props["MODO_ALONE"]
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> internal functions	
	
	function _detalhes.RaidTables:DisableRaidMode (instance)
		--free
		self:SetInUse (instance.current_raid_plugin, nil)
		--hide
		local current_plugin_object = _detalhes:GetPlugin (instance.current_raid_plugin)
		if (current_plugin_object) then
			current_plugin_object.Frame:Hide()
		end
		instance.current_raid_plugin = nil
	end
	
	function _detalhes:RaidPluginInstalled (plugin_name)
		if (self.waiting_raid_plugin) then
			--print (self.meu_id, 2, self.last_raid_plugin, " == ", plugin_name)
			if (self.last_raid_plugin == plugin_name) then
				if (self.waiting_pid) then
					self:CancelTimer (self.waiting_pid, true)
				end
				self:CancelWaitForPlugin()
				_detalhes.RaidTables:EnableRaidMode (self, plugin_name)
			end
		end
	end
	
	function _detalhes.RaidTables:EnableRaidMode (instance, plugin_name, from_cooltip, from_mode_menu)

		--> check if came from cooltip
		if (from_cooltip) then
			self = _detalhes.RaidTables
			instance = plugin_name
			plugin_name = from_cooltip
		end
	
		--> set the mode
		if (instance.modo == modo_alone) then
			instance:SoloMode (false)
		end
		instance.modo = modo_raid
		
		--> hide rows, scrollbar
		gump:Fade (instance, 1, nil, "barras")
		if (instance.rolagem) then
			instance:EsconderScrollBar (true) --> hida a scrollbar
		end
		_detalhes:ResetaGump (instance)
		instance:RefreshMainWindow (true)
		
		--> get the plugin name
		
		--if the desired plugin isn't passed, try to get the latest used.
		if (not plugin_name) then
			local last_plugin_used = instance.last_raid_plugin
			if (last_plugin_used) then
				if (self:IsAvailable (last_plugin_used, instance)) then
					plugin_name = last_plugin_used
				end
			end
		end

		--if we still doesnt have a name, try to get the first available
		if (not plugin_name) then
			local available = self:GetAvailablePlugins()
			if (#available == 0) then
				if (not instance.wait_for_plugin_created or not instance.WaitForPlugin) then
					instance:CreateWaitForPlugin()
				end
				return instance:WaitForPlugin()
			end
			
			plugin_name = available [1] [4]
		end

		--last check if the name is okey
		if (self:IsAvailable (plugin_name, instance)) then
			self:switch (nil, plugin_name, instance)
			
			if (from_mode_menu) then
				--refresh
				instance.baseframe.cabecalho.modo_selecao:GetScript ("OnEnter")(instance.baseframe.cabecalho.modo_selecao, _, true)
			end
		else
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end

	end

	function _detalhes.RaidTables:GetAvailablePlugins()
		local available = {}
		for index, plugin in ipairs (self.Menu) do
			if (not self.PluginsInUse [ plugin [4] ] and plugin [3].__enabled) then -- 3 = plugin object 4 = absolute name
				tinsert (available, plugin)
			end
		end
		return available
	end
	
	function _detalhes.RaidTables:IsAvailable (plugin_name, instance)
		--check if is installed
		if (not self.NameTable [plugin_name]) then
			return false
		end

		--check if is enabled
		if (not self.NameTable [plugin_name].__enabled) then
			return false
		end
		
		--check if is available
		local in_use = self.PluginsInUse [ plugin_name ]
		
		if (in_use and in_use ~= instance:GetId()) then
			return false
		else
			return true
		end
	end
	
	function _detalhes.RaidTables:SetInUse (absolute_name, instance_number)
		if (absolute_name) then
			self.PluginsInUse [ absolute_name ] = instance_number
		end
	end

	----------------
	
	function _detalhes.RaidTables:switch (_, plugin_name, instance)
	
		local update_menu = false
		if (not self) then --came from cooltip
			self = _detalhes.RaidTables
			update_menu = true
		end
	
		--only hide the current plugin shown
		if (not plugin_name) then
			if (instance.current_raid_plugin) then
				--free
				self:SetInUse (instance.current_raid_plugin, nil)
				--hide
				local current_plugin_object = _detalhes:GetPlugin (instance.current_raid_plugin)
				if (current_plugin_object) then
					current_plugin_object.Frame:Hide()
				end
				instance.current_raid_plugin = nil
			end
			return
		end
		
		--check if is realy available
		if (not self:IsAvailable (plugin_name, instance)) then
			instance.last_raid_plugin = plugin_name
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end
		
		--hide current shown plugin
		if (instance.current_raid_plugin) then
			--free
			self:SetInUse (instance.current_raid_plugin, nil)
			--hide
			local current_plugin_object = _detalhes:GetPlugin (instance.current_raid_plugin)
			if (current_plugin_object) then
				current_plugin_object.Frame:Hide()
			end
		end
		
		local plugin_object = _detalhes:GetPlugin (plugin_name)

		if (plugin_object and plugin_object.__enabled and plugin_object.Frame) then
			instance.last_raid_plugin = plugin_name
			instance.current_raid_plugin = plugin_name
			
			self:SetInUse (plugin_name, instance:GetId())
			plugin_object.instance_id = instance:GetId()
			plugin_object.Frame:SetPoint ("TOPLEFT", instance.bgframe)
			plugin_object.Frame:Show()
			instance:ChangeIcon (plugin_object.__icon)--; print (instance:GetId(),"icon",plugin_object.__icon)
			_detalhes:SendEvent ("DETAILS_INSTANCE_CHANGEATTRIBUTE", nil, instance, instance.atributo, instance.sub_atributo)
			
			if (update_menu) then
				GameCooltip:ExecFunc (instance.baseframe.cabecalho.atributo)
				--instance _detalhes.popup:ExecFunc (DeleteButton)
			end
		else
			if (not instance.wait_for_plugin) then
				instance:CreateWaitForPlugin()
			end
			return instance:WaitForPlugin()
		end

	end

	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> built in announcers
	
	function _detalhes:SendMsgToChannel (msg, channel, towho)
		if (channel == "RAID" or channel == "PARTY") then
			if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
				channel = "INSTANCE_CHAT"
			end
			SendChatMessage (msg, channel)
			
		elseif (channel == "BNET") then
		
			if (type (towho) == "number") then
				BNSendWhisper (towho, msg)
			
			elseif (type (towho) == "string") then
				--local BnetFriends = BNGetNumFriends()
				--for i = 1, BnetFriends do 
				--	local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, broadcastTime, canSoR = BNGetFriendInfo (i)
				--	if ((presenceName == towho or toonName == towho) and isOnline) then
				--		BNSendWhisper (presenceID, msg)
				--		break
				--	end
				--end
			end
		
		elseif (channel == "CHANNEL") then
			SendChatMessage (msg, channel, nil, GetChannelName (towho))
		
		elseif (channel == "WHISPER") then
			SendChatMessage (msg, channel, nil, towho)
		
		elseif (channel == "PRINT") then
			print (msg)
		
		else --say channel?
			if (IsInInstance()) then --patch 80205 cannot use 'say' channel outside instances
				SendChatMessage (msg, channel)
			end
		
		--elseif (channel == "SAY" or channel == "YELL" or channel == "RAID_WARNING" or channel == "OFFICER" or channel == "GUILD" or channel == "EMOTE") then
		
		end
	end
	
	--/run local s="teste {spell}"; s=s:gsub("{spell}", "tercio");print(s)
	
	function _detalhes:interrupt_announcer (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname, spelltype, extraSpellID, extraSpellName, extraSchool)
	
		-- add novo canal Self.
		-- no canal self ele mostra todos os interrupts al�m do meu.
		
		-- add canal self pras mortes tbm?
	
		local channel = _detalhes.announce_interrupts.channel
	
		if (channel ~= "PRINT" and who_name == _detalhes.playername) then
			
			local next = _detalhes.announce_interrupts.next
			local custom = _detalhes.announce_interrupts.custom
			
			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink (extraSpellID)
			else
				spellname = _GetSpellInfo (extraSpellID)
			end

			if (channel == "RAID") then
				local zone = _detalhes:GetZoneType()

				if (zone ~= "party" and zone ~= "raid") then
					return
				end
				
				if (zone == "raid") then
					channel = "RAID"
				elseif (zone == "party") then
					channel = "PARTY"
				end
				if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
					channel = "INSTANCE_CHAT"
				end
			end
			
			if (custom ~= "") then
				custom = custom:gsub ("{spell}", spellname)
				custom = custom:gsub ("{target}", alvo_name or "")
				custom = custom:gsub ("{next}", next)
				_detalhes:SendMsgToChannel (custom, channel, _detalhes.announce_interrupts.whisper)
			else
				local msg = _cstr (Loc ["STRING_OPTIONS_RT_INTERRUPT"], spellname)
				if (next ~= "") then
					msg = msg .. " " .. _cstr (Loc ["STRING_OPTIONS_RT_INTERRUPT_NEXT"], next)
				end
				
				_detalhes:SendMsgToChannel (msg, channel, _detalhes.announce_interrupts.whisper)
			end
			
		elseif (channel == "PRINT") then

			local custom = _detalhes.announce_interrupts.custom
			
			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink (extraSpellID)
			else
				spellname = _GetSpellInfo (extraSpellID)
			end

			if (custom ~= "") then
				custom = custom:gsub ("{spell}", spellname)
				custom = custom:gsub ("{next}", who_name)
				custom = custom:gsub ("{target}", alvo_name or "")
				_detalhes:SendMsgToChannel (custom, "PRINT")
			else
				local minute, second = _detalhes:GetCombat():GetFormatedCombatTime()
				
				local _, class = _UnitClass (who_name)
				local class_color = "|cFFFF3333"
				
				if (class) then
					local coords = CLASS_ICON_TCOORDS [class]
					class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:0:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS [class].colorStr
				end
				
				if (second < 10) then
					second = "0" .. second
				end
				local msg = "|cFFFFFF00[|r".. minute ..  ":" .. second .. "|cFFFFFF00]|r Interrupt: " .. spellname .. " (" .. class_color .. _detalhes:GetOnlyName (who_name) .. "|r)"
				
				_detalhes:SendMsgToChannel (msg, "PRINT")
			end
			
		end
	end
	
	local ignored_self_cooldowns = {
		[119582] = true, -- Purifying Brew
		[115308] = true, --Elusive Brew
		[115203 ] = true, --Fortifying Brew
	}
	
	function _detalhes:cooldown_announcer (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, spellid, spellname)
	
		local channel = _detalhes.announce_cooldowns.channel
	
		if (channel ~= "PRINT" and who_name == _detalhes.playername) then
	
			local ignored = _detalhes.announce_cooldowns.ignored_cooldowns
			if (ignored [spellid]) then
				return
			end

			if (channel == "WHISPER") then
				if (alvo_name == Loc ["STRING_RAID_WIDE"]) then
					channel = "RAID"
				end
			end
			
			if (channel == "RAID") then
				local zone = _detalhes:GetZoneType()

				if (zone ~= "party" and zone ~= "raid") then
					return
				end
				
				if (zone == "raid") then
					channel = "RAID"
				elseif (zone == "party") then
					channel = "PARTY"
				end
				if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
					channel = "INSTANCE_CHAT"
				end
			end

			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink (spellid)
			else
				spellname = _GetSpellInfo (spellid)
			end

			local custom = _detalhes.announce_cooldowns.custom
			
			if (custom ~= "") then
				custom = custom:gsub ("{spell}", spellname)
				custom = custom:gsub ("{target}", alvo_name or "")
				_detalhes:SendMsgToChannel (custom, channel, _detalhes.announce_interrupts.whisper)
			else
				local msg
				
				if (alvo_name == Loc ["STRING_RAID_WIDE"]) then
					msg = _cstr (Loc ["STRING_OPTIONS_RT_COOLDOWN2"], spellname)
				else
					msg = _cstr (Loc ["STRING_OPTIONS_RT_COOLDOWN1"], spellname, alvo_name)
				end

				_detalhes:SendMsgToChannel (msg, channel, _detalhes.announce_interrupts.whisper)
			end
			
		elseif (channel == "PRINT") then
			
			local ignored = _detalhes.announce_cooldowns.ignored_cooldowns
			if (ignored [spellid]) then
				return
			end

			if (ignored_self_cooldowns [spellid]) then
				return
			end
			
			if (who_name == alvo_name and who_name ~= _detalhes.playername) then
				return
			end
			
			local msg
			local minute, second = _detalhes:GetCombat():GetFormatedCombatTime()
			
			local _, class = _UnitClass (who_name)
			local class_color = "|cFFFFFFFF"
			
			local _, class2 = _UnitClass (alvo_name)
			local class_color2 = "|cFFFFFFFF"
			
			if (class) then
				local coords = CLASS_ICON_TCOORDS [class]
				class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:0:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS [class].colorStr
			end
			
			if (class2) then
				local coords = CLASS_ICON_TCOORDS [class2]
				class_color2 = " -> |TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:0:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS [class2].colorStr
				alvo_name = _detalhes:GetOnlyName (alvo_name)
			else
				alvo_name = ""
			end
			
			local spellname
			if (spellid > 10) then
				spellname = GetSpellLink (spellid)
			else
				spellname = _GetSpellInfo (spellid)
			end
			
			if (second < 10) then
				second = "0" .. second
			end
			msg = "|cFF8F8FFF[|r".. minute ..  ":" .. second .. "|cFF8F8FFF]|r Cooldown: " .. spellname .. " (" .. class_color .. _detalhes:GetOnlyName (who_name) .. "|r" .. class_color2 .. alvo_name .. "|r)"

			_detalhes:SendMsgToChannel (msg, "PRINT")
			
		end
	end
	
	function _detalhes:death_announcer (token, time, who_serial, who_name, who_flags, alvo_serial, alvo_name, alvo_flags, death_table, last_cooldown, death_at, max_health)

			local where = _detalhes.announce_deaths.where
			local zone = _detalhes:GetZoneType()
			local channel = ""
			
			if (where == 1) then
				if (zone ~= "party" and zone ~= "raid") then
					return
				end
				
				if (zone == "raid") then
					channel = "RAID"
				elseif (zone == "party") then
					channel = "PARTY"
				end
				if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
					channel = "INSTANCE_CHAT"
				end
				
			elseif (where == 2) then
				if (zone ~= "raid") then
					return
				end
				channel = "RAID"
				if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
					channel = "INSTANCE_CHAT"
				end
				
			elseif (where == 3) then
				if (zone ~= "party") then
					return
				end
				channel = "PARTY"
				if (GetNumGroupMembers (LE_PARTY_CATEGORY_INSTANCE) > 0) then
					channel = "INSTANCE_CHAT"
				end
				
			elseif (where == 4) then --> observer
				if (zone ~= "raid" and zone ~= "party") then
					return
				end
				channel = "PRINT"
			
			elseif (where == 5) then --> officers
				if (IsInGuild()) then
					channel = "OFFICER"
				end
			end
			
			local only_first = _detalhes.announce_deaths.only_first
			--_detalhes:GetCombat ("current"):GetDeaths() is the same thing, but, it's faster without using the API.
			if (zone == "raid" and not _detalhes.tabela_vigente.is_boss) then
				return
			end
			if (only_first > 0 and #_detalhes.tabela_vigente.last_events_tables > only_first) then
				return
			end
			
			alvo_name = _detalhes:GetOnlyName (alvo_name)
			
			local msg
			if (where == 4) then --> observer
				local _, class = _UnitClass (alvo_name)
				local class_color = "|cFFFFFFFF"
				
				if (class) then
					local coords = CLASS_ICON_TCOORDS [class]
					class_color = "|TInterface\\AddOns\\Details\\images\\classes_small_alpha:12:12:0:0:128:128:" .. coords[1]*128 .. ":" .. coords[2]*128 .. ":" .. coords[3]*128 .. ":" .. coords[4]*128 .. "|t |c" .. RAID_CLASS_COLORS [class].colorStr
				end
				msg = "Death: " .. class_color .. alvo_name .. "|r ->"
			else
				msg = _cstr (Loc ["STRING_OPTIONS_RT_DEATH_MSG"], alvo_name) .. ":"
			end
			
			local spells = ""
			death_table = death_table[1]
			local last = #death_table

			for i = 1, _detalhes.announce_deaths.last_hits do
				for o = last, 1, -1 do
					local this_death = death_table [o]
					if (type (this_death[1]) == "boolean" and this_death[1] and this_death[4]+5 > time) then
						local spelllink
						if (this_death [2] > 10) then
							spelllink = GetSpellLink (this_death [2])
						else
							spelllink = "[" .. _GetSpellInfo (this_death [2]) .. "]"
						end
						spells = spelllink .. ": " .. _detalhes:ToK2 (_math_floor (this_death [3])) .. " " .. spells
						last = o-1
						break
					end
				end
			end
			
			msg = msg .. " " .. spells
			
			if (where == 4) then --> observer
				local minute, second = _detalhes:GetCombat():GetFormatedCombatTime()
				if (second < 10) then
					second = "0" .. second
				end
				msg = "|cFFFF8800[|r".. minute ..  ":" .. second .. "|cFFFF8800]|r " .. msg
			end
			
			_detalhes:SendMsgToChannel (msg, channel)

	end

	function _detalhes:StartAnnouncers()
		if (_detalhes.announce_interrupts.enabled) then
			_detalhes:InstallHook (DETAILS_HOOK_INTERRUPT, _detalhes.interrupt_announcer)
		end
		if (_detalhes.announce_cooldowns.enabled) then
			_detalhes:InstallHook (DETAILS_HOOK_COOLDOWN, _detalhes.cooldown_announcer)
		end
		if (_detalhes.announce_deaths.enabled) then
			_detalhes:InstallHook (DETAILS_HOOK_DEATH, _detalhes.death_announcer)
		end
	end
	
	function _detalhes:EnableInterruptAnnouncer()
		_detalhes.announce_interrupts.enabled = true
		_detalhes:InstallHook (DETAILS_HOOK_INTERRUPT, _detalhes.interrupt_announcer)
	end
	function _detalhes:DisableInterruptAnnouncer()
		_detalhes.announce_interrupts.enabled = false
		_detalhes:UnInstallHook (DETAILS_HOOK_INTERRUPT, _detalhes.interrupt_announcer)
	end
	
	function _detalhes:EnableCooldownAnnouncer()
		_detalhes.announce_cooldowns.enabled = true
		_detalhes:InstallHook (DETAILS_HOOK_COOLDOWN, _detalhes.cooldown_announcer)
	end
	function _detalhes:DisableCooldownAnnouncer()
		_detalhes.announce_cooldowns.enabled = false
		_detalhes:UnInstallHook (DETAILS_HOOK_COOLDOWN, _detalhes.cooldown_announcer)
	end
	
	function _detalhes:EnableDeathAnnouncer()
		_detalhes.announce_deaths.enabled = true
		_detalhes:InstallHook (DETAILS_HOOK_DEATH, _detalhes.death_announcer)
	end
	function _detalhes:DisableDeathAnnouncer()
		_detalhes.announce_deaths.enabled = false
		_detalhes:UnInstallHook (DETAILS_HOOK_DEATH, _detalhes.death_announcer)
	end
	
	
