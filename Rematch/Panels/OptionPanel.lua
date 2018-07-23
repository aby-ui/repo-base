local _,L = ...
local rematch = Rematch
local panel = RematchOptionPanel
local settings

local newIcon = " \124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:12:12\124t"

--[[ Option format:

	[1] = type of option: "check" "radio" "header" "widget" or "spacer"

	"check"
	[2] = the settings[var] of the optn ("FastPetCard", "ClickPetCard", etc)
	[3] = the name of the option as displayed ("Faster pet cards", "Click for pet cards", etc)
	[4] = the tooltip text of the option
	[5] = the settings[var] that the option is dependant upon ("AutoLoadTargetOnly" would have "AutoLoad" here)
	[6] = boolean whether this setting has a panel.funcs to run when clicked
	[7] = boolean whether this setting's function should run on login

	"radio"
	[2] = the shared settings[var] of the option
	[3] = the name of the option as displayed ("Minimized Standalone" "Maximized Standalone")
	[4] = the tooltip text of the option
	[5] = the value (number) to assign to the shared settings[var]

	"header"
	[2] = text to display in header
	[3] = header index (number, see below)

	"widget"
	[2] = name of widget (parentKey of childframe to RematchOptionPanel)

	Header indexes: These numbers are "keys" to the header (collapsed in settings.CollapsedOptHeaders).
	If changing headers, make sure not to reuse an index. It's ok if they're missing or if
	they're out of order. The index is merely for a permanent collapsed handle.
		0 = All Options
		1 = Targeting Options
		2 = Standalone Window Options
		3 = Appearance Options
		4 = Pet Card & Notes Options
		5 = Leveling Queue Options
		6 = Miscellaneous Options
		7 = Preferred Window Mode
		8 = Pet Filters
		9 = Toolbar Options
		10 = Team Options
		11 = Confirmation Options
]]

panel.opts = {
	{ "header", L["All Options"], 0 },
	{ "header", L["Targeting Options"], 1 },
	{ "check", "PromptToLoad", L["Prompt To Load"], L["When your new target has a saved team not already loaded, and the target panel isn't on screen, display a popup asking if you want to load the team.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."], nil, true },
	{ "check", "PromptWithMinimized", L["With Rematch Window"], L["Prompt to load with the Rematch window instead of a separate popup dialog."], "PromptToLoad" },
	{ "check", "PromptAlways", L["Always Prompt"], L["Prompt every time you interact with a target with a saved team not already loaded, instead of only the first time."], "PromptToLoad" },
	{ "check", "AutoLoad", L["Auto Load"], L["When you mouseover a new target that has a saved team not already loaded, immediately load it.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."], nil, true },
	{ "check", "AutoLoadShow", L["Show After Loading"], L["After a team auto loads, show the Rematch window."], "AutoLoad" },
	{ "check", "ShowOnInjured", L["Show On Injured"], L["When a team auto loads, show the Rematch window if any pets in the team are injured."], "AutoLoad" },
	{ "check", "AutoLoadTargetOnly", L["On Target Only"], L["Auto load upon targeting only, not mouseover.\n\n\124cffff4040WARNING!\124r This is not recommended! It can be too late to load pets if you target with right click!"], "AutoLoad", true },
	{ "check", "ShowOnTarget", L["Always Show When Targeting"], L["Regardless whether a target's team is already loaded, show the Rematch window when you target something with a saved team."] },
	{ "header", L["Preferred Window Mode"], 7 },
	{ "radio", "PreferredMode", L["Minimized Standalone"], L["When automatically showing the Rematch window, show the minimized standalone window."], 1 },
	{ "radio", "PreferredMode", L["Maximized Standalone"], L["When automatically showing the Rematch window, show the maximized standalone window."], 2 },
	{ "radio", "PreferredMode", L["Pet Journal"], L["When automatically showing the Rematch window, show the pet journal."], 3 },
	{ "header", L["Standalone Window Options"], 2 },
	{ "widget", "Growth" },
	{ "spacer" }, -- Growth widget takes up two rows
	{ "widget", "CustomScale", L["Use Custom Scale"], L["Change the relative size of the standalone window to anywhere between 50% and 200% of its standard size."], nil, true },
	{ "check", "SinglePanel", L["Single Panel Mode"], L["Collapse the maximized standalone window to one panel instead of two side by side.\n\nUsers of earlier versions of Rematch may find this mode more familiar."], nil, true },
	{ "check", "UseMiniQueue", L["Combine Pets And Queue"], L["In single panel mode, combine the Pets and Queue tabs together. A narrow queue will display to the right of the pet list instead of in a separate tab."], "SinglePanel", true },
	{ "check", "LockWindow", L["Keep Window On Screen"], L["Don't hide the standalone window when the ESCape key is pressed or most other times it would hide, such as going to the game menu."], nil, true },
	{ "check", "StayForBattle", L["Even For Pet Battles"], L["Keep the standalone window on the screen even when you enter pet battles."], "LockWindow" },
	{ "check", "StayOnLogout", L["Even Across Sessions"], L["If the standalone window was on screen when logging out, automatically summon it on next login."], "LockWindow" },
	{ "check", "LockDrawer", L["Don't Minimize With ESC Key"], L["Don't minimize the standalone window when the ESCape key is pressed."], nil, true, true },
	{ "check", "DontMinTabToggle", L["Or With Panel Tabs"], L["Don't let the Pets, Teams, Queue or Options tabs minimize the standalone window."], "LockDrawer" },
	{ "check", "LowerStrata", L["Lower Window Behind UI"], L["Push the standalone window back behind other parts of the UI so other parts of the UI can appear ontop."], nil, true, true },
	{ "check", "PanelTabsToRight", L["Move Panel Tabs To Right"], L["Align the Pets, Teams, Queue and Options tabs to the right side of the standalone window."], nil, true, true },
	{ "check", "MiniMinimized", L["Minimal Minimized Window"], L["Remove the titlebar and tabs when the standalone window is minimized."] },
	{ "header", L["Appearance Options"], 3 },
	{ "check", "SlimListButtons", L["Compact List Format"], L["Use an alternate style of lists for Pets, Teams and Queue to display more on the screen at once.\n\n\124cffff4040This option requires a Reload."], nil, true },
	{ "check", "SlimListSmallText", L["Use Smaller Text Too"], L["Also use smaller text in the Compact List Format so more text displays on each button."], "SlimListButtons", true },
	{ "check", "ColorPetNames", L["Color Pet Names By Rarity"], L["Make the names of pets you own the same color as its rarity. Blue for rare, green for uncommon, etc."], nil, true },
	{ "check", "HideRarityBorders", L["Hide Rarity Borders"], L["Don't color the icon border for pets you own in the same color as its rarity."], nil, true },
	{ "check", "HideLevelBubbles", L["Hide Level At Max Level"], L["If a pet is level 25, don't show its level on the pet icon."], nil, true },
	{ "check", "ShowAbilityNumbers", L["Show Ability Numbers"], L["In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."], nil, true },
	{ "check", "ShowAbilityNumbersLoaded", L["On Loaded Abilities Too"], L["In addition to the flyouts, show the numbers 1 and 2 on loaded abilities."], "ShowAbilityNumbers", true },
	{ "header", L["Toolbar Options"], 9 },
	{ "check", "BottomToolbar", L["Move Toolbar To Bottom"], L["Move the toolbar buttons (Revive Battle Pets, Battle Pet Bandages, Safari Hat, etc) to the bottom of the standalone window.\n\nAlso convert the red panel buttons (Save, Save As, Find Battle) to toolbar buttons."], nil, true },
	{ "check", "ReverseToolbar", L["Reverse Toolbar Buttons"], L["Reverse the order of the toolbar buttons (Revive Battle Pets, Battle Pet Bandages, Safari Hat, etc)."], nil, true },
	{ "check", "ToolbarDismiss", L["Hide On Toolbar Right Click"], L["When a toolbar button is used with a right click, dismiss the Rematch window after performing its action."] },
	{ "check", "SafariHatShine", L["Safari Hat Reminder"], L["Draw attention to the safari hat button while a pet below max level is loaded.\n\nAlso show the Rematch window when a low level pet loads and the safari hat is not equipped."], nil, true },
	{ "header", L["Pet Card & Notes Options"], 4 },
	{ "check", "FixedPetCard", L["Allow Pet Cards To Be Pinned"], L["When dragging a pet card to another part of the screen, pin the card so all future pet cards display in the same spot, until the pet card is moved again or the unpin button is clicked."], nil, true },
	{ "check", "ClickPetCard", L["Click For Pet Cards & Notes"], L["Instead of automatically showing pet cards and notes when you mouseover them, require clicking the pet or notes button to display them."] },
	{ "check", "FastPetCard", L["Faster Pet Cards & Notes"], L["Instead of a small delay before showing pet cards and notes, immediately show them as you mouseover pets and notes buttons."] },
	{ "check", "PetCardInBattle", L["Use Pet Cards In Battle"], L["Use the pet card on the unit frames during a pet battle instead of the default tooltip."] },
	{ "check", "PetCardForLinks", L["Use Pet Cards For Links"], L["Use the pet card when viewing a link of a pet someone else sent you instead of the default link."] },
	{ "check", "NotesNoESC", L["Keep Notes On Screen"], L["Don't hide notes when the ESCape key is pressed or other times it would hide, such as changing tabs or closing Rematch."], nil, true, true },
	{ "check", "ShowNotesOnTarget", L["Show Notes Upon Targeting"], L["When your target has a saved team with notes, automatically display and lock the notes."] },
	{ "check", "ShowNotesInBattle", L["Show Notes In Battle"], L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] },
	{ "check", "ShowNotesOnce", L["Only Once Per Team"], L["Only display notes automatically the first time entering battle, until another team is loaded."], "ShowNotesInBattle" },
	{ "check", "BoringLoreFont", L["Alternate Lore Font"], L["Use a more normal-looking font for lore text on the back of the pet card."], nil, true, true },
	{ "check", "ShowSpeciesID", L["Show Species ID & Ability ID"], L["Display the numerical species ID of a pet as a stat on their pet card and the numerical ability ID on ability tooltips."] },
	{ "header", L["Team Options"]..newIcon, 10 },
   { "check", "LoadHealthiest", L["Load Healthiest Pets"], L["When a team loads, if any pet is injured or dead and there's another version with more health \124cffffffffand identical stats\124r, load the healthier version.\n\nPets in the leveling queue are exempt from this option.\n\n\124cffffffffNote:\124r This is only when a team loads. It will not automatically swap in healthier pets when you leave battle."] },
   { "check", "LoadHealthiestAny", L["Allow Any Version"], L["Instead of choosing only the healthiest pet with identical stats, choose the healthiest version of the pet regardless of stats."], "LoadHealthiest" },
	{ "check", "HideTargetNames", L["Hide Targets Below Teams"], L["Hide the target name that appears beneath a team that is not named the same as its target."] },
	{ "check", "AlwaysTeamTabs", L["Always Show Team Tabs"], L["Show team tabs along the right side of the window even if you're not on the team panel."], nil, true },
	{ "check", "TeamTabsToLeft", L["Move Team Tabs To Left"], L["Move the team tabs along the right side of the standalone window to the left side."], "AlwaysTeamTabs", true },
	{ "check", "AutoWinRecord", L["Auto Track Win Record"], L["At the end of each battle, automatically record whether the loaded team won or lost.\n\nForfeits always count as a loss.\n\nYou can still manually update a team's win record at any time."] },
	{ "check", "AutoWinRecordPVPOnly", L["For PVP Battles Only"], L["Automatically track whether the loaded team won or lost only in a PVP battle and never for a PVE battle."], "AutoWinRecord" },
	{ "check", "AlternateWinRecord", L["Display Total Wins Instead"], L["Instead of displaying the win percentage of a team on the win record button, display the total number of wins.\n\nTeam tabs that are sorted by win record will sort by total wins also."], nil, true },
	{ "check", "HideWinRecord", L["Hide Win Record Buttons"], L["Hide the win record button displayed to the right of each team.\n\nYou can still manually edit a team's win record from its right-click menu and automatic tracking will continue if enabled."], nil, true },
   { "check", "UseLegacyExport", L["Share In Legacy Format"], L["When exporting teams or sending to another Rematch user, use the old format.\n\nUse this option when sharing teams with someone on an older Rematch that's unable to import or receive newer teams."] },
   { "check", "PrioritizeBreedOnImport", L["Prioritize Breed On Import"], L["When importing or receiving teams, fill the team with the best matched breed as the first priority instead of the highest level."] },
   { "check", "RandomAbilitiesToo", L["Randomize Abilities Too"], L["For random pets, randomize the pets' abilities also."]},
   { "check", "AllowRandomPetsFromTeams", L["Allow Random Pets From Teams"]..newIcon, L["The default behavior for a random pet slot is to not choose a random pet saved in another team, unless all three pet slots are random.\n\nEnable this option to always allow pets from other teams to be included in the random pool."] },
	{ "header", L["Leveling Queue Options"], 5 },
	{ "check", "QueueSkipDead", L["Prefer Living Pets"], L["When loading pets from the queue, skip dead pets and load living ones first."], nil, true },
	{ "check", "QueuePreferFullHP", L["And At Full Health"], L["Also prefer uninjured pets when loading pets from the queue."], "QueueSkipDead", true },
	{ "check", "QueueDoubleClick", L["Double Click To Send To Top"], L["When a pet in the queue panel is double clicked, send it to the top of the queue instead of summoning it."] },
	{ "check", "HidePetToast", L["Hide Leveling Pet Toast"], L["Don't display the popup 'toast' when a new pet is automatically loaded from the leveling queue."] },
	{ "check", "QueueAutoLearn", L["Automatically Level New Pets"], L["When you capture or learn a pet, automatically add it to the leveling queue."] },
	{ "check", "QueueAutoLearnOnly", L["Only Pets Without A 25"], L["Only automatically level pets which don't have a version already at 25 or in the queue."], "QueueAutoLearn" },
	{ "check", "QueueAutoLearnRare", L["Only Rare Pets"], L["Only automatically level rare quality pets."], "QueueAutoLearn" },
	{ "header", L["Pet Filter Options"]..newIcon, 8 },
   { "check", "StrongVsLevel", L["Use Level In Strong Vs Filter"]..newIcon, L["When doing a Strong Vs filter, take the level of the pet into account. If a pet is not high enough level to use a Strong Vs ability, do not list the pet.\n\n\124cffffffffNote:\124r A Strong Vs filter is sometimes useful for identifying pets you want to level or capture. This option will hide those pets while the Strong Vs filter is active."], nil, true },
	{ "check", "ResetFilters", L["Reset Filters On Login"], L["When logging in, start with all pets listed and no filters active."] },
	{ "check", "ResetSortWithFilters", L["Reset Sort With Filters"], L["When clearing filters, also reset the sort back to the default: Sort by Name, Favorites First."], nil, true },
	{ "check", "ResetExceptSearch", L["Don't Reset Search With Filters"], L["When manually clearing filters, don't clear the search box too.\n\nSome actions, such as logging in or Find Similar, will always clear search regardless of this setting."] },
	{ "check", "SortByNickname", L["Sort By Chosen Name"], L["When pets are sorted by name, sort them by the name given with the Rename option instead of their original name."], nil, true },
	{ "check", "DontSortByRelevance", L["Don't Sort By Relevance"], L["When searching for something by name in the search box, do not sort the results by relevance.\n\nWhen sorted by relevance, pets with the search term in their name are listed first, followed by terms in notes, then abilities and then source text last."], nil, true },
   { "check", "HideNonBattlePets", L["Hide Non-Battle Pets"], L["Only list pets that can battle. Do not list pets like balloons, squires and other companion pets that cannot battle."], nil, true },
   { "check", "AllowHiddenPets", L["Allow Hidden Pets"], L["Allow the ability to hide specific pet species in the pet list with a 'Hide Pet' in the list's right-click menu.\n\nYou can view pets you've hidden from the Other -> Hidden Pets filter."], nil, true },
	{ "header", L["Confirmation Options"], 11 },
	{ "check", "DontWarnMissing", L["Don't Warn About Missing Pets"], L["Don't display a popup when a team loads and a pet within the team can't be found."] },
	{ "check", "DontConfirmHidePets", L["Don't Ask When Hiding Pets"], L["Don't ask for confirmation when hiding a pet.\n\nYou can view hidden pets in the 'Other' pet filter."] },
	{ "check", "NoBackupReminder", L["Don't Remind About Backups"], L["Don't show a popup offering to backup teams every once in a while. Generally, the popup appears sometime after the number of teams increases by 50."] },
	{ "header", L["Miscellaneous Options"], 6 },
	{ "check", "ShowAfterBattle", L["Show After Pet Battle"], L["Show the Rematch window after leaving a pet battle."] },
	{ "check", "DisableShare", L["Disable Sharing"], L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] },
	{ "check", "UseMinimapButton", L["Use Minimap Button"], L["Place a button on the minimap to toggle Rematch and load favorite teams."], nil, true, true },
	{ "check", "KeepSummoned", L["Keep Companion"], L["After a team is loaded, summon back the companion that was at your side before the load; or dismiss the pet if you had none summoned."] },
	{ "check", "NoSummonOnDblClick", L["No Summon On Double Click"], L["Do nothing when pets within Rematch are double-clicked. The normal behavior of double click throughout Rematch is to summon or dismiss the pet."] },
	{ "check", "HideTooltips", L["Hide Tooltips"], L["Hide the more common tooltips in Rematch."] },
	{ "check", "HideMenuHelp", L["Hide Extra Help"], L["Hide the informational \"Help\" items found in many menus and on the pet card."] },
   { "check", "UseDefaultJournal", L["Use Default Pet Journal"], L["Turn off Rematch integration with the default pet journal.\n\nYou can still use Rematch in its standalone window, accessed via key binding, /rematch command or from the Minimap button if enabled in options."], nil, true },
   { "check", "DebugJournalFrameLevel", L["Debug: Journal FrameLevel"], L["If you experience problems opening Rematch in the Collections window, and the standalone window works fine, then check this to see if it helps. Let me know if it does or doesn't, thanks!"] },
	{ "text", format(L["Rematch version %s"],GetAddOnMetadata("Rematch","Version")) },
	{ "text", format(L["The%s icon indicates new options."],newIcon) },
}

-- list of children of each button and children of panel to hide when list is updated
panel.widgets = { "Header", "Text", "CheckButton", "RadioButton", "Growth", "CustomScale" }

panel.funcs = {} -- where setting functions are stored (ie panel.func.AutoLoad)

panel.workingList = {} -- working list of indexes to display

rematch:InitModule(function()
	rematch.OptionPanel = panel
	settings = RematchSettings
	local scrollFrame = panel.List.ScrollFrame
	scrollFrame.update = panel.Update
	scrollFrame.ScrollBar.doNotHide = true
	scrollFrame.stepSize = 144
	HybridScrollFrame_CreateButtons(scrollFrame,"RematchOptionListButtonTemplate")
	for i,info in ipairs({
		{"BOTTOMRIGHT",3,-3,0.5,1.2,1.2,0.5,-0.2,0.5,0.5,-0.2},
		{"TOPRIGHT",3,3,-0.2,0.5,0.5,1.2,0.5,-0.2,1.2,0.5},
		{"BOTTOMLEFT",-3,-3,1.2,0.5,0.5,-0.2,0.5,1.2,-0.2,0.5},
		{"TOPLEFT",-3,3,0.5,-0.2,-0.2,0.5,1.2,0.5,0.5,1.2},
	}) do
		panel.Growth.Corners[i].Icon:SetTexture("Interface\\AddOns\\Rematch\\Textures\\MiniRematch")
		panel.Growth.Corners[i].Arrow:ClearAllPoints()
		panel.Growth.Corners[i].Arrow:SetPoint(info[1],panel.Growth.Corners[i],info[1],info[2],info[3])
		panel.Growth.Corners[i].Arrow:SetTexCoord(info[4],info[5],info[6],info[7],info[8],info[9],info[10],info[11])
	end
	panel.Growth.Label:SetText(L["Anchor"])
	settings.CollapsedOptHeaders = settings.CollapsedOptHeaders or {}
	settings.PreferredMode = settings.PreferredMode or 1

	panel.CustomScale.ScaleButton:SetNormalFontObject(GameFontNormal)
	panel.CustomScale.ScaleButton:SetHighlightFontObject(GameFontHighlight)

   -- if first time with AllowHiddenPets option, check if any pets are hidden and default option to on
   if not settings.AllowHiddenPetsDefaulted then
      settings.AllowHiddenPetsDefaulted = true
      if settings.HiddenPets then
         settings.AllowHiddenPets = next(settings.HiddenPets) and true
      end
   end

	-- remove leveling toast option if ElvUI is enabled
	if IsAddOnLoaded("ElvUI") then
		for i=#panel.opts,1,-1 do
			if panel.opts[i][2]=="HidePetToast" then
				panel.opts[i][4] = format(L["%s\n\n%sWARNING!\124r There may be an issue with pet toasts in ElvUI not positioning properly. While using ElvUI it's recommended pet toasts remain hidden unless you've moved alerts in ElvUI."],panel.opts[i][4],rematch.hexRed)
				-- when ElvUI is enabled, if we've not set a default for toast yet, define it to true
				if not settings.ElvUIToastDefaulted then
					settings.ElvUIToastDefaulted = true
					settings.HidePetToast = true
				end
			end
		end
	end

	panel:PopulateList()

	if rematch.localeSquish then -- make text smaller if on deDE client
		for _,button in ipairs(scrollFrame.buttons) do
			button.Header:SetNormalFontObject(GameFontNormalSmall)
			button.Header:SetHighlightFontObject(GameFontHighlightSmall)
			button.Text:SetFontObject(GameFontHighlightSmall)
		end
		panel.CustomScale.Text:SetFontObject(GameFontHighlightSmall)
	end
end)

-- called in Main.lua after all initfuncs are run: any option with true as a 7th parameter
-- will run the panel.funcs[NameOfOption] during startup
function panel:RunOptionInits()
	for _,opt in ipairs(panel.opts) do
		if opt[7] and opt[6] and panel.funcs[opt[2]] then
			panel.funcs[opt[2]]()
		end
	end
end

function panel:PopulateList()
	local list = panel.workingList
	wipe(list)
	local skipping
	panel.allCollapsed = true
	for index,opt in ipairs(panel.opts) do
		if opt[1]=="header" or opt[1]=="text" then
			tinsert(list,index)
			if settings.CollapsedOptHeaders[opt[3]] then
				skipping = true
			else
				skipping = nil
			end
		elseif not skipping then
			tinsert(list,index)
			panel.allCollapsed = nil
		end
	end
end

function panel:Update()
	local numData = #panel.workingList
	local scrollFrame = panel.List.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	for _,widget in ipairs(panel.widgets) do
		if panel[widget] then
			panel[widget]:Hide()
		end
	end

	for i=1,#buttons do
		local index = panel.workingList[i+offset]
		local button = buttons[i]
		button.index = index
		local opt = panel.opts[index]
		if index and index<=#panel.opts then
			for _,widget in ipairs(panel.widgets) do
				if button[widget] then
					button[widget]:Hide() -- hide all widgets for each button first
				end
			end
			button.Text:SetPoint("LEFT",button.CheckButton,"RIGHT",2,0)
			if opt[1]=="header" then
				button.Header.Text:SetText(opt[2])
				button.Header:Show()

				button.headerIndex = opt[3]
				if settings.CollapsedOptHeaders[opt[3]] or (opt[3]==0 and panel.allCollapsed) then
					button.Header.ExpandIcon:SetTexCoord(0, 0.4375, 0, 0.4375)
				else
					button.Header.ExpandIcon:SetTexCoord(0.5625, 1, 0, 0.4375)
				end

			elseif opt[1]=="check" then
				button.Text:SetText(opt[3])
				button.CheckButton:SetChecked(settings[opt[2]] and true)
				button.CheckButton:SetPoint("LEFT",opt[5] and 20 or 4,0)
				if opt[5] and not settings[opt[5]] then
					button.CheckButton:Disable()
					button.Text:SetTextColor(0.5,0.5,0.5)
				else
					button.CheckButton:Enable()
					button.Text:SetTextColor(1,1,1)
				end
				button.Text:Show()
				button.CheckButton:Show()
			elseif opt[1]=="radio" then
				button.Text:SetText(opt[3])
				button.RadioButton:SetChecked(settings[opt[2]]==opt[5])
				button.RadioButton:SetPoint("LEFT",5,0)
				button.CheckButton:SetPoint("LEFT",4,0) -- so text is aligned properly
				button.Text:SetTextColor(1,1,1)
				button.Text:Show()
				button.RadioButton:Show()
			elseif opt[1]=="widget" then
				panel[opt[2]]:SetParent(button)
				panel[opt[2]]:SetPoint("TOPLEFT",button,"TOPLEFT")
				panel[opt[2]]:Show()
				if panel[opt[2]].Update then
					panel[opt[2]]:Update()
				end
			elseif opt[1]=="text" then
				button.Text:SetText(opt[2])
				button.Text:SetTextColor(0.65,0.65,0.65)
				button.Text:SetPoint("LEFT",8,0)
				button.Text:Show()
			end
			button:Show()
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame,24*numData,24)
end

function panel:GrowthOnEnter()
	local id = self:GetID()
	local corner = id==1 and L["Bottom Right"] or id==2 and L["Top Right"] or id==3 and L["Bottom Left"] or L["Top Left"]
	rematch.ShowTooltip(self,format(L["Anchor: %s"],corner),format(L["When the standlone window is minimized, send it to the %s corner."],corner),"BOTTOMRIGHT",self,"TOPLEFT")
end

function panel.Growth:Update()
	for i=1,4 do
		panel.Growth.Corners[i]:SetChecked(settings.CornerPos==panel.Growth.Corners[i].corner)
	end
end

function panel:GrowthOnClick()
	settings.CornerPos = self.corner
	panel.Growth:Update()
	rematch.Frame:UpdateCorner()
	rematch.Frame:UpdateSinglePanelButton()
end

function panel.CustomScale:Update()
	panel.CustomScale.Text:SetText(L["Use Custom Scale"])
	panel.CustomScale.index = self:GetParent().index
	panel.CustomScale.CheckButton:SetChecked(settings.CustomScale)
	panel.CustomScale.CheckButton:SetHitRectInsets(-2,settings.CustomScale and -2-panel.CustomScale.Text:GetStringWidth() or -200,-2,-2)
	panel.CustomScale.ScaleButton:SetShown(settings.CustomScale)
	local scale = settings.CustomScaleValue or 100
	panel.CustomScale.ScaleButton:SetText(format("%d%%",scale))
	panel.CustomScale.ScaleButton.tooltipTitle = format(L["Current Scale: %d%%"],scale)
	panel.CustomScale.ScaleButton.tooltipBody = L["Click here to choose a different scale for the standalone window."]..(rematch.Journal:IsVisible() and format(L["\n\n%sThis will close the journal and open the standalone window."],rematch.hexRed) or "")
end

function panel:ListButtonOnEnter()
	local index = self:GetID()==0 and self:GetParent().index or self.index
	local title = panel.opts[index][3]:gsub("\124T.-$","")
	local body = panel.opts[index][4]
	if rematch.Journal:IsVisible() then -- make tooltips on journal anchor to left out of the way
		rematch.ShowTooltip(self,title,body,"RIGHT",self,"LEFT")
	else -- otherwise smart anchor (can't always do left; window may be flush against left edge)
		rematch.ShowTooltip(self,title,body)
	end
end

function panel:CheckButtonOnClick()
	local opt = panel.opts[self:GetParent().index]
	settings[opt[2]] = self:GetChecked()
	if opt[6] and panel.funcs[opt[2]] then
		panel.funcs[opt[2]]()
	end
	panel:Update()
end

function panel:RadioButtonOnClick()
	local opt = panel.opts[self:GetParent().index]
	settings[opt[2]] = opt[5]
	panel:Update()
end

--[[ funcs to run when options are clicked ]]

function panel.funcs.LockWindow()
	rematch:SetESCable("RematchFrame",not settings.LockWindow)
end

function panel.funcs.LockDrawer()
	if settings.LockDrawer then
		RematchFrame.TitleBar.MinimizeButton:SetScript("OnKeyDown",nil)
	else
		RematchFrame.TitleBar.MinimizeButton:SetScript("OnKeyDown",RematchFrame.MinimizeOnKeyDown)
	end
end

function panel.funcs.NotesNoESC()
	if settings.NotesNoESC then
		rematch.Notes:SetScript("OnKeyDown",nil)
	else
		rematch.Notes:SetScript("OnKeyDown",rematch.Notes.OnKeyDown)
	end
end

panel.funcs.ColorPetNames = rematch.UpdateUI
panel.funcs.HideRarityBorders = rematch.UpdateUI
panel.funcs.HideLevelBubbles = rematch.UpdateUI
panel.funcs.ShowAbilityNumbers = rematch.UpdateUI
panel.funcs.ShowAbilityNumbersLoaded = rematch.UpdateUI
panel.funcs.ResetSortWithFilters = rematch.UpdateUI
panel.funcs.SortByNickname = rematch.UpdateRoster
panel.funcs.AlwaysTeamTabs = function()
	rematch.TeamTabs:SetParent(nil)
	rematch.TeamTabs:Configure(rematch.Frame:IsVisible() and rematch.Frame or rematch.Journal)
	rematch.TeamTabs:SetShown(settings.AlwaysTeamTabs)
	rematch.TeamTabs:Update()
end
panel.funcs.AutoLoad = function()
	if settings.AutoLoad then
		settings.PromptToLoad = nil
	end
	rematch:UpdateAutoLoadState()
	panel:Update()
end
panel.funcs.AutoLoadTargetOnly = function()
	rematch:UpdateAutoLoadState()
end
panel.funcs.PromptToLoad = function()
	if settings.PromptToLoad then
		settings.AutoLoad = nil
	end
	panel:Update()
end
panel.funcs.LowerStrata = function()
	RematchFrame:SetFrameStrata(settings.LowerStrata and "LOW" or "MEDIUM")
end
panel.funcs.UseMinimapButton = function()
	if settings.UseMinimapButton then
		rematch:CreateMinimapButton()
		rematch:MinimapButtonPosition()
	end
	if RematchMinimapButton then
		RematchMinimapButton:SetShown(settings.UseMinimapButton)
	end
end
panel.funcs.SinglePanel = function()
	if rematch.Frame:IsVisible() then
		rematch.Frame:ConfigureFrame()
	end
end
panel.funcs.ReverseToolbar = function()
	rematch.Toolbar:Resize(rematch.Toolbar.width)
end
panel.funcs.PanelTabsToRight = function()
	local anchorPoint, relativePoint, xoff = "TOPLEFT", "BOTTOMLEFT", 0
	if settings.PanelTabsToRight then
		anchorPoint, relativePoint, xoff = "TOPRIGHT", "BOTTOMRIGHT", -4
	end
	rematch.Frame.PanelTabs:ClearAllPoints()
	rematch.Frame.PanelTabs:SetPoint(anchorPoint,RematchFrame,relativePoint,xoff,1)
end

function panel:Resize(width)
	panel:SetWidth(width)
	for _,button in ipairs(panel.List.ScrollFrame.buttons) do
		button:SetWidth(width-32)
	end
end
panel.funcs.BottomToolbar = panel.funcs.SinglePanel

panel.funcs.FixedPetCard = function()
	if rematch.PetCard:IsVisible() then
		rematch:HidePetCard()
	end
end
panel.funcs.TeamTabsToLeft = function()
	local tabs = rematch.TeamTabs
	local parent = tabs:GetParent() or rematch.Frame
	tabs:SetParent(nil)
	tabs:Configure(parent)
	tabs:Show()
	tabs:Update()
end
panel.funcs.UseDefaultJournal = function()
	if rematch.Journal:IsVisible() then
		settings.ActivePanel = 4
		ToggleCollectionsJournal(2)
		if not rematch.Frame:IsVisible() then
			rematch.Frame:Toggle()
		end
	end
end
panel.funcs.SlimListButtons = function()
	local dialog = rematch:ShowDialog("SlimListButtons",300,180,L["Compact List Format"],L["Reload the UI now?"],YES,ReloadUI,NO)
	dialog:ShowText(L["You've chosen to change the setting for Compact List Format.\n\nThis change doesn't take effect until a reload or logout."],260,80,"TOP",0,-36)
	rematch.timeUIChanged = GetTime() -- prevent tooltip from scale shift
end
panel.funcs.SlimListSmallText = function()
	local winRecord = rematch.LoadedTeamPanel.Footnotes.WinRecord
	winRecord:GetScript("OnMouseUp")(winRecord) -- change the visible WinRecord button in LoadTeamPanel
	rematch:UpdateUI()
end
panel.funcs.QueueSkipDead = rematch.UpdateQueue
panel.funcs.QueuePreferFullHP = rematch.UpdateQueue
panel.funcs.UseMiniQueue = panel.funcs.SinglePanel
panel.funcs.BoringLoreFont = function()
	rematch.PetCard.Back.Middle.Lore:SetFontObject(settings.BoringLoreFont and "GameTooltipHeader" or "RematchLoreFont")
end
panel.funcs.SafariHatShine = rematch.UpdateUI
panel.funcs.HideWinRecord = rematch.UpdateUI
panel.funcs.AlternateWinRecord = rematch.UpdateUI
panel.funcs.ShowActualHealth = rematch.UpdateUI
panel.funcs.DontSortByRelevance = rematch.UpdateRoster
panel.funcs.HideNonBattlePets = function()
   rematch:HideMenu() -- in case pet filter menu open
   rematch.Roster:ClearAllFilters() -- to clear any existing Can Battle/Can't Battle filter
   rematch:UpdateRoster() -- to update list
end
panel.funcs.AllowHiddenPets = function()
   if not settings.AllowHiddenPets and settings.HiddenPets then
      wipe(settings.HiddenPets) -- if option being disabled, remove hidden pets
   end
   rematch:UpdateRoster()
end
panel.funcs.StrongVsLevel = rematch.UpdateRoster

-- collapses or expands an option header
function panel:HeaderOnClick()
	local headerIndex = self:GetParent().headerIndex
	local collapsed = settings.CollapsedOptHeaders
	if headerIndex==0 then -- All Options header
		wipe(collapsed)
		if not panel.allCollapsed then
			for index,opt in ipairs(panel.opts) do
				if opt[1]=="header" and opt[3]~=0 then
					collapsed[opt[3]] = true
				end
			end
		end
	else -- any other header, toggle the collapsed state
		if collapsed[headerIndex] then
			collapsed[headerIndex] = nil
		else
			collapsed[headerIndex] = true
		end
	end
	panel:PopulateList()
	panel:Update()
end

function panel:ShowCustomScaleDialog()
	if rematch:IsDialogOpen("CustomScale") then
		rematch:HideDialog()
		return
	end
	if not rematch.Frame:IsVisible() then
		settings.Minimized = nil
		rematch.Frame:Toggle() -- if we're changing scale from journal, switch to frame
	end
	local dialog = rematch:ShowDialog("CustomScale",300,200,L["Custom Scale"],L["Keep this scale?"],YES,rematch.UpdateUI,NO,panel.CancelScaleSlider)
	dialog:ShowText(L["This scale determines the relative size of the standalone window, where 100% is the standard size."],240,40,"TOP",0,-32)

	dialog:SetContext("oldScale",settings.CustomScaleValue)

	dialog.ScaleSlider:SetPoint("TOP",0,-106)
	dialog.ScaleSlider.updating = true -- semaphore to prevent doing full scale update
	dialog.ScaleSlider:SetValue(settings.CustomScaleValue or 100)
	dialog.ScaleSlider.updating = false
	dialog.ScaleSlider:Show()
end

function panel:CustomScaleSliderOnValueChanged(value)
	self.Value:SetText(format("%d%%",value))
	if not self.updating then
		settings.CustomScaleValue = self:GetValue()
		panel:RescaleFrame()
	end
end

function panel:CancelScaleSlider()
	settings.CustomScaleValue = rematch.Dialog:GetContext("oldScale")
	panel:RescaleFrame()
end

-- this should ONLY be run in reaction to values changing during options
-- NEVER NEVER NEVER during initialization!
-- value can be nil to turn off custom scale
function panel:RescaleFrame(value)
	local frame = rematch.Frame
	local oldScale = frame:GetEffectiveScale()
	local corner = settings.CornerPos
	local oldX = corner:match("LEFT") and frame:GetLeft() or frame:GetRight()
	local oldY = corner:match("TOP") and frame:GetTop() or frame:GetBottom()
	rematch.timeUIChanged = GetTime() -- prevent tooltip from scale shift
	rematch:AdjustScale(frame,true)
	local newScale = frame:GetEffectiveScale()
	settings.XPos = (oldX*oldScale)/newScale
	settings.YPos = (oldY*oldScale)/newScale
	frame:ClearAllPoints()
	frame:SetPoint(corner,UIParent,"BOTTOMLEFT",settings.XPos,settings.YPos)
end
panel.funcs.CustomScale = panel.RescaleFrame
