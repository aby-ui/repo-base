local AddonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "zhCN")
if not L then return end

-- effect names
L.None = NONE
L.Pulse = "搏动"
L.Shine = "闪亮"
L.Alert = "警报"
L.Activate = "激活"
L.Flare = "耀斑"

--effect tooltips
L.ActivateTip = [[模仿系统自带的，技能被“触发”的效果
（如CTM时代术士燃放灵魂碎片之后灵魂之火按钮的效果）。]]
L.AlertTip = [[结束冷却的图标在屏幕中央搏动。]]
L.PulseTip = [[结束冷却的图标将发生搏动。]]

-- other
L.ConfigMissing = '%s无法被载入，因为该插件%s'
L.Version = '你正在使用|cffFCF75EOmniCC 版本(%s)|r'