-- author: callmejames @《凤凰之翼》 一区藏宝海湾
-- commit by: yaroot <yaroot AT gmail.com>
-- modified by: Diablohu < 178.com / ngacn.cc / dreamgen.cn >


if GetLocale() ~= "zhCN" then return end

local L

------------------------
--  Northrend Beasts  --
------------------------
L = DBM:GetModLocalization("NorthrendBeasts")

L:SetGeneralLocalization{
	name = "诺森德猛兽"
}

L:SetMiscLocalization{
	Charge				= "%%s等着(%S+)，发出一阵震耳欲聋的怒吼！",
	CombatStart			= "他来自风暴峭壁最幽深，最黑暗的洞穴，穿刺者戈莫克！准备战斗，英雄们！",
	Phase2				= "做好准备，英雄们，两头猛兽已经进入了竞技场！它们是酸喉和恐鳞！",
	Phase3				= "当下一名斗士出场时，空气都会为之冻结！它是冰吼，胜或是死，勇士们！",
	Gormok				= "穿刺者戈莫克",
	Acidmaw				= "酸喉",
	Dreadscale			= "恐鳞",
	Icehowl				= "冰吼"
}

L:SetOptionLocalization{
	WarningSnobold			= "为狗头人奴隶出现显示警报",
	ClearIconsOnIceHowl		= "冲锋前清除所有标记",
	TimerNextBoss			= "显示下一场战斗倒计时",
	TimerEmerge			= "显示钻地计时",
	TimerSubmerge			= "显示钻地结束计时",
	IcehowlArrow			= "当冰吼即将向你附近冲锋时显示DBM箭头"
}

L:SetTimerLocalization{
	TimerNextBoss			= "下一场战斗",
	TimerEmerge			= "钻地结束",
	TimerSubmerge			= "钻地"
}

L:SetWarningLocalization{
	WarningSnobold			= "狗头人奴隶 出现了"
}

---------------------
--  Lord Jaraxxus  --
---------------------
L = DBM:GetModLocalization("Jaraxxus")

L:SetGeneralLocalization{
	name = "加拉克苏斯大王"
}

L:SetOptionLocalization{
	IncinerateShieldFrame		= "在首领血量里显示血肉成灰目标的血量"
}

L:SetMiscLocalization{
	IncinerateTarget		= "血肉成灰 -> %s",
	FirstPull			= "大术士威尔弗雷德·菲斯巴恩将会召唤你们的下一个挑战者。等待他的登场吧。"
}

-------------------------
--  Faction Champions  --
-------------------------
L = DBM:GetModLocalization("Champions")

L:SetGeneralLocalization{
	name = "阵营冠军"
}

L:SetMiscLocalization{
	AllianceVictory			= "荣耀归于联盟！",
	HordeVictory			= "那只是让你们知道将来必须面对的命运。为了部落！",
	YellKill			= "肤浅而悲痛的胜利。今天痛失的生命反而令我们更加的颓弱。除了巫妖王之外，谁还能从中获利?伟大的战士失去了宝贵生命。为了什么?真正的威胁就在前方 - 巫妖王在死亡的领域中等着我们。"
} 

---------------------
--  Val'kyr Twins  --
---------------------
L = DBM:GetModLocalization("ValkTwins")

L:SetGeneralLocalization{
	name = "瓦格里双子"
}

L:SetTimerLocalization{
	TimerSpecialSpell		= "下一次 特殊技能"	
}

L:SetWarningLocalization{
	WarnSpecialSpellSoon		= "特殊技能 即将到来",
	SpecWarnSpecial			= "立刻变换颜色",
	SpecWarnSwitchTarget		= "立刻切换目标攻击双生相协",
	SpecWarnKickNow			= "立刻打断",
	WarningTouchDebuff		= "光明或黑暗之触 -> >%s<",
	WarningPoweroftheTwins2		= "双生之能 - 加大治疗 -> >%s<",
	SpecWarnPoweroftheTwins		= "双生之能"
}

L:SetMiscLocalization{
	Fjola 				= "光明邪使菲奥拉",
	Eydis				= "黑暗邪使艾蒂丝"
}

L:SetOptionLocalization{
	TimerSpecialSpell		= "为下一次特殊技能显示计时器",
	WarnSpecialSpellSoon		= "为下一次特殊技能显示提前警报",
	SpecWarnSpecial			= "当你需要变换颜色时显示特殊警报",
	SpecWarnSwitchTarget		= "当另一个首领施放双子相协时显示特殊警报",
	SpecWarnKickNow			= "当你可以打断时显示特殊警报",
	SpecialWarnOnDebuff		= "当你中了光明或黑暗之触时显示特殊警报(需切换颜色)",
	SetIconOnDebuffTarget		= "为光明或黑暗之触的目标设置标记(英雄模式)",
	WarningTouchDebuff		= "提示光明或黑暗之触的目标",
	WarningPoweroftheTwins2		= "提示双生之能的目标",
	SpecWarnPoweroftheTwins		= "当你坦克的首领拥有双生之能时显示特殊警报"
}

-----------------
--  Anub'arak  --
-----------------
L = DBM:GetModLocalization("Anub'arak_Coliseum")

L:SetGeneralLocalization{
	name 				= "阿努巴拉克"
}

L:SetTimerLocalization{
	TimerEmerge			= "钻地结束",
	TimerSubmerge			= "钻地",
	timerAdds			= "下一次 掘地者出现"
}

L:SetWarningLocalization{
	WarnEmerge			= "阿努巴拉克钻出地面了",
	WarnEmergeSoon			= "10秒后 钻出地面",
	WarnSubmerge			= "阿努巴拉克钻进地里了",
	WarnSubmergeSoon		= "10秒后 钻进地里",
	specWarnSubmergeSoon		= "10秒后 钻进地里!",
	warnAdds			= "掘地者 出现了"
}

L:SetMiscLocalization{
	Emerge				= "钻入了地下！",
	Burrow				= "从地面上升起来了！",
	PcoldIconSet			= "刺骨之寒{rt%d} -> %s",
	PcoldIconRemoved		= "移除标记 -> %s"
}

L:SetOptionLocalization{
	WarnEmerge			= "为钻出地面显示警报",
	WarnEmergeSoon			= "为钻出地面显示提前警报",
	WarnSubmerge			= "为钻进地里显示警报",
	WarnSubmergeSoon		= "为钻进地里显示提前警报",
	specWarnSubmergeSoon		= "为即将钻进地里显示特殊警报",
	warnAdds			= "提示掘地者出现",
	timerAdds			= "为下一次掘地者出现显示计时器",
	TimerEmerge			= "为首领钻地显示计时器",
	TimerSubmerge			= "为下一次钻地显示计时器",
	AnnouncePColdIcons		= "公布$spell:68510目标设置的标记到团队频道<br/>(需要团长或助理权限)",
	AnnouncePColdIconsRemoved	= "当移除$spell:68510的标记时也提示<br/>(需要上述选项)"
}
