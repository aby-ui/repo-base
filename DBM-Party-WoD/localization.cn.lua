--Mini Dragon(projecteurs@gmail.com)
--Thanks to Yike Xia
--Last update: Dec 4, 2014@11926

if GetLocale() ~= "zhCN" then return end
local L

-----------------------
-- <<<Auchindoun>>> --
-----------------------
-----------------------
-- Protector of Auchindoun --
-----------------------
L= DBM:GetModLocalization(1185)

-----------------------
-- Soulbinder Nyami --
-----------------------
L= DBM:GetModLocalization(1186)

-----------------------
-- Azzakel, Vanguard of the Legion --
-----------------------
L= DBM:GetModLocalization(1216)

-----------------------
-- Teron'gor --
-----------------------
L= DBM:GetModLocalization(1225)

-------------
--  Auch Trash  --
-------------
L = DBM:GetModLocalization("AuchTrash")

L:SetGeneralLocalization({
	name =	"奥金顿小怪"
})

-----------------------
-- <<<Bloodmaul Slag Mines>>> --
-----------------------
-----------------------
-- Magmolatus --
-----------------------
L= DBM:GetModLocalization(893)

-----------------------
-- Slave Watcher Crushto --
-----------------------
L= DBM:GetModLocalization(888)

-----------------------
-- Roltall --
-----------------------
L= DBM:GetModLocalization(887)

-----------------------
-- Gug'rokk --
-----------------------
L= DBM:GetModLocalization(889)

-------------
--  BSM Trash  --
-------------
L = DBM:GetModLocalization("BSMTrash")

L:SetGeneralLocalization({
	name =	"血槌炉渣矿井小怪"
})

-----------------------
-- <<<Grimrail Depot>>> --
-----------------------
-----------------------
-- Railmaster Rocketspark and Borka the Brute --
-----------------------
L= DBM:GetModLocalization(1138)

-----------------------
-- Blackrock Assault Commander --
-----------------------
L= DBM:GetModLocalization(1163)

L:SetWarningLocalization({
	warnGrenadeDown			= "%s出现",
	warnMortarDown			= "%s出现"
})

-----------------------
-- Thunderlord General --
-----------------------
L= DBM:GetModLocalization(1133)

-------------
--  GRD Trash  --
-------------
L = DBM:GetModLocalization("GRDTrash")

L:SetGeneralLocalization({
	name =	"恐轨车站小怪"
})
-----------------------
-- <<<Iron Docks>>> --
-----------------------
---------------------
-- Fleshrender Nok'gar --
---------------------
L= DBM:GetModLocalization(1235)

-------------
-- Grimrail Enforcers --
-------------
L= DBM:GetModLocalization(1236)

-----------------------
-- Oshir --
-----------------------
L= DBM:GetModLocalization(1237)

-----------------------------
-- Skulloc, Son of Gruul --
-----------------------------
L= DBM:GetModLocalization(1238)

-----------------------
-- <<<Overgrown Outpost>>> --
-----------------------
-----------------------
-- Witherbark --
-----------------------
L= DBM:GetModLocalization(1214)

-----------------------
-- Ancient Protectors --
-----------------------
L= DBM:GetModLocalization(1207)

-----------------------
-- Archmage Sol --
-----------------------
L= DBM:GetModLocalization(1208)

-----------------------
-- Xeri'tac --
-----------------------
L= DBM:GetModLocalization(1209)

L:SetMiscLocalization({
	Pull	= "艾里塔克对你放出剧毒小蜘蛛！"
})

-----------------------
-- Yalnu --
-----------------------
L= DBM:GetModLocalization(1210)

-----------------------
-- <<<Shadowmoon Buriel Grounds>>> --
-----------------------
-----------------------
-- Sadana Bloodfury --
-----------------------
L= DBM:GetModLocalization(1139)

-----------------------
-- Nhallish, Feaster of Souls --
-----------------------
L= DBM:GetModLocalization(1168)

-----------------------
-- Bonemaw --
-----------------------
L= DBM:GetModLocalization(1140)

-----------------------
-- Ner'zhul --
-----------------------
L= DBM:GetModLocalization(1160)

-----------------------
-- <<<Skyreach>>> --
-----------------------
-----------------------
-- Ranjit, Master of the Four Winds --
-----------------------
L= DBM:GetModLocalization(965)

-----------------------
-- Araknath --
-----------------------
L= DBM:GetModLocalization(966)

-----------------------
-- Rukhran --
-----------------------
L= DBM:GetModLocalization(967)

-----------------------
-- High Sage Viryx --
-----------------------
L= DBM:GetModLocalization(968)

-----------------------
-- <<<Upper Blackrock Spire>>> --
-----------------------
-----------------------
-- Orebender Gor'ashan --
-----------------------
L= DBM:GetModLocalization(1226)

-----------------------
-- Kyrak --
-----------------------
L= DBM:GetModLocalization(1227)

-----------------------
-- Commander Tharbek --
-----------------------
L= DBM:GetModLocalization(1228)

-----------------------
-- Ragewind the Untamed --
-----------------------
L= DBM:GetModLocalization(1229)

-----------------------
-- Warlord Zaela --
-----------------------
L= DBM:GetModLocalization(1234)

L:SetTimerLocalization({
	timerZaelaReturns	= "扎伊拉回来了！"
})

L:SetOptionLocalization({
	timerZaelaReturns	= "显示扎伊拉返回的计时器"
})

-------------
--  UBRS Trash  --
-------------
L = DBM:GetModLocalization("UBRSTrash")

L:SetGeneralLocalization({
	name =	"黑石塔上层小怪"
})
