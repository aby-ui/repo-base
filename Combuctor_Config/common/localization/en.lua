--[[
	English Localization
		This file must be present to have partial translations
		***
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'enUS', true, 'raw')

-- general
L.GeneralDesc = 'These are general features that can be toggled depending on your preferences.'
L.Locked = 'Lock Frames'
L.Fading = 'Fading Effects'
L.TipCount = 'Tooltip Item Count'
L.CountGuild = 'Include Guild Banks'
L.FlashFind = 'Flash Find'
L.EmptySlots = 'Display Background on Empty Slots'
L.DisplayBlizzard = 'Display Blizzard Frames for Hidden Bags'

-- frame
L.FrameSettings = 'Frame Settings'
L.FrameSettingsDesc = 'These are configuration settings specific to a ADDON frame.'
L.Frame = 'Frame'
L.Enabled = 'Enable Frame'
L.CharacterSpecific = 'Character Specific Settings'
L.ActPanel = 'Act as Standard Panel'
L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

L.BagFrame = 'Bag List'
L.Money = 'Money'
L.Broker = 'Databroker Plugins'
L.Sort = 'Sort Button'
L.Search = 'Search Toggle'
L.Options = 'Options Button'
L.ExclusiveReagent = 'Separate Reagent Bank'
L.LeftTabs = 'Rulesets on Left'
L.LeftTabsTip = [[
If enabled, the side tabs will be
displayed on the left side of the panel.]]

L.Appearance = 'Appearance'
L.Layer = 'Layer'
L.BagBreak = 'Bag Break'
L.ReverseBags = 'Reverse Bag Order'
L.ReverseSlots = 'Reverse Slot Order'

L.Color = 'Background Color'
L.BorderColor = 'Border Color'

L.Strata = 'Frame Layer'
L.Columns = 'Columns'
L.Scale = 'Scale'
L.ItemScale = 'Item Scale'
L.Spacing = 'Spacing'
L.Alpha = 'Opacity'

-- auto display
L.DisplaySettings = 'Automatic Display'
L.DisplaySettingsDesc = 'These settings allow you to configure when your inventory automatically opens or closes due to game events.'
L.DisplayInventory = 'Display Inventory'
L.CloseInventory = 'Close Inventory'

L.DisplayBank = 'Visiting the Bank'
L.DisplayAuction = 'Visiting the Auction House'
L.DisplayTrade = 'Trading Items'
L.DisplayCraft = 'Crafting'
L.DisplayMail = 'Checking a Mailbox'
L.DisplayGuildbank = 'Visiting the Guild Bank'
L.DisplayPlayer = 'Opening the Character Info'
L.DisplayGems = 'Socketing Items'

L.CloseCombat = 'Entering Combat'
L.CloseVehicle = 'Entering a Vehicle'
L.CloseBank = 'Leaving the Bank'
L.CloseVendor = 'Leaving a Vendor'

-- colors
L.ColorSettings = 'Color Settings'
L.ColorSettingsDesc = 'These settings allow you to change how item slots are presented on ADDON frames for easier identification.'
L.GlowQuality = 'Highlight Items by Quality'
L.GlowNew = 'Highlight New Items'
L.GlowQuest = 'Highlight Quest Items'
L.GlowUnusable = 'Highlight Unusable Items'
L.GlowSets = 'Highlight Equipment Set Items'
L.ColorSlots = 'Color Empty Slots by Bag Type'

L.NormalColor = 'Normal Color'
L.LeatherColor = 'Leatherworking Color'
L.InscribeColor = 'Inscription Color'
L.HerbColor = 'Herbalism Color'
L.EnchantColor = 'Enchanting Color'
L.EngineerColor = 'Engineering Color'
L.GemColor = 'Gem Color'
L.MineColor = 'Mining Color'
L.TackleColor = 'Tackle Box Color'
L.RefrigeColor = 'Refrigerator Color'
L.ReagentColor = 'Reagent Bank Color'
L.GlowAlpha = 'Highlight Brightness'

-- rulesets
L.RuleSettings = 'Item Rulesets'
L.RuleSettingsDesc = 'These settings allow you to choose which item rulesets to display and in which order.'
