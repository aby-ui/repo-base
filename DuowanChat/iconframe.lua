local DWChat = LibStub('AceAddon-3.0'):GetAddon('DuowanChat')
local L = LibStub("AceLocale-3.0"):GetLocale("DuowanChat")
local MODNAME = "ICONFRAME"
local DWChatIconFrame = DWChat:NewModule(MODNAME)
DWChatIconFrame.callbacks = LibStub("CallbackHandler-1.0"):New(DWChatIconFrame)
local DWC_NUM_TAB=60 
local DWC_ICON_SIZE_X=25
local DWC_ICON_SIZE_Y=25
local DWC_ICON_NUMBER_X=10 
local DWC_ICON_NUMBER_Y=6 
local chaticonbuttonlist={}
local buttonTemplate 
DWC_IconTable={ 
	{"{rt1}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_1"}, 
	{"{rt2}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_2"}, 
	{"{rt3}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_3"}, 
	{"{rt4}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_4"}, 
	{"{rt5}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_5"}, 
	{"{rt6}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_6"}, 
	{"{rt7}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_7"},
	{"{rt8}","Interface\\TargetingFrame\\UI-RaidTargetingIcon_8"}, 
	{"{"..L.Angel.."}","Interface\\AddOns\\DuowanChat\\icon\\angel.tga"},
	{"{"..L.Angry.."}","Interface\\AddOns\\DuowanChat\\icon\\angry.tga"}, 
	{"{"..L.Biglaugh.."}","Interface\\AddOns\\DuowanChat\\icon\\biglaugh.tga"}, 
	{"{"..L.Clap.."}","Interface\\AddOns\\DuowanChat\\icon\\clap.tga"}, 
	{"{"..L.Cool.."}","Interface\\AddOns\\DuowanChat\\icon\\cool.tga"}, 
	{"{"..L.Cry.."}","Interface\\AddOns\\DuowanChat\\icon\\cry.tga"}, 
	{"{"..L.Cute.."}","Interface\\AddOns\\DuowanChat\\icon\\cutie.tga"},
	{"{"..L.Despise.."}","Interface\\AddOns\\DuowanChat\\icon\\despise.tga"},
	{"{"..L.Dreamsmile.."}","Interface\\AddOns\\DuowanChat\\icon\\dreamsmile.tga"}, 
	{"{"..L.Embarras.."}","Interface\\AddOns\\DuowanChat\\icon\\embarrass.tga"},
	{"{"..L.Evil.."}","Interface\\AddOns\\DuowanChat\\icon\\evil.tga"},
	{"{"..L.Excited.."}","Interface\\AddOns\\DuowanChat\\icon\\excited.tga"}, 
	{"{"..L.Faint.."}","Interface\\AddOns\\DuowanChat\\icon\\faint.tga"}, 
	{"{"..L.Fight.."}","Interface\\AddOns\\DuowanChat\\icon\\fight.tga"},
	{"{"..L.Flu.."}","Interface\\AddOns\\DuowanChat\\icon\\flu.tga"}, 
	{"{"..L.Freeze.."}","Interface\\AddOns\\DuowanChat\\icon\\freeze.tga"},
	{"{"..L.Frown.."}","Interface\\AddOns\\DuowanChat\\icon\\frown.tga"},
	{"{"..L.Greet.."}","Interface\\AddOns\\DuowanChat\\icon\\greet.tga"},
	{"{"..L.Grimace.."}","Interface\\AddOns\\DuowanChat\\icon\\grimace.tga"},
	{"{"..L.Growl.."}","Interface\\AddOns\\DuowanChat\\icon\\growl.tga"},
	{"{"..L.Happy.."}","Interface\\AddOns\\DuowanChat\\icon\\happy.tga"},
	{"{"..L.Heart.."}","Interface\\AddOns\\DuowanChat\\icon\\heart.tga"}, 
	{"{"..L.Horror.."}","Interface\\AddOns\\DuowanChat\\icon\\horror.tga"}, 
	{"{"..L.Ill.."}","Interface\\AddOns\\DuowanChat\\icon\\ill.tga"},
	{"{"..L.Innocent.."}","Interface\\AddOns\\DuowanChat\\icon\\innocent.tga"},
	{"{"..L.Kongfu.."}","Interface\\AddOns\\DuowanChat\\icon\\kongfu.tga"}, 
	{"{"..L.Love.."}","Interface\\AddOns\\DuowanChat\\icon\\love.tga"},
	{"{"..L.Mail.."}","Interface\\AddOns\\DuowanChat\\icon\\mail.tga"}, 
	{"{"..L.Makeup.."}","Interface\\AddOns\\DuowanChat\\icon\\makeup.tga"},
	{"{"..L.Mario.."}","Interface\\AddOns\\DuowanChat\\icon\\mario.tga"}, 
	{"{"..L.Meditate.."}","Interface\\AddOns\\DuowanChat\\icon\\meditate.tga"}, 
	{"{"..L.Miserable.."}","Interface\\AddOns\\DuowanChat\\icon\\miserable.tga"}, 
	{"{"..L.Okay.."}","Interface\\AddOns\\DuowanChat\\icon\\okay.tga"}, 
	{"{"..L.Pretty.."}","Interface\\AddOns\\DuowanChat\\icon\\pretty.tga"}, 
	{"{"..L.Puke.."}","Interface\\AddOns\\DuowanChat\\icon\\puke.tga"}, 
	{"{"..L.Shake.."}","Interface\\AddOns\\DuowanChat\\icon\\shake.tga"}, 
	{"{"..L.Shout.."}","Interface\\AddOns\\DuowanChat\\icon\\shout.tga"}, 
	{"{"..L.Silent.."}","Interface\\AddOns\\DuowanChat\\icon\\shuuuu.tga"}, 
	{"{"..L.Shy.."}","Interface\\AddOns\\DuowanChat\\icon\\shy.tga"}, 
	{"{"..L.Sleep.."}","Interface\\AddOns\\DuowanChat\\icon\\sleep.tga"}, 
	{"{"..L.Smile.."}","Interface\\AddOns\\DuowanChat\\icon\\smile.tga"}, 
	{"{"..L.Suprise.."}","Interface\\AddOns\\DuowanChat\\icon\\suprise.tga"}, 
	{"{"..L.Surrender.."}","Interface\\AddOns\\DuowanChat\\icon\\surrender.tga"},
	{"{"..L.Sweat.."}","Interface\\AddOns\\DuowanChat\\icon\\sweat.tga"},
	{"{"..L.Tear.."}","Interface\\AddOns\\DuowanChat\\icon\\tear.tga"},
	{"{"..L.Tears.."}","Interface\\AddOns\\DuowanChat\\icon\\tears.tga"},
	{"{"..L.Think.."}","Interface\\AddOns\\DuowanChat\\icon\\think.tga"},
	{"{"..L.Titter.."}","Interface\\AddOns\\DuowanChat\\icon\\titter.tga"}, 
	{"{"..L.Ugly.."}","Interface\\AddOns\\DuowanChat\\icon\\ugly.tga"},
	{"{"..L.Victory.."}","Interface\\AddOns\\DuowanChat\\icon\\victory.tga"}, 
	{"{"..L.Volunteer.."}","Interface\\AddOns\\DuowanChat\\icon\\volunteer.tga"}, 
	{"{"..L.Wronged.."}","Interface\\AddOns\\DuowanChat\\icon\\wronged.tga"},
} 

local tag2Text = setmetatable({}, {
    __index = function(t, i)
        t[i] = i:match'{(.+)}'
        return t[i]
    end,
    __call = function(t, i)
        return t[i]
    end,
})

local db 
local defaults = {
	profile = {
		enablechaticon=false
	}
} 

local optGetter, optSetter 
do
	local mod = DWChatIconFrame
	function optGetter(info)
		local key = info[#info] 
		return DWChat.db.profile[key] 
	end 
	
	function optSetter(info, value) 
		local key = info[#info]
		DWChat.db.profile[key] = value
		mod:Refresh() 
	end
end 

local options 
local getOptions=function()
	if not options then
		options={
			type = "group",
			name = L["IconFrame"], 
			arg = MODNAME, 
			get = optGetter,
			set = optSetter, 
			args={
				intro = { 
					order = 1,
					type = "description", 
					name = L["this function allows you to use emtion icons in your chat, and others who has this addon enabled can see your emtion icons"], 
				}, 
				enablechaticon = { 
					order = 2, 
					type = "toggle",
					name = L["Enable emotion icons"], 
					get = function()
						return DWChat:GetModuleEnabled(MODNAME) 
					end, 
					set = function(info, value) 
						DWChat:SetModuleEnabled(MODNAME, value) 
					end, 
				},
			},
		}
	end
	return options
end 

function DWCIconButton_OnClick(self, button)
    local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
    local editBox = chatFrame.editBox or ChatEdit_ChooseBoxForSend() or ChatFrame1EditBox or ChatFrameEditBox
	if (not editBox:IsShown()) then
		editBox:Show();
	end
	editBox:SetFocus();
	local _,font=SELECTED_CHAT_FRAME:GetFont()
	font=floor(font)
	--editBox:Insert("|T"..self.texture..":"..font.."|t")
    editBox:Insert(self.text)
	DWCIconFrame:Hide()
end

local function createIconButton(text,texture,i)
	local chatTab=_G["DWCChatIconButton"..i] or CreateFrame("Button","DWCChatIconButton"..i,DWCIconFrame,"DWCIconButtonTemplate") 
	chatTab.id= i 
	chatTab.text=text
	chatTab.texture=texture
	chatTab:SetNormalTexture(texture) 
	return chatTab 
end 

local function setIconPosition(frame,icon,ix,iy)
	icon:SetPoint("TOPLEFT",frame,"TOPLEFT",(ix-1)*DWC_ICON_SIZE_X+5,-1*(iy-1)*DWC_ICON_SIZE_Y-5) 
end

local function arrangeIcons(frame,icons)
	local px=1
	local py=1 
	for i=1,DWC_NUM_TAB,1 do
		setIconPosition(frame,icons[i],px,py)
		px=px+1
		if px==DWC_ICON_NUMBER_X+1 then 
			px=1 
			py=py+1 
		end
	end 
end

local function createIconFrame()
	local callOutButton=_G.DWCIconFrameCalloutButton 
	local iconFrame=_G.DWCIconFrame
	callOutButton:SetScript("OnClick",function()
        if IsControlKeyDown() then
            DuowanChat.db.profile.enablechatchannelmove = not DuowanChat.db.profile.enablechatchannelmove;
            U1Message(DuowanChat.db.profile.enablechatchannelmove and "频道按钮栏已解锁" or "频道按钮栏已锁定");
            DWCChatFrame:ClearAllPoints();
            DuowanChat:Refresh();
            return
        end
		if not iconFrame then 
			return
		end
		if iconFrame:IsShown() then
			iconFrame:Hide() 
		else
			iconFrame:Show() 
		end 
	end) 
	callOutButton:SetScript("OnEnter",function()end) 
	callOutButton:SetScript("OnLeave",function()end) 
    CoreUIEnableTooltip(callOutButton, "表情图标", "按住ctrl点击可以锁定/解锁按钮栏");
	callOutButton:SetAlpha(0.8)
	callOutButton:SetPoint("TOPLEFT",DWCChatFrame,"TOPLEFT",2,-3) 
	local i=0
	for k, v in pairs(DWC_IconTable) do
		i=i+1 
		chaticonbuttonlist[i]=createIconButton( v[1], v[2],k)
	end 
	
	DWC_NUM_TAB=i arrangeIcons(iconFrame,chaticonbuttonlist)
	iconFrame.iconButtonList=chaticonbuttonlist iconFrame:SetScript("OnShow",function(self) 
		local i=1
		while(self.iconButtonList[i]) do 
			self.iconButtonList[i]:Show()
			i=i+1
		end
	end)
	iconFrame:SetScript("OnHide",function(self) 
		local i=1 
		while(self.iconButtonList[i]) do
			self.iconButtonList[i]:Hide()
			i=i+1 
		end 
	end)
    DuowanChat:Refresh()
end 

function DWChatIconFrame:OnInitialize() 
	self.db = DWChat.db:RegisterNamespace(MODNAME, defaults) 
	db = self.db.profile 
	self:SetEnabledState(DWChat:GetModuleEnabled(MODNAME)) 
	DWChat:RegisterModuleOptions(MODNAME, getOptions, L["IconFrame"])
	local worldFrame_MouseUp=WorldFrame:GetScript("OnMouseUp")
	if worldFrame_MouseUp then
		WorldFrame:HookScript("OnMouseUp",function() 
			if DWCIconFrame then
				DWCIconFrame:Hide() 
			end 
		end) 
	else 
		WorldFrame:SetScript("OnMouseUp",function() 
			if DWCIconFrame then 
				DWCIconFrame:Hide() 
			end
		end)
	end
end 

function DWChatIconFrame:Refresh()
end

local ICON_TAG_LIST, ICON_LIST = {}, {}
function DWChatIconFrame:OnEnable() 
   for _, v in next, DWC_IconTable do
      local tag, icon = unpack(v)
      if(icon:match'tga$') then
         local text = tag2Text(tag)
         ICON_TAG_LIST[text] = text
         ICON_LIST[text] = string.format('|T%s:18.', icon)
      end
   end
   
   return createIconFrame() 
end

if CoreOnEvent then
    CoreOnEvent("PLAYER_ENTERING_WORLD", function()
        local origs = {}
        local function ChatFrame_ReplaceIconAndGroupExpressions(message, noIconReplacement)
            for tag in string.gmatch(message, "%b{}") do
                local term = strlower(string.gsub(tag, "[{}]", ""));
                if ( not noIconReplacement and ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
                    message = string.gsub(message, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
                end
            end
            return message;
        end
        local addMessageReplace = function(self, msg, ...)
            origs[self](self, msg and ChatFrame_ReplaceIconAndGroupExpressions(msg) or msg, ...)
        end
        WithAllChatFrame(function(cf)
            if cf:GetID() == 2 then return end
            origs[cf] = cf.AddMessage
            cf.AddMessage = addMessageReplace
        end)
        return "remove"
    end)
end

function DWChatIconFrame:OnDisable() 
	--for i=1, 10 do
	--	_G["ChatFrame" .. i .. "EditBox"]:SetScript("OnTextChanged",function(self) end)
	--end
	_G.DWCIconFrameCalloutButton:Hide() 
	_G.DWCIconFrame:Hide()
end 

function DWC_StartCount(frame) 
	if frame:GetParent() ~= UIParent then
		DWC_StartCount(frame:GetParent())
		return
	end 
	frame.showTimer = 1;
	frame.isCounting = 1;
end

function DWC_StopCount(frame) 
	if frame:GetParent()~=UIParent then 
		DWC_StopCount(frame:GetParent())
		return 
	end
	frame.isCounting = nil; 
end 

function DWC_OnUpdate(self,elapsed) 
	if ( not self.showTimer or not self.isCounting ) then 
		return;
	elseif ( self.showTimer < 0 ) then 
		self:Hide();
		self.showTimer = nil; 
		self.isCounting = nil;
	else
		self.showTimer = self.showTimer - elapsed; 
	end 
end

