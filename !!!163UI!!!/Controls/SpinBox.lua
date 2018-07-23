--[[------------------------------------------------------------
cfg参数：
- range = { min, max, [step(default:1)] }
- noedit = 1/true  不可输入
---------------------------------------------------------------]]
local __type = "spin"

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
    self.edit:SetTextColor(0.81, 0.65, 0.48);
    if not self._cfg.noedit then self.edit:Enable(); end
    self.prev:Enable();
    self.next:Enable();
end

function methods:CtlDisable()
    self._disabled = true;
    self.title:SetTextColor(0.5, 0.5, 0.5);
    self.edit:SetTextColor(0.5, 0.5, 0.5);
    self.edit:Disable();
    self.prev:Disable();
    self.next:Disable();
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
    assert(cfg.range and cfg.range[1] < cfg.range[2], "must have range (min < max)")
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);
    self:SetWidth(parent:GetWidth() - CtlGetLeftPadding(self))
    self.title:SetText(cfg.text);
    self.edit.tooltipTitle = cfg.noedit and "" or format(L["请输入 |cffffd200%s|r ~ |cffffd200%s|r 之间的数字"], cfg.range[1], cfg.range[2]);
    CoreUIShowOrHide(_G[self.edit:GetName().."Left"], not cfg.noedit)
    CoreUIShowOrHide(_G[self.edit:GetName().."Right"], not cfg.noedit)
    CoreUIShowOrHide(_G[self.edit:GetName().."Middle"], not cfg.noedit)
    CoreUIEnableOrDisable(self.edit, not cfg.noedit)
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
    local cfg = ctl._cfg
    local v = tonumber(ctl.edit:GetText())
    if not v or v>cfg.range[2] or v<cfg.range[1] then
        ctl:CtlLoadValue(U1LoadDBValue(cfg))
    else
        CtlRegularSaveValue(ctl, v)
    end
    ctl.edit:ClearFocus();
end

local function prevNext(self, button)
    local ctl = self:GetParent();
    local cfg = ctl._cfg;
    local v = tonumber(ctl.edit:GetText())
    if v then
        local step = cfg.range[3] or 1
        if button=="RightButton" then step = step*10 end
        --local f = self.factor < 0 and math.ceil or math.floor --0.999的问题
        --v = f((v - cfg.range[1])/step) * step + cfg.range[1]
        v = v + self.factor * step
        if v > cfg.range[2] then v = cfg.range[2] end
        if v < cfg.range[1] then v = cfg.range[1] end
        ctl.edit:SetText(v)
    end
    confirmValue(self)
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
    :SetScale(.95):TR(-62, -25):Size(83, 24)
    :SetAutoFocus(false)
    :SetMaxLetters(8)
    :SetJustifyH("CENTER")
    :un();

    ct.edit:SetScript("OnChar", editOnChar)
    ct.edit:SetScript("OnEnterPressed", confirmValue)

    CoreUIEnableTooltip(ct.edit);

    ct.edit:HookScript("OnEnter", childOnEnter)
    ct.edit:HookScript("OnLeave", childOnLeave)
    ct.edit:HookScript("OnEditFocusLost", onEditFocusLost);

    ct:Button(nil, nil, "prev"):Size(24,24):RIGHT(ct.edit, "LEFT", -5, 0)
    :RegisterForClicks("AnyUp"):SetScript("OnClick", prevNext)
    :SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
    :SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
    :SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
    :SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    :un()
    ct.prev:HookScript("OnEnter", childOnEnter)
    ct.prev:HookScript("OnLeave", childOnLeave)
    ct.prev.factor = -1

    ct:Button(nil, nil, "next"):Size(24,24):LEFT(ct.edit, "RIGHT", 1, 0)
    :RegisterForClicks("AnyUp"):SetScript("OnClick", prevNext)
    :SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
    :SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
    :SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
    :SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
    :un()
    ct.next:HookScript("OnEnter", childOnEnter)
    ct.next:HookScript("OnLeave", childOnLeave)
    ct.next.factor = 1

    ct.ok = TplPanelButton(ct):LEFT(ct.edit, "RIGHT", -4, 0)
    :SetScript("OnClick", confirmValue)
    :SetText(OKAY):AddFrameLevel(1, ct.next):Hide():un()

    CtlExtend(ct);
    CtlExtend(ct, methods);
    return ct:un();
end

CtlRegister(__type, creator)