--[[------------------------------------------------------------
始终高亮腐蚀装备
---------------------------------------------------------------]]
if not PaperDollFrame_UpdateCorruptedItemGlows then return end
local hook = function()
    PaperDollFrame_UpdateCorruptedItemGlows(true)
end
SetOrHookScript(CharacterFrame, "OnShow", hook)
SetOrHookScript(CharacterFrame, "OnShow", hook)
local CorruptFrame = CharacterStatsPane.ItemLevelFrame.Corruption
if CorruptFrame then SetOrHookScript(CorruptFrame, "OnLeave", hook) end

CoreDependCall("Blizzard_InspectUI", function()

    local cache, stats = {}, {}
    local function update_border(frame, link)
        if not frame then return end
        if not frame._aby_corrupt then
            local bc = frame:CreateTexture(nil, "OVERLAY", nil, 1)
            bc:SetAtlas("Nzoth-charactersheet-item-glow", true)
            bc:SetPoint("CENTER", frame)
            frame._aby_corrupt = bc
        end
        if not link then
            frame._aby_corrupt:Hide()
        else
            if cache[link] == nil then
                table.wipe(stats)
                GetItemStats(link, stats)
                cache[link] = stats.ITEM_MOD_CORRUPTION and stats.ITEM_MOD_CORRUPTION > 0 and "1" or "0"
            end
            CoreUIShowOrHide(frame._aby_corrupt, cache[link] == "1")
        end
    end

    -- copy from oGlow/pipes/inspect.lua
    local slots = { Waist=6, Legs=7, Feet=8, Wrist=9, Hands=10, Finger0=11, Finger1=12, MainHand=16, SecondaryHand=17, }

    local _MISSING = {}
    local itemInfoReceived = function()
        if(not next(_MISSING)) then
            return
        end

        local unit = InspectFrame.unit
        if(not unit) then
            table.wipe(_MISSING)
        end

        for i, slotName in next, _MISSING do
            local itemLink = GetInventoryItemLink(unit, i)
            if(itemLink) then
                update_border(_G['Inspect' .. slotName .. 'Slot'], itemLink)
                _MISSING[i] = nil
            end
        end
    end

    local update = function(self, event)
        if(not InspectFrame or not InspectFrame:IsShown()) then return end

        local unit = InspectFrame.unit
        for slotName, i in next, slots do
            local itemLink = GetInventoryItemLink(unit, i)
            local itemTexture = GetInventoryItemTexture(unit, i)

            if(itemTexture and not itemLink) then
                -- Force the client to request information from the server.
                local itemId = GetInventoryItemID(unit, i)
                if itemId then GetItemInfo(GetInventoryItemID(unit, i)) end
                _MISSING[i] = slotName
            end

            update_border(_G["Inspect"..slotName.."Slot"], itemLink)
        end
    end

    local UNIT_INVENTORY_CHANGED = function(self, event, unit)
        if(InspectFrame.unit == unit) then update(self) end
    end

    local f = CreateFrame("Frame")
    f:RegisterEvent("PLAYER_TARGET_CHANGED")
    f:RegisterEvent('UNIT_INVENTORY_CHANGED')
    f:RegisterEvent('GET_ITEM_INFO_RECEIVED')
    f:RegisterEvent('INSPECT_READY')
    f:SetScript("OnEvent", function(self, event, ...)
        if event == "PLAYER_TARGET_CHANGED" then return update(self, event, ...) end
        if event == "UNIT_INVENTORY_CHANGED" then return UNIT_INVENTORY_CHANGED(self, event, ...) end
        if event == "GET_ITEM_INFO_RECEIVED" then return itemInfoReceived(self, event, ...) end
        if event == "INSPECT_READY" then return update(self, event, ...) end
    end)

end)