local GlobalAddonName, ExRT = ...

local UnitGUID, UnitCombatlogname = UnitGUID, ExRT.F.UnitCombatlogname

local module = ExRT:New("Pets",nil,true)
module.db.petsDB = {}
local petsDB = module.db.petsDB

function module.main:ADDON_LOADED()
	module:RegisterEvents("COMBAT_LOG_EVENT_UNFILTERED",'UNIT_PET')
	
	local n = GetNumGroupMembers() or 0
	local partyType = IsInRaid() and "raid" or "party"	
	for i=1,n do
		module.main:UNIT_PET(partyType..i)
	end
	module.main:UNIT_PET("player")
end

function module.main.COMBAT_LOG_EVENT_UNFILTERED(_,event,_,sourceGUID,sourceName,_,_,destGUID,destName)
	if event == "SPELL_SUMMON" or event == "SPELL_CREATE" then
		petsDB[destGUID] = {sourceGUID,sourceName,destName}
	end
end

function module.main:UNIT_PET(arg)
	local guid = UnitGUID(arg.."pet")
	if guid and not petsDB[guid] then
		petsDB[guid] = {UnitGUID(arg),UnitCombatlogname(arg),UnitCombatlogname(arg.."pet")}
	end
end

ExRT.F.Pets = {}

function ExRT.F.Pets:getOwnerName(petName,thirdDB)
	local db = thirdDB or petsDB
	for i,val in pairs(db) do
		if petName == val[3] then
			return val[2]
		end
	end
end

function ExRT.F.Pets:getOwnerNameByGUID(petGUID,thirdDB)
	local db = thirdDB or petsDB
	for i,val in pairs(db) do
		if petGUID == i then
			return val[2]
		end
	end
end

function ExRT.F.Pets:getOwnerGUID(petGUID,thirdDB)
	local db = thirdDB or petsDB
	for i,val in pairs(db) do
		if petGUID == i then
			return val[1]
		end
	end
end

function ExRT.F.Pets:getOwnerGUIDByName(petName,thirdDB)
	local db = thirdDB or petsDB
	for i,val in pairs(db) do
		if petName == val[3] then
			return val[1]
		end
	end
end

function ExRT.F.Pets:getPetsDB()
	return petsDB
end


function ExRT.F.Pets:getPets(ownerGUID,thirdDB)
	local db = thirdDB or petsDB
	local result = {}
	for petGUID,petData in pairs(db) do
		if petData[1] == ownerGUID then
			result[#result + 1] = petGUID
		end
	end
	return result
end