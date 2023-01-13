
do

	local _detalhes = _G._detalhes
	local addonName, Details222 = ...
	_detalhes.EncounterInformation = {}
	local ipairs = ipairs --lua local

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--details api functions

	--return if the player is inside a raid supported by details
	function _detalhes:IsInInstance()
		local _, _, _, _, _, _, _, zoneMapID = GetInstanceInfo()
		if (_detalhes.EncounterInformation [zoneMapID]) then
			return true
		else
			return false
		end
	end

	--return the full table with all data for the instance
	function _detalhes:GetRaidInfoFromEncounterID (encounterID, encounterEJID)
		for id, raidTable in pairs(_detalhes.EncounterInformation) do
			if (encounterID) then
				local ids = raidTable.encounter_ids2 --combatlog
				if (ids) then
					if (ids [encounterID]) then
						return raidTable
					end
				end
			end
			if (encounterEJID) then
				local ejids = raidTable.encounter_ids --encounter journal
				if (ejids) then
					if (ejids [encounterEJID]) then
						return raidTable
					end
				end
			end
		end
	end

	--return the ids of trash mobs in the instance
	function _detalhes:GetInstanceTrashInfo (mapid)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].trash_ids
	end

	function _detalhes:GetInstanceIdFromEncounterId (encounterid)
		for id, instanceTable in pairs(_detalhes.EncounterInformation) do
			--combatlog encounter id
			local ids = instanceTable.encounter_ids2
			if (ids) then
				if (ids [encounterid]) then
					return id
				end
			end
			--encounter journal id
			local ids_ej = instanceTable.encounter_ids
			if (ids) then
				if (ids_ej [encounterid]) then
					return id
				end
			end
		end
	end

	--return the boss table using a encounter id
	function _detalhes:GetBossEncounterDetailsFromEncounterId (mapid, encounterid)
		if (not mapid) then
			local bossIndex, instance
			for id, instanceTable in pairs(_detalhes.EncounterInformation) do
				local ids = instanceTable.encounter_ids2
				if (ids) then
					bossIndex = ids [encounterid]
					if (bossIndex) then
						instance = instanceTable
						break
					end
				end
			end

			if (instance) then
				local bosses = instance.encounters
				if (bosses) then
					return bosses [bossIndex], instance
				end
			end

			return
		end

		local bossindex = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounter_ids and _detalhes.EncounterInformation [mapid].encounter_ids [encounterid]
		if (bossindex) then
			return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex], bossindex
		else
			local bossindex = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounter_ids2 and _detalhes.EncounterInformation [mapid].encounter_ids2 [encounterid]
			if (bossindex) then
				return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex], bossindex
			end
		end
	end

	--return the EJ boss id
	function _detalhes:GetEncounterIdFromBossIndex (mapid, index)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounter_ids and _detalhes.EncounterInformation [mapid].encounter_ids [index]
	end

	--return the table which contain information about the start of a encounter
	function _detalhes:GetEncounterStartInfo (mapid, encounterid)
		local bossindex = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounter_ids and _detalhes.EncounterInformation [mapid].encounter_ids [encounterid]
		if (bossindex) then
			return _detalhes.EncounterInformation [mapid].encounters [bossindex] and _detalhes.EncounterInformation [mapid].encounters [bossindex].encounter_start
		end
	end

	--return the table which contain information about the end of a encounter
	function _detalhes:GetEncounterEndInfo (mapid, encounterid)
		local bossindex = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounter_ids and _detalhes.EncounterInformation [mapid].encounter_ids [encounterid]
		if (bossindex) then
			return _detalhes.EncounterInformation [mapid].encounters [bossindex] and _detalhes.EncounterInformation [mapid].encounters [bossindex].encounter_end
		end
	end

	--return the function for the boss
	function _detalhes:GetEncounterEnd (mapid, bossindex)
		local t = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex]
		if (t) then
			local _end = t.combat_end
			if (_end) then
				return unpack(_end)
			end
		end
		return
	end

	--generic boss find function
	function _detalhes:GetRaidBossFindFunction (mapid)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].find_boss_encounter
	end

	--return if the boss need sync
	function _detalhes:GetEncounterEqualize (mapid, bossindex)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex] and _detalhes.EncounterInformation [mapid].encounters [bossindex].equalize
	end

	--return the function for the boss
	function _detalhes:GetBossFunction (mapid, bossindex)
		local func = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex] and _detalhes.EncounterInformation [mapid].encounters [bossindex].func
		if (func) then
			return func, _detalhes.EncounterInformation [mapid].encounters [bossindex].funcType
		end
		return
	end

	--return the boss table with information about name, adds, spells, etc
	function _detalhes:GetBossDetails (mapid, bossindex)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex]
	end

	--return a table with all names of boss enemies
	function _detalhes:GetEncounterActors (mapid, bossindex)

	end

	--return a table with spells id of specified encounter
	function _detalhes:GetEncounterSpells (mapid, bossindex)
		local encounter = _detalhes:GetBossDetails (mapid, bossindex)
		local habilidades_poll = {}
		if (encounter.continuo) then
			for index, spellid in ipairs(encounter.continuo) do
				habilidades_poll [spellid] = true
			end
		end
		local fases = encounter.phases
		if (fases) then
			for fase_id, fase in ipairs(fases) do
				if (fase.spells) then
					for index, spellid in ipairs(fase.spells) do
						habilidades_poll [spellid] = true
					end
				end
			end
		end
		return habilidades_poll
	end

	--return a table with all boss ids from a raid instance
	function _detalhes:GetBossIds (mapid)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].boss_ids
	end

	function _detalhes:InstanceIsRaid (mapid)
		return _detalhes:InstanceisRaid (mapid)
	end
	function _detalhes:InstanceisRaid (mapid)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].is_raid
	end

	--return a table with all encounter names present in raid instance
	function _detalhes:GetBossNames (mapid)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].boss_names
	end

	--return the encounter name
	function _detalhes:GetBossName (mapid, bossindex)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].boss_names [bossindex]
	end

	--same thing as GetBossDetails, just a alias
	function _detalhes:GetBossEncounterDetails (mapid, bossindex)
		return _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex]
	end



	function _detalhes:GetEncounterInfoFromEncounterName (EJID, encountername)
		DetailsFramework.EncounterJournal.EJ_SelectInstance (EJID) --11ms per call
		for i = 1, 20 do
			local name = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, EJID)
			if (not name) then
				return
			end
			if (name == encountername or name:find(encountername)) then
				return i, DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, EJID)
			end
		end
	end

	--return the wallpaper for the raid instance
	function _detalhes:GetRaidBackground (mapid)
		local bosstables = _detalhes.EncounterInformation [mapid]
		if (bosstables) then
			local bg = bosstables.backgroundFile
			if (bg) then
				return bg.file, unpack(bg.coords)
			end
		end
	end
	--return the icon for the raid instance
	function _detalhes:GetRaidIcon (mapid, ejID, instanceType)
		local raidIcon = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].icon
		if (raidIcon) then
			return raidIcon
		end

		if (ejID and ejID ~= 0) then
			local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (ejID)
			if (name) then
				if (instanceType == "party") then
					return loreImage --bgImage
				elseif (instanceType == "raid") then
					return loreImage
				end
			end
		end

		return nil
	end

	function _detalhes:GetBossIndex (mapid, encounterCLID, encounterEJID, encounterName)
		local raidInfo = _detalhes.EncounterInformation [mapid]
		if (raidInfo) then
			local index = raidInfo.encounter_ids2 [encounterCLID] or raidInfo.encounter_ids [encounterEJID]
			if (not index) then
				for i = 1, #raidInfo.boss_names do
					if (raidInfo.boss_names [i] == encounterName) then
						index = i
						break
					end
				end
			end
			return index
		end
	end

	--return the boss icon
	function _detalhes:GetBossIcon (mapid, bossindex)
		if (_detalhes.EncounterInformation [mapid]) then
			local line = math.ceil (bossindex / 4)
			local x = ( bossindex - ( (line-1) * 4 ) )  / 4
			return x-0.25, x, 0.25 * (line-1), 0.25 * line, _detalhes.EncounterInformation [mapid].icons
		end
	end

	--return the boss portrit
	function _detalhes:GetBossPortrait(mapid, bossindex, encounterName, ejID)
		if (mapid and bossindex) then
			local haveIcon = _detalhes.EncounterInformation [mapid] and _detalhes.EncounterInformation [mapid].encounters [bossindex] and _detalhes.EncounterInformation [mapid].encounters [bossindex].portrait
			if (haveIcon) then
				return haveIcon
			end
		end

		if (encounterName and ejID and ejID ~= 0) then
			local index, name, description, encounterID, rootSectionID, link = _detalhes:GetEncounterInfoFromEncounterName (ejID, encounterName)

			if (index and name and encounterID) then
				local id, name, description, displayInfo, iconImage = DetailsFramework.EncounterJournal.EJ_GetCreatureInfo (1, encounterID)
				if (iconImage) then
					return iconImage
				end
			end
		end

		return nil
	end

	--return a list with names of adds and bosses
	function _detalhes:GetEncounterActorsName (EJ_EncounterID)
		--code snippet from wowpedia
		local actors = {}
		local stack, encounter, _, _, curSectionID = {}, DetailsFramework.EncounterJournal.EJ_GetEncounterInfo (EJ_EncounterID)

		if (not curSectionID) then
			return actors
		end

		repeat
			local title, description, depth, abilityIcon, displayInfo, siblingID, nextSectionID, filteredByDifficulty, link, startsOpen, flag1, flag2, flag3, flag4 = DetailsFramework.EncounterJournal.EJ_GetSectionInfo (curSectionID)
			if (displayInfo ~= 0 and abilityIcon == "") then
				actors [title] = {model = displayInfo, info = description}
			end
			table.insert(stack, siblingID)
			table.insert(stack, nextSectionID)
			curSectionID = table.remove (stack)
		until not curSectionID

		return actors
	end

	function _detalhes:GetInstanceEJID (mapid)
		mapid = mapid or select(8, GetInstanceInfo())
		if (mapid) then
			local instance_info = _detalhes.EncounterInformation [mapid]
			if (instance_info) then
				return instance_info.ej_id or 0
			end
		end
		return 0
	end

	function _detalhes:GetCurrentDungeonBossListFromEJ()

		local mapID = C_Map.GetBestMapForUnit ("player")

		if (not mapID) then
			--print("Details! exeption handled: zone has no map")
			return
		end

		local EJ_CInstance = DetailsFramework.EncounterJournal.EJ_GetInstanceForMap(mapID)

		if (EJ_CInstance and EJ_CInstance ~= 0) then
			if (_detalhes.encounter_dungeons [EJ_CInstance]) then
				return _detalhes.encounter_dungeons [EJ_CInstance]
			end

			DetailsFramework.EncounterJournal.EJ_SelectInstance (EJ_CInstance)

			local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (EJ_CInstance)

			local boss_list = {
				[EJ_CInstance] = {name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link}
			}

			for i = 1, 20 do
				local encounterName, description, encounterID, rootSectionID, link = DetailsFramework.EncounterJournal.EJ_GetEncounterInfoByIndex (i, EJ_CInstance)
				if (encounterName) then
					for o = 1, 6 do
						local id, creatureName, creatureDescription, displayInfo, iconImage = DetailsFramework.EncounterJournal.EJ_GetCreatureInfo (o, encounterID)
						if (id) then
							boss_list [creatureName] = {encounterName, encounterID, creatureName, iconImage, EJ_CInstance}
						else
							break
						end
					end
				else
					break
				end
			end

			_detalhes.encounter_dungeons [EJ_CInstance] = boss_list

			return boss_list
		end
	end

	function _detalhes:IsRaidRegistered(mapid)
		return _detalhes.EncounterInformation [mapid] and true
	end


	function Details:GetExpansionBossList() --~bosslist
		local bossIndexedTable = {}
		local bossInfoTable = {} --[bossId] = bossInfo
		local raidInfoTable = {}

		if (not EncounterJournal_LoadUI) then
			return bossIndexedTable, bossInfoTable, raidInfoTable
		end

		if (not EncounterJournal) then
			EncounterJournal_LoadUI()
		end

		for instanceIndex = 10, 2, -1 do
			local raidInstanceID, instanceName, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID = EJ_GetInstanceByIndex(instanceIndex, true)
			if (raidInstanceID) then
				EncounterJournal_DisplayInstance(raidInstanceID)

				raidInfoTable[raidInstanceID] = {
					raidName = instanceName,
					raidIcon = buttonImage1,
					raidIconCoords = {0.01, .67, 0.025, .725},
					raidIconSize = {70, 36},
					raidIconTexture = buttonImage2,
					raidIconTextureCoords = {0, 1, 0, 0.95},
					raidIconTextureSize = {70, 36},
					raidIconLore = loreImage,
					raidIconLoreCoords = {0, 1, 0, 0.95},
					raidIconLoreSize = {70, 36},
					raidMapID = dungeonAreaMapID,
					raidEncounters = {},
				}

				for i = 20, 1, -1 do
					local name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, UiMapID = _G.EJ_GetEncounterInfoByIndex(i, raidInstanceID)
					if (name) then
						local id, creatureName, creatureDescription, displayInfo, iconImage = EJ_GetCreatureInfo(1, journalEncounterID)
						local thisbossIndexedTable = {
							bossName = name,
							journalEncounterID = journalEncounterID,
							bossRaidName = instanceName,
							bossIcon = iconImage,
							bossIconCoords = {0, 1, 0, 0.95},
							bossIconSize = {70, 36},
							instanceId = raidInstanceID,
							uiMapId = UiMapID,
							instanceIndex = instanceIndex,
							journalInstanceId = journalInstanceID,
							dungeonEncounterID = dungeonEncounterID,
						}
						bossIndexedTable[#bossIndexedTable+1] = thisbossIndexedTable
						bossInfoTable[journalEncounterID] = thisbossIndexedTable
					end
				end
			end
		end

		return bossIndexedTable, bossInfoTable, raidInfoTable
	end

	function Details222.EJCache.GetInstanceData(...)
		for i = 1, select("#", ...) do
			local value = select(i, ...)
			local instanceData = Details222.EJCache.GetInstanceDataByName(value) or Details222.EJCache.GetInstanceDataByInstanceId(value) or Details222.EJCache.GetInstanceDataByMapId(value)
			if (instanceData) then
				return instanceData
			end
		end
	end

	function Details222.EJCache.GetEncounterDataFromInstanceData(instanceData, ...)
		if (not instanceData) then
			if (Details.debug) then
				Details:Msg("GetEncounterDataFromInstanceData expects instanceData on first parameter.")
			end
		end

		for i = 1, select("#", ...) do
			local value = select(i, ...)
			if (value) then
				local encounterData = instanceData.encountersArray[value]
				if (encounterData) then
					return encounterData
				end

				encounterData = instanceData.encountersByName[value]
				if (encounterData) then
					return encounterData
				end

				encounterData = instanceData.encountersByDungeonEncounterId[value]
				if (encounterData) then
					return encounterData
				end

				encounterData = instanceData.encountersByJournalEncounterId[value]
				if (encounterData) then
					return encounterData
				end
			end
		end
	end

	function Details222.EJCache.GetInstanceDataByName(instanceName)
		local raidData = Details222.EJCache.CacheRaidData_ByInstanceName[instanceName]
		local dungeonData = Details222.EJCache.CacheDungeonData_ByInstanceName[instanceName]
		return raidData or dungeonData
	end
	function Details222.EJCache.GetInstanceDataByInstanceId(instanceId)
		local raidData = Details222.EJCache.CacheRaidData_ByInstanceId[instanceId]
		local dungeonData = Details222.EJCache.CacheDungeonData_ByInstanceId[instanceId]
		return raidData or dungeonData
	end
	function Details222.EJCache.GetInstanceDataByMapId(mapId)
		local raidData = Details222.EJCache.CacheRaidData_ByMapId[mapId]
		local dungeonData = Details222.EJCache.CacheDungeonData_ByMapId[mapId]
		return raidData or dungeonData
	end

	function Details222.EJCache.GetRaidDataByName(instanceName)
		return Details222.EJCache.CacheRaidData_ByInstanceName[instanceName]
	end
	function Details222.EJCache.GetRaidDataByInstanceId(instanceId)
		return Details222.EJCache.CacheRaidData_ByInstanceId[instanceId]
	end
	function Details222.EJCache.GetRaidDataByMapId(instanceId)
		return Details222.EJCache.CacheRaidData_ByMapId[instanceId]
	end

	function Details222.EJCache.GetDungeonDataByName(instanceName)
		return Details222.EJCache.CacheDungeonData_ByInstanceName[instanceName]
	end
	function Details222.EJCache.GetDungeonDataByInstanceId(instanceId)
		return Details222.EJCache.CacheDungeonData_ByInstanceId[instanceId]
	end
	function Details222.EJCache.GetDungeonDataByMapId(instanceId)
		return Details222.EJCache.CacheDungeonData_ByMapId[instanceId]
	end

	function Details222.EJCache.MakeCache()
		Details222.EJCache.CacheRaidData_ByInstanceId = {}
		Details222.EJCache.CacheRaidData_ByInstanceName = {} --this is localized name
		Details222.EJCache.CacheRaidData_ByMapId = {} --retrivied from GetInstanceInfo()

		Details222.EJCache.CacheDungeonData_ByInstanceId = {}
		Details222.EJCache.CacheDungeonData_ByInstanceName = {}
		Details222.EJCache.CacheDungeonData_ByMapId = {}

		--exit this function if is classic wow using DetailsFramework
		if (DetailsFramework.IsClassicWow()) then
			return
		end

		if (not EncounterJournal_LoadUI) then
			return
		end

		--todo generate encounter spells cache

		--delay the cache createation as it is not needed right away
		--createEJCache() will check if encounter journal is loaded, if not it will load it and then create the cache
		local createEJCache = function()
			--check if the encounter journal added is loaded
			if (not EncounterJournal) then
				--local startTime = debugprofilestop()
				EncounterJournal_LoadUI()
				--local endTime = debugprofilestop()
				--print("DE loading EJ:", endTime - startTime)
			end

			hooksecurefunc("EncounterJournal_OpenJournalLink", Details222.EJCache.OnClickEncounterJournalLink)

			do
				--iterate among all raid instances, by passing true in the second argument of EJ_GetInstanceByIndex, indicates to the API we want to get raid instances
				local bGetRaidInstances = true

				EncounterJournalRaidTab:Click()
				EncounterJournal_TierDropDown_Select(_, 10) --select Dragonflight

				for instanceIndex = 10, 2, -1 do
					local journalInstanceID, instanceName, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID = EJ_GetInstanceByIndex(instanceIndex, bGetRaidInstances)

					if (journalInstanceID) then
						--tell the encounter journal to display the raid instance by the instanceId
						EncounterJournal_DisplayInstance(journalInstanceID)

						--build a table with data of the raid instance
						local instanceData = {
							name = instanceName,
							mapId = dungeonAreaMapID,
							bgImage = bgImage,
							instanceId = journalInstanceID,

							encountersArray = {},
							encountersByName = {},
							encountersByDungeonEncounterId = {},
							encountersByJournalEncounterId = {},

							icon = buttonImage1,
							iconSize = {70, 36},
							iconCoords = {0.01, .67, 0.025, .725},

							iconLore = loreImage,
							iconLoreSize = {70, 36},
							iconLoreCoords = {0, 1, 0, 0.95},

							iconTexture = buttonImage2,
							iconTextureSize = {70, 36},
							iconTextureCoords = {0, 1, 0, 0.95},
						}

						--cache the raidData on different tables using different indexes
						Details222.EJCache.CacheRaidData_ByInstanceId[journalInstanceID] = instanceData
						Details222.EJCache.CacheRaidData_ByInstanceName[instanceName] = instanceData
						Details222.EJCache.CacheRaidData_ByMapId[dungeonAreaMapID] = instanceData

						for encounterIndex = 1, 20 do
							local name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, UiMapID = _G.EJ_GetEncounterInfoByIndex(encounterIndex, journalInstanceID)
							if (name) then

								local encounterData = {
									name = name,
									mapId = dungeonAreaMapID,
									uiMapId = UiMapID,
									dungeonEncounterId = dungeonEncounterID,
									journalEncounterId = journalEncounterID,
									journalInstanceId = journalInstanceID,
								}

								local journalEncounterCreatureId, creatureName, creatureDescription, creatureDisplayID, iconImage, uiModelSceneID = EJ_GetCreatureInfo(1, journalEncounterID)
								if (journalEncounterCreatureId) then
									encounterData.creatureName = creatureName
									encounterData.creatureIcon = iconImage
									encounterData.creatureId = journalEncounterCreatureId
									encounterData.creatureDisplayId = creatureDisplayID
									encounterData.creatureUIModelSceneId = uiModelSceneID
								end

								instanceData.encountersArray[#instanceData.encountersArray+1] = encounterData
								instanceData.encountersByName[name] = encounterData
								instanceData.encountersByDungeonEncounterId[dungeonEncounterID] = encounterData
								instanceData.encountersByJournalEncounterId[journalEncounterID] = encounterData
							end
						end
					end
				end
			end

			do
				local bGetRaidInstances = false
				EncounterJournalDungeonTab:Click()
				EncounterJournal_TierDropDown_Select(_, 11) --select mythic+

				for instanceIndex = 20, 1, -1 do
					local journalInstanceID, instanceName, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID = EJ_GetInstanceByIndex(instanceIndex, bGetRaidInstances)

					if (journalInstanceID) then
						--tell the encounter journal to display the dungeon instance by the instanceId
						EncounterJournal_DisplayInstance(journalInstanceID)

						--build a table with data of the raid instance
						local instanceData = {
							name = instanceName,
							mapId = dungeonAreaMapID,
							bgImage = bgImage,
							instanceId = journalInstanceID,

							encountersArray = {},
							encountersByName = {},
							encountersByDungeonEncounterId = {},
							encountersByJournalEncounterId = {},

							icon = buttonImage1,
							iconSize = {70, 36},
							iconCoords = {0.01, .67, 0.025, .725},

							iconLore = loreImage,
							iconLoreSize = {70, 36},
							iconLoreCoords = {0, 1, 0, 0.95},

							iconTexture = buttonImage2,
							iconTextureSize = {70, 36},
							iconTextureCoords = {0, 1, 0, 0.95},
						}

						--cache the raidData on different tables using different indexes
						Details222.EJCache.CacheDungeonData_ByInstanceId[journalInstanceID] = instanceData
						Details222.EJCache.CacheDungeonData_ByInstanceName[instanceName] = instanceData
						Details222.EJCache.CacheDungeonData_ByMapId[dungeonAreaMapID] = instanceData

						--iterate among all encounters of the dungeon instance
						for encounterIndex = 1, 20 do
							local name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, UiMapID = _G.EJ_GetEncounterInfoByIndex(encounterIndex, journalInstanceID)
							if (name) then

								local encounterData = {
									name = name,
									mapId = dungeonAreaMapID,
									uiMapId = UiMapID,
									dungeonEncounterId = dungeonEncounterID,
									journalEncounterId = journalEncounterID,
									journalInstanceId = journalInstanceID,
								}

								local journalEncounterCreatureId, creatureName, creatureDescription, creatureDisplayID, iconImage, uiModelSceneID = EJ_GetCreatureInfo(1, journalEncounterID)
								if (journalEncounterCreatureId) then
									encounterData.creatureName = creatureName
									encounterData.creatureIcon = iconImage
									encounterData.creatureId = journalEncounterCreatureId
									encounterData.creatureDisplayId = creatureDisplayID
									encounterData.creatureUIModelSceneId = uiModelSceneID
								end

								instanceData.encountersArray[#instanceData.encountersArray+1] = encounterData
								instanceData.encountersByName[name] = encounterData
								instanceData.encountersByDungeonEncounterId[dungeonEncounterID] = encounterData
								instanceData.encountersByJournalEncounterId[journalEncounterID] = encounterData
							end
						end
					end
				end

				EncounterJournal_TierDropDown_Select(_, 10) --select Dragonflight

				for instanceIndex = 20, 1, -1 do
					local journalInstanceID, instanceName, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID = EJ_GetInstanceByIndex(instanceIndex, bGetRaidInstances)

					if (journalInstanceID and not Details222.EJCache.CacheDungeonData_ByInstanceId[journalInstanceID]) then
						--tell the encounter journal to display the dungeon instance by the instanceId
						EncounterJournal_DisplayInstance(journalInstanceID)

						--build a table with data of the raid instance
						local instanceData = {
							name = instanceName,
							mapId = dungeonAreaMapID,
							bgImage = bgImage,
							instanceId = journalInstanceID,

							encountersArray = {},
							encountersByName = {},
							encountersByDungeonEncounterId = {},
							encountersByJournalEncounterId = {},

							icon = buttonImage1,
							iconSize = {70, 36},
							iconCoords = {0.01, .67, 0.025, .725},

							iconLore = loreImage,
							iconLoreSize = {70, 36},
							iconLoreCoords = {0, 1, 0, 0.95},

							iconTexture = buttonImage2,
							iconTextureSize = {70, 36},
							iconTextureCoords = {0, 1, 0, 0.95},
						}

						--cache the raidData on different tables using different indexes
						Details222.EJCache.CacheDungeonData_ByInstanceId[journalInstanceID] = instanceData
						Details222.EJCache.CacheDungeonData_ByInstanceName[instanceName] = instanceData
						Details222.EJCache.CacheDungeonData_ByMapId[dungeonAreaMapID] = instanceData

						--iterate among all encounters of the dungeon instance
						for encounterIndex = 1, 20 do
							local name, description, journalEncounterID, rootSectionID, link, journalInstanceID, dungeonEncounterID, UiMapID = _G.EJ_GetEncounterInfoByIndex(encounterIndex, journalInstanceID)
							if (name) then

								local encounterData = {
									name = name,
									mapId = dungeonAreaMapID,
									uiMapId = UiMapID,
									dungeonEncounterId = dungeonEncounterID,
									journalEncounterId = journalEncounterID,
									journalInstanceId = journalInstanceID,
								}

								local journalEncounterCreatureId, creatureName, creatureDescription, creatureDisplayID, iconImage, uiModelSceneID = EJ_GetCreatureInfo(1, journalEncounterID)
								if (journalEncounterCreatureId) then
									encounterData.creatureName = creatureName
									encounterData.creatureIcon = iconImage
									encounterData.creatureId = journalEncounterCreatureId
									encounterData.creatureDisplayId = creatureDisplayID
									encounterData.creatureUIModelSceneId = uiModelSceneID
								end

								instanceData.encountersArray[#instanceData.encountersArray+1] = encounterData
								instanceData.encountersByName[name] = encounterData
								instanceData.encountersByDungeonEncounterId[dungeonEncounterID] = encounterData
								instanceData.encountersByJournalEncounterId[journalEncounterID] = encounterData
							end
						end
					end
				end
			end

			--reset the dungeon journal to the default state
			C_Timer.After(0.5, function()
				EncounterJournal_ResetDisplay(nil, "none")
			end)

			--EncounterJournal_OpenJournalLink(tag, jtype, id, difficultyID)
			--EncounterJournal_OpenJournal(difficultyID, instanceID, encounterID, sectionID, creatureID, itemID, tierIndex)
		end

		--todo: should run one second after the player_login event or entering_world
		C_Timer.After(1, function()
			if (not EncounterJournal_LoadUI) then
				return
			end
			createEJCache()
		end)

		--local tooltipInfo = CreateBaseTooltipInfo("GetHyperlink", link, classID, specID);

	end

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--core

	function _detalhes:InstallEncounter(InstanceTable)
		_detalhes.EncounterInformation[InstanceTable.id] = InstanceTable
		return true
	end
end
