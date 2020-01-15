-- OmniCC configuration interface localization - Chinese Traditional
local L = LibStub("AceLocale-3.0"):NewLocale("OmniCC", "zhTW")
if not L then return end

L.Anchor = '錨點'
L.Anchor_BOTTOM = '下'
L.Anchor_BOTTOMLEFT = '左下'
L.Anchor_BOTTOMRIGHT = '右下'
L.Anchor_CENTER = '中'
L.Anchor_LEFT = '左'
L.Anchor_RIGHT = '右'
L.Anchor_TOP = '上'
L.Anchor_TOPLEFT = '左上'
L.Anchor_TOPRIGHT = '右上'
L.ColorAndScale = "顏色 & 縮放"
L.ColorAndScaleDesc = "調整顏色和縮放設置以適應不同的冷卻狀態"
L.CooldownText = "冷卻文字"
L.CreateTheme = "建立主題"
L.Display = DISPLAY
L.DisplayGroupDesc = "調整何時與那些訊息要顯示在冷卻時間"
L.Duration = "持續時間"
L.EnableCooldownSwipes = "描繪冷卻動態"
L.EnableCooldownSwipesDesc = "冷卻動態為深色背景用來指示冷卻的剩餘時間"
L.EnableText = "顯示冷卻文字"
L.EnableTextDesc = "顯示冷卻的剩餘時間文字"
L.FinishEffect = "完成效果"
L.FinishEffectDesc = "調整冷卻結束時觸發的效果"
L.FinishEffects = "完成效果"
L.FontFace = "字型風格"
L.FontOutline = "字型輪廓"
L.FontSize = "字型大小"
L.HorizontalOffset = "水平偏移"
L.MinDuration = "顯示文字的最少時間"
L.MinDurationDesc = "確定多長的冷卻時間才顯示文字，此設定主要用於篩選出GCD"
L.MinEffectDuration = "完成效果的最少時間"
L.MinEffectDurationDesc = "確定需要多長的冷卻時間來顯示一個完成的效果（例如，脈衝/閃亮）"
L.MinSize = "顯示文字的最小字型大小"
L.MinSizeDesc = [[確定多大的框架能顯示文字。
該值越小，可以展示的東西越小。
該值越大，可以展示的東西越大。

一些基準:
100 - 動作按鈕的大小
80  - 職業或寵物動作按鈕的大小
47  - 暴雪目標增益框架的大小]]
L.MMSSDuration = "最少時間的文字以 MM:SS 格式來顯示"
L.MMSSDurationDesc = "確定用於顯示冷卻時間的閾值以 MM:SS 格式來顯示"
L.Outline_NONE = NONE
L.Outline_OUTLINE = "細邊"
L.Outline_OUTLINEMONOCHROME = "無抗鋸齒"
L.Outline_THICKOUTLINE = "粗邊"
L.Preview = PREVIEW
L.RuleAdd = "新增規則"
L.RuleAddDesc = "建立一個新規則"
L.RuleEnable = ENABLE
L.RuleEnableDesc = "切換此規則。 如果禁用了規則，則OmniCC將跳過對其進行檢查。"
L.RulePatterns = "模式"
L.RulePatternsDesc = "此規則應該套用於的UI元素的名稱或名稱的一部分。 每個模式應在單獨的行中輸入。"
L.RulePriority = "優先級"
L.RulePriorityDesc = "規則按升序評估，第一個匹配項目將應用於冷卻。"
L.RuleRemove = REMOVE
L.RuleRemoveDesc = "移除此規則"
L.Rules = "規則"
L.RulesDesc = "規則可用於將主題應用於 UI 的特定元素。如果沒有規則匹配特定的 UI 元素，則它將使用預設主題。"
L.Rulesets = "規則設置"
L.RuleTheme = "主題"
L.RuleThemeDesc = "要應用於匹配此規則的 UI 元素的主題"
L.ScaleText = "使用自動縮放令文字保持在框架之內"
L.ScaleTextDesc = "當啟用時，此設定會令文字縮小來適應太小的框架"
L.State_charging = "恢復充能"
L.State_controlled = "失去控制"
L.State_days = "至少剩餘一天"
L.State_hours = "剩餘小時"
L.State_minutes = "不到一小時"
L.State_seconds = "不到一分鐘"
L.State_soon = "即將到期"
L.TenthsDuration = "以十分之一秒為單位顯示"
L.TenthsDurationDesc = "確定用於顯示冷卻時間的閾值以十分之一秒格式來顯示"
L.TextColor = "文字顏色"
L.TextFont = "文字字型"
L.TextPosition = "文字位置"
L.TextShadow = "文字陰影"
L.TextShadowColor = COLOR
L.TextSize = "文字大小"
L.Theme = "主題"
L.ThemeAdd = "新增主題"
L.ThemeAddDesc = "建立一個新主題"
L.ThemeRemove = REMOVE
L.ThemeRemoveDesc = "移除此主題"
L.Themes = "主題"
L.ThemesDesc = "主題是OmniCC外觀設置的集合。 主題可以與規則結合使用，以更改UI特定部分上的OmniCC"
L.Typography = "文字式樣"
L.TypographyDesc = "調整冷卻文字的外觀，例如使用哪種字體"
L.VerticalOffset = "垂直偏移"
