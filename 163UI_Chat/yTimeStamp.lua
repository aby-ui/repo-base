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
    local betterts = U1GetCfgValue("163ui_chat/betterts")
    if betterts then
        local cvalue = GetCVar("showTimestamps")
        if cvalue ~= "none" then
            local date = BetterDate(cvalue, time())
            if text:sub(1, #date) == date then
                text = format(ts, date, text:sub(#date + 1))
            else
                text = format(ts, date, text)
            end
        end
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

local newSetItemRef = function(link, text, button, ...)
    if(link:sub(1, LINK_LEN) ~= LINK_NAME) then return end

    local text = borderManipulation(SELECTED_CHAT_FRAME.FontStringContainer:GetRegions())
    if(text) then
        text = text:gsub('||', '\\124') --text = text:gsub('||', '#!|#') --还是\124方便一些
        text = text:gsub('|T.-|t', '')
        text = text:gsub('|K.-|k', '*')
        --print(text:gsub("|", "/"))
        text = text:gsub('|c%x%x%x%x%x%x%x%x|H(item:.-)|h.-|h%s-|r', function(link) return select(2, GetItemInfo(link)) end) --特殊处理物品链接被AddMessage处理的情况
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(item:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(spell:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(item:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(clubTicket:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(achievement:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(quest:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(trade:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(battlepet:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(worldmap:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(pvptal:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c(%x%x%x%x%x%x%x%x)|H(talent:.-)|h(.-)|h%s-|r', "|W%1^%2^%3|w")
        text = text:gsub('|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
        text = text:gsub('|H.-|h(.-)|h', '%1')
        text = text:gsub('|W(.-)%^(.-)%^(.-)|w', "|c%1|H%2|h%3|h|r")
        --text = text:gsub('#!|#', "||")
        CoreUIChatEdit_Insert(text)
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

