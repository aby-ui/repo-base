
local tdPack = tdCore(...)

local ipairs, sort, wipe = ipairs, sort, wipe

local Rule = tdPack:NewModule('Rule')

local compareStrings = {}

function Rule:New(tbl, default)
    local obj = {}
    
    obj.__unknownOrder = default
    for i, v in ipairs(tbl) do
        obj[v] = default and i or true
    end
    
    return obj
end

------ order

local specialReagent = {
    190315,190316,190326,190327,190320,190321,190328,190329,190451,190450,
    190324,190322,190331,190330,    191529,191526,
} for _, v in ipairs(specialReagent) do specialReagent[v] = true end

function Rule:CleanSpecialCompareString()
    if TDPACK_ONLY_REAGENT then
        wipe(compareStrings)
    end
end

--- 把能使用的物品交换到背包里
function Rule:SwapSpecialReagentItems(bags)
    if TDPACK_ONLY_REAGENT then
        if #bags[1].bags > 1 then
            --表示整理了2个材料包，即打开了银行
            local bank = bags[1].bags[1]
            local bag = bags[1].bags[2]
            C_Timer.After(0.5, function()
                local bagSlot, bagTotal = 1, C_Container.GetContainerNumSlots(bag)
                for i=1,C_Container.GetContainerNumSlots(bank) do
                    local itemID = C_Container.GetContainerItemID(bank, i)
                    if itemID and specialReagent[itemID] then
                        local swapped = false
                        for j = bagSlot, bagTotal do
                            itemID = C_Container.GetContainerItemID(bag, j)
                            if not itemID or not specialReagent[itemID] then
                                C_Container.PickupContainerItem(bank, i)
                                C_Container.PickupContainerItem(bag, j)
                                bagSlot = j + 1
                                swapped = true
                                break
                            end
                        end
                        if not swapped then return end
                    end
                end
            end)
        end
    end
end

function Rule:GetJunkOrder(item)
    if TDPACK_ONLY_REAGENT then
        --材料银行不会有垃圾和装备，所以开头就是版本号
        if tdPack:IsReversePack() then
            return specialReagent[item:GetItemID()] and 1 or (20 - item:GetItemExpansion()) --优先背包，则新版本在前
        else
            return specialReagent[item:GetItemID()] and 99 or item:GetItemExpansion() + 1
        end
    end
    --abyui 灰色垃圾在最前面,以3开头,低级绿装以2开头
    if(item:GetItemQuality() == 0)then return 3 end
    if(item:GetItemEquipLoc() ~= '')then
        --绿装且等级比当前平均装备小100次之
        if(item:GetItemQuality() <= 2 and item:GetItemLevel() <= GetAverageItemLevel() * 0.88) then return 2 end
        --其他低等级装备暂时不处理
        --if(item:GetItemLevel() <= GetAverageItemLevel() - 100) then return 1 end
    end
    return 0
end

function Rule:GetCustomOrder(item)
    return self.CustomOrder[item:GetItemID()] or self.CustomOrder[item:GetItemName()]
end

function Rule:GetTypeOrder(item)
    return  self.CustomOrder['#'  .. item:GetItemType() .. '##' .. item:GetItemSubType()] or
            self.CustomOrder['##' .. item:GetItemSubType()] or
            self.CustomOrder['#'  .. item:GetItemType()] or
            self.CustomOrder.__unknownOrder
end

function Rule:GetEquipLocOrder(item)
    local q = item:GetItemQuality()
    if q == 6 then return 0 end
    if q == 5 then return 1 end
    return (self.EquipLocOrder[item:GetItemEquipLoc()] or self.EquipLocOrder.__unknownOrder) + 2
end

function Rule:GetLevelOrder(item)
    return 9999 - item:GetItemLevel()
end

--163ui 消耗品-其他-按图标排序, 尽量把要塞的垃圾和升级分到一起
local consumable = GetItemClassInfo(LE_ITEM_CLASS_CONSUMABLE)
local consumableOthers = GetItemSubClassInfo(LE_ITEM_CLASS_CONSUMABLE, 8)
function Rule:GetQualityOrder(item)
    if(item:GetItemType() == consumable and item:GetItemSubType() == consumableOthers) then
        return item:GetItemTexture()
    else
        return 99 - item:GetItemQuality()
    end
end

--/dump tdCore("tdPack"):GetModule("Rule"):GetCompareString(tdPackItem:NewByID(129317))
function Rule:GetCompareString(item)
    local itemID = item:GetItemID()
    if not compareStrings[itemID] then
        local idOrder = self:GetCustomOrder(item)
        
        compareStrings[itemID] = idOrder and ('00%03d'):format(idOrder) or ('%02d%03d%02d%s%s%08d%04d%s'):format(
            self:GetJunkOrder(item),
            self:GetTypeOrder(item),
            self:GetEquipLocOrder(item),
            item:GetItemType(),
            item:GetItemSubType(),
            self:GetQualityOrder(item),
            self:GetLevelOrder(item),
            item:GetItemName()
        )
    end
    return compareStrings[itemID]
end

------ bank

function Rule:IsNeed(item, rule)
    if rule[item:GetItemID()] then
        return true
    end
    
    return  rule[item:GetItemName()] or
            rule['#' .. item:GetItemType() .. '##' .. item:GetItemSubType()] or
            rule['##' .. item:GetItemSubType()] or
            rule['#' .. item:GetItemType()]
end

function Rule:NeedSaveToBank(item)
    return Rule:IsNeed(item, self.SaveToBank)
end

function Rule:NeedLoadToBag(item)
    return Rule:IsNeed(item, self.LoadFromBank)
end

------ other

local function sortCompare(a, b)
    return Rule:GetCompareString(a) < Rule:GetCompareString(b)
end

function Rule:SortItems(items)
    sort(items, sortCompare)
end

function Rule:BuildRule()
    local profile = tdPack:GetProfile()

    self.CustomOrder   = Rule:New(profile.Orders.CustomOrder, 999)
    self.EquipLocOrder = Rule:New(profile.Orders.EquipLocOrder, 99)
    self.SaveToBank    = Rule:New(profile.SaveToBank)
    self.LoadFromBank  = Rule:New(profile.LoadFromBank)
end

function Rule:OnProfileUpdate()
    wipe(compareStrings)
    
    self:BuildRule()
end

function Rule:OnInit()
    self:BuildRule()
    self:SetHandle('OnProfileUpdate', self.OnProfileUpdate)
end
