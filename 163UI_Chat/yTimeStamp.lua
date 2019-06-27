--[[
    Take from oChat by haste (http://github.com/haste)
--]]

local _SetItemRef = SetItemRef

local blacklist = {
    --[ChatFrame2] = true,
    --[ChatFrame7] = true,
}

local origs = {}
local LINK_NAME = '163chat'
local LINK_LEN = #LINK_NAME

local ts = '|cff68ccef|H'..LINK_NAME..'|h%s|h|r %s'

local AddMessage = function(self, text, ...)
    if U1Chat_TimeStampFormat then
        if(type(text) ~= 'string') then
            text = tostring(text)
        end
        text = format(ts, date(U1Chat_TimeStampFormat), text)
    end

    return origs[self](self, text, ...)
end

for i=1, NUM_CHAT_WINDOWS do
    local cf = _G['ChatFrame'..i]
    if(not blacklist[cf]) then
        origs[cf] = cf.AddMessage
        --cf._addMessageOrigin = cf.AddMessage;
        cf.AddMessage = AddMessage
    end
end

-- Modified version of MouseIsOver from UIParent.lua
local MouseIsOver = function(frame)
    local s = frame:GetParent():GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / s
    y = y / s

    local left = frame:GetLeft()
    local right = frame:GetRight()
    local top = frame:GetTop()
    local bottom = frame:GetBottom()

    -- Hack to fix a symptom not the real issue
    if(not left) then
        return
    end

    if((x > left and x < right) and (y > bottom and y < top)) then
        return 1
    else
        return
    end
end

local borderManipulation = function(...)
    for l = 1, select('#', ...) do
        local obj = select(l, ...)
        if(obj:GetObjectType() == 'FontString' and MouseIsOver(obj)) then
            return obj:GetText()
        end
    end
end

local eb = ChatFrame1EditBox
local newSetItemRef = function(link, text, button, ...)
    if(link:sub(1, LINK_LEN) ~= LINK_NAME) then return end

    local text = borderManipulation(SELECTED_CHAT_FRAME.FontStringContainer:GetRegions())
    if(text) then
        text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
        text = text:gsub('|H.-|h(.-)|h', '%1')
		text = text:gsub('|T.-|t', '')

        local chatFrame = GetCVar("chatStyle")=="im" and SELECTED_CHAT_FRAME or DEFAULT_CHAT_FRAME
        local eb = chatFrame and chatFrame.editBox
        if(eb) then
            eb:Insert(text)
            eb:Show();
            eb:HighlightText()
            eb:SetFocus()
        end
    end
end

local NChat_SetHyperlink_Origin = ItemRefTooltip.SetHyperlink;
ItemRefTooltip.SetHyperlink = function(self,link)
    if(strsub(link, 1, LINK_LEN)==LINK_NAME) then
        self:Hide();
        return;
    end
    return NChat_SetHyperlink_Origin(self,link);
end
hooksecurefunc("SetItemRef", newSetItemRef);

