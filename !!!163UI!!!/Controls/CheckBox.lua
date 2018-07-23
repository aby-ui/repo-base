local type = "checkbox"
--[[------------------------------------------------------------
控件的自定义方法
---------------------------------------------------------------]]
local methods = {}
function methods:CtlDisable()
    --SetEnabled是CheckButtonWithIcon的方法
    self:EnableOrDisable(nil);
end

function methods:CtlEnable()
    self:EnableOrDisable(1);
end

local function deepChange(control, checked)
    if(#control._cfg > 0) then
        for _,cfg in ipairs(control._cfg) do
            cfg._ctl:CtlSetEnabled(checked);
            if #cfg > 0 then
                deepChange(cfg._ctl, checked and not cfg._ctl:IsChildrenDisabled());
            end
        end
    end
end

function methods:CtlPlace(parent, cfg, last)
    --LoadValue必须在子控件都布置好了再设，所以放在外面
    CtlRegularAnchor(self, parent, cfg, last);
    CtlRegularTip(self, cfg);

    self:SetIcon(cfg.ldbIcon);
    --必须在SetIcon之后调用
    self:SetText(cfg.text, CtlGetLeftPadding(self)); --计算控件的左侧位置, 用于缩减宽度
end

--在显示的时候被框架调用,deepChange会通过IsChildrenDisabled()在外部调用.
--插件只需要处理点击触发的deepChange即可
function methods:CtlLoadValue(v)
    self:SetChecked(v)
end

--在自定义的时刻触发，会调用配置function
function methods:CtlSaveValue()
    CtlRegularSaveValue(self, self:GetChecked());
end

--初始show的时候创建子控件用的，必须用Is，Get开头才能不被wrapper替换
function methods:IsChildrenDisabled()
    return not (self:IsEnabled() and self:GetChecked());
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self.text, self._cfg.text, text)
end

local function OnClick(self)
    local checked = self:GetChecked();
    self:CtlSaveValue();
    deepChange(self, checked);
    --self._cfg.callback(checked); --saveValue的时候调用了
end

--[[------------------------------------------------------------
生成初始化,注意,不能返回wrapper, 反正GetChildren那里都不会使用wrapper
---------------------------------------------------------------]]
local creator = function()
    local control = CoreUICreateCheckButtonWithIcon(nil, nil, 18, 16):Set3Fonts("CtlFontSmall");
    --control:GetCheckedTexture():SetVertexColor(.8,.6,1)
    CtlExtend(control);
    CtlExtend(control, methods);

    control:SetScript("OnClick", OnClick);

    return control:un();
end

CtlRegister(type, creator)