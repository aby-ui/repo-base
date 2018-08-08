--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com
    Sep 9. 2012 yaroot##gmail#com
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'zhCN')
if not L then return end

L.Scale = '缩放'
L.Opacity = '鼠标悬停透明度'
L.FadedOpacity = '透明度'
L.Visibility = '可见性' --NOUSE
L.Spacing = '按钮间隔'
L.Padding = '边距'
L.Layout = '布局'
L.Columns = '一行按钮数'
L.Size = '按钮总数'
L.Modifiers = '功能键翻页'
L.QuickPaging = '快速翻页'
L.Targeting = '根据目标翻页'
L.ShowStates = '显示隐藏条件'
L.Set = '选中'
L.Save = '新建'
L.Copy = '复制'
L.Delete = '删除'
L.Bar = '动作条 %d'
L.RightClickUnit = '右键点击'
L.RCUPlayer = '自己'
L.RCUFocus = '焦点'
L.RCUToT = '目标的目标'
L.EnterName = '输入名称'
L.PossessBar = '载具'
L.Profiles = '方案'
L.ProfilesPanelDesc = '允许你管理Dominos插件的配置'
L.SelfcastKey = '自我施法按键'
L.QuickMoveKey = '快速移动按键'
L.ShowMacroText = '显示宏名称'
L.ShowBindingText = '显示按键绑定文字'
L.ShowEmptyButtons = '显示空按钮'
L.LockActionButtons = '锁定动作条位置'
L.EnterBindingMode = '绑定按键...'
L.EnterConfigMode = '进入设置模式'
L.ActionBarSettings = '动作条 %d 设置'
L.BarSettings = '%s 动作条设置'
L.ShowTooltips = '显示鼠标提示'
L.ShowTooltipsCombat = '战斗中显示鼠标提示'
L.OneBag = '只显示一个背包图标'
L.ShowKeyring = '显示钥匙链'
L.StickyBars = '粘附动作条'
L.ShowMinimapButton = '显示小地图按钮'
L.Advanced = '高级'
L.LeftToRight = '按钮从左至右排列'
L.TopToBottom = '按钮从上至下排列'
L.LinkedOpacity = '粘附动作条继承透明度'
L.ClickThrough = '允许穿透点击'
L.DisableMenuButtons = '隐藏按钮'
L.ShowOverrideUI = '使用默认载具界面'
L.ShowInOverrideUI = '载具界面'
L.ShowInPetBattleUI = '宠物战斗界面'
L.ShowEquippedItemBorders = '动作条上已装备物品显示边框'

L.ALT_KEY_TEXT = 'ALT'

L.State_HELP = '友方目标'
L.State_HARM = '敌对目标'
L.State_NOTARGET = '无目标'
L.State_ALTSHIFT = 'ALT-' .. SHIFT_KEY_TEXT
L.State_CTRLSHIFT = CTRL_KEY_TEXT .. '-' .. SHIFT_KEY_TEXT
L.State_CTRLALT = CTRL_KEY_TEXT .. '-ALT'
L.State_CTRLALTSHIFT = CTRL_KEY_TEXT .. '-ALT-' .. SHIFT_KEY_TEXT

--totems
L.ShowTotems = '显示图腾'
L.ShowTotemRecall = '显示回收'

--extra bar
L.ExtraBarShowBlizzardTexture = '显示默认周围材质'

--general settings panel
L.General = '通用'

--profile settings panel
L.CreateProfile = '创建方案...'
L.ResetProfile = '重置方案...'
L.CopyProfile = '复制方案...'
L.ConfirmResetProfile = '你确定要重置此方案为多米诺默认值(非爱不易默认值)?'
L.ConfirmCopyProfile = '复制方案 %s 的内容到当前方案?'
L.ConfirmDeleteProfile = '删除方案 %s?'

L.Paging = '切换翻页'
L.Buttons = '选择按钮'