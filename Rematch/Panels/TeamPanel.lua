local _,L = ...
local rematch = Rematch
local panel = RematchTeamPanel
local settings, saved

local workingList = {} -- list of teams (keys) being displayed
local searchText = nil -- desensitized text (or petID) entered in search box
local searchTabs = {} -- lookup table of tabs that have a search match

rematch:InitModule(function()
	rematch.TeamPanel = panel
	settings = RematchSettings
	saved = RematchSaved

   panel.Top.Team.Label:SetText(L["Loaded Team"])

	local scrollFrame = panel.List.ScrollFrame
	scrollFrame.update = panel.UpdateList
	scrollFrame.ScrollBar.doNotHide = true
	scrollFrame.stepSize = 264 -- 44*6 or 6 rows
	local slim = settings.SlimListButtons
	if slim then
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchSlimTeamListButtonTemplate",78,-1)
	else
		HybridScrollFrame_CreateButtons(scrollFrame,"RematchTeamListButtonTemplate",85,0)
	end
	for _,button in ipairs(scrollFrame.buttons) do
		button:RegisterForClicks("AnyUp")
		for i=1,3 do
			button.Pets[i]:RegisterForClicks("AnyUp")
			if not slim then
				button.Pets[i]:SetSize(28,36)
				button.Pets[i].Icon:SetTexCoord(0.16,0.84,0.05,0.95)
			end
		end
	end
	panel.Top.Team:RegisterForClicks("AnyUp")
	for i=1,3 do
		panel.Top.Team.Pets[i]:SetSize(28,36)
		panel.Top.Team.Pets[i].Icon:SetTexCoord(0.16,0.84,0.05,0.95)
	end
	panel.Top.Teams:SetText(L["Teams"])
	panel.Selected.Texture:SetHeight(settings.SlimListButtons and 20 or 40)
	rematch:UpdateAutoLoadState()
end)

function panel:Update()
	if panel:IsVisible() then
		panel:PopulateTeamList()
		panel:UpdateLoadedTeam()
		panel:UpdateList()
		local searching = panel.Top.SearchBox:GetText():len()>0
		panel.Top.SearchBox.Clear:SetShown(searching)
		panel.Top.SearchBox.Instructions:SetShown(not searching)
	end
end

function panel:UpdateLoadedTeam()
	panel.Top.Toggle:SetEnabled(settings.loadedTeam and true)
	if settings.ShowLoadedTeam and settings.loadedTeam then
		panel.Top:SetHeight(88)
		panel.Top.Team:Show()
		panel:FillTeamButton(panel.Top.Team,settings.loadedTeam)
	else
		panel.Top:SetHeight(29)
		panel.Top.Team:Hide()
	end
	rematch:SetTopToggleButton(panel.Top.Toggle,settings.ShowLoadedTeam)
end

function panel:ToggleLoadedTeam()
	settings.ShowLoadedTeam = not settings.ShowLoadedTeam
	panel:Update()
end

--[[ Working List ]]

-- normal sort: favorite -> name -> targeted -> untargeted
-- before doing this sort, set panel.sortByWins to try to sort by wins.
-- wins: favorite -> %wins -> #wins -> name -> targeted -> untargeted
function rematch.TeamSort(e1,e2)
	if e1 and not e2 then
		return true
	elseif not e1 and e2 then
		return false
	end
	local fav1 = saved[e1].favorite
	local fav2 = saved[e2].favorite
	if fav1 and not fav2 then
		return true
	elseif not fav1 and fav2 then
		return false
	end

	-- sort by wins if panel.sortByWins set before sort began (remember to turn it off afterwards!)
	if panel.sortByWins then
		local w1,_,_,b1 = rematch:GetTeamWinRecord(e1)
		local w2,_,_,b2 = rematch:GetTeamWinRecord(e2)
		local p1 = b1>0 and w1/b1
		local p2 = b2>0 and w2/b2
		if p1 and not p2 then
			return true
		elseif not p1 and p2 then
			return false
		elseif p1 and p2 then -- sort by win% if both have a win%
			if settings.AlternateWinRecord then
				if w1~=w2 then
					return w1>w2
				end
			end
			if p1~=p2 then
				return p1>p2
			elseif w1~=w2 then
				return w1>w2
			end
		end
	end

	local title1 = rematch:GetTeamTitle(e1):lower()
	local title2 = rematch:GetTeamTitle(e2):lower()
	if title1==title2 then
		local type1 = type(e1)
		local type2 = type(e2)
		if type1=="number" and type2~="number" then
			return true
		elseif type2=="number" and type1~="number" then
			return false
		else
			return e1<e2
		end
	else
		return title1<title2
	end
end


function panel:PopulateTeamList()
	local selected = rematch.TeamTabs:GetSelectedTab()
	local numTabs = #settings.TeamGroups

	local forPet = searchText and rematch:GetIDType(searchText)=="pet"

	wipe(workingList)
	wipe(searchTabs)

	for key,data in pairs(saved) do
		local tab = data.tab
		if tab and tab>numTabs then
			saved[key].tab = nil
			tab = nil
		end
		if key==1 then
			-- do nothing for imported teams; don't list them
		elseif not searchText then -- not searching for a team, fill with teams in the selected tab
			if (tab and tab==selected) or (not tab and selected==1) then
				tinsert(workingList,key)
			end
		else -- there's a search happening
			if forPet then -- this is a search for a petID BattlePet-0-000etc
				for i=1,3 do
					if data[i][1]==searchText then
						tinsert(workingList,key)
						searchTabs[data.tab or 1] = true
						break
					end
				end
			else -- this is a traditional [Ss][Ee][Aa][Rr][Cc][Hh]
				if panel:TeamMatchesSearch(key,data) then
					tinsert(workingList,key)
					searchTabs[data.tab or 1] = true
				end
			end
		end
	end

	local custom = settings.TeamGroups[selected][3] -- whether tab is custom sorted

	-- sort the teams (yes even if a custom sort)
	-- sort by wins if enabled and we're not looking at search results and it's not a custom sort
	panel.sortByWins = not searchText and not custom and settings.TeamGroups[selected][5]
	table.sort(workingList,rematch.TeamSort)
	panel.sortByWins = nil -- minimap button also uses this TeamSort function and never sorts by wins

	-- a custom-sorted tab can have teams moved/added (in bulk in the case of deleting a tab
	-- or turning on custom sort), so custom sort requires the leftover teams to be sorted.
	-- So the above sort still has to happen. After the above sort, the teams not present in the
	-- defined custom sort are added in the order they appear above. Then the workingList is wiped
	-- and a new complete custom sort is filled in its place.
	if not searchText and custom then
		-- remove any teams from custom sort that don't belong in this tab
		for i=#custom,1,-1 do
			local key = custom[i]
			local team = saved[key]
			if not team or not ((team.tab and team.tab==selected) or (not team.tab and selected==1)) then
				tremove(custom,i)
			end
		end
		-- add any in workinglist that belong in custom sort but don't already
		for i=1,#workingList do
			if not tContains(custom,workingList[i]) then
				tinsert(custom,workingList[i])
			end
		end
		-- wipe workinglist and fill with custom
		wipe(workingList)
		for i=1,#custom do
			tinsert(workingList,custom[i])
		end
	end

end

-- returns true if the key,data team matches the searchText
function panel:TeamMatchesSearch(key,data)
	-- look for match in team name
	if rematch:match(rematch:GetTeamTitle(key),searchText) then
		return true
	end
	-- look for match with npc name
	if type(key)=="number" and rematch:match(rematch:GetNameFromNpcID(key),searchText) then
		return true
	end
	-- look for match in notes
	if data.notes and rematch:match(data.notes,searchText) then
		return true
	end
	-- look for match in pet names
	for i=1,3 do
		local petID = data[i][1]
		local idType = rematch:GetIDType(petID)
		if idType=="pet" then
			local _,customName,_,_,_,_,_,name = C_PetJournal.GetPetInfoByPetID(petID)
			if customName and rematch:match(customName,searchText) then
				return true
			elseif name and rematch:match(name,searchText) then
				return true
			end
		elseif idType=="species" then
			local name = C_PetJournal.GetPetInfoBySpeciesID(petID)
			if name and rematch:match(name,searchText) then
				return true
			end
		elseif idType=="leveling" and (L["Leveling"]):match(searchText) then
			return true
		end
	end
end

-- for use by separate tab panel
function panel:GetTeamSearchInfo()
	return searchText,searchTabs
end

-- export needs access to this doh
function panel:GetWorkingList()
	return workingList
end

--[[ List UI ]]

function panel:FillTeamButton(button,key)
	button.key = key

	local title = rematch:GetTeamTitle(key)
	button.Name:SetText(title)

	-- set up height of team name (and set subname to target if needed)
	-- the actual setting of the team name is handled past the footnotes
	if type(key)=="number" then -- if this is a targeted team (npcID for key)
		button.Name:SetTextColor(1,1,1)
		if not button.slim then
			local npcName = rematch:GetNameFromNpcID(key)
			if title~=npcName and not settings.HideTargetNames then
				button.Name:SetHeight(21)
				button.SubName:SetText(npcName)
				button.SubName:Show()
			else
				button.Name:SetHeight(36)
				button.SubName:Hide()
			end
		end
	else -- named team
		button.Name:SetTextColor(1,.82,0) -- colored gold
		if not button.slim then
			button.Name:SetHeight(36) -- never has a target
			button.SubName:Hide()
		end
	end

	local xstart = -3 -- starting offset from right edge
	local xoffset = xstart -- offset from right edge for footnotes to be placed
	local yoffset = 0 -- offset from center for footnotes to be placed

	-- WinRecord stuff
	local showWins = rematch:FillWinRecordButton(button.WinRecord,key)
	if showWins then
		if button.slim then -- slim button winrecord adjusts xoffset like a regular footnote
			xoffset = xoffset - button.WinRecord:GetWidth()
		else -- not moving xoffset for regular teamlistbuttons; moving y offset to push footnotes up
			yoffset = 8
		end
	end
	button.WinRecord:SetShown(showWins)
	if saved[key].notes then
		button.Notes:SetPoint("RIGHT",xoffset,yoffset)
		button.Notes:Show()
		xoffset = xoffset - button.Notes:GetWidth()
	else
		button.Notes:Hide()
	end
	if rematch:HasPreferences(saved[key]) then
		button.Preferences:SetPoint("RIGHT",xoffset,yoffset)
		button.Preferences:Show()
		xoffset = xoffset - button.Notes:GetWidth()
	else
		button.Preferences:Hide()
	end

	-- adjust winrecord button hitrect/position for regular team list buttons
	if showWins and not button.slim then
		-- move the vertical offset of the winrecord to center if no footnotes are used
		if xoffset==xstart then -- no other footnotes used, center the winrecord
			button.WinRecord:SetPoint("BOTTOMRIGHT",-3,14)
			button.WinRecord:SetHitRectInsets(0,0,-14,-14)
		else -- this team has other footnotes, anchor to bottom
			button.WinRecord:SetPoint("BOTTOMRIGHT",-3,4)
			button.WinRecord:SetHitRectInsets(0,0,0,-2)
		end
		button.WinRecord:SetPoint("BOTTOMRIGHT",-3, xoffset==xstart and 14 or 4)
		-- make xoffset just off left edge of winrecord (which is same width as two footnotes)
		xoffset = xstart - button.WinRecord:GetWidth() - 2
	end

	-- name of team
	if button.slim then
		button.Name:SetFontObject(settings.SlimListSmallText and GameFontNormalSmall or GameFontNormal)
	end
	if button.slim then
		button.Name:SetPoint("RIGHT",xoffset-2,0)
	else
		button.Name:SetPoint("TOPRIGHT",xoffset-1,-6)
	end
	for i=1,3 do
		local petID = saved[key][i][1]
      local petInfo = rematch.petInfo:Fetch(petID)
      local icon = petInfo.icon
		--local icon = rematch:GetPetIcon(petID)
		if not icon then -- pet is not found, get its species instead
			petID = saved[key][i][5]
			icon = rematch:GetPetIcon(petID)
		end
		button.Pets[i].petID = petID
		button.Pets[i].Icon:SetTexture(icon)
		button.Pets[i].Icon:SetDesaturated(type(petID)=="number" and petID~=0)
	end
	button.Favorite:SetShown(saved[key].favorite and true)

end

function panel:UpdateList()
	local numData = #workingList
	local scrollFrame = panel.List.ScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	rematch:HideTooltip()
	panel.Selected:Hide()
	for i=1,#buttons do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			local key = workingList[index]
			panel:FillTeamButton(button,key)
			if key==settings.loadedTeam then
--				button:SetBackdropBorderColor(0.35,0.65,1)
				button:SetBackdropBorderColor(1,0.82,0)
				panel.Selected:SetParent(button)
				panel.Selected:SetAllPoints(true)
				panel.Selected:Show()
			else
				button:SetBackdropBorderColor(0.33,0.33,0.33)
			end
			button:Show()
		else
			button:Hide()
		end
	end

	HybridScrollFrame_Update(scrollFrame,scrollFrame.buttonHeight*numData,scrollFrame.buttonHeight)
end

-- single click of a team now loads teams
function panel:TeamOnClick(button)
	local key = self.key
	if button=="RightButton" then
		rematch:SetMenuSubject(key)
		rematch:ShowMenu("TeamMenu","cursor")
	else
		rematch:LoadTeam(key)
		if self==panel.Top.Team then
			rematch:ShowTeam(key)
		end
		if type(key)=="number" then
			rematch.recentTarget = key
		end
		rematch:UpdateUI()
	end
end

-- desaturates the loaded team, hides pets and sets team name to given text ("Loading..." "No Team Loaded" etc)
function panel:NotifyTeamLoading(text)
	if panel==false then
		panel.LoadedTeam.InsetBack:SetDesaturated(true)
		panel.LoadedTeam.Team.Name:SetText(format("%s%s",rematch.hexGrey,text))
		panel.LoadedTeam.Team.Notes:Hide()
		for i=1,3 do
			panel.LoadedTeam.Team.Pets[i]:Hide()
		end
	end
end

function panel:SearchBoxOnTextChanged()
	searchText = nil
	local text = self:GetText()
	self:SetTextColor(1,1,1)
	if text and text:len()>0 then
		if rematch:GetIDType(text)=="pet" then -- this is a search for a petID (BattlePet-0-0000etc)
			searchText = text
			self:SetTextColor(0.5,0.5,0.5)
		else -- this is a normal search
			searchText = rematch:DesensitizeText(text)
		end
	end
	panel:Update()
	rematch.TeamTabs:Update()
end

-- use this to set a search (aside from the user typing in the searchbox) to handle searchbox bits
function panel:SetTeamSearch(text)
	local searchBox = panel.Top.SearchBox
	searchBox:ClearFocus()
	searchBox.Instructions:SetShown(not text)
	searchBox.Clear:SetShown(text and true)
	searchBox:SetText(text or "")
end

-- regardless whether in journal or standalone, go to a team tab
-- if key is given, go to the team
function rematch:ShowTeam(key)
	if settings.Minimized and key then
		return
	end
	-- if key given, switch to the tab that contains the team (if it's not already selected)
	if key and saved[key] then -- and settings.SelectedTab~=(saved[key].tab or 1) then
		rematch.TeamTabs:SelectTeamTab(saved[key].tab or 1)
	end
	-- team panel not visible, show it
	if not panel:IsVisible() then
		if rematch.Frame:IsVisible() then
			settings.Minimized = nil
			settings.ActivePanel = 2
			rematch.Frame:ConfigureFrame()
		elseif rematch.Journal:IsVisible() then
			settings.JournalPanel = 1
			rematch:SelectPanelTab(rematch.Journal.PanelTabs,1)
			rematch.Journal:ConfigureJournal()
		else
			return -- neither frame or journal on screen
		end
	end
	-- if key provided, scroll to team (which should be on the team panel workingList at this point)
	if key and saved[key] then
		local index
		for i=1,#workingList do
			if workingList[i]==key then
				index = i
			end
		end
		if index then
			rematch:ListScrollToIndex(panel.List.ScrollFrame,index)
			rematch:ListBling(panel.List.ScrollFrame,"key",key)
			rematch.TeamTabs:ScrollToTeamTab(key)
		elseif not panel.retryShowTeam then
			-- if index not found then we didn't scroll to team yet, try again once things settle
			panel.retryShowTeam = true
			C_Timer.After(0.1,function() rematch:ShowTeam(key) end)
			return
		end
	end
	panel.retryShowTeam = nil
end

-- this registers/unregisters for UPDATE_MOUSEOVER_UNIT depending on settings
-- if off is true, turn off regardless of its settings (entering combat)
function rematch:UpdateAutoLoadState(off)
	if not off and settings.AutoLoad and not settings.AutoLoadTargetOnly then
		rematch:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end

-- ordinarily done in PetClicks template; handles special handling of team list pet buttons
-- to display team menu instead of pet menu
function panel:PetButtonOnClick(button)
	if button=="RightButton" then
		rematch:SetMenuSubject(self:GetParent().key)
		rematch:ShowMenu("TeamMenu","cursor")
	elseif IsModifiedClick("CHATLINK") then
		if rematch:GetIDType(self.petID)=="pet" then
			ChatEdit_InsertLink(C_PetJournal.GetBattlePetLink(self.petID))
		end
	else
		rematch:LockPetCard(self,self.petID)
	end
end

function panel:Resize(width)
	panel.width = width
	panel:SetWidth(width)
	for _,button in ipairs(panel.List.ScrollFrame.buttons) do
		button:SetWidth(width-32-(button.slim and 77 or 84))
	end
	panel.Top:SetWidth(width)
	panel.Top.Team:SetWidth(width-96)
end

function panel:TeamOnEnter()
	self.Backplate:SetColorTexture(0.25,0.5,0.75)
	-- if the name of the team (or its target) is truncated then show a tooltip
	if self.Name:IsTruncated() or (self.SubName and self.SubName:IsVisible() and self.SubName:IsTruncated()) then
		local teamName = rematch:GetTeamTitle(self.key)
		if type(self.key)=="number" then
			local npcName = rematch:GetNameFromNpcID(self.key)
			rematch.ShowTooltip(self,teamName,self.key~=npcName and npcName)
		else
			rematch.ShowTooltip(self,format("%s%s",rematch.hexGold,teamName))
		end
	else
		rematch:HideTooltip() -- this is due to OnEnter()s called during scroll without a hide
	end
	-- highlight the team tab to show where the team is from
	local team = saved[self.key]
	local tab = team and (team.tab or 1)
	rematch:HighlightTeamTab(tab)
end

function panel:TeamOnLeave()
	self.Backplate:SetColorTexture(0.15,0.15,0.15)
	rematch:HideTooltip()
	rematch:HighlightTeamTab() -- unlock all highlights
end

-- returns the number of teams saved
function rematch:GetNumTeams()
	local numTeams = 0
	for k,v in pairs(saved) do
		numTeams = numTeams + 1
	end
	return numTeams
end
