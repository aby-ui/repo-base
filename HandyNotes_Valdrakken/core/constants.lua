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
        icon_scale_craftingorders = 1.25,
        icon_alpha_craftingorders = 1,
        icon_scale_flightmaster = 1.25,
        icon_alpha_flightmaster = 1,
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
        icon_scale_rostrum = 1.5,
        icon_alpha_rostrum = 1,
        icon_scale_stablemaster = 1.25,
        icon_alpha_stablemaster = 1,
        icon_scale_tpplatform = 1.5,
        icon_alpha_tpplatform = 1,
        icon_scale_trainer = 1.25,
        icon_alpha_trainer = 1,
        icon_scale_transmogrifier = 1.25,
        icon_alpha_transmogrifier = 1,
        icon_scale_vendor = 1.25,
        icon_alpha_vendor = 1,
        icon_scale_void = 1.25,
        icon_alpha_void = 1,
        -- icon_scale_others = 1.25,
        -- icon_alpha_others = 1,

        show_auctioneer = true,
        show_banker = true,
        show_barber = true,
        show_craftingorders = true,
        show_flightmaster = true,
        show_guildvault = true,
        show_innkeeper = true,
        show_mail = true,
        show_portal = true,
        show_portaltrainer = true,
        show_reforge = true,
        show_rostrum = true,
        show_stablemaster = true,
        show_tpplatform = true,
        show_trainer = true,
        show_transmogrifier = true,
        show_vendor = true,
        show_void = true,
        -- show_others = true,

        show_onlymytrainers = false,
        use_old_picons = false,
        picons_vendor = false,
        picons_trainer = false,
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
    "craftingorders",
    "flightmaster",
    "guildvault",
    "innkeeper",
    "mail",
    "portal",
    "portaltrainer",
    "reforge",
    "rostrum",
    "stablemaster",
    "tpplatform",
    "trainer",
    "transmogrifier",
    "vendor",
    "void"
}

constants.icon = {
    portal     = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\portal_blue",
    portal_red = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\portal_red",

    -- npc/poi icons
    auctioneer     = "Interface\\MINIMAP\\TRACKING\\Auctioneer",
    anvil          = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\anvil",
    banker         = "Interface\\MINIMAP\\TRACKING\\Banker",
    barber         = "Interface\\MINIMAP\\TRACKING\\Barbershop",
    craftingorders = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\craftingorders",
    rostrum        = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\rostrum",
    flightmaster   = "Interface\\MINIMAP\\TRACKING\\FlightMaster",
    guildvault     = "Interface\\ICONS\\Achievement_ChallengeMode_Auchindoun_Gold",
    innkeeper      = "Interface\\MINIMAP\\TRACKING\\Innkeeper",
    mail           = "Interface\\MINIMAP\\TRACKING\\Mailbox",
    reforge        = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\reforge",
    stablemaster   = "Interface\\MINIMAP\\TRACKING\\StableMaster",
    trainer        = "Interface\\MINIMAP\\TRACKING\\Profession",
    portaltrainer  = "Interface\\MINIMAP\\TRACKING\\Profession",
    transmogrifier = "Interface\\MINIMAP\\TRACKING\\Transmogrifier",
    tpplatform     = "Interface\\MINIMAP\\TempleofKotmogu_ball_cyan",
    vendor         = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\vendor",
    void           = "Interface\\AddOns\\" .. FOLDER_NAME .. "\\icons\\void",

    -- profession icons (since Dragonflight)
    alchemy = "Interface\\ICONS\\ui_profession_alchemy",
    blacksmithing = "Interface\\ICONS\\ui_profession_blacksmithing",
    cooking = "Interface\\ICONS\\ui_profession_cooking",
    enchanting = "Interface\\ICONS\\ui_profession_enchanting",
    engineering = "Interface\\ICONS\\ui_profession_engineering",
    fishing = "Interface\\ICONS\\ui_profession_fishing",
    herbalism = "Interface\\ICONS\\ui_profession_herbalism",
    inscription = "Interface\\ICONS\\ui_profession_inscription",
    jewelcrafting = "Interface\\ICONS\\ui_profession_jewelcrafting",
    leatherworking = "Interface\\ICONS\\ui_profession_leatherworking",
    mining = "Interface\\ICONS\\ui_profession_mining",
    skinning = "Interface\\ICONS\\ui_profession_skinning",
    tailoring = "Interface\\ICONS\\ui_profession_tailoring",

    -- profession icons OLD
    alchemy_old = "Interface\\ICONS\\trade_alchemy",
    blacksmithing_old = "Interface\\ICONS\\trade_blacksmithing",
    cooking_old = "Interface\\ICONS\\INV_Misc_Food_15",
    enchanting_old = "Interface\\ICONS\\trade_engraving",
    engineering_old = "Interface\\ICONS\\trade_engineering",
    fishing_old = "Interface\\ICONS\\trade_fishing",
    herbalism_old = "Interface\\ICONS\\spell_nature_naturetouchgrow",
    inscription_old = "Interface\\ICONS\\inv_inscription_tradeskill01",
    jewelcrafting_old = "Interface\\ICONS\\inv_misc_gem_01",
    leatherworking_old = "Interface\\ICONS\\inv_misc_armorkit_17",
    mining_old = "Interface\\ICONS\\trade_mining",
    skinning_old = "Interface\\ICONS\\inv_misc_pelt_wolf_01",
    tailoring_old = "Interface\\ICONS\\trade_tailoring"
}
