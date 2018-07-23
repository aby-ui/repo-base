function ChatEdit_CustomTabPressed(...)
    return ChatEdit_CustomTabPressed_Inner(...);
end
local cycles = {
    {
        chatType = "SAY",
        use = function(self, editbox) return 1 end,
    },
    {
        chatType = "YELL",
        use = function(self, editbox) return 1 end,
    },
    {
        chatType = "PARTY",
        use = function(self, editbox) return IsInGroup() end,
    },
    {
        chatType = "RAID",
        use = function(self, editbox) return IsInRaid() end,
    },
    {
        chatType = "INSTANCE_CHAT",
        use = function(self, editbox) return select(2, IsInInstance()) == 'pvp' end,
    },
    {
        chatType = "GUILD",
        use = function(self, editbox) return IsInGuild() end,
    },
    {
        chatType = "CHANNEL",
        use = function(self, editbox, currChatType)
            if U1GetCfgValue and U1GetCfgValue("163ui_chat", "customtab/tabchannel") then
                local currNum
                if currChatType~="CHANNEL" then
                    currNum = IsShiftKeyDown() and 21 or 0
                else
                    currNum = editbox:GetAttribute("channelTarget");
                end
                local h, r, step = currNum+1, 20, 1
                if IsShiftKeyDown() then h, r, step = currNum-1, 1, -1 end
                for i=h,r,step do
                    local channelNum, channelName = GetChannelName(i);
                    if channelNum > 0 and not channelName:find("本地防务 %-") then
                        editbox:SetAttribute("channelTarget", i);
                        return true;
                    end
                end
            end
        end,
    },
    {
        chatType = "SAY",
        use = function(self, editbox) return 1 end,
    },

}

local lastTabTime, lastChatType, lastTellTarget --记录上次的A tab B tab 处理，此时B是curr，A是last，记录A为lastChatType or lastWhisperType

local chatTypeBeforeSwitch, tellTargetBeforeSwitch --记录在频道和密语之间切换时的状态

function ChatEdit_CustomTabPressed_Inner(self)
    if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
    local currChatType = self:GetAttribute("chatType")

    --[[ --双击切换，误操作太多
    local now = GetTime()
    if(lastTabTime and now - lastTabTime <= 0.2) then
        if ( currChatType == "WHISPER" or currChatType == "BN_WHISPER" ) then
            --记录之前的密语对象，以便后续切回
            self:SetAttribute("chatType", chatTypeBeforeSwitch or "SAY");
            ChatEdit_UpdateHeader(self);
            chatTypeBeforeSwitch = lastChatType
            tellTargetBeforeSwitch = lastTellTarget
            U1Message("双击了TAB，聊天切换至频道")
            return
        else
            local newTarget, newTargetType = ChatEdit_GetNextTellTarget()
            if tellTargetBeforeSwitch or (newTarget and newTarget~="") then
                self:SetAttribute("chatType", tellTargetBeforeSwitch and chatTypeBeforeSwitch or newTargetType);
                self:SetAttribute("tellTarget", tellTargetBeforeSwitch or newTarget);
                ChatEdit_UpdateHeader(self);
                chatTypeBeforeSwitch = lastChatType
                tellTargetBeforeSwitch = nil
                U1Message("双击了TAB，聊天切换至密语")
                return true
            end
        end
    end
    lastChatType = currChatType
    lastTellTarget = self:GetAttribute("tellTarget")
    lastTabTime = now
    --]]

    if (IsControlKeyDown()) then
        if ( currChatType == "WHISPER" or currChatType == "BN_WHISPER" ) then
            --记录之前的密语对象，以便后续切回
            self:SetAttribute("chatType", chatTypeBeforeSwitch or "SAY");
            ChatEdit_UpdateHeader(self);
            chatTypeBeforeSwitch = currChatType
            tellTargetBeforeSwitch = self:GetAttribute("tellTarget")
            return  --这里和下面不同，这里可以不返回true
        else
            local newTarget, newTargetType = ChatEdit_GetNextTellTarget()
            if tellTargetBeforeSwitch or (newTarget and newTarget~="") then
                self:SetAttribute("chatType", tellTargetBeforeSwitch and chatTypeBeforeSwitch or newTargetType);
                self:SetAttribute("tellTarget", tellTargetBeforeSwitch or newTarget);
                ChatEdit_UpdateHeader(self);
                chatTypeBeforeSwitch = currChatType
                tellTargetBeforeSwitch = nil
                return true --这里必须返回true，否则会被暴雪默认的再切换一次密语对象
            end
        end
    end

    --对于说然后SHIFT的情况，因为没有return，所以第一层循环会一直遍历到最后的SAY
    for i, curr in ipairs(cycles) do
        if curr.chatType== currChatType then
            local h, r, step = i+1, #cycles, 1
            if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
            if currChatType=="CHANNEL" then h = i end --频道仍然要测试一下
            for j=h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute("chatType", cycles[j].chatType);
                    ChatEdit_UpdateHeader(self);
                    return;
                end
            end
        end
    end
end

function U1Chat_SetChatType(chatType, index)
    local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
	local text = "";
	if (string.find(chatType, "CHANNEL")) then
		chatFrame.editBox:Show();
		if (chatFrame.editBox:GetAttribute("chatType") == "CHANNEL") and (chatFrame.editBox:GetAttribute("channelTarget") == index) then
			ChatFrame_OpenChat("", chatFrame);
		else
			chatFrame.editBox:SetAttribute("chatType", "CHANNEL");
			chatFrame.editBox:SetAttribute("channelTarget", index);
			ChatEdit_UpdateHeader(chatFrame.editBox);
		end
	else
		if (chatType == "WHISPER") then
			text = "";
			ChatFrame_ReplyTell(chatFrame);
			if (UnitExists("target") and UnitIsFriend("target", "player") and UnitIsPlayer("target")) then
				text = text .. UnitName("target").." ";
			end

			ChatFrame_OpenChat(text, chatFrame);
		else
			if (not chatFrame.editBox:IsVisible()) then
				ChatFrame_OpenChat("", chatFrame);
			end
			-- ChatFrame_OpenChat("", chatFrame);
			text = chatFrame.editBox:GetText();
			text = string.gsub(text, "^/[Ww] ", "");
			chatFrame.editBox:SetText(text);
			chatFrame.editBox:SetAttribute("chatType", chatType);
			ChatEdit_UpdateHeader(chatFrame.editBox);
		end
	end
	chatFrame.editBox:SetFocus();
end
