local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_Select = Postal:NewModule("Select", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_Select.description = L["Add check boxes to the inbox for multiple mail operations."]
Postal_Select.description2 = L[ [[|cFFFFCC00*|r Selected mail will be batch opened or returned to sender by clicking Open or Return.
|cFFFFCC00*|r You can Shift-Click 2 checkboxes to mass select every mail between the 2 checkboxes.
|cFFFFCC00*|r You can Ctrl-Click a checkbox to mass select or unselect every mail from that sender.
|cFFFFCC00*|r Select will never delete any mail (mail without text is auto-deleted by the game when all attached items and gold are taken).
|cFFFFCC00*|r Select will skip CoD mails and mails from Blizzard.
|cFFFFCC00*|r Disable the Verbose option to stop the chat spam while opening mail.]] ]

-- luacheck: globals InboxFrame

local _G = getfenv(0)
local currentMode = nil
local selectedMail = {}
local openButton = nil
local returnButton = nil
local checkboxFunc = function(self) Postal_Select:ToggleMail(self) end
local mailIndex, attachIndex
local lastItem, lastNumAttach, lastNumGold
local wait
local skipFlag
local invFull, invAlmostFull
local lastCheck
local firstMailDaysLeft
local mailID = {}

local updateFrame = CreateFrame("Frame")
updateFrame:Hide()
updateFrame:SetScript("OnShow", function(self)
	self.time = Postal.db.profile.OpenSpeed
	if invAlmostFull and self.time < 1.0 and not self.lootingMoney then
		-- Delay opening to 1 second to account for a nearly full
		-- inventory to respect the KeepFreeSpace setting
		self.time = 1.0
	end
	self.lootingMoney = nil
end)
updateFrame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time - elapsed
	if self.time <= 0 then
		self:Hide()
		Postal_Select:ProcessNext()
	end
end)


local lastSeen,lastRefill = 0,0

local function updateMailCounts()
	local cur,tot = GetInboxNumItems()
	if cur>lastSeen then
		lastRefill = GetTime()
	end
	lastSeen = cur
end

local function printTooMuchMail()
	InboxTooMuchMail.Show = updateMailCounts	-- only print once, rest of the time: update
	updateMailCounts()

	local cur,tot = GetInboxNumItems()

	local timeLeft = lastRefill+60-GetTime()
	if cur>=50 or -- if inbox is full, no more will arrive
	   timeLeft<0 then	-- if someone waited more than 60 seconds to take a mail out....
		Postal:Print(format(L["There are %i more messages not currently shown."], tot-cur))
	else
		Postal:Print(format(L["There are %i more messages not currently shown. More should become available in %i seconds."], tot-cur, timeLeft))
	end

end

function Postal_Select:OnEnable()
	--create the open button
	if not openButton then
		openButton = CreateFrame("Button", "PostalSelectOpenButton", InboxFrame, "UIPanelButtonTemplate")
		openButton:SetWidth(120)
		openButton:SetHeight(25)
		openButton:SetPoint("RIGHT", InboxFrame, "TOP", 0, -42)
		openButton:SetText(L["Open"])
		openButton:SetScript("OnClick", function() Postal_Select:HandleSelect(1) end)
		openButton:SetFrameLevel(openButton:GetFrameLevel() + 1)
	end

	--create the return button
	if not returnButton then
		returnButton = CreateFrame("Button", "PostalSelectReturnButton", InboxFrame, "UIPanelButtonTemplate")
		returnButton:SetWidth(120)
		returnButton:SetHeight(25)
		returnButton:SetPoint("LEFT", InboxFrame, "TOP", 5, -42)
		returnButton:SetText(L["Return"])
		returnButton:SetScript("OnClick", function() Postal_Select:HandleSelect(2) end)
		returnButton:SetFrameLevel(returnButton:GetFrameLevel() + 1)
	end

	--indent to make room for the checkboxes
	MailItem1:SetPoint("TOPLEFT", "InboxFrame", "TOPLEFT", 29, -68)
	for i = 1, 7 do
		_G["MailItem"..i.."ExpireTime"]:SetPoint("TOPRIGHT", "MailItem"..i, "TOPRIGHT", 10, -4)
		_G["MailItem"..i]:SetWidth(280)
	end

	--now create the checkboxes
	for i = 1, 7 do
		if not _G["PostalInboxCB"..i] then
			local CB = CreateFrame("CheckButton", "PostalInboxCB"..i, _G["MailItem"..i], "OptionsCheckButtonTemplate")
			CB:SetID(i)
			CB:SetPoint("RIGHT", "MailItem"..i, "LEFT", 1, -5)
			CB:SetWidth(24)
			CB:SetHeight(24)
			CB:SetHitRectInsets(0, 0, 0, 0)
			CB:SetScript("OnClick", checkboxFunc)
			local text = CB:CreateFontString("PostalInboxCB"..i.."Text", "BACKGROUND", "GameFontHighlightSmall")
			text:SetPoint("BOTTOM", CB, "TOP")
			text:SetText(i)
			CB.text = text
		end
	end

	self:RawHook("InboxFrame_Update", true)
	self:RegisterEvent("MAIL_SHOW")

	-- Don't show that silly "Not all of your mail could be delivered. Please delete some
	-- mail to make room." message under our Open and Return buttons. Print it to chat instead.
	InboxTooMuchMail.Show = printTooMuchMail
	InboxTooMuchMail:Hide()

	-- For enabling after a disable
	openButton:Show()
	returnButton:Show()
	for i = 1, 7 do
		_G["PostalInboxCB"..i]:Show()
	end
end

function Postal_Select:OnDisable()
	self:Reset()
	if self:IsHooked("InboxFrame_Update") then
		self:Unhook("InboxFrame_Update")
	end
	openButton:Hide()
	returnButton:Hide()
	MailItem1:SetPoint("TOPLEFT", "InboxFrame", "TOPLEFT", 28, -80)
	for i = 1, 7 do
		_G["PostalInboxCB"..i]:Hide()
		_G["MailItem"..i.."ExpireTime"]:SetPoint("TOPRIGHT", "MailItem"..i, "TOPRIGHT", -4, -4)
		_G["MailItem"..i]:SetWidth(305)
	end
	InboxTooMuchMail.Show = nil
end

function Postal_Select:MAIL_SHOW()
	self:RegisterEvent("MAIL_CLOSED", "Reset")
	self:RegisterEvent("PLAYER_LEAVING_WORLD", "Reset")
	self:RegisterEvent("MAIL_INBOX_UPDATE")
	self:BuildUniqueIDs()
end

function Postal_Select:ToggleMail(frame)
	local index = frame:GetID() + (InboxFrame.pageNum - 1) * 7
	if lastCheck and IsShiftKeyDown() then
		-- Sneaky feature to shift-click a checkbox to select every
		-- mail between the clicked one and the previous click
		for i = lastCheck, index, lastCheck <= index and 1 or -1 do
			selectedMail[i] = true
		end
		self:InboxFrame_Update()
		return
	end
	if IsControlKeyDown() then
		-- Sneaky feature to ctrl-click a checkbox to select/unselect every
		-- mail where the sender is the same
		local status = frame:GetChecked()
		local indexSender = select(3, GetInboxHeaderInfo(index))
		for i = 1, GetInboxNumItems() do
			if select(3, GetInboxHeaderInfo(i)) == indexSender then
				selectedMail[i] = status
			end
		end
		self:InboxFrame_Update()
		return
	end
	if frame:GetChecked() then
		selectedMail[index] = true
		lastCheck = index
	else
		selectedMail[index] = nil
		lastCheck = nil
	end
end

function Postal_Select:GetUniqueID(index)
	local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(index)
	packageIcon = packageIcon or ""
	stationeryIcon = stationeryIcon or ""
	sender = sender or ""
	subject = subject or ""
	hasItem = hasItem or 0
	wasReturned = wasReturned or 0
	textCreated = textCreated or 0
	canReply = canReply or 0
	isGM = isGM or 0
	return format("%s%s%s%s%s%s%d%d%d%d%d", packageIcon, stationeryIcon, sender, subject, money, CODAmount, hasItem, wasReturned, textCreated, canReply, isGM)
end

function Postal_Select:BuildUniqueIDs()
	-- Build a unique ID for every mail
	local numMails = GetInboxNumItems()
	wipe(mailID)
	for i = 1, numMails do
		mailID[i] = self:GetUniqueID(i)
	end
end

function Postal_Select:HandleSelect(mode)
	mailIndex = GetInboxNumItems() or 0
	attachIndex = ATTACHMENTS_MAX_RECEIVE
	invFull = nil
	skipFlag = false
	lastItem = false
	lastNumAttach = nil
	lastNumGold = nil
	wait = false
	if mailIndex == 0 then
		return
	end
	firstMailDaysLeft = select(7, GetInboxHeaderInfo(1))

	currentMode = mode
	if currentMode == 1 then
		openButton:SetText(L["In Progress"])
		returnButton:Hide()
	else
		returnButton:SetText(L["In Progress"])
		openButton:Hide()
	end

	--protect the user from changing anything while were in process
	Postal:DisableInbox(1)
	if self:IsHooked("InboxFrame_Update") then
		self:Unhook("InboxFrame_Update")
	end

	for i = 1, 7 do
		local index = i + (InboxFrame.pageNum-1) * 7
		local CB = _G["PostalInboxCB"..i]
		CB:Hide()
	end

	self:RegisterEvent("UI_ERROR_MESSAGE")
	self:ProcessNext()
end

function Postal_Select:ProcessNext()
	-- Skip mails not selected to be processed
	while not selectedMail[mailIndex] and mailIndex > 0 do
		mailIndex = mailIndex - 1
		attachIndex = ATTACHMENTS_MAX_RECEIVE
	end

	if mailIndex > 0 then
		local msgSubject, msgMoney, msgCOD, _, msgItem, _, wasReturned, msgText, canReply, isGM = select(4, GetInboxHeaderInfo(mailIndex))

		if currentMode == 1 then
			-- Open mode

			-- Check if we need to wait for the mailbox to change
			if wait then
				local attachCount, goldCount = Postal:CountItemsAndMoney()
				if lastNumGold ~= goldCount then
					-- Process next mail, gold has been taken
					wait = false
					selectedMail[mailIndex] = nil
					mailIndex = mailIndex - 1
					attachIndex = ATTACHMENTS_MAX_RECEIVE
					return self:ProcessNext() -- tail call
				elseif lastNumAttach ~= attachCount then
					-- Process next item, an attachment has been taken
					wait = false
					attachIndex = attachIndex - 1
					if lastItem then
						-- The item taken was the last item, process next mail
						lastItem = false
						selectedMail[mailIndex] = nil
						mailIndex = mailIndex - 1
						attachIndex = ATTACHMENTS_MAX_RECEIVE
						return self:ProcessNext() -- tail call
					end
				else
					-- Wait longer until something in the mailbox changes
					updateFrame:Show()
					return
				end
			end

			-- Print message on next mail
			if Postal.db.profile.Select.SpamChat and attachIndex == ATTACHMENTS_MAX_RECEIVE then
				if not invFull or msgMoney > 0 then
					local moneyString = msgMoney > 0 and " ["..Postal:GetMoneyString(msgMoney).."]" or ""
					local playerName
					local mailType = Postal:GetMailType(msgSubject)
					if (mailType == "AHSuccess" or mailType == "AHWon") then
						playerName = select(3,GetInboxInvoiceInfo(mailIndex))
						playerName = playerName and (" ("..playerName..")")
					end
					Postal:Print(format("%s %d: %s%s%s", L["Open"], mailIndex, msgSubject or "", moneyString, (playerName or "")))
				end
			end

			-- Skip mail if it contains a CoD or if its from a GM
			if (msgCOD and msgCOD > 0) or (isGM) then
				skipFlag = true
				selectedMail[mailIndex] = nil
				mailIndex = mailIndex - 1
				attachIndex = ATTACHMENTS_MAX_RECEIVE
				return self:ProcessNext() -- tail call
			end

			-- Find next attachment index backwards
			while not GetInboxItemLink(mailIndex, attachIndex) and attachIndex > 0 do
				attachIndex = attachIndex - 1
			end

			-- Check for free bag space
			if attachIndex > 0 and not invFull and Postal.db.profile.Select.KeepFreeSpace > 0 then
				local free = 0
				for bag = 0, NUM_BAG_SLOTS do
					local bagFree, bagFam = GetContainerNumFreeSlots(bag)
					if bagFam == 0 then
						free = free + bagFree
					end
				end
				if free <= Postal.db.profile.Select.KeepFreeSpace then
					invFull = true
					invAlmostFull = nil
					Postal:Print(format(L["Not taking more items as there are now only %d regular bagslots free."], free))
				elseif free <= Postal.db.profile.Select.KeepFreeSpace + 1 then
					invAlmostFull = true
				end
			end

			-- If inventory is full, check if the item to be looted can stack with an existing stack
			local lootFlag = false
			if attachIndex > 0 and invFull then
				local name, itemID, itemTexture, count, quality, canUse = GetInboxItem(mailIndex, attachIndex)
				local link = GetInboxItemLink(mailIndex, attachIndex)
				itemID = strmatch(link, "item:(%d+)")
				local stackSize = select(8, GetItemInfo(link))
				if itemID and stackSize and GetItemCount(itemID) > 0 then
					for bag = 0, NUM_BAG_SLOTS do
						for slot = 1, GetContainerNumSlots(bag) do
							local texture2, count2, locked2, quality2, readable2, lootable2, link2 = GetContainerItemInfo(bag, slot)
							if link2 then
								local itemID2 = strmatch(link2, "item:(%d+)")
								if itemID == itemID2 and count + count2 <= stackSize then
									lootFlag = true
									break
								end
							end
						end
						if lootFlag then break end
					end
				end
			end

			if attachIndex > 0 and (lootFlag or not invFull) then
				-- If there's attachments, take the item
				--Postal:Print("Getting Item from Message "..mailIndex..", "..attachIndex)
				TakeInboxItem(mailIndex, attachIndex)

				lastNumAttach, lastNumGold = Postal:CountItemsAndMoney()
				wait = true
				-- Find next attachment index backwards
				local attachIndex2 = attachIndex - 1
				while not GetInboxItemLink(mailIndex, attachIndex2) and attachIndex2 > 0 do
					attachIndex2 = attachIndex2 - 1
				end
				if attachIndex2 == 0 and msgMoney == 0 then lastItem = true end

				updateFrame:Show()
			elseif msgMoney > 0 then
				-- No attachments, but there is money
				--Postal:Print("Getting Gold from Message "..mailIndex)
				TakeInboxMoney(mailIndex)

				lastNumAttach, lastNumGold = Postal:CountItemsAndMoney()
				wait = true

				updateFrame.lootingMoney = true
				updateFrame:Show()
			else
				-- Mail has no item or money, go to next mail
				selectedMail[mailIndex] = nil
				mailIndex = mailIndex - 1
				attachIndex = ATTACHMENTS_MAX_RECEIVE
				return self:ProcessNext() -- tail call
			end

		else
			-- Return mode
			if Postal.db.profile.Select.SpamChat and attachIndex == ATTACHMENTS_MAX_RECEIVE then
				Postal:Print(L["Return"].." "..mailIndex..": "..msgSubject)
			end
			if not InboxItemCanDelete(mailIndex) then
				self:RegisterEvent("MAIL_INBOX_UPDATE")
				ReturnInboxItem(mailIndex)
				selectedMail[mailIndex] = nil
				mailIndex = mailIndex - 1
				attachIndex = ATTACHMENTS_MAX_RECEIVE
			else
				Postal:Print(L["Skipping"].." "..mailIndex..": "..msgSubject)
				mailIndex = mailIndex - 1
				attachIndex = ATTACHMENTS_MAX_RECEIVE
				return self:ProcessNext() -- tail call
			end
		end

	else
		-- Reached the end of opening all selected mail
		if skipFlag then Postal:Print(L["Some Messages May Have Been Skipped."]) end
		self:Reset()
	end
end

function Postal_Select:InboxFrame_Update()
	self.hooks["InboxFrame_Update"]()
	for i = 1, 7 do
		local index = i + (InboxFrame.pageNum-1)*7
		local CB = _G["PostalInboxCB"..i]
		if index > GetInboxNumItems() then
			CB:Hide()
		else
			CB:Show()
			CB:SetChecked(selectedMail[index])
			CB.text:SetText(index)
		end
	end
end

function Postal_Select:MAIL_INBOX_UPDATE()
	--Postal:Print("update")
	-- We need this because MAIL_INBOX_UPDATEs can now potentially
	-- include mailbox refreshes since patch 4.0.3 (that is mail can
	-- get inserted both at the back (old mail past 50) and at the front
	-- (new mail received in the last 60 seconds))
	local currentFirstMailDaysLeft = select(7, GetInboxHeaderInfo(1))
	if currentFirstMailDaysLeft ~= firstMailDaysLeft then
		-- First mail's daysLeft changed, indicating we have a
		-- fresh MAIL_INBOX_UPDATE that has new data from CheckInbox()
		-- Try to determine how many new mails were added in front
		local numMails = GetInboxNumItems()
		local checkUntilMailIndex
		if currentMode then
			checkUntilMailIndex = mailIndex - 1
		else
			checkUntilMailIndex = #mailID
		end
		local numNewMailsAtFront = 0
		local mailChanged = true
		while mailChanged do
			mailChanged = false
			for i = 1, checkUntilMailIndex do
				if i + numNewMailsAtFront > numMails then break end
				local id = self:GetUniqueID(i + numNewMailsAtFront)
				if mailID[i] ~= id then
					mailChanged = true
					numNewMailsAtFront = numNewMailsAtFront + 1
					break
				end
			end
		end
		--Postal:Print(numNewMailsAtFront.. " new mails detected at front")
		if numNewMailsAtFront > 0 then
			if mailIndex then
				mailIndex = mailIndex + numNewMailsAtFront
			end
			for i = 50 - numNewMailsAtFront, 1, -1 do
				selectedMail[i + numNewMailsAtFront] = selectedMail[i]
			end
			for i = 1, numNewMailsAtFront do
				selectedMail[i] = nil
			end
		end
		firstMailDaysLeft = currentFirstMailDaysLeft
	end
	self:BuildUniqueIDs()

	if currentMode == 2 then
		updateFrame:Show()
	end
end

function Postal_Select:Reset(event)
	if not self:IsHooked("InboxFrame_Update") then self:RawHook("InboxFrame_Update", true) end

	updateFrame:Hide()
	self:UnregisterEvent("UI_ERROR_MESSAGE")

	wipe(selectedMail)

	Postal:DisableInbox()
	self:InboxFrame_Update()
	openButton:SetText(L["Open"])
	openButton:Show()
	returnButton:SetText(L["Return"])
	returnButton:Show()
	lastCheck = nil
	currentMode = nil
	if event == "MAIL_CLOSED" or event == "PLAYER_LEAVING_WORLD" then
		self:UnregisterEvent("MAIL_CLOSED")
		self:UnregisterEvent("PLAYER_LEAVING_WORLD")
		self:UnregisterEvent("MAIL_INBOX_UPDATE")
	end
	InboxTooMuchMail.Show = printTooMuchMail
end

function Postal_Select:UI_ERROR_MESSAGE(event, error_message)
	if error_message == ERR_INV_FULL then
		invFull = true
		wait = false
	elseif error_message == ERR_ITEM_MAX_COUNT then
		attachIndex = attachIndex - 1
		wait = false
	end
end

function Postal_Select.SetKeepFreeSpace(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.Select.KeepFreeSpace = arg1
end

function Postal_Select.ModuleMenu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	if level == 1 + self.levelAdjust then
		info.keepShownOnClick = 1

		info.text = L["Keep free space"]
		info.hasArrow = 1
		info.value = "KeepFreeSpace"
		info.func = self.UncheckHack
		UIDropDownMenu_AddButton(info, level)
		local listFrame = _G["DropDownList"..level]
		self.UncheckHack(_G[listFrame:GetName().."Button"..listFrame.numButtons])

		info.text = L["Verbose mode"]
		info.hasArrow = nil
		info.value = nil
		info.func = Postal.SaveOption
		info.arg1 = "Select"
		info.arg2 = "SpamChat"
		info.checked = Postal.db.profile.Select.SpamChat
		info.isNotRadio = 1
		UIDropDownMenu_AddButton(info, level)
	elseif level == 2 + self.levelAdjust then
		if UIDROPDOWNMENU_MENU_VALUE == "KeepFreeSpace" then
			local keepFree = Postal.db.profile.Select.KeepFreeSpace
			info.func = Postal_Select.SetKeepFreeSpace
			for _, v in ipairs(Postal.keepFreeOptions) do
				info.text = v
				info.checked = v == keepFree
				info.arg1 = v
				UIDropDownMenu_AddButton(info, level)
			end
		end
	end
end

