local Postal = LibStub("AceAddon-3.0"):GetAddon("Postal")
local Postal_DoNotWant = Postal:NewModule("DoNotWant", "AceHook-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Postal")
Postal_DoNotWant.description = L["Shows a clickable visual icon as to whether a mail will be returned or deleted on expiry."]

-- luacheck: globals InboxFrame

local _G = getfenv(0)
local selectedID
local selectedIDmoney

StaticPopupDialogs["POSTAL_DELETE_MAIL"] = {preferredIndex = 3,
	text = DELETE_MAIL_CONFIRMATION,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		DeleteInboxItem(selectedID)
		selectedID = nil
		--HideUIPanel(OpenMailFrame)
	end,
	showAlert = 1,
	timeout = 0,
	hideOnEscape = 1
}

StaticPopupDialogs["POSTAL_DELETE_MONEY"] = {preferredIndex = 3,
	text = DELETE_MONEY_CONFIRMATION,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		DeleteInboxItem(selectedID)
		selectedID = nil
		--HideUIPanel(OpenMailFrame)
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, selectedIDmoney)
	end,
	hasMoneyFrame = 1,
	showAlert = 1,
	timeout = 0,
	hideOnEscape = 1
}

function Postal_DoNotWant.Click(self, button, down)
	selectedID = self.id + (InboxFrame.pageNum-1)*7
	local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, itemCount, wasRead, wasReturned, textCreated, canReply = GetInboxHeaderInfo(selectedID)
	selectedIDmoney = money
	local firstAttachName
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		firstAttachName = GetInboxItem(selectedID, i)
		if firstAttachName then break end
	end
	if InboxItemCanDelete(selectedID) then
		if firstAttachName then
			StaticPopup_Show("POSTAL_DELETE_MAIL", firstAttachName)
			return
		elseif money and money > 0 then
			StaticPopup_Show("POSTAL_DELETE_MONEY")
			return
		else
			DeleteInboxItem(selectedID)
		end
	else
		ReturnInboxItem(selectedID)
		StaticPopup_Hide("COD_CONFIRMATION")
	end
	selectedID = nil
	--HideUIPanel(OpenMailFrame)
end

function Postal_DoNotWant:OnEnable()
	-- Create the icons
	for i = 1, 7 do
		local b = _G["MailItem"..i.."ExpireTime"]
		if not b.returnicon then
			b.returnicon = CreateFrame("BUTTON", nil, b)
			b.returnicon:SetPoint("TOPRIGHT", b, "BOTTOMRIGHT", -5, -1)
			b.returnicon:SetWidth(16)
			b.returnicon:SetHeight(16)
			b.returnicon.texture = b.returnicon:CreateTexture(nil, "BACKGROUND")
			b.returnicon.texture:SetAllPoints()
			b.returnicon.texture:SetTexCoord(1, 0, 0, 1) -- flips image left/right
			b.returnicon.id = i
			b.returnicon:SetScript("OnClick", Postal_DoNotWant.Click)
			b.returnicon:SetScript("OnEnter", b:GetScript("OnEnter"))
			b.returnicon:SetScript("OnLeave", b:GetScript("OnLeave"))
		end
		-- For enabling after a disable
		b.returnicon:Show()
	end

	self:RawHook("InboxFrame_Update", true)
end

function Postal_DoNotWant:OnDisable()
	if self:IsHooked("InboxFrame_Update") then
		self:Unhook("InboxFrame_Update")
	end
	for i = 1, 7 do
		_G["MailItem"..i.."ExpireTime"].returnicon:Hide()
	end
end

function Postal_DoNotWant:InboxFrame_Update()
	self.hooks["InboxFrame_Update"]()
	for i = 1, 7 do
		local index = i + (InboxFrame.pageNum-1)*7
		local b = _G["MailItem"..i.."ExpireTime"].returnicon
		if index > GetInboxNumItems() then
			b:Hide()
		else
			local f = InboxItemCanDelete(index)
			b.texture:SetTexture(f and "Interface\\RaidFrame\\ReadyCheck-NotReady" or "Interface\\ChatFrame\\ChatFrameExpandArrow")
			b.tooltip = f and DELETE or MAIL_RETURN
			b:Show()
		end
	end
end
