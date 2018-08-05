U1RegisterAddon("DuowanChat", {
    title = "聊天条",
    defaultEnable = 1,
    tags = {TAG_CHAT},
    load = "LOGIN", --5.0 script ran too long
    optdeps = {"163UI_Chat"},
    frames = {"DWCChatFrame"},

    desc = "来自魔盒及大脚的聊天条插件，在聊天框下方显示各个频道的切换按钮，此外还提供表情图标、世界频道、属性报告、整页复制（聊天框左上角按钮）等功能。`其他功能参见设置窗口。",
    icon = [[Interface\ICONS\Spell_Holy_HolyGuidance]],

    author = "魔盒/大脚",

    toggle = function(name, info, enable, justload)
        CoreUIEnableOrDisable(DuowanChat, enable);
        U1CfgCallSub(name, "report", enable);
    end,

    ------- Options --------
    {
        type="checkbox",
        text="开启玩家属性发送",
        var = "report",
        default = 1,
        tip="聊天条中增加属性发送按钮`左键发送简约信息`右键发送详细信息",
        callback = function(cfg, v, loading) DuowanStat_Toggle(v) end,
    },
    {
        text="显示发言人的级别",
        var = "level",
        default = 1,
        getvalue = function() return DuowanChat.db.profile.enablelevel end,
        callback = function(cfg, v, loading) DuowanChat.db.profile.enablelevel = not not v end,
    },
    {
        text="团队时显示小队编号",
        var = "subgroup",
        default = 1,
        getvalue = function() return DuowanChat.db.profile.enablesubgroup end,
        callback = function(cfg, v, loading) DuowanChat.db.profile.enablesubgroup = not not v end,
    },
    {
        text="创建个人聊天窗口",
        var = "channel",
        tip = "说明`创建一个窗口显示仅和自己相关的信息，排除公共频道，避免信息爆炸。",
        getvalue = function() return DuowanChat.db.profile.enablechatchannel end,
        callback = function(cfg, v, loading)
            DuowanChat.db.profile.enablechatchannel = not not v
            local modChatChannel = DuowanChat:GetModule("CHATCHANNEL", true);
            if(modChatChannel)then
                if v then
                    modChatChannel._SetByOption = true;
                    modChatChannel:Enable()
                else
                    modChatChannel:Disable()
                end
            end
            DuowanChat:Refresh()
        end,
    },
--[[
    {
        type="checkbox",
        text="开启快捷聊天条",
        var = "bar",
        default = 1,
        callback = function(cfg, v, loading)
            if v then
                DuowanChat:EnableModule("ICONFRAME");
                DuowanChat:EnableModule("CHATFRAME");
                U1CfgCallBack(U1CfgFindChild(cfg, "report"));
            else
                DuowanChat:DisableModule("ICONFRAME");
                DuowanChat:DisableModule("CHATFRAME");
                U1CfgCallBack(U1CfgFindChild(cfg, "report"), false);
            end
        end,
    },
]]
    {
        text="其他设置",
        callback = function() LibStub("AceConfigDialog-3.0"):Open("DuowanChat"); end,
    },

});

if(not ChatFrame_AddMessageEventFilter) then return end
local L = {}
L["BigFootChannel"] = "大脚世界频道"
L["WorldChannel"] = "世界频道"

-- people don't wanna know, and we cannot wait for OnInitialize()
local notice_filter = function(cf, event, msg, sender, lang, channelStr,
    target, flags, unknown, channelNumber, channelName, unknown2, counter, ...)
    --if(channelName == L.BigFootChannel) then
    if(channelName:find(L.BigFootChannel)) then
        return false, msg, sender, lang, channelStr, target, flags, unknown,
        channelNumber, L.WorldChannel, unknown2, counter, ...
    end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL_NOTICE', notice_filter)
ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL_NOTICE_USER', notice_filter)

local join_leave_filter = function(cf, event, msg, sender, lang, channelStr,
    target, flags, unknown, channelNumber, channelName, unknown2, counter)
    if(channelName:find(L.BigFootChannel)) then
        return true
    end
end

ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL_JOIN', join_leave_filter)
ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL_LEAVE', join_leave_filter)

