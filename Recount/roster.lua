local Recount = _G.Recount

local revision = tonumber(string.sub("$Revision: 1309 $", 12, -3))
if Recount.Version < revision then
	Recount.Version = revision
end

local type = type

local GetNumPartyMembers = GetNumPartyMembers or GetNumSubgroupMembers
local GetNumRaidMembers = GetNumRaidMembers or GetNumGroupMembers
local IsInRaid = IsInRaid
local UnitAffectingCombat = UnitAffectingCombat
local UnitExists = UnitExists
local UnitGUID = UnitGUID
local UnitName = UnitName

function Recount:CheckPartyCombatWithPets()
	if IsInRaid() and GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers() do
			if UnitAffectingCombat("raid"..i) then
				return true
			end
			if UnitAffectingCombat("raidpet"..i) then
				return true
			end
		end
	end
	if not IsInRaid() and GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers() do
			if UnitAffectingCombat("party"..i) then
				return true
			end
			if UnitAffectingCombat("partypet"..i) then
				return true
			end
		end
	end
	if UnitAffectingCombat("player") then
		return true
	end
	return false
end

function Recount:GetUnitIDFromName(name)
	if type(name) ~= "string" then
		return nil
	end -- Bandaid for raid frame issues
	local realm = name:match("-(.-)")
	--[[if realm then
		name = name:match("(.-)-") -- Strip the realm part for this function
	end]] -- Resike: This is bad for some pet type detection
	if UnitExists(name) then -- Elsia: Speed boost, yay
		return name
	else
		local lname = name:lower()
		if lname:sub(1, 3) == "pet" or lname:sub(1, 4) == "raid" or lname:sub(1, 5) == "party" or lname:sub(1, 6) == "player" or lname:sub(1, 6) == "target" then
			return Recount:GetPetPrefixUnit(name, realm)
		end
		return nil
	end
end

function Recount:GetPetPrefixUnit(name, realm)
	if Recount.PlayerName == name and not realm then
		return "player"
	end
	if IsInRaid() and GetNumRaidMembers() > 0 then
		for i = 1, GetNumRaidMembers() do
			local unitname, unitrealm = UnitName("raid"..i)
			if unitname == name and unitrealm == realm then
				return "raid"..i
			end
		end
	elseif GetNumPartyMembers() > 0 then
		for i = 1, GetNumPartyMembers() do
			local unitname, unitrealm = UnitName("party"..i)
			if unitname == name and unitrealm == realm then
				return "party"..i
			end
		end
	end
	return nil
end

function Recount:FindTargetedUnit(name)
	if UnitExists(name) then
		return name
	end
	for i = 1, GetNumRaidMembers() do
		if UnitName("raid"..i) and name == UnitName("raid"..i.."target") then
			return "raid"..i.."target"
		elseif UnitName("raidpet"..i.."target") and name == UnitName("raidpet"..i.."target") then
			return "raidpet"..i.."target"
		end
	end
	for i = 1, GetNumPartyMembers() do
		if UnitName("party"..i) and name == UnitName("party"..i.."target") then
			return "party"..i.."target"
		elseif UnitName("partypet"..i) and name == UnitName("partypet"..i.."target") then
			return "partypet"..i.."target"
		end
	end
	if name == UnitName("playertarget") then
		return "playertarget"
	elseif name == UnitName("focus") then
		return "focus"
	end
end

function Recount:FindOwnerPetFromGUID(petName, petGUID)
	local ownerName
	local ownerGUID
	local ownerRealm
	for i = 1, GetNumRaidMembers() do
		if petGUID == UnitGUID("raidpet"..i) then
			ownerName, ownerRealm = UnitName("raid"..i)
			if ownerRealm then
				ownerName = ownerName.."-"..ownerRealm
			end
			ownerGUID = UnitGUID("raid"..i)
			return ownerName, ownerGUID
		end
	end
	for i = 1, GetNumPartyMembers() do
		if petGUID == UnitGUID("partypet"..i) then
			ownerName, ownerRealm = UnitName("party"..i)
			if ownerRealm then
				ownerName = ownerName.."-"..ownerRealm
			end
			ownerGUID = UnitGUID("party"..i)
			return ownerName, ownerGUID
		end
	end
	if petGUID == UnitGUID("pet") then
		ownerName = UnitName("player")
		ownerGUID = UnitGUID("player")
		return ownerName, ownerGUID
	end
	return nil, nil
end
