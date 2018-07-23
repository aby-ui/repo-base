--[[

   ODTables: On-Demand Tables

   There are times when data needs to be gathered in a table but the data
   doesn't need to hang around, such as cache tables; or it doesn't need
   gathered upon login but it should automatically gather when the table
   becomes relevant, such as sourceIDs.
   
   ODTables are intended to maximize table reuse, minimize garbage creation,
   and avoid filling tables with data until the data is actually needed.
   When created, an ODTable is empty. Once activated, via indexing or via
   table:Activate(), it will become active and run its populateFunc if one
   was defined when the table was created. After 1/4 of a second, or when the
   table is invalidated by table:Invalidate() or table:Deactivate(), the
   ODTable is wiped and returned to an inactive state.

   Persistent tables will not automatically invalidate over time, so the data
   remains; but it should be invalidated when info may change, such as when
   a new team is pushed.

   To create an ODTable:
      odTable = rematch:CreateODTable(populateFunc,persist)
         populateFunc (function) function to run when the table is activated
         persist (bool) to only wipe the table when it's explicitly invalidated

   To activate an ODTable, either:
      odTable:Activate() -- directly activating the table
         or
      local x = odTable[petID] -- activating by indexing it
      (if an inactive table is indexed, it will be activated automatically)
   
   To invalidate an ODTable, one of:
      odTable:Deactivate()
         or
      odTable:Invalidate()
         or
      if not persistent, let 1/4 second pass and it will wipe on its own

   Note: If iterating over a ODTable without indexing it, make sure to
   table:Activate() it first. It's ok if it was already activated.

]]

local rematch = Rematch

local tableDuration = 0.25 -- time (in seconds) before an active ODTable goes inactive
local timerIndex = 1 -- used for naming timers, incremented for each ODTable created

-- this table is indexed by ODTable table references, and contains tables of
-- attributes: isActive, populateFunc, isPersistent, timerName
local tableAttributes = {}

-- local functions defined later
local lookup, activateTable, deactivateTable

-- a few keys have special meaning to activate or deactivate a table
local ODTableAPI = {
   Activate = "activateFunc",
   Deactivate = "deactivateFunc",
   Invalidate = "deactivateFunc",
}

-- define a few global ODTables:
rematch:InitModule(function()

   -- petsInTeams is a persistent table indexed by petIDs (can be a speciesID)
   -- that equals number of teams the petID belongs to, or nil if none.
   -- note: when teams are pushed, this table should be invalidated
   rematch.petsInTeams = rematch:CreateODTable(function(self)
      for _,team in pairs(RematchSaved) do
         for i=1,3 do
            local petID = team[i][1]
            if petID then
               self[petID] = (self[petID] or 0) + 1
            end
         end
      end
   end,true)

   -- sourceIDs is a persistent table indexed by speciesIDs of the source
   -- for each species (1=Drop, 2=Quest, 3=Vendor, etc)
   -- because it's relatively expensive to populate the table (need to set 11 different
   -- filters and gather results) this one doesn't invalidate
   -- but because it's not used for most sessions, it's only created on demand
   rematch.sourceIDs = rematch:CreateODTable(function(self)
      Rematch.Roster:ExpandJournalFilters()
      for sourceID=1,C_PetJournal.GetNumPetSources() do -- going through all pet sources
         -- set source filter to single category
         for i=1,C_PetJournal.GetNumPetSources() do
            C_PetJournal.SetPetSourceChecked(i,i==sourceID)
         end
         -- fill sourceIDs with the source-filtered results
         for i=1,C_PetJournal.GetNumPets() do
            local _,speciesID = C_PetJournal.GetPetInfoByIndex(i)
            if not self[speciesID] then
               self[speciesID] = sourceID
            end
         end
      end
      rematch.Roster:RestoreJournalFilters() -- put everything back how it was
   end,true)

   -- speciesAt25 is a temporary table indexed by speciesIDs, true if the species
   -- has at least one level 25 pet.
   rematch.speciesAt25 = rematch:CreateODTable(function(self)
      for petID in rematch.Roster:AllOwnedPets() do
         local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
         if level==25 then
            self[speciesID] = true
         end
      end
   end)

   -- movesetsBySpecies is a persistent table indexed by speciesID, that contains
   -- the moveset for each species. a moveset is all abilities concatenated into a
   -- string such as "429,492,538,535,357,536" for a black tabby cat. note that a
   -- moveset is defined as the same abilities in the same order; which makes it
   -- different than "similar" abilities.
   rematch.movesetsBySpecies = rematch:CreateODTable(function(self)
      for speciesID in rematch.Roster:AllSpecies() do
         local petInfo = rematch.petInfo:Fetch(speciesID,true)
         self[speciesID] = table.concat(petInfo.abilityList,",")
      end
   end,true)

   -- movesetsAt25 is a temporary table indexed by movesets, true if the moveset is
   -- used by at least one species at level 25.
   rematch.movesetsAt25 = rematch:CreateODTable(function(self)
      rematch.speciesAt25:Activate()
      for speciesID in pairs(rematch.speciesAt25) do
         self[rematch.movesetsBySpecies[speciesID]] = true
      end
   end)

   -- uniqueMovesets is a temporary table indexed by movesets, true if the moveset
   -- is only used by one species.
   rematch.uniqueMovesets = rematch:CreateODTable(function(self)
      rematch.movesetsBySpecies:Activate() -- movesetsBySpecies needs activated since it's not indexed
      -- first count the number of times each moveset is used
      for speciesID,moveset in pairs(rematch.movesetsBySpecies) do
         self[moveset] = (self[moveset] or 0) + 1
      end
      -- next remove any that have more than 1
      for moveset,count in pairs(self) do
         if count>1 then
            self[moveset] = nil
         end
      end
   end,true)

end)

-- creates a ODTable, sets up its attributes, and returns the new table
function rematch:CreateODTable(populateFunc,isPersistent)
   local odTable = {}
   tableAttributes[odTable] = {}
   local attributes = tableAttributes[odTable]
   attributes.populateFunc = populateFunc
   attributes.isPersistent = isPersistent
   attributes.timerName = "ODTable"..timerIndex
   attributes.activateFunc = function() return activateTable(odTable) end
   attributes.deactivateFunc = function() return deactivateTable(odTable) end
   timerIndex = timerIndex + 1
   setmetatable(odTable,{__index=lookup})
   return odTable
end

-- __index function when a table's key value is nil
function lookup(self,key)
   local attributes = tableAttributes[self]
   -- if doing a table:Activate(), table:Deactivate() or table:Invalidate() return appropriate function
   local api = ODTableAPI[key]
   if api then
      return attributes[api]
   end
   -- otherwise first activate table if not already activated
   if not attributes.isActive then
      activateTable(self)
   end
   -- and return raw value of table (filled in after activation or still nil)
   return rawget(self,key)
end

-- called either directly via table:Activate() or indexing a nil entry
-- flags a table active, runs its populateFunc if it exists, and starts timer to deactivate
function activateTable(self)
   local attributes = tableAttributes[self]
   if not attributes.isActive then -- only activate if it wasn't activated
      attributes.isActive = true
      if attributes.populateFunc then -- if table has a function to populate on activation
         attributes.populateFunc(self) -- run it
      end
   end
   -- if table is not persistent, start timer to deactivate
   -- (this will restart the timer in the event an Activate() happens while already activated)
   if not attributes.isPersistent then
      rematch:StartTimer(attributes.timerName,tableDuration,attributes.deactivateFunc)
   end
   return self
end

-- called either directly via table:Deactivate()/Invalidate() or after 1/4 seconds pass after table activates
-- wipes table, flags it as inactive, and stops a timer if one is running
function deactivateTable(self)
   local attributes = tableAttributes[self]
   wipe(self)
   attributes.isActive = nil
   if not attributes.isPersistent then
      rematch:StopTimer(attributes.timerName)
   end
   return self
end
