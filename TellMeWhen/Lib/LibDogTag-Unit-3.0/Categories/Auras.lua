local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local select, pairs, rawget, GetTime, setmetatable = select, pairs, rawget, GetTime, setmetatable
local GetSpellInfo, UnitAura, UnitIsFriend, UnitClass, UnitPowerType = 
	  GetSpellInfo, UnitAura, UnitIsFriend, UnitClass, UnitPowerType

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L

local newList = DogTag.newList

local hasEvent = DogTag.hasEvent

local IsNormalUnit = DogTag.IsNormalUnit
local newList, del = DogTag.newList, DogTag.del

local currentAuras, currentDebuffTypes, currentAuraTimes, currentNumDebuffs

-- Parnic: support for cataclysm; Divine Intervention was removed
local wow_400 = select(4, GetBuildInfo()) >= 40000
local wow_700 = select(4, GetBuildInfo()) >= 70000
local wow_800 = select(4, GetBuildInfo()) >= 80000

local mt = {__index=function(self, unit)
	local auras = newList()
	local debuffTypes = newList()
	local auraTimes = newList()
	local i = 0
	while true do
		i = i + 1
		local name, count, duration, expirationTime, _
		if wow_800 then
			name, _, count, _, duration, expirationTime = UnitAura(unit, i, "HELPFUL")
		else
			name, _, _, count, _, duration, expirationTime = UnitAura(unit, i, "HELPFUL")
		end
		if not name then
			break
		end
		if count == 0 then
			count = 1
		end
		auras[name] = (auras[name] or 0) + count
		
		if expirationTime and expirationTime > 0 and (not auraTimes[name] or auraTimes[name] > expirationTime) then
			auraTimes[name] = expirationTime
		end
	end
	local numDebuffs = 0
	local isFriend = UnitIsFriend("player", unit)
	local i = 0
	while true do
		i = i + 1
		local name, count, dispelType, expirationTime, _
		if wow_800 then
			name, _, count, dispelType, _, expirationTime = UnitAura(unit, i, "HARMFUL")
		else
			name, _, _, count, dispelType, _, expirationTime = UnitAura(unit, i, "HARMFUL")
		end
		if not name then
			break
		end
		if count == 0 then
			count = 1
		end
		numDebuffs = numDebuffs + 1
		auras[name] = (auras[name] or 0) + count
		if isFriend and dispelType then
			debuffTypes[dispelType] = true
		end

		if expirationTime and expirationTime > 0 and (not auraTimes[name] or auraTimes[name] > expirationTime) then
			auraTimes[name] = expirationTime
		end
	end
	currentAuras[unit] = auras
	currentDebuffTypes[unit] = debuffTypes
	currentAuraTimes[unit] = auraTimes
	currentNumDebuffs[unit] = numDebuffs
	return self[unit]
end}
currentAuras = setmetatable({}, mt)
currentDebuffTypes = setmetatable({}, mt)
currentAuraTimes = setmetatable({}, mt)
currentNumDebuffs = setmetatable({}, mt)
mt = nil

local auraQueue = {}

local nextAuraUpdate = 0
local nextWackyAuraUpdate = 0
DogTag:AddTimerHandler("Unit", function(num, currentTime)
	if currentTime >= nextAuraUpdate and hasEvent('Aura') then
		nextAuraUpdate = currentTime + 0.5
		if currentTime >= nextWackyAuraUpdate then
			nextWackyAuraUpdate = currentTime + 2
			for unit, v in pairs(currentAuras) do
				if not IsNormalUnit[unit] then
					currentAuras[unit] = del(v)
					currentDebuffTypes[unit] = del(currentDebuffTypes[unit])
					currentAuraTimes[unit] = del(currentAuraTimes[unit])
					currentNumDebuffs[unit] = nil
				end
			end
		end
		for unit in pairs(auraQueue) do
			auraQueue[unit] = nil
			local t = newList()
			local u = newList()
			local v = newList()
			for i = 1, 40 do
				local name, count, expirationTime, _
				if wow_800 then
					name, _, count, _, _, expirationTime = UnitAura(unit, i, "HELPFUL")
				else
					name, _, _, count, _, _, expirationTime = UnitAura(unit, i, "HELPFUL")
				end
				if not name then
					break
				end
				if count == 0 then
					count = 1
				end
				t[name] = (t[name] or 0) + count
				if expirationTime and expirationTime > 0 and (not v[name] or v[name] > expirationTime) then
					v[name] = expirationTime
				end
			end
			local numDebuffs = 0
			local isFriend = UnitIsFriend("player", unit)
			for i = 1, 40 do
				local name, count, dispelType, expirationTime, _
				if wow_800 then
					name, _, count, dispelType, _, expirationTime = UnitAura(unit, i, "HARMFUL")
				else
					name, _, _, count, dispelType, _, expirationTime = UnitAura(unit, i, "HARMFUL")
				end
				if not name then
					break
				end
				if count == 0 then
					count = 1
				end
				numDebuffs = numDebuffs + 1
				t[name] = (t[name] or 0) + count
				if isFriend and dispelType then
					u[dispelType] = true
				end
				if expirationTime and expirationTime > 0 and (not v[name] or v[name] > expirationTime) then
					v[name] = expirationTime
				end
			end
			local old = rawget(currentAuras, unit) or newList()
			local oldType = rawget(currentDebuffTypes, unit) or newList()
			local oldTimes = rawget(currentAuraTimes, unit) or newList()
			local changed = false
			for k, num in pairs(t) do
				if not old[k] then
					changed = true
					break
				end
				if num ~= old[k] then
					changed = true
					break
				end
				old[k] = nil
			end
			if not changed then
				for k in pairs(old) do
					changed = true
					break
				end
			end
			currentAuras[unit] = t
			currentDebuffTypes[unit] = u
			currentAuraTimes[unit] = v
			local oldNumDebuffs = rawget(currentNumDebuffs, unit)
			currentNumDebuffs[unit] = numDebuffs
			old = del(old)
			oldType = del(oldType)
			oldTimes = del(oldTimes)
			if changed or oldNumDebuffs ~= numDebuffs then
				DogTag:FireEvent("Aura", unit)
			end
		end
	end
end)


DogTag:AddEventHandler("Unit", "UnitChanged", function(event, unit)
	if rawget(currentAuras, unit) then
		currentAuras[unit] = del(currentAuras[unit])
		currentDebuffTypes[unit] = del(currentDebuffTypes[unit])
		currentAuraTimes[unit] = del(currentAuraTimes[unit])
		currentNumDebuffs[unit] = nil
		auraQueue[unit] = true
	end
end)

DogTag:AddEventHandler("Unit", "UNIT_AURA", function(event, unit)
	auraQueue[unit] = true
end)

DogTag:AddTag("Unit", "HasAura", {
	code = function(aura, unit)
		return currentAuras[unit][aura]
	end,
	arg = {
		'aura', 'string', '@req',
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "Aura#$unit",
	doc = L["Return True if unit has the aura argument"],
	example = ('[HasAura("Shadowform")] => %q; [HasAura("Shadowform")] => ""'):format(L["True"]),
	category = L["Auras"]
})

DogTag:AddTag("Unit", "NumAura", {
	code = function(aura, unit)
		return currentAuras[unit][aura] or 0
	end,
	arg = {
		'aura', 'string', '@req',
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "Aura#$unit",
	doc = L["Return the number of auras on the unit"],
	example = '[NumAura("Renew")] => "2"; [NumAura("Renew")] => "0"',
	category = L["Auras"]
})

DogTag:AddTag("Unit", "RaidStacks", {
	code = function(aura)
		local prefix = "raid"
		local numPlayers = GetNumGroupMembers()
    
		local numAuras = 0
		
		if wow_800 then
			-- All this could probably be much more efficient.
			-- Blizzard removed aura lookups by name in BFA

			aura = aura:lower()
			if not IsInRaid() then
				prefix = "party"
				numPlayers = numPlayers-1
			
				for i = 1, 40 do
					local name, _, _, _, _, expirationTime, _, _, _, _ = UnitAura("player", i, "PLAYER|HELPFUL")
					if name and name:lower() == aura and expirationTime ~= nil then
						numAuras = numAuras + 1
					end
				end
			end
		
			for i=1,numPlayers do
				local unit = prefix..i
				for i = 1, 40 do
					local name, _, _, _, _, expirationTime, _, _, _, _ = UnitAura(unit, i, "PLAYER|HELPFUL")
					if name and name:lower() == aura and expirationTime ~= nil then
						numAuras = numAuras + 1
					end
				end
			end
		else
			if not IsInRaid() then
				prefix = "party"
				numPlayers = numPlayers-1
			
				local _, _, _, _, _, _, expirationTime, _, _, _, _ = UnitAura("player", aura, nil, "PLAYER|HELPFUL")
				if expirationTime ~= nil then
					numAuras = numAuras + 1
				end
			end
		
			for i=1,numPlayers do
				local unit = prefix..i
				local _, _, _, _, _, _, expirationTime, _, _, _, _ = UnitAura(unit, aura, nil, "PLAYER|HELPFUL")
				if expirationTime ~= nil then
					numAuras = numAuras + 1
				end
			end
		end
		
		return numAuras
	end,
	arg = {
		'aura', "string", '@req'
	},
	ret = "number",
	events = "Update",
	doc = L["Return the total number of units in raid/party that have the specified aura"],
	example = '[RaidStacks("Renewing Mist")] => "5"',
	category = L["Auras"]
})

local MOONKIN_FORM = GetSpellInfo(24858)
local AQUATIC_FORM = GetSpellInfo(1066)
local FLIGHT_FORM = GetSpellInfo(33943)
local SWIFT_FLIGHT_FORM = GetSpellInfo(40120)
local TRAVEL_FORM = GetSpellInfo(783)
local TREE_OF_LIFE = GetSpellInfo(33891)

local function DruidForm(unit)
		local _, c = UnitClass(unit)
		if c ~= "DRUID" then
			return nil
		end
		local power = UnitPowerType(unit)
		if power == 1 then
			return L["Bear"]
		elseif power == 3 then
			return L["Cat"]
		end
		local auras = currentAuras[unit]
		if auras[MOONKIN_FORM] then
			return L["Moonkin"]
		elseif auras[AQUATIC_FORM] then
			return L["Aquatic"]
		elseif auras[FLIGHT_FORM] or auras[SWIFT_FLIGHT_FORM] then
			return L["Flight"]
		elseif auras[TRAVEL_FORM] then
			return L["Travel"]
		elseif auras[TREE_OF_LIFE] and auras[TREE_OF_LIFE] >= 2 then
			return L["Tree"]
		end
		return nil
end

DogTag:AddTag("Unit", "DruidForm", {
	code = DruidForm,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	events = "UNIT_DISPLAYPOWER#$unit;Aura#$unit",
	doc = L["Return the shapeshift form the unit is in if unit is a druid"],
	example = ('[DruidForm] => %q; [DruidForm] => %q; [DruidForm] => ""'):format(L["Bear"], L["Cat"]),
	category = L["Auras"]
})

local ShortDruidForm_abbrev = {
	[L["Bear"]] = L["Bear_short"],
	[L["Cat"]] = L["Cat_short"],
	[L["Moonkin"]] = L["Moonkin_short"],
	[L["Aquatic"]] = L["Aquatic_short"],
	[L["Flight"]] = L["Flight_short"],
	[L["Travel"]] = L["Travel_short"],
	[L["Tree"]] = L["Tree_short"],
}

DogTag:AddTag("Unit", "ShortDruidForm", {
	code = function(value, unit)
		return ShortDruidForm_abbrev[value or DruidForm(unit)]
	end,
	arg = {
		'value', 'string;undef', '@undef',
		'unit', 'string;undef', 'player'
	},
	ret = "string;nil",
	doc = L["Return a shortened druid form of unit, or shorten a druid form"],
	example = ('[ShortDruidForm] => %q; [%q:ShortDruidForm] => %q; ["Hello":ShortDruidForm] => ""'):format(L["Bear_short"], L["Bear"], L["Bear_short"]),
	category = L["Abbreviations"]
})

DogTag:AddTag("Unit", "NumDebuffs", {
	code = function(unit)
		return currentNumDebuffs[unit]
	end,
	arg = {
		'unit', 'string;undef', 'player'
	},
	ret = "number",
	events = "Aura#$unit",
	doc = L["Return the total number of debuffs that unit has"],
	example = '[NumDebuffs] => "5"; [NumDebuffs] => "40"',
	category = L["Auras"]
})


DogTag:AddTag("Unit", "AuraDuration", {
	code = function(aura, unit)
		local t = currentAuraTimes[unit][aura]
		if t then
			return t - GetTime()
		end
		return nil
	end,
	arg = {
		'aura', 'string', '@req',
		'unit', 'string;undef', 'player'
	},
	events = "Update;Aura#$unit",
	ret = "number;nil",
	doc = L["Return the duration until the aura for unit is finished"],
	example = '[AuraDuration("Renew")] => "10.135123"',
	category = L["Auras"],
})

local SHADOWFORM = GetSpellInfo(15473)
if not wow_700 then
DogTag:AddTag("Unit", "IsShadowform", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(SHADOWFORM),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the shadowform buff"],
	example = ('[IsShadowform] => %q; [IsShadowform] => ""'):format(L["True"]),
	category = L["Auras"],
})
end

local STEALTH = GetSpellInfo(1784)
local SHADOWMELD = GetSpellInfo(58984) or GetSpellInfo(743) -- 58984 is the ID in BFA, 743 is the ID in Classic.
local PROWL = GetSpellInfo(5215)
DogTag:AddTag("Unit", "IsStealthed", {
	alias = ("HasAura(aura=%q, unit=unit) or HasAura(aura=%q, unit=unit) or HasAura(aura=%q, unit=unit)"):format(STEALTH, SHADOWMELD, PROWL),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit is stealthed in some way"],
	example = ('[IsStealthed] => %q; [IsStealthed] => ""'):format(L["True"]),
	category = L["Auras"]
})

local SHIELD_WALL = GetSpellInfo(871)
DogTag:AddTag("Unit", "HasShieldWall", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(SHIELD_WALL),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the Shield Wall buff"],
	example = ('[HasShieldWall] => %q; [HasShieldWall] => ""'):format(L["True"]),
	category = L["Auras"]
})

local LAST_STAND = GetSpellInfo(12975)
DogTag:AddTag("Unit", "HasLastStand", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(LAST_STAND),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the Last Stand buff"],
	example = ('[HasLastStand] => %q; [HasLastStand] => ""'):format(L["True"]),
	category = L["Auras"]
})

local SOULSTONE_RESURRECTION = GetSpellInfo(20707)
DogTag:AddTag("Unit", "HasSoulstone", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(SOULSTONE_RESURRECTION),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the Soulstone buff"],
	example = ('[HasSoulstone] => %q; [HasSoulstone] => ""'):format(L["True"]),
	category = L["Auras"]
})

local MISDIRECTION = GetSpellInfo(34477)
if MISDIRECTION then -- WoW Classic compat
	DogTag:AddTag("Unit", "HasMisdirection", {
		alias = ("HasAura(aura=%q, unit=unit)"):format(MISDIRECTION),
		arg = {
			'unit', 'string;undef', 'player'
		},
		doc = L["Return True if the unit has the Misdirection buff"],
		example = ('[HasMisdirection] => %q; [HasMisdirection] => ""'):format(L["True"]),
		category = L["Auras"]
	})
end

local ICE_BLOCK = GetSpellInfo(27619)
DogTag:AddTag("Unit", "HasIceBlock", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(ICE_BLOCK),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the Ice Block buff"],
	example = ('[HasIceBlock] => %q; [HasIceBlock] => ""'):format(L["True"]),
	category = L["Auras"]
})

local INVISIBILITY = GetSpellInfo(66)
DogTag:AddTag("Unit", "HasInvisibility", {
	alias = ("HasAura(aura=%q, unit=unit)"):format(INVISIBILITY),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has the Invisibility buff"],
	example = ('[HasInvisibility] => %q; [HasInvisibility] => ""'):format(L["True"]),
	category = L["Auras"]
})

-- Parnic: DI removed in Cataclysm
local DIVINE_INTERVENTION = GetSpellInfo(19752)
if DIVINE_INTERVENTION then
	DogTag:AddTag("Unit", "HasDivineIntervention", {
		alias = ("HasAura(aura=%q, unit=unit)"):format(DIVINE_INTERVENTION),
		arg = {
			'unit', 'string;undef', 'player'
		},
		doc = L["Return True if the unit has the Divine Intervention buff"],
		example = ('[HasDivineIntervention] => %q; [HasDivineIntervention] => ""'):format(L["True"]),
		category = L["Auras"]
	})
end

DogTag:AddTag("Unit", "HasDebuffType", {
	code = function(type, unit)
		return currentDebuffTypes[unit][type]
	end,
	arg = {
		'type', 'string', '@req',
		'unit', 'string;undef', 'player'
	},
	ret = "boolean",
	events = "Aura#$unit",
	doc = L["Return True if friendly unit is has a debuff of type"],
	example = ('[HasDebuffType("Poison")] => %q; [HasDebuffType("Poison")] => ""'):format(L["True"]),
	category = L["Auras"],
})

DogTag:AddTag("Unit", "HasMagicDebuff", {
	alias = ("HasDebuffType(type=%q, unit=unit)"):format(L["Magic"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has a Magic debuff"],
	example = ('[HasMagicDebuff] => %q; [HasMagicDebuff] => ""'):format(L["True"]),
	category = L["Auras"]
})

DogTag:AddTag("Unit", "HasCurseDebuff", {
	alias = ("HasDebuffType(type=%q, unit=unit)"):format(L["Curse"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has a Curse debuff"],
	example = ('[HasCurseDebuff] => %q; [HasCurseDebuff] => ""'):format(L["True"]),
	category = L["Auras"]
})

DogTag:AddTag("Unit", "HasPoisonDebuff", {
	alias = ("HasDebuffType(type=%q, unit=unit)"):format(L["Poison"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has a Poison debuff"],
	example = ('[HasPoisonDebuff] => %q; [HasPoisonDebuff] => ""'):format(L["True"]),
	category = L["Auras"]
})

DogTag:AddTag("Unit", "HasDiseaseDebuff", {
	alias = ("HasDebuffType(type=%q, unit=unit)"):format(L["Disease"]),
	arg = {
		'unit', 'string;undef', 'player'
	},
	doc = L["Return True if the unit has a Disease debuff"],
	example = ('[HasDiseaseDebuff] => %q; [HasDiseaseDebuff] => ""'):format(L["True"]),
	category = L["Auras"]
})

end
