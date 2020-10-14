-- Adds overlays to LiteBag https://mods.curse.com/addons/wow/litebag

if IsAddOnLoaded("LiteBag") then

    LiteBagItemButton_RegisterHook('LiteBagItemButton_Update', function (button)
            CIMI_AddToFrame(button, ContainerFrameItemButton_CIMIUpdateIcon)
            ContainerFrameItemButton_CIMIUpdateIcon(button.CanIMogItOverlay)
        end)

end
