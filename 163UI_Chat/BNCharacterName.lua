--[[------------------------------------------------------------
BN战网翻译
---------------------------------------------------------------]]
local CLASS_LOC_STR = {}
for i=1, GetNumClasses() do
    local loc, eng = GetClassInfo(i)
    CLASS_LOC_STR[loc] = RAID_CLASS_COLORS[eng].colorStr
end

--/HBNplayer:NAME:5:1117:BN_WHISPER:NAME/h[NAME]/h悄悄地说： tset 12
local origs = {} -- Original ChatFrame:AddMessage

local addMessageReplace = function(self, msg, ...)
    msg = msg and tostring(msg) or ""
    local _, _, text1, name1, bnId, bnId2, chatType, name2, name3, text2 = msg:find("^(.*)\124HBNplayer:([^%[]+):([0-9]+):([0-9]+):BN_WHISPER([A-Z_]*):([^%[]+)\124h%[([^\]]+)%]\124h(.*)$")
    if name1 then
        --u1debug(name1, bnId, bnId2, name2, name3)
        --{6,   "NAME",   "BN#5885",   true,   "CHAR_NAME",   72,   "WoW",   true,   1471711024,   false,   false,   "",   "",   true,   0,   false,   false,   false, }
        local _, _, _, _, charName, gameAccountId, gameId = BNGetFriendInfoByID(bnId)
        if gameId and gameId:lower() == "wow" then
            --{   true,   "CHAR_NAME",   "WoW",   "奥特兰克",   850,   "Alliance",   "人类",   "牧师",   "",   "艾萨拉",   "100",   "艾萨拉 - 奥特兰克",   "",   0,   true,   72,   6,   true,   false, }
            local _, _, _, realmName, _, _, _, class = BNGetGameAccountInfo(gameAccountId)
            if class then
                local color = CLASS_LOC_STR[class]
                msg = format("%s\124HBNplayer:%s:%d:%d:BN_WHISPER%s:%s\124h[%s]\124h%s", text1, name1, bnId, bnId2, chatType, name2, format("%s-|c%s%s|r", name3, color, charName), text2)
            end
        end
    end
    return origs[self](self, msg, ...)
end

WithAllChatFrame(function(cf)
    if cf:GetID() == 2 then return end
    origs[cf] = cf.AddMessage
    cf.AddMessage = addMessageReplace
end)

--[[------------------------------------------------------------
战网好友鼠标提示
---------------------------------------------------------------]]
SetOrHookScript(FriendsTooltip, "OnHide", function(self) self:SetParent(FriendsFrame) self:ClearAllPoints() end)

local function OnHyperlinkEnter(self, playerString)
    if playerString and strsub(playerString, 1, 8) == "BNplayer" then
        local bnId = select(3, strsplit(":", playerString))
        bnId = tonumber(bnId)
        for i=1, BNGetNumFriends() do
            local testId = BNGetFriendInfo(i)
            if testId == bnId then
                local fake = FAKE_FRAME or CreateFrame("Frame")
                fake.id = i
                fake.buttonType = FRIENDS_BUTTON_TYPE_BNET
                FriendsTooltip:SetParent(UIParent) FriendsFrameTooltip_Show(fake)
                FriendsTooltip.hasBroadcast = nil
                local x, y = GetCursorPosition();
                local effScale = FriendsTooltip:GetEffectiveScale();
                FriendsTooltip:ClearAllPoints()
                return FriendsTooltip:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMLEFT",(x / effScale + 0),(y / effScale + 30));
            end
        end
    end
end

local function OnHyperlinkLeave()
    if FriendsTooltip:GetParent() == UIParent then
        FriendsTooltip:Hide()
    end
end

WithAllChatFrame(function(cf)
    if cf:GetID() == 2 then return end
    SetOrHookScript(cf, "OnHyperlinkEnter", OnHyperlinkEnter);
    SetOrHookScript(cf, "OnHyperlinkLeave", OnHyperlinkLeave);
end)