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
        icon_scale_auctioneer = 1.25,
        icon_alpha_auctioneer = 1,
        icon_scale_banker = 1.25,
        icon_alpha_banker = 1,
        icon_scale_barber = 1.25,
        icon_alpha_barber = 1,
        icon_scale_guildvault = 1.3,
        icon_alpha_guildvault = 1,
        icon_scale_innkeeper = 1.25,
        icon_alpha_innkeeper = 1,
        icon_scale_mail = 1.25,
        icon_alpha_mail = 1,
        icon_scale_portal = 1.5,
        icon_alpha_portal = 1,
        icon_scale_portaltrainer = 1.25,
        icon_alpha_portaltrainer = 1,
        icon_scale_reforge = 1.25,
        icon_alpha_reforge = 1,
        icon_scale_stablemaster = 1.25,
        icon_alpha_stablemaster = 1,
        icon_scale_trainer = 1.25,
        icon_alpha_trainer = 1,
        icon_scale_transmogrifier = 1.25,
        icon_alpha_transmogrifier = 1,
        icon_scale_tpplatform = 1.5,
        icon_alpha_tpplatform = 1,
        icon_scale_vendor = 1.25,
        icon_alpha_vendor = 1,
        icon_scale_void = 1.25,
        icon_alpha_void = 1,
        icon_scale_zonegateway = 2,
        icon_alpha_zonegateway = 1,
        -- icon_scale_others = 1.25,
        -- icon_alpha_others = 1,

        show_auctioneer = true,
        show_banker = true,
        show_barber = true,
        show_guildvault = true,
        show_innkeeper = true,
        show_mail = true,
        show_portal = true,
        show_portaltrainer = true,
        show_tpplatform = true,
        show_reforge = true,
        show_stablemaster = true,
        show_trainer = true,
        show_transmogrifier = true,
        show_vendor = true,
        show_void = true,
        show_zonegateway = true,
        -- show_others = true,

        show_onlymytrainers = true,
        fmaster_waypoint = false,
        fmaster_waypoint_dropdown = 1,
        easy_waypoint = true,
        easy_waypoint_dropdown = 1,

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
    "auctioneer",
    -- "anvil",
    "banker",
    "barber",
    "guildvault",
    "innkeeper",
    "mail",
    "portal",
    "portaltrainer",
    "reforge",
    "stablemaster",
    "trainer",
    "transmogrifier",
    "tpplatform",
    "vendor",
    "void",
    "zonegateway"
}

local left, right, top, bottom = GetObjectIconTextureCoords(4772) --MagePortalAlliance
local left2, right2, top2, bottom2 = GetObjectIconTextureCoords(4773) --MagePortalHorde

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

    -- npc/poi icons
    auctioneer      = "Interface\\MINIMAP\\TRACKING\\Auctioneer",
    anvil           = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\anvil",
    banker          = "Interface\\MINIMAP\\TRACKING\\Banker",
    barber          = "Interface\\MINIMAP\\TRACKING\\Barbershop",
    guildvault      = "Interface\\ICONS\\Achievement_ChallengeMode_Auchindoun_Gold",
    innkeeper       = "Interface\\MINIMAP\\TRACKING\\Innkeeper",
    mail            = "Interface\\MINIMAP\\TRACKING\\Mailbox",
    reforge         = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\reforge",
    stablemaster    = "Interface\\MINIMAP\\TRACKING\\StableMaster",
    trainer         = "Interface\\MINIMAP\\TRACKING\\Profession",
    portaltrainer   = "Interface\\MINIMAP\\TRACKING\\Profession",
    transmogrifier  = "Interface\\MINIMAP\\TRACKING\\Transmogrifier",
    tpplatform      = "Interface\\MINIMAP\\TempleofKotmogu_ball_cyan",
    vendor          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\vendor",
    void            = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\void",

    -- covenant icons
    kyrian          = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\kyrian",
    necrolord       = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\necrolord",
    nightfae        = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\nightfae",
    venthyr         = "Interface\\AddOns\\"..FOLDER_NAME.."\\icons\\venthyr",

    -- profession icons
    alchemy         = "Interface\\ICONS\\trade_alchemy",
    blacksmithing   = "Interface\\ICONS\\trade_blacksmithing",
    cooking         = "Interface\\ICONS\\INV_Misc_Food_15",
    enchanting      = "Interface\\ICONS\\trade_engraving",
    engineering     = "Interface\\ICONS\\trade_engineering",
    fishing         = "Interface\\ICONS\\trade_fishing",
    herbalism       = "Interface\\ICONS\\spell_nature_naturetouchgrow",
    inscription     = "Interface\\ICONS\\inv_inscription_tradeskill01",
    jewelcrafting   = "Interface\\ICONS\\inv_misc_gem_01",
    leatherworking  = "Interface\\ICONS\\inv_misc_armorkit_17",
    mining          = "Interface\\ICONS\\trade_mining",
    skinning        = "Interface\\ICONS\\inv_misc_pelt_wolf_01",
    tailoring       = "Interface\\ICONS\\trade_tailoring"

}
