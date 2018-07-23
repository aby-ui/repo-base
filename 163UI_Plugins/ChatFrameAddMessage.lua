--- 简写大脚世界频道的名字

local DEBUG
local function debug(...)
    if DEBUG then
        ChatFrame3:AddMessage(table.concat({...}, ","))
    end
end

local origs = {} -- Original ChatFrame:AddMessage

local addMessageReplace = function(self, msg, ...)
    --debug(msg:gsub("\124", "/"))

    --大脚世界频道
    msg = msg:gsub('(%[%d+%. )大脚世界频道(%])', "%1世界%2")
    return origs[self](self, msg, ...)
end

hooksecurefunc("ChatEdit_UpdateHeader", function(editBox)
    local type = editBox:GetAttribute("chatType");
   	if ( not type ) then
           return;
       end
    if type == "CHANNEL" then
        local header = _G[editBox:GetName().."Header"];
        local text = header and header:GetText()
        if text then
            header:SetText((text:gsub('(%[%d+%. )大脚世界频道(%])', "%1世界%2")))
            editBox:SetTextInsets(8 + header:GetWidth(), 13, 0, 0);
        end
    end
end)

WithAllChatFrame(function(cf)
    if (DEBUG and cf:GetID()~=1) or (not DEBUG and cf:GetID()==2) then return end
    origs[cf] = cf.AddMessage
    cf.AddMessage = addMessageReplace
end)