--[[
OmniCC configuration interface localization - Chinese Traditional
--]]

if GetLocale() ~= 'zhTW' then return end

local L = OMNICC_LOCALS

L.GeneralSettings = "顯示"
L.FontSettings = "文字風格"
L.RuleSettings = "規則"
L.PositionSettings = "文字位置"

L.Font = "字型"
L.FontSize = "預設字型大小"
L.FontOutline = "字型輪廓"

L.Outline_NONE = NONE
L.Outline_OUTLINE = "細邊"
L.Outline_THICKOUTLINE = "粗邊"

L.MinDuration = "顯示文字的最少時間"
L.MinSize = "顯示文字的最小字型大小"
L.ScaleText = "使用自動縮放令文字保持在框架之內"
L.EnableText = "啟用冷卻文字"

L.Add = "新增"
L.Remove = "移除"

L.FinishEffect = "完成效果"
L.MinEffectDuration = "完成效果的最少時間"

L.MMSSDuration = "最少時間的文字以 MM:SS 格式來顯示"
L.TenthsDuration = "以十分之一秒為單位顯示"

L.ColorAndScale = "顏色 & 縮放"
L.Color_soon = "即將到期"
L.Color_seconds = "少於1分鐘"
L.Color_minutes = "少於1小時"
L.Color_hours = "1小時或以上"

L.UseAniUpdater = "優化效能"

-- 文字定位
L.XOffset = "X 偏移"
L.YOffset = "Y 偏移"

L.Anchor = '錨點'
L.Anchor_LEFT = '左'
L.Anchor_CENTER = '中'
L.Anchor_RIGHT = '右'
L.Anchor_TOPLEFT = '左上'
L.Anchor_TOP = '上'
L.Anchor_TOPRIGHT = '右上'
L.Anchor_BOTTOMLEFT = '左下'
L.Anchor_BOTTOM = '下'
L.Anchor_BOTTOMRIGHT = '右下'

--分組
L.Groups = '分組'
L.Group_base = '預設'
L.Group_action = '動作'
L.Group_aura = '光環'
L.Group_pet = '寵物動作'
L.AddGroup = '新增分組...'

--[[ 提示 ]]--

L.ScaleTextTip =
[[當啟用時，此設定會令文字縮小來適應太小的框架]]

L.UseAniUpdaterTip =
[[優化CPU效能，但是在某些環境可能造成崩潰。
禁用此選項可以解決事件。]]

L.UseAniUpdaterSmallTip = "|cffff2020改變需要遊戲重載。|r"

L.MinDurationTip =
[[確定多長的冷卻時間才顯示文字
此設定主要用於篩選出GCD]]

L.MinSizeTip =
[[確定多大的框架能顯示文字。
該值越小，可以展示的東西越小。
該值越大，可以展示的東西越大。

一些基準:
100 - 動作按鈕的大小
80  - 職業或寵物動作按鈕的大小
55  - 暴雪目標增益框架的大小]]

L.MinEffectDurationTip =
[[確定需要多長的冷卻時間來顯示一個完成的效果
（例如，脈衝/閃亮）]]

L.MMSSDurationTip =
[[確定用於顯示冷卻時間的閾值以 MM:SS 格式來顯示]]

L.TenthsDurationTip =
[[確定用於顯示冷卻時間的閾值以十分之一秒格式來顯示]]

L.FontSizeTip =
[[控制文字的大小]]

L.FontOutlineTip =
[[控制文字周圍的輪廓厚度]]

L.UseBlacklistTip =
[[點擊切換使用黑名單。
當啟用時，任何框架的名稱與黑名單上
的項目相同時將不會顯示冷卻時間。]]

L.FrameStackTip =
[[切換當滑鼠懸停在框架時顯示的名稱]]

L.XOffsetTip =
[[控制文字的水準偏移]]

L.YOffsetTip =
[[控制文字的垂直偏移]]