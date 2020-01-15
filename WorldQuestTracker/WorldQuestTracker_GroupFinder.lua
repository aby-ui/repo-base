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

	--check if the quest is elite
	
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (ff.CurrentWorldQuest)
	--> check if player is in quest, otherwise it'll be a ghost button
	if (ff:IsShown() and isElite and WorldQuestTracker.PlayerIsInQuest (title)) then
		local success = WorldQuestTracker.TrackEliteQuest (ff.CurrentWorldQuest)
		if (not success) then
			
		end
		return
	end

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
	
	if (title or ff.NpcID) then
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

ff.OpenGroupFinderButton.FlashTexture = ff.OpenGroupFinderButton:CreateTexture (nil, "overlay")
ff.OpenGroupFinderButton.FlashTexture:SetColorTexture (1, 1, 1)
ff.OpenGroupFinderButton.FlashTexture:SetAllPoints()
ff.OpenGroupFinderButton.FlashTexture:Hide()
ff.OpenGroupFinderButton.FlashAnimation = DF:CreateAnimationHub (ff.OpenGroupFinderButton.FlashTexture, function() ff.OpenGroupFinderButton.FlashTexture:Show() end, function() ff.OpenGroupFinderButton.FlashTexture:Hide() end)
DF:CreateAnimation (ff.OpenGroupFinderButton.FlashAnimation, "ALPHA", 1, 0.1, 0, 0.4)
DF:CreateAnimation (ff.OpenGroupFinderButton.FlashAnimation, "ALPHA", 2, 0.1, 0.6, 0)


ff:SetScript ("OnMouseDown", function (self, button)
	if (button == "RightButton") then
		ff:HideFrame (true)
	end
end)

--> BUTTON onvite nearby players
local InvitePlayersOnClick = function()
	GameCooltip:Hide()
	C_Timer.After (0.15, function()
		GameCooltip:ExecFunc (ff.InvitePlayersButton.widget)
	end)
end

ff.InvitePlayersButton = WorldQuestTracker:CreateButton (ff, InvitePlayersOnClick, ff.ButtonWidth, ff.ButtonHeight, "Invite Nearby Players", -1, nil, nil, nil, nil, nil, WorldQuestTracker:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
ff.InvitePlayersButton:SetPoint ("top", ff.OpenGroupFinderButton, "bottom", 0, -ff.ButtonVerticalPadding)
ff.InvitePlayersButton:SetClickFunction (function() ff:HideFrame (true) end, false, false, "right")

local playerSelectedToInvite = function (self, fixedValue, value)
	GameCooltip2:Hide()
	ff.PlayersNearby [value] = nil
	ff.PlayersInvited [value] = true
	InviteUnit (value)
	
	C_Timer.After (0.15, function()
		GameCooltip:ExecFunc (ff.InvitePlayersButton.widget)
	end)
end

local BuildInviteMenu = function()
	GameCooltip2:Preset (2)
	local playerName = next (ff.PlayersNearby)
	if (playerName) then
		local added = false
		
		for playerName, playerInfo in pairs (ff.PlayersNearby) do
			local spottedAt, guid = unpack (playerInfo)
			if (spottedAt + 20 > GetTime()) then
				local className, classId, raceName, raceId, gender, name, realm = GetPlayerInfoByGUID (guid)
				
				if (classId) then
					GameCooltip:AddLine (playerName, "", 1, classId)
				else
					GameCooltip:AddLine (playerName)
				end
				
				GameCooltip:AddMenu (1, playerSelectedToInvite, playerName)
				added = true
			end
		end
		
		if (not added) then
			GameCooltip2:AddLine ("No other players nearby.")
		end
	else
		GameCooltip2:AddLine ("No other players nearby.")
	end
end

ff.InvitePlayersButton.widget.CoolTip = {
	Type = "menu",
	BuildFunc = BuildInviteMenu,
	OnEnterFunc = function (self) 
		ff.InvitePlayersButton.widget.button_mouse_over = true
	end,
	OnLeaveFunc = function (self) 
		ff.InvitePlayersButton.widget.button_mouse_over = false
	end,
	FixedValue = "none",
	ShowSpeed = 0.02,
	Options = function()
		GameCooltip:SetOption ("MyAnchor", "left")
		GameCooltip:SetOption ("RelativeAnchor", "right")
		GameCooltip:SetOption ("WidthAnchorMod", -2)
		GameCooltip:SetOption ("HeightAnchorMod", 0)
		GameCooltip:SetOption ("LineHeightSizeOffset", 4)
		GameCooltip:SetOption ("VerticalPadding", -4)
		GameCooltip:SetOption ("FrameHeightSizeOffset", 4)
	end
}

GameCooltip2:CoolTipInject (ff.InvitePlayersButton.widget)

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
		
		ff.LeaveButton:Disable()
		
		if (IsInGroup()) then
			ff.LeaveButton:Enable()
		else
			ff.LeaveButton:Disable()
		end
	end

	function ff:HideFrame (noAnimation)
		ff:SetScript ("OnUpdate", nil)
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

function ff:PlayerEnteredWorldQuestZone (questID, npcID, npcName)
	--> update the frame

	local title, isNpc
	if (npcID) then
		--> check if the group finder can search for rares
		if (WorldQuestTracker.db.profile.rarescan.search_group) then
		
			if (WorldQuestTracker.db.profile.groupfinder.ignored_quests [npcID]) then
				return
			end
			
			if (WorldQuestTracker.db.profile.groupfinder.dont_open_in_group and IsInGroup()) then
				return
			end
		
			title = npcName
			questID = npcID
			isNpc = true
		end
		
	elseif (questID) then
		title = C_TaskQuest.GetQuestInfoByQuestID (questID)
		
	end
	
	if (title) then
		ff.IsInQuestZone = true
		ff.CurrentWorldQuest = questID
		ff.NpcID = isNpc and questID
		
		--> toggle buttons
		ff.OpenGroupFinderButton:Enable()
		ff.IgnoreQuestButton:Enable()
		
		if (not IsInGroup()) then
			ff.LeaveButton:Disable()
		else
			ff.LeaveButton:Enable()
		end
		
		ff:ShowFrame()
		
		if (type (questID) == "number") then
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
			if (isElite) then
				ff.OpenGroupFinderButton:Disable()
				C_Timer.After (3, function() 
					ff.OpenGroupFinderButton:Enable()
					ff.OpenGroupFinderButton.FlashAnimation:Play()
				end)
			end
		end
		
		
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

local asd = ff:CreateFontString (nil, "overlay", "GameFontNormal")

function WorldQuestTracker.PlayerIsInQuest (questName, questID)
	local isInQuest = false
	local numQuests = GetNumQuestLogEntries() 
	
	if (questName) then
		for i = 1, numQuests do 
			local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID = GetQuestLogTitle (i)
			if (questName == questTitle) then
				isInQuest = true
			end
		end
	else
		for i = 1, numQuests do 
			local questTitle, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, thisQuestID = GetQuestLogTitle (i)
			if (thisQuestID == questID) then
				isInQuest = true
			end
		end
	end
	
	return isInQuest
end

function WorldQuestTracker.TrackEliteQuest (questID)
	local tracker = ObjectiveTrackerFrame
	
	if (not tracker.initialized) then
		return false
	end
	
	for i = 1, #tracker.MODULES do
		local module = tracker.MODULES [i]
		for blockName, usedBlock in pairs (module.usedBlocks) do
			if (usedBlock.id == questID) then
				if (usedBlock.rightButton) then
					usedBlock.rightButton:Click()
					return true
				end
			end
		end
	end
	
	return false
end

function WorldQuestTracker.InviteFromGroupApply()
	if (not ff.CurrentWorldQuest) then
		return
	end
	
--[=[
--		/dump select (5, C_LFGList.GetActiveEntryInfo()):find("k00000|")
	
	print ("=============")
	for k, v in pairs (a) do
		print (k,v)
	end
	print ("=============")
	--]=]
	
	local a = C_LFGList.GetActiveEntryInfo()
	if (not a) then
		return
	end
	local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, questID = a.active, a.activityID, a.ilvl, a.honorLevel, a.name, a.comment, a.voiceChat, a.duration, a.autoAccept, a.privateGroup, a.questID
	--active = true --disabling to fix later
	
	--print ("player applyind:", active, ff.CurrentWorldQuest, UnitIsGroupLeader ("player"), name:find ("ks2|"), name:find ("k000000|"), name == ff.CurrentWorldQuest)
	--print (name, type (name))
	
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (ff.CurrentWorldQuest)
	local mapName, shortName, activityCategoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType = C_LFGList.GetActivityInfo (activityID)
	local standingMapID = WorldQuestTracker.GetCurrentStandingMapAreaID()
	local playerStandingMapName = WorldQuestTracker.GetMapName (standingMapID)
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData (ff.CurrentWorldQuest)
	
	--Details:Dump ({C_LFGList.GetActivityInfo (activityID)})
	
	--print ("name = questid", tostring (ff.CurrentWorldQuest) == name)
	--[=[
	for i = 1, #name do
	    local letter = name:sub(i,i)
	    --print (letter)
	end
	--strings inside the lfg system seems to be upvalued and bridget by a escape sequence which increments every new group shown
	--]=]

	if (not LFGListUtil_GetQuestCategoryData) then
		WorldQuestTracker:Msg ("LFGListUtil_GetQuestCategoryData isn't accessible anymore.")
		return
	end

	--/dump GetMouseFocus():Click()
	
	--print ("title:",title == questName, "category:", categoryID == activityCategoryID, "map name", playerStandingMapName == mapName, " | ", categoryID, activityCategoryID, playerStandingMapName)
	--> check if the quest title, category, and zone from the wqt popup matches with the quest title, category and zone from the lfg frame
	if (title == questName and categoryID == activityCategoryID and playerStandingMapName == mapName) then

	--> check if the player has a group listed in the LFG and if is the group leader
	--if (active and ff.CurrentWorldQuest and UnitIsGroupLeader ("player") and (activityCategoryID == 0)) then --name:find ("ks2|") or name:find ("k000000|") or name == ff.CurrentWorldQuest
		
		local isInQuest = WorldQuestTracker.PlayerIsInQuest (title)
		
		if (isInQuest) then

			if (GetNumGroupMembers() <= 3 and UnitIsGroupLeader ("player")) then

				local applicantInfo = C_LFGList.GetApplicants()
				if (applicantInfo and #applicantInfo > 0) then

					for i = 1, #applicantInfo do
						local b = C_LFGList.GetApplicantInfo (applicantInfo [i])
						local id, status, pendingStatus, numMembers, isNew, comment = b.id, b.applicationStatus, b.pendingStatus, b.numMembers, b.isNew, b.comment
						--print (id, status, pendingStatus, numMembers, isNew, comment)
						if (status == "applied") then
							--local a = C_LFGList.GetApplicantMemberInfo (applicantInfo [i], 1)
							--local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = a.name, a.class, a.localizedClass, a.level, a.itemLevel, a.honorLevel, a.tank, a.healer, a.damage, a.assignedRole, a.relationship
							local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship = C_LFGList.GetApplicantMemberInfo (applicantInfo [i], 1)
							
							--print (name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship)
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
end

ff:SetScript ("OnEvent", function (self, event, arg1, questID, arg3)
	
	--is this feature enable?
	if (not WorldQuestTracker.db.profile.groupfinder.enabled) then
		return
	end
	
	if (event == "COMBAT_LOG_EVENT_UNFILTERED") then
	
		local time, token, hidding, who_serial, who_name, who_flags, who_flags2, target_serial, target_name, target_flags, target_flags2, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12 = CombatLogGetCurrentEventInfo()
		
		if (who_name and who_serial and type (who_serial) == "string" and who_serial:find ("Player") and not ff.PlayersNearby [who_name] and not ff.PlayersInvited [who_name]) then
			if (who_flags and (bit.band (who_flags, 0x00000410) == 0x00000410)) then
				if (who_name ~= UnitName ("player")) then
					ff.PlayersNearby [who_name] = {GetTime(), who_serial} --when the player got spotted
				end
			end
		end
		
		if (target_name and target_serial and type (target_serial) == "string" and target_serial:find ("Player") and not ff.PlayersNearby [target_name] and not ff.PlayersInvited [target_name]) then
			if (target_flags and (bit.band (target_flags, 0x00000410) == 0x00000410)) then
				if (target_name ~= UnitName ("player")) then
					ff.PlayersNearby [target_name] = {GetTime(), target_serial} --when the player got spotted
				end
			end
		end

	elseif (event == "LFG_LIST_APPLICANT_LIST_UPDATED") then
		if (GetNumGroupMembers() <= 4 and IsInGroup() and UnitIsGroupLeader ("player")) then
			C_Timer.After (3, WorldQuestTracker.InviteFromGroupApply)
		end
	
	elseif (event == "QUEST_ACCEPTED") then
		--> get quest data
		local isInArea, isOnMap, numObjectives = GetTaskInfo (questID)
		local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (questID)
		
		-->  do the regular checks
		if ((isInArea or isOnMap) and HaveQuestData (questID)) then

			--get all quests from 8.3 assault stuff
			local allAssaultQuests = {}
			for _, questId in ipairs(C_TaskQuest.GetThreatQuests()) do
				--put all into a table where the hash is the key and true is the value
				allAssaultQuests [questId] = true
			end

			--if the quest is a worldquest OR the quest is listed as an 8.3 assault quest
			if ((isWorldQuest and isInArea) or allAssaultQuests[questID]) then
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

ff.InvitePlayersButton.button.text:SetText(L["Invite Nearby Players"]) --abyui
