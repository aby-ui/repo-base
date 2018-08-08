--[[
	This module's purpose is to assign petIDs to teams and queue where a petID has
	been reassigned (by the server, by caging and relearning a pet, etc) or when a
	missing pet is learned (convert a speciesID placeholder to a live petID).

	UpdateSanctuary should be called after an UpdateOwned during the UpdateUI.

	When a pet is caged, or a total petID reassignment happens by the server, the pet will
	still exist but with a new petID. This module will store enough stats from a petID
	(level, maxHealth, power, speed, rarity) to find its new petID when needed.

	ONLY pets that are in a team or in the leveling queue are stored here.

	[petID] = {count,exists,speciesID,level,maxHealth,power,speed,rarity}
		count is the number of instances this petID is used; when it reaches 0 it's removed.
		exists is set in UpdateOwned and is true when the petID is known to exist.
]]

local _,L = ...
local rematch = Rematch
local settings, saved
local sanctuary

rematch.sanctuaryCandidates = {} -- list of petID candidates for potential replacement

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved
	sanctuary = settings.Sanctuary
	-- convert 3.x sanctuary to new format
	if settings.SanctuaryPets then
		for _,pet in ipairs(settings.SanctuaryPets) do
			local petID,speciesID,level,maxHealth,power,speed = strsplit(",",pet)
			if petID:len()>0 then
				-- old sanctuary didn't include rarity; rarity will be pulled on next UpdateSanctuary
				settings.Sanctuary[petID] = {0,nil,tonumber(speciesID),tonumber(level),tonumber(maxHealth),tonumber(power),tonumber(speed),0}
			end
		end
		settings.SanctuaryPets = nil -- remove old sanctuary
	end
end)

-- adds a petID to the sanctuary; if update is true then it will update its stats if
-- it already existed.
function rematch:AddToSanctuary(petID,update)
	if petID and petID~=0 then
		local existed = true
		if type(sanctuary[petID])~="table" then
			if rematch:GetIDType(petID)=="pet" then
				local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
				local _, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(petID)
				sanctuary[petID] = {0,true,speciesID,level,maxHealth,power,speed,rarity}
			else
				sanctuary[petID] = {0} -- this petID has no stats (likely a speciesiD)
			end
			existed = false
		end
		sanctuary[petID][1] = sanctuary[petID][1] + 1 -- increment occurance of petID
		if existed and update then
			rematch:UpdatePetInSanctuary(petID)
		end
	end
end

-- this updates the stats of a single petID in the sanctuary
-- called during AddToSanctuary if a pet already existed and in UpdateUI to update
-- loadout and summoned pets if they exist.
-- if level has a value, then no need to re-pull value
function rematch:UpdatePetInSanctuary(petID)
   local petInfo = rematch.petInfo:Fetch(petID)
   if petInfo.idType=="pet" and sanctuary[petID] and petInfo.level then
      sanctuary[petID][4] = petInfo.level
      sanctuary[petID][5] = petInfo.maxHealth
      sanctuary[petID][6] = petInfo.power
      sanctuary[petID][7] = petInfo.speed
      sanctuary[petID][8] = petInfo.rarity
	end
end

-- this is safe to call anytime, but should be called after an UpdateOwned() which
-- flags whether a petID is known to exist
function rematch:UpdateSanctuary(force)
	if rematch.isLoaded and (rematch.sanctuaryNeedsUpdated or force) and not settings.DebugNoSanctuary then
		-- reset counters for all pets
		for petID,info in pairs(sanctuary) do
			sanctuary[petID][1] = 0 -- team counter
		end
		-- go through all teams and add any un-sanctuary'ed pet
		for key,team in pairs(saved) do
			for i=1,3 do
				rematch:AddToSanctuary(team[i][1])
			end
		end
		-- go through the leveling queue and add any un-sanctuary'ed pet
		for _,petID in pairs(settings.LevelingQueue) do
			rematch:AddToSanctuary(petID)
		end
		-- this removes any pets that no longer belong to a team or are in the queue
		for petID,info in pairs(sanctuary) do
			if sanctuary[petID][1]==0 then
				sanctuary[petID] = nil
			end
		end
		-- now go through and see if any invalid petIDs need found
		for petID,info in pairs(sanctuary) do
			if not info[2] then -- if this pet is known not to exist
				local idType = rematch:GetIDType(petID)
				if idType=="pet" then
					local _,_,level = C_PetJournal.GetPetInfoByPetID(petID)
					if not level then -- confirm petID doesn't exist before finding a replacement
						rematch:FindReplacementPet(petID,sanctuary[petID][3])
					end
				elseif idType=="species" then -- a numeric petID that's not 0 is a species with no owned versions
					rematch:FindReplacementPet(nil,petID)
				end
			else -- if pet exists, it's (very likely) a valid petID; update its stats
				rematch:UpdatePetInSanctuary(petID)
			end
		end
		rematch.sanctuaryNeedsUpdated = nil
	end
end

-- in the event of a petID reassignment, or when learning a new speciesID, this will
-- replace all instances of petID (or speciesID if petID not given) in teams
-- when petID has a value, only exact matches will be considered
-- when petID has no value, any of the found speciesID will be considered
function rematch:FindReplacementPet(petID,speciesID)

	local count = type(speciesID)=="number" and C_PetJournal.GetNumCollectedInfo(speciesID)

	if not count or count==0 then
		return -- pet still not known, can leave
	end

	local sanctuaryPet = petID and sanctuary[petID]
	local candidates = rematch.sanctuaryCandidates
	wipe(candidates)

	-- if only one version of this speciesID exists, our work is easy
	if count==1 then
		local _,candidatePetID = C_PetJournal.FindPetIDByName((select(1,C_PetJournal.GetPetInfoBySpeciesID(speciesID))))
		if not petID then -- if no petID was given, we're looking to replace an as-yet unlearned species
			tinsert(candidates,candidatePetID)
		else -- a petID was given, we want to replace only with a pet that matches stats
			local _,_,level = C_PetJournal.GetPetInfoByPetID(candidatePetID)
			local _,maxHealth,power,speed,rarity = C_PetJournal.GetPetStats(candidatePetID)
			if level==sanctuaryPet[4] and maxHealth==sanctuaryPet[5] and power==sanctuaryPet[6] and speed==sanctuaryPet[7] and rarity==sanctuaryPet[8] then
				tinsert(candidates,candidatePetID)
			end
		end
	else
		-- if there are more than 1 copies of the species, we'll need to dig through the roster for the best
		for candidatePetID in rematch.Roster:AllOwnedPets() do
			local candidateSpeciesID,_,level = C_PetJournal.GetPetInfoByPetID(candidatePetID)
			if candidateSpeciesID==speciesID then -- we found one of the intended species
				if petID then -- if petID passed, we're looking for a precise version of this pet
					if level==sanctuaryPet[4] then
						local _, maxHealth, power, speed, rarity = C_PetJournal.GetPetStats(candidatePetID)
						if maxHealth==sanctuaryPet[5] and power==sanctuaryPet[6] and speed==sanctuaryPet[7] and rarity==sanctuaryPet[8] then
							tinsert(candidates,candidatePetID)
						end
					end
				else -- no petID was passed, we want to find/replace the best version of the species just learned
					tinsert(candidates,candidatePetID)
				end
				-- decrement the count to stop looking once we found all copies of the speciesID
				count = count-1
				if count==0 then
					break
				end
			end
		end
	end

	if #candidates==0 then
		return -- no candidates found :(
	end

	-- at this point at least one candidate was found to replace this petID

	local replaced -- becomes true if any pet was replaced

	-- check teams
	for key,team in pairs(saved) do
		for i=1,3 do
			if team[i][1]==(petID or speciesID) then
				if rematch:ReplaceCandidateInTeam(key,petID or speciesID) then
					replaced = true
				end
			end
		end
	end

	-- a pet was replaced, update the UI
	if replaced and (rematch.Frame:IsVisible() or rematch.Journal:IsVisible()) then
		-- in the case of server petID reassignment, this can happen hundreds of times!
		-- wait until they're all done before doing an UpdateUI
		rematch:StartTimer("UpdateUI",0.1,rematch.UpdateUI)
	end

end

function rematch:ReplaceCandidateInTeam(key,petID)
	local candidates = rematch.sanctuaryCandidates
	local team = saved[key]
	for i=1,#candidates do
		-- check to make sure candidate is not already in a team before replacing
		local found
		for j=1,3 do
			if team[j][1]==candidates[i] then
				found = true
			end
		end
		-- this candidate was not found already in the team, safe to replace
		if not found then
			for j=1,3 do
				if team[j][1]==petID then
					team[j][1] = candidates[i]
					return true
				end
			end
		end
	end
end

-- when all of the above fails to find a replacement, pet loading will load
-- a temporary replacement: the highest level of a speciesID it can find
-- the optional teammates are other petIDs on a team; if passed the temporary petID
-- will not be one of these
function rematch:FindTemporaryPetID(speciesID,teammate1,teammate2,teammate3)
   if speciesID then
		local count = C_PetJournal.GetNumCollectedInfo(speciesID)
		if not count then
			return -- this speciesID probably isn't valid
		elseif count==1 then -- only one of this species, return sole petID owned
			return select(2,C_PetJournal.FindPetIDByName((C_PetJournal.GetPetInfoBySpeciesID(speciesID))))
		elseif count>1 then
			-- there's more than one of this speciesID, go through all owned pets
			local bestPetID
			local bestLevel = 0
			for candidatePetID in rematch.Roster:AllOwnedPets() do
				local candidateSpeciesID,_,level = C_PetJournal.GetPetInfoByPetID(candidatePetID)
				if candidateSpeciesID==speciesID and level>bestLevel and candidatePetID~=teammate1 and candidatePetID~=teammate2 and candidatePetID~=teammate3 then
					bestPetID = candidatePetID
					bestLevel = level
					count = count-1
					if count==0 then
						break
					end
				end
			end
			return bestPetID
		end
	end
end

