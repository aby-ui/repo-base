--- ---------------- 污染问题 ------------
local deal_taint_dropdown = true
local deal_taint_options = false
local deal_taint_other = false

--[[------------------------------------------------------------
选项面板里有下拉菜单选项的问题
(5.4已经改为securecall, 参见 RunControlsCallbacks BlizzardOptionsPanel_RefreshControl
    /run for _, control in next, AudioOptionsSoundPanel.controls do print(control:GetName(), isv(control, "oldValue")) end
    local function AudioOptionsPanel_Refresh (self)
        for _, control in next, self.controls do
            BlizzardOptionsPanel_RefreshControl(control);
            -- record values so we can cancel back to this state
            control.oldValue = control.value;
        end
    end
    在这里面，遇到一个dropdown的，就会开始污染
    /dump isv(AudioOptionsSoundPanelHardwareDropDown, "newValue") -> 1证明了是在下面两句里污染的
                UIDropDownMenu_SetSelectedValue(self, selectedDriverIndex);
                UIDropDownMenu_Initialize(self, AudioOptionsSoundPanelHardwareDropDown_Initialize);
    /dump isv(AudioOptionsSoundPanelSoundChannelsDropDown, "value") -> GearManagerEx
    进一步证明
    /dump isv(DropDownList1, "numButtons")
---------------------------------------------------------------]]

--[[------------------------------------------------------------
处理4.3 OnEvent循环调用 ActionButton_Update()时因为读取OverlayGlow导致的污染
ActionButton_UpdateAction -> if ( event == "ACTIONBAR_PAGE_CHANGED" or event == "UPDATE_BONUS_ACTIONBAR" or event == "UPDATE_EXTRA_ACTIONBAR" ) then
ACTIONBAR_PAGE_CHANGED - ActionBarButtonEventsFrame
ACTIONBAR_SLOT_CHANGED - ActionBarButtonEventsFrame
PLAYER_ENTERING_WORLD - ActionBarButtonEventsFrame
UPDATE_SHAPESHIFT_FORM - ActionBarButtonEventsFrame
PET_STABLE_UPDATE, PET_STABLE_SHOW - ActionBarActionEventsFrame
/run hooksecurefunc("ActionButton_Update", function(f) if f==ActionButton1 then print(debugstack()) end end)
---------------------------------------------------------------]]
if deal_taint_other then
    local buttonEvents = {"ACTIONBAR_PAGE_CHANGED","ACTIONBAR_SLOT_CHANGED","PLAYER_ENTERING_WORLD","UPDATE_SHAPESHIFT_FORM"}
    local actionEvents = {"PET_STABLE_UPDATE", "PET_STABLE_SHOW" }
    for _, evt in ipairs(buttonEvents) do
        ActionBarButtonEventsFrame:UnregisterEvent(evt)
        for _, frm in pairs(ActionBarButtonEventsFrame.frames) do
            frm:RegisterEvent(evt)
        end
    end
    hooksecurefunc("ActionBarButtonEventsFrame_RegisterFrame", function(frame)
        for _, evt in ipairs(buttonEvents) do frame:RegisterEvent(evt) end
    end)
    for _, evt in ipairs(actionEvents) do
        ActionBarActionEventsFrame:UnregisterEvent(evt)
        for _, frm in pairs(ActionBarActionEventsFrame.frames) do
            frm:RegisterEvent(evt)
        end
    end
    hooksecurefunc("ActionBarActionEventsFrame_RegisterFrame", function(frame)
        for _, evt in ipairs(actionEvents) do frame:RegisterEvent(evt) end
    end)
end

--[[------------------------------------------------------------
清理DropDown的污染（3层的可以在专业附魔里测试）
---------------------------------------------------------------]]
local isv = issecurevariable
CoreOnEvent("PLAYER_LEAVING_WORLD", function() core.leavingWorld = 1 end)
CoreOnEvent("PLAYER_ENTERING_WORLD", function() core.leavingWorld = nil end)
local U1NoTaintCleanAll, tracingInfo
if(deal_taint_dropdown)then
    hooksecurefunc(CompactUnitFrameProfiles, "UnregisterEvent", function(self, event)
        if(event=="COMPACT_UNIT_FRAME_PROFILES_LOADED" or event=="VARIABLES_LOADED") then
            U1NoTaintCleanAll(); --清除了numButtons
        end
    end)

    local dropDownList1 = DropDownList1

    --捕获 UIDropDownMenuDelegate，因为测试发现，如果有 UIDROPDOWNMENU_OPEN_MENU 会造成污染
    hooksecurefunc(getmetatable(UIParent).__index, "SetAttribute", function(self, attr)
        if attr=="initmenu" and not core.t then core.t = self end
    end)
    --捕获 UIDropDownMenu_SecureInfo 因为如果里面有非安全的值，也会引起污染
    hooksecurefunc("UIDropDownMenu_AddButton", function(info)
            if core.s then return end
            for k,v in pairs(info) do
                if isv(info, k) then core.s = info return end
            end
        end)

    --numButtons如果清理掉则一些没经过IntializeHelper就直接AddButton的插件会报错
    --而如果不清理掉，则暴雪的插件一旦未经过Initialize直接调用UIDropDownMenu_SetSelectedValue就会污染
    local function cleanObject(obj)
        for k,v in pairs(obj) do
            if k~="__hooked" and k~="numButtons" and k~="maxWidth" and not isv(obj, k) then obj[k] = nil end
        end
    end

    ---清理drop及buttons的属性，(现在不清理openmenu和initmenu了，防止 RaidFrameDropDown_Initialize 之后报错)
    --注意不清理dropDownList1.numButtons, 只在LoadAddOn之后和CleanAll的时候清理
    local function cleanDrop(drop)
        if drop:IsVisible() then return end
        cleanObject(drop)
        --if not isv(drop, "numButtons") then drop.numButtons = nil end
        for j=1, UIDROPDOWNMENU_MAXBUTTONS, 1 do
            local button = _G["DropDownList"..drop:GetID().."Button"..j];
            cleanObject(button);
        end
        --if core.t and drop:GetID()==1 then
        --    core.t:SetAttribute("openmenu", nil)
        --    core.t:SetAttribute("initmenu", nil)
        --end
    end

    ---通过开启一次寻求组队来重置 UIDROPDOWNMENU_MENU_LEVEL，注意 UIDROPDOWNMENU_MENU_LEVEL 会被重置到 1，所以当有Drop显示时不能处理
    --因为LFDParentFrame:Show()会触发 LFG_LOCK_INFO_RECEIVED 和 LFG_UPDATE_RANDOM_INFO 所以会清掉
    --2012.9.14 实际生效的是 ScenarioQueueFrameTypeDropDown 的 OnShow
    local function cleanDropMenuLevel()
        do return end --Auctionator启用时有冲突
        local proxyFrame = ScenarioQueueFrameTypeDropDown
        if proxyFrame and not dropDownList1:IsVisible() and not isv("UIDROPDOWNMENU_MENU_LEVEL") then --这里一旦去掉 isv("UIDROPDOWNMENU_MENU_LEVEL") 这个条件, 立刻污染groupMode
            --print("cleanDropMenuLevel from "..tracingInfo)
            --ScenarioQueueFrameTypeDropDown 显示时会设置 UIDROPDOWNMENU_INIT_MENU, 从而导致可能的错误
            local lastInitMenu = UIDROPDOWNMENU_INIT_MENU
            local oldpar = proxyFrame:GetParent()
            proxyFrame:SetParent(nil)
            --proxyFrame:Hide() proxyFrame:Show()
            proxyFrame:SetParent(oldpar)
            if core.t then core.t:SetAttribute("initmenu", lastInitMenu); end
            --如果安全则不设置,否则要把这次LFD增加的按钮去掉
            --print(dropDownList1.numButtons, "isv = ", isv(dropDownList1, "numButtons")) --有时是不污染的
            if dropDownList1.numButtons then --and not isv(dropDownList1, "numButtons") then
                --去掉判断，是因为UIDropDownMenu_InitializeHelper在安全代码里设置numButtons为常量肯定是安全的
                --而且，如果运行到这里，说明UIDROPDOWN_MENU_LEVEL已经被污染了，之后只要AddButton就会污染numButtons，所以逻辑正确。
                --但是，存在一种情况，第三方插件调用时 UIDROPDOWN_MENU_LEVEL 未污染，则 cleanDropMenuLevel 就会导致 numButton 为 nil
                for j=1, dropDownList1.numButtons, 1 do
                    local button = _G["DropDownList1Button"..n2s(j)];
                    button:Hide();
                end
                --如果在加载期间设置，会导致污染
                if (HasLoadedCUFProfiles() and CompactUnitFrameProfiles.variablesLoaded) or U1IsAddonEnabled("CompactRaid") then
                    dropDownList1.numButtons = 0
                    dropDownList1.maxWidth = 0 --清理宽度
                end
                --numButtons 在 InitializeHelper 和 UIDropDownMenu_Refresh 会被安全的设置为 0
                --如果这里设置为0, 则初始化时，暴雪的插件直接调用 UIDropDownMenu_SetSelectedValue, 然后在 UIDropDownMenu_Refresh 中 就会污染
                --如果在 UIDropDownMenu_Initialize 把 numButtons 清理掉，则会报 nil 的错误
                --目前是在LoadAddOn之后立刻清理
            end
            --print("UIDROPDOWNMENU_MENU_LEVEL cleaned", "level=", (isv("UIDROPDOWNMENU_MENU_LEVEL")), "tot=", (isv("SHOW_TARGET_OF_TARGET_STATE")), "groupMode=",(isv(CompactRaidFrameContainer, "groupMode")))
        end
        --if not doNotCleanNumButtons then --InitializeHelper里绝对不能清理numButtons
            --print(isv(dropDownList1, "numButtons"), isv(DropDownList1, "numButtons"))
            --if not isv(dropDownList1, "numButtons") then dropDownList1.numButtons = nil end
            --if not isv(dropDownList1, "maxWidth") then dropDownList1.maxWidth = nil end
        --end
    end

    --第一时间清理掉 UIDROPDOWNMENU_MENU_LEVEL, 否则战场初次加载插件的时候就会有问题
    local cycle
    hooksecurefunc("UIDropDownMenu_InitializeHelper", function()
        if(cycle or core.leavingWorld or dropDownList1:IsVisible()) then return end --or UIDROPDOWNMENU_MENU_LEVEL ~= 1
        cycle = true
        --if not core.variableLoaded or not core.playerLogin then U1NoTaintCleanAll() else cleanDropMenuLevel() end --暂时不调用cleanAll，因为会清掉maxWidth导致报错
        tracingInfo = "helper"
        cleanDropMenuLevel();
        if not core.variableLoaded or not core.playerLogin then
            --这里如果不处理，那么就会导致4.3的CompactRaid被污染
            for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
                local dropDownList = _G["DropDownList"..n2s(i)];
                cleanDrop(dropDownList);
            end
        end
        cycle = nil
        if core.s then cleanObject(core.s) end
        --if core.t and not dropDownList1:IsVisible() then core.t:SetAttribute("openmenu", nil) end --这里肯定不能调用，因为ToggleDropDown先设置openmenu，再调用Initialize
        --print("UIDropDownMenu_InitializeHelper", isv("UIDROPDOWNMENU_MENU_LEVEL"))
        --RunOnNextFrameKey("U1Core_cleanNumButtons", cleanNumButtons)
    end)

    --Intialize之后意味着AddButton都执行完了，第一时间清理掉 secureInfo
    hooksecurefunc("UIDropDownMenu_Initialize", function()
        if core.leavingWorld then return end
        if core.s then cleanObject(core.s) end
        local stack = debugstack(3, 1, 0)
        if stack and (stack:find("`ToggleDropDownMenu'") or stack:find("\\ScenarioFinder%.lua"))then
            --之后会调用listFrame:Show(), 不进行处理
            RunOnNextFrameKey("U1NoTaintCleanAll", U1NoTaintCleanAll)
        else
            --print("UIDropDownMenu_Initialize", debugstack(3, 1, 0))
            --U1NoTaintCleanAll() --如果Initialize接着执行SetSelected就会出问题，因为UIDropDownMenu_Refresh，尝试Hook Refresh没成功
            RunOnNextFrameKey("U1NoTaintCleanAll", U1NoTaintCleanAll)
        end
    end)

    ---------------------- 当菜单隐藏时的清理 ------------------------
    -- 如果没有这个处理，则先打开界面，然后再打开其他插件的菜单就会出问题
    do
        -- 菜单隐藏分为两种情况，一个是在 UIDropDownMenuButton_OnClick 里，先隐藏后执行func，另一个是普通隐藏
        -- 新的实现是通过按钮的PreClick来判断，之前的实现是通过debugstack，都很2

        -- 在 OnHide 的时候调用，需要清理level和openmenu，基本上相当于CleanAll
        local function cleanDropAndLevel(drop)
            cleanDrop(drop) --代码顺序为什么要把cleanDrop放在上面? 不然会报numButtons==nil的错误
            --drop.numButtons = nil
            cleanDropMenuLevel()
        end

        --和 clearOnHide 配合的
        hooksecurefunc("UIDropDownMenuButton_OnClick", function(self)
            if(not self:GetParent():IsVisible()) then
                --print(self:GetParent():GetName(), "clear UIDropDownMenuButton_OnClick")
                tracingInfo = "click"
                cleanDropAndLevel(self:GetParent())
            end
        end)

        local __anyButtonClicked; --这个是一个全局性的，一但点击一个DropDownButton

        local function clearOnHide(self)
            --print("clearOnHide", __anyButtonClicked)
            if core.leavingWorld then return end
            --因为UIDropDownMenuButton_OnClick里是先Hide然后才运行button的func，所以清理要放到UIDropDownMenuButton_OnClick里
            --由于一次点击可能引起多个list的隐藏，所以只要有 __anyButtonClicked 就只清非当前list的data，click按钮的父list会在OnClick里清
            if(__anyButtonClicked) then
                --被点击的会在 UIDropDownMenuButton_OnClick 里清掉，所以这里是 ~=self
                if __anyButtonClicked ~= self then
                    --print(self:GetName(), "cleanDrop OnHide");
                    cleanDrop(self)
                end
            else
                --print(self:GetName(), "cleanDropAndLevel OnHide");
                tracingInfo = "hide"
                cleanDropAndLevel(self) --不是点击引发的隐藏 --似乎不需要RunOnNext了
            end
        end

        local function buttonOnPreClick(self)
            --print(self:GetName(), self:GetParent():GetName(), "OnPreClick");
            __anyButtonClicked = self:GetParent() --设置当前可能是点击按钮导致的隐藏
        end
        local function buttonHookClick(self)
            __anyButtonClicked = nil --清理掉标记
        end

        --添加隐藏事件
        hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
            for i=1, UIDROPDOWNMENU_MAXLEVELS do
                local dropDownList = _G["DropDownList"..n2s(i)];
                if not dropDownList.__hooked then
                    dropDownList.__hooked = 1
                    dropDownList:HookScript("OnHide", clearOnHide)
                end
                for j=1, UIDROPDOWNMENU_MAXBUTTONS do
                    local button = _G["DropDownList"..n2s(i).."Button"..n2s(j)]
                    if not button.__hooked then
                        button.__hooked = 1
                        button:SetScript("PreClick", buttonOnPreClick)
                        button:HookScript("OnClick", buttonHookClick)
                    end
                end
            end
        end)
    end
    -----------------------------------------------------------------------

    ---清理全部
    function U1NoTaintCleanAll()

        --先清理 UIDROPDOWNMENU_MENU_LEVEL，应该在前面执行
        tracingInfo = "all"
        cleanDropMenuLevel()

        if not dropDownList1:IsVisible() then
            --清理所有对象，其中会清理掉 openmenu
            for i = 1, UIDROPDOWNMENU_MAXLEVELS, 1 do
                local dropDownList = _G["DropDownList"..n2s(i)];
                cleanDrop(dropDownList);
                --dropDownList.numButtons = nil; --这里不清除也可以的
                --dropDownList.maxWidth = nil; --这里清除了会导致LoseControl报错
            end

            if core.t then
                core.t:SetAttribute("openmenu", nil)
                core.t:SetAttribute("initmenu", nil)
            end
        end

        --清理secureInfo, 这里其实不需要执行，保险起见吧.
        if core.s then cleanObject(core.s) end
        --print("all cleaned", isv("UIDROPDOWNMENU_MENU_LEVEL"), isv("SHOW_TARGET_OF_TARGET_STATE"), isv(CompactRaidFrameContainer, "groupMode"))
    end

    --在加载完插件之后全部清除一次，其实用处不大
    local NT_EVENTS, NT_OBJ = { "LOGIN_ADDONS_LOADED", "SOME_ADDONS_LOADED", }, {}
    for _, v in ipairs(NT_EVENTS) do
        NT_OBJ[v] = U1NoTaintCleanAll;
        CoreAddEvent(v); CoreRegisterEvent(v, NT_OBJ)
    end

    --一些特殊操作需要保证安全的地方
    local needPreClicks = {InterfaceOptionsFrameCancel, InterfaceOptionsFrameOkay, GameMenuButtonOptions, GameMenuButtonUIOptions, GameMenuButtonKeybindings, GameMenuButtonMacros, CompactRaidFrameManagerDisplayFrameOptionsButton }
    for _, v in ipairs(needPreClicks) do v:SetScript("PreClick", U1NoTaintCleanAll) end
    --OpenToCategory之间调用的
    hooksecurefunc("InterfaceOptionsFrame_TabOnClick", U1NoTaintCleanAll)

--[[
    --如果没有此处，则初始化时，暴雪的插件直接调用 UIDropDownMenu_SetSelectedValue, 然后在 UIDropDownMenu_Refresh 中读取 numButtons 就会污染
    --是由于Blizzard_CUFProfiles中的事件COMPACT_UNIT_FRAME_PROFILES_LOADED读取MENU_LEVEL导致的，因为这个事件是在PLAYER_LOGIN之后，
    --而我们在PLAYER_LOGIN后会触发LOGIN_ADDONS_LOADED把所有单体插件的污染清除，所以现在注释掉了
    hooksecurefunc("LoadAddOn", function(name)
        if name and not name:find("^Blizzard_") then --每次输入命令ChatFrame都会调用UIParentLoadAddOn()
            U1NoTaintCleanAll()
            dropDownList1.numButtons = nil;
        end
    end)
]]

end

if deal_taint_options then
    --- ---------------- 界面选项污染问题 ------------
    -- 需要搜索所有的 InterfaceOptionsFrameAddOns 改成 InterfaceOptionsFrameAddOns2
    local SecureNext = next
    local INTERFACEOPTIONS_ADDONCATEGORIES = {}

    local ButtonOnMouseWheel = function(self, delta)
        local bar = _G[self:GetParent():GetName() .. "ListScrollBar"]
        bar:SetValue(bar:GetValue() - (delta * self:GetHeight() * (IsModifierKeyDown() and 10 or 1)))
    end
        
    local displayedElements = {}
    function InterfaceAddOnsList_Update2 ()
        -- Might want to merge this into InterfaceCategoryList_Update depending on whether or not things get differentiated.
        local offset = FauxScrollFrame_GetOffset(InterfaceOptionsFrameAddOns2List);
        local buttons = InterfaceOptionsFrameAddOns2.buttons;
        local element;

        for i, element in SecureNext, displayedElements do
            displayedElements[i] = nil;
        end

        for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            if ( not element.hidden ) then
                tinsert(displayedElements, element);
            end
        end

        local numAddOnCategories = #displayedElements;
        local numButtons = #buttons;

        -- Show the AddOns tab if it's not empty.
        if ( ( InterfaceOptionsFrameTab2 and not InterfaceOptionsFrameTab2:IsShown() ) and numAddOnCategories > 0 ) then
            InterfaceOptionsFrameCategoriesTop:Hide();
            InterfaceOptionsFrameAddOnsTop:Hide();
            InterfaceOptionsFrameTab1:Show();
            InterfaceOptionsFrameTab2:Show();
        end

        if ( numAddOnCategories > numButtons and ( not InterfaceOptionsFrameAddOns2List:IsShown() ) ) then
            -- We need to show the scroll bar, we have more elements than buttons.
            OptionsList_DisplayScrollBar(InterfaceOptionsFrameAddOns2);
        elseif ( numAddOnCategories <= numButtons and ( InterfaceOptionsFrameAddOns2List:IsShown() ) ) then
            -- Hide the scrollbar, there's nothing to scroll.
            OptionsList_HideScrollBar(InterfaceOptionsFrameAddOns2);
        end

        FauxScrollFrame_Update(InterfaceOptionsFrameAddOns2List, numAddOnCategories, numButtons, buttons[1]:GetHeight());

        local selection = InterfaceOptionsFrameAddOns2.selection;
        if ( selection ) then
            OptionsList_ClearSelection(InterfaceOptionsFrameAddOns2, InterfaceOptionsFrameAddOns2.buttons);
        end

        for i = 1, #buttons do
            element = displayedElements[i + offset]
            if not buttons[i]:IsMouseWheelEnabled() then
                buttons[i]:EnableMouseWheel()
                buttons[i]:SetScript("OnMouseWheel", ButtonOnMouseWheel)
            end
            if ( not element ) then
                OptionsList_HideButton(buttons[i]);
            else
                OptionsList_DisplayButton(buttons[i], element);

                if ( selection ) and ( selection == element ) and ( not InterfaceOptionsFrameAddOns2.selection ) then
                    OptionsList_SelectButton(InterfaceOptionsFrameAddOns2, buttons[i]);
                end
            end
        end

        if ( selection ) then
            InterfaceOptionsFrameAddOns2.selection = selection;
        end
    end

    function InterfaceOptionsListButton_ToggleSubCategories2 (self)
        local element = self.element;

        element.collapsed = not element.collapsed;
        local collapsed = element.collapsed;

        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            if ( category.parent == element.name ) then
                if ( collapsed ) then
                    category.hidden = true;
                else
                    category.hidden = false;
                end
            end
        end

        InterfaceAddOnsList_Update2();
    end

    function InterfaceOptionsListButton_OnClick2 (self, mouseButton)
        if ( mouseButton == "RightButton" ) then
            if ( self.element.hasChildren ) then
                OptionsListButtonToggle_OnClick(self.toggle);
            end
            return;
        end

        local parent = self:GetParent();
        local buttons = parent.buttons;

        OptionsList_ClearSelection(InterfaceOptionsFrameCategories, InterfaceOptionsFrameCategories.buttons);
        OptionsList_ClearSelection(InterfaceOptionsFrameAddOns2, InterfaceOptionsFrameAddOns2.buttons);
        OptionsList_SelectButton(parent, self);

        InterfaceOptionsList_DisplayPanel2(self.element);
    end

    function InterfaceOptionsList_DisplayPanel2(frame)
        if ( InterfaceOptionsFramePanelContainer.displayedPanel ) then
            InterfaceOptionsFramePanelContainer.displayedPanel:Hide();
            InterfaceOptionsFramePanelContainer.displayedPanel = nil;
        end
        if ( InterfaceOptionsFramePanelContainer.displayedPanel2 ) then
            InterfaceOptionsFramePanelContainer.displayedPanel2:Hide();
        end

        InterfaceOptionsFramePanelContainer.displayedPanel2 = frame;

        frame:SetParent(InterfaceOptionsFramePanelContainer);
        frame:ClearAllPoints();
        frame:SetPoint("TOPLEFT", InterfaceOptionsFramePanelContainer, "TOPLEFT");
        frame:SetPoint("BOTTOMRIGHT", InterfaceOptionsFramePanelContainer, "BOTTOMRIGHT");
        frame:Show();
    end

    --暴雪在初始化之后就不会再调用 InterfaceOptions_AddCategory 了
    setfenv(InterfaceOptions_AddCategory, setmetatable({
        INTERFACEOPTIONS_ADDONCATEGORIES = INTERFACEOPTIONS_ADDONCATEGORIES,
        InterfaceAddOnsList_Update = InterfaceAddOnsList_Update2
    }, {__index=_G}))

    _G["InterfaceOptionsFrameAddOns"]:HookScript("OnShow", function() InterfaceOptionsFrameAddOns2:Show() end)
    _G["InterfaceOptionsFrameAddOns"]:HookScript("OnHide", function() InterfaceOptionsFrameAddOns2:Hide() end)

    hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)
    --外围的判断条件是原函数所没有的
    --如果是从 InterfaceOptionsFrame_OnShow 里调用过来的，则如果之前的面板是 displayedPanel2 则再次调用 InterfaceOptionsFrame_OpenToCategory
    --参见 hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", 的说明
    --不能写到 InterfaceOptionsFrame_OpenToCategory 的posthook中，因为会清掉displayPanel2
    --CONTROLS_LABEL 是没有上次打开选项页时候的默认选项页
        local ct = InterfaceOptionsFramePanelContainer
        if(frame and frame.name==CONTROLS_LABEL and debugstack():find("InterfaceOptionsFrame_OpenToCategory")) then
            if ( ct.displayedPanel2 ) then
                if ( ct.displayedPanel ) then
                    ct.displayedPanel:Hide();
                    ct.displayedPanel = nil;
                end
                InterfaceOptionsFrame_OpenToCategory(ct.displayedPanel2)
            end
        else
            --这里是兼容IOF_OTC方法的，如果上次打开的是系统面板，则再次打开就不隐藏
            if ( ct.displayedPanel2 and ct.displayedPanel2 ~= ct.displayedPanel) then
                ct.displayedPanel2:Hide();
                ct.displayedPanel2 = nil;
            end
        end
    end)

    hooksecurefunc("InterfaceOptionsFrame_OpenToCategory", function(panel)
    --主要问题是, InterfaceOptionsFrame_Show 会调用 InterfaceOptionsFrame_OnShow
    --而对于我们的hack面板，InterfaceOptionsFramePanelContainer.displayedPanel 始终是nil，所以会再次调用InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL)
    --我的处理方法是在 InterfaceOptionsFrame_OpenToCategory 调用 InterfaceOptionsList_DisplayPanel 的时候，再次选择一次，而此时不会触发 InterfaceOptionsFrame_OnShow
    --参见 hooksecurefunc("InterfaceOptionsList_DisplayPanel", function(frame)

        local panelName;
        if ( type(panel) == "string" ) then
            panelName = panel;
            panel = nil;
        end

        assert(panelName or panel, 'Usage: InterfaceOptionsFrame_OpenToCategory("categoryName" or panel)');

        local blizzardElement, elementToDisplay

        if ( not elementToDisplay ) then
            for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
                if ( element == panel or (panelName and element.name and element.name == panelName) ) then
                    elementToDisplay = element;
                    break;
                end
            end
        end

        if ( not elementToDisplay ) then
            return;
        end

        --if ( blizzardElement ) then
        InterfaceOptionsFrameTab2:Click();
        local buttons = InterfaceOptionsFrameAddOns2.buttons;
        for i, button in SecureNext, buttons do
            if ( button.element == elementToDisplay ) then
                InterfaceOptionsListButton_OnClick2(button);
            elseif ( elementToDisplay.parent and button.element and (button.element.name == elementToDisplay.parent and button.element.collapsed) ) then
                OptionsListButtonToggle_OnClick(button.toggle);
            end
        end

        if ( not InterfaceOptionsFrame:IsShown() ) then
            InterfaceOptionsFrame_Show();
        end

        U1NoTaintCleanAll();
    --end
    end)

    InterfaceOptionsFrame:HookScript("OnShow", function(self)
    --刷新hack的插件选项列表
    --参见 InterfaceOptionsFrame_OnShow
    --打开上次面板InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL)是通过 InterfaceOptionsList_DisplayPanel 的Hook处理的
        InterfaceAddOnsList_Update2();
        InterfaceOptionsOptionsFrame_RefreshAddOns2();
    end)

    local function InterfaceOptionsFrame_RunOkayForCategory (category)
        pcall(category.okay, category);
    end

    local function InterfaceOptionsFrame_RunDefaultForCategory (category)
        pcall(category.default, category);
    end

    local function InterfaceOptionsFrame_RunCancelForCategory (category)
        pcall(category.cancel, category);
    end

    local function InterfaceOptionsFrame_RunRefreshForCategory (category)
        pcall(category.refresh, category);
    end

    InterfaceOptionsFrameOkay:HookScript("OnClick", function (self, button, apply)
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunOkayForCategory, category);
        end
        U1NoTaintCleanAll();
    end)

    InterfaceOptionsFrameCancel:HookScript("OnClick", function (self, button)
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunCancelForCategory, category);
        end
        U1NoTaintCleanAll();
    end)

    hooksecurefunc("InterfaceOptionsFrame_SetAllToDefaults", function()
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunDefaultForCategory, category);
        end
        InterfaceOptionsOptionsFrame_RefreshAddOns2();
    end)

    hooksecurefunc("InterfaceOptionsFrame_SetCurrentToDefaults", function()
        local displayedPanel = InterfaceOptionsFramePanelContainer.displayedPanel2;
        if ( not displayedPanel or not displayedPanel.default ) then
            return;
        end

        displayedPanel.default(displayedPanel);
        --Run the refresh method to refresh any values that were changed.
        displayedPanel.refresh(displayedPanel);
        U1NoTaintCleanAll();
    end)

    function InterfaceOptionsOptionsFrame_RefreshAddOns2()
        for _, category in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
            securecall(InterfaceOptionsFrame_RunRefreshForCategory, category);
        end
        U1NoTaintCleanAll();
    end

    --InterfaceOptionsFrame_OpenToCategory
    --/run CoreIOF_OTC(InterfaceOptionsCombatPanel)
    function CoreIOF_OTC(panel)
        U1NoTaintCleanAll();
        InterfaceOptionsFrame:Show();
        if type(panel)=="string" then
            for i, element in SecureNext, INTERFACEOPTIONS_ADDONCATEGORIES do
                if ( panel and element.name and element.name == panel ) then
                    InterfaceOptionsList_DisplayPanel2(element)
                    return
                end
            end
        else
            InterfaceOptionsList_DisplayPanel2(panel)
        end
    end
    --hooksecurefunc("InterfaceOptionsOptionsFrame_RefreshAddOns", InterfaceOptionsOptionsFrame_RefreshAddOns2) --测试过，不用这句，只有OnShow和InterfaceOptionsFrame_SetAllToDefaults的时候用
else
    CoreIOF_OTC = InterfaceOptionsFrame_OpenToCategory
end


--[[--------------------------------------------
Deal with StaticPopup_Show()
/run StaticPopup_Show('PARTY_INVITE',"test")
----------------------------------------------]]
if deal_taint_other then
    local function hook()
        PlayerTalentFrame_Toggle = function()
            if ( not PlayerTalentFrame:IsShown() ) then
                ShowUIPanel(PlayerTalentFrame);
                TalentMicroButtonAlert:Hide();
            else
                PlayerTalentFrame_Close();
            end
        end

        for i=1, 10 do
            local tab = _G["PlayerTalentFrameTab"..i];
            if not tab then break end
            tab:SetScript("PreClick", function()
                --print("PreClicked")
                for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
                    local frame = _G["StaticPopup"..index];
                    if(not issecurevariable(frame, "which")) then
                        local info = StaticPopupDialogs[frame.which];
                        if frame:IsShown() and info and not issecurevariable(info, "OnCancel") then
                            info.OnCancel()
                        end
                        frame:Hide()
                        frame.which = nil
                    end
                end
            end)
        end
    end

    if(IsAddOnLoaded("Blizzard_TalentUI")) then
        hook()
    else
        local f = CreateFrame("Frame")
        f:RegisterEvent("ADDON_LOADED")
        f:SetScript("OnEvent", function(self, event, addon)
            if(addon=="Blizzard_TalentUI")then
                self:UnregisterEvent("ADDON_LOADED")
                hook()
            end
        end)
    end
end

--[[----------------------------------------------------
-- Deal with FCF_StartAlertFlash
-- which is called only in ChatFrame_MessageEventHandler
-- (removed because LibChatAnim make a whole FCF_StartAlertFlash)
if deal_taint_other then
    local function FCFTab_UpdateAlpha(chatFrame, alerting)
        local chatTab = _G[chatFrame:GetName().."Tab"];
        local mouseOverAlpha, noMouseAlpha
        if ( not chatFrame.isDocked or chatFrame == FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK) ) then
            mouseOverAlpha = CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA;
            noMouseAlpha = CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA;
        else
            if ( alerting ) then
                mouseOverAlpha = CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA;
                noMouseAlpha = CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA;
            else
                mouseOverAlpha = CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA;
                noMouseAlpha = CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA;
            end
        end

        -- If this is in the middle of fading, stop it, since we're about to set the alpha
        UIFrameFadeRemoveFrame(chatTab);

        if ( chatFrame.hasBeenFaded ) then
            chatTab:SetAlpha(mouseOverAlpha);
        else
            chatTab:SetAlpha(noMouseAlpha);
        end
    end

    function FCF_StartAlertFlash(chatFrame)
        if ( chatFrame.minFrame ) then
            UICoreFrameFlash(chatFrame.minFrame.glow, 1.0, 1.0, -1, false, 0, 0, nil);

            --chatFrame.minFrame.alerting = true;
        end

        local chatTab = _G[chatFrame:GetName().."Tab"];
        UICoreFrameFlash(chatTab.glow, 1.0, 1.0, -1, false, 0, 0, nil);

        --chatTab.alerting = true;

        FCFTab_UpdateAlpha(chatFrame, true);

        --FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton);
    end

    hooksecurefunc("FCF_StopAlertFlash", function(chatFrame)
        if ( chatFrame.minFrame ) then
            UICoreFrameFlashStop(chatFrame.minFrame.glow);

            --chatFrame.minFrame.alerting = false;
        end

        local chatTab = _G[chatFrame:GetName().."Tab"];
        UICoreFrameFlashStop(chatTab.glow);

        --chatTab.alerting = false;

        FCFTab_UpdateAlpha(chatFrame, false);

        --FCFDockOverflowButton_UpdatePulseState(GENERAL_CHAT_DOCK.overflowButton);
    end)
end
-------------------------------------------------------]]

-- ======================= 污染问题 end ==========================