local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, table, next, pairs, ipairs, unpack, select, GetTime = _G, table, next, pairs, ipairs, unpack, select, GetTime
local UnitIsPartyLeader, UnitIsFeignDeath, UnitIsTappedByPlayer, UnitIsUnit, UnitIsCharmed, UnitIsVisible, UnitHasVehicleUI, UnitIsConnected =
	  UnitIsPartyLeader, UnitIsFeignDeath, UnitIsTappedByPlayer, UnitIsUnit, UnitIsCharmed, UnitIsVisible, UnitHasVehicleUI, UnitIsConnected
local UnitExists, UnitGUID, UnitAffectingCombat, UnitIsAFK, UnitIsDeadOrGhost, UnitIsGhost, UnitIsDead, UnitIsDND, UnitIsPVP, UnitIsPVPFreeForAll =
	  UnitExists, UnitGUID, UnitAffectingCombat, UnitIsAFK, UnitIsDeadOrGhost, UnitIsGhost, UnitIsDead, UnitIsDND, UnitIsPVP, UnitIsPVPFreeForAll
local GetNumRaidMembers, GetNumPartyMembers, GetPetHappiness, GetRaidTargetIndex, UnitIsTapped, GetBindingText, GetBindingKey, GetRaidRosterInfo =
	  GetNumRaidMembers, GetNumPartyMembers, GetPetHappiness, GetRaidTargetIndex, UnitIsTapped, GetBindingText, GetBindingKey, GetRaidRosterInfo
local UnitName, UnitInRaid, UnitFactionGroup, GetPVPTimer, IsPVPTimerRunning, GetSpellInfo, IsResting =
	  UnitName, UnitInRaid, UnitFactionGroup, GetPVPTimer, IsPVPTimerRunning, GetSpellInfo, IsResting

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L
local GetNameServer = DogTag_Unit.GetNameServer

local offlineTimes = {}
local afkTimes = {}
local deadTimes = {}

-- Parnic: support for cataclysm; Divine Intervention was removed
local wow_ver = select(4, GetBuildInfo())
local wow_classic = WOW_PROJECT_ID and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local wow_400 = wow_ver >= 40000
local wow_500 = wow_ver >= 50000
local wow_600 = wow_ver >= 60000
local wow_700 = wow_ver >= 70000
local petHappinessEvent = "UNIT_POWER_UPDATE"
local partyChangedEvent = "PARTY_MEMBERS_CHANGED"
if wow_500 or wow_classic then
	UnitIsPartyLeader = UnitIsGroupLeader
	partyChangedEvent = "GROUP_ROSTER_UPDATE"
end

-- Parnic: pet happiness removed in 4.1
local wow_401 = wow_ver >= 40100
-- ...and back in Classic
if wow_classic then
	petHappinessEvent = "UNIT_HAPPINESS"
end

-- Parnic: GetNumRaidMembers/GetNumPartyMembers removed in 6.0
if wow_600 or wow_classic then
	GetNumRaidMembers = GetNumGroupMembers
	GetNumPartyMembers = GetNumGroupMembers
end

local iterateGroupMembers
local iterateGroupMembers__t = {}
do
	function iterateGroupMembers()
		return pairs(iterateGroupMembers__t)
	end
end
_G.iterateGroupMembers = iterateGroupMembers

local tmp = {}
local function PARTY_MEMBERS_CHANGED(event)
	local prefix, min, max = "raid", 1, 0
	if wow_500 then
		max = GetNumGroupMembers()
	else
		max = GetNumRaidMembers()
	end
	if wow_500 and max <= 5 or (not wow_500 and max == 0) then
		prefix, min = "party", 0
		if not wow_500 then
			max = GetNumPartyMembers()
		end
	end

	for k in pairs(iterateGroupMembers__t) do
		iterateGroupMembers__t[k] = nil
	end

	for i = min, max do
		local unit
		if i == 0 then
			unit = 'player'
		else
			unit = prefix .. i
		end

		if not UnitExists(unit) then
			break
		end

		iterateGroupMembers__t[unit] = UnitGUID(unit)
	end

	for unit, guid in iterateGroupMembers() do
		tmp[guid] = true

		if not UnitIsConnected(unit) then
			if not offlineTimes[guid] then
				offlineTimes[guid] = GetTime()
			end
			afkTimes[guid] = nil
		else
			offlineTimes[guid] = nil
			if UnitIsAFK(unit) then
				if not afkTimes[guid] then
					afkTimes[guid] = GetTime()
				end
			else
				afkTimes[guid] = nil
			end
		end
		if UnitIsDeadOrGhost(unit) then
			if not deadTimes[guid] then
				deadTimes[guid] = GetTime()
			end
		else
			deadTimes[guid] = nil
		end
	end

	for guid in pairs(offlineTimes) do
		if not tmp[guid] then
			offlineTimes[guid] = nil
		end
	end
	for guid in pairs(deadTimes) do
		if not tmp[guid] then
			deadTimes[guid] = nil
		end
	end
	for guid in pairs(afkTimes) do
		if not tmp[guid] then
			afkTimes[guid] = nil
		end
	end
	for guid in pairs(tmp) do
		tmp[guid] = nil
	end
end
DogTag:AddEventHandler("Unit", partyChangedEvent, PARTY_MEMBERS_CHANGED)

DogTag:AddAddonFinder("Unit", "_G", "oRA", function(v)
	if AceLibrary and AceLibrary:HasInstance("AceEvent-2.0") then
		AceLibrary("AceEvent-2.0"):RegisterEvent("oRA_MainTankUpdate", function()
			DogTag:FireEvent(partyChangedEvent)
		end)
	end
end)

DogTag:AddAddonFinder("Unit", "_G", "CT_RAOptions_UpdateMTs", function(v)
	hooksecurefunc("CT_RAOptions_UpdateMTs", function()
		DogTag:FireEvent(partyChangedEvent)
	end)
end)

local first = true
DogTag:AddTimerHandler("Unit", function(currentTime, num)
	if first then
		first = false
		PARTY_MEMBERS_CHANGED()
	end
	for guid in pairs(offlineTimes) do
		for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
			DogTag:FireEvent("OfflineDuration", unit)
		end
	end
	for unit, guid in iterateGroupMembers() do
		if UnitIsDeadOrGhost(unit) then
			if not deadTimes[guid] then
				deadTimes[guid] = GetTime()
			end
		else
			if deadTimes[guid] then
				deadTimes[guid] = nil
				for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
					DogTag:FireEvent("DeadDuration", unit)
				end
			end
		end

		if UnitIsAFK(unit) then
			if not afkTimes[guid] then
				afkTimes[guid] = GetTime()
			end
		else
			if afkTimes[guid] then
				afkTimes[guid] = nil
				for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
					DogTag:FireEvent("AFKDuration", unit)
				end
			end
		end
	end
	for guid in pairs(deadTimes) do
		for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
			DogTag:FireEvent("DeadDuration", unit)
		end
	end
	for guid in pairs(afkTimes) do
		for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
			DogTag:FireEvent("AFKDuration", unit)
		end
	end
end)

DogTag:AddTag("Unit", "OfflineDuration", {
	code = function(unit)
		local t = offlineTimes[UnitGUID(unit)]
		if not t then
			return nil
		else
			return GetTime() - t
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "OfflineDuration#$unit",
	doc = L["Return the duration offline if unit is offline"],
	example = ('[OfflineDuration] => "110"; [OfflineDuration:FormatDuration] => "1:50"'),
	category = L["Status"]
})

DogTag:AddTag("Unit", "Offline", {
	alias = ("Concatenate(%q, ' ', OfflineDuration:FormatDuration:Paren)"):format(L["Offline"]),
	doc = L["Return Offline and the time offline if unit is offline"],
	example = ('[Offline] => "%s (2:45)"; [Offline] => ""'):format(L["Offline"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "DeadDuration", {
	code = function(unit)
		local t = deadTimes[UnitGUID(unit)]
		if not t then
			return nil
		else
			return GetTime() - t
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "DeadDuration#$unit",
	doc = L["Return the duration dead if unit is dead and time is known, unit can be dead and have an unknown time of death"],
	example = ('[DeadDuration] => "110"; [DeadDuration:FormatDuration] => "1:50"'),
	category = L["Status"]
})

DogTag:AddTag("Unit", "DeadType", {
	code = function(unit)
		if UnitIsGhost(unit) then
			return L["Ghost"]
		elseif UnitIsDead(unit) then
			return L["Dead"]
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "DeadDuration#$unit",
	doc = L["Return Dead or Ghost if unit is dead"],
	example = ('[DeadType] => "%s"; [DeadType] => "%s"; [DeadType] => ""'):format(L["Dead"], L["Ghost"]),
	category = L["Status"],
})

DogTag:AddTag("Unit", "Dead", {
	alias = "DeadType(unit=unit) Concatenate(' ', DeadDuration(unit=unit):FormatDuration:Paren)",
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return Dead or Ghost and the duration dead if unit is dead"],
	example = ('[Dead] => "%s (1:34)"; [Dead] => "%s"; [Dead] => ""'):format(L["Dead"], L["Ghost"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "AFKDuration", {
	code = function(unit)
		local t = afkTimes[UnitGUID(unit)]
		if not t then
			return nil
		else
			return GetTime() - t
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "AFKDuration#$unit",
	doc = L["Return the duration AFK if unit is AFK"],
	example = ('[AFKDuration] => "110"; [AFKDuration:FormatDuration] => "1:50"'),
	category = L["Status"]
})

DogTag:AddTag("Unit", "AFK", {
	alias = ("Concatenate(%q, ' ', AFKDuration:FormatDuration:Paren)"):format(L["AFK"]),
	doc = L["Return AFK and the time AFK if unit is AFK"],
	example = ('[AFK] => "%s (2:12)"; [AFK] => ""'):format(L["AFK"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "DND", {
	code = function(unit)
		if UnitIsDND(unit) then
			return L["DND"]
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "PLAYER_FLAGS_CHANGED#$unit",
	doc = L["Return DND if the unit has specified DND"],
	example = ('[DND] => %q; [DND] => ""'):format(L["DND"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "PvPDuration", {
	code = function()
		if IsPVPTimerRunning() then
			return GetPVPTimer() / 1000
		else
			return nil
		end
	end,
	ret = 'number;nil',
	events = 'PLAYER_FLAGS_CHANGED;Update',
	doc = L["Return the duration until the players PVP flag wears off"],
	example = ('[PvPDuration] => "110"; [PvPDuration:FormatDuration] => "1:50"'),
	category = L["Status"]
})

DogTag:AddTag("Unit", "PvP", {
	code = function(unit)
		if UnitIsPVPFreeForAll(unit) then
			return L["FFA"]
		elseif UnitIsPVP(unit) then
			return L["PvP"]
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "UNIT_FACTION#$unit",
	doc = L["Return PvP or FFA if the unit is PvP-enabled"],
	example = ('[PvP] => %q; [PvP] => %q; [PvP] => ""'):format(L["PvP"], L["FFA"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "PvPIcon", {
	code = function(size, unit)
		local has
		if UnitIsPVPFreeForAll(unit) then
			has = 'FFA'
		elseif UnitIsPVP(unit) then
			has = UnitFactionGroup(unit)
		end
		if has then
			if has == "Neutral" then
				has = "FFA"
			end
			return "|TInterface\\TargetingFrame\\UI-PVP-" .. has .. ":" .. size .. ":".. size .. ":0:0:64:64:3:38:1:36|t"
		else
			return nil
		end
	end,
	arg = {
		'size', 'number', 12,
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "UNIT_FACTION#$unit",
	doc = L["Display the appropriate PvP icon if the unit is PvP flagged"],
	example = '[PvPIcon] => "|TInterface\\TargetingFrame\\UI-PVP-Horde:24:24:0:0:64:64:3:38:1:36|t"; [PvPIcon] => ""',
	category = L["Status"]
})

DogTag:AddTag("Unit", "CombatIcon", {
	code = function(size, unit)
		if UnitAffectingCombat(unit) then
			return ("|TInterface\\CharacterFrame\\UI-StateIcon:%d:%d:0:0:64:64:32:64:0:32|t"):format(size, size)
		else
			return nil
		end
	end,
	arg = {
		'size', 'number', 32,
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Update",
	doc = L["Display the combat icon if the unit is in combat"],
	example = '[CombatIcon] => "|TInterface\\CharacterFrame\\UI-StateIcon:32:32:0:0:64:64:32:64:0:32|t"; [CombatIcon] => ""',
	category = L["Status"]
})

DogTag:AddTag("Unit", "RestingIcon", {
	code = function(size)
		if IsResting() then
			return ("|TInterface\\CharacterFrame\\UI-StateIcon:%d:%d:0:0:64:64:0:32:0:32|t"):format(size, size)
		else
			return nil
		end
	end,
	arg = {
		'size', 'number', 32,
	},
	ret = "string;nil",
	events = "PLAYER_UPDATE_RESTING",
	doc = L["Display the resting icon if the player is resting"],
	example = '[RestingIcon] => "|TInterface\\CharacterFrame\\UI-StateIcon:32:32:0:0:64:64:0:32:0:32|t"; [RestingIcon] => ""',
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsResting", {
	code = IsResting,
	ret = "boolean",
	events = "PLAYER_UPDATE_RESTING",
	doc = L["Return True if you are in an inn or capital city"],
	example = ('[IsResting] => %q; [IsResting] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsLeader", {
	code = UnitIsPartyLeader,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is a party leader"],
	example = ('[IsLeader] => %q; [IsLeader] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsFeignedDeath", {
	code = UnitIsFeignDeath,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is feigning death"],
	example = ('[IsFeignedDeath] => "%q"; [IsFeignedDeath] => ""'):format(L["True"]),
	category = L["Status"]
})

-- Parnic: pet happiness removed in 4.1
if not wow_401 then
DogTag:AddTag("Unit", "HappyNum", {
	code = function()
		return GetPetHappiness() or 0
	end,
	ret = "number",
	events = petHappinessEvent,
	doc = L["Return the happiness number of your pet"],
	example = '[HappyNum] => "3"',
	category = L["Status"]
})

DogTag:AddTag("Unit", "HappyText", {
	code = function()
		return _G["PET_HAPPINESS" .. (GetPetHappiness() or 0)]
	end,
	ret = "number",
	events = petHappinessEvent,
	doc = L["Return a description of how happy your pet is"],
	example = ('[HappyText] => %q'):format(_G.PET_HAPPINESS3),
	category = L["Status"]
})

DogTag:AddTag("Unit", "HappyIcon", {
	code = function(happy, content, unhappy)
		local num = GetPetHappiness()
		if num == 3 then
			return happy
		elseif num == 2 then
			return content
		elseif num == 1 then
			return unhappy
		end
	end,
	arg = {
		'happy', 'string', ':D',
		'content', 'string', ':I',
		'unhappy', 'string', 'B(',
	},
	ret = "string;nil",
	events = petHappinessEvent,
	doc = L["Return an icon representative of how happy your pet is"],
	example = ('[HappyIcon] => ":D"; [HappyIcon] => ":I"; [HappyIcon] => "B("'),
	category = L["Status"]
})
end

DogTag:AddTag("Unit", "RaidIcon", {
	code = function(size, unit)
		local index =  GetRaidTargetIndex(unit)
		if index then
			return "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. index .. ":" .. size .. "|t"
		else
			return nil
		end
	end,
	arg = {
		'size', 'number', 0,
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "RAID_TARGET_UPDATE",
	doc = L["Display the raid icon associated with the unit"],
	example = '[RaidIcon] => "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:0|t"; [RaidIcon] => ""',
	category = L["Status"]
})

if wow_700 or wow_classic then
	DogTag:AddTag("Unit", "IsNotTappableByMe", {
		code = UnitIsTapDenied,
		arg = {
			'unit', 'string;undef', 'player'
		},
		ret = "boolean",
		events = "Update",
		doc = L["Return True if unit is tapped by someone else and cannot be tapped by you"],
		example = '[IsNotTappableByMe] => "True"; [IsNotTappableByMe] => ""',
		category = L["Status"]
	})
else
	DogTag:AddTag("Unit", "IsTappedByMe", {
		code = UnitIsTappedByPlayer,
		arg = {
			'unit', 'string;undef', 'player'
		},
		ret = "boolean",
		events = "Update",
		doc = L["Return True if unit is tapped by you"],
		example = '[IsTappedByMe] => "True"; [IsTappedByMe] => ""',
		category = L["Status"]
	})

	DogTag:AddTag("Unit", "IsTapped", {
		code = function(unit)
			return UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)
		end,
		arg = {
			'unit', 'string;undef', 'player'
		},
		ret = "boolean",
		events = "Update",
		doc = L["Return True if unit is tapped, but not by you"],
		example = ('[IsTapped] => %q; [IsTapped] => ""'):format(L["True"]),
		category = L["Status"]
	})
end

DogTag:AddTag("Unit", "InCombat", {
	code = UnitAffectingCombat,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "Update",
	doc = L["Return True if unit is in combat"],
	example = ('[InCombat] => %q; [InCombat] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "FKey", {
	code = function(unit)
		local fkey
		if UnitIsUnit(unit, "player") then
			return GetBindingText(GetBindingKey("TARGETSELF"), "KEY_", true)
		elseif UnitIsUnit(unit, "pet") then
			return GetBindingText(GetBindingKey("TARGETPET"), "KEY_", true)
		else
			for i = 1, 4 do
				if UnitIsUnit(unit, "party" .. i) then
					return GetBindingText(GetBindingKey("TARGETPARTYMEMBER" .. i), "KEY_", true)
				elseif UnitIsUnit(unit, "partypet" .. i) then
					return GetBindingText(GetBindingKey("TARGETPARTYPET" .. i), "KEY_", true)
				end
			end
		end
		return nil
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return the function key to press to select unit"],
	example = '[FKey] => "F5"',
	category = L["Status"]
})

local raidGroups = {}
DogTag:AddEventHandler("Unit", partyChangedEvent, function()
	for k in pairs(raidGroups) do
		raidGroups[k] = nil
	end
end)

DogTag:AddTag("Unit", "RaidGroup", {
	code = function(unit)
		if not next(raidGroups) then
			for i = 1, GetNumRaidMembers() do
				local name, rank, subgroup = GetRaidRosterInfo(i)
				if name then
					raidGroups[name] = subgroup
				end
			end
		end
		local n, s = UnitName(unit)
		if s and s ~= "" then
			n = n .. "-" .. s
		end
		return raidGroups[n]
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	doc = L["Return the raid group that unit is in"],
	example = '[RaidGroup] => "3"',
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsMasterLooter", {
	code = function(unit)
		local n, s = UnitName(unit)
		if s and s ~= "" then
			n = n .. "-" .. s
		end
		for i = 1, GetNumRaidMembers() do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
			if name == n then
				return isML and true or false
			end
		end
		return false
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is the master looter for your raid"],
	example = ('[IsMasterLooter] => %q; [IsMasterLooter] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsMainTank", {
	code = function(unit)
		if not UnitInRaid(unit) then
			return false
		end
		local n, s = UnitName(unit)
		if s and s ~= "" then
			n = n .. "-" .. s
		end

		local maintanktable
		if oRA then
			maintanktable = oRA.maintanktable
		else
			maintanktable = CT_RA_MainTanks
		end
		if maintanktable then
			for i = 1, 10 do
				if maintanktable[i] == n then
					return true
				end
			--	i = i + 1 -- what the fuck is this shit?
			end
		else
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, _, _, _, _, role = GetRaidRosterInfo(i)
				if name == n then
				 	return role == 'MAINTANK'
				end
			end
		end
		return false
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is a main tank for your raid"],
	example = ('[IsMainTank] => %q; [IsMainTank] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsMainAssist", {
	code = function(unit)
		if not UnitInRaid(unit) then
			return false
		end
		local n, s = UnitName(unit)
		if s and s ~= "" then
			n = n .. "-" .. s
		end
		for i = 1, GetNumRaidMembers() do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i)
			if name == n then
			 	return role == 'MAINASSIST'
			end
		end
		return false
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is a main assist for your raid"],
	example = ('[IsMainAssist] => %q; [IsMainAssist] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "MasterLooterIcon", {
	alias = [=[IsMasterLooter(unit=unit)?Icon("Interface\GROUPFRAME\UI-Group-MasterLooter", size=size)]=],
	arg = {
		'size', 'number', 0,
		'unit', 'string;undef', 'player'
	},
	doc = L["Display a master looter icon if the unit is the master looter."],
	example = '[MasterLooterIcon] => "|TInterface\\GROUPFRAME\\UI-Group-MasterLooter:0|t"; [MasterLooterIcon] => ""',
	category = L["Status"]
})

DogTag:AddTag("Unit", "MainTankIcon", {
	alias = [=[IsMainTank(unit=unit)?Icon("Interface\GROUPFRAME\UI-GROUP-MAINTANKICON", size=size)]=],
	arg = {
		'size', 'number', 0,
		'unit', 'string;undef', 'player'
	},
	doc = L["Display a main tank icon if the unit is a main tank."],
	example = '[MainTankIcon] => "|TInterface\\GROUPFRAME\\UI-GROUP-MAINTANKICON:0|t"; [MainTankIcon] => ""',
	category = L["Status"]
})

DogTag:AddTag("Unit", "MainAssistIcon", {
	alias = [=[IsMainAssist(unit=unit)?Icon("Interface\GROUPFRAME\UI-GROUP-MAINASSISTICON", size=size)]=],
	arg = {
		'size', 'number', 0,
		'unit', 'string;undef', 'player'
	},
	doc = L["Display a main assist icon if the unit is a main assist."],
	example = '[MainAssistIcon] => "|TInterface\\GROUPFRAME\\UI-GROUP-MAINASSISTICON:0|t"; [MainAssistIcon] => ""',
	category = L["Status"]
})


DogTag:AddTag("Unit", "Target", {
	code = function(unit)
		if unit == "player" then
			return "target"
		else
			return unit .. "target"
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string",
	doc = L["Return the unit id of unit's target"],
	example = '[Target] => "party1target"; [HP(unit=Target)] => "1000"',
	category = L["Status"]
})

DogTag:AddTag("Unit", "Pet", {
	code = function(unit)
		if unit == "player" then
			return "pet"
		elseif unit:match("^party%d$") then
			return "partypet" .. unit:match("(%d+)")
		elseif unit:match("^raid%d$") then
			return "raidpet" .. unit:match("(%d+)")
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return the unit id of unit's pet"],
	example = '[Pet] => "partypet1"; [HP(unit=Pet)] => "500"',
	category = L["Status"]
})

DogTag:AddTag("Unit", "NumTargeting", {
	code = function(unit)
		local num = 0
		for u in iterateGroupMembers() do
			if UnitIsUnit(u .. "target", unit) then
				num = num + 1
			end
		end
		return num
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "UNIT_TARGET;Update",
	doc = L["Return the number of group members currently targeting unit"],
	example = '[NumTargeting] => "2"',
	category = L["Status"]
})

local t = {}
DogTag:AddTag("Unit", "TargetingList", {
	code = function(unit)
		for u in iterateGroupMembers() do
			if UnitIsUnit(u .. "target", unit) then
				local name = GetNameServer(u)
				t[#t+1] = name
			end
		end
		table.sort(t)
		local s = table.concat(t, ", ")
		for k in pairs(t) do
			t[k] = nil
		end
		return s
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "UNIT_TARGET;Update",
	doc = L["Return an alphabetized, comma-separated list of group members currently targeting unit"],
	example = '[TargetingList] => "Grommash, Thrall"',
	category = L["Status"]
})

DogTag:AddTag("Unit", "InGroup", {
	code = function()
		return GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0
	end,
	ret = "boolean",
	doc = L["Return True if you are in a party or raid"],
	example = ('[InGroup] => %q; [InGroup] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsUnit", {
	code = UnitIsUnit,
	arg = {
		'other', 'string', '@req',
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	doc = L["Return True if unit is the same as argument"],
	example = ('[IsUnit("target")] => %q; [IsUnit("party1")] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsCharmed", {
	code = UnitIsCharmed,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "UNIT_FACTION#$unit",
	doc = L["Return True if unit is under mind control"],
	example = ('[IsCharmed] => %q; [IsCharmed] => ""'):format(L["True"]),
	category = L["Status"]
})

DogTag:AddTag("Unit", "IsVisible", {
	code = UnitIsVisible,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "UNIT_PORTRAIT_UPDATE",
	doc = L["Return True if unit is in visible range"],
	example = ('[IsVisible] => %q; [IsVisible] => ""'):format(L["True"]),
	category = L["Status"]
})

if UnitHasVehicleUI then
	DogTag:AddTag("Unit", "HasVehicleUI", {
		code = UnitHasVehicleUI,
		arg = {
			'unit', 'string;undef', 'player'
		},
		ret = "boolean",
		events = "UNIT_ENTERED_VEHICLE#$unit;UNIT_EXITED_VEHICLE#$unit",
		doc = L["Return True if unit has a vehicle UI"],
		example = ('[HasVehicleUI] => %q; [HasVehicleUI] => ""'):format(L["True"]),
		category = L["Status"]
	})
end


DogTag:AddTag("Unit", "StatusColor", {
	code = function(value, unit)
		local r, g, b
		if not UnitIsConnected(unit) then
			r, g, b = unpack(DogTag.__colors.disconnected)
		elseif UnitIsDeadOrGhost(unit) then
			r, g, b = unpack(DogTag.__colors.dead)
		end
		if r then
			if value then
				return ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, value)
			else
				return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
			end
		else
			return value
		end
	end,
	arg = {
		'value', 'string;undef', '@undef',
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "DeadDuration#$unit",
	doc = L["Return the color or wrap value with the color associated with unit's current status"],
	example = '["Hello":StatusColor] => "|cff7f7f7fHello|r"; [StatusColor "Hello")] => "|cff7f7f7fHello"',
	category = L["Status"]
})

-- Parnic: pet happiness removed in 4.1
if not wow_401 then
DogTag:AddTag("Unit", "HappyColor", {
	code = function(value)
		local x = GetPetHappiness()
		local r,g,b
		if x == 3 then
			r,g,b = unpack(DogTag.__colors.petHappy)
		elseif x == 2 then
			r,g,b = unpack(DogTag.__colors.petNeutral)
		elseif x == 1 then
			r,g,b = unpack(DogTag.__colors.petAngry)
		end
		if r then
			if value then
				return ("|cff%02x%02x%02x%s|r"):format(r * 255, g * 255, b * 255, value)
			else
				return ("|cff%02x%02x%02x"):format(r * 255, g * 255, b * 255)
			end
		else
			return value
		end
	end,
	arg = {
		'value', 'string;undef', "@undef",
	},
	ret = "nil;string",
	events = petHappinessEvent,
	doc = L["Return the color or wrap value with the color associated with your pet's happiness"],
	example = '["Hello":HappyColor] => "|cff00ff00Hello|r"; [HappyColor "Hello"] => "|cff00ff00Hello"',
	category = L["Status"]
})
end

-- Parnic: DI removed in Cataclysm
if not wow_400 then
local DIVINE_INTERVENTION = GetSpellInfo(19752)
DogTag:AddTag("Unit", "Status", {
	alias = ("Offline(unit=unit) or (HasDivineIntervention(unit=unit) ? %q) or (IsFeignedDeath(unit=unit) ? %q) or [if Dead(unit=unit) then ((HasSoulstone(unit=unit) ? %q) or Dead(unit=unit))]"):format(DIVINE_INTERVENTION, L["Feigned Death"], L["Soulstoned"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return whether unit is offline, has divine intervention, is dead, feigning death, or has a soulstone while dead"],
	example = ('[Status] => "Offline"; [Status] => "Dead"; [Status] => ""'),
	category = L["Status"]
})
else
DogTag:AddTag("Unit", "Status", {
	alias = ("Offline(unit=unit) or (IsFeignedDeath(unit=unit) ? %q) or [if Dead(unit=unit) then ((HasSoulstone(unit=unit) ? %q) or Dead(unit=unit))]"):format(L["Feigned Death"], L["Soulstoned"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return whether unit is offline, is dead, feigning death, or has a soulstone while dead"],
	example = ('[Status] => "Offline"; [Status] => "Dead"; [Status] => ""'),
	category = L["Status"]
})
end

end
