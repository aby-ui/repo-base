--local zone = "Gate of the Setting Sun"
local zoneid = 399

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Arcurion
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Arcurion")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102582, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103904, 12, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103962, 13, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 104050, 14, 6, 6)
--Asira Dawnslayer
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Asira Dawnslayer")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 102726, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103558, 22, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103790, 23, 6, 6)
--Archbishop Benedictus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Archbishop Benedictus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103151, 31, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103363, 32, 6, 6)