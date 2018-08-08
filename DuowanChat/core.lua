
-- TODO
-- use realm based player database

local L = LibStub('AceLocale-3.0'):GetLocale('DuowanChat') 
DuowanChat = LibStub('AceAddon-3.0'):NewAddon('DuowanChat', 'AceEvent-3.0', 'AceHook-3.0', 'AceConsole-3.0', 'AceTimer-3.0') 
DuowanChat._DEBUG = true
DuowanChat.cbuttons = {};
DuowanChat.lines = {};
local raidRosters = {}; DuowanChat.raidRosters = raidRosters --保存小队ID


local SCCN_Chan_Replace= {
    [L["Guild"]]=L["GuildShort"],
    [L["Raid"]]=L["RaidShort"], 
    [L["Party"]]=L["PartyShort"],
    [L["Yell"]]=L["YellShort"], 
    [L["BattleGround"]]=L["BattleGroundShort"], 
    [L["General"]]=L["GeneralShort"],
    [L["Trade"]]=L["TradeShort"],
    [L["LFG"]] = L["ShortLFG"],
    [L["BigFootChannel"]]=L["BigFootShort"],
    [L["WorldChannel"]]=L["BigFootShort"],
    ["世界"]=L["BigFootShort"],
    [L["WorldDefense"]]=L["WorldDefenseShort"],
    [L["WhisperTo"]]=L["WhisperToShort"], 
    [L["WhisperFrom"]]=L["WhisperFromShort"], 
} 

local DWC_ColorTable = {}
for cls, c in next, RAID_CLASS_COLORS do
    DWC_ColorTable[cls] = string.format('cff%02x%02x%02x',
    c.r * 255,
    c.g * 255,
    c.b * 255)
end

local DWC_FILENAME = {}
for e, l in next, LOCALIZED_CLASS_NAMES_MALE do
    DWC_FILENAME[l] = e
end
for e, l in next, LOCALIZED_CLASS_NAMES_FEMALE do
    DWC_FILENAME[l] = e
end

local db, player_db
local defaults = { 
    profile = {
        --enabletimestamp = false, 
        --enableclasscolor = true,
        enablelevel = true,
        enablesubgroup = true,
        useshortname =true,
        enablecopy = false, 
        enablechatchannelmove=false,
        userPlaced = false,
        mute = false,
        modules = {
            ["ICONFRAME"] = true, 
            ["CHATFRAME"] = true, 
            ["CHATCHANNEL"] = true,
        }, 
    } 
}

local events={
    ["CHAT_MSG_YELL"]=true, 
    ["CHAT_MSG_WHISPER"]=true, 
    ["CHAT_MSG_WHISPER_INFORM"]=true,
    ["CHAT_MSG_AFK"]=true,
    ["CHAT_MSG_DND"]=true,
    --["CHAT_MSG_BN_WHISPER"]=true, 
    --["CHAT_MSG_BN_WHISPER_INFORM"]=true,	
    ["CHAT_MSG_SAY"]=true,
    ["CHAT_MSG_RAID_LEADER"]=true,
    ["CHAT_MSG_RAID"]=true,
    ["CHAT_MSG_RAID_WARNING"]=true, 
    ["CHAT_MSG_PARTY"]=true,
    ["CHAT_MSG_PARTY_LEADER"]=true,
    ["CHAT_MSG_MONSTER_PARTY"]=true,
    ["CHAT_MSG_GUILD"]=true,
    ["CHAT_MSG_CHANNEL"]=true, 
    ["CHAT_MSG_BATTLEGROUND"]=true,
    ["CHAT_MSG_OFFICER"]=true, 
}

-- local DWC_IconTableMap={}
-- local DWC_ReverseIconTableMap={} 
-- local function generateIconMap() 
--     for k,v in pairs(DWC_IconTable) do
--         DWC_IconTableMap[v[1]]=v[2]
--     end
--     for k,v in pairs(DWC_IconTable) do
--         DWC_ReverseIconTableMap[v[2]]=v[1] 
--     end
-- end 

function DuowanChat:debug(msg, ...)
    if (self._DEBUG) then
        print(format(msg, ...));
    end
end

-----------------------
-- 大脚世界频道
local leaveChannelFunc = SlashCmdList["LEAVE"]

local joinChannelFunc = function(channel)
    local channelId = JoinTemporaryChannel(channel)
    if channelId == nil then return false end

    local worldChannels = db.worldChannels
    --检查所有窗口看看是否有一个加入了世界频道
    local joinOne = false
    for index = 1, NUM_CHAT_WINDOWS do
        local shown, locked, docked = select(7, GetChatWindowInfo(index))
        local chatFrame = _G["ChatFrame"..index]
        if chatFrame and (shown or docked) then
            --print(index, shown, locked, docked)
            if worldChannels and worldChannels[_G[chatFrame:GetName().."Tab"]:GetText()] then
                ChatFrame_RemoveChannel(chatFrame, L["BigFootChannel"])
                ChatFrame_AddChannel(chatFrame, L["BigFootChannel"])
                joinOne = true
            end
        end
    end

    if not joinOne then
        ChatFrame_RemoveChannel(DEFAULT_CHAT_FRAME, L["BigFootChannel"])
        ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, L["BigFootChannel"])
    end
    return true
end

local OriginReloadUI = ReloadUI
local addonName = ...
local function BeforeReload()
    local enabled = GetAddOnEnableState(UnitName("player"), addonName)>=2
    if not enabled then leaveChannelFunc(L["BigFootChannel"]) end
end
function ReloadUI() BeforeReload(); OriginReloadUI(); end

local OriginConsoleExec = ConsoleExec
function ConsoleExec(cmd, ...)
    if cmd and cmd:lower()=="reloadui" then BeforeReload(); end
    OriginConsoleExec(cmd, ...);
end

local function getNextChannel(channelName)
    local i = 1 
    local cur 
    if channelName:find(L["BigFootChannel"]) then
        cur = channelName:match("%d") 
        if cur then
            i = tonumber(cur)+1 
        end 
        return L["BigFootChannel"]..i 
    end 
end

function DuowanChat:ClearPlayerDB(tbl)
    local tmp = {}
    local interv = time() - 60*60*24*30 -- 30 days

    for name, val in next, tbl do
        local lvl, time = val:match'^(%d+)@(%d+)$'
        time = tonumber(time)
        if(time) then
            if(time < interv) then
                tinsert(tmp, name)
            end
        else
            tinsert(tmp, name)
        end
    end

    for _, ent in next, tmp do
        tbl[ent] = nil
    end
    wipe(tmp)
end

function DuowanChat:OnInitialize()
    DWC_ChatFrame_Spacing=_G.ChatFrame1:GetSpacing() 

    do
        local realm = GetRealmName()
        DuowanChatPlayerDB = DuowanChatPlayerDB or {}
        DuowanChatPlayerDB[realm] = DuowanChatPlayerDB[realm] or {}
        player_db = DuowanChatPlayerDB[realm]
        self:ClearPlayerDB(player_db)

        if(type(DuowanChatPerDB) == 'table') then
            wipe(DuowanChatPerDB)
            DuowanChatPerDB = nil
        end
    end

    if(DEBUG_MODE) then
        local debugf = tekDebug and tekDebug:GetFrame'DuowanChat:Core'
        if(debugf) then
            self.tekdebug = function(...)
                local text = string.join(", ", tostringall(...))
                debugf:AddMessage(text:gsub('\124', '/'))
            end
        end
    end

    self.db = LibStub("AceDB-3.0"):New("DuowanChatDB", defaults, "Default") 
    db = self.db.profile 

    self.db.RegisterCallback(self, "OnProfileChanged", "Refresh") 
    self.db.RegisterCallback(self, "OnProfileCopied", "Refresh")
    self.db.RegisterCallback(self, "OnProfileReset", "Refresh")
    hooksecurefunc("FCF_SetButtonSide", self.Refresh)

    -- self:RegisterEvent("CHANNEL_PASSWORD_REQUEST")
    self:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:SetBFChannelMuted(db.mute)

    -- don't be evil
    -- UIParent:UnregisterEvent("CHANNEL_PASSWORD_REQUEST") 
    -- SlashCmdList["CHAT_PASSWORD"] = nil 

    self:SetupOptions() 
    -- generateIconMap()
    if (not db.userPlaced) then
        db.userPlaced = true;
        DEFAULT_CHAT_FRAME:SetUserPlaced(false);
    end

    wipe(self.cbuttons);
    for i=1, NUM_CHAT_WINDOWS do
        local button = self:CreateCopyButton(i);
        tinsert(self.cbuttons, button);
    end	

    --self:RawHook("ChatFrame_MessageEventHandler", true);
    for i = 1, NUM_CHAT_WINDOWS do
        if(i ~= 2) then
            local cf = _G['ChatFrame'..i]
            self:RawHook(cf, 'AddMessage', true)
        end
    end

end

function DWCChatFrame_OnShow(self) 
    self:RegisterForDrag("LeftButton");
end

--function DuowanChat:ParseLocalText(text)
--	for tag in string.gmatch(text, "|T([^:]+):%d+|t") do 
--		if ( DWC_ReverseIconTableMap[tag] ) then
--			text = string.gsub(text, "|T[^:]+:%d+|t",DWC_ReverseIconTableMap[tag],1); 
--			return text,true 
--		end 
--	end 
--	return text,false 
--end 

local function getCurrentFont()
    local _,font=SELECTED_CHAT_FRAME:GetFont()	
    local myfont=floor(font)*1.3	
    return myfont
end 

--function DuowanChat:ParseText(text,font) 
--	for tag in string.gmatch(text, "({[^}]+})") do
--		if ( DWC_IconTableMap[tag] ) then
--			text = string.gsub(text, tag, "|T"..DWC_IconTableMap[tag] .. ":"..getCurrentFont().."|t",1);
--			--text = string.gsub(text, tag, "|T"..DWC_IconTableMap[tag] .. ":".."0".."|t",1);
--			return text;
--		end 
--	end
--	return text
--end

-- function DuowanChat:ReverseParseText(text,font)
-- 	for tag in string.gmatch(text, "|T([^:]+):"..font.."|t") do
-- 		if ( DWC_ReverseIconTableMap[tag] ) then
-- 			text = string.gsub(text, "|T[^:]+:"..font.."|t",DWC_ReverseIconTableMap[tag],1); 
-- 		end 
-- 	end
-- 	return text 
-- end 

function DuowanChat:RegisterEvents()
    --self:RegisterEvent("CHAT_MSG_WHISPER",self.OnEvent)
    --self:RegisterEvent("CHAT_MSG_PARTY",self.OnEvent)
    --self:RegisterEvent("CHAT_MSG_GUILD",self.OnEvent)
    --self:RegisterEvent("CHAT_MSG_YELL",self.OnEvent)
    --self:RegisterEvent("CHAT_MSG_SAY",self.OnEvent)
    self:RegisterEvent("GROUP_ROSTER_UPDATE",self.OnEvent)
    self:RegisterEvent("GUILD_ROSTER_UPDATE",self.OnEvent)
    self:RegisterEvent("FRIENDLIST_UPDATE",self.OnEvent) 
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT",self.OnEvent) 
    self:RegisterEvent("WHO_LIST_UPDATE",self.WhoListUpdate) 
    self:RegisterEvent("UNIT_LEVEL", self.OnEvent)
end 

function DuowanChat:UnregisterEvents() 
    self:UnregisterEvent("CHAT_MSG_WHISPER")
    self:UnregisterEvent("CHAT_MSG_PARTY")
    self:UnregisterEvent("CHAT_MSG_GUILD")
    self:UnregisterEvent("CHAT_MSG_YELL")
    self:UnregisterEvent("CHAT_MSG_SAY")
    self:UnregisterEvent("GROUP_ROSTER_UPDATE")
    self:UnregisterEvent("GUILD_ROSTER_UPDATE")
    self:UnregisterEvent("UNIT_FOCUS")
    self:UnregisterEvent("UNIT_TARGET") 
    self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
    self:UnregisterEvent("WHO_LIST_UPDATE") 
    self:UnregisterEvent("FRIENDLIST_UPDATE") 
    self:UnregisterEvent("UNIT_LEVEL") 
end 

local function getNameInfo(name)
    local d = player_db and player_db[name]
    if(d) then
        return d:match'(%d+)@(%d+)'
    end
end

function dcTEST()
    local p = UnitName'player'
    print('player:', p)
    print('getNameInfo():', getNameInfo(p))
end

local function storeName(name, lvl) 
    if (name and lvl) then
        player_db[name] = lvl.."@"..time()
    end
end

function DuowanChat:WhoListUpdate() 
    if GetNumWhoResults()>0 then
        local name,_,level=GetWhoInfo(1)
        storeName(name,level) 
    end 
    SetWhoToUI(0)
    FriendsFrame:RegisterEvent("WHO_LIST_UPDATE") 
end

local sendWhoQuery=function(name)
    SetWhoToUI(1)
    FriendsFrame:UnregisterEvent("WHO_LIST_UPDATE")
    SendWho('n-"'..name..'"')
end

local function checkMessageSender(message,sender)
    if (message and sender and strlen(sender)>0) then
        local level = getNameInfo(sender)
        level = level and tonumber(level)

        -- query if sender's not at max level
        if not (level == MAX_PLAYER_LEVEL) then
            sendWhoQuery(sender)
        end
    end 
end

function DuowanChat.OnEvent(event, message, sender)
    local checkUnitIsStored=function(unit)
        if UnitIsPlayer(unit) then
            local name=UnitName(unit)
            local level=UnitLevel(unit)
            storeName(name,level)
        end 
    end
    if string.find(event,"CHAT_MSG") then
        checkMessageSender(message, sender)
    elseif event=="GROUP_ROSTER_UPDATE" then
        if(IsInRaid())then
            local num = GetNumGroupMembers()
            table.wipe(raidRosters)
            if num>0 then
                for i=1,num,1 do
                    local name,_,subgroup,level = GetRaidRosterInfo(i)
                    if name then
                        storeName(name,level)
                        raidRosters[name] = subgroup;
                    end
                end
            end
        end
        local num = GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME)
        if num>0 then
            -- local num=GetRealNumPartyMembers()
            for i=1,num,1 do
                checkUnitIsStored("party"..i)
            end
        end
    elseif event=="GUILD_ROSTER_UPDATE" then
        local num= GetNumGuildMembers()
        if num>0 then
            for i=1,num,1 do 
                local name,_,_,level = GetGuildRosterInfo(i) 
                storeName(name,level) 
            end
        end 
    elseif event=="FRIENDLIST_UPDATE" then 
        local _, num= GetNumFriends()
        if num>0 then
            for i=1,num,1 do
                local name,level,class= GetFriendInfo(i) 
                storeName(name,level)
            end
        end 
    elseif event=="UNIT_FOCUS" then 
        checkUnitIsStored("focus") 
    elseif event=="UNIT_TARGET" then 
        checkUnitIsStored("target")
    elseif event=="UPDATE_MOUSEOVER_UNIT" then 
        checkUnitIsStored("mouseover") 
    elseif (event == "UNIT_LEVEL") then
        checkUnitIsStored(sender);
    end
end

do
    local diffcolors = setmetatable({}, {
        __index = function(t, i)
            local r, g, b = string.split('-', i)
            r = tonumber(r); g = tonumber(g); b = tonumber(b)
            local c = string.format('|cff%02x%02x%02x', r*255, g*255, b*255)
            t[i] = c
            return c
        end,
        __call = function(t, i)
            local _ty = type(i)
            if(_ty == 'table') then
                return t[i.r..'-'..i.g..'-'..i.b]
            elseif(_ty == 'string') then
                return t[i]
            end
        end,
    })



    local format_player_link = function(name, channel, player)
        -- '|Hplayer:%1:%2|h%3|h'
        local levelPart, subgroupParty
        if db.enablelevel then
            local level = getNameInfo(name)
            level = level and tonumber(level)
            local color = level and diffcolors(GetQuestDifficultyColor(level))
            if color then
                levelPart = format("%s%d%s:",color and color or "",level,color and "|r" or "")
            end
        end
        local sube = db.enablesubgroup
        local subg = sube and raidRosters[name]
        if(sube and subg) then
            subgroupParty =  " "..subg.."队"
        end

        return string.format('|Hplayer:%s:%s|h[%s%s%s]|h', name, channel, levelPart or "", player, subgroupParty or "")
    end

    local channel = function(channum, channame, ...)
        -- if(DuowanChat.tekdebug) then
        --     DuowanChat.tekdebug(channum, channame, last)
        -- end
        if(db.useshortname) then
            channame = SCCN_Chan_Replace[channame] or channame
        end

        if(channame == L.BigFootChannel) then
            channame = L.WorldChannel
        end

        -- `%3$s`: from the 3rd arg to the last
        return string.format('[%d.%s]|h %3$s', channum, channame, ...)
    end

    local function format_message(text)
        --local namelink, nametext = text:match'|Hplayer:([^|]+)|h%[([^]]+)%]|h'
        if(db.enablelevel or db.enablesubgroup) then
            text = text:gsub('|Hplayer:([^:]+):([^|]+)|h%[(.-)%]|h', format_player_link)
        end

        -- DuowanChat.tekdebug(text)
        text = text:gsub('%[(%d+)%. (.-)%].+(|Hplayer.+)', channel)

        return text
    end

    function DuowanChat:AddMessage(cf, text, r, g, b, id, addToStart, accessID, extraData)
        if ( addToStart or not self.enable ) then
            return self.hooks[cf].AddMessage(cf, text, r, g, b, id, addToStart, accessID, extraData);
        end

        if(type(text) == 'string' and (db.enablelevel or db.useshortname)) then
            text = format_message(text)
        end

        if (self.hooks[cf].AddMessage) then 
            return self.hooks[cf].AddMessage(cf, text,r,g,b,id,addToStart, accessID, extraData);
        end	
    end
end

do
    local orig = GetChannelDisplayInfo
    _G.GetChannelDisplayInfo = function(...)
        local name = orig(...)
        if name then name = name:gsub(L["BigFootChannel"], L["WorldChannel"]); end
        return name, select(2, orig(...))
    end
end

function DuowanChat:AddLines(lines, ...)
    for i=select("#", ...), 1, -1 do
        local x = select(i, ...);
        if x:GetObjectType() == "FontString" and not x:GetName() then
            table.insert(lines, x:GetText());
        end
    end
end

function DuowanChat:CopyChat()
    local frame = SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME;
    wipe(self.lines);
    self:AddLines(self.lines, frame.FontStringContainer:GetRegions());
    self.str = table.concat(self.lines, "\n");
    wipe(self.lines);

    DWCCopyFrameText:SetText(L["Press Ctrl-C to Copy the text"]);
    DWCCopyFrameScrollText:SetText(self.str or "");
    DWCCopyFrame:Show();	
end

do
    local function reminderOnClick(self) 
        PlaySound163("igChatBottom");
        DuowanChat:CopyChat();		
    end
    local function reminderOnEnter(self, motion) self:SetAlpha(0.9) end
    local function reminderOnLeave(self, motion) self:SetAlpha(0.3) end

    function DuowanChat:CreateCopyButton(id)
        local cf = _G["ChatFrame"..id];
        local name = "ChatFrame"..id.."DWCCReminder";
        local b = _G[name];
        if not b then
            b = CreateFrame("Button", name, cf);
            b:SetFrameStrata("LOW");
            b:SetWidth(14);
            b:SetHeight(14);
            b:SetNormalTexture("Interface\\AddOns\\DuowanChat\\icon\\prat-chatcopy2");
            b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight");
            b:SetPoint("TOPLEFT", cf, "TOPLEFT", 14, 2);
            b:SetScript("OnClick", reminderOnClick);
            b:SetScript("OnEnter", reminderOnEnter);
            b:SetScript("OnLeave", reminderOnLeave);
            b:SetAlpha(0.3);
            b:Hide();
        end

        return b;
    end
end

function DuowanChat:ChatCopyToggle(switch)	
    for i, b in ipairs(self.cbuttons) do
        if (switch) then
            b:Show();
        else
            b:Hide();
        end
    end
end

function DuowanChat:PLAYER_ENTERING_WORLD(...)
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    hooksecurefunc("ChatFrame_AddChannel", function(chatframe, name)
        if name==L["BigFootChannel"] then
            --print("ChatFrame_AddChannel", chatframe:GetID(), name)
            db.worldChannels = db.worldChannels or {}
            db.worldChannels[_G[chatframe:GetName().."Tab"]:GetText()] = 1
        end
    end)
    hooksecurefunc("ChatFrame_RemoveChannel", function(chatframe, name)
        if name==L["BigFootChannel"] then
            --print("ChatFrame_RemoveChannel", chatframe:GetID(), name)
            db.worldChannels = db.worldChannels or {}
            db.worldChannels[_G[chatframe:GetName().."Tab"]:GetText()] = nil
        end
    end)

    if U1GetCfgValue and IsAddOnLoaded("163ui_chat") and not U1GetCfgValue("163ui_chat/worldchannel") then
        self:SetBFChannelMuted(true)
        dwChannel_RefreshMuteButton()
        return
    else
        local tryJoin;
        tryJoin = function()
            local success = joinChannelFunc(L["BigFootChannel"])
            if not success then
                self:ScheduleTimer(tryJoin, 1)
            end
        end
        tryJoin();
    end
end

function DuowanChat:CHANNEL_PASSWORD_REQUEST(...)
    local _,channelName = ... 
    if channelName:find(L["BigFootChannel"]) then 
        self.nextChannel = getNextChannel(channelName)
        joinChannelFunc(self.nextChannel) 
    else
        local dialog = StaticPopup_Show("CHAT_CHANNEL_PASSWORD", channelName);
        if ( dialog ) then 
            dialog.data = channelName; 
        end 
        return; 
    end 
end 

function DuowanChat:ChatEdit_DeactivateChat(editBox)
    editBox:Hide();
end

function DuowanChat:UIParent_ManageFramePositions()
    self:FCF_UpdateDockPosition();
    --self:ScheduleTimer("FCF_UpdateDockPosition", 2);	
end

function DuowanChat:UIParent_ManageFramePosition(...)
    self:FCF_UpdateDockPosition();
end
-- Function for repositioning the chat dock depending on if there's a shapeshift bar/stance bar, etc...
function DuowanChat:FCF_UpdateDockPosition()
    if ( DEFAULT_CHAT_FRAME:IsUserPlaced() ) then
        if ( SIMPLE_CHAT ~= "1" ) then			
            return;
        end
    end

    local chatOffset = 113;
    if ((AspectPosionBarFrame and AspectPosionBarFrame:GetNumShapeshiftForms() > 0) or GetNumShapeshiftForms() > 0 or HasPetUI() or PetHasActionBar() or HasMultiCastActionBar()) then
        if ( MultiBarBottomLeft:IsShown() or MultiBarBottomRight:IsShown()) then
            chatOffset = chatOffset + 80;
        else
            chatOffset = chatOffset + 45;
        end
    elseif ( MultiBarBottomLeft:IsShown() or MultiBarBottomRight:IsShown() ) then
        chatOffset = chatOffset + 45;
    end

    DEFAULT_CHAT_FRAME:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 32, chatOffset);
    FCF_DockUpdate();
end

function DuowanChat:FCF_ResetChatWindows()
    DEFAULT_CHAT_FRAME:SetUserPlaced(false);
    self:FCF_UpdateDockPosition();
end

function DuowanChat:ChatEdit_UpdateHeader(editBox)
    local type = editBox:GetAttribute("chatType");
    if(type) then
        -- local info = ChatTypeInfo[type];
        local header = _G[editBox:GetName().."Header"];
        local headerText = header and header:GetText();
        -- print(type, headerText)
        if(headerText) then
            if (headerText:find(L["BigFootChannel"])) then
                header:SetText(L["WorldChannel"].."： ");
            elseif (headerText:find("LFGForwarder")) then
                header:SetText("组队转发".."： ");
            elseif (headerText:find("TCForwarder")) then
                header:SetText("交易转发".."： ");
            else
                return
            end
            editBox:SetTextInsets(15 + header:GetWidth(), 13, 0, 0);
        end
    end
end

function DuowanChat:OnEnable() 
    self.enable = true;
    self:SecureHook("ChatEdit_UpdateHeader");
    self:SecureHook("ChatEdit_DeactivateChat"); --warbaby 如果注释则im方式下始终显示输入框
    self:RegisterEvents();
    --self:ChatScrollToggle(true);
    self:ChatCopyToggle(true);	
    self:SecureHook("UIParent_ManageFramePositions");
    self:SecureHook("FCF_ResetChatWindows");
    --self:RawHook("FCF_UpdateDockPosition", true);
    self:SecureHook("UIParent_ManageFramePosition");
    --SetCVar("chatStyle", "classic");
    dwChannel_RefreshMuteButton();
    storeName(UnitName("player"), UnitLevel("player"));
end

function DuowanChat:Refresh()
    DWCChatFrame:SetMovable(db.enablechatchannelmove)
    if db.enablechatchannelmove or not DWCChatFrame:IsVisible() then
        local a,b,c,d = ChatFrame1:GetClampRectInsets()
        if d == -29 then ChatFrame1:SetClampRectInsets(a,b,c,0) end
    	for i=1,10 do
    		local point,rel,relp,x,y=_G["ChatFrame"..i.."EditBox"]:GetPoint()
            if point == "TOPLEFT" then
    		    _G["ChatFrame"..i.."EditBox"]:SetPoint(point,rel,relp,x,-2)
            end
        end
        --if DWCChatFrame:GetPoint() == nil then
        --    DWCChatFrame:SetPoint("TOPLEFT", "ChatFrame1", "BOTTOMLEFT", -5, -3)
        --end
    else
        local a,b,c,d = ChatFrame1:GetClampRectInsets()
        if d == 0 and DWCChatFrame:IsVisible() then
            ChatFrame1:SetClampRectInsets(a,b,c,-29)
        end
        --buttons are on the right
        DWCChatFrame:ClearAllPoints()
        if ChatFrame1ButtonFrame:GetPoint() ~= "TOPLEFT" then
            DWCChatFrame:SetPoint("TOPLEFT", "ChatFrame1", "BOTTOMLEFT", -5 - 28, -3)
        else
            DWCChatFrame:SetPoint("TOPLEFT", "ChatFrame1", "BOTTOMLEFT", -5, -3)
        end
    	for i=1,10 do
    		local point,rel,relp,x,y=_G["ChatFrame"..i.."EditBox"]:GetPoint()
            if point == "TOPLEFT" then
    		    _G["ChatFrame"..i.."EditBox"]:SetPoint(point,rel,relp,x,-28)
            end
        end
    end
end

function DuowanChat:OnDisable() 
    self.enable = false;
    self:Unhook("ChatEdit_UpdateHeader");	
    --FCF_UpdateDockPosition=FCF_UpdateDockPosition_ORI 
    self:Unhook("ChatEdit_DeactivateChat");
    self:UnregisterEvents();
    --self:ChatScrollToggle(false);
    self:ChatCopyToggle(false);
    self:Unhook("UIParent_ManageFramePositions");	
    self:Unhook("FCF_ResetChatWindows");
    self:Unhook("FCF_UpdateDockPosition");
    self:Unhook("UIParent_ManageFramePosition");
    --SetCVar("chatStyle", "im");
end

function DuowanChat:GetModuleEnabled(module)
    return db.modules[module] 
end 

function DuowanChat:SetModuleEnabled(module, value)
    local old = db.modules[module] 
    db.modules[module] = value
    if old ~= value then 
        if value then 
            self:EnableModule(module) 
        else 
            self:DisableModule(module) 
        end 
    end 
end

local _bfchannel_filter = function(cf, event, msg, sender, lang, channelStr,
    target, flags, unknown, channelNumber, channelName, unknown2, counter)
    if(channelName:find(L['BigFootChannel'])) then
        -- if(DuowanChat.tekdebug) then
        --     DuowanChat.tekdebug('Filter', sender, channelStr, msg)
        -- end
        return true
    end
end

local _filter_registed = false
function DuowanChat:SetBFChannelMuted(muted)
    db.mute = muted
    if(muted) then
        if(not _filter_registed) then
            _filter_registed = true
            return ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', _bfchannel_filter)
        end
    else
        joinChannelFunc(L["BigFootChannel"])
        if(_filter_registed) then
            _filter_registed = false
            return ChatFrame_RemoveMessageEventFilter('CHAT_MSG_CHANNEL', _bfchannel_filter)
        end
    end
end

function dwChannel_RefreshMuteButton()
    dwChannelMuteButtonMute:SetDrawLayer("OVERLAY", 1);
    if db.mute then 
        dwChannelMuteButtonMute:Show() 
    else 
        dwChannelMuteButtonMute:Hide() 
    end 
end

function dwChannelMuteButton_OnEnter(self)
    GameTooltip_SetDefaultAnchor(GameTooltip, self);
    GameTooltip:SetText(L["Channel mute label"], 1, 1, 1);
    GameTooltip:AddLine(L["Channel mute desc"]);
    GameTooltip:Show();
end


function dwChannelMuteButton_OnClick(self, button)
    DuowanChat:SetBFChannelMuted(not db.mute)

    if db.mute then
        print(L["BigFoot Channel has been blocked"])
    else
        print(L["BigFoot Channel has been unblocked"])
    end

    if(IsAddOnLoaded("163ui_chat") and U1DB and U1DB.configs) then
        U1DB.configs["163ui_chat/worldchannel"] = not db.mute
    end

    LFW_SHOW = db.mute
    TFW_SHOW = LFW_SHOW
    local origin = DEFAULT_CHAT_FRAME.AddMessage DEFAULT_CHAT_FRAME.AddMessage = noop
    if SlashCmdList["LFW"] then SlashCmdList["LFW"]("") end
    if SlashCmdList["TFW"] then SlashCmdList["TFW"]("") end
    DEFAULT_CHAT_FRAME.AddMessage = origin

    dwChannel_RefreshMuteButton()
end 

--截图按钮
--[[
function scButton_OnEnter(self)
    GameTooltip_SetDefaultAnchor(GameTooltip, self);
    GameTooltip:SetText("|cff880303[爱不易]|r 截图分享", 1, 1, 1);
    GameTooltip:AddLine("快捷键：Ctrl+PrtScr");
    GameTooltip:Show();
end 

function scButton_OnClick(self, button)
	Cmd3DCode_Screenshot_Start()
end 
]]

