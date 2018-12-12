--[[

	Where petInfo is an abstraction layer to easily get information about pets,
	teamInfo is an abstraction layer to easy get information about teams.

	Presently, the key in RematchSaved is a number for teams saved for a target
	(the number is the npcID) or a string for untargeted teams (name of team).

	Future considerations (NYI but things to keep in mind):
	- PetTags should be added to all teams at some point
	- The key for all saved teams will become an index in an ordered list
	- Multiple teams will be able to share the same target/npcID
	- Multiple targets/npcIDs will be able to exist in a single team
	- Sideline/share system should be switched to teamInfo also

	For teamInfo, the key serves the same purpose as the petID: a unique
	reference number for the team when it's fetched.

	To use, first create a teamInfo instance:
		local teamInfo = rematch:CreateTeamInfo()

	Then fetch a key to make it the team of interest:
		teamInfo:Fetch(key)
	
	After a team of interest is fetched, simply index the stat you want:
		print(teamInfo.name, "has", teamInfo.wins, "wins")

	The stat can be any one of:

		key: the unique identifier for the team
		name: the name of the team
		coloredName: the name of the team with attached color codes
		hasTarget: whether the team has a saved npcID
		target: the npcID saved in the team
		targetName: the name of the npcID
		needsSubName: whether the target name is different than team name
		petIDs: small table of petIDs (or speciesIDs or tags) in the team
		hasBadPetID: whether at least one pet has a bad petID (reassigned, caged or nil pet)
		tab: the tab (1 through max, never nil) that the team is in
		isFavorite: whether the team is favorited
		hasNotes: whether the team has any notes
		notes: the text of the team's notes
		hasPreferences: whether the team has any leveling preferences
		minHP: the minimum health leveling preference
		maxHP: the maximum health leveling preference
		minXP: the minimum level+xp leveling preference
		maxXP: the maximum level+xp leveling preference
		allowMM: allow magic & mechanical leveling preference
		expectedDD: the type of damage expected leveling preference
		hasLevelingSlot: whether the team has a leveling slot
		numLevelingSlots: the number of leveling slots on the team (0-3)
		wins: the number of wins in the team's win record
		losses: the number of losses in the team's win record
		draws: the number of draws in the team's win record
		battles: the total number of battles in the team's win record
]]

local _,L = ...
local rematch = Rematch
local saved, settings
local petInfo -- using a local petInfo to not step on any toes

rematch:InitModule(function()
	saved = RematchSaved
	settings = RematchSettings
	petInfo = rematch:CreatePetInfo()
end)

local apiByStat = {
	name="Info", hasTarget="Info", target="Info", tab="Info", isFavorite="Info",
	coloredName="ColoredName",
	targetName="TargetName", needsSubName="TargetName",
	petIDs="PetIDs", hasBadPetID="PetIDs",
	notes="Notes", hasNotes="Notes",
	minHP="Preferences", maxHP="Preferences", minXP="Preferences", maxXP="Preferences",
	allowMM="Preferences", expectedDD="Preferences", hasPreferences="Preferences",
	hasLevelingSlot="LevelingSlot", numLevelingSlots="LevelingSlot",
	wins="WinRecord", losses="WinRecord", draws="WinRecord", battles="WinRecord",
}

-- indexed by teamInfo table reference, this will contain reused tables like fetchedAPI
-- and petIDs to prevent garbage creation
local hiddenTables = {}

local queryAPIs = {
	Info = function(self)
		local key = self.key
		if type(key)=="number" then -- this team has a saved target/npcID
			self.target = key
			self.hasTarget = true
			 -- note the following assigns targetName if a teamName isn't stored, but a teamName
			 -- should be stored because targetName has to read a tooltip to get a name!
			self.name = saved[key].teamName or self.targetName
		else
			self.name = key
		end
		self.tab = saved[key].tab or 1
		self.isFavorite = saved[key].favorite and true
	end,
	-- breaking out to a separate function to reduce garbage creation
	ColoredName = function(self)
		self.coloredName = (self.hasTarget and "\124cffffffff" or "\124cffffd200")..self.name.."\124r"
	end,
	-- breaking out since GetNameFromNpcID lifts name off a tooltip (expensive call)
	TargetName = function(self)
		if self.hasTarget then
			local targetName = rematch:GetNameFromNpcID(self.key)
			self.targetName = targetName
			if self.name ~= targetName and not settings.HideTargetNames then -- HideTargetNames is "Hide Targets Below Teams"
				self.needsSubName = true -- if team name different than target name
			end
		end
	end,
	-- note these petIDs can be a speciesID, leveling ID, random ID, etc
	-- but if the petID is not valid it will replace it with a speciesID if possible
	PetIDs = function(self)
		local key = self.key
		local petIDs = hiddenTables[self].petIDs
		wipe(petIDs)
		for i=1,3 do
			local petID = saved[key][i][1]
			petInfo:Fetch(petID)
			if petInfo.valid then -- if petID looks ok, keep it
				petIDs[i] = petID
			else -- this is not a valid petID, see if there's a speciesID
				self.hasBadPetID = true
				petID = saved[key][i][5]
				petInfo:Fetch(petID)
				if petInfo.valid then
					petIDs[i] = petID
				end
			end
		end
		self.petIDs = petIDs
	end,
	Notes = function(self)
		local notes = saved[self.key].notes
		if notes then
			self.notes = notes
			self.hasNotes = true
		end
	end,
	Preferences = function(self)
		local team = saved[self.key]
		self.minHP = team.minHP
		self.maxHP = team.maxHP
		self.minXP = team.minXP
		self.maxXP = team.maxXP
		self.allowMM = team.allowMM
		self.expectedDD = team.expectedDD
		self.hasPreferences = self.minHP or self.maxHP or self.minXP or self.maxXP
	end,
	LevelingSlot = function(self)
		local team = saved[self.key]
		self.numLevelingSlots = 0
		for i=1,3 do
			if team[i][1]==0 then
				self.hasLevelingSlot = true
				self.numLevelingSlots = self.numLevelingSlots + 1
			end
		end
	end,
	WinRecord = function(self)
		local team = saved[self.key]
		self.wins = team.wins or 0
		self.losses = team.losses or 0
		self.draws = team.draws or 0
		self.battles = self.wins + self.losses + self.draws
	end,
} 

local reset -- function used in fetch and teamInfo, definining it after fetch

-- makes a key the "team of interest" to a teamInfo(self)
local function fetch(self,key)
	if key~=self.key then
		reset(self)
		if saved[key] then
			self.key = key
		end
	end
	return self
end

-- wipes a teamInfo(self) for new data
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
	if api and not fetchedAPI[api] and queryAPIs[api] and saved[self.key] then
		fetchedAPI[api] = true
		queryAPIs[api](self)
	end
	return rawget(self,stat)
end

-- this creates a new petInfo and returns it
function rematch:CreateTeamInfo()
	local info = {}
	hiddenTables[info] = {
		fetchedAPI = {}, -- lookup of API functions that have been called for current pet
		petIDs = {}, -- list of petIDs (or speciesIDs) in the team
		loadouts = {}, -- list of petIDs to load and their abilityIDs {petID,ab1,ab2,ab3} or {} if ignoring
	}
	reset(info)
	setmetatable(info,{__index=lookup})
	return info
end

-- create a teamInfo for use in the addon

rematch.teamInfo = rematch:CreateTeamInfo()
