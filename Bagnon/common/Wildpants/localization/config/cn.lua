--[[
	Chinese Simplified Localization
		Credits: Diablohu, yleaf@cwdg, 狂飙@cwdg, 天下牧@萨格拉斯, ananhaid
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhCN')
if not L then return end

-- global
L.ConfirmGlobals = '确定要禁用特定此角色的特定设置？所有特定设置将丢失。'

-- general
L.GeneralDesc = '这些通用功能可以依据配置切换。'
L.Locked = '锁定框架'
L.Fading = '渐隐效果'
L.TipCount = '提示物品数目'
L.CountGuild = '包含公会银行'
L.FlashFind = '闪烁搜索'
L.DisplayBlizzard = '禁用的背包使用暴雪默认框体'

-- frame
L.FrameSettings = '显示设置'
L.FrameSettingsDesc = '背包/银行/虚空银行等各窗口显示设置'
L.Frame = '窗口'
L.Enabled = '启用窗口整合'
L.CharacterSpecific = '角色特定设置'
L.ActPanel = '作为标准面板'
L.ActPanelTip = [[
如启用，此面板将自动定位
像标准的一样，如同 |cffffffff法术书|r
或 |cffffffff团队查找器|r，并不能被移动。]]

L.BagToggle = '背包切换'
L.Money = '货币'
L.Broker = 'Databroker 插件'
L.Sort = '整理按钮'
L.Search = '切换搜索'
L.Options = '选项按钮'
L.ExclusiveReagent = '单独显示材料银行（通过点击背包按钮切换）'
L.LeftTabs = '左侧规则'
L.LeftTabsTip = [[
如启用，边框标签将被
显示到左侧面板。]]

L.Appearance = '外观'
L.Layer = '层级'
L.BagBreak = '背包分散'
L.ReverseBags = '反向背包排列'
L.ReverseSlots = '反向物品排列'

L.Color = '背景颜色'
L.BorderColor = '边框颜色'

L.Strata = '框架层级'
L.Columns = '列数'
L.Scale = '缩放'
L.ItemScale = '物品缩放'
L.Spacing = '间距'
L.Alpha = '透明度'

-- auto display
L.DisplaySettings = '自动显示'
L.DisplaySettingsDesc = '此设置允许配置游戏事件时自动打开或关闭背包。'
L.DisplayInventory = '打开背包'
L.CloseInventory = '关闭背包'

L.DisplayBank = '打开银行时'
L.DisplayGuildbank = '打开公会银行时'
L.DisplayAuction = '打开拍卖行时'
L.DisplayMail = '打开邮箱时'
L.DisplayTrade = '交易时'
L.DisplayScrapping = '摧毁装备时'
L.DisplayGems = '镶嵌物品时'
L.DisplayCraft = '制作时'
L.DisplayPlayer = '打开角色信息时'

L.CloseCombat = '进入战斗时'
L.CloseVehicle = '进入载具时'
L.CloseBank = '离开银行时'
L.CloseVendor = '离开商人时'
L.CloseMap = '打开世界地图时'

-- colors
L.ColorSettings = '颜色设置'
L.ColorSettingsDesc = '设置物品按钮的呈现效果，以便更好的区分.'
L.GlowQuality = '按物品品质对物品染色'
L.GlowQuest = '对任务物品染色'
L.GlowUnusable = '对无法使用的物品染色'
L.GlowSets = '对已经保存为套装的物品染色' 
L.GlowNew = '新物品发光' 
L.GlowAlpha = '发光亮度'

L.EmptySlots = '显示空格背景材质'
L.ColorSlots = '按背包类型对空格染色'
L.NormalColor = '一般颜色'
L.QuiverColor = '箭袋颜色'
L.SoulColor = '灵魂袋颜色'
L.ReagentColor = '材料银行颜色'
L.LeatherColor = '制皮颜色'
L.InscribeColor = '铭文颜色'
L.HerbColor = '草药颜色'
L.EnchantColor = '附魔颜色'
L.EngineerColor = '工程颜色'
L.GemColor = '宝石颜色'
L.MineColor = '矿石颜色'
L.TackleColor = '工具箱颜色'
L.RefrigeColor = '烹饪颜色'

-- rulesets
L.RuleSettings = '物品规则'
L.RuleSettingsDesc = '这项设置允许选择按照类型显示和排列物品的规则。'
