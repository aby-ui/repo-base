
local assert, ipairs, pairs, ripairs = assert, ipairs, pairs, ripairs
local tinsert, tremove, wipe = table.insert, table.remove, wipe

local tdPack = tdCore(...)

local Group = tdPack('Group')
local Rule = tdPack('Rule')
local Bag = tdPack:NewModule('Bag')

local bagClasses = {
    bag = {0, 1, 2, 3, 4},
    bank = {-1, 5, 6, 7, 8, 9, 10, 11},
    reagent = {-3},
}

tdPack_BAGS = bagClasses

function Bag:New(bagClass)
    assert(bagClasses[bagClass])
    
    local obj = self:Bind{}
    
    obj.bags = bagClasses[bagClass]
    obj.bagClass = bagClass
    obj.groups = {}
    obj.swapItems = {}
    
    obj:InitGroups()
    
    return obj
end

function Bag:InitGroups()
    local initedGroups = {}
    for _, bag in ipairs(self.bags) do
        local bagFamily = tdPack:GetBagFamily(bag)
        if bagFamily and not initedGroups[bagFamily] then
            initedGroups[bagFamily] = true
            
            local group = Group:New(self, bagFamily)
            if bagFamily == 0 then
                self.groups[0] = group
            else
                tinsert(self.groups, group)
            end
        end
    end
end

function Bag:GetBags()
    return self.bags
end

function Bag:IterateGroups()
    return pairs(self.groups)
end

function Bag:IterateTradeGroups()
    return ipairs(self.groups)
end

function Bag:GetNormalGroup()
    return self.groups[0]
end

function Bag:IsLocked()
    for _, group in self:IterateGroups() do
        if group:IsLocked() then
            return true
        end
    end
end

function Bag:Pack()
    local complete = true
    for _, group in self:IterateGroups() do
        local success, result = group:Pack()
        if not success then
            self:Debug(result)
            complete = false
        end
    end
    return complete
end

function Bag:FindSlot(item, tarSlot)
    for _, group in self:IterateGroups() do
        local slot = group:FindSlot(item, tarSlot)
        if slot then
            return slot
        end
    end
end

function Bag:ChooseItems(items)
    for _, group in self:IterateTradeGroups() do
        group:ChooseItems(items)
    end
    self:GetNormalGroup():ChooseItems(items)
end

function Bag:RestoreItems()
    for _, item in ripairs(self.swapItems) do
        tinsert(item:GetParent():GetItems(), item)
    end
    wipe(self.swapItems)
end

function Bag:Sort()
    for _, group in self:IterateTradeGroups() do
        group:ChooseItems(self:GetNormalGroup():GetItems())
    end
    for _, group in self:IterateGroups() do
        group:SortItems()
        group:FilterSlots()
    end
end

function Bag:GetSwapItems()
    wipe(self.swapItems)
    
    local methodName = self.bagClass == 'bag' and 'NeedSaveToBank' or 'NeedLoadToBag'
    
    for _, group in self:IterateGroups() do
        local items = group:GetItems()
        for index, item in ripairs(items) do
            if item[methodName](item) then
                tremove(items, index)
                tinsert(self.swapItems, item)
            end
        end
    end
    Rule:SortItems(self.swapItems)
    
    return self.swapItems
end
