TidyPlatesUtility = {}

-------------------------------------------------------------------------------------
--  General Helpers
-------------------------------------------------------------------------------------
local _

local copytable         -- Allows self-reference
copytable = function(original)
	local duplicate = {}
	for key, value in pairs(original) do
		if type(value) == "table" then duplicate[key] = copytable(value)
		else duplicate[key] = value end
	end
	return duplicate
end


TidyPlatesUtility.IsFriend = function(...) end
--TidyPlatesUtility.IsHealer =
TidyPlatesUtility.IsGuildmate = function(...) end

local function RaidMemberCount()
	if UnitInRaid("player") then
		return GetNumGroupMembers()
	end
end

local function PartyMemberCount()
	if UnitInParty("player") then
		return GetNumGroupMembers()
	end
end

local function GetSpec()
	return GetActiveSpecGroup()
end

TidyPlatesUtility.GetNumRaidMembers = RaidMemberCount
TidyPlatesUtility.GetNumPartyMembers = PartyMemberCount
TidyPlatesUtility.GetSpec = GetSpec

local function GetGroupInfo()
	local groupType, groupCount

	if UnitInRaid("player") then groupType = "raid"
		groupCount = GetNumGroupMembers()
			-- Unitids for raid groups go from raid1..to..raid40.  No errors.
	elseif UnitInParty("player") then groupType = "party"
		groupCount = GetNumGroupMembers() - 1
			-- WHY?  Because the range for unitids are party1..to..party4.  GetNumGroupMembers() includes the Player, causing errors.
	else return end

	return groupType, groupCount
end

TidyPlatesUtility.GetGroupInfo = GetGroupInfo


local function mergetable(master, mate)
	local merged = {}
	local matedata
	for key, value in pairs(master) do
		if type(value) == "table" then
			matedata = mate[key]
			if type(matedata) == "table" then merged[key] = mergetable(value, matedata)
			else merged[key] = copytable(value) end
		else
			matedata = mate[key]
			if matedata == nil then merged[key] = master[key]
			else merged[key] = matedata end
		end
	end
	return merged
end

local function updatetable(original, added)
	-- Check for exist
	if not (original or added) then return original end
	if not (type(original) == 'table' and type(added) == 'table' ) then return original end
	local originalval

	for index, var in pairs(original) do
		if type(var) == "table" then original[index] = updatetable(var, added[index]) or var
		else
			--original[index] = added[index] or original[index]
			if added[index] ~= nil then
				original[index] = added[index]
			else original[index] = original[index] end

		end
	end
	return original
end

local function valueToString(value)
    if value ~= nil then
        if value >= 1000000 then return format('%.1fm', value / 1000000)
        elseif value >= 1000 then return format('%.1fk', value / 1000)
        else return value end
    end
end

TidyPlatesUtility.abbrevNumber = valueToString
TidyPlatesUtility.copyTable = copytable
TidyPlatesUtility.mergeTable = mergetable
TidyPlatesUtility.updateTable = updatetable

------------------------------------------
-- GameTooltipScanner
------------------------------------------
local ScannerName = "TidyPlatesScanningTooltip"
local TooltipScanner = CreateFrame( "GameTooltip", ScannerName , nil, "GameTooltipTemplate" ); -- Tooltip name cannot be nil
TooltipScanner:SetOwner( WorldFrame, "ANCHOR_NONE" );

------------------------------------------
-- Unit Subtitles/NPC Roles
------------------------------------------
local UnitSubtitles = {}
local function GetUnitSubtitle(unit)
	local unitid = unit.unitid

	-- Bypass caching while in an instance
	--if inInstance or (not UnitExists(unitid)) then return end
	if ( UnitIsPlayer(unitid) or UnitPlayerControlled(unitid) or (not UnitExists(unitid))) then return end

	--local guid = UnitGUID(unitid)
	local name = unit.name
	local subTitle = UnitSubtitles[name]

	if not subTitle then
		TooltipScanner:ClearLines()
 		TooltipScanner:SetUnit(unitid)

 		local TooltipTextLeft1 = _G[ScannerName.."TextLeft1"]
 		local TooltipTextLeft2 = _G[ScannerName.."TextLeft2"]
 		local TooltipTextLeft3 = _G[ScannerName.."TextLeft3"]
 		local TooltipTextLeft4 = _G[ScannerName.."TextLeft4"]

 		name = TooltipTextLeft1:GetText()

		if name then name = gsub( gsub( (name), "|c........", "" ), "|r", "" ) else return end	-- Strip color escape sequences: "|c"
		if name ~= UnitName(unitid) then return end	-- Avoid caching information for the wrong unit


		-- Tooltip Format Priority:  Faction, Description, Level
		local toolTipText = TooltipTextLeft2:GetText() --163ui or "UNKNOWN"
        if not toolTipText then return end

		if string.match(toolTipText, UNIT_LEVEL_TEMPLATE) then
			subTitle = ""
		else
			subTitle = toolTipText
		end

		UnitSubtitles[name] = subTitle
	end

	-- Maintaining a cache allows us to avoid the hit
	if subTitle == "" then return nil
	else return subTitle end

end

TidyPlatesUtility.GetUnitSubtitle = GetUnitSubtitle

------------------------------------------
-- Quest Info
------------------------------------------
local function GetTooltipLineText(lineNumber)
        local tooltipLine = _G[ScannerName .. "TextLeft" .. lineNumber]
        local tooltipText = tooltipLine:GetText()
        local r, g, b = tooltipLine:GetTextColor()

        return tooltipText, r, g, b
end

local function GetUnitQuestInfo(unit)
    local unitid = unit.unitid
    local questName
    local questProgress

    if not unitid then return end

    -- Tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
    TooltipScanner:ClearLines()
    TooltipScanner:SetUnit(unitid)

    for line = 3, TooltipScanner:NumLines() do
        local tooltipText, r, g, b = GetTooltipLineText( line )

        -- If the Quest Name exists, the following tooltip lines list quest progress
        if questName then
            -- Strip out the name of the player that is on the quest.
            local playerName, questNote = string.match(tooltipText, "(%g*) ?%- (.*)")

            if (playerName == "") or (playerName == UnitName("player")) then
                questProgress = questNote
                break
            end

        elseif b == 0 and r > 0.99 and g > 0.82 then
            -- Note: Quest Name Heading is colored Yellow
            questName = tooltipText
        end
    end

    return questName, questProgress
end


TidyPlatesUtility.GetUnitQuestInfo = GetUnitQuestInfo

------------------------
-- Threat Function
------------------------

-- /run print(UnitThreatSituation("party1"), UnitAffectingCombat("party1"))
--local function GetThreatCondition(name)
local function GetFriendlyThreat(unitid)

	if unitid then
		local isUnitInParty = UnitPlayerOrPetInParty(unit)
		local isUnitInRaid = UnitInRaid(unit)
		local isUnitPet = (unit == "pet")

		--if isUnitInParty then
			local unitaggro = UnitThreatSituation(unitid)
			if unitaggro and unitaggro > 1 then return true end
		--end
	end
end

TidyPlatesUtility.GetFriendlyThreat = GetFriendlyThreat

------------------------
-- Threat Function
------------------------

do

	local function GetRelativeThreat(enemyUnitid)		-- 'enemyUnitid' is a target/enemy
		if not UnitExists(enemyUnitid) then return end

		local allyUnitid, allyThreat = nil, 0
		local playerIsTanking, playerSituation, playerThreat = UnitDetailedThreatSituation("player", enemyUnitid)
		if not playerThreat then return end

		-- Get Group Type
		local evalUnitid, evalIndex, evalThreat
		local groupType, size, startAt = nil, nil, 1
		if UnitInRaid("player") then
			groupType = "raid"
			groupSize = TidyPlatesUtility:GetNumRaidMembers()
			startAt = 2
		elseif UnitInParty("player") then
			groupType = "party"
			groupSize = TidyPlatesUtility:GetNumPartyMembers()
		else groupType = nil end

		-- Cycle through Group, picking highest threat holder
		if groupType then
			for allyIndex = startAt, groupSize do
				evalUnitid = groupType..allyIndex
				evalThreat = select(3, UnitDetailedThreatSituation(evalUnitid, enemyUnitid))
				if evalThreat and evalThreat > allyThreat then
					allyThreat = evalThreat
					allyUnitid = evalUnitid
				end
			end
		end

		-- Request Pet Threat (if possible)
		if HasPetUI() and UnitExists("pet") then
			evalThreat = select(3, UnitDetailedThreatSituation("pet", enemyUnitid)) or 0
			if evalThreat > allyThreat then
				allyThreat = evalThreat
				allyUnitid = "pet"
			end
		end

		--[[
		if playerIsTanking and allyThreat then
			return 100 - tonumber(allyThreat or 0), true
		elseif allyThreat and allyUnitid then
			return 100 - playerThreat, false
		end
		--]]
		-- [[
		-- Return the appropriate value
		if playerThreat and allyThreat and allyUnitid then
			if playerThreat >= 100 then 	-- The enemy is attacking you. You are tanking. 	Returns: 1. Your threat, plus your lead over the next highest person, 2. Your Unitid (since you're tanking)
				return tonumber(playerThreat + (100-allyThreat)), "player"
			else 	-- The enemy is not attacking you.  Returns: 1. Your scaled threat percent, 2. Who is On Top
				return tonumber(playerThreat), allyUnitid
			end
		end
		--]]
	end

	TidyPlatesUtility.GetRelativeThreat = GetRelativeThreat
end
------------------------------------------------------------------
-- Panel Helpers (Used to create interface panels)
------------------------------------------------------------------

local function CreatePanelFrame(self, reference, listname, title)
	local panelframe = CreateFrame( "Frame", reference, UIParent);
	panelframe.name = listname
	panelframe.Label = panelframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	panelframe.Label:SetPoint("TOPLEFT", panelframe, "TOPLEFT", 16, -16)
	panelframe.Label:SetHeight(15)
	panelframe.Label:SetWidth(350)
	panelframe.Label:SetJustifyH("LEFT")
	panelframe.Label:SetJustifyV("TOP")
	panelframe.Label:SetText(title or listname)
	return panelframe
end
-- [[
local function CreateDescriptionFrame(self, reference, parent, title, text)
	local descframe = CreateFrame( "Frame", reference, parent);
	descframe:SetHeight(15)
	descframe:SetWidth(200)

	descframe.Label = descframe:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	descframe.Label:SetAllPoints()
	descframe.Label:SetJustifyH("LEFT")
	descframe.Label:SetText(title)

	descframe.Description = descframe:CreateFontString(nil, 'ARTWORK', 'GameFontWhiteSmall')
	descframe.Description:SetPoint("TOPLEFT")
	descframe.Description:SetPoint("BOTTOMRIGHT")
	descframe.Description:SetJustifyH("LEFT")
	descframe.Description:SetJustifyV("TOP")
	descframe.Description:SetText(text)
	--
	return descframe
end
--]]
local function CreateCheckButton(self, reference, parent, label)
	local checkbutton = CreateFrame( "CheckButton", reference, parent, "InterfaceOptionsCheckButtonTemplate" )
	checkbutton.Label = _G[reference.."Text"]
	checkbutton.Label:SetText(label)
	checkbutton.GetValue = function() if checkbutton:GetChecked() then return true else return false end end
	checkbutton.SetValue = checkbutton.SetChecked

	return checkbutton
end

local function CreateRadioButtons(self, reference, parent, numberOfButtons, defaultButton, spacing, list, label)
	local index
	local radioButtonSet = {}

	for index = 1, numberOfButtons do
		radioButtonSet[index] = CreateFrame( "CheckButton", reference..index, parent, "UIRadioButtonTemplate" )
		radioButtonSet[index].Label = _G[reference..index.."Text"]
		radioButtonSet[index].Label:SetText(list[index] or " ")
		radioButtonSet[index].Label:SetWidth(250)
		radioButtonSet[index].Label:SetJustifyH("LEFT")

		if index > 1 then
			radioButtonSet[index]:SetPoint("TOP", radioButtonSet[index-1], "BOTTOM", 0, -(spacing or 10))
		end

		radioButtonSet[index]:SetScript("OnClick", function (self)
			local button
			for button = 1, numberOfButtons do radioButtonSet[button]:SetChecked(false) end
			self:SetChecked(true)
		end)
	end

	radioButtonSet.GetChecked = function()
		local index
		for index = 1, numberOfButtons do
			if radioButtonSet[index]:GetChecked() then return index end
		end
	end

	radioButtonSet.SetChecked = function(self, number)
		local index
		for index = 1, numberOfButtons do radioButtonSet[index]:SetChecked(false) end
		radioButtonSet[number]:SetChecked(true)
	end

	--if label then
	--	dropdown.Label = dropdown:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	--	dropdown.Label:SetPoint("TOPLEFT", 18, 18)
	--	dropdown.Label:SetText(label)
	--end

	radioButtonSet[defaultButton]:SetChecked(true)
	radioButtonSet.GetValue = radioButtonSet.GetChecked
	radioButtonSet.SetValue = radioButtonSet.SetChecked

	return radioButtonSet
end

local function CreateSliderFrame(self, reference, parent, label, val, minval, maxval, step, mode)
	local slider = CreateFrame("Slider", reference, parent, 'OptionsSliderTemplate')
	slider:SetWidth(100)
	slider:SetHeight(15)
	--
	slider:SetMinMaxValues(minval or 0, maxval or 1)
	slider:SetValueStep(step or .1)
	slider:SetValue(val or .5)
	slider:SetOrientation("HORIZONTAL")
	slider:Enable()
	-- Labels
	slider.Label = slider:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	slider.Label:SetPoint("TOPLEFT", -5, 18)
	slider.Low = _G[reference.."Low"]
	slider.High = _G[reference.."High"]
	slider.Label:SetText(label or "")

	-- Value
	slider.Value = slider:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	slider.Value:SetPoint("BOTTOM", 0, -10)
	slider.Value:SetWidth(50)
	--slider.Value
	if mode and mode == "ACTUAL" then
		slider.Value:SetText(tostring(ceil(val)))
		slider:SetScript("OnValueChanged", function()
			local v = tostring(ceil(slider:GetValue()))
			slider.Value:SetText(v)
		end)
		slider.Low:SetText(ceil(minval or 0))
		slider.High:SetText(ceil(maxval or 1))
	else
		slider.Value:SetText(tostring(ceil(100*(val or .5))))
		slider:SetScript("OnValueChanged", function()
			slider.Value:SetText(tostring(ceil(100*slider:GetValue())).."%")
		end)
		slider.Low:SetText(ceil((minval or 0)*100).."%")
		slider.High:SetText(ceil((maxval or 1)*100).."%")
	end

	--slider.tooltipText = "Slider"
	return slider
end

------------------------------------------------
-- Alternative Dropdown Menu
------------------------------------------------

local DropDownMenuFrame = CreateFrame("Frame")
local MaxDropdownItems = 25

DropDownMenuFrame:SetSize(100, 100)
DropDownMenuFrame:SetFrameStrata("TOOLTIP");
DropDownMenuFrame:Hide()

local Border = CreateFrame("Frame", nil, DropDownMenuFrame)
Border:SetBackdrop(
		{	bgFile = "Interface/DialogFrame/UI-DialogBox-Background-Dark",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }});
Border:SetBackdropColor(0,0,0,1);
Border:SetPoint("TOPLEFT", DropDownMenuFrame, "TOPLEFT")

-- Create the Menu Item Buttons
for i = 1, MaxDropdownItems do
	local button = CreateFrame("Button", "TidyPlateDropdownMenuButton"..i, DropDownMenuFrame)
	DropDownMenuFrame["Button"..i] = button

	button:SetHeight(15)
	button:SetPoint("RIGHT", DropDownMenuFrame, "RIGHT")
	button:SetText("Button")

	button.buttonIndex = i

	if i > 1 then
		button:SetPoint("TOPLEFT", DropDownMenuFrame["Button"..i-1], "BOTTOMLEFT")
	else
		-- Initial Corner Point
		button:SetPoint("TOPLEFT", DropDownMenuFrame, "TOPLEFT", 10, -8)
	end

	local region = select(1, button:GetRegions())
	region:SetJustifyH("LEFT")
	region:SetPoint("LEFT", button, "LEFT")
	region:SetPoint("RIGHT", button, "RIGHT")

	--button:SetFrameStrata("DIALOG")
	button:SetHighlightTexture("Interface/QuestFrame/UI-QuestTitleHighlight")
	button:SetNormalFontObject("GameFontHighlightSmallLeft")
	button:SetHighlightFontObject("GameFontNormalSmallLeft")
	button:Show()
end

--[[
local CloseDropdownButton = CreateFrame("Button", nil, DropDownMenuFrame, "UIPanelCloseButton")
CloseDropdownButton:SetPoint("TOPLEFT", DropDownMenuFrame, "TOPRIGHT", -4, 0)
CloseDropdownButton:SetFrameStrata("TOOLTIP");
CloseDropdownButton:Raise()
CloseDropdownButton:Show()
--]]


local function HideDropdownMenu()
	DropDownMenuFrame:Hide()
end

local function ShowDropdownMenu(sourceFrame, menu, clickScript)
	if DropDownMenuFrame:IsShown() and DropDownMenuFrame.SourceFrame == sourceFrame then
		HideDropdownMenu()
		return
	end

	local currentSelection

	DropDownMenuFrame.SourceFrame = sourceFrame
	if sourceFrame.GetValue then currentSelection = sourceFrame:GetValue() end

	local numOfItems = 0
	local maxWidth = 0
	for i = 1, MaxDropdownItems do
		local item = menu[i]

		local button = DropDownMenuFrame["Button"..i]

		if item then
			local itemText = item.text

			local region1, region2 = button:GetRegions()
			--print(region1:GetObjectType(), region2:GetObjectType() )

			if currentSelection == i or itemText == currentSelection then
				region1:SetTextColor(1, .8, 0)
				region1:SetFont(1, .8, 0)
			else
				region1:SetTextColor(1, 1, 1)
			end

			button:SetText(itemText)
			button.Value = item.value

			--button:SetText
			maxWidth = max(maxWidth, button:GetTextWidth())
			numOfItems = numOfItems + 1
			button:SetScript("OnClick", clickScript)


			button:Show()
		else
			button:Hide()
		end

	end

	DropDownMenuFrame:SetWidth(maxWidth + 20)
	Border:SetPoint("BOTTOMRIGHT", DropDownMenuFrame["Button"..numOfItems], "BOTTOMRIGHT", 10, -12)
	DropDownMenuFrame:SetPoint("TOPLEFT", sourceFrame, "BOTTOM")
	DropDownMenuFrame:Show()
	DropDownMenuFrame:Raise()

	-- Make sure the menu stays visible when displayed
	local LowerBound = Border:GetBottom() or 0
	if 0 > LowerBound then DropDownMenuFrame:SetPoint("TOPLEFT", sourceFrame, "BOTTOM", 0, LowerBound * -1) end
end


------------------------------------------------
-- Creates the Dropdown Drawer object
------------------------------------------------


local function CreateDropdownFrame(helpertable, reference, parent, menu, default, label, valueMethod)
	local drawer = CreateFrame("Frame", reference, parent, "TidyPlatesDropdownDrawerTemplate" )

	drawer.Text = _G[reference.."Text"]
	drawer.Button = _G[reference.."Button"]
	drawer:SetWidth(120)

	if label then
		drawer.Label = drawer:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		drawer.Label:SetPoint("TOPLEFT", 18, 18)
		drawer.Label:SetText(label)
	end

	drawer.valueMethod = valueMethod


	drawer.Text:SetWidth(100)
	drawer.Value = default

	-- SetValue is used in the Hub and Panel functions; Very important
	------------------------------------
	drawer.SetValue = function (self, value)
		--if not value then return end

		local itemText

		-- Search for Numerical Index
		if menu[value] then
			itemText = menu[value].text
		else
			-- Search for Token
			for i,v in pairs(menu) do
				if v.value == value then
					itemText = v.text
					break
				end
			end
		end

		if value then
			drawer.Text:SetText(itemText)
			drawer.Value = value
		end
	end

	-- GetValue is used in the Hub and Panel functions; Very important
	------------------------------------
	drawer.GetValue = function (self)
		return self.Value
	end

	-- New Dropdown Method
	------------------------------------------------

	local function OnClickItem(self)

		drawer:SetValue(menu[self.buttonIndex].value or self.buttonIndex)
		--print(self.Value, menu[self.buttonIndex].value, drawer:GetValue())

		if drawer.OnValueChanged then drawer.OnValueChanged(drawer) end
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		HideDropdownMenu()
	end

	local function OnClickDropdown()
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
		ShowDropdownMenu(drawer, menu, OnClickItem)
	end

	local function OnHideDropdown()
		HideDropdownMenu()
	end

	-- Override the default menu display scripts...
	local button = _G[reference.."Button"]
	button:SetScript("OnClick", OnClickDropdown)
	button:SetScript("OnHide", OnHideDropdown)

	-- Set the default value on itself
	drawer:SetValue(default)

	return drawer
end

-- [[ COLOR
local CreateColorBox
do

	local workingFrame
	local function ChangeColor(cancel)
		local a, r, g, b
		if cancel then
			--r,g,b,a = unpack(ColorPickerFrame.startingval )
			workingFrame:SetBackdropColor(unpack(ColorPickerFrame.startingval ))
		else
			a, r, g, b = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
			workingFrame:SetBackdropColor(r,g,b,1-a)
			if workingFrame.OnValueChanged then workingFrame:OnValueChanged() end
		end
	end

	local function ShowColorPicker(frame)
		local r,g,b,a = frame:GetBackdropColor()
		workingFrame = frame
		ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = 	ChangeColor, ChangeColor, ChangeColor;
		ColorPickerFrame.startingval  = {r,g,b,a}
		ColorPickerFrame:SetColorRGB(r,g,b);
		ColorPickerFrame.hasOpacity = true
		ColorPickerFrame.opacity = 1 - a
		ColorPickerFrame:SetFrameStrata(frame:GetFrameStrata())
		ColorPickerFrame:SetFrameLevel(frame:GetFrameLevel()+1)
		ColorPickerFrame:Hide(); ColorPickerFrame:Show(); -- Need to activate the OnShow handler.
	end

	function CreateColorBox(self, reference, parent, label, r, g, b, a)
		local colorbox = CreateFrame("Button", reference, parent)
		colorbox:SetWidth(24)
		colorbox:SetHeight(24)
		colorbox:SetBackdrop({bgFile = "Interface\\ChatFrame\\ChatFrameColorSwatch",
												edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
												tile = false, tileSize = 16, edgeSize = 8,
												insets = { left = 1, right = 1, top = 1, bottom = 1 }});
		colorbox:SetBackdropColor(r, g, b, a);
		colorbox:SetScript("OnClick",function() ShowColorPicker(colorbox) end)
		--
		colorbox.Label = colorbox:CreateFontString(nil, 'ARTWORK', 'GameFontWhiteSmall')
		colorbox.Label:SetPoint("TOPLEFT", colorbox, "TOPRIGHT", 4, -7)
		colorbox.Label:SetText(label)

		colorbox.GetValue = function() local color = {}; color.r, color.g, color.b, color.a = colorbox:GetBackdropColor(); return color end
		colorbox.SetValue = function(self, color) colorbox:SetBackdropColor(color.r, color.g, color.b, color.a); end
		--colorbox.tooltipText = "Colorbox"
		return colorbox
	end
end

PanelHelpers = {}

PanelHelpers.CreatePanelFrame = CreatePanelFrame
PanelHelpers.CreateDescriptionFrame = CreateDescriptionFrame
PanelHelpers.CreateCheckButton = CreateCheckButton
PanelHelpers.CreateRadioButtons = CreateRadioButtons
PanelHelpers.CreateSliderFrame = CreateSliderFrame
PanelHelpers.CreateDropdownFrame = CreateDropdownFrame
PanelHelpers.CreateColorBox = CreateColorBox
PanelHelpers.ShowDropdownMenu = ShowDropdownMenu
PanelHelpers.HideDropdownMenu = HideDropdownMenu

TidyPlatesUtility.PanelHelpers = PanelHelpers



local function StartMovement(frame)
	-- Store Original Point to frame.OriginalAnchor
	frame:StartMoving()
	local OriginalAnchor = frame.OriginalAnchor

	if not OriginalAnchor.point then
		OriginalAnchor.point, OriginalAnchor.relativeTo, OriginalAnchor.relativePoint,
			OriginalAnchor.xOfs, OriginalAnchor.yOfs = frame:GetPoint(1)
		print("Starting Movement from, ", OriginalAnchor.xOfs,  OriginalAnchor.yOfs)
	end


	-- Store Current Screen-RelativePosition to frame.NewAnchor
end

local function FinishMovement(frame)
	-- Store New Screen-RelativePosition to frame.NewAnchor
	local NewAnchor = frame.NewAnchor
	local OriginalAnchor = frame.OriginalAnchor
	NewAnchor.point, NewAnchor.relativeTo, NewAnchor.relativePoint,
		NewAnchor.xOfs, NewAnchor.yOfs = frame:GetPoint(1)
	print(frame:GetName(), " has been moved, " , NewAnchor.xOfs - OriginalAnchor.xOfs, " , ", NewAnchor.yOfs - OriginalAnchor.yOfs)
	frame:StopMovingOrSizing()
	-- Process the
end

local function EnableFreePositioning(frame)
	-- http://www.wowwiki.com/API_Frame_StartMoving
	-- point, relativeTo, relativePoint, xOfs, yOfs = MyRegion:GetPoint(n)
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetScript("OnMouseDown", StartMovement)
	frame:SetScript("OnMouseUp", FinishMovement)
	frame.OriginalAnchor = {}
	frame.NewAnchor = {}
end

PanelHelpers.EnableFreePositioning = EnableFreePositioning




----------------------
-- Call In() - Registers a callback, which hides the specified frame in X seconds
----------------------
do
	local CallList = {}			-- Key = Frame, Value = Expiration Time
	local Watcherframe = CreateFrame("Frame")
	local WatcherframeActive = false
	local select = select
	local timeToUpdate = 0

	local function CheckWatchList(self)
		local curTime = GetTime()
		if curTime < timeToUpdate then return end
		local count = 0
		timeToUpdate = curTime + 1
		-- Cycle through the watchlist
		for func, expiration in pairs(CallList) do
			if expiration < curTime then
				CallList[func] = nil
				func()
			else count = count + 1 end
		end
		-- If no more frames to watch, unregister the OnUpdate script
		if count == 0 then Watcherframe:SetScript("OnUpdate", nil) end
	end

	local function CallIn(func, expiration)
		-- Register Frame
		CallList[ func] = expiration + GetTime()
		-- Init Watchframe
		if not WatcherframeActive then
			Watcherframe:SetScript("OnUpdate", CheckWatchList)
			WatcherframeActive = true
		end
	end

	TidyPlatesUtility.CallIn = CallIn

end



--------------------------------------------------------------------------------------------------
-- InterfaceOptionsFrame_OpenToCategory
-- Quick and dirty fix
--------------------------------------------------------------------------------------------------

do
	local fixed = false

	local function OpenInterfacePanel(panel)
		if not fixed then

			local panelName = panel.name
			if not panelName then return end

			local t = {}

			for i, p in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do
				if p.name == panelName then
					t.element = p
					InterfaceOptionsListButton_ToggleSubCategories(t)
				end
			end
			fixed = true
		end

		InterfaceOptionsFrame_OpenToCategory(panel)
	end

	TidyPlatesUtility.OpenInterfacePanel = OpenInterfacePanel
end

-- /run for i,v in pairs(INTERFACEOPTIONS_ADDONCATEGORIES) do print(i, v, v.name) end







