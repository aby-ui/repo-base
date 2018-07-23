local _,L = ...
local rematch = Rematch
local panel = RematchLoadedTeamPanel
local settings

rematch:InitModule(function()
	rematch.LoadedTeamPanel = panel
	settings = RematchSettings
	panel:RegisterForClicks("AnyUp")
	panel:RegisterForDrag("LeftButton")
	rematch:ConvertTitlebarCloseButton(panel.Footnotes.Close)
	rematch:SetTitlebarButtonIcon(panel.Footnotes.Maximize,"maximize")
end)

function panel:Update()
	local key = settings.loadedTeam
	if key then
		panel.Name:SetText(rematch:GetTeamTitle(settings.loadedTeam,true))
	else
		panel.Name:SetText(BATTLE_PET_SLOTS)
	end
	panel.key = key
	panel.Footnotes.key = key
	local team = RematchSaved[key]

	panel.Favorite:SetShown(team and team.favorite)

	local fx = 5
	local footnotes = panel.Footnotes

	if rematch:ArePreferencesActive() then
		footnotes.Preferences:SetPoint("LEFT",fx,-0.5)
		footnotes.Preferences:Show()
		fx = fx + 21
		footnotes.Preferences.Paused:SetShown(settings.QueueNoPreferences)
	else
		footnotes.Preferences:Hide()
	end
	if team and team.notes then
		footnotes.Notes:SetPoint("LEFT",fx,-0.5)
		footnotes.Notes:Show()
		fx = fx + 21
	else
		footnotes.Notes:Hide()
	end
	if rematch:FillWinRecordButton(footnotes.WinRecord,key) then
		footnotes.WinRecord:SetPoint("LEFT",fx,-1)
		footnotes.WinRecord:Show()
		fx = fx + footnotes.WinRecord:GetWidth()
	else
		footnotes.WinRecord:Hide()
	end


	if rematch.Frame:IsVisible() and settings.Minimized and settings.MiniMinimized then
		footnotes.Maximize:SetPoint("LEFT",fx-5,0)
		footnotes.Maximize:Show()
		fx = fx + 21
		footnotes.Close:SetPoint("LEFT",fx-5,0)
		footnotes.Close:Show()
		fx = fx + 21
	else
		footnotes.Maximize:Hide()
		footnotes.Close:Hide()
	end

	local footnoteWidth = fx + 4

	local panelWidth = panel.maxWidth or 280

	if footnoteWidth>10 then
		panel.Footnotes:SetWidth(footnoteWidth)
		panel.Footnotes:Show()
		panel:SetWidth(panelWidth-footnoteWidth-3)
	else
		panel.Footnotes:Hide()
		panel:SetWidth(panelWidth)
	end
end

function panel:OnClick(button)
	if button=="RightButton" and self.key then
		rematch:SetMenuSubject(self.key)
		rematch:ShowMenu("TeamMenu","cursor")
	elseif self.key then
		rematch:LoadTeam(self.key)
	end
end

function panel:OnDragStart()
	if rematch.Frame:IsVisible() then
		Rematch.Frame:MoveStart()
	end
end

function panel:OnDragStop()
	Rematch.Frame:MoveStop()
	self:GetScript("OnMouseUp")(self)
end

function panel:OnEnter()
	local body = ""
	if settings.loadedTeam then
		local teamName = rematch:GetTeamTitle(settings.loadedTeam)
		if self.Name:IsTruncated() then
			body = format("%s%s\n",body,rematch:GetTeamTitle(settings.loadedTeam,true))
		end
		if type(settings.loadedTeam)=="number" then
			local npcName = rematch:GetNameFromNpcID(settings.loadedTeam)
			if teamName~=npcName then
				body = format("%s%s%s\124r\n",body,rematch.hexGrey,npcName)
			end
		end
		body = format("%s%s %s\n%s %s",body,rematch.LMB,L["Reload Team"],rematch.RMB,L["Team Options"])
	else
		body = L["When a team is loaded its name goes here. You can reload the team by clicking here or right-click for team options such as setting notes."]
	end
	rematch.ShowTooltip(self,L["Last Loaded Team"],body)
end
