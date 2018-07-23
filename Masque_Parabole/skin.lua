
local MSQ = LibStub("Masque", true)
if not MSQ then return end

MSQ:AddSkin("Parabole", {
  Author = "MoonWitch",
  Version = "5.4.0.1",
  Shape = "Square",
  Masque_Version = 40300,
  Backdrop = {
    Width = 36,
    Height = 36,
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Backdrop]],
  },
  Icon = {
    Width = 34,
    Height = 34,
  },
  Flash = {
    Width = 36,
    Height = 36,
    Color = {1, 0, 0, 0.3},
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Overlay]],
  },
  Cooldown = {
    Width = 34,
    Height = 34,
  },
  Pushed = {
    Width = 36,
    Height = 36,
    Color = {0, 0, 0, 0.5},
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Overlay]],
  },
  Normal = {
    Width = 36,
    Height = 36,
    Color = {0.3, 0.3, 0.3, 1},
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Normal]],
  },
  Disabled = {
    Hide = true,
  },
  Checked = {
    Width = 36,
    Height = 36,
    BlendMode = "ADD",
    Color = {0, 0.8, 1, 0.5},
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Border]],
  },
  Border = {
    Width = 36,
    Height = 36,
    BlendMode = "ADD",
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Border]],
  },
  Gloss = {
    Width = 36,
    Height = 36,
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Gloss]],
  },
  AutoCastable = {
    Width = 54,
    Height = 54,
    OffsetX = 0.5,
    OffsetY = -0.5,
    Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
  },
  Highlight = {
    Width = 36,
    Height = 36,
    BlendMode = "ADD",
    Color = {1, 1, 1, 0.5},
    Texture = [[Interface\AddOns\Masque_Parabole\Textures\Highlight]],
  },
  Name = {
    Width = 36,
    Height = 10,
    OffsetX = 2,
    OffsetY = 5,
  },
  Count = {
    Width = 36,
    Height = 10,
    OffsetX = -4,
    OffsetY = 5,
  },
  HotKey = {
    Width = 36,
    Height = 10,
    OffsetX = 1,
    OffsetY = -6,
  },
  Duration = {
    Width = 36,
    Height = 10,
    OffsetY = -2,
  },
  AutoCast = {
    Width = 26,
    Height = 26,
    OffsetX = 1,
    OffsetY = -1,
  },
}, true)
