--[[------------------------------------------------------------
cfg参数：
- options = { caption1, value1, caption2, value2, ... } or function
- cols = 2(default),
---------------------------------------------------------------]]
-- local __type = "radio"
-- local __type = "checklist"

--[[
--   helper utils
--]]

-- upgrade old db format
local function upgrade_checklist(v)
    if(type(v) == 'string') then
        local cfg = {}
        for _, val in next, string.split(',', v) do
            cfg[val] = true
        end
        return cfg
    end
end

-- load value from func
local function load_value(inp)
    if(type(inp) == 'function') then
        return inp()
    else
        return inp
    end
end

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

local function buttonOnClick(self)
    self:GetParent():SelectValue(self.value);
end

local function buttonOnEnter(self)
    local par = self:GetParent()
    if not GameTooltip:IsVisible() then
        par:GetScript("OnEnter")(par);
    else
        titleOnEnter(par)
    end
end

local function buttonOnLeave(self)
    self:GetParent():GetScript("OnLeave")(self:GetParent());
end

local OPTION_LINE_SPACE = CTL_LINESPACE-3
function methods:CtlPlace(parent, cfg, last)
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);
    self:SetWidth(parent:GetWidth() - CtlGetLeftPadding(self))
    cfg.cols = cfg.cols or 2;
    self.title:SetText(cfg.text);

    local options = load_value(cfg.options)

    local rw = (self:GetWidth() - CTL_INDENT - (cfg.indent and 16+10 or 0))/ cfg.cols --缩进的时候再短一点更好看
    local buttons = self.__checkbuttons;
    local _type = self.__type
    local lines = 1;
    for i=1, #options/2 do
        if not buttons[i] then
            local btn

            if(_type == 'radio') then
                btn = TplRadioButton(self):Size(16,16)
            elseif(_type == 'checklist') then
                btn = TplCheckButton(self):Size(16, 16)
            else
                error('unsupported type: ' .. _type)
            end

            btn:SetScript("OnClick", buttonOnClick)
            btn:HookScript("OnEnter", buttonOnEnter)
            btn:HookScript("OnLeave", buttonOnLeave)
            btn.text:SetFontObject'CtlOptionFontNormalSmall'
            buttons[i] = btn
        end
        buttons[i]:Show();
        buttons[i].text:SetSize(rw-buttons[i]:GetWidth(),1);

        buttons[i]:ClearAllPoints();
        if i==1 then
            buttons[i]:SetPoint("TOPLEFT", self.title, "BOTTOMLEFT", cfg.indent and 0 or -16, -6);
        else
            if cfg.cols == 1 or i % cfg.cols == 1 then
                lines = lines + 1;
                buttons[i]:SetPoint("TOPLEFT", buttons[i-cfg.cols], "BOTTOMLEFT", 0, -OPTION_LINE_SPACE);
            else
                buttons[i]:SetPoint("LEFT", buttons[i-1], "LEFT", rw, 0);
            end
        end
        buttons[i].text:SetText(options[i*2-1]);
        buttons[i].value = options[i*2];
        buttons[i].option = options[i*2-1];
    end
    for i=#options/2+1, #buttons do buttons[i]:Hide(); end
    local height = lines * ((buttons[1] and buttons[1]:GetHeight() or 0) + OPTION_LINE_SPACE) + self.title:GetStringHeight();
    self:SetHeight(height + 6);
    --self:SetHitRectInsets(0,0,0,height-self.title:GetStringHeight());
end

function methods:UpdateSelected()
    local _type = self.__type
    for _, v in ipairs(self.__checkbuttons) do
        if(v:IsShown()) then
            if(_type == 'radio' and v.value == self.selectedValue) or
                (_type == 'checklist' and type(self.selectedValue) == 'table' and self.selectedValue[v.value]) then
                v.text:SetText(v:IsEnabled() and format("|cfffff5a0%s|r", v.option) or v.option);
                v:SetChecked(true)
            else
                v.text:SetText(v.option);
                v:SetChecked(nil);
            end
        end
    end
end

function methods:CtlEnable()
    self._disabled = nil;
    self.title:SetTextColor(self.title:GetFontObject():GetTextColor());
    for _, v in ipairs(self.__checkbuttons) do v:Enable() end
    self:UpdateSelected();
end

function methods:CtlDisable()
    self._disabled = true;
    self.title:SetTextColor(0.5, 0.5, 0.5);
    for _, v in ipairs(self.__checkbuttons) do v:Disable() end
    self:UpdateSelected();
end

function methods:IsChildrenDisabled()
    return self._disabled;
end

function methods:CtlLoadValue(v)
    -- upgrade to table
    if(self.__type == 'checklist' and type(v) == 'string') then
        v = upgrade_checklist(v)
    end
    self.selectedValue = v
    self:UpdateSelected()
end

function methods:SelectValue(v)
    if(self.__type == 'checklist') then
        self.selectedValue = self.selectedValue or {}
        wipe(self.selectedValue)

        for _, btn in next, self.__checkbuttons do
            if(btn:IsShown()) then
                if(btn:GetChecked()) then
                    self.selectedValue[btn.value] = true
                else
                    self.selectedValue[btn.value] = false
                end
            end
        end

    elseif(self.__type == 'radio') then
        self.selectedValue = v
    end

    self:UpdateSelected()
    CtlRegularSaveValue(self, self.selectedValue);
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self.title, self._cfg.text, text)
    --TODO:搜索选项
end

--[[------------------------------------------------------------
生成初始化,注意,不能返回wrapper, 反正GetChildren那里都不会使用wrapper
---------------------------------------------------------------]]
local creator = function(__type)
    local ct = WW:Frame();
    CoreUIEnableTooltip(ct);
    ct:HookScript("OnEnter", titleOnEnter);
    ct:HookScript("OnLeave", titleOnLeave);
    ct:CreateTexture():SetSize(7, 7):SetColorTexture(1,.82,0,0.3):TL(5,-5);
    ct.title = ct:CreateFontString():SetFontObject(CtlFontNormalSmall):TL(17, -3);
    --ct:CreateTexture():SetColorTexture(1,1,1,0.5):SetAllPoints();

    ct.__type = __type
    ct.__checkbuttons = {};
    CtlExtend(ct);
    CtlExtend(ct, methods);
    return ct:un();
end

for _, t in next, { 'radio', 'checklist' } do
    CtlRegister(t, function() return creator(t) end)
end

