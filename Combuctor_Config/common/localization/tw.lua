--[[
  Chinese Traditional Localization
		***
--]]

local CONFIG, Config = ...
local L = LibStub('AceLocale-3.0'):NewLocale(CONFIG, 'zhTW')
if not L then return end

-- general
L.GeneralDesc = '根據你的喜好來切換一般功能設定。'
L.Locked = '鎖定框架'
L.Fading = '框架淡化'
L.TipCount = '物品統計提示'
L.FlashFind = '閃爍找到'
L.EmptySlots = '在空的槽位顯示背景顏色'
L.DisplayBlizzard = '隱藏的背包顯示為內建框架'

-- frame
L.FrameSettings = '框架設定'
L.FrameSettingsDesc = '設定ADDON框架。'
L.Frame = '框架'
L.Enabled = '啟用框架'
--L.CharacterSpecific = 'Character Specific Settings'
L.ExclusiveReagent = '分離材料銀行'

L.BagFrame = '背包列表'
L.Money = '金錢'
L.Broker = 'Databroker外掛'
L.Sort = '排序按鈕'
L.Search = '切換搜尋'
L.Options = '設定按鈕'

L.Appearance = '外觀'
L.Layer = '階層'
L.BagBreak = '根據背包顯示'
L.ReverseBags = '反轉背包順序'
L.ReverseSlots = '反轉槽位順序'

L.Color = '背景顏色'
L.BorderColor = '邊框顏色'

L.Strata = '框架層級'
L.Columns = '列'
L.Scale = '縮放'
L.ItemScale = '物品縮放'
L.Spacing = '間距'
L.Alpha = '透明度'

-- auto display
L.DisplaySettings = '自動顯示'
L.DisplaySettingsDesc = '讓你設定在遊戲事件中背包自動開啟或關閉。'
L.DisplayInventory = '顯示背包'
L.CloseInventory = '關閉背包'

L.DisplayBank = '訪問銀行'
L.DisplayAuction = '訪問拍賣行'
L.DisplayTrade = '交易物品'
L.DisplayCraft = '製造'
L.DisplayMail = '檢查信箱'
L.DisplayGuildbank = '訪問公會銀行'
L.DisplayPlayer = '開啟角色資訊'
L.DisplayGems = '鑲崁寶石'

L.CloseCombat = '進入戰鬥'
L.CloseVehicle = '進入載具'
L.CloseBank = '離開銀行'
L.CloseVendor = '離開商人'

-- colors
L.ColorSettings = '顏色設定'
L.ColorSettingsDesc = '讓你設定在ADDON框架裡較簡單辨識物品槽位。'
L.GlowQuality = '根據品質高亮物品' 
L.GlowNew = '高亮新物品'
L.GlowQuest = '高亮任務物品'
L.GlowUnusable = '高亮無法使用的物品'
L.GlowSets = '高亮裝備設定物品'
L.ColorSlots = '根據背包類型高亮空的槽'

L.NormalColor = '一般背包槽顏色'
L.LeatherColor = '製皮包槽顏色'
L.InscribeColor = '銘文包槽顏色'
L.HerbColor = '草藥包槽顏色'
L.EnchantColor = '附魔包槽顏色'
L.EngineerColor = '工程箱槽顏色'
L.GemColor = '寶石包顏色'
L.MineColor = '礦石包顏色'
L.TackleColor = '工具箱顏色'
L.RefrigeColor = '冰箱顏色'
L.ReagentColor = '材料銀行顏色'
L.GlowAlpha = '高亮亮度'