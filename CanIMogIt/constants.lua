-- Constants for CanIMogIt

local L = CanIMogIt.L


--------------------------------------------
-- Database scan speed values             --
--------------------------------------------


-- Instant - Only the best of connections, or you WILL crash with Error #134
-- CanIMogIt.throttleTime = 0.25
-- CanIMogIt.bufferMax = 10000

-- Near Instant - May cause your game to crash with Error #134
-- CanIMogIt.throttleTime = 0.25
-- CanIMogIt.bufferMax = 200

-- Fast - Less likely to cause lag or crash
-- CanIMogIt.throttleTime = 0.1
-- CanIMogIt.bufferMax = 50

-- Medium - Most likely safe
CanIMogIt.throttleTime = 0.1
CanIMogIt.bufferMax = 25

-- Slow - Will take a long time, but be 100% safe. Use if you have a poor connection.
-- CanIMogIt.throttleTime = 0.5
-- CanIMogIt.bufferMax = 5


--------------------------------------------
-- Tooltip icon, color and text constants --
--------------------------------------------

-- Icons
CanIMogIt.KNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN:0|t "
CanIMogIt.KNOWN_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_OVERLAY"
CanIMogIt.KNOWN_BOE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_BOE:0|t "
CanIMogIt.KNOWN_BOE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_BOE_OVERLAY"
CanIMogIt.KNOWN_BUT_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle:0|t "
CanIMogIt.KNOWN_BUT_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_circle_OVERLAY"
CanIMogIt.KNOWN_BUT_BOE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\KNOWN_BOE_circle:0|t "
CanIMogIt.KNOWN_BUT_BOE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\KNOWN_BOE_circle_OVERLAY"
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND:0|t "
CanIMogIt.UNKNOWABLE_SOULBOUND_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_SOULBOUND_OVERLAY"
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER:0|t "
CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWABLE_BY_CHARACTER_OVERLAY"
CanIMogIt.UNKNOWN_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\UNKNOWN:0|t "
CanIMogIt.UNKNOWN_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\UNKNOWN_OVERLAY"
CanIMogIt.NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE:0|t "
CanIMogIt.NOT_TRANSMOGABLE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE_OVERLAY"
CanIMogIt.NOT_TRANSMOGABLE_BOE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE_BOE:0|t "
CanIMogIt.NOT_TRANSMOGABLE_BOE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\NOT_TRANSMOGABLE_BOE_OVERLAY"
CanIMogIt.QUESTIONABLE_ICON = "|TInterface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE:0|t "
CanIMogIt.QUESTIONABLE_ICON_OVERLAY = "Interface\\Addons\\CanIMogIt\\Icons\\QUESTIONABLE_OVERLAY"


-- Colorblind colors
CanIMogIt.BLUE =   "|cff15abff"
CanIMogIt.BLUE_GREEN = "|cff009e73"
CanIMogIt.PINK = "|cffcc79a7"
CanIMogIt.ORANGE = "|cffe69f00"
CanIMogIt.RED_ORANGE = "|cffff9333"
CanIMogIt.YELLOW = "|cfff0e442"
CanIMogIt.GRAY =   "|cff888888"
CanIMogIt.WHITE =   "|cffffffff"


-- Tooltip Text
local KNOWN =                                           L["Learned."]
local KNOWN_BOE =                                       L["Learned."]
local KNOWN_FROM_ANOTHER_ITEM =                         L["Learned from another item."]
local KNOWN_FROM_ANOTHER_ITEM_BOE =                     L["Learned from another item."]
local KNOWN_BY_ANOTHER_CHARACTER =                      L["Learned for a different class."]
local KNOWN_BY_ANOTHER_CHARACTER_BOE =                  L["Learned for a different class."]
local KNOWN_BUT_TOO_LOW_LEVEL =                         L["Learned but cannot transmog yet."]
local KNOWN_BUT_TOO_LOW_LEVEL_BOE =                     L["Learned but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =       L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE =   L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =           L["Learned for a different class and item."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE =       L["Learned for a different class and item."]
local UNKNOWABLE_SOULBOUND =                            L["Cannot learn: Soulbound"] .. " " -- subClass
local UNKNOWABLE_BY_CHARACTER =                         L["Cannot learn:"] .. " " -- subClass
local CAN_BE_LEARNED_BY =                               L["Can be learned by:"] -- list of classes
local UNKNOWN =                                         L["Not learned."]
local NOT_TRANSMOGABLE =                                L["Cannot be learned."]
local NOT_TRANSMOGABLE_BOE =                            L["Cannot be learned."]
local CANNOT_DETERMINE =                                L["Cannot determine status on other characters."]


-- Combine icons, color, and text into full tooltip
CanIMogIt.KNOWN =                                           CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN
CanIMogIt.KNOWN_BOE =                                       CanIMogIt.KNOWN_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM =                         CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE =                     CanIMogIt.KNOWN_BUT_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN_FROM_ANOTHER_ITEM
CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER =                      CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN_BY_ANOTHER_CHARACTER
CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE =                  CanIMogIt.KNOWN_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN_BY_ANOTHER_CHARACTER
CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL =                         CanIMogIt.KNOWN_ICON .. CanIMogIt.BLUE .. KNOWN_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE =                     CanIMogIt.KNOWN_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =       CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE =   CanIMogIt.KNOWN_BUT_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =           CanIMogIt.KNOWN_BUT_ICON .. CanIMogIt.BLUE .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE =       CanIMogIt.KNOWN_BUT_BOE_ICON .. CanIMogIt.YELLOW .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
-- CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =        CanIMogIt.QUESTIONABLE_ICON .. CanIMogIt.YELLOW .. CANNOT_DETERMINE
CanIMogIt.UNKNOWABLE_SOULBOUND =                            CanIMogIt.UNKNOWABLE_SOULBOUND_ICON .. CanIMogIt.BLUE_GREEN .. UNKNOWABLE_SOULBOUND
CanIMogIt.UNKNOWABLE_BY_CHARACTER =                         CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON .. CanIMogIt.YELLOW .. UNKNOWABLE_BY_CHARACTER
CanIMogIt.UNKNOWN =                                         CanIMogIt.UNKNOWN_ICON .. CanIMogIt.RED_ORANGE .. UNKNOWN
CanIMogIt.NOT_TRANSMOGABLE =                                CanIMogIt.NOT_TRANSMOGABLE_ICON .. CanIMogIt.GRAY .. NOT_TRANSMOGABLE
CanIMogIt.NOT_TRANSMOGABLE_BOE =                            CanIMogIt.NOT_TRANSMOGABLE_BOE_ICON .. CanIMogIt.YELLOW .. NOT_TRANSMOGABLE


CanIMogIt.tooltipIcons = {
    [CanIMogIt.KNOWN] = CanIMogIt.KNOWN_ICON,
    [CanIMogIt.KNOWN_BOE] = CanIMogIt.KNOWN_BOE_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = CanIMogIt.KNOWN_BUT_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN_ICON,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = CanIMogIt.KNOWN_BOE_ICON,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_ICON,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_BOE_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_BUT_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_BUT_ICON,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON,
    -- [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.QUESTIONABLE_ICON,
    [CanIMogIt.UNKNOWABLE_SOULBOUND] = CanIMogIt.UNKNOWABLE_SOULBOUND_ICON,
    [CanIMogIt.UNKNOWABLE_BY_CHARACTER] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON,
    -- [CanIMogIt.CAN_BE_LEARNED_BY] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON,
    [CanIMogIt.UNKNOWN] = CanIMogIt.UNKNOWN_ICON,
    [CanIMogIt.NOT_TRANSMOGABLE] = CanIMogIt.NOT_TRANSMOGABLE_ICON,
    [CanIMogIt.NOT_TRANSMOGABLE_BOE] = CanIMogIt.NOT_TRANSMOGABLE_BOE_ICON,
    -- [CanIMogIt.CANNOT_DETERMINE] = CanIMogIt.QUESTIONABLE_ICON,
}


-- Used by itemOverlay
CanIMogIt.tooltipOverlayIcons = {
    [CanIMogIt.KNOWN] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BOE] = CanIMogIt.KNOWN_BOE_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BY_ANOTHER_CHARACTER_BOE] = CanIMogIt.KNOWN_BOE_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_ICON_OVERLAY,
    [CanIMogIt.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_BOE_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.KNOWN_BUT_ICON_OVERLAY,
    [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = CanIMogIt.KNOWN_BUT_BOE_ICON_OVERLAY,
    -- [CanIMogIt.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = CanIMogIt.QUESTIONABLE_ICON_OVERLAY,
    [CanIMogIt.UNKNOWABLE_SOULBOUND] = CanIMogIt.UNKNOWABLE_SOULBOUND_ICON_OVERLAY,
    [CanIMogIt.UNKNOWABLE_BY_CHARACTER] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    -- [CanIMogIt.CAN_BE_LEARNED_BY] = CanIMogIt.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    [CanIMogIt.UNKNOWN] = CanIMogIt.UNKNOWN_ICON_OVERLAY,
    [CanIMogIt.NOT_TRANSMOGABLE] = CanIMogIt.NOT_TRANSMOGABLE_ICON_OVERLAY,
    [CanIMogIt.NOT_TRANSMOGABLE_BOE] = CanIMogIt.NOT_TRANSMOGABLE_BOE_ICON_OVERLAY,
    -- [CanIMogIt.CANNOT_DETERMINE] = CanIMogIt.QUESTIONABLE_ICON_OVERLAY,
}


-- Other text

CanIMogIt.DATABASE_START_UPDATE_TEXT = L["Updating appearances database."]
CanIMogIt.DATABASE_DONE_UPDATE_TEXT = L["Items updated: "] -- followed by a number

--------------------------------------------
-- Blizzard frame constants --
--------------------------------------------


---- Auction Houses ----
-- Auction House = NUM_BROWSE_TO_DISPLAY
CanIMogIt.NUM_BLACKMARKET_BUTTONS = 12  -- No Blizzard constant

---- Containers ----
-- Bags = NUM_CONTAINER_FRAMES
-- Bag Items = MAX_CONTAINER_ITEMS
-- Bank = NUM_BANKGENERIC_SLOTS
CanIMogIt.NUM_VOID_STORAGE_FRAMES = 80 -- Blizzard functions are locals
-- Guild Bank
-- NOTE: For the guild bank, it appears that it gets unset sometimes. We are
-- referencing it here so we don't error when that happens.
CanIMogIt.NUM_GUILDBANK_COLUMNS = 7 -- Columns
CanIMogIt.NUM_SLOTS_PER_GUILDBANK_GROUP = 14 -- Buttons

---- Others ----
CanIMogIt.NUM_ENCOUNTER_JOURNAL_ENCOUNTER_LOOT_FRAMES = 10 -- Blizzard functions are locals
-- Loot Roll = NUM_GROUP_LOOT_FRAMES
CanIMogIt.NUM_MAIL_INBOX_ITEMS = 7
-- Mail Attachments = ATTACHMENTS_MAX_SEND
-- Merchant Items = MERCHANT_ITEMS_PER_PAGE
CanIMogIt.NUM_WARDROBE_COLLECTION_BUTTONS = 12 -- Blizzard functions are locals
-- Trade Skill = no constants
