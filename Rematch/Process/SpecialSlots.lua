--[[
   Slots can be marked special by assigning one of these petIDs:
      - 0: this slot is a leveling slot under the queue's control
      - "ignored": this slot should be ignored and no specific pet goes in this slot
      - "random:x": this slot is a random slot and a random pet is chosen when loading
      - nil: remove special slot status

   While a special slot is active, the loadout pet's icon will be bordered in
   gold with a button in the topright to indicate what type of slot it is.
   
   Marking a special slot is done by:
   - The right-click menu of the slot:
      "Put Leveling Pet Here"
      "Put Random Pet Here"
      "Ignore This Slot"
   - Loading a team that has a special slot saved.

	Revoking the queue's control of a slot is done by:
	- The right-click menu of the slot:
       "Stop Leveling This Slot"
       "Stop Randomizing This Slot"
       "Stop Ignoring This Slot"
   - Loading a team that has no special slot saved.
   - Unloading the currently loaded team.
]]

local _,L = ...
local rematch = Rematch
local settings
local specialSlots

rematch:InitModule(function()
   settings = RematchSettings
   specialSlots = settings.SpecialSlots

end)

-- to be called after a team is loaded or unloaded
-- defines each of the three slots' special property
function rematch:AssignSpecialSlots()
   -- this function is also called during InitSavedVars on a new install.
   -- in that special case, assign local variables since InitSavedVars is called before
   -- this module's InitModule gets a chance to run
   if not specialSlots then
      settings = RematchSettings
      specialSlots = settings.SpecialSlots
   end
   wipe(specialSlots)
   local loadedTeam = settings.loadedTeam
   local team = loadedTeam and RematchSaved[loadedTeam]
   if team then
      for i=1,3 do
         local petInfo = rematch.altInfo:Fetch(team[i][1])
         if petInfo.idType=="leveling" or petInfo.idType=="ignored" or petInfo.idType=="random" then
            rematch:SetSpecialSlot(i,petInfo.petID)
         end
      end
   end
end

function rematch:SetSpecialSlot(slot,petID)
   if not petID or petID==0 or petID=="ignored" or tostring(petID):match("^random") then
      specialSlots[slot] = petID
   end
end

-- returns the petID of the special slot or nil if none
-- petID can be 0 (leveling), "ignored" or "random:x"
function rematch:GetSpecialSlot(slot)
   return specialSlots[slot]
end

-- returns "leveling" or "ignored" or "random" depending on the petID
function rematch:GetSpecialPetIDType(petID)
   if petID==0 then
      return "leveling"
   elseif petID=="ignored" then
      return "ignored"
   elseif type(petID)~="string" then
      return false
   elseif petID:match("^random") then
      return "random"
   end
end

function rematch:GetSpecialTooltip(petID)
   if petID==0 then
      return L["Leveling Slot"],L["This slot is controlled by the leveling queue.\n\nTeams saved with leveling slots will load leveling pets from the queue into these slots."]
   elseif petID=="ignored" then
      return L["Ignored Slot"],L["Teams saved with ignored slots will not load anything into these slots."]
   elseif tostring(petID):match("^random") then
      local petType = tonumber(petID:match("random:(%d+)"))
      return petType==0 and L["Random Pet"] or format(L["Random %s Pet"],_G["BATTLE_PET_NAME_"..petType] or ""),L["Teams saved with random slots will load a random high level pet into these slots."]
   end
end

function rematch:SpecialFootnoteOnClick()
   rematch:SetMenuSubject(self:GetParent():GetID())
   rematch:ShowMenu("LoadoutMenu","cursor")
end

-- this takes a random petID ("random:10") and returns a random petID of an owned pet
-- if noPetID1 and/or noPetID2 defined, the random pet will not be one of those
-- the random group is prioritized by level, rarity, whether in a team, and health
-- pets not in a team are preferred, and full-health pets are preferred over injured pets,
-- which are preferred over dead pets. if evenInTeams is true, then whether the pet is
-- in a team is not a deciding factor.
function rematch:PickRandomPet(petID,notPetID1,notPetID2,notPetID3,evenInTeams)
   if rematch:GetSpecialPetIDType(petID)=="random" then
      local petType = tonumber(petID:match("random:(%d+)"))
      local randomPetIDs = {}
      local bestWeight = 0
      if settings.AllowRandomPetsFromTeams then
         evenInTeams = true
      end
      for petID in rematch.Roster:AllOwnedPets() do
         if petID~=notPetID1 and petID~=notPetID2 and petID~=notPetID3 then
            local petInfo = rematch.altInfo:Fetch(petID,true)
            if (petType==0 or petInfo.petType==petType) and petInfo.canBattle and not petInfo.isDead and petInfo.speciesID~=1426 then -- petType==0 is "any type", speciesID 1426 is Elekk Plushie
               -- calculating weights from lowest to highest
               -- health is lowest: max health=2, injured=1, dead=0
               local weight = petInfo.health==petInfo.maxHealth and 2 or petInfo.health>0 and 1 or 0
               -- if pet not in any teams (or evenInTeams enabled and we don't care), add next highest
               if evenInTeams or not petInfo.inTeams then
                  weight = weight + 10
               end
               -- highest weight priority is level and rarity
               weight = weight + petInfo.level*1000 + petInfo.rarity*100
               -- at this point weight is: level->rarity->inTeam->health
               if weight>bestWeight then -- if this pet's weight is better
                  wipe(randomPetIDs) -- start list over
                  tinsert(randomPetIDs,petID) -- add pet to list
                  bestWeight = weight
               elseif weight==bestWeight then -- this pet is also a best weight
                  tinsert(randomPetIDs,petID) -- add pet to list
               end
            end
         end
      end
      if #randomPetIDs>0 then
         local petID = randomPetIDs[random(#randomPetIDs)]
         return petID
      end
   end
end

-- slots a random pet in the given slot; the petID is a random:x petID
-- random:0 for any type, random:1 for random humanoid, random:2 for dragonkin, etc
function rematch:SlotRandomPet(slot,petID)
   if rematch:GetSpecialPetIDType(petID)=="random" then
      -- first get other two loadout pets so we don't choose one of those for a random pet
      local next1 = slot%3+1
      local noPetID1 = C_PetJournal.GetPetLoadOutInfo(next1)
      local next2 = next1%3+1
      local noPetID2 = C_PetJournal.GetPetLoadOutInfo(next2)

      -- then pick a random pet and slot it (if one found)
      local petID = rematch:PickRandomPet(petID,next1,next2)
      if petID then
         rematch:SlotPet(slot,petID)
      end
   end
end
