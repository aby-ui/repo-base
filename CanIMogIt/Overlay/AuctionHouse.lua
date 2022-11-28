-- Overlay for the auction house.

----------------------------
-- UpdateIcon functions   --
----------------------------


local function GetAuctionHouseItemLink(auctionHouseButton)
    -- rowData format: {
    --     ["battlePetSpeciesID"] = 0,
    --     ["itemID"] = 2140,
    --     ["itemLevel"] = 11,
    --     ["itemSuffix"] = 0,
    --     ["appearanceLink"] = 12345  -- Only sometimes
    --}
    local rowData = auctionHouseButton.rowData
    if rowData then
        if rowData.appearanceLink then
            -- Items that have multiple appearances under the same itemID also include an appearance ID.
            -- Use that to get the appearance instead.
            local sourceID = string.match(rowData.appearanceLink, ".*transmogappearance:?(%d*)|.*")
            if sourceID then
                return CanIMogIt:GetItemLinkFromSourceID(sourceID)
            else
                -- This results in a bug from Blizzard, where the item is flagged as having an
                -- appearanceLink (such as upgradable item appearances), but one is not provided.
                -- Seem to be limited to crafted items. Making the same query twice causes the
                -- data to be filled correctly.
                return
            end
        else
            -- Most items have a single appearance, and will use this code.
            local itemKey = rowData.itemKey
            return "|Hitem:".. itemKey.itemID .."|h"
        end
    else
        -- No row data
        return
    end
end


function AuctionHouseFrame_CIMIUpdateIcon(self)
    if not self then return end
    if not CIMI_CheckOverlayIconEnabled() then
        self.CIMIIconTexture:SetShown(false)
        self:SetScript("OnUpdate", nil)
        return
    end

    local button = self:GetParent()
    local itemLink = GetAuctionHouseItemLink(button)

    if itemLink == nil then
        -- Mark the items we can't figure out as a question mark (rather than empty).
        CIMI_SetIcon(self, AuctionHouseFrame_CIMIUpdateIcon, CanIMogIt.CANNOT_DETERMINE, CanIMogIt.CANNOT_DETERMINE)
    else
        CIMI_SetIcon(self, AuctionHouseFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
    end
end

------------------------
-- Function hooks     --
------------------------

function AuctionHouseFrame_CIMIOnValueChanged(_, elapsed)
    -- Add hook for the Auction House frames.
    -- We should only ever create/recreate the same
    -- frames over and over, so we shouldn't have
    -- a memory leak (I think).
    if not CanIMogIt.FrameShouldUpdate("AuctionHouseOverlay", elapsed or 1) then return end
    local scrollBox = _G["AuctionHouseFrame"].BrowseResultsFrame.ItemList.ScrollBox
    local buttons = scrollBox:GetFrames()
    if buttons == nil then
        return
    end

    for i, button in pairs(buttons) do
        local frame = button
        frame.CIMI_index = i
        if frame then
            CIMI_AddToFrame(frame, AuctionHouseFrame_CIMIUpdateIcon, "AuctionHouse"..i, "AUCTION_HOUSE")
            AuctionHouseFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
        end
    end
end


----------------------------
-- Begin adding to frames --
----------------------------

local function HookOverlayAuctionHouse(event)
    if event ~= "AUCTION_HOUSE_SHOW" then return end
    if (IsRestrictedAccount() or IsTrialAccount() or IsVeteranTrialAccount()) then return end

    -- We would normally add the frames here, but they don't
    -- exist at creation anymore. Instead, we need to create
    -- them when the values change.
    local itemList = _G["AuctionHouseFrame"].BrowseResultsFrame.ItemList
    itemList:HookScript("OnUpdate", AuctionHouseFrame_CIMIOnValueChanged)
end

CanIMogIt.frame:AddEventFunction(HookOverlayAuctionHouse)

------------------------
-- Event functions    --
------------------------

local function AuctionHouseUpdateEvents(event, ...)
    if event ~= "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then return end
    C_Timer.After(.1, AuctionHouseFrame_CIMIOnValueChanged)
end

CanIMogIt.frame:AddEventFunction(AuctionHouseUpdateEvents)

CanIMogIt:RegisterMessage("OptionUpdate", AuctionHouseUpdateEvents)
