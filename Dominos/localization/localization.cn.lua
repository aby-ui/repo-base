--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com
    Sep 9. 2012     yaroot##gmail#com
--]]

local AddonName = ...
local L = LibStub('AceLocale-3.0'):NewLocale(AddonName, 'zhCN')
if not L then return end

L.ActionBarDisplayName = "动作条 %d"
L.ActionButtonDisplayName = "动作按钮 %d"
L.AlertsBarDisplayName = "警报"
L.AvailableProfiles = '可用配置'
L.BagBarDisplayName = "背包"
L.BarDisplayName = "%s 条"
L.BindingEnterTip = '<Shift+左键> 进入绑定模式'
L.BindingExitTip = '<Shift+左键> 退出绑定模式'
L.CantDeleteCurrentProfile = '不能删除当前正在使用的配置'
L.ClassBarDisplayName = HUD_EDIT_MODE_STANCE_BAR_LABEL or "职业技能"
L.ConfigDesc = '设置模式开关'
L.ConfigEnterTip = '<左键> 进入设置模式'
L.ConfigExitTip = '<左键> 退出设置模式'
L.ConfigMode = '设置模式'
L.ConfigModeExit = '退出设置模式'
L.ConfigModeHelp = '<拖动> 移动技能条(按住Alt键可以不粘附)。\n<右键> 进入设置。\n<中键> 或 <Shift+右键> 设置是否显示。'
L.CopyDesc = '从 <profile> 复制设置'
L.DeleteDesc = '删除 <profile>'
L.EncounterBarDisplayName = HUD_EDIT_MODE_ENCOUNTER_BAR_LABEL or "战斗条"
L.ExtraBarDescription = "显示区域或遭遇战的特殊技能"
L.ExtraBarDisplayName = HUD_EDIT_MODE_EXTRA_ABILITIES_LABEL or "额外技能"
L.GridDensity = "密度"
L.Hidden = "隐藏"
L.HideBar = '<中键或者Shift+右键> 隐藏'
L.HideFramesDesc = '隐藏 <frameList>'
L.InvalidProfile = '无效的配置 "%s"'
L.KeyboardMovementTip = "使用方向键调整位置。"
L.ListDesc = '列出所有配置'
L.MenuBarDisplayName = "菜单"
L.MouseMovementTip = '用左键拖动移动。'
L.NewPlayer = '建立新角色配置 %s'
L.PetBarDisplayName = HUD_EDIT_MODE_PET_ACTION_BAR_LABEL or "宠物动作条"
L.PossessBarDisplayName = HUD_EDIT_MODE_POSSESS_ACTION_BAR_LABEL or '载具'
L.PrintVersionDesc = '显示当前版本'
L.ProfileCopied = '已复制配置"%s"的设置到当前配置'
L.ProfileCreated = '建立新配置 "%s"'
L.ProfileDeleted = '删除配置 "%s"'
L.ProfileLoaded = '配置设置为 "%s"'
L.ProfileReset = '重置配置 "%s"'
L.QueueStatusBarDisplayName = "任务状态条"
L.ResetDesc = '返回默认设置'
L.RollBarDisplayName = "Rolls"
L.SaveDesc = '保存当前配置为 <profile>'
L.SetAlpha = '<滚轮> 设置透明度 (|cffffffff%d|r)'
L.SetAlphaDesc = '透明度 <frameList>'
L.SetColsDesc = '列 <frameList>'
L.SetDesc = '配置切换为 <profile>'
L.SetFadeDesc = '遮罩透明度 <frameList>'
L.SetPadDesc = '填充 <frameList>'
L.SetScaleDesc = '缩放 <frameList>'
L.SetSpacingDesc = '间隔 <frameList>'
L.ShowAlignmentGrid = "显示网格"
L.ShowBar = '<中键或者Shift+右键> 显示'
L.ShowConfig = '<右键> 设置'
L.ShowFramesDesc = '显示 <frameList>'
L.Shown = "显示"
L.ShowOptionsDesc = '显示设置菜单'
L.ShowOptionsTip = '<右键> 显示设置菜单'
L.TalkingHeadBarDisplayName = HUD_EDIT_MODE_TALKING_HEAD_FRAME_LABEL or "对话特写头像"
L.TipRollBar = '在团队中显示物品掷点面板'
L.TipVehicleBar = [[显示瞄准和离开载具的控制按钮.\n其他载具按钮将在心灵控制条上显示.]]
L.ToggleFramesDesc = '开关 <frameList>'
L.TotemBarDisplayName = "图腾条"
L.Updated = '升级到 v%s'
L.VehicleBarDisplayName = HUD_EDIT_MODE_VEHICLE_LEAVE_BUTTON_LABEL or BINDING_NAME_VEHICLEEXIT
L.WrongBuildWarning = "You're running a %s version for %s on a %s server. Things may not work"


--L.ActionBarDisplayName = "动作条 %s"
L.AlertsBarDisplayName = "提示框"
--L.BagBarDisplayName = "背包"
--L.BarDisplayName = "%s 条"
--L.ClassBarDisplayName = "姿态条"
--L.ExtraBarDisplayName = "特殊\n动作"
--L.MenuBarDisplayName = "菜单"
--L.PossessBarDisplayName = '附身条'
--L.PetBarDisplayName = "宠物条"
L.RollBarDisplayName = "掷骰框"
L.VehicleDisplayName = "退出\n载具"
L.PageBarDisplayName = "翻\n页"
L.CastingBarDisplayName = "暴雪施法条"
L.QueueStatusBarDisplayName = "排队\n状态"
L.ProgressBarDisplayName = "进度条"
L.VehicleBarDisplayName = "离开\n载具"

L.Hidden = "已隐藏"
