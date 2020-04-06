local msg_types = {
    CHAT_MSG_PARTY = "PARTY",
    CHAT_MSG_PARTY_LEADER = "PARTY",
    CHAT_MSG_RAID = "RAID",
    CHAT_MSG_RAID_LEADER = "RAID",
    CHAT_MSG_GUILD = "GUILD",
    CHAT_MSG_WHISPER = "WHISPER",
    CHAT_MSG_INSTANCE_CHAT = "INSTANCE_CHAT",
}
local chat_types = {} for _, v in pairs(msg_types) do chat_types[v] = true end

local frame_lasts, frame_lens, player_lasts, player_times, player_times2 = {}, {}, {}, {}, {}
local tmp_packed = {}

local debug = function() end --u1debug or print --function() end

--- 在聊天框里删除最后一条，然后重新触发MessageEventHandler，不能直接替换因为很多插件会通过AddMessage修改内容
-- @param packed { buf_last_element, event, msg, sender, ... }
local function ReplaceLastMessage(frame, newMsg, packed, len)
    haohaoliaotian = haohaoliaotian or {}
    if haohaoliaotian.pause then return end
    packed[3] = newMsg
    local buf = frame.historyBuffer
    local ele = buf.elements
    local last = ele[#ele]
    if last == packed[1] then
        ele[#ele] = nil
        buf.headIndex = buf.headIndex - 1
        if buf.headIndex < 0 then
            buf.headIndex = buf.maxElements
        end
        frame._run_again = true
        ChatFrame_MessageEventHandler(frame, unpack(packed, 2, len))
        frame._run_again = nil
        frame:RefreshDisplay()
    end
end

local chars = {} for i, v in ipairs({ "!", "@", "#", "$", "%", "^", "&", "*" }) do chars[string.byte(v)] = i end

local function transformFilteredToPattern(msg)
    if not msg then return "" end
    local i = 0
    while i < #msg do
        i = i + 1
        local c = msg:byte(i)
        local idx = chars[c]
        if idx then
            local head = i
            i = i + 1
            while i <= #msg and chars[msg:byte(i)] == idx % #chars + 1 do
                idx = chars[msg:byte(i)]
                i = i + 1
            end

            -- minimum 3 chars in a row
            if i - 1 - head + 1 >= 3 then
                msg = msg:sub(1, head - 1) .. "\007" .. msg:sub(i)
                i = head + 1
            end
        end
    end
    msg = msg:gsub("%%", "%%%%"):gsub("%-", "%%-"):gsub("%+", "%%+"):gsub("%.", "%%."):gsub("%[", "%%["):gsub("%]", "%%]"):gsub("%(", "%%("):gsub("%)", "%%)")
    return "^" .. escape_pattern(msg):gsub("\007", ".+") .. "$"
end

local GUILD_MAX_DELAY_TIME = 5 --公会消息和ADDON_MSG最长延迟
local GUILD_MIN_INTERVAL = 1.5 --同一个玩家上一条和本条最长间隔，低于此间隔不处理

local HookMsgHandler = function(f, event, ...)
    if f._run_again then return end
    frame_lens[f] = 0
    if not msg_types[event] or not f.historyBuffer then return end

    debug(GetTime(), f:GetName(), event, ...)

    local ele = f.historyBuffer.elements
    if not ele or #ele == 0 then return end

    local last = ele[#ele]
    --判断AddMessage的最后一条是不是和事件相同，先判断事件，后判断lineID
    if last.timestamp == GetTime() then
        --event, text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex,
        --channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidFlags
        local text, player, _, _, _, _, _, _, _, _, lineID = ...
        if not text or not player or not lineID then return end
        debug(text, player, lineID, last.message:gsub("\124", "/"))


        if last.message:find("\124Hplayer:" .. player:gsub("%-", "%%-") .. ":" .. lineID .. ":") then

            if event == "CHAT_MSG_GUILD" then
                if not player_lasts[player] then return end

                --比较是否最近只发过一条，多了对不上
                local t1 = player_times[player]
                local t2 = player_times2[player] or 0
                if not (t1 > GetTime() - GUILD_MAX_DELAY_TIME and t2 < t1 - (GetTime() - t1) - GUILD_MIN_INTERVAL) then
                    player_lasts[player] = nil
                    return
                end

                -- 比较文本是否符合
                local pattern = transformFilteredToPattern(text)
                if not player_lasts[player]:match(pattern) then
                    player_lasts[player] = nil
                    return
                end
            end

            local len = select("#", ...) + 2

            local packed
            if event == "CHAT_MSG_GUILD" then
                packed = tmp_packed
            else
                frame_lasts[f] = frame_lasts[f] or {} --no need to wipe
                frame_lens[f] = len
                packed = frame_lasts[f]
            end

            packed[1] = last
            packed[2] = event
            for i = 3, len do
                packed[i] = select(i - 2, ...)
            end

            if event == "CHAT_MSG_GUILD" then
                ReplaceLastMessage(f, player_lasts[player], packed, len)
            end
        end
    end
end

local ADDON_MSG = function(event, prefix, msg, ...)
    if prefix ~= "ABYCN" then return end
    debug(GetTime(), msg, ...)

    --prefix, text, channel, sender, target, zoneChannelID, localID, name, instanceID
    local channel, sender = ...

    --公会消息晚于ADDON_MSG，我们的逻辑是N秒内只有一条的时候才触发过滤，防止对应错误
    if channel == "GUILD" then
        player_times2[sender] = player_times[sender]
        player_times[sender] = GetTime()
        player_lasts[sender] = msg
        return
    end

    for f, v in pairs(frame_lasts) do
        if frame_lens[f] > 0 then
            if v[4] == sender and v[3] ~= msg and channel == msg_types[v[2]] then
                ReplaceLastMessage(f, msg, v, frame_lens[f])
            end
        end
    end
end

C_ChatInfo.RegisterAddonMessagePrefix("ABYCN")
hooksecurefunc("SendChatMessage", function(msg, type, lang, target, ...)
    if chat_types[type] then
        C_ChatInfo.SendAddonMessage("ABYCN", msg, type, target)
    end
end)
hooksecurefunc("ChatFrame_MessageEventHandler", HookMsgHandler)
local ef = CreateFrame("Frame")
ef:RegisterEvent("CHAT_MSG_ADDON")
ef:SetScript("OnEvent", function(self, ...) ADDON_MSG(...) end)