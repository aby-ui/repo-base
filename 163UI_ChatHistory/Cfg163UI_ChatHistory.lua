U1RegisterAddon("163UI_ChatHistory", {
    title = "聊天历史",
    defaultEnable = 1,
    load = 'NORMAL',

    tags = {TAG_CHAT, TAG_DEV},
    desc = "重新登入时可以重新显示上次游戏时10分钟之内的聊天文本。``并且在聊天输入框中，可以通过按↑↓键获取上次游戏甚至是其他角色的输入记录（举例说明：换号进团时，我密团长甲说：|cffffffff'XX职业要吗，我换号'|r,甲说'好',然后我换号进游戏后，只要按回车再按一下上，聊天框里就能显示|cffffffff'告诉甲：XX职业要吗，我换号'|r，非常方便）",
    --parent = "163UI_Chat",


    author = "|cffcd1a1c[爱不易原创]|r",
    
    icon = [[Interface\ICONS\INV_Inscription_Scroll]],

    {
        text = '显示上次游戏的历史信息',
        var = "showhis",
        tip = '说明`进入游戏时, 会显示上次游戏中10分钟以内的所有聊天文本。',
        type = 'checkbox',
        getvalue = function()
            return ChatHistoryDB and ChatHistoryDB.backlog
        end,
        callback = function(cfg, v, loading)
            if ChatHistoryDB then
                ChatHistoryDB.backlog = not not v
            end
        end,
    },
--[[
    {
        var = "altarrow",
        default = 1,
        type = "checkbox",
        text = "翻动输入历史不需按ALT键",
        callback = function(cfg, v, loading)
            U1ChatHistory_AltArrowKeyMode(not v);
        end,
    },
]]
    {
        var = "keep_session",
        type = "checkbox",
        text = "保存输入历史供下次登录使用",
        tip = "说明`在输入框中按ALT+↑可以调用出上次登录期间输入的历史。",
        default = 1,
        reload = 1,
        callback = function(cfg, v, loading)
            local db = ChatHistoryDB or _G["163UI_ChatHistory"].defaultDB;
            db.keep_session = v;
        end,
        {
            var = "character_only",
            type = "checkbox",
            text = "读取同账户角色的输入历史",
            tip = "说明`可以使用同账户其他角色近期的聊天输入历史。",
            reload = 1,
            default = 1,
            callback = function(cfg, v, loading)
                local db = ChatHistoryDB or _G["163UI_ChatHistory"].defaultDB;
                db.character_only = not v;
            end
        }
    },
    {
        var = "hookAdd",
        text = "防止输入历史丢失",
        tip = "说明`暴雪默认编辑一条输入历史后，会替换掉原来的记录。` `比如先说一个'收10个花'，然后ALT+↑和退格键改成'收10个草'，这时输入历史里的'收10个花'就被替换掉了。` `|cffff0000注意：开启本功能后只能手工输入安全命令,比如不能记录'/target 怪物'等命令，请根据自己的情况决定是否启用。|r",
        default = 1,
        callback = function(cfg, v, loading)
            togglehook(nil, "U1ChatHistory_HookAddHistoryLine", noop, not v);
        end,
    },
    {
        var = "maxlines",
        text = "设置输入历史最大数目",
        type = "radio",
        default = 32,
        cols = 4,
        options = {"默认", 0, "10", 10, "20", 20, "50", 50},
        callback = function(cfg, v, loading)
            local db = ChatHistoryDB or _G["163UI_ChatHistory"].defaultDB;
            db.lines = v;
            if v ~= 0 then
                WithAllChatFrame(function (cf) cf.editBox:SetHistoryLines(v) end);
            end
        end,
    },
})
