if GetLocale() ~= "zhTW" then return end
local L

--------------
--  Onyxia  --
--------------
L = DBM:GetModLocalization("Onyxia")

L:SetGeneralLocalization{
	name = "奧妮克希亞"
}

L:SetWarningLocalization{
	WarnWhelpsSoon		= "奧妮克希亞幼龍即將出現"
}

L:SetTimerLocalization{
	TimerWhelps 		= "奧妮克希亞幼龍"
}

L:SetOptionLocalization{
	TimerWhelps		= "為奧妮克希亞幼龍顯示計時器",
	WarnWhelpsSoon	= "為奧妮克希亞幼龍顯示預先警告",
	SoundWTF3		= "為經典傳奇式奧妮克希亞副本播放一些有趣的音效"
}

L:SetMiscLocalization{
	YellPull = "真是幸運。通常我為了覓食就必須離開窩。",
	YellP2 	= "這毫無意義的行動讓我很厭煩。我會從上空把你們都燒成灰!",
	YellP3 	= "看起來需要再給你一次教訓，凡人!"
}