-- author: callmejames @《凤凰之翼》 一区藏宝海湾
-- commit by: yaroot <yaroot AT gmail.com>
-- Mini Dragon(projecteurs AT gmail.com) Brilla@金色平原
-- Last update: 2019/08/22

if GetLocale() ~= "zhCN" then return end

local L

--------------
--  Onyxia  --
--------------
L = DBM:GetModLocalization("Onyxia")

L:SetGeneralLocalization{
	name 			= "奥妮克希亚"
}

L:SetWarningLocalization{
	WarnWhelpsSoon		= "奥妮克希亚雏龙 即将出现"
}

L:SetTimerLocalization{
	TimerWhelps 		= "奥妮克希亚雏龙"
}

L:SetOptionLocalization{
	TimerWhelps			= "为奥妮克希亚雏龙显示计时条",
	WarnWhelpsSoon		= "为奥妮克希亚雏龙显示预警",
	SoundWTF3			= "为经典传奇式奥妮克希亚副本播放一些有趣的音效"
}

L:SetMiscLocalization{
	YellPull 		= "真是走运。通常我必须离开窝才能找到食物。",
	YellP2 			= "这毫无意义的行动让我很厌烦。我会从上空把你们都烧成灰！",
	YellP3 			= "看起来需要再给你一次教训，凡人！"
}
