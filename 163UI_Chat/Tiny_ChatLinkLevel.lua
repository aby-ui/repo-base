
----------------------------------------------
-- 聊天超鏈接增加物品等級 (支持大祕境鑰匙等級)
-- @Author:M
----------------------------------------------

local tooltip = CreateFrame("GameTooltip", "ChatLinkLevelTooltip", UIParent, "GameTooltipTemplate")

local ItemLevelPattern = gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local ItemPowerPattern = gsub(CHALLENGE_MODE_ITEM_POWER_LEVEL, "%%d", "(%%d+)")
local ItemNamePattern  = gsub(CHALLENGE_MODE_KEYSTONE_NAME, "%%s", "(.+)")

--获取物品实际等级
local function GetItemLevelAndTexture(ItemLink)
    local texture = select(10, GetItemInfo(ItemLink))
    if (not texture) then return end
    local text, level, extraname
    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetHyperlink(ItemLink)
    for i = 2, 4 do
        text = _G[tooltip:GetName().."TextLeft"..i]:GetText() or ""
        level = string.match(text, ItemLevelPattern)
        if (level) then break end
        level = string.match(text, ItemPowerPattern)
        if (level) then
            extraname = string.match(_G[tooltip:GetName().."TextLeft1"]:GetText(), ItemNamePattern)
            break
        end
    end
    return level, texture, extraname
end

--等级图标显示
local function SetChatLinkLevel(Hyperlink)
    local link = string.match(Hyperlink, "|H(.-)|h")
    local level, texture, extraname = GetItemLevelAndTexture(link)
    if (level and extraname) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..level..":%1:"..extraname.."]|h")
    elseif (level) then
        Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..level..":%1]|h")
    end
    return Hyperlink
end

--过滤器
local function filter(self, event, msg, ...)
    if (not TinyChatDB or not TinyChatDB.hideLinkLevel) and not IsAddOnLoaded("TinyInspect") then
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", SetChatLinkLevel)
    end
    return false, msg, ...
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", filter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_LOOT", filter)
