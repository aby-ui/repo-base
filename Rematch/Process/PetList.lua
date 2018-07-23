-- This is an extension to Roster and only deals with populating the filtered list of pets.

-- Roster.lua handles the collection of pets and created API to get information about pets.
-- Filters.lua handles the definition of filters and API to manipulate those filters.
-- PetList.lua applies the filters to the roster to form the filtered pet list to display.

local _,L = ...
local rematch = Rematch
local roster = Rematch.Roster
local settings

local GetFilter = roster.GetFilter -- since this is called so often, made local for speed

roster.petList = {} -- filtered list of petIDs/speciesIDs to list in the pet panel

local activeFilters = {} -- list of filter groups that are active
-- this is the order that filter groups are processed (simplest to most complex)
local priority = { "Favorite", "Collected", "Types", "Rarity", "Sources", "Tough",
						 "Level", "Other", "Breed", "Strong", "Similar", "Moveset", "Script" }

local petInfo = {} -- where the various stats of a pet are stored (petID, speciesID, etc)
local filterFuncs = {} -- each filter group has a filterFuncs entry to process the petInfo

local sortReference = { "name", "level", "rarity", "petType", "maxHealth", "power", "speed" }
local sortStatsTable -- will be the SortStats tempTable
local sortFavoritesTable -- will be the Favorites tempTable (improves speed 57% over using PetIsFavorite)
local sortRelevanceTable -- will be the SearchRelevance tempTable
local sortLowToHigh -- will be whether sort lists in ascending or descending stat order
local sortByNickname -- will be whether settings.SortByNickname is enabled

rematch:InitModule(function()
	settings = RematchSettings
	rematch:RegisterTempTable("SearchSpecies") -- cache for searching text in a species
	rematch:RegisterTempTable("SearchAbilities") -- cache for searching text in an ability
	rematch:RegisterTempTable("SortStats") -- table of the primary sort stat of each pet
	rematch:RegisterTempTable("Favorites") -- table containing favorite petIDs for sort optimization
	rematch:RegisterTempTable("SearchRelevance") -- table of relevance values from search results
end)

-- UpdatePetList is the only function called outside this module.
-- It populates roster.petList with the sorted list of pets to display.
function roster:UpdatePetList()

	if not roster.petListNeedsUpdated then
		return -- don't do anything if list doesn't need updated
	end
	roster.petListNeedsUpdated = nil

	-- start with a clean slate
	wipe(roster.petList)

	-- setup which filters are going to run
	wipe(activeFilters)
	for i=1,#priority do
		local group = priority[i]
		if roster:IsFilterUsed(group) then
			tinsert(activeFilters,group)
		end
	end

	-- special cases to run before pulling data
	-- for CurrentZone capture and desensitize the user's current zone
	roster.currentZone = GetFilter(self,"Other","CurrentZone") and rematch:DesensitizeText(GetRealZoneText() or "") or nil
	-- if script filter used, setup its environment
	if GetFilter(self,"Script","code") then
		rematch:SetupScriptEnvironment()
	end

	-- setup sort temp tables to hold primary sort stat
	sortStatsTable = rematch:GetTempTable("SortStats")
	sortFavoritesTable = rematch:GetTempTable("Favorites")
	sortRelevanceTable = rematch:GetTempTable("SearchRelevance")
	sortByNickname = settings.SortByNickname
	local favoritesFirst = settings.Sort.FavoritesFirst -- not used outside this scope; ok to be local here

	-- now go through each petID and add ones that should be listed to petList
	for petID in roster:AllPets() do
		if roster:FilterPetByPetID(petID) then -- if pet is to be added
			if favoritesFirst and petInfo.isFavorite then
				sortFavoritesTable[petID] = true -- note favorites
			end
			sortStatsTable[petID] = roster:GetSortStat()
			tinsert(roster.petList,petID)
		end
	end

	-- here all pets to be listed are gathered. now sort them
	local order = settings.Sort.Order
	local reversed = settings.Sort.Reverse
	if (order==1 or order==4) then -- sort by name and type are ascending
		sortLowToHigh = not reversed
	else -- sort by level, rarity, health, power and speed is descending
		sortLowToHigh = reversed
	end
	table.sort(roster.petList,roster.SortPets)

	-- once in a great while there may be wrapped pets; not handling them in
	-- main filters/sorts because of how infrequenlty it will happen
	local numWrapped = C_PetJournal.GetNumPetsNeedingFanfare()
	if numWrapped>0 then
		local numRelocated = 0
		while numWrapped>0 do
			-- move backwards down list and relocate wrapped pets to start
			for i=#roster.petList,2,-1 do
				local petID = roster.petList[i]
				-- if petID is an owned pet, needs fanfare, and one before it does not need fanfare, move it
				if type(petID)=="string" and C_PetJournal.PetNeedsFanfare(petID) and i>numRelocated then
					tremove(roster.petList,i) -- move the petID to the start of the list
					tinsert(roster.petList,1,petID)
					numRelocated = numRelocated + 1
					break
				end
			end
			-- sometimes pets needing fanfare will be filtered out so this may run more than
			-- necessary; which is ok. this is happening very rarely only when at least
			-- one pet needs a fanfare/unwrapped
			numWrapped = numWrapped-1
		end
	end

	-- whew! all done. now the cleanup
	rematch:WipeTempTables()
	if roster:GetFilter("Script","code") then
		rematch:CleanupScriptEnvironment()
	end
end

-- run the petID through each active filter and return false at first failure
-- if true returned, pet should be listed
function roster:FilterPetByPetID(petID)

	-- gather information about the pet into petInfo
	if type(petID)=="string" then -- if this is an owned pet
		petInfo.owned = true
		petInfo.speciesID, petInfo.customName, petInfo.level, petInfo.xp, petInfo.maxXp, petInfo.displayID, petInfo.isFavorite, petInfo.name, petInfo.icon, petInfo.petType, petInfo.creatureID, petInfo.sourceText, petInfo.description, petInfo.isWild, petInfo.canBattle, petInfo.tradable, petInfo.unique, petInfo.obtainable = C_PetJournal.GetPetInfoByPetID(petID)
		petInfo.petID = petID
      if not petInfo.canBattle then
         petInfo.level = 0
      end
	elseif type(petID)=="number" then -- if this a pet user doesn't own
		petInfo.owned = false
		petInfo.name, petInfo.icon, petInfo.petType, petInfo.creatureID, petInfo.sourceText, petInfo.description, petInfo.isWild, petInfo.canBattle, petInfo.tradable, petInfo.unique, petInfo.obtainable, petInfo.displayID = C_PetJournal.GetPetInfoBySpeciesID(petID)
		petInfo.speciesID = petID
		petInfo.petID, petInfo.customName, petInfo.level, petInfo.xp, petInfo.maxXp, petInfo.isFavorite = nil, nil, nil, nil, nil, nil
	end

	if not petInfo.name then
		return -- if the pet no longer exists (was released)
	end

   if settings.HideNonBattlePets and not petInfo.canBattle then
      return false
   end

	-- hidden pets get special treatment outside of active filters
	local hidden = settings.HiddenPets
	if GetFilter(self,"Other","Hidden") then
		if not hidden or not hidden[petInfo.speciesID] then
			return false
		end
	elseif hidden and hidden[petInfo.speciesID] then
		return false
	end

	-- the first active filter to return false will fail this pet candidate
	for i=1,#activeFilters do
		if filterFuncs[activeFilters[i]]()==false then
			return false
		end
	end

	-- now for search stuff, offloading it to IsSearchMatch() later in this module
	local mask = roster.searchMask
	if mask then
		local relevance = roster:RunSearchMatch(mask)
		if not relevance then
			return false
		else
			rematch:GetTempTable("SearchRelevance")[petID] = relevance
		end
	end

	-- and finally if any stat searches (ie speed>300) then run its thing
	local range = roster.searchStatRanges
	if next(range) and not roster:RunStatMatch(range) then
		return false
	end

	-- if we reached here, all filters passed, pet is ok to list
	return true
end

--[[ filterFuncs

	These are the individual functions that run for each active filter group.
	If they return false then the pet is to NOT be listed.
	If they return nil or true then the pet is to be listed.

]]

function filterFuncs.Favorite()
	return petInfo.isFavorite or false
end

function filterFuncs.Collected()
	local owned = petInfo.owned
	if owned and GetFilter(self,"Collected","Owned") then
		return false
	elseif not owned and GetFilter(self,"Collected","Missing") then
		return false
	end
end

function filterFuncs.Types()
	return GetFilter(self,"Types",petInfo.petType) or false
end

function filterFuncs.Rarity()
	if not petInfo.owned then
		return false -- pets not owned have no rarity
	else
		local _,_,_,_,rarity = rematch:GetPetStats(petInfo.petID)
		return GetFilter(self,"Rarity",rarity) or false
	end
end

function filterFuncs.Sources()
	return GetFilter(self,"Sources",roster:GetSpeciesSource(petInfo.speciesID)) or false
end

function filterFuncs.Tough()
	return GetFilter(self,"Tough",rematch.hintsDefense[petInfo.petType][2]) or false
end

function filterFuncs.Level()
	if petInfo.canBattle then
		if GetFilter(self,"Level","Without25s") then
			return not rematch.speciesAt25[petInfo.speciesID]
		elseif GetFilter(self,"Level","MovesetNot25") then
			return not roster:IsMovesetAt25(petInfo.speciesID)
		elseif petInfo.owned then
			local level = petInfo.level
			if GetFilter(self,"Level",1) and level>0 and level<8 then
				return true
			elseif GetFilter(self,"Level",2) and level>7 and level<15 then
				return true
			elseif GetFilter(self,"Level",3) and level>14 and level<25 then
				return true
			elseif GetFilter(self,"Level",4) and level==25 then
				return true
			end
		end
	end
	return false
end

function filterFuncs.Other()
	-- Other -> Leveling/Not Leveling
	local isLeveling = rematch:IsPetLeveling(petInfo.petID)
	if GetFilter(self,"Other","Leveling") and not isLeveling then
		return false
	elseif GetFilter(self,"Other","NotLeveling") and isLeveling then
		return false
	end
	-- Other -> Tradable/Not Tradable
	if GetFilter(self,"Other","Tradable") and not petInfo.tradable then
		return false
	elseif GetFilter(self,"Other","NotTradable") and petInfo.tradable then
		return false
	end
	-- Other -> Can Battle/Can't Battle
	if GetFilter(self,"Other","Battle") and not petInfo.canBattle then
		return false
	elseif GetFilter(self,"Other","NotBattle") and petInfo.canBattle then
		return false
	end
	-- Other -> In A Team/Not In A Team
	local candidate = petInfo.petID or petInfo.speciesID
	if GetFilter(self,"Other","InTeam") and not roster:IsPetInTeam(candidate) then
		return false
	elseif GetFilter(self,"Other","NotInTeam") and roster:IsPetInTeam(candidate) then
		return false
	end
   -- Other -> Unique Moveset (excludes non-battle pets)
   if GetFilter(self,"Other","UniqueMoveset") and (not rematch.uniqueMovesets[rematch.movesetsBySpecies[petInfo.speciesID]] or not petInfo.canBattle) then
      return false
   elseif GetFilter(self,"Other","SharedMoveset") and (rematch.uniqueMovesets[rematch.movesetsBySpecies[petInfo.speciesID]] or not petInfo.canBattle) then
      return false
   end
	-- Other -> Has Notes
	if GetFilter(self,"Other","HasNotes") and not settings.PetNotes[petInfo.speciesID] then
		return false
	end
	-- Other -> Current Zone
	if GetFilter(self,"Other","CurrentZone") then
		local source = petInfo.sourceText
		if not source or not rematch:match(source,roster.currentZone) then
			return false
		end
	end
	-- Other -> One Copy/Two+ Copies/Three+ Copies
	local qty = GetFilter(self,"Other","Qty1") and 1 or GetFilter(self,"Other","Qty2") and 2 or GetFilter(self,"Other","Qty3") and 3
	if qty then
		local count = C_PetJournal.GetNumCollectedInfo(petInfo.speciesID)
		if not count then
			return false
		elseif qty==3 and count<3 then
			return false
		elseif qty==2 and count<2 then
			return false
		elseif qty==1 and count~=1 then
			return false
		end
	end
end

function filterFuncs.Breed()
	if not petInfo.owned or not petInfo.canBattle then
		return false -- pets not owned have no breed
	end
	return GetFilter(self,"Breed",(rematch:GetBreedIndex(petInfo.petID) or 13)-2) or false
end

--function filterFuncs.Strong()
--	return roster:IsStrong(petInfo.speciesID) or false
--end

function filterFuncs.Strong()
   -- return roster:IsStrong(petInfo.speciesID) or false

   if roster:IsStrong(petInfo.speciesID) then -- the species is strong vs the chosen filters

      -- if 'Use Level In Strong Vs Filter' is checked, strong abilities need to meet level requirement too
      if settings.StrongVsLevel then
         if not petInfo.level then
            return false -- unowned pets automatically fail
         elseif petInfo.level<20 then -- if pet is under 20, it can potentially fail level requirement
            -- this repeats some work from roster:IsStrong(speciesID) to confirm level (can't use cache for individual pets)
            -- fortunately the impact as not huge since the species cache limits how often this part runs
            local abilities,levels = rematch:GetAbilities(petInfo.speciesID)
            local lookup = rematch.info
            wipe(lookup)
            -- fill lookup table with abilityType of attacks this species has
            for index,abilityID in ipairs(abilities) do
               local _,_,_,_,_,_,abilityType,noHints = C_PetBattles.GetAbilityInfoByID(abilityID)
               if not noHints and petInfo.level>=levels[index] then
                  lookup[abilityType] = true
               end
            end
            -- then go through each filter and make sure each Strong Vs type are accounted for
            for attackType in pairs(settings.Filters.Strong) do
               if not lookup[rematch.hintsDefense[attackType][1]] then
                  return false
               end
            end
         end
      end

      -- if we reached here, either pet met level requirements or there were no level requirements
      return true
   end
   -- if we reached here, species wasn't strong vs the chosen filters
   return false
end

function filterFuncs.Similar()
	local abilities = rematch:GetAbilities(petInfo.speciesID)
	local matches = 0
	for i=1,#abilities do
		local abilityID = abilities[i]
		if GetFilter(self,"Similar",abilityID) then
			matches = matches + 1
		end
		-- if pet has at least 3 of the abilities in the Similar filter, return true (list pet)
		if matches>2 then
			return true
		end
	end
	-- if we reached here, pet didn't have 3 abilities in the Similar filter, return false (don't list)
	return false
end

function filterFuncs.Moveset()
   -- the 1 is the index into the settings.Filters.Moveset table (all filter groups are tables,
   -- and this filter only has one value to store which is stored in [1] index)
   return rematch.movesetsBySpecies[petInfo.speciesID]==GetFilter(self,"Moveset",1)
end

function filterFuncs.Script()
	local abilityList, levelList = rematch:GetAbilities(petInfo.speciesID)
	-- TODO: use petInfo for scripts instead of ridiculous number of args?
	if not rematch:RunScriptFilter(petInfo.owned, petInfo.petID, petInfo.speciesID, petInfo.customName, petInfo.level, petInfo.xp, petInfo.maxXp, petInfo.displayID, petInfo.isFavorite, petInfo.name, petInfo.icon, petInfo.petType, petInfo.creatureID, petInfo.sourceText, petInfo.description, petInfo.isWild, petInfo.canBattle, petInfo.tradable, petInfo.unique, petInfo.obtainable, abilityList, levelList) then
		return false
	end
end

--[[ Searches ]]

-- returns relevance if the pet defined in petInfo matches the passed search mask.
-- the desensitized mask is matched to the name, source and notes of a pet,
-- and then the names and description of its abilities.
-- due to the weighty nature of this search, two caches via tempTables are used
-- to dramatically speed up processing.

-- relevance: 1=custom name exact match; 2=custom name match; 3=species name exact match;
-- 4=species name match; 5=notes exact match; 6=notes match; 7=ability exact match;
-- 8=ability match; 9=source exact match; 10=source match

local speciesCache -- will be the SearchSpecies TempTable

-- for use in RunSearchMatch; does a match of mask to candidate and returns the given
-- relevanceStart if there's an exact match and the relevanceStart+1 if just a regular
-- match and nil if there is no match
local function matchRelevance(speciesID,mask,candidate,relevanceStart)
	if candidate and rematch:match(candidate,mask) then
		local relevance = candidate:match("^"..mask.."$") and relevanceStart or relevanceStart+1
		speciesCache[speciesID] = relevance
		return relevance
	end
end

function roster:RunSearchMatch(mask)

	-- search for custom name first since that's potentially unique among all pets
	-- customName match has a relevance of 1/2
	local customName = petInfo.customName
	if customName and rematch:match(customName,mask) then
		return customName:match("^"..mask.."$") and 1 or 2
	end

	-- the rest of the searches have the same result across the species, so we're going
	-- to use a cache for the species to speed up processing.
	local speciesID = petInfo.speciesID
	speciesCache = rematch:GetTempTable("SearchSpecies")

	-- check if we examined this speciesID before and return earlier result if so
	if speciesCache[speciesID]~=nil then
		return speciesCache[speciesID]
	end

	local relevance

	-- match species name; relevance 3/4
	relevance = matchRelevance(speciesID,mask,petInfo.name,3)
	if relevance then
		return relevance
	end

	-- match notes; relevance 5/6
	relevance = matchRelevance(speciesID,mask,settings.PetNotes[speciesID],5)
	if relevance then
		return relevance
	end

	-- if no hits yet, look through abilities, which has another cache since many
	-- abilities are shared across many pets.
	local abilityCache = rematch:GetTempTable("SearchAbilities")
	local abilities = rematch:GetAbilities(speciesID)
	for i=1,#abilities do
		local abilityID = abilities[i]
		-- first see if we've cached a result for this ability
		local cached = abilityCache[abilityID]
		if cached~=nil then -- if we've examined this ability already
			if cached then -- and it was a successful match
				speciesCache[speciesID] = cached -- mark species as a success too
				return cached
			end
			-- if cached is false, we know this ability doesn't match the mask;
			-- but another ability may return a hit. just ignore this ability.
		elseif not cached then -- we haven't examined this ability yet
			local _,name,_,_,description = C_PetBattles.GetAbilityInfoByID(abilityID)
			relevance = matchRelevance(speciesID,mask,name,7) or matchRelevance(speciesID,mask,description,7)
			if relevance then
				abilityCache[abilityID] = relevance
				return relevance
			else
				abilityCache[abilityID] = false -- no match, cache its result
			end
		end
	end

	-- match sourceText; relevance 9/10
	relevance = matchRelevance(speciesID,mask,petInfo.sourceText,9)
	if relevance then
		return relevance
	end

	-- if we've reached here, there was no match :( cache it as such and leave
	speciesCache[speciesID] = false
	return false
end

-- roster.searchStatRanges (passed as ranges) has the limits of stats in a small table
-- this returns true if the petInfo pet meets all the criterea of those ranges
function roster:RunStatMatch(ranges)
	if not petInfo.owned or not petInfo.canBattle then
		return false
	end
	local _,maxHealth,power,speed = rematch:GetPetStats(petInfo.petID)
	for stat,values in pairs(ranges) do
		local liveStat = stat=="Level" and petInfo.level or stat=="Health" and maxHealth or stat=="Power" and power or stat=="Speed" and speed
		if liveStat<values[1] or liveStat>values[2] then
			return false
		end
	end
	return true
end

-- returns the sort stat of the current petInfo pet, depending on settings.Sort.Order
-- sort orders: 1=name, 2=level, 3=rarity, 4=type, 5=health, 6=power, 7=speed
function roster:GetSortStat()
	local sortOrder = settings.Sort.Order
	local owned = petInfo.owned
	local sortStat,_
	-- for rarity, health, power or speed, we need to fetch those stats if they haven't been fetched
	if (sortOrder==3 or sortOrder>4) then
		if owned then
			_, petInfo.maxHealth, petInfo.power, petInfo.speed, petInfo.rarity = rematch:GetPetStats(petInfo.petID)
		else -- for missing pets, health, power, speed and rarity are nil
			petInfo.maxHealth, petInfo.power, petInfo.speed, petInfo.rarity = nil, nil, nil, nil
			petInfo.maxHealth, petInfo.power, petInfo.speed, petInfo.rarity = 0, 0, 0, 0
		end
	end
	if owned then -- for owned pets
		if sortOrder==1 and sortByNickname then -- sortStat is customName if SortByNickname enabled
			return petInfo.customName or petInfo.name -- returning customName or real name early
		end
	elseif sortOrder==2 then -- for missing pets when level is the sort order
		petInfo.level = 0 -- give it a fixed value so the sort is stable
	end
	return petInfo[sortReference[sortOrder]] -- and finally return the appropriate sort stat
end


-- table.sort function to sort pets so:
-- owned (petID instead of speciesID) always list first
-- then favorites list before non-favorites (if FavoritesFirst true)
-- then by sort stat filled during filter
-- then by name pulled on demand (compromise between memory vs speed)
-- and lastly by the raw petID so order remains fixed
function roster.SortPets(pet1,pet2)

	-- first sort by the existence of a pet
	if pet1 and not pet2 then return true
	elseif pet2 and not pet1 then return false
	elseif not pet1 and not pet2 then return false
	end

	local o1,o2 = type(pet1)=="string", type(pet2)=="string" -- owned pets always list first
	if o1 and not o2 then return true
	elseif o2 and not o1 then return false
	end

	-- relevance only matters if there's a search happening
	if roster.searchMask and not settings.DontSortByRelevance then
		local r1,r2 = sortRelevanceTable[pet1], sortRelevanceTable[pet2] -- relevance
		if r1 and not r2 then return true -- relevant pets first
		elseif r2 and not r1 then return false
		elseif r1~=r2 then
			return r1<r2
		end
	end

	local f1,f2 = sortFavoritesTable[pet1], sortFavoritesTable[pet2] -- favorites
	if f1 and not f2 then return true -- f1/f2 only true if FavoritesFirst true
	elseif f2 and not f1 then return false
	end

	local s1,s2 = sortStatsTable[pet1], sortStatsTable[pet2] -- chosen sort stat existence
	if s1 and not s2 then return true
	elseif s2 and not s1 then return false
	elseif not s1 and not s2 then return false
	end

	-- both pets have a sort stat here; sort them depending on sortLowToHigh
	if sortLowToHigh then
		if s1<s2 then return true
		elseif s2<s1 then return false
		end
	else -- level, rarity, health, power and speed sort in descending value (25-1)
		if s1>s2 then return true
		elseif s2>s1 then return false
		end
	end

	-- if we're still here, the two pets have the same sort stat

	-- gather name and level of the two pets
	local n1,n2,l1,l2,c1,c2,_
	if o1 then -- these are owned pets
		_,c1,l1,_,_,_,_,n1 = C_PetJournal.GetPetInfoByPetID(pet1)
		_,c2,l2,_,_,_,_,n2 = C_PetJournal.GetPetInfoByPetID(pet2)
	else -- unowned pets (0 level)
		l1,n1 = 0,C_PetJournal.GetPetInfoBySpeciesID(pet1)
		l2,n2 = 0,C_PetJournal.GetPetInfoBySpeciesID(pet2)
	end

	-- if SortByNickname enabled, use customName instead of actual name
	if sortByNickname then
		n1 = c1 or n1
		n2 = c2 or n2
	end

	-- if sorting by rarity, then do a secondary sort by level
	if settings.Sort.Order==3 then
		if l1~=l2 then
			return l1>l2 -- always descending level
		end
	end

	-- sort stats are identical, sort by name first

	-- final sort: by name (or by petID if name is identical)
	if n1==n2 then
		return pet1<pet2 -- names identical; sort by petID so sort order remains fixed
	else
		return n1<n2 -- names are different; sort by name
	end
end
