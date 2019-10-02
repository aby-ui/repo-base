 -- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local type, pairs, gsub, strfind, strmatch, strsplit, strtrim, tonumber, tremove, ipairs, tinsert, CopyTable, setmetatable =
	  type, pairs, gsub, strfind, strmatch, strsplit, strtrim, tonumber, tremove, ipairs, tinsert, CopyTable, setmetatable
local tconcat = table.concat
local GetSpellInfo = 
	  GetSpellInfo

local strlowerCache = TMW.strlowerCache

local _, pclass = UnitClass("player")





---------------------------------
-- Spell String Parsing Functions
---------------------------------

-- These functions are as old as TMW itself (except for duration stuff). They have changed much over the years,
-- but they're one of the few things that are still here in some form.


local function splitSpellAndDuration(str)
	-- A space is optionally allowed before the semicolon 
	-- to support French, which likes spaces around semicolons.
	local spell, duration = strmatch(str, "(.-)%s?:([%d:%s%.]*)$")
	if not spell then
		return str, 0
	end
	if not duration then
		duration = 0
	else
		duration = tonumber( TMW.toSeconds(duration:trim(" :;.")) )
	end

	return spell:trim(" "), duration
end

local function parseSpellsString(setting, doLower, keepDurations)

	local buffNames = TMW:SplitNames(setting) -- Get a table of everything
	
	if doLower then
		buffNames = TMW:LowerNames(buffNames)
	end

	--INSERT EQUIVALENCIES
	--start at the end of the table, that way we dont have to worry
	--about increasing the key of buffNames to work with every time we insert something
	local k = #buffNames
	while k > 0 do
		local eqtt = TMW:EquivToTable(buffNames[k]) -- Get the table form of the equivalency string
		if eqtt then
			local n = k	--point to start inserting the values at
			tremove(buffNames, k)	--take the actual equavalancey itself out, because it isnt an actual spell name or anything
			for z, x in ipairs(eqtt) do
				tinsert(buffNames, n, x)	--put the names into the main table
				n = n + 1	--increment the point of insertion
			end
		else
			k = k - 1	--there is no equivalency to insert, so move backwards one key towards zero to the next key
		end
	end

	-- REMOVE DUPLICATES
	TMW.tRemoveDuplicates(buffNames)


	-- Remove entries that the user has chosed to omit by using a "-" prefix.
	local k = #buffNames
	while k > 0 do
		local v = buffNames[k]
		if (type(v) == "string" and v:match("^%-")) or (type(v) == "number" and v < 0) then

			tremove(buffNames, k)

			local thingToRemove = tostring(v):match("^%-%s*(.*)"):lower()
			local spellToRemove, durationToRemove = splitSpellAndDuration(thingToRemove)

			local i = 1
			local removed
			while buffNames[i] do
				local name = tostring(buffNames[i]):lower()
				local spell, duration = splitSpellAndDuration(name)
				
				if spellToRemove == spell and durationToRemove == duration then
					tremove(buffNames, i)
					removed = true
				else
					i = i + 1
				end
			end

			if not removed then
				TMW:Printf(L["SPELL_EQUIV_REMOVE_FAILED"], thingToRemove, tconcat(buffNames, "; "))
			end
		else
			-- The entry was valid, so move backwards towards the beginning.
			k = k - 1
		end
	end

	-- Remove invalid SpellIDs
	for k = #buffNames, 1, -1 do
		local v = buffNames[k]
		local spell, duration = splitSpellAndDuration(v)
		if (tonumber(spell) or 0) >= 2^31 or duration >= 2^31 then
			-- Invalid spellID or duration. Remove it to prevent integer overflow errors.
			tremove(buffNames, k)
			TMW:Warn(L["ERROR_INVALID_SPELLID2"]:format(v))
		end
	end


	-- REMOVE SPELL DURATIONS (FOR UNIT COOLDOWNS/ICDs)
	-- THIS MUST HAPPEN LAST or else the duration array and spell array can get mismatched.
	if not keepDurations then
		for k, buffName in pairs(buffNames) do
			local spell, duration = splitSpellAndDuration(buffName)
			buffNames[k] = tonumber(spell) or spell
		end
	end

	return buffNames
end
parseSpellsString = TMW:MakeNArgFunctionCached(3, parseSpellsString)


local function getSpellNames(setting, doLower, firstOnly, toname, hash, allowRenaming)
	local buffNames = parseSpellsString(setting, doLower, false)

	-- buffNames MUST BE COPIED because the return from parseSpellsString is cached.
	buffNames = CopyTable(buffNames)

	if hash then
		local hash = {}
		for k, v in ipairs(buffNames) do
			if toname and (allowRenaming or tonumber(v)) then
				v = GetSpellInfo(v or "") or v -- Turn the value into a name if needed
			end

			v = TMW:LowerNames(v)

			-- Put the final value in the table as well (may or may not be the same as the original value).
			-- Value should be NameArrray's key, for use with the duration table.
			hash[v] = k	
		end
		return hash
	end

	if toname then
		if firstOnly then
			-- Turn the first value into a name and return it
			local ret = buffNames[1] or ""
			if (allowRenaming or tonumber(ret)) then
				ret = GetSpellInfo(ret) or ret 
			end

			if doLower then
				ret = TMW:LowerNames(ret)
			end

			return ret
		else
			-- Convert everything to a name
			for k, v in ipairs(buffNames) do
				if (allowRenaming or tonumber(v)) then
					buffNames[k] = GetSpellInfo(v or "") or v 
				end
			end

			if doLower
				then TMW:LowerNames(buffNames)
			end

			return buffNames
		end
	end

	if firstOnly then
		local ret = buffNames[1] or ""
		return ret
	end

	return buffNames
end

local function getSpellDurations(setting)
	local NameArray = parseSpellsString(setting, false, true)

	local DurationArray = CopyTable(NameArray)

	-- EXTRACT SPELL DURATIONS
	for k, buffName in pairs(NameArray) do
		local dur = strmatch(buffName, ".-:([%d:%s%.]*)$")
		if not dur then
			DurationArray[k] = 0
		else
			DurationArray[k] = tonumber( TMW.toSeconds(dur:trim(" :;.")) )
		end
	end

	return DurationArray
end






---------------------------------
-- TMW.C.SpellSet
---------------------------------

local tableArgs = {
	--						lower,	first,	toname,	hash
	First				= { 1,		1,		nil,	nil	},
	FirstString			= { 1,		1,		1,		nil },
	Array				= { 1,		nil,	nil,	nil },
	StringArray			= { 1,		nil,	1,		nil	},
	Hash				= { 1,		nil,	nil, 	1	},
	StringHash			= { 1,		nil,	1,		1	},

	--						lower,	first,	toname,	hash
	FirstNoLower		= { nil,	1,		nil,	nil },
	FirstStringNoLower	= { nil,	1,		1,		nil	},
	ArrayNoLower		= { nil,	nil,	nil,	nil	},
	StringArrayNoLower	= { nil,	nil,	1,		nil	},
	HashNoLower			= { nil,	nil,	nil, 	1	},
	StringHashNoLower	= { nil,	nil,	1,		1	},

	-- DUrations is kept in this table because it should also be cleared
	-- every time the cache needs to be reset (handled in the :Wipe() method).
	-- It is handled specially, though.
	Durations = true,
}
local __index_old = nil


TMW:NewClass("SpellSet"){
	instancesByName = {
		-- Keyed here by allowRenaming
		[true] = setmetatable({}, {__mode='kv'}),
		[false] = setmetatable({}, {__mode='kv'}),
	},

	OnFirstInstance = function(self)
		self:MakeInstancesWeak()

		__index_old = self.instancemeta.__index
		local meta = {}
		for k, v in pairs(self.instancemeta) do
			meta[k] = v
		end
		meta.__index = self.__index
		
		self.betterMeta = meta
	end,

	OnNewInstance = function(self, name, allowRenaming)
	 	allowRenaming = not not allowRenaming -- make sure its a boolean

		self.Name = name
		self.AllowRenaming = allowRenaming

		if name then
			self.instancesByName[allowRenaming][name] = self
		end
		
		setmetatable(self, self.betterMeta)
	end,

	__index = function(self, k)
		local v = __index_old[k]
		if v then
			return v
		end
		
		if k == "Durations" then
			self[k] = getSpellDurations(self.Name)
			return self[k]
		end

		local args = tableArgs[k]
		if args then
			self[k] = getSpellNames(self.Name, args[1], args[2], args[3], args[4], self.AllowRenaming)
			return self[k]
		end
	end,

	Wipe = function(self)
		for k, v in pairs(self) do
			if tableArgs[k] then
				self[k] = nil
			end 
		end
	end,
}

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	-- We need to wipe the stored objects/strings on every TMW_GLOBAL_UPDATE because of issues with
	-- spells that replace other spells in different specs, like Corruption/Immolate.
	-- TMW_GLOBAL_UPDATE might fire a little too often for this, but it is a surefire way to prevent issues that should
	-- hold up through out all future game updates because TMW_GLOBAL_UPDATE should always react to any changes in spec/talents/etc

	for _, instance in pairs(TMW.C.SpellSet.instances) do
		instance:Wipe()
	end
end)


--- Returns an instance of {{{TMW.C.SpellSet}}} for the given spellString.
-- The following can be accessed as members of the {{{TMW.C.SpellSet}}}:
-- * 
-- * {{{SpellSet.First}}} - The first spell in the spellString.
-- * {{{SpellSet.FirstString}}} - The first spell in the spellString, converted to a name if given as an ID.
-- * {{{SpellSet.Array}}} - An array of all spells in the spellString.
-- * {{{SpellSet.StringArray}}} - SpellSet.Array with any spellIDs converted to names.
-- * {{{SpellSet.Hash}}} - A dictionary of all spells in the spellString, with the values in the table being their index in the spellString (and their index in indexed tables of the SpellSet).
-- * {{{SpellSet.StringHash}}} - SpellSet.Hash with any spellIDs converted to names.
-- * {{{SpellSet.Durations}}} - An array of all the durations of spells in the spellString using the "Spell: Duration" syntax. Filled with zeroes for spells that don't use the duration synxtax.
-- Furthermore, all of the above, with the exception of SpellSet.Durations, may also have "NoLower" appended to prevent strlower()ing of any strings. E.g. {{{SpellSet.StringArrayNoLower}}}.

-- @arg spellString [string] A semicolon-delimited list of spells that
-- will be parsed and made available in various forms by the {{{TMW.C.SpellSet}}}.
-- @arg allowRenaiming [boolean] True if the SpellSet should attempt to rename spells
-- that were inputted by name but have different names because of the player's currently learned spells.
-- @return [TMW.C.SpellSet] An instance of {{{TMW.C.SpellSet}}} for the requested spells.
function TMW:GetSpells(spellString, allowRenaming)
	TMW:ValidateType("2 (spellString)", "TMW:GetSpells(spellString, allowRenaming)", spellString, "string;number")

	-- Make sure that allowRenaming is a boolean.
	allowRenaming = not not allowRenaming

	return TMW.C.SpellSet.instancesByName[allowRenaming][spellString] or TMW.C.SpellSet:New(spellString, allowRenaming)
end






---------------------------------
-- Misc Spell Name Helper Funcs
---------------------------------

local loweredbackup = {}
--- Converts a string, or all values of a table, to lowercase. Numbers are kept as numbers.
-- The original case is saved so that it can be used by TMW:RestoreCase() to restore the capitalization of spells that have been lowered.
-- @arg str [string|table] The string or table of spell names to strlower.
-- @return Returns what was passed in after strlowering it.
function TMW:LowerNames(str)
	
	if type(str) == "table" then -- Handle a table with recursion
		for k, v in pairs(str) do
			str[k] = TMW:LowerNames(v)
		end
		return str
	end

	local str_lower = strlowerCache[str]
	-- Dispel types retain their capitalization. Restore it here.
	for ds in pairs(TMW.DS) do
		if strlowerCache[ds] == str_lower then
			return ds
		end
	end

	if type(str_lower) == "string" then
		if loweredbackup[str_lower] then
			-- Dont replace names that are proper case with names that arent.
			-- Generally, assume that strings with more capitals after non-letters are more proper than ones with less
			local _, oldcount = gsub(loweredbackup[str_lower], "[^%a]%u", "%1")
			local _, newcount = gsub(str, "[^%a]%u", "%1")

			-- Check the first letter of each string for a capital
			if strfind(loweredbackup[str_lower], "^%u") then
				oldcount = oldcount + 1
			end
			if strfind(str, "^%u") then
				newcount = newcount + 1
			end

			-- The new string has more than the old, so use it instead
			if newcount > oldcount then
				loweredbackup[str_lower] = str
			end
		else
			-- There wasn't a string before, so set the base
			loweredbackup[str_lower] = str
		end
	end

	return str_lower
end

--- Attempts to restore the capitalization of a spell name that has been strlowered.
-- Numbers are returned immediately. Otherwise, the cache of lowered names from TMW:LowerNames() 
-- is checked, and if it isn't in there, TMW.strlowerCache is scanned for an original string.
function TMW:RestoreCase(str)
	if type(str) == "number" then
		return str
	elseif loweredbackup[str] then
		return loweredbackup[str], str
	else
		for original, lowered in pairs(strlowerCache) do
			if lowered == str then
				return original, str
			end
		end
		return str
	end
end

--- Generates a table of all the spells contained in a spell equivalency.
-- @arg name [string] The equivalency to generate a table for.
-- @return Returns the table of all the spells of the equivalency if it was valid, or nil if it wasn't.
function TMW:EquivToTable(name)

	-- Everything in this function is handled as lowercase to prevent issues with user input capitalization.
	-- DONT use TMW:LowerNames() here, because the input is not the output
	name = strlowerCache[name]


	-- See if the string being checked has a duration attached to it
	-- (It really shouldn't because there is currently no point in doing so,
	-- But a user did try this and made a bug report, so I fixed it anyway
	local eqname, duration = strmatch(name, "(.-):([%d:%s%.]*)$") 

	-- If there was a duration, then replace the old name with the actual name without the duration attached
	name = eqname or name 

	local tbl

	-- Iterate over all of TMW.BE's sub-categories ('buffs', 'debuffs', 'casts', etc)
	for k, v in pairs(TMW.BE) do
		-- Iterate over each equivalency in the category
		for equiv, t in pairs(v) do
			if strlowerCache[equiv] == name then
				-- We found a matching equivalency, so stop searching.
				tbl = t
				break
			end
		end
		if tbl then break end
	end

	-- If we didnt find an equivalency string then get out
	if not tbl then return end

	-- For each spell in the equivalency:
	for a, b in pairs(tbl) do
		-- Take off trailing spaces
		local new = strtrim(b) 

		-- Make sure it is a number if it can be
		new = tonumber(new) or new 

		-- Tack on the duration that should be applied to all spells if there was a duration
		if duration then 
			new = new .. ":" .. duration
		end

		-- Done. Stick the new value in the return table.
		tbl[a] = new
	end

	return tbl
end
TMW:MakeSingleArgFunctionCached(TMW, "EquivToTable")













---------------------------------
-- Constant spell data
---------------------------------


if pclass == "DRUID" then
	TMW.COMMON.CurrentClassTotems = {
		name = GetSpellInfo(145205),
		desc = L["ICONMENU_TOTEM_GENERIC_DESC"]:format(GetSpellInfo(145205)),
		{
			hasVariableNames = false,
			name = GetSpellInfo(145205),
			texture = GetSpellTexture(145205)
		}
	}
elseif pclass == "MAGE" then
	TMW.COMMON.CurrentClassTotems = {
		name = GetSpellInfo(116011),
		desc = L["ICONMENU_TOTEM_GENERIC_DESC"]:format(GetSpellInfo(116011)),
		{
			hasVariableNames = false,
			name = GetSpellInfo(116011),
			texture = GetSpellTexture(116011)
		}
	}

elseif pclass == "PALADIN" then
	local name = GetSpellInfo(26573) .. " & " .. GetSpellInfo(114158)
	TMW.COMMON.CurrentClassTotems = {
		name = name,
		desc = L["ICONMENU_TOTEM_GENERIC_DESC"]:format(name),
		{
			hasVariableNames = false,
			name = GetSpellInfo(26573), --consecration
			texture = GetSpellTexture(26573)
		},
        {
            hasVariableNames = false,
            name = GetSpellInfo(114158), --light's hammer
            texture = GetSpellTexture(114158)
        }
	}
elseif pclass == "MONK" then
	TMW.COMMON.CurrentClassTotems = {
		name = L["ICONMENU_STATUE"],
		desc = L["ICONMENU_TOTEM_GENERIC_DESC"]:format(L["ICONMENU_STATUE"]),
		{
			hasVariableNames = false,
			name = L["ICONMENU_STATUE"],
			texture = function()
				if GetSpecialization() == 1 then
					return GetSpellTexture(163177) -- black ox
				else
					return GetSpellTexture(115313) -- jade serpent
				end
			end,
		}
	}
elseif pclass == "DEATHKNIGHT" then
	local npcName = function(npcID)
		local cachedName = TMW:TryGetNPCName(npcID)
		return function()
			if cachedName then return cachedName end
			cachedName = TMW:TryGetNPCName(npcID)
			return cachedName
		end
	end
	local name = GetSpellInfo(49206) .. " & " .. GetSpellInfo(288853)
	TMW.COMMON.CurrentClassTotems = {
		name = name,
		desc = function() return L["ICONMENU_TOTEM_GENERIC_DESC"]:format(name) end,
		texture = GetSpellTexture(49206),
		[1] = { -- Raise Abomination (pvp talent)
			hasVariableNames = false,
			name = npcName(149555),
			texture = GetSpellTexture(288853),
		},
		[3] = { -- Ebon Gargoyle
			hasVariableNames = false,
			name = npcName(27829),
			texture = GetSpellTexture(49206),
		}
	}
else
	-- This includes shamans now in Legion - the elements of totems is no longer a notion.
	TMW.COMMON.CurrentClassTotems = {
		name = L["ICONMENU_TOTEM"],
		desc = L["ICONMENU_TOTEM_DESC"],
		{
			hasVariableNames = true,
			name = L["GENERICTOTEM"]:format(1),
			texture = "Interface\\ICONS\\ability_shaman_tranquilmindtotem"
		},
		{
			hasVariableNames = true,
			name = L["GENERICTOTEM"]:format(2),
			texture = "Interface\\ICONS\\ability_shaman_tranquilmindtotem"
		},
		{
			hasVariableNames = true,
			name = L["GENERICTOTEM"]:format(3),
			texture = "Interface\\ICONS\\ability_shaman_tranquilmindtotem"
		},
		{
			hasVariableNames = true,
			name = L["GENERICTOTEM"]:format(4),
			texture = "Interface\\ICONS\\ability_shaman_tranquilmindtotem"
		},
		{
			hasVariableNames = true,
			name = L["GENERICTOTEM"]:format(5),
			texture = "Interface\\ICONS\\ability_shaman_tranquilmindtotem"
		},
	}
end