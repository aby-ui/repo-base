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
local C_TaskQuest = _G.C_TaskQuest
local isWorldQuest = QuestUtils_IsQuestWorldQuest
local GetNumQuestLogRewardCurrencies = _G.GetNumQuestLogRewardCurrencies
local GetQuestLogRewardInfo = _G.GetQuestLogRewardInfo
local GetQuestLogRewardCurrencyInfo = _G.GetQuestLogRewardCurrencyInfo
local GetQuestLogRewardMoney = _G.GetQuestLogRewardMoney
local GetNumQuestLogRewards = _G.GetNumQuestLogRewards
local GetQuestInfoByQuestID = C_TaskQuest.GetQuestInfoByQuestID

local MapRangeClamped = DF.MapRangeClamped
local FindLookAtRotation = DF.FindLookAtRotation
local GetDistance_Point = DF.GetDistance_Point

--create tick frame
	ff.TickFrame = CreateFrame("frame", nil, UIParent, "BackdropTemplate")

--finder frame setup
	ff.Width = 240
	ff.Height = 116
	ff.ButtonWidth = 236
	ff.ButtonHeight = 20
	ff.ButtonVerticalPadding = 4
	ff.TitleHeight = 20 + (ff.ButtonVerticalPadding*2)
	ff.divBarY = -55
	ff.topLevelY = -28
	ff.buttonRowY = -8 --from the div bar

	ff:SetSize(ff.Width, ff.Height)
	DF:ApplyStandardBackdrop(ff)
	ff:SetPoint("center")
	ff:EnableMouse (true)
	ff:SetMovable (true)
	ff:Hide()

	ff.lastToggleRequest = 0

	hooksecurefunc("PVEFrame_ToggleFrame", function()
		if (ff.lastToggleRequest == time()) then
			--the call came from world quest tracker it self
			return
		else
			ff.lastToggleRequest = time()
		end

		local isFFShown = ff:IsShown()
		--if FF isn't shown, make sure to restore the alpha
		--even if this is a hide call
		if (not isFFShown) then
			PVEFrame:SetAlpha(1)
			return
		end

		--player pressed to show/hide the group finder interface
		local isPVEFrameShown = PVEFrame:IsShown()
		local PVEFrameAlpha = PVEFrame:GetAlpha()

		if (isFFShown and PVEFrameAlpha == 0 and not isPVEFrameShown) then
			--player pressed to show group finder, but is was just with zero alpha due to FF being Shown
			--here need to show again the group finder and adjust its alpha to 1
			PVEFrame_ToggleFrame()
			PVEFrame:SetAlpha(1)
			return
		end
	end)

	--right click to close label
		ff.RightClickClose = DF:CreateLabel (ff, L["right click to close this window"])
		ff.RightClickClose:SetPoint("bottom", ff, "bottom", 0, 2)
		ff.RightClickClose.color = "gray"

		ff:SetScript("OnMouseDown", function(self, button)
			if (button == "RightButton") then
				ff:HideFrame(true)
			end
		end)

	--captcha text input
		function ff.OnCaptchaEnterPressed(textEntryBox, _, text)
			--print("text entered:", text)
		end

		local captchaTextInstruction = ff:CreateFontString(nil, "overlay", "GameFontNormal")
		captchaTextInstruction:SetText("For group search, enter questId:")
		--captchaTextInstruction:SetPoint("topleft", ff, "topleft", 2, -26)
		captchaTextInstruction:SetPoint("topleft", ff, "topleft", 2, ff.divBarY - 7)
		DF:SetFontSize(captchaTextInstruction, 10)

		local captchaText = ff:CreateFontString(nil, "overlay", "GameFontNormal")
		captchaText:SetPoint("topleft", captchaTextInstruction, "bottomleft", 0, -5)
		DF:SetFontSize(captchaText, 18)
		ff.CaptchaText = captchaText

		local captchaEntry = DF:CreateTextEntry (ff, ff.OnCaptchaEnterPressed, 80, 22, "CaptchaEntry", "$parentCaptchaEntry", nil, DF:GetTemplate("button", "OPTIONS_BUTTON_TEMPLATE"))
		captchaEntry:SetPoint("left", captchaText, "right", 8, 0)
		captchaEntry:SetJustifyH("left")
		captchaEntry:SetTextInsets(10, -10, 0, 0)

		captchaEntry:SetHook("OnEnterPressed", function(editBox)
			_G.WorldQuestTrackerFinderFrameAcceptButton:Click()
		end)

		captchaEntry:SetHook("OnChar", function(editBox)

		end)

		--create group button
		local createGroupFrame = CreateFrame("frame", "WorldQuestTrackerCreateQuestGroupFrame", UIParent)
		createGroupFrame:Hide()
		createGroupFrame:SetSize(200, 20)
		createGroupFrame.questName = createGroupFrame:CreateFontString(nil, "overlay", "GameFontNormal")

		--create small lines for each number
		local supportCaptchaFrame = CreateFrame("frame", nil, captchaEntry.widget)
		supportCaptchaFrame:SetAllPoints()
		for i = 1, 5 do
			local line = supportCaptchaFrame:CreateTexture(nil, "overlay", nil, 7)
			line:SetColorTexture(1, 1, 1, 0.5)
			line:SetSize(10, 1)
			line:SetPoint("left", supportCaptchaFrame, "left", i*12, -8)
		end

		supportCaptchaFrame:SetScript("OnEvent", function(self, event, ...)
			if (event == "LFG_LIST_SEARCH_RESULT_UPDATED") then
				--search results are ready
				supportCaptchaFrame.searchId = select(1, ...)
				--print(supportCaptchaFrame.searchId)
				--local searchResultInfo = C_LFGList.GetSearchResultInfo(supportCaptchaFrame.searchId);

			elseif (event == "LFG_LIST_SEARCH_RESULTS_RECEIVED") then
				local results = LFGListFrame.SearchPanel.results
				--no results?
				if (results and #results == 0) then
					--show the create group button if in quest category
					local selectedCategory = LFGListFrame.SearchPanel.categoryID
					if (selectedCategory ~= 1) then
						return
					end

					createGroupFrame:SetParent(LFGListFrame.SearchPanel)
					if LFGListSearchPanelScrollFrame then
						createGroupFrame:SetPoint("top", LFGListSearchPanelScrollFrame.StartGroupButton, "bottom", 0, -5)
					end
					createGroupFrame:Show()

				else
					createGroupFrame:Hide()
				end
			end
		end)

		--hook search result lines to auto signup when clicking on them
		C_Timer.After(1, function()
			--hook onclick from buttons in the result frame
			--LFGListFrame.SearchPanel.ScrollFrame doesn't exist in dragonflight
			--[=[
			for i = 1, #LFGListFrame.SearchPanel.ScrollFrame.buttons do
				local button = LFGListFrame.SearchPanel.ScrollFrame.buttons[i]
				button:HookScript("OnClick", function(self, button)

					if (button == "RightButton") then
						return
					end

					--if already applied to a group, reclicking should cancel the apply
					--check if the entry is valid
					if (LFGListFrame.SearchPanel.selectedResult) then
						_G.LFGListSearchPanel_SignUp(LFGListFrame.SearchPanel)

						--this should only work on questing and custom, player may want to select the role on other categories
						local selectedCategory = LFGListFrame.SearchPanel.categoryID
						if (selectedCategory ~= 1) then
							return
						end

						--checking the boxes make them be saved for the next time player uses it
	--						_G.LFGListApplicationDialog.TankButton.CheckButton:SetChecked(true)
	--						_G.LFGListApplicationDialog.HealerButton.CheckButton:SetChecked(true)
	--						_G.LFGListApplicationDialog.DamagerButton.CheckButton:SetChecked(true)
						--_G.LFGListApplicationDialog.Description:SetText("World Quest Tracker.") - causing an error

						_G.LFGListApplicationDialogSignUpButton_OnClick(_G.LFGListApplicationDialog.SignUpButton)
					end
				end)
			end
			--]=]

			--hook onclick from the start group button
			--LFGListSearchPanelScrollFrameScrollChild doesn't exists in dragonflight
			--[=[
			LFGListSearchPanelScrollFrameScrollChild.StartGroupButton:HookScript("OnClick", function(self)
				--only work for category quest
				local selectedCategory = LFGListFrame.SearchPanel.categoryID
				if (selectedCategory ~= 1 and selectedCategory ~= 6) then
					return
				end
			end)
			--]=]
		end)

		--hiddenSearchButton
		ff.hiddenSearchButton = CreateFrame("button", "$parentHiddenSearchButton", ff, "BackdropTemplate")
		ff.hiddenSearchButton:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		ff.hiddenSearchButton:SetScript("OnClick", function(self, mouseButton)
			if (mouseButton == "RightButton") then
				ff:HideFrame(true)
				return
			end

			ff.WasLFGWindowOpened = _G.PVEFrame:IsShown()

			if (not ff.WasLFGWindowOpened) then
				ff.lastToggleRequest = time()
				_G.PVEFrame_ToggleFrame()
			end

			_G.LFGListUtil_OpenBestWindow()
			_G.LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 1, 0)

			--make the quest
			LFGListFrame.CategorySelection.FindGroupButton:Click()

			--literally take the search box from the group finder window and put it in the wqt window
			local stolenSearchBox = LFGListFrame.SearchPanel.SearchBox
			stolenSearchBox:ClearAllPoints()
			stolenSearchBox:SetPoint("left", captchaText, "right", 10, 0)
			stolenSearchBox:SetIgnoreParentAlpha(true)
			_G.PVEFrame:SetAlpha(0)
			stolenSearchBox:SetFrameLevel(captchaEntry:GetFrameLevel() + 2)
			stolenSearchBox:Show()
			stolenSearchBox:SetFocus(true)
			stolenSearchBox:SetAlpha(0)

			ff.hiddenSearchButton.fakeInputMarkTexture:SetPoint("left", captchaEntry.widget, "left", 12, 0)
			ff.hiddenSearchButton.fakeInputMarkAnim:Play()
		end)

		ff.hiddenSearchButton:SetPoint("topleft", captchaEntry.widget, "topleft", -100, 10)
		ff.hiddenSearchButton:SetPoint("bottomright", captchaEntry.widget, "bottomright", 235, -10)
		ff.hiddenSearchButton:SetFrameLevel(captchaEntry:GetFrameLevel() + 1)

		local fakeInputMark = ff.hiddenSearchButton:CreateTexture(nil, "overlay", nil, 7)
		fakeInputMark:SetColorTexture(1, 1, 1, 1)
		fakeInputMark:SetSize(2, 18)
		fakeInputMark.animHub = DF:CreateAnimationHub(fakeInputMark, function()fakeInputMark:Show();fakeInputMark:SetAlpha(1)end, function()fakeInputMark:Hide();fakeInputMark:SetAlpha(1)end)
		fakeInputMark.animHub:SetLooping("REPEAT")
		ff.hiddenSearchButton.fakeInputMarkTexture = fakeInputMark
		ff.hiddenSearchButton.fakeInputMarkAnim = fakeInputMark.animHub

		fakeInputMark.Alpha1 = DF:CreateAnimation(fakeInputMark.animHub, "ALPHA", 1, 0, 0, 1)
		fakeInputMark.Alpha1:SetEndDelay(0.55)
		fakeInputMark.Alpha2 = DF:CreateAnimation(fakeInputMark.animHub, "ALPHA", 2, 0, 1, 0)
		fakeInputMark.Alpha2:SetEndDelay(0.55)

		local givebackStolenSearchBox = function()
			--restore search box point
			local stolenSearchBox = LFGListFrame.SearchPanel.SearchBox
			stolenSearchBox:ClearAllPoints()
			stolenSearchBox:SetPoint("topleft", LFGListFrame.SearchPanel.CategoryName, "bottomleft", 4, -7)

			stolenSearchBox:ClearFocus()
			stolenSearchBox:SetIgnoreParentAlpha(false)
			stolenSearchBox:SetAlpha(1)
		end

		local restoreFrames = function()
			--restore search box point
			givebackStolenSearchBox()

			ff.hiddenSearchButton.fakeInputMarkAnim:Stop()
			ff.hiddenSearchButton.fakeInputMarkTexture:Hide()

			if (_G.PVEFrame:IsShown() and _G.PVEFrame:GetAlpha() > .9) then
				--already shown, the user might have requested to open it, all good!
				return
			end

			_G.PVEFrame:SetAlpha(1)

			if (ff.WasLFGWindowOpened) then
				if (not _G.PVEFrame:IsShown()) then
					ff.lastToggleRequest = time()
					_G.PVEFrame_ToggleFrame()
				end

			elseif (_G.PVEFrame:IsShown()) then
				ff.lastToggleRequest = time()
				_G.PVEFrame_ToggleFrame()
			end
		end

		do
			local stolenSearchBox = LFGListFrame.SearchPanel.SearchBox

			stolenSearchBox:HookScript("OnTextChanged", function(self)
				local text = self:GetText()
				captchaEntry:SetText(text)
				ff.hiddenSearchButton.fakeInputMarkTexture:SetPoint("left", captchaEntry.widget, "left", 12 + (#text * 12), 0)
			end)

			stolenSearchBox:HookScript("OnEditFocusLost", function(self)
				if (ff:IsShown()) then
					ff.hiddenSearchButton.fakeInputMarkAnim:Stop()
					ff.hiddenSearchButton.fakeInputMarkTexture:Hide()
				end
			end)

			stolenSearchBox:HookScript("OnEditFocusGained", function(self)
				if (ff:IsShown()) then
					ff.hiddenSearchButton.fakeInputMarkAnim:Play()
					ff.hiddenSearchButton.fakeInputMarkTexture:Show()
				end
			end)

			stolenSearchBox:HookScript("OnEnterPressed", function(self)
				if (ff:IsShown()) then
					ff.EnterPressedTime = GetTime()
					_G.PVEFrame:SetAlpha(1)
					givebackStolenSearchBox()
					ff.SearchTime = GetTime()
				end
			end)

			ff:SetScript("OnShow", function()
				ff.hiddenSearchButton:Show()
				ff.GroupButtonsFrame:Show()
				ff.GroupButtonsFrame:SetPoint("top", ff, "top", 0, ff.topLevelY)

				ff.leaveButtonSolo:Hide()

				local children = {ff.GroupButtonsFrame:GetChildren()}
				local firstChild = children[1]
				firstChild:SetPoint("left", ff.GroupButtonsFrame, "left", 0, 0)
				local padding = 2

				for i = 2, #children do
					local child = children[i]
					child:SetPoint("left", children[i-1], "right", padding, 0)
				end

				local width = #children * firstChild:GetWidth() + ((#children-2) * padding)
				ff.GroupButtonsFrame:SetSize(width, firstChild:GetHeight())
			end)

			ff:SetScript("OnHide", function()
				ff.hiddenSearchButton:Hide()
				restoreFrames()
			end)

			--LFGListSearchPanelScrollFrameScrollChild isn't present on dragonflight
			--start group OnClick hook

			--[=[
			LFGListSearchPanelScrollFrameScrollChild.StartGroupButton:HookScript("OnClick", function()
				--hide the ff
				ff.WasLFGWindowOpened = true
				ff:Hide()

				C_Timer.After(0.05, function()
					if (not LFGListFrame.EntryCreation.Name.Instructions2) then
						LFGListFrame.EntryCreation.Name.Instructions2 = WorldQuestTracker:CreateLabel(LFGListFrame.EntryCreation.Name)
						LFGListFrame.EntryCreation.Name.Instructions2:SetPoint("right", -21, 0)
						LFGListFrame.EntryCreation.Name.Instructions2.color = "gray"
						LFGListFrame.EntryCreation.Name.Instructions2.alpha = 0.3
						LFGListFrame.EntryCreation.Name.Instructions2.align = ">"

						LFGListFrame.SearchPanel.SearchBox.Instructions2 = WorldQuestTracker:CreateLabel (LFGListFrame.SearchPanel.SearchBox)
						LFGListFrame.SearchPanel.SearchBox.Instructions2:SetPoint("right", -21, 0)
						LFGListFrame.SearchPanel.SearchBox.Instructions2.color = "gray"
						LFGListFrame.SearchPanel.SearchBox.Instructions2.alpha = 0.3
						LFGListFrame.SearchPanel.SearchBox.Instructions2.align = ">"

						--ballon popup
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon = CreateFrame("frame", "WorldQuestTrackerGroupFinderPopup", LFGListFrame.EntryCreation.Name, "MicroButtonAlertTemplate_BFA")
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetFrameLevel(2000)
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.Text:SetSpacing(4)
						DF:SetFontSize(LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.Text, 20)
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetPoint("bottomleft", LFGListFrame.SearchPanel.SearchBox, "topleft", 0, 20)

						LFGListFrame.EntryCreation.Name:HookScript("OnEnterPressed", function()
							LFGListFrame.EntryCreation.ListGroupButton:Click()
						end)

						LFGListFrame.EntryCreation.Name:HookScript("OnHide", function()
							LFGListFrame.EntryCreation.Name.Instructions2.text = ""
							LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Hide()
						end)
					end

					if (ff.SearchTime and ff.SearchTime+30 > GetTime()) then
						LFGListFrame.EntryCreation.Name.Instructions2.text = "Enter questID: " .. ff.CurrentWorldQuest
						LFGListFrame.EntryCreation.Name.Instructions:SetText("")

						LFGListFrame.SearchPanel.SearchBox.Instructions:SetText("")
						LFGListFrame.SearchPanel.SearchBox:SetFocus(true)

						LFGListFrame.SearchPanel.SearchBox.Instructions2.text = "Enter questID: " .. ff.CurrentWorldQuest
						ff.SearchTime = GetTime()

						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.label = ff.CurrentWorldQuest
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.Text:SetText(LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon.label)
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:SetPoint("bottomleft", LFGListFrame.EntryCreation.Name, "topleft", 0, 20)
						LFGListFrame.SearchPanel.SearchBox.QuestIDBalloon:Show()
					end
				end)
			end)
			--]=]
		end

		supportCaptchaFrame:RegisterEvent("LFG_LIST_SEARCH_RESULT_UPDATED")
		supportCaptchaFrame:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")

		--search for a group in group finder button, create with bliz api
		local acceptButton = CreateFrame("button", "$parentAcceptButton", ff, "BackdropTemplate")
		acceptButton:SetSize(80, 22)
		acceptButton:SetPoint("left", supportCaptchaFrame, "right", 5, 0)
		acceptButton:SetFrameStrata("HIGH")
		acceptButton:SetFrameLevel(LFGListFrame.SearchPanel.SearchBox:GetFrameLevel() + 5)
		DF:ApplyStandardBackdrop(acceptButton)
		acceptButton:SetNormalFontObject("GameFontNormal")
		acceptButton:SetText(_G.SEARCH)

		acceptButton:SetScript("OnClick", function(self, button)
			local captcha = tonumber(captchaEntry:GetText())
			if (captcha == ff.CurrentWorldQuest) then
				LFGListFrame.CategorySelection.FindGroupButton:Click()
				_G.PVEFrame:SetAlpha(1)
				givebackStolenSearchBox()
				ff.SearchTime = GetTime()
			else
				captchaEntry:SetTextColor(1, .2, 0, 1)
				C_Timer.After(0.15, function() captchaEntry:SetTextColor(1, 1, 1, 1) end)
				C_Timer.After(0.3, function() captchaEntry:SetTextColor(1, .2, 0, 1) end)
				C_Timer.After(0.45, function() captchaEntry:SetTextColor(1, 1, 1, 1) end)
				C_Timer.After(0.6, function() captchaEntry:SetTextColor(1, .2, 0, 1) end)
				C_Timer.After(0.75, function() captchaEntry:SetTextColor(1, 1, 1, 1) end)
			end
		end)

		do
			local file, size, flags = captchaEntry:GetFont()
			captchaEntry:SetFont (file, 18, flags)
		end

	--create a divisor
	ff.divbar = ff:CreateTexture(nil, "overlay")
	ff.divbar:SetTexture([[Interface\QUESTFRAME\AutoQuest-Parts]])
	ff.divbar:SetTexCoord(238/512, 445/512, 0/64, 4/64)
	ff.divbar:SetHeight(3)
	ff.divbar:SetDesaturated(true)
	ff.divbar:SetAlpha(0.5)
	ff.divbar:SetVertexColor(0.5, 0.5, 0.5, 1)
	ff.divbar:SetPoint("topleft", ff, "topleft", 3, ff.divBarY)
	ff.divbar:SetPoint("topright", ff, "topright", -3, ff.divBarY)

	ff.overlayCaptcha = CreateFrame("frame", nil, ff, "BackdropTemplate")
	ff.overlayCaptcha:SetPoint("topleft", ff.divbar, "topleft", -2, 0)
	ff.overlayCaptcha:SetPoint("bottomright", ff, "bottomright", 0, 0)
	ff.overlayCaptcha:SetFrameStrata("DIALOG")
	ff.overlayCaptcha:SetBackdrop({bgFile = [[Interface\ACHIEVEMENTFRAME\UI-GuildAchievement-Parchment-Horizontal-Desaturated]], tileSize = 64, tile = true})
	ff.overlayCaptcha:SetBackdropColor(0, 0, 0, 1)
	ff.overlayCaptcha:EnableMouse(true)
	ff.overlayCaptcha:Hide(true)

	--row with buttons
	ff.GroupButtonsFrame = CreateFrame("frame", nil, ff)

	--button settings
	local groupButtonOnEnter = function(self)
		if (not self.tooltip or self.tooltip == "") then
			return
		end

		GameCooltip:Preset(2)
		GameCooltip:AddLine(self.tooltip)
		GameCooltip:ShowCooltip(self)
	end

	local groupButtonOnLeave = function(self)
		GameCooltip:Hide()
	end
	local setupGroupButton = function(button, index, iconTexture, iconTexCoord, func, tooltip)
		local buttonIndex = index
		local width = 40 * 0.9
		local height = 25 * 0.9

		button:SetSize(width, height)
		DF:ApplyStandardBackdrop(button)

		local icon = button:CreateTexture(nil, "artwork", nil, 2)
		icon:SetPoint("center", 0, 0)
		icon:SetSize(width-2, height-2)
		icon:SetTexture(iconTexture)
		icon:SetDesaturated(true)
		if (iconTexCoord) then
			icon:SetTexCoord(unpack(iconTexCoord))
		end

		button:SetScript("OnClick", func)
		if (tooltip) then
			button:SetScript("OnEnter", groupButtonOnEnter)
			button:SetScript("OnLeave", groupButtonOnLeave)
			button.tooltip = tooltip
		end

		local highlight = button:CreateTexture(nil, "highlight")
		highlight:SetColorTexture(1, 1, 1, .3)
		highlight:SetPoint("center", 0, 0)
		highlight:SetSize(width-2, height-2)
	end

	--invite nearby players
		local groupButtons_InviteNearbyPlayers = CreateFrame("button", "$parentInviteNearbyPlayersButton", ff.GroupButtonsFrame, "BackdropTemplate")
		local invitePlayersOnClick = function()
			GameCooltip:Hide()
			GameCooltip:ExecFunc(groupButtons_InviteNearbyPlayers)
		end
		local playerSelectedToInvite = function(self, fixedValue, value)
			GameCooltip2:Hide()
			ff.PlayersNearby [value] = nil
			ff.PlayersInvited [value] = true
			_G.C_PartyInfo.InviteUnit(value)

			C_Timer.After (0.006, function()
				GameCooltip:ExecFunc(groupButtons_InviteNearbyPlayers)
			end)
		end
		local buildInviteMenu = function()
			GameCooltip2:Preset(2)
			local playerName = next(ff.PlayersNearby)
			if (playerName) then
				local added = false

				for playerName, playerInfo in pairs(ff.PlayersNearby) do
					local spottedAt, guid = unpack(playerInfo)
					if (spottedAt + 20 > GetTime()) then
						local className, classId = GetPlayerInfoByGUID(guid)

						if (classId) then
							GameCooltip:AddLine(playerName, "", 1, classId)
						else
							GameCooltip:AddLine(playerName)
						end

						GameCooltip:AddMenu(1, playerSelectedToInvite, playerName)
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

		groupButtons_InviteNearbyPlayers.CoolTip = {
			Type = "menu",
			BuildFunc = buildInviteMenu,
			OnEnterFunc = function(self)
				groupButtons_InviteNearbyPlayers.button_mouse_over = true
			end,
			OnLeaveFunc = function(self)
				groupButtons_InviteNearbyPlayers.button_mouse_over = false
			end,
			FixedValue = "none",
			ShowSpeed = 0.006,
			Options = function()
				GameCooltip:SetOption("MyAnchor", "bottom")
				GameCooltip:SetOption("RelativeAnchor", "top")
				GameCooltip:SetOption("WidthAnchorMod", 0)
				GameCooltip:SetOption("HeightAnchorMod", 4)
				GameCooltip:SetOption("LineHeightSizeOffset", 4)
				GameCooltip:SetOption("VerticalPadding", -4)
				GameCooltip:SetOption("FrameHeightSizeOffset", -4)
			end
		}
		GameCooltip2:CoolTipInject (groupButtons_InviteNearbyPlayers)

		setupGroupButton(groupButtons_InviteNearbyPlayers, 1, [[Interface\FriendsFrame\PlusManz-PlusManz]], {0, 1, 11/64, 58/64}, function()
			invitePlayersOnClick()
		end)

	--open group finder window
		local groupButtons_OpenGroupFinder = CreateFrame("button", "$parentOpenGroupFinderButton", ff.GroupButtonsFrame, "BackdropTemplate")
		setupGroupButton(groupButtons_OpenGroupFinder, 2, [[Interface\Icons\Achievement_General_StayClassy]], {.10, .90, .20, .80}, function()
			restoreFrames()

			ff:HideFrame(true)

			if (not _G.PVEFrame:IsShown()) then
				ff.lastToggleRequest = time()
				_G.PVEFrame_ToggleFrame()
			end

			_G.LFGListUtil_OpenBestWindow()
			_G.LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 1, 0)
			_G.LFGListCategorySelection_StartFindGroup(LFGListFrame.CategorySelection, 0)
		end, "Open Premade Groups")

	--ignore quest
		local groupButtons_IgnoreQuest = CreateFrame("button", "$parentIgnoreQuestButton", ff.GroupButtonsFrame, "BackdropTemplate")
		setupGroupButton(groupButtons_IgnoreQuest, 3, [[Interface\COMMON\icon-noloot]], {0, 1, .1, .9}, function()
			DF:ShowPromptPanel ("Don't Show Popups for the Quest: " .. (ff.CurrentQuestName or "-") .. "?", function()
				if (ff.CurrentWorldQuest) then
					WorldQuestTracker.db.profile.groupfinder.ignored_quests [ff.CurrentWorldQuest] = true
					WorldQuestTracker:Msg ("Quest " .. (ff.CurrentQuestName or "-") .. " added to ignore list.")
				end
				ff:HideFrame (true)
			end, function() end)
		end, "Ignore this quest (won't popup next time)")

	--leave group
		local groupButtons_LeaveGroup = CreateFrame("button", "$parentLeaveGroupButton", ff.GroupButtonsFrame, "BackdropTemplate")
		setupGroupButton(groupButtons_LeaveGroup, 4, [[Interface\COMMON\CommonIcons]], {92/256, 137/256, 6/128, 36/128}, function()
			if (not IsInGroup()) then
				return
			end

			if (ff.QuestCompletedHidingTimer and not ff.QuestCompletedHidingTimer._cancelled) then
				ff.QuestCompletedHidingTimer:Cancel()

			elseif (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
				ff.QuestCancelledHidingTimer:Cancel()
			end

			ff:HideFrame(true)
			C_PartyInfo.LeaveParty()
		end, "Leave Group")

	--place holder
	--[=[
		local groupButtons_PlaceHolder = CreateFrame("button", "$parentPlaceHolderButton", ff, "BackdropTemplate")
		setupGroupButton(groupButtons_PlaceHolder, 5, [[Interface\Calendar\MeetingIcon]], nil, function()
			_G.PVEFrame_ToggleFrame()
			_G.LFGListUtil_OpenBestWindow()
			_G.LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 1, 0)
		end)
	--]=]


	--leave group big button
	local leaveButtonSolo = CreateFrame("button", "$parentLeaveButtonSolo", ff, "BackdropTemplate")
	DF:ApplyStandardBackdrop(leaveButtonSolo)
	leaveButtonSolo:SetPoint("top", ff, "top", 0, ff.topLevelY)
	leaveButtonSolo:Hide()
	ff.leaveButtonSolo = leaveButtonSolo
	leaveButtonSolo.text = leaveButtonSolo:CreateFontString(nil, "overlay", "GameFontNormal")
	leaveButtonSolo.text:SetPoint("center", 0, 0)
	leaveButtonSolo.text:SetText("Leave Group")

	--create a title bar
		DF:CreateTitleBar(ff, "Title")

	--create the options button
		ff.Options = CreateFrame ("button", "$parentTopRightOptionsButton", ff, "BackdropTemplate")
		ff.Options:SetPoint("right", ff.CloseButton, "left", -2, 0)
		ff.Options:SetSize(16, 16)
		ff.Options:SetNormalTexture ([[Interface\GossipFrame\BinderGossipIcon]])
		ff.Options:SetHighlightTexture ([[Interface\GossipFrame\BinderGossipIcon]])
		ff.Options:SetPushedTexture ([[Interface\GossipFrame\BinderGossipIcon]])
		ff.Options:GetNormalTexture():SetDesaturated (true)
		ff.Options:GetHighlightTexture():SetDesaturated (true)
		ff.Options:GetPushedTexture():SetDesaturated (true)
		ff.Options:SetAlpha(0.7)

		--require full load before run
		C_Timer.After(0.5, function()
			ff.Options.CoolTip = {
				Type = "menu",
				BuildFunc = ff.BuildOptionsMenuFunc,
				OnEnterFunc = function(self) end,
				OnLeaveFunc = function(self) end,
				FixedValue = "none",
				ShowSpeed = 0.05,
				Options = {
					["FixedWidth"] = 300,
				},
			}
			GameCooltip:CoolTipInject (ff.Options)

			--create the quest icon
			ff.QuestIcon = WorldQuestTracker.CreateZoneWidget(1, "GroupFinderIcon", ff)
			ff.QuestIcon:SetPoint("left", ff.TitleBar, "left", 2, 0)

			ff.QuestIcon.Animation = DF:CreateAnimationHub(ff.QuestIcon)
			DF:CreateAnimation(ff.QuestIcon.Animation, "scale", 1, 0.2, 1, 1, 1.2, 1.2)
			DF:CreateAnimation(ff.QuestIcon.Animation, "scale", 2, 0.2, 1.2, 1.2, 1, 1)
		end)

		--animations
			local onShowAnimationHub = DF:CreateAnimationHub (ff, function()ff:Show()end)
			DF:CreateAnimation (onShowAnimationHub, "ALPHA", 1, 1/14, 0, 1)
			ff.AnimationShow = onShowAnimationHub

			local onHideAnimationHub = DF:CreateAnimationHub (ff, function()end, function()ff:Hide()end)
			DF:CreateAnimation (onHideAnimationHub, "ALPHA", 1, 0.5, 1, 0)
			ff.AnimationHide = onHideAnimationHub


function WorldQuestTracker.RegisterGroupFinderFrameOnLibWindow()
	local LibWindow = LibStub("LibWindow-1.1")
	LibWindow.RegisterConfig(ff, WorldQuestTracker.db.profile.groupfinder.frame)
	LibWindow.MakeDraggable(ff)
	LibWindow.RestorePosition(ff)
	ff.IsRegistered = true

	function ff:ShowFrame()
		ff.AnimationHide:Stop()
		ff.AnimationShow:Play()
		ff.Options:Show()

		groupButtons_LeaveGroup:Disable()
		if (IsInGroup()) then
			groupButtons_LeaveGroup:Enable()
		else
			groupButtons_LeaveGroup:Disable()
		end
	end

	function ff:HideFrame (noAnimation)
		ff:SetScript("OnUpdate", nil)
		ff.AnimationShow:Stop()

		if (noAnimation) then
			ff:Hide()
		else
			ff.AnimationHide:Play()
		end
	end
end

--events
	ff:RegisterEvent ("QUEST_TURNED_IN")
	ff:RegisterEvent ("QUEST_ACCEPTED")
	ff:RegisterEvent ("QUEST_REMOVED")
	ff:RegisterEvent ("GROUP_ROSTER_UPDATE")
	ff:RegisterEvent ("GROUP_INVITE_CONFIRMATION")
	ff:RegisterEvent ("LFG_LIST_APPLICANT_LIST_UPDATED")
	ff:RegisterEvent ("ZONE_CHANGED_NEW_AREA")
	ff:RegisterEvent ("PLAYER_ENTERING_WORLD")
	ff:RegisterEvent ("PLAYER_LOGIN")

	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", function (_, _, msg)
		if (not WorldQuestTracker.db.profile.groupfinder.send_whispers) then
			if (msg:find ("World Quest Tracker")) then
				if (msg:find ("Invite for World Quest")) then
					return true
				end
			end
		end
	end)

local playerEnteredWorldQuestZone = function(questID, npcID, npcName)

	if (true) then
		--return
	end

	if (ff.buttonAcquired) then
		ff.buttonAcquired:Hide()
		QuestObjectiveFindGroup_ReleaseButton(ff.buttonAcquired)
		ff.buttonAcquired = nil
	end

	ff.overlayCaptcha:Hide()

	--> update the frame
	local title, isNpc, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex
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
		groupButtons_OpenGroupFinder:Enable()
		groupButtons_IgnoreQuest:Enable()

		if (not IsInGroup()) then
			groupButtons_LeaveGroup:Disable()
		else
			groupButtons_LeaveGroup:Enable()
		end

		ff:ShowFrame()

		if (type (questID) == "number") then
			title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)

			--print(tagID, worldQuestType, rarity, isElite) -- 136, 2, 1, true

			if (isElite) then
				groupButtons_OpenGroupFinder:Disable()
				C_Timer.After (3, function()
					groupButtons_OpenGroupFinder:Enable()
				end)
			end

			--print(tagID, tagName, worldQuestType , rarity , isElite)

			if ((tagID == 112 or tagID == 136) and worldQuestType == 2 and (rarity == 1 or rarity == 2) and isElite) then
				groupButtons_OpenGroupFinder:Disable()
				C_Timer.After(3, function()
					groupButtons_OpenGroupFinder:Enable()
				end)

				local findButton = QuestObjectiveFindGroup_AcquireButton(ff, questID)
				findButton:ClearAllPoints()
				findButton:SetPoint("center", ff, "center", 0, -28)
				findButton:SetSize(64, 64)
				findButton:SetFrameStrata("FULLSCREEN")
				findButton:Show()
				ff.overlayCaptcha:Show()

				--TODO > arrumar o auto hide to painel quando completar a quest
				--TODO > fechar o painel quando entrar em grupo
				--TODO > reabrir o painel se sair do grupo e ainda estiver na quest
				--TODO > não poder abrir o frame do LFG enquanto estiver em combate

				ff.buttonAcquired = findButton
			end
		end

		ff.CurrentQuestName = title

		ff:SetTitle(title)
		ff.QuestIcon.mapID = WorldQuestTracker.GetCurrentStandingMapAreaID()
		ff.QuestIcon.questID = questID
		ff.QuestIcon.numObjectives = 1
		ff.QuestIcon.questName = title
		ff.QuestIcon.Order = 1
		ff.QuestIcon.Currency_Gold = 0
		ff.QuestIcon.Currency_ArtifactPower = 0
		ff.QuestIcon.Currency_Resources = 0
		ff.QuestIcon.worldQuestType = worldQuestType
		ff.QuestIcon.rarity = rarity
		ff.QuestIcon.isElite = isElite
		ff.QuestIcon.tradeskillLineIndex = tradeskillLineIndex
		ff.QuestIcon.inProgress = false
		ff.QuestIcon.selected = false
		ff.QuestIcon.isSelected = false
		ff.QuestIcon.isCriteria = false
		ff.QuestIcon.isSpellTarget = false

		WorldQuestTracker.SetupWorldQuestButton(ff.QuestIcon, worldQuestType, rarity, isElite, tradeskillLineIndex)

		--update a second time
		C_Timer.After(1.5, function()
			WorldQuestTracker.SetupWorldQuestButton(ff.QuestIcon, worldQuestType, rarity, isElite, tradeskillLineIndex)

			ff.QuestIcon:SetParent(ff)
			ff.QuestIcon:SetPoint("left", ff.TitleBar, "left", 2, 0)
			ff.QuestIcon.AnchorFrame:SetParent(ff)
			ff.QuestIcon.AnchorFrame:SetPoint("left", ff.TitleBar, "left", 2, 0)
			ff.QuestIcon.flagText:SetText("")
			ff.QuestIcon.bgFlag:Hide()
			ff.QuestIcon.blackGradient:Hide()

			ff.QuestIcon.Animation:Play()
		end)

		ff.QuestIcon:SetParent(ff)
		ff.QuestIcon:SetPoint("left", ff.TitleBar, "left", 2, 0)
		ff.QuestIcon.AnchorFrame:SetParent(ff)
		ff.QuestIcon.AnchorFrame:SetPoint("left", ff.TitleBar, "left", 2, 0)
		ff.QuestIcon.flagText:SetText("")
		ff.QuestIcon.bgFlag:Hide()
		ff.QuestIcon.blackGradient:Hide()

		ff.CaptchaText:SetText(questID)
		ff.CaptchaEntry:SetText("")
		--ff.CaptchaEntry:SetText("59599") --debug

		wipe(ff.PlayersNearby)
		wipe(ff.PlayersInvited)

		ff:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

		--> check for active timers and disable them
		if (ff.QuestCompletedHidingTimer and not ff.QuestCompletedHidingTimer._cancelled) then
			ff.QuestCompletedHidingTimer:Cancel()
		end
		if (ff.QuestCancelledHidingTimer and not ff.QuestCancelledHidingTimer._cancelled) then
			ff.QuestCancelledHidingTimer:Cancel()
		end
	end
end

hooksecurefunc("QuestObjectiveSetupBlockButton_AddRightButton", function(block, groupFinderButton, buttonType)
	if (buttonType == "groupFinder") then
--		for a, b in pairs(block.TrackedQuest) do
--			print(a,b)
--		end
--		groupFinderButton

		local questID = block and block.TrackedQuest and block.TrackedQuest.questID
		if (questID) then
			local questName = C_TaskQuest.GetQuestInfoByQuestID(questID)
			if (questName) then
				C_Timer.After(0.5, function()
					if (ff:IsShown()) then
						if (ff.CurrentQuestName == questName) then
							--print("Hello!")
						end
					end
				end)
			end
		end
	end
end)

function ff:PlayerEnteredWorldQuestZone(questID, npcID, npcName)
	C_Timer.After(0.6, function()
		--delay the call for the enter zone
		playerEnteredWorldQuestZone(questID, npcID, npcName)
	end)
end

function ff:PlayerLeftWorldQuestZone (questID, questCompleted)
	--questCompleted is true when the zone left came from the quest completed event
	ff.IsInQuestZone = nil
	ff.IsInWQGroup = nil

	--stop auto invites if any
	ff:SetScript("OnUpdate", nil)

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
			groupButtons_OpenGroupFinder:Disable()
			groupButtons_IgnoreQuest:Disable()
			--> enable button
			groupButtons_LeaveGroup:Enable()

			--> show the frame if isn't shown
			if (not ff:IsShown()) then
				ff:ShowFrame()
			end

		elseif (not IsInGroup() and not isInInstance) then

			--> check if is in the group finder
			local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, questID = C_LFGList.GetActiveEntryInfo()

			if (active) then
				--> disable buttons
				groupButtons_OpenGroupFinder:Disable()
				groupButtons_IgnoreQuest:Disable()
				--> enable button
				groupButtons_LeaveGroup:Enable()

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

		ff.QuestCompletedHidingTimer = C_Timer.NewTimer(25, function()
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
	local numQuests = C_QuestLog.GetNumQuestLogEntries()

	if (questName) then
		for i = 1, numQuests do
			local questTitle = C_QuestLog.GetTitleForLogIndex(i)
			if (questName == questTitle) then
				isInQuest = true
			end
		end
	else
		for i = 1, numQuests do
			local questInfo = C_QuestLog.GetInfo(i)
			local thisQuestID = questInfo.questID

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

	local a = C_LFGList.GetActiveEntryInfo()
	if (not a) then
		return
	end
	local active, activityID, ilvl, honorLevel, name, comment, voiceChat, duration, autoAccept, privateGroup, questID = a.active, a.activityID, a.ilvl, a.honorLevel, a.name, a.comment, a.voiceChat, a.duration, a.autoAccept, a.privateGroup, a.questID
	--active = true --disabling to fix later

	--print ("player applyind:", active, ff.CurrentWorldQuest, UnitIsGroupLeader ("player"), name:find ("ks2|"), name:find ("k000000|"), name == ff.CurrentWorldQuest)
	--print (name, type (name))

	local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (ff.CurrentWorldQuest)
	local activityTable = C_LFGList.GetActivityInfoTable(activityID)

	local mapName, shortName, activityCategoryID, groupID, iLevel, filters, minLevel, maxPlayers, displayType = activityTable.fullName, activityTable.shortName, activityTable.categoryID, activityTable.groupFinderActivityGroupID, activityTable.ilvlSuggestion, activityTable.filters, activityTable.minLevel, activityTable.maxNumPlayers, activityTable.displayType

	local standingMapID = WorldQuestTracker.GetCurrentStandingMapAreaID()
	local playerStandingMapName = WorldQuestTracker.GetMapName (standingMapID)
	local activityID, categoryID, filters, questName = LFGListUtil_GetQuestCategoryData (ff.CurrentWorldQuest)

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
								C_PartyInfo.InviteUnit(name)
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

ff:SetScript("OnEvent", function (self, event, questID, arg2, arg3)

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

		local isInArea, isOnMap = GetTaskInfo(questID)

		-->  do the regular checks
		if ((isInArea or isOnMap) and HaveQuestData (questID)) then
			--get all quests from 8.3 assault stuff
			local allAssaultQuests = {}
			for _, questId in ipairs(C_TaskQuest.GetThreatQuests()) do
				--put all into a table where the hash is the key and true is the value
				allAssaultQuests [questId] = true
			end

			local tagInfo = C_QuestLog.GetQuestTagInfo(questID)
			if (not tagInfo) then
				if (WorldQuestTracker.__debug) then
					WorldQuestTracker:Msg("no tagInfo(1) for quest", questID)
				end
				return
			end
			local tagID = tagInfo.tagID
			local rarity = tagInfo.rarity or 1
			local isElite = tagInfo.isElite

			local isWorldQuest = isWorldQuest(questID)

			if ((isWorldQuest and isInArea) or allAssaultQuests[questID] or tagID == 112 or (isElite and rarity == LE_WORLD_QUEST_QUALITY_EPIC)) then
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
		else
			if (WorldQuestTracker.__debug and not HaveQuestData(questID)) then
				WorldQuestTracker:Msg("no HaveQuestData(2) for quest", questID)
			end
		end

	elseif (event == "ZONE_CHANGED_NEW_AREA") then
		local isInInstance = IsInInstance()
		if (isInInstance) then
			ff:HideFrame()
		end

	elseif (event == "QUEST_REMOVED") then
		if (questID == ff.CurrentWorldQuest) then

			ff.CurrentWorldQuest = nil
			ff:PlayerLeftWorldQuestZone (questID)
		end

	elseif (event == "QUEST_LOG_UPDATE") then



	elseif (event == "QUEST_TURNED_IN") then
		local isWorldQuest = isWorldQuest(questID)
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

				--check if the player is in a world quest zone
				--may popup the group finder again
				ff.CheckForQuestsInTheArea()
			else
				ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1
			end
		else
			if (IsInGroup()) then
				--player entered in a group
				ff.IsInWQGroup = true
				ff.GroupMembers = GetNumGroupMembers (LE_PARTY_CATEGORY_HOME) + 1

				if (ff.buttonAcquired) then
					ff:HideFrame(true)
				end
			end
		end

		if (IsInGroup()) then
			groupButtons_LeaveGroup:Enable()
		else
			groupButtons_LeaveGroup:Disable()
		end

	elseif (event == "GROUP_INVITE_CONFIRMATION") then
		--> hide annoying alerts
		if (ff.IsInWQGroup) then
			StaticPopup_Hide ("LFG_LIST_ENTRY_EXPIRED_TOO_MANY_PLAYERS")
			StaticPopup_Hide ("LFG_LIST_AUTO_ACCEPT_CONVERT_TO_RAID")
			StaticPopup_Hide ("GROUP_INVITE_CONFIRMATION")
		end

	elseif (event == "PLAYER_ENTERING_WORLD") then
		--> check if the player is in a quest location (big quests like invasions)
		if (not IsInGroup()) then
			--get invasion quests
			for _, questId in ipairs(C_TaskQuest.GetThreatQuests()) do
				--this invasion is active?
				if (C_TaskQuest.IsActive(questId)) then
					local isInArea, isOnMap = GetTaskInfo (questId)
					--the player is inside the zone of this invasion?
					if (isInArea and isOnMap) then
						ff.CurrentWorldQuest = questId
						ff:PlayerEnteredWorldQuestZone (questId)
					end
				end
			end
		end

		if (not ff.RegisteredApplicationViewerHook) then
			ff.RegisteredApplicationViewerHook = true

			if (UnitLevel("player") < 70) then
				return
			end

			C_Timer.After(3, function()
				if (not ff.PVEFrameHooked) then
					ff.PVEFrameHooked = true

					PVEFrame:HookScript("OnShow", function()
						if (not ff.ApplicationsHookCreated) then
							ff.ApplicationsHookCreated = true
							local eventFrame = CreateFrame("frame")
								LFGListFrame.ApplicationViewer.ScrollBox:HookScript("OnShow", function()

								eventFrame:RegisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
								eventFrame:SetScript("OnEvent", function()
									local scrollTartet = LFGListFrame.ApplicationViewer.ScrollBox.ScrollTarget
									local playerApplications = C_LFGList.GetApplicants()
									if (playerApplications and #playerApplications > 0) then
										for i = 1, #playerApplications do
											local appInfo = C_LFGList.GetApplicantInfo(playerApplications[i])
											if (appInfo and appInfo.applicationStatus == "applied") then

												local playerName, _, _, playerLevel = C_LFGList.GetApplicantMemberInfo(playerApplications[i], 1)
												if (playerLevel < 70) then
													local applicantNameWithoutRealm = strsplit("-", playerName)
													local applicantID = appInfo.applicantID

													local applicantFrames = {LFGListFrame.ApplicationViewer.ScrollBox.ScrollTarget:GetChildren()}
													for frameIndex, appFrame in ipairs(applicantFrames) do
														if (appFrame.Member1.Name:GetText() == applicantNameWithoutRealm) then
															appFrame.Member1.Name:SetText(applicantNameWithoutRealm .. "  |cFFFF0000[" .. playerLevel .. "]|r")
														end
													end
												end
											end
										end
									end
								end)
							end)
							LFGListFrame.ApplicationViewer.ScrollBox:HookScript("OnHide", function()
								eventFrame:UnregisterEvent("LFG_LIST_APPLICANT_LIST_UPDATED")
							end)
						end
					end)
				end
			end)
		end

	elseif (event == "PLAYER_LOGIN") then
		if (not IsInGroup()) then
			--attempt to get the quest the player is in at the login
			ff.CheckForQuestsInTheArea()
		end
	end
end)

function ff.CheckForQuestsInTheArea()
	local allQuestsInTheMap = C_TaskQuest.GetQuestsForPlayerByMapID(WorldQuestTracker.GetCurrentStandingMapAreaID())
	if (allQuestsInTheMap) then
		for index, questInfo in ipairs(allQuestsInTheMap) do
			local questId = questInfo.questId
			if(questInfo.inProgress) then
				--show world quest popup
				C_Timer.After(3, function()
					ff:GetScript("OnEvent")(ff, "QUEST_ACCEPTED", questId)
				end)
			end
		end
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
		--button:SetPoint("right", block.TrackedQuest, "left", -2, 0)
		button:SetPoint("topright", block, "topright", 11, -17)
	else
		--check if there's a quest button
		if (block.rightButton and block.rightButton:IsShown()) then
			button:SetPoint("right", block.rightButton, "left", -2, 0)
		else
			button:SetPoint("topright", block, "topright", 10, 0)
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
		button = CreateFrame ("button", nil, UIParent, "BackdropTemplate")
		button:SetFrameStrata ("FULLSCREEN")
		button:SetSize(30, 30)

		button:SetNormalTexture ([[Interface\BUTTONS\UI-SquareButton-Up]])
		button:SetPushedTexture ([[Interface\BUTTONS\UI-SquareButton-Down]])
		button:SetHighlightTexture ([[Interface\BUTTONS\UI-Common-MouseHilight]])

		local icon = button:CreateTexture(nil, "OVERLAY")
		icon:SetAtlas ("socialqueuing-icon-eye")
		icon:SetSize(13, 13)

		--icon:SetSize(22, 22)
		--icon:SetTexture([[Interface\FriendsFrame\PlusManz-PlusManz]])
		--icon:SetPoint("center", button, "center")

		icon:SetPoint("center", button, "center", -1, 0)

		button:SetScript("OnClick", ff.OnBBlockButtonPress)
		button:SetScript("OnEnter", ff.OnBBlockButtonEnter)
		button:SetScript("OnLeave", ff.OnBBlockButtonLeave)
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
		if (type (questID) == "number" and HaveQuestData (questID) and isWorldQuest(questID)) then
			local title, factionID, tagID, tagName, worldQuestType, rarity, isElite, tradeskillLineIndex = WorldQuestTracker.GetQuest_Info (questID)
			if (not ff.cannot_group_quest [worldQuestType] and not WorldQuestTracker.MapData.GroupFinderIgnoreQuestList [questID]) then
				--> give a button for this block
				ff.AddButtonToBBlock (block, questID)
			end
		end
	else
		local isInArea, isOnMap, numObjectives = GetTaskInfo (questID) -- or not isInArea
		if (type (questID) ~= "number" or not HaveQuestData (questID) or not isWorldQuest(questID)) then
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
			C_PartyInfo.LeaveParty()
		else
			ff:Show()
			C_Timer.After(.1, function()
				ff.GroupButtonsFrame:Hide()
				ff.leaveButtonSolo:Show()
			end)
		end
	end
end

function ff.WorldQuestFinished (questID, fromCustomSeearch)
	ff.GroupDone()
end


--options
	ff.SetEnabledFunc = function(_, _, value)
		WorldQuestTracker.db.profile.groupfinder.enabled = value
		GameCooltip:Hide()
	end

	ff.SetFindGroupForRares = function(_, _, value)
		WorldQuestTracker.db.profile.rarescan.search_group = value
		GameCooltip:Hide()
	end

	ff.SetOTButtonsFunc = function(_, _, value)
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

	ff.AlreadyInGroupFunc = function(_, _, value)
		WorldQuestTracker.db.profile.groupfinder.dont_open_in_group = value
		GameCooltip:Hide()
	end

	ff.SetAutoGroupLeaveFunc = function(_, _, value, key)
		WorldQuestTracker.db.profile.groupfinder.autoleave = false
		WorldQuestTracker.db.profile.groupfinder.autoleave_delayed = false
		WorldQuestTracker.db.profile.groupfinder.askleave_delayed = false
		WorldQuestTracker.db.profile.groupfinder.noleave = false

		WorldQuestTracker.db.profile.groupfinder [key] = true

		GameCooltip:Hide()
	end

	ff.SetGroupLeaveTimeoutFunc = function(_, _, value)
		WorldQuestTracker.db.profile.groupfinder.leavetimer = value
		if (WorldQuestTracker.db.profile.groupfinder.autoleave) then
			WorldQuestTracker.db.profile.groupfinder.autoleave = false
			WorldQuestTracker.db.profile.groupfinder.askleave_delayed = true
		end
		GameCooltip:Hide()
	end

	--build the option menu
	ff.BuildOptionsMenuFunc = function()
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

--> anti spam

local kspam = CreateFrame("frame")

function kspam.OnClickConfigButton()

	if (WorldQuestTrackerKspamOptionsFrame) then
		if (WorldQuestTrackerKspamOptionsFrame:IsShown()) then
			WorldQuestTrackerKspamOptionsFrame:Hide()
			return
		end

		WorldQuestTrackerKspamOptionsFrame:Show()
		return
	end

	local kspamOptions = WorldQuestTrackerKspamOptionsFrame or CreateFrame("frame", "WorldQuestTrackerKspamOptionsFrame", UIParent, "BackdropTemplate")
	kspamOptions:SetSize(250, 200)
	kspamOptions:SetPoint("center", UIParent, "center", 0, 0)
	kspamOptions:SetFrameStrata("FULLSCREEN")
	kspamOptions:SetMovable(true)
	kspamOptions:EnableMouse(true)
	kspamOptions:RegisterForDrag()

	--skin
	DF:ApplyStandardBackdrop(kspamOptions)

	--title
	kspamOptions.titleBar = DF:CreateTitleBar(kspamOptions, "World  Quest Tracker Ad-Blocker")

	local options = {
		--filter #ads (default enabled)
		{
			type = "toggle",
			get = function() return WorldQuestTracker.db.profile.groupfinder.kfilter.enabled end,
			set = function(self, fixedparam, value)
				WorldQuestTracker.db.profile.groupfinder.kfilter.enabled = value
			end,
			name = "Ad-Blocker Enabled",
			desc = "Ad-Blocker Enabled",
		},

		{type = "blank"},
		{
			type = "toggle",
			get = function() return WorldQuestTracker.db.profile.groupfinder.kfilter.dont_show_ignored_leaders end,
			set = function(self, fixedparam, value)
				WorldQuestTracker.db.profile.groupfinder.kfilter.dont_show_ignored_leaders = value
			end,
			name = "Don't Show Blacklisted Leaders",
			desc = "Won't show groups where the leader previously got caught doing an Ad.",
		},

		--purge list of banned leaders
		{
			type = "execute",
			func = function()
				table.wipe(WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored)
				--feedback
				WorldQuestTracker:Msg("Leaders list wiped.")
			end,
			name = "Wipe Blacklisted Leaders",
			desc = "Wipe Blacklisted Leaders",
		},

		{type = "blank"},

		--ignore group by time since the group creation
		{
			type = "range",
			get = function() return WorldQuestTracker.db.profile.groupfinder.kfilter.ignore_by_time end,
			set = function(self, fixedparam, value)
				WorldQuestTracker.db.profile.groupfinder.kfilter.ignore_by_time = value
			end,
			min = 1,
			max = 60,
			step = 1,
			name = "Time Limit in Minutes",
			desc = "Don't show groups where created time is bigger than 'X' minutes ago.",
		},

		{type = "blank"},

		--[=[]]
		{
			type = "toggle",
			get = function() return WorldQuestTracker.db.profile.groupfinder.kfilter.show_button end,
			set = function(self, fixedparam, value)
				WorldQuestTracker.db.profile.groupfinder.kfilter.show_button = value
			end,
			name = "Show Options Button",
			desc = "Show Options Button",
		},
		--]=]

	}

	local options_text_template = DF:GetTemplate ("font", "OPTIONS_FONT_TEMPLATE")
	local options_dropdown_template = DF:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE")
	local options_switch_template = DF:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE")
	local options_slider_template = DF:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE")
	local options_button_template = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

	DF:BuildMenu(kspamOptions, options, 5, -30, 360, true, options_text_template, options_dropdown_template, options_switch_template, true, options_slider_template, options_button_template)
end

local configButton = DF:CreateButton(LFGListFrame.SearchPanel, kspam.OnClickConfigButton, 70, 20, "options")
local options_button_template = DF.table.copy({}, DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE"))
options_button_template.backdropcolor = {.2, .2, .2, .6}
options_button_template.backdropbordercolor = {0, 0, 0, 1}
configButton:SetTemplate(options_button_template)
configButton:Hide()

if (UsePFGButton) then
	configButton:SetPoint("right", UsePFGButton, "left", -8, 0)
else
	configButton:SetPoint("right", LFGListFrame.SearchPanel.RefreshButton, "left", -5, 0)
end
configButton:Hide()

kspam:SetScript("OnUpdate", function()
	if (LFGListFrame:IsShown()) then
		local selectedCategory = LFGListFrame.SearchPanel.categoryID
		if (selectedCategory == 2 or selectedCategory == 3) then --dungeon | raid
			configButton:Show()
		else
			configButton:Hide()
		end
	end
end)

function kspam.OnSortResults(results)
	--check if the feature is enabled

	if true then return end

	if (not WorldQuestTracker.db.profile.groupfinder.kfilter.enabled) then
		return
	end

	--check if the result received is from the dungeon section
	local selectedCategory = LFGListFrame.SearchPanel.categoryID
	if (selectedCategory ~= 2 and selectedCategory ~= 3) then --dungeon | raid
		return
	end

	return kspam.FilterSortedResult(results)
end

function kspam.FilterSortedResult(results)

	if (WorldQuestTracker.db.profile.groupfinder.kfilter.wipe_counter == 0) then
		WorldQuestTracker.db.profile.groupfinder.kfilter.wipe_counter = WorldQuestTracker.db.profile.groupfinder.kfilter.wipe_counter + 1
		wipe(WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored)
	end

	local maxAge = WorldQuestTracker.db.profile.groupfinder.kfilter.ignore_by_time * 60

	for i = #results, 1, -1 do
		--get the result id
		local resultId = results[i]
		--get the search result info

		local searchResultInfo1 = C_LFGList.GetSearchResultInfo(resultId)

		--get the leader name
		local leaderName = searchResultInfo1.leaderName
		local leaderLevel = searchResultInfo1.leaderLevel

		local canAdd = true

		--cut immediatelly if the leader isn't at level 60
		if (leaderLevel and leaderLevel < 60) then
			tremove(results, i)
			canAdd = false
		end

		--check if this character isn't in the black list
		if (WorldQuestTracker.db.profile.groupfinder.kfilter.dont_show_ignored_leaders and WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[leaderName]) then
			tremove(results, i)
			canAdd = false
		end

		if (canAdd and searchResultInfo1 and not searchResultInfo1.isDelisted) then
			--cut by age (default 30 minutes)
			if (searchResultInfo1.age > maxAge) then
				canAdd = false
			end

			--elseif (searchResultInfo1.voiceChat ~= "") then
			--	canAdd = false
			--end

			--if this group is exposed more than two hours
			if (searchResultInfo1.age > maxAge+7200 and searchResultInfo1.leaderName) then
				if (WorldQuestTracker.db.profile.groupfinder.kfilter.ignore_leaders_enabled) then
					WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[searchResultInfo1.leaderName] = true
				end
				canAdd = false
			end

			if (not canAdd) then
				tremove(results, i)
				--if (searchResultInfo1.leaderName) then
					--if (WorldQuestTracker.db.profile.groupfinder.kfilter.ignore_leaders_enabled) then
					--	WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[searchResultInfo1.leaderName] = true
					--end
				--end
			end

			--[[ searchResultInfo1 members
				.name
				.autoAccept
				.age
				.comment
				.numGuildMates
				.leaderName
				.leaderLevel
				.activityID
				.numBNetFriends
				.numMembers
				.requiredItemLevel
				.searchResultID
				.voiceChat
				.requiredHonorLevel
				.isDelisted
				.numCharFriends
			--]]
		end
	end
end

hooksecurefunc("LFGListUtil_SortSearchResults", kspam.OnSortResults)

local onClickBanButton = function(banButton)
	local buttonObject =  banButton.MyObject
	local searchResultInfo = C_LFGList.GetSearchResultInfo(buttonObject.resultID)
	local leaderName = searchResultInfo.leaderName

	WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[leaderName] = true
	banButton:GetParent().isBanned = buttonObject.resultID
	banButton:GetParent().disabledOverlay:Show()

	banButton:Hide()
end

local allowedCache = {}

function kspam.OnUpdateButtonStatus(button)
	--get the result info
	local searchResultInfo = C_LFGList.GetSearchResultInfo(button.resultID)

	--is this result banned
	if (WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[searchResultInfo.leaderName]) then
		if (button.disabledOverlay) then
			button.disabledOverlay:Show()
			for _, texture in pairs(button.DataDisplay.Enumerate.Icons) do
				texture:Hide()
			end
		end

		if (button.banButton) then
			button.banButton.text = ""
		end
	else
		if (button.disabledOverlay) then
			button.disabledOverlay:Hide()
		end
	end

	local shouldShowBan = button.VoiceChat:IsShown()

	--check timer
	if (searchResultInfo.age > 420) then
		local tankAmount = tonumber(button.DataDisplay.RoleCount.TankCount:GetText())
		local healerAmount = tonumber(button.DataDisplay.RoleCount.HealerCount:GetText())
		local dpsAmount = tonumber(button.DataDisplay.RoleCount.DamagerCount:GetText())

		if (tankAmount and healerAmount and dpsAmount) then
			local playerAmount = tankAmount + healerAmount + dpsAmount
			if (playerAmount == 1) then
				shouldShowBan = true
			end
		end
	end

	--check if the voice icon is shown
	if (shouldShowBan) then
		local buttonAlpha = 0.7

		if ((allowedCache[searchResultInfo.leaderName] or 0) > 100) then
			if (button.banButton) then
				button.banButton:Hide()
			end
			return

		elseif ((allowedCache[searchResultInfo.leaderName] or 0) > 0) then
			buttonAlpha = buttonAlpha - (allowedCache[searchResultInfo.leaderName] * 0.007)
		end

		if (not button.banButton) then
			--create the ban button if not exists
			local alpha = 0.7
			button.banButton = DF:CreateButton(button, onClickBanButton, 36, 12, "Ban!", _, _, _, _, _, false, DF:GetTemplate("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			button.banButton.widget.text:ClearAllPoints()
			button.banButton.widget.text:SetPoint("left", button.banButton.widget, "left", 2, 0)
			button.banButton.widget.text:SetTextColor(.7, .7, 0, alpha)
			button.banButton:SetPoint("topright", button, "topright", 8, -1)
			button.banButton:SetFrameLevel(button:GetFrameLevel()+10)
			button.banButton:SetBackdropColor(0, 0, 0, alpha)
			button.banButton.onleave_backdrop = {0, 0, 0, alpha}
			button.banButton.onenter_backdrop = {0, 0, 0, alpha}
			button.banButton.tooltip = "|cFFFFFF00World Quest Tracker|r\nIf this is an #Ad, Spam, Trash, hit this button!"

			--dark texture to be placed above the result rectangle when it get banned
			button.disabledOverlay = CreateFrame("frame", nil, button)
			button.disabledOverlay:SetAllPoints()
			button.disabledOverlay.texture = button.disabledOverlay:CreateTexture(nil, "overlay")
			button.disabledOverlay.texture:SetColorTexture(.0, .0, .0, .863)
			button.disabledOverlay.texture:SetAllPoints()
			button.disabledOverlay:Hide()
		else
			if (not WorldQuestTracker.db.profile.groupfinder.kfilter.leaders_ignored[searchResultInfo.leaderName]) then
				button.banButton.text = "Ban!"
			end
		end

		button.banButton:Show()
		button.banButton:SetAlpha(buttonAlpha)
		button.banButton.resultID = button.resultID
		if (searchResultInfo.leaderName) then
			allowedCache[searchResultInfo.leaderName] = (allowedCache[searchResultInfo.leaderName] or 0) + 1
		end
	else
		if (button.banButton) then
			button.banButton:Hide()
		end
	end

	--[=[
		[18:26:50] LFGListSearchPanelScrollFrameButton5 312 36.000007629395
		[18:26:50] 0 userdata: 000002E4B3633E58
		[18:26:50] Spinner table: 000002E536255480
		[18:26:50] Highlight table: 000002E536254DF0
		[18:26:50] DataDisplay table: 000002E536255070
			[18:28:18] Enumerate table: 000002E58EA65470
			[18:28:18] PlayerCount table: 000002E58EA65C90
			[18:28:18] RoleCount table: 000002E58EA644D0
		[18:26:50] ActivityName table: 000002E536254CB0
		[18:26:50] VoiceChat table: 000002E5362553E0
		[18:26:50] PendingLabel table: 000002E536254D50
		[18:26:50] ExpirationTime table: 000002E536254D00
		[18:26:50] Selected table: 000002E536254DA0
		[18:26:50] resultID 1255
		[18:26:50] CancelButton table: 000002E536255700
		[18:26:50] expiration 372979.737
		[18:26:50] ResultBG table: 000002E536254BC0
		[18:26:50] ApplicationBG table: 000002E536254C10
		[18:26:50] Name table: 000002E536254C60

	--]=]


end

--hooksecurefunc("LFGListSearchEntry_Update", kspam.OnUpdateButtonStatus)





