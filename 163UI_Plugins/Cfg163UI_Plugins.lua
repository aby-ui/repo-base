U1PLUG = {}
local function load(cfg, v, loading, no_reload, plugin)
    plugin = plugin or cfg.var
    if v and U1PLUG[plugin] then
        U1PLUG[plugin]()
        U1PLUG[plugin] = nil
        if not loading then U1Message("已启用小功能 - "..cfg.text, 0.2, 1.0, 0.2) end
    elseif not v and not no_reload then
        if not loading then U1Message("停用小功能可能需要重载界面", 1.0, 0.2, 0.2) end
    end
end

U1_NEW_ICON = U1_NEW_ICON or '|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t'
U1RegisterAddon("163UI_Plugins", {
    title = "贴心小功能集合",
    defaultEnable = 1,
    load = "NORMAL",
    tags = { TAG_MANAGEMENT },
    icon = "Interface\\ICONS\\INV_Misc_Blizzcon09_GraphicsCard",
    desc = "各种贴心小功能，组合在一起，原来和爱不易核心在一起，现在独立出来了。",
    nopic = 1,

    {
        var = "CastSound",
        text = U1_NEW_ICON.."战斗节奏音",
        default = "none",
        tip = "说明`实验功能，在成功释放技能后播放一个音效，说不定有用呢。",
        type = "radio",
        options = {
            "无", "none", "D3", "Ding3.ogg", "D5", "Ding5.ogg", "D7", "Ding7.ogg",
            "D9", "Ding9.ogg", "P3", "Pling4.ogg", "P4", "Pling5.ogg", "P5", "Pling6.ogg",
        },
        cols = 4,
        callback = function(cfg, v, loading)
            if not _G.U1CastSoundFrame then
                _G.U1CastSoundFrame = CreateFrame("Frame")
                ---[[
                local lastSpell
                _G.U1CastSoundFrame:SetScript("OnEvent", function(self, event, ...)
                    if event == "COMBAT_LOG_EVENT_UNFILTERED" then
                        local timeStamp, subevent, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellId = CombatLogGetCurrentEventInfo()
                        if sourceGUID == UnitGUID("player") and (subevent=="SPELL_CAST_START" or subevent=="SPELL_CAST_SUCCESS") then
                            --print(subevent, spellId, lastSpell, GetSpellLink(spellId), destName)
                        end
                        if sourceGUID == UnitGUID("player") and (subevent=="SPELL_CAST_START" or subevent=="SPELL_CAST_SUCCESS") and lastSpell and (InCombatLockdown() or UnitExists("boss1")) then
                            if lastSpell == spellId then
                                lastSpell = nil
                                PlaySoundFile("Interface\\AddOns\\TellMeWhen\\Sounds\\"..self.sound, "MASTER")
                            end
                        end
                    elseif event == "UNIT_SPELLCAST_SENT" then
                        local unit, target, castid, spell = ...
                        if unit == "player" then
                            lastSpell = spell
                            --print(event, unit, spell)
                            --PlaySoundFile("Interface\\AddOns\\TellMeWhen\\Sounds\\"..self.sound, "MASTER")
                        end
                    end
                end)
            end
            if v ~= "none" then
                _G.U1CastSoundFrame.sound = v
                _G.U1CastSoundFrame:RegisterEvent("UNIT_SPELLCAST_SENT")
                _G.U1CastSoundFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
                if not loading then PlaySoundFile("Interface\\AddOns\\TellMeWhen\\Sounds\\"..v, "MASTER") end
            else
                _G.U1CastSoundFrame:UnregisterEvent("UNIT_SPELLCAST_SENT")
                _G.U1CastSoundFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
            end
        end
    },

    {
        var = "ExaltedPlus", text = U1_NEW_ICON.."声望增强", default = true, callback = load,
        tip = "说明`7.2版本新增功能`声望面板直接显示崇拜后的进度。`获得声望时会显示当前进度。`可以设置自动追踪刚获得的声望。",
        {
            var = "autotrace",
            default = true,
            text = "满级后自动追踪刚提升的声望"
        }
    },

    {
        var = "skipTalkingHead",
        default = false,
        text = U1_NEW_ICON.."完全屏蔽剧情台词窗口",
        confirm = "建议通过双击空格关闭台词窗口，\n完全屏蔽可能会导致剧情不连贯。\n您确定吗?",
        tip = "说明`7.0新增的窗口，如果启用此选项，则完全屏蔽，毫无痕迹。建议不要启用，爱不易提供了双击空格直接关闭当前台词的功能。",
        callback = function(cfg, v, loading) U1Toggle_SkipTalkingHead(v) end,
    },

    {
        var = "HideQuickJoin",
        text = "屏蔽快速加入提示",
        default = false,
        tip = "说明`7.1新增的快速加入提示消息，爱不易贴心提供屏蔽功能。",
        callback = function(cfg, v, loading) U1Toggle_QuickJoinToasts(not v, loading) end,
    },

    {
        text = "显示布局网格",
        tip = "说明`快捷命令/align 20 或 /wangge 30, 默认格子大小是30",
        callback = function(cfg, v, loading) SlashCmdList["EALIGN_UPDATED"]("") end,
    },

    {
        var = "replaceTalent",
        default = true,
        text = "自动替换天赋技能",
        tip = "说明`当同一层天赋是不能并存的主动技能时，更换天赋会用新技能替换动作条上的旧技能，而不是同时存在新旧两个技能",
    },

    {
        var = "garrisonMMB",
        default = true,
        text = "职业大厅小地图按钮",
        tip = "说明`把职业大厅小地图按钮缩小为普通小地图按钮大小，并支持拖动。关闭此功能需要重载界面",
        callback = function(cfg, v, loading)
            if not loading and v then U1_ProcessGarrisonLandingPageMMB() end
            if not loading and not v then U1Message("停用小功能需要重载界面", 1.0, 0.2, 0.2) end
        end
    },

    {
        var = "QuestWatchSort", text = U1_NEW_ICON.."任务追踪按距离排序", default = false, callback = load,
        tip = "说明`按任务远近进行排序``暴雪的任务排序功能失效很久了,爱不易为您临时提供解决方案",
    },

    {
        var = "163UI_Quest", text = "任务奖励信息与半自动交接", default = true, callback = load,
        tip = "说明`●选择奖励时显示卖店价格`●选择奖励时显示物品类型`●显示'自动选择最贵'按钮`●显示直接接受和完成按钮",
    },

    {
        var = "AlreadyKnown", text = "已学配方染色", default = true, callback = load,
        tip = "说明`在商人和拍卖行界面中将已学配方染色显示。",
    },

    {
        var = "CopyFriendList", text = "好友复制功能", default = true, callback = load,
        tip = "说明`点击好友列表（O键面板）左上角可以弹出好友复制功能菜单，可以复制同账号下其他角色的游戏内好友列表。",
    },

    {
        var = "FriendsGuildTab", text = "好友/公会切换按钮", default = true, callback = load,
        tip = "说明`在好友面板和公会面板右下角添加切换到另一个面板的标签页。",
    },

    {
        var = "GuildRosterButtons", text = "公会名单切换按钮", default = true, callback = load,
        tip = "说明`在公会名单面板上显示一组按钮，用来切换'玩家状态','专业'等，比默认的下拉菜单方式要方便一些。",
    },

    {
        var = "FixBlizGuild", text = U1_NEW_ICON.."延迟加载公会新闻", default = true, callback = load,
        tip = "说明`打开公会面板时不加载公会新闻，可能会减少初次打开公会卡死的问题。",
    },

    {
        var = "MerchantFilterButtons", text = "商人面板过滤按钮", default = true, callback = load,
        tip = "说明`在NPC商人购买面板上方，显示'职业、专精、是否装备绑定'等过滤按钮，替代系统的下拉菜单方式。",
    },

    {
        var = "OpenBags", text = "开启银行时打开全部背包", default = true, callback = load,
    },

    {
        var = 'PingPing', text = '显示小地图点击者名字', default = true,
        callback = function(_, v, loading)
            if(not loading) then
                local addon = LibStub('AceAddon-3.0'):GetAddon('163PingPing')
                if(addon) then
                    if(v) then
                        addon:Enable()
                    else
                        addon:Disable()
                    end
                end
            end
        end,
    },

    {
        var = "ProfessionTabs", text = "专业技能面板标签", default = true, callback = load,
        tip = "说明`在专业制造面板右侧显示各个专业的切换按钮。",
    },

    {
        var = 'bfautorelease',
        default = false,
        text = '战场中自动释放灵魂',
    },

    {
        var = 'map_raid_color',
        default = true,
        text = '地图队友图标颜色',
        tip = "说明`大地图和小地图上的队友圆点显示为起职业颜色",
        reload = 1,
        callback = function(cfg, v, loading)
            local mod = U1PLUGIN_ColorRostersOnMap
            if(mod and mod.Init) then
                return mod:Init()
            end
        end,
    },

    {
        var = "SlashCommands", text = "快捷命令", default = true, callback = load,
        tip = "说明`增加若干命令行指令`● /tele 传入传出随机副本`● /in 秒数 其他命令`　　延迟N秒后执行其他命令`　　例如/in 1 /yell 开怪啦",
    },

    {
        var = "ExtraActionButton", text = "自定义的额外动作按钮", default = false, callback = function(cfg, v, loading)
            CoreLeaveCombatCall(cfg._path, "战斗中无法显示或隐藏。", function()
                if U1PLUG["ExtraActionButton"] then load(cfg, v, loading, true) end
                CoreUIShowOrHide(U1ExtraAction1, v)
            end)
        end,
        tip = "说明`某些场景下会出现一个单独的动作按钮，有时此按钮会因为某些原因导致看不到，为不影响玩家游戏，尤其是BOSS战斗，可以打开此选项，使用一个自定义的替代按钮。",
    },

--[=[
    {
        var = 'print_huangli_onload',
        default = 1,
        text = '每天第一次登陆时显示老黄历',
    },
]=]

})

U1RegisterAddon("GrievousHelper", { title = "重伤助手(自动摘武器)", defaultEnable = 1, parent = "163UI_Plugins", })