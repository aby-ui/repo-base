-- Adds overlays to LiteBag https://mods.curse.com/addons/wow/litebag

if IsAddOnLoaded("LiteBag") then

    hooksecurefunc('LiteBagItemButton_Update', function (button)
            CIMI_AddToFrame(button, ContainerFrameItemButton_CIMIUpdateIcon)
            ContainerFrameItemButton_CIMIUpdateIcon(button.CanIMogItOverlay)
        end)

end
