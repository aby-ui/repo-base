-- Adds overlays to Combuctor https://mods.curse.com/addons/wow/bagnon

if IsAddOnLoaded("Combuctor") then

    -- Needs a slightly modified version of ContainerFrameItemButton_CIMIUpdateIcon(),
    -- to support cached Combuctor bags (e.g. bank when not at bank or other characters).
    function CombuctorItemButton_CIMIUpdateIcon(self)

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

        -- For cached Combuctor bags, GetContainerItemLink(bag, slot) would not work in CanIMogIt:GetTooltipText(nil, bag, slot).
        -- Therefore provide GetTooltipText() with itemLink when available.
        -- If the itemLink isn't available, then try with the bag/slot as backup (fixes battle pets).
        local itemLink = self:GetParent():GetItem()
        if not itemLink then
            -- This may be void storage or guild bank
            itemLink = self:GetParent():GetInfo().link
        end
        local cached = self:GetParent().info.cached
        -- Need to prevent guild bank items from using bag/slot from Combuctor,
        -- since they don't match Blizzard's frames.
        if itemLink or cached or self:GetParent().__name == "CombuctorGuildItem" then
            CIMI_SetIcon(self, CombuctorItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink))
        else
            CIMI_SetIcon(self, CombuctorItemButton_CIMIUpdateIcon, CanIMogIt:GetTooltipText(itemLink, bag, slot))
        end
    end

    function CIMI_CombuctorUpdate(self)
        CIMI_AddToFrame(self, CombuctorItemButton_CIMIUpdateIcon)
        CombuctorItemButton_CIMIUpdateIcon(self.CanIMogItOverlay)
    end

    hooksecurefunc(Combuctor.Item, "Update", CIMI_CombuctorUpdate)
    CanIMogIt:RegisterMessage("ResetCache", function () Combuctor.Frames:Update() end)

end
