local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, pairs, wipe, tonumber, GetTime = _G, pairs, wipe, tonumber, GetTime
local UnitName, UnitGUID, UnitCastingInfo, UnitChannelInfo, CastingInfo, ChannelInfo = 
	  UnitName, UnitGUID, UnitCastingInfo, UnitChannelInfo, CastingInfo, ChannelInfo 

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local newList = DogTag.newList
local del = DogTag.del
local castData = {}
local UnitGUID = UnitGUID
local IsNormalUnit = DogTag.IsNormalUnit

local wow_ver = select(4, GetBuildInfo())
local wow_classic = WOW_PROJECT_ID and WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
local wow_800 = wow_ver >= 80000

local playerGuid = nil
DogTag:AddEventHandler("Unit", "PLAYER_LOGIN", function()
	playerGuid = UnitGUID("player")
end)

local nextSpell, nextRank, nextTarget
local function updateInfo(event, unit)
	local guid = UnitGUID(unit)
	if not guid then
		return
	end
	local data = castData[guid]
	if not data then
		data = newList()
		castData[guid] = data
	end
	
	local spell, rank, displayName, icon, startTime, endTime
	local channeling = false
	if wow_800 then
		spell, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
		rank = nil
		if not spell then
			spell, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
			channeling = true
		end
	elseif wow_classic then
		-- Classic only has an API for player spellcasts. No API for arbitrary units.
		if unit == "player" then
			spell, displayName, icon, startTime, endTime = CastingInfo()
			rank = nil
			if not spell then
				spell, displayName, icon, startTime, endTime = ChannelInfo()
				channeling = true
			end
		end
	else
		spell, rank, displayName, icon, startTime, endTime = UnitCastingInfo(unit)
		if not spell then
			spell, rank, displayName, icon, startTime, endTime = UnitChannelInfo(unit)
			channeling = true
		end
	end

	if spell then
		data.spell = spell
		rank = rank and tonumber(rank:match("%d+"))
		data.rank = rank
		local oldStart = data.startTime
		startTime = startTime * 0.001
		data.startTime = startTime
		data.endTime = endTime * 0.001
		if event == "UNIT_SPELLCAST_DELAYED" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
			data.delay = (data.delay or 0) + (startTime - (oldStart or startTime))
		else
			data.delay = 0
		end
		if guid == playerGuid and spell == nextSpell and rank == nextRank then
			data.target = nextTarget
		end
		data.casting = not channeling
		data.channeling = channeling
		data.fadeOut = false
		data.stopTime = nil
		data.stopMessage = nil
		DogTag:FireEvent("Cast", unit)
		return
	end
	
	if not data.spell then
		castData[guid] = del(data)
		DogTag:FireEvent("Cast", unit)
		return
	end
	
	if event == "UNIT_SPELLCAST_FAILED" then
		data.stopMessage = _G.FAILED
	elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
		data.stopMessage = _G.INTERRUPTED
	end
	
	data.casting = false
	data.channeling = false
	data.fadeOut = true
	if not data.stopTime then
		data.stopTime = GetTime()
	end
	DogTag:FireEvent("Cast", unit)
end

local guidsToFire, unitsToUpdate = {}, {}
local function fixCastData()
	local frame
	local currentTime = GetTime()
	for guid, data in pairs(castData) do
		if data.casting then
			if currentTime > data.endTime and playerGuid ~= guid then
				data.casting = false
				data.fadeOut = true
				data.stopTime = currentTime
			end
		elseif data.channeling then
			if currentTime > data.endTime then
				data.channeling = false
				data.fadeOut = true
				data.stopTime = currentTime
			end
		elseif data.fadeOut then
			local alpha = 0
			local stopTime = data.stopTime
			if stopTime then
				alpha = stopTime - currentTime + 1
			end
		
			if alpha <= 0 then
				castData[guid] = del(data)
			end
		else
			castData[guid] = del(data)
		end
		local found = false
		local normal = false
		for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
			found = unit
			if IsNormalUnit[unit] then
				normal = true
				break
			end
		end
		if not found then
			if castData[guid] then
				castData[guid] = del(data)
			end
		else
			if not normal then
				unitsToUpdate[found] = true
			end
			
			guidsToFire[guid] = true
		end
	end
	for unit in pairs(unitsToUpdate) do
		updateInfo(nil, unit)
	end
	wipe(unitsToUpdate)
	for guid in pairs(guidsToFire) do
		for unit in DogTag_Unit.IterateUnitsWithGUID(guid) do
			DogTag:FireEvent("Cast", unit)
		end
	end
	wipe(guidsToFire)
end
DogTag:AddTimerHandler("Unit", fixCastData)

DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_START", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_CHANNEL_START", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_STOP", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_FAILED", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_INTERRUPTED", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_DELAYED", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_CHANNEL_UPDATE", updateInfo)
DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_CHANNEL_STOP", updateInfo)
DogTag:AddEventHandler("Unit", "UnitChanged", updateInfo)

DogTag:AddEventHandler("Unit", "UNIT_SPELLCAST_SENT", function(event, unit, spell, rank, target)
	
	-- The purpose of this event is to predict the next spell target.
	-- This seems to be removed in at least wow_800
	if unit == "player" and not wow_800 then
		nextSpell = spell
		nextRank = rank and tonumber(rank:match("%d+"))
		nextTarget = target ~= "" and target or nil
	end
end)

local blank = {}
local function getCastData(unit)
	return castData[UnitGUID(unit)] or blank
end

DogTag:AddTag("Unit", "CastName", {
	code = function(unit)
		return getCastData(unit).spell
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Cast#$unit",
	doc = L["Return the current or last spell to be cast"],
	example = ('[CastName] => %q'):format(L["Holy Light"]),
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastTarget", {
	code = function(unit)
		return getCastData(unit).target
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Cast#$unit",
	doc = L["Return the current cast target name"],
	example = ('[CastTarget] => %q'):format((UnitName("player"))),
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastRank", {
	code = function(unit)
		return getCastData(unit).rank
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "Cast#$unit",
	doc = L["Return the current cast rank"],
	example = '[CastRank] => "4"; [CastRank:Romanize] => "IV"',
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastStartDuration", {
	code = function(unit)
		local t = getCastData(unit).startTime
		if t then
			return GetTime() - t
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "Cast#$unit",
	doc = L["Return the duration since the current cast started"],
	example = '[CastStartDuration] => "3.012367"; [CastStartDuration:FormatDuration] => "0:03"',
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastEndDuration", {
	code = function(unit)
		local t = getCastData(unit).endTime
		if t then
			return t - GetTime()
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "Cast#$unit",
	globals = "DogTag.__castData",
	doc = L["Return the duration until the current cast is meant to finish"],
	example = '[CastEndDuration] => "2.07151"; [CastEndDuration:FormatDuration] => "0:02"',
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastDelay", {
	code = function(unit)
		return getCastData(unit).delay
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "Cast#$unit",
	doc = L["Return the number of seconds the current cast has been delayed by interruption"],
	example = '[CastDelay] => "1.49997"; [CastDelay:Round(1)] => "1.5"',
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastIsChanneling", {
	code = function(unit)
		return getCastData(unit).channeling
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "Cast#$unit",
	doc = L["Return True if the current cast is a channeling spell"],
	example = ('[CastIsChanneling] => %q; [CastIsChanneling] => ""'):format(L["True"]),
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastStopDuration", {
	code = function(unit)
		local t = getCastData(unit).stopTime
		if t then
			return GetTime() - t
		else
			return nil
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number;nil",
	events = "Cast#$unit",
	doc = L["Return the duration which the current cast has been stopped, blank if not stopped yet"],
	example = '[CastStopDuration] => "2.06467"; [CastStopDuration:FormatDuration] => "0:02"; [CastStopDuration] => ""',
	category = L["Casting"]
})

DogTag:AddTag("Unit", "CastStopMessage", {
	code = function(unit)
		return getCastData(unit).stopMessage
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "Cast#$unit",
	doc = L["Return the message as to why the cast stopped, if there is an error"],
	example = ('[CastStopMessage] => %q; [CastStopMessage] => %q, [CastStopMessage] => ""'):format(_G.FAILED, _G.INTERRUPTED),
	category = L["Casting"]
})

end
