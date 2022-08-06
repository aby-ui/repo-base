--local zone = "The Vortex Pinnacle"
local zoneid = 325

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

_G.GridStatusRaidDebuff:DebuffId(zoneid, 87759, 1, 6, 6) --Shockwave
_G.GridStatusRaidDebuff:DebuffId(zoneid, 87930, 1, 6, 6) --Charge
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88182, 1, 6, 6) --Lethargic Poison
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88171, 1, 6, 6) --Hurricane
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88314, 1, 6, 6) --Twisting Winds
_G.GridStatusRaidDebuff:DebuffId(zoneid, 87923, 1, 6, 6) --Wind Blast
_G.GridStatusRaidDebuff:DebuffId(zoneid, 86292, 1, 6, 6) --Cyclone Shield
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88075, 1, 6, 6) --Typhoon
_G.GridStatusRaidDebuff:DebuffId(zoneid, 87771, 1, 6, 6) --Crusader Strike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88175, 1, 6, 6) --Asphyxiate
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76622, 1, 6, 6) --Sunder Armor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88282, 1, 6, 6) --Upwind of Altairus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88010, 1, 6, 6) --Cyclone

--Grand Vizier Ertan
--Cyclone Shield
--Storm's Edge
--Altairus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Altairus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 88308, 21, 6, 6)
--Asaad, Caliph of Zephyrs
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Asaad, Caliph of Zephyrs")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 86930, 31, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 87618, 32, 6, 6)