--[[ The sideline is a place to put teams for intermediate use, such as when
		 saving, receiving, renaming, etc.

	Instead of ferrying parts of teams piecemeal through the dialogs, all
	interactions with teams will begin by placing them on the sideline. When
	done, they're pushed back into the saved teams.

	When starting to deal with a team:
		rematch:SetSideline("name of team" or npcID[,{team table},loadout])
			
	Any manipulation of this team should be from the return of:
		{team table}, "name of team", "orinal name" = rematch:GetSideline()
	If the name of the team needs changed:
		rematch:RenameSideline("name of team" or npcID)
			
	When the team is ready to get integrated into saved teams:
		rematch:PushSideline()

]]

local _,L = ...
local rematch = Rematch
local settings, saved

-- the table that contains the sideline team, will usually only have one:
-- { ["teamName" or npcID] = {team table} }
local sideline = {} 
-- context stores information about how the sideline is to be used, to be set
-- after a team is sidelined with rematch:SetSidelineContext("var",value) and
-- retrieved with rematch:GetSidelineContact("var")
-- wiped when a new team is sidelined with originalKey immediately added
local context = {}

-- keys into the team table for notes and preferences (that don't always get pushed)
local extraKeys = {"notes","minHP","allowMM","expectedDD","maxXP","minXP","maxHP"}

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved
end)

-- copies a table (max one sub-table deep)
local function copy(t1,t2)
	for k,v in pairs(t1) do
		if type(v)=="table" then
			t2[k] = {}
			for x,y in pairs(v) do
				t2[k][x] = y
			end
		else
			t2[k] = v
		end
	end
end

-- for named keys (that have to be unique), returns the key if it's already unused,
-- or key (2), key (3), etc until it finds an unused key
local function uniqueKey(key)
	if not saved[key] then
		return key -- name is already unique (not used for a team key)
	end
	local oldkey = key:match("(.+) %(%d%)") or key -- drop name (x) if it has one already
	local index = 2
	local newKey
	repeat
		newKey = format("%s (%d)",oldkey,index) -- name (2)
		index = index+1
	until not saved[newKey]
	return newKey
end

-- copies a team to the sideline. Used when starting to deal with a new
-- (or old) team. If a dialog can reappear (such as a save dialog returning
-- on a cancelled confirmation) this should be called before dialogs start
-- getting involved.
-- key: pass nil to generate a new unique name ("New Team (2)")
-- team: pass nil to generate a new team for current tab
-- loadout: pass true to copy loadout pets to the new sideline team
function rematch:SetSideline(key,team,loadout)
	wipe(sideline)
	wipe(context)

	key = key or uniqueKey(L["New Team"])

	-- special case for an imported team being sidelined
	if key==1 and team then
		key = team.teamName or rematch:GetNameFromNpcID(1)
	end

	sideline[key] = {}

	if type(team)=="table" then -- if team table alreayd provided, copy its data
		copy(team,sideline[key])
	else -- if not, we're forming a new team; set tab to current team tab
		sideline[key].tab = settings.SelectedTab>1 and settings.SelectedTab or nil
		if type(key)=="number" then -- if key is an npcID, set name of team
			sideline[key].teamName = rematch:GetNameFromNpcID(key)
		end
	end

	-- if loadout true, copy the currently loaded pets to the sidelined pet slots
	if loadout then
		for i=1,3 do
			local petID,ability1,ability2,ability3 = C_PetJournal.GetPetLoadOutInfo(i)
         local specialPetID = rematch:GetSpecialSlot(i)
         if specialPetID==0 then -- if this slot is queue controlled
				sideline[key][i] = {0}
         elseif specialPetID=="ignored" then -- ignored slot
            sideline[key][i] = {"ignored"}
         elseif specialPetID and rematch:GetSpecialPetIDType(specialPetID)=="random" then
            sideline[key][i] = {specialPetID}
			elseif petID then -- for normal pets, get its speciesID and add it too
				local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
				sideline[key][i] = {petID,ability1,ability2,ability3,speciesID}
			else -- empty slot?
				sideline[key][i] = {}
			end
		end
		-- if loaded team has notes and preferences, copy those to sideline too
		if settings.loadedTeam and saved[settings.loadedTeam] then
			for k,v in pairs(extraKeys) do
				sideline[key][v] = saved[settings.loadedTeam][v]
			end
		end
		rematch:SetSidelineContext("loadout",true) -- notes that this team was made from current pets
	end

	rematch:SetSidelineContext("originalKey",key)
	rematch:SetSidelineContext("originalName",type(key)=="number" and sideline[key].teamName or key)
	return sideline[key],key
end

-- copies existing sideline to a new team with newKey as index and deletes the old
-- REMEMBER: need to GetSideline() again because tables are changed!
function rematch:ChangeSidelineKey(newKey)
	local oldTeam, oldKey = rematch:GetSideline()
	if newKey and oldKey and newKey~=oldKey then
		sideline[newKey] = {}
		copy(oldTeam,sideline[newKey])
		sideline[oldKey] = nil
	end
end

-- returns the table of the sidelined team and its current key
function rematch:GetSideline()
	local teamKey,team = next(sideline)
	return team,teamKey
end

-- pushes the sideline team into RematchSaved huzzah!
function rematch:PushSideline()
	rematch:HideDialog()
	local team,key = rematch:GetSideline()
	local originalKey = rematch:GetSidelineContext("originalKey")
	local loadout = rematch:GetSidelineContext("loadout")
	local backupNotes -- place to store backup notes and preferences in case they shouldn't be pushed

	-- if a team saving over another existing team, backup existing team's notes/preferences
	if saved[key] then
		backupNotes = {}
		for k,v in pairs(extraKeys) do
			backupNotes[v] = saved[key][v]
		end
	end

	saved[key] = {} -- create new one with clean slate
	copy(team,saved[key]) -- copy sideline to saved

	-- if we just overwrote another existing team, restore its original notes/preferences if it had any
	-- unless the overwrite notes checkbox was used and OverwriteNotes is true
	if not (rematch:GetSidelineContext("AskingOverwriteNotes") and settings.OverwriteNotes) and not rematch:GetSidelineContext("deleteOriginal") and not rematch:GetSidelineContext("receivedTeam") then
		for k,v in pairs(extraKeys) do
			if backupNotes then
				saved[key][v] = backupNotes[v]
			else
				saved[key][v] = nil
			end
		end
	end

	if (loadout or settings.loadedTeam==originalKey) and (not rematch:GetSidelineContext("receivedTeam") or settings.loadedTeam==key) and not (InCombatLockdown() or C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo()) then
		-- this is the current pets being pushed, do anything related to loaded team here
		settings.loadedTeam = key
		-- Loadteam in case any funny business with imported/received teams (changed loaded team)
		-- also a LoadTeam will reassert leveling slots and run ProcessQueue
		rematch:LoadTeam(key)
	end

	-- add any new pets to the sanctuary
	for i=1,3 do
		rematch:AddToSanctuary(team[i][1],true)
	end

	if originalKey~=key and rematch:GetSidelineContext("deleteOriginal") then
		saved[originalKey] = nil
	end
	if type(key)=="string" then
		saved[key].teamName = nil -- don't keep redundant teamName when a team is keyed by its name
	end

   rematch.petsInTeams:Invalidate() -- next time petsInTeams used, get new data
	rematch:UpdateUI()
end

-- sets and returns single values from the sideline context table.
-- example: rematch:SetSidelineContext("loadout",true)
function rematch:SetSidelineContext(var,value) context[var]=value end
function rematch:GetSidelineContext(var) return context[var] end

-- returns the displayed name of the sidelined team
function rematch:GetSidelineTitle(color)
	local team,teamKey = rematch:GetSideline()
	if type(teamKey)=="number" then
		if color then
			return format("\124cffffffff%s\124r",team.teamName)
		else
			return team.teamName
		end
	else
		return teamKey
	end
end

-- Call when a sideline team needs to be made unique. (Creating a "New Team"
-- or when choosing "Save as a new team" in import/receive.)
-- If the sideline team's key is already unique, no changes are made.
-- If the key isn't unique, the key will be converted to a named key (if needed)
-- and a number appended to make it unique: "New Team (3)" "Aki the Chosen (2)"
function rematch:MakeSidelineUnique()
	local team,key = rematch:GetSideline()
	if not saved[key] then
		return -- team is already unique, that was easy!
	end
	-- all npcID-keyed teams that are not unique get their key changed to the team's name
	if type(key)=="number" then
		key = team.teamName
		team.teamName = nil
		rematch:ChangeSidelineKey(key)
		if not saved[key] then
			return -- text name of team for this npcID is unique
		end
	end
	-- at this point, key is a string that's not unique
	local newKey = uniqueKey(key)
	-- now, newKey is a unique key
	rematch:ChangeSidelineKey(newKey)
end
