--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com
    Sep 9. 2012     yaroot##gmail#com
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos', 'zhCN')
if not L then return end

--system messages
L.NewPlayer = '建立新角色方案 %s'
L.Updated = '升级到 v%s'

--profiles
L.ProfileCreated = '建立新方案 "%s"'
L.ProfileLoaded = '方案设置为 "%s"'
L.ProfileDeleted = '删除方案 "%s"'
L.ProfileCopied = '已复制方案"%s"的设置到当前方案'
L.ProfileReset = '重置方案 "%s"'
L.CantDeleteCurrentProfile = '不能删除当前在用的方案'
L.InvalidProfile = '无效的方案或者已是当前方案 "%s"'

--slash command help
L.ShowOptionsDesc = '显示设置菜单'
L.ConfigDesc = '设置模式开关'

L.SetScaleDesc = '缩放 <frameList>'
L.SetAlphaDesc = '透明度 <frameList>'
L.SetFadeDesc = '遮罩透明度 <frameList>'

L.SetColsDesc = '列 <frameList>'
L.SetPadDesc = '填充 <frameList>'
L.SetSpacingDesc = '间隔 <frameList>'

L.ShowFramesDesc = '显示 <frameList>'
L.HideFramesDesc = '隐藏 <frameList>'
L.ToggleFramesDesc = '开关 <frameList>'

--slash commands for profiles
L.SetDesc = '方案切换为 <profile>'
L.SaveDesc = '保存当前方案为 <profile>'
L.CopyDesc = '从 <profile> 复制设置'
L.DeleteDesc = '删除 <profile>'
L.ResetDesc = '返回默认配置'
L.ListDesc = '列出所有方案'
L.AvailableProfiles = '可用方案'
L.PrintVersionDesc = '显示当前版本'

--dragFrame tooltips
L.ShowConfig = '<右键> 设置'
L.HideBar = '<中键或者Shift+右键> 隐藏'
L.ShowBar = '<中键或者Shift+右键> 显示'
L.SetAlpha = '<滚轮> 设置透明度 (|cffffffff%d|r)'

--minimap button stuff
L.ConfigEnterTip = '<左键> 进入设置模式'
L.ConfigExitTip = '<左键> 退出设置模式'
L.BindingEnterTip = '<Shift+左键> 进入绑定模式'
L.BindingExitTip = '<Shift+左键> 退出绑定模式'
L.ShowOptionsTip = '<右键> 显示设置菜单'

--helper dialog stuff
L.ConfigMode = '设置模式'
L.ConfigModeExit = '退出设置模式'
L.ConfigModeHelp = '<拖动> 移动技能条(按住Alt键可以不粘附)。\n<右键> 进入设置。\n<中键> 或 <Shift+右键> 设置是否显示。'

--bar tooltips
L.TipRollBar = '在团队中显示物品掷点面板'
L.TipVehicleBar = [[
显示瞄准和离开载具的控制按钮.
其他载具按钮将在心灵控制条上显示.]]

L.AbyDisplayNames = {artifact="神器",exp="经验声望",page="翻\n页",vehicle="离开\n载具",pet="宠物技能",menu="菜单",bags="背包",roll="掷骰框",alerts="提示框",extra="特殊\n动作",encounter="战斗能量",cast="施法条",cast_new="美化施法条",zone="区域\n技能",class="职业", talk="剧情对话" }

L.BarDisplayName = "%s 条"
L.ActionBarDisplayName = "动作条 %s"
L.ActionButtonDisplayName = "Action Button %d"
L.AlertsBarDisplayName = "提示框"
L.AvailableProfiles = 'Available Profiles'
L.BagBarDisplayName = "背包"
L.ClassBarDisplayName = "职业"
L.ExtraBarDisplayName = "特殊\n动作"
L.MenuBarDisplayName = "菜单"
L.PossessBarDisplayName = '支配'
L.PetBarDisplayName = "宠物技能"
L.RollBarDisplayName = "掷骰框"
L.VehicleDisplayName = "离开\n载具"
L.PageBarDisplayName = "翻\n页"
L.CastingBarDisplayName = "施法条"
L.KeyboardMovementTip = "按方向键(WASD)来微调位置."

L.ShowAlignmentGrid = "布局网格"
L.GridDensity = "密度"
L.Hidden = "已隐藏"
L.Shown = "显示"