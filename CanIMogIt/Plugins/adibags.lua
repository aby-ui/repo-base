-- Adds overlays to items in the addon AdiBags: https://mods.curse.com/addons/wow/adibags


if IsAddOnLoaded("AdiBags") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------


    function AdiBagsItemButton_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag, slot = self:GetParent().bag, self:GetParent().slot
        -- need to catch 0, 0 and 100, 0 here because the bank frame doesn't
        -- load everything immediately, so the OnUpdate needs to run until those frames are opened.
        if (bag == 0 and slot == 0) or (bag == 100 and slot == 0) then return end
        CIMI_SetIcon(self, AdiBagsItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------


    function CIMI_AdiBagsAddFrame(event, addonName)
        if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CIMIEvents[event] then return end
        -- Add to frames
        for i=1,600 do
            local frame = _G["AdiBagsItemButton"..i]
            if frame then
                C_Timer.After(.5, function() CIMI_AddToFrame(frame, AdiBagsItemButton_CIMIUpdateIcon) end)
            end
        end
        for i=1,28 do
            local frame = _G["AdiBagsBankItemButton"..i]
            if frame then
                C_Timer.After(.5, function() CIMI_AddToFrame(frame, AdiBagsItemButton_CIMIUpdateIcon) end)
            end
        end
    end
    CanIMogIt.frame:AddEventFunction(CIMI_AdiBagsAddFrame)


    ------------------------
    -- Event functions    --
    ------------------------


    function CIMI_AdiBagsEvents(self, event, ...)
        if not CIMIEvents[event] then return end
        -- Update event
        for i=1,600 do
            local frame = _G["AdiBagsItemButton"..i]
            if frame then
                -- Added a timer here because their function runs too far after the BAG_UPDATE event.
                C_Timer.After(.5, function() AdiBagsItemButton_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
            end
        end
    end
    hooksecurefunc(CanIMogIt.frame, "ItemOverlayEvents", CIMI_AdiBagsEvents)

    function AdiBags_UpdateAfter()
        C_Timer.After(.5, function() CIMI_AdiBagsAddFrame(nil, "PLAYER_LOGIN") end)
        C_Timer.After(.5, function() CanIMogIt.frame:ItemOverlayEvents("BAG_UPDATE") end)
    end
    LibStub('ABEvent-1.0').RegisterMessage("CanIMogIt", "AdiBags_BagOpened", AdiBags_UpdateAfter)
    LibStub('ABEvent-1.0').RegisterMessage("CanIMogIt", "AdiBags_ForceFullLayout", AdiBags_UpdateAfter)
end
