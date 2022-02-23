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
        icon_scale_innkeeper = 1.25,
        icon_alpha_innkeeper = 1.0,
        icon_scale_mail = 1.25,
        icon_alpha_mail = 1.0,
        icon_scale_portal = 1.5,
        icon_alpha_portal = 1.0,
        icon_scale_reforge = 1.25,
        icon_alpha_reforge = 1.0,
        icon_scale_renown = 1.25,
        icon_alpha_renown = 1.0,
        icon_scale_stablemaster = 1.25,
        icon_alpha_stablemaster = 1.0,
        icon_scale_vendor = 1.25,
        icon_alpha_vendor = 1.0,
        icon_scale_weaponsmith = 1.25,
        icon_alpha_weaponsmith = 1.0,
        icon_scale_others = 1.25,
        icon_alpha_others = 1.0,

        show_anvil = true,
        show_innkeeper = true,
        show_mail = true,
        show_portal = true,
        show_reforge = true,
        show_renown = true,
        show_stablemaster = true,
        show_vendor = true,
        show_weaponsmith = true,
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

constants.icongroup = {
    "innkeeper",
    "mail",
    "portal",
    "reforge",
    "renown",
    "stablemaster",
    "vendor",
    "weaponsmith",
    "others"
}

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
    flightMaster    = "Interface\\MINIMAP\\TRACKING\\FlightMaster",
    innkeeper       = "Interface\\MINIMAP\\TRACKING\\Innkeeper",
    mail            = "Interface\\MINIMAP\\TRACKING\\Mailbox",
    reforge         = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\reforge",
    renown          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\renown",
    stablemaster    = "Interface\\MINIMAP\\TRACKING\\StableMaster",
    trainer         = "Interface\\MINIMAP\\TRACKING\\Profession",
    vendor          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\vendor",
    weaponsmith     = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\weaponsmith",
}
