--[[------------------------------------------------------------
文本输入框
---------------------------------------------------------------]]
local __type = "input"

local L = select(2, ...).L

--[[------------------------------------------------------------
事件
---------------------------------------------------------------]]
local function titleOnEnter(self)
    if(not self._disabled)then
        local r,g,b = self.title:GetFontObject():GetTextColor();
        self.title:SetTextColor(1,1,1-b);
    end
end

local function titleOnLeave(self)
    if(not self._disabled)then
        self.title:SetTextColor(self.title:GetFontObject():GetTextColor())
    end
end

--[[------------------------------------------------------------
控件的自定义方法
---------------------------------------------------------------]]
local methods = {}

local function childOnEnter(self)
    local par = self:GetParent()
    if not GameTooltip:IsVisible() then
        par:GetScript("OnEnter")(par);
    else
        titleOnEnter(par)
    end
end
local function childOnLeave(self)
    self:GetParent():GetScript("OnLeave")(self:GetParent());
end

local function setAgain(self) self:GetRegions():SetText(self:GetText() or "") end
function methods:CtlLoadValue(v)
    self.edit:SetText(v or "")
    CoreScheduleTimer(false, .1, setAgain, self.edit) --TODO: 好恶心，不知为何第一次不显示
end


function methods:CtlEnable()
    self._disabled = nil;
    self.title:SetTextColor(self.title:GetFontObject():GetTextColor());
    self.edit:SetTextColor(0.81, 0.81, 0.48);
    self.edit:Enable();
end

function methods:CtlDisable()
    self._disabled = true;
    self.title:SetTextColor(0.5, 0.5, 0.5);
    self.edit:SetTextColor(0.5, 0.5, 0.5);
    self.edit:Disable();
    self.ok:Hide();
end

function methods:IsChildrenDisabled()
    return self._disabled;
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self.title, self._cfg.text, text)
    --TODO: 搜索选项
end

function methods:CtlPlace(parent, cfg, last)
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);
    self:SetWidth(parent:GetWidth() - CtlGetLeftPadding(self))
    self.title:SetText(cfg.text);
    self.edit.tooltipTitle = cfg.tip
    CoreUIShowOrHide(_G[self.edit:GetName().."Left"], true)
    CoreUIShowOrHide(_G[self.edit:GetName().."Right"], true)
    CoreUIShowOrHide(_G[self.edit:GetName().."Middle"], true)
    CoreUIEnableOrDisable(self.edit, true)
end

local function onEditFocusLost(self)
    local ctl = self:GetParent();
    local cfg = ctl._cfg
    ctl:CtlLoadValue(U1LoadDBValue(cfg))
    ctl.ok:Hide();
end

local function editOnChar(self) self:GetParent().ok:Show() end

local function confirmValue(self)
    local ctl = self:GetParent();
    ctl.ok:Hide();
    local v = ctl.edit:GetText()
    CtlRegularSaveValue(ctl, v)
    ctl.edit:ClearFocus();
end

--[[------------------------------------------------------------
生成初始化,注意,不能返回wrapper, 反正GetChildren那里都不会使用wrapper
---------------------------------------------------------------]]
local idx = 0
local creator = function()
    idx = idx + 1;
    local ct = WW:Frame():SetHeight(45);
    CoreUIEnableTooltip(ct);
    ct:HookScript("OnEnter", titleOnEnter);
    ct:HookScript("OnLeave", titleOnLeave);
    ct:CreateTexture():SetSize(7, 7):SetColorTexture(1,.82,0,0.3):TL(5,-5);
    ct.title = ct:CreateFontString():SetFontObject(CtlFontNormalSmall):TL(17, -3);

    ct:EditBox(U1_FRAME_NAME.."C_"..__type..idx, "InputBoxTemplate", "edit")
    :SetScale(.95):TR(-42, -25):Size(150, 24)
    :SetAutoFocus(false)
    :SetMaxLetters(100)
    :SetJustifyH("LEFT")
    :un();

    ct.edit:SetScript("OnChar", editOnChar)
    ct.edit:SetScript("OnEnterPressed", confirmValue)

    CoreUIEnableTooltip(ct.edit);

    ct.edit:HookScript("OnEnter", childOnEnter)
    ct.edit:HookScript("OnLeave", childOnLeave)
    ct.edit:HookScript("OnEditFocusLost", onEditFocusLost);

    ct.ok = TplPanelButton(ct):LEFT(ct.edit, "RIGHT", -4, 0)
    :SetScript("OnClick", confirmValue)
    :SetText(OKAY):AddFrameLevel(1, ct.next):Hide():un()

    CtlExtend(ct);
    CtlExtend(ct, methods);
    return ct:un();
end

CtlRegister(__type, creator)