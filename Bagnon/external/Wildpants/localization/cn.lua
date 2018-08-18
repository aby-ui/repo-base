--[[
	Chinese Simplified Localization
--]]

local ADDON = ...
local L = LibStub('AceLocale-3.0'):NewLocale(ADDON, 'zhCN')
if not L then return end

--keybinding text
L.ToggleBags = '开关 背包'
L.ToggleBank = '开关 银行'
L.ToggleVault = '开关 虚空仓库'


--system messages
L.NewUser = '这是该角色第一次使用 Bagnon，已载入默认设置。'
L.Updated = '已更新到 v%s'
L.UpdatedIncompatible = '从一个不兼容版本升级，已载入默认设置。'


--slash commands
L.Commands = '命令：'
L.CmdShowInventory = '开关 背包'
L.CmdShowBank = '开关 银行'
L.CmdShowVersion = '显示当前版本'


--frame text
L.TitleBags = '%s 的背包'
L.TitleBank = '%s 的银行'


--tooltips
L.TipBags = '背包'
L.TipChangePlayer = '查看其他角色的物品'
L.TipCleanBags = '整理背包'
L.TipCleanBank = '<右击> 整理银行'
L.TipDepositReagents = '<单击> 存放各种材料'
L.TipFrameToggle = '<右击> 开关其他窗口'
L.TipGoldOnRealm = '%s 上的总资产'
L.TipHideBag = '<单击> 隐藏包裹'
L.TipHideBags = '<单击> 隐藏背包'
L.TipHideSearch = '隐藏搜索'
L.TipManageBank = '管理银行'
L.PurchaseBag = '购买银行空位'
L.TipShowBag = '<单击> 显示包裹'
L.TipShowBags = '<单击> 显示背包'
L.TipShowMenu = '右击打开设置菜单'
L.TipShowSearch = '搜索'
L.TipShowFrameConfig = '设置'
L.TipDoubleClickSearch = '<Alt-拖动> 移动\n<右击> 设置\n<双击> 搜索'
L.Total = '总共'

--itemcount tooltips
L.TipCountEquip = '装备:%d'
L.TipCountBags = '包里:%d'
L.TipCountBank = '银行:%d'
L.TipCountVault = '虚空仓库:%d'
L.TipCountGuild = '公会银行:%d'
L.TipDelimiter = '|'

L.ConfirmTransfer = '储存这件物品将移除该物品上的一切改动并使其无法退还，且无法交易。|n|n你是否要继续？'
L.PurchaseDialog = '你是否想解锁虚空仓库？|n|n|cffffd200花费:|r %s'
L.CannotPurchaseDialog = '你没有足够的金钱来解锁虚空仓库。|n|n|cffff2020花费: %s|r'
L.AskMafia = '向朋友索要'

L.Title = [[%s 的虚空仓库]]
L.NumDeposit = '%d 存放'
L.NumWithdraw = '%d 提取'

--databroker tooltips
L.TipShowBank = '右击 开关银行'
L.TipShowInventory = '单击 开关背包'
L.TipShowOptions = 'Shift-单击 打开设置菜单'
