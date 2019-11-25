local AddonName = ...
local L = LibStub("AceLocale-3.0"):NewLocale(AddonName, "zhTW")
if not L then return end

-- timer formats
L.DayFormat = "%d天"
L.HourFormat = "%d小時"
L.MinuteFormat = "%d分"
L.MMSSFormat = "%d:%02d"
L.SecondsFormat = "%d"
L.TenthsFormat = "%0.1f"

-- effect names
L.Activate = "啟動"
L.Alert = "警告"
L.Flare = "閃光"
L.None = NONE
L.Pulse = "跳動"
L.Shine = "亮光"

-- effect tooltips
L.ActivateTip = [[模擬快捷列按鈕上的技能"建議使用"時顯示的預設特效。]]
L.AlertTip = [[在畫面中央跳動冷卻倒數完成的圖示。]]
L.PulseTip = [[跳動冷卻倒數完成的圖示。]]

-- other
L.ConfigMissing = '無法載入 %s 因為插件 %s'
L.Version = '正在使用冷卻時間 |cffFCF75EOmniCC 版本 (%s)|r'
