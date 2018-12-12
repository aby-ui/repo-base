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

	local scrollFrame = panel.List
	scrollFrame.template = settings.SlimListButtons and "RematchCompactTeamListButtonTemplate" or "RematchTeamListButtonTemplate"
	scrollFrame.templateType = "RematchCompositeButton"
	scrollFrame.list = workingList
	scrollFrame.callback = panel.FillTeamListButton
	scrollFrame.preUpdateFunc = panel.PreUpdate

	panel.Top.Teams:SetText(L["Teams"])
	rematch:UpdateAutoLoadState()
end)

-- for the following TeamListButtonOnLoad, to avoid creating new functions for every button
local function showPetCard(self) rematch:ShowPetCard(self,self.petID) end
local function hidePetCard(self) rematch:HidePetCard(true) end

-- when a composite button is created, hook up script handlers for its textures
function panel:TeamListButtonOnLoad()
	-- Notes button
	self:SetTextureScript(self.Notes,"OnEnter",rematch.Notes.OnEnter)
	self:SetTextureScript(self.Notes,"OnLeave",rematch.Notes.OnLeave)
	self:SetTextureScript(self.Notes,"OnClick",rematch.Notes.OnClick)
	-- preferences button
	self:SetTextureScript(self.Preferences,"OnEnter",rematch.ShowPreferencesTooltip)
	self:SetTextureScript(self.Preferences,"OnLeave",rematch.HideTooltip)
	self:SetTextureScript(self.Preferences,"OnClick",rematch.ShowPreferencesDialog)
	-- winrecord
	self:SetTextureScript(self.WinRecordBack,"OnEnter",rematch.WinRecordOnEnter)
	self:SetTextureScript(self.WinRecordBack,"OnLeave",rematch.WinRecordOnLeave)
	self:SetTextureScript(self.WinRecordBack,"OnClick",rematch.WinRecordOnClick)
	-- pets
	for i=1,3 do
		self:SetTextureScript(self.Pets[i],"OnEnter",showPetCard)
		self:SetTextureScript(self.Pets[i],"OnLeave",hidePetCard)
		self:SetTextureScript(self.Pets[i],"OnClick",panel.PetButtonOnClick)
	end
end

function panel:Update()
	if panel:IsVisible() then
		panel:PopulateTeamList()
		panel.List:Update()
		local searching = panel.Top.SearchBox:GetText():len()>0
		panel.Top.SearchBox.Clear:SetShown(searching)
		panel.Top.SearchBox.Instructions:SetShown(not searching)
	end
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

function panel:PreUpdate()
	panel.SelectedOverlay:Hide()
end

-- this fills out both the normal and compact list buttons
function panel:FillTeamListButton(key)

	local teamInfo = rematch.teamInfo:Fetch(key)

	if not teamInfo.key then
		return -- this isn't a valid team
	end

	self.key = teamInfo.key

	-- place border around team if it's currently loaded
	if teamInfo.key == settings.loadedTeam then
		panel.SelectedOverlay:SetParent(self)
		panel.SelectedOverlay:SetPoint("TOPLEFT",self.Back,"TOPLEFT")
		panel.SelectedOverlay:SetPoint("BOTTOMRIGHT",self.Back,"BOTTOMRIGHT")
		panel.SelectedOverlay:Show()
	end

	-- update pets to the left
	for i=1,3 do
		local petID = teamInfo.petIDs[i]
		local petInfo = rematch.petInfo:Fetch(petID)
		self.Pets[i].petID = petID
		self.Pets[i]:SetTexture(petInfo.icon)
		self.Pets[i]:SetDesaturated(petInfo.idType=="species")
	end

	-- show favorites star if a favorite team
	self.Favorite:SetShown(teamInfo.isFavorite)

	-- rightOffset will decide where to anchor Name's RIGHT edge, depending on winrecord
	-- and footnotes; it's adjusted differently for normal and compact modes
	local rightOffset = self.compact and -2 or -8

	-- winrecord first
	if not settings.HideWinRecord and teamInfo.battles > 0 then
		-- both alternate and normal display need percent calculated to choose background
		local percent = floor(teamInfo.wins*100 / teamInfo.battles + 0.5)
		self.WinRecordText:SetText(settings.AlternateWinRecord and teamInfo.wins or format("%d%%", percent))
		local left,right,top,bottom
		if percent>=60 then
			left,right,top,bottom = 0,0.296875,0,0.28125
		elseif percent<=40 then
			left,right,top,bottom = 0,0.296875,0.375,0.65625
		else
			left,right,top,bottom = 0,0.296875,0.71875,1
		end
		self.WinRecordBack:SetTexCoord(left,right,top,bottom)	
		self.WinRecordBack:Show()
		self.WinRecordText:Show()
		rightOffset = self.slim and -41 or -44
	else
		self.WinRecordBack:Hide()
		self.WinRecordText:Hide()
	end

	-- notes button
	if teamInfo.hasNotes then
		if self.compact then
			self.Notes:SetPoint("RIGHT", rightOffset, 0)
			rightOffset = rightOffset - 21
		else -- normal mode: notes button never changes position
			rightOffset = min(rightOffset, -22)
		end
		self.Notes:Show()
	else
		self.Notes:Hide()
	end

	-- preferences button
	if teamInfo.hasPreferences then
		if self.compact then
			self.Preferences:SetPoint("RIGHT", rightOffset, 0)
			rightOffset = rightOffset - 20
		else
			self.Preferences:SetPoint("TOPRIGHT",teamInfo.hasNotes and -22 or -2, -3)
			rightOffset = min(rightOffset, teamInfo.hasNotes and -44 or -22)
		end
		self.Preferences:Show()
	else
		self.Preferences:Hide()
	end

	-- finally, name of the team
	self.Name:SetText(teamInfo.coloredName)
	if self.compact then
		self.Name:SetPoint("RIGHT", rightOffset-2, 0)
		self.Name:SetFontObject(settings.SlimListSmallText and GameFontNormalSmall or GameFontNormal)
	else -- normal list mode potentially has subnames (name of target)
		self.Name:SetPoint("TOPRIGHT", rightOffset, -4)
		if teamInfo.needsSubName then
			self.Name:SetHeight(21)
			self.SubName:SetText(teamInfo.targetName)
			self.SubName:Show()
		else
			self.Name:SetHeight(36)
			self.SubName:Hide()
		end		
	end

end

-- this flashes the button containing the given team
function panel:BlingKey(key)
	for _,button in ipairs(panel.List.ScrollFrame.Buttons) do
		if key and button.key == key then
			panel.List:BlingIndex(button.index)
			return
		end
	end
end

-- single click of a team now loads teams
function panel:TeamOnClick(button)
	local key = self.key
	if button=="RightButton" then
		rematch:SetMenuSubject(key)
		rematch:ShowMenu("TeamMenu","cursor")
	else
		rematch:LoadTeam(key)
		if type(key)=="number" then
			rematch.recentTarget = key
		end
		rematch:UpdateUI()
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
			if not panel.List:IsIndexVisible(index) then
				panel.List:ScrollToIndex(index)
			end
			panel.List:BlingIndex(index)
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
	panel.Top:SetWidth(width)
	panel:Update()
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
