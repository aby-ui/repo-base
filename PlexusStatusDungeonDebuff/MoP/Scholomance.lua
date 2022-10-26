--local zone = "Scholomance"
local zoneid = 476

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Instructor Chillheart
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Instructor Chillheart")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111631, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111610, 12, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 51498, 13, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 32860, 14, 6, 6)
--Jandice Barov
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Jandice Barov")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 114035, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 113775, 22, 6, 6)
--Rattlegore
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Rattlegore")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 114007, 31, 6, 6)
--Lilian Voss
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Lilian Voss")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111585, 41, 6, 6)
--Darkmaster Gandling
_G.GridStatusRaidDebuff:BossNameId(zoneid, 50, "Darkmaster Gandling")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 348, 51, 6, 6)