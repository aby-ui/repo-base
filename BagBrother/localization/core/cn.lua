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
L.Updated = '已更新到 v%s'

--frame titles
L.TitleBags = '%s的背包'
L.TitleBank = '%s的银行'
L.TitleVault = '%s的虚空仓库'

--dropdowns
L.TitleFrames = '%s的框架'
L.SelectCharacter = '选择角色'
L.ConfirmDelete = '确定要删除 %s 的缓存数据？'

--interactions
L.Click = '点击'
L.Drag = '<拖动>'
L.LeftClick = '<左击>'
L.RightClick = '<右击>'
L.DoubleClick = '<双击>'
L.ShiftClick = '<Shift-点击>'

--tooltips
L.Total = '总共'
L.GuildFunds = '公会基金'
L.TipGoldOnRealm = '%s总资产'
L.NumWithdraw = '%d取出'
L.NumDeposit = '%d存入'
L.NumRemainingWithdrawals = '%d取出剩余'

local searchTip = '\n爱不易提示: 会在名称,描述分类,品质等多种信息中搜索。\n  boe/bop/boa -> 装绑/拾取绑定/账号绑定\n  l:>372 -> 物品等级高于372\n  r:60 or 70 -> 需要等级为60级或70级\n  v:10 -> 10.0资料片的物品\n  n:符文 -> 只搜索物品名\n  !或not表示反向, 例如v:!9 v:not < 9 / not boe / !boa\n  l:372 or 385表示装等是372或385的\n  l:>372 <385表示装等在372到385之间的'

--action tooltips
L.TipChangePlayer = '<点击>查看其他角色的物品。'
L.TipCleanItems = '点击整理物品。'
L.TipConfigure = '%s配置此窗口。'
L.TipDepositReagents = '%s存放材料到银行。'
L.TipDeposit = '%s存入。'
L.TipWithdraw = '%s取出（%s剩余）。'
L.TipFrameToggle = '%s切换其他窗口。'
L.TipHideBag = '%s隐藏此背包。'
L.TipHideBags = '%s隐藏背包显示。'
L.TipHideSearch = '%s停止搜索。'..searchTip
L.TipMove = '%s移动。'
L.TipPurchaseBag = '%s购买此银行空位。'
L.TipResetPlayer = '%s返回到当前角色。'
L.TipShowBag = '%s显示此背包。'
L.TipShowBags = '%s显示背包显示。'
L.TipShowBank = '%s切换银行。'
L.TipShowInventory = '%s切换背包。'
L.TipShowOptions = '%s打开选项菜单。'
L.TipShowSearch = '%s搜索'

--item tooltips
L.TipCountEquip = '已装备：%d'
L.TipCountBags = '背包：%d'
L.TipCountBank = '银行：%d'
L.TipCountVault = '虚空仓库：%d'
L.TipCountGuild = '公会：%d'
L.TipDelimiter = '|'

--dialogs
L.AskMafia = '问问大佬'
L.ConfirmTransfer = '存入任一物品将移除全部修改并使其不可交易和不可退款。|n|n希望继续？'
L.CannotPurchaseVault = '没有足够的货币解锁虚空仓库服务|n|n|cffff2020花费：%s|r'
L.PurchaseVault = '希望解锁虚空仓库？|n|n|cffffd200花费：|r %s'
