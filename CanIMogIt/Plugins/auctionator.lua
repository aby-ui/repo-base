-- Adds overlays to items in the addon Auctionator: https://www.curseforge.com/wow/addons/auctionator


if IsAddOnLoaded("Auctionator") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------

    CanIMogIt.ICON_LOCATIONS["AUCTIONATOR"] = {"LEFT", 0, 0}


    local function GetAuctionatorItemLink(auctionatorButton)
        -- rowData format: {
        --     ["battlePetSpeciesID"] = 0,
        --     ["itemID"] = 2140,
        --     ["itemLevel"] = 11,
        --     ["itemSuffix"] = 0,
        --     ["appearanceLink"] = 12345  -- Only sometimes
        --}
        local rowData = auctionatorButton.rowData
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


    function AuctionatorFrame_CIMIUpdateIcon(self)
        if not self then return end
        if not CIMI_CheckOverlayIconEnabled() then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end

        local button = self:GetParent()
        local itemLink = GetAuctionatorItemLink(button)

        if itemLink == nil then
            -- Mark the items we can't figure out as a question mark (rather than empty).
            CIMI_SetIcon(self, AuctionatorFrame_CIMIUpdateIcon, CanIMogIt.CANNOT_DETERMINE, CanIMogIt.CANNOT_DETERMINE)
        else
            CIMI_SetIcon(self, AuctionatorFrame_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
        end
    end

    ------------------------
    -- Function hooks     --
    ------------------------

    function AuctionatorFrame_CIMIOnValueChanged(_, elapsed)
        -- Some other addons *coughTSMcough* prevent this frame from loading.
        if _G["AuctionatorShoppingFrame"] == nil then return end
        if not CanIMogIt.FrameShouldUpdate("AuctionatorShopping", elapsed or 1) then return end
        local buttons = _G["AuctionatorShoppingFrame"].ResultsListing.ScrollArea.ScrollBox:GetFrames()
        if buttons == nil then
            return
        end
        for i, button in pairs(buttons) do
            if button then
                button.CIMI_index = i
                CIMI_AddToFrame(button, AuctionatorFrame_CIMIUpdateIcon, "AuctionatorShoppingList"..i, "AUCTIONATOR")
                AuctionatorFrame_CIMIUpdateIcon(button.CanIMogItOverlay)
            end
        end
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------

    local function HookOverlay()
        -- Some other addons *coughTSMcough* prevent this frame from loading.
        if _G["AuctionatorShoppingFrame"] == nil then return end

        local scrollArea = _G["AuctionatorShoppingFrame"].ResultsListing.ScrollArea
        scrollArea:HookScript("OnUpdate", AuctionatorFrame_CIMIOnValueChanged)

        -- This GetChildren returns an _unpacked_ value for some reason, so we have to pack it in a table.
        local headers = {AuctionatorShoppingFrame.ResultsListing.HeaderContainer:GetChildren()}
        for i, header in ipairs(headers) do
            header:HookScript("OnClick", AuctionatorFrame_CIMIOnValueChanged)
        end
    end

    local function HookOverlayAuctionator(event)
        if event ~= "AUCTION_HOUSE_SHOW" then return end
        C_Timer.After(.1, function () HookOverlay() end)
    end

    CanIMogIt.frame:AddEventFunction(HookOverlayAuctionator)

    ------------------------
    -- Event functions    --
    ------------------------

    local function AuctionatorUpdateEvents(event, ...)
        if event ~= "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then return end
        C_Timer.After(.1, AuctionatorFrame_CIMIOnValueChanged)
    end

    CanIMogIt.frame:AddEventFunction(AuctionatorUpdateEvents)

end
