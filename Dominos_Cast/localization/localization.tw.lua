--[[
	localization.tw.lua
	2016/7/18 New translations by 彩虹ui https://www.facebook.com/rainbowui/
	2019/10/5 New translations by Kal.L
	Triditional Chinese 繁體中文
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-CastBar', 'zhTW')
if not L then return end
L.Texture = '材質'
L.Width = '寬度'
L.Height = '高度'
L.Display_time = "顯示時間"
L.Display_icon = '顯示圖示'
L.Display_border = '顯示邊框'
L.Padding = '內距'
L.Font = '字體'
L.LatencyPadding = '延遲間隔 (毫秒)'

-- 自行加入
L.CastBarDisplayName = HUD_EDIT_MODE_CAST_BAR_LABEL or '施法條'
L.Display_label = "顯示文字"
L.Display_latency = "顯示延遲"
L.Display_spark = "顯示亮點"
L.MirrorTimerDisplayName = '環境計時條 %d'
L.UseSpellReactionColors = "依類別著色"
L.UseSpellReactionColorsTip = "助益法術和有害法術顯示為不同的顏色"