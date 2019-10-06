local AddonName = ...
local SelectedError = 1;
local ErrorList = {};
local SoundTime = 0;
local QueueError = {};
local Config;
local SoundEditBox;
local ClearFocus = CreateFrame("EditBox");
ClearFocus:SetAutoFocus(nil);
ClearFocus:SetScript("OnEditFocusGained", function(self)
    self:ClearFocus();
end);


local DefaultSound = "sound\\doodad\\belltolltribal.ogg";

local CheckButtons = {
    {Text="在聊天窗中显示错误信息", SavedVar="Messages", Default=false},
    {Text="显示'插件被阻止'的错误(安全污染)", SavedVar="Taint", Default=false},
    {Text="播放音效", SavedVar="PlaySound", Default=false},
};

local EventFuncs;
EventFuncs = {
    ADDON_LOADED = function(addon)
        if addon == AddonName then
            Config = BaudErrorFrameConfig;
            if(type(Config)~="table")then
                Config = {
                    PlaySound = false,
                    Messages = false,
                    Taint = false,
                    minimapPos = 322.5,
                };
                BaudErrorFrameConfig = Config;
            end
            BaudErrorFrameMinimapButton_Create();
            if(Config.Sound == nil)then
                --Backwards compatability
                Config.Sound = BaudErrorFrameSound or DefaultSound;
            end
            SoundEditBox:SetText(Config.Sound);
            SoundEditBox:SetCursorPosition(0);
            SoundEditBox:SetScript("OnChar", function(self)
                Config.Sound = self:GetText();
            end);

            for Key, Value in ipairs(CheckButtons)do
                if(Config[Value.SavedVar]==nil)then
                    Config[Value.SavedVar] = Value.Default;
                end
                Value.Button:SetChecked(Config[Value.SavedVar]);
            end

            for Key, Value in ipairs(QueueError)do
                BaudErrorFrameShowError(Value);
            end
            QueueError = nil;

            EventFuncs.ADDON_LOADED = nil
            BaudErrorFrame:UnregisterEvent("ADDON_LOADED")
        end
    end,

    --[[ abyui 8.2.0 by hook DisplayInterfaceActionBlockedMessage
    ADDON_ACTION_BLOCKED = function(AddOn, FuncName)
        if Config.Taint then
            BaudErrorFrameAdd(format("插件[%s]对接口'%s'的调用导致界面行为失效", AddOn, FuncName), 4);
        end
    end,

    MACRO_ACTION_BLOCKED = function(FuncName)
        if Config.Taint then
            BaudErrorFrameAdd(format("宏代码对接口'%s'的调用导致界面行为失效", FuncName), 4);
        end
    end,
    --]]

    ADDON_ACTION_FORBIDDEN = function(AddOn,FuncName)
        if Config.Taint then
            BaudErrorFrameAdd(format("插件[%s]试图调用接口'%s'，该功能只对暴雪的UI开放。", AddOn, FuncName), 4);
        end
    end,

    MACRO_ACTION_FORBIDDEN = function(FuncName)
        if Config.Taint then
            BaudErrorFrameAdd(format("宏代码试图调用接口'%s'，该功能只对暴雪的UI开放。", FuncName), 4);
        end
    end,

};

function BaudErrorFrame_OnLoad(self)
    tinsert(UISpecialFrames, self:GetName());
    self:RegisterForDrag("LeftButton");
    self:RegisterForClicks("LeftButtonUp","RightButtonUp");
    self:SetScript("OnClick", function()
        ClearFocus:SetFocus();
    end);

    for Key, Value in pairs(EventFuncs)do
        self:RegisterEvent(Key);
    end
    self:SetScript("OnEvent", function(self, event, ...)
        EventFuncs[event](...);
    end);
    seterrorhandler(BaudErrorFrameHandler);
    if DisplayInterfaceActionBlockedMessage then
        hooksecurefunc("DisplayInterfaceActionBlockedMessage", function()
            if Config.Taint then
                BaudErrorFrameAdd(date("%H:%M:%S") .. " 插件导致界面行为失效", 4);
            end
        end)
    end

    UIParent:UnregisterEvent("MACRO_ACTION_BLOCKED");
    UIParent:UnregisterEvent("ADDON_ACTION_BLOCKED");
    UIParent:UnregisterEvent("MACRO_ACTION_FORBIDDEN");
    UIParent:UnregisterEvent("ADDON_ACTION_FORBIDDEN");

    self:SetResizable(true);
    self:SetMinResize(400,300);
    self:SetMaxResize(UIParent:GetWidth()-100,UIParent:GetHeight()-100);
    local btn = CreateFrame("Button", "$parentResizeButton", self);
    btn:SetSize(16, 16);
    btn:SetPoint("BOTTOMRIGHT", -4, 5);
    btn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up");
    btn:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight");
    btn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down");
    btn:SetScript("OnMouseDown", function(self) self:GetParent():StartSizing("BOTTOMRIGHT") end);
    btn:SetScript("OnMouseUp", function(self)
        BaudErrorFrame:StopMovingOrSizing();
        BaudErrorFrameEditBox:SetWidth(BaudErrorFrameDetailScrollFrame:GetWidth()-48)
        BaudErrorFrame:SetUserPlaced(false)
    end);
end

function BaudErrorFrameMinimapButton_OnClick(self, button)
    if(button=="LeftButton")then
        BaudErrorFrame:Show();
    else
        InterfaceOptionsFrame_OpenToCategory("错误提示配置");
    end
end


function BaudErrorFrameMinimapButton_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
    GameTooltip:AddLine("错误提示增强");
    GameTooltip:AddLine("左键点击查看错误",1,1,1);
    GameTooltip:AddLine("右键点击打开配置",1,1,1);
    GameTooltip:AddLine("按住鼠标左键可拖动",1,1,1);
    GameTooltip:Show();
end


function BaudErrorFrameMinimapButton_OnLeave()
    GameTooltip:Hide();
end

function BaudErrorFrameMinimapButton_Create()
    local ldb = LibStub("LibDataBroker-1.1"):NewDataObject("!BaudErrorFrame", {
        type = "launcher",
        label = "错误提示增强",
        icon = "Interface\\Buttons\\UI-MicroButton-MainMenu-Up",
        iconCoords = {0.09375+0.05, 0.90625+0.05, 0.46875, 0.859375},
        OnClick = BaudErrorFrameMinimapButton_OnClick,
        OnEnter = BaudErrorFrameMinimapButton_OnEnter,
    })
    LibStub("LibDBIcon-1.0"):Register("BaudErrorFrame", ldb, BaudErrorFrameConfig);

    local count = LibDBIcon10_BaudErrorFrame:CreateFontString("BaudErrorFrameMinimapCount", "OVERLAY", "GameFontGreenSmall")
    count:SetPoint("CENTER", -1, 2)
end

function BaudErrorFrameHandler(Error)
    BaudErrorFrameAdd(Error,4);
end

function BaudErrorFrameShowError(Error)
    if(U1GetAddonInfo and not DEBUG_MODE) then
        return
    end
    if Config.Messages then
        DEFAULT_CHAT_FRAME:AddMessage(Error,0.8,0.1,0.1);
    end
    if(GetTime() > SoundTime)and Config.PlaySound then
        PlaySoundFile(Config.Sound);
        SoundTime = GetTime() + 1;
    end
end


function BaudErrorFrameAdd(Error, Retrace)
    if Error and Error:find("StaticPopup%.lua:[0-9]+: bad argument #2 to 'SetFormattedText' %(number expected, got nil%)") then return end
    for Key, Value in pairs(ErrorList)do
        if(Value.Error==Error)then
            if(Value.Count < 99)then
                Value.Count = Value.Count + 1;
                BaudErrorFrameEditBoxUpdate();
            end
            return;
        end
    end
    if Config then
        BaudErrorFrameShowError(Error);
    else
        tinsert(QueueError, Error);
    end
    local error = {Error=Error,Count=1,Stack="\n"..debugstack(Retrace), locals={} }
    tinsert(ErrorList,error);
    if(DEBUG_MODE) then
        for i=Retrace, 100 do local info = debuglocals(i) if info and #info>0 then error.locals[i-Retrace+1] = info end end
        local line = 0
        error.Stack = error.Stack:gsub("\n", function()
            line = line + 1;
            return error.locals[line] and "\n["..line.."] " or "\n"
        end)
    end
    
    BaudErrorFrameMinimapCount:SetText(#ErrorList - (BaudErrorFrame.lastCount or 0));

    if U1MMB_ShouldCollect and U1MMB_ShouldCollect("LibDBIcon10_BaudErrorFrame") and _G[U1_FRAME_NAME] and not _G[U1_FRAME_NAME]:IsVisible() and LibDBIcon10_U1MMB then
        --U1_MMBStartFlash()
        U1_MMBCollect(LibDBIcon10_BaudErrorFrame)
    end

    LibDBIcon10_BaudErrorFrame:Show();
    BaudErrorFrameScrollBar_Update();
end


function BaudErrorFrame_Select(Index)
    SelectedError = Index;
    BaudErrorFrameScrollBar_Update();
    BaudErrorFrameDetailScrollFrameScrollBar:SetValue(0);
end


function BaudErrorFrame_OnShow(self)
    BaudErrorFrameMinimapCount:SetText("");
    BaudErrorFrame.lastCount = #ErrorList;
    PlaySound(SOUNDKIT and SOUNDKIT.GS_TITLE_OPTION_EXIT or "gsTitleOptionExit");
    self:ClearAllPoints()
    self:SetPoint("CENTER");
    BaudErrorFrameScrollBar_Update();
end


function BaudErrorFrame_OnHide()
    PlaySound(SOUNDKIT and SOUNDKIT.GS_TITLE_OPTION_EXIT or "gsTitleOptionExit");
end


function BaudErrorFrameEntry_OnClick(self)
    BaudErrorFrame_Select(self:GetID());
end


function BaudErrorFrameClearButton_OnClick(self)
    ErrorList = {};
    BaudErrorFrame.lastCount = 0;
    BaudErrorFrameMinimapCount:SetText("");
    --BaudErrorFrameMinimapButton:Hide();
    self:GetParent():Hide();
end


function BaudErrorFrameScrollBar_Update()
    if not BaudErrorFrame:IsShown()then
        return;
    end
    local Index, Button, ButtonText, Text;

    local Frame = BaudErrorFrameListScrollBox;
    local FrameName = Frame:GetName();
    local ScrollBar = getglobal(FrameName.."ScrollBar");
    local Highlight = getglobal(FrameName.."Highlight");
    local Total = #ErrorList;
    FauxScrollFrame_Update(ScrollBar,Total,Frame.Entries,16);
    Highlight:Hide();
    for Line = 1, Frame.Entries do
        Index = Line + FauxScrollFrame_GetOffset(ScrollBar);
        Button = getglobal(FrameName.."Entry"..Line);
        ButtonText = getglobal(FrameName.."Entry"..Line.."Text");
        if(Index <= Total)then
            Button:SetID(Index);
            ButtonText:SetText(ErrorList[Index].Error);
            Button:Show();
            if(Index==SelectedError)then
                Highlight:SetPoint("TOP",Button);
                Highlight:Show();
            end
        else
            Button:Hide();
        end
    end
    BaudErrorFrameEditBoxUpdate();
end

function BaudErrorFrameCreateLocalButton()
    local btn = WW:Button(nil,BaudErrorFrameEditBox):Size(36, 12):SetButtonFont(ChatFontSmall):SetAlpha(0.5)
    btn:GetFontString():SetJustifyH("RIGHT")
    btn:GetFontString():SetWidth(36)
    return btn;
end

function BaudErrorFrameEditBoxUpdateLocal(self)
    local message = ErrorList[SelectedError]
    if message then
        BaudErrorFrameEditBox.TextShown = message.locals[self.i] or ""
        BaudErrorFrameEditBox:SetText(BaudErrorFrameEditBox.TextShown);
    end
end

function BaudErrorFrameEditBoxUpdate()
    local message = ErrorList[SelectedError]
    if message then
        BaudErrorFrameEditBox.TextShown = message.Error.."\nCount: "..message.Count.."\n\nCall Stack:"..message.Stack;
        if(DEBUG_MODE and WW) then
            local btns = BaudErrorFrameEditBox.btns
            if not btns then
                btns = {}
                BaudErrorFrameEditBox.btns = btns;
                btns[1] = BaudErrorFrameCreateLocalButton():TL("$parent", "TR", 0, -(13*2)):SetText("|cff00ff00[00]|r"):SetScript("OnClick", BaudErrorFrameEditBoxUpdate):un()
                btns[1].i = 0
            end
            local num = 1
            for i=1,#message.locals do
                if(message.locals[i])then
                    num=num+1
                    btns[num] = btns[num] or BaudErrorFrameCreateLocalButton():TOP(btns[num-1],"B",0,-1):SetScript("OnClick", BaudErrorFrameEditBoxUpdateLocal):un();
                    btns[num]:SetText(format("|cff00ff00[%d]|r", i))
                    btns[num].i = i
                end
            end
        end
    else
        BaudErrorFrameEditBox.TextShown = "";
    end
    BaudErrorFrameEditBox:SetText(BaudErrorFrameEditBox.TextShown);
    --BaudErrorFrameDetailScrollFrame:UpdateScrollChildRect();
end


function BaudErrorFrameEditBox_OnTextChanged(self)
    if(self:GetText()~=self.TextShown)then
        self:SetText(self.TextShown);
        self:ClearFocus();
        return;
    end
    BaudErrorFrameDetailScrollFrame:UpdateScrollChildRect();
end


function BaudErrorFrameOptions_OnLoad(self)
    local Text = self:CreateFontString(nil, "BACKGROUND", "GameFontNormalSmall");
    Text:SetPoint("BOTTOMRIGHT",-13,13);
    Text:SetText("Version "..GetAddOnMetadata("!BaudErrorFrame","Version"));

    self.name = "错误提示配置";
    self.default = function()
        for Key, Value in ipairs(CheckButtons)do
            Config[Value.SavedVar] = Value.Default;
            Value.Button:SetChecked(Value.Default);
        end
        Config.Sound = DefaultSound;
        ClearFocus:SetFocus();
        SoundEditBox:SetText(Config.Sound);
        SoundEditBox:SetCursorPosition(0);
    end
    --self.refresh = BaudManifestOptions_OnShow;
    InterfaceOptions_AddCategory(self);

    SlashCmdList["BaudErrorFrame"] = function()
        InterfaceOptionsFrame_OpenToCategory("错误提示配置");
    end
    SLASH_BaudErrorFrame1 = "/bauderrorframe";
    SLASH_BaudErrorFrame2 = "/bauderror";

    SoundEditBox = BaudErrorFrameSoundEditBox;

    local Func = function(self)
        Config[self.SavedVar] = self:GetChecked()and true or false;
        if self:GetChecked()then
            PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or "igMainMenuOptionCheckBoxOn");
        else
            PlaySound(SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF or "igMainMenuOptionCheckBoxOff");
        end
        ClearFocus:SetFocus();
    end
    for Key, Value in ipairs(CheckButtons)do
        Button = CreateFrame("CheckButton", "BaudErrorFrameCheck"..Key, self, "OptionsCheckButtonTemplate");
        Value.Button = Button;
        Button.SavedVar = Value.SavedVar;
        getglobal(Button:GetName().."Text"):SetText(Value.Text);
        Button:SetPoint("TOPLEFT", 25, -25 * Key);
        Button:SetScript("OnClick", Func);
    end
end


function BaudErrorFrameTestSound()
    PlaySoundFile(Config.Sound);
    ClearFocus:SetFocus();
end
