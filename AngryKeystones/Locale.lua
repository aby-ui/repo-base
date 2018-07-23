local ADDON, Addon = ...
local Locale = Addon:NewModule('Locale')

local default_locale = "enUS"
local current_locale = GetLocale()

local langs = {}
langs.enUS = {
	config_characterConfig = "Per-character configuration",
	config_progressTooltip = "Show progress each enemy gives on their tooltip",
	config_progressFormat = "Enemy Forces Format",
	config_progressFormat_1 = "24.19%",
	config_progressFormat_2 = "90/372",
	config_progressFormat_3 = "24.19% - 90/372",
	config_progressFormat_4 = "24.19% (75.81%)",
	config_progressFormat_5 = "90/372 (282)",
	config_progressFormat_6 = "24.19% (75.81%) - 90/372 (282)",
	config_splitsFormat = "Objective Splits Display",
	config_splitsFormat_1 = "Disabled",
	config_splitsFormat_2 = "Time from start",
	config_splitsFormat_3 = "Relative to previous",
	config_autoGossip = "Automatically select gossip entries during Mythic Keystone dungeons (ex: Odyn)",
	config_cosRumors = "Output to party chat clues from \"Chatty Rumormonger\" during Court of Stars",
	config_silverGoldTimer = "Show timer for both 2 and 3 bonus chests at same time",
	config_completionMessage = "Show message with final times on completion of a Mythic Keystone dungeon",
	config_showSplits = "Show split time for each objective in objective tracker",
	keystoneFormat = "[Keystone: %s - Level %d]",
	completion0 = "Timer expired for %s with %s, you were %s over the time limit.",
	completion1 = "Beat the timer for %s in %s. You were %s ahead of the timer, and missed +2 by %s.",
	completion2 = "Beat the timer for +2 %s in %s. You were %s ahead of the +2 timer, and missed +3 by %s.",
	completion3 = "Beat the timer for +3 %s in %s. You were %s ahead of the +3 timer.",
	completionSplits = "Split timings were: %s.",
	timeLost = "Time Lost",
	config_smallAffixes = "Reduce the size of affix icons on timer frame",
	config_deathTracker = "Show death tracker on timer frame",
	config_persistTracker = "Show objective tracker after Mythic Keystone completion (requires Reload UI to take effect)",
	scheduleTitle = "Schedule",
	scheduleWeek1 = "This week",
	scheduleWeek2 = "Next week",
	scheduleWeek3 = "In two weeks",
	scheduleWeek4 = "In three weeks",
	scheduleMissingKeystone = "Requires a level 7+ Mythic Keystone in your inventory to display.",
	config_exclusiveTracker = "Hide quest and achievement trackers during Mythic Keystones (requires Reload UI to take effect)",
	config_hideTalkingHead = "Hide Talking Head dialog during a Mythic Keystone dungeon",
	config_resetPopup = "Show popup to reset instances upon leaving a completed Mythic Keystone dungeon",
}
langs.enGB = langs.enUS

langs.esES = {
	config_characterConfig = "Configuración por personaje",
	config_progressTooltip = "Mostrar cantidad de progreso de cada enemigo en su tooltip",
	config_progressFormat = "Formato de \"Fuerzas enemigas\"",
	keystoneFormat = "[Piedra angular: %s - Nivel %d]",
}
langs.esMX = langs.esES

langs.ruRU = {
	config_characterConfig = "Настройки персонажа",
	config_progressTooltip = "Показывать прогресс за каждого врага в подсказках",
	config_progressFormat = "Формат отображения прогресса",
	keystoneFormat = "[Ключ: %s - Уровень %d]",
}

langs.deDE = {
	config_characterConfig = "Charakterspezifische Konfiguration",
	config_progressTooltip = "Fortschritt für \"Feindliche Streitkräfte\" im Tooltip von Feinden zeigen",
	config_progressFormat = "Format für \"Feindliche Streitkräfte\"",
	config_splitsFormat = "Zwischenzeitsanzeige der Ziele",
	config_splitsFormat_1 = "Deaktiviert",
	config_splitsFormat_2 = "Zeit ab Start",
	config_splitsFormat_3 = "Relativ zum vorherigen",
	config_autoGossip = "Gesprächsoptionen während Mythisch+-Dungeons (z.B. Odyn) automatisch auswählen",
	config_cosRumors = "Hinweise von \"Geschwätzige Plaudertasche\" im Hof der Sterne im Gruppenchat ausgeben",
	config_silverGoldTimer = "Zeit für +2- und +3-Bonustruhen gleichzeitig zeigen",
	config_completionMessage = "Nachricht mit finalen Zeiten am Ende des Dungeons anzeigen",
	config_showSplits = "Zwischenzeit für jedes Ziel in der Zielverfolgung anzeigen",
	keystoneFormat = "[Schlüsselstein: %s - Stufe %d]",
	completion0 = "Zeit abgelaufen für %s mit %s, ihr wart %s über dem Zeitlimit.",
	completion1 = "Zeit für %s in %s geschlagen. Ihr wart %s vor dem Zeitlimit, und habt +2 um %s verfehlt.",
	completion2 = "Zeit für +2 %s in %s geschlagen. Ihr wart %s vor dem Zeitlimit für +2, und habt +3 um %s verfehlt.",
	completion3 = "Zeit für +3 %s in %s geschlagen. Ihr wart %s vor dem Zeitlimit für +3.",
	completionSplits = "Zwischenzeiten waren: %s.",
	timeLost = "Verlorene Zeit",
	config_smallAffixes = "Die Größe der Affix-Symbole im Zeitfenster verringern",
	config_deathTracker = "Todeszähler im Zeitfenster zeigen",
	config_persistTracker = "Zielverfolgung nach Abschluss eines mythischen Schlüsselsteins wieder zeigen (Erfordert UI neu laden)",
	scheduleTitle = "Zeitplan",
	scheduleWeek1 = "Diese Woche",
	scheduleWeek2 = "Nächste Woche",
	scheduleWeek3 = "In zwei Wochen",
	scheduleWeek4 = "In drei Wochen",
	scheduleMissingKeystone = "Erfordert einen mythischen Schlüsselstein mit Stufe 7+ in deiner Tasche zur Anzeige.",
	config_exclusiveTracker = "Quest- und Erfolgsverfolgung während mythischen Schlüsselsteindungeons ausblenden (Erfordert UI neu laden)",
	config_hideTalkingHead = "Gesprächseinblendungen während eines mythischen Schlüsselsteindungeons ausblenden",
}

langs.koKR = {
	config_characterConfig = "캐릭터별 설정",
	config_progressTooltip = "각각의 적이 주는 진행도를 툴팁에 표시",
	config_progressFormat = "적 병력 표시 형식",
	config_splitsFormat = "공략 목표당 소요 시간",
	config_splitsFormat_1 = "사용하지 않음",
	config_splitsFormat_2 = "시작점부터 걸린 시간",
	config_splitsFormat_3 = "이전 목표부터 걸린 시간",
	config_autoGossip = "신화 쐐기돌 던전에서 자동으로 대화 넘김 (예: 오딘)",
	config_cosRumors = "별의 궁정에서 \"수다쟁이 호사가\"가 알려주는 단서 표시",
	config_silverGoldTimer = "추가 상자 2와 3의 남은 시간을 함께 표시",
	config_completionMessage = "신화 쐐기돌 던전 완료시 소요 시간 메시지 표시",
	config_showSplits = "던전 목표에서 각 목표당 소요 시간 표시",
	keystoneFormat = "[쐐기돌: %s - %d 레벨]",
	completion0 = "%s|1이;가; %s만에 끝났습니다. 제한 시간을 %s 초과했습니다.",
	completion1 = "%s|1을;를; %s만에 완료했습니다. 제한 시간은 %s 남았으며 %s|1이;가; 모자라 2상자를 놓쳤습니다.",
	completion2 = "%s 2상자를 %s만에 완료했습니다. 2상자 제한 시간은 %s 남았으며 %s|1이;가; 모자라 3상자를 놓쳤습니다.",
	completion3 = "%s 3상자를 %s만에 완료했습니다. 3상자 제한 시간이 %s 남았습니다.",
	completionSplits = "분할된 시점: %s.",
	timeLost = "깎인 시간",
	config_smallAffixes = "타이머 프레임에 속성 아이콘 크기 축소",
	config_deathTracker = "타이머 프레임에 사망 내역 표시",
	config_persistTracker = "신화 쐐기돌을 완료한 뒤에도 타이머 프레임 표시",
	scheduleTitle = "예정된 조합",
	scheduleWeek1 = "이번주",
	scheduleWeek2 = "다음주",
	scheduleWeek3 = "2주 뒤",
	scheduleWeek4 = "3주 뒤",
	scheduleMissingKeystone = "예정된 조합을 보려면 레벨 7 이상의 신화 쐐기돌이 가방에 있어야 합니다.",
	config_exclusiveTracker = "신화 쐐기돌 던전에서 퀘스트와 업적 추적창 숨김 (UI 재시작 필요)",
	config_hideTalkingHead = "신화 쐐기돌 던전에서 팝업 대화창 숨김",
	config_resetPopup = "완료한 신화 쐐기돌 던전을 나가면 인스턴스 초기화 팝업창 표시",
}

langs.zhCN = {
	config_characterConfig = "为角色进行独立的配置",
	config_progressTooltip = "聊天窗口的史诗钥石显示副本名称和等级",
	config_progressFormat = "敌方部队进度格式",
	config_splitsFormat = "进度分割显示方式",
	config_splitsFormat_1 = "禁用",
	config_splitsFormat_2 = "从头计时",
	config_splitsFormat_3 = "与之前关联",
	config_autoGossip = "在史诗钥石副本中自动对话交互（如奥丁）",
	config_cosRumors = "群星庭院密探线索发送到队伍频道",
	config_cosRumors = "群星庭院造谣者线索发送到队伍频道",
	config_silverGoldTimer = "同时显示2箱和3箱的计时",
	config_completionMessage = "副本完成时在聊天窗口显示总耗时",
	config_showSplits = "在任务列表的进度上显示单独的进度计时",
	keystoneFormat = "[%s（%d级）]",
	forcesFormat = " - 敌方部队 %s",
	completion0 = "你超时完成了 %s 的战斗。共耗时 %s，超出规定时间 %s。",
	completion1 = "你在规定时间内完成了 %s 的战斗！共耗时 %s，剩余时间 %s，2箱奖励超时 %s。",
	completion2 = "你在规定时间内获得了 %s 的2箱奖励！共耗时 %s，2箱奖励剩余时间 %s，3箱奖励超时 %s。",
	completion3 = "你在规定时间内获得了 %s 的3箱奖励！共耗时 %s，3箱奖励剩余时间 %s。",
	timeLost = "损失时间",
	config_smallAffixes = "缩小进度条上的光环图标大小",
	config_deathTracker = "在进度条上显示死亡统计",
	config_persistTracker = "副本完成后继续显示任务追踪（重载插件后生效）",
	scheduleTitle = "日程表",
	scheduleWeek1 = "本周",
	scheduleWeek2 = "下周",
	scheduleWeek3 = "两周后",
	scheduleWeek4 = "三周后",
	scheduleMissingKeystone = "你需要一把7级以上的钥石才可激活此项功能。",
	config_exclusiveTracker = "在副本中隐藏任务和成就追踪（重载插件后生效）",
	config_hideTalkingHead = "在史诗钥石副本中隐藏NPC情景对话窗口",
	config_resetPopup = "离开已完成的副本后提示是否重置",
}
langs.zhTW = {
	config_characterConfig = "為角色進行獨立的配置",
	config_progressTooltip = "聊天窗口的傳奇鑰石顯示副本名稱和等級",
	config_progressFormat = "敵方部隊進度格式",
	config_splitsFormat = "進度分割顯示方式",
	config_splitsFormat_1 = "禁用",
	config_splitsFormat_2 = "從頭計時",
	config_splitsFormat_3 = "與之前關聯",
	config_autoGossip = "在傳奇鑰石副本中自動進行對話互動（如歐丁）",
	config_cosRumors = "衆星之廷造謠者線索發送到隊伍頻道",
	config_silverGoldTimer = "同時顯示2箱及3箱的計時",
	config_completionMessage = "副本完成時在聊天窗口顯示總耗時",
	config_showSplits = "在任務列表的进度上顯示單獨的進度計時",
	keystoneFormat = "[%s（%d級）]",
	forcesFormat = " - 敵方部隊 %s",
	completion0 = "你超時完成了 %s 的戰鬥。共耗時 %s，超出規定時間 %s。",
	completion1 = "你在規定時間內完成了 %s 的戰鬥！共耗時 %s，剩餘時間 %s，2箱獎勵超時 %s。",
	completion2 = "你在規定時間內獲得了 %s 的2箱獎勵！共耗時 %s，2箱獎勵剩餘時間 %s，3箱獎勵超時 %s。",
	completion3 = "你在規定時間內獲得了 %s 的3箱獎勵！共耗時 %s，3箱獎勵剩餘時間 %s。",
	timeLost = "損失時間",
	config_smallAffixes = "縮小計時器上的光環圖標大小",
	config_deathTracker = "在計時器上顯示死亡統計",
	config_persistTracker = "副本完成後繼續顯示任務追蹤（重載插件後生效）",
	scheduleTitle = "日程表",
	scheduleWeek1 = "本周",
	scheduleWeek2 = "下周",
	scheduleWeek3 = "兩周後",
	scheduleWeek4 = "三周後",
	scheduleMissingKeystone = "你需要一把7級以上的鑰石來激活此項功能。",
	config_exclusiveTracker = "在副本中隱藏成就和任務追蹤（重裝插件後生效）",
	config_hideTalkingHead = "在傳奇鑰石副本中隱藏NPC情景對話窗口",
	config_resetPopup = "離開已完成的副本後提示是否重置",
}

function Locale:Get(key)
	if langs[current_locale] and langs[current_locale][key] ~= nil then
		return langs[current_locale][key]
	else
		return langs[default_locale][key]
	end
end

function Locale:Local(key)
	return langs[current_locale] and langs[current_locale][key]
end

function Locale:Exists(key)
	return langs[default_locale][key] ~= nil
end

setmetatable(Locale, {__index = Locale.Get})

local clues = {}
local rumors = {}

clues.enUS = {
	male = MALE,
	female = FEMALE,
	lightVest = "Light Vest",
	darkVest = "Dark Vest",
	shortSleeves = "Short Sleeves",
	longSleeves = "Long Sleeves",
	cloak = "Cloak",
	noCloak = "No Cloak",
	gloves = "Gloves",
	noGloves = "No Gloves",
	noPotion = "No Potion",
	book = "Book",
	coinpurse = "Coinpurse",
	potion = "Potion",
}
clues.enGB = clues.enUS

rumors.enUS = {
	["I heard somewhere that the spy isn't female."]="male",
	["I heard the spy is here and he's very good looking."]="male",
	["A guest said she saw him entering the manor alongside the Grand Magistrix."]="male",
	["One of the musicians said he would not stop asking questions about the district."]="male",

	["Someone's been saying that our new guest isn't male."]="female",
	["A guest saw both her and Elisande arrive together earlier."]="female",
	["They say that the spy is here and she's quite the sight to behold."]="female",
	["I hear some woman has been constantly asking about the district..."]="female",

	["The spy definitely prefers the style of light colored vests."]="lightVest",
	["I heard that the spy is wearing a lighter vest to tonight's party."]="lightVest",
	["People are saying the spy is not wearing a darker vest tonight."]="lightVest",

	["The spy definitely prefers darker clothing."]="darkVest",
	["I heard the spy's vest is a dark, rich shade this very night."]="darkVest",
	["The spy enjoys darker colored vests... like the night."]="darkVest",
	["Rumor has it the spy is avoiding light colored clothing to try and blend in more."]="darkVest",

	["Someone told me the spy hates wearing long sleeves."]="shortSleeves",
	["I heard the spy wears short sleeves to keep their arms unencumbered."]="shortSleeves",
	["I heard the spy enjoys the cool air and is not wearing long sleeves tonight."]="shortSleeves",
	["A friend of mine said she saw the outfit the spy was wearing. It did not have long sleeves."]="shortSleeves",

	["I heard the spy's outfit has long sleeves tonight."]="longSleeves",
	["A friend of mine mentioned the spy has long sleeves on."]="longSleeves",
	["Someone said the spy is covering up their arms with long sleeves tonight."]="longSleeves",
	["I just barely caught a glimpse of the spy's long sleeves earlier in the evening."]="longSleeves",

	["Someone mentioned the spy came in earlier wearing a cape."]="cloak",
	["I heard the spy enjoys wearing capes."]="cloak",

	["I heard that the spy left their cape in the palace before coming here."]="noCloak",
	["I heard the spy dislikes capes and refuses to wear one."]="noCloak",

	["There's a rumor that the spy always wears gloves."]="gloves",
	["I heard the spy carefully hides their hands."]="gloves",
	["Someone said the spy wears gloves to cover obvious scars."]="gloves",
	["I heard the spy always dons gloves."]="gloves",

	["You know... I found an extra pair of gloves in the back room. The spy is likely to be bare handed somewhere around here."]="noGloves",
	["There's a rumor that the spy never has gloves on."]="noGloves",
	["I heard the spy avoids having gloves on, in case some quick actions are needed."]="noGloves",
	["I heard the spy dislikes wearing gloves."]="noGloves",

	["Rumor has is the spy loves to read and always carries around at least one book."]="book",
	["I heard the spy always has a book of written secrets at the belt."]="book",

	["A musician told me she saw the spy throw away their last potion and no longer has any left."]="noPotion",
	["I heard the spy is not carrying any potions around."]="noPotion",

	["I'm pretty sure the spy has potions at the belt."]="potion",
	["I heard the spy brought along potions, I wonder why?"]="potion",
	["I heard the spy brought along some potions... just in case."]="potion",
	["I didn't tell you this... but the spy is masquerading as an alchemist and carrying potions at the belt."]="potion",

	["I heard the spy's belt pouch is lined with fancy threading."]="coinpurse",
	["A friend said the spy loves gold and a belt pouch filled with it."]="coinpurse",
	["I heard the spy's belt pouch is filled with gold to show off extravagance."]="coinpurse",
	["I heard the spy carries a magical pouch around at all times."]="coinpurse",
}
rumors.enGB = rumors.enUS

clues.zhCN = {
	lightVest = "浅色上衣",
	darkVest = "深色上衣",
	shortSleeves = "短袖",
	longSleeves = "长袖",
	cloak = "有斗篷",
	noCloak = "无斗篷",
	gloves = "有手套",
	noGloves = "无手套",
	noPotion = "无药水",
	book = "有书",
	coinpurse = "有钱袋",
	potion = "有药水",
}

rumors.zhCN = {
	["我在别处听说那个密探不是女性。"]="male",
	["我听说那个密探已经来了，而且他很英俊。"]="male",
	["有个客人说她看见他和大魔导师一起走进了庄园。"]="male",
	["有个乐师说，他一直在打听这一带的消息。"]="male",
	["有人说我们的新客人不是男性。"]="female",
	["他们说那个密探已经来了，而且她是个大美人。"]="female",
	["我听说有个女人一直打听贵族区的情况……"]="female",
	["那个间谍肯定更喜欢浅色的上衣。"]="lightVest",
	["我听说那个密探穿着一件浅色上衣来参加今晚的聚会。"]="lightVest",
	["大家都在说那个密探今晚没有穿深色的上衣。"]="lightVest",
	["那个间谍肯定更喜欢深色的服装。"]="darkVest",
	["我听说那个密探今晚所穿的外衣是浓密的暗深色。"]="darkVest",
	["那个密探喜欢深色的上衣……就像夜空一样深沉。"]="darkVest",
	["传说那个密探会避免穿浅色的服装，以便更好地混入人群。"]="darkVest",
	["有人告诉我那个密探讨厌长袖的衣服。"]="shortSleeves",
	["我听说密探喜欢穿短袖服装，以免妨碍双臂的活动。"]="shortSleeves",
	["我听说那个密探喜欢清凉的空气，所以今晚没有穿长袖衣服。"]="shortSleeves",
	["我的一个朋友说，她看到了密探穿的衣服，是一件短袖上衣。"]="shortSleeves",
	["我听说那个密探今天穿着长袖外套。"]="longSleeves",
	["我的一个朋友说那个密探穿着长袖衣服。"]="longSleeves",
	["有人说，那个密探今晚穿了一件长袖的衣服。"]="longSleeves",
	["上半夜的时候，我正巧瞥见那个密探穿着长袖衣服。"]="longSleeves",
	["有人提到那个密探之前是穿着斗篷来的。"]="cloak",
	["我听说那个密探喜欢穿斗篷。"]="cloak",
	["我听说那个密探在来这里之前，把斗篷忘在王宫里了。"]="noCloak",
	["我听说那个密探讨厌斗篷，所以没有穿。"]="noCloak",
	["有传言说那个密探总是带着手套。"]="gloves",
	["我听说密探都会小心隐藏自己的双手。"]="gloves",
	["有人说那个密探带着手套，以掩盖手上明显的疤痕。"]="gloves",
	["我听说那个密探总是带着手套。"]="gloves",
	["你知道吗……我在后头的房间里发现了一双多余的手套。那个密探现在可能就赤着双手在这附近转悠呢。"]="noGloves",
	["有传言说那个密探从来不戴手套。"]="noGloves",
	["我听说那个密探会尽量不戴手套，以防在快速行动时受到阻碍。"]="noGloves",
	["我听说那个密探不喜欢戴手套。"]="noGloves",
	["据说那个密探喜欢读书，而且总是随身携带至少一本书。"]="book",
	["我听说那个密探的腰带上，总是挂着一本写满机密的书。"]="book",
	["有个乐师告诉我，她看到那个密探扔掉了身上的最后一瓶药水，已经没有药水了。"]="noPotion",
	["我听说那个密探根本没带任何药水。"]="noPotion",
	["我敢肯定，那个密探的腰带上挂着药水。"]="potion",
	["我听说那个密探随身带着药水，这是为什么呢？"]="potion",
	["可别说是我告诉你的……那个密探伪装成了炼金师，腰带上挂着药水。"]="potion",
	["我听说那个密探买了一些药水……以防万一。"]="potion",
	["我听说那个密探的腰包上绣着精美的丝线。"]="coinpurse",
	["一个朋友说，那个密探喜欢黄金，所以在腰包里装满了金币。"]="coinpurse",
	["我听说那个密探的腰包里装满了摆阔用的金币。"]="coinpurse",
	["我听说那个密探总是带着一个魔法袋。"]="coinpurse",
}

clues.koKR = {
	male = MALE,
	female = FEMALE,
	lightVest = "밝은색 조끼",
	darkVest = "어두운색 조끼",
	shortSleeves = "짧은 소매",
	longSleeves = "긴 소매",
	cloak = "망토 있음",
	noCloak = "망토 없음",
	gloves = "장갑 있음",
	noGloves = "장갑 없음",
	noPotion = "물약 없음",
	book = "책",
	coinpurse = "금화 주머니",
	potion = "물약",
}

rumors.koKR = {
	["첩자가 여성이 아니라는 얘기를 들었습니다."]="male",
	["첩자가 나타났다고 합니다. 그 남자는 대단히 호감형이라고도 하더군요."]="male",
	["한 남자가 대마법학자와 나란히 저택에 들어오는 걸 봤다는 얘기가 있더군요."]="male",
	["한 연주자가 말하길, 그 남자가 끊임없이 그 지구에 관한 질문을 늘어놨다고 합니다."]="male",
	["그 불청객은 남자가 아니라는 말을 들었습니다."]="female",
	["아까 한 방문객이 그녀와 엘리산드가 함께 도착하는 걸 보았답니다."]="female",
	["첩자가 나타났다고 합니다. 그 여자는 아주 미인이라고도 하더군요."]="female",
	["어떤 여자가 귀족 지구에 관해 계속 묻고 다닌다고 하던데..."]="female",
	["그자는 첩자인데도 밝은색 조끼를 즐겨 입는다고 합니다."]="lightVest",
	["오늘 밤 파티에 그 첩자는 밝은색 조끼를 입고 올 거라는 말을 들었습니다."]="lightVest",
	["사람들이 그러는데, 오늘 밤 그 첩자는 어두운 색 조끼를 입지 않았다고 합니다."]="lightVest",
	["그 첩자는 분명 어두운 옷을 선호합니다."]="darkVest",
	["오늘 밤 그 첩자는 어둡고 짙은 색의 조끼를 입었다고 합니다."]="darkVest",
	["그 첩자는 어두운 색 조끼를 즐겨 입어요... 밤과 같은 색이죠."]="darkVest",
	["소문에 그 첩자는 눈에 띄지 않으려고 밝은색 옷은 피한다더군요."]="darkVest",
	["그 첩자는 소매가 긴 옷을 입는 걸 정말 싫어한다고 합니다."]="shortSleeves",
	["그 첩자는 팔을 빠르게 움직이려고 짧은 소매 옷만 고집한다고 합니다."]="shortSleeves",
	["그 첩자는 시원한 걸 좋아해서 오늘 밤 짧은 소매를 입고 왔다고 들었습니다."]="shortSleeves",
	["제 친구가 그 첩자가 입은 옷을 봤는데, 긴 소매는 아니었다는군요!"]="shortSleeves",
	["오늘 밤 첩자는 긴 소매 옷을 입었다고 하더군요."]="longSleeves",
	["제 친구 말로는, 첩자가 긴 소매 옷을 입었다고 합니다."]="longSleeves",
	["오늘 밤 그 첩자는 소매가 긴 옷을 입었다고 들었어요."]="longSleeves",
	["초저녁에 첩자를 언뜻 보았는데... 긴 소매 옷을 입었던 것 같습니다."]="longSleeves",
	["그 첩자가 망토를 걸친 모습을 봤다는 사람이 있었습니다."]="cloak",
	["그 첩자는 망토를 즐겨 입는다고 들었습니다."]="cloak",
	["제가 듣기로는 그 첩자가 궁전에 망토를 벗어두고 여기 왔다고 합니다."]="noCloak",
	["그 첩자는 망토를 싫어해서 절대로 입지 않는다고 합니다."]="noCloak",
	["그 첩자는 항상 장갑을 낀다고 하더군요."]="gloves",
	["제가 듣기로는, 그 첩자는 항상 신경 써서 손을 가린다고 합니다."]="gloves",
	["그 첩자는 손에 있는 선명한 흉터를 가리려고 장갑을 낀다고 합니다."]="gloves",
	["그 첩자는 항상 장갑을 낀다고 들었습니다."]="gloves",
	["안쪽 방에서 장갑 한 켤레를 발견했습니다. 첩자는 분명히 이 주변에 장갑을 끼지 않은 사람중 하나일 거에요."]="noGloves",
	["그 첩자는 장갑을 끼는 일이 없다고 하더군요."]="noGloves",
	["그 첩자는 장갑을 끼지 않는답니다. 위급한 순간에 걸리적거려서 그렇겠지요."]="noGloves",
	["그 첩자는 장갑을 끼는 걸 싫어한다고 들었습니다."]="noGloves",
	["소문을 들어 보니, 그 첩자는 독서를 좋아해서 항상 책을 가지고 다닌다고 합니다."]="book",
	["그 첩자의 허리띠 주머니에는 비밀이 잔뜩 적힌 책이 담겨 있다고 합니다."]="book",
	["한 연주자가 그 첩자가 마지막 물약을 버리는 걸 봤다고 합니다. 그러니 더는 물약이 없겠죠."]="noPotion",
	["그 첩자는 물약을 가지고 다니지 않는다고 합니다."]="noPotion",
	["그 첩자는 허리띠에 물약을 매달고 있을 게 분명합니다. 있는 게 분명해요."]="potion",
	["그 첩자는 물약을 가지고 다닌데요. 이유가 뭘까요?"]="potion",
	["그 첩자는 만약을 대비해... 물약 몇 개를 가져왔다고 합니다."]="potion",
	["이 얘기를 깜빡할 뻔했네요... 그 첩자는 연금술사로 가장해 허리띠에 물약을 달고 다닌다고 합니다."]="potion",
	["그 첩자는 허리띠 주머니도 휘황찬란한 자수로 꾸며져 있다고 합니다."]="coinpurse",
	["제 친구가 말하길, 그 첩자는 금을 너무 좋아해서 허리띠 주머니에도 금이 가득 들어 있다고 합니다."]="coinpurse",
	["그 첩자는 어찌나 사치스러운지 허리띠에 달린 주머니에 금화를 잔뜩 넣어서 다닌다고 합니다."]="coinpurse",
	["그 첩자는 마법의 주머니를 항상 가지고 다닌다고 들었습니다."]="coinpurse",
}

clues.deDE = {
	male = MALE,
	female = FEMALE,
	lightVest = "Helle Weste",
	darkVest = "Dunkle Weste",
	shortSleeves = "Kurze Ärmel",
	longSleeves = "Lange Ärmel",
	cloak = "Umhang",
	noCloak = "Kein Umhang",
	gloves = "Handschuhe",
	noGloves = "Keine Handschuhe",
	noPotion = "Kein Fläschchen",
	book = "Buch",
	coinpurse = "Geldbeutel",
	potion = "Fläschchen",
}

rumors.deDE = {
	["Irgendwo habe ich gehört, dass der Spion nicht weiblich ist."]="male",
	["Ich hörte, dass der Spion ein äußerst gutaussehender Herr ist."]="male",
	["Ein Gast sagte, sie sah, wie ein Herr an der Seite der Großmagistrix das Anwesen betreten hat."]="male",
	["Einer der Musiker sagte, er stellte unablässig Fragen über den Bezirk."]="male",

	["Jemand hat behauptet, dass unser neuester Gast nicht männlich ist."]="female",
	["Ein Gast hat beobachtet, wie sie und Elisande vorhin gemeinsam eingetroffen sind."]="female",
	["Man sagt, die Spionin wäre hier und sie wäre eine wahre Augenweide."]="female",
	["Wie ich höre, hat eine Frau sich ständig nach diesem Bezirk erkundigt..."]="female",

	["Der Spion bevorzugt auf jeden Fall Westen mit hellen Farben."]="lightVest",
	["Wie ich hörte, trägt der Spion auf der Party heute Abend eine helle Weste."]="lightVest",
	["Die Leute sagen, dass der Spion heute Abend keine dunkle Weste trägt."]="lightVest",

	["Der Spion bevorzugt auf alle Fälle dunkle Kleidung."]="darkVest",
	["Ich hörte, dass die Weste des Spions heute Abend von dunkler, kräftiger Farbe ist."]="darkVest",
	["Dem Spion gefallen Westen mit dunklen Farben... dunkel wie die Nacht."]="darkVest",
	["Gerüchten zufolge vermeidet der Spion es, helle Kleidung zu tragen, damit er nicht so auffällt."]="darkVest",

	["Jemand sagte mir, dass der Spion lange Ärmel hasst."]="shortSleeves",
	["Mir ist zu Ohren gekommen, dass der Spion kurze Ärmel trägt, damit er seine Arme ungehindert bewegen kann."]="shortSleeves",
	["Man hat mir zugetragen, dass der Spion die kühle Luft mag und deshalb heute Abend keine langen Ärmel trägt."]="shortSleeves",
	["Eine meiner Freundinnen sagte, dass sie die Kleidung des Spions gesehen hat. Er trägt keine langen Ärmel."]="shortSleeves",

	["Wie ich hörte, trägt der Spion heute Abend Kleidung mit langen Ärmeln."]="longSleeves",
	["Einer meiner Freunde erwähnte, dass der Spion lange Ärmel trägt."]="longSleeves",
	["Jemand sagte, dass der Spion heute Abend seine Arme mit langen Ärmeln bedeckt."]="longSleeves",
	["Ich habe am frühen Abend einen kurzen Blick auf die langen Ärmel des Spions erhascht."]="longSleeves",

	["Jemand erwähnte, dass der Spion vorhin hier hereinkam und einen Umhang trug."]="cloak",
	["Mir ist zu Ohren gekommen, dass der Spion gerne Umhänge trägt."]="cloak",

	["Ich hörte, dass der Spion seinen Umhang im Palast gelassen hat, bevor er hierhergekommen ist."]="noCloak",
	["Ich hörte, dass der Spion keine Umhänge mag und sich weigert, einen zu tragen."]="noCloak",

	["Einem Gerücht zufolge trägt der Spion immer Handschuhe."]="gloves",
	["Wie ich hörte, verbirgt der Spion sorgfältig die Hände."]="gloves",
	["Jemand behauptete, dass der Spion Handschuhe trägt, um sichtbare Narben zu verbergen."]="gloves",
	["Ich hörte, dass der Spion immer Handschuhe anlegt."]="gloves",

	["Wisst Ihr... Ich habe ein zusätzliches Paar Handschuhe im Hinterzimmer gefunden. Wahrscheinlich ist der Spion hier irgendwo mit bloßen Händen unterwegs."]="noGloves",
	["Es gibt Gerüchte, dass der Spion niemals Handschuhe trägt."]="noGloves",
	["Ich hörte, dass der Spion es vermeidet, Handschuhe zu tragen, falls er schnell handeln muss."]="noGloves",
	["Mir ist zu Ohren gekommen, dass der Spion ungern Handschuhe trägt."]="noGloves",

	["Gerüchten zufolge liest der Spion gerne und trägt immer mindestens ein Buch bei sich."]="book",
	["Ich hörte, dass der Spion immer ein Buch mit niedergeschriebenen Geheimnissen am Gürtel trägt."]="book",

	["Eine Musikerin erzählte mir, dass sie gesehen hat, wie der Spion seinen letzten Trank wegwarf und jetzt keinen mehr übrig hat."]="noPotion",
	["Wie ich hörte, hat der Spion keine Tränke bei sich."]="noPotion",

	["Ich bin mir ziemlich sicher, dass der Spion Tränke am Gürtel trägt."]="potion",
	["Ich hörte, dass der Spion Tränke mitgebracht hat... Ich frage mich wieso?"]="potion",
	["Wie ich hörte, hat der Spion einige Tränke mitgebracht... für alle Fälle."]="potion",
	["Von mir habt Ihr das nicht... aber der Spion verkleidet sich als Alchemist und trägt Tränke an seinem Gürtel."]="potion",

	["Ich hörte, dass der Gürtelbeutel des Spions mit ausgefallenem Garn gesäumt wurde."]="coinpurse",
	["Ein Freund behauptet, dass der Spion Gold liebt und einen Gürtelbeutel voll davon hat."]="coinpurse",
	["Mir ist zu Ohren gekommen, dass der Gürtelbeutel des Spions mit Gold gefüllt ist, um besonders extravagant zu erscheinen."]="coinpurse",
	["Ich hörte, dass der Spion immer einen magischen Beutel mit sich herumträgt."]="coinpurse",
}

function Locale:HasRumors()
	return rumors[current_locale] ~= nil and clues[current_locale] ~= nil
end

function Locale:Rumor(gossip)
	if rumors[current_locale] and rumors[current_locale][gossip] then
		return clues[current_locale] and clues[current_locale][rumors[current_locale][gossip]]
	end
end
