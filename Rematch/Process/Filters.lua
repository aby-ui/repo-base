-- This is an extension to Roster that focuses on the filters themselves.

-- Roster.lua handles the collection of pets and created API to get information about pets.
-- Filters.lua handles the definition of filters and API to manipulate those filters.
-- PetList.lua applies the filters to the roster to form the filtered pet list to display.

--[[ todo: update this template to include new stuff; but its format is the same
	settings.Filters = {
		Collected = { Owned=boolean, Missing=boolean },
		Types = { booleanx10 },
		Strong = { booleanx10 },
		Tough = { booleanx10 },
		Sources = { booleanx10 },
		Rarity = { booleanx4 },
		Level = { 1(levels 1-7), 2(8-14), 3(15-24), 4(25), Without25s, MovesetNot25 all boolean},
		Other = { Favorite, NotFavorite, Leveling, NotLeveling, Tradable, NotTradable,
							Battle, NotBattle, Qty1, Qty2, Qty3, InTeam, NotInTeam },
	}
	settings.Sort = {
		Order = 1-7, (1=name, 2=level, 3=rarity, 4=type, 5=health, 6=power, 7=speed)
		Reverse = boolean,
		FavoritesFirst = boolean,
	}
	boolean are actually true/nil so next(table) will report whether it's empty
]]

local _,L = ...
local rematch = Rematch
local roster = Rematch.Roster
local settings

roster.searchMask = nil -- desensitized text to search for ([xX]51%-[nN][eE]etc)
roster.searchStatRanges = {} -- Level={1,24} Speed={300,305} Health={1400,nil} Power={nil,100}

-- settings.Filter table keys and their localized name
roster.filterGroups = { Collected=COLLECTED, Favorite=L["Favorites"], Types=L["Types"],
												Strong=L["Strong Vs"], Tough=L["Tough Vs"],	Sources=SOURCES, Rarity=RARITY,
												Breed=L["Breed"], Level=LEVEL, Other=OTHER, Similar=L["Similar"], Script=L["Script"],
                                    Moveset=L["Moveset"] }

-- radio group definitions: variables that are mutually exclusive with each other
roster.radioGroups = {
	Without25s=L["Level"], MovesetNot25=L["Level"], Leveling=L["Leveling"], NotLeveling=L["Leveling"],
	Tradable=L["Tradable"], NotTradable=L["Tradable"], Battle=L["Battle"], NotBattle=L["Battle"],
	Qty1=L["Quantity"], Qty2=L["Quantity"], Qty3=L["Quantity"], InTeam=L["Team"], NotInTeam=L["Team"],
	Hidden=L["Hidden"], CurrentZone=L["Zone"], HasNotes=L["Notes"], UniqueMoveset=L["Moveset"],
   SharedMoveset=L["Moveset"] }

roster.searchStatMasks = { [PET_BATTLE_STAT_HEALTH:lower()]="Health", [PET_BATTLE_STAT_POWER:lower()]="Power",
	[PET_BATTLE_STAT_SPEED:lower()]="Speed", [LEVEL:lower()]="Level", ["health"]="Health", ["power"]="Power",
	["speed"]="Speed", ["level"]="Level", ["h"]="Health", ["p"]="Power", ["s"]="Speed", ["l"]="Level" }

rematch:InitModule(function()
	settings = RematchSettings
	-- make sure each filterGroup has a table in settings.Filters
	for var in pairs(roster.filterGroups) do
		if type(settings.Filters[var])~="table" then
			settings.Filters[var] = {}
		end
		-- if ResetFilters option enabled, clear all filters on login
		if settings.ResetFilters then
			wipe(settings.Filters[var])
		end
	end
	-- if a sort isn't defined (or ResetFilters+ResetSortWithFilters both enabled), create an empty one
	if settings.ResetSortWithFilters and settings.ResetFilters then
		roster:ClearSort()
	end
	roster:UpdateZoneRegistration()
end)

-- called in login (during init above), when current zone filter checked/unchecked,
-- and when filters cleared
function roster:UpdateZoneRegistration()
	if roster:GetFilter("Other","CurrentZone") then
		roster:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	else
		roster:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	end
end

--[[ Filter Manipulation ]]

-- sets a filter: SetFilter("collected","owned",true)
function roster:SetFilter(group,variable,value)
	settings.Filters[group][variable] = value or nil
end

-- returns the state of a filter: GetFilter("sources",3)
function roster:GetFilter(group,variable)
	return settings.Filters[group][variable]
end

-- returns whether a filter group is clear: IsFilterClear("types")
function roster:IsFilterClear(group)
	return not next(settings.Filters[group])
end

-- returns true if a filter is being used (has something inside)
function roster:IsFilterUsed(group)
	return next(settings.Filters[group]) and true
end

-- returns true if a numerically-indexed filter is full
function roster:IsFilterFull(group,size)
	for i=1,size do
		if not settings.Filters[group][i] then
			return false
		end
	end
	return true
end

-- clears a filter group: ClearFilter("rarity")
function roster:ClearFilter(group)
	wipe(settings.Filters[group])
	if group=="Other" then -- if Other group being cleared, make sure to unregister for ZONE_CHANGED_NEW_AREA
		roster:UpdateZoneRegistration()
	end
end

-- clears a filter radio group: ClearRadio("Other","Quantity")
function roster:ClearRadio(group,radioGroup)
	local filter = settings.Filters[group]
	if filter then
		for k,v in pairs(roster.radioGroups) do
			if v==radioGroup then
				filter[k] = nil
			end
		end
	end
end

-- clears all filters
function roster:ClearAllFilters(manual)
	for k,v in pairs(settings.Filters) do
		if type(v)=="table" and roster.filterGroups[k] then
			wipe(v)
		else
			settings.Filters[k] = nil
		end
	end
	-- if ResetSortWithFilters enabled, also clear sort
	if settings.ResetSortWithFilters then
		roster:ClearSort()
	end
	roster:UpdateZoneRegistration()
	-- clearing search via petpanel search box (unless ResetExceptSearch checked and this is a manual reset)
	if not manual or not settings.ResetExceptSearch then
		rematch.PetPanel.Top.SearchBox.Clear:Click()
	end
	rematch:UpdateRoster()
	rematch:HideDialog()
end

function roster:GetSort(var)
	return settings.Sort[var]
end

function roster:SetSort(var,value)
	settings.Sort[var] = value or nil
end

function roster:ClearSort()
	settings.Sort = { Order=1, FavoritesFirst=true }
end

-- returns a comma-separated list of filters used for displaying on petpanel header; or nil if no filters used
-- pass groupsOnly as true when a list of filters groups only should be returned (ie favorite filters)
function roster:GetFiltersText(groupsOnly)
	local info = rematch.info
	wipe(info)
	if not groupsOnly then
		if roster.searchMask then
			tinsert(info,L["Search"])
		end
		-- if ResetSortWithFilters enabled, also show when a non-default Sort is active
		if settings.ResetSortWithFilters and (settings.Sort.Order~=1 or settings.Sort.Reverse or not settings.Sort.FavoritesFirst) then
			tinsert(info,L["Sort"])
		end
	end
	for filter,filterName in pairs(roster.filterGroups) do
		if roster:IsFilterUsed(filter) then
			if filter=="Other" then
				for otherFilter,otherFilterName in pairs(roster.radioGroups) do
					if roster:GetFilter(filter,otherFilter) then
						tinsert(info,otherFilterName)
					end
				end
			else
				tinsert(info,filterName)
			end
		end
	end
	if next(roster.searchStatRanges) then
		tinsert(info,L["Stats Search"])
	end
	if #info>0 then
		return table.concat(info,", "),(#info==1 and info[1]==L["Search"])
	end
end

--[[ Search ]]

-- sets search to the search text and makes a case-insensitive/magic-char-escaped search mask
-- returns true if the text actually changed
function roster:SetSearch(text)
	roster.oldSearchText = roster.oldSearchText or text -- first set text is not going to change
	local hadStats = next(roster.searchStatRanges)
	wipe(roster.searchStatRanges)
	local hasStats
	if not text or text:len()==0 then
		roster.searchMask = nil
	else
		text,hasStats = roster:ParseSearchStatRanges(text)
		roster.searchMask = rematch:DesensitizeText(text)
		-- after search text is desensitized, replace leading " with a ^ and
		-- trailing " with a $ to match the whole word (can use one quote to match start/end too!)
		roster.searchMask = roster.searchMask:gsub("^\"","^"):gsub("\"$","$")
		if roster.searchMask=="" then
			roster.searchMask = nil
		end
	end
	if text~=roster.oldSearchText or hasStats or hadStats then
		roster.oldSearchText = text
		return true
	end
end

-- takes raw text from the search box and pulls out operations on stats and returns remainder
function roster:ParseSearchStatRanges(text)
	local ranges = roster.searchStatRanges
	local info = rematch.info
	wipe(info)
	local hasStatRange
	-- if any operations found (level<25, 1-24, health=100-500, etc) then pull them out
	if text:match("[<>=]%d") or text:match("%d%-%d") then
		-- fill info with clumps of text without spaces
		for operation in text:gmatch("[^ ]+") do
			tinsert(info,operation)
		end
		-- go through each clump of text and test if it's an operation
		for i=#info,1,-1 do
			local operation = info[i]
			if operation:match("[<>=%-]") then -- if this has one of < > = or - then
				local stat,minValue,maxValue = roster:ParseOperation(operation:lower())
				if stat then -- operation was a stat range, add it to ranges
					ranges[stat] = {minValue,maxValue}
					hasStatRange = true
					tremove(info,i) -- and remove operation from the table of clumps
				end
			end
		end
	end
	if hasStatRange then -- some stat ranges were pulled out, rebuild text from remaining clumps
		return table.concat(info," "),true
	else -- no stat ranges were pulled out, return text as it was given
		return text
	end
end

-- tests potentional operation for any stat equations and returns stat and min/max value if so
function roster:ParseOperation(operation)
	-- legacy operation: <25 or >1 or =25 for level ranges
	local operator,value = operation:match("^([<>=])(%d+)$")
	if operator then
		value = tonumber(value)
		if operator=="=" then return "Level",value,value
		elseif operator=="<" then return "Level",1,value-1
		elseif operator==">" then return "Level",value+1,25
		end
	end
	-- legacy operation: 10-11, 1-24 for level ranges
	local minValue,maxValue = operation:match("^(%d+)%-(%d+)$")
	if minValue then
		return "Level",tonumber(minValue),tonumber(maxValue)
	end
	-- stat<value or stat>value or stat=value: level<25, speed>280, power=100
	local stat,operator,value = operation:match("^(%w+)([<>=])(%d+)$")
	if stat and roster.searchStatMasks[stat] then
		stat = roster.searchStatMasks[stat]
		value = tonumber(value)
		if operator=="=" then return stat,value,value
		elseif operator=="<" then return stat,1,value-1
		elseif operator==">" then return stat,value+1,9999
		end
	end
	-- stat=min-max: level=1-24, health=200-500
	local stat,minValue,maxValue = operation:match("^(%w+)=(%d+)%-(%d+)$")
	if stat and roster.searchStatMasks[stat] then
		stat = roster.searchStatMasks[stat]
		return stat,tonumber(minValue),tonumber(maxValue)
	end
end

--[[ Sort ]]

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

	local f1,f2 = roster.favorites[pet1], roster.favorites[pet2] -- favorites
	if f1 and not f2 then return true -- f1/f2 only true if FavoritesFirst true
	elseif f2 and not f1 then return false
	end

	local s1,s2 = roster.sortStats[pet1], roster.sortStats[pet2] -- chosen sort stat existence
	if s1 and not s2 then return true
	elseif s2 and not s1 then return false
	elseif not s1 and not s2 then return false
	end

	-- both pets have a sort stat here; sort them depending on sortLowToHigh
	if roster.sortLowToHigh then
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
	if settings.SortByNickname then
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
--	local n1 = o1 and select(8,C_PetJournal.GetPetInfoByPetID(pet1)) or C_PetJournal.GetPetInfoBySpeciesID(pet1)
--	local n2 = o2 and select(8,C_PetJournal.GetPetInfoByPetID(pet2)) or C_PetJournal.GetPetInfoBySpeciesID(pet2)

	-- final sort: by name (or by petID if name is identical)
	if n1==n2 then
		return pet1<pet2 -- names identical; sort by petID so sort order remains fixed
	else
		return n1<n2 -- names are different; sort by name
	end
end

--[[ Similar ]]

function roster:SetSimilarFilter(speciesID)
	roster:ClearAllFilters() -- start search for similar with other filters clear
	wipe(rematch.abilityList)
	C_PetJournal.GetPetAbilityList(speciesID, rematch.abilityList, rematch.levelList)
	for _,abilityID in ipairs(rematch.abilityList) do
		roster:SetFilter("Similar",abilityID,true)
	end
	rematch:ShowPets()
	rematch:UpdateRoster()
end

function roster:SetMovesetFilter(speciesID)
   roster:ClearAllFilters()
   -- the 1 is the index into the settings.Filters.Moveset table (all filter groups are tables,
   -- and this filter only has one value to store which is stored in [1] index)
   roster:SetFilter("Moveset",1,rematch.movesetsBySpecies[speciesID])
end

--[[ Hidden Pets ]]

-- hidden pets are always by speciesIDs and stored in settings.HiddenPets,
-- indexed by speciesID. this table only exists if there are any hidden pets

-- hides the speciesID of the petID if hide is true, unhides it if hide is false
function roster:SetHidePet(petID,hide)
	local speciesID = rematch:GetPetSpeciesID(petID)
	if speciesID then
		-- if unhiding, then remove speciesID from HiddenPets
		if not hide and settings.HiddenPets then
			settings.HiddenPets[speciesID] = nil
			if not next(settings.HiddenPets) then
				settings.HiddenPets = nil -- if no more hidden pets, remove HiddenPets table too
			end
		else
			-- do dialog to confirm if they want to hide the speciesID
			-- if hiding, create HiddenPets if it doesn't exist
			if not settings.HiddenPets then
				settings.HiddenPets = {}
			end
			-- and add this species to it
			settings.HiddenPets[speciesID] = true
		end
		rematch:UpdateRoster()
	end
end
