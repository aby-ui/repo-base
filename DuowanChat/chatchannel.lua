local DWChat = LibStub('AceAddon-3.0'):GetAddon('DuowanChat')
local L = LibStub("AceLocale-3.0"):GetLocale("DuowanChat")
local MODNAME = "CHATCHANNEL";
local ChatChannel = DWChat:NewModule(MODNAME, "AceEvent-3.0", "AceHook-3.0")
local org_FCF_Close;
local db;
local defaults = {
	profile = {
		enablechatchannel=false,
	},
} 
local TABTYPE_CHATCHANNEL = L["Chat Channel"];
ChannelType={
	[TABTYPE_CHATCHANNEL]={
		"WHISPER",
		"GUILD",
		"GUILD_OFFICER",
		"GUILD_ACHIEVEMENT",		
		"RAID",
		"RAID_LEADER",
		"RAID_WARNING",
		"BATTLEGROUND",
		"BATTLEGROUND_LEADER",
		"PARTY",
		"PARTY_LEADER", 
		"BG_HORDE",
		"BG_ALLIANCE",
		"BG_NEUTRAL",
		"SAY",
		"YELL",
		"BN_WHISPER"
	},
};	


function ChatChannel:OnInitialize() 
	org_FCF_Close = FCF_Close;
	self.db = DWChat.db:RegisterNamespace(MODNAME, defaults) 
	db = self.db.profile 
	self:SetEnabledState(DWChat:GetModuleEnabled(MODNAME)) 
end

local function ChatFrame_FindPage(pageID)
	local curFrame,curTab,tmp,i;
	for i=1,NUM_CHAT_WINDOWS+1 do
		tmp =  _G["ChatFrame"..i];
		if(tmp)then
			if(pageID == _G["ChatFrame"..i.."Tab"]:GetText())then
				curTab = getglobal("ChatFrame"..i.."Tab");
				curFrame = getglobal("ChatFrame"..i);
				break;
			end
		end
	end
	return curFrame, curTab, i;
end

function ChatChannel:CloseChat(pageID)
	local chatFrame, curTab = ChatFrame_FindPage(pageID);
	if(not chatFrame)then
		return;
	end
	
	FCF_Close(chatFrame);
end


local function FlashChannel(chatFrame, event, message, ...)
	local tab = getglobal(chatFrame:GetName().."Tab");
	local channelid;
	channelid = ChannelType[tab:GetText()];
	if(channelid)then
		chatFrame.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME; --tellTimer is only to control a PlaySound163("TellMessage");
		FCF_FlashTab(chatFrame); --调用了Flash
	end
end

function ChatChannel:CreateChat(chatType)
	local v,aa,bb,cc,xx,yy,tname,curFrame,curTab,i;	
	curFrame, curTab, i = ChatFrame_FindPage(chatType);
	if(curFrame and curTab)then
		FCF_Close(curFrame);		
		curFrame=nil;
		curTab=nil;
	end
	if(not ChatFrame1)then
		return;
	end
	
	FCF_OpenNewWindow(chatType);
	curFrame, curTab = ChatFrame_FindPage(chatType);		
	if(not curFrame)then 
		return; 
	end
	
	FCF_DockUpdate();

	curFrame:SetClampedToScreen(true);
	curTab:SetClampedToScreen(true);

	ChatFrame_RemoveAllMessageGroups(curFrame);
	ChatFrame_RemoveAllChannels(curFrame);
	ChatFrame_ReceiveAllPrivateMessages(curFrame);
	--ChatFrame_ReceiveAllBNConversations(curFrame);

	for _, t in pairs(ChannelType[chatType]) do
		ChatFrame_AddMessageGroup(curFrame, t);
		if (ChatTypeGroup[t] and type(ChatTypeGroup[t]) == "table") then
            --也许能防止污染
			--for _, tname in pairs(ChatTypeGroup[t]) do
			--	ChatFrame_AddMessageEventFilter(tname, FlashChannel);
			--end
		end
	end
	FCF_DockFrame(curFrame, FCF_GetNumActiveChatFrames(), true);
	FCF_SelectDockFrame(ChatFrame1);
end

function ChatChannel:SetPage(pageID, show)
	if (pageID == TABTYPE_CHATCHANNEL) then
		show = show or db.enablechatchannel;
	end
	if(show)then
		self:CreateChat(pageID);
	else
		self:CloseChat(pageID);
	end	
end

function ChatChannel:FCF_ResetChatWindows(...)
	if(db.enablechatchannel)then
		self:CreateChat(TABTYPE_CHATCHANNEL);
	end
end

function ChatChannel:FCF_Close(frame, callback)	
	local channelid, tab, curFrame;
	
	if(callback)then
		tab = getglobal(callback:GetName().."Tab");
		if (ChannelType[tab:GetText()]) then
			curFrame = ChatFrame_FindPage(tab:GetText());
			if(curFrame)then
				return;
			end
		end		
	end

	if(frame)then
		tab = getglobal(frame:GetName().."Tab");
		if(tab)then			
			self.hooks.FCF_Close(frame, callback);			
			return;
		end
	end
	self.hooks.FCF_Close(frame,callback);		
end

function ChatChannel:PLAYER_ENTERING_WORLD()
	self:SetPage(TABTYPE_CHATCHANNEL);
end

function ChatChannel:FCF_FadeInChatFrame(chatFrame)
	chatFrame.oldAlpha = chatFrame.oldAlpha or DEFAULT_CHATFRAME_ALPHA;
	self.hooks.FCF_FadeInChatFrame(chatFrame);
end

function ChatChannel:OnEnable()
    if not self._SetByOption then return end self._SetByOption = nil;
	--self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:SecureHook("FCF_ResetChatWindows");
	self:RawHook("FCF_Close", true);
	self:RawHook("FCF_FadeInChatFrame", true);
	self:CreateChat(TABTYPE_CHATCHANNEL);
end

function ChatChannel:OnDisable()
	--self:UnregisterEvent("PLAYER_ENTERING_WORLD");
	self:Unhook("FCF_ResetChatWindows");
	self:Unhook("FCF_Close");		
	self:Unhook("FCF_FadeInChatFrame");
	self:CloseChat(TABTYPE_CHATCHANNEL);
end