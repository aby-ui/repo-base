-- Adds overlays to the UI Package ElvUI: https://www.tukui.org

if IsAddOnLoaded("ElvUI") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------


    function ElvUI_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag, slot = self:GetParent().bagID, self:GetParent().slotID
        CIMI_SetIcon(self, ElvUI_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------


    function CIMI_ElvUIAddFrame(event, addonName)
        if event ~= "PLAYER_LOGIN" and event ~= "BANKFRAME_OPENED" and not CIMIEvents[event] then return end
        -- Add to frames
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                end
            end
        end

        local function AddToBankFrames()
            -- This is a separate function, so that we can add a delay before these are added.
            -- Main Bank
            for i=1,28 do
                for j=1,MAX_CONTAINER_ITEMS do
                    local frame = _G["ElvUI_BankContainerFrameBag-"..i.."Slot"..j]
                    if frame then
                        CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                    end
                end
            end
            -- Bank Bags
            for i=1,NUM_CONTAINER_FRAMES do
                for j=1,MAX_CONTAINER_ITEMS do
                    local frame = _G["ElvUI_BankContainerFrameBag"..i.."Slot"..j]
                    if frame then
                        CIMI_AddToFrame(frame, ElvUI_CIMIUpdateIcon)
                    end
                end
            end
        end

        -- The ElvUI bank frames don't exist when the BANKFRAME_OPENED event occurs,
        -- so need to wait a moment first.
        C_Timer.After(.5, function() AddToBankFrames() end)

    end

    CanIMogIt.frame:AddEventFunction(CIMI_ElvUIAddFrame)


    ------------------------
    -- Event functions    --
    ------------------------


    function CIMI_ElvUIUpdate(self, event, ...)
        -- Update event
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_ContainerFrameBag"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
        -- Main Bank
        for i=1,28 do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag-"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
        -- Bank Bags
        for i=1,NUM_CONTAINER_FRAMES do
            for j=1,MAX_CONTAINER_ITEMS do
                local frame = _G["ElvUI_BankContainerFrameBag"..i.."Slot"..j]
                if frame then
                    ElvUI_CIMIUpdateIcon(frame.CanIMogItOverlay)
                end
            end
        end
    end


    function CIMI_ElvUIEvents(event)
        -- Update based on wow events
        if not CIMIEvents[event] then return end
        CIMI_ElvUIUpdate()
    end
    CanIMogIt.frame:AddOverlayEventFunction(CIMI_ElvUIEvents)
end
