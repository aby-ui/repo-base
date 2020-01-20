local AddonName, Addon = ...
local ButtonThemer = LibStub("AceAddon-3.0"):GetAddon(AddonName):NewModule("ButtonThemer")

local round = _G.Round
local ActionButtonWidth = round(_G["ActionButton1"]:GetWidth())

local function theme(button)
    if not Addon:ThemeButtons() then
        return
    end

    button.icon:SetTexCoord(0.06, 0.94, 0.06, 0.94)

    -- reposition the cooldown on the extra action button
    -- to handle the cooldown not properly covering the icon
    if button.buttonType == 'EXTRAACTIONBUTTON' then
        button.cooldown:ClearAllPoints()
        button.cooldown:SetAllPoints(button.icon)
    end

    local r = round(button:GetWidth()) / ActionButtonWidth

    local nt = button:GetNormalTexture()
    nt:ClearAllPoints()
    nt:SetPoint("TOPLEFT", -15 * r, 15 * r)
    nt:SetPoint("BOTTOMRIGHT", 15 * r, -15 * r)
    nt:SetVertexColor(1, 1, 1, 0.5)

    local floatingBG = _G[button:GetName() .. "FloatingBG"]
    if floatingBG then
        floatingBG:Hide()
    end
end

function ButtonThemer:Unload()
    self.shouldReskin = true
end

-- masque installed, use for theming
local Masque, MasqueVersion = LibStub("Masque", true)
if Masque then
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
        -- Add the new default skin (thanks StormFX)
        Masque:AddSkin(
            AddonName,
            {
                -- Info
                Description = ("The default skin for %s."):format(AddonName),
                Author = "Tuller, StormFX",
                -- Skin
                Template = "Default",
                --Disable = true, -- Hides the skin in the GUI.
                Icon = {
                    TexCoords = {0.06, 0.94, 0.06, 0.94},
                    DrawLayer = "BACKGROUND",
                    DrawLevel = 0,
                    Width = 36,
                    Height = 36,
                    Point = "CENTER",
                    OffsetX = 0,
                    OffsetY = 0
                },
                Normal = {
                    Texture = [[Interface\Buttons\UI-Quickslot2]],
                    -- TexCoords = {0, 1, 0, 1},
                    Color = {1, 1, 1, 0.5},
                    -- EmptyTexture = [[Interface\Buttons\UI-Quickslot2]],
                    -- EmptyCoords = {0, 1, 0, 1},
                    -- EmptyColor = {1, 1, 1, 0.5},
                    BlendMode = "BLEND",
                    DrawLayer = "ARTWORK",
                    DrawLevel = 0,
                    Width = 66,
                    Height = 66,
                    Point = "CENTER",
                    OffsetX = 0,
                    OffsetY = 0,
                    UseStates = true,
                },
                IconBorder = {
                    Texture = [[Interface\Common\WhiteIconFrame]],
                    RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
                    -- TexCoords = {0, 1, 0, 1},
                    -- Color = {1, 1, 1, 1},
                    BlendMode = "BLEND",
                    DrawLayer = "OVERLAY",
                    DrawLevel = 0,
                    Width = 37,
                    Height = 37,
                    Point = "CENTER",
                    OffsetX = 0,
                    OffsetY = 0,
                },
                IconOverlay = {
                    Atlas = "AzeriteIconFrame",
                    -- Color = {1, 1, 1, 1},
                    BlendMode = "BLEND",
                    DrawLayer = "OVERLAY",
                    DrawLevel = 1,
                    Width = 37,
                    Height = 37,
                    Point = "CENTER",
                    OffsetX = 0,
                    OffsetY = 0,
                },
            },
            true
        )

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
-- masque not installed
else
    function ButtonThemer:Register(button)
        theme(button)
    end

    function ButtonThemer:Unregister(button)
    end

    function ButtonThemer:Reskin()
    end
end
