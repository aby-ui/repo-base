-- Prevent tainting global _.
local _
local _G = _G

if GetLocale() == "zhTW" then 


EA_TTIP_DOALERTSOUND = "事件發生時是否播放音效.";
EA_TTIP_ALERTSOUNDSELECT = "選擇事件發生時所播放的音效.";
EA_TTIP_LOCKFRAME = "鎖定提示框架，避免被滑鼠拖拉移動.";
EA_TTIP_SHARESETTINGS = "所有職業共用相同的框架位置設定.";
EA_TTIP_SHOWFRAME = "顯示/關閉 事件發生時的提示框架.";
EA_TTIP_SHOWNAME = "顯示/關閉 事件發生時的法術名稱.";
EA_TTIP_SHOWFLASH = "顯示/關閉 事件發生時的全螢幕閃爍.";
EA_TTIP_SHOWTIMER = "顯示/關閉 事件發生時的法術剩餘時間.";
EA_TTIP_CHANGETIMER = "變更法術剩餘時間的字體大小、位置.";
EA_TTIP_ICONSIZE = "變更提示的圖示大小.";
-- EA_TTIP_ICONSPACE = "變更提示的圖示間距.";
-- EA_TTIP_ICONDROPDOWN = "變更提示的圖示延展方向.";
EA_TTIP_ALLOWESC = "變更是否可用ESC鍵關閉提示框架. (附註: 需重新載入UI)";
EA_TTIP_ALTALERTS = "開啟/關閉 EventAlertMod 提示額外事件(非增減益的觸發型技能).";

EA_TTIP_ICONXOFFSET = "調整提示框架的水平間距.";
EA_TTIP_ICONYOFFSET = "調整提示框架的垂直間距.";
EA_TTIP_ICONREDDEBUFF = "調整本身 Debuff 圖示的紅色深度.";
EA_TTIP_ICONGREENDEBUFF = "調整目標 Debuff 圖示的綠色深度.";
EA_TTIP_ICONEXECUTION = "調整首領血量百分比的斬殺期(0%代表關閉斬殺提示)";
EA_TTIP_PLAYERLV2BOSS = "比玩家等級高2級者(如5人副本首領)也套用首領級斬殺提示";
EA_TTIP_SCD_USECOOLDOWN = "技能冷卻使用倒數陰影(需重載UI才會生效)";
EA_TTIP_TAR_NEWLINE = "調整目標Debuff，是否另以單獨一行顯示";
EA_TTIP_TAR_ICONXOFFSET = "調整目標Debuff行與提醒框架水平間距";
EA_TTIP_TAR_ICONYOFFSET = "調整目標Debuff行與提醒框架垂直間距";
EA_TTIP_TARGET_MYDEBUFF = "調整目標Debuff行，是否僅顯示玩家所施放之Debuff";
EA_TTIP_SPELLCOND_STACK = "開啟/關閉, 當法術堆疊大於等於幾層時才顯示框架\n(可以輸入的最小值由2開始)";
EA_TTIP_SPELLCOND_SELF = "開啟/關閉, 只限制為玩家施放的法術, 避免監控到他人施放的相同法術";
EA_TTIP_SPELLCOND_OVERGROW = "開啟/關閉, 當法術堆疊大於等於幾層時以高亮顯示\n(可以輸入的最小值由1開始)";
EA_TTIP_SPELLCOND_REDSECTEXT = "開啟/關閉, 當倒數秒數小於等於幾秒時，以加大紅色字體顯示\n(可以輸入的最小值由1開始)";
EA_TTIP_SPELLCOND_ORDERWTD = "開啟/關閉, 設定顯示順序的優先比重，數字越大者，越優先顯示於最內圈(可輸入1至20)";

EA_TTIP_SPECFLAG_CHECK_HOLYPOWER = "開啟/關閉, 於本身BUFF框架左側第一格顯示聖能堆疊數";
EA_TTIP_SPECFLAG_CHECK_RUNICPOWER = "開啟/關閉, 於本身BUFF框架左側第一格顯示符文能量";
EA_TTIP_SPECFLAG_CHECK_RUNES = "開啟/關閉, 於本身BUFF框架上方顯示符文";
EA_TTIP_SPECFLAG_CHECK_SOULSHARDS = "開啟/關閉, 於本身BUFF框架左側第一格顯示靈魂碎片";
EA_TTIP_SPECFLAG_CHECK_LUNARPOWER = "開啟/關閉, 於本身BUFF框架左側第一格顯示星能";
EA_TTIP_SPECFLAG_CHECK_COMBOPOINT = "開啟/關閉, 於目標DEBUFF框架左側第一格顯示集星連擊數";
EA_TTIP_SPECFLAG_CHECK_LIFEBLOOM = "開啟/關閉, 於本身BUFF框架左側第一格顯示生命之花堆疊與時間";
EA_TTIP_SPECFLAG_CHECK_RAGE = "開啟/關閉, 於本身BUFF框架左側第一格顯示怒氣";				--  支援怒氣(戰士,熊D)
EA_TTIP_SPECFLAG_CHECK_FOCUS = "開啟/關閉, 於本身BUFF框架左側第一格顯示集中值";				--  支援集中值(獵人)
EA_TTIP_SPECFLAG_CHECK_ENERGY = "開啟/關閉, 於本身BUFF框架左側第一格顯示能量";				--  支援能量(賊,貓D,武僧)
EA_TTIP_SPECFLAG_CHECK_LIGHTFORCE = "開啟/關閉, 於本身BUFF框架左側第一格顯示真氣堆疊數";	--  支援武僧真氣
EA_TTIP_SPECFLAG_CHECK_INSANITY = "開啟/關閉, 於本身BUFF框架左側第一格顯示瘋狂";			--  支援暗影寶珠(暗牧)
EA_TTIP_SPECFLAG_CHECK_DEMONICFURY = "開啟/關閉於本身BUFF框架左側第一格顯示惡魔之怒";		--  支援惡魔之怒
EA_TTIP_SPECFLAG_CHECK_BURNINGEMBERS = "開啟/關閉於本身BUFF框架左側第一格顯示燃火餘燼";		--  支援燃火餘燼
EA_TTIP_SPECFLAG_CHECK_ARCANECHARGES = "開啟/關閉於本身BUFF框架左側第一格顯示秘法充能";		--  支援秘法充能
EA_TTIP_SPECFLAG_CHECK_MAELSTROM = "開啟/關閉於本身BUFF框架左側第一格顯示元能";				--  支援薩滿元能
EA_TTIP_SPECFLAG_CHECK_FURY = "開啟/關閉於本身BUFF框架左側第一格顯示魔怒";					--  支援惡魔獵人魔怒
EA_TTIP_SPECFLAG_CHECK_PAIN = "開啟/關閉於本身BUFF框架左側第一格顯示魔痛";					--  支援惡魔獵人魔痛
EA_TTIP_SPECFLAG_CHECK_FOCUS_PET = "開啟/關閉於本身BUFF框架左側第二格顯示寵物集中值";		--  支援獵人寵物集中

EA_TTIP_GRPCFG_ICONALPHA = "變更圖示的透明度";
EA_TTIP_GRPCFG_TALENT = "限定此專精時才作用";
EA_TTIP_GRPCFG_HIDEONLEAVECOMBAT = "離開戰鬥後,隱藏圖示";
EA_TTIP_GRPCFG_HIDEONLOSTTARGET = "沒有目標時,隱藏圖示";

EA_XOPT_ICONPOSOPT = "圖示位置&職業特殊能量";
EA_XOPT_SHOW_ALTFRAME = "顯示主提示框架";
EA_XOPT_SHOW_BUFFNAME = "顯示法術名稱";
EA_XOPT_SHOW_TIMER = "顯示倒數秒數";
EA_XOPT_SHOW_OMNICC = "秒數顯示於框架內";
EA_XOPT_SHOW_FULLFLASH = "顯示全螢幕閃爍提示";
EA_XOPT_PLAY_SOUNDALERT = "播放聲音提示";
EA_XOPT_ESC_CLOSEALERT = "ESC 關閉提示";
EA_XOPT_SHOW_ALTERALERT = "顯示額外提示";
EA_XOPT_SHOW_CHECKLISTALERT = "啟用";
EA_XOPT_SHOW_CLASSALERT = "本職業-增減益提示";
EA_XOPT_SHOW_OTHERALERT = "跨職業-增減益提示";
EA_XOPT_SHOW_TARGETALERT = "目標的-增減益提示";
EA_XOPT_SHOW_SCDALERT = "本職業-技能CD提示";
EA_XOPT_SHOW_GROUPALERT = "本職業-條件技能提示";
EA_XOPT_OKAY = "關閉";
EA_XOPT_SAVE = "儲存";
EA_XOPT_CANCEL = "取消";
EA_XOPT_VERURLTEXT = "EAM發布網址：";
EA_XOPT_VERBTN1 = "巴哈";
EA_XOPT_VERURL1 = "http://forum.gamer.com.tw/Co.php?bsn=05219&sn=5125122&subbsn=0";
EA_XOPT_SPELLCOND_STACK = "法術堆疊>=幾層時顯示框架:";
EA_XOPT_SPELLCOND_SELF = "只限制為玩家施放的法術";
EA_XOPT_SPELLCOND_OVERGROW = "法術堆疊>=幾層時顯示高亮:"
EA_XOPT_SPELLCOND_REDSECTEXT = "倒數秒數<=幾秒時顯示紅字:"
EA_XOPT_SPELLCOND_ORDERWTD   = "顯示順序的優先比重(1-20):"

EA_XICON_LOCKFRAME = "鎖定範例框架";
EA_XICON_LOCKFRAMETIP = "若要移動『提示框架』或『重設框架位置』時，請將『鎖定範例框架』的打勾取消";
EA_XICON_SHARESETTING = "共用框架位置設定";
EA_XICON_ICONSIZE = "圖示大小";
-- EA_XICON_ICONSIZE2 = "目標圖示大小";
-- EA_XICON_ICONSIZE3 = "CD圖示大小";
EA_XICON_LARGE = "大";
EA_XICON_SMALL = "小";
EA_XICON_HORSPACE = "水平間距";
EA_XICON_VERSPACE = "垂直間距";
-- EA_XICON_ICONSPACE1 = "自身圖示間距";
-- EA_XICON_ICONSPACE2 = "目標圖示間距";
-- EA_XICON_ICONSPACE3 = "CD圖示間距";
EA_XICON_MORE = "多";
EA_XICON_LESS = "少";
EA_XICON_REDDEBUFF = "本身Debuff圖示紅色深度";
EA_XICON_GREENDEBUFF = "目標Debuff圖示綠色深度";
EA_XICON_DEEP = "深";
EA_XICON_LIGHT = "淡";
-- EA_XICON_DIRECTION = "延展方向";
-- EA_XICON_DIRUP = "上";
-- EA_XICON_DIRDOWN = "下";
-- EA_XICON_DIRLEFT = "左";
-- EA_XICON_DIRRIGHT = "右";
EA_XICON_TAR_NEWLINE = "目標Debuff以另一行顯示";
EA_XICON_TAR_HORSPACE = "與提醒框架水平間距";
EA_XICON_TAR_VERSPACE = "與提醒框架垂直間距";
EA_XICON_TOGGLE_ALERTFRAME = "移動框架";
EA_XICON_RESET_FRAMEPOS = "重設框架位置";
EA_XICON_SELF_BUFF = "本身Buff";
EA_XICON_SELF_SPBUFF = "本身DeBuff(1)\n或特殊框架";
EA_XICON_SELF_DEBUFF = "本身Debuff";
EA_XICON_TARGET_BUFF = "目標Buff";
EA_XICON_TARGET_SPBUFF = "目標Buff(1)\n或特殊框架";
EA_XICON_TARGET_DEBUFF = "目標Debuff";
EA_XICON_SCD = "技能CD";
EA_XICON_EXECUTION = "提示首領級目標血量斬殺期";
EA_XICON_EXEFULL = "50%";
EA_XICON_EXECLOSE = "關閉";
EA_XICON_SCD_USECOOLDOWN = "技能冷卻使用倒數陰影(需重載UI)";

EX_XCLSALERT_SELALL = "全選";
EX_XCLSALERT_CLRALL = "全不選";
EX_XCLSALERT_LOADDEFAULT = "預設";
EX_XCLSALERT_REMOVEALL = "全刪";
EX_XCLSALERT_SPELL = "法術ID:";
EX_XCLSALERT_ADDSPELL = "新增";
EX_XCLSALERT_DELSPELL = "刪除";
EX_XCLSALERT_HELP1 = "上面列表以[法術ID]作為排列順序";
EX_XCLSALERT_HELP2 = "若想查詢法術ID，建議輸入 /eam help 指令";
EX_XCLSALERT_HELP3 = "瞭解在遊戲中[查詢法術]的各種指令。";
EX_XCLSALERT_HELP4 = "額外提醒區為非Buff類型之條件式技能";
EX_XCLSALERT_HELP5 = "例如:敵人血量進入斬殺期,或招架後使用";
EX_XCLSALERT_HELP6 = ",不會額外顯示Buff,卻能使用的技能。";
EX_XCLSALERT_SPELLURL = "http://www.wowhead.com/spells";

EA_XTARALERT_TARGET_MYDEBUFF = "僅限玩家施放減益";

EA_XGRPALERT_ICONALPHA = "圖示透明度";
EA_XGRPALERT_GRPID = "群組ID:";
EA_XGRPALERT_TALENT1 = "專精1";
EA_XGRPALERT_TALENT2 = "專精2";
EA_XGRPALERT_TALENT3 = "專精3";
EA_XGRPALERT_TALENT4 = "專精4";
EA_XGRPALERT_HIDEONLEAVECOMBAT = "無戰鬥時隱藏"
EA_XGRPALERT_HIDEONLOSTTARGET = "無目標時隱藏"
EA_XGRPALERT_TALENTS = "不限專精";
EA_XGRPALERT_NEWSPELLBTN = "新增法術";
EA_XGRPALERT_NEWCHECKBTN = "新增父條件";
EA_XGRPALERT_NEWSUBCHECKBTN = "新增子條件";
EA_XGRPALERT_SPELLNAME = "法術名稱:";
EA_XGRPALERT_SPELLICON = "法術圖示:";
EA_XGRPALERT_TITLECHECK = "父條件:";
EA_XGRPALERT_TITLESUBCHECK = "子條件:";
EA_XGRPALERT_TITLEORDERUP = "提升優先度";
EA_XGRPALERT_TITLEORDERDOWN = "降低優先度";
EA_XGRPALERT_LOGICS = {
	[1]={text="並且", value=1},
	[2]={text="或者", value=0}, };
EA_XGRPALERT_EVENTTYPE = "事件類型:";
EA_XGRPALERT_EVENTTYPES = {
	[1]={text="對象能量異動類", value="UNIT_POWER_UPDATE"},
	[2]={text="對象血量異動類", value="UNIT_HEALTH"},
	[3]={text="對象增減益異動類", value="UNIT_AURA"},
	[4]={text="連擊數異動類", value="UNIT_COMBO_POINTS"}, };
EA_XGRPALERT_UNITTYPE = "對象別:";
EA_XGRPALERT_UNITTYPES = {
	[1]={text="玩家", value="player"},
	[2]={text="目標", value="target"},
	[3]={text="專注目標", value="focus"},
	[4]={text="寵物", value="pet"},
	[5]={text="首領1", value="boss1"},
	[6]={text="首領2", value="boss2"},
	[7]={text="首領3", value="boss3"},
	[8]={text="首領4", value="boss4"}, 
	[9]={text="隊友1", value="party1"},
	[10]={text="隊友2", value="party2"},
	[11]={text="隊友3", value="party3"},
	[12]={text="隊友4", value="party4"},
	[13]={text="團隊1", value="raid1"},
	[14]={text="團隊2", value="raid2"},
	[15]={text="團隊3", value="raid3"},
	[16]={text="團隊4", value="raid4"},
	[17]={text="團隊5", value="raid5"},
	[18]={text="團隊6", value="raid6"},
	[19]={text="團隊7", value="raid7"},
	[20]={text="團隊8", value="raid8"},
	[21]={text="團隊9", value="raid9"},
};

EA_XGRPALERT_CHECKCD = "檢測法術CD:";
	
EA_XGRPALERT_HEALTH = "血量:";
EA_XGRPALERT_COMPARES = {
	[1]={text="<", value=1},
	[2]={text="<=", value=2},
	[3]={text="=", value=3},
	[4]={text=">=", value=4},
	[5]={text=">", value=5}, 
	[6]={text="<>", value=6}, 
	[7]={text="*", value=7}, 		--any	
};
EA_XGRPALERT_COMPARETYPES = {
	[1]={text="數值", value=1},
	[2]={text="百分比", value=2},
};
EA_XGRPALERT_CHECKAURA = "增減益:";
EA_XGRPALERT_CHECKAURAS = {
	[1]={text="存在", value=1},
	[2]={text="不存在", value=2},
};
EA_XGRPALERT_AURATIME = "時間:";
EA_XGRPALERT_AURASTACK = "堆疊:";
EA_XGRPALERT_CASTBYPLAYER = "限玩家施放";
EA_XGRPALERT_COMBOPOINT = "連擊數:";

EA_XLOOKUP_START1 = "查詢法術名稱";
EA_XLOOKUP_START2 = "完整符合";
EA_XLOOKUP_RESULT1 = "查詢法術結果";
EA_XLOOKUP_RESULT2 = "項符合";
EA_XLOAD_LOAD = "\124cffFFFF00EventAlertMod\124r:法術監控觸發提示,已載入版本:\124cff00FFFF";

EA_XLOAD_FIRST_LOAD = "\124cffFF0000首次載入 EventAlertMod 特效觸發提示UI，載入預設參數\124r。\n\n"..
"請使用 \124cffFFFF00/eam opt\124r 來進行參數設定、監控法術設定、調整位置。\n\n";

EA_XLOAD_NEWVERSION_LOAD = "請使用 \124cffFFFF00/eam help\124r 查閱詳細指令說明。\n\n\n"..
"\124cff00FFFF- 主要更新項目 -\124r\n\n"..
"*功能新增：群組式多判斷條件的事件提示功能。\n\n"..
"目前支援偵測事件為：\n"..
"1.'對象'的'能量'，'大於等於'或'小於等於'一定'值或比例'時發動\n"..
"2.'對象'的'血量'，'大於等於'或'小於等於'一定'值或比例'時發動\n"..
"3.'對象'的'Buff/Debuff'，'含有特定法術ID'(可另以層數或秒數過濾)，或'不含有特定法術ID'時發動\n"..
"4.'玩家'對於'目標'的連擊點數，'大於等於'或'小於等於'一定'值'時發動\n"..
"以上所有條件可以用 AND 或 OR，一個或以上的條件來篩選。\n"..
"篩選結果為真時，則提示所指定的圖案。\n"..
""; -- END OF NEWVERSION






EA_XCMD_VER = " \124cff00FFFFBy Whitep@雷鱗\124r 版本: ";
EA_XCMD_DEBUG = " 模式: ";
EA_XCMD_SELFLIST = " 顯示自身Buff/Debuff: ";
EA_XCMD_TARGETLIST = " 顯示目標Debuff: ";
EA_XCMD_CASTSPELL = " 顯示施放法術ID: ";
EA_XCMD_AUTOADD_SELFLIST = " 自動新增本身全增減益: ";
EA_XCMD_ENVADD_SELFLIST = " 自動新增本身環境增減益: ";
EA_XCMD_DEBUG_P0 = "觸發法術清單";
EA_XCMD_DEBUG_P1 = "法術";
EA_XCMD_DEBUG_P2 = "法術ID";
EA_XCMD_DEBUG_P3 = "堆疊";
EA_XCMD_DEBUG_P4 = "持續秒數";

EA_XCMD_CMDHELP = {
	["TITLE"] = "\124cffFFFF00EventAlertMod\124r \124cff00FF00指令\124r說明(/eventalertmod or /eam):",
	["OPT"] = "\124cff00FF00/eam options(或opt)\124r - 顯示/關閉 主設定視窗.",
	["HELP"] = "\124cff00FF00/eam help\124r - 顯示進一步指令說明.",
	["SHOW"] = {
		"\124cff00FF00/eam show [sec]\124r -",
		"開始/停止, 持續列出 >玩家< 身上所有 Buff/Debuff 的法術ID. 並且持續時間為 sec 秒之內的法術",
	},
	["SHOWT"] = {
		"\124cff00FF00/eam showtarget(或showt) [sec]\124r -",
		"開始/停止, 持續列出 >目標< 身上所有 Debuff 的法術ID. 並且持續時間為 sec 秒之內的法術",
	},
	["SHOWC"] = {
		"\124cff00FF00/eam showcast(或showc)\124r -",
		"開始/停止, 成功施放法術之後, 列出所施放的法術ID",
	},
	["SHOWA"] = {
		"\124cff00FF00/eam showautoadd(或showa) [sec]\124r -",
		"開始/停止, 自動將 >玩家< 身上所有 Buff/Debuff 的法術加入監測清單. 並且持續時間為 sec 秒(預設為60秒)之內的法術",
	},
	["SHOWE"] = {
		"\124cff00FF00/eam showenvadd(或showe) [sec]\124r -",
		"開始/停止, 自動將 >玩家< 身上 Buff/Debuff 的法術(但排除來自團隊與隊伍的)加入監測清單. 並且持續時間為 sec 秒(預設為60秒)之內的法術",
	},
	["LIST"] = {
		"\124cff00FF00/eam list\124r - 顯示觸發法術清單",
		"顯示/隱藏 show, showc, showt, lookup, lookupfull 指令的輸出結果",
	},
	["LOOKUP"] = {
		"\124cff00FF00/eam lookup(或l) 查詢名稱\124r - 部份名稱查詢法術ID",
		"查詢遊戲中所有法術，並列出所有[部份符合]查詢名稱的法術ID",
	},
	["LOOKUPFULL"] = {
		"\124cff00FF00/eam lookupfull(或lf) 查詢名稱\124r - 完整名稱查詢法術ID",
		"查詢遊戲中所有法術，並列出所有[完整符合]查詢名稱的法術ID",
	},
}



EA_XOPT_SPECFLAG_HOLYPOWER = "聖能";
EA_XOPT_SPECFLAG_RUNICPOWER = "符文能量";
EA_XOPT_SPECFLAG_RUNES = "符文";
EA_XOPT_SPECFLAG_SOULSHARDS = "靈魂碎片";
EA_XOPT_SPECFLAG_LUNARPOWER = "星能";
EA_XOPT_SPECFLAG_COMBOPOINT = "賊/貓德連擊數";
EA_XOPT_SPECFLAG_LIFEBLOOM = "生命之花";
EA_XOPT_SPECFLAG_INSANITY = "瘋狂";									
EA_XOPT_SPECFLAG_RAGE = "怒氣";
EA_XOPT_SPECFLAG_ENERGY = "能量";
EA_XOPT_SPECFLAG_FOCUS = "集中值";
EA_XOPT_SPECFLAG_FOCUS_PET = "寵物集中";
EA_XOPT_SPECFLAG_LIGHTFORCE = "真氣";		
EA_XOPT_SPECFLAG_BURNINGEMBERS = "燃火餘燼";
EA_XOPT_SPECFLAG_DEMONICFURY = "惡魔之怒";
EA_XOPT_SPECFLAG_ARCANECHARGES = "秘法充能";
EA_XOPT_SPECFLAG_MAELSTROM = "元能";
EA_XOPT_SPECFLAG_FURY = "魔怒";
EA_XOPT_SPECFLAG_PAIN = "魔痛";

EA_XGRPALERT_POWERTYPE = "能量別:";
EA_XGRPALERT_POWERTYPES = {
	[1]={text="法力", value=EA_SPELL_POWER_MANA},
	[2]={text="怒氣", value=EA_SPELL_POWER_RAGE},
	[3]={text="集中值", value=EA_SPELL_POWER_FOCUS},
	[4]={text="能量", value=EA_SPELL_POWER_ENERGY},
	[5]={text="符文", value=EA_SPELL_POWER_RUNES},
	[6]={text="符文能量", value=EA_SPELL_POWER_RUNIC_POWER},
	[7]={text="靈魂碎片", value=EA_SPELL_POWER_SOUL_SHARDS},
	[8]={text="星能", value=EA_SPELL_POWER_LUNAR_POWER},
	[9]={text="聖能", value=EA_SPELL_POWER_HOLY_POWER},
	[10]={text="真氣", value=EA_SPELL_POWER_LIGHT_FORCE},		
	[11]={text="瘋狂", value=EA_SPELL_POWER_INSANITY},		
	[12]={text="燃火餘燼", value=EA_SPELL_POWER_BURNING_EMBERS},
	[13]={text="惡魔之怒", value=EA_SPELL_POWER_DEMONIC_FURY},
	[14]={text="秘法充能", value=EA_SPELL_POWER_ARCANE_CHARGES},
	[15]={text="元能", value=EA_SPELL_POWER_MAELSTROM},
	[16]={text="魔怒", value=EA_SPELL_POWER_FURY},
	[17]={text="魔痛", value=EA_SPELL_POWER_PAIN},
};

EA_XSPECINFO_COMBOPOINT = "連擊數";
EA_XSPECINFO_RUNICPOWER	= "符能";
EA_XSPECINFO_RUNES	= "符文";
EA_XSPECINFO_SOULSHARDS	= "靈魂碎片";
EA_XSPECINFO_LUNARPOWER= "星能";
--EA_XSPECINFO_ECLIPSE	= "月能";
--EA_XSPECINFO_ECLIPSEORG	= "日能";
EA_XSPECINFO_HOLYPOWER	= "聖能";
EA_XSPECINFO_INSANITY= "瘋狂";		
EA_XSPECINFO_ENERGY= "能量";
EA_XSPECINFO_RAGE= "怒氣";
EA_XSPECINFO_FOCUS= "集中值";
EA_XSPECINFO_FOCUS_PET= "寵物集中";
EA_XSPECINFO_LIGHTFORCE= "真氣";		
EA_XSPECINFO_ARCANECHARGES= "秘法充能";			
EA_XSPECINFO_MAELSTROM= "元能";		
EA_XSPECINFO_FURY= "魔怒";	
EA_XSPECINFO_PAIN= "魔痛";			
end		-- End Of If