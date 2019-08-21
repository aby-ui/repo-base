--[[ Credit for these translations goes to:
	lsjyzjl
	szp1222
--]]
local L = LibStub("AceLocale-3.0"):NewLocale("TellMeWhen", "zhTW", false)
if not L then return end


L["!!Main Addon Description"] = "為冷卻、增益/減益及其他各個方面提供視覺、聽覺以及文字上的通知。"
L["ABSORBAMT"] = "護盾吸收量"
L["ABSORBAMT_DESC"] = "檢查單位上的護盾的吸收總量。"
L["ACTIVE"] = "%d 作用中"
L["ADDONSETTINGS_DESC"] = "配置所有通用插件的設置。"
L["AIR"] = "風之圖騰"
L["ALLOWCOMM"] = "允許圖示匯入"
L["ALLOWCOMM_DESC"] = "允許另一個TellMeWhen使用者給你發送數據。"
L["ALLOWVERSIONWARN"] = "新版本通知"
L["ALPHA"] = "可見度"
L["ANCHOR_CURSOR_DUMMY"] = "TellMeWhen虛擬遊標錨點"
L["ANCHOR_CURSOR_DUMMY_DESC"] = [=[這是一個虛擬的遊標，作用是幫你定位圖示。

在使用「遊標對象」單位時，利用該遊標定位群組非常有用。

你只需|cff7fffff右鍵點擊並拖拽|r一個圖示到遊標上即可將該圖示組依附到遊標。

由於暴雪的bug，冷卻時鐘動畫在移動後可能不能正常使用，依附遊標的圖示最好禁用它。

|cff7fffff左鍵點擊並拖拽：|r移動遊標。]=]
L["ANCHORTO"] = "依附框架"
L["ANIM_ACTVTNGLOW"] = "圖示：啟用邊框"
L["ANIM_ACTVTNGLOW_DESC"] = "在圖示上顯示暴雪的法術激活邊框。"
L["ANIM_ALPHASTANDALONE"] = "可見度"
L["ANIM_ALPHASTANDALONE_DESC"] = "設定動畫可視度的最大值。"
L["ANIM_ANCHOR_NOT_FOUND"] = "動畫無法依附到框架「%q」。 當前圖示是否沒有使用到這個框架？"
L["ANIM_ANIMSETTINGS"] = "設定"
L["ANIM_ANIMTOUSE"] = "使用的動畫"
L["ANIM_COLOR"] = "顏色/可視度"
L["ANIM_COLOR_DESC"] = "設定閃光的顏色和可視度。"
L["ANIM_DURATION"] = "動畫持續時間"
L["ANIM_DURATION_DESC"] = "設定動畫觸發後持續顯示多久。"
L["ANIM_FADE"] = "淡入淡出閃光"
L["ANIM_FADE_DESC"] = [=[勾選此項使每個閃光之間平滑的淡入淡出。不勾選則直接閃光。

（譯者註：具體的差別請自行進行區分，我測試的效果除了第一次閃光之外，後面的閃光區別並不明顯。）]=]
L["ANIM_ICONALPHAFLASH"] = "圖示：可見度閃爍"
L["ANIM_ICONALPHAFLASH_DESC"] = "通過改變圖示的可視度達到閃爍提示的效果。"
L["ANIM_ICONBORDER"] = "圖示：邊框"
L["ANIM_ICONBORDER_DESC"] = "在圖示上生成一個有顏色的邊框。"
L["ANIM_ICONCLEAR"] = "圖示：停止動畫"
L["ANIM_ICONCLEAR_DESC"] = "停止當前圖示正在播放的所有動畫效果。"
L["ANIM_ICONFADE"] = "圖示：淡入/淡出"
L["ANIM_ICONFADE_DESC"] = "在選定的事件發生時圖示可見度將會漸變。"
L["ANIM_ICONFLASH"] = "圖示：顏色閃爍"
L["ANIM_ICONFLASH_DESC"] = "利用顏色重疊在整個圖示上閃爍，達到提示的效果。"
L["ANIM_ICONOVERLAYIMG"] = "圖示：圖像重疊"
L["ANIM_ICONOVERLAYIMG_DESC"] = "在圖示上重疊顯示自訂圖像。"
L["ANIM_ICONSHAKE"] = "圖示：震動"
L["ANIM_ICONSHAKE_DESC"] = "在事件觸發時震動圖示。"
L["ANIM_INFINITE"] = "無限重複播放"
L["ANIM_INFINITE_DESC"] = [=[勾選此項將會重複播放動畫直到同個圖示上另一相同類型的動畫開始播放，或是在「%q」觸發之後才會停止。

說明：比如在事件「開始」中設定了「圖示：顏色閃爍」，並且勾選了「無限重複播放」，在事件「結束」設定了「圖示：顏色閃爍」（持續時間3秒），事件「開始」中的「無限重複播放」就會在事件「結束」的動畫播放結束後停止。 假如在同個圖示中沒有設定相同類型的動畫那就只能在「圖示：停止動畫」觸發之後才會停止播放。如果還是不明白，就這樣理解，同個圖示中相同類型的動畫只會存在一個，後面觸發的會覆寫掉前面觸發的。]=]
L["ANIM_MAGNITUDE"] = "震動幅度"
L["ANIM_MAGNITUDE_DESC"] = "設定震動的幅度需要多猛烈。"
L["ANIM_PERIOD"] = "閃光週期"
L["ANIM_PERIOD_DESC"] = [=[設定每次閃爍應當持續多久 - 閃爍的顯示時間或消退時間。

如果設定為0則不閃爍或淡出。]=]
L["ANIM_PIXELS"] = "%s 像素"
L["ANIM_SCREENFLASH"] = "螢幕：閃爍"
L["ANIM_SCREENFLASH_DESC"] = "利用顏色重疊在整個遊戲螢幕上閃爍，達到提示的效果。"
L["ANIM_SCREENSHAKE"] = "螢幕：震動"
L["ANIM_SCREENSHAKE_DESC"] = [=[在事件觸發時震動整個遊戲螢幕。

注意：螢幕震動只能在離開戰鬥後使用，或者在你登入之後沒有啟用名條的情況下使用。

（第一點囉嗦的解釋：如果你在登入之後按下顯示名條的快捷鍵或者名條原本就已經啟用了，就無法在戰鬥中使用螢幕震動如果你需要在戰鬥中使用請繼續往下看。

第二點囉嗦的解釋：如果一定要在戰鬥中使用螢幕震動請先關閉在「ESC->介面->名稱」中有關顯示單位名條的選項，然後重登，登入之後切記不可以按到任何顯示名條的快捷鍵。）]=]
L["ANIM_SECONDS"] = "%s秒"
L["ANIM_SIZE_ANIM"] = "邊框大小"
L["ANIM_SIZE_ANIM_DESC"] = "設定邊框的尺寸大小為多少。"
L["ANIM_SIZEX"] = "圖像寬度"
L["ANIM_SIZEX_DESC"] = "設定圖像的寬度為多少。"
L["ANIM_SIZEY"] = "圖像高度"
L["ANIM_SIZEY_DESC"] = "設定圖像的高度為多少。"
L["ANIM_TAB"] = "動畫"
L["ANIM_TAB_DESC"] = "設定需要​​播放的動畫效果。它們當中有些作用於圖示，有些則是作用於整個熒幕。"
L["ANIM_TEX"] = "材質"
L["ANIM_TEX_DESC"] = [=[選擇你要用於覆蓋圖示的材質。

你可以輸入一個材質路徑，例如'Interface/Icons/spell_nature_healingtouch'， 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'。

你也能使用放在WoW資料夾中的自訂材質（請在該欄位輸入材質的相對路徑，如：「tmw/ccc.tga」），僅支援尺寸為2的N次方（32， 64， 128，等）並且類型為.tga和.blp的材質檔案。]=]
L["ANIM_THICKNESS"] = "邊框粗細"
L["ANIM_THICKNESS_DESC"] = "設定邊框的粗細為多少。（一個圖示的預設尺寸為30。）"
L["ANN_CHANTOUSE"] = "使用頻道"
L["ANN_EDITBOX"] = "要輸出的文字內容"
L["ANN_EDITBOX_DESC"] = "輸入通知事件觸發時你想輸出的文字內容。"
L["ANN_EDITBOX_WARN"] = "在此輸入你想要輸出的文字內容"
L["ANN_FCT_DESC"] = "使用暴雪的浮動戰鬥文字功能輸出。必須先啟用介面選項中的文字輸出。"
L["ANN_NOTEXT"] = "<暫無文字>"
L["ANN_SHOWICON"] = "顯示圖示材質"
L["ANN_SHOWICON_DESC"] = "一些文字目標能連同文字內容一起顯示一個材質。勾選此項啟用該功能。"
L["ANN_STICKY"] = "靜態訊息"
L["ANN_SUB_CHANNEL"] = "輸出位置"
L["ANN_TAB"] = "文字"
L["ANN_TAB_DESC"] = "設定要輸出的文字。包括暴雪的文字頻道、UI框體以及其他的一些插件。"
L["ANN_WHISPERTARGET"] = "悄悄話目標"
L["ANN_WHISPERTARGET_DESC"] = "輸入你想要密語的玩家名字， 僅可密語同伺服器/同陣營的玩家。"
L["ASCENDING"] = "升序"
L["ASPECT"] = "守護"
L["AURA"] = "光環"
L["BACK_IE"] = "轉到上一個"
L["BACK_IE_DESC"] = [=[載入上一個編輯過的圖示

%s |T%s:0|t.]=]
L["Bleeding"] = "流血效果"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["BUFFCNDT_DESC"] = "只有第一個法術會被檢查，其他的將全部被忽略。"
L["BUFFTOCHECK"] = "要檢查的增益"
L["BUFFTOCOMP1"] = "進行比較的第一個增益"
L["BUFFTOCOMP2"] = "進行比較的第二個增益"
L["BURNING_EMBERS_FRAGMENTS"] = "燃火餘燼碎片"
L["BURNING_EMBERS_FRAGMENTS_DESC"] = [=[一個完整的燃火餘燼由十個碎片所組成。

假如你有一個半的燃火餘燼（由十五個餘燼碎片組成），你要監視全部的餘燼碎片時，可能需要使用此條件。]=]
L["CACHING"] = "TellMeWhen正在快取和篩選遊戲中的所有法術。這只需要在每次魔獸世界補丁升級之後完成一次。您可以使用下方的滑桿加快或減慢過程。"
L["CACHINGSPEED"] = "法術快取速度（每幀法術）："
L["CASTERFORM"] = "施法者形態"
L["CENTER"] = "中間"
L["CHANGELOG"] = "更新紀錄"
L["CHANGELOG_DESC"] = "顯示TellMeWhen當前和之前版本的變動列表。"
L["CHANGELOG_INFO2"] = [=[歡迎使用 TellMeWhen v%s!
<br/><br/>
在你確認完更新訊息後, 點擊標簽 %s 或底部的標簽 %s 開始設置TellMeWhen。]=]
L["CHANGELOG_LAST_VERSION"] = "以前安裝的版本"
L["CHAT_FRAME"] = "聊天視窗"
L["CHAT_MSG_CHANNEL"] = "聊天頻道"
L["CHAT_MSG_CHANNEL_DESC"] = "將輸出到一個聊天頻道，例如交易頻道或是你加入的某個自訂頻道。"
L["CHAT_MSG_SMART"] = "智能頻道"
L["CHAT_MSG_SMART_DESC"] = "此頻道會自行選擇最合適的輸出頻道。（僅限於：戰場，團隊，隊伍，或者說）"
L["CHOOSEICON"] = "選擇一個用於檢查的圖示"
L["CHOOSEICON_DESC"] = [=[|cff7fffff點擊：|r來選擇一個圖示/群組。
|cff7fffff左鍵點擊並拖拽：|r以滾動方式改變排序。
|cff7fffff右鍵點擊並拖拽：|r以常見方式交換位置。

譯者註：如果搞不清楚，只需要用常見方式（右鍵點擊並拖拽）來改變排序即可。]=]
L["CHOOSENAME_DIALOG"] = [=[輸入你想讓此圖示監視的名稱或者ID，你可以利用半形分號（;）輸入多個條目（名稱、ID、同類型的任意組合）。

你可以使用減號從同類型法術中單獨移除某個法術，例如"Slowed; -暈眩"。

你可以|cff7fffff按住Shift再按左鍵點選|r法術/物品/聊天連結或者拖拽法術/物品添加到此編輯框中。]=]
L["CHOOSENAME_DIALOG_PETABILITIES"] = "|cFFFF5959寵物技能|r必須使用法術ID。"
L["CLEU_"] = "任意事件"
L["CLEU_CAT_AURA"] = "增益/減益"
L["CLEU_CAT_CAST"] = "施法"
L["CLEU_CAT_MISC"] = "其他"
L["CLEU_CAT_SPELL"] = "法術"
L["CLEU_CAT_SWING"] = "近戰/遠程"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MASK"] = "操控者關係"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE"] = "操控者關係：玩家（你）"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_MINE_DESC"] = "勾選以排除那些你控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER"] = "操控者關係：外人"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_OUTSIDER_DESC"] = "勾選以排除那些與你同組的某人控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY"] = "操控者關係：隊伍成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_PARTY_DESC"] = "勾選以排除那些你隊伍中的玩家控制的單位。"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID"] = "操控者關係：團隊成員"
L["CLEU_COMBATLOG_OBJECT_AFFILIATION_RAID_DESC"] = "勾選以排除那些你團隊中的玩家控制的單位。"
L["CLEU_COMBATLOG_OBJECT_CONTROL_MASK"] = "操控者"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC"] = "操控者：伺服器"
L["CLEU_COMBATLOG_OBJECT_CONTROL_NPC_DESC"] = "勾選以排除那些伺服器控制的單位（包括它們的寵物跟守護者）。"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER"] = "操控者：人類"
L["CLEU_COMBATLOG_OBJECT_CONTROL_PLAYER_DESC"] = "勾選以排除那些人類控制的單位（包括他們的寵物跟守護者），這裡是指真正的人類，不是遊戲中的人類種族，如果你教會了猴子、猩猩玩魔獸世界的話，可以算上它們。"
L["CLEU_COMBATLOG_OBJECT_FOCUS"] = "其他：你的專注目標"
L["CLEU_COMBATLOG_OBJECT_FOCUS_DESC"] = "勾選以排除那個你設定為專注目標的單位。"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST"] = "其他：主助攻"
L["CLEU_COMBATLOG_OBJECT_MAINASSIST_DESC"] = "勾選以排除團隊中被標記為主助攻的單位。"
L["CLEU_COMBATLOG_OBJECT_MAINTANK"] = "其他：主坦克"
L["CLEU_COMBATLOG_OBJECT_MAINTANK_DESC"] = "勾選以排除團隊中被標記為主坦克的單位。"
L["CLEU_COMBATLOG_OBJECT_NONE"] = "其他：未知單位"
L["CLEU_COMBATLOG_OBJECT_NONE_DESC"] = "勾選以排除WoW客戶端完全未知的單位，還可以排除在遊戲客戶端中沒有提供單位的一些事件。"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY"] = "單位反應：友好"
L["CLEU_COMBATLOG_OBJECT_REACTION_FRIENDLY_DESC"] = "勾選以排除那些對你反應是友好的單位。"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE"] = "單位反應：敵對"
L["CLEU_COMBATLOG_OBJECT_REACTION_HOSTILE_DESC"] = "勾選以排除那些對你反應是敵對的單位。"
L["CLEU_COMBATLOG_OBJECT_REACTION_MASK"] = "單位反應"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL"] = "單位反應：中立"
L["CLEU_COMBATLOG_OBJECT_REACTION_NEUTRAL_DESC"] = "勾選以排除那些對你反應是中立的單位。"
L["CLEU_COMBATLOG_OBJECT_TARGET"] = "其他：你的目標"
L["CLEU_COMBATLOG_OBJECT_TARGET_DESC"] = "勾選以排除你當前的目標單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN"] = "單位類型：守護者"
L["CLEU_COMBATLOG_OBJECT_TYPE_GUARDIAN_DESC"] = "勾選以排除守護者。 守護者指那些會保護操控者但是不能直接被控制的單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_MASK"] = "單位類型"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC"] = "單位類型：NPC"
L["CLEU_COMBATLOG_OBJECT_TYPE_NPC_DESC"] = "勾選以排除非玩家角色。"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT"] = "單位類型：對象"
L["CLEU_COMBATLOG_OBJECT_TYPE_OBJECT_DESC"] = "勾選以排除像是陷阱，魚點等其他沒有被劃分到「單位類型」中的其他任何東西。"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET"] = "單位類型：寵物"
L["CLEU_COMBATLOG_OBJECT_TYPE_PET_DESC"] = "勾選以排除寵物。 寵物指那些會保護操控者並且可以直接被控制的單位。"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER"] = "單位類型：玩家角色"
L["CLEU_COMBATLOG_OBJECT_TYPE_PLAYER_DESC"] = "勾選以排除玩家角色。"
L["CLEU_CONDITIONS_DESC"] = [=[配置每個單元必須通過的條件，以便進行檢查。

這些條件僅在輸入要檢查的單位，並且所有輸入的單位均為單位ID時可用 - 不能在這些條件下使用名稱。]=]
L["CLEU_CONDITIONS_DEST"] = "目標條件"
L["CLEU_CONDITIONS_SOURCE"] = "來源條件"
L["CLEU_DAMAGE_SHIELD"] = "傷害護盾"
L["CLEU_DAMAGE_SHIELD_DESC"] = "此事件在傷害護盾對一個單位造成傷害時發生。 （%s，%s，等等，但是不包括%s）"
L["CLEU_DAMAGE_SHIELD_MISSED"] = "傷害護盾未命中"
L["CLEU_DAMAGE_SHIELD_MISSED_DESC"] = "此事件在傷害護盾對一個單位造成傷害失敗時發生。 （%s，%s，等等，但是不包括%s）"
L["CLEU_DAMAGE_SPLIT"] = "傷害分擔"
L["CLEU_DAMAGE_SPLIT_DESC"] = "此事件在傷害被兩個或更多個單位分擔時發生。"
L["CLEU_DESTUNITS"] = "用於檢查的目標單位"
L["CLEU_DESTUNITS_DESC"] = "選擇你想要圖示檢查的事件目標單位，可以保留空白讓圖示檢查任意的事件目標單位。"
L["CLEU_DIED"] = "死亡"
L["CLEU_ENCHANT_APPLIED"] = "附魔應用"
L["CLEU_ENCHANT_APPLIED_DESC"] = "此事件所指為暫時性武器附魔，像是盜賊的毒藥和薩滿的武器強化。"
L["CLEU_ENCHANT_REMOVED"] = "附魔移除"
L["CLEU_ENCHANT_REMOVED_DESC"] = "此事件所指為暫時性武器附魔，像是盜賊的毒藥和薩滿的武器強化。"
L["CLEU_ENVIRONMENTAL_DAMAGE"] = "環境傷害"
L["CLEU_ENVIRONMENTAL_DAMAGE_DESC"] = "包括來自熔岩，掉落，溺水以及疲勞的傷害。"
L["CLEU_EVENTS"] = "用於檢查的事件"
L["CLEU_EVENTS_ALL"] = "全部事件"
L["CLEU_EVENTS_DESC"] = "選擇那些你想要圖示檢查的戰鬥事件。"
L["CLEU_FLAGS_DESC"] = "可以排除列表中包含的某種屬性的單位使其無法觸發圖示。如果勾選排除某種屬性的單位，圖示將不會處理那個單位相關的事件。"
L["CLEU_FLAGS_DEST"] = "排除"
L["CLEU_FLAGS_SOURCE"] = "排除"
L["CLEU_HEADER"] = "戰鬥事件篩選"
L["CLEU_HEADER_DEST"] = "目標單位"
L["CLEU_HEADER_SOURCE"] = "來源單位"
L["CLEU_NOFILTERS"] = "%s圖示在%s沒有定義任何篩選條件。你需要定義至少一個篩選條件，否則無法正常使用。"
L["CLEU_PARTY_KILL"] = "隊伍擊殺"
L["CLEU_PARTY_KILL_DESC"] = "當隊伍中的某人殺死某個怪物時觸發。"
L["CLEU_RANGE_DAMAGE"] = "遠程攻擊傷害"
L["CLEU_RANGE_MISSED"] = "遠程攻擊未命中"
L["CLEU_SOURCEUNITS"] = "用於檢查的來源單位"
L["CLEU_SOURCEUNITS_DESC"] = "選擇你想要圖示檢查的事件來源單位，可以保留空白讓圖示檢查任意的事件來源單位。"
L["CLEU_SPELL_AURA_APPLIED"] = "效果獲得（指目標單位獲得某增益/減益，來源單位為施放者）"
L["CLEU_SPELL_AURA_APPLIED_DOSE"] = "效果堆疊"
L["CLEU_SPELL_AURA_BROKEN"] = "效果被打破（物理）"
L["CLEU_SPELL_AURA_BROKEN_SPELL"] = "效果被打破（法術）"
L["CLEU_SPELL_AURA_BROKEN_SPELL_DESC"] = [=[此事件在一個效果被法術傷害打破時發生（通常是指某種控場技能）。

圖示會篩選出被打破的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_AURA_REFRESH"] = "效果刷新"
L["CLEU_SPELL_AURA_REMOVED"] = "效果移除"
L["CLEU_SPELL_AURA_REMOVED_DOSE"] = "效果堆疊移除"
L["CLEU_SPELL_CAST_FAILED"] = "施法失敗"
L["CLEU_SPELL_CAST_START"] = "開始施法"
L["CLEU_SPELL_CAST_START_DESC"] = [=[此事件在開始施放一個法術時發生。

注意：為了防止可能出現的遊戲框架濫用，暴雪禁用了此事件的目標單位，所以你不能篩選它們。]=]
L["CLEU_SPELL_CAST_SUCCESS"] = "法術施放成功"
L["CLEU_SPELL_CAST_SUCCESS_DESC"] = "此事件在法術施法成功時發生。"
L["CLEU_SPELL_CREATE"] = "法術製造"
L["CLEU_SPELL_CREATE_DESC"] = "此事件在一個對像被製造時發生，例如獵人的陷阱跟法師的傳送門。"
L["CLEU_SPELL_DAMAGE"] = "法術傷害"
L["CLEU_SPELL_DAMAGE_CRIT"] = "法術致命一擊"
L["CLEU_SPELL_DAMAGE_CRIT_DESC"] = "此事件在任意法術傷害造成致命一擊時發生，會跟%q事件同時觸發。"
L["CLEU_SPELL_DAMAGE_DESC"] = "此事件在任意法術造成傷害時發生。"
L["CLEU_SPELL_DAMAGE_NONCRIT"] = "法術未致命一擊"
L["CLEU_SPELL_DAMAGE_NONCRIT_DESC"] = "此事件在任意法術傷害沒有造成致命一擊時發生，會跟%q事件同時觸發。"
L["CLEU_SPELL_DISPEL"] = "驅散"
L["CLEU_SPELL_DISPEL_DESC"] = [=[此事件在一個效果被驅散時發生。

圖示會篩選出被驅散的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_DISPEL_FAILED"] = "驅散失敗"
L["CLEU_SPELL_DISPEL_FAILED_DESC"] = [=[此事件在驅散某一效果失敗時發生。

圖示會篩選出這個驅散失敗的效果;在文字輸出/顯示時你可以使用標籤[Extra]替代這個效果。]=]
L["CLEU_SPELL_DRAIN"] = "抽取資源"
L["CLEU_SPELL_DRAIN_DESC"] = "此事件在資源從一個單位移除時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_ENERGIZE"] = "獲得資源"
L["CLEU_SPELL_ENERGIZE_DESC"] = "此事件在一個單位獲得資源時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_EXTRA_ATTACKS"] = "獲得額外攻擊"
L["CLEU_SPELL_EXTRA_ATTACKS_DESC"] = "此事件在你獲得額外的近戰攻擊時發生。"
L["CLEU_SPELL_HEAL"] = "治療"
L["CLEU_SPELL_INSTAKILL"] = "秒殺"
L["CLEU_SPELL_INTERRUPT"] = "中斷 - 被中斷的法術"
L["CLEU_SPELL_INTERRUPT_DESC"] = [=[此事件在施法被中斷時發生。

圖示會篩選出被中斷施法的法術;在文字輸出/顯示時你可以使用標籤[Extra]替代這個法術。

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生，但是篩選出的法術會有所不同。]=]
L["CLEU_SPELL_INTERRUPT_SPELL"] = "中斷 - 造成中斷的法術"
L["CLEU_SPELL_INTERRUPT_SPELL_DESC"] = [=[此事件在施法被中斷時發生。

圖示會篩選出造成中斷施法的法術;在文字輸出/顯示時你可以使用標籤[Extra]替代這個法術。

請注意兩個中斷事件的區別- 當一個法術被中斷時兩個事件都會發生，但是篩選出的法術會有所不同。]=]
L["CLEU_SPELL_LEECH"] = "資源吸取"
L["CLEU_SPELL_LEECH_DESC"] = "此事件在從一個單位移除資源給另一單位時發生（資源指生命值/法力值/怒氣/能量等）。"
L["CLEU_SPELL_MISSED"] = "法術未命中"
L["CLEU_SPELL_PERIODIC_DAMAGE"] = "傷害（週期）"
L["CLEU_SPELL_PERIODIC_DRAIN"] = "抽取資源（週期）"
L["CLEU_SPELL_PERIODIC_ENERGIZE"] = "獲得資源（週期）"
L["CLEU_SPELL_PERIODIC_HEAL"] = "治療（週期）"
L["CLEU_SPELL_PERIODIC_LEECH"] = "資源吸取（週期）"
L["CLEU_SPELL_PERIODIC_MISSED"] = "傷害（週期）未命中"
L["CLEU_SPELL_REFLECT"] = "法術反射"
L["CLEU_SPELL_REFLECT_DESC"] = [=[此事件在你反射一個對你施放的法術時發生。

來源單位是反射法術者，目標單位是法術被反射的施法者。]=]
L["CLEU_SPELL_RESURRECT"] = "復活"
L["CLEU_SPELL_RESURRECT_DESC"] = "此事件在某個單位從死亡中被復活時發生。"
L["CLEU_SPELL_STOLEN"] = "效果被竊取"
L["CLEU_SPELL_STOLEN_DESC"] = [=[此事件在增益被竊取時發生，很可能來自%s。

圖示會篩選出那個被竊取的法術。]=]
L["CLEU_SPELL_SUMMON"] = "法術召喚"
L["CLEU_SPELL_SUMMON_DESC"] = "此事件在一個NPC被召喚或者生成時發生。"
L["CLEU_SWING_DAMAGE"] = "近戰攻擊傷害"
L["CLEU_SWING_MISSED"] = "近戰攻擊未命中"
L["CLEU_TIMER"] = "設定事件的計時器"
L["CLEU_TIMER_DESC"] = [=[設定圖示計時器在事件發生時的持續時間。

你也可以在%q編輯框中使用「法術:持續時間」語法指定一個持續時間，在事件處理你篩選出的那些法術時使用。

如果法術沒有指定持續時間，或者你沒有篩選任何法術（編輯框為空白），那將使用這個持續時間。]=]
L["CLEU_UNIT_DESTROYED"] = "單位被摧毀"
L["CLEU_UNIT_DESTROYED_DESC"] = "此事件在一個單位被摧毀時發生（例如薩滿的圖騰）。"
L["CLEU_UNIT_DIED"] = "單位死亡"
L["CLEU_WHOLECATEGORYEXCLUDED"] = [=[你排除了%q分類中的所有條目，這將導致圖示不再處理任何事件。

取消勾選至少一個條目使圖示可以正常運作。]=]
L["CLICK_TO_EDIT"] = "|cff7fffff點擊|r編輯。"
L["CMD_CHANGELOG"] = "更新日誌"
L["CMD_DISABLE"] = "停用"
L["CMD_ENABLE"] = "啟用"
L["CMD_OPTIONS"] = "選項"
L["CMD_PROFILE"] = "設定檔"
L["CMD_PROFILE_INVALIDPROFILE"] = "無法找到名為「%q」的設定檔! （譯者註：注意區分大小寫）"
L["CMD_PROFILE_INVALIDPROFILE_SPACES"] = [=[提示：如果設定檔包含空格，請在前後加上半形引號。

例如：
/tmw profile "阿光光 - 地獄吼"
或
/tmw 設定檔 "薇璇 - 地獄吼"]=]
L["CMD_TOGGLE"] = "切換"
L["CNDT_DEPRECATED_DESC"] = "條件%s無效。這可能是因為遊戲機制改變所造成的，請移除它或者更改為其他條件。"
L["CNDT_MULTIPLEVALID"] = "你可以利用分號分隔的方式輸入多個用於檢查的名稱或ID。"
L["CNDT_ONLYFIRST"] = "僅檢查第一個法術/物品，使用分號分隔的列表不適用此條件類型。"
L["CNDT_RANGE"] = "單位距離"
L["CNDT_RANGE_DESC"] = "使用LibRangeCheck-2.0檢查單位的大致距離．單位不存在時條件將會返回否（false）。"
L["CNDT_RANGE_IMPRECISE"] = "%d 碼。 （|cffff1300不太準確|r）"
L["CNDT_RANGE_PRECISE"] = "%d 碼。 （|cff00c322準確|r）"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOMANUAL"] = "|cff7fffff點擊右鍵|r切換到手動輸入模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER"] = "|cff7fffff點擊右鍵|r切換到滑動條選擇模式。"
L["CNDT_SLIDER_DESC_CLICKSWAP_TOSLIDER_DISALLOWED"] = "僅允許在手動輸入時輸入大於%s的數值。（較大的數值顯示在暴雪滑動條上會變得很奇怪）"
L["CNDT_TOTEMNAME"] = "圖騰名稱"
L["CNDT_TOTEMNAME_DESC"] = [=[設定為空白檢查所選的圖騰類型中的全部圖騰。

如果需要檢查指定的圖騰，請輸入一個圖騰名稱或是利用分號分隔開的名稱列表。]=]
L["CNDT_UNKNOWN_DESC"] = "你的設定中有一個名為%s的標識無法找到對應的條件。可能是因為使用了舊版本的TMW或者該條件已經被移除。"
L["CNDTCAT_ARCHFRAGS"] = "考古學碎片"
L["CNDTCAT_ATTRIBUTES_PLAYER"] = "玩家屬性/狀態"
L["CNDTCAT_ATTRIBUTES_UNIT"] = "單位屬性/狀態"
L["CNDTCAT_BOSSMODS"] = "首領模塊"
L["CNDTCAT_BUFFSDEBUFFS"] = "增益/減益"
L["CNDTCAT_CURRENCIES"] = "通貨"
L["CNDTCAT_FREQUENTLYUSED"] = "常用條件"
L["CNDTCAT_LOCATION"] = "組隊/區域"
L["CNDTCAT_MISC"] = "其他"
L["CNDTCAT_RESOURCES"] = "能量類型"
L["CNDTCAT_SPELLSABILITIES"] = "法術/物品"
L["CNDTCAT_STATS"] = "戰鬥統計（人物屬性）"
L["CNDTCAT_TALENTS"] = "職業/天賦"
L["CODESNIPPET_ADD2"] = "新 %s 片段"
L["CODESNIPPET_ADD2_DESC"] = "|cff7fffff點擊|r新增 %s 片段。"
L["CODESNIPPET_AUTORUN"] = "登入時自動執行"
L["CODESNIPPET_AUTORUN_DESC"] = "如果啟用，此片段將在TWM載入時運行(運行時間為在玩家登入事件PLAYER_LOGIN時，但是在圖標跟分組創建之前)。"
L["CODESNIPPET_CODE"] = "用於執行的Lua程式碼"
L["CODESNIPPET_DELETE"] = "刪除片段"
L["CODESNIPPET_DELETE_CONFIRM"] = "你確定要刪除程式碼片段（%q）？"
L["CODESNIPPET_EDIT_DESC"] = "|cff7fffff點擊|r 編輯此片段。"
L["CODESNIPPET_GLOBAL"] = "共用片段"
L["CODESNIPPET_ORDER"] = "執行順序"
L["CODESNIPPET_ORDER_DESC"] = [=[設定此程式碼片段的執行順序（相對於其他的片段而言）。

%s和%s都將基於這個數值來執行。

如果兩個片段使用了相同的順序，無法確認誰先執行的時候，可以使用小數。]=]
L["CODESNIPPET_PROFILE"] = "角色專用片段"
L["CODESNIPPET_RENAME"] = "程式碼片段名稱"
L["CODESNIPPET_RENAME_DESC"] = [=[為這個片段輸入一個自己容易識別的名稱。

名稱不是唯一，允許重複使用。]=]
L["CODESNIPPET_RUNAGAIN"] = "再次運行片段"
L["CODESNIPPET_RUNAGAIN_DESC"] = [=[此片段已經在進程中運行過一次。

|cff7fffff點擊|r再次運行。]=]
L["CODESNIPPET_RUNNOW"] = "執行片段"
L["CODESNIPPET_RUNNOW_DESC"] = [=[點擊執行此程式碼片段。

按住|cff7fffffCtrl|r繞過片段已經執行的確認。]=]
L["CODESNIPPETS"] = "Lua程式碼片段"
L["CODESNIPPETS_DEFAULTNAME"] = "新片段"
L["CODESNIPPETS_DESC"] = [=[此功能允許你編寫Lua程式碼並在TellMeWhen載入時執行。

它是一個進階功能，可以讓Lua熟練工如魚得水，也可以讓完全不懂Lua的人匯入其他TellMeWhen使用者分享出來的片段。

可用在像是編寫一個特定的過程用於Lua條件中（必須把它們定義在TMW.CNDT.Env）。

片段可被定義為角色專用或公用（共用片段會在所有角色執行）。]=]
L["CODESNIPPETS_DESC_SHORT"] = "輸入的LUA代碼會在TellMeWhen初始化的時候運行。"
L["CODESNIPPETS_IMPORT_GLOBAL"] = "新的共用片段"
L["CODESNIPPETS_IMPORT_GLOBAL_DESC"] = "片段匯入為共用片段。"
L["CODESNIPPETS_IMPORT_PROFILE"] = "新的角色專用片段"
L["CODESNIPPETS_IMPORT_PROFILE_DESC"] = "片段匯入為角色專用片段。"
L["CODESNIPPETS_TITLE"] = "Lua片段（進階）"
L["CODETOEXE"] = "要執行的代碼"
L["COLOR_MSQ_COLOR"] = "使用Masque邊框顏色（整個圖示）"
L["COLOR_MSQ_COLOR_DESC"] = "勾選此項將使用Masque皮膚中設定的邊框顏色對圖示著色（假如你在皮膚設定中有使用邊框的話）。"
L["COLOR_MSQ_ONLY"] = "使用Masque邊框顏色（僅邊框）"
L["COLOR_MSQ_ONLY_DESC"] = "勾選此項將僅對圖示邊框使用Masque皮膚中設定的邊框顏色進行著色（假如你在皮膚設定中有使用邊框的話）。圖示不會被著色。"
L["COLOR_OVERRIDE_GLOBAL"] = "覆蓋全局顏色"
L["COLOR_OVERRIDE_GLOBAL_DESC"] = "勾選以配置獨立於全局定義顏色的顏色。"
L["COLOR_OVERRIDE_GROUP"] = "覆蓋分組顏色"
L["COLOR_OVERRIDE_GROUP_DESC"] = "勾選以配置與為圖標組指定的顏色無關的顏色。"
L["COLOR_USECLASS"] = "使用職業顏色"
L["COLOR_USECLASS_DESC"] = "勾選使用所檢測單位的職業顏色來給進度條著色。"
L["COLORPICKER_BRIGHTNESS"] = "亮度"
L["COLORPICKER_BRIGHTNESS_DESC"] = "設置顏色的亮度(有時也稱為值)"
L["COLORPICKER_DESATURATE"] = "減少飽和度"
L["COLORPICKER_DESATURATE_DESC"] = "在應用顏色之前對紋理去飽和，允許您重新著色紋理，而不是著色。"
L["COLORPICKER_HUE"] = "色度"
L["COLORPICKER_HUE_DESC"] = "設置顏色的色度"
L["COLORPICKER_ICON"] = "預覽"
L["COLORPICKER_OPACITY"] = "透明度"
L["COLORPICKER_OPACITY_DESC"] = "設置顏色的透明度(有時稱為alpha)。"
L["COLORPICKER_RECENT"] = "最近使用的顏色"
L["COLORPICKER_RECENT_DESC"] = [=[|cff7fffff點擊|r讀取這個顏色。
|cff7fffff右鍵點擊|r從列表移除這個顏色。]=]
L["COLORPICKER_SATURATION"] = "飽和度"
L["COLORPICKER_SATURATION_DESC"] = "設置顏色的飽和度。"
L["COLORPICKER_STRING"] = "16進制字串"
L["COLORPICKER_STRING_DESC"] = "獲取/設置 當前顏色的十六進制(A)RGB"
L["COLORPICKER_SWATCH"] = "顏色"
L["COMPARISON"] = "比較"
L["CONDITION_COUNTER"] = "用於檢查的計數器"
L["CONDITION_COUNTER_EB_DESC"] = "輸入你想要檢查的計數器名稱。"
L["CONDITION_QUESTCOMPLETE"] = "任務完成"
L["CONDITION_QUESTCOMPLETE_DESC"] = "檢查一個任務是否已完成。"
L["CONDITION_QUESTCOMPLETE_EB_DESC"] = [=[輸入你想檢查的任務ID​​。

任務ID可以在魔獸世界數據庫網站獲得，像是db.178.com（中文）和www.wowhead.com（英文）。

例如：http:////db.178.com/wow/tw/quest/32615.html<更多更多龐大的恐龍骨頭>任務ID為32615。]=]
L["CONDITION_TIMEOFDAY"] = "一天中的時間"
L["CONDITION_TIMEOFDAY_DESC"] = [=[此條件將使用當前時間與設定時間進行比較。

用於比較的時間是當地時間（基於你的電腦時鐘）。它不會獲取伺服器時間。]=]
L["CONDITION_TIMER"] = "用於檢查的計時器"
L["CONDITION_TIMER_EB_DESC"] = "輸入你想用於檢查的計時器名稱。"
L["CONDITION_TIMERS_FAIL_DESC"] = [=[設定條件無法通過以後圖示計時器的持續時間

（譯者註：圖示在條件每次通過/無法通過後都會重新計時，另外在預設的情況下圖示的顯示只會根據條件通過情況來改變，設定的持續時間不會影響到圖示的顯示情況，不會在設定的持續時間倒數結束後隱藏圖示，如果想要圖示在計時結束後隱藏，需要勾選「僅在計時器作用時顯示」，這是4.5.3版本新加入的功能。）]=]
L["CONDITION_TIMERS_SUCCEED_DESC"] = [=[設定條件成功通過以後圖示計時器的持續時間

（譯者註：圖示在條件每次通過/無法通過後都會重新計時，另外在預設的情況下圖示的顯示只會根據條件通過情況來改變，設定的持續時間不會影響到圖示的顯示情況，不會在設定的持續時間倒數結束後隱藏圖示，如果想要圖示在計時結束後隱藏，需要勾選'僅在計時器作用時顯示'，這是4.5.3版本新加入的功能。）]=]
L["CONDITION_WEEKDAY"] = "星期幾"
L["CONDITION_WEEKDAY_DESC"] = [=[檢查今天是不是星期幾。

用於檢查的時間是當地時間（基於你的電腦時鐘）。它不會獲取伺服器時間。]=]
L["CONDITIONALPHA_METAICON"] = "條件未通過時"
L["CONDITIONALPHA_METAICON_DESC"] = [=[此可見度用於條件未通過時。

條件可在%q選項卡中設定。]=]
L["CONDITIONPANEL_ABSOLUTE"] = "（非百分比/絕對值）"
L["CONDITIONPANEL_ADD"] = "新增條件"
L["CONDITIONPANEL_ADD2"] = "點擊增加一個條件"
L["CONDITIONPANEL_ALIVE"] = "單位存活"
L["CONDITIONPANEL_ALIVE_DESC"] = "此條件會在單位還活著時通過"
L["CONDITIONPANEL_ALTPOWER"] = "特殊能量"
L["CONDITIONPANEL_ALTPOWER_DESC"] = "這是浩劫與重生某些首領戰遇到的特殊能量，像是丘加利的腐化值跟亞特拉米德的音波值。"
L["CONDITIONPANEL_AND"] = "同時"
L["CONDITIONPANEL_ANDOR"] = "同時/或者"
L["CONDITIONPANEL_ANDOR_DESC"] = "|cff7fffff點擊|r切換邏輯運算符 同時/或者（And/Or）"
L["CONDITIONPANEL_AUTOCAST"] = "寵物自動施法"
L["CONDITIONPANEL_AUTOCAST_DESC"] = "檢查指定寵物技能是否自動釋放中。"
L["CONDITIONPANEL_BIGWIGS_ENGAGED"] = "Big Wigs - 首領戰開始"
L["CONDITIONPANEL_BIGWIGS_ENGAGED_DESC"] = [=[檢查Big Wigs激活的首領戰。

請輸入首領戰的全名到「用於檢查的首領戰」。]=]
L["CONDITIONPANEL_BIGWIGS_TIMER"] = "Big Wigs - 計時器"
L["CONDITIONPANEL_BIGWIGS_TIMER_DESC"] = [=[檢測Big Wigs首領模塊計時器的持續時間。

請輸入計時器全名到「用於檢查的計時器」。]=]
L["CONDITIONPANEL_BITFLAGS_ALWAYS"] = "總是如此"
L["CONDITIONPANEL_BITFLAGS_CHECK"] = "否定選擇"
L["CONDITIONPANEL_BITFLAGS_CHECK_DESC"] = [=[檢查此設置，以反轉用於檢查此條件的邏輯。

默認情況下，這種情況將通過是否有任何選擇的選項是正確的。

如果選中該設置，限制將會通過如果所有選擇的選項是錯誤的。]=]
L["CONDITIONPANEL_BITFLAGS_CHOOSECLASS"] = "選擇職業……"
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_CONTINENT"] = "選擇大陸..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_RAIDICON"] = "選擇圖標..."
L["CONDITIONPANEL_BITFLAGS_CHOOSEMENU_TYPES"] = "選擇類型……"
L["CONDITIONPANEL_BITFLAGS_CHOOSERACE"] = "選擇種族..."
L["CONDITIONPANEL_BITFLAGS_NEVER"] = "無 - 不要精確"
L["CONDITIONPANEL_BITFLAGS_NOT"] = "非"
L["CONDITIONPANEL_BITFLAGS_SELECTED"] = "|cff7fffff已選|r："
L["CONDITIONPANEL_BLIZZEQUIPSET"] = "套裝已裝備（裝備管理器）"
L["CONDITIONPANEL_BLIZZEQUIPSET_DESC"] = "檢查暴雪裝備管理器中的套裝設定是否已裝備。"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT"] = "套裝名稱"
L["CONDITIONPANEL_BLIZZEQUIPSET_INPUT_DESC"] = [=[輸入你要檢查的暴雪裝備管理器中的套裝名稱。

只允許輸入一個套裝，注意|cFFFF5959區分大小寫|r。

譯者註：可以從右側的提示與建議列表中直接選擇套裝名稱。]=]
L["CONDITIONPANEL_CASTCOUNT"] = "法術施放次數"
L["CONDITIONPANEL_CASTCOUNT_DESC"] = "檢查一個單位施放某個法術的次數。"
L["CONDITIONPANEL_CASTTOMATCH"] = "用於比較的法術"
L["CONDITIONPANEL_CASTTOMATCH_DESC"] = [=[在此輸入一個法術名稱使該條件只在施放的法術名稱跟輸入的法術名稱完全相符時才可通過。

你可以保留空白來檢查任意的法術施放/引導法術（不包括瞬發法術）。]=]
L["CONDITIONPANEL_CLASS"] = "單位職業"
L["CONDITIONPANEL_CLASSIFICATION"] = "單位分類"
L["CONDITIONPANEL_CLASSIFICATION_DESC"] = "檢測一個單位是否為精英、稀有、世界首領。"
L["CONDITIONPANEL_COMBAT"] = "單位在戰鬥中"
L["CONDITIONPANEL_COMBO"] = "連擊點數"
L["CONDITIONPANEL_COUNTER_DESC"] = "檢查「計數器」通知處理所創建和修改的計數器的值。"
L["CONDITIONPANEL_CREATURETYPE"] = "單位生物類型"
L["CONDITIONPANEL_CREATURETYPE_DESC"] = [=[你可以利用分號（;）輸入多個生物類型用於檢查。

輸入的生物類型必須同滑鼠提示資訊上所顯示的完全相同。

此條件會在所選單位的生物類型與你設定的任意一種生物類型相符時通過。]=]
L["CONDITIONPANEL_CREATURETYPE_LABEL"] = "生物類型"
L["CONDITIONPANEL_DBM_ENGAGED"] = "Deadly Boss Mods - 首領戰開始"
L["CONDITIONPANEL_DBM_ENGAGED_DESC"] = [=[檢查Deadly Boss Mods激活的首領戰。

請輸入首領戰的全名到「用於檢查的首領戰」。]=]
L["CONDITIONPANEL_DBM_TIMER"] = "Deadly Boss Mods - 計時器"
L["CONDITIONPANEL_DBM_TIMER_DESC"] = [=[檢查Deadly Boss Mods計時器的持續時間。

請輸入計時器的全名到「用於檢查的計時器」。]=]
L["CONDITIONPANEL_DEFAULT"] = "選擇條件類型……"
L["CONDITIONPANEL_ECLIPSE_DESC"] = "蝕星蔽月有一個範圍在-100（月蝕）到100（日蝕）。如果你想讓圖示在有80月蝕的時候顯示請輸入-80。"
L["CONDITIONPANEL_EQUALS"] = "等於"
L["CONDITIONPANEL_EXISTS"] = "單位存在"
L["CONDITIONPANEL_GREATER"] = "大於"
L["CONDITIONPANEL_GREATEREQUAL"] = "大於或者等於"
L["CONDITIONPANEL_GROUPSIZE"] = "副本大小"
L["CONDITIONPANEL_GROUPSIZE_DESC"] = [=[檢查針對當前實際調整的隊伍成員數量。


這包括當前的彈性團隊組合的調整。]=]
L["CONDITIONPANEL_GROUPTYPE"] = "隊伍類型"
L["CONDITIONPANEL_GROUPTYPE_DESC"] = "檢查你所在的隊伍類型(單獨,小隊或團隊)。"
L["CONDITIONPANEL_ICON"] = "圖示顯示"
L["CONDITIONPANEL_ICON_DESC"] = [=[此條件檢查指定的圖示為顯示或隱藏。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選「%q」。

The group of the icon being checked must be shown in order to check the icon， even if the condition is set to false。]=]
L["CONDITIONPANEL_ICON_HIDDEN"] = "隱藏"
L["CONDITIONPANEL_ICON_SHOWN"] = "顯示"
L["CONDITIONPANEL_ICONHIDDENTIME"] = "圖示隱藏時間"
L["CONDITIONPANEL_ICONHIDDENTIME_DESC"] = [=[此條件檢查指定的圖示隱藏了多久時間。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選 %q。]=]
L["CONDITIONPANEL_ICONSHOWNTIME"] = "圖示顯示時間"
L["CONDITIONPANEL_ICONSHOWNTIME_DESC"] = [=[此條件檢查指定的圖示顯示了多久時間。

如果你不想顯示被檢查的圖示，請在被檢查圖示的圖示編輯器勾選 %q。]=]
L["CONDITIONPANEL_INPETBATTLE"] = "在寵物對戰中"
L["CONDITIONPANEL_INSTANCETYPE"] = "副本類型"
L["CONDITIONPANEL_INSTANCETYPE_DESC"] = "檢測你所在的地下城的類型。此條件包含任何地下城或團隊副本的難度設置。"
L["CONDITIONPANEL_INSTANCETYPE_LEGACY"] = "%s （神話難度）"
L["CONDITIONPANEL_INSTANCETYPE_NONE"] = "戶外"
L["CONDITIONPANEL_INTERRUPTIBLE"] = "可斷法"
L["CONDITIONPANEL_ITEMRANGE"] = "單位在物品範圍內"
L["CONDITIONPANEL_LASTCAST"] = "最後使用的技能"
L["CONDITIONPANEL_LASTCAST_ISNTSPELL"] = "不匹配"
L["CONDITIONPANEL_LASTCAST_ISSPELL"] = "匹配"
L["CONDITIONPANEL_LESS"] = "小於"
L["CONDITIONPANEL_LESSEQUAL"] = "小於或者等於"
L["CONDITIONPANEL_LEVEL"] = "單位等級"
L["CONDITIONPANEL_LOC_CONTINENT"] = "大陸"
L["CONDITIONPANEL_LOC_SUBZONE"] = "子區域"
L["CONDITIONPANEL_LOC_SUBZONE_BOXDESC"] = "輸入您要檢查的子區域。 用分號分隔多個子區域。"
L["CONDITIONPANEL_LOC_SUBZONE_DESC"] = "檢查您當前的子區域。 請注意：有時，您可能不在子區域。"
L["CONDITIONPANEL_LOC_SUBZONE_LABEL"] = "輸入子區域進行檢查"
L["CONDITIONPANEL_LOC_ZONE"] = "地區"
L["CONDITIONPANEL_LOC_ZONE_DESC"] = "輸入您要檢查的區域。 用分號分隔多個區域。"
L["CONDITIONPANEL_LOC_ZONE_LABEL"] = "輸入用於檢測的區域"
L["CONDITIONPANEL_MANAUSABLE"] = "法術可用（法力值/能量/等是否夠用）"
L["CONDITIONPANEL_MANAUSABLE_DESC"] = [=[如果一個法術的可用基於你的主要能量（法力、能量、怒氣、符能、集中值等）。

不會再檢查基於第二能量的可用性（符文、聖能、真氣等）。]=]
L["CONDITIONPANEL_MAX"] = "（最大值）"
L["CONDITIONPANEL_MOUNTED"] = "在坐騎上"
L["CONDITIONPANEL_NAME"] = "單位名字"
L["CONDITIONPANEL_NAMETOMATCH"] = "用於比較的名字"
L["CONDITIONPANEL_NAMETOOLTIP"] = "你可以在每個名字後面加上分號（;）以便輸入多個需要比較的名字。 其中任何一個名字相符時此條件都會通過。"
L["CONDITIONPANEL_NOTEQUAL"] = "不等於"
L["CONDITIONPANEL_NPCID"] = "單位NPC編號"
L["CONDITIONPANEL_NPCID_DESC"] = [=[檢查指定的單位NPC編號。

NPC編號可以在Wowhead之類的魔獸世界數據庫找到（例如http:////www.wowhead.com/npc=62943）。

玩家與某些單位沒有NPC編號，在此條件中的返回值為0。]=]
L["CONDITIONPANEL_NPCIDTOMATCH"] = "用於比較的編號"
L["CONDITIONPANEL_NPCIDTOOLTIP"] = "你可以利用分號（;）輸入多個NPC編號。條件會在任意一個編號相符時通過。"
L["CONDITIONPANEL_OLD"] = "<|cffff1300舊版本|r>"
L["CONDITIONPANEL_OLD_DESC"] = "<|cffff1300舊版本|r> - 此條件有新版本可用。"
L["CONDITIONPANEL_OPERATOR"] = "運算符"
L["CONDITIONPANEL_OR"] = "或者"
L["CONDITIONPANEL_OVERLAYED"] = "法術啟用邊框"
L["CONDITIONPANEL_OVERLAYED_DESC"] = "檢測一個法術是否有啟用邊框效果（就是在你動作條有黃色的邊邊的技能）。"
L["CONDITIONPANEL_OVERRBAR"] = "動作條效果"
L["CONDITIONPANEL_OVERRBAR_DESC"] = "檢查你主要動作條上的一些動畫效果，不包含寵物戰鬥。"
L["CONDITIONPANEL_PERCENT"] = "（百分比）"
L["CONDITIONPANEL_PERCENTOFCURHP"] = "當前生命值百分比"
L["CONDITIONPANEL_PERCENTOFMAXHP"] = "最大生命百分比"
L["CONDITIONPANEL_PETMODE"] = "寵物攻擊模式"
L["CONDITIONPANEL_PETMODE_DESC"] = "檢查當前寵物的攻擊模式。"
L["CONDITIONPANEL_PETMODE_NONE"] = "沒有寵物"
L["CONDITIONPANEL_PETSPEC"] = "寵物種類"
L["CONDITIONPANEL_PETSPEC_DESC"] = "檢測你當前寵物的專精類型。"
L["CONDITIONPANEL_POWER"] = "基本資源"
L["CONDITIONPANEL_POWER_DESC"] = "檢查單位為德魯伊時在貓形態的能量，或者單位為戰士時的怒氣等等。"
L["CONDITIONPANEL_PVPFLAG"] = "開啟PVP的單位"
L["CONDITIONPANEL_RAIDICON"] = "單位團隊標記"
L["CONDITIONPANEL_RAIDICON_DESC"] = "檢測一個單位的團隊標記圖標。"
L["CONDITIONPANEL_REMOVE"] = "移除此條件"
L["CONDITIONPANEL_RESTING"] = "休息狀態"
L["CONDITIONPANEL_ROLE"] = "單位隊伍職責"
L["CONDITIONPANEL_ROLE_DESC"] = "檢測你隊伍、團隊中一個玩家所選擇的角色類型。"
L["CONDITIONPANEL_RUNES"] = "符文數量"
L["CONDITIONPANEL_RUNES_CHECK_DESC"] = [=[正常情況下，第一行的符文無論是不是死亡符文，在符合條件設定時都會通過。

啟用這個選項強制第一行的符文僅匹配非死亡符文。]=]
L["CONDITIONPANEL_RUNES_DESC3"] = "使用此條件僅在特定數量的符文可用時顯示圖示。"
L["CONDITIONPANEL_RUNESLOCK"] = "鎖定符文數量"
L["CONDITIONPANEL_RUNESLOCK_DESC"] = "使用此條件僅在特定數量的符文被鎖定時顯示圖示（等待恢復）。"
L["CONDITIONPANEL_RUNESRECH"] = "恢復中符文數量"
L["CONDITIONPANEL_RUNESRECH_DESC"] = "使用此條件僅在特定數量的符文恢復中時顯示圖示。"
L["CONDITIONPANEL_SPELLCOST"] = "施法所需能量"
L["CONDITIONPANEL_SPELLCOST_DESC"] = "檢測施法所需能量。像是法力值、怒氣、能量等等。"
L["CONDITIONPANEL_SPELLRANGE"] = "單位在法術範圍內"
L["CONDITIONPANEL_SWIMMING"] = "游泳狀態"
L["CONDITIONPANEL_THREAT_RAW"] = "單位威脅值 - 原始"
L["CONDITIONPANEL_THREAT_RAW_DESC"] = [=[此條件用來檢查你對一個單位的原始威脅值百分比。

近戰玩家仇恨失控（OT）的威脅值為110%
遠程玩家仇恨失控（OT）的威脅值為130%]=]
L["CONDITIONPANEL_THREAT_SCALED"] = "單位威脅值 - 比例"
L["CONDITIONPANEL_THREAT_SCALED_DESC"] = [=[此條件用來檢查你對一個單位的威脅值百分比比例。

100%表示你正在坦這個單位。]=]
L["CONDITIONPANEL_TIMER_DESC"] = "檢查通知事件「計時器」中的計時器所創建和變更的數值。"
L["CONDITIONPANEL_TRACKING"] = "追蹤"
L["CONDITIONPANEL_TRACKING_DESC"] = "檢測你小地圖當前所追蹤的類型。"
L["CONDITIONPANEL_TYPE"] = "類型"
L["CONDITIONPANEL_UNIT"] = "單位"
L["CONDITIONPANEL_UNITISUNIT"] = "單位比較"
L["CONDITIONPANEL_UNITISUNIT_DESC"] = "此條件在兩個編輯框輸入的單位為同一角色時通過。（例子：編輯框1為「targettarget」，編輯框2為「player」，當「目標的目標」為「玩家」時此條件通過。）"
L["CONDITIONPANEL_UNITISUNIT_EBDESC"] = "在此編輯框輸入需要與所指定的第一單位進行比較的第二單位。"
L["CONDITIONPANEL_UNITRACE"] = "單位種族"
L["CONDITIONPANEL_UNITSPEC"] = "單位專精"
L["CONDITIONPANEL_UNITSPEC_CHOOSEMENU"] = "選擇專精……"
L["CONDITIONPANEL_UNITSPEC_DESC"] = "此條件僅可用於戰場和競技場。"
L["CONDITIONPANEL_VALUEN"] = "值"
L["CONDITIONPANEL_VEHICLE"] = "單位控制載具"
L["CONDITIONPANEL_ZONEPVP"] = "區域PvP類型"
L["CONDITIONPANEL_ZONEPVP_DESC"] = "檢測區域的PvP類型（例如：爭奪中、聖域、戰鬥區域等）"
L["CONDITIONPANEL_ZONEPVP_FFA"] = "自由PVP"
L["CONDITIONS"] = "條件"
L["CONFIGMODE"] = "TellMeWhen正處於設定模式。 在離開設定模式之前，圖示無法正常使用。 輸入'/tellmewhen'或'/tmw'可以開啟或關閉設定模式。"
L["CONFIGMODE_EXIT"] = "退出設定模式"
L["CONFIGMODE_EXITED"] = "TMW已鎖定。輸入/tmw重新進入設定模式。"
L["CONFIGMODE_NEVERSHOW"] = "不再顯示此訊息"
L["CONFIGPANEL_BACKDROP_HEADER"] = "背景材質"
L["CONFIGPANEL_CBAR_HEADER"] = "計時條覆蓋"
L["CONFIGPANEL_CLEU_HEADER"] = "戰鬥事件"
L["CONFIGPANEL_CNDTTIMERS_HEADER"] = "條件計時器"
L["CONFIGPANEL_COMM_HEADER"] = "通訊"
L["CONFIGPANEL_MEDIA_HEADER"] = "媒體"
L["CONFIGPANEL_PBAR_HEADER"] = "能量條覆蓋"
L["CONFIGPANEL_TIMER_HEADER"] = "計時器時鐘"
L["CONFIGPANEL_TIMERBAR_BARDISPLAY_HEADER"] = "計時條"
L["CONFIRM_DELETE_GENERIC_DESC"] = "%s 將被刪除。"
L["CONFIRM_DELGROUP"] = "刪除分組"
L["CONFIRM_DELLAYOUT"] = "刪除樣式"
L["CONFIRM_HEADER"] = "確定嗎？"
L["COPYGROUP"] = "複製群組"
L["COPYPOSSCALE"] = "僅複製位置/比例"
L["CrowdControl"] = "控場技能"
L["Curse"] = "詛咒"
L["DamageBuffs"] = "傷害爆發增益"
L["DamageShield"] = "傷害護盾"
L["DBRESTORED_INFO"] = [=[TellMeWhen檢測到資料庫為空或已損壞。造成此情況最可能的原因是WoW沒有正常登出。

TellMeWhen_Options對資料庫多備份了一次，以防止這樣的情況發生，因為很少會出現TellMeWhen和TellMeWhen_Options的資料庫同時損壞。

你這個創建於%s的備份已還原。]=]
L["DEBUFFTOCHECK"] = "要檢查的減益"
L["DEBUFFTOCOMP1"] = "進行比較的第一個減益"
L["DEBUFFTOCOMP2"] = "進行比較的第二個減益"
L["DEFAULT"] = "預設值"
L["DefensiveBuffs"] = "防禦性增益"
L["DefensiveBuffsAOE"] = "AOE減傷Buffs"
L["DefensiveBuffsSingle"] = "單體減傷Buffs"
L["DESCENDING"] = "降序"
L["DISABLED"] = "已停用"
L["Disease"] = "疾病"
L["Disoriented"] = "困惑"
L["DOMAIN_GLOBAL"] = "|cff00c300共用|r"
L["DOMAIN_PROFILE"] = "角色設定檔"
L["DOWN"] = "下"
L["DR-Disorient"] = "迷惑/其他"
L["DR-Incapacitate"] = "癱瘓"
L["DR-Root"] = "定身"
L["DR-Silence"] = "沉默"
L["DR-Stun"] = "擊暈"
L["DR-Taunt"] = "嘲諷"
L["DT_DOC_AuraSource"] = "返回圖示檢查的增益/減益的來源單位。最好同[Name]標籤一起使用。 （此標籤僅能用於圖示類型：%s）。"
L["DT_DOC_Counter"] = "返回TellMeWhen計數器的值。圖示通知資訊會創建或修改計數器。"
L["DT_DOC_Destination"] = "返回圖示最後一次處理過的戰鬥事件中的目標單位或名稱。同[Name]標籤一起使用效果更佳。（此標籤僅可用於圖示類型%s）"
L["DT_DOC_Duration"] = "返回圖示當前的剩餘持續時間。推薦你使用[TMWFormatDuration]。"
L["DT_DOC_Extra"] = "返回圖示最後一次處理過的戰鬥事件中的額外法術名稱。（此標籤僅可用於圖示類型%s）"
L["DT_DOC_gsub"] = [=[提供強大的Lua函式string.gsub來處理DogTags輸出的字串。

替換當前值在匹配模式中的所有實例，可使用可選參數限制替換數目。]=]
L["DT_DOC_IsShown"] = "返回一個圖示是否顯示。"
L["DT_DOC_LocType"] = "返回圖示所顯示的失去控制的效果類型（此標籤僅可用於圖示類型%s）。"
L["DT_DOC_MaxDuration"] = "返回當前圖標的最大持續時間。 這個持續時間是指剛開始時的持續時間，不是當前剩余的持續時間。"
L["DT_DOC_Name"] = "返回單位的名稱。這是一個由DogTag提供的預設[Name]標籤的加強版本。"
L["DT_DOC_Opacity"] = "返回一個圖示的可視度。返回值為0和1之間的數字。"
L["DT_DOC_PreviousUnit"] = "返回圖示所檢查的上一個單位或單位名稱（相對於與當前檢查單位來講）。同[Name]標籤一起使用效果更佳。"
L["DT_DOC_Source"] = "返回圖示最後一次處理過的戰鬥事件中的來源單位或名稱。同[Name]標籤一起使用效果更佳。 （此標籤僅可用於圖示類型%s）"
L["DT_DOC_Spell"] = "返回圖示當前所顯示數據的法術名稱或物品名稱。"
L["DT_DOC_Stacks"] = "返回圖示當前的堆疊數量"
L["DT_DOC_strfind"] = [=[提供強大的Lua函式string.find來處理DogTags輸出的字串。

返回當前值中從第幾位開始出現的第一次匹配的具體位置。]=]
L["DT_DOC_StripServer"] = "從單位名字移除伺服器名稱。這將會移除名字的破折號之後的所有文字。"
L["DT_DOC_Timer"] = "返回TellMeWhen計時器的數值。計時器一般在圖示的通知事件中被創建或更改。"
L["DT_DOC_TMWFormatDuration"] = "返回一个由TellMeWhen的時間格式處理過的字串。用於替代[FormatDuration]。"
L["DT_DOC_Unit"] = "返回當前圖示所檢查的單位或單位名稱。同[Name]標籤一起使用效果更佳。"
L["DT_DOC_Value"] = "返回圖示當前顯示的數字，此功能僅在小部分圖示類型使用。"
L["DT_DOC_ValueMax"] = "返回圖示當前顯示的數字的初始最大值，此功能僅在小部分圖示類型使用。"
L["DT_INSERTGUID_GENERIC_DESC"] = "如果你想要在一個圖示上顯示另外一個圖示的資訊，可以 |cff7fffffShift+滑鼠點擊|r那個圖示將它的唯一識別碼添加到標籤參數icon中即可。"
L["DT_INSERTGUID_TOOLTIP"] = "|cff7fffffShift+滑鼠點擊|r將這個圖示的識別碼插入到DogTag。"
L["DURATION"] = "持續時間"
L["DURATIONALPHA_DESC"] = "設定在你要求的持續時間不符合時圖示顯示的可視度。"
L["DURATIONPANEL_TITLE2"] = "持續時間限定"
L["EARTH"] = "大地圖騰"
L["ECLIPSE_DIRECTION"] = "蝕星蔽月方向"
L["elite"] = "精英"
L["ENABLINGOPT"] = "TellMeWhen選項已停用。正在重新啟用中……"
L["ENCOUNTERTOCHECK"] = "用於檢查的首領戰"
L["ENCOUNTERTOCHECK_DESC_BIGWIGS"] = "輸入首領戰的全名。在BigWig的設定跟地城手冊中都有顯示。"
L["ENCOUNTERTOCHECK_DESC_DBM"] = "輸入首領戰的全名。在聊天的拉怪、團滅、殺死或者在地下城手冊中有顯示。"
L["Enraged"] = "狂暴"
L["EQUIPSETTOCHECK"] = "用於檢查的套裝名稱（|cFFFF5959區分大小寫|r）"
L["ERROR_ACTION_DENIED_IN_LOCKDOWN"] = "無法在戰鬥中這麼做，請先啟用%q選項（輸入'/tmw options'或'/tmw 選項'）。"
L["ERROR_ANCHOR_CYCLICALDEPS"] = "%s嘗試依附到%s，但是%s的位置依賴於%s的位置，為了防止出錯TellMeWhen會將它重設到熒幕的中央。"
L["ERROR_ANCHORSELF"] = "%s嘗試依附於它自己，所以TellMeWhen會重設它的依附位置到螢幕中間以防止出現嚴重的錯誤。"
L["ERROR_INVALID_SPELLID2"] = "一個圖示正在檢查一個無效的法術ID：%s。 為免圖示發生錯誤，請移除它!"
L["ERROR_MISSINGFILE"] = "TellMeWhen需要在重開魔獸世界之後才能正常使用 %s （原因：無法找到%s）。 你要馬上重開魔獸世界嗎？"
L["ERROR_MISSINGFILE_NOREQ"] = "TellMeWhen需要在重開魔獸世界之後才能完全正常使用 %s （原因：無法找到%s）。 你要馬上重開魔獸世界嗎？"
L["ERROR_MISSINGFILE_OPT"] = [=[需要在重開魔獸世界之後才能設定TellMeWhen %s。

原因：無法找到%s。

你要馬上重開魔獸世界嗎？]=]
L["ERROR_MISSINGFILE_OPT_NOREQ"] = [=[可能需要在重開魔獸世界之後才能全面設定TellMeWhen %s。

原因：無法找到%s。

你要馬上重開魔獸世界嗎？]=]
L["ERROR_MISSINGFILE_REQFILE"] = "一個必需的檔案"
L["ERROR_NO_LOCKTOGGLE_IN_LOCKDOWN"] = "無法在戰鬥中解鎖TellMeWhen，請先啟用%q選項（輸入'/tmw options'或'/tmw 選項'）。"
L["ERROR_NOTINITIALIZED_NO_ACTION"] = "插件初始化失敗，TellMeWhen不能執行該步驟。 "
L["ERROR_NOTINITIALIZED_NO_LOAD"] = "插件初始化失敗，TellMeWhen_Options無法載入。"
L["ERROR_NOTINITIALIZED_OPT_NO_ACTION"] = "如果插件初始化失敗，TellMeWhen_Options將無法執行該動作！"
L["ERRORS_FRAME"] = "錯誤訊息框架"
L["ERRORS_FRAME_DESC"] = "輸出文字到系統的錯誤訊息框架，就是顯示%q的那個位置。"
L["EVENT_CATEGORY_CHANGED"] = "數據已改變"
L["EVENT_CATEGORY_CHARGES"] = "充能"
L["EVENT_CATEGORY_CLICK"] = "行為"
L["EVENT_CATEGORY_CONDITION"] = "條件"
L["EVENT_CATEGORY_MISC"] = "其他"
L["EVENT_CATEGORY_STACKS"] = "疊加層數"
L["EVENT_CATEGORY_TIMER"] = "計時器"
L["EVENT_CATEGORY_VISIBILITY"] = "顯示"
L["EVENT_FREQUENCY"] = "觸發頻率"
L["EVENT_FREQUENCY_DESC"] = "設定條件通過的觸發頻率（單位為秒）。"
L["EVENT_WHILECONDITIONS"] = "觸發條件"
L["EVENT_WHILECONDITIONS_DESC"] = "點擊設定條件，當它們通過時會觸發通知事件。"
L["EVENT_WHILECONDITIONS_TAB_DESC"] = "設定觸發通知事件需要的條件。"
L["EVENTCONDITIONS"] = "事件條件"
L["EVENTCONDITIONS_DESC"] = "點擊進入設定用於觸發此事件的條件。"
L["EVENTCONDITIONS_TAB_DESC"] = "設定的條件通過時則觸發此事件。"
L["EVENTHANDLER_COUNTER_TAB"] = "計數器"
L["EVENTHANDLER_COUNTER_TAB_DESC"] = "設定一個計數器。此計數器可用於條件中檢查或DogTags標籤中顯示文字。"
L["EVENTHANDLER_LUA_CODE"] = "用於執行的Lua程式碼"
L["EVENTHANDLER_LUA_CODE_DESC"] = "在此輸入事件觸發後需要執行的Lua程式碼"
L["EVENTHANDLER_LUA_LUA"] = "Lua"
L["EVENTHANDLER_LUA_LUAEVENTf"] = "Lua事件：%s"
L["EVENTHANDLER_LUA_TAB"] = "Lua（進階）"
L["EVENTHANDLER_LUA_TAB_DESC"] = "設定用於執行的Lua腳本。這是一個進階功能，需要有Lua語言編程基礎。"
L["EVENTHANDLER_TIMER_TAB"] = "計時器"
L["EVENTHANDLER_TIMER_TAB_DESC"] = "設置一個時鐘樣式的計時器。此計時器可以使用條件及顯示文字到DogTags。"
L["EVENTS_CHANGETRIGGER"] = "更改觸發器"
L["EVENTS_CHOOSE_EVENT"] = "選擇觸發器："
L["EVENTS_CHOOSE_HANDLER"] = "選擇通知事件："
L["EVENTS_CLONEHANDLER"] = "複製"
L["EVENTS_HANDLER_ADD_DESC"] = "|cff7fffff點擊：|r添加這個通知事件。"
L["EVENTS_HANDLERS_ADD"] = "新增通知事件……"
L["EVENTS_HANDLERS_ADD_DESC"] = "|cff7fffff點擊|r選擇一個通知事件新增到此圖示。"
L["EVENTS_HANDLERS_GLOBAL_DESC"] = [=[|cff7fffff點擊：|r開啟通知事件設定選項。
|cff7fffff右鍵點擊|r複製或更改事件的觸發。
|cff7fffff點擊並拖拽|r來變更排序。]=]
L["EVENTS_HANDLERS_HEADER"] = "通知事件處理器"
L["EVENTS_HANDLERS_PLAY"] = "測試通知事件"
L["EVENTS_HANDLERS_PLAY_DESC"] = "|cff7fffff點擊：|r測試通知事件"
L["EVENTS_SETTINGS_CNDTJUSTPASSED"] = "僅在條件剛通過時"
L["EVENTS_SETTINGS_CNDTJUSTPASSED_DESC"] = "除非上面設定的條件剛剛成功通過，否則阻止通知事件的觸發。"
L["EVENTS_SETTINGS_COUNTER_AMOUNT"] = "值"
L["EVENTS_SETTINGS_COUNTER_AMOUNT_DESC"] = "輸入你希望檢查的計數器被創建或修改的值。"
L["EVENTS_SETTINGS_COUNTER_HEADER"] = "計數器設定"
L["EVENTS_SETTINGS_COUNTER_NAME"] = "計數器名稱"
L["EVENTS_SETTINGS_COUNTER_NAME_DESC"] = [=[輸入計數器的名稱。如果計數器不存在，它的預設值則為0。

計數器名稱必須為小寫，並且不能有空格。

你也可以在其它地方檢查這個計數器，在條件檢查或DogTags的文字顯示標籤[Counter]中。

進階玩家：計數器保存在TMW.COUNTERS[counterName] = value中。如果你想在自訂Lua語言腳本中更改一個計數器，可調用TMW:Fire( "TMW_COUNTER_MODIFIED"， counterName )。]=]
L["EVENTS_SETTINGS_COUNTER_OP"] = "運算符"
L["EVENTS_SETTINGS_COUNTER_OP_DESC"] = "選擇計數器要執行的運算符"
L["EVENTS_SETTINGS_HEADER"] = "触发設定"
L["EVENTS_SETTINGS_ONLYSHOWN"] = "僅在圖示顯示時觸發"
L["EVENTS_SETTINGS_ONLYSHOWN_DESC"] = "勾選此項防止圖示在沒有顯示時觸發相關通知事件。"
L["EVENTS_SETTINGS_PASSINGCNDT"] = "僅在條件通過時觸發："
L["EVENTS_SETTINGS_PASSINGCNDT_DESC"] = "除非下面設定的條件成功通過，否則阻止通知事件的觸發。"
L["EVENTS_SETTINGS_PASSTHROUGH"] = "允許觸發其他事件"
L["EVENTS_SETTINGS_PASSTHROUGH_DESC"] = [=[勾選允許在觸發該通知事件後去觸發另一個通知事件，如果不勾選，則在該事件觸發並輸出了文字/音效之後，圖示將不再處理同時觸發的其他任何通知事件。

可以有例外，詳情請參閱個別事件的描述。]=]
L["EVENTS_SETTINGS_SIMPLYSHOWN"] = "僅在圖示顯示時觸發"
L["EVENTS_SETTINGS_SIMPLYSHOWN_DESC"] = [=[讓通知事件在圖示顯示時觸發。

你可以在不設定條件的情況下啟用此選項來觸發事件。

或者你也可以加上條件來決定如何觸發。]=]
L["EVENTS_SETTINGS_TIMER_HEADER"] = "計時器設定"
L["EVENTS_SETTINGS_TIMER_NAME"] = "計時器名稱"
L["EVENTS_SETTINGS_TIMER_NAME_DESC"] = [=[輸入你需要修改的計時器名稱。

計時器名稱必須為小寫字母並且不能有空格。

此計時器使用的名稱可以在其它任何地方來檢測（條件和文字顯示，像是DogTag中的[Timer]）]=]
L["EVENTS_SETTINGS_TIMER_OP_DESC"] = "選擇你想要計時器使用的運算符"
L["EVENTS_TAB"] = "通知事件"
L["EVENTS_TAB_DESC"] = "設定聲音/文字輸出/動畫的觸發器。"
L["EXPORT_ALLGLOBALGROUPS"] = "所有|cff00c300共用|r群組"
L["EXPORT_f"] = "匯出 %s"
L["EXPORT_HEADING"] = "匯出"
L["EXPORT_SPECIALDESC2"] = "其他TellMeWhen使用者只能在他們所用的版本等於或高於%s時才可匯入這些數據。"
L["EXPORT_TOCOMM"] = "到玩家"
L["EXPORT_TOCOMM_DESC"] = [=[輸入一個玩家的名字到編輯框同時選擇此選項來發送數據給他們。他們必須是你能密語的某人（同陣營，同伺服器，在線），同時他們必須已經安裝版本為4.0.0+的TellMeWhen。

你還可以輸入"GUILD"或"RAID"發送到整個公會或整個團隊（輸入時請注意區分大小寫，'GUILD'跟'RAID'中的英文字母全部都是大寫）。]=]
L["EXPORT_TOGUILD"] = "到公會"
L["EXPORT_TORAID"] = "到團隊"
L["EXPORT_TOSTRING"] = "到字串"
L["EXPORT_TOSTRING_DESC"] = "包含必要數據的字串將匯出到編輯框裡，按下CTRL+C複製它，然後到任何你想分享的地方貼上它。"
L["FALSE"] = "否"
L["fCODESNIPPET"] = "程式碼片段：%s"
L["Feared"] = "恐懼"
L["fGROUP"] = "群組：%s"
L["fGROUPS"] = "群組：%s"
L["fICON"] = "圖示：%s"
L["FIRE"] = "火焰圖騰"
L["FONTCOLOR"] = "文字顏色"
L["FONTSIZE"] = "字體大小"
L["FORWARDS_IE"] = "轉到下一個"
L["FORWARDS_IE_DESC"] = [=[載入下一個編輯過的圖示

%s |T%s:0|t.]=]
L["fPROFILE"] = "設定檔：%s"
L["FROMNEWERVERSION"] = "你匯入的數據為版本較新的TellMeWhen所創建，某些設定在更新至最新版本之前可能無法正常使用。"
L["fTEXTLAYOUT"] = "文字顯示樣式：%s"
L["GCD"] = "公共冷卻"
L["GCD_ACTIVE"] = "公共冷卻作用中"
L["GENERIC_NUMREQ_CHECK_DESC"] = "勾選以啟用並設定%s"
L["GENERICTOTEM"] = "圖騰 %d"
L["GLOBAL_GROUP_GENERIC_DESC"] = "|cff00c300共用群組|r是指在你這個魔獸世界帳號中的TellMeWhen設定檔的所有角色都可共同使用的群組。"
L["GLYPHTOCHECK"] = "要檢查的雕紋"
L["GROUP"] = "組"
L["GROUP_UNAVAILABLE"] = "|TInterface/PaperDollInfoFrame/UI-GearManager-LeaveItem-Transparent:20|t 由於其過度限制的規範/角色設置，此組無法顯示。"
L["GROUPCONDITIONS"] = "群組條件"
L["GROUPCONDITIONS_DESC"] = "設定條件進行微調，以便更好的顯示這個群組。"
L["GROUPICON"] = "群組：%s，圖示：%s"
L["GROUPSELECT_TOOLTIP"] = [=[|cff7fffff點擊|r 來編輯。

|cff7fffff點擊拖拽|r 重新排序或更改域。]=]
L["GROUPSETTINGS_DESC"] = "設定此群組。"
L["GUIDCONFLICT_DESC_PART1"] = [=[TellMeWhen檢測到下列的物件擁有相同的全域唯一識別碼（GUID）。如果你從它們其中之一調用數據可能會發生料想不到問題（例如：將它們之中的一個加入到整合圖示中）。

為了解決這個問題，請選擇某個物件重新生成GUID，原有的調用都將指向到那個沒有重新生成GUID的物件。你可能需要適當調整設定才能確保所有功能都可正常使用。]=]
L["GUIDCONFLICT_DESC_PART2"] = "你也可以自行解決這個問題（例如：刪除兩個之中的某一個）。"
L["GUIDCONFLICT_IGNOREFORSESSION"] = "忽略此設定會話衝突。"
L["GUIDCONFLICT_REGENERATE"] = "為%s重新生成GUID"
L["Heals"] = "玩家治療法術"
L["HELP_ANN_LINK_INSERTED"] = [=[你插入的連結看起來很詭異，可能是因為DogTag的格式轉換所引起。

如果輸出到暴雪頻道時連結無法正常顯示，請更改顏色代碼。]=]
L["HELP_BUFF_NOSOURCERPPM"] = [=[看來你想檢查%s，這個增益使用了RPPM系統。

由於暴雪的bug，在啟用了%q選項時，這個增益無法被檢測。

如果你想正確檢測這個增益，請禁用該設定。]=]
L["HELP_CNDT_ANDOR_FIRSTSEE"] = [=[你可以選擇兩個條件都需要通過，還是只需要某個條件通過。

|cff7fffff點擊|r此處更改條件之間的關聯方式，以達到你所需的檢查效果。]=]
L["HELP_CNDT_PARENTHESES_FIRSTSEE"] = [=[你可以組合多個條件執行複雜的檢查功能，尤其是連同%q選項一起使用。

|cff7fffff點擊|r括號將條件組合在一起，以達到你需要的檢查效果（左右括號中間的條件就是一個條件組合）。]=]
L["HELP_COOLDOWN_VOIDBOLT"] = [=[看起來你是想檢測|TInterface/Icons/ability_ironmaidens_convulsiveshadows:20|t %s的冷卻時間。

非常不幸的是暴雪的機制使它無法正常被監測到。

你需要檢測的是 |T1386548:20|t %s 的冷卻時間。

請添加一個條件檢測增益 %s ，如果你僅僅是想檢測 %s 是否可以使用的話。]=]
L["HELP_EXPORT_DOCOPY_MAC"] = "按下|cff7fffffCMD+C|r複製"
L["HELP_EXPORT_DOCOPY_WIN"] = "按下|cff7fffffCTRL+C|r複製"
L["HELP_EXPORT_MULTIPLE_COMM"] = "匯出的數據包括主要數據所需要的額外數據。想要知道包含了哪些內容，請匯出相同數據到字串後在匯入選單的「來自字串」查看即可。"
L["HELP_EXPORT_MULTIPLE_STRING"] = [=[匯出的數據包括主要數據所需要的額外數據。想要知道包含了哪些內容，請匯出相同數據到字串後在匯入選單的「來自字串」查看即可。

TellMeWhen版本7.0.0+的使用者可以一次匯入所有數據。其他人需要分開多次匯入字串。]=]
L["HELP_FIRSTUCD"] = [=[這是你第一次使用一個採取特定時間語法的圖示類型！
在添加法術到某些圖示類型的 %q 編輯框時，必須使用下列語法在法術後面指定它們的冷卻時間/持續時間：

法術:時間

例如：

「%s:120」
「%s:10; %s:24」
「%s:180」
「%s:3:00」
「62618:3:00」

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間（譯者註：自動添加時間功能支援提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術，如果一個法術同時存在上述兩種時間，會優先選擇添加冷卻時間，假如自動添加的時間不正確，請自行手動變更）。]=]
L["HELP_IMPORT_CURRENTPROFILE"] = [=[嘗試在這個設定檔中移動或複制一個圖示到另外一個圖示格位嗎？

你可以輕鬆的做到這一點，使用|cff7fffff右鍵點擊圖示並拖拽|r它到另外一個圖示格位（這個過程需要按下右鍵不放開）。 當你放開右鍵時，會出現一個有很多選項的選單。

嘗試拖拽一個圖示到整合圖示，其他群組，或在你螢幕上的其他框架以獲取其他相應的選項。]=]
L["HELP_MISSINGDURS"] = [=[以下法術缺少持續時間/冷卻時間：

%s

請使用下列語法添加時間：

法術:時間

例如：「%s:10」。

用建議列表插入條目時會自動添加在滑鼠提示資訊中顯示的時間（譯者註：自動添加時間功能支援提示資訊中有顯示冷卻時間的法術以及提示資訊中有註明持續時間的大部分法術，如果一個法術同時存在上述兩種時間，會優先選擇添加冷卻時間，假如自動添加的時間不正確，請自行手動變更）。]=]
L["HELP_NOUNIT"] = "你必須輸入一個單位!"
L["HELP_NOUNITS"] = "你至少需要輸入一個單位!"
L["HELP_ONLYONEUNIT"] = "條件只允許檢查一個單位，你已經輸入了%d個單位。"
L["HELP_POCKETWATCH"] = [=[|TInterface\Icons\INV_Misc_PocketWatch_01:20|t -- 關於懷錶材質

此材質用於第一個檢測到的有效法術在你的法術書中不存在時。

正確的材質將會在你施放過一次或者見到過一次該法術之後使用。

若要顯示正確的材質，請把第一個被檢查的法術名稱變更為法術ID。你可以輕鬆的做到這一點，你只需要點擊名稱編輯框中的法術，再根據之後出現的建議列表中顯示的正確的以及相對應的法術上點擊右鍵即可。

（這裡的法術指排在首位的法術，當你的滑鼠移動到建議列表的某個法術上時，在提示資訊中可以看到更為具體的 滑鼠左右鍵插入法術ID或法術名稱的方法。）]=]
L["HELP_SCROLLBAR_DROPDOWN"] = [=[一些TellMeWhen的下拉選單有捲動條。

你可以拖動捲動條來查看選單的全部內容。

你也可以使用滑鼠滾輪。]=]
L["ICON"] = "圖示"
L["ICON_TOOLTIP_CONTROLLED"] = "此圖示被這群組的第一個圖示接管。你不能單獨修改它。"
L["ICON_TOOLTIP_CONTROLLER"] = "此圖示具有群組控制功能。"
L["ICON_TOOLTIP2NEW"] = [=[|cff7fffff點擊右鍵|r進入圖示設定。
|cff7fffff點擊右鍵並拖拽|r 複製/移動 到另一個圖示。
|cff7fffff拖拽|r法術或物品到圖示來快速設定。]=]
L["ICON_TOOLTIP2NEWSHORT"] = "|cff7fffff點擊右鍵|r進入圖示設定。"
L["ICONALPHAPANEL_FAKEHIDDEN"] = "總是隱藏"
L["ICONALPHAPANEL_FAKEHIDDEN_DESC"] = [=[強制隱藏此圖示，但保持它其他的正常功能。

|cff7fffff-|r 此圖示依然可以通過其他圖示的條件進行檢查。
|cff7fffff-|r 整合圖示可以包含並顯示此圖示。
|cff7fffff-|r 此圖示的通知仍正常運作。]=]
L["ICONCONDITIONS_DESC"] = "設定條件進行微調，以便更好的顯示這個圖示。"
L["ICONGROUP"] = "圖示：%s （群組：%s）"
L["ICONMENU_ABSENT"] = "缺少"
L["ICONMENU_ABSENTEACH"] = "沒有施法的單位"
L["ICONMENU_ABSENTEACH_DESC"] = [=[設置單位沒有任何施法時的圖標透明度。

如果此選項未設置成隱藏並且檢測到有一個單位存在時，%s選項不會運作。]=]
L["ICONMENU_ABSENTONALL"] = "全都缺少"
L["ICONMENU_ABSENTONALL_DESC"] = "設定在檢查的所有單位中不存在任何一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_ABSENTONANY"] = "任一缺少"
L["ICONMENU_ABSENTONANY_DESC"] = "設定在檢查的所有單位中只要其中之一不存在任何一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_ADDMETA"] = "添加到'整合圖示'"
L["ICONMENU_ALLOWGCD"] = "允許公共冷卻"
L["ICONMENU_ALLOWGCD_DESC"] = "勾選此項允許冷卻時鐘顯示公共冷卻，而不是忽略它。"
L["ICONMENU_ALLSPELLS"] = "所有法術技能可用"
L["ICONMENU_ALLSPELLS_DESC"] = "當此圖標正在跟蹤的所有法術准備好在特定單位上時，此狀態處於活動狀態。"
L["ICONMENU_ANCHORTO"] = "依附於 %s"
L["ICONMENU_ANCHORTO_DESC"] = [=[依附%s於%s，無論%s如何移動，%s都會跟隨它一起移動。

群組選項中有進階依附設定。]=]
L["ICONMENU_ANCHORTO_UIPARENT"] = "重設依附"
L["ICONMENU_ANCHORTO_UIPARENT_DESC"] = [=[讓%s重新依附於你的螢幕（UIParent）。 它目前依附於%s。

群組選項中有進階依附設定。]=]
L["ICONMENU_ANYSPELLS"] = "任意法術技能可用"
L["ICONMENU_ANYSPELLS_DESC"] = "當被該圖標跟蹤的法術中的至少一個准備好在特定單元上時，該狀態是活動的。"
L["ICONMENU_APPENDCONDT"] = "添加到'圖示顯示'條件"
L["ICONMENU_BAR_COLOR_BACKDROP"] = "背景顏色/可見度"
L["ICONMENU_BAR_COLOR_BACKDROP_DESC"] = "設定計量條後的背景顏色和可見度。"
L["ICONMENU_BAR_COLOR_COMPLETE"] = "完成顏色"
L["ICONMENU_BAR_COLOR_COMPLETE_DESC"] = "計量條在冷卻、持續時間完成時的顏色。"
L["ICONMENU_BAR_COLOR_MIDDLE"] = "過半顏色"
L["ICONMENU_BAR_COLOR_MIDDLE_DESC"] = "計量條在冷卻、持續時間過半時的顏色。"
L["ICONMENU_BAR_COLOR_START"] = "起始顏色"
L["ICONMENU_BAR_COLOR_START_DESC"] = "計量條在冷卻、持續時間起始時的顏色。"
L["ICONMENU_BAROFFS"] = [=[此數值將會添加到計量條以便用來調整它的位移值。

一些有用的例子：
當你開始施法時防止一個增益消失的自訂指示器，或者用來指示某個法術施放所需能量的同時還剩多少時間可以中斷施法。]=]
L["ICONMENU_BOTH"] = "任意一種"
L["ICONMENU_BUFF"] = "增益"
L["ICONMENU_BUFFCHECK"] = "增益/減益檢查"
L["ICONMENU_BUFFCHECK_DESC"] = [=[檢查你所設定的單位是否缺少某個增益。

可使用這個圖示類型來檢查缺少的團隊增益（像是耐力之類）。

其他情況應使用圖示類型%q。]=]
L["ICONMENU_BUFFDEBUFF"] = "增益/減益"
L["ICONMENU_BUFFDEBUFF_DESC"] = "檢查增益或減益。"
L["ICONMENU_BUFFTYPE"] = "增益或減益"
L["ICONMENU_CAST"] = "法術施放"
L["ICONMENU_CAST_DESC"] = "檢查非瞬發施法和引導法術。"
L["ICONMENU_CHECKNEXT"] = "擴展子元"
L["ICONMENU_CHECKNEXT_DESC"] = [=[選中此框該圖示將檢查添加在列表中的任意整合圖示所包含的全部圖示，它可能是任何級別的檢查。

此外，該圖示不會顯示已經在另一個整合圖示顯示的任何圖示。

譯者註：因為很多人不明白這個功能，舉個例子，假設你有3個設定完全一樣的整合圖示（每個圖示中都是圖示1 圖示2 圖示3），全部都勾上了這個選項，如果整合圖示中，圖示1 圖示2 圖示3都可以顯示，並且顯示排序為 圖示3>圖示1>圖示2，那麼在整合圖示1將會顯示圖示3，整合圖示2則是顯示圖示1，整合圖示3顯示圖示2（理論上就是這樣的效果，具體的細節請自行發掘）。]=]
L["ICONMENU_CHECKREFRESH"] = "法術刷新偵測"
L["ICONMENU_CHECKREFRESH_DESC"] = [=[暴雪的戰鬥記錄在涉及法術刷新和恐懼（或者某些在造成一定傷害量後才會中斷的法術）存在嚴重缺陷，戰鬥記錄會認為法術在造成傷害時已經刷新，儘管事實上並非如此。

取消此選項以便停用法術刷新偵測，注意：正常的刷新也將被忽略。 

如果你檢查的遞減在造成一定傷害量後不會中斷的話建議保留此選項。]=]
L["ICONMENU_CHOOSENAME_EVENTS"] = "選擇用於檢查的訊息"
L["ICONMENU_CHOOSENAME_EVENTS_DESC"] = [=[輸入你想要圖示檢查的錯誤訊息。你可以利用';'（分號）輸入多個條目。

錯誤訊息必須完全匹配，不區分大小寫。]=]
L["ICONMENU_CHOOSENAME_ITEMSLOT_DESC"] = [=[輸入你想要此圖示監視的名稱/ID/裝備欄位編號。 你可以利用分號添加多個條目（名稱/ID/裝備欄位編號的任意組合）。

裝備欄位編號是已裝備物品所在欄位的編號索引。即使你更換了那個裝備欄位的已裝備物品，也不會影響圖示的正常使用。

你可以|cff7fffff按住Shift再按左鍵點選|r物品/聊天連結或者拖拽物品添加到此編輯框中。]=]
L["ICONMENU_CHOOSENAME_ORBLANK"] = "或者保留空白檢查所有"
L["ICONMENU_CHOOSENAME_WPNENCH_DESC"] = [=[輸入你想要此圖示監視的暫時性武器附魔的名稱。 你可以利用分號（;）添加多個條目。

|cFFFF5959重要提示|r：附魔名稱必須使用在暫時性武器附魔激活時出現在武器的提示資訊中的那個名稱（例如：「%s」， 而不是「%s」）。]=]
L["ICONMENU_CHOOSENAME3"] = "監視什麼"
L["ICONMENU_CHOSEICONTODRAGTO"] = "選擇一個圖示拖拽到："
L["ICONMENU_CHOSEICONTOEDIT"] = "選擇一個圖示來修改："
L["ICONMENU_CLEU"] = "戰鬥事件"
L["ICONMENU_CLEU_DESC"] = [=[檢查戰鬥事件。

例如：法術被反射，未命中，瞬發施法以及死亡等等。
實際上此圖示類型可以檢查所有的戰鬥事件（包括上述的例子以及其他沒有提到的戰鬥事件）。]=]
L["ICONMENU_CLEU_NOREFRESH"] = "不刷新"
L["ICONMENU_CLEU_NOREFRESH_DESC"] = "勾選後在圖示的計時器作用時不會再觸發事件。"
L["ICONMENU_CNDTIC"] = "條件圖示"
L["ICONMENU_CNDTIC_DESC"] = "檢查條件的狀態。"
L["ICONMENU_CNDTIC_ICONMENUTOOLTIP"] = "（%d個條件）"
L["ICONMENU_COMPONENTICONS"] = "元件圖示&群組"
L["ICONMENU_COOLDOWNCHECK"] = "冷卻檢查"
L["ICONMENU_COOLDOWNCHECK_DESC"] = "勾選此項啟用當可用技能在冷卻中時視為不可用。"
L["ICONMENU_COPYCONDITIONS"] = "複製 %d 個條件"
L["ICONMENU_COPYCONDITIONS_DESC"] = "複製%s的%d個條件到%s。"
L["ICONMENU_COPYCONDITIONS_DESC_OVERWRITE"] = "這將會覆寫已存在的%d個條件。"
L["ICONMENU_COPYCONDITIONS_GROUP"] = "複製%d個群組條件"
L["ICONMENU_COPYEVENTHANDLERS"] = "複製 %d 個通知事件"
L["ICONMENU_COPYEVENTHANDLERS_DESC"] = "複製%s的%d個通知事件到%s。"
L["ICONMENU_COPYHERE"] = "複製到此"
L["ICONMENU_COUNTING"] = "倒數中"
L["ICONMENU_CTRLGROUP"] = "群組控制圖示"
L["ICONMENU_CTRLGROUP_DESC"] = [=[啟用此選項讓這個圖示控制整個群組。

如果啟用，將使用這個圖示的數據填充這個群組。

該群組中的其他圖示都不能進行單獨設定。

當你需要快速定制群組的佈局、樣式或者排列選項，可以選擇使用它控制群組。]=]
L["ICONMENU_CTRLGROUP_UNAVAILABLE_DESC"] = "當前圖示類型不能控制整個群組。"
L["ICONMENU_CTRLGROUP_UNAVAILABLEID_DESC"] = "只有組中的第一個圖標（圖標ID 1）可以是組控制器。"
L["ICONMENU_CUSTOMTEX"] = "自訂圖示材質"
L["ICONMENU_CUSTOMTEX_DESC"] = [=[你可以使用下列方法更改這個圖示的顯示材質：

|cff00d1ff法術材質|r
輸入你希望顯示的法術名稱或法術ID。

|cff00d1ff其他暴雪材質|r
你可以輸入一個材質路徑，例如'Interface/Icons/spell_nature_healingtouch'， 假如材質路徑為'Interface/Icons'可以只輸入'spell_nature_healingtouch'。

|cff00d1ff空白（透明無材質）|r
輸入none或blank圖示將透明顯示，不再使用任何材質。

|cff00d1ff物品欄|r
你可以在此編輯框輸入"$"（美元符號，或稱錢幣符號）檢視一個動態材質列表。

|cff00d1ff自訂材質|r
你也能使用放在WoW子資料夾下的自訂材質（請在該欄位輸入材質的相對路徑，如：「tmw/ccc.tga」），僅支援尺寸為2的N次方（32， 64， 128，等）並且類型為.tga和.blp的材質檔案。]=]
L["ICONMENU_CUSTOMTEX_MOPAPPEND_DESC"] = [=[|cff00d1ff錯誤解決|r
|TNULL:0|t在自訂了某個材質後但是圖示顯示成綠色的話，請往下看可能發生的兩種可能性，如果材質在WOW主目錄（跟WOW.exe同一個目錄）下，請把材質移動到某個子目錄（珍愛生命，遠離WOW.exe）去即可正常使用（請關閉WOW之後再執行上述步驟），如果你是使用某個特定的法術作為材質，那可能是因為暴雪移除或者修改了它們（原來的名稱或ID已經不存在），請重新輸入另一個你要用於自訂材質的法術名稱或法術ID。]=]
L["ICONMENU_DEBUFF"] = "減益"
L["ICONMENU_DISPEL"] = "驅散類型"
L["ICONMENU_DONTREFRESH"] = "不刷新"
L["ICONMENU_DONTREFRESH_DESC"] = "勾選此項在圖示仍然倒數的時候觸發效果將強制不重置冷卻時間。"
L["ICONMENU_DOTWATCH"] = "所有單位的增益/減益"
L["ICONMENU_DOTWATCH_AURASFOUND_DESC"] = "設定圖示在被檢查的任意單位有任意增益/減益時的可見度。"
L["ICONMENU_DOTWATCH_DESC"] = [=[嘗試檢查你所選的所有單位的增益、減益。

在檢查多個法術效果時比較有用。

這個圖示類型必須使用群組控制器- 它不能是一個單獨圖示。]=]
L["ICONMENU_DOTWATCH_GCREQ"] = "必須為群組控制器"
L["ICONMENU_DOTWATCH_GCREQ_DESC"] = [=[此圖示類型必須使用群組控制器來運作。你不能單獨使用它。

請創建一個圖示並且設定為群組控制器，他必須是群組中第一個圖示（例如，他的圖示ID為1），再啟用%q選項，它在勾選框%q附近。]=]
L["ICONMENU_DOTWATCH_NOFOUND_DESC"] = "設定在無法找到被檢查的增益/減益時圖示的可見度。"
L["ICONMENU_DR"] = "遞減"
L["ICONMENU_DR_DESC"] = "檢查遞減程度跟遞減時間。"
L["ICONMENU_DRABSENT"] = "未遞減"
L["ICONMENU_DRPRESENT"] = "已遞減"
L["ICONMENU_DRS"] = "遞減"
L["ICONMENU_DURATION_MAX_DESC"] = "允許圖示顯示的最大持續時間，高於此數值圖示將被隱藏。"
L["ICONMENU_DURATION_MIN_DESC"] = "顯示圖示所需的最小持續時間，低於此數值圖示將被隱藏。"
L["ICONMENU_ENABLE"] = "啟用"
L["ICONMENU_ENABLE_DESC"] = "圖示需要啟用後才會起作用。"
L["ICONMENU_ENABLE_GROUP_DESC"] = "分組在啟用時才會正常運作。"
L["ICONMENU_ENABLE_PROFILE"] = "對角色啟用"
L["ICONMENU_ENABLE_PROFILE_DESC"] = "取消勾選禁止這個角色使用|cff00c300公共|r分組。"
L["ICONMENU_FAIL2"] = "條件無效"
L["ICONMENU_FAKEMAX"] = "偽最大值"
L["ICONMENU_FAKEMAX_DESC"] = [=[設定計時器的偽最大值。

你可以使用此設定讓整組圖示以相同的速度進行倒計時。可以讓你更清楚的看到哪些計時器先結束。

設定為0則禁用此選項。

譯者註：如果你設定為20， 那TellMeWhen顯示的計時條的總長度將變成20秒，但是並不影響你實際的計時，事實上法術的持續時間還是10秒，只是倒計時會從那個20秒長的計時條的中間開始。]=]
L["ICONMENU_FOCUS"] = "專注目標"
L["ICONMENU_FOCUSTARGET"] = "專注目標的目標"
L["ICONMENU_FRIEND"] = "友好"
L["ICONMENU_GROUPUNIT_DESC"] = [=[Group是TellMeWhen中一個特殊的單位，用於你在團隊時檢查團隊成員，或你在隊伍時檢查隊伍成員。

如果你在一個團隊中，它不會檢查重複的單位（實際上可檢查的單位有"player;party;raid"，某些時候隊伍成員可能會被檢查兩次，但是它不會。）]=]
L["ICONMENU_GUARDIAN"] = "守護者"
L["ICONMENU_GUARDIAN_CHOOSENAME_DESC"] = [=[輸入你需要監視的守護者名字或者NPC ID。

你可以利用分號(;)輸入多個單位。]=]
L["ICONMENU_GUARDIAN_DESC"] = [=[檢測你當前使用的守護者。 像是術士的小鬼等等。

此圖標類型最好使用一個分組控制器。]=]
L["ICONMENU_GUARDIAN_DUR"] = "用於顯示持續時間的單位"
L["ICONMENU_GUARDIAN_DUR_EITHER"] = "增效優先"
L["ICONMENU_GUARDIAN_DUR_EITHER_DESC"] = "如果存在增效，則優先顯示增效的持續時間。否則將顯示守護者的持續時間。"
L["ICONMENU_GUARDIAN_DUR_EMPOWER"] = "只有增效"
L["ICONMENU_GUARDIAN_DUR_GUARDIAN"] = "只有守護者"
L["ICONMENU_GUARDIAN_EMPOWERED"] = "增效"
L["ICONMENU_GUARDIAN_TRIGGER"] = "觸發自：%s"
L["ICONMENU_GUARDIAN_UNEMPOWERED"] = "未增效"
L["ICONMENU_HIDENOUNITS"] = "無單位時隱藏"
L["ICONMENU_HIDENOUNITS_DESC"] = "勾選此項可在單位不存在時致使圖示檢查的所有單位都無效的情況下隱藏該圖示（包括單位條件的設定在內）。"
L["ICONMENU_HIDEUNEQUIPPED"] = "當裝備欄缺少武器時隱藏"
L["ICONMENU_HIDEUNEQUIPPED_DESC"] = "勾選此項在檢查的武器欄沒有裝備武器時強制隱藏圖示"
L["ICONMENU_HOSTILE"] = "敵對"
L["ICONMENU_ICD"] = "內置冷卻"
L["ICONMENU_ICD_DESC"] = [=[檢查一個觸發效果或與其類似效果的冷卻。

|cFFFF5959重要提示|r：關於如何檢查每種類型的內置冷卻請參閱在 %q 下方選項的提示資訊。]=]
L["ICONMENU_ICDAURA_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在你應用某個減益/獲得某個增益以後（包括觸發），或是
|cff7fffff2）|r在某個效果造成傷害以後，或是
|cff7fffff3）|r在充能效果使你恢復法力值/怒氣/等情況以後，或是
|cff7fffff4）|r在你召喚某個東西或NPC以後。

你需要在 %q 編輯框中輸入法術/技能的名稱或ID：

|cff7fffff1）|r觸發內置冷卻的增益/減益的名稱/ID，或是
|cff7fffff2）|r造成傷害的法術/技能的名稱/ID（請檢查你的戰鬥記錄），或是
|cff7fffff3）|r充能效果的名稱/ID（請檢查你的戰鬥記錄），或是
|cff7fffff4）|r觸發內置冷卻的召喚效果的法術/技能（請檢查你的戰鬥記錄）。

（請檢查你的戰鬥記錄或者利用插件來確認法術名稱或ID）]=]
L["ICONMENU_ICDBDE"] = "增益/減益/傷害/充能/召喚"
L["ICONMENU_ICDTYPE"] = "何時開始冷卻……"
L["ICONMENU_IGNORENOMANA"] = "忽略能量不足"
L["ICONMENU_IGNORENOMANA_DESC"] = [=[勾選此項當一個技能僅僅是因為能量不足而不可用時視該技能為可用。  

對於像是%s 或者 %s這類技能很實用。]=]
L["ICONMENU_IGNORERUNES"] = "忽略符文"
L["ICONMENU_IGNORERUNES_DESC"] = [=[勾選此項，在技能冷卻已結束，僅僅因為符文冷卻（或公共冷卻）導致技能無法施放，則視該技能為可用。

譯者註：舉例說明一下，比如死亡騎士的符文轉化冷卻時間為30秒，但是30秒冷卻結束之後，在沒有可用的血魄符文或死亡符文的情況下會繼續顯示冷卻倒數計時，如果有勾選這個選項，則圖示不會出現繼續倒數，直接顯示為符文轉化可用。]=]
L["ICONMENU_IGNORERUNES_DESC_DISABLED"] = "\"忽略符文\"必須在\"冷卻檢查\"已勾選後才可使用。"
L["ICONMENU_INVERTBARDISPLAYBAR_DESC"] = "勾選此項以反向的方式填充計量條，會在持續時間到0時填滿整個計量條。"
L["ICONMENU_INVERTBARS"] = "反轉計量條"
L["ICONMENU_INVERTCBAR_DESC"] = "勾選此項使圖示上的計時條在持續時間為0時才填滿圖示的寬度，而不是計時條從填滿開始減少。"
L["ICONMENU_INVERTPBAR_DESC"] = "勾選此項使圖示上的能量條在有足夠的能量施法時才填滿圖示的寬度，而不是計時條從填滿開始減少。"
L["ICONMENU_INVERTTIMER"] = "反轉陰影"
L["ICONMENU_INVERTTIMER_DESC"] = "勾選此項來反轉計時器的陰影效果。"
L["ICONMENU_ISPLAYER"] = "單位是玩家"
L["ICONMENU_ITEMCOOLDOWN"] = "物品冷卻"
L["ICONMENU_ITEMCOOLDOWN_DESC"] = "檢查可使用物品的冷卻。"
L["ICONMENU_LIGHTWELL_DESC"] = "檢查你施放的%s的持續時間跟可用次數。"
L["ICONMENU_MANACHECK"] = "能量檢查"
L["ICONMENU_MANACHECK_DESC"] = [=[勾選此項啟用當你法力/怒氣/符能等等不足時改變圖示顏色（或視為不可用）。

譯者註：除非特別說明，本插件中的能量一般是指法術施放所需的法力/怒氣/符能/集中值等等，並非盜賊/野德的能量值。]=]
L["ICONMENU_META"] = "整合圖示"
L["ICONMENU_META_DESC"] = [=[組合多個圖示到一個圖示。

在整合圖示中被檢查的那些圖示即使設定為%q，在可以顯示時同樣會顯示。]=]
L["ICONMENU_META_ICONMENUTOOLTIP"] = "（%d個圖示）"
L["ICONMENU_MOUSEOVER"] = "遊標對象"
L["ICONMENU_MOUSEOVERTARGET"] = "遊標對象的目標"
L["ICONMENU_MOVEHERE"] = "移動到此"
L["ICONMENU_NAMEPLATE"] = "姓名版"
L["ICONMENU_NOPOCKETWATCH"] = "未知時顯示透明材質"
L["ICONMENU_NOPOCKETWATCH_DESC"] = "勾選此項使用透明材質代替時鐘材質。"
L["ICONMENU_NOTCOUNTING"] = "未倒數"
L["ICONMENU_NOTREADY"] = "沒有準備好"
L["ICONMENU_OFFS"] = "位移"
L["ICONMENU_ONCOOLDOWN"] = "冷卻中"
L["ICONMENU_ONFAIL"] = "在無效時"
L["ICONMENU_ONLYACTIVATIONOVERLAY"] = "需要啟用邊框"
L["ICONMENU_ONLYACTIVATIONOVERLAY_DESC"] = "此選項為檢測系統預設提示技能可用時的黃色發光邊框所需的必要選項。"
L["ICONMENU_ONLYBAGS"] = "只在背包中存在時"
L["ICONMENU_ONLYBAGS_DESC"] = "勾選此項當物品在背包中（或者已裝備）時顯示圖示。如果啟用'已裝備的物品'，此選項會被強制啟用。"
L["ICONMENU_ONLYEQPPD"] = "只在已裝備時"
L["ICONMENU_ONLYEQPPD_DESC"] = "勾選這個來使圖示只在物品已裝備時顯示。"
L["ICONMENU_ONLYIFCOUNTING"] = "僅在計時器倒數時顯示"
L["ICONMENU_ONLYIFCOUNTING_DESC"] = "勾選此項使圖示僅在計時器持續時間設定大於0並且正在倒數時顯示"
L["ICONMENU_ONLYIFNOTCOUNTING"] = "僅在計時器倒數完畢時顯示"
L["ICONMENU_ONLYIFNOTCOUNTING_DESC"] = "勾選此項使圖示僅在計時器持續時間設定大於0並且倒數完畢時顯示"
L["ICONMENU_ONLYINTERRUPTIBLE"] = "僅可中斷"
L["ICONMENU_ONLYINTERRUPTIBLE_DESC"] = "選中此框僅顯示可中斷的施法"
L["ICONMENU_ONLYMINE"] = "僅檢查自己施放的"
L["ICONMENU_ONLYMINE_DESC"] = "勾選此項讓該圖示只顯示你施放的增益或減益"
L["ICONMENU_ONLYSEEN"] = "僅顯示施放過的法術"
L["ICONMENU_ONLYSEEN_ALL"] = "允許所有法術"
L["ICONMENU_ONLYSEEN_ALL_DESC"] = "選中此項以允許為所有檢查的單元顯示所有功能。"
L["ICONMENU_ONLYSEEN_CLASS"] = "僅單位職業法術、技能"
L["ICONMENU_ONLYSEEN_CLASS_DESC"] = [=[選中此項，只有在已知該單元的類具有該能力時，才允許該圖標顯示能力。

已知的類法術在建議列表中用藍色或粉紅色突出顯示。]=]
L["ICONMENU_ONLYSEEN_DESC"] = "選擇此項可以讓圖示只顯示某單位至少施放過一次的法術冷卻。如果你想在同一個圖示中檢查來自不同職業的法術那麼應該勾上它。"
L["ICONMENU_ONLYSEEN_HEADER"] = "法術篩選"
L["ICONMENU_ONSUCCEED"] = "在通過時"
L["ICONMENU_OO_F"] = "在 %s 之外"
L["ICONMENU_OOPOWER"] = "在野"
L["ICONMENU_OORANGE"] = "超出範圍"
L["ICONMENU_PETTARGET"] = "寵物的目標"
L["ICONMENU_PRESENT"] = "存在"
L["ICONMENU_PRESENTONALL"] = "全都存在"
L["ICONMENU_PRESENTONALL_DESC"] = "設定在檢查的所有單位中至少都有一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_PRESENTONANY"] = "任一存在"
L["ICONMENU_PRESENTONANY_DESC"] = "設定在檢查的所有單位中至少存在一個用於檢查的增益/減益時的圖示可見度。"
L["ICONMENU_RANGECHECK"] = "距離檢查"
L["ICONMENU_RANGECHECK_DESC"] = "勾選此項啟用當你超出範圍時改變圖示顏色（或視為不可用）。"
L["ICONMENU_REACT"] = "單位反映"
L["ICONMENU_REACTIVE"] = "觸發性技能"
L["ICONMENU_REACTIVE_DESC"] = [=[檢查觸發性技能的可用情況。

觸發性的技能指類似%s， %s 和 %s 這些只能在某種特定條件下使用的技能。]=]
L["ICONMENU_READY"] = "準備"
L["ICONMENU_REVERSEBARS"] = "翻轉進度條"
L["ICONMENU_REVERSEBARS_DESC"] = "翻轉進度條為從左到右走。"
L["ICONMENU_RUNES"] = "符文冷卻"
L["ICONMENU_RUNES_CHARGES"] = "不可用符文充能"
L["ICONMENU_RUNES_CHARGES_DESC"] = "啟用此項，在一個符文獲得額外充能並顯示為可用時，讓圖示依然顯示成符文正在冷卻狀態（顯示為冷卻時鐘）。"
L["ICONMENU_RUNES_DESC"] = "檢查符文冷卻。"
L["ICONMENU_SHOWCBAR_DESC"] = "將會在跟圖示重疊的下半部份顯示剩餘的冷卻/持續時間的計量條（或是在'反轉計量條'啟用的情況下顯示已用的時間）"
L["ICONMENU_SHOWPBAR_DESC"] = [=[將會在跟圖示重疊的上半部份方顯示你施放此法術還需多少能量的能量條（或是在'反轉計量條'啟用的情況下顯示當前的能量）。

譯者註：這個能量可以是盜賊的能量，戰士的怒氣，獵人的集中值，其他職業的法力值等等。]=]
L["ICONMENU_SHOWSTACKS"] = "顯示堆疊數量"
L["ICONMENU_SHOWSTACKS_DESC"] = "勾選此項顯示物品的堆疊數量並啟用堆疊數量條件。"
L["ICONMENU_SHOWTIMER"] = "顯示計時器"
L["ICONMENU_SHOWTIMER_DESC"] = "勾選此項讓該圖示的冷卻時鐘動畫在可用時顯示。（譯者註：此選項僅影響圖示的時鐘動畫，就是技能冷卻時的那個轉圈效果，不包括數字在內哦。）"
L["ICONMENU_SHOWTIMERTEXT"] = "顯示計時器數字"
L["ICONMENU_SHOWTIMERTEXT_DESC"] = [=[勾選此項在圖示上顯示剩餘冷卻時間或持續時間的數字。

你需要安裝OmniCC或類似插件，或者勾選內建遊戲設定「快捷列」一頁中「顯示冷卻時間」一項。]=]
L["ICONMENU_SHOWTIMERTEXT_NOOCC"] = "顯示ElvUI計時器數字"
L["ICONMENU_SHOWTIMERTEXT_NOOCC_DESC"] = [=[勾選此項使用ElvUI的冷卻數字來顯示圖示剩餘的冷卻時間/持續時間。

此設定僅用於ElvUI的計時器。如果你有其他插件提供類似此種計時器的功能（像是OmniCC），你可以利用%q選項來控制那些計時器。 我們不推薦兩個選項同時啟用。]=]
L["ICONMENU_SHOWTTTEXT_DESC2"] = [=[在圖示的疊加層數位置顯示技能效果的變數數值。較常使用在監視傷害護盾的數值等。

此數值會顯示到圖示的疊加層數位置並替代它。

數值來源為暴雪的API接口，可能跟提示訊息上看到的數值會不相同。]=]
L["ICONMENU_SHOWTTTEXT_FIRST"] = "第一個非0變數"
L["ICONMENU_SHOWTTTEXT_FIRST_DESC"] = [=[把增益/減益第一個非0的變數顯示到圖示疊加層數的位置。

一般情況下它顯示的變數數值都是正確的，你也可以自行選擇一個效果變數來顯示。

如果檢查%s，你需要監視變數#1。]=]
L["ICONMENU_SHOWTTTEXT_STACKS"] = "疊加層數（預設）"
L["ICONMENU_SHOWTTTEXT_STACKS_DESC"] = "在圖示疊加層數位置顯示增益/減益的疊加層數。"
L["ICONMENU_SHOWTTTEXT_VAR"] = "僅變數#%d"
L["ICONMENU_SHOWTTTEXT_VAR_DESC"] = [=[僅在圖示疊加層數位置顯示此變數數值。

請自行嘗試並選擇正確的數值來源。]=]
L["ICONMENU_SHOWTTTEXT2"] = "法術效果變數"
L["ICONMENU_SHOWWHEN"] = "何時顯示圖示"
L["ICONMENU_SHOWWHEN_OPACITY_GENERIC_DESC"] = "設定此圖示在這個圖示狀態下用來顯示的可視度。"
L["ICONMENU_SHOWWHEN_OPACITYWHEN_WRAP"] = "當%s|r時的可視度"
L["ICONMENU_SHOWWHENNONE"] = "沒有結果時顯示"
L["ICONMENU_SHOWWHENNONE_DESC"] = "勾選此項允許在單位沒有被檢查到遞減時顯示圖示。"
L["ICONMENU_SHRINKGROUP"] = "收縮分組"
L["ICONMENU_SHRINKGROUP_DESC"] = [=[如果啟用此項，分組將會動態調整可見圖標的位置，使其變得不會狗啃骨頭一樣難看。

結合上面的圖標排列以及布局方向一同使用，你就可以創建一個動態居中的分組。]=]
L["ICONMENU_SORT_STACKS_ASC"] = "堆疊數量升序"
L["ICONMENU_SORT_STACKS_ASC_DESC"] = "勾選此項優先顯示堆疊數量最低的法術。"
L["ICONMENU_SORT_STACKS_DESC"] = "堆疊數量降序"
L["ICONMENU_SORT_STACKS_DESC_DESC"] = "勾選此項優先顯示堆疊數量最高的法術。"
L["ICONMENU_SORTASC"] = "持續時間升序"
L["ICONMENU_SORTASC_DESC"] = "勾選此項優先顯示持續時間最低的法術。"
L["ICONMENU_SORTASC_META_DESC"] = "勾選此項優先顯示持續時間最低的圖示。"
L["ICONMENU_SORTDESC"] = "持續時間降序"
L["ICONMENU_SORTDESC_DESC"] = "勾選此項優先顯示持續時間最高的法術。"
L["ICONMENU_SORTDESC_META_DESC"] = "勾選此項優先顯示持續時間最高的圖示。"
L["ICONMENU_SPELLCAST_COMPLETE"] = "施法結束/瞬發施法"
L["ICONMENU_SPELLCAST_COMPLETE_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在你施法結束後，或是
|cff7fffff2）|r在你施放一個瞬發法術後。

你需要在 %q 編輯框中輸入觸發內置冷卻的法術名稱或ID。]=]
L["ICONMENU_SPELLCAST_START"] = "施法開始"
L["ICONMENU_SPELLCAST_START_DESC"] = [=[如果是在以下情況開始內置冷卻，請選擇此項：

|cff7fffff1）|r在開始施法後。

你需要在 %q 編輯框中輸入觸發內置冷卻的法術名稱或ID。]=]
L["ICONMENU_SPELLCOOLDOWN"] = "法術冷卻"
L["ICONMENU_SPELLCOOLDOWN_DESC"] = "檢查在你法術書中那些法術的冷卻。"
L["ICONMENU_SPLIT"] = "拆分成新的群組"
L["ICONMENU_SPLIT_DESC"] = "創建一個新的群組並將這個圖示移動到上面。 原群組中的許多設定會保留到新的群組。"
L["ICONMENU_SPLIT_GLOBAL"] = "拆分成新的|cff00c300global共用群組|r"
L["ICONMENU_SPLIT_NOCOMBAT_DESC"] = "戰鬥中不能創建新的群組。請在脫離戰鬥後分離到新的群組。"
L["ICONMENU_STACKS_MAX_DESC"] = "允許圖示顯示的最大堆疊數量，高於此數值圖示將被隱藏。"
L["ICONMENU_STACKS_MIN_DESC"] = "顯示圖示所需的最低堆疊數量，低於此數值圖示將被隱藏。"
L["ICONMENU_STATECOLOR"] = "圖標色彩和材質"
L["ICONMENU_STATECOLOR_DESC"] = [=[將圖標紋理的色調設置為此圖標狀態。

白色是正常的。 任何其他顏色會使紋理的顏色。

在此狀態下，還可以覆蓋圖標上顯示的紋理。]=]
L["ICONMENU_STATUE"] = "武僧雕像"
L["ICONMENU_STEALABLE"] = "僅可法術竊取"
L["ICONMENU_STEALABLE_DESC"] = "勾選此項僅顯示能被\"法術竊取\"的增益，非常適合跟驅散類型中的魔法搭配使用。"
L["ICONMENU_SUCCEED2"] = "條件通過時"
L["ICONMENU_SWAPWITH"] = "交換位置"
L["ICONMENU_SWINGTIMER"] = "揮擊計時器"
L["ICONMENU_SWINGTIMER_DESC"] = "檢查你主手和副手武器的揮擊時間。"
L["ICONMENU_SWINGTIMER_NOTSWINGING"] = "無揮擊"
L["ICONMENU_SWINGTIMER_SWINGING"] = "揮擊中"
L["ICONMENU_TARGETTARGET"] = "目標的目標"
L["ICONMENU_TOTEM"] = "圖騰"
L["ICONMENU_TOTEM_DESC"] = "檢查你的圖騰。"
L["ICONMENU_TOTEM_GENERIC_DESC"] = "檢測你的 %s。"
L["ICONMENU_TYPE"] = "圖示類型"
L["ICONMENU_TYPE_CANCONTROL"] = "此圖示類型如果在群組的第一個圖示設定好就可以控制整個群組。"
L["ICONMENU_TYPE_DISABLED_BY_VIEW"] = "此圖示類型不支援顯示方式：%q。你可以更改群組顯示方式或者創建一個新的群組使用這個圖示類型。"
L["ICONMENU_UIERROR"] = "戰鬥錯誤訊息"
L["ICONMENU_UIERROR_DESC"] = "檢查UI錯誤訊息。例如：「怒氣不足」、「你需要一個目標」等等。"
L["ICONMENU_UNIT_DESC"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入，或者你是一位高端玩家可以自行輸入需要監視的單位。多個單位請用分號分隔開（;）可使用標準單位（像是player，target，mouseover等等可用於巨集的單位），或者是友好玩家的名字（像是%s，Cybeloras，小兔是豬，阿光是豬等。）

需要瞭解更多關於單位的相關資訊，請訪問http://www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_CONDITIONUNIT"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入，或者你是一位高端玩家可以自行輸入需要監視的單位。

可使用標準單位（像是player，target，mouseover等等可用於巨集的單位），或者是友好玩家的名字（像是%s，Cybeloras，小兔是豬，阿光是豬等。）

需要瞭解更多關於單位的相關資訊，請訪問http:////www.wowpedia.org/UnitId]=]
L["ICONMENU_UNIT_DESC_UNITCONDITIONUNIT"] = [=[在此框輸入需要監視的單位。此單位能從右邊的下拉列表插入。

"unit"是指當前圖示正在檢查的任意單位。]=]
L["ICONMENU_UNITCNDTIC"] = "單位條件圖示"
L["ICONMENU_UNITCNDTIC_DESC"] = [=[檢查單位的條件狀態。

設定中所有應用的單位都會被檢查。]=]
L["ICONMENU_UNITCOOLDOWN"] = "單位冷卻"
L["ICONMENU_UNITCOOLDOWN_DESC"] = [=[檢查其他單位的冷卻。

檢查 %s 可以使用 %q 作為名稱。

譯者註：玩家也可以作為被檢查的單位。]=]
L["ICONMENU_UNITFAIL"] = "單位條件未通過"
L["ICONMENU_UNITS"] = "單位"
L["ICONMENU_UNITSTOWATCH"] = "監視的單位"
L["ICONMENU_UNITSUCCEED"] = "單位條件通過"
L["ICONMENU_UNUSABLE"] = "不可用"
L["ICONMENU_UNUSABLE_DESC"] = "當上述狀態也不啟用時，該狀態是活動的。 不透明度為0％的狀態將永遠不會被啟用。"
L["ICONMENU_USABLE"] = "可用"
L["ICONMENU_USEACTIVATIONOVERLAY"] = "檢查技能激活邊框"
L["ICONMENU_USEACTIVATIONOVERLAY_DESC"] = "檢查系統預設提示技能可用時的黃色發光邊框。"
L["ICONMENU_VALUE"] = "資源顯示"
L["ICONMENU_VALUE_DESC"] = "顯示一個單位的資源（生命值、法力值等等）"
L["ICONMENU_VALUE_HASUNIT"] = "單位已找到"
L["ICONMENU_VALUE_NOUNIT"] = "單位未找到"
L["ICONMENU_VALUE_POWERTYPE"] = "資源類型"
L["ICONMENU_VALUE_POWERTYPE_DESC"] = "設定你想要圖示檢查的資源類型。"
L["ICONMENU_VEHICLE"] = "載具"
L["ICONMENU_VIEWREQ"] = "群組顯示方式不支持"
L["ICONMENU_VIEWREQ_DESC"] = [=[此圖示類型不能用於當前群組顯示方式，因為它沒有顯示全部數據所需的組件。

請更改群組的顯示方式或者創建一個新的群組再使用這個圖示類型。]=]
L["ICONMENU_WPNENCHANT"] = "暫時性武器附魔"
L["ICONMENU_WPNENCHANT_DESC"] = "檢查暫時性的武器附魔"
L["ICONMENU_WPNENCHANTTYPE"] = "監視的武器欄"
L["IconModule_CooldownSweepCooldown"] = "冷卻時鐘"
L["IconModule_IconContainer_MasqueIconContainer"] = "圖示容器"
L["IconModule_IconContainer_MasqueIconContainer_DESC"] = "容納圖示的主要部份，像是材質。"
L["IconModule_PowerBar_OverlayPowerBar"] = "重疊式能量條"
L["IconModule_SelfIcon"] = "圖示"
L["IconModule_Texture_ColoredTexture"] = "圖示材質"
L["IconModule_TimerBar_BarDisplayTimerBar"] = "計時條（計量條顯示）"
L["IconModule_TimerBar_OverlayTimerBar"] = "重疊式計時條"
L["ICONTOCHECK"] = "要檢查的圖示"
L["ICONTYPE_DEFAULT_HEADER"] = "提示資訊"
L["ICONTYPE_DEFAULT_INSTRUCTIONS"] = [=[要開始設定該圖示，請先從%q下拉式選單中選擇一個圖示類型。

圖示只能在鎖定狀態才能正常運作，當你設定結束後記得輸入"/TMW"。


在設定TellMeWhen時，請仔細閱讀每個設定選項的提示資訊，裡面會有如何設定的關鍵訊息，可以讓你事半功倍!]=]
L["ICONTYPE_SWINGTIMER_TIP"] = [=[你需要檢查%s的時間嗎？圖示類型%s擁有你想要的功能。 僅需簡單設定一個%s來檢查%q（法術ID：%d）!

你可以點擊下方的按鈕自動套用設定。]=]
L["ICONTYPE_SWINGTIMER_TIP_APPLYSETTINGS"] = "套用%s設定"
L["IE_NOLOADED_GROUP"] = "選擇一個分組加載："
L["IE_NOLOADED_ICON"] = "沒有圖標載入。"
L["IE_NOLOADED_ICON_DESC"] = [=[你可以右鍵點擊來讀取一個圖標。

如果你的屏幕上沒有顯示任何圖標，請點擊下面的 %s 標簽 。

在那裡你可以新增一個分組或者配置一個已存在的分組。

輸入'/tmw'退出設置模式。]=]
L["ImmuneToMagicCC"] = "免疫法術控制"
L["ImmuneToStun"] = "免疫擊暈"
L["IMPORT_EXPORT"] = "匯入/匯出/還原"
L["IMPORT_EXPORT_BUTTON_DESC"] = "點擊此下拉式選單來匯出或匯入圖示/群組/設定檔。"
L["IMPORT_EXPORT_DESC"] = [=[點擊這個編輯框右側的下拉式選單的箭頭來匯出圖示，群組或設定檔。

匯出/匯入字串或發送給其他玩家需要使用這個編輯框。 具體的使用方法請看下拉式選單上的提示資訊。]=]
L["IMPORT_FAILED"] = "匯入失敗！"
L["IMPORT_FROMBACKUP"] = "來自備份"
L["IMPORT_FROMBACKUP_DESC"] = "用此選單可以還原設定到：%s "
L["IMPORT_FROMBACKUP_WARNING"] = "備份設定：%s"
L["IMPORT_FROMCOMM"] = "來自玩家"
L["IMPORT_FROMCOMM_DESC"] = "如果另一個TellMeWhen使用者給你發送了組態數據，可以從這個子選單匯入那些數據。"
L["IMPORT_FROMLOCAL"] = "來自設定檔"
L["IMPORT_FROMSTRING"] = "來自字串"
L["IMPORT_FROMSTRING_DESC"] = [=[字串允許你在遊戲以外的地方轉存TellMeWhen組態數據。（包括用來給其他人分享自己的設定，或者匯入其他人分享的設定，也可用來備份你自己的設定。）

從字串匯入的方法：當複製TMW字串到你的剪貼簿後，在「匯出/匯入」編輯框中按下CTRL+V貼上字串，然後返回瀏覽這個子選單。]=]
L["IMPORT_GROUPIMPORTED"] = "群組已匯入！"
L["IMPORT_GROUPNOVISIBLE"] = "你剛剛匯入的群組無法顯示，因為它的設定似乎不是你當前的專精和職業所使用。請輸入'/tmw options'，在群組設定中修改專精和職業設定。"
L["IMPORT_HEADING"] = "匯入"
L["IMPORT_ICON_DISABLED_DESC"] = "你必須在設定一個圖示的時候才能匯入一個圖示。"
L["IMPORT_LUA_CONFIRM"] = "確定匯入"
L["IMPORT_LUA_DENY"] = "取消匯入"
L["IMPORT_LUA_DESC"] = [=[匯入的數據中包含了以下Lua程式碼可以被TellMeWhen執行。

你需要警惕匯入的Lua程式碼的來源是否可信。大部分情況下它們都是安全的，但是知人知面不知心，不要被少數壞人有機可乘。

注意檢查並確認程式碼來自可信的地方，以及它們不會做像是以你的名義來發送郵件或者確認交易這種事情。]=]
L["IMPORT_LUA_DESC2"] = "|TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t 請注意檢視紅色部分程式碼，它們可能會有某些惡意行為。 |TInterface\\AddOns\\TellMeWhen\\Textures\\Alert:0:2|t"
L["IMPORT_NEWGUIDS"] = [=[你剛匯入的數據中的%d|4群組；群組，和%d|4圖示：圖示；有唯一識別碼。可能是因為你之前已經匯入過該數據。

已經為匯入的數據分配了新的識別碼。你在這之後匯入的那些圖示都將引用新的數據，可能會無法正常使用，新數據會使用到老的圖示數據而造成混亂。

如果你打算替換現有的數據，請重新匯入到正確的位置。]=]
L["IMPORT_PROFILE"] = "複製設定檔"
L["IMPORT_PROFILE_NEW"] = "|cff59ff59創建|r新的設定檔"
L["IMPORT_PROFILE_OVERWRITE"] = "|cFFFF5959覆寫|r %s"
L["IMPORT_SUCCESSFUL"] = "匯入完成!"
L["IMPORTERROR_FAILEDPARSE"] = "處理字串時發生錯誤。請確保你複製的字串是完整的。"
L["IMPORTERROR_INVALIDTYPE"] = "嘗試匯入未知類型的數據，請檢查是否已安裝了最新版本的TellMeWhen。"
L["Incapacitated"] = "癱瘓"
L["INCHEALS"] = "單位受到的治療量"
L["INCHEALS_DESC"] = [=[檢查單位即將受到的治療量（包括下一跳HoT和施放中的法術）

僅能在友好單位使用， 敵對單位會返回0。

譯者註：由於暴雪的API問題，HoT只會返回單位框架上所顯示的數值。]=]
L["INRANGE"] = "在範圍內"
L["ITEMCOOLDOWN"] = "物品冷卻"
L["ITEMEQUIPPED"] = "已裝備的物品"
L["ITEMINBAGS"] = "物品計數（包含使用次數）"
L["ITEMSPELL"] = "物品有使用效果"
L["ITEMTOCHECK"] = "要檢查的物品"
L["ITEMTOCOMP1"] = "進行比較的第一個物品"
L["ITEMTOCOMP2"] = "進行比較的第二個物品"
L["LAYOUTDIRECTION"] = "佈局方向"
L["LAYOUTDIRECTION_PRIMARY_DESC"] = "使圖標的主要布局方向沿 %s 方向展開。"
L["LAYOUTDIRECTION_SECONDARY_DESC"] = "使連續的行/列圖標沿 %s 方向展開。"
L["LDB_TOOLTIP1"] = "|cff7fffff左鍵點擊：|r鎖定群組"
L["LDB_TOOLTIP2"] = "|cff7fffff右鍵點擊：|r顯示TWM選項"
L["LEFT"] = "左"
L["LOADERROR"] = "TellMeWhen設定插件無法載入："
L["LOADINGOPT"] = "正在載入TellMeWhen設定插件。"
L["LOCKED"] = "已鎖定"
L["LOCKED2"] = "位置鎖定。"
L["LOSECONTROL_CONTROLLOST"] = "失去控制"
L["LOSECONTROL_DROPDOWNLABEL"] = "失去控制類型"
L["LOSECONTROL_DROPDOWNLABEL_DESC"] = "選擇你需要作用於此圖示的失去控制的類型（譯者註：可多選）。"
L["LOSECONTROL_ICONTYPE"] = "失去控制"
L["LOSECONTROL_ICONTYPE_DESC"] = "檢查那些造成你失去角色控制權的效果。 "
L["LOSECONTROL_INCONTROL"] = "可控制"
L["LOSECONTROL_TYPE_ALL"] = "全部類型"
L["LOSECONTROL_TYPE_ALL_DESC"] = "讓圖示顯示所有相關類型的資訊。"
L["LOSECONTROL_TYPE_DESC_USEUNKNOWN"] = "注意：圖示無法判斷這個失去控制的類型是否已使用。 "
L["LOSECONTROL_TYPE_MAGICAL_IMMUNITY"] = "魔法免疫"
L["LOSECONTROL_TYPE_SCHOOLLOCK"] = "法術類別被鎖定"
L["LUA_INSERTGUID_TOOLTIP"] = "|cff7fffffShift點擊|r插入並在你的代碼中引用這個圖標。"
L["LUACONDITION"] = "Lua（進階）"
L["LUACONDITION_DESC"] = [=[此條件類型允許你使用Lua語言來評估一個條件的狀態。

輸入不能為「if……then」敘述，也不能為function closure。它可以是一個普通的敘述評估，例如：「a and b or c」。如果需要複雜功能，可使用函數調用，例如：「CheckStuff()」，這是一個外部函數。 （你也可以使用Lua片段功能）。

使用「thisobj」來引用這個圖示、群組的數據。你也可以插入其他圖示的GUID，在編輯框獲得焦點時SHIFT點擊那個圖示即可。

如果需要更多的幫助（但不是關於如何去寫Lua代碼），到CurseForge提交一份回報單。關於如何編寫Lua语言，請自行去互聯網搜尋資料。

註：Lua語言部份就不翻譯了，翻譯了反而覺得怪怪的。]=]
L["LUACONDITION2"] = "Lua條件"
L["MACROCONDITION"] = "巨集條件式"
L["MACROCONDITION_DESC"] = [=[此條件將會評估巨集的條件式，在巨集條件式成立時則此條件通過。
所有的巨集條件式都能在前面加上"no"進行逆向檢查。
例子：
"[nomodifier:alt]" - 沒有按住ALT鍵
"[@target,help][mod:ctrl]" - 目標是友好的或者按住CTRL鍵
"[@focus,harm,nomod:shift]" - 專注目標是敵對的同時沒有按住SHIFT鍵

需要更多的幫助，請訪問http:////www.wowpedia.org/Making_a_macro]=]
L["MACROCONDITION_EB_DESC"] = "使用單一條件時中括號是可選的，使用多個條件式時中括號是必須的。（說明：中括號->[ ]）"
L["MACROTOEVAL"] = "輸入需要評估的巨集條件式（允許多個）"
L["Magic"] = "魔法"
L["MAIN"] = "主頁面"
L["MAIN_DESC"] = "包含這個圖示的主要選項。"
L["MAINASSIST"] = "主助攻"
L["MAINASSIST_DESC"] = "檢查團隊中被標記為主助攻的單位。"
L["MAINOPTIONS_SHOW"] = "群組設定"
L["MAINTANK"] = "主坦克"
L["MAINTANK_DESC"] = "檢查團隊中被標記為主坦克的單位。"
L["MAKENEWGROUP_GLOBAL"] = "|cff59ff59創建|r新的|cff00c300帳號共用|r群組"
L["MAKENEWGROUP_PROFILE"] = "|cff59ff59創建|r新的角色設定檔分組"
L["MESSAGERECIEVE"] = "%s給你發送了一些TellMeWhen的數據! 你可以利用圖示編輯器中的 %q 下拉式選單匯入這些數據到TellMeWhen。"
L["MESSAGERECIEVE_SHORT"] = "%s給你發送了一些TellMeWhen數據!"
L["META_ADDICON"] = "增加圖示"
L["META_ADDICON_DESC"] = "點擊新增圖示到此整合圖示中。"
L["META_GROUP_INVALID_VIEW_DIFFERENT"] = [=[該群組的圖示不可用於整合圖示的檢查，因為它們使用了不同的顯示方式。

群組：%s
目標群組：%s]=]
L["METAPANEL_DOWN"] = "向下移動"
L["METAPANEL_REMOVE"] = "移除此圖示"
L["METAPANEL_REMOVE_DESC"] = "點擊從整合圖示的檢查列表中移除該圖示。"
L["METAPANEL_UP"] = "向上移動"
L["minus"] = "下屬"
L["MISCELLANEOUS"] = "其他"
L["MiscHelpfulBuffs"] = "雜項-其他增益"
L["MODTIMER_PATTERN"] = "允許Lua匹配模式"
L["MODTIMER_PATTERN_DESC"] = [=[預設情況下，這個條件將匹配任何包含你輸入的文字的計時器，不區分大小寫。

如果啟用此設定，輸入將使用Lua樣式的字符匹配模式。

輸入^timer name$時將強制匹配計時器的完整名稱。 TellMeWhen保存計時器的名稱必須全部為小寫字母。

需要獲取更多的資訊，請訪問http:////wowpedia.org/Pattern_matching]=]
L["MODTIMERTOCHECK"] = "用於檢查的計時器"
L["MODTIMERTOCHECK_DESC"] = "輸入顯示在首領模塊計時器顯示在計時條上的全名。"
L["MOON"] = "月蝕"
L["MOUSEOVER_TOKEN_NOT_FOUND"] = "無遊標對象"
L["MOUSEOVERCONDITION"] = "滑鼠遊標停留"
L["MOUSEOVERCONDITION_DESC"] = "此條件檢查你的滑鼠遊標是否有停留在此圖示上，如果為群組條件則檢查滑鼠遊標是否有停留在該群組的某個圖示上。"
L["MP5"] = "%d 5秒回藍"
L["MUSHROOM"] = "蘑菇%d"
L["NEWVERSION"] = "有新版本可升級（%s）"
L["NOGROUPS_DIALOG_BODY"] = [=[你當前的TellMeWhen設定或玩家專精不允許顯示任何群組，所以沒有東西可以進行設定。

如果你想更改已有群組的設定或新增一個群組，請輸入/tmw options打開TellMeWhen的首選項或者點擊下方的按鍵。

輸入/tellmewhen或/tmw退出設定模式。]=]
L["NONE"] = "不包含任何一個"
L["normal"] = "普通"
L["NOTINRANGE"] = "不在範圍內"
L["NOTYPE"] = "<無圖示類型>"
L["NUMAURAS"] = "數量"
L["NUMAURAS_DESC"] = [=[此條件僅檢查一個作用中的法術效果的數量 - 不要與法術效果的堆疊數量混淆。
像是你的兩個相同的武器附魔特效同時觸發並且在作用中。
請有節制的使用它，此過程需要消耗不少CPU運算來計算數量。]=]
L["ONLYCHECKMINE"] = "僅檢查自己施放的"
L["ONLYCHECKMINE_DESC"] = "勾選此項讓此條件只檢查自己施放的增益/減益。"
L["OPERATION_DIVIDE"] = "除（/）"
L["OPERATION_MINUS"] = "減（-）"
L["OPERATION_MULTIPLY"] = "乘（*）"
L["OPERATION_PLUS"] = "加（+）"
L["OPERATION_SET"] = "集（Set）"
L["OPERATION_TPAUSE"] = "暫停"
L["OPERATION_TPAUSE_DESC"] = "暫停計時器。"
L["OPERATION_TRESET"] = "重設"
L["OPERATION_TRESET_DESC"] = "重設計時器為0。如果它還在運作的話不會停止。"
L["OPERATION_TRESTART"] = "重開"
L["OPERATION_TRESTART_DESC"] = "重設計時器為0。如果它未運作則開始運作。"
L["OPERATION_TSTART"] = "開始"
L["OPERATION_TSTART_DESC"] = "如果計時器沒在運行則開始計時。不重設計時器。"
L["OPERATION_TSTOP"] = "停止"
L["OPERATION_TSTOP_DESC"] = "停止計時器並重設為0。"
L["OUTLINE_MONOCHORME"] = "單色"
L["OUTLINE_NO"] = "無描邊"
L["OUTLINE_THICK"] = "粗描邊"
L["OUTLINE_THIN"] = "細描邊"
L["PARENTHESIS_TYPE_("] = "左括號（"
L["PARENTHESIS_TYPE_)"] = "右括號）"
L["PARENTHESIS_WARNING1"] = [=[左右括號的数量不相等!

缺少%d個%s。]=]
L["PARENTHESIS_WARNING2"] = [=[一些右括號缺少左括號。

缺少%d個左括號'（'。]=]
L["PERCENTAGE"] = "百分比"
L["PERCENTAGE_DEPRECATED_DESC"] = [=[百分比條件已經作廢，因為它們不再可靠。

在德拉諾之王，增益/減益的加速機制更改為未結束前刷新可以最大延長至130%基礎持續時間。

其他一大段略過，基本同上。]=]
L["PET_TYPE_CUNNING"] = "靈巧"
L["PET_TYPE_FEROCITY"] = "兇暴"
L["PET_TYPE_TENACITY"] = "堅毅"
L["PLAYER_DESC"] = "單位'player'是你自己。"
L["Poison"] = "毒"
L["PROFILE_LOADED"] = "已載入設定檔：%s"
L["PROFILES_COPY"] = "複製設定檔..."
L["PROFILES_COPY_CONFIRM"] = "複製設定檔"
L["PROFILES_COPY_CONFIRM_DESC"] = "設定檔 %q 將被複製的設定檔 %q 覆蓋。"
L["PROFILES_COPY_DESC"] = [=[選擇一個設定檔。當前的設定檔會被這個選擇的設定檔覆蓋。

在登出游戲或重載前你都可以使用 %q (下方選單 %q 中的選項)來恢復被刪除的設定檔。]=]
L["PROFILES_DELETE"] = "刪除設定檔..."
L["PROFILES_DELETE_CONFIRM"] = "刪除設定檔"
L["PROFILES_DELETE_CONFIRM_DESC"] = "設定檔 %q 將被刪除。"
L["PROFILES_DELETE_DESC"] = [=[選擇需要刪除的設定檔。

在登出游戲或重載前你都可以使用 %q (下方選單 %q 中的選項)來恢復被刪設定檔。]=]
L["PROFILES_NEW"] = "新建設定檔"
L["PROFILES_NEW_DESC"] = "輸入新設定檔的名稱，按下enter來建立。"
L["PROFILES_SET"] = "變更設定檔..."
L["PROFILES_SET_DESC"] = "切換到選擇的設定檔。"
L["PROFILES_SET_LABEL"] = "目前設定檔"
L["PvPSpells"] = "PVP控制技能以及其他"
L["QUESTIDTOCHECK"] = "用於檢查的任務ID"
L["RAID_WARNING_FAKE"] = "團隊警報 （假）"
L["RAID_WARNING_FAKE_DESC"] = "輸出類似於團隊警報訊息的文字，此訊息不會被其他人看到，你不需要團隊權限，也不需要在團隊中就可使用。"
L["RaidWarningFrame"] = "團隊警告框架"
L["rare"] = "稀有"
L["rareelite"] = "稀有精英"
L["REACTIVECNDT_DESC"] = "此條件僅檢查技能的觸發/可用情況，並非它的冷卻。"
L["REDO"] = "重作"
L["REDO_DESC"] = "重做上次對這些設置所做的更改。"
L["ReducedHealing"] = "治療效果降低"
L["REQFAILED_ALPHA"] = "無效時的可視度"
L["RESET_ICON"] = "重設"
L["RESET_ICON_DESC"] = "重置這個圖示的所有設定為預設值。"
L["RESIZE"] = "改變大小"
L["RESIZE_GROUP_CLOBBERWARN"] = "當你使用|cff7fffff右鍵點擊並拖拽|r縮減群組格數時，部分圖示的設定將會臨時存檔，在你使用|cff7fffff右鍵點擊並拖拽|r加大群組格數時會恢復，但是在你登出或者重新載入UI後臨時存檔的數據將會丟失。"
L["RESIZE_TOOLTIP"] = "|cff7fffff點擊並拖拽：|r改變大小"
L["RESIZE_TOOLTIP_CHANGEDIMS"] = "|cff7fffff右鍵點擊並拖拽：|r更改群組的格數"
L["RESIZE_TOOLTIP_IEEXTRA"] = "在主選項啟用縮放。"
L["RESIZE_TOOLTIP_SCALEX_SIZEY"] = "|cff7fffff點擊並拖拽：|r改變大小"
L["RESIZE_TOOLTIP_SCALEXY"] = [=[|cff7fffff點擊並拖拽：|r快速調整大小比例
|cff7fffff按住CTRL：|r微調大小比例]=]
L["RESIZE_TOOLTIP_SCALEY_SIZEX"] = "|cff7fffff點擊並拖拽：|r調整大小比例"
L["RIGHT"] = "右"
L["ROLEf"] = "職責：%s"
L["Rooted"] = "纏繞"
L["RUNEOFPOWER"] = "符文%d"
L["RUNES"] = "要檢查的符文"
L["RUNSPEED"] = "單位奔跑速度"
L["RUNSPEED_DESC"] = "這是指單位的最大運行速度，而不管單位是否正在移動。"
L["SAFESETUP_COMPLETE"] = "安全&慢速設定完成。"
L["SAFESETUP_FAILED"] = "安全&慢速設定失敗：%s"
L["SAFESETUP_TRIGGERED"] = "正在進行安全&慢速設定……"
L["SEAL"] = "聖印"
L["SENDSUCCESSFUL"] = "發送完成"
L["SHAPESHIFT"] = "變身"
L["Shatterable"] = "冰凍"
L["SHOWGUIDS_OPTION"] = "在滑鼠提示上顯示GUID。"
L["SHOWGUIDS_OPTION_DESC"] = "啟用此設定可以在滑鼠提示上顯示圖示跟群組的GUID（全域唯一識別碼）。在需要知道圖示或群組所對應的GUID時，這可能對你有所幫助。"
L["Silenced"] = "沉默"
L["Slowed"] = "緩速"
L["SORTBY"] = "排序方式"
L["SORTBYNONE"] = "正常排序"
L["SORTBYNONE_DESC"] = [=[如果選中，法術將按照"%s"編輯框中的輸入順序來檢查並排序。

如果是一個增益/減益圖示，只要出現在單位框架上的法術效果數字沒有超出效率閥值設定的界限，就會被檢查並排序。

（註：如果看不懂請無視這段說明，只要知道它是按照你輸入的順序來排序就好。）]=]
L["SORTBYNONE_DURATION"] = "持續時間正常"
L["SORTBYNONE_META_DESC"] = "如果勾選，被檢查的圖示將使用上面的列表所設定的順序來排序。"
L["SORTBYNONE_STACKS"] = "堆疊數量正常"
L["SOUND_CHANNEL"] = "音效播放頻道"
L["SOUND_CHANNEL_DESC"] = [=[選擇一個你想用於播放聲音的頻道（會直接使用在系統->音效中該頻道所設定的音量跟設定來播放）。

選擇%q時，可以在音效關閉時播放聲音。]=]
L["SOUND_CHANNEL_MASTER"] = "主聲道"
L["SOUND_CUSTOM"] = "自訂音效檔案"
L["SOUND_CUSTOM_DESC"] = [=[輸入需要用來播放的自訂音效檔案的路徑。
下面是一些例子，其中「File」是你的音效檔案名，「ext」是副檔名（只能用ogg或者mp3格式）

-「CustomSounds\file.ext」：一個檔案放在WOW根目錄一個命名為「CustomSound」的新建資料夾中（此資料夾同WOW.exe，Interface和WTF在同一個位置）
-「Interface\AddOns\file.ext」：插件資料夾中的某一檔案
-「file.ext」： WOW主目錄的某個檔案

注意：魔獸世界必須在重開之後才能正常使用那些在它啟動時還不存在的檔案。]=]
L["SOUND_ERROR_ALLDISABLED"] = [=[無法進行音效播放測試，原因：遊戲音效已經被完全禁用。

你需要去更改暴雪音效選項的相關設定。]=]
L["SOUND_ERROR_DISABLED"] = [=[無法進行音效播放測試，原因：音效播放頻道「%q」已經被禁用。

你需要去更改暴雪音效選項的相關設定，或者你也可以在TellMeWhen的主選項中更改TellMeWhen的音效播放頻道（/tmw options）。]=]
L["SOUND_ERROR_MUTED"] = [=[無法進行音效播放測試，原因：音效播放頻道「%q」的音量大小為0。

你需要去更改暴雪音效選項的相關設定，或者你也可以在TellMeWhen的主選項中更改TellMeWhen的音效播放頻道（/tmw options）。]=]
L["SOUND_EVENT_DISABLEDFORTYPE"] = "不可用"
L["SOUND_EVENT_DISABLEDFORTYPE_DESC2"] = [=[在當前圖示設定下，此事件不可用。

可能因為當前的圖示類型（%s）還不支援此事件，請|cff7fffff右鍵點擊|r更改事件類型。]=]
L["SOUND_EVENT_NOEVENT"] = "未設定的事件"
L["SOUND_EVENT_ONALPHADEC"] = "在可見度百分比減少時"
L["SOUND_EVENT_ONALPHADEC_DESC"] = [=[當圖示的可視度降低時觸發此事件。

注意：可視度在降低後如果為0%不會觸發此事件（如果有需要請使用「在隱藏時」）。]=]
L["SOUND_EVENT_ONALPHAINC"] = "在可見度百分比增加時"
L["SOUND_EVENT_ONALPHAINC_DESC"] = [=[當圖示的可視度提高時觸發此事件。

注意：可視度在提高前如果為0%不會觸發此事件（如果有需要請使用「在顯示時」）。]=]
L["SOUND_EVENT_ONCHARGEGAINED"] = "在充能獲取時"
L["SOUND_EVENT_ONCHARGEGAINED_DESC"] = "此事件在一個被檢測的充能類型技能獲取一次充能時觸發。"
L["SOUND_EVENT_ONCHARGELOST"] = "在充能使用時"
L["SOUND_EVENT_ONCHARGELOST_DESC"] = "此事件在一個被檢測的充能類型技能使用一次充能時觸發。"
L["SOUND_EVENT_ONCLEU"] = "在戰鬥事件發生時"
L["SOUND_EVENT_ONCLEU_DESC"] = "此事件在圖示處理某一戰鬥事件時觸發。"
L["SOUND_EVENT_ONCONDITION"] = "在設定的條件通過時"
L["SOUND_EVENT_ONCONDITION_DESC"] = "當你設定的條件通過時觸發此事件。"
L["SOUND_EVENT_ONDURATION"] = "在持續時間改變時"
L["SOUND_EVENT_ONDURATION_DESC"] = [=[此事件在圖示計時器的持續時間改變時觸發。

因為在計時器運行時每次圖示更新都會觸發該事件，你必須設定一個條件，使事件僅在條件的狀態改變時觸發。]=]
L["SOUND_EVENT_ONEVENTSRESTORED"] = "在圖示設定後"
L["SOUND_EVENT_ONEVENTSRESTORED_DESC"] = [=[此事件在這圖示已經設定完畢後觸發。

這主要發生在你退出設定模式時，同樣也會發生在某些區域的進入事件或者離開事件。

你可以視它為圖示的"軟重設"。

此事件比較常用於創建一個圖示的預設狀態的動畫。]=]
L["SOUND_EVENT_ONFINISH"] = "在結束時"
L["SOUND_EVENT_ONFINISH_DESC"] = "當冷卻完成，增益/減益消失，等類似的情況下觸發此事件。 "
L["SOUND_EVENT_ONHIDE"] = "在隱藏時"
L["SOUND_EVENT_ONHIDE_DESC"] = "當圖示隱藏時觸發此事件（即使 %q 已勾選）。"
L["SOUND_EVENT_ONLEFTCLICK"] = "在左鍵點擊時"
L["SOUND_EVENT_ONLEFTCLICK_DESC"] = "在圖示鎖定的情況下，當你用|cff7fffff左鍵點擊|r這個圖示時觸發此事件。"
L["SOUND_EVENT_ONRIGHTCLICK"] = "在右鍵點擊時"
L["SOUND_EVENT_ONRIGHTCLICK_DESC"] = "在圖示鎖定的情況下，當你用|cff7fffff右鍵點擊|r這個圖示時觸發此事件。"
L["SOUND_EVENT_ONSHOW"] = "在顯示時"
L["SOUND_EVENT_ONSHOW_DESC"] = "當圖示顯示時觸發此事件（即使 %q 已勾選）。"
L["SOUND_EVENT_ONSPELL"] = "在法術改變時"
L["SOUND_EVENT_ONSPELL_DESC"] = "當圖示顯示資訊中的法術/物品/等改變時觸發此事件。"
L["SOUND_EVENT_ONSTACK"] = "在堆疊數量改變時"
L["SOUND_EVENT_ONSTACK_DESC"] = [=[此事件在圖示所檢查的法術/物品等的堆疊數量發生改變時觸發。

包括逐漸降低的%s圖示。]=]
L["SOUND_EVENT_ONSTACKDEC"] = "在疊加數量減少時"
L["SOUND_EVENT_ONSTACKINC"] = "在疊加數量增加時"
L["SOUND_EVENT_ONSTART"] = "在開始時"
L["SOUND_EVENT_ONSTART_DESC"] = "當冷卻開始，增益/減益開始作用，等類似的情況下觸發此事件。"
L["SOUND_EVENT_ONUIERROR"] = "在戰鬥錯誤事件發生時"
L["SOUND_EVENT_ONUIERROR_DESC"] = "此事件在圖示處理一個戰鬥錯誤事件時觸發。"
L["SOUND_EVENT_ONUNIT"] = "在單位改變時"
L["SOUND_EVENT_ONUNIT_DESC"] = "當圖示顯示資訊中的單位改變時觸發此事件。"
L["SOUND_EVENT_WHILECONDITION"] = "當設定的條件通過時"
L["SOUND_EVENT_WHILECONDITION_DESC"] = "此類型的通知事件會在你設定的條件通過時觸發。"
L["SOUND_SOUNDTOPLAY"] = "要播放的音效"
L["SOUND_TAB"] = "音效"
L["SOUND_TAB_DESC"] = "設定用於播放的聲音。你可以使用LibSharedMedia的聲音或者指定一個聲音檔案。"
L["SOUNDERROR1"] = "檔案必須有一個副檔名!"
L["SOUNDERROR2"] = [=[魔獸世界4.0+不支援自訂WAV檔案

（WoW自帶WAV音效可以使用）]=]
L["SOUNDERROR3"] = "只支援OGG和MP3檔案!"
L["SPEED"] = "單位速度"
L["SPEED_DESC"] = [=[這是指單位當前的移動速度，如果單位不移動則為0。
如果您要檢查單位的最高奔跑速度，可以使用'單位奔跑速度'條件來代替。]=]
L["SpeedBoosts"] = "速度提升"
L["SPELL_EQUIV_REMOVE_FAILED"] = "警告：嘗試把「%q」從法術列表「%q」中移除，但是無法找到。"
L["SPELLCHARGES"] = "法術次數"
L["SPELLCHARGES_DESC"] = "檢查像是%s或%s此類法術的可用次數。"
L["SPELLCHARGES_FULLYCHARGED"] = "完全恢復"
L["SPELLCHARGETIME"] = "法術次數恢復計時"
L["SPELLCHARGETIME_DESC"] = "檢查像是%s或%s恢復一次充能還需多少時間。"
L["SPELLCOOLDOWN"] = "法術冷卻"
L["SPELLREACTIVITY"] = "法術反應（激活/觸發/可用）"
L["SPELLTOCHECK"] = "要檢查的法術"
L["SPELLTOCOMP1"] = "進行比較的第一個法術"
L["SPELLTOCOMP2"] = "進行比較的第二個法術"
L["STACKALPHA_DESC"] = "設定在你要求的堆疊數量不符合時圖示需顯示的可視度。"
L["STACKS"] = "堆疊數量"
L["STACKSPANEL_TITLE2"] = "堆疊數量限定"
L["STANCE"] = "姿態"
L["STANCE_DESC"] = [=[你可以利用分號（;）輸入多個用於檢查的姿態。

此條件會在任意一個姿態相符時通過。]=]
L["STANCE_LABEL"] = "姿態"
L["STRATA_BACKGROUND"] = "背景（最低）"
L["STRATA_DIALOG"] = "對話框"
L["STRATA_FULLSCREEN"] = "全螢幕"
L["STRATA_FULLSCREEN_DIALOG"] = "全螢幕對話框"
L["STRATA_HIGH"] = "高"
L["STRATA_LOW"] = "低"
L["STRATA_MEDIUM"] = "中"
L["STRATA_TOOLTIP"] = "提示資訊（最高）"
L["Stunned"] = "擊暈"
L["SUG_BUFFEQUIVS"] = "同類型增益"
L["SUG_CLASSSPELLS"] = "已知的玩家/寵物法術"
L["SUG_DEBUFFEQUIVS"] = "同類型減益"
L["SUG_DISPELTYPES"] = "驅散類型"
L["SUG_FINISHHIM"] = "馬上結束快取"
L["SUG_FINISHHIM_DESC"] = "|cff7fffff點擊|r快速完成該快取/篩選過程。友情提示：您的電腦可能會因此停格幾秒鐘的時間。"
L["SUG_FIRSTHELP_DESC"] = [=[這是一個提示與建議列表，它可以顯示相關的條目供你選擇以加快設定速度。

|cff7fffff滑鼠點擊|r或使用鍵盤|cff7fffff上/下|r箭頭和|cff7fffffTab|r插入條目。

如果你只需要插入名稱，可以無視條目的ID是否正確，只要名稱完全相同即可。

大部分情況下，用名稱來檢查是比較好的選擇。在同個名稱存在多個不同效果可能發生重疊的情況下你才需要使用ID來檢查。

如果你輸入的是一個名稱，則|cff7fffff右鍵點擊|r條目會插入一個ID，反之亦然，你輸入的是ID則|cff7fffff右鍵點擊|r會插入一個名稱。]=]
L["SUG_INSERT_ANY"] = "|cff7fffff點擊滑鼠|r"
L["SUG_INSERT_LEFT"] = "|cff7fffff點擊左鍵|r"
L["SUG_INSERT_RIGHT"] = "|cff7fffff點擊右鍵|r"
L["SUG_INSERT_TAB"] = "或者按|cff7fffffTab|r鍵"
L["SUG_INSERTEQUIV"] = "%s插入同類型條目"
L["SUG_INSERTERROR"] = "%s插入錯誤訊息"
L["SUG_INSERTID"] = "%s插入編號（ID）"
L["SUG_INSERTITEMSLOT"] = "%s插入物品對應的裝備欄位編號"
L["SUG_INSERTNAME"] = "%s插入名稱"
L["SUG_INSERTNAME_INTERFERE"] = [=[|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffffa500CAUTION:|TInterface\AddOns\TellMeWhen\Textures\Alert:0:2|t|cffff1111
此法術可能有多個效果。
如果使用名稱可能無法被正確的檢查。
你應當使用一個ID來檢查。 |r]=]
L["SUG_INSERTTEXTSUB"] = "%s插入標籤"
L["SUG_INSERTTUNITID"] = "%s插入單位ID"
L["SUG_MISC"] = "雜項"
L["SUG_MODULE_FRAME_LIKELYADDON"] = "猜測來源：%s"
L["SUG_NPCAURAS"] = "已知NPC的增益/減益"
L["SUG_OTHEREQUIVS"] = "其他同類型"
L["SUG_PATTERNMATCH_FISHINGLURE"] = "魚餌%（%+%d+釣魚技能%）"
L["SUG_PATTERNMATCH_SHARPENINGSTONE"] = "磨利%（%+%d+傷害%）"
L["SUG_PATTERNMATCH_WEIGHTSTONE"] = "增重%（%+%d+傷害%）"
L["SUG_PLAYERAURAS"] = "已知玩家/寵物的增益/減益"
L["SUG_PLAYERSPELLS"] = "你的法術"
L["SUG_TOOLTIPTITLE"] = [=[當你輸入時，TellMeWhen將會在快取中查找並提示你最有可能輸入的法術。

法術按照以下列表分類跟著色。
注意：在記錄到相應的數據之前或是在你沒有登入过其他職業的情況下不會把那些法術放入"已知"開頭的分類中。

點擊一個條目將其插入到編輯框。

]=]
L["SUG_TOOLTIPTITLE_GENERIC"] = [=[當你輸入時，TellMeWhen會嘗試確定你想要輸入的內容。

在某些情況下，建議列表中可能顯示了錯誤的內容。你可以不用選擇建議列表中的條目- 當你輸入編輯框的（正確）內容越長時，TellMeWhen越不容易發生這樣的情況。

點擊一個條目把它插入到編輯框中。]=]
L["SUG_TOOLTIPTITLE_TEXTSUBS"] = [=[下列的單位變數可以使用在輸出顯示的文字內容中。變數將會被替換成與其相應的內容後再輸出顯示。

點擊一個條目將其插入到編輯框中。]=]
L["SUGGESTIONS"] = "提示與建議："
L["SUGGESTIONS_DOGTAGS"] = "DogTags："
L["SUGGESTIONS_SORTING"] = "排序中……"
L["SUN"] = "日蝕"
L["SWINGTIMER"] = "揮擊計時"
L["TABGROUP_GROUP_DESC"] = "設置 TellMeWhen 分組。"
L["TABGROUP_ICON_DESC"] = "設置 TellMeWhen 圖標。"
L["TABGROUP_MAIN_DESC"] = "TellMeWhen綜合設置"
L["TEXTLAYOUTS"] = "文字顯示樣式"
L["TEXTLAYOUTS_ADDANCHOR"] = "新增依附錨點"
L["TEXTLAYOUTS_ADDANCHOR_DESC"] = "點擊增加一個文字依附錨點。"
L["TEXTLAYOUTS_ADDLAYOUT"] = "創建新的文字顯示樣式"
L["TEXTLAYOUTS_ADDLAYOUT_DESC"] = "創建一個你可自行更改設定並應用到圖示的新文字顯示樣式。"
L["TEXTLAYOUTS_ADDSTRING"] = "新增文字顯示方案"
L["TEXTLAYOUTS_ADDSTRING_DESC"] = "新增一個文字顯示方案到此文字顯示樣式中。"
L["TEXTLAYOUTS_BLANK"] = "（空白）"
L["TEXTLAYOUTS_CHOOSELAYOUT"] = "選擇文字顯示樣式……"
L["TEXTLAYOUTS_CHOOSELAYOUT_DESC"] = "選取你要用於此圖示的文字顯示樣式。"
L["TEXTLAYOUTS_CLONELAYOUT"] = "克隆文字顯示樣式"
L["TEXTLAYOUTS_CLONELAYOUT_DESC"] = "點擊創建一個該顯示樣式的副本，你可以單獨修改它。"
L["TEXTLAYOUTS_DEFAULTS_BAR1"] = "計量條顯示樣式 1"
L["TEXTLAYOUTS_DEFAULTS_BAR2"] = "垂直計量條佈局1"
L["TEXTLAYOUTS_DEFAULTS_BINDINGLABEL"] = "綁定/標籤"
L["TEXTLAYOUTS_DEFAULTS_CENTERNUMBER"] = "中間數字"
L["TEXTLAYOUTS_DEFAULTS_DURATION"] = "持續時間"
L["TEXTLAYOUTS_DEFAULTS_ICON1"] = "圖示顯示樣式 1"
L["TEXTLAYOUTS_DEFAULTS_NOLAYOUT"] = "<無顯示樣式>"
L["TEXTLAYOUTS_DEFAULTS_NUMBER"] = "數字"
L["TEXTLAYOUTS_DEFAULTS_SPELL"] = "法術"
L["TEXTLAYOUTS_DEFAULTS_STACKS"] = "堆疊數量"
L["TEXTLAYOUTS_DEFAULTS_WRAPPER"] = "預設：%s"
L["TEXTLAYOUTS_DEFAULTTEXT"] = "預設顯示文字"
L["TEXTLAYOUTS_DEFAULTTEXT_DESC"] = "修改文字顯示樣式在圖示上顯示的預設文字。"
L["TEXTLAYOUTS_DEGREES"] = "%d 度"
L["TEXTLAYOUTS_DELANCHOR"] = "刪除依附錨點"
L["TEXTLAYOUTS_DELANCHOR_DESC"] = "點擊刪除此文字依附錨點"
L["TEXTLAYOUTS_DELETELAYOUT"] = "刪除顯示樣式"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_LISTING"] = "%s: ~%d |4圖示:圖示;"
L["TEXTLAYOUTS_DELETELAYOUT_CONFIRM_NUM2"] = "|cFFFF2929下列設定檔的圖示中使用了這個顯示樣式。如果你要刪除該顯示樣式，圖示將重新使用預設的顯示樣式：|r"
L["TEXTLAYOUTS_DELETELAYOUT_DESC2"] = "點擊刪除此文字顯示樣式"
L["TEXTLAYOUTS_DELETESTRING"] = "刪除文字顯示方案"
L["TEXTLAYOUTS_DELETESTRING_DESC2"] = "從文字顯示樣式中刪除這個文字顯示方案。"
L["TEXTLAYOUTS_DESC"] = "定義的文字顯示樣式能用於你設置的任意一個圖標。"
L["TEXTLAYOUTS_ERR_ANCHOR_BADANCHOR"] = "此文字佈局無法使用在這個群組顯示方式上，請選擇另外的文字佈局。 （未找到依附位置：%s）"
L["TEXTLAYOUTS_ERR_ANCHOR_BADINDEX"] = "文字佈局錯誤：文字顯示#%d嘗試依附到文字顯示#%d，但是%d不存在，所以文字顯示#%d不能正常使用。"
L["TEXTLAYOUTS_ERROR_FALLBACK"] = [=[找不到此圖示使用的文字顯示樣式。在找到相符的顯示樣式或選擇其他顯示樣式之前將使用預設文字顯示樣式。

（你是不是刪除了相關的文字顯示樣式？或只有匯入圖示而沒匯入它使用的文字顯示樣式？）]=]
L["TEXTLAYOUTS_fLAYOUT"] = "文字顯示樣式：%s"
L["TEXTLAYOUTS_FONTSETTINGS"] = "字型設定"
L["TEXTLAYOUTS_fSTRING"] = "文字顯示方案%s"
L["TEXTLAYOUTS_fSTRING2"] = "文字顯示方案 %d：%s"
L["TEXTLAYOUTS_fSTRING3"] = "文字顯示方案：%s"
L["TEXTLAYOUTS_HEADER_DISPLAY"] = "文字顯示方案"
L["TEXTLAYOUTS_HEADER_LAYOUT"] = "文字顯示樣式"
L["TEXTLAYOUTS_IMPORT"] = "匯入文字顯示樣式"
L["TEXTLAYOUTS_IMPORT_CREATENEW"] = "|cff59ff59創建|r 新的"
L["TEXTLAYOUTS_IMPORT_CREATENEW_DESC"] = [=[文字顯示樣式中已有一個跟該顯示樣式相同的唯一標識。

選擇此項創建一個新的唯一標識並匯入這個顯示樣式。]=]
L["TEXTLAYOUTS_IMPORT_NORMAL_DESC"] = "點擊以匯入文字顯示樣式。"
L["TEXTLAYOUTS_IMPORT_OVERWRITE"] = "|cFFFF5959覆寫|r 現有"
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DESC"] = [=[文字顯示樣式中已有一個跟需要匯入的顯示樣式相同的唯一標識。

選擇此項覆寫已有唯一標識的顯示樣式並匯入新的顯示樣式。那些正在使用被覆寫掉的那個文字顯示樣式的圖示都會在匯入後自動作出相應的更新。]=]
L["TEXTLAYOUTS_IMPORT_OVERWRITE_DISABLED_DESC"] = "你無法覆寫預設文字顯示樣式。"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS"] = "重設為預設值"
L["TEXTLAYOUTS_LAYOUT_SETDEFAULTS_DESC"] = "重設當前文字顯示樣式設定中所有方案的文字為預設顯示文字。"
L["TEXTLAYOUTS_LAYOUTDISPLAYS"] = [=[文字顯示方案：
%s]=]
L["TEXTLAYOUTS_LAYOUTSETTINGS"] = "顯示樣式設定"
L["TEXTLAYOUTS_LAYOUTSETTINGS_DESC"] = "點擊以設定文字顯示樣式%q。"
L["TEXTLAYOUTS_NOEDIT_DESC"] = [=[這個文字顯示樣式是TellMeWhen預設的文字顯示樣式，你無法對其作出更改。

如果你想更改的話，請克隆一份此文字顯示樣式的副本。]=]
L["TEXTLAYOUTS_POINT2"] = "文字位置"
L["TEXTLAYOUTS_POINT2_DESC"] = "將 %s 的文字顯示到錨定目標。"
L["TEXTLAYOUTS_POSITIONSETTINGS"] = "位置設定"
L["TEXTLAYOUTS_RELATIVEPOINT2_DESC"] = "將文字顯示到 %s 的錨定目標。"
L["TEXTLAYOUTS_RELATIVETO_DESC"] = "文字將依附的對象"
L["TEXTLAYOUTS_RENAME"] = "顯示樣式重新命名"
L["TEXTLAYOUTS_RENAME_DESC"] = "為此文字顯示樣式修改一個與其用途相符的名稱，讓你可以輕鬆的找到它。"
L["TEXTLAYOUTS_RENAMESTRING"] = "顯示方案重新命名"
L["TEXTLAYOUTS_RENAMESTRING_DESC"] = "為此文字顯示方案修改一個與其用途相符的名稱，讓你可以輕鬆的找到它。"
L["TEXTLAYOUTS_RESETSKINAS"] = "%q設定用於文字%q將被重設，以防止跟文字%q的新設定產生衝突。"
L["TEXTLAYOUTS_SETGROUPLAYOUT"] = "文字顯示樣式"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DDVALUE"] = "選擇顯示樣式……"
L["TEXTLAYOUTS_SETGROUPLAYOUT_DESC"] = [=[設定使用於這個群組所有圖示的文字顯示樣式。

每個圖示的文字顯示樣式也可以自行單獨設定。]=]
L["TEXTLAYOUTS_SETTEXT"] = "設定顯示文字"
L["TEXTLAYOUTS_SETTEXT_DESC"] = [=[設定用於這個文字顯示方案中的文字。

文字可能會被轉化為DogTag標記的格式，以便動態顯示資訊。 關於如何使用DogTag標記，請輸入'/dogtag'或'/dt'查看幫助。]=]
L["TEXTLAYOUTS_SIZE_AUTO"] = "自動"
L["TEXTLAYOUTS_SKINAS"] = "使用皮膚"
L["TEXTLAYOUTS_SKINAS_COUNT"] = "堆疊數量"
L["TEXTLAYOUTS_SKINAS_DESC"] = "選擇你需要用於顯示文字的Masque皮膚。"
L["TEXTLAYOUTS_SKINAS_HOTKEY"] = "綁定/標籤"
L["TEXTLAYOUTS_SKINAS_NONE"] = "無"
L["TEXTLAYOUTS_SKINAS_SKINNEDINFO"] = [=[此文字顯示皮膚由Masque設置。 

因此，當此布局用於由Masque設置外觀的TellMeWhen圖標時，下面的設置不會有任何效果。]=]
L["TEXTLAYOUTS_STRING_COPYMENU"] = "複製"
L["TEXTLAYOUTS_STRING_COPYMENU_DESC"] = "點擊打開一個此設定檔中所有已使用的顯示文字列表，你可以將它們加入到這個文字顯示方案中。"
L["TEXTLAYOUTS_STRING_SETDEFAULT"] = "重設為預設值"
L["TEXTLAYOUTS_STRING_SETDEFAULT_DESC"] = [=[重設當前文字顯示方案中的顯示文字為下列預設顯示文字，在該文字顯示樣式中的設定為：

%s]=]
L["TEXTLAYOUTS_STRINGUSEDBY"] = "已使用%d次。"
L["TEXTLAYOUTS_TAB"] = "文字顯示方案"
L["TEXTLAYOUTS_UNNAMED"] = "<未命名>"
L["TEXTLAYOUTS_USEDBY_HEADER"] = "以下設定檔在他們的圖示中使用了此顯示樣式："
L["TEXTLAYOUTS_USEDBY_NONE"] = "此魔獸世界帳號中的TellMeWhen設定檔中沒有使用這個顯示樣式。"
L["TEXTMANIP"] = "文字處理"
L["TOOLTIPSCAN"] = "法術效果變數"
L["TOOLTIPSCAN_DESC"] = "此條件類型允許你檢查某一單位的某個法術效果提示資訊上的第一個變數（數字）。 數字是由暴雪API所提供，跟你在法術效果的提示資訊中看到的數字可能會不同（像是伺服器已經在線修正，客戶端依然顯示錯誤的數字這種情況），同時也不保證一定能夠從法術效果取得一個數字，不過在大多數實際情況下都能檢查到正確的數字。"
L["TOOLTIPSCAN2"] = "提示訊息數字 #%d"
L["TOOLTIPSCAN2_DESC"] = "此條件類型將允許你檢測一個在技能提示訊息面板上找到的數字。"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["TOTEMS"] = "檢查圖騰"
L["TREEf"] = "專精：%s"
L["TRUE"] = "是"
L["UIPANEL_ADDGROUP2"] = "新建 %s 分組"
L["UIPANEL_ADDGROUP2_DESC"] = "|cff7fffff點擊|r 新建 %s 分組。"
L["UIPANEL_ALLOWSCALEIE"] = "允許圖標編輯器縮放"
L["UIPANEL_ALLOWSCALEIE_DESC"] = [=[預設情況下圖標編輯器不允許拖放更改尺寸，以便讓布局比較清新以及完美。

如果你不介意這個或者有特別的原因，那麼請啟用它。]=]
L["UIPANEL_ANCHORNUM"] = "依附錨點 %d"
L["UIPANEL_BAR_BORDERBAR"] = "進度條邊框"
L["UIPANEL_BAR_BORDERBAR_DESC"] = "設置進度條邊框"
L["UIPANEL_BAR_BORDERCOLOR"] = "邊框顏色"
L["UIPANEL_BAR_BORDERCOLOR_DESC"] = "改變圖標和進度條邊框顏色。"
L["UIPANEL_BAR_BORDERICON"] = "圖標邊框"
L["UIPANEL_BAR_BORDERICON_DESC"] = "在紋理，冷卻掃描和其他類似組件周圍設置邊框。"
L["UIPANEL_BAR_FLIP"] = "翻轉圖標"
L["UIPANEL_BAR_FLIP_DESC"] = "將紋理，冷卻掃描和其他類似的組件放置在圖標的另一側。"
L["UIPANEL_BAR_PADDING"] = "填充"
L["UIPANEL_BAR_PADDING_DESC"] = "設置圖標和計時條間距。"
L["UIPANEL_BAR_SHOWICON"] = "顯示圖標"
L["UIPANEL_BAR_SHOWICON_DESC"] = "禁用此設置可隱藏紋理，冷卻掃描和其他類似組件。"
L["UIPANEL_BARTEXTURE"] = "計量條材質"
L["UIPANEL_COLUMNS"] = "欄"
L["UIPANEL_COMBATCONFIG"] = "允許在戰鬥中進行設定"
L["UIPANEL_COMBATCONFIG_DESC"] = [=[啟用這個選項就可以在戰鬥中對TellMeWhen進行設定。

注意，這個選項會導致插件強制載入設定模塊，記憶體的佔用以及插件載入的時間都會隨之增加。

所有角色的設定檔都共同使用該選項。

|cff7fffff需要重新載入UI|cffff5959才能生效。|r]=]
L["UIPANEL_DELGROUP"] = "刪除此群組"
L["UIPANEL_DIMENSIONS"] = "尺寸"
L["UIPANEL_DRAWEDGE"] = "高亮計時器指針"
L["UIPANEL_DRAWEDGE_DESC"] = "高亮冷卻計時器指針（時鐘動畫）來突出顯示效果"
L["UIPANEL_EFFTHRESHOLD"] = "增益效率閥值"
L["UIPANEL_EFFTHRESHOLD_DESC"] = [=[輸入增益/減益的最小時間以便在它們有很高的數值時切換到更有效的檢查模式。 注意：一旦效果的數值超出所選擇的數字的限定，數值較大的效果會優先顯示，而不是按照設定的優先級順序。
]=]
L["UIPANEL_FONT_DESC"] = "選擇圖示堆疊數量文字的字型"
L["UIPANEL_FONT_HEIGHT"] = "高"
L["UIPANEL_FONT_HEIGHT_DESC"] = [=[設定顯示文字的最大高度。如果設為0將自動使用可能的最大高度。

如果這個顯示文字依附於底部或頂部可能會無效。]=]
L["UIPANEL_FONT_JUSTIFY"] = "文字橫向對齊校準"
L["UIPANEL_FONT_JUSTIFY_DESC"] = "設定該文字顯示方案中文字的橫向對齊位置校準（左/中/右）。 "
L["UIPANEL_FONT_JUSTIFYV"] = "文字垂直對齊校準"
L["UIPANEL_FONT_JUSTIFYV_DESC"] = "設定該文字顯示方案中文字的垂直對齊位置校準（左/中/右）。"
L["UIPANEL_FONT_OUTLINE"] = "文字描邊"
L["UIPANEL_FONT_OUTLINE_DESC2"] = "設置文字顯示方案的輪廓樣式。"
L["UIPANEL_FONT_ROTATE"] = "旋轉"
L["UIPANEL_FONT_ROTATE_DESC"] = [=[設定你想要文字顯示旋轉的度數。

此方法不是暴雪自帶的功能，所以可能發生一些奇怪的錯誤，我們也只能做到這了，好運。]=]
L["UIPANEL_FONT_SHADOW"] = "陰影位移"
L["UIPANEL_FONT_SHADOW_DESC"] = "更改文字陰影效果的位移數值，設定為0則停用陰影效果。"
L["UIPANEL_FONT_SIZE"] = "字體大小"
L["UIPANEL_FONT_SIZE_DESC2"] = "改變字體大小。"
L["UIPANEL_FONT_WIDTH"] = "寬"
L["UIPANEL_FONT_WIDTH_DESC"] = [=[設定顯示文字的最大寬度。如果設為0將自動使用可能的最大寬度。

如果這個顯示文字依附於左右兩側可能會無效。]=]
L["UIPANEL_FONT_XOFFS"] = "X位移"
L["UIPANEL_FONT_XOFFS_DESC"] = "附著點的X軸位移值"
L["UIPANEL_FONT_YOFFS"] = "Y位移"
L["UIPANEL_FONT_YOFFS_DESC"] = "附著點的Y軸位移值"
L["UIPANEL_FONTFACE"] = "字型"
L["UIPANEL_FORCEDISABLEBLIZZ"] = "禁用暴雪冷卻文字"
L["UIPANEL_FORCEDISABLEBLIZZ_DESC"] = "強制關閉暴雪內置的冷卻文字顯示。它在你安裝了有此類功能的插件時會自動開啟禁用。"
L["UIPANEL_GLYPH"] = "雕紋"
L["UIPANEL_GLYPH_DESC"] = "檢查你是否使用了某一特定的雕紋。"
L["UIPANEL_GROUP_QUICKSORT_DEFAULT"] = "按照ID排序"
L["UIPANEL_GROUP_QUICKSORT_DURATION"] = "按照持續時間排序"
L["UIPANEL_GROUP_QUICKSORT_SHOWN"] = "顯示的圖標靠前"
L["UIPANEL_GROUPALPHA"] = "群組可視度"
L["UIPANEL_GROUPALPHA_DESC"] = [=[設定整個群組的可視度等級。

此選項對圖示原本的功能沒有任何影響，僅改變這個群組所有圖示的外觀。

如果你要隱藏整個群組並且仍然允許此群組下的圖示正常運作，請將此選項設定為0（該選項有點類似於圖示設定中的%q）。]=]
L["UIPANEL_GROUPNAME"] = "重命名群組"
L["UIPANEL_GROUPRESET"] = "重設位置"
L["UIPANEL_GROUPS"] = "群組"
L["UIPANEL_GROUPS_DROPDOWN"] = "選擇/創建分組"
L["UIPANEL_GROUPS_DROPDOWN_DESC"] = [=[使用此選單載入要配置的其他組，或創建新組。

您也可以|cff7fffff右鍵點擊|r在螢幕上的圖標加載該圖標的組。]=]
L["UIPANEL_GROUPS_GLOBAL"] = "|cff00c300共用|r群組"
L["UIPANEL_GROUPSORT"] = "圖示排列"
L["UIPANEL_GROUPSORT_ADD"] = "增加優先級"
L["UIPANEL_GROUPSORT_ADD_DESC"] = "為分組新增一個圖標優先級排序。"
L["UIPANEL_GROUPSORT_ADD_NOMORE"] = "無可用優先級"
L["UIPANEL_GROUPSORT_ALLDESC"] = [=[|cff7fffff點擊|r更改此排序優先級的方向。
|cff7fffff點擊並拖動|r重新排列。

拖動到底部刪除。]=]
L["UIPANEL_GROUPSORT_alpha"] = "可視度"
L["UIPANEL_GROUPSORT_alpha_1"] = "透明靠前"
L["UIPANEL_GROUPSORT_alpha_-1"] = "不透明靠前"
L["UIPANEL_GROUPSORT_alpha_DESC"] = "群組將根據圖示的可視度來排序"
L["UIPANEL_GROUPSORT_duration"] = "持續時間"
L["UIPANEL_GROUPSORT_duration_1"] = "短持續時間靠前"
L["UIPANEL_GROUPSORT_duration_-1"] = "長持續時間靠前"
L["UIPANEL_GROUPSORT_duration_DESC"] = "群組將根據圖示剩餘的持續時間來排序。"
L["UIPANEL_GROUPSORT_fakehidden"] = "%s"
L["UIPANEL_GROUPSORT_fakehidden_1"] = "總是隱藏靠後"
L["UIPANEL_GROUPSORT_fakehidden_-1"] = "總是隱藏靠前"
L["UIPANEL_GROUPSORT_fakehidden_DESC"] = "按 %q 設置的狀態對組進行排序。"
L["UIPANEL_GROUPSORT_id"] = "圖示ID"
L["UIPANEL_GROUPSORT_id_1"] = "低ID數字靠前"
L["UIPANEL_GROUPSORT_id_-1"] = "高ID數字靠前"
L["UIPANEL_GROUPSORT_id_DESC"] = "群組將根據圖示ID數字來排序。"
L["UIPANEL_GROUPSORT_PRESETS"] = "選擇預設值..."
L["UIPANEL_GROUPSORT_PRESETS_DESC"] = "從預設排序優先級列表中選擇以應用於此圖標。"
L["UIPANEL_GROUPSORT_shown"] = "顯示"
L["UIPANEL_GROUPSORT_shown_1"] = "隱藏的圖標靠前"
L["UIPANEL_GROUPSORT_shown_-1"] = "顯示的圖標靠前"
L["UIPANEL_GROUPSORT_shown_DESC"] = "群組將根據圖示是否顯示來排序。"
L["UIPANEL_GROUPSORT_stacks"] = "堆疊數量"
L["UIPANEL_GROUPSORT_stacks_1"] = "低堆疊靠前"
L["UIPANEL_GROUPSORT_stacks_-1"] = "高堆疊靠前"
L["UIPANEL_GROUPSORT_stacks_DESC"] = "群組將根據每個圖示的堆疊數量來排序。"
L["UIPANEL_GROUPSORT_value"] = "數值"
L["UIPANEL_GROUPSORT_value_1"] = "低數值靠前"
L["UIPANEL_GROUPSORT_value_-1"] = "高數值靠前"
L["UIPANEL_GROUPSORT_value_DESC"] = "按進度條值對組進行排序。 這是 %s 圖標類型提供的值。"
L["UIPANEL_GROUPSORT_valuep"] = "百分比數值"
L["UIPANEL_GROUPSORT_valuep_1"] = "低值％優先"
L["UIPANEL_GROUPSORT_valuep_-1"] = "高值％優先"
L["UIPANEL_GROUPSORT_valuep_DESC"] = "按進度條值百分比對組進行排序。 這是 %s 圖標類型提供的值。"
L["UIPANEL_GROUPTYPE"] = "群組顯示方式"
L["UIPANEL_GROUPTYPE_BAR"] = "計時條"
L["UIPANEL_GROUPTYPE_BAR_DESC"] = "群組使用圖示+進度條的方式來顯示。"
L["UIPANEL_GROUPTYPE_BARV"] = "垂直計量條"
L["UIPANEL_GROUPTYPE_BARV_DESC"] = "在分組中的圖示將會顯示垂直的計量條。"
L["UIPANEL_GROUPTYPE_ICON"] = "圖示"
L["UIPANEL_GROUPTYPE_ICON_DESC"] = "群組使用TellMeWhen傳統的圖示方式來顯示。"
L["UIPANEL_HIDEBLIZZCDBLING"] = "禁用暴雪內建的冷卻完成動畫"
L["UIPANEL_HIDEBLIZZCDBLING_DESC"] = [=[禁止暴雪增加的計時器冷卻結束時的閃光效果。

此效果暴雪新增於6.2版本。]=]
L["UIPANEL_ICONS"] = "圖示"
L["UIPANEL_ICONSPACING"] = "圖示間隔"
L["UIPANEL_ICONSPACING_DESC"] = "同組圖示彼此之間的間隔距離"
L["UIPANEL_ICONSPACINGX"] = "圖示横向間隔"
L["UIPANEL_ICONSPACINGY"] = "圖示縱向間隔"
L["UIPANEL_LEVEL"] = "框架優先級"
L["UIPANEL_LEVEL_DESC"] = "在組的層次內，應該繪制的等級。"
L["UIPANEL_LOCK"] = "鎖定位置"
L["UIPANEL_LOCK_DESC"] = "鎖定此群組，防止移動或改變比例大小"
L["UIPANEL_LOCKUNLOCK"] = "鎖定/解鎖插件"
L["UIPANEL_MAINOPT"] = "主選項"
L["UIPANEL_ONLYINCOMBAT"] = "只在戰鬥中顯示"
L["UIPANEL_PERFORMANCE"] = "性能"
L["UIPANEL_POINT"] = "依附錨點"
L["UIPANEL_POINT2_DESC"] = "將組的 %s 定位到錨定目標。"
L["UIPANEL_POSITION"] = "位置"
L["UIPANEL_PRIMARYSPEC"] = "主要天賦"
L["UIPANEL_PROFILES"] = "設定檔"
L["UIPANEL_PTSINTAL"] = "天賦使用點數（非天賦樹）"
L["UIPANEL_PVPTALENTLEARNED"] = "已學榮譽天賦"
L["UIPANEL_RELATIVEPOINT"] = "依附位置"
L["UIPANEL_RELATIVEPOINT2_DESC"] = "將 %s 的組定位到錨定目標。"
L["UIPANEL_RELATIVETO"] = "依附框架"
L["UIPANEL_RELATIVETO_DESC"] = [=[輸入'/framestack'來觀察當前滑鼠遊標所在框架的提示資訊，以便尋找需要輸入編輯框的框架名稱。

需要更多幫助，請訪問http:////www.wowpedia.org/API_Region_SetPoint]=]
L["UIPANEL_RELATIVETO_DESC_GUIDINFO"] = "當前值是另一群組的唯一識別碼。它是在該分組右鍵點擊並拖拽到另一群組並且\"依附到\"選項被選中時設定的。"
L["UIPANEL_ROLE_DESC"] = "勾選此項允許在你當前專精可以擔任這個職責時顯示群組。"
L["UIPANEL_ROWS"] = "列"
L["UIPANEL_SCALE"] = "比例"
L["UIPANEL_SECONDARYSPEC"] = "第二天賦"
L["UIPANEL_SHOWCONFIGWARNING"] = "顯示設置模式警告"
L["UIPANEL_SPEC"] = "雙天賦"
L["UIPANEL_SPECIALIZATION"] = "天賦類型"
L["UIPANEL_SPECIALIZATIONROLE"] = "專精職責"
L["UIPANEL_SPECIALIZATIONROLE_DESC"] = "檢查你當前專精所能滿足的職責（坦克，治療，傷害輸出）。"
L["UIPANEL_STRATA"] = "框架層級"
L["UIPANEL_STRATA_DESC"] = "應該繪制組的UI的層。"
L["UIPANEL_SUBTEXT2"] = [=[圖示僅在鎖定後開始工作。

在未鎖定時，你可以變更大小或移動圖示群組，右鍵點擊圖示開啟設定頁面。

你可以輸入「/tellmewhen」或「/tmw」來鎖定、解鎖。]=]
L["UIPANEL_TALENTLEARNED"] = "已學天賦"
L["UIPANEL_TOOLTIP_COLUMNS"] = "設定此群組的欄數"
L["UIPANEL_TOOLTIP_GROUPRESET"] = "重設此群組位置跟比例"
L["UIPANEL_TOOLTIP_ONLYINCOMBAT"] = "勾選此項讓該群組只在戰鬥中顯示"
L["UIPANEL_TOOLTIP_ROWS"] = "設定此群組的列數"
L["UIPANEL_TOOLTIP_UPDATEINTERVAL"] = [=[設定圖示顯示/隱藏、可見度、條件等的檢查頻率（秒）。

0為最快。低階電腦設定數值過低會使幀數明顯降低。]=]
L["UIPANEL_TREE_DESC"] = "勾選來允許該組在某個天賦樹激活時顯示，或者不勾選讓它在天賦樹沒激活時隱藏。"
L["UIPANEL_UPDATEINTERVAL"] = "更新頻率"
L["UIPANEL_USE_PROFILE"] = "使用設定檔設置"
L["UIPANEL_WARNINVALIDS"] = "提示無效圖示"
L["UIPANEL_WARNINVALIDS_DESC"] = [=[如果勾選此項， TellMeWhen會在檢測到你的圖標存在無效的設置時警告你。

非常推薦開啟這個選項，某些錯誤的設置可能會讓你的電腦變得非常卡。]=]
L["UNDO"] = "復原"
L["UNDO_DESC"] = "取消最後所做的更改操作。"
L["UNITCONDITIONS"] = "單位條件"
L["UNITCONDITIONS_DESC"] = [=[點擊以便設定條件在上面輸入的全部單位中篩選出你想用於檢查的每個單位。

譯者註：
單位條件可用於像是檢測團隊中哪幾個人缺少耐力，或者像是檢測團隊中的某個坦中了魔法/疾病等等，這只是我隨便舉的兩個例子，實際應用範圍更大。（兩個例子的前提都有在單位框中輸入了player，raid1-40，party1-4）]=]
L["UNITCONDITIONS_STATICUNIT"] = "<圖示單位>"
L["UNITCONDITIONS_STATICUNIT_DESC"] = "該條件將檢查正在被圖示檢查中的每個單位。"
L["UNITCONDITIONS_STATICUNIT_TARGET"] = "<圖示單位>的目標"
L["UNITCONDITIONS_STATICUNIT_TARGET_DESC"] = "該條件檢查圖示正在檢查之中的每個單位的目標。"
L["UNITCONDITIONS_TAB_DESC"] = "設定條件只讓那些你要用到的單位通過。"
L["UNITTWO"] = "第二單位"
L["UNKNOWN_GROUP"] = "<未知/不可用群組>"
L["UNKNOWN_ICON"] = "<未知/不可用圖示>"
L["UNKNOWN_UNKNOWN"] = "<未知???>"
L["UNNAMED"] = "（未命名）"
L["UP"] = "上"
L["VALIDITY_CONDITION_DESC"] = "條件中檢測的圖示是無效的 >>>"
L["VALIDITY_CONDITION2_DESC"] = "第%d個條件>>>"
L["VALIDITY_ISINVALID"] = "。"
L["VALIDITY_META_DESC"] = "整合圖示中檢查的第%d個圖示是無效的 >>>"
L["WARN_DRMISMATCH"] = [=[警告！你正在檢查遞減的法術來自兩個不同的已知分類。

在同一個遞減圖示中，用於檢查的所有法術應當使用同一遞減分類才能使圖示正常運作。

檢測到下列你所使用的法術及其分類：]=]
L["WATER"] = "水之圖騰"
L["worldboss"] = "首領"


