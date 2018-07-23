--[[
   This module handles the conversion of sidelined teams into strings and vice versa.

   Old string format: <name>:<npcID>:<speciesID>:<abilityID>:<abilityID>:<abilityID>:
      <speciesID>:<abilityID>:<abilityID>:<abilityID>:<speciesID>:<abilityID>:
      <abilityID>:<abilityID>:

   New string format: <name>:<npcID>:<petTag>:<petTag>:<petTag>:

   Preferences format: P:<minHP>:<allowMM>:<expectedDD>:<maxHP>:<minXP>:<maxXP>:
   (in old format, empty fields have a 0; in new format, fields can be empty: "P:::5:")

   Optional notes must be at the end of the string:
   N:<notes text to end of line>

   rematch:ConvertSidelineToString()
   rematch:ConvertStringToSideline()
   rematch:ConvertSidelineToPlainText()
]]

local _,L = ...
local rematch = Rematch

-- import patterns
local patterns = {
	legacyTeam = "^([^\n]-):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(.*)",
   team = "^([^\n]-):(%w*):(%w+):(%w+):(%w+):(.*)",
   prefs = "P:(%d*):(%d*):(%d*):(%d*):([%d%.]*):([%d%.]*):(.*)",
	notes = "N:(.+)",
}

-- patterns for exporting teams into plain text
local exportStubs = {
	title_npcID_only = L["%s (NPC#%d)"], -- 1=name of npc, 2=npcID
	title_npcID_name = L["%s (%s NPC#%d)"], -- 1=name of team, 2=name of npc, 3=npcID
	pet_basic = L["%d: %s"], -- 1=slot, 2=pet name
	pet_with_abilities = L["%d: %s (%d,%d,%d)"], -- 1=slot, 2=pet name, 3-5=1/2 ability
	prefs = L["Preferred leveling pets: %s."], -- 1=concatenated string of preferences
	minHP_basic = L["at least %d health"], -- 1=minHP
	minHP_allowMM = L["at least %d health (or any Magic/Mechanical)"], -- 1=minHP
	minHP_expectedDD = L["at least %d health (%s damage expected)"], -- 1=minHP, 2=expectedDD text
	minHP_allowMM_expectedDD = L["at least %d health (or any Magic/Mechanical, %s damage expected)"], -- 1=minHP, 2=expectedDD text (", " critical!)
	maxHP = L["at most %d health"], -- 1=maxHP
	minXP = L["at least level %s"], -- 1=minXP
	maxXP = L["at most level %s"], -- 1=maxXP
}

-- converts an existing sideline into a team string
function rematch:ConvertSidelineToString()
   local team,key = rematch:GetSideline()
   local legacy = RematchSettings.UseLegacyExport
   local teamString
   if key then
      local result = rematch.info
      wipe(result)
      -- start with name of team
      tinsert(result,tonumber(key) and team.teamName or key)
      -- add the target npcID
      if type(key)=="number" then -- this team has a target npcID
         tinsert(result,legacy and key or rematch:ToBase32(key))
      else -- this team does not have an npcID
         tinsert(result,legacy and "0" or "")
      end
      -- then a tag for each of the three pets
      for i=1,3 do
         local petID,ability1,ability2,ability3 = team[i][1],team[i][2],team[i][3],team[i][4]
         local petInfo = rematch.petInfo:Fetch(petID)
         if not petInfo.valid then
            petID = team[i][5] -- if petID isn't valid, use the saved speciesID
            -- if no saved speciesID it's ok, petID will be nil and pet unknown (ZU)
         end
         if not legacy then -- for new format, add PetTag
            tinsert(result,rematch:CreatePetTag(petID,ability1,ability2,ability3))
         else -- for legacy format, add speciesID and abilities
            tinsert(result,petInfo.speciesID or 0)
            tinsert(result,ability1 or 0)
            tinsert(result,ability2 or 0)
            tinsert(result,ability3 or 0)
         end
      end

      -- string so far is name, npcID and pet tags
      teamString = table.concat(result,":")..":"

      -- add preferences if team has any
      if rematch:HasPreferences(team) and not RematchSettings.DontIncludePreferences then
         local emptyField = legacy and "0" or "" -- field to use for empty values
         wipe(result)
         tinsert(result,"P")
         tinsert(result,team.minHP or emptyField)
         tinsert(result,team.allowMM and "1" or emptyField)
         tinsert(result,team.expectedDD or emptyField)
         tinsert(result,team.maxHP or emptyField)
         tinsert(result,team.minXP or emptyField)
         tinsert(result,team.maxXP or emptyField)
         teamString = teamString .. table.concat(result,":")..":"
      end

      -- add notes if team has any
      if team.notes and team.notes:trim()~="" and not RematchSettings.DontIncludeNotes then
         teamString = teamString .. format("N:%s",team.notes):gsub("\n","\\n")
      end

      return teamString
   end
end

function rematch:ConvertStringToSideline(text)
   if type(text)=="string" then
      if rematch:AttemptLegacyStringToSideline(text:match(patterns.legacyTeam)) then
         return "legacy teamstring sidelined for "..rematch:GetSidelineTitle()
      elseif rematch:AttemptStringToSideline(text:match(patterns.team)) then
         return "teamstring sidelined for "..rematch:GetSidelineTitle()
      else
         return false
      end
   end
end

-- legacy teamstrings will be converted to the normal format during conversion
function rematch:AttemptLegacyStringToSideline(...)
   local name,npcID = ...
   if name and npcID then -- there was a pattern match, convert to normal format
      local tags = rematch.info
      wipe(tags)
      for i=1,3 do
         local speciesID,a1,a2,a3 = select(3+(i-1)*4,...)
         local tag = rematch:CreatePetTag(tonumber(speciesID),tonumber(a1),tonumber(a2),tonumber(a3))
         tinsert(tags,tag)
      end
      return rematch:AttemptStringToSideline(name,rematch:ToBase32(npcID),tags[1],tags[2],tags[3],select(15,...))
   end
end

function rematch:AttemptStringToSideline(...)
   local name,npcID = ...
   if name and npcID then -- there was a pattern match, attempt to parse new teamstring
      -- sideline a blank team, keyed to npcID if one exists, by name otherwise
      local team,key
      if npcID=="" or npcID=="0" then -- this is a team without an npcID
         team,key = rematch:SetSideline(name,{})
      else
         team,key = rematch:SetSideline(tonumber(npcID,32),{teamName=name})
      end
      -- assign tab to current tab
      team.tab = RematchSettings.SelectedTab>1 and RematchSettings.SelectedTab or nil
      -- now add pets
      local otherPetIDs = rematch.info
      wipe(otherPetIDs)
      for i=3,5 do
         local petTag = select(i,...)
         local petID = rematch:FindPetFromPetTag(petTag,otherPetIDs[1],otherPetIDs[2])
         if type(petID)=="string" then -- if an actual petID was found (not a speciesID)
            tinsert(otherPetIDs,petID) -- add this pet to otherPetIDs so it doesn't get reused
         end
         team[i-2] = {petID,rematch:GetAbilitiesFromTag(petTag)}
      end
      -- attempt to get preferences and notes
      local extras = select(6,...)
      if extras and extras~="" then
         if extras:match(patterns.prefs) then
            rematch:AttemptStringExtrasToSideline("P",extras:match(patterns.prefs))
         elseif extras:match(patterns.notes) then
            rematch:AttemptStringExtrasToSideline("N",extras:match(patterns.notes))
         end
      end
      return true
   end
end

-- for preferences: takes a string and returns it in number form if it's not "" or "0"
local function getNumber(stat)
   if stat=="" or stat=="0" then
      return nil
   else
      return tonumber(stat)
   end
end

-- this will add either preferences or notes from a string to a team
-- the first parameter should be "P" for preferences and "N" for notes
-- the remaining parameters are the matches from a prefs or notes pattern
-- NOTE: notes must always be last extras!
function rematch:AttemptStringExtrasToSideline(...)
   local extraType = ...
   local team,key = rematch:GetSideline()
   -- if these are preferences, add their values
   if extraType=="P" then
      team.minHP = getNumber(select(2,...))
      team.allowMM = select(3,...)=="1" and true or nil
      team.expectedDD = getNumber(select(4,...))
      team.maxHP = getNumber(select(5,...))
      team.minXP = getNumber(select(6,...))
      team.maxXP = getNumber(select(7,...))
      -- call this function again with remainder if remainder matches notes pattern
      local extras = select(8,...)
      if extras and extras:match(patterns.notes) then
         rematch:AttemptStringExtrasToSideline("N",extras:match(patterns.notes))
      end
   end
   -- if these are notes, add the notes
   if extraType=="N" then
      local notes = select(2,...)
      if notes then
         team.notes = notes:gsub("\\n","\n")
      end
   end
end

-- returns true if the passed name,npcID form an already-used team key
local function isKeyUsed(name,npcID)
	if not npcID or npcID==0 then
		return RematchSaved[name] and true
	else
		return RematchSaved[tonumber(npcID)] and true
	end
end


-- if text contains string teams, returns the number of teams and the number of those keys
-- already used for an existing saved team. the first team is sidelined. if gather given
-- as a table, string lines are added to it
function rematch:TestTextForStringTeams(text,gather)
	text = (text or ""):trim()
	if text=="" then return end
   local numTeams = 0 -- number of teams in the text
   local numUsedKeys = 0 -- number of keys already used by an existing saved team
   for line in text:gmatch("[^\n]+") do
      line = line:trim()
      local name,npcID = rematch:GetTeamStringNameAndNpcID(line)
      if name then
         if type(gather)=="table" then
            tinsert(gather,line)
         else
            if numTeams==0 then -- if this is the first team, sideline it
               rematch:ConvertStringToSideline(line)
               rematch.Dialog:SetContext("plain",nil)
            end
            numTeams = numTeams + 1
            if isKeyUsed(name,npcID) then
               numUsedKeys = numUsedKeys + 1
            end
         end
      end
   end
   if numTeams>0 then
      return numTeams,numUsedKeys
   end
end

-- returns name and npcID of the given line if it contains a teamstring
-- (note npcID can be nil!)
-- returns nil if line was not a team string
function rematch:GetTeamStringNameAndNpcID(line)
   -- have to check legacy first because name:123:456:789:etc will match new team pattern
   local name,npcID = line:match(patterns.legacyTeam)
   if npcID then -- there was a match, this is a legacy team
      npcID = tonumber(npcID)
      if npcID==0 then -- if npcID is 0 then nil it
         npcID = nil
      end
   else -- legacy didn't match, check for new team pattern
      name,npcID = line:match(patterns.team)
      if npcID then
         npcID = tonumber(npcID,32)
      end
   end
   return name,npcID
end


-- returns the sidelined team in plain-text format (or nil if it can't)
function rematch:ConvertSidelineToPlainText()
	local result = {}
	local team,key = rematch:GetSideline()
	if not key then return end -- no team sidelined, leave

	if type(key)=="number" then
		local npcName = rematch:GetNameFromNpcID(key)
		if npcName==team.teamName then -- name of team is same as npcID: "Name of Team (NPC#123)"
			tinsert(result,format(exportStubs.title_npcID_only,npcName,key))
		else -- name of team is different from npcID: "Name of Team (Name of NPC (NPC#123)"
			tinsert(result,format(exportStubs.title_npcID_name,team.teamName,npcName,key))
		end
	else -- named team, no npcID; first line is just the name of the team
		tinsert(result,key)
	end

	tinsert(result,"") -- blank line separating title from rest

	-- pets and abilities (1: Name of Pet (2/2/1)
	for i=1,3 do
		local speciesID, ability1, ability2, ability3 = rematch:ExportPet(team[i],3)
		if speciesID and not rematch:GetSpecialPetIDType(speciesID) then
			local name = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
			if name then
				if ability3 then
					tinsert(result,format(exportStubs.pet_with_abilities,i,name,ability1,ability2,ability3))
				else
					tinsert(result,format(exportStubs.pet_basic,i,name))
				end
			end
		else
         local petName = L["Leveling Pet"]
         if rematch:GetSpecialPetIDType(speciesID) then
            petName = rematch:GetSpecialTooltip(speciesID) or petName
         end
         tinsert(result,format(exportStubs.pet_basic,i,petName))
		end
	end

	-- Preferred leveling pets: at least 700 health (or any magic/mechanical, dragonkin damage expected); at most 1200 health; at least level 5; at most level 24.5.
	if rematch:HasPreferences(team) and not RematchSettings.DontIncludePreferences then
		tinsert(result,"")
		local subprefs = {}
		if team.minHP then
			local ddType = team.expectedDD and _G["BATTLE_PET_NAME_"..team.expectedDD]
			if team.allowMM and team.expectedDD then
				tinsert(subprefs,format(exportStubs.minHP_allowMM_expectedDD,team.minHP,ddType))
			elseif team.allowMM and not team.expectedDD then
				tinsert(subprefs,format(exportStubs.minHP_allowMM,team.minHP))
			elseif not team.allowMM and team.expectedDD then
				tinsert(subprefs,format(exportStubs.minHP_expectedDD,team.minHP,ddType))
			else
				tinsert(subprefs,format(exportStubs.minHP_basic,team.minHP))
			end
		end
		if team.maxHP then
			tinsert(subprefs,format(exportStubs.maxHP,team.maxHP))
		end
		if team.minXP then
			tinsert(subprefs,format(exportStubs.minXP,team.minXP))
		end
		if team.maxXP then
			tinsert(subprefs,format(exportStubs.maxXP,team.maxXP))
		end
		-- combine all of the above to "Preferred leveling pets: (stubs separated by a ;)."
		tinsert(result,format(exportStubs.prefs,table.concat(subprefs,"; ")))
	end

	-- notes if any
	if team.notes and not RematchSettings.DontIncludeNotes then
		tinsert(result,"")
		tinsert(result,team.notes:trim())
	end

	return table.concat(result,"\n")
end
