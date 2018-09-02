-- Main.lua: Initialization, major variables/constants, event handling, timers

-- this frame is for events and timers, not to be displayed
local rematch = CreateFrame("Frame","Rematch")

-- localization
local _,L = ...
setmetatable(L,{__index=function(L,key) return key end})

local settings, saved

-- these are the panels to the UI
rematch.panels = {"RematchPetPanel","RematchLoadoutPanel","RematchTeamPanel","RematchQueuePanel",
									"RematchOptionPanel","RematchMiniPanel","RematchBottomPanel","RematchMiniQueue",
									-- the following are not real panels but are here so they update with the rest of the UI
									"RematchToolbar","RematchFrame","RematchTeamTabs","RematchLoadedTeamPanel" }

rematch.info = {} -- scratch table (never expect this to contain data from a previous execution path)
rematch.abilityList = {} -- scratch table for C_PetJournal.GetPetAbilityList
rematch.levelList = {} -- scratch table for C_PetJournal.GetPetAbilityList
rematch.recentTarget = nil -- the npcID of the most recent target
rematch.numOwnedPets = nil -- number of owned pets, noted to recognize when a pet is added/removed
rematch.queueNeedsProcessed = nil -- true when queue needs processed at next opportunity (left combat/battle/pvp)
rematch.breedNames = {} -- names of breeds in a list indexed 1-10 for use in menu (and lookup for BPBID) and filter
rematch.breedLookup = {} -- for BPBID, translates name of breed ("B/B") to an index to breedNames to filter
rematch.timeUIChanged = nil -- GetTime() when a major frame is shown, menu item clicked, etc; to supress OnEnters

-- constants
rematch.levelingIcon = "Interface\\AddOns\\Rematch\\Textures\\levelingicon"
rematch.hexWhite = "\124cffffffff"
rematch.hexGold = "\124cffffd200"
rematch.hexGrey = "\124cffc0c0c0"
rematch.hexRed = "\124cffff4040"
rematch.hexBlue = "\124cff88bbff"
rematch.LMB = "\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:228:283\124t" -- left mouse button
rematch.RMB = "\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:10:65:330:385\124t" -- right mouse button
rematch.NMB = "\124TInterface\\TutorialFrame\\UI-Tutorial-Frame:12:12:0:0:512:512:89:144:228:283\124t" -- no mouse button

BINDING_HEADER_REMATCH = L["Rematch"]
BINDING_NAME_REMATCH_WINDOW = L["Toggle Window"]
BINDING_NAME_REMATCH_AUTOLOAD = L["Auto Load"]
BINDING_NAME_REMATCH_NOTES = L["Team Notes"]
BINDING_NAME_REMATCH_PETS = L["Pets Tab"]
BINDING_NAME_REMATCH_TEAMS = L["Teams Tab"]
BINDING_NAME_REMATCH_QUEUE = L["Queue Tab"]

-- the following hint tables describe whether an attack is strong/weak vs a pet type
-- 1=Humanoid 2=Dragonkin 3=Flying 4=Undead 5=Critter 6=Magic 7=Elemental 8=Beast 9=Aquatic 10=Mechanical

-- this table describes how an attack will be received by the indexed pet type (incoming modifier)
-- {[petType]={increasedVs,decreasedVs},[petType]={increasedVs,decreasedVs},etc}
-- ie dragonkin pets {1,3} take increased damage from humanoid attacks (1) and less damage from flying attacks (3)
rematch.hintsDefense = {{4,5},{1,3},{6,8},{5,2},{8,7},{2,9},{9,10},{10,1},{3,4},{7,6}}

-- this table describes how an attack of the indexed pet type will be applied (outgoing modifier)
-- {[attackType]={increasedVs,decreasedVs},[attackType]={increasedVs,decreasedVs},etc}
-- ie dragonkin attacks {6,4) deal increased damage to magic pets (6) and less damage to undead pets (4)
rematch.hintsOffense = {{2,8},{6,4},{9,2},{1,9},{4,1},{3,10},{10,5},{5,3},{7,6},{8,7}}

rematch:SetScript("OnEvent",function(self,event,...)
	if rematch[event] then
		rematch[event](self,...)
	end
end)
rematch:RegisterEvent("PLAYER_LOGIN")

-- modules that need an initialization on PLAYER_LOGIN can rematch:InitModule their func
local initFuncs = {}
function rematch:InitModule(func) tinsert(initFuncs,func) end

-- this is the "update the whole UI" function; only visible panels are updated
-- note: it does not and should not update RematchFrame or RematchJournal
function rematch:UpdateUI()
	local roster = rematch.Roster

	rematch.petInfo:Reset() -- reset any petInfo from previous execution

	-- some stuff is only done while the rematch is on screen
	local isVisible = rematch.Frame:IsVisible() or rematch.Journal:IsVisible()

	if isVisible then
		roster:UpdateOwned() -- will only do stuff when roster.ownedNeedsUpdated is true
		rematch:UpdateSanctuary() -- will only do stuff when rematch.sanctuaryNeedsUpdated is true
	end

	-- regardless if rematch on screen, update queue if it needs updated
	if rematch.queueNeedsProcessed then
		rematch:ProcessQueue()
	end

	-- if any pets gain level or rarity they will either be the summoned or a slotted pet.
	-- update sanctuary to their most recent stats
	local owned = roster.ownedPets
	if owned and owned>0 then
		rematch:UpdatePetInSanctuary(C_PetJournal.GetSummonedPetGUID())
		for i=1,3 do
			rematch:UpdatePetInSanctuary(C_PetJournal.GetPetLoadOutInfo(i))
		end
	end

	-- "unload" the loaded team if it ceases to exist
	local loadedTeam = settings.loadedTeam
	if loadedTeam and not saved[loadedTeam] then
		rematch:UnloadTeam()
	end

	-- now that all the data is confirmed to be updated, update the visible panels

	if isVisible then
		-- update the list of pets
		roster:UpdatePetList()
		-- update visible panels
		for _,name in ipairs(rematch.panels) do
			local panel = _G[name]
			if panel and panel.Update and panel:IsVisible() then
				panel:Update()
			end
		end
		-- if pet card up, update it in case anything about the pet changed
		local card = rematch.PetCard
		if card:IsVisible() and card.parent and card.petID then
			rematch:ShowPetCard(card.parent,card.petID,true)
		end
	end
end

--[[ Events ]]


-- PLAYER_LOGIN will watch an independent PET_JOURNAL_LIST_UPDATE to watch for the journal
-- unlocking
function rematch:PLAYER_LOGIN()
   rematch:Start() -- set up the addon (the old PLAYER_LOGIN)
   rematch:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
end

-- when the journal is unlocked, this fires a PET_JOURNAL_LIST_UPDATE for the roster
-- (this is made irrelevant in 5.0)
function rematch:PET_JOURNAL_LIST_UPDATE()
   if not rematch.isLoaded and C_PetJournal.IsJournalUnlocked() then
      rematch.isLoaded = true
      self:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")
      rematch.Roster.ownedNeedsUpdated = true -- force an update of owned pets as journal unlocks
      --rematch.Roster.ownedPets = nil -- this probably isn't necessary, but if any problems, uncomment
      rematch.Roster:PET_JOURNAL_LIST_UPDATE() -- let roster know an event fired
   end
end

-- this initializes the addon; it was formerly PLAYER_LOGIN
function rematch:Start()

	-- check for the existence of an object that's in a new file and shut down rematch if it's not accessible.
	-- this is caused by new files added and user updates the addon while logged in to the game
	if rematch:AddonDidntCompletelyLoad(rematch.CreateODTable) then
		return
	end

	rematch:InitSavedVars()

	rematch:FindBreedSource()
	local locale = GetLocale()
	if locale=="deDE" or locale=="frFR" then
		rematch.localeSquish = true -- flag to make some room when locale has longer text
	end

	-- run initialization for each module that has one registered
	for _,func in ipairs(initFuncs) do func() end
	initFuncs = nil -- don't need them anymore
	rematch.OptionPanel:RunOptionInits() -- after modules are all initialized, run option-specific inits
	rematch:RegisterEvent("PLAYER_TARGET_CHANGED")
	rematch:RegisterEvent("PLAYER_REGEN_DISABLED")
	rematch:RegisterEvent("PLAYER_REGEN_ENABLED")
	rematch:RegisterEvent("PET_BATTLE_OPENING_START")
	rematch:RegisterEvent("PET_BATTLE_CLOSE")
	rematch:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
	rematch:RegisterEvent("PLAYER_LOGOUT")
	rematch:RegisterEvent("CHAT_MSG_SYSTEM")
	rematch:RegisterEvent("COMPANION_UPDATE")
	rematch:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	rematch:RegisterEvent("ADDON_LOADED")
	SlashCmdList["REMATCH"] = rematch.SlashHandler
	SLASH_REMATCH1 = "/rematch"
	-- add launcher button for LDB if it exists
	local ldb = LibStub and LibStub:GetLibrary("LibDataBroker-1.1",true)
	if ldb then
	  ldb:NewDataObject("Rematch",{ type="launcher", icon="Interface\\Icons\\PetJournalPortrait", iconCoords={0.075,0.925,0.075,0.925}, tooltiptext=L["Toggle Rematch"], OnClick=rematch.Frame.Toggle	})
	end
	-- some partial reskinning if Aurora exists (TODO: do a proper reskin in a separate module like ElvUI, except the relationship between Aurora+RealUI and the optional nature of Aurora Missing Textures is a mess)
	if type(Aurora)=="table" then
		local F,C = unpack(Aurora)
		if type(F)=="table" and F.CreateBD then
			for k,v in pairs({rematch.Journal,rematch.Frame,rematch.PetCard,rematch.PetCard.Front.Middle,RematchAbilityCard,RematchWinRecordCard,rematch.Dialog,rematch.Notes}) do
				F.CreateBD(v)
			end
			for k,v in pairs({rematch.Frame.TitleBar.MinimizeButton,rematch.Frame.TitleBar.SinglePanelButton,rematch.Frame.TitleBar.LockButton,rematch.Notes.LockButton,rematch.PetCard.PinButton}) do
				v:SetBackdrop({})
			end
		end
	end
	if IsAddOnLoaded("miirGUI") then
		for k,v in pairs({rematch.Frame.TitleBar.MinimizeButton,rematch.Frame.TitleBar.SinglePanelButton,rematch.Frame.TitleBar.LockButton,rematch.Notes.LockButton,rematch.PetCard.PinButton}) do
			v:SetBackdrop({})
		end
		RematchJournalPortrait:SetTexture("Interface\\Icons\\PetJournalPortrait")
		RematchJournalPortrait:SetTexCoord(0.1,0.9,0.1,0.9)
		rematch.PetCard.Back.Middle.LoreBG:SetColorTexture(1,0.82,0.5)
	end
	-- watch for player forfeiting a match (playerForfeit is nil'ed during PET_BATTLE_OPENING_START)
	hooksecurefunc(C_PetBattles,"ForfeitGame",function() rematch.playerForfeit=true end)
end

function rematch:InitSavedVars()
	RematchSaved = RematchSaved or {}
	RematchSettings = RematchSettings or {}
    if RematchSettings.AutoLoad == nil then RematchSettings.AutoLoad = true end
    if RematchSettings.AutoLoadShow == nil then RematchSettings.AutoLoadShow = true end
    if RematchSettings.ShowOnTarget == nil then RematchSettings.ShowOnTarget = true end
	settings = RematchSettings
	saved = RematchSaved
	-- create settings sub-tables and default values if they don't exist
	for k,v in pairs({"TeamGroups","Filters","FavoriteFilters","Sort","Sanctuary","LevelingQueue","PetNotes","ScriptFilters","SpecialSlots"}) do
		if type(settings[v])~="table" then
			if v=="TeamGroups" then -- TeamGroups starts with a default entry
				settings[v] = {{GENERAL,"Interface\\Icons\\PetJournalPortrait"}}
			elseif v=="Sort" then
				settings[v] = {Order=1,FavoritesFirst=true}
			elseif v=="SpecialSlots" then
				settings[v] = {}
            if settings.LevelingSlots then -- if old LevelingSlots system is used
               -- convert old leveling slots to new special slot system
               for i=1,3 do
                  rematch:SetSpecialSlot(i,settings.LevelingSlots and "leveling" or nil)
               end
               settings.LevelingSlots = nil
            else -- otherwise setup new slot handling
               rematch:AssignSpecialSlots()
            end
			else
				settings[v] = {}
			end
		end
	end
	settings.SelectedTab = settings.SelectedTab or 1

	-- on MacOS clients, turn on DebugDelayMacs setting to delay launch of journal
	if IsMacClient() and settings.DebugDelayMacs==nil then
		settings.DebugDelayMacs = true
	end

	rematch:ValidateTeams() -- make sure teams are okay
end

-- this will go through the RematchSaved savedvar and make sure everything is normal
function rematch:ValidateTeams()
	local found = false
	for key,team in pairs(saved) do
		-- verify the team is a table
		if type(team)~="table" then
			rematch:print(format("Corrupt team found: %s. Unrecoverable, sorry!", key))
			saved[key] = nil
			found = true
		end
		-- validate npcID is a legitimate number if it's a number
		if saved[key] and type(key)=="number" and key>(2^32/2-1) then
			local newKey = tostring(key)
			local newName = format("%s %s",team.teamName or "NPC", newKey)
			rematch:print(format("Corrupt team found: its new name is %s",newName))
			saved[newName] = CopyTable(team)
			saved[key] = nil
			found = true
		end
		-- validate the team has 3 pet slots
		if saved[key] then
			for i=1,3 do
				if type(team[i])~="table" then
					rematch:print(format("Corrupt team found: bad pet in team %s", rematch:GetTeamTitle(key)))
					team[i] = {}
					found = true
				end
			end
		end
	end
	if found then
		rematch:print("At least one team appears corrupt. Your saved data may be lost. To recover:")
		rematch:print("- Before exiting the game, make a backup of your World of Warcraft\\WTF folder.")
		rematch:print("- ALL TEAMS ARE STORED IN WTF. NO TEAMS ARE STORED IN INTERFACE\\ADDONS!")
		rematch:print("- Exit the game after making a backup. (Any changes while logged in will have no effect.)")
		rematch:print("- Go to WTF\\Account\\accountname\\SavedVariables")
		rematch:print("- Rename Rematch.lua to Rematch-old.lua")
		rematch:print("- If there's a Rematch.lua.bak, make a backup of it and rename it Rematch.lua")
		rematch:print("- If there is not a Rematch.lua.bak, you will need to restore teams from a prior backup.")
		rematch:print("- If you have no prior backup, you can try continuing with the current data but it may cause severe problems.")
	end
end

function rematch:PLAYER_TARGET_CHANGED()
	local name, npcID
	if UnitExists("target") then
		name, npcID = rematch:GetUnitNameandID("target")
		if npcID then
			rematch.recentTarget = npcID
			RematchLoadoutPanel:UpdateTarget("target") -- only does stuff if loadout panel visible
			-- if ShowOnTarget enabled, and team saved for target, show window regardless
			if settings.ShowOnTarget and saved[npcID] and not rematch.Frame:IsVisible() then
				rematch:AutoShow()
			end
			-- if PromptToLoad enabled, and this team isn't loaded, and target panel not on screen, and we can swap pets, prompt to load
			if settings.PromptToLoad or settings.AutoLoad then
				if saved[npcID] and settings.loadedTeam~=npcID and (npcID~=rematch.lastInteractNpcID or settings.PromptAlways) and not (InCombatLockdown() or C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo()) then
					if settings.PromptToLoad and (not rematch.LoadoutPanel:IsVisible() and not rematch.MiniPanel:IsVisible()) then
						if settings.PromptWithMinimized then
							rematch:AutoShow()
						else
							local dialog = rematch:ShowDialog("PromptToLoad",300,176,rematch:GetTeamTitle(npcID,true),L["Load this team?"],YES,function() rematch:LoadTeam(npcID) end,NO)
							dialog.Team:SetPoint("TOP",0,-36)
							dialog.Team:Show()
							dialog:FillTeam(dialog.Team,saved[npcID])
						end
						rematch:SetLastInteractNpcID(npcID)
					elseif settings.AutoLoad then
						if settings.AutoLoadShow and (not rematch.LoadoutPanel:IsVisible() and not rematch.MiniPanel:IsVisible()) then
							rematch:AutoShow()
						end
						rematch:LoadTeam(npcID)
						rematch:SetLastInteractNpcID(npcID)
					end
				end
			end
			if settings.ShowNotesOnTarget and saved[npcID] and saved[npcID].notes then
				rematch.Notes.locked = true
				rematch:ShowNotes("team",npcID,true) -- then show notes!
				rematch.lastNotedTeam = npcID
			end
		end
	end
	RematchMiniPanel:UpdateTarget("target",npcID) -- only does stuff if minipanel visible
end

function rematch:UPDATE_MOUSEOVER_UNIT()
	if UnitExists("mouseover") then
		local name,npcID = rematch:GetUnitNameandID("mouseover")
		if npcID and saved[npcID] and settings.AutoLoad then
			if InCombatLockdown() or C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo() then
				return -- can't change pets, don't load a team regardless
			end
			if UnitExists("target") then
				local _,targetNpcID = rematch:GetUnitNameandID("target")
				if targetNpcID and saved[targetNpcID] then
					return -- user has a saved target targeted right now, don't load a new team
				end
			end
			-- if we haven't autoloaded a team for this npc recently
			if npcID ~= rematch.lastInteractNpcID then
				if settings.AutoLoadShow and (not rematch.LoadoutPanel:IsVisible() and not rematch.MiniPanel:IsVisible()) then
					rematch:AutoShow()
				end
				rematch:LoadTeam(npcID) -- then load it
				rematch:SetLastInteractNpcID(npcID)
			end
		end
	end
end

-- sets rematch.lastInteractNpcID only if not in combat, battle or queued for pvp
-- this variable is used to decide whether to stop prompting to load a team
function rematch:SetLastInteractNpcID(npcID)
	if not (InCombatLockdown() or C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo()) then
		rematch.lastInteractNpcID = npcID
	end
end

-- this makes the loadout pets and leveling slot glow when a pet is picked up onto the cursor
-- it's initially called by hooksecurefunc of C_PetJournal.PickupPet
function rematch:CURSOR_UPDATE()
	local petID = rematch:GetCursorPet()
	if petID then -- if pet picked up, then show drop buttons and start glow animations
		rematch:HideWidgets()
		for i=1,3 do
			rematch.LoadoutPanel.Loadouts[i].DropButton:Show()
			rematch.LoadoutPanel.Loadouts[i].DropButton.Glow:Play()
		end
		if rematch:PetCanLevel(petID) then -- only glow leveling slot if pet can level
			rematch.QueuePanel.DropButton:Show()
			rematch.QueuePanel.DropButton.Glow:Play()
		end
		rematch.MiniPanel.Glow:Show()
		rematch:RegisterEvent("CURSOR_UPDATE") -- this is the only place this event is registered
	else -- if pet dropped, hide drop buttons and stop glow animations
		for i=1,3 do
			rematch.LoadoutPanel.Loadouts[i].DropButton:Hide()
			rematch.LoadoutPanel.Loadouts[i].DropButton.Glow:Stop()
		end
		rematch.QueuePanel.DropButton:Hide()
		rematch.QueuePanel.DropButton.Glow:Stop()
		rematch.MiniPanel.Glow:Hide()
		rematch:UnregisterEvent("CURSOR_UPDATE") -- cursor clear, stop watching cursor changes
	end
	if rematch.QueuePanel:IsVisible() then
		rematch.QueuePanel:UpdateList()
	elseif rematch.MiniQueue:IsVisible() then
		rematch.MiniQueue:UpdateList()
	end
end

-- capture pets gaining xp
function rematch:UPDATE_SUMMONPETS_ACTION()
	rematch:UpdateQueue()
end

-- when pet is summoned or dismissed (UNIT_PET doesn't fire when dismissed). always fires in pairs grr
function rematch:COMPANION_UPDATE(companionType)
	if companionType=="CRITTER" and rematch.PetPanel:IsVisible() then
		rematch:StartTimer("UpdatePetPanel",0.1,rematch.PetPanel.Update)
	end
end

-- entering combat
function rematch:PLAYER_REGEN_DISABLED()
	rematch:HideWidgets(nil,true) -- completely close all widgets
	local frame = rematch.Frame
	if frame:IsVisible() then
		frame:Hide()
		frame.showAfterCombat = true
	end
	if rematch.Journal:IsVisible() then
		rematch.Journal:ConfigureJournal(true) -- this will hide the journal
	end
	rematch:UpdateAutoLoadState(true)
	if UseRematchButton and PetJournal:IsVisible() then
		UseRematchButton:Hide() -- hide checkbutton on default journal if journal is up
	end
end

-- entering a pet battle
function rematch:PET_BATTLE_OPENING_START()
	rematch:HideWidgets()
	rematch.pvpProposalAccepted = nil
	if settings.LockWindow and not settings.StayForBattle and rematch.Frame:IsVisible() then
		rematch.Frame.showAfterBattle = true
		rematch.Frame:Hide()
	end
	rematch:UpdateAutoLoadState(true)
	if settings.ShowNotesInBattle and settings.loadedTeam and RematchSaved[settings.loadedTeam] and RematchSaved[settings.loadedTeam].notes then
		-- and if 'Only once per team' not checked, or team is different than last notes displayed...
		if not settings.ShowNotesOnce or rematch.lastNotedTeam~=settings.loadedTeam then
			rematch.Notes.locked = true
			rematch:ShowNotes("team",settings.loadedTeam,true) -- then show notes!
			rematch.lastNotedTeam = settings.loadedTeam
		end
	end
	rematch.playerForfeit = nil -- start watching for player forfeiting the match
end

function rematch:PET_BATTLE_QUEUE_STATUS()
	-- there's a gap when GetPVPMatchmakingInfo is nil after we accept a queue proposal and
	-- before a battle begins; to prevent the queue from running in that time, a flag
	-- is set upon "entry" status and cleared in PET_BATTLE_OPENING_START.
	local status = C_PetBattles.GetPVPMatchmakingInfo()
	if status=="entry" then
		rematch.pvpProposalAccepted = true
	elseif status then
		rematch:UpdateAutoLoadState(true)
		rematch:UpdateUI()
	elseif not rematch.pvpProposalAccepted then -- don't resume if flag set
		C_Timer.After(0,rematch.UpdateQueue)
		rematch:UpdateAutoLoadState()
	end
end

-- leaving battle
function rematch:PLAYER_REGEN_ENABLED()
	local frame = rematch.Frame
	if frame.showAfterCombat then
		frame:Show()
	end
	C_Timer.After(0,rematch.UpdateQueue)
	rematch:UpdateAutoLoadState()
end

-- leaving pet battle
function rematch:PET_BATTLE_CLOSE()
	if not C_PetBattles.IsInBattle() then
		rematch:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
		local frame = rematch.Frame
		if frame.showAfterBattle then
			frame:Show() -- this is for standalone being open and dismissed when battle started
		end
		if settings.ShowAfterBattle then
			rematch:AutoShow() -- this is the "Show After Pet Battle" option
		end
		if rematch.Notes:IsVisible() and not rematch.Notes.Content.ScrollFrame.EditBox:HasFocus() then
			rematch:HideNotes()
		end
		C_Timer.After(0,rematch.UpdateQueue) -- waiting a frame (client thinks we can't swap pets right now)
		rematch:UpdateAutoLoadState()
	end
end

-- logging out
function rematch:PLAYER_LOGOUT()
	settings.ShowOnLogin = (settings.LockWindow and settings.StayOnLogout) and rematch.Frame:IsVisible() and true
end

-- when learning a new pet, or when attempting to send a team to someone offline
local patternPlayerOffline = format("^%s$",ERR_CHAT_PLAYER_NOT_FOUND_S:gsub("%%s","(.+)"))
local patternNewPet = format("^%s$",BATTLE_PET_NEW_PET:gsub("%%s","(.+)"))
function rematch:CHAT_MSG_SYSTEM(message)
	-- pattern matching for offling players only happens while there's a sideline with recipient context
	local recipient = rematch:GetSidelineContext("recipient")
	if recipient then
		local player = message:match(patternPlayerOffline)
		-- if "No player named '%s' is currently playing." and %s is the recipient of a send
		if player and player==recipient then
			rematch.Dialog.Share:SendFailed(L["They do not appear to be online."])
		end
	end
	-- pattern matching for learned pets only happens when QueueAutoLearn enabled
	if settings.QueueAutoLearn then
		-- if "%s has been added to your pet journal!" and %s is a pet link
		local petLink = message:match(patternNewPet)
		if petLink then
			local _,petID = petLink:match("battlepet:(%d+):.+:(BattlePet%-.-)\124h")
			if petID and rematch:PetCanLevel(petID) then
				local addID
				local speciesID,_,level,_,_,_,_,name = C_PetJournal.GetPetInfoByPetID(petID)
				if not settings.QueueAutoLearnOnly and not settings.QueueAutoLearnRare then
					addID = petID
				else
					-- QueueAutoLearnOnly requires pet not have its species at 25 already or a version in queue
					local at25orQueued = rematch.speciesAt25[speciesID]
					-- look through queue if QueueAutoLearnOnly checked to see if species is in queue already
					if settings.QueueAutoLearnOnly and not at25orQueued then
						for _,qPetID in ipairs(settings.LevelingQueue) do
							if C_PetJournal.GetPetInfoByPetID(qPetID)==speciesID then
								at25orQueued = true
								break
							end
						end
					end
					if (not settings.QueueAutoLearnOnly or not at25orQueued) and (not settings.QueueAutoLearnRare or select(5,C_PetJournal.GetPetStats(petID))==4) then
						addID = petID
					end
				end
				if addID then
					rematch:InsertPetToQueue(#settings.LevelingQueue+1,addID)
					local info = ChatTypeInfo["SYSTEM"]
					print(format("%s \124cff%02x%02x%02x%s",petLink,info.r*255,info.g*255,info.b*255,L["has also been added to your leveling queue!"]))
				end
			end
		end
	end
end

function rematch:ZONE_CHANGED_NEW_AREA()
	if rematch.Roster:GetFilter("Other","CurrentZone") then
		rematch:StartTimer("CurrentZone",0.75,rematch.UpdateRoster)
	end
end

function rematch:PET_BATTLE_FINAL_ROUND(winner)

	if settings.AutoWinRecord and (not settings.AutoWinRecordPVPOnly or not C_PetBattles.IsPlayerNPC(2)) then
		local key = settings.loadedTeam
		if key and saved[key] then
			local team = saved[key]

			-- when the player doesn't win (and even if opponent forfeits) winner appears to be 2.
			-- if player didn't win, see why they didn't win
			if winner~=1 then
				-- see who has pets still alive
				local allyAlive, enemyAlive
				local numAlly = C_PetBattles.GetNumPets(1)
				local numEnemy = C_PetBattles.GetNumPets(2)
				for i=1,3 do
					local health = C_PetBattles.GetHealth(1,i)
					if health and health>0 and i<=numAlly then
						allyAlive = true
					end
					health = C_PetBattles.GetHealth(2,i)
					if health and health>0 and i<=numEnemy then
						enemyAlive = true
					end
				end
				if allyAlive and enemyAlive then -- if both pets alive, someone forfeit tsk tsk
					if rematch.playerForfeit then
						winner = 2 -- player forfeit match in progress, mark as loss
					else
						winner = 1 -- opponent forfeit match in progress, mark as win
					end
				elseif not allyAlive and not enemyAlive then
					winner = 3 -- both teams dead, it was a draw
				else
					winner = 2 -- any other reason mark as a loss
				end
			end

			if winner==1 then
				team.wins = (team.wins or 0) + 1 -- won! :D
			elseif winner==2 then
				team.losses = (team.losses or 0) + 1 -- lost! :(
			elseif winner==3 then
				team.draws = (team.draws or 0) + 1 -- draw! :|
			end
			rematch:ToastWinRecord(rematch.LoadedTeamPanel,key,winner or 3)
		end
	end
end

function rematch:ADDON_LOADED(addon)
	if addon=="Blizzard_Collections" then
		rematch.Journal:Blizzard_Collections()
	elseif addon=="Blizzard_PetBattleUI" then
		rematch.Battle:Blizzard_PetBattleUI()
	end
end

--[[ Timer Management ]]

rematch.timerFuncs = {} -- indexed by arbitrary name, the func to run when timer runs out
rematch.timerTimes = {} -- indexed by arbitrary name, the duration to run the timer
rematch.timersRunning = {} -- indexed numerically, timers that are running
rematch.timerStopped = nil -- name of timer that just stopped
rematch:Hide()

function rematch:StartTimer(name,duration,func)
	local timers = rematch.timersRunning
	rematch.timerFuncs[name] = func
	rematch.timerTimes[name] = duration
	if not tContains(timers,name) then
		tinsert(timers,name)
	end
	rematch:Show()
end

function rematch:StopTimer(name)
	local timers = rematch.timersRunning
	for i=#timers,1,-1 do
		if timers[i]==name then
			tremove(timers,i)
			return
		end
	end
end

-- returns whether a named timer is running
function rematch:IsTimerRunning(name)
	return tContains(rematch.timersRunning,name)
end

-- returns the name of the timer that just stopped
function rematch:GetTimerStopped()
	return rematch.timerStopped
end

-- timer handling; everything should go through rematch:StartTimer
rematch:SetScript("OnUpdate",function(self,elapsed)
	local tick
	local times = rematch.timerTimes
	local timers = rematch.timersRunning
	for i=#timers,1,-1 do
		local name = timers[i]
		if times[name] then
			times[name] = times[name] - elapsed
			if times[name] < 0 then
				tremove(timers,i)
				if rematch.timerFuncs[name] then
					rematch.timerStopped = name
					rematch.timerFuncs[name]()
				end
			end
			tick = true
		else
			tremove(timers,i)
		end
	end
	if not tick then
		self:Hide()
	end
	rematch.timerStopped = nil
end)

function rematch.SlashHandler(msg)
	msg = SecureCmdOptionParse(msg)
	if msg:lower()=="debug" then
		rematch:ShowDebugDialog()
	elseif msg:trim():len()>0 then
		-- going to desensitize the passed name so "aki the chosen" works for "Aki the Chosen"
		local name = format("^%s$",rematch:DesensitizeText(msg))
		for k,v in pairs(saved) do -- and this necessitates going through the table instead of a lookup
			if rematch:GetTeamTitle(k):match(name) then
				rematch:LoadTeam(k) -- team found, load it
				return -- and leave
			end
		end
		-- next see if "<cmd> <args>" is passed
		local cmd,arg = msg:trim():match("^(%w+)%s+(.+)$")
		if cmd and cmd:lower()=="winrecord" then
			if arg:lower()=="reset" then
				rematch:ShowResetAllWinRecordsDialog()
				return
			end
			if arg:lower()=="convert" then
				rematch:ShowConvertTeamNamesToWinRecordDialog()
				return
			end
			rematch:print("/rematch winrecord reset : wipe out all winrecord data.")
			rematch:print("/rematch winrecord convert : convert teams with win/loss/draw in their name to a winrecord.")
			return
		end
		rematch:print(format(L["The team named '%s' can't be found."],msg))
	else
		rematch.Frame:Toggle()
	end
end

-- when new files are added to the addon, some users will update while logged in;
-- this tests for the existence of a new object and throws up a warning dialog if the test does not exist
function rematch:AddonDidntCompletelyLoad(test)
	if not test then
		StaticPopupDialogs["REMATCHUPDATE"] = { button1=OKAY, timeout=0, showAlert=1, text="You updated Rematch while you were logged in to the game.\n\nWhich is usually fine!\n\nHowever, this update has some new files that won't be recognized while the game is running.\n\n\124cffff4040Rematch is disabled until the next time you start the World of Warcraft client." }
		StaticPopup_Show("REMATCHUPDATE")
		rematch:ShutdownAddon()
		return true
	end
end

function rematch:ShutdownAddon()
	RematchFrame.Toggle = function() end
	Rematch.ToggleFrameTab = function() end
	Rematch.ToggleNotes = function() end
end

-- /rematch debug displays a dialog containing enabled options and various settings the user can copy to a post/comment to help debug
function rematch:ShowDebugDialog()
	local data = {}
	-- help funcs
	local function add(pattern,arg1,arg2) -- add text to data table
		arg1 = tostring(arg1)
		arg2 = tostring(arg2)
		tinsert(data,format(pattern,arg1,arg2))
	end
	local function petName(petID) -- returns real name (and level) of petID
		local idType = rematch:GetIDType(petID)
		if idType=="pet" then
			local _,_,level,_,_,_,_,name = C_PetJournal.GetPetInfoByPetID(petID)
			return level and format("%s (%s)",name,tostring(level)) or "PetID not known"
		elseif idType=="species" then
			return (C_PetJournal.GetPetInfoBySpeciesID(petID))
		else
			return idType=="leveling" and "Leveling Pet" or "Unknown"
		end
	end
	local function addPrefs(source) -- adds preferences to data table from source table
		for _,var in pairs({"minHP","allowMM","expectedDD","maxHP","minXP","maxXP"}) do
			if source[var] then
				add("%s=%s",var,source[var])
			end
		end
	end
	-- gather each line into data table
	add("__ Rematch version %s __",GetAddOnMetadata("Rematch","Version"))
	add("%s last used",settings.JournalUsed and "Journal" or "Standalone")
	add("Panel Tab=%s",settings.JournalUsed and settings.JournalPanel or settings.ActivePanel)
	add("Error Reporting=%s",IsAddOnLoaded("BugSack") and "BugSack" or GetCVarBool("scriptErrors") and "scriptErrors" or "None")
	local count = 0
	for k,v in pairs(saved) do count=count+1 end
	add("Number Of Teams=%d",count)
	add("Number Of Team Tabs=%d",#settings.TeamGroups)
	count = 0
	for k,v in pairs(settings.Sanctuary) do count=count+1 end
	add("Pets In Sanctuary=%d",count)
	add("__ Queue __")
	add("Pets In Queue=%s",#settings.LevelingQueue)
	if #settings.LevelingQueue>0 then
		add("Top Pet=%s",petName(settings.LevelingQueue[1]))
	end
	for _,var in ipairs({"QueueSortOrder","QueueActiveSort","QueueNoPreferences"}) do
		if settings[var] then
			add("%s=%s",var,settings[var])
		end
	end
	add("__ Loaded Team __")
	if settings.loadedTeam then
		add("Key=%s",settings.loadedTeam)
		local team = saved[settings.loadedTeam]
		if team then
			for i=1,3 do
				add("%s=%s",i,petName(team[i][1]))
			end
			if rematch:HasPreferences(team) then
				add("Team Preferences:")
				addPrefs(team)
			end
			add("Team Tab=%s",team.tab or 1)
			local pref = settings.TeamGroups[team.tab or 1][4]
			if pref then
				add("Tab Preferences:")
				addPrefs(pref)
			end
		else
			add("Team not saved")
		end
	else
		add("None")
	end
	add("__ Loaded Pets __")
	for i=1,3 do
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		add("%s=%s",i,petName(petID))
	end
	add("__ Enabled Settings __")
	local opts = Rematch.OptionPanel.opts
	for _,opt in ipairs(opts) do
		if opt[1]=="check" and settings[opt[2]] then
			add("%s",opt[2])
		elseif opt[1]=="radio" then
			local radio = format("%s=%s",opt[2],tostring(settings[opt[2]]))
			if not tContains(data,radio) then
				add("%s",radio)
			end
		elseif opt[2]=="Growth" then
			add("Anchor=%s",settings.CornerPos)
		elseif opt[2]=="CustomScale" and settings[opt[2]] then
			add("CustomScale=%s",settings.CustomScaleValue)
		end
	end

	-- data collected, now show dialog
	local dialog = rematch:ShowDialog("DebugDialog",300,300,L["Rematch Debug Info"],nil,nil,nil,OKAY)
	dialog.MultiLine:SetPoint("TOP",0,-38)
	dialog.MultiLine:SetSize(262,224)
	dialog.MultiLine:Show()
	dialog:SetContext("settings",table.concat(data,"\n"))
	dialog.MultiLine.EditBox:SetScript("OnTextChanged",function(self)
		if self:GetText()~=dialog:GetContext("settings") then
			self:SetText(dialog:GetContext("settings"))
			self:SetCursorPosition(0)
			self:HighlightText(0)
			self:SetFocus(true)
		end
	end)
	dialog.MultiLine.EditBox:SetText("")
end

--[[ RematchTitlebarButtonTemplate: for red buttons atop BasicFrameTemplate titlebars (close, minimize, etc) ]]

function rematch:TitlebarButtonOnMouseDown()
	self.Icon:SetPoint("CENTER",-1,-2)
	self.Icon:SetVertexColor(0.85,0.85,0.85)
end

function rematch:TitlebarButtonOnMouseUp()
	self.Icon:SetPoint("CENTER")
	self.Icon:SetVertexColor(1,1,1)
end

-- texcoords into TitlebarButtons.tga
local titleIconTexCoords = {
	pin = {0.75,1,0,0.25}, minimize = {0,0.25,0.25,0.5}, maximize = {0.25,0.5,0.25,0.5},
	lock = {0.5,0.75,0.25,0.5}, unlock = {0.75,1,0.25,0.5}, left = {0,0.25,0.5,0.75},
	right = {0.25,0.5,0.5,0.75}, up = {0.5,0.75,0.5,0.75}, down = {0.75,1,0.5,0.75}
}

-- this changes the icon of a titlebar button
function rematch:SetTitlebarButtonIcon(button,icon)
	local coords = titleIconTexCoords[icon]
	if coords then
		button.Icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
	end
end

-- converts the default BasicFrameTemplate CloseButton to Rematch's icon decal overlaid over a blank red button
function rematch:ConvertTitlebarCloseButton(button)
	if not button.Icon then
		button:SetNormalTexture("Interface\\AddOns\\Rematch\\Textures\\TitlebarButtons")
		button:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		button:SetPushedTexture("Interface\\AddOns\\Rematch\\Textures\\TitlebarButtons")
		button:GetPushedTexture():SetTexCoord(0.25,0.5,0,0.25)
		button.Icon = button:CreateTexture(nil,"OVERLAY")
		button.Icon:SetSize(32,32)
		button.Icon:SetPoint("CENTER")
		button.Icon:SetTexture("Interface\\AddOns\\Rematch\\Textures\\TitlebarButtons")
		button.Icon:SetTexCoord(0.5,0.75,0,0.25)
		button:SetScript("OnMouseDown",rematch.TitlebarButtonOnMouseDown)
		button:SetScript("OnMouseUp",rematch.TitlebarButtonOnMouseUp)
		button:SetScript("OnShow",rematch.TitlebarButtonOnMouseUp)
	end
end

--[[ RematchFootnoteButtonTemplate: for the little round buttons on list buttons (notes, leveling, etc) ]]

local footnoteCoords = { 
	notes={0,0.125,0,0.25}, leveling={0.125,0.25,0,0.25}, preferences={0.25,0.375,0,0.25},
	ascending={0.375,0.5,0,0.25}, median={0,0.125,0.25,0.5}, descending={0.125,0.375,0.25,0.5},
   random={0.375,0.5,0.25,0.5}, ignored={0,0.125,0.5,0.75},
   ["random:0"]={0.375,0.5,0.25,0.5}, ["random:1"]={0.125,0.25,0.5,0.75},
   ["random:2"]={0.25,0.375,0.5,0.75}, ["random:3"]={0.375,0.5,0.5,0.75},
   ["random:4"]={0,0.125,0.75,1}, ["random:5"]={0.125,0.25,0.75,1},
   ["random:6"]={0.25,0.375,0.75,1}, ["random:7"]={0.375,0.5,0.75,1},
   ["random:8"]={0.5,0.625,0,0.25}, ["random:9"]={0.625,0.75,0,0.25},
   ["random:10"]={0.75,0.875,0,0.25}, [0]={0.125,0.25,0,0.25},
}

function rematch:FootnoteButtonOnLoad()
	rematch:SetFootnoteIcon(self,self.icon)
	self.icon = nil
end

-- this is used not only in the OnLoad above but by the QueuePanel to change the active sort icon
function rematch:SetFootnoteIcon(button,icon)
	if icon and footnoteCoords[icon] then
		local left,right,top,bottom = unpack(footnoteCoords[icon])
		button:GetNormalTexture():SetTexCoord(left,right,top,bottom)
      local pushedTexture = button:GetPushedTexture()
      if pushedTexture then
		   button:GetPushedTexture():SetTexCoord(left,right,top,bottom)
      end
	end
end
