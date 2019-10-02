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
L.DisplayBlizzard = '显示暴雪框架隐藏背包'

-- frame
L.FrameSettings = '框架设置'
L.FrameSettingsDesc = '此配置设置特定到一个插件框架。'
L.Frame = '框架'
L.Enabled = '启用框架'
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
L.ExclusiveReagent = '分离材料银行'
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
L.ColorSettingsDesc = '此设置允许更改物品在插件框架上的染色以便于识别。'
L.GlowQuality = '按物品品质染色'
L.GlowQuest = '任务物品染色'
L.GlowUnusable = '无用品染色'
L.GlowSets = '套装染色'
L.GlowNew = '新物品发光' 
L.GlowAlpha = '发光亮度'

L.EmptySlots = '显示空格背景材质'
L.ColorSlots = '按背包类型染色'
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
