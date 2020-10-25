--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com
    Sep 9. 2012 yaroot##gmail#com
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'zhCN')
if not L then return end

L.ActionBarBehavior = "动作条行为"
L.ActionBarNumber = "动作条 %d"
L.ActionButtonLookAndFeel = "动作条按钮样式"
L.Advanced = '高级'
L.BagBarShowBags = "显示背包栏"
L.BagBarShowKeyRing = "显示钥匙扣"
L.Bar = '动作条 %d'
L.BarSettings = '%s 框架设置'
L.Buttons = "按钮"
L.ClickThrough = '允许穿透点击'
L.Columns = '一行按钮数'
L.ConfirmCopyProfile = '复制方案 %s 的内容到当前方案?'
L.ConfirmDeleteProfile = '删除方案 %s?'
L.ConfirmResetProfile = '你确定要重置此方案为多米诺默认值(非爱不易默认值)?'
L.Copy = '复制'
L.CopyProfile = '复制方案...'
L.CreateProfile = '创建方案...'
L.Delay = "延迟 (秒)"
L.Delete = '删除'
L.DisableMenuButtons = '隐藏按钮'
L.Duration = "持续时间 (秒)"
L.EnterBindingMode = '绑定按键...'
L.EnterConfigMode = '进入设置模式'
L.EnterName = '输入名称'
L.ExtraBarShowBlizzardTexture = '显示默认周围材质'
L.FadedOpacity = '透明度'
L.FadeIn = "淡入"
L.FadeOut = "淡出"
L.Fading = "渐变"
L.General = '通用'
L.Layout = '布局'
L.LeftToRight = '按钮从左至右排列'
L.LinkedOpacity = '粘附动作条继承透明度'
L.LockActionButtons = '锁定动作条位置'
L.Modifiers = '功能键翻页'
L.None = NONE
L.OneBag = '只显示一个背包图标'
L.Opacity = '鼠标悬停透明度'
L.OutOfCombat = "战斗外"
L.Padding = '边距'
L.Paging = "切换翻页"
L.PossessBar = '心控动作条'
L.PossessBarDesc = "当在某些战斗中控制了敌对单位时，使用哪个动作条显示特殊的动作"
L.Profiles = '方案'
L.ProfilesPanelDesc = '允许你管理Dominos插件的配置'
L.QuickMoveKey = '快速移动按键'
L.QuickPaging = '快速翻页'
L.RCUFocus = '焦点'
L.RCUPlayer = '自己'
L.RCUToT = '目标的目标'
L.ResetProfile = '重置方案...'
L.RightClickUnit = '右键点击'
L.Save = '新建'
L.Scale = '缩放'
L.SelfcastKey = '自我施法按键'
L.Set = '选中'
L.ShowBindingText = '显示按键绑定文字'
L.ShowCountText = "显示数量文字"
L.ShowEmptyButtons = '显示空按钮'
L.ShowEquippedItemBorders = '显示已装备物品边框'
L.ShowInOverrideUI = '载具界面'
L.ShowInPetBattleUI = '宠物战斗界面'
L.ShowKeyring = '显示钥匙链'
L.ShowMacroText = '显示宏名称'
L.ShowMinimapButton = '显示小地图按钮'
L.ShowOverrideUI = '使用默认载具界面'
L.ShowOverrideUIDesc = "显示暴雪自带的载具界面"
L.ShowStates = '显示隐藏条件'
L.ShowTooltips = '显示鼠标提示'
L.ShowTooltipsCombat = '战斗中显示鼠标提示'
L.Size = '按钮总数'
L.Spacing = '按钮间隔'
L.State_ALTSHIFT = strjoin('-', ALT_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLALT = strjoin('-', CTRL_KEY_TEXT, ALT_KEY_TEXT)
L.State_CTRLALTSHIFT = strjoin('-', CTRL_KEY_TEXT, ALT_KEY_TEXT, SHIFT_KEY_TEXT)
L.State_CTRLSHIFT = strjoin('-', CTRL_KEY_TEXT, SHIFT_KEY_TEXT)

if IsMacClient() then
    L.State_META = '命令键'
else
    L.State_META = 'WIN键'
end

L.State_HARM = '敌对目标'
L.State_HELP = '友方目标'
L.State_NOTARGET = '无目标'
L.State_SHIELD = "持盾"
L.StickyBars = '粘附动作条'
L.Targeting = '根据目标翻页'
L.ThemeActionButtons = '按钮皮肤(需要重载界面)'
L.ThemeActionButtonsDesc = "Applies some custom style adjustments to action buttons when enabled, and leave them untouched when not"
L.TopToBottom = '按钮从上至下排列'
L.Visibility = '可见性' --NOUSE
