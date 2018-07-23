
local _,L = ...
local rematch = Rematch
local settings, saved

-- loadin is a team table filled with the pets and abilities to load
-- LoadTeam(teamName) fills the table
-- LoadLoadIn() actually loads the pets/abilities (and removes from table)
-- when loadin is empty, the team is done loading
local loadin = {{},{},{}}
local loadingKey -- key of team being loaded
local loadTimeout -- LoadLoadIn attempts (max 10)
local missing = {} -- slots that have a missing pet (indexed by slot, equals petID if a substitue found, true otherwise)

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved
end)

function rematch:LoadTeam(key)

	local team = saved[key]
	if not team then return end

	local title = rematch:GetTeamTitle(key)

	if InCombatLockdown() then
		rematch:print(L["You can't load a team during combat."])
		return
	elseif C_PetBattles.IsInBattle() then
		rematch:print(L["You can't load a team during a pet battle."])
		return
	elseif C_PetBattles.GetPVPMatchmakingInfo() then
		rematch:print(L["You can't load a team in a matched pet battle."])
		return
	end

	rematch.TeamPanel:NotifyTeamLoading(L["Loading..."]) -- desaturate loaded team and say it's loading

	loadingKey = key --  note what team we're about to load

	for i=1,3 do wipe(loadin[i]) end -- start with clean loadin
	wipe(missing) -- and clean missing

	-- fill loadin from the team
	local pickIndex = 1
   local numRandomSlots = 0
	for i=1,3 do
		local petID = team[i][1]
		local levelingPick = rematch.topPicks[pickIndex]
		if petID==0 and levelingPick then
			loadin[i][1] = rematch.topPicks[pickIndex]
			pickIndex = pickIndex + 1
      elseif petID=="ignored" then
         loadin[i][1] = C_PetJournal.GetPetLoadOutInfo(i) -- keep loaded pet here if ignored
      elseif rematch:GetSpecialPetIDType(petID)=="random" then
         loadin[i][1] = petID -- will come back to this pet later
         numRandomSlots = numRandomSlots + 1
		elseif petID and petID~=0 then
         local idType = rematch:GetIDType(petID)
			if idType=="species" then
				-- if pet is a speciesID, look for a temporary petID (sanctuary failed to find one)
				petID = rematch:FindTemporaryPetID(petID,team[1][1],team[2][1],team[3][1])
				missing[i] = petID or true
			elseif idType=="pet" and not C_PetJournal.GetPetInfoByPetID(petID) then
				-- if pet is a real petID but not valid, look for a temporary petID (sanctuary failed to find one)
				petID = rematch:FindTemporaryPetID(team[i][5],team[1][1],team[2][1],team[3][1])
				missing[i] = petID or true
			end
			if petID and idType=="pet" and not C_PetJournal.PetIsRevoked(petID) then
				loadin[i][1] = petID
				local speciesAbilities = rematch:GetAbilities(team[i][5])
				for j=1,3 do
					local abilityID = team[i][j+1]
					if abilityID and abilityID~=0 then
						-- confirm the ability still exists in that slot for the species before marking it to be loaded
						if not speciesAbilities[j] or speciesAbilities[j]==abilityID or speciesAbilities[j+3]==abilityID then
							loadin[i][j+1] = abilityID
						end
					end
				end
			end
		end
	end

   -- replace random petIDs with a random pet after loadin filled, to prevent later slot's
   -- pet being chosen as a random pet for an earlier slot
   for slot=1,3 do
      if rematch:GetSpecialPetIDType(loadin[slot][1])=="random" then
         -- make sure random pet isn't one that's going to be loaded in another slot
         local next1 = slot%3+1
         local noPetID1 = loadin[next1][1] -- it's ok if these are nil
         local next2 = next1%3+1
         local noPetID2 = loadin[next2][1]
         -- then pick a random pet from the random petID (that's not already loaded)
         -- if 3 slots are random, pass true for evenInTeams flag to pick pets in teams too
         local petID = rematch:PickRandomPet(loadin[slot][1],team[1][1],team[2][1],team[3][1],numRandomSlots==3)
         loadin[slot][1] = petID
         if petID and settings.RandomAbilitiesToo then
            local petInfo = rematch.petInfo:Fetch(petID)
            for i=1,3 do
               loadin[slot][i+1] = petInfo.abilityList[i+(random(100)>50 and 3 or 0)]
            end
         elseif not petID then
            missing[slot] = true
         end
      end
   end

	-- if "Load Healthiest Pet" enabled, go through loadin to look for injured/dead pets and replace
	if settings.LoadHealthiest then
		rematch:FindHealthiestLoadIn()
	end

	-- start loading pets
	if rematch:LoadLoadIn() then -- if first pass finished, we're done!
		rematch:LoadingDone()
	else -- if not, come back in 0.2 seconds to load more
		loadTimeout = 0
		rematch:StartTimer("ReloadLoadIn",0.2,rematch.ReloadLoadIn)
	end

	rematch:HideNotes()
end

-- this will go through loadin and find the healthiest version of pets
function rematch:FindHealthiestLoadIn()
	for i=1,3 do
		local petID = loadin[i][1] -- the petID we intend to load
		-- if pet is not missing/substituted and it's not a leveling pet
		if petID and not missing[i] and not rematch:IsPetLeveling(petID) then
			local health,maxHealth,power,speed = rematch:GetPetStats(petID)
			if health and health<maxHealth then
				local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
				if C_PetJournal.GetNumCollectedInfo(speciesID)>1 then -- if player has more than one
					local healthiestPetID = petID
					for cPetID in rematch.Roster:AllOwnedPets() do
						local cSpeciesID,_,cLevel = C_PetJournal.GetPetInfoByPetID(cPetID)
						if cSpeciesID==speciesID and (settings.LoadHealthiestAny or cLevel==level) then
                     local cHealth,cMaxHealth,cPower,cSpeed = rematch:GetPetStats(cPetID)
							if cHealth>health and (settings.LoadHealthiestAny or (cMaxHealth==maxHealth and cPower==power and cSpeed==speed)) then
								local isTeammate -- prevent substituting a version that's going to another slot
								for j=1,3 do
									if i~=j and loadin[j][1]==cPetID then
										isTeammate = true
									end
								end
								if not isTeammate then
									healthiestPetID = cPetID
								end
							end
						end
					end
					-- found a healthier version of the pet, replace it in the loadin
					if healthiestPetID and healthiestPetID~=petID then
						loadin[i][1] = healthiestPetID
					end
				end
			end
		end
	end
end

-- actually load the pets in the loadin table filled in LoadTeam
-- returns true if team loaded fully; false otherwise
function rematch:LoadLoadIn()
	local loadout = rematch.info
	wipe(loadout)

	-- now attempt to load all pets/abilities that are defined
	for slot=1,3 do
		loadout[1],loadout[2],loadout[3],loadout[4] = C_PetJournal.GetPetLoadOutInfo(slot)
		-- pet slot
		if loadin[slot][1] and loadin[slot][1] ~= loadout[1] then
			rematch:SlotPet(slot,loadin[slot][1])
		end
		-- ability slots
		for i=1,3 do
			local abilityID = loadin[slot][i+1]
			if abilityID and loadout[i+1]~=abilityID then
				C_PetJournal.SetAbility(slot,i,abilityID)
			end
		end
	end

	-- now nil out the pets/abilities that loaded successfully
	for slot=1,3 do
		loadout[1],loadout[2],loadout[3],loadout[4] = C_PetJournal.GetPetLoadOutInfo(slot)
		for i=1,4 do
			if loadin[slot][i]==loadout[i] then
				loadin[slot][i] = nil
			end
		end
	end

	-- if anything left in loadin, return false; everything didn't load
	for i=1,3 do
		for j=1,4 do
			if loadin[i][j] then
				return false
			end
		end
	end

	-- if we made it this far, return true; everything loaded
	return true

end

function rematch:ReloadLoadIn()
	if rematch:LoadLoadIn() then
		rematch:LoadingDone()
	elseif loadTimeout<20 then
		loadTimeout = loadTimeout + 1
		rematch:StartTimer("ReloadLoadIn",0.25,rematch.ReloadLoadIn)
	else
		rematch:LoadingDone(true)
	end
end

function rematch:LoadingDone(unsuccessful)
	if unsuccessful then
		rematch:UnloadTeam()
	else
		settings.loadedTeam = loadingKey
	end
	-- if loadouts visible, do a "bling" flash to indicate load happened
	if rematch.LoadoutPanel:IsVisible() then
		for i=1,3 do
			rematch.LoadoutPanel.Loadouts[i].Bling:Show()
		end
	elseif rematch.MiniPanel:IsVisible() then
		rematch.MiniPanel.Bling:Show()
	end
	if rematch.LoadedTeamPanel:IsVisible() then
		rematch.LoadedTeamPanel.Bling:Show()
	end
	rematch:AssignSpecialSlots()
	rematch:UpdateQueue() -- team change may mean leveling pet preferences changed; this also does an UpdateUI

	-- ShowOnInjured to summon window if any loaded pets are injured
	if settings.AutoLoad and settings.ShowOnInjured and not rematch.Frame:IsVisible() and not rematch.Journal:IsVisible() then
		for i=1,3 do
			local petID = C_PetJournal.GetPetLoadOutInfo(i)
			if petID then
				local health,maxHealth = C_PetJournal.GetPetStats(petID)
				if health<maxHealth then
					rematch:AutoShow() -- a loadout pet is injured, show the standalone window
					break
				end
			end
		end
	end

	-- SafariHatShine to summon window if a team loads with a low level pet and the safari hat is not equipped
	if settings.SafariHatShine and not rematch.Frame:IsVisible() and not rematch.Journal:IsVisible() then
		local safariBuff = GetItemSpell(92738)
		if safariBuff and not rematch:UnitBuff(safariBuff) and rematch:IsLowLevelPetLoaded() then
			rematch:AutoShow()
		end
	end
		
	-- a pet was missing :( show the bad news if they don't have DontWarnMissing checked
	if next(missing) and not settings.DontWarnMissing then
		local substituted -- find out if any substitutions made
		for i=1,3 do
			if missing[i] and missing[i]~=true then
				substituted = true
			end
		end
		local dialog = rematch:ShowDialog("MissingPets",300,200+(substituted and 36 or 0),rematch:GetTeamTitle(loadingKey,true),nil,nil,nil,OKAY)
		dialog:ShowText(L["Pets are missing from this team!"],260,20,"TOP",0,-32)
		dialog.Text:SetJustifyH("CENTER")
		dialog.Team:SetPoint("TOP",dialog.Text,"BOTTOM",0,-4)
		dialog.Team:Show()
		dialog:FillTeam(dialog.Team,saved[loadingKey])
		if substituted then
			dialog.SmallText:SetSize(240,40)
			dialog.SmallText:SetPoint("TOP",dialog.Team,"BOTTOM",0,-4)
			dialog.SmallText:SetText(L["Substitutes were found. Please review the loaded team and click Save if you'd like to keep the chosen pets."])
			dialog.SmallText:Show()
		end
		dialog.CheckButton:SetPoint("BOTTOMLEFT",36,36)
		dialog.CheckButton.text:SetText(L["Don't Warn About Missing Pets"])
		dialog.CheckButton:SetScript("OnClick",function(self) settings.DontWarnMissing=self:GetChecked() end)
		dialog.CheckButton:Show()
		-- show the red border around the missing pets
		for i=1,3 do
			if missing[i] then
				dialog.Team.Pets[i].Missing:Show()
			end
		end
	end

	RematchWinRecordToast:Hide() -- if a winrecord toast is showing from a previous team, stop it

end

-- use this to wipe loadedTeam instead of setting it directly
function rematch:UnloadTeam()
	settings.loadedTeam = nil
	rematch:AssignSpecialSlots() -- will clear leveling slots
end
