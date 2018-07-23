------------------------------------------------------------
-- zhTW.lua
--
-- 繁體中文本地化文件
--
-- Abin
-- 2015-08-26
------------------------------------------------------------

if GetLocale() ~= "zhTW" then return end

local _, addon = ...

addon.L = {
	["title"] = "WhisperPop",
	["no new messages"] = "沒有未閱讀消息",
	["desc"] = "顯示角色發送與接收到的密語聊天消息，並且將聊天記錄跨角色保存。",
	["new messages from"] = "未閱讀消息來自: ",
	["receive only"] = "僅顯示接收到的消息",
	["toggle frame"] = "打開/關閉WhisperPop框體",
	["general options"] = "一般選項",
	["sound notify"] = "啟用聲音提示 ",
	["timestamp"] = "顯示時間戳",
	["save messages"] = "保存聊天記錄",
	["show realms"] = "顯示伺服器名稱後綴",
	["foreign realms"] = "僅不同服時顯示",
	["clear all"] = "清空聊天",
	["clear all confirm"] = "即將永久刪除所有未保護的消息記錄，你確定嗎？",
	["settings tooltip 1"] = "|cff00ff00點擊：|r打開設置窗口",
	["settings tooltip 2"] = "|cff00ff00Shift-點擊：|r清空所有已保存的記錄",
	["show notify button"] = "顯示屏幕提示按鈕",
	["delete player records"] = "刪除所有來自|cff00ff00%s|r的記錄",
	["filter settings"] = "過濾設置",
	["ignore tag messages"] = "不保存標籤類消息（以 |cff00ff00<|r 或 |cff00ff00[|r 開頭的）",
	["apply third-party filters"] = "繼承第三方插件過濾器",
	["frame settings"] = "窗體設置",
	["button scale"] = "按鈕縮放",
	["list scale"] = "列表縮放",
	["list width"] = "列表寬度",
	["list height"] = "列表高度",
	["reset frames"] = "重置窗體",
	["reset frames confirm"] = "將WhisperPop窗體的尺寸與位置恢復到初始值，你確定嗎？",
	["protected"] = "已保護",
	["cannot delete protected"] = "與|cffff0000%s|r的聊天記錄已被保護，請先解除保護後再刪除。",
}
