local _,L = ...
local rematch = Rematch
local settings, saved
local card = RematchWinRecordCard

rematch:InitModule(function()
	settings = RematchSettings
	saved = RematchSaved

	card.Title:SetText(L["Win Record"])
	card.Content.AltFlipHelp:SetText(L["Hold [Alt] to view totals for all teams."])

	for k,v in pairs({{L["Wins:"],0,1,0},{L["Losses:"],1,0.1,0.1},{L["Draws:"],1,0.82,0}}) do
		local stat = card.Content.Stats[k]
		stat.Add.Icon:SetTexCoord(0.3095703125,0.337890625,0.763671875,0.8203125)
		stat.Label:SetText(v[1])
		stat.Add.Icon:SetDesaturated(true)
		stat.Add.Icon:SetVertexColor(v[2],v[3],v[4])
		stat.Percent:SetTextColor(v[2],v[3],v[4])
		stat.Label:SetTextColor(v[2],v[3],v[4])
	end
	rematch:ConvertTitlebarCloseButton(card.CloseButton)
end)	

-- returns the win record stats of a team
function rematch:GetTeamWinRecord(key)
	local team = saved[key]
	if team then
		local wins = team.wins or 0
		local losses = team.losses or 0
		local draws = team.draws or 0
		local battles = wins + losses + draws
		return wins, losses, draws, battles
	end
end


function rematch:ShowWinRecord(parent,key,force)
	-- if card is locked (or ClickPetCard enabled) don't show card unless forced (via click)
	if (not force and card.locked) or (settings.ClickPetCard and not force) then
		return
	end
	-- for non-forced shows, delay showing the card
	if not settings.ClickPetCard and not settings.FastPetCard and not force then
		if parent and key then
			card.parent = parent
			card.key = key
			rematch:StartTimer("ShowWinRecord",0.25,rematch.ShowWinRecord)
			return
		else -- if key is nil then this is the func being called from the timer above
			parent = card.parent
			key = card.key
		end
	end
	local team = saved[key]
	if not team then
		return -- don't bother showing winrecord for a team that doesn't exist
	end
	if force then
		card.locked = true
	end

	local tab = saved[key].tab or 1

	card.parent = parent
	card.key = key

	card:UpdateWinRecord()
	rematch:SmartAnchor(card,parent,nil,22,-26)
	card:Show()
end

-- to be called anytime the lock state or contents of the win record needs updated
function card:UpdateWinRecord()
	local key = card.key
	local team = saved[key]
	local content = card.Content

	local results = {0,0,0,0} -- 1=wins, 2=losses, 3=draws, 4=battles

	local showTotals = IsAltKeyDown() or MouseIsOver(card.Content.LeftIcon) or MouseIsOver(card.Content.RightIcon)

	if showTotals then
		content.Name:SetText(L["Totals Across All Teams"])
		content.RightIcon.Texture:SetTexture("Interface\\Icons\\PetJournalPortrait")
		content.LeftIcon.Texture:SetTexture("Interface\\Icons\\Achievement_BG_DG_Master_of_the_deepwind_gorge")
		for k in pairs(saved) do
			local wins,losses,draws,battles = rematch:GetTeamWinRecord(k)
			results[1] = results[1] + wins
			results[2] = results[2] + losses
			results[3] = results[3] + draws
			results[4] = results[4] + battles
		end
	elseif team then
		-- fill in card
		content.Name:SetText(rematch:GetTeamTitle(key,true))
		content.RightIcon.Texture:SetTexture(settings.TeamGroups[team.tab or 1][2])
		content.LeftIcon.Texture:SetTexture("Interface\\Icons\\Achievement_BG_KillXEnemies_GeneralsRoom")
		results[1],results[2],results[3],results[4] = rematch:GetTeamWinRecord(key)
	end

	content.BattleCount:SetText(format(L["%s%s\124r Battles"],rematch.hexWhite,results[4]))
	for i=1,3 do
		content.Stats[i].Value:SetText(results[i])
		content.Stats[i].EditBox:SetText(results[i])
		content.Stats[i].Percent:SetText(results[4]>0 and format("%.1f%%",results[i]*100/results[4]) or NOT_APPLICABLE)
	end

	-- show/hide the Hold [Alt] to view help text depending on HideMenuHelp setting
	card.Content.AltFlipHelp:SetShown(not settings.HideMenuHelp)
	card:SetHeight(settings.HideMenuHelp and 222 or 236)

	-- update locked state
	local showEditBoxes = card.locked and not showTotals
	card:SetAlpha(card.locked and 1 or 0)
	for stat=1,3 do
	  card.Content.Stats[stat].EditBox:SetShown(showEditBoxes)
	  card.Content.Stats[stat].Add:SetShown(showEditBoxes)
	  card.Content.Stats[stat].Value:SetShown(not showEditBoxes)
	  card.Content.Stats[stat].Percent:SetShown(not showEditBoxes)
	end
end

function rematch:HideWinRecord(maybe)
	if maybe and card.locked then return end
	card:Hide()
end

function card:OnHide()
	card.locked = nil
	card.parent = nil
	card.key = nil
	card:SetAlpha(1)
	card:UnregisterEvent("MODIFIER_STATE_CHANGED")
end

function card:OnKeyDown(key)
	if key==GetBindingKey("TOGGLEGAMEMENU") and card.locked then
		rematch:HideWinRecord()
		self:SetPropagateKeyboardInput(false)
	elseif key=="TAB" and card.locked then
		card.OnTabPressed(card.Content.Draws.EditBox)
		self:SetPropagateKeyboardInput(false)
	else
		self:SetPropagateKeyboardInput(true)
	end
end

--[[ WinRecordButton handlers ]]

-- tooltip for the little WinRecord button beside each team
function rematch:WinRecordOnEnter()
	rematch:ShowWinRecord(self,self:GetParent().key)
end

function rematch:WinRecordOnLeave()
	if not settings.FastPetCard then
		rematch:StopTimer("ShowWinRecord")
	end
	rematch:HideWinRecord(true)
end

-- click of the little WinRecord button beside each team
function rematch:WinRecordOnClick(fromLoadedTeam)
	local key = self:GetParent().key
	if not key then
		return
	end
	if settings.ClickPetCard then
		card.locked = true
	end
	if key~=card.key then
		rematch:ShowWinRecord(self,key,true) -- can change true to card.key and true to make reclick not locked
	elseif settings.ClickPetCard then
		rematch:HideWinRecord()
	else
		card.locked = not card.locked
	end
	card:UpdateWinRecord()
end

-- mousedown of the winrecord footnote
function rematch:WinRecordOnMouseDown()
	if settings.SlimListButtons and settings.SlimListSmallText then
		self.Text:SetFontObject(GameFontWhiteTiny)
	else
		self.Text:SetFontObject(GameFontHighlightSmall)
	end
end

-- mouseup of the winrecord footnote
function rematch:WinRecordOnMouseUp()
	if settings.SlimListButtons and settings.SlimListSmallText then
		self.Text:SetFontObject(GameFontHighlightSmall)
	else
		self.Text:SetFontObject(GameFontHighlight)
	end
end

-- fills in/colors the passed WinRecordButton, returning true if it should be shown
function rematch:FillWinRecordButton(button,key)
	local wins,losses,draws,battles = rematch:GetTeamWinRecord(key)
	if battles and battles>0 and not settings.HideWinRecord then
		local percent = floor(wins*100/battles+0.5)
		button.Text:SetText(settings.AlternateWinRecord and wins or format("%d%%",percent))
		local left,right,top,bottom
		if percent>=60 then
			left,right,top,bottom = 0,0.296875,0,0.28125
		elseif percent<=40 then
			left,right,top,bottom = 0,0.296875,0.375,0.65625
		else
			left,right,top,bottom = 0,0.296875,0.71875,1
		end
		button:GetNormalTexture():SetTexCoord(left,right,top,bottom)
		button:GetPushedTexture():SetTexCoord(left,right,top,bottom)
		return true
	end
end

-- floats the RematchWinRecardToast above a parent frame, where stat is 1="+1 Win" 2="+1 Loss" 3="+1 Draw"
-- returns true if it did a toast; from is the parent frame where the card came from
function rematch:ToastWinRecord(from,key,stat)
	if key and stat then
		local parent -- find the team list button that contains this key (to know which to toast over)
		if from==rematch.LoadedTeamPanel or from==rematch.LoadedTeamPanel.Footnotes.WinRecord then
			parent = settings.HideWinRecord and rematch.LoadedTeamPanel or rematch.LoadedTeamPanel.Footnotes.WinRecord
		elseif rematch.TeamPanel:IsVisible() then
			for _,button in ipairs(rematch.TeamPanel.List.ScrollFrame.buttons) do
				if button.key==key then
					parent = settings.HideWinRecord and button or button.WinRecord
					break
				end
			end
		end
		if parent then -- if parent to toast isn't found that's okay, we just won't toast
			local toast = RematchWinRecordToast
			if stat==1 then
				toast.Text:SetText(L["+1 Win"])
				toast.Text:SetTextColor(0,1,0)
			elseif stat==2 then
				toast.Text:SetText(L["+1 Loss"])
				toast.Text:SetTextColor(1,0.2,0.2)
			elseif stat==3 then
				toast.Text:SetText(L["+1 Draw"])
				toast.Text:SetTextColor(1,0.82,0)
			else
				return -- no idea what to display, get out of here
			end
			toast:SetParent(parent)
			toast:SetFrameLevel(parent:GetFrameLevel()+5)
			toast:SetPoint("CENTER",parent,"TOP",-8,0)
			toast:Show()
			if rematch.TeamPanel:IsVisible() then
				rematch:ListBling(rematch.TeamPanel.List.ScrollFrame,"key",key)
			end
			if key==settings.loadedTeam then
				rematch.LoadedTeamPanel.Bling:Show()
			end
			return true
		end
	end
end

--[[ Card controls while the card is locked ]]

-- tab pressed in editbox moves to next editbox
function card:OnTabPressed()
	card.Content.Stats[self:GetParent():GetID()%3+1].EditBox:SetFocus(true)
end

-- click on the + button beside the Wins/Losses/Draws editboxes in the WinRecordCard controls
function card:AddButtonOnClick()
	local key = card.key
	local team = saved[key]
	if team then
		local parent = card.parent -- noting this before hiding the card and parent lost; it's what spawned the card
		local stat = self:GetParent().stat
		team[stat] = (team[stat] or 0) + 1
		card:Hide()
		rematch:UpdateUI()
		if not rematch:ToastWinRecord(parent,key,self:GetParent():GetID()) and rematch.TeamPanel:IsVisible() then
			rematch:ShowTeam(key)
		end
	end
end

-- from clicking Save in the WinRecordCard controls
function card:SaveWinRecord()
	local key = card.key
	if saved[key] then
		for i=1,3 do
			local stat = card.Content.Stats[i].stat
			saved[key][stat] = tonumber(card.Content.Stats[i].EditBox:GetText())
			if saved[key][stat]==0 then
				saved[key][stat] = nil -- don't save 0s, nil them out
			end
		end
		card:Hide()
		rematch:UpdateUI()
		if rematch.TeamPanel:IsVisible() then
			rematch:ShowTeam(key) -- flashes the team
		end
		if key==settings.loadedTeam and rematch.LoadedTeamPanel:IsVisible() then
			rematch.LoadedTeamPanel.Bling:Show()
		end
	end
end

-- from clicking Reset in the lowerleft of the WinRecordCard controls
function card:ShowResetDialog()
	local key = card.key
	if saved[key] then
		local dialog = rematch:ShowDialog("ResetWinRecord",300,146,L["Reset Win Record"],nil,YES,card.AcceptResetWinRecord,NO)
		dialog:SetContext("key",key) -- restore key
		dialog:ShowText(format(L["Are you sure you want to remove all wins, losses and draws from the team \"%s\"?"],rematch:GetTeamTitle(key,true)),240,80,"TOP",0,-32)
	end
end

-- from clicking Yes in ShowResetDialog
function card:AcceptResetWinRecord()
	local key = rematch.Dialog:GetContext("key")
	local team = saved[key]
	if team then
		team.wins = nil
		team.losses = nil
		team.draws = nil
		if rematch.TeamPanel:IsVisible() then
			rematch:ShowTeam(key)
		else
			rematch:UpdateUI()
		end
	end
end

--[[ Slash-command stuff ]]

-- hopefully seldom-used function called from /rematch winrecord reset : to wipe all winrecord stats
function rematch:ShowResetAllWinRecordsDialog()
	local dialog = rematch:ShowDialog("ResetAllWinRecords",300,132,L["Reset All Win Records"],L["Are you sure?"],YES,rematch.ResetAllWinRecords,NO)
	dialog.Warning:SetPoint("TOPLEFT",16,-32)
	dialog.Warning.Text:SetText(L["This will remove win record data for all teams and cannot be undone!"])
	dialog.Warning:Show()
end
function rematch:ResetAllWinRecords()
	for _,team in pairs(saved) do
		team.wins = nil
		team.losses = nil
		team.draws = nil
	end
	rematch:UpdateUI()
end

-- this is from /rematch winrecord convert : teams that are named like 123-45-6 Team Name are assumed
-- to have 123 wins, 45 losses and 6 draws. It will add those into the team's winrecord and then remove
-- that portion of text from the team name.
function rematch:ShowConvertTeamNamesToWinRecordDialog()
	local dialog = rematch:ShowDialog("WinRecordConvert",300,270,L["Convert Team Names To Win Records"],nil,L["Convert"],rematch.ConvertTeamNamesToWinRecord,CANCEL)
	dialog:ShowText(L["This will look for teams with names that may include win-loss-draw stats and pull those into an actual win record before removing the numbers from the team name.\n\nDo you want to convert these teams?\n\nThe currently loaded team will be unloaded to prevent major complications.\n\n\124cffff1111Please backup your teams before attempting this!"],260,200,"TOP",0,-24)
end
function rematch:ConvertTeamNamesToWinRecord()
	-- first gather all teams to convert into toConvert ({key,newname,win,loss,draw},{key,newname,win,loss,draw},etc}
	local toConvert = {} -- table of teams to convert (don't maul saved while finding these teams)
	for key,team in pairs(saved) do
		local title = rematch:GetTeamTitle(key)
		local win,loss,draw = title:match("(%d+)[%s%-/\\]+(%d+)[%s%-/\\]+(%d+)")
		if win then -- if team named something like 12-34-5 then it's 12 wins, 34 losses, 5 draws
			local newname = title:match("%d+[%s%-/\\]+%d+[%s%-/\\]+%d+%s+(.+)") or title:match("(.+)%s+%d+[%s%-/\\]+%d+[%s%-/\\]+%d+")
			if newname then
				tinsert(toConvert,{key,newname:trim(),tonumber(win),tonumber(loss),tonumber(draw)})
			end
		else
			win,loss = title:match("(%d+)[%s%-/\\]+(%d+)")
			if win then -- if team named something like 12-34 then it's 12 wins, 34 losses, 0 draws
				local newname = title:match("%d+[%s%-/\\]+%d+%s+(.+)") or title:match("(.+)%s+%d+[%s%-/\\]+%d+")
				if newname then
					tinsert(toConvert,{key,newname:trim(),tonumber(win),tonumber(loss),0})
				end
			end
		end
	end
	rematch:UnloadTeam() -- unload loaded team to prevent potential catastrophe
	-- here goes: data[1]=original key, data[2]=new name, data[3]-[5]=win,loss,draw
	local battles = 0
	for _,data in ipairs(toConvert) do
		local team = rematch:SetSideline(data[1],saved[data[1]])
		rematch:SetSidelineContext("deleteOriginal",true)
		battles = battles + data[3] + data[4] + data[5]
		for i=3,5 do
			if data[i]==0 then
				data[i] = nil -- don't actually store 0s (it won't hurt anything but a ton of 0s is unnecessary)
			end
		end
		team.wins = data[3]
		team.losses = data[4]
		team.draws = data[5]
		-- rename team to drop the win/loss(/draw) bit
		if type(data[1])=="number" then -- this is a targeted team, name is just team.teamName and never conflicts
			team.teamName = data[2]
		else -- this is a named team where key is the name of the team; change the key
			rematch:ChangeSidelineKey(data[2])
			rematch:MakeSidelineUnique() -- rename if any name conflicts after name change
			team = rematch:GetSideline()
		end
		rematch:print(rematch:GetTeamTitle(data[1]),"->",data[2],format("w:%d l:%d d:%d",data[3],data[4],data[5]))
		rematch:PushSideline()
	end
	-- display dialog showing how many converted
	local dialog = rematch:ShowDialog("WinRecordConvertDone",300,164,L["Done!"],nil,nil,nil,OKAY)
	dialog:ShowText(format(L["%s%d teams and %d battles were converted."],rematch.hexWhite,#toConvert,battles),240,96,"TOP",0,-32)
end
