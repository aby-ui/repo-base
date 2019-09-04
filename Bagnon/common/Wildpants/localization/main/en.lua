--[[
	English Localization (default)
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'enUS', true)

--keybindings
L.ToggleBags = 'Toggle Inventory'
L.ToggleBank = 'Toggle Bank'
L.ToggleGuild = 'Toggle Guild Bank'
L.ToggleVault = 'Toggle Void Storage'

--terminal
L.Commands = 'command list'
L.CmdShowInventory = 'Toggles your inventory'
L.CmdShowBank = 'Toggles your bank'
L.CmdShowGuild = 'Toggles your guild bank'
L.CmdShowVault = 'Toggles your void storage'
L.CmdShowVersion = 'Prints the current verison'
L.CmdShowOptions = 'Opens the configuration menu'
L.Updated = 'Updated to v%s'

--frame titles
L.TitleBags = '%s\'s Inventory'
L.TitleBank = '%s\'s Bank'
L.TitleVault = '%s\'s Void Storage'

--tooltips
L.TipChangePlayer = '<Left-Click> to view another character\'s items.'
L.TipCleanBags = 'Click to clean up bags.'
L.TipCleanBank = '<Right-Click> to to clean up bank.'
L.TipDepositReagents = '<Left-Click> to deposit all reagents.'
L.TipFrameToggle = '<Right-Click> to toggle other windows.'
L.TipGoldOnRealm = '%s Totals'
L.TipHideBag = 'Click to hide this bag.'
L.TipHideBags = '<Left-Click> to hide the bags display.'
L.TipHideSearch = 'Click to hide the search box.'
L.TipManageBank = 'Manage Bank'
L.TipResetPlayer = '<Right-Click> to return to the current character.'
L.TipPurchaseBag = 'Click to purchase this bank slot.'
L.TipShowBag = 'Click to show this bag.'
L.TipShowBags = '<Left-Click> to show the bags display.'
L.TipShowBank = '<Right Click> to toggle your bank.'
L.TipShowInventory = '<Left Click> to toggle your inventory.'
L.TipShowMenu = '<Right-Click> to configure this window.'
L.TipShowOptions = '<Shift Click> to open the options menu.'
L.TipShowSearch = 'Click to search'
L.TipShowFrameConfig = 'Click to configure this window'
L.TipDoubleClickSearch = '<Alt-Drag> to move.\n<Right-Click> to configure.\n<Double-Click> to search.'
L.TipDeposit = '<Left Click> to deposit.'
L.TipWithdrawRemaining = '<Right Click> to withdraw (%s remaining).'
L.WithdrawalsRemaining = '%d Withdrawals Remaining'
L.NumWithdraw = '%d withdraw'
L.NumDeposit = '%d deposit'
L.GuildFunds = 'Guild Funds'
L.Total = 'Total'

--dialogs
L.ConfirmTransfer = 'Depositing these items will remove all modifications and make them non-tradeable and non-refundable.|n|nDo you wish to continue?'
L.PurchaseVault = 'Would you like to unlock the Void Storage service?|n|n|cffffd200Cost:|r %s'
L.CannotPurchaseVault = 'You do not have enough money to unlock the Void Storage service|n|n|cffff2020Cost: %s|r'
L.AskMafia = 'Ask Mafia'

--item tooltips
L.TipCountEquip = 'Equipped: %d'
L.TipCountBags = 'Bags: %d'
L.TipCountBank = 'Bank: %d'
L.TipCountVault = 'Vault: %d'
L.TipCountGuild = 'Guild: %d'
L.TipDelimiter = '|'
