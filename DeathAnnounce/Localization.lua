--[[---------------------------------------------------------------------------------
    Localisation for ruRU and others  Any commented lines need to be updated
----------------------------------------------------------------------------------]]

if (GetLocale() == "zhCN" ) then
	DEATH_ANNOUNCE_LOCALE_DIE                    = " 挂了。";
	DEATH_ANNOUNCE_LOCALE_ENABLE                 = "发送";
	DEATH_ANNOUNCE_LOCALE_DISABLE                = "不发送";

    DEATH_ANNOUNCE_LOCALE_Drowning               = "溺水";
    DEATH_ANNOUNCE_LOCALE_Falling                = "跌落";
    DEATH_ANNOUNCE_LOCALE_Fatigue                = "疲劳";
    DEATH_ANNOUNCE_LOCALE_Fire                   = "篝火";
    DEATH_ANNOUNCE_LOCALE_Lava                   = "岩浆";
    DEATH_ANNOUNCE_LOCALE_Slime                  = "软泥";
else
	DEATH_ANNOUNCE_LOCALE_DIE                    = " dies. ";
	DEATH_ANNOUNCE_LOCALE_ENABLE                 = "enabled";
	DEATH_ANNOUNCE_LOCALE_DISABLE                = "disabled";
end
