------------------------------------------------------------
-- ToolBar.lua
--
-- Abin
-- 2011-8-23
------------------------------------------------------------

local ipairs = ipairs
local tonumber = tonumber
local GetScreenHeight = GetScreenHeight
local ToggleDropDownMenu = ToggleDropDownMenu
local strtrim = strtrim
local StaticPopup_Show = StaticPopup_Show
local format = format
local UIDropDownMenu_AddButton = UIDropDownMenu_AddButton
local InCombatLockdown = InCombatLockdown
local MAX_EQUIPMENT_SETS_PER_PLAYER = MAX_EQUIPMENT_SETS_PER_PLAYER
local ERR_NOT_IN_COMBAT = ERR_NOT_IN_COMBAT

local GameTooltip = GameTooltip

local _, addon = ...
local L = addon.L
local BUTTON_WIDTH = 20
local setButtons = {}
local allButtons = {}
local db = {}

-- Parent frame of all bar buttons
local frame = CreateFrame("Frame", "GearManagerExToolBarFrame", UIParent, "SecureFrameTemplate")
addon.toolbar = frame
frame:SetMovable(true)
frame:SetUserPlaced(true)
frame:SetFrameStrata("MEDIUM")
frame:SetToplevel(true)
frame:SetClampedToScreen(true)
frame:SetSize(BUTTON_WIDTH, BUTTON_WIDTH)

local function resetToolbarPos()
    local X, Y = 98, 0
    frame:ClearAllPoints();
    if PlayerFrame:IsVisible() then
        frame:SetPoint("TOPLEFT", "PlayerFrame", "TOPLEFT", X, Y);
    else
        frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", X-19, Y-4);
    end
end
resetToolbarPos()

local function AlignButtons()
    local i
    for i = 1, #allButtons do
        local button = allButtons[i]
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("TOPLEFT")
        elseif (i - 1) % (db.columns + 1) == 0 then
            button:SetPoint("TOP", allButtons[i - db.columns], "BOTTOM", 0, -db.spacing)
        else
            button:SetPoint("LEFT", allButtons[i - 1], "RIGHT", db.spacing, 0)
        end
    end
end

local function UpdateNumeric()
    local button
    for _, button in ipairs(setButtons) do
        button:SetNumeric(db.numeric)
    end
end

local function UpdateTooltip()
    local button
    for _, button in ipairs(setButtons) do
        if button:IsShown() then
            if GameTooltip:IsOwned(button) then
                GameTooltip:ClearLines()
                button:OnEnter()
                GameTooltip:Show()
            end
        else
            break
        end
    end
end

local function CreateToolButton(id)
    local button = CreateFrame("Button", frame:GetName().."Button"..id, frame, "SecureActionButtonTemplate")
    button:SetID(id)
    button:SetSize(BUTTON_WIDTH, BUTTON_WIDTH)
    button:SetBackdrop({ edgeFile = "Interface\\LFGFRAME\\LFGBorder", edgeSize = 8, bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", insets = { top = 2, left = 2, bottom = 2, right = 2 } })

    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    local icon = button:CreateTexture(button:GetName().."Icon", "ARTWORK")
    button.icon = icon
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

    button:RegisterForDrag("LeftButton")

    button:SetScript("OnDragStart", function(self)
        if not db.lock then
            frame:StartMoving()
        end
    end)

    button:SetScript("OnDragStop", function(self)
        frame:StopMovingOrSizing()
    end)

    button:SetScript("OnEnter", function(self)
        if db.hidetip then
            return
        end

        local left = self:GetLeft()
        local top = self:GetTop()
        if not left or not top then
            return
        end

        local anchor
        local leftOK = left > 250
        local topOK = (GetScreenHeight() - top) > 250

        if leftOK then
            if topOK then
                anchor = "ANCHOR_LEFT"
            else
                anchor = "ANCHOR_BOTTOMLEFT"
            end
        else
            if topOK then
                anchor = "ANCHOR_RIGHT"
            else
                anchor = "ANCHOR_BOTTOMRIGHT"
            end
        end

        GameTooltip:SetOwner(self, anchor)
        GameTooltip:ClearLines()
        self:OnEnter()
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    if id == 0 then
        icon:SetPoint("TOPLEFT", 1, -1)
        icon:SetPoint("BOTTOMRIGHT", -1, 1)
        button:SetPoint("LEFT")

        icon:SetTexture(PAPERDOLL_SIDEBARS[3].icon)
        local tcoords = PAPERDOLL_SIDEBARS[3].texCoords
        icon:SetTexCoord(tcoords[1], tcoords[2], tcoords[3], tcoords[4])

        button.OnEnter = function(self)
            GameTooltip:AddLine(L["toolbar title"], 1, 1, 1)
            GameTooltip:AddLine(KEY_BUTTON1..": "..L["quick strip"])
            GameTooltip:AddLine(KEY_BUTTON2..": "..OPTIONS_MENU)
            GameTooltip:AddLine("ALT+"..KEY_BUTTON1..": "..L["create new"])
        end

        button:SetScript("OnClick", function(self, arg1)
            if arg1 == "LeftButton" then
                if (IsAltKeyDown() or IsControlKeyDown()) and not IsShiftKeyDown() then
                    GearManagerEx_Toggle()
                else
                    addon:QuickStrip()
                end
            else
                ToggleDropDownMenu(nil, nil, frame.menu)
            end
            GameTooltip:Hide()
        end)
    else
        local checked = button:CreateTexture(button:GetName().."Checked", "OVERLAY")
        button.checked = checked
        checked:SetTexture("Interface\\Buttons\\CheckButtonHilight")
        checked:SetBlendMode("ADD")
        checked:SetAlpha(0.5)
        checked:SetAllPoints(button)
        checked:Hide()
        button:SetNormalFontObject("GameFontNormalSmall")
        button:SetHighlightFontObject("GameFontHighlightSmall")
        icon:SetPoint("TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", -2, 2)
        icon:SetTexCoord(0.04, 0.96, 0.04, 0.96)
        button:Hide()
		button:SetAttribute("type1", "macro")
		button:SetAttribute("type2", "")

        button.OnEnter = function(self)
            if self.name then
                GameTooltip:SetEquipmentSet(self.name)
                GameTooltip:AddLine(L["tooltip prompt"], 0, 1, 0, 1)
                GameTooltip:AddLine(L["tooltip replace"], 0, 1, 0, 1)
            end
        end

		button:SetScript("PostClick", function(self, arg1)
			if arg1 == "RightButton" then
                addon:SetMenuSet(self.setID)
                addon:ToggleMenu(UIParent, "TOPLEFT", self, "BOTTOMLEFT", 0, 0)
            elseif arg1 == "LeftButton" and (IsAltKeyDown() or IsControlKeyDown()) then
				addon:ResaveSet(self.setID)
			end
            GameTooltip:Hide()
        end)

        button.SetChecked = function(self, checked)
            if checked then
                self.checked:Show()
            else
                self.checked:Hide()
            end
        end

        button.SetNumeric = function(self, numeric)
            if numeric then
                self.icon:Hide()
                self:SetText(self:GetID())
            else
                self.icon:Show()
                self:SetText()
            end
        end
    end

    return button
end

-- Updates highlight stats for buttons
local function UpdateButtonsChecked(name)
    local button, found
    for _, button in ipairs(setButtons) do
        if not found and name and button.name == name then
            found = 1
            button:SetChecked(true)
            button:LockHighlight()
        else
            button:SetChecked(false)
            button:UnlockHighlight()
        end
    end
    UpdateTooltip()
end

-- Show or hide buttons
local function UpdateButtonsStatus()
	if InCombatLockdown() then
		return
	end

    local setIDs = C_EquipmentSet.GetEquipmentSetIDs()
    local count = #setIDs
    local id, button
    for i, button in ipairs(setButtons) do
        if i > count then
            button:Hide()
        else
	        id = setIDs[i]
            local name, icon, setID, isEquipped = C_EquipmentSet.GetEquipmentSetInfo(id)
            button.name = name
            button.setID = id
            button:SetAttribute("macrotext", name and "/equipset "..name)
            button.icon:SetTexture(icon)
            button:Show()
        end
    end
    UpdateButtonsChecked(addon:GetActiveSet())
    UpdateTooltip()
end

local mainButton = CreateToolButton(0)
mainButton:SetPoint("TOPLEFT")
tinsert(allButtons, mainButton)

-- Create set buttons
do
    local prev = mainButton
    local i
    for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
        local button = CreateToolButton(i)
        button.prevButton = prev
        prev = button
        tinsert(setButtons, button)
        tinsert(allButtons, button)
    end
end

addon:RegisterCallback(UpdateButtonsChecked)

--------------------------------------------------
-- A check button on char page
--------------------------------------------------

local checkFrame = CreateFrame("Frame", "GearManagerExToolBarCheckFrame", PaperDollEquipmentManagerPane)
checkFrame:SetBackdrop({ bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16, edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16, insets = {left = 5, right = 5, top = 5, bottom = 5 } })
checkFrame:SetPoint("TOPLEFT", PaperDollEquipmentManagerPane, "BOTTOMLEFT", -4, -7)
checkFrame:SetSize(200, 40)
checkFrame:EnableMouse(true)

local checkButton = CreateFrame("Button", checkFrame:GetName().."Button", checkFrame, "UIPanelButtonTemplate")
checkButton:SetPoint("CENTER")
checkButton:SetSize(150, 24)

local function UpdateCheckText()
    checkButton:SetText(db.hide and L["show toolbar"] or L["reset toolbar"])
end

checkButton:SetScript("OnClick", function(self)
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end

	if db.hide then
		db.hide = nil
		frame:Show()
	else
		-- reset
        resetToolbarPos()
        db.scale = 100
        db.spacing = 0
        db.numeric = 1
        db.columns = MAX_EQUIPMENT_SETS_PER_PLAYER
        frame:SetScale(1)
        AlignButtons()
        UpdateNumeric()
    end
    UpdateCheckText()
end)

function frame:OnInitialize(moduleDB)
    db = moduleDB
    if type(db.scale) ~= "number" or db.scale < 25 or db.scale > 300 then
        db.scale = 100
    end

    CoreUISetScale(self, db.scale / 100)

    if type(db.spacing) ~= "number" or db.spacing < 0 or db.spacing > 10 then
        db.spacing = 0
    end

    if type(db.columns) ~= "number" or db.columns < 1 or db.columns > MAX_EQUIPMENT_SETS_PER_PLAYER then
        db.columns = MAX_EQUIPMENT_SETS_PER_PLAYER
    end

    AlignButtons()
    UpdateNumeric()

    if db.hide then
        self:Hide()
    end

    UpdateCheckText()

    PlayerFrameGroupIndicator:HookScript("OnShow", function()
        PlayerFrameGroupIndicatorLeft:SetAlpha(0);
        PlayerFrameGroupIndicatorRight:SetAlpha(0);
        PlayerFrameGroupIndicatorMiddle:SetAlpha(0);
        PlayerFrameGroupIndicator:ClearAllPoints();
        PlayerFrameGroupIndicator:SetPoint("BOTTOMLEFT", "PlayerFrame", "TOPLEFT", 33, -9);
    end)
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("EQUIPMENT_SETS_CHANGED")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

frame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "EQUIPMENT_SETS_CHANGED" then
        UpdateButtonsStatus()
    elseif event == "PLAYER_EQUIPMENT_CHANGED" then
        UpdateTooltip()
    end
end)

--------------------------------------------------
-- Option Menu
--------------------------------------------------

local menu = CreateFrame("Button", frame:GetName().."Menu", UIParent, "UIDropDownMenuTemplate")
frame.menu = menu
menu.point = "TOPLEFT"
menu.relativeTo = mainButton
menu.relativePoint = "BOTTOMLEFT"
menu.xOffset = 0
menu.yOffset = 0

local onConfirm, curValue

local function ProcessInput(text)
    if onConfirm then
        local value = tonumber(strtrim(text) or "")
        if value then
            return onConfirm(value)
        else
            return 1
        end
    end
end

local popupData = {
    preferredIndex = 3,
    button1 = OKAY,
    button2 = CANCEL,
    hasEditBox = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
    hideOnEscape = 1,

    OnAccept = function(self)
        if ProcessInput(self.editBox:GetText()) then
            self.editBox:SetFocus()
            self.editBox:HighlightText()
            return 1
        end
    end,

    EditBoxOnEnterPressed = function(self)
        if ProcessInput(self:GetText()) then
            self:SetFocus()
            self:HighlightText()
        else
            self:GetParent():Hide()
        end
    end,

    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,

    OnShow = function(self)
        self.editBox:SetText(curValue or "")
        self.editBox:SetFocus()
        self.editBox:HighlightText()
    end,
}

StaticPopupDialogs["GEARMANAGEREX_TOOLBAR_DATA"] = popupData

local function OnMenuLock()
    if db.lock then
        db.lock = nil
    else
        db.lock = 1
    end
end

local function OnMenuHide()
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end

    if db.hide then
        db.hide = nil
        frame:Show()
    else
        db.hide = 1
        frame:Hide()
    end
    UpdateCheckText()
end

local function OnMenuHideTip()
    if db.hidetip then
        db.hidetip = nil
    else
        db.hidetip = 1
    end
end

local function OnMenuNumeric()
    if db.numeric then
        db.numeric = nil
    else
        db.numeric = 1
    end
    UpdateNumeric()
end

local function OnConfirmColumns(value)
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end

    if value < 1 then
        value = 1
    elseif value > MAX_EQUIPMENT_SETS_PER_PLAYER then
        value = MAX_EQUIPMENT_SETS_PER_PLAYER
    end
    db.columns = value
    AlignButtons()
end

local function OnConfirmScale(value)
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end

    if value < 25 then
        value = 25
    elseif value > 300 then
        value = 300
    end
    db.scale = value
    frame:SetScale(value / 100)
end

local function OnConfirmSpacing(value)
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end

    if value < 0 then
        value = 0
    elseif value > 10 then
        value = 10
    end
    db.spacing = value
    AlignButtons()
end

local function OnMenuColumns()
    onConfirm = OnConfirmColumns
    curValue = db.columns or MAX_EQUIPMENT_SETS_PER_PLAYER
    popupData.text = format(L["please type value"], L["button columns"], 1, MAX_EQUIPMENT_SETS_PER_PLAYER)
    StaticPopup_Show("GEARMANAGEREX_TOOLBAR_DATA")
end

local function OnMenuScale()
    onConfirm = OnConfirmScale
    curValue = db.scale or 100
    popupData.text = format(L["please type value"], L["scale"], 25, 300)
    StaticPopup_Show("GEARMANAGEREX_TOOLBAR_DATA")
end

local function OnMenuSpacing()
    onConfirm = OnConfirmSpacing
    curValue = db.spacing or 3
    popupData.text = format(L["please type value"], L["spacing"], 0, 10)
    StaticPopup_Show("GEARMANAGEREX_TOOLBAR_DATA")
end

UIDropDownMenu_Initialize(menu, function()
	UIDropDownMenu_AddButton({ text = L["toolbar title"], isTitle = 1, notCheckable = 1 })
	UIDropDownMenu_AddButton({ text = L["lock"], isNotRadio = true, checked = db.lock, func = OnMenuLock, disabled = InCombatLockdown() })
	UIDropDownMenu_AddButton({ text = L["hide toolbar"], isNotRadio = true, checked = db.hide, func = OnMenuHide, disabled = InCombatLockdown() })
    UIDropDownMenu_AddButton({ text = L["hide tooltip"], isNotRadio = true, checked = db.hidetip, func = OnMenuHideTip })
    UIDropDownMenu_AddButton({ text = L["numeric"], isNotRadio = true, checked = db.numeric, func = OnMenuNumeric })
	UIDropDownMenu_AddButton({ text = L["button columns"], notCheckable = 1, func = OnMenuColumns, disabled = InCombatLockdown() })
	UIDropDownMenu_AddButton({ text = L["scale"], notCheckable = 1, func = OnMenuScale, disabled = InCombatLockdown() })
	UIDropDownMenu_AddButton({ text = L["spacing"], notCheckable = 1, func = OnMenuSpacing, disabled = InCombatLockdown() })
    UIDropDownMenu_AddButton({ text = L["reset toolbar"], notCheckable = 1, func = checkButton:GetScript("OnClick"), disabled = InCombatLockdown() })
    UIDropDownMenu_AddButton({ text = CLOSE, notCheckable = 1 })
end, "MENU")

GearManagerEx_OnMenuHide = function(v)
    db.hide = v and 1 or nil
	if InCombatLockdown() then
		addon:Print(ERR_NOT_IN_COMBAT, 1, 0, 0);
		return
	end	
    if db.hide then
        frame:Hide()
    else
        frame:Show()
    end
    UpdateCheckText()
end
