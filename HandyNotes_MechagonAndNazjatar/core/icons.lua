-------------------------------------------------------------------------------
---------------------------------- NAMESPACE ----------------------------------
-------------------------------------------------------------------------------

local ADDON_NAME, ns = ...

-------------------------------------------------------------------------------
------------------------------- TEXTURE ATLASES -------------------------------
-------------------------------------------------------------------------------

local ICONS_DIR = "Interface\\Addons\\"..ADDON_NAME.."\\icons"

local ICONS = ICONS_DIR.."\\icons.blp"
local ICONS_WIDTH = 255
local ICONS_HEIGHT = 511

local ICONSW = ICONS_DIR.."\\icons_white.blp"
local ICONSW_WIDTH = 255
local ICONSW_HEIGHT = 255

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

    quest_yellow = { icon=ICONS, coords=coords(0, 0), glow='quest' },
    quest_blue = { icon=ICONS, coords=coords(0, 1), glow='quest' },
    quest_orange = { icon=ICONS, coords=coords(0, 2), glow='quest' },
    quest_green = { icon=ICONS, coords=coords(0, 3), glow='quest' },
    quest_yellow_old = { icon=ICONS, coords=coords(0, 4), glow='quest' },
    quest_blue_old = { icon=ICONS, coords=coords(0, 5), glow='quest' },

    quest_repeat_yellow = { icon=ICONS, coords=coords(0, 6), glow='quest_repeat' },
    quest_repeat_blue = { icon=ICONS, coords=coords(0, 7), glow='quest_repeat' },
    quest_repeat_orange = { icon=ICONS, coords=coords(1, 0), glow='quest_repeat' },
    quest_repeat_blue_old = { icon=ICONS, coords=coords(1, 1), glow='quest_repeat' },

    peg_blue = { icon=ICONS, coords=coords(1, 2), glow='peg' },
    peg_red = { icon=ICONS, coords=coords(1, 3), glow='peg' },
    peg_green = { icon=ICONS, coords=coords(1, 4), glow='peg' },
    peg_yellow = { icon=ICONS, coords=coords(1, 5), glow='peg' },

    gpeg_red = { icon=ICONS, coords=coords(1, 6), glow='peg' },
    gpeg_green = { icon=ICONS, coords=coords(1, 7), glow='peg' },
    gpeg_yellow = { icon=ICONS, coords=coords(2, 7), glow='peg' },

    envelope = { icon=ICONS, coords=coords(0, 8), glow='envelope' },
    horseshoe = { icon=ICONS, coords=coords(0, 9), glow='horseshoe' },
    world_quest = { icon=ICONS, coords=coords(0, 10), glow='world_quest' },
    anima_crystal = { icon=ICONS, coords=coords(1, 9), glow='crystal' },
    left_mouse = { icon=ICONS, coords=coords(2, 9) },
    orange_crystal = { icon=ICONS, coords=coords(2, 6), glow='crystal' },

    door_down = { icon=ICONS, coords=coords(2, 0), glow='door' },
    door_left = { icon=ICONS, coords=coords(2, 1), glow='door' },
    door_right = { icon=ICONS, coords=coords(2, 2), glow='door' },
    door_up = { icon=ICONS, coords=coords(2, 3), glow='door' },

    portal_blue = { icon=ICONS, coords=coords(2, 4), glow='portal' },
    portal_red = { icon=ICONS, coords=coords(2, 5), glow='portal' },
    portal_green = { icon=ICONS, coords=coords(3, 9), glow='portal' },
    portal_purple = { icon=ICONS, coords=coords(4, 9), glow='portal' },

    chest_gray = { icon=ICONS, coords=coords(3, 0), glow='treasure' },
    chest_yellow = { icon=ICONS, coords=coords(3, 1), glow='treasure' },
    chest_orange = { icon=ICONS, coords=coords(3, 2), glow='treasure' },
    chest_red = { icon=ICONS, coords=coords(3, 3), glow='treasure' },
    chest_purple = { icon=ICONS, coords=coords(3, 4), glow='treasure' },
    chest_blue = { icon=ICONS, coords=coords(3, 5), glow='treasure' },
    chest_lblue = { icon=ICONS, coords=coords(3, 6), glow='treasure' },
    chest_teal = { icon=ICONS, coords=coords(3, 7), glow='treasure' },
    chest_camo = { icon=ICONS, coords=coords(4, 0), glow='treasure' },
    chest_lime = { icon=ICONS, coords=coords(4, 1), glow='treasure' },
    chest_brown = { icon=ICONS, coords=coords(4, 2), glow='treasure' },
    chest_white = { icon=ICONS, coords=coords(4, 3), glow='treasure' },

    paw_yellow = { icon=ICONS, coords=coords(4, 4), glow='paw' },
    paw_green = { icon=ICONS, coords=coords(4, 5), glow='paw' },

    skull_white = { icon=ICONS, coords=coords(4, 6), glow='skull' },
    skull_blue = { icon=ICONS, coords=coords(4, 7), glow='skull' },

    star_chest = { icon=ICONS, coords=coords(0, 0, 48, 160), glow='star_chest' },
    star_skull = { icon=ICONS, coords=coords(0, 1, 48, 160), glow='star_chest' },
    star_swords = { icon=ICONS, coords=coords(0, 2, 48, 160), glow='star_chest' },

    shootbox_blue = { icon=ICONS, coords=coords(0, 3, 48, 160), glow='shootbox' },
    shootbox_yellow = { icon=ICONS, coords=coords(0, 4, 48, 160), glow='shootbox' },
    shootbox_pink = { icon=ICONS, coords=coords(0, 5, 48, 160), glow='shootbox' },

    kyrian_sigil = { icon=ICONS, coords=coords(1, 8)},
    necrolord_sigil = { icon=ICONS, coords=coords(2, 8)},
    nightfae_sigil = { icon=ICONS, coords=coords(3, 8)},
    venthyr_sigil = { icon=ICONS, coords=coords(4, 8)},
}

ns.glows = {
    quest = { icon=ICONSW, coords=coords(0, 0) },
    quest_repeat = { icon=ICONSW, coords=coords(0, 1) },
    envelope = { icon=ICONSW, coords=coords(0, 2) },
    horseshoe = { icon=ICONSW, coords=coords(0, 3) },
    door = { icon=ICONSW, coords=coords(1, 0) },
    crystal = { icon=ICONSW, coords=coords(1, 1) },
    peg = { icon=ICONSW, coords=coords(1, 2) },
    portal = { icon=ICONSW, coords=coords(1, 3) },
    treasure = { icon=ICONSW, coords=coords(2, 0) },
    paw = { icon=ICONSW, coords=coords(2, 1) },
    skull = { icon=ICONSW, coords=coords(2, 2) },
    world_quest = { icon=ICONSW, coords=coords(2, 3) },
    star_chest = { icon=ICONSW, coords=coords(0, 0, 48, 160) },
    shootbox = { icon=ICONSW, coords=coords(0, 1, 48, 160) },
}

local function InitIcon(icon, width, height)
    if type(icon) == 'table' then
        icon.tCoordLeft = icon.coords[1]/width
        icon.tCoordRight = icon.coords[2]/width
        icon.tCoordTop = icon.coords[3]/height
        icon.tCoordBottom = icon.coords[4]/height
        function icon:link (size)
            return (
                "|T"..ICONS..":"..size..":"..size..":0:0:"..
                (width+1)..":"..(height+1)..":"..
                self.coords[1]..":"..self.coords[2]..":"..
                self.coords[3]..":"..self.coords[4].."|t"
            )
        end
    end
end

for name, icon in pairs(ns.icons) do InitIcon(icon, ICONS_WIDTH, ICONS_HEIGHT) end
for name, icon in pairs(ns.glows) do InitIcon(icon, ICONSW_WIDTH, ICONSW_HEIGHT) end
