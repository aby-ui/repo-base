local _,L = ...
local rematch = Rematch
local dialog = RematchDialog
local settings, saved

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved
	dialog:UpdateTabPicker()
	rematch:RegisterMenu("SaveAsTarget",{
		{ text=L["No Target"], npcID=nil, func=rematch.PickNpcID },
		{ text=function() return rematch:GetNameFromNpcID(rematch.recentTarget) end, hidden=function() return not rematch.recentTarget end, npcID=function() return rematch.recentTarget end, func=rematch.PickNpcID },
		{ text=function() return rematch:GetTeamTitle(settings.loadedTeam) end, hidden=function() return type(settings.loadedTeam)~="number" or settings.loadedTeam==rematch.recentTarget or settings.loadedTeam==1 end, npcID=function() return settings.loadedTeam end, func=rematch.PickNpcID },
		{ text=L["Noteworthy Targets"], subMenu="NotableNPCs" }, -- defined in Npcs.lua
	})
	dialog.SaveAs.Target.tooltipTitle=L["Target For This Team"]
	dialog.SaveAs.Target.tooltipBody=L["A target stored in a team is used to decide which team to load when you return to that target.\n\nYou can save an unlimited number of teams to fight a target, but a target can only be saved in one team."]
	dialog.SaveAs.Name.Label:SetText(L["Name:"])
	dialog.SaveAs.Target.Label:SetText(L["Target:"])
end)

function rematch:ShowSaveAsDialog(header)
	rematch:ShowDialog("SaveAs",300,140+dialog.SaveAs:GetHeight(),header or L["Save As.."],L["Save this team?"],SAVE,rematch.SaveAsAccept,CANCEL)
	dialog.SaveAs:SetPoint("TOP",0,-40)
	dialog.SaveAs:Show()
	dialog.TabPicker:SetPoint("TOPRIGHT",dialog.SaveAs.Target,"BOTTOMRIGHT",0,-6)
	dialog.TabPicker:Show()
	rematch:UpdateSaveAsDialog() -- fills in stuff
end

function dialog.SaveAs.Target:OnClick()
	rematch:ToggleMenu("SaveAsTarget","TOPRIGHT",self,"BOTTOMRIGHT",0,2)
end

function rematch:UpdateSaveAsDialog()
	dialog:UpdateTabPicker()
	local team,key = rematch:GetSideline()
	dialog:FillTeam(dialog.SaveAs.Team,team)
	dialog.SaveAs.Name:SetFontObject(type(key)=="number" and "GameFontHighlight" or "GameFontNormal")
	dialog.SaveAs.Name:SetText(rematch:GetSidelineTitle())
	dialog.SaveAs.Target.Text:SetText(rematch:GetNameFromNpcID(key))
	dialog.SaveAs.Themselves:Hide()
	local height = 180
	local yoff = -40
	if rematch:GetSidelineContext("AskingOverwriteNotes") then
		-- if saving from loadout, and team has notes (determined in CheckToOverwriteNotesAndPreferences)
		-- which also sets this context, then attach a checkbox for "Save Notes & Preferences too"
		dialog.CheckButton:SetPoint("TOPLEFT",dialog.SaveAs.Target,"BOTTOMLEFT",-32,yoff)
		dialog.CheckButton.text:SetText(L["Save Notes & Preferences Too"])
		dialog.CheckButton:Show()
		dialog.CheckButton:SetChecked(settings.OverwriteNotes and true)
		dialog.CheckButton:SetScript("OnClick",function(self) settings.OverwriteNotes=self:GetChecked() end)
		height = height + 28
		yoff = yoff - 28
	end
	dialog.SaveAs:SetHeight(height)
	rematch:SaveAsUpdateWarning()
end

function rematch:SaveAsUpdateWarning()
	local name = dialog.SaveAs.Name:GetText()
	local team,key = rematch:GetSideline()
	local warn
	if name and name:len()==0 then
		warn = L["All teams must have a name."]
	elseif rematch:GetSidelineContext("originalKey")~=key and saved[key] then
		if type(key)=="number" then
			warn = L["This target already has a team."]
		else
			warn = L["A team already has this name."]
		end
	end
	if warn then
		dialog.Warning:SetPoint("TOP",dialog.SaveAs,"BOTTOM",0,-4)
		dialog.Warning.Text:SetText(warn)
		dialog.Warning:Show()
	else
		dialog.Warning:Hide()
	end
	dialog:SetHeight((warn and 140 or 108)+dialog.SaveAs:GetHeight())
end

-- call to change target in the SaveAs dialog
function rematch:SetSaveAsTarget(npcID)
	local team,key = rematch:GetSideline()
	if npcID~=key then
		if npcID then
			rematch:ChangeSidelineKey(npcID)
			team,key = rematch:GetSideline() -- need to get them again since table changes
			if saved[npcID] then
				team.teamName = saved[npcID].teamName
			else
				team.teamName = rematch:GetNameFromNpcID(npcID)
			end
		else
			rematch:ChangeSidelineKey(rematch:GetSidelineContext("originalName"))
			team,key = rematch:GetSideline() -- need to get them again since table changes
			team.teamName = nil
		end
	end
	rematch:UpdateSaveAsDialog()
end

function dialog.SaveAs.Name:OnTextChanged()
	local text = self:GetText()
	if text:len()==0 then
		dialog.Accept:Disable()
	else
		dialog.Accept:Enable()
		if text~=rematch:GetSidelineTitle() then
			local team,key = rematch:GetSideline()
			if type(key)=="number" then
				team.teamName = text -- if an npcID-indexed team, it can be any name
			else
				rematch:ChangeSidelineKey(text)
			end
		end
	end
	rematch:SaveAsUpdateWarning()
end

-- when the Save button is clicked in the SaveAs dialog
function rematch:SaveAsAccept()
	local team,key = rematch:GetSideline()
	if not saved[key] or not rematch:SidelinePetsDifferentThan(key) then
		rematch:PushSideline()
		rematch:ShowTeam(key)
	else
		rematch:ShowOverwriteDialog()
	end
end

-- returns true if the sidelined team's pets are different than the team of the passed key
function rematch:SidelinePetsDifferentThan(key)
	local team1 = rematch:GetSideline()
	local team2 = saved[key]
	if team1 and team2 then
		for i=1,3 do
			if team1[i][1]~=team2[i][1] then
				return true -- a pet is different
			end
		end
		if team1.notes~=team2.notes or team1.minHP~=team2.minHP or team1.maxXP~=team2.maxXP or team1.minXP~=team2.minXP or team1.maxHP~=team2.maxHP then
			return true -- notes or preferences are different
		end
		return false -- the three pets are the same
	end
	return true -- one or both teams doesn't exist
end

-- shows an overwrite dialog to confirm whether to save a team
-- make noDialog true when declining shouldn't return to the SaveAs dialog
function rematch:ShowOverwriteDialog(noDialog,prompt)
	rematch:ShowDialog("Overwrite",300,350,L["Overwrite Team"],prompt or L["Overwrite this team?"],YES,rematch.OverwriteAccept,NO,not noDialog and rematch.ShowSaveAsDialog or nil)
	local team,key = rematch:GetSideline()
	dialog.Text:SetSize(260,72)
	if noDialog then -- no need to explain why overwrite happening, just show team name
		dialog.Text:SetSize(260,32)
		dialog.Text:SetJustifyH("CENTER")
		dialog.Text:SetText(rematch:GetTeamTitle(key,true))
		dialog:SetHeight(310)
	else
		if type(key)=="number" then
			dialog.Text:SetText(format(L["The target %s%s\124r already has a team.\n\nA target can only have one team."],rematch.hexWhite,rematch:GetNameFromNpcID(key)))
		else
			dialog.Text:SetText(format(L["A team named %s%s\124r already exists.\n\nTeams without a target must have a unique name."],rematch.hexWhite,key))
		end
	end
	dialog.Text:SetPoint("TOP",0,-32)
	dialog.Text:Show()
	dialog.OldTeam:SetPoint("TOP",dialog.Text,"BOTTOM")
	dialog.OldTeam:Show()
	dialog:FillTeam(dialog.OldTeam,saved[key])
	dialog.Team:SetPoint("TOP",dialog.OldTeam,"BOTTOM",0,-32)
	dialog.Team:Show()
	dialog:FillTeam(dialog.Team,team)
end

-- when accept clicked on overwrite dialog
function rematch:OverwriteAccept()
	local _,key = rematch:GetSideline()
	rematch:PushSideline()
	rematch:ShowTeam(key)
end

-- to be called after a loaded team is sidelined (Save As... or target's Save button)
-- will turn on AskingOverwriteNotes to know whether notes can potentially overwrite
function rematch:CheckToOverwriteNotesAndPreferences()
	local team = settings.loadedTeam and saved[settings.loadedTeam]
	if team and (team.notes or rematch:HasPreferences(team)) then
		rematch:SetSidelineContext("AskingOverwriteNotes",true)
	end
end
