-- Simplified Chinese by Diablohu(diablohudream@gmail.com)
-- Last update: 9/18/2011

if GetLocale() ~= "zhCN" then return end

local L

-------------------------------
--  Dark Iron Golem Council  --
-------------------------------
L = DBM:GetModLocalization(169)

L:SetWarningLocalization({
	SpecWarnActivated			= "更换目标 -> %s!",
	specWarnGenerator			= "能量发生器 - 移动%s!"
})

L:SetTimerLocalization({
	timerShadowConductorCast	= "暗影导体",
	timerArcaneLockout			= "奥术歼灭者反制",
	timerArcaneBlowbackCast		= "奥术反冲",
	timerNefAblity				= "技能增强冷却"
})

L:SetOptionLocalization({
	timerShadowConductorCast	= "计时条：$spell:92048施法时间",
	timerArcaneLockout			= "计时条：$spell:91542反制时间",
	timerArcaneBlowbackCast		= "计时条：$spell:91879施法时间",
	timerNefAblity				= "计时条：英雄模式增益法术冷却时间",
	SpecWarnActivated			= "特殊警报：新的金刚已激活",
	specWarnGenerator			= "特殊警报：金刚获得$spell:91557效果",
	AcquiringTargetIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79501),
	ConductorIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79888),
	ShadowConductorIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92053),
	SetIconOnActivated			= "自动为最新激活的金刚添加团队标记"
})

L:SetMiscLocalization({
	YellTargetLock				= "暗影包围！远离我！"
})

--------------
--  Magmaw  --
--------------
L = DBM:GetModLocalization(170)

L:SetWarningLocalization({
	SpecWarnInferno	= "炽焰白骨结构体即将出现（约4秒）"
})

L:SetOptionLocalization({
	SpecWarnInferno	= "特殊警报：$spell:92190即将施放（约4秒）",
	RangeFrame		= "在第2阶段显示距离监视器（5码）"
})

L:SetMiscLocalization({
	Slump			= "%s向前倒下，暴露出他的钳子！",
	HeadExposed		= "%s将自己钉在刺上，露出了他的头！",
	YellPhase2		= "难以置信，你们竟然真要击败我的熔岩巨虫了！也许我可以帮你们……扭转局势。"
})

-----------------
--  Atramedes  --
-----------------
L = DBM:GetModLocalization(171)

L:SetOptionLocalization({
	InfoFrame				= "信息框：团员声音等级列表",
	TrackingIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(78092)
})

L:SetMiscLocalization({
	NefAdd					= "艾卓曼德斯，那些英雄就在那边！",
	Airphase				= "对，跑吧！每跑一步你的心跳都会加快。这心跳声，洪亮如雷，震耳欲聋。你逃不掉的！"
})

-----------------
--  Chimaeron  --
-----------------
L = DBM:GetModLocalization(172)

L:SetOptionLocalization({
	RangeFrame		= "距离监视器（6码）",
	SetIconOnSlime	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(82935),
	InfoFrame		= "信息框：生命值小于1万的团员的列表"
})

L:SetMiscLocalization({
	HealthInfo	= "生命值"
})

----------------
--  Maloriak  --
----------------
L = DBM:GetModLocalization(173)

L:SetWarningLocalization({
	WarnPhase			= "%s阶段",
})

L:SetTimerLocalization({
	TimerPhase			= "下一阶段"
})

L:SetOptionLocalization({
	WarnPhase			= "警报：阶段变化",
	TimerPhase			= "计时条：下一阶段",
	RangeFrame			= "在蓝瓶阶段显示距离监视器（6码）",
	SetTextures			= "在黑暗阶段自动取消材质投射效果（当阶段结束时会自动恢复）",
	FlashFreezeIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(92979),
	BitingChillIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(77760),
	ConsumingFlamesIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(77786)
})

L:SetMiscLocalization({
	YellRed				= "红瓶|r扔进了大锅里！",--Partial matchs, no need for full strings unless you really want em, mod checks for both.
	YellBlue			= "蓝瓶|r扔进了大锅里！",
	YellGreen			= "绿瓶|r扔进了大锅里！",
	YellDark			= "黑暗|r魔法！"
})

----------------
--  Nefarian  --
----------------
L = DBM:GetModLocalization(174)

L:SetWarningLocalization({
	OnyTailSwipe			= "龙尾扫击（奥妮克希亚）",
	NefTailSwipe			= "龙尾扫击（奈法利安）",
	OnyBreath				= "暗影烈焰吐息（奥妮克希亚）",
	NefBreath				= "暗影烈焰吐息（奈法利安）",
	specWarnShadowblazeSoon	= "%s",
	warnShadowblazeSoon		= "%s"
})

L:SetTimerLocalization({
	timerNefLanding			= "奈法利安着陆",
	OnySwipeTimer			= "龙尾扫击冷却（奥妮克希亚）",
	NefSwipeTimer			= "龙尾扫击冷却（奈法利安）",
	OnyBreathTimer			= "吐息冷却（奥妮克希亚）",
	NefBreathTimer			= "吐息冷却（奈法利安）"
})

L:SetOptionLocalization({
	OnyTailSwipe			= "警报：奥妮克希亚的$spell:77827",
	NefTailSwipe			= "警报：奈法利安的$spell:77827",
	OnyBreath				= "警报：奥妮克希亚的$spell:94124",
	NefBreath				= "警报：奈法利安的$spell:94124",
	specWarnCinderMove		= "特殊警报：当你受到$spell:79339影响需要移动时（爆炸前5秒）",
	warnShadowblazeSoon		= "提前警报：$spell:81031（5秒）（为保证精确性，仅当暗影爆燃时间同步后才会显示确切时间警报）",
	specWarnShadowblazeSoon	= "特殊警报：$spell:81031即将施放（为保证精确性，第一次<br/>提前5秒，在暗影爆燃时间同步后提前1秒警报）",
	timerNefLanding			= "计时条：奈法利安着陆",
	OnySwipeTimer			= "计时条：奥妮克希亚的$spell:77827冷却时间",
	NefSwipeTimer			= "计时条：奈法利安的$spell:77827冷却时间",
	OnyBreathTimer			= "计时条：奥妮克希亚的$spell:94124冷却时间",
	NefBreathTimer			= "计时条：奈法利安的$spell:94124冷却时间",
	InfoFrame				= "信息框：奥妮克希亚的电能",
	SetWater				= "在拉怪时自动取消水体碰撞效果（战斗结束后会自动恢复）",
	SetIconOnCinder			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(79339),
	RangeFrame				= "为$spell:79339显示距离监视器（10码）",-- Shows everyone if you have debuff, only players with icons if not
	FixShadowblaze        = "自动同步$spell:94085时间（实验功能，利用首领的喊话进行同步）",	
})

L:SetMiscLocalization({
	NefAoe					= "空气中激荡的电流噼啪作响！",
	YellPhase2				= "诅咒你们，凡人！你们丝毫不尊重他人财产的行为必须受到严厉处罚！",
	YellPhase3				= "我一直在尝试扮演好客的主人，可你们就是不肯受死！该卸下伪装了……杀光你们！",
	YellShadowBlaze			= "血肉化为灰烬！",
	ShadowBlazeExact		= "%d秒后暗影爆燃火花",
	ShadowBlazeEstimate		= "暗影爆燃火花即将施放（约5秒）"
})

-------------------------------
--  Blackwing Descent Trash  --
-------------------------------
L = DBM:GetModLocalization("BWDTrash")

L:SetGeneralLocalization({
	name = "黑翼血环小怪"
})
