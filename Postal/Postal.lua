local Postal = LibStub("AceAddon-3.0"):NewAddon("Postal", "AceEvent-3.0", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
_G["Postal"] = Postal

-- defaults for storage
local defaults = {
	profile = {
		ModuleEnabledState = {
			["*"] = true
		},
		OpenSpeed = 0.50,
		ChatOutput = 1,
		Select = {
			SpamChat = true,
			KeepFreeSpace = 1,
		},
		OpenAll = {
			AHCancelled = true,
			AHExpired = true,
			AHOutbid = true,
			AHSuccess = true,
			AHWon = true,
			NeutralAHCancelled = true,
			NeutralAHExpired = true,
			NeutralAHOutbid = true,
			NeutralAHSuccess = true,
			NeutralAHWon = true,
			Postmaster = true,
			Attachments = true,
			SpamChat = true,
			KeepFreeSpace = 1,
		},
		Express = {
			EnableAltClick = false,
			AutoSend = false,
			BulkSend = true,
			MouseWheel = true,
			MultiItemTooltip = true,
		},
		BlackBook = {
			AutoFill = true,
			contacts = {},
			recent = {},
			AutoCompleteAlts = true,
			AutoCompleteAllAlts = true,
			AutoCompleteRecent = true,
			AutoCompleteContacts = true,
			AutoCompleteFriends = true,
			AutoCompleteGuild = true,
			ExcludeRandoms = false,
			DisableBlizzardAutoComplete = false,
			UseAutoComplete = true,
		},
	},
	global = {
		BlackBook = {
			alts = {},
		},
	},
}
local _G = getfenv(0)
local t = {}
Postal.keepFreeOptions = {0, 1, 2, 3, 5, 10, 15, 20, 25, 30}

-- Use a common frame and setup some common functions for the Postal dropdown menus
local Postal_DropDownMenu = CreateFrame("Frame", "Postal_DropDownMenu")
Postal_DropDownMenu.displayMode = "MENU"
Postal_DropDownMenu.info = {}
Postal_DropDownMenu.levelAdjust = 0
Postal_DropDownMenu.UncheckHack = function(dropdownbutton)
	_G[dropdownbutton:GetName().."Check"]:Hide()
	_G[dropdownbutton:GetName().."UnCheck"]:Hide()
end
Postal_DropDownMenu.HideMenu = function()
	if UIDROPDOWNMENU_OPEN_MENU == Postal_DropDownMenu then
		CloseDropDownMenus()
	end
end

-- Functions for long subject mouseover
local function subjectHoverIn(self)
	local s = _G["MailItem"..self:GetID().."Subject"]
	if s:GetStringWidth() + 25 > s:GetWidth() then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(s:GetText())
		GameTooltip:Show()
	end
end
local function subjectHoverOut(self)
	GameTooltip:Hide()
end


---------------------------
-- Postal Core Functions --
---------------------------

function Postal:OnInitialize()

	--print("Postal is Active and Running");

	-- Version number
	if not self.version then self.version = GetAddOnMetadata("Postal", "Version") end

	-- Initialize database
	self.db = LibStub("AceDB-3.0"):New("Postal3DB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	-- Enable/disable modules based on saved settings
	for name, module in self:IterateModules() do
		module:SetEnabledState(self.db.profile.ModuleEnabledState[name] or false)
		if module.OnEnable then
			hooksecurefunc(module, "OnEnable", self.OnModuleEnable_Common) -- Posthook
		end
	end

	-- Register events
	self:RegisterEvent("MAIL_CLOSED")

	-- Create the Menu Button
	local Postal_ModuleMenuButton = CreateFrame("Button", "Postal_ModuleMenuButton", MailFrame)
	Postal_ModuleMenuButton:SetWidth(25)
	Postal_ModuleMenuButton:SetHeight(25)
	Postal_ModuleMenuButton:SetPoint("TOPRIGHT", -22, 2)
	Postal_ModuleMenuButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
	Postal_ModuleMenuButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Round")
	Postal_ModuleMenuButton:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
	Postal_ModuleMenuButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
	Postal_ModuleMenuButton:SetScript("OnClick", function(self, button, down)
		if Postal_DropDownMenu.initialize ~= Postal.Menu then
			CloseDropDownMenus()
			Postal_DropDownMenu.initialize = Postal.Menu
		end
		ToggleDropDownMenu(1, nil, Postal_DropDownMenu, self:GetName(), 0, 0)
	end)
	Postal_ModuleMenuButton:SetScript("OnHide", Postal_DropDownMenu.HideMenu)

	-- Create 7 buttons for mouseover on long subject lines
	for i = 1, 7 do
		local b = CreateFrame("Button", "PostalSubjectHover"..i, _G["MailItem"..i])
		b:SetID(i)
		b:SetAllPoints(_G["MailItem"..i.."Subject"])
		b:SetScript("OnEnter", subjectHoverIn)
		b:SetScript("OnLeave", subjectHoverOut)
	end
	self.OnInitialize = nil
end

function Postal:OnProfileChanged(event, database, newProfileKey)
	for name, module in self:IterateModules() do
		if self.db.profile.ModuleEnabledState[name] then
			module:Enable()
		else
			module:Disable()
		end
	end
end

function Postal:OnModuleEnable_Common()
	-- If the module is enabled with the MailFrame open (at mailbox)
	-- run the MAIL_SHOW() event function
	if self.MAIL_SHOW and MailFrame:IsVisible() then
		self:MAIL_SHOW()
	end
end

-- Hides the minimap unread mail button if there are no unread mail on closing the mailbox.
-- Does not scan past the first 50 items since only the first 50 are viewable.
function Postal:MAIL_CLOSED()
	for i = 1, GetInboxNumItems() do
		if not select(9, GetInboxHeaderInfo(i)) then return end
	end
	MiniMapMailFrame:Hide()
end

function Postal:Print(...)
	local text = "|cff33ff99Postal|r:"
	for i = 1, select("#", ...) do
		text = text.." "..tostring(select(i, ...))
	end

	if not self:IsChatFrameActive(self.db.profile.ChatOutput) then
		self.db.profile.ChatOutput = 1
	end
	local chatFrame = _G["ChatFrame"..self.db.profile.ChatOutput]
	if chatFrame then
		chatFrame:AddMessage(text)
	end
end

function Postal:IsChatFrameActive(i)
	local _, _, _, _, _, _, shown = FCF_GetChatWindowInfo(i);
	local chatFrame = _G["ChatFrame"..i]
	if chatFrame then
		if shown or chatFrame.isDocked then
			return true
		end
	end
	return false
end

function Postal.SaveOption(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile[arg1][arg2] = checked
end

function Postal.ToggleModule(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.ModuleEnabledState[arg1] = checked
	if checked then arg2:Enable() else arg2:Disable() end
end

function Postal.SetOpenSpeed(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.OpenSpeed = arg1
end

function Postal.SetChatOutput(dropdownbutton, arg1, arg2, checked)
	Postal.db.profile.ChatOutput = arg1
end

function Postal.ProfileFunc(dropdownbutton, arg1, arg2, checked)
	if arg1 == "NewProfile" then
		StaticPopup_Show("POSTAL_NEW_PROFILE")
	else
		Postal.db[arg1](Postal.db, arg2)
	end
	CloseDropDownMenus()
end

StaticPopupDialogs["POSTAL_NEW_PROFILE"] = {preferredIndex = 3,
	text = L["New Profile Name:"],
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 128,
	editBoxWidth = 350,  -- Needed in Cata
	OnAccept = function(self)
		Postal.db:SetProfile(strtrim(self.editBox:GetText()))
	end,
	OnShow = function(self)
		self.editBox:SetText(Postal.db:GetCurrentProfile())
		self.editBox:SetFocus()
	end,
	OnHide = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].OnHide,
	EditBoxOnEnterPressed = function(self)
		local parent = self:GetParent()
		Postal.db:SetProfile(strtrim(parent.editBox:GetText()))
		parent:Hide()
	end,
	EditBoxOnEscapePressed = StaticPopupDialogs["SET_GUILDPLAYERNOTE"].EditBoxOnEscapePressed,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
}

function Postal.Menu(self, level)
	if not level then return end
	local info = self.info
	wipe(info)
	if level == 1 then
		info.isTitle = 1
		info.text = "邮件增强"
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		info.disabled = nil
		info.isTitle = nil
		info.notCheckable = nil

		info.keepShownOnClick = 1
		info.isNotRadio = 1
		for name, module in Postal:IterateModules() do
			info.text = L[name]
			info.func = Postal.ToggleModule
			info.arg1 = name
			info.arg2 = module
			info.checked = module:IsEnabled()
			info.hasArrow = module.ModuleMenu ~= nil
			info.value = module
			UIDropDownMenu_AddButton(info, level)
		end

		wipe(info)
		info.disabled = 1
		UIDropDownMenu_AddButton(info, level)
		info.disabled = nil

		info.text = L["Opening Speed"]
		info.func = self.UncheckHack
		info.notCheckable = 1
		info.keepShownOnClick = 1
		info.hasArrow = 1
		info.value = "OpenSpeed"
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Chat Output"]
		info.func = self.UncheckHack
		info.notCheckable = 1
		info.keepShownOnClick = 1
		info.hasArrow = 1
		info.value = "ChatOutput"
		UIDropDownMenu_AddButton(info, level)

		info.text = L["Profile"]
		info.func = self.UncheckHack
		info.value = "Profile"
		UIDropDownMenu_AddButton(info, level)

		wipe(info)
		info.notCheckable = 1
		info.text = L["Help"]
		info.func = Postal.About
		UIDropDownMenu_AddButton(info, level)

		info.disabled = 1
		info.text = nil
		info.func = nil
		UIDropDownMenu_AddButton(info, level)

		info.disabled = nil
		info.text = CLOSE
		info.func = self.HideMenu
		info.tooltipTitle = CLOSE
		UIDropDownMenu_AddButton(info, level)

	elseif level == 2 then
		if UIDROPDOWNMENU_MENU_VALUE == "OpenSpeed" then
			local speed = Postal.db.profile.OpenSpeed
			for i = 0, 13 do
				local s = 0.3 + i*0.05
				info.text = format("%0.2f", s)
				info.func = Postal.SetOpenSpeed
				info.checked = s == speed
				info.arg1 = s
				UIDropDownMenu_AddButton(info, level)
			end
			for i = 0, 8 do
				local s = 1 + i*0.5
				info.text = format("%0.2f", s)
				info.func = Postal.SetOpenSpeed
				info.checked = s == speed
				info.arg1 = s
				UIDropDownMenu_AddButton(info, level)
			end

		elseif UIDROPDOWNMENU_MENU_VALUE == "ChatOutput" then
			local selectedFrame = Postal.db.profile.ChatOutput
			for i = 1, NUM_CHAT_WINDOWS do
				if Postal:IsChatFrameActive(i) then
					info.text = format("%d. %s", i, _G["ChatFrame"..i.."Tab"]:GetText())
					info.func = Postal.SetChatOutput
					info.checked = i == selectedFrame
					info.arg1 = i
					UIDropDownMenu_AddButton(info, level)
				end
			end

		elseif UIDROPDOWNMENU_MENU_VALUE == "Profile" then
			-- Profile stuff
			info.hasArrow = 1
			info.keepShownOnClick = 1
			info.func = self.UncheckHack
			info.notCheckable = 1

			info.text = L["Choose"]
			info.value = "SetProfile"
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Copy From"]
			info.value = "CopyProfile"
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Delete"]
			info.value = "DeleteProfile"
			UIDropDownMenu_AddButton(info, level)

			info.hasArrow = nil
			info.keepShownOnClick = nil
			info.func = Postal.ProfileFunc
			info.arg1 = "NewProfile"
			info.text = L["New Profile"]
			UIDropDownMenu_AddButton(info, level)

			info.text = L["Reset Profile"]
			info.func = Postal.ProfileFunc
			info.arg1 = "ResetProfile"
			info.arg2 = nil
			UIDropDownMenu_AddButton(info, level)

		elseif type(UIDROPDOWNMENU_MENU_VALUE) == "table" and UIDROPDOWNMENU_MENU_VALUE.ModuleMenu then
			-- Submenus for modules
			self.levelAdjust = 1
			UIDROPDOWNMENU_MENU_VALUE.ModuleMenu(self, level)
			self.levelAdjust = 0
			self.module = UIDROPDOWNMENU_MENU_VALUE
		end

	elseif level == 3 then
		if UIDROPDOWNMENU_MENU_VALUE == "SetProfile" then
			local cur = Postal.db:GetCurrentProfile()
			Postal.db:GetProfiles(t)
			table.sort(t)
			info.func = Postal.ProfileFunc
			info.arg1 = "SetProfile"
			for i = 1, #t do
				local s = t[i]
				info.text = s
				info.arg2 = s
				info.checked = cur == s
				UIDropDownMenu_AddButton(info, level)
			end

		elseif UIDROPDOWNMENU_MENU_VALUE == "CopyProfile" or UIDROPDOWNMENU_MENU_VALUE == "DeleteProfile" then
			local cur = Postal.db:GetCurrentProfile()
			Postal.db:GetProfiles(t)
			table.sort(t)
			info.func = Postal.ProfileFunc
			info.arg1 = UIDROPDOWNMENU_MENU_VALUE
			info.notCheckable = 1
			for i = 1, #t do
				local s = t[i]
				if s ~= cur then
					info.text = s
					info.arg2 = s
					UIDropDownMenu_AddButton(info, level)
				end
			end

		elseif self.module and self.module.ModuleMenu then
			self.levelAdjust = 1
			self.module.ModuleMenu(self, level)
			self.levelAdjust = 0
		end

	elseif level > 3 then
		if self.module and self.module.ModuleMenu then
			self.levelAdjust = 1
			self.module.ModuleMenu(self, level)
			self.levelAdjust = 0
		end

	end
end

function Postal:CreateAboutFrame()
	local aboutFrame = Postal.aboutFrame
	if not aboutFrame and Chatter and ChatterCopyFrame then
		aboutFrame = ChatterCopyFrame
		aboutFrame.editBox = Chatter:GetModule("Chat Copy").editBox
	end
	if not aboutFrame or not aboutFrame.editBox then
		aboutFrame = CreateFrame("Frame", "PostalAboutFrame", UIParent)
		tinsert(UISpecialFrames, "PostalAboutFrame")
		aboutFrame:SetBackdrop({
			bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
			edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
			tile = true, tileSize = 16, edgeSize = 16,
			insets = { left = 3, right = 3, top = 5, bottom = 3 }
		})
		aboutFrame:SetBackdropColor(0,0,0,1)
		aboutFrame:SetWidth(500)
		aboutFrame:SetHeight(400)
		aboutFrame:SetPoint("CENTER", UIParent, "CENTER")
		aboutFrame:Hide()
		aboutFrame:SetFrameStrata("DIALOG")
		aboutFrame:SetToplevel(true)

		local scrollArea = CreateFrame("ScrollFrame", "PostalAboutScroll", aboutFrame, "UIPanelScrollFrameTemplate")
		scrollArea:SetPoint("TOPLEFT", aboutFrame, "TOPLEFT", 8, -30)
		scrollArea:SetPoint("BOTTOMRIGHT", aboutFrame, "BOTTOMRIGHT", -30, 8)

		local editBox = CreateFrame("EditBox", nil, aboutFrame)
		editBox:SetMultiLine(true)
		editBox:SetMaxLetters(99999)
		editBox:EnableMouse(true)
		editBox:SetAutoFocus(false)
		editBox:SetFontObject(ChatFontNormal)
		editBox:SetWidth(400)
		editBox:SetHeight(270)
		editBox:SetScript("OnEscapePressed", function() aboutFrame:Hide() end)
		aboutFrame.editBox = editBox

		scrollArea:SetScrollChild(editBox)

		local close = CreateFrame("Button", nil, aboutFrame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", aboutFrame, "TOPRIGHT")
	end
	Postal.aboutFrame = aboutFrame
	Postal.CreateAboutFrame = nil -- Kill ourselves
end

function Postal.About()
	if Postal.CreateAboutFrame then Postal:CreateAboutFrame() end
	local version = GetAddOnMetadata("Postal", "Version")
	wipe(t)
	tinsert(t, "|cFFFFCC00"..GetAddOnMetadata("Postal", "Title").." v"..version.."|r")
	tinsert(t, "-----")
	tinsert(t, "")
	for name, module in Postal:IterateModules() do
		tinsert(t, "|cffffcc00"..L[name].."|r")
		if module.description then
			tinsert(t, module.description)
		end
		if module.description2 then
			tinsert(t, "")
			tinsert(t, module.description2)
		end
		tinsert(t, "")
	end
	tinsert(t, "-----")
	tinsert(t, L["Please post bugs or suggestions on the curseforge Postal page |cFF00FFFFhttps://www.curseforge.com/wow/addons/postal/issues|r. When posting bugs, indicate your locale and Postal's version number v%s."]:format(version))
	tinsert(t, "")
	tinsert(t, "- Abaton (Wyrmrest Accord US Alliance)")
	tinsert(t, "")
	Postal.aboutFrame.editBox:SetText(table.concat(t, "\n"))
	Postal.aboutFrame:Show()
	wipe(t) -- For garbage collection
end

---------------------------
-- Common Mail Functions --
---------------------------

-- Disable Inbox Clicks
local function noop() end
function Postal:DisableInbox(disable)
	if disable then
		if not self:IsHooked("InboxFrame_OnClick") then
			self:RawHook("InboxFrame_OnClick", noop, true)
			for i = 1, 7 do
				_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(true)
			end
		end
	else
		if self:IsHooked("InboxFrame_OnClick") then
			self:Unhook("InboxFrame_OnClick")
			for i = 1, 7 do
				_G["MailItem" .. i .. "ButtonIcon"]:SetDesaturated(false)
			end
		end
	end
end

-- Return the type of mail a message subject is
local SubjectPatterns = {
	AHCancelled = gsub(AUCTION_REMOVED_MAIL_SUBJECT, "%%s", ".*"),
	AHExpired = gsub(AUCTION_EXPIRED_MAIL_SUBJECT, "%%s", ".*"),
	AHOutbid = gsub(AUCTION_OUTBID_MAIL_SUBJECT, "%%s", ".*"),
	AHSuccess = gsub(AUCTION_SOLD_MAIL_SUBJECT, "%%s", ".*"),
	AHWon = gsub(AUCTION_WON_MAIL_SUBJECT, "%%s", ".*"),
}
function Postal:GetMailType(msgSubject)
	if msgSubject then
		for k, v in pairs(SubjectPatterns) do
			if msgSubject:find(v) then return k end
		end
	end
	return "NonAHMail"
end

function Postal:GetMoneyString(money)
	local gold = floor(money / 10000)
	local silver = floor((money - gold * 10000) / 100)
	local copper = mod(money, 100)
	if gold > 0 then
		return format(GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, gold, 0, 0, silver, 0, 0, copper, 0, 0)
	elseif silver > 0 then
		return format(SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, silver, 0, 0, copper, 0, 0)
	else
		return format(COPPER_AMOUNT_TEXTURE, copper, 0, 0)
	end
end

function Postal:GetMoneyStringPlain(money)
	local gold = floor(money / 10000)
	local silver = floor((money - gold * 10000) / 100)
	local copper = mod(money, 100)
	if gold > 0 then
		return gold..GOLD_AMOUNT_SYMBOL.." "..silver..SILVER_AMOUNT_SYMBOL.." "..copper..COPPER_AMOUNT_SYMBOL
	elseif silver > 0 then
		return silver..SILVER_AMOUNT_SYMBOL.." "..copper..COPPER_AMOUNT_SYMBOL
	else
		return copper..COPPER_AMOUNT_SYMBOL
	end
end

function Postal:CountItemsAndMoney()
	local numAttach = 0
	local numGold = 0
	for i = 1, GetInboxNumItems() do
		local msgMoney, _, _, msgItem = select(5, GetInboxHeaderInfo(i))
		numAttach = numAttach + (msgItem or 0)
		numGold = numGold + msgMoney
	end
	return numAttach, numGold
end
