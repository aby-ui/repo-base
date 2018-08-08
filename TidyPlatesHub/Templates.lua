local font = TidyPlatesHubLocalizedFont or "Interface\\Addons\\TidyPlates\\Media\\DefaultFont.ttf"
local divider = "Interface\\Addons\\TidyPlatesHub\\shared\\ThinBlackLine"

local PanelHelpers = TidyPlatesUtility.PanelHelpers 		-- PanelTools
local DropdownFrame = CreateFrame("Frame", "TidyPlatesHubCategoryFrame", UIParent, "UIDropDownMenuTemplate" )
local L = TidyPlatesHub_GetLocalizedString

-- Menu Templates
TidyPlatesHubMenus = TidyPlatesHubMenus or {}

TidyPlatesHubMenus.ScaleModes = {}
TidyPlatesHubMenus.EnemyOpacityModes = {}
TidyPlatesHubMenus.FriendlyOpacityModes = {}
TidyPlatesHubMenus.EnemyBarModes = {}
TidyPlatesHubMenus.FriendlyBarModes = {}
TidyPlatesHubMenus.StyleModes = {}
TidyPlatesHubMenus.TextModes = {}
TidyPlatesHubMenus.HeadlineEnemySubtexts = {}
TidyPlatesHubMenus.NameColorModes = {}

--TidyPlatesHubMenus.RangeModes = {}
--TidyPlatesHubMenus.DebuffStyles = {}
--TidyPlatesHubMenus.AuraWidgetModes = {}
--TidyPlatesHubMenus.ThreatWarningModes = {}


--[[
The basic concept of RapidPanel is that each UI widget will get attached to a 'rail' or alignment column.  This rail
provides access to a common update function.  Each widget gets attached as a stack, with widget definition tagging
the previous widget to anchor to.  Default and consistent anchor points also make for less work.

--]]


local function QuickSetPoints(frame, columnFrame, neighborFrame, xOffset, yOffset)
		local TopOffset = frame.Margins.Top + (yOffset or 0)
		local LeftOffset = frame.Margins.Left + (xOffset or 0)
		frame:ClearAllPoints()
		if neighborFrame then
			if neighborFrame.Margins then TopOffset = neighborFrame.Margins.Bottom + TopOffset + (yOffset or 0) end
			frame:SetPoint("TOP", neighborFrame, "BOTTOM", -(neighborFrame:GetWidth()/2), -TopOffset)
		else frame:SetPoint("TOP", columnFrame, "TOP", 0, -TopOffset) end
		frame:SetPoint("LEFT", columnFrame, "LEFT", LeftOffset, 0)
end

local function CreateQuickSlider(name, label, ... ) --, neighborFrame, xOffset, yOffset)
		local columnFrame = ...
		local frame = PanelHelpers:CreateSliderFrame(name, columnFrame, label, .5, 0, 1, .1)
		frame:SetWidth(250)
		--frame.Label:SetFont("FONTS/ARIALN.TTF", 14)
		-- Margins	-- Bottom/Left are negative
		frame.Margins = { Left = 12, Right = 8, Top = 20, Bottom = 13,}
		QuickSetPoints(frame, ...)
		-- Set Feedback Function
		frame:SetScript("OnMouseUp", function()
			--OnPanelItemChange()
			columnFrame.Callback()
			--if columnFrame.OnFeedback then columnFrame:OnFeedback() end
		end)
		return frame, frame
	end

	local function CreateQuickCheckbutton(name, label, ...)
		local columnFrame = ...
		local frame = PanelHelpers:CreateCheckButton(name, columnFrame, label)
		--frame.Label:SetFont("FONTS/ARIALN.TTF", 14)
		-- Margins	-- Bottom/Left are supposed to be negative
		frame.Margins = { Left = 2, Right = 100, Top = 0, Bottom = 0,}
		QuickSetPoints(frame, ...)
		-- Set Feedback Function
		frame:SetScript("OnClick", function()
			--OnPanelItemChange()
			columnFrame.Callback()
			--if columnFrame.OnFeedback then columnFrame:OnFeedback() end
		end)
		return frame, frame
	end

	local function SetSliderMechanics(slider, value, minimum, maximum, increment)
		slider:SetMinMaxValues(minimum, maximum)
		slider:SetValueStep(increment)
		slider:SetValue(value)
	end

	local function CreateQuickEditbox(name, ...)
		local columnFrame = ...
		local frame = CreateFrame("ScrollFrame", name, columnFrame, "UIPanelScrollFrameTemplate")
		frame.BorderFrame = CreateFrame("Frame", nil, frame )
		local EditBox = CreateFrame("EditBox", nil, frame)
		-- Margins	-- Bottom/Left are supposed to be negative
		frame.Margins = {Left = 4, Right = 24, Top = 8, Bottom = 8, }

		-- Frame Size
		frame:SetWidth(165)
		frame:SetHeight(125)
		-- Border
		frame.BorderFrame:SetPoint("TOPLEFT", 0, 5)
		frame.BorderFrame:SetPoint("BOTTOMRIGHT", 3, -5)
		frame.BorderFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
											edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
											tile = true, tileSize = 16, edgeSize = 16,
											insets = { left = 4, right = 4, top = 4, bottom = 4 }
											});
		frame.BorderFrame:SetBackdropColor(0.05, 0.05, 0.05, 0)
		frame.BorderFrame:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
		-- Text

		EditBox:SetPoint("TOPLEFT")
		EditBox:SetPoint("BOTTOMLEFT")
		EditBox:SetHeight(100)
		EditBox:SetWidth(150)
		EditBox:SetMultiLine(true)

		EditBox:SetFrameLevel(frame:GetFrameLevel()-1)
		EditBox:SetFont(GameFontNormal:GetFont(), 11, "NONE")
		EditBox:SetText("Empty")
		EditBox:SetAutoFocus(false)
		EditBox:SetTextInsets(9, 6, 2, 2)
		frame:SetScrollChild(EditBox)
		frame.EditBox = EditBox
		--EditBox:SetIndentedWordWrap(true)
		--print(name, EditBox:GetFrameLevel(), frame:GetFrameLevel(), EditBox:GetFrameStrata(), frame:GetFrameStrata())
		-- Functions
		--function frame:GetValue() return SplitToTable(strsplit("\n", EditBox:GetText() )) end
		--function frame:SetValue(value) EditBox:SetText(TableToString(value)) end
		function frame:GetValue() return EditBox:GetText() end
		function frame:SetValue(value) EditBox:SetText(value) end
		frame._SetWidth = frame.SetWidth
		function frame:SetWidth(value) frame:_SetWidth(value); EditBox:SetWidth(value) end
		-- Set Positions
		QuickSetPoints(frame, ...)
		-- Set Feedback Function
		--frame.OnValueChanged = columnFrame.OnFeedback
		return frame, frame
	end

	local function CreateQuickColorbox(name, label, ...)
		local columnFrame = ...
		local frame = PanelHelpers:CreateColorBox(name, columnFrame, label, 0, .5, 1, 1)
		-- Margins	-- Bottom/Left are supposed to be negative
		frame.Margins = { Left = 5, Right = 100, Top = 3, Bottom = 2,}
		-- Set Positions
		QuickSetPoints(frame, ...)
		-- Set Feedback Function
		frame.OnValueChanged = function() columnFrame.Callback() end
		--frame.OnValueChanged = columnFrame.OnFeedback
		return frame, frame
	end

	local function CreateQuickDropdown(name, label, dropdownTable, initialValue, ...)
		local columnFrame = ...

		local frame = PanelHelpers:CreateDropdownFrame(name, columnFrame, dropdownTable, initialValue, label)		--- ADD the new valueMethod  (2 for Token)
		-- Margins	-- Bottom/Left are supposed to be negative
		frame.Margins = { Left = -12, Right = 2, Top = 22, Bottom = 0,}
		-- Set Positions
		QuickSetPoints(frame, ...)
		-- Set Feedback Function
		frame.OnValueChanged = function() columnFrame.Callback() end
		--frame.OnValueChanged = columnFrame.OnFeedback
		return frame, frame
	end

	local function CreateQuickHeadingLabel(name, label, ...)
		local columnFrame = ...
		local frame = CreateFrame("Frame", name, columnFrame)
		-- Heading Appearance
		frame:SetHeight(26)
		frame:SetWidth(500)
		frame.Text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		frame.Text:SetFont(GameFontNormal:GetFont(), 22) --frame.Text:SetFont(font, 26)
		frame.Text:SetTextColor(255/255, 105/255, 6/255)
		frame.Text:SetAllPoints()
		frame.Text:SetText(label)
		frame.Text:SetJustifyH("LEFT")
		frame.Text:SetJustifyV("BOTTOM")
                -- Divider Line
                frame.DividerLine = frame:CreateTexture(nil, 'ARTWORK')
                frame.DividerLine:SetTexture(divider)
                frame.DividerLine:SetSize( 500, 12)
                frame.DividerLine:SetPoint("BOTTOMLEFT", frame.Text, "TOPLEFT", 0, 5)
		-- Margins
		frame.Margins = { Left = 6, Right = 2, Top = 12, Bottom = 2,}
		-- Set Positions
		QuickSetPoints(frame, ...)
		-- Bookmark
		local bookmark = CreateFrame("Frame", nil, columnFrame)
		bookmark:SetPoint("TOPLEFT", columnFrame, "TOPLEFT")
		bookmark:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
		columnFrame.Headings = columnFrame.Headings or {}
		columnFrame.Headings[(#columnFrame.Headings)+1] = label
		columnFrame.HeadingBookmarks = columnFrame.HeadingBookmarks or {}
		columnFrame.HeadingBookmarks[label] = bookmark
		-- Done!
		return frame, frame
	end

	local function CreateDrawer(name, label, ...)
		local columnFrame = ...
		local frame = CreateFrame("Frame", name, columnFrame)
		frame.AnchorButton = CreateFrame("Button", name.."Button", columnFrame)

		-- Heading Appearance
		frame:SetHeight(26)
		frame:SetWidth(500)
		-- Clicky Button

		--frame.Border = frame:CreateTexture(nil, "ARTWORK")

		frame.Text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		frame.Text:SetFont(font, 26)
		frame.Text:SetTextColor(255/255, 105/255, 6/255)
		frame.Text:SetAllPoints()
		frame.Text:SetText("Test Text")
		frame.Text:SetJustifyH("LEFT")
		frame.Text:SetJustifyV("BOTTOM")

		--frame.Button = CreateFrame("Button", name.."Button", frame)

		--local frame = CreateFrame("ScrollFrame", name, columnFrame, "UIPanelScrollFrameTemplate")
		--:SetScrollChild()

		-- Margins
		frame.Margins = { Left = 6, Right = 2, Top = 12, Bottom = 2,}
		-- Set Positions
		QuickSetPoints(frame.AnchorButton, ...)
		frame:SetPoint("TOPLEFT", frame.AnchorButton, "TOPLEFT", 0, 0)
		-- Done!
		return frame, frame
	end

	local function CreateQuickItemLabel(name, label, ...)
		local columnFrame = ...
		local frame = CreateFrame("Frame", name, columnFrame)
		frame:SetHeight(15)
		frame:SetWidth(500)
		frame.Text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		--frame.Text = frame:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		-- frame.Text:SetFont("Fonts\\FRIZQT__.TTF", 18 )
		-- frame.Text:SetFont("Fonts\\ARIALN.TTF", 18 )
		--frame.Text:SetFont(font, 22 )
		--frame.Text:SetTextColor(1, .7, 0)
		--frame.Text:SetTextColor(55/255, 173/255, 255/255)
		frame.Text:SetAllPoints()
		frame.Text:SetText(label)
		frame.Text:SetJustifyH("LEFT")
		frame.Text:SetJustifyV("BOTTOM")
		-- Margins	-- Bottom/Left are supposed to be negative
		frame.Margins = { Left = 6, Right = 2, Top = 2, Bottom = 2,}
		-- Set Positions
		QuickSetPoints(frame, ...)
		return frame, frame
	end

local function OnMouseWheelScrollFrame(frame, value, name)
	local scrollbar = _G[frame:GetName() .. "ScrollBar"];
	local currentPosition = scrollbar:GetValue()
	local increment = 50

	-- Spin Up
	if ( value > 0 ) then scrollbar:SetValue(currentPosition - increment);
	-- Spin Down
	else scrollbar:SetValue(currentPosition + increment); end
end


TidyPlatesHubRapidPanel = {}
TidyPlatesHubRapidPanel.CreateQuickSlider = CreateQuickSlider
TidyPlatesHubRapidPanel.CreateQuickCheckbutton = CreateQuickCheckbutton
TidyPlatesHubRapidPanel.SetSliderMechanics = SetSliderMechanics
TidyPlatesHubRapidPanel.CreateQuickEditbox = CreateQuickEditbox
TidyPlatesHubRapidPanel.CreateQuickColorbox = CreateQuickColorbox
TidyPlatesHubRapidPanel.CreateQuickDropdown = CreateQuickDropdown
TidyPlatesHubRapidPanel.CreateQuickHeadingLabel = CreateQuickHeadingLabel
TidyPlatesHubRapidPanel.CreateQuickItemLabel = CreateQuickItemLabel
TidyPlatesHubRapidPanel.OnMouseWheelScrollFrame = OnMouseWheelScrollFrame

--[[
local CreateQuickSlider = TidyPlatesHubRapidPanel.CreateQuickSlider
local CreateQuickCheckbutton = TidyPlatesHubRapidPanel.CreateQuickCheckbutton
local SetSliderMechanics = TidyPlatesHubRapidPanel.SetSliderMechanics
local CreateQuickEditbox = TidyPlatesHubRapidPanel.CreateQuickEditbox
local CreateQuickColorbox = TidyPlatesHubRapidPanel.CreateQuickColorbox
local CreateQuickDropdown = TidyPlatesHubRapidPanel.CreateQuickDropdown
local CreateQuickHeadingLabel = TidyPlatesHubRapidPanel.CreateQuickHeadingLabel
local CreateQuickItemLabel = TidyPlatesHubRapidPanel.CreateQuickItemLabel
local OnMouseWheelScrollFrame = TidyPlatesHubRapidPanel.OnMouseWheelScrollFrame
--]]


---------------
-- Helpers
---------------
local yellow, blue, red, orange = "|cffffff00", "|cFF3782D1", "|cFFFF1100", "|cFFFF6906"

local GetPanelValues = TidyPlatesHubHelpers.GetPanelValues
local SetPanelValues = TidyPlatesHubHelpers.SetPanelValues
local ListToTable = TidyPlatesHubHelpers.ListToTable
--local ConvertStringToTable = TidyPlatesHubHelpers.ConvertStringToTable
--local ConvertDebuffListTable = TidyPlatesHubHelpers.ConvertDebuffListTable
local CopyTable = TidyPlatesUtility.copyTable

--[[
local function GetGlobalSettings()

end

local function SetGlobalSettings()

end

--]]

local function CheckVariableIntegrity(objectName)
	for i,v in pairs(TidyPlatesHubDefaults) do
		if TidyPlatesHubSettings[objectName][i] == nil then TidyPlatesHubSettings[objectName][i] = v end
	end
end

local function CheckCacheSet(objectName)
	for i,v in pairs(TidyPlatesHubDefaults) do
		if TidyPlatesHubCache[objectName][i] == nil then TidyPlatesHubCache[objectName][i] = v end
	end
end

local function GetCacheSet(objectName)
	if not TidyPlatesHubCache[objectName] then
		TidyPlatesHubCache[objectName] = {}
	end
	CheckCacheSet(objectName)
	return TidyPlatesHubCache[objectName]
end

local function CreateVariableSet(objectName)
	--print("CreateVariableSet", objectName)
	-- New Behavior: Check for a template
	local cacheSet = GetCacheSet("SavedTemplate")
	TidyPlatesHubSettings[objectName] = CopyTable(cacheSet or TidyPlatesHubDefaults)

	-- Old Behavior: Just load defaults
	--TidyPlatesHubSettings[objectName] = CopyTable( TidyPlatesHubDefaults)

	return TidyPlatesHubSettings[objectName]
end

local function GetVariableSet(panel)
	if panel then

		local objectName = panel.objectName

		local settings = TidyPlatesHubSettings[objectName]
		if not settings then

			settings = CreateVariableSet(objectName)
		end
		--print("GetVariableSet", panel, objectName, settings)
		return settings
	else
		--return TidyPlatesHubDefaults
	end
end



local function ClearVariableSet(panel)
	for i, v in pairs(TidyPlatesHubSettings[panel.objectName]) do TidyPlatesHubSettings[panel.objectName][i] = nil end
	TidyPlatesHubSettings[panel.objectName] = nil
	ReloadUI()
end

local function OnPanelItemChange(panel)
	local LocalVars = GetVariableSet(panel)
	GetPanelValues(panel, LocalVars)
	panel.RefreshSettings(LocalVars)
end

-- Colors
local yellow, blue, red, orange = "|cffffff00", "|cFF5599EE", "|cFFFF1100", "|cFFFF9920"

local function PasteSettings(panel)
	local cacheName, LocalVars

	print(blue.."Settings Retrieved")

	cacheName = "SavedTemplate"

	LocalVars = GetCacheSet(cacheName)

	SetPanelValues(panel, LocalVars)
	OnPanelItemChange(panel)
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function CopySettings(panel)
	local cacheName, LocalVars

--[[
	if IsShiftKeyDown() then
		cacheName = panel.objectName
		--print(blue.."Settings copied to the "..yellow..panel.name..blue.." clipboard."..yellow.."  To use these values, hold down 'Shift' while clicking 'Paste'.")
	else
		cacheName = "GlobalClipboard"
		--print(blue.."Settings copied to the clipboard.")
	end
--]]

	cacheName = "SavedTemplate"
	print(blue.."Settings Stored")

	-- Get a pointer for the cache set
	LocalVars = GetCacheSet(cacheName)

	-- Store the panel values into the LocalVars/Cache table
	GetPanelValues(panel, LocalVars)

	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
end

local function ResetSettings(panel)
	if IsShiftKeyDown() then
		ClearVariableSet(panel)
		CreateVariableSet(panel.objectName)
		ReloadUI()
	else
		SetPanelValues(panel, TidyPlatesHubDefaults)
		OnPanelItemChange(panel)
		print(yellow.."Resetting "..orange..panel.name..yellow.." Configuration to Default")
		print(yellow.."Holding down "..blue.."Shift"..yellow.." while clicking "..red.."Reset"..yellow.." will clear all saved settings, cached data, and reload the user interface.")
	end
end

local function AddDropdownTitle(title)
	local DropdownTitle, DropdownSpacer = {}, {}

	-- Define Spacer
	DropdownSpacer.text = ""
	DropdownSpacer.notCheckable = 1
	DropdownSpacer.isTitle = 1

	-- Define Title
	DropdownTitle.text = title
	DropdownTitle.notCheckable = 1
	DropdownTitle.isTitle = 1
	DropdownTitle.padding = 16

	-- Add Menu Buttons
	UIDropDownMenu_AddButton(DropdownTitle)
	--UIDropDownMenu_AddButton(DropdownSpacer)
end


local function CreateInterfacePanel( objectName, panelTitle, parentFrameName)

	-- Variables
	------------------------------
	-- This can be created later...
	--CreateVariableSet(objectName)

	-- Panel
	------------------------------
	local panel = CreateFrame( "Frame", objectName.."_InterfaceOptionsPanel", UIParent);
	panel.objectName = objectName
	panel:SetBackdrop({	bgFile = "Interface/Tooltips/UI-Tooltip-Background", --bgFile = "Interface/FrameGeneral/UI-Background-Marble",
						edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
						edgeSize = 16,
						insets = { left = 4, right = 4, top = 4, bottom = 4 },})

	--panel:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", insets = { left = 2, right = 2, top = 2, bottom = 2 },})
	panel:SetBackdropColor(.1, .1, .1, .6)
	panel:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	--panel:SetBackdropColor(0.06, 0.06, 0.06, .5)

	if parentFrameName then
		panel.parent = parentFrameName
	end

	panel.name = panelTitle

	-- Heading
	------------------------------
	--panel.MainLabel = CreateQuickHeadingLabel(nil, panelTitle, panel, nil, 16, 16)
	panel.MainLabel = CreateQuickHeadingLabel(nil, panelTitle, panel, nil, 16, 8)

        -- Warnings
        ------------------------------
	panel.WarningFrame = CreateFrame("Frame", objectName.."WarningFrame", panel )
	panel.WarningFrame:SetPoint("LEFT", 16, 0 )
	panel.WarningFrame:SetPoint("TOP", panel.MainLabel, "BOTTOM", 0, -8 )
        panel.WarningFrame:SetPoint("RIGHT", -16 , 16 )
        panel.WarningFrame:SetHeight(50)
	panel.WarningFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
												edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
												--tile = true, tileSize = 16,
												edgeSize = 16,
												insets = { left = 4, right = 4, top = 4, bottom = 4 }
												});
	--panel.WarningFrame:SetBackdropColor(0.5, 0.5, 0.5, 1)
	panel.WarningFrame:SetBackdropColor(.9, 0.3, 0.2, 1)
	panel.WarningFrame:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
	panel.WarningFrame:Hide()
        -- Description
        panel.Warnings = CreateQuickHeadingLabel(nil, "", panel.WarningFrame, nil, 8, -4)
        -- Button
	local WarningFixButton = CreateFrame("Button", objectName.."WarningFixButton", panel.WarningFrame, "TidyPlatesPanelButtonTemplate")
	WarningFixButton:SetPoint("RIGHT", -10, 0)
	WarningFixButton:SetWidth(150)
        WarningFixButton:SetText("问题修复...")


	-- Main Scrolled Frame
	------------------------------
	panel.MainFrame = CreateFrame("Frame")
	panel.MainFrame:SetWidth(412)
	panel.MainFrame:SetHeight(2760) 		-- This can be set VERY long since we've got it in a scrollable window.

	-- Scrollable Panel Window
	------------------------------
	panel.ScrollFrame = CreateFrame("ScrollFrame",objectName.."_Scrollframe", panel, "UIPanelScrollFrameTemplate")
	panel.ScrollFrame:SetPoint("LEFT", 16 )
	panel.ScrollFrame:SetPoint("TOP", panel.MainLabel, "BOTTOM", 0, -8 )
	panel.ScrollFrame:SetPoint("BOTTOMRIGHT", -32 , 16 )
	panel.ScrollFrame:SetScrollChild(panel.MainFrame)
	panel.ScrollFrame:SetScript("OnMouseWheel", OnMouseWheelScrollFrame)

	-- Scroll Frame Border
	------------------------------
	panel.ScrollFrameBorder = CreateFrame("Frame", objectName.."ScrollFrameBorder", panel.ScrollFrame )
	panel.ScrollFrameBorder:SetPoint("TOPLEFT", -4, 5)
	panel.ScrollFrameBorder:SetPoint("BOTTOMRIGHT", 3, -5)
	panel.ScrollFrameBorder:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background",
												edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
												--tile = true, tileSize = 16,
												edgeSize = 16,
												insets = { left = 4, right = 4, top = 4, bottom = 4 }
												});
	panel.ScrollFrameBorder:SetBackdropColor(0.05, 0.05, 0.05, 0)
	panel.ScrollFrameBorder:SetBackdropBorderColor(0.2, 0.2, 0.2, 0)

	-- Alignment Colum
	------------------------------
	panel.AlignmentColumn = CreateFrame("Frame", objectName.."_AlignmentColumn", panel.MainFrame)
	panel.AlignmentColumn:SetPoint("TOPLEFT", 12,0)
	panel.AlignmentColumn:SetPoint("BOTTOMRIGHT", panel.MainFrame, "BOTTOM")
	panel.AlignmentColumn.Callback = function() OnPanelItemChange(panel) end

	-----------------
	-- Panel Event Handler
	-----------------


	--panel:SetScript("OnEvent", function()
	panel:SetScript("OnShow", function()
		-- Check for Variable Set
		if not GetVariableSet(panel) then CreateVariableSet(objectName) end
		-- Verify Variable Integrity
		CheckVariableIntegrity(objectName)
		-- Refresh Panel based on loaded variables
		if panel.RefreshSettings then panel.RefreshSettings(GetVariableSet(panel)) end
	end)

	--panel:RegisterEvent("PLAYER_ENTERING_WORLD")



	-----------------
	-- Config Management Buttons
	-----------------


	-- Paste
	local PasteThemeDataButton = CreateFrame("Button", objectName.."PasteThemeDataButton", panel, "TidyPlatesPanelButtonTemplate")
	PasteThemeDataButton.tooltipText = "从已存储的模板里加载配置"
	PasteThemeDataButton:SetPoint("TOPRIGHT", -40, -22)
	PasteThemeDataButton:SetWidth(110)
	PasteThemeDataButton:SetScale(.85)
	PasteThemeDataButton:SetText("加载模板")

	PasteThemeDataButton:SetScript("OnClick", function() PasteSettings(panel); end)

	-- Copy
	local CopyThemeDataButton = CreateFrame("Button", objectName.."CopyThemeDataButton", panel, "TidyPlatesPanelButtonTemplate")
	CopyThemeDataButton.tooltipText = "使用当前设置作为模板"
	---- This feature works between matching panel types (ie. Hub/Damage to Hub/Damage)
	CopyThemeDataButton:SetPoint("TOPRIGHT", PasteThemeDataButton, "TOPLEFT", -4, 0)
	CopyThemeDataButton:SetWidth(110)
	CopyThemeDataButton:SetScale(.85)
	CopyThemeDataButton:SetText("存为模板")

	CopyThemeDataButton:SetScript("OnClick", function() CopySettings(panel); end)

	-- Reset
	local ReloadThemeDataButton = CreateFrame("Button", objectName.."ReloadThemeDataButton", panel, "TidyPlatesPanelButtonTemplate")
	ReloadThemeDataButton.tooltipText = "重置配置恢复默认.  按着'Shift'以便清空数据和重置UI."
	ReloadThemeDataButton:SetPoint("TOPRIGHT", CopyThemeDataButton, "TOPLEFT", -4, 0)
	ReloadThemeDataButton:SetWidth(60)
	ReloadThemeDataButton:SetScale(.85)
	ReloadThemeDataButton:SetText("重置")

	ReloadThemeDataButton:SetScript("OnClick", function()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON); ResetSettings(panel);
	end)

-- [[
	-- Bookmark/Table of Contents Button
	local BookmarkButton = CreateFrame("Button", objectName.."BookmarkButton", panel, "TidyPlatesPanelButtonTemplate")
	BookmarkButton:SetPoint("TOPRIGHT", ReloadThemeDataButton, "TOPLEFT", -4, 0)
	BookmarkButton:SetWidth(110)
	BookmarkButton:SetScale(.85)
	BookmarkButton:SetText("导 航")


	local function OnClickBookmark(frame)
		local scrollTo = panel.AlignmentColumn.HeadingBookmarks[frame:GetText()]:GetHeight()
		--print(frame:GetText(), scrollTo)
		panel.ScrollFrame:SetVerticalScroll(ceil(scrollTo - 27))
		PanelHelpers.HideDropdownMenu()
	end

	local function OnClickBookmarkDrawer(frame)
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)

		if not (panel.AlignmentColumn and panel.AlignmentColumn.Headings) then return end
		local BookmarkMenu = {}


		for index, name in pairs(panel.AlignmentColumn.Headings) do
			BookmarkMenu[index] = {}
			BookmarkMenu[index].text = name
		end

		PanelHelpers.ShowDropdownMenu(BookmarkButton, BookmarkMenu, OnClickBookmark)
	end


	BookmarkButton:SetScript("OnClick", OnClickBookmarkDrawer )
--]]

	local function SetMaximizeButtonTexture(frame)
		--frame:SetNormalTexture("Interface\\Buttons\\UI-Panel-BiggerButton-Up")
		frame:SetNormalTexture("Interface\\Buttons\\UI-Panel-SmallerButton-Up")
		--frame:SetPushedTexture("Interface\\Buttons\\UI-Panel-BiggerButton-Down")
		frame:SetPushedTexture("Interface\\Buttons\\UI-Panel-SmallerButton-Down")
	end

	-- Unlink - Detach -
	local ClosePanel, UnLinkPanel, EnableUnlink
	local UnlinkButton
	UnlinkButton = CreateFrame("Button", objectName.."UnlinkButton", panel, "UIPanelCloseButton")
	UnlinkButton:SetPoint("LEFT", PasteThemeDataButton, "RIGHT", 0, -0.5)
	UnlinkButton:SetScale(.95)
	SetMaximizeButtonTexture(UnlinkButton)



	EnableUnlink = function()
		UnlinkButton:SetScript("OnClick", UnLinkPanel)
		SetMaximizeButtonTexture(UnlinkButton)
		UnlinkButton:SetScript("OnClick", UnLinkPanel)

		--panel:SetScale(1)
		panel:SetMovable(false)
		panel:SetScript("OnDragStart",nil)
		panel:SetScript("OnDragStop",nil)
                panel:SetBackdropColor(.1, .1, .1, .6)
	end

	-- The Unlink feature will pop the config panel onto its own movable window frame
	UnLinkPanel = function (self)
		HideUIPanel(InterfaceOptionsFrame)		-- ShowUIPanel(InterfaceOptionsFrame);
		local height, width = panel:GetHeight(), panel:GetWidth()
		panel:SetParent(UIParent)
		panel:ClearAllPoints()
		panel:SetHeight(height - 40)
		panel:SetWidth(width - 60)
		panel:SetPoint("CENTER")
		--panel:SetScale(.95)
                panel:SetBackdropColor(.1, .1, .1, 1)

		--[[
		panel:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background",
											edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
											--edgeFile = "Interface/DialogFrame/UI-DialogBox-Gold-Border",
											--tile = true, tileSize = 16,
											edgeSize = 16,
											insets = { left = 4, right = 4, top = 4, bottom = 4 }
											});

		--panel:SetBackdropColor(0.05, 0.05, 0.05, .8)
		panel:SetBackdropColor(0.06, 0.06, 0.06, 1)
		panel:SetBackdropBorderColor(0.2, 0.2, 0.2, 1)
		--]]

		panel:SetClampedToScreen(true)
		panel:RegisterForDrag("LeftButton")
		panel:EnableMouse(true)
		panel:SetMovable(true)
		panel:SetScript("OnDragStart", function(self, button) panel:SetAlpha(.9); if button =="LeftButton" then panel:StartMoving() end end)
		panel:SetScript("OnDragStop", function(self, button) panel:SetAlpha(1); panel:StopMovingOrSizing() end)

		-- Repurpose button for Close
		self:SetScript("OnClick", ClosePanel)
		self:SetScale(.90)
		self:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
		self:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")
	end

	ClosePanel = function(self)
		OnPanelItemChange(panel)
		EnableUnlink()
		panel:Hide()
	end

        local function OpenTidyPlatesConfig()
            InterfaceOptionsFrame_OpenToCategory("Tidy Plates")
        end

        local RefreshPanel = function(self)
            SetPanelValues(panel, GetVariableSet(panel))
            EnableUnlink(UnlinkButton)

            local activeTheme = TidyPlates:GetTheme()

            if activeTheme.OnUpdate and (activeTheme.OnUpdate == TidyPlatesHubFunctions.OnUpdate) then
            	panel.WarningFrame:Hide()
                panel.ScrollFrame:SetPoint("TOP", panel.MainLabel, "BOTTOM", 0, -8 )        -- Default

     		else
				panel.ScrollFrame:SetPoint("TOP", panel.WarningFrame, "BOTTOM", 0, -8 )     -- Warning
                panel.WarningFrame:Show()
                panel.Warnings.Text:SetText("你目前使用着尚未兼容的主题.")
                panel.Warnings.Text:SetTextColor(1, 1, 1)
                panel.Warnings.Text:SetFont(font, 18)

                WarningFixButton:SetText("更换主题...")
                WarningFixButton:SetScript("OnClick", OpenTidyPlatesConfig)
            end

            --[[
            -- On Warning...
            panel.ScrollFrame:SetPoint("TOP", panel.MainLabel, "BOTTOM", 0, -8       -- Default
            panel.ScrollFrame:SetPoint("TOP", panel.MainLabel, "BOTTOM", 0, -8       -- Default

            panel.ScrollFrame:SetPoint("TOP", panel.WarningFrame, "BOTTOM", 0, -8 )     -- Warning

            panel.WarningFrame:Hide()
        -- Description
        panel.Warnings
            --]]
            --Theme.ShowConfigPanel = ShowTidyPlatesHubDamagePanel
        end

	-----------------
	-- Button Handlers
	-----------------
	panel.okay = ClosePanel --function() OnPanelItemChange(panel) end
	panel.refresh = RefreshPanel
        panel:SetScript("OnShow", RefreshPanel)
	UnlinkButton:SetScript("OnClick", UnLinkPanel)

	InterfaceOptions_AddCategory(panel)
	----------------
	-- Return a pointer to the whole thingy
	----------------
	return panel
end

TidyPlatesHubRapidPanel.CreateInterfacePanel = CreateInterfacePanel
TidyPlatesHubRapidPanel.CreateVariableSet = CreateVariableSet

