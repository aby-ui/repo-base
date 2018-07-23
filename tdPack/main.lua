
local tdPack = tdCore:NewAddon(...)
local L = tdPack:GetLocale()

function tdPack:ShowMessage(text, r, g, b)
    local profile = self:GetProfile()
    
    if profile.showmessage then
        (profile.messageframe == 1 and DEFAULT_CHAT_FRAME or UIErrorsFrame):AddMessage(text, r or 1, g or 1, b or 1, 1)
    end
end

tdPack:RegisterEmbed('Base', {
    GetParent = function(obj) 
        return obj.parent
    end,
    SetParent = function(obj, parent)
        obj.parent = parent
    end,
})

local select = select

local GetItemInfo = GetItemInfo
local PickupContainerItem = PickupContainerItem
local GetContainerItemID = GetContainerItemID
local GetContainerItemInfo = GetContainerItemInfo
local GetContainerItemLink = GetContainerItemLink
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetPetInfoBySpeciesID = C_PetJournal.GetPetInfoBySpeciesID

local BATTLE_PET = GetItemClassInfo(LE_ITEM_CLASS_BATTLEPET)
local BATTLE_PET_SUBTYPES = {}
for i=1, 100 do local sub = GetItemSubClassInfo(LE_ITEM_CLASS_BATTLEPET, i) if not sub or sub=="" then break end table.insert(BATTLE_PET_SUBTYPES, sub) end

function tdPack:GetItemID(itemLink)
    if not itemLink then
        return
    end
    
    if itemLink:find('battlepet') then
        local id, level, quality = itemLink:match('battlepet:(%d+):(%d+):(%d+)')
        
        return (('battlepet:%d:%d:%d'):format(id, level, quality))
    else
        return (tonumber(itemLink:match('item:(%d+)')))
    end
end

function tdPack:GetItemInfo(itemID)
    local itemName, itemType, itemSubType, itemEquipLoc, itemQuality, itemLevel, itemTexture
    if type(itemID) == 'number' then
        itemName, _, itemQuality, itemLevel, _, itemType, itemSubType, _, itemEquipLoc, itemTexture = GetItemInfo(itemID)
    else
        local SpeciesID
        SpeciesID, itemLevel, itemQuality = itemID:match('battlepet:(%d+):(%d+):(%d+)')
        itemName, itemTexture, itemSubType = GetPetInfoBySpeciesID(tonumber(SpeciesID))
        itemType = BATTLE_PET
        itemSubType = BATTLE_PET_SUBTYPES[itemSubType]
    end
    
    return itemName, itemType, itemSubType, itemEquipLoc, itemQuality, itemLevel, itemTexture
end

---- bag slot

function tdPack:GetBagSlotLink(bag, slot)
    return GetContainerItemLink(bag, slot)
end

function tdPack:GetBagSlotID(bag, slot)
    local itemLink = GetContainerItemLink(bag, slot)
    if not itemLink then
        return
    end
    return self:GetItemID(itemLink)
end

function tdPack:GetBagSlotFamily(bag, slot)
    local itemID = self:GetBagSlotID(bag, slot)
    if not itemID then
        return 0
    end
    
    return type(itemID) == 'string' and 0 or GetItemFamily(itemID)
end

function tdPack:IsBagSlotEmpty(bag, slot)
    return not GetContainerItemID(bag, slot)
end

function tdPack:IsBagSlotFull(bag, slot)
    local itemID = GetContainerItemID(bag, slot)
    if not itemID then
        return false
    end
    
    local stackCount = select(8, GetItemInfo(itemID))
    if stackCount == 1 then
        return true
    end
    
    return stackCount == (select(2, GetContainerItemInfo(bag, slot)))
end

function tdPack:IsBagSlotLocked(bag, slot)
    return (select(3, GetContainerItemInfo(bag, slot)))
end

function tdPack:PickupBagSlot(bag, slot)
    PickupContainerItem(bag, slot)
end

---- bag

function tdPack:GetBagFamily(bag)
    return (select(2, GetContainerNumFreeSlots(bag)))
end

function tdPack:GetBagNumSlots(bag)
    return (GetContainerNumSlots(bag))
end

function tdPack:FindSlot(item, tarSlot)
    return self:GetModule('Pack'):FindSlot(item, tarSlot)
end

function tdPack:IsReversePack()
    --return self.desc
	return self:GetProfile().desc
end

function tdPack:SetReversePack(desc)
    --self.desc = desc
	self:GetProfile().desc = desc
end

function tdPack:SetLoadToBag(en)
    self.loadtobag = en
end

function tdPack:SetSaveToBank(en)
    self.savetobank = en
end

function tdPack:IsSaveToBank()
    return self.savetobank
end

function tdPack:IsLoadToBag()
    return self.loadtobag
end

function tdPack:OnInit()
    self:RegisterCmd('/tdpack', '/tdp', '/tp')
    self:SetHandle('OnSlashCmd', self.Pack)
    
    self:InitDB('TDDB_TDPACK', {
        showmessage = true,
        messageframe = 2,
        
        SaveToBank = {},
        LoadFromBank = {},
        Orders = {
            CustomOrder = {},
            EquipLocOrder = {},
        }
    }, true)
    
    do
        local profile = self:GetProfile()
        
        if #profile.Orders.CustomOrder == 0 then
            profile.Orders.CustomOrder = self.DefaultCustomOrder or {}
        end
        if #profile.Orders.EquipLocOrder == 0 then
            profile.Orders.EquipLocOrder = self.DefaultEquipLocOrder or {}
        end

        self.DefaultEquipLocOrder = nil
    end
    
    self:LoadOption()
    
    self:InitMinimap{
        itemList = tdPack.PackMenu, angle = -253, icon = [[Interface\Icons\INV_Misc_Gift_03]],
        note = {
            'tdPack', L['<Left Click> '] .. L['Pack bags'], L['<Right Click> '] .. L['Show pack menu']
        },
        scripts = {
            OnCall = function()
                self:Pack()
            end,
        }
    }

    --Default order could be updated automatically.
    if TDDB_TDPACK._LAST_DEFAULT_ORDER then
        local same = true
        for i, v in ipairs(self:GetProfile().Orders.CustomOrder) do
            if TDDB_TDPACK._LAST_DEFAULT_ORDER[i] ~= v then
                same = false
                break
            end
        end
        if same then
            for i,v in ipairs(self.DefaultCustomOrder) do
                if TDDB_TDPACK._LAST_DEFAULT_ORDER[i] ~= v then
                    self:GetProfile().Orders.CustomOrder = self.DefaultCustomOrder
                    U1Message("背包整理(tdPack)的整理顺序已更新.")
                    break
                end
            end
        end
    end
    TDDB_TDPACK._LAST_DEFAULT_ORDER = self.DefaultCustomOrder
    self.DefaultCustomOrder = nil
end

function tdPack:Pack(...)
    self.savetobank = nil
    self.loadtobag  = nil
    
    local argc = select('#', ...)
    
    if argc > 0 then
        for i = 1, select('#', ...) do
            local arg = select(i, ...)
            if arg == 'asc' then
                self:SetReversePack(nil)
            elseif arg == 'desc' then
                self:SetReversePack(true)
            elseif arg == 'load' then
                self:SetLoadToBag(true)
            elseif arg == 'save' then
                self:SetSaveToBank(true)
            end
        end
    else
        self:SetReversePack(self:GetProfile().desc)
        self:SetSaveToBank(self:GetProfile().savetobank)
        self:SetLoadToBag(self:GetProfile().loadtobag)
    end
    
    self:GetModule('Pack'):Start()
end

tdPack.PackMenu = {
    { text = L['Pack asc'], onClick = function() tdPack:Pack('asc') end },
    { text = L['Pack desc'], onClick = function() tdPack:Pack('desc') end },
    { text = L['Save to bank'], onClick = function() tdPack:Pack('save') end },
    { text = L['Load from bank'], onClick = function() tdPack:Pack('load') end },
    { text = L['Open tdPack config frame'], onClick = function() tdPack:ToggleOption() end },
}
