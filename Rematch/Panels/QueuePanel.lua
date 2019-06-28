-- this handles just the UI of the leveling queue; QueueProcess.lua handles the backend stuff

local _,L = ...
local rematch = Rematch
local panel = RematchQueuePanel
local settings, saved, queue

-- icons and text used to describe each sort order
panel.sortInfo = {
	{ "Interface\\Icons\\misc_arrowlup", L["Ascending Level"] }, -- 1=ascending
	{ "Interface\\Icons\\misc_arrowdown", L["Descending Level"] }, -- 2=descending
	{ "Interface\\Icons\\Ability_Hunter_FocusedAim", L["Median Level"] }, -- 3=median
--	{ "Interface\\Icons\\Icon_UpgradeStone_Beast_Uncommon", L["Type"] }, -- 4=type
}

rematch:InitModule(function()
	rematch.QueuePanel = panel
	settings = RematchSettings
	saved = RematchSaved
	queue = settings.LevelingQueue

	panel.Top.QueueButton:SetText(L["Queue"])
   
	local scrollFrame = panel.List
	scrollFrame.template = settings.SlimListButtons and "RematchCompactPetListButtonTemplate" or "RematchNewPetListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = queue
	scrollFrame.callback = rematch.FillNewPetListButton
	scrollFrame.postUpdateFunc = panel.PostUpdateFunc	

	-- setup list scrollframe
	-- local scrollFrame = panel.List.ScrollFrame
	-- scrollFrame.update = panel.UpdateList
	-- scrollFrame.scrollBar.doNotHide = true
	-- scrollFrame.stepSize = 264 -- 44*6 or 6 rows

	-- if settings.SlimListButtons then
	-- 	HybridScrollFrame_CreateButtons(scrollFrame,"RematchSlimPetListButtonTemplate",28,-1)
	-- else
	-- 	HybridScrollFrame_CreateButtons(scrollFrame,"RematchPetListButtonTemplate",44,0)
	-- end

	-- for _,button in ipairs(scrollFrame.buttons) do
	-- 	button.forQueuePanel = true
	-- end

	settings.QueueSortOrder = settings.QueueSortOrder or 1

	local queueHelp = L["This is the leveling queue. Drag pets you want to level here.\n\nRight click any of the three battle pet slots and choose 'Put Leveling Pet Here' to mark it as a leveling slot you want controlled by the queue.\n\nWhile a leveling slot is active, the queue will fill the slot with the top-most pet in the queue. When this pet reaches level 25 (gratz!) it will leave the queue and the next pet in the queue will take its place.\n\nTeams saved with a leveling slot will reserve that slot for future leveling pets."]
	panel.List.Help:SetText(queueHelp)

	rematch:RegisterMenu("QueueMenu", { -- menu for Queue button in topright of panel
		{ text=L["Sort by:"], highlight=true, disabled=true },
		{ text=panel.sortInfo[1][2], icon=panel.sortInfo[1][1], radio=panel.GetActiveSort, index=1, value=panel.IsQueueSort, func=panel.SetQueueSort, tooltipBody=L["Sort all pets in the queue from level 1 to level 24."] },
		{ text=panel.sortInfo[3][2], icon=panel.sortInfo[3][1], radio=panel.GetActiveSort, index=3, value=panel.IsQueueSort, func=panel.SetQueueSort, tooltipBody=L["Sort all pets in the queue for levels closest to 10.5."] },
		{ text=panel.sortInfo[2][2], icon=panel.sortInfo[2][1], radio=panel.GetActiveSort, index=2, value=panel.IsQueueSort, func=panel.SetQueueSort, tooltipBody=L["Sort all pets in the queue from level 24 to level 1."] },
--		{ text=panel.sortInfo[4][2], icon=panel.sortInfo[4][1], radio=panel.GetActiveSort, index=4, value=panel.IsQueueSort, func=panel.SetQueueSort, tooltipBody=L["Sort all pets in the queue by their types."] },
		{ spacer=true },
		{ text=L["Favorites First"], icon="Interface\\Icons\\Achievement_GuildPerk_MrPopularity", check=panel.GetActiveSort, value=function() return settings.QueueSortFavoritesFirst end, func=panel.SetFavoritesFirst, tooltipBody=L["Group favorites to the top of the queue."] },
		{ text=L["Rares First"], icon="Interface\\Icons\\Icon_UpgradeStone_Rare", check=panel.GetActiveSort, value=function(self) return settings.QueueSortRaresFirst end, func=panel.SetRaresFirst, tooltipBody=L["Group rares to the top of the leveling queue."] },
		{ spacer=true },
		{ text=L["Active Sort"], check=true, value=panel.GetActiveSort, func=panel.SetActiveSort, tooltipBody=L["The queue will stay sorted in the order chosen. The order of pets may automatically change as they gain xp or get added/removed from the queue.\n\nYou cannot manually change the order of pets while the queue is actively sorted."] },
		{ text=L["Pause Preferences"], check=true, value=panel.GetQueueNoPreferences, func=panel.SetQueueNoPreferences, tooltipBody=L["Suspend all preferred loading of pets from the queue, except for pets that can't load."] },
		{ spacer=true },
		{ text=L["Fill Queue"], func=function() panel:ShowFillQueueDialog() end, tooltipBody=L["Fill the leveling queue with one of each version of a pet that can level from the filtered pet list, and for which you don't have a level 25 or one in the queue already."] },
		{ text=L["Fill Queue More"], func=function() panel:ShowFillQueueDialog(true) end, tooltipBody=L["Fill the leveling queue with one of each version of a pet that can level from the filtered pet list, regardless whether you have any at level 25 or one in the queue already."] },
		{ text=L["Empty Queue"], tooltipBody=L["Remove all leveling pets from the queue."], func=function()
				local dialog = rematch:ShowDialog("EmptyQueue",300,116,L["Empty Queue"],nil,YES,panel.EmptyQueue,NO)
				dialog:ShowText(L["Are you sure you want to remove all pets from the leveling queue?"],220,40,"TOP",0,-36)
			end },
		{ spacer=true },
		{ text=L["Help"], stay=true, hidden=function() return settings.HideMenuHelp end, icon="Interface\\Common\\help-i", iconCoords={0.15,0.85,0.15,0.85}, tooltipTitle=L["Leveling Queue"], tooltipBody=queueHelp },
		{ text=OKAY },
	},rematch.UpdateQueue)

	panel.Status.Clear.tooltipTitle = L["No Active Sort"]
	panel.Status.Clear.tooltipBody = format(L["Turn off Active Sort. Queued pets can then be rearranged and will not automatically reorder themselves.\n\nTo turn Active Sort back on, check %sActive Sort\124r in the Queue menu."],rematch.hexWhite)

end)

-- callback that runs after the petlist is updated
function panel:PostUpdateFunc()
	local petCard = rematch.PetCard
	local focus = GetMouseFocus()
	-- if pet card is up and it's different than pet under the mouse, update the pet card
	-- (so pet card changes during mousewheel scroll)
	if petCard:IsVisible() and focus and focus.petID and focus.petID~=petCard.petID then
		rematch:ShowPetCard(self,focus.petID)
	end
	-- show instructions "This is the leveling queue. Drag pets here..etc." if queue is empty
	panel.List.Help:SetShown(#queue==0 and not rematch.MiniQueue:IsVisible())
end

------------------

function panel:Update()
	if panel:IsVisible() then
		panel:UpdateTop()
		panel.List:Update()
	end
end

--[[ Leveling Slot ]]

-- this is called by the DropButton's click on receivedrag, to place a leveling pet in the top slot
-- note: this is still used in several places, do not remove
function panel:LevelingSlotReceiveDrag(index)
	if index then
		local petID = rematch:GetCursorPet()
		if rematch:PetCanLevel(petID) then
			if rematch:IsPetLeveling(petID) and settings.QueueActiveSort then
				local dialog = rematch:ShowDialog("CancelActiveSort",300,196,L["Turn Off Active Sort?"],nil,YES,function(self) settings.QueueActiveSort=nil panel:LevelingSlotReceiveDrag(index) end,NO)
				dialog:ShowText(L["This pet is already in the queue and Active Sort is enabled.\n\nWhile enabled, the queue has complete control over the order of pets in the queue.\n\nDo you want to turn off Active Sort to move this pet in the queue?"],260,122,"TOP",0,-32)
			else
				rematch:InsertPetToQueue(index,petID)
				ClearCursor()
				panel:BlingPetID(petID)
			end
		end
	end
end

-- flashes the given petID in the queue
function panel:BlingPetID(petID)
	for queueIndex,queuedPetID in ipairs(queue) do
		if queuedPetID==petID then
			panel.List:BlingIndex(queueIndex)
			return
		end
	end
end

-- this is actually an OnUpdate for the DropButton; to show/hide the child InsertLine
-- which is a child of DropButton.  While the DropButton is up, it constantly checks if
-- the mouse is over the scrollframe.  If so, it positions InsertLine (an invisible frame)
-- over the mouse to intercept clicks and positions a texture child of InsertLine onto
-- the button the pet would insert to.  Clicking InsertLine under the mouse will trigger
-- an InsertLevelingPet at that index.
function panel:InsertLineOnUpdate(elapsed)
	local insertLine = self.InsertLine
	local scrollFrame = rematch.QueuePanel.List.ScrollFrame -- DropButton:GetParent().List.ScrollFrame

	panel.DropButton.SlotBorder:Hide()
	panel.DropButton:ClearAllPoints()

	if not MouseIsOver(scrollFrame) then
		insertLine:Hide() -- not over the scrollframe, hide the insert frame/line
		return
	end
	-- we're over the scrollframe, first position the mouse-intercepting insertLine frame below mouse
	local x,y = GetCursorPosition()
	local scale = insertLine:GetEffectiveScale()
	insertLine:SetPoint("CENTER",UIParent,"BOTTOMLEFT",x/scale,y/scale)

	-- adjust width of pulsing line to the buttons it will be displayed between
	insertLine.Texture:SetWidth(panel.List:GetButtonWidth()-6)

	if panel.List:IsOverEmptyArea() then
		insertLine.index = -1 -- if so can mark index to -1 to add to queue and leave
		if #queue>0 then
			insertLine.Texture:SetPoint("CENTER",scrollFrame.Buttons[#queue],"BOTTOM")
			insertLine.Texture:Show()
		else
			insertLine.Texture:Hide()
		end
		insertLine:Show()
		return
	end

	-- now go through each button and see if we're over that button (can't GetMouseFocus() since
	-- mouse is intercepted) to know where to put the line texture
	insertLine.index = nil -- will be index to insert if applicable
	for i,button in ipairs(scrollFrame.Buttons) do
		local relativeTo
		local isVisible = button:IsVisible()
		if MouseIsOver(button) or (button.Pet and MouseIsOver(button.Pet)) or (button.Icon and MouseIsOver(button.Icon)) then
			if abs(y/scale-button:GetTop())<(panel.List.buttonHeight/2) then -- if cursor is closer to top of button
				relativeTo = "TOP" -- anchor line there
				insertLine.index = button.index -- and set its index to this button
			else -- if cursor is closer to bottom of button
				relativeTo = "BOTTOM" -- anchor line to bottom
				insertLine.index = button.index + 1 -- and set its index to the next button
			end
			-- now position the line texture itself relative to the button it's over instead of the parent insertLine
			insertLine.Texture:SetPoint("CENTER",button,relativeTo)
			-- before leaving, make sure line isn't above or below scrollframe (button is partially displayed)
			if (relativeTo=="TOP" and button:GetTop()>scrollFrame:GetTop()+6) or (relativeTo=="BOTTOM" and button:GetBottom()<scrollFrame:GetBottom()-6) then
				insertLine.index = nil -- prevent insertLine from being clickable (it checks for index)
				insertLine.Texture:Hide()
				insertLine:Show() -- going to keep insertLine up to intercept clicks
				return -- and leave early
			else
				insertLine.Texture:Show() -- everything ok, display the line
			end
			break
		end
	end
	insertLine:SetShown(insertLine.index and true)
end

--[[ queue menu ]]

function panel:GetActiveSort() return settings.QueueActiveSort and true end
function panel:SetActiveSort(_,checked)
	settings.QueueActiveSort = not checked
	settings.QueueSortOrder = settings.QueueSortOrder or 1
	rematch:ShowMenu("QueueMenu","TOPLEFT",panel.Top.QueueButton,"TOPRIGHT")
end
function panel:IsQueueSort() return settings.QueueSortOrder==self.index end
function panel:SetQueueSort()
	settings.QueueSortOrder = self.index
	rematch:HideMenu()
	rematch:SortQueue()
end
function panel:EmptyQueue() wipe(queue) rematch:UpdateQueue() end
function panel:GetQueueNoPreferences() return settings.QueueNoPreferences end
function panel:SetQueueNoPreferences(_,checked) settings.QueueNoPreferences = not checked end
function panel:SetFavoritesFirst(_,checked)
	if settings.QueueActiveSort then
		settings.QueueSortFavoritesFirst = not checked
	else
		rematch:StableSortQueue("favorites")
	end
end
function panel:SetRaresFirst(_,checked)
	if settings.QueueActiveSort then
		settings.QueueSortRaresFirst = not checked
	else
		rematch:StableSortQueue("rares")
	end
end

-- for the queue list, when pets are skipped they're dimmed by desaturating/darkening textures and fonts
function rematch:DimQueueListButton(button,dim)
	dim = dim and true -- convert nil to false
	local v = dim and 0.4 or 1
	if button.compact then -- compact format button
		button.LevelText:SetTextColor(v,v,v)
		button.Pet:SetDesaturated(dim)
		button.Pet:SetVertexColor(v,v,v)
		button.Breed:SetTextColor(v,v,v)
		button.TypeDecal:SetDesaturated(dim)
		button.TypeDecal:SetVertexColor(v,v,v)
		button.Favorite:SetDesaturated(dim)
		button.Favorite:SetVertexColor(v,v,v)
		button.Notes:SetDesaturated(dim)
		button.Notes:SetVertexColor(v,v,v)
		if dim then
			button.Name:SetTextColor(v,v,v)
			button.Back:SetVertexColor(0.15,0.15,0.15)
		end
	else -- standard format
		if dim then
			button.Name:SetTextColor(v,v,v)
			button.SubName:SetTextColor(v,v,v)
			button.LevelText:SetTextColor(v,v,v)
			button.Breed:SetTextColor(v,v,v)
			-- we don't want to mess with desaturation of rarity borders; replace with default slot border
			button.Rarity:SetVertexColor(v,v,v)
		else -- not dimmed, put everything back to normal
			-- button.Name is colored in FillPetListButton (preserve rarity coloring if enabled)
			button.SubName:SetTextColor(1,1,1)
			button.LevelText:SetTextColor(1,0.82,0)
			button.Breed:SetTextColor(0.9,0.9,0.9)
		end
		button.Pet:SetDesaturated(dim)
		button.Pet:SetVertexColor(v,v,v)
		button.Favorite:SetDesaturated(dim)
		button.Favorite:SetVertexColor(v,v,v)
		button.LevelBack:SetDesaturated(true)
		button.LevelBack:SetVertexColor(v,v,v)
		button.TypeDecal:SetDesaturated(dim)
		button.TypeDecal:SetVertexColor(v,v,v)
	end
end

-- regardless whether in journal, mini panel or tabbed frame, go to a queue tab
-- if petID is given, go to the petID
function rematch:ShowQueue(petID)
	-- team panel not visible, show it
	if not panel:IsVisible() then
		if rematch.Frame:IsVisible() then
			settings.Minimized = nil
			settings.ActivePanel = 3
			rematch.Frame:ConfigureFrame()
		elseif rematch.Journal:IsVisible() then
			settings.JournalPanel = 2
			rematch:SelectPanelTab(rematch.Journal.PanelTabs,2)
			rematch.Journal:ConfigureJournal()
		else
			return -- neither frame or journal on screen
		end
	end
	-- if key provided, scroll to team (which should be on the team panel workingList at this point)
	if petID then
		local index
		for i=1,#queue do
			if queue[i]==petID then
				index = i
			end
		end
		if index then
			panel.List:ScrollToIndex(index)
			panel.List:BlingIndex(index)
		end
	end
end


function panel:UpdateTop()
	-- update counter for pets in queue
	panel.Top.Count:SetText(format(L["Leveling Pets: %s%s"],rematch.hexWhite,#queue))
	local anchorTo = panel.Top -- what further components (Status, Preferences, List) anchor to

	if settings.QueueActiveSort then
		panel.Status:Show()
		if settings.QueueActiveSort and panel.sortInfo[settings.QueueSortOrder] then
			panel.Status.Text:SetText(L["Active Sort:"])
			panel.Status.Text:SetTextColor(1,0.82,0)
			panel.Status.Icon:SetTexture(panel.sortInfo[settings.QueueSortOrder][1])
			panel.Status.Icon:Show()
			panel.Status.Sort:SetText(panel.sortInfo[settings.QueueSortOrder][2])
			panel.Status.Sort:Show()
			panel.Status.Clear:Show()
		end
		anchorTo = panel.Status -- change anchorTo to this status bar
	else
		panel.Status:Hide()
	end
	local team = settings.loadedTeam and saved[settings.loadedTeam]
	if team and rematch:ArePreferencesActive() then
		panel.Top.Preferences:Show()
		panel.Top.Preferences.Paused:SetShown(settings.QueueNoPreferences)
		panel.Top.Count:SetPoint("LEFT",panel,"TOPLEFT",28,-15)
	else
		panel.Top.Preferences:Hide()
		panel.Top.Count:SetPoint("LEFT",panel,"TOPLEFT",10,-15)
	end
	panel.List:SetPoint("TOPLEFT",anchorTo,"BOTTOMLEFT",0,-2)
end

function panel:ShowFillQueueDialog(more)
	local dialog = rematch:ShowDialog("FillQueue",300,246,L["Fill Queue"],L["Add these pets to the queue?"],YES,function() rematch:FillQueue(nil,more) end,NO)
	local count = rematch:FillQueue(true,more)
	if count>50 then
		dialog:ShowText(format(L["This will add %s%d\124r pets to the leveling queue.\n\nYou can be more selective by filtering pets.\n\nFor instance, if you filter pets to High Level (15-24) and Rare, Fill Queue will only add rare pets between level 15 and 24."],rematch.hexWhite,count),220,140,"TOP",0,-36)
	else
		dialog:ShowText(format(L["This will add %s%d\124r pets to the leveling queue."],rematch.hexWhite,count),260,32,"TOP",0,-36)
		dialog:SetHeight(138)
	end
end

function panel:Resize(width)
	panel:SetWidth(width)
	panel.Top:SetWidth(width)
	panel.Status:SetWidth(width)
end
