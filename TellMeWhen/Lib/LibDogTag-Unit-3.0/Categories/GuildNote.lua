local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, setmetatable, getmetatable, pairs, GetTime = _G, setmetatable, getmetatable, pairs, GetTime
local IsInGuild, GetNumGuildMembers, GetGuildRosterInfo, IsInGuild, GuildRoster, UnitName = 
	  IsInGuild, GetNumGuildMembers, GetGuildRosterInfo, IsInGuild, GuildRoster, UnitName

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local guildNotes, officerNotes
local function refreshGuildNotes()
	if getmetatable(guildNotes) then
		return
	end
	for k in pairs(guildNotes) do
		guildNotes[k] = nil
	end
	for k in pairs(officerNotes) do
		officerNotes[k] = nil
	end
	if not IsInGuild() then
		return nil
	end
	for i = 1, GetNumGuildMembers(true) do
		local name, _, _, _, _, _, note, officernote = GetGuildRosterInfo(i)
		if note then
			note = note:trim()
			if note == "" then
				note = nil
			end
		end
		if officernote then
			officernote = officernote:trim()
			if officernote == "" then
				officernote = nil
			end
		end
		guildNotes[name] = note
		officerNotes[name] = officernote
	end
end
local x = {__index=function(self, name)
	setmetatable(guildNotes, nil)
	setmetatable(officerNotes, nil)
	refreshGuildNotes()
	return self[name]
end}
guildNotes = setmetatable({},x)
officerNotes = setmetatable({},x)

local nextGuildRosterUpdate = 0
DogTag:AddEventHandler("Unit", "GUILD_ROSTER_UPDATE", function()
	refreshGuildNotes()

	nextGuildRosterUpdate = GetTime() + 20
end)

DogTag:AddEventHandler("Unit", "PLAYER_GUILD_UPDATE", function()
	refreshGuildNotes()
end)

DogTag:AddTimerHandler("Unit", function(num, currentTime)
	if currentTime > nextGuildRosterUpdate then
		if IsInGuild() then
			GuildRoster()
		end
		nextGuildRosterUpdate = currentTime + 20
	end
end)

DogTag:AddTag("Unit", "GuildNote", {
	code = function(unit)
		local name, server = UnitName(unit)
		if name and (not server or server == "") then
			return guildNotes[name]
		end
		return nil
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "GUILD_ROSTER_UPDATE",
	doc = L["Return the guild note of unit, if unit is in your guild"],
	example = ('[GuildNote] => %q'):format("My note"),
	category = L["Characteristics"]
})

DogTag:AddTag("Unit", "OfficerNote", {
	code = function(unit)
		local name, server = UnitName(unit)
		if name and (not server or server == "") then
			return officerNotes[name]
		end
		return nil
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "GUILD_ROSTER_UPDATE",
	doc = L["Return the officer's guild note of unit, if unit is in your guild and you are an officer"],
	example = ('[OfficerNote] => %q'):format("Special note"),
	category = L["Characteristics"]
})

end