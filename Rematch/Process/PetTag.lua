--[[
   A PetTag is a short string to describe a pet and its abilities.

   The variable-length string is made of 32-base numbers in this format:

   000 0 0000
   ||| | |
   ||| | +- speciesID 
   ||| +--- breedID (0 to ignore, or 3-12)
   ||+----- ability 3 (0 to ignore, or 1-2)
   |+------ ability 2 (0 to ignore, or 1-2)
   +------- ability 1 (0 to ignore, or 1-2)

   Pet tags are stored in teams and used in import/export strings. When a petID
   ceases to be valid, or if a petID doesn't exist while importing a string,
   the tag is used to find the highest level/rarity of the described pet.

   This will remove the need for a sancutary, allow accurate backup/restore of
   teams, support breeds when exporting/importing teams, and solve the problem
   of Blizzard occasionally changing the abilities of pets.

   A few special case tags for export/import are prefixed by a Z:
      ZL:  Leveling pet
      ZI:  Ignored slot
      ZR0: Random pet (0 for any pet type, 1-A for a specific pet type)
      ZU:  Unknown

]]

local _,L = ...
local rematch = Rematch

local newTag = {} -- to avoid garbage creation, this table is reused to form a tag

-- creates and returns a tag for the given petID and abilities
-- petID can be a live petID or a speciesID
-- abilities can an abilityID or a number 0,1 or 2; or nil for ability ignored
-- for live petIDs, a breedID is embedded in the tag (see comments at top)
function rematch:CreatePetTag(petID,...)
   local petInfo = rematch.petInfo:Fetch(petID)
   if petInfo.speciesID and petInfo.valid then
      wipe(newTag)
      -- add three abilities to tag first
      for i=1,3 do
         local abilityID = floor(select(i,...) or 0)
         if abilityID>=0 and abilityID<=3 then -- if ability is already 0, 1 or 2
            tinsert(newTag,abilityID) -- no need to look it up
         else -- otherwise this is an abilityID, convert to 1 or 2 (or 0 if not found)
            if abilityID==petInfo.abilityList[i] then
               tinsert(newTag,1)
            elseif abilityID==petInfo.abilityList[i+3] then
               tinsert(newTag,2)
            else
               tinsert(newTag,0)
            end
         end
      end
      -- then breed if a breed addon is enabled (0 if not or a breed can't be determined)
      tinsert(newTag,type(petInfo.breedID)=="number" and rematch:ToBase32(petInfo.breedID) or "0")
      -- and finally speciesID
      tinsert(newTag,rematch:ToBase32(petInfo.speciesID))
      -- and return the tag
      return table.concat(newTag,"")
   elseif petInfo.idType=="leveling" then
      return "ZL"
   elseif petInfo.idType=="ignored" then
      return "ZI"
   elseif petInfo.idType=="random" then
      return "ZR"..(rematch:ToBase32(petInfo.petType or 0))
   end
   -- if we reached here, this pet can't be turned into a tag
   return "ZU" -- Unknown
end

-- returns the abilities as abilityIDs from the given tag (with a speciesID at the end)
-- returns 0 when ability offset is 0, and abilityID when it's 1 or 2
-- returns nil if no abilities can be inferred from the tag
function rematch:GetAbilitiesFromTag(tag)
   if type(tag)=="string" then
      local speciesID = tonumber(tag:sub(5,-1),32) -- pull out speciesID
      if speciesID then
         local abilityIDs = {}
         local petInfo = rematch.petInfo:Fetch(speciesID)
         for i=1,3 do
            local abilityOffset = tonumber(tag:sub(i,i),32)
            -- if abilityOffset is 1 or 2, then add that ability
            if abilityOffset==1 or abilityOffset==2 then
               tinsert(abilityIDs,petInfo.abilityList[i+(abilityOffset-1)*3])
            else -- otherwise use 0 for abilityID (to ignore ability)
               tinsert(abilityIDs,0)
            end
         end
         return abilityIDs[1],abilityIDs[2],abilityIDs[3],speciesID
      end
   end
end

-- FindPetFromPetTag takes a tag and returns the best petID for that tag
-- if notPetID1 to notPetID3 are defined, it will not choose any of those
-- if no petID is found, the speciesID will be returned as a petID
function rematch:FindPetFromPetTag(tag,notPetID1,notPetID2,notPetID3)
   if type(tag)~="string" then
      return -- all tags are strings
   elseif tag=="ZL" then
      return 0 -- this tag is for a leveling pet
   elseif tag=="ZI" then
      return "ignored" -- this tag is for an ignored slot
   elseif tag:match("^ZR%w") then
      return "random:"..tonumber(tag:match("^ZR(%w)"),32) -- this tag is for a random pet
   else -- this is a full tag with abilities, breed and speciesID
      local speciesID = tonumber(tag:sub(5,-1),32) -- speciesID begins at 5th character
      if speciesID then

         -- first check if one or less of a speciesID is known
         local numCollected = C_PetJournal.GetNumCollectedInfo(speciesID)
         if numCollected==0 then
            return speciesID -- player doesn't have this pet, return the speciesID
         elseif numCollected==1 then -- player has just one copy of this speciesID
            -- get the name of the speciesID, find the petID by name and return it
            local petInfo = rematch.petInfo:Fetch(speciesID)
            local _,petID = C_PetJournal.FindPetIDByName(petInfo.name)
            if petID~=notPetID1 and petID~=notPetID2 and petID~=notPetID3 then
               return petID or speciesID -- return found petID (or speciesID if petID not found)
            else
               return speciesID
            end
         end

         -- player owns more than one copy of this speciesID, find the best one
         local breedID = tonumber(tag:sub(4,4),32) or 0 -- breed is 4th character in tag
         local bestPetID -- current best petID
         local bestWeight = 0 -- weight of the current best petID
         -- go through all owned petIDs to get the best weighted petID
         for petID in rematch.Roster:AllOwnedPets() do
            local petInfo = rematch.petInfo:Fetch(petID)
            if petInfo.speciesID==speciesID and petID~=notPetID1 and petID~=notPetID2 and petID~=notPetID3 then
               local weight = petInfo.rarity -- rarity is lowest weight
               -- if breedID of the tag is 0, ignore breed (use 0 for all candidate breeds)
               -- if breedID is not 0, then matching breeds get a weight of 1
               local candidateBreedID = (breedID~=0 and petInfo.breedID==breedID) and 1 or 0
               -- if prioritizing breeds, give breed the highest weight
               if RematchSettings.PrioritizeBreedOnImport then
                  weight = weight + candidateBreedID*1000 + petInfo.level*10
               else -- otherwise give level the highest weight
                  weight = weight + petInfo.level*1000 + candidateBreedID*10
               end
               -- if this pet's weight is greater than current best, this pet is new best
               if weight>bestWeight then
                  bestPetID = petID
                  bestWeight = weight
               end
            end
         end
         -- return the best petID found, or the speciesID if none found
         if bestPetID then
            local petInfo = rematch.petInfo:Fetch(bestPetID)
         end
         return bestPetID or speciesID
      end
   end
end
