--[[------------------------------------------------------------
FriendsMenuXP.lua
---------------------------------------------------------------]]
FRIENDSMENU_MAXBUTTONS = 20;
local FRIENDSMENU_NOW_LINK_PLAYER = {} --save current mouse over hyperlink
tinsert(UIMenus, "FriendsMenuXP");
tinsert(UIMenus, "FriendsMenuXPSecure");

function GetNameFromLink(link)
    --link is not |Hplayer:Warbaby:33|h[Warbaby]|h in 3.0, only player:Warbaby:33
    --ChatFrame1:AddMessage(string.gsub(link, "%|", "%/"));
    local _, name, lineid = strsplit(":", link);
    if ( name and (strlen(name) > 0) ) then
        name = gsub(name, "([^%s]*)%s+([^%s]*)%s+([^%s]*)", "%3");
        name = gsub(name, "([^%s]*)%s+([^%s]*)", "%2");
    end
    return name;
end

local function SetOrHookScript(frame, scriptName, func)
    if( frame:GetScript(scriptName) ) then
        frame:HookScript(scriptName, func);
    else
        frame:SetScript(scriptName, func);
    end
end

---通用的显示下拉菜单的方法
--@param buttonSet RAID FRIENDS等
--@param closeOrigin 是否关闭原有下拉菜单
--@param anchor relative offsetx offsety 针对DropDownList1的位置
--@param ... -> name, connected, lineID, chatType, chatFrame, friendsList, isMobile
function FriendsMenuXP_ShowDropdown(buttonSet, closeOrigin, anchor, relative, offsetx, offsety, ...)
    local shown = DropDownList1:IsVisible()
    if not shown and closeOrigin == false then return end
    if closeOrigin then HideDropDownMenu(1) end
    local dropDown = InCombatLockdown() and FriendsMenuXP or FriendsMenuXPSecure
    local appendBottom = relative and anchor and anchor:find("TOP") and relative:find("BOTTOM")
    FriendsMenuXP_Show(dropDown, buttonSet, appendBottom, ...)
    dropDown:ClearAllPoints();
    if(DropDownList1:IsVisible()) then
        if DropDownList1:GetTop() and DropDownList1:GetTop()<UIParent:GetHeight()/2 and appendBottom then
            appendBottom = nil
            anchor = "TOPLEFT"
            relative = "TOPRIGHT"
        end
        dropDown:SetPoint(anchor, DropDownList1, relative, offsetx or 0, offsety or 0);
        if appendBottom then
            local width = max(dropDown:GetWidth(), DropDownList1:GetWidth())
            dropDown:SetWidth(width)
            DropDownList1:SetWidth(width)
        end
    else
        if shown then
            dropDown:SetPoint("TOPLEFT", DropDownList1, "TOPLEFT"); --显示在原列表的位置
        else
            local cursorX, cursorY = GetCursorPosition();
            local uiScale = UIParent:GetScale();
            cursorX = cursorX/uiScale;
            cursorY =  cursorY/uiScale;
            dropDown:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX, cursorY);
        end
    end
end

function FriendsMenuXP_HideBoth()
    FriendsMenuXP:Hide()
    if not InCombatLockdown() then FriendsMenuXPSecure:Hide() end
end
hooksecurefunc("HideDropDownMenu", FriendsMenuXP_HideBoth)

--function hooked to ChatFrames' OnHyperlinkEnter
function FriendsMenuXP_OnHyperlinkEnter(self, playerString, arg2,arg3,arg4) --playerString = "player:NAME:line";
    if ( playerString and strsub(playerString, 1, 6) == "player" ) then --|Hplayer
        FRIENDSMENU_NOW_LINK_PLAYER.link = playerString;
        FRIENDSMENU_NOW_LINK_PLAYER.chatFrame = self;
    end;
end

--function hooked to ChatFrames' OnHyperlinkLeave
function FriendsMenuXP_OnHyperlinkLeave(self, arg1,arg2,arg3,arg4)
    table.wipe(FRIENDSMENU_NOW_LINK_PLAYER);
end

--ClickHandler for ListMenu buttons
function FriendsMenuXPButton_OnClick(self)
    local func = self.func;
    if ( func ) then
        func(FriendsMenuXP_ShrinkSameRealmPlayerName(self:GetParent().name), self:GetParent());
    end;

    self:GetParent():Hide();
    if(DropDownList1) then DropDownList1:Hide(); end;
    PlaySound163("UChatScrollButton");
end

function FriendsMenuXP_ChatFrame_OnHyperlinkShow(self, playerString, text, button)
    if(playerString and strsub(playerString, 1, 6) == "player") then
        if ( IsAltKeyDown() ) then
            --we must do reverse action against ItemRef#SetItemRef()
            if(not IsShiftKeyDown()) then
                if (button=="RightButton") then
                    HideDropDownMenu(1);
                else
                    DEFAULT_CHAT_FRAME.editBox:Hide();
                end
            end

            --do our defined action
            InviteUnit(GetNameFromLink(playerString));
            return;
        end
    end
end

--deal with the hot-key click function.
function FriendsMenuXP_InitiateMaskButton()
    --Create a "mask button", to block the click to ChatHyperlink.
    local button = CreateFrame("Button", "ChatLinkMaskButton", UIParent, "SecureActionButtonTemplate");
    button:RegisterForClicks("AnyUp");
    button:SetWidth(30); button:SetHeight(10);

    --right click this button will also bring the menu
    SetOrHookScript(button, "OnClick", function(self, button)
        if(button=="RightButton") then self:Hide() end --showing the mask button will trigger OnHyperlinkLeave
        --[[if(button=="RightButton" and FRIENDSMENU_NOW_LINK_PLAYER.link) then
            local _, name, lineid, chatType, chatTarget = strsplit(":", FRIENDSMENU_NOW_LINK_PLAYER.link);
            FriendsMenuXP_FriendsShowDropdown(name, 1, lineid, chatType, FRIENDSMENU_NOW_LINK_PLAYER.chatFrame);
        end]]
    end);

    --define the SECURE actions
    button:SetAttribute("ctrl-type1", "macro"); --ctrl+leftclick with do "/target linkname" macro.

    --define the insecure actions.
    hooksecurefunc("ChatFrame_OnHyperlinkShow", FriendsMenuXP_ChatFrame_OnHyperlinkShow);
end


function FriendsMenuXP_OnLoad(self)

    FriendsMenuXP_InitiateMaskButton();

    for i=1,7 do
        SetOrHookScript(_G["ChatFrame"..i], "OnHyperlinkEnter", FriendsMenuXP_OnHyperlinkEnter);
        SetOrHookScript(_G["ChatFrame"..i], "OnHyperlinkLeave", FriendsMenuXP_OnHyperlinkLeave);
    end

    SetOrHookScript(DropDownList1, "OnHide", function()
        FriendsMenuXP:Hide();
        if(not InCombatLockdown()) then FriendsMenuXPSecure:Hide(); end
        UIDropDownMenu_StopCounting(FriendsMenuXP)
        UIDropDownMenu_StopCounting(FriendsMenuXPSecure)
    end)

    SetOrHookScript(FriendsMenuXP, "OnHide", function()
        if not FriendsMenuXPSecure:IsVisible() and DropDownList1:IsVisible() then
            DropDownList1:Hide()
        end
    end)

    SetOrHookScript(FriendsMenuXPSecure, "OnHide", function()
        if not FriendsMenuXP:IsVisible() and DropDownList1:IsVisible() then
            DropDownList1:Hide()
        end
    end)

    self:RegisterEvent("PLAYER_REGEN_DISABLED");
    self:RegisterEvent("PLAYER_REGEN_ENABLED");

    FriendsMenuXP_HandlesGlobalMouseEvent = function(self, button, event)
        return self:IsShown() and (self:IsMouseOver() or self:GetParent():IsMouseOver() or DropDownList1:IsMouseOver())
    end
    FriendsMenuXP.HandlesGlobalMouseEvent = FriendsMenuXP_HandlesGlobalMouseEvent
    FriendsMenuXPSecure.HandlesGlobalMouseEvent = FriendsMenuXP_HandlesGlobalMouseEvent

    if(FRIENDS_MENU_XP_LOADED) then DEFAULT_CHAT_FRAME:AddMessage(FRIENDS_MENU_XP_LOADED,1,1,0); end
	-- 5.4.1, fix IsDisabledByParentalControls taint
	--setfenv(MainMenuMicroButton:GetScript("OnMouseUp"), setmetatable({ UpdateMicroButtons = function() end }, { __index = _G }))
end

function FriendsMenuXP_OnEvent(self, event, ...)
    local arg1 = ...;
    if(event=="PLAYER_REGEN_DISABLED") then
        if(ChatLinkMaskButton and ChatLinkMaskButton:IsVisible()) then ChatLinkMaskButton:Hide(); end;
        if(FriendsMenuXPSecure:IsVisible()) then
            local last = FriendsMenuXP
            local name, connected, lineID, chatType, chatFrame, friendsList, isMobile = last.name, last.connected, last.lineID, last.chatType, last.chatFrame, last.friendsList, last.isMobile
            FriendsMenuXP_Show(FriendsMenuXP, FriendsMenuXPSecure, nil, name, connected, lineID, chatType, chatFrame, friendsList, isMobile);
            FriendsMenuXPSecure:Hide();
        end
        --FriendsMenuXPUpdateFrame:SetScript("OnUpdate", nil);
    elseif(event=="PLAYER_REGEN_ENABLED") then
        if(FriendsMenuXP:IsVisible()) then
            local last = FriendsMenuXPSecure
            local name, connected, lineID, chatType, chatFrame, friendsList, isMobile = last.name, last.connected, last.lineID, last.chatType, last.chatFrame, last.friendsList, last.isMobile
            FriendsMenuXP_Show(FriendsMenuXPSecure, FriendsMenuXP, nil, name, connected, lineID, chatType, chatFrame, friendsList, isMobile);
            FriendsMenuXP:Hide();
        end
        if(RaidGroupButton1 and RaidGroupButton1:GetAttribute("type")~="target") then
            FriendsMenuXP_FixRaidGroupButton();
        end;
    end
end

function FriendsMenuXP_FixRaidGroupButton()
    if(not InCombatLockdown()) then
        for i=1,40 do
            local raidbutton = _G["RaidGroupButton"..i];
            if(raidbutton and raidbutton.unit) then
                raidbutton:SetAttribute("type", "target");
                raidbutton:SetAttribute("unit", raidbutton.unit);
            end
        end
    end
end

local TimeSinceLastUpdate = 0;

function FriendsMenuXP_OnUpdate(self, elapsed)
    TimeSinceLastUpdate = TimeSinceLastUpdate + elapsed;
    if(TimeSinceLastUpdate < 0.1) then return end;
    TimeSinceLastUpdate = 0;
    if(InCombatLockdown()) then return end;

    if( IsControlKeyDown() and FRIENDSMENU_NOW_LINK_PLAYER.link) then
        if(ChatLinkMaskButton) then
            local _, name, lineid, chatType, chatTarget = strsplit(":", FRIENDSMENU_NOW_LINK_PLAYER.link);
            ChatLinkMaskButton:SetAttribute("macrotext", "/target "..name);
        end

        local x,y = GetCursorPosition()
        local scale = UIParent:GetScale()
        if(scale and scale ~= 0) then
            x = x / scale
            y = y / scale
        end
        ChatLinkMaskButton:ClearAllPoints()
        ChatLinkMaskButton:SetPoint("TOPLEFT",UIParent,"TOPLEFT", x-15, y - UIParent:GetTop() + 5)

        ChatLinkMaskButton:Show();
    else
        if(not IsControlKeyDown() and ChatLinkMaskButton and ChatLinkMaskButton:IsVisible()) then
            ChatLinkMaskButton:Hide();
        end
    end
end

--===============================================================================================
--The following codes are based on Blizzard's FrameXMLs, includes UnitPopup and UIDropDownMenu.
--arg2 is relativeFrame(table) or ButtonSet(string)
--===============================================================================================
function FriendsMenuXP_Show(listFrame, arg2, appendBottom, name, connected, lineID, chatType, chatFrame, friendsList, isMobile)
    listFrame.name = name;
    listFrame.connected = connected;
    listFrame.lineID = lineID;
    listFrame.chatType = chatType;
    listFrame.chatFrame = chatFrame;
    listFrame.friendsList = friendsList;
    listFrame.isMobile = isMobile;
    listFrame.chatTarget = name;
    listFrame.presenceID = nil;


    local relativeFrame, buttonSet
    if type(arg2)=="string" then
        buttonSet = arg2
    elseif type(arg2)=="table" then
        relativeFrame = arg2
        buttonSet = relativeFrame.buttonSet
    end

    if(not buttonSet) then
        if friendsList and not connected then
            buttonSet = "OFFLINE";
        else
            buttonSet = "NORMAL";
        end
    end
    listFrame.buttonSet = buttonSet;
    FriendsMenu_Initialize(listFrame, buttonSet, appendBottom); --TODO: OFFLINE
    if(not relativeFrame) then PlaySound163("igMainMenuOpen"); end --open at last place should not play sound.

    -- Hide the listframe anyways since it is redrawn OnShow()
    listFrame:Hide();
    listFrame:ClearAllPoints();

    if(relativeFrame) then
        listFrame:SetPoint(relativeFrame:GetPoint(1));
        listFrame:Show();
        return;
    end

    -- Set the dropdownframe scale
    --local uiScale = 1.0;
    --if ( GetCVar("useUiScale") == "1" ) then
    --	uiScale = tonumber(GetCVar("uiscale"));
    --end
    local scale = UIParent:GetScale()
    listFrame:SetScale(scale);

    local cursorX, cursorY = GetCursorPosition();
    cursorX = cursorX/scale;
    cursorY = cursorY/scale
    listFrame:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", cursorX, cursorY);

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
    -- Determine whether the menu is off the screen or not
    local offscreenY, offscreenX;
    if ( (y - listFrame:GetHeight()/2) < 0 ) then
        offscreenY = 1;
    end
    if ( listFrame:GetRight() > GetScreenWidth() ) then
        offscreenX = 1;
    end

    if ( offscreenY and offscreenX ) then
        anchorPoint = "BOTTOMRIGHT";
    elseif ( offscreenY ) then
        anchorPoint = "BOTTOMLEFT";
    elseif ( offscreenX ) then
        anchorPoint = "TOPRIGHT";
    else
        anchorPoint = "TOPLEFT";
    end

    listFrame:ClearAllPoints();
    listFrame:SetPoint(anchorPoint, nil, "BOTTOMLEFT", cursorX, cursorY);
end

function FriendsMenu_Initialize(dropDownList, buttonSet, appendBottom)

    --===============================================================================================
    --Copied from UnitPopup_HideButtons(), compute the information used for the button operation.
    --===============================================================================================
    local inInstance, instanceType = IsInInstance();
    local inParty = 0;
    if ( GetNumGroupMembers() > 0 ) then
        inParty = 1;
    end

    local inRaid = 0;
    if ( GetNumGroupMembers() > 0 and IsInRaid() ) then
        inRaid = 1;
    end

    local isLeader = 0;
    if ( UnitIsGroupLeader("player") ) then
        isLeader = 1;
    end

    local isAssistant = 0;
    if ( UnitIsGroupAssistant("player") ) then
        isAssistant = 1;
    end

    local inBattleground = 0;
    if ( UnitInBattleground("player") ) then
        inBattleground = 1;
    end

    local canCoop = 0;
    if ( dropDownList.unit and UnitCanCooperate("player", dropDownList.unit) ) then
        canCoop = 1;
    end

    dropDownList.inInstance = inInstance
    dropDownList.instanceType = instanceType
    dropDownList.inParty = inParty
    dropDownList.inRaid = inRaid
    dropDownList.isLeader = isLeader
    dropDownList.isAssistant = isAssistant
    dropDownList.inBattleground = inBattleground
    dropDownList.canCoop = canCoop

    -- Hide all the buttons
    local button;
    dropDownList.numButtons = 0;
    dropDownList.maxWidth = 0;
    for j=1, FRIENDSMENU_MAXBUTTONS, 1 do
        button = _G[dropDownList:GetName().."Button"..j];
        button:Hide();
    end
    dropDownList:Hide();

    if not dropDownList.name then return end

    -- Add dropdown title
    local info
    if not appendBottom then
        info = FriendsMenuXP_CreateInfo();
        info.text = dropDownList.name:gsub("%-"..GetRealmName(), "");
        info.isTitle = 1;
        info.justifyH = "LEFT"
        FriendsMenuXP_AddButton(dropDownList, info);
    end

    for _, v in pairs(FriendsMenuXP_ButtonSet[buttonSet]) do
        info = FriendsMenuXP_Buttons[v];
        if info and (not info.show or (dropDownList.name and info.show(FriendsMenuXP_ShrinkSameRealmPlayerName(dropDownList.name), dropDownList))) then
            if(not info.isSecure or strfind(dropDownList:GetName(), "Secure")) then
                FriendsMenuXP_AddButton(dropDownList, info);
            end
        end
    end
end

function FriendsMenuXP_AddButton(listFrame, info)

    local listFrameName = listFrame:GetName();
    local index = listFrame.numButtons + 1;
    local width;

    -- Set the number of buttons in the listframe
    listFrame.numButtons = index;

    local button = _G[listFrameName.."Button"..index];
    if(not button) then return end;
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
        info.disabled = 1;
        button:SetDisabledFontObject(GameFontHighlightSmallLeft);
    end

    -- Set the text color and disable it if its a title
    if ( info.isTitle ) then
        info.disabled = 1;
        button:SetDisabledFontObject(GameFontNormalSmallLeft);
    end

    -- Disable the button if disabled and turn off the color code
    if ( info.disabled ) then
        button:Disable();
        invisibleButton:Show();
        info.colorCode = nil;
    end
    -- Configure button
    if ( info.text ) then
        -- look for inline color code this is only if the button is enabled
        if ( info.colorCode ) then
            button:SetText(info.colorCode..info.text.."|r");
        else
            button:SetText(info.text);
        end
        -- Determine the width of the button
        width = normalText:GetWidth() + 30;
        -- Add padding if has and expand arrow or color swatch
        if ( info.hasArrow or info.hasColorSwatch ) then
            width = width + 10;
        end
        if ( info.notCheckable ) then
            width = width - 30;
        end
        -- Set icon
        if ( info.icon ) then
            icon:SetTexture(info.icon);
            if ( info.tCoordLeft ) then
                icon:SetTexCoord(info.tCoordLeft, info.tCoordRight, info.tCoordTop, info.tCoordBottom);
            else
                icon:SetTexCoord(0, 1, 0, 1);
            end
            icon:Show();
            -- Add padding for the icon
            width = width + 10;
        else
            icon:Hide();
        end
        -- Set maximum button width
        if ( width > listFrame.maxWidth ) then
            listFrame.maxWidth = width;
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

    -- Pass through attributes
    button.func = info.func;
    button.tooltipText = info.tooltipText;

    -- If not checkable move everything over to the left to fill in the gap where the check would be
    local xPos = 5;
    local yPos = -((button:GetID() - 1) * UIDROPDOWNMENU_BUTTON_HEIGHT) - UIDROPDOWNMENU_BORDER_HEIGHT;
    normalText:ClearAllPoints();
    if ( info.justifyH and info.justifyH == "CENTER" ) then
        normalText:SetPoint("CENTER", button, "CENTER", -7, 0);
    else
        normalText:SetPoint("LEFT", button, "LEFT", info.icon and 15 or 0, 0);
    end
    xPos = xPos + 10;

    button:SetPoint("TOPLEFT", button:GetParent(), "TOPLEFT", xPos, yPos);

    button:UnlockHighlight();


    -- Set the height of the listframe
    listFrame:SetHeight((index * UIDROPDOWNMENU_BUTTON_HEIGHT) + (UIDROPDOWNMENU_BORDER_HEIGHT * 2));

    if(button.attributes and button.attributes~="") then
        local attribs = {strsplit(";",button.attributes)};
        for _,v in pairs(attribs) do
            if(v and v~="") then
                button:SetAttribute(v, nil);
            end
        end
    end
    button.attributes = "";
    if(info.isSecure and info.attributes) then
        local attribs = gsub(info.attributes,"%$name%$", FriendsMenuXP_ShrinkSameRealmPlayerName(listFrame.name));
        local aaa = {strsplit(";", attribs)};
        for k,v in pairs(aaa) do
            if(v and v~="") then
                local att,val = strsplit(":",v);
                if(att and att~="" and val and val~="") then
                    button:SetAttribute(strtrim(att), gsub(strtrim(val), "%^", "%:"));
                    button.attributes = button.attributes..strtrim(att)..";";
                end
            end
        end
    end

    button:Show();
end

local FriendsMenuXP_ButtonInfo = {};

function FriendsMenuXP_CreateInfo()
    -- Reuse the same table to prevent memory churn
    local info = FriendsMenuXP_ButtonInfo;
    for k,v in pairs(info) do
        info[k] = nil;
    end
    return FriendsMenuXP_ButtonInfo;
end

--[[------------------------------------------------------------
UnitPopUp
---------------------------------------------------------------]]
local __visible;
local function cleanVisible() __visible=nil end
hooksecurefunc("SpellIsTargeting", function()
    __visible = not not DropDownList1:IsVisible();
    RunOnNextFrame(cleanVisible);
end)

if not RunOnNextFrame then
    RunOnNextFrame = function() end
    local coreframe = CreateFrame("Frame")
    coreframe:SetScript("OnUpdate", function(self)
        __visible = nil
    end)
end

local realm = GetRealmName()
function FriendsMenuXP_ShrinkSameRealmPlayerName(name)
    return name and name:gsub("%-"..realm, "") or name
end

hooksecurefunc("SecureActionButton_OnClick", function(self, button, down)
    if __visible==false and DropDownList1:IsVisible() then

        --[[------------------------------------------------------------
        以下复制自SecureTemplates.lua, 获取unit和actionType
        ---------------------------------------------------------------]]
        if (down) then
            -- remap the button if desired for up-down behaviors. This behavior may not be safe and has been deferred.
            button = SecureButton_GetModifiedAttribute(self, "downbutton", button) or button
        end

        -- Lookup the unit, based on the modifiers and button
        local unit = SecureButton_GetModifiedUnit(self, button);

        -- Remap button suffixes based on the disposition of the unit (contributed by Iriel and Cladhaire)
        if ( unit ) then
            local origButton = button;
            if ( UnitCanAttack("player", unit) )then
                button = SecureButton_GetModifiedAttribute(self, "harmbutton", button) or button;
            elseif ( UnitCanAssist("player", unit) )then
                button = SecureButton_GetModifiedAttribute(self, "helpbutton", button) or button;
            end

            -- The unit may have changed based on button remapping
            if ( button ~= origButton ) then
                unit = SecureButton_GetModifiedUnit(self, button);
            end
        end

        -- Don't do anything if our unit doesn't exist
        if ( unit and unit ~= "none" and not UnitExists(unit) ) then
            return;
        end

        -- Lookup the action type, based on the modifiers and button
        local actionType = SecureButton_GetModifiedAttribute(self, "type", button);

        -- Perform the requested action!
        if ( actionType == "menu") then

            --================= 显示我们的下拉菜单 ==============
            local name, server = UnitName(unit);
            if(server and server~="") then name = name.."-"..server; end
            local connected = UnitIsConnected(unit);
            FriendsMenuXP_ShowDropdown(UnitIsPlayer(unit) and "UNITPOPUP" or "NPC", false, "TOPLEFT", "BOTTOMLEFT", 0, 0, name, connected)
        end

    end
end)

function FriendsMenuXP_StopCounting(self)
    if DropDownList1 and DropDownList1:IsVisible() then
        DropDownList1.isCounting = nil  --avoid cycle call
    end
    self.isCounting = nil
end

--- 鼠标离开我们的菜单移到原菜单的时候，保持我们的菜单开启
hooksecurefunc("UIDropDownMenu_StartCounting", function(self)
    if self==DropDownList1 then
        if (FriendsMenuXP:IsVisible()) then
            UIDropDownMenu_StartCounting(FriendsMenuXP)
        elseif (FriendsMenuXPSecure:IsVisible()) then
            UIDropDownMenu_StartCounting(FriendsMenuXPSecure)
        end
    end
end)

hooksecurefunc("UIDropDownMenu_StopCounting", function(self)
    if self==DropDownList1 then
        if (FriendsMenuXP:IsVisible()) then
            UIDropDownMenu_StopCounting(FriendsMenuXP)
        elseif (FriendsMenuXPSecure:IsVisible()) then
            UIDropDownMenu_StopCounting(FriendsMenuXPSecure)
        end
    end
end)

--[[------------------------------------------------------------
OTHER HOOKS
---------------------------------------------------------------]]
local DependCall = CoreDependCall
if not DependCall then
    local eventFrame = CreateFrame("Frame");
    local funcs = {}
    eventFrame:SetScript("OnEvent", function(event, arg)
        if event == "ADDON_LOADED" then
            for i=#funcs, 1, -1 do
                if funcs[i](event, arg) then
                    table.remove(funcs, i)
                end
            end
            if #funcs == 0 then
                eventFrame:SetScript("OnEvent", nil);
                eventFrame:UnregisterAllEvents();
                eventFrame = nil;
                funcs = nil;
            end
        end
    end)

    DependCall = function(addon, func)
        if(IsAddOnLoaded(addon)) then
            func()
        else
            table.insert(funcs, func);
        end
    end
end

---- FriendsFrame
hooksecurefunc("FriendsFrame_ShowBNDropdown", FriendsMenuXP_HideBoth)

hooksecurefunc("FriendsFrame_ShowDropdown", function(...)
    FriendsMenuXP_ShowDropdown(nil, true, nil, nil, nil, nil, ...)
end)

---- GuildFrame
DependCall("Blizzard_GuildUI", function()
    hooksecurefunc("GuildRoster_ShowMemberDropDown", function(fullName, online, isMobile)
        FriendsMenuXP_ShowDropdown(nil, false, "TOPLEFT", "TOPRIGHT", 0, 0, fullName, online);
    end)

    --Default style is click open, click hide. Change to click open, click open another
    GuildRosterFrame:HookScript("OnShow", function()
        for i=1, 100 do
            local button = _G["GuildRosterContainerButton"..i]
            if not button then break end
            if not button._163set then
                button._163set = true
                button:SetScript("PreClick", function(self, button)
                    if button ~= "LeftButton" then
                        local fullName = GetGuildRosterInfo(self.guildIndex);
                        local xpMenu = FriendsMenuXPSecure:IsVisible() and FriendsMenuXPSecure
                        local xpMenu = xpMenu or (FriendsMenuXP:IsVisible() and FriendsMenuXP)
                        if xpMenu and xpMenu.name == fullName then
                            --do nothing, let ToggleDropDown in GuildRoster_ShowMemberDropDown hide the DropList
                        else
                            DropDownList1:Hide()
                        end
                    end
                end)
            end
        end
    end)
end)

---- RaidFrame
local function appendRaidDropdown(self)
    local name, server = UnitName(self.unit);
    if(server and server~="") then name = name.."-"..server; end
    local connected = UnitIsConnected(self.unit);
    FriendsMenuXP_ShowDropdown("RAID", false, "TOPLEFT", "TOPRIGHT", 0, 0, name, connected)
end

DependCall("Blizzard_RaidUI", function()
    hooksecurefunc("RaidGroupButton_ShowMenu", appendRaidDropdown);
    FriendsMenuXP_FixRaidGroupButton();
end)