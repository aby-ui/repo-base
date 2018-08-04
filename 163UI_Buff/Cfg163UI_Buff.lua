U1RegisterAddon("163UI_Buff", {
    title = "增益设置",
    defaultEnable = 1,

    tags = { TAG_COMBATINFO },
    icon = [[Interface\Icons\Achievement_Reputation_KirinTor]],

    author = "SonicBuff",
    modifier = "|cffcd1a1c[爱不易]|r",

    desc = "玩家的增益效果和负面效果显示精确到秒，无持续时间的状态可以显示'N/A'。``鼠标移动到状态图标上可以显示此效果的施法者",

    -------- Options --------
    {
        text = "重置以下选项为默认值",
        confirm = "恢复默认设置并重新加载界面？",
        callback = function(cfg, v, loading)
            SetCVar("buffDurations", 1)
            SetCVar("noBuffDebuffFilterOnTarget", 0)
            U1CfgResetAddOn("163UI_Buff")
        end,
    },
    {
        text = "玩家增益时间设置", type = "text",
        U1CfgMakeCVarOption("显示BUFF持续时间", "buffDurations", {
            tip = "说明`请通过默认的设置界面进行设置",
            default = 1,
            reload = 1,
            {
                var = "na",
                default = 1,
                text = "无时间的显示为N/A",
                callback = function(cfg, v, loading)
                    _G["163UI_Buff"].cfg_showna = v
                    if not loading then SBuff_Refresh() end
                end,
            },
            {
                var = "time",
                default = 1,
                text = "BUFF时间精确到秒",
                callback = function(cfg, v, loading)
                    _G["163UI_Buff"].cfg_showsec = v
                    -- for dura, _ in pairs(SBuff_AuraDurationProcessed) do
                    --     SBuff_Aura_ChangeBuffFontSize(dura, true)
                    -- end
                    -- SBuff_ResetAuraDurationFontSize()
                end,
                {
                    var = 'time10',
                    default = nil,
                    text = '十分钟以上不显示秒',
                    callback = function(cfg, v, loading)
                        _G['163UI_Buff'].cfg_showsec_10 = v
                    end,
                },
            },
            {
                var = "buffSize",
                default = 13,
                type = "spin",
                tip = "说明`调整美化后的增益减益下面的计时文字尺寸。",
                range = {1, 32, 1},
                text = "BUFF时间文字大小",
                callback = function(cfg, v, loading)
                    return SBuff_ResetAuraDurationFontSize()
                end,
            },
        }),
        {
            var = "caster",
            default = 1,
            text = "显示BUFF的施放者",
            callback = function(cfg, v, loading) togglehook(nil, "CastByHook", noop, not v) end,
        },
    },

    {
        text = "目标增益减益设置", type = "text",
        U1CfgMakeCVarOption("显示目标所有BUFF/DEBUFF", "noBuffDebuffFilterOnTarget", {
            tip = "说明`显示所有状态而不仅仅是你施放的。",
            reload = false,
        }),
        {
            var = "targetBuffCooldownCount",
            text = "显示目标BUFF计时数字",
            default = 1,
            tip = "说明`显示计时数字需要开启OmniCC，而且如果图标设置过小会自动隐藏计时数字。",
            callback = function(cfg, v, loading)
                if v and not loading and not IsAddOnLoaded("OmniCC") then
                    U1Message("显示计时数字需要开启OmniCC【技能冷却计时】")
                    for i = 1, TargetFrame._163buffFrames or 0 do
                        _G["TargetFrameBuff"..(i).."Cooldown"].noCooldownCount = not v
                    end
                    for i = 1, FocusFrame._163buffFrames or 0 do
                        _G["FocusFrameBuff"..(i).."Cooldown"].noCooldownCount = not v
                    end
                end
            end
        },
        {
            var = "largeBuffSize",
            type = "spin",
            range = {15, 36, 1},
            text = "玩家施放的BUFF大小",
            tip = "说明`玩家释放在目标上的负面效果的图标大小，注意不会根据新值调整换行，所以调整过大可能会影响布局效果。`默认值21",
            default = 21,
        },
        {
            var = "smallBuffSize",
            type = "spin",
            range = {12, 24, 1},
            text = "其他人施放的BUFF大小",
            tip = "说明`默认值17",
            default = 17,
        },
        {
            var = "targetDebuffCooldownCount",
            text = "显示目标DEBUFF计时数字",
            default = 1,
            tip = "说明`显示计时数字需要开启OmniCC，而且如果图标设置过小会自动隐藏计时数字。",
            callback = function(cfg, v, loading)
                if v and not loading and not IsAddOnLoaded("OmniCC") then
                    U1Message("显示计时数字需要开启OmniCC【技能冷却计时】")
                    for i = 1, TargetFrame._163debuffFrames or 0 do
                        _G["TargetFrameDebuff"..(i).."Cooldown"].noCooldownCount = not v
                    end
                    for i = 1, FocusFrame._163debuffFrames or 0 do
                        _G["FocusFrameDebuff"..(i).."Cooldown"].noCooldownCount = not v
                    end
                end
            end
        },
        {
            var = "largeDebuffSize",
            type = "spin",
            range = {15, 36, 1},
            text = "玩家施放的DEBUFF大小",
            tip = "说明`玩家释放在目标上的负面效果的图标大小，注意不会根据新值调整换行，所以调整过大可能会影响布局效果。`默认值21",
            default = 21,
        },
        {
            var = "smallDebuffSize",
            type = "spin",
            range = {12, 24, 1},
            text = "其他人施放的DEBUFF大小",
            tip = "说明`默认值17",
            default = 17,
        },
    },

    {
        text = "其他增益相关设置", type = "text",
        {
            text = "隐藏姓名板DEBUFF图标",
            tip = "说明`隐藏怪物血条上方的DEBUFF图标",
            var = "hideNameplateDebuff",
            default = false,
            callback = function(cfg, v, loading)
                if v and Buff163_StartHookNamePlates then
                    Buff163_StartHookNamePlates()
                    Buff163_StartHookNamePlates = nil
                end
            end
        },
        {
            text = "显示TOT状态层数",
            tip = "说明`开启此选项则显示目标的目标的Debuff状态层数，不开启则显示剩余时间。",
            var = "totdebuffcount",
            reload = 1,
            callback = function(cfg, v, loading)
                if v and TargetFrame.totFrame and not TargetFrame.totFrame._flag163 then
                    TargetFrame.totFrame._flag163 = 1

                    for i=1, 4 do
                        local debuffFrame = _G["TargetFrameToTDebuff"..i]
                        debuffFrame.countFrame = debuffFrame:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
                        debuffFrame.countFrame:SetJustifyH("RIGHT")
                        debuffFrame.countFrame:SetPoint("BOTTOMRIGHT", 4, -2)
                        _G["TargetFrameToTDebuff"..i.."Cooldown"].noCooldownCount = true
                    end

                    hooksecurefunc("RefreshDebuffs", function(frame, unit, numDebuffs, suffix, checkCVar)
                        if frame==TargetFrame.totFrame and frame:IsVisible() then
                            numDebuffs = numDebuffs or MAX_PARTY_DEBUFFS;
                            suffix = "Debuff";
                            local frameName = "TargetFrameToT"

                            local isEnemy = UnitCanAttack("player", unit);

                            local filter;
                            if ( checkCVar and SHOW_DISPELLABLE_DEBUFFS == "1" and UnitCanAssist("player", unit) ) then
                                filter = "RAID";
                            end

                            for i=1, MAX_PARTY_DEBUFFS do
                                local name, icon, count, debuffType, duration, expirationTime, caster = UnitDebuff(unit, i, filter);

                                local debuffName = frameName..suffix..n2s(i);
                                local debuffFrame = _G[debuffName]
                                if debuffFrame:IsShown() then
                                    local countFrame = debuffFrame.countFrame
                                    if count > 1 then
                                        countFrame:SetText(count);
                                        countFrame:Show();
                                    else
                                        countFrame:Hide();
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        },
    }
});
