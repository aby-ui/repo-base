local setProfanityFilter, hideNameplateDebuff

local L = U1.L

local function untex(text)
    return text and text:gsub("\124T.*\124t", "")
end

U1RegisterAddon("163UI_MoreOptions", {
    title = "额外设置",
    tags = { TAG_MANAGEMENT },
    icon = [[Interface\Icons\Achievement_BG_overcome500disadvantage]],
    desc = "额外设置",
    nopic = 1,
    protected = 1,
    author = "|cffcd1a1c[爱不易原创]|r",
    defaultEnable = 1,

    U1CfgMakeCVarOption(U1_NEW_ICON.."简易原汁原味", "overrideArchive", nil, {
        tip = "说明`通过设置变量达到简易反和谐的目的，没有任何风险。可以和谐大部分模型，比如坟包会替换成白骨，技能图标似乎不会变化。``\n如果开启后卡蓝条或无法进入游戏，请删除WTF\\Config.wtf``|cffff0000设置后必须重启游戏才能生效。|r",
        confirm = "注意：如果开启后|cffff7777无法进入游戏|r，请删除WTF\\Config.wtf文件即可恢复（或只移除其中的overrideArchive条目）\n\n请确认，然后关闭游戏重新进入。",
        getvalue = function() return not GetCVarBool("overrideArchive") end,
        callback = function(cfg, v, loading) SetCVar("overrideArchive", v and "0" or "1") end,
    }),

    --[[{
        text = U1_NEW_ICON.."上线后立即释放尸体",
        var = "death_release",
        tip = "说明`8.0以后BOSS战掉线再上线时会连续掉线，开启此选项后可以改善。",
        default = false,
    },--]]

    --[[
    U1CfgMakeCVarOption(U1_NEW_ICON.."使用老版本TAB键选取方式", "targetnearestuseold", {
        tip = "说明`7.0之后TAB键可以选取到身后的怪物，容易ADD，启用此选项可以恢复之前的方式",
        reload = 1,
    }),--]]

    U1CfgMakeCVarOption("姓名板的最大显示距离", "nameplateMaxDistance", 60, {
        tip = "说明`8.2后已被固定为60码，无法修改",
        disableOnLoad = true,
        type = "spin",
        range = {59, 60, 5},
    }),

    U1CfgMakeCVarOption("显示目标施法条", "showTargetCastbar", 1, {
        tip = "说明`是否在目标头像下方显示施法条`7.0以后暴雪将此选项精简掉了",
        reload = 1,
    }),

    U1CfgMakeCVarOption("显示目标仇恨值", "threatShowNumeric", 1, {
        tip = "说明`在目标头像上方显示当前仇恨百分比",
    }),

    U1CfgMakeCVarOption("自动追踪任务", "autoQuestWatch", 1, {
        tip = "说明`接受任务后自动添加到追踪列表里`7.0以后暴雪将此选项精简掉了",
        reload = 1,
    }),

    U1CfgMakeCVarOption("连击点界面位置", "comboPointLocation", nil, {
        type = "radio",
        options = { "玩家头像下", "2", "经典:目标头像", "1", },
        reload = 1,
    }),

    {
        var = "checkAddonVersion",
        text = L["允许加载过期插件"],
        tip = L["说明`和人物选择功能插件界面上的选项一致"],
        default = "0",
        getvalue = function() return GetCVar("checkAddonVersion")=="0" end,
        callback = function(cfg, v, loading)
            SetCVar("checkAddonVersion", v and "0" or "1")
        end,
    },

    {
        var = 'profanityFilter',
        text = '强制关闭语言过滤器',
        tip = '说明`国服强制开启语言过滤器，但是可以通过一些手段关闭。不过关闭后会影响暴雪自带的支持功能，需要时可以恢复此选项。',
        default = true,
        --getvalue = function() return GetCVar'profanityFilter' == '1' end,
        callback = function(cfg, v, loading)
            return setProfanityFilter(loading)
        end
    },

    U1CfgMakeCVarOption("按下按键时开始动作", "ActionButtonUseKeyDown", nil),
    {
        var = "cameraDistanceMaxZoomFactor",
        text = L["设置最远镜头距离"],
        tip = L["说明`这个值是修改\"界面-镜头-最大镜头距离\"绝对值, 比如, 系统默认为15, 界面设置里调到最大是15，调到中间是7.5。当设置此选项为25时，调到最大是25，调到中间是12.5"],
        type = "spin",
        range = {1, 2.6, 0.1},
        cols = 3,
        default = "2.6",
        getvalue = function() return ceil(GetCVar("cameraDistanceMaxZoomFactor")*10)/10 end,
        callback = function(cfg, v, loading) SetCVar("cameraDistanceMaxZoomFactor", v) end,
    },

    --[[------------------------------------------------------------
    -- 姓名板设置
    ---------------------------------------------------------------]]
    {
        text = "姓名板设置", type = "text",
        U1CfgMakeCVarOption(U1_NEW_ICON.."友方玩家姓名板职业颜色", "ShowClassColorInFriendlyNameplate", nil, {
            reload = 1,
            tip = "说明`7.2.5新增变量，无法通过界面设置",
        }),
        U1CfgMakeCVarOption("敌方玩家职业颜色", "ShowClassColorInNameplate", nil, { reload = 1 }),

        U1CfgMakeCVarOption("显示友方NPC的姓名板", "nameplateShowFriendlyNPCs", nil, {
            tip = "说明`7.1之后，友方NPC的姓名板无法通过界面设置",
        }),

        U1CfgMakeCVarOption(untex(DISPLAY_PERSONAL_RESOURCE) or "显示个人资源", "nameplateShowSelf", 0, { tip = OPTION_TOOLTIP_DISPLAY_PERSONAL_RESOURCE, secure = 1 }),

        --U1CfgMakeCVarOption("总是显示姓名板", "nameplateShowAll", { tip = OPTION_TOOLTIP_UNIT_NAMEPLATES_AUTOMODE, secure = 1 }),

        --makeCVarOption("能量点位于目标姓名板", "nameplateResourceOnTarget", { tip = '连击点等框体显示在目标姓名板上而不是自己脚下', secure = 1 }),

        U1CfgMakeCVarOption("姓名板分散不重叠", "nameplateMotion", nil, { tip = UNIT_NAMEPLATES_TYPE_TOOLTIP_2, callback = function(cfg, v, loading)
            if not loading then
                local function f()
                    SetCVar(cfg.var:gsub("^cvar_", ""), v)
                    local d = InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown
                    if d then
                        local v --= v and 1 or 0 will taint
                        d.value = v
                        d.selectedValue = v
                    end
                end
                CoreLeaveCombatCall("ABY_nameplateMotion", "脱战后会自动更新设置", f)
            end
        end}),

        U1CfgMakeCVarOption("允许姓名板移到屏幕之外", "nameplateOtherTopInset", nil, {
            tip = "说明`7.0之后，姓名板默认会收缩到屏幕之内挤在一起``此选项可以恢复到7.0之前的方式",
            secure = 1,
            getvalue = function() if GetCVar("nameplateOtherTopInset") == "-1" then return true else return false end end,
            callback = function(cfg, v, loading)
                if v then
                    SetCVar("nameplateTargetRadialPosition", 2)
                    SetCVar("nameplateOtherTopInset", -1)
                    SetCVar("nameplateOtherBottomInset", -1)
                    --C.NamePlate.SetTargetClampingInsets
                else
                    SetCVar("nameplateTargetRadialPosition", GetCVarDefault("nameplateTargetRadialPosition"))
                    SetCVar("nameplateOtherTopInset", GetCVarDefault("nameplateOtherTopInset"))
                    SetCVar("nameplateOtherBottomInset", GetCVarDefault("nameplateOtherBottomInset"))
                end
            end
        }),

        U1CfgMakeCVarOption("切换友方姓名板显示", "nameplateShowFriends", nil, { secure = 1, callback = function(cfg, v, loading)
            if not loading then SetCVar(cfg.var:gsub("^cvar_", ""), v) end
        end}),
    },

    {
        text = U1_NEW_ICON.."进一步优化友方姓名版",
        tip = "说明`这些选项只影响暴雪自带的姓名板，由于暴雪限制，在副本里只能使用系统自带的友方姓名板。这些选项是在暴雪允许的范围内进行一些调整。可以在副本里（非战斗状态）或者关闭美化姓名板（TidyPlates）进行测试。",
        var = "optNamePlates",
        default = false,
        secure = 1,
        callback = function(cfg, v, loading)
            if not InCombatLockdown() then
                if v then
                    local NamePlateHorizontalScale = 1.0
                    local NamePlateVerticalScale = 1.0
                    local NamePlateClassificationScale = 1.0
                    if InterfaceOptionsNamesPanelUnitNameplatesMakeLarger and tostring(InterfaceOptionsNamesPanelUnitNameplatesMakeLarger:GetValue()) == "1" then
                        NamePlateHorizontalScale = 1.4
                        NamePlateVerticalScale = 2.7
                        NamePlateClassificationScale = 1.25
                    end
                    SetCVar("NamePlateHorizontalScale", NamePlateHorizontalScale)
                    SetCVar("NamePlateVerticalScale", NamePlateVerticalScale)
                    SetCVar("nameplateMinScale", 1.0)
                    SetCVar("nameplateMinAlpha", 0.75)
                    SetCVar("ShowClassColorInFriendlyNameplate", 1)
                    --SetCVar("nameplateShowOnlyNames", 1)
                    --SetCVar("nameplateSelectedScale", 1.0)
                    if not loading then
                        U1CfgCallSub(cfg, "scale", true)
                        U1CfgCallSub(cfg, "fwidth", true)
                        U1CfgCallSub(cfg, "fheight", true)
                        U1CfgCallSub(cfg, "fthrough", true)
                    end
                elseif not loading then
                    SetCVar("nameplateGlobalScale", GetCVarDefault("nameplateGlobalScale"))
                    SetCVar("nameplateMinScale", GetCVarDefault("nameplateMinScale"))
                    SetCVar("nameplateMinAlpha", GetCVarDefault("nameplateMinAlpha"))
                    if InterfaceOptionsNamesPanelUnitNameplatesMakeLarger and tostring(InterfaceOptionsNamesPanelUnitNameplatesMakeLarger:GetValue()) == "1" then
                        C_NamePlate.SetNamePlateFriendlySize(154, 64.125)
                    else
                        C_NamePlate.SetNamePlateFriendlySize(110, 45)
                    end
                    C_NamePlate.SetNamePlateFriendlyClickThrough(false)
                end
            end
            if loading then
                hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function()
                    -- call in InterfaceOptionsPanel_Cancel -> InterfaceOptionsLargerNamePlate_OnLoad setFunc
                    if not InCombatLockdown() then
                        U1CfgCallBack(cfg)
                        U1CfgCallSub(cfg, "scale", true)
                        U1CfgCallSub(cfg, "fwidth", true)
                        U1CfgCallSub(cfg, "fheight", true)
                        U1CfgCallSub(cfg, "fthrough", true)
                    end
                end)
            end
        end,
        { text = "缩放比例", var = "scale", type = "spin", range = {0.4, 2.0, 0.1}, default = 1, callback = function(cfg, v, loading) SetCVar("nameplateGlobalScale", v or 1.0) end, },
        { text = "自带友方姓名板宽度", var = "fwidth", type = "spin", range = {24, 200, 1}, default = 60, callback = function(cfg, v, loading) local w,h = C_NamePlate.GetNamePlateFriendlySize() C_NamePlate.SetNamePlateFriendlySize(v, h) end, },
        { text = "自带友方姓名板占位高度", tip = "说明`此设置影响友方姓名板点击可选中的区域，也会影响堆叠分散时姓名板之间的间隔，设置成最小1可以实现敌方姓名板堆叠、友方姓名板不堆叠的效果。系统默认值为45，建议想点击时设置成20，不想点击时设置成1", var = "fheight", type = "spin", range = {-100, 100, 1}, default = 45, callback = function(cfg, v, loading) if v == 0 then v = 1 end local w,h = C_NamePlate.GetNamePlateFriendlySize() C_NamePlate.SetNamePlateFriendlySize(w, v) end, },
        { text = "友方姓名板不可点击", var = "fthrough", default = false, callback = function(cfg, v, loading) C_NamePlate.SetNamePlateFriendlyClickThrough(not not v) end, },
    },

    {
        text = "进一步修改敌方姓名板", var = "optEnemyPlates", default = false, secure = 1,
        { text = "敌方姓名板占位高度", tip = "说明（有Plater插件的时候此设置不执行）`开关大姓名板时需要手工调整此选项` `此设置影响敌方姓名板点击可选中的区域，也会影响堆叠分散时姓名板之间的间隔。`系统默认值为45(nameplateOverlapV=1.1)`大姓名板默认值为64`Plater的设置为28(nameplateOverlapV=1.4)`可供参考", var = "eheight", type = "spin", range = {-100, 100, 1}, default = 45, callback = function(cfg, v, loading) if U1IsAddonEnabled("Plater") then return end if v == 0 then v = 1 end local w,h = C_NamePlate.GetNamePlateEnemySize() C_NamePlate.SetNamePlateEnemySize(w, v) end, },
    },

    --[[------------------------------------------------------------
    -- 浮动战斗信息设置
    ---------------------------------------------------------------]]
    {
        text = "暴雪伤害数字设置", type = "text",
        U1CfgMakeCVarOption("人物伤害", "floatingCombatTextCombatDamage", 1),
        U1CfgMakeCVarOption("人物治疗", "floatingCombatTextCombatHealing", 1),
        U1CfgMakeCVarOption("人物持续伤害", "floatingCombatTextCombatLogPeriodicSpells", nil),
        U1CfgMakeCVarOption("宠物普攻", "floatingCombatTextPetMeleeDamage", nil),
        U1CfgMakeCVarOption("宠物技能", "floatingCombatTextPetSpellDamage", nil),
        --fctSpellMechanics floatingCombatTextAllSpellMechanics floatingCombatTextSpellMechanics floatingCombatTextSpellMechanicsOther
    }

})

if(not GetCVar) then return end --java parser
do
    local realPortal = GetCVar("portal") or "CN" --GetCVar is always realPortal even after ConsoleExec("SET portal TW")

    StaticPopupDialogs["ABYUI_CLOSE_PROFANITYFILTER"] = {preferredIndex = 3,
        text = "爱不易监测到你使用了|cff00ff00'强制关闭语言过滤器'|r的功能，这可能会导致暴雪的客服支持面板一直转圈或报错。如果你现在需要客服支持，点击'是'会恢复语言过滤设置，并自动|cffff0000重载界面|r，然后就可以使用了。是否确定？",
        button1 = YES,
        button2 = CANCEL,
        OnAccept = function(self, data)
            U1ChangeCfg("163UI_MoreOptions/profanityFilter", false)
            ReloadUI()
        end,
        OnCancel = function(self, data)
        end,
        hideOnEscape = 1,
        timeout = 0,
        exclusive = 1,
        whileDead = 1,
    }

    --[==[ 9.1邀请按钮提示 ERR_TRAVEL_PASS_DIFFERENT_REGION 不同的地区, 没法修改下拉框等，作废
    local INVITE_RESTRICTION_NONE = 9;
    local INVITE_RESTRICTION_MOBILE = 10;
    local INVITE_RESTRICTION_REGION = 11;
    hooksecurefunc("FriendsFrame_UpdateFriendButton", function(button)
        if button.buttonType == FRIENDS_BUTTON_TYPE_BNET then
            local restriction = FriendsFrame_GetInviteRestriction(button.id);
            if restriction == INVITE_RESTRICTION_NONE or restriction == INVITE_RESTRICTION_REGION then
                button.travelPassButton:Enable();
                if not button.travelPassButton.__hookedOnEnter then
                    button.travelPassButton.__hookedOnEnter = true
                    button.travelPassButton:HookScript("OnEnter", function(self)
                    	local restriction = FriendsFrame_GetInviteRestriction(self:GetParent().id);
                    	if ( restriction == INVITE_RESTRICTION_REGION ) then
                            GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
                    		local guid = FriendsFrame_GetPlayerGUIDFromIndex(self:GetParent().id);
                    		local inviteType = GetDisplayedInviteType(guid);
                    		if ( inviteType == "INVITE" ) then
                    			GameTooltip:SetText(TRAVEL_PASS_INVITE, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
                    		elseif ( inviteType == "SUGGEST_INVITE" ) then
                    			GameTooltip:SetText(SUGGEST_INVITE, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
                    		else --inviteType == "REQUEST_INVITE"
                    			GameTooltip:SetText(REQUEST_INVITE, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
                    			--For REQUEST_INVITE, we'll display other members in the group if there are any.
                    			local group = C_SocialQueue.GetGroupForPlayer(guid);
                    			local members = C_SocialQueue.GetGroupMembers(group);
                    			local numDisplayed = 0;
                    			for i=1, #members do
                    				if ( members[i].guid ~= guid ) then
                    					if ( numDisplayed == 0 ) then
                    						GameTooltip:AddLine(SOCIAL_QUEUE_ALSO_IN_GROUP);
                    					elseif ( numDisplayed >= 7 ) then
                    						GameTooltip:AddLine(SOCIAL_QUEUE_AND_MORE, GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b, 1);
                    						break;
                    					end
                    					local name, color = SocialQueueUtil_GetRelationshipInfo(members[i].guid, nil, members[i].clubId);
                    					GameTooltip:AddLine(color..name..FONT_COLOR_CODE_CLOSE);

                    					numDisplayed = numDisplayed + 1;
                    				end
                    			end
                            end
                            GameTooltip:Show();
                        end
                    end)
                end
            else
                button.travelPassButton:Disable();
            end
        end
    end)
    ]==]
    hooksecurefunc("ConsoleExec", function(msg)
        if FriendsFrame_GetInviteRestriction_Origin then return end
        local portal = type(msg) == "string" and select(3, msg:lower():find("set portal (.+)"))
                                              or select(3, msg:lower():find("portal (.+)"))
        if portal and portal ~= GetCVar("portal"):lower() then
            FriendsFrame_GetInviteRestriction_Origin = FriendsFrame_GetInviteRestriction
            local INVITE_RESTRICTION_REGION = 11;
            local INVITE_RESTRICTION_NONE = 9;
            FriendsFrame_GetInviteRestriction = function(index)
                local restriction = FriendsFrame_GetInviteRestriction_Origin(index)
                if restriction == INVITE_RESTRICTION_REGION then
                    return INVITE_RESTRICTION_NONE
                else
                    return restriction
                end
            end
        end
    end)

    if GameMenuButtonHelp then
        SetOrHookScript(HelpFrame, "OnShow", function()
            if(U1GetCfgValue("163UI_MoreOptions", 'profanityFilter')) then
                StaticPopup_Show("ABYUI_CLOSE_PROFANITYFILTER")
                AbySetProfanityButton:Hide()
            else
                AbySetProfanityButton:Show()
            end
        end)

        local btn = WW:Button("AbySetProfanityButton", HelpFrame, "UIPanelButtonTemplate")
        :SetTextFont(GameFontNormal, 13, "")
        :SetText("关闭语言过滤器"):Size(120, 26)
        :TOPRIGHT(-25, 2)
        :AddFrameLevel(1)
        :SetScript("OnClick", function()
            U1ChangeCfg("163UI_MoreOptions/profanityFilter", true)
            U1Message("已强制关闭语言过滤器，聊天不会再乱码，即时生效，不需重载界面")
            if not InCombatLockdown() then HideUIPanel(HelpFrame) end
        end):un()
        CoreUIEnableTooltip(btn, '说明', '强制关闭语言过滤器和暴雪的支持功能有冲突, 需要访问暴雪支持功能时需要临时恢复语言过滤器。用完了可通过此按钮再次关闭（也可在控制台-额外设置里设置）')
    end

    setProfanityFilter = function(loading)
        if(U1GetCfgValue("163UI_MoreOptions", 'profanityFilter')) then
            ConsoleExec("SET portal TW")
            SetCVar('profanityFilter', '0')
            --if BNConnected() then
            pcall(BNSetMatureLanguageFilter, false)
        elseif not loading then
            ConsoleExec("SET portal " .. realPortal)
        end
    end

--     for _, e in next, {
--         'CVAR_UPDATE',
--         'PLAYER_ENTERING_WORLD',
--         'BN_MATURE_LANGUAGE_FILTER',
--         -- events that might cause problem
--         -- 'MINIMAP_UPDATE_ZOOM',
--         -- 'UPDATE_CHAT_COLOR_NAME_BY_CLASS',
--     } do
--         CoreOnEvent(e, setProfanityFilter)
--     end

    --[[
    CoreOnEvent("PLAYER_ENTERING_WORLD", function()
        if U1GetCfgValue("163ui_moreoptions/death_release") and UnitIsDeadOrGhost("player") then
            AcceptResurrect()
            RepopMe()
        end
        return "remove"
    end)
    --]]
end
