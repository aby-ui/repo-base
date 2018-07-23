-- Roster.lua handles the collection of pets and created API to get information about pets.
-- Filters.lua handles the definition of filters and API to manipulate those filters.
-- PetList.lua applies the filters to the roster to form the filtered pet list to display.

local _,L = ...
local rematch = Rematch
local settings

local roster = CreateFrame("Frame") -- this module will handle its own events
rematch.Roster = roster

-- pets is the master list of petIDs/speciesIDs (the "unfiltered" journal list)
local allPets = {}
roster.allPets = allPets

-- speciesIDs is the master list of speciesIDs
local allSpeciesIDs = {} -- list of all speciesIDs
roster.speciesIDs = allSpeciesIDs -- (delete this line before pushing; need to really avoid direct access)

roster.speciesSources = {} -- source indexes of each species, filled only if GetSpeciesSource ever used

-- place to backup and restore journal settings
roster.journalBackup = { search="", collected=nil, notCollected=nil, types={}, sources={} }

roster.uniquePets = 0 -- number of unique pets owned, updated when number of owned pets changes
roster.ownedPets = nil -- number of owned pets in the journal; UpdateOwned() runs when this number changes

roster.updatingSelf = nil -- becomes true when roster is updating itself (to prevent reacting to own events)

roster.ownedNeedsUpdated = true -- becomes true when we need to expand filters to grab all pets

rematch:InitModule(function()
	settings = RematchSettings
	roster:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
	roster:SetScript("OnEvent",function(self,event,...) roster[event](self,...) end)
   roster.isStrongCache = rematch:CreateODTable() -- used by IsStrong() function
end)

function roster:GetNumUniquePets()
	roster:UpdateOwned()
	return roster.uniquePets
end

-- this should be the standard way of updating the roster; wait a frame before doing actual update
function rematch:UpdateRoster()
	roster.petListNeedsUpdated = true
	rematch:StartTimer("RosterUpdate",0,rematch.UpdateUI)
end

--[[ PET_JOURNAL_LIST_UPDATE

	Just about everything that changes pets (added/removed, renamed, stoned for level/rarity, etc)
	triggers this event.

	As of 7.0.3:

	On a cold login if this fires once:
	1: numPets is valid, numOwned is valid, not sure on first loadout (not observed lately)

	On a cold login if this fires twice:
	1: numPets is 0, numOwned is 0, first loadout is nil
	2: numPets is valid, numOwned is valid, first loadout is valid

	On a /reload if this fires once (first /reload after a cold login):
	1: numPets is valid, numOwned is valid, first loadout is valid

	On a /reload if this fires twice:
	1: numPets is 0, numOwned is valid, first loadout is nil (pets are not properly loaded!)
	2: numPets is valid, numOwned is valid, first loadout is valid

	Notes:
	- numPets,numOwned are the returns of C_PetJournal.GetNumPets()
	- numPets can be 0 and still be valid! When the default journal has all pets filtered off.
	- numOwned can be 0 and still be valid too! When the user has no pets.
	- On the first event of a /reload when it fires twice, petIDs are not yet valid.
	- In the past on a cold login it could take a good while for this event to fire (and it would fire once)
   - As of 4.7.3, PET_JOURNAL_LIST_UPDATE does not fire for the roster until the journal is unlocked
]]

function roster:PET_JOURNAL_LIST_UPDATE()
	local numPets,owned = C_PetJournal.GetNumPets()

	-- if number of owned pets changed, pets were added/removed; flag for an update to happen
	if owned ~= roster.ownedPets then
		roster.ownedPets = owned
		roster.ownedNeedsUpdated = true
	end
	-- if pets not loaded yet, simply leave
	if not owned or owned==0 then
		return
	end
	rematch.queueNeedsProcessed = true
	if owned>0 and settings.ShowOnLogin then
		settings.ShowOnLogin = nil
		rematch.Frame:Show()
	end
   rematch.speciesAt25:Invalidate()
	roster.petListNeedsUpdated = true
	rematch:UpdateUI()
end

-- this is only registered while "Other","CurrentZone" filter enabled
function roster:ZONE_CHANGED_NEW_AREA()
	if roster:GetFilter("Other","CurrentZone") then
		rematch:StartTimer("CurrentZone",0.75,rematch.UpdateUI)
	end
end

-- this is safe to call at any time; only when the number of owned pets changes will
-- roster.ownedNeedsUpdated be true.
function roster:UpdateOwned()
	if roster.ownedNeedsUpdated then
		-- first go through and mark all sanctuary pets as unknown
		local sanctuary = settings.Sanctuary
		for _,pet in pairs(sanctuary) do
			pet[2] = nil
		end
		-- next expand filters
		roster:ExpandJournalFilters()
		local numPets,owned = C_PetJournal.GetNumPets() -- get this AFTER expanding
		local fillSpecies = #allSpeciesIDs==0 -- if we haven't gathered species yet
		-- wipe existing pets
		local uniqueOwned = rematch.info -- will collect species owned in this table to count uniques
		wipe(uniqueOwned)
		wipe(allPets)
		-- and go through and gather them
		for i=1,numPets do
			local petID,speciesID,_,_,level = C_PetJournal.GetPetInfoByIndex(i)
			-- add the petID to allPets if it's one we own, or its speciesID otherwise
			if petID then
				tinsert(allPets,petID)
				uniqueOwned[speciesID] = true
				if sanctuary[petID] then -- if the pet is in the sanctuary
					sanctuary[petID][2] = true -- flag it as known to exist
				end
			else
				tinsert(allPets,speciesID)
			end
			-- if we need to gather species and this one isn't already in the allSpeciesIDs table
			if fillSpecies and not tContains(allSpeciesIDs,speciesID) then
				tinsert(allSpeciesIDs,speciesID)
			end
		end
		-- total unique pets
		roster.uniquePets = 0
		for k,v in pairs(uniqueOwned) do
			roster.uniquePets = roster.uniquePets + 1
		end
		wipe(uniqueOwned)
		-- put everything back how it was
		roster:RestoreJournalFilters()
		roster.ownedNeedsUpdated = owned==0 -- if pets not loaded we still need updating!
		rematch.sanctuaryNeedsUpdated = owned>0 -- and don't touch sanctuary until then!
	end
end

--[[ Journal Extraction: getting all pets from the journal requires expanding filters
		 and clearing search, getting the list of pets, then restoring filters/search ]]

-- since there is no C_PetJournal.GetSearchFilter, we need to watch for it changing
hooksecurefunc(C_PetJournal,"SetSearchFilter",function(search)
	if not roster.updatingSelf then
		roster.journalBackup.search = search or ""
	end
end)
hooksecurefunc(C_PetJournal,"ClearSearchFilter",function()
	if not roster.updatingSelf then
		roster.journalBackup.search = ""
	end
end)

-- backs up filters and expands journal to show all pets
function roster:ExpandJournalFilters()
	roster.updatingSelf = true
	-- we're going to be triggering a PJLU event, expand disables event; restore turns it on after a delay
	roster:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")
	-- backup all filters
	local backup = roster.journalBackup
	backup.collected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED)
	backup.notCollected = C_PetJournal.IsFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED)
	for i=1,C_PetJournal.GetNumPetTypes() do
		backup.types[i] = C_PetJournal.IsPetTypeChecked(i)
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		backup.sources[i] = C_PetJournal.IsPetSourceChecked(i)
	end
	C_PetJournal.ClearSearchFilter()
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED,true)
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED,true)
	C_PetJournal.SetAllPetSourcesChecked(true)
	C_PetJournal.SetAllPetTypesChecked(true)
end

-- restores journal filters to the state in roster.journalBackup
function roster:RestoreJournalFilters()
	local backup = roster.journalBackup
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED,backup.collected)
	C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED,backup.notCollected)
	for i=1,C_PetJournal.GetNumPetSources() do
		C_PetJournal.SetPetSourceChecked(i,backup.sources[i])
	end
	for i=1,C_PetJournal.GetNumPetTypes() do
		C_PetJournal.SetPetTypeFilter(i,backup.types[i])
	end
	C_PetJournal.SetSearchFilter(backup.search)
	roster.updatingSelf = nil
	-- we're done messing with PJLU-triggering stuff, start event again next frame
	C_Timer.After(0,function() roster:RegisterEvent("PET_JOURNAL_LIST_UPDATE") end)
end


--[[ Iterator functions will go over all pets, running UpdateOwned if needed ]]

-- this is all pets, owned petIDs and missing speciesIDs
function roster:AllPets()
	roster:UpdateOwned()
	local i=0
	return function()
		i=i+1
		if i<=#allPets then
			return allPets[i]
		end
	end
end

-- this is all owned petIDs
function roster:AllOwnedPets()
	roster:UpdateOwned()
	local i=0
	return function()
		i=i+1
		if i<=#allPets then
			local petID = allPets[i]
			if type(petID)=="string" then
				return petID
			end
		end
	end
end

-- this is all unique speciesIDs
function roster:AllSpecies()
   roster:UpdateOwned()
  local i=0
	return function()
		i=i+1
		if i<=#allSpeciesIDs then
			return allSpeciesIDs[i]
		end
	end
end

--[[ On-demand stuff ]]

-- returns the source (as a number 1-10; Drop, Quest, Vendor, etc) of a speciesID.
-- unfortunately the only way to get this number is by setting the journal filters and
-- looking at what's left. this caches first encounter so later use doesn't touch filters.
function roster:GetSpeciesSource(speciesID)
	local sources = roster.speciesSources
	if not next(sources) then -- haven't collected sources this session
		roster:ExpandJournalFilters()
		for source=1,C_PetJournal.GetNumPetSources() do -- going through all pet sources
			-- set source filter to single category
			for i=1,C_PetJournal.GetNumPetSources() do
				C_PetJournal.SetPetSourceChecked(i,i==source)
			end
			-- fill speciesSources with the results
			for i=1,C_PetJournal.GetNumPets() do
			  local _,speciesID = C_PetJournal.GetPetInfoByIndex(i)
				if not sources[speciesID] then
					sources[speciesID] = source
				end
			end
		end
		roster:RestoreJournalFilters() -- put everything back how it was
	end
	-- after the first time sources are gathered, we just return the cached source index
	if speciesID then
		return sources[speciesID]
	end
end

-- returns true if the moveset of a species is at 25 for any species
function roster:IsMovesetAt25(speciesID)
   return rematch.movesetsAt25[rematch.movesetsBySpecies[speciesID]]
end

-- counts the number of teams that a petID belongs to
-- (remove this once PetList converted to real petInfo)
function roster:IsPetInTeam(petID)
   return rematch.altInfo:Fetch(petID).inTeams
end

function roster:PopulatePetsInTeams(data)
	for _,team in pairs(RematchSaved) do
		for i=1,3 do
			local petID = team[i][1]
			if petID then
				if not data[petID] then
					data[petID] = 0
				end
				data[petID] = data[petID] + 1
			end
		end
	end
end

-- returns true if the given speciesID is strong to the filtered pet types
function roster:IsStrong(speciesID)
	-- to save work, use an ondemand table with cached results of this species
   local cache = roster.isStrongCache:Activate()
	if cache[speciesID]~=nil then
		return cache[speciesID]
	end
	local abilities = rematch:GetAbilities(speciesID)
	local lookup = rematch.info
	wipe(lookup)
	-- fill lookup table with abilityType of attacks this species has
	for _,abilityID in ipairs(abilities) do
		local _,_,_,_,_,_,abilityType,noHints = C_PetBattles.GetAbilityInfoByID(abilityID)
		if not noHints then
			lookup[abilityType] = true
		end
	end
	-- then go through each filter and make sure each Strong Vs type are accounted for
	for attackType in pairs(settings.Filters.Strong) do
		if not lookup[rematch.hintsDefense[attackType][1]] then
			cache[speciesID] = false -- a filtered Strong Vs is not among the pet's attacks; mark it false
			return false
		end
	end
	-- if we reached here, all Strong Vs types are accounted for in the pet's attacks
	cache[speciesID] = true
	return true
end
