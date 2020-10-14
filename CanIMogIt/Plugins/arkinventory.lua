-- Adds overlays to items in the addon ArkInventory: https://mods.curse.com/addons/wow/ark-inventory


if IsAddOnLoaded("ArkInventory") then

    if ( ArkInventory.API.Version( ) ) < 30821 then

        ----------------------------
        -- UpdateIcon functions   --
        ----------------------------


        function ArkInventoryItemButton_CIMIUpdateIcon(self)
            if not self or not self:GetParent() then return end
            local frame = self:GetParent()
            if not frame.ARK_Data then return end
            if not CIMI_CheckOverlayIconEnabled(self) then
                self.CIMIIconTexture:SetShown(false)
                self:SetScript("OnUpdate", nil)
                return
            end
            local itemLink, bag, slot
            bag = ArkInventory.InternalIdToBlizzardBagId(frame.ARK_Data.loc_id, frame.ARK_Data.bag_id)
            slot = frame.ARK_Data.slot_id

            if ArkInventory.Global.Location[frame.ARK_Data.loc_id].isOffline or bag >= 1000 then
                --[[
                    Two things of note here:
                    1) isOffline should treat the item as if it's on a different
                    character, ignoring soulbound status.
                    2) Guild Bank lists the bag as 1000+, which is incorrect.
                    Grabbing the item from the frame directly, since they
                    can't be soulbound anyway.
                ]]
                local i = ArkInventory.Frame_Item_GetDB(frame)
                if i and i.h then
                    itemLink = i.h
                end
                -- Nil out bag and slot, so it uses the itemlink instead.
                bag = nil
                slot = nil
            end
            CIMI_SetIcon(self, ArkInventoryItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
        end


        ----------------------------
        -- Begin adding to frames --
        ----------------------------


        function CIMI_ArkInventoryAddFrame(frame,tainted)
            if not tainted then
                -- Add to frames
                CIMI_AddToFrame(frame, ArkInventoryItemButton_CIMIUpdateIcon)
            end
        end

        hooksecurefunc(ArkInventory, "Frame_Item_OnLoad", CIMI_ArkInventoryAddFrame)


        ------------------------
        -- Event functions    --
        ------------------------


        function CIMI_ArkInventoryUpdate(loc_id, bag_id, slot_id)
            -- Bags
            for i=1,NUM_CONTAINER_FRAMES do
                for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
                    local frame = _G["ARKINV_Frame1ScrollContainerBag"..i.."Item"..j]
                    if frame then
                        ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
                    end
                end
            end
            -- Player Bank
            for i=1,12 do
                for j=1,200 do
                    local frame = _G["ARKINV_Frame3ScrollContainerBag"..i.."Item"..j]
                    if frame then
                        C_Timer.After(.1, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                    end
                end
            end
            -- Guild Bank
            for i=1,12 do
                for j=1,200 do
                    local frame = _G["ARKINV_Frame4ScrollContainerBag"..i.."Item"..j]
                    if frame then
                        -- The guild bank frame does extra stuff after the CIMI icon shows up,
                        -- so need to add a slight delay.
                        C_Timer.After(.2, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                    end
                end
            end
        end

        function CIMI_ArkInventoryUpdateSingle(loc_id, bag_id, slot_id)
            local _, frame = ArkInventory.ContainerItemNameGet( loc_id, bag_id, slot_id )
            if frame then
                ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
            end
        end

        hooksecurefunc(ArkInventory, "Frame_Item_Update", CIMI_ArkInventoryUpdateSingle)
        CanIMogIt:RegisterMessage("ResetCache", CIMI_ArkInventoryUpdate)

        function CIMI_ArkInventoryEvents(self, event)
            -- Update based on wow events
            if not CIMIEvents[event] then return end
            CIMI_ArkInventoryUpdate()
        end
        hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_ArkInventoryEvents)

        -- Makes sure things are updated if bags are open quickly after logging in. Won't always work, but better than nothing.
        C_Timer.After(15, function() CanIMogIt:ResetCache() end)

    else

        --    3.08.21 or higher

        ----------------------------
        -- UpdateIcon functions   --
        ----------------------------


        function ArkInventoryItemButton_CIMIUpdateIcon(self)
            if not self or not self:GetParent() then return end
            local frame = self:GetParent()
            if not frame.ARK_Data then return end
            if not CIMI_CheckOverlayIconEnabled(self) then
                self.CIMIIconTexture:SetShown(false)
                self:SetScript("OnUpdate", nil)
                return
            end
            local itemLink = nil
            local bag = frame.ARK_Data.blizzard_id
            local slot = frame.ARK_Data.slot_id
            if ArkInventory.API.LocationIsOffline( loc_id ) or not ( loc_id == ArkInventory.Const.Location.Bag or loc_id == ArkInventory.Const.Location.Bank ) then
                local i = ArkInventory.API.ItemFrameItemTableGet( frame )
                if i and i.h then
                    itemLink = i.h
                end
                -- use the itemlink for offline locations or any that are not the bag or bank
                bag = nil
                slot = nil
            end
            CIMI_SetIcon(self, ArkInventoryItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
        end


        ----------------------------
        -- Begin adding to frames --
        ----------------------------


        function CIMI_ArkInventoryAddFrame(frame,loc_id)
            -- Add to item frame
            -- Added a C_Timer, since CanIMogItOptions aren't loaded yet.
            C_Timer.After(.1, function() CIMI_AddToFrame(frame, ArkInventoryItemButton_CIMIUpdateIcon) end)
        end

        hooksecurefunc( ArkInventory.API, "ItemFrameLoaded", CIMI_ArkInventoryAddFrame )

        -- add to any preloaded item frames
        for framename, frame in ArkInventory.API.ItemFrameLoadedIterate( ) do
            CIMI_ArkInventoryAddFrame(frame)
        end


        ------------------------
        -- Event functions    --
        ------------------------


        function CIMI_ArkInventoryUpdate()
            for framename, frame, loc_id in ArkInventory.API.ItemFrameLoadedIterate( ) do
                if loc_id == ArkInventory.Const.Location.Bank then
                    C_Timer.After(.1, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                elseif loc_id == ArkInventory.Const.Location.Vault then
                    -- The guild bank frame does extra stuff after the CIMI icon shows up, so need to add a slight delay.
                    C_Timer.After(.2, function() ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                else
                    ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end

        function CIMI_ArkInventoryUpdateSingle(frame)
            ArkInventoryItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay)
        end

        hooksecurefunc( ArkInventory.API, "ItemFrameUpdated", CIMI_ArkInventoryUpdateSingle )

        CanIMogIt:RegisterMessage("ResetCache", CIMI_ArkInventoryUpdate)

        function CIMI_ArkInventoryEvents(self, event)
            -- Update based on wow events
            if not CIMIEvents[event] then return end
            CIMI_ArkInventoryUpdate()
        end
        hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_ArkInventoryEvents)

    end

end
