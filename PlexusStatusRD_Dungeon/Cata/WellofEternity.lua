--local zone = "Gate of the Setting Sun"
local zoneid = 398

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Peroth'arn
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Peroth'arn")
--Corrupting Touch
_G.GridStatusRaidDebuff:DebuffId(zoneid, 108141, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 105544, 12, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 104905, 13, 6, 6)
--Easy Prey
--Queen Azshara
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Queen Azshara")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103241, 21, 6, 6)
--Coldflame
--Firebomb
--Mannoroth and Varo'then
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Mannoroth and Varo'then")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 103888, 31, 6, 6)
--Aura of Immolation