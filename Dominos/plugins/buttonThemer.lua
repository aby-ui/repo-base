local AddonName, Addon = ...
local ButtonThemer = Addon:NewModule('ButtonThemer')

local theme
if Addon:IsBuild("retail") then
    -- reserved for if I want to retheme buttons in Dragonflight
    theme = function(button)
        if button.SlotArt and button.SlotArt:IsShown() then
            button.SlotArt:Hide()
            button.SlotBackground:Show()
        end
    end
-- classic theming
else
    local ActionButtonWidth = Round(ActionButton1:GetWidth())

    local function getIconTexture(button)
        if button.Icon and button.Icon.SetTexCoord then
            return button.Icon
        end

        if button.icon and button.icon.SetTexCoord then
            return button.icon
        end
    end

    -- fix hotkey text extending outside of the button itself
    -- and make it consistent with the button size
    local function cleanupHotkeyText(button)
        local hotkey = button.HotKey
        if not hotkey then return end

        if hotkey:GetWidth() > button:GetWidth() then
            hotkey:SetWidth(button:GetWidth())

            local font, size, flags = hotkey:GetFont()
            size = Round(size * button:GetWidth() / ActionButtonWidth)

            hotkey:SetFont(font, size, flags)
        end
    end

    -- trim textures to remove some built in borders
    local function trimIconEdges(button)
        local icon = getIconTexture(button)
        if not icon then return end

        icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)
    end

    -- reposition the cooldown on the extra action button
    -- to handle the cooldown not properly covering the icon
    local function fixCooldownPositions(button)
        if button.buttonType ~= 'EXTRAACTIONBUTTON' then return end

        button.cooldown:ClearAllPoints()
        button.cooldown:SetAllPoints(button.icon)
    end

    -- resize normal texture for buttons of non action bar size
    local function resizeNormalTexture(button)
        local normalTexture = button:GetNormalTexture()
        if not normalTexture then return end

        local abRatio = Round(button:GetWidth()) / ActionButtonWidth

        normalTexture:ClearAllPoints()
        normalTexture:SetPoint('TOPLEFT', -15 * abRatio, 15 * abRatio)
        normalTexture:SetPoint('BOTTOMRIGHT', 15 * abRatio, -15 * abRatio)

        -- make the texture slightly transparent now to match its state when moving
        -- empty buttons around
        if type(button.NormalTexture) == "table" and type(button.NormalTexture.SetVertexColor) == "function" then
            button.NormalTexture:SetVertexColor(1, 1, 1, 0.5)
        end
    end

    -- hide the dark background on multi action bar buttons
    local function hideFloatingBG(button)
        local name = button:GetName()
        if not name then return end

        local floatingBG = _G[button:GetName() .. 'FloatingBG']
        if floatingBG then
            floatingBG:Hide()
        end
    end

    theme = function(button)
        if not Addon:ThemeButtons() then
            return
        end

        cleanupHotkeyText(button)
        trimIconEdges(button)
        fixCooldownPositions(button)
        resizeNormalTexture(button)
        hideFloatingBG(button)
    end
end

function ButtonThemer:Unload()
    self.shouldReskin = true
end

-- masque installed, use for theming
local Masque, MasqueVersion = LibStub('Masque', true)

if Masque then
    -- masque not installed
    function ButtonThemer:Register(button, groupName, ...)
        local group = Masque:Group(AddonName, groupName)

        group:AddButton(button, ...)

        if not group.db or group.db.Disabled then
            theme(button)
        end
    end

    function ButtonThemer:Unregister(button, groupName)
        local group = Masque:Group(AddonName, groupName)

        group:RemoveButton(button)

        theme(button)
    end

    -- handle differences in the masque API
    if MasqueVersion < 80100 then
        -- in older verisons, fallback to the dominos theme when disabled
        Masque:Register(
            AddonName,
            function(...)
                local _, group, _, _, _, _, disabled = ...

                if disabled then
                    for button in pairs(Masque:Group(AddonName, group).Buttons) do
                        theme(button)
                    end
                end
            end
        )

        function ButtonThemer:Reskin()
            if not self.shouldReskin then
                return
            end

            self.shouldReskin = nil

            for _, groupName in pairs(Masque:Group(AddonName).SubList or {}) do
                Masque:Group(AddonName, groupName):ReSkin()
            end
        end
    else
        function ButtonThemer:Reskin()
            if not self.shouldReskin then
                return
            end

            self.shouldReskin = nil

            for _, group in pairs(Masque:Group(AddonName).SubList or {}) do
                group:ReSkin()
            end
        end
    end
else
    function ButtonThemer:Register(button)
        theme(button)
    end

    function ButtonThemer:Unregister(button)
    end

    function ButtonThemer:Reskin()
    end
end
