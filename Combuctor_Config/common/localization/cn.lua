--[[
	Chinese Simplified Localization
		Credits: Diablohu, yleaf@cwdg, 狂飙@cwdg, 天下牧@萨格拉斯
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhCN')
if not L then return end

-- general
L.GeneralDesc = '通用设置'
L.Locked = '锁定位置'
L.Fading = '启用框架渐隐'
L.TipCount = '启用物品统计提示'
L.FlashFind = '启用闪烁搜索'
L.EmptySlots = '显示空格背景材质'
L.DisplayBlizzard = '禁用的背包使用暴雪默认框体'

-- frame
L.FrameSettings = '显示设置'
L.FrameSettingsDesc = '窗口显示设置'
--L.Frame = 'Frame'
--L.Enabled = 'Enable Frame'
--L.CharacterSpecific = 'Character Specific Settings'
--L.ExclusiveReagent = 'Separate Reagent Bank'

L.BagFrame = '启用背包按钮'
L.Money = '启用货币窗口'
L.Broker = '启用信息窗口'
--L.Sort = 'Sort Button'
L.Options = '启用整理按钮'
L.Search = '启用搜索按钮'

--L.Appearance = 'Appearance'
L.Layer = '窗口层级'
L.BagBreak = '启用背包分散布局'
--L.ReverseBags = 'Reverse Bag Order'
L.ReverseSlots = '反向排列'

L.Color = '窗口颜色'
L.BorderColor = '窗口边框颜色'

L.Strata = '窗口层级'
L.Columns = '列数'
L.Scale = '缩放'
--L.ItemScale = 'Item Scale'
L.Spacing = '间距'
L.Alpha = '透明度'

-- auto display
L.DisplaySettings = '事件设置'
L.DisplaySettingsDesc = '何时自动打开背包'
--L.DisplayInventory = 'Display Inventory'
--L.CloseInventory = 'Close Inventory'

L.DisplayBank = '打开银行时'
L.DisplayAuction = '打开拍卖行时'
L.DisplayTrade = '交易时'
L.DisplayCraft = '制作物品时'
L.DisplayMail = '打开邮箱时'
L.DisplayGuildbank = '打开公会银行时'
L.DisplayPlayer = '打开角色信息时'
L.DisplayGems = '打开物品镶嵌时'

L.CloseCombat = '进入战斗时关闭'
L.CloseVehicle = '进入载具时关闭'
--L.CloseBank = 'Leaving the Bank'
L.CloseVendor = '与商贩对话时'

-- colors
L.ColorSettings = '颜色设置'
L.ColorSettingsDesc = '物品染色设置'
L.GlowQuality = '按物品品质对物品染色'
L.GlowNew = '对新物品染色' 
L.GlowQuest = '对任务物品染色'
L.GlowUnusable = '对无法使用的物品染色'
L.GlowSets = '对已经保存为套装的物品染色' 
L.ColorSlots = '按背包类型对空格染色'

L.NormalColor = '一般背包槽颜色'
L.LeatherColor = '制皮包槽颜色'
L.InscribeColor = '铭文包槽颜色'
L.HerbColor = '草药包槽颜色'
L.EnchantColor = '附魔包槽颜色'
L.EngineerColor = '工程箱槽颜色'
L.GemColor = '宝石包槽颜色'
L.MineColor = '矿石包槽颜色'
L.TackleColor = '工具箱槽颜色'
L.RefrigeColor = '烹饪包槽颜色'
L.ReagentColor = '材料银行颜色'
L.GlowAlpha = '物品高亮亮度'