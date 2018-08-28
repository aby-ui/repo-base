--------------------------------------------------------------------------
-- GTFO.lua 
--------------------------------------------------------------------------
--[[
GTFO
Author: Zensunim of Dragonblight

Usage: /GTFO or go to Interface->Add-ons->GTFO
]]--
GTFO = {
	DefaultSettings = {
		Active = true;
		Sounds = { true, true, true, true };
		ScanMode = nil;
		DebugMode = nil; -- Turn on debug alerts
		TestMode = nil; -- Activate alerts for events marked as "test only"
		UnmuteMode = nil;
		TrivialMode = nil;
		NoVersionReminder = nil;
		Volume = 3; -- Volume setting, 3 = default
		SoundChannel = "Master"; -- Sound channel to play on
		IgnoreOptions = { };
		TrivialDamagePercent = 2; -- Minimum % of HP lost required for an alert to be trivial
		SoundOverrides = { }; -- Override table for GTFO sounds
	};
	Version = "4.46.5a"; -- Version number (text format)
	VersionNumber = 44604; -- Numeric version number for checking out-of-date clients
	DataLogging = nil; -- Indicate whether or not the addon needs to run the datalogging function (for hooking)
	DataCode = "4"; -- Saved Variable versioning, change this value to force a reset to default
	CanTank = nil; -- The active character is capable of tanking
	CanCast = nil; -- The active character is capable of casting
	TankMode = nil; -- The active character is a tank
	CasterMode = nil; -- The active character is a caster
	SpellName = { }; -- List of spells (legacy placeholder, not supported)
	SpellID = { }; -- List of spell IDs
	FFSpellID = { }; -- List of friendly fire spell IDs
	IgnoreSpellCategory = { }; -- List of spell groups to ignore
	IgnoreScan = { }; -- List of spell groups to ignore during scans
	MobID = { }; -- List of mob IDs for melee attack detection
	GroupGUID = { }; -- List of GUIDs of members in your group
	UpdateFound = nil; -- Upgrade available?
	IgnoreTimeAmount = .2; -- Number of seconds between alert sounds
	IgnoreTime = nil;
	IgnoreUpdateTimeAmount = 5; -- Number of seconds between sending out version updates
	IgnoreUpdateTime = nil;
	IgnoreUpdateRequestTimeAmount = 90; -- Number of seconds between sending out version update requests
	IgnoreUpdateRequestTime = nil;
	Events = { }; -- Event queue
	Users = { }; -- User version database
	Sounds = { }; -- Sound Files
	SoundSettings = { }; -- CVARs for temporary muting
	SoundTimes = { .5, .3, .4, .5 }; -- Length of sound files in seconds (for auto-unmute)
	PartyMembers = 0;
	RaidMembers = 0;
	PowerAuras = nil; -- PowerAuras Integration enabled
	WeakAuras = nil; -- WeakAuras Integration enabled
	Recount = nil; -- Recount Integration enabled
	Skada = nil; -- Skada Integration enabled
	ShowAlert = nil;
	Settings = { };
	UIRendered = nil;
	VariableStore = { -- Variable storage for special circumstances
		StackCounter = 0;
		DisableGTFO = nil;
	};
	BetaMode = nil; -- WoW Beta/PTR client detection
	SoundChannels = { 
		{ Code = "Master", Name = _G.MASTER },
		{ Code = "SFX", Name = _G.SOUND_VOLUME, CVar = "Sound_EnableSFX" },
		{ Code = "Ambience", Name = _G.AMBIENCE_VOLUME, CVar = "Sound_EnableAmbience" },
		{ Code = "Music", Name = _G.MUSIC_VOLUME, CVar = "Sound_EnableMusic" },
		{ Code = "Dialog", Name = _G.DIALOG_VOLUME },
	};
	Scans = { };
};

GTFOData = {};

if (select(4, GetBuildInfo()) >= 80000) then
	GTFO.BetaMode = true;
end

StaticPopupDialogs["GTFO_POPUP_MESSAGE"] = {
	preferredIndex = 3,
	text = GTFOLocal.LoadingPopup_Message,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		GTFO_Command_Options()
	end,
	OnCancel = function()
		GTFO_ChatPrint(string.format(GTFOLocal.ClosePopup_Message," |cFFFFFFFF/gtfo options|r"))
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
};	

function GTFO_ChatPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[GTFO] "..tostring(str), 0.25, 1.0, 0.25);
end

function GTFO_ErrorPrint(str)
	DEFAULT_CHAT_FRAME:AddMessage("[GTFO] "..tostring(str), 1.0, 0.5, 0.5);
end

function GTFO_DebugPrint(str)
	if (GTFO.Settings.DebugMode) then
		DEFAULT_CHAT_FRAME:AddMessage("[GTFO] "..tostring(str), 0.75, 1.0, 0.25);
	end
end

function GTFO_ScanPrint(str)
	if (GTFO.Settings.ScanMode) then
		DEFAULT_CHAT_FRAME:AddMessage("[GTFO] "..tostring(str), 0.5, 0.5, 0.85);
	end
end

function GTFO_GetMobId(sGUID)
	local mobType, _, _, _, _, mobId = strsplit("-", sGUID or "")
	if mobType and (mobType == "Creature" or mobType == "Vehicle" or mobType == "Pet") then
		return tonumber(mobId)
	end
	return 0;
end

function GTFO_OnEvent(self, event, ...)
	if (event == "VARIABLES_LOADED") then
		C_ChatInfo.RegisterAddonMessagePrefix("GTFO");
		if (GTFOData.DataCode ~= GTFO.DataCode) then
			GTFO_SetDefaults();
			--163uiedit
			--GTFO_ChatPrint(string.format(GTFOLocal.Loading_NewDatabase, GTFO.Version));
			--GTFO_DisplayConfigPopupMessage();
		end
		GTFO.Settings = {
			Active = GTFOData.Active;
			Sounds = { GTFOData.Sounds[1], GTFOData.Sounds[2], GTFOData.Sounds[3], GTFOData.Sounds[4] };
			ScanMode = GTFOData.ScanMode;
			DebugMode = GTFOData.DebugMode;
			TestMode = GTFOData.TestMode;
			UnmuteMode = GTFOData.UnmuteMode;
			TrivialMode = GTFOData.TrivialMode;
			NoVersionReminder = GTFOData.NoVersionReminder;
			Volume = GTFOData.Volume or 3;
			TrivialDamagePercent = GTFOData.TrivialDamagePercent or GTFO.DefaultSettings.TrivialDamagePercent;
			SoundChannel = GTFOData.SoundChannel or GTFO.DefaultSettings.SoundChannel;
			IgnoreOptions = { };
			SoundOverrides = { };
		};
		if (GTFOData.IgnoreOptions) then
			for key, option in pairs(GTFOData.IgnoreOptions) do
				GTFO.Settings.IgnoreOptions[key] = GTFOData.IgnoreOptions[key];
			end
		end
		if (GTFOData.SoundOverrides) then
			for key, option in pairs(GTFOData.SoundOverrides) do
				GTFO.Settings.SoundOverrides[key] = GTFOData.SoundOverrides[key];
			end
		end

		GTFO_RenderOptions();
		GTFO_SaveSettings();
		GTFO_AddEvent("RefreshOptions", .1, function() GTFO_RefreshOptions(); end);

		-- Power Auras Integration
		if (IsAddOnLoaded("PowerAuras")) then
			local PowaAurasEnabled
			if (PowaAuras_GlobalTrigger) then
				PowaAurasEnabled = PowaAuras_GlobalTrigger()
			end
			-- Power Auras 5.x
			if (PowaAuras and PowaAuras.MarkAuras) then
				GTFO.PowerAuras = true;
			-- Power Auras 4.24.2+
			elseif (PowaAurasEnabled) then
				GTFO.PowerAuras = true;
			-- Power Auras 4.x
			elseif (PowaAuras and PowaAuras.AurasByType) then
				if (PowaAuras.AurasByType.GTFOHigh) then
					GTFO.PowerAuras = true;
				else
					--163uiedit
					--GTFO_ChatPrint(GTFOLocal.Loading_PowerAurasOutOfDate);
				end
			else
				GTFO_ChatPrint(GTFOLocal.Loading_PowerAurasOutOfDate);
			end
		end
		if (IsAddOnLoaded("WeakAuras")) then
			GTFO.WeakAuras = true;
		else
			GTFO_DisplayAura_WeakAuras = nil;
		end
		if not (GTFO.PowerAuras) then
				GTFO_DisplayAura_PowerAuras = nil
		end
		if (GTFO.Settings.Active) then
			--GTFO_ChatPrint(string.format(GTFOLocal.Loading_Loaded, GTFO.Version));
		else
			GTFO_ChatPrint(string.format(GTFOLocal.Loading_LoadedSuspended, GTFO.Version));
		end
		
		-- Recount Integration
		if (IsAddOnLoaded("Recount")) then
			GTFO.Recount = GTFO_Recount();
			GTFO.DataLogging = true;
		else
			GTFO_Recount = nil;
			GTFO_RecordRecount = nil;
		end
		if (IsAddOnLoaded("Skada")) then
			GTFO.Skada = GTFO_Skada();
			GTFO.DataLogging = true;
		else
			GTFO_Skada = nil;
		end
		
		GTFO.Users[UnitName("player")] = GTFO.VersionNumber;
		GTFO_GetSounds();
		GTFO.CanTank = GTFO_CanTankCheck("player");
		GTFO.CanCast = GTFO_CanCastCheck("player");
		if (GTFO.CanCast) then
			GTFO_RegisterCasterEvents();
		end
		if (GTFO.CanTank) then
			GTFO_RegisterTankEvents();
		end
		GTFO.TankMode = GTFO_CheckTankMode();
		GTFO.CasterMode = GTFO_CheckCasterMode();
		GTFO_SendUpdateRequest();
		return;
	end
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if (GTFO.IgnoreTime and not (GTFO.DataLogging)) then
			if (GetTime() < GTFO.IgnoreTime) then
				-- Alerts are currently being ignored and data logging is off, don't bother with processing anything
				return;
			end
		end

		local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, misc1, misc2, misc3, misc4, misc5, misc6, misc7 = CombatLogGetCurrentEventInfo(); 
		
		local SpellType = tostring(eventType);
		local vehicle = nil;

		if (GTFO.VariableStore.DisableGTFO) then
			if GTFO_FindEvent("ReshapeLife") then
				if (GTFO_HasDebuff("player", 122784)) then
					GTFO_AddEvent("ReshapeLife", 5);
				end
				return;
			end
			GTFO.VariableStore.DisableGTFO = nil;
		end
	
		if (destGUID ~= UnitGUID("player")) then
			-- Damage happened to someone/something other than the player
			if (destGUID == UnitGUID("vehicle")) then
				-- Player's vehicle is targetted, not the player
				vehicle = true;
			else
				if (sourceGUID == UnitGUID("player")) then
					-- Player was the source of event, but not the target
					if (SpellType=="SPELL_DAMAGE") then
						local SpellID = tonumber(misc1);
						local SpellName = tostring(misc2);
						local SpellSourceGUID = tostring(sourceGUID);
						SpellID = tostring(SpellID);
						--GTFO_ScanPrint(SpellType.." - "..SpellID.." - "..SpellName.." - "..SpellSourceName.." ("..GTFO_GetMobId(sourceGUID)..") >"..tostring(destName));
						if (GTFO.FFSpellID[SpellID]) then
							-- Friendly fire alerts
							if not (tContains(GTFO.GroupGUID, destGUID)) then
								--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") on "..tostring(destName).." - Damage wasn't a raid member");
								return;
							end
							if (GTFO.FFSpellID[SpellID].test and not GTFO.Settings.TestMode) then
								--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") on "..tostring(destName).." - Test mode off");
								-- Test mode is off, ignore
								return;
							end
							if (GTFO.FFSpellID[SpellID].trivialLevel and not GTFO.Settings.TrivialMode and GTFO.FFSpellID[SpellID].trivialLevel <= UnitLevel("player")) then
								--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") on "..tostring(destName).." - Trivial spell - Level");
								-- Trivial mode is off, ignore trivial spell
								return;
							end
							if (GTFO.FFSpellID[SpellID].ignoreSelfInflicted and destGUID == UnitGUID("player")) then
								--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Ignore self inflicted");
								-- Self-inflicted wound and "Ignore Self Inflicated" is set
								return;
							end
							local damage = tonumber(misc4) or 0
							if ((GTFO.FFSpellID[SpellID].trivialPercent or 0) >= 0 and not GTFO.FFSpellID[SpellID].alwaysAlert and not GTFO.Settings.TrivialMode) then
								local damagePercent = tonumber((damage * 100) / UnitHealthMax("player"));
							 	if (((GTFO.FFSpellID[SpellID].trivialPercent or 0) == 0 and damagePercent < tonumber(GTFO.Settings.TrivialDamagePercent)) or (GTFO.FFSpellID[SpellID].trivialPercent and GTFO.FFSpellID[SpellID].trivialPercent > 0 and damagePercent < GTFO.FFSpellID[SpellID].trivialPercent)) then
									--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") on "..tostring(destName).." - Trivial spell - Damage %");
									-- Trivial mode is off, ignore trivial spell based on damage %
									return;
								end
							end

							if (GTFO.FFSpellID[SpellID].test) then
								GTFO_ScanPrint("TEST ALERT: Spell ID #"..SpellID);
							end
							alertID = GTFO_GetAlertID(GTFO.FFSpellID[SpellID], "player");
							GTFO_PlaySound(alertID);
							GTFO_RecordStats(alertID, SpellID, SpellName, tonumber(damage), nil);
						end
					end
				end
				return;
			end
		end
		if (SpellType == "ENVIRONMENTAL_DAMAGE") then
			local environment = string.upper(tostring(misc1))
			local damage = tonumber(misc2) or 0
			local damagePercent = tonumber((damage * 100) / UnitHealthMax("player"))
			-- Environmental detection
			GTFO_ScanPrint(SpellType.." - "..environment);
			local alertID;
			if (environment == "DROWNING") then
				alertID = 1;
			elseif (environment == "FATIGUE") then
				if (GTFO.Settings.IgnoreOptions and GTFO.Settings.IgnoreOptions["Fatigue"]) then
					-- Fatigue being ignored
					--GTFO_DebugPrint("Won't alert FATIGUE - Manually ignored");
					return;
				end
				alertID = 1;
			elseif (environment == "LAVA") then
				alertID = 2;
				if (GTFO_HasDebuff("player", 81118) or GTFO_HasDebuff("player", 94073) or GTFO_HasDebuff("player", 94074) or GTFO_HasDebuff("player", 94075) or GTFO_HasDebuff("player", 97151)) then
					-- Magma debuff exception
					--GTFO_DebugPrint("Won't alert LAVA - Magma debuff found");
					return;
				end
				if (not GTFO.Settings.TrivialMode and damagePercent < tonumber(GTFO.Settings.TrivialDamagePercent)) then
					-- Trivial
					--GTFO_DebugPrint("Won't alert LAVA - Trivial");
					return;
				end
			elseif (environment ~= "FALLING") then
				alertID = 2;
				if (not GTFO.Settings.TrivialMode and damagePercent < tonumber(GTFO.Settings.TrivialDamagePercent)) then
					-- Trivial
					--GTFO_DebugPrint("Won't alert "..tostring(environment).." - Trivial");
					return;
				end
			else
				return;
			end
			GTFO_PlaySound(alertID);
			GTFO_RecordStats(alertID, 0, GTFOLocal.Recount_Environmental, tonumber(damage), nil);
			return;
		elseif (SpellType=="SPELL_PERIODIC_DAMAGE" or SpellType=="SPELL_DAMAGE" or SpellType=="SPELL_MISSED" or SpellType=="SPELL_PERIODIC_MISSED" or SpellType=="SPELL_ENERGIZE" or SpellType=="SPELL_INSTAKILL" or ((SpellType=="SPELL_AURA_APPLIED" or SpellType=="SPELL_AURA_APPLIED_DOSE" or SpellType=="SPELL_AURA_REFRESH") and misc4=="DEBUFF")) then
			-- Spell detection
			local SpellID = tonumber(misc1);
			local SpellName = tostring(misc2);
			local SpellSourceGUID = tostring(sourceGUID);
			local SpellSourceName = tostring(sourceName);
			local damage = tonumber(misc4) or 0

			-- Special exception for Onyxia Breath's and her stupid 92 different spell IDs
			if ((SpellID > 17086 and SpellID <= 17097) or (SpellID >= 18351 and SpellID <= 18361) or (SpellID >= 18564 and SpellID <= 18607) or SpellID == 18609 or (SpellID >= 18611 and SpellID <= 18628)) then
				SpellID = 17086;
			end
			
			SpellID = tostring(SpellID);

			if (GTFO.Settings.ScanMode and not GTFO.IgnoreScan[SpellID]) then
				if (vehicle) then
					GTFO_ScanPrint("V: "..SpellType.." - "..SpellID.." - "..GetSpellLink(SpellID).." - "..SpellSourceName.." ("..GTFO_GetMobId(sourceGUID)..") >"..tostring(destName));
					GTFO_SpellScan(SpellID, SpellSourceName);
				elseif (SpellType~="SPELL_ENERGIZE" or (SpellType=="SPELL_ENERGIZE" and sourceGUID ~= UnitGUID("player"))) then
					GTFO_ScanPrint(SpellType.." - "..SpellID.." - "..GetSpellLink(SpellID).." - "..SpellSourceName.." ("..GTFO_GetMobId(sourceGUID)..") >"..tostring(destName).." for "..tostring(misc4));
					GTFO_SpellScan(SpellID, SpellSourceName, tostring(misc4));
				end
			end
			if (GTFO.SpellID[SpellID]) then
				if (GTFO.SpellID[SpellID].category) then
					if (GTFO.Settings.IgnoreOptions and GTFO.Settings.IgnoreOptions[GTFO.SpellID[SpellID].category]) then
						-- Spell is being ignored completely
						--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Player activated ignore option: "..GTFO.SpellID[SpellID].category);
						return;						
					end
				end

				if (GTFO.SpellID[SpellID].spellType and not (GTFO.SpellID[SpellID].spellType == SpellType)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Wrong Spell Type");
					-- Wrong spell type
					return;
				end

				if (vehicle and not GTFO.SpellID[SpellID].vehicle) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Vehicle not enabled");
					-- Vehicle damage and vehicle mode is not set
					return;
				end
				if (GTFO.SpellID[SpellID].test and not GTFO.Settings.TestMode) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Test mode off");
					-- Experiemental/Beta option is off, ignore
					return;
				end

				if (GTFO.SpellID[SpellID].casterOnly and not GTFO.CasterMode) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Caster alert only");
					-- Alert is for casters only
					return;
				end

				if (GTFO.SpellID[SpellID].ignoreEvent and GTFO_FindEvent(GTFO.SpellID[SpellID].ignoreEvent)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Ignore Event ("..GTFO.SpellID[SpellID].ignoreEvent..") is active");
					-- Ignore event code found
					return;
				end
				if (GTFO.SpellID[SpellID].negatingDebuffSpellID and GTFO_HasDebuff("player", GTFO.SpellID[SpellID].negatingDebuffSpellID)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Negating debuff ("..GTFO.SpellID[SpellID].negatingDebuffSpellID..") is active");
					-- Player has a spell negating debuff
					if (GTFO.SpellID[SpellID].negatingIgnoreTime) then
						GTFO_AddEvent("Negate"..SpellID, GTFO.SpellID[SpellID].negatingIgnoreTime);
					end
					return;
				end
				if (GTFO.SpellID[SpellID].negatingBuffSpellID and GTFO_HasBuff("player", GTFO.SpellID[SpellID].negatingBuffSpellID)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Negating buff ("..GTFO.SpellID[SpellID].negatingBuffSpellID..") is active");
					-- Player has a spell negating buff
					if (GTFO.SpellID[SpellID].negatingIgnoreTime) then
						GTFO_AddEvent("Negate"..SpellID, GTFO.SpellID[SpellID].negatingIgnoreTime);
					end
					return;
				end
				if (GTFO.SpellID[SpellID].negatingIgnoreTime and GTFO_FindEvent("Negate"..SpellID)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Ignore Event (Negate"..SpellID..") is active");
					-- Ignore event code found (keep this code after AddEvent triggers so the triggers can continue to refresh)
					return;
				end
				if (GTFO.SpellID[SpellID].affirmingDebuffSpellID and not GTFO_HasDebuff("player", GTFO.SpellID[SpellID].affirmingDebuffSpellID)) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Affirming debuff ("..GTFO.SpellID[SpellID].affirmingDebuffSpellID..") is not active");
					-- Player doesn't have spell affirming debuff
					return;
				end
				if (not GTFO.Settings.TrivialMode) then
					if (GTFO.SpellID[SpellID].trivialLevel and GTFO.SpellID[SpellID].trivialLevel <= UnitLevel("player")) then
						--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Trivial spell - Low level");
						-- Trivial mode is off, ignore trivial spell based on level
						return;
					end
					if ((GTFO.SpellID[SpellID].trivialPercent or 0) >= 0 and not GTFO.SpellID[SpellID].alwaysAlert and (SpellType=="SPELL_PERIODIC_DAMAGE" or SpellType=="SPELL_DAMAGE")) then
						local damagePercent = tonumber((damage * 100) / UnitHealthMax("player"));
					 	if (((GTFO.SpellID[SpellID].trivialPercent or 0) == 0 and damagePercent < tonumber(GTFO.Settings.TrivialDamagePercent)) or (GTFO.SpellID[SpellID].trivialPercent and GTFO.SpellID[SpellID].trivialPercent > 0 and damagePercent < GTFO.SpellID[SpellID].trivialPercent)) then
							--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Trivial spell - Damage %");
							-- Trivial mode is off, ignore trivial spell based on damage %
							return;
						end
					end
				end
				if (GTFO.SpellID[SpellID].specificMobs and not tContains(GTFO.SpellID[SpellID].specificMobs, GTFO_GetMobId(sourceGUID))) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Mob isn't on the list");
					-- Mob isn't on the list, ignore spell
					return;
				end
				if ((SpellType == "SPELL_MISSED" or SpellType == "SPELL_PERIODIC_MISSED") and not GTFO.SpellID[SpellID].alwaysAlert) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Spell missed & always alert off");
					-- Always Alert is off, ignore missed spell
					return;
				end
				if (GTFO.SpellID[SpellID].applicationOnly) then
					if (GTFO.SpellID[SpellID].minimumStacks or GTFO.SpellID[SpellID].maximumStacks) then
						if (SpellType ~= "SPELL_AURA_APPLIED_DOSE" or not misc5) then
							--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Application only w/ minimum stacks & not a dosage event");
							-- Not a dose application event
							return;
						end
						local stacks = tonumber(misc5);
						if (GTFO.SpellID[SpellID].minimumStacks and stacks <= tonumber(GTFO.SpellID[SpellID].minimumStacks)) then
							--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Application only w/ minimum stacks & not enough stacks");
							-- Not enough stacks
							return;
						elseif (GTFO.SpellID[SpellID].maximumStacks and stacks >= tonumber(GTFO.SpellID[SpellID].maximumStacks)) then
							--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Application only w/ maximum stacks & too many stacks");
							-- Too many stacks
							return;
						end
					elseif (not (SpellType == "SPELL_AURA_APPLIED" or SpellType == "SPELL_AURA_APPLIED_DOSE" or SpellType == "SPELL_AURA_REFRESH")) then
						--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Application only & non-application event");
						-- Application Only is set and this was a non-application event
						return;
					end
				end
				if (GTFO.SpellID[SpellID].ignoreApplication and SpellType == "SPELL_AURA_APPLIED") then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Ignore application event");
					-- Debuff application and "Ignore Application" is set
					return;					
				end
				if (GTFO.SpellID[SpellID].ignoreSelfInflicted and SpellSourceGUID == UnitGUID("player")) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Ignore self inflicted");
					-- Self-inflicted wound and "Ignore Self Inflicated" is set
					return;
				end
				if (GTFO.SpellID[SpellID].damageMinimum and GTFO.SpellID[SpellID].damageMinimum > damage) then
					--GTFO_DebugPrint("Won't alert "..SpellName.." ("..SpellID..") - Minimum damage amount not exceeded");
					-- Not enough damage was caused
					return;
				end
				alertID = GTFO_GetAlertID(GTFO.SpellID[SpellID], "player");
				if (GTFO.SpellID[SpellID].test) then
					GTFO_ScanPrint("TEST ALERT: Spell ID #"..SpellID);
				end
				GTFO_PlaySound(alertID);
				if (SpellType == "SPELL_PERIODIC_DAMAGE" or SpellType == "SPELL_DAMAGE" or SpellType == "SPELL_ENERGIZE") then
					GTFO_RecordStats(alertID, SpellID, SpellName, damage, SpellSourceName);
				else
					GTFO_RecordStats(alertID, SpellID, "+"..SpellName, 0, SpellSourceName);
				end
				return;
			end
		elseif (SpellType=="SWING_DAMAGE" or SpellType=="SWING_MISSED") then
			-- Melee hit detection
			local SourceMobID = tostring(GTFO_GetMobId(sourceGUID));
			if (GTFO.MobID[SourceMobID]) then
				if (GTFO.MobID[SourceMobID].test and not GTFO.Settings.TestMode) then
					return;
				end
				if (GTFO.MobID[SourceMobID].trivialLevel and not GTFO.Settings.TrivialMode and GTFO.MobID[SourceMobID].trivialLevel <= UnitLevel("player")) then
					-- Trivial mode is off, ignore trivial mob
					return;
				end
				if (SpellType=="SWING_DAMAGE") then
					local damage = tonumber(misc1) or 0
					if (damage > 0 or not GTFO.MobID[SourceMobID].damageOnly) then
						alertID = GTFO_GetAlertID(GTFO.MobID[SourceMobID], "player");
						GTFO_PlaySound(alertID);
						GTFO_RecordStats(alertID, 6603, sourceName, tonumber(damage), nil);
						return;						
					end
				elseif (not GTFO.MobID[SourceMobID].damageOnly and SpellType=="SWING_MISSED") then
					alertID = GTFO_GetAlertID(GTFO.MobID[SourceMobID], "player");
					GTFO_PlaySound(alertID);
					GTFO_RecordStats(alertID, 6603, sourceName, 0, nil);
					return;						
				end
			end
		end
		return;
	end
	if (event == "MIRROR_TIMER_START") then
		-- Fatigue bar warning
		local sType, iValue, iMaxValue, iScale, bPaused, sLabel = ...;
		if (sType == "EXHAUSTION" and iScale < 0) then
			if (GTFO.Settings.IgnoreOptions and GTFO.Settings.IgnoreOptions["Fatigue"]) then
				-- Fatigue being ignored
				--GTFO_DebugPrint("Won't alert FATIGUE - Manually ignored");
				return;
			end
			GTFO_PlaySound(1);
		end
		return;
	end
	if (event == "CHAT_MSG_ADDON") then
		local msgPrefix, msgMessage, msgType, msgSender = ...;
		if (msgPrefix == "GTFO" and msgMessage and msgMessage ~= "") then
			local iSlash = string.find(msgMessage,":",1);
			if (iSlash) then
				local sCommand = string.sub(msgMessage,1,iSlash - 1);
				local sValue = string.sub(msgMessage,iSlash + 1);
				if (sCommand == "V" and sValue) then
					-- Version update received
					--GTFO_DebugPrint(msgSender.." sent version info '"..sValue.."' to "..msgType);
					if (not GTFO.Users[msgSender]) then
						GTFO_SendUpdate(msgType);
					end
					GTFO.Users[msgSender] = sValue;
					if ((tonumber(sValue) > GTFO.VersionNumber) and not GTFO.UpdateFound) then
						GTFO.UpdateFound = GTFO_ParseVersionNumber(sValue);
						if (not GTFO.Settings.NoVersionReminder) then
						--163uiedit
						--GTFO_ChatPrint(string.format(GTFOLocal.Loading_OutOfDate, GTFO.UpdateFound));
						end
					end
					return;
				elseif (sCommand == "U" and sValue) then
					-- Version Request
					--GTFO_DebugPrint(msgSender.." requested update to "..sValue);
					GTFO_SendUpdate(sValue);
					return;
				end
			end
		end
		return;
	end
	if (event == "GROUP_ROSTER_UPDATE") then
		--GTFO_DebugPrint("Group roster was updated");
		local sentUpdate = nil;
		GTFO_ScanGroupGUID();
		local PartyMembers = GetNumSubgroupMembers();
		if (PartyMembers > GTFO.PartyMembers and GTFO.RaidMembers == 0) then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				GTFO_SendUpdate("INSTANCE_CHAT");
			else
				GTFO_SendUpdate("PARTY");
			end
			sentUpdate = true;
		end
		GTFO.PartyMembers = PartyMembers;

		local RaidMembers = GetNumGroupMembers();		
		if (not IsInRaid()) then
			RaidMembers = 0
		end

		if (RaidMembers > GTFO.RaidMembers) then
			if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
				if (not sentUpdate) then
					GTFO_SendUpdate("INSTANCE_CHAT");
				end
			else
				GTFO_SendUpdate("RAID");
			end
		end
		GTFO.RaidMembers = RaidMembers;		
		return;
	end
	if (event == "UNIT_INVENTORY_CHANGED") then
		local msgUnit = ...;
		if (UnitIsUnit(msgUnit, "PLAYER")) then
			--GTFO_DebugPrint("Inventory changed, check tank mode");
			GTFO.TankMode = GTFO_CheckTankMode();
		end
		return;
	end
	if (event == "UPDATE_SHAPESHIFT_FORM") then
		--GTFO_DebugPrint("Form changed, check tank mode");
		GTFO.TankMode = GTFO_CheckTankMode();
		return;
	end
	if (event == "CHAT_MSG_MONSTER_YELL") then
		local msgBoss = ...;
		if (msgBoss == GTFOLocal.Boss_Nefarian_Phase2) then
			GTFO_AddEvent("NefarianIgnoreMagma", 17); -- 17 seconds from Nefarian's warning to getting on the pillar
		end
		return;
	end
	if (event == "ACTIVE_TALENT_GROUP_CHANGED" or event == "PLAYER_TALENT_UPDATE") then
		--GTFO_DebugPrint("Spec changed, check tank/caster mode -- "..event);
		GTFO.TankMode = GTFO_CheckTankMode();
		GTFO.CasterMode = GTFO_CheckCasterMode();
		return;
	end
end

function GTFO_ScanGroupGUID()
	GTFO.GroupGUID = { };
	local partyMembers, raidMembers;
	raidMembers = GetNumGroupMembers();
	partyMembers = GetNumSubgroupMembers();
	if (not IsInRaid()) then
		raidMembers = 0
	end
	if (raidMembers > 0) then
		for i = 1, raidMembers, 1 do
			if not (UnitIsUnit("raid"..i, "player")) then
				tinsert(GTFO.GroupGUID, UnitGUID("raid"..i));
			end;
		end
	end
	if (partyMembers > 0) then
		for i = 1, partyMembers, 1 do
			if not (UnitIsUnit("party"..i, "player")) then
				tinsert(GTFO.GroupGUID, UnitGUID("party"..i));
			end;
		end
	end
end

function GTFO_Command(arg1)
	local Command = string.upper(arg1);
	local DescriptionOffset = string.find(arg1,"%s",1);
	local Description = nil;
	
	if (DescriptionOffset) then
		Command = string.upper(string.sub(arg1, 1, DescriptionOffset - 1));
		Description = tostring(string.sub(arg1, DescriptionOffset + 1));
	end
	
	--GTFO_DebugPrint("Command executed: "..Command);
	
	if (Command == "OPTION" or Command == "OPTIONS") then
		GTFO_Command_Options();
	elseif (Command == "STANDBY") then
		GTFO_Command_Standby();
	elseif (Command == "DEBUG") then
		GTFO_Command_Debug();
	elseif (Command == "SCAN" or Command == "SCANNER") then
		GTFO_Command_Scan();
	elseif (Command == "TESTMODE") then
		GTFO_Command_TestMode();
	elseif (Command == "VERSION") then
		GTFO_Command_Version();
	elseif (Command == "TEST") then
		if (DescriptionOffset) then
			GTFO_Command_Test(tonumber(Description));
		else
			GTFO_Command_Test(1);
		end
	elseif (Command == "TEST1") then
		GTFO_Command_Test(1);
	elseif (Command == "TEST2") then
		GTFO_Command_Test(2);
	elseif (Command == "TEST3") then
		GTFO_Command_Test(3);
	elseif (Command == "TEST4") then
		GTFO_Command_Test(4);
	elseif (Command == "NOVERSION") then
		GTFO_Command_VersionReminder();
	elseif (Command == "DATA") then
		GTFO_Command_Data();
	elseif (Command == "CLEAR") then
		GTFO_Command_ClearData();
	elseif (Command == "HELP" or Command == "") then
		GTFO_Command_Help();
	else
		GTFO_Command_Help();
	end
end

function GTFO_Command_Test(iSound)
	if (iSound == 1) then
		GTFO_PlaySound(1);
		if (GTFO.Settings.Sounds[1]) then
			GTFO_ChatPrint(GTFOLocal.TestSound_High);
		else
			GTFO_ChatPrint(GTFOLocal.TestSound_HighMuted);		
		end
	elseif (iSound == 2) then
		GTFO_PlaySound(2);
		if (GTFO.Settings.Sounds[2]) then
			GTFO_ChatPrint(GTFOLocal.TestSound_Low);
		else
			GTFO_ChatPrint(GTFOLocal.TestSound_LowMuted);		
		end
	elseif (iSound == 3) then			
		GTFO_PlaySound(3);
		if (GTFO.Settings.Sounds[3]) then
			GTFO_ChatPrint(GTFOLocal.TestSound_Fail);
		else
			GTFO_ChatPrint(GTFOLocal.TestSound_FailMuted);		
		end
	elseif (iSound == 4) then			
		GTFO_PlaySound(4);
		if (GTFO.Settings.Sounds[4]) then
			GTFO_ChatPrint(GTFOLocal.TestSound_FriendlyFire);
		else
			GTFO_ChatPrint(GTFOLocal.TestSound_FriendlyFireMuted);		
		end
	end
end

function GTFO_Command_Debug()
	if (GTFO.Settings.DebugMode) then
		GTFO.Settings.DebugMode = nil;
		GTFO_ChatPrint("Debug mode off.");
	else
		GTFO.Settings.DebugMode = true;
		GTFO_ChatPrint("Debug mode on.");
	end
	GTFO_SaveSettings();
end

function GTFO_Command_Scan()
	if (GTFO.Settings.ScanMode) then
		GTFO.Settings.ScanMode = nil;
		GTFO_ChatPrint("Scan mode off.");
	else
		GTFO.Settings.ScanMode = true;
		GTFO_ChatPrint("Scan mode on.");
	end
	GTFO_SaveSettings();
end

function GTFO_Command_TestMode()
	if (GTFO.Settings.TestMode) then
		GTFO.Settings.TestMode = nil;
		GTFO_ChatPrint("Test mode off.");
	else
		GTFO.Settings.TestMode = true;
		GTFO_ChatPrint("Test mode on.");
	end
	GTFO_SaveSettings();
end

function GTFO_Command_Standby()
	if (GTFO.Settings.Active) then
		GTFO.Settings.Active = nil;
		GTFO_ChatPrint(GTFOLocal.Active_Off);
	else
		GTFO.Settings.Active = true;
		GTFO_ChatPrint(GTFOLocal.Active_On);
	end
	GTFO_SaveSettings();
	GTFO_ActivateMod();
end

function GTFO_Command_VersionReminder()
	if (GTFO.Settings.NoVersionReminder) then
		GTFO.Settings.NoVersionReminder = nil;
		GTFO_ChatPrint(GTFOLocal.Version_On);
	else
		GTFO.Settings.NoVersionReminder = true;
		GTFO_ChatPrint(GTFOLocal.Version_Off);
	end
	GTFO_SaveSettings();
end

function GTFO_OnLoad()
	GTFOFrame:RegisterEvent("VARIABLES_LOADED");
	GTFOFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
	GTFOFrame:RegisterEvent("CHAT_MSG_ADDON");
	GTFOFrame:RegisterEvent("MIRROR_TIMER_START");
	GTFOFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	SlashCmdList["GTFO"] = GTFO_Command;
	SLASH_GTFO1 = "/GTFO";
end

function GTFO_PlaySound(iSound, bOverride)
	if ((iSound or 0) == 0) then
		return;
	end
	
	local currentTime = GetTime();
	if (GTFO.IgnoreTime) then
		if (currentTime < GTFO.IgnoreTime) then
			return;
		end
	end
	GTFO.IgnoreTime = currentTime + GTFO.IgnoreTimeAmount;

	if (bOverride or GTFO.Settings.Sounds[iSound]) then
		local soundChannel = GTFO.Settings.SoundChannel;
		if (bOverride) then
			--soundChannel = UIDropDownMenu_GetSelectedValue(GTFO_SoundChannelDropdown) or soundChannel;
		end
		if (bOverride and getglobal("GTFO_UnmuteButton"):GetChecked()) then
			GTFO_UnmuteSound(GTFO.SoundTimes[iSound], soundChannel);
		elseif (GTFO.Settings.UnmuteMode and GTFO.SoundTimes[iSound] and not bOverride) then
			GTFO_UnmuteSound(GTFO.SoundTimes[iSound], soundChannel);
		end
		if (GTFO.Settings.SoundOverrides[iSound]) then
			PlaySoundFile(GTFO.Settings.SoundOverrides[iSound], soundChannel);
		else
			PlaySoundFile(GTFO.Sounds[iSound], soundChannel);
		end
		
		if (GTFO.Settings.Volume >= 4) then
			if (GTFO.Settings.SoundOverrides[iSound]) then
				PlaySoundFile(GTFO.Settings.SoundOverrides[iSound], soundChannel);
			else
				PlaySoundFile(GTFO.Sounds[iSound], soundChannel);
			end
		end
		if (GTFO.Settings.Volume >= 5) then
			if (GTFO.Settings.SoundOverrides[iSound]) then
				PlaySoundFile(GTFO.Settings.SoundOverrides[iSound], soundChannel);
			else
				PlaySoundFile(GTFO.Sounds[iSound], soundChannel);
			end
		end
	end
	GTFO_DisplayAura(iSound);
end

-- Create Addon Menu options and interface
--local GTFO_SoundChannelDropdown;
function GTFO_RenderOptions()
	GTFO.UIRendered = true;

	local ConfigurationPanel = CreateFrame("FRAME","GTFO_MainFrame");
	ConfigurationPanel.name = "GTFO";
	InterfaceOptions_AddCategory(ConfigurationPanel);

	local IntroMessageHeader = ConfigurationPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
	IntroMessageHeader:SetPoint("TOPLEFT", 10, -10);
	IntroMessageHeader:SetText("GTFO "..GTFO.Version);

	local EnabledButton = CreateFrame("CheckButton", "GTFO_EnabledButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	EnabledButton:SetPoint("TOPLEFT", 10, -35)
	EnabledButton.tooltip = GTFOLocal.UI_EnabledDescription;
	getglobal(EnabledButton:GetName().."Text"):SetText(GTFOLocal.UI_Enabled);

	local HighSoundButton = CreateFrame("CheckButton", "GTFO_HighSoundButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	HighSoundButton:SetPoint("TOPLEFT", 10, -65)
	HighSoundButton.tooltip = GTFOLocal.UI_HighDamageDescription;
	getglobal(HighSoundButton:GetName().."Text"):SetText(GTFOLocal.UI_HighDamage);

	local LowSoundButton = CreateFrame("CheckButton", "GTFO_LowSoundButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	LowSoundButton:SetPoint("TOPLEFT", 10, -95)
	LowSoundButton.tooltip = GTFOLocal.UI_LowDamageDescription;
	getglobal(LowSoundButton:GetName().."Text"):SetText(GTFOLocal.UI_LowDamage);

	local FailSoundButton = CreateFrame("CheckButton", "GTFO_FailSoundButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	FailSoundButton:SetPoint("TOPLEFT", 10, -125)
	FailSoundButton.tooltip = GTFOLocal.UI_FailDescription;
	getglobal(FailSoundButton:GetName().."Text"):SetText(GTFOLocal.UI_Fail);

	local FriendlyFireSoundButton = CreateFrame("CheckButton", "GTFO_FriendlyFireSoundButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	FriendlyFireSoundButton:SetPoint("TOPLEFT", 10, -155)
	FriendlyFireSoundButton.tooltip = GTFOLocal.UI_FriendlyFireDescription;
	getglobal(FriendlyFireSoundButton:GetName().."Text"):SetText(GTFOLocal.UI_FriendlyFire);

	local HighTestButton = CreateFrame("Button", "GTFO_HighTestButton", ConfigurationPanel, "OptionsButtonTemplate");
	HighTestButton:SetPoint("TOPLEFT", 300, -65);
	HighTestButton.tooltip = GTFOLocal.UI_TestDescription;
	HighTestButton:SetScript("OnClick",GTFO_Option_HighTest);
	getglobal(HighTestButton:GetName().."Text"):SetText(GTFOLocal.UI_Test);

	local LowTestButton = CreateFrame("Button", "GTFO_LowTestButton", ConfigurationPanel, "OptionsButtonTemplate");
	LowTestButton:SetPoint("TOPLEFT", 300, -95);
	LowTestButton.tooltip = GTFOLocal.UI_TestDescription;
	LowTestButton:SetScript("OnClick",GTFO_Option_LowTest);
	getglobal(LowTestButton:GetName().."Text"):SetText(GTFOLocal.UI_Test);

	local FailTestButton = CreateFrame("Button", "GTFO_FailTestButton", ConfigurationPanel, "OptionsButtonTemplate");
	FailTestButton:SetPoint("TOPLEFT", 300, -125);
	FailTestButton.tooltip = GTFOLocal.UI_TestDescription;
	FailTestButton:SetScript("OnClick",GTFO_Option_FailTest);
	getglobal(FailTestButton:GetName().."Text"):SetText(GTFOLocal.UI_Test);

	local FriendlyFireTestButton = CreateFrame("Button", "GTFO_FriendlyFireTestButton", ConfigurationPanel, "OptionsButtonTemplate");
	FriendlyFireTestButton:SetPoint("TOPLEFT", 300, -155);
	FriendlyFireTestButton.tooltip = GTFOLocal.UI_TestDescription;
	FriendlyFireTestButton:SetScript("OnClick",GTFO_Option_FriendlyFireTest);
	getglobal(FriendlyFireTestButton:GetName().."Text"):SetText(GTFOLocal.UI_Test);

	local VolumeText = ConfigurationPanel:CreateFontString("GTFO_VolumeText","ARTWORK","GameFontNormal");
	VolumeText:SetPoint("TOPLEFT", 170, -195);
	VolumeText:SetText("");

	local VolumeSlider = CreateFrame("Slider", "GTFO_VolumeSlider", ConfigurationPanel, "OptionsSliderTemplate");
	VolumeSlider:SetPoint("TOPLEFT", 12, -195);
	VolumeSlider.tooltip = GTFOLocal.UI_VolumeDescription;
	VolumeSlider:SetScript("OnValueChanged",GTFO_Option_SetVolume);
	getglobal(GTFO_VolumeSlider:GetName().."Text"):SetText(GTFOLocal.UI_Volume);
	getglobal(GTFO_VolumeSlider:GetName().."High"):SetText(GTFOLocal.UI_VolumeMax);
	getglobal(GTFO_VolumeSlider:GetName().."Low"):SetText(GTFOLocal.UI_VolumeMin);
	VolumeSlider:SetMinMaxValues(1,5);
	VolumeSlider:SetValueStep(1);
	VolumeSlider:SetValue(GTFO.Settings.Volume);
	GTFO_Option_SetVolumeText(GTFO.Settings.Volume);
	
	local UnmuteButton = CreateFrame("CheckButton", "GTFO_UnmuteButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	UnmuteButton:SetPoint("TOPLEFT", 10, -240)
	UnmuteButton.tooltip = GTFOLocal.UI_UnmuteDescription.."\n\n("..GTFOLocal.UI_UnmuteDescription2..")";
	getglobal(UnmuteButton:GetName().."Text"):SetText(GTFOLocal.UI_Unmute);

	local TrivialButton = CreateFrame("CheckButton", "GTFO_TrivialButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	TrivialButton:SetPoint("TOPLEFT", 10, -270)
	TrivialButton.tooltip = GTFOLocal.UI_TrivialDescription.."\n\n"..GTFOLocal.UI_TrivialDescription2;
	getglobal(TrivialButton:GetName().."Text"):SetText(GTFOLocal.UI_Trivial);

	local TrivialDamageText = ConfigurationPanel:CreateFontString("GTFO_TrivialDamageText","ARTWORK","GameFontNormal");
	TrivialDamageText:SetPoint("TOPLEFT", 450, -270);
	TrivialDamageText:SetText("");

	local TrivialDamageSlider = CreateFrame("Slider", "GTFO_TrivialDamageSlider", ConfigurationPanel, "OptionsSliderTemplate");
	TrivialDamageSlider:SetPoint("TOPLEFT", 300, -270);
	TrivialDamageSlider.tooltip = GTFOLocal.UI_TrivialSlider;
	TrivialDamageSlider:SetScript("OnValueChanged",GTFO_Option_SetTrivialDamage);
	getglobal(GTFO_TrivialDamageSlider:GetName().."Text"):SetText(GTFOLocal.UI_TrivialSlider);
	getglobal(GTFO_TrivialDamageSlider:GetName().."High"):SetText(" ");
	getglobal(GTFO_TrivialDamageSlider:GetName().."Low"):SetText(" ");
	TrivialDamageSlider:SetMinMaxValues(.5,10);
	TrivialDamageSlider:SetValueStep(.5);
	TrivialDamageSlider:SetValue(GTFO.Settings.TrivialDamagePercent);
	GTFO_Option_SetTrivialDamageText(GTFO.Settings.TrivialDamagePercent);

	local TestModeButton = CreateFrame("CheckButton", "GTFO_TestModeButton", ConfigurationPanel, "ChatConfigCheckButtonTemplate");
	TestModeButton:SetPoint("TOPLEFT", 10, -300)
	TestModeButton.tooltip = GTFOLocal.UI_TestModeDescription.."\n\n"..string.format(GTFOLocal.UI_TestModeDescription2,"zensunim","gmail","com");
	getglobal(TestModeButton:GetName().."Text"):SetText(GTFOLocal.UI_TestMode);

	--[[
	local SoundChannelText = ConfigurationPanel:CreateFontString("GTFO_SoundChannelText","ARTWORK","GameFontNormal");
	SoundChannelText:SetPoint("TOPLEFT", 10, -330);
	SoundChannelText:SetText(GTFOLocal.UI_SoundChannel);
	SoundChannelText.tooltip = UI_SoundChannelDescription;
	
	GTFO_SoundChannelDropdown = CreateFrame("Button", "GTFO_SoundChannelDropdown", ConfigurationPanel, "UIDropDownMenuTemplate");
	GTFO_SoundChannelDropdown:SetPoint("TOPLEFT", 10, -350)
	UIDropDownMenu_Initialize(GTFO_SoundChannelDropdown, GTFO_SoundChannelDropdownInitialize);
  UIDropDownMenu_SetWidth(GTFO_SoundChannelDropdown, 150);
  UIDropDownMenu_SetButtonWidth(GTFO_SoundChannelDropdown, 124);
  UIDropDownMenu_SetSelectedValue(GTFO_SoundChannelDropdown, GTFO.Settings.SoundChannel);
  UIDropDownMenu_JustifyText(GTFO_SoundChannelDropdown, "LEFT");
  ]]--

	-- Special Alerts frame

	local IgnoreOptionsPanel = CreateFrame("FRAME","GTFO_IgnoreOptionsFrame");
	IgnoreOptionsPanel.name = GTFOLocal.UI_SpecialAlerts;
	IgnoreOptionsPanel.parent = ConfigurationPanel.name;
	InterfaceOptions_AddCategory(IgnoreOptionsPanel);

	local IntroMessageHeader2 = IgnoreOptionsPanel:CreateFontString(nil, "ARTWORK","GameFontNormalLarge");
	IntroMessageHeader2:SetPoint("TOPLEFT", 10, -10);
	IntroMessageHeader2:SetText("GTFO "..GTFO.Version.." - "..GTFOLocal.UI_SpecialAlertsHeader);

	local yCount = -20;
	for key, option in pairs(GTFO.IgnoreSpellCategory) do
		if (GTFO.IgnoreSpellCategory[key].spellID) then
			yCount = yCount - 30;

			local IgnoreAlertButton = CreateFrame("CheckButton", "GTFO_IgnoreAlertButton_"..key, IgnoreOptionsPanel, "ChatConfigCheckButtonTemplate");
			IgnoreAlertButton:SetPoint("TOPLEFT", 10, yCount)
			getglobal(IgnoreAlertButton:GetName().."Text"):SetText(GTFO.IgnoreSpellCategory[key].desc);
			if (GTFO.IgnoreSpellCategory[key].tooltip) then
				_G["GTFO_IgnoreAlertButton_"..key].tooltip = GTFO.IgnoreSpellCategory[key].tooltip;
			end
		end
	end

	GTFOSpellTooltip:ClearLines();

	-- Confirmation buttons Logic
	GTFO.Settings.OriginalVolume = GTFO.Settings.Volume;
	GTFO.Settings.OriginalTrivialDamagePercent = GTFO.Settings.TrivialDamagePercent;

	ConfigurationPanel.okay = 
		function (self)
			GTFO.Settings.Active = EnabledButton:GetChecked();
			GTFO.Settings.Sounds[1] = HighSoundButton:GetChecked();
			GTFO.Settings.Sounds[2] = LowSoundButton:GetChecked();
			GTFO.Settings.Sounds[3] = FailSoundButton:GetChecked();
			GTFO.Settings.Sounds[4] = FriendlyFireSoundButton:GetChecked();
			GTFO.Settings.Volume = VolumeSlider:GetValue();
			GTFO.Settings.TrivialDamagePercent = TrivialDamageSlider:GetValue();
			--GTFO.Settings.SoundChannel = SoundChannelDropdown:GetValue();
			GTFO.Settings.TestMode = TestModeButton:GetChecked();
			GTFO.Settings.UnmuteMode = UnmuteButton:GetChecked();
			GTFO.Settings.TrivialMode = TrivialButton:GetChecked();
			for key, option in pairs(GTFO.IgnoreSpellCategory) do
				if (getglobal("GTFO_IgnoreAlertButton_"..key):GetChecked()) then
					GTFO.Settings.IgnoreOptions[key] = nil;
				else
					-- Option unchecked, add to ignore list
					GTFO.Settings.IgnoreOptions[key] = true;
				end
			end
			--GTFO.Settings.SoundChannel = UIDropDownMenu_GetSelectedValue(GTFO_SoundChannelDropdown);

			GTFO_SaveSettings();
		end
	ConfigurationPanel.cancel = 
		function (self)
			VolumeSlider:SetValue(GTFO.Settings.OriginalVolume);
			TrivialDamageSlider:SetValue(GTFO.Settings.OriginalTrivialDamagePercent);
			--UIDropDownMenu_Initialize(GTFO_SoundChannelDropdown, GTFO_SoundChannelDropdownInitialize);
			--UIDropDownMenu_SetSelectedValue(GTFO_SoundChannelDropdown, GTFO.Settings.SoundChannel);
			GTFO_SaveSettings();
		end
	ConfigurationPanel.default = 
		function (self)
			GTFO_SetDefaults();
		end
end

function GTFO_SoundChannelDropdownInitialize(self, level)
  --[[
  for id, soundChannel in pairs(GTFO.SoundChannels) do
    local info;
    info = UIDropDownMenu_CreateInfo();
    info.text = soundChannel.Name;
    info.value = soundChannel.Code;
    info.arg1 = id;
    info.func = function(self, arg1, arg2, checked)
    	UIDropDownMenu_SetSelectedValue(GTFO_SoundChannelDropdown, self.value);
    end
    UIDropDownMenu_AddButton(info, level);
  end
  ]]--
end

function GTFO_RefreshOptions()
	-- Spell info isn't available right away, so do this after loading
	for key, option in pairs(GTFO.IgnoreSpellCategory) do
		if (GTFO.IgnoreSpellCategory[key].spellID and not (GetLocale() == "enUS" and GTFO.IgnoreSpellCategory[key].override)) then
			local IgnoreAlertButton = _G["GTFO_IgnoreAlertButton_"..key];
			if (IgnoreAlertButton) then
				local spellID = GTFO.IgnoreSpellCategory[key].spellID;
				local spellName = GetSpellInfo(spellID);
				if (spellName) then
					getglobal(IgnoreAlertButton:GetName().."Text"):SetText(spellName);
				
					GTFOSpellTooltip:SetOwner(_G["GTFOFrame"],"ANCHOR_NONE");
					GTFOSpellTooltip:ClearLines();
					GTFOSpellTooltip:SetHyperlink(GetSpellLink(spellID));
					local tooltipText = tostring(getglobal("GTFOSpellTooltipTextLeft1"):GetText());
					if (GTFOSpellTooltip:NumLines()) then
						if (getglobal("GTFOSpellTooltipTextLeft"..tostring(GTFOSpellTooltip:NumLines()))) then
							tooltipText = tooltipText.."\n"..tostring(getglobal("GTFOSpellTooltipTextLeft"..tostring(GTFOSpellTooltip:NumLines())):GetText());
						end
					end
					IgnoreAlertButton.tooltip = tooltipText;
				else
					getglobal(IgnoreAlertButton:GetName().."Text"):SetText(GTFO.IgnoreSpellCategory[key].desc);
				end
			end
		end
	end
end

function GTFO_ActivateMod()
	if (GTFO.Settings.Active) then
		GTFOFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	else
		GTFOFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end	
end

-- Event handling
function GTFO_OnUpdate()
	local currentTime = GetTime();
	
	if (#GTFO.Events > 0) then
		for index, event in pairs(GTFO.Events) do
			if (currentTime > event.ExecuteTime) then
				if (event.Code) then
					event:Code();
				end
				if (event.Repeat > 0) then
					event.ExecuteTime = currentTime + event.Repeat;
					--GTFO_DebugPrint("Repeating event #"..index.." for "..event.Repeat.." seconds.");
				else
					--GTFO_DebugPrint("Removing event #"..index.." - "..event.Name);
					tremove(GTFO.Events, index);
				end				
			end
		end
	end
	
	-- Check for GTFO events
	if (#GTFO.Events <= 0) then
		GTFOFrame:SetScript("OnUpdate", nil);
		--GTFO_DebugPrint("Event update checking disabled.");
	end	
end

function GTFO_UnmuteSound(delayTime, soundChannel)
	if (not GTFO_FindEvent("Mute")) then
		GTFO.SoundSettings.EnableAllSound = GetCVar("Sound_EnableAllSound");
		GTFO.SoundSettings.SecondaryCVar = GTFO_GetSoundChannelCVar(soundChannel);
		if (GTFO.SoundSettings.SecondaryCVar) then
			GTFO.SoundSettings.EnableSecondary = GetCVar(GTFO.SoundSettings.SecondaryCVar);
			SetCVar(GTFO.SoundSettings.SecondaryCVar, 1);
		end
		SetCVar("Sound_EnableAllSound", 1);
		--GTFO_DebugPrint("Temporarily unmuting volume for "..delayTime.. " seconds.");
	end
	GTFO_AddEvent("Mute", delayTime, function() GTFO_MuteSound(); end);
end

function GTFO_MuteSound()
	SetCVar("Sound_EnableAllSound", GTFO.SoundSettings.EnableAllSound);
	if (GTFO.SoundSettings.SecondaryCVar) then
		SetCVar(GTFO.SoundSettings.SecondaryCVar, GTFO.SoundSettings.EnableSecondary);
	end
	--GTFO_DebugPrint("Muting sound again.");
end

function GTFO_Command_Help()
	DEFAULT_CHAT_FRAME:AddMessage("[GTFO] "..string.format(GTFOLocal.Help_Intro, GTFO.Version), 0.25, 1.0, 0.25);
	if not (GTFO.Settings.Active) then
		DEFAULT_CHAT_FRAME:AddMessage(GTFOLocal.Help_Suspended, 1.0, 0.1, 0.1);		
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo options|r -- "..GTFOLocal.Help_Options, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo standby|r -- "..GTFOLocal.Help_Suspend, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo version|r -- "..GTFOLocal.Help_Version, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo test|r -- "..GTFOLocal.Help_TestHigh, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo test2|r -- "..GTFOLocal.Help_TestLow, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo test3|r -- "..GTFOLocal.Help_TestFail, 0.25, 1.0, 0.75);
	DEFAULT_CHAT_FRAME:AddMessage("|cFFEEEE00/gtfo test4|r -- "..GTFOLocal.Help_TestFriendlyFire, 0.25, 1.0, 0.75);
end

function GTFO_Option_HighTest()
	GTFO_PlaySound(1, true);
end

function GTFO_Option_LowTest()
	GTFO_PlaySound(2, true);
end

function GTFO_Option_FailTest()
	GTFO_PlaySound(3, true);
end

function GTFO_Option_FriendlyFireTest()
	GTFO_PlaySound(4, true);
end

-- Get a list of all the people in your group/raid using GTFO and their version numbers
function GTFO_Command_Version()
	GTFO_SendUpdateRequest();
	local partymembers, raidmembers;

	partymembers = GetNumSubgroupMembers();
	raidmembers = GetNumGroupMembers();
	if (not IsInRaid()) then
		raidmembers = 0
	end

	local users = 0;

	if (raidmembers > 0 or partymembers > 0) then
		if (raidmembers > 0) then
			for i = 1, raidmembers, 1 do
				local displayName;
				local name, server = UnitName("raid"..i);
				local fullname = name;
				if (server and server ~= "") then
					fullname = name.."-"..server;
					displayName = fullname;
				else
					fullname = name.."-"..GTFO_GetRealmName()
					displayName = name;
				end
				if (GTFO.Users[fullname]) then
					GTFO_ChatPrint(displayName..": "..GTFO_ParseVersionColor(GTFO.Users[fullname]));
					users = users + 1;
				else
					GTFO_ChatPrint(displayName..": |cFF999999"..GTFOLocal.Group_None.."|r");
				end
			end
			GTFO_ChatPrint(string.format(GTFOLocal.Group_RaidMembers, users, raidmembers));
		elseif (partymembers > 0) then
			GTFO_ChatPrint(UnitName("player")..": "..GTFO_ParseVersionColor(GTFO.VersionNumber));
			users = 1;
			for i = 1, partymembers, 1 do
				local displayName;
				local name, server = UnitName("party"..i);
				local fullname = name;
				if (server and server ~= "") then
					fullname = name.."-"..server
					displayName = fullname;
				else
					fullname = name.."-"..GTFO_GetRealmName()
					displayName = name;
				end
				if (GTFO.Users[fullname]) then
					GTFO_ChatPrint(displayName..": "..GTFO_ParseVersionColor(GTFO.Users[fullname]));
					users = users + 1;
				else
					GTFO_ChatPrint(displayName..": |cFF999999"..GTFOLocal.Group_None.."|r");
				end
			end
			GTFO_ChatPrint(string.format(GTFOLocal.Group_PartyMembers, users, (partymembers + 1)));
		end
	else
		GTFO_ErrorPrint(GTFOLocal.Group_NotInGroup);
	end		
end

function GTFO_ParseVersionColor(iVersionNumber)
	local Color = "";
	if (GTFO.VersionNumber < iVersionNumber * 1) then
		Color = "|cFFFFFF00"
	elseif (GTFO.VersionNumber == iVersionNumber * 1) then
		Color = "|cFFFFFFFF"
	else
		Color = "|cFFAAAAAA"
	end
	return Color..GTFO_ParseVersionNumber(iVersionNumber).."|r"
end

function GTFO_ParseVersionNumber(iVersionNumber)
	local sVersion = "";
	local iMajor = math.floor(iVersionNumber * 0.0001);
	local iMinor = math.floor((iVersionNumber - (iMajor * 10000)) * 0.01)
	local iMinor2 = iVersionNumber - (iMajor * 10000) - (iMinor * 100)
	if (iMinor2 > 0) then
		sVersion = iMajor.."."..iMinor.."."..iMinor2
	else
		sVersion = iMajor.."."..iMinor
	end
	return sVersion;
end

function GTFO_SendUpdate(sMethod)
	if not (sMethod == "PARTY" or sMethod == "RAID" or sMethod == "INSTANCE_CHAT") then
		return;
	end
	local currentTime = GetTime();
	if (GTFO.IgnoreUpdateTime) then
		if (currentTime < GTFO.IgnoreUpdateTime) then
			return;
		end
	end
	GTFO.IgnoreUpdateTime = currentTime + GTFO.IgnoreUpdateTimeAmount;

	--GTFO_DebugPrint("Sending version info to "..sMethod);
	C_ChatInfo.SendAddonMessage("GTFO","V:"..GTFO.VersionNumber,sMethod)
end

function GTFO_SendUpdateRequest()
	local currentTime = GetTime();
	if (GTFO.IgnoreUpdateRequestTime) then
		if (currentTime < GTFO.IgnoreUpdateRequestTime) then
			return;
		end
	end
	GTFO.IgnoreUpdateRequestTime = currentTime + GTFO.IgnoreUpdateRequestTimeAmount;

	raidmembers = GetNumGroupMembers();
	partymembers = GetNumSubgroupMembers();
	if (not IsInRaid()) then
		raidmembers = 0
	end
	
	if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
		C_ChatInfo.SendAddonMessage("GTFO","U:INSTANCE_CHAT","INSTANCE_CHAT");
	elseif (raidmembers > 0) then
		C_ChatInfo.SendAddonMessage("GTFO","U:RAID","RAID");
	elseif (partymembers > 0) then
		C_ChatInfo.SendAddonMessage("GTFO","U:PARTY","PARTY");
	end
end

function GTFO_Command_Options()
	InterfaceOptionsFrame_OpenToCategory("GTFO");
	InterfaceOptionsFrame_OpenToCategory("GTFO");
	InterfaceOptionsFrame_OpenToCategory("GTFO");
end

function GTFO_Option_SetVolume()
	if (not GTFO.UIRendered) then
		return;
	end
	GTFO.Settings.Volume = math.floor(getglobal("GTFO_VolumeSlider"):GetValue());
	getglobal("GTFO_VolumeSlider"):SetValue(GTFO.Settings.Volume);
	GTFO_GetSounds();
	GTFO_Option_SetVolumeText(GTFO.Settings.Volume)
end

function GTFO_Option_SetVolumeText(iVolume)
	if (iVolume == 1) then
		getglobal("GTFO_VolumeText"):SetText(GTFOLocal.UI_VolumeQuiet);
	elseif (iVolume == 2) then
		getglobal("GTFO_VolumeText"):SetText(GTFOLocal.UI_VolumeSoft);
	elseif (iVolume == 4) then
		getglobal("GTFO_VolumeText"):SetText(GTFOLocal.UI_VolumeLoud);
	elseif (iVolume == 5) then
		getglobal("GTFO_VolumeText"):SetText(GTFOLocal.UI_VolumeLouder);
	elseif (iVolume > 5) then
		getglobal("GTFO_VolumeText"):SetText(iVolume);
	else
		getglobal("GTFO_VolumeText"):SetText(GTFOLocal.UI_VolumeNormal);
	end
end

function GTFO_Option_SetTrivialDamage()
	if (not GTFO.UIRendered) then
		return;
	end
	GTFO.Settings.TrivialDamagePercent = math.floor(getglobal("GTFO_TrivialDamageSlider"):GetValue() * 10)/10;
	getglobal("GTFO_TrivialDamageSlider"):SetValue(GTFO.Settings.TrivialDamagePercent);
	GTFO_GetSounds();
	GTFO_Option_SetTrivialDamageText(GTFO.Settings.TrivialDamagePercent)
end

function GTFO_Option_SetSoundChannel()
	if (not GTFO.UIRendered) then
		return;
	end
	GTFO.Settings.SoundChannel = "Master";
	--getglobal("GTFO_SoundChannelDropdown"):SetValue(GTFO.Settings.SoundChannel);
end

function GTFO_Option_SetTrivialDamageText(iTrivialDamagePercent)
	if (not GTFO.UIRendered) then
		return;
	end
	getglobal("GTFO_TrivialDamageText"):SetText(iTrivialDamagePercent.."%");
end

-- Detect if the player is tanking or not
function GTFO_CheckTankMode()
	if (GTFO.CanTank) then
		local x, class = UnitClass("player");
		if (class == "DRUID") then
			local stance = GetShapeshiftForm();
			if (stance == 1) then
				--GTFO_DebugPrint("Bear Form found - tank mode activated");
				return true;
			end
		elseif (class == "MONK" or class == "DEMONHUNTER" or class == "WARRIOR" or class == "DEATHKNIGHT" or class == "PALADIN") then
			local spec = GetSpecialization();
			if (spec and GetSpecializationRole(spec) == "TANK") then
				--GTFO_DebugPrint("Tank spec found - tank mode activated");
				return true;
			end
		else
			--GTFO_DebugPrint("Failed Tank Mode - This code shouldn't have ran");
			GTFO.CanTank = nil;
		end
	end
	--GTFO_DebugPrint("Tank mode off");
	return nil;
end

function GTFO_CheckCasterMode()
	if (GTFO.CanCast) then
		local x, class = UnitClass("player");

		if (class == "PRIEST" or class == "MAGE" or class == "WARLOCK") then
			return true;
		end

		local spec = GetSpecialization();
		if (spec) then
			local role = GetSpecializationRole(spec);
			if (role == "TANK") then
				return nil;
			end
			if (role == "HEALER") then
				return true;
			end
		
			local id, _ = GetSpecializationInfo(spec);
			if (id == 102) then
				-- Balance Druid
				return true;
			end
			if (id == 262) then
				-- Elemental Shaman
				return true;
			end
		end
	end
	--GTFO_DebugPrint("Caster mode off");
	return nil;
end

function GTFO_IsTank(target)
	if (GTFO_CanTankCheck(target)) then
		local _, class = UnitClass(target);
		if (class == "PALADIN") then
			-- Check for Righteous Fury
			if (GTFO_HasBuff(target, 25780)) then
				return true;
			end
		elseif (class == "DRUID") then
			-- Check for Bear Form
			if (GTFO_HasBuff(target, 5487)) then
				return true;
			end
		elseif (class == "DEATHKNIGHT") then
			-- Check for Blood Presence
			if (GTFO_HasBuff(target, 48263)) then
				return true;
			end
		elseif (class == "WARRIOR" or class == "MONK" or class == "DEMONHUNTER") then
			-- No definitive way to determine...take a guess.
			if (UnitGroupRolesAssigned(target) == "TANK" or GetPartyAssignment("MAINTANK", target)) then
				return true;
			end
		end	
	end
	return;
end

function GTFO_CanTankCheck(target)
	local _, class = UnitClass(target);
	if (class == "PALADIN" or class == "DRUID" or class == "DEATHKNIGHT" or class == "WARRIOR" or class == "MONK" or class == "DEMONHUNTER") then
		----GTFO_DebugPrint("Possible tank detected for "..target);
		return true;
	else
		----GTFO_DebugPrint("This class isn't a tank");
	end
	return;
end

function GTFO_CanCastCheck(target)
	local _, class = UnitClass(target);
	if (class == "WARRIOR" or class == "HUNTER" or class == "ROGUE" or class == "DEATHKNIGHT") then
		----GTFO_DebugPrint("This class isn't a caster");
		return;
	else
		----GTFO_DebugPrint("Possible caster detected for "..target);
		return true;
	end
end

function GTFO_RegisterTankEvents()
	local _, class = UnitClass("player");
	if (class == "PALADIN") then
		GTFOFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");
	else
		GTFOFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	end
end

function GTFO_RegisterCasterEvents()
	GTFOFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
	GTFOFrame:RegisterEvent("PLAYER_TALENT_UPDATE");	
end

-- Cache sound file locations 
function GTFO_GetSounds()
	if (GTFO.Settings.Volume == 2) then
		GTFO.Sounds = {
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzzer.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbeep.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmdouble.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzz.mp3",
		};
	elseif (GTFO.Settings.Volume == 1) then
		GTFO.Sounds = {
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzzer.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbeep.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmdouble.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzz.mp3",
		};
	else	
		GTFO.Sounds = {
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzzer.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbeep.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmdouble.mp3",
			"Interface\\AddOns\\GTFO\\Sounds\\alarmbuzz.mp3",
		};
	end
end

-- Save settings to persistant storage, refresh UI options
function GTFO_SaveSettings()
	--GTFO_DebugPrint("Saving settings");
	GTFO_Option_SetVolume();

	GTFOData.DataCode = GTFO.DataCode;
	GTFOData.Active = GTFO.Settings.Active;
	GTFOData.Sounds = { };
	GTFOData.Sounds[1] = GTFO.Settings.Sounds[1];
	GTFOData.Sounds[2] = GTFO.Settings.Sounds[2];
	GTFOData.Sounds[3] = GTFO.Settings.Sounds[3];
	GTFOData.Sounds[4] = GTFO.Settings.Sounds[4];
	GTFOData.Volume = GTFO.Settings.Volume;
	GTFOData.ScanMode = GTFO.Settings.ScanMode;
	GTFOData.DebugMode = GTFO.Settings.DebugMode;
	GTFOData.TestMode = GTFO.Settings.TestMode;
	GTFOData.UnmuteMode = GTFO.Settings.UnmuteMode;
	GTFOData.TrivialMode = GTFO.Settings.TrivialMode;
	GTFOData.TrivialDamagePercent = GTFO.Settings.TrivialDamagePercent;
	GTFOData.NoVersionReminder = GTFO.Settings.NoVersionReminder;
	GTFOData.SoundChannel = GTFO.Settings.SoundChannel;
	GTFOData.IgnoreOptions = { };
	if (GTFO.Settings.IgnoreOptions) then
		for key, option in pairs(GTFO.Settings.IgnoreOptions) do
			GTFOData.IgnoreOptions[key] = GTFO.Settings.IgnoreOptions[key];
		end
	end
	GTFOData.SoundOverrides = { };
	if (GTFO.Settings.SoundOverrides) then
		for key, option in pairs(GTFO.Settings.SoundOverrides) do
			GTFOData.SoundOverrides[key] = GTFO.Settings.SoundOverrides[key];
		end
	end

	GTFO.Settings.OriginalVolume = GTFO.Settings.Volume;
	GTFO.Settings.OriginalTrivialDamagePercent = GTFO.Settings.TrivialDamagePercent;
	

	if (GTFO.UIRendered) then
		getglobal("GTFO_EnabledButton"):SetChecked(GTFO.Settings.Active);
		getglobal("GTFO_HighSoundButton"):SetChecked(GTFO.Settings.Sounds[1]);
		getglobal("GTFO_LowSoundButton"):SetChecked(GTFO.Settings.Sounds[2]);
		getglobal("GTFO_FailSoundButton"):SetChecked(GTFO.Settings.Sounds[3]);
		getglobal("GTFO_FriendlyFireSoundButton"):SetChecked(GTFO.Settings.Sounds[4]);
		getglobal("GTFO_TestModeButton"):SetChecked(GTFO.Settings.TestMode);
		getglobal("GTFO_UnmuteButton"):SetChecked(GTFO.Settings.UnmuteMode);
		getglobal("GTFO_TrivialButton"):SetChecked(GTFO.Settings.TrivialMode);

		for key, option in pairs(GTFO.IgnoreSpellCategory) do
			getglobal("GTFO_IgnoreAlertButton_"..key):SetChecked(not GTFO.Settings.IgnoreOptions[key]);
		end
	end
	
	GTFO_ActivateMod();
end

-- Reset all settings to default
function GTFO_SetDefaults()
	GTFO.Settings.Active = GTFO.DefaultSettings.Active;
	GTFO.Settings.Sounds = { };
	GTFO.Settings.Sounds[1] = GTFO.DefaultSettings.Sounds[1];
	GTFO.Settings.Sounds[2] = GTFO.DefaultSettings.Sounds[2];
	GTFO.Settings.Sounds[3] = GTFO.DefaultSettings.Sounds[3];
	GTFO.Settings.Sounds[4] = GTFO.DefaultSettings.Sounds[4];
	GTFO.Settings.Volume = GTFO.DefaultSettings.Volume;
	GTFO.Settings.ScanMode = GTFO.DefaultSettings.ScanMode;
	GTFO.Settings.DebugMode = GTFO.DefaultSettings.DebugMode;
	GTFO.Settings.TestMode = GTFO.DefaultSettings.TestMode;
	GTFO.Settings.UnmuteMode = GTFO.DefaultSettings.UnmuteMode;
	GTFO.Settings.TrivialMode = GTFO.DefaultSettings.TrivialMode;
	GTFO.Settings.NoVersionReminder = GTFO.DefaultSettings.NoVersionReminder;
	GTFO.Settings.TrivialDamagePercent = GTFO.DefaultSettings.TrivialDamagePercent;
	GTFO.Settings.SoundChannel = GTFO.DefaultSettings.SoundChannel;
	if (GTFO.UIRendered) then
		getglobal("GTFO_VolumeSlider"):SetValue(GTFO.DefaultSettings.Volume);
		getglobal("GTFO_TrivialDamageSlider"):SetValue(GTFO.DefaultSettings.TrivialDamagePercent);
		--UIDropDownMenu_Initialize(GTFO_SoundChannelDropdown, GTFO_SoundChannelDropdownInitialize);
		--UIDropDownMenu_SetSelectedValue(GTFO_SoundChannelDropdown, GTFO.Settings.SoundChannel);
	end
	GTFO.Settings.IgnoreOptions = GTFO.DefaultSettings.IgnoreOptions;
	GTFO.Settings.SoundOverrides = GTFO.DefaultSettings.SoundOverrides;
	GTFO_SaveSettings();
end

-- Show pop-up alert
function GTFO_DisplayConfigPopupMessage()
	StaticPopup_Show("GTFO_POPUP_MESSAGE");
end

function GTFO_HasBuff(target, iSpellID)
	if (GTFO_GetBuffSpellIndex(target, iSpellID)) then
		return true;
	else
		return nil;
	end
end

function GTFO_HasDebuff(target, iSpellID)
	if (GTFO_GetDebuffSpellIndex(target, iSpellID)) then
		return true;
	else
		return nil;
	end
end

function GTFO_DebuffStackCount(target, iSpellID)
	local spellName = GetSpellInfo(tonumber(iSpellID));
	if (spellName) then
		local debuffInfo;
		local debuffIndex = GTFO_GetDebuffSpellIndex(target, iSpellID);
		if (debuffIndex) then
			debuffInfo = select(3, UnitDebuff(target, debuffIndex));
		end
		if (debuffInfo) then
			return tonumber(debuffInfo);
		end
	end
	return 0;
end

function GTFO_GetBuffSpellIndex(target, iSpellID)
	if (iSpellID) then
		for i = 1, 40, 1 do
			local buff = select(10, UnitBuff(target, i));
			if (buff) then
				if (tonumber(buff) == tonumber(iSpellID)) then
					return i;
				end
			else
				return nil;
			end
		end
	end
	return nil;
end

function GTFO_GetDebuffSpellIndex(target, iSpellID)
	if (iSpellID) then
		for i = 1, 40, 1 do
			local debuff = select(10, UnitDebuff(target, i));
			if (debuff) then
				if (tonumber(debuff) == tonumber(iSpellID)) then
					return i;
				end
			else
				return nil;
			end
		end
	end
	return nil;
end

function GTFO_GetAlertID(alert, target)
	if (alert.soundFunction) then
		return alert:soundFunction();
	end	

	local alertLevel;
	local tankAlert = false;

	if (alert.tankSound) then
		if (UnitIsUnit("player", target)) then
			if (GTFO.TankMode or (GTFO.RaidMembers == 0 and GTFO.PartyMembers == 0)) then
				-- Tank or soloing
				tankAlert = true;
			end
		elseif (GTFO_IsTank(target)) then
			tankAlert = true;
		end
	end
	
	if (tankAlert and alert.tankSound) then
		alertLevel = alert.tankSound;
	else
		alertLevel = alert.sound or 0;
	end
	
	if ((alert.soundLFR or (tankAlert and alert.tankSoundLFR)) and GTFO_IsInLFR()) then
		if (tankAlert and alert.tankSoundLFR) then
			alertLevel = alert.tankSoundLFR;
		elseif (alert.soundLFR) then
			alertLevel = alert.soundLFR;
		end
	elseif (alert.soundHeroic or alert.soundChallenge or (tankAlert and (alert.tankSoundHeroic or alert.tankSoundChallenge))) then
		local isHeroic, isChallenge = select(3, GetDifficultyInfo(select(3, GetInstanceInfo())));
		if (isChallenge == true) then
			-- Challenge Mode
			if (tankAlert and (alert.tankSoundChallenge or alert.tankSoundHeroic)) then
				alertLevel = alert.tankSoundChallenge or alert.tankSoundHeroic;
			elseif (alert.soundChallenge or alert.soundHeroic) then
				alertLevel = alert.soundChallenge or alert.soundHeroic;
			end
		elseif (isHeroic == true) then
			-- Heroic Mode
			if (tankAlert and alert.tankSoundHeroic) then
				alertLevel = alert.tankSoundHeroic;
			elseif (alert.soundHeroic) then
				alertLevel = alert.soundHeroic;
			end
		end
	end
	
	return alertLevel;
end

function GTFO_GetAlertType(alertID)
	if (alertID == 1) then
		return GTFOLocal.AlertType_High;
	elseif (alertID == 2) then
		return GTFOLocal.AlertType_Low;
	elseif (alertID == 3) then
		return GTFOLocal.AlertType_Fail;
	elseif (alertID == 4) then
		return GTFOLocal.AlertType_FriendlyFire;
	end
	return nil;
end

function GTFO_GetAlertByID(alertName)
	if (alertName == GTFOLocal.AlertType_High) then
		return 1;
	elseif (alertName == GTFOLocal.AlertType_Low) then
		return 2;
	elseif (alertName == GTFOLocal.AlertType_Fail) then
		return 3;
	elseif (alertName == GTFOLocal.AlertType_FriendlyFire) then
		return 4;
	end
	return nil;
end

function GTFO_GetAlertIcon(alertID)
	if (alertID == 1) then
		return "Interface\\Icons\\Spell_Fire_Fire";
	elseif (alertID == 2) then
		return "Interface\\Icons\\Spell_Fire_BlueFire";
	elseif (alertID == 3) then
		return "Interface\\Icons\\Ability_Suffocate";
	elseif (alertID == 4) then
		return "Interface\\Icons\\Spell_Fire_FelFlameRing";
	end
	return nil;
end

function GTFO_AlertIncoming(soundAlert, vehicle, ...)
	local timestamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, misc1, misc2, misc3, misc4, misc5, misc6, misc7 = ...; 
end

function GTFO_AddEvent(eventName, eventTime, eventCode, eventRepeat)
		local event = {
			Name = tostring(eventName);
			ExecuteTime = GetTime() + eventTime;
			Code = eventCode;
			Repeat = 0;
		};
		local eventIndex = nil;
		
		if (eventRepeat) then
			event.Repeat = eventRepeat;
		end

		-- Check for existing event
		eventIndex = GTFO_FindEvent(event.Name);
		
		if (eventIndex) then
			GTFO.Events[eventIndex].ExecuteTime = event.ExecuteTime;
			--GTFO_DebugPrint("Extending event '"..event.Name.."' to be executed in "..eventTime.." seconds.");
		else
			tinsert(GTFO.Events, event);
			--GTFO_DebugPrint("Adding event '"..event.Name.."' to be executed in "..eventTime.." seconds.");			
			GTFOFrame:SetScript("OnUpdate", GTFO_OnUpdate);
			--GTFO_DebugPrint("Event update checking enabled.");
		end
end

function GTFO_FindEvent(eventName)
	if (#GTFO.Events > 0) then
		for index, currentEvent in pairs(GTFO.Events) do
			if (currentEvent.Name == eventName) then
				return index;
			end
		end
	end	
	return nil;
end

function GTFO_RecordStats(alertID, SpellID, SpellName, damage, sourceName)
	if (alertID and alertID > 0 and (GTFO.Recount or GTFO.Skada)) then
		local spellName = SpellName;
		-- Append the name of the person that did damage for Friendly Fire alerts
		if (alertID == 4) then
			if (sourceName and tostring(sourceName) ~= "nil") then
				spellName = spellName.." ("..sourceName..")";
			end
		end
		
		-- Integration
		if (GTFO.Recount) then
			GTFO_RecordRecount(UnitName("player"), alertID, spellName, damage);
		end
		if (GTFO.Skada) then
			GTFO_RecordSkada(UnitName("player"), UnitGUID("player"), alertID, tonumber(SpellID), spellName, tonumber(damage));
		end
	end
end

function GTFO_DisplayAura(alertTypeID)
	-- Integration
	if (GTFO.PowerAuras) then
		GTFO_DisplayAura_PowerAuras(alertTypeID);
	end
	if (GTFO.WeakAuras) then
		GTFO_DisplayAura_WeakAuras(alertTypeID);
	end
end

function GTFO_IsInLFR()
	return IsInGroup(LE_PARTY_CATEGORY_INSTANCE);
end

function GTFO_GetSoundChannelCVar(soundChannel)
	for _, item in pairs(GTFO.SoundChannels) do
	  if (item.Code and item.Code == soundChannel) then
	    return item.CVar;
	  end
	end
	return;	
end

function GTFO_GetRealmName()
	return gsub(GetRealmName(), "%s", "");
end

function GTFO_SpellScan(spellId, spellOrigin, spellDamage)
	if (GTFO.Settings.ScanMode) then
		local damage = tonumber(spellDamage) or 0;
		if not (GTFO.Scans[spellId] or GTFO.SpellID[spellId] or GTFO.FFSpellID[spellId] or GTFO.IgnoreScan[spellId]) then
			GTFO.Scans[spellId] = {
				TimeAdded = GetTime();
				Times = 1;
				SpellID = spellId;
				SpellName = tostring(select(1, GetSpellInfo(spellId)));
				SpellDescription = GetSpellDescription(spellId) or "";
				SpellOrigin = tostring(spellOrigin);
				IsDebuff = (spellDamage == "DEBUFF");
				Damage = damage;
			};
		elseif (GTFO.Scans[spellId]) then
			GTFO.Scans[spellId].Times = GTFO.Scans[spellId].Times + 1;
			GTFO.Scans[spellId].Damage = GTFO.Scans[spellId].Damage + damage;
		end
	end
end

function GTFO_Command_Data()
	if (next(GTFO.Scans) == nil) then
		GTFO_ErrorPrint("No scan data available.");
		return;
	end
	if (not PratCCFrame) then
		GTFO_ErrorPrint("Prat Addon is required to use this feature.");
		return;
	end

	local dataOutput = "";
	local scans = { };
	for key, data in pairs(GTFO.Scans) do
    table.insert(scans, data);
  end
  table.sort(scans, (function(a, b) return tonumber(a.TimeAdded) < tonumber(b.TimeAdded) end));
  
	for _, data in pairs(scans) do
		dataOutput = dataOutput.."-- |cff00ff00"..tostring(data.SpellName).." (x"..data.Times;

		if (data.SpellDescription == nil or data.SpellDescription == "") then
			data.SpellDescription = GetSpellDescription(data.SpellID) or "";
		end
		
		if (data.Damage > 0) then
			dataOutput = dataOutput..", "..data.Damage
		end
		dataOutput = dataOutput..")|r\n";
		dataOutput = dataOutput.."-- |cff00aa00"..tostring(data.SpellDescription or "").."|r\n";
		dataOutput = dataOutput.."GTFO.SpellID[\""..data.SpellID.."\"] = {\n";
		dataOutput = dataOutput.."  --desc = \""..tostring(data.SpellName).." ("..tostring(data.SpellOrigin)..")\";\n";
		if (data.IsDebuff) then
			dataOutput = dataOutput.."  applicationOnly = true;\n";
		end
		dataOutput = dataOutput.."  sound = 1;\n";
		dataOutput = dataOutput.."};\n";
		dataOutput = dataOutput.."\n";
	end

	local display = "|cffffffff"..dataOutput.."|r"
	PratCCText:SetText("GTFO Spells");
	PratCCFrameScrollText:SetText(display);
	PratCCFrame:Show()
end

function GTFO_Command_ClearData()
	GTFO.Scans = { };
	return;
end
