

local Details = _G._detalhes
local DF = _G.DetailsFramework
local _

--local AceComm = LibStub ("AceComm-3.0")
--local AceSerializer = LibStub ("AceSerializer-3.0")
local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")

local CONST_MENU_X_POSITION = 10
local CONST_MENU_Y_POSITION = -40
local CONST_MENU_WIDTH = 160
local CONST_MENU_HEIGHT = 20

local CONST_INFOBOX_X_POSITION = 220
local CONST_EDITBUTTONS_X_POSITION = 560

local CONST_EDITBOX_Y_POSITION = -200
local CONST_EDITBOX_WIDTH = 900
local CONST_EDITBOX_HEIGHT = 370

local CONST_EDITBOX_BUTTON_WIDTH = 80
local CONST_EDITBOX_BUTTON_HEIGHT = 20

local CONST_BUTTON_TEMPLATE = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
local CONST_TEXTENTRY_TEMPLATE = DF:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")

DF:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BUTTONS", 
    {
        icon = {texture = [[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]]},
        width = 160,
    }, 
    "DETAILS_PLUGIN_BUTTON_TEMPLATE"
)

DF:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_REGULAR_BUTTON", 
    {
        width = 130,
    }, 
    "DETAILS_PLUGIN_BUTTON_TEMPLATE"
)

DF:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX", {
    backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
    backdropcolor = {.2, .2, .2, 0.6},
    backdropbordercolor = {0, 0, 0, 1},
})
DF:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_EXPANDED", {
    backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
    backdropcolor = {.2, .2, .2, 1},
    backdropbordercolor = {0, 0, 0, 1},
})
DF:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_BUTTON", {
    backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
    backdropcolor = {.2, .2, .2, 1},
    backdropbordercolor = {0, 0, 0, 1},
})

DF:NewColor ("DETAILS_CUSTOMDISPLAY_ICON", .7, .6, .5, 1)

local CONST_CODETEXTENTRY_TEMPLATE = DF:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX")
local CONST_CODETEXTENTRYEXPANDED_TEMPLATE = DF:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_EXPANDED")
local CONST_CODETEXTENTRYBUTTON_TEMPLATE = DF:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_BUTTON")
local CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE = DF:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BUTTONS")
local CONST_REGULAR_BUTTON_TEMPLATE = DF:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_REGULAR_BUTTON")


--new script button


--search script box


--control buttons like import, export, delete, restore


--build the left menu, this menu has all scripts to edit


--build the script properties panel with name, icon, etc


--
