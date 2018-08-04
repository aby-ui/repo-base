U1RegisterAddon("163UI_CombatTimer", {
    title = "战斗计时",
    tags = { TAG_COMBATINFO, TAG_GOOD, },
    atlas = "Mobile-CombatIcon",
    desc = "显示进入战斗和战斗结束的提示，同时显示当前战斗持续时间，更多功能还会逐渐完善。",
    nopic = 1,
    author = "|cffcd1a1c[爱不易原创]|r",
    defaultEnable = 1,

    frames = {"U1CT"},

    toggle = function(name, info, enable, justload)
        if enable then
            U1CT:RegisterEvent("PLAYER_REGEN_DISABLED")
            U1CT:RegisterEvent("PLAYER_REGEN_ENABLED")
            U1CT:RegisterEvent("ENCOUNTER_START")
            U1CT:RegisterEvent("ENCOUNTER_END")
            CoreUIShowOrHide(U1CT, U1GetCfgValue(name, "timer"))
        else
            U1CT:UnregisterAllEvents()
            U1CT:Hide()
        end
    end,

    {
        text = "提示文字位置",
        var = "yoffset",
        type = "spin",
        range = { -500, 500, 50 },
        default = 200,
        callback = function(cfg, v, loading)
            CombatTimerEnterBanner:SetPoint("CENTER", 0, v)
            CombatTimerLeaveBanner:SetPoint("CENTER", 0, v)
            if loading then return end
            U1CT_PlayBanner(true)
        end
    },
    {
        text = "提示文字停留时间",
        var = "duration",
        type = "spin",
        range = { 0.5, 2.5, 0.1 },
        default = 0.8,
        callback = function(cfg, v, loading)
            CombatTimerEnterBanner.Anim.BG1Alpha:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.TitleAlpha:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.BLAlpha:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.IconAlpha:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.BG1Scale:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.TitleScale:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.BLScale:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.IconScale:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.BG1Translation:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.TitleTranslation:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.BonusLabelTranslation:SetStartDelay(v)
            CombatTimerEnterBanner.Anim.IconTranslation:SetStartDelay(v)

            CombatTimerLeaveBanner.Anim.BG1Alpha:SetStartDelay(v)
            CombatTimerLeaveBanner.Anim.TitleAlpha:SetStartDelay(v)
            CombatTimerLeaveBanner.Anim.BG1Scale:SetStartDelay(v)
            CombatTimerLeaveBanner.Anim.TitleScale:SetStartDelay(v)
            CombatTimerLeaveBanner.Anim.BG1Translation:SetStartDelay(v)
            CombatTimerLeaveBanner.Anim.TitleTranslation:SetStartDelay(v)

            if loading then return end
            U1CT_PlayBanner(true)
        end
    },
    {
        text = "进入战斗提示",
        var = "enter_anim",
        default = true,
        callback = function(cfg, v, loading) if not v or loading then return end U1CT_PlayBanner(true) end,
        {
            type = "input",
            text = "主要文字",
            var = "title",
            default = "爱不易战斗计时",
        },
        {
            type = "input",
            text = "次要文字",
            var = "label",
            default = "进入战斗",
        },
    },

    {
        text = "进入战斗音效",
        var = "enter_sound",
        default = true,
        callback = function(cfg, v, loading) if not v or loading then return end U1CT_PlaySound(true) end,

        {
            text = "音效选择",
            var = "ogg",
            type = "drop",
            options = {
                "女声开火", "Sound\\Character\\BloodElf\\BloodElfFemaleOpenFire01.ogg",
                "哐", "Sound\\Interface\\LFG_RoleCheck.ogg",
                "嘭", "Sound\\Interface\\Aggro_Pulled_Aggro.ogg",
                "咯噔", "Sound\\Interface\\UI_70_Artifact_Forge_ColorChange_03.ogg",
                "口哨1", "Sound\\Character\\EmoteCatCallWhistle01.ogg",
            },
            default = "Sound\\Interface\\UI_70_Artifact_Forge_ColorChange_03.ogg",
            callback = function(cfg, v, loading) if not v or loading then return end U1CT_PlaySound(true) end,
        }
    },

    {
        text = "离开战斗提示",
        var = "leave_anim",
        default = true,
        callback = function(cfg, v, loading) if not v or loading then return end U1CT_PlayBanner(false) end,
        {
            type = "input",
            text = "提示文字",
            var = "title",
            default = "离开战斗",
        }
    },

    {
        text = "离开战斗音效",
        var = "leave_sound",
        default = false,
        callback = function(cfg, v, loading) if not v or loading then return end U1CT_PlaySound(false) end,
    },

    {
        text = "启用计时器",
        var = "timer",
        default = true,
        callback = function(cfg, v, loading)
            CoreUIShowOrHide(U1CT, v)
        end,

        {
            text = "计时数字字体",
            var = "timer_font",
            type = "drop",
            default = NumberFontNormal:GetFont(),
            options = CtlSharedMediaOptions("font"),
            callback = function(cfg, v, loading)
                local font, size, outline = U1CT.text:GetFont()
                U1CT.text:SetFont(v, size, outline)
                if not loading and not InCombatLockdown() then
                    U1CT_StartTimer(true)
                    CoreScheduleBucket("U1CT_CFG_STOP", 5.0, U1CT_StartTimer, false)
                end
            end,
        },
    }

})