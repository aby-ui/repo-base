
-------------------------------------
-- 物品等級顯示 Author: M
-------------------------------------

local LibEvent = LibStub:GetLibrary("LibEvent.7000")
local LibItemGem = LibStub:GetLibrary("LibItemGem.7000")
local LibSchedule = LibStub:GetLibrary("LibSchedule.7000")
local LibItemInfo = LibStub:GetLibrary("LibItemInfo.7000")

local ARMOR = ARMOR or "Armor"
local WEAPON = WEAPON or "Weapon"
local RELICSLOT = RELICSLOT or "Relic"
local ARTIFACT_POWER = ARTIFACT_POWER or "Artifact"
if (GetLocale():sub(1,2) == "zh") then ARTIFACT_POWER = "能量" end

--框架 #category Bag|Bank|Merchant|Trade|GuildBank|Auction|AltEquipment|PaperDoll|Loot
local function GetItemLevelFrame(self, category)
    if (not self.ItemLevelFrame) then
        local fontAdjust = GetLocale():sub(1,2) == "zh" and 0 or -3
        self.ItemLevelFrame = CreateFrame("Frame", nil, self)
        self.ItemLevelFrame:SetFrameLevel(8)
        self.ItemLevelFrame:SetSize(self:GetSize())
        self.ItemLevelFrame:SetPoint("CENTER")
        self.ItemLevelFrame.levelString = self.ItemLevelFrame:CreateFontString(nil, "OVERLAY")
        self.ItemLevelFrame.levelString:SetFont(STANDARD_TEXT_FONT, 13+fontAdjust, "OUTLINE")
        self.ItemLevelFrame.levelString:SetPoint("TOP")
        self.ItemLevelFrame.levelString:SetTextColor(1, 0.82, 0)
        self.ItemLevelFrame.slotString = self.ItemLevelFrame:CreateFontString(nil, "OVERLAY")
        self.ItemLevelFrame.slotString:SetFont(STANDARD_TEXT_FONT, 10+fontAdjust, "OUTLINE")
        self.ItemLevelFrame.slotString:SetPoint("BOTTOMRIGHT", 1, 2)
        self.ItemLevelFrame.slotString:SetTextColor(1, 1, 1)
        self.ItemLevelFrame.slotString:SetJustifyH("RIGHT")
        self.ItemLevelFrame.slotString:SetWidth(30)
        self.ItemLevelFrame.slotString:SetHeight(0)
        LibEvent:trigger("ITEMLEVEL_FRAME_CREATED", self.ItemLevelFrame, self)
    end
    if (TinyInspectDB and TinyInspectDB.EnableItemLevel) then
        self.ItemLevelFrame:Show()
        LibEvent:trigger("ITEMLEVEL_FRAME_SHOWN", self.ItemLevelFrame, self, category)
    else
        self.ItemLevelFrame:Hide()
    end
    return self.ItemLevelFrame
end

--設置裝等文字
local function SetItemLevelString(self, text, quality, ilvl)
    if ilvl and ilvl~="" and ilvl > 0 and U1GetInventoryLevelColor and TinyInspectDB.ShowColoredItemLevelString then
        self:SetTextColor(U1GetInventoryLevelColor(ilvl, quality))
    elseif (quality and TinyInspectDB and TinyInspectDB.ShowColoredItemLevelString) then
        local r, g, b, hex = GetItemQualityColor(quality)
        text = format("|c%s%s|r", hex, text)
    end
    self:SetText(text)
end

--設置部位文字
local function SetItemSlotString(self, class, equipSlot, link)
    local slotText = ""
    if (TinyInspectDB and TinyInspectDB.ShowItemSlotString) then
        if (equipSlot and string.find(equipSlot, "INVTYPE_")) then
            slotText = _G[equipSlot] or ""
        elseif (class == ARMOR) then
            slotText = class
        elseif (link and IsArtifactPowerItem(link)) then
            slotText = ARTIFACT_POWER
        elseif (link and IsArtifactRelicItem(link)) then
            slotText = RELICSLOT
        end
    end
    if (link and IsArtifactPowerItem(link)) then slotText = ARTIFACT_POWER end
    self:SetText(slotText)
end

--部分裝備無法一次讀取
local function SetItemLevelScheduled(button, ItemLevelFrame, link)
    if (not string.match(link, "item:(%d+):")) then return end
    LibSchedule:AddTask({
        identity  = link,
        elasped   = 0.5,
        expired   = GetTime() + 3,
        frame     = ItemLevelFrame,
        button    = button,
        onExecute = function(self)
            local count, level, _, _, quality, _, _, class, _, _, equipSlot = LibItemInfo:GetItemInfo(self.identity)
            if (count == 0) then
                SetItemLevelString(self.frame.levelString, level > 0 and level or "", quality)
                SetItemSlotString(self.frame.slotString, class, equipSlot, link)
                self.button.OrigItemLevel = (level and level > 0) and level or ""
                self.button.OrigItemQuality = quality
                self.button.OrigItemClass = class
                self.button.OrigItemEquipSlot = equipSlot
                return true
            end
        end,
    })
end

--設置物品等級
local function SetItemLevel(self, link, category, BagID, SlotID)
    if (not self) then return end
    local frame = GetItemLevelFrame(self, category)
    if (self.OrigItemLink == link) then
        SetItemLevelString(frame.levelString, self.OrigItemLevel, self.OrigItemQuality, self.OrigItemLevel)
        SetItemSlotString(frame.slotString, self.OrigItemClass, self.OrigItemEquipSlot, self.OrigItemLink)
    else
        local _, count, level, quality, class, equipSlot
        if (link and string.match(link, "item:(%d+):")) then
            _, _, quality, _, _, class, _, _, equipSlot = GetItemInfo(link)
            if (BagID and SlotID and (category == "Bag" or category == "AltEquipment") and (quality == 7 or quality == 6)) then
                count, level = LibItemInfo:GetContainerItemLevel(BagID, SlotID)
            else
                count, level = LibItemInfo:GetItemInfo(link)
            end
            if (count > 0) then
                SetItemLevelString(frame.levelString, "...", nil, 1)
                return SetItemLevelScheduled(self, frame, link)
            else
                SetItemLevelString(frame.levelString, level > 0 and level or "", quality, level)
                SetItemSlotString(frame.slotString, class, equipSlot, link)
            end
        else
            SetItemLevelString(frame.levelString, "")
            SetItemSlotString(frame.slotString)
        end
        self.OrigItemLink = link
        self.OrigItemLevel = (level and level > 0) and level or ""
        self.OrigItemQuality = quality
        self.OrigItemClass = class
        self.OrigItemEquipSlot = equipSlot
    end
end

-- Bag
hooksecurefunc("ContainerFrame_Update", function(self)
    local id = self:GetID()
    local name = self:GetName()
    local button
    for i = 1, self.size do
        button = _G[name.."Item"..i]
        SetItemLevel(button, GetContainerItemLink(id, button:GetID()), "Bag", id, button:GetID())
    end
end)

-- Bank
hooksecurefunc("BankFrameItemButton_Update", function(self)
    if (self.isBag) then return end
    SetItemLevel(self, GetContainerItemLink(self:GetParent():GetID(), self:GetID()), "Bank")
end)

-- Merchant
hooksecurefunc("MerchantFrameItem_UpdateQuality", function(self, link)
    SetItemLevel(self.ItemButton, link, "Merchant")
end)

-- Trade
hooksecurefunc("TradeFrame_UpdatePlayerItem", function(id)
    SetItemLevel(_G["TradePlayerItem"..id.."ItemButton"], GetTradePlayerItemLink(id), "Trade")
end)
hooksecurefunc("TradeFrame_UpdateTargetItem", function(id)
    SetItemLevel(_G["TradeRecipientItem"..id.."ItemButton"], GetTradeTargetItemLink(id), "Trade")
end)

-- Loot
hooksecurefunc("LootFrame_UpdateButton", function(index)
    local button = _G["LootButton"..index]
    local numLootItems = LootFrame.numLootItems
    local numLootToShow = LOOTFRAME_NUMBUTTONS
    if (numLootItems > LOOTFRAME_NUMBUTTONS) then
		numLootToShow = numLootToShow - 1
	end
    local slot = (numLootToShow * (LootFrame.page - 1)) + index
    if (button:IsShown()) then
        SetItemLevel(button, GetLootSlotLink(slot), "Loot")
    end
end)

-- GuildBank
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
    if (addonName == "Blizzard_GuildBankUI") then
        hooksecurefunc("GuildBankFrame_Update", function()
            if (GuildBankFrame.mode == "bank") then
                local tab = GetCurrentGuildBankTab()
                local button, index, column
                for i = 1, MAX_GUILDBANK_SLOTS_PER_TAB do
                    index = mod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
                    if (index == 0) then
                        index = NUM_SLOTS_PER_GUILDBANK_GROUP
                    end
                    column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)
                    button = _G["GuildBankColumn"..column.."Button"..index]
                    SetItemLevel(button, GetGuildBankItemLink(tab, i), "GuildBank")
                end
            end
        end)
    end
end)

-- Auction
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
    if (addonName == "Blizzard_AuctionUI") then
        hooksecurefunc("AuctionFrameBrowse_Update", function()
            local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame)
            local itemButton
            for i = 1, NUM_BROWSE_TO_DISPLAY do
                itemButton = _G["BrowseButton"..i.."Item"]
                if (itemButton) then
                    SetItemLevel(itemButton, GetAuctionItemLink("list", offset+i), "Auction")
                end
            end
        end)
        hooksecurefunc("AuctionFrameBid_Update", function()
            local offset = FauxScrollFrame_GetOffset(BidScrollFrame)
            local itemButton
            for i = 1, NUM_BIDS_TO_DISPLAY do
                itemButton = _G["BidButton"..i.."Item"]
                if (itemButton) then
                    SetItemLevel(itemButton, GetAuctionItemLink("bidder", offset+i), "Auction")
                end
            end
        end)
        hooksecurefunc("AuctionFrameAuctions_Update", function()
            local offset = FauxScrollFrame_GetOffset(AuctionsScrollFrame)
            local tokenCount = C_WowTokenPublic.GetNumListedAuctionableTokens()
            local itemButton
            for i = 1, NUM_AUCTIONS_TO_DISPLAY do
                itemButton = _G["AuctionsButton"..i.."Item"]
                if (itemButton) then
                    SetItemLevel(itemButton, GetAuctionItemLink("owner", offset-tokenCount+i), "Auction")
                end
            end
        end)
    end
end)

-- ALT
if (EquipmentFlyout_DisplayButton) then
    hooksecurefunc("EquipmentFlyout_DisplayButton", function(button, paperDollItemSlot)
        local location = button.location
        if (not location) then return end
        local player, bank, bags, voidStorage, slot, bag, tab, voidSlot = EquipmentManager_UnpackLocation(location)
        if (not player and not bank and not bags and not voidStorage) then return end
        if (voidStorage) then return end
        local link
        if (bags) then
            link = GetContainerItemLink(bag, slot)
            --SetItemLevel(button, link, "AltEquipment", bag, slot)
            local ilvl = U1GetRealItemLevel(link)
            SetItemLevelString(GetItemLevelFrame(button, "AltEquipment").levelString, ilvl, nil, ilvl)
        else
            link = GetInventoryItemLink("player", slot)
            --SetItemLevel(button, link, "AltEquipment")
            local ilvl = U1GetRealItemLevel(link, "player", slot)
            SetItemLevelString(GetItemLevelFrame(button, "AltEquipment").levelString, ilvl, nil, ilvl)
        end
    end)
end

-- ForAddons: Bagnon Combuctor LiteBag ArkInventory
LibEvent:attachEvent("PLAYER_LOGIN", function()
    -- For Bagnon
    if (Bagnon and Bagnon.ItemSlot and Bagnon.ItemSlot.Update) then
        hooksecurefunc(Bagnon.ItemSlot, "Update", function(self)
            SetItemLevel(self, self:GetItem(), "Bag", self:GetBag(), self:GetID())
        end)
    end
    -- For Combuctor
    if (Combuctor and Combuctor.ItemSlot and Combuctor.ItemSlot.Update) then
        hooksecurefunc(Combuctor.ItemSlot, "Update", function(self)
            SetItemLevel(self, self:GetItem(), "Bag", self:GetBag(), self:GetID())
        end)
    elseif (Combuctor and Combuctor.Item and Combuctor.Item.Update) then
        hooksecurefunc(Combuctor.Item, "Update", function(self)
            SetItemLevel(self, self.hasItem, "Bag", self.bag, self.GetID and self:GetID())
        end)
    end
    -- For LiteBag
    if (LiteBagItemButton_UpdateItem) then
        hooksecurefunc("LiteBagItemButton_UpdateItem", function(self)
            SetItemLevel(self, GetContainerItemLink(self:GetParent():GetID(), self:GetID()), "Bag", self:GetParent():GetID(), self:GetID())
        end)
    end
    -- For ArkInventory
    if (ArkInventory and ArkInventory.Frame_Item_Update_Texture) then
        hooksecurefunc(ArkInventory, "Frame_Item_Update_Texture", function(button)
            local i = ArkInventory.Frame_Item_GetDB(button)
            if (i) then
                SetItemLevel(button, i.h, "Bag")
            end
        end)
    end
end)

-- GuildNews
LibEvent:attachEvent("ADDON_LOADED", function(self, addonName)
    if (addonName == "Blizzard_Communities" or addonName == "Blizzard_GuildUI") then
        GuildNewsItemCache = GuildNewsItemCache or {}
        hooksecurefunc(addonName == "Blizzard_Communities" and "CommunitiesGuildNewsButton_SetText" or "GuildNewsButton_SetText", function(button, text_color, text, text1, text2, ...)
            if (not TinyInspectDB or 
                not TinyInspectDB.EnableItemLevel or 
                not TinyInspectDB.EnableItemLevelGuildNews) then
              return
            end
            if (text2 and type(text2) == "string") then
                local link = string.match(text2, "|H(item:%d+:.-)|h.-|h")
                if (link) then
                    local level = GuildNewsItemCache[link] or select(2, LibItemInfo:GetItemInfo(link))
                    if (level > 0) then
                        GuildNewsItemCache[link] = level
                        if level > 220 then
                            local r,g,b = U1GetInventoryLevelColor(level)
                            local hex = ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
                            text2 = text2:gsub("%|cff......(%|Hitem:%d+:.-%|h%[)(.-)(%]%|h)", "|cff" .. hex .. "%1"..level..":%2%3")
                        elseif level >= 192 then
                            text2 = text2:gsub("(%|Hitem:%d+:.-%|h%[)(.-)(%]%|h)", "%1"..level..":%2%3")
                        end
                        button.text:SetFormattedText(text, text1, text2, ...)
                    end
                end
            end
        end)
    end
end)


-------------------
--   PaperDoll  --
-------------------

local function SetPaperDollItemLevel(self, unit)
    if (not self) then return end
    local id = self:GetID()
    local frame = GetItemLevelFrame(self, "PaperDoll")
    if (unit and self.hasItem) then
        if U1GetInventoryLevel then
            local itemLink = GetInventoryItemLink(unit, id)
            if not itemLink then SetItemLevelString(frame.levelString, "") return end
            local ilvl = U1GetRealItemLevel(itemLink, unit, id)
            SetItemLevelString(frame.levelString, ilvl, nil, ilvl)
        else
        local count, level, _, link, quality = LibItemInfo:GetUnitItemInfo(unit, id)
        SetItemLevelString(frame.levelString, level > 0 and level or "", quality)
        if (id == 16 or id == 17) then
            local _, mlevel, _, _, mquality = LibItemInfo:GetUnitItemInfo(unit, 16)
            local _, olevel, _, _, oquality = LibItemInfo:GetUnitItemInfo(unit, 17)
            if (mlevel > 0 and olevel > 0 and (mquality == 6 or oquality == 6)) then
                SetItemLevelString(frame.levelString, max(mlevel,olevel), mquality or oquality)
            end
        end
        end
    else
        SetItemLevelString(frame.levelString, "")
    end
end

--[[
hooksecurefunc("PaperDollItemSlotButton_OnShow", function(self, isBag)
    SetPaperDollItemLevel(self, "player")
end)

hooksecurefunc("PaperDollItemSlotButton_OnEvent", function(self, event, id, ...)
    if (event == "PLAYER_EQUIPMENT_CHANGED" and self:GetID() == id) then
        SetPaperDollItemLevel(self, "player")
    end
end)
--]]

LibEvent:attachTrigger("UNIT_INSPECT_READY", function(self, data)
    if (InspectFrame and InspectFrame.unit and UnitGUID(InspectFrame.unit) == data.guid) then
        for _, button in ipairs({
             InspectHeadSlot,InspectNeckSlot,InspectShoulderSlot,InspectBackSlot,InspectChestSlot,InspectWristSlot,
             InspectHandsSlot,InspectWaistSlot,InspectLegsSlot,InspectFeetSlot,InspectFinger0Slot,InspectFinger1Slot,
             InspectTrinket0Slot,InspectTrinket1Slot,InspectMainHandSlot,InspectSecondaryHandSlot
            }) do
            SetPaperDollItemLevel(button, InspectFrame.unit)
        end
    end
end)


----------------------
--  Chat ItemLevel  --
----------------------

local itemStatTable = {}
local ARMOR_TYPES = {} --{["板甲"]=true, ...}
for i=1, 4 do ARMOR_TYPES[GetItemSubClassInfo(4,i)] = true end
local typeTexts = { INVTYPE_HEAD = "头", INVTYPE_SHOULDER = "肩", INVTYPE_CHEST = "胸", INVTYPE_WAIST = "腰", INVTYPE_LEGS = "腿", INVTYPE_HAND = "手", INVTYPE_FEET = "鞋", INVTYPE_WRIST = "腕", }
local Caches = {}
_G.TI_REPLACE_CACHE = Caches

local function ChatItemLevel(Hyperlink)
    if (Caches[Hyperlink]) then
        return Caches[Hyperlink]
    end
    local link = string.match(Hyperlink, "|H(.-)|h")
    local name, _, quality, _, _, class, subclass, _, equipSlot, texture = GetItemInfo(link)
    if (not texture) then return end
	local Origin = Hyperlink
    local level = select(2, LibItemInfo:GetItemInfo(link))
    local yes = true
    if (level) then
        if (equipSlot and string.find(equipSlot, "INVTYPE_")) then
            level = format("%s%s", level, (ARMOR_TYPES[subclass] and subclass or "")..(typeTexts[equipSlot] or _G[equipSlot] or equipSlot))
        elseif (class == ARMOR) then
            level = format("%s%s", level, class)
        elseif (subclass and string.find(subclass, RELICSLOT)) then
            level = format("%s%s", level, RELICSLOT)
        else
            yes = false
        end
        if (yes) then
            local gem = ""
            if quality ~= 6 then
                -- 神器不显示宝石孔
                wipe(itemStatTable)
                GetItemStats(link, itemStatTable)
                for key, num in pairs(itemStatTable) do
                    if (string.find(key, "EMPTY_SOCKET_")) then
                        gem = gem .. "|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t"
                        break
                    end
                end
            end
			--[[
            for i = 1, num do
                gem = gem .. "|TInterface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic:0|t"
            end
            if (gem ~= "") then gem = gem.." " end
			--]]
            Hyperlink = Hyperlink:gsub("|h%[(.-)%]|h", "|h["..level..":"..name.."]|h"..gem)
        end
        Caches[Origin] = Hyperlink
    end
    return Hyperlink
end

local function filter(self, event, msg, ...)
    if (TinyInspectDB and TinyInspectDB.EnableItemLevelChat) then
        msg = msg:gsub("(|Hitem:%d+:.-|h.-|h)", ChatItemLevel)
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


-- 位置設置
LibEvent:attachTrigger("ITEMLEVEL_FRAME_SHOWN", function(self, frame, parent, category)
    if (TinyInspectDB and not TinyInspectDB["EnableItemLevel"..category]) then
        return frame:Hide()
    end
    if (TinyInspectDB and TinyInspectDB.PaperDollItemLevelOutsideString) then
        return
    end
    local anchorPoint = TinyInspectDB and TinyInspectDB.ItemLevelAnchorPoint
    if (frame.anchorPoint ~= anchorPoint) then
        frame.anchorPoint = anchorPoint
        frame.levelString:ClearAllPoints()
        frame.levelString:SetPoint(anchorPoint or "TOP")
        if anchorPoint == "TOPLEFT" then frame.levelString:SetPoint("TOPLEFT", 1, -1) end
    end
end)

-- OutsideString For PaperDoll ItemLevel
LibEvent:attachTrigger("ITEMLEVEL_FRAME_CREATED", function(self, frame, parent)
    if (TinyInspectDB and TinyInspectDB.PaperDollItemLevelOutsideString) then
        local name = parent:GetName()
        if (name and string.match(name, "^[IC].+Slot$")) then
            local id = parent:GetID()
            frame:ClearAllPoints()
            frame.levelString:ClearAllPoints()
            if (id <= 5 or id == 9 or id == 15 or id == 19) then
                frame:SetPoint("LEFT", parent, "RIGHT", 7, -1)
                frame.levelString:SetPoint("TOPLEFT")
                frame.levelString:SetJustifyH("LEFT")
            elseif (id == 17) then
                frame:SetPoint("LEFT", parent, "RIGHT", 5, 1)
                frame.levelString:SetPoint("TOPLEFT")
                frame.levelString:SetJustifyH("LEFT")
            elseif (id == 16) then
                frame:SetPoint("RIGHT", parent, "LEFT", -5, 1)
                frame.levelString:SetPoint("TOPRIGHT")
                frame.levelString:SetJustifyH("RIGHT")
            else
                frame:SetPoint("RIGHT", parent, "LEFT", -7, -1)
                frame.levelString:SetPoint("TOPRIGHT")
                frame.levelString:SetJustifyH("RIGHT")
            end
        end
    end
end)
