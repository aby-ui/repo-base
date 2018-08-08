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

    U1CfgMakeCVarOption(U1_NEW_ICON.."简易原汁原味", "overrideArchive", {
        tip = "说明`通过设置变量达到简易反和谐的目的，没有任何风险。可以和谐大部分模型，比如坟包会替换成白骨，技能图标似乎不会变化。``\n如果开启后卡蓝条或无法进入游戏，请删除WTF\\Config.wtf``|cffff0000设置后必须重启游戏才能生效。|r",
        confirm = "注意：如果开启后|cffff7777无法进入游戏|r，请删除WTF\\Config.wtf文件即可恢复（或只移除其中的overrideArchive条目）\n\n请确认，然后关闭游戏重新进入。",
        getvalue = function() return not GetCVarBool("overrideArchive") end,
        callback = function(cfg, v, loading) SetCVar("overrideArchive", v and "0" or "1") end,
    }),

    --[[
    U1CfgMakeCVarOption(U1_NEW_ICON.."使用老版本TAB键选取方式", "targetnearestuseold", {
        tip = "说明`7.0之后TAB键可以选取到身后的怪物，容易ADD，启用此选项可以恢复之前的方式",
        reload = 1,
    }),--]]

    U1CfgMakeCVarOption("姓名板的最大显示距离", "nameplateMaxDistance", {
        tip = "说明`7.0之后默认显示距离是60码，会导致另一个楼层的怪物都会被显示出来，可以修改此选项进行设置。建议设置为40或30",
        type = "spin",
        range = {20, 80, 5},
    }),

    {
        text = "反向整理背包",
        var = "SetSortBagsRightToLeft",
        tip = "说明`设置默认背包整理(不是tdPack背包整理)的顺序。`7.0以后暴雪将此选项精简掉了",
        default = function() return GetSortBagsRightToLeft() end,
        getvalue = function() return GetSortBagsRightToLeft() end,
        callback = function(cfg, v, loading)
            if loading then return end
            SetSortBagsRightToLeft(v)
        end,
    },

    {
        text = "新物品优先放入行囊",
        var = "SetInsertItemsLeftToRight",
        tip = "说明`拾取/购买新物品时，优先放入行囊，也就是先放入靠右的背包。`7.0以后暴雪将此选项精简掉了",
        default = function() return not GetInsertItemsLeftToRight() end,
        getvalue = function() return not GetInsertItemsLeftToRight() end,
        callback = function(cfg, v, loading)
            if loading then return end
            SetInsertItemsLeftToRight(not v)
        end,
    },

    U1CfgMakeCVarOption("显示目标施法条", "showTargetCastbar", {
        tip = "说明`是否在目标头像下方显示施法条`7.0以后暴雪将此选项精简掉了",
        reload = 1,
    }),

    U1CfgMakeCVarOption("显示目标仇恨值", "threatShowNumeric", {
        tip = "说明`在目标头像上方显示当前仇恨百分比",
    }),

    U1CfgMakeCVarOption("自动追踪任务", "autoQuestWatch", {
        tip = "说明`接受任务后自动添加到追踪列表里`7.0以后暴雪将此选项精简掉了",
        reload = 1,
    }),

    U1CfgMakeCVarOption("连击点界面位置", "comboPointLocation", {
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
        tip = '说明`4.3版本后出现的BUG，玩家即使不开启过滤器，系统有时也会强制过滤，而且在界面选项里无法修改。开启此选项后，爱不易会强制关闭语言过滤器选项。',
        default = true,
        --getvalue = function() return GetCVar'profanityFilter' == '1' end,
        callback = function(cfg, v, loading)
            return setProfanityFilter()
        end
    },

    U1CfgMakeCVarOption("按下按键时开始动作", "ActionButtonUseKeyDown"),
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
        U1CfgMakeCVarOption(U1_NEW_ICON.."友方玩家姓名板职业颜色", "ShowClassColorInFriendlyNameplate", {
            reload = 1,
            default = false,
            tip = "说明`7.2.5新增变量，无法通过界面设置",
        }),
        U1CfgMakeCVarOption("敌方玩家职业颜色", "ShowClassColorInNameplate", { reload = 1 }),

        U1CfgMakeCVarOption("显示友方NPC的姓名板", "nameplateShowFriendlyNPCs", {
            tip = "说明`7.1之后，友方NPC的姓名板无法通过界面设置",
        }),

        U1CfgMakeCVarOption(untex(DISPLAY_PERSONAL_RESOURCE) or "显示个人资源", "nameplateShowSelf", { tip = OPTION_TOOLTIP_DISPLAY_PERSONAL_RESOURCE, secure = 1 }),

        --U1CfgMakeCVarOption("总是显示姓名板", "nameplateShowAll", { tip = OPTION_TOOLTIP_UNIT_NAMEPLATES_AUTOMODE, secure = 1 }),

        --makeCVarOption("能量点位于目标姓名板", "nameplateResourceOnTarget", { tip = '连击点等框体显示在目标姓名板上而不是自己脚下', secure = 1 }),

        U1CfgMakeCVarOption("允许姓名板移到屏幕之外", "nameplateOtherTopInset", {
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

        { text = "切换友方姓名板显示", secure = 1, callback = function() SetCVar("nameplateShowFriends", not GetCVarBool("nameplateShowFriends")); end },

    },

    {
        text = U1_NEW_ICON.."进一步优化友方姓名版",
        tip = "说明`这些选项只影响暴雪自带的姓名板，由于暴雪限制，在副本里只能使用系统自带的友方姓名板。这些选项是在暴雪允许的范围内进行一些调整。可以在副本里（非战斗状态）或者关闭美化姓名板（TidyPlates）进行测试。",
        var = "optNamePlates",
        default = false,
        secure = 1,
        callback = function(cfg, v, loading)
            if v then
                SetCVar("NamePlateVerticalScale", 1.0)
                SetCVar("NamePlateHorizontalScale", 1.0)
                SetCVar("nameplateMinScale", 1.0)
                SetCVar("nameplateMinAlpha", 0.75)
                SetCVar("ShowClassColorInFriendlyNameplate", 1)
                --SetCVar("nameplateShowOnlyNames", 1)
                --SetCVar("nameplateSelectedScale", 1.0)
                if not loading then
                    U1CfgCallSub(cfg, "scale", true)
                    U1CfgCallSub(cfg, "fwidth", true)
                    U1CfgCallSub(cfg, "fthrough", true)
                end
            elseif not loading then
                SetCVar("nameplateGlobalScale", GetCVarDefault("nameplateGlobalScale"))
                SetCVar("nameplateMinScale", GetCVarDefault("nameplateMinScale"))
                SetCVar("nameplateMinAlpha", GetCVarDefault("nameplateMinAlpha"))
                C_NamePlate.SetNamePlateFriendlySize(110, 45)
                C_NamePlate.SetNamePlateFriendlyClickThrough(false)
            end
        end,
        { text = "缩放比例", var = "scale", type = "spin", range = {0.4, 2.0, 0.1}, default = 1, callback = function(cfg, v, loading) SetCVar("nameplateGlobalScale", v or 1.0) end, },
        { text = "自带友方血条宽度", var = "fwidth", type = "spin", range = {24, 200, 1}, default = 60, callback = function(cfg, v, loading) C_NamePlate.SetNamePlateFriendlySize(v, 45) end, },
        { text = "友方血条不可点击", var = "fthrough", default = false, callback = function(cfg, v, loading) C_NamePlate.SetNamePlateFriendlyClickThrough(not not v) end, },
    },

    --[[------------------------------------------------------------
    -- 浮动战斗信息设置
    ---------------------------------------------------------------]]
    {
        text = "暴雪伤害数字设置", type = "text",
        U1CfgMakeCVarOption("人物伤害", "floatingCombatTextCombatDamage"),
        U1CfgMakeCVarOption("人物治疗", "floatingCombatTextCombatHealing"),
        U1CfgMakeCVarOption("人物持续伤害", "floatingCombatTextCombatLogPeriodicSpells"),
        U1CfgMakeCVarOption("宠物普攻", "floatingCombatTextPetMeleeDamage"),
        U1CfgMakeCVarOption("宠物技能", "floatingCombatTextPetSpellDamage"),
        --fctSpellMechanics floatingCombatTextAllSpellMechanics floatingCombatTextSpellMechanics floatingCombatTextSpellMechanicsOther
    }

})

if(not GetCVar) then return end --java parser
do
    setProfanityFilter = function()
        if(U1GetCfgValue("163UI_MoreOptions", 'profanityFilter')) then
            SetCVar('profanityFilter', '0')
            --if BNConnected() then
            pcall(BNSetMatureLanguageFilter, false)
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
end
