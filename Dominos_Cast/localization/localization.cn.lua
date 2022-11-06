--[[
	Localization_zhCN.lua
	2008/12/4 Modified by xuxianhe@gmail.com

	Simple Chinese : 简体中文
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-CastBar', 'zhCN')
if not L then return end

L.CastBarDisplayName = HUD_EDIT_MODE_CAST_BAR_LABEL or '施法条'
L.Display = DISPLAY
L.Display_border = '显示边框'
L.Display_icon = '显示图标'
L.Display_label = "显示标签"
L.Display_latency = "显示延迟"
L.Display_spark = "显示火花效果"
L.Display_time = '显示时间'
L.Font = '字体'
L.Height = '高'
L.LatencyPadding = '延迟填充 (ms)'
L.MirrorTimerDisplayName = '时间 %d'
L.Padding = '填充'
L.Texture = '材质'
L.UseSpellReactionColors = "法术类型着色"
L.UseSpellReactionColorsTip = "用颜色来区分有益法术和伤害法术"
L.Width = '宽'
L.CastBarDisplayName = '多米诺施法条'
L.MirrorTimerDisplayName = '镜像计时条 %d'
