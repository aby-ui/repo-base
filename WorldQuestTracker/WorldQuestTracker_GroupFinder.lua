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
ff:SetSize (240, 100)
ff:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
ff:SetBackdropColor (0, 0, 0, 1)
ff:SetBackdropBorderColor (0, 0, 0, 1)
ff:SetPoint ("center")
ff:EnableMouse (true)
ff:SetMovable (true)
ff:Hide()

--tick frame
ff.TickFrame = CreateFrame ("frame", nil, UIParent)

--> titlebar
ff.TitleBar = CreateFrame ("frame", "$parentTitleBar", ff)
ff.TitleBar:SetPoint ("topleft", ff, "topleft", 2, -3)
ff.TitleBar:SetPoint ("topright", ff, "topright", -2, -3)
ff.TitleBar:SetHeight (20)
ff.TitleBar:EnableMouse (false)
ff.TitleBar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
ff.TitleBar:SetBackdropColor (.2, .2, .2, 1)
ff.TitleBar:SetBackdropBorderColor (0, 0, 0, .5)

--close button
ff.Close = CreateFrame ("button", "$parentCloseButton", ff)
ff.Close:SetPoint ("right", ff.TitleBar, "right", -2, 0)
ff.Close:SetSize (16, 16)
ff.Close:SetNormalTexture (DF.folder .. "icons")
ff.Close:SetHighlightTexture (DF.folder .. "icons")
ff.Close:SetPushedTexture (DF.folder .. "icons")
ff.Close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
ff.Close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
ff.Close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
ff.Close:SetAlpha (0.7)
ff.Close:SetScript ("OnClick", function() ff.HideMainFrame() end)

--gear button
ff.Options = CreateFrame ("button", "$parentOptionsButton", ff)
ff.Options:SetPoint ("right", ff.Close, "left", -2, 0)
ff.Options:SetSize (16, 16)
ff.Options:SetNormalTexture (DF.folder .. "icons")
ff.Options:SetHighlightTexture (DF.folder .. "icons")
ff.Options:SetPushedTexture (DF.folder .. "icons")
ff.Options:GetNormalTexture():SetTexCoord (48/128, 64/128, 0, 1)
ff.Options:GetHighlightTexture():SetTexCoord (48/128, 64/128, 0, 1)
ff.Options:GetPushedTexture():SetTexCoord (48/128, 64/128, 0, 1)
ff.Options:SetAlpha (0.7)

--do the menu with cooltip injection
ff.Options.SetEnabledFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.enabled = value
	if (value) then
		--check if is doing a world quest and popup the gump
		
	else
		--hide the current doing world quest
		--ff.ResetMembers()
		--ff.ResetInteractionButton()
		--ff.HideMainFrame()
	end
	
	GameCooltip:Hide()
end

ff.Options.SetAvoidPVPFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.nopvp = value
	GameCooltip:Hide()
end

ff.Options.SetNoAFKFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.noafk = value
	GameCooltip:Hide()
end

ff.Options.SetFindGroupForRares = function (_, _, value)
	WorldQuestTracker.db.profile.rarescan.search_group = value
	GameCooltip:Hide()
end

ff.Options.SetFindInvasionPoints = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.invasion_points = value
	GameCooltip:Hide()
end

ff.Options.SetOTButtonsFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.tracker_buttons = value
	if (value) then
		--enabled
		WorldQuestTracker:FullTrackerUpdate()
	else
		--disabled
		for block, button in pairs (ff.BQuestTrackerUsedWidgets) do
			ff.RemoveButtonFromBBlock (block)
		end
	end
	GameCooltip:Hide()
end

ff.Options.SetAutoGroupLeaveFunc = function (_, _, value, key)
	WorldQuestTracker.db.profile.groupfinder.autoleave = false
	WorldQuestTracker.db.profile.groupfinder.autoleave_delayed = false
	WorldQuestTracker.db.profile.groupfinder.askleave_delayed = false
	WorldQuestTracker.db.profile.groupfinder.noleave = false
	
	WorldQuestTracker.db.profile.groupfinder [key] = true
	
	GameCooltip:Hide()
end
ff.Options.SetGroupLeaveTimeoutFunc = function (_, _, value)
	WorldQuestTracker.db.profile.groupfinder.leavetimer = value
	if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
		WorldQuestTracker.db.profile.groupfinder.autoleave = false
		WorldQuestTracker.db.profile.groupfinder.askleave_delayed = true
	end
	GameCooltip:Hide()
end

ff.Options.BuildMenuFunc = function()
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
	GameCooltip:AddMenu (1, ff.Options.SetEnabledFunc, not WorldQuestTracker.db.profile.groupfinder.enabled)
	
	--find group for rares
	GameCooltip:AddLine (L["S_GROUPFINDER_AUTOOPEN_RARENPC_TARGETED"])
	if (WorldQuestTracker.db.profile.rarescan.search_group) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.Options.SetFindGroupForRares, not WorldQuestTracker.db.profile.rarescan.search_group)		
	
	--find invasion points
	GameCooltip:AddLine (L["S_GROUPFINDER_INVASION_ENABLED"])
	if (WorldQuestTracker.db.profile.groupfinder.invasion_points) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.Options.SetFindInvasionPoints, not WorldQuestTracker.db.profile.groupfinder.invasion_points)
	
	
	--uses buttons on the quest tracker
	GameCooltip:AddLine (L["S_GROUPFINDER_OT_ENABLED"])
	if (WorldQuestTracker.db.profile.groupfinder.tracker_buttons) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.Options.SetOTButtonsFunc, not WorldQuestTracker.db.profile.groupfinder.tracker_buttons)

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
	GameCooltip:AddMenu (2, ff.Options.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave, "autoleave")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_AFTERX"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.autoleave_delayed) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.autoleave_delayed, "autoleave_delayed")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_ASKX"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.askleave_delayed) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.askleave_delayed, "askleave_delayed")
	
	GameCooltip:AddLine (L["S_GROUPFINDER_LEAVEOPTIONS_DONTLEAVE"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.noleave) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetAutoGroupLeaveFunc, not WorldQuestTracker.db.profile.groupfinder.noleave, "noleave")
	
	--
	GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
	--ask to leave with timeout
	GameCooltip:AddLine ("10 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 10) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetGroupLeaveTimeoutFunc, 10)
	
	GameCooltip:AddLine ("15 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 15) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetGroupLeaveTimeoutFunc, 15)
	
	GameCooltip:AddLine ("20 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 20) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetGroupLeaveTimeoutFunc, 20)
	
	GameCooltip:AddLine ("30 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 30) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetGroupLeaveTimeoutFunc, 30)
	
	GameCooltip:AddLine ("60 " .. L["S_GROUPFINDER_SECONDS"], "", 2)
	if (WorldQuestTracker.db.profile.groupfinder.leavetimer == 60) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 2, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 2, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (2, ff.Options.SetGroupLeaveTimeoutFunc, 60)
	
	GameCooltip:AddLine ("$div", nil, 1, nil, -5, -11)
	
	--no pvp realms
	GameCooltip:AddLine (L["S_GROUPFINDER_NOPVP"])
	if (WorldQuestTracker.db.profile.groupfinder.nopvp) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.Options.SetAvoidPVPFunc, not WorldQuestTracker.db.profile.groupfinder.nopvp)
	
	--kick afk players
	GameCooltip:AddLine ("Kick AFKs")
	if (WorldQuestTracker.db.profile.groupfinder.noafk) then
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-CheckBox-Check]], 1, 1, 16, 16)
	else
		GameCooltip:AddIcon ([[Interface\BUTTONS\UI-AutoCastableOverlay]], 1, 1, 16, 16, .4, .6, .4, .6)
	end
	GameCooltip:AddMenu (1, ff.Options.SetNoAFKFunc, not WorldQuestTracker.db.profile.groupfinder.noafk)
	
end

ff.Options.CoolTip = {
	Type = "menu",
	BuildFunc = ff.Options.BuildMenuFunc,
	OnEnterFunc = function (self) end,
	OnLeaveFunc = function (self) end,
	FixedValue = "none",
	ShowSpeed = 0.05,
	Options = {
		["FixedWidth"] = 300,
	},
}

GameCooltip:CoolTipInject (ff.Options)

--> illustrate the clickable box
ff.ClickArea = CreateFrame ("frame", nil, ff)
ff.ClickArea:SetPoint ("topleft", ff.TitleBar, "bottomleft", 0, -1)
ff.ClickArea:SetPoint ("topright", ff.TitleBar, "bottomright", 0, -1)
ff.ClickArea:SetHeight (74)
ff.ClickArea:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
ff.ClickArea:SetBackdropColor (.2, .2, .2, .4)
ff.ClickArea:SetBackdropBorderColor (0, 0, 0, .5)
ff.ClickArea:EnableMouse (false)
ff.ClickArea:SetFrameLevel (ff:GetFrameLevel()+1)

--> interaction button
local interactionButton = CreateFrame ("button", nil, ff)
interactionButton:SetPoint ("topleft", ff, "topleft", 0, -20)
interactionButton:SetPoint ("bottomright", ff, "bottomright", 0, 0)
interactionButton:SetFrameLevel (ff:GetFrameLevel()+2)
interactionButton:RegisterForClicks ("RightButtonDown", "LeftButtonDown")

local secondaryInteractionButton = CreateFrame ("button", nil, ff)
secondaryInteractionButton:SetPoint ("bottomright", ff, "bottomright", -5, 4)
secondaryInteractionButton:SetWidth (100)
secondaryInteractionButton:SetHeight (18)
secondaryInteractionButton:SetFrameLevel (ff:GetFrameLevel()+4)
secondaryInteractionButton:RegisterForClicks ("RightButtonDown", "LeftButtonDown")
secondaryInteractionButton:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
secondaryInteractionButton:SetBackdropColor (.2, .2, .2, 1)
secondaryInteractionButton:SetBackdropBorderColor (0, 0, 0, 1)
secondaryInteractionButton.ButtonText = DF:CreateLabel (secondaryInteractionButton, "placeholder", DF:GetTemplate ("font", "WQT_GROUPFINDER_SMALL"))
secondaryInteractionButton.ButtonText:SetPoint ("CENTER", secondaryInteractionButton, "CENTER", 0, 0)
secondaryInteractionButton:Hide()

--title
ff.Title = ff.TitleBar:CreateFontString ("$parentTitle", "overlay", "GameFontNormal")
ff.Title:SetPoint ("center", ff.TitleBar, "center")
ff.Title:SetTextColor (.8, .8, .8, 1)
ff.Title:SetText (L["World Quest Tracker"])

ff.AnchorFrame = CreateFrame ("frame", nil, ff)
ff.AnchorFrame:SetAllPoints()
ff.AnchorFrame:SetFrameLevel (ff:GetFrameLevel()+3)

--> label 1
ff.Label1 = DF:CreateLabel (ff.AnchorFrame, " ", DF:GetTemplate ("font", "WQT_GROUPFINDER_BIG"))
ff.Label1:SetPoint (5, -30)

--> label 2
ff.Label2 = DF:CreateLabel (ff.AnchorFrame, " ", DF:GetTemplate ("font", "WQT_GROUPFINDER_SMALL"))
ff.Label2:SetPoint (5, -47)

--> label 3
ff.Label3 = DF:CreateLabel (ff.AnchorFrame, L["S_GROUPFINDER_RIGHTCLICKCLOSE"], DF:GetTemplate ("font", "WQT_GROUPFINDER_TRANSPARENT"))
ff.Label3:SetPoint ("bottomleft", ff, "bottomleft", 5, 4)

--> progress bar
ff.ProgressBar = DF:CreateBar (ff.AnchorFrame, nil, 230, 16, 50)
ff.ProgressBar:SetPoint (5, -60)
ff.ProgressBar.fontsize = 11
ff.ProgressBar.fontface = "Accidental Presidency"
ff.ProgressBar.fontcolor = "darkorange"
ff.ProgressBar.color = "gray"	
ff.ProgressBar:EnableMouse (false)

function ff.ShowSecondaryInteractionButton (actionID, text)
	--> reset the button
	secondaryInteractionButton.ToSearch = nil
	secondaryInteractionButton.ToCreate = nil
	
	--> setup new variables
	secondaryInteractionButton.ButtonText:SetText (text)
	
	if (actionID == ff.actions.ACTIONTYPE_GROUP_SEARCH) then
		secondaryInteractionButton.ToSearch = true
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_CREATE) then
		secondaryInteractionButton.ToCreate = true
	end
	
	--> show it
	secondaryInteractionButton:Show()
end

function ff.HideSecondaryInteractionButton()
	secondaryInteractionButton:Hide()
end

--> feedback
--[=
	ff.FeedbackFrame = CreateFrame ("button", nil, ff)
	ff.FeedbackFrame:SetPoint ("topleft", ff, "bottomleft", 0, -2)
	ff.FeedbackFrame:SetPoint ("topright", ff, "bottomright", 0, -2)
	ff.FeedbackFrame:SetHeight (16)
	ff.FeedbackFrame:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
	ff.FeedbackFrame:SetBackdropColor (.2, .2, .2, 1)
	ff.FeedbackFrame:SetBackdropBorderColor (.1, .10, .10, 1)
	
	ff.FeedbackEntry = DF:CreateTextEntry (ff.FeedbackFrame, function()end, 120, 20, nil, _, nil, nil)
	ff.FeedbackEntry:SetAllPoints()
	ff.FeedbackEntry:SetText ([[https://wow.curseforge.com/projects/world-quest-tracker/issues/464]])
	ff.FeedbackEntry:Hide()
	
	ff.FeedbackFrame:SetScript ("OnClick", function()
		ff.FeedbackEntry:Show()
		ff.FeedbackEntry:SetFocus (true)
		ff.FeedbackEntry:HighlightText()
		
		C_Timer.After (1, function()
			ff.FeedbackEntry:SetFocus (true)
			ff.FeedbackEntry:HighlightText()
		end)
		
		C_Timer.After (20, function()
			ff.FeedbackFrame:Hide()
		end)
	end)
	
	DF:InstallTemplate ("font", "WQT_GROUPFINDER_FEEDBACK", {color = {1, .9, .4, .85}, size = 9, font = ChatFontNormal:GetFont()})
	ff.FeedbackFrame.Text = DF:CreateLabel (ff.FeedbackFrame, "Under Development - Send Feedback", DF:GetTemplate ("font", "WQT_GROUPFINDER_FEEDBACK"))
	ff.FeedbackFrame.Text:SetPoint ("center", ff.FeedbackFrame, "center")
	
	ff.FeedbackFrame:Hide()
--]=]
--[[
quotes:
-middle clicking the tracked quest will start a search for that quest

/dump LFGListInviteDialog
resultID=4,
informational=true,

--]]
-- end of the feedback code

ff.BQuestTrackerFreeWidgets = {}
ff.BQuestTrackerUsedWidgets = {}

ff.actions = {
	ACTIONTYPE_GROUP_SEARCH = 1,
	ACTIONTYPE_GROUP_CREATE = 2,
	ACTIONTYPE_GROUP_RELIST = 3,
	ACTIONTYPE_GROUP_APPLY = 4,
	ACTIONTYPE_GROUP_WAIT = 5,
	ACTIONTYPE_GROUP_SEARCHING = 6,
	ACTIONTYPE_GROUP_LEAVE = 7,
	ACTIONTYPE_GROUP_UNLIST = 8,
	ACTIONTYPE_GROUP_UNAPPLY = 9,
	ACTIONTYPE_GROUP_KICK = 10,
	ACTIONTYPE_GROUP_SEARCHANOTHER = 11,
	ACTIONTYPE_GROUP_SEARCHCUSTOM = 12,
}

ff.cannot_group_quest = {
	[LE_QUEST_TAG_TYPE_PET_BATTLE] = true,
}

function WorldQuestTracker.RegisterGroupFinderFrameOnLibWindow()
	LibWindow.RegisterConfig  (ff, WorldQuestTracker.db.profile.groupfinder.frame)
	LibWindow.MakeDraggable (ff)
	LibWindow.RestorePosition (ff)
	ff.IsRegistered = true

	local texture = LibStub:GetLibrary ("LibSharedMedia-3.0"):Fetch ("statusbar", "Iskar Serenity")
	ff.ProgressBar.timer_texture:SetTexture (texture)
	ff.ProgressBar.background:SetTexture (texture)
end

--> register needed events
function ff.RegisterEvents()
	ff:RegisterEvent ("QUEST_ACCEPTED")
	ff:RegisterEvent ("QUEST_TURNED_IN")
	ff:RegisterEvent ("GROUP_ROSTER_UPDATE")
	ff:RegisterEvent ("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
	ff:RegisterEvent ("GROUP_INVITE_CONFIRMATION")
end
function ff.UnregisterEvents()
	ff:UnregisterEvent ("QUEST_ACCEPTED")
	ff:UnregisterEvent ("QUEST_TURNED_IN")
	ff:UnregisterEvent ("GROUP_ROSTER_UPDATE")
	ff:UnregisterEvent ("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
	ff:UnregisterEvent ("GROUP_INVITE_CONFIRMATION")
end

ff.RegisterEvents()

--> members
ff.IsInWQGroup = false
ff.GroupMembers = 0

function ff.ShowMainFrame()
	ff.SetCheckIfIsInArea (true)
	ff:Show()
end
function ff.HideMainFrame()
	--print (debugstack())
	ff.SetCheckIfIsInArea (false)
	
	if (interactionButton.LeaveTimer) then
		interactionButton.LeaveTimer:Cancel()
		interactionButton.LeaveTimer = nil
	end
	
	ff:Hide()
end

function ff.SetApplyTimeout (timeout)
	--> cancel previous timer if exists
	if (ff.TimeoutTimer) then
		ff.TimeoutTimer:Cancel()
	end
	
	--> create a new timer
	ff.TimeoutTimer = C_Timer.NewTimer (timeout, ff.GroupApplyTimeout)
	
	--> and set the time on the statusbar
	ff.ProgressBar:SetTimer (timeout)
end

function ff.GroupApplyTimeout()
	--> clear the timer
	ff.TimeoutTimer = nil
	
	--> found a group? if not need to create a new one
	if (not IsInGroup() and not LFGListInviteDialog:IsShown()) then
	
		--> need to check if there is applycations
		local activeApplications = C_LFGList.GetNumApplications()
		
		if (activeApplies and activeApplies > 0) then
			--> need to undo applications apply before create a new group
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_UNAPPLY, L["S_GROUPFINDER_ACTIONS_CANCEL_APPLICATIONS"])
		else
			--> request an action
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_CREATE)
		end

		--> and shutdown the group checker
		--ff.SetCheckIfIsInGroup (false)
	else
		--> found group, good to go
		if (IsInGroup()) then
			ff.IsInWQGroup = true
			ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
		else
			ff.QueueGroupUpdate = true
		end
		
		--> hide the main frame
		ff.HideMainFrame()
	end
end

function ff.LeaveTimerTimeout()
	--> clear the timer
	interactionButton.LeaveTimer = nil
	
	--> if is leave after time
	if (WorldQuestTracker.db.profile.groupfinder.autoleave_delayed) then
		if (IsInGroup()) then
			LeaveParty()
		end
	end
	
	--> hide the main frame
	ff.HideMainFrame()
end

--
	--quando a lideran� passa para o jogador vindo de um player que estava offline
	--muitas vezes nao esta acontecendo nadad ao tentar crita um grupo
--

function ff.GetItemLevelRequirement()
	local isInArgus = WorldQuestTracker.IsArgusZone (WorldQuestTracker.GetCurrentMapAreaID())
	if (isInArgus) then
		return WorldQuestTracker.db.profile.groupfinder.argus_min_itemlevel
	end
	return 0
end

function ff.SetAction (actionID, message, ...)

	--> show the frame
	ff.ShowMainFrame()
	ff.ProgressBar:Hide()
	ff.HideSecondaryInteractionButton()
	
	ff.Label3:Show()
	
	--> reset the button state
	ff.ClearInteractionButtonActions()

	--> deal with each request action
	if (actionID == ff.actions.ACTIONTYPE_GROUP_SEARCH) then
		interactionButton.ToSearch = true
		ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_SEARCH"])
		
		ff.ShowSecondaryInteractionButton (ff.actions.ACTIONTYPE_GROUP_CREATE, L["S_GROUPFINDER_ACTIONS_CREATE_DIRECT"])
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_SEARCHING) then
		ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_SEARCHING"])
		ff.ProgressBar:SetTimer (1.6)
		ff.ProgressBar:Show()
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_UNAPPLY) then
		interactionButton.ToUnapply = true
		ff.SetCurrentActionText (message or L["S_GROUPFINDER_ACTIONS_UNAPPLY1"])
		ff.ShowSecondaryInteractionButton (ff.actions.ACTIONTYPE_GROUP_SEARCH, L["S_GROUPFINDER_ACTIONS_RETRYSEARCH"])
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_CREATE) then
		interactionButton.ToCreate = true
		ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_CREATE"])
		ff.ShowSecondaryInteractionButton (ff.actions.ACTIONTYPE_GROUP_SEARCH, L["S_GROUPFINDER_ACTIONS_RETRYSEARCH"])
		--ff.Label3:Hide()
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_UNLIST) then
		interactionButton.ToUnlist = true
		ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_UNLIST"])
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_RELIST) then
		interactionButton.ToCreate = true
		ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_SEARCHMORE"])
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_APPLY) then
		interactionButton.ToApply = true
		ff.SetCurrentActionText (message)
		ff.ProgressBar:Show()
		
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_LEAVE) then
		interactionButton.ToLeave = true
		
		if (WorldQuestTracker.db.profile.groupfinder.autoleave_delayed) then
			ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_LEAVINGIN"])
			
		elseif (WorldQuestTracker.db.profile.groupfinder.askleave_delayed) then
			ff.SetCurrentActionText (L["S_GROUPFINDER_ACTIONS_LEAVEASK"])
		end
		
		ff.ProgressBar:SetTimer (WorldQuestTracker.db.profile.groupfinder.leavetimer)
		if (interactionButton.LeaveTimer) then
			interactionButton.LeaveTimer:Cancel()
		end
		interactionButton.LeaveTimer = C_Timer.NewTimer (WorldQuestTracker.db.profile.groupfinder.leavetimer, ff.LeaveTimerTimeout)
		ff.ProgressBar:Show()
		ff.SetCheckIfIsInGroup (true)
	
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_KICK) then
		ff.SetCurrentActionText (message)
		interactionButton.ToKick = true
		local UnitID, GUID = ...
		ff.KickTargetUnitID = UnitID
		ff.KickTargetGUID = GUID
		interactionButton.ToKick = true
	
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_WAIT) then
		ff.SetCurrentActionText (message or L["S_GROUPFINDER_ACTIONS_WAITING"])
		interactionButton.ToApply = nil
		local waitTime, callBack = ...
		if (waitTime) then
			ff.ProgressBar:SetTimer (waitTime)
			if (callBack) then
				C_Timer.After (waitTime, callBack)
			end
		end
		ff.ProgressBar:Show()
	
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_SEARCHCUSTOM) then
		ff.SetCurrentActionText (message)
		interactionButton.ToSearchCustom = true
		ff.SearchCustom = true
		ff.ShowSecondaryInteractionButton (ff.actions.ACTIONTYPE_GROUP_CREATE, L["S_GROUPFINDER_ACTIONS_CREATE_DIRECT"])
	
	elseif (actionID == ff.actions.ACTIONTYPE_GROUP_SEARCHANOTHER) then
		ff.SetCurrentActionText (message or L["S_GROUPFINDER_ACTIONS_SEARCHOTHER"])
		interactionButton.ToSearchAnother = true

	end
end

function ff.OnBBlockButtonPress (self, button)
	if (self.questID) then
		WorldQuestTracker.FindGroupForQuest (self.questID, true)
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
	button:SetFrameStrata ("HIGH")
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
	ff.HideMainFrame()
	--> leave the group
	if (IsInGroup()) then
		if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
			LeaveParty()
		else
			--> show timer to leave the group
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_LEAVE)
		end
	end
	
	--> shutdown ontick script
	ff.ShutdownOnTickScript (true)
end

function ff.WorldQuestFinished (questID, fromCustomSeearch)
	if (interactionButton.HadInteraction) then
		if (fromCustomSearch) then
			ff.GroupDone()
		else
			if (interactionButton.questID == questID) then
				ff.GroupDone()
			end
		end
	end
end

function ff.SetQuestTitle (questName)
	ff.Label1.text = questName
end

function ff.SetCurrentActionText (actionText)
	ff.Label2.text = actionText
end

function ff.ResetMembers()
	ff.IsInWQGroup = false
	ff.GroupMembers = 0
end

function ff.ResetInteractionButton()
	ff.ClearInteractionButtonActions()
	
	interactionButton.questName = ""
	interactionButton.questID = 0
	
	if (interactionButton.LeaveTimer) then
		interactionButton.LeaveTimer:Cancel()
	end
	
	ff.HideSecondaryInteractionButton()
end

function ff.OnTick (self, deltaTime)
	if (ff.CheckIfInGroup) then
		if (IsInGroup()) then
			ff.HideMainFrame()
			ff.SetCheckIfIsInGroup (false)
		end
	end
	
	if (not ff.SearchCustom) then
	
		if (ff.CheckCurrentQuestArea) then
			ff.CheckCurrentQuestArea_Timer = ff.CheckCurrentQuestArea_Timer + deltaTime
			
			if (ff.CheckCurrentQuestArea_Timer > 2) then
				local isInArea, isOnMap, numObjectives = GetTaskInfo (interactionButton.questID)
				if (not isInArea) then
					ff.SetCheckIfIsInArea (false)
					ff.HideMainFrame()
				end
				ff.CheckCurrentQuestArea_Timer = 0
			end
		end

		if (ff.CheckForAFKs) then
			ff.CheckForAFKs_Timer = ff.CheckForAFKs_Timer + deltaTime
			
			if (ff.CheckForAFKs_Timer > 5) then
				--> check if we are in the quest and not in raid, just to make sure
				local isInArea, isOnMap, numObjectives = GetTaskInfo (interactionButton.questID)
				if (isInArea and not IsInRaid()) then
					--> do the check
					local mySelf = UnitGUID ("player")
					local selfX, selfY = UnitPosition ("player")
					
					for i = 1, GetNumGroupMembers() do
						local GUID = UnitGUID ("party" .. i)
						if (GUID and GUID ~= mySelf) then
							local unitTable = ff.AFKCheckList [GUID]
							if (not unitTable) then
								ff.AFKCheckList [GUID] = {
									tick = 0,
									name = UnitName ("party" .. i),
									x = 0,
									y = 0,
									faraway = 0,
								}
								unitTable = ff.AFKCheckList [GUID]
							end
							
							local mapPosition = C_Map.GetPlayerMapPosition (WorldQuestTracker.GetCurrentStandingMapAreaID(), "party" .. i) or {}
							local x, y = mapPosition.x, mapPosition.y
							x = x or 0
							y = y or 0
							
							--> check location for afk
							if (x ~= unitTable.x or y ~= unitTable.y or UnitHealth ("party" .. i) < UnitHealthMax ("party" .. i)) then
								unitTable.tick = 0
								unitTable.x = x
								unitTable.y = y
							else
								unitTable.tick = unitTable.tick + 1
								if (unitTable.tick > WorldQuestTracker.db.profile.groupfinder.noafk_ticks) then
									--print ("[debug] found a afk player, not moving or taking damage for 30 seconds", UnitName ("party" .. i))
									ff.SetAction (ff.actions.ACTIONTYPE_GROUP_KICK, "click to kick an AFK player", "party" .. i, GUID)
									break
								end
							end
							
							--> check location for distance
							if (selfX and selfX ~= 0 and DF.GetDistance_Point) then
								local distance = DF:GetDistance_Point (selfX, selfY, x, y)
								if (distance > WorldQuestTracker.db.profile.groupfinder.noafk_distance) then
									unitTable.faraway = unitTable.faraway + 1
									if (unitTable.faraway > WorldQuestTracker.db.profile.groupfinder.noafk_ticks) then
										--print ("[debug] found a player too far away, sqrt > 500 yards:", distance, UnitName ("party" .. i))
										ff.SetAction (ff.actions.ACTIONTYPE_GROUP_KICK, "click to kick an AFK player", "party" .. i, GUID)
										unitTable.faraway = 0
										break
									end
								else
									unitTable.faraway = 0
								end
							end
						end
					end
				end
				
				ff.CheckForAFKs_Timer = 0
			end
		end
	end
end

function ff.ShutdownOnTickScript (force)
	if (force) then
		ff.CheckIfInGroup = nil
		ff.CheckCurrentQuestArea = nil
		ff.CheckForAFKs = nil
		ff.TickFrame:SetScript ("OnUpdate", nil)
		return
	end
	if (	not ff.CheckIfInGroup and 
		not ff.CheckCurrentQuestArea and 
		not ff.CheckForAFKs
	) then
		ff.TickFrame:SetScript ("OnUpdate", nil)
	end
end

function ff.SetCheckIfIsInGroup (state)
	if (state) then
		ff.CheckIfInGroup = true
		ff.TickFrame:SetScript ("OnUpdate", ff.OnTick)
	else
		ff.CheckIfInGroup = nil
		ff.ShutdownOnTickScript()
	end
end

function ff.SetCheckIfIsInArea (state)
	if (state) then
		ff.CheckCurrentQuestArea = true
		ff.TickFrame:SetScript ("OnUpdate", ff.OnTick)
		ff.CheckCurrentQuestArea_Timer = 0
	else
		ff.CheckCurrentQuestArea = nil
		ff.ShutdownOnTickScript()
	end
end

function ff.SetCheckIfTrackingAFKs (state)
	if (state) then
		ff.CheckForAFKs = true
		ff.CheckForAFKs_Timer = 0
		ff.TickFrame:SetScript ("OnUpdate", ff.OnTick)
	else
		ff.CheckForAFKs = nil
		ff.ShutdownOnTickScript()
	end
end

function ff.ClearInteractionButtonActions()
	interactionButton.ToApply = nil
	interactionButton.ToCreate = nil
	interactionButton.ToSearch = nil
	interactionButton.ToLeave = nil
	interactionButton.ToUnlist = nil
	interactionButton.ToUnapply = nil
	interactionButton.ToKick = nil
	interactionButton.ToSearchAnother = nil
	interactionButton.ToSearchCustom = nil
	
end

function ff.IsPVPRealm (desc)
	if (desc:find ("@PVP") or desc:find ("#PVP")) then
		return true
	end
end

function ff.SearchCompleted() --~searchfinished
	--C_LFGList.GetSearchResultInfo (applicationID)
	
	--ff.ProgressBar:Hide()
	
	local active, activityID, iLevel, name, comment, voiceChat, expiration, autoAccept = C_LFGList.GetActiveEntryInfo()
	if (active) then
		--> the player group is listing, need request to get out
		--> we can do this automatically, but is best request an interaction
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_UNLIST)
		return
	end
	
	ff.ClearInteractionButtonActions()
	
	local numResults, resultIDTable = C_LFGList.GetSearchResults()
	interactionButton.GroupsToApply = interactionButton.GroupsToApply or {}
	wipe (interactionButton.GroupsToApply)
	interactionButton.GroupsToApply.n = 1
	
	local t = {}
	
	for index, resultID in pairs (resultIDTable) do
		--no filters but, pve players shouldn't queue on pvp servers?
		
		local id, activityID, name, desc, voiceChat, ilvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, members, isAuto = C_LFGList.GetSearchResultInfo (resultID)
		
		--print (members) --is always an int?
		--print ("resultado:", name, interactionButton.questName)
		
		if (isAuto and not isDelisted and ilvl <= GetAverageItemLevel()) then -- and members < 5 -- and name == interactionButton.questName
			local isPVP = ff.IsPVPRealm (desc)
			if (not WorldQuestTracker.db.profile.groupfinder.nopvp) then
				tinsert (t, {resultID, (numBNetFriends or 0) + (numCharFriends or 0) + (numGuildMates or 0), members or 0, isPVP and 0 or 1})
			else
				if (not isPVP) then
					tinsert (t, {resultID, (numBNetFriends or 0) + (numCharFriends or 0) + (numGuildMates or 0), members or 0, isPVP and 0 or 1})
				end
			end
		end
		
		--ApplyToGroup(resultID, comment, tankOK, healerOK, damageOK)
		--print (index, resultID)
		--C_LFGList.ApplyToGroup (resultID, "WorldQuestTrackerInvite-" .. self.questName, UnitGetAvailableRoles ("player"))
	end
	
	table.sort (t,  function(t1, t2) return t1[3] > t2[3] end) --more people first
	table.sort (t,  function(t1, t2) return t1[2] > t2[2] end) --more friends first
	table.sort (t,  function(t1, t2) return t1[4] > t2[4] end) --pvp status first
	
	for i = 1, #t do
		tinsert (interactionButton.GroupsToApply, t[i][1])
	end
	
	if (#interactionButton.GroupsToApply > 0) then
		local amt = #interactionButton.GroupsToApply
		if (amt > 1) then
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_APPLY, format (L["S_GROUPFINDER_RESULTS_FOUND"], #interactionButton.GroupsToApply))
		else
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_APPLY, L["S_GROUPFINDER_RESULTS_FOUND1"])
		end
		
		interactionButton.ApplyLeft = #interactionButton.GroupsToApply
	else
		--> no group found
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_CREATE)
		if (ff.SearchCallback) then
			ff.SearchCallback ("NO_GROUP_FOUND")
		end
	end
end

function ff.CheckValidClick (self, button)
	if (button == "RightButton") then
		ff.HideMainFrame()
		return
	end
	
	if (GetLFGMode (1) or GetLFGMode (3)) then --dungeon and raid finder
		print ("nop, you are in queue...")
		print ("World Quest Tracker: ", L["S_GROUPFINDER_QUEUEBUSY"])
		ff.HideMainFrame()
		return
	end
	
	for i = 1, 5 do --bg / wont work with ashran
		local status, mapName, teamSize, registeredMatch, suspendedQueue, queueType, gameType, role = GetBattlefieldStatus (i)
		if (queueType and status ~= "none") then
			print ("World Quest Tracker: ", L["S_GROUPFINDER_QUEUEBUSY"])
			ff.HideMainFrame()
			return
		end
	end
	
	if (not self.ToSearch and not self.ToUnlist and not self.ToLeave and not self.ToCreate and not self.ToApply and not self.ToKick and not self.ToUnapply and not self.ToSearchAnother and not self.ToSearchCustom) then
		--print ("No actions scheduled!")
		return
	end
	
	return true
end

ff.NameCache = {}
ff.NameCacheLatestUpdate = 0

function ff.RareFound_FromSearchGroups (npcId, leaderName)
	--> can add rares from group finder?
	if (not WorldQuestTracker.db.profile.rarescan.add_from_premade) then
		return
	end
	
	--> this rare is unreliable
	local rareName = WorldQuestTracker.MapData.RaresENNames [npcId]
	if (rareName) then
		local zoneID = WorldQuestTracker.MapData.ENRareNameToZoneID [rareName]
		if (zoneID) then
			rf.RareSpotted (leaderName, "GROUPFINDER", rareName, "Creature-0-0000-0000-00000-" .. npcId .. "-0000000000", zoneID, 0, 0, false, time(), true)
		end
	end
end

function ff.ParsePremadeSearchGroups()
	
	if (ff.NameCacheLatestUpdate+30 < time()) then
		--> names from all languages discovered
		for name, npcId in pairs (WorldQuestTracker.db.profile.rarescan.name_cache) do
			ff.NameCache [name:lower()] = npcId
		end
		--> only universal english names
		for npcId, name in pairs (WorldQuestTracker.MapData.RaresENNames) do
			ff.NameCache [name] = npcId
		end
		ff.NameCacheLatestUpdate = time()
	end
	
	local numResults, resultIDTable = C_LFGList.GetSearchResults()
	local foundRares, foundAmount = {}, 0
	
	for index, resultID in pairs (resultIDTable) do
		local id, activityID, name, desc, voiceChat, ilvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, members, isAuto = C_LFGList.GetSearchResultInfo (resultID)
		
		if (ff.NameCache [name:lower()]) then
			local npcId = ff.NameCache [name:lower()]
			if (not foundRares [npcId]) then
				ff.RareFound_FromSearchGroups (npcId, leaderName)
				foundRares [npcId] = true
				foundAmount = foundAmount + 1
			end
		else
			--> format used by world quest tracker
			local npcId = desc:match ("#NPCID%x%x%x%x%x%x")
			if (npcId) then
				npcId = npcId:gsub ("#NPCID", "")
				npcId = tonumber (npcId)
				if (npcId) then
					if (rf.RaresToScan [npcId]) then
						--> rare up
						if (not foundRares [npcId]) then
							ff.RareFound_FromSearchGroups (npcId, leaderName)
							foundRares [npcId] = true
							foundAmount = foundAmount + 1
						end
						
						--> learn the rare name on different languages
						local rareName = desc:match ("#LOC%s.+%s")
						if (rareName) then
							rareName = rareName:gsub ("#LOC ", "")
							if (rareName) then
								rareName = WorldQuestTracker:trim (rareName)
								if (rareName) then
									WorldQuestTracker.db.profile.rarescan.name_cache [rareName] = npcId
								end
							end
						end
					end
				end
			else
				--> format used by handynotes_argus
				local npcId = desc:match ("##rare%x%x%x%x%x%x")
				if (npcId) then
					npcId = tonumber (npcId:gsub ("##rare", ""))
					if (npcId) then
						if (rf.RaresToScan [npcId]) then
							--> rare up
							if (not foundRares [npcId]) then
								ff.RareFound_FromSearchGroups (npcId, leaderName)
								foundRares [npcId] = true
								foundAmount = foundAmount + 1
							end
						end
					end
				end
			end
		end
	end
	
	WorldQuestTracker.Debug ("ParsePremadeSearchGroups () > found " .. foundAmount .. " rares.")
	
	if (WorldQuestTracker.db.profile.rarescan.autosearch_share) then
		--> check if a timer already exists
		if (rf.ShareRaresTimer_Guild and not rf.ShareRaresTimer_Guild._cancelled) then
			return
		end
		--> schedule to share those new rares in the guild
		rf.ShareRaresTimer_Guild = C_Timer.NewTimer (20, rf.SendRareList)
	end
end

--> make a bridge with addons that search the premade groups for rares
--> so when the user search we can show the desired rare location on the map
--> also use these searches to discover rare names in other languages
hooksecurefunc (C_LFGList, "Search", function (where, terms)
	if (not WorldQuestTracker.db.profile.rarescan.add_from_premade) then
		return
	end
	
	if (ff.LatestSearch and ff.LatestSearch+3 > GetTime()) then
		return
	end
	if (where == 6 and type (terms) == "table" and #terms == 0) then
		C_Timer.After (2, ff.ParsePremadeSearchGroups)
	end
end)

function ff.StartSearchForCustom()
	local terms = LFGListSearchPanel_ParseSearchTerms (interactionButton.questName)
	ff.LatestSearch = GetTime()
	C_LFGList.Search (6, terms) --ignora os filtros
	C_Timer.After (1.6, ff.SearchCompleted)
end

function ff.StartSearch()
	ff.LatestSearch = GetTime()
	C_LFGList.Search (1, LFGListSearchPanel_ParseSearchTerms (interactionButton.questName)) --ignora os filtros
	C_Timer.After (1.6, ff.SearchCompleted)
end

function ff.CreateNewListing (questID, questName, AddToDesc)
	local pvpType = GetZonePVPInfo()
	local pvpTag
	if (pvpType == "contested") then
		pvpTag = "#PVP"
	else
		pvpTag = ""
	end

	local groupDesc
	if (questID == 0) then
		groupDesc = (ff.SearchCustomGroupDesc or "") .. "#ID" .. questID .. pvpTag
	else
		groupDesc = "Doing world quest " .. questName .. ". Group created with World Quest Tracker. #ID" .. questID .. pvpTag .. (AddToDesc or "")
	end

	local itemLevelRequired = ff.MinItemLevel or 0
	local honorLevelRequired = 0
	local isAutoAccept = true
	local isPrivate = false
	
	if (questID == 0) then
		C_LFGList.CreateListing (16, questName, itemLevelRequired, honorLevelRequired, "", groupDesc, isAutoAccept, isPrivate)
	else
		C_LFGList.CreateListing (C_LFGList.GetActivityIDForQuestID (questID) or 469, "", itemLevelRequired, honorLevelRequired, "", groupDesc, isAutoAccept, isPrivate, questID)
	end
	
	--> if is an epic quest, converto to raid
	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
	if (rarity == LE_WORLD_QUEST_QUALITY_EPIC) then -- or questID == 0
		--converto to raid if the quest is a world boss
		C_Timer.After (2, function() ConvertToRaid(); end)
	end
	
	local mapFileName = GetMapInfo()
	if (mapFileName and mapFileName:find ("InvasionPoint")) then
		--converto to raid if the group is for an invasion point
		C_Timer.After (2, function() ConvertToRaid(); end)
	end

	ff.IsInWQGroup = true
	ff.GroupMembers = 1
	
	ff.HideMainFrame()
end

secondaryInteractionButton:SetScript ("OnClick", function (self, button)
	--> is a valid click?
	if (not ff.CheckValidClick (self, button)) then
		return
	end
	
	--> disable the main interaction button, the actions below should set the new state
	ff.ClearInteractionButtonActions()
	
	--> hide the secondary button
	ff.HideSecondaryInteractionButton()
	
	--> parse the action
	if (self.ToSearch) then
		if (not ff.SearchCustom) then
			ff.StartSearch()
		else
			ff.StartSearchForCustom()
		end
		
		self.ToSearch = nil
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHING)
		
	elseif (self.ToCreate) then
		self.ToCreate = nil
		interactionButton.ToSearch = nil
		interactionButton.HadInteraction = true
		ff.CreateNewListing (interactionButton.questID, interactionButton.questName)
	end
end)

interactionButton:SetScript ("OnClick", function (self, button)

	if (not ff.CheckValidClick (self, button)) then
		return
	end
	
--		print ("Search", self.ToSearch, "Unlist", self.ToUnlist, "Leave", self.ToLeave, "Create", self.ToCreate, "Apply", self.ToApply, "Kick", self.ToKick, "UnApply", self.ToUnapply)
	
	if (self.ToSearch) then
		ff.StartSearch()
		interactionButton.ToSearch = nil
		self.HadInteraction = true
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHING)

	elseif (self.ToSearchAnother) then
		--> get the current leader, so we don't apply to the same group again
		for i = 1, GetNumGroupMembers() do 
			if (UnitIsGroupLeader ("party" .. i)) then
				ff.PreviousLeader = UnitName ("party" .. i)
				break
			end
		end
		--> leave the group
		ff.IsInWQGroup = false
		LeaveParty()
		ff.StartSearch()
		self.ToSearchAnother = nil
		self.HadInteraction = true
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHING)
	
	elseif (self.ToSearchCustom) then
		ff.StartSearchForCustom()
		interactionButton.ToSearchCustom = nil
		self.HadInteraction = true
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHING)
	
	elseif (self.ToUnlist) then
		C_LFGList.RemoveListing()
		--> call search completed once it can only enter on Unlist state from there
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_WAIT, L["S_GROUPFINDER_ACTIONS_UNLISTING"], 1.2, ff.SearchCompleted)
		self.ToUnlist = nil
	
	elseif (self.ToKick) then
		local GUID = UnitGUID (ff.KickTargetUnitID)
		if (GUID and ff.KickTargetGUID == GUID) then
			UninviteUnit (ff.KickTargetUnitID)
		end
		ff.HideMainFrame()
		self.ToKick = nil
	
	elseif (self.ToLeave) then
		LeaveParty()
		ff.HideMainFrame()
		ff.ResetInteractionButton()
		ff.ShutdownOnTickScript (true)
		return
	
	elseif (self.ToUnapply) then
		
		local numApplications = C_LFGList.GetNumApplications() --Returns the number of groups the player has applied for.
		local applications = C_LFGList.GetApplications() --Returns a table with the groups the player has applied for
		--groupID, status, unknown, timeRemaining, role = C_LFGList.GetApplicationInfo(groupID)

		if (numApplications > 0) then
			local groupID, status, unknown, timeRemaining, role = C_LFGList.GetApplicationInfo (applications [numApplications])
			if (status == "invited") then
				C_LFGList.DeclineInvite (applications [numApplications])
			else
				C_LFGList.CancelApplication (applications [numApplications])
			end
		end
		
		if (numApplications == 1) then
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_WAIT, L["S_GROUPFINDER_ACTIONS_CANCELING"], 1, ff.GroupApplyTimeout)
			self.ToUnapply = nil
		else
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_UNAPPLY, format (L["S_GROUPFINDER_RESULTS_UNAPPLY"], numApplications-1))
		end
		
		self.HadInteraction = true
		
	elseif (self.ToCreate) then
		local questID = self.questID
		local questName = self.questName
		
		ff.CreateNewListing (questID, questName)
		
		self.ToCreate = nil
		self.HadInteraction = true

	elseif (self.ToApply) then	
		self.HadInteraction = true
		
		local id, activityID, name, desc, voiceChat, ilvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, leaderName, members, isAuto = C_LFGList.GetSearchResultInfo (interactionButton.GroupsToApply [interactionButton.GroupsToApply.n])
		local isPreviousLeader = ff.PreviousLeader and ((ff.PreviousLeader == leaderName) or (leaderName:find (ff.PreviousLeader)))
		
		if (isAuto and not isDelisted and ilvl <= GetAverageItemLevel() and not isPreviousLeader) then -- and members < 5 --name == interactionButton.questName and
			--print ("Applying:", interactionButton.GroupsToApply [interactionButton.GroupsToApply.n], "WorldQuestTrackerInvite-" .. self.questName, UnitGetAvailableRoles ("player"))

			--Usage: ApplyToGroup(resultID, comment, tankOK, healerOK, damageOK)
			local id, name, description, icon, role, primaryStat = GetSpecializationInfo (GetSpecialization())

			C_LFGList.ApplyToGroup (interactionButton.GroupsToApply [interactionButton.GroupsToApply.n], "WQTInvite-" .. self.questName, role == "TANK", role == "HEALER", role == "DAMAGER")
			--print (interactionButton.GroupsToApply.n, interactionButton.GroupsToApply [interactionButton.GroupsToApply.n], role == "TANK", role == "HEALER", role == "DAMAGER")
			
			--> set the timeout
			ff.SetApplyTimeout (4)
			
			interactionButton.ApplyLeft = interactionButton.ApplyLeft - 1
			if (interactionButton.ApplyLeft > 0) then
				if (interactionButton.ApplyLeft > 1) then
					ff.SetAction (ff.actions.ACTIONTYPE_GROUP_APPLY, format (L["S_GROUPFINDER_RESULTS_APPLYING"], interactionButton.ApplyLeft))
				else
					ff.SetAction (ff.actions.ACTIONTYPE_GROUP_APPLY, L["S_GROUPFINDER_RESULTS_APPLYING1"])
				end
			else
				ff.SetAction (ff.actions.ACTIONTYPE_GROUP_WAIT)
			end
			
			ff.SetCheckIfIsInGroup (true)
			
		end
		
		interactionButton.GroupsToApply.n = interactionButton.GroupsToApply.n + 1
		
		if (interactionButton.GroupsToApply.n > #interactionButton.GroupsToApply) then
		
			if (true) then --debug
--					self.ToApply = nil
--					ff.SetAction (ff.actions.ACTIONTYPE_GROUP_UNAPPLY, "click to cancel applications...")
--					return
			end
		
			ff.SetApplyTimeout (4)
			ff.SetAction (ff.actions.ACTIONTYPE_GROUP_WAIT)
			return
		end
	end
end)

function WorldQuestTracker.FindGroupForQuest (questID, fromOTButton)
	local itemLevelRequired = ff.GetItemLevelRequirement()
	ff.FindGroupForQuest (questID, fromOTButton, nil, nil, nil, nil, itemLevelRequired)
end

function WorldQuestTracker.FindGroupForCustom (searchString, customTitle, customDesc, customGroupDescription, minItemLevel, callback)
	ff.FindGroupForQuest (searchString, nil, true, customTitle, customDesc, customGroupDescription, minItemLevel, callback)
end

function ff.FindGroupForQuest (questID, fromOTButton, isSearchOnCustom, customTitle, customDesc, customGroupDescription, minItemLevel, callback)
	--> reset the search type
	ff.SearchCustom = nil
	ff.SearchCustomGroupDesc = nil
	ff.SearchCallback = nil
	ff.MinItemLevel = nil
	
	if (callback) then
		ff.SearchCallback = callback
	end
	
	if (minItemLevel) then
		ff.MinItemLevel = minItemLevel
	end
	
	if (isSearchOnCustom) then
		ff.NewWorldQuestEngaged (nil, nil, questID, customTitle, customDesc, customGroupDescription)
		return
	end

	if (fromOTButton and IsInGroup() and ff.IsInWQGroup) then
		--> player already doing the quest
		ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCHANOTHER)
		return
	end
	
	if ((not IsInGroup() and not IsInRaid()) or (IsInGroup() and GetNumGroupMembers() == 1) or (IsInGroup() and not IsInRaid() and not ff.IsInWQGroup)) then --> causou problemas de ? - precisa de um aviso case esteja em grupo
		local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
		if (not ff.cannot_group_quest [worldQuestType] and not WorldQuestTracker.MapData.GroupFinderIgnoreQuestList [questID]) then
			ff.NewWorldQuestEngaged (title, questID)
		end
	end
end

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

function ff.DelayedCheckForDisband()
	--> everyone from player group could be gone, check if the quest is valid and if still  doing it
	if (interactionButton.questID) then
		local isInArea, isOnMap, numObjectives = GetTaskInfo (interactionButton.questID)
		if (isInArea and not IsQuestFlaggedCompleted (interactionButton.questID)) then
			--> just to make sure there's no group listed on the group finder
			--> it should be false since the player isn't in group
			local active, activityID, iLevel, name, comment, voiceChat, expiration, autoAccept = C_LFGList.GetActiveEntryInfo()
			if (not active) then
				--> everything at this point should be already set
				--> just query the player if want another group
				ff.SetAction (ff.actions.ACTIONTYPE_GROUP_SEARCH)
				return
			end
		end
	end
	
	local mapFileName = GetMapInfo()
	if (not mapFileName) then
		C_Timer.After (3, WorldQuestTracker.IsInvasionPoint)
	else
		WorldQuestTracker.IsInvasionPoint()
	end
end

ff:SetScript ("OnShow", function (self)
	if (WorldQuestTracker.db.profile.groupfinder.tutorial == 0) then
		local alert = CreateFrame ("frame", "WorldQuestTrackerGroupFinderTutorialAlert1", ff, "MicroButtonAlertTemplate")
		alert:SetFrameLevel (302)
		alert.label = L["S_GROUPFINDER_TUTORIAL1"]
		alert.Text:SetSpacing (4)
		MicroButtonAlert_SetText (alert, alert.label)
		alert:SetPoint ("topleft", ff, "topleft", 10, 110)
		alert.CloseButton:HookScript ("OnClick", function()
			
		end)
		alert:Show()
		WorldQuestTracker.db.profile.groupfinder.tutorial = WorldQuestTracker.db.profile.groupfinder.tutorial + 1
	end
end)

ff:SetScript ("OnEvent", function (self, event, arg1, questID, arg3)

	--> ~disabled
	if (true) then
		return
	end

	--is this feature enable?
	if (not WorldQuestTracker.db.profile.groupfinder.enabled) then
		return
	end
	
	if (event == "QUEST_ACCEPTED") then
		--> get quest data
		local isInArea, isOnMap, numObjectives = GetTaskInfo (questID)
		local title, factionID, capped = C_TaskQuest.GetQuestInfoByQuestID (questID)
		
		-->  do the regular checks
		if (isInArea and HaveQuestData (questID)) then
			local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
			if (isWorldQuest) then
				--FlashClientIcon()
				WorldQuestTracker.FindGroupForQuest (questID)
			end
		end 
	
	elseif (event == "QUEST_TURNED_IN") then
		questID = arg1
		local isWorldQuest = QuestMapFrame_IsQuestWorldQuest (questID)
		--print ("quest finished", questID, "is world:", isWorldQuest, "is last:", interactionButton.questID == questID)
		if (isWorldQuest) then
			ff.WorldQuestFinished (questID)
		end
	
	elseif (event == "LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS" or event == "GROUP_INVITE_CONFIRMATION") then
		--> hide annoying alerts
		if (ff.IsInWQGroup) then
			StaticPopup_Hide ("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
			StaticPopup_Hide ("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			StaticPopup_Hide ("GROUP_INVITE_CONFIRMATION")
			--print ("popup ignored")
		end
		--for d,_ in pairs(StaticPopupDialogs)do if (StaticPopup_FindVisible(d)) then print (d) end end
	
	elseif (event == "GROUP_ROSTER_UPDATE") then
		--> is in a world quest group
		if (ff.IsInWQGroup) then
			--> player left the group
			if (not IsInGroup()) then
				ff.IsInWQGroup = false
				ff.PreviousLeader = nil
				C_Timer.After (2, ff.DelayedCheckForDisband)
			else
				--> check if lost a member
				if (ff.GroupMembers > GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1) then
					--> is the leader?
					if (UnitIsGroupLeader ("player")) then
						--> is the player still doing this quest?
						local isInArea, isOnMap, numObjectives = GetTaskInfo (interactionButton.questID)
						if (isInArea) then
							--> is the quest not completed?
							if (not IsQuestFlaggedCompleted (interactionButton.questID)) then
								--> is the group not listed?
								local active, activityID, iLevel, name, comment, voiceChat, expiration, autoAccept = C_LFGList.GetActiveEntryInfo()
								if (not active) then
									ff.SetAction (ff.actions.ACTIONTYPE_GROUP_RELIST)
								end
							end
						end
					end
				end
				
				if (UnitIsGroupLeader ("player") and not ff.HasLeadership) then
					ff.HasLeadership = true
					if (WorldQuestTracker.db.profile.groupfinder.noafk) then
						ff.SetCheckIfTrackingAFKs (true)
					end
					
				elseif (ff.HasLeadership and not UnitIsGroupLeader ("player")) then
					ff.HasLeadership = false
					ff.SetCheckIfTrackingAFKs (false)
				end
				
				ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
				
				--> tell the rare finder the group has been modified
				rf.ScheduleGroupShareRares()
			end
		else
			if (ff.QueueGroupUpdate) then
				ff.QueueGroupUpdate = nil
				
				if (IsInGroup()) then
					ff.IsInWQGroup = true
					ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
					
					--> player entered in a group
					
				end
			end
		end
	end
end)

