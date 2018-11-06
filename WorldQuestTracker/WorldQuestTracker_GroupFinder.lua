-- ~disabled

--world quest tracker object
local WorldQuestTracker = WorldQuestTrackerAddon
if (not WorldQuestTracker) then
	return
end

--framework
local DF = _G ["DetailsFramework"]
if (not DF) then
	print ("|cFFFFAA00World Quest Tracker: framework not found, if you just installed or updated the addon, please restart your client.|r")
	return
end

--localization
local L = LibStub ("AceLocale-3.0"):GetLocale ("WorldQuestTrackerAddon", true)
if (not L) then
	return
end


local ff = WorldQuestTrackerFinderFrame
local rf = WorldQuestTrackerRareFrame

ff.cannot_group_quest = {}

--> store players near the player
ff.PlayersNearby = {}
ff.PlayersInvited = {}

local GameCooltip = GameCooltip2

local _
local QuestMapFrame_IsQuestWorldQuest = QuestMapFrame_IsQuestWorldQuest or QuestUtils_IsQuestWorldQuest
local GetNumQuestLogRewardCurrencies = GetNumQuestLogRewardCurrencies
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetQuestLogRewardCurrencyInfo = GetQuestLogRewardCurrencyInfo
local GetQuestLogRewardMoney = GetQuestLogRewardMoney
local GetQuestTagInfo = GetQuestTagInfo
local GetNumQuestLogRewards = GetNumQuestLogRewards
local GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID
local GetQuestTimeLeftMinutes = C_TaskQuest.GetQuestTimeLeftMinutes

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

local LibWindow = LibStub ("LibWindow-1.1")
if (not LibWindow) then
	print ("|cFFFFAA00World Quest Tracker|r: libwindow not found, did you just updated the addon? try reopening the client.|r")
end

--finder frame

ff.Width = 240
ff.Height = 170
ff.ButtonWidth = 236
ff.ButtonHeight = 20
ff.ButtonVerticalPadding = 4
ff.TitleHeight = 20 + (ff.ButtonVerticalPadding*2)

ff:SetSize (ff.Width, ff.Height)
ff:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
ff:SetBackdropColor (0, 0, 0, 1)
ff:SetBackdropBorderColor (0, 0, 0, 1)
ff:SetPoint ("center")
ff:EnableMouse (true)
ff:SetMovable (true)
ff:Hide()

ff.RightClickClose = DF:CreateLabel (ff, L["right click to close this window"])
ff.RightClickClose:SetPoint ("bottom", ff, "bottom", 0, 2)
ff.RightClickClose.color = "gray"

--tick frame
ff.TickFrame = CreateFrame ("frame", nil, UIParent)

ff.SetEnabledFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.enabled = value
	GameCooltip:Hide()
end

ff.SetFindGroupForRares = function (_, _, value)
	WorldQuestTracker.db.profile.rarescan.search_group = value
	GameCooltip:Hide()
end

ff.SetOTButtonsFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.tracker_buttons = value
	if (value) then
		--enabled
		WorldQuestTracker:FullTrackerUpdate()
	else
		--disabled
		if (ff.BQuestTrackerUsedWidgets) then
			for block, button in pairs (ff.BQuestTrackerUsedWidgets) do
				if (ff.RemoveButtonFromBBlock) then
					ff.RemoveButtonFromBBlock (block)
				end
			end
		end
	end
	GameCooltip:Hide()
end

ff.SendWhispersFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.send_whispers = value
	GameCooltip:Hide()
end

ff.AlreadyInGroupFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.dont_open_in_group = value
	GameCooltip:Hide()
end

ff.SetAutoGroupLeaveFunc = function (_, _, value, key)
	WorldQuestTracker.db.profile.groupfinder.autoleave = false
	WorldQuestTracker.db.profile.groupfinder.autoleave_delayed = false
	WorldQuestTracker.db.profile.groupfinder.askleave_delayed = false
	WorldQuestTracker.db.profile.groupfinder.noleave = false
	
	WorldQuestTracker.db.profile.groupfinder [key] = true
	
	GameCooltip:Hide()
end
ff.SetGroupLeaveTimeoutFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.leavetimer = value
	if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
		WorldQuestTracker.db.profile.groupfinder.autoleave = false
		WorldQuestTracker.db.profile.groupfinder.askleave_delayed = true
	end
	GameCooltip:Hide()
end

ff.BuildMenuFunc = function()
	GameCooltip:Preset (2)
	GameCooltip:SetOption ("TextSize", 10)
	GameCooltip:SetOption ("FixedWidth", 180)
	
	--enabled
	GameCooltip:AddLine (L["S_GROUPFINDER_ENABLED"])
	if (WorldQuestTracker.db.profile.groupfinder.enabled) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.SetEnabledFunc, not WorldQuestTracker.db.profile.groupfinder.enabled)
	
	--find group for rares
	GameCooltip:AddLine (L["S_GROUPFINDER_AUTOOPEN_RARENPC_TARGETED"])
	if (WorldQuestTracker.db.profile.rarescan.search_group) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.SetFindGroupForRares, not WorldQuestTracker.db.profile.rarescan.search_group)		
	
	--uses buttons on the quest tracker
	GameCooltip:AddLine (L["S_GROUPFINDER_OT_ENABLED"])
	if (WorldQuestTracker.db.profile.groupfinder.tracker_buttons) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.SetOTButtonsFunc, not WorldQuestTracker.db.profile.groupfinder.tracker_buttons)

	--
	GameCooltip:AddLine ("$div", nil, 1, nil, -5, -11)
	--
	
	--
	GameCooltip:AddLine ("Send Invite Whispers")
	if (WorldQuestTracker.db.profile.groupfinder.send_whispers) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.SendWhispersFunc, not WorldQuestTracker.db.profile.groupfinder.send_whispers)
	
	GameCooltip:AddLine ("Don't Show if Already in Group")
	if (WorldQuestTracker.db.profile.groupfinder.dont_open_in_group) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.AlreadyInGroupFunc, not WorldQuestTracker.db.profile.groupfinder.dont_open_in_group)

	--
	GameCooltip:AddLine ("$div", nil, 1, nil, -5, -11)
	--
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS"])
	GameCooltip:AddIcon ([[Interface\BUTTONS\UI-GROUPLOOT-PASS-DOWN]], 1, 1, IconSize, IconSize)
	
	--leave group
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_IMMEDIATELY"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave, "autoleave")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_AFTERX"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.autoleave_delayed) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave_delayed, "autoleave_delayed")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_ASKX"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.askleave_delayed) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.askleave_delayed, "askleave_delayed")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_DONTLEAVE"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.noleave) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.noleave, "noleave")
	
	--
	GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
	--ask to leave with timeout
	GameCooltip:AddLine ("10 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 10) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 10)
	
	GameCooltip:AddLine ("15 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 15) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 15)
	
	GameCooltip:AddLine ("20 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 20) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 20)
	
	GameCooltip:AddLine ("30 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 30) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 30)
	
	GameCooltip:AddLine ("60 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 60) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.SetGroupLeaveTimeoutFunc, 60)
end

function WorldQuestTracker.OpenGroupFinderForQuest()
	--get the quest information
	local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (ff.CurrentWorldQuest)
	
	if (not LFGListFrame.SearchPanel.SearchBox.Instructions2) then
		LFGListFrame.SearchPanel.SearchBox.Instructions2 = WorldQuestTracker:CreateLabel (LFGListFrame.SearchPanel.SearchBox)
		LFGListFrame.SearchPanel.SearchBox.Instructions2:SetPoint ("right", -21, 0)
		LFGListFrame.SearchPanel.SearchBox.Instructions2.color = "gray"
		LFGListFrame.SearchPanel.SearchBox.Instructions2.alpha = 0.3
		LFGListFrame.SearchPanel.SearchBox.Instructions2.align = ">"
		
		--ballon popup
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon = CreateFrame ("frame", "WorldQuestTrackerGroupFinderPopup", LFGListFrame.EntryCreation.Name, "MicroButtonAlertTemplate")
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetFrameLevel (2000)
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.Text:SetSpacing (4)
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetPoint ("bottomleft", LFGListFrame.SearchPanel.SearchBox, "topleft", 0, 20)
		
		LFGListFrame.SearchPanel.SearchBox:HookScript ("OnHide", function()
			LFGListFrame.SearchPanel.SearchBox.Instructions2.text = ""
			LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Hide()
		end)
		
		LFGListFrame.SearchPanel.SearchBox:HookScript ("OnTextChanged", function()
			local text = LFGListFrame.SearchPanel.SearchBox:GetText()
			if (tonumber (text) == ff.CurrentWorldQuest) then
				LFGListFrame.SearchPanel.SearchBox.Instructions2.text = ""
				LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Hide()
			end
		end)
		
		LFGListFrame.EntryCreation.Name:HookScript ("OnEnterPressed", function()
			LFGListFrame.EntryCreation.ListGroupButton:Click()
		end)
		
		LFGListSearchPanelScrollFrame.StartGroupButton:HookScript ("OnClick", function()
			C_Timer.After (0.1, function()
				if (not LFGListFrame.EntryCreation.Name.Instructions2) then
					LFGListFrame.EntryCreation.Name.Instructions2 = WorldQuestTracker:CreateLabel (LFGListFrame.EntryCreation.Name)
					LFGListFrame.EntryCreation.Name.Instructions2:SetPoint ("right", -21, 0)
					LFGListFrame.EntryCreation.Name.Instructions2.color = "gray"
					LFGListFrame.EntryCreation.Name.Instructions2.alpha = 0.3
					LFGListFrame.EntryCreation.Name.Instructions2.align = ">"
					
					LFGListFrame.EntryCreation.Name:HookScript ("OnHide", function()
						LFGListFrame.EntryCreation.Name.Instructions2.text = ""
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Hide()
					end)
				end

				if (WorldQuestTracker.OpenSearchTime and WorldQuestTracker.OpenSearchTime+30 > GetTime()) then
					LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetPoint ("bottomleft", LFGListFrame.EntryCreation.Name, "topleft", 0, 20)
					LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Show()
					LFGListFrame.EntryCreation.Name.Instructions2.text = "Enter the QuestID: " .. ff.CurrentWorldQuest
					LFGListFrame.EntryCreation.Name.Instructions:SetText("")
				end
			end)
		end)
		
		--/dump LFGListFrame.EntryCreation.Name
	end
	
	if (title) then
		LFGListUtil_OpenBestWindow()
		LFGListCategorySelection_SelectCategory (LFGListFrame.CategorySelection, 1, 0)
		LFGListCategorySelection_StartFindGroup (LFGListFrame.CategorySelection)
		
		LFGListFrame.SearchPanel.SearchBox.Instructions:SetText ("")
		LFGListFrame.SearchPanel.SearchBox:SetFocus (true)
		
		LFGListFrame.SearchPanel.SearchBox.Instructions2.text = "Enter the QuestID: " .. ff.CurrentWorldQuest
		WorldQuestTracker.OpenSearchTime = GetTime()
		
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.label = "Enter the QuestID: " .. ff.CurrentWorldQuest
		MicroButtonAlert_SetText (LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon, LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.label)
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Show()
		LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetPoint ("bottomleft", LFGListFrame.SearchPanel.SearchBox, "topleft", 0, 20)
	end
end

--> TEXT quest name
ff.QuestNameText = WorldQuestTracker:CreateLabel (ff, L["Quest Name:"])
ff.QuestName2Text = WorldQuestTracker:CreateLabel (ff, "")
ff.QuestNameText:SetPoint ("topleft", ff, "topleft", 2, -ff.ButtonVerticalPadding - ff.TitleHeight)
ff.QuestName2Text:SetPoint ("left", ff.QuestNameText, "right", 2, 0)

--> TEXT quest ID
ff.QuestIDText = WorldQuestTracker:CreateLabel (ff, L["Quest ID:"])
ff.QuestID2Text = WorldQuestTracker:CreateLabel (ff, "")
ff.QuestIDText:SetPoint ("topleft", ff.QuestNameText, "bottomleft", 0, -ff.ButtonVerticalPadding)
ff.QuestID2Text:SetPoint ("left", ff.QuestIDText, "right", 2, 0)

--> BUTTON open group finder window
ff.OpenGroupFinderButton = WorldQuestTracker:CreateButton (ff, WorldQuestTracker.OpenGroupFinderForQuest, ff.ButtonWidth, ff.ButtonHeight, L["Search for a Group in Group Finder"], -1, nil, nil, nil, nil, nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
ff.OpenGroupFinderButton:SetPoint ("topleft", ff.QuestIDText, "bottomleft", 0, -ff.ButtonVerticalPadding)
ff.OpenGroupFinderButton:SetClickFunction (function() ff:HideFrame (true) end, false, false, "right")

ff:SetScript ("OnMouseDown", function (self, button)
	if (button == "RightButton") then
		ff:HideFrame (true)
	end
end)

--> BUTTON onvite nearby players

function ff.StartAutoInvites()

	local nextInviteWave = 0.025414
	if (not ff.InvitePlayersButton.inviteAnimation:IsPlaying()) then
		ff.InvitePlayersButton.inviteAnimation:Play()
	end
	
	ff.InvitePlayersButton:Disable()
	
	ff:SetScript ("OnUpdate", function (self, deltaTime)
	
		nextInviteWave = nextInviteWave - deltaTime
		
		if (nextInviteWave < 0) then
		
			--update the quest size
			ff.UpdatePlayerNearbyCount()
		
			local numMembersInGroup = GetNumGroupMembers()
			if (numMembersInGroup >= 5) then
				self:SetScript ("OnUpdate", nil)
				WorldQuestTracker:Msg ("Group is full.")
				if (ff.InvitePlayersButton.inviteAnimation:IsPlaying()) then
					ff.InvitePlayersButton.inviteAnimation:Stop()
				end
				ff.UpdatePlayerNearbyCount()
				return
			end
		
			local playerName = next (ff.PlayersNearby)
			if (playerName) then
			
				if (not ff.PlayersInvited [playerName]) then
					local inviteCooldown = ff.PlayersNearby [playerName]
					if (inviteCooldown+20 > GetTime()) then
						--> invite unit and add a cooldown
						InviteUnit (playerName)
						
						WorldQuestTracker:Msg ("Inviting " .. playerName)
						
						ff.PlayersInvited [playerName] = true
						ff.PlayersNearby [playerName] = nil
						
						--> send message to player
						if (WorldQuestTracker.db.profile.groupfinder.send_whispers) then
							SendChatMessage ("[World Quest Tracker]: Invite for World Quest '" .. (ff.QuestName2Text:GetText() or "-") .. "'", "WHISPER", nil, playerName)
						end
						
					else
						ff.PlayersNearby [playerName] = nil
					end
					
					if (numMembersInGroup >= 3) then
						nextInviteWave = 3.498547
					else
						nextInviteWave = 1.498547
					end
				else
					ff.PlayersNearby [playerName] = nil
				end
			else
				self:SetScript ("OnUpdate", nil)
				if (ff.InvitePlayersButton.inviteAnimation:IsPlaying()) then
					ff.InvitePlayersButton.inviteAnimation:Stop()
				end
				ff.UpdatePlayerNearbyCount()
			end
		end
	end)
end

ff.InvitePlayersButton = WorldQuestTracker:CreateButton (ff, ff.StartAutoInvites, ff.ButtonWidth, ff.ButtonHeight, L["Invite Nearby Players"], -1, nil, nil, nil, nil, nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
ff.InvitePlayersButton:SetPoint ("top", ff.OpenGroupFinderButton, "bottom", 0, -ff.ButtonVerticalPadding)
ff.InvitePlayersButton:SetClickFunction (function() ff:HideFrame (true) end, false, false, "right")

ff.InvitePlayersButton.InvitingTexture =  WorldQuestTracker:CreateImage (ff.InvitePlayersButton, [[Interface\COMMON\StreamCircle]], 32, 32, "artwork")
ff.InvitePlayersButton.InvitingTexture:SetPoint ("left", 4, 0)
ff.InvitePlayersButton.InvitingTexture:SetAlpha (0.75)
ff.InvitePlayersButton.InvitingTexture:SetVertexColor (.7, .7, .7)
ff.InvitePlayersButton.InvitingTexture:SetBlendMode ("ADD")

ff.InvitePlayersButton.InvitingTextureOverlay =  WorldQuestTracker:CreateImage (ff.InvitePlayersButton, [[Interface\COMMON\StreamFrame]], 32, 32, "overlay")
ff.InvitePlayersButton.InvitingTextureOverlay:SetPoint ("left", 4, 0)
ff.InvitePlayersButton.InvitingTextureOverlay:SetAlpha (0.2)

ff.InvitePlayersButton.InvitingTexture:Hide()
ff.InvitePlayersButton.InvitingTextureOverlay:Hide()

ff.InvitePlayersButton.inviteAnimation = WorldQuestTracker:CreateAnimationHub (ff.InvitePlayersButton.InvitingTexture, function() ff.InvitePlayersButton.InvitingTexture:Show(); ff.InvitePlayersButton.InvitingTextureOverlay:Show() end, function() ff.InvitePlayersButton.InvitingTexture:Hide(); ff.InvitePlayersButton.InvitingTextureOverlay:Hide() end)
ff.InvitePlayersButton.inviteAnimation:SetLooping ("REPEAT")
WorldQuestTracker:CreateAnimation (ff.InvitePlayersButton.inviteAnimation, "ROTATION", 1, 6, -360)

local leave_func = function()
	if (ff.QuestCompletedHidingTimer and not ff.QuestCompletedHidingTimer._cancelled) then
		ff.QuestCompletedHidingTimer:Cancel()
		
	elseif (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
		ff.QuestCancelledHidingTimer:Cancel()
		
	end
	
	ff:HideFrame (true)
	LeaveParty()
end

ff.LeaveButton = WorldQuestTracker:CreateButton (ff, leave_func, ff.ButtonWidth, ff.ButtonHeight, L["LeaveGroup"], -1, nil, nil, nil, nil, nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
ff.LeaveButton:SetPoint ("top", ff.InvitePlayersButton, "bottom", 0, -ff.ButtonVerticalPadding)
ff.LeaveButton:SetClickFunction (function() ff:HideFrame (true) end, false, false, "right")

--> BUTTON open group finder window
local ignore_current_quest = function()
	DF:ShowPromptPanel ("Don't Show Popups for the Quest: " .. (ff.QuestName2Text:GetText() or "-") .. "?", function() 
		if (ff.CurrentWorldQuest) then
			WorldQuestTracker.db.profile.groupfinder.ignored_quests [ff.CurrentWorldQuest] = true
			WorldQuestTracker:Msg ("Quest " .. (ff.QuestName2Text:GetText() or "-") .. " added to ignore list.")
		end
		ff:HideFrame (true)
	end, function() end)
end

ff.IgnoreQuestButton = WorldQuestTracker:CreateButton (ff, ignore_current_quest, ff.ButtonWidth, ff.ButtonHeight, L["Ignore Quest"], -1, nil, nil, nil, nil, nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
ff.IgnoreQuestButton:SetPoint ("top", ff.LeaveButton, "bottom", 0, -ff.ButtonVerticalPadding)
ff.IgnoreQuestButton:SetClickFunction (function() ff:HideFrame (true) end, false, false, "right")

--> Auto search for player nearby

WorldQuestTracker.CommFunctions ["WQTF"] = function (data)
	--data 1 = prefix
	--data 2 = questID
	--data 3 = player name
	
	
	
end

--WorldQuestTracker:SendCommMessage (WorldQuestTracker.COMM_PREFIX, data, "WHISPER", targetCharacter)
--_detalhes:SendCommMessage (CONST_DETAILS_PREFIX, _detalhes:Serialize (CONST_GUILD_SYNC, from, realm, _detalhes.realversion, "L", IDs), "WHISPER", chr_name)
--ff:Show()

function WorldQuestTracker.RegisterGroupFinderFrameOnLibWindow()
	LibWindow.RegisterConfig  (ff, WorldQuestTracker.db.profile.groupfinder.frame)
	LibWindow.MakeDraggable (ff)
	LibWindow.RestorePosition (ff)
	ff.IsRegistered = true
	
	DF:CreateTitleBar (ff, "Title")
	
	--gear button
	ff.Options = CreateFrame ("button", "$parentTopRightOptionsButton", ff)
	ff.Options:SetPoint ("right", ff.CloseButton, "left", -2, 0)
	ff.Options:SetSize (16, 16)
	ff.Options:SetNormalTexture (DF.folder .. "icons")
	ff.Options:SetHighlightTexture (DF.folder .. "icons")
	ff.Options:SetPushedTexture (DF.folder .. "icons")
	ff.Options:GetNormalTexture():SetTexCoord (48/128, 64/128, 0, 1)
	ff.Options:GetHighlightTexture():SetTexCoord (48/128, 64/128, 0, 1)
	ff.Options:GetPushedTexture():SetTexCoord (48/128, 64/128, 0, 1)
	ff.Options:SetAlpha (0.7)
	
	ff.Options.CoolTip = {
		Type = "menu",
		BuildFunc = ff.BuildMenuFunc,
		OnEnterFunc = function (self) end,
		OnLeaveFunc = function (self) end,
		FixedValue = "none",
		ShowSpeed = 0.05,
		Options = {
			["FixedWidth"] = 300,
		},
	}

	GameCooltip:CoolTipInject (ff.Options)
	
	--> on show animations
	local onShowAnimationHub = DF:CreateAnimationHub (ff, function()ff:Show()end)
	DF:CreateAnimation (onShowAnimationHub, "ALPHA", 1, 1/14, 0, 1)
	ff.AnimationShow = onShowAnimationHub
	
	--> on hide animations
	local onHideAnimationHub = DF:CreateAnimationHub (ff, function()end, function()ff:Hide()end)
	DF:CreateAnimation (onHideAnimationHub, "ALPHA", 1, 0.5, 1, 0)
	ff.AnimationHide = onHideAnimationHub
	
	function ff:ShowFrame()
		ff.AnimationHide:Stop()
		ff.AnimationShow:Play()
		ff.Options:Show()
		
		ff.InvitePlayersButton:Disable()
		ff.LeaveButton:Disable()
		
		if (IsInGroup()) then
			ff.LeaveButton:Enable()
		else
			ff.LeaveButton:Disable()
		end
	end

	function ff:HideFrame (noAnimation)
		ff:SetScript ("OnUpdate", nil)
		if (ff.InvitePlayersButton.inviteAnimation:IsPlaying()) then
			ff.InvitePlayersButton.inviteAnimation:Stop()
		end
		ff.AnimationShow:Stop()
		
		if (noAnimation) then
			ff:Hide()
		else
			ff.AnimationHide:Play()
		end
	end
	
	ff:SetScript ("OnShow", function()
		
	end)
	
	ff:SetScript ("OnHide", function()
		
	end)
	
end

ff:RegisterEvent ("QUEST_TURNED_IN")
ff:RegisterEvent ("QUEST_ACCEPTED")
ff:RegisterEvent ("QUEST_REMOVED")
ff:RegisterEvent ("GROUP_ROSTER_UPDATE")
ff:RegisterEvent ("GROUP_INVITE_CONFIRMATION")
ff:RegisterEvent ("LFG_LIST_APPLICANT_LIST_UPDATED")
ff:RegisterEvent ("ZONE_CHANGED_NEW_AREA")

ChatFrame_AddMessageEventFilter ("CHAT_MSG_WHISPER", function (_, _, msg)
	if (not WorldQuestTracker.db.profile.groupfinder.send_whispers) then
		if (msg:find ("World Quest Tracker")) then
			if (msg:find ("Invite for World Quest")) then
				return true
			end
		end
	end
end)

function ff:PlayerEnteredWorldQuestZone (questID)
	--> update the frame
	local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (questID)
	if (title) then
		ff.IsInQuestZone = true
		ff.CurrentWorldQuest = questID
		
		--> toggle buttons
		ff.OpenGroupFinderButton:Enable()
		ff.IgnoreQuestButton:Enable()
		
		if (not IsInGroup()) then
			ff.LeaveButton:Disable()
		else
			ff.LeaveButton:Enable()
		end
		
		ff:ShowFrame()
		
		ff:SetTitle (L["World Quest Tracker"])
		
		ff.QuestName2Text.text = title
		ff.QuestID2Text.text = questID
		
		wipe (ff.PlayersNearby)
		wipe (ff.PlayersInvited)
		
		ff:RegisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
		
		--> check for active timers and disable them
		if (ff.QuestCompletedHidingTimer and not ff.QuestCompletedHidingTimer._cancelled) then
			ff.QuestCompletedHidingTimer:Cancel()
		end
		if (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
			ff.QuestCancelledHidingTimer:Cancel()
		end
	end
end

function ff:PlayerLeftWorldQuestZone (questID, questCompleted)
	--questCompleted is true when the zone left came from the quest completed event
	ff.IsInQuestZone = nil
	ff.IsInWQGroup = nil
	
	--stop auto invites if any
	ff:SetScript ("OnUpdate", nil)
	
	if (questCompleted) then
		--> cancel the timer for leaving the quest area if any
		if (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
			ff.QuestCancelledHidingTimer:Cancel()
		end
		if (ff.QuestCompletedHidingTimer and not ff.QuestCompletedHidingTimer._cancelled) then
			ff.QuestCompletedHidingTimer:Cancel()
		end
		
		local isInInstance = IsInInstance()
		
		if (IsInGroup() and not isInInstance) then
		
			--> disable buttons
			ff.InvitePlayersButton:Disable()
			ff.OpenGroupFinderButton:Disable()
			ff.IgnoreQuestButton:Disable()
			--> enable button
			ff.LeaveButton:Enable()
			
			--> show the frame if isn't shown
			if (not ff:IsShown()) then
				ff:ShowFrame()
			end
			
		elseif (not IsInGroup() and not isInInstance) then
			
			--> check if is in the group finder
			local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, questID = C_LFGList.GetActiveEntryInfo()
			
			if (active) then
				--> disable buttons
				ff.InvitePlayersButton:Disable()
				ff.OpenGroupFinderButton:Disable()
				ff.IgnoreQuestButton:Disable()
				--> enable button
				ff.LeaveButton:Enable()
				
				--> show the frame if isn't shown
				if (not ff:IsShown()) then
					ff:ShowFrame()
				end
			else
				--> hide the frame if is still shown
				if (ff:IsShown()) then
					ff:HideFrame()
				end
			end

		end
		
		ff.QuestCompletedHidingTimer = C_Timer.NewTimer (20, function()
			ff:HideFrame()
		end)
	else
		--> apply the timer to leave the window by leaving the quest area only if there is not a timer by quest completed
		if (not ff.QuestCompletedHidingTimer or ff.QuestCompletedHidingTimer._cancelled) then
			if (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
				ff.QuestCancelledHidingTimer:Cancel()
			end
			ff.QuestCancelledHidingTimer = C_Timer.NewTimer (5, function()
				ff:HideFrame()
			end)
		end
	end
	
	ff:UnregisterEvent ("COMBAT_LOG_EVENT_UNFILTERED")
	
	--> check to left the group
	
	
end

function ff.DelayedCheckForDisband()
	--> when the player left the group
	
	
	
end

function ff.UpdatePlayerNearbyCount()
	if (ff:IsShown()) then
		local amount = 0
		for playerName, _ in pairs (ff.PlayersNearby) do
			amount = amount + 1
		end
		
		if (amount > 0) then
			--> only run if it isn't inviting
			if (not ff:GetScript ("OnUpdate")) then
				ff.InvitePlayersButton:Enable()
			end
		else
			ff.InvitePlayersButton:Disable()
		end
		
		--ff.InvitePlayersButton:SetText ("Invite Nearby Players [" .. amount .. "]")
	end
end

ff:SetScript ("OnEvent", function (self, event, arg1, questID, arg3)

	--is this feature enable?
	if (not WorldQuestTracker.db.profile.groupfinder.enabled) then
		return
	end
	
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	
		local time, token, hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12 = CombatLogGetCurrentEventInfo()
		
		if (who_name and not ff.PlayersNearby [who_name] and not ff.PlayersInvited [who_name]) then
			if (who_flags and (bit.band (who_flags, 0x00000410) == 0x00000410)) then
				if (who_name ~= UnitName ("player")) then
					ff.PlayersNearby [who_name] = GetTime() --when the player got spotted
					ff.UpdatePlayerNearbyCount()
				end
			end
		end
		
		if (target_name and not ff.PlayersNearby [target_name] and not ff.PlayersInvited [target_name]) then
			if (target_flags and (bit.band (target_flags, 0x00000410) == 0x00000410)) then
				if (target_name ~= UnitName ("player")) then
					ff.PlayersNearby [target_name] = GetTime() --when the player got spotted
					ff.UpdatePlayerNearbyCount (target_name)
				end
			end
		end
	
	elseif (event == "LFG_LIST_APPLICANT_LIST_UPDATED") then
--		/dump select (5, C_LFGList.GetActiveEntryInfo()):find("k00000|")
		local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, questID = C_LFGList.GetActiveEntryInfo()
		
		--> check if the player has a group listed in the LFG and if is the group leader
		if (active and ff.CurrentWorldQuest and UnitIsGroupLeader ("player") and name:find ("k00000|")) then
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (ff.CurrentWorldQuest)
			
			local isInQuest = false
			
			--> check if the player still have the quest from the popup
			local numQuests = GetNumQuestLogEntries() 
			for i = 1, numQuests do 
				local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle (i)
				if (questTitle == title) then
					isInQuest = true
				end
			end
			
			if (isInQuest) then
				if (GetNumGroupMembers() <= 4) then
					local applicantInfo = C_LFGList.GetApplicants()
					if (applicantInfo and #applicantInfo > 0) then
						for i = 1, #applicantInfo do
							local id, status, pendingStatus, numMembers, isNew, comment = C_LFGList.GetApplicantInfo (applicantInfo [i])
							if (status == "applied") then
								local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = C_LFGList.GetApplicantMemberInfo (applicantInfo [i], 1)
								if (name) then
									InviteUnit (name)
									WorldQuestTracker:Msg ("Auto Inviting " .. name .. " from the LFG apply.")
								end
							end
						end
					end
				end
			else
				--> player doesn't have the quest from the popup window, the group should be deslisted or this is a group for another activity
				--if (not ff:IsShown()) then
					--> show the frame again so the player can click on the leave group
				--	ff:ShowFrame()
				--end
			end
		end
	
	elseif (event == "QUEST_ACCEPTED") then
		--> get quest data
		local isInArea, isOnMap, numObjectives = GetTaskInfo (questID)
		local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (questID)
		
		-->  do the regular checks
		if (isInArea and HaveQuestData (questID)) then
			local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
			if (isWorldQuest) then
				--FlashClientIcon()
				--WorldQuestTracker.FindGroupForQuest (questID)
				
				--> player entered in a world quest zone
				--> need to handle when it leaves
				--> show the panel, player entered in a world quest zone

				if (WorldQuestTracker.db.profile.groupfinder.ignored_quests [questID]) then
					return
				end
				
				if (WorldQuestTracker.db.profile.groupfinder.dont_open_in_group and IsInGroup()) then
					return
				end
				
				ff.CurrentWorldQuest = questID
				ff:PlayerEnteredWorldQuestZone (questID)
			end
		end 
	
	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		local isInInstance = IsInInstance()
		if (isInInstance) then
			ff:HideFrame()
		end
	
	elseif (event == "QUEST_REMOVED") then
		questID = arg1
		if (questID == ff.CurrentWorldQuest) then
			
			ff.CurrentWorldQuest = nil
			ff:PlayerLeftWorldQuestZone (questID)
		end
	
	elseif (event == "QUEST_LOG_UPDATE") then
		
		
	
	elseif (event == "QUEST_TURNED_IN") then
		questID = arg1
		local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
		if (isWorldQuest) then
			ff.WorldQuestFinished (questID)

			--> check if the quest completed was the current world quest
			if (questID == ff.CurrentWorldQuest) then
				ff.CurrentWorldQuest = nil
				ff:PlayerLeftWorldQuestZone (questID, true)
			end
		end
	
	elseif (event == "GROUP_ROSTER_UPDATE") then
		--> is in a world quest group
		if (ff.IsInWQGroup) then
			--> player left the group
			if (not IsInGroup()) then
				ff.IsInWQGroup = false
				ff.PreviousLeader = nil
				C_Timer.After (2, ff.DelayedCheckForDisband)
			else
				ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
				--> tell the rare finder the group has been modified
				rf.ScheduleGroupShareRares()
			end
		else
			if (IsInGroup()) then
				ff.IsInWQGroup = true
				ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
				
				--> player entered in a group
				
			end
		end
		
		if (IsInGroup()) then
			ff.LeaveButton:Enable()
		else
			ff.LeaveButton:Disable()
		end
		
	elseif (event == "GROUP_INVITE_CONFIRMATION") then
		--> hide annoying alerts
		if (ff.IsInWQGroup) then
			StaticPopup_Hide ("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
			StaticPopup_Hide ("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			StaticPopup_Hide ("GROUP_INVITE_CONFIRMATION")
		end		
		
	end
end)

--deprecated?
function ff.NewWorldQuestEngaged (questName, questID, isSearchOnCustom, customTitle, customDesc, customGroupDescription)
	--> reset the gump
	ff.ShutdownOnTickScript (true)
	ff.ResetInteractionButton()
	ff.ResetMembers()
	
	--> update the interactive button to current quest
	interactionButton.questName = questName or isSearchOnCustom
	interactionButton.questID = questID or 0
	interactionButton.HadInteraction = nil

	ff.AFKCheckList = ff.AFKCheckList or {}
	wipe (ff.AFKCheckList)
	
	if (not isSearchOnCustom) then
		--> normal search for quests
		ff.SetQuestTitle (questName .. " (" .. questID .. ")")
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCH)
		
	else
		--> custom searchs
		ff.SearchCustomGroupDesc = customGroupDescription
		ff.SetQuestTitle (customTitle or isSearchOnCustom)
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHCUSTOM, customDesc)
	end
	
	ff.HasLeadership = false
	
	--> show the main frame
	if (not ff.IsRegistered) then
		WorldQuestTracker.RegisterGroupFinderFrameOnLibWindow()
	end
end	

ff.BQuestTrackerFreeWidgets = {}
ff.BQuestTrackerUsedWidgets = {}

function ff.OnBBlockButtonPress (self, button)
	if (self.questID) then
		
		ff:PlayerEnteredWorldQuestZone (self.questID)
		
	end
end

function ff.OnBBlockButtonEnter (self)
	GameTooltip:SetOwner (self, "ANCHOR_LEFT")
	GameTooltip:AddLine (L["S_GROUPFINDER_ACTIONS_SEARCH_TOOLTIP"])
	GameTooltip:Show()
end

function ff.OnBBlockButtonLeave (self)
	GameTooltip:Hide()
end

function ff.UpdateButtonAnchorOnBBlock (block, button)
	button:ClearAllPoints()
	
	--> detect other addons to avoid placing our icons over other addons icons
	if (WorldQuestGroupFinderAddon) then --todo: add the world quest assistant addon here too
		--button:SetPoint ("right", block.TrackedQuest, "left", -2, 0)
		button:SetPoint ("topright", block, "topright", 11, -17)
	else
		--check if there's a quest button
		if (block.rightButton and block.rightButton:IsShown()) then
			button:SetPoint ("right", block.rightButton, "left", -2, 0)
		else
			button:SetPoint ("topright", block, "topright", 10, 0)
		end
	end
	
	button:SetParent (block)
	button:SetFrameStrata ("LOW")
	button:Show()
end

--> need to place a button somewhere to search for a group in case the player closes the panel
function ff.AddButtonToBBlock (block, questID)
	local button = tremove (ff.BQuestTrackerFreeWidgets)
	if (not button) then
		button = CreateFrame ("button", nil, UIParent)
		button:SetFrameStrata ("FULLSCREEN")
		button:SetSize (30, 30)
		
		button:SetNormalTexture ([[Interface\BUTTONS\UI-SquareButton-Up]])
		button:SetPushedTexture ([[Interface\BUTTONS\UI-SquareButton-Down]])
		button:SetHighlightTexture ([[Interface\BUTTONS\UI-Common-MouseHilight]])
		
		local icon = button:CreateTexture (nil, "OVERLAY")
		icon:SetAtlas ("socialqueuing-icon-eye")
		icon:SetSize (13, 13)
		
		--icon:SetSize (22, 22)
		--icon:SetTexture ([[Interface\FriendsFrame\PlusManz-PlusManz]])
		--icon:SetPoint ("center", button, "center")
		
		icon:SetPoint ("center", button, "center", -1, 0)
		
		button:SetScript ("OnClick", ff.OnBBlockButtonPress)
		button:SetScript ("OnEnter", ff.OnBBlockButtonEnter)
		button:SetScript ("OnLeave", ff.OnBBlockButtonLeave)
	end
	
	ff.UpdateButtonAnchorOnBBlock (block, button)
	
	ff.BQuestTrackerUsedWidgets [block] = button
	button.questID = questID
	
end

function ff.RemoveButtonFromBBlock (block)
	tinsert (ff.BQuestTrackerFreeWidgets, ff.BQuestTrackerUsedWidgets [block])
	ff.BQuestTrackerUsedWidgets [block]:ClearAllPoints()
	ff.BQuestTrackerUsedWidgets [block]:Hide()
	ff.BQuestTrackerUsedWidgets [block] = nil
end

function ff.HandleBTrackerBlock (questID, block)
	if (not ff.BQuestTrackerUsedWidgets [block]) then
		if (type (questID) == "number" and HaveQuestData (questID) and QuestMapFrame_IsQuestWorldQuest (questID)) then
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
			if (not ff.cannot_group_quest [worldQuestType] and not WorldQuestTracker.MapData.GroupFinderIgnoreQuestList [questID]) then
				--> give a button for this block
				ff.AddButtonToBBlock (block, questID)
			end
		end
	else
		local isInArea, isOnMap, numObjectives = GetTaskInfo (questID) -- or not isInArea
		if (type (questID) ~= "number" or not HaveQuestData (questID) or not QuestMapFrame_IsQuestWorldQuest (questID)) then
			--> remove the button from this block
			ff.RemoveButtonFromBBlock (block)
		else
			--> just update the questID
			ff.BQuestTrackerUsedWidgets [block].questID = questID
			--> update the anchor
			ff.UpdateButtonAnchorOnBBlock (block, ff.BQuestTrackerUsedWidgets [block])
		end
	end
end


function ff.GroupDone()
	--> hide the frame
	--ff:HideFrame()
	--> leave the group
	if (IsInGroup()) then
		if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
			LeaveParty()
		else
			--> show timer to leave the group
			---ff.SetAction (ff.actions.ACTIONTYPE_GROUP_LEAVE)
		end
	end
end

function ff.WorldQuestFinished (questID, fromCustomSeearch)
	ff.GroupDone()
end
