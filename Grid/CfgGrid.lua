U1RegisterAddon("Grid", {
    title = "团队框架Grid",
    defaultEnable = 1,
    load = "NORMAL",
    minimap = "LibDBIcon10_Grid",

    tags = { TAG_RAID, },
    icon = "Interface\\AddOns\\Grid\\Media\\icon",
    desc = "强大的团队框架Grid, 使用爱不易warbaby的整合版，提供适合大部分玩家的默认配置。`Grid插件下有许多扩展子模块，可以根据自己的需要选择开启。``如需自行配置显示的内容，需要在设置界面中给不同的|cffffffff指示器|r配置上对应的|cffffffff状态|r，有一些状态自身也有选项，要在'状态页'中进行调整。",
    pics = 2,

    modifier = "|cffcd1a1c[爱不易]|r",

    toggle = function(name, info, enable, justload)
        if(justload and IsLoggedIn()) then
            RunOnNextFrame(function() U1LoadAddOn("GridClickSets") end)
        elseif not justload then
            CoreUIShowOrHide(GridLayoutFrame, enable)
        end
    end,

    runBeforeLoad = function(info, name) end,

    -------- Options --------
    {
        text = "详细设置",
        callback = function(cfg, v, loading) LibStub("AceConfigDialog-3.0"):Open("Grid") end,
    },
    {
        text = "图标冷却文字设置",
        callback = function(cfg, v, loading)
            U1CfgGridConfigOmniCC()
        end,
    },
    --]]
});

U1RegisterAddon("GridBuffIcons", {
    desc = "在Grid的框架上显示所有增益或减益图标。",
    title = "扩展：增益减益图标", protected = nil, hide = nil, load = "NORMAL",
    {
        var = "filter",
        text = "过滤状态图标",
        tip = "说明`状态图标模块是显示全部状态还是只显示自己可释放/移除的。",
        default = true,
        getvalue = function()
            local mod = Grid:GetModule("GridBuffIconStatus", true);
            return mod.db.profile.bufffilter
        end,
        callback = function(cfg, v, loading)
            local mod = Grid:GetModule("GridBuffIconStatus", true);
            if mod then
                mod.db.profile.bufffilter = v;
                mod:UpdateAllUnitsBuffs();
            end
        end,
    },
    {
        var = "buff",
        text = "切换增益/减益",
        tip = "说明`开启状态图标后，可以方便的在BUFF和DEBUFF之间切换，既可检查团队状态信息，又可关注战斗减益。",
        default = false,
        getvalue = function()
            local mod = Grid:GetModule("GridBuffIconStatus", true);
            return mod.db.profile.showbuff
        end,
        callback = function(cfg, v, loading)
            local mod = Grid:GetModule("GridBuffIconStatus", true);
            if mod then
                mod.db.profile.showbuff = v;
                mod:UpdateAllUnitsBuffs();
            end
        end,
    },
});
--U1RegisterAddon("GridBorderStyle", {title = "扩展：边框美化", deps = {"GridManaBars"}, protected = nil, hide = nil, });
U1RegisterAddon("GridManaBars", {title = "指示器：法力能量条", load="NORMAL", protected = nil, hide = nil, load = "NORMAL",});
U1RegisterAddon("GridIndicatorsDynamic", {title = "指示器：边角及自定义", load="NORMAL", protected = nil, hide = nil, load = "NORMAL",
    desc = "提供动态添加图标/色块/文字指示器的功能，默认提供了四边图标和四角文字",
});
U1RegisterAddon("GridQuickHealth", {title = "扩展：快速血条变化", protected = nil, hide = nil, load = "NORMAL",
    desc = "加快原版Grid血量变化，最高可缩短近300毫秒，赢得反应时间！",
});
U1RegisterAddon("GridCustomLayouts", {title = "扩展：自定义布局", protected = nil, hide = nil, load = "NORMAL",
    desc = "提供基于属性的布局定义，功能强大，满足您的各种需求。仅建议高级玩家尝试。",
});
U1RegisterAddon("GridStatusEnemyTarget", {title = "状态：怪物目标", protected = nil, hide = nil, load = "NORMAL",
    desc = "提供最迅速的Boss目标转移警告，怪物当前目标以黄框显示（Grid自带的怪物当前仇恨目标为红框，两者有区别），并提供怪物施法进度的显示",
});
U1RegisterAddon("GridStatusHots", {title = "状态：HoTs(持续治疗)", protected = nil, hide = nil, load = "NORMAL",
    desc = "提供常见持续治疗效果的倒计时及总数提示。"
});
U1RegisterAddon("GridStatusTankCooldown", {title = "状态：坦克救命技能", protected = nil, hide = nil, load = "NORMAL",
    desc = "提供一些救场技能的提示，例如盾墙、破釜沉舟等。默认显示在右侧图标中。"
});
U1RegisterAddon("GridStatusRaidDebuff", {title = "状态：团队减益", protected = nil, hide = false, load="NORMAL",
    desc = "提供副本Boss的主要Debuff技能的提示。"
});
U1RegisterAddon("GridStatusRD_Legion", {title = "军团再临", protected = nil, hide = nil, load="NORMAL",});
U1RegisterAddon("GridStatusRD_WoD", {title = "德拉诺之王", protected = nil, hide = nil, load="NORMAL",});
U1RegisterAddon("GridStatusRD_MoP", {title = "熊猫人之谜", defaultEnable = 0, protected = nil, hide = nil, load="NORMAL",});



--[[------------------------------------------------------------
OmniCC profile for Grid 2016.7.28 warbaby
---------------------------------------------------------------]]
function U1CfgGridConfigOmniCC()
    if not IsAddOnLoaded("OmniCC_Config") then U1LoadAddOn("OmniCC") U1LoadAddOn("OmniCC_Config") end
    if not IsAddOnLoaded("OmniCC_Config") then U1Message("请安装OmniCC及OmniCC_Config插件") return end
    if OmniCC:GetGroupIndex('163UI_Grid') then
        OmniCCOptions:SetGroupId('163UI_Grid')
        SlashCmdList["OmniCC"]()
    end
end
CoreDependCall("OmniCC", function()
    local KEY = '163UI_Grid'
    local VERSION = "20160728"
    hooksecurefunc(OmniCC, "StartupSettings", function()
        local gid = OmniCC:GetGroupIndex(KEY)
        if not gid then
            OmniCC:AddGroup('163UI_Grid')
            gid = OmniCC:GetGroupIndex(KEY)
        end
        if OmniCC.sets.groups[gid].version ~= VERSION then
            OmniCC.sets.groups[gid].version = VERSION
            OmniCC.sets.groups[gid].rules = {
                "GridLayoutHeader"
            }
            OmniCC.sets.groupSettings[KEY] = {
                enabled = true,
                scaleText = true,
                spiralOpacity = 0.6,
                fontFace = STANDARD_TEXT_FONT,
                fontSize = 26,
                fontOutline = 'OUTLINE',
                minDuration = 3,
                minSize = 0.1,
                effect = 'none',
                tenthsDuration = 0,
                mmSSDuration = 0,
                minEffectDuration=30,
                xOff = 10,
                yOff = 5,
                anchor = 'TOPRIGHT',
                styles = {
                    soon = { r = 1, g = .1, b = .1, a = 1, scale = 1 },
                    seconds = { r = 1, g = 1, b = .1, a = .9, scale = 1 },
                    minutes = { r = 1, g = 1, b = 1, a = .8, scale = 1 },
                    hours = { r = .7, g = .7, b = .7, a = .7, scale = 1 },
                    charging = { r = 0.8, g = 1, b = .3, a = .9, scale = 1 },
                    controlled = { r = 1, g = .1, b = .1, a = 1, scale = 1 },
                }
            }
        end
    end)
end)