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
local strlowerCache = TMW.strlowerCache

local tonumber, pairs, wipe, assert =
      tonumber, pairs, wipe, assert
local strfind, strmatch, strtrim, gsub, gmatch, strsplit, abs =
      strfind, strmatch, strtrim, gsub, gmatch, strsplit, abs
local UnitName, UnitClass =
      UnitName, UnitClass

local _, pclass = UnitClass("Player")
local pname = UnitName("player")

local DogTag = LibStub("LibDogTag-3.0")


local NAMES = TMW:NewModule("Names", "AceEvent-3.0")
TMW.NAMES = NAMES
NAMES.ClassColors = {}
NAMES.ClassColoredNameCache = {}

NAMES.CONST = {
	UNIT_LIST = [[
	player;
	mouseover;
	
	target;
	targettarget;
	targettargettarget;
	
	focus;
	focustarget;
	focustargettarget;
	
	pet;
	pettarget;
	pettargettarget;
	
	nameplate1-30;
	
	arena1-5;
	arena1-5target;
	arena1-5targettarget;
	
	boss1-5;
	boss1-5target;
	boss1-5targettarget;
	
	party1-4;
	party1-4pet;
	party1-4target;
	party1-4pettarget;
	party1-4targettarget;
	party1-4pettargettarget;
	
	raid1-40;
	raid1-40target;
	raid1-40targettarget]],
}


function NAMES:OnInitialize()
	
	-- self.unitList used to be just a massive table of a ton of possible units.
	-- Methods that checked unitList would always check every single unit.
	-- Now, it is managed by TMW's unit code, so only units that can possibly exist will be checked.
	self.unitList = TMW:GetUnits(self, self.CONST.UNIT_LIST)

	self:UpdateClassColors()

	if CUSTOM_CLASS_COLORS then
		CUSTOM_CLASS_COLORS:RegisterCallback("UpdateClassColors", self)
	end
	self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
end

function NAMES:UPDATE_BATTLEFIELD_SCORE()
	for i = 1, GetNumBattlefieldScores() do
		local name, _, _, _, _, _, _, _, class = GetBattlefieldScore(i)
		if name and class then -- sometimes this returns nil??
			self.ClassColoredNameCache[name] = self.ClassColors[class] .. name .. "|r"
		end
	end
end

function NAMES:UPDATE_MOUSEOVER_UNIT()
	local name, server = UnitName("mouseover")
	if not name then return end
	if server then
		name = name .. "-" .. server
	end
	local _, class = UnitClass("mouseover")

	if class then
		-- ClientActor type NPCs return nils for UnitClass.
		self.ClassColoredNameCache[name] = self.ClassColors[class] .. name .. "|r"
	end
end

function NAMES:UpdateClassColors()
	-- GLOBALS: CUSTOM_CLASS_COLORS, RAID_CLASS_COLORS
	for class, color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		if color.colorStr then
			self.ClassColors[class] = "|c" .. color.colorStr
		else
			self.ClassColors[class] = "|c" .. TMW:RGBATableToStringWithoutFlags(color)
		end
	end
end


function NAMES:GetUnitIDFromName(name)
	local unitList = self.unitList
	name = strlowerCache[name]
	
	for i = 1, #unitList do
		local id = unitList[i]
		local nameGuess, serverGuess = UnitName(id)
		if (serverGuess and strlowerCache[nameGuess .. "-" .. serverGuess] == name) or strlowerCache[nameGuess] == name then
			return id
		end
	end
end

--[[
function NAMES:GetUnitIDFromGUID(GUID)
	local unitList = NAMES.unitList
	for i = 1, #unitList do
		local id = unitList[i]
		local guidGuess = UnitGUID(id)
		if guidGuess and guidGuess == GUID then
			return id
		end
	end
end

function NAMES:TryToAcquireUnit(input, isName)
	if not input then return end

	local name, server
	if not isName then
		name, server = UnitName(input or "")
	end

	if name then
		-- input was a unitID if name was obtained.
		return input
	else
		-- input was a name.
		name = input

		local unit = NAMES:GetUnitIDFromName(input)
		if unit then
			return unit
		end
	end
end]]

function NAMES:TryToAcquireName(input, shouldColor, noServer)
	if not input then return end

	local name, server = UnitName(input or "")

	if name then	-- input was a unitID if name was obtained.
		if server and server ~= "" and not noServer then
			name = name .. "-" .. server
		end
		if shouldColor then
			local _, class = UnitClass(input)
			local nameColored = (self.ClassColors[class] or "") .. name .. "|r"

			self.ClassColoredNameCache[name] = nameColored

			name = nameColored
		end
	else			-- input was a name.
		name = input

		if shouldColor and self.ClassColoredNameCache[name] then
			return self.ClassColoredNameCache[name]
		end

		local unit = self:GetUnitIDFromName(input)
		if unit then
			if shouldColor then
				local _, class = UnitClass(unit)
				local colorString = self.ClassColors[class]
				local nameColored = name
				if colorString then 
					nameColored = self.ClassColors[class] .. name .. "|r"

					self.ClassColoredNameCache[name] = nameColored
				end
				
				name = nameColored
			else
				name, server = UnitName(unit)
				if server and server ~= "" and not noServer then
					name = name .. "-" .. server
				end
			end
		end
	end

	return name
end

NAMES:UpdateClassColors()

TMW:RegisterCallback("TMW_GLOBAL_UPDATE", function()

	-- This tag is registered with LibDogTag-Unit-3.0's namespace instead of TMW's namespace 
	-- because it requires the event processing that is provided by the Unit namespace.

	-- We re-check for its registration on global update because
	-- if another addon (like ThreatPlates) loads LDT-Unit after TMW,
	-- and if this other addon has a newer version of LDT-Unit than what
	-- was already loaded (by TMW or some other addon),
	-- then it'll wipe out this tag when it ugprades itself.
	if DogTag.Tags.Unit.TMWName then return end
	DogTag:AddTag("Unit", "TMWName", {
		code = function(unit, color, server)
			if NAMES.dogTag_forceUncolored then
				color = false
			end
			
			return NAMES:TryToAcquireName(unit, color, not server)
		end,
		arg = {
			'unit', 'string;undef', 'player',
			'color', 'boolean', true,
			'server', 'boolean', true,
		},
		ret = "string",
		events = "UNIT_NAME_UPDATE#$unit",
		noDoc = true,
	})
end)
DogTag:AddTag("TMW", "Name", {
	alias = "TMWName(unit=unit, color=color, server=server)",
	arg = {
		'unit', 'string;undef', 'player',
		'color', 'string;undef', 'true',
		'server', 'string;undef', 'true',
	},
	ret = "string",
	doc = L["DT_DOC_Name"],
	example = ('[Name] => %q; [Name(color=false)] => %q; [Name(unit="Randomdruid")] => %q; [Name(unit="Randomdruid", server=false)] => %q'):
		format(NAMES:TryToAcquireName("player", true), NAMES:TryToAcquireName("player", false), NAMES.ClassColors.DRUID .. "Randomdruid-AeriePeak|r", NAMES.ClassColors.DRUID .. "Randomdruid|r")
	,
	category = L["MISCELLANEOUS"],
})

DogTag:AddTag("TMW", "StripServer", {
	alias = "gsub(name, '(.*)%-[^|]*(.*)', '%1%2')",
	arg = {
		'name', 'string', '@req',
	},
	ret = "string",
	doc = L["DT_DOC_StripServer"],
	example = ('["%s-%s":StripServer] => %q; [Name:StripServer] => %q'):
		format(UnitFullName("player"), GetRealmName():gsub(" ", ""), UnitFullName("player"), NAMES:TryToAcquireName("player", true))
	,
	category = L["TEXTMANIP"],
})
