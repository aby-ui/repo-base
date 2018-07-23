local _,L = ...
local rematch = Rematch
local dialog = RematchDialog
local panel = dialog.ScriptFilter
local roster = rematch.Roster
local scripts

-- so a user can leave/return to a new script in progress, these values will be kept
-- and reset back to "New Script"/"" when a script saves
panel.newScriptName = L["New Script"] -- initial name for a new script
panel.newScriptCode = "" -- initial code for a new script

panel.referenceOpen = nil -- the reference currently open

rematch:InitModule(function()
	scripts = RematchSettings.ScriptFilters
	for k,v in ipairs({L["Help"],L["Pet Variables"],L["Exposed API"]}) do
		panel.ReferenceButtons[k]:SetText(v)
	end
   panel.scriptPetInfo = rematch:CreatePetInfo()
end)

-- if this is called in response to a menu editButton being clicked, self will be
-- the 'entry' table of the calling menu; which has an index to the script to edit
-- if this is called from "New Script" menu item, there is no index
function rematch:ShowScriptFilterDialog()
	rematch:HideDialog() -- force a hide in case bringing up a second script to reference and a new one was being worked on (this will save work in progress)
	local index = self.index
	local name = scripts[index] and scripts[index][1] or panel.newScriptName
	rematch:ShowDialog("ScriptFilterDialog",400,404,name or L["New Script"],nil,SAVE,panel.SaveScript,CANCEL,panel.CancelScript,L["Test"],panel.TestScript)
	panel:SetPoint("TOP",0,-36)
	panel:Show()

	dialog.MultiLine:SetSize(360,264)
	dialog.MultiLine:SetPoint("TOP",panel.Name,"BOTTOM",-2,-12)
	dialog.MultiLine:SetPoint("BOTTOM",panel,"BOTTOM",0,8)
	dialog.MultiLine:Show()
	local editBox = dialog.MultiLine.EditBox
	editBox:SetScript("OnTextChanged",panel.UpdatePanelButtons)
	editBox:SetScript("OnEditFocusGained",panel.OnEditFocusGained)
	editBox:SetScript("OnEscapePressed",panel.OnEscapePressed)

	panel.Name:SetText(name)
	panel.TestResult:Hide()
	panel.TestResultFlash:Hide()
	panel:HideReference()
	if not index then -- if new script, highlight name to be edited first
		if panel.newScriptCode:len()>0 then
			editBox:SetFocus()
		else
			panel.Name:HighlightText()
			panel.Name:SetFocus()
		end
		editBox:SetText(panel.newScriptCode)
	else
		panel.Name:SetText(scripts[index][1])
		editBox:SetText(scripts[index][2])
		editBox:SetFocus()
		dialog:SetContext("index",index)
	end
	panel:UpdatePanelButtons()
end

-- to run in pre-filter setup: sets up script filter environment if code waiting to run.
-- returns true if successful.
function rematch:SetupScriptEnvironment()
	local code = roster:GetFilter("Script","code")
	if code then
		rematch.scriptEnvironment = {
			print=print, table=table, string=string, format=format, pairs=pairs, ipairs=ipairs, select=select, tonumber=tonumber, tostring=tostring, random=random, type=type,
			C_PetJournal=C_PetJournal, C_PetBattles=C_PetBattles,
			GetBreed=panel.GetBreed, GetSource=panel.GetSource,
			AllSpeciesIDs=roster.AllSpecies, AllPetIDs=roster.AllOwnedPets,
			AllPets=roster.AllPets, AllAbilities=panel.AllAbilities,
			IsPetLeveling=function(petID) return rematch:IsPetLeveling(petID) end,
         petInfo=panel.scriptPetInfo,
		}
		-- it's critical that lua errors triggered by scripts not go through normal channels
		-- or it will be Rematch that's believed to be bugged and not the user script >:D
		local ok,func = pcall(function() return assert(loadstring(code,"")) end)
		if ok then -- code successfully parsed into a function, set it to environment
			panel.scriptFunc = func
			setfenv(panel.scriptFunc,rematch.scriptEnvironment)
		else -- code couldn't be turned into a function, throw a custom error with its lua error
			panel:ErrorHandler(func) -- func (second return from pcall) is the lua error instead of the function
		end
	end
end

-- to run after a filter finishes: cleans out environment (TODO: keep sanctioned stuff to reuse environment)
function rematch:CleanupScriptEnvironment()
	rematch.scriptEnvironment = nil
	if type(rematch.abilityList)~="table" then
		rematch.abilityList = {}
	end
	if type(rematch.levelList)~="table" then
		rematch.levelList = {}
	end
end

-- if an error happens, call this to inform the user and turn off the script.
-- it's very basic-looking by design. there should be zero ambiguity that this is a user
-- script error and not a big deal, vs an error in rematch which is a big deal.
function panel:ErrorHandler(message)
	message = (message or ""):gsub("^.-string \"\"%]%:",L["line "])
	-- if the error happened while ScriptFilter dialog was up, then it was due to Test button
	if rematch:IsDialogOpen("ScriptFilterDialog") then
		panel:ShowTestResults(message)
		dialog:SetContext("ScriptFailed",true) -- TestScript() will want to know script failed
	else -- otherwise this is a script attempting to be used out in the field: show an error dialog
		rematch:ShowDialog("ScriptError",300,164,L["Pet Filter Script Error"],nil,nil,nil,OKAY)
		dialog.Warning:SetPoint("TOP",0,-32)
		dialog.Warning.Text:SetText(format(L["Error in %s"],roster:GetFilter("Script","name") or UNKNOWN))
		dialog.Warning:Show()
		dialog:ShowText(message,260,64,"TOP",dialog.Warning,"BOTTOM")
	end
	roster:ClearFilter("Script")
	rematch:UpdateRoster()
end

-- list of variables passed to RunScriptFilter; must be in PRECISELY same order as roster's call
-- to RunScriptFilter()
local variables = { "owned", "petID", "speciesID", "customName", "level", "xp", "maxXp", "displayID",
	"isFavorite", "name", "icon", "petType", "creatureID", "sourceText", "description", "isWild",
	"canBattle", "tradable", "unique", "obtainable", "abilityList", "levelList" }

function rematch:RunScriptFilter(...) -- owned, petID, speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique, obtainable)
	local env = rematch.scriptEnvironment
	-- copy the variables to the environment
	for index,var in ipairs(variables) do
		env[var] = select(index,...)
	end
   -- set up the petInfo
   panel.scriptPetInfo:Fetch(env.owned and env.petID or env.speciesID)
	if panel.scriptFunc then
		local ok,value = pcall(panel.scriptFunc)
		if ok then
			return value
		else
			panel:ErrorHandler(value)
			return true
		end
	end
end

-- save button clicked
function panel:SaveScript()
	local index = dialog:GetContext("index") or #scripts+1
	local name = (panel.Name:GetText() or ""):trim()
	if name:len()==0 then
		name = L["New Script"]
	end
	local code = dialog.MultiLine.EditBox:GetText()
	if code and code:trim():len()>0 then
		scripts[index] = {name,code}
		roster:SetFilter("Script","code",code)
		roster:SetFilter("Script","name",name)
		rematch:UpdateRoster()
		panel.newScriptName = L["New Script"] -- reset working name/code for next script
		panel.newScriptCode = ""
	end
	rematch:UpdateScriptFilterMenu()
end

-- when use cancels or ESCs dialog, and this is a new script, note the working name and code
-- so it can be retrieved the next time it's run (they could be going to another script to
-- references its code)
function panel:CancelScript()
	if not dialog:GetContext("index") and not panel.referenceOpen then
		panel.newScriptName = panel.Name:GetText() or L["New Script"]
		panel.newScriptCode = dialog.MultiLine.EditBox:GetText() or ""
	end
end

function panel:TestScript()
	local code = dialog.MultiLine.EditBox:GetText()
	if code and code:trim():len()>0 then
		roster:SetFilter("Script","code",code)
		roster:SetFilter("Script","name",UNKNOWN)
		rematch:UpdateRoster()
		if not dialog:GetContext("ScriptFailed") then
			panel:ShowTestResults() -- no arg means it was a success
		end
		dialog:SetContext("ScriptFailed",nil)
	end
end

-- if message is true, an error happened while testing a script: display error
-- if message is nil, script ran just fine: display success status
function panel:ShowTestResults(message)
	local text
	if message then
		text = format(L["\124TInterface\\RaidFrame\\ReadyCheck-NotReady:16\124t Error %s"],message)
	else
		text = L["\124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t Script ran without errors!"]
	end
	panel.TestResult:SetText(text)
	panel.TestResultFlash:SetText(text)
	panel.TestResult:Show()
	panel.TestResultFlash:Show()
	panel.FlashAnimation:Play()
	dialog.MultiLine:SetPoint("BOTTOM",panel.TestResult,"TOP",0,12)
end

-- disables/enables Test and Save buttons in reaction to editbox text changing
function panel:UpdatePanelButtons()
	local code = dialog.MultiLine.EditBox:GetText()
	dialog.Other:SetEnabled(code and code:trim():len()>0)
	dialog.Other:SetShown(not panel.referenceOpen)
	local name = panel.Name:GetText()
	dialog.Accept:SetEnabled(dialog.Other:IsEnabled() and name and name:trim():len()>0)
	dialog.Accept:SetShown(not panel.referenceOpen)
	for i=1,3 do
		local button = panel.ReferenceButtons[i]
		if panel.referenceOpen==i then
			button:LockHighlight()
		else
			button:UnlockHighlight()
		end
	end
end

function panel:OnEditFocusGained()
	if panel.referenceOpen then
		self:ClearFocus()
	end
end

function panel:OnEscapePressed()
	self:ClearFocus()
end

--[[ iterator and helper functions exposed to environment ]]

-- when a script needs to grab abilities of a pet outside the present pet,
-- use this to prevent creating unnecessary tables
local scriptAbilityList, scriptLevelList -- will be used for this iterator only
function panel.AllAbilities(speciesID)
	if type(speciesID)~="number" then
		return function() end -- if this isn't a species then return an empty function
	end
	local i=0
	-- set up reused tables
	if not scriptAbilityList then
		scriptAbilityList = {}
		scriptLevelList = {}
	end
	C_PetJournal.GetPetAbilityList(speciesID,scriptAbilityList,scriptLevelList)
	return function()
		i=i+1
		if i<=#scriptAbilityList then
			return scriptAbilityList[i],scriptLevelList[i]
		end
	end
end

-- returns numerical breed of petID
function panel.GetBreed(petID)
	return rematch:GetBreedIndex(petID)
end

-- returns numerical source of a speciesID (1-10)
function panel.GetSource(speciesID)
	return roster:GetSpeciesSource(speciesID)
end

--[[ Reference

	At the top of the script dialog are three reference buttons to mouseover for
	info about the scripting system.  The GetID() of the buttons are:
		1 = Technical Notes
		2 = Pet Variables
		3 = Exposed API
	
	They display special tooltips in table format. Since 95% of users will never use
	this, they are generated on demand.
]]

panel.referenceInfo = {
	L["\124cffffd200-\124r Scripts are a way to create custom pet filters.\n\n\124cffffd200-\124r Scripts are Lua code and require some knowledge of the language and API to create your own filters.\n\n\124cffffd200-\124r Scripts run for each pet and should return true if the pet is to be listed.\n\n\124cffffd200-\124r Some variables are filled in as the script runs for each pet. See Pet Variables.\n\n\124cffffd200-\124r Scripts run in a restricted environment with no access outside its environment. See Exposed API.\n\n\124cffffd200-\124r All variables/tables created exist only in this environment and disappear when the filter finishes.\n\n\124cffffd200-\124r If the first line of the script is a --comment, it will be used as a tooltip in the Script menu."],
	L["These variables are defined as the script runs for each pet:\n\n\124cffffd200owned\124r \124cffaaaaaa(boolean)\124r\nWhether the pet is owned by the player.\n\n\124cffffd200petID\124r \124cffaaaaaa(string)\124r\nUnique ID of the owned pet, such as \"BattlePet-0-000004A98F18\".\n\n\124cffffd200speciesID\124r \124cffaaaaaa(number)\124r\nShared ID of the pet's family. Black Tabby Cats are species 42.\n\n\124cffffd200customName\124r \124cffaaaaaa(string)\124r\nName given to the pet by the player.\n\n\124cffffd200level\124r \124cffaaaaaa(number)\124r\nLevel of the pet, or nil for uncollected pets.\n\n\124cffffd200xp\124r \124cffaaaaaa(number)\124r\nAmount of xp the pet has in its current level.\n\n\124cffffd200maxXp\124r \124cffaaaaaa(number)\124r\nTotal amount of xp required to reach the pet's next level.\n\n\124cffffd200displayID\124r \124cffaaaaaa(number)\124r\nA numeric representation of a pet's model skin.\n\n\124cffffd200isFavorite\124r \124cffaaaaaa(boolean)\124r\nWhether the pet is favorited by the player.\n\n\124cffffd200name\124r \124cffaaaaaa(string)\124r\nTrue name of the pet species.\n\n\124cffffd200icon\124r \124cffaaaaaa(string)\124r\nTexture path of the pet's icon.\n\n\124cffffd200petType\124r \124cffaaaaaa(number)\124r\nValue between 1 and 10 for its type. 1=Humanoid, 2=Dragonkin, etc.\n\n\124cffffd200creatureID\124r \124cffaaaaaa(number)\124r\nThe npcID of the pet when it's summoned.\n\n\124cffffd200sourceText\124r \124cffaaaaaa(string)\124r\nFormatted text describing where the pet is from.\n\n\124cffffd200description\124r \124cffaaaaaa(string)\124r\nLore text of the species.\n\n\124cffffd200isWild\124r \124cffaaaaaa(boolean)\124r\nWhether the pet was a captured wild pet.\n\n\124cffffd200canBattle\124r \124cffaaaaaa(boolean)\124r\nWhether the pet can battle.\n\n\124cffffd200tradable\124r \124cffaaaaaa(boolean)\124r\nWhether the pet can be caged.\n\n\124cffffd200unique\124r \124cffaaaaaa(boolean)\124r\nWhether no more than one of the pet can be known at a time.\n\n\124cffffd200abilityList\124r \124cffaaaaaa(table)\124r\nArray of abilityIDs used by the species.\n\n\124cffffd200levelList\124r \124cffaaaaaa(table)\124r\nArray of levels the abilityIDs are learned.\n\nFurther information about pets can be retrieved with the \124cffffd200petInfo\124r system. See Process\\PetInfo.lua for more information."],
	L["The script environment is restricted with access to only common Lua and the following:\n\n\124cffffd200C_PetJournal \124cffaaaaaa(table)\124r\nThe default API for journal functions.\n\n\124cffffd200C_PetBattles \124cffaaaaaa(table)\124r\nThe default API for the battle UI.\n\n\124cffffd200GetBreed \124cffaaaaaa(function)\nArgument:\124r petID\n\124cffaaaaaaReturns:\124r The numeric breed (3-12) of a petID if one of the supported breed addons is enabled.\n\n\124cffffd200GetSource \124cffaaaaaa(function)\nArgument:\124r speciesID\n\124cffaaaaaaReturns:\124r The numeric source (1-10) of a speciesID. 1=Drop, 2=Quest, etc.\n\n\124cffffd200IsPetLeveling \124cffaaaaaa(function)\nArgument:\124r petID\n\124cffaaaaaaReturns:\124r Whether the given petID is in the leveling queue.\n\nA few iterator functions are also provided if you need to compare a pet against others. These are used in a for loop such as:\n\n\124cffcccccc    for speciesID in \124cffffd200AllSpeciesIDs()\124cffcccccc do\n      -- do something with speciesID\n    end\124r\n\n\124cffffd200AllSpeciesIDs \124cffaaaaaa(iterator function)\nReturns:\124r The next speciesID of all existing unique pets.\n\n\124cffffd200AllPetIDs \124cffaaaaaa(iterator function)\nReturns:\124r The next petID of all owned pets.\n\n\124cffffd200AllPets \124cffaaaaaa(iterator function)\nReturns:\124r The next petID or speciesID of all pets in the master list. Owned pets return a petID string, uncollected pets return a speciesID number.\n\n\124cffffd200AllAbilities \124cffaaaaaa(iterator function)\nArgument:\124r speciesID\n\124cffaaaaaaReturns:\124r The next abilityID and level of the ability for a speciesID.\n\124cffffd200Note:\124r abilityList and levelList are already defined for each pet as your script runs. Use this iterator if you need to gather abilities of other pets for comparison. See the Unique Abilities script for an example.\n\n\124cffffd200If you would like anything else exposed please post a comment on wowinterface, curse or warcraftpet's Rematch 4.0 thread."],
}

function panel:ShowReference(index)
	panel:UpdatePanelButtons()
	panel.TestResult:Hide()
	panel.TestResultFlash:Hide()
	panel.Name:Hide()
	for i=1,3 do
		panel.ReferenceButtons[i]:Hide()
	end
	local scrollFrame = dialog.MultiLine
	if not panel.referenceOpen then -- -- save state of editbox if not coming directly from another reference
		panel.oldScrollBarValue = scrollFrame.ScrollBar:GetValue()
		panel.oldCursorPosition = scrollFrame.EditBox:GetCursorPosition()
		panel.oldEditBoxText = scrollFrame.EditBox:GetText()
	end
	scrollFrame:SetPoint("TOP",panel,"TOP",-1,-2)
	scrollFrame.EditBox:ClearFocus()
	scrollFrame.EditBox:SetText(panel.referenceInfo[index])
	scrollFrame.ScrollBar:SetValue(0)
	scrollFrame.EditBox:SetCursorPosition(0)
	dialog.Cancel:SetText(BACK)
	panel.referenceOpen = index
end

function panel:HideReference()
	panel.Name:Show()
	for i=1,3 do
		panel.ReferenceButtons[i]:Show()
	end
	local scrollFrame = dialog.MultiLine
	scrollFrame:SetPoint("TOP",panel.Name,"BOTTOM",-1,-10)
	scrollFrame:SetPoint("BOTTOM",panel,"BOTTOM",0,8)
	panel.referenceOpen = nil
	if panel.oldEditBoxText then -- restore scrollframe's editbox to its pre-reference state
		scrollFrame.EditBox:SetText(panel.oldEditBoxText)
		scrollFrame.EditBox:SetCursorPosition(panel.oldCursorPosition)
		scrollFrame.ScrollBar:SetValue(panel.oldScrollBarValue)
		panel.oldEditBoxText = nil
		panel.oldCursorPosition = nil
		panel.oldScrollBarValue = nil
	end
	scrollFrame.EditBox:SetFocus(true)
	panel:UpdatePanelButtons()
	dialog.Cancel:SetText(CANCEL)
end

function panel:ReferenceButtonOnClick()
	local index = self:GetID()
	if panel.referenceOpen==index then
		panel:HideReference()
	else
		panel:ShowReference(index)
	end
end