--[[
	localization.tw.lua
	zhTW (convert from zhCN)
		xuxianhe@gmail.com
        yaroot##gmail#com
		
	
	2020/5/7 New translations by 彩虹ui https://www.facebook.com/rainbowui/
	2019/10/5 New translations by Kal.L
	Triditional Chinese 繁體中文
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'zhTW')
if not L then return end

L.ActionBarBehavior = "快捷列行為"
L.ActionBarNumber = "快捷列 %d"
L.ActionButtonLookAndFeel = "快捷列按鈕外觀"
L.Advanced = "進階"
L.BagBarShowBags = "顯示更換背包欄位"
L.BagBarShowKeyRing = "顯示鑰匙圈"
L.Bar = "快捷列 %d"
L.BarSettings = "%s 設定"
L.Buttons = "按鈕"
L.ClickThrough = "啟用點擊穿透"
L.Columns = "直行數"
L.CommandKey = '指令'
L.ConfirmCopyProfile = "是否要將 %s 的內容複製到目前的設定檔?"
L.ConfirmDeleteProfile = "是否要刪除設定檔 %s?"
L.ConfirmResetProfile = "是否確定要重置設定檔?"
L.Copy = "複製"
L.CopyProfile = "複製設定檔..."
L.CreateProfile = "建立設定檔..."
L.Delay = "延遲 (秒)"
L.Delete = _G.DELETE
L.DisableMenuButtons = "停用按鈕"
L.Duration = "持續時間 (秒)"
L.EnterBindingMode = "設定快捷鍵..."
L.EnterConfigMode = "設定快捷列..."
L.EnterName = "輸入名稱"
L.ExtraBarShowBlizzardTexture = "顯示暴雪預設材質"
L.FadedOpacity = "淡出透明度"
L.FadeIn = "淡入"
L.FadeOut = "淡出"
L.Fading = "淡出"
L.FrameStrata = "框架層級"
L.FrameStrata_BACKGROUND = "背景"
L.FrameStrata_LOW = LOW
L.FrameStrata_MEDIUM = "中"
L.FrameStrata_HIGH = HIGH
L.FrameLevel = "框架層數"
L.General = "一般"
L.Layout = "外觀"
L.LeftToRight = "按鈕由左至右排列"
L.LinkedOpacity = "吸附的快捷列繼承相同的透明度"
L.LockActionButtons = "鎖定快捷列按鈕圖示"
L.MetaKey = 'Meta鍵'
L.Modifiers = "輔助鍵"
-- L.None = _G.NONE
L.OneBag = "只顯示一個背包圖示"
-- L.Opacity = _G.OPACITY
L.OutOfCombat = "非戰鬥中"
L.Padding = "內距"
L.Paging = "切換"
L.PossessBar = "載具/操控列使用"
L.PossessBarDesc = "在某些首領戰中和操控敵人時，要在哪個快捷列上要顯示特殊技能。"
L.Profiles = "設定檔"
L.ProfilesPanelDesc = "管理儲存的快捷列版面配置"
L.QuickMoveKey = "快速移動鍵"
L.QuickPaging = "快速切換"
L.RCUFocus = "專注目標"
L.RCUPlayer = "自己"
L.RCUToT = "目標的目標"
L.ResetProfile = "重置設定檔..."
L.RightClickUnit = "右鍵點擊的目標是"
-- L.Save = _G.SAVE
L.Scale = "縮放大小"
L.SelfcastKey = "自我施法鍵"
L.Set = "設定"
L.ShowBindingText = "顯示快捷鍵文字"
L.ShowCountText = "顯示物品數量文字"
L.ShowEmptyButtons = "顯示空按鈕"
L.ShowEquippedItemBorders = "已裝備的物品顯示邊框"
L.ShowInOverrideUI = "在載具上時要顯示"
L.ShowInPetBattleUI = "寵物戰鬥時要顯示"
L.ShowKeyring = "顯示鑰匙圈"
L.ShowMacroText = "顯示巨集文字"
L.ShowMinimapButton = "顯示小地圖按鈕"
L.ShowOverrideUI = "使用遊戲內建的載具介面"
L.ShowOverrideUIDesc = "駕駛車輛或其他相關情況時，顯示暴雪預設的載具介面。"
L.ShowStates = "顯示條件 - 可輸入巨集指令，例如:\n [combat][harm,nodead]show;hide"
L.ShowTooltips = "顯示滑鼠提示"
L.ShowTooltipsCombat = "戰鬥中顯示滑鼠提示"
L.Size = "大小"
L.Spacing = "間距"
L.State_HARM = "敵方"
L.State_HELP = "友方"
L.State_NOTARGET = "沒有目標"
L.State_SHIELD = "已裝備盾牌"
L.StickyBars = "磁吸式對齊"
L.Targeting = "目標為"
L.ThemeActionButtons = "套用達美樂的按鈕外觀主題 (需要重新載入)"
L.ThemeActionButtonsDesc = "啟用時，會對快捷列按鈕套用一些自訂的樣式調整。停用時則保持原樣。"
L.TopToBottom = "按鈕由上到下排列"
L.Visibility = "顯示/隱藏"

if IsMacClient() then
    L.State_META = 'CMD鍵'
else
    L.State_META = 'Meta鍵'
end

L.ParentAddonName = "達美樂快捷列 "
