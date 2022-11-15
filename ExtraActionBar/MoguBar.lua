local Masque = LibStub and LibStub('Masque', true)
local AddButtonToGroup = function(btnname, index, groupname, func)
    if not Masque then
        return
    end
    local Group = Masque:Group('额外动作条', groupname)
    for i = 1, index do
        local btn = _G[format(btnname, i)]
        if (btn) then
            Group:AddButton(btn)
            if (func) then
                pcall(func, btn)
            end
        end
    end
end

MOVING_MOGUBAR = nil;
if (GetLocale() == "zhCN") then
    MOGUBAR_WINDOWS = "窗口操作";
    MOGUBAR_UNLOCK_BAR = "解锁动作条";
    MOGUBAR_LOCK_BAR = "锁定动作条";
    MOGUBAR_MINIMIZE_BAR = "最小化动作条";
    MOGUBAR_RESTORE_BAR = "恢复动作条";
    MOGUBAR_RESIZE = "缩放动作条";
    MOGUBAR_CLOSE_BAR = "关闭动作条";
    MOGUBAR_ARRANGEMENT = "排列方式";
    MOGUBAR_ARRANGEMENT_HORIZONTAL = "横向排列";
    MOGUBAR_ARRANGEMENT_VERTICAL = "纵向排列";
    MOGUBAR_ARRANGEMENT_FUNNY = "趣味排列";
    MOGUBAR_BUTTONS = "按钮操作";
    MOGUBAR_INCREASE_BUTTON = "增加按钮";
    MOGUBAR_DECREASE_BUTTON = "减少按钮";
    MOGUBAR_MESSAGE_ERROR_NO_ENOUGH_ID = "没有可分配的动作按钮ID。";
    MOGUBAR_CLOSE_BAR_INFO = "关闭动作条将使你所有的动作按钮信息失去，你真的想关闭动作按钮吗？";
    MOGUBAR_ENABLE = "开启额外动作条";
    MOGUBAR_RESET = "按鍵綁定";
    MOGUBAR_HIDE_TAB = "隐藏动作条标题头";
    MOGUBAR_HIDE_GRID = "隐藏未用的动作按钮";
    MOGUBAR_OTHERS = "其它操作";
    MOGUBAR_CREATE_NEW_BAR = "创建新的动作条";
    MOGUBAR_TAB_HELP_TEXT = "按住鼠标左键可拖动,\n单击鼠标右键弹出操作菜单,\nCTRL滚轮增加/减少按钮,\nCTRL左键可以切换布局。"
elseif (GetLocale() == "zhTW") then
    MOGUBAR_WINDOWS = "視窗";
    MOGUBAR_UNLOCK_BAR = "解鎖快捷列";
    MOGUBAR_LOCK_BAR = "鎖定快捷列";
    MOGUBAR_MINIMIZE_BAR = "最小化快捷列";
    MOGUBAR_RESTORE_BAR = "恢復快捷列";
    MOGUBAR_RESIZE = "縮放動作條";
    MOGUBAR_CLOSE_BAR = "關閉快捷列";
    MOGUBAR_ARRANGEMENT = "排列方式";
    MOGUBAR_ARRANGEMENT_HORIZONTAL = "橫向排列";
    MOGUBAR_ARRANGEMENT_VERTICAL = "縱向排列";
    MOGUBAR_ARRANGEMENT_FUNNY = "趣味排列";
    MOGUBAR_BUTTONS = "按鈕";
    MOGUBAR_INCREASE_BUTTON = "增加按鈕";
    MOGUBAR_DECREASE_BUTTON = "減少按鈕";
    MOGUBAR_OTHERS = "其它操作";
    MOGUBAR_CREATE_NEW_BAR = "創建新的快捷列";
    MOGUBAR_MESSAGE_ERROR_NO_ENOUGH_ID = "沒有可分配的動作按鈕ID。";
    MOGUBAR_CLOSE_BAR_INFO = "關閉快捷列將失去你所有的動作按鈕訊息，你確定要關閉動作按鈕嗎？";
    MOGUBAR_ENABLE = "開啟额外快捷列";
    MOGUBAR_RESET = "按鍵綁定";
    MOGUBAR_HIDE_TAB = "隱藏快捷列標題";
    MOGUBAR_HIDE_GRID = "隱藏未用的動作按鈕";
    MOGUBAR_TAB_HELP_TEXT = "按住滑鼠左鍵可對快捷列進行拖曳,\n點選滑鼠右鍵彈出操作選單。"
else
    MOGUBAR_WINDOWS = "Window";
    MOGUBAR_UNLOCK_BAR = "Unlock";
    MOGUBAR_LOCK_BAR = "Lock";
    MOGUBAR_MINIMIZE_BAR = "Minimize";
    MOGUBAR_RESTORE_BAR = "Restore";
    MOGUBAR_RESIZE = "Resize Bar";
    MOGUBAR_CLOSE_BAR = "Close";
    MOGUBAR_ARRANGEMENT = "Arrangement";
    MOGUBAR_ARRANGEMENT_HORIZONTAL = "Horizontal arrangement";
    MOGUBAR_ARRANGEMENT_VERTICAL = "Vertical arragnement";
    MOGUBAR_ARRANGEMENT_FUNNY = "Funny arrangement";
    MOGUBAR_BUTTONS = "Button";
    MOGUBAR_INCREASE_BUTTON = "Increase button";
    MOGUBAR_DECREASE_BUTTON = "Decrease button";
    MOGUBAR_OTHERS = "Other";
    MOGUBAR_CREATE_NEW_BAR = "Create new bar";
    MOGUBAR_MESSAGE_ERROR_NO_ENOUGH_ID = "No more button could be arragned.";
    MOGUBAR_CLOSE_BAR_INFO = "All button information you want to close will be lost, do you really want to do?";
    MOGUBAR_ENABLE = "Enable MOGU Bar";
    MOGUBAR_RESET = "Key Binding";
    MOGUBAR_HIDE_TAB = "Hide action bar headers";
    MOGUBAR_HIDE_GRID = "Hide unused action buttons";
    MOGUBAR_TAB_HELP_TEXT = "Hold mouse left button to move bar,\nRight click to popup menu.";
end
MOGUBar_MAX_BUTTONS = 12;
MOGUBar_MIN_BUTTONS = 1;
U1BAR_DEFAULT_BTNS = 10;
MOGUBar_TAB_DROPDOWN_WIDTH = 124;
U1BAR_MAX_BARS = 13;
U1BAR_DEFAULT_SCALE = 0.8; --DragonFlight button 45, old 36
U1BAR_ORDER = { 1, 2, 3, 11, 12, 13, 4, 5, 6, 7, 8, 9, 10 } --1对应动作条10,枭兽形态, 2对9,熊形态,3对7是空的,11,12,13是新的
MOGUBar_Info = {};
MOGUBar_ENABLED = nil;
MOGUBar_SHOW_GRID = nil;
StaticPopupDialogs["CLOSE_BAR"] = { preferredIndex = 3,
    text = MOGUBAR_CLOSE_BAR_INFO, button1 = YES, button2 = NO,
    OnAccept = function(self, data)
        MOGUBar_HideBar(data);
    end,
    OnCancel = function(self, MOGUBar_3a41fa2f33897b6c190993d845e6b222)
    end,
    showAlert = 1, timeout = 0, whileDead = 1
};

local BScale = BLibrary("BScale");
local BEvent = BLibrary("BEvent");
function MOGUBar_PageUpAndPageDown()
    ActionBar_PageUp();
    ActionBar_PageDown();
end

function MOGU_ShowKeyBindingFrame(MOGU_7739b813d90aed43ab9d0eb84ec1c1ae)
    if (MOGU_7739b813d90aed43ab9d0eb84ec1c1ae == nil) then
        KeyBindingFrame_LoadUI();
        ShowUIPanel(KeyBindingFrame);
        return ;
    end
    local MOGU_b52e349dfc92773f7d6f1dd51228ec0a = GetNumBindings();
    for MOGU_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGU_b52e349dfc92773f7d6f1dd51228ec0a, 1 do
        local MOGU_d28056e4bcd8f214a25daeabfe052d6e, MOGU_31c593401a06ae783f934538e503e6e1, MOGU_59981dde119ddaafbcbf4b1ac8eae22d = GetBinding(MOGU_e914904fab9d05d3f54d52bfc31a0f3f);
        if (MOGU_d28056e4bcd8f214a25daeabfe052d6e == MOGU_7739b813d90aed43ab9d0eb84ec1c1ae) then
            KeyBindingFrame_LoadUI();
            ShowUIPanel(KeyBindingFrame);
            KeyBindingFrameScrollFrameScrollBar:SetValue((MOGU_e914904fab9d05d3f54d52bfc31a0f3f - 1) * KEY_BINDING_HEIGHT);
        end
    end
end

function MOGUBar_Toggle(enable)
    if (enable == 1) then
        if (not MOGUBar_ENABLED) then
            MOGUBar_UpdateAllBars();
            local page = GetActionBarPage();
            local new_page_offset;
            if (page == 1) then
                new_page_offset = 1;
            else
                new_page_offset = -1;
            end
            ChangeActionBarPage(page + new_page_offset);
            ChangeActionBarPage(page);
            MOGUBar_ENABLED = 1;
        end
    else
        if (MOGUBar_ENABLED) then
            for i = 1, U1BAR_MAX_BARS, 1 do
                local thisBar2 = getglobal("U1BAR" .. i);
                if (thisBar2) then
                    MOGUBar_HideBar(nil, thisBar2);
                end
                MOGUBar_TogglePartyFrame();
                MOGUBar_ToggleDurabilityFrame();
            end
            MOGUBar_ENABLED = nil;
        end
    end
end

function MOGU_DelayCall(MOGU_c31af5fd9021206e921af3d99e5a90af, MOGU_fa0e20b884d24b5fee3e57d9608679e2, ...)
    if (not MOGUFramecallroutine) then
        MOGUFramecallroutine = {};
    end
    local MOGU_2e00ffac12aadb3a1fd865993ec505b9 = {};
    local MOGU_7739b813d90aed43ab9d0eb84ec1c1ae = { ... };
    MOGU_2e00ffac12aadb3a1fd865993ec505b9["func"] = MOGU_c31af5fd9021206e921af3d99e5a90af;
    MOGU_2e00ffac12aadb3a1fd865993ec505b9["delay"] = MOGU_fa0e20b884d24b5fee3e57d9608679e2;
    MOGU_2e00ffac12aadb3a1fd865993ec505b9["lastUpdate"] = 0;
    MOGU_2e00ffac12aadb3a1fd865993ec505b9.arg = MOGU_7739b813d90aed43ab9d0eb84ec1c1ae;
    table.insert(MOGUFramecallroutine, MOGU_2e00ffac12aadb3a1fd865993ec505b9);
end

mehide = CreateFrame("Frame") --缩放在离开3秒后消失
mehide:SetScript("OnUpdate", function(this)
    if MOGUBarOpacitySlider.Leave == 1 then
        gettime = gettime or GetTime()
    else
        gettime = GetTime()
    end
    if (GetTime() - gettime > 1) then
        MOGUBarOpacitySlider:Hide();
        MOGUBarOpacitySlider.Leave = nil
    end
end)
function MOGUBar_ToggleShowGrid(switch)
    if (switch) then
        MOGUBar_SHOW_GRID = true;
        for ii = 1, U1BAR_MAX_BARS, 1 do
            local thisBar2 = getglobal("U1BAR" .. ii);
            if (thisBar2 and thisBar2:IsVisible()) then
                for jj = 1, MOGUBar_MAX_BUTTONS, 1 do
                    local btn = getglobal(thisBar2:GetName() .. "AB" .. jj);
                    MOGUActionButton_ShowGrid(btn);
                    btn:Update();
                end
            end
        end
    else
        MOGUBar_SHOW_GRID = false;
        for barid = 1, U1BAR_MAX_BARS, 1 do
            local bar = getglobal("U1BAR" .. barid);
            if (bar and bar:IsVisible()) then
                for id = 1, MOGUBar_MAX_BUTTONS, 1 do
                    local btn = getglobal(bar:GetName() .. "AB" .. id);
                    MOGUActionButton_HideGrid(btn);
                    btn:Update();
                end
            end
        end
    end
end

function MOGUBarFrame_OnLoad(self)
    self:SetClampedToScreen(true);
end

function MOGUBar_TabDropDownInitialize(frame, level)
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_WINDOWS;
    MOGUBar_info.isTitle = 1;
    MOGUBar_info.notCheckable = 1;
    UIDropDownMenu_AddButton(MOGUBar_info);
    MOGUBar_info = {};
    local currBar = frame:GetParent():GetParent();
    if (currBar and currBar.isLocked) then
        MOGUBar_info.text = MOGUBAR_UNLOCK_BAR;
    else
        MOGUBar_info.text = MOGUBAR_LOCK_BAR;
    end
    MOGUBar_info.func = MOGUBar_SetLock;
    UIDropDownMenu_AddButton(MOGUBar_info);
    if (currBar and currBar.minimized) then
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_RESTORE_BAR;
        MOGUBar_info.func = MOGUBar_ExpandBar;
        UIDropDownMenu_AddButton(MOGUBar_info);
    else
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_MINIMIZE_BAR;
        MOGUBar_info.func = MOGUBar_CollapseBar;
        UIDropDownMenu_AddButton(MOGUBar_info);
    end
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_RESIZE;
    MOGUBar_info.func = MOGUBar_ScaleBar;
    UIDropDownMenu_AddButton(MOGUBar_info);
    if (MOGUBar_GetNextBarID() > 1) then
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_CLOSE_BAR;
        MOGUBar_info.func = function()
            MOGUBar_HideBar(currBar)
            --StaticPopup_Show("CLOSE_BAR", nil, nil, currBar);
        end;
        UIDropDownMenu_AddButton(MOGUBar_info);
    end
    if (currBar and not currBar.minimized) then
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_ARRANGEMENT;
        MOGUBar_info.isTitle = 1;
        MOGUBar_info.notCheckable = 1;
        UIDropDownMenu_AddButton(MOGUBar_info);
        if (currBar.arrangement ~= "horizontal") then
            MOGUBar_info = {};
            MOGUBar_info.text = MOGUBAR_ARRANGEMENT_HORIZONTAL;
            MOGUBar_info.func = MOGUBar_53a0a7c289244b633760f09361be7083;
            UIDropDownMenu_AddButton(MOGUBar_info);
        end
        if (currBar.arrangement ~= "vertical") then
            MOGUBar_info = {};
            MOGUBar_info.text = MOGUBAR_ARRANGEMENT_VERTICAL;
            MOGUBar_info.func = MOGUBar_c1a00077417bf72984105bce5124b1e3;
            UIDropDownMenu_AddButton(MOGUBar_info);
        end
        if (currBar.arrangement ~= "funny") then
            MOGUBar_info = {};
            MOGUBar_info.text = MOGUBAR_ARRANGEMENT_FUNNY;
            MOGUBar_info.func = U1BAR_AlignFunny;
            UIDropDownMenu_AddButton(MOGUBar_info);
        end
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_BUTTONS;
        MOGUBar_info.isTitle = 1;
        MOGUBar_info.notCheckable = 1;
        UIDropDownMenu_AddButton(MOGUBar_info);
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_INCREASE_BUTTON;
        MOGUBar_info.func = U1BAR_IncreaseButton;
        MOGUBar_info.disabled = 1;
        if (MOGUBar_GetNumButtonsShown(currBar) < MOGUBar_MAX_BUTTONS) then
            MOGUBar_info.disabled = nil;
        end
        UIDropDownMenu_AddButton(MOGUBar_info);
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_DECREASE_BUTTON;
        MOGUBar_info.func = U1BAR_DecreaseButton;
        MOGUBar_info.disabled = 1;
        if (MOGUBar_GetNumButtonsShown(currBar) > MOGUBar_MIN_BUTTONS) then
            MOGUBar_info.disabled = nil;
        end
        UIDropDownMenu_AddButton(MOGUBar_info);
    end
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_OTHERS;
    MOGUBar_info.isTitle = 1;
    MOGUBar_info.notCheckable = 1;
    UIDropDownMenu_AddButton(MOGUBar_info);
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_CREATE_NEW_BAR;
    MOGUBar_info.func = U1BAR_CreateNewActionBar;
    if (MOGUBar_GetNextBarID() >= U1BAR_MAX_BARS) then
        MOGUBar_info.disabled = 1;
    end
    UIDropDownMenu_AddButton(MOGUBar_info);
    MOGUBar_info = {};
    MOGUBar_info.text = "打开控制台设置";
    MOGUBar_info.func = function()
        if UUI then
            UUI.OpenToAddon("ExtraActionBar", true)
        end
    end;
    UIDropDownMenu_AddButton(MOGUBar_info);
    --[[
    local info = {}
    info.text = "关闭标题头"
    info.func = function() _G[thisBar2:GetName().."Tab"]:Hide() DEFAULT_CHAT_FRAME:AddMessage("额外动作条标题头已关闭，如需开启，请在控制台中设置") end
    UIDropDownMenu_AddButton(info);
    ]]
end

function MOGUBar_SetLock()
    local bar = U1BAR_FindBar();
    if (bar) then
        if (bar.isLocked) then
            bar.isLocked = nil;
        else
            bar.isLocked = 1;
        end
        MOGUBar_SaveSettings(bar);
    end
end

function U1BAR_FindBar(self)
    local bar = getglobal("U1BAR" .. UIDropDownMenu_GetCurrentDropDown():GetParent():GetParent():GetID());
    if (not bar) then
        bar = getglobal("U1BAR" .. self:GetParent():GetID());
    end
    return bar;
end

local map = { vertical = "horizontal", horizontal = "funny", funny = "vertical" }

function MOGUBarTab_OnClick(self, button)
    if (button == "RightButton" and not InCombatLockdown()) then
        if (GetScreenWidth() - self:GetRight() < MOGUBar_TAB_DROPDOWN_WIDTH - 40) then
            ToggleDropDownMenu(1, nil, getglobal(self:GetName() .. "DropDown"), self:GetName(), 10 - MOGUBar_TAB_DROPDOWN_WIDTH, 3);
        else
            ToggleDropDownMenu(1, nil, getglobal(self:GetName() .. "DropDown"), self:GetName(), 10, 3);
        end
        PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON);
        return ;
    elseif (button == "LeftButton" and not InCombatLockdown()) then
        if IsModifierKeyDown() then
            U1BAR_SetAlign(self:GetParent(), map[self:GetParent().arrangement or "funny"])
        end
    end

    CloseDropDownMenus();
end

function MOGUBarDropDown_OnLoad(self)
    UIDropDownMenu_Initialize(self, MOGUBar_TabDropDownInitialize, "MENU");
    UIDropDownMenu_SetButtonWidth(self, 50);
    UIDropDownMenu_SetWidth(self, 50);
end

function U1BAR_IncreaseButton(self, bar)
    local thisBar = bar or U1BAR_FindBar(self);
    if (thisBar) then
        for ii = 1, MOGUBar_MAX_BUTTONS, 1 do
            local showGrid = getglobal(thisBar:GetName() .. "AB" .. ii);
            if (showGrid and not showGrid.forceShow) then
                showGrid.forceShow = true;
                MOGUActionButton_ShowGrid(showGrid);
            end
            showGrid.grid_timestamp = 0;
            if (showGrid and showGrid.hide) then
                MOGUBar_ShowButton(showGrid);
                local db = MOGUBar_InfoForPlayer();
                if (db[thisBar:GetName()]) then
                    db[thisBar:GetName()].buttonCount = ii;
                end
                MOGUBar_PageUpAndPageDown();
                break ;
            end
        end
        if (thisBar.arrangement == "funny") then
            U1BAR_SetAlign(thisBar, "funny");
        end
    end
end

function U1BAR_DecreaseButton(self, bar)
    local thisBar1 = bar or U1BAR_FindBar(self);
    if (thisBar1) then
        for ii = 1, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(thisBar1:GetName() .. "AB" .. ii);
            if (btn and not btn.forceShow) then
                btn.forceShow = true;
                MOGUActionButton_ShowGrid(btn);
            end
            btn.grid_timestamp = 0;
        end
        for ii = MOGUBar_MAX_BUTTONS, 2, -1 do
            local btn = getglobal(thisBar1:GetName() .. "AB" .. ii);
            if (btn and not btn.hide) then
                MOGUBar_HideButton(btn);
                local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_InfoForPlayer();
                if (MOGUBar_bba564c01b4659989f8d87879ec9fe5e[thisBar1:GetName()]) then
                    MOGUBar_bba564c01b4659989f8d87879ec9fe5e[thisBar1:GetName()].buttonCount = ii - 1;
                end
                break ;
            end
        end
        if (thisBar1.arrangement == "funny") then
            U1BAR_SetAlign(thisBar1, "funny");
        end
    end
end

function U1BAR_SetAlign(thisBar2, direction)
    if (direction == "horizontal") then
        for ii = 2, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(thisBar2:GetName() .. "AB" .. ii);
            local last = thisBar2:GetName() .. "AB" .. (ii - 1);
            btn:ClearAllPoints();
            btn:SetPoint("LEFT", last, "RIGHT", 6, 0);
        end
        thisBar2.arrangement = "horizontal";
    elseif (direction == "vertical") then
        for ii = 2, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(thisBar2:GetName() .. "AB" .. ii);
            local last = thisBar2:GetName() .. "AB" .. (ii - 1);
            btn:ClearAllPoints();
            btn:SetPoint("TOP", last, "BOTTOM", 0, -6);
        end
        thisBar2.arrangement = "vertical";
    elseif (direction == "funny") then
        local numShown = MOGUBar_GetNumButtonsShown(thisBar2);
        MOGUBar_FunnyLayout(thisBar2, numShown);
        thisBar2.arrangement = "funny";
    end
    MOGUBar_SaveSettings(thisBar2);
end

function MOGUBar_SetButtonPoint(thisBar2, id, point, parentName, relPoint, x, y)
    local btn = getglobal(thisBar2:GetName() .. "AB" .. id);
    btn:ClearAllPoints();
    btn:SetPoint(point, parentName, relPoint, x, y);
    return btn;
end

function MOGUBar_FunnyLayout(thisBar2, MOGUBar_3f50417fb16be9b1078eb68d24fa9c26)
    if (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 1) then
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 2) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOP", firstButton:GetName(), "BOTTOM", 0, -6);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 3) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "TOPLEFT", firstButton:GetName(), "BOTTOM", 3, -6);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 4) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "TOPLEFT", firstButton:GetName(), "BOTTOM", 3, -6);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOP", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOMRIGHT", 3, -6);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 5) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOPRIGHT", firstButton:GetName(), "BOTTOMLEFT", -3, -6);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "TOP", firstButton:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOPLEFT", firstButton:GetName(), "BOTTOMRIGHT", 3, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "TOP", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "BOTTOM", 0, -6);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 6) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOPRIGHT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 7) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "LEFT", firstButton:GetName(), "RIGHT", 6, 0);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "LEFT", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "RIGHT", 6, 0);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "TOPLEFT", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "BOTTOM", 3, -6);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 8) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOPRIGHT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "TOPLEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 3, -6);
        local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_SetButtonPoint(thisBar2, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 9) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "LEFT", firstButton:GetName(), "RIGHT", 6, 0);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOP", firstButton:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_SetButtonPoint(thisBar2, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
        local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_SetButtonPoint(thisBar2, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 10) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "LEFT", firstButton:GetName(), "RIGHT", 6, 0);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOPRIGHT", firstButton:GetName(), "BOTTOM", -3, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
        local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_SetButtonPoint(thisBar2, 8, "TOPLEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 3, -6);
        local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_SetButtonPoint(thisBar2, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0);
        local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_SetButtonPoint(thisBar2, 10, "LEFT", MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 11) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "LEFT", firstButton:GetName(), "RIGHT", 6, 0);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOP", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "RIGHT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "LEFT", -6, 0);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
        local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_SetButtonPoint(thisBar2, 8, "TOP", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_SetButtonPoint(thisBar2, 10, "TOP", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_SetButtonPoint(thisBar2, 9, "RIGHT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "LEFT", -6, 0);
        local MOGUBar_527e9de525b5c4635499afc0f0f44840 = MOGUBar_SetButtonPoint(thisBar2, 11, "LEFT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "RIGHT", 6, 0);
    elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 12) then
        local firstButton = getglobal(thisBar2:GetName() .. "AB" .. 1);
        local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_SetButtonPoint(thisBar2, 2, "LEFT", firstButton:GetName(), "RIGHT", 6, 0);
        local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_SetButtonPoint(thisBar2, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
        local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_SetButtonPoint(thisBar2, 4, "TOP", firstButton:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_SetButtonPoint(thisBar2, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
        local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_SetButtonPoint(thisBar2, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
        local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_SetButtonPoint(thisBar2, 7, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_SetButtonPoint(thisBar2, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
        local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_SetButtonPoint(thisBar2, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0);
        local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_SetButtonPoint(thisBar2, 10, "TOP", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "BOTTOM", 0, -6);
        local MOGUBar_527e9de525b5c4635499afc0f0f44840 = MOGUBar_SetButtonPoint(thisBar2, 11, "LEFT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "RIGHT", 6, 0);
        local MOGUBar_428c0e6168551556f099cada47165338 = MOGUBar_SetButtonPoint(thisBar2, 12, "LEFT", MOGUBar_527e9de525b5c4635499afc0f0f44840:GetName(), "RIGHT", 6, 0);
    end
end

function MOGUBar_53a0a7c289244b633760f09361be7083(self)
    local thisBar1 = U1BAR_FindBar(self);
    U1BAR_SetAlign(thisBar1, "horizontal");
end

function MOGUBar_c1a00077417bf72984105bce5124b1e3(self)
    local thisBar1 = U1BAR_FindBar(self);
    U1BAR_SetAlign(thisBar1, "vertical");
end

function U1BAR_AlignFunny(self)
    local thisBar1 = U1BAR_FindBar(self);
    U1BAR_SetAlign(thisBar1, "funny");
end

function MOGUBar_GetNumButtonsShown(thisBar2)
    for ii = 1, MOGUBar_MAX_BUTTONS, 1 do
        local btn = getglobal(thisBar2:GetName() .. "AB" .. ii);
        if (btn and btn.hide) then
            return ii - 1;
        end
    end
    return MOGUBar_MAX_BUTTONS;
end

function MOGUBar_GetNextBarID()
    local nextBarID = 0;
    for i = 1, U1BAR_MAX_BARS, 1 do
        local bar = getglobal("U1BAR" .. i);
        if (bar and bar:IsVisible()) then
            nextBarID = nextBarID + 1;
        end
    end
    return nextBarID;
end

function MOGUActionButton_OnEvent(self, event, ...)
    if (event == "ACTIONBAR_SHOWGRID") then
        MOGUActionButton_ShowGrid(self);
    elseif (event == "ACTIONBAR_HIDEGRID") then
        MOGUActionButton_HideGrid(self);
    else
        U1BAR_ActionButton_OnEvent(self, event, ...);
    end
end

function MOGUActionButton_ShowGrid(button)
    if (not InCombatLockdown()) then
        button:SetAttribute("showgrid", button:GetAttribute("showgrid") + 1);
        MOGUActionButton_UpdateGrid(button);
    end
end

function MOGUActionButton_HideGrid(button)
    if (not InCombatLockdown()) then
        local MOGUBar_7c92a639261d1e1015d3449a288a5933 = button:GetAttribute("showgrid");
        MOGUBar_7c92a639261d1e1015d3449a288a5933 = MOGUBar_7c92a639261d1e1015d3449a288a5933 - 1;
        if (button.forceShow) then
            button.forceShow = nil;
            MOGUBar_7c92a639261d1e1015d3449a288a5933 = MOGUBar_7c92a639261d1e1015d3449a288a5933 - 1;
        end
        if (MOGUBar_7c92a639261d1e1015d3449a288a5933 < 0) then
            MOGUBar_7c92a639261d1e1015d3449a288a5933 = 0;
        end
        button:SetAttribute("showgrid", MOGUBar_7c92a639261d1e1015d3449a288a5933);
        MOGUActionButton_UpdateGrid(button);
    end
end

function MOGUActionButton_UpdateGrid(button)
    if (button:GetAttribute("statehidden")) then
        button:Hide();
    elseif (HasAction(button:GetAttribute("action"))) then
        button:Show();
    elseif ((button:GetAttribute("showgrid") or 0) >= 1) then
        button:Show();
    else
        button:Hide();
    end
end

---靠，仅仅是用来新创建的按钮显示5秒空白的...
CoreScheduleTimer(true, 2, function()
    for barId = 1, 10 do
        local bar = _G[format("U1BAR%d", barId)]
        if bar and bar:IsVisible() then
            for i = 1, MOGUBar_MAX_BUTTONS, 1 do
                local btn = getglobal(bar:GetName() .. "AB" .. i);
                if (btn.forceShow) then
                    if (not btn.grid_timestamp) then
                        btn.grid_timestamp = 0;
                    end
                    btn.grid_timestamp = btn.grid_timestamp + 2;
                    if (btn.grid_timestamp > 5) then
                        btn.forceShow = nil;
                        btn:SetAttribute("showgrid", btn:GetAttribute("showgrid") - 1);
                    end
                    MOGUActionButton_UpdateGrid(btn);
                else
                    btn.grid_timestamp = 0;
                end
                if (not btn.bookFrameShow and SpellBookFrame:IsShown()) then
                    MOGUActionButton_ShowGrid(btn);
                    btn.bookFrameShow = true;
                elseif (btn.bookFrameShow and not SpellBookFrame:IsShown()) then
                    MOGUActionButton_HideGrid(btn);
                    btn.bookFrameShow = false;
                end
            end
        end
    end
end)

function MOGUBar_ShowButton(btn)
    local tex = getglobal(btn:GetName() .. "NormalTexture");
    btn.hide = nil;
    tex:SetAlpha(0.3);
    btn:SetAttribute("statehidden", nil);
    MOGUActionButton_UpdateGrid(btn);
    return true;
end

function MOGUBar_HideButton(btn)
    btn.hide = 1;
    btn:SetAttribute("statehidden", true);
    MOGUActionButton_UpdateGrid(btn);
end

function U1BAR_SetPos(bar)
    bar:ClearAllPoints();
    for i, v in ipairs(U1BAR_ORDER) do
        if bar:GetName() == "U1BAR" .. v then
            return bar:SetPoint("CENTER", "UIParent", "CENTER", 200 + 50 * (i - 1), 200);
        end
    end
    bar:SetPoint("CENTER", "UIParent", "CENTER", 0, 60);
end

function MOGUBar_SetAllBarPos()
    for i = 1, U1BAR_MAX_BARS, 1 do
        local bar = getglobal("U1BAR" .. i);
        if (bar and bar:IsVisible()) then
            U1BAR_SetPos(bar);
        end
    end
end

function MOGUBar_9d9ae0ea8d213958f106e815d1c56b12()
end

function U1BAR_CreateBar(name)
    local bar = CreateFrame("Frame", name, UIParent, "MOGUBarFrameTemplate");
    if CoreHideOnPetBattle then
        CoreHideOnPetBattle(bar)
    end
    U1BAR_SetPos(bar);
    AddButtonToGroup(name .. "AB%d", 12, "额外动作条" .. name)
    return bar;
end

function MOGUBar_HideBarButtons(bar)
    bar:Hide();
    for i = 1, MOGUBar_MAX_BUTTONS, 1 do
        local btn = getglobal(bar:GetName() .. "AB" .. i);
        MOGUBar_HideButton(btn);
    end
end

function MOGUBar_FindOrCreateNewBar(name)
    local nextBarID = MOGUBar_GetNextBarID();
    if (nextBarID > U1BAR_MAX_BARS) then
        return ;
    end
    local bar;
    if (name) then
        local found, _, barId = string.find(name, "^U1BAR(%d+)$");
        bar = getglobal(name);
        if (bar and found) then
            bar:Show();
            return bar;
        else
            bar = U1BAR_CreateBar(name);
            bar:SetScale(U1BAR_DEFAULT_SCALE)
            bar:SetID(barId);
            local titile = getglobal(bar:GetName() .. "TabTitle");
            titile:SetText(barId);
            bar:Show();
            return bar;
        end
    end
    for i = 1, U1BAR_MAX_BARS, 1 do
        bar = getglobal("U1BAR" .. i);
        if (bar and not bar:IsVisible()) then
            bar:Show();
            return bar;
        end
    end
    for _, i in ipairs(U1BAR_ORDER) do
        bar = getglobal("U1BAR" .. i);
        if (not bar) then
            bar = U1BAR_CreateBar("U1BAR" .. i);
            bar:SetID(i);
            bar:SetScale(U1BAR_DEFAULT_SCALE)
            local title = getglobal(bar:GetName() .. "TabTitle");
            title:SetText(i);
            bar:Show();
            return bar;
        end
    end
end

function U1BAR_GetActionBarStartAction(barID)
    --1-10不变, 1:9*12, 10:0*12, 11-12*12, 12-13*12, 13-14*12
    if barID <= 10 then
        return (10 - barID) * MOGUBar_MAX_BUTTONS
    else
        return (barID + 1) * MOGUBar_MAX_BUTTONS
    end
end

function U1BAR_CreateNewActionBar()
    local bar = MOGUBar_FindOrCreateNewBar();
    local hasAnyButtons;
    if (bar) then
        local titile = getglobal(bar:GetName() .. "TabTitle");
        titile:SetText(bar:GetID());
        --MHDB["mgbar"..thisBar2:GetID()] = true
        bar.isLocked = nil;
        bar.minimized = nil;
        bar.sonID = 1;
        for ii = 1, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(bar:GetName() .. "AB" .. ii);
            local action = bar.sonID + U1BAR_GetActionBarStartAction(bar:GetID());
            --btn:SetScript("OnEvent", MOGUActionButton_OnEvent);
            btn:SetAttribute("action", action);
            btn.bookFrameShow = nil;
            MOGUBar_ShowButton(btn);
            bar.sonID = bar.sonID + 1;
            hasAnyButtons = true;
            if (MOGUBar_SHOW_GRID) then
                btn:SetAttribute("showgrid", 1);
            else
                btn:SetAttribute("showgrid", 0);
            end
            btn.forceShow = true;
            MOGUActionButton_ShowGrid(btn);
            MOGUActionButton_UpdateGrid(btn);
        end
        for i = U1BAR_DEFAULT_BTNS + 1, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(bar:GetName() .. "AB" .. i);
            MOGUBar_HideButton(btn);
        end
        U1BAR_SetAlign(bar, "vertical");
        MOGUBar_SaveSettings(bar);
        if (not hasAnyButtons) then
            MOGUBar_HideBar(bar);
        end
        MOGUBar_PageUpAndPageDown();
    end
end

function MOGUBar_HideBar(self, thisBar2)
    local thisBar1;
    if (thisBar2) then
        thisBar1 = thisBar2;
    else
        thisBar1 = U1BAR_FindBar(self);
    end
    MOGUBar_HideBarButtons(thisBar1);
    MOGUBar_SaveSettings(thisBar1);
end

function MOGUBar_InfoForPlayer()
    local player = UnitName("Player");
    if (not player or player == UNKNOWNOBJECT or player == UKNOWNBEING) then
        return nil;
    end
    if (not MOGUBar_Info[player]) then
        MOGUBar_Info[player] = {
            U1BAR1 = {
                buttonCount = 7,
                arrangement = "funny",
                region = { top = GetScreenHeight() / 2, left = GetScreenWidth() / 2 + 225, }
            }
        };
    end
    return MOGUBar_Info[player];
end

function MOGUBar_UpdateBarPos(thisBar2)
    if (thisBar2 and thisBar2:IsVisible()) then
        local db = MOGUBar_InfoForPlayer();
        local MOGUBar_info = db[thisBar2:GetName()];
        if (MOGUBar_info and MOGUBar_info.region) then
            thisBar2.arrangement = MOGUBar_info.arrangement;
            thisBar2.isLocked = MOGUBar_info.isLocked;
            thisBar2.minimized = MOGUBar_info.minimized;
            thisBar2.scale = MOGUBar_info.scale;
            thisBar2.togglePartyFrame = MOGUBar_info.togglePartyFrame;
            thisBar2.toggleDurabilityFrame = MOGUBar_info.toggleDurabilityFrame;
            if (thisBar2.scale) then
                BScale:SetScale(thisBar2, thisBar2.scale);
            end
            thisBar2:ClearAllPoints();
            thisBar2:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", MOGUBar_info.region.left, MOGUBar_info.region.top);
            U1BAR_SetAlign(thisBar2, MOGUBar_info.arrangement);
            if (thisBar2.togglePartyFrame) then
                MOGUBar_TogglePartyFrame(1);
            end
            if (thisBar2.toggleDurabilityFrame) then
                MOGUBar_ToggleDurabilityFrame(1);
            end
        end
    end
end

function MOGUBar_UpdateAllBars()
    local db = MOGUBar_InfoForPlayer();
    if (not db) then
        MOGU_DelayCall(MOGUBar_UpdateAllBars, 2);
        return ;
    end
    local showAtLeastOneBar = nil;
    for i = 1, U1BAR_MAX_BARS, 1 do
        local barName = "U1BAR" .. i;
        if (db[barName]) then
            local bar = getglobal(barName);
            if (not bar) then
                bar = MOGUBar_FindOrCreateNewBar(barName);
            end
            bar.keyframe = CreateFrame("Frame", nil, UIParent);
            bar.sonID = 1;
            local numButtons = db[barName].buttonCount;
            if (not numButtons) then
                numButtons = MOGUBar_MAX_BUTTONS;
            end
            for j = 1, MOGUBar_MAX_BUTTONS, 1 do
                local btn = getglobal(bar:GetName() .. "AB" .. j);
                local action = bar.sonID + U1BAR_GetActionBarStartAction(bar:GetID());
                btn:SetAttribute("action", action);
                bar.sonID = bar.sonID + 1;
                --btn:SetScript("OnEvent", MOGUActionButton_OnEvent);
                if (MOGUBar_SHOW_GRID) then
                    btn:SetAttribute("showgrid", 1);
                else
                    btn:SetAttribute("showgrid", 0);
                end
            end
            for U1B_i = 1, numButtons, 1 do
                local btn = getglobal(bar:GetName() .. "AB" .. U1B_i);
                MOGUBar_ShowButton(btn);
            end
            for U1B_i = numButtons + 1, MOGUBar_MAX_BUTTONS, 1 do
                local btn = getglobal(bar:GetName() .. "AB" .. U1B_i);
                MOGUBar_HideButton(btn);
            end
            for U1B_i = 1, MOGUBar_MAX_BUTTONS, 1 do
                local btn = getglobal(bar:GetName() .. "AB" .. U1B_i);
                MOGUActionButton_UpdateGrid(btn);
            end
            MOGUBar_UpdateBarPos(bar);
            local titile = getglobal(bar:GetName() .. "TabTitle");
            titile:SetText(bar:GetID());
            if (bar.minimized) then
                MOGUBar_CollapseBar(bar);
            end
            showAtLeastOneBar = true;
        end
    end
    if (not showAtLeastOneBar) then
        U1BAR_CreateNewActionBar();
    end
end

function MOGUBar_d7613b704685de240b505fbb41cef8ca(MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3, MOGUBar_eed0be1c2d5f65980b06b5094460c3c5)
    if (MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3 == "Error") then
        ChatFrame1:AddMessage(MOGUBar_eed0be1c2d5f65980b06b5094460c3c5, 1.0, 0.0, 0.0);
    elseif (MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3 == "Info") then
        ChatFrame1:AddMessage(MOGUBar_eed0be1c2d5f65980b06b5094460c3c5, 1.0, 1.0, 0.0);
    end
end

function MOGUBar_GetBarRegion(bar)
    local newdb = {};
    newdb.left = bar:GetLeft();
    newdb.right = bar:GetRight();
    newdb.top = bar:GetTop();
    newdb.bottom = bar:GetBottom();
    if (not newdb.left or not newdb.right or not newdb.top or not newdb.bottom) then
        return nil;
    end
    newdb.left = math.floor(newdb.left + 0.5);
    newdb.right = math.floor(newdb.right + 0.5);
    newdb.top = math.floor(newdb.top + 0.5);
    newdb.bottom = math.floor(newdb.bottom + 0.5);
    return newdb;
end

function MOGUBar_SaveSettings(bar)
    local db = MOGUBar_InfoForPlayer();
    if (bar and db) then
        if (bar:IsVisible()) then
            local MOGUBar_info = {};
            local region = MOGUBar_GetBarRegion(bar);
            MOGUBar_info.region = region;
            MOGUBar_info.arrangement = bar.arrangement;
            MOGUBar_info.isLocked = bar.isLocked;
            MOGUBar_info.minimized = bar.minimized;
            MOGUBar_info.scale = bar.scale;
            MOGUBar_info.togglePartyFrame = bar.togglePartyFrame;
            MOGUBar_info.toggleDurabilityFrame = bar.toggleDurabilityFrame;
            MOGUBar_info.buttonCount = MOGUBar_GetNumButtonsShown(bar);
            db[bar:GetName()] = MOGUBar_info;
        else
            db[bar:GetName()] = nil;
        end
    end
end

function MOGUBar_ScaleBar(self)
    local bar = U1BAR_FindBar(self);
    local scale = bar.scale;
    if (not scale) then
        scale = 0.8;
    end
    local tab = getglobal(bar:GetName() .. "Tab");
    local top = tab:GetTop() * tab:GetEffectiveScale();
    local left = tab:GetLeft() * tab:GetEffectiveScale();
    MOGUBarOpacitySlider.frame = nil;
    MOGUBarOpacitySlider:SetAlpha(1);
    MOGUBarOpacitySlider:ClearAllPoints();
    MOGUBarOpacitySlider:SetPoint("TOPRIGHT", tab, "TOPLEFT", -20, 0);
    MOGUBarOpacitySlider:Show();
    MOGUBarOpacitySlider:SetMinMaxValues(50, 150);
    MOGUBarOpacitySlider:SetValueStep(10);
    if (bar.scale) then
        MOGUBarOpacitySlider:SetValue(bar.scale * 100);
    else
        MOGUBarOpacitySlider:SetValue(100);
    end
    MOGUBarOpacitySlider.frame = bar;
end

function MOGUBar_CollapseBar(self)
    local thisBar1 = U1BAR_FindBar(self);
    for i = 1, MOGUBar_MAX_BUTTONS, 1 do
        local btn = getglobal(thisBar1:GetName() .. "AB" .. i);
        if (btn) then
            btn.minimized = 1;
            MOGUBar_HideButton(btn);
        end
    end
    thisBar1.minimized = 1;
    MOGUBar_SaveSettings(thisBar1);
end

function MOGUBar_ExpandBar(self)
    local bar = U1BAR_FindBar(self);
    for id = 1, MOGUBar_MAX_BUTTONS, 1 do
        local btn = getglobal(bar:GetName() .. "AB" .. id);
        if (btn and btn.hide) then
            btn.minimized = nil;
            MOGUBar_ShowButton(btn);
        end
        btn:UpdateState();
        MOGUActionButton_UpdateGrid(btn);
    end
    bar.minimized = nil;
    local db = MOGUBar_InfoForPlayer();
    local MOGUBar_info = db[bar:GetName()];
    U1BAR_SetAlign(bar, MOGUBar_info.arrangement);
    MOGUBar_SaveSettings(bar);
end

function MOGUBar_ToggleDurabilityFrame(enable)
    do
        return
    end
    if (enable) then
        DurabilityFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", -20, 15);
    else
        DurabilityFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", 40, 15);
    end
end

function MOGUBar_TogglePartyFrame(enable)
    do
        return
    end
    if (enable) then
        PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 40, -128);
    else
        PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 10, -128);
    end
end

function MOGUBar_OnMouseDown(self, button)
    if (button ~= "LeftButton" or IsControlKeyDown()) then
        return ;
    end
    local bar = self:GetParent();
    if (not bar.isLocked and not bar.inCombat) then
        bar:StartMoving();
        bar.moving = true;
        MOVING_MOGUBAR = bar;
    end
end

function MOGUBar_OnMouseUp(self, btn)
    local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = self:GetParent();
    if (MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.moving or InCombatLockdown()) then
        MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:StopMovingOrSizing();
        MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.moving = false;
        MOVING_MOGUBAR = nil;
        MOGUBar_SaveSettings(MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a);
    end
end

function MOGUBarTab_OnEnter(self)
    self:GetParent().isFading = nil;
    self:GetParent().locking = true;
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
    GameTooltip:SetText(MOGUBAR_TAB_HELP_TEXT);
    GameTooltip:Show();
end

function MOGUBarTab_OnLeave(self)
    local dropdown = getglobal(self:GetName() .. "DropDown");
    if (UIDropDownMenu_GetCurrentDropDown() ~= dropdown) then
        self:GetParent().locking = nil;
    end
    self:GetParent().lastLeave = GetTime();
    GameTooltip:Hide();
end

function MOGUBarOpacitySlider_OnValueChanged(self, value)
    getglobal(self:GetName() .. "Text"):SetText(math.floor(value) .. "%");
    if (self.frame) then
        BScale:SetScale(self.frame, value / 100);
        self.frame.scale = value / 100;
        MOGUBar_SaveSettings(self.frame);
    end
end

local function MOGUBar_3132bb65521790fe81fb039758b0f1f0()
    if (MOGUBarOpacitySlider.Leave) then
        MOGUBarOpacitySlider:Hide();
    end
end

local function MOGUBar_d4c4d4c5dde2baa01c763775a64361ff()
    if (MOGUBarOpacitySlider.Leave) then
        UICoreFrameFadeIn(MOGUBarOpacitySlider, 0.5, 1, 0);
        MOGU_DelayCall(MOGUBar_3132bb65521790fe81fb039758b0f1f0, 0.5);
    end
end

function MOGUBarOpacitySlider_OnEnter(self)
    MOGUBarOpacitySlider.Leave = nil;
end

function MOGUBarOpacitySlider_OnLeave(self)
    if (MOGUBarOpacitySlider.frame) then
        MOGUBarOpacitySlider.Leave = 1;
    end
    MOGU_DelayCall(MOGUBar_d4c4d4c5dde2baa01c763775a64361ff, 2);
end