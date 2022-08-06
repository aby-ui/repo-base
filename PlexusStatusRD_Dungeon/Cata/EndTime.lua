--local zone = "End Time"
local zoneid = 404

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

_G.GridStatusRaidDebuff:DebuffId(zoneid, 102066, 1, 6, 6) --Flesh Rip
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101984, 1, 6, 6) --Distortion Bomb
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102414, 1, 6, 6) --Dark Moonlight
_G.GridStatusRaidDebuff:DebuffId(zoneid, 277373, 1, 6, 6) --Massive Glaive
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101619, 1, 6, 6) --Magma
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102057, 1, 6, 6) --Scorched
_G.GridStatusRaidDebuff:DebuffId(zoneid, 109952, 1, 6, 6) --Cadaver Toss
_G.GridStatusRaidDebuff:DebuffId(zoneid, 108589, 1, 6, 6) --Tail Sweep
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101840, 1, 6, 6) --Molten Blast
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102158, 1, 6, 6) --Sear Flesh
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102132, 1, 6, 6) --Break Armor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102600, 1, 6, 6) --Temporal Vortex

--Echo of Baine
--Echo of Jaina
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Echo of Jaina")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101339, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101810, 12, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101809, 13, 6, 6)
--Echo of Sylvanas
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Echo of Sylvanas")
--Wracking Pain
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101412, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101411, 22, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 101401, 23, 6, 6)
--Echo of Tyrande
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Echo of Tyrande")
--Dark Moonlight
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102151, 31, 6, 6)
--Piercing Gaze of Elune
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102241, 32, 6, 6)
--Murozond
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Murozond")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102381, 41, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102569, 42, 6, 6)