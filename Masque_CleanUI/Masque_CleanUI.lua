local MASQUE = LibStub("Masque", true)
if not MASQUE then
    return
end

local AddOn, _ = ...
local Version = GetAddOnMetadata(AddOn, "Version")

--[[ CleanUI ]]

MASQUE:AddSkin("CleanUI", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Layer Settings
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Default\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true)


--[=[ CleanUI Edged

MASQUE:AddSkin("CleanUI Edged", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Edged\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true) ]=]


--[[ CleanUI Thin ]]

MASQUE:AddSkin("CleanUI Thin", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
            TexCoords = { 0.05, 0.95, 0.05, 0.95 },
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Thin\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true)


--[[ CleanUI Gray ]]

MASQUE:AddSkin("CleanUI Gray", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
            TexCoords = { 0.05, 0.95, 0.05, 0.95 },
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Gray\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true)


--[[ CleanUI Black ]]

MASQUE:AddSkin("CleanUI Black", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_Black\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true)


--[[ CleanUI White ]]

MASQUE:AddSkin("CleanUI White", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_White\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true)


--[=[ CleanUI White and Black

MASQUE:AddSkin("CleanUI White and Black", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_WhiteAndBlack\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true) ]=]


--[=[ CleanUI Black and White

MASQUE:AddSkin("CleanUI Black and White", {
        Author = "Nirriti",
        Version = Version,
        Shape = "Square",
        Masque_Version = 70200,

        -- Skin data start.
        Backdrop = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 1, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Backdrop]],
        },
        Icon = {
            Width = 36,
            Height = 36,
        },
        Flash = {
            Width = 42,
            Height = 42,
            Color = {1, 0, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Overlay]],
        },
        Cooldown = {
            Width = 36,
            Height = 36,
            AboveNormal = true,
        },
        Normal = {
            Width = 42,
            Height = 42,
            Static = true,
            Color = {0.25, 0.25, 0.25, 1},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Normal]],
        },
        Pushed = {
            Width = 42,
            Height = 42,
            Color = {1, 1, 0, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Overlay]],
        },
        Border = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Border]],
        },
        Disabled = {
            Hide = true,
        },
        Checked = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {0, 0.75, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Border]],
        },
        AutoCastable = {
            Width = 60,
            Height = 60,
            OffsetX = 0.5,
            OffsetY = -0.5,
            Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
        },
        Shine = {
            Width = 34,
            Height = 34,
            OffsetX = 0.5,
            OffsetY = -0.5,
        },
        Highlight = {
            Width = 42,
            Height = 42,
            BlendMode = "ADD",
            Color = {1, 1, 1, 0.5},
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Highlight]],
        },
        Gloss = {
            Width = 42,
            Height = 42,
            Texture = [[Interface\AddOns\Masque_CleanUI\CleanUI_BlackAndWhite\Gloss]],
        },
        HotKey = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = -4,
        },
        Count = {
            Width = 36,
            Height = 9,
            OffsetX = 0,
            OffsetY = 4,
        },
        Name = {
            Width = 36,
            Height = 9,
            OffsetY = 4,
        },
        Duration = {
            Width = 36,
            Height = 10,
            OffsetY = -2,
        },
-- Skin data end.

}, true) ]=]
