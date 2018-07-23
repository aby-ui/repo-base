local type = "text"
--[[------------------------------------------------------------
控件的自定义方法
---------------------------------------------------------------]]
local methods = {}

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

function methods:CtlEnable()
    self._disabled = nil;
    self.title:SetTextColor(self.title:GetFontObject():GetTextColor());
end

function methods:CtlDisable()
    self._disabled = true;
    self.title:SetTextColor(0.5, 0.5, 0.5);
end

function methods:IsChildrenDisabled()
    return self._disabled;
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self.title, self._cfg.text, text)
end

function methods:CtlPlace(parent, cfg, last)
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);
    self.title:SetText(cfg.text, CtlGetLeftPadding(self) -10);
    self:SetWidth(parent:GetWidth() - CtlGetLeftPadding(self) - 10)
    self:SetHeight(16);
end

--[[------------------------------------------------------------
生成初始化,注意,不能返回wrapper, 反正GetChildren那里都不会使用wrapper
---------------------------------------------------------------]]
local creator = function()
    local ct = WW:Frame();
    CoreUIEnableTooltip(ct);
    ct:HookScript("OnEnter", titleOnEnter);
    ct:HookScript("OnLeave", titleOnLeave);
    local r,g,b,factor,start,stop=1,1,0,0.5,0.8,0.1
    ct.sep = ct:CreateTexture():SetSize(100, 1):SetColorTexture(1,0.82,0,1):SetGradientAlpha("HORIZONTAL",r,g,b,start,r*factor,g*factor,b*factor,stop):TL(2, 0):TR(1, 0);
    ct.title = ct:CreateFontString():SetFontObject(CtlFontNormalSmall):TL(2, -4);
    CtlExtend(ct);
    CtlExtend(ct, methods);
    return ct:un();
end

CtlRegister(type, creator)