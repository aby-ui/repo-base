
--todo:
--implement divisors in the timeline (vertical lines)

do
	local Details = Details
	if (not Details) then
		print ("Details! Not Found.")
		return
	end
	
	local _
	local DF = _G.DetailsFramework

	local UnitGUID = _G.UnitGUID
	local GetTime = _G.GetTime
	local tremove = _G.tremove
	local tinsert = _G.tinsert
	local UnitBuff = _G.UnitBuff
	local UnitIsPlayer = _G.UnitIsPlayer
	local UnitInParty = _G.UnitInParty
	local UnitInRaid = _G.UnitInRaid
	local UnitIsUnit = _G.UnitIsUnit
	local abs = _G.abs
	local wipe = _G.wipe
	local unpack = _G.unpack

	local GetSpellInfo = Details.GetSpellInfo

	--> minimal details version required to run this plugin
	local MINIMAL_DETAILS_VERSION_REQUIRED = 136
	local DETAILS_ATTRIBUTE_DAMAGE = _G.DETAILS_ATTRIBUTE_DAMAGE
	local CASTHISTORY_VERSION = "v1.0.0"
	
	--> create a plugin object
	local castHistory = Details:NewPluginObject ("Details_CastHistory", _G.DETAILSPLUGIN_ALWAYSENABLED)
	--> just localizing here the plugin's main frame
	local frame = castHistory.Frame
	--> set the description
	castHistory:SetPluginDescription ("Show a time line of casts of players")
	--> get the framework object
	local framework = castHistory:GetFramework()
	
	--> spells cache
	local spellCache = {}
	local auraCache = {}
	
	--> when receiving an event from details, handle it here
	local handle_details_event = function (event, ...)
	
		if (event == "COMBAT_PLAYER_ENTER") then
			castHistory.OnCombatStart (...)

		elseif (event == "COMBAT_PLAYER_LEAVE") then
			castHistory.OnCombatEnd()
			
		elseif (event == "PLUGIN_DISABLED") then
			--> plugin has been disabled at the details options panel
		
		elseif (event == "PLUGIN_ENABLED") then
			--> plugin has been enabled at the details options panel
		
		elseif (event == "DETAILS_DATA_SEGMENTREMOVED") then
			--> old segment got deleted by the segment limit
		
		elseif (event == "DETAILS_DATA_RESET") then
			--> combat data got wiped

		end
		
	end
	
	function castHistory.InstallTab()
		local tabName = "CastTimeline"
		local tabNameLoc = "Cast Timeline (New Plugin Pls Test)"
		
		local canShowTab = function (tabOBject, playerObject)
			local combat = Details:GetCombatFromBreakdownWindow()
			if (combat) then
				if (combat.spells_cast_timeline [playerObject.serial]) then
					tabOBject.frame:Show()
					return true
				end
			end
			return false
		end
		
		local fillTab = function (tab, playerObject, combat)

			local castData = combat.spells_cast_timeline [playerObject and playerObject.serial]
			if (castData and castData[1]) then
				local spellData = {}
				
				local firstAbilityUsedTime = castData[1][1] --gettime
				local combatTime = combat:GetCombatTime() --seconds elapsed
				local combatStartTime = combat:GetStartTime() --gettime
				local combatEndTime = combat:GetEndTime() --gettime

				local auraData = combat.aura_timeline [playerObject and playerObject.serial]

				--cast data
				for i = 1, #castData do
					--cast: [1] GetTime(), [2] spellId, [3] target
					local cast = castData [i]
					local atTime = cast [1] --when it was casted
					local spellId = cast [2]
					local payload = cast [3] --contains the spell target
					
					local auraTimers = auraData[spellId]
					if (auraTimers) then
						auraTimers = auraTimers.data
						local foundAuraTimer = false

						for o = 1, #auraTimers do
							local auraTimer = auraTimers[o]
							--print (select(1, GetSpellInfo(spellId)),  atTime,  auraTimer[1])

							if (DF:IsNearlyEqual(auraTimer[1], atTime, 0.650)) then --when it was applyed, using 650ms as latency compensation
								foundAuraTimer = true

								local auraActivationData = auraTimer
								local applied = auraActivationData [1]
								local wentOff = auraActivationData [2]
								local duration = wentOff - applied

								spellData [spellId] = spellData [spellId] or {}
								tinsert (spellData[spellId], {applied - combatStartTime, 10, duration, duration, ["payload"] = payload})
								break
							end
						end

						if (not foundAuraTimer) then
							spellData [spellId] = spellData [spellId] or {}
							tinsert (spellData[spellId], {atTime - combatStartTime, 1, ["payload"] = payload})
						end
					else
						spellData [spellId] = spellData [spellId] or {}
						tinsert (spellData[spellId], {atTime - combatStartTime, 1, ["payload"] = payload})
					end
				end
				
				local scrollData = {
					length = combatTime,
					defaultColor = {1, 1, 1, 1},
					useIconOnBlocks = true,
					lines = {},
				}
				
				for spellId, spellTimers in pairs (spellData) do
					local spellName, _, spellIcon = GetSpellInfo(spellId)
					
					local t = {
						text = spellName,
						icon = spellIcon,
						spellId = spellId,
						timeline = spellTimers, --each table inside has the .payload
					}
					tinsert (scrollData.lines, t)
				end

				tab.frame.scroll:SetData (scrollData)
			end
		end
		
		local onClickTab = function()
			--tab.frame:Show()
		end
		
		local onCreatedTab = function (tab, frame)

			local GameCooltip2 = _G.GameCooltip2

			local scroll = DF:CreateTimeLineFrame (frame, "$parentTimeLine",
			{ --general options
				width = 865, height = 438,
			
				backdrop_color = {1, 1, 1, .1},
				backdrop_color_highlight = {1, 1, 1, .3},

				slider_backdrop_color = {.2, .2, .2, 0.3},
				slider_backdrop_border_color = {0.2, 0.2, 0.2, .3},
				
				on_enter = function (self)
					self:SetBackdropColor (unpack (self.backdrop_color_highlight))
				end,
				
				on_leave = function (self)
					if (self.dataIndex % 2 == 1) then
						self:SetBackdropColor (1, 1, 1, 0)
					else
						self:SetBackdropColor (1, 1, 1, .1)
					end
				end,

				block_on_enter = function (self)
					local info = self.info
					local spellName, _, spellIcon = GetSpellInfo(info.spellId)
					GameCooltip2:Preset (2)
					GameCooltip2:SetOwner (self)
					GameCooltip2:SetOption ("TextSize", 10)
					GameCooltip2:AddLine (spellName)
					GameCooltip2:AddIcon (spellIcon, 1, 1, 16, 16, .1, .9, .1, .9)
					GameCooltip2:AddLine ("Time:", info.time < -0.2 and "-" .. DF:IntegerToTimer(abs(info.time)) or DF:IntegerToTimer(abs(info.time)))

					if (info.duration) then
						GameCooltip2:AddLine ("Duration:", DF:IntegerToTimer (info.duration))
					end

					local target = info.payload

					GameCooltip2:AddLine("Target:", info.payload)
					GameCooltip2:AddLine("SpellId:", info.spellId)
					GameCooltip2:Show()
					
					self.icon:SetBlendMode ("ADD")
				end,
				
				block_on_leave = function (self)
					GameCooltip2:Hide()
					self.icon:SetBlendMode ("BLEND")
				end,
			},
			
			{ --timeline frame options
				draw_line_color = {1, 1, 1, 0.03},
			}
			)

			local scrollText = DF:CreateLabel (scroll.horizontalSlider, "scroll", 10, {.5, .5, .5, .5})
			scrollText:SetPoint ("right", scroll.horizontalSlider, "right", -2, 0)

			local zoomText = DF:CreateLabel (scroll.scaleSlider, "zoom", 10, {.5, .5, .5, .5})
			zoomText:SetPoint ("right", scroll.scaleSlider, "right", -2, 0)

			scroll:SetPoint ("topleft", frame, "topleft", 0, 0)
			frame.scroll = scroll
		end
		
		local iconSettings = {
			texture = [[Interface\CHATFRAME\CHATFRAMEBACKGROUND]],
			coords = {0.1, 0.9, 0.1, 0.9},
			width = 16,
			height = 16,
		}

		Details:CreatePlayerDetailsTab (tabName, tabNameLoc, canShowTab, fillTab, nil, onCreatedTab, iconSettings)
	end
	

	
	--runs on each member in the group
	function castHistory.BuildPlayerList(unitId, combatObject)
		local GUID = UnitGUID (unitId)
		combatObject.spells_cast_timeline [GUID] = {}
		combatObject.aura_timeline [GUID] = {}
	end

	--runs on each member in the group
	--these are stored spells when out of combat to show pre-casts before a pull
	function castHistory.CacheTransfer(unitId, combatObject, spellCache, auraCache)
		local GUID = UnitGUID(unitId)
		local cachedCastTable = spellCache [GUID]
		local combatCastTable = combatObject.spells_cast_timeline [GUID]
		
		if (cachedCastTable and combatCastTable) then
			local cutOffTime = GetTime() - 5
			for i = #cachedCastTable, 1, -1 do
				if (cachedCastTable [i][1] < cutOffTime) then
					tremove(cachedCastTable, i)
				end
			end

			for i = 1, #cachedCastTable do
				tinsert(combatCastTable, cachedCastTable[i])
			end
			
			table.wipe(cachedCastTable)
		end
		
		--
		
		local cachedAuraTable = auraCache [GUID]
		local combatAuraTable = combatObject.aura_timeline [GUID]
		
		if (cachedAuraTable and combatAuraTable) then
			for spellId, appliedAt in pairs (cachedAuraTable) do
			
				--check if the aura is still up
				local auraUp
				for i = 1, 40 do
					local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, auraSpellId = UnitBuff(unitId, i)
					
					if (not name) then
						break
					end
					
					if (spellId == auraSpellId) then
						auraUp = true
						break
					end
				end
				
				if (auraUp) then
					combatAuraTable [spellId] = {
						enabled = true,
						appliedAt = appliedAt,
						data = {},
						spellId = spellId,
						auraType = "BUFF",
					}
				end
			end
			
			table.wipe(cachedAuraTable)
		end
	end
	
	function castHistory.OnCombatStart (combatObject)
		--start
		castHistory.inCombat = true
		castHistory.currentCombat =  combatObject
		--built the table
		DF:GroupIterator (castHistory.BuildPlayerList, combatObject)
		--precasts
		DF:GroupIterator (castHistory.CacheTransfer, combatObject, spellCache, auraCache)
		--wipe sent cache
		wipe(castHistory.sentSpellCache)

		castHistory.combatLogReader:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	end
	
	function castHistory.OnCombatEnd()
		--finish
		castHistory.inCombat = false
		
		--close aura timers
		if (castHistory.currentCombat) then
			for GUID, playerAuraTable in pairs(castHistory.currentCombat.aura_timeline) do
				for spellId, auraTable in pairs(playerAuraTable) do
					if (auraTable.enabled) then
						auraTable.enabled = false
						auraTable.amountUp = 0
						tinsert (auraTable.data, {auraTable.appliedAt, GetTime()}) --when it was applied and when it went off
					end
				end
			end
		end

		wipe(castHistory.sentSpellCache)
		castHistory.combatLogReader:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	end

	function castHistory:OnEvent (_, event, ...)
	
		if (event == "UNIT_AURA disabled") then
			local unitId = ...
			if (unitId and UnitIsPlayer(unitId) and (UnitInParty(unitId) or UnitInRaid(unitId) or UnitIsUnit(unitId, "player"))) then
				local GUID = UnitGUID(unitId)
				if (GUID) then
					if (castHistory.inCombat) then
						local playerAuraTable = castHistory.currentCombat.aura_timeline [GUID]
						if (playerAuraTable) then
							local aurasFound = {}
							for i = 1, 40 do
								local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitBuff(unitId, i)
								
								if (not name) then
									break
								end
								
								if (duration and duration > 0 and duration < 50) then
									--check if can merge
									spellId = castHistory.db.merged_spells[spellId] or spellId

									local auraTable = playerAuraTable [spellId]
									if (not auraTable) then
										playerAuraTable [spellId] = {
											enabled = true,
											appliedAt = GetTime(),
											data = {},
											spellId = spellId,
											auraType = "BUFF",
										}
										auraTable = playerAuraTable [spellId]
									else
										if (not auraTable.enabled) then
											auraTable.enabled = true
											auraTable.appliedAt = GetTime()
										end
									end
									
									aurasFound [spellId] = true
								end
							end
							
							for spellId, auraTable in pairs (playerAuraTable) do
								if (auraTable.enabled and not aurasFound [spellId]) then
									auraTable.enabled = false
									tinsert (auraTable.data, {auraTable.appliedAt, GetTime()}) --when it was applied and when it went off
								end
							end
						end
					else
						--details! isn't in combat
						--add the spell into the cache for pre-cast spells
						local cachedAuraTable = auraCache [GUID] or {}
						auraCache [GUID] = cachedAuraTable

						for i = 1, 40 do
							local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId = UnitBuff (unitId, i)
							
							if (not name) then
								break
							end
							
							--check if can merge
							spellId = castHistory.db.merged_spells[spellId] or spellId

							if (duration and duration > 0 and duration < 50) then
								cachedAuraTable [spellId] = expirationTime - duration
							end
						end
					end
				end
			end

		elseif (event == "UNIT_SPELLCAST_SENT") then
			local unitId, target, castGUID, spellId = ...
			local spell = GetSpellInfo(spellId)

			if (unitId == "player") then
				castHistory.sentSpellCache[castGUID] = {
					target = target or "",
					caster = unitId,
					spellId = spellId,
				}
			end

			--print("sent", castHistory.sentSpellCache[castGUID])

		elseif (event == "UNIT_SPELLCAST_SUCCEEDED") then
			local unitId, castGUID, spellId = ...

			local castSent = castHistory.sentSpellCache[castGUID]
			if (not castSent) then
				return
			end

			castHistory.sentSpellCache [castGUID] = nil

			local target = castSent.target
			local caster = castSent.caster
			--local spellId = castSent.spellId

			if (caster and spellId and UnitIsPlayer(caster) and (UnitInParty(caster) or UnitInRaid(caster) or UnitIsUnit(caster, "player"))) then
				local GUID = UnitGUID(caster)
				if (GUID) then
					--check if can merge
					spellId = castHistory.db.merged_spells[spellId] or spellId

					if (castHistory.inCombat) then
						local playerCastTable = castHistory.currentCombat.spells_cast_timeline [GUID]
						if (playerCastTable) then
							tinsert(playerCastTable, {GetTime(), spellId, target})
						end

					else
						local playerCastTable = spellCache [GUID]
						
						if (not playerCastTable) then
							spellCache [GUID] = {}
							playerCastTable = spellCache [GUID]
						else
							local cutOffTime = GetTime() - 5
							for i = #playerCastTable, 1, -1 do
								if (playerCastTable [i][1] < cutOffTime) then
									tremove (playerCastTable, i)
								end
							end
						end

						tinsert(playerCastTable, {GetTime(), spellId, target})
					end
				end
			end
		
		elseif (event == "ADDON_LOADED") then
			local AddonName = select (1, ...)
			if (AddonName == "Details_CastHistory") then
				
				--> every plugin must have a OnDetailsEvent function
				function castHistory:OnDetailsEvent (event, ...)
					return handle_details_event (event, ...)
				end

				local default_options = {
					ignored_spells = {
						[324988] = true, --shared suffering (lady inerva darkvein)
						[324183] = true, --lightless force

						--hunter
						[75] = true, --auto shot

						--warrior
						[184367] = 201363, --rampage
						[184709] = 201363,
						[199667] = 44949, --whirlwind
						[190411] = 44949,
						[85739] = 44949,
						[317488] = 317485, --condemn
						[126664] = 100, --charge
						[227847] = 50622, --bladestorm
						[147833] = 3411, --intervene
						[316531] = 3411, --intervene
						[52174] = 6544, --heroic leap

						--prist
						[33076] = 41635, --prayer of mending

						--rogue
						[199672] = 1943, --rupture
						[185313] = 185422, --shadow dance

						--mage
						[7268] = 5143, --arcane missiles
						[228597] = true, --frostbolt

						--warlock
						[146739] = 172, --corruption

						--monk
						[148187] = 116847, --rushing jade wing

						--dh
						[222031] = 199547, --chaos strike
						[201453] = 191427, --metamorphosis
						[201428] = true, --annihilation
						[227518] = true, --annihilation

						--dk
						[196711] = true, --remorseless winter
					},

					merged_spells = {

					},
				}
				
				--> Install: install -> if successful installed; saveddata -> a table saved inside details db, used to save small amount of data like configs
				local install, saveddata = Details:InstallPlugin("RAID",
				"Cast History",
				"Interface\\Icons\\Ability_Warrior_BattleShout",
				castHistory,
				"DETAILS_PLUGIN_CAST_HISTORY",
				MINIMAL_DETAILS_VERSION_REQUIRED,
				"Terciob",
				CASTHISTORY_VERSION,
				default_options)

				if (type (install) == "table" and install.error) then
					print (install.error)
				end
				
				--> registering details events we need
				Details:RegisterEvent (castHistory, "COMBAT_PLAYER_ENTER") --when details creates a new segment, not necessary the player entering in combat.
				Details:RegisterEvent (castHistory, "COMBAT_PLAYER_LEAVE") --when details finishs a segment, not necessary the player leaving the combat.
				Details:RegisterEvent (castHistory, "DETAILS_DATA_RESET") --details combat data has been wiped
				
				castHistory.Frame:RegisterEvent ("UNIT_SPELLCAST_SENT")
				castHistory.Frame:RegisterEvent ("UNIT_SPELLCAST_SUCCEEDED")
				castHistory.Frame:RegisterEvent ("UNIT_AURA")

				castHistory.sentSpellCache = {}
				
				castHistory.InstallTab()

				--combatlog parser
				local combatLogReader = CreateFrame("frame")
				local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
				local playerSerial = UnitGUID("player")
				castHistory.combatLogReader = combatLogReader

				local eventFunc = {
					["SPELL_AURA_APPLIED"] = function(timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellId, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical)
						local GUID = sourceSerial
						if (castHistory.inCombat) then
							local playerAuraTable = castHistory.currentCombat.aura_timeline[GUID]
							if (playerAuraTable) then

								spellId = castHistory.db.merged_spells[spellId] or spellId

								local auraTable = playerAuraTable[spellId]
								if (not auraTable) then
									playerAuraTable [spellId] = {
										enabled = true,
										amountUp = 1,
										appliedAt = GetTime(),
										data = {},
										spellId = spellId,
										--auraType = "BUFF",
									}
									auraTable = playerAuraTable [spellId]
								else
									if (not auraTable.enabled) then
										auraTable.enabled = true
										auraTable.amountUp = 1
										auraTable.appliedAt = GetTime()
									else
										auraTable.amountUp = auraTable.amountUp + 1
									end
								end
							end
						else
							--not in combat
						end
					end,

					["SPELL_AURA_REMOVED"] = function(timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellId, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical)
						local GUID = sourceSerial
						if (castHistory.inCombat) then
							local playerAuraTable = castHistory.currentCombat.aura_timeline[GUID]
							if (playerAuraTable) then
								spellId = castHistory.db.merged_spells[spellId] or spellId

								local auraTable = playerAuraTable[spellId]
								if (auraTable) then
									if (auraTable.enabled) then
										auraTable.amountUp = auraTable.amountUp - 1
										if (auraTable.amountUp <= 0) then
											auraTable.enabled = false
											tinsert(auraTable.data, {auraTable.appliedAt, GetTime()}) --when it was applied and when it went off
										end
									end
								end
							end
						end
					end,
				}

				combatLogReader:SetScript ("OnEvent", function (self)
					local timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellId, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = CombatLogGetCurrentEventInfo()
					local func = eventFunc[token]
					if (func) then
						--check if the event is from the player or from the group
						if (sourceName and spellId and (UnitInParty(sourceName) or UnitInRaid(sourceName) or UnitIsUnit(sourceName, "player"))) then
							func(timew, token, hidding, sourceSerial, sourceName, sourceFlag, sourceFlag2, targetSerial, targetName, targetFlag, targetFlag2, spellId, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical)
						end
					end
				end)

			end
		end

	end

end
