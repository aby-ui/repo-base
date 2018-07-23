-- --------------------
-- TellMeWhen
-- Originally by Nephthys of Hyjal <lieandswell@yahoo.com>

-- Other contributions by:
--		Sweetmms of Blackrock, Oozebull of Twisting Nether, Oodyboo of Mug'thol,
--		Banjankri of Blackrock, Predeter of Proudmoore, Xenyr of Aszune

-- Currently maintained by
-- Cybeloras of Aerie Peak
-- --------------------


if not TMW then return end

local TMW = TMW
local L = TMW.L
local print = TMW.print

local tonumber, tostring, type, pairs, tremove, wipe, next, setmetatable, pcall, assert, rawget, unpack, select, loadstring, error =
	  tonumber, tostring, type, pairs, tremove, wipe, next, setmetatable, pcall, assert, rawget, unpack, select, loadstring, error
local strmatch, strtrim, max =
	  strmatch, strtrim, max

-- GLOBALS: TellMeWhen_TextDisplayOptions, TELLMEWHEN_VERSIONNUMBER
-- GLOBALS: CreateFrame, IsControlKeyDown

local DogTag = LibStub("LibDogTag-3.0")
local LMB = LibStub("Masque", true) or (LibMasque and LibMasque("Button"))
local LSM = LibStub("LibSharedMedia-3.0")

local TEXT = TMW.TEXT
local IE = TMW.IE
local CI = TMW.CI

if not TEXT then return end


local clientVersion = select(4, GetBuildInfo())





-------------------------------
-- Layout Configuration
-------------------------------

local Tab = IE:RegisterTab("MAIN", "TEXTLAYOUTS", "TextLayouts", 90)
Tab:SetTexts(L["TEXTLAYOUTS"], L["TEXTLAYOUTS_DESC"])
TEXT.LayoutTab = Tab

TMW.C.HistorySet:GetHistorySet("MAIN"):AddBlocker({
	global = { TextLayouts = true}
})
local HistorySet = TMW.C.HistorySet:New("TEXTLAYOUTS")
local layoutHistories = setmetatable({}, {
	__index = function(self, key)
		self[key] = {}
		return self[key]
	end
})

function HistorySet:GetCurrentLocation()
	local layoutGUID = TEXT:GetCurrentLayoutAndDisplay()
	return layoutGUID and layoutHistories[layoutGUID]
end
function HistorySet:GetCurrentSettings()
	local layoutSettings = TEXT:GetCurrentLayoutAndDisplaySettings()
	return layoutSettings
end

Tab:SetHistorySet(HistorySet)



local function layoutSort(GUID_a, GUID_b)
	local layoutSettings_a, layoutSettings_b = TEXT:GetTextLayoutSettings(GUID_a), TEXT:GetTextLayoutSettings(GUID_b)
	local NoEdit_a, NoEdit_b = layoutSettings_a.NoEdit, layoutSettings_b.NoEdit
	
	if NoEdit_a == NoEdit_b then
		-- Simple string comparison for alphabetical sorting
		return TEXT:GetLayoutName(layoutSettings_a, GUID_a) < TEXT:GetLayoutName(layoutSettings_b, GUID_b)
	else
		return NoEdit_a
	end
end


TMW:NewClass("Config_TextLayout_List", "Config_Frame") {
	OnNewInstance = function(self)
		self.frames = {}

		TMW:ConvertContainerToScrollFrame(self, true, nil, 8)
	end,

	GetTextLayoutFrame = function(self, id)
		local frame = self.frames[id]
		if not frame then
			frame = TMW.C.Config_TextLayout_ListItem:New("Frame", nil, self, "TellMeWhen_TextLayout_ListItem", id)
			self.frames[id] = frame

			if id == 1 then
				frame:SetPoint("TOP", self)
			else
				frame:SetPoint("TOP", self.frames[id - 1], "BOTTOM", 0, -2)
			end
		end

		return frame
	end,


	ReloadSetting = function(self)
		local id = 0
		local firstGUID
		for GUID, layoutSettings in TMW:OrderedPairs(TMW.db.global.TextLayouts, layoutSort) do
			if GUID ~= "" then
				id = id + 1

				local frame = self:GetTextLayoutFrame(id)

				frame:SetSetting(GUID)
				frame:Show()

				firstGUID = firstGUID or GUID
			end
		end

		for i = id + 1, #self.frames do
			self.frames[i]:Hide()
		end

		local layoutGUID = TEXT:GetCurrentLayoutAndDisplay()
		if id > 0 and not layoutGUID then
			TEXT:SetCurrentLayout(firstGUID)
		end

	end,
}

TMW:NewClass("Config_TextLayout_ListItem", "Config_Frame") {
	OnNewInstance = function(self)
		self.frames = {}

		self:CScriptAdd("SettingTableRequested", self.SettingTableRequested)

		self.Layout:SetScript("OnClick", self.LayoutOnClick)
		self:SetClipsChildren(true)
	end,

	SettingTableRequested = function(self)
		local GUID = self.setting
		local TextLayouts = TMW.db.global.TextLayouts

		local layoutSettings = GUID and rawget(TextLayouts, GUID)

		return layoutSettings or false
	end,
	
	GetTextDisplayFrame = function(self, id)
		local frame = self.frames[id]
		if not frame then
			frame = TMW.C.Config_TextDisplay_ListItem:New("CheckButton", nil, self, "TellMeWhen_TextDisplay_ListItem", id)
			self.frames[id] = frame

			if id == 1 then
				frame:SetPoint("TOP", self.Layout, "BOTTOM", 0, -2)
			else
				frame:SetPoint("TOP", self.frames[id - 1], "BOTTOM", 0, -2)
			end
		end

		return frame
	end,

	tooltipFunction = function(Layout)
		local self = Layout:GetParent()
		local layoutSettings = self:GetSettingTable()

		if not layoutSettings then
			return ""
		end

		if layoutSettings.NoEdit then
			return L["TEXTLAYOUTS_NOEDIT_DESC"]
		else
			local tooltip = TEXT:GetNumTimesUsed(layoutSettings.GUID)
			if tooltip ~= "" then
				return TMW.L["TEXTLAYOUTS_USEDBY_HEADER"] .. "\n\n" .. tooltip .. "\n\n" .. L["CLICK_TO_EDIT"]
			else
				return TMW.L["TEXTLAYOUTS_USEDBY_NONE"] .. "\n\n" .. L["CLICK_TO_EDIT"]
			end
		end
	end,

	ReloadSetting = function(self)
		local layoutSettings = self:GetSettingTable()

		local currentLayoutGUID, currentDisplayID = TEXT:GetCurrentLayoutAndDisplay()
		self.Layout:SetChecked(currentLayoutGUID == self.setting)

		local numShown = 0
		if layoutSettings then
			local name = TEXT:GetLayoutName(layoutSettings)
			self.Layout.Name:SetText(name)

			TMW:TT(self.Layout, name, self.tooltipFunction, 1, 1)

			-- Setup text display frames
			for id, displaySettings in TMW:InNLengthTable(layoutSettings) do
				local frame = self:GetTextDisplayFrame(id)

				frame:Show()
				numShown = id
			end
		end

		-- Load the first display if there isn't one already loaded.
		if self.Layout:GetChecked() and not currentDisplayID then
			TEXT:SetCurrentDisplay(1)
		end

		-- Hide all the extra frames.
		for i = numShown + 1, #self.frames do
			self.frames[i]:Hide()
		end

		if self.Layout:GetChecked() then
			-- Adjust the height to fit all the text displays.
			self:AdjustHeightAnimated(10, 0.2)
		else
			-- Shrink to just fit the header.
			TMW:AnimateHeightChange(self, self.Layout:GetHeight(), 0.2)
		end
	end,

	LayoutOnClick = function(Layout)
		local self = Layout:GetParent()

		TEXT:SetCurrentLayout(self.setting)
	end,
}

TMW:NewClass("Config_TextDisplay_ListItem", "Config_CheckButton") {
	ReloadSetting = function(self)
		local layoutSettings = self:GetSettingTable()

		if layoutSettings and self:GetID() <= layoutSettings.n then
			local name = TEXT:GetStringName(layoutSettings[self:GetID()], self:GetID())

			self.Name:SetText(name)

			self:SetTooltip(name, not layoutSettings.NoEdit and L["CLICK_TO_EDIT"] or nil)
		end

		local layoutGUID, displayID = TEXT:GetCurrentLayoutAndDisplay()
		self:SetChecked(displayID == self:GetID())
	end,

	OnClick = function(self)
		TEXT:SetCurrentDisplay(self:GetID())
	end,
}


TEXT.currentLayout = nil
TEXT.currentDisplay = nil

function TEXT:SetCurrentLayout(layoutGUID)
	IE:SaveSettings()
	
	TEXT.currentLayout = layoutGUID

	IE.Pages.TextLayouts:RequestReload()
end

function TEXT:SetCurrentDisplay(displayID)
	TEXT.currentDisplay = displayID

	IE.Pages.TextLayouts:RequestReload()
end

function TEXT:GetCurrentLayoutAndDisplay()
	if not TEXT.currentLayout or not rawget(TMW.db.global.TextLayouts, TEXT.currentLayout) then
		TEXT.currentLayout = nil
		TEXT.currentDisplay = nil

		return nil, nil
	end
	
	local layoutSettings = TMW.db.global.TextLayouts[TEXT.currentLayout]
	if TEXT.currentDisplay and TEXT.currentDisplay > layoutSettings.n then
		TEXT.currentDisplay = nil
	end

	return TEXT.currentLayout, TEXT.currentDisplay
end

function TEXT:GetCurrentLayoutAndDisplaySettings()
	local layoutGUID, displayID = TEXT:GetCurrentLayoutAndDisplay()

	if not layoutGUID then
		return nil, nil
	end

	local layoutSettings = TMW.db.global.TextLayouts[layoutGUID]

	return layoutSettings, displayID and layoutSettings[displayID]
end


local panels = {
	TMW.C.StaticConfigPanelInfo:New(1, "LayoutSettings"),
	TMW.C.StaticConfigPanelInfo:New(2, "DisplaySettings"),
	TMW.C.StaticConfigPanelInfo:New(3, "MasqueWarn"),
	TMW.C.StaticConfigPanelInfo:New(4, "DisplayFontSettings"),
}
local anchorPanels = {}

function TEXT:SetupPanels()
	local layoutSettings, displaySettings = TEXT:GetCurrentLayoutAndDisplaySettings()

	if displaySettings then
		local Anchors = displaySettings.Anchors
		for id, anchorSettings in TMW:InNLengthTable(Anchors) do
			if not anchorPanels[id] then
				-- XmlConfigPanelInfo can't be used here because it only allows for one frame per template.
				local page = IE.Pages.TextLayouts
				local panel = CreateFrame("Frame", nil, page.Panels, "TellMeWhen_TextDisplay_Anchor", id)
				local key = "Anchor" .. id
				page.Panels[key] = panel

				anchorPanels[id] = TMW.C.StaticConfigPanelInfo:New(10 + id, key)
				tinsert(panels, anchorPanels[id])
			end
		end
	end

	TMW.IE:PositionPanels("TextLayouts", panels)
end

function TEXT:Clonelayout(sourceGUID)
	local GUID = TMW:GenerateGUID("textlayout", TMW.CONST.GUID_SIZE)

	local Item = TMW.Classes.SettingsItem:New("textlayout")
	Item.Settings = TEXT:GetTextLayoutSettings(sourceGUID)
	Item.Version = TELLMEWHEN_VERSIONNUMBER
	Item.ImportSource = TMW.C.ImportSource.types.Profile

	Item:SetExtra("GUID", GUID)

	Item:Import(GUID)

	return GUID
end

function TEXT:DeleteDisplay(layoutGUID, displayID)
	local layoutSettings = TEXT:GetTextLayoutSettings(layoutGUID)
	
	for i, fontStringSettings in TMW:InNLengthTable(layoutSettings) do
		for _, anchorSettings in TMW:InNLengthTable(fontStringSettings.Anchors) do
			local relativeTo = anchorSettings.relativeTo
			if relativeTo:sub(1, 2) == "$$" then
				relativeTo = tonumber(relativeTo:sub(3))
				if relativeTo > displayID then
					anchorSettings.relativeTo = "$$" .. relativeTo - 1
				elseif relativeTo == displayID then
					anchorSettings.relativeTo = ""
				end
			end
		end
	end
	
	tremove(layoutSettings, displayID)
	layoutSettings.n = layoutSettings.n - 1
end

function TEXT:AddTextLayout()
	local GUID = TMW:GenerateGUID("textlayout", TMW.CONST.GUID_SIZE)
	local newLayout = TMW.db.global.TextLayouts[GUID]
	newLayout.GUID = GUID
	
	local Name = "New 1"
	repeat
		local found
		for k, layoutSettings in pairs(TMW.db.global.TextLayouts) do
			if layoutSettings.Name == Name then
				Name = TMW.oneUpString(Name)
				found = true
				break
			end
		end
	until not found
	
	newLayout.Name = Name

	return newLayout
end

local function deepRecScanTableForLayout(domainTable, GUID, table, ...)
	-- The vararg here acts like a stack, containing the key of
	-- everything we've scanned to get to this depth.
	local n = 0

	for k, v in pairs(table) do
		if type(v) == "table" then
			n = n + deepRecScanTableForLayout(domainTable, GUID, v, k, ...)
		elseif v == GUID then
			local parentTableKey = select(4, ...)

			if parentTableKey == "Icons" then
				local groupID = select(5, ...)
				local gs = domainTable.Groups[groupID]
				if not TEXT.TextLayout_NumTimesUsedTemp[gs] then
					n = n + 1
				end
			elseif parentTableKey == "Groups" then
				local groupID = select(3, ...)

				local gs = domainTable.Groups[groupID]

				if not TEXT.TextLayout_NumTimesUsedTemp[gs] then
					TEXT.TextLayout_NumTimesUsedTemp[gs] = true

					n = n + ((gs.Rows or TMW.Group_Defaults.Rows) * (gs.Columns or TMW.Group_Defaults.Columns))
				end
			end
		end
	end

	return n
end
function TEXT:GetNumTimesUsed(layoutGUID)
	-- This function returns a string that lists all of the profiles that use the given text layout
	-- along with how many times it is used in each profile.

	TEXT.TextLayout_NumTimesUsedTemp = wipe(TEXT.TextLayout_NumTimesUsedTemp or {})
	
	local result = ""

	do  -- Global groups
		local n = deepRecScanTableForLayout(TMW.db.global, layoutGUID, TMW.db.global)
		if n > 0 then
			result = result .. L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"]:format(L["DOMAIN_GLOBAL"], n) .. "\r\n"
		end
	end

	for profileName, profile in pairs(TMW.db.profiles) do
		local n = deepRecScanTableForLayout(profile, layoutGUID, profile)

		if n > 0 then
			if profileName == TMW.db:GetCurrentProfile() then
				profileName = "|cff7fffff" .. profileName .. "|r"
			end
			result = result .. L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"]:format(profileName, n) .. "\r\n"
		end
	end


	wipe(TEXT.TextLayout_NumTimesUsedTemp)

	return result:trim("\r\n")
end

function TEXT:UpdateIconsUsingTextLayout(layoutGUID)
	for group in TMW:InGroups() do
		for icon in group:InIcons() do
			if icon:IsVisible() and TEXT:GetTextLayoutForIcon(icon) == layoutGUID then
				-- setup entire groups because there is code that prevents excessive event firing
				-- when updating a whole group vs a single icon
				group:Setup()
				
				break -- break icon loop
			end
		end
	end
end

function TEXT.Anchor_DropdownGenerator(dropdown)
	local layoutSettings, displaySettings = TEXT:GetCurrentLayoutAndDisplaySettings()

	if not displaySettings then
		return nil
	end

	local displayID = TMW.tContains(layoutSettings, displaySettings)

	local t = {
		[""] = L["ICON"],
	}
	
	for otherDisplayID, otherDisplaySettings in TMW:InNLengthTable(layoutSettings) do
		if otherDisplayID ~= displayID then
			t["$$" .. otherDisplayID] = L["TEXTLAYOUTS_fSTRING3"]:format(TEXT:GetStringName(otherDisplaySettings, otherDisplayID))
		end
	end
	
	for IconModule in pairs(TMW.Classes.IconModule.inheritedBy) do
		if #IconModule.instances > 0 then
			for identifier, localizedName in pairs(IconModule.anchorableChildren) do
				if type(localizedName) == "string" then
					t[IconModule.className .. identifier] = localizedName
				end
			end
		end
	end

	return t
end










-------------------------------
-- Utility Functions
-------------------------------


function TEXT:GetTextLayoutSettings(GUID)
	return GUID and rawget(TMW.db.global.TextLayouts, GUID) or nil
end

function TEXT:GetStringName(settings, num, unnamed)
	local Name = strtrim(settings.StringName or "")
	
	if Name == "" then
		if unnamed then
			Name = L["TEXTLAYOUTS_UNNAMED"]
		else
			Name = L["TEXTLAYOUTS_fSTRING"]:format(num)
		end
	end
	
	return Name
end

function TEXT:GetLayoutName(settings, GUID, noDefaultWrapper)
	if GUID and not settings then
		assert(type(GUID) == "string")
		settings = TEXT:GetTextLayoutSettings(GUID)
		
		if not settings then
			return L["UNKNOWN_UNKNOWN"]
		end

	elseif settings and not GUID then
		GUID = settings.GUID

	elseif not settings and not GUID then
		error("You need to specify either settings or GUID for GetLayoutName")
	end
	
	assert(type(GUID) == "string")
	assert(type(settings) == "table")
	
	local Name = strtrim(settings.Name or "")
	
	if Name == "" then
		Name = L["TEXTLAYOUTS_UNNAMED"]
	end
	if settings.NoEdit and not noDefaultWrapper then
		Name = L["TEXTLAYOUTS_DEFAULTS_WRAPPER"]:format(Name)
	end
	
	return Name
end










-------------------------------
-- Icon Configuration
-------------------------------

local function Layout_DropDown_OnClick(button, dropdown)
	CI.icon:GetSettingsPerView().TextLayout = button.value

	dropdown:OnSettingSaved()
end
function TEXT.Layout_DropDown(dropdown)
	for GUID, settings in TMW:OrderedPairs(TMW.db.global.TextLayouts, layoutSort) do
		if GUID ~= "" then
			local info = TMW.DD:CreateInfo()
			
			info.text = TEXT:GetLayoutName(settings, GUID)
			info.value = GUID
			info.checked = GUID == TEXT:GetTextLayoutForIcon(CI.icon)
			info.arg1 = dropdown
			
			local displays = ""
			for i, fontStringSettings in TMW:InNLengthTable(settings) do
				displays = displays .. "\r\n" .. TEXT:GetStringName(fontStringSettings, i)
			end
			info.tooltipTitle = TEXT:GetLayoutName(settings, GUID)
			info.tooltipText = L["TEXTLAYOUTS_LAYOUTDISPLAYS"]:format(displays)
			
			info.func = Layout_DropDown_OnClick
			
			TMW.DD:AddButton(info)
		end
	end
end


local usedStrings = {}
function TEXT:CacheUsedStrings()
	for text in pairs(usedStrings) do
		usedStrings[text] = 0 -- set to 0, not nil, and dont wipe the table either
	end
	
	for ics, gs in TMW:InIconSettings() do
		for view, viewSettings in pairs(ics.SettingsPerView) do
		
			local GUID, layoutSettings = TEXT:GetTextLayoutForIconSettings(gs, ics, view)
			local Texts = viewSettings.Texts
			
			-- Get text displays that are used by the current layout.
			for textID = 1, layoutSettings.n do
				local text = TEXT:GetTextFromSettingsAndLayout(Texts, layoutSettings, textID)
				text = text:trim()
				usedStrings[text] = (usedStrings[text] or 0) + 1
			end
			
			-- Get text displays that lie outside the bounds of the current layout.
			for i, text in pairs(Texts) do
				if i > layoutSettings.n then
					text = text:trim()
					usedStrings[text] = (usedStrings[text] or 0) + 1
				end
			end
		end
	end
	
	usedStrings[""] = nil
end

local function CopyString_DropDown_OnClick(button, dropdown)
	local id = dropdown:GetParent():GetParent():GetID()
	
	CI.icon:GetSettingsPerView().Texts[id] = button.value
	
	dropdown:OnSettingSaved()
end
function TEXT.CopyString_DropDown(dropdown)
	TEXT:CacheUsedStrings()
	
	for text, num in TMW:OrderedPairs(usedStrings, nil, true, true) do
		local info = TMW.DD:CreateInfo()
		
		if #text > 50 then
			info.text = DogTag:ColorizeCode(text:sub(1, 40)) .. "..."
		else
			info.text = DogTag:ColorizeCode(text)
		end
		
		info.value = text
		
		info.tooltipTitle = L["TEXTLAYOUTS_STRINGUSEDBY"]:format(num)
		info.tooltipText = DogTag:ColorizeCode(text)
		info.tooltipWrap = false
		info.notCheckable = true
		
		info.arg1 = dropdown
		info.func = CopyString_DropDown_OnClick
		
		TMW.DD:AddButton(info)
	end
end



local function ttText(self)
	GameTooltip:AddLine(L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"]:format(""), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
	GameTooltip:AddLine(self.DefaultText, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, false)
	return nil
end

function TEXT:LoadConfig()
	if not TellMeWhen_TextDisplayOptions or not CI.icon then
		return
	end
	
	local Texts = CI.icon:GetSettingsPerView().Texts
	local GUID, layoutSettings, isFallback = TEXT:GetTextLayoutForIcon(CI.icon)
	
	-- Run this every time that we load the config so that it will cache
	-- strings that might not be used anymore (acts as sort of a backup mechanism)
	TEXT:CacheUsedStrings()
	
	local layoutName
	if layoutSettings then
		local previousFrame
		for i, stringSettings in TMW:InNLengthTable(layoutSettings) do
			local frame = TEXT[i]
			
			local text = TEXT:GetTextFromSettingsAndLayout(Texts, layoutSettings, i)
			
			if not frame then
				frame = CreateFrame("Frame", "$parentString"..i, TellMeWhen_TextDisplayOptions, "TellMeWhen_TextDisplayGroup", i)
				TEXT[i] = frame

				if i == 1 then
					frame:SetPoint("TOPLEFT", TellMeWhen_TextDisplayOptions.Layout, "BOTTOMLEFT", 0, 0)
				else
					frame:SetPoint("TOP", previousFrame, "BOTTOM")
				end

				-- Setup the tooltip for the reset button.
				TMW:TT(frame.Default, "TEXTLAYOUTS_STRING_SETDEFAULT", ttText, nil, 1)
			end
			
			frame:Show()

			frame.stringSettings = stringSettings

			-- display_N_stringName looks something like "Display 1: Binding/Label"
			local display_N_stringName = L["TEXTLAYOUTS_fSTRING2"]:format(i, TEXT:GetStringName(stringSettings, i, true))

			-- Set it as the tooltip title and the label text on the editbox.
			frame.EditBox:SetTexts(display_N_stringName, L["TEXTLAYOUTS_SETTEXT_DESC"])

			frame.EditBox:SetText(text)
			
			-- DefaultText is the text that the string will be reverted to if the user pressed the rest button.
			local DefaultText = stringSettings.DefaultText
			if DefaultText == "" then
				DefaultText = L["TEXTLAYOUTS_BLANK"]
			else
				DefaultText = DogTag:ColorizeCode(DefaultText)
			end
			frame.Default.DefaultText = DefaultText
			
			-- Test the string and its tags & syntax
			frame.Error:SetText(TMW:TestDogTagString(CI.icon, text))
			
			previousFrame = frame
			
			-- Update the height of the text display so that there is room for errors to be displayed.
			TEXT:ResizeTextDisplayFrame(frame)
		end
		
		for i = max(layoutSettings.n + 1, 1), #TEXT do
			TEXT[i]:Hide()
		end
		
		layoutName = TEXT:GetLayoutName(layoutSettings, GUID, true)
	else
		layoutName = "UNKNOWN LAYOUT: " .. (GUID or "<?>")
	end

	-- Set the text of the dropdown to pick the text layout.
	TellMeWhen_TextDisplayOptions.Layout.PickLayout:SetText("|cff666666" .. L["TEXTLAYOUTS_HEADER_LAYOUT"] .. ": |r" .. layoutName)
	

	-- Set the error text for the entire layout (show if we are using a fallback layout)
	TellMeWhen_TextDisplayOptions.Layout.Error:SetText(isFallback and L["TEXTLAYOUTS_ERROR_FALLBACK"] or nil)
	
	-- Validate the anchors for the text layout on the icon.
	-- If there are invalid anchors, display an error message.
	local IconModule_Texts = TMW.CI.icon:GetModuleOrModuleChild("IconModule_Texts")
	if IconModule_Texts then
		local err = IconModule_Texts:CheckAnchorValidity()
		if err then
			TellMeWhen_TextDisplayOptions.Layout.Error:SetText(err)
		end
	end

	-- After we have updated the height of all the child frames, update the height of the parent frame.
	TEXT:ResizeParentFrame()
	
	-- Set the tooltip of the button that opens the layout settings for the currently used text layout
	TMW:TT(TellMeWhen_TextDisplayOptions.Layout.LayoutSettings, "TEXTLAYOUTS_LAYOUTSETTINGS", L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"]:format(layoutName), nil, 1)
end

function TEXT:ResizeParentFrame()
	local layoutHeight = 26 + TellMeWhen_TextDisplayOptions.Layout.Error:GetHeight()
	
	TellMeWhen_TextDisplayOptions.Layout:SetHeight(layoutHeight)
	
	TellMeWhen_TextDisplayOptions:AdjustHeight(10)
end

function TEXT:ResizeTextDisplayFrame(frame)
	local height = 1
	
	if not frame.EditBox or not frame.Error then
		return
	end
	
	height = height + frame.EditBox:GetHeight()
	
	--frame.Error:SetHeight(frame.Error:GetStringHeight())
	height = height + frame.Error:GetHeight()
	
	frame:SetHeight(height)
	
	TEXT:ResizeParentFrame()
end










-------------------------------
-- Group Layout Configuration
-------------------------------


-- TODO: register this on the texts module itself
TMW.C.GroupModule_BaseConfig:RegisterConfigPanel_XMLTemplate(400, "TellMeWhen_GM_TextLayout")

local function Layout_Group_DropDown_OnClick(button)

	local group = TMW.CI.group
	local gs = group:GetSettings()

	gs.SettingsPerView[gs.View].TextLayout = button.value
	
	-- the group setting is a fallback for icons, so there is no reason to set the layout for individual icons
	-- we do need to reset icons to nil so that they will fall back to the group setting, though.
	for icon in group:InIcons() do
		icon:SaveBackup()
	end
	
	for ics in group:InIconSettings() do
		local icspv = rawget(ics.SettingsPerView, gs.View)
		if icspv then
			icspv.TextLayout = nil
		end
	end
	
	for icon in group:InIcons() do
		icon:SaveBackup()
	end
	
	group:Setup()
	
	IE:LoadGroup(1)
	IE:LoadIcon(1)
end
function TEXT:Layout_Group_DropDown()
	for GUID, settings in TMW:OrderedPairs(TMW.db.global.TextLayouts, layoutSort) do
		if GUID ~= "" then
			local info = TMW.DD:CreateInfo()
			
			info.text = TEXT:GetLayoutName(settings, GUID)
			info.value = GUID
			info.checked = GUID == CI.group:GetSettingsPerView().TextLayout
			
			local displays = ""
			for i, fontStringSettings in TMW:InNLengthTable(settings) do
				displays = displays .. "\r\n" .. TEXT:GetStringName(fontStringSettings, i)
			end
			info.tooltipTitle = TEXT:GetLayoutName(settings, GUID)
			info.tooltipText = L["TEXTLAYOUTS_LAYOUTDISPLAYS"]:format(displays)
			
			info.func = Layout_Group_DropDown_OnClick
			
			TMW.DD:AddButton(info)
		end
	end
end










-------------------------------
-- IMPORT/EXPORT
-------------------------------


-- Explicitly sets the text layouts used by an icon on that icon's settings
-- in case that icon is only inheriting from its group.
-- This makes sure that the layout is the same in the destination as it was in the source.
TMW:RegisterCallback("TMW_ICON_PREPARE_SETTINGS_FOR_COPY", function(event, ics, gs)
	if not ics.SettingsPerView then
		return
	end
	
	for view, settingsPerView in pairs(ics.SettingsPerView) do
		local GUID = settingsPerView.TextLayout
		if not GUID then
			local GUID_group = TMW.approachTable(gs, "SettingsPerView", view, "TextLayout")
			if GUID_group and GUID_group ~= TMW.approachTable(TMW.Group_Defaults, "SettingsPerView", view, "TextLayout") then
				GUID = GUID_group
			end
		end
		settingsPerView.TextLayout = GUID
	end
end)



local textlayout = TMW.Classes.SharableDataType:New("textlayout", 15)
textlayout.extrasMap = {"GUID"}
function textlayout:Import_ImportData(Item, GUID)
	assert(type(GUID) == "string")
	
	TMW.db.global.TextLayouts[GUID] = nil -- restore defaults
	local textlayout = TMW.db.global.TextLayouts[GUID]
	TMW:CopyTableInPlaceUsingDestinationMeta(Item.Settings, textlayout, true)
	textlayout.GUID = GUID

	-- We might have imported a default layout. Set it to be editable.
	if textlayout.NoEdit then
		textlayout.NoEdit = false -- must be false, not nil
	end
	
	-- Calculate a new name for the layout if the name is used by another layout.
	repeat
		local found
		for k, layoutSettings in pairs(TMW.db.global.TextLayouts) do
			if layoutSettings ~= textlayout and layoutSettings.Name == textlayout.Name then
				textlayout.Name = TMW.oneUpString(textlayout.Name)
				found = true
				break
			end
		end
	until not found
	
	-- Handle upgrades for the new layout.
	local version = Item.Version
	if version then
		if version > TELLMEWHEN_VERSIONNUMBER then
			TMW:Print(L["FROMNEWERVERSION"])
		else
			TMW:StartUpgrade("textlayout", version, textlayout, GUID)
		end
	end

	-- Run an update incase any icons should be using the new layout.
	TMW:Update()
end
function textlayout:Import_CreateMenuEntry(info, Item, doLabel)
	info.text = TMW.TEXT:GetLayoutName(Item.Settings, Item:GetExtra("GUID"))

	if doLabel then
		info.text = L["fTEXTLAYOUT"]:format(info.text)
	end
end


-- Build a menu for text layouts
TMW.C.SharableDataType.types.database:RegisterMenuBuilder(17, function(Item_database)
	local db = Item_database.Settings

	if db.global.TextLayouts then
		local isGood = false
		for GUID, settings in pairs(db.global.TextLayouts) do
			if GUID ~= "" and settings.GUID then
				isGood = true
				break
			end
		end

		if not isGood then return end


		local SettingsBundle = TMW.Classes.SettingsBundle:New("textlayout")

		for GUID, layout in pairs(db.global.TextLayouts) do
			local Item = TMW.Classes.SettingsItem:New("textlayout")

			Item:SetParent(Item_database)
			Item.Settings = layout
			Item:SetExtra("GUID", GUID)

			SettingsBundle:Add(Item)

		end

		SettingsBundle:CreateParentedMenuEntry(L["TEXTLAYOUTS"])
	end
end)

-- Build a menu for layouts that are still attached to a profile, should only be from an import string.
TMW.C.SharableDataType.types.profile:RegisterMenuBuilder(20, function(Item_profile)

	if Item_profile.Settings.TextLayouts then
		local isGood = false
		for GUID, settings in pairs(Item_profile.Settings.TextLayouts) do
			if GUID ~= "" and settings.GUID then
				isGood = true
				break
			end
		end

		if not isGood then return end


		local SettingsBundle = TMW.Classes.SettingsBundle:New("textlayout")

		for GUID, layout in pairs(Item_profile.Settings.TextLayouts) do
			local Item = TMW.Classes.SettingsItem:New("textlayout")

			Item:SetParent(Item_profile)
			Item.Settings = layout
			Item:SetExtra("GUID", GUID)

			SettingsBundle:Add(Item)

		end

		if SettingsBundle:CreateParentedMenuEntry(L["TEXTLAYOUTS"]) then
			TMW.DD:AddSpacer()
		end
	end
end)

-- Import Layout
textlayout:RegisterMenuBuilder(1, function(Item_textlayout)
	local settings = Item_textlayout.Settings
	local GUID = Item_textlayout:GetExtra("GUID")

	assert(type(GUID) == "string")
	
	local layoutSettings = TMW.TEXT:GetTextLayoutSettings(GUID)
	
	if layoutSettings then
		-- overwrite existing
		local info = TMW.DD:CreateInfo()
		info.disabled = layoutSettings.NoEdit
		info.text = L["TEXTLAYOUTS_IMPORT"] .. " - " .. L["TEXTLAYOUTS_IMPORT_OVERWRITE"]
		info.tooltipTitle = info.text
		info.tooltipText = info.disabled and L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] or L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"]
		info.tooltipWhileDisabled = true
		info.notCheckable = true
		
		info.func = function()
			Item_textlayout:Import(GUID)
		end
		TMW.DD:AddButton(info)
		
		-- create new
		local info = TMW.DD:CreateInfo()
		info.text = L["TEXTLAYOUTS_IMPORT"] .. " - " .. L["TEXTLAYOUTS_IMPORT_CREATENEW"]
		info.tooltipTitle = info.text
		info.tooltipText = L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"]
		info.notCheckable = true
		
		info.func = function()
			Item_textlayout:Import(TMW:GenerateGUID("textlayout", TMW.CONST.GUID_SIZE))
		end
		TMW.DD:AddButton(info)
	else
		-- import normally - the layout doesnt already exist
		local info = TMW.DD:CreateInfo()
		info.text = L["TEXTLAYOUTS_IMPORT"]
		info.tooltipTitle = info.text
		info.tooltipText = L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"]
		info.notCheckable = true
		
		info.func = function()
			Item_textlayout:Import(GUID)
		end
		TMW.DD:AddButton(info)
	
	end
end)


function textlayout:Export_SetButtonAttributes(editbox, info)
	local IMPORTS, EXPORTS = editbox:GetAvailableImportExportTypes()
	local GUID = EXPORTS[self.type]
	
	local text = L["fTEXTLAYOUT"]:format(TMW.TEXT:GetLayoutName(nil, GUID))
	info.text = text
	info.tooltipTitle = text
end
function textlayout:Export_GetArgs(editbox)
	-- settings, defaults, ...
	local IMPORTS, EXPORTS = editbox:GetAvailableImportExportTypes()
	local GUID = EXPORTS[self.type]
	assert(type(GUID) == "string")
	local settings = TMW.TEXT:GetTextLayoutSettings(GUID)
	
	return settings, TMW.Defaults.global.TextLayouts["**"], GUID
end





-- Determine if the requesting editbox can import or export a text layout.
TMW:RegisterCallback("TMW_CONFIG_REQUEST_AVAILABLE_IMPORT_EXPORT_TYPES", function(event, editbox, import, export)
	
	import.textlayout_new = true

	if IE.CurrentTabGroup.identifier == "ICON" and CI.icon then
		-- The user is editing an icon. Work with the current icon's layout.
		local GUID = TEXT:GetTextLayoutForIcon(CI.icon)
		local settings = TMW.TEXT:GetTextLayoutSettings(GUID)
		
		import.textlayout_overwrite = GUID

		-- Don't list default text layouts since so many people get so confused by them for some reason.
		if not settings.NoEdit then
			export.textlayout = GUID
		end

	elseif IE.CurrentTab == Tab then	
		-- The user is editing a text layout. Work with that layout.
		-- GUID may be nil if no layout is selected, but that's ok.
		local GUID = TEXT:GetCurrentLayoutAndDisplay()

		import.textlayout_overwrite = GUID
		export.textlayout = GUID
	end
end)


-- This function is recursive. Don't inline it with the RegisterCallback call.
local function GetTextLayouts(event, strings, type, settings)
	if type == "icon" or type == "group" then
		for view, settingsPerView in pairs(settings.SettingsPerView) do
			local GUID = settingsPerView.TextLayout

			if GUID and GUID ~= "" then
				local layout = rawget(TMW.db.global.TextLayouts, GUID)
				if layout and not layout.NoEdit then
					TMW:GetSettingsStrings(strings, "textlayout", layout, TMW.Defaults.global.TextLayouts["**"], GUID)
				end
			end
		end
	end

	if type == "group" then
		for iconID, ics in pairs(settings.Icons) do
			GetTextLayouts(event, strings, "icon", ics)
		end
	end

	if type == "profile" then
		for groupID, gs in pairs(settings.Groups) do
			GetTextLayouts(event, strings, "group", gs)
		end
	end
end
TMW:RegisterCallback("TMW_EXPORT_SETTINGS_REQUESTED", GetTextLayouts)
