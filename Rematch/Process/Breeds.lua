local _,L = ...
local rematch = Rematch
local source -- will contain the breedSource

--[[ breeds are pulled from the first of these addons encountered:

	1. BattlePetBreedID
	2. PetTracker_Breeds
	3. LibPetBreedInfo-1.0
]]



-- returns the addon that will provide breed data
function rematch:FindBreedSource()
	local addon
	for _,name in pairs({"BattlePetBreedID","PetTracker_Breeds","LibPetBreedInfo-1.0"}) do
		if not addon and IsAddOnLoaded(name) then
			-- make sure PetTracker is not the Legion-version one
			if name~="PetTracker_Breeds" or GetAddOnMetadata("PetTracker_Breeds","Version")~="7.1.4" then
				addon = name
			end
		end
	end
	if not addon then -- one of the sources is not loaded, try loading LibPetBreedInfo separately
		LoadAddOn("LibPetBreedInfo-1.0")
		if LibStub then
			for lib in LibStub:IterateLibraries() do
				if lib=="LibPetBreedInfo-1.0" then
					rematch.breedLib = LibStub("LibPetBreedInfo-1.0")
					-- ensure LibPetBreedInfo is working enough to return a value
					if rematch.breedLib then
						addon = lib
					end
					break
				end
			end
		end
	end
	rematch:GatherBreedNames() -- while here, gather names of the breeds indexed by breed filter
	source = addon
	rematch.breedSource = source
end

-- called not only by the FindBreedSource function, but also later if BPBID is used and BPBID_Options.format changes
function rematch:GatherBreedNames()
	wipe(rematch.breedNames)
	wipe(rematch.breedLookup)
	if source=="BattlePetBreedID" then
		if BPBID_Options.format==1 then
			rematch.breedNames = {3,4,5,6,7,8,9,10,11,12}
		elseif BPBID_Options.format==2 then
			rematch.breedNames = {"3/13","4/14","5/15","6/16","7/17","8/18","9/19","10/20","11/21","12/22"}
		elseif BPBID_Options.format==3 then
			rematch.breedNames = {"B/B","P/P","S/S","H/H","H/P","P/S","H/S","P/B","S/B","H/B"}
		end
		-- since BPBID doesn't return a number, make a lookup to convert its names to a filter index
		for index,breedName in ipairs(rematch.breedNames) do
			rematch.breedLookup[breedName] = index
		end
		rematch.BPBIDFormat = BPBID_Options.format
	elseif source=="PetTracker_Breeds" then
		-- PetTracker returns a number, so we can just use breed minus 2 to compare to filter settings
		for i=3,12 do
			tinsert(rematch.breedNames,format("%s %s",PetTracker:GetBreedIcon(i,.95),PetTracker:GetBreedName(i)))
		end
	elseif source=="LibPetBreedInfo-1.0" then
		rematch.breedNames = {"B/B","P/P","S/S","H/H","H/P","P/S","H/S","P/B","S/B","H/B"}
	end
end

-- returns the breed of the petID
function rematch:GetBreedByPetID(petID)
	if rematch:GetIDType(petID)=="pet" then
		if source=="BattlePetBreedID" then
			return GetBreedID_Journal(petID) or ""
		elseif source=="PetTracker_Breeds" then
			local icon = PetTracker:GetBreedIcon((PetTracker.Journal:GetBreed(petID)),.95)
			if not icon or icon=="" then
				icon = "NEW"
			end
			return icon
		elseif source=="LibPetBreedInfo-1.0" then
			return rematch.breedLib:GetBreedName(rematch.breedLib:GetBreedByPetID(petID)) or "NEW"
		end
	end
	return ""
end

-- returns the numerical breed (3=B/B, 4=P/P, etc), or nil if no breed; used for filtering
function rematch:GetBreedIndex(petID)
	if rematch:GetIDType(petID)=="pet" then
		if source=="BattlePetBreedID" then
			if rematch.BPBIDFormat~=BPBID_Options.format or #rematch.breedNames==0 then
				rematch:GatherBreedNames()
			end
			local breed = rematch.breedLookup[GetBreedID_Journal(petID)]
			if breed then -- if breed was found in lookup table
				return breed+2 -- then return its index+2 to get proper breed
			end
		elseif source=="PetTracker_Breeds" then
			return PetTracker.Journal:GetBreed(petID)
		elseif source=="LibPetBreedInfo-1.0" then
			return (rematch.breedLib:GetBreedByPetID(petID))
		end
	end
end

-- returns the breed of a pet in a battle UI owner,index slot
function rematch:GetBreedByBattleSlot(petOwner,petIndex)
	if petOwner==1 then -- if petOwner is ally (player) return breed of the loaded petID
		return rematch:GetBreedByPetID(C_PetJournal.GetPetLoadOutInfo(petIndex))
	elseif source=="BattlePetBreedID" then
		return GetBreedID_Battle(rematch.Battle:GetBattleUnitParent(petOwner,petIndex))
	elseif source=="PetTracker_Breeds" then
		local speciesID = C_PetBattles.GetPetSpeciesID(petOwner,petIndex)
		local level = C_PetBattles.GetLevel(petOwner,petIndex)
		local rarity = C_PetBattles.GetBreedQuality(petOwner,petIndex)
		local health = C_PetBattles.GetMaxHealth(petOwner,petIndex)
		local power = C_PetBattles.GetPower(petOwner,petIndex)
		local speed = C_PetBattles.GetSpeed(petOwner,petIndex)
		return PetTracker:GetBreedIcon(PetTracker.Predict:Breed(speciesID,level,rarity,health,power,speed),0.95)
	elseif source=="LibPetBreedInfo-1.0" then
		return rematch.breedLib:GetBreedName(rematch.breedLib:GetBreedByPetBattleSlot(petOwner,petIndex))
	end
end

function rematch:GetBreedByStats(speciesID,level,rarity,health,power,speed)
	-- for BPBID lifting the breed from the tooltip it generates since it doesn't expose its calculate function :(
	if source=="BattlePetBreedID" then
		local breedID = BPBID_Internal.CalculateBreedID(speciesID,rarity,level,health,power,speed,false,false)
		if type(breedID)=="number" then
			return rematch.breedNames[breedID-2]
		else
			return breedID
		end
	elseif source=="PetTracker_Breeds" then
		return PetTracker:GetBreedIcon(PetTracker.Predict:Breed(speciesID,level,rarity,health,power,speed),0.95)
	elseif source=="LibPetBreedInfo-1.0" then
		return rematch.breedLib:GetBreedName(rematch.breedLib:GetBreedByStats(speciesID,level,rarity,health,power,speed)) or "NEW"
	end
end
