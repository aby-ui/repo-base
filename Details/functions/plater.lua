

local Details = _G.Details



local plater_integration_frame = CreateFrame ("frame", "DetailsPlaterFrame", UIParent, "BackdropTemplate")
plater_integration_frame.DamageTaken = {}

--> aprox. 6 updates per second
local CONST_REALTIME_UPDATE_TIME = 0.166
--> how many samples to store, 30 x .166 aprox 5 seconds buffer
local CONST_BUFFER_SIZE = 30
--> Dps division factor
PLATER_DPS_SAMPLE_SIZE = CONST_BUFFER_SIZE * CONST_REALTIME_UPDATE_TIME

--> separate CLEU events from the Tick event for performance
plater_integration_frame.OnTickFrame = CreateFrame ("frame", "DetailsPlaterFrameOnTicker", UIParent, "BackdropTemplate")

--> on tick function
plater_integration_frame.OnTickFrameFunc = function (self, deltaTime)
	if (self.NextUpdate < 0) then
		for targetGUID, damageTable in pairs (plater_integration_frame.DamageTaken) do
		
			--> total damage
			local totalDamage = damageTable.TotalDamageTaken
			local totalDamageFromPlayer = damageTable.TotalDamageTakenFromPlayer
			
			--> damage on this update
			local damageOnThisUpdate = totalDamage - damageTable.LastTotalDamageTaken
			local damageOnThisUpdateFromPlayer = totalDamageFromPlayer - damageTable.LastTotalDamageTakenFromPlayer
			
			--> update the last damage taken
			damageTable.LastTotalDamageTaken = totalDamage
			damageTable.LastTotalDamageTakenFromPlayer = totalDamageFromPlayer
			
			--> sum the current damage 
			damageTable.CurrentDamage = damageTable.CurrentDamage + damageOnThisUpdate
			damageTable.CurrentDamageFromPlayer = damageTable.CurrentDamageFromPlayer + damageOnThisUpdateFromPlayer
			
			--> add to the buffer the damage added
			tinsert (damageTable.RealTimeBuffer, 1, damageOnThisUpdate)
			tinsert (damageTable.RealTimeBufferFromPlayer, 1, damageOnThisUpdateFromPlayer)
			
			--> remove the damage from the buffer
			local damageRemoved = tremove (damageTable.RealTimeBuffer, CONST_BUFFER_SIZE + 1)
			if (damageRemoved) then
				damageTable.CurrentDamage = max (damageTable.CurrentDamage - damageRemoved, 0)
			end
			
			local damageRemovedFromPlayer = tremove (damageTable.RealTimeBufferFromPlayer, CONST_BUFFER_SIZE + 1)
			if (damageRemovedFromPlayer) then
				damageTable.CurrentDamageFromPlayer = max (damageTable.CurrentDamageFromPlayer - damageRemovedFromPlayer, 0)
			end
		end
		
		--update time
		self.NextUpdate = CONST_REALTIME_UPDATE_TIME
	else
		self.NextUpdate = self.NextUpdate - deltaTime
	end
end


--> parse the damage taken by unit
function plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, amount)
	local damageTable = plater_integration_frame.DamageTaken [targetGUID]
	
	if (not damageTable) then
		plater_integration_frame.DamageTaken [targetGUID] = {
			LastEvent = time,
			
			TotalDamageTaken = amount,
			TotalDamageTakenFromPlayer = 0,
			
			--for real time
				RealTimeBuffer = {},
				RealTimeBufferFromPlayer = {},
				LastTotalDamageTaken = 0,
				LastTotalDamageTakenFromPlayer = 0,
				CurrentDamage = 0,
				CurrentDamageFromPlayer = 0,
		}
		
		--> is the damage from the player it self?
		if (sourceGUID == plater_integration_frame.PlayerGUID) then
			plater_integration_frame.DamageTaken [targetGUID].TotalDamageTakenFromPlayer = amount
		end
	else
		damageTable.LastEvent = time
		damageTable.TotalDamageTaken = damageTable.TotalDamageTaken + amount
		
		if (sourceGUID == plater_integration_frame.PlayerGUID) then
			damageTable.TotalDamageTakenFromPlayer = damageTable.TotalDamageTakenFromPlayer + amount
		end
	end
end

plater_integration_frame:SetScript ("OnEvent", function (self)
	local time, token, hidding, sourceGUID, sourceName, sourceFlag, sourceFlag2, targetGUID, targetName, targetFlag, targetFlag2, spellID, spellName, spellType, amount, overKill, school, resisted, blocked, absorbed, isCritical = CombatLogGetCurrentEventInfo()
	
	--> tamage taken by the GUID unit
	if (token == "SPELL_DAMAGE" or token == "SPELL_PERIODIC_DAMAGE" or token == "RANGE_DAMAGE" or token == "DAMAGE_SHIELD") then
		plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, amount)
		
	elseif (token == "SWING_DAMAGE") then
		--the damage is passed in the spellID argument position
		plater_integration_frame.AddDamageToGUID (sourceGUID, targetGUID, time, spellID)
	end
end)

function Details:RefreshPlaterIntegration()

	if (Plater and Details.plater.realtime_dps_enabled or Details.plater.realtime_dps_player_enabled or Details.plater.damage_taken_enabled) then
		
		--> wipe the cache
		wipe (plater_integration_frame.DamageTaken)
		
		--> read cleu events
		plater_integration_frame:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		--> start the real time dps updater
		plater_integration_frame.OnTickFrame.NextUpdate = CONST_REALTIME_UPDATE_TIME
		plater_integration_frame.OnTickFrame:SetScript ("OnUpdate", plater_integration_frame.OnTickFrameFunc)

		--> cache the player serial
		plater_integration_frame.PlayerGUID = UnitGUID ("player")
		
		--> cancel the timer if already have one
		if (plater_integration_frame.CleanUpTimer and not plater_integration_frame.CleanUpTimer._cancelled) then
			plater_integration_frame.CleanUpTimer:Cancel()
		end
		
		--> cleanup the old tables
		plater_integration_frame.CleanUpTimer = C_Timer.NewTicker (10, function()
			local now = time()
			for GUID, damageTable in pairs (plater_integration_frame.DamageTaken) do
				if (damageTable.LastEvent + 9.9 < now) then
					plater_integration_frame.DamageTaken [GUID] = nil
				end
			end
		end)
		
	else
		--> unregister the cleu
		plater_integration_frame:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		--> stop the real time updater
		plater_integration_frame.OnTickFrame:SetScript ("OnUpdate", nil)
		
		--> stop the cleanup process
		if (plater_integration_frame.CleanUpTimer and not plater_integration_frame.CleanUpTimer._cancelled) then
			plater_integration_frame.CleanUpTimer:Cancel()
		end
	end
	
	
	
end