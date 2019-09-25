
local _, ns = ...
local ycc = ns.ycc
if(not ycc) then return end

local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%%d', '%%s')
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub('%$d', '%$s') -- '%2$s %1$d-го уровня'
local function friendsFrame()
    local scrollFrame = FriendsListFrameScrollFrame
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local buttons = scrollFrame.buttons

    local playerArea = GetRealZoneText()

    for i = 1, #buttons do
        local nameText, infoText
        button = buttons[i]
        index = offset + i
        if(button:IsShown()) then
            if ( button.buttonType == FRIENDS_BUTTON_TYPE_WOW ) then
                local name, level, class, area, connected, status, note = GetFriendInfo(button.id)
                if(connected) then
                    nameText = ycc.classColor[class] .. name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[level] .. level .. '|r', class)
                    if(areaName == playerArea) then
                        infoText = format('|cff00ff00%s|r', area)
                    end
                end
            elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
                local presenceID, presenceName, battleTag, isBattleTagPresence, toonName, toonID, client, isOnline, lastOnline, isAFK, isDND, messageText, noteText, isRIDFriend, messageTime, canSoR = BNGetFriendInfo(button.id)
                if(isOnline and client==BNET_CLIENT_WOW) then
                    local hasFocus, toonName, client, realmName, realmID, faction, race, class, guild, zoneName, level, gameText, broadcastText, broadcastTime = BNGetGameAccountInfo(toonID)
                    if(presenceName and toonName and class) then
                        nameText = presenceName .. ' ' .. FRIENDS_WOW_NAME_COLOR_CODE..'('..
                                    ycc.classColor[class] .. toonName .. FRIENDS_WOW_NAME_COLOR_CODE .. ')'
                        if(zoneName == playerArea) then
                            infoText = format('|cff00ff00%s|r', zoneName)
                        end
                    end
                end
            end
        end

        if(nameText) then
            button.name:SetText(nameText)
        end
        if(infoText) then
            button.info:SetText(infoText)
        end
    end
end
hooksecurefunc(FriendsListFrameScrollFrame, 'update', friendsFrame)
hooksecurefunc('FriendsFrame_UpdateFriends', friendsFrame)


