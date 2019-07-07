
local tdPack = tdCore(...)

local ipairs, ripairs, wipe = ipairs, ripairs, wipe
local tinsert, tremove = table.insert, table.remove

local Bag = tdPack('Bag')
local Slot = tdPack('Slot')
local Pack = tdPack:NewModule('Pack', CreateFrame('Frame'), 'Event', 'Update')
_G.tdPack = Pack
local L = tdPack:GetLocale()

local STATUS_FREE       = 0
local STATUS_READY      = 1
local STATUS_STACKING   = 2
local STATUS_STACKED    = 3
local STATUS_PACKING    = 4
local STATUS_PACKED     = 5
local STATUS_FINISH     = 6
local STATUS_CANCEL     = 7

Pack.isBankOpened = nil
Pack.status = STATUS_FREE
Pack.slots = {}
Pack.bags = {}

function Pack:IsLocked()
    for _, bag in ipairs(self.bags) do
        if bag:IsLocked() then
            return true
        end
    end
end

function Pack:FindSlot(item, tarSlot)
    for _, bag in ipairs(self.bags) do
        local slot = bag:FindSlot(item, tarSlot)
        if slot then
            return slot
        end
    end
end

function Pack:Start()
    if self.status ~= STATUS_FREE then
        self:ShowMessage(L['Packing now'], 1, 0, 0)
        return
    end
    
    if UnitIsDead('player') then
        self:ShowMessage(L['Player is dead'], 1, 0, 0)
        return
    end
    
    if InCombatLockdown() then
        self:ShowMessage(L['Player in combat'], 1, 0, 0)
        return
    end
    
    if GetCursorInfo() then
        self:ShowMessage(L['Please drop the item, money or skills.'], 1, 0, 0)
        return
    end
    
    self:SetStatus(STATUS_READY)
    self:StartUpdate(0.05)
end

function Pack:Stop()
    self:StopUpdate()
    
    wipe(self.bags)
    wipe(self.slots)
    self:SetStatus(STATUS_FREE)
end

function Pack:ShowMessage(text, r, g, b)
    tdPack:ShowMessage('|cff45afd3tdPack: |r' .. text, r, g, b)
end

------ stack

local bags = {
    bag = {0, 1, 2, 3, 4},
    bank = {0, 1, 2, 3, 4, -1, 5, 6, 7, 8, 9, 10, 11},
}

function Pack:StackReady()
	local ignored_bank = JPACK_IGNORE_BAGS_NO_BANK
    for _, bag in ipairs(self.isBankOpened and not ignored_bank and bags.bank or bags.bag) do
        for slot = 1, tdPack:GetBagNumSlots(bag) do
            if not tdPack:IsBagSlotEmpty(bag, slot) and not tdPack:IsBagSlotFull(bag, slot) then
                tinsert(self.slots, Slot:New(nil, bag, slot))
            end
        end
    end
end

function Pack:Stack()
    local stackingSlots = {}
    local complete = true
    
    for i, slot in ripairs(self.slots) do
        if slot:IsLocked() then
            complete = false
        else
            if not slot:IsEmpty() and not slot:IsFull() then
                local itemID = slot:GetItemID()
                if stackingSlots[itemID] then
                    slot:MoveTo(stackingSlots[itemID])
                    
                    stackingSlots[itemID] = nil
                    complete = false
                else
                    stackingSlots[itemID] = slot
                end
            else
                tremove(self.slots, i)
            end
        end
    end
    return complete
end

function Pack:StackFinish()
    wipe(self.slots)
end

function Pack:PackReady()
    wipe(self.bags)

    if TDPACK_ONLY_REAGENT then
        local reagent = Bag:New('reagent')
        tinsert(self.bags, reagent)
        return reagent:Sort()
    end

    local bag, bank
	local ignored = TDPACK_IGNORE_BAGS
	local ignored_bank = TDPACK_IGNORE_BAGS_NO_BANK
    
    bag = Bag:New('bag')
	if not ignored then
		tinsert(self.bags, bag)
	end
    
    if self.isBankOpened then
        bank = Bag:New('bank')
		if not ignored_bank then
			tinsert(self.bags, bank)
		end
        
        if tdPack:IsLoadToBag() and tdPack:IsSaveToBank() then
            local loadTo = bank:GetSwapItems()
            local saveTo = bag:GetSwapItems()
            
            bag:ChooseItems(loadTo)
            bank:ChooseItems(saveTo)
            
            bag:RestoreItems()
            bank:RestoreItems()
        elseif tdPack:IsLoadToBag() then
            local loadTo = bank:GetSwapItems()
            bag:ChooseItems(loadTo)
            bank:RestoreItems()
        elseif tdPack:IsSaveToBank() then
            local saveTo = bag:GetSwapItems()
            bank:ChooseItems(saveTo)
            bag:RestoreItems()
        end
        
        bank:Sort()
    end
    bag:Sort()
end

function Pack:Pack()
    local complete = true
    for _, bag in ipairs(self.bags) do
        if not bag:Pack() then
            complete = false
        end
    end
    return complete
end

function Pack:PackFinish()
    wipe(self.bags)
	TDPACK_IGNORE_BAGS = nil
	TDPACK_IGNORE_BAGS_NO_BANK = nil
    TDPACK_ONLY_REAGENT = nil
end

------ status

function Pack:SetStatus(status)
    self.status = status
end

function Pack:StatusReady()
    if self:IsLocked() then
        return
    end
    
    self:StackReady()
    self:SetStatus(STATUS_STACKING)
end

function Pack:StatusStacking()
    if not self:Stack() then
        return
    end
    
    self:SetStatus(STATUS_STACKED)
    self:StackFinish()
end

function Pack:StatusStacked()
    if self:IsLocked() then
        return
    end
    
    self:PackReady()
    self:SetStatus(STATUS_PACKING)
end

function Pack:StatusPacking()
    if not self:Pack() then
        return
    end
    
    self:SetStatus(STATUS_PACKED)
    self:PackFinish()
end

function Pack:StatusPacked()
    self:SetStatus(STATUS_FINISH)
end

function Pack:StatusFinish()
    self:Stop()
    self:ShowMessage(L['Pack finish.'], 0, 1, 0)
end

function Pack:StatusCancel()
    self:Stop()
end

Pack.statusProc = {
    [STATUS_READY]    = Pack.StatusReady,
    [STATUS_STACKING] = Pack.StatusStacking,
    [STATUS_STACKED]  = Pack.StatusStacked,
    [STATUS_PACKING]  = Pack.StatusPacking,
    [STATUS_PACKED]   = Pack.StatusPacked,
    [STATUS_FINISH]   = Pack.StatusFinish,
    [STATUS_CANCEL]   = Pack.StatusCancel,
}

function Pack:OnUpdate()
    local proc = self.statusProc[self.status]
    if proc then
        proc(self)
    end
end

------ event

function Pack:BANKFRAME_OPENED()
    self.isBankOpened = true
end

function Pack:BANKFRAME_CLOSED()
    if self.isBankOpened and self.status ~= STATUS_FREE then
        self:SetStatus(STATUS_CANCEL)
        self:ShowMessage(L['Leave bank, pack cancel.'], 1, 0, 0)
    end
    self.isBankOpened = nil
end

function Pack:PLAYER_REGEN_DISABLED()
    if self.status ~= STATUS_FREE then
        self:SetStatus(STATUS_CANCEL)
        self:ShowMessage(L['Player enter combat, pack cancel.'], 1, 0, 0)
    end
end

function Pack:OnInit()
    self:RegisterEvent('BANKFRAME_OPENED')
    self:RegisterEvent('BANKFRAME_CLOSED')
    self:RegisterEvent('PLAYER_REGEN_DISABLED')
end
