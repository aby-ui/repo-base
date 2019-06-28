local Masque = LibStub and LibStub('Masque', true)
local AddButtonToGroup = function(btnname, index, groupname, func)
    if not Masque then return end
    local Group = Masque:Group('额外动作条', groupname)
    for i = 1, index do
        local btn = _G[format(btnname, i)]
        if(btn) then
            Group:AddButton(btn)
            if(func) then
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
else MOGUBAR_WINDOWS = "Window"; MOGUBAR_UNLOCK_BAR = "Unlock"; MOGUBAR_LOCK_BAR = "Lock"; MOGUBAR_MINIMIZE_BAR = "Minimize"; MOGUBAR_RESTORE_BAR = "Restore"; MOGUBAR_RESIZE = "Resize Bar"; MOGUBAR_CLOSE_BAR = "Close"; MOGUBAR_ARRANGEMENT = "Arrangement"; MOGUBAR_ARRANGEMENT_HORIZONTAL = "Horizontal arrangement"; MOGUBAR_ARRANGEMENT_VERTICAL = "Vertical arragnement"; MOGUBAR_ARRANGEMENT_FUNNY = "Funny arrangement"; MOGUBAR_BUTTONS = "Button"; MOGUBAR_INCREASE_BUTTON = "Increase button"; MOGUBAR_DECREASE_BUTTON = "Decrease button"; MOGUBAR_OTHERS = "Other"; MOGUBAR_CREATE_NEW_BAR = "Create new bar"; MOGUBAR_MESSAGE_ERROR_NO_ENOUGH_ID = "No more button could be arragned."; MOGUBAR_CLOSE_BAR_INFO = "All button information you want to close will be lost, do you really want to do?";
MOGUBAR_ENABLE = "Enable MOGU Bar"; MOGUBAR_RESET = "Key Binding"; MOGUBAR_HIDE_TAB = "Hide action bar headers"; MOGUBAR_HIDE_GRID = "Hide unused action buttons"; MOGUBAR_TAB_HELP_TEXT = "Hold mouse left button to move bar,\nRight click to popup menu.";
end
MOGUBar_MAX_BUTTONS = 12;
MOGUBar_13a3c67ee59d2b4a6a40c57847c95a42 = 1;
U1BAR_DEFAULT_BTNS = 10;
MOGUBar_72be2d2fba590211fe0f29e1a9832788 = 124;
U1BAR_MAX_BARS = 10;
MOGUBar_cbb2b67bbf31ebf16da60ddaa3a897b6 = 2;
MOGUBar_1107aed32aff112f82fac829c22d1591 = 0.5;
MOGUBar_Info = {};
MOGUBar_3062be796f02383eadecd6c8e48ebc4b = nil;
MOGUBar_f97a2a7812f94d4bb34fcf1f04f5711e = nil;
StaticPopupDialogs["CLOSE_BAR"] = {preferredIndex = 3, text = MOGUBAR_CLOSE_BAR_INFO, button1 = TEXT(YES), button2 = TEXT(NO), OnAccept = function(self, data) MOGUBar_503ed091c79944be5b7079c0602f8146(data); end, OnCancel = function(self, MOGUBar_3a41fa2f33897b6c190993d845e6b222) end, showAlert = 1, timeout = 0, whileDead = 1};
function MOGUBarButton_OnLoad(self)
    self.buttonType = "MOGUBarActionButton";
    --copy from ActionButton_OnLoad, remove ActionBarButtonEventsFrame_RegisterFrame
	self.flashing = 0;
	self.flashtime = 0;
	self:SetAttribute("showgrid", 0);
	self:SetAttribute("type", "action");
	self:SetAttribute("checkselfcast", true);
	self:SetAttribute("checkfocuscast", true);
	self:SetAttribute("useparent-unit", true);
	self:SetAttribute("useparent-actionpage", true);
	self:RegisterForDrag("LeftButton", "RightButton");
	self:RegisterForClicks("AnyUp");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ACTIONBAR_SHOWGRID");
	self:RegisterEvent("ACTIONBAR_HIDEGRID");
	self:RegisterEvent("ACTIONBAR_PAGE_CHANGED");
	self:RegisterEvent("ACTIONBAR_SLOT_CHANGED");
	self:RegisterEvent("UPDATE_BINDINGS");
	self:RegisterEvent("UPDATE_SHAPESHIFT_FORM");

    self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");

	--ActionBarButtonEventsFrame_RegisterFrame(self); --SetActionUIButton(self, action, self.cooldown);
	ActionButton_UpdateAction(self);
	ActionButton_UpdateHotkeys(self, self.buttonType);
end

local BScale = BLibrary("BScale");
local BEvent = BLibrary("BEvent");
function MOGUBar_bceab2d4ca6bac097d8aac711b117e68()
    ActionBar_PageUp();
    ActionBar_PageDown();
end

function MOGU_ShowKeyBindingFrame(MOGU_7739b813d90aed43ab9d0eb84ec1c1ae)
    if (MOGU_7739b813d90aed43ab9d0eb84ec1c1ae == nil) then
        KeyBindingFrame_LoadUI();
        ShowUIPanel(KeyBindingFrame);
        return;
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

function MOGUBar_Toggle(MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae)
    if (MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae == 1) then
        if (not MOGUBar_3062be796f02383eadecd6c8e48ebc4b) then
            MOGUBar_25b1d2fe6e14021d74f8def30b5d48bc();
            local page = GetActionBarPage();
            local new_page_offset;
            if (page == 1) then
                new_page_offset = 1;
            else new_page_offset = -1;
            end
            ChangeActionBarPage(page + new_page_offset);
            ChangeActionBarPage(page);
            MOGUBar_3062be796f02383eadecd6c8e48ebc4b = 1;
        end
    else
        if (MOGUBar_3062be796f02383eadecd6c8e48ebc4b) then
            for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do
                local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
                if (MOGUBar_69072c73fde2ed407f863929fd1e7483) then
                    MOGUBar_503ed091c79944be5b7079c0602f8146(nil, MOGUBar_69072c73fde2ed407f863929fd1e7483);
                end
                MOGUBar_188692f2774e57694ab1a6c14c3e21c9(); MOGUBar_808a4bd835bd3741099c5cfacb463a5c();
            end
            MOGUBar_3062be796f02383eadecd6c8e48ebc4b = nil;
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
    else gettime = GetTime()
    end
    if (GetTime() - gettime > 1) then
        MOGUBarOpacitySlider:Hide();
        MOGUBarOpacitySlider.Leave = nil
    end
end)
function MOGUBar_ToggleShowGrid(switch)
    local MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f, MOGUBar_5e57ab95c762a48d9a126b104db1056f;
    if (switch) then
        MOGUBar_f97a2a7812f94d4bb34fcf1f04f5711e = true;
        for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do
            local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
            if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then
                for MOGUBar_5e57ab95c762a48d9a126b104db1056f = 1, MOGUBar_MAX_BUTTONS, 1 do
                    local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_5e57ab95c762a48d9a126b104db1056f);
                    MOGUActionButton_ShowGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5);
                    ActionButton_Update(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5);
                end
            end
        end
    else MOGUBar_f97a2a7812f94d4bb34fcf1f04f5711e = false;
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do
        local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
        if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then
            for MOGUBar_5e57ab95c762a48d9a126b104db1056f = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_5e57ab95c762a48d9a126b104db1056f); MOGUActionButton_HideGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); ActionButton_Update(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end
        end
    end
    end
end

function MOGUBarFrame_OnLoad(self) self:SetClampedToScreen(true); end

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
        MOGUBar_info.func = MOGUBar_f7b216cf55af9a4d5e1d6041d1932933;
        UIDropDownMenu_AddButton(MOGUBar_info);
    else
        MOGUBar_info = {};
        MOGUBar_info.text = MOGUBAR_MINIMIZE_BAR;
        MOGUBar_info.func = MOGUBar_4a8bce8af3e339e7256a76e8fd38aa73;
        UIDropDownMenu_AddButton(MOGUBar_info);
    end
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_RESIZE;
    MOGUBar_info.func = MOGUBar_519dd29c57db397976fd839a096551aa; --缩放
    UIDropDownMenu_AddButton(MOGUBar_info);
    if (MOGUBar_1db89d9f19df64198d6ec146695e73df() > 1) then
        MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_CLOSE_BAR;
        MOGUBar_info.func = function()
            StaticPopup_Show("CLOSE_BAR", nil, nil, currBar);
        end;
        UIDropDownMenu_AddButton(MOGUBar_info);
    end
    if (currBar and not currBar.minimized) then
        MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_ARRANGEMENT; MOGUBar_info.isTitle = 1; MOGUBar_info.notCheckable = 1; UIDropDownMenu_AddButton(MOGUBar_info);
        if (currBar.arrangement ~= "horizontal") then
            MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_ARRANGEMENT_HORIZONTAL; MOGUBar_info.func = MOGUBar_53a0a7c289244b633760f09361be7083; UIDropDownMenu_AddButton(MOGUBar_info);
        end
        if (currBar.arrangement ~= "vertical") then
            MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_ARRANGEMENT_VERTICAL; MOGUBar_info.func = MOGUBar_c1a00077417bf72984105bce5124b1e3; UIDropDownMenu_AddButton(MOGUBar_info);
        end
        if (currBar.arrangement ~= "funny") then
            MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_ARRANGEMENT_FUNNY; MOGUBar_info.func = U1BAR_AlignFunny; UIDropDownMenu_AddButton(MOGUBar_info);
        end MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_BUTTONS; MOGUBar_info.isTitle = 1; MOGUBar_info.notCheckable = 1; UIDropDownMenu_AddButton(MOGUBar_info); MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_INCREASE_BUTTON; MOGUBar_info.func = U1BAR_IncreaseButton; MOGUBar_info.disabled = 1; if (MOGUBar_b740f76b158bf0246affe3865ebde2cf(currBar) < MOGUBar_MAX_BUTTONS) then MOGUBar_info.disabled = nil; end UIDropDownMenu_AddButton(MOGUBar_info); MOGUBar_info = {}; MOGUBar_info.text = MOGUBAR_DECREASE_BUTTON; MOGUBar_info.func = U1BAR_DecreaseButton; MOGUBar_info.disabled = 1; if (MOGUBar_b740f76b158bf0246affe3865ebde2cf(currBar) > MOGUBar_13a3c67ee59d2b4a6a40c57847c95a42) then MOGUBar_info.disabled = nil; end UIDropDownMenu_AddButton(MOGUBar_info);
    end
    MOGUBar_info = {};
    MOGUBar_info.text =
    MOGUBAR_OTHERS; MOGUBar_info.isTitle = 1;
    MOGUBar_info.notCheckable = 1;
    UIDropDownMenu_AddButton(MOGUBar_info);
    MOGUBar_info = {};
    MOGUBar_info.text = MOGUBAR_CREATE_NEW_BAR;
    MOGUBar_info.func = U1BAR_CreateNewActionBar;
    if (MOGUBar_1db89d9f19df64198d6ec146695e73df() >= U1BAR_MAX_BARS) then
        MOGUBar_info.disabled = 1;
    end
    UIDropDownMenu_AddButton(MOGUBar_info);
    MOGUBar_info = {};
    MOGUBar_info.text = "打开控制台设置";
    MOGUBar_info.func = function() if UUI then UUI.OpenToAddon("ExtraActionBar", true) end end;
    UIDropDownMenu_AddButton(MOGUBar_info);
    --[[
    local info = {}
    info.text = "关闭标题头"
    info.func = function() _G[MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName().."Tab"]:Hide() DEFAULT_CHAT_FRAME:AddMessage("额外动作条标题头已关闭，如需开启，请在控制台中设置") end
    UIDropDownMenu_AddButton(info);
    ]]
end

function MOGUBar_SetLock()
    local bar = U1BAR_FindBar();
    if (bar) then if (bar.isLocked) then bar.isLocked = nil; else bar.isLocked = 1; end
    MOGUBar_9bf8053183f37cc485e2dcebb062ab02(bar);
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
        if (GetScreenWidth() - self:GetRight() < MOGUBar_72be2d2fba590211fe0f29e1a9832788 - 40) then
            ToggleDropDownMenu(1, nil, getglobal(self:GetName() .. "DropDown"), self:GetName(), 10 - MOGUBar_72be2d2fba590211fe0f29e1a9832788, 3); else ToggleDropDownMenu(1, nil, getglobal(self:GetName() .. "DropDown"), self:GetName(), 10, 3);
        end
        PlaySound163("UChatScrollButton");
        return;
    elseif(button == "LeftButton" and not InCombatLockdown()) then
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
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = bar or U1BAR_FindBar(self);
    if (MOGUBar_3e285ebeedd19f2a00429a2614a093d7) then
        for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do
            local showGrid = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
            if (showGrid and not showGrid.forceShow) then showGrid.forceShow = true;
            MOGUActionButton_ShowGrid(showGrid);
            end
            showGrid.grid_timestamp = 0;
            if (showGrid and showGrid.hide) then MOGUBar_11e76fe10cb05184719f745e4db8a533(showGrid); local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b(); if (MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName()]) then MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName()].buttonCount = MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f; end MOGUBar_bceab2d4ca6bac097d8aac711b117e68(); break; end
        end if (MOGUBar_3e285ebeedd19f2a00429a2614a093d7.arrangement == "funny") then U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, "funny"); end
    end
end

function U1BAR_DecreaseButton(self, bar)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = bar or U1BAR_FindBar(self);
    if (MOGUBar_3e285ebeedd19f2a00429a2614a093d7) then for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 and not MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.forceShow) then MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.forceShow = true; MOGUActionButton_ShowGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.grid_timestamp = 0; end for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = MOGUBar_MAX_BUTTONS, 2, -1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 and not MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.hide) then MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b(); if (MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName()]) then MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName()].buttonCount = MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f - 1; end break; end end if (MOGUBar_3e285ebeedd19f2a00429a2614a093d7.arrangement == "funny") then U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, "funny"); end end end

function U1BAR_SetAlign(MOGUBar_69072c73fde2ed407f863929fd1e7483, MOGUBar_0addda812f85f956e81ce69f2325e162) if (MOGUBar_0addda812f85f956e81ce69f2325e162 == "horizontal") then
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 2, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); local MOGUBar_9f4f14a4b6bb211896381263b4932758 = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. (MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f - 1); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:ClearAllPoints(); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetPoint("LEFT", MOGUBar_9f4f14a4b6bb211896381263b4932758, "RIGHT", 6, 0); end MOGUBar_69072c73fde2ed407f863929fd1e7483.arrangement = "horizontal";
elseif (MOGUBar_0addda812f85f956e81ce69f2325e162 == "vertical") then
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 2, MOGUBar_MAX_BUTTONS, 1 do
        local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
        local MOGUBar_9f4f14a4b6bb211896381263b4932758 = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. (MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f - 1); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:ClearAllPoints(); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetPoint("TOP", MOGUBar_9f4f14a4b6bb211896381263b4932758, "BOTTOM", 0, -6);
    end MOGUBar_69072c73fde2ed407f863929fd1e7483.arrangement = "vertical";
elseif (MOGUBar_0addda812f85f956e81ce69f2325e162 == "funny") then
    local MOGUBar_d5559836e6861c025e096cb9c41eda8c = MOGUBar_b740f76b158bf0246affe3865ebde2cf(MOGUBar_69072c73fde2ed407f863929fd1e7483); MOGUBar_415fabcdc81ddd99a13581c4551bbcb5(MOGUBar_69072c73fde2ed407f863929fd1e7483, MOGUBar_d5559836e6861c025e096cb9c41eda8c); MOGUBar_69072c73fde2ed407f863929fd1e7483.arrangement = "funny";
end MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_69072c73fde2ed407f863929fd1e7483);
end

function MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, __index, MOGUBar_0e2babf2e3097eec96cf9280d1412ab5, MOGUBar_00ae4bc475ffbcf97f789256a2e707de, MOGUBar_6599f8c6a1b53d0212dfbab04e14e329, MOGUBar_18bd17b74c56bfd23801044c9c9e8d4e, MOGUBar_a29776f66159eb25625ce8ff4969048f) local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. __index); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:ClearAllPoints(); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetPoint(MOGUBar_0e2babf2e3097eec96cf9280d1412ab5, MOGUBar_00ae4bc475ffbcf97f789256a2e707de, MOGUBar_6599f8c6a1b53d0212dfbab04e14e329, MOGUBar_18bd17b74c56bfd23801044c9c9e8d4e, MOGUBar_a29776f66159eb25625ce8ff4969048f);
return MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5;
end

function MOGUBar_415fabcdc81ddd99a13581c4551bbcb5(MOGUBar_69072c73fde2ed407f863929fd1e7483, MOGUBar_3f50417fb16be9b1078eb68d24fa9c26) if (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 1) then
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 2) then local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOP", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 0, -6);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 3) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1); local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "TOPLEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 3, -6);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 4) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1); local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "TOPLEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 3, -6);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOP", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOMRIGHT", 3, -6);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 5) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1); local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOMLEFT", -3, -6);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "TOP", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOPLEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOMRIGHT", 3, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "TOP", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "BOTTOM", 0, -6);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 6) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOPRIGHT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 7) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "LEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "RIGHT", 6, 0);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "LEFT", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "RIGHT", 6, 0);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "TOPLEFT", MOGUBar_a7af04fce99bafe185c44fd8033aac34:GetName(), "BOTTOM", 3, -6);
    local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 8) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOPRIGHT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
    local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "TOPLEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 3, -6);
    local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 9) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "LEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "RIGHT", 6, 0);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOP", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
    local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
    local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 10) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1);
    local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "LEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "RIGHT", 6, 0);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOPRIGHT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", -3, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0); local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
    local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 8, "TOPLEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 3, -6);
    local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0); local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 10, "LEFT", MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5:GetName(), "RIGHT", 6, 0); elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 11) then local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1); local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "LEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "RIGHT", 6, 0); local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0); local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOP", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "BOTTOM", 0, -6); local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6); local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "RIGHT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "LEFT", -6, 0); local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "LEFT", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "RIGHT", 6, 0);
    local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 8, "TOP", MOGUBar_6730b8c921a5f792f77bc21fef04de6b:GetName(), "BOTTOM", 0, -6); local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 10, "TOP", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "BOTTOM", 0, -6); local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 9, "RIGHT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "LEFT", -6, 0); local MOGUBar_527e9de525b5c4635499afc0f0f44840 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 11, "LEFT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "RIGHT", 6, 0);
elseif (MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 == 12) then
    local MOGUBar_ad8436a5e203286daabf6371f7d4bbf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. 1); local MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 2, "LEFT", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "RIGHT", 6, 0);
    local MOGUBar_a7af04fce99bafe185c44fd8033aac34 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 3, "LEFT", MOGUBar_b3abf60b2e789016349d8a0c9ae9d78e:GetName(), "RIGHT", 6, 0);
    local MOGUBar_9dbccb7afb70e52ecdb47dd475db3042 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 4, "TOP", MOGUBar_ad8436a5e203286daabf6371f7d4bbf5:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_47888b79d2e19ed3954133aecd2d3d13 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 5, "LEFT", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "RIGHT", 6, 0);
    local MOGUBar_6730b8c921a5f792f77bc21fef04de6b = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 6, "LEFT", MOGUBar_47888b79d2e19ed3954133aecd2d3d13:GetName(), "RIGHT", 6, 0);
    local MOGUBar_922b9b070b7dcf3e915e5ee7063da024 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 7, "TOP", MOGUBar_9dbccb7afb70e52ecdb47dd475db3042:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_c09bcf10f0448d5c105fa0ef31956117 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 8, "LEFT", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "RIGHT", 6, 0);
    local MOGUBar_dec7cba1852c1c686ea8ed81075ef1d5 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 9, "LEFT", MOGUBar_c09bcf10f0448d5c105fa0ef31956117:GetName(), "RIGHT", 6, 0);
    local MOGUBar_df64fc302f6e608c524ab1613c38f587 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 10, "TOP", MOGUBar_922b9b070b7dcf3e915e5ee7063da024:GetName(), "BOTTOM", 0, -6);
    local MOGUBar_527e9de525b5c4635499afc0f0f44840 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 11, "LEFT", MOGUBar_df64fc302f6e608c524ab1613c38f587:GetName(), "RIGHT", 6, 0); local MOGUBar_428c0e6168551556f099cada47165338 = MOGUBar_37637622dabae2911e0a0b3c266c2ed4(MOGUBar_69072c73fde2ed407f863929fd1e7483, 12, "LEFT", MOGUBar_527e9de525b5c4635499afc0f0f44840:GetName(), "RIGHT", 6, 0);
end
end

function MOGUBar_53a0a7c289244b633760f09361be7083(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self); U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, "horizontal");
end

function MOGUBar_c1a00077417bf72984105bce5124b1e3(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self); U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, "vertical");
end

function U1BAR_AlignFunny(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self); U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, "funny");
end

function MOGUBar_b740f76b158bf0246affe3865ebde2cf(MOGUBar_69072c73fde2ed407f863929fd1e7483)
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
    if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 and MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.hide) then return MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f - 1; end
    end return MOGUBar_MAX_BUTTONS;
end

function MOGUBar_1db89d9f19df64198d6ec146695e73df()
    local MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 = 0;
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
    if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 = MOGUBar_3f50417fb16be9b1078eb68d24fa9c26 + 1; end
    end return MOGUBar_3f50417fb16be9b1078eb68d24fa9c26;
end

function MOGUActionButton_OnEvent(self, event, ...)
    if (event == "ACTIONBAR_SHOWGRID") then
        MOGUActionButton_ShowGrid(self);
    elseif(event == "ACTIONBAR_HIDEGRID") then
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
        local MOGUBar_7c92a639261d1e1015d3449a288a5933 = button:GetAttribute("showgrid"); MOGUBar_7c92a639261d1e1015d3449a288a5933 = MOGUBar_7c92a639261d1e1015d3449a288a5933 - 1;
        if (button.forceShow) then
            button.forceShow = nil; MOGUBar_7c92a639261d1e1015d3449a288a5933 = MOGUBar_7c92a639261d1e1015d3449a288a5933 - 1;
        end if (MOGUBar_7c92a639261d1e1015d3449a288a5933 < 0) then
            MOGUBar_7c92a639261d1e1015d3449a288a5933 = 0;
        end button:SetAttribute("showgrid", MOGUBar_7c92a639261d1e1015d3449a288a5933); MOGUActionButton_UpdateGrid(button);
    end
end

function MOGUActionButton_UpdateGrid(button)
    if (button:GetAttribute("statehidden")) then
        button:Hide();
    elseif (HasAction(button:GetAttribute("action"))) then
        button:Show();
    elseif (button:GetAttribute("showgrid") >= 1) then button:Show();
    else button:Hide();
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

function MOGUBar_11e76fe10cb05184719f745e4db8a533(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5) local MOGUBar_9248008bbb6d0ee7ce13f6ee45680051 = getglobal(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:GetName() .. "NormalTexture"); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.hide = nil; MOGUBar_9248008bbb6d0ee7ce13f6ee45680051:SetAlpha(0.3); MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetAttribute("statehidden", nil); MOGUActionButton_UpdateGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); return true;
end

function MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5) MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.hide = 1; MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetAttribute("statehidden", true); MOGUActionButton_UpdateGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end

function U1BAR_SetPos(bar)
    bar:ClearAllPoints();
    bar:SetPoint("CENTER", "UIParent", "CENTER", 0, 60);
end

function MOGUBar_18944ab3c3e030c1bfeaaffe49a94415()
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do
        local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then U1BAR_SetPos(MOGUBar_69072c73fde2ed407f863929fd1e7483); end
    end
end

function MOGUBar_9d9ae0ea8d213958f106e815d1c56b12() end

function U1BAR_CreateBar(name)
    local bar = CreateFrame("Frame", name, UIParent, "MOGUBarFrameTemplate");
    if CoreHideOnPetBattle then CoreHideOnPetBattle(bar) end
    U1BAR_SetPos(bar);
    AddButtonToGroup(name.."AB%d", 12, "额外动作条"..name)
    return bar;
end

function MOGUBar_8255b0f6448dd3de248a67e8c53eec6b(MOGUBar_69072c73fde2ed407f863929fd1e7483) MOGUBar_69072c73fde2ed407f863929fd1e7483:Hide(); for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end end

function MOGUBar_4c34961ddb1a82e3dabee32d55e91d31(name)
    local MOGUBar_65e6a9c457b63f1f4e18b37f608f2807 = MOGUBar_1db89d9f19df64198d6ec146695e73df();
    if (MOGUBar_65e6a9c457b63f1f4e18b37f608f2807 > U1BAR_MAX_BARS) then
        return;
    end
    local MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f;
    local MOGUBar_69072c73fde2ed407f863929fd1e7483;
    if (name) then
        local MOGUBar_6e4d0db7491d6883f86de390d20dbe5b, MOGUBar_a2f3972c23a0aa3bd7fb0e9823d918f2, MOGUBar_8d0febf2348ea712b2b375ae95601d5f = string.find(name, "^U1BAR(%d+)$"); MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal(name); if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_6e4d0db7491d6883f86de390d20dbe5b) then MOGUBar_69072c73fde2ed407f863929fd1e7483:Show();
        return MOGUBar_69072c73fde2ed407f863929fd1e7483;
        else MOGUBar_69072c73fde2ed407f863929fd1e7483 = U1BAR_CreateBar(name); MOGUBar_69072c73fde2ed407f863929fd1e7483:SetID(MOGUBar_8d0febf2348ea712b2b375ae95601d5f); local titile = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "TabTitle"); titile:SetText(MOGUBar_8d0febf2348ea712b2b375ae95601d5f); MOGUBar_69072c73fde2ed407f863929fd1e7483:Show(); return MOGUBar_69072c73fde2ed407f863929fd1e7483; end end
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and not MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then
        MOGUBar_69072c73fde2ed407f863929fd1e7483:Show(); return MOGUBar_69072c73fde2ed407f863929fd1e7483;
    end
    end
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, U1BAR_MAX_BARS, 1 do MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (not MOGUBar_69072c73fde2ed407f863929fd1e7483) then MOGUBar_69072c73fde2ed407f863929fd1e7483 = U1BAR_CreateBar("U1BAR" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); MOGUBar_69072c73fde2ed407f863929fd1e7483:SetID(MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); local titile = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "TabTitle"); titile:SetText(MOGUBar_8d0febf2348ea712b2b375ae95601d5f); MOGUBar_69072c73fde2ed407f863929fd1e7483:Show();
    return MOGUBar_69072c73fde2ed407f863929fd1e7483;
    end
    end
end

function U1BAR_CreateNewActionBar()
    local bar = MOGUBar_4c34961ddb1a82e3dabee32d55e91d31();
    local MOGUBar_9c289060f01bdfd0d82b46cc13ae58a1;
    if (bar) then
        local titile = getglobal(bar:GetName() .. "TabTitle"); titile:SetText(bar:GetID());
        --MHDB["mgbar"..MOGUBar_69072c73fde2ed407f863929fd1e7483:GetID()] = true
        bar.isLocked = nil; bar.minimized = nil; bar.sonID = 1; for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do
            local btn = getglobal(bar:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
            local MOGUBar_8d0febf2348ea712b2b375ae95601d5f = bar.sonID + (10 - bar:GetID()) * MOGUBar_MAX_BUTTONS;
            btn:SetScript("OnEvent", MOGUActionButton_OnEvent);
            btn:SetAttribute("action", MOGUBar_8d0febf2348ea712b2b375ae95601d5f);
            btn.bookFrameShow = nil;
            MOGUBar_11e76fe10cb05184719f745e4db8a533(btn);
            bar.sonID =
            bar.sonID + 1; MOGUBar_9c289060f01bdfd0d82b46cc13ae58a1 = true;
            if (MOGUBar_f97a2a7812f94d4bb34fcf1f04f5711e) then
                btn:SetAttribute("showgrid", 1);
            else
                btn:SetAttribute("showgrid", 0);
            end
            btn.forceShow = true;
            MOGUActionButton_ShowGrid(btn);
            MOGUActionButton_UpdateGrid(btn);
        end
        for i = U1BAR_DEFAULT_BTNS + 1, MOGUBar_MAX_BUTTONS, 1 do
            local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(bar:GetName() .. "AB" .. i); MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5);
        end
        U1BAR_SetAlign(bar, "vertical");
        MOGUBar_9bf8053183f37cc485e2dcebb062ab02(bar);
        if (not MOGUBar_9c289060f01bdfd0d82b46cc13ae58a1) then MOGUBar_503ed091c79944be5b7079c0602f8146(bar); end MOGUBar_bceab2d4ca6bac097d8aac711b117e68();
    end
end

function MOGUBar_503ed091c79944be5b7079c0602f8146(self, MOGUBar_69072c73fde2ed407f863929fd1e7483) local MOGUBar_3e285ebeedd19f2a00429a2614a093d7; if (MOGUBar_69072c73fde2ed407f863929fd1e7483) then MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = MOGUBar_69072c73fde2ed407f863929fd1e7483; else MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self); end MOGUBar_8255b0f6448dd3de248a67e8c53eec6b(MOGUBar_3e285ebeedd19f2a00429a2614a093d7); MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_3e285ebeedd19f2a00429a2614a093d7); end

function MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b()
    local MOGUBar_8983c60d66c8593ec7165ea9dbedb584 = UnitName("Player");
    if (not MOGUBar_8983c60d66c8593ec7165ea9dbedb584 or MOGUBar_8983c60d66c8593ec7165ea9dbedb584 == UNKNOWNOBJECT or MOGUBar_8983c60d66c8593ec7165ea9dbedb584 == UKNOWNBEING) then
        return nil;
    end if (not MOGUBar_Info[MOGUBar_8983c60d66c8593ec7165ea9dbedb584]) then
        MOGUBar_Info[MOGUBar_8983c60d66c8593ec7165ea9dbedb584] = {
            U1BAR1 = {
                buttonCount = 7,
                arrangement = "funny",
                region = {top = GetScreenHeight()/2, left = GetScreenWidth()/2 + 225,}
            }
        };
    end
    return MOGUBar_Info[MOGUBar_8983c60d66c8593ec7165ea9dbedb584];
end

function MOGUBar_39617e6afb8c5b386f4220eb9cedc482(MOGUBar_69072c73fde2ed407f863929fd1e7483) if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then
    local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b();
    local MOGUBar_info = MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName()]; if (MOGUBar_info and MOGUBar_info.region) then
        MOGUBar_69072c73fde2ed407f863929fd1e7483.arrangement = MOGUBar_info.arrangement; MOGUBar_69072c73fde2ed407f863929fd1e7483.isLocked = MOGUBar_info.isLocked; MOGUBar_69072c73fde2ed407f863929fd1e7483.minimized = MOGUBar_info.minimized; MOGUBar_69072c73fde2ed407f863929fd1e7483.scale = MOGUBar_info.scale; MOGUBar_69072c73fde2ed407f863929fd1e7483.togglePartyFrame = MOGUBar_info.togglePartyFrame; MOGUBar_69072c73fde2ed407f863929fd1e7483.toggleDurabilityFrame = MOGUBar_info.toggleDurabilityFrame;
        if (MOGUBar_69072c73fde2ed407f863929fd1e7483.scale) then
            BScale:SetScale(MOGUBar_69072c73fde2ed407f863929fd1e7483, MOGUBar_69072c73fde2ed407f863929fd1e7483.scale);
        end MOGUBar_69072c73fde2ed407f863929fd1e7483:ClearAllPoints(); MOGUBar_69072c73fde2ed407f863929fd1e7483:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", MOGUBar_info.region.left, MOGUBar_info.region.top); U1BAR_SetAlign(MOGUBar_69072c73fde2ed407f863929fd1e7483, MOGUBar_info.arrangement);
        if (MOGUBar_69072c73fde2ed407f863929fd1e7483.togglePartyFrame) then
            MOGUBar_188692f2774e57694ab1a6c14c3e21c9(1);
        end
        if (MOGUBar_69072c73fde2ed407f863929fd1e7483.toggleDurabilityFrame) then MOGUBar_808a4bd835bd3741099c5cfacb463a5c(1); end
    end
end
end

function MOGUBar_25b1d2fe6e14021d74f8def30b5d48bc() local MOGUBar_c685f4925ec02e7e5f0d12a9e63db683 = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b(); if (not MOGUBar_c685f4925ec02e7e5f0d12a9e63db683) then
    MOGU_DelayCall(MOGUBar_25b1d2fe6e14021d74f8def30b5d48bc, 2);
    return;
end
local MOGUBar_ff4467bc8864d2ea7b10717bedfa5445 = nil;
local __index;
for __index = 1, U1BAR_MAX_BARS, 1 do local MOGUBar_a089a0b53f3ee0ef6a00560e0ec5f20e = "U1BAR" .. __index;
if (MOGUBar_c685f4925ec02e7e5f0d12a9e63db683[MOGUBar_a089a0b53f3ee0ef6a00560e0ec5f20e]) then local MOGUBar_69072c73fde2ed407f863929fd1e7483 = getglobal(MOGUBar_a089a0b53f3ee0ef6a00560e0ec5f20e);
if (not MOGUBar_69072c73fde2ed407f863929fd1e7483) then
    MOGUBar_69072c73fde2ed407f863929fd1e7483 = MOGUBar_4c34961ddb1a82e3dabee32d55e91d31(MOGUBar_a089a0b53f3ee0ef6a00560e0ec5f20e);
end MOGUBar_69072c73fde2ed407f863929fd1e7483.keyframe = CreateFrame("Frame", nil, UIParent); MOGUBar_69072c73fde2ed407f863929fd1e7483.sonID = 1; local MOGUBar_d5559836e6861c025e096cb9c41eda8c = MOGUBar_c685f4925ec02e7e5f0d12a9e63db683[MOGUBar_a089a0b53f3ee0ef6a00560e0ec5f20e].buttonCount;
if (not MOGUBar_d5559836e6861c025e096cb9c41eda8c) then MOGUBar_d5559836e6861c025e096cb9c41eda8c = MOGUBar_MAX_BUTTONS; end for U1B_i = 1, MOGUBar_MAX_BUTTONS, 1 do
    local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. U1B_i);
    local loc1 = MOGUBar_69072c73fde2ed407f863929fd1e7483.sonID + (10 - MOGUBar_69072c73fde2ed407f863929fd1e7483:GetID()) * MOGUBar_MAX_BUTTONS;
    MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetAttribute("action", loc1);
    MOGUBar_69072c73fde2ed407f863929fd1e7483.sonID = MOGUBar_69072c73fde2ed407f863929fd1e7483.sonID + 1;
    MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetScript("OnEvent", MOGUActionButton_OnEvent);
    if (MOGUBar_f97a2a7812f94d4bb34fcf1f04f5711e) then
        MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetAttribute("showgrid", 1);
    else
        MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5:SetAttribute("showgrid", 0);
    end
end
for U1B_i = 1, MOGUBar_d5559836e6861c025e096cb9c41eda8c, 1 do
    local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. U1B_i); MOGUBar_11e76fe10cb05184719f745e4db8a533(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5);
end
for U1B_i = MOGUBar_d5559836e6861c025e096cb9c41eda8c + 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. U1B_i); MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end for U1B_i = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "AB" .. U1B_i); MOGUActionButton_UpdateGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end MOGUBar_39617e6afb8c5b386f4220eb9cedc482(MOGUBar_69072c73fde2ed407f863929fd1e7483);
local titile = getglobal(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName() .. "TabTitle"); titile:SetText(MOGUBar_69072c73fde2ed407f863929fd1e7483:GetID()); if (MOGUBar_69072c73fde2ed407f863929fd1e7483.minimized) then MOGUBar_4a8bce8af3e339e7256a76e8fd38aa73(MOGUBar_69072c73fde2ed407f863929fd1e7483); end MOGUBar_ff4467bc8864d2ea7b10717bedfa5445 = true;
end
end
if (not MOGUBar_ff4467bc8864d2ea7b10717bedfa5445) then U1BAR_CreateNewActionBar(); end
end

function MOGUBar_d7613b704685de240b505fbb41cef8ca(MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3, MOGUBar_eed0be1c2d5f65980b06b5094460c3c5) if (MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3 == "Error") then ChatFrame1:AddMessage(MOGUBar_eed0be1c2d5f65980b06b5094460c3c5, 1.0, 0.0, 0.0); elseif (MOGUBar_6d5e7d83d8358745ae4dcf61d16bd1f3 == "Info") then ChatFrame1:AddMessage(MOGUBar_eed0be1c2d5f65980b06b5094460c3c5, 1.0, 1.0, 0.0); end end

function MOGUBar_b426b0ee17555ad80167ab19c3adbf2d(MOGUBar_69072c73fde2ed407f863929fd1e7483)
    local MOGUBar_9112dfed749d840c7819e10f55f2697b = {};
    MOGUBar_9112dfed749d840c7819e10f55f2697b.left = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetLeft(); MOGUBar_9112dfed749d840c7819e10f55f2697b.right = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetRight(); MOGUBar_9112dfed749d840c7819e10f55f2697b.top = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetTop();
    MOGUBar_9112dfed749d840c7819e10f55f2697b.bottom = MOGUBar_69072c73fde2ed407f863929fd1e7483:GetBottom();
    if (not MOGUBar_9112dfed749d840c7819e10f55f2697b.left or not MOGUBar_9112dfed749d840c7819e10f55f2697b.right or not MOGUBar_9112dfed749d840c7819e10f55f2697b.top or not MOGUBar_9112dfed749d840c7819e10f55f2697b.bottom) then
        return nil;
    end MOGUBar_9112dfed749d840c7819e10f55f2697b.left = math.floor(MOGUBar_9112dfed749d840c7819e10f55f2697b.left + 0.5); MOGUBar_9112dfed749d840c7819e10f55f2697b.right = math.floor(MOGUBar_9112dfed749d840c7819e10f55f2697b.right + 0.5); MOGUBar_9112dfed749d840c7819e10f55f2697b.top = math.floor(MOGUBar_9112dfed749d840c7819e10f55f2697b.top + 0.5); MOGUBar_9112dfed749d840c7819e10f55f2697b.bottom = math.floor(MOGUBar_9112dfed749d840c7819e10f55f2697b.bottom + 0.5);
    return MOGUBar_9112dfed749d840c7819e10f55f2697b;
end

function MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_69072c73fde2ed407f863929fd1e7483)
    local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b();
    if (MOGUBar_69072c73fde2ed407f863929fd1e7483 and MOGUBar_bba564c01b4659989f8d87879ec9fe5e) then
        if (MOGUBar_69072c73fde2ed407f863929fd1e7483:IsVisible()) then
            local MOGUBar_info = {};
            local MOGUBar_9112dfed749d840c7819e10f55f2697b = MOGUBar_b426b0ee17555ad80167ab19c3adbf2d(MOGUBar_69072c73fde2ed407f863929fd1e7483); MOGUBar_info.region = MOGUBar_9112dfed749d840c7819e10f55f2697b;
            MOGUBar_info.arrangement = MOGUBar_69072c73fde2ed407f863929fd1e7483.arrangement; MOGUBar_info.isLocked = MOGUBar_69072c73fde2ed407f863929fd1e7483.isLocked; MOGUBar_info.minimized = MOGUBar_69072c73fde2ed407f863929fd1e7483.minimized; MOGUBar_info.scale = MOGUBar_69072c73fde2ed407f863929fd1e7483.scale; MOGUBar_info.togglePartyFrame = MOGUBar_69072c73fde2ed407f863929fd1e7483.togglePartyFrame; MOGUBar_info.toggleDurabilityFrame = MOGUBar_69072c73fde2ed407f863929fd1e7483.toggleDurabilityFrame; MOGUBar_info.buttonCount = MOGUBar_b740f76b158bf0246affe3865ebde2cf(MOGUBar_69072c73fde2ed407f863929fd1e7483); MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName()] = MOGUBar_info; else MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_69072c73fde2ed407f863929fd1e7483:GetName()] = nil;
        end
    end
end

function MOGUBar_519dd29c57db397976fd839a096551aa(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self);
    local MOGUBar_6230e23f021dec637edabaa368556c06 = MOGUBar_3e285ebeedd19f2a00429a2614a093d7.scale;
    if (not MOGUBar_6230e23f021dec637edabaa368556c06) then
        MOGUBar_6230e23f021dec637edabaa368556c06 = 1;
    end
    local bar = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "Tab");
    local top = bar:GetTop() * bar:GetEffectiveScale();
    local left = bar:GetLeft() * bar:GetEffectiveScale();
    MOGUBarOpacitySlider.frame = nil;
    MOGUBarOpacitySlider:SetAlpha(1);
    MOGUBarOpacitySlider:ClearAllPoints();
    MOGUBarOpacitySlider:SetPoint("TOPRIGHT", bar, "TOPLEFT", -20, 0); MOGUBarOpacitySlider:Show(); MOGUBarOpacitySlider:SetMinMaxValues(50, 150); MOGUBarOpacitySlider:SetValueStep(10);
    if (MOGUBar_3e285ebeedd19f2a00429a2614a093d7.scale) then
        MOGUBarOpacitySlider:SetValue(MOGUBar_3e285ebeedd19f2a00429a2614a093d7.scale * 100);
    else MOGUBarOpacitySlider:SetValue(100);
    end
    MOGUBarOpacitySlider.frame = MOGUBar_3e285ebeedd19f2a00429a2614a093d7;
end

function MOGUBar_4a8bce8af3e339e7256a76e8fd38aa73(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self);
    for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do
        local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f);
        if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5) then
            MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.minimized = 1;
            MOGUBar_572bc203d168039d0b16ee8ebdfc9d3a(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5);
        end
    end
    MOGUBar_3e285ebeedd19f2a00429a2614a093d7.minimized = 1;
    MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_3e285ebeedd19f2a00429a2614a093d7);
end

function MOGUBar_f7b216cf55af9a4d5e1d6041d1932933(self)
    local MOGUBar_3e285ebeedd19f2a00429a2614a093d7 = U1BAR_FindBar(self); for MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f = 1, MOGUBar_MAX_BUTTONS, 1 do local MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 = getglobal(MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName() .. "AB" .. MOGUBar_e914904fab9d05d3f54d52bfc31a0f3f); if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 and MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.hide) then MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5.minimized = nil; MOGUBar_11e76fe10cb05184719f745e4db8a533(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end ActionButton_UpdateState(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); MOGUActionButton_UpdateGrid(MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5); end MOGUBar_3e285ebeedd19f2a00429a2614a093d7.minimized = nil; local MOGUBar_bba564c01b4659989f8d87879ec9fe5e = MOGUBar_45eed77ae29ae5fa45c281c9f2e34a2b(); local MOGUBar_info = MOGUBar_bba564c01b4659989f8d87879ec9fe5e[MOGUBar_3e285ebeedd19f2a00429a2614a093d7:GetName()]; U1BAR_SetAlign(MOGUBar_3e285ebeedd19f2a00429a2614a093d7, MOGUBar_info.arrangement); MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_3e285ebeedd19f2a00429a2614a093d7);
end

function MOGUBar_808a4bd835bd3741099c5cfacb463a5c(MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae) if (MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae) then DurabilityFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", -20, 15); else DurabilityFrame:SetPoint("TOP", "MinimapCluster", "BOTTOM", 40, 15); end end

function MOGUBar_188692f2774e57694ab1a6c14c3e21c9(MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae)
    do return end
    if (MOGUBar_7739b813d90aed43ab9d0eb84ec1c1ae) then
        PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 40, -128);
    else
        PartyMemberFrame1:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 10, -128);
    end
end

function MOGUBar_OnMouseDown(self, MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5)
    if (MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5 ~= "LeftButton") then
        return;
    end
    local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = self:GetParent();
    if (not MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.isLocked and not MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.inCombat) then MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:StartMoving();
    MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.moving = true;
    MOVING_MOGUBAR = MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a;
    end
end

function MOGUBar_OnMouseUp(self, MOGUBar_99f3cf2c6f1fdfadb0fd4ab6e0843bf5)
    local MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a = self:GetParent();
    if (MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.moving or InCombatLockdown()) then
        MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a:StopMovingOrSizing(); MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a.moving = false;
        MOVING_MOGUBAR = nil;
        MOGUBar_9bf8053183f37cc485e2dcebb062ab02(MOGUBar_411b8aa6d5954c6020f0b9c9e80e847a);
    end
end

function MOGUBarTab_OnEnter(self) self:GetParent().isFading = nil;
self:GetParent().locking = true; GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
GameTooltip:SetText(MOGUBAR_TAB_HELP_TEXT); GameTooltip:Show();
end

function MOGUBarTab_OnLeave(self) local dropdown = getglobal(self:GetName() .. "DropDown");
if (UIDropDownMenu_GetCurrentDropDown() ~= dropdown) then self:GetParent().locking = nil;
end
self:GetParent().lastLeave = GetTime(); GameTooltip:Hide();
end

function MOGUBarOpacitySlider_OnValueChanged(self, value)
    getglobal(self:GetName() .. "Text"):SetText(math.floor(value) .. "%");
    if (self.frame) then
        BScale:SetScale(self.frame, value / 100); self.frame.scale = value / 100; MOGUBar_9bf8053183f37cc485e2dcebb062ab02(self.frame);
    end
end

local function MOGUBar_3132bb65521790fe81fb039758b0f1f0()
    if (MOGUBarOpacitySlider.Leave) then
        MOGUBarOpacitySlider:Hide();
    end
end

local function MOGUBar_d4c4d4c5dde2baa01c763775a64361ff()
    if (MOGUBarOpacitySlider.Leave) then
        UICoreFrameFadeIn(MOGUBarOpacitySlider, 0.5, 1, 0); MOGU_DelayCall(MOGUBar_3132bb65521790fe81fb039758b0f1f0, 0.5);
    end
end

function MOGUBarOpacitySlider_OnEnter(self) MOGUBarOpacitySlider.Leave = nil; end

function MOGUBarOpacitySlider_OnLeave(self)
    if (MOGUBarOpacitySlider.frame) then
        MOGUBarOpacitySlider.Leave = 1;
    end
    MOGU_DelayCall(MOGUBar_d4c4d4c5dde2baa01c763775a64361ff, 2);
end

function U1BAR_ActionButton_Update (self)
	local name = self:GetName();

	local action = self.action;
	local icon = _G[name.."Icon"];
	local buttonCooldown = _G[name.."Cooldown"];
	local texture = GetActionTexture(action);

	if ( HasAction(action) ) then



		if ( not self.eventsRegistered ) then

			self:RegisterEvent("ACTIONBAR_UPDATE_STATE");
			self:RegisterEvent("ACTIONBAR_UPDATE_USABLE");
			--self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
			self:RegisterEvent("UPDATE_INVENTORY_ALERTS");
			self:RegisterEvent("PLAYER_TARGET_CHANGED");
			self:RegisterEvent("TRADE_SKILL_SHOW");
			self:RegisterEvent("TRADE_SKILL_CLOSE");
			self:RegisterEvent("ARCHAEOLOGY_CLOSED");
			self:RegisterEvent("PLAYER_ENTER_COMBAT");
			self:RegisterEvent("PLAYER_LEAVE_COMBAT");
			self:RegisterEvent("START_AUTOREPEAT_SPELL");
			self:RegisterEvent("STOP_AUTOREPEAT_SPELL");
			self:RegisterEvent("UNIT_ENTERED_VEHICLE");
			self:RegisterEvent("UNIT_EXITED_VEHICLE");
			self:RegisterEvent("COMPANION_UPDATE");
			self:RegisterEvent("UNIT_INVENTORY_CHANGED");
			self:RegisterEvent("LEARNED_SPELL_IN_TAB");
			self:RegisterEvent("PET_STABLE_UPDATE");
			self:RegisterEvent("PET_STABLE_SHOW");
			self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
			self:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
			self.eventsRegistered = true;
		end

		if ( not self:GetAttribute("statehidden") ) then
            if not InCombatLockdown() then
			    self:Show();
            end
		end
		ActionButton_UpdateState(self);
		ActionButton_UpdateUsable(self);
		ActionButton_UpdateCooldown(self);
		ActionButton_UpdateFlash(self);
	else


		if ( self.eventsRegistered ) then

			self:UnregisterEvent("ACTIONBAR_UPDATE_STATE");
			self:UnregisterEvent("ACTIONBAR_UPDATE_USABLE");
			--self:UnregisterEvent("ACTIONBAR_UPDATE_COOLDOWN");
			self:UnregisterEvent("UPDATE_INVENTORY_ALERTS");
			self:UnregisterEvent("PLAYER_TARGET_CHANGED");
			self:UnregisterEvent("TRADE_SKILL_SHOW");
			self:UnregisterEvent("ARCHAEOLOGY_CLOSED");
			self:UnregisterEvent("TRADE_SKILL_CLOSE");
			self:UnregisterEvent("PLAYER_ENTER_COMBAT");
			self:UnregisterEvent("PLAYER_LEAVE_COMBAT");
			self:UnregisterEvent("START_AUTOREPEAT_SPELL");
			self:UnregisterEvent("STOP_AUTOREPEAT_SPELL");
			self:UnregisterEvent("UNIT_ENTERED_VEHICLE");
			self:UnregisterEvent("UNIT_EXITED_VEHICLE");
			self:UnregisterEvent("COMPANION_UPDATE");
			self:UnregisterEvent("UNIT_INVENTORY_CHANGED");
			self:UnregisterEvent("LEARNED_SPELL_IN_TAB");
			self:UnregisterEvent("PET_STABLE_UPDATE");
			self:UnregisterEvent("PET_STABLE_SHOW");
			self:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW");
			self:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE");
			self.eventsRegistered = nil;
		end

		if ( self:GetAttribute("showgrid") == 0 ) then
            if not InCombatLockdown() then
			    self:Hide();
            end
		else
			buttonCooldown:Hide();
		end
	end

	-- Add a green border if button is an equipped item
	local border = _G[name.."Border"];
	if ( IsEquippedAction(action) ) then
		border:SetVertexColor(0, 1.0, 0, 0.35);
		border:Show();
	else
		border:Hide();
	end

	-- Update Action Text
	local actionName = _G[name.."Name"];
	if ( not IsConsumableAction(action) and not IsStackableAction(action) ) then
		actionName:SetText(GetActionText(action));
	else
		actionName:SetText("");
	end

	-- Update icon and hotkey text
	if ( texture ) then
		icon:SetTexture(texture);
		icon:Show();
		self.rangeTimer = -1;
		self:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2");
	else
		icon:Hide();
		buttonCooldown:Hide();
		self.rangeTimer = nil;
		self:SetNormalTexture("Interface\\Buttons\\UI-Quickslot");
		local hotkey = _G[name.."HotKey"];
        if ( hotkey:GetText() == RANGE_INDICATOR ) then
			hotkey:Hide();
		else
			hotkey:SetVertexColor(0.6, 0.6, 0.6);
		end
	end
	ActionButton_UpdateCount(self);

	-- Update flyout appearance
	--ActionButton_UpdateFlyout(self);

	ActionButton_UpdateOverlayGlow(self);

	-- Update tooltip
	if ( GameTooltip:GetOwner() == self ) then
		ActionButton_SetTooltip(self);
	end

	self.feedback_action = action;
end

function U1BAR_ActionButton_OnEvent (self, event, ...)

	local arg1 = ...;
	if ((event == "UNIT_INVENTORY_CHANGED" and arg1 == "player") or event == "LEARNED_SPELL_IN_TAB") then
		if ( GameTooltip:GetOwner() == self ) then
			ActionButton_SetTooltip(self);
		end
	end
	if ( event == "ACTIONBAR_SLOT_CHANGED" ) then
		if ( arg1 == 0 or arg1 == tonumber(self.action) ) then
			U1BAR_ActionButton_Update(self);
		end
		return;
	end
	if ( event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_SHAPESHIFT_FORM" ) then
		-- need to listen for UPDATE_SHAPESHIFT_FORM because attack icons change when the shapeshift form changes
		U1BAR_ActionButton_Update(self);
		return;
	end
	if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" ) then
		ActionButton_UpdateAction(self);
		local actionType, id, subType = GetActionInfo(self.action);
		if ( actionType == "spell" and id == 0 ) then
			ActionButton_HideOverlayGlow(self);
		end
		return;
	end
	if ( event == "UPDATE_BINDINGS" ) then
		ActionButton_UpdateHotkeys(self, self.buttonType);
		return;
	end

	-- All event handlers below this line are only set when the button has an action

	if ( event == "PLAYER_TARGET_CHANGED" ) then
		self.rangeTimer = -1;
	elseif ( (event == "ACTIONBAR_UPDATE_STATE") or
		((event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE") and (arg1 == "player")) or
		((event == "COMPANION_UPDATE") and (arg1 == "MOUNT")) ) then
		ActionButton_UpdateState(self);
	elseif ( event == "ACTIONBAR_UPDATE_USABLE" ) then
		ActionButton_UpdateUsable(self);
	elseif ( event == "ACTIONBAR_UPDATE_COOLDOWN" ) then
		ActionButton_UpdateCooldown(self);
		-- Update tooltip
		if ( GameTooltip:GetOwner() == self ) then
			ActionButton_SetTooltip(self);
		end
	elseif ( event == "TRADE_SKILL_SHOW" or event == "TRADE_SKILL_CLOSE"  or event == "ARCHAEOLOGY_CLOSED" ) then
		ActionButton_UpdateState(self);
	elseif ( event == "PLAYER_ENTER_COMBAT" ) then
		if ( IsAttackAction(self.action) ) then
			ActionButton_StartFlash(self);
		end
	elseif ( event == "PLAYER_LEAVE_COMBAT" ) then
		if ( IsAttackAction(self.action) ) then
			ActionButton_StopFlash(self);
		end
	elseif ( event == "START_AUTOREPEAT_SPELL" ) then
		if ( IsAutoRepeatAction(self.action) ) then
			ActionButton_StartFlash(self);
		end
	elseif ( event == "STOP_AUTOREPEAT_SPELL" ) then
		if ( ActionButton_IsFlashing(self) and not IsAttackAction(self.action) ) then
			ActionButton_StopFlash(self);
		end
	elseif ( event == "PET_STABLE_UPDATE" or event == "PET_STABLE_SHOW") then
		-- Has to update everything for now, but this event should happen infrequently
		U1BAR_ActionButton_Update(self);
	elseif ( event == "SPELL_ACTIVATION_OVERLAY_GLOW_SHOW" ) then
		local actionType, id, subType = GetActionInfo(self.action);
		if ( actionType == "spell" and id == arg1 ) then
			ActionButton_ShowOverlayGlow(self);
		end
	elseif ( event == "SPELL_ACTIVATION_OVERLAY_GLOW_HIDE" ) then
		local actionType, id, subType = GetActionInfo(self.action);
		if ( actionType == "spell" and id == arg1 ) then
			ActionButton_HideOverlayGlow(self);
		end
	end
end