local L = TrinketMenuLocale
if(not L) then return end --TODO: 版本不对
-- luyi7338 汉化
-- Sharak@BigFoot 增加繁体版数据

if (GetLocale() == "zhCN") then
    L["No profiles saved yet."] = "尚未保存任何方案"
    L["Priority"] = "优先"
    L["Pause Queue"] = "中断"
    L["TrinketMenu"] = "饰品管理"
    
	TrinketMenu.CheckOptInfo = {
		{"ShowIcon","ON","迷你地图按钮","显示或隐藏小地图按钮."},
		{"SquareMinimap","OFF","方形迷你地图","如果迷你地图是方形移动迷你地图按钮.","ShowIcon"},
		{"CooldownCount","OFF","冷却计时","在按钮上显示剩余冷却时间."},
		{"TooltipFollow","OFF","跟随鼠标","提示信息跟随鼠标.","ShowTooltips"},
		{"KeepOpen","OFF","保持列表开启","保持饰物列表始终开启."},
		{"KeepDocked","ON","保持列表粘附","保持饰物列表粘附在当前装备列表."},
		{"Notify","OFF","可使用提示","饰物冷却后提示玩家."},
		{"DisableToggle","OFF","禁止开关","止使用点击小地图按钮来控制列表的显示/隐藏.","ShowIcon"},
		{"NotifyChatAlso","OFF","在聊天窗口提示","在饰物冷却结束后在聊天窗口也发出提示信息."},
		{"Locked","OFF","锁定窗口","不能移动,缩放,转动饰品列表."},
		{"ShowTooltips","ON","显示提示信息","显示提示信息."},
		{"NotifyThirty","ON","三十秒提示","在饰品冷却前三十秒时提示玩家."},
		{"MenuOnShift","OFF","Shift显示列表","只有按下Shift才会显示饰品选择列表."},
		{"TinyTooltips","OFF","迷你提示","简化饰品的提示信息变为只有名字, 用途, 冷却.","ShowTooltips"},
		{"SetColumns","OFF","设置列表列数","设置饰品选择列表的列数.\n\n不选择此项 TrinketMenu 会自动排列."},
		{"LargeCooldown","ON","大字体","用更大的字体显示冷却时间.","CooldownCount"},
		{"ShowHotKeys","ON","显示快捷键","在饰品上显示绑定的快捷键."},
		{"StopOnSwap","OFF","被动饰品停止排队","当换上一个被动饰品时停止自动排队.  选中这个选项时, 当一个可点击饰品通过 TrinketMenu 被手动换上时同样会停止自动排队. 当频繁标记饰品为优先时这个选项尤其有用"},
		{"HideOnLoad","OFF","当配置载入时关闭","当你载入一个配置时关闭这个窗口."},
		{"RedRange","OFF","射程警告","当有效目标在饰品的射程外时饰品变红警告.  例如, 侏儒死亡射线和侏儒捕网器."},
		{"MenuOnRight","OFF","右击菜单","防止菜单出现除非一个警告饰品被右击.\n\n提示: 战斗中不能改变这个选项."}
	}

	TrinketMenu.TooltipInfo = {
		{"TrinketMenu_LockButton","锁定窗口","不能移动,缩放,转动饰品列表."},
		{"TrinketMenu_Trinket0Check","上面饰品栏自动排队","选中这个选项会让饰品自动排队替换到上面的饰品栏.  你也可以Alt+点击饰品来开关自动排队."},
		{"TrinketMenu_Trinket1Check","下面饰品栏自动排队","选中这个选项会让饰品自动排队替换到下面的饰品栏.  你也可以Alt+点击饰品来开关自动排队."},
		{"TrinketMenu_SortPriority","高优先权","当选中这个选项时, 这个饰品会被第一时间装备上, 而不管装备着的饰品是否在冷却中.\n\n当没选中时, 这个饰品不会替换掉没有在冷却中的已装备饰品."},
		{"TrinketMenu_SortDelay","延迟替换","设置一个饰品被替换的时间 (秒).  比如, 你需要20秒得到大地之击的20秒BUFF."},
		{"TrinketMenu_SortKeepEquipped","暂停自动排队","选中这个选项,当这个饰品被装备时会暂停自动排队替换. 比如, 你有一个自动换装的插件在你骑马时把棍子上的胡萝卜装备上了."},
		{"TrinketMenu_Profiles","配置文件","你可以载入或保存一个队列配置."},
		{"TrinketMenu_Delete","删除","从列表中删这个饰品.  更下面的饰品完全不会影响.  这个选项仅仅用来保持列表的可控性. 提示: 你包包里的饰品将回到列表的最下面."},
		{"TrinketMenu_ProfilesDelete","删除配置","移除这个配置Remove this profile."},
		{"TrinketMenu_ProfilesLoad","载入配置","为选中饰品槽载入一个队列.  你也可以双击一个配置来载入它."},
		{"TrinketMenu_ProfilesSave","保存配置","保存选中饰品槽的队列.  任一饰品槽都可以使用它."},
		{"TrinketMenu_ProfileName","配置名","为这个配置输入一个名字.  保存后, 你可以载入给任一饰品槽."},
		{"TrinketMenu_OptBindButton","绑定饰品","单击这里为你的上/下面饰品绑定一个热键."}
	}

	TrinketMenu.Tooltip1 = "点击: 开关选项窗口\n拖动: 移动设置按钮";
	TrinketMenu.Tooltip2 = "左键点击: 开关饰物窗口\n右键点击: 开关选项窗口\n拖动: 移动设置按钮";
	StopQueueHereText1 = "-- 停止排队线 --";
	StopQueueHereText2 = "停止排队线";
	StopQueueHereTooltip = "移动这个来标记让下面的饰品不自动排队.  当你想让一个被动饰品只允许手动换上时, 就把它移动到这条线的下面.";

	TrinketMenu_Tab1:SetText("选项");
	TrinketMenu_Tab2:SetText("下面      ");
	TrinketMenu_Tab3:SetText("上面      ");

	TrinketMenu_SortDelayText1:SetText("延迟");
	TrinketMenu_SortDelayText2:SetText("秒");
	TrinketMenu_ProfileNameText:SetText("配置");
	TrinketMenu_ProfilesDelete:SetText("删除");
	TrinketMenu_ProfilesLoad:SetText("载入");
	TrinketMenu_ProfilesSave:SetText("保存");
	TrinketMenu_ProfilesCancel:SetText("取消");
	--TrinketMenu_OptBindButton:SetText("热键绑定");

	TrinketMenu.Message1 = "|cFFFFFF00TrinketMenu 缩放:";
	TrinketMenu.Message2 = "/trinket scale main (number) : 设置主列表缩放比";
	TrinketMenu.Message3 = "/trinket scale menu (number) : 设置选择列表缩放比";
	TrinketMenu.Message4 = "比如: /trinket scale menu 0.85";
	TrinketMenu.Message5 = "提示: 你可以拖动右下角调整缩放比.";
	TrinketMenu.Message6= "|cFFFFFF00TrinketMenu 帮助:";
	TrinketMenu.Message7 = "/trinket or /trinketmenu : 开关列表";
	TrinketMenu.Message8 = "/trinket reset : 重置所有设置";
	TrinketMenu.Message9 = "/trinket opt : 打开设置窗口";
	TrinketMenu.Message10 = "/trinket lock|unlock : 锁定/解锁窗口";
	TrinketMenu.Message11 = "/trinket scale main|menu (number) : 缩放主/列表";
	TrinketMenu.Message12 = "|cFFFFFF00TrinketMenu 载入:";
	TrinketMenu.Message13 = "/trinket load (top|bottom) profilename\nie: /trinket load bottom PvP";
	TrinketMenu.Message14 = "/trinket load top|bottom profilename : 为上/下饰品载入一个配置文件";

	BINDING_NAME_TOGGLE_TRINKETMENU = "打开/关闭饰品管理";
	BINDING_HEADER_TRINKETMENU = "饰品管理";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket0:LeftButton'] = "使用1号饰品";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket1:LeftButton'] = "使用2号饰品";
elseif (GetLocale() == "zhTW") then
	TrinketMenu.CheckOptInfo = {
		{"ShowIcon","ON","迷你地圖按鈕","顯示或隱藏小地圖按鈕."},
		{"SquareMinimap","OFF","方形迷你地圖","如果迷你地圖是方形移動迷你地圖按鈕.","ShowIcon"},
		{"CooldownCount","OFF","冷卻計時","在按鈕上顯示剩餘冷卻時間."},
		{"TooltipFollow","OFF","跟隨滑鼠","提示資訊跟隨滑鼠.","ShowTooltips"},
		{"KeepOpen","OFF","保持列表開啟","保持飾物列表始終開啟."},
		{"KeepDocked","ON","保持列表粘附","保持飾物列表粘附在當前裝備列表."},
		{"Notify","OFF","可使用提示","飾物冷卻後提示玩家."},
		{"DisableToggle","OFF","禁止開關","止使用點擊小地圖按鈕來控制列表的顯示/隱藏.","ShowIcon"},
		{"NotifyChatAlso","OFF","在聊天窗口提示","在飾物冷卻結束後在聊天視窗也發出提示資訊."},
		{"Locked","OFF","鎖定視窗","不能移動,縮放,轉動飾品列表."},
		{"ShowTooltips","ON","顯示提示資訊","顯示提示資訊."},
		{"NotifyThirty","ON","三十秒提示","在飾品冷卻前三十秒時提示玩家."},
		{"MenuOnShift","OFF","Shift顯示列表","只有按下Shift才會顯示飾品選擇列表."},
		{"TinyTooltips","OFF","迷你提示","簡化飾品的提示資訊變為只有名字, 用途, 冷卻.","ShowTooltips"},
		{"SetColumns","OFF","設置列表列數","設置飾品選擇列表的列數.\n\n不選擇此項 TrinketMenu 會自動排列."},
		{"LargeCooldown","ON","大字體","用更大的字體顯示冷卻時間.","CooldownCount"},
		{"ShowHotKeys","ON","顯示快捷鍵","在飾品上顯示綁定的快捷鍵."},
		{"StopOnSwap","OFF","被動飾品停止排隊","當換上一個被動飾品時停止自動排隊.  選中這個選項時, 當一個可點擊飾品通過 TrinketMenu 被手動換上時同樣會停止自動排隊. 當頻繁標記飾品為優先時這個選項尤其有用"},
		{"HideOnLoad","OFF","當配置載入時關閉","當你載入一個配置時關閉這個視窗."},
		{"RedRange","OFF","射程警告","當有效目標在飾品的射程外時飾品變紅警告.  例如, 侏儒死亡射線和侏儒捕網器."},
		{"MenuOnRight","OFF","右擊功能表","防止功能表出現除非一個警告飾品被右擊.\n\n提示: 戰鬥中不能改變這個選項."}
	}

	TrinketMenu.TooltipInfo = {
		{"TrinketMenu_LockButton","鎖定視窗","不能移動,縮放,轉動飾品列表."},
		{"TrinketMenu_Trinket0Check","上面飾品欄自動排隊","選中這個選項會讓飾品自動排隊替換到上面的飾品欄.  你也可以Alt+點擊飾品來開關自動排隊."},
		{"TrinketMenu_Trinket1Check","下面飾品欄自動排隊","選中這個選項會讓飾品自動排隊替換到下面的飾品欄.  你也可以Alt+點擊飾品來開關自動排隊."},
		{"TrinketMenu_SortPriority","高優先權","當選中這個選項時, 這個飾品會被第一時間裝備上, 而不管裝備著的飾品是否在冷卻中.\n\n當沒選中時, 這個飾品不會替換掉沒有在冷卻中的已裝備飾品."},
		{"TrinketMenu_SortDelay","延遲替換","設置一個飾品被替換的時間 (秒).  比如, 你需要20秒得到大地之擊的20秒BUFF."},
		{"TrinketMenu_SortKeepEquipped","暫停自動排隊","選中這個選項,當這個飾品被裝備時會暫停自動排隊替換. 比如, 你有一個自動換裝的插件在你騎馬時把棍子上的胡蘿蔔裝備上了."},
		{"TrinketMenu_Profiles","配置檔","你可以載入或保存一個佇列配置."},
		{"TrinketMenu_Delete","刪除","從列表中刪這個飾品.  更下面的飾品完全不會影響.  這個選項僅僅用來保持列表的可控性. 提示: 你包包裏的飾品將回到列表的最下麵."},
		{"TrinketMenu_ProfilesDelete","刪除配置","移除這個配置Remove this profile."},
		{"TrinketMenu_ProfilesLoad","載入配置","為選中飾品槽載入一個佇列.  你也可以雙擊一個配置來載入它."},
		{"TrinketMenu_ProfilesSave","保存配置","保存選中飾品槽的佇列.  任一飾品槽都可以使用它."},
		{"TrinketMenu_ProfileName","配置名","為這個配置輸入一個名字.  保存後, 你可以載入給任一飾品槽."},
		{"TrinketMenu_OptBindButton","綁定飾品","單擊這裏為你的上/下面飾品綁定一個熱鍵."}
	}

	TrinketMenu.Tooltip1 = "點擊: 開關選項視窗\n拖動: 移動設置按鈕";
	TrinketMenu.Tooltip2 = "左鍵點擊: 開關飾物視窗\n右鍵點擊: 開關選項視窗\n拖動: 移動設置按鈕";
	StopQueueHereText1 = "-- 停止排隊線 --";
	StopQueueHereText2 = "停止排隊線";
	StopQueueHereTooltip = "移動這個來標記讓下面的飾品不自動排隊.  當你想讓一個被動飾品只允許手動換上時, 就把它移動到這條線的下麵.";

	TrinketMenu_Tab1:SetText("選項");
	TrinketMenu_Tab2:SetText("下麵      ");
	TrinketMenu_Tab3:SetText("上面      ");

	TrinketMenu_SortDelayText1:SetText("延遲");
	TrinketMenu_SortDelayText2:SetText("秒");
	TrinketMenu_ProfileNameText:SetText("配置");
	TrinketMenu_ProfilesDelete:SetText("刪除");
	TrinketMenu_ProfilesLoad:SetText("載入");
	TrinketMenu_ProfilesSave:SetText("保存");
	TrinketMenu_ProfilesCancel:SetText("取消");
	--TrinketMenu_OptBindButton:SetText("熱鍵綁定");

	TrinketMenu.Message1 = "|cFFFFFF00TrinketMenu 縮放:";
	TrinketMenu.Message2 = "/trinket scale main (number) : 設置主列表縮放比";
	TrinketMenu.Message3 = "/trinket scale menu (number) : 設置選擇列表縮放比";
	TrinketMenu.Message4 = "比如: /trinket scale menu 0.85";
	TrinketMenu.Message5 = "提示: 你可以拖動右下角調整縮放比.";
	TrinketMenu.Message6= "|cFFFFFF00TrinketMenu 説明:";
	TrinketMenu.Message7 = "/trinket or /trinketmenu : 開關列表";
	TrinketMenu.Message8 = "/trinket reset : 重置所有設置";
	TrinketMenu.Message9 = "/trinket opt : 打開設置視窗";
	TrinketMenu.Message10 = "/trinket lock|unlock : 鎖定/解鎖窗口";
	TrinketMenu.Message11 = "/trinket scale main|menu (number) : 縮放主/列表";
	TrinketMenu.Message12 = "|cFFFFFF00TrinketMenu 載入:";
	TrinketMenu.Message13 = "/trinket load (top|bottom) profilename\nie: /trinket load bottom PvP";
	TrinketMenu.Message14 = "/trinket load top|bottom profilename : 為上/下飾品載入一個配置檔";

	BINDING_NAME_TOGGLE_TRINKETMENU = "打開/關閉飾品管理";
	BINDING_HEADER_TRINKETMENU = "飾品管理";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket0:LeftButton'] = "使用1號飾品";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket1:LeftButton'] = "使用2號飾品";
else
	TrinketMenu.Tooltip1 ="Click: toggle options\nDrag: move icon";
	TrinketMenu.Tooltip2 = "Left click: toggle trinkets\nRight click: toggle options\nDrag: move icon";
	StopQueueHereText1 = "-- stop queue here --";
	StopQueueHereText2 = "Stop Queue Here";
	StopQueueHereTooltip = "Move this to mark the lowest trinket to auto queue.  Sometimes you may want a passive trinket with a click effect to be the end (Burst of Knowledge, Second Wind, etc).";

	TrinketMenu.Message1 = "|cFFFFFF00TrinketMenu scale:";
	TrinketMenu.Message2 = "/trinket scale main (number) : set exact main scale";
	TrinketMenu.Message3 = "/trinket scale menu (number) : set exact menu scale";
	TrinketMenu.Message4 = "ie, /trinket scale menu 0.85";
	TrinketMenu.Message5 = "Note: You can drag the lower-right corner of either window to scale.  This slash command is for those who want to set an exact scale.";
	TrinketMenu.Message6= "|cFFFFFF00TrinketMenu useage:";
	TrinketMenu.Message7 = "/trinket or /trinketmenu : toggle the window";
	TrinketMenu.Message8 = "/trinket reset : reset all settings";
	TrinketMenu.Message9 = "/trinket opt : summon options window";
	TrinketMenu.Message10 = "/trinket lock|unlock : toggles window lock";
	TrinketMenu.Message11 = "/trinket scale main|menu (number) : sets an exact scale";
	TrinketMenu.Message12 = "|cFFFFFF00TrinketMenu load:";
	TrinketMenu.Message13 = "/trinket load (top|bottom) profilename\nie: /trinket load bottom PvP";
	TrinketMenu.Message14 = "/trinket load top|bottom profilename : loads a profile to top or bottom trinket";

	BINDING_NAME_TOGGLE_TRINKETMENU = "Toggle TrinketMenu";
	BINDING_HEADER_TRINKETMENU = "TrinketMenu";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket0:LeftButton'] = "Use first trinket";
	_G['BINDING_NAME_CLICK TrinketMenu_Trinket1:LeftButton'] = "Use second trinket";
end
