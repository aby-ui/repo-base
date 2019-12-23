--[[
	localization.tw.lua	
	2016/7/18 New translations by 彩虹ui https://www.facebook.com/rainbowui/
	2019/10/5 New translations by Kal.L
	Triditional Chinese 繁體中文
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Progress', 'zhTW')
if not L then return end
L.OneBarMode = '只使用一條進度條顯示'
L.Progress = '進度'
L.Texture = '材質'
L.Width = '寬度'
L.Height = '高度'
L.AlwaysShowText = '保持顯示文字'
L.Segmented = '區段格子'
L.Font = '文字'
L.LockDisplayMode = ('%s %s %s'):format(_G.LOCK, _G.DISPLAY, _G.MODE)
L.ShowLabels = '顯示標籤文字'
L.CompressValues = '顯示簡短的數值'
L.AutoSwitchModes = '自動轉換模式'
L.Display_label = '顯示標籤'
L.Display_value = '顯示現時數值'
L.Display_max = '顯示最大數值'
L.Display_bonus = '顯示休憩/額外經驗值'
L.Display_percent = '顯示百分比'
L.Display_remaining = '顯示餘下經驗值'

L.Color_xp = '經驗條顏色'
L.Color_xp_bonus = '額外經驗條顏色'
L.Color_honor = '榮譽條顏色'
L.Color_honor_bonus = '額外榮譽條顏色'
L.Color_artifact = '神器條顏色'
L.Color_azerite = '艾澤萊條顏色'

L.Paragon = '巔峰'
L.Azerite = '艾澤萊晶岩之力'
L.SkipInactiveModes = "跳過沒有使用的條"
