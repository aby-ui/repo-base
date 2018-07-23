local type = "subgroup"
--[[------------------------------------------------------------
插件的自定义方法
---------------------------------------------------------------]]
local methods = {}
function methods:CtlPlace(parent, addonName, last)
    self:SetSize(parent:GetWidth()-CTL_SUBGROUP_PADDING*2,1)
    --TODO: LDB按钮
    local info = U1GetAddonInfo(addonName);
    if(info.ldbIcon)then
        self.check.icon:Show();
        self.check:SetIcon(info.ldbIcon);
    else
        self.check.icon:Hide();
    end
    self.check:SetIcon(info.ldbIcon);
    CtlRegularAnchor(self, parent, addonName, last);
    self.check:SetText(U1GetAddonTitle(addonName), 2); --在search的时候会设置
    self.check:SetChecked(U1IsAddonEnabled(addonName));
    self:CtlSetEnabled(U1IsAddonEnabled(info.parent) and info.installed and not U1IsAddonCombatLockdown(addonName));
    if(info.protected) then
        TplCheckButtonForceChecked(self.check, 1);
    end
    CoreUIShowOrHide(self.border, #info>1 and info.parent and U1GetAddonInfo(info.parent).dummy) --如果父插件是dummy而且有两行以上的配置则显示
end

function methods:CtlDisable()
    self.check:EnableOrDisable(nil);
end

function methods:CtlEnable()
    self.check:EnableOrDisable(1);
end

function methods:CtlOnSearch(text)
    CtlUpdateSearchText(self, self.check.text, U1GetAddonTitle(self._cfg), text)
    CtlSearchPage(self, text)
end

function methods:CtlAfterPlaced()
    local _,_,_,h = self:GetBoundsRect()
    --TODO: 临时解决的方案
    if(h<2) then
        RunOnNextFrame(self.CtlAfterPlaced, self);
    else
        local lastChild = select(select("#", self:GetChildren()), self:GetChildren());
        if(lastChild._type=="button" or lastChild._type=="subgroup") then
            self:SetHeight(h);
        else
            self:SetHeight(h-6);
        end
    end
end

--[[------------------------------------------------------------
生成初始化
---------------------------------------------------------------]]
function CtlSubGroupCheckOnClick(self)
    local scroll = _G[U1_FRAME_NAME].right.scroll;
    local group = self:GetParent()
    CoreUIScrollSavePos(scroll);
    UUI.ClickAddonCheckBox(self, group._cfg, self:GetChecked(), 1)
    CtlShowPage(group._cfg, group, group.check);
    UUI.Center.Refresh();
end

local creator = function()
    local group = WW:Frame()
    --group:Backdrop([[Interface\QUESTFRAME\UI-TextBackground-BackdropBackground]],[[Interface\AddOns\!!!163UI!!!\Textures\SubGroupBorder]],8,8);
    CtlExtend(group);
    CtlExtend(group, methods);
    local check = CoreUICreateCheckButtonWithIcon(group, nil, 18, 16):Key("check"):Set3Fonts(UUI.FONT_PANEL_BUTTON):TOPLEFT(0, 0):un();
    check:SetScript("OnClick", CtlSubGroupCheckOnClick);
    CoreUIEnableTooltip(check, nil, function(self, tip)
        UUI.SetAddonTooltip(self:GetParent()._cfg, tip);
    end)
    group.border = group:Frame():TL(-1, 2-18-CTL_LINESPACE+2):BR(4,-2-CTL_LINESPACE+4):Backdrop(nil,UUI.Tex'TuiBlank',1):SetBackdropBorderColor(.3,.3,.3):un()
    return group:un();
end

CtlRegister(type, creator)
