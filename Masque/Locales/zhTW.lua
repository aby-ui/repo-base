--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For license information,
	please see the included License.txt file or visit https://github.com/StormFX/Masque.

	* File...: Locales\zhTW.lua

	zhTW Locale

	[ Notes ]

	To help with translations, use the localization system on WoWAce (https://www.wowace.com/projects/masque/localization)
	or contribute directly on GitHub (https://github.com/StormFX/Masque).

]]

-- GLOBALS: GetLocale

if GetLocale() ~= "zhTW" then return end

local _, Core = ...
local L = Core.Locale

----------------------------------------
-- About Masque
---

L["About Masque"] = "關於按鈕外觀 Masque"
L["API"] = "API"
L["For more information, please visit one of the sites listed below."] = "更多訊息說明，請拜訪下列其中之一的網站。"
L["Masque is a skinning engine for button-based add-ons."] = "Masque 是幫插件按鈕更換外觀的引擎。"
L["Select to view."] = "選擇以查看。"
L["You must have an add-on that supports Masque installed to use it."] = "必須安裝支援 Masque 按鈕外觀的插件才能使用。"

----------------------------------------
-- Classic Skin
---

L["An improved version of the game's default button style."] = "遊戲預設按鈕樣式的改進版本。"

----------------------------------------
-- Core Settings
---

L["About"] = "關於"
L["Click to load Masque's options."] = "點擊來載入Masque的選項。"
L["Load Options"] = "載入選項"
L["Masque's options are load on demand. Click the button below to load them."] = "Masque的選項是需求時才載入。點擊下面的按鈕來載入它。"
L["This section will allow you to view information about Masque and any skins you have installed."] = "此部分允許您查看有關Masque和已安裝的任何外觀的訊息。"

----------------------------------------
-- Developer Settings
---

L["Causes Masque to throw Lua errors whenever it encounters a problem with an add-on or skin."] = "每當遭遇插件或是外觀問題都會讓Masque丟出Lua錯誤。"
L["Clean Database"] = "清除數據庫"
L["Click to purge the settings of all unused add-ons and groups."] = "點擊來清理所有未使用插件與群組的設置。"
L["Debug Mode"] = "除錯模式"
L["Developer"] = "開發人員"
L["Developer Settings"] = "開發人員設置"
L["Masque debug mode disabled."] = "Masque 除錯模式已停用。"
L["Masque debug mode enabled."] = "Masque除錯模式已啟用。"
L["This action cannot be undone. Continue?"] = "此操作無法撤銷。要繼續嗎？"
L["This section will allow you to adjust settings that affect working with Masque's API."] = "本部分允許您調整會影響使用Masque的API。"

----------------------------------------
-- Dream Skin
---

L["A square skin with trimmed icons and a semi-transparent background."] = "方形的外觀，帶有修剪過的圖示以及半透明的背景。"

----------------------------------------
-- General Settings
---

L["General Settings"] = "一般設置"
L["This section will allow you to adjust Masque's interface and performance settings."] = "本部分允許您調整Masque的介面以及性能設置。"

----------------------------------------
-- Installed Skins
---

L["Author"] = "作者"
L["Authors"] = "作者"
L["Click for details."] = "點擊取得細節。"
L["Compatible"] = "相容"
L["Description"] = "說明"
L["Incompatible"] = "不相容"
L["Installed Skins"] = "已安裝的外觀"
L["No description available."] = "沒有說明。"
L["Status"] = "狀態"
L["The status of this skin is unknown."] = "此外觀的狀態為未知。"
L["This section provides information on any skins you have installed."] = "本部分提供所有你已安裝的任何外觀的訊息。"
L["This skin is compatible with Masque."] = "這款外觀與Masque相容。"
L["This skin is outdated and is incompatible with Masque."] = "這款外觀已經過期或是不相容於Masque。"
L["This skin is outdated but is still compatible with Masque."] = "這款外觀已經過期但仍相容於Masque。"
L["Unknown"] = "未知"
L["Version"] = "版本"
L["Website"] = "網站"
L["Websites"] = "網站"

----------------------------------------
-- Interface Settings
---

L["Enable the Minimap icon."] = "啟用小地圖按鈕。"
L["Interface"] = "介面"
L["Interface Settings"] = "介面設置"
L["Minimap Icon"] = "小地圖按鈕"
L["Stand-Alone GUI"] = "獨立的圖形介面"
L["This section will allow you to adjust settings that affect Masque's interface."] = "本部分允許您調整影響Masque介面的設置。"
L["Use a resizable, stand-alone options window."] = "使用可調整大小的獨立選項視窗。"

----------------------------------------
-- LDB Launcher
---

L["Click to open Masque's settings."] = "點一下開啟按鈕外觀的設定選項。"

----------------------------------------
-- Performance Settings
---

L["Click to load reload the interface."] = "點擊來載入或重載介面。"
L["Load the skin information panel."] = "載入外觀訊息面板"
L["Performance"] = "效能"
L["Performance Settings"] = "效能設置"
L["Reload Interface"] = "重載介面"
L["Requires an interface reload."] = "需要介面重新載入。"
L["Skin Information"] = "外觀訊息"
L["This section will allow you to adjust settings that affect Masque's performance."] = "本部分允許您調整影響Masque效能的設置。"

----------------------------------------
-- Profile Settings
---

L["Profile Settings"] = "設定檔設定"

----------------------------------------
-- Skin Settings
---

L["Backdrop"] = "背景設定"
L["Checked"] = "已勾選"
L["Color"] = "顏色"
L["Colors"] = "顏色"
L["Cooldown"] = "冷卻中"
L["Disable"] = "停用"
L["Disable the skinning of this group."] = "停用這個群組的按鈕外觀。"
L["Disabled"] = "已停用"
L["Enable"] = "啟用"
L["Enable the Backdrop texture."] = "啟用背景材質。"
L["Enable the Gloss texture."] = "啟用光澤材質。"
L["Enable the Shadow texture."] = "啟用陰影材質。"
L["Flash"] = "閃光"
L["Global"] = "全部"
L["Global Settings"] = "全局設置"
L["Gloss"] = "光澤設定"
L["Highlight"] = "顯著標示"
L["Normal"] = "一般"
L["Pushed"] = "按下"
L["Reset all skin options to the defaults."] = "重置所有外觀選項為預設值。"
L["Reset Skin"] = "重置外觀"
L["Set the color of the Backdrop texture."] = "設定背景材質顏色。"
L["Set the color of the Checked texture."] = "設定已勾選材質顏色。"
L["Set the color of the Cooldown animation."] = "設定冷卻倒數動畫顏色。"
L["Set the color of the Disabled texture."] = "設定已停用材質顏色。"
L["Set the color of the Flash texture."] = "設定閃光材質顏色。"
L["Set the color of the Gloss texture."] = "設定光澤材質顏色。"
L["Set the color of the Highlight texture."] = "設定高亮材質顏色。"
L["Set the color of the Normal texture."] = "設定一般材質顏色。"
L["Set the color of the Pushed texture."] = "設定按下材質顏色。"
L["Set the color of the Shadow texture."] = "設定陰影材質的顏色。"
L["Set the skin for this group."] = "設定套用在此群組的外觀。"
L["Shadow"] = "陰影"
L["Skin"] = "外觀"
L["Skin Settings"] = "外觀設置"
L["This section will allow you to adjust the skin settings of all buttons registered to %s."] = "本部分允許您調整所有註冊到%s的按鈕外觀設置。"
L["This section will allow you to adjust the skin settings of all buttons registered to %s. This will overwrite any per-group settings."] = "本部分允許您調整所有註冊到%s的按鈕外觀設置。這會覆蓋每個群組的設置。"
L["This section will allow you to adjust the skin settings of all registered buttons. This will overwrite any per-add-on settings."] = "此部分允許您調整所有已註冊的按鈕外觀設置。這會覆蓋每個插件的設置。"
L["This section will allow you to skin the buttons of the add-ons and add-on groups registered with Masque."] = "此部分允許您美化已在Masque註冊的插件和插件群組的按鈕外觀。"

----------------------------------------
-- Zoomed Skin
---

L["A square skin with zoomed icons and a semi-transparent background."] = "方形的外觀，帶有縮放過的圖示以及半透明的背景。"
