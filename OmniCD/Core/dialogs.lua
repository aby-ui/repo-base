local E, L, C = select(2, ...):unpack()

E.StaticPopupDialogs = {} -- upvalue global to switch

E.StaticPopupDialogs["OMNICD_Elv_MSG"] = {
	text = E.userClassHexColor .. "OmniCD:|r " .. L["Changing party display options in your UF addon while OmniCD is active will break the anchors. Type (/oc rl) to fix the anchors"],
	button1 = OKAY,
	button2 = L["Don't show again"],
	OnCancel = function()
		E.DB.global.disableElvMsg = true
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS
}

E.StaticPopupDialogs["OMNICD_RELOADUI"] = {
	text = "%s",
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() -- data2 is only passed on to OnAccept
		EnableAddOn("Blizzard_CompactRaidFrames")
		EnableAddOn("Blizzard_CUFProfiles")
		C_UI.Reload()
	end,
	OnCancel = function()
		if E.Party.test then
			E.Party:Test()
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS
}

E.StaticPopupDialogs["OMNICD_IMPORT_EDITOR"] = {
	text = L["Importing Custom Spells will reload UI. Press Cancel to abort."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(_, data)
		E.ProfileSharing.CopyCustomSpells(data)
		OmniCD_ProfileDialogEditBox:SetText(L["Profile imported successfully!"])
		C_UI.Reload()
	end,
	OnCancel = function()
		OmniCD_ProfileDialogEditBox:SetText(L["Profile import cancelled!"])
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS
}

E.StaticPopupDialogs["OMNICD_IMPORT_PROFILE"] = {
	text = L["Press Accept to save profile %s. Addon will switch to the imported profile."],
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(_, data)
		E.ProfileSharing.CopyProfile(data.profileType, data.profileKey, data.profileData)
		OmniCD_ProfileDialogEditBox:SetText(L["Profile imported successfully!"])
		E.Libs.ACR:NotifyChange("OmniCD")
	end,
	OnCancel = function()
		OmniCD_ProfileDialogEditBox:SetText(L["Profile import cancelled!"])
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = STATICPOPUP_NUMDIALOGS
}

local function Button_OnLeave(self)
	self:SetBackdropBorderColor(0, 0, 0)
end

local function Button_OnEnter(self)
	local r, g, b = GetClassColor(E.userClass)
	self:SetBackdropBorderColor(r, g, b)
end

function E.GetStaticPopup()
	local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
	frame:Hide()
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:SetSize(320, 72)
	frame:SetFrameStrata("TOOLTIP")
	E.BackdropTemplate(frame, "dialog", [[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
	frame:SetBackdropBorderColor(0, 0, 0)
	frame:SetScript("OnKeyDown", function(self, key)
		if key == "ESCAPE" then
			self:SetPropagateKeyboardInput(false)
			if self.cancel:IsShown() then
				self.cancel:Click()
			else
				self:Hide()
			end
		else
			self:SetPropagateKeyboardInput(true)
		end
	end)

	local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight-OmniCD")
	text:SetSize(290, 0)
	text:SetPoint("TOP", 0, -16)
	frame.text = text

	local function newButton(name)
		local button = CreateFrame("Button", nil, frame, "BackdropTemplate")
		button:SetSize(128, 21)
		E.BackdropTemplate(button)
		button:SetBackdropColor(0.2, 0.2, 0.2, 1)
		button:SetBackdropBorderColor(0, 0, 0, 1)
		button:SetScript("OnEnter", Button_OnEnter)
		button:SetScript("OnLeave", Button_OnLeave)
		button:SetNormalFontObject("GameFontNormal-OmniCD")
		button:SetHighlightFontObject("GameFontHighlight-OmniCD")
		button:SetText(name)
		return button
	end

	local accept = newButton(ACCEPT)
	accept:SetPoint("BOTTOMRIGHT", frame, "BOTTOM", -6, 16)
	frame.accept = accept

	local cancel = newButton(CANCEL)
	cancel:SetPoint("LEFT", accept, "RIGHT", 13, 0)
	frame.cancel = cancel

	return frame
end

local function StaticPopup_OnShow(self)
	local info = self.info
	local OnShow = info.OnShow
	if OnShow then
		OnShow(self, self.data, self.data2)
	end
end

local function StaticPopup_OnHide(self)
	local info = self.info
	local OnHide = info.OnHide
	if OnHide then
		OnHide(self, self.data, self.data2)
	end
end

local function StaticPopup_OnAccept(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
	local frame = self:GetParent()
	local info = frame.info
	local OnAccept = info.OnAccept
	if OnAccept then
		OnAccept(self, frame.data, frame.data2)
	end
	frame:Hide()
	self:SetScript("OnClick", nil)
	frame.cancel:SetScript("OnClick", nil)
end

local function StaticPopup_OnCancel(self)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
	local frame = self:GetParent()
	local info = frame.info
	local OnCancel = info.OnCancel
	if OnCancel then
		OnCancel(self, frame.data, frame.data2)
	end
	frame:Hide()
	self:SetScript("OnClick", nil)
	frame.accept:SetScript("OnClick", nil)
end

function E.StaticPopup_Show(which, text_arg1, text_arg2, data, data2)
	local info = E.StaticPopupDialogs[which]
	if not info then
		local dialog = StaticPopup_Show(which, text_arg1, text_arg2)
		if dialog then
			dialog.data = data
			dialog.data2 = data2
			dialog:SetFrameStrata("TOOLTIP")
		end
		return
	end

	if not E.popup then
		E.popup = E.GetStaticPopup()
	end
	local frame = E.popup
	local message = format(info.text, text_arg1 or "", text_arg2 or "")
	frame.text:SetText(message)
	local height = 61 + frame.text:GetHeight()
	frame:SetHeight(height)

	frame.info = info
	frame.data = data
	frame.data2 = data2

	frame.accept:SetText(info.button1 or ACCEPT)
	frame.cancel:SetText(info.button2 or CANCEL)
	frame:SetScript("OnShow", StaticPopup_OnShow)
	frame:SetScript("OnHide", StaticPopup_OnHide)
	frame.accept:SetScript("OnClick", StaticPopup_OnAccept)
	frame.cancel:SetScript("OnClick", StaticPopup_OnCancel)

	frame:Show()
end
