local U1Name, U1 = ...
local DataBroker = LibStub'LibDataBroker-1.1'
local L = U1.L

U1_FRAME_NAME = "U1Frame";

UUI = UUI or {}
UUI.Main, UUI.Right, UUI.Center, UUI.Left, UUI.Top = {}, {}, {}, {}, {}
setmetatable(UUI, {__call = function() return _G[U1_FRAME_NAME] end})

UUI.DropDownItems = U1_QuickMenus or {}

--[[------------------------------------------------------------
配置常量
---------------------------------------------------------------]]
UUI.URL = "https://github.com/aby-ui/repo-base";
UUI.DEFAULT_ICON = "Interface\\HelpFrame\\HelpIcon-CharacterStuck" --"Interface\\HelpFrame\\HelpIcon-KnowledgeBase"  --"Interface\\Icons\\INV_Misc_QuestionMark" --[[Interface\ICONS\INV_Egg_07]]
UUI.PICS_ADDON = "!!!163UI.pics!!!"

UUI.MAX_COL = 5
UUI.BUTTON_W = 192
UUI.BUTTON_H = 48
UUI.ICON_W = 38
UUI.CHECK_W = 26;
UUI.BUTTON_OFFSET = 10
UUI.BUTTON_P = 10;  --中央按钮间隔
UUI.CENTER_COLS = 2;
UUI.CENTER_TEXT_LEFT = UUI.ICON_W + 8

UUI.PANEL_BUTTON_HEIGHT = 22
UUI.BORDER_WIDTH = 12
UUI.LEFT_WIDTH = 120-UUI.BORDER_WIDTH
UUI.TOP_HEIGHT = 55-UUI.BORDER_WIDTH
UUI.RIGHT_WIDTH = 275-UUI.BORDER_WIDTH

UUI.DEFAULT_TAG = UI163_USER_MODE and "ALL" or "ABYUI"

UUI.FONT_PANEL_BUTTON = "U1FPanelButtonHei"
WW:Font3(UUI.FONT_PANEL_BUTTON, U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 14.1 or 12.1, {{1,.82,0},{1,1,1},{.5,.5,.5}}, nil, 1, -1)
WW:Font3("U1FBannerHei", U1.CN and ChatFontNormal or GameFontNormal, 16, {{.91,.72,0},{1,1,1},{.5,.5,.5}}, nil, 1, -1)
WW:Font3("U1F_LeftTags", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 14.1 or 12.1, {{0.81, 0.65, 0.48},{1,1,1},{.5,.5,.5}}, nil, 1, -1)
WW:Font("U1FCenterTextMid", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 14.1 or 12.1):SetFontFlags():SetShadowOffset(2,-2):un();
WW:Font("U1FCenterTextTiny", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 11 or 9):SetShadowOffset(1,-2):un();
WW:Font("U1FTextTinyOUTLINE", ChatFontNormal, 11):SetFontFlags("OUTLINE"):un();

--[[------------------------------------------------------------
不属于任何区域的函数
---------------------------------------------------------------]]
function UUI.Tex(name)
    return "Interface\\AddOns\\"..U1Name.."\\Textures\\"..name
end

local dropDownFuncCheck = function(self, arg1, arg2, on) CtlRegularSaveValue(self, on and 1 or nil, arg1) end
local dropDownFuncAddon = function(self, arg1, arg2, on) U1ToggleAddon(arg1, on) end

---把Config统一转换成info, 只支持check
function UUI.TransCfgToDropDown(path, info)
    local path, flagAlways = strsplit(",", path)
    local pos = path:find("/");
    assert(pos, "parameter #1 should be addon/path!")
    local addon, path = path:sub(1,pos-1), path:sub(pos+1)
    if select(5, GetAddOnInfo(addon))=="MISSING" and not flagAlways then return end
    if path=="" then
        info = info or UIDropDownMenu_CreateInfo()
        table.wipe(info);
        info.isNotRadio = true;
        info.keepShownOnClick = true;
        info.notCheckable = nil;
        info.checked = U1IsAddonEnabled(addon)
        info.func = dropDownFuncAddon;
        info.text = L["插件："]..U1GetAddonTitle(addon)
        info.fontObject = "CtlFontNormalSmall";
        info.arg1 = addon;
        info.tooltipTitle=L["快速启用/停用插件"];
        info.tooltipText=nil;
    else
        if (not U1IsAddonInstalled(addon) and not flagAlways) or (not UI163_USER_MODE and not U1IsAddonRegistered(addon)) then return end
        if not IsAddOnLoaded(addon) and not flagAlways then return end
        if addon == U1Name:lower() and (path=="sortmem" or path=="english") and not UUI():IsVisible() then return end

        info = info or UIDropDownMenu_CreateInfo()
        --info.tooltipOnButton = 1;
        info.isNotRadio = nil;
        info.keepShownOnClick = true;
        info.notCheckable = nil;
        local value, cfg = U1GetCfgValue(addon, path, 1)
        if not cfg then return end
        if cfg.type == "checkbox" then
            info.isNotRadio = true;
            info.checked = value;
        elseif cfg.type == "button" then
            info.keepShownOnClick = nil;
        end
        info.func = dropDownFuncCheck;
        info.text = cfg.text;
        info.fontObject = "CtlFontNormalSmall";
        info.arg1 = cfg;
        CtlRegularTip(info, cfg);
        info.tooltipTitle=cfg.tipLines and cfg.tipLines[1].."|cff00d200 ("..U1GetAddonTitle(addon)..")|r"
        info.tooltipText=cfg.tipLines and table.concat(cfg.tipLines, "\n", 2)
    end
    UIDropDownMenu_AddButton(info);
end

---根据Cols修改界面元素
UUI.changeWithCols = {}
function UUI.AddChangeWithCols(obj, func)
    UUI.changeWithCols[obj] = func;
end
function UUI.ToggleLongShortText(cols, obj)
    local long, short = obj.textLong, obj.textShort;
    WW(obj):SetText(format(cols<=1 and short or long)):AutoWidth():un();
    obj:SetWidth(obj:GetWidth() + 4)
end
function UUI.AddChangeWithColsButton(obj, ...)
    obj:SetText(...)
    obj:SetWidth(obj:GetFontString():GetStringWidth()+(obj.mid and 12 or 0));
    obj.textLong, obj.textShort = ...
    UUI.AddChangeWithCols(obj, UUI.ToggleLongShortText)
end
function UUI.ChangeWithCols()
    for k, v in pairs(UUI.changeWithCols) do v(UUI().center.cols, k) end
    --RunOnNextFrame(CoreCall, "U1_MMBUpdateUI")
end

---重载界面按钮闪烁
--@param from checkBox从哪里开始移动
--@param enable checkBox的状态
function UUI.ReloadFlash(from, enable)
    local f = UUI();
    if(next(U1GetReloadList()))then
        f.animCheck:SetChecked(enable)
        f.animCheck.anim:Stop();
        local left1, top1 = f.reload:GetCenter();
        local left2, top2 = from:GetCenter();
        f.animCheck.anim.move:SetOffset(left1-left2, top1-top2)
        f.animCheck.anim.size:SetScale(f.reload:GetWidth()/ from:GetWidth(), f.reload:GetHeight()/ from:GetHeight())
        f.animCheck:ClearAllPoints();
        f.animCheck:SetAllPoints(from);
        f.animCheck:Show();
        f.animCheck:SetFrameLevel(1000);
        f.animCheck.anim:Play();
    end
    UUI.ReloadFlashRefresh();
end

function UUI.ReloadFlashRefresh()
    local flash = UUI().reload.flash
    ActionButton_HideOverlayGlow(flash);
    if(next(U1GetReloadList()))then
        ActionButton_ShowOverlayGlow(flash);
    end
end

---将主面板显示在最上层, 如果raise是false则显示在最下层
function UUI.Raise(raise)
    if(U1ProfileFrame and U1ProfileFrame:IsVisible()) then U1ProfileFrame:Hide() end
    local main = UUI();
    if(raise~=false)then
        main:SetFrameStrata("DIALOG");
        main:SetFrameLevel(0);
        main:Raise();
        if(main:GetFrameLevel()>100) then
            main:SetFrameLevel(30);
        end
    else
        if GameMenuFrame:IsVisible() then
            HideUIPanel(GameMenuFrame);
        else
            main:SetFrameStrata("MEDIUM");
            main:Lower();
        end
    end
end

---设置移动本层时可以移动主框架
function UUI.MainStartMoving() UUI():StartMoving() end
function UUI.MainStopMoving() UUI():StopMovingOrSizing() end
function UUI.MakeMove(frame)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", UUI.MainStartMoving)
    frame:SetScript("OnDragStop", UUI.MainStopMoving)
    frame:HookScript("OnMouseDown", UUI.Raise)
end

---点击启用/关闭插件的CheckButton
function UUI.ClickAddonCheckBox(self, name, enable, subgroup)
    if(not subgroup and U1GetSelectedAddon()~=name) then U1SelectAddon(name, true) end --不然点了以后会因为AddonLoaded滚动到顶上
    local deepToggleChildren = IsControlKeyDown()
    if enable and not IsAddOnLoaded(name) then
        --当真正加载时，打开全部子插件, 除非同时按CTRL+ALT
        deepToggleChildren = not (IsControlKeyDown() and IsAltKeyDown())
        if deepToggleChildren then
            --dummy的仅当一个子插件都没开的时候才全开
            local info = U1GetAddonInfo(name)
            if info and info.dummy then
                local hasOne
                for k, sub in U1IterateAllAddons() do
                    if sub.parent==name and U1IsAddonEnabled(k) then hasOne = true end
                end
                if hasOne then deepToggleChildren = IsControlKeyDown() end
            end
        end
    end

    --todo: 临时的冲突处理
    local info = U1GetAddonInfo(name)
    if info then
        local other_loaded = false
        for _, other in ipairs(info.conflicts or _empty_table) do
            if IsAddOnLoaded(other) then
                DisableAddOn(other)
                other_loaded = true
            end
        end
        if other_loaded then EnableAddOn(name) return ReloadUI() end
    end

    local needReload = U1ToggleAddon(name, enable, nil, deepToggleChildren);
    UUI.ReloadFlash(self, enable);
    if(not subgroup) then
        UUI.Right.ADDON_SELECTED()
    end
    UUI.Center.Refresh();
end

---根据cols重新设置合适的宽度
function UUI.SizeFitCols()
    local main = UUI();
    main:SetWidth(UUI.CalcWidth(main.center.cols));
    main:SetMinResize(UUI.CalcWidth(1), UUI.TOP_HEIGHT + (UUI.BUTTON_H + UUI.BUTTON_OFFSET)*3 + 110)
    main:SetMaxResize(UUI.CalcWidth(UUI.MAX_COL), UUI.TOP_HEIGHT + (UUI.BUTTON_H + UUI.BUTTON_OFFSET)*15 + 105)
end
function UUI.CalcWidth(cols)
    return UUI.LEFT_WIDTH + (UUI.BUTTON_W + UUI.BUTTON_P) * cols + UUI.RIGHT_WIDTH + 48;
end

function UUI.formatTip(label, text)
    return format("|cffffff7f%s:|r %s", label, text);
end
function UUI.getAddonStatus(parent, loaded, enabled, reason, lod, protected)
    local status, reasonInfo
    if loaded then
        lod = lod and protected or nil --已加载的不关心是否按需载入
        if(not enabled) then
            status = L["已加载,重启后停用"]
        else
            status = L["|cff00D100已加载|r"]
        end
    elseif reason == "MISSING" then
        status = L["|cffff0000未安装|r"]
    elseif not enabled then
        status = L["|cffA0A0A0未启用|r"]
    elseif(not reason or lod) then
        status = lod and L["已启用"] or L["已启用,需重新加载"]
    else
        if parent and reason=="DEP_DISABLED" then
            status = L["|cffA0A0A0依赖插件未启用|r"]
        else
            status = L["|cffff7f7f启用失败|r"];
            reasonInfo = _G["U1REASON_"..reason] or reason;
        end
    end
    return status, reasonInfo, lod
end
function UUI.SetAddonTooltipChild(addonName, tip)
    local info = U1GetAddonInfo(addonName);
    if (info.dummy and U1IsAddonEnabled(addonName)) or IsAddOnLoaded(addonName) then
        for subName, subInfo in U1IterateAllAddons() do
            if subInfo.parent == addonName then --and not subInfo.hide then
                if (IsAddOnLoaded(subName))then
                    local mem = GetAddOnMemoryUsage(subName);
                    mem = mem > 1000 and format("%.2f MB", mem/1000) or format("%.0f KB", mem)
                    tip:AddDoubleLine(UUI.formatTip(L["子插件"],U1GetAddonTitle(subName)), mem, 1,1,1)
                    --TODO: 支持多级？
                end
            end
        end
    end
end
function UUI.SetAddonTooltip(addonName, tip)
    tip = tip or GameTooltip;
    local info = U1GetAddonInfo(addonName);
    local title = U1GetAddonTitle(addonName, false)
    local name, title, notes, _, reason = GetAddOnInfo(addonName)
    local enabled = GetAddOnEnableState(U1PlayerName,addonName)>=2
    local loaded = IsAddOnLoaded(name);

    if(InCombatLockdown()) then
        tip:AddLine(L["战斗中启用/停用插件可能会导致错误，重载界面后会正常。\n"], 1, .1, .1, 1);
    end

    if info.parent then
        tip:AddLine(L["子插件"]..": " .. (info.title or info.name))
    else
        tip:AddLine(info.title or info.name)
    end

    --if(info.name ~= info.title)then tip:AddDoubleLine(" ", info.name, 1, 1, 1, 1, 1, 1); end

    if info.parent then
        if(info.author)then
            if info.modifier then
                tip:AddDoubleLine(UUI.formatTip(L["作者"], info.author), UUI.formatTip(L["修改"], info.modifier), 1, 1, 1, true);
            else
                tip:AddLine(UUI.formatTip(L["作者"], info.author), 1, 1, 1, true);
            end
        end
        --if(info.author or info.modifier)then tip:AddLine("向原作者与修改者们致敬!", 1, 1, 0.5, true) end

        if(info.desc) then
            tip:AddLine(" ")
            if(type(info.desc)=="string") then
                info.desc = {strsplit("`", info.desc)};
            end
            if(type(info.desc)=="table") then
                for _, txt in ipairs(info.desc) do
                    tip:AddLine(txt, nil, nil, nil, true);
                end
            end
            tip:AddLine(" ")
        end
    else
        tip:AddLine(" ")
    end

    if(info.name ~= info.title)then tip:AddLine(UUI.formatTip(L["目录"], info.name), 1, 1, 1); end
    if(info.version)then tip:AddLine(UUI.formatTip(L["版本"], info.version), 1, 1, 1, true); end

    if(info.dummy) then
        tip:AddLine(L["爱不易插件集"], 0, 0.82, 0);
        return
    end

    local memTip, allmemTip
    if(loaded)then
        local _, subs, allmem = U1GetAddonModsAndMemory(name)
        local mem = GetAddOnMemoryUsage(name);
        mem = mem > 1000 and format("%.2f MB", mem/1000) or format("%.0f KB", mem)
        if subs > 0 then
            allmem = allmem > 1000 and format("%.2f MB", allmem/1000) or format("%.0f KB", allmem)
            allmemTip = UUI.formatTip(L["全部"], allmem)
        end
        memTip = UUI.formatTip(L["内存"], mem)
    end
    local status, reasonInfo, lod = UUI.getAddonStatus(info.parent, loaded, enabled, reason, info.lod, info.protected);
    tip:AddDoubleLine(UUI.formatTip(L["状态"], status), lod and L["|cff00D100按需载入|r"], 1, 1, 1)
    tip:AddDoubleLine(memTip, allmemTip, 1, 1, 1)
    UUI.SetAddonTooltipChild(addonName, tip)
    if(reasonInfo) then
        tip:AddLine(UUI.formatTip(L["原因"], reasonInfo), 1, .5, .5)
        local depNum = select("#", GetAddOnDependencies(name));
        if(depNum > 0) then
            for i=1, depNum do
                local depName = select(i, GetAddOnDependencies(name));
                local _, _, _, _, depReason = GetAddOnInfo(depName)
                local depEnabled = GetAddOnEnableState(U1PlayerName,name)>=2
                local status, reasonInfo = UUI.getAddonStatus(nil, IsAddOnLoaded(depName), depEnabled, depReason, IsAddOnLoadOnDemand(depName));
                tip:AddLine(UUI.formatTip(L["依赖"], depName.." "..(reasonInfo or status)), 1, 1, 1)
            end
        end
    end

    if UI163_USER_MODE then return end

    tip:AddLine(" ")
    if(not info.vendor)then
        tip:AddLine(L["单体插件"])
    else
        tip:AddLine(L["爱不易整合版"], 0, 0.82, 0)
    end
end

do
    local addons = {}
    local order = {}
    local last_tag = nil

    local function mem_sort(a, b)
        return addons[a] > addons[b]
    end

    local function fmt_mem(b)
        if(b > 1e3) then
            return string.format('%.1f m', b/1024)
        else
            return string.format('%d k', b)
        end
    end

    UUI.Left.TagButton_OnEnter = function(self)
        local tag = self.tag
        wipe(addons)
        if(tag ~= last_tag) then
            last_tag = tag
            wipe(order)

            -- addon list of current tag
            for addon, info in U1IterateAllAddons() do
                if(IsAddOnLoaded(addon) and U1AddonHasTag(addon, tag)) then
                    tinsert(order, addon)
                end
            end
        end

        -- get mem usage
        for _, name in ipairs(order) do
            local mem = GetAddOnMemoryUsage(name)
            addons[name] = mem
        end

        -- sort
        table.sort(order, mem_sort)

        -- display
        GameTooltip:SetOwner(self, 'ANCHOR_LEFT', 5, 0)
        local tag_name = select(3, U1GetTagInfoByName(tag))
        GameTooltip:AddLine(tag_name)
        GameTooltip:AddLine('    ')

        if(#order == 0) then
            GameTooltip:AddLine(L['|cffFFA3A3没有启用插件|r'])
        else
            for i = 1, math.min(#order , 10) do
                local addon = order[i]
                GameTooltip:AddDoubleLine('|cffB2E2FF'..U1GetAddonTitle(addon), '|cffB2FFC2'..fmt_mem(addons[addon]))
            end
        end

        GameTooltip:Show()
    end
end

UUI.Left.TagButton_OnLeave = function(self)
    GameTooltip:Hide()
end

--[[------------------------------------------------------------
左侧面板
---------------------------------------------------------------]]
function UUI.Left.Create(main)
    local left = main:Frame(nil, nil, "left"):TL(0, -UUI.TOP_HEIGHT-1):BR(main, "BL", UUI.LEFT_WIDTH, 0);

    left:Button():Key("btn163"):Size(128,32):TL(-14,-6):Set3Fonts("U1FBannerHei"):SetText(L[" 爱不易整合 "])
    :Texture(nil, nil, UUI.Tex'UI2-banner', 0,1,0,0.5):ToTexture("Normal"):ALL():up():un()
    left:Button():Key("btnSingle"):Size(128,32):BL(-14,16):Set3Fonts("U1FBannerHei"):SetText(UI163_USER_MODE and L["　其他插件　"] or L["　单体插件　"])
    :Texture(nil, nil, UUI.Tex'UI2-banner', 0,1,0.5,1):ToTexture("Normal"):TL(0,-1):BR(0,-1):up()
    :Texture(nil, nil, UUI.Tex'UI2-banner', 0,1,0.5,1):ToTexture("Disabled"):TL(0,-1):BR(0,-1):up()
    :un()

    left.btn163.tag = UUI.DEFAULT_TAG
    left.btn163:SetScript('OnClick', UUI.Left.ButtonOnClick)
    left.btn163:SetScript('OnEnter', UUI.Left.TagButton_OnEnter)
    left.btn163:SetScript('OnLeave', UUI.Left.TagButton_OnLeave)

    left.btnSingle.tag = 'SINGLE'
    left.btnSingle:SetScript('OnClick', UUI.Left.ButtonOnClick)
    left.btnSingle:SetScript('OnEnter', UUI.Left.TagButton_OnEnter)
    left.btnSingle:SetScript('OnLeave', UUI.Left.TagButton_OnLeave)
    --CoreUIDesaturateTexture(left.btnSingle:GetDisabledTexture());

    local scroll = CoreUICreateHybridStep1(nil, left(), nil, nil, nil, "LINE")
    UUI.MakeMove(scroll);
    left.scroll = scroll;
    WW(scroll):TL(3, -65):BR(0, 75):SetSize(110, 100):un() --不设置尺寸会有问题

    scroll.creator = UUI.Left.ScrollHybridCreator
    scroll.updateFunc = UUI.Left.ScrollHybridUpdater
    scroll.getNumFunc = function() return U1GetNumTags() end

    --自定义的滚动按钮
    scroll.noScrollBar = true;
    scroll.scrollBar.IsVisible = function() return 1 end --骗过 HybridScrollFrameScrollButton_OnClick
    scroll.scrollUp = UUI.Left.CreateScrollButton(scroll, 1):BOTTOM(scroll, 'TOP', 0, 1)
    scroll.scrollDown = UUI.Left.CreateScrollButton(scroll, -1):TOP(scroll, 'BOTTOM', 0, -0)

    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", 2)

    --滚动边缘的阴影
    WW:Frame(nil, scroll):ALL()
    :Texture(nil, "OVERLAY", UUI.Tex'UI2-shade-dark-deeper'):SetTexRotate(180):TL(0,1):BR(scroll, "TR", 0, -4):up()
    :Texture(nil, "OVERLAY", UUI.Tex'UI2-shade-dark-deeper'):BL(0,-2):TR(scroll, "BR", 0, 8):up()
    :un();

    left:SetScript("OnSizeChanged", CoreUICreateHybridButtonsOnSizeChanged)

    return left
end

function UUI.Left.CreateScrollButton(scroll, direction)
    local l, r, t, b = 2/128, 106/128+2/128, 0, 20/64
    if direction < 0 then t=0.5 b=b+0.5 end
    local btn = WW(scroll):Button():Size(106, 20)
    :Texture(nil, nil, UUI.Tex'UI2-left-scroll', l, r, t, b):ToTexture("Normal"):ALL():up()
    :Texture(nil, nil, UUI.Tex'UI2-left-scroll', l, r, t, b):ToTexture("Disabled"):ALL():up()
    :Texture(nil, nil, "Interface\\Buttons\\UI-Silver-Button-Highlight", 0, 1, 0.03, 0.7175):ToTexture("Highlight"):SetAlpha(0.7):TL(-4, 6):BR(1, -6):up()
    :Texture(nil, nil, UUI.Tex'UI2-left-scroll', l-1/128, r-1/128, t-1/64, b-1/64):ToTexture("Pushed"):ALL():up()

    btn:GetDisabledTexture():SetDesaturated(1)
    btn:GetDisabledTexture():SetVertexColor(.75, .75, .75);
    btn.direction = direction
    btn.parent = scroll; --使用 HybridScrollFrameScrollButton_OnClick 必须 parent是scroll, 而且是MouseDown
    btn:RegisterForClicks("LeftButtonUp", "LeftButtonDown");
    btn:SetScript('OnClick', HybridScrollFrameScrollButton_OnClick)

    return btn
end

function UUI.Left.ScrollHybridCreator(self, index, name)
    local btn = WW:Button(nil, self.scrollChild):Size(104, 32):Set3Fonts("U1F_LeftTags"):SetText("ABC")
    :Texture(nil, nil, UUI.Tex'UI2-left-btn', 0,104/128,0,0.25):ToTexture("Normal"):ALL():up()
    :Texture(nil, nil, UUI.Tex'UI2-left-btn', 0,104/128,0.25,0.5):ToTexture("Highlight"):SetAlpha(0.3):ALL():up()
    :Texture(nil, nil, UUI.Tex'UI2-left-btn', 0,104/128,0.5,0.75):ToTexture("Pushed"):ALL():up()

    btn:GetFontString():SetSize(btn:GetSize())
    btn:GetFontString():SetMaxLines(U1.CN and 1 or 2)

    btn:SetScript('OnClick', UUI.Left.ButtonOnClick);

    btn:RegisterForDrag("LeftButton")
    btn:SetScript("OnDragStart", UUI.Left.ScrollOnDragStart);
    btn:SetScript("OnDragStop", UUI.Left.ScrollOnDragStop);
    btn:SetScript('OnEnter', UUI.Left.TagButton_OnEnter)
    btn:SetScript('OnLeave', UUI.Left.TagButton_OnLeave)

    return btn()
end

function UUI.Left.ScrollHybridUpdater(self, button, index)
    local name, num, caption, special = U1GetTagInfo(index);
    button:SetText(caption)
    --button:SetNormalFontObject(special and U1ButtonNormalFontSpecial or U1ButtonNormalFontNormal);
    button.tag = name;

    if (button.tag == U1GetSelectedTag()) then
        button:GetNormalTexture():SetTexCoord(0,0.8125,0.5,0.75);
        button:GetFontString():SetTextColor(1, .96, .63)
    else
        button:GetFontString():SetTextColor(0.81, 0.65, 0.48)
        button:GetNormalTexture():SetTexCoord(0,0.8125,0,0.25);
    end
end

---实现拖动按钮滚动左侧标签的效果
function UUI.Left.ScrollOnUpdateDrag(self)
    local y = select(2, GetCursorPosition());
    self.scrollBar:SetValue(self.scrollBar:GetValue() + y - self.dragging);
    self.dragging = y;
end

function UUI.Left.ScrollOnDragStart(self)
    local scroll = self:GetParent():GetParent();
    scroll.dragging = select(2, GetCursorPosition());
    scroll:SetScript("OnUpdate", UUI.Left.ScrollOnUpdateDrag);
end

function UUI.Left.ScrollOnDragStop(self)
    local scroll = self:GetParent():GetParent();
    scroll.dragging = nil;
    scroll:SetScript("OnUpdate", nil);
end

function UUI.Left.ButtonOnClick(self)
    local search = UUI().search;
    search:SetText("");
    search:SetFocus();
    search:ClearFocus();
    U1SelectTag(self.tag);
end

--[[------------------------------------------------------------
顶部操作按钮
---------------------------------------------------------------]]
function UUI.Top.Create(main)
    --左上角LOGO及文字
    main:CreateTexture():Key("logo"):SetTexture(UUI.Tex"UI2-logo"):TL(-18, 38):Size(87):un()
    main:CreateTexture():Key("logof"):TL(-18, 38):Size(87):SetTexture("Interface\\UnitPowerBarAlt\\Atramedes_Circular_Flash"):SetBlendMode("ADD"):SetAlpha(0.5):up()
    main:Button():TL(-8, 48):Size(67):SetScript("OnClick", function() local f = U1DonatorsFrame or U1Donators:CreateFrame() CoreUIShowOrHide(f, not f:IsShown()) end):un()
    UICoreFrameFlash(main.logof, 1 , 1, -1, nil, 0, 0)

    main:Texture(nil, nil, UUI.Tex'UI2-text', 0,1,0,0.5):TL(74, -7):Size(256,32):un()
    local url = main:Button():Size(180, 32):TL(180, -11):Texture(nil, nil, UUI.Tex'UI2-text', 0,180/256,0.5,1):ALL():ToTexture("Normal"):up():un()
    url:SetScript("OnClick", function() CoreUISetEditText(UUI.URL) end)
    UUI.MakeMove(url)

    --右上角关闭按钮
    main.btnClose = main:Button(nil, "UIPanelCloseButton"):Size(30):TR(5, 5)
    :SetScript("OnClick", function(self) HideUIPanel(self:GetParent()) end)
    :un()
    --关闭按钮的边框
    main:Texture(nil, nil, "Interface\\Buttons\\UI-CheckBox-Up"):TL(main.btnClose,1,0):BR(main.btnClose,-1,-1):un()

    --主界面的按钮
    main.setting = TplPanelButton(main,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnClick", function()
        CloseDropDownMenus(1);
        if(UUI().right.addonName==U1Name) then
            UUI.Right.ADDON_SELECTED()
        else
            UUI.Right.ADDON_SELECTED(U1Name) UUI.Right.TabChange(1)
        end
    end)
    :Frame("$parentSettingDropdown", "UIDropDownMenuTemplate", "drop"):TL("$parent", "BL", 0, 0):up()
    :Button():Key("dropbutton"):Size(20,UUI.PANEL_BUTTON_HEIGHT+6):LEFT("$parent", "RIGHT", -6, -1)
	:SetNormalTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Up")
	:SetPushedTexture("Interface/ChatFrame/UI-ChatIcon-ScrollDown-Down")
	:SetHighlightTexture("Interface/Buttons/UI-Common-MouseHilight")
    :SetScript("OnClick", UUI.Top.ToggleQuickSettingDropDown):up()
    :un()
    CoreUIEnableTooltip(main.setting, L["爱不易设置"], L["直接显示爱不易的介绍和配置项，再次点击则恢复当前的选择插件"])
    CoreUIEnableTooltip(main.setting.dropbutton, L["快捷设置"], L["一些常用的选项，以下拉菜单方式列出，可迅速进行设置。"])
    UUI.AddChangeWithColsButton(main.setting, L["爱不易设置"], L["设置"])

    do
        --音量调整按钮
        main.setting.soundPanel = WW:Frame(nil, UIParent):Size(60,175):TL(DropDownList1, "TR", -3, 0):SetFrameStrata("FULLSCREEN_DIALOG"):Hide()
        :Backdrop("Interface\\Tooltips\\UI-Tooltip-Background", "Interface\\Tooltips\\UI-Tooltip-Border", 16, {5,5,5,4}, 16)
        :SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
        :SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
        :EnableMouse(true)
        :SetScript("OnEnter", UIDropDownMenu_StopCounting):SetScript("OnLeave", UIDropDownMenu_StartCounting)
        :un()
        main.setting.soundPanel.parent = DropDownList1; --stopCounting

        local soundSlider = TplSlider(main.setting.soundPanel, nil, VOLUME, 1, "%d%%", 0, 100, 5):Size(12,128):TOP(-10, -35)
        :SetScript("OnEnter", UIDropDownMenu_StopCounting):SetScript("OnLeave", UIDropDownMenu_StartCounting)
        :SetScript("OnShow", function(self) self:SetValue(100-GetCVar("Sound_MasterVolume")*100) end)
        :un()
        soundSlider.func = function(self, v) BlizzardOptionsPanel_SetCVarSafe("Sound_MasterVolume", v/100) PlaySound(SOUNDKIT.IG_MAINMENU_OPEN) end
        soundSlider.parent = DropDownList1; --StopCounting
        DropDownList1:HookScript("OnHide", function() main.setting.soundPanel:Hide() end)
    end

    main.reload = TplPanelButton(main,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnClick", function(self) self.hint:SetFrameLevel(self:GetFrameLevel()+1) CoreScheduleTimer(false, 0.4, self.hint.Show, self.hint) end)
    :SetScript("OnEnter", UUI.Top.ReloadOnEnter)
    :SetScript("OnDoubleClick", function(self) ReloadUI();end)
    :Frame():Key("flash"):SetAlpha(0.5):TL(-11,2):BR(8,-3):up()
    :un()
    UUI.AddChangeWithColsButton(main.reload, L["重载界面"], L["重载"])
    UUI.AddChangeWithCols("RELOADFLASH", function(cols)
        if cols <= 1 then
            WW(main.reload.flash):TL(-3,2):BR(1,-3):up():un();
        else
            WW(main.reload.flash):TL(-11,2):BR(8,-3):up():un();
        end
        UUI.ReloadFlashRefresh();
    end)
    local hint = TplGlowHint(main.reload, "$parentReloadHint", 240):Key("hint"):BOTTOM("$parent", "TOP", 0, 20):Hide():un()
    hint.text:SetText(L["请双击按钮（防止误操作）"]);

    --main.collect = TplPanelButton(main,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    --:SetText(L["回收内存"])
    --:SetScript("OnClick", function(self) collectgarbage(); UpdateAddOnMemoryUsage(); U1SortAddons() end)
    --:un()
    --CoreUIEnableTooltip(main.collect, L["释放内存"], L["强制回收空闲的内存, 除了确定插件内存的稳定值外, 并没有太大用处."])

    main.collect = TplPanelButton(main,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnClick", function(self) U1SelectAddon("163UI_MoreOptions") UUI.Right.TabChange(1) end)
    :un()
    CoreUIEnableTooltip(main.collect, "额外设置", "一些暴雪取消了设置界面，但却有意义的设置选项")
    UUI.AddChangeWithColsButton(main.collect, "额外设置", "额外")

    main.profile = TplPanelButton(main,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnMouseDown", function(self)
        if not U1ProfileFrame then U1Profiles:CreateFrame() return end
        CoreUIShowOrHide(U1ProfileFrame, not U1ProfileFrame:IsVisible())
        U1ProfileFrame:SetFrameLevel(UUI():GetFrameLevel()+10)
    end)
    CoreUIEnableTooltip(main.profile, L["方案管理"], L["将已启用的插件列表等保存为方案，例如任务模式、副本模式等，亦可以在多个角色之间共用。"])
    UUI.AddChangeWithColsButton(main.profile, L["方案管理"], L["方案"])

    CoreUIAnchor(main,"TOPRIGHT","TOPRIGHT",-28-20,-12,"RIGHT", "LEFT",-8,0, main.setting, main.collect, main.profile, main.reload);
end

function UUI.Top.ToggleQuickSettingDropDown(self)
    GameTooltip:Hide()
    if not self._inited then
        self._inited = true
        UIDropDownMenu_Initialize(UUI().setting.drop, UUI.Top.QuickSettingDropDownMenuInitialize, "MENU"); -- taint here
    end
    ToggleDropDownMenu(1, nil, UUI().setting.drop, self, 0, 0)
    if DropDownList1:IsVisible() then UUI().setting.soundPanel:Show() end
end

function UUI.Top.QuickSettingDropDownMenuInitialize(frame, level, menuList)
    --UIDropDownMenu_SetAnchor(main.setting.drop, 0, 0, "TOPRIGHT", main.setting.dropbutton, "BOTTOMRIGHT")
    frame.point = "TOPRIGHT"; frame.relativePoint = "BOTTOMRIGHT";
    local info = UIDropDownMenu_CreateInfo();
    info.isNotRadio = 1; info.notCheckable = 1; info.isTitle = 1; info.justifyH = "CENTER"; info.text = L["爱不易快捷设置"];
    UIDropDownMenu_AddButton(info);
    info.text = "";
    UIDropDownMenu_AddButton(info);
    table.wipe(info);
    local items = U1DBG.qSet or UUI.DropDownItems
    for _, v in ipairs(items) do
        UUI.TransCfgToDropDown(v, info)
    end
end

function UUI.Top.ReloadOnEnter(self)
    local tmp = _temp_table
    local reloadList = U1GetReloadList();
    if(next(reloadList))then
        GameTooltip:SetOwner(self);
        GameTooltip:AddLine(L["以下操作需要重载界面："],1,1,1);
        local i=0
        table.wipe(tmp)

        -- remember disabled addons, Disable is prior
        for k,v in pairs(reloadList) do
            local name, type = strsplit("/", k)
            tmp[name] = type
        end
        for k,v in pairs(reloadList) do
            local name, type = strsplit("/", k);
            local info = U1GetAddonInfo(name);
            while info.parent do
                info = U1GetAddonInfo(info.parent)
                type = "config" --disabling sub shows 'Config - <parent>'
            end
            name = info.name:lower()
            if tmp[name] ~= 1 then
                local title = U1GetAddonTitle(name);
                if tmp[name] == "__disable" or type == "__disable" then
                    GameTooltip:AddLine( L["|cffff0000停用|r - "] .. title)
                else
                    GameTooltip:AddLine( L["配置 - "] .. title)
                end
                tmp[name] = 1
                i=i+1
                if(i>10)then GameTooltip:AddLine("..."); break end
            end
        end
        GameTooltip:Show();
        --GameTooltip:AddLine("|cffffff00双击|r按钮重载界面"); --不要了
    end
end

--[[------------------------------------------------------------
中央区域
---------------------------------------------------------------]]
function UUI.Center.Create(main)
    local center = main:Frame():Key("center"):TL(UUI.LEFT_WIDTH+11, -(UUI.TOP_HEIGHT+10+24+10)):BR(-UUI.RIGHT_WIDTH-9, 12):Backdrop("Interface\\GLUES\\COMMON\\Glue-Tooltip-Background")
    local tl = CoreUIDrawBorder(center, 1, "U1T_InnerBorder", 16, UUI.Tex'UI2-border-inner-corner', 16, true)

    local scroll = CoreUICreateHybridStep1(nil, center(), 9, nil, true, "LINE")
    UUI.MakeMove(scroll);
    center.scroll = scroll;
    WW(scroll):TL(UUI.BUTTON_P+2,-UUI.BUTTON_P-2):BR(-23, 41):un();
    scroll:SetSize(409,325) --不设置大小无法显示scrollChild，无法创建多行按钮
    scroll.scrollBar.doNotHide = 1

    center:Texture(nil, "BORDER", UUI.Tex'UI2-scroll-end'):Size(32):TR():up()
    :Texture(nil, "BORDER", UUI.Tex'UI2-scroll-end'):Size(32):BR():SetTexRotate("V"):up()
    :CreateTexture(nil, "BORDER", 'U1T_ScrollMid'):Size(32):TL("$parent", "TR", -32, -32):BR(0, 32):up()

    WW(scroll.scrollBar):TL(scroll, "TR", 1, -9):BL(scroll, "BR", 1, -21)
    :AddFrameLevel(1)
    :un() --否则无法滚动

    WW(scroll.scrollUp):TOP(0,17):Size(18,17):un();
    WW(scroll.scrollDown):BOTTOM(0,-17):Size(18,17):un();

    --WW(scroll):CreateTexture():SetTexture(1,1,1):ALL()
    scroll.creator = UUI.Center.ScrollHybridCreator;
    scroll.updateFunc = UUI.Center.ScrollHybridUpdater;
    function scroll:getNumFunc()
        return math.ceil(U1GetNumCurrentAddOns()/self:GetParent().cols);
    end
    center.cols = UUI.CENTER_COLS
    CoreUICreateHybridStep2(scroll, 0, 0, "TOPLEFT", "TOPLEFT", UUI.BUTTON_OFFSET)

    --底部背景
    local l = center:Texture(nil, "BORDER", UUI.Tex'UI2-bg-bottom-end'):BL(2,-24):SetSize(16, 64)
    local r = center:Texture(nil, "BORDER", UUI.Tex'UI2-bg-bottom-end'):BR(-21,-24):SetSize(16, 64):SetTexRotate("H")
    center:CreateTexture(nil, "BORDER", 'U1T_BottomMid'):Size(16,64):TL(l, "TR"):BR(r, "BL"):up()
    center:Frame():CreateTexture(nil, "OVERLAY"):SetTexture(UUI.Tex'UI2-shade-dark-deeper'):ALL():up():SetHeight(32):BL(l,"TL"):BR(r,"TR"):AddFrameLevel(2, center)

    StaticPopupDialogs["163UIUI_LOAD_ALL_CONFIRM"] = {preferredIndex = 3,
        text = "您确认吗？不建议您加载全部插件\n\n爱不易整合了非常多的优秀插件，但玩家一般用不到全部功能。建议您在默认方案的基础上选择几个自己需要的，不然会显得有点杂乱。",
        button1 = TEXT(YES),
        button2 = TEXT(CANCEL),
        OnAccept = function(self, data)
            UUI.Center.BtnLoadAllOnClick()
        end,
        hideOnEscape = 1,
        timeout = 0,
        exclusive = 1,
        whileDead = 1,
    }
    local btn = TplPanelButton(center,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnClick", function()
        local tag = U1GetSelectedTag()
        if not tag or tag == "ABYUI" or tag == "BIG" then
            StaticPopup_Show("163UIUI_LOAD_ALL_CONFIRM")
        else
            UUI.Center.BtnLoadAllOnClick()
        end
    end):un();
    UUI.AddChangeWithColsButton(btn, L["全部加载"], L["全开"])
    CoreUIEnableTooltip(btn, L["加载当前显示的所有插件"], function(self, tip)
        if InCombatLockdown() then
            tip:AddLine(L["注意：战斗中执行此操作可能会导致大量错误，建议执行完毕后重载界面。"], 1, .1, .1, 1)
        end
        tip:AddLine(L["注意：可能会加载近一分钟之久，期间游戏会停止响应，请安心等待。"], nil, nil, nil, 1)
    end)
    main.btnLoadAll = btn;

    local btn = TplPanelButton(center,nil, UUI.PANEL_BUTTON_HEIGHT):Set3Fonts(UUI.FONT_PANEL_BUTTON)
    :SetScript("OnClick", UUI.Center.BtnDisAllOnClick):un();
    UUI.AddChangeWithColsButton(btn, L["全部停用"], L["全关"])
    CoreUIEnableTooltip(btn, L["停用当前显示的所有插件"], function(self, tip)
        if InCombatLockdown() then
            tip:AddLine(L["注意：战斗中执行此操作可能会导致大量错误。"], 1, .1, .1, 1)
        end
        tip:AddLine(L["停用后请手动重载界面"], nil, nil, nil, 1)
    end);
    main.btnDisAll = btn;

    CoreUIAnchor(center(), "BOTTOMRIGHT", "BOTTOMRIGHT", -30, 10, "RIGHT", "LEFT", -5, 0, main.btnDisAll, main.btnLoadAll)

    local chkLoaded = TplCheckButton(center):Key("chkLoaded"):Size(24):Set3Fonts(UUI.FONT_PANEL_BUTTON):SetText(L["已启用"]):SetScript('OnClick', UUI.Center.FilterButtonOnClick):un()
    chkLoaded.tag = 'LOADED'
    CoreUIEnableTooltip(chkLoaded, L["说明"], L["显示当前分类下已启用的插件"])
    local chkDisabled = TplCheckButton(center):Key("chkDisabled"):Size(24):Set3Fonts(UUI.FONT_PANEL_BUTTON):SetText(L["未启用"]):SetScript('OnClick', UUI.Center.FilterButtonOnClick):un()
    chkDisabled.tag = 'NLOADED'
    CoreUIEnableTooltip(chkDisabled, L["说明"], L["显示当前分类下未启用的插件"])
    chkLoaded.other = chkDisabled
    chkDisabled.other = chkLoaded

    chkLoaded:SetPoint("BOTTOMLEFT", 10, 8);
    chkDisabled:SetPoint("LEFT", chkLoaded.text, "RIGHT", 5, -1);

    UUI.AddChangeWithCols("Center.FilterButtonAdjust", UUI.Center.FilterButtonAdjust)
end

function UUI.Center.ScrollToAddon(name)
    local center = UUI().center
    name = name or U1GetSelectedAddon()
    if(name) then
        for i=1, U1GetNumCurrentAddOns() do
            if U1GetCurrentAddOnInfo(i) == name then
                CoreUIScrollTo(center.scroll, math.ceil(i / center.cols) - 1);
                return;
            end
        end
    end
end

function UUI.Center.Resize(self)
    CoreUICreateHybridButtonsOnSizeChanged(self);
    UUI.SizeFitCols();
    --CoreScheduleBucket("Timer_UUI.Center.ScrollToAddon", 0.2, UUI.Center.ScrollToAddon)
end

function UUI.Center.Refresh()
    UUI().center.scroll.update();
end

function UUI.Center.ButtonOnClick(self)
    local f = UUI()
    if(self.addonName == U1GetSelectedAddon() and (f.right:IsVisible() and f.right.addonName==self.addonName))then
        U1SelectAddon(nil, true);
        UUI.Center.Refresh();  --为了显示selected边框
        --f.right:Hide(); --TODO:
    else
        U1SelectAddon(self.addonName);
    end
end

function UUI.Center.ButtonUpdateTooltip(self)
    if not self.addonName then return end
    GameTooltip_SetDefaultAnchor(GameTooltip, self)
    UUI.SetAddonTooltip(self.addonName, GameTooltip);
    GameTooltip:Show();
end
function UUI.Center.ButtonOnEnter(self)
    UUI.Center.ButtonUpdateTooltip(self)
    local info = U1GetAddonInfo(self.addonName)
    if info and (info.installed or info.dummy) then
        self.text1:SetTextColor(1, .96, .63)
    end
end
function UUI.Center.ButtonOnLeave(self)
    local f = UUI();
    local txt = self.text1
    txt:SetTextColor(txt.r, txt.g, txt.b, txt.a)
    GameTooltip:Hide();
end

function UUI.Center.CheckOnClick(self)
    UUI.ClickAddonCheckBox(self, self:GetParent().addonName, self:GetChecked());
end
function UUI.Center.CheckOnEnter(self)
    local btn = self:GetParent();
    WW(btn):On("Enter"):LockHighlight():un()
end
function UUI.Center.CheckOnLeave(self)
    local btn = self:GetParent();
    WW(btn):On("Leave"):UnlockHighlight():un()
end

--创建一行之中的其中一列的单个按钮
function UUI.Center.ScrollCreateOnButton(lineButton)
    local b = lineButton:Button():Size(UUI.BUTTON_W, UUI.BUTTON_H);
    b:SetMotionScriptsWhileDisabled(true);
    --b.tooltipAnchorPoint = "ANCHOR_TOPLEFT"; --改为直接显示在右侧
    CoreUIEnableTooltip(b);
    b:SetScript("OnEnter", UUI.Center.ButtonOnEnter);
    b:SetScript("OnClick", UUI.Center.ButtonOnClick);
    b:SetScript("OnLeave", UUI.Center.ButtonOnLeave);
    b.UpdateTooltip = UUI.Center.ButtonUpdateTooltip; --无法换行了

    --如果直接贴texture则高光效果不同
    local icon = b:Frame():Key("icon"):Size(UUI.ICON_W):TL(4, -4)
    :Texture():Key("tex"):ALL():SetTexture("Interface\\Buttons\\Button-Backpack-Up"):up()
    :un();

    local check = b:CheckButton(nil, "UICheckButtonTemplate"):Key("check"):RIGHT(-UUI.CHECK_W/4, 0):Size(UUI.CHECK_W):AddFrameLevel(1)
    :SetMotionScriptsWhileDisabled(true)
    :SetScript("OnClick", UUI.Center.CheckOnClick)
    :SetScript("OnEnter", UUI.Center.CheckOnEnter)
    :SetScript("OnLeave", UUI.Center.CheckOnLeave)
    :un()

    b:CreateFontString():Key("text1"):LEFT(UUI.CENTER_TEXT_LEFT, 1):RIGHT(check, "LEFT", 2, 0):SetJustifyH("LEFT"):SetNonSpaceWrap(false):un()

    b:CreateFontString():Key("text2"):LEFT(UUI.CENTER_TEXT_LEFT, -9):RIGHT(check, "LEFT", 2, 0):SetJustifyH("LEFT"):SetFontObject(U1FCenterTextTiny):SetMaxLines(1):un()

    b:Texture(nil, "BACKGROUND", UUI.Tex"UI2-center-btn", 0,.75,0,.1875):ToTexture("Normal"):ALL():un() --0,192/256,0/256,48/256
    --b:Texture(nil, "BACKGROUND", UUI.Tex"UI2-center-btn", 0,.75,.375,.5625):ToTexture("Pushed"):ALL():un() --0,192/256,96/256,144/256
    b:Texture(nil, "HIGHLIGHT", UUI.Tex"UI2-center-btn", 0,.75,.1875,.375):ToTexture("Highlight", "ADD"):ALL():SetAlpha(.4):un() --0,192/256,48/256,96/256

    return b:un();
end

function UUI.Center.ScrollHybridCreator(self, index, name)
    local btn = WW(self.scrollChild):Frame(name):Size(1, UUI.BUTTON_H);
    local height = btn:GetHeight();
    btn.btns = {};
    for i = 1, UUI.MAX_COL do
        btn.btns[i] = UUI.Center.ScrollCreateOnButton(btn);
        if (i == 1) then
            btn.btns[i]:SetPoint("LEFT", 0, 0);
        else
            btn.btns[i]:SetPoint("LEFT", btn.btns[i - 1], "RIGHT", UUI.BUTTON_P, 0);
        end
    end
    return btn:un();
end

function UUI.Center.ScrollUpdateOneButton(b, idx)
    local addonName, info = U1GetCurrentAddOnInfo(idx);
    b.addonName = addonName;

    b.text1:SetFontObject( U1.CN and (not UI163_USER_MODE and not info.registered or U1GetShowOrigin()) and U1FCenterTextTiny or U1FCenterTextMid)

    if(not info.icon and not info.atlas) then
        if(not info.noAddonLoaderLDBIcon) then
            info.noAddonLoaderLDBIcon = true
            local meta = GetAddOnMetadata(addonName, 'X-LoadOn-LDB-Launcher')
            if(meta) then
                local texture, brokername = string.split(' ', meta)
                if(texture) then
                    info.icon = texture
                end
            end
        end

        if(not info.icon) then
            local dataobj = DataBroker:GetDataObjectByName(addonName)
            or DataBroker:GetDataObjectByName(addonName..'Launcher')
            or DataBroker:GetDataObjectByName('Broker_'..addonName)
            if(dataobj and dataobj.icon) then
                info.icon = dataobj.icon
            -- else
            --     info.icon = false
            end
        end
    end

    if info.atlas then
        b.icon.tex:SetAtlas(info.atlas)
    else
        b.icon.tex:SetTexture(info.icon or UUI.DEFAULT_ICON)
    end

    local addonId = info.installed;
    if addonId or info.dummy then
        b:Enable();
        b:GetHighlightTexture():Show()
        b.icon.tex:SetVertexColor(1,1,1)
        b.check:Show()

        CoreUIEnableOrDisable(b.check, not info.protected and not U1IsAddonCombatLockdown(addonName));
        b.check:SetChecked(U1IsAddonEnabled(addonName));
        --b.text1:SetText(U1GetAddonTitle(addonName));

        b.text1:SetShadowOffset(2, -2)

        --更好的区分未启用，已加载
        local enabled = U1IsAddonEnabled(addonName)
        local loaded = IsAddOnLoaded(addonName)
        if loaded or (info.dummy and enabled) or (false and info.lod and enabled) then
            b.text1:SetShadowOffset(2,-2)
            b:GetNormalTexture():SetVertexColor(1,1,1)
            CoreUIUndesaturateTexture(b.icon.tex);
            CoreUIUndesaturateTexture(b:GetNormalTexture());
            if(enabled) then
                b.text1:SetTextColor(0.81, 0.65, 0.48);
            else
                b.text1:SetTextColor(0.71, 0.5, 0.30);
            end
        else
            b.text1:SetShadowOffset(1,-1)
            b:GetNormalTexture():SetVertexColor(.75,.75,.75)
            if not (info.lod and enabled) then CoreUIDesaturateTexture(b.icon.tex); end
            CoreUIDesaturateTexture(b:GetNormalTexture());
            if(enabled) then
                if info.lod then
                    b.text1:SetTextColor(0.81, 0.65, 0.48);
                else
                    b.text1:SetTextColor(1, .2, .2);
                end
            else
                b.text1:SetTextColor(.5, .5, .5);
            end
        end

        --选中插件
        if(addonName==U1GetSelectedAddon())then
            b.text1:SetTextColor(1, .96, .63)
            b:GetNormalTexture():SetTexCoord(0,.75,.375,.5625)
            CoreUIUndesaturateTexture(b:GetNormalTexture());
        else
            b:GetNormalTexture():SetTexCoord(0,.75,0,.185) --.1875少一点防止白边
        end
    else
        b:Disable();
        b:GetHighlightTexture():Hide()
        b.icon.tex:SetVertexColor(.3,.3,.3)
        b.check:Hide()

        --b.text1:SetText(U1GetAddonTitle(addonName));
        b.text1:SetTextColor(.5, .5, .5, .5);
        b:GetNormalTexture():SetTexCoord(0,.75,0,.185)
        b:GetNormalTexture():SetVertexColor(.3,.3,.3)
        CoreUIDesaturateTexture(b:GetNormalTexture())
        CoreUIDesaturateTexture(b.icon.tex);
    end

    --搜索的高亮显示，拼音没办法
    local text = UUI().search:GetSearchText()
    local title = U1GetAddonTitle(addonName)
    local showText2 = false
    if(text=="")then
        b.text1:SetText(title);
    else
        local pattern = nocase(text);
        if(title:find(pattern)) then
            b.text1:SetText(title:gsub(pattern, "|cff00ff00%0|r"));
        elseif(addonName:find(pattern)) then
            b.text1:SetText(title);
            b.text2:SetText(info.name:gsub(pattern, "|cff00ff00%0|r"))
            showText2 = true
        else
            b.text1:SetText(title);
        end
    end
    CoreUIShowOrHide(b.text2, showText2)
    b.text1:SetMaxLines(showText2 and 1 or (U1.CN and 1 or 2))
    b.text1:SetPoint("LEFT", UUI.CENTER_TEXT_LEFT, showText2 and 6 or 1)

    local txt = b.text1
    txt.r, txt.g, txt.b, txt.a = txt:GetTextColor() --处理鼠标悬停文字高亮后的恢复
    if (addonId or info.dummy) and b:IsMouseOver() then b.text1:SetTextColor(1, .96, .63) end
end

function UUI.Center.ScrollHybridUpdater(self, button, index)
    local cols = self:GetParent().cols;
    for i = 1, #button.btns do
        local b = button.btns[i]
        if i>cols then
            b:Hide()
        else
            local idx=(index-1)*cols+i;
            if idx >U1GetNumCurrentAddOns()then
                b:Hide()
            else
                UUI.Center.ScrollUpdateOneButton(b, idx)
                b:Show();
            end
        end
    end
end

function UUI.Center.FilterButtonOnClick(self)
    local other = self.other
    if(self:GetChecked() == other:GetChecked()) then
        U1SetAdditionalFilter(nil)
    else
        local tag = self:GetChecked() and self.tag
        if(other:GetChecked()) then
            tag = other.tag
        end
        U1SetAdditionalFilter(tag)
    end
end

function UUI.Center.FilterButtonAdjust(cols)
    local main = UUI()
    main.center.chkLoaded:SetText(cols<2 and format("|cff00ff00 %d|r", select(2, U1GetTagInfoByName("LOADED"))) or format(L["已启用|cff00ff00 %d|r"], select(2, U1GetTagInfoByName("LOADED"))));
    main.center.chkDisabled:SetText(cols<2 and format("|cffAAAAAA %d|r", select(2, U1GetTagInfoByName("NLOADED"))) or format(L["未启用|cffAAAAAA %d|r"], select(2, U1GetTagInfoByName("NLOADED"))));
end

UUI.addonToLoad, UUI.loadTimer = {}, nil
function UUI.LoadAddons(deepToggleChildren)
    --if InCombatLockdown() then return end
    local used = 0;
    while (used < 0.2) do
        local name = table.remove(UUI.addonToLoad, 1);
        if(not name) then
            U1Message(L["全部插件加载完毕."])
            CoreCancelTimer(UUI.loadTimer);
            UUI.loadTimer = nil
            UUI.Center.Refresh();
            UUI.Right.ADDON_SELECTED();
            return
        end
        if(not IsAddOnLoaded(name)) then
            U1ToggleAddon(name, true, nil, deepToggleChildren)
            used = used + 0.1;
        end
    end
end

function UUI.Center.BtnLoadAllOnClick(self)
    if UUI.loadTimer then return end
    local deepToggleChildren = true --IsControlKeyDown()
    table.wipe(UUI.addonToLoad)
    local names = {}
    for i=1, U1GetNumCurrentAddOns() do names[i] = U1GetCurrentAddOnInfo(i) end
    for _, name in ipairs(names) do
        local info = U1GetAddonInfo(name);
        if (not U1IsAddonEnabled(name) and (info.installed or info.dummy)) then
            if not info.ignoreLoadAll then
                if not IsAddOnLoaded(name) then
                    table.insert(UUI.addonToLoad, name)
                else
                    U1ToggleAddon(name, true, nil, deepToggleChildren)
                end
            end
        else
            --按住Ctrl全部加载的时候，已加载的也处理孩子
            if deepToggleChildren then
                U1ToggleChildren(name, true, nil, true)
            end
        end
    end
    UUI.loadTimer = CoreScheduleTimer(true, 0.05, UUI.LoadAddons, deepToggleChildren);
end

function UUI.Center.BtnDisAllOnClick(self)
    local names = {}
    local deepToggleChildren = IsControlKeyDown()
    for i=1, U1GetNumCurrentAddOns() do names[i] = U1GetCurrentAddOnInfo(i) end
    for _, name in ipairs(names) do
        local info = U1GetAddonInfo(name);
        if U1IsAddonEnabled(name) and not info.protected and name~=strlower(U1Name) then
            U1ToggleAddon(name, false, nil, deepToggleChildren)
        else
            --按住Ctrl全部关闭的时候，已关闭的也处理孩子
            if deepToggleChildren then
                U1ToggleChildren(name, false, nil, true)
            end
        end
    end
    UUI.ReloadFlash(self, false);
    UUI.Center.Refresh();
    UUI.Right.ADDON_SELECTED();
end

--[[------------------------------------------------------------
右侧区域
---------------------------------------------------------------]]
function UUI.Right.Create(main)
    local right = main:Frame():Key("right"):TL(main,"TR", -UUI.RIGHT_WIDTH, -(UUI.TOP_HEIGHT+10+24+10)):BR(-12, 12):Backdrop("Interface\\GLUES\\COMMON\\Glue-Tooltip-Background")
    local l = right:Texture(nil, "BORDER", UUI.Tex'UI2-chain-end'):Size(16,16):TL(-10,0)
    local r = right:Texture(nil, "BORDER", UUI.Tex'UI2-chain-end'):Size(16,16):BL(-10,0):SetTexRotate("V")
    right:CreateTexture(nil, "BORDER", 'U1T_ChainMid'):Size(16,1):TL(l, "BL"):BR(r, "TR"):up()

    local check = CoreUICreateCheckButtonWithIcon(right, nil, 22, 16):Key("check"):Set3Fonts(UUI.FONT_PANEL_BUTTON):BL(right, "TL", -5,7):un();
    check.text:SetMaxLines(1)

    check:SetScript("OnClick", UUI.Center.CheckOnClick);
    CoreUIEnableTooltip(check, nil, function(self, tip)
        local name = self:GetParent().addonName
        if name then UUI.SetAddonTooltip(name, tip) end
    end, true)

    -- -------------- 右侧分页页签, 创建一个可伸缩边框，去掉上边框 --------------
    local _,_,_,_,_,_,t = CoreUIDrawBorder(right, 1, "U1T_InnerBorder", 16, UUI.Tex'UI2-border-inner-corner', 16, true)  t:Hide()
    local topw = UUI.RIGHT_WIDTH-44
    right.tabBottom = right:Texture(nil, "BORDER", UUI.Tex'UI2-border-right-top'):Size(topw,16):TR(-18,1)
    right.tabBg = right:Texture(nil, "OVERLAY", UUI.Tex'UI2-tab-1'):Size(128,64):BR(right.tabBottom, "TR", 10, -3):un()

    local function clickTabButton(self)
        UUI.Right.TabChange(self:GetID(), nil, true)
    end
    local function createTabButton(title, info)
        local btn = right:Button():Size(48, 32):SetMotionScriptsWhileDisabled(true)
        :Texture(nil, nil, "Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight"):TL(-9,11):BR(7,-14):ToTexture("Highlight"):up()
        :SetScript("OnClick", clickTabButton);
        CoreUIEnableTooltip(btn(), title, info)
        return btn;
    end
    right.tabs = {}
    right.tabs[1] = createTabButton(L["插件选项"]):SetID(1):BR(right.tabBg, -73, 2):un()
    right.tabs[2] = createTabButton(L["插件介绍"]):SetID(2):BR(right.tabBg, -17, 2):un()

    right:Texture(nil, "BORDER", UUI.Tex'UI2-scroll-end'):Size(32):TR():up()
    :Texture(nil, "BORDER", UUI.Tex'UI2-scroll-end'):Size(32):BR():SetTexRotate("V"):up()
    :CreateTexture(nil, "BORDER", 'U1T_ScrollMid'):Size(32):TL("$parent", "TR", -32, -32):BR(0, 32):up()

    local scroll = WW:ScrollFrame(tostring(right).."Scroll", right, "MinimalScrollFrameTemplate"):Key("scroll"):Size(UUI.RIGHT_WIDTH-33,100):TL(2,-5):BR(-22,5)
    :CreateTexture(nil,"BACKGROUND"):Key("wm"):SetTexture(U1.CN and UUI.Tex'UI2-watermark' or nil):SetAlpha(0.125):Size(256, 64):BL(5, 0):up()
    :un();
    --WW(scroll):CreateTexture():SetTexture(1,1,1):ALL()
    scroll.scrollBarHideable = nil
    _G[scroll.ScrollBar:GetName().."Track"]:SetAlpha(0.3)
    scroll.scrollBar = scroll.ScrollBar --for CoreUIScrollSavePos
    WW(scroll.scrollBar):TL(scroll, "TR", 0, -16):BL(scroll, "BR", 0, 15)

    local scrollUp = _G[scroll.ScrollBar:GetName().."ScrollUpButton"]
    local scrollDown = _G[scroll.ScrollBar:GetName().."ScrollDownButton"]
    WW(scrollUp):TOP(0,17):Size(18,17):un()
    WW(scrollDown):BOTTOM(0,-17):Size(18,17):un()
    WW(scroll):On("Load"):un();

    UUI.Right.CreatePageDesc(right)

    right = right:un();
end

function UUI.Right.CreatePageDesc(right)
    local scroll = right.scroll
    right.pageCfg = WW:Frame(nil, scroll):AddToScroll(scroll):Size(scroll:GetWidth(), 10):un();
    local pageDesc = WW:Frame(nil, scroll):Size(scroll:GetWidth(), 10):un(); right.pageDesc = pageDesc
    local font = (U1.CN and ChatFontNormal or GameFontNormal):GetFont()
    WW:SimpleHTML(nil, pageDesc):Key("html"):TL(5, -5):Size(scroll:GetWidth()-10, 10)
    :SetFont("P" ,font,U1.CN and 13 or 12):SetTextColor("P",0.81, 0.65, 0.48):SetSpacing("P",5) --cfa67f
    :SetFont("H1",font,U1.CN and 14 or 13):SetTextColor("H1",.9,.9,.7):SetSpacing("H1",5)
    :SetFont("H2",font,U1.CN and 13 or 12):SetTextColor("H2",.9,.9,.7):SetSpacing("H2",4)
    :SetFont("H3",font,U1.CN and 12 or 11):SetTextColor("H3",.9,.9,.7):SetSpacing("H3",3):SetIndentedWordWrap("H3",true)
    :un();

    --右侧说明的图片窗
    local factor = 1 --(scroll:GetWidth()-12)/200
    WW:Frame(nil, pageDesc):Key("pics"):Size(200*factor, 128*factor):TL("$parent", "TL", 8+(scroll:GetWidth()-12-200)/2, -4-6)
    :CreateTexture():Key("tex"):ALL():up()
    :CreateFontString():Key("caption"):SetFontObject(U1FTextTinyOUTLINE):SetTextColor(1,.96,.63,0.5):TL(0,-3):up()
    --边框
    local border = WW:Frame(nil, pageDesc.pics):Key("border"):TL(-2, 2):BR(2,-2):Backdrop(nil,UUI.Tex'TuiBlank',1):SetBackdropBorderColor(.3,.3,.3):un()
    --外边框
    local outset = -2 WW:Frame(nil, border):TL(-3 - outset, 3 + outset):BR(3 + outset, -3 - outset):Backdrop(nil,UUI.Tex'TuiBlank',1):SetBackdropBorderColor(.3,.3,.3,.5):un()

    --图片翻页按钮
    local function pageButtonOnClick(self)
        local pics = self:GetParent();
        local isprev = self== pics.prev
        local other = isprev and pics.next or pics.prev;
        local dots = pics.dots;
        local selected = (dots.selected or 1) + (isprev and -1 or 1);
        if selected == (isprev and 1 or dots.numDots) then self:Hide() end
        other:Show();
        dots:UpdateDots(selected)
    end
    local function pageButtonCreate(btn)
        btn:SetScript("OnClick", pageButtonOnClick)
        --btn:SetScript("OnEnable", btn.Show) --为了能拖动, 会导致 /dump GetFrameCPUUsage(UUI().right.scroll) 很高
        --btn:SetScript("OnDisable", btn.Hide)
        UUI.MakeMove(btn)
    end
    WW:Button(nil, pageDesc.pics):Key("prev"):TL():BR(-pageDesc.pics:GetWidth()/2,0):CreateTexture():SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-PrevPage-Up"):SetTexCoord(0.3,0.65,0.28,0.75):Size(20,20):LEFT(5,0):ToTexture("Highlight"):up():un()
    WW:Button(nil, pageDesc.pics):Key("next"):TL(pageDesc.pics:GetWidth()/2,0):BR():CreateTexture():SetTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up"):SetTexCoord(0.3,0.65,0.28,0.75):Size(20,20):RIGHT(-5,0):ToTexture("Highlight"):up():un()
    pageButtonCreate(pageDesc.pics.prev)
    pageButtonCreate(pageDesc.pics.next)

    --底部圆点
    local dots = WW:Frame(nil, pageDesc.pics):Key("dots"):TOP(border, "BOTTOM", 0, -3):Size(120, 10):un();
    dots.texs = {}
    function dots:UpdateDots(selected)
        self.selected = selected
        for i = 1, self.numDots do
            if i==selected then
                self.texs[i]:SetTexture("Interface\\COMMON\\Indicator-Yellow"):SetAlpha(1)
            else
                self.texs[i]:SetTexture("Interface\\COMMON\\Indicator-Gray"):SetAlpha(0.8)
            end
        end

        --设置图片
        local pics = self:GetParent()
        local picsInfos = pics.picsInfos
        local showCaption = true --插件集的时候显示子插件名
        if type(picsInfos)=="string" then
            table.wipe(_temp_table)
            _temp_table[1]=picsInfos
            picsInfos=_temp_table
            showCaption = nil
        end
        for _, pic in ipairs(picsInfos) do
            local path, num, width = strsplit(",", pic) num = tonumber(num) width = tonumber(width)
            if selected <= num then
                pics.tex:SetTexture("Interface\\AddOns\\"..UUI.PICS_ADDON.."\\"..path)
                pics.tex:SetTexCoord(200*(selected-1)/width,200*(selected)/width,0,1)
                pics.caption:SetText(showCaption and U1GetAddonTitle(path) or "")
                break
            end
            selected = selected - num
        end
    end
    function dots:CreateDots(num)
        self.numDots = num;
        for i=#self.texs+1, num do
            self.texs[i]=WW(self:CreateTexture()):Size(10,10):TL((i-1)*20+10, 0)
        end
        for i=1,#self.texs do CoreUIShowOrHide(self.texs[i], i<=num) end
        self:SetSize(20*num, 10);
        dots:UpdateDots(1);
    end

    --UUI.Right.SetPics(UUI.Tex'_help', 5, 8129);
end

function UUI.Right.SetHtmlUpdateLog(tmp, log)
    for _, s in ipairs(log) do
        table.insert(tmp, format("<H3>-%s</H3>", CoreEncodeHTML(s:gsub("<a .->.-</a>", ""))))
    end
    table.insert(tmp, "<IMG height='5'/>");
end

function UUI.Right.GetTitleFormat()
    return "<img height='10'/><H1>|cffffb233%s|r</H1><H3>|TInterface\\DialogFrame\\UI-DialogBox-Gold-Background:2:185:0:1|t</H3>";
end
function UUI.Right.SetHTML(right, name)
    if not name and right.tagName==UUI.DEFAULT_TAG then name=U1Name end

    --如果没有name则使用right.tagName显示标签的说明，主要是为了在选择标签时不至于太卡
    if not name then
        local _,num,caption,order,desc = U1GetTagInfoByName(right.tagName)
        if right.tagName=="CLASS" then caption = L["TAG_CLASS"] end
        desc = (desc and desc ~= "") and format(L["<P>　%s<br/><br/></P>"], CoreEncodeHTML(desc)) or ""
        local text = "<HTML><BODY>"..format(UUI.Right.GetTitleFormat(), L["插件分类："]..CoreEncodeHTML(caption)) .. desc .. L["<P>　%s</P></BODY></HTML>"];
        right.pageDesc.html:SetText(format(text, L["插件数："]..num));
    else

        local info = U1GetAddonInfo(name);
        local title = U1GetAddonTitle(name, false)
        local name, _, notes, _, reason = GetAddOnInfo(name)
        local loaded = IsAddOnLoaded(name);

        local desc = info.desc or ""
        if(type(desc)=="table") then
            desc = table.concat(desc, "`");
        end

        local text = UUI().search:GetSearchText()
        if(text~="")then
            local pattern = nocase(text);
            if(desc:find(pattern)) then
                desc = desc:gsub(pattern, "|cff00ff00%0|r");
            end
        end
        desc = CoreEncodeHTML(desc, true):gsub("`", L["<BR/>　"]);

        if(info.dummy)then
            desc = desc..L["<BR/><BR/>　插件集包含以下插件："];
            for _, v in ipairs(info.children) do
                if U1IsAddonInstalled(v) then
                    desc = desc..format(L["<BR/>　|cffe6e6b3 - %s|r"],U1GetAddonTitle(v));
                end
            end
        end

        local page = right.pageDesc;

        local text = "<HTML><BODY>%s%s%s"..format(UUI.Right.GetTitleFormat(), L["插件介绍"])..L["<P>　%s<br/></P>%s</BODY></HTML>"];
        local author, modifier, changes, tags = "", "", "", ""
        if #info.tags > 0 then
            for _, tag in ipairs(info.tags) do
                tag = select(3, U1GetTagInfoByName(tag))
                if tag then tags = tags .. ", " .. tag end
            end
            tags = format("<P>|cffe6e6b3"..L["插件分类："].."%s|r</P>", CoreEncodeHTML(tags:sub(3)));
        end
        if info.author then
            author = format(L["<P>|cffe6e6b3作者: %s|r</P>"], CoreEncodeHTML(info.author))
        end
        if info.modifier then
            modifier = format(L["<P>|cffe6e6b3修改: %s|r</P>"], CoreEncodeHTML(info.modifier))
        end

        if U1_CHANGES then
            local MAX_CHANGES_ALL, MAX_CHANGES_SINGLE = 3, 5
            local tmp = _temp_table or {} table.wipe(tmp);
            if strlower(name)==U1Name:lower() then
                author = ""
                for i=1, MAX_CHANGES_ALL do
                    local change = U1_CHANGES[i]
                    if not change then break end
                    --if #tmp > 0 then table.insert(tmp, "<H3><BR/></H3>") end
                    table.insert(tmp, format(L["<H2 align='center'>|cff7f7fff◆ %s ◆|r</H2>"], change.time))
                    for k, v in pairs(change) do
                        if k~="time" then
                            v.title = U1GetAddonInfo(k) and U1GetAddonInfo(k).title or k
                            table.insert(tmp, format(L["<H2>◇|cffffd200%s|r</H2>"], v.title))
                            UUI.Right.SetHtmlUpdateLog(tmp, v)
                        end
                    end
                end
            else
                local i = 1
                for _, change in ipairs(U1_CHANGES) do
                    for k, v in pairs(change) do
                        if k~="time" then
                            v.parent = v.parent or strlower((U1GetAddonInfo(k) or _empty_table).parent or "_NIL")
                            local justthis = strlower(k)==strlower(name) --是当期插件还是子插件
                            if justthis or v.parent==strlower(name) then
                                v.title = U1GetAddonInfo(k) and U1GetAddonInfo(k).title or k
                                table.insert(tmp, format(L["<H2>|cff7f7fff◇ %s%s ◇|r</H2>"], change.time:gsub(L[".*年(.*) %d+:%d+"], "%1"), justthis and "" or " - "..v.title)) --◇
                                UUI.Right.SetHtmlUpdateLog(tmp, v)
                                i=i+1; if i> MAX_CHANGES_SINGLE then break end
                            end
                        end
                    end
                    if i> MAX_CHANGES_ALL then break end
                end
            end
            if(#tmp>0) then
                table.insert(tmp, 1, format(UUI.Right.GetTitleFormat(), L["最近更新"]))
                changes = table.concat(tmp);
            end

        end

        --right.html:SetHeight(1)
        --print(format(text, author, modifier, desc, changes:gsub("<H3>%- </H3>","")))
        page.html:SetText(format(text, author, modifier, tags, desc, changes:gsub("<H3>%- </H3>","")));
    end
end

---插件是否有设置项
function UUI.Right.IsAddonHasCfg(name, info)
    --有配置项或之前计算过子插件则返回
    if #info > 0 or info._hasCfg then return true end
    --检索子插件
    for k, v in U1IterateAllAddons() do
        if(v.parent == name and not v.hide) then
            info._hasCfg = true
            return true
        end
    end
    info._hasCfg = false
    return false
end

--@param name 插件名，如果是nil则自动获取selected
function UUI.Right.ADDON_SELECTED(name)
    if not UUI():IsVisible() then return end
    local right = UUI().right
    name = name or U1GetSelectedAddon()

    --如果没有选择任何addon， 则显示更新日志
    if(not name)then
        --TODO: 显示TAB的说明
        --print(U1GetSelectedTag())
        right.hasCfg = nil;
        right.addonName = nil;
        right.tagName = U1GetSelectedTag();
        UUI.Right.TabChange(2)
        right.check:Hide();
        return
    else
        right.addonName = name;
        right.check:Show();
        local info = U1GetAddonInfo(name);
        if(info.ldbIcon)then
            right.check.icon:Show();
            right.check:SetIcon(info.ldbIcon==1 and info.icon or info.ldbIcon);
        else
            right.check.icon:Hide();
        end
        right.check:SetText(U1GetAddonTitle(name));
        right.check:EnableOrDisable(info.installed or info.dummy); --包括文字都disable
        if(info.protected or U1IsAddonCombatLockdown(name)) then
            right.check:Disable(); --只Disable选择框
        end
        right.check:SetChecked(U1IsAddonEnabled(name));

        right.hasCfg = UUI.Right.IsAddonHasCfg(name, info)
        right.check.text:SetWidth(UUI.RIGHT_WIDTH - (right.hasCfg and 163 or 113)); --有Cfg的少个标签所以-163

        UUI.Right.TabChange(right.selectedTab or 1)
    end
end

function UUI.Right.ShowPageBucket(name)
    local self = UUI().right
    CoreCall("CtlShowPage", name, self.pageCfg);
    CoreCall("CtlSearchPage", self.pageCfg, self:GetParent().search:GetSearchText());
    self.pageCfg:Show();
    self.scroll:SetScrollChild(self.pageCfg);
end

function UUI.Right.SetPics(numPics, picsInfos)
    local pics = UUI().right.pageDesc.pics;
    pics.picsInfos = picsInfos
    --图片的设置在UpdateDots中，CreateDots之后会调用
    pics.dots:CreateDots(numPics);
    pics.prev:Hide()
    CoreUIShowOrHide(pics.next, numPics>1);
end

---如果选中标签，则name是nil，靠right.tagName来区分
function UUI.Right.TabChange(state, name, saveLast)
    local right = UUI().right
    name = name or right.addonName
    if not right.hasCfg then
        right.tabs[1]:Hide()
        right.tabBg:SetTexture(UUI.Tex'UI2-tab-3')
        state = 2
    else
        right.tabs[1]:Show()
        right.tabBg:SetTexture(state==1 and UUI.Tex'UI2-tab-1' or UUI.Tex'UI2-tab-2')
    end
    local texL = state==1 and .23 or .12
    right.tabBottom:SetTexCoord(texL,texL+(UUI.RIGHT_WIDTH-44)/512,0,1)
    if saveLast then right.selectedTab = state end

    for _, v in ipairs(right.tabs) do CoreUIEnableOrDisable(v, v:GetID()~=state) end --放在后面是为了state = 2时

    if(state==1) then
        right.pageDesc:Hide();
        right.pageCfg:Hide() --先隐藏，防止闪动
        CoreScheduleBucket("ShowPage", 0.1, UUI.Right.ShowPageBucket, name)
    else
        right.pageCfg:Hide();
        right.pageDesc:Show();
        UUI.Right.SetHTML(right, name)
        --RunOnNextFrame(function() right.pageDesc.html:SetHeight(select(4, right.pageDesc.html:GetBoundsRect()) + 10) end)
        right.scroll:SetScrollChild(right.pageDesc);
        right.scroll.scrollBar:SetValue(0);

        local info = name and U1GetAddonInfo(name)

        if(info and not info._hasPics) then
            if(info.dummy) then
                local group_pics, num_pics
                for k, sub in U1IterateAllAddons() do
                    if(sub.parent==name) then
                        if CoreIsTextureExists(UUI.PICS_ADDON, sub.name) then
                            group_pics = group_pics or {}
                            table.insert(group_pics, format("%s,%d,%d", k, sub.pics or 1, sub.picsWidth or 1024))
                            num_pics = (num_pics or 0) + (sub.pics or 1)
                        end
                    end
                end

                if(group_pics) then
                    info._hasPics = 2
                    info._picsInfos = group_pics
                    info.pics = num_pics
                end
            else
                if(CoreIsTextureExists(UUI.PICS_ADDON, name)) then
                    info._hasPics = 1
                    info.pics = info.pics or 1
                    info._picsInfos = format("%s,%d,%d", name, info.pics or 1, info.picsWidth or 1024)
                end
            end
            info._hasPics = info._hasPics or 0
        end

        if not info or info._hasPics == 0 then
            right.pageDesc.pics:Hide();
            right.pageDesc.html:SetPoint("TOPLEFT", 6, -5);
        else
            UUI.Right.SetPics(info.pics, info._picsInfos);
            right.pageDesc.html:SetPoint("TOPLEFT", right.pageDesc.pics, "BOTTOMLEFT", -1-(right.scroll:GetWidth()-12-200)/2, -20);
            right.pageDesc.pics:Show();
        end
    end
end

--[[------------------------------------------------------------
脚本
---------------------------------------------------------------]]
---更新内存使用信息，处理缩放拖拽
function UUI.OnUpdate(self, elapsed)
    if(self.sizing) then
        local delta = GetCursorPosition()-self.initx
        local factor = 2.5
        if(math.abs(delta)> UUI.BUTTON_W/factor ) then
            local center = self.center;
            local coldelta = math.floor(delta/ UUI.BUTTON_W*factor)
            if(coldelta<0)then coldelta=coldelta+1 end
            local colsOld = center.cols;
            center.cols = center.cols+coldelta;
            if(center.cols<1) then center.cols = 1 end
            if(center.cols> UUI.MAX_COL) then center.cols = UUI.MAX_COL end
            U1DB.cols = center.cols
            self.initx = GetCursorPosition();
            UUI.Center.Refresh();
            UUI.SizeFitCols();
            if(center.cols~=colsOld) then UUI.ChangeWithCols(); end
            UUI.ReloadFlashRefresh();
            self.timer = 0;
            return;
        end
    end

    self.timer = self.timer + elapsed;
    if(self.timer > 3) then
        self.timer = 0;
        UpdateAddOnMemoryUsage()
        UUI.Center.Refresh();
    end
end

function UUI.OnSizeChanged(self)
    if(self.sizing) then UUI.Center.Resize(self.center) end;
end

function UUI.OnShow(self)
    --self:SetSize(840, 465)
    UpdateAddOnMemoryUsage();
    self.left:SetWidth(UUI.LEFT_WIDTH); --没有这句就会出问题！

    U1UpdateTags(); --为什么要在这里UpdateTags? 因为除此之外只有一个事件在Update了
    UUI.Center.Resize(self.center);
    UUI.ChangeWithCols();
    self:SetFrameStrata("MEDIUM");
    self:Raise();
    self.search.onTextChanged(self.search)
    CoreUIShowOrHide(self.search.hint, U1DBG and U1DBG.hintSearch == nil)

    if self.mmbct then self.mmbct:Show(); end --CoreCall("U1_MMBOnFrameShow"); --在Container的OnShow中调用，这里只需要强制显示一下
    
    if self:GetLeft() > GetScreenWidth() - UUI.BORDER_WIDTH
            or self:GetBottom() > GetScreenHeight() - UUI.BORDER_WIDTH
            or self:GetRight() < UUI.BORDER_WIDTH
            or self:GetTop() < UUI.BORDER_WIDTH then
        self:ClearAllPoints()
        self:SetPoint("CENTER")
    end    
end

function UUI:CURRENT_TAGS_UPDATED(...)
    local main = UUI()
    main.left.scroll.update();
    UUI.Center.FilterButtonAdjust(UUI().center.cols);
    local _, num = U1GetTagInfoByName("SINGLE");
    CoreUIEnableOrDisable(main.left.btnSingle, num>0)
end

function UUI:CURRENT_ADDONS_UPDATED(...)
    UUI.Center.Refresh();
    UUI.Center.ScrollToAddon();
end

function UUI:ADDON_SELECTED(name)
    local main = UUI();
    --右侧的操作在右侧事件
    UUI.Center.Refresh();
    if(name) then
        UUI.Center.ScrollToAddon(name);
    else
        --换了tag滚动到最上, 如果是点自己关闭了选择, 通过noevent不触发这里
        main.center.scroll.scrollBar:SetValue(0);
    end
    UUI.Right.ADDON_SELECTED(name);
end

function UUI:DB_LOADED()
    local main = UUI();
    if U1DB.lastSearch then
        main.search:SetSearchText(U1DB.lastSearch)
    end
    main.center.cols = U1DB.cols or UUI.CENTER_COLS;
    UUI.Center.Resize(main.center)
    --UIDropDownMenu_Initialize(UUI().setting.drop, UUI.Top.QuickSettingDropDownMenuInitialize, "MENU"); --taint here
    main.setting.drop:Hide()
    UUI.DB_LOADED = nil
end

function UUI.CreateUI()
    table.insert(UISpecialFrames, U1_FRAME_NAME)
    local main = WW:Frame(U1_FRAME_NAME, UIParent):TR(-250, -160):Size(800,500) --TR(-350, -260)
    :Hide():SetToplevel(1)
    CoreUIMakeMovable(main)
    CoreHookScript(main, "OnMouseDown", UUI.Raise)

    CoreCall("U1MMB_CreateContainer") --必须尽早提前调用

    local tl = CoreUIDrawBorder(main, UUI.BORDER_WIDTH, "U1T_OuterBorder", 32, UUI.Tex'UI2-border-outter-corner', 32, nil)
    tl:SetAlpha(0)

    main:Backdrop("Interface\\DialogFrame\\UI-DialogBox-Background")

    local left = UUI.Left.Create(main)

    main:Texture(nil, "BORDER", UUI.Tex'UI2-corner'):SetTexRotate(90):TR(11,11):Size(64):SetVertexColor(.4,.4,.4)--:SetAlpha(0.4)
    main:Texture(nil, "BORDER", UUI.Tex'UI2-corner'):SetTexRotate(180):BR(11,-11):Size(64):SetVertexColor(.4,.4,.4)--:SetAlpha(0.4)
    main:Texture(nil, "BORDER", UUI.Tex'UI2-corner'):SetTexRotate(-90):BL(-11,-11):Size(64):SetVertexColor(.4,.4,.4)--:SetAlpha(0.4)
    main:Texture(nil, "BACKGROUND", UUI.Tex'UI2-curve'):SetTexRotate(0):TL(-3,9):Size(256,64):SetAlpha(1):SetVertexColor(.7,.7,.7)
    main:Texture(nil, "BORDER", UUI.Tex'UI2-curve'):SetTexRotate("H"):TR(0,-8):Size(256,64):SetAlpha(1):SetVertexColor(.7,.7,.7)
    --左面板和中面板中间的高光
    left:CreateTexture(nil, "BACKGROUND"):SetTexture(UUI.Tex'UI2-shade-dark-deep'):SetWidth(32):SetTexRotate(90):TR(0,0):BR()
    left:CreateTexture(nil, "BACKGROUND"):SetTexture(UUI.Tex'UI2-shade-light'):SetWidth(32):SetTexRotate(-90):TL("$parent","TR",1,0):BR(32,0)
    left:CreateTexture(nil, "BACKGROUND"):SetTexture(UUI.Tex'UI2-line-carve'):SetWidth(8):SetTexRotate(-90):TL("$parent","TR",0,0):BR(8,0)

    --底边阴影
    main:CreateTexture(nil, "BORDER"):SetTexture(UUI.Tex'UI2-shade-dark'):SetHeight(32):SetTexRotate(180):BL():BR()

    --做面板和上面板之间的高光
    main:CreateTexture(nil, "BORDER"):SetTexture(UUI.Tex'UI2-shade-dark'):SetHeight(32):SetTexRotate(180):BL("$parent","TL",0,-UUI.TOP_HEIGHT):BR("$parent","TR",0,-UUI.TOP_HEIGHT)
    main:CreateTexture(nil, "BORDER"):SetTexture(UUI.Tex'UI2-shade-light'):SetHeight(32):TL(0, -UUI.TOP_HEIGHT-1):TR(0, -UUI.TOP_HEIGHT)
    main:CreateTexture(nil, "BORDER"):SetTexture(UUI.Tex'UI2-line-carve'):SetHeight(8):TL(0, -UUI.TOP_HEIGHT):TR(0, -UUI.TOP_HEIGHT)

    main:SetResizable(true);

    --缩放按钮
    main:Texture(nil, nil, "Interface\\BUTTONS\\UI-AutoCastableOverlay", 0.619, 0.760, 0.612, 0.762):Size(14):BR(UUI.BORDER_WIDTH-2, -UUI.BORDER_WIDTH+2)
    local resizeButton = CoreUICreateResizeButton(main(),"BOTTOMRIGHT","BOTTOM", UUI.BORDER_WIDTH-1, -UUI.BORDER_WIDTH+1, 14)
    resizeButton:GetNormalTexture():SetAlpha(0)
    resizeButton:GetPushedTexture():SetAlpha(0)
    resizeButton:HookScript("OnMouseDown", function(self)
        local f = self:GetParent();
        f.sizing = true;
        f.initx = GetCursorPosition();
    end)
    resizeButton:HookScript("OnMouseUp", function(self)
        local f = self:GetParent();
        f.sizing = false;
        UUI.SizeFitCols();
        UUI.Center.ScrollToAddon();
    end)

    --背景不随UI缩放
    main.BG = CoreUIDrawBG(main, "U1T_OuterBG", 0, true)

    ---- 搜索框
    local search = CoreUICreateSearchBox(U1_FRAME_NAME.."AddonSearchBox", main, 300, 24)
    :Key("search"):TL(UUI.LEFT_WIDTH+15, -(UUI.TOP_HEIGHT+10)):TR(-UUI.RIGHT_WIDTH-10,10):SetAlpha(1):un()
    search.tooltipAnchorPoint = "ANCHOR_TOP"
    CoreUIEnableTooltip(search, L["搜索插件及选项"], function(self, tip)
        tip:AddLine(L["输入汉字、全拼或简拼进行检索，只有一个结果时可按回车选定。"], nil,nil,nil,true);
        tip:AddLine(" ");
        tip:AddLine(L["可以搜索插件名称或原名、以及选项中的任意文本，在当前标签下符合条件的插件会被显示出来，被搜索到的选项会被高亮显示。"], nil,nil,nil,true);
        tip:AddLine(" ");
        tip:AddLine(L["仅爱不易官方支持的插件才能用拼音搜索名称。"], 0,0.82,0,true);
    end)

    search.onTextChanged = function(self)
        local text = self:GetSearchText();
        CoreUIShowOrHide(self:GetParent().center.chkLoaded, text=="")
        CoreUIShowOrHide(self:GetParent().center.chkDisabled, text=="")
        U1SearchAddon(text);
        if(U1GetSelectedAddon()) then
            CoreCall("CtlSearchPage", self:GetParent().right.scroll:GetScrollChild(), self:GetSearchText())
            if self:GetParent().right.pageDesc:IsVisible() then
                -- update addon desc highlight
                UUI.Right.SetHTML(self:GetParent().right, U1GetSelectedAddon())
            end
        end
    end

    search.onEnterPressed = function(self)
        if U1GetNumCurrentAddOns()==1 then
            U1SelectAddon(U1GetCurrentAddOnInfo(1), nil)
        end
    end

    --搜索提示
    local f = TplGlowHint(search, "$parentHint", 320):Key("hint"):BOTTOM("$parent", "TOP", -30, 12)
    f.text:SetText(L["这里可以输入汉字或者拼音，例如'|cffffd200对比|r'或者'|cffffd200Grid|r'。不但能查询插件名称，还能查询插件的选项呢！试试输入'|cffffd200对比|r'，然后选|cffffd200\"鼠标提示\"|r插件，选项里就会显示：\n|cffffd200\"是否自动|r|cff00d200对比|r|cffffd200装备\"|r。\n\n让一切功能手到擒来，现在就试试吧！"]);
    f.close:HookScript("OnClick", function() if U1DBG then U1DBG.hintSearch = 1 end end)

    --右侧面板
    UUI.Right.Create(main)

    --中央面板
    UUI.Center.Create(main)

    UUI.Top.Create(main)

    --scripts
    main:SetClampedToScreen(false)
    --main:SetClampRectInsets(-UUI.BORDER_WIDTH, UUI.BORDER_WIDTH, UUI.BORDER_WIDTH, -UUI.BORDER_WIDTH);

    main.animCheck = main:CheckButton(nil, "UICheckButtonTemplate"):SetFrameStrata("TOOLTIP"):Size(24):BR():Hide():EnableMouse(false):un()
    main.animCheck.anim = WW(main.animCheck):CreateAnimationGroup()
    :CreateAnimation("Translation"):Key("move"):SetOffset(50,30):SetDuration(0.4):up()
    :CreateAnimation("Scale"):Key("size"):SetScale(2,2):SetDuration(0.4):up()
    :CreateAnimation("Alpha"):SetFromAlpha(1):SetToAlpha(0)
    :SetDuration(0.4):up()
    :SetScript("OnFinished", function(self) self:GetParent():Hide() end)

    main.timer = 0;
    main:SetScript("OnUpdate", UUI.OnUpdate)
    main:SetScript("OnSizeChanged", UUI.OnSizeChanged)
    main:SetScript("OnShow", UUI.OnShow)
    CoreRegisterEvent("CURRENT_TAGS_UPDATED", UUI);
    CoreRegisterEvent("CURRENT_ADDONS_UPDATED", UUI);
    CoreRegisterEvent("ADDON_SELECTED", UUI);
    CoreRegisterEvent("DB_LOADED", UUI);

    CoreDispatchEvent(main());
    main:RegisterEvent("DISPLAY_SIZE_CHANGED")
    main:RegisterEvent("PLAYER_REGEN_ENABLED")
    main:RegisterEvent("PLAYER_REGEN_DISABLED")
    function main:DISPLAY_SIZE_CHANGED(...)
        if UUI():IsVisible() then
            UUI.Center.Resize(self.center);
            self.left:GetScript("OnSizeChanged")(self.left);
        end
    end
    function main:PLAYER_REGEN_ENABLED(event)
        if UUI():IsVisible() then
            UUI.Center.Refresh()
            UUI.Right.ADDON_SELECTED()
        end
        --CoreUIEnableOrDisable(self.btnLoadAll, not InCombatLockdown())
        --CoreUIEnableOrDisable(self.btnDisAll, not InCombatLockdown())
    end
    function main:PLAYER_REGEN_DISABLED(event)
        --事件触发时仍然是安全的，所以延迟0.1秒
        CoreScheduleTimer(false, 0.1, self.PLAYER_REGEN_ENABLED, self)
    end

    --游戏菜单图标
    WW:Button(nil, GameMenuFrame):Key("btn163"):TL("$parent", "TR", -14-22, 24):Size(60, 60)
    :AddFrameLevel(2, GameMenuFrame)
    :SetScript("OnClick", UUI.ToggleUI)
    :RegisterForDrag("LeftButton")
    :SetScript("OnDragStart", function() GameMenuFrame:StartMoving() end)
    :SetScript("OnDragStop", function() GameMenuFrame:StopMovingOrSizing() end)
    :SetScript("OnEnter", function(self) UICoreFrameFlash(self:GetHighlightTexture(), 0.5 , 0.5, -1,nil, 0, 0) end)
    :SetScript("OnLeave", function(self) UICoreFrameFlashStop(self:GetHighlightTexture()) end)
    :CreateTexture():SetTexture(UUI.Tex"UI2-logo"):Size(87):TL(-14, 18):up()
    :CreateTexture():TL(-20,20):BR(20, -20):SetTexture("Interface\\UnitPowerBarAlt\\Atramedes_Circular_Flash"):SetAlpha(0.8):ToTexture("Highlight"):up()
    :un()
    CoreUIEnableTooltip(GameMenuFrame.btn163, L["爱不易"], L["点击爱不易标志开启插件控制中心\n \nCtrl点击小地图图标可以收集/还原"])

end

---必须在DB创建之后调用
function U1_CreateMinimapButton()

    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject(U1Name, {
        type = "launcher",
        label = L["爱不易"],
        icon = UUI.Tex'UI2-icon',
        iconCoords = {0.04+0.05, 26/32-0.06+0.05, 0.06, 26/32-0.10},
        OnEnter = CoreUIShowTooltip,
        OnClick = function(self, button)
            GameTooltip:Hide();
            if button=="RightButton" then
                UUI.Top.ToggleQuickSettingDropDown(self)
            else
                CloseDropDownMenus(1);
                UUI.ToggleUI(self, button)
            end
        end,
        OnTooltipShow = function(tip)
            tip:AddLine(L["爱不易插件中心"])
            tip:AddLine(L["爱不易是新一代整合插件。其设计理念是兼顾整合插件的易用性和单体插件的灵活性，同时适合普通和高级用户群体。|n|n    功能上，爱不易实现了任意插件的随需加载，并可先进入游戏再逐一加载插件，此为全球首创。此外还有标签分类、拼音检索、界面缩排等特色功能。"], nil, nil, nil, 1)
            tip:AddLine(" ")
            tip:AddLine(L["鼠标右键点击可打开快捷设置"], 0, 0.82, 0)
            tip:AddLine(L["Ctrl点击任意小地图按钮可收集"], 0, 0.82, 0)
            if LibDBIcon10_U1MMB.__flash:IsVisible() then
                tip:AddLine(" ");
                tip:AddLine(L["图标闪光表示有新的小地图按钮被收集到控制台中， 请点击查看，下次就不再闪烁了"], 0, 0.82, 0, 1);
            end
        end,
    })
    U1DB.minimapPos = U1DB.minimapPos or 191
    LibStub("LibDBIcon-1.0"):Register("U1MMB", ldb, U1DB);
    CoreUICreateFlash(LibDBIcon10_U1MMB, "Interface\\UnitPowerBarAlt\\Generic1Party_Circular_Flash");
    U1_CreateMinimapButton = nil
end

function UUI.ToggleUI(self, button)
    if GameMenuFrame:IsVisible() then HideUIPanel(GameMenuFrame) end
    if UUI():IsVisible() then UUI():Hide() else UUI():Show() end
end

function UUI.OpenToAddon(addon, forceSelect)
    if not UUI():IsShown() then
        UUI():Show();
    end
    if forceSelect then
        local tags = U1GetAddonInfo(addon).tags
        UUI().search:SetText("")
        UUI().search:ClearFocus();
        U1SelectTag(tags and tags[1] or UUI.DEFAULT_TAG)
        U1SelectAddon(addon)
    else
        UUI.Right.ADDON_SELECTED(addon)
    end
end

CoreUIRegisterSlash('163CFGTOGGLE', '/163', '/163ui', UUI.ToggleUI)

function UUI.Clean()
    UUI.Right.Create = nil
    UUI.Left.Create = nil
    UUI.Center.Create = nil
    UUI.Left.CreateScrollButton = nil
    UUI.Top.Create = nil
    UUI.Right.CreatePageDesc = nil
    UUI.CreateUI = nil
    UUI.Clean = nil
end

if DEBUG_MODE then
    _G.U1Name = _G.U1Name or U1Name
    _G.get=function()return UUI() end
    if not UUI.FIRST then
        WWRun(UUI.CreateUI, U1_FRAME_NAME); UUI.FIRST = true;
    else
        WW:Run(function(name)
            U1_FRAME_NAME = name;
            UUI.CreateUI()
        --if U1DB then U1DB.lastSearch = nil end
        --U1SelectTag(UUI.DEFAULT_TAG)
        end)
    end
    if IsLoggedIn() then get():Show() else CoreOnEvent("PLAYER_ENTERING_WORLD", function() get():Show() return 1 end) end
else
    UUI.CreateUI();
    UUI.Clean();
end
