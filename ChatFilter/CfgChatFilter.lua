U1RegisterAddon("ChatFilter", {
    title = "聊天过滤",
    defaultEnable = 1,
    tags = { TAG_CHAT, },
    nopic = 1,
    desc = "强力聊天过滤插件，过滤重复及广告信息，过滤多行宏，合并显示切换天赋时的学会/忘却技能，合并显示获得成就，合并显示制造物品。``你可以复制插件目录下的config-mine-copy.lua为config-mine.lua，然后修改其中的配置项目，包括添加自己的关键字。这样可以不会被插件更新器复原。",
    icon = [[Interface\Icons\Spell_Holy_PowerInfusion]],

    {
        text = U1_NEW_ICON .. "出入副本自动开关聊天泡泡",
        tip = '说明`进入副本自动开启聊天泡泡，出副本自动关闭，防止广告骚扰',
        var = "AutoBubble",
        default = false,
        callback = function(info, v, loading)
            if(loading) then
                local func = function()
                    if not U1GetCfgValue("ChatFilter/AutoBubble") then return end
                    SetCVar("chatBubbles", IsInInstance() and 1 or 0)
                end
                CoreOnEvent("PLAYER_ENTERING_WORLD", func)
                func()
            else
                -- 如果在副本外取消设置, 则设置为1, 防止在副本里忘了开
                if not v and not IsInInstance() then SetCVar("chatBubbles", 1) end
            end
        end
    },

    {
        text = "过滤重复信息",
        var = "FilterRepeat",
        default = false,
        callback = function(info, v, loading)
            ChatFilterConfig[info.var] = v
        end
    },

    {
        text = "屏蔽小号密语",
        var = "FilterByLevel",
        tip = "说明`使用BadBoy模块进行过滤，需要空出两个好友位置，通过临时添加好友判断密语玩家等级。",
        default = false,
        callback = function(info, v, loading)
            ChatFilterConfig.FilterByLevel = false  --屏蔽ChatFilter的小号功能
        end,

        { text = "屏蔽110级整的玩家", tip = "说明`暴雪开了110级试玩, 但是居然能发密语, 似乎还没被利用, 但是你懂的", var = "just100", default = false, },
        { text = "允许的最低等级", var = "level", type = "spin", range = {1, 120, 1}, default = 5, },
        { text = "死亡骑士允许等级", var = "level_dk", type = "spin", range = {55, 120, 1}, default = 57, },
        { text = "恶魔猎手允许等级", var = "level_dh", type = "spin", range = {55, 120, 1}, default = 99, }
    },

    {
        text = "屏蔽副本外的喊话",
        tip = "说明`在城里的时候屏蔽超过指定字数的喊话（红字）与说话（白字）",
        var = "FilterYell",
        default = true,
        {
            text = "允许的最大字数",
            tip = "说明`少于这些字数（汉字算一个）的喊话不会被屏蔽",
            var = "YellLen",
            default = 30,
            type = "spin",
            range = {0, 100, 5},
        }
    },

    {
        text = "屏蔽公共频道里过长的发言",
        tip = "说明`屏蔽所有频道包括综合、世界、交易、防务里过长的信息，与喊话不同，如果设置的过小可能会错过公会招募、吟游诗人等略微有价值的消息。",
        var = "FilterChannel",
        default = true,
        {
            text = "允许的最大字数",
            tip = "说明`少于这些字数（汉字算一个）的发言不会被屏蔽",
            var = "MaxLen",
            default = 80,
            type = "spin",
            range = {0, 160, 5},
        }
    }
});

--[[------------------------------------------------------------
提前注册，以免后续处理
---------------------------------------------------------------]]
local playerGUID = UnitGUID("player")
local function filter(self, event, msg, player, _, _, _, flag, _, _, channel, _, lineId, guid)
    if IsInInstance() or guid == playerGUID or not U1GetCfgValue("ChatFilter", "FilterYell") then
        return
    end
    msg = msg and msg:gsub("\124c%x%x%x%x%x%x%x%x.-\124H.-\124h(.-)\124h.-\124r", "%1")
    if msg and string.utf8len(msg) > (U1GetCfgValue("ChatFilter/FilterYell/YellLen") or 80) then
        return true
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_EMOTE", filter)

local function filterChannel(self, event, msg, player, _, _, _, flag, _, _, channel, _, lineId, guid)
    if guid == playerGUID or not U1GetCfgValue("ChatFilter", "FilterChannel") then
        return
    end
    msg = msg and msg:gsub("\124c%x%x%x%x%x%x%x%x.-\124H.-\124h(.-)\124h.-\124r", "%1")
    if msg and string.utf8len(msg) > (U1GetCfgValue("ChatFilter/FilterChannel/MaxLen") or 80) then
        return true
    end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterChannel)