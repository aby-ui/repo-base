local ADDON_NAME, ns = ...
local ICONS = "Interface\\Addons\\"..ADDON_NAME.."\\icons\\icons.blp"
local ICONS_SIZE = 255

local function coords(x, y, grid, xo, yo)
    grid, xo, yo = grid or 32, xo or 0, yo or 0
    return { xo+x*grid, xo+(x+1)*grid-1, yo+y*grid, yo+(y+1)*grid-1 }
end

ns.icons = {

    ---------------------------------------------------------------------------
    ---------------------------------- GAME -----------------------------------
    ---------------------------------------------------------------------------

    default = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS",
    diablo_murloc = "Interface\\Icons\\inv_pet_diablobabymurloc.blp",
    emerald_cat = "Interface\\Icons\\trade_archaeology_catstatueemeraldeyes.blp",
    green_egg = "Interface\\Icons\\Inv_egg_02.blp",
    slime = "Interface\\Icons\\ability_creature_poison_05.blp",
    quest_chalice = 236669,

    ---------------------------------------------------------------------------
    -------------------------------- EMBEDDED ---------------------------------
    ---------------------------------------------------------------------------

    -- coords={l, r, t, b}

    quest_yellow = { icon=ICONS, coords=coords(0, 0) },
    quest_blue = { icon=ICONS, coords=coords(0, 1) },
    quest_orange = { icon=ICONS, coords=coords(0, 2) },
    quest_green = { icon=ICONS, coords=coords(0, 3) },
    quest_yellow_old = { icon=ICONS, coords=coords(0, 4) },
    quest_blue_old = { icon=ICONS, coords=coords(0, 5) },

    quest_repeat_yellow = { icon=ICONS, coords=coords(0, 6) },
    quest_repeat_blue = { icon=ICONS, coords=coords(0, 7) },
    quest_repeat_orange = { icon=ICONS, coords=coords(1, 0) },
    quest_repeat_blue_old = { icon=ICONS, coords=coords(1, 1) },

    peg_blue = { icon=ICONS, coords=coords(1, 2) },
    peg_red = { icon=ICONS, coords=coords(1, 3) },
    peg_green = { icon=ICONS, coords=coords(1, 4) },
    peg_yellow = { icon=ICONS, coords=coords(1, 5) },

    gpeg_red = { icon=ICONS, coords=coords(1, 6) },
    gpeg_green = { icon=ICONS, coords=coords(1, 7) },
    gpeg_yellow = { icon=ICONS, coords=coords(2, 7) },

    door_down = { icon=ICONS, coords=coords(2, 0) },
    door_left = { icon=ICONS, coords=coords(2, 1) },
    door_right = { icon=ICONS, coords=coords(2, 2) },
    door_up = { icon=ICONS, coords=coords(2, 3) },

    portal_blue = { icon=ICONS, coords=coords(2, 4) },
    portal_red = { icon=ICONS, coords=coords(2, 5) },

    chest_gray = { icon=ICONS, coords=coords(3, 0) },
    chest_yellow = { icon=ICONS, coords=coords(3, 1) },
    chest_orange = { icon=ICONS, coords=coords(3, 2) },
    chest_red = { icon=ICONS, coords=coords(3, 3) },
    chest_purple = { icon=ICONS, coords=coords(3, 4) },
    chest_blue = { icon=ICONS, coords=coords(3, 5) },
    chest_lblue = { icon=ICONS, coords=coords(3, 6) },
    chest_teal = { icon=ICONS, coords=coords(3, 7) },
    chest_camo = { icon=ICONS, coords=coords(4, 0) },
    chest_lime = { icon=ICONS, coords=coords(4, 1) },
    chest_brown = { icon=ICONS, coords=coords(4, 2) },
    chest_white = { icon=ICONS, coords=coords(4, 3) },

    paw_yellow = { icon=ICONS, coords=coords(4, 4) },
    paw_green = { icon=ICONS, coords=coords(4, 5) },

    skull_white = { icon=ICONS, coords=coords(4, 6) },
    skull_blue = { icon=ICONS, coords=coords(4, 7) },

    skull_white_red_glow = { icon=ICONS, coords=coords(0, 0, 48, 160) },
    skull_blue_red_glow = { icon=ICONS, coords=coords(0, 1, 48, 160) },
    skull_white_green_glow = { icon=ICONS, coords=coords(1, 0, 48, 160) },
    skull_blue_green_glow = { icon=ICONS, coords=coords(1, 1, 48, 160) },

    star_chest = { icon=ICONS, coords=coords(0, 2, 48, 160) },
    star_skull = { icon=ICONS, coords=coords(0, 3, 48, 160) },
    star_swords = { icon=ICONS, coords=coords(0, 4, 48, 160) },

    shootbox_blue = { icon=ICONS, coords=coords(1, 2, 48, 160) },
    shootbox_yellow = { icon=ICONS, coords=coords(1, 3, 48, 160) },
    shootbox_pink = { icon=ICONS, coords=coords(1, 4, 48, 160) }
};

for name, icon in pairs(ns.icons) do
    if type(icon) == 'table' then
        icon.tCoordLeft = icon.coords[1]/ICONS_SIZE
        icon.tCoordRight = icon.coords[2]/ICONS_SIZE
        icon.tCoordTop = icon.coords[3]/ICONS_SIZE
        icon.tCoordBottom = icon.coords[4]/ICONS_SIZE
        icon.coords = nil
    end
end
