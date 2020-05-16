local AddonName, Addon = ...
local ParentAddonName = GetAddOnDependencies(AddonName)
local ParentAddon = LibStub("AceAddon-3.0"):GetAddon(ParentAddonName)

-- shows the first options panel frame we have
function Addon:ShowPrimaryOptionsPanel()
    local _, child = next(self.frame.children)

    if child then
        InterfaceOptionsFrame_OpenToCategory(child)
    end
end

-- on the next frame, actually load the options menu
-- this should allow other addons to respond to ADDON_LOADED and add additional
-- panels to the options menu, and also let me list panels a bit later in the 
-- toc order without ill effect
C_Timer.After(GetTickTime(), function()
    ParentAddon.callbacks:Fire("OPTIONS_MENU_LOADING", self)

    -- augment the options panel with new stuff
    Addon.frame = ParentAddon.OptionsFrame
    Addon.frame.children = {}
    Addon.frame:SetScript("OnShow", function() 
        Addon:ShowPrimaryOptionsPanel() 
    end)

    -- register ace config options
    LibStub("AceConfig-3.0"):RegisterOptionsTable(
        ParentAddonName,
        function()
            local options = {
                type = "group",
                name = ParentAddonName,
                args = {}
            }

            for _, panel in Addon:GetOptionsPanels() do
                if panel.options then
                    options.args[panel.key] = panel.options
                end
            end

            return options
        end
    )

    -- build options panels
    for _, panel in Addon:GetOptionsPanels() do
        local frame = panel.frame

        if not frame then
            frame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(
                Addon.frame.name,
                panel.options.name,
                Addon.frame.name,
                panel.key
            )
        end

        tinsert(Addon.frame.children, frame)
    end

    ParentAddon.callbacks:Fire("OPTIONS_MENU_LOADED", self)    

    if Addon.frame:IsShown() then
        Addon:ShowPrimaryOptionsPanel()    
    end
end)

-- exports
ParentAddon.Options = Addon