--- MSA-DropDownMenu-1.0 - DropDown menu for non-Blizzard addons
--- Copyright (c) 2016-2018, Marouan Sabbagh <mar.sabbagh@gmail.com>
--- All Rights Reserved.
---
--- https://www.curseforge.com/wow/addons/msa-dropdownmenu-10

local name, version = "MSA-DropDownMenu-1.0", 5

local lib, oldVersion = LibStub:NewLibrary(name, version)
if not lib then return end

-- WoW API
local _G = _G

MSA_DROPDOWNMENU_MINBUTTONS = 8;
MSA_DROPDOWNMENU_MAXBUTTONS = 8;
MSA_DROPDOWNMENU_MAXLEVELS = 2;
MSA_DROPDOWNMENU_BUTTON_HEIGHT = 16;
MSA_DROPDOWNMENU_BORDER_HEIGHT = 15;
-- The current open menu
MSA_DROPDOWNMENU_OPEN_MENU = nil;
-- The current menu being initialized
MSA_DROPDOWNMENU_INIT_MENU = nil;
-- Current level shown of the open menu
MSA_DROPDOWNMENU_MENU_LEVEL = 1;
-- Current value of the open menu
MSA_DROPDOWNMENU_MENU_VALUE = nil;
-- Time to wait to hide the menu
MSA_DROPDOWNMENU_SHOW_TIME = 2;
-- Default dropdown text height
MSA_DROPDOWNMENU_DEFAULT_TEXT_HEIGHT = nil;
-- List of open menus
MSA_OPEN_DROPDOWNMENUS = {};

local MSA_DropDownMenuDelegate = CreateFrame("FRAME");

------------------------------------------------------------------------------------------------------------------------
-- Frames
------------------------------------------------------------------------------------------------------------------------

local function CreateDropDownMenuButton(name, parent)
    local DropDownMenuButton = CreateFrame("Button", name, parent or nil)
    DropDownMenuButton:SetWidth(100)
    DropDownMenuButton:SetHeight(16)
    DropDownMenuButton:SetFrameLevel(DropDownMenuButton:GetParent():GetFrameLevel()+2)

    local texture1 = DropDownMenuButton:CreateTexture(name.."Highlight", "BACKGROUND")
    texture1:SetAllPoints()
    texture1:Hide()
    texture1:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    texture1:SetBlendMode("ADD")

    local texture2 = DropDownMenuButton:CreateTexture(name.."Check", "ARTWORK")
    texture2:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
    texture2:SetWidth(16)
    texture2:SetHeight(16)
    texture2:SetPoint("LEFT", DropDownMenuButton, 0, 0)
    texture2:SetTexCoord(0, 0.5, 0.5, 1)

    local texture3 = DropDownMenuButton:CreateTexture(name.."UnCheck", "ARTWORK")
    texture3:SetTexture("Interface\\Common\\UI-DropDownRadioChecks")
    texture3:SetWidth(16)
    texture3:SetHeight(16)
    texture3:SetPoint("LEFT", DropDownMenuButton, 0, 0)
    texture3:SetTexCoord(0.5, 1, 0.5, 1)

    local texture4 = DropDownMenuButton:CreateTexture(name.."Icon", "ARTWORK")
    texture4:Hide()
    texture4:SetWidth(16)
    texture4:SetHeight(16)
    texture4:SetPoint("RIGHT", DropDownMenuButton, 0, 0)

    local button1 = CreateFrame("Button", name.."ColorSwatch", DropDownMenuButton)
    button1:Hide()
    button1:SetWidth(16)
    button1:SetHeight(16)
    button1:SetPoint("RIGHT", DropDownMenuButton, -6, 0)

    local button1Texture1 = button1:CreateTexture(name.."ColorSwatchSwatchBg", "BACKGROUND")
    button1Texture1:SetVertexColor(1, 1, 1)
    button1Texture1:SetWidth(14)
    button1Texture1:SetHeight(14)
    button1Texture1:SetPoint("CENTER", button1, 0, 0)

    button1:SetScript("OnClick", function(self, button, down)
        CloseMenus();
        MSA_DropDownMenuButton_OpenColorPicker(self:GetParent());
    end)
    button1:SetScript("OnEnter", function(self, motion)
        MSA_CloseDropDownMenus(self:GetParent():GetParent():GetID() + 1);
        _G[self:GetName().."SwatchBg"]:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
        MSA_DropDownMenu_StopCounting(self:GetParent():GetParent());
    end)
    button1:SetScript("OnLeave", function(self, motion)
        _G[self:GetName().."SwatchBg"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
        MSA_DropDownMenu_StartCounting(self:GetParent():GetParent());
    end)

    local button1NormalTexture = button1:CreateTexture(name.."ColorSwatchNormalTexture")
    button1NormalTexture:SetTexture("Interface\\ChatFrame\\ChatFrameColorSwatch")
    button1NormalTexture:SetAllPoints()
    button1:SetNormalTexture(button1NormalTexture)

    local button2 = CreateFrame("Button", name.."ExpandArrow", DropDownMenuButton)
    button2:Hide()
    button2:SetWidth(16)
    button2:SetHeight(16)
    button2:SetPoint("RIGHT", DropDownMenuButton, 0, 0)
    button2:SetScript("OnClick", function(self, button, down)
        MSA_ToggleDropDownMenu(self:GetParent():GetParent():GetID() + 1, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self);
    end)
    button2:SetScript("OnEnter", function(self, motion)
        local level =  self:GetParent():GetParent():GetID() + 1;
        local listFrame = _G["MSA_DropDownList"..level];
        if ( not listFrame or not listFrame:IsShown() or select(2, listFrame:GetPoint()) ~= self ) then
            MSA_ToggleDropDownMenu(level, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self);
        end
        MSA_DropDownMenu_StopCounting(self:GetParent():GetParent());
    end)
    button2:SetScript("OnLeave", function(self, motion)
        MSA_DropDownMenu_StartCounting(self:GetParent():GetParent());
    end)

    local button2NormalTexture = button2:CreateTexture()
    button2NormalTexture:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
    button2NormalTexture:SetAllPoints()
    button2:SetNormalTexture(button2NormalTexture)

    local button3 = CreateFrame("Button", name.."InvisibleButton", DropDownMenuButton)
    DropDownMenuButton["invisibleButton"] = button3
    button3:Hide()
    button3:SetPoint("TOPLEFT", DropDownMenuButton, 0, 0)
    button3:SetPoint("BOTTOMLEFT", DropDownMenuButton, 0, 0)
    button3:SetPoint("RIGHT", button1, "LEFT", 0, 0)
    button3:SetScript("OnEnter", function(self, motion)
        MSA_DropDownMenu_StopCounting(self:GetParent():GetParent());
        MSA_CloseDropDownMenus(self:GetParent():GetParent():GetID() + 1);
        local parent = self:GetParent();
        if ( parent.tooltipTitle and parent.tooltipWhileDisabled) then
            if ( parent.tooltipOnButton ) then
                GameTooltip:SetOwner(parent, "ANCHOR_RIGHT");
                GameTooltip:AddLine(parent.tooltipTitle, 1.0, 1.0, 1.0);
                GameTooltip:AddLine(parent.tooltipText, nil, nil, nil, true);
                GameTooltip:Show();
            else
                GameTooltip_AddNewbieTip(parent, parent.tooltipTitle, 1.0, 1.0, 1.0, parent.tooltipText, 1);
            end
        end
    end)
    button3:SetScript("OnLeave", function(self, motion)
        MSA_DropDownMenu_StartCounting(self:GetParent():GetParent());
        GameTooltip:Hide();
    end)

    DropDownMenuButton:SetScript("OnClick", function(self, button, down)
        MSA_DropDownMenuButton_OnClick(self, button, down);
    end)
    DropDownMenuButton:SetScript("OnEnter", function(self, motion)
        if ( self.hasArrow ) then
            local level =  self:GetParent():GetID() + 1;
            local listFrame = _G["MSA_DropDownList"..level];
            if ( not listFrame or not listFrame:IsShown() or select(2, listFrame:GetPoint()) ~= self ) then
                MSA_ToggleDropDownMenu(self:GetParent():GetID() + 1, self.value, nil, nil, nil, nil, self.menuList, self);
            end
        else
            MSA_CloseDropDownMenus(self:GetParent():GetID() + 1);
        end
        _G[self:GetName().."Highlight"]:Show();
        MSA_DropDownMenu_StopCounting(self:GetParent());
        if ( self.tooltipTitle ) then
            if ( self.tooltipOnButton ) then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                GameTooltip:AddLine(self.tooltipTitle, 1.0, 1.0, 1.0);
                GameTooltip:AddLine(self.tooltipText, nil, nil, nil, true);
                GameTooltip:Show();
            else
                GameTooltip_AddNewbieTip(self, self.tooltipTitle, 1.0, 1.0, 1.0, self.tooltipText, 1);
            end
        end
    end)
    DropDownMenuButton:SetScript("OnLeave", function(self, motion)
        _G[self:GetName().."Highlight"]:Hide();
        MSA_DropDownMenu_StartCounting(self:GetParent());
        GameTooltip:Hide();
    end)
    DropDownMenuButton:SetScript("OnEnable", function(self)
        self.invisibleButton:Hide();
    end)
    DropDownMenuButton:SetScript("OnDisable", function(self)
        self.invisibleButton:Show();
    end)

    local text1 = DropDownMenuButton:CreateFontString(name.."NormalText")
    DropDownMenuButton:SetFontString(text1)
    text1:SetPoint("LEFT", DropDownMenuButton, -5, 0)
    DropDownMenuButton:SetNormalFontObject("GameFontHighlightSmallLeft")
    DropDownMenuButton:SetHighlightFontObject("GameFontHighlightSmallLeft")
    DropDownMenuButton:SetDisabledFontObject("GameFontDisableSmallLeft")

    return DropDownMenuButton
end

local function CreateDropDownList(name, parent)
    local DropDownList = CreateFrame("Button", name, parent or nil)
    DropDownList:Hide()
    DropDownList:SetFrameStrata("DIALOG")
    DropDownList:EnableMouse(true)

    local frame1 = CreateFrame("Frame", name.."Backdrop", DropDownList)
    frame1:SetAllPoints()
    frame1:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {
            left = 11,
            right = 12,
            top = 12,
            bottom = 9,
        },
    })

    local frame2 = CreateFrame("Frame", name.."MenuBackdrop", DropDownList)
    frame2:SetAllPoints()
    frame2:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 5,
            right = 5,
            top = 5,
            bottom = 4,
        },
    })
    frame2:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
    frame2:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)

    for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
        local button = CreateDropDownMenuButton(name.."Button"..i, DropDownList)
        button:SetID(i)
    end

    DropDownList:SetScript("OnClick", function(self, button, down)
        self:Hide();
    end)
    DropDownList:SetScript("OnEnter", function(self, motion)
        MSA_DropDownMenu_StopCounting(self, motion);
    end)
    DropDownList:SetScript("OnLeave", function(self, motion)
        MSA_DropDownMenu_StartCounting(self, motion);
    end)
    DropDownList:SetScript("OnUpdate", function(self, elapsed)
        MSA_DropDownMenu_OnUpdate(self, elapsed);
    end)
    DropDownList:SetScript("OnShow", function(self)
        for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
            if (not self.noResize) then
                _G[self:GetName().."Button"..i]:SetWidth(self.maxWidth);
            end
        end
        if (not self.noResize) then
            self:SetWidth(self.maxWidth+25);
        end
        self.showTimer = nil;
        if ( self:GetID() > 1 ) then
            self.parent = _G["MSA_DropDownList"..(self:GetID() - 1)];
        end
    end)
    DropDownList:SetScript("OnHide", function(self)
        MSA_DropDownMenu_OnHide(self);
    end)

    return DropDownList
end

local function CreateDropDownMenu(name, parent)
    local DropDownMenu
    if type(name) == "table" then
        DropDownMenu = name
        name = DropDownMenu:GetName()
    else
        DropDownMenu = CreateFrame("Frame", name, parent or nil)
    end
    DropDownMenu:SetWidth(40)
    DropDownMenu:SetHeight(32)

    local texture1 = DropDownMenu:CreateTexture(name.."Left", "ARTWORK")
    texture1:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    texture1:SetWidth(25)
    texture1:SetHeight(64)
    texture1:SetPoint("TOPLEFT", DropDownMenu, 0, 17)
    texture1:SetTexCoord(0, 0.1953125, 0, 1)

    local texture2 = DropDownMenu:CreateTexture(name.."Middle", "ARTWORK")
    texture2:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    texture2:SetWidth(115)
    texture2:SetHeight(64)
    texture2:SetPoint("LEFT", texture1, "RIGHT", 0, 0)
    texture2:SetTexCoord(0.1953125, 0.8046875, 0, 1)

    local texture3 = DropDownMenu:CreateTexture(name.."Right", "ARTWORK")
    texture3:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame")
    texture3:SetWidth(25)
    texture3:SetHeight(64)
    texture3:SetPoint("LEFT", texture2, "RIGHT", 0, 0)
    texture3:SetTexCoord(0.8046875, 1, 0, 1)

    local text1 = DropDownMenu:CreateFontString(name.."Text", "ARTWORK", "GameFontHighlightSmall")
    DropDownMenu["Text"] = text1
    text1:SetWordWrap(false)
    text1:SetJustifyH("RIGHT")
    text1:SetWidth(0)
    text1:SetHeight(10)
    text1:SetPoint("RIGHT", texture3, -43, 2)

    local texture4 = DropDownMenu:CreateTexture(name.."Icon", "OVERLAY")
    DropDownMenu["Icon"] = texture4
    texture4:Hide()
    texture4:SetWidth(16)
    texture4:SetHeight(16)
    texture4:SetPoint("LEFT", DropDownMenu, 30, 2)

    local button1 = CreateFrame("Button", name.."Button", DropDownMenu)
    DropDownMenu["Button"] = button1
    button1:SetMotionScriptsWhileDisabled(true)
    button1:SetWidth(24)
    button1:SetHeight(24)
    button1:SetPoint("TOPRIGHT", texture3, -16, -18)
    button1:SetScript("OnEnter", function(self, motion)
        local parent = self:GetParent();
        local myscript = parent:GetScript("OnEnter");
        if(myscript ~= nil) then
            myscript(parent);
        end
    end)
    button1:SetScript("OnLeave", function(self, motion)
        local parent = self:GetParent();
        local myscript = parent:GetScript("OnLeave");
        if(myscript ~= nil) then
            myscript(parent);
        end
    end)
    button1:SetScript("OnClick", function(self, button, down)
        MSA_ToggleDropDownMenu(nil, nil, self:GetParent());
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
    end)

    local button1NormalTexture = button1:CreateTexture(name.."ButtonNormalTexture")
    button1NormalTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    button1NormalTexture:SetWidth(24)
    button1NormalTexture:SetHeight(24)
    button1NormalTexture:SetPoint("RIGHT", button1, 0, 0)
    button1:SetNormalTexture(button1NormalTexture)

    local button1PushedTexture = button1:CreateTexture(name.."ButtonPushedTexture")
    button1PushedTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    button1PushedTexture:SetWidth(24)
    button1PushedTexture:SetHeight(24)
    button1PushedTexture:SetPoint("RIGHT", button1, 0, 0)
    button1:SetPushedTexture(button1PushedTexture)

    local button1DisabledTexture = button1:CreateTexture(name.."ButtonDisabledTexture")
    button1DisabledTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled")
    button1DisabledTexture:SetWidth(24)
    button1DisabledTexture:SetHeight(24)
    button1DisabledTexture:SetPoint("RIGHT", button1, 0, 0)
    button1:SetDisabledTexture(button1DisabledTexture)

    local button1HighlightTexture = button1:CreateTexture(name.."ButtonHighlightTexture")
    button1HighlightTexture:SetTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    button1HighlightTexture:SetBlendMode("ADD")
    button1HighlightTexture:SetWidth(24)
    button1HighlightTexture:SetHeight(24)
    button1HighlightTexture:SetPoint("RIGHT", button1, 0, 0)
    button1:SetHighlightTexture(button1HighlightTexture)

    DropDownMenu:SetScript("OnHide", function(self)
        MSA_CloseDropDownMenus();
    end)

    return DropDownMenu
end

local DropDownList1 = CreateDropDownList("MSA_DropDownList1", UIParent)
DropDownList1:Hide()
DropDownList1:SetToplevel(true)
DropDownList1:SetFrameStrata("FULLSCREEN_DIALOG")
DropDownList1:SetID(1)
DropDownList1:SetWidth(180)
DropDownList1:SetHeight(10)
local _, fontHeight, _ = _G["MSA_DropDownList1Button1NormalText"]:GetFont()
MSA_DROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontHeight

local DropDownList2 = CreateDropDownList("MSA_DropDownList2", UIParent)
DropDownList2:Hide()
DropDownList2:SetToplevel(true)
DropDownList2:SetFrameStrata("FULLSCREEN_DIALOG")
DropDownList2:SetID(2)
DropDownList2:SetWidth(180)
DropDownList2:SetHeight(10)

------------------------------------------------------------------------------------------------------------------------
-- Public
------------------------------------------------------------------------------------------------------------------------

function MSA_DropDownMenu_Create(name, parent)
    return CreateDropDownMenu(name, parent)
end

-- 7.3.0.24920

function MSA_DropDownMenuDelegate_OnAttributeChanged(self, attribute, value)
    if ( attribute == "createframes" and value == true ) then
        MSA_DropDownMenu_CreateFrames(self:GetAttribute("createframes-level"), self:GetAttribute("createframes-index"));
    elseif ( attribute == "initmenu" ) then
        MSA_DROPDOWNMENU_INIT_MENU = value;
    elseif ( attribute == "openmenu" ) then
        MSA_DROPDOWNMENU_OPEN_MENU = value;
    end
end

MSA_DropDownMenuDelegate:SetScript("OnAttributeChanged", MSA_DropDownMenuDelegate_OnAttributeChanged);

function MSA_DropDownMenu_InitializeHelper(frame)
    -- This deals with the potentially tainted stuff!
    if ( frame ~= MSA_DROPDOWNMENU_OPEN_MENU ) then
        MSA_DROPDOWNMENU_MENU_LEVEL = 1;
    end

    -- Set the frame that's being intialized
    MSA_DropDownMenuDelegate:SetAttribute("initmenu", frame);

    -- Hide all the buttons
    local button, dropDownList;
    for i = 1, MSA_DROPDOWNMENU_MAXLEVELS, 1 do
        dropDownList = _G["MSA_DropDownList"..i];
        if ( i >= MSA_DROPDOWNMENU_MENU_LEVEL or frame ~= MSA_DROPDOWNMENU_OPEN_MENU ) then
            dropDownList.numButtons = 0;
            dropDownList.maxWidth = 0;
            for j=1, MSA_DROPDOWNMENU_MAXBUTTONS, 1 do
                button = _G["MSA_DropDownList"..i.."Button"..j];
                button:Hide();
            end
            dropDownList:Hide();
        end
    end
    frame:SetHeight(MSA_DROPDOWNMENU_BUTTON_HEIGHT * 2);
end

function MSA_DropDownMenu_Initialize(frame, initFunction, displayMode, level, menuList)
    frame.menuList = menuList;

    MSA_DropDownMenu_InitializeHelper(frame);

    -- Set the initialize function and call it.  The initFunction populates the dropdown list.
    if ( initFunction ) then
        MSA_DropDownMenu_SetInitializeFunction(frame, initFunction);
        initFunction(frame, level, frame.menuList);
    end

    --master frame
    if(level == nil) then
        level = 1;
    end

    local dropDownList = _G["MSA_DropDownList"..level]
    dropDownList.dropdown = frame;
    dropDownList.shouldRefresh = true;

    -- Change appearance based on the displayMode
    if ( displayMode == "MENU" ) then
        local name = frame:GetName();
        _G[name.."Left"]:Hide();
        _G[name.."Middle"]:Hide();
        _G[name.."Right"]:Hide();
        _G[name.."ButtonNormalTexture"]:SetTexture("");
        _G[name.."ButtonDisabledTexture"]:SetTexture("");
        _G[name.."ButtonPushedTexture"]:SetTexture("");
        _G[name.."ButtonHighlightTexture"]:SetTexture("");

        local button = _G[name.."Button"]
        button:ClearAllPoints();
        button:SetPoint("LEFT", name.."Text", "LEFT", -9, 0);
        button:SetPoint("RIGHT", name.."Text", "RIGHT", 6, 0);
        frame.displayMode = "MENU";
    end

end

function MSA_DropDownMenu_SetInitializeFunction(frame, initFunction)
    frame.initialize = initFunction;
end

function MSA_DropDownMenu_RefreshDropDownSize(self)
    self.maxWidth = MSA_DropDownMenu_GetMaxButtonWidth(self);
    self:SetWidth(self.maxWidth + 25);

    for i=1, MSA_DROPDOWNMENU_MAXBUTTONS, 1 do
        local icon = _G[self:GetName().."Button"..i.."Icon"];

        if ( icon.tFitDropDownSizeX ) then
            icon:SetWidth(self.maxWidth - 5);
        end
    end
end

-- If dropdown is visible then see if its timer has expired, if so hide the frame
function MSA_DropDownMenu_OnUpdate(self, elapsed)
    if ( self.shouldRefresh ) then
        MSA_DropDownMenu_RefreshDropDownSize(self);
        self.shouldRefresh = false;
    end

    if ( not self.showTimer or not self.isCounting ) then
        return;
    elseif ( self.showTimer < 0 ) then
        self:Hide();
        self.showTimer = nil;
        self.isCounting = nil;
    else
        self.showTimer = self.showTimer - elapsed;
    end
end

-- Start the countdown on a frame
function MSA_DropDownMenu_StartCounting(frame)
    if ( frame.parent ) then
        MSA_DropDownMenu_StartCounting(frame.parent);
    else
        frame.showTimer = MSA_DROPDOWNMENU_SHOW_TIME;
        frame.isCounting = 1;
    end
end

-- Stop the countdown on a frame
function MSA_DropDownMenu_StopCounting(frame)
    if ( frame.parent ) then
        MSA_DropDownMenu_StopCounting(frame.parent);
    else
        frame.isCounting = nil;
    end
end

--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that MSA_DROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, true, function]  --  Check the button if true or function returns true
info.isNotRadio = [nil, true]  --  Check the button uses radial image if false check box image if true
info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.tooltipWhileDisabled = [nil, 1] -- Show the tooltip, even when the button is disabled.
info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, true]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.tooltipOnButton = [nil, 1] -- Show the tooltip attached to the button instead of as a Newbie tooltip.
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.fontObject = [FONT] -- font object replacement for Normal and Highlight
info.menuTable = [TABLE] -- This contains an array of info tables to be displayed as a child menu
info.noClickSound = [nil, 1]  --  Set to 1 to suppress the sound when clicking the button. The sound only plays if .func is set.
info.padding = [nil, NUMBER] -- Number of pixels to pad the text on the right side
info.leftPadding = [nil, NUMBER] -- Number of pixels to pad the button on the left side
info.minWidth = [nil, NUMBER] -- Minimum width for this line
]]

local MSA_DropDownMenu_ButtonInfo = {};

local wipe = table.wipe;

function MSA_DropDownMenu_CreateInfo()
    -- Reuse the same table to prevent memory churn
    return wipe(MSA_DropDownMenu_ButtonInfo);
end

function MSA_DropDownMenu_CreateFrames(level, index)
    while ( level > MSA_DROPDOWNMENU_MAXLEVELS ) do
        MSA_DROPDOWNMENU_MAXLEVELS = MSA_DROPDOWNMENU_MAXLEVELS + 1;
        local newList = CreateDropDownList("MSA_DropDownList"..MSA_DROPDOWNMENU_MAXLEVELS);
        newList:SetFrameStrata("FULLSCREEN_DIALOG");
        newList:SetToplevel(true);
        newList:Hide();
        newList:SetID(MSA_DROPDOWNMENU_MAXLEVELS);
        newList:SetWidth(180)
        newList:SetHeight(10)
        for i=MSA_DROPDOWNMENU_MINBUTTONS+1, MSA_DROPDOWNMENU_MAXBUTTONS do
            local newButton = CreateDropDownMenuButton("MSA_DropDownList"..MSA_DROPDOWNMENU_MAXLEVELS.."Button"..i, newList);
            newButton:SetID(i);
        end
    end

    while ( index > MSA_DROPDOWNMENU_MAXBUTTONS ) do
        MSA_DROPDOWNMENU_MAXBUTTONS = MSA_DROPDOWNMENU_MAXBUTTONS + 1;
        for i=1, MSA_DROPDOWNMENU_MAXLEVELS do
            local newButton = CreateDropDownMenuButton("MSA_DropDownList"..i.."Button"..MSA_DROPDOWNMENU_MAXBUTTONS, _G["MSA_DropDownList"..i]);
            newButton:SetID(MSA_DROPDOWNMENU_MAXBUTTONS);
        end
    end
end

function MSA_DropDownMenu_AddSeparator(info, level)
    info.text = nil;
    info.hasArrow = false;
    info.dist = 0;
    info.isTitle = true;
    info.isUninteractable = true;
    info.notCheckable = true;
    info.leftPadding = nil;     -- MSA
    info.iconOnly = true;
    info.icon = "Interface\\Common\\UI-TooltipDivider-Transparent";
    info.tCoordLeft = 0;
    info.tCoordRight = 1;
    info.tCoordTop = 0;
    info.tCoordBottom = 1;
    info.tSizeX = 0;
    info.tSizeY = 8;
    info.tFitDropDownSizeX = true;
    info.iconInfo = { tCoordLeft = info.tCoordLeft,
        tCoordRight = info.tCoordRight,
        tCoordTop = info.tCoordTop,
        tCoordBottom = info.tCoordBottom,
        tSizeX = info.tSizeX,
        tSizeY = info.tSizeY,
        tFitDropDownSizeX = info.tFitDropDownSizeX };

    MSA_DropDownMenu_AddButton(info, level);

    -- MSA
    info.isTitle = nil;
    info.disabled = nil;
    info.iconOnly = nil;
    info.icon = nil;
    info.iconInfo = nil;
end

function MSA_DropDownMenu_AddButton(info, level)
    --[[
    Might to uncomment this if there are performance issues
    if ( not MSA_DROPDOWNMENU_OPEN_MENU ) then
        return;
    end
    ]]
    if ( not level ) then
        level = 1;
    end

    local listFrame = _G["MSA_DropDownList"..level];
    local index = listFrame and (listFrame.numButtons + 1) or 1;
    local width;

    MSA_DropDownMenuDelegate:SetAttribute("createframes-level", level);
    MSA_DropDownMenuDelegate:SetAttribute("createframes-index", index);
    MSA_DropDownMenuDelegate:SetAttribute("createframes", true);

    listFrame = listFrame or _G["MSA_DropDownList"..level];
    local listFrameName = listFrame:GetName();

    -- Set the number of buttons in the listframe
    listFrame.numButtons = index;

    local button = _G[listFrameName.."Button"..index];
    local normalText = _G[button:GetName().."NormalText"];
    local icon = _G[button:GetName().."Icon"];
    -- This button is used to capture the mouse OnEnter/OnLeave events if the dropdown button is disabled, since a disabled button doesn't receive any events
    -- This is used specifically for drop down menu time outs
    local invisibleButton = _G[button:GetName().."InvisibleButton"];

    -- Default settings
    button:SetDisabledFontObject(GameFontDisableSmallLeft);
    invisibleButton:Hide();
    button:Enable();

    -- If not clickable then disable the button and set it white
    if ( info.notClickable ) then
        info.disabled = true;
        button:SetDisabledFontObject(GameFontHighlightSmallLeft);
    end

    -- Set the text color and disable it if its a title
    if ( info.isTitle ) then
        info.disabled = true;
        button:SetDisabledFontObject(GameFontNormalSmallLeft);
    end

    -- Disable the button if disabled and turn off the color code
    if ( info.disabled ) then
        button:Disable();
        invisibleButton:Show();
        info.colorCode = nil;
    end

    -- If there is a color for a disabled line, set it
    if( info.disablecolor ) then
        info.colorCode = info.disablecolor;
    end

    -- Configure button
    if ( info.text ) then
        -- look for inline color code this is only if the button is enabled
        if ( info.colorCode ) then
            button:SetText(info.colorCode..info.text.."|r");
        else
            button:SetText(info.text);
        end

        -- Set icon
        if ( info.icon ) then
            icon:SetSize(16,16);
            icon:SetTexture(info.icon);
            icon:ClearAllPoints();
            icon:SetPoint("RIGHT");

            if ( info.tCoordLeft ) then
                icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
            else
                icon:SetTexCoord(0, 1, 0, 1);
            end
            icon:Show();
        else
            icon:Hide();
        end

        -- Check to see if there is a replacement font
        if ( info.fontObject ) then
            button:SetNormalFontObject(info.fontObject);
            button:SetHighlightFontObject(info.fontObject);
        else
            button:SetNormalFontObject(GameFontHighlightSmallLeft);
            button:SetHighlightFontObject(GameFontHighlightSmallLeft);
        end
    else
        button:SetText("");
        icon:Hide();
    end

    button.iconOnly = nil;
    button.icon = nil;
    button.iconInfo = nil;

    if (info.iconInfo) then
        icon.tFitDropDownSizeX = info.iconInfo.tFitDropDownSizeX;
    else
        icon.tFitDropDownSizeX = nil;
    end
    if (info.iconOnly and info.icon) then
        button.iconOnly = true;
        button.icon = info.icon;
        button.iconInfo = info.iconInfo;

        MSA_DropDownMenu_SetIconImage(icon, info.icon, info.iconInfo);
        icon:ClearAllPoints();
        icon:SetPoint("LEFT");
    end

    -- Pass through attributes
    button.func = info.func;
    button.owner = info.owner;
    button.hasOpacity = info.hasOpacity;
    button.opacity = info.opacity;
    button.opacityFunc = info.opacityFunc;
    button.cancelFunc = info.cancelFunc;
    button.swatchFunc = info.swatchFunc;
    button.keepShownOnClick = info.keepShownOnClick;
    button.tooltipTitle = info.tooltipTitle;
    button.tooltipText = info.tooltipText;
    button.arg1 = info.arg1;
    button.arg2 = info.arg2;
    button.hasArrow = info.hasArrow;
    button.hasColorSwatch = info.hasColorSwatch;
    button.notCheckable = info.notCheckable;
    button.menuList = info.menuList;
    button.tooltipWhileDisabled = info.tooltipWhileDisabled;
    button.tooltipOnButton = info.tooltipOnButton;
    button.noClickSound = info.noClickSound;
    button.padding = info.padding;

    if ( info.value ) then
        button.value = info.value;
    elseif ( info.text ) then
        button.value = info.text;
    else
        button.value = nil;
    end

    -- Show the expand arrow if it has one
    if ( info.hasArrow ) then
        _G[listFrameName.."Button"..index.."ExpandArrow"]:Show();
    else
        _G[listFrameName.."Button"..index.."ExpandArrow"]:Hide();
    end
    button.hasArrow = info.hasArrow;

    -- If not checkable move everything over to the left to fill in the gap where the check would be
    local xPos = 5;
    local yPos = -((button:GetID() - 1) * MSA_DROPDOWNMENU_BUTTON_HEIGHT) - MSA_DROPDOWNMENU_BORDER_HEIGHT;
    local displayInfo = normalText;
    if (info.iconOnly) then
        displayInfo = icon;
    end

    displayInfo:ClearAllPoints();
    if ( info.notCheckable ) then
        if ( info.justifyH and info.justifyH == "CENTER" ) then
            displayInfo:SetPoint("CENTER", button, "CENTER", -7, 0);
        else
            displayInfo:SetPoint("LEFT", button, "LEFT", 0, 0);
        end
        xPos = xPos + 10;

    else
        xPos = xPos + 12;
        displayInfo:SetPoint("LEFT", button, "LEFT", 20, 0);
    end

    -- Adjust offset if displayMode is menu
    local frame = MSA_DROPDOWNMENU_OPEN_MENU;
    if ( frame and frame.displayMode == "MENU" ) then
        if ( not info.notCheckable ) then
            xPos = xPos - 2;    -- MSA
        end
    end

    -- If no open frame then set the frame to the currently initialized frame
    frame = frame or MSA_DROPDOWNMENU_INIT_MENU;

    if ( info.leftPadding ) then
        xPos = xPos + info.leftPadding;
    end
    button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);

    -- See if button is selected by id or name
    if ( frame ) then
        if ( MSA_DropDownMenu_GetSelectedName(frame) ) then
            if ( button:GetText() == MSA_DropDownMenu_GetSelectedName(frame) ) then
                info.checked = 1;
            end
        elseif ( MSA_DropDownMenu_GetSelectedID(frame) ) then
            if ( button:GetID() == MSA_DropDownMenu_GetSelectedID(frame) ) then
                info.checked = 1;
            end
        elseif ( MSA_DropDownMenu_GetSelectedValue(frame) ) then
            if ( button.value == MSA_DropDownMenu_GetSelectedValue(frame) ) then
                info.checked = 1;
            end
        end
    end


    if not info.notCheckable then
        if ( info.disabled ) then
            _G[listFrameName.."Button"..index.."Check"]:SetDesaturated(true);
            _G[listFrameName.."Button"..index.."Check"]:SetAlpha(0.5);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetDesaturated(true);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetAlpha(0.5);
        else
            _G[listFrameName.."Button"..index.."Check"]:SetDesaturated(false);
            _G[listFrameName.."Button"..index.."Check"]:SetAlpha(1);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetDesaturated(false);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetAlpha(1);
        end

        if info.isNotRadio then
            _G[listFrameName.."Button"..index.."Check"]:SetTexCoord(0.0, 0.5, 0.0, 0.5);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetTexCoord(0.5, 1.0, 0.0, 0.5);
        else
            _G[listFrameName.."Button"..index.."Check"]:SetTexCoord(0.0, 0.5, 0.5, 1.0);
            _G[listFrameName.."Button"..index.."UnCheck"]:SetTexCoord(0.5, 1.0, 0.5, 1.0);
        end

        -- Checked can be a function now
        local checked = info.checked;
        if ( type(checked) == "function" ) then
            checked = checked(button);
        end

        -- Show the check if checked
        if ( checked ) then
            button:LockHighlight();
            _G[listFrameName.."Button"..index.."Check"]:Show();
            _G[listFrameName.."Button"..index.."UnCheck"]:Hide();
        else
            button:UnlockHighlight();
            _G[listFrameName.."Button"..index.."Check"]:Hide();
            _G[listFrameName.."Button"..index.."UnCheck"]:Show();
        end
    else
        _G[listFrameName.."Button"..index.."Check"]:Hide();
        _G[listFrameName.."Button"..index.."UnCheck"]:Hide();
    end
    button.checked = info.checked;

    -- If has a colorswatch, show it and vertex color it
    local colorSwatch = _G[listFrameName.."Button"..index.."ColorSwatch"];
    if ( info.hasColorSwatch ) then
        _G["MSA_DropDownList"..level.."Button"..index.."ColorSwatch".."NormalTexture"]:SetVertexColor(info.r, info.g, info.b);
        button.r = info.r;
        button.g = info.g;
        button.b = info.b;
        colorSwatch:Show();
    else
        colorSwatch:Hide();
    end

    width = max(MSA_DropDownMenu_GetButtonWidth(button), info.minWidth or 0);
    --Set maximum button width
    if ( width > listFrame.maxWidth ) then
        listFrame.maxWidth = width;
    end

    -- Set the height of the listframe
    listFrame:SetHeight((index * MSA_DROPDOWNMENU_BUTTON_HEIGHT) + (MSA_DROPDOWNMENU_BORDER_HEIGHT * 2));

    button:Show();
end

function MSA_DropDownMenu_GetMaxButtonWidth(self)
    local maxWidth = 0;
    for i=1, self.numButtons do
        local button = _G[self:GetName().."Button"..i];
        if ( button:IsShown() ) then
            local width = MSA_DropDownMenu_GetButtonWidth(button);
            if ( width > maxWidth ) then
                maxWidth = width;
            end
        end
    end
    return maxWidth;
end

function MSA_DropDownMenu_GetButtonWidth(button)
    local width;
    local buttonName = button:GetName();
    local icon = _G[buttonName.."Icon"];
    local normalText = _G[buttonName.."NormalText"];

    if ( button.iconOnly and icon ) then
        width = icon:GetWidth();
    elseif ( normalText and normalText:GetText() ) then
        width = normalText:GetWidth() + 40;

        if ( button.icon ) then
            -- Add padding for the icon
            width = width + 10;
        end
    else
        return 0;
    end

    -- Add padding if has and expand arrow or color swatch
    if ( button.hasArrow or button.hasColorSwatch ) then
        width = width + 10;
    end
    if ( button.notCheckable ) then
        width = width - 30;
    end
    if ( button.padding ) then
        width = width + button.padding;
    end

    return width;
end

function MSA_DropDownMenu_Refresh(frame, useValue, dropdownLevel)
    local button, checked, checkImage, uncheckImage, normalText, width;
    local maxWidth = 0;
    local somethingChecked = nil;
    if ( not dropdownLevel ) then
        dropdownLevel = MSA_DROPDOWNMENU_MENU_LEVEL;
    end

    local listFrame = _G["MSA_DropDownList"..dropdownLevel];
    listFrame.numButtons = listFrame.numButtons or 0;
    -- Just redraws the existing menu
    for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
        button = _G["MSA_DropDownList"..dropdownLevel.."Button"..i];
        checked = nil;

        if(i <= listFrame.numButtons) then
            -- See if checked or not
            if ( MSA_DropDownMenu_GetSelectedName(frame) ) then
                if ( button:GetText() == MSA_DropDownMenu_GetSelectedName(frame) ) then
                    checked = 1;
                end
            elseif ( MSA_DropDownMenu_GetSelectedID(frame) ) then
                if ( button:GetID() == MSA_DropDownMenu_GetSelectedID(frame) ) then
                    checked = 1;
                end
            elseif ( MSA_DropDownMenu_GetSelectedValue(frame) ) then
                if ( button.value == MSA_DropDownMenu_GetSelectedValue(frame) ) then
                    checked = 1;
                end
            end
        end
        if (button.checked and type(button.checked) == "function") then
            checked = button.checked(button);
        end

        if not button.notCheckable and button:IsShown() then
            -- If checked show check image
            checkImage = _G["MSA_DropDownList"..dropdownLevel.."Button"..i.."Check"];
            uncheckImage = _G["MSA_DropDownList"..dropdownLevel.."Button"..i.."UnCheck"];
            if ( checked ) then
                somethingChecked = true;
                local icon = _G[frame:GetName().."Icon"];
                if (button.iconOnly and icon and button.icon) then
                    MSA_DropDownMenu_SetIconImage(icon, button.icon, button.iconInfo);
                elseif ( useValue ) then
                    MSA_DropDownMenu_SetText(frame, button.value);
                    icon:Hide();
                else
                    MSA_DropDownMenu_SetText(frame, button:GetText());
                    icon:Hide();
                end
                button:LockHighlight();
                checkImage:Show();
                uncheckImage:Hide();
            else
                button:UnlockHighlight();
                checkImage:Hide();
                uncheckImage:Show();
            end
        end

        if ( button:IsShown() ) then
            width = MSA_DropDownMenu_GetButtonWidth(button);
            if ( width > maxWidth ) then
                maxWidth = width;
            end
        end
    end
    if(somethingChecked == nil) then
        MSA_DropDownMenu_SetText(frame, VIDEO_QUALITY_LABEL6);
    end
    if (not frame.noResize) then
        for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
            button = _G["MSA_DropDownList"..dropdownLevel.."Button"..i];
            button:SetWidth(maxWidth);
        end
        MSA_DropDownMenu_RefreshDropDownSize(_G["MSA_DropDownList"..dropdownLevel]);
    end
end

function MSA_DropDownMenu_RefreshAll(frame, useValue)
    for dropdownLevel = MSA_DROPDOWNMENU_MENU_LEVEL, 2, -1 do
        local listFrame = _G["MSA_DropDownList"..dropdownLevel];
        if ( listFrame:IsShown() ) then
            MSA_DropDownMenu_Refresh(frame, nil, dropdownLevel);
        end
    end
    -- useValue is the text on the dropdown, only needs to be set once
    MSA_DropDownMenu_Refresh(frame, useValue, 1);
end

function MSA_DropDownMenu_SetIconImage(icon, texture, info)
    icon:SetTexture(texture);
    if ( info.tCoordLeft ) then
        icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
    else
        icon:SetTexCoord(0, 1, 0, 1);
    end
    if ( info.tSizeX ) then
        icon:SetWidth(info.tSizeX);
    else
        icon:SetWidth(16);
    end
    if ( info.tSizeY ) then
        icon:SetHeight(info.tSizeY);
    else
        icon:SetHeight(16);
    end
    icon:Show();
end

function MSA_DropDownMenu_SetSelectedName(frame, name, useValue)
    frame.selectedName = name;
    frame.selectedID = nil;
    frame.selectedValue = nil;
    MSA_DropDownMenu_Refresh(frame, useValue);
end

function MSA_DropDownMenu_SetSelectedValue(frame, value, useValue)
    -- useValue will set the value as the text, not the name
    frame.selectedName = nil;
    frame.selectedID = nil;
    frame.selectedValue = value;
    MSA_DropDownMenu_Refresh(frame, useValue);
end

function MSA_DropDownMenu_SetSelectedID(frame, id, useValue)
    frame.selectedID = id;
    frame.selectedName = nil;
    frame.selectedValue = nil;
    MSA_DropDownMenu_Refresh(frame, useValue);
end

function MSA_DropDownMenu_GetSelectedName(frame)
    return frame.selectedName;
end

function MSA_DropDownMenu_GetSelectedID(frame)
    if ( frame.selectedID ) then
        return frame.selectedID;
    else
        -- If no explicit selectedID then try to send the id of a selected value or name
        local button;
        for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
            button = _G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL.."Button"..i];
            -- See if checked or not
            if ( MSA_DropDownMenu_GetSelectedName(frame) ) then
                if ( button:GetText() == MSA_DropDownMenu_GetSelectedName(frame) ) then
                    return i;
                end
            elseif ( MSA_DropDownMenu_GetSelectedValue(frame) ) then
                if ( button.value == MSA_DropDownMenu_GetSelectedValue(frame) ) then
                    return i;
                end
            end
        end
    end
end

function MSA_DropDownMenu_GetSelectedValue(frame)
    return frame.selectedValue;
end

function MSA_DropDownMenuButton_OnClick(self)
    local checked = self.checked;
    if ( type (checked) == "function" ) then
        checked = checked(self);
    end


    if ( self.keepShownOnClick ) then
        if not self.notCheckable then
            if ( checked ) then
                _G[self:GetName().."Check"]:Hide();
                _G[self:GetName().."UnCheck"]:Show();
                checked = false;
            else
                _G[self:GetName().."Check"]:Show();
                _G[self:GetName().."UnCheck"]:Hide();
                checked = true;
            end
        end
    else
        self:GetParent():Hide();
    end

    if ( type (self.checked) ~= "function" ) then
        self.checked = checked;
    end

    -- saving this here because func might use a dropdown, changing this self's attributes
    local playSound = true;
    if ( self.noClickSound ) then
        playSound = false;
    end

    local func = self.func;
    if ( func ) then
        func(self, self.arg1, self.arg2, checked);
    else
        return;
    end

    if ( playSound ) then
        PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
    end
end

function MSA_HideDropDownMenu(level)
    local listFrame = _G["MSA_DropDownList"..level];
    listFrame:Hide();
end

function MSA_ToggleDropDownMenu(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
    if ( not level ) then
        level = 1;
    end
    MSA_DropDownMenuDelegate:SetAttribute("createframes-level", level);
    MSA_DropDownMenuDelegate:SetAttribute("createframes-index", 0);
    MSA_DropDownMenuDelegate:SetAttribute("createframes", true);
    MSA_DROPDOWNMENU_MENU_LEVEL = level;
    MSA_DROPDOWNMENU_MENU_VALUE = value;
    local listFrame = _G["MSA_DropDownList"..level];
    local listFrameName = "MSA_DropDownList"..level;
    local listFrameBlizz = _G["DropDownList1"];
    local tempFrame;
    local point, relativePoint, relativeTo;
    if ( not dropDownFrame ) then
        tempFrame = button:GetParent();
    else
        tempFrame = dropDownFrame;
    end
    if ( listFrame:IsShown() and (MSA_DROPDOWNMENU_OPEN_MENU == tempFrame) ) then
        listFrame:Hide();
    else
        -- Set the dropdownframe scale
        local uiScale;
        local uiParentScale = UIParent:GetScale();
        if ( GetCVar("useUIScale") == "1" ) then
            uiScale = tonumber(GetCVar("uiscale"));
            if ( uiParentScale < uiScale ) then
                uiScale = uiParentScale;
            end
        else
            uiScale = uiParentScale;
        end
        -- MSA
        if oldVersion and oldVersion <= 4 then
            listFrame:SetScale(uiScale);
        end

        -- Hide the listframe anyways since it is redrawn OnShow()
        listFrame:Hide();
        if ( listFrameBlizz and listFrameBlizz:IsShown() ) then
            listFrameBlizz:Hide();
        end

        -- Frame to anchor the dropdown menu to
        local anchorFrame;

        -- Display stuff
        -- Level specific stuff
        if ( level == 1 ) then
            MSA_DropDownMenuDelegate:SetAttribute("openmenu", dropDownFrame);
            listFrame:ClearAllPoints();
            -- If there's no specified anchorName then use left side of the dropdown menu
            if ( not anchorName ) then
                -- See if the anchor was set manually using setanchor
                if ( dropDownFrame.xOffset ) then
                    xOffset = dropDownFrame.xOffset;
                end
                if ( dropDownFrame.yOffset ) then
                    yOffset = dropDownFrame.yOffset;
                end
                if ( dropDownFrame.point ) then
                    point = dropDownFrame.point;
                end
                if ( dropDownFrame.relativeTo ) then
                    relativeTo = dropDownFrame.relativeTo;
                else
                    relativeTo = MSA_DROPDOWNMENU_OPEN_MENU:GetName().."Left";
                end
                if ( dropDownFrame.relativePoint ) then
                    relativePoint = dropDownFrame.relativePoint;
                end
            elseif ( anchorName == "cursor" ) then
                relativeTo = nil;
                local cursorX, cursorY = GetCursorPosition();
                cursorX = cursorX/uiScale;
                cursorY =  cursorY/uiScale;

                if ( not xOffset ) then
                    xOffset = 0;
                end
                if ( not yOffset ) then
                    yOffset = 0;
                end
                xOffset = cursorX + xOffset;
                yOffset = cursorY + yOffset;
            else
                -- See if the anchor was set manually using setanchor
                if ( dropDownFrame.xOffset ) then
                    xOffset = dropDownFrame.xOffset;
                end
                if ( dropDownFrame.yOffset ) then
                    yOffset = dropDownFrame.yOffset;
                end
                if ( dropDownFrame.point ) then
                    point = dropDownFrame.point;
                end
                if ( dropDownFrame.relativeTo ) then
                    relativeTo = dropDownFrame.relativeTo;
                else
                    relativeTo = anchorName;
                end
                if ( dropDownFrame.relativePoint ) then
                    relativePoint = dropDownFrame.relativePoint;
                end
            end
            if ( not xOffset or not yOffset ) then
                xOffset = 8;
                yOffset = 22;
            end
            if ( not point ) then
                point = "TOPLEFT";
            end
            if ( not relativePoint ) then
                relativePoint = "BOTTOMLEFT";
            end
            listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
        else
            if ( not dropDownFrame ) then
                dropDownFrame = MSA_DROPDOWNMENU_OPEN_MENU;
            end
            listFrame:ClearAllPoints();
            -- If this is a dropdown button, not the arrow anchor it to itself
            if ( strsub(button:GetParent():GetName(), 0,16) == "MSA_DropDownList" and strlen(button:GetParent():GetName()) == 17 ) then
                anchorFrame = button;
            else
                anchorFrame = button:GetParent();
            end
            point = "TOPLEFT";
            relativePoint = "TOPRIGHT";
            listFrame:SetPoint(point, anchorFrame, relativePoint, 0, 0);
        end

        -- Change list box appearance depending on display mode
        if ( dropDownFrame and dropDownFrame.displayMode == "MENU" ) then
            _G[listFrameName.."Backdrop"]:Hide();
            _G[listFrameName.."MenuBackdrop"]:Show();
        else
            _G[listFrameName.."Backdrop"]:Show();
            _G[listFrameName.."MenuBackdrop"]:Hide();
        end
        dropDownFrame.menuList = menuList;
        MSA_DropDownMenu_Initialize(dropDownFrame, dropDownFrame.initialize, nil, level, menuList);
        -- If no items in the drop down don't show it
        if ( listFrame.numButtons == 0 ) then
            return;
        end

        -- Check to see if the dropdownlist is off the screen, if it is anchor it to the top of the dropdown button
        listFrame:Show();
        -- Hack since GetCenter() is returning coords relative to 1024x768
        local x, y = listFrame:GetCenter();
        -- Hack will fix this in next revision of dropdowns
        if ( not x or not y ) then
            listFrame:Hide();
            return;
        end

        listFrame.onHide = dropDownFrame.onHide;

        --  We just move level 1 enough to keep it on the screen. We don't necessarily change the anchors.
        if ( level == 1 ) then
            local offLeft = listFrame:GetLeft()/uiScale;
            local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale;
            local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale;
            local offBottom = listFrame:GetBottom()/uiScale;

            local xAddOffset, yAddOffset = 0, 0;
            if ( offLeft < 0 ) then
                xAddOffset = -offLeft;
            elseif ( offRight < 0 ) then
                xAddOffset = offRight;
            end

            if ( offTop < 0 ) then
                yAddOffset = offTop;
            elseif ( offBottom < 0 ) then
                yAddOffset = -offBottom;
            end

            listFrame:ClearAllPoints();
            if ( anchorName == "cursor" ) then
                listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
            else
                listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset);
            end
        else
            -- Determine whether the menu is off the screen or not
            local offscreenY, offscreenX;
            if ( (y - listFrame:GetHeight()/2) < 0 ) then
                offscreenY = 1;
            end
            if ( listFrame:GetRight() > GetScreenWidth() ) then
                offscreenX = 1;
            end
            if ( offscreenY and offscreenX ) then
                point = gsub(point, "TOP(.*)", "BOTTOM%1");
                point = gsub(point, "(.*)LEFT", "%1RIGHT");
                relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
                relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
                xOffset = -11;
                yOffset = -14;
            elseif ( offscreenY ) then
                point = gsub(point, "TOP(.*)", "BOTTOM%1");
                relativePoint = gsub(relativePoint, "TOP(.*)", "BOTTOM%1");
                xOffset = 0;
                yOffset = -14;
            elseif ( offscreenX ) then
                point = gsub(point, "(.*)LEFT", "%1RIGHT");
                relativePoint = gsub(relativePoint, "(.*)RIGHT", "%1LEFT");
                xOffset = -11;
                yOffset = 14;
            else
                xOffset = 0;
                yOffset = 14;
            end

            listFrame:ClearAllPoints();
            listFrame.parentLevel = tonumber(strmatch(anchorFrame:GetName(), "MSA_DropDownList(%d+)"));
            listFrame.parentID = anchorFrame:GetID();
            listFrame:SetPoint(point, anchorFrame, relativePoint, xOffset, yOffset);
        end

        if ( autoHideDelay and tonumber(autoHideDelay)) then
            listFrame.showTimer = autoHideDelay;
            listFrame.isCounting = 1;
        end
    end
end

if ToggleDropDownMenu then
    hooksecurefunc("ToggleDropDownMenu", function(level, value, dropDownFrame, anchorName, xOffset, yOffset, menuList, button, autoHideDelay)
        local listFrameMSA = _G["MSA_DropDownList1"];
        if ( listFrameMSA:IsShown() ) then
            listFrameMSA:Hide();
        end
    end)
end

function MSA_CloseDropDownMenus(level)
    if ( not level ) then
        level = 1;
    end
    for i=level, MSA_DROPDOWNMENU_MAXLEVELS do
        _G["MSA_DropDownList"..i]:Hide();
    end
end

function MSA_DropDownMenu_OnHide(self)
    local id = self:GetID()
    if ( self.onHide ) then
        self.onHide(id+1);
        self.onHide = nil;
    end
    MSA_CloseDropDownMenus(id+1);
    MSA_OPEN_DROPDOWNMENUS[id] = nil;
    if (id == 1) then
        MSA_DROPDOWNMENU_OPEN_MENU = nil;
    end
end

function MSA_DropDownMenu_SetWidth(frame, width, padding)
    _G[frame:GetName().."Middle"]:SetWidth(width);
    local defaultPadding = 25;
    if ( padding ) then
        frame:SetWidth(width + padding);
    else
        frame:SetWidth(width + defaultPadding + defaultPadding);
    end
    if ( padding ) then
        _G[frame:GetName().."Text"]:SetWidth(width);
    else
        _G[frame:GetName().."Text"]:SetWidth(width - defaultPadding);
    end
    frame.noResize = 1;
end

function MSA_DropDownMenu_SetButtonWidth(frame, width)
    if ( width == "TEXT" ) then
        width = _G[frame:GetName().."Text"]:GetWidth();
    end

    _G[frame:GetName().."Button"]:SetWidth(width);
    frame.noResize = 1;
end

function MSA_DropDownMenu_SetText(frame, text)
    local filterText = _G[frame:GetName().."Text"];
    filterText:SetText(text);
end

function MSA_DropDownMenu_GetText(frame)
    local filterText = _G[frame:GetName().."Text"];
    return filterText:GetText();
end

function MSA_DropDownMenu_ClearAll(frame)
    -- Previous code refreshed the menu quite often and was a performance bottleneck
    frame.selectedID = nil;
    frame.selectedName = nil;
    frame.selectedValue = nil;
    MSA_DropDownMenu_SetText(frame, "");

    local button, checkImage, uncheckImage;
    for i=1, MSA_DROPDOWNMENU_MAXBUTTONS do
        button = _G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL.."Button"..i];
        button:UnlockHighlight();

        checkImage = _G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL.."Button"..i.."Check"];
        checkImage:Hide();
        uncheckImage = _G["MSA_DropDownList"..MSA_DROPDOWNMENU_MENU_LEVEL.."Button"..i.."UnCheck"];
        uncheckImage:Hide();
    end
end

function MSA_DropDownMenu_JustifyText(frame, justification)
    local text = _G[frame:GetName().."Text"];
    text:ClearAllPoints();
    if ( justification == "LEFT" ) then
        text:SetPoint("LEFT", frame:GetName().."Left", "LEFT", 27, 2);
        text:SetJustifyH("LEFT");
    elseif ( justification == "RIGHT" ) then
        text:SetPoint("RIGHT", frame:GetName().."Right", "RIGHT", -43, 2);
        text:SetJustifyH("RIGHT");
    elseif ( justification == "CENTER" ) then
        text:SetPoint("CENTER", frame:GetName().."Middle", "CENTER", -5, 2);
        text:SetJustifyH("CENTER");
    end
end

function MSA_DropDownMenu_SetAnchor(dropdown, xOffset, yOffset, point, relativeTo, relativePoint)
    dropdown.xOffset = xOffset;
    dropdown.yOffset = yOffset;
    dropdown.point = point;
    dropdown.relativeTo = relativeTo;
    dropdown.relativePoint = relativePoint;
end

function MSA_DropDownMenu_GetCurrentDropDown()
    if ( MSA_DROPDOWNMENU_OPEN_MENU ) then
        return MSA_DROPDOWNMENU_OPEN_MENU;
    elseif ( MSA_DROPDOWNMENU_INIT_MENU ) then
        return MSA_DROPDOWNMENU_INIT_MENU;
    end
end

function MSA_DropDownMenuButton_GetChecked(self)
    return _G[self:GetName().."Check"]:IsShown();
end

function MSA_DropDownMenuButton_GetName(self)
    return _G[self:GetName().."NormalText"]:GetText();
end

function MSA_DropDownMenuButton_OpenColorPicker(self, button)
    CloseMenus();
    if ( not button ) then
        button = self;
    end
    MSA_DROPDOWNMENU_MENU_VALUE = button.value;
    MSA_OpenColorPicker(button);
end

function MSA_DropDownMenu_DisableButton(level, id)
    _G["MSA_DropDownList"..level.."Button"..id]:Disable();
end

function MSA_DropDownMenu_EnableButton(level, id)
    _G["MSA_DropDownList"..level.."Button"..id]:Enable();
end

function MSA_DropDownMenu_SetButtonText(level, id, text, colorCode)
    local button = _G["MSA_DropDownList"..level.."Button"..id];
    if ( colorCode) then
        button:SetText(colorCode..text.."|r");
    else
        button:SetText(text);
    end
end

function MSA_DropDownMenu_SetButtonNotClickable(level, id)
    _G["MSA_DropDownList"..level.."Button"..id]:SetDisabledFontObject(GameFontHighlightSmallLeft);
end

function MSA_DropDownMenu_SetButtonClickable(level, id)
    _G["MSA_DropDownList"..level.."Button"..id]:SetDisabledFontObject(GameFontDisableSmallLeft);
end

function MSA_DropDownMenu_DisableDropDown(dropDown)
    local label = _G[dropDown:GetName().."Label"];
    if ( label ) then
        label:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
    end
    _G[dropDown:GetName().."Text"]:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
    _G[dropDown:GetName().."Button"]:Disable();
    dropDown.isDisabled = 1;
end

function MSA_DropDownMenu_EnableDropDown(dropDown)
    local label = _G[dropDown:GetName().."Label"];
    if ( label ) then
        label:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
    end
    _G[dropDown:GetName().."Text"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
    _G[dropDown:GetName().."Button"]:Enable();
    dropDown.isDisabled = nil;
end

function MSA_DropDownMenu_IsEnabled(dropDown)
    return not dropDown.isDisabled;
end

function MSA_DropDownMenu_GetValue(id)
    --Only works if the dropdown has just been initialized, lame, I know =(
    local button = _G["MSA_DropDownList1Button"..id];
    if ( button ) then
        return _G["MSA_DropDownList1Button"..id].value;
    else
        return nil;
    end
end

function MSA_OpenColorPicker(info)
    ColorPickerFrame.func = info.swatchFunc;
    ColorPickerFrame.hasOpacity = info.hasOpacity;
    ColorPickerFrame.opacityFunc = info.opacityFunc;
    ColorPickerFrame.opacity = info.opacity;
    ColorPickerFrame.previousValues = {r = info.r, g = info.g, b = info.b, opacity = info.opacity};
    ColorPickerFrame.cancelFunc = info.cancelFunc;
    ColorPickerFrame.extraInfo = info.extraInfo;
    -- This must come last, since it triggers a call to ColorPickerFrame.func()
    ColorPickerFrame:SetColorRGB(info.r, info.g, info.b);
    ShowUIPanel(ColorPickerFrame);
end

------------------------------------------------------------------------------------------------------------------------
-- Skins
------------------------------------------------------------------------------------------------------------------------

-- ElvUI skin
local function LoadSkin_ElvUI()
    if not IsAddOnLoaded("ElvUI") then return end
    local E = unpack(_G.ElvUI)
    if E.private.skins.blizzard.misc ~= true then return end
    for i = 1, MSA_DROPDOWNMENU_MAXLEVELS do
        _G["MSA_DropDownList"..i.."MenuBackdrop"]:SetTemplate("Transparent")
        _G["MSA_DropDownList"..i.."Backdrop"]:SetTemplate("Transparent")
    end
end

-- Tukui skin
local function LoadSkin_Tukui()
    if not IsAddOnLoaded("Tukui") then return end
    local backdrop
    for i = 1, MSA_DROPDOWNMENU_MAXLEVELS do
        backdrop = _G["MSA_DropDownList"..i.."MenuBackdrop"]
        backdrop:SetTemplate("Default")
        backdrop:CreateShadow()
        backdrop.IsSkinned = true
        backdrop = _G["MSA_DropDownList"..i.."Backdrop"]
        backdrop:SetTemplate("Default")
        backdrop:CreateShadow()
        backdrop.IsSkinned = true
    end
end

-- Aurora skin
local function LoadSkin_Aurora()
    if not IsAddOnLoaded("Aurora") then return end
    local F = _G.Aurora[1]
    for i = 1, MSA_DROPDOWNMENU_MAXLEVELS do
        F.CreateBD(_G["MSA_DropDownList"..i.."MenuBackdrop"])
        F.CreateBD(_G["MSA_DropDownList"..i.."Backdrop"])
    end
end

-- Init skins
local initFrame = CreateFrame("Frame")
initFrame:SetScript("OnEvent", function(self, event)
    LoadSkin_ElvUI()
    LoadSkin_Tukui()
    LoadSkin_Aurora()
    self:UnregisterEvent(event)
end)
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
