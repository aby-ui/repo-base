--[[
	Chinese Traditional Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'zhTW')
if not L then return end

--keybindings
L.ToggleBags = '切換 背包'
L.ToggleBank = '切換 銀行'
L.ToggleGuild = '切換 公會銀行'
L.ToggleVault = '切換 虛空倉庫'

--terminal
L.Commands = '命令：'
L.CmdShowInventory = '切換背包'
L.CmdShowBank = '切換銀行'
L.CmdShowGuild = '切換公會銀行'
L.CmdShowVault = '切換虛空倉庫'
L.CmdShowVersion = '顯示目前版本'
L.Updated = '已更新到 v%s'

--frames
L.TitleBags = '%s的背包'
L.TitleBank = '%s的銀行'
L.TitleVault = '%s的虛空倉庫'
--interactions
L.Click = '點擊'
L.Drag = '<拖動>'
L.LeftClick = '<右鍵點擊>'
L.RightClick = '<右鍵點擊>'
L.DoubleClick = '<連按兩下>'
L.ShiftClick = '<shift鍵+點擊>'

--tooltips
L.TipBags = '背包'
L.TipChangePlayer = '點擊檢視其他角色的物品。'
L.TipCleanBags = '點擊整理背包。'
L.TipCleanBank = '<右鍵點擊>整理銀行。'
L.TipDepositReagents = '<右鍵點擊>全部存放到材料銀行。'
L.TipFrameToggle = '<右鍵點擊>切換其它視窗。'
L.TipGoldOnRealm = '%s上的總資產'
L.TipHideBag = '點擊隱藏背包。'
L.TipHideBags = '<左鍵點擊>隱藏背包顯示。'
L.TipHideSearch = '點擊隱藏搜尋介面。'
L.TipManageBank = '管理銀行'
L.PurchaseBag = '點擊購買銀行槽。'
L.TipShowBag = '點擊顯示背包。'
L.TipShowBags = '<左鍵點擊>顯示背包顯示。'
L.TipShowMenu = '<右鍵點擊>設定視窗。'
L.TipShowFrameConfig = '開啟設定視窗。'
L.TipDoubleClickSearch = '<拖動>移動。\n<右鍵點擊>設定。\n<兩次點擊>搜尋。'
L.Total = '總共'
L.TipResetPlayer = '%s返回現時角色'
L.TipCleanItems = '%s整理物品'
L.TipMove = '%s移動'
L.TipShowSearch = '%s搜尋'
L.TipConfigure = '%s設定這框架'

L.GuildFunds = '工會資金'
L.NumWithdraw = '%d 提款'
L.NumDeposit = '%d 存款'
L.NumRemainingWithdrawals = '%d 剩餘提款'

--itemcount tooltips
L.TipCountEquip = '已裝備: %d'
L.TipCountBags = '背包: %d'
L.TipCountBank = '銀行: %d'
L.TipCountVault = '虛空倉庫: %d'
L.TipCountGuild = '工會銀行: %d'
L.TipDelimiter = '|'

--databroker plugin tooltips
L.TipShowInventory = '<左鍵點擊>切換背包。'
L.TipShowBank = '<右鍵點擊>切換銀行。'
L.TipShowOptions = '<Shift-左鍵點擊>開啟設定選單。'
