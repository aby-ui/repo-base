U1RegisterAddon("EN_UnitFrames", {
    title = "系统头像增强",
    load = "LOGIN",
    secure = 1,
    optionsAfterVar = 1,
    defaultEnable = 1,
    --frames = {"EUF_FocusFrame"}, --EN_Focus自己记录了

    modifer = "魔盒 蘑菇",
    tags = { TAG_INTERFACE },
    icon = [[Interface\Icons\Achievement_Reputation_Ogre]],
    desc = "头像增强插件，可以给系统自带的玩家、目标、小队等头像框架增加额外的信息，例如职业图标、精英边框、生命法力文字、队友目标及施法条、队友的BUFF等。`此外还具有显示目标的目标的目标的框体的功能。",

    --toggle = function(name, info, enable, justload) end,
    ------- Options --------
    {
        var = "3d",
        default = false,
        text = "开启玩家和目标的3D头像",
        callback = function(cfg, v, loading)
            EUF_Options_Update("3DPORTRAIT", v and 1 or 0);
        end,
    },
    {
        var = "scale",
        default = 100,
        type = "spin",
        range = {80, 150, 10},
        text = "玩家和目标头像缩放",
        callback = function(cfg, v, loading)
            if loading and v==100 then return end
            CoreLeaveCombatCall(cfg._path, "头像缩放将在脱离战斗后修改。", function()
                PlayerFrame:SetScale(v/100)
                TargetFrame:SetScale(v/100)
            end)
        end,
    },
    {
        var = "color",
        default = 1,
        text = "血条颜色根据血量渐变",
        callback = function(cfg, v, loading)
            EUF_Options_Update("AUTOHEALTHCOLOR", v and 1 or 0);
        end,
    },
    {
        type = 'radio',
        var = 'numberformat',
        default = 1,
        cols = 3,
        options = {'万进位', 1, '千进位', 0, '暴雪式', 2},
        text = '血量格式',
        callback = function(_, v)
            if(EUF_CurrentOptions) then
                if v == 2 then
                    EUF_CurrentOptions['BLIZZ_NUMBERFORMAT'] = 1
                else
                    EUF_CurrentOptions['BLIZZ_NUMBERFORMAT'] = 0
                end
                EUF_CurrentOptions['NUMBERFORMAT'] = v
				EUF_Options_Update("NUMBERFORMAT", v);
            end
        end,
    },
    {
        type="text",text="玩家头像增强",
        {
            var = "showBlizPlayerHP",
            default = 1,
            text = "玩家血条显示暴雪默认数值",
            callback = function(cfg, v, loading)
                PlayerFrameHealthBarText:SetAlpha(v and 1 or 0)
                PlayerFrameHealthBarTextLeft:SetAlpha(v and 1 or 0)
                PlayerFrameHealthBarTextRight:SetAlpha(v and 1 or 0)
                PlayerFrameManaBarText:SetAlpha(v and 1 or 0)
                PlayerFrameManaBarTextLeft:SetAlpha(v and 1 or 0)
                PlayerFrameManaBarTextRight:SetAlpha(v and 1 or 0)
            end,
        },
        {
            var = "player",
            default = 1,
            text = "开启玩家头像扩展",
            callback = function(cfg, v, loading)
                EUF_Options_Update("PLAYERHPMP", v and 1 or 0);
                EUF_Options_Update("PLAYERPETHPMP", v and 1 or 0);
                U1CfgCallSub(cfg, "exp", v);
            end,
            {
                var = "exp",
                default = false,
                text = "显示经验条",
                callback = function(cfg, v, loading)
                    EUF_XPBarToggle(v)
                end,
            },
        },
        {
            var = "playerelite",
            default = 0,
            text = "玩家头像装饰",
            type = "radio",
            options = {"默认", 0, "精英", 1, "稀有", 2},
            cols = 3,
            callback = function(cfg, v, loading)
                MG_PlayerElite(v);
            end,
        },
    },
    {
        type="text", text="目标头像增强",
        {
            var = "target",
            default = 1,
            text = "开启目标头像扩展",
            callback = function(cfg, v, loading)
                EUF_Options_Update("TARGETHPMP", v and 1 or 0);
                EUF_Options_Update("TARGETCLASSICONSMALL", v and 1 or 0);
            end,
        },
        {
            var = "targethp",
            default = 1,
            text = "显示目标血量百分比",
            callback = function(cfg, v, loading)
                EUF_Options_Update("TARGETHPMPPERCENT", v and 1 or 0);
            end,
        },
        {
            var = "target_bliz",
            text = "目标血条显示暴雪默认数值",
            tip = "说明`很多人习惯目标血量始终显示为详细数值，这样可以调节玩家数值显示为百分比，所以增加此选项，取消勾选时，始终显示详细数值.",
            default = 0,
            callback = function(cfg, v, loading)
                EUF_Options_Update("TARGETHPMPBLIZ", v and 1 or 0);
                if not loading then EUF_TargetFrameDisplay_Update() end
            end,
            {
                text = "暴雪数值显示方式",
                callback = function()
                    CoreIOF_OTC(InterfaceOptionsDisplayPanel);
                    CoreUIShowCallOut(InterfaceOptionsDisplayPanel, InterfaceOptionsDisplayPanelDisplayDropDownLabel, InterfaceOptionsDisplayPanelDisplayDropDownButton, -10, 10, 10, -10)
                end,
            },
        },
        {
            text = "目标的目标",
            tip = "说明`因为暴雪的限制，如果通过插件设置是否显示目标的目标，可能会导致界面失效。`请设置游戏菜单的'界面-战斗-目标的目标'，下拉框选择'总是'",
            callback = function()
                CoreIOF_OTC(InterfaceOptionsCombatPanel);
                CoreUIShowCallOut(InterfaceOptionsCombatPanel, InterfaceOptionsCombatPanelTargetOfTarget, InterfaceOptionsCombatPanelTOTDropDown, -15, 10, 5, -10)
            end,
        },
        {
            var = "tot/totot",
            default = false,
            secure = 1,
            text = "显示目标的目标的目标",
            tip = "说明`因为暴雪的限制，如果通过插件设置是否显示目标的目标，可能会导致界面失效。`请设置游戏菜单的'界面-战斗-目标的目标'，下拉框选择'总是'",
            callback = function(cfg, v, loading)
                if InCombatLockdown() then return end
                EN_ToToT_Toggle(v);
            end,
        },

    },
    {
        type="text", text="小队头像增强",
        {
            var = "partybuff",
            default = 1,
            text = "显示队友BUFF/DEBUFF",
            callback = function(cfg, v, loading)
                partybufftoggle(v);
            end,
        },
        {
            var = "party",
            default = 1,
            text = "显示队友头像扩展",
            callback = function(cfg, v, loading)
                EUF_PartyInfoToggle(v);
                U1CfgCallSub(cfg, "partytarget", v);
            end,
            {
                var = "partytarget",
                default = true,
                secure = 1,
                text = "显示队友的目标",
                callback = function(cfg, v, loading)
                    if InCombatLockdown() then return end
                    PartyTarget_Toggle(v);
                end,
            },
        },
        {
            var = "partycast",
            default = 1,
            text = "显示队友施法条",
            callback = function(cfg, v, loading)
                PartyCast_Toggle(v)
            end,
        },
    },
    --[[
        {
            var = "focus",
            default = 1,
            secure = 1,
            text = "显示焦点头像扩展",
            tip = "说明`SHIFT+左鍵點擊目標頭像設置焦點`SHIFT+右鍵取消焦點",
            callback = function(cfg, v, loading)
                if InCombatLockdown() then return end
                SetCVar("fullSizeFocusFrame", v and "1" or "0");
                FocusFrame_SetSmallSize(v, true);
                if v then MGFocusFrameTitle:Show() else MGFocusFrameTitle:Hide(); end
            end,
        },
    ]]
});

function MG_PlayerElite(flag) --精英頭像
    if flag == 1 then
        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
        PlayerFrameTexture:SetDesaturated(nil)
    elseif flag == 2 then
        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame-Elite")
        PlayerFrameTexture:SetDesaturated(1)
    elseif flag == 0 then
        PlayerFrameTexture:SetTexture("Interface\\TargetingFrame\\UI-TargetingFrame")
    end
    --PlayerFrameTexture:Show()
end