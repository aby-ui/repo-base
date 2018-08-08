-- Overlay for player bags, bank, void storage, and guild banks.


----------------------------
-- UpdateIcon functions   --
----------------------------


function ContainerFrameItemButton_CIMIUpdateIcon(self)
    if not self or not self:GetParent() or not self:GetParent():GetParent() then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end
    local bag, slot = self:GetParent():GetParent():GetID(), self:GetParent():GetID()
    -- need to catch 0, 0 and 100, 0 here because the bank frame doesn't
    -- load everything immediately, so the OnUpdate needs to run until those frames are opened.
    if (bag == 0 and slot == 0) or (bag == 100 and slot == 0) then return end
    CIMI_SetIcon(self, ContainerFrameItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
end


function ContainerFrameItemButton_CIMIToggleBag(...)
    CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE")
end


function GuildBankFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local tab = GetCurrentGuildBankTab()
    local slot = self:GetParent():GetID()
    local itemLink = GetGuildBankItemLink(tab, slot)
    CIMI_SetIcon(self, GuildBankFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


function VoidStorageFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local page = _G["VoidStorageFrame"].page
    local buttonSlot = self:GetParent().slot
    local voidSlot = buttonSlot + (CanIMogIt.NUM_VOID_STORAGE_FRAMES * (page - 1))
    local itemLink = GetVoidItemHyperlinkString(voidSlot)
    CIMI_SetIcon(self, VoidStorageFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
end


------------------------
-- Function hooks     --
------------------------


function VoidStorageFrame_CIMIOnClick()
    for i=1,CanIMogIt.NUM_VOID_STORAGE_FRAMES do
        local frame = _G["VoidStorageStorageButton"..i]
        if frame then
            VoidStorageFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------


local function HookOverlayContainers(event)
    if event ~= "PLAYER_LOGIN" then return end

    -- Add hook for each bag item.
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            if frame then
                CIMI_AddToFrame(frame, ContainerFrameItemButton_CIMIUpdateIcon)
            end
        end
    end

    hooksecurefunc("ToggleBag", ContainerFrameItemButton_CIMIToggleBag)
    hooksecurefunc("OpenAllBags", ContainerFrameItemButton_CIMIToggleBag)
    hooksecurefunc("CloseAllBags", ContainerFrameItemButton_CIMIToggleBag)
    hooksecurefunc("ToggleAllBags", ContainerFrameItemButton_CIMIToggleBag)

    -- Add hook for the main bank frame.
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        if frame then
            CIMI_AddToFrame(frame, ContainerFrameItemButton_CIMIUpdateIcon)
        end
    end
end

CanIMogIt.frame:AddEventFunction(HookOverlayContainers)


-- guild bank
local guildBankLoaded = false

local function OnGuildBankOpened(event, ...)
    if event ~= "GUILDBANKFRAME_OPENED" then return end
    if guildBankLoaded == true then return end
    guildBankLoaded = true
    for column=1,CanIMogIt.NUM_GUILDBANK_COLUMNS do
        for button=1,CanIMogIt.NUM_SLOTS_PER_GUILDBANK_GROUP do
            local frame = _G["GuildBankColumn"..column.."Button"..button]
            if frame then
                CIMI_AddToFrame(frame, GuildBankFrame_CIMIUpdateIcon)
            end
        end
    end
end

CanIMogIt.frame:AddEventFunction(OnGuildBankOpened)

-- void storage
local voidStorageLoaded = false

local function OnVoidStorageOpened(event, ...)
    -- Add the overlay to the void storage frame.
    if event ~= "VOID_STORAGE_OPEN" then return end
    if voidStorageLoaded == true then return end
    voidStorageLoaded = true
    for i=1,CanIMogIt.NUM_VOID_STORAGE_FRAMES do
        local frame = _G["VoidStorageStorageButton"..i]
        if frame then
            CIMI_AddToFrame(frame, VoidStorageFrame_CIMIUpdateIcon)
        end
    end

    local voidStorageFrame = _G["VoidStorageFrame"]
    if voidStorageFrame then
        -- if the frame doesn't exist, then it's likely overwritten by an addon.
        voidStorageFrame.Page1:HookScript("OnClick", VoidStorageFrame_CIMIOnClick)
        voidStorageFrame.Page2:HookScript("OnClick", VoidStorageFrame_CIMIOnClick)
    end
end

CanIMogIt.frame:AddEventFunction(OnVoidStorageOpened)

------------------------
-- Event functions    --
------------------------


local function ContainersOverlayEvents(event, ...)
    --[[
        Adding C_Timer.After to cause it to run next frame. Something changed
        with 8.0 that is causing bigger bags to update items being moved
        in to/out of bags in a different order. This is causing the icon to
        not update on some characters. The After(0,...) call makes it update
        next frame instead.
    ]]
    -- bags
    for i=1,NUM_CONTAINER_FRAMES do
        for j=1,MAX_CONTAINER_ITEMS do
            local frame = _G["ContainerFrame"..i.."Item"..j]
            if frame then
                C_Timer.After(0, function() ContainerFrameItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            end
        end
    end

    -- main bank frame
    for i=1,NUM_BANKGENERIC_SLOTS do
        local frame = _G["BankFrameItem"..i]
        if frame then
            C_Timer.After(0, function() ContainerFrameItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
        end
    end

    -- void storage frames
    if voidStorageLoaded then
        VoidStorageFrame_CIMIOnClick()
    end

    -- guild bank frames
    if guildBankLoaded then
        for column=1,CanIMogIt.NUM_GUILDBANK_COLUMNS do
            for button=1,CanIMogIt.NUM_SLOTS_PER_GUILDBANK_GROUP do
                local frame = _G["GuildBankColumn"..column.."Button"..button]
                if frame then
                    GuildBankFrame_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
    end
end

CanIMogIt.frame:AddOverlayEventFunction(ContainersOverlayEvents)
