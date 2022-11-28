--[[

   Rematch refers to pets as a single number or string, depending on their
   context. This reference, called a petID, can be one of seven idTypes:
   
   idType      example petID value    description
   ----------  ---------------------  -----------------------------------
   "pet"       "Battle-0-0000000etc"  a player-owned pet in the journal
   "species"   42                     speciesID species number
   "leveling"  0                      leveling slot
   "ignored"   "ignored"              ignored slot
   "link"      "battlepet:42:25:etc"  linked pet
   "battle"    "battle:2:1"           pet in battle (battle:owner:index)
   "random"    "random:10"            random mechanical pet (random:0 for any pet type)
   "unknown"   (anything, even nil)   indecipherable/undefined pet
   
   To simplify getting information about these different types of pets, to
   eliminate the scattered code to independently call the various API through
   C_PetJournal and C_PetBattles, and to reduce redundant API calls for
   information already retrieved (or information not used!), this module
   encapsulates a "front end" for information about pets.

   To use, first create a petInfo instance:
      
      local petInfo = rematch:CreatePetInfo()

   Then fetch a petID to make it the pet of interest:

      petInfo:Fetch(petID)
      
   After a pet of interest is fetched, simply index the stat you want:

      print(petInfo.name,"is level",petInfo.level,"and breed",petInfo.breedName)

   The stat can be any of these:

      petID: this is the pet reference Fetched (string, number, link, etc)
      idType: "pet" "species" "leveling" "ignored" "link" "battle" "random" or "unknown" (string)
      speciesID: numeric speciesID of the pet (integer)
      customName: user-renamed pet name (string)
      speciesName: name of the species (string)
      name: customName if defined, speciesName otherwise (string)
      level: whole level 1-25 (integer)
      xp: amount of xp in current level (integer)
      maxXp: total xp to reach next level (integer)
      fullLevel: level+xp/maxXp (float)
      displayID: id of the pet's skin (integer)
      isFavorite: whether pet is favorited (bool)
      icon: fileID of pet's icon or specific filename (integer or string)
      petType: numeric type of pet 1-10 (integer)
      creatureID: npcID of summoned pet (integer)
      sourceText: formatted text about where pet is from (string)
      loreText: "back of the card" lore (string)
      isWild: whether the pet is found in the wild (bool)
      canBattle: whether pet can battle (bool)
      isTradable: whether pet can be caged (bool)
      isUnique: whether only one of pet can be learned (bool)
      isObtainable: whether this pet is in the journal (bool)
      health: current health of the pet (integer)
      maxHealth: maximum health of the pet (integer)
      power: power stat of the pet (integer)
      speed: speed stat of the pet (integer)
      rarity: rarity 1-4 of pet (integer)
      isDead: whether the pet is dead (bool)
      isInjured: whether the pet has less than max health (bool)
      isSummonable: whether the pet can be summoned (bool)
      isRevoked: whether the pet is revoked (bool)
      abilityList: table of pet's abilities (table)
      levelList: table of pet's ability levels (table)
      valid: whether the petID is valid and petID is not missing (bool)
      owned: whether the petID is a valid pet owned by the player (bool)
      count: number of pet the player owns (integer)
      maxCount: maximum number of this pet the player can own (integer)
      hasBreed: whether pet can battle and there's a breed source (bool)
      breedID: 3-12 for known breeds, 0 for unknown breed, nil for n/a (integer)
      breedName: text version of breed like P/P or S/B (string)
      possibleBreedIDs: list of breedIDs possible for the pet's species (table)
      possibleBreedNames: list of breedNames possible for the pet's species (table)
      numPossibleBreeds: number of known breeds for the pet (integer)
      needsFanfare: whether a pet is wrapped (bool)
      battleOwner: whether ally(1) or enemy(2) pet in battle (integer)
      battleIndex: 1-3 index of pet in battle (integer)
      isSlotted: whether pet is slotted (bool)
      inTeams: whether pet is in any teams (pet and species idTypes only) (bool)
      numTeams: number of teams the pet belongs to (pet and species only) (integer)
      sourceID: the source index (1=Drop, 2=Quest, 3=Vendor, etc) of the pet (integer)
      moveset: the exact moveset of the pet ("123,456,etc") (string)
      speciesAt25: whether the pet has a version at level 25 (bool)
      hasNotes: whether the pet has notes (bool)
      notes: the text of the pet's notes (string)
      isLeveling: whether the pet is in the queue (bool)
      isSummoned: whether the pet is currently summoned (bool)
      expansionID: the numeric index of the expansion the pet is from: 0=classic, 1=BC, 2=WotLK, etc. (integer)
      expansionName: the name of the expansion the pet is from (string)
      canLevel: whether the pet can battle and is below level 25
      
   How it works:

      petInfo:Fetch(petID) will check if the petID is different from the last-
      fetched pet. If so, it will wipe the existing information and store the
      petID and idType within the table, ready for stats to be queried/indexed.

      The created petInfo table has a __index metamethod to look up indexes
      that don't exist.

      If a petInfo[stat] has no value, the __index metamethod will call the
      appropriate API (depending on the idType of the pet) and fill in its
      value. Future references to petInfo[stat] will have a value and not
      invoke a __index.

   Also:

      rematch.petInfo and rematch.altInfo are defined at the end of this file
      for use throughout the addon.

      The script filter system has its own petInfo that's already fetched for each
      pet. Script filters do not need to fetch a the current pet.

      petInfo:Reset() will force a wipe of information.

      When the petID is guaranteed to be from the journal (either a valid,
      owned petID string or speciesID), Fetch(petID,true) will skip the
      test of its type to improve performance.

      link format:
      "battlepet:<speciesID>:<level>:<rarity>:<health>:<power>:<speed>"

]]

local _,L = ...
local rematch = Rematch

local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
local GetPetInfoBySpeciesID = C_PetJournal.GetPetInfoBySpeciesID

-- every petInfo key added needs to be added here; key="Group", where Group is a key in queryAPI
local apiByStat = {
   speciesID="Info", customName="Info", level="Info", xp="Info", maxXp="Info",
   displayID="Info", isFavorite="Info", speciesName="Info", name="Info", icon="Info",
   petType="Info", creatureID="Info", sourceText="Info", loreText="Info", isWild="Info",
   canBattle="Info", isTradable="Info", isUnique="Info", isObtainable="Info", health="Stats",
   maxHealth="Stats", power="Stats", speed="Stats", rarity="Stats", isDead="Dead", isInjured="Dead",
   isSummonable="SummonInfo", summonError="SummonInfo", summonErrorText="SummonInfo", summonShortError="SummonInfo",
   isRevoked="Other", abilityList="Abilities", levelList="Abilities",
   valid="Valid", count="Count", maxCount="Count", fullLevel="FullLevel", needsFanfare="Fanfare",
   breedID="Breed", breedName="Breed", possibleBreedIDs="PossibleBreeds",
   possibleBreedNames="PossibleBreeds", numPossibleBreeds="PossibleBreeds", hasBreed="Breed",
   owned="Valid", battleOwner="Battle", battleIndex="Battle", isSlotted="Slotted",
   inTeams="Teams", numTeams="Teams", sourceID="Source", moveset="Moveset", speciesAt25="SpeciesAt25",
   notes="Notes", hasNotes="Notes", isLeveling="IsLeveling", isSummoned="IsSummoned", 
   expansionID="Expansion", expansionName="Expansion",
   canLevel="CanLevel",
}

-- indexed by petInfo table reference, this will contain reused tables like fetchedAPI
-- and abilityList to prevent garbage creation
local hiddenTables = {}

-- for Breed stat group
local breedSource -- addon that's providing breed data: "BattlePetBreedID", "PetTracker_Breeds" or "LibPetBreedInfo-1.0"
local breedLib -- for LibPetBreedInfo-1.0 only
local breedNames = {nil,nil,"B/B","P/P","S/S","H/H","H/P","P/S","H/S","P/B","S/B","H/B"}

-- lookup table by speciesID, whether the species has ever been able to battle; this is to address canBattle being false
-- while zoning. the queue and other areas need to know if a pet can potentially battle, not if it can battle while zoning
local canBattleBySpeciesID = {}
_canBattleBySpeciesID = canBattleBySpeciesID

-- in general, when a pet is added alongside others in an expansion they all clump to a range of speciesIDs
-- (with some outliers listed below). this is a list of expansions and the range of speciesIDs in that
-- epxansion: [expansionID] = {firstSpeciesID,lastSpeciesID}
local expansionRanges = {
   [0] = {39,128}, -- Classic
   [1] = {130,186}, -- Burning Crusade
   [2] = {187,258}, -- Wrath of the Lich King
   [3] = {259,343}, -- Cataclysm
   [4] = {346,1365}, -- Mists of Pandaria
   [5] = {1384,1693}, -- Warlords of Draenor
   [6] = {1699,2163}, -- Legion
   [7] = {2165,2872}, -- Battle for Azeroth
   [8] = {2878,3255}, -- Shadowlands
   [9] = {3256,9999}, -- Dragonflight
}

-- the majority of pets fall into a range for each expansion above, except for some outliers. these are the
-- species ID and the expansionID they belong to
local expansionOutliers = {
   [1563] = 0, -- Bronze Whelpling
   [191] = 1, -- Clockwork Rocket Bot
   [1073] = 1, -- Terky
   [1351] = 2, -- Macabre Marionette
   [220] = 3, -- Withers
   [255] = 3, -- Celestial Dragon
   [231] = 4, -- Jade Tiger
   [1386] = 4, -- Dread Hatchling
   [1943] = 4, -- Noblegarden Bunny
   [115] = 5, -- Land Shark
   [1725] = 5, -- Grumpling
   [1730] = 5, -- Spectral Spinner
   [1740] = 5, -- Ghost Maggot
   [1741] = 5, -- Ghastly Rat
   [1761] = 5, -- Echo Batling
   [1764] = 5, -- Energized Manafiend
   [1765] = 5, -- Empyreal Manafiend
   [1766] = 5, -- Empowered Manafiend
   [1828] = 5, -- Baby Winston
   [2143] = 7, -- Tottle
   [2157] = 7, -- Dart
   [2798] = 8, -- Plagueborn Slime
   [666] = 6, -- Micronax
}

-- short reason that the pet can't be summoned
local summonErrors = {
   [Enum.PetJournalError.JournalIsLocked] = L["Journal Is Locked"],
   [Enum.PetJournalError.InvalidFaction] = L["Wrong Faction"],
   [Enum.PetJournalError.InvalidCovenant] = L["Wrong Covenant"]
}

-- getIDType takes a petID and returns what type of id it is
-- possible: "pet" "species" "leveling" "ignored" "link" "battle" "random" or "unknown"
local function getIDType(id)
   local idType = type(id)
   if idType=="string" then
      if id:match("^BattlePet%-%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
         return "pet"
      elseif id:match("battlepet:%d+:%d+:%d+:%d+:%d+:%d+") then
         return "link"
      elseif id:match("battle:%d:%d") then
         return "battle"
      elseif id:match("random:%d+") then
         return "random"
      elseif id=="ignored" then
         return "ignored"
      end
   elseif idType=="number" then
      if id>0 then
         return "species"
      elseif id==0 then
         return "leveling"
      end
   end
   return "unknown" -- if we reached here, no idea what this petID is!
end

-- used in Info functions to gather info by petID (BattlePet-0-000etc)
local function fillInfoByPetID(self,petID)
   local speciesID, customName, speciesName, canBattle -- prevent a __index lookup if petID is invalid or not renamed
   speciesID,customName,self.level,self.xp,self.maxXp,self.displayID,
   self.isFavorite,speciesName,self.icon,self.petType,self.creatureID,
   self.sourceText,self.loreText,self.isWild,canBattle,self.isTradable,
   self.isUnique,self.isObtainable = GetPetInfoByPetID(petID)
   self.speciesID = speciesID
   self.name = customName or speciesName
   self.customName = customName
   self.speciesName = speciesName
   if speciesID then
      if not canBattleBySpeciesID[speciesID] and canBattle then
         canBattleBySpeciesID[speciesID] = canBattle -- if pet is ever canBattle, then it always can
      end
      self.canBattle = canBattleBySpeciesID[speciesID]
   end
end

-- used in Info functions to gather info by speciesID (42)
local function fillInfoBySpeciesID(self,speciesID)
   local speciesName, canBattle -- prevent a __index lookup if speciesID is invalid
   speciesName,self.icon,self.petType,self.creatureID,self.sourceText,
   self.loreText,self.isWild,self.canBattle,self.isTradable,self.isUnique,
   self.isObtainable,self.displayID = GetPetInfoBySpeciesID(speciesID)
   self.speciesName = speciesName
   self.name = speciesName
   self.speciesID = speciesID
   if not self.icon then
      self.icon = "Interface\\Icons\\INV_Pet_BattlePetTraining"
   end
   if speciesID then
      if not canBattleBySpeciesID[speciesID] and canBattle then
         canBattleBySpeciesID[speciesID] = canBattle -- if pet is ever canBattle, then it always can
      end
      self.canBattle = canBattleBySpeciesID[speciesID]   
   end
end

-- indexed by API group ("Info", "Stats", etc) these are the functions that are called
-- if fetchedAPI[key] is nil; they fill petInfo with values depending on the pet idType
local queryAPIs = {
   Info = function(self)
      -- the majority of info is behind GetPetInfoByPetID and GetPetInfoBySpeciesID
      local idType = self.idType
      if idType=="pet" then
         fillInfoByPetID(self,self.petID)
      elseif idType=="species" then
         fillInfoBySpeciesID(self,self.petID)
      elseif idType=="leveling" then
         self.name = L["Leveling Pet"]
         self.icon = "Interface\\AddOns\\Rematch\\Textures\\LevelingIcon.blp"
      elseif idType=="ignored" then
         self.name = L["Ignored Pet"]
         self.icon = "Interface\\AddOns\\Rematch\\Textures\\IgnoredIcon.blp"
      elseif idType=="link" then
         local speciesID,level = self.petID:match("battlepet:(%d+):(%d+):")
         speciesID = tonumber(speciesID)
         if speciesID then
            fillInfoBySpeciesID(self,speciesID)
            self.level = tonumber(level)
         end
      elseif idType=="battle" then
         local owner = self.battleOwner
         local index = self.battleIndex
         if owner==1 then -- for ally battle pets, just use the loaded pet
            local petID = C_PetJournal.GetPetLoadOutInfo(index)
            if petID then
               fillInfoByPetID(self,petID)
            end
         elseif owner==2 then
            local speciesID = C_PetBattles.GetPetSpeciesID(owner,index)
            if speciesID then
               fillInfoBySpeciesID(self,speciesID)
               self.level = C_PetBattles.GetLevel(owner,index)
               self.displayID = C_PetBattles.GetDisplayID(owner,index)
            end
         end
      elseif idType=="random" then
         -- petType always defined as 0-10 for random pets
         local petType = math.min(10,math.max(0,tonumber(self.petID:match("random:(%d+)")) or 0))
         self.petType = petType
         -- name is "Random Pet" or "Random Humanoid", "Random Dragonkin", etc
         local suffix = PET_TYPE_SUFFIX[petType]
         self.name = suffix and format(L["Random %s"],_G["BATTLE_PET_NAME_"..petType]) or L["Random Pet"]
         self.icon = suffix and format("Interface\\Icons\\Icon_PetFamily_%s",suffix) or "Interface\\Icons\\INV_Misc_Dice_02"
      else
         self.name = L["Unknown"]
         self.icon = "Interface\\Icons\\INV_Misc_QuestionMark"
      end
   end,
   -- only owned pets, linked pets and battle pets have real stats
   Stats = function(self)
      local idType = self.idType
      if idType=="pet" then
         self.health,self.maxHealth,self.power,self.speed,self.rarity = C_PetJournal.GetPetStats(self.petID)
      elseif idType=="link" then
         local rarity,health,power,speed = self.petID:match("battlepet:%d+:%d+:(%d+):(%d+):(%d+):(%d+)")
         if rarity then
            self.rarity = tonumber(rarity)+1 -- links are 0-3 rarity intead of 1-4
            self.health = tonumber(health)
            self.maxHealth = tonumber(health)
            self.power = tonumber(power)
            self.speed = tonumber(speed)
         end
      elseif idType=="battle" then -- pets in a battle fetch live stats (but note values cache!)
         local owner = self.battleOwner
         local index = self.battleIndex
         if C_PetBattles.GetPetSpeciesID(owner,index) then
            self.rarity = C_PetBattles.GetBreedQuality(owner,index)
            self.health = C_PetBattles.GetHealth(owner,index)
            self.maxHealth = C_PetBattles.GetMaxHealth(owner,index)
            self.power = C_PetBattles.GetPower(owner,index)
            self.speed = C_PetBattles.GetSpeed(owner,index)
         end
      end
   end,
   -- intended to be functions that are only called for journal listing; may separate these later
   Other = function(self)
      if self.idType=="pet" then
         local petID = self.petID
         --self.isSummonable = C_PetJournal.PetIsSummonable(petID)
         self.isRevoked = C_PetJournal.PetIsRevoked(petID)
      end
   end,
   -- isSummonable moved to this for new GetPetSummonInfo
   SummonInfo = function(self)
      if self.idType=="pet" then
         local isSummonable, error, errorText = C_PetJournal.GetPetSummonInfo(self.petID)
         if not isSummonable and error==Enum.PetJournalError.PetIsDead then
            isSummonable = true -- treating summonable pets that are just dead as summonable
         end
         self.isSummonable = isSummonable
         self.summonError = error
         self.summonErrorText = errorText -- this text is a bit too long for pet card but usable in tooltips
         self.summonShortError = error and summonErrors[error] or L["Can't Summon"] -- usable for pet card
      else
         self.isSummonable = true
      end
   end,
   -- fills petInfo.abilityList and .levelList
   Abilities = function(self)
      if self.speciesID then
         local abilityList = hiddenTables[self].abilityList
         local levelList = hiddenTables[self].levelList
         C_PetJournal.GetPetAbilityList(self.speciesID,abilityList,levelList)
         self.abilityList = abilityList
         self.levelList = levelList
      end
   end,
   -- petInfo.valid verifies the pet contains information (not a reassigned petID or bad speciesID)
   Valid = function(self)
      local idType = self.idType
      if idType=="pet" and self.speciesID then -- if speciesID read ok then "pet" petID is functional
         self.valid = true
         self.owned = true -- owned is only true if regular petID is valid
      elseif (idType=="species" and self.name) or (idType=="leveling" or idType=="ignored" or idType=="random") or (idType=="link" and self.name) or (idType=="battle" and self.name) then
         self.valid = true
         self.owned = false
      else
         self.valid = false
      end
   end,
   -- fills petInfo.count and petInfo.maxCount with the number of a species the player owns
   Count = function(self)
      if self.speciesID then
         self.count,self.maxCount = C_PetJournal.GetNumCollectedInfo(self.speciesID)
      end
   end,
   -- the regular level is an Info function (which this will use if .level not defined)
   FullLevel = function(self)
      local xp = self.xp
      if xp then
         self.fullLevel = self.level + (xp/self.maxXp)
      else
         self.fullLevel = self.level
      end
   end,
   -- whether a pet is wrapped
   Fanfare = function(self)
      self.needsFanfare = self.idType=="pet" and C_PetJournal.PetNeedsFanfare(self.petID)
   end,
   -- whether a pet isDead
   Dead = function(self)
      if self.maxHealth and self.maxHealth > 0 then
         self.isDead = self.health==0
         self.isInjured = self.health<self.maxHealth
      end
   end,
   -- this fills petInfo.breedID and petInfo.breedName depending on which breed addon is enabled, if any
   Breed = function(self)
      local source = rematch:GetBreedSource()
      local idType = self.idType
      if source and self.valid and self.canBattle and (idType=="pet" or idType=="link" or idType=="battle") then
         local breedID, breedName
         if source=="BattlePetBreedID" then
            if idType=="pet" or idType=="link" then
               breedID = BPBID_Internal.CalculateBreedID(self.speciesID,self.rarity,self.level,self.maxHealth,self.power,self.speed,false,false)
            elseif idType=="battle" then
               breedID = BPBID_Internal.breedCache[self.battleIndex + (self.battleOwner==2 and 3 or 0)]
            end
         elseif source=="PetTracker_Breeds" then
            if idType=="pet" then
               breedID = PetTracker.Journal:GetBreed(self.petID)
            elseif idType=="link" then
               breedID = PetTracker.Predict:Breed(self.speciesID,self.level,self.rarity,self.maxHealth,self.power,self.speed)
            elseif idType=="battle" then
               breedID = PetTracker.Battle:Get(self.battleOwner,self.battleIndex):GetBreed()
            end
            if breedID then
               breedName = PetTracker:GetBreedIcon(breedID,.85) -- using PetTracker's breed icon
            end
         elseif source=="PetTracker" then
            if idType=="pet" then
               breedID = PetTracker.Pet(self.petID):GetBreed()
            elseif idType=="link" then
               breedID = PetTracker.Predict:Breed(self.speciesID,self.level,self.rarity,self.maxHealth,self.power,self.speed)
            elseif idType=="battle" then
                breedID = PetTracker.Battle(self.battleOwner,self.battleIndex):GetBreed()
            end
            if breedID and not RematchSettings.PetTrackerLetterBreeds then
               breedName = PetTracker.Breeds:Icon(breedID,0.85)
            end
         elseif source=="LibPetBreedInfo-1.0" then
            if idType=="pet" then
               breedID = breedLib:GetBreedByPetID(self.petID)
            elseif idType=="link" then
               breedID = breedLib:GetBreedByStats(self.speciesID,self.level,self.rarity,self.maxHealth,self.power,self.speed)
            elseif idType=="battle" then
               breedID = breedLib:GetBreedByPetBattleSlot(self.battleOwner,self.battleIndex)
            end
         end
         -- make unknown breeds breedID 0 and named "NEW" if no known breeds or "???" otherwise
         if type(breedID)~="number" then
            breedID = 0
            breedName = self.numPossibleBreeds==0 and "NEW" or "???"
         end
		 self.breedID = breedID
         self.breedName = breedName or breedNames[breedID]
         self.hasBreed = true
      else
         self.hasBreed = false
      end
   end,
   -- for possibleBreedIDs and possibleBreedNames, only need a speciesID (and a breed source)
   PossibleBreeds = function(self)
      wipe(hiddenTables[self].possibleBreedIDs)
      wipe(hiddenTables[self].possibleBreedNames)
      local possibleBreedIDs = hiddenTables[self].possibleBreedIDs
      local possibleBreedNames = hiddenTables[self].possibleBreedNames
      local source = rematch:GetBreedSource()
      local speciesID = self.speciesID
      if source and type(speciesID)=="number" and self.canBattle then
         local data -- the table that contains possible breeds
         if source=="BattlePetBreedID" then
            if not BPBID_Arrays.BreedsPerSpecies then
               BPBID_Arrays.InitializeArrays()
            end
            data = BPBID_Arrays.BreedsPerSpecies[speciesID]
         elseif source=="PetTracker_Breeds" then
            data = PetTracker.Breeds[speciesID]
         elseif source=="PetTracker" then
            data = PetTracker.SpecieBreeds[speciesID]
         elseif source=="LibPetBreedInfo-1.0" then
            data = breedLib:GetAvailableBreeds(speciesID)
         end
         -- if there's a table of breeds, copy them to possibleBreeds
         if data and type(data)=="table" then
            for _,breed in ipairs(data) do
               tinsert(possibleBreedIDs,breed)
               if source=="PetTracker_Breeds" then
                  tinsert(possibleBreedNames,PetTracker:GetBreedIcon(breed,0.85))
               elseif source=="PetTracker" and not RematchSettings.PetTrackerLetterBreeds then
                  tinsert(possibleBreedNames,PetTracker.Breeds:Icon(breed,0.85))
               else
                  tinsert(possibleBreedNames,breedNames[breed])
               end
            end
         end
         self.possibleBreedIDs = possibleBreedIDs
         self.possibleBreedNames = possibleBreedNames
         self.numPossibleBreeds = #possibleBreedIDs
      end
   end,
   -- pulls battleOwner and battleIndex from the "battle" petID
   Battle = function(self)
      if self.idType=="battle" then
         local owner,index = self.petID:match("battle:(%d):(%d)")
         self.battleOwner = tonumber(owner)
         self.battleIndex = tonumber(index)
      end
   end,
   -- whether the pet is slotted
   Slotted = function(self)
      local idType = self.idType
      self.isSlotted = (idType=="pet" and C_PetJournal.PetIsSlotted(self.petID)) or (idType=="battle" and self.battleOwner==1)
   end,
   -- pulls the number of teams the pet of interest belongs to
   Teams = function(self)
      -- defining the actual stats inTeams and numTeams
      local idType = self.idType
      if idType=="pet" or idType=="species" then
         local numTeams = rematch.petsInTeams[self.petID] or 0
         self.inTeams = numTeams>0
         self.numTeams = numTeams
      end
   end,
   -- sourceID is source pet filter category (1=Drop, 2=Vendor, 3=Quest, etc)
   Source = function(self)
      self.sourceID = rematch.sourceIDs[self.speciesID]
   end,
   -- moveset is the list of abilityIDs separated by commas like "429,492,538,535,357,536" for a black tabby cat
   Moveset = function(self)
      self.moveset = rematch.movesetsBySpecies[self.speciesID]
   end,
   SpeciesAt25 = function(self)
      self.speciesAt25 = rematch.speciesAt25[self.speciesID] and true
   end,
   Notes = function(self)
		local speciesID = self.speciesID
		self.notes = RematchSettings.PetNotes[speciesID]
		if self.notes then
			self.hasNotes = true
		end
   end,
   IsLeveling = function(self)
		self.isLeveling = self.owned and rematch:IsPetLeveling(self.petID)
   end,
   IsSummoned = function(self)
		self.isSummoned = C_PetJournal.GetSummonedPetGUID() == self.petID
   end,
   Expansion = function(self)
      local speciesID = self.speciesID
      local expansionID
      local idType = self.idType
      if idType=="leveling" or idType=="random" or idType=="ignored" then
         return
      end
      -- first check if this is one of the species that doesn't fit into an expansion's range
      if expansionOutliers[speciesID] then
         expansionID = expansionOutliers[speciesID]
         self.expansionID = expansionID
         self.expansionName = _G["EXPANSION_NAME"..expansionID]
         return
      end
      -- start at expansionID 0 and work upward, comparing speciesID to the expansion's range of speciesIDs
      local expansionID = 0
      while expansionRanges[expansionID] do
         if speciesID >= expansionRanges[expansionID][1] and speciesID <= expansionRanges[expansionID][2] then
            self.expansionID = expansionID
            self.expansionName = _G["EXPANSION_NAME"..expansionID]
            return
         end
         expansionID = expansionID + 1
      end
   end,
   CanLevel = function(self)
      local level = self.level
      local canBattle = self.canBattle
      self.canLevel = level and level<25 and canBattle
   end,
}

-- rematch:GetBreedSource() is used by the Breed and PossibleBreeds API
-- the first time this runs it looks for a breed addon enabled and returns it
-- future runs will just return the saved source (so this only looks for a breed addon once)
-- addons are used in this priority: BattlePetBreedID, PetTracker_Breeds then LibPetBreedInfo-1.0
function rematch:GetBreedSource()
   if breedSource==nil then
      if IsAddOnLoaded("BattlePetBreedID") then
         breedSource = "BattlePetBreedID"
         return "BattlePetBreedID"
      elseif IsAddOnLoaded("PetTracker_Breeds") and GetAddOnMetadata("PetTracker_Breeds","Version")~="7.1.4" then
         if not PetTracker.Pet then -- only set this source if new PetTracker isn't enabled (PetTracker has its own issues when this is enabled alongside newer versions that don't include this)
            breedSource = "PetTracker_Breeds"
            return "PetTracker_Breeds"
         end
      elseif IsAddOnLoaded("PetTracker") and PetTracker and PetTracker.Pet and PetTracker.Pet.GetBreed then
         breedSource = "PetTracker"
         return "PetTracker"
      end
      -- one of the sources is not loaded, try loading LibPetBreedInfo separately
      LoadAddOn("LibPetBreedInfo-1.0")
      if LibStub then
         for lib in LibStub:IterateLibraries() do
            if lib=="LibPetBreedInfo-1.0" then
			   breedLib = LibStub("LibPetBreedInfo-1.0")
			   if lib then
				 breedSource = lib
				 return lib
			   end
            end
         end
      end
      breedSource = false -- none found, only attempt to find a source once
   end
   return breedSource
end

-- either "text" or "icon", the format of breed to display
function rematch:GetBreedFormat()
   local source = rematch:GetBreedSource()
   if source=="PetTracker_Breeds" or (source=="PetTracker" and not RematchSettings.PetTrackerLetterBreeds) then
      return "icon"
   else
      return "text"
   end
end

-- returns the name of a breed by its ID (used by PetMenus' breed menu; not petInfo)
function rematch:GetBreedNameByID(breedID)
   local breedSource = rematch:GetBreedSource()
	if breedSource=="PetTracker_Breeds" then
      return PetTracker:GetBreedIcon(breedID,.85)
   elseif breedSource=="PetTracker" and PetTracker.Breeds.Names[breedID] and not RematchSettings.PetTrackerLetterBreeds then
      return PetTracker.Breeds:Icon(breedID,.85) .. " " .. PetTracker.Breeds.Names[breedID]
	else
		return breedNames[breedID]
	end
end

local reset -- function used in fetch and petInfo, definining it after fetch

-- makes a petID the "pet of interest" to a petInfo(self)
-- if journal is true, the petID is guaranteed to be a valid owned petID or a valid speciesID
local function fetch(self,petID,journal)
   if petID~=self.petID then
      reset(self)
      self.petID = petID
      if journal then
         self.idType = type(petID)=="string" and "pet" or "species"
      else
         self.idType = getIDType(petID)
      end
   end
   return self
end

-- wipes a petInfo(self) for new data
function reset(self)
   wipe(self)
   wipe(hiddenTables[self].fetchedAPI)
   self.Fetch = fetch
   self.Reset = reset
end

-- __index lookup when stat(index) is nil
-- if its API has not been fetched yet, call the API to fill in stats
-- then return the fetched value (or the old nil if it's been fetched before)
local function lookup(self,stat)
   local api = apiByStat[stat]
   local fetchedAPI = hiddenTables[self].fetchedAPI
   if api and not fetchedAPI[api] and queryAPIs[api] then
      fetchedAPI[api] = true
      queryAPIs[api](self)
   end
   return rawget(self,stat)
end

-- this creates a new petInfo and returns it
function rematch:CreatePetInfo()
   local info = {}
   hiddenTables[info] = {
      fetchedAPI = {}, -- lookup of API functions that have been called for current pet
      abilityList = {}, -- cached result of C_PetJournal.GetPetAbilityList
      levelList = {}, -- cached result of C_PetJournal.GetPetAbilityList
      possibleBreedIDs = {}, -- table of breedIDs possible for a speciesID
      possibleBreedNames = {}, -- table of breedNames possible for a speciesID
   }
   reset(info)
   setmetatable(info,{__index=lookup})
   return info
end

-- create two petInfos for use in the addon

rematch.petInfo = rematch:CreatePetInfo()
rematch.altInfo = rematch:CreatePetInfo()
