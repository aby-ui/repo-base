--[[
	localization.tw.lua
	zhTW (convert from zhCN)
		xuxianhe@gmail.com
        yaroot##gmail#com
		
	
	2016/7/18 New translations by 彩虹ui https://www.facebook.com/rainbowui/
	2019/10/5 New translations by Kal.L
	Triditional Chinese 繁體中文
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos-Config', 'zhTW')
if not L then return end

L.Scale = '縮放'
L.Opacity = '透明度'
L.FadedOpacity = '淡出透明度'
L.Visibility = '顯示/隱藏'
L.Spacing = '間距'
L.Padding = '內距'
L.Layout = '外觀'
L.Columns = '行數'
L.Size = '大小'
L.Modifiers = '按鍵切換快捷列'
L.Paging = '切換'
L.QuickPaging = '快速切換快捷列'
L.Targeting = '目標為'
L.ShowStates = '顯示狀態'
L.Set = '設定'
L.Save = '儲存'
L.Copy = '複製'
L.Delete = '刪除'
L.Bar = '快捷列 %d'
L.Buttons = '按鈕'
L.RightClickUnit = '右鍵目標'
L.RCUPlayer = '自己'
L.RCUFocus = '專注目標'
L.RCUToT = '目標的目標'
L.EnterName = '輸入名稱'
L.PossessBar = '載具使用'
L.Profiles = '設定檔'
L.ProfilesPanelDesc = '管理儲存的快捷列版面配置'
L.SelfcastKey = '自我施法鍵'
L.QuickMoveKey = '快速移動鍵'
L.ShowMacroText = '顯示巨集文字'
L.ShowBindingText = '顯示快捷鍵文字'
L.ShowEmptyButtons = '顯示空按鈕'
L.LockActionButtons = '鎖定快捷列 (按住 Shift 可拖曳按鈕圖示)'
L.EnterBindingMode = '設定快捷鍵...'
L.EnterConfigMode = '設定快捷列...'
L.ActionBarSettings = '快捷列 %d 設定'
L.BarSettings = '%s 設定'
L.ShowTooltips = '顯示滑鼠提示'
L.ShowTooltipsCombat = '戰鬥中顯示滑鼠提示'
L.OneBag = '只顯示一個背包圖示'
L.ShowKeyring = '顯示鑰匙圈'
L.StickyBars = '自動對齊快捷列'
L.ShowMinimapButton = '顯示小地圖按鈕'
L.Advanced = '進階'
L.LeftToRight = '按鈕由左至右排列'
L.TopToBottom = '按鈕由上到下排列'
L.LinkedOpacity = '附著的快捷列繼承相同的透明度'
L.ClickThrough = '啟用穿透點擊'
L.DisableMenuButtons = '停用按鈕'
L.ShowOverrideUI = '使用遊戲預設的載具介面'
L.ShowInOverrideUI = '顯示載具介面'
L.ShowInPetBattleUI = '顯示寵物戰鬥介面'
L.ShowEquippedItemBorders = '顯示已裝備物品的邊界'
L.ThemeActionButtons = '套用主題到快捷鍵按鈕 (需要重載)'

L.ALT_KEY_TEXT = 'ALT'

L.State_HELP = '友方目標'
L.State_HARM = '敵對目標'
L.State_NOTARGET = '沒有目標'
L.State_ALTSHIFT = 'ALT-' .. SHIFT_KEY_TEXT
L.State_CTRLSHIFT = CTRL_KEY_TEXT .. '-' .. SHIFT_KEY_TEXT
L.State_CTRLALT = CTRL_KEY_TEXT .. '-ALT'
L.State_CTRLALTSHIFT = CTRL_KEY_TEXT .. '-ALT-' .. SHIFT_KEY_TEXT

--totems
L.ShowTotems = '顯示圖騰'
L.ShowTotemRecall = '顯示回收圖騰'

--extra bar
L.ExtraBarShowBlizzardTexture = '顯示暴雪材質'

--general settings panel
L.General = '一般選項'

--profile settings panel
L.CreateProfile = '建立設定檔...'
L.ResetProfile = '重置設定檔...'
L.CopyProfile = '複製設定檔...'
L.ConfirmResetProfile = '是否確定要重置設定檔?'
L.ConfirmCopyProfile = '是否要將 %s 的內容複製到目前的設定檔?'
L.ConfirmDeleteProfile = '是否確定要刪除設定檔 %s?'
