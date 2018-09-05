--[[----------------------------------------------------------------------
_开头的属性表示系统自动冗余添加的
控件具有属性
_cfg  注意subgroup的_cfg是addonName字符串
_type

配置项具有属性
_ctl
_path
_depth
_parent
注意配置项的type没有下划线

只有checkbox才有children

必须实现的：CtlLoadValue，另外要在合适的位置自己调用CtlRegularSaveValue(self, value);
Custom需要实现IsChildrenDisabled和CtlSetEnabled
-------------------------------------------------------------------------]]

local _, U1 = ...
local L = U1.L

CTL_INDENT = 16;
CTL_LINESPACE = 10;
CTL_INIT_OFFSETX = 8;
CTL_INIT_OFFSETY = 5;
CTL_SUBGROUP_PADDING = 8

--- title font
WW:Font("CtlFontNormalSmall", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 13 or 11):SetTextColor(0.81, 0.65, 0.48):SetShadowOffset(1,-1):un();
--- options font
WW:Font("CtlOptionFontNormalSmall", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 12 or 10):SetTextColor(0.40, 0.33, 0.24):un();
--- check box font
WW:Font3("CtlFontSmall", U1.CN and ChatFontNormal or GameFontNormal, U1.CN and 13 or 11, {{0.81, 0.65, 0.48},{1, .96, .63},{.5,.5,.5}}, nil, 1, -1);
--- button font
WW:Font3("CfgButtonFont", U1.CN and ChatFontNormal or GameFontNormal, 12, {{0.81, 0.65, 0.48},{1, .96, .63},{.5,.5,.5}}, nil, 1, -1);


--[[------------------------------------------------------------
控件的默认方法
---------------------------------------------------------------]]
local base = {}
function base:CtlSetEnabled(enabled)
    if(enabled) then self:CtlEnable(); else self:CtlDisable(); end
end
function base:CtlDisable()
    self:Disable();
end
function base:CtlEnable()
    self:Enable();
end
function base:CtlPlace(parent, cfg, last)
    assert("please implement");
end
function base:IsChildrenDisabled()
    return nil;
end

--[[------------------------------------------------------------
生成控件的工具方法
---------------------------------------------------------------]]
---将控件的默认事件复制到对象上，如果不提供methods则使用base, 一般需要调用两次
function CtlExtend(control, methods)
    for k,v in pairs(methods or base) do
        control[k] = v;
    end
end

--[[------------------------------------------------------------
控件注册和管理
---------------------------------------------------------------]]
local types = {}
local pool = {}
function CtlRegister(type, creator)
    types[type] = creator;
    pool[type] = pool[type] or {};
end

function CtlRelease(control)
    control:SetParent(nil);
    control:ClearAllPoints();
    control:Hide();
    if control._type ~= "custom" then
        table.insert(pool[control._type], control);
    end
end

function CtlObtain(type)
    assert(types[type], "error: control type "..tostring(type).." is not registered.");
    local control = table.remove(pool[type]) or types[type]();
    control._type = type;
    return control;
end


--[[------------------------------------------------------------
显示页面
---------------------------------------------------------------]]
--每个CtlPlaced都要调用的函数, 根据上一个的位置计算, 同时清理值
function CtlRegularAnchor(control, parent, cfg, last)
    control._cfg = cfg;
    if(type(cfg)=="table") then cfg._ctl = control; end

    control:Show();
    control:ClearAllPoints();

    if(last)then
        --注意subgroup的last肯定不会是subgroup里的check
        if(control._type=="subgroup")then
            --subgroup的cfg是addonName, 其左侧是固定的.
            control:SetPoint("TOP",WW:un(last),"BOTTOM", 0, -CTL_LINESPACE-5);
            control:SetPoint("LEFT", parent, CTL_SUBGROUP_PADDING, 0);
        else
            --没有last._cfg的时候, 说明last是内部Group的checkbutton.
            local offsetx = last._cfg and (control._cfg._depth - last._cfg._depth)*CTL_INDENT or 1*CTL_INDENT
            local offsety = last._cfg and (-CTL_LINESPACE) or -CTL_LINESPACE
            if not last._cfg and last:GetParent().border:IsShown() then offsetx = 2 end --如果父插件是dummy则无缩进
            control:SetPoint("TOPLEFT",WW:un(last),"BOTTOMLEFT", offsetx, offsety);
        end
    else
        if(control._type=="subgroup")then
            control:SetPoint("TOPLEFT",parent,"TOPLEFT", CTL_SUBGROUP_PADDING, -CTL_INIT_OFFSETY);
        else
            control:SetPoint("TOPLEFT",parent,"TOPLEFT", CTL_INIT_OFFSETX, -CTL_INIT_OFFSETY);
        end
    end
end

--OnEnter事件里有CoreUIShowTooltip即可用这个
function CtlRegularTip(self, cfg)
    if not cfg.tipLines and cfg.tip then
        cfg.tipLines = {strsplit("`", cfg.tip)};
        cfg.tip = nil
	end
    if cfg.reload and not cfg._reloadTipAdded then
        if not cfg.tipLines then cfg.tipLines = { L["注意"] } else tinsert(cfg.tipLines, " ") end
        tinsert(cfg.tipLines, L["|cffff0000需要重新加载界面|r"]);
        cfg._reloadTipAdded = true
    end
    self.tooltipLines = cfg.tipLines
end

function CtlGetLeftPadding(control)
    if(control:GetParent()._type == "subgroup") then
        return (control._cfg._depth) * CTL_INDENT + CTL_SUBGROUP_PADDING
    else
        return (control._cfg._depth) * CTL_INDENT + CTL_INIT_OFFSETX
    end
end

---布置一个自定义的组件，注意该组件是一个容器，其高度由自己设置，而宽度是左右拉伸至最合适
function CtlCustomPlace(control, parent, cfg, last)
    --必须先CtlRegularAnchor然后再CtlGetLeftPadding
    control:SetParent(parent)
    CtlRegularAnchor(control, parent, cfg, last);
    control:SetSize(parent:GetWidth()-CtlGetLeftPadding(control)*2, control:GetHeight());
end

local last;
local function deepShow(addon, cfg, parent, disabled)
    local ctl
    if cfg.type == "custom" then
        ctl = cfg.place(parent, cfg, last);
        if not ctl then return end
        ctl._type = "custom"
    else
        ctl = CtlObtain(cfg.type);
        ctl:SetParent(WW:un(parent));
        ctl:CtlPlace(parent, cfg, last);
    end
    -- 获取其他插件的保存值, 当在其他插件的界面中修改后能够反应到这里
    -- 支持没有var的配置提供getvalue, 但此时default无意义
    if(cfg.getvalue and IsAddOnLoaded(addon)) then
        local success, value = pcall(cfg.getvalue);
        if success then
            if cfg.var then
                U1SaveDBValue(cfg, value);
            else
				--[[if not ctl:CtlLoadValue(value) then
					print("ctl:CtlLoadValue(value) error ")
				end]]
                ctl:CtlLoadValue(value)
            end
        end
    end
    --print("deepShow", cfg.getvalue(), U1LoadDBValue(cfg))
    if(cfg.var) then
        ctl:CtlLoadValue(U1LoadDBValue(cfg))
    end

    if(cfg.disabled or (cfg.secure and InCombatLockdown())) then
        ctl:CtlSetEnabled(nil)
    else
        ctl:CtlSetEnabled(cfg.always or not disabled) --必须在place之后,因为会还原默认状态
    end
    last = ctl;
    if #cfg > 0 then
        for _, v in ipairs(cfg) do
            deepShow(addon, v, parent, ctl:IsChildrenDisabled());
        end
    end
end

function CtlShowPage(addon, parent, anchor)
    --[[如果连续两次显示会出bug,只能出此下策，现在用Bucket了
    if addon == parent._lastPage and GetTime() - (parent._lastTime or 0) < 0.1 and IsAddOnLoaded(addon) == parent._lastStat then return end
    parent._lastPage = addon;
    parent._lastStat = IsAddOnLoaded(addon);
    parent._lastTime = GetTime();
    --]]

    CtlWipeCurrentPage(parent); --子界面此时才清理
    local page = U1GetPage(addon);
    last = anchor;
    local info = U1GetAddonInfo(addon);
    local p = info.parent;
    --如果有配置页面则生成配置项
    if page then
        for _, cfg in ipairs(page) do
            --不能用IsAddOnLoaded，因为没load也可以设置选项
            local disabled = not U1IsAddonEnabled(addon) or (IsAddOnLoaded(addon) and cfg.disableOnLoad) or (not IsAddOnLoaded(addon) and not cfg.enableOnNotLoad) or (p and not U1IsAddonEnabled(p)) or (anchor and not anchor:GetChecked())
            if cfg.alwaysEnable then disabled = false end
			if (cfg.visible == nil or cfg.visible) then
				deepShow(addon, cfg, parent, disabled); --如果子插件都不能点了(父插件关闭), 自然不显示
			end
        end
    end

    --查找子插件,显示配置页

    --增加按注册顺序排序
    if not info.subAddons then
        info.subAddons = {};
        for k, v in U1IterateAllAddons() do
            if(v.parent == addon and not v.hide) then
                table.insert(info.subAddons, k);
            end
        end
        table.sort(info.subAddons, function(v1, v2) v1=U1GetAddonInfo(v1).order or 0 v2=U1GetAddonInfo(v2).order or 0 return v1<v2 end)
    end

    for _, k in ipairs(info.subAddons) do
        local group = CtlObtain("subgroup");
        group:SetParent(parent);
        group:CtlPlace(parent, k, last);
        --group的enable和disable在CtlPlace里处理
        CtlShowPage(k, group, group.check);
        --TODO: 临时解决的方案，而且这里超过两层时有问题
        RunOnNextFrame(group.CtlAfterPlaced, group)
        last = group;
    end

    --在底部显示一部分空白
    if(not anchor and last)then
        parent.spacer = parent.spacer or CreateFrame("Frame", nil, parent);
        parent.spacer:Show();
        parent.spacer:SetSize(1,1);
        parent.spacer:SetPoint("TOP", WW:un(last), "BOTTOM", 0, -CTL_LINESPACE);
    else
        if parent.spacer then parent.spacer:Hide(); end
    end

    -- 如果下面有空白则显示介绍
    local right = UUI().right
    if parent == right.pageCfg then
        if parent:GetTop() - last:GetTop() < 150 then
            local html = right.html
            UUI.Right.SetHTML(right, addon)
            html:SetParent(right.pageCfg)
            html:ClearAllPoints();
            html:SetPoint("TOP", WW:un(last), "BOTTOM", 0, -CTL_LINESPACE*2);
            html:SetPoint("LEFT", parent, CTL_SUBGROUP_PADDING, 0);
        end
    end

    --强制重新计算滚动条
    --[[ --因为外面有SetScrollChild，之后会计算
    if parent:GetParent():GetObjectType()=="ScrollFrame" then
        parent:GetParent():GetScript("OnScrollRangeChanged")(parent:GetParent(), 0, max(0, select(4, parent:GetBoundsRect()) - parent:GetParent():GetHeight()));
    end]]
end

--[[------------------------------------------------------------
清理界面, 只隐藏第一层, 子界面会在ShowPage之前清理
---------------------------------------------------------------]]
function CtlWipeCurrentPage(parent)
    local skipped = 0
    while(true)do
        local child = select(skipped+1, parent:GetChildren());
        if(not child) then break;end
        if(child._type)then
            CtlRelease(child);
        else
            skipped = skipped + 1;
        end
    end
end

StaticPopupDialogs["163UIUI_CONFIRM"] = {preferredIndex = 3,
    text = "%1$s",
    button1 = TEXT(YES),
    button2 = TEXT(CANCEL),
    OnAccept = function(self, data)
        CtlRegularSaveValue(data[1], data[2], data[3], 1);
    end,
    OnCancel = function(self, data)
        local cfg = data[3] or data[1]._cfg
        if cfg.type == "checkbox" then
            --需要刷新disable状态
            UUI.Right.ShowPageBucket(UUI().right.addonName)
        elseif cfg.type ~= "button" and cfg.var ~= 1 then --cfg.var==1是外部调用CtlRegularSave的设置
            data[1]:CtlLoadValue(U1LoadDBValue(cfg))
        end
    end,
    --OnHide = ConfirmOnCancel, --OnCancel完了会执行OnHide
    hideOnEscape = 1,
    timeout = 0,
    exclusive = 1,
    whileDead = 1,
}

--[[------------------------------------------------------------
操作相关
---------------------------------------------------------------]]
---向DB中保存Configs信息
--@param providedCfg 是直接提供的cfg对象，供dropdown使用
function CtlRegularSaveValue(control, value, providedCfg, onAccept)
    local cfg = providedCfg or control._cfg
    if cfg.confirm and not onAccept then
        StaticPopup_Show("163UIUI_CONFIRM", cfg.confirm, nil, {control, value, providedCfg})
        return;
    end
    if(cfg.var) then
        --处理config的reload情况
        local old = U1SaveDBValue(cfg, value)
        if cfg.reload then
            local encode = U1EncodeNIL(value)
            if old~=encode then
                U1ChangeReloadList(cfg._path, true, old, encode)
                UUI.ReloadFlash(control, value)
            end
        end
    end
    if(cfg.callback) then
        if not providedCfg then --BAD hack
            local needLower = cfg.lower;
            if needLower == nil then needLower = (cfg.type == "button") end
            if needLower then UUI.Raise(false); end
        end
        U1CfgCallBack(cfg, value, false);
    end
end

--工具方法, 更新搜索文本
function CtlUpdateSearchText(control, fontstring, old, text)
    if(text=="")then
        fontstring:SetText(old);
    else
        local pattern = nocase(text);
        if(old:find(pattern)) then
            fontstring:SetText(old:gsub(pattern, "|cff00ff00%0|r"));
        else
            if control._type=="subgroup" then
                --如果是子插件，则拼音或英文命中时也高亮
                local info = U1GetAddonInfo(control._cfg)
                local searched = control._cfg:find(pattern) or (info.title and U1SearchPinyin(info.title, pattern))
                if searched then
                    fontstring:SetText("|cff00ff00"..old.."|r")
                else
                    fontstring:SetText(old)
                end
            else
                fontstring:SetText(old);
            end
        end
    end
end

function CtlSearchPage(page, text)
    local num = select("#", page:GetChildren());
    for i=1, num do
        local child = select(i, page:GetChildren());
        if(child.CtlOnSearch) then
            child:CtlOnSearch(text);
        end
    end
end
