
	local Details = 		_G._detalhes
	local Loc = LibStub("AceLocale-3.0"):GetLocale( "Details" )
	local _

	--register namespace
	Details.network = {}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--local pointers

	local UnitName = UnitName
	local GetRealmName = GetRealmName
	local select = select

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--constants

	_G.DETAILS_PREFIX_NETWORK = "DTLS"

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

	_G.DETAILS_PREFIX_COACH = "CO" --coach feature
	_G.DETAILS_PREFIX_TBC_DATA = "BC" --tbc data

	Details.network.ids = {
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

		["COACH_FEATURE"] = DETAILS_PREFIX_COACH, --ask the raid leader is the coach is enbaled

		["TBC_DATA"] = DETAILS_PREFIX_TBC_DATA, --get basic information about the player
	}

	local registredPlugins = {}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--comm functions

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--item level
	function Details:SendCharacterData()
		--only send if in group
		if (not IsInGroup() and not IsInRaid()) then
			return
		end

		if (DetailsFramework.IsTimewalkWoW()) then
			return
		end

		--check the player level
		local playerLevel = UnitLevel("player")
		if (not playerLevel) then
			return
		elseif (playerLevel < 60) then
			return
		end

		--delay to sent information again
		if (Details.LastPlayerInfoSync and Details.LastPlayerInfoSync + 10 > GetTime()) then
			--do not send info if recently sent
			return
		end

		--get player item level
		local overall, equipped = GetAverageItemLevel()

		--get player talents
		local talents = {}
		for i = 1, 7 do
			for o = 1, 3 do
				local talentID, name, texture, selected, available = GetTalentInfo(i, o, 1)
				if (selected) then
					tinsert(talents, talentID)
					break
				end
			end
		end

		--get the spec ID
		local spec = DetailsFramework.GetSpecialization()
		local currentSpec
		if (spec) then
			local specID = DetailsFramework.GetSpecializationInfo(spec)
			if (specID and specID ~= 0) then
				currentSpec = specID
			end
		end

		--get the character serial number
		local serial = UnitGUID("player")

		if (IsInRaid()) then
			Details:SendRaidData(CONST_ITEMLEVEL_DATA, serial, equipped, talents, currentSpec)
			if (Details.debugnet) then
				Details:Msg("(debug) sent ilevel data to Raid")
			end

		elseif (IsInGroup()) then
			Details:SendPartyData(CONST_ITEMLEVEL_DATA, serial, equipped, talents, currentSpec)
			if (Details.debugnet) then
				Details:Msg("(debug) sent ilevel data to Party")
			end
		end

		Details.LastPlayerInfoSync = GetTime()
	end

	function Details.network.ItemLevel_Received(player, realm, coreVersion, serial, itemlevel, talents, spec)
		Details:IlvlFromNetwork(player, realm, coreVersion, serial, itemlevel, talents, spec)
	end

	--high five
	function Details.network.HighFive_Request()
		return Details:SendRaidData(CONST_HIGHFIVE_DATA, Details.userversion)
	end

	function Details.network.HighFive_DataReceived(player, realm, coreVersion, userVersion)
		if (Details.sent_highfive and Details.sent_highfive + 30 > GetTime()) then
			Details.users[#Details.users+1] = {player, realm, (userVersion or "") .. " (" .. coreVersion .. ")"}
		end
	end

	function Details.network.Update_VersionReceived(player, realm, coreVersion, buildNumber)
		if (Details.debugnet) then
			Details:Msg("(debug) received version alert ", buildNumber)
		end

		if (Details.streamer_config.no_alerts) then
			return
		end

		buildNumber = tonumber(buildNumber)

		if (not Details.build_counter or not Details.lastUpdateWarning or not buildNumber) then
			return
		end

		if (buildNumber > Details.build_counter) then
			if (time() > Details.lastUpdateWarning + 72000) then
				local lowerInstanceId = Details:GetLowerInstanceNumber()
				if (lowerInstanceId) then
					local instance = Details:GetInstance(lowerInstanceId)
					if (instance) then
						instance:InstanceAlert("Update Available!", {[[Interface\GossipFrame\AvailableQuestIcon]], 16, 16, false}, Details.update_warning_timeout, {Details.OpenUpdateWindow})
					end
				end
				--Details:Msg(Loc["STRING_VERSION_AVAILABLE"])
				Details.lastUpdateWarning = time()
			end
		end
	end

	function Details.network.Cloud_Request(player, realm, coreVersion, ...)
		--deprecated
	end

	function Details.network.Cloud_Found(player, realm, coreVersion, ...)
		--deprecated
	end

	function Details.network.Cloud_DataRequest(player, realm, coreVersion, ...)
		--deprecated
	end

	function Details.network.Cloud_DataReceived(player, realm, coreVersion, ...)
		--deprecated
	end

	function Details.network.Cloud_Equalize(player, realm, coreVersion, data)
		--deprecated
	end

	function Details.network.Wipe_Call(player, realm, coreVersion, ...)
		local chr_name = Ambiguate(player, "none")
		if (UnitIsGroupLeader (chr_name)) then
			if (UnitIsInMyGuild (chr_name)) then
				Details:CallWipe()
			end
		end
	end

	function Details.network.Cloud_SharedData(player, realm, coreVersion, data)
		--deprecated
	end

	function Details.network.TBCData(player, realm, coreVersion, data)
		if (not IsInRaid() and not IsInGroup()) then
			return
		end

		local LibDeflate = _G.LibStub:GetLibrary("LibDeflate")
		local dataCompressed = LibDeflate:DecodeForWoWAddonChannel(data)
		local dataSerialized = LibDeflate:DecompressDeflate(dataCompressed)
		local dataTable = {Details:Deserialize(dataSerialized)}
		tremove(dataTable, 1)
		local dataTable = dataTable[1]

		local playerRole = dataTable[1]
		local spec = dataTable[2]
		local itemLevel = dataTable[3]
		local talents = dataTable[4]
		local guid = dataTable[5]

		--[=[
		print("Details! Received TBC Comm Data:")
		print("From:", player)
		print("spec:", spec)
		print("role:", playerRole)
		print("item level:", itemLevel)
		print("guid:", guid)
		--]=]

		if (guid) then
			Details.cached_talents[guid] = talents
			if (spec and spec ~= 0)  then
				Details.cached_specs[guid] = spec
			end
			Details.cached_roles[guid] = playerRole
			Details.item_level_pool[guid] = {
				name = player,
				ilvl = itemLevel,
				time = time()
			}
		end
	end

	--"CIEA" Coach Is Enabled Ask (client > server)
	--"CIER" Coach Is Enabled Response (server > client)
	--"CCS" Coach Combat Start (client > server)
	function Details.network.Coach(player, realm, coreVersion, msgType, data)
		if (not IsInRaid()) then
			return
		end

		if (Details.debugnet) then
			print("Details Coach Received Comm", player, realm, coreVersion, msgType, data)
		end

		local sourcePlayer = Ambiguate(player, "none")

		local playerName = UnitName("player")
		if (playerName == sourcePlayer) then
			if (Details.debugnet) then
				print("Details Coach Received Comm | RETURN | playerName == sourcePlayer", playerName , sourcePlayer)
			end
			return
		end

		if (msgType == "CIEA") then --Is Coach Enabled Ask (regular player asked to raid leader)
			Details.Coach.Server.CoachIsEnabled_Answer(sourcePlayer)

		elseif (msgType == "CIER") then --Coach Is Enabled Response (regular player received a raid leader response)
			local isEnabled = data
			Details.Coach.Client.CoachIsEnabled_Response(isEnabled, sourcePlayer)

		elseif (msgType == "CCS") then --Coach Combat Start (raid assistant told the raid leader a combat started)
			Details.Coach.Server.CombatStarted()

		elseif (msgType == "CCE") then --Coach Combat End (raid assistant told the raid leader a combat ended)
			Details.Coach.Server.CombatEnded()

		elseif (msgType == "CS") then --Coach Start (raid leader notifying other members of the group)
			if (Details.debugnet) then
				print("Details Coach received 'CE' a new coach is active, coach name:", sourcePlayer)
			end
			Details.Coach.Client.EnableCoach(sourcePlayer)

		elseif (msgType == "CE") then --Coach End (raid leader notifying other members of the group)
			Details.Coach.Client.CoachEnd()

		elseif (msgType == "CDT") then --Coach Data (a player in the raid sent to raid leader combat data)
			if (Details.Coach.Server.IsEnabled()) then
				--update the current combat with new information
				Details.packFunctions.DeployPackedCombatData(data)
			end

		elseif (msgType == "CDD") then --Coach Death (a player in the raid sent to raid leader his death log)
			if (Details.Coach.Server.IsEnabled()) then
				Details.Coach.Server.AddPlayerDeath(sourcePlayer, data)
			end
		end
	end

	--guild sync R = someone pressed the sync button
	--guild sync L = list of fights IDs
	--guild sync G = requested a list of encounters
	--guild sync A = received missing encounters, add them

	function Details.network.GuildSync(player, realm, coreVersion, type, data)
		local characterName = Ambiguate(player, "none")

		if (UnitName("player") == characterName) then
			return
		end

		if (coreVersion ~= Details.realversion) then
			return false
		end

		if (type == "R") then --RoS - somebody requested IDs of stored encounters
			Details.LastGuildSyncDataTime1 = Details.LastGuildSyncDataTime1 or 0
			--build our table and send to the player
			if (Details.LastGuildSyncDataTime1 > GetTime()) then
				--return false
			end

			local IDs = Details.storage:GetIDsToGuildSync()
			if (IDs and IDs [1]) then
				local from = UnitName ("player")
				local realm = GetRealmName()
				Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(CONST_GUILD_SYNC, from, realm, Details.realversion, "L", IDs), "WHISPER", characterName)
			end

			Details.LastGuildSyncDataTime1 = GetTime() + 60
			return true

		elseif (type == "L") then --RoC - the player received the IDs list and send back which IDs he doesn't have
			local MissingIDs = Details.storage:CheckMissingIDsToGuildSync(data)

			if (MissingIDs and MissingIDs[1]) then
				local from = UnitName ("player")
				local realm = GetRealmName()
				Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(CONST_GUILD_SYNC, from, realm, Details.realversion, "G", MissingIDs), "WHISPER", characterName)
			end
			return true

		elseif (type == "G") then --RoS - the 'server' send the encounter dps table to the player which requested
			local encounterData = Details.storage:BuildEncounterDataToGuildSync(data)

			if (encounterData and encounterData[1]) then
				local task = C_Timer.NewTicker(4, function(task)
					task.TickID = task.TickID + 1
					local data = task.EncounterData[task.TickID]

					if (not data) then
						task:Cancel()
						return
					end

					local from = UnitName("player")
					local realm = GetRealmName()
					--todo: need to check if the target is still online
					Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(CONST_GUILD_SYNC, from, realm, Details.realversion, "A", data), "WHISPER", task.Target)

					if (Details.debugnet) then
						Details:Msg("(debug) [RoS-EncounterSync] send-task sending data #" .. task.TickID .. ".")
					end
				end)

				task.TickID = 0
				task.EncounterData = encounterData
				task.Target = characterName
			end
			return true

		elseif (type == "A") then --RoC - the player received the dps table and should now add it to the db
			Details.storage:AddGuildSyncData(data, player)
			return true
		end
	end

	function Details.network.HandleMissData(player, realm, coreVersion, data)
		--soul rip from akaari's soul (LEGION ONLY)
		--deprecated
	end

	function Details.network.ReceivedEnemyPlayer(player, realm, coreVersion, data)
		--deprecated
	end

	Details.network.functions = {
		[CONST_HIGHFIVE_REQUEST] = Details.network.HighFive_Request,
		[CONST_HIGHFIVE_DATA] = Details.network.HighFive_DataReceived,
		[CONST_VERSION_CHECK] = Details.network.Update_VersionReceived,
		[CONST_ITEMLEVEL_DATA] = Details.network.ItemLevel_Received,

		[CONST_CLOUD_REQUEST] = Details.network.Cloud_Request,
		[CONST_CLOUD_FOUND] = Details.network.Cloud_Found,
		[CONST_CLOUD_DATARQ] = Details.network.Cloud_DataRequest,
		[CONST_CLOUD_DATARC] = Details.network.Cloud_DataReceived,
		[CONST_CLOUD_EQUALIZE] = Details.network.Cloud_Equalize,
		[CONST_WIPE_CALL] = Details.network.Wipe_Call,

		[CONST_GUILD_SYNC] = Details.network.GuildSync,

		[CONST_ROGUE_SR] = Details.network.HandleMissData, --soul rip from akaari's soul (LEGION ONLY)

		[CONST_PVP_ENEMY] = Details.network.ReceivedEnemyPlayer,

		[DETAILS_PREFIX_COACH] = Details.network.Coach, --coach feature
		[DETAILS_PREFIX_TBC_DATA] = Details.network.TBCData
	}

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--register comm

	function Details:CommReceived(commPrefix, data, channel, source)

		--print("comm", source, data)

		local deserializedTable = {Details:Deserialize(data)}
		if (not deserializedTable[1]) then
			if (Details.debugnet) then
				Details:Msg("(debug) network deserialize |cFFFF0000failed|r, from:", source, Details:Deserialize(data))
			end
			return
		end

		tremove(deserializedTable, 1)
		local prefix, player, realm, coreVersion, arg6, arg7, arg8, arg9 = unpack(deserializedTable)
		player = source

		if (Details.debugnet) then
			Details:Msg("(debug) network received prefix:", prefix, "length:", string.len(data), source)
		end

		if (type(prefix) ~= "string") then
			if (Details.debugnet) then
				Details:Msg("(debug) network |cFFFF0000failed|r: prefix isn't a string", prefix, "length:", string.len(data))
			end
			return

		elseif (type(coreVersion) ~= "number") then
			if (Details.debugnet) then
				Details:Msg("(debug) network |cFFFF0000failed|r: coreVersion isn't a number", prefix, "length:", string.len(data))
			end
			return
		end

		--event
		Details:SendEvent("COMM_EVENT_RECEIVED", nil, string.len(data), prefix, player, realm, coreVersion, arg6, arg7, arg8, arg9)

		local func = Details.network.functions[prefix]
		if (func) then
			local callName = "CommReceived|" .. prefix .. "|" .. coreVersion .. "|" .. Details:GetCoreVersion()
			Details.SafeRun(func, callName, player, realm, coreVersion, arg6, arg7, arg8, arg9)
		else
			func = registredPlugins[prefix]
			if (func) then
				local callName = "CommReceived|Plugin|" .. prefix .. "|" .. coreVersion .. "|" .. Details:GetCoreVersion()
				Details.SafeRun(func, callName, player, realm, coreVersion, arg6, arg7, arg8, arg9)
			else
				if (Details.debugnet) then
					Details:Msg("comm prefix not found:", prefix)
				end
			end
		end
	end

	Details:RegisterComm("DTLS", "CommReceived")

	--hook the send comm message so we can trigger events when sending data
	--this adds overhead, but easily catches all outgoing comm messages
	hooksecurefunc(Details, "SendCommMessage", function(context, addonPrefix, serializedData, channel)
		--unpack data
		local prefix, player, realm, coreVersion, arg6, arg7, arg8, arg9 =  select(2, Details:Deserialize(serializedData))
		--send the event
		Details:SendEvent("COMM_EVENT_SENT", nil, string.len(serializedData), prefix, player, realm, coreVersion, arg6, arg7, arg8, arg9)
	end)

	function Details:RegisterPluginComm(prefix, func)
		assert(type(prefix) == "string" and string.len(prefix) >= 2 and string.len(prefix) <= 4, "RegisterPluginComm expects a string with 2-4 characters on #1 argument.")
		assert(type(func) == "function" or (type(func) == "string" and type(self[func]) == "function"), "RegisterPluginComm expects a function or function name on #2 argument.")
		assert(registredPlugins[prefix] == nil, "Prefix " .. prefix .. " already in use 1.")
		assert(Details.network.functions[prefix] == nil, "Prefix " .. prefix .. " already in use 2.")

		if (type(func) == "string") then
			registredPlugins[prefix] = self[func]
		else
			registredPlugins[prefix] = func
		end
		return true
	end

	function Details:UnregisterPluginComm(prefix)
		registredPlugins[prefix] = nil
		return true
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--send functions

	function Details:GetChannelId(channel)
		--deprecated
	end

	function Details.parser_functions:CHAT_MSG_CHANNEL(...)
		--deprecated
	end

	function Details:SendPluginCommMessage(prefix, channel, ...)
		if (channel == "RAID") then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
				Details:SendCommMessage(prefix, Details:Serialize(self.__version, ...), "INSTANCE_CHAT")
			else
				Details:SendCommMessage(prefix, Details:Serialize(self.__version, ...), "RAID")
			end

		elseif (channel == "PARTY") then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then
				Details:SendCommMessage(prefix, Details:Serialize(self.__version, ...), "INSTANCE_CHAT")
			else
				Details:SendCommMessage(prefix, Details:Serialize(self.__version, ...), "PARTY")
			end
		else
			Details:SendCommMessage(prefix, Details:Serialize(self.__version, ...), channel)
		end

		return true
	end

	--send as
	function Details:SendRaidDataAs(type, player, realm, ...)
		--deprecated
	end

	function Details:SendHomeRaidData(type, ...)
		if (IsInRaid(LE_PARTY_CATEGORY_HOME) and IsInInstance()) then
			Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "RAID")
		end
	end

	function Details:SendRaidData(type, ...)
		local isInInstanceGroup = IsInRaid(LE_PARTY_CATEGORY_INSTANCE)
		if (isInInstanceGroup) then
			Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "INSTANCE_CHAT")
		else
			Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "RAID")
		end
	end

	function Details:SendPartyData(type, ...)
		local isInInstanceGroup = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
		if (isInInstanceGroup) then
			Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "INSTANCE_CHAT")
		else
			Details:SendCommMessage (DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "PARTY")
		end
	end

	function Details:SendRaidOrPartyData(type, ...)
		if (IsInRaid()) then
			Details:SendRaidData(type, ...)
		elseif (IsInGroup()) then
			Details:SendPartyData(type, ...)
		end
	end

	function Details:SendGuildData(type, ...)
		if not IsInGuild() then return end --fix from Tim@WoWInterface
		Details:SendCommMessage(DETAILS_PREFIX_NETWORK, Details:Serialize(type, UnitName("player"), GetRealmName(), Details.realversion, ...), "GUILD")
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--cloud

	function Details:SendCloudRequest()
		--deprecated
	end

	function Details:ScheduleSendCloudRequest()
		--deprecated
	end

	function Details:RequestCloudData()
		--deprecated
	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--update

	function Details:CheckVersion(sendToGuild)
		if (IsInRaid()) then
			Details:SendRaidData(Details.network.ids.VERSION_CHECK, Details.build_counter)

		elseif (IsInGroup()) then
			Details:SendPartyData(Details.network.ids.VERSION_CHECK, Details.build_counter)
		end

		if (sendToGuild) then
			Details:SendGuildData(Details.network.ids.VERSION_CHECK, Details.build_counter)
		end
	end
