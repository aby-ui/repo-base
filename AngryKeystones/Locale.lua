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
	scheduleTitle = "Schedule",
	scheduleWeek1 = "This week",
	scheduleWeek2 = "Next week",
	scheduleWeek3 = "In two weeks",
	scheduleWeek4 = "In three weeks",
	scheduleMissingKeystone = "Requires a level 7+ Mythic Keystone in your inventory to display.",
	scheduleUnknown = "The updated affix schedule is currently unknown.",
	config_hideTalkingHead = "Hide Talking Head dialog during a Mythic Keystone dungeon",
	config_resetPopup = "Show popup to reset instances upon leaving a completed Mythic Keystone dungeon",
	partyKeysTitle = "Party Keystones",
	newKeystoneAnnounce = "New Keystone: %s",
	currentKeystoneText = "Current: |cFFFFFFFF%s|r",
	config_announceKeystones = "Announce newly acquired Mythic Keystones to your party",
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
    config_silverGoldTimer = "추가 상자 2와 3의 남은 시간을 함께 표시",
    config_completionMessage = "신화 쐐기돌 던전 완료시 소요 시간 메시지 표시",
    config_showSplits = "던전 목표에서 각 목표당 소요 시간 표시",
    keystoneFormat = "[쐐기돌: %s - %d 레벨]",
    completion0 = "%s|1이;가; %s만에 끝났습니다. 제한 시간을 %s 초과했습니다.",
    completion1 = "%s|1을;를; %s만에 완료했습니다. 제한 시간은 %s 남았으며 %s|1이;가; 모자라 2상자를 놓쳤습니다.",
    completion2 = "%s 2상자를 %s만에 완료했습니다. 2상자 제한 시간은 %s 남았으며 %s|1이;가; 모자라 3상자를 놓쳤습니다.",
    completion3 = "%s 3상자를 %s만에 완료했습니다. 3상자 제한 시간이 %s 남았습니다.",
    completionSplits = "분할된 시점: %s.",
    timeLost = "잃은 시간",
    config_smallAffixes = "타이머 프레임에 속성 아이콘 크기 축소",
    config_deathTracker = "타이머 프레임에 죽은 횟수 표시",
    scheduleTitle = "예정된 조합",
    scheduleWeek1 = "이번주",
    scheduleWeek2 = "다음주",
    scheduleWeek3 = "2주 뒤",
    scheduleWeek4 = "3주 뒤",
    scheduleMissingKeystone = "예정된 조합을 보려면 레벨 7 이상의 신화 쐐기돌이 가방에 있어야 합니다.",
    config_hideTalkingHead = "신화 쐐기돌 던전에서 팝업 대화창 숨김",
    config_resetPopup = "완료한 신화 쐐기돌 던전을 나가면 인스턴스 초기화 팝업창 표시",
    partyKeysTitle = "파티 쐐기돌",
    newKeystoneAnnounce = "새 쐐기돌: %s",
    currentKeystoneText = "현재 쐐기돌: |cFFFFFFFF%s|r",
    config_announceKeystones = "신화 쐐기돌을 새로 받으면 파티에 알림",
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
	scheduleTitle = "日程表（推测，仅供参考）",
	scheduleWeek1 = "本周",
	scheduleWeek2 = "下周",
	scheduleWeek3 = "两周后",
	scheduleWeek4 = "三周后",
	scheduleMissingKeystone = "你需要一把7级以上的钥石才可激活此项功能。",
    scheduleUnknown = "抱歉，8.2词缀顺序尚未确定",
	config_exclusiveTracker = "在副本中隐藏任务和成就追踪（重载插件后生效）",
	config_hideTalkingHead = "在史诗钥石副本中隐藏NPC情景对话窗口",
	config_resetPopup = "离开已完成的副本后提示是否重置",
	partyKeysTitle = "队伍钥石信息",
	newKeystoneAnnounce = "新钥石：%s",
	currentKeystoneText = "当前钥石：|cFFFFFFFF%s|r",
	config_announceKeystones = "在队伍里通报获得的新钥石",
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
	partyKeysTitle = "隊伍鑰石信息",
	newKeystoneAnnounce = "新鑰石：%s",
	currentKeystoneText = "當前鑰石：|cFFFFFFFF%s|r",
	config_announceKeystones = "在隊伍里通報獲得的新鑰石",
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
