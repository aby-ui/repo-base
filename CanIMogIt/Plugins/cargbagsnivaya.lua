-- Adds overlays to items in the addon cargBags Nivaya: https://www.curseforge.com/wow/addons/cargbags-nivaya-mop-update

if IsAddOnLoaded("cargBags_Nivaya") then


    ----------------------------
    -- UpdateIcon functions   --
    ----------------------------


    function CargBagsNivaya_CIMIUpdateIcon(self)
        if not self or not self:GetParent() then return end
        if not CIMI_CheckOverlayIconEnabled(self) then
            self.CIMIIconTexture:SetShown(false)
            self:SetScript("OnUpdate", nil)
            return
        end
        local bag, slot = self:GetParent().bagID, self:GetParent().slotID
        CIMI_SetIcon(self, CargBagsNivaya_CIMIUpdateIcon, CanIMogIt:GetTooltipText(nil, bag, slot))
    end


    ----------------------------
    -- Begin adding to frames --
    ----------------------------


    function CIMI_CargBagsNivayaAddFrame(event, addonName)
        local function LoadFrames()
            -- All items (including the bank) can be accessed from NivayaSlotXXX
            -- I've observed the slot number going up to around 600
            for i=0,NUM_CONTAINER_FRAMES do
                for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
                    local frame = _G["NivayaSlot"..(i*CanIMogIt.MAX_CONTAINER_ITEMS+j)]
                    if frame then
                        CIMI_AddToFrame(frame, CargBagsNivaya_CIMIUpdateIcon)
                    end
                end
            end
        end

        -- Takes some time to initialize cargbags
        C_Timer.After(.5, function() LoadFrames() end)

    end

    CanIMogIt.frame:AddEventFunction(CIMI_CargBagsNivayaAddFrame)


    ------------------------
    -- Event functions    --
    ------------------------


    function CIMI_CargBagsNivayaUpdate(self, event, ...)
        -- Update event
        -- Bags
        for i=0,NUM_CONTAINER_FRAMES do
            for j=1,CanIMogIt.MAX_CONTAINER_ITEMS do
                local frame = _G["NivayaSlot"..(i*CanIMogIt.MAX_CONTAINER_ITEMS+j)]
                if frame then
                    C_Timer.After(.1, function() CargBagsNivaya_CIMIUpdateIcon(frame.CanIMogItOverlay) end)
                end
            end
        end
    end


    function CIMI_CargBagsNivayaEvents(event)
        -- Update based on wow events
        if not CIMIEvents[event] then return end
        CIMI_CargBagsNivayaUpdate()
    end
    CanIMogIt.frame:AddOverlayEventFunction(CIMI_CargBagsNivayaEvents)
end
