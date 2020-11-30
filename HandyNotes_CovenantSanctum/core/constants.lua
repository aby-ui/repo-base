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

        show_anvil = true,
        show_innkeeper = true,
        show_mail = true,
        show_portal = true,
        show_reforge = true,
        show_stablemaster = true,
        show_vendor = true,
        show_weaponsmith = true,
--        show_weekly = true,
        show_others = true,

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

    anvil           = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\anvil",
    flightmaster    = "Interface\\MINIMAP\\TRACKING\\FlightMaster",
    innkeeper       = "Interface\\MINIMAP\\TRACKING\\Innkeeper",
    mail            = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\mail",
    reforge         = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\reforge",
    stablemaster    = "Interface\\MINIMAP\\TRACKING\\StableMaster",
    vendor          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\vendor",
    weaponsmith     = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\weaponsmith",
--    weekly          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\weekly",
}
