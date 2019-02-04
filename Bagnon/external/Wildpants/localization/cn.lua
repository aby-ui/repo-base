--[[
	Chinese Simplified Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'zhCN')
if not L then return end

--keybindings
L.ToggleBags = '切换背包'
L.ToggleBank = '切换银行'
L.ToggleGuild = '切换公会银行'
L.ToggleVault = '切换虚空仓库'

--terminal
L.Commands = '命令列表'
L.CmdShowInventory = '切换背包'
L.CmdShowBank = '切换银行'
L.CmdShowGuild = '切换公会银行'
L.CmdShowVault = '切换虚空仓库'
L.CmdShowVersion = '列出当前版本'
L.CmdShowOptions = '打开配置菜单'
L.Updated = '已更新到v%s'


--frame titles
L.TitleBags = '%s的背包'
L.TitleBank = '%s的银行'
L.TitleVault = '%s的虚空仓库'

--tooltips
L.TipChangePlayer = '<点击>查看其他角色的物品。'
L.TipCleanBags = '点击整理背包。'
L.TipCleanBank = '<右击>整理银行。'
L.TipDepositReagents = '<单击>存放全部材料。'
L.TipFrameToggle = '<右击>切换其他窗口。'



L.TipGoldOnRealm = '%s总资产'
L.TipHideBag = '点击隐藏此背包。'
L.TipHideBags = '<点击>隐藏背包显示。'
L.TipHideSearch = '点击隐藏搜索框。'
L.TipManageBank = '管理银行'
L.TipResetPlayer = '<右击>返回到当前角色。'
L.TipPurchaseBag = '点击购买此银行空位。'
L.TipShowBag = '点击显示此背包。'
L.TipShowBags = '<单击>显示此背包样式。'
L.TipShowBank = '<右击>切换银行。'
L.TipShowInventory = '<点击>切换背包。'
L.TipShowMenu = '<右击>配置此窗口。'
L.TipShowOptions = '<Shift 点击>打开选项菜单。'
L.TipShowSearch = '点击搜索'
L.TipShowFrameConfig = '点击配置此窗口'
L.TipDoubleClickSearch = '<Alt 拖动>移动。\n<右击>配置。\n<双击>搜索。'
L.TipDeposit = '<点击>存入。'
L.TipWithdrawRemaining = '<右击>取出（%s剩余）。'
L.WithdrawalsRemaining = '%d取出剩余'
L.NumWithdraw = '%d取出'
L.NumDeposit = '%d存入'
L.GuildFunds = '公会基金'
L.Total = '总共'

--dialogs
L.ConfirmTransfer = '存入此物品将移除全部修改并使其不可交易和不可退款。|n|n希望继续？'
L.PurchaseVault = '希望解锁虚空仓库？|n|n|cffffd200花费：|r %s'
L.CannotPurchaseVault = '没有足够的货币解锁虚空仓库服务|n|n|cffff2020花费：%s|r'
L.AskMafia = '问问大佬'

--item tooltips
L.TipCountEquip = '已装备：%d'
L.TipCountBags = '背包：%d'
L.TipCountBank = '银行：%d'
L.TipCountVault = '虚空仓库：%d'
L.TipCountGuild = '公会：%d'
L.TipDelimiter = '|'
