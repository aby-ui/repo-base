--

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	local _detalhes = 		_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	
	_detalhes.network = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	local _UnitName = UnitName
	local _GetRealmName = GetRealmName
	local _select = select
	local _table_wipe = table.wipe
	local _math_min = math.min
	local _string_gmatch = string.gmatch
	local _pairs = pairs

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants

	local CONST_REALM_SYNC_ENABLED = false

	local CONST_DETAILS_PREFIX = "DTLS"

	local CONST_HIGHFIVE_REQUEST = "HI"
	local CONST_HIGHFIVE_DATA = "HF"
	
	local CONST_VERSION_CHECK = "CV"
	
	local CONST_ITEMLEVEL_DATA = "IL"
	
	local CONST_WIPE_CALL = "WI"
	
	local CONST_GUILD_SYNC = "GS"
	
	local CONST_CLOUD_REQUEST = "CR"
	local CONST_CLOUD_FOUND = "CF"
	local CONST_CLOUD_DATARQ = "CD"
	local CONST_CLOUD_DATARC = "CE"
	local CONST_CLOUD_EQUALIZE = "EQ"
	
	local CONST_CLOUD_SHAREDATA = "SD"
	
	local CONST_PVP_ENEMY = "PP"
	
	local CONST_ROGUE_SR = "SR" --soul rip from akaari's soul (LEGION ONLY)
	
	_detalhes.network.ids = {
		["HIGHFIVE_REQUEST"] = CONST_HIGHFIVE_REQUEST,
		["HIGHFIVE_DATA"] = CONST_HIGHFIVE_DATA,
		["VERSION_CHECK"] = CONST_VERSION_CHECK,
		["ITEMLEVEL_DATA"] = CONST_ITEMLEVEL_DATA,
		["CLOUD_REQUEST"] = CONST_CLOUD_REQUEST,
		["CLOUD_FOUND"] = CONST_CLOUD_FOUND,
		["CLOUD_DATARQ"] = CONST_CLOUD_DATARQ,
		["CLOUD_DATARC"] = CONST_CLOUD_DATARC,
		["CLOUD_EQUALIZE"] = CONST_CLOUD_EQUALIZE,
		
		["WIPE_CALL"] = CONST_WIPE_CALL,
		
		["GUILD_SYNC"] = CONST_GUILD_SYNC,
		
		["PVP_ENEMY"] = CONST_PVP_ENEMY,
		
		["MISSDATA_ROGUE_SOULRIP"] = CONST_ROGUE_SR, --soul rip from akaari's soul (LEGION ONLY)
		
		["CLOUD_SHAREDATA"] = CONST_CLOUD_SHAREDATA,
	}
	
	local plugins_registred = {}
	
	local temp = {}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> comm functions

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> item level
	function _detalhes:SendCharacterData()
		--> only send if in group
		if (not IsInGroup() and not IsInRaid()) then
			return
		end
		
		if (DetailsFramework.IsClassicWow()) then
			--average item level doesn't exists
			--talent information is very different
			return
		end
		
		--> check the player level
		local playerLevel = UnitLevel ("player")
		if (not playerLevel) then
			return
		elseif (playerLevel < 60) then
			return
		end
		
		--> delay to sent information again
		if (_detalhes.LastPlayerInfoSync and _detalhes.LastPlayerInfoSync+10 > GetTime()) then
			--do not send info if recently sent
			return
		end
	
		--> get player item level
		local overall, equipped = GetAverageItemLevel()
		
		--> get player talents
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
		
		--> get the spec ID
		local spec = DetailsFramework.GetSpecialization()
		local currentSpec
		if (spec) then
			local specID = DetailsFramework.GetSpecializationInfo (spec)
			if (specID and specID ~= 0) then
				currentSpec = specID
			end
		end
		
		--> get the character serial number
		local serial = UnitGUID ("player")
		
		if (IsInRaid()) then
			_detalhes:SendRaidData (CONST_ITEMLEVEL_DATA, serial, equipped, talents, currentSpec)
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent ilevel data to Raid")
			end
			
		elseif (IsInGroup()) then
			_detalhes:SendPartyData (CONST_ITEMLEVEL_DATA, serial, equipped, talents, currentSpec)
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent ilevel data to Party")
			end
		end
		
		_detalhes.LastPlayerInfoSync = GetTime()
	end
	
	function _detalhes.network.ItemLevel_Received (player, realm, core_version, serial, itemlevel, talents, spec)
		_detalhes:IlvlFromNetwork (player, realm, core_version, serial, itemlevel, talents, spec)
	end

--high five
	function _detalhes.network.HighFive_Request()
		return _detalhes:SendRaidData (CONST_HIGHFIVE_DATA, _detalhes.userversion)
	end
	
	function _detalhes.network.HighFive_DataReceived (player, realm, core_version, user_version)
		if (_detalhes.sent_highfive and _detalhes.sent_highfive + 30 > GetTime()) then
			_detalhes.users [#_detalhes.users+1] = {player, realm, (user_version or "") .. " (" .. core_version .. ")"}
		end
	end
	
	function _detalhes.network.Update_VersionReceived (player, realm, core_version, build_number)
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) received version alert ", build_number)
		end
	
		build_number = tonumber (build_number)
	
		if (not _detalhes.build_counter or not _detalhes.lastUpdateWarning or not build_number) then
			return
		end
	
		if (build_number > _detalhes.build_counter) then
			if (time() > _detalhes.lastUpdateWarning + 72000) then
				local lower_instance = _detalhes:GetLowerInstanceNumber()
				if (lower_instance) then
					lower_instance = _detalhes:GetInstance (lower_instance)
					if (lower_instance) then
						lower_instance:InstanceAlert ("Update Available!", {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, _detalhes.update_warning_timeout, {_detalhes.OpenUpdateWindow})
					end
				end
				_detalhes:Msg (Loc ["STRING_VERSION_AVAILABLE"])
				_detalhes.lastUpdateWarning = time()
			end
		end
	end
	
	function _detalhes.network.Cloud_Request (player, realm, core_version, ...)
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug)", player, _detalhes.host_of, _detalhes:CaptureIsAllEnabled(), core_version == _detalhes.realversion)
		end
		if (player ~= _detalhes.playername) then
			if (not _detalhes.host_of and _detalhes:CaptureIsAllEnabled() and core_version == _detalhes.realversion) then
				if (realm ~= _GetRealmName()) then
					player = player .."-"..realm
				end
				_detalhes.host_of = player
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) sent 'okey' answer for a cloud parser request.")
				end
				_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (_detalhes.network.ids.CLOUD_FOUND, _UnitName ("player"), _GetRealmName(), _detalhes.realversion), "WHISPER", player)
			end
		end
	end
	
	function _detalhes.network.Cloud_Found (player, realm, core_version, ...)
		if (_detalhes.host_by) then
			return
		end
		
		if (realm ~= _GetRealmName()) then
			player = player .."-"..realm
		end
		_detalhes.host_by = player
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) cloud found for disabled captures.")
		end
		
		_detalhes.cloud_process = _detalhes:ScheduleRepeatingTimer ("RequestCloudData", 10)
		_detalhes.last_data_requested = _detalhes._tempo
	end
	
	function _detalhes.network.Cloud_DataRequest (player, realm, core_version, ...)
		if (not _detalhes.host_of) then
			return
		end
		
		local atributo, subatributo = player, realm
		
		local data
		local atributo_name = _detalhes:GetInternalSubAttributeName (atributo, subatributo)
		
		if (atributo == 1) then
			data = _detalhes.atributo_damage:RefreshWindow ({}, _detalhes.tabela_vigente, nil, { key = atributo_name, modo = _detalhes.modos.group })
		elseif (atributo == 2) then
			data = _detalhes.atributo_heal:RefreshWindow ({}, _detalhes.tabela_vigente, nil, { key = atributo_name, modo = _detalhes.modos.group })
		elseif (atributo == 3) then
			data = _detalhes.atributo_energy:RefreshWindow ({}, _detalhes.tabela_vigente, nil, { key = atributo_name, modo = _detalhes.modos.group })
		elseif (atributo == 4) then
			data = _detalhes.atributo_misc:RefreshWindow ({}, _detalhes.tabela_vigente, nil, { key = atributo_name, modo = _detalhes.modos.group })
		else
			return
		end
		
		if (data) then
			local export = temp
			local container = _detalhes.tabela_vigente [atributo]._ActorTable
			for i = 1, _math_min (6, #container) do 
				local actor = container [i]
				if (actor.grupo) then
					export [#export+1] = {actor.nome, actor [atributo_name]}
				end
			end
			
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) requesting data from the cloud.")
			end
			
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_CLOUD_DATARC, atributo, atributo_name, export), "WHISPER", _detalhes.host_of)
			_table_wipe (temp)
		end
	end
	
	function _detalhes.network.Cloud_DataReceived	(player, realm, core_version, ...)
		local atributo, atributo_name, data = player, realm, core_version
		
		local container = _detalhes.tabela_vigente [atributo]
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) received data from the cloud.")
		end
		
		for i = 1, #data do 
			local _this = data [i]
			
			local name = _this [1]
			local actor = container:PegarCombatente (nil, name)
			
			if (not actor) then
				if (IsInRaid()) then
					for i = 1, GetNumGroupMembers() do 
						if (name:find ("-")) then --> other realm
							local nname, server = _UnitName ("raid"..i)
							if (server and server ~= "") then
								nname = nname.."-"..server
							end
							if (nname == name) then
								actor = container:PegarCombatente (UnitGUID ("raid"..i), name, 0x514, true)
								break
							end
						else
							if (_UnitName ("raid"..i) == name) then
								actor = container:PegarCombatente (UnitGUID ("raid"..i), name, 0x514, true)
								break
							end
						end

					end
				elseif (IsInGroup()) then
					for i = 1, GetNumGroupMembers()-1 do
						if (name:find ("-")) then --> other realm
							local nname, server = _UnitName ("party"..i)
							if (server and server ~= "") then
								nname = nname.."-"..server
							end
							if (nname == name) then
								actor = container:PegarCombatente (UnitGUID ("party"..i), name, 0x514, true)
								break
							end
						else
							if (_UnitName ("party"..i) == name or _detalhes.playername == name) then
								actor = container:PegarCombatente (UnitGUID ("party"..i), name, 0x514, true)
								break
							end
						end
					end
				end
			end

			if (actor) then
				actor [atributo_name] = _this [2]
				container.need_refresh = true
			else
				if (_detalhes.debug) then
					_detalhes:Msg ("(debug) actor not found on cloud data received", name, atributo_name)
				end
			end
		end
	end
	
	function _detalhes.network.Cloud_Equalize (player, realm, core_version, data)
		if (not _detalhes.in_combat) then
			if (core_version ~= _detalhes.realversion) then
				return
			end
			_detalhes:MakeEqualizeOnActor (player, realm, data)
		end
	end
	
	function _detalhes.network.Wipe_Call (player, realm, core_version, ...)
		local chr_name = Ambiguate (player .. "-" .. realm, "none")
		if (UnitIsGroupLeader (chr_name)) then
			if (UnitIsInMyGuild (chr_name)) then
				_detalhes:CallWipe()
			end
		end
	end
	
	--received an entire segment data from a user that is sharing with  the 'player'
	function _detalhes.network.Cloud_SharedData (player, realm, core_version, data)
	
		if (core_version ~= _detalhes.realversion) then
			if (core_version > _detalhes.realversion) then
				--_detalhes:Msg ("your Details! is out dated and cannot perform the action, please update it.")
			end
			return false
		end

		
	end
	
	--guild sync R = someone pressed the sync button
	--guild sync L = list of fights IDs
	--guild sync G = requested a list of encounters
	--guild sync A = received missing encounters, add them
	
	function _detalhes.network.GuildSync (player, realm, core_version, type, data)
		local chr_name = Ambiguate (player .. "-" .. realm, "none")
		
		if (UnitName ("player") == chr_name) then
			return
		end
		
		if (core_version ~= _detalhes.realversion) then
			if (core_version > _detalhes.realversion) then
				--_detalhes:Msg ("your Details! is out dated and cannot perform the action, please update it.")
			end
			return false
		end
		
		if (type == "R") then --RoS - somebody requested IDs of stored encounters
			_detalhes.LastGuildSyncDataTime1 = _detalhes.LastGuildSyncDataTime1 or 0
			
			--build our table and send to the player
			if (_detalhes.LastGuildSyncDataTime1 > GetTime()) then
				--return false
			end
			
			local IDs = _detalhes.storage:GetIDsToGuildSync()
			if (IDs and IDs [1]) then
				local from = UnitName ("player")
				local realm = GetRealmName()
				_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_GUILD_SYNC, from, realm, _detalhes.realversion, "L", IDs), "WHISPER", chr_name)
			end
			
			_detalhes.LastGuildSyncDataTime1 = GetTime() + 60
			return true
			
		elseif (type == "L") then --RoC - the player received the IDs list and send back which IDs he doesn't have
			local MissingIDs = _detalhes.storage:CheckMissingIDsToGuildSync (data)
			
			if (MissingIDs and MissingIDs [1]) then
				local from = UnitName ("player")
				local realm = GetRealmName()
				_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_GUILD_SYNC, from, realm, _detalhes.realversion, "G", MissingIDs), "WHISPER", chr_name)
			end
			return true
			
		elseif (type == "G") then --RoS - the 'server' send the encounter dps table to the player which requested
			local EncounterData = _detalhes.storage:BuildEncounterDataToGuildSync (data)
			
			if (EncounterData and EncounterData [1]) then
				local task = C_Timer.NewTicker (4, function (task)
					task.TickID = task.TickID + 1
					local data = task.EncounterData [task.TickID]
					
					if (not data) then
						task:Cancel()
						return
					end
					
					local from = UnitName ("player")
					local realm = GetRealmName()
					--todo: need to check if the target is still online
					_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_GUILD_SYNC, from, realm, _detalhes.realversion, "A", data), "WHISPER", task.Target)
					
					if (_detalhes.debug) then
						_detalhes:Msg ("(debug) [RoS-EncounterSync] send-task sending data #" .. task.TickID .. ".")
					end
				end)
				
				task.TickID = 0
				task.EncounterData = EncounterData
				task.Target = chr_name
			end	
			return true
			
		elseif (type == "A") then --RoC - the player received the dps table and should now add it to the db
			_detalhes.storage:AddGuildSyncData (data, player)
			return true
			
		end
		
	end
	
	function _detalhes.network.HandleMissData (player, realm, core_version, data)
	
--		[1] - container
--		[2] - spellid
--		[3] - spell total
--		[4] - spell counter

		core_version = tonumber (core_version) or 0
		if (core_version ~= _detalhes.realversion) then
			if (core_version > _detalhes.realversion) then
				_detalhes:Msg ("your Details! is out dated and cannot communicate with other players.")
			end
			return
		end
		if (type (player) ~= "string") then
			return
		end
		local playerName = _detalhes:GetCLName (player)
		if (playerName) then
			_detalhes.HandleMissData (playerName, data)
		end
	end
	
	function _detalhes.network.ReceivedEnemyPlayer (player, realm, core_version, data)
		-- ["PVP_ENEMY"] = CONST_PVP_ENEMY,
	end
	
	
	
	_detalhes.network.functions = {
		[CONST_HIGHFIVE_REQUEST] = _detalhes.network.HighFive_Request,
		[CONST_HIGHFIVE_DATA] = _detalhes.network.HighFive_DataReceived,
		[CONST_VERSION_CHECK] = _detalhes.network.Update_VersionReceived,
		[CONST_ITEMLEVEL_DATA] = _detalhes.network.ItemLevel_Received,
		
		[CONST_CLOUD_REQUEST] = _detalhes.network.Cloud_Request,
		[CONST_CLOUD_FOUND] = _detalhes.network.Cloud_Found,
		[CONST_CLOUD_DATARQ] = _detalhes.network.Cloud_DataRequest,
		[CONST_CLOUD_DATARC] = _detalhes.network.Cloud_DataReceived,
		[CONST_CLOUD_EQUALIZE] = _detalhes.network.Cloud_Equalize,
		[CONST_WIPE_CALL] = _detalhes.network.Wipe_Call,
		
		[CONST_GUILD_SYNC] = _detalhes.network.GuildSync,
		
		[CONST_ROGUE_SR] = _detalhes.network.HandleMissData, --soul rip from akaari's soul (LEGION ONLY)
		
		[CONST_PVP_ENEMY] = _detalhes.network.ReceivedEnemyPlayer,
	}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> register comm

	function _detalhes:CommReceived (_, data, _, source)
	
		local prefix, player, realm, dversion, arg6, arg7, arg8, arg9 =  _select (2, _detalhes:Deserialize (data))
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) network received:", prefix, "length:", string.len (data))
		end
		
		--event
		_detalhes:SendEvent ("COMM_EVENT_RECEIVED", nil, string.len (data), prefix, player, realm, dversion, arg6, arg7, arg8, arg9)
		
		--print ("comm received", prefix, _detalhes.network.functions [prefix])
		
		local func = _detalhes.network.functions [prefix]
		if (func) then
			--todo: this call should be safe
			func (player, realm, dversion, arg6, arg7, arg8, arg9)
		else
			func = plugins_registred [prefix]
			--print ("plugin comm?", func, player, realm, dversion, arg6, arg7, arg8, arg9)
			if (func) then
				--todo: this call should be safe
				func (player, realm, dversion, arg6, arg7, arg8, arg9)
			else
				if (_detalhes.debug) then
					_detalhes:Msg ("comm prefix not found:", prefix)
				end
			end
		end
	end
	
	_detalhes:RegisterComm ("DTLS", "CommReceived")
	
	--> hook the send comm message so we can trigger events when sending data
	--> this adds overhead, but easily catches all outgoing comm messages
	hooksecurefunc (Details, "SendCommMessage", function (context, addonPrefix, serializedData, channel)
		--unpack data
		local prefix, player, realm, dversion, arg6, arg7, arg8, arg9 =  _select (2, _detalhes:Deserialize (serializedData))
		--send the event
		_detalhes:SendEvent ("COMM_EVENT_SENT", nil, string.len (serializedData), prefix, player, realm, dversion, arg6, arg7, arg8, arg9)
	end)
	
	function _detalhes:RegisterPluginComm (prefix, func)
		assert (type (prefix) == "string" and string.len (prefix) >= 2 and string.len (prefix) <= 4, "RegisterPluginComm expects a string with 2-4 characters on #1 argument.")
		assert (type (func) == "function" or (type (func) == "string" and type (self [func]) == "function"), "RegisterPluginComm expects a function or function name on #2 argument.")
		assert (plugins_registred [prefix] == nil, "Prefix " .. prefix .. " already in use 1.")
		assert (_detalhes.network.functions [prefix] == nil, "Prefix " .. prefix .. " already in use 2.")
		
		if (type (func) == "string") then
			plugins_registred [prefix] = self [func]
		else
			plugins_registred [prefix] = func
		end
		return true
	end
	
	function _detalhes:UnregisterPluginComm (prefix)
		plugins_registred [prefix] = nil
		return true
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> send functions

	function _detalhes:GetChannelId (channel)
		for id = 1, GetNumDisplayChannels() do 
			local name, _, _, room_id = GetChannelDisplayInfo (id)
			if (name == channel) then
				return room_id
			end
		end
	end
	
	--[
	function _detalhes.parser_functions:CHAT_MSG_CHANNEL (...)
		local message, _, _, _, _, _, _, _, channelName = ...
		if (channelName == "Details") then
			local prefix, data = strsplit ("_", message, 2)
			
			local func = plugins_registred [prefix]
			if (func) then
				func (_select (2, _detalhes:Deserialize (data)))
			else
				if (_detalhes.debug) then
					_detalhes:Msg ("comm prefix not found:", prefix)
				end
			end

		end
	end
	--]]

	function _detalhes:SendPluginCommMessage (prefix, channel, ...)
	
		if (not _detalhes:IsConnected()) then
			return false
		end
	
		if (not channel) then
			channel = "Details"
		end
		
		if (channel == "RAID") then
			if (IsInGroup (LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
				_detalhes:SendCommMessage (prefix, _detalhes:Serialize (self.__version, ...), "INSTANCE_CHAT")
			else
				_detalhes:SendCommMessage (prefix, _detalhes:Serialize (self.__version, ...), "RAID")
			end
			
		elseif (channel == "PARTY") then
			if (IsInGroup (LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
				_detalhes:SendCommMessage (prefix, _detalhes:Serialize (self.__version, ...), "INSTANCE_CHAT")
			else
				_detalhes:SendCommMessage (prefix, _detalhes:Serialize (self.__version, ...), "PARTY")
			end
		
		elseif (channel == "Details") then
			local id = _detalhes:GetChannelId (channel)
			if (id) then
				if (not _detalhes.listener:IsEventRegistered ("CHAT_MSG_CHANNEL")) then
					_detalhes.listener:RegisterEvent ("CHAT_MSG_CHANNEL")
				end
				SendChatMessage (prefix .. "_" .. _detalhes:Serialize (self.__version, ...), "CHANNEL", nil, id)
			end
		else
			_detalhes:SendCommMessage (prefix, _detalhes:Serialize (self.__version, ...), channel)
		end
		
		return true
	end
	
	
	--> send as
	function _detalhes:SendRaidDataAs (type, player, realm, ...)
		if (not realm) then
			--> check if realm is already inside player name
			for _name, _realm in _string_gmatch (player, "(%w+)-(%w+)") do
				if (_realm) then
					player = _name
					realm = _realm
				end
			end
		end
		if (not realm) then
			--> doesn't have realm at all, so we assume the actor is in same realm as player
			realm = _GetRealmName()
		end
		_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, player, realm, _detalhes.realversion, ...), "RAID")
	end
	
	function _detalhes:SendHomeRaidData (type, ...)
		if (IsInRaid (LE_PARTY_CATEGORY_HOME) and IsInInstance()) then
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "RAID")
		end
	end
	
	function _detalhes:SendRaidData (type, ...)
	
		local isInInstanceGroup = IsInRaid (LE_PARTY_CATEGORY_INSTANCE)
	
		if (isInInstanceGroup) then
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "INSTANCE_CHAT")
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent comm to INSTANCE raid group")
			end
		else
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "RAID")
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent comm to LOCAL raid group")
			end
		end
	end
	
	function _detalhes:SendPartyData (type, ...)
		
		local isInInstanceGroup = IsInGroup (LE_PARTY_CATEGORY_INSTANCE)
		
		if (isInInstanceGroup) then
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "INSTANCE_CHAT")
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent comm to INSTANCE party group")
			end
		else
			_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "PARTY")
			if (_detalhes.debug) then
				_detalhes:Msg ("(debug) sent comm to LOCAL party group")
			end
		end
		
	end
	
	function _detalhes:SendRaidOrPartyData (type, ...)
		if (IsInRaid()) then
			_detalhes:SendRaidData (type, ...)
		elseif (IsInGroup()) then
			_detalhes:SendPartyData (type, ...)
		end
	end
	
	function _detalhes:SendGuildData (type, ...)
		if not IsInGuild() then return end --> fix from Tim@WoWInterface
		_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (type, _UnitName ("player"), _GetRealmName(), _detalhes.realversion, ...), "GUILD")
	end
	


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> cloud

	function _detalhes:SendCloudRequest()
		_detalhes:SendRaidData (_detalhes.network.ids.CLOUD_REQUEST)
	end
	
	function _detalhes:ScheduleSendCloudRequest()
		_detalhes:ScheduleTimer ("SendCloudRequest", 1)
	end

	function _detalhes:RequestCloudData()
		_detalhes.last_data_requested = _detalhes._tempo

		if (not _detalhes.host_by) then
			return
		end
	
		for index = 1, #_detalhes.tabela_instancias do
			local instancia = _detalhes.tabela_instancias [index]
			if (instancia.ativa) then
				local atributo = instancia.atributo
				if (atributo == 1 and not _detalhes:CaptureGet ("damage")) then
					_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_CLOUD_DATARQ, atributo, instancia.sub_atributo), "WHISPER", _detalhes.host_by)
					break
				elseif (atributo == 2 and (not _detalhes:CaptureGet ("heal") or _detalhes:CaptureGet ("aura"))) then
					_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_CLOUD_DATARQ, atributo, instancia.sub_atributo), "WHISPER", _detalhes.host_by)
					break
				elseif (atributo == 3 and not _detalhes:CaptureGet ("energy")) then
					_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_CLOUD_DATARQ, atributo, instancia.sub_atributo), "WHISPER", _detalhes.host_by)
					break
				elseif (atributo == 4 and not _detalhes:CaptureGet ("miscdata")) then
					_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_CLOUD_DATARQ, atributo, instancia.sub_atributo), "WHISPER", _detalhes.host_by)
					break
				end
			end
		end
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> update

	function _detalhes:CheckVersion (send_to_guild)
		if (IsInRaid()) then
			_detalhes:SendRaidData (_detalhes.network.ids.VERSION_CHECK, _detalhes.build_counter)
		elseif (IsInGroup()) then
			_detalhes:SendPartyData (_detalhes.network.ids.VERSION_CHECK, _detalhes.build_counter)
		end
		
		if (send_to_guild) then
			_detalhes:SendGuildData (_detalhes.network.ids.VERSION_CHECK, _detalhes.build_counter)
		end
	end
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> sharer

	local city_zones = {
		["ShattrathCity"] = true,
		["Dalaran"] = true,
		
		["AshranHordeFactionHub"] = true,
		["AshranAllianceFactionHub"] = true,
		
		["Orgrimmar"] = true,
		["Undercity"] = true,
		["ThunderBluff"] = true,
		["SilvermoonCity"] = true,
		
		["StormwindCity"] = true,
		["Darnassus"] = true,
		["Ironforge"] = true,
		["TheExodar"] = true,
		
		["garrisonffhorde_tier1"] = true,
		["garrisonffhorde_tier2"] = true,
		["garrisonffhorde_tier3"] = true,
		
		["garrisonsmvalliance_tier1"] = true,
		["garrisonsmvalliance_tier2"] = true,
		["garrisonsmvalliance_tier3"] = true,
		["garrisonsmvalliance_tier4"] = true,
	}
	
	local sub_zones = {
		["ShrineofTwoMoons"] = true,
		["ShrineofSevenStars"] = true,
	}

	function _detalhes:IsInCity()
		if (SetMapToCurrentZone and SetMapToCurrentZone()) then
			local mapID = C_Map.GetBestMapForUnit ("player")
			if (not mapID) then
				--print ("Details! exeption handled: zone has no map")
				return
			end
			local mapFileName, _, _, _, microDungeonMapName = C_Map.GetMapInfo (mapID)
			
			if (city_zones [mapFileName]) then
				return true
			elseif (microDungeonMapName and type (microDungeonMapName) == "string" and sub_zones [microDungeonMapName]) then
				return true
			end
		end
	end

	--> entrar no canal ap�s logar no servidor
	function _detalhes:EnterChatChannel()
		if (not _detalhes.realm_sync or not CONST_REALM_SYNC_ENABLED) then
			return
		end
		
		if (not _detalhes:IsInCity()) then
			return
		end
		
		if (_detalhes.schedule_chat_leave) then
			_detalhes:CancelTimer (_detalhes.schedule_chat_leave)
			_detalhes.schedule_chat_leave = nil
		end
		_detalhes.schedule_chat_enter = nil
	
		local realm = GetRealmName()
		realm = realm or ""
	
		--> room name
		local room_name = "Details"

		_detalhes.listener:RegisterEvent ("CHAT_MSG_CHANNEL")
		
		--> already in?
		for room_index = 1, 10 do
			local _, name = GetChannelName (room_index)
			if (name == room_name) then
				_detalhes.is_connected = true
				return --> already in the room
			end
		end
		
		--> enter
		JoinChannelByName (room_name)
		_detalhes.is_connected = true
		
		_detalhes:SendEvent ("REALM_CHANNEL_ENTER")
	end
	
	function _detalhes:LeaveChatChannel()
		if (not _detalhes.realm_sync or not CONST_REALM_SYNC_ENABLED) then
			return
		end
	
		if (_detalhes.schedule_chat_enter) then
			_detalhes:CancelTimer (_detalhes.schedule_chat_enter)
			_detalhes.schedule_chat_enter  = nil
		end
		_detalhes.schedule_chat_leave = nil
	
		local realm = GetRealmName()
		realm = realm or ""
		
		--> room name
		local room_name = "Details"
		local is_in = false
		
		--> already in?
		for room_index = 1, 10 do
			local _, name = GetChannelName (room_index)
			if (name == room_name) then
				is_in = true
			end
		end
		
		if (is_in) then
			LeaveChannelByName (room_name)
		end
		
		_detalhes.is_connected = false
		
		_detalhes.listener:UnregisterEvent ("CHAT_MSG_CHANNEL")
		
		_detalhes:SendEvent ("REALM_CHANNEL_LEAVE")
	end
	
	function _detalhes:DoZoneCheck()
		local in_city = _detalhes:IsInCity()
		if (not in_city) then
			if (_detalhes.schedule_chat_enter) then
				_detalhes:CancelTimer (_detalhes.schedule_chat_enter)
			end
			if (not _detalhes.schedule_chat_leave) then
				_detalhes.schedule_chat_leave = _detalhes:ScheduleTimer ("LeaveChatChannel", 5)
			end
		else
			if (in_city) then
			
				local _, name = GetChannelName (2)
				if (name) then
					if (_detalhes.schedule_chat_leave) then
						_detalhes:CancelTimer (_detalhes.schedule_chat_leave)
					end
					if (not _detalhes.schedule_chat_enter) then
						_detalhes.schedule_chat_enter = _detalhes:ScheduleTimer ("EnterChatChannel", 5)
					end
				end
			end
		end
	end
	
	function _detalhes:CheckChatOnZoneChange()
		if (not _detalhes.realm_sync or not CONST_REALM_SYNC_ENABLED) then
			return
		end
		_detalhes:ScheduleTimer ("DoZoneCheck", 2)
	end
	
	function _detalhes:IsConnected()
		if (not _detalhes.is_connected) then
			local id = _detalhes:GetChannelId ("Details")
			if (id) then
				_detalhes.is_connected = true
			end
		end
		return _detalhes.is_connected
	end
