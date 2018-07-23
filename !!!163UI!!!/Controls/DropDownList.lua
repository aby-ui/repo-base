--[[------------------------------------------------------------
cfg参数：
- options = { caption1, value1, caption2, value2, ... } or function
---------------------------------------------------------------]]
local UIDROPDOWNMENUTEMPLATE = "UIDropDownMenuTemplate"

local __type = "drop"

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
    local par = self:GetParent():GetParent()
    if not GameTooltip:IsVisible() then
        par:GetScript("OnEnter")(par);
    else
        titleOnEnter(par)
    end
end
local function childOnLeave(self)
    self:GetParent():GetParent():GetScript("OnLeave")(self:GetParent():GetParent());
end

local function dropDownButtonFunc(self, arg1, arg2)
    local menu = self.owner
    local value = self.value
    UIDropDownMenu_SetSelectedValue(menu, value);
    local cfg = menu:GetParent()._cfg
    CtlRegularSaveValue(menu:GetParent(), value)
end

local function dropDownInitialize(frame, level, menuList)
    local info = {};
    info.owner = frame;
    info.func = dropDownButtonFunc;
    info.isNotRadio = true;
    local cfg = frame:GetParent()._cfg
    local options
    if(type(cfg.options) == 'function') then
        options = cfg.options()
    else
        options = cfg.options
    end
    for i=1, #options, 2 do
        info.checked = nil;
        info.text = options[i]
        info.value = options[i+1]
        UIDropDownMenu_AddButton(info);
    end
end

function methods:CtlEnable()
    self._disabled = nil;
    self.title:SetTextColor(self.title:GetFontObject():GetTextColor());
    UIDropDownMenu_EnableDropDown(self.menu);
end

function methods:CtlDisable()
    self._disabled = true;
    self.title:SetTextColor(0.5, 0.5, 0.5);
    UIDropDownMenu_DisableDropDown(self.menu);
end

function methods:IsChildrenDisabled()
    return self._disabled;
end

function methods:CtlLoadValue(v)
    UIDropDownMenu_SetSelectedValue(self.menu, v);
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

    UIDropDownMenu_Initialize(self.menu, dropDownInitialize);
    --UIDropDownMenu_SetWidth(self.menu, parent:GetWidth() - CtlGetLeftPadding(self) - 56); --暂时不根据缩进设置宽度
    UIDropDownMenu_SetWidth(self.menu, 130);
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
    local btnName = U1_FRAME_NAME.."C_"..__type..idx
    ct:Frame(btnName, UIDROPDOWNMENUTEMPLATE, "menu"):SetScale(0.85):TR(-30, -27):un();
    _G[btnName.."Button"]:HookScript("OnEnter", childOnEnter)
    _G[btnName.."Button"]:HookScript("OnLeave", childOnLeave)
    --menu.displayMode = "MENU";
    CtlExtend(ct);
    CtlExtend(ct, methods);
    return ct:un();
end

CtlRegister(__type, creator)
