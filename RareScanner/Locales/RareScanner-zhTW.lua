-- Locale
local AceLocale = LibStub:GetLibrary("AceLocale-3.0");
local AL = AceLocale:NewLocale("RareScanner", "zhTW", false);

if AL then
	AL["ALARM_MESSAGE"] = "一個稀有NPC剛剛出現，檢查你的地圖！"
	AL["ALARM_SOUND"] = "稀有NPC的通告聲音"
	AL["ALARM_SOUND_DESC"] = "稀有NPC出現在小地圖上時撥放的聲音。"
	AL["ALARM_TREASURES_SOUND"] = "事件/寶箱的通告聲音"
	AL["ALARM_TREASURES_SOUND_DESC"] = "事件/寶箱出現在小地圖上時撥放的聲音。"
	AL["ALL_ZONES"] = "- 全部 -"
	AL["APPLY_COLLECTIONS_LOOT_FILTERS"] = "你想修改戰利品欄和世界地圖中顯示的戰利品，使其只顯示找到的缺失收藏品嗎？這將覆蓋您當前的戰利品過濾器（這不適用於單個過濾器）。"
	AL["AUTO_HIDE_BUTTON"] = "自動隱藏按鈕與小圖像"
	AL["AUTO_HIDE_BUTTON_DESC"] = "超過選擇的時間後自動隱藏按鈕與小圖像 (以秒為單位)。設為0秒時不會自動隱藏。"
	AL["CHANNEL_AMBIENCE"] = "環境"
	AL["CHANNEL_DIALOG"] = "對話"
	AL["CHANNEL_MASTER"] = "主要"
	AL["CHANNEL_MUSIC"] = "音樂"
	AL["CHANNEL_SFX"] = "特效"
	AL["CLASS_HALLS"] = "職業大廳"
	AL["CLEAR_FILTERS_SEARCH"] = "顯示全部"
	AL["CLEAR_FILTERS_SEARCH_DESC"] = "重設之前的搜尋並且顯示完整的清單"
	AL["CLICK_TARGET"] = "點一下將NPC設為目標"
	AL["CMD_DISABLE_ALERTS"] = "RareScanner稀有NPC、財寶以及事件警報已停用"
	AL["CMD_DISABLE_CONTAINERS_ALERTS"] = "RareScanner財寶警報已停用"
	AL["CMD_DISABLE_EVENTS_ALERTS"] = "RareScanner事件警報已停用"
	AL["CMD_DISABLE_RARES_ALERTS"] = "RareScanner稀有NPC警報已停用"
	AL["CMD_DISABLE_SCANNING_WORLDMAP_VIGNETTES"] = "RareScanner 掃描世界地圖插圖已禁用"
	AL["CMD_ENABLE_ALERTS"] = "RareScanner稀有NPC、財寶以及事件警報已啟用"
	AL["CMD_ENABLE_CONTAINERS_ALERTS"] = "RareScanner財寶警報已啟用"
	AL["CMD_ENABLE_EVENTS_ALERTS"] = "RareScanner事件警報已啟用"
	AL["CMD_ENABLE_RARES_ALERTS"] = "RareScanner稀有NPC警報已啟用"
	AL["CMD_ENABLE_SCANNING_WORLDMAP_VIGNETTES"] = "RareScanner 掃描世界地圖插圖已啟用"
	AL["CMD_HELP1"] = "命令列表"
	AL["CMD_HELP10"] = "啟用/禁用掃描世界地圖插圖"
	AL["CMD_HELP11"] = "在世界地圖上顯示/隱藏龍形的圖示"
	AL["CMD_HELP2"] = "顯示/隱藏所有世界地圖的圖示"
	AL["CMD_HELP3"] = "顯示/隱藏世界地圖事件的圖示"
	AL["CMD_HELP4"] = "顯示/隱藏世界地圖財寶的圖示"
	AL["CMD_HELP5"] = "顯示/隱藏世界地圖稀有NPC的圖示"
	AL["CMD_HELP6"] = "啟用/停用所有警報"
	AL["CMD_HELP7"] = "啟用/停用事件警報"
	AL["CMD_HELP8"] = "啟用/停用財寶警報"
	AL["CMD_HELP9"] = "啟用/停用稀有NPC警報"
	AL["CMD_HIDE"] = "隱藏世界地圖上所有 RareScanner 圖示"
	AL["CMD_HIDE_DRAGON_GLYPHS"] = "在世界地圖上隱藏RareScanner龍形圖示"
	AL["CMD_HIDE_EVENTS"] = "隱藏世界地圖上 RareScanner 事件圖示"
	AL["CMD_HIDE_RARES"] = "隱藏世界地圖上 RareScanner 稀有NPC圖示"
	AL["CMD_HIDE_TREASURES"] = "隱藏世界地圖上 RareScanner 寶箱圖示"
	AL["CMD_SHOW"] = "顯示世界地圖上所有的 RareScanner 圖示"
	AL["CMD_SHOW_DRAGON_GLYPHS"] = "在世界地圖上顯示RareScanner龍形圖示"
	AL["CMD_SHOW_EVENTS"] = "顯示世界地圖上 RareScanner 事件圖示"
	AL["CMD_SHOW_RARES"] = "顯示世界地圖上 RareScanner 稀有NPC圖示"
	AL["CMD_SHOW_TREASURES"] = "顯示世界地圖上 RareScanner 寶箱圖示"
	AL["COLLECTION_FILTERS_PROFILE_BACKUP_CREATED"] = "根據名為 %s 的當前設定檔創建了一個新設定檔。"
	AL["CONTAINER"] = "箱子"
	AL["CONTAINER_FILTER"] = "容器過濾"
	AL["CUSTOM_NPC_ADD_NPC"] = "NPC ID"
	AL["CUSTOM_NPC_ADD_NPC_DESC"] = "輸入 NPC ID 後按Enter鍵添加新的自定義NPC。NPC ID 是唯一的數字用於標識魔獸世界中的 NPC。您可以在 Wowhead 或類似網站上找到這些標識號。"
	AL["CUSTOM_NPC_ADD_NPC_EXISTS_RS"] = "此NPC已經被RareScanner所支援。"
	AL["CUSTOM_NPC_ADD_NPC_NOEXIST"] = "輸入的 NPC ID 未被找到。有時伺服器需要一段時間才能返回其訊息，因此請重試，如果錯誤仍然存在，請驗證 ID 是否正確。"
	AL["CUSTOM_NPC_ADD_ZONE"] = "加入區域"
	AL["CUSTOM_NPC_ADD_ZONE_DESC"] = "將該區域加入到可以找到該 NPC 的區域列表中。"
	AL["CUSTOM_NPC_COORDINATES"] = "座標"
	AL["CUSTOM_NPC_COORDINATES_DESC"] = "（可選）NPC 可能刷新的座標。用以下格式輸入座標：X1-Y1,X2-Y2,…例如：0614-6712,75152-4123（表示 NPC 可以在座標“6.14-67.12”和“75.152-41.23”處刷新）。骷髏圖示將出現在地圖的第一組坐標處。其餘的坐標將在覆蓋層中使用。"
	AL["CUSTOM_NPC_CURRENT_ZONE"] = "區域"
	AL["CUSTOM_NPC_CURRENT_ZONE_DESC"] = "可以在其中找到此NPC的區域。"
	AL["CUSTOM_NPC_CURRENT_ZONES"] = "可以在其中找到此NPC的區域"
	AL["CUSTOM_NPC_DELETE_NPC"] = "刪除此NPC"
	AL["CUSTOM_NPC_DELETE_NPC_CONFIRM"] = "確定要從NPC列表中刪除“%s”？"
	AL["CUSTOM_NPC_DELETE_NPC_DESC"] = "從數據庫中刪除此自定義 NPC。"
	AL["CUSTOM_NPC_DELETE_ZONE"] = "刪除區域"
	AL["CUSTOM_NPC_DELETE_ZONE_CONFIRM"] = "確定要從可以找到該 NPC 的區域列表中刪除該區域及其坐標？"
	AL["CUSTOM_NPC_DELETE_ZONE_DESC"] = "從可以找到該 NPC 的區域列表中刪除該區域。"
	AL["CUSTOM_NPC_DISPLAY_ID"] = "顯示ID"
	AL["CUSTOM_NPC_DISPLAY_ID_DESC"] = "（可選）顯示 ID是標識 NPC 模型的唯一數字。用於在按鈕頂部按鈕顯示找到 NPC 的縮略圖。可以在 Wowhead 或類似網站上找到此標識號。"
	AL["CUSTOM_NPC_EXTRA_INFO"] = "可選額外訊息"
	AL["CUSTOM_NPC_FIND_ZONES"] = "選擇一個可以找到此NPC的區域"
	AL["CUSTOM_NPC_INFO"] = "警告：在您加入區域之前不會記錄NPC。"
	AL["CUSTOM_NPC_LOOT"] = "拾取"
	AL["CUSTOM_NPC_LOOT_DESC"] = "（可選）此 NPC 可拾取的戰利品的物品ID。輸入具有以下格式的物品 ID：ID1,ID2,…例如：184198,184198。可以在 Wowhead 或類似網站上找到這些標識號。"
	AL["CUSTOM_NPC_TEXT"] = "重要：RareScanner 使用自定義 NPC 姓名板掃描，因此不要忘記啟用它們，否則您將不會收到有關它們的警報。"
	AL["CUSTOM_NPC_VALIDATION_CHAR"] = "輸入的值包含與“％s”不同的字符"
	AL["CUSTOM_NPC_VALIDATION_COORD"] = "輸入的坐標不正確。字符串應具有以下格式：X1-Y1,X2-Y2,…"
	AL["CUSTOM_NPC_VALIDATION_ITEM"] = "輸入的物品 ID不正確。字符串應具有以下格式：ID1,ID2,…"
	AL["CUSTOM_NPC_VALIDATION_NUMBER"] = "輸入的值必須是數字。"
	AL["CUSTOM_NPCS"] = "自定義NPC"
	AL["CYPHER_CONSOLE"] = "密文控制台"
	AL["CYPHER_CONSOLE_ENTRANCE"] = "到「密文控制台」的入口"
	AL["DATABASE_HARD_RESET"] = "由於最近的資料片以及最新版的RareScanner在數據庫上發生很大的變化，這需要重置數據庫以避免矛盾。 抱歉給你帶來不便。"
	AL["DISABLE_OBJECTS_SOUND"] = "停用寶物以及事件的音效警報"
	AL["DISABLE_OBJECTS_SOUND_DESC"] = "啟用此功能後，您將不會收到有關寶物和事件的音效警報"
	AL["DISABLE_SEARCHING_CONTAINER_TOOLTIP"] = "禁用對此寶箱的警報"
	AL["DISABLE_SEARCHING_EVENT_TOOLTIP"] = "禁用此事件的警報"
	AL["DISABLE_SEARCHING_RARE_TOOLTIP"] = "停用這個稀有NPC的通知"
	AL["DISABLE_SOUND"] = "停用音效通知"
	AL["DISABLE_SOUND_DESC"] = "啟用時，將不會收到音效通知。"
	AL["DISABLED_SEARCHING_CONTAINER"] = "禁用對此寶箱的警報：%s"
	AL["DISABLED_SEARCHING_EVENT"] = "禁用此事件的警報：%s"
	AL["DISABLED_SEARCHING_RARE"] = "已停用通知的稀有NPC:"
	AL["DISPLAY"] = "顯示"
	AL["DISPLAY_BUTTON"] = "顯示按鈕與小圖像"
	AL["DISPLAY_BUTTON_CONTAINERS"] = "切換是否顯示寶箱的按鈕"
	AL["DISPLAY_BUTTON_CONTAINERS_DESC"] = "切換是否顯示寶箱的按鈕。不會影響警報聲和聊天通知"
	AL["DISPLAY_BUTTON_DESC"] = "取消按鈕與小圖像後不會再次顯示。它不影響通告聲音和聊天通知。"
	AL["DISPLAY_BUTTON_SCALE"] = "按鈕和微縮模型縮放"
	AL["DISPLAY_BUTTON_SCALE_DESC"] = "調整按鈕和微縮模型縮放，0.85為原始尺寸"
	AL["DISPLAY_BUTTON_SCALE_POSITION"] = "縮放與位置選項"
	AL["DISPLAY_CONTAINER_ICONS"] = "世界地圖顯示寶箱圖示開關"
	AL["DISPLAY_CONTAINER_ICONS_DESC"] = "當停用時，寶箱的圖示不會顯示在世界地圖上。"
	AL["DISPLAY_EVENT_ICONS"] = "世界地圖顯示事件圖示開關"
	AL["DISPLAY_EVENT_ICONS_DESC"] = "當停用時，事件圖示不會顯示在世界地圖上。"
	AL["DISPLAY_FRIENDLY_NPC_ICONS"] = "切換是否顯示世界地圖上的友善稀有NPC圖示"
	AL["DISPLAY_FRIENDLY_NPC_ICONS_DESC"] = "禁用時，友善稀有NPC的圖示不會顯示在世界地圖上。"
	AL["DISPLAY_LOOT_PANEL"] = "切換顯示戰利品"
	AL["DISPLAY_LOOT_PANEL_DESC"] = "啟用時，會顯示NPC掉落的戰利品。"
	AL["DISPLAY_MAP_DRAGON_GLYPHS_ICONS"] = "切換世界地圖上的龍形圖示顯示"
	AL["DISPLAY_MAP_DRAGON_GLYPHS_ICONS_DESC"] = "當停用後，龍形圖示將不會顯示在世界地圖上。"
	AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS"] = "切換是否在地圖上顯示未發現的圖示。"
	AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS_DESC"] = "停用後，還未發現的NPC(紅色與橘色圖示)，箱子以及事件不會在世界地圖上顯示。"
	AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS"] = "切換是否在地圖上顯示舊資料片的未發現圖示。"
	AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS_DESC"] = "取消以後，對於舊資料片的區域，未探索的稀有NPC圖示(紅色與橘色圖示)、箱子或事件不會顯示在地圖上。"
	AL["DISPLAY_MINIATURE"] = "顯示小畫像"
	AL["DISPLAY_MINIATURE_DESC"] = "停用後小畫像將不在顯示。"
	AL["DISPLAY_MINIMAP_BUTTON"] = "切換顯示小地圖按鈕"
	AL["DISPLAY_MINIMAP_BUTTON_DESC"] = "在小地圖旁邊顯示一個按鈕以瀏覽RareScanner和選項面板"
	AL["DISPLAY_MINIMAP_ICONS"] = "切換小地圖圖示是否顯示"
	AL["DISPLAY_MINIMAP_ICONS_DESC"] = "如果停用將不會在小地圖看見圖示。"
	AL["DISPLAY_NPC_ICONS"] = "世界地圖顯示稀有NPC圖示開關"
	AL["DISPLAY_NPC_ICONS_DESC"] = "當停用時，稀有NPC圖示不會顯示在世界地圖上。"
	AL["DISPLAY_OPTIONS"] = "顯示選項"
	AL["DISPLAY_WORLDMAP_BUTTON"] = "切換顯示世界地圖按鈕"
	AL["DISPLAY_WORLDMAP_BUTTON_DESC"] = "在世界地圖中顯示一個按鈕以訪問與世界地圖相關的RareScanner選項"
	AL["DRAGON_GLYPH"] = "龍形圖示"
	AL["DUNGEONS_SCENARIOS"] = "地城/事件"
	AL["ENABLE_AUTO_TOMTOM_WAYPOINTS"] = "啟用自動替換路徑點"
	AL["ENABLE_AUTO_TOMTOM_WAYPOINTS_DESC"] = "當你找到稀有實體時會立即啟用，該插件將用一個指向最近找到實體的位置替換現有的Tomtom路徑點。禁用時，僅在單擊主按鈕時才會添加路徑點。"
	AL["ENABLE_AUTO_WAYPOINTS"] = "啟用自動替換路徑點"
	AL["ENABLE_AUTO_WAYPOINTS_DESC"] = "當你找到稀有實體時會立即啟用，該插件將用一個指向最近找到實體的位置替換現有遊戲中的路徑點。禁用時，僅在單擊主按鈕時才會添加路徑點。"
	AL["ENABLE_MARKER"] = "切換目標是否標記"
	AL["ENABLE_MARKER_DESC"] = "當啟用以後，點擊主按鈕將在目標頭頂上個標記。"
	AL["ENABLE_SCAN_CHAT"] = "切換是否透過聊天訊息搜尋稀有NPC"
	AL["ENABLE_SCAN_CHAT_DESC"] = "啟用以後，每當稀有NPC大喊或是偵測到相關的聊天訊息時，將發出視覺以及聲音提醒。"
	AL["ENABLE_SCAN_CONTAINERS"] = "搜尋寶藏或寶箱"
	AL["ENABLE_SCAN_CONTAINERS_DESC"] = "啟用時，每當你的小地圖上有寶藏或寶箱出現，都會有視覺警告與聲音提醒。"
	AL["ENABLE_SCAN_EVENTS"] = "搜尋事件"
	AL["ENABLE_SCAN_EVENTS_DESC"] = "啟用時，每當你的小地圖上有事件出現，都會有視覺警告與聲音提醒。"
	AL["ENABLE_SCAN_GARRISON_CHEST"] = "搜尋要塞寶箱"
	AL["ENABLE_SCAN_GARRISON_CHEST_DESC"] = "啟用時，每當你的要塞寶箱顯示在小地圖上，都會有視覺警告與聲音提醒。"
	AL["ENABLE_SCAN_IN_INSTANCE"] = "切換副本中是否掃描"
	AL["ENABLE_SCAN_IN_INSTANCE_DESC"] = "當啟用後在副本中（地城、團隊、等等）也會如常運作。"
	AL["ENABLE_SCAN_ON_PET_BATTLE"] = "寵物對戰時掃描開關"
	AL["ENABLE_SCAN_ON_PET_BATTLE_DESC"] = "當啟用時，在寵物對戰中任會正常提示。"
	AL["ENABLE_SCAN_ON_TAXI"] = "使用交通工具時掃描開關"
	AL["ENABLE_SCAN_ON_TAXI_DESC"] = "當啟用時，如果您正在使用交通工具(鳥、船、或其他)仍會正常提示。"
	AL["ENABLE_SCAN_RARES"] = "搜尋稀有NPC"
	AL["ENABLE_SCAN_RARES_DESC"] = "啟用時，每當你的小地圖上有稀有NPC出現，都會有視覺警告與聲音提醒。"
	AL["ENABLE_SCAN_WORLDMAP_VIGNETTES"] = "通過世界地圖縮圖來搜尋稀有"
	AL["ENABLE_SCAN_WORLDMAP_VIGNETTES_DESC"] = "啟用此功能後，只要世界地圖上出現稀有NPC，寶藏或事件的圖標，就會警告您。請注意，在圖標保留很長時間的地方，此過濾器可能會很煩人，因此請謹慎使用。"
	AL["ENABLE_SEARCHING_CONTAINER_TOOLTIP"] = "啟用對此寶箱的警報"
	AL["ENABLE_SEARCHING_EVENT_TOOLTIP"] = "啟用此事件的警報"
	AL["ENABLE_SEARCHING_RARE_TOOLTIP"] = "啟用這個稀有NPC的通知"
	AL["ENABLE_TOMTOM_SUPPORT"] = "Tomtom功能支持開關"
	AL["ENABLE_TOMTOM_SUPPORT_DESC"] = "啟用後會添加Tomtom插件的坐標點"
	AL["ENABLE_WAYPOINTS_SUPPORT"] = "切換遊戲內建路徑點支援"
	AL["ENABLE_WAYPOINTS_SUPPORT_DESC"] = "啟用此功能後，它將在稀有實體的找到的坐標處添加一個遊戲中路徑點。重要！遊戲在實體頂部添加了一個不同的圖標，因此您不會看到粉紅色的按鈕，而必須尋找一個正方形圖標。"
	AL["ENABLED_SEARCHING_CONTAINER"] = "啟用對此寶箱的警報：%s"
	AL["ENABLED_SEARCHING_EVENT"] = "啟用此事件的警報：%s"
	AL["ENABLED_SEARCHING_RARE"] = "已啟用通知的稀有NPC:"
	AL["EVENT"] = "事件"
	AL["EVENT_FILTER"] = "事件過濾器"
	AL["EXPEDITION_ISLANDS"] = "海嶼探險"
	AL["EXPLORER_AUTO_FILTER"] = "自動過濾 NPC"
	AL["EXPLORER_AUTO_FILTER_DESC"] = "啟動此功能後，只要您從 NPC 收集所有缺失的物品，它就會自動過濾。"
	AL["EXPLORER_AUTOFILTER"] = "自動過濾 [%s]。不再缺少收藏品。"
	AL["EXPLORER_BUTTON_TOOLTIP1"] = "左鍵點擊查看詳細"
	AL["EXPLORER_BUTTON_TOOLTIP2"] = "右鍵點擊停止過濾 NPC"
	AL["EXPLORER_BUTTON_TOOLTIP3"] = "右鍵點擊過濾此NPC"
	AL["EXPLORER_CREATE_BACKUP"] = "建立設定檔備份"
	AL["EXPLORER_CREATE_BACKUP_DESC"] = "啟動此功能後，點擊“%s”時將建立當前設定檔的備份。如果需要，此備份將允許您返回到以前的配置。"
	AL["EXPLORER_FILTER_ACHIEVEMENT"] = "是成就的一部分"
	AL["EXPLORER_FILTER_APPEARANCES"] = "掉落缺失外觀"
	AL["EXPLORER_FILTER_COLLECTIONS"] = "收集"
	AL["EXPLORER_FILTER_DEAD"] = "顯示已擊殺NPC"
	AL["EXPLORER_FILTER_FILTERED"] = "顯示已過濾NPC"
	AL["EXPLORER_FILTER_MOUNTS"] = "掉落缺失坐騎"
	AL["EXPLORER_FILTER_PETS"] = "掉落缺失寵物"
	AL["EXPLORER_FILTER_STATE"] = "狀態"
	AL["EXPLORER_FILTER_TOYS"] = "掉落缺失玩具"
	AL["EXPLORER_FILTER_WITHOUT_COLLECTIBLES"] = "顯示沒有缺少收藏的NPC"
	AL["EXPLORER_FILTERING"] = "過濾NPC"
	AL["EXPLORER_FILTERING_CONTAINERS"] = "正分析要過濾的寶箱..."
	AL["EXPLORER_FILTERING_DESC"] = "過濾所有選擇在“%s - %s”下不掉落的任何收藏品的NPC，並取消過濾其餘的。"
	AL["EXPLORER_FILTERING_DIALOG"] = "將過濾每一個不掉落任何在“%s - %s”下選擇的收藏品的 NPC（例如，如果您只選擇了“%s”和“%s”，您將過濾所有 NPC 不會掉落任何這些收藏品並取消過濾掉那些收藏品）。要繼續嗎？"
	AL["EXPLORER_FILTERING_NPCS"] = "正分析要過濾的NPC..."
	AL["EXPLORER_FILTERS"] = "過濾"
	AL["EXPLORER_FOUND_CONTAINERS"] = "找到 %s 個尚未收集的寶箱..."
	AL["EXPLORER_FOUND_NPCS"] = "找到 %s 個尚未收集的NPC..."
	AL["EXPLORER_MISSING_APPEARANCES"] = "檢測到 %s  個缺少 %s 外觀..."
	AL["EXPLORER_MISSING_MOUNTS"] = "檢測到 %s 缺失坐騎…"
	AL["EXPLORER_MISSING_PETS"] = "檢測到 %s 缺失寵物…"
	AL["EXPLORER_MISSING_TOYS"] = "檢測到 %s 缺失玩具…"
	AL["EXPLORER_NO_MISSING_APPEARANCES"] = "無缺失外觀"
	AL["EXPLORER_NO_MISSING_MOUNTS"] = "無缺失坐騎"
	AL["EXPLORER_NO_MISSING_PETS"] = "無缺失寵物"
	AL["EXPLORER_NO_MISSING_TOYS"] = "無缺失玩具"
	AL["EXPLORER_NO_RESULTS"] = "沒找到結果"
	AL["EXPLORER_RESCANN"] = "重新掃描"
	AL["EXPLORER_RESCANN_DESC"] = "強制手動重新掃描缺少的收藏品"
	AL["EXPLORER_SCAN_CLASS_REQUIRED"] = "檢測到新版本數據庫，需要掃描當前職業。"
	AL["EXPLORER_SCAN_MANUAL"] = "為當前職業啟用手動重新掃描。"
	AL["EXPLORER_SCAN_REQUIRED"] = "檢測到新版本數據庫，需要新的掃描。"
	AL["EXPLORER_START_SCAN"] = "開始掃描"
	AL["FILTER"] = "過濾NPC"
	AL["FILTER_CONTAINER_LIST"] = "寶箱搜索過濾"
	AL["FILTER_CONTAINER_LIST_DESC"] = "寶箱搜索過濾開關。禁用時發現這個寶箱不會警報。"
	AL["FILTER_CONTAINERS_ONLY_MAP_DESC"] = "此選項啟用時，您仍會收到已過濾寶箱的警報，但不會在世界地圖上顯示。當停用此選項時，您不會收到已過濾寶箱的警報。"
	AL["FILTER_CONTINENT"] = "大陸/類別"
	AL["FILTER_CONTINENT_DESC"] = "大陸或類別名稱"
	AL["FILTER_EVENT_LIST"] = "過濾搜索事件"
	AL["FILTER_EVENT_LIST_DESC"] = "切換搜索此事件。禁用後，您將不會在找到此事件時收到警報。"
	AL["FILTER_EVENTS_ONLY_MAP_DESC"] = "啟用後，您仍會收到來自過濾事件的警報，但它們不會顯示在您的世界地圖中。禁用後，您根本不會收到來自過濾事件的警報。"
	AL["FILTER_NPCS_ONLY_MAP"] = "只在世界地圖中啟用過濾器"
	AL["FILTER_NPCS_ONLY_MAP_DESC"] = "啟用以後，您仍會收到已過濾稀有的提醒，但這些提醒不會顯示在世界地圖中，停用以後，您將無法從過濾後的稀有收到警報。"
	AL["FILTER_RARE_LIST"] = "過濾要搜尋的稀有NPC"
	AL["FILTER_RARE_LIST_DESC"] = "搜尋這個稀有NPC。|n停用後，發現這個NPC時不會通知。"
	AL["FILTER_ZONE"] = "區域"
	AL["FILTER_ZONE_DESC"] = "大陸或類別內的區域"
	AL["FILTER_ZONES_LIST"] = "區域清單"
	AL["FILTER_ZONES_LIST_DESC"] = "啟用/停用這個區域的通知。停用後，在這個區域中發現稀有NPC、事件或寶箱不會通知。"
	AL["FILTER_ZONES_ONLY_MAP"] = "只在世界地圖中啟用過濾器"
	AL["FILTER_ZONES_ONLY_MAP_DESC"] = "啟用以後，您仍會收到已過濾區域中稀有的提醒，但這些提醒不會顯示在世界地圖中，停用後，您將無法從屬於過濾區域的稀有收到警報。"
	AL["FILTERS"] = "過濾稀有NPC"
	AL["FILTERS_CONTAINERS_SEARCH_DESC"] = "輸入寶箱的名稱過濾以下列表"
	AL["FILTERS_EVENTS_SEARCH_DESC"] = "輸入事件的名稱以過濾下面的列表"
	AL["FILTERS_SEARCH"] = "搜尋"
	AL["FILTERS_SEARCH_DESC"] = "輸入NPC名字來過濾下方的清單"
	AL["GENERAL_OPTIONS"] = "一般選項"
	AL["GUIDE_ABUSE_OF_POWER"] = "濫用權力"
	AL["GUIDE_ANIMA_CONDUCTOR"] = "靈魄傳導器"
	AL["GUIDE_BOUNDING_SHROOM"] = "反彈菇"
	AL["GUIDE_ENTRANCE"] = "入口"
	AL["GUIDE_LUNARLIGHT_BUD"] = "月光花苞"
	AL["GUIDE_PATH_START"] = "路徑從這裡開始"
	AL["GUIDE_SINSTONE_QUEST"] = "罪孽石重複性任務"
	AL["GUIDE_SPECTRAL_KEY"] = "幽魂鑰匙"
	AL["GUIDE_TRANSPORT"] = "傳送點"
	AL["INGAME_WAYPOINTS"] = "遊戲內建路徑點"
	AL["JUST_SPAWNED"] = "%s 剛剛出現了，檢查你的地圖！"
	AL["LEFT_BUTTON"] = "左鍵點擊"
	AL["LOCK_BUTTON_POSITION"] = "鎖定按鈕位置"
	AL["LOCK_BUTTON_POSITION_DESC"] = "啟用後，您將無法通過拖放按鈕來更改按鈕的位置。"
	AL["LOG_DONE"] = "完成"
	AL["LOG_FETCHING_COLLECTIONS"] = "正在獲取缺失的收藏..."
	AL["LOG_FILTERING_ENTITIES"] = "正在根據掉落物品過濾實體..."
	AL["LOG_LOOT_FILTERS_APPLIED"] = "掉落物品過濾器修改為僅顯示未收集"
	AL["LOOT_CATEGORY_FILTERED"] = "為類別/子類別啟用過濾器：%s/%s。您可以再次單擊戰利品圖示或RareScanner插件選單來禁用此過濾器"
	AL["LOOT_CATEGORY_FILTERS"] = "類別過濾"
	AL["LOOT_CATEGORY_FILTERS_DESC"] = "依據戰利品類別過濾"
	AL["LOOT_CATEGORY_NOT_FILTERED"] = "禁用過濾的類別/子類別：%s/%s"
	AL["LOOT_COVENANT_REQUIREMENT"] = "僅%s可拾取。"
	AL["LOOT_DISPLAY_OPTIONS"] = "顯示選項"
	AL["LOOT_DISPLAY_OPTIONS_DESC"] = "顯示戰利品列的選項"
	AL["LOOT_FILTER_ANIMA_ITEMS"] = "過濾貯藏靈魄物品"
	AL["LOOT_FILTER_ANIMA_ITEMS_DESC"] = "啟用時，貯藏靈魄物品不會在掉落物品條中顯示。"
	AL["LOOT_FILTER_COLLECTED"] = "過濾已收藏的寵物、坐騎以及玩具。"
	AL["LOOT_FILTER_COLLECTED_DESC"] = "啟用以後，只有您尚未收集的坐騎、寵物和玩具才會顯示在戰利品欄上。此過濾器不會影響任何其他類別的戰利品。"
	AL["LOOT_FILTER_COMPLETED_QUEST"] = "過濾無法開始新任務的任務物品"
	AL["LOOT_FILTER_COMPLETED_QUEST_DESC"] = "啟用時，任務物品開啟的任務如果已完成，不會在掉落物品條中顯示。"
	AL["LOOT_FILTER_CONDUIT_ITEMS"] = "過濾你無法使用的傳導器"
	AL["LOOT_FILTER_CONDUIT_ITEMS_DESC"] = "啟用時，你無法使用的和已收集的傳導器不會在掉落物品條中顯示。"
	AL["LOOT_FILTER_ITEM_LIST"] = "已過濾物品"
	AL["LOOT_FILTER_NOT_EQUIPABLE"] = "過濾不可裝備物品"
	AL["LOOT_FILTER_NOT_EQUIPABLE_DESC"] = "取消以後，此角色無法裝備的護甲與武器不會出現在戰利品欄上。此過濾器不會影響其他類別任何的戰利品。"
	AL["LOOT_FILTER_NOT_MATCHING_CLASS"] = "過濾需求非您當前職業的物品"
	AL["LOOT_FILTER_NOT_MATCHING_CLASS_DESC"] = "啟用後，任何需要非您當前的特定職業來使用的物品，都不會顯示在戰利品欄中。"
	AL["LOOT_FILTER_NOT_MATCHING_FACTION"] = "過濾不同陣營的物品"
	AL["LOOT_FILTER_NOT_MATCHING_FACTION_DESC"] = "啟用後，任何與你不匹配的特定陣營的物品都不會顯示在戰利品欄中。"
	AL["LOOT_FILTER_NOT_TRANSMOG"] = "只顯示可塑形的護甲與武器"
	AL["LOOT_FILTER_NOT_TRANSMOG_DESC"] = "啟用以後，只有你尚未收集外觀的護甲與武器才會顯示在戰利品欄上。此過濾器不會影響任何其他類別的戰利品。"
	AL["LOOT_FILTER_SUBCATEGORY_DESC"] = "切換是否在戰利品欄上顯示這類戰利品。停用以後，當您找到稀有NPC時不會看見與此類別匹配的任何物品。"
	AL["LOOT_FILTER_SUBCATEGORY_LIST"] = "子類別"
	AL["LOOT_FILTERS"] = "拾取過濾"
	AL["LOOT_FILTERS_DESC"] = "在世界地圖和拾取欄中顯示過濾拾取"
	AL["LOOT_INDIVIDUAL_FILTERED"] = "已啟用%s的過濾器。你可以通過再次點擊戰利品圖示或者在RareScanner插件選單中禁用此過濾器"
	AL["LOOT_INDIVIDUAL_FILTERS"] = "獨立物品過濾器"
	AL["LOOT_INDIVIDUAL_FILTERS_DESC"] = "為了將物品添加到此列表中，你可以通過直接點擊世界地圖鼠標提示中顯示的圖示或掉落物品條中的圖示來對其進行過濾。"
	AL["LOOT_INDIVIDUAL_NOT_FILTERED"] = "已禁用%s的過濾器。"
	AL["LOOT_ITEMS_PER_ROW"] = "每行顯示物品的數目"
	AL["LOOT_ITEMS_PER_ROW_DESC"] = "設置戰利品欄上每行顯示的物品數。如果該數字小於要顯示的最大行數。"
	AL["LOOT_MAIN_CATEGORY"] = "主類別"
	AL["LOOT_MAX_ITEMS"] = "要顯示物品的數目"
	AL["LOOT_MAX_ITEMS_DESC"] = "設置戰利品欄上顯示的最大物品數。"
	AL["LOOT_MIN_QUALITY"] = "戰利品最低品質"
	AL["LOOT_MIN_QUALITY_DESC"] = "設定要顯示的戰利品的最低品質"
	AL["LOOT_OPTIONS"] = "戰利品選項"
	AL["LOOT_OTHER_FILTERS"] = "其他過濾器"
	AL["LOOT_OTHER_FILTERS_DESC"] = "其他過濾器"
	AL["LOOT_PANEL_OPTIONS"] = "戰利品選項"
	AL["LOOT_RESET"] = "重置過濾"
	AL["LOOT_RESET_DESC"] = "點擊該按鈕可將所有過濾重置為其預設值。這不會修改單項過濾。"
	AL["LOOT_RESET_DONE"] = "已恢復拾取過濾"
	AL["LOOT_SEARCH_ITEMS_DESC"] = "輸入物品名稱以過濾下面的列表"
	AL["LOOT_SUBCATEGORY_FILTERS"] = "子類別過濾器"
	AL["LOOT_TOGGLE_FILTER"] = "Alt+左鍵點擊過濾分類 (%s/%s)"
	AL["LOOT_TOGGLE_INDIVIDUAL_FILTER"] = "Alt+Shift+左鍵點擊過濾此物品"
	AL["LOOT_TOOLTIP_POSITION"] = "戰利品滑鼠提示位置"
	AL["LOOT_TOOLTIP_POSITION_DESC"] = "設定滑鼠指向戰利品圖示時，滑鼠提示出現的位置 (相對於按鈕)。"
	AL["LOOT_TOOLTIPS_CANIMOGIT"] = "CanIMogIt支援"
	AL["LOOT_TOOLTIPS_CANIMOGIT_DESC"] = "拾取提示中CanIMogIt插件訊息顯示切換開關。"
	AL["LOOT_TOOLTIPS_COVENANT"] = "切換誓盟要求"
	AL["LOOT_TOOLTIPS_COVENANT_DESC"] = "某些物品只能被特定誓盟拾取。啟用後將會在物品鼠標提示顯示對應誓盟要求。"
	AL["MAIN_BUTTON_OPTIONS"] = "主按鈕選項"
	AL["MAP_CONTAINERS_ICONS"] = "箱子"
	AL["MAP_EVENTS_ICONS"] = "事件"
	AL["MAP_ICONS"] = "圖示"
	AL["MAP_ICONS_DESC"] = "用於設置要在世界地圖上顯示哪些圖示的選項"
	AL["MAP_MENU_DISABLE_LAST_SEEN_CONTAINER_FILTER"] = "顯示您很久以前看到但可以重生的內容"
	AL["MAP_MENU_DISABLE_LAST_SEEN_EVENT_FILTER"] = "顯示您很久以前看到但可以重生的事件"
	AL["MAP_MENU_DISABLE_LAST_SEEN_FILTER"] = "顯示你很久以前見過可重生的稀有NPC。"
	AL["MAP_MENU_SHOW_CONTAINERS"] = "在地圖上顯示寶箱圖示"
	AL["MAP_MENU_SHOW_DRAGON_GLYPHS"] = "在地圖上顯示龍形圖示"
	AL["MAP_MENU_SHOW_EVENTS"] = "在地圖上顯示事件圖示"
	AL["MAP_MENU_SHOW_NOT_DISCOVERED"] = "未發現的實體"
	AL["MAP_MENU_SHOW_NOT_DISCOVERED_OLD"] = "未發現的實體 (舊資料片)"
	AL["MAP_MENU_SHOW_RARE_NPCS"] = "在地圖上顯示稀有NPC圖示"
	AL["MAP_NEVER"] = "從未"
	AL["MAP_NOT_DISCOVERED_ICONS"] = "未發現實體"
	AL["MAP_NPCS_ICONS"] = "NPC"
	AL["MAP_OPTIONS"] = "地圖選項"
	AL["MAP_OTHER_ICONS"] = "其他圖示"
	AL["MAP_SCALE_ICONS"] = "圖示大小"
	AL["MAP_SCALE_ICONS_DESC"] = "這將調整地圖上的圖示大小，數值1表示原始大小"
	AL["MAP_SEARCHER"] = "世界地圖搜索器"
	AL["MAP_SEARCHER_CLEAR"] = "地圖關閉時的清除搜索框開關"
	AL["MAP_SEARCHER_CLEAR_DESC"] = "啟用後，每次您關閉世界地圖時，都會清除在搜索框中鍵入的值。"
	AL["MAP_SEARCHER_DESC"] = "用於配置世界地圖中顯示的搜索框以搜索實體的選項"
	AL["MAP_SEARCHER_DISPLAY"] = "搜索框顯示開關"
	AL["MAP_SEARCHER_DISPLAY_DESC"] = "禁用後，搜索框將不會顯示在您的世界地圖中"
	AL["MAP_SEARCHER_TOOLTIP_DESC"] = "輸入要查找的稀有實體的名稱，然後按Enter。"
	AL["MAP_SEARCHER_TOOLTIP_TITLE"] = "RareScanner搜索器"
	AL["MAP_SHOW_ICON_AFTER_COLLECTED"] = "拾取後仍保持顯示箱子圖示"
	AL["MAP_SHOW_ICON_AFTER_COLLECTED_DESC"] = "停用以後，在拾取箱子之後圖示將會消失。"
	AL["MAP_SHOW_ICON_AFTER_COMPLETED"] = "完成後繼續顯示事件圖示"
	AL["MAP_SHOW_ICON_AFTER_COMPLETED_DESC"] = "如果停用，完成活動後該圖示將消失。"
	AL["MAP_SHOW_ICON_AFTER_DEAD"] = "在擊殺後仍然顯示圖示"
	AL["MAP_SHOW_ICON_AFTER_DEAD_DESC"] = "停用後，圖示將在殺死NPC後消失。再次找到NPC後，圖標就會出現。這個選項只適用於在殺死它們後繼續進行追蹤的NPC。"
	AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE"] = "在NPC死亡後持續顯示圖示（僅在可重置區域）"
	AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE_DESC"] = "禁用時，當你擊殺NPC後圖示會隱藏。圖示會在你再次發現該NPC時出現。本選項只在NPC擊殺後依然為精英的區域（隨世界任務重置）生效"
	AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME"] = "隱藏箱子圖示的計時器(以分計)"
	AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME_DESC"] = "設置自從你看到箱子以來最大的分鐘數。在此時間之後，再次找到箱子以前，圖示不再顯示在世界地圖上。如果你選擇0分鐘，則不論你看過箱子有多長時間都會顯示圖示，此過濾器不適用於包含於成就的箱子。"
	AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME"] = "隱藏事件圖示的計時（以分計）"
	AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME_DESC"] = "設置自看到事件以來的最大分鐘數。在那之後，除非您再次找到該事件，否則該圖示不會顯示在世界地圖上。如果您選擇零分鐘，則無論您看到該事件有多長時間，都會顯示圖示。"
	AL["MAP_SHOW_ICON_MAX_SEEN_TIME"] = "自從你遇見稀有NPC以來的最長時間"
	AL["MAP_SHOW_ICON_MAX_SEEN_TIME_DESC"] = "設置您看過NPC後的最長小時數。 在那之後，圖示將不會顯示在世界地圖上，直到您再次找到NPC。 如果您選擇零小時，則無論您看到稀有NPC以來多長時間，都會顯示圖示。"
	AL["MAP_SPAWN_SPOTS"] = "重生點"
	AL["MAP_SPAWN_SPOTS_COLOUR"] = "重生點實體編號 %s"
	AL["MAP_SPAWN_SPOTS_DESC"] = "世界地圖中顯示的重生點配置選項"
	AL["MAP_TIMERS"] = "計時器"
	AL["MAP_TIMERS_DESC"] = "用於設置要在世界地圖上顯示圖示時間長久的選項"
	AL["MAP_TOOLTIP_ADD_WAYPOINT"] = "Shift-左鍵點擊來新增此位置的路徑點"
	AL["MAP_TOOLTIP_DAYS"] = "天"
	AL["MAP_TOOLTIP_FILTER_ENTITY"] = "過濾此實體"
	AL["MAP_TOOLTIP_NOT_FOUND"] = "你還沒見過此NPC並且也還沒有人跟你分享。"
	AL["MAP_TOOLTIP_RESPAWN"] = "重生於：%s"
	AL["MAP_TOOLTIP_SEEN"] = "多久前見過：%s"
	AL["MAP_TOOLTIP_SHOW_GUIDE"] = "右鍵單擊以切換顯示指南圖示"
	AL["MAP_TOOLTIP_SHOW_OVERLAY"] = "左鍵單擊以切換顯示其他出生點"
	AL["MAP_TOOLTIPS"] = "提示框"
	AL["MAP_TOOLTIPS_ACHIEVEMENT"] = "顯示成就訊息"
	AL["MAP_TOOLTIPS_ACHIEVEMENT_DESC"] = "禁用後將不會在提示看到成就訊息。"
	AL["MAP_TOOLTIPS_COMMANDS"] = "顯示指令行"
	AL["MAP_TOOLTIPS_COMMANDS_DESC"] = "禁用後將不會在提示的底部看到指令行的描述。"
	AL["MAP_TOOLTIPS_DESC"] = "設定提示顯示的選項"
	AL["MAP_TOOLTIPS_LOOT"] = "在地圖提示上顯示戰利品"
	AL["MAP_TOOLTIPS_LOOT_ACHIEVEMENT"] = "戰利品/成就"
	AL["MAP_TOOLTIPS_LOOT_ACHIEVEMENT_POSITION"] = "拾取/成就 工具提示位置"
	AL["MAP_TOOLTIPS_LOOT_ACHIEVEMENT_POSITION_DESC"] = "決定相對於上層工具提示顯示戰利品和成就工具提示的位置。"
	AL["MAP_TOOLTIPS_LOOT_ACHIEVEMENT_SCALE"] = "戰利品/成就工具提示的縮放"
	AL["MAP_TOOLTIPS_LOOT_ACHIEVEMENT_SCALE_DESC"] = "這將調整世界地圖中戰利品和成就工具提示的縮放。"
	AL["MAP_TOOLTIPS_LOOT_DESC"] = "切換當你把鼠標移到圖示上時，是否在提示上顯示NPC/包含的戰利品。"
	AL["MAP_TOOLTIPS_NOTES"] = "顯示註記"
	AL["MAP_TOOLTIPS_NOTES_DESC"] = "禁用後將不會在提示看到註記。"
	AL["MAP_TOOLTIPS_SCALE"] = "世界地圖鼠標提示縮放"
	AL["MAP_TOOLTIPS_SCALE_DESC"] = "調整世界地圖中鼠標提示的縮放比例，包括掉落物品和成就鼠標提示。"
	AL["MAP_TOOLTIPS_SEEN"] = "顯示最後看到時間"
	AL["MAP_TOOLTIPS_SEEN_DESC"] = "禁用後將不會看到實體已過了多長時間。"
	AL["MAP_TOOLTIPS_STATE"] = "顯示實體狀態"
	AL["MAP_TOOLTIPS_STATE_DESC"] = "禁用後將不會看到與實體狀態有關的訊息（死亡，已打開或已完成和重生時間）。此提示只有藍色圖示。"
	AL["MAP_TOOLTIPS_WORLDMAP_ICONS"] = "顯示提示游戲內世界地圖圖示"
	AL["MAP_TOOLTIPS_WORLDMAP_ICONS_DESC"] = "禁用後將不會看到游戲內世界地圖圖示中提示。"
	AL["MAP_WAYPOINT_INGAME"] = "切換遊戲內的路徑點"
	AL["MAP_WAYPOINT_INGAME_DESC"] = "當啟用後，您可以在世界地圖圖示上透由'Shift-左鍵點擊'來新增一個遊戲內的路徑點。"
	AL["MAP_WAYPOINT_TOMTOM"] = "切換Tomtom的路徑點"
	AL["MAP_WAYPOINT_TOMTOM_DESC"] = "當啟用後，您可以在世界地圖圖示上透由'Shift-左鍵點擊'來新增一個Tomtom的路徑點。"
	AL["MAP_WAYPOINTS"] = "路徑點"
	AL["MAP_WAYPOINTS_DESC"] = "透由點擊世界地圖圖示新增路徑點的選項。"
	AL["MARKER"] = "目標標記"
	AL["MARKER_DESC"] = "點擊主按鈕，選擇目標頂部的標記。"
	AL["MESSAGE_OPTIONS"] = "訊息選項"
	AL["MIDDLE_BUTTON"] = "中鍵點擊"
	AL["MINIMAP_ICON_TOOLTIP1"] = "左鍵點擊打開 RareScanner 瀏覽"
	AL["MINIMAP_ICON_TOOLTIP2"] = "右鍵點擊開啟 RareScanner 選項面板"
	AL["MINIMAP_SCALE_ICONS"] = "小地圖按鈕縮放"
	AL["MINIMAP_SCALE_ICONS_DESC"] = "調整小地圖上的按鈕縮放，0.7表示原始尺寸。"
	AL["NAVIGATION_ENABLE"] = "切換導航"
	AL["NAVIGATION_ENABLE_DESC"] = "啟用後，導航箭頭將顯示在主按鈕旁邊，以允許您訪問找到的新舊單位"
	AL["NAVIGATION_LOCK_ENTITY"] = "如果已經顯示新單位，則阻止顯示"
	AL["NAVIGATION_LOCK_ENTITY_DESC"] = "啟用後，如果主按鈕在螢幕上顯示一個單位，它將不會自動更新為較新的單位。 準備就緒後，將出現一個箭頭，允許您訪問新單位。"
	AL["NAVIGATION_OPTIONS"] = "導航選項"
	AL["NAVIGATION_SHOW_NEXT"] = "顯示找到的下一個單位"
	AL["NAVIGATION_SHOW_PREVIOUS"] = "顯示找到的先前單位"
	AL["NOT_TARGETEABLE"] = "無法設為目標"
	AL["NOTE_10263"] = "“裂盾術士”打開傳送門有時會從中召喚稀有 NPC。"
	AL["NOTE_129836"] = "它沒有微縮圖，所以無法獲得他的報警訊息。在建築的地下室中。"
	AL["NOTE_130350"] = "你必須沿著這個位置右邊的路徑騎上稀有到此箱子。"
	AL["NOTE_131453"] = "你必須騎上[春天守護者-暫譯]到這個位置，這匹馬是友善的稀有怪，通常可在箱子左邊的路徑找到。"
	AL["NOTE_131735"] = "他是一個中立NPC。擊殺他之後會出現一只小豬，可以獲得一個小寵物[帕菲]"
	AL["NOTE_135448"] = "僅在史詩難度下出現。你需要找到[被遺棄的監獄鑰匙]（刷新在附近家具頂部）來打開有骷髏的監舍。進入後穿過牆上的洞進入一個有桶的房間，點擊桶召喚稀有 NPC。"
	AL["NOTE_135497"] = "僅在蜜露恩發放日常任務[來自諾達希爾的援助]時有效。該日常要求你在樹底下找蘑菇，當你點擊一個蘑菇時它會停滯，你需要在它消失前再點2個蘑菇，NPC才會出現"
	AL["NOTE_140474"] = "你需要收集20個[深淵碎片]（世界掉落）。收集齊20個之後點擊合成[讓人厭惡的深淵精華]，在坐標73.23處（瀑布後面）使用它。它會指引你去一個可以召喚稀有 NPC 的礦洞（礦洞入口坐標46.36）"
	AL["NOTE_149847"] = "你靠近他時他會告訴你一個他討厭的顏色，你要到坐標63.41被染成這個顏色，然後回來找他，他就會攻擊你。"
	AL["NOTE_149886"] = "他只會在你剛進入皇家圖書館時出現一次。這是對漫威的斯坦·李的致敬。"
	AL["NOTE_149887"] = "他只會在你剛進入這個房子時出現一次。這是對漫威的斯坦·李的致敬。"
	AL["NOTE_150342"] = "在事件[鑽探機 DR-TR35]進行期間可用"
	AL["NOTE_150394"] = "你需要把他帶到坐標63.38，那裡有一個藍色閃電裝置，當NPC觸碰到閃電時他會爆炸，然後你就可以拾取戰利品。"
	AL["NOTE_151124"] = "你需要在事件[鑽探機 DR-JD99]進行期間（坐標59.67）從小怪身上拾取[砸壞的運輸繼電器]，然後在這個機器上使用"
	AL["NOTE_151159"] = "他只在NPC[奧格索普·奧布諾提斯]探訪機械岡（坐標72.37）時存在。他會在機械岡游蕩，所以你需要沿著每條路尋找。擊殺他會召喚[OOX-復仇者/MG]"
	AL["NOTE_151202"] = "你需要在岸邊用水里的電線塔連接電線才能召喚他"
	AL["NOTE_151296"] = "首先檢查[奧格索普‧奧布諾提斯]是否在機械岡(座標 72.37)。如果他在那裡，那麼您必須找到並殺死[OOX-Fleetfoot / MG]（這是在機械岡周圍徘徊的雞機器人）。找到他並殺死他後，請返回此圖示的坐標。"
	AL["NOTE_151308"] = "在事件[鑽探機]進行期間可用"
	AL["NOTE_151569"] = "你需要一个[百噚誘餌]来召唤他。"
	AL["NOTE_151627"] = "你需要在平台的機器上使用一個[發熱蒸發器線圈]。"
	AL["NOTE_151933"] = "你需要使用[野獸機器人動力包]才能擊殺他（你可以在坐標60.41找到圖紙）"
	AL["NOTE_152007"] = "它會在這個區域遊蕩，所以坐標可能不太精確。"
	AL["NOTE_152113"] = "在事件[鑽探機 DR-CC88]進行期間可用"
	AL["NOTE_152569"] = "你靠近他時他會告訴你一個他討厭的顏色，你要到坐標63.41被染成這個顏色，然後回來找他，他就會攻擊你。"
	AL["NOTE_152570"] = "你靠近他時他會告訴你一個他討厭的顏色，你要到坐標63.41被染成這個顏色，然後回來找他，他就會攻擊你。"
	AL["NOTE_153000"] = "它會在這個區域遊蕩，所以坐標可能不太精確。"
	AL["NOTE_153200"] = "在事件[鑽探機 DR-JD41]進行期間可用"
	AL["NOTE_153205"] = "在事件[鑽探機 DR-JD99]進行期間可用"
	AL["NOTE_153206"] = "在事件[鑽探機 DR-TR28]進行期間可用"
	AL["NOTE_153228"] = "需要擊殺很多[升級版哨衛]才會在這個區域出現"
	AL["NOTE_154225"] = "需要使用[個人時光轉移裝置]訪問他的接口，這個物品是克羅米發放日常任務[另一個地方]的獎勵品"
	AL["NOTE_154332"] = "在一個山洞裡。入口位於坐標57,38。"
	AL["NOTE_154333"] = "在一個山洞裡。入口位於坐標57,38。"
	AL["NOTE_154342"] = "需要使用[個人時光轉移裝置]訪問他的接口，這個物品是克羅米發放日常任務[另一個地方]的獎勵品"
	AL["NOTE_154559"] = "在山洞裡。入口位於坐標70,58處。"
	AL["NOTE_154604"] = "在一個山洞裡。 入口位於坐標36,20。"
	AL["NOTE_154701"] = "在事件[鑽探機 DR-CC61]進行期間可用"
	AL["NOTE_154739"] = "在事件[鑽探機 DR-CC73]進行期間可用"
	AL["NOTE_155531"] = "您必須使用他上面的球（太陽精華）來獲得[太陽光環]並能夠攻擊他。"
	AL["NOTE_156709"] = "您必須殺死無面Despoiler（普通NPC），才能迫使它出生。"
	AL["NOTE_157162"] = "在廟裡。 入口位於坐標22,24處。"
	AL["NOTE_157312"] = "每種材料加10。"
	AL["NOTE_158531"] = "您必須殺死虛空扭曲的納弗塞特（普通NPC）才能迫使它出生。"
	AL["NOTE_158632"] = "您必須殺死Burbling Fleshbeast（普通NPC）才能迫使它出生。"
	AL["NOTE_158706"] = "您必須殺死腐爛軟泥（普通NPC）才能強制其出生。"
	AL["NOTE_159087"] = "您必須殺死恩若司剝骨者（普通NPC）才能迫使它出生。"
	AL["NOTE_160968"] = "在廟裡。 入口位於坐標22,24處。"
	AL["NOTE_162171"] = "在一個山洞裡。 入口位於坐標45,58處。"
	AL["NOTE_162352"] = "它在山洞裡。入口在水下52,40處。"
	AL["NOTE_162588_1"] = "不尋常的蛋"
	AL["NOTE_163460"] = "他在地下。"
	AL["NOTE_167078_1"] = "勇氣號角"
	AL["NOTE_167464"] = "殺死他周圍的所有NPC開啟戰鬥。"
	AL["NOTE_167851"] = "在一個洞穴裡。"
	AL["NOTE_170659_1"] = "在這個區域四處走走，直到您的頭上有紫色的眼睛。"
	AL["NOTE_171255"] = "在你和他說話之前是中立的。"
	AL["NOTE_171327"] = "使用傳送到達那裡。"
	AL["NOTE_171688"] = "他在一個山洞裡。轉到山頂，跟隨河流，然後跳下瀑布。洞穴的入口在第二個瀑布後面。"
	AL["NOTE_171688_1"] = "跳下瀑布"
	AL["NOTE_171699_1"] = "踩上去來得到隱形"
	AL["NOTE_172862"] = "跟隨他到一個可以攻擊他的洞穴。"
	AL["NOTE_180731_1"] = "頂部平台，在桌子上"
	AL["NOTE_180731_2"] = "在手推車中間"
	AL["NOTE_180731_3"] = "在兩塊大石頭之間"
	AL["NOTE_180731_4"] = "在兩個花蕾旁邊的地面上"
	AL["NOTE_180731_5"] = "在推車下，在輪子之間"
	AL["NOTE_280951"] = "沿著鐵路走直到你找到推車，然後騎上他來發現財寶。"
	AL["NOTE_287239"] = "如果您是部落，您必須完成沃魯敦活動才能進入神殿。"
	AL["NOTE_289647"] = "財寶在洞穴內。入口位於座標65.11，介於快到山頂的一些樹中間。"
	AL["NOTE_292673"] = "5個卷軸的第1個，閱讀所有卷軸來發現寶藏[深淵的秘密-暫譯]。它位於地下室。閱讀後請手動隱藏此圖示。"
	AL["NOTE_292674"] = "5個卷軸的第2個，閱讀所有卷軸來發現寶藏[深淵的秘密-暫譯]。它位於木地板下，在一堆蠟燭旁邊的角落裡。 閱讀後，請手動隱藏此圖示。"
	AL["NOTE_292675"] = "5個卷軸的第3個，閱讀所有卷軸來發現寶藏[深淵的秘密-暫譯]。它位於地下室。閱讀後請手動隱藏此圖示。"
	AL["NOTE_292676"] = "5個卷軸的第4個，閱讀所有卷軸來發現寶藏[深淵的秘密-暫譯]。它位於頂層。閱讀後請手動隱藏此圖示。"
	AL["NOTE_292677"] = "5個卷軸的第5個，閱讀所有卷軸來發現寶藏[深淵的秘密-暫譯]。它在一個地下洞穴裡。 入口位於坐標72.40處的水下（修道院的水池）。。閱讀後請手動隱藏此圖示。"
	AL["NOTE_292686"] = "閱讀完5個卷軸後，使用[不祥的祭壇]來獲取[深淵的秘密](以上暫譯)。警告：使用祭壇會將你傳送到海中。 使用後，請手動隱藏此圖示。"
	AL["NOTE_293349"] = "它在棚子裡的架子上面。"
	AL["NOTE_293350"] = "這寶藏藏在下面的洞穴裡。 轉到坐標61.38，將視角置於頂部，然後向後跳過地板上的小裂縫並落在窗台上。"
	AL["NOTE_293852"] = "在你從自由港的海盜那拿到[溼透的藏寶圖]之前你不會看到"
	AL["NOTE_293880"] = "在你從自由港的海盜那拿到[褪色的藏寶圖]之前你不會看到"
	AL["NOTE_293881"] = "在你從自由港的海盜那拿到[泛黃的藏寶圖]之前你不會看到"
	AL["NOTE_293884"] = "在你從自由港的海盜那拿到[罪惡的藏寶圖]之前你不會看到"
	AL["NOTE_297828"] = "飛在上面的烏鴉握著鑰匙。 殺了它。"
	AL["NOTE_297891"] = "您必須按以下順序停用符文：左，下，上，右"
	AL["NOTE_297892"] = "您必須按以下順序停用符文：左，右，下，上"
	AL["NOTE_297893"] = "您必須按以下順序停用符文：右，上，左，下"
	AL["NOTE_326395"] = "點擊桌上箱子旁的[秘法裝置]開始小遊戲。需要將三個三角形分開，點擊寶珠交換位置。"
	AL["NOTE_326396"] = "點擊桌上箱子旁的[秘法裝置]開始小遊戲。需要將二個長方形分開，點擊寶珠交換位置。"
	AL["NOTE_326397"] = "點擊桌上箱子旁的[秘法裝置]開始小遊戲。需要將三個紅色的符文連成一線。。"
	AL["NOTE_326398"] = "點擊桌上箱子旁的[秘法裝置]開始小遊戲。需要將四個青色的符文連成一線。。"
	AL["NOTE_326399"] = "在水下的洞裡。你需要完成一個小遊戲，在火球碰到地上到圓圈前射擊他們。當火球碰到地面或者你的技能沒有打到火球時能量會減少，當能量歸零你需要從頭開始遊戲。"
	AL["NOTE_326400"] = "在洞裡。你需要完成一個小遊戲，在火球碰到地上到圓圈前射擊他們。當火球碰到地面或者你的技能沒有打到火球時能量會減少，當能量歸零你需要從頭開始遊戲。"
	AL["NOTE_326403"] = "在建築物內，你需要從建築物後面進入"
	AL["NOTE_326405"] = "在地圖最頂層的一堆廢墟中間"
	AL["NOTE_326406"] = "在地圖最頂層的山頂上，非常難以到達，但是從地圖南邊上去是可行的。"
	AL["NOTE_326407"] = "在地圖最頂層的山頂上"
	AL["NOTE_326408"] = "入口在南方湖面水下的洞裡(坐標57,39)"
	AL["NOTE_326410"] = "在地圖最底層的洞裡"
	AL["NOTE_326411"] = "在地圖最頂層的一堆石頭中間"
	AL["NOTE_326413"] = "在地圖最底層的洞裡"
	AL["NOTE_326415"] = "需要解鎖飛行，或者你可以用[哥布林滑翔工具組]從旁邊的高山頂上滑過去。寶箱在珊瑚橋的頂部。"
	AL["NOTE_326416"] = "在地圖的最高層，廢墟中的塔內"
	AL["NOTE_329783"] = "在坐標83.33的屋頂上。你需要完成一個小遊戲，在火球碰到地上到圓圈前射擊他們。當火球碰到地面或者你的技能沒有打到火球時能量會減少，當能量歸零你需要從頭開始遊戲。"
	AL["NOTE_332220"] = "你需要完成一個小遊戲，在火球碰到地上到圓圈前射擊他們。當火球碰到地面或者你的技能沒有打到火球時能量會減少，當能量歸零你需要從頭開始遊戲。"
	AL["NOTE_336428"] = "在擊敗Herculon之後出現。"
	AL["NOTE_341424_1536"] = "這是寶藏所在金庫的入口。進入內部獲取更多說明。"
	AL["NOTE_341424_1649"] = "為了打開門，您必須拉出在此保險庫中的坐標25.53處懸掛的鏈條。"
	AL["NOTE_349794"] = "在建築物的後面，您可以從左側走過。"
	AL["NOTE_351544"] = "它在地下。您必須與寶藏所在房間正前方的房間中的肖像互動。在肖像後面，您會找到一個打開門的槓桿。"
	AL["NOTE_351544_1"] = "肖像"
	AL["NOTE_351980"] = "在蘑菇頂部"
	AL["NOTE_351980_1"] = "跳向蘑菇"
	AL["NOTE_351980_2"] = "跳到蜘蛛網"
	AL["NOTE_351980_3"] = "往這邊走"
	AL["NOTE_353871_1533"] = "它在地下。為了到達那裡，先走到小路的起點，然後沿著右牆向下走。"
	AL["NOTE_353940_1"] = "淨化之鐘"
	AL["NOTE_353940_2"] = "瀑布"
	AL["NOTE_353944_2"] = "跟隨點點"
	AL["NOTE_353944_3"] = "向上移動相機並從孔中找到火盆"
	AL["NOTE_354186"] = "它在牆的頂部，但是要到達那裡，您必須從較高的牆跳下。"
	AL["NOTE_354192"] = "它在山頂上。一旦到達頂部，進入一個小鎮，向右走然後從那裡跳。"
	AL["NOTE_354202"] = "它在地下。"
	AL["NOTE_354214"] = "它在地下。"
	AL["NOTE_354651"] = "它懸掛在拱門中間的頂部樹枝上。您可以通過從後面攀爬左側的岩石來到達目標。"
	AL["NOTE_355418_1"] = "在最上層平臺"
	AL["NOTE_355418_2"] = "在平臺下"
	AL["NOTE_355418_3"] = "在最高的平臺上，懸掛在樹上"
	AL["NOTE_355865"] = "右邊桌子的上方有一個小瓶子。在箱子上使用打開它。"
	AL["NOTE_355886_1"] = "從這走到水裏"
	AL["NOTE_355947"] = "在一個山洞裡。您必須殺死旁邊的兩個非精英NPC才能解鎖它。"
	AL["NOTE_357487"] = "在牆的頂部。"
	AL["NOTE_CRAFTING_NPCS"] = "您必須向池中添加原料，直到完成30/30。 ％s"
	AL["NOTE_FOUR_PEOPLE_NPCS"] = "需要4個人召喚他。"
	AL["NOTE_KYRIAN"] = "琪瑞安"
	AL["NOTE_NECROLORDS"] = "死靈領主"
	AL["NOTE_NIGHT_FAE"] = "暗夜妖精"
	AL["NOTE_TEMPLE_COURAGE"] = "勇氣聖殿"
	AL["NOTE_THEATER_PAIN"] = "苦痛劇場"
	AL["NOTE_THEATER_PAIN_NPCS"] = "開始擊敗敵人，直到您可以攻擊這個NPC。"
	AL["NOTE_VENTHYR"] = "汎希爾"
	AL["PILE_BONES"] = "骨堆"
	AL["PRE_EVENT"] = "事件：%s"
	AL["PROFILES"] = "設定檔"
	AL["RAIDS"] = "團隊"
	AL["RELIC_CACHE"] = "文物箱"
	AL["RESCAN_TIMER"] = "避免對同一個體持續發出警報的計時器"
	AL["RESCAN_TIMER_DESC"] = "定義該插件在同一時間段內多次發現時不會提醒您相同個體的時間（以分鐘為單位）。如果發現同一個體煩人的警報頻率，則應增加設置的時間量。"
	AL["RESET_POSITION"] = "重設位置"
	AL["RESET_POSITION_DESC"] = "重設主按鈕回復原始位置。"
	AL["SHADOWLANDS_PRE_PATCH_NEXTSPAWN"] = "暗影之境前夕事件：接下來將出現 %s ！在地圖上尋找粉紅色的骷髏頭。"
	AL["SHADOWLANDS_PRE_PATCH_SPAWNINGTIMER"] = "大約多久後重生: %s"
	AL["SHARDHIDE_STASH"] = "碎片貯藏"
	AL["SHOW_CHAT_ALERT"] = "顯示聊天通知"
	AL["SHOW_CHAT_ALERT_DESC"] = "每當寶藏、寶箱或NPC出現時，在聊天視窗中顯示一則私人訊息。"
	AL["SHOW_RAID_WARNING"] = "切換是否顯示團隊警告"
	AL["SHOW_RAID_WARNING_DESC"] = "每當財寶、箱子或NPC發現的時候顯示團隊警告在螢幕上。"
	AL["SOUND"] = "聲音"
	AL["SOUND_ADD"] = "加入自定義聲音"
	AL["SOUND_ADD_DESC"] = "輸入自定義聲音的名稱。 這是你會在上面的列表中看到的名稱。"
	AL["SOUND_AUDIOS"] = "聲音"
	AL["SOUND_CHANNEL"] = "聲音頻道"
	AL["SOUND_CHANNEL_DESC"] = "播放聲音提示的通道。除“主要”外，每個聲道都有用戶可配置的音量設置，且可被靜音。"
	AL["SOUND_CUSTOM_FILE"] = "聲音檔案"
	AL["SOUND_CUSTOM_FILE_DESC"] = "輸入復制到自定義音效文件夾中的音效檔案的名稱。 例如：“myaudio.ogg”。"
	AL["SOUND_CUSTOM_FILE_INFO"] = "使用說明"
	AL["SOUND_CUSTOM_FILE_INFO1"] = "1. 建立資料夾“World of Warcraft\\_retail_\\Interface\\addons\\%s"
	AL["SOUND_CUSTOM_FILE_INFO2"] = "2. 複製你的OGG或MP3格式的音頻檔案到此資料夾"
	AL["SOUND_CUSTOM_FILE_INFO3"] = "3. 如果你是在載入游戲後複製了檔案，請使用按鈕“%s”載入新的音頻檔案。"
	AL["SOUND_CUSTOM_FILE_INFO4"] = "4. 輸入檔案名稱並添加它。 例如“myaudio.ogg”"
	AL["SOUND_CUSTOM_FILE_INFO5"] = "5. 現在你就可以從上面的列表中選擇聲音了"
	AL["SOUND_CUSTOM_FOLDER"] = "自定義音效資料夾"
	AL["SOUND_CUSTOM_FOLDER_DESC"] = "“World of Warcraft\\_retail_\\Interface\\addons\\”中要存儲自定義音效檔案的資料夾的名稱。 "
	AL["SOUND_DELETE"] = "刪除"
	AL["SOUND_DELETE_DESC"] = "刪除此自定義聲音"
	AL["SOUND_OPTIONS"] = "聲音選項"
	AL["SOUND_PLAY"] = "播放"
	AL["SOUND_PLAY_DESC"] = "播放此自定義聲音。 如果聽不到，請檢查檔案路徑或嘗試重新載入您的游戲界面，以防音頻尚未載入。"
	AL["SOUND_RELOAD"] = "重載界面"
	AL["SOUND_RELOAD_DESC"] = "重新載入界面。 如果您在載入游戲後將音頻檔案複製到“RareScannerSounds”資料夾中，請使用此按鈕。"
	AL["SOUND_VOLUME"] = "音量"
	AL["SOUND_VOLUME_DESC"] = "設置音效的音量等級"
	AL["STOLEN_ANIMA_VESSEL"] = "失竊的靈魄容器"
	AL["TEST"] = "開始測試"
	AL["TEST_DESC"] = "按下按鈕以顯示通知範例，將面板拖曳到你想要擺放的合適位置。"
	AL["TOC_NOTES"] = "小地圖掃描器。當稀有NPC、寶藏/寶箱或事件出現在您的小地圖上時，使用一個按鈕與縮小的模型用視覺化的方式提醒您並播放聲音。"
	AL["TOGGLE_FILTERS"] = "切換過濾器"
	AL["TOGGLE_FILTERS_DESC"] = "一次切換所有過濾器"
	AL["TOMTOM_WAYPOINTS"] = "Tomtom路徑點"
	AL["TOOLTIP_BOTTOM"] = "下方"
	AL["TOOLTIP_BOTTOMLEFT"] = "左下側"
	AL["TOOLTIP_BOTTOMRIGHT"] = "右下側"
	AL["TOOLTIP_CURSOR"] = "跟隨游標"
	AL["TOOLTIP_LEFT"] = "左側"
	AL["TOOLTIP_RIGHT"] = "右側"
	AL["TOOLTIP_TOP"] = "上方"
	AL["TOOLTIP_TOPLEFT"] = "左上側"
	AL["TOOLTIP_TOPRIGHT"] = "右上側"
	AL["UNKNOWN"] = "未知"
	AL["UNKNOWN_TARGET"] = "未知目標"
	AL["ZONE_1332"] = "%s（戰爭前線）"
	AL["ZONE_1527"] = "%s（決戰艾澤拉斯突襲）"
	AL["ZONE_1530"] = "%s（決戰艾澤拉斯突襲）"
	AL["ZONE_1570"] = "%s（決戰艾澤拉斯恩若司的小幻象）"
	AL["ZONE_1571"] = "%s（決戰艾澤拉斯恩若司的小幻象）"
	AL["ZONE_317"] = "%s（人形區）"
	AL["ZONE_318"] = "%s（不死區）"
	AL["ZONE_943"] = "%s（戰爭前線）"
	AL["ZONES_FILTER"] = "過濾區域"
	AL["ZONES_FILTERS_SEARCH_DESC"] = "輸入區域名稱來過濾下方的清單"
	
	-- CONTINENT names
	AL["ZONES_CONTINENT_LIST"] = {
		[9999] = "職業大廳"; --Class Halls
		[9998] = "暗月島"; --Darkmoon Island
		[9997] = "地城/事件"; --Dungeons/Scenarios
		[9996] = "團隊"; --Raids
		[9995] = "未知"; --Unknown
		[9994] = "海嶼探險"; --Expedition islands
	}
end