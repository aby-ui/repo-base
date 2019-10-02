--[[
Name: LibDogTag-3.0
Revision: $Rev$
Author: Cameron Kenneth Knight (ckknight@gmail.com)
Website: http://www.wowace.com/
Description: A library to provide a markup syntax
]]

local MAJOR_VERSION = "LibDogTag-Unit-3.0"
local MINOR_VERSION = 90000 + (tonumber(("20190917021642"):match("%d+")) or 33333333333333)

if MINOR_VERSION > _G.DogTag_Unit_MINOR_VERSION then
	_G.DogTag_Unit_MINOR_VERSION = MINOR_VERSION
end

local select, type, pairs, ipairs, next, setmetatable = select, type, pairs, ipairs, next, setmetatable
local UnitIsUnit, UnitName, UnitGUID, UnitMana, UnitExists =
	  UnitIsUnit, UnitName, UnitGUID, UnitMana, UnitExists

DogTag_Unit_funcs[#DogTag_Unit_funcs+1] = function(DogTag_Unit, DogTag)

local L = DogTag_Unit.L
local newList = DogTag.newList
local del = DogTag.del

local wow_ver = select(4, GetBuildInfo())
local wow_500 = wow_ver >= 50000
local PartyChangedEvent = "PARTY_MEMBERS_CHANGED"
if wow_500 then
	PartyChangedEvent = "GROUP_ROSTER_UPDATE"
end

local frame
if DogTag_Unit.oldLib and DogTag_Unit.oldLib.frame then
	frame = DogTag_Unit.oldLib.frame
	frame:UnregisterAllEvents()
	frame:SetScript("OnEvent", nil)
	frame:SetScript("OnUpdate", nil)
	frame:Show()
else
	frame = CreateFrame("Frame")
end
DogTag_Unit.frame = frame
local normalUnitsWackyDependents = {}

local function fireEventForDependents(event, unit, ...)
	local wackyDependents = normalUnitsWackyDependents[unit]
	if wackyDependents then
		for unit in pairs(wackyDependents) do
			DogTag:FireEvent(event, unit, ...)
		end
	end
end
frame:RegisterAllEvents()
frame:SetScript("OnEvent", function(this, event, unit, ...)
	fireEventForDependents(event, unit, ...)
	if unit == "target" then
	 	if UnitIsUnit("mouseover", "target") then
			DogTag:FireEvent(event, "mouseover", ...)
			fireEventForDependents(event, "mouseover", ...)
		end
		DogTag:FireEvent(event, "playertarget", ...)
		fireEventForDependents(event, "playertarget", ...)
	elseif unit == "pet" then
		DogTag:FireEvent(event, "playerpet", ...)
		fireEventForDependents(event, "playerpet", ...)
	elseif type(unit) == "string" then
	 	local num = unit:match("^partypet(%d)$")
		if num then
			DogTag:FireEvent(event, "party" .. num .. "pet", ...)
			fireEventForDependents(event, "party" .. num .. "pet", ...)
		end
	end
end)

local function GetNameServer(unit)
	local name, realm = UnitName(unit)
	if name then
		if realm and realm ~= "" then
			return name .. "-" .. realm
		else
			return name
		end
	end
end
DogTag_Unit.GetNameServer = GetNameServer

local UnitToLocale = {player = L["Player"], target = L["Target"], pet = L["%s's pet"]:format(L["Player"]), focus = L["Focus-target"], mouseover = L["Mouse-over"]}
setmetatable(UnitToLocale, {__index=function(self, unit)
	if unit:find("pet$") then
		local nonPet = unit:sub(1, -4)
		self[unit] = L["%s's pet"]:format(self[nonPet])
		return self[unit]
	elseif not unit:find("target$") then
		if unit:find("^party%d$") then
			local num = unit:match("^party(%d)$")
			self[unit] = L["Party member #%d"]:format(num)
			return self[unit]
		elseif unit:find("^raid%d%d?$") then
			local num = unit:match("^raid(%d%d?)$")
			self[unit] = L["Raid member #%d"]:format(num)
			return self[unit]
		elseif unit:find("^arena%d$") then
			local num = unit:match("^arena(%d)$")
			self[unit] = L["Arena enemy #%d"]:format(num)
			return self[unit]
		elseif unit:find("^boss%d$") then
			local num = unit:match("^boss(%d)$")
			self[unit] = L["Boss #%d"]:format(num)
			return self[unit]
		elseif unit:find("^partypet%d$") then
			local num = unit:match("^partypet(%d)$")
			self[unit] = UnitToLocale["party" .. num .. "pet"]
			return self[unit]
		elseif unit:find("^raidpet%d%d?$") then
			local num = unit:match("^raidpet(%d%d?)$")
			self[unit] = UnitToLocale["raid" .. num .. "pet"]
			return self[unit]
		elseif unit:find("^arenapet%d$") then
			local num = unit:match("^arenapet(%d)$")
			self[unit] = UnitToLocale["arena" .. num .. "pet"]
			return self[unit]
		end
		self[unit] = unit
		return unit
	end
	local nonTarget = unit:sub(1, -7)
	self[unit] = L["%s's target"]:format(self[nonTarget])
	return self[unit]
end})
DogTag.UnitToLocale = UnitToLocale

-- [""] = true added 8/26 by Cybeloras. TellMeWhen icons (which implement DogTag) don't always check a unit, in which case they fall back on "", not "player".
-- Falling back on "player" (in TellMeWhen) is counter-intuitive. Falling back on "" doesn't seem to cause any issues.
local IsLegitimateUnit = { [""] = true, player = true, target = true, focus = true, pet = true, playerpet = true, mouseover = true, npc = true, NPC = true, vehicle = true }
DogTag.IsLegitimateUnit = IsLegitimateUnit
local IsNormalUnit = { player = true, target = true, focus = true, pet = true, playerpet = true, mouseover = true }
local WACKY_UNITS = { targettarget = true, playertargettarget = true, targettargettarget = true, playertargettargettarget = true, pettarget = true, playerpettarget = true, pettargettarget = true, playerpettargettarget = true }
DogTag.IsNormalUnit = IsNormalUnit
for i = 1, 4 do
	IsLegitimateUnit["party" .. i] = true
	IsLegitimateUnit["partypet" .. i] = true
	IsLegitimateUnit["party" .. i .. "pet"] = true
	IsNormalUnit["party" .. i] = true
	IsNormalUnit["partypet" .. i] = true
	IsNormalUnit["party" .. i .. "pet"] = true
	WACKY_UNITS["party" .. i .. "target"] = true
	WACKY_UNITS["partypet" .. i .. "target"] = true
	WACKY_UNITS["party" .. i .. "pettarget"] = true
	WACKY_UNITS["party" .. i .. "targettarget"] = true
	WACKY_UNITS["partypet" .. i .. "targettarget"] = true
	WACKY_UNITS["party" .. i .. "pettargettarget"] = true
end
for i = 1, 40 do
	IsLegitimateUnit["raid" .. i] = true
	IsNormalUnit["raid" .. i] = true
	IsLegitimateUnit["raidpet" .. i] = true
	IsLegitimateUnit["raid" .. i .. "pet"] = true
	WACKY_UNITS["raid" .. i .. "target"] = true
	WACKY_UNITS["raidpet" .. i] = true
	WACKY_UNITS["raid" .. i .. "pet"] = true
	WACKY_UNITS["raidpet" .. i .. "target"] = true
	WACKY_UNITS["raid" .. i .. "pettarget"] = true
end
for i = 1, MAX_BOSS_FRAMES do
	IsLegitimateUnit["boss" .. i] = true
	IsNormalUnit["boss" .. i] = true
	WACKY_UNITS["boss" .. i .. "target"] = true
	WACKY_UNITS["boss" .. i .. "targettarget"] = true
end
for i = 1, 5 do
	IsLegitimateUnit["arena" .. i] = true
	IsLegitimateUnit["arenapet" .. i] = true
	IsLegitimateUnit["arena" .. i .. "pet"] = true
	IsNormalUnit["arena" .. i] = true
	IsNormalUnit["arenapet" .. i] = true
	IsNormalUnit["arena" .. i .. "pet"] = true
	WACKY_UNITS["arena" .. i .. "target"] = true
	WACKY_UNITS["arenapet" .. i .. "target"] = true
	WACKY_UNITS["arena" .. i .. "pettarget"] = true
	WACKY_UNITS["arena" .. i .. "targettarget"] = true
	WACKY_UNITS["arenapet" .. i .. "targettarget"] = true
	WACKY_UNITS["arena" .. i .. "pettargettarget"] = true
end
setmetatable(IsLegitimateUnit, { __index = function(self, key)
	if type(key) ~= "string" then
		return false
	end
	if key:match("target$") then
		self[key] = self[key:sub(1, -7)]
		return self[key]
	end
	self[key] = false
	return false
end, __call = function(self, key)
	return self[key]
end})

local unitToGUID = {}
local guidToUnits = {}
local wackyUnitToBestUnit = {}

local function getBestUnit(guid)
	if not guid then
		return nil
	end

	local guidToUnits__guid = guidToUnits[guid]
	if not guidToUnits__guid then
		return nil
	end

	for unit in pairs(guidToUnits__guid) do
		if IsNormalUnit[unit] and unit ~= "mouseover" then
			return unit
		end
	end
	return nil
end
local function calculateBestUnit(unit)
	local bestUnit = getBestUnit(UnitGUID(unit))
	local oldBestUnit = wackyUnitToBestUnit[unit]

	if bestUnit == oldBestUnit then
		return
	end

	wackyUnitToBestUnit[unit] = bestUnit
	local normalUnitsWackyDependents__oldBestUnit = normalUnitsWackyDependents[oldBestUnit]
	if normalUnitsWackyDependents__oldBestUnit then
		normalUnitsWackyDependents__oldBestUnit[unit] = nil
		if not next(normalUnitsWackyDependents__oldBestUnit) then
			normalUnitsWackyDependents[oldBestUnit] = del(normalUnitsWackyDependents__oldBestUnit)
		end
	end
	if bestUnit then
		local normalUnitsWackyDependents__bestUnit = normalUnitsWackyDependents[bestUnit]
		if not normalUnitsWackyDependents__bestUnit then
			normalUnitsWackyDependents__bestUnit = newList()
			normalUnitsWackyDependents[bestUnit] = normalUnitsWackyDependents__bestUnit
		end
		normalUnitsWackyDependents__bestUnit[unit] = true
	end
end

local function refreshGUID(unit)
	local guid = UnitGUID(unit)
	local oldGuid = unitToGUID[unit]
	if guid == oldGuid then
		return
	end
	unitToGUID[unit] = guid
	if oldGuid then
		local guidToUnits_oldGuid = guidToUnits[oldGuid]
		if guidToUnits_oldGuid then
			guidToUnits_oldGuid[unit] = nil
			if not next(guidToUnits_oldGuid) then
				guidToUnits[oldGuid] = del(guidToUnits_oldGuid)
			end
		end
	end

	if guid then
		local guidToUnits_guid = guidToUnits[guid]
		if not guidToUnits_guid then
			guidToUnits_guid = newList()
			guidToUnits[guid] = guidToUnits_guid
		end
		guidToUnits_guid[unit] = true
	end

	for wackyUnit in pairs(WACKY_UNITS) do
		if wackyUnitToBestUnit[wackyUnit] == unit or (guid and unitToGUID[wackyUnit] == guid) then
			calculateBestUnit(wackyUnit)
		end
	end
end

local function PARTY_MEMBERS_CHANGED()
	for unit in pairs(IsNormalUnit) do
		local guid = unitToGUID[unit]
		refreshGUID(unit)
		local newGUID = unitToGUID[unit]
		if guid ~= newGUID then
			DogTag:FireEvent("UnitChanged", unit)
		end
	end
end
DogTag:AddEventHandler("Unit", PartyChangedEvent, PARTY_MEMBERS_CHANGED)
DogTag:AddEventHandler("Unit", "PLAYER_ENTERING_WORLD", PARTY_MEMBERS_CHANGED)

PARTY_MEMBERS_CHANGED()
DogTag:AddEventHandler("Unit", "PLAYER_LOGIN", PARTY_MEMBERS_CHANGED)

local function doNothing() end

local function IterateUnitsWithGUID(guid)
	local t = guidToUnits[guid]
	if not t then
		return doNothing
	else
		return pairs(t)
	end
end
DogTag_Unit.IterateUnitsWithGUID = IterateUnitsWithGUID

local function searchForNameTag(ast)
	if type(ast) ~= "table" then
		return false
	end
	if ast[1] == "tag" and ast[2]:lower() == "name" then
		return true
	end
	for i = 2, #ast do
		if searchForNameTag(ast[i]) then
			return true
		end
	end
	if ast.kwarg then
		for k, v in pairs(ast.kwarg) do
			if searchForNameTag(v) then
				return true
			end
		end
	end
	return false
end

DogTag:AddCompilationStep("Unit", "start", function(t, ast, kwargTypes, extraKwargs)
	if kwargTypes["unit"] then
		t[#t+1] = [=[if not DogTag.IsLegitimateUnit[]=]
		t[#t+1] = extraKwargs["unit"][1]
		t[#t+1] = [=[] then]=]
		t[#t+1] = "\n"
		t[#t+1] = [=[return ("Bad unit: %q"):format(]=]
		t[#t+1] = extraKwargs["unit"][1]
		t[#t+1] = [=[ or tostring(]=]
		t[#t+1] = extraKwargs["unit"][1]
		t[#t+1] = [=[)), nil;]=]
		t[#t+1] = "\n"
		t[#t+1] = [=[end;]=]
		t[#t+1] = "\n"


		-- I really don't see this point to this.
		-- It just prevents users from using custom tags that override the unit specified by the kwargs passed to AddFontString.
		-- So I commented it out.
		t[#t+1] = [=[if ]=]
		t[#t+1] = extraKwargs["unit"][1]
		t[#t+1] = [=[ ~= "player" and not UnitExists(]=]
		t[#t+1] = extraKwargs["unit"][1]
		t[#t+1] = [=[) then]=]
		t[#t+1] = "\n"
		t[#t+1] = [=[return ]=]
		if searchForNameTag(ast) then
			t[#t+1] = [=[DogTag.UnitToLocale[]=]
			t[#t+1] = extraKwargs["unit"][1]
			t[#t+1] = [=[]]=]
		else
			t[#t+1] = [=[nil]=]
		end
		t[#t+1] = [=[, nil;]=]
		t[#t+1] = "\n"
		t[#t+1] = [=[end;]=]


		t[#t+1] = "\n"
	end
end)

DogTag:AddCompilationStep("Unit", "tag", function(ast, t, tag, tagData, kwargs, extraKwargs, compiledKwargs)
	if compiledKwargs["unit"] and kwargs["unit"] ~= extraKwargs then
		if type(kwargs["unit"]) ~= "table" then
		 	if not IsLegitimateUnit[kwargs["unit"]] then
				t[#t+1] = [=[do]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[return ]=]
				t[#t+1] = [=[("Bad unit: %q"):format(tostring(]=]
				t[#t+1] = compiledKwargs["unit"][1]
				t[#t+1] = [=[));]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[end;]=]
				t[#t+1] = "\n"
			end
		else
			t[#t+1] = [=[if ]=]
			t[#t+1] = compiledKwargs["unit"][1]
			t[#t+1] = [=[ and not DogTag.IsLegitimateUnit[]=]
			t[#t+1] = compiledKwargs["unit"][1]
			t[#t+1] = [=[] then]=]
			t[#t+1] = "\n"
			t[#t+1] = [=[return ]=]
			t[#t+1] = [=[("Bad unit: %q"):format(tostring(]=]
			t[#t+1] = compiledKwargs["unit"][1]
			t[#t+1] = [=[));]=]
			t[#t+1] = "\n"
			t[#t+1] = [=[end;]=]
			t[#t+1] = "\n"
		end
	end
	if tag == "IsUnit" then
		if type(kwargs["other"]) ~= "table" then
		 	if not IsLegitimateUnit[kwargs["other"]] then
				t[#t+1] = [=[do]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[return ]=]
				t[#t+1] = [=[("Bad unit: %q"):format(tostring(]=]
				t[#t+1] = compiledKwargs["other"][1]
				t[#t+1] = [=[));]=]
				t[#t+1] = "\n"
				t[#t+1] = [=[end;]=]
				t[#t+1] = "\n"
			end
		else
			t[#t+1] = [=[if not DogTag.IsLegitimateUnit[]=]
			t[#t+1] = compiledKwargs["other"][1]
			t[#t+1] = [=[] then]=]
			t[#t+1] = "\n"
			t[#t+1] = [=[return ]=]
			t[#t+1] = [=[("Bad unit: %q"):format(tostring(]=]
			t[#t+1] = compiledKwargs["other"][1]
			t[#t+1] = [=[));]=]
			t[#t+1] = "\n"
			t[#t+1] = [=[end;]=]
			t[#t+1] = "\n"
		end
	end
end)

DogTag:AddCompilationStep("Unit", "tagevents", function(ast, t, u, tag, tagData, kwargs, extraKwargs, compiledKwargs, events, returns)
	if compiledKwargs["unit"] and kwargs["unit"] ~= extraKwargs and kwargs["unit"] ~= "player" then
		t[#t+1] = [=[if ]=]
		t[#t+1] = compiledKwargs["unit"][1]
		t[#t+1] = [=[ and UnitExists(]=]
		t[#t+1] = compiledKwargs["unit"][1]
		t[#t+1] = [=[) then]=]
		t[#t+1] = "\n"
		u[#u+1] = [=[end;]=]
		u[#u+1] = "\n"
		if not returns["boolean"] then
			returns["nil"] = true
		end
	end
end)

DogTag:AddEventHandler("Unit", "PLAYER_TARGET_CHANGED", function(event, ...)
	refreshGUID("target")
	DogTag:FireEvent("UnitChanged", "target")
	DogTag:FireEvent("UnitChanged", "playertarget")
end)

DogTag:AddEventHandler("Unit", "PLAYER_FOCUS_CHANGED", function(event, ...)
	refreshGUID("focus")
	DogTag:FireEvent("UnitChanged", "focus")
end)

DogTag:AddEventHandler("Unit", "UNIT_TARGET", function(event, unit)
	DogTag:FireEvent("UnitChanged", unit .. "target")
end)

DogTag:AddEventHandler("Unit", "UNIT_TARGETABLE_CHANGED", function(event, unit)
	refreshGUID(unit)
	DogTag:FireEvent("UnitChanged", unit)
end)

DogTag:AddEventHandler("Unit", "UNIT_PET", function(event, unit)
	if unit == "player" then unit = "" end
	local unit_pet = unit .. "pet"
	refreshGUID(unit_pet)
	DogTag:FireEvent("UnitChanged", unit_pet)
end)

DogTag:AddEventHandler("Unit", "UPDATE_MOUSEOVER_UNIT", function(event, ...)
	refreshGUID("mouseover")
	DogTag:FireEvent("UnitChanged", "mouseover")
end)

DogTag:AddEventHandler("Unit", "INSTANCE_ENCOUNTER_ENGAGE_UNIT", function(event, ...)
	for i = 1, MAX_BOSS_FRAMES do
		refreshGUID("boss"..i)
		DogTag:FireEvent("UnitChanged", "boss"..i)
	end
end)

local fsToKwargs = DogTag.fsToKwargs
local fsToNSList = DogTag.fsToNSList
local fsNeedUpdate = DogTag.fsNeedUpdate
local fsNeedQuickUpdate = DogTag.fsNeedQuickUpdate
local unpackNamespaceList = DogTag.unpackNamespaceList

local nsListHasUnit = setmetatable({}, { __index = function(self, key)
	for _, ns in ipairs(unpackNamespaceList[key]) do
		if ns == "Unit" then
			self[key] = true
			return true
		end
	end
	self[key] = false
	return false
end })

local checkYield = DogTag.checkYield
if not checkYield then
	-- If LibDogTag doesn't include checkYield (old version)
	-- Then just make checkYield an empty function to prevent errors.
	checkYield = function() end
end

local nextRefreshGUIDsTime = 0
DogTag:AddTimerHandler("Unit", function(num, currentTime)
	if nextRefreshGUIDsTime > currentTime then
		return
	end
	nextRefreshGUIDsTime = currentTime + 15

	PARTY_MEMBERS_CHANGED()
end, 1)

local nextUpdateWackyUnitsTime = 0
DogTag:AddTimerHandler("Unit", function(num, currentTime)
	local mouseoverGUID = UnitGUID("mouseover")
	if mouseoverGUID ~= unitToGUID["mouseover"] then
		unitToGUID["mouseover"] = mouseoverGUID
		DogTag:FireEvent("UnitChanged", "mouseover")
	end
	if currentTime >= nextUpdateWackyUnitsTime then
		for unit in pairs(WACKY_UNITS) do
			local oldGUID = unitToGUID[unit]
			refreshGUID(unit)
			local newGUID = unitToGUID[unit]
			if oldGUID ~= newGUID then
				DogTag:FireEvent("UnitChanged", unit)

				-- This loop is where things get hung up all the time,
				-- so we should check for a yield right here.
				checkYield()
			end
		end
		nextUpdateWackyUnitsTime = currentTime + 0.5
		DogTag:FireEvent("UpdateWackyUnits")
		for fs, nsList in pairs(fsToNSList) do
			if nsListHasUnit[nsList] then
				local kwargs = fsToKwargs[fs]
				local unit = kwargs and kwargs["unit"]
				if unit and not IsNormalUnit[unit] and not wackyUnitToBestUnit[unit] then
					fsNeedUpdate[fs] = true
				end
			end
		end
	end
end)

DogTag:AddTimerHandler("Unit", function(num, currentTime)
	local exists = not not UnitExists("mouseover")
	if not exists then
		for fs, nsList in pairs(fsToNSList) do
			if nsListHasUnit[nsList] and not fs.__DT_dontcancelupdatesforMO then
				local kwargs = fsToKwargs[fs]
				if kwargs and kwargs["unit"] == "mouseover" then
					fsNeedUpdate[fs] = nil
					fsNeedQuickUpdate[fs] = nil
				end
			end
		end
	end
end, 9)

DogTag:AddCompilationStep("Unit", "tagevents", function(ast, t, u, tag, tagData, kwargs, extraKwargs, compiledKwargs, events, returns)
	if compiledKwargs["unit"] then
		events["UnitChanged#$unit"] = true
		events[PartyChangedEvent] = true
		events["PLAYER_ENTERING_WORLD"] = true
		local kwargs_unit = kwargs["unit"]
		if (type(kwargs_unit) ~= "table" or kwargs_unit[1] ~= "kwarg" or kwargs_unit[2] ~= "unit") and kwargs_unit ~= extraKwargs and (type(kwargs_unit) ~= "string" or not IsNormalUnit[kwargs_unit]) then
			events["UpdateWackyUnits"] = true
		end
	end
end)

end
