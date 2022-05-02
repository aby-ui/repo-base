if not LOCALE_zhTW then return end

local addonName, Data = ...
local L = Data.L;

L["Allies"] = "友方"
L["allies"] = "友方"
L["ally"] = "友方"
L["Ally"] = "友方"
L["AllyIsTargeted"] = "攻擊目標是我方"
L["AllyJoined"] = "一位盟友加入了戰場"
L["AllyLeft"] = "一位盟友離開了戰場"
L["AND"] = "和"
L["AttachToObject"] = "對齊物件"
L["AttachToObject_Desc"] = "請注意，並不是每個物件都可以選擇，會依據和其他框架的相對位置而定。例如，如果已經將 PVP 天賦對齊到種族技能，而又嘗試將種族技能對齊到 PVP 天賦時，會出現錯誤訊息。"
L["Auras_Buffs_Container_Color_Desc"] = "增益效果圖示區域的外框顏色。"
L["Auras_CustomFiltering_Conditions_All"] = "全部"
L["Auras_CustomFiltering_Conditions_Any"] = "任何"
L["Auras_CustomFiltering_ConditionsMode"] = "條件模式"
L["Auras_CustomFiltering_ConditionsMode_Desc"] = "在這裡可以選擇，所選的條件要如何套用到光環。選擇 \"任何\" 時，只要符合任一條件就會顯示光環。選擇 \"全部\" 時，只有符合全部的條件才會顯示光環。"
L["Auras_Debuffs_Coloring_Enabled"] = "依據減益效果類型顯示顏色"
L["Auras_Debuffs_Coloring_Enabled_Desc"] = "啟用時，可以選擇框架邊框或倒數文字是否要依據減益效果的類型來顯示顏色 (和預設介面相同，中毒是綠色、疾病是藍色...等等)。"
L["Auras_Debuffs_Container_Color_Desc"] = "減益效果圖示區域的外框顏色。"
L["Auras_Enabled"] = "啟用光環"
L["Auras_Enabled_Desc"] = "啟用時，會顯示光環圖示，同時也會顯示剩餘時間和堆疊層數的數字。"
L["Auras_Filtering_Mode"] = "過濾模式"
L["Auras_Filtering_Mode_Desc"] = "在這裡可以選擇，哪種過濾方式要套用到光環。選擇暴雪過濾方式時，會和遊戲內建框架顯示相同的光環，或是選擇自訂過濾條件。"
L["Auras_ShowTooltips"] = "顯示法術的滑鼠提示"
L["AurasCustomConditions"] = "自訂條件"
L["AurasFiltering_AddSpellID"] = "法術 ID"
L["AurasFiltering_AddSpellID_Desc"] = "輸入一個或多個要加入到過濾清單的法術 ID，使用逗號來分隔。啟用過濾時，只會顯示法術 ID 在清單內的光環。"
L["AurasFiltering_Enabled_Desc"] = "啟用時，只會看到已經加入到過濾清單內的%s。"
L["AurasFiltering_Filterlist_Desc"] = "點一下移除這個%s。"
L["AurasFilteringSettings_Desc"] = "控制要顯示哪些光環。"
L["AurasSettings"] = "光環"
L["AurasSettings_Desc"] = "光環的設定 (增益和減益效果)。"
L["AurasStacktextSettings"] = "層數文字"
L["BarBackground"] = "背景顏色"
L["BarHeight_Desc"] = "每個橫列的高度。因為暴雪的功能保護，戰鬥中無法調整設定。"
L["BarSettings"] = "條列設定"
L["BarSettings_Desc"] = "這裡可以調整橫列。"
L["BarTexture"] = "血量條材質"
L["BarWidth_Desc"] = "每個橫列的寬度。因為暴雪的功能保護，戰鬥中無法調整設定。"
L["BattlegroundSize"] = "戰場大小"
L["BGSize_15"] = "1–15 名玩家"
L["BGSize_15_Desc"] = "在每方 1-15 名玩家的戰場，設定會套用到%s。"
L["BGSize_40"] = "16-40 名玩家"
L["BGSize_40_Desc"] = "在每方 16-40 名玩家的戰場，設定會套用到%s。"
L["BGSize_5"] = "競技場"
L["BGSize_5_Desc"] = "在競技場，設定會套用到%s。"
L["BlizzlikeAuraFiltering"] = "使用暴雪團隊框架過濾方式"
L["BorderThickness"] = "外框粗細"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["buff"] = "增益效果"
L["BuffContainer"] = "增益效果區域"
L["BuffIcon"] = "增益效果圖示"
L["Buffs"] = "增益效果"
L["Button"] = "按鈕"
L["CantAnchorToItself"] = "不能對齊到自己!"
L["CENTER"] = "中"
L["Columns"] = "直行"
L["Columns_Desc"] = "玩家要顯示成多少個直行。"
L["ConfirmProfileOverride"] = "是否確定要覆蓋子設定檔  %s，使用子設定檔 %s 取代"
L["Container_Color"] = "區域外框顏色"
L["ContainerPosition"] = "區域位置"
L["ConvertCyrillic"] = "轉換西里爾字母"
L["ConvertCyrillic_Desc"] = "不是使用俄文版遊戲時轉換西里爾字母，讓名字更容易閱讀。"
L["CopySettings"] = "從%s複製設定"
L["CopySettings_Desc"] = "點一下從%s匯入子設定檔。"
L["Countdowntext"] = "倒數時間文字"
L["CovenantIcon_Enabled"] = "啟用誓盟圖示"
L["CovenantIcon_Enabled_Desc"] = "啟用時，會在血條上顯示誓盟圖示。"
L["CovenantIcon_Size_Desc"] = "誓盟圖示的大小 (寬和高)"
L["CovenantIconSettings"] = "誓盟圖示"
L["CovenantIconSettings_Desc"] = "設定血條上所顯示的誓盟圖示"
L["CurrentVersion"] = "目前版本"
L["Curse"] = "詛咒"
L["CustomMacro_Desc"] = [=[這裡可以設定自訂巨集，空白的欄位會產生空巨集。
可用的替換符號: %n 會替換成敵人的名字。

範例:
/targetexact %n
/施放 變形術
/說 已將 %n 變羊
/targetlasttarget

這個巨集會將敵人選為目標、施放變形術、輸出一段訊息到說話頻道，然後選取前一個目標為當前目標。

請注意，巨集最長只能使用 255 個字元(包含替換後的敵人名字)。]=]
L["debuff"] = "減益效果"
L["DebuffContainer"] = "減益效果區域"
L["DebuffIcon"] = "減益效果圖示"
L["Debuffs"] = "減益效果"
L["DebuffType_Filtering"] = "依據減益效果類型過濾"
L["DebuffType_Filtering_Desc"] = "啟用時，只會看所選類型的減益效果。測試模式中不會模擬這個選項，因為需要龐大的資料庫才能模擬出魔獸海量的法術和減益效果類型。"
L["DisableArenaFrames"] = "停用競技場框架"
L["DisableArenaFrames_Desc"] = "在戰場中停用停用競技場框架，同樣適用於 sArena 插件。"
L["Disease"] = "疾病"
L["DispellFilter"] = "依據是否可驅散過濾"
L["DisplayType"] = "顯示類型"
L["Downwards"] = "向下"
L["DR_Disorient"] = "暈眩"
L["DR_Incapacitate"] = "癱瘓"
L["DR_Knockback"] = "擊退"
L["DR_Root"] = "定身"
L["DR_Silence"] = "沉默"
L["DR_Stun"] = "昏迷"
L["DRContainer"] = "控場區域"
L["DrTracking_Container_Color_Desc"] = "控場圖示區域的外框顏色。"
L["DrTracking_DisplayType_Desc"] = "選擇控場追蹤的指示要使用圖示周圍的彩色外框，還是彩色的倒數文字。請注意，沒有使用像是 OmniCC 這類型會更改文字顏色的插件時，彩色的倒數文字才能正常運作。"
L["DrTracking_Enabled"] = "啟用控場追蹤"
L["DrTracking_Enabled_Desc"] = "啟用時會在敵方的橫列旁顯示控場效果遞減的監控圖示。綠色邊框：下一個控場技能時間減半，黃色邊框：下一個控場技能時間只有四分之一，紅色邊框：下一個控場技能無效，因為玩家已經免疫。"
L["DrTracking_Spacing"] = "控場追蹤間距"
L["DrTracking_Spacing_Desc"] = "控場追蹤圖示之間的距離。"
L["DrTrackingFiltering_Enabled_Desc"] = "啟用時，只會看到過濾清單中所勾選的類別中的法術圖示。"
L["DrTrackingFiltering_Filterlist_Desc"] = "點一下以追蹤/取消追蹤這個類別。"
L["DrTrackingFilteringSettings_Desc"] = "選擇要顯示的控場追蹤類別。"
L["DrTrackingSettings"] = "控場追蹤"
L["DrTrackingSettings_Desc"] = "控場時間和遞減效果追蹤的設定。"
L["EnableClique"] = "使用 Clique 的按鍵設定"
L["EnableClique_Desc"] = "啟用時，Clique 插件會接管所有按鍵設定。"
L["Enemies"] = "敵方"
L["enemies"] = "敵方"
L["EnemiesTargetingAllies_Enabled_Desc"] = "啟用時，當一票敵人的目標是我方時，會播放通知音效。"
L["EnemiesTargetingMe_Enabled_Desc"] = "啟用時，當一票敵人的目標是你時，會播放通知音效。"
L["enemy"] = "敵方"
L["Enemy"] = "敵方"
L["EnemyJoined"] = "一個敵方玩家加入了戰場"
L["EnemyLeft"] = "一個敵方玩家離開了戰場"
L["Filtering_Enabled"] = "啟用過濾"
L["Filtering_Filterlist"] = "過濾清單"
L["FilterSettings"] = "過濾方式設定"
L["Font"] = "字體"
L["Font_Desc"] = "插件所使用的主要字體。"
L["Font_Outline"] = "文字外框"
L["Font_Outline_Desc"] = "文字的外框。"
L["Fontcolor"] = "顏色"
L["Fontcolor_Desc"] = "文字的顏色"
L["FontShadow_Enabled"] = "啟用文字陰影"
L["FontShadow_Enabled_Desc"] = "啟用時，文字周圍會顯示陰影，可以自行選擇陰影的顏色。"
L["FontShadowColor"] = "陰影顏色"
L["FontShadowColor_Desc"] = "文字陰影的顏色。"
L["Fontsize"] = "文字大小"
L["Fontsize_Desc"] = "文字的大小"
L["Frame"] = "外框"
L["Framescale"] = "縮放大小"
L["Framescale_Desc"] = "主要框架的縮放大小。因為暴雪的功能保護，戰鬥中無法調整設定。"
L["General"] = "一般"
L["GeneralSettings"] = "一般設定"
L["GeneralSettings_Desc"] = "一些基本的設定。"
L["GeneralSettingsAllies"] = "設定會套用到友方，不論戰場的大小。"
L["GeneralSettingsEnemies"] = "設定會套用到敵方，不論戰場的大小。"
L["HealthBar_Background_Desc"] = "血量條的背景顏色。"
L["HealthBar_Texture_Desc"] = "血量條的材質。"
L["HealthBarSettings"] = "血量條"
L["HealthBarSettings_Desc"] = "血量條的設定。"
L["Height"] = "高度"
L["Highlight_Color"] = "顯著標示顏色"
L["Highlight_Color_Desc"] = "滑鼠目前指向的玩家框架顏色。"
L["HorizontalGrowdirection"] = "水平增長方向"
L["HorizontalGrowdirection_Desc"] = "選擇直行要向左或向右增長。"
L["HorizontalSpacing"] = "水平間距"
L["IAmTargeted"] = "攻擊目標是我"
L["IconsPerRow"] = "每個橫列的圖示數量"
L["KeybindSettings_Desc"] = "這裡可以設定滑鼠左鍵、右鍵和中鍵點擊時的功能。"
L["LEFT"] = "左側"
L["LeftToTargetCounter"] = "目標數量的左側"
L["Leftwards"] = "向左"
L["LevelText_Enabled"] = "顯示玩家等級"
L["LevelText_OnlyShowIfNotMaxLevel"] = "只有不是滿等時才顯示等級"
L["LevelTextSettings"] = "玩家等級"
L["Locked"] = "鎖定位置"
L["Locked_Desc"] = "鎖定框架的位置。"
L["Magic"] = "魔法"
L["MainFrameSettings"] = "主要框架設定"
L["MainFrameSettings_Desc"] = "%s所使用的主要框架設定。"
L["MaxPlayers"] = "最多敵方數量"
L["MaxPlayers_Desc"] = "超過這個數字的敵方不會顯示出來。"
L["MyFocus_Color"] = "專注目標顏色"
L["MyFocus_Color_Desc"] = "用來顯著標示當前專注目標的血條外框顏色。"
L["MyTarget_Color"] = "目標顏色"
L["MyTarget_Color_Desc"] = "用來顯著標示當前目標的血條外框顏色。"
L["MyVersion"] = "你的版本是"
L["Name"] = "名字"
L["Name_Desc"] = "血條上名字的設定。"
L["NewVersionAvailable"] = "已有新版本可以使用"
L["None"] = "無"
L["Normal"] = "一般"
L["NotAvailableInCombat"] = "因為暴雪的功能保護，戰鬥中無法調整設定。"
L["Notifications_Allies_Enabled_Desc"] = "啟用時， 友方玩家加入或離開戰場時會顯示通知。"
L["Notifications_Enabled"] = "啟用通知"
L["Notifications_Enemies_Enabled_Desc"] = "啟用時， 敵方玩家加入或離開戰場時會顯示通知。"
L["NoVersion"] = "沒有找到插件"
L["NumericTargetindicator"] = "目標數量"
L["NumericTargetindicator_Enabled_Desc"] = "顯示有多少%s的當前目標是這個玩家。"
L["ObjectiveAndRespawn_ObjectiveEnabled"] = "顯示任務目標"
L["ObjectiveAndRespawn_ObjectiveEnabled_Desc"] = "在敵方按鈕旁顯示旗幟、礦車、或攜帶異能球圖示。"
L["ObjectiveAndRespawn_Position"] = "位置"
L["ObjectiveAndRespawn_Position_Desc"] = "圖示要顯示在專精圖示的左側，或是飾品/種族技能圖示的右側。"
L["ObjectiveAndRespawn_RespawnEnabled"] = "顯示重生時間"
L["ObjectiveAndRespawn_RespawnEnabled_Desc"] = "啟用時，會顯示敵人再次復活的剩餘時間圖示。"
L["ObjectiveAndRespawn_Width_Desc"] = "任務目標圖示的寬度。"
L["ObjectiveAndRespawnSettings"] = "任務目標"
L["ObjectiveAndRespawnSettings_Desc"] = "戰場任務目標的設定。"
L["OffsetX"] = "水平位置"
L["OffsetY"] = "垂直位置"
L["OldVersion"] = "舊版本"
L["PlayerCount_Enabled"] = "玩家數量"
L["PlayerCount_Enabled_Desc"] = "是否要顯示目前玩家數量的文字。請注意，這個數量可能會和目前的橫列數量不同，因為插件的戰鬥中保護功能或離開隨機戰場的人數。"
L["Point"] = "對齊點"
L["PointAtObject"] = "物件的對齊點"
L["Poison"] = "中毒"
L["Position"] = "位置"
L["PowerBar_Background_Desc"] = "能量條的背景顏色。"
L["PowerBar_Enabled"] = "啟用資源條"
L["PowerBar_Enabled_Desc"] = "啟用時，會顯示法力、怒氣等資源。"
L["PowerBar_Height_Desc"] = "資源條的高度。資源條愈高生命條就會愈窄。"
L["PowerBar_Texture_Desc"] = "能量條的材質。"
L["PowerBarSettings"] = "能量條"
L["PowerBarSettings_Desc"] = "資源條的設定。"
L["Racial_Enabled"] = "啟用種族特長"
L["Racial_Enabled_Desc"] = "啟用時，會顯示已使用的種族特長圖示。"
L["Racial_Width_Desc"] = "種族技能的寬度。"
L["RacialFiltering_Enabled_Desc"] = "啟用時，只會看到過濾清單中所勾選的種族技能。"
L["RacialFiltering_Filterlist_Desc"] = "點一下以監控/取消監控這個種族技能。"
L["RacialFilteringSettings_Desc"] = "在這裡選擇要追蹤的種族技能。"
L["RacialSettings"] = "種族特長"
L["RacialSettings_Desc"] = "種族特長的設定。"
L["RangeIndicator_Alpha"] = "透明度"
L["RangeIndicator_Alpha_Desc"] = "敵人超出指定距離時，敵方框架的透明度。"
L["RangeIndicator_Enabled"] = "啟用距離指示"
L["RangeIndicator_Enabled_Desc"] = "啟用時，敵人超出指定距離時，敵方框架會顯示成指定的透明度。"
L["RangeIndicator_Everything"] = "更改全部的透明度"
L["RangeIndicator_Frames"] = "更改透明度"
L["RangeIndicator_Frames_Desc"] = "當敵人超出距離範圍時，橫列的哪個部分要變得比較透明。"
L["RangeIndicator_Range"] = "距離範圍"
L["RangeIndicator_Range_Desc"] = "敵人在這個距離 (碼) 以外時，敵方框架會顯示成指定的透明度。"
L["RangeIndicator_Settings"] = "距離指示"
L["RangeIndicator_Settings_Desc"] = "這裡可以調整距離指示。"
L["RBGSpecificSettings"] = "積分戰場"
L["RBGSpecificSettings_Desc"] = "這些設定只會套用到積分戰場。"
L["RIGHT"] = "右側"
L["Rightwards"] = "向右"
L["RoleIcon_Enabled"] = "啟用角色圖示"
L["RoleIcon_Enabled_Desc"] = "啟用時，會在血量條上顯示角色圖示。"
L["RoleIcon_Size_Desc"] = "角色圖示的大小 (寬和高)。"
L["RoleIconSettings"] = "角色圖示"
L["RoleIconSettings_Desc"] = "血量條上面的角色圖示設定。"
L["ShowDispellable"] = "顯示可驅散的"
L["ShowDispellable_Desc"] = "顯示我可以使用驅散、淨化...等移除的%s。"
L["ShowMine"] = "顯示我的"
L["ShowMine_Desc"] = "顯示我施放的%s。"
L["ShowNumbers"] = "顯示數字"
L["ShowNumbers_Desc"] = "顯示冷卻時間數字，請注意，使用 OmniCC 插件時，此選項會沒有作用。"
L["ShowRealmnames"] = "顯示伺服器"
L["ShowRealmnames_Desc"] = "顯示敵方的伺服器名稱。"
L["ShowTooltips"] = "顯示滑鼠提示"
L["ShowTooltips_Desc"] = "滑鼠指向飾品或光環圖示等物件時顯示滑鼠提示。"
L["Side"] = "方向"
L["SideAtObject"] = "物件的方向"
L["Size"] = "大小"
L["SourceFilter"] = "依據來源過濾"
L["Spec_AuraDisplay_Enabled"] = "顯示光環"
L["Spec_AuraDisplay_Enabled_Desc"] = "啟用時，會顯示群體控場和斷法技能的圖示 (有啟用時)，取代專精圖示。"
L["Spec_Enabled"] = "啟用專精"
L["Spec_Enabled_Desc"] = "啟用時，會顯示玩家專精的圖示。"
L["Spec_Width_Desc"] = "專精圖示的寬度。"
L["SpecSettings"] = "專精"
L["SpecSettings_Desc"] = "專精圖示的設定。"
L["SpellID_Filtering"] = "依據法術 ID 過濾"
L["SymbolicTargetindicator_Enabled"] = "目標符號"
L["SymbolicTargetindicator_Enabled_Desc"] = "在當前目標是玩家的%s上顯示方形的職業顏色圖示。"
L["TargetAmount"] = "目標數量"
L["TargetAmount_Ally"] = "當隊友被超過指定數量的敵方選為目標時，就會立刻播放聲音。 "
L["TargetAmount_Me"] = "當你被超過指定數量的敵方選為目標時，就會立刻播放聲音。 "
L["TargetCallerUpdated"] = "是目前的發號施令者"
L["TargetCalling"] = "發號施令"
L["TargetCallingNotificationEnable"] = "啟用音效通知"
L["TargetCallingNotificationEnable_Desc"] = "通知你有新的目標 (偵測骷髏頭標)"
L["TargetCallingSetMark"] = "幫我的目標上骷髏頭標"
L["TargetCallingSetMark_Desc"] = "當你是團隊隊長，而且隊中沒有團隊助理時，自動將你的當前目標標記骷髏圖示。當你不是隊長，但是助理時，也會上標記。"
L["TargetCallingShowIcon"] = "發號施令者的目標要顯示圖示"
L["TargetCallingShowIcon_Desc"] = "啟用時，發號施令者的當前目標的框架上面會顯示圖示。"
L["TargetCallingSoundEnable"] = "有新目標時通知我"
L["TargetCallingSoundEnable_Desc"] = "啟用時，發號施令者選取了新的目標時，會播放音效。"
L["TargetCallingSoundSound"] = "通知音效"
L["TargetIndicator"] = "目標指示"
L["TargetIndicator_Desc"] = "數字和符號的目標指示器。"
L["Testmode_Toggle"] = "切換測試模式"
L["Testmode_Toggle_Desc"] = [=[啟用/停用測試模式，更容易觀察調整設定選項時的變化。無法模擬全部的選項效果，但在這個華麗的測試模式中，已經包含了絕大部分。

已經在戰場中時，會停用測試模式。]=]
L["Testmode_ToggleAnimation"] = "切換測試動畫"
L["Testmode_ToggleAnimation_Desc"] = "啟用/停用測試模式的動畫效果，以便能夠更專注於設定某個選項，而不會被動畫干擾。"
L["TestmodeSettings"] = "測試模式"
L["Thick"] = "飾品"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["Trinket_Enabled"] = "啟用飾品"
L["Trinket_Enabled_Desc"] = "啟用時會顯示鬥士徽章等飾品圖示。"
L["Trinket_Width_Desc"] = "飾品的寬度。"
L["TrinketSettings"] = "飾品"
L["TrinketSettings_Desc"] = "飾品的設定。"
L["Upwards"] = "向上"
L["UseBarHeight"] = "使用橫列高度"
L["UserDefined"] = "玩家自訂的"
L["VerticalGrowdirection"] = "垂直增長方向"
L["VerticalGrowdirection_Desc"] = "選擇橫列要向上或向下增長。"
L["VerticalPosition"] = "垂直位置"
L["VerticalSpacing"] = "垂直間距"
L["Width"] = "寬度"
