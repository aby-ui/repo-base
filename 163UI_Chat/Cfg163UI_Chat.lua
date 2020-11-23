U1_CHAT_WORLD_CHANNEL = "大脚世界频道";

U1RegisterAddon("163UI_Chat", {
    title = "聊天增强",
    defaultEnable = 1,
    load = "LOGIN",
    desc = "和聊天框相关的小插件，提供聊天框缩放、鼠标滚轮增强、TAB切换频道、点击时间标记复制文本等功能，详情参见设置页面。` `此外还整合了'自动查询密语详情'及'智能切换声望条'的功能。",

    tags = { TAG_CHAT, TAG_DEV },

    --icon = [[Interface\Icons\Achievement_WorldEvent_ChildrensWeek]],
    author = "|cffcd1a1c[爱不易原创]|r",
    icon = [[Interface\Icons\Spell_Holy_HolyGuidance]],
    ------- Options --------
    {
        var="worldchannel",
        default = false,
        text="加入世界频道",
        callback = function(cfg, v, loading)
            if v then
                local id, name = JoinChannelByName(U1_CHAT_WORLD_CHANNEL)
                if not id then
                    CoreOnEvent("INITIAL_CLUBS_LOADED", function()
                        JoinChannelByName(U1_CHAT_WORLD_CHANNEL)
                        return true
                    end)
                end
            else
                LeaveChannelByName(U1_CHAT_WORLD_CHANNEL)
            end
            if DuowanChat and DuowanChat.SetBFChannelMuted and dwChannel_RefreshMuteButton then
                DuowanChat:SetBFChannelMuted(not v)
                dwChannel_RefreshMuteButton()
            end
        end,
    },

    {
        var="wwm",
        default = false,
        text="自动查询密我的人是谁",
        callback = function(cfg, v, loading)
            WhoWhisperedMeCmds(v and "ON" or "OFF");
        end,
        {
            text="列出密我的所有人",
            tip="说明`可以点击回复哦`命令行：/wwm",
            callback = function() WhoWhisperedMeCmds("stats") end,
        }
    },
    {
        var = "whispersticky",
        default = false,
        type = "checkbox",
        text = "保持上次密语对象",
        tip = "说明`按回车时显示的是最近一次密语的人，容易密错人，请注意哦。",
        callback = function(cfg, v, loading)
            ChatTypeInfo["WHISPER"].sticky = v and 1 or 0;
            ChatTypeInfo["BN_WHISPER"].sticky = v and 1 or 0;
            if not v then
                WithAllChatFrame(function(cf)
                    local ctype = cf.editBox:GetAttribute("chatType")
                    if ctype=="WHISPER" or ctype=="BN_WHISPER" then
                        cf.editBox:SetAttribute("chatType", "SAY")
                    end
                    local stype = cf.editBox:GetAttribute("stickyType")
                    if stype=="WHISPER" or stype=="BN_WHISPER" then
                        cf.editBox:SetAttribute("stickyType", "SAY")
                    end
                end)
            end
        end,
    },
    {
        var = "resize2",
        default = 1,
        type = "checkbox",
        text = "启用左上角缩放按钮",
        callback = function(cfg, v, loading)
            if v then
                WithAllChatFrame(function(chatFrame) if(chatFrame.ResizeButton:IsVisible()) then chatFrame.resizeButton2:Show() end end)
            else
                WithAllChatFrame(function(chatFrame) chatFrame.resizeButton2:Hide() end)
            end
            togglehook(nil, "U1Chat_ChatFrameResizeOnShow", noop, not v);
        end,
    },
    {
        var = "wheel",
        default = 1,
        type = "checkbox",
        text = "启用鼠标滚轮增强功能",
        tip = "说明`启用本功能后，按住ctrl然后滚动鼠标滚轮可以一次翻一页，按住shift然后滚动则可以翻到第一行或最末行。",
        callback = function(cfg, v, loading)
            togglehook(nil, "U1Chat_ChatFrame_OnMouseWheel", noop, not v);
        end,
    },
    {
        var = "editontop",
        default = false,
        type = "checkbox",
        text = "输入框位于窗口顶部",
        callback = function(cfg, v, loading)
            if loading and not v then return end
            U1_Chat_UpdateEditBoxPosition()
        end,
        {
            var = "offset",
            default = 0,
            type= "spin",
            range = {-100, 100, 10},
            text = "位置偏移量",
            tip = "说明`向上为正，向下为负数，默认0是在聊天标签上沿。",
            callback = function(cfg, v, loading)
                if not loading then U1CfgCallBack(cfg._parent, nil, loading); end
            end,
        }
    },
    {
        var = "format3",
        getvalue = function() return U1DBG.config_timestamp end, --因为和cvar联动，所以只能用全局值，不能用default，不能通过更新强制设置默认值
        type = "drop",
        text = "聊天时间戳格式",
        tip = "说明`修改系统设置，美化颜色，并且可以点击时间戳复制这一行聊天文本。` `这里稍微有点绕，从这里设置时间戳会显示为浅蓝色，且对非聊天记录也能有效，暴雪的时间戳设置那边会显示为自定义。` `而如果选了不改变暴雪样式，则相当于关闭插件功能（不修改时间戳颜色也无法点击），并把系统的时间戳改为默认格式。",
        options = function()
            local exampleTime = time({ year = 2010, month = 12, day = 15, hour = 15, min = 27, sec = 32, })
            local tsFormat = { TIMESTAMP_FORMAT_HHMM, TIMESTAMP_FORMAT_HHMMSS, TIMESTAMP_FORMAT_HHMM_AMPM, TIMESTAMP_FORMAT_HHMMSS_AMPM, TIMESTAMP_FORMAT_HHMM_24HR, TIMESTAMP_FORMAT_HHMMSS_24HR }
            local tsOptions = { "不改变暴雪样式", "", "无", "none", }
            for _, v in ipairs(tsFormat) do tinsert(tsOptions, BetterDate(v, exampleTime)); tinsert(tsOptions, '|cff68ccef' .. v .. '|r') end
            return tsOptions
        end,
        confirm = "需要重载页面才能生效，是否确定",
        reload = true,
        callback = function(cfg, v, loading)
            local cvalue = GetCVar("showTimestamps")

            if loading then
                --print(format("'%s'", cvalue or 'nil'), format("'%s'", U1DBG.config_timestamp or 'nil'), format("'%s'", v or 'nil'), U1DB.configs["163ui_chat/format"], U1DB.configs["163ui_chat/format3"])
                U1DB.showTimestamps = nil
                local old1 = U1DB.configs["163ui_chat/format"] --v1版'无'或''表示没有，此外有"%M:%S"是旧值
                local old2 = U1DB.configs["163ui_chat/format2"] --v2版''表示没有，可能为'none'
                local oldv = old1 or old2 or nil --值只会是nil和字符串, nil表示没有这个版本的数据, 优先取old1
                if oldv ~= nil then
                    if U1DBG.config_timestamp == nil then
                        --旧版数据兼容, 如果之前有值, 尽量设置为之前的值, 然后删掉他们
                        if oldv == '无' or oldv == '' then
                            v = 'none'
                        else
                            v = '|cff68ccef' .. oldv .. '|r '
                        end
                        -- 我们的旧版会设置为"none", 如果不是none则表示用户改过.
                        if cvalue == "none" or cvalue == "无" or cvalue == "" then
                            SetCVar("showTimestamps", v)
                            CHAT_TIMESTAMP_FORMAT = v ~= 'none' and v or nil --可能会污染社区面板, 但只在新老切换时设置, 问题不大
                        end
                    end
                    U1DB.configs["163ui_chat/format"] = nil
                    U1DB.configs["163ui_chat/format2"] = nil

                else
                    --正常进入游戏，以cvar为主来设置插件，如果用其他号设置了cvar，这边会把设置同步过来。但是如果其他号是非|c开头的，那我们也保持原样，只是把设置改为''
                    if cvalue == 'none' or cvalue == '无' or cvalue == '' then
                        if v ~= '' then v = 'none' end --保持住不修改默认
                    elseif cvalue and cvalue:sub(1,2) ~= "|c" then
                        v = '' --暴雪的格式，我们改成不修改暴雪样式
                    else
                        v = cvalue --|c开头的，表示是我们设置的，那我们就保存起来
                    end
                    if U1DBG.config_timestamp == nil then
                        v = '|cff68ccef' .. TIMESTAMP_FORMAT_HHMMSS_24HR .. '|r' --默认值 default
                        U1Message("重置了聊天时间戳格式，请在控制面板-聊天增强里修改")
                    end

                    if v ~= cvalue and v ~= '' and v ~= '无' then
                        SetCVar("showTimestamps", v)
                        CHAT_TIMESTAMP_FORMAT = v ~= 'none' and v or nil
                    end
                end

                U1DBG.config_timestamp = v
                return
            end --loading

            --如果选了不改变暴雪样式，则相当于关闭插件功能（不修改时间戳颜色也无法点击），并把系统的时间戳改为默认格式。
            if v == '' then
                SetCVar("showTimestamps", TIMESTAMP_FORMAT_HHMMSS_24HR);
            else
                SetCVar("showTimestamps", v);
            end
            U1DBG.config_timestamp = v
            ReloadUI()
        end,
    },
    {
        var = "maxLines",
        default = nil,
        type = "spin",
        range = {0, 5000, 500,},
        text = "设置聊天框的记录行数",
        cols = 4,
        callback = function(cfg, v, loading)
            U1Chat_SetMaxLines(not loading)
        end,
    },
    {
        type="button",
        id="clean",
        text="清除当前窗口",
        tip="温馨提示`请先点一下要清除窗口的标签，然后再点击此按钮",
        callback = function(cfg, v, loading)
            if SELECTED_CHAT_FRAME then
                StaticPopup_Show("163UI_CHAT_CLEAR", _G[SELECTED_CHAT_FRAME:GetName().."Tab"]:GetText());
            else
                U1Message("请先点击标签选择一个聊天框");
            end
        end,
    },
    {
        var="customtab",
        default = 1,
        text="启用TAB智能切换对话模式",
        tip="说明`按TAB键可以在说/公会/小队/团队/战场等对话模式下切换，小提示：按住SHIFT再按TAB可以向前翻。",
        callback = function(cfg, v, loading)
            togglehook(nil, "ChatEdit_CustomTabPressed_Inner", noop, not v);
        end,
        {
            var="tabchannel",
            text="是否在通用频道之间切换",
            tip="说明`循环时包含'综合','交易'等通用频道。",
        },
    },
    {
        var = 'chatColorNamesByClass',
        default = false,
        text = "聊天框名字使用职业颜色",
        tip = '说明`选中后将自动启用所有频道和玩家信息的[使用职业颜色]选项, 关闭时不会自动禁用这些选项',
        callback = function(cfg, v, loading)
            U1_Chat_EnableChatColorNamesByClassGroup(v)
        end,
    },
});
