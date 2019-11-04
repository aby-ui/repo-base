if GetLocale()=="zhCN" or GetLocale() == "zhTW" then
    COMERGY_GENERAL = "通用"
    COMERGY_BAR = "界面与文本"

    COMERGY_BLOOD = "就绪"
    COMERGY_FROST = "Frost"
    COMERGY_UNHOLY = "冷却"
    COMERGY_DEATH = "Death"

    COMERGY_LEFT = "左"
    COMERGY_RIGHT = "右"
    
    COMERGY_TARGET_HEALTH_WARNING = "注意: 可能需要reload才生效"

    COMERGY_TEXT_SOUND = SOUND
    COMERGY_TEXT_SPLIT = "分段"
    COMERGY_TEXT_COLOR = COLOR
    COMERGY_TEXT_FLASH = "当激活"..GetSpellInfo(79140)..","..GetSpellInfo(13750).."或"..GetSpellInfo(185313).."时:" --宿敌 冲动 暗影之舞
    COMERGY_TEXT_ANTICIPATION = "当使用90级天赋时:"

    COMERGY_TEXTURE = "能量条材质"
    COMERGY_FONT = "字体"

    COMERGY_SLIDERINFO = {
        ["X"] = "水平位置",
        ["Y"] = "垂直位置",
        ["Width"] = "长度",
        ["Spacing"] = "间隔",
        ["TextHeight"] = "字体大小",
        ["DurationScale"] = "渐隐延时",
        ["FrameStrata"] = "框体层级",
        ["PlayerHeight"] = "玩家血条高度",
        ["TargetHeight"] = "目标血条高度",
    }

    COMERGY_SLIDERINFO_ENERGY = {
        ["EnergyHeight"] = "能量条高度",
    }

    COMERGY_SLIDERINFO_FOCUS = {
        ["EnergyHeight"] = "集中值条高度",
    }

    COMERGY_SLIDERINFO_RAGE = {
        ["EnergyHeight"] = "怒气条高度",
    }

    COMERGY_SLIDERINFO_RUNIC = {
        ["EnergyHeight"] = "符文能量条高度",
    }

    COMERGY_SLIDERINFO_INSANITY = {
        ["EnergyHeight"] = "狂乱值条高度",
    }

    COMERGY_SLIDERINFO_MANA = {
        ["ManaHeight"] = "法力值条高度",
    }

    COMERGY_SLIDERINFO_COMBO = {
        ["ChiHeight"] = "条高度",
        ["ChiBGAlpha"] = "背景透明度",
        ["ChiDiff"] = "渐进分段",
    }

    COMERGY_SLIDERINFO_CHI = COMERGY_SLIDERINFO_COMBO

    COMERGY_SLIDERINFO_HOLY_POWER = COMERGY_SLIDERINFO_COMBO

    COMERGY_SLIDERINFO_ARCANE_CHARGES = COMERGY_SLIDERINFO_COMBO

    COMERGY_SLIDERINFO_RUNE = {
        ["RuneHeight"] = "符文条高度",
        ["RuneBGAlpha"] = "背景透明度",
        ["RuneDiff"] = "渐进分段",
    }

    COMERGY_CHECKOPTINFO = {
        ["Enabled"] = "整体启用/停用插件",
        ["ShowOnlyInCombat"] = "战斗外隐藏",
        ["ShowInStealth"] = "潜行时显示",
        ["ShowWhenEnergyNotFull"] = "但是当能量或血量不满时显示",
        ["Locked"] = "锁定位置",
        ["CritSound"] = "暴击音效",
        ["StealthSound"] = "增加缺失的潜行音效",
        ["TextCenter"] = "文字居中",
        ["TextCenterUp"] = "文字在框体上方",
        ["FlipBars"] = "交换能量条与资源点的位置",
        ["FlipOrientation"] = "反向增长",
        ["VerticalBars"] = "垂直模式",
        ["ShowPlayerHealthBar"] = "显示",
        ["ShowTargetHealthBar"] = "显示",
        ["EnergyFlash"] = "能量条闪烁",
        ["Anticipation"] = "修改额外连击点颜色",
        ["AnticipationCombo"] = "仅修改激活的连击点",
    }

    COMERGY_CHECKOPTINFO_ENERGY = {
        ["EnergyText"] = "数值文本",
        ["UnifiedEnergyColor"] = "统一颜色",
        ["GradientEnergyColor"] = "颜色渐变",
        ["EnergyBGFlash"] = "当能量不足时闪烁",
    }

    COMERGY_CHECKOPTINFO_FOCUS = COMERGY_CHECKOPTINFO_ENERGY

    COMERGY_CHECKOPTINFO_RAGE = COMERGY_CHECKOPTINFO_ENERGY

    COMERGY_CHECKOPTINFO_INSANITY = COMERGY_CHECKOPTINFO_ENERGY

    COMERGY_CHECKOPTINFO_RUNIC = COMERGY_CHECKOPTINFO_ENERGY

    COMERGY_CHECKOPTINFO_MANA = {
        ["ManaText"] = "法力值文本",
        ["ManaShortText"] = "数值简化",
        ["UnifiedManaColor"] = "统一颜色",
        ["GradientManaColor"] = "渐变色",
        ["ManaBGFlash"] = "没有足够法力值时闪烁",
    }

    COMERGY_CHECKOPTINFO_COMBO = {
        ["ChiText"] = "资源点数值",
        ["UnifiedChiColor"] = "统一颜色",
        ["ChiFlash"] = "当资源点满时闪烁并播放音效",
    }

    COMERGY_CHECKOPTINFO_CHI = COMERGY_CHECKOPTINFO_COMBO

    COMERGY_CHECKOPTINFO_HOLY_POWER = COMERGY_CHECKOPTINFO_COMBO

    COMERGY_CHECKOPTINFO_ARCANE_CHARGES = COMERGY_CHECKOPTINFO_COMBO

    COMERGY_CHECKOPTINFO_RUNE = {
        ["RuneText"] = "符文数文本",
        ["UnifiedRuneColor"] = "统一颜色",
        ["RuneFlash"] = "符文闪烁",
    }

    COMERGY_COLORPICKERINFO = {
        ["TextColor"] = "文本颜色",
        ["BGColorAlpha"] = "背景颜色",
        ["RuneBGColorAlpha"] = "符文背景",
    }

    COMERGY_COLORPICKERINFO_ENERGY = {
        ["EnergyBGColorAlpha"] = "能量背景",
    }

    COMERGY_COLORPICKERINFO_FOCUS = COMERGY_COLORPICKERINFO_ENERGY

    COMERGY_COLORPICKERINFO_INSANITY = COMERGY_COLORPICKERINFO_ENERGY

    COMERGY_COLORPICKERINFO_RAGE = COMERGY_COLORPICKERINFO_ENERGY

    COMERGY_COLORPICKERINFO_RUNIC = COMERGY_COLORPICKERINFO_ENERGY

    COMERGY_COLORPICKERINFO_MANA = {
        ["ManaBGColorAlpha"] = "背景",
    }

    COMERGY_TALENT_PRIMARY = "专精"
    COMERGY_TALENT_SECONDARY = ""

    COMERGY_TALENT = ""
end