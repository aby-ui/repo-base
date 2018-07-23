local type = "button"
--[[------------------------------------------------------------
控件的自定义方法
---------------------------------------------------------------]]
local methods = {}

function methods:CtlPlace(parent, cfg, last)
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);
    if(cfg.ldbIcon)then
        self.icon:Show();
        self.icon.tex:SetTexture(cfg.ldbIcon);
    else
        self.icon:Hide();
    end
    self:SetText(cfg.text);
    --WW(self):AutoWidth():un();
end

function methods:IsChildrenDisabled()
    return not self:IsEnabled();
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self:GetFontString(), self._cfg.text, text)
end

local function OnClick(self)
    CtlRegularSaveValue(self, value);
end

--[[------------------------------------------------------------
生成初始化,注意,不能返回wrapper, 反正GetChildren那里都不会使用wrapper
---------------------------------------------------------------]]
local creator = function()
    
    local btn = TplPanelButton():Set3Fonts("CfgButtonFont");
    btn:SetWidth(150);
    btn.icon = btn:Button():LEFT(btn, "RIGHT", 3, -1):SetSize(btn:GetHeight()-2)
    :CreateTexture():Key("tex"):ALL():up();

    CtlExtend(btn);
    CtlExtend(btn, methods);

    btn:SetScript("OnClick", OnClick);
    return btn:un();
end

CtlRegister(type, creator)