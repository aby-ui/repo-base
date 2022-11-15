local AddonName, Data = ...

Data.Templates = Data.Templates or {}

Data.Templates.IconSelectorPopupFrameTemplate = function(parent)
	local frame = CreateFrame("frame", nil, parent)
	Mixin(frame, Data.Mixins.BackportedIconSelectorPopupFrameTemplateMixin)
	frame:SetSize(525, 495)
	frame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
	frame.BG = frame:CreateTexture(nil, "BACKGROUND")
	frame.BG:SetPoint("TOPLEFT", 7, -7)
	frame.BG:SetPoint("BOTTOMRIGHT", -7, 7)
	frame.BG:SetColorTexture(0, 0, 0, 0.80)
	local borderBox = Data.Templates.SelectionFrameTemplate(frame)
	borderBox:SetAllPoints(true)
	borderBox:SetFrameLevel(50)
	borderBox.EditBoxHeaderText = borderBox:CreateFontString(nil, "BORDER", "GameFontHighlightSmall")
	borderBox.EditBoxHeaderText:SetPoint("TOPLEFT", 24, -21)

	borderBox.IconSelectionText = borderBox:CreateFontString(nil, "BORDER", "GameFontHighlightSmall")
	borderBox.IconSelectionText:SetPoint("TOPLEFT", 24, -69)
	borderBox.IconSelectionText:SetText(MACRO_POPUP_CHOOSE_ICON)

	local selectionIconArea = CreateFrame("Frame", nil, borderBox)
	selectionIconArea:SetSize(275, 45)
	selectionIconArea:SetPoint("TOPRIGHT", -13, -13)

	local selectedIconButton = CreateFrame("Button", nil, selectionIconArea)
	Mixin(selectedIconButton, Data.Mixins.BackportedSelectedIconButtonMixin)
	selectedIconButton:SetSize(36, 36)
	selectedIconButton:SetPoint("TOPRIGHT", -4.5, -3.5)
	local backgroundTexture = selectedIconButton:CreateTexture(nil, "BACKGROUND")
	backgroundTexture:SetTexture("Interface\\Buttons\\UI-EmptySlot-Disabled")
	backgroundTexture:SetSize(45, 45)
	backgroundTexture:SetPoint("CENTER", 0, -1)
	backgroundTexture:SetTexCoord(0.140625, 0.84375, 0.140625, 0.84375)


	selectedIconButton.SelectedTexture = selectedIconButton:CreateTexture(nil, "OVERLAY")
	selectedIconButton.SelectedTexture:SetBlendMode("ADD")
	selectedIconButton.SelectedTexture:SetTexture("Interface\\Buttons\\CheckButtonHilight")
	selectedIconButton.SelectedTexture:Hide()
	selectedIconButton:SetScript("OnClick", selectedIconButton.OnClick)
	selectedIconButton.Icon = selectedIconButton:GetNormalTexture()
	if not selectedIconButton.Icon then
		selectedIconButton.Icon = selectedIconButton:SetNormalTexture(0)
		selectedIconButton.Icon = selectedIconButton:GetNormalTexture()
	end
	selectedIconButton.Icon:SetSize(36, 36)
	selectedIconButton.Icon:SetPoint("CENTER", 0, -1)


	selectedIconButton.Highlight = selectedIconButton:GetHighlightTexture()
	if not selectedIconButton.Highlight then
		selectedIconButton.Highlight = selectedIconButton:SetHighlightTexture(0)
		selectedIconButton.Highlight = selectedIconButton:GetHighlightTexture()
	end

	selectedIconButton.Highlight:SetBlendMode("ADD")
	selectedIconButton.Highlight:SetTexture("Interface\\Buttons\\ButtonHilight-Square")


	selectionIconArea.SelectedIconButton = selectedIconButton
	local selectedIconText = CreateFrame("frame", nil, selectionIconArea, "VerticalLayoutFrame")
	selectedIconText:SetPoint("TOPRIGHT", -46, -10.5)

	selectedIconText.spacing = 2
	selectedIconText.expand = true

	selectedIconText.SelectedIconHeader = selectedIconText:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	selectedIconText.SelectedIconHeader.layoutIndex = 1
	selectedIconText.SelectedIconHeader.align = "right"

	selectedIconText.SelectedIconDescription = selectedIconText:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	selectedIconText.SelectedIconDescription.layoutIndex = 2
	selectedIconText.SelectedIconDescription.align = "right"

	selectionIconArea.SelectedIconText = selectedIconText

	borderBox.SelectedIconArea = selectionIconArea

	local iconDragArea = CreateFrame("Frame", nil, borderBox)
	iconDragArea:Hide()
	iconDragArea:SetSize(499, 391)
	iconDragArea:SetPoint("TOPLEFT", 13, -68)
	borderBox.IconDragArea = iconDragArea

	local iconDragAreaContent = CreateFrame("Frame", nil, iconDragArea, "HorizontalLayoutFrame")
	iconDragAreaContent.spacing = 5
	iconDragAreaContent.expand = true
	iconDragAreaContent:SetPoint("CENTER")
	local plusIcon = iconDragAreaContent:CreateTexture(nil, "OVERLAY")
	plusIcon.layoutIndex = 1
	plusIcon:SetAtlas("communities-icon-addchannelplus", true)
	plusIcon:SetBlendMode("ADD")
	iconDragAreaContent.PlusIcon = plusIcon

	local iconDragText = iconDragAreaContent:CreateFontString(nil, "OVERLAY", "GameFontGreenLarge")
	iconDragText:SetText(ICON_SELECTION_DRAG)
	iconDragText.layoutIndex = 2
	iconDragAreaContent.IconDragText = iconDragText
	borderBox.IconDragArea.IconDragAreaContent = iconDragAreaContent

	local iconSelectorEditBox = CreateFrame("EditBox", nil, borderBox)
	Mixin(iconSelectorEditBox, Data.Mixins.BackportedIconSelectorEditBoxMixin)
	iconSelectorEditBox:SetSize(182, 20)
	iconSelectorEditBox:SetPoint("TOPLEFT", 29, -35)
	iconSelectorEditBox:SetFontObject(GameFontNormal)

	local iconSelectorPopupNameLeft = iconSelectorEditBox:CreateTexture(nil, "BACKGROUND")
	iconSelectorPopupNameLeft:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	iconSelectorPopupNameLeft:SetSize(12, 29)
	iconSelectorPopupNameLeft:SetPoint("TOPLEFT", -11, 0)
	iconSelectorPopupNameLeft:SetTexCoord(0, 0.09375, 0, 1.0)
	iconSelectorEditBox.IconSelectorPopupNameLeft = iconSelectorPopupNameLeft

	local iconSelectorPopupNameMiddle = iconSelectorEditBox:CreateTexture(nil, "BACKGROUND")
	iconSelectorPopupNameMiddle:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	iconSelectorPopupNameMiddle:SetSize(175, 29)
	iconSelectorPopupNameMiddle:SetPoint("LEFT", iconSelectorPopupNameLeft, "RIGHT")
	iconSelectorPopupNameMiddle:SetTexCoord(0.09375, 0.90625, 0, 1.0)
	iconSelectorEditBox.IconSelectorPopupNameMiddle = iconSelectorPopupNameMiddle

	local iconSelectorPopupNameRight = iconSelectorEditBox:CreateTexture(nil, "BACKGROUND")
	iconSelectorPopupNameRight:SetTexture("Interface\\ClassTrainerFrame\\UI-ClassTrainer-FilterBorder")
	iconSelectorPopupNameRight:SetSize(12, 29)
	iconSelectorPopupNameRight:SetPoint("LEFT", iconSelectorPopupNameMiddle, "RIGHT")
	iconSelectorPopupNameRight:SetTexCoord(0.90625, 1.0, 0, 1.0)
	iconSelectorEditBox.IconSelectorPopupNameRight = iconSelectorPopupNameRight


	iconSelectorEditBox:SetScript("OnTextChanged", iconSelectorEditBox.OnTextChanged)
	iconSelectorEditBox:SetScript("OnEscapePressed", iconSelectorEditBox.OnEscapePressed)
	iconSelectorEditBox:SetScript("OnEnterPressed", iconSelectorEditBox.OnEnterPressed)
	borderBox.IconSelectorEditBox = iconSelectorEditBox

	frame.BorderBox = borderBox

	frame.IconSelector = Data.Templates.ScrollBoxSelectorTemplate(frame)
	frame.IconSelector:SetFrameStrata("HIGH")
	frame.IconSelector:SetPoint("TOPLEFT", 21, -84)
	return frame
end