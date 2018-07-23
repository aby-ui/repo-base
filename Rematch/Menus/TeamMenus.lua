local _,L = ...
local rematch = Rematch
local settings,saved,groups
local rmf = {}

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved
	groups = settings.TeamGroups

	-- "TeamMenu" right-click menu for teams
	rematch:RegisterMenu("TeamMenu", {
		{ title=true, text=function(self,key) return rematch:GetTeamTitle(key,true) end, },
		{ text=L["Edit Win Record"], func=function(self,key) rematch:ShowWinRecord(rematch:GetMenuParent(),key,true) end }, -- keep first (so it's always in same spot for muscle memory)
		{ text=L["Change Name Or Target"], func=function(self,key)
				rematch:SetSideline(key,saved[key])
				rematch:SetSidelineContext("deleteOriginal",true)
				rematch:ShowSaveAsDialog(L["Edit Team"])
			end },
		{ text=function(self,key) -- set/remove favorite
				return (saved[key] and saved[key].favorite) and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE
			end,
			func=function(self,key)
				if saved[key] then
					saved[key].favorite = (not saved[key].favorite) or nil
					rematch:UpdateUI()
				end
			end },
		{ text=L["Set Notes"], func=function(self,key)
				rematch.Notes.locked = true
				rematch:ShowNotes("team",key,true)
				rematch.Notes.Content.ScrollFrame.EditBox:SetFocus(true)
			end },
		{ text=L["Leveling Preferences"], hidden=function(self,key) for i=1,3 do if saved[key][i][1]==0 then return false end end return true end, func=function(self,key) rematch:ShowPreferencesDialog("team",key) end },
		{ text=L["Move To"], subMenu="TeamMove" },
		{ spacer=true, hidden=rmf.NotSortable },
		{ text=L["Move To Top"], hidden=rmf.NotSortable,stay=true, icon="Interface\\Buttons\\UI-MicroStream-Green", iconCoords={0.075,0.925,0.925,0.075}, disabled=rmf.TeamAtTop, dir=-2, func=rmf.MoveTeamWithinTab },
		{ text=L["Move Up"], hidden=rmf.NotSortable, stay=true, icon="Interface\\Buttons\\UI-MicroStream-Yellow", iconCoords={0.075,0.925,0.925,0.075}, disabled=rmf.TeamAtTop, dir=-1, func=rmf.MoveTeamWithinTab },
		{ text=L["Move Down"], hidden=rmf.NotSortable, stay=true, icon="Interface\\Buttons\\UI-MicroStream-Yellow", disabled=rmf.TeamAtEnd, dir=1, func=rmf.MoveTeamWithinTab },
		{ text=L["Move To End"], hidden=rmf.NotSortable, stay=true, icon="Interface\\Buttons\\UI-MicroStream-Green", disabled=rmf.TeamAtEnd, dir=2, func=rmf.MoveTeamWithinTab },
		{ spacer=true, hidden=rmf.NotSortable },
		{ text=L["Share"], subMenu="ShareMenu" },
		{ text=DELETE, func=function(self,key)
				local dialog = rematch:ShowDialog("DeleteTeam",300,176,rematch:GetTeamTitle(key,true),L["Delete this team?"],YES,function(self) saved[key]=nil rematch.petsInTeams:Invalidate() rematch:UpdateUI() end,NO)
				dialog.Team:SetPoint("TOP",0,-36)
				dialog.Team:Show()
				dialog:FillTeam(dialog.Team,saved[key])
			end },
		{ text=L["Unload Team"], hidden=function(self,key) return not key or key~=settings.loadedTeam end, func=function(self,key)
				rematch:UnloadTeam()
				rematch:UpdateQueue() -- will do UpdateUI also
			end },
		{ spacer=true, hidden=rmf.NotForTeamPet },
		{ text=L["Put Leveling Pet Here"], hidden=rmf.NotForTeamPet, func=function(self,key)
				local slot = rematch:GetMenuParent():GetID()
				if saved[key] then
					local team,key = rematch:SetSideline(key,saved[key])
					team[slot] = {0,0,0,0}
					rematch:ShowOverwriteDialog(true,L["Add a leveling pet to this team?"])
				end
			end },
		{ spacer=true, hidden=rmf.NotForTeamPet },
		{ text=L["Help"], stay=true, hidden=function() return settings.HideMenuHelp end, icon="Interface\\Common\\help-i", iconCoords={0.15,0.85,0.15,0.85}, tooltipTitle=L["About Teams"], tooltipBody=format(L["Teams named in %sWhite\124r have a target stored within them.\nTeams named in Gold do not.\n\n%sTo change pets or abilities in a team:\124r\n1) Load the team.\n2) Make any changes.\n3) Click Save at the bottom of the window."],rematch.hexWhite,rematch.hexWhite) },
		{ text=CANCEL },
	})

	rematch:RegisterMenu("ShareMenu", {
		{ text=L["Copy As Plain Text"], func=function(self,key) rematch:SetSideline(key,saved[key]) rematch:SetSidelineContext("plain",true) rematch:ShowExportDialog(key) end, tooltipBody=L["Format this team into plain text to copy elsewhere, such as forums or emails.\n\nThe plain text format is best for sharing a team with others that may not use Rematch."] },
		{ text=L["Export Team"], func=function(self,key) rematch:SetSideline(key,saved[key]) rematch:ShowExportDialog(key) end, tooltipBody=L["Export this team as a string you can copy elsewhere, such as forums or emails.\n\nOther Rematch users can paste this team into their Rematch via Import Team."] },
		{ text=L["Import Team"], func=rematch.ShowImportDialog, tooltipBody=L["Import a single team or many teams that were exported from Rematch."] },
		{ text=L["Send Team"], disabled=function() return settings.DisableShare end, disabledReason=L["Sharing is disabled in options."],func=function(self,key) rematch:SetSideline(key,saved[key]) rematch:ShowSendDialog() end, tooltipBody=L["Send this team to another online user of Rematch."] }
	})

	-- "TeamMove" and "TabPick" for moving or changing team tabs
	local teamMove = {} -- menu for moving a team to another tba
	local tabPick = {} -- menu for changing to another tab
	for i=1,RematchTeamTabs.MAX_TABS do
		tinsert(teamMove,{tab=i,hidden=rmf.HideTab,text=rmf.TabName,icon=rmf.TabIcon,disabled=rmf.DisableTab,func=rmf.MoveTeam})
		tinsert(tabPick,{tab=i,hidden=rmf.HideTab,text=rmf.TabName,icon=rmf.TabIcon,func=rmf.TabPick})
	end
	rematch:RegisterMenu("TeamMove",teamMove)
	rematch:RegisterMenu("TabPick",tabPick)

	-- "TeamOptions" is the filter-like menu from the Teams button in topright of team panel
	rematch:RegisterMenu("TeamOptions", {
		{ text=L["Prompt To Load"], check=true, var="PromptToLoad", value=rmf.GetValue, func=rmf.SetLoadRadio, tooltipBody=L["When your new target has a saved team not already loaded, and the target panel isn't on screen, display a popup asking if you want to load the team.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."] },
		{ text=L["With Rematch Window"], indent=8, check=true, value=rmf.GetValue, var="PromptWithMinimized", disabled=rmf.NotPromptToLoad, func=rmf.ToggleValue, tooltipBody=L["Prompt to load with the Rematch window instead of a separate popup dialog."] },
		{ text=L["Always Prompt"], indent=8, check=true, value=rmf.GetValue, var="PromptAlways", disabled=rmf.NotPromptToLoad, func=rmf.ToggleValue, tooltipBody=L["Prompt every time you interact with a target with a saved team not already loaded, instead of only the first time."] },
		{ text=L["Auto Load"], check=true, var="AutoLoad", value=rmf.GetValue, func=rmf.SetLoadRadio, tooltipBody=L["When you mouseover a new target that has a saved team not already loaded, immediately load it.\n\nThis is only for the first interaction with a target. You can always load a target's team from the target panel."] },
		{ text=L["Show After Loading"], indent=8, check=true, value=rmf.GetValue, var="AutoLoadShow", disabled=rmf.NotAutoLoad, func=rmf.ToggleValue, tooltipBody=L["After a team auto loads, show the Rematch window."] },
		{ text=L["Show On Injured"], indent=8, check=true, value=rmf.GetValue, var="ShowOnInjured", disabled=rmf.NotAutoLoad, func=rmf.ToggleValue, tooltipBody=L["When a team auto loads, show the Rematch window if any pets are injured."] },
		{ text=L["On Target Only"], indent=8, check=true, value=rmf.GetValue, var="AutoLoadTargetOnly", disabled=rmf.NotAutoLoad, func=rmf.ToggleValue, tooltipBody=L["Auto load upon targeting only, not mouseover.\n\n\124cffff4040WARNING!\124r This is not recommended! It can be too late to load pets if you target with right-click!"] },
		{ spacer=true },
		{ text=L["Export Listed Teams"], func=function() rematch.Dialog.Share:ExportTeamTab() end, tooltipBody=L["Export all teams listed below to a string you can copy elsewhere, such as forums or emails.\n\nOther Rematch users can then paste these teams into their Rematch via Import Teams.\n\nYou can export a single team by right-clicking one and choosing its Share menu."] },
		{ text=L["Backup All Teams"], func=rematch.ShowBackupDialog, tooltipBody=L["This will export all teams across all tabs into text that you can paste elsewhere, such as an email to yourself or a text file someplace safe. You can later restore these teams with the Import Teams option."] },
		{ text=L["Import Teams"], func=rematch.ShowImportDialog, tooltipBody=L["Import a single team or many teams that was exported from Rematch."] },
		{ text=L["Import From Pet Battle Teams"], hidden=function() return not IsAddOnLoaded("PetBattleTeams") end, tooltipBody=L["Copy your existing teams from Pet Battle Teams to Rematch."], func=rematch.ShowImportPBTDialog },
	},rematch.UpdateAutoLoadState)

end)

function rmf:TabName() return settings.TeamGroups[self.tab][1] end
function rmf:TabIcon() return settings.TeamGroups[self.tab][2] end
function rmf:HideTab() return not settings.TeamGroups[self.tab] end
function rmf:DisableTab(key) return self.tab==(saved[key].tab or 1) end
function rmf:MoveTeam(key) saved[key].tab = self.tab>1 and self.tab or nil if key and settings.loadedTeam==key then rematch:ShowTeam(key) else rematch:UpdateUI() end end
function rmf:TabPick() rematch.TeamTabs:SelectTeamTab(self.tab) end
function rmf:GetValue() return settings[self.var] end
function rmf:ToggleValue(_,checked) settings[self.var]=not checked end
function rmf:NotPromptToLoad() return not settings.PromptToLoad end
function rmf:NotAutoLoad() return not settings.AutoLoad end
function rmf:SetLoadRadio(_,checked)
	if checked then
		settings[self.var] = nil
		return
	else
		settings.AutoLoad = nil
		settings.PromptToLoad = nil
		settings[self.var] = true
	end
end
function rmf:NotForTeamPet()
	local petID = rematch:GetMenuParent().petID
	return not (petID and petID~=0)
end
function rmf:NotSortable(key)
	local tab = saved[key] and (saved[key].tab or 1)
	return not settings.TeamGroups[tab] or not settings.TeamGroups[tab][3] or rematch:GetMenuParent()==rematch.LoadedTeamPanel
end
function rmf:TeamAtTop(key)
	return settings.TeamGroups[saved[key].tab or 1][3][1]==key
end
function rmf:TeamAtEnd(key)
	local custom = settings.TeamGroups[saved[key].tab or 1][3]
	return custom[#custom]==key
end
function rmf:MoveTeamWithinTab(key)
	-- self.dir -2 for top, -1 for up, 1 for down, 2 for end
	local custom = settings.TeamGroups[saved[key].tab or 1][3]
	local oldIndex -- find the original index
	for i=1,#custom do
		if custom[i]==key then
			oldIndex = i
			break
		end
	end
	if self.dir==-2 then -- moving to top
		tremove(custom,oldIndex)
		tinsert(custom,1,key)
	elseif self.dir==2 then -- moving to end
		tremove(custom,oldIndex)
		tinsert(custom,key)
	elseif self.dir==-1 then -- moving up
		local oldKey = custom[oldIndex-1]
		custom[oldIndex-1] = key
		custom[oldIndex] = oldKey
	elseif self.dir==1 then -- moving down
		local oldKey = custom[oldIndex+1]
		custom[oldIndex+1] = key
		custom[oldIndex] = oldKey
	end
	rematch.TeamPanel:Update()
	rematch:ShowTeam(key)
end
