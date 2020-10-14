-- GatherMate Locale
-- Please use the Localization App on WoWAce to Update this
-- http://www.wowace.com/projects/gathermate2/localization

local L = LibStub("AceLocale-3.0"):NewLocale("GatherMate2", "zhTW")
if not L then return end

-- Options
L["Add this location to Cartographer_Waypoints"] = "將該地點加入 Cartographer_Waypoints"
L["Add this location to TomTom waypoints"] = "將該地點加入 TomTom 導航目的地點"
L["Always show"] = "總是顯示"
L["Archaeology"] = "考古學"
L["Archaeology filter"] = "考古篩選"
L["Are you sure you want to delete all nodes from this database?"] = "您確定要刪除這資料庫所有的資源點嗎?"
L["Are you sure you want to delete all of the selected node from the selected zone?"] = "您確定要從選定的區域刪除所有選定的資源點嗎?"
L["Auto Import"] = "自動匯入"
L["Auto import complete for addon "] = "自動匯入資料源："
L["Automatically import when ever you update your data module, your current import choice will be used."] = "當你升級你的資料模組的時候自動匯入升級後的資料,你目前的匯入選項將控制匯入的資料類型."
L["Cataclysm"] = "浩劫與重生"
L["Cleanup Complete."] = "清理完成。"
L["Cleanup Database"] = "清理資料庫"
L["Cleanup Failed."] = "清理失敗"
L["Cleanup in progress."] = "清理執行中"
L["Cleanup radius"] = "清理半徑"
L["Cleanup Started."] = "清理開始"
L["Cleanup your database by removing duplicates. This takes a few moments, be patient."] = "清理你的資料庫，移除重復資料。這個過程可能持續幾分鐘，請耐心等待。"
L["Cleanup_Desc"] = "經過一段時間後,你的數據庫可能會非常大,清理資料可以讓你的相同專業的在一定範圍內的資料合併為一個,以避免重複."
L["CLEANUP_RADIUS_DESC"] = "設置以碼為單位的半徑，在半徑內的資料將被清除。預設值設定為|cffffd20050|r碼(氣雲)/|cffffd20015|r碼(其他採集資料)。這些設定也被用於新增的節點。"
L["Clear database selections"] = "清除資料庫的選擇"
L["Clear node selections"] = "清除選擇的資源點"
L["Clear zone selections"] = "清除地區的選擇"
L["Click to toggle minimap icons."] = "點一下切換顯示小地圖圖示。"
L["Color of the tracking circle."] = "追蹤環的顏色。"
L["Control various aspects of node icons on both the World Map and Minimap."] = "控制你想要在世界地圖和小地圖上顯示的多種資源點圖示。"
L["Conversion_Desc"] = "轉換現存的 GatherMate 資料至 GatherMate2 格式。"
L["Convert Databses"] = "轉換資料庫"
L["Database Locking"] = "資料庫鎖定"
L["Database locking"] = "資料庫鎖定"
L["Database Maintenance"] = "資料庫維護"
L["DATABASE_LOCKING_DESC"] = "資料庫鎖定功能可讓您凍結一個資料庫的狀態。一旦鎖定您將不再能夠新增，刪除或修改資料庫。這包括清理和匯入。"
L["Databases to Import"] = "匯入到資料庫"
L["Databases you wish to import"] = "你想要匯入的資料庫"
L["Delete"] = "刪除"
L["Delete Entire Database"] = "刪除整個資料庫"
L["Delete selected node from selected zone"] = "從選定的區域刪除所有選定的資源點"
L["Delete Specific Nodes"] = "刪除選定的資源點"
L["DELETE_ENTIRE_DESC"] = "這將會忽略資料庫鎖定並從選定的資料庫內所有的區域刪除所有的資源點。"
L["DELETE_SPECIFIC_DESC"] = "從選定的區域刪除所有選定的資源點。您必須停用資料庫鎖定才能運作。"
L["Disabled"] = "停用"
L["Display Settings"] = "顯示設定"
L["Enabled"] = "啟用"
L["Engineering"] = "工程學"
L["Expansion"] = "資料片"
L["Expansion Data Only"] = "僅匯入資料片資料"
L["Failed to load GatherMateData due to "] = "載入GatherMateData失敗:"
L["FAQ"] = "常見問題"
L["FAQ_TEXT"] = [=[|cffffd200
我剛剛安裝好GatherMate，為什麼在地圖上沒看到資源點?
|r
GatherMate 本身沒有內建的資料。當你在進行採集之後，GatherMate便會新增及更新你地圖上的資源點。還有，請撿查一下顯示設定。

|cffffd200
為什麼在地圖上有的資源點，但小地圖上卻沒有?
|r
|cffffff78Minimap Button Bag|r (可能是其它類似的插件)會覆蓋小地圖上的按鈕。請關掉它。

|cffffd200
怎樣可取得現成的資料?
|r
你可用三種方法把現成的資料匯GatherMate:

1. |cffffff78GatherMate_Data|r - 這個 LoD(按需要時載入)的插件，包含了WowHead收集的資源點並每周會作資料更新。提供自動更新的選項。

2. |cffffff78GatherMate_CartImport|r - 這插件讓你把現存|cffffff78Cartographer_<Profession>|r的資料庫匯入到 GatherMate。但一定要|cffffff78Cartographer_<Profession>|r模組和GatherMate_CartImport一起載入運作才能順利匯入資料。

注意:匯入資料到GatherMate並非自動運作。你要自己按匯入資料的按鈕。

這不同於|cffffff78Cartographer_Data|r能容許你作個別的修改資料，當載入|cffffff78Cartographer_Data|r時會覆寫你現存的資料庫和已發現的資源點。

|cffffd200
是否會加入其它的顯示，如郵箱和飛行管理員等等?
|r
答案是不會。不過，有些其它的插件作者可能會製作這樣的插件或模組，GatherMate核心程式不會考慮加入這些。

|cffffd200
我發現有臭蟲!在那裡可以舉報?
|r
你可以在|cffffff78http://www.wowace.com/forums/index.php?topic=10990.0|r裡貼文關於臭蟲或建議(不過要用英文)。

另外，你可以在|cffffff78irc://irc.freenode.org/wowace|r找到我們(也是要用英文)。

當舉報臭蟲時，請詳細說明|cffffff78引至錯誤的動作|r，提供 |cffffff78error messages|r，GatherMate的|cffffff78版本|r和你在在使用什麼語言系統|cffffff78英文或其它語言|r。

|cffffd200
誰製作這超酷的插件?
|r
Kagaro, Xinhuan, Nevcairiel and Ammo]=]
L["Filter_Desc"] = "選擇你想要在世界地圖和小地圖上顯示的資源點類型，不選擇的類型將僅記錄在資料庫中。"
L["Filters"] = "篩選"
L["Fish filter"] = "魚群篩選"
L["Fishes"] = "魚群"
L["Fishing"] = "釣魚"
L["Frequently Asked Questions"] = "常見問題解答"
L["Gas Clouds"] = "氣雲"
L["Gas filter"] = "氣雲篩選"
L["GatherMate Conversion"] = "GatherMate 轉換"
L["GatherMate data has been imported."] = "GatherMate 資料已匯入。"
L["GatherMate Pin Options"] = "採集助手地圖點選項"
L["GatherMate2Data has been imported."] = "GatherMate2Data 已匯入。"
L["GatherMateData has been imported."] = "GatherMateData已經被匯入。"
L["General"] = "一般"
L["Herb Bushes"] = "草藥"
L["Herb filter"] = "草藥篩選"
L["Herbalism"] = "草藥學"
L["Icon Alpha"] = "圖示透明度"
L["Icon alpha value, this lets you change the transparency of the icons. Only applies on World Map."] = "圖示透明度,這個選項讓你更改圖示的透明度,僅作用於世界地圖!"
L["Icon Scale"] = "圖示縮放"
L["Icon scaling, this lets you enlarge or shrink your icons on both the World Map and Minimap."] = "圖示縮放,這個選項讓你把世界地圖和小地圖上的圖示放大或縮小."
L["Icon scaling, this lets you enlarge or shrink your icons on the Minimap."] = "圖示縮放，這能讓你放大或縮小小地圖上的圖示"
L["Icon scaling, this lets you enlarge or shrink your icons on the World Map."] = "圖示縮放，這能讓你放大或縮小世界地圖上的圖示"
L["Icons"] = "圖示"
L["Import Data"] = "匯入資料"
L["Import GatherMate2Data"] = "匯入 GatherMate2Data"
L["Import GatherMateData"] = "匯入 GatherMateData"
L["Import Options"] = "匯入選項"
L["Import Style"] = "匯入模式"
L["Importing_Desc"] = "匯入允許 GatherMate 從其他來源獲取節點資料.匯入結束後,你最好進行一次資料清理."
L["Keybind to toggle Minimap Icons"] = "切換顯示小地圖資源點圖示快速鍵"
L["Keybind to toggle Worldmap Icons"] = "切換顯示世界地圖資源點圖示快速鍵"
L["Legion"] = "軍臨天下"
L["Load GatherMate2Data and import the data to your database."] = "載入GatherMate2Data並把資料匯入到你的資料庫。"
L["Load GatherMateData and import the data to your database."] = "載入GatherMateData並把資料匯入到你的資料庫。"
L["Merge"] = "合併"
L["Merge will add GatherMate2Data to your database. Overwrite will replace your database with the data in GatherMate2Data"] = "合併將 GatherMate2Date 資料加入你的資料庫，覆蓋將用GatherMate2Data中的資料替換你現有的資料庫"
L["Merge will add GatherMateData to your database. Overwrite will replace your database with the data in GatherMateData"] = "合併將 GatherMateDate 資料加入你的資料庫，覆蓋將用GatherMateData中的資料替換你現有的資料庫"
L["Mine filter"] = "礦脈篩選"
L["Mineral Veins"] = "礦脈"
L["Minimap Icon Scale"] = "小地圖圖示縮放"
L["Minimap Icon Tooltips"] = "小地圖圖示的滑鼠提示"
L["Minimap Icons"] = "小地圖圖示"
L["Mining"] = "採礦"
L["Mists of Pandaria"] = "潘達利亞之謎"
L["Never show"] = "從不顯示"
L["Only import selected expansion data from WoWDB"] = "從WoWDB中僅匯入到選擇的擴展資料庫"
L["Only import selected expansion data from WoWhead"] = "從WoWhead中僅匯入到選擇的擴展資料庫"
L["Only while tracking"] = "僅顯示追蹤相關"
L["Only with digsite"] = "只有挖掘場"
L["Only with profession"] = "僅顯示專業相關"
L["Overwrite"] = "覆蓋"
L["Processing "] = "正在處理……"
L["Right-click for options."] = "右鍵點擊開啟設定選單"
L["Select All"] = "全部選擇"
L["Select all databases"] = "選擇全部資料庫"
L["Select all nodes"] = "選擇全部資源點"
L["Select all zones"] = "選擇全部地區"
L["Select Database"] = "選擇資料庫"
L["Select Databases"] = "選擇資料庫"
L["Select Node"] = "選擇資源點"
L["Select None"] = "清空選擇"
L["Select the archaeology nodes you wish to display."] = "選擇你想要顯示的考古資源點"
L["Select the fish nodes you wish to display."] = "選擇你想要顯示的魚群資源點."
L["Select the gas clouds you wish to display."] = "選擇你想要顯示的氣雲資源點."
L["Select the herb nodes you wish to display."] = "選擇你想要顯示的草藥資源點."
L["Select the mining nodes you wish to display."] = "選擇你想要顯示的礦脈資源點."
L["Select the treasure you wish to display."] = "選擇你想要顯示的寶藏資源點."
L["Select Zone"] = "選擇地區"
L["Select Zones"] = "選擇地區"
L["Selected databases are shown on both the World Map and Minimap."] = "在世界地圖和小地圖上顯示已選用的資料庫。"
L["Shift-click to toggle world map icons."] = "Shift-左鍵點擊切換顯示世界地圖圖示。"
L["Show Archaeology Nodes"] = "顯示考古"
L["Show Databases"] = "顯示資料庫"
L["Show Fishing Nodes"] = "顯示魚群"
L["Show Gas Clouds"] = "顯示氣雲"
L["Show Herbalism Nodes"] = "顯示草藥"
L["Show Minimap Icons"] = "顯示小地圖圖示"
L["Show Mining Nodes"] = "顯示礦脈"
L["Show Nodes on Minimap Border"] = "小地圖邊沿顯示資源點"
L["Show Timber Nodes"] = "顯示木料"
L["Show Tracking Circle"] = "顯示追蹤環"
L["Show Treasure Nodes"] = "顯示寶藏"
L["Show World Map Icons"] = "顯示世界地圖圖示"
L["Shows more Nodes that are currently out of range on the minimap's border."] = "在小地圖邊界上顯示哪些超出小地圖的資源點."
L["The Burning Crusades"] = "燃燒的遠征"
L["The distance in yards to a node before it turns into a tracking circle"] = "在一個資源點變成追蹤環之前的距離."
L["The Frozen Sea"] = "冰凍之海"
L["The North Sea"] = "北海"
L["Toggle if World Map icons are clickable (to remove them or generate way points)."] = "切換世界地圖圖示是否可以點擊 (來移除圖示或建立導航點)。"
L["Toggle showing archaeology nodes."] = "切換顯示考古點."
L["Toggle showing fishing nodes."] = "切換顯示魚群垂釣點."
L["Toggle showing gas clouds."] = "切換顯示氣雲(微粒採集點)."
L["Toggle showing herbalism nodes."] = "切換顯示草藥採集點."
L["Toggle showing Minimap icon tooltips."] = "切換是否要顯示小地圖圖示的滑鼠提示。"
L["Toggle showing Minimap icons."] = "切換顯示小地圖圖示。"
L["Toggle showing mining nodes."] = "切換顯示礦脈採集點."
L["Toggle showing the tracking circle."] = "切換是否顯示追蹤環."
L["Toggle showing timber nodes."] = "開啟顯示木料結點"
L["Toggle showing treasure nodes."] = "切換顯示財寶地點."
L["Toggle showing World Map icons."] = "切換顯示世界地圖圖示。"
L["Tracking Circle Color"] = "追蹤環顏色"
L["Tracking Distance"] = "追蹤距離"
L["Treasure"] = "財寶"
L["Treasure filter"] = "寶藏篩選"
L["Warlords of Draenor"] = "德拉諾之霸"
L["World Map Icon Scale"] = "世界地圖圖示縮放"
L["World Map Icons"] = "世界地圖圖示"
L["World Map Icons Clickable"] = "可點擊世界地圖圖示"
L["Wrath of the Lich King"] = "巫妖王之怒"


local NL = LibStub("AceLocale-3.0"):NewLocale("GatherMate2Nodes", "zhTW")
if not NL then return end

-- Nodes
NL["Abundant Bloodsail Wreckage"] = "豐碩漂浮殘骸"
NL["Abundant Firefin Snapper School"] = "豐碩火鰭鯛魚群"
NL["Abundant Oily Blackmouth School"] = "豐碩黑口魚群"
NL["Abyssal Gulper School"] = "深淵大嘴鰻群"
NL["Adamantite Bound Chest"] = "堅鋼箱"
NL["Adamantite Deposit"] = "堅鋼礦床"
NL["Adder's Tongue"] = "奎蛇之舌"
NL["Aethril"] = "紫地根草"
NL["Akunda's Bite"] = "亞昆達之噬"
NL["Albino Cavefish School"] = "白化穴魚群"
NL["Algaefin Rockfish School"] = "藻鰭岩魚群"
NL["Anchor Weed"] = "錨草"
NL["Ancient Lichen"] = "古老青苔"
NL["Ancient Mana Chunk"] = "上古法力塊"
NL["Ancient Mana Crystal"] = "上古法力水晶"
NL["Ancient Mana Shard"] = "上古法力裂片"
NL["Arakkoa Archaeology Find"] = "阿拉卡考古學文物"
NL["Arcane Vortex"] = "秘法漩渦"
NL["Arctic Cloud"] = "極地雲"
NL["Arthas' Tears"] = "阿薩斯之淚"
NL["Astral Glory"] = "暗星之芒"
NL["Azshara's Veil"] = "艾薩拉的帷紗"
NL["Battered Chest"] = "破損的箱子"
NL["Battered Footlocker"] = "破碎的置物箱"
NL["Black Barracuda School"] = "黑色梭子魚群"
NL["Black Lotus"] = "黑蓮花"
NL["Black Trillium Deposit"] = "黑延齡礦石"
NL["Blackbelly Mudfish School"] = "黑肚泥鰍群"
NL["Blackrock Deposit"] = "黑石礦床"
NL["Blackwater Whiptail School"] = "黑水鞭尾魚群"
NL["Blind Lake Sturgeon School"] = "盲湖鱘魚群"
NL["Blindweed"] = "盲目草"
NL["Blood of Heroes"] = "英雄之血"
NL["Bloodpetal Sprout"] = "血瓣花苗"
NL["Bloodsail Wreckage"] = "血帆殘骸"
NL["Bloodsail Wreckage Pool"] = "血帆殘骸"
NL["Bloodthistle"] = "血薊"
NL["Bloodvine"] = "血藤"
NL["Bluefish School"] = "藍魚群"
NL["Borean Man O' War School"] = "北風水母群"
NL["Bound Adamantite Chest"] = "受封的堅鋼箱子"
NL["Bound Fel Iron Chest"] = "受封的魔鐵箱"
NL["Brackish Mixed School"] = "魔尾魚群"
NL["Briarthorn"] = "石南草"
NL["Brightly Colored Egg"] = "明亮的彩蛋"
NL["Bruiseweed"] = "跌打草"
NL["Buccaneer's Strongbox"] = "海盜的保險箱"
NL["Burial Chest"] = "埋葬箱"
NL["Cinder Cloud"] = "煤渣雲"
NL["Cinderbloom"] = "燼花"
NL["Cobalt Deposit"] = "鈷藍礦床"
NL["Copper Vein"] = "銅礦脈"
NL["Cursed Queenfish School"] = "詛咒皇后魚群"
NL["Dark Iron Deposit"] = "黑鐵礦床"
NL["Dark Iron Treasure Chest"] = "黑鐵寶箱"
NL["Dark Soil"] = "深色土壤"
NL["Dart's Nest"] = "達爾特的巢"
NL["Deep Sea Monsterbelly School"] = "深海大肚魚群"
NL["Deepsea Sagefish School"] = "深海鼠尾魚群"
NL["Demonic Archaeology Find"] = "惡魔考古學文物"
NL["Dented Footlocker"] = "被砸過的箱子"
NL["Draenei Archaeology Find"] = "德萊尼考古學文物"
NL["Draenor Clans Archaeology Find"] = "德拉諾氏族考古學文物"
NL["Dragonfin Angelfish School"] = "龍鱗天使魚群"
NL["Dragon's Teeth"] = "龍之牙"
NL["Dreamfoil"] = "夢葉草"
NL["Dreaming Glory"] = "譽夢草"
NL["Dreamleaf"] = "幻夢草"
NL["Drust Archaeology Find"] = "佐司特考古學文物"
NL["Dwarf Archaeology Find"] = "矮人考古學文物"
NL["Earthroot"] = "地根草"
NL["Elementium Vein"] = "源質礦脈"
NL["Emperor Salmon School"] = "帝王鮭魚群"
NL["Empyrium Deposit"] = "燦鐵礦床"
NL["Empyrium Seam"] = "燦鐵礦層"
NL["Everfrost Chip"] = "永霜屑片"
NL["Fadeleaf"] = "枯葉草"
NL["Fangtooth Herring School"] = "尖齒鯡魚群"
NL["Fat Sleeper School"] = "胖睡魚魚群"
NL["Fathom Eel Swarm"] = "澗鰻群"
NL["Fel Iron Chest"] = "魔鐵箱"
NL["Fel Iron Deposit"] = "魔鐵礦床"
NL["Fel-Encrusted Herb"] = "魔覆草藥"
NL["Fel-Encrusted Herb Cluster"] = "魔覆草藥簇"
NL["Felmist"] = "魔化霧"
NL["Felmouth Frenzy School"] = "魔嘴狂魚群"
NL["Felslate Deposit"] = "魔岩礦床"
NL["Felslate Seam"] = "魔岩礦層"
NL["Felsteel Chest"] = "魔鋼箱"
NL["Feltail School"] = "魔尾魚群"
NL["Felweed"] = "魔獄草"
NL["Felwort"] = "魔草"
NL["Fever of Stormrays"] = "一群風暴魟魚"
NL["Fire Ammonite School"] = "火焰菊石群"
NL["Firebloom"] = "火焰花"
NL["Firefin Snapper School"] = "火鰭鯛魚群"
NL["Firethorn"] = "火棘"
NL["Fireweed"] = "火草"
NL["Fjarnskaggl"] = "鬼燈果"
NL["Flame Cap"] = "火帽花"
NL["Floating Debris"] = "漂浮的碎片"
NL["Floating Debris Pool"] = "漂浮的殘骸"
NL["Floating Shipwreck Debris"] = "沈船殘骸"
NL["Floating Wreckage"] = "漂浮殘骸"
NL["Floating Wreckage Pool"] = "漂浮殘骸之池"
NL["Fool's Cap"] = "丑帽菇"
NL["Fossil Archaeology Find"] = "石化的考古學文物"
NL["Foxflower"] = "狐花"
NL["Frenzied Fangtooth School"] = "尖牙狂魚群"
NL["Frost Lotus"] = "冰霜蓮花"
NL["Frostweed"] = "霜草"
NL["Frozen Herb"] = "冰凍草藥"
NL["Ghost Iron Deposit"] = "鬼鐵礦床"
NL["Ghost Mushroom"] = "鬼魂菇"
NL["Giant Clam"] = "巨型蚌殼"
NL["Giant Mantis Shrimp Swarm"] = "巨型螳螂蝦群"
NL["Glacial Salmon School"] = "冰川鮭魚群"
NL["Glassfin Minnow School"] = "玻鰭小鯉魚群"
NL["Gleaming Draenic Chest"] = "閃閃發光的德萊尼寶箱"
NL["Glimmering Chest"] = "發光的寶箱"
NL["Glowcap"] = "白閃菇"
NL["Glowing Tome"] = "發光典籍"
NL["Gold Vein"] = "金礦脈"
NL["Goldclover"] = "金黃苜蓿"
NL["Golden Carp School"] = "金鯉魚群"
NL["Golden Lotus"] = "黃金蓮"
NL["Golden Sansam"] = "黃金蔘"
NL["Goldthorn"] = "金棘草"
NL["Gorgrond Flytrap"] = "格古隆德捕蠅草"
NL["Grave Moss"] = "墓地苔"
NL["Great Sea Catfish School"] = "無盡之海鯰魚群"
NL["Greater Sagefish School"] = "大型鼠尾魚群"
NL["Green Tea Leaf"] = "綠茶葉"
NL["Gromsblood"] = "格羅姆之血"
NL["Heartblossom"] = "心綻花"
NL["Heavy Fel Iron Chest"] = "沉重的魔鐵箱"
NL["Highborne Archaeology Find"] = "精靈貴族考古學文物"
NL["Highland Guppy School"] = "高地孔雀魚群"
NL["Highland Mixed School"] = "高地綜合魚群"
NL["Highmaul Reliquary"] = "天槌聖物"
NL["Highmountain Salmon School"] = "高嶺鮭魚群"
NL["Highmountain Tauren Archaeology Find"] = "高嶺牛頭人考古學文物"
NL["Huge Obsidian Slab"] = "巨型黑曜石片"
NL["Icecap"] = "冰蓋草"
NL["Icethorn"] = "冰棘"
NL["Imperial Manta Ray School"] = "帝王韌皮魟魚群"
NL["Incendicite Mineral Vein"] = "火岩礦脈"
NL["Indurium Mineral Vein"] = "精鐵礦脈"
NL["Ionized Minnows"] = "離子小鯉"
NL["Iron Deposit"] = "鐵礦床"
NL["Jade Lungfish School"] = "翠玉龍魚群"
NL["Jawless Skulker School"] = "無頷潛藏者魚群"
NL["Jelly Deposit"] = "蜂王乳儲藏處"
NL["Jewel Danio School"] = "珠寶斑馬魚群"
NL["Khadgar's Whisker"] = "卡德加的鬍鬚"
NL["Khorium Vein"] = "克銀礦脈"
NL["Kingsblood"] = "皇血草"
NL["Krasarang Paddlefish School"] = "喀撒朗匙吻鱘魚群"
NL["Kyparite Deposit"] = "奇帕利礦床"
NL["Lagoon Pool"] = "潟湖水池"
NL["Lane Snapper School"] = "笛鯛魚群"
NL["Large Battered Chest"] = "破碎的大箱子"
NL["Large Darkwood Chest"] = "大型黑木箱"
NL["Large Iron Bound Chest"] = "大型鐵箍儲物箱"
NL["Large Jelly Deposit"] = "大型蜂王乳儲藏處"
NL["Large Mithril Bound Chest"] = "大型秘銀儲物箱"
NL["Large Obsidian Chunk"] = "大黑曜石塊"
NL["Large Solid Chest"] = "堅固的大箱子"
NL["Large Timber"] = "大型木料"
NL["Lesser Bloodstone Deposit"] = "次級血石礦床"
NL["Lesser Firefin Snapper School"] = "火鰭鯛魚群"
NL["Lesser Floating Debris"] = "漂浮的碎片"
NL["Lesser Oily Blackmouth School"] = "小型黑口魚群"
NL["Lesser Sagefish School"] = "小型鼠尾魚群"
NL["Leypetal Blossom"] = "地脈花朵"
NL["Leypetal Powder"] = "地脈花粉"
NL["Leystone Deposit"] = "脈石礦床"
NL["Leystone Seam"] = "脈石礦層"
NL["Lichbloom"] = "低語藤"
NL["Liferoot"] = "活根草"
NL["Lumber Mill"] = "鋸木廠"
NL["Mageroyal"] = "魔皇草"
NL["Mana Thistle"] = "法力薊"
NL["Mana-Infused Gem"] = "法力灌注珠寶"
NL["Mantid Archaeology Find"] = "螳螂人考古學文物"
NL["Maplewood Treasure Chest"] = "楓木寶箱"
NL["Mauve Stinger School"] = "淡紫刺尾魚群"
NL["Mechanized Chest"] = "機械箱"
NL["Mithril Deposit"] = "秘銀礦床"
NL["Mixed Ocean School"] = "各種海洋魚群"
NL["Mogu Archaeology Find"] = "魔古考古學文物"
NL["Monelite Deposit"] = "蒙那萊礦床"
NL["Monelite Seam"] = "蒙那萊礦層"
NL["Moonglow Cuttlefish School"] = "月色墨魚群"
NL["Mossgill Perch School"] = "蘚鰓鱸魚群"
NL["Mossy Footlocker"] = "生苔的置物箱"
NL["Mountain Silversage"] = "山鼠草"
NL["Mountain Trout School"] = "山脈鱒魚群"
NL["Muddy Churning Water"] = "混濁的水"
NL["Mudfish School"] = "泥鰍群"
NL["Musselback Sculpin School"] = "蚌脊魚群"
NL["Mysterious Camel Figurine"] = "神秘駱駝刻像"
NL["Nagrand Arrowbloom"] = "納葛蘭箭矢花"
NL["Nerubian Archaeology Find"] = "奈幽考古學文物"
NL["Netherbloom"] = "虛空花"
NL["Nethercite Deposit"] = "虛空聚晶礦床"
NL["Netherdust Bush"] = "虛空之塵灌木"
NL["Netherwing Egg"] = "虛空之翼蛋"
NL["Nettlefish School"] = "蕁麻魚群"
NL["Night Elf Archaeology Find"] = "夜精靈考古學文物"
NL["Nightmare Vine"] = "夢魘根"
NL["Obsidian Chunk"] = "黑曜石塊"
NL["Obsidium Deposit"] = "黑曜石塊"
NL["Ogre Archaeology Find"] = "巨魔考古學文物"
NL["Oil Spill"] = "油井"
NL["Oily Abyssal Gulper School"] = "油性深淵大嘴鰻魚群"
NL["Oily Blackmouth School"] = "黑口魚群"
NL["Oily Sea Scorpion School"] = "肥美的海蠍群"
NL["Onyx Egg"] = "瑪瑙蛟蛋"
NL["Ooze Covered Gold Vein"] = "軟泥覆蓋的金礦脈"
NL["Ooze Covered Mithril Deposit"] = "軟泥覆蓋的秘銀礦床"
NL["Ooze Covered Rich Thorium Vein"] = "軟泥覆蓋的富瑟銀礦脈"
NL["Ooze Covered Silver Vein"] = "軟泥覆蓋的銀礦脈"
NL["Ooze Covered Thorium Vein"] = "軟泥覆蓋的瑟銀礦脈"
NL["Ooze Covered Truesilver Deposit"] = "軟泥覆蓋的真銀礦床"
NL["Orc Archaeology Find"] = "獸人考古學文物"
NL["Osmenite Deposit"] = "奧司曼礦床"
NL["Osmenite Seam"] = "奧司曼礦層"
NL["Other Archaeology Find"] = "其他考古學文物"
NL["Pandaren Archaeology Find"] = "熊貓人考古學文物"
NL["Patch of Elemental Water"] = "元素之水"
NL["Peacebloom"] = "寧神花"
NL["Plaguebloom"] = "瘟疫花"
NL["Platinum Deposit"] = "白金礦床"
NL["Pool of Fire"] = "火池"
NL["Practice Lockbox"] = "練習用帶鎖箱"
NL["Primitive Chest"] = "遠古箱子"
NL["Prismatic Crystal"] = "稜彩水晶"
NL["Pure Saronite Deposit"] = "純淨薩鋼礦床"
NL["Pure Water"] = "純水"
NL["Purple Lotus"] = "紫蓮花"
NL["Pyrite Deposit"] = "黃鐵礦床"
NL["Radiating Apexis Shard"] = "散射頂尖裂片"
NL["Ragveil"] = "拉格維花"
NL["Rain Poppy"] = "雨罌粟"
NL["Rasboralus School"] = "伯拉勒斯波魚群"
NL["Ravasaur Matriarch's Nest"] = "暴掠龍族母的巢"
NL["Razormaw Matriarch's Nest"] = "刺喉龍族母的巢"
NL["Redbelly Mandarin School"] = "紅肚桂花魚群"
NL["Redtail Loach School"] = "紅尾泥鰍魚群"
NL["Reef Octopus Swarm"] = "暗礁章魚群"
NL["Rich Adamantite Deposit"] = "豐沃的堅鋼礦床"
NL["Rich Blackrock Deposit"] = "豐沃的黑石礦床"
NL["Rich Cobalt Deposit"] = "豐沃的鈷藍礦床"
NL["Rich Elementium Vein"] = "豐沃的源質礦脈"
NL["Rich Empyrium Deposit"] = "豐沃的燦鐵礦床"
NL["Rich Felslate Deposit"] = "豐沃的魔岩礦床"
NL["Rich Ghost Iron Deposit"] = "豐沃的鬼鐵礦脈"
NL["Rich Kyparite Deposit"] = "豐沃的奇帕利礦床"
NL["Rich Leystone Deposit"] = "豐沃的脈石礦床"
NL["Rich Monelite Deposit"] = "豐沃的蒙那萊礦床"
NL["Rich Obsidium Deposit"] = "豐沃的黑曜石塊"
NL["Rich Osmenite Deposit"] = "豐沃的奧司曼礦床"
NL["Rich Platinum Deposit"] = "豐沃的白金礦床"
NL["Rich Pyrite Deposit"] = "豐沃的黃鐵礦床"
NL["Rich Saronite Deposit"] = "豐沃的薩鋼礦床"
NL["Rich Storm Silver Deposit"] = "豐沃的風暴白銀礦床"
NL["Rich Thorium Vein"] = "富瑟銀礦脈"
NL["Rich Trillium Vein"] = "豐沃的延齡礦脈"
NL["Rich True Iron Deposit"] = "豐沃的真鐵礦床"
NL["Riverbud"] = "河芽草"
NL["Runescale Koi School"] = "符鱗錦鯉魚群"
NL["Runestone Treasure Chest"] = "符文寶箱"
NL["Sagefish School"] = "鼠尾魚群"
NL["Sand Shifter School"] = "變幻砂礫魚群"
NL["Saronite Deposit"] = "薩鋼礦床"
NL["Savage Piranha Pool"] = "蠻荒食人魚池"
NL["Scarlet Footlocker"] = "血色十字軍置物箱"
NL["School of Darter"] = "淡水魚群"
NL["School of Deviate Fish"] = "變異魚群"
NL["School of Tastyfish"] = "可口魚群"
NL["Schooner Wreckage"] = "漂浮的殘骸"
NL["Schooner Wreckage Pool"] = "帆船殘骸區域"
NL["Sea Scorpion School"] = "海蠍群"
NL["Sea Stalks"] = "海莖草"
NL["Sentry Fish School"] = "哨兵魚群"
NL["Sha-Touched Herb"] = "煞化的藥草"
NL["Shipwreck Debris"] = "沉船殘骸"
NL["Silken Treasure Chest"] = "絲質寶箱"
NL["Silkweed"] = "絲草"
NL["Silver Vein"] = "銀礦脈"
NL["Silverbound Treasure Chest"] = "鑲銀寶箱"
NL["Silverleaf"] = "銀葉草"
NL["Siren's Sting"] = "海妖之棘"
NL["Slimy Mackerel School"] = "黏滑鯖魚群"
NL["Small Obsidian Chunk"] = "小黑曜石塊"
NL["Small Thorium Vein"] = "瑟銀礦脈"
NL["Small Timber"] = "小型木料"
NL["Snow Lily"] = "雪百合"
NL["Solid Chest"] = "堅固的箱子"
NL["Solid Fel Iron Chest"] = "堅固的魔鐵箱"
NL["Sorrowmoss"] = "悲傷苔蘚"
NL["Sparkling Pool"] = "冒泡的池子"
NL["Sparse Firefin Snapper School"] = "稀疏火鰭鯛魚群"
NL["Sparse Oily Blackmouth School"] = "稀疏黑口魚群"
NL["Sparse Schooner Wreckage"] = "稀疏漂浮的殘骸"
NL["Spinefish School"] = "棘魚群"
NL["Sporefish School"] = "孢子魚群"
NL["Star Moss"] = "星苔"
NL["Starflower"] = "星辰花"
NL["Starlight Rose"] = "星輝玫瑰"
NL["Steam Cloud"] = "蒸汽雲"
NL["Steam Pump Flotsam"] = "蒸汽幫浦漂浮殘骸"
NL["Stonescale Eel Swarm"] = "石鱗鰻魚群"
NL["Storm Silver Deposit"] = "風暴白銀礦床"
NL["Storm Silver Seam"] = "風暴白銀礦層"
NL["Stormvine"] = "風暴藤"
NL["Strange Pool"] = "奇怪的水池"
NL["Stranglekelp"] = "荊棘藻"
NL["Sturdy Treasure Chest"] = "結實的寶箱"
NL["Sungrass"] = "太陽草"
NL["Suspiciously Glowing Chest"] = "發光的可疑箱子"
NL["Swamp Gas"] = "沼氣"
NL["Takk's Nest"] = "塔克的巢"
NL["Talador Orchid"] = "塔拉多爾蘭花"
NL["Talandra's Rose"] = "泰蘭卓的玫瑰"
NL["Tattered Chest"] = "破爛的箱子"
NL["Teeming Firefin Snapper School"] = "群聚火鰭鯛魚群"
NL["Teeming Floating Wreckage"] = "群聚漂浮的殘骸"
NL["Teeming Oily Blackmouth School"] = "群聚黑口魚群"
NL["Terocone"] = "泰魯草"
NL["Tiger Gourami School"] = "虎斑絲足魚群"
NL["Tiger Lily"] = "虎百合"
NL["Timber"] = "中型木料"
NL["Tin Vein"] = "錫礦脈"
NL["Tiragarde Perch School"] = "提拉加德鱸魚群"
NL["Titanium Vein"] = "泰坦鋼礦脈"
NL["Tol'vir Archaeology Find"] = "托維爾考古學文物"
NL["Trillium Vein"] = "延齡礦脈"
NL["Troll Archaeology Find"] = "食人妖考古學文物"
NL["Trove of the Thunder King"] = "雷王的珍寶"
NL["True Iron Deposit"] = "真鐵礦床"
NL["Truesilver Deposit"] = "真銀礦床"
NL["Twice-Fortified Arcwine"] = "兩次加烈的秘能酒"
NL["Twilight Jasmine"] = "暮光茉莉"
NL["Un'Goro Dirt Pile"] = "安戈落泥土堆"
NL["U'taka School"] = "烏塔卡魚群"
NL["Viper Fish School"] = "毒牙魚群"
NL["Vrykul Archaeology Find"] = "維酷考古學文物"
NL["Waterlogged Footlocker"] = "浸水的置物箱"
NL["Waterlogged Wreckage"] = "浸水的殘骸"
NL["Waterlogged Wreckage Pool"] = "浸水的殘骸"
NL["Whiptail"] = "鞭尾蜥草"
NL["White Trillium Deposit"] = "白延齡礦石"
NL["Wicker Chest"] = "柳條箱"
NL["Wild Steelbloom"] = "野鋼花"
NL["Windy Cloud"] = "多風之雲"
NL["Winter's Kiss"] = "冬吻花"
NL["Wintersbite"] = "冬刺草"
NL["Withered Herb"] = "枯萎的草藥"
NL["Zandalari Archaeology Find"] = "贊達拉考古學文物"
NL["Zin'anthid"] = "辛葵"

