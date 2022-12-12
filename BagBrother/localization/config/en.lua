--[[
  English Localization (default)
--]]

local CONFIG = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'enUS', true, 'raw')

-- general
L.GeneralOptionsDesc = 'These are general features that can be toggled depending on your preferences.'
L.Locked = 'Lock Frames'
L.TipCount = 'Tooltip Item Count'
L.CountGuild = 'Include Guild Banks'
L.FlashFind = 'Flash Find'
L.DisplayBlizzard = 'Fallback Hidden Bags'
L.DisplayBlizzardTip = 'If enabled, the default Blizzard UI bag panels will be displayed for hidden inventory or bank containers.\n\n|cffff1919Requires UI reload.|r'
L.ConfirmGlobals = 'Are you sure you want to disable specific settings for this character? All specific settings will be lost.'
L.CharacterSpecific = 'Character Specific Settings'

-- frame
L.FrameOptions = 'Frame Settings'
L.FrameOptionsDesc = 'These are configuration settings specific to a %s frame.'
L.Frame = 'Frame'
L.Enabled = 'Enable Frame'
L.EnabledTip = 'If disabled, the default Blizzard UI will not be replaced for this frame.\n\n|cffff1919Requires UI reload.|r'
L.ActPanel = 'Act as Standard Panel'
L.ActPanelTip = [[
If enabled, this panel will automatically position
itself as the standard ones do, such as the |cffffffffSpellbook|r
or the |cffffffffDungeon Finder|r, and will not be movable.]]

L.BagToggle = 'Bags Toggle'
L.Broker = 'Databroker Plugins'
L.Currency = 'Currencies'
L.ExclusiveReagent = 'Separate Reagent Bank'
L.Money = 'Money'
L.Sort = 'Sort Button'
L.Search = 'Search Toggle'
L.Options = 'Options Button'
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
L.DisplayOptions = 'Automatic Display'
L.DisplayOptionsDesc = 'These settings allow you to configure when your inventory automatically opens or closes due to game events.'
L.DisplayInventory = 'Display Inventory'
L.CloseInventory = 'Close Inventory'

L.Auctioneer = 'At the Auction House'
L.Banker = 'At the Bank'
L.Combat = 'Entering Combat'
L.Crafting = 'Crafting'
L.GuildBanker = 'At the Guild Bank'
L.VoidStorageBanker = 'At Void Storage'
L.MailInfo = 'At a Mailbox'
L.MapFrame = 'Opening the World Map'
L.Merchant = 'Talking to Merchant'
L.PlayerFrame = 'Opening the Character Info'
L.ScrappingMachine = 'Scrapping Equipment'
L.Socketing = 'Socketing Equipment'
L.TradePartner = 'Trading'
L.Vehicle = 'Entering a Vehicle'

-- colors
L.ColorOptions = 'Color Settings'
L.ColorOptionsDesc = 'These settings allow you to change how item slots are presented on %s frames for easier identification.'

L.GlowQuality = 'Color by Quality'
L.GlowQuest = 'Color Quest Items'
L.GlowUnusable = 'Color Unusable Items'
L.GlowSets = 'Color Equipment Sets'
L.GlowNew = 'Flash New Items'
L.GlowPoor = 'Mark Poor Items'
L.GlowAlpha = 'Glow Brightness'

L.EmptySlots = 'Display Background'
L.ColorSlots = 'Color by Bag Type'
L.NormalColor = 'Normal Color'
L.KeyColor = 'Key Color'
L.QuiverColor = 'Quiver Color'
L.SoulColor = 'Soul Bag Color'
L.ReagentColor = 'Reagent Bank Color'
L.LeatherColor = 'Leatherworking Color'
L.InscribeColor = 'Inscription Color'
L.HerbColor = 'Herbalism Color'
L.EnchantColor = 'Enchanting Color'
L.EngineerColor = 'Engineering Color'
L.GemColor = 'Gem Color'
L.MineColor = 'Mining Color'
L.TackleColor = 'Tackle Box Color'
L.FridgeColor = 'Refrigerator Color'

-- rulesets
L.RuleOptions = 'Item Rulesets'
L.RuleOptionsDesc = 'These settings allow you to choose which item rulesets to display and in which order.'
