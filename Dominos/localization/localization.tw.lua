--[[
	localization.tw.lua
    zhTW (convert from zhCN)
    xuxianhe@gmail.com
    yaroot##gmail#com
	
	
	2016/7/18 New translations by 彩虹ui https://www.facebook.com/rainbowui/
	
	Triditional Chinese 繁體中文
]]

local L = LibStub('AceLocale-3.0'):NewLocale('Dominos', 'zhTW')
if not L then return end

--system messages
L.NewPlayer = '建立新的設定檔給 %s'
L.Updated = '已升級為 v%s'

--profiles
L.ProfileCreated = '建立新的設定檔 "%s"'
L.ProfileLoaded = '已載入設定檔 "%s"'
L.ProfileDeleted = '已刪除設定檔 "%s"'
L.ProfileCopied = '已從 "%s" 複製設定'
L.ProfileReset = '重置設定檔 "%s"'
L.CantDeleteCurrentProfile = '無法刪除目前的設定檔'
L.InvalidProfile = '無效的設定檔 "%s"'

--slash command help
L.ShowOptionsDesc = '顯示設定選項'
L.ConfigDesc = '切換版面配置模式'

L.SetScaleDesc = '設定縮放 <frameList>'
L.SetAlphaDesc = '設定透明度 <frameList>'
L.SetFadeDesc = '設定淡出透明度 <frameList>'

L.SetColsDesc = '設定行數 <frameList>'
L.SetPadDesc = '設定內距 <frameList>'
L.SetSpacingDesc = '設定間距 <frameList>'

L.ShowFramesDesc = '顯示 <frameList>'
L.HideFramesDesc = '隱藏 <frameList>'
L.ToggleFramesDesc = '切換 <frameList>'

--slash commands for profiles
L.SetDesc = '切換設定為 <profile>'
L.SaveDesc = '儲存目前的設定並切換為 <profile>'
L.CopyDesc = '複製設定從 <profile>'
L.DeleteDesc = '刪除 <profile>'
L.ResetDesc = '恢復為預設值'
L.ListDesc = '列出所有設定檔'
L.AvailableProfiles = '可用的設定檔'
L.PrintVersionDesc = '顯示插件版本'

--dragFrame tooltips
L.ShowConfig = '<右鍵> 開啟設定'
L.HideBar = '<中鍵 或 Shift-右鍵> 隱藏'
L.ShowBar = '<中鍵 或 Shift-右鍵> 顯示'
L.SetAlpha = '<滑鼠滾輪> 設定透明度 (|cffffffff%d|r)'

--minimap button stuff
L.ConfigEnterTip = '<左鍵> 進入版面配置模式'
L.ConfigExitTip = '<左鍵> 退出版面配置模式'
L.BindingEnterTip = '<Shift-左鍵> 進入按鍵設定模式'
L.BindingExitTip = '<Shift-左鍵> 退出按鍵設定模式'
L.ShowOptionsTip = '<右鍵> 顯示設定選項'

--helper dialog stuff
L.ConfigMode = '版面配置模式'
L.ConfigModeExit = '退出版面配置模式'
L.ConfigModeHelp = '<拖曳> 任何條列移動位置  <右鍵> 進行設定。  <中鍵> 或 <Shift-右鍵> 切換顯示/隱藏'

--bar tooltips
L.TipRollBar = '在隊伍中時顯示擲骰物品的面板。'
L.TipVehicleBar = [[
顯示瞄準和離開載具的控制按鈕。
其他載具動作會顯示在載具列上。]]

L.BarDisplayName = "%s列"
L.ActionBarDisplayName = "快捷列 %s"