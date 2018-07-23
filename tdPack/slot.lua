
local InCombatLockdown = InCombatLockdown

local tdPack = tdCore(...)

local Slot = tdPack:NewModule('Slot', {}, 'Base')

function Slot:New(parent, bag, slot)
    local obj = self:Bind{}
    
    obj:SetParent(parent)
    obj.bag = bag
    obj.slot = slot
    
    return obj
end

function Slot:GetBag()
    return self.bag
end

function Slot:GetSlot()
    return self.slot
end

function Slot:GetItemID()
    return tdPack:GetBagSlotID(self.bag, self.slot)
end

function Slot:GetFamily()
    return tdPack:GetBagSlotFamily(self.bag, self.slot)
end

function Slot:IsEmpty()
    return tdPack:IsBagSlotEmpty(self.bag, self.slot)
end

function Slot:IsFull()
    return tdPack:IsBagSlotFull(self.bag, self.slot)
end

function Slot:IsLocked()
    return tdPack:IsBagSlotLocked(self.bag, self.slot)
end

function Slot:MoveTo(slot)
    if self:IsEmpty() then
        if slot:IsEmpty() then
            return true
        else
            return slot:MoveTo(self)
        end
    end
    
    if InCombatLockdown() then
        return false, 'player in combat'
    end
    
    if self:IsLocked() or slot:IsLocked() then
        return false, 'some slot is locked'
    end
    
    tdPack:PickupBagSlot(self.bag, self.slot)
    tdPack:PickupBagSlot(slot.bag, slot.slot)
    
    return true
end
