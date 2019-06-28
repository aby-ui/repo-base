﻿if GetLocale() ~= "zhTW" then return end

local L

-------------------------------
--  Dark Iron Golem Council  --
-------------------------------
L = DBM:GetModLocalization(169)

L:SetWarningLocalization({
	SpecWarnActivated			= "轉換目標到 %s!",
	specWarnGenerator			= "發電機 - 拉開%s!"
})

L:SetTimerLocalization({
	timerShadowConductorCast	= "聚影體",
	timerArcaneLockout			= "秘法殲滅者鎖定",
	timerArcaneBlowbackCast		= "秘法逆爆",
	timerNefAblity				= "技能增益冷卻"
})

L:SetOptionLocalization({
	timerShadowConductorCast	= "為$spell:92048的施放顯示計時器",
	timerArcaneLockout			= "為$spell:79710法術鎖定顯示計時器",
	timerArcaneBlowbackCast		= "為$spell:91879的施放顯示計時器",
	timerNefAblity				= "為困難技能增益冷卻顯示計時器",
	SpecWarnActivated			= "當新首領啟動時顯示特別警告",
	specWarnGenerator			= "當首領獲得$spell:91557時顯示特別警告",
	SetIconOnActivated			= "設置標記到最後啟動的首領"
})

L:SetMiscLocalization({
	YellTargetLock				= "覆體之影! 遠離我!"
})

--------------
--  Magmaw  --
--------------
L = DBM:GetModLocalization(170)

L:SetWarningLocalization({
	SpecWarnInferno		= "熾熱的煉獄即將到來(約4秒前)"
})

L:SetOptionLocalization({
	SpecWarnInferno		= "為$spell:92190顯示預先特別警告(約4秒前)",
	RangeFrame			= "第2階段時顯示距離框(5碼)"
})

L:SetMiscLocalization({
	Slump				= "%s往前撲倒，露出他的鉗子!",
	HeadExposed			= "%s被釘在尖刺上，露出了他的頭!",
	YellPhase2			= "真難想像!看來你真有機會打敗我的蟲子!也許我可幫忙...扭轉戰局。"
})

-----------------
--  Atramedes  --
-----------------
L = DBM:GetModLocalization(171)

L:SetOptionLocalization({
	InfoFrame				= "為$journal:3072顯示資訊框架"
})

L:SetMiscLocalization({
	NefAdd					= "亞特拉米德，英雄們就在那!",
	Airphase				= "沒錯，逃吧!每一步都會讓你的心跳加速。跳得轟隆作響...震耳欲聾。你逃不掉的!"
})

-----------------
--  Chimaeron  --
-----------------
L = DBM:GetModLocalization(172)

L:SetOptionLocalization({
	RangeFrame				= "顯示距離框 (6碼)",
	InfoFrame			 	= "為血量(低於1萬血)顯示資訊框架"
})

L:SetMiscLocalization({
	HealthInfo				= "血量資訊"
})

----------------
--  Maloriak  --
----------------
L = DBM:GetModLocalization(173)

L:SetWarningLocalization({
	WarnPhase				= "%s階段"
})

L:SetTimerLocalization({
	TimerPhase				= "下一階段"
})

L:SetOptionLocalization({
	WarnPhase				= "為哪個階段即將到來顯示警告",
	TimerPhase				= "為下一階段顯示計時器",
	RangeFrame				= "藍色階段時顯示距離框 (6碼)",
	SetTextures				= "自動在黑暗階段停用投影材質<br/>(離開黑暗階段後回到啟用)"
})

L:SetMiscLocalization({
	YellRed				= "紅色|r瓶子到鍋子裡!",
	YellBlue			= "藍色|r瓶子到鍋子裡!",
	YellGreen			= "綠色|r瓶子到鍋子裡!",
	YellDark			= "黑暗|r魔法到鍋子裡!"
})

----------------
--  Nefarian  --
----------------
L = DBM:GetModLocalization(174)

L:SetWarningLocalization({
	OnyTailSwipe			= "尾部鞭擊 (奧妮克希亞)",
	NefTailSwipe			= "尾部鞭擊 (奈法利安)",
	OnyBreath				= "暗影焰息 (奧妮克希亞)",
	NefBreath				= "暗影焰息 (奈法利安)",
	specWarnShadowblazeSoon	= "%s",
	warnShadowblazeSoon		= "%s"
})

L:SetTimerLocalization({
	timerNefLanding			= "奈法利安落地",
	OnySwipeTimer			= "尾部鞭擊冷卻 (奧妮)",
	NefSwipeTimer			= "尾部鞭擊冷卻 (奈法)",
	OnyBreathTimer			= "暗影焰息冷卻 (奧妮)",
	NefBreathTimer			= "暗影焰息冷卻 (奈法)"
})

L:SetOptionLocalization({
	OnyTailSwipe			= "為奧妮克希亞的$spell:77827顯示警告",
	NefTailSwipe			= "為奈法利安的$spell:77827顯示警告",
	OnyBreath				= "為奧妮克希亞的$spell:77826顯示警告",
	NefBreath				= "為奈法利安的$spell:77826顯示警告",
	specWarnCinderMove		= "為$spell:79339顯示特殊警告提示你離開(爆炸前5秒)",
	warnShadowblazeSoon		= "為$spell:81031顯示提前警告<br/>(只在計時器與第一次大喊台詞同步後顯示, 以確保準確)",
	specWarnShadowblazeSoon	= "為$spell:94085顯示預先特別警告(約5秒)",
	timerNefLanding			= "為奈法利安落地顯示計時器",
	OnySwipeTimer			= "為奧妮克希亞的$spell:77827的冷卻時間顯示計時器",
	NefSwipeTimer			= "為奈法利安的$spell:77827的冷卻時間顯示計時器",
	OnyBreathTimer			= "為奧妮克希亞的$spell:77826的冷卻時間顯示計時器",
	NefBreathTimer			= "為奈法利安的$spell:77826的冷卻時間顯示計時器",
	InfoFrame				= "為$journal:3284顯示資訊框架",
	SetWater				= "進入戰鬥後自動停用水體細節<br/>(離開戰鬥後回到啟用)",
	RangeFrame				= "為$spell:79339顯示距離框(10碼)<br/>(當你中減益時顯示所有人, 否則只顯示中的人)"
})

L:SetMiscLocalization({
	NefAoe					= "響起了電流霹啪作響的聲音!",
	YellPhase2 				= "詛咒你們，凡人!如此冷酷地漠視他人的所有物必須受到嚴厲的懲罰!",
	YellPhase3				= "我本來只想略盡地主之誼，但是你們就是不肯痛快的受死!是時候拋下一切的虛偽...殺光你們就好!",
	YellShadowBlaze			= "化為灰燼吧!",
	ShadowBlazeExact		= "暗影炎%d秒",
	ShadowBlazeEstimate		= "暗影炎即將到來(約5秒後)"
})

-------------------------------
--  Blackwing Descent Trash  --
-------------------------------
L = DBM:GetModLocalization("BWDTrash")

L:SetGeneralLocalization({
	name = "黑翼陷窟小怪"
})
