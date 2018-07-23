if GetLocale() ~= "zhCN" then return end

local L

----------------------
--  Lord Marrowgar  --
----------------------
L = DBM:GetModLocalization("LordMarrowgar")

L:SetGeneralLocalization{
	name = "玛洛加尔领主"
}

-------------------------
--  Lady Deathwhisper  --
-------------------------
L = DBM:GetModLocalization("Deathwhisper")

L:SetGeneralLocalization{
	name = "亡语者女士"
}

L:SetTimerLocalization{
	TimerAdds	= "新的小怪"
}

L:SetWarningLocalization{
	WarnReanimating	= "小怪再活化",
	WarnAddsSoon	= "新的小怪即将到来"
}

L:SetOptionLocalization{
	WarnAddsSoon		= "为新的小怪出现显示预先警告",
	WarnReanimating		= "当小怪再活化时显示警告",
	TimerAdds			= "为新的小怪显示计时器"
}

L:SetMiscLocalization{
	YellReanimatedFanatic	= "起来，在纯粹的形态中感受狂喜!",
	Fanatic1				= "神教狂热者",
	Fanatic2				= "畸形的狂热者",
	Fanatic3				= "再活化的狂热者"
}

----------------------
--  Gunship Battle  --
----------------------
L = DBM:GetModLocalization("GunshipBattle")

L:SetGeneralLocalization{
	name = "炮艇战"
}

L:SetWarningLocalization{
	WarnAddsSoon	= "新的小怪即将到来"
}

L:SetOptionLocalization{
	WarnAddsSoon		= "为新的小怪出现显示预先警告",
	TimerAdds			= "为新的小怪显示计时器"
}

L:SetTimerLocalization{
	TimerAdds			= "新的小怪"
}

L:SetMiscLocalization{
	PullAlliance	= "发动引擎!小伙子们，我们即将面对命运啦!",
	KillAlliance	= "別说我没警告过你，无赖!兄弟姐妹们，向前冲!",
	PullHorde		= "起来吧，部落的儿女!今天我们要和最可恨的敌人作战!为了部落!",
	KillHorde		= "联盟已经动摇了。向巫妖王前进!",
	AddsAlliance	= "掠夺者，士官们，攻击!",
	AddsHorde		= "海員们，士官们，攻击!",
	MageAlliance	= "船体受到伤害，找个战斗法师到来，搞定那些火炮!",
	MageHorde		= "船体受损，找个巫士到这里来，搞定那些火炮!"
}

-----------------------------
--  Deathbringer Saurfang  --
-----------------------------
L = DBM:GetModLocalization("Deathbringer")

L:SetGeneralLocalization{
	name = "死亡使者萨鲁法尔"
}

L:SetOptionLocalization{
	RangeFrame				= "显示距离框 (12码)",
	RunePowerFrame			= "显示首领血量及$spell:72371条"
}

L:SetMiscLocalization{
	RunePower			= "血魄威能",
	PullAlliance		= "每个你杀死的部落士兵 -- 每条死去的联盟狗，都让巫妖王的军队随之增长。此时此刻瓦基里安都还在把你们倒下的同伴复活成天谴军。",
	PullHorde			= "柯尔克隆，前进!勇士们，要当心，天谴军团已经..."
}

-----------------
--  Festergut  --
-----------------
L = DBM:GetModLocalization("Festergut")

L:SetGeneralLocalization{
	name = "烂肠"
}

L:SetOptionLocalization{
	RangeFrame			= "显示距离框 (8码)",
	AnnounceSporeIcons	= "公布$spell:69279目标设置的标记到团队频道<br/>(需要团队队长)",
	AchievementCheck	= "公布 '流感疫苗短缺' 成就失败到团队频道<br/>(需助理权限)"
}

L:SetMiscLocalization{
	SporeSet			= "气体孢子{rt%d}: %s",
	AchievementFailed	= ">> 成就失败: %s中了%d层孢子 <<"
}

---------------
--  Rotface  --
---------------
L = DBM:GetModLocalization("Rotface")

L:SetGeneralLocalization{
	name = "腐面"
}

L:SetWarningLocalization{
	WarnOozeSpawn		= "小软泥怪出现了",
	SpecWarnLittleOoze	= "你被小软泥怪盯上了 - 快跑开"
}


L:SetOptionLocalization{
	WarnOozeSpawn		= "为小软泥的出现显示警告",
	SpecWarnLittleOoze	= "当你被小软泥怪盯上时显示特別警告",
	RangeFrame			= "显示距离框(8码)"
}

L:SetMiscLocalization{
	YellSlimePipes1	= "大伙听着，好消息!我修好了剧毒软泥管!",
	YellSlimePipes2	= "大伙听着，超級好消息!软泥又开始流动了!"
}

---------------------------
--  Professor Putricide  --
---------------------------
L = DBM:GetModLocalization("Putricide")

L:SetGeneralLocalization{
	name 				= "普崔塞德教授"
}

L:SetOptionLocalization{
	MalleableGooIcon	= "为第一个中$spell:72295的目标设置标记"
}

----------------------------
--  Blood Prince Council  --
----------------------------
L = DBM:GetModLocalization("BPCouncil")

L:SetGeneralLocalization{
	name = "血王子议会"
}

L:SetWarningLocalization{
	WarnTargetSwitch		= "转换目标到: %s",
	WarnTargetSwitchSoon	= "转换目标即将到来"
}

L:SetTimerLocalization{
	TimerTargetSwitch		= "转换目标"
}

L:SetOptionLocalization{
	WarnTargetSwitch		= "为转换目标显示警告",
	WarnTargetSwitchSoon	= "为转换目标显示预先警告",
	TimerTargetSwitch		= "为转换目标显示冷却计时器",
	ActivePrinceIcon		= "设置标记在強化的亲王身上(头颅)",
	RangeFrame				= "显示距离框(12码)"
}

L:SetMiscLocalization{
	Keleseth			= "凯雷塞斯王子",
	Taldaram			= "塔达拉姆王子",
	Valanar				= "瓦拉纳王子",
	EmpoweredFlames		= "地狱烈焰加速靠近(%S+)!"
}

-----------------------------
--  Blood-Queen Lana'thel  --
-----------------------------
L = DBM:GetModLocalization("Lanathel")

L:SetGeneralLocalization{
	name = "鲜血女王兰娜瑟尔"
}

L:SetOptionLocalization{
	RangeFrame			= "显示距离框(8码)"
}

L:SetMiscLocalization{
	SwarmingShadows		= "暗影聚集並欢绕在(%S+)四周!",
	YellFrenzy			= "我饿了!"
}

-----------------------------
--  Valithria Dreamwalker  --
-----------------------------
L = DBM:GetModLocalization("Valithria")

L:SetGeneralLocalization{
	name = "踏梦者瓦莉瑟瑞娅"
}

L:SetWarningLocalization{
	WarnPortalOpen			= "传送门开启"
}

L:SetTimerLocalization{
	TimerPortalsOpen		= "传送门开启",
	TimerBlazingSkeleton	= "下一次炽热骷髅",
	TimerAbom				= "下一次憎恶体"
}

L:SetOptionLocalization{
	SetIconOnBlazingSkeleton	= "为炽热骷髅设置标记(头颅)",
	WarnPortalOpen				= "当梦魇之门开启时显示警告",
	TimerPortalsOpen			= "当梦魇之门开启时显示计时器",
	TimerBlazingSkeleton		= "为下一次炽热骷髅出现显示计时器",
	TimerAbom					= "为下一次贪吃的憎恶体出现显示计时器"
}

L:SetMiscLocalization{
	YellPull			= "入侵者已经突破了內部圣所。加快摧毀綠龍的速度!只要留下骨头和肌腱来复活!",
	YellKill			= "我重生了!伊瑟拉賦予我让那些邪恶生物安眠的力量!",
	YellPortals			= "我打开了一道传送门通往梦境。你们的救赎就在其中，英雄们..."
}

------------------
--  Sindragosa  --
------------------
L = DBM:GetModLocalization("Sindragosa")

L:SetGeneralLocalization{
	name = "辛达苟萨"
}

L:SetWarningLocalization{
	WarnAirphase			= "空中阶段",
	WarnGroundphaseSoon		= "辛达苟萨 即将着陆"
}

L:SetTimerLocalization{
	TimerNextAirphase		= "下一次空中阶段",
	TimerNextGroundphase	= "下一次地上阶段",
	AchievementMystic		= "清除秘能连击叠加"
}

L:SetOptionLocalization{
	WarnAirphase			= "提示空中阶段",
	WarnGroundphaseSoon		= "为地上阶段显示预先警告",
	TimerNextAirphase		= "为下一次 空中阶段显示计时器",
	TimerNextGroundphase	= "为下一次 地上阶段显示计时器",
	AnnounceFrostBeaconIcons= "公布$spell:70126目标设置的标记到团队频道<br/>(需要团队队长)",
	ClearIconsOnAirphase	= "空中阶段前清除所有标记",
	AchievementCheck		= "公布 '吃到饱' 成就警告到团队频道<br/>(需助理权限)",
	RangeFrame				= "根据最后首领使用的技能跟玩家减益显示动态距离框(10/20码)"
}

L:SetMiscLocalization{
	YellAirphase		= "你们的入侵将在此终止!谁也別想存活!",
	YellPhase2			= "现在，绝望地感受我主无限的力量吧!",
	YellAirphaseDem		= "Rikk zilthuras rikk zila Aman adare tiriosh ",--Demonic, since curse of tonges is used by some guilds and it messes up yell detection.
	YellPhase2Dem		= "Zar kiel xi romathIs zilthuras revos ruk toralar ",--Demonic, since curse of tonges is used by some guilds and it messes up yell detection.
	BeaconIconSet		= "冰霜信标{rt%d}: %s",
	AchievementWarning	= "警告: %s中了5层秘能连击",
	AchievementFailed	= ">> 成就失败: %s中了%d层秘能连击 <<"
}

---------------------
--  The Lich King  --
---------------------
L = DBM:GetModLocalization("LichKing")

L:SetGeneralLocalization{
	name 				= "巫妖王"
}

L:SetWarningLocalization{
	ValkyrWarning			= ">%s< 被抓住了!",
	SpecWarnYouAreValkd		= "你被抓住了",
	WarnNecroticPlagueJump	= "亡域瘟疫跳到>%s<身上",
	SpecWarnValkyrLow		= "瓦基里安血量低于55%"
}

L:SetTimerLocalization{
	TimerRoleplay		= "角色扮演",
	PhaseTransition		= "转换阶段",
	TimerNecroticPlagueCleanse 	= "净化亡域瘟疫"
}

L:SetOptionLocalization{
	TimerRoleplay			= "为角色扮演事件显示计时器",
	WarnNecroticPlagueJump	= "提示$spell:73912跳跃后的目标",
	TimerNecroticPlagueCleanse	= "为净化第一次堆叠前的亡域瘟疫显示计时器",
	PhaseTransition			= "为转换阶段显示计时器",
	ValkyrWarning			= "提示谁给瓦基里安影卫抓住了",
	SpecWarnYouAreValkd		= "当你给瓦基里安影卫抓住时显示特別警告",
	AnnounceValkGrabs		= "提示谁被瓦基里安影卫抓住到团队频道<br/>(需开启团队广播及助理权限)",
	SpecWarnValkyrLow		= "当瓦基里安血量低于55%时显示特別警告",
	AnnouncePlagueStack		= "提示$spell:73912层数到团队频道 (10层, 10层后每5层提示一次)<br/>(需开启助理权限)"
}

L:SetMiscLocalization{
	LKPull					= "圣光所谓的正义终于来了吗?我是否该把霜之哀伤放下，祈求你的宽恕呢，弗丁?",
	LKRoleplay				= "你们的原动力真的是正义感吗?我很怀疑...",
	ValkGrabbedIcon			= "瓦基里安影卫{rt%d}抓住了%s",
	ValkGrabbed				= "瓦基里安影卫抓住了%s",
	PlagueStackWarning		= "警告: %s中了%d层亡域瘟疫",
	AchievementCompleted	= ">> 成就成功: %s中了%d层亡域瘟疫 <<"
}

-------------
--  Trash  --
-------------
L = DBM:GetModLocalization("ICCTrash")

L:SetGeneralLocalization{
	name = "Icecrown Trash"
}

L:SetWarningLocalization{
	SpecWarnTrapL		= "触发陷阱! - 亡缚守卫被释放了",
	SpecWarnTrapP		= "触发陷阱! - 复仇的血肉收割者到来",
	SpecWarnGosaEvent	= "辛达苟萨夹道攻击开始!"
}

L:SetOptionLocalization{
	SpecWarnTrapL		= "当触发陷阱时显示特別警告",
	SpecWarnTrapP		= "当触发陷阱时显示特別警告",
	SpecWarnGosaEvent	= "为辛达苟萨夹道攻击显示特別警告"
}

L:SetMiscLocalization{
	WarderTrap1			= "谁...在那儿...?",
	WarderTrap2			= "我...更醒了!",
	WarderTrap3			= "主人的圣所受到了打扰!",
	FleshreaperTrap1	= "快，我们要从后面奇袭他们!",
	FleshreaperTrap2	= "你无法逃避我们!",
	FleshreaperTrap3	= "活人? 这儿?!",
	SindragosaEvent		= "你一定不能靠近冰霜之后。快，阻止他们!"
}
