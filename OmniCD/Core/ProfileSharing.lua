local E, L, C = select(2, ...):unpack()

local PS = CreateFrame("Frame")
LibStub("AceSerializer-3.0"):Embed(PS)

local LibDeflate = LibStub("LibDeflate")
local ACD_Tooltip = E.Libs.ACD.tooltip
local Dialog

local function Button_OnLeave(self)
	local fadeIn = self.fadeIn
	if fadeIn:IsPlaying() then
		fadeIn:Stop()
	end
	self.fadeOut:Play()
end

local function Button_OnEnter(self)
	PlaySound(1217)
	local fadeOut = self.fadeOut
	if fadeOut:IsPlaying() then
		fadeOut:Stop()
	end
	self.fadeIn:Play()
end

local function Move_OnMouseDown(self, button)
	if button == "LeftButton" and not self.isMoving then
		self:StartMoving()
		self.isMoving = true
	end
end

local function Move_OnMouseUp(self, button)
	if button == "LeftButton" and self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = false
	end
end

local function ExportEditBox_OnTextChanged(self, userInput)
	if userInput then
		self:SetText(Dialog.text)
		self:HighlightText()
	else
		self:SetCursorPosition(Dialog.EditBox:GetNumLetters())
		Dialog.ScrollFrame:SetVerticalScroll(Dialog.ScrollFrame:GetVerticalScrollRange())
	end
end

local function ImportEditBox_OnTextChanged(self)
	self:SetCursorPosition(Dialog.EditBox:GetNumLetters())
	Dialog.ScrollFrame:SetVerticalScroll(Dialog.ScrollFrame:GetVerticalScrollRange())
end

local function EditBox_OnChar(self)
	self:SetText(Dialog.text)
	self:HighlightText()
end

local function ExportEditBox_OnEnter()
	ACD_Tooltip:SetOwner(Dialog.ScrollFrame, "ANCHOR_TOPRIGHT")
	ACD_Tooltip:SetText(L["Press Ctrl+C to copy profile"])
end

local function ImportEditBox_OnEnter()
	ACD_Tooltip:SetOwner(Dialog.ScrollFrame, "ANCHOR_TOPRIGHT")
	ACD_Tooltip:SetText(L["Press Ctrl+V to paste profile"])
end

function E.CreateFlashButton(parent, text, width, height, style)
	local Button = CreateFrame("Button", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	Button:SetSize(width or 80, height or 20)
	E.BackdropTemplate(Button, style)
	Button:SetBackdropColor(0.725, 0.008, 0.008)
	Button:SetBackdropBorderColor(0, 0, 0)
	Button:SetScript("OnEnter", Button_OnEnter)
	Button:SetScript("OnLeave", Button_OnLeave)
	Button:SetNormalFontObject(E.GameFontHighlight)

	Button:SetText(text or "")

	Button.bg = Button:CreateTexture(nil, "BORDER")
	if E.isClassic then
		Button.bg:SetAllPoints()
	else
		E.DisablePixelSnap(Button.bg)
		Button.bg:SetPoint("TOPLEFT", Button.TopEdge, "BOTTOMLEFT")
		Button.bg:SetPoint("BOTTOMRIGHT", Button.BottomEdge, "TOPRIGHT")
	end
	Button.bg:SetColorTexture(0.0, 0.6, 0.4)
	Button.bg:Hide()

	Button.fadeIn = Button.bg:CreateAnimationGroup()
	Button.fadeIn:SetScript("OnPlay", function() Button.bg:Show() end)
	local fadeIn = Button.fadeIn:CreateAnimation("Alpha")
	fadeIn:SetFromAlpha(0)
	fadeIn:SetToAlpha(1)
	fadeIn:SetDuration(0.4)
	fadeIn:SetSmoothing("OUT")

	Button.fadeOut = Button.bg:CreateAnimationGroup()
	Button.fadeOut:SetScript("OnFinished", function() Button.bg:Hide() end)
	local fadeOut = Button.fadeOut:CreateAnimation("Alpha")
	fadeOut:SetFromAlpha(1)
	fadeOut:SetToAlpha(0)
	fadeOut:SetDuration(0.3)
	fadeOut:SetSmoothing("OUT")

	return Button
end

function PS:ShowProfileDialog(text)
	if not Dialog then
		Dialog = CreateFrame("Frame", "OmniCD_ProfileDialog", UIParent, "DialogBoxFrame")
		Dialog:SetPoint("CENTER")
		Dialog:SetSize(600, 400)
		Dialog:SetFrameStrata("FULLSCREEN_DIALOG")
		E.BackdropTemplate(Dialog)
		Dialog:SetBackdropColor(0.05, 0.05, 0.05, 0.9)
		Dialog:SetBackdropBorderColor(0.3, 0.3, 0.3)
		Dialog:SetMovable(true)
		Dialog:SetClampedToScreen(true)

		Dialog:SetResizable(true)
		if Dialog.SetResizeBounds then
			Dialog:SetResizeBounds(180, 100)
		else
			Dialog:SetMinResize(180, 100)
		end
		Dialog:SetScript("OnMouseDown", Move_OnMouseDown)
		Dialog:SetScript("OnMouseUp", Move_OnMouseUp)
		Dialog:SetScript("OnShow", function(self)
			self.EditBox:SetFocus()
			self.EditBox:HighlightText()
		end)


		local Label = Dialog:CreateFontString(nil, "ARTWORK", "GameFontNormal-OmniCD")
		Label:SetPoint("TOP", 0, -1)


		_G.OmniCD_ProfileDialogButton:Hide()

		local CloseButton = E.CreateFlashButton(Dialog, CLOSE)
		CloseButton:SetPoint("BOTTOM", 0, 16)
		CloseButton:SetScript("OnClick", function(self)
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION)
			self:GetParent():Hide()
		end)

		local DecodeButton = E.CreateFlashButton(Dialog, L["Decode"])
		DecodeButton:SetPoint("BOTTOMRIGHT", Dialog, "BOTTOM", -2, 16)
		DecodeButton:SetScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
			local profileType, profileKey = PS:ImportProfile(Dialog.EditBox:GetText())
			if profileType then
				profileKey = profileType == "cds" and "" or format("%s: |cffffd200%s|r", L["Profile"], profileKey)
				profileType = format(L["Profile Type: %s%s|r"], "|cffffd200", PS.profileTypeValues[profileType])
				Dialog.EditBox:SetText(format("%s\n%s\n%s\n\n%s", L["Profile decoded successfully!"], profileType, profileKey, L["Pending user input..."]))
			else
				Dialog.EditBox:SetText(PS.errorMsg)
			end
		end)


		local Resizer = CreateFrame("Button", "OmniCD_ProfileDialogResizeButton", Dialog)






		Resizer:SetPoint("BOTTOMRIGHT", -8, 8)
		Resizer:SetSize(16, 16)
		Resizer:SetNormalTexture([[Interface\AddOns\OmniCD\Media\omnicd-bullet-resizer]])
		local Resizer_Normal = Resizer:GetNormalTexture()
		Resizer_Normal:SetPoint("BOTTOMRIGHT")
		Resizer_Normal:SetPoint("TOPLEFT", Resizer, "CENTER")
		Resizer:SetScript("OnMouseDown", function(_, button)
			if button == "LeftButton" then
				Dialog:StartSizing("BOTTOMRIGHT")
			end
		end)
		Resizer:SetScript("OnMouseUp", function(self, button)
			Dialog:StopMovingOrSizing()

		end)


		local ScrollContainer = CreateFrame("Frame", "OmniCD_ProfileDialogScrollContainer", Dialog, BackdropTemplateMixin and "BackdropTemplate" or nil)
		ScrollContainer:SetPoint("TOPLEFT", 18, -28)
		ScrollContainer:SetPoint("BOTTOMRIGHT", -38, 50)
		E.BackdropTemplate(ScrollContainer)
		ScrollContainer:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
		ScrollContainer:SetBackdropBorderColor(0, 0, 0)


		local ScrollFrame = CreateFrame("ScrollFrame", "OmniCD_ProfileDialogScrollFrame", ScrollContainer, "UIPanelScrollFrameTemplate")
		ScrollFrame:SetPoint("TOPLEFT", 5, -10)
		ScrollFrame:SetPoint("BOTTOMRIGHT", -5, 10)
		ScrollFrame:SetScript("OnMouseDown", function()
			Dialog.EditBox:SetFocus()
		end)
		ScrollFrame:SetScript("OnSizeChanged", function(self)
			if Dialog.EditBox then
				Dialog.EditBox:SetWidth(self:GetWidth())
			end
		end)
		ScrollFrame:SetScript("OnLeave", function()
			ACD_Tooltip:Hide()
		end)


		local ScrollBar = _G["OmniCD_ProfileDialogScrollFrameScrollBar"]
		ScrollBar:ClearAllPoints()
		ScrollBar:SetPoint("TOPLEFT", ScrollContainer, "TOPRIGHT", 4, -1)
		ScrollBar:SetPoint("BOTTOMLEFT", ScrollContainer, "BOTTOMRIGHT", 4, 1)



		ScrollBar.ScrollUpButton:SetNormalTexture(0)
		ScrollBar.ScrollUpButton:SetPushedTexture(0)
		ScrollBar.ScrollUpButton:SetDisabledTexture(0)
		ScrollBar.ScrollUpButton:SetHighlightTexture(0)
		ScrollBar.ScrollDownButton:SetNormalTexture(0)
		ScrollBar.ScrollDownButton:SetPushedTexture(0)
		ScrollBar.ScrollDownButton:SetDisabledTexture(0)
		ScrollBar.ScrollDownButton:SetHighlightTexture(0)
		ScrollBar.ThumbTexture:SetTexture([[Interface\BUTTONS\White8x8]])
		ScrollBar.ThumbTexture:SetSize(16, 32)
		ScrollBar.ThumbTexture:SetColorTexture(0.3, 0.3, 0.3)
		ScrollBar.BG = ScrollBar:CreateTexture(nil, "BACKGROUND")
		ScrollBar.BG:SetAllPoints()
		ScrollBar.BG:SetColorTexture(0, 0, 0, 0.4)


		local EditBox = CreateFrame("EditBox", "OmniCD_ProfileDialogEditBox", ScrollFrame)
		EditBox:SetSize(ScrollFrame:GetSize())
		EditBox:SetMultiLine(true)
		EditBox:SetAutoFocus(false)
		EditBox:SetFontObject(E.GameFontHighlight)
		EditBox:SetScript("OnEscapePressed", function(self)
			self:ClearFocus()
		end)
		EditBox:SetScript("OnEditFocusGained", function(self)
			self:HighlightText()
		end)
		EditBox:SetScript("OnEditFocusLost", function(self)
			self:HighlightText(0, 0)
		end)
		EditBox:SetScript("OnLeave", function()
			ACD_Tooltip:Hide()
		end)
		ScrollFrame:SetScrollChild(EditBox)

		Dialog.Label = Label
		Dialog.CloseButton = CloseButton
		Dialog.DecodeButton = DecodeButton
		Dialog.ScrollFrame = ScrollFrame
		Dialog.ScrollBar = ScrollBar
		Dialog.EditBox = EditBox
	end

	if text then


		Dialog.Label:SetText(L["Export Profile"])
		Dialog.DecodeButton:Hide()
		Dialog.CloseButton:ClearAllPoints()
		Dialog.CloseButton:SetPoint("BOTTOM", 0, 16)
		Dialog.EditBox:SetText(text)
		Dialog.EditBox:SetFocus()
		Dialog.EditBox:HighlightText()
		Dialog.EditBox:SetScript("OnTextChanged", ExportEditBox_OnTextChanged)
		Dialog.EditBox:SetScript("OnChar", EditBox_OnChar)
		Dialog.EditBox:SetScript("OnEnter", ExportEditBox_OnEnter)
		Dialog.ScrollFrame:SetScript("OnEnter", nil)
	else


		Dialog.Label:SetText(L["Import Profile"])
		Dialog.DecodeButton:Show()
		Dialog.CloseButton:ClearAllPoints()
		Dialog.CloseButton:SetPoint("BOTTOMLEFT", Dialog, "BOTTOM", 2, 16)
		Dialog.EditBox:SetText("")
		Dialog.EditBox:SetFocus()
		Dialog.EditBox:SetScript("OnTextChanged", ImportEditBox_OnTextChanged)
		Dialog.EditBox:SetScript("OnChar", nil)
		Dialog.EditBox:SetScript("OnEnter", ImportEditBox_OnEnter)
		Dialog.ScrollFrame:SetScript("OnEnter", ImportEditBox_OnEnter)
	end

	Dialog.text = text
	Dialog:Show()
end

local function ErrorMessage(text)
	PS.errorMsg = "|cffff2020" .. text
end

function PS:Decode(encodedData)
	self.errorMsg = ""

	local compressedData = LibDeflate:DecodeForPrint(encodedData)
	if not compressedData then
		ErrorMessage(L["Decode failed!"])
		return
	end

	local serializedData = LibDeflate:DecompressDeflate(compressedData)
	if not serializedData then
		ErrorMessage(L["Decompress failed!"])
		return
	end

	local appendage
	serializedData = gsub(serializedData, "%^%^(.+)", function(str)
		appendage = str
		return "^^"
	end)

	if not appendage or not strfind(appendage, E.AddOn) then
		ErrorMessage(L["Not an OmniCD profile!"])
		return
	end

	appendage = gsub(appendage, "^OmniCD", "")
	local profileType, profileKey = strsplit(",", appendage, 2)

	local success, profileData = self:Deserialize(serializedData)
	if not success then
		ErrorMessage(L["Deserialize failed!"])
		return
	end

	return profileType, profileKey, profileData
end

function PS:CopyCustomSpells(profileData)
	for k, v in pairs(profileData) do
		OmniCDDB.cooldowns[k] = v
	end
end

function PS:CopyProfile(profileType, profileKey, profileData)
	if profileType == "all" then
		OmniCDDB.profiles[profileKey] = profileData
	else
		local currentProfile = E.DB:GetCurrentProfile()
		OmniCDDB.profiles[profileKey] = E:DeepCopy(OmniCDDB.profiles[currentProfile])
		OmniCDDB.profiles[profileKey].Party[profileType] = profileData
	end

	E.DB:SetProfile(profileKey)
end

function PS:ImportProfile(encodedData)
	local profileType, profileKey, profileData = self:Decode(encodedData)
	if not profileData then
		return
	end

	local prefix = "[IMPORT-%s]%s"
	local n = 1
	local key
	while true do
		key = format(prefix, n, profileKey)
		if not OmniCDDB.profiles[key] then
			profileKey = key
			break
		end
		n = n + 1
	end

	if profileType == "cds" then
		E.StaticPopup_Show("OMNICD_IMPORT_EDITOR", nil, nil, profileData)
	else
		E.StaticPopup_Show("OMNICD_IMPORT_PROFILE", format("|cffffd200%s|r", profileKey), nil, {profileType=profileType, profileKey=profileKey, profileData=profileData})
	end

	return profileType, profileKey
end


local blackList = {
	modules = true,
}

function PS:ExportProfile(profileType)
	self.errorMsg = ""

	local profileKey = E.DB:GetCurrentProfile()
	local profileData
	if profileType == "cds" then
		profileData = E:DeepCopy(OmniCDDB.cooldowns)
	elseif profileType == "all" then
		profileData = E:DeepCopy(OmniCDDB.profiles[profileKey], blackList)
		profileData = E:RemoveEmptyDuplicateTables(profileData, C)
	else
		profileData = E:DeepCopy(OmniCDDB.profiles[profileKey].Party[profileType])
		profileData = E:RemoveEmptyDuplicateTables(profileData, C.Party[profileType])
	end

	if not profileData then
		ErrorMessage(L["Profile unchanged from default!"])
		return
	end

	if next(profileData) == nil then
		ErrorMessage(L["Profile is empty!"])
		return
	end

	profileKey = gsub(profileKey, "^%[IMPORT.-%]", "")

	local serializedData = self:Serialize(profileData)
	if type(serializedData) ~= "string" then
		ErrorMessage(L["Serialize failed!"])
	end

	serializedData = format("%sOmniCD%s,%s", serializedData, profileType, profileKey)

	local compressedData = LibDeflate:CompressDeflate(serializedData)
	local encodedData = LibDeflate:EncodeForPrint(compressedData)

	return profileKey, encodedData
end

E["ProfileSharing"] = PS
