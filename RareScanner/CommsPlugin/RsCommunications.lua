-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner", "AceComm-3.0")

local ADDON_NAME, private = ...

-- Communications
local COMM_PREFIX = "CommRS"
local EVENT_NPC_FOUND = "RsNpcFound"
local EVENT_REQUEST_DATA = "RsRequestData"
local EVENT_SEND_DATA = "RsResponseData"
local CHANNEL_GUILD = "GUILD"
local CHANNEL_PARTY = "PARTY"
local CHANNEL_RAID = "RAID"
local RESPAWN_DEATH = 0
local ETERNAL_DEATH = -1

-- Timers
local SEND_DATA_PARTY_TIMER
local SEND_DATA_DELAY = 20
local SEND_DATA_COOLDOWN = 0
local SEND_DATA_COOLDOWN_DELAY = 10
local _30_MINUTES = 1800 -- 30min * 60sec

function RareScanner:RequestGuildData()
	C_Timer.After(15, function() 
		RareScanner:PrintDebugMessage("DEBUG: Solicitando informacion a la hermandad")
		local data = LibStub ("AceSerializer-3.0"):Serialize({EVENT_REQUEST_DATA, UnitName("player")})
	
		if (IsInGuild()) then
			RareScanner:PrintDebugMessage("DEBUG: Enviado mensaje de peticion a la hermandad")
			RareScanner:SendCommMessage(COMM_PREFIX, data, CHANNEL_GUILD)
		end
	end)
end

function RareScanner:RequestGroupDataOnChange()
	if (self.numPlayers and GetNumGroupMembers() ~= 1 and self.numPlayers < GetNumGroupMembers() + 1) then
		-- share info
		if (not SEND_DATA_PARTY_TIMER or SEND_DATA_PARTY_TIMER._cancelled) then
			SEND_DATA_PARTY_TIMER = C_Timer.After(5, function()
				-- internally it avoids to resend until SEND_DATA_DELAY
				RareScanner:SendData(CHANNEL_RAID)
			end)
		end
	end
	
	self.numPlayers = GetNumGroupMembers()
end

local already_reported = {}
function RareScanner:ReportRareFound(npcID, vignetteInfo, coordinates)
	-- avoid spaming the same npc while jumping to another realm
	if (already_reported[npcID]) then
		return
	end

	local currentMap
	
	-- If its a NPC
	if (vignetteInfo.atlasName == RareScanner.NPC_VIGNETTE or vignetteInfo.atlasName == RareScanner.NPC_LEGION_VIGNETTE or vignetteInfo.atlasName == RareScanner.NPC_VIGNETTE_ELITE) then
		-- Extracts zoneID from database that its more accurate
		if (private.ZONE_IDS[npcID] and type(private.ZONE_IDS[npcID].zoneID) == "number" and private.ZONE_IDS[npcID].zoneID ~= 0) then
			currentMap = private.ZONE_IDS[npcID].zoneID
		-- If it shows up in different places, be sure that we got a good one
		elseif (private.ZONE_IDS[npcID] and type(private.ZONE_IDS[npcID].zoneID) == "table") then
			local playerCurrentMap = C_Map.GetBestMapForUnit("player")
			if (RS_tContains(private.ZONE_IDS[npcID], playerCurrentMap)) then
				currentMap = playerCurrentMap
			end
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	-- If its a container
	elseif (vignetteInfo.atlasName == RareScanner.CONTAINER_VIGNETTE or vignetteInfo.atlasName == RareScanner.CONTAINER_ELITE_VIGNETTE) then 
		-- Extracts zoneID from database that its more accurate
		if (private.CONTAINER_ZONE_IDS[npcID]) then
			currentMap = private.CONTAINER_ZONE_IDS[npcID].zoneID
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	-- If its an event
	elseif (vignetteInfo.atlasName == RareScanner.EVENT_VIGNETTE) then 
		-- Extracts zoneID from database that its more accurate
		if (private.EVENT_ZONE_IDS[npcID]) then
			currentMap = private.EVENT_ZONE_IDS[npcID].zoneID
		-- If we dont have it in our database gets the players map
		else
			currentMap = C_Map.GetBestMapForUnit("player")
		end
	end
	
	-- Ignore if incorrect mapID
	if (not currentMap or currentMap == 0) then
		return
	end
	
	-- If we got a list of zones, get the first one
	if (type (currentMap) == "table") then
		local i, v = next(currentMap, nil)
		currentMap = v
	end

	local vignettePosition = nil
	if (coordinates and coordinates.x and coordinates.y) then
		vignettePosition = coordinates
	else
		vignettePosition = C_VignetteInfo.GetVignettePosition(vignetteInfo.vignetteGUID, currentMap)
	end
	
	if (not vignettePosition) then
		return
	end
	
	local mapX = vignettePosition.x
	local mapY = vignettePosition.y
	local atlas = vignetteInfo.atlasName
	local art = C_Map.GetMapArtID(currentMap)
	
	-- If its already in our database, just update the timestamp and the new position
	if (private.dbglobal.rares_found[npcID]) then
		private.dbglobal.rares_found[npcID].foundTime = time()
		private.dbglobal.rares_found[npcID].coordX = mapX
		private.dbglobal.rares_found[npcID].coordY = mapY
		
		-- If we don't have artID add it
		if (not private.dbglobal.rares_found[npcID].artID) then
			private.dbglobal.rares_found[npcID].artID = art
		end
			
		RareScanner:PrintDebugMessage("DEBUG: Detectado NPC que ya habiamos localizado, se actualiza la fecha y sus coordenadas")
	else		
		private.dbglobal.rares_found[npcID] = { mapID = currentMap, coordX = mapX, coordY = mapY, atlasName = atlas, artID = art, foundTime = time() }
		RareScanner:PrintDebugMessage("DEBUG: Guardado en private.dbglobal.rares_found (ID: "..npcID.." MAPID: "..currentMap.." COORDX: "..mapX.." COORDY: "..mapY.." TIMESTAMP: "..time().." ATLASNAME: "..atlas.." ARTID: "..art)
	end

	-- Report to the GUILD, PARTY or RAID
	if (IsInGuild()) then
		local data = LibStub("AceSerializer-3.0"):Serialize({EVENT_NPC_FOUND, npcID, currentMap, mapX, mapY, atlas, time(), private.dbglobal.rares_loot[npcID] or {}, CHANNEL_GUILD, UnitName("player"), art})
		RareScanner:SendCommMessage(COMM_PREFIX, data, CHANNEL_GUILD)
	end
	if ((IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME)) and GetNumGroupMembers() > 1) then
		local data = LibStub("AceSerializer-3.0"):Serialize({EVENT_NPC_FOUND, npcID, currentMap, mapX, mapY, atlas, time(), private.dbglobal.rares_loot[npcID] or {}, IsInRaid(LE_PARTY_CATEGORY_HOME) and CHANNEL_RAID or CHANNEL_PARTY, UnitName("player"), art})
		RareScanner:SendCommMessage(COMM_PREFIX, data, IsInRaid(LE_PARTY_CATEGORY_HOME) and CHANNEL_RAID or CHANNEL_PARTY)
	end
	
	-- avoid reporting same rare
	already_reported[npcID] = true
	C_Timer.After(15, function() 
		already_reported[npcID] = nil
	end)
end

function RareScanner:DataReceived(_, data)
	-- Avoids receive too much information while in combat
	local status, dataDeserialized = LibStub("AceSerializer-3.0"):Deserialize(data)
	if (status) then
		if (not RareScanner:ValidateReceivedData(dataDeserialized)) then
			return
		end
		
		local event = dataDeserialized[1]
		if (event == EVENT_NPC_FOUND) then
			RareScanner:PrintDebugMessage("DEBUG: Te han enviado informacion de un rare")
			local npcID = dataDeserialized[2]
			local currentMap = dataDeserialized[3]
			local x = dataDeserialized[4]
			local y = dataDeserialized[5] 
			local atlas = dataDeserialized[6] 
			local timeStamp = dataDeserialized[7]
			local lootTable = dataDeserialized[8]
			local sourceChannel = dataDeserialized[9]
			local requestOwner = dataDeserialized[10]
			local art = dataDeserialized[11] 
			
			-- just in case its myself
			if (requestOwner == UnitName("player")) then
				RareScanner:PrintDebugMessage("DEBUG: La solicitud recibida es tuya... ignorala")
				return
			end
			
			RareScanner:PrintDebugMessage("DEBUG: Rare recibido (ID: "..npcID.." MAPID: "..currentMap.." COORDX: "..x.." COORDY: "..y.." TIMESTAMP: "..timeStamp.." ATLASNAME: "..atlas.." CHANNEL: "..sourceChannel.." USER: "..requestOwner.." ARTID: "..art)

			-- Add the rare to our found list
			if (not private.dbglobal.rares_found[npcID]) then
				-- only if not filtered
				if (next(private.db.general.filteredRares) ~= nil and private.db.general.filteredRares[npcID] == false) then
					RareScanner:PrintDebugMessage("DEBUG: Este raro lo estas filtrando por ID, se ignora")
				elseif (RareScanner:ZoneFiltered(npcID)) then
					RareScanner:PrintDebugMessage("DEBUG: Este raro lo estas filtrando por zona, se ignora")
				else
					RareScanner:PrintDebugMessage("DEBUG: No tenias a este raro, añadido a la base de datos")
					private.dbglobal.rares_found[npcID] = { mapID = currentMap, coordX = x, coordY = y, atlasName = atlas, artID = art, foundTime = timeStamp }
				end
			-- If its not killed updates the found time if its superior
			else
				if (not private.dbchar.rares_killed[npcID] and timeStamp > private.dbglobal.rares_found[npcID].foundTime) then
					RareScanner:PrintDebugMessage("DEBUG: Ya lo tenias pero con una hora mas vieja")
					private.dbglobal.rares_found[npcID].foundTime = timeStamp
				end				
			end
			-- Add the loot to our loot list
			if (lootTable and next(lootTable) ~= nil) then
				--RareScanner:PrintDebugMessage("DEBUG: Loot recibido "..unpack(lootTable))
				if (not private.dbglobal.rares_loot[npcID]) then
					private.dbglobal.rares_loot[npcID] = {}
				end
				
				for _,v in ipairs(lootTable) do 
					if (not InCombatLockdown()) then --avoid script ran too long error
						if (not RS_tContains(private.dbglobal.rares_loot[npcID], v)) then
							table.insert(private.dbglobal.rares_loot[npcID], v)
						end
					end
				end
			else
				RareScanner:PrintDebugMessage("DEBUG: No se ha recibido loot con el NPC")
			end
			
			-- Resend to other channels
			if (sourceChannel == CHANNEL_GUILD) then
				if ((IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME)) and GetNumGroupMembers() > 1) then
					-- Don't bother in dungeons/raids/pvp
					if (not IsInInstance()) then
						RareScanner:PrintDebugMessage("DEBUG: Enviado informacion del raro recien descubierto al grupo/raid")
						local newChannel = IsInRaid(LE_PARTY_CATEGORY_HOME) and CHANNEL_RAID or CHANNEL_PARTY
						local resendData = LibStub("AceSerializer-3.0"):Serialize({EVENT_NPC_FOUND, npcID, currentMap, x, y, atlas, timeStamp, private.dbglobal.rares_loot[npcID] or {}, newChannel, UnitName("player"), art})
						RareScanner:SendCommMessage(COMM_PREFIX, resendData, newChannel)
					end
				end
			elseif (sourceChannel == CHANNEL_PARTY or sourceChannel == CHANNEL_RAID) then
				if (IsInGuild()) then
					-- Important! avoid loop resending between group and guild if both 
					-- players from same guild share a group
					if (not RS_PlayerInGuild(requestOwner)) then
						RareScanner:PrintDebugMessage("DEBUG: Enviado informacion del raro recien descubierto a la hermandad")
						local resendData = LibStub("AceSerializer-3.0"):Serialize({EVENT_NPC_FOUND, npcID, currentMap, x, y, atlas, timeStamp, private.dbglobal.rares_loot[npcID] or {}, CHANNEL_GUILD, UnitName("player"), art})
						RareScanner:SendCommMessage(COMM_PREFIX, resendData, CHANNEL_GUILD)
					end
				end
			end
		elseif (event == EVENT_REQUEST_DATA) then
			RareScanner:PrintDebugMessage("DEBUG: Evento de solicitud de datos")
			local requestOwner = dataDeserialized[2]
			RareScanner:PrintDebugMessage("DEBUG: Solicitado por "..requestOwner)
			
			-- just in case its myself
			if (requestOwner == UnitName("player")) then
				RareScanner:PrintDebugMessage("DEBUG: La solicitud recibida es tuya... ignorala")
				return
			end
			
			-- otherwise send to the whole list
			RareScanner:SendData(CHANNEL_GUILD)
		elseif (event == EVENT_SEND_DATA) then
			RareScanner:PrintDebugMessage("DEBUG: Te han enviado una tabla de datos de raros")
			local responseData = dataDeserialized[2]
			local sourceChannel = dataDeserialized[3]
			RareScanner:PrintDebugMessage("DEBUG: Canal "..sourceChannel)
			local requestOwner = dataDeserialized[4]
			RareScanner:PrintDebugMessage("DEBUG: Lo envia "..requestOwner)
			
			-- avoid sending messages continuosly
			if (SEND_DATA_COOLDOWN and time() < SEND_DATA_COOLDOWN + SEND_DATA_COOLDOWN_DELAY) then
				RareScanner:PrintDebugMessage("DEBUG: Has enviado demasiados datos, no envia durante un rato")
				return
			end
			
			-- just in case its myself
			if (requestOwner == UnitName("player")) then
				RareScanner:PrintDebugMessage("DEBUG: La solicitud recibida es tuya... ignorala")
				return
			end
			
			-- dump the new data
			if (responseData) then
				for k, v in pairs (responseData) do
					RareScanner:PrintDebugMessage("NPC Recibido: "..k)
					if (not private.dbglobal.rares_found[k]) then
						private.dbglobal.rares_found[k] = { mapID = v.mapID, coordX = v.coordX, coordY = v.coordY, atlasName = v.atlasName, artID = v.artID, foundTime = v.foundTime }
						-- Add the loot to our loot list
						if (v.lootTable and next(v.lootTable) ~= nil) then
							--RareScanner:PrintDebugMessage("DEBUG: Loot recibido "..unpack(v.lootTable))
							if (not private.dbglobal.rares_loot[k]) then
								private.dbglobal.rares_loot[k] = {}
							end
							
							for _,l in ipairs(v.lootTable) do 
								if (not InCombatLockdown()) then --avoid script ran too long error
									if (not RS_tContains(private.dbglobal.rares_loot[k], l)) then
										table.insert(private.dbglobal.rares_loot[k], l)
									end
								end
							end
						else
							RareScanner:PrintDebugMessage("DEBUG: No se ha recibido loot con el NPC")
						end
			
						-- Resend it to the guild
						if (IsInGuild() and SEND_DATA_GUILD_COOLDOWN and time() < SEND_DATA_GUILD_COOLDOWN + SEND_DATA_DELAY) then
							-- Important! avoid loop resending between group and guild if both 
							-- players are sharing guild and group / it shouldn't ever happend
							-- in this scenario, but just in case
							if ((sourceChannel == CHANNEL_PARTY or sourceChannel == CHANNEL_RAID) and not RS_PlayerInGuild(requestOwner)) then
								RareScanner:PrintDebugMessage("DEBUG: Enviado informacion del raro recien descubierto a la hermandad")
								local resendData = LibStub("AceSerializer-3.0"):Serialize({EVENT_NPC_FOUND, k, v.mapID, v.coordX, v.coordY, v.atlasName, v.foundTime, v.lootTable, CHANNEL_GUILD, UnitName("player"), v.artID})
								RareScanner:SendCommMessage(COMM_PREFIX, resendData, CHANNEL_GUILD)
								SEND_DATA_COOLDOWN = time()
							else
								RareScanner:PrintDebugMessage("DEBUG: La persona que me ha pasado la informacion esta en mi grupo y es de mi hermandad. NO reenvio a la hermandad")
							end
						end
					elseif (private.dbglobal.rares_found[k] and not private.dbchar.rares_killed[k] and private.dbglobal.rares_found[k].foundTime < v.foundTime) then
						RareScanner:PrintDebugMessage("DEBUG: Lo tenia pero con una hora mas vieja, la actualizo")
						private.dbglobal.rares_found[k].foundTime = v.foundTime
					end
				end
			end
		end
	end
end
RareScanner:RegisterComm(COMM_PREFIX, "DataReceived")

function RareScanner:SendData(channel)
	if (channel == CHANNEL_GUILD) then
		if (not IsInGuild()) then
			RareScanner:PrintDebugMessage("DEBUG: No perteneces a una hermandad, no hay a quien enviar datos")
			return
		elseif (SEND_DATA_GUILD_COOLDOWN and time() < SEND_DATA_GUILD_COOLDOWN + SEND_DATA_DELAY) then
			RareScanner:PrintDebugMessage("DEBUG: No han pasado 30 segundos desde tu ultimo envio a la party, esperamos un poco")
			return
		end
	elseif (channel == CHANNEL_RAID) then
		if (not IsInGroup(LE_PARTY_CATEGORY_HOME) and not IsInRaid(LE_PARTY_CATEGORY_HOME)) then
			RareScanner:PrintDebugMessage("DEBUG: No estas en un grupo/raid creado manualmente, no se envian datos")
			return
		elseif (SEND_DATA_PARTY_COOLDOWN and time() < SEND_DATA_PARTY_COOLDOWN + SEND_DATA_DELAY) then
			RareScanner:PrintDebugMessage("DEBUG: No han pasado 30 segundos desde tu ultimo envio a la party, no se envian datos")
			return
		end
		local isInstance, instanceType = IsInInstance()
		
		-- don't bother in instances
		if (isInstance) then
			if (SEND_DATA_PARTY_TIMER) then
				RareScanner:PrintDebugMessage("DEBUG: En instancia, desactivo SPAM hasta que haya un cambio de la raid")
				SEND_DATA_PARTY_TIMER:Cancel()
				return
			end
		end
	end
	
	-- avoid sending messages continuosly
	if (SEND_DATA_COOLDOWN and time() < SEND_DATA_COOLDOWN + SEND_DATA_COOLDOWN_DELAY) then
		return
	end

	RareScanner:PrintDebugMessage("DEBUG: Enviado datos por el canal "..channel)
	if (next(private.dbglobal.rares_found) ~= nil) then
		RareScanner:PrintDebugMessage("DEBUG: Se han encontrado datos que enviar")
		
		local dataTable = {}
		for k, v in pairs(private.dbglobal.rares_found) do
			-- only takes into account rares found before 30 minutes
			if (time() - v.foundTime <= _30_MINUTES) then
				RareScanner:PrintDebugMessage("Empaquetando "..k.." que fue encontrado hace menos de 30 minutos")
				dataTable[k] = { mapID = v.mapID, coordX = v.coordX, coordY = v.coordY, atlasName = v.atlasName, artID = v.artID, foundTime = v.foundTime, lootTable = private.dbglobal.rares_loot[k] or {} }
			end
		end
		
		if (channel == CHANNEL_RAID) then
			if ((IsInGroup(LE_PARTY_CATEGORY_HOME) or IsInRaid(LE_PARTY_CATEGORY_HOME)) and GetNumGroupMembers() > 1) then
				RareScanner:PrintDebugMessage("DEBUG: Enviado mensaje a grupo/raid")
				local newChannel = IsInRaid(LE_PARTY_CATEGORY_HOME) and CHANNEL_RAID or CHANNEL_PARTY
				local data = LibStub("AceSerializer-3.0"):Serialize({EVENT_SEND_DATA, dataTable, newChannel, UnitName("player")})
				RareScanner:SendCommMessage(COMM_PREFIX, data, newChannel)
				SEND_DATA_PARTY_COOLDOWN = time()
				SEND_DATA_COOLDOWN = time()
			end
		else
			RareScanner:PrintDebugMessage("DEBUG: Enviado mensaje a hermandad")
			local data = LibStub("AceSerializer-3.0"):Serialize({EVENT_SEND_DATA, dataTable, CHANNEL_GUILD, UnitName("player")})
			RareScanner:SendCommMessage(COMM_PREFIX, data, channel)
			SEND_DATA_GUILD_COOLDOWN = time()
			SEND_DATA_COOLDOWN = time()
		end
	else
		RareScanner:PrintDebugMessage("DEBUG: No hay datos que enviar")
	end
end

function RareScanner:ValidateReceivedData(data)
	if (not data[1]) then
		RareScanner:PrintDebugMessage("DEBUG: No se ha recibido el evento.")
		return
	end
	RareScanner:PrintDebugMessage("DEBUG: Evento recibido "..data[1])
	if (data[1] == EVENT_NPC_FOUND) then
		if (not data[2] or type (data[2]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el npcID (number) en la posicion 2")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[2] or ''))
			return
		elseif (not data[3] or type (data[3]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el mapID (number) en la posicion 3")
			if (data[3] and type (data[3]) ~= "table") then
				RareScanner:PrintDebugMessage("DEBUG: "..(data[3] or ''))
			else
				RareScanner:PrintDebugMessage("DEBUG: Recibida tabla en lugar del mapID en la posicion 3")
			end
			return
		elseif (not data[4] or type (data[4]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el x (number) en la posicion 4")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[4] or ''))
			return
		elseif (not data[5] or type (data[5]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el y (number) en la posicion 5")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[5] or ''))
			return
		elseif (not data[6] or type (data[6]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el atlasName (string) en la posicion 6")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[6] or ''))
			return
		elseif (not data[7] or type (data[7]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el timeStamp (number) en la posicion 7")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[7] or ''))
			return
		elseif (data[8] and type (data[8]) ~= "table") then --not mandatory
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el lootTable (table) en la posicion 8")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[8] or ''))
			return
		elseif (not data[9] or type (data[9]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el sourceChannel (string) en la posicion 9")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[9] or ''))
			return
		elseif (not data[10] or type (data[10]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el requestOwner (string) en la posicion 10")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[10] or ''))
			return
		elseif (not data[11] or type (data[11]) ~= "number") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND No recibido el artID (number) en la posicion 11")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[11] or ''))
			return
		end
		
		if (data[8]) then
			local errorFound = false;
			for i, itemID in ipairs (data[8]) do
				if (type (itemID) ~= "number" or itemID == 0) then
					RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND Identificador de item recibido erroneo (number)")
					RareScanner:PrintDebugMessage("DEBUG: "..(itemID or ''))
					errorFound = true
					break;
				end
			end
			
			if (errorFound) then
				return
			end
		end
	
		return true
	end

	if (data[1] == EVENT_REQUEST_DATA) then
		if (not data[2] or type (data[2]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_REQUEST_DATA No recibido el requestOwner (string) en la posicion 2")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[2] or ''))
			return
		end
		
		return true
	end
	
	if (data[1] == EVENT_SEND_DATA) then
		if (not data[2] or type (data[2]) ~= "table") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido el responseData (string) en la posicion 2")
			pRareScanner:PrintDebugMessage("DEBUG: "..(data[2] or ''))
			return
		elseif (not data[3] or type (data[3]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido el sourceChannel (string) en la posicion 3")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[3] or ''))
			return
		elseif (not data[4] or type (data[4]) ~= "string") then
			RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido el requestOwner (string) en la posicion 4")
			RareScanner:PrintDebugMessage("DEBUG: "..(data[4] or ''))
			return
		end
		
		for k, v in pairs (data[2]) do
			if (not k or type (k) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el npcID (number) en la clave K")
				RareScanner:PrintDebugMessage("DEBUG: "..(k or ''))
				return
			elseif (not v or type (v) ~= "table") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData la informacion del npc (table) en el valor V")
				RareScanner:PrintDebugMessage("DEBUG: "..(v or ''))
				return
			elseif (not v.mapID or type (v.mapID) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el mapID (number)")
				if (v.mapID and type (v.mapID) ~= "table") then
					RareScanner:PrintDebugMessage("DEBUG: "..(v.mapID or ''))
				else
					RareScanner:PrintDebugMessage("DEBUG: Recibida tabla en lugar del mapID")
				end
				return
			elseif (not v.coordX or type (v.coordX) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el x (number)")
				RareScanner:PrintDebugMessage("DEBUG: "..(v.coordX or ''))
				return
			elseif (not v.coordY or type (v.coordY) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el y (number)")
				RareScanner:PrintDebugMessage("DEBUG: "..(v.coordY or ''))
				return
			elseif (not v.atlasName or type (v.atlasName) ~= "string") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el atlasName (string)")
				RareScanner:PrintDebugMessage("DEBUG: "..(v.atlasName or ''))
				return
			elseif (not v.artID or type (v.artID) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el artID (number)")
				RareScanner:PrintDebugMessage("DEBUG: "..(v.artID or ''))
				return
			elseif (not v.foundTime or type (v.foundTime) ~= "number") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA No recibido en el responseData el foundTime (number)")
				RareScanner:PrintDebugMessage("DEBUG: "..(v.foundTime or ''))
				return
			elseif (v.lootTable and type (v.lootTable) ~= "table") then
				RareScanner:PrintDebugMessage("DEBUG: EVENT_SEND_DATA Recibido en el responseData el lootTable con formato incorrecto (table)")
				RareScanner:PrintDebugMessage("DEBUG: "..(unpack(v.lootTable) or ''))
				return
			end
			
			if (v.lootTable) then
				local errorFound = false;
				for i, itemID in ipairs (v.lootTable) do
					if (type (itemID) ~= "number" or itemID == 0) then
						RareScanner:PrintDebugMessage("DEBUG: EVENT_NPC_FOUND Identificador de item recibido erroneo (number)")
						RareScanner:PrintDebugMessage("DEBUG: "..(itemID or ''))
						errorFound = true
						break;
					end
				end
				
				if (errorFound) then
					return
				end
			end
		end

		return true
	end
end


-----------------------------------
----- Auxiliar functions
-----------------------------------

function RS_PlayerInGuild(guildy_name)
	if (guildiesNames) then
		for i, name in ipairs(guildiesNames) do
			if (RS_tContains(name, guildy_name.."-")) then
				RareScanner:PrintDebugMessage("DEBUG: Detectado que el jugador "..guildy_name.." pertenece a tu misma hermandad") 
				return true
			end
		end
		
		RareScanner:PrintDebugMessage("DEBUG: Detectado que el jugador "..guildy_name.." es de otra hermandad")
		return false
	else
		RareScanner:PrintDebugMessage("DEBUG: No se ha podido comprobar si el jugador "..guildy_name.." pertenece a tu misma hermandad")
	
		GuildRoster()
		return false
	end
end