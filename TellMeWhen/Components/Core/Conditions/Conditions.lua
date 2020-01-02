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
local Env

-- -----------------------
-- LOCALS/GLOBALS/UTILITIES
-- -----------------------

local L = TMW.L
local _, pclass = UnitClass("Player")

local tostring, type, pairs, ipairs, tremove, unpack, select, tonumber, wipe, assert, next, loadstring, setfenv, setmetatable =
	  tostring, type, pairs, ipairs, tremove, unpack, select, tonumber, wipe, assert, next, loadstring, setfenv, setmetatable
local strlower, min, max, gsub, strfind, strsub, strtrim, format, strmatch, strsplit, strrep =
	  strlower, min, max, gsub, strfind, strsub, strtrim, format, strmatch, strsplit, strrep
local NONE = NONE

local _G = _G
local print = TMW.print
local get = TMW.get
local clientVersion = select(4, GetBuildInfo())
local strlowerCache = TMW.strlowerCache
local isNumber = TMW.isNumber
local huge = math.huge
	
local CNDT = TMW:NewModule("Conditions", "AceEvent-3.0", "AceSerializer-3.0")
TMW.CNDT = CNDT


CNDT.ConditionsByType = {}



--- Conditions.lua contains the conditions core.
-- 
-- In it you can find methods for getting condition categories, condition objects, and condition constructors.
-- 
-- {{{CNDT}}} is an alias for {{{TMW.CNDT}}}
-- 
-- @class file
-- @name Conditions.lua




----------------------------------------------
-- CNDT.COMMON
----------------------------------------------

CNDT.COMMON = {}
CNDT.COMMON.standardtcoords = {0.07, 0.93, 0.07, 0.93}






----------------------------------------------
-- Condition Settings, Defaults, & Upgrades
----------------------------------------------

CNDT.Condition_Defaults = {
	n 					= 0,
	["**"] = {
		AndOr			= "AND",
		Type			= "",
		Icon			= "",
		Operator		= "==",
		Level			= 0,
		Unit			= "player",
		Name			= "",
		Name2			= "",
		PrtsBefore		= 0,
		PrtsAfter		= 0,
		Checked			= false,
		Checked2		= false,

		-- Runes 		= {}, -- Deprecated

		-- IMPORTANT: This setting can be a number OR a table.
		BitFlags		= 0x0, -- may also be a table.
	},
}
setmetatable(CNDT.Condition_Defaults["**"], {
	__newindex = function(self, k, v)
		if TMW.InitializedDatabase then
			error("New condition defaults cannot be added after the database has already been initialized", 2)
		end
		
		TMW:Fire("TMW_CNDT_DEFAULTS_NEWVAL", k, v)
		
		rawset(self, k, v)
	end,
})


--- Registers default condition settings. Must be called before TMW's database is initialized.
-- @param defaults [table] A table that will be merged into CNDT.Condition_Defaults
function CNDT:RegisterConditionDefaults(defaults)
	TMW:ValidateType("2 (defaults)", "CNDT:RegisterConditionDefaults(defaults)", defaults, "table")
	
	if TMW.InitializedDatabase then
		error("Defaults for conditions are being registered too late. They need to be registered before the database is initialized.")
	end
	
	-- Copy the defaults into the main defaults table.
	TMW:MergeDefaultsTables(defaults, CNDT.Condition_Defaults["**"])
end


TMW:RegisterUpgrade(61011, {
	condition = function(self, condition)
		-- Don't show these help messages for users who already use the settings.
		if condition.PrtsBefore ~= 0 or condition.PrtsAfter ~= 0 then
			TMW.db.global.HelpSettings.CNDT_PARENTHESES_FIRSTSEE = true
		end
		if condition.AndOr == "OR" then
			TMW.db.global.HelpSettings.CNDT_ANDOR_FIRSTSEE = true
		end
	end,
})
TMW:RegisterUpgrade(60026, {
	stances = {
		{class = "WARRIOR", 	id = 2457}, 	-- Battle Stance
		{class = "WARRIOR", 	id = 71}, 		-- Defensive Stance
		{class = "WARRIOR", 	id = 2458}, 	-- Berserker Stance

		{class = "DRUID", 		id = 5487}, 	-- Bear Form
		{class = "DRUID", 		id = 768}, 		-- Cat Form
		{class = "DRUID", 		id = 1066}, 	-- Aquatic Form
		{class = "DRUID", 		id = 783}, 		-- Travel Form
		{class = "DRUID", 		id = 24858}, 	-- Moonkin Form
		{class = "DRUID", 		id = 33891}, 	-- Tree of Life
		{class = "DRUID", 		id = 33943}, 	-- Flight Form
		{class = "DRUID", 		id = 40120}, 	-- Swift Flight Form

		{class = "PRIEST", 		id = 15473}, 	-- Shadowform

		{class = "ROGUE", 		id = 1784}, 	-- Stealth

		{class = "HUNTER", 		id = 82661}, 	-- Aspect of the Fox
		{class = "HUNTER", 		id = 13165}, 	-- Aspect of the Hawk
		{class = "HUNTER", 		id = 5118}, 	-- Aspect of the Cheetah
		{class = "HUNTER", 		id = 13159}, 	-- Aspect of the Pack
		{class = "HUNTER", 		id = 20043}, 	-- Aspect of the Wild

		{class = "DEATHKNIGHT", id = 48263}, 	-- Blood Presence
		{class = "DEATHKNIGHT", id = 48266}, 	-- Frost Presence
		{class = "DEATHKNIGHT", id = 48265}, 	-- Unholy Presence

		{class = "PALADIN", 	id = 19746}, 	-- Concentration Aura
		{class = "PALADIN", 	id = 32223}, 	-- Crusader Aura
		{class = "PALADIN", 	id = 465}, 		-- Devotion Aura
		{class = "PALADIN", 	id = 19891}, 	-- Resistance Aura
		{class = "PALADIN", 	id = 7294}, 	-- Retribution Aura

		{class = "WARLOCK", 	id = 47241}, 	-- Metamorphosis
		
		--[[{class = "MONK", 		id = 115069}, 	-- Sturdy Ox
		{class = "MONK", 		id = 115070}, 	-- Wise Serpent
		{class = "MONK", 		id = 103985}, 	-- Fierce Tiger]]
	},
	
	setupcsn = function(self)
		self.CSN = {
			[0]	= NONE,
		}

		for _, stanceData in ipairs(self.stances) do
			if stanceData.class == pclass then
				local stanceName = GetSpellInfo(stanceData.id)
				tinsert(self.CSN, stanceName)
			end
		end

		for i, stanceName in pairs(self.CSN) do
			self.CSN[stanceName] = i
		end

	end,
	condition = function(self, condition)
		if condition.Type == "STANCE" then
			if not self.CSN then
				self:setupcsn()
			end
			
			-- Make sure that there actually are stances for this class
			if self.CSN[1] then
				condition.Name = ""
				
				if condition.Operator == "==" then
					condition.Name = self.CSN[condition.Level]
					condition.Level = 0 -- true
				elseif condition.Operator == "~=" then
					condition.Name = self.CSN[condition.Level]
					condition.Level = 1 -- false
				elseif condition.Operator:find(">") then
					condition.Name = ""
					
					-- If the operator is >= then include the condition at condition.Level
					-- If the operator is > then start on the condition immediately after condition.Level
					local startOffset = condition.Operator:find("=") and 0 or 1
					
					for i = condition.Level + startOffset, #self.CSN do
						condition.Name = condition.Name .. self.CSN[i] .. "; "
					end
					condition.Name = condition.Name:sub(1, -3) -- trim off the ending semicolon and space
					
					condition.Level = 0 -- true
				elseif condition.Operator:find("<") then
					condition.Name = ""
					
					-- If the operator is >= then include the condition at condition.Level
					-- If the operator is > then start on the condition immediately before condition.Level
					local startOffset = condition.Operator:find("=") and 0 or 1
					
					-- Iterate backwards towards 1
					for i = condition.Level - startOffset, 1, -1 do
						condition.Name = condition.Name .. self.CSN[i] .. "; "
					end
					condition.Name = condition.Name:sub(1, -3) -- trim off the ending semicolon and space
					
					condition.Level = 0 -- true
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(51008, {
	condition = function(self, condition)
		if condition.Type == "TOTEM1"
		or condition.Type == "TOTEM2"
		or condition.Type == "TOTEM3"
		or condition.Type == "TOTEM4"
		then
			condition.Name = ""
		end
	end,
})
TMW:RegisterUpgrade(46417, {
	-- cant use the conditions key here because it depends on Conditions.n, which is 0 until this is ran
	-- also, dont use TMW:InNLengthTable because it will use conditions.n, which is 0 until the upgrade is complete
	group = function(self, gs)
		local n = 0
		for k in pairs(gs.Conditions) do
			if type(k) == "number" then
				n = max(n, k)
			end
		end
		gs.Conditions.n = n
	end,
	icon = function(self, ics)
		local n = 0
		for k in pairs(ics.Conditions) do
			if type(k) == "number" then
				n = max(n, k)
			end
		end
		ics.Conditions.n = n
	end,
})
TMW:RegisterCallback("TMW_DB_PRE_DEFAULT_UPGRADES", function() -- 46413
	-- The default condition type changed from "HEALTH" to "" in v46413
	-- So, if the user is upgrading to this version, and Condition.Type is nil,
	-- then it must have previously been set to "HEALTH", causing Ace3DB not to store it,
	-- so explicity set it as "HEALTH" to make sure it doesn't change just because the default changed.
	
	if TellMeWhenDB.profiles and TellMeWhenDB.Version < 46413 then
		for _, p in pairs(TellMeWhenDB.profiles) do
			if p.Groups then
				for _, gs in pairs(p.Groups) do
					if gs.Conditions then
						for k, Condition in pairs(gs.Conditions) do
							if type(k) == "number" and Condition.Type == nil then
								Condition.Type = "HEALTH"
							end
						end
					end
					if gs.Icons then
						for _, ics in pairs(gs.Icons) do
							if ics.Conditions then
								for k, Condition in pairs(ics.Conditions) do
									if type(k) == "number" and Condition.Type == nil then
										Condition.Type = "HEALTH"
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)
TMW:RegisterUpgrade(45802, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and condition.Type == "CASTING" then
				condition.Name = ""
			end
		end
	end,
})
TMW:RegisterUpgrade(44202, {
	icon = function(self, ics)
		ics.Conditions["**"] = nil
	end,
})
TMW:RegisterUpgrade(42105, {
	-- cleanup some old stuff that i noticed is sticking around in my settings, probably in other peoples' settings too
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" then
				for k in pairs(condition) do
					if strfind(k, "Condition") then
						condition[k] = nil
					end
				end
				condition.Names = nil
			end
		end
	end,
})
TMW:RegisterUpgrade(41206, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and condition.Type == "STANCE" then
				condition.Operator = "=="
			end
		end
	end,
})
TMW:RegisterUpgrade(41008, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" then
				if condition.Type == "SPELLCD" or condition.Type == "ITEMCD" then
					if condition.Level == 0 then
						condition.Operator = "=="
					elseif condition.Level == 1 then
						condition.Operator = ">"
						condition.Level = 0
					end
				elseif condition.Type == "MAINHAND" or condition.Type == "OFFHAND" or condition.Type == "THROWN" then
					if condition.Level == 0 then
						condition.Operator = ">"
					elseif condition.Level == 1 then
						condition.Operator = "=="
						condition.Level = 0
					end
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(41004, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" then
				if condition.Type == "BUFF" then
					condition.Type = "BUFFSTACKS"
				elseif condition.Type == "DEBUFF" then
					condition.Type = "DEBUFFSTACKS"
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(40115, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and (condition.Type == "BUFF" or condition.Type == "DEBUFF") then
				if condition.Level == 0 then
					condition.Operator = ">"
				elseif condition.Level == 1 then
					condition.Operator = "=="
					condition.Level = 0
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(40112, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and condition.Type == "CASTING" then
				condition.Level = condition.Level + 1
			end
		end
	end,
})
TMW:RegisterUpgrade(40106, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and condition.Type == "ITEMINBAGS" then
				if condition.Level == 0 then
					condition.Operator = ">"
				elseif condition.Level == 1 then
					condition.Operator = "=="
					condition.Level = 0
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(40100, {
	icon = function(self, ics)
		for k, condition in pairs(ics.Conditions) do
			if type(k) == "number" and condition.Type == "NAME" then
				condition.Level = 0
			end
		end
	end,
})
TMW:RegisterUpgrade(40080, {
	icon = function(self, ics)
		for k, v in pairs(ics.Conditions) do
			if type(k) == "number" and v.Type == "ECLIPSE_DIRECTION" and v.Level == -1 then
				v.Level = 0
			end
		end
	end,
})
TMW:RegisterUpgrade(22010, {
	icon = function(self, ics, ...)
		for k, condition in ipairs(ics.Conditions) do
			local old = condition

			-- Recreate the condition
			ics.Conditions[k] = nil
			condition = ics.Conditions[k]
			for k, v in pairs(old) do
				if k:find("Condition") then
					condition[k:gsub("Condition", "")] = v
				end
			end
		end
	end,
})
TMW:RegisterUpgrade(22000, {
	icon = function(self, ics)
		for k, v in ipairs(ics.Conditions) do
			if type(k) == "number" and ((v.ConditionType == "ICON") or (v.ConditionType == "EXISTS") or (v.ConditionType == "ALIVE")) then
				v.ConditionLevel = 0
			end
		end
	end,
})
TMW:RegisterUpgrade(20100, {
	icon = function(self, ics)
		for k, v in ipairs(ics.Conditions) do
			v.ConditionLevel = tonumber(v.ConditionLevel) or 0
			if type(k) == "number" and ((v.ConditionType == "SOUL_SHARDS") or (v.ConditionType == "HOLY_POWER")) and (v.ConditionLevel > 3) then
				v.ConditionLevel = ceil((v.ConditionLevel/100)*3)
			end
		end
	end,
})

function CNDT:ConvertSliderCondition(condition, min, max, flagRemap)
    local op = condition.Operator
    local flags = {}
    condition.BitFlags = flags
    if op == "==" then
        flags[condition.Level] = true
    elseif op == "<=" then
        for i = min, condition.Level do
            flags[i] = true
        end
    elseif op == "<" then
        for i = min, condition.Level-1 do
            flags[i] = true
        end
    elseif op == ">" then
        for i = condition.Level+1, max do
            flags[i] = true
        end
    elseif op == ">=" then
        for i = condition.Level, max do
            flags[i] = true
        end
    elseif op == "~=" then
        flags[condition.Level] = true
        condition.Checked = true
    end
    if flagRemap then
        local fc = CopyTable(flags)
        wipe(flags)
        for k, v in pairs(fc) do 
            flags[flagRemap[k]] = v 
        end
    end
end





----------------------------------------------
-- Checker/Anticipator Function Environment
----------------------------------------------

--- The function environment used for condition checker functions and update anticipator functions.
CNDT.Env = {	
	strlower = strlower,
	strlowerCache = TMW.strlowerCache,
	strfind = strfind,
	floor = floor,
	select = select,
	min = min,
	max = max,
	tonumber = tonumber,
	isNumber = TMW.isNumber,
	
	print = TMW.print,
	type = type,
	time = TMW.time,
	huge = math.huge,
	epsilon = 1e-255,

	bit = bit,
	bit_band = bit.band,
	bit_bor = bit.bor,
	bit_lshift = bit.lshift,


	TMW = TMW,
	GCDSpell = TMW.GCDSpell,
	GUIDToOwner = TMW.GUIDToOwner,
	
	SemicolonConcatCache = setmetatable(
	{}, {
		__index = function(t, i)
			if not i then return ";;" end

			local o = ";" .. strlowerCache[i] .. ";"
			
			-- escape ()[]-+*^$. since the purpose of this is to be the 2nd arg to strfind
			o = o:gsub("([%(%)%%%[%]%-%+%*%.%^%$])", "%%%1")
			
			t[i] = o
			return o
		end,
	}),
	
	-- These are here as a primitive security measure to prevent some of the most basic forms of malicious Lua conditions.
	-- This list isn't even exhaustive, and it is in no way cracker-proof, but its a start.
    CancelLogout = error,
    DownloadSettings = error,
    ForceLogout = error,
    ForceQuit = error,
    Logout = error,
    Quit = error,
    ReloadUI = error,
    Screenshot = error,
    SetEuropeanNumbers = error,
    SetUIVisibility = error,
    UploadSettings = error,
    DeleteCursorItem = error,
    ClearCursor = error,
    AcceptDuel = error,
    CancelDuel = error,
    StartDuel = error,
    DeleteGMTicket = error,
    AcceptTrade = error,
    SendMail = error,
    GuildDisband = error,
    GuildPromote = error,

} Env = CNDT.Env

CNDT.EnvMeta = {
	__index = _G,
	-- don't do this. Manually add to _G if you need to add to _G.
	--__newindex = _G,
}

TMW:RegisterCallback("TMW_ONUPDATE_PRE", function(event, time_arg)
	Env.time = time_arg
end)

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()
	Env.Locked = TMW.Locked
end)






-- --------------------------------------------
-- Checker/Anticipator Function Helpers
-- --------------------------------------------

local function strWrap(string)
	local num = isNumber[string]
	if num then
		return num
	else
		return format("%q", string)
	end
end

Env.ItemRefs = {}
function CNDT:GetItemRefForConditionChecker(name)
	local item = TMW:GetItems(name)[1]

	if not item then
		item = TMW:GetNullRefItem()
	end

	Env.ItemRefs[name] = item

	return "ItemRefs[" .. strWrap(name) .. "]"
end


--- Obtains the first unit from a unit setting and makes sure it is clean. Should be called whenever using unit settings, like in the {{{conditionData.events}}} function.
-- @param setting [string] A raw condition setting that represents a unit.
-- @return [string] The cleaned first unit from the setting passed in.
function CNDT:GetUnit(setting)
	return TMW.UNITS:GetOriginalUnitTable(setting)[1] or ""
end


function CNDT:GetTableSubstitution(tbl)
	TMW:ValidateType("CNDT:GetTableSubstitution(tbl)", "tbl", tbl, "table")

	-- We used to check the format of the address explicitly,
	-- but ticket 1076 demonstrates that sometimes it can be in the format
	-- "table: 0000000312EBEB0" (the format I get), or "table: 0x1ba1bbb00" (from the ticket)
	-- so instead we just check that the metatable exists.
	local address = tostring(tbl)
	if TMW.approachTable(tbl, getmetatable, "__tostring") then
		error("can't substitute tables with __tostring metamethods: " .. address)
	end

	local var = address:gsub(":", "_"):gsub(" ", "")
	CNDT.Env[var] = tbl

	return var
end

function CNDT:GetBitFlag(conditionSettings, index)
	if type(conditionSettings.BitFlags) == "table" then
		return conditionSettings.BitFlags[index]
	else
		local flag = bit.lshift(1, index-1)
		return bit.band(conditionSettings.BitFlags, flag) == flag
	end
end

function CNDT:ToggleBitFlag(conditionSettings, index)
	if type(conditionSettings.BitFlags) == "table" then
		conditionSettings.BitFlags[index] = (not conditionSettings.BitFlags[index]) and true or nil
	else
		local flag = bit.lshift(1, index-1)
		conditionSettings.BitFlags = bit.bxor(conditionSettings.BitFlags, flag)
	end
end

function CNDT:ConvertBitFlagsToTable(conditionSettings, conditionData)
	if type(conditionSettings.BitFlags) == "table" then
		return
	end

	local flagsOld = conditionSettings.BitFlags
	conditionSettings.BitFlags = {}

	for index, _ in pairs(conditionData.bitFlags) do
		if type(index) == "number" and index < 32 and index >= 1 then
			local flag = bit.lshift(1, index-1)
			local flagSet = bit.band(flagsOld, flag) == flag
			conditionSettings.BitFlags[index] = flagSet and true or nil
		end
	end
end


CNDT.Substitutions = {

{	src = "BITFLAGSMAPANDCHECK(%b())",
	rep = function(conditionData, conditionSettings, name, name2)
		if type(conditionSettings.BitFlags) == "table" then
			if conditionSettings.Checked then
				return [[ not c.BitFlags[%1] ]]
			else
				return [[ c.BitFlags[%1] ]]
			end
		else
			if conditionSettings.Checked then
				return [[bit_band(bit_lshift(1, (%1 or 1) - 1), c.BitFlags) == 0]]
			else
				return [[bit_bor(bit_lshift(1, (%1 or 1) - 1), c.BitFlags) == c.BitFlags]]
			end
		end
	end,
},{	src = "c.BitFlags",
	rep = function(conditionData, conditionSettings, name, name2)
		TMW:ValidateType("c.BitFlags", conditionData.identifier, conditionSettings.BitFlags, "table;number")

		if type(conditionSettings.BitFlags) == "table" then
			return CNDT:GetTableSubstitution(conditionSettings.BitFlags)
		elseif type(conditionSettings.BitFlags) == "number" then
			return conditionSettings.BitFlags
		end
	end,
},

{	src = "BOOLCHECK(%b())",
	rep = function(conditionData, conditionSettings, name, name2)
		if conditionSettings.Level == 0 then
			return [[%1]]
		else
			return [[not %1]]
		end
	end,
},
{	src = "MULTINAMECHECK(%b())",
	rep = function(conditionData, conditionSettings, name, name2)
		return [[ (not not strfind(c.Name, SemicolonConcatCache[%1])) ]]
	end,
},

{	src = "c.Level",
	rep = function(conditionData, conditionSettings, name, name2)
		TMW:ValidateType("c.Level", conditionData.identifier, conditionSettings.Level, "number")

		return conditionData.percent and conditionSettings.Level/100 or conditionSettings.Level
	end,
},{
	src = "c.Checked",
	rep = function(conditionData, conditionSettings, name, name2)
		TMW:ValidateType("c.Checked", conditionData.identifier, conditionSettings.Checked, "boolean")

		return tostring(conditionSettings.Checked)
	end,
},{
	src = "c.Checked2",
	rep = function(conditionData, conditionSettings, name, name2)
		TMW:ValidateType("c.Checked2", conditionData.identifier, conditionSettings.Checked2, "boolean")

		return tostring(conditionSettings.Checked2)
	end,
},{
	src = "c.Operator",
	rep = function(conditionData, conditionSettings, name, name2)
		TMW:ValidateType("c.Operator", conditionData.identifier, conditionSettings.Operator, "string")
		if conditionSettings.Operator:find("[^<>~=]") then
			error("Invalid operator to " .. conditionData.identifier)
		end

		return conditionSettings.Operator
	end,
},

{
	src = "c.NameFirst2",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(TMW:GetSpells(name2).First)

	end,
},{
	src = "c.NameString2",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(TMW:GetSpells(name2).FirstString)
	end,
},{
	src = "c.ItemID2",
	rep = "error('Condition sub c.ItemID is obsolete')",
},{
	src = "c.Name2Raw",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(conditionSettings.Name2)
	end,
},{
	src = "c.Name2",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(name2)
	end,
},

{
	src = "c.NameFirst",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(TMW:GetSpells(name).First)
	end,
},{
	src = "c.NameStrings",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(";" .. table.concat(TMW:GetSpells(name).StringArray, ";") .. ";")
	end,
},{
	src = "c.NameString",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(TMW:GetSpells(name).FirstString)
	end,
},{
	src = "c.ItemID",
	rep = "error('Condition sub c.ItemID is obsolete')",
},{
	src = "c.NameRaw",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(conditionSettings.Name)
	end,
},{
	src = "c.Name",
	rep = function(conditionData, conditionSettings, name, name2)
		return strWrap(name)
	end,
},

{
	src = "c.True",
	rep = 	function(conditionData, conditionSettings, name, name2)
		return tostring(conditionSettings.Level == 0)
	end,
},{
	src = "c.False",
	rep = function(conditionData, conditionSettings, name, name2)
		return tostring(conditionSettings.Level == 1)
	end,
},{
	src = "c.1nil",
	rep = function(conditionData, conditionSettings, name, name2)
		return conditionSettings.Level == 0 and 1 or "nil"
	end,
},{
	src = "c.nil1",
	rep = function(conditionData, conditionSettings, name, name2)
		-- reverse 1nil
		return conditionSettings.Level == 1 and 1 or "nil"
	end,
},

{
	src = "c.GCDReplacedNameFirst2",
	rep = function(conditionData, conditionSettings, name, name2)

		local name = TMW:GetSpells(name2).First
		if name == "gcd" then
			name = TMW.GCDSpell
		end
		return strWrap(name)
	end,
},{
	src = "c.GCDReplacedNameFirst",
	rep = function(conditionData, conditionSettings, name, name2)
		local name = TMW:GetSpells(name).First
		if name == "gcd" then
			name = TMW.GCDSpell
		end
		return strWrap(name)
	end,
},

{
	src = "c.Item2",
	rep = function(conditionData, conditionSettings, name, name2)
		return CNDT:GetItemRefForConditionChecker(name2)
	end,
},{
	src = "c.Item",
	rep = function(conditionData, conditionSettings, name, name2)
		return CNDT:GetItemRefForConditionChecker(name)
	end,
},

{
	src = "c.Icon",
	rep = function(conditionData, conditionSettings, name, name2)
		return format("GUIDToOwner[%q]", conditionSettings.Icon:gsub("%%", "%%%%"))
	end,
},

{
	src = "LOWER(%b())",
	rep = function() return strlower end,
},}

local conditionNameSettingProcessedCache = setmetatable(
{}, {
	__mode = "kv",
	__index = function(t, i)
		if not i then return end

		local name = gsub((i or ""), "; ", ";")
		name = gsub(name, " ;", ";")
		name = ";" .. name .. ";"
		name = gsub(name, ";;", ";")
		name = strtrim(name)
		name = strlower(name)

		t[i] = name
		return name
	end,
	__call = function(t, i)
		return t[i]
	end,
})

-- [INTERNAL]
function CNDT:GetConditionUnitSubstitution(unit)

	local translatedUnits, unitSet = TMW:GetUnits(nil, unit)
	local firstOriginal = unitSet.originalUnits[1]
	local substitution
	if unitSet.hasSpecialUnitRefs then
		-- The unit is probably a special unit.
		-- We will use the unit set to perform the translation
		-- from the special unit to a real unit.
		-- We have to have the " or <originalUnits[1]>" part
		-- so that in case the special unit doesn't map to anything,
		-- we won't be passing nil to functions that don't accept nil.
		substitution = 
			CNDT:GetTableSubstitution(translatedUnits)
			.. "[1] or "
			.. strWrap(firstOriginal)
	else
		-- The unit is something that can be passed raw as a unitID.
		-- Just sub it straight in as a string.
		substitution = strWrap(firstOriginal or "")
	end

	return substitution
end

-- [INTERNAL]
function CNDT:DoConditionSubstitutions(conditionData, conditionSettings, funcstr)
	-- Substitutes all the c.XXXXX substitutions into a string.
	
	for _, append in TMW:Vararg("2", "") do -- Unit2 MUST be before Unit
		if strfind(funcstr, "c.Unit" .. append) then
			-- Use CNDT:GetUnit() first to grab only the first unit
			-- in case the configured value is an expansion (like party1-4).
			local unit
			if append == "2" then
				unit = CNDT:GetUnit(conditionSettings.Name)
			elseif append == "" then
				unit = CNDT:GetUnit(conditionSettings.Unit)
			end
			if unit then
				funcstr = gsub(funcstr, "c.Unit" .. append,	CNDT:GetConditionUnitSubstitution(unit))
			end
		end
	end

	local name  = conditionNameSettingProcessedCache[conditionSettings.Name]
	local name2 = conditionNameSettingProcessedCache[conditionSettings.Name2]

	for k, subData in pairs(CNDT.Substitutions) do
		if funcstr:find(subData.src) then
			funcstr = funcstr:gsub(subData.src, TMW.get(subData.rep, conditionData, conditionSettings, name, name2))
		end
	end

	return funcstr
end

-- [INTERNAL]
function CNDT:GetConditionCheckFunctionString(parent, Conditions)
	-- Compiles the function checker string for the conditions.
	-- Doesn't depend on a ConditionObject because this function is used to 
	-- check the cache for a ConditionObject that might already exist for the conditions.
	-- The return from this function is passed to ConditionObject's constructor.
	
	local funcstr = ""
	
	if not CNDT:CheckParentheses(Conditions) then
		return ""
	end

	for n, conditionSettings in TMW:InNLengthTable(Conditions) do
		local Type = conditionSettings.Type
		local conditionData = CNDT.ConditionsByType[Type]
		
		local andor
		if n == 1 then
			andor = ""
		elseif conditionSettings.AndOr == "OR" then
			andor = "or "
		elseif conditionSettings.AndOr == "AND" then
			andor = "and"
		end

		if conditionSettings.Operator == "~|="
		or conditionSettings.Operator == "|="
		or conditionSettings.Operator == "||=" then
			-- fix potential corruption from importing a string
			-- (a single | becaomes || when pasted, "~=" in encoded as "~|=")
			conditionSettings.Operator = "~=" 
		end

		local thisstr = "true"
		if conditionData then
		
			if conditionData:UsesTabularBitflags() then
				CNDT:ConvertBitFlagsToTable(conditionSettings, conditionData)
			end

			conditionData:PrepareEnv()

			if conditionData:IsDeprecated() then
				TMW:QueueValidityCheck(parent, "<CONDITION>", L["VALIDITY_CONDITION2_DESC"], n)
				thisstr = "true"
			else
				thisstr = get(conditionData.funcstr, conditionSettings, parent) or "true"
			end
		else
			TMW:QueueValidityCheck(parent, "<CONDITION>", L["VALIDITY_CONDITION2_DESC"], n)
		end
		
		if Conditions.n >= 3 then
			thisstr = strrep("(", conditionSettings.PrtsBefore) .. thisstr .. strrep(")", conditionSettings.PrtsAfter)
		end

		thisstr = andor .. "(" .. thisstr .. ")"
		

		if conditionData then
			thisstr = CNDT:DoConditionSubstitutions(conditionData, conditionSettings, thisstr)
		end
		
		funcstr = funcstr .. "    " .. thisstr .. " -- " .. n .. "_" .. Type .. "\r\n"
	end
	
	if funcstr ~= "" then
		funcstr = "local ConditionObject = ... \r\n return (\r\n " .. funcstr .. " )"
	end
	
	return funcstr
end

-- [INTERNAL]
function CNDT:CheckParentheses(settings)	
	-- Returns true if the parentheses for a set of condition settings are valid, otherwise false
	-- Second return is a localized error message if they are invalid.

	if settings.n < 3 then
		-- Remove hanging parens from condition settings with less than 3 conditions.
		-- This prevents issues with post-user condition modifying via ConditionObjectConstructor,
		-- and just ensures general sanity.
		for _, Condition in TMW:InNLengthTable(settings) do
			Condition.PrtsBefore = 0
			Condition.PrtsAfter = 0
		end
		return true
	end
	
	local numclose, numopen, runningcount = 0, 0, 0
	local unopened = 0

	for _, Condition in TMW:InNLengthTable(settings) do
		for i = 1, Condition.PrtsBefore do
			numopen = numopen + 1
			runningcount = runningcount + 1
			if runningcount < 0 then unopened = unopened + 1 end
		end
		for i = 1, Condition.PrtsAfter do
			numclose = numclose + 1
			runningcount = runningcount - 1
			if runningcount < 0 then unopened = unopened + 1 end
		end
	end

	if numopen ~= numclose then
		local typeNeeded, num
		if numopen > numclose then
			typeNeeded, num = ")", numopen-numclose
		else
			typeNeeded, num = "(", numclose-numopen
		end
		
		return false, L["PARENTHESIS_WARNING1"]:format(num, L["PARENTHESIS_TYPE_" .. typeNeeded])
	elseif unopened > 0 then
		
		return false, L["PARENTHESIS_WARNING2"]:format(unopened)
	else
		
		return true
	end
end






----------------------------------------------
-- Public Constructor Wrapper Methods
----------------------------------------------

--- Gets a [[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]] instance.
-- If a pre-used one is not available for use, a new one will be created.
-- @return [[[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]]] An instance of a [[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]].
function CNDT:GetConditionObjectConstructor()
	for _, instance in pairs(TMW.Classes.ConditionObjectConstructor.instances) do
		if instance.status == "ready" then
			return instance
		end
	end
	
	return TMW.Classes.ConditionObjectConstructor:New()
end

--- Gets a [[api/conditions/api-documentation/condition-object/|ConditionObject]] for the specified parent and condition settings.
-- @param parent [table] The parent object of the ConditionObject.
-- @param conditionSettings [table] The condition settings that the ConditionObject will be created for.
-- @return [ [[api/conditions/api-documentation/condition-object/|ConditionObject]]|nil] A [[api/conditions/api-documentation/condition-object/|ConditionObject]] instance (may be previously cached or may be a new instance), or nil if the conditions passed in were invalid.
function CNDT:GetConditionObject(parent, conditionSettings)
	local conditionString = CNDT:GetConditionCheckFunctionString(parent, conditionSettings)
	
	if conditionString and conditionString ~= "" then
		local instances = TMW.Classes.ConditionObject.instances
		for i, instance in pairs(instances) do
			if instance.conditionString == conditionString then
				return instance
			end
		end
		return TMW.Classes.ConditionObject:New(conditionSettings, conditionString)
	end
end







----------------------------------------------
-- Condition Categories
----------------------------------------------

CNDT.Categories = {}
CNDT.CategoriesByID = {}

--- Gets a [[api/conditions/api-documentation/condition-category/|ConditionCategory]] instance. If one does not already exist with the specified identifier, a new one will be created.
-- @param identifier [string] A string that will uniquely identify this category.
-- @param order [number] The order of this category, relative to other categories, in the condition type dropdown menu.
-- @param categoryName [string] Localized name of the category.
-- @param spaceBefore [boolean|nil] True if there should be a space before this category is listed in the condition type dropdown menu.
-- @param spaceAfter [boolean|nil] True if there should be a space after this category is listed in the condition type dropdown menu.
function CNDT:GetCategory(identifier, order, categoryName, spaceBefore, spaceAfter)
	TMW:ValidateType("2 (identifier)", "CNDT:GetCategory()", identifier, "string")
	
	if CNDT.CategoriesByID[identifier] then
		return CNDT.CategoriesByID[identifier]
	end
	
	TMW:ValidateType("3 (order)", "CNDT:GetCategory()", order, "number")
	TMW:ValidateType("4 (categoryName)", "CNDT:GetCategory()", categoryName, "string")
	
	return TMW.Classes.ConditionCategory:New(identifier, order, categoryName, spaceBefore, spaceAfter)
end







----------------------------------------------
-- Condition Sets & ConditionSetImplementor
----------------------------------------------

CNDT.ConditionSets = {}
local ConditionSets = CNDT.ConditionSets

TMW:NewClass("ConditionSetImplementor"){
	OnNewInstance_ConditionSetImplementor = function(self)
		if type(self.GetName) == "function" then
			Env[self:GetName()] = self
		end
	end,
	
	--- Gets a [[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]] and loads in self as the parent and the passed in settings as the settings.
	-- @name ConditionSetImplementor:Conditions_GetConstructor
	-- @paramsig conditionSettings
	-- @param conditionSettings [table] The condition settings that will be loaded into the ConditionObjectConstructor.
	-- @return [[[api/conditions/api-documentation/condition-object-constructor/|ConditionObjectConstructor]]] An instance of a ConditionObjectConstructor.
	-- @usage local ConditionObjectConstructor = icon:Conditions_GetConstructor(icon.Conditions)
	-- icon.ConditionObject = ConditionObjectConstructor:Construct()
	Conditions_GetConstructor = function(self, conditionSettings)
		local ConditionObjectConstructor = CNDT:GetConditionObjectConstructor()
		
		ConditionObjectConstructor:LoadParentAndConditions(self, conditionSettings)
		
		return ConditionObjectConstructor
	end,
}

--- Registers a Condition Set. A condition set defines an implementation of conditions.
-- @param identifier [string] An identifier for this condition set.
-- @param conditionSetData [table] A table that defines how the condition set is implemented. See the [[api/conditions/api-documentation/condition-set-specification|Condition Set Specification]]
function CNDT:RegisterConditionSet(identifier, conditionSetData)
	local data = conditionSetData
	
	TMW:ValidateType("2 (identifier)", "CNDT:RegisterConditionSet()", identifier, "string")
	TMW:ValidateType("3 (conditionSetData)", "CNDT:RegisterConditionSet()", data, "table")
	
	TMW:ValidateType("parentSettingType", "conditionSetData", data.parentSettingType, "string")
	TMW:ValidateType("parentDefaults", "conditionSetData", data.parentDefaults, "table")
	TMW:ValidateType("modifiedDefaults", "conditionSetData", data.modifiedDefaults, "table;nil")
	
	TMW:ValidateType("ConditionTypeFilter", "conditionSetData", data.ConditionTypeFilter, "function;nil")
	
	TMW:ValidateType("settingKey", "conditionSetData", data.settingKey, "string")
	TMW:ValidateType("GetSettings", "conditionSetData", data.GetSettings, "function")
	
	TMW:ValidateType("iterFunc", "conditionSetData", data.iterFunc, "function")
	TMW:ValidateType("iterArgs", "conditionSetData", data.iterArgs, "table")
	
	TMW:ValidateType("useDynamicTab", "conditionSetData", data.useDynamicTab, "boolean;nil")
	TMW:ValidateType("GetTab", "conditionSetData", data.GetTab, "function;nil")
	TMW:ValidateType("tabText", "conditionSetData", data.tabText, "string")
	
	if data.useDynamicTab then
		TMW:ValidateType("ShouldShowTab", "conditionSetData", data.ShouldShowTab, "function")
	end
	
	if not (data.useDynamicTab or data.GetTab) then
		error("You must define either useDynamicTab or GetTab in your Condition Set.", 2)
	end
	
	if ConditionSets[identifier] then
		error(("A condition set is already registered with the identifier %q"):format(identifier), 2)
	end
	
	if TMW.InitializedDatabase then
		error(("ConditionSet %q is being registered too late. It needs to be registered before the database is initialized."):format(self.name or "<??>"), 2)
	end
	
	if data.parentSettingType == "condition" then
		error("You can't nest a condition set implementation within conditions. That will just create a nightmare of recursion that the framework isn't prepared to handle.", 2)
	end
	
	data.identifier = identifier
	
	local defaults = CNDT.Condition_Defaults
	if data.modifiedDefaults then
		defaults = CopyTable(defaults)
		TMW:CopyInPlaceWithMetatable(data.modifiedDefaults, defaults["**"])
		TMW:RegisterCallback("TMW_CNDT_DEFAULTS_NEWVAL", function(event, k, v)
			defaults["**"][k] = v
		end)
	end
	data.parentDefaults[data.settingKey] = defaults
	
	ConditionSets[identifier] = data
	
	if not data.useDynamicTab then
		TMW:RegisterCallback("TMW_CONFIG_TAB_CLICKED", function(event)
			CNDT:SetTabText(identifier)
		end)
	end
end

--- Inherits {{{TMW.Classes.ConditionSetImplementor}}} (Its only method is documented on this page) into the specified class. This should be done when a class implements a ConditionSet.
-- Provides the {{{ConditionSetImplementor:Conditions_GetConstructor()}}} method to that class.
-- @param className [string] The name of a class that ConditionSetImplementor should be inherited into.
-- @usage TMW.CNDT:RegisterConditionSetImplementingClass("Icon")
function CNDT:RegisterConditionSetImplementingClass(className)
	TMW:ValidateType("2 (className)", "CNDT:RegisterConditionSetImplementingClass()", className, "string")
	
	if not TMW.Classes[className] then
		error(("No class named %q exists to embed ConditionSetImplementor into."):format(className), 2)
	end
	
	if next(TMW.Classes[className].instances) then
		error(("Class %q already has instances created! Can't make it into a condition set implementing class."):format(className), 2)
	end
	
	TMW.Classes[className]:Inherit("ConditionSetImplementor")
end


TMW:RegisterCallback("TMW_UPGRADE_PERFORMED", function(event, settingType, upgradeData, ...)
	local parentSettings = ...
	
	for identifier, conditionSetData in pairs(ConditionSets) do
		if conditionSetData.parentSettingType == settingType then
			local isGood = true
			
			if type(parentSettings) ~= "table" then
				TMW:Error("ConditionSet %q is defined as having child settings of '%q', " .. 
				"but that settings type does not provide a settings table as the 4th arg "..
				"(right after upgradeData) to TMW:Upgrade(settingType, upgradeData, ...)", identifier, settingType)
				isGood = false
			end
			
			local conditions = isGood and parentSettings[conditionSetData.settingKey]
			
			if type(conditions) ~= "table" or type(conditions.n) ~= "number" then
				TMW:Error("ConditionSet %q does not have a settingKey that corresponds " .. 
				"to a valid table of condition settings in the settings of its defined parentSettingType", identifier)
				isGood = false
			end
			
			if isGood then
				for conditionID, condition in TMW:InNLengthTable(parentSettings[conditionSetData.settingKey]) do
					TMW:Upgrade("condition", upgradeData, condition, conditionID)
				end
			end
			
		end
	end
	
end)

--[=[
do -- InConditionSettings
	local states = {}
	local function getstate()
		local state = wipe(tremove(states) or {})

		state.currentConditionSetKey, state.currentConditionSet = next(ConditionSets)
		state.currentConditionID = 0
		
		state.extIter, state.extIterState = state.currentConditionSet.iterFunc(unpack(state.currentConditionSet.iterArgs))

		return state
	end

	local function iter(state)
		state.currentConditionID = state.currentConditionID + 1

		if not state.currentConditions or state.currentConditionID > (state.currentConditions.n or #state.currentConditions) then
			local parentTable = state.extIter(state.extIterState)
			
			if not parentTable then
				state.currentConditionSetKey, state.currentConditionSet = next(ConditionSets, state.currentConditionSetKey)
				if state.currentConditionSetKey then
					state.extIter, state.extIterState = state.currentConditionSet.iterFunc(unpack(state.currentConditionSet.iterArgs))
					
					return iter(state)
				else
					tinsert(states, state)
					return
				end
			end

			state.parentTable = parentTable
			state.currentConditions = parentTable[state.currentConditionSet.settingKey]
			state.currentConditionID = 0
			
			return iter(state)
		end
		
		local condition = rawget(state.currentConditions, state.currentConditionID)
		
		if not condition then
			return iter(state)
		end
		
		return condition, state.currentConditionID, state.parentTable -- condition data, conditionID, parentTable
	end

	--- Iterates over all condition settings for all condition sets.
	-- @return An interator that provides (conditionSettings, conditionID, parentTable) for each iteration.
	-- @usage	for conditionSettings, conditionID, parentTable in TMW:InConditionSettings() do
	--		print(conditionSettings, conditionID)
	--		assert(conditionSetting == parentTable[conditionID])
	--	end
	function TMW:InConditionSettings()
		return iter, getstate()
	end
end
]=]
