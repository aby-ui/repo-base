-----------------------------------------------------------
-- ModularOptionFrame.lua
-----------------------------------------------------------
-- Create main option frame and modular categories for complicated
-- addons contain multiple modules.
--
-- Abin
-- 2013-10-18

-----------------------------------------------------------
-- API reference
-----------------------------------------------------------

-- frame = UICreateModularOptionFrame("name", "title", ["version", [, "button1" [, "button2" [, ... ]]]]) -- Create the option frame
-- frame:Toggle() -- Toggles show/hide stats of the frame
-- frame:SetWaterMarkText("text") -- Display a watermark text (gray and small) at bottom-left corner
-- frame:AddCategory("key", "title" [, "desc" [, "parent" ]]) -- Add a category, returns category data if succeeds, "parent" can be key(string) or category(table)
-- frame:FindCategory("key") -- Find a category by key, returns category data if exists
-- frame:GetOpenedCategory() -- Returns the currently opened category data
-- frame:OpenToCategory("key") -- Open page for a category by key
-- frame:OpenToCategory(category) -- Open page for a category
-- frame:SetCategoryListWidth(width) -- Specifies the category list width of the frame
-- frame:GetOperationButton(index) -- Returns an operation button by index
-- frame:GetOperationButton("text") -- Returns an operation button by button label

-----------------------------------------------------------
-- Callback functions
-----------------------------------------------------------

-- frame:OnCategorySelect(category) -- Called when a category is deselected
-- frame:OnCategoryDeselect(category) -- Called when a category is deselected

-- frame:OnOperation1(button) -- Called when the 1st operation button is clicked
-- frame:OnOperation2(button) -- Called when the 2nd operation button is clicked
-- ...                        -- ...
-- frame:OnOperationN(button) -- Called when the N-th operation button is clicked

-- optionPage:OnVerticalScrollUpdate(range, offset) -- Called when the vertical scroll range/offset of the selected option page is changed

-----------------------------------------------------------

local type = type
local CreateFrame = CreateFrame
local tostring = tostring
local tinsert = tinsert
local floor = floor
local ipairs = ipairs
local GetTime = GetTime
local UISpecialFrames = UISpecialFrames
local UIParent = UIParent
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT
local GAME_VERSION_LABEL = GAME_VERSION_LABEL

local MAJOR_VERSION = 1
local MINOR_VERSION = 6

local BUTTON_HEIGHT = 20

-- To prevent older libraries from over-riding newer ones...
if type(UICreateModularOptionFrame_IsNewerVersion) == "function" and not UICreateModularOptionFrame_IsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end

-- Recursive function for calculating the effective height of a given branch
local function GetBranchHeight(self)
	local height = BUTTON_HEIGHT
	if self.expanded then
		local i
		for i = 1, #self.nodes do
			height = height + GetBranchHeight(self.nodes[i])
		end
	end
	return height
end

-- Check whether "child" is a branch child of "self"
local function IsBranchChild(self, child)
	while child ~= self.catList do
		if child == self then
			return 1
		end
		child = child:GetParent()
	end
end

local function CatButton_Expand(self)
	local toggle = self.toggle
	if not toggle or self.expanded then
		return
	end

	self.expanded = 1

	local _, child
	for _, child in ipairs(self.nodes) do
		child:Show()
	end

	local peer = self.peer
	if peer then
		local y = GetBranchHeight(self) - BUTTON_HEIGHT
		peer:ClearAllPoints()
		peer:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -y)
		peer:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -y)
	end

	toggle:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-UP")
	toggle:SetDisabledTexture("Interface\\Buttons\\UI-MinusButton-Disabled")
	toggle:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-DOWN")
end

local function CatButton_Collapse(self)
	local toggle = self.toggle
	if not toggle or not self.expanded then
		return
	end

	self.expanded = nil

	local _, child
	for _, child in ipairs(self.nodes) do
		child:Hide()
	end

	local peer = self.peer
	if peer then
		peer:ClearAllPoints()
		peer:SetPoint("TOPLEFT", self, "BOTTOMLEFT")
		peer:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT")
	end

	toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
	toggle:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")
	toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")

	local category = self.catList.selectedCategory
	if category and IsBranchChild(self, category.button) then
		self:Click()
	end
end

local function CatButton_OnClick(self)
	--CatButton_Expand(self)

	self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	local parent = self.catList
	local prevCategory = parent.selectedCategory
	local category = self.category
	if prevCategory == category then
		return -- No changes
	end

	parent.highlightTexture:Hide()

	local texture = parent.checkedTexture
	texture:ClearAllPoints()
	texture:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -1)
	texture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")

	local frame = parent.mainFrame

	parent.selectedCategory = nil

	if prevCategory then
		prevCategory.button.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		prevCategory.page:Hide()

		if type(frame.OnCategoryDeselect) == "function" then
			frame:OnCategoryDeselect(prevCategory)
		end
	end

	parent.selectedCategory = category
	category.page:Show()

	if type(frame.OnCategorySelect) == "function" then
		frame:OnCategorySelect(category)
	end
end

local function CatButton_OnEnter(self)
	local parent = self.catList
	if parent.selectedCategory ~= self.category then
		local texture = parent.highlightTexture
		texture:ClearAllPoints()
		texture:SetPoint("TOPLEFT", self, "TOPLEFT", 0, -1)
		texture:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		texture:Show()
		self.text:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	end
end

local function CatButton_OnLeave(self)
	local parent = self.catList
	parent.highlightTexture:Hide()
	if parent.selectedCategory ~= self.category then
		self.text:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	end
end

local function CatButton_OnDoubleClick(self)
	self.toggle:Click()
end

local function Toggle_OnClick(self)
	local button = self:GetParent()
	if button.expanded then
		CatButton_Collapse(button)
	else
		CatButton_Expand(button)
	end
end

local function CatList_OnShow(self)
	if not self.selectedCategory and self.nodes[1] then
		self.nodes[1]:Click()
	end
end

local function CatList_CreateButton(self, key, title, parent)
	if type(key) ~= "string" or self.categories[key] then
		return
	end

	if type(parent) == "string" then
		parent = self.categories[parent]
	end

	if type(parent) ~= "table" or not parent.button then
		parent = nil
	end

	local category = { key = key, title = title, parent = parent }
	local parentButton = parent and parent.button or self

	if parentButton ~= self and not parentButton.toggle then
		local toggle = CreateFrame("Button", parentButton:GetName().."Toggle", parentButton) -- The toggle button
		parentButton.toggle = toggle
		toggle:SetSize(14, 14)
		toggle:SetPoint("LEFT", 2, 0)
		toggle:SetHighlightTexture("Interface\\Buttons\\UI-PlusButton-Hilight", "ADD")
		toggle:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-UP")
		toggle:SetDisabledTexture("Interface\\Buttons\\UI-PlusButton-Disabled")
		toggle:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-DOWN")
		toggle:SetScript("OnClick", Toggle_OnClick)
		parentButton:SetScript("OnDoubleClick", CatButton_OnDoubleClick)
	end

	local id = self.buttonCount + 1
	self.buttonCount = id
	category.id = id

	local button = CreateFrame("Button", self:GetName().."Button"..id, parentButton)
	button:SetID(id)
	button:SetHeight(BUTTON_HEIGHT)
	button.catList = self
	button.nodes = {}

	if id == 1 then
		button:SetPoint("TOPLEFT")
		button:SetPoint("TOPRIGHT")
	else
		local prev = parentButton.nodes[#parentButton.nodes]
		if prev then
			prev.peer = button
			local y = GetBranchHeight(prev) - BUTTON_HEIGHT
			button:ClearAllPoints()
			button:SetPoint("TOPLEFT", prev, "BOTTOMLEFT", 0, -y)
			button:SetPoint("TOPRIGHT", prev, "BOTTOMRIGHT", 0, -y)
		else
			button:SetPoint("TOPLEFT", parentButton, "BOTTOMLEFT", 14, 0)
			button:SetPoint("TOPRIGHT", parentButton, "BOTTOMRIGHT")
		end
	end

	if not parentButton.expanded then
		button:Hide()
	end

	button.text = button:CreateFontString(button:GetName().."Text", "ARTWORK", "GameFontNormalLeft")
	button.text:SetPoint("LEFT", 18 , 0)
	button.text:SetPoint("RIGHT", -2, 0)
	button.text:SetText(title)
	button:SetFontString(button.text)

	button:SetScript("OnClick", CatButton_OnClick)
	button:SetScript("OnEnter", CatButton_OnEnter)
	button:SetScript("OnLeave", CatButton_OnLeave)

	category.button = button
	button.category = category

	self.categories[key] = category
	tinsert(parentButton.nodes, button)
	return category

end

local function ScrollFrame_EnsureVisible(self, button)
	if not button or button.category ~= self:GetScrollChild().selectedCategory then
		return 1
	end

	if self:GetHeight() < BUTTON_HEIGHT * 3 then
		return
	end

	local slider = self.ScrollBar
	local minVal, maxVal = slider:GetMinMaxValues()
	if maxVal == 0 then
		return
	end

	if button:GetTop() > self:GetTop() then
		local i
		for i = 1, 100 do
			if button:GetTop() > self:GetTop() then
				slider:SetValue(slider:GetValue() - BUTTON_HEIGHT)
			else
				return 1
			end
		end

	elseif button:GetBottom() < self:GetBottom() then
		local i
		for i = 1, 100 do
			if button:GetBottom() < self:GetBottom() then
				slider:SetValue(slider:GetValue() + BUTTON_HEIGHT)
			else
				return 1
			end
		end
	else
		return 1
	end
end

local function ScrollFrame_OnSizeChanged(self, x)
	if x > 0 then
		self:GetScrollChild():SetWidth(x)
	end
end

local function ScrollFrame_OnUpdate(self)
	local ok = ScrollFrame_EnsureVisible(self, self.watchedButton)
	if ok or GetTime() - (self.watchTime or 0) > 2 then
		self.watchedButton = nil
		self:SetScript("OnUpdate", nil)
	end
end

local function Frame_CreateScrollFrame(self, name, parent)
	local frame = CreateFrame("ScrollFrame", name, parent, "UIPanelScrollFrameTemplate")
	frame:EnableMouseWheel(true)
	frame.scrollBarHideable = 1
	frame.ScrollBar:Hide()
	frame.ScrollBar:SetValueStep(BUTTON_HEIGHT)
	frame.ScrollBar.scrollStep = BUTTON_HEIGHT

	local scrollChild = CreateFrame("Frame", name.."ScrollChild", frame)
	scrollChild:SetSize(200, 400)
	scrollChild.mainFrame = self
	frame:SetScrollChild(scrollChild)

	frame:SetScript("OnSizeChanged", ScrollFrame_OnSizeChanged)
	return frame, scrollChild
end

local function Frame_Toggle(self)
	if self:IsShown() then
		self:Hide()
	else
		self:Show()
	end
end

local function Frame_FindCategory(self, key)
	return self.catList.categories[key]
end

local function Frame_AddCategory(self, key, title, desc, parent)
	local category = CatList_CreateButton(self.catList, key, title, parent)
	if not category then
		return
	end

	local pageName = self:GetName().."_UserPage_"..category.id
	local page

	if type(UICreateInterfaceOptionPage) == "function" then
		page = UICreateInterfaceOptionPage(self:GetName().."_UserPage_"..category.id, title, desc, nil, self.pageContainer)
		page.SetDialogStyle, page.Open, page.Toggle = nil
	else
		page = CreateFrame("Frame", pageName, self.pageContainer)
		page.title = page:CreateFontString(pageName.."Title", "ARTWORK", "GameFontNormal")
		page.title:SetText(title)
		page.title:SetJustifyV("TOP")
		page.title:SetPoint("TOPLEFT", 16, -16)

		page.subTitle = page:CreateFontString(pageName.."SubTitle", "ARTWORK", "GameFontHighlightSmallLeftTop")
		page.subTitle:SetPoint("TOPLEFT", 16, -38)
		page.subTitle:SetPoint("TOPRIGHT", -16, -38)
		page.subTitle:SetNonSpaceWrap(true)
		page.subTitle:SetText(desc)
	end

	category.page = page
	category.desc = desc

	page:Hide()
	page:SetAllPoints(self.pageContainer)
	return category, page
end

local function Frame_OpenToCategory(self, category)
	if not self:IsShown() then
		self:Show()
	end

	if type(category) == "string" then
		category = Frame_FindCategory(self, category)
	end

	if type(category) == "table" and category.button then
		local parent = category.button:GetParent()
		while parent ~= self.catList do
			CatButton_Expand(parent)
			parent = parent:GetParent()
		end

		category.button:Click()

		local scrollFrame = self.catListScrollFrame
		scrollFrame.watchTime = GetTime()
		scrollFrame.watchedButton = category.button
		scrollFrame:SetScript("OnUpdate", ScrollFrame_OnUpdate)

		return category
	end
end

local function Frame_GetOpenedCategory(self)
	return self.catList.selectedCategory
end

local function OperationButton_OnClick(self)
	local frame = self:GetParent()
	local func = frame["OnOperation"..self:GetID()]
	if func then
		func(frame, self)
	else
		frame:Hide()
	end
end

local function Frame_SetWaterMarkText(self, text)
	self.waterMark:SetText(text)
end

local function Frame_SetCategoryListWidth(self, width)
	if type(width) == "number" and width > 0 then
		self.leftPanel:SetWidth(width)
	end
end

local function Frame_GetOperationButton(self, index)
	if type(index) == "number" then
		return self.operationButtons[index]
	end

	if type(index) == "string" then
		local _, button
		for _, button in ipairs(self.operationButtons) do
			if button:GetText() == index then
				return button
			end
		end
	end
end

function UICreateModularOptionFrame(name, title, version, button1, ...)
	if type(name) ~= "string" or _G[name] then
		return
	end

	local frame = CreateFrame("Frame", name, UIParent)
	frame:SetBackdrop({ bgFile = "Interface\\FrameGeneral\\UI-Background-Marble", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })
	frame:SetSize(800, 610)
	frame:SetPoint("CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	frame:SetMovable(true)
	frame:SetToplevel(true)
	frame:SetUserPlaced(false)
	frame:SetDontSavePosition(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	tinsert(UISpecialFrames, name)

	local titleText = frame:CreateFontString(name.."TitleText", "OVERLAY", "GameFontNormal")
	frame.titleText = titleText
	titleText:SetPoint("TOP", 0, 1)
	titleText:SetText(title)

	local headerTexture = frame:CreateTexture(name.."HeaderTexture", "ARTWORK")
	frame.headerTexture = headerTexture
	headerTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
	headerTexture:SetSize(titleText:GetWidth() + 200, 62)
	headerTexture:SetPoint("TOP", 1, 13)

	local versionText = frame:CreateFontString(name.."VersionText", "ARTWORK", "GameFontNormalSmall")
	frame.versionText = versionText
	versionText:SetPoint("TOPRIGHT", -45, -12)
	versionText:SetFont(STANDARD_TEXT_FONT, 12)

	if type(version) == "number" then
		versionText:SetFormattedText("%s: %.2f", GAME_VERSION_LABEL, version)
	elseif type(version) == "string" then
		versionText:SetFormattedText("%s: %s", GAME_VERSION_LABEL, version)
	end

	local topClose = CreateFrame("Button", name.."TopClose", frame, "UIPanelCloseButton")
	topClose:SetSize(24, 24)
	topClose:SetPoint("TOPRIGHT", -5, -5)

	local leftPanel = CreateFrame("Frame", name.."LeftPanel", frame)
	frame.leftPanel = leftPanel
	leftPanel:SetBackdrop({ tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }})
	leftPanel:SetBackdropBorderColor(0.75, 0.75, 0.75)
	leftPanel:SetPoint("TOPLEFT", 24, -28)
	leftPanel:SetPoint("BOTTOMLEFT", 24, button1 and 50 or 24)

	local catListScrollFrame, catList = Frame_CreateScrollFrame(frame, name.."CatListScrollFrame", leftPanel)
	frame.catListScrollFrame, frame.catList = catListScrollFrame, catList

	catListScrollFrame:SetPoint("TOPLEFT", 4, -5)
	catListScrollFrame:SetPoint("BOTTOMRIGHT", -8, 6)

	catList.expanded = 1
	catList.buttonCount = 0
	catList.categories = {}
	catList.nodes = {}
	catList:SetScript("OnShow", CatList_OnShow)

	local texture = catList:CreateTexture(nil, "BORDER")
	catList.highlightTexture = texture
	texture:SetTexture("Interface\\QuestFrame\\UI-QuestLogTitleHighlight")
	texture:SetBlendMode("ADD")
	texture:SetVertexColor(0.196, 0.388, 0.8, 0.8)

	local texture = catList:CreateTexture(nil, "BORDER")
	catList.checkedTexture = texture
	texture:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	texture:SetBlendMode("ADD")
	texture:SetVertexColor(1, 1, 1, 0.8)

	local rightPanel = CreateFrame("Frame", name.."RightPanel", frame)
	frame.rightPanel = rightPanel
	rightPanel:SetBackdrop({ tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 }})
	rightPanel:SetBackdropBorderColor(0.75, 0.75, 0.75)
	rightPanel:SetPoint("TOPRIGHT", -24, -28)
	rightPanel:SetPoint("BOTTOMLEFT", leftPanel, "BOTTOMRIGHT", 12, 0)

	local pageContainer = CreateFrame("Frame", name.."PageContainerScrollFrame", rightPanel)
	frame.pageContainer = pageContainer

	pageContainer:SetPoint("TOPLEFT", 4, -6)
	pageContainer:SetPoint("BOTTOMRIGHT", -8, 6)

	frame.operationButtons = {}

	if button1 then
		local buttonsTexts = { button1, ... }

		local i, lastButton
		for i = #buttonsTexts, 1, -1 do
			local button = CreateFrame("Button", name.."OperationButton"..i, frame, "UIPanelButtonTemplate")
			button:SetSize(96, 24)
			button:SetText(tostring(buttonsTexts[i]))
			button:SetID(i)

			if lastButton then
				button:SetPoint("RIGHT", lastButton, "LEFT")
			else
				button:SetPoint("TOPRIGHT", rightPanel, "BOTTOMRIGHT", 0, -7)
			end

			lastButton = button
			tinsert(frame.operationButtons, 1, button)
			button:SetScript("OnClick", OperationButton_OnClick)
		end
	end

	local waterMark = frame:CreateFontString(name.."WaterMark", "ARTWORK", "GameFontNormal")
	frame.waterMark = waterMark
	waterMark:SetFont(STANDARD_TEXT_FONT, 10)
	waterMark:SetTextColor(0.5, 0.5, 0.5)
	waterMark:SetPoint("BOTTOMLEFT", 16, 15)

	frame.AddCategory = Frame_AddCategory
	frame.FindCategory = Frame_FindCategory
	frame.OpenToCategory = Frame_OpenToCategory
	frame.GetOpenedCategory = Frame_GetOpenedCategory
	frame.Toggle = Frame_Toggle
	frame.SetWaterMarkText = Frame_SetWaterMarkText
	frame.SetCategoryListWidth = Frame_SetCategoryListWidth
	frame.GetOperationButton = Frame_GetOperationButton

	leftPanel:SetWidth(210) -- Set the category list width to default value

	return frame
end

-- Provides version check
function UICreateModularOptionFrame_IsNewerVersion(major, minor)
	if type(major) ~= "number" or type(minor) ~= "number" then
		return false
	end

	if major > MAJOR_VERSION then
		return true
	elseif major < MAJOR_VERSION then
		return false
	else -- major equal, check minor
		return minor > MINOR_VERSION
	end
end