---------------------------------------------------------
-- Module declaration
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local HN = HandyNotes:GetModule("HandyNotes")
local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)

local info = {}
local backdrop2 = {
	bgFile = nil,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

-- Create the main frame
-- For jncl (Skinner), this frame is accessed by LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame
local HNEditFrame = CreateFrame("Frame", "HNEditFrame", UIParent)
HN.HNEditFrame = HNEditFrame
HNEditFrame:Hide()
HNEditFrame:SetWidth(350)
HNEditFrame:SetHeight(235)
HNEditFrame:SetPoint("BOTTOM", 0, 90)
HNEditFrame:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
--HNEditFrame:SetBackdropColor(0, 0, 0, 0.75)
HNEditFrame:SetBackdropColor(0,0,0,1)
HNEditFrame:EnableMouse(true)
HNEditFrame:SetToplevel(true)
HNEditFrame:SetClampedToScreen(true)
HNEditFrame:SetMovable(true)
HNEditFrame:SetFrameStrata("FULLSCREEN")
HNEditFrame.titleTexture = HNEditFrame:CreateTexture(nil, "ARTWORK")
HNEditFrame.titleTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
HNEditFrame.titleTexture:SetWidth(300)
HNEditFrame.titleTexture:SetHeight(64)
HNEditFrame.titleTexture:SetPoint("TOP", 0, 12)
--HNEditFrame.titleTexture = temp
HNEditFrame.title = HNEditFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
HNEditFrame.title:SetPoint("TOP", 0, -3)
HNEditFrame.title:SetText(L["Add Handy Note"])

-- This creates a transparent textureless draggable frame to move HNEditFrame
-- It overlaps the above title text and texture (more or less) exactly.
local temp = CreateFrame("Frame", nil, HNEditFrame)
temp:SetWidth(150)
temp:SetHeight(30)
temp:SetPoint("TOP", 0, 8)
temp:EnableMouse(true)
temp:RegisterForDrag("LeftButton")
temp:SetScript("OnDragStart", function(self)
	self:GetParent():StartMoving()
end)
temp:SetScript("OnDragStop", function(self)
	self:GetParent():StopMovingOrSizing()
end)

-- Create the Close button
HNEditFrame.CloseButton = CreateFrame("Button", nil, HNEditFrame, "UIPanelCloseButton")
HNEditFrame.CloseButton:SetPoint("TOPRIGHT", -2, -1)
HNEditFrame.CloseButton:SetHitRectInsets(5, 5, 5, 5)

-- Create and position the Title text string
HNEditFrame.titletext = HNEditFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
HNEditFrame.titletext:SetPoint("TOPLEFT", 25, -28)
HNEditFrame.titletext:SetText(L["Title"])

-- Create the Title Input Box and position it below the text
HNEditFrame.titleinputframe = CreateFrame("Frame", nil, HNEditFrame)
HNEditFrame.titleinputframe:SetWidth(300)
HNEditFrame.titleinputframe:SetHeight(24)
HNEditFrame.titleinputframe:SetBackdrop(backdrop2)
HNEditFrame.titleinputframe:SetPoint("TOPLEFT", HNEditFrame.titletext, "BOTTOMLEFT", 0, 0)
HNEditFrame.titleinputbox = CreateFrame("EditBox", nil, HNEditFrame.titleinputframe)
HNEditFrame.titleinputbox:SetWidth(290)
HNEditFrame.titleinputbox:SetHeight(24)
HNEditFrame.titleinputbox:SetMaxLetters(100)
HNEditFrame.titleinputbox:SetNumeric(false)
HNEditFrame.titleinputbox:SetAutoFocus(false)
HNEditFrame.titleinputbox:SetFontObject("GameFontHighlightSmall")
HNEditFrame.titleinputbox:SetPoint("TOPLEFT", 5, 1)
HNEditFrame.titleinputbox:SetScript("OnShow", HNEditFrame.titleinputbox.SetFocus)
HNEditFrame.titleinputbox:SetScript("OnEscapePressed", HNEditFrame.titleinputbox.ClearFocus)

-- Create and position the Description text string
HNEditFrame.desctext = HNEditFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
HNEditFrame.desctext:SetPoint("TOPLEFT", HNEditFrame.titleinputframe, "BOTTOMLEFT", 0, 0)
HNEditFrame.desctext:SetText(L["Description/Notes:"])

-- Create the ScrollFrame for the Description Edit Box
HNEditFrame.descframe = CreateFrame("Frame", nil, HNEditFrame)
HNEditFrame.descframe:SetWidth(300)
HNEditFrame.descframe:SetHeight(67)
HNEditFrame.descframe:SetBackdrop(backdrop2)
HNEditFrame.descframe:SetPoint("TOPLEFT", HNEditFrame.desctext, "BOTTOMLEFT", 0, 0)
HNEditFrame.descscrollframe = CreateFrame("ScrollFrame", "HandyNotes_EditScrollFrame", HNEditFrame.descframe, "UIPanelScrollFrameTemplate")
HNEditFrame.descscrollframe:SetWidth(269)
HNEditFrame.descscrollframe:SetHeight(59)
HNEditFrame.descscrollframe:SetPoint("TOPLEFT", 5, -4)
-- Create the Description Input Box and position it below the text
HNEditFrame.descinputbox = CreateFrame("EditBox", nil, HNEditFrame)
HNEditFrame.descinputbox:SetWidth(269) -- Height is auto set in a multiline editbox
HNEditFrame.descinputbox:SetMaxLetters(512)
HNEditFrame.descinputbox:SetNumeric(false)
HNEditFrame.descinputbox:SetAutoFocus(false)
HNEditFrame.descinputbox:SetFontObject("GameFontHighlightSmall")
HNEditFrame.descinputbox:SetMultiLine(true)
HNEditFrame.descinputbox:SetScript("OnCursorChanged", function(self, x, y, w, h)
	local scrollFrame = self:GetParent()
	local height = scrollFrame:GetHeight()
	local range = scrollFrame:GetVerticalScrollRange()
	local scroll = scrollFrame:GetVerticalScroll()
	local cursorOffset = -y
	while ( cursorOffset < scroll ) do
		scroll = (scroll - (height / 2))
		if ( scroll < 0 ) then
			scroll = 0
		end
		scrollFrame:SetVerticalScroll(scroll)
	end
	while ( (cursorOffset + h) > (scroll + height) and scroll < range ) do
		scroll = (scroll + (height / 2))
		if ( scroll > range ) then
			scroll = range
		end
		scrollFrame:SetVerticalScroll(scroll)
	end
end)
HNEditFrame.descinputbox:SetScript("OnEscapePressed", HNEditFrame.descinputbox.ClearFocus)
-- Attach the ScrollChild to the ScrollFrame
HNEditFrame.descscrollframe:SetScrollChild(HNEditFrame.descinputbox)

-- Create the Icon Dropdown
HNEditFrame.icondropdown = CreateFrame("Frame", "HandyNotes_IconDropDown", HNEditFrame, "UIDropDownMenuTemplate")
HNEditFrame.icondropdown:SetPoint("TOPLEFT", HNEditFrame.descframe, "BOTTOMLEFT", -17, 0)
HNEditFrame.icondropdown:SetHitRectInsets(16, 16, 0, 0)
UIDropDownMenu_SetWidth(HNEditFrame.icondropdown, 120)
UIDropDownMenu_EnableDropDown(HNEditFrame.icondropdown)
HNEditFrame.icondropdown.displayMode = "MENU"
HNEditFrame.icondropdown.texture = HNEditFrame.icondropdown:CreateTexture(nil, "OVERLAY")
HNEditFrame.icondropdown.texture:SetWidth(12)
HNEditFrame.icondropdown.texture:SetHeight(12)
HNEditFrame.icondropdown.texture:SetPoint("RIGHT", HNEditFrame.icondropdown, -41, 2)
HNEditFrame.icondropdown.Text:SetPoint("RIGHT", HNEditFrame.icondropdown.texture, "LEFT", -3, 0)
HNEditFrame.icondropdown.Text:SetWidth(HNEditFrame.icondropdown.Text:GetWidth() - 9)
HNEditFrame.icondropdown.OnClick = function(button, value)
	local t = HN.icons[value]
	HNEditFrame.icondropdown.selectedValue = value
	HNEditFrame.icondropdown.texture:SetTexture(t.icon)
	if t.tCoordLeft then
		HNEditFrame.icondropdown.texture:SetTexCoord(t.tCoordLeft, t.tCoordRight, t.tCoordTop, t.tCoordBottom)
	else
		HNEditFrame.icondropdown.texture:SetTexCoord(0, 1, 0, 1)
	end
	HNEditFrame.icondropdown.Text:SetText(t.text)
	local color = t.color
	if color then
		HNEditFrame.icondropdown.Text:SetTextColor(color.r, color.g, color.b, color.a or 1)
	else
		HNEditFrame.icondropdown.Text:SetTextColor(1, 1, 1, 1)
	end
end
HNEditFrame.icondropdown.initialize = function(level)
	wipe(info)
	for i = 1, #HN.icons do
		local t = HN.icons[i]
		info.text = t.text
		info.icon = t.icon
		info.tCoordLeft = t.tCoordLeft
		info.tCoordRight = t.tCoordRight
		info.tCoordTop = t.tCoordTop
		info.tCoordBottom = t.tCoordBottom
		info.arg1 = i
		info.func = HNEditFrame.icondropdown.OnClick
		info.checked = HNEditFrame.icondropdown.selectedValue == i
		info.keepShownOnClick = nil
		UIDropDownMenu_AddButton(info)
	end
end

-- Create the Show on Continent checkbox
HNEditFrame.continentcheckbox = CreateFrame("CheckButton", nil, HNEditFrame, "UICheckButtonTemplate")
HNEditFrame.continentcheckbox:SetWidth(24)
HNEditFrame.continentcheckbox:SetHeight(24)
HNEditFrame.continentcheckbox:SetPoint("LEFT", HNEditFrame.icondropdown, "RIGHT", -10, 2)
HNEditFrame.continentcheckbox.string = HNEditFrame.continentcheckbox:CreateFontString()
HNEditFrame.continentcheckbox.string:SetWidth(153)
HNEditFrame.continentcheckbox.string:SetJustifyH("LEFT")
HNEditFrame.continentcheckbox.string:SetPoint("LEFT", 24, 1)
HNEditFrame.continentcheckbox:SetFontString(HNEditFrame.continentcheckbox.string)
HNEditFrame.continentcheckbox:SetNormalFontObject("GameFontNormalSmall")
HNEditFrame.continentcheckbox:SetHighlightFontObject("GameFontHighlightSmall")
HNEditFrame.continentcheckbox:SetDisabledFontObject("GameFontDisableSmall")
HNEditFrame.continentcheckbox:SetText(L["Show on continent map"])
HNEditFrame.continentcheckbox:SetChecked(true)
HNEditFrame.continentcheckbox:SetHitRectInsets(0, -HNEditFrame.continentcheckbox.string:GetStringWidth(), 0, 0)
HNEditFrame.continentcheckbox:SetPushedTextOffset(0, 0)

-- Create the OK button
HNEditFrame.okbutton = CreateFrame("Button", nil, HNEditFrame, "OptionsButtonTemplate")
HNEditFrame.okbutton:SetWidth(150)
HNEditFrame.okbutton:SetHeight(22)
HNEditFrame.okbutton:SetPoint("TOPLEFT", HNEditFrame.leveldropdown or HNEditFrame.icondropdown, "BOTTOMLEFT", 15, 0)
HNEditFrame.okbutton:SetText(OKAY)

-- Create the Cancel button
HNEditFrame.cancelbutton = CreateFrame("Button", nil, HNEditFrame, "OptionsButtonTemplate")
HNEditFrame.cancelbutton:SetWidth(150)
HNEditFrame.cancelbutton:SetHeight(22)
HNEditFrame.cancelbutton:SetPoint("LEFT", HNEditFrame.okbutton, "RIGHT", 3, 0)
HNEditFrame.cancelbutton:SetText(CANCEL)
HNEditFrame.cancelbutton:SetScript("OnClick", HNEditFrame.CloseButton:GetScript("OnClick"))

-- Additional Behavior functions
HNEditFrame:SetScript("OnMouseDown", function(self, button)
	if MouseIsOver(HNEditFrame.descframe) and button == "LeftButton" then
		HNEditFrame.descinputbox:SetFocus()
	end
end)
HNEditFrame.titleinputbox:SetScript("OnTabPressed", function(self)
	HNEditFrame.descinputbox:SetFocus()
end)
HNEditFrame.descinputbox:SetScript("OnTabPressed", function(self)
	HNEditFrame.titleinputbox:SetFocus()
end)
-- Makes ESC key close HNEditFrame
tinsert(UISpecialFrames, "HNEditFrame")


---------------------------------------------------------
-- OnShow function to show a note for adding or editing

HNEditFrame:SetScript("OnShow", function(self)
	local data = HN.db.global[self.mapID][self.coord]
	if data then
		HNEditFrame.title:SetText(L["Edit Handy Note"])
		HNEditFrame.titleinputbox:SetText(data.title)
		HNEditFrame.descinputbox:SetText(data.desc)
		HNEditFrame.icondropdown.OnClick(nil, data.icon)
		HNEditFrame.continentcheckbox:SetChecked(data.cont)
	else
		HNEditFrame.title:SetText(L["Add Handy Note"])
		HNEditFrame.titleinputbox:SetText("")
		HNEditFrame.descinputbox:SetText("")
		HNEditFrame.icondropdown.OnClick(nil, 1)
		HNEditFrame.continentcheckbox:SetChecked(nil)
	end
	if WorldMapFrame:IsShown() then
		self:SetParent(WorldMapFrame)
		self:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 20)
	else
		self:SetParent(UIParent)
		self:SetFrameLevel(10) --self:SetFrameStrata("DIALOG")
	end
end)


---------------------------------------------------------
-- OnClick function to accept the changes for a new/edited note

HNEditFrame.okbutton:SetScript("OnClick", function(self)
	local data = HN.db.global[HNEditFrame.mapID][HNEditFrame.coord]
	if not data then
		data = {}
		HN.db.global[HNEditFrame.mapID][HNEditFrame.coord] = data
	end
	data.title = HNEditFrame.titleinputbox:GetText()
	data.desc = HNEditFrame.descinputbox:GetText()
	data.icon = HNEditFrame.icondropdown.selectedValue
	data.cont = HNEditFrame.continentcheckbox:GetChecked()
	HNEditFrame:Hide()
	HN:SendMessage("HandyNotes_NotifyUpdate", "HandyNotes")
end)
