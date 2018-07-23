
local type, tonumber = type, tonumber

local tdPack = tdCore(...)

local Rule = tdPack('Rule')
local Item = tdPack:NewModule('Item', {}, 'Base')

function Item:New(parent, bag, slot)
    local itemID = tdPack:GetBagSlotID(bag, slot)
    if not itemID then
        return
    end

    local itemName, itemType, itemSubType, itemEquipLoc, itemQuality, itemLevel, itemTexture = tdPack:GetItemInfo(itemID)

    if type(itemID) == 'number' then
        local itemLink = tdPack:GetBagSlotLink(bag, slot)
        itemLevel = U1GetItemLevelByScanTooltip(itemLink)
    end

    if not itemName then return end  --163ui sometime can't get iteminfo , 2016.9

    local obj = self:Bind{}
    obj:SetParent(parent)
    obj.itemID = itemID
    obj.itemName = itemName
    obj.itemType = itemType
    obj.itemSubType = itemSubType
    obj.itemEquipLoc = itemEquipLoc
    obj.itemQuality = itemQuality
    obj.itemLevel = itemLevel
    obj.itemTexture = itemTexture
    
    return obj
end

function Item:GetFamily()
    local itemID = self:GetItemID()
    
    return type(itemID) == 'string' and 0 or GetItemFamily(itemID)
end

function Item:NeedSaveToBank()
    if tdPack:IsLoadToBag() then
        return Rule:NeedSaveToBank(self) and not Rule:NeedLoadToBag(self)
    else
        return Rule:NeedSaveToBank(self)
    end
end

function Item:NeedLoadToBag()
    if tdPack:IsSaveToBank() then
        return Rule:NeedLoadToBag(self) and not Rule:NeedSaveToBank(self)
    else
        return Rule:NeedLoadToBag(self)
    end
end

function Item:GetItemID()
    return self.itemID or 0
end

function Item:GetItemName()
    return self.itemName or ''
end

function Item:GetItemType()
    return self.itemType or ''
end

function Item:GetItemSubType()
    return self.itemSubType or ''
end

function Item:GetItemLevel()
    return self.itemLevel or ''
end

function Item:GetItemQuality()
    return self.itemQuality or 1
end

function Item:GetItemTexture()
    return self.itemTexture or ''
end

function Item:GetItemEquipLoc()
    return self.itemEquipLoc or ''
end

---163ui for test
function Item:NewByLink(itemLink)
    local itemID = GetItemInfo(itemLink)
    if not itemID then
        return
    end

    local itemName, itemType, itemSubType, itemEquipLoc, itemQuality, itemLevel, itemTexture = tdPack:GetItemInfo(itemID)

    if type(itemID) == 'number' then
        itemLevel = U1GetItemLevelByScanTooltip(itemLink)
    end

    if not itemName then return end  --163ui sometime can't get iteminfo , 2016.9

    local obj = self:Bind{}
    obj.itemID = itemID
    obj.itemName = itemName
    obj.itemType = itemType
    obj.itemSubType = itemSubType
    obj.itemEquipLoc = itemEquipLoc
    obj.itemQuality = itemQuality
    obj.itemLevel = itemLevel
    obj.itemTexture = itemTexture

    return obj
end
_G["tdPackItem"] = Item  --tdCore("tdPack"):GetModule("Item")