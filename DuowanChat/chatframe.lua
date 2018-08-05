local DWChat = LibStub('AceAddon-3.0'):GetAddon('DuowanChat')
local L = LibStub("AceLocale-3.0"):GetLocale("DuowanChat")
local MODNAME = "CHATFRAME" 
local DWChatFrame = DWChat:NewModule(MODNAME, "AceEvent-3.0") 
local DWC_NUM_TAB=7
local chatchannelframe={} 
local buttonTemplate 
local db 
local prvBtn
local defaults = { 
	profile = { 
		enablechatchannel=false, 
		enablechatchannelmove=false 
	} 
}

local function GetChannelNameWithCommunity(index)
    local channelNum, channelName = GetChannelName(index);
    if channelNum == 0 then return channelNum, channelName end
    if channelName then
        local _, _, clubId = channelName:find("Community:(%d+)")
        if clubId then
            local info = C_Club.GetClubInfo(tonumber(clubId))
            return info and channelNum or 0, info and info.name
        else
            return channelNum, channelName
        end
    end
end

local function DWC_ChannelShortText(index)
	local channelNum, channelName = GetChannelNameWithCommunity(index);

	if (channelNum ~= 0) then
		if (strfind(channelName, L["General"])) then
			return L["GeneralShort"], channelName;
		elseif (strfind(channelName, L["Trade"])) then
			return L["TradeShort"], channelName;
		elseif (strfind(channelName, L["LFG"])) then
			return L["ShortLFG"], channelName;
		elseif (strfind(channelName, L["GuildRecruit"])) then
			return L["GuildRecruitShort"], channelName;
		elseif (strfind(channelName, L["BigFootChannel"])) then
			return L["BigFootShort"], "世界频道";
		elseif (strfind(channelName, "LFGForwarder")) then
			return L["DWLFG"], "转发的寻求组队消息";
		elseif (strfind(channelName, "TCForwarder")) then--11
			return L["DWLFG"], "转发的交易消息";
		else
			return string.utf8sub(channelName, 1, 1), channelName;	-- strsub(channelName,1,3);
		end
	end
end
local short = DWC_ChannelShortText;

local function DWC_ShowChannel(index)
	local channelNum, channelName = GetChannelNameWithCommunity(index);
	if (channelNum ~= 0 and (not (strfind(channelName, L["LocalDefense"]) or strfind(channelName, "^QuestHelperLite"))) and not strfind(channelName, "LFGForwarder") and not strfind(channelName, "TCForwarder") ) then
		return true;
	end	
	--[[
	if (channelNum ~= 0 and (strfind(channelName, L["General"]) or strfind(channelName, L["Trade"]) or strfind(channelName, L["LFG"]))) then
		return true;
	else
		return false;
	end
	]]
end

local function DWC_ShowChannel_Gen(index)
    return function() return DWC_ShowChannel(index) end
end

local DWC_TABS={ 
	{text=function() return short(1) end, chatType="CHANNEL1", show=DWC_ShowChannel_Gen(1), index=1}, 
	{text=function() return short(2) end, chatType="CHANNEL2", show=DWC_ShowChannel_Gen(2), index=2}, 
	{text=function() return short(3) end, chatType="CHANNEL3", show=DWC_ShowChannel_Gen(3), index=3}, 
	{text=function() return short(4) end, chatType="CHANNEL4", show=DWC_ShowChannel_Gen(4), index=4}, 
	{text=function() return short(5) end, chatType="CHANNEL5", show=DWC_ShowChannel_Gen(5), index=5}, 
	{text=function() return short(6) end, chatType="CHANNEL6", show=DWC_ShowChannel_Gen(6), index=6}, 
	{text=function() return short(7) end, chatType="CHANNEL7", show=DWC_ShowChannel_Gen(7), index=7}, 
	{text=function() return short(8) end, chatType="CHANNEL8", show=DWC_ShowChannel_Gen(8), index=8}, 
	{text=function() return short(9) end, chatType="CHANNEL9", show=DWC_ShowChannel_Gen(9), index=9}, 
	{text=function() return short(10) end, chatType="CHANNEL10", show=DWC_ShowChannel_Gen(10), index=10}, 
	{text=function() return L["Say"] end, chatType="SAY", show=function() return true end,  index=0}, 
	{text=function() return L["PartyShort"] end, chatType="PARTY", show=function() return IsInGroup() end, index=0},
	{text=function() return L["RaidShort"] end, chatType="RAID", show=function() return IsInRaid() end,  index=0},
    {text=function() return L["InstanceShort"] end, chatType="INSTANCE_CHAT", chatTypeCmd='instance', show=function() return IsInInstance() end, index = 0},
	{text=function() return L["BattleGroundShort"] end, chatType="INSTANCE_CHAT", chatTypeCmd='instance', show=function() return select(2, IsInInstance())=="pvp" end,  index=0},
	{text=function() return L["GuildShort"] end, chatType="GUILD", show=function() return IsInGuild() end,  index=0},
	{text=function() return L["YellShort"] end, chatType="YELL", show=function() return not IsInGroup() --[[GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0]] end,  index=0},
	{text=function() return L["WhisperToShort"] end, chatType="WHISPER", show=function() return true end,  index=0},
	{text=function() return L["OfficerShort"] end, chatType="OFFICER", show=function() return CanEditOfficerNote() end,  index=0}, 
} 


local optGetter, optSetter 
do 
	local mod = DWChatFrame 
	function optGetter(info)
		local key = info[#info] 
		return db[key] 
	end 
	function optSetter(info, value)
		local key = info[#info] db[key] = value 
		mod:Refresh() 
	end 
end

local options 
local getOptions=function() 
	if not options then 
		options={
			type = "group", 
			name = L["ChatFrame"], 
			arg = MODNAME, 
			get = optGetter, 
			set = optSetter, 
			args = {
				intro = { 
					order = 1, 
					type = "description", 
					name = L["Fast chat channel provides you easy access to different channels"], 
				}, 
				enablechatchannel = { 
					order = 2, 
					type = "toggle", 
					name = L["Enable channel buttons"],
					get = function() 
						return DWChat:GetModuleEnabled(MODNAME) 
					end, 
					set = function(info, value) 
						DWChat:SetModuleEnabled(MODNAME, value) 
					end,
					width = full,
				}, 
			},
		}
	end
	return options
end 

local chat_fmt = '/%s %s'
function DWC_SetChatType(chatType, index) 
    local editBox = ChatEdit_ChooseBoxForSend()
    local text_in_box = editBox:IsShown() and editBox:GetText() or ''
    -- replace `/t` or `/w` without target name
    text_in_box = text_in_box:gsub('^/[wWtT]\032?', '') 

    local channel = chatType:match'CHANNEL(%d+)'
    if(channel and tonumber(channel)) then
        return ChatFrame_OpenChat(chat_fmt:format(channel, text_in_box))
    end

    --	local chatFrame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;
    --	local text = "";
    --	if (string.find(chatType, "CHANNEL")) then
    --		chatFrame.editBox:Show();
    --		if (chatFrame.editBox:GetAttribute("chatType") == "CHANNEL") and (chatFrame.editBox:GetAttribute("channelTarget") == index) then
    --			ChatFrame_OpenChat("", chatFrame);
    --		else
    --			chatFrame.editBox:SetAttribute("chatType", "CHANNEL");
    --			chatFrame.editBox:SetAttribute("channelTarget", index);
    --			ChatEdit_UpdateHeader(chatFrame.editBox);
    --		end
    --	else

    if(chatType == 'WHISPER') then
        local lastTell = ChatEdit_GetLastTellTarget()
        if(lastTell == '') then lastTell = false end

        if(not lastTell) then
            if(UnitExists'target' and UnitIsFriend('target', 'player') and UnitIsPlayer'target') then
                local name, realm = UnitName'target'
                if(realm and realm ~= GetRealmName()) then
                    name = string.format('%s-%s', name, realm)
                end
                lastTell = name
            end
        end

        if(lastTell) then
            local cmd = string.format('w %s', lastTell)
            return ChatFrame_OpenChat(chat_fmt:format(cmd, text_in_box))
        else
            return ChatFrame_OpenChat(chat_fmt:format('s', text_in_box))
        end
        return
    end

    return ChatFrame_OpenChat(chat_fmt:format(chatType, text_in_box))

--    if (chatType == "WHISPER") then
--        text = "";
--        ChatFrame_ReplyTell(chatFrame);
--        if (UnitExists("target") and UnitIsFriend("target", "player") and UnitIsPlayer("target")) then
--            text = "/w " .. UnitName("target").." ";
--        end
--
--        ChatFrame_OpenChat(text)
--    else
--        if (not chatFrame.editBox:IsVisible()) then
--            ChatFrame_OpenChat("", chatFrame);
--        end
--        -- ChatFrame_OpenChat("", chatFrame);
--        text = chatFrame.editBox:GetText();
--        text = string.gsub(text, "^/[Ww] ", "");		
--        chatFrame.editBox:SetText(text);
--        chatFrame.editBox:SetAttribute("chatType", chatType);
--        ChatEdit_UpdateHeader(chatFrame.editBox);
--    end
    --end
    --chatFrame.editBox:SetFocus();
end 

local function createChatTab(texfunc, chatType, showfunc, index, id)
	local chatTab=_G["DWCChatTab"..id] 
	if not chatTab then 
		chatTab=CreateFrame("Button","DWCChatTab"..id,UIParent,"DWCChatTabTemplate") 		
		CoreUIEnableTooltip(chatTab)
	end
	chatTab.chatType = chatType 		
	chatTab.text, chatTab.tooltipText = texfunc()
	chatTab.index = index
	_G[chatTab:GetName().."Text"]:SetText(chatTab.text) 
	if (showfunc()) then
		if (not prvBtn) then
			chatTab:SetPoint("LEFT",_G.DWCIconFrameCalloutButton,"RIGHT",1,0) 
		else 
			chatTab:SetPoint("LEFT",prvBtn,"RIGHT",1,0) 
		end 
		prvBtn = chatTab
		chatTab:Show()
		return chatTab 
	else
		chatTab:Hide()
		return false
	end	
end

function DWChatFrame:OnInitialize() 
	self.db = DWChat.db:RegisterNamespace(MODNAME, defaults);
	db = self.db.profile;
	self:SetEnabledState(DWChat:GetModuleEnabled(MODNAME));
	DWChat:RegisterModuleOptions(MODNAME, getOptions, L["ChatFrame"]);
	CoreUIEnableTooltip(DWCReportStatButton, "发送属性报告", "左键简略，右键详细");
	CoreUIEnableTooltip(DWCRandomButton, "掷骰子");
end

function DWChatFrame:Refresh() 
	table.wipe(chatchannelframe)
	prvBtn = nil;
	for i, v in ipairs(DWC_TABS) do		
		local tab = createChatTab( v.text, v.chatType, v.show, v.index, i);
		if (tab) then
            tab.chatTypeCmd = v.chatTypeCmd
			tinsert(chatchannelframe, tab);
		end
	end

	DWCReportStatButton:ClearAllPoints();
	DWCReportStatButton:SetPoint("LEFT", prvBtn,"RIGHT",1,0);
	DWCRandomButton:ClearAllPoints();
	DWCRandomButton:SetPoint("LEFT", DWCReportStatButton,"RIGHT",1,0);
end

function DWCReportStatButton_OnClick(self, button)
	local DuowanStat = DWChat:GetModule("DUOWANSTAT");
	if (button == "LeftButton") then
		DuowanStat:InsertStat();
	else
		DuowanStat:InsertStat(1);
	end	
end

function DWChatFrame:UpdateChatBar(event)
	self:Refresh() 
end

local hooked = false
local refreshing
function DWC_RefreshPosition()
    if not hooked then
        --hooksecurefunc(DWCChatFrame, "SetPoint", function() if not refreshing then DWC_RefreshPosition() end end)
        --hooksecurefunc(DWCChatFrame, "StopMovingOrSizing", function() DWC_RefreshPosition() end)
        hooksecurefunc(ChatFrame1EditBox, "SetPoint", function() if not refreshing then DWC_RefreshPosition() end end)
        hooked = true
    end
    refreshing = true
    --[[local xo, yo = -5, -2
    if DWCChatFrame:IsShown() then
        local _, rel = DWCChatFrame:GetPoint()
        if rel and rel~=UIParent then
            xo, yo = xo-28, yo-28
        end
    end
	for i=1, 10 do
		local point,rel,relp,x=_G["ChatFrame"..i.."EditBox"]:GetPoint()
        if point == "TOPLEFT" then
		    _G["ChatFrame"..i.."EditBox"]:SetPoint(point,rel,relp,x,yo)
        end
    end]]
    DuowanChat:Refresh()
    refreshing = nil
end
function DWChatFrame:OnEnable()
	self:Refresh()
	self:RegisterEvent("CHANNEL_UI_UPDATE", "UpdateChatBar");
    self:RegisterEvent("INITIAL_CLUBS_LOADED", "UpdateChatBar");
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", "UpdateChatBar");
    self:RegisterEvent("PLAYER_GUILD_UPDATE", "UpdateChatBar");
    self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateChatBar");
	DWCChatFrame:Show()
    DWCIconFrameCalloutButton:Show()
    DuowanStat_Toggle(true)
    DWC_RefreshPosition()
end

function DWChatFrame:OnDisable()
	self:UnregisterEvent("UPDATE_WORLD_STATES");
	self:UnregisterEvent("CHAT_MSG_CHANNEL_NOTICE");
	self:UnregisterEvent("PLAYER_GUILD_UPDATE");
	for k, v in pairs(chatchannelframe) do
		 v:ClearAllPoints() 
		 v:Hide()
    end
    DWCChatFrame:Hide()
	DWCIconFrameCalloutButton:Hide()
    DuowanStat_Toggle(false)
    DWC_RefreshPosition()
end
