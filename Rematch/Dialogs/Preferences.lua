local _,L = ...
local rematch = Rematch
local settings, saved, dialog, pref

rematch:InitModule(function()
	saved = RematchSaved
	settings = RematchSettings
	dialog = rematch.Dialog
	pref = dialog.Preferences
	pref.editBoxes = { "MinHP", "MaxHP", "MinXP", "MaxXP" } -- list of controls to tab through/update
	pref.MinHP.Label:SetText(L["Minimum Health"])
	pref.MinHP.tooltipTitle = L["Minimum Health"]
	pref.MinHP.tooltipBody = L["This is the minimum health preferred for a leveling pet.\n\nThe queue will prefer leveling pets with at least this much health (adjusted by expected damage taken if any chosen)."]
	pref.MinXP.Label:SetText(L["Minimum Level"])
	pref.MinXP.tooltipTitle = L["Minimum Level"]
	pref.MinXP.tooltipBody = L["This is the minimum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 4.33 is level 4 with 33% xp towards level 5."]
	pref.MaxHP.Label:SetText(L["Maximum Health"])
	pref.MaxHP.tooltipTitle = L["Maximum Health"]
	pref.MaxHP.tooltipBody = L["This is the maximum health preferred for a leveling pet."]
	pref.MaxXP.Label:SetText(L["Maximum Level"])
	pref.MaxXP.tooltipTitle = L["Maximum Level"]
	pref.MaxXP.tooltipBody = L["This is the maximum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 23.45 is level 23 with 45% xp towards level 24."]
	pref.AllowMM.tooltipTitle = format("%s %s & %s",L["Or any"],rematch:PetTypeAsText(6,16),rematch:PetTypeAsText(10,16))
	pref.AllowMM.tooltipBody = L["Allow low-health Magic and Mechanical pets to ignore the Minimum Health, since their racials allow them to often survive a hit that would ordinarily kill them."]
	pref.AllowMM.text:SetFontObject(GameFontNormal)
	pref.AllowMM.text:SetText(format("%s %s & %s",L["Or any"],rematch:PetTypeAsText(6,22),rematch:PetTypeAsText(10,22)))
	pref.ExpectedDDLabel:SetText(L["Expected Damage Taken"])
	pref.Top.RadioTeam.Text:SetText(L["Team"])
	pref.Top.RadioTab.Text:SetText(L["Tab"])
end)

-- displays a tooltip of the preferences to a team
function rematch:ShowPreferencesTooltip(prefSet,prefKey,prefLoaded,info)

	if not prefSet and not prefKey then
		prefSet,prefKey,prefLoaded = rematch:GetPrefSetFrom(self)
	end

	if not prefSet or (prefSet=="team" and not saved[prefKey]) or (prefSet=="tab" and not settings.TeamGroups[prefKey]) then
		return -- if team or tab is not known, leave
	end

	local tabIcon = " \124TInterface\\PetBattles\\BattleBar-AbilityBadge-Strong:16\124t"

	if not info then
		info = rematch.info
		wipe(info)
	end
	local prefType = prefLoaded and L["Leveling Preferences"] or prefSet=="team" and L["Team Preferences"] or prefSet=="tab" and L["Tab Preferences"]
	tinsert(info,format("%s %s%s","\124TInterface\\AddOns\\Rematch\\textures\\footnotes:16:16:0:0:256:128:65:95:1:31\124t",rematch.hexWhite,prefType))
	local minHP, expectedDD, allowMM, maxHP, minXP, maxXP, fromTab, override
	minHP,fromTab = rematch:GetPrefStatValue("minHP",prefSet,prefKey,prefLoaded)
	override = override or fromTab
	if minHP then -- minimum hp defined
		tinsert(info,format("%s: %s%s%s",L["Minimum Health"],rematch.hexWhite,minHP,fromTab and tabIcon or ""))
		expectedDD,fromTab = rematch:GetPrefStatValue("expectedDD",prefSet,prefKey,prefLoaded)
		override = override or fromTab
		if expectedDD then -- expected damage taken
			tinsert(info,format(L["  For %s pets: %s%d%s"],rematch:PetTypeAsText(rematch.hintsOffense[expectedDD][1]),rematch.hexWhite,minHP*1.5,fromTab and tabIcon or ""))
			tinsert(info,format(L["  For %s pets: %s%d%s"],rematch:PetTypeAsText(rematch.hintsOffense[expectedDD][2]),rematch.hexWhite,minHP*2/3,fromTab and tabIcon or ""))
		end
		allowMM,fromTab = rematch:GetPrefStatValue("allowMM",prefSet,prefKey,prefLoaded)
		override = override or fromTab
		if allowMM then -- allow magic & mechanical
			tinsert(info,format("  %s %s & %s%s",L["Or any"],rematch:PetTypeAsText(6),rematch:PetTypeAsText(10),fromTab and tabIcon or ""))
		end
	end
	maxHP,fromTab = rematch:GetPrefStatValue("maxHP",prefSet,prefKey,prefLoaded)
	override = override or fromTab
	if maxHP then -- maximum health
		tinsert(info,format("%s: %s%s%s",L["Maximum Health"],rematch.hexWhite,maxHP,fromTab and tabIcon or ""))
	end
	minXP,fromTab = rematch:GetPrefStatValue("minXP",prefSet,prefKey,prefLoaded)
	override = override or fromTab
	if minXP then -- minimum level
		tinsert(info,format("%s: %s%s%s",L["Minimum Level"],rematch.hexWhite,minXP,fromTab and tabIcon or ""))
	end
	maxXP,fromTab = rematch:GetPrefStatValue("maxXP",prefSet,prefKey,prefLoaded)
	override = override or fromTab
	if maxXP then -- maximum level
		tinsert(info,format("%s: %s%s%s",L["Maximum Level"],rematch.hexWhite,maxXP,fromTab and tabIcon or ""))
	end
	if override and tabIcon then
		tinsert(info,format(L["%s %sTab Preferences"],tabIcon:gsub("^ ",""),rematch.hexGrey))
	end
	if self.Paused then -- if this tooltip is for a pause-able button
		if settings.QueueNoPreferences then
			tinsert(info,format(L["%s%s Preferences Paused"],"\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t",rematch.hexRed))
		end
		tinsert(info,format(settings.QueueNoPreferences and L["%s Resume Preferences"] or L["%s Pause Preferences"],rematch.RMB))
	end
	rematch:ShowTableTooltip(self,info)
end

-- returns the prefSet,prefKey (and whether to display both if prefLoaded in parent and both team and tab have prefs)
function rematch:GetPrefSetFrom(frame)
	local prefLoaded -- will be true if both team and tab have preferences (only relevant for loaded team)
	local parent = frame:GetParent()
   local prefSet,prefKey,prefLoaded
	if parent.forLoadedTeam then
		local hasTeamPreferences = rematch:HasPreferences(saved[settings.loadedTeam])
		local hasTabPreferences = rematch:HasPreferences(nil,rematch:GetTabFromTeam(settings.loadedTeam))
		if hasTeamPreferences then -- priorities to team first
			prefSet,prefKey,prefLoaded = "team",settings.loadedTeam,hasTabPreferences
		else
			prefSet,prefKey = "tab",rematch:GetTabFromTeam(settings.loadedTeam)
		end
	elseif parent.key then
		if rematch:HasPreferences(saved[parent.key]) then
			prefSet,prefKey = "team",parent.key
		end
	elseif parent.tab then
		if rematch:HasPreferences(nil,parent.tab) then
			prefSet,prefKey = "tab",parent.tab
		end
	end
	return prefSet,prefKey,prefLoaded
end

function rematch:ShowPreferencesDialog(prefSet,prefKey,prefLoaded)

	if not prefSet and not prefKey then
		prefSet,prefKey,prefLoaded = rematch:GetPrefSetFrom(self)
	end

	if not prefSet or (prefSet=="team" and not saved[prefKey]) or (prefSet=="tab" and not settings.TeamGroups[prefKey]) then
		return -- if team or tab is not known, leave
	end

	if rematch:IsDialogOpen("Preferences") then
		if dialog:GetContext("prefSet")==prefSet and dialog:GetContext("prefKey")==prefKey then
			rematch:HideDialog() -- if this preference is already displayed, hide and leave (toggle)
			return
		end
	end

	local dialog = rematch:ShowDialog("Preferences",300,364,L["Leveling Preferences"],nil,SAVE,rematch.PreferencesSave,CANCEL,nil,DELETE,rematch.PreferencesDelete)

	dialog:SetContext("prefSet",prefSet)
	dialog:SetContext("prefKey",prefKey)

	if not prefLoaded then
		pref.Top:SetHeight(48)
		pref.Top.RadioTeam:Hide()
		pref.Top.RadioTab:Hide()
	else -- we're looking at preferences for the loaded team and both team and tab preference are in play
		-- show radio buttons to choose which to show (team will always be default)
		pref.Top:SetHeight(68)
		pref.Top.PrefKey:SetText("Team Or Tab Name Goes Here")
		pref.Top.RadioTeam:Show()
		pref.Top.RadioTab:Show()
		dialog:SetHeight(364+20)
	end

	pref:SetPoint("TOP",0,-36)
	pref:Show()
	if not pref.expectedDD then
		-- create expectedDD buttons the first time preference dialog is shown
		pref.expectedDD = {}
		for i=1,10 do
			local button = CreateFrame("CheckButton",nil,pref,"RematchSlotTemplate")
			button:SetID(i)
			button:SetSize(24,24)
			rematch:FillPetTypeIcon(button.Icon,i,"Interface\\Icons\\Icon_PetFamily_")
			button:SetPoint("CENTER",pref.ExpectedDDLabel,"BOTTOM",(i-1)*25-112,-20)
			button:SetCheckedTexture("Interface\\Buttons\\CheckButtonHilight","ADD")
			button:SetScript("OnClick",rematch.PreferencesExpectedDDOnClick)
			button:SetScript("OnEnter",rematch.PreferencesExpectedDDOnEnter)
			button:SetScript("OnLeave",rematch.HideTooltip)
			tinsert(pref.expectedDD,button)
		end
	end
	rematch:UpdatePreferencesDialog()
end

function rematch:UpdatePreferencesDialog()

	local prefSet = dialog:GetContext("prefSet")
	local prefKey = dialog:GetContext("prefKey")

	local working = dialog:GetContext("workingPrefs")

	-- if workingPrefs not set up (dialog just shown), pull live values from prefSet/prefKey
	if not working then
		working = dialog:SetContext("workingPrefs",{})
		local prefTable
		if prefSet=="team" then
			prefTable = saved[dialog:GetContext("prefKey")]
		elseif prefSet=="tab" then
			local tab = settings.TeamGroups[prefKey]
			prefTable = tab and tab[4] -- preferences are a table in 4th field
		end
		if prefTable then -- copy preferences to workingPrefs
			for _,var in ipairs({"minHP", "allowMM", "expectedDD", "maxHP", "minXP", "maxXP"}) do
				working[var] = prefTable[var]
			end
		end
	end

	-- update name of team/tab
	pref.Top.Label:SetText(format(L["Leveling Preferences For %s:"],prefSet=="team" and L["Team"] or L["Tab"]))
	if prefSet=="team" then
		pref.Top.PrefKey:SetText(rematch:GetTeamTitle(prefKey,true))
		pref.Top.RadioTeam:SetChecked(true)
		pref.Top.RadioTab:SetChecked(false)
	else
		pref.Top.PrefKey:SetText(format("%s%s",rematch.hexWhite,settings.TeamGroups[prefKey][1]))
		pref.Top.RadioTeam:SetChecked(false)
		pref.Top.RadioTab:SetChecked(true)
	end

	-- update values in the dialog
	for _,editBox in pairs(pref.editBoxes) do
		pref[editBox]:SetText(working[pref[editBox].var] or "")
		pref[editBox].Clear:SetShown(working[pref[editBox].var] and true or pref[editBox]:HasFocus())
	end
	pref.AllowMM:SetChecked(working.allowMM)
	local dd = working.expectedDD
	for i=1,10 do
		pref.expectedDD[i]:SetChecked(dd==i)
		pref.expectedDD[i].Icon:SetDesaturated(dd and dd~=i)
	end
end

-- cycles through editboxes
function rematch:PreferencesOnTabPressed()
	local index = self:GetID()%#pref.editBoxes + 1
	pref[pref.editBoxes[index]]:SetFocus(true)
end

-- when text is typed into a preferences editbox to make sure it's a number)
-- this is used because setting numeric="true" won't allow decimals (ie 23.5)
function rematch:PreferencesOnChar()
	rematch:HideTooltip()
	if not tonumber(self:GetText()) then
		local working = dialog:GetContext("workingPrefs")
		if working then
			self:SetText(working[self.var] or "")
		end
	end
end

-- when text changes in an editbox, show/hide clear button and update team var
-- the OnChar will make sure the editbox has a valid value (or none at all)
function rematch:PreferencesOnTextChanged()
	local value = tonumber(self:GetText())
	self.Clear:SetShown(value and true or self:HasFocus())
	local working = dialog:GetContext("workingPrefs")
	if working then
		working[self.var] = value
	end
end

function rematch:PreferencesExpectedDDOnClick()
	local index = self:GetID()
	local working = dialog:GetContext("workingPrefs")
	if index==working.expectedDD then
		working.expectedDD = nil
	else
		working.expectedDD = index
	end
	rematch:UpdatePreferencesDialog()
end

function rematch:PreferencesAllowMMOnClick()
	local working = dialog:GetContext("workingPrefs")
	working.allowMM = self:GetChecked() or nil
end

-- tooltip of expected type buttons calculates damage expected
function rematch:PreferencesExpectedDDOnEnter()
	local petType = self:GetID()
	local working = dialog:GetContext("workingPrefs")
	local minHP = working.minHP
	if not minHP then -- no min health defined, show a tooltip to describe what the buttons are for
		rematch.ShowTooltip(self,L["Expected damage taken"],L["The minimum health of pets can be adjusted by the type of damage they are expected to receive."])
	else
		local info = rematch.info
		wipe(info)
		tinsert(info,format("%s: %s",L["Damage expected"],rematch:PetTypeAsText(petType)))
		tinsert(info,format("%s: \124cffffd200%s",L["Minimum Health"],minHP))
		tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[petType][1]),minHP*1.5))
		tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[petType][2]),minHP*2/3))
		rematch:ShowTableTooltip(self,info)
	end
end

-- save button clicked in preferences dialog
function rematch:PreferencesSave()
	rematch:HideDialog()
	local prefSet = dialog:GetContext("prefSet")
	local prefKey = dialog:GetContext("prefKey")
	local working = dialog:GetContext("workingPrefs")

	local prefTable
	if prefSet=="team" then
		prefTable = saved[prefKey]
	elseif prefSet=="tab" then
		local tab = settings.TeamGroups[prefKey]
		if tab then
			if next(working) then -- if there are preferences to save
				tab[4] = {} -- then create a new table in 4th TeamGroups field
				prefTable = tab[4] -- and point to it to be filled from workingList
			else
				tab[4] = nil -- if no preferences to save, nil 4th TeamGroups field
			end
		end
	end
	if prefTable then -- copy preferences from workingPrefs
		for _,var in ipairs({"minHP", "allowMM", "expectedDD", "maxHP", "minXP", "maxXP"}) do
			prefTable[var] = working[var]
		end
	end

	-- if preferences of loaded team (or a team in tab with preferences changing), load the team
	-- this runs ProcessQueue also and will fetch any changed pets if needed
	if (prefSet=="team" and settings.loadedTeam==prefKey) or (prefSet=="tab" and rematch:GetTabFromTeam(settings.loadedTeam)==settings.SelectedTab) then
		rematch:LoadTeam(settings.loadedTeam)
	else
		rematch:UpdateUI() -- otherwise just update UI (ProcessQueue above will UpdateUI)
	end

end

-- wipes all preferences from workingPrefs and saves it
function rematch:PreferencesDelete()
	wipe(dialog:GetContext("workingPrefs"))
	rematch:PreferencesSave()
end

-- returns true if one of the team's preferences has a value
-- if tab is passed, returns true if that tab has preferences
function rematch:HasPreferences(team,tab)
	if tab and settings.TeamGroups[tab] and settings.TeamGroups[tab][4] then
		return true
	elseif team and (team.minHP or team.maxHP or team.minXP or team.maxXP) then
		return true
	end
end

function rematch:ArePreferencesActive()
	local team = saved[settings.loadedTeam]
	if not team then
		return false -- no team loaded, can't have preferences active
	end
	if team and (team.minHP or team.maxHP or team.minXP or team.maxXP) then
		return true
	end
	local tab = settings.TeamGroups[team.tab or 1]
	if tab then
		tab = tab[4] -- tab exists, make sure preferences table exists
		if tab and (tab.minHP or tab.maxHP or tab.minXP or tab.maxXP) then
			return true
		end
	end
end

-- click of team or tab radio button; only shown when looking at preferences of loaded team
function rematch:PreferencesRadioOnClick()
	dialog:SetContext("prefSet",self.prefSet)
	dialog:SetContext("prefKey",self.prefSet=="team" and settings.loadedTeam or rematch:GetTabFromTeam(settings.loadedTeam))
	dialog:SetContext("workingPrefs",nil) -- wipe them so it fills them in again
	rematch:UpdatePreferencesDialog()
end

-- returns a single preference value (minHP, allowMM, etc) and whether it came from the tab when prefLoaded true
-- ProcessQueue also uses this to get a combination of preferences (prefLoaded=true)
function rematch:GetPrefStatValue(stat,prefSet,prefKey,prefLoaded)
	if prefLoaded then -- we want loaded preference
		local team = saved[settings.loadedTeam]
		local teamStat, tabStat
		if team then
			teamStat = team[stat]
		end
		local tab = settings.TeamGroups[team.tab or 1]
		if tab and tab[4] then
			tabStat = tab[4][stat]
		end
		return tabStat or teamStat,tabStat and true
	else
		if prefSet=="team" then
			return saved[prefKey] and saved[prefKey][stat]
		elseif prefSet=="tab" then
			local tab = settings.TeamGroups[prefKey]
			return tab and tab[4] and tab[4][stat]
		end
	end
end

function rematch:PreferencesPauseButtonOnClick(button)
	if button=="RightButton" then
		settings.QueueNoPreferences = not settings.QueueNoPreferences
		rematch:UpdateQueue()
		rematch.ShowPreferencesTooltip(self)
	else
		rematch.ShowPreferencesDialog(self)
	end
end