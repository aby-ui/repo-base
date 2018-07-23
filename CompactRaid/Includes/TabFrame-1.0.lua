-----------------------------------------------------------
-- TabFrame-1.0.lua
-----------------------------------------------------------
-- A light-weight tab frame based on Blizzard UIPanelTemplates.
--
-- Abin (2010-10-18)

-----------------------------------------------------------
-- API Documentation:
-----------------------------------------------------------

-- frame = UICreateTabFrame("name", parent) -- Create a tab frame

-- frame:NumTabs() -- Return number of tabs created
-- frame:AddTab("text" [, data [, "tooltipText"]]) -- Add a new tab, return index of the newly created tab
-- frame:GetTabButton(index) -- Return the tab button
-- frame:GetSelection() -- Return index of currently selected tab, and its associated data
-- frame:SelectTab(index) -- Select a tab, do nothing of the tab was already selected
-- frame:DeselectTab() -- Deselect any selected tab
-- frame:TabEnabled(index) -- Return whether a tab is enabled
-- frame:EnableTab(index) -- Enable a tab
-- frame:DisableTab(index) -- Disable a tab
-- frame:SetTabText(index, text) -- Set text for a tab button

-----------------------------------------------------------
-- Callback Methods:
-----------------------------------------------------------

-- frame:OnTabSelected(index, data) -- Called when a tab is selected
-- frame:OnTabDeselected(index, data) -- Called when a tab is deselected
-- frame:OnTabTooltip(index, data) -- Called when mouse hovers over a tab button

-----------------------------------------------------------

local ipairs = ipairs
local type = type
local tinsert = tinsert
local CreateFrame = CreateFrame
local pcall = pcall
local PanelTemplates_TabResize = PanelTemplates_TabResize
local GameTooltip = GameTooltip
local _G = _G

local MAJOR_VERSION = 1
local MINOR_VERSION = 7

-- To prevent older libraries from over-riding newer ones...
if type(UICreateTabFrame_IsNewerVersion) == "function" and not UICreateTabFrame_IsNewerVersion(MAJOR_VERSION, MINOR_VERSION) then return end

local function CreateBorderTexture(parent, tl, tr, tt, tb, corner, spacer)
	local texture = parent:CreateTexture(nil, "BORDER")
	texture:SetSize(16, 16)
	texture:SetTexture(spacer and "Interface\\OptionsFrame\\UI-OptionsFrame-Spacer" or "Interface\\Tooltips\\UI-Tooltip-Border")
	if tl then
		texture:SetTexCoord(tl, tr, tt, tb)
	end

	if corner then
		texture:SetPoint(corner)
	end

	return texture
end

local function TabButton_UpdateTextColor(self)
	local color
	local state = self._tabState
	if self._tabSelected then
		color = HIGHLIGHT_FONT_COLOR
	elseif self._tabDisabled then
		color = GRAY_FONT_COLOR
	elseif self._tabEntered then
		color = HIGHLIGHT_FONT_COLOR
	else
		color = NORMAL_FONT_COLOR
	end

	self.text:SetTextColor(color.r, color.g, color.b)
end

local function TabButton_Select(self)
	local _, texture
	for _, texture in ipairs(self.deselectTextures) do
		texture:Hide()
	end

	for _, texture in ipairs(self.selectTextures) do
		texture:Show()
	end

	self.text:ClearAllPoints()
	self.text:SetPoint("CENTER", 0, -1)

	self:Disable()
	self._tabSelected = 1
	TabButton_UpdateTextColor(self)

	local frame = self:GetParent()
	pcall(frame.OnTabSelected, frame, self:GetID(), self.data)
end

local function TabButton_Deselect(self, internal)
	local _, texture
	for _, texture in ipairs(self.deselectTextures) do
		texture:Show()
	end

	for _, texture in ipairs(self.selectTextures) do
		texture:Hide()
	end

	self.text:ClearAllPoints()
	self.text:SetPoint("CENTER", 0, -3)

	self._tabSelected = nil
	if not self._tabDisabled then
		self:Enable()
	end

	TabButton_UpdateTextColor(self)

	if not internal then
		local frame = self:GetParent()
		pcall(frame.OnTabDeselected, frame, self:GetID(), self.data)
	end
end

local function Frame_SelectTab(self, index)
	if self.selectedTab == index then
		return index
	end

	local button = self.tabButtons[index]
	if not button then
		return
	end

	local old = self.selectedTab
	local oldButton = self.tabButtons[old]
	self.selectedTab = index

	self.spacer1:ClearAllPoints()
	self.spacer1:SetPoint("LEFT", self.topLeft, "TOPRIGHT", 0, -1)
	self.spacer1:SetPoint("RIGHT", button, "BOTTOMLEFT", 10, -2)

	self.spacer2:Show()
	self.spacer2:ClearAllPoints()
	self.spacer2:SetPoint("RIGHT", self.topRight, "TOPLEFT", 0, -1)
	self.spacer2:SetPoint("LEFT", button, "BOTTOMRIGHT", -10, 2)

	if oldButton then
		TabButton_Deselect(oldButton)
	end

	TabButton_Select(button)
	return index
end

local function Frame_DeselectTab(self)
	local old = self.selectedTab
	local button = self.tabButtons[old]
	if not button then
		return
	end

	self.selectedTab = 0
	self.spacer1:SetPoint("LEFT", self.topLeft, "TOPRIGHT", 0, -1)
	self.spacer1:SetPoint("RIGHT", self.topRight, "TOPLEFT", 0, -1)
	self.spacer2:Hide()
	TabButton_Deselect(button)
	return old
end

local function Frame_GetSelection(self)
	local tab = self.tabButtons[self.selectedTab]
	return self.selectedTab, tab and tab.data
end

local function Frame_TabEnabled(self, index)
	local button = self.tabButtons[index]
	if button then
		return button:IsEnabled()
	end
end

local function Frame_EnableTab(self, index)
	local button = self.tabButtons[index]
	if button then
		button:Enable()
		button._tabDisabled = nil
		TabButton_UpdateTextColor(button)
	end
end

local function Frame_DisableTab(self, index)
	local button = self.tabButtons[index]
	if button then
		button:Disable()
		button._tabDisabled = 1
		TabButton_UpdateTextColor(button)
	end
end

local function TabButton_OnClick(self)
	Frame_SelectTab(self:GetParent(), self:GetID())
end

local function TabButton_OnEnter(self)
	self._tabEntered = 1
	TabButton_UpdateTextColor(self)

	local frame = self:GetParent()
	local func = frame.OnTabTooltip
	local tooltipText = self.tooltipText

	if func or tooltipText then
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine(self:GetText())
		if func then
			func(frame, self:GetID(), self.data)
		else
			GameTooltip:AddLine(tooltipText, 1, 1, 1, 1)
		end
		GameTooltip:Show()
	end
end

local function TabButton_OnLeave(self)
	self._tabEntered = nil
	TabButton_UpdateTextColor(self)
	GameTooltip:Hide()
end

local function Frame_AddTab(self, text, data, tooltipText)
	local index = self.numTabs + 1
	local name = self:GetName().."Tab"..index

	self.numTabs = index
	local button = CreateFrame("Button", name, self, "OptionsFrameTabButtonTemplate")
	button.text = _G[name.."Text"]
	button.data = data
	button.tooltipText = tooltipText
	button:SetID(index)
	button.text:SetFont(STANDARD_TEXT_FONT, 13)
	button:SetFontString(button.text)
	button:SetText(text)

	button:SetMotionScriptsWhileDisabled(true)
	button:SetHitRectInsets(10, 10, 5, 0)

	button.deselectTextures = {}
	tinsert(button.deselectTextures, _G[name.."Left"])
	tinsert(button.deselectTextures, _G[name.."Middle"])
	tinsert(button.deselectTextures, _G[name.."Right"])

	button.selectTextures = {}
	tinsert(button.selectTextures, _G[name.."LeftDisabled"])
	tinsert(button.selectTextures, _G[name.."MiddleDisabled"])
	tinsert(button.selectTextures, _G[name.."RightDisabled"])

	if self.lastTab then
		button:SetPoint("LEFT", self.lastTab, "RIGHT", -18, 0)
	else
		button:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 6, -3)
	end
	self.lastTab = button
	tinsert(self.tabButtons, button)

	button:SetScript("OnClick", TabButton_OnClick)
	button:SetScript("OnEnter", TabButton_OnEnter)
	button:SetScript("OnLeave", TabButton_OnLeave)
	TabButton_Deselect(button, 1)

	return index, button
end

local function Frame_GetTabButton(self, index)
	return self.tabButtons[index]
end

local function Frame_NumTabs(self)
	return self.numTabs
end

local function Frame_SetTabText(self, index, text)
	local tab = self.tabButtons[index]
	if not tab then
		return
	end

	tab:SetText(text)
	if tab:IsVisible() then
		PanelTemplates_TabResize(tab, 0)
	end
end

function UICreateTabFrame(name, parent)
	local frame = CreateFrame("Frame", name, parent)
	frame.selectedTab = 0
	frame.tabButtons = {}
	frame.topLeft = CreateBorderTexture(frame, 0.5, 0.625, 0, 1, "TOPLEFT")
	frame.topRight = CreateBorderTexture(frame, 0.625, 0.75, 0, 1, "TOPRIGHT")
	local bottomLeft = CreateBorderTexture(frame, 0.75, 0.875, 0, 1, "BOTTOMLEFT")
	local bottomRight = CreateBorderTexture(frame, 0.875, 1, 0, 1, "BOTTOMRIGHT")

	local left = CreateBorderTexture(frame, 0, 0.125, 0, 1)
	left:SetPoint("TOPLEFT", frame.topLeft, "BOTTOMLEFT")
	left:SetPoint("BOTTOMRIGHT", bottomLeft, "TOPRIGHT")

	local right = CreateBorderTexture(frame, 0.125, 0.25, 0, 1)
	right:SetPoint("TOPLEFT", frame.topRight, "BOTTOMLEFT")
	right:SetPoint("BOTTOMRIGHT", bottomRight, "TOPRIGHT")

	local bottom = CreateBorderTexture(frame, nil, nil, nil, nil, nil, 1)
	bottom:SetPoint("BOTTOMLEFT", bottomLeft, "BOTTOMRIGHT", 0, -2)
	bottom:SetPoint("BOTTOMRIGHT", bottomRight, "BOTTOMLEFT")

	frame.spacer1 =CreateBorderTexture(frame, nil, nil, nil, nil, nil, 1)
	frame.spacer2 =CreateBorderTexture(frame, nil, nil, nil, nil, nil, 1)
	frame.spacer1:SetPoint("LEFT", frame.topLeft, "TOPRIGHT", 0, -1)
	frame.spacer1:SetPoint("RIGHT", frame.topRight, "TOPLEFT", 0, -1)

	frame.numTabs = 0
	frame.NumTabs = Frame_NumTabs
	frame.AddTab = Frame_AddTab
	frame.GetTabButton = Frame_GetTabButton
	frame.GetSelection = Frame_GetSelection
	frame.SelectTab = Frame_SelectTab
	frame.DeselectTab = Frame_DeselectTab
	frame.TabEnabled = Frame_TabEnabled
	frame.EnableTab = Frame_EnableTab
	frame.DisableTab = Frame_DisableTab
	frame.SetTabText = Frame_SetTabText
	return frame
end

-- Provides version check
function UICreateTabFrame_IsNewerVersion(major, minor)
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