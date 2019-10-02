local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local _G, ipairs, type, GetTime = _G, ipairs, type, GetTime
local UnitName, UnitFactionGroup, UnitPlayerControlled, UnitIsPlayer, UnitIsVisible, UnitIsConnected, UnitPlayerControlled =
	  UnitName, UnitFactionGroup, UnitPlayerControlled, UnitIsPlayer, UnitIsVisible, UnitIsConnected, UnitPlayerControlled
local InCombatLockdown, GetNumFactions, GetFactionInfo, ExpandFactionHeader, CollapseFactionHeader, GetGuildInfo =
	  InCombatLockdown, GetNumFactions, GetFactionInfo, ExpandFactionHeader, CollapseFactionHeader, GetGuildInfo

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local tt = CreateFrame("GameTooltip")
tt:SetOwner(UIParent, "ANCHOR_NONE")
tt.left = {}
tt.right = {}
for i = 1, 30 do
	tt.left[i] = tt:CreateFontString()
	tt.left[i]:SetFontObject(GameFontNormal)
	tt.right[i] = tt:CreateFontString()
	tt.right[i]:SetFontObject(GameFontNormal)
	tt:AddFontStrings(tt.left[i], tt.right[i])
end
local nextTime = 0
local lastName
local lastUnit
local function updateTT(unit)
	local name = UnitName(unit)
	local time = GetTime()
	if lastUnit == unit and lastName == name and nextTime < time then
		return
	end
	lastUnit = unit
	lastName = name
	nextTime = time + 1
	tt:ClearLines()
	tt:SetUnit(unit)
	if not tt:IsOwned(UIParent) then
		tt:SetOwner(UIParent, "ANCHOR_NONE")
	end
end

local LEVEL_start = "^" .. (type(LEVEL) == "string" and LEVEL or "Level")
local function FigureNPCGuild(unit)
	updateTT(unit)
	local left_2 = tt.left[2]:GetText()
	if not left_2 or left_2:find(LEVEL_start) then
		return nil
	end
	return left_2
end

local factionList = {}

local PVP = type(PVP) == "string" and PVP or "PvP"
local function FigureFaction(unit)
	local _, faction = UnitFactionGroup(unit)
	if UnitPlayerControlled(unit) or UnitIsPlayer(unit) then
		return faction
	end

	updateTT(unit)
	local left_2 = tt.left[2]:GetText()
	local left_3 = tt.left[3]:GetText()
	if not left_2 or not left_3 then
		return faction
	end
	local hasGuild = not left_2:find(LEVEL_start)
	local factionText = not hasGuild and left_3 or tt.left[4]:GetText()
	if factionText == PVP then
		return faction
	end
	if factionList[factionText] or faction then
		return factionText
	end
end

local function FigureZone(unit)
	if UnitIsVisible(unit) then
		return nil
	end
	if not UnitIsConnected(unit) then
		return nil
	end
	updateTT(unit)
	local left_2 = tt.left[2]:GetText()
	local left_3 = tt.left[3]:GetText()
	if not left_2 or not left_3 then
		return nil
	end
	local hasGuild = not left_2:find(LEVEL_start)
	local factionText = not hasGuild and left_3 or tt.left[4]:GetText()
	if factionText == PVP then
		factionText = nil
	end
	local hasFaction = factionText and not UnitPlayerControlled(unit) and not UnitIsPlayer(unit) and (UnitFactionGroup(unit) or factionList[factionText])
	if hasGuild and hasFaction then
		return tt.left[5]:GetText()
	elseif hasGuild or hasFaction then
		return tt.left[4]:GetText()
	else
		return left_3
	end
end

local should_UPDATE_FACTION = false
local in_UNIT_FACTION = false
local function UPDATE_FACTION()
	if in_UNIT_FACTION then return end
	in_UNIT_FACTION = true
	if InCombatLockdown() then
		should_UPDATE_FACTION = true
		return
	end
	
	for name in DogTag.IterateFactions() do
		factionList[name] = true
	end
	
	in_UNIT_FACTION = false
end
DogTag:AddEventHandler("Unit", "UPDATE_FACTION", UPDATE_FACTION)
DogTag:AddEventHandler("Unit", "PLAYER_LOGIN", UPDATE_FACTION)
DogTag:AddEventHandler("Unit", "PLAYER_REGEN_ENABLED", function()
	if should_UPDATE_FACTION then
		should_UPDATE_FACTION = false
		UPDATE_FACTION()
	end
end)

DogTag:AddTag("Unit", "Guild", {
	code = function(unit)
		if UnitIsPlayer(unit) then
			return GetGuildInfo(unit)
		else
			return FigureNPCGuild(unit)
		end
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return the guild name or title of unit"],
	example = ('[Guild] => %q; [Guild] => %q; [Guild] => %q'):format(L["My Little Pwnies"], L["Banker"], _G.UNITNAME_TITLE_PET:format("Grommash")),
	category = L["Characteristics"]
})

local checks = {
	_G.UNITNAME_TITLE_CHARM:gsub("%%s", "(.+)"),
	_G.UNITNAME_TITLE_COMPANION:gsub("%%s", "(.+)"),
	_G.UNITNAME_TITLE_CREATION:gsub("%%s", "(.+)"),
	_G.UNITNAME_TITLE_GUARDIAN:gsub("%%s", "(.+)"),
	_G.UNITNAME_TITLE_MINION:gsub("%%s", "(.+)"),
	_G.UNITNAME_TITLE_PET:gsub("%%s", "(.+)")
}

DogTag:AddTag("Unit", "Owner", {
	code = function(unit)
		if not UnitIsPlayer(unit) then
			local guild = FigureNPCGuild(unit)
			if guild then
				for i, v in ipairs(checks) do
					local owner = guild:match(v)
					if owner then
						return owner
					end
				end
			end
		end
		return nil
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return the name of the owner of unit, if a pet"],
	example = ('[Owner] => %q'):format(L["Grommash"]),
	category = L["Characteristics"]
})

DogTag:AddTag("Unit", "Faction", {
	code = FigureFaction,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "UNIT_FACTION",
	doc = L["Return the faction of unit"],
	example = ('[Faction] => %q; [Faction] => %q'):format(L["Alliance"], L["Aldor"]),
	category = L["Characteristics"]
})

DogTag:AddTag("Unit", "Zone", {
	code = FigureZone,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "SlowUpdate",
	doc = L["Return the zone of unit. Note: only works when unit is out of your sight."],
	example = ('[Zone] => %q'):format(L["Shattrath"]),
	category = L["Status"]
})

end
