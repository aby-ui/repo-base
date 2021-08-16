local L = LibStub("AceLocale-3.0"):NewLocale("OmniCD", "zhTW")

L = L or {}
L[ [=[%d: spellID.
%d-%d: spellID-talentID (Mark spell if talent is selected).]=] ] = "%d: 法術 ID。%d-%d: 法術 ID-天賦 ID (選擇天賦後標記法術)。"
L["|cff9d9d9d * Scenarios and Outdoor Zones will use Arena settings."] = "|cff9d9d9d * 事件和戶外區域會使用競技場的設定。"
L["|cffff2020Glow and Highlights are never applied on cropped icons. \"Border\" must be enabled."] = "|cffff2020剪裁過的圖示不會發光和顯著標示，必須啟用 \"邊框\"。"
L["|cffff2020Important!|r Covenant and Soulbind Conduit data can only be acquired from group members with OmniCD installed."] = "|cffff2020重要!|r 只有安裝隊友技能冷卻插件 OmniCD 的隊友才能取得誓盟和靈印資料。"
L["> 1 minute"] = "> 1 分鐘"
L["2nd Row Icons (Double Row Layout)"] = "第二排圖示 (兩排版面配置)"
L["2px Border"] = "2px 邊框"
L["A new update is available. (|cff99cdff%s)"] = "有新版本可以使用。(|cff99cdff%s)"
L["Active"] = "啟動"
L["Active Icon Opacity"] = "冷卻中圖示不透明度"
L["Active Icon Settings"] = "冷卻中圖示設定"
L["Add spell to Spell Alerts"] = "將法術加入到法術通知"
L["Add Spells"] = "新增法術"
L["Add to Alerts"] = "加入通知"
L["Alerts"] = "通知"
L["All user set values will be lost. Do you want to proceed?"] = "所有由使用者所設定的值都會消失，是否確定要繼續?"
L["Always attach to Blizzard frames. By default, bars attach to whichever frame is visible, and if both are visible UF addon take precedence over Blizzard"] = "總是附加到遊戲內建的隊伍框架。圖示列會附加到任何能看見的隊伍框架，如果同時也能看見插件的隊伍框架時，預設會附加到插件的框架而不會遊戲內建的。"
L["Always Bottom"] = "總是在下方"
L["Always Top"] = "總是在上方"
L["Anchor"] = "對齊"
L["Anchor Point"] = "對齊點"
L["Anchor Position"] = "對齊位置"
L["Animate"] = "動畫"
L["Apply 'Icons' alpha settings to the status bar"] = "將 '圖示' 的透明度設定套用到狀態列"
L["Ascending"] = "升冪"
L["Assign Raid Cooldowns."] = "指定團隊冷卻。"
L["Attach to Blizzard Frames"] = "附加到遊戲內建的隊伍框架"
L["Attachment Point"] = "附加點"
L["Author"] = "作者"
L["Auto"] = "自動"
L["Bar"] = "技能列"
L["Bar width"] = "狀態列寬度"
L["BG"] = "背景"
L["Blizzard Raid Frames has been disabled by your AddOn(s). Enable and reload UI?"] = "遊戲內建的團隊框架已經被其他插件停用。是否要啟用它並且重新載入介面。"
L["Border"] = "邊框"
L["Border Color"] = "邊框顏色"
L["Border Thickness"] = "邊框粗細"
L["Borders retain 1px width regardless of the UI scale"] = "無視使用者介面縮放大小，邊框永遠保持 1px。"
L["Borders retain 1px width regardless of the UI scale. Need to reload the UI when the UI or icon scale changes"] = "無視使用者介面縮放大小，邊框永遠保持 1px。更改介面或圖示的縮放大小後需要重新載入介面。"
L["BOTTOM"] = "下"
L["BOTTOMLEFT"] = "左下"
L["BOTTOMRIGHT"] = "右下"
L["Breakpoint"] = "換行/排"
L["Buff ID (Optional)"] = "增益效果 ID (選擇性)"
L["Cannot edit protected spell"] = "無法編輯受保護的法術"
L["Cannot test while in combat"] = "戰鬥中無法測試"
L["CD-Group %d"] = "冷卻群組 %d"
L["CD-Group Padding"] = "冷卻群組間距"
L["CENTER"] = "中"
L["Center Horizontally"] = "水平置中"
L["Changelog"] = "更新資訊"
L["Changing party display options in your UF addon while OmniCD is active will break the anchors. Type (/oc rl) to fix the anchors"] = "當 OmniCD 處於啟用狀態時，更改隊伍框架插件的顯示選項會打亂隊友技能監控圖示的對齊位置。請輸入 /oc rl 來修正對齊位置。"
L["Charge Color"] = "次數顏色"
L["Charge Size"] = "次數大小"
L["Charges"] = "次數"
L["Check All"] = "全選"
L["Check this option if the spell is a talent ability to ensure proper spell detection"] = "如果法術是天賦的技能，請勾選這個選項，以確保使用合適的法術偵測。"
L["Clean wipe the savedvariable file. |cffff2020Warning|r: This can not be undone!"] = "清空 savedvariable 檔案。|cffff2020警告|r: 刪除後將無法還原!"
L["Column"] = "行數"
L["Column Padding"] = "直行間距"
L["Commands:"] = "指令:"
L["Convert the status bar timer to a simple name display by disabling all timer functions. The 'Name' color scheme will be retained."] = "停用所有的時間功能，將狀態列的時間改為只顯示名字。將會保留 '名字' 的配色。"
L["Convert to Name Bar"] = "轉換為名字列"
L["Cooldown"] = "冷卻"
L["Cooldown Remaining"] = "冷卻時間剩餘"
L["Copy"] = "複製"
L["Copy Default"] = "複製預設"
L["Copy selected zone settings to the current zone"] = "將選取區域的設定複製到當前區域"
L["Copy Settings From:"] = "複製設定，來自:"
L["Copy Zone Segments"] = "複製區域部分內容"
L["Counter CC"] = "計數冷卻"
L["Counter Color"] = "計數顏色"
L["Counter Size"] = "數字大小"
L["Covenant"] = "誓盟"
L["Create Bar"] = "建立技能列"
L["Credits"] = "製作群"
L["Crop"] = "剪裁"
L["Crop Icons 1.5:1."] = "剪裁圖示 1.5:1。"
L["Crowd Control"] = "控場"
L["Current Profile"] = "目前設定檔"
L["Current Unit Frame Addon"] = "目前使用的單位框架插件"
L["Custom Priority"] = "自訂排序"
L["Custom Spells"] = "自訂法術"
L["Custom UI"] = "自訂介面"
L["Decode"] = "解碼"
L["Decode failed!"] = "解碼失敗!"
L["Decompress failed!"] = "解壓縮失敗!"
L["Default spells are reverted back to original values and removed from the list only"] = "預設法術只會恢復成原始值並且從清單中移除"
L["Defensive"] = "防禦"
L["Desaturate Colors"] = "去色"
L["Desaturate colors on active icons"] = "冷卻中的圖示去色"
L["Descending"] = "降冪"
L["Deserialize failed!"] = "反序列化失敗!"
L["Destination Profile"] = "目地設定檔"
L["Detach CD-Group"] = "分離冷卻群組"
L["Detach from raid frames and set position manually"] = "與團隊框架分離改由手動設定位置"
L["Disable Popup"] = "不需要確認"
L["Disable Reload UI confirmation when using Pixel Perfect borders"] = "使用像素完美邊框時，無須確認立即重新載入介面。"
L["Disable to make the icons click through"] = "停用來讓滑鼠點擊可以穿透圖示"
L["Display a glow animation around an icon when it is activated"] = "技能被使用時在圖示周圍顯示發光動畫效果"
L["Display custom border around icons"] = "圖示周圍顯示自訂邊框"
L["Display default border around icons"] = "圖示周圍顯示預設邊框"
L["Display icons not on cooldown"] = "不在冷卻中時也要顯示圖示"
L["Display Inactive"] = "非冷卻時顯示"
L["Display Inactive Icons"] = "顯示非冷卻中圖示"
L["Don't show again"] = "不再顯示"
L["Enable CD tracking in the current zone"] = "啟用當前區域的冷卻追蹤。"
L["Enable if the spell is a base ability for this specialization"] = "法術是此專精的基本能力時啟用。"
L["Enable in automated instance groups"] = "在自動組成的隨機隊伍中啟用"
L["Enable initial spark and marching-ants animation"] = "啟用開頭的亮點和螞蟻路徑動畫"
L["Enable spell for this specialization"] = "啟用這個專精的法術"
L["Enable to customize the 2nd row icons when using 'Double Row' layout."] = "使用 \"兩排\" 版面配置時，啟用此選項來自訂第二排圖示。"
L["Enter buff ID if it differs from spell ID for Highlights to work"] = "請輸入增益效果 ID，如果它和法術 ID 不同的話，以便讓顯著標示能夠運作"
L["Enter item ID to enable spell when the item is equipped only"] = "輸入物品 ID 來啟用法術 (只在已裝備該物品時)"
L["Enter Spell ID to Add/Edit"] = "輸入法術 ID 來新增 / 編輯"
L["Enter talent ID if the spell is a talent ability in any of the class specializations. This ensures proper spell detection."] = "法術是任何職業專精的天賦能力時，請輸入天賦 ID，以確保能夠正確的偵測。"
L["Enter value to set a custom spell priority. This value is applied to all zones."] = "輸入數值來設定自訂的法術排列順序，此設定會套用到所有區域。"
L["Export"] = "匯出"
L["Export Profile"] = "匯出設定檔"
L["Exports your currently active profile."] = "匯出目前使用的設定檔。"
L["External Defensive"] = "外部防禦"
L["Extra Bars"] = "額外技能列"
L["Fade In Time"] = "淡入時間"
L["Fade Out Time"] = "淡出時間"
L["Feedback"] = "問題與建議"
L["Font"] = "文字"
L["Font Outline"] = "文字外框"
L["Fonts"] = "字體"
L["Glow Icons"] = "圖示發光"
L["Group Padding"] = "隊伍間距"
L["Group Size"] = "隊伍大小"
L["Group Type"] = "隊伍類型"
L["Grow Columns Left"] = "行往左延伸"
L["Grow Rows Upward"] = "橫排向上延伸"
L["Having \"BOTTOM\" in the anchor point, icons grow upward, otherwise downward"] = "對齊下方，圖示往上延伸，否則往下。"
L["Having \"RIGHT\" in the anchor point, icons grow left, otherwise right"] = "對齊右側，圖示往左延伸，否則往右。"
L["Help Translate"] = "請幫忙翻譯"
L["Hide Border"] = "隱藏外框"
L["Hide Disabled Spells"] = "隱藏已停用的法術"
L["Hide Spark"] = "隱藏亮點"
L["Hide spells that are not enabled in the 'Spells' menu."] = "隱藏在 '法術' 選單中沒有啟用的法術"
L["Hide status bar border"] = "隱藏狀態列外框"
L["Hide the leading spark texture."] = "隱藏開頭的亮光材質。"
L["Highlight"] = "顯著標示"
L["Highlight Icons"] = "顯著標示圖示"
L["Highlight the icon when a buffing spell is used until the buff falls off"] = "開始使用有增強效果的法術，直到效果結束的期間，要顯著標示圖示"
L["Hold Time"] = "停留時間"
L["Horizontal"] = "水平"
L["Horizontal + CD Groups"] = "水平 + 冷卻群組"
L["Hotfix"] = "Hotfix"
L["Icon"] = "圖示"
L["Icon Alignment"] = "圖示對齊方式"
L["Icon Opacity"] = "圖示不透明度"
L["Icon Position"] = "圖示位置"
L["Icon Scale Changed."] = "圖示縮放大小已變更。"
L["Icon Size"] = "圖示大小"
L["Icon size auto adjusts as a percentage of the anchored frame height"] = "依據所對齊框架的高度百分比自動調整圖示大小"
L["Icons"] = "圖示"
L["Immunity"] = "免疫"
L["Import"] = "匯入"
L["Import Profile"] = "匯入設定檔"
L["Importing `%s` will create a new profile."] = "匯入 '%s' 將會建立新的設定檔。"
L["Importing `%s` will merge new spells to your list and overwrite same spells."] = "匯入 '%s' 會將新的法術合併到清單中，取代相同的法術。"
L["Importing Custom Spells will reload UI. Press Cancel to abort."] = "匯入自訂法術將會重新載入介面，要放棄請按取消。"
L["Inactive"] = "未啟動"
L["Inactive Icon Opacity"] = "非冷卻中圖示不透明度"
L["INNER"] = "內部"
L["Interrupt Bar"] = "斷法技能列"
L["Interrupts"] = "斷法"
L["Invalid ID"] = "無效的 ID"
L["Invalid Profile"] = "無效的設定檔"
L["Item ID (Optional)"] = "物品 ID (選擇性)"
L["Jump to Extra Bars settings"] = "跳至額外技能列設定"
L["Layout"] = "版面配置"
L["LEFT"] = "左"
L["License"] = "授權"
L["Lock frame position"] = "鎖定框架位置"
L["Login Message"] = "登入訊息"
L["Major update"] = "重大更新"
L["Manual Mode"] = "手動調整模式"
L["Manual Position"] = "手動調整位置"
L["Mark Enhanced Spells"] = "標記強化法術"
L["Mark icons with a red dot to indicate enhanced spells"] = "使用紅點標記圖示來表示強化法術"
L["Max number of group members"] = "最多隊伍成員數"
L["Minor update"] = "次要更新"
L["MM Color"] = "MM 顏色"
L["MM:SS Color"] = "MM:SS 顏色"
L["MM:SS Threshold"] = "MM:SS 分界值"
L["Move your group's Interrupt spells to the Interrupt Bar."] = "將隊伍的斷法技能移至斷法技能列。"
L["Move your group's Raid Cooldowns to the Raid Bar."] = "將隊伍的團隊冷卻移至團隊技能列。"
L["Multiselect"] = "多選"
L["Name Bar"] = "名字列"
L["Name Offset X"] = "名字水平位置"
L["Name Offset Y"] = "名字垂直位置"
L["New Column per Group"] = "每個隊伍一行"
L["None of the CD counter skins support modrate. Timers will fluctuate erratically whenever CD recovery rate is modulated."] = "冷卻計時外觀不支援平滑移動。每當冷卻恢復速率調整時，計時條不會穩定的移動。"
L["Not an OmniCD profile!"] = "不是隊友技能冷卻監控 OmniCD 的設定檔!"
L["Notes"] = "說明"
L["Notify Updates"] = "有新版本時通知我"
L["Offensive"] = "攻擊"
L["Offset X"] = "水平位置"
L["Offset Y"] = "垂直位置"
L["Padding"] = "間距"
L["Padding X"] = "水平間距"
L["Padding Y"] = "垂直間距"
L["Pending user input..."] = "正在等待使用者輸入..."
L["Pixel Perfect"] = "像素完美模式"
L["Pixel Perfect ON."] = "像素完美模式已開啟。"
L["Player Frame in Party"] = "隊伍中的玩家框架"
L["Position"] = "位置"
L["Press Accept to save profile %s. Addon will switch to the imported profile."] = "按下接受來儲存設定檔 %s，插件會自動切換為已匯入的設定檔。"
L["Press Ctrl+C to copy profile"] = "按 Ctrl+C 複製設定檔"
L["Press Ctrl+C to copy URL"] = "按 Ctrl+C 複製網址"
L["Press Ctrl+V to paste profile"] = "按 Ctrl+V 貼上設定檔"
L["Priority"] = "排序"
L["Profile"] = "設定檔"
L["Profile decoded successfully!"] = "設定檔解碼成功!"
L["Profile import cancelled!"] = "已取消匯入設定檔!"
L["Profile imported successfully!"] = "設定檔匯入成功!"
L["Profile is empty!"] = "設定檔是空的!"
L["Profile Sharing"] = "設定檔分享"
L["Profile Type"] = "設定檔類型"
L["Profile Type: %s%s|r"] = "設定檔類型: %s%s|r"
L["Profile unchanged from default!"] = "設定檔和預設值相同!"
L["Quick Select"] = "快速選擇"
L["Racial Traits"] = "種族特長"
L["Raid Bar"] = "團隊技能列"
L["Raid CD"] = "團隊冷卻"
L["Raid Defensive"] = "團隊防禦"
L["Raid Frames for testing doesn't exist for %s. If it fails to load, configure OmniCD while in a group or temporarily set it to 'Manual Mode'."] = "%s 隊伍/團隊框架無法使用測試功能，請加入隊伍後再調整設定，或是先暫時設為 '手動調整模式'。"
L["Raid Movement"] = "團隊位移"
L["Recharge"] = "充能"
L["Reload addon."] = "重新載入插件。"
L["Reload UI?"] = "是否要重新載入介面?"
L["Replace default timers with a status bar timer."] = "使用狀態列計時器取代預設計時器。"
L["Reset all cooldown timers."] = "重置所有冷卻計時器。"
L["Reset current zone settings to default"] = "重置當前區域的設定，恢復成預設值。"
L["Reset frame position"] = "重置框架位置"
L["Reset Status Bar Timer settings to default"] = "重置狀態列計時器的設定，恢復成預設值。"
L["Reverse Fill"] = "反向充填"
L["Reverse Swipe"] = "反向轉圈動畫"
L["Reverse the cooldown swipe animation"] = "反向顯示冷卻轉圈動畫效果"
L["RIGHT"] = "右"
L["Row"] = "排數"
L["Row Breakpoint"] = "換到下一排"
L["Same category units are sorted alphabetically in ascending order"] = "相同類別的單位會按照字母順序升冪排序"
L["Select a spell type to enable all spells in that category for all classes"] = "選擇法術類型來為全部職業啟用該類別中的所有法術"
L["Select addon to override auto anchoring"] = "選擇要對齊到的插件"
L["Select how the player frame is displayed inside the party frame"] = "選擇玩家框架要如何顯示在隊伍框架內"
L["Select the column(s) that you want the rows to grow upwards."] = "選擇橫列要延伸增加幾行。"
L["Select the column(s) that you want to detach and position manually."] = "選擇要分離並且手動調整位置的行。"
L["Select the group size for which you want to set the spell bar position"] = "選擇要設定技能列位置的隊伍大小"
L["Select the highest priority spell type to use as the start of the 2nd row"] = "選擇第二排開頭、優先順序最高的法術類型"
L["Select the highest priority spell type to use as the start of the 3rd row"] = "選擇第三排開頭、優先順序最高的法術類型"
L["Select the icon layout"] = "選擇圖示版面配置"
L["Select the spell types you want to display on this column."] = "選擇要在此行中顯示的法術類型。"
L["Select the zone setting to use for this zone."] = "選擇此區域要使用的區域設定。"
L["Select the zone you want to copy settings from."] = "選擇要複製哪個區域的設定。"
L["Select your default party frame layout"] = "選擇預設的隊伍框架版面配置"
L["Send a chat message when a newer version is found."] = "有新版本時，在聊天視窗顯示訊息。"
L["Serialize failed!"] = "序列化失敗!"
L["Set the anchor attachement point. Icon grow direction will auto adjust"] = "設定對齊到的點，圖示延伸方向會自動調整。"
L["Set the anchor attachment point on the party/raid frame"] = "設定隊伍/團隊框架的附加對齊點"
L["Set the anchor point on the spell bar"] = "設定技能列的對齊點"
L["Set the number of icons per column"] = "設定每個直行的圖示數量"
L["Set the number of icons per row"] = "設定每排的圖示數量"
L["Set the opacity of icons"] = "設定圖示的不明度"
L["Set the opacity of icons not on cooldown"] = "設定不在冷卻中圖示的不透明度"
L["Set the opacity of icons on cooldown"] = "設定冷卻中的圖示不明度"
L["Set the opacity of swipe animations"] = "設定轉圈動畫的不透明度"
L["Set the padding space between CD-groups"] = "設定冷卻群組之間的距離"
L["Set the padding space between group columns"] = "設定隊伍直行間距"
L["Set the padding space between icon columns"] = "設定圖示直行之間的距離"
L["Set the padding space between icon rows"] = "設定圖示橫排之間的距離"
L["Set the padding space between icons"] = "設定圖示之間的距離"
L["Set the prioirty of spell types for sorting."] = "設定法術類型的優先權，供排序使用。"
L["Set the size of charge numbers"] = "設定次數的文字大小"
L["Set the size of cooldown numbers"] = "設定冷卻數字的大小"
L["Set the size of icons"] = "設定圖示大小"
L["Set the spell bar position"] = "設定技能列位置"
L["Set the spell type for sorting"] = "設定法術類型來排序"
L["Set the status bar width. Adjust height with 'Icon Size'."] = "設定狀態列寬度， 要設定高度請調整 '圖示大小'。"
L["Set to override the global cooldown setting for this specialization"] = "設定這個專精專用，取代整體冷卻設定"
L["Settings"] = "設定"
L["Show Anchor"] = "顯示對齊位置"
L["Show anchor with party/raid numbers"] = "顯示對齊點和隊伍編號"
L["Show Forbearance CD"] = "顯示自律冷卻"
L["Show name on icons"] = "在圖示上面顯示名稱"
L["Show Player"] = "顯示自己"
L["Show Player in Extra Bars"] = "在額外技能列中顯示自己"
L["Show player spells in the Extra Bars regardless of 'Show Player' setting."] = "在額外技能列中顯示自己的法術，無視 '顯示自己' 的設定。"
L["Show player's spell bar"] = "顯示玩家自己的技能監控列"
L["Show pvp trinket only while in Battlegrounds"] = "只有在戰場中才會顯示 PvP 飾品"
L["Show Spell ID in Tooltips"] = "在滑鼠提示中顯示法術 ID"
L["Show spell information when you mouseover an icon"] = "滑鼠指向圖示時顯示法術資訊"
L["Show timer on spells while under the effect of Forbearance or Hypothermia. Spells castable to others will darken instead"] = "顯示在自律或體溫過低效果影響下的法術時間，可對他人施放的法術會變暗。"
L["Show Tooltip"] = "顯示滑鼠提示"
L["Show Trinket Only"] = "只顯示飾品"
L["Slash Commands"] = "聊天指令"
L["Sort Direction"] = "排序方向"
L["Sort Order"] = "排列順序"
L["Source Profile"] = "來源設定檔"
L["Spacing"] = "間距"
L["Spell Editor"] = "法術編輯器"
L["Spell ID"] = "法術 ID"
L["Spell Types"] = "法術類型"
L["Spells"] = "法術"
L["Status Bar"] = "狀態列"
L["Status Bar Timer"] = "狀態列計時器"
L["Strong Yellow Glow"] = "鮮黃色發光"
L["Supported UI"] = "支援的插件"
L["Swipe Opacity"] = "轉圈不透明度"
L["Synchronize"] = "同步"
L["Talent Ability"] = "天賦技能"
L["Talent ID"] = "天賦 ID"
L["Test"] = "測試"
L["Test frames will be hidden once player is out of combat"] = "測試框架會在脫離戰鬥後隱藏"
L["Test Mode Disabled: Non-Blizzard party frames"] = "測試模式已停用：只有使用遊戲內建的隊伍框架時才能測試"
L["Text Alignment"] = "文字對齊方式"
L["Threshold at which the timer transitions from MM to MM:SS format."] = "時間格式由 MM 變成 MM:SS 的分界值。"
L["Timer will progress from right to left"] = "計時器會從右往左前進"
L["Timers"] = "計時條"
L["Toggle \"Show Spell ID in Tooltips\" to retrieve item IDs"] = "啟用 [在滑鼠提示中顯示法術 ID] 來取得物品 ID"
L["Toggle module on and off"] = "切換開關模組"
L["Toggle raid-style party frame and player spell bar for testing"] = "切換顯示團隊風格的隊伍框架和玩家自己的技能監控列來測試"
L["Toggle test frames for current zone."] = "切換顯示當前區域的測試框架。"
L["Toggle the cooldown numbers. Spells with charges only show cooldown numbers at 0 charge"] = "切換開關冷卻數字。有使用次數的法術只有在次數為 0 時才會顯示冷卻數字。"
L["Toggle the grow direction of icon columns"] = "切換圖示直行的延伸方向"
L["Toggle the grow direction of icon rows"] = "切換圖示橫排的延伸方向"
L["Tool to copy portions of a profile to another existing profile."] = "將設定檔的部分內容複製到另一個現有設定檔的工具。"
L["TOP"] = "上"
L["TOPLEFT"] = "左上"
L["TOPRIGHT"] = "右上"
L["Trinket and Racial abilities are excluded from sorting"] = "飾品和種族特長不包含在排序之內"
L["Trinket Items"] = "飾品"
L["UI Scale Changed."] = "使用者介面縮放大小已變更。"
L["Unit CD bars are limited to 5 man groups unless Blizzard Raid Frames are used."] = "單位冷卻條只能用於 5 人隊伍，除非是使用遊戲內建的團隊框架。"
L["Usage:"] = "用法:"
L["Use a semi-colon(;) to seperate multiple IDs."] = "使用分號分隔多個 ID。"
L["Use Default"] = "使用預設值"
L["Use Double Column"] = "使用兩行"
L["Use Double Row"] = "使用兩排"
L["Use Icon Alpha"] = "使用圖示透明度"
L["Use Relative Size"] = "使用相對大小"
L["Use this setting for all group sizes"] = "所有大小的隊伍都使用這個設定"
L["Use Triple Column"] = "使用三行"
L["Use Triple Row"] = "使用三排"
L["Use Zone Settings From:"] = "使用區域設定，來自:"
L["Utils"] = "工具"
L["Value 'Manual Position' includes Interrupt and Raid Bar's saved positions."] = "'手動調整位置' 包含斷法和團隊技能列的保存位置。"
L["Version"] = "版本"
L["Vertical"] = "垂直"
L["Vertical + CD Groups"] = "垂直 + 冷卻群組"
L["Vertical Groups"] = "垂直隊伍"
L["Visibility"] = "顯示"
L["Weak Purple Glow"] = "淡紫色發光"
