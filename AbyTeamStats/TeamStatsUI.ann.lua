local _, TS = ...
local L = TS.L

local function TSFrame()
    return _G[TS.FRAME_NAME]
end

--信息广播
--【爱不易：团员信息统计】 - 总览：
--★桂花猫猫 圣骑 装等:896.3 橙装:肩,手 引领:萨,海 秘境:174 15层:10天 M翡翠:2/7 H勇气:3/3 暗夜:10/10 H暗夜:9/10
local annLine = {}
local function GetPlayerAnnText(name)
    local tab = TS.TABS[TS.Frame().tabIdx]
    table.wipe(annLine);
    local player = TS.db.players[name]
    if player and player.selected and (player.gsGot or player.compared) then
        tinsert(annLine, "★");
        tinsert(annLine, player.name);
        if TS.Frame().tabIdx == 1 then
            tinsert(annLine, " ");
            tinsert(annLine, player.talent1);
            tinsert(annLine, " ");
            tinsert(annLine, "装等")
            tinsert(annLine, player.gsGot and player.bad and "*" or "")
            tinsert(annLine, player.gsGot and player.gs or "未知")
            tinsert(annLine, " 大秘评分")
            tinsert(annLine, player.mscore or "未知")
            --tinsert(annLine, " 腐蚀")
            --local corrupt = tostring(math.max(0, (player.c_total or 0) - (player.c_resist or 0) - 10))
            --tinsert(annLine, player.c_total and corrupt or "未知")
            --tinsert(annLine, " ");
            --tinsert(annLine, "橙装:")
            --local slot1, link1, slot2, link2 = strsplit("^", player.legends or "")
            --tinsert(annLine, slot1 and slot1~="" and slot1 or "无")
            --tinsert(annLine, slot2 and "," .. slot2 or "")
        end

        if tab.special == "season_mythic" then
            for i, id in ipairs(tab.specialIDs) do
                if id == 0 then
                    tinsert(annLine, " 大秘评分"..player.mscore)
                else
                    local data = TS.temp_data[name]
                    data = data and data["mythic"]
                    if data and data[id] then
                        tinsert(annLine, " ")
                        local score = data[id]:gsub("^%|c%x%x%x%x%x%x%x%x(%d+)%|r.*$", "%1")
                        tinsert(annLine, tab.names[i]..score)
                    end
                end
            end
        end

        if(player.compared) then
            --[[
            local VBOSSES = TS.VERSION_BOSSES
            local first = true
            for i=1,#VBOSSES,2 do
                local text = TeamStatsUI_GetAchievementOrStaticText(player, VBOSSES[i])
                if text ~= "?" and text ~= "-" then
                    if first then
                        tinsert(annLine, " 引领:"..VBOSSES[i+1])
                        first = false
                    else
                        tinsert(annLine, ","..VBOSSES[i+1])
                    end
                end
            end
            --]]
            for i, ids in ipairs(tab.ids or {}) do
                if tab.reports == nil or tab.reports[i] then
                    if type(ids) == "table" then
                        local progress, max, total = TeamStatsUI_GetAchievementOrStaticText(player, ids)
                        if progress and progress ~= 0 then
                            tinsert(annLine, " ");
                            tinsert(annLine, tab.names[i])
                            tinsert(annLine, tab.any_done and "★" or "" .. progress .. "/" .. max)
                        end
                    else
                        local text = TeamStatsUI_GetAchievementOrStaticText(player, ids)
                        if text ~= "?" and text ~= "-" then
                            tinsert(annLine, " ");
                            tinsert(annLine, tab.names[i])
                            tinsert(annLine, "")
                            tinsert(annLine, text)
                        end
                    end
                end
            end
        else
            tinsert(annLine, "");
        end
        return table.concat(annLine, "")
    end
end

StaticPopupDialogs["TEAMSTATS_ANN"] = {preferredIndex = 3,
    text = L["BtnAnnPopupText"],
    button1 = YES,
    button2 = CANCEL,
    OnAccept = function(self)
       local tab = TS.TABS[TS.Frame().tabIdx]
       SendChatMessage("【爱不易：团员信息统计】 - "..tab.tab.."：", self.data[1], nil, self.data[2]);
       for i=1,#TS.ui_names do
           local line = GetPlayerAnnText(TS.ui_names[i])
           if line then
               SendChatMessage(line, self.data[1], nil, self.data[2]);
           end
       end
    end,
    timeout = 0,
    hideOnEscape = 1,
    whileDead = 1,
    exclusive = 1,
}

function TeamStatsUI_BtnAnnOnClick(self)
    local count = 0
    for i=1,#TS.ui_names do
        local player = TS.db.players[TS.ui_names[i]]
        if player and player.selected then count=count+1 end
    end
    if(count==0) then message(L["BtnAnnNoSelect"]); return; end
    -- local channel = GetNumRaidMembers()>0 and "RAID" or GetNumPartyMembers()>0 and "PARTY" or "SAY";
    local channel, target = 'SAY', nil
    if(IsInGroup()) then
        if(IsInRaid()) then
            channel = 'RAID'
        else
            channel = 'PARTY'
        end
    end

    --只选中一个的时候复制到输入框，打开聊天输入框时，使用相关的方式
    if count == 1 then
        for i=1,#TS.ui_names do
            local line = GetPlayerAnnText(TS.ui_names[i])
            if line then
                CoreUIChatEdit_Insert(line)
                return
            end
        end
    else
        local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
        local eb = chatFrame and chatFrame.editBox
        local chatType = eb:GetAttribute("chatType")
        if (chatType == "RAID" or chatType == "PARTY" or chatType == "SAY" or chatType == "INSTANCE") then
            channel = chatType
        elseif chatType == "WHISPER" then
            target = eb:GetAttribute("tellTarget")
            if target and target ~= "" then channel = chatType end
        elseif chatType == "CHANNEL" then
            target = eb:GetAttribute("channelTarget")
            if target and target ~= "" then channel = chatType end
        end
    end
    local channelName = channel=="RAID" and "团队" or channel=="PARTY" and "小队" or channel=="INSTANCE" and "副本" or channel=="WHISPER" and "密语:%s" or channel=="CHANNEL" and "频道:%s" or "说";
    StaticPopup_Show("TEAMSTATS_ANN", count, format(channelName, target), {channel, target});
end