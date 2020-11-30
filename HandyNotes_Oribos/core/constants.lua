----------------------------------------------------------------------------------------------------
------------------------------------------AddOn NAMESPACE-------------------------------------------
----------------------------------------------------------------------------------------------------

local FOLDER_NAME, private = ...

local constants = {}
private.constants = constants

----------------------------------------------------------------------------------------------------
----------------------------------------------DEFAULTS----------------------------------------------
----------------------------------------------------------------------------------------------------

constants.defaults = {
    profile = {
        icon_scale = 1.25,
        icon_alpha = 1.0,

        show_auctioneer = true,
        show_banker = true,
        show_barber = true,
        show_innkeeper = true,
        show_mail = true,
        show_portal = true,
        show_tpplatform = true,
        show_reforge = true,
        show_stablemaster = true,
        show_trainer = true,
        show_onlymytrainers = false,
        show_transmogrifier = true,
        show_vendor = true,
        show_void = true,
--        show_others = true,

        easy_waypoint = true,

        force_nodes = false,
        show_prints = false,
    },
    global = {
        dev = false,
    },
    char = {
        hidden = {
            ['*'] = {},
        },
    },
}

----------------------------------------------------------------------------------------------------
------------------------------------------------ICONS-----------------------------------------------
----------------------------------------------------------------------------------------------------

local left, right, top, bottom = GetObjectIconTextureCoords("4772") --MagePortalAlliance
local left2, right2, top2, bottom2 = GetObjectIconTextureCoords("4773") --MagePortalHorde

constants.icon = {
    portal = {
        icon = [[Interface\MINIMAP\OBJECTICONSATLAS]],
        tCoordLeft = left,
        tCoordRight = right,
        tCoordTop = top,
        tCoordBottom = bottom,
    },

    MagePortalHorde = {
        icon = [[Interface\MINIMAP\OBJECTICONSATLAS]],
        tCoordLeft = left2,
        tCoordRight = right2,
        tCoordTop = top2,
        tCoordBottom = bottom2,
    },

    auctioneer      = "Interface\\MINIMAP\\TRACKING\\Auctioneer",
    anvil           = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\anvil",
    banker          = "Interface\\MINIMAP\\TRACKING\\Banker",
    barber          = "Interface\\MINIMAP\\TRACKING\\Barbershop",
--    flightmaster    = "Interface\\MINIMAP\\TRACKING\\FlightMaster",
--    food            = "Interface\\MINIMAP\\TRACKING\\Food",
    innkeeper       = "Interface\\MINIMAP\\TRACKING\\Innkeeper",
    mail            = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\mail",
    reforge         = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\reforge",
    stablemaster    = "Interface\\MINIMAP\\TRACKING\\StableMaster",
    trainer      = "Interface\\MINIMAP\\TRACKING\\Profession",
--    reagents        = "Interface\\MINIMAP\\TRACKING\\Reagents",
    transmogrifier  = "Interface\\MINIMAP\\TRACKING\\Transmogrifier",
    tpplatform      = "Interface\\MINIMAP\\TempleofKotmogu_ball_cyan",
    vendor          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\vendor",
    void            = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\void",

}
