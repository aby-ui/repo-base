if GetLocale() ~= "zhTW" then return end
if not DBM_GUI_L then DBM_GUI_L = {} end
local L = DBM_GUI_L

L.MainFrame	= "Deadly Boss Mods"

L.TranslationByPrefix		= "翻譯:"
L.TranslationBy 			= "三皈依@暗影之月 & Imbav@聖光之願"
L.Website					= "拜訪討論/支援論壇:|cFF73C2Fhttps://discord.gg/deadlybossmods|r. 請在推特上關注@deadlybossmods或@MysticalOS"
L.WebsiteButton				= "論壇"

L.OTabBosses				= "模組"
L.OTabRaids					= "團隊"
L.OTabDungeons				= "隊伍/單獨"
L.OTabPlugins				= "核心插件"
L.OTabOptions				= "選項"
L.OTabAbout					= "關於"

L.TabCategory_OTHER			= "其它模組"
L.TabCategory_AFFIXES		= "詞綴"

L.BossModLoaded				= "%s狀態"
L.BossModLoad_now 			= [[該模組尚未載入。
當你進入相應副本時其會自動載入。
你也可以點擊該按鈕手動載入該模組。]]

L.PosX						= "X座標"
L.PosY						= "Y座標"

L.MoveMe 					= "移動"
L.Button_OK 				= "確定"
L.Button_Cancel 			= "取消"
L.Button_LoadMod 			= "載入模組"
L.Mod_Enabled				= "啟用首領模組"
L.Mod_Reset					= "讀取預設值"
L.Reset 					= "重置"
L.Import					= "匯入"

L.Enable					= "啟用"
L.Disable					= "停用"

L.NoSound					= "靜音"

L.IconsInUse				= "此模組已使用的標記"

-- Tab: Boss Statistics
L.BossStatistics			= "首領狀態"
L.Statistic_Kills			= "勝利："
L.Statistic_Wipes			= "失敗："
L.Statistic_Incompletes		= "未完成："
L.Statistic_BestKill		= "最快記錄："
L.Statistic_BestRank		= "最佳排名："

-- Tab: General Options
L.TabCategory_Options	 	= "一般選項"
L.Area_BasicSetup			= "初始DBM設置提示"
L.Area_ModulesForYou		= "哪些DBM模組適合您？"
L.Area_ProfilesSetup		= "DBM配置檔使用指南"
-- Panel: Core & GUI
L.Core_GUI 					= "核心 & 圖形界面"
L.General 					= "一般DBM核心選項"
L.EnableMiniMapIcon			= "顯示小地圖圖示"
L.UseSoundChannel			= "設置DBM警告的音效頻道"
L.UseMasterChannel			= "主聲道"
L.UseDialogChannel			= "對話聲道"
L.UseSFXChannel				= "音效聲道"
L.Latency_Text				= "設定最高延遲同步門檻:%d"

L.Button_RangeFrame			= "顯示/隱藏距離監視器"
L.Button_InfoFrame			= "顯示/隱藏訊息框架"
L.Button_TestBars			= "測試計時條"
L.Button_MoveBars			= "移動計時條"
L.Button_ResetInfoRange		= "重置訊息/距離監視器"

L.ModelOptions				= "3D模型預覽選項"
L.EnableModels				= "在首領選項中啟用3D模型預覽"
L.ModelSoundOptions			= "為模型預覽設置聲音"
L.ModelSoundShort			= SHORT
L.ModelSoundLong			= TOAST_DURATION_LONG

L.ResizeOptions			 	= "尺寸調整選項"
L.ResizeInfo				= "您可以通過點擊右下角並拖動來調整GUI的大小。"
L.Button_ResetWindowSize	= "重設GUI視窗大小"
L.Editbox_WindowWidth		= "GUI視窗寬度"
L.Editbox_WindowHeight		= "GUI視窗高度"

L.UIGroupingOptions			= "界面分組選項 (更改這些需要輸入 /reload 來重載界面)"
L.GroupOptionsBySpell		= "按照技能分組 (只支持有效的模組)"
L.GroupOptionsExcludeIcon	= "按照技能分組排除“設置標記圖示”選項 (它們將像以前一樣在“圖示”類中顯示)"
L.AutoExpandSpellGroups		= "按照技能分組自動擴展選項"
--L.ShowSpellDescWhenExpanded	= "分組擴展時繼續顯示技能描述"
L.NoDescription				= "此技能無描述說明"

-- Panel: Extra Features
L.Panel_ExtraFeatures		= "額外功能"

L.Area_SoundAlerts			= "聲音/閃爍警告選項"
L.LFDEnhance				= "使用主要或對話聲音頻道播放準備確認音效和閃爍應用程式圖示給角色確認和戰場/隨機團隊進場(I.E. 即使音效被關閉了也會發出音效而且很大聲!)"
L.WorldBossNearAlert		= "當你需要的世界首領在你附近開戰播放準備確認音效和閃爍應用程式圖示"
L.RLReadyCheckSound			= "從主要或對話音效頻道播放準備確認音效和閃爍應用程式圖示"
L.AFKHealthWarning			= "播放警告聲音和閃爍應用程式圖示假如你在暫離時被攻擊"
L.AutoReplySound			= "當接收到DBM自動回覆密語時播放警告聲和閃爍應用程式圖示"
--
L.TimerGeneral 				= "計時器選項"
L.SKT_Enabled				= "顯示目前戰鬥的最佳紀錄勝利計時器"
L.ShowRespawn				= "顯示下一次首領重生計時器"
L.ShowQueuePop				= "顯示接受彈出佇列的剩餘時間(尋求組隊、戰場..等)"
--
--Auto Logging: Logging toggles/types
L.Area_AutoLogging			= "自動記錄切換"
L.AutologBosses				= "自動使用暴雪戰鬥日誌記錄所選內容"
L.AdvancedAutologBosses		= "自動使用Transcriptor紀錄所選內容"
--Auto Logging: Global filter Options
L.Area_AutoLoggingFilters	= "自動記錄過濾"
L.RecordOnlyBosses			= "不記錄小怪的戰鬥 (只記錄首領。請於首領開打前使用 /dbm pull 以獲取數據)"

L.DoNotLogLFG				= "不記錄地城搜尋器或團隊搜尋器 (佇列的內容)"
--Auto Logging: Recorded Content types
L.Area_AutoLoggingContent	= "自動記錄內容"
L.LogCurrentMythicRaids		= "當前等級傳奇團隊副本"--Retail Only
L.LogCurrentRaids			= "當前等級團隊"
L.LogTWRaids				= "時光漫遊 或 克羅米時光團隊副本"--Retail Only
L.LogTrivialRaids			= "低等團隊副本 (低於角色等級)"
L.LogCurrentMPlus			= "當前等級傳奇+地下城"--Retail Only
L.LogCurrentMythicZero		= "當前等級傳奇0層地下城"--Retail Only
L.LogTWDungeons				= "時光漫遊 或 克羅米時光地下城"--Retail Only
L.LogCurrentHeroic			= "當前等級英雄地下城 (注意：如果您通過地城搜尋器佇列英雄並想要記錄，請關閉地城搜尋器過濾)"
--
L.Area_3rdParty				= "協力插件選項"
L.oRA3AnnounceConsumables	= "在戰鬥開始時通告oRA3消耗品檢查"
L.Area_Invite				= "邀請選項"
L.AutoAcceptFriendInvite	= "自動接受來自朋友的隊伍邀請"
L.AutoAcceptGuildInvite		= "自動接受來自公會成員的隊伍邀請"
L.Area_Advanced				= "進階選項"
L.FakeBW					= "假裝使用BigWigs版本檢查而不是用DBM版本(適合用在工會強制使用BigWigs時)"
L.AITimer					= "DBM為從未遭遇的戰鬥使用內建的AI計時器來自動生成計時條(在初期Beta或PTR首次遭遇首領時之測試非常有幫助)。注意：這可能不能正確運作在有著相同技能的多重目標上。"

-- Panel: Profiles
L.Panel_Profile				= "配置檔"
L.Area_CreateProfile		= "建立核心選項配置檔"
L.EnterProfileName			= "輸入配置檔名稱"
L.CreateProfile				= "建立預設設定值的新配置檔"
L.Area_ApplyProfile			= "套用DBM核心選項配置檔"
L.SelectProfileToApply		= "選擇配置檔套用"
L.Area_CopyProfile			= "複製DBM核心選項配置檔"
L.SelectProfileToCopy		= "選擇配置檔複製"
L.Area_DeleteProfile		= "移除DBM核心選項配置檔"
L.SelectProfileToDelete		= "選擇配置檔刪除"
L.Area_DualProfile			= "首領模組配置檔選項"
L.DualProfile				= "啟用多首領模組專精設定檔。可依據你的專精去設定不同的首領選項設定。(首領配置檔管理在首領模組頁面下)"

L.Area_ModProfile			= "從其他角色/專精複製或刪除模組設定"
L.ModAllReset				= "重置所有模組設定"
L.ModAllStatReset			= "重置所有模組狀態"
L.SelectModProfileCopy		= "複製所有設定"
L.SelectModProfileCopySound	= "只複製音效設定"
L.SelectModProfileCopyNote	= "只複製註記設定"
L.SelectModProfileDelete	= "刪除模組設定"

L.Area_ImportExportProfile	= "匯入/匯出 設定檔"
L.ImportExportInfo			= "匯入會覆寫您當前的設定檔，後果請自負。"
L.ButtonImportProfile		= "匯入設定檔"
L.ButtonExportProfile		= "匯出設定檔"

L.ImportErrorOn				= "缺少設置中的自定義聲音: %s"
L.ImportVoiceMissing		= "缺少語音包: %s"

-- Tab: Alerts
L.TabCategory_Alerts	 	= "警告"
L.Area_SpecAnnounceConfig	= "特別警告視覺和聲音指南"
L.Area_SpecAnnounceNotes	= "特別警告註記指南"
L.Area_VoicePackInfo		= "有關DBM語音包的訊息"
-- Panel: Raidwarning
L.Tab_RaidWarning 			= "警告"
L.RaidWarning_Header		= "警告選項"
L.RaidWarnColors 			= "警告顏色"
L.RaidWarnColor_1 			= "顏色1"
L.RaidWarnColor_2 			= "顏色2"
L.RaidWarnColor_3			= "顏色3"
L.RaidWarnColor_4 			= "顏色4"
L.InfoRaidWarning			= [[你可以對團隊警告的顏色及其位置進行設定。
在這裡會顯示例如“玩家X中了Y效果”之類的資訊。]]
L.ColorResetted 			= "該顏色設置已重置"
L.ShowWarningsInChat 		= "在聊天視窗中顯示通告"
L.WarningIconLeft 			= "左側顯示圖示"
L.WarningIconRight 			= "右側顯示圖示"
L.WarningIconChat 			= "在聊天視窗顯示圖示"
L.WarningAlphabetical		= "依字母排序"
L.Warn_Duration				= "警告持續時間：%0.1f秒"
L.None						= "無"
L.Random					= "隨機"
L.Outline					= "描邊"
L.ThickOutline				= "厚描邊"
L.MonochromeOutline			= "單色描邊"
L.MonochromeThickOutline	= "單色加粗描邊"
L.RaidWarnSound				= "在團隊通告時播放音效"

-- Panel: Spec Warn Frame
L.Panel_SpecWarnFrame		= "特別提示"
L.Area_SpecWarn				= "特別提示選項"
L.SpecWarn_ClassColor		= "為特別提示套用職業顏色"
L.ShowSWarningsInChat 		= "在聊天視窗中顯示特別提示"
L.SWarnNameInNote			= "使用特別提示5選項如果自訂註記有包含你的名字"
L.SpecialWarningIcon		= "在特別提示上顯示圖示"
L.ShortTextSpellname		= "使用簡短法術名稱文字(如果可用)"
L.SpecWarn_FlashFrameRepeat	= "閃爍%d次"
L.SpecWarn_Flash			= "閃爍螢幕"
L.SpecWarn_Vibrate			= "震動控制器"
L.SpecWarn_FlashRepeat		= "反覆閃爍"
L.SpecWarn_FlashColor		= "閃爍顏色:%d"
L.SpecWarn_FlashDur			= "閃爍長度:%0.1f"
L.SpecWarn_FlashAlpha		= "閃爍透明度:%0.1f"
L.SpecWarn_DemoButton		= "顯示範例"
L.SpecWarn_ResetMe			= "重置為預設值"
L.SpecialWarnSoundOption	= "設置預設音效"
L.SpecialWarnHeader1		= "類型1: 設置影響您或您的操作的普通優先級提示選擇"
L.SpecialWarnHeader2		= "類型2: 設置影響每個人的一般優先級提示選擇"
L.SpecialWarnHeader3		= "類型3: 設置高優先級提示的選擇"
L.SpecialWarnHeader4		= "類型4: 設置高優先級運行特別提示的選擇"
L.SpecialWarnHeader5		= "類型5: 設置提示選項，並在註釋中包含您的玩家名稱"

-- Panel: Generalwarnings
L.Tab_GeneralMessages 		= "聊天訊息"
L.CoreMessages				= "核心訊息選項"
L.ShowPizzaMessage 			= "在聊天視窗顯示計時器廣播訊息"
L.ShowAllVersions	 		= "當運行版本檢查時在聊天視窗顯示所有隊伍成員的首領模組版本。(如果停用，依舊顯示過期/目前總結)"
L.ShowReminders				= "顯示有關缺少子模組、禁用子模組、子模組修復、子模組過期以及仍啟用靜音模式的提醒訊息。"

L.CombatMessages			= "戰鬥訊息選項"
L.ShowEngageMessage 		= "在聊天視窗顯示開戰訊息"
L.ShowDefeatMessage 		= "在聊天視窗顯示戰勝/滅團訊息"
L.ShowGuildMessages 		= "在聊天視窗顯示公會的開戰/戰勝/滅團的訊息"
L.ShowGuildMessagesPlus		= "同時也顯示公會史詩鑰石的開戰/戰勝/滅團的訊息(需要團隊選項)"

L.Area_ChatAlerts			= "額外警告選項"
L.RoleSpecAlert				= "當你加入團隊時拾取專精不符合你目前專精顯示警告訊息"
L.CheckGear					= "開怪時顯示裝備警告訊息 (當你裝備的裝備等級低於包包裡40等以上或主手武器沒有裝備時顯示警告訊息)"
L.WorldBossAlert			= "當你的公會成員或是朋友可能在你的伺服器上開戰世界首領時顯示警告訊息(如果發送者是被戰復的會不準確)"
L.WorldBuffAlert			= "當你的伺服器的世界增益啟動時顯示警告訊息以及計時器"

L.Area_BugAlerts			= "錯誤回報警報選項"
L.BadTimerAlert				= "當DBM檢測到計時器錯誤且至少有1秒不正確時顯示聊天訊息"
L.BadIDAlert				= "當DBM檢測到使用的是無效法術或紀錄ID時顯示聊天訊息"

-- Panel: Spoken Alerts Frame
L.Panel_SpokenAlerts		= "語音警告"
L.Area_VoiceSelection		= "語音選擇"
L.CountdownVoice			= "設置主要倒數計時語音"
L.CountdownVoice2			= "設置次要倒數計時語音"
L.CountdownVoice3			= "設置第三倒數計時語音"
L.PullVoice					= "設置開怪計時器的語音"
L.VoicePackChoice			= "設置語音警告的語音包"
L.MissingVoicePack			= "缺少語音包 (%s)"
L.Area_CountdownOptions		= "倒數選項"
L.Area_VoicePackReplace		= "語音包替換選項 (選擇那些語音包要啟用、靜音以及替換)"
L.VPReplaceNote				= "注意: 語音包永遠不會更改或刪除警告聲音。\n當替換語音包時，只是被簡單地靜音。"
L.ReplacesAnnounce			= "替換提示聲音 (注意: 語音包除了階段轉換以及小怪外很少使用)"
L.ReplacesSA1				= "替換特別提示 1 聲音 (個人的 'pvp拔旗')"
L.ReplacesSA2				= "替換特別提示 2 聲音 (每個人 '當心')"
L.ReplacesSA3				= "替換特別提示 3 聲音 (高優先級的 'airhorn')"
L.ReplacesSA4				= "替換特別提示 4 聲音 (高優先級的 '快跑')"
L.ReplacesCustom			= "替換特別提示 自定義使用者設置 (每個警告)(不建議)"
L.Area_VoicePackAdvOptions	= "語音包進階選項"
L.SpecWarn_AlwaysVoice		= "總是播放所有語音警告 (即使已禁用特別警告，對團隊領隊是有用的，除此之外不建議使用)"
L.VPDontMuteSounds			= "當使用語音包時禁用常規警報的靜音 (只有當您希望在警報期間同時聽到兩者時才使用)"
L.Area_VPLearnMore          = "了解更多關於語音包以及如何使用這些選項的訊息"
L.VPLearnMore               = "|cFF73C2FBhttps://github.com/DeadlyBossMods/DBM-Retail/wiki/%5BGuide%5D-DBM-&-Voicepacks#2022-update|r"
L.Area_BrowseOtherVP		= "在Curse上瀏覽其他語言包"
L.BrowseOtherVPs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+voice|r"
L.Area_BrowseOtherCT		= "在Curse上瀏覽倒數包"
L.BrowseOtherCTs			= "|cFF73C2FBhttps://www.curseforge.com/wow/addons/search?search=dbm+count+pack|r"

-- Panel: Event Sounds
L.Panel_EventSounds				= "事件音效"
L.Area_SoundSelection			= "音效選擇 (使用滑鼠滾輪捲動選單)"
L.EventVictorySound				= "設定戰鬥勝利時的音效"
L.EventWipeSound				= "設定滅團或重置時的音效"
L.EventEngagePT					= "設定開怪倒數開始的音效"
L.EventEngageSound				= "設定戰鬥開戰時的音效"
L.EventDungeonMusic				= "設定在地城/團隊中播放的音樂"
L.EventEngageMusic				= "設置戰鬥期間播放的音樂"
L.Area_EventSoundsExtras		= "事件音效選項"
L.EventMusicCombined			= "允許在地城和戰鬥選擇的所有音效選項（更改此選項需要UI重載以生效）"
L.Area_EventSoundsFilters		= "事件音效過濾條件"
L.EventFilterDungMythicMusic	= "不要在傳奇/傳奇+難度播放地城音樂"
L.EventFilterMythicMusic		= "不要在傳奇/傳奇+難度播放戰鬥音樂"

-- Tab: Timers
L.TabCategory_Timers		= "計時條"
L.Area_ColorBytype			= "計時條分類著色指南"
-- Panel: Color by Type
L.Panel_ColorByType	 		= "計時條類型顏色"
L.AreaTitle_BarColors		= "根據計時條類型上色"
L.BarTexture 				= "計時條材質"
L.BarStyle					= "計時條動作"
L.BarDBM					= "經典 (現有的小計時條滑到大條的錨點)"
L.BarSimple					= "簡單 (小計時條消失，創建新的大計時條)"
L.BarStartColor				= "開始顏色"
L.BarEndColor 				= "結束顏色"
L.Bar_Height				= "計時條高度:%d"
L.Slider_BarOffSetX 		= "X偏移:%d"
L.Slider_BarOffSetY 		= "Y偏移:%d"
L.Slider_BarWidth 			= "寬度:%d"
L.Slider_BarScale 			= "尺寸:%0.2f"
L.BarSaturation				= "小型計時條的飽和度 (當大計時條被停用時): %0.2f"

--Types
L.BarStartColorAdd			= "開始顏色(小怪)"
L.BarEndColorAdd			= "結束顏色(小怪)"
L.BarStartColorAOE			= "開始顏色(AOE)"
L.BarEndColorAOE			= "結束顏色(AOE)"
L.BarStartColorDebuff		= "開始顏色(點名技能)"
L.BarEndColorDebuff			= "結束顏色(點名技能)"
L.BarStartColorInterrupt	= "開始顏色(中斷)"
L.BarEndColorInterrupt		= "結束顏色(中斷)"
L.BarStartColorRole			= "開始顏色(角色)"
L.BarEndColorRole			= "結束顏色(角色)"
L.BarStartColorPhase		= "開始顏色(階段轉換)"
L.BarEndColorPhase			= "結束顏色(階段轉換)"
L.BarStartColorUI			= "開始顏色(自訂)"
L.BarEndColorUI				= "結束顏色(自訂)"
--Type 7 options
L.Bar7Header				= "自訂計時條選項"
L.Bar7ForceLarge			= "總是使用大計時條"
L.Bar7CustomInline			= "使用自訂的'!'內嵌圖示"
--Dropdown Options
L.CBTGeneric				= "一般"
L.CBTAdd					= "小怪"
L.CBTAOE					= "AOE"
L.CBTTargeted				= "點名技能"
L.CBTInterrupt				= "中斷"
L.CBTRole					= "角色類型"
L.CBTPhase					= "階段轉換"
L.CBTImportant				= "重要(自訂)"
L.CVoiceOne					= "倒數語音 1"
L.CVoiceTwo					= "倒數語音 2"
L.CVoiceThree				= "倒數語音 3"

-- Panel: Timers
L.Panel_Appearance	 		= "計時條外觀"
L.Panel_Behavior	 		= "計時條動作"
L.AreaTitle_BarSetup		= "計時條外觀選項"
L.AreaTitle_Behavior		= "計時條動作選項"
L.AreaTitle_BarSetupSmall 	= "小型計時條設置"
L.AreaTitle_BarSetupHuge	= "大型計時條設置"
L.EnableHugeBar 			= "開啟大型計時條(2號計時條)"
L.BarIconLeft 				= "左側顯示圖示"
L.BarIconRight 				= "右側顯示圖示"
L.ExpandUpwards				= "計時條向上延伸"
L.FillUpBars				= "填滿計時條"
L.ClickThrough				= "禁用鼠標事件(允許你點擊穿透計時條)"
L.Bar_Decimal				= "%d秒以下顯示小數點"
L.Bar_Alpha					= "透明度: %0.1f"
L.Bar_EnlargeTime			= "計時條時間低於: %d時放大"
L.BarSpark					= "計時條閃光"
L.BarFlash					= "快結束時閃爍計時條"
L.BarSort					= "依剩餘時間排序"
L.BarColorByType			= "根據類型上色"
L.Highest					= "頂部最高"
L.Lowest					= "頂部最低"
L.NoBarFade					= "使用開始/結束顏色作為小型/大型顏色，而不是逐漸改變顏色"
L.BarInlineIcons			= "顯示嵌入圖示"
L.ShortTimerText			= "使用較短的計時器文字(如果可用時)"
L.KeepBar					= "保持計時器啟用直到技能施放"
L.KeepBar2					= "(當有支援的模組時)"
L.FadeBar					= "隱藏已超出距離技能的計時器"
L.BarSkin					= "計時條外觀"

-- Tab: Global Disables & Filters
L.TabCategory_Filters	 	= "全局禁用及過濾"
L.Area_DBMFiltersSetup		= "DBM過濾器指南"
L.Area_BlizzFiltersSetup	= "暴雪過濾器指南"
-- Panel: DBM Features
L.Panel_SpamFilter					= "DBM功能設置"
L.Area_SpamFilter_Anounces			= "全局警告禁用及過濾選項"
L.SpamBlockNoShowAnnounce			= "不顯示任何提示文字或播放警告音效"
L.SpamBlockNoShowTgtAnnounce		= "不顯示目標的提示文字或播放警告音效 (上列選項會覆蓋此選項)"
L.SpamBlockNoTrivialSpecWarnSound	= "如果相對你等級是不重要的內容則不要播放特別提示音效 (播放使用者選擇的標準提示音效替代)"

L.Area_SpamFilter_SpecRoleFilters	= "特別提示類型過濾（控制DBM要怎麼做）"
L.SpamSpecInformationalOnly			= "從特別警告中刪除所有教學文字/口語警報 (需要重載UI)。警報仍顯示和播放聲音，但將是通用和非指示性"
L.SpamSpecRoleDispel				= "完全過濾 '驅散' 警報 (完全無文字或聲音)"
L.SpamSpecRoleInterrupt				= "過濾 '打斷' 警報 (完全無文字或聲音)"
L.SpamSpecRoleDefensive				= "過濾 '減傷' 警報 (完全無文字或聲音)"
L.SpamSpecRoleTaunt					= "過濾 '嘲諷' 警報 (完全無文字或聲音)"
L.SpamSpecRoleSoak					= "過濾 '吸收' 警報 (完全無文字或聲音)"
L.SpamSpecRoleStack					= "過濾 '疊加層數' 警報 (完全無文字或聲音)"
L.SpamSpecRoleSwitch				= "過濾 '切換目標''小怪' 警報 (完全無文字或聲音)"
L.SpamSpecRoleGTFO					= "過濾 '地面有害技能' 警報 (完全無文字或聲音)"


L.Area_SpamFilter_SpecFeatures		= "特別提示功能切換"
L.SpamBlockNoSpecWarnText			= "不顯示特別提示文字"
L.SpamBlockNoSpecWarnFlash			= "特別提示時不閃爍螢幕"
L.SpamBlockNoSpecWarnVibrate		= "特別提示時不震動控制器"
L.SpamBlockNoSpecWarnSound			= "不播放特別提示音效 (如果在“語音警告”面板中啟用了語音包，則仍允許語音包)"


L.Area_SpamFilter_Timers	= "全局計時禁用及過濾選項"
L.SpamBlockNoShowTimers		= "不顯示計時器(首領模組/挑戰模式/尋求組隊/重生)"
L.SpamBlockNoShowUTimers	= "不顯示玩家送出的計時器(自訂/拉怪/休息)"
L.SpamBlockNoCountdowns		= "不播放倒數音效"

L.Area_SpamFilter_Misc		= "全局其他禁用及過濾選項"
L.SpamBlockNoSetIcon		= "不設置標記在目標上"
L.SpamBlockNoRangeFrame		= "不顯示距離框架"
L.SpamBlockNoInfoFrame		= "不顯示訊息框架"
L.SpamBlockNoHudMap			= "不要顯示HudMap"
L.SpamBlockNoNameplate		= "不要顯示名條光環 "
L.SpamBlockNoYells			= "不送出大喊至頻道"
L.SpamBlockNoNoteSync		= "不接受註記分享"

L.Area_Restore				= "DBM還原選項(DBM是否還原至使用者過去狀態)"
L.SpamBlockNoIconRestore	= "不在戰鬥結束後記住和還原團隊圖示狀態"
L.SpamBlockNoRangeRestore	= "不因模組預設值還原距離框架的狀態"

L.Area_SpamFilter			= "垃圾過濾選項"
L.DontShowFarWarnings		= "不發送距離過遠的事件提示/計時器"
L.StripServerName			= "隱藏警告、計時器、距離檢測以及資訊框架的玩家伺服器名稱"
L.FilterVoidFormSay			= "在虛空型態時不要發送圖示/倒數計時聊天喊話(仍會發送標準聊天喊話)"

L.Area_SpecFilter			= "角色職責過濾選項"
L.FilterTankSpec			= "非坦克角色職責時過濾掉坦克專精的特定警告 (註:不建議玩家關閉此選項因大多數的坦克嘲諷警告都是預設開啟。)"
L.FilterInterruptsHeader	= "過濾可中斷技能的警告基於以下行為偏好。"
L.SWFNever					= "永不"
L.FilterInterrupts			= "如果施法者不是你的目標/專注目標(總是)。"
L.FilterInterrupts2			= "如果施法者不是你的目標/專注目標(總是)或中斷在冷卻中(只適用首領)"
L.FilterInterrupts3			= "如果施法者不是你的目標/專注目標(總是)或中斷在冷卻中(首領&小怪)"
L.FilterInterrupts4			= "永遠過濾中斷警告 (你不想看到它們的時候)"
L.FilterInterruptNoteName	= "過濾可中斷技能的警告(與次數)，如果自訂註記警告沒有包含你的名字"
L.FilterDispels				= "過濾可驅散技能如果你的驅散技正在冷卻中"
L.FilterTrashWarnings		= "過濾所有小怪警告在普通與英雄以及過往版本的地城"

L.Area_PullTimer			= "開怪、休息、戰鬥和自定義計時器過濾器選項"
L.DontShowPTNoID			= "阻擋與你不同區域ID送出的開怪倒數計時條"
L.DontShowPT				= "不要顯示開怪/休息倒數計時條"
L.DontShowPTText			= "不要顯示開怪/休息提示文字"
L.DontShowPTCountdownText	= "不要顯示開怪計時倒數文字"
L.DontPlayPTCountdown		= "完全不要播放開怪/休息/開戰/自訂計時器倒數音效"
L.PT_Threshold				= "不要播放高於%d秒以上的休息/開戰/自訂倒數計時器音效"

-- Panel: Blizzard Features
L.Panel_HideBlizzard		= "暴雪內建功能設置"
L.Area_HideBlizzard			= "禁用及隱藏暴雪功能選項"
L.HideBossEmoteFrame		= "首領戰鬥時隱藏團隊首領表情框架"
L.HideWatchFrame			= "首領戰鬥時隱藏任務目標框架。如果沒有追蹤中的成就，或是不在傳奇+。"
L.HideGarrisonUpdates		= "首領戰鬥時隱藏追隨者任務完成提示"
L.HideGuildChallengeUpdates	= "首領戰鬥時隱藏公會挑戰完成提示"
L.HideQuestTooltips			= "首領戰鬥時隱藏任務目標提示"
L.HideTooltips				= "首領戰鬥時完全地隱藏滑鼠提示"
L.DisableSFX				= "首領戰鬥時禁用音效頻道（注意：如果啟用此選項，則即使戰鬥進入時音效未打開，戰鬥結束時也會打開聲音效果）"
L.DisableCinematics			= "禁用遊戲中的過場動畫"
L.OnlyFight					= "只有戰鬥中，每次動畫播放一次之後"
L.AfterFirst				= "在副本中，每次動畫播放一次之後"
L.CombatOnly				= "在任何戰鬥中停用"
L.RaidCombat				= "只在首領戰鬥中停用"

-- Panel: Privacy
L.Tab_Privacy 				= "隱私控制"
L.Area_WhisperMessages		= "密語訊息選項"
L.AutoRespond 				= "啟用戰鬥中自動密語回覆"
L.WhisperStats 				= "在密語回應中加入戰勝/滅團狀態"
L.DisableStatusWhisper 		= "停用整個團隊的狀態密語(需要為團隊領隊)。只適用於普通/英雄/傳奇難度與傳奇＋地城"
L.Area_SyncMessages			= "插件同步選項"
L.DisableGuildStatus 		= "停用進度訊息同步到公會(如果為領隊，整個隊伍都會禁用。)"
L.EnableWBSharing 			= "當同個伺服器的公會與戰網好友開怪/擊敗世界首領時共享訊息。"

-- Tab: Frames & Integrations
L.TabCategory_Frames		= "框架 & 整合"
L.Area_NamelateInfo			= "DBM名條光環資訊"
-- Panel: InfoFrame
L.Panel_InfoFrame			= "訊息框架"

-- Panel: Range
L.Panel_Range				= "距離框架"

-- Panel: Nameplate
L.Panel_Nameplates			= "名條"
L.UseNameplateHandoff		= "將名條光環請求移交給支持的名條插件 (KuiNameplates, Threat Plates, Plater) 而不是內部處理。 推薦使用此選項，因為它允許通過名條插件完成更高級的功能和配置"
L.Area_NPStyle				= "風格 (注意：僅在DBM處理名條時配置風格。)"
L.NPAuraSize				= "光環像素大小 (平方): %d"

-- Misc
L.Area_General				= "一般"
L.Area_Position				= "位置"
L.Area_Style				= "風格"

L.FontSize					= "字型大小:%d"
L.FontStyle					= "字型風格"
L.FontColor					= "文字顏色"
L.FontShadow				= "陰影"
L.FontType					= "選擇字型"

L.FontHeight	= 18
