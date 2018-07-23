
local band = bit.band
local ipairs, ripairs = ipairs, ripairs
local random = math.random
local tinsert, tremove = table.insert, table.remove

local tdPack = tdCore(...)

local Slot = tdPack('Slot')
local Item = tdPack('Item')
local Rule = tdPack('Rule')
local Group = tdPack:NewModule('Group', {}, 'Base')

function Group:New(parent, family)
    local obj = self:Bind{}
    
    obj.family = family
    obj.slots = {}
    obj.items = {}
    obj:SetParent(parent)
    
    obj:InitSlots()
    obj:InitItems()
    
    return obj
end

function Group:GetFamily()
    return self.family
end

---- slots

function Group:InitSlots()
    local bags = self:GetParent():GetBags()
    
    if tdPack:IsReversePack() then
        for _, bag in ripairs(bags) do
            if tdPack:GetBagFamily(bag) == self.family then
                for slot = tdPack:GetBagNumSlots(bag), 1, -1 do
                    tinsert(self.slots, Slot:New(self, bag, slot))
                end
            end
        end
    else
        for _, bag in ipairs(bags) do
            if tdPack:GetBagFamily(bag) == self.family then
                for slot = 1, tdPack:GetBagNumSlots(bag) do
                    tinsert(self.slots, Slot:New(self, bag, slot))
                end
            end
        end
    end
end

function Group:GetSlotCount()
    return #self.slots
end

function Group:GetSlot(index)
    return self.slots[index]
end

---- items

function Group:InitItems()
    for _, slot in ipairs(self.slots) do
        local item = Item:New(self, slot:GetBag(), slot:GetSlot())
        if item then
            tinsert(self.items, item)
        end
    end
end

function Group:SortItems()
    Rule:SortItems(self.items)
end

function Group:GetItemCount()
    return #self.items
end

function Group:GetItem(index)
    return self.items[index]
end

function Group:GetItems()
    return self.items
end

---- pack

function Group:IsPackFinish()
    return #self.items == 0
end

function Group:Pack()
    while not self:IsPackFinish() do
        if InCombatLockdown() then
            return false, 'pack: player in combat'
        end
        
        local tarSlot, index = self:GetIdleSlot()
        if not tarSlot then
            return false, 'pack: not found slot'
        end
        
        local item = self.items[index]
        if item:GetItemID() ~= tarSlot:GetItemID() then
            local slot = tdPack:FindSlot(item, tarSlot)
            if not slot then
                return false, 'pack: not found target slot ' .. item:GetItemName() .. ' goto ' .. tarSlot.bag .. ' ' .. tarSlot.slot
            end
            
            local success, result = slot:MoveTo(tarSlot)
            if not success then
                return false, 'pack: move fail ' .. result
            end
        end
        
        tremove(self.items, index)
        tremove(self.slots, index)
    end
    return true
end

function Group:GetIdleSlot()
    local step = random(0, 1) == 0 and -1 or 1
    local e = random(1, self:GetItemCount())
    local i = e
    
    repeat
        local slot = self:GetSlot(i)
        if not slot:IsLocked() then
            return slot, i
        end 
        i = (i - 1 + step) % self:GetItemCount() + 1
    until i == e
end

function Group:FindSlot(item, tarSlot)
    if not self:CanPutSlot(tarSlot) then
        return
    end
    for _, slot in ripairs(self.slots) do
        if slot:GetItemID() == item:GetItemID() and not slot:IsLocked() then
            return slot
        end
    end
end

function Group:FilterSlots()
    for i = self:GetSlotCount(), self:GetItemCount() + 1, -1 do
        if self:GetSlot(i):IsEmpty() then
            tremove(self.slots, i)
        end
    end

    for i, item in ripairs(self.items) do
        if self:GetSlot(i):GetItemID() == item:GetItemID() then
            tremove(self.slots, i)
            tremove(self.items, i)
        end
    end
end

function Group:IsFull()
    return self:GetItemCount() == self:GetSlotCount()
end

function Group:CanPutItem(item)
    local family = self:GetFamily()
    if family == 0 then
        return true
    end
    return band(family, item:GetFamily()) > 0
end

function Group:CanPutSlot(slot)
    if slot:IsEmpty() then
        return true
    end
    return self:CanPutItem(slot)
end

function Group:ChooseItems(items)
    for i, item in ripairs(items) do
        if self:IsFull() then
            return
        end
        
        if self:CanPutItem(item) then
            tremove(items, i)
            tinsert(self.items, item)
        end
    end
end
