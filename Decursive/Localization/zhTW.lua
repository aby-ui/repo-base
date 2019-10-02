--[[
    This file is part of Decursive.

    Decursive (v 2.7.6.4) add-on for World of Warcraft UI
    Copyright (C) 2006-2019 John Wellesz (Decursive AT 2072productions.com) ( http://www.2072productions.com/to/decursive.php )

    Starting from 2009-10-31 and until said otherwise by its author, Decursive
    is no longer free software, all rights are reserved to its author (John
    Wellesz).

    The only official and allowed distribution means are
    www.2072productions.com, www.wowace.com and curse.com.
    To distribute Decursive through other means a special authorization is
    required.


    Decursive is inspired from the original "Decursive v1.9.4" by Patrick Bohnet (Quu).
    The original "Decursive 1.9.4" is in public domain ( www.quutar.com )

    Decursive is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY.

    This file was last updated on 2019-09-09T00:15:26Z
--]]
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Traditional Chinese localization
-------------------------------------------------------------------------------

--[=[
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating Decursive.
--    Do not edit those files. Use the localization interface available at the following address:
--
--      ################################################################
--      #  http://wow.curseforge.com/projects/decursive/localization/  #
--      ################################################################
--
--    Your translations made using this interface will be automatically included in the next release.
--
--]=]

local addonName, T = ...;
-- big ugly scary fatal error message display function {{{
if not T._FatalError then
-- the beautiful error popup : {{{ -
StaticPopupDialogs["DECURSIVE_ERROR_FRAME"] = {
    text = "|cFFFF0000Decursive Error:|r\n%s",
    button1 = "OK",
    OnAccept = function()
        return false;
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    showAlert = 1,
    preferredIndex = 3,
    }; -- }}}
T._FatalError = function (TheError) StaticPopup_Show ("DECURSIVE_ERROR_FRAME", TheError); end
end
-- }}}
if not T._LoadedFiles or not T._LoadedFiles["enUS.lua"] then
    if not DecursiveInstallCorrupted then T._FatalError("Decursive installation is corrupted! (enUS.lua not loaded)"); end;
    DecursiveInstallCorrupted = true;
    return;
end
T._LoadedFiles["zhTW.lua"] = false;

local L = LibStub("AceLocale-3.0"):NewLocale("Decursive", "zhTW");

if not L then
    T._LoadedFiles["zhTW.lua"] = "2.7.6.4";
    return;
end;

L["ABOLISH_CHECK"] = "施法前檢查是否需要淨化"
L["ABOUT_AUTHOREMAIL"] = "作者 E-Mail"
L["ABOUT_CREDITS"] = "貢獻者"
L["ABOUT_LICENSE"] = "許可"
L["ABOUT_NOTES"] = "當單獨、小隊和團隊時清除有害狀態，並可使用高級過濾和優先等級系統。"
L["ABOUT_OFFICIALWEBSITE"] = "官方網站"
L["ABOUT_SHAREDLIBS"] = "共享庫"
L["ABSENT"] = "不存在 (%s)"
L["AFFLICTEDBY"] = "受 %s 影響"
L["ALT"] = "ALt"
L["AMOUNT_AFFLIC"] = "即時清單顯示人數: "
L["ANCHOR"] = "Decursive 文字定位點"
L["BINDING_NAME_DCRMUFSHOWHIDE"] = "顯示或隱藏 MUF"
L["BINDING_NAME_DCRPRADD"] = "添加目標至優先名單"
L["BINDING_NAME_DCRPRCLEAR"] = "清空優先名單"
L["BINDING_NAME_DCRPRLIST"] = "顯示優先名單至聊天視窗"
L["BINDING_NAME_DCRPRSHOW"] = "開/關優先名單"
L["BINDING_NAME_DCRSHOW"] = "顯示或隱藏 Decursive 工作條"
L["BINDING_NAME_DCRSHOWOPTION"] = "顯示靜態設定選單"
L["BINDING_NAME_DCRSKADD"] = "添加目標至忽略名單"
L["BINDING_NAME_DCRSKCLEAR"] = "清空忽略名單"
L["BINDING_NAME_DCRSKLIST"] = "顯示忽略名單至聊天視窗"
L["BINDING_NAME_DCRSKSHOW"] = "開/關忽略名單"
L["BLACK_LENGTH"] = "停留在排除名單的時間: "
L["BLACKLISTED"] = "在排除名單"
L["CHARM"] = "魅惑"
L["CLASS_HUNTER"] = "獵人"
L["CLEAR_PRIO"] = "C"
L["CLEAR_SKIP"] = "C"
L["COLORALERT"] = "設定按鍵警示'%s'的顏色"
L["COLORCHRONOS"] = "秒錶"
L["COLORCHRONOS_DESC"] = "設定秒錶顏色"
L["COLORSTATUS"] = "設定當玩家狀態是 '%s' 時的 MUF 顏色."
L["CTRL"] = "Ctrl"
L["CURE_PETS"] = "檢測並淨化寵物"
L["CURSE"] = "詛咒"
L["DEBUG_REPORT_HEADER"] = [=[|cFF11FF33請報告此視窗的內容給 <%s>|r
|cFF009999（使用 CTRL+A 選擇所有 CTRL+C 復制文本到剪切板）|r
如果發現 %s 任何奇怪的行為也一并報告。
]=]
L["DECURSIVE_DEBUG_REPORT"] = "**** |cFFFF0000Decursive 除錯報告|r ****"
L["DECURSIVE_DEBUG_REPORT_BUT_NEW_VERSION"] = [=[|cFF11FF33Decursive 啟動失敗但請勿擔心! 一個新版本的Decursive已經被偵測到 (%s)。你只需要執行更新。前往curse.com並搜索"Decursive" 或使用Curse Client，此服務會自動更新所有您最愛的UI。|r
|cFFFF1133 所以請不要浪費你的時間回報此錯誤，因為它也許已被修正。安裝新更新並排除問題! |r
|cFF11FF33 感謝你閱讀此訊息! |r
]=]
L["DECURSIVE_DEBUG_REPORT_NOTIFY"] = [=[一個出錯報告可用！
輸入 |cFFFF0000/DCRREPORT|r 查看]=]
L["DECURSIVE_DEBUG_REPORT_SHOW"] = "除錯報告可用！"
L["DECURSIVE_DEBUG_REPORT_SHOW_DESC"] = "顯示作者需要看到的除錯報告…"
L["DEFAULT_MACROKEY"] = "`"
L["DEV_VERSION_ALERT"] = [=[您正在使用的是開發版本的 Decursive 。

如果不想參加測試新功能與修復，得到遊戲中的除錯報告后發送問題給作者，請“不要使用此版本”並從 curse.com 和 wowace.com 下載最新的“穩定”版本。

這條消息只將在版本更新中顯示一次]=]
L["DEV_VERSION_EXPIRED"] = [=[此開發版 Decursive 已過期。
請從 CURSE.COM 和 WOWACE.COM 下載最新的開發版或使用當前穩定版。謝謝！ ^_^
此提示每兩天顯示一次。]=]
L["DEWDROPISGONE"] = "沒有等同于 Ace3 的 DewDrop。Alt+點擊右鍵打開選項面板。"
L["DISABLEWARNING"] = [=[Decursive 已停用！

如欲啟用, 輸入 |cFFFFAA44/DCR ENABLE|r]=]
L["DISEASE"] = "疾病"
L["DONOT_BL_PRIO"] = "不添加優先名單的玩家到排除名單"
L["DONT_SHOOT_THE_MESSENGER"] = "Decursive僅提供事件報告。問題並非Decursive產生，請尋找真正錯誤來源。"
L["FAILEDCAST"] = [=[|cFF22FFFF%s %s|r |cFFAA0000對|r %s釋放失敗
|cFF00AAAA%s|r]=]
L["FOCUSUNIT"] = "監控單位"
L["FUBARMENU"] = "Fubar 選單"
L["FUBARMENU_DESC"] = "Fubar 圖示相關設定"
L["GLOR1"] = "紀念 Glorfindal"
L["GLOR2"] = [=[Decursive 獻給匆匆離我們而去的 Bertrand
他將永遠被我們所銘記。]=]
L["GLOR3"] = [=[紀念 Bertrand 
1969 - 2007]=]
L["GLOR4"] = [=[對於那些在魔獸世界裡遇見過 Glorfindal 的人來說，他是一個重承諾的男人，也是一個有超凡魅力的領袖。

友誼和慈愛將永植於他們的心中。他在遊戲中就如同在他生活中一樣的無私，彬彬有禮，樂於奉獻，最重要的是他對生活充滿熱情。

他離開我們的時候才僅僅38歲，隨他離去的絕不會是虛擬世界匿名的角色；在這裡還有一群忠實的朋友在永遠想念他。]=]
L["GLOR5"] = "他將永遠被我們所銘記。"
L["HANDLEHELP"] = "拖曳移動所有的 Micro-UnitFrames (MUFs)"
L["HIDE_MAIN"] = "隱藏 Decursive 視窗"
L["HIDESHOW_BUTTONS"] = "顯示/隱藏按鈕和鎖定/解鎖“Decursive”條"
L["HLP_LEFTCLICK"] = "左-鍵"
L["HLP_LL_ONCLICK_TEXT"] = [=[實時列表不代表能被點擊。請先閱讀此文檔來學習如何使用此插件。在 WoWAce.com 網站搜索“Decursive”
（從 Decursive 計時條移除此列表，/dcrshow 命令並左Alt+點擊移除）]=]
L["HLP_MIDDLECLICK"] = "中-鍵"
L["HLP_NOTHINGTOCURE"] = "沒有可處理的負面效果！"
L["HLP_RIGHTCLICK"] = "右-鍵"
L["HLP_USEXBUTTONTOCURE"] = "用 \"%s\" 來淨化這個負面效果！"
L["HLP_WRONGMBUTTON"] = "錯誤的滑鼠按鍵！"
L["IGNORE_STEALTH"] = "忽略潛行的玩家"
L["IS_HERE_MSG"] = "Decursive 已經啟動，請核對設定選項。"
L["LIST_ENTRY_ACTIONS"] = [=[|cFF33AA33[CTRL]|r-左鍵: 移除該玩家
 |cFF33AA33左|r-鍵: 提升該玩家順序
 |cFF33AA33右|r-鍵: 降低該玩家順序
 |cFF33AA33[SHIFT] 左|r-鍵: 將該玩家置頂
 |cFF33AA33[SHIFT] 右|r-鍵: 將該玩家置底]=]
L["MACROKEYALREADYMAPPED"] = [=[警告: Decursive 巨集對應按鍵 [%s] 先前對應到 '%s' 動作。
當你設定別的巨集按鍵後 Decursive 會回復此按鍵原有的對應動作。]=]
L["MACROKEYMAPPINGFAILED"] = "按鍵 [%s] 不能被對應到 Decursive 巨集！"
L["MACROKEYMAPPINGSUCCESS"] = "按鍵 [%s] 已成功對應到 Decursive 巨集。"
L["MACROKEYNOTMAPPED"] = "Decursive 巨集未對應到一個按鍵，你可以透過設定選單來設定此一按鍵。(別錯過這個神奇的功能)"
L["MAGIC"] = "魔法"
L["MAGICCHARMED"] = "魔法誘惑"
L["MISSINGUNIT"] = "找不到的單位"
L["NEW_VERSION_ALERT"] = [=[已檢測到新版本的 Decursive：|cFFEE7722%q|r 發佈於 |cFFEE7722%s|r！


請前往|cFFFF0000WoWAce.com|r下載！
--------]=]
L["NORMAL"] = "一般"
L["NOSPELL"] = "沒有可用法術"
L["OPT_ABOLISHCHECK_DESC"] = "檢查玩家身上是否有淨化法術在運作。"
L["OPT_ABOUT"] = "關於"
L["OPT_ADD_A_CUSTOM_SPELL"] = "添加一個自訂法術"
L["OPT_ADD_A_CUSTOM_SPELL_DESC"] = "點擊這裡並 Shift+點擊技能書上的一個法術。也可以直接寫法術名稱或數字 ID。"
L["OPT_ADDDEBUFF"] = "添加一負面效果到清單中"
L["OPT_ADDDEBUFF_DESC"] = "將一個新的負面效果新增到清單中。"
L["OPT_ADDDEBUFF_USAGE"] = "<Debuff name>"
L["OPT_ADDDEBUFFFHIST"] = "新增一個最近受到的負面效果"
L["OPT_ADDDEBUFFFHIST_DESC"] = "從歷史紀錄中新增一個負面效果"
L["OPT_ADVDISP"] = "進階顯示選項"
L["OPT_ADVDISP_DESC"] = "可設定邊框與中央色塊各自的透明度，以及 MUFs 之間的距離。"
L["OPT_AFFLICTEDBYSKIPPED"] = "%s 受到 %s 的影響，但將被忽略。"
L["OPT_ALLOWMACROEDIT"] = "允許巨集版本"
L["OPT_ALLOWMACROEDIT_DESC"] = "啟用此項以防止 Decursive 更新巨集，可自行編輯所需的巨集。"
L["OPT_ALWAYSIGNORE"] = "即使不在戰鬥中也忽略之"
L["OPT_ALWAYSIGNORE_DESC"] = "如果選取該選項，即使脫離戰鬥也忽略該負面效果而不解除"
L["OPT_AMOUNT_AFFLIC_DESC"] = "設定即時清單最多顯示幾人。"
L["OPT_ANCHOR_DESC"] = "顯示自訂視窗的文字定位點。"
L["OPT_AUTOHIDEMFS"] = "隱藏 MUFs："
L["OPT_AUTOHIDEMFS_DESC"] = "選擇何時自動隱藏 MUF 視窗"
L["OPT_BLACKLENTGH_DESC"] = "設定一個人停留在排除名單中的時間。"
L["OPT_BORDERTRANSP"] = "邊框透明度"
L["OPT_BORDERTRANSP_DESC"] = "設定邊框的透明度。"
L["OPT_CENTERTEXT"] = "中央計數器:"
L["OPT_CENTERTEXT_DESC"] = [=[顯示每個MUF的中心最上面的（根據你的優先次序）受影響信息。

其中之一：
- 剩餘時間直至結束
- 從過去時間的影響量(Time elapsed since the affliction hit)
- 距離數]=]
L["OPT_CENTERTEXT_DISABLED"] = "關閉"
L["OPT_CENTERTEXT_ELAPSED"] = "經過時間"
L["OPT_CENTERTEXT_STACKS"] = "距離數"
L["OPT_CENTERTEXT_TIMELEFT"] = "剩餘時間"
L["OPT_CENTERTRANSP"] = "中央透明度"
L["OPT_CENTERTRANSP_DESC"] = "設定中間色塊的透明度"
L["OPT_CHARMEDCHECK_DESC"] = "選取後你可以看見並處理被媚惑的玩家。"
L["OPT_CHATFRAME_DESC"] = "顯示到預設的聊天視窗。"
L["OPT_CHECKOTHERPLAYERS"] = "檢查其他玩家"
L["OPT_CHECKOTHERPLAYERS_DESC"] = "顯示當前小隊或團隊玩家 Decursive 版本（不能顯示 Decursive 2.4.6之前的版本）。"
L["OPT_CMD_DISBLED"] = "已禁用"
L["OPT_CMD_ENABLED"] = "啟用"
L["OPT_CREATE_VIRTUAL_DEBUFF"] = "建立虛擬負面效果測試"
L["OPT_CREATE_VIRTUAL_DEBUFF_DESC"] = "讓你看到當負面效果發生時Decursive的樣子。"
L["OPT_CURE_PRIORITY_NUM"] = "優先級 #%d"
L["OPT_CUREPETS_DESC"] = "寵物會被顯示出來也可淨化。"
L["OPT_CURINGOPTIONS"] = "淨化選項"
L["OPT_CURINGOPTIONS_DESC"] = "淨化的選項包含更改每種負面效果與順序的選項。"
L["OPT_CURINGOPTIONS_EXPLANATION"] = [=[選擇你想要治療的傷害類型，未經檢查的類型將被 Decursive 完全忽略。

綠色數字確定優先的傷害。這一優先事項將影響幾方面：

- 如果一個玩家獲得許多類型的減益效果，Decursive 將優先顯示。

- 滑鼠按鈕點擊將治療減益（第一法術是左鍵點擊，第二法術是右鍵點擊，等等…）

所有這一切的說明文檔（請見）：
http://www.wowace.com/addons/decursive/]=]
L["OPT_CURINGORDEROPTIONS"] = "淨化順序設定"
L["OPT_CURSECHECK_DESC"] = "選取後你可以看見並解除被詛咒的玩家。"
L["OPT_CUSTOM_SPELL_ALLOW_EDITING"] = "允許巨集編輯（僅限進階使用者）"
L["OPT_CUSTOM_SPELL_ALLOW_EDITING_DESC"] = [=[如果要編輯內部巨集請勾選此項，Decursive 將使用您的自訂法術。

注意：勾選此項將允許你編輯由 Decursive 所管理的法術。

If a spell is already listed you'll need to remove it first to enable macro editing.

（--- 僅限進階使用者 ---）]=]
L["OPT_CUSTOM_SPELL_CURE_TYPES"] = "傷害類型"
L["OPT_CUSTOM_SPELL_IS_DEFAULT"] = "此法術是 Decursive 自動配置的一部份，如果此法術無法正常運作，移除或禁用此項以回復預設的 Decursive 設定。"
L["OPT_CUSTOM_SPELL_ISPET"] = "寵物能力"
L["OPT_CUSTOM_SPELL_ISPET_DESC"] = "檢查此技能是否屬於你的寵物，使Decursive能正確偵測並且使用該技能。"
L["OPT_CUSTOM_SPELL_MACRO_MISSING_NOMINAL_SPELL"] = "警告：法術 %q 未出現在巨集中，範圍及冷卻資訊將無法符合。"
L["OPT_CUSTOM_SPELL_MACRO_MISSING_UNITID_KEYWORD"] = "缺少結合關鍵字。"
L["OPT_CUSTOM_SPELL_MACRO_TEXT"] = "巨集文字："
L["OPT_CUSTOM_SPELL_MACRO_TEXT_DESC"] = [=[編輯預設的巨集文字。
|cFFFF0000有兩項限制：|r

- 必須指定目標使用 UNITID 關鍵字，將自動被每個 MUF 的單位 ID 取代。

- 無論法術在巨集中如何使用， Decursive 將保持顯示左方的原始名稱，以利範圍及冷卻的顯示 / 追蹤。
（如果你計畫要使用不同的法術名稱的話，請注意這一點）]=]
L["OPT_CUSTOM_SPELL_MACRO_TOO_LONG"] = "你的巨集過長，需移除 %d 個字元。"
L["OPT_CUSTOM_SPELL_PRIORITY"] = "法術優先級"
L["OPT_CUSTOM_SPELL_PRIORITY_DESC"] = [=[當有多個法術可以治療相同類型的傷害，將選擇優先級高的。

注意Decursive預設管理的能力，優先程度設定範圍為0到9。

因此如果你將自行設定之施法能力的優先程度設為負值，此能力只有在預設施法能力無法使用時才會被選用。]=]
L["OPT_CUSTOM_SPELL_UNAVAILABLE"] = "不可用"
L["OPT_CUSTOMSPELLS"] = "自訂法術"
L["OPT_CUSTOMSPELLS_DESC"] = [=[這裡添加法術以擴展Decursive的自動配置。
您的自訂法術總是會有高優先權，並且將蓋過與替代預設的法術(只有在你的角色可以使用這些法術的時候)。
]=]
L["OPT_CUSTOMSPELLS_EFFECTIVE_ASSIGNMENTS"] = "有效法術分配"
L["OPT_DEBCHECKEDBYDEF"] = [=[

Checked by default]=]
L["OPT_DEBUFFENTRY_DESC"] = "選擇戰鬥中要忽略受到此負面效果影響的職業。"
L["OPT_DEBUFFFILTER"] = "負面效果過濾設定"
L["OPT_DEBUFFFILTER_DESC"] = "設定戰鬥中要忽略的職業與負面效果"
L["OPT_DELETE_A_CUSTOM_SPELL"] = "移除"
L["OPT_DISABLEABOLISH"] = "不使用\"驅散\"法術"
L["OPT_DISABLEABOLISH_DESC"] = "如啟用，Decursive 將為“無效”減益選擇使用“淨化疾病”和“淨化中毒”。"
L["OPT_DISABLEMACROCREATION"] = "禁止創建巨集"
L["OPT_DISABLEMACROCREATION_DESC"] = "Decursive 巨集將不再創建和保留"
L["OPT_DISEASECHECK_DESC"] = "選取後你可以看見並治療生病的玩家。"
L["OPT_DISPLAYOPTIONS"] = "顯示設定"
L["OPT_DONOTBLPRIO_DESC"] = "設定到優先清單的玩家不會被移入排除清單中。"
L["OPT_ENABLE_A_CUSTOM_SPELL"] = "啟用"
L["OPT_ENABLE_LIVELIST"] = "啟用直播列表"
L["OPT_ENABLE_LIVELIST_DESC"] = [=[顯示信息列表受影響玩家。

您可以將這個名單通過移動decursive的欄位 (或者輸入 /DCRSHOW 顯示該欄位).]=]
L["OPT_ENABLEDEBUG"] = "啟用除錯"
L["OPT_ENABLEDEBUG_DESC"] = "啟用除錯輸出"
L["OPT_ENABLEDECURSIVE"] = "啟用 Decursive"
L["OPT_FILTEROUTCLASSES_FOR_X"] = "在戰鬥中指定的職業%q將被忽略。"
L["OPT_GENERAL"] = "一般選項"
L["OPT_GROWDIRECTION"] = "反向顯示 MUFs"
L["OPT_GROWDIRECTION_DESC"] = "MUFs 會從尾巴開始顯示。"
L["OPT_HIDEMFS_GROUP"] = "單獨或小隊"
L["OPT_HIDEMFS_GROUP_DESC"] = "當不在團隊中的時隱藏 MUF 視窗。"
L["OPT_HIDEMFS_NEVER"] = "從不自動隱藏"
L["OPT_HIDEMFS_NEVER_DESC"] = "從不自動隱藏 MUF 視窗。"
L["OPT_HIDEMFS_SOLO"] = "單獨"
L["OPT_HIDEMFS_SOLO_DESC"] = "當不在團隊中或隊伍中的時隱藏 MUF 視窗。"
L["OPT_HIDEMUFSHANDLE"] = "隱藏 MUF 表頭"
L["OPT_HIDEMUFSHANDLE_DESC"] = [=[隱藏微單元面板（MUF）表頭並禁止移動。
Use the same command to get it back.]=]
L["OPT_IGNORESTEALTHED_DESC"] = "忽略潛行的玩家。"
L["OPT_INPUT_SPELL_BAD_INPUT_ALREADY_HERE"] = "法術已在列表中！"
L["OPT_INPUT_SPELL_BAD_INPUT_DEFAULT_SPELL"] = "Decursive 已經包含此法術。Shift+點擊此法術或輸入它的 ID 添加一個特殊等級。"
L["OPT_INPUT_SPELL_BAD_INPUT_ID"] = "法術 ID 不可用！"
L["OPT_INPUT_SPELL_BAD_INPUT_NOT_SPELL"] = "不能在技能書中找到法術！"
L["OPT_LIVELIST"] = "即時清單"
L["OPT_LIVELIST_DESC"] = [=[These are the settings concerning the list of afflicted units displayed beneath the "Decursive" bar.

To move this list you need to move the little "Decursive" frame. Some of the settings below are available only when this frame is displayed. You can display it by typing |cff20CC20/DCRSHOW|r in your chat window.

Once you have set the position, scale and transparency of the live-list you can safely hide Decursive's frame by typing |cff20CC20/DCRHIDE|r.]=]
L["OPT_LLALPHA"] = "實況清單的透明度"
L["OPT_LLALPHA_DESC"] = "變更 Decursive 工作條及實況清單的透明度(工作條必須設定為顯示)"
L["OPT_LLSCALE"] = "縮放即時列表"
L["OPT_LLSCALE_DESC"] = "設定 Decursive 狀態條以及其即時列表的大小（狀態條必須顯示）"
L["OPT_LVONLYINRANGE"] = "只顯示法術有效範圍內的目標"
L["OPT_LVONLYINRANGE_DESC"] = "即時清單只顯示淨化法術有效範圍內的目標。"
L["OPT_MACROBIND"] = "設定巨集按鍵"
L["OPT_MACROBIND_DESC"] = [=[定義呼叫 Decursive 巨集的按鍵。

按你想設定的按鍵然後按 'Enter' 鍵儲存設定(滑鼠要移動到編輯區域)]=]
L["OPT_MACROOPTIONS"] = "巨集設定選項"
L["OPT_MACROOPTIONS_DESC"] = "設定 Decursive 產生的巨集如何動作"
L["OPT_MAGICCHARMEDCHECK_DESC"] = "選取後你可以看見並處理被魔法媚惑的玩家。"
L["OPT_MAGICCHECK_DESC"] = "選取後你可以看見並處理受魔法影響的玩家。"
L["OPT_MAXMFS"] = "最多顯示幾個"
L["OPT_MAXMFS_DESC"] = "設定在螢幕上最多顯示幾個 micro unit frames。"
L["OPT_MESSAGES"] = "訊息設定"
L["OPT_MESSAGES_DESC"] = "設定訊息顯示。"
L["OPT_MFALPHA"] = "透明度"
L["OPT_MFALPHA_DESC"] = "設定無 debuff 時 MUFs 的透明度。"
L["OPT_MFPERFOPT"] = "效能設定選項"
L["OPT_MFREFRESHRATE"] = "刷新頻率"
L["OPT_MFREFRESHRATE_DESC"] = "設定多久刷新一次(一次可刷新一個或數個 micro-unit-frames)。"
L["OPT_MFREFRESHSPEED"] = "刷新速度"
L["OPT_MFREFRESHSPEED_DESC"] = "設定每次刷新多少個 micro-unit-frames。"
L["OPT_MFSCALE"] = "micro-unit-frames 大小"
L["OPT_MFSCALE_DESC"] = "設定螢幕上 micro-unit-frames 的大小。"
L["OPT_MFSETTINGS"] = "微單位框格(MUF)設定選項"
L["OPT_MFSETTINGS_DESC"] = "設定 MUF 框格以顯示不同的負面類型與順序。"
L["OPT_MUFFOCUSBUTTON"] = "監控按鈕："
L["OPT_MUFHANDLE_HINT"] = "移動 MUFs：在第一個 MUF 之上 Alt+點擊的不可見表頭。"
L["OPT_MUFMOUSEBUTTONS"] = "滑鼠綁定"
L["OPT_MUFMOUSEBUTTONS_DESC"] = [=[設定每個 MUF 滑鼠按鈕的警報顏色。

Each priority number represents a different affliction type as specified in the '|cFFFF5533Curing Options|r' panel.

The spell used for each affliction type is set by default but can be changed in the '|cFF00DDDDCustom Spells|r' panel.]=]
L["OPT_MUFSCOLORS"] = "顏色"
L["OPT_MUFSCOLORS_DESC"] = [=[設定MUF不同負面類型的顏色與順序的選項。"

Each priority represents a different affliction type as specified in the '|cFFFF5533Curing Options|r' panel.]=]
L["OPT_MUFSVERTICALDISPLAY"] = "垂直顯示"
L["OPT_MUFSVERTICALDISPLAY_DESC"] = "MUFs 視窗將垂直增長"
L["OPT_MUFTARGETBUTTON"] = "目標按鈕："
L["OPT_NEWVERSIONBUGMENOT"] = "新版本通知"
L["OPT_NEWVERSIONBUGMENOT_DESC"] = "如果有較新版本的 Decursive 被檢測到，每七天將顯示一個彈出警報。"
L["OPT_NOKEYWARN"] = "當沒有設定按鍵時警告"
L["OPT_NOKEYWARN_DESC"] = "當巨集按鍵沒有設定時顯示警告"
L["OPT_NOSTARTMESSAGES"] = "禁用歡迎訊息"
L["OPT_NOSTARTMESSAGES_DESC"] = "移除每次登入時在聊天框架顯示的兩個 Decursive 訊息。"
L["OPT_OPTIONS_DISABLED_WHILE_IN_COMBAT"] = "此選項戰鬥中被禁用。"
L["OPT_PERFOPTIONWARNING"] = "警告：不要更改這些值，除非你確切知道你在做什麼。這些設置可以對遊戲性能影響很大。大多數用戶應當使用0.1和10的默認值。"
L["OPT_PLAYSOUND_DESC"] = "有玩家中了負面效果時發出音效。"
L["OPT_POISONCHECK_DESC"] = "選取後你可以看見並清除中毒的玩家。"
L["OPT_PRINT_CUSTOM_DESC"] = "顯示到自訂的聊天視窗。"
L["OPT_PRINT_ERRORS_DESC"] = "顯示錯誤訊息。"
L["OPT_PROFILERESET"] = "重置設定檔..."
L["OPT_RANDOMORDER_DESC"] = "隨機顯示與淨化玩家(不推薦使用)。"
L["OPT_READDDEFAULTSD"] = "回復預設負面效果"
L["OPT_READDDEFAULTSD_DESC1"] = [=[添加被移除的預設負面效果
你的設定不會被改變。]=]
L["OPT_READDDEFAULTSD_DESC2"] = "所有的預設負面效果都在此清單中。"
L["OPT_REMOVESKDEBCONF"] = [=[你確定要把
 '%s' 
 從負面效果忽略清單中移除？]=]
L["OPT_REMOVETHISDEBUFF"] = "移除此負面效果"
L["OPT_REMOVETHISDEBUFF_DESC"] = "將 '%s' 從忽略清單移除。"
L["OPT_RESETDEBUFF"] = "重置此負面效果"
L["OPT_RESETDTDCRDEFAULT"] = "重置 '%s' 為 Decursive 預設值。"
L["OPT_RESETMUFMOUSEBUTTONS"] = "重置"
L["OPT_RESETMUFMOUSEBUTTONS_DESC"] = "重置滑鼠按鈕指派為默認。"
L["OPT_RESETOPTIONS"] = "重置為原始設定"
L["OPT_RESETOPTIONS_DESC"] = "回復目前的設定檔為原始設定"
L["OPT_RESTPROFILECONF"] = [=[你確定要重置
 '(%s) %s'
 為原始設定?]=]
L["OPT_REVERSE_LIVELIST_DESC"] = "由下到上填滿即時清單。"
L["OPT_SCANLENGTH_DESC"] = "設定掃描時間間隔。"
L["OPT_SHOW_STEALTH_STATUS"] = "顯示潛行狀態"
L["OPT_SHOW_STEALTH_STATUS_DESC"] = "當玩家前行時，他的 MUF 將有一個特殊的顏色"
L["OPT_SHOWBORDER"] = "顯示職業顏色邊框"
L["OPT_SHOWBORDER_DESC"] = "MUFs 邊框會顯示出該玩家的職業代表顏色。"
L["OPT_SHOWHELP"] = "顯示小提示"
L["OPT_SHOWHELP_DESC"] = "當滑鼠移到一個 micro-unit-frame 上時顯示小提示。"
L["OPT_SHOWMFS"] = "在螢幕上顯示 micro units Frame (MUF)"
L["OPT_SHOWMFS_DESC"] = "如果你要在螢幕上按按鍵清除就必須點選這個設定。"
L["OPT_SHOWMINIMAPICON"] = "迷你地圖圖標"
L["OPT_SHOWMINIMAPICON_DESC"] = "啟用迷你地圖小圖示。"
L["OPT_SHOWTOOLTIP_DESC"] = "在即時清單跟 MUFs 上顯示負面效果的小提示。"
L["OPT_STICKTORIGHT"] = "將 MUF 視窗向右對齊"
L["OPT_STICKTORIGHT_DESC"] = "設定這個選項將會使 MUF 視窗由右邊向左邊成長"
L["OPT_TESTLAYOUT"] = "測試布局"
L["OPT_TESTLAYOUT_DESC"] = [=[新建測試單位以測試顯示布局。
（點擊後稍等片刻）]=]
L["OPT_TESTLAYOUTUNUM"] = "單位數字"
L["OPT_TESTLAYOUTUNUM_DESC"] = "設定新建測試單位數字。"
L["OPT_TIE_LIVELIST_DESC"] = "即時清單顯示與否取決於 \"Decursive\" 工作條是否顯示。"
L["OPT_TIECENTERANDBORDER"] = "固定 MUF 中央與邊框的透明度"
L["OPT_TIECENTERANDBORDER_OPT"] = "選取時邊界的透明度固定為中央的一半。"
L["OPT_TIEXYSPACING"] = "固定水平與垂直距離。"
L["OPT_TIEXYSPACING_DESC"] = "固定 MUFs 之間的水平與垂直距離(空白)。"
L["OPT_UNITPERLINES"] = "每一行單位數"
L["OPT_UNITPERLINES_DESC"] = "設定每行最多顯示幾個 MUF。"
L["OPT_USERDEBUFF"] = "這項負面效果不是 Decursive 預設的效果之一"
L["OPT_XSPACING"] = "水平距離"
L["OPT_XSPACING_DESC"] = "設定 MUFs 之間的水平距離。"
L["OPT_YSPACING"] = "垂直距離"
L["OPT_YSPACING_DESC"] = "設定 MUFs 之間的垂直距離。"
L["OPTION_MENU"] = "Decursive 選項"
L["PLAY_SOUND"] = "有玩家需要淨化時發出音效"
L["POISON"] = "中毒"
L["POPULATE"] = "p"
L["POPULATE_LIST"] = "Decursive 名單快速添加介面"
L["PRINT_CHATFRAME"] = "在聊天視窗顯示訊息"
L["PRINT_CUSTOM"] = "在遊戲畫面中顯示訊息"
L["PRINT_ERRORS"] = "顯示錯誤訊息"
L["PRIORITY_LIST"] = "Decursive 優先名單"
L["PRIORITY_SHOW"] = "P"
L["RANDOM_ORDER"] = "隨機淨化玩家"
L["REVERSE_LIVELIST"] = "反向顯示即時清單"
L["SCAN_LENGTH"] = "即時檢測時間間隔(秒): "
L["SHIFT"] = "Shift"
L["SHOW_MSG"] = "要顯示 Decursive 視窗，請輸入 /dcrshow。"
L["SHOW_TOOLTIP"] = "在即時清單顯示簡要說明"
L["SKIP_LIST_STR"] = "Decursive 忽略名單"
L["SKIP_SHOW"] = "S"
L["SPELL_FOUND"] = "找到 %s 法術"
L["STEALTHED"] = "已潛行"
L["STR_CLOSE"] = "關閉"
L["STR_DCR_PRIO"] = "Decursive 優先選單"
L["STR_DCR_SKIP"] = "Decursive 忽略選單"
L["STR_GROUP"] = "隊伍 "
L["STR_OPTIONS"] = "Decursive 設定選項"
L["STR_OTHER"] = "其他"
L["STR_POP"] = "快速添加清單"
L["STR_QUICK_POP"] = "快速添加介面"
L["SUCCESSCAST"] = "|cFF22FFFF%s %s|r |cFF00AA00成功淨化|r %s"
L["TARGETUNIT"] = "選取目標"
L["TIE_LIVELIST"] = "即時清單顯示與 DCR 視窗連結"
L["TOC_VERSION_EXPIRED"] = [=[你的Decursive版本已經過期。當前魔獸世界版本比你的Decursive版本新。
你需要更新Decursive以修正潛在的錯誤。

前往curse.com搜索Decursive，或使用Curse's client軟體更新您所有的使用者外掛。

此訊息將每兩天提示一次。]=]
L["TOO_MANY_ERRORS_ALERT"] = [=[你的UI有太多LUA錯誤 (%d)。你的遊戲體驗正受到影響。關閉或更新產生錯誤的UI以關閉此訊息並重新取得正常的禎數。
你可開啟LUA錯誤報告來辨別產生錯誤的UI (/console scriptErrors 1)。]=]
L["TOOFAR"] = "太遠"
L["UNITSTATUS"] = "玩家狀態: "
L["UNSTABLERELEASE"] = "不穩定釋出版"



T._LoadedFiles["zhTW.lua"] = "2.7.6.4";
