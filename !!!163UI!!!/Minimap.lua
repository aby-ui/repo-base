local _ = ...;
local L = select(2, ...).L

--必须在hook之前设置
QueueStatusMinimapButton:SetPoint("TOPLEFT", 17, -94)

function U1MMB_HasConflictAddons()
    return MBB_Version or MBBFrame or MBFversion or (NxMapDock and NxMapDock:IsVisible()) or IsAddOnLoaded("Mappy")
end

--skipList是永远不会被处理的图标名.
local protectList = {
    "LibDBIcon10_U1MMB",
    "QueueStatusMinimapButton",
    "MiniMapMailFrame",
    "MiniMapTracking",
    "LibDBIcon10_GLPMMB",
}
for i=1, #protectList do protectList[protectList[i]] = true end

--no used
local forceCollect = {
    'HealiumMiniMap',
}

--这是默认会被加入的. 逻辑是从数据库里加上要加入的，再减去不加入的, 在OnLoad之后会调整
local defaultCollectSet = {}

--DB对应
local collectList = {}
local collectSet = {} for i=1, #collectList do collectSet[collectList[i]] = true end --快速索引
local ignoreList = {}
local ignoreSet = {} for i=1, #ignoreList do ignoreSet[ignoreList[i]] = true end --快速索引

local hookedList = {} --只用来记录一个按钮是否已经被hook了，另外也负责记录顺序，顺序就是插件加载的顺序，很固定。

local newlyCollected = {} --新加入的按钮, 用来闪光

function U1MMB_ShouldCollect(name)
    return collectSet[name] or (defaultCollectSet[name] and not ignoreSet[name])
end

function U1MMB_SpecialCall(btn, funcName, ...)
    btn._specialCall = true;
    btn[funcName](btn, ...)
    btn._specialCall = nil;
end

local function tipAddLine(self, tip)
    if U1MMB_HasConflictAddons() then return end
    --tip:AddLine("小地图图标收集");
    local text;
    if(self._base:GetParent()==Minimap)then
        text = L["按住CTRL点击可以收集"];
    else
        text = L["按住CTRL点击可以还原"];
    end
    tip:AddLine(text, 0, 0.82, 0, 1);
end

local function mmbOnMouseDown(self) if self._hookOnMouseDown then self._hookOnMouseDown(self) end end
local function mmbOnDragStart(self) if self._hookOnDragStart then self._hookOnDragStart(self) end end
local function mmbHookOnMouseDown(self) self:GetScript("OnMouseUp")(self) end
local function mmbHookOnDragStart(self) self:GetScript("OnDragStop")(self) end
local function mmbHookOnShow(self)
    --HookOnShow的作用是在初始时刻可以记录位置的变动，而不显示按钮，而当按钮被收集后又由于配置隐藏了，也能进行处理
    if(self._hidden) then self._hidden = nil end --hidden是用来标记在收集状态下被单独隐藏的.
    if not self._specialCall and U1MMB_ShouldCollect(self:GetName()) then
        if not U1MMB_GetContainer():GetParent():IsVisible() then
            self:Hide()
        else
            U1_MMBUpdateUI();
        end
    end
end

local function mmbHookOnHide(self)
    if(not self._specialCall) then
        --对于我们发起的隐藏不处理
        if self:GetParent()==U1MMB_GetContainer() and U1MMB_GetContainer():GetParent():IsVisible() then
            self._hidden = true
            if(strlen(_)~=11) then U1_MMBRestore(self); end --插件名保护，如果用Restore意思是隐藏以后就不再收纳了, 但是会导致客户端崩溃...
            U1_MMBUpdateUI()
        end
    end
end

local function mmbHookOnLeave(self)
    GameTooltip:Hide()
end

local function mmbHookOnEnterNoOrigin(self)
    self.tooltipText = tipAddLine;
    CoreUIShowTooltip(self);
end

local function mmbHookOnEnter(self)
    if(GameTooltip:IsVisible()) then
        GameTooltip:AddLine(" ");
        tipAddLine(self, GameTooltip);
        GameTooltip:Show();
    else
        mmbHookOnEnterNoOrigin(self);
    end
    if self:GetName() and newlyCollected[self:GetName()] then newlyCollected[self:GetName()] = nil end
    if self.__flash then UICoreFrameFlashStop(self.__flash); end
end

local function mmbHookOnClick(self, ...)
    if(IsControlKeyDown() and not IsShiftKeyDown() and not IsAltKeyDown()) then
        if(self._base:GetParent()==Minimap)then
            U1_MMBCollect(self, true);
        else
            U1_MMBRestore(self);
            --U1_Raise(false);
        end
        U1_MMBUpdateUI();
    else
        --U1_CloseCompactMode(); --还原并不好用.
        if(GameMenuFrame:IsVisible())then
            HideUIPanel(GameMenuFrame);
        end
        UUI.Raise(false);
        if(self._originOnClick) then
            self._originOnClick(self, ...);
        end
    end
end

local function hookButton(btn, name)
    --需要处理FishBuddy这种外面有个Frame的
    if btn:GetObjectType()~="Button" then
        for j=1, select("#", btn:GetChildren()) do
            local sub = select(j, btn:GetChildren());
            if sub:GetObjectType()=="Button" and sub:GetWidth()>17 then
                sub._base = btn
                btn = sub
                name = btn:GetName()
                break
            end
        end
        if not btn._base then return end
    else
        btn._base = btn;
    end

    hookedList[btn] = true
    btn._base:SetToplevel(true);
    table.insert(hookedList, btn) --用table来保证顺序
    --btn:SetFrameStrata("LOW");
    hooksecurefunc(btn._base, "Show", mmbHookOnShow);
    hooksecurefunc(btn._base, "Hide", mmbHookOnHide);
    hooksecurefunc(btn._base, "SetPoint", mmbHookOnShow); --新机制需要的

    if(btn:GetScript("OnMouseDown")) then btn:HookScript("OnMouseDown", mmbOnMouseDown) end
    if(btn:GetScript("OnDragStart")) then btn:HookScript("OnDragStart", mmbOnDragStart) end
    if btn:GetScript("OnEnter") then
        CoreHookScript(btn, "OnEnter", mmbHookOnEnter)
    else
        btn:SetScript("OnEnter", mmbHookOnEnterNoOrigin);
        CoreHookScript(btn, "OnLeave", mmbHookOnLeave);
    end
    btn._originOnClick = btn:GetScript("OnClick");
    btn:SetScript("OnClick", mmbHookOnClick);

    if(U1MMB_ShouldCollect(name))then
        U1_MMBInitialCollect(btn);
    end
    return btn
end

local initReallyComplete --用来在RunOnNextFrame里也能判断是否初始化完毕
function U1MMB_CheckMinimapChildren()
    if U1MMB_HasConflictAddons() then return end --防止死循环
    local hasnew;
    --TODO: OutfitterMinimapButton父是MinimapBackdrop的
    for i=1, select("#", Minimap:GetChildren()) do
        local btn = select(i, Minimap:GetChildren());
        if not btn or btn=="MinimapBackdrop" or btn:IsProtected() or btn.__u1mmbchecked then
            --continue --如果不增加安全按钮保护判断，则会报 Interface\FrameXML\RestrictedExecution.lua:375: Cannot declare closure factories from insecure code
        else
            local name = btn:GetName();
            if(name and name:sub(1,13)=="HandyNotesPin") then
                --HandyNotes卡顿
            elseif(not hookedList[btn]) then
                btn.__u1mmbchecked = 1
                local name = btn:GetName();
                if name and not protectList[name] then
                    local width = btn:GetWidth();
                    if(width>17 and width<39) then
                        if hookButton(btn, name) then
                            hasnew = true
                        end
                    end
                end
            end
        end
    end
    if hasnew then
        --当已经收集的小地图按钮被修改位置时，不动。必须用GetParent()来判断，因为右侧区域可以隐藏
        local mmbct = U1MMB_GetContainer()
        if mmbct and mmbct:GetParent():IsVisible() then
            U1_MMBUpdateUI(); --保持位置不变
        end
    end
    if U1IsInitComplete() then initReallyComplete = true end
end

---@param manully表示当玩家手工把一个图标收回时, 才记录到collectList里
function U1_MMBCollect(btn, manually)
    if U1MMB_HasConflictAddons() then return end
    
    local container = U1MMB_GetContainer()

    btn._base = btn._base or btn;
    if manually then
        collectSet[btn:GetName()] = true;
        collectSet[btn._base:GetName()] = true;
        tinsertdata(collectList, btn:GetName());
        tinsertdata(collectList, btn._base:GetName());
    end
    ignoreSet[btn:GetName()] = nil;
    ignoreSet[btn._base:GetName()] = nil;
    tremovedata(ignoreList, btn:GetName());
    tremovedata(ignoreList, btn._base:GetName());

    --btn:SetParent(U1MMB_GetContainer()); --我们是希望只有当显示的才设置parent, 这样保持其他插件对位置的修改
    U1MMB_SpecialCall(btn._base, "Hide") --隐藏即可, 在控制台显示的时候会显示出来, 这里不直接放到控制台中, 是为了防止之后又修改位置.

    if initReallyComplete then --因为是下一帧才调用的，所以不能用U1IsInitComplete
        newlyCollected[btn:GetName()] = true;
        if not container:GetParent():IsVisible() then U1_MMBStartFlash(); end
    end
end

---供外部调用
function U1_MMBAddDefaultCollect(name)
    defaultCollectSet[name] = true;
end

local function restorePos(btn)
    --btn:SetUserPlaced(true);
    btn = btn._base;
    U1MMB_SpecialCall(btn, "SetParent", Minimap);
    btn:SetFrameStrata("LOW");
    local s = btn._savepos;
    if s then
        btn:SetScale(s[6]);
        btn:ClearAllPoints();
        U1MMB_SpecialCall(btn, "SetPoint", s[1],s[2],s[3],s[4],s[5]);
        btn:SetFrameLevel(s[7]);
    end
end
function U1_MMBRestore(btn, noset)
    if U1MMB_HasConflictAddons() then return end
    if not noset then
        collectSet[btn:GetName()] = nil;
        collectSet[btn._base:GetName()] = nil;
        tremovedata(collectList, btn:GetName());
        tremovedata(collectList, btn._base:GetName());
        ignoreSet[btn:GetName()] = true;
        ignoreSet[btn._base:GetName()] = true;
        tinsertdata(ignoreList, btn:GetName());
        tinsertdata(ignoreList, btn._base:GetName());
    end

    if btn.__flash then UICoreFrameFlashStop(btn.__flash); end
    restorePos(btn);
    btn._hookOnMouseDown = nil;
    btn._hookOnDragStart = nil;
    --btn:Show();
end

function U1_MMBCollectAll()
    for _, btn in ipairs(hookedList) do
        if btn._base:GetParent()~=U1MMB_GetContainer() then U1_MMBCollect(btn, true); end
    end
end
function U1_MMBRestoreAll()
    for _, btn in ipairs(hookedList) do
        if btn._base:GetParent()==U1MMB_GetContainer() then U1_MMBRestore(btn); end
    end
end

---被CreateUI调用的创建函数
function U1MMB_CreateContainer()
    --主界面上的区域
    local ct = WW:Frame(nil, UUI()):Key("mmbct"):TL("$parent", "TR", 13,8):Size(43,200):Backdrop("Interface\\DialogFrame\\UI-DialogBox-Background", nil, 5, 3):un();
    CoreUIDrawBorder(ct, 1, "U1T_InnerBorder", 16, UUI.Tex'UI2-border-inner-corner', 16, true)
    CoreUIDrawBG(ct, "U1T_OuterBG", 2, true)
    UUI.MakeMove(ct)

    CoreHookScript(ct, "OnHide", U1_MMBOnFrameHide);
    CoreHookScript(ct, "OnShow", U1_MMBOnFrameShow);

    --游戏菜单附着区域
    local ct = WW:Frame(nil, GameMenuFrame):Key("mmbct"):TL("$parent", "TR", -14, 0):Size(100,GameMenuFrame:GetHeight()):AddFrameLevel(-1, GameMenuFrame)
    :Backdrop("Interface\\DialogFrame\\UI-DialogBox-Background","Interface\\DialogFrame\\UI-DialogBox-Border", 32, 8, 32)
    :Frame():Key("btn"):TL(-22, 24):Size(60, 60):AddFrameLevel(2, GameMenuFrame):Hide()
    :Frame():Key("first"):up() --游戏菜单图标下的第一个位置的占位符
    :up():un()

    CoreUIMakeMovable(ct, GameMenuFrame)
    GameMenuFrame:SetMovable(true);

    CoreHookScript(ct, "OnHide", U1_MMBOnFrameHide);
    CoreHookScript(ct, "OnShow", U1_MMBOnFrameShow);
end

function U1MMB_GetContainer()
    if not GameMenuFrame.mmbct then return end --没有mmbct则表示还未创建
    return GameMenuFrame:IsVisible() and GameMenuFrame.mmbct or UUI().mmbct;
end

local function updateGameMenuHeight(self) self:SetHeight(GameMenuFrame:GetHeight()) end
---核心函数
function U1_MMBUpdateUI()
    local ct = U1MMB_GetContainer();

    --有冲突插件或者容器未显示就不用处理，所以要强制显示容器
    if U1MMB_HasConflictAddons() or not ct:GetParent():IsVisible() then
        return
    end

    local compact = GameMenuFrame:IsVisible()

    local MAX_HEIGHT = compact and GameMenuFrame:GetHeight() or select(2, UUI():GetMinResize())
    local OFFSET_X  = compact and 13 or 6;
    local OFFSET_Y  = compact and 12 or 5;
    local PADDING_X = compact and 1 or -1
    local PADDING_Y = compact and -1 or -1;
    local SCALE     = compact and 1 or 1;
    local SIZE = 32*SCALE;

    local COUNT = 0;

    --计算要收集的按钮数量
    for i, btn in ipairs(hookedList) do
        if U1MMB_ShouldCollect(btn:GetName()) and not btn._base._hidden then COUNT = COUNT + 1 end
    end

    if compact then
        ct:SetBackdropColor(1,1,1,COUNT==0 and 0 or 0.6)
        ct:SetBackdropBorderColor(1,1,1,COUNT==0 and 0 or 0.6)
        if COUNT > 1 then
            --处理占位符, 最后要删除掉,如果只有一个按钮就不加占位符了
            ct.btn.first._base =  ct.btn.first
            ct.btn.first._holder = 1
            ct.btn.first:SetSize(SIZE,SIZE);
            table.insert(hookedList, 1, ct.btn.first);
            COUNT = COUNT + 1
        end
    end

    local maxLines = math.floor((MAX_HEIGHT - OFFSET_Y*2) / (SIZE + PADDING_Y))
    local cols = math.ceil(COUNT / maxLines);

    --没有任何按钮的时候隐藏, 对于compact是肯定不会隐藏的, 所有IsVisible判断改为parent:IsVisible()
    if not compact and cols == 0 then
        ct:Hide()
        return
    end

    ct:Show();

    local actualLines = math.ceil(COUNT / max(1,cols) )
    local height =  actualLines*(SIZE+PADDING_Y)+OFFSET_Y*2;
    if compact then
        local modi = (MAX_HEIGHT - height) / (actualLines + 1)
        PADDING_Y = PADDING_Y + modi
        OFFSET_Y = OFFSET_Y + modi/2
        PADDING_X = PADDING_X + (modi >= 6 and 3 or 0)
        ct:SetHeight(MAX_HEIGHT)
        RunOnNextFrameKey(ct, updateGameMenuHeight) --for acp add game menu button.
    else
        ct:SetHeight(height)
    end
    ct:SetWidth((SIZE+PADDING_X)*cols-PADDING_X+OFFSET_X*2)

    local last;
    local width = 0;
    local lines = 0;
    for i, btnReal in ipairs(hookedList) do
        local btn = btnReal._base;
        if btnReal._holder or ( U1MMB_ShouldCollect(btnReal:GetName()) and not btn._hidden ) then
            if(btn:GetParent()==Minimap)then
                local save = btn._savepos or {};
                btn._savepos = save;
                save[1], save[2], save[3], save[4], save[5] = btn:GetPoint();
                save[6] = btn:GetScale();
                save[7] = btn:GetFrameLevel();
            end
            --btn:SetUserPlaced(false);
            U1MMB_SpecialCall(btn, "SetParent", ct); --SetParent会触发OnShow
            --btn:SetFrameLevel(top:GetFrameLevel()+1)
            btn:ClearAllPoints();
            btnReal._hookOnMouseDown = (not btnReal:GetName() or not btnReal:GetName():find("LibDBIcon10_")) and mmbHookOnMouseDown or nil; --LibDBIcon的MouseDown只是设置按下效果的
            btnReal._hookOnDragStart = mmbHookOnDragStart;
            btn:SetScale(SCALE);
            width = width + (SIZE+PADDING_X)
            if(last==nil or width > ct:GetWidth()) then
                U1MMB_SpecialCall(btn, "SetPoint", "TOPLEFT", ct, "TOPLEFT", OFFSET_X/SCALE, -(SIZE+PADDING_Y)/SCALE*(lines)-(OFFSET_Y)/SCALE);
                width = (SIZE+PADDING_X) + OFFSET_X;
                lines = lines + 1;
            else
                U1MMB_SpecialCall(btn, "SetPoint", "LEFT", last, "RIGHT", PADDING_X, 0);
            end
            U1MMB_SpecialCall(btn, "Show");
            if(newlyCollected[btnReal:GetName()]) then
                local flash = CoreUICreateFlash(btnReal, "Interface\\Vehicles\\VehicleSeats", 0.21,0.3828125,0.06,0.78125);
                UICoreFrameFlashStop(flash);
                UICoreFrameFlash(flash, 0.5, 0.5, -1, nil, 0, 0, "U1MinimapFlash");
            else
                if btnReal.__flash then UICoreFrameFlashStop(btnReal.__flash); end
            end
            last = btn;
        end
    end

    if compact and hookedList[1] and hookedList[1]._holder then
        table.remove(hookedList, 1);
    end

end

--初始收集, 指在玩家用鼠标点击控制之前的处理, 已经统一了, 暂时保留
function U1_MMBInitialCollect(btn)
    U1_MMBCollect(btn, false); --收纳小地图按钮
end

function U1_MMBStartFlash()
    local flash = LibDBIcon10_U1MMB.__flash;
    UICoreFrameFlashStop(flash);
    UICoreFrameFlash(flash, 0.5 , 0.5, -1,nil, 0, 0);
end

--当界面显示出来时的回调
function U1_MMBOnFrameShow(self)
    if U1MMB_HasConflictAddons() then self:Hide() end
    UICoreFrameFlashStop(LibDBIcon10_U1MMB.__flash);
    U1_MMBUpdateUI();
end

function U1_MMBOnFrameHide()
    table.wipe(newlyCollected)
end

function U1MMB_ADDON_LOADED(event, ...)
    local db = U1DB;
    if db.collectList == nil then
        db.collectList = collectList
    else
        collectList = db.collectList;
        table.wipe(collectSet)
        for i=1, #collectList do collectSet[collectList[i]] = true end
    end

    if db.ignoreList == nil then
        db.ignoreList = ignoreList
    else
        ignoreList = db.ignoreList;
        table.wipe(ignoreSet);
        for i=1, #ignoreList do ignoreSet[ignoreList[i]] = true end
    end

    for _, btn in ipairs(hookedList) do
        if U1MMB_ShouldCollect(btn:GetName()) then
            U1_MMBInitialCollect(btn);
        end
    end

    return 1;
end

function U1MMB_PLAYER_LOGOUT(event)
    if U1MMB_HasConflictAddons() then return end
    for _, btn in ipairs(hookedList) do
        if(btn._base:GetParent()==U1MMB_GetContainer()) then
            restorePos(btn);
        end
    end
end

WW:Frame("MinimapZoom", Minimap):SetFrameStrata("LOW"):EnableMouse(false):ALL():SetScript("OnMouseWheel", function(self, delta)
    if IsModifierKeyDown() then return end
    if ( delta > 0 ) then
        if MinimapZoomIn:IsEnabled() then Minimap_ZoomInClick(); end
    elseif ( delta < 0 ) then
        if MinimapZoomOut:IsEnabled() then Minimap_ZoomOutClick(); end
    end
end):un();

function U1MMB_MinimapZoom_Toggle(enable)
    if enable then
        MinimapZoomIn:Hide();
        MinimapZoomOut:Hide();
        MinimapZoom:Show();
    else
        MinimapZoomIn:Show();
        MinimapZoomOut:Show();
        MinimapZoom:Hide();
    end
end

function U1_MMBCreateCoordsButton()
    local btn = CreateFrame("Frame","MinimapCoordsButton",UIParent)
    btn:SetBackdrop({edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",edgeSize = 11,})
    btn:EnableMouse(true)
    btn:SetMovable(true)
    btn:SetSize(55, 20)
    btn:SetPoint("TOPRIGHT",Minimap,"BOTTOMRIGHT",15,6)
    CoreUIMakeMovable(btn);
    local tex= btn:CreateTexture(nil,"ARTWORK")
    tex:SetTexture(0,0,0,0.5)
    tex:SetAllPoints(btn)
    local fot= btn:CreateFontString(nil,"ARTWORK","GameFontNormal")
    fot:SetPoint("CENTER")
    local HBD = LibStub("HereBeDragons-2.0")
    local function MinimapCoordsButton_OnUpdate()
        local px, py = HBD:GetPlayerZonePosition(false)
        if not px or not py then btn.originShown = btn:IsShown() btn:Hide() return end
        if btn.originShown then btn:Show() btn.originShown = nil end
        if(px == 0 and py == 0) then
            fot:SetText("无坐标");
        else
            fot:SetFormattedText("%d, %d", px * 100, py * 100);
        end
    end
    CoreScheduleTimer(true, 0.1, MinimapCoordsButton_OnUpdate)
    btn:Show()
    CoreHideOnPetBattle(btn)
    U1_MMBCreateCoordsButton = nil
end

U1_MMBCreateCoordsButton();
--{"GameTimeFrame","TimeManagerClockButton","MiniMapWorldMapButton","MiniMapMailFrame","MiniMapTracking","MiniMapVoiceChatFrame","QueueStatusMinimapButton","MiniMapInstanceDifficulty","GuildInstanceDifficulty","MinimapZoomIn","MinimapZoomOut"}
--/run a = {"MiniMapMailFrame","MiniMapTracking","MiniMapVoiceChatFrame","QueueStatusMinimapButton","MiniMapInstanceDifficulty",} for i=1,#a do _G[a[i]]:Show() end

--战斗中停止检查小地图按钮
local checkTimer, stopCheckTimer
local function startCheckTimer()
    U1MMB_CheckMinimapChildren();
    checkTimer = CoreScheduleTimer(true, 3, U1MMB_CheckMinimapChildren)
    CoreOnEvent("PLAYER_REGEN_DISABLED", stopCheckTimer)
    return true
end
function stopCheckTimer()
    if checkTimer then
        CoreCancelTimer(checkTimer);
        checkTimer = nil;
    end
    CoreOnEvent("PLAYER_REGEN_ENABLED", startCheckTimer)
    return true
end
CoreOnEvent("PLAYER_LOGIN", startCheckTimer)
