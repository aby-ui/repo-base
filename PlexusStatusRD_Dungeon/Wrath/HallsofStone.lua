--local zone = "Halls of Stone
local zoneid = 140

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

_G.GridStatusRaidDebuff:DebuffId(zoneid, 46202, 1, 6, 6) --Pierce Armor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 50895, 1, 6, 6) --Lightning Tether
_G.GridStatusRaidDebuff:DebuffId(zoneid, 50761, 1, 6, 6) --Pillar of Woe
_G.GridStatusRaidDebuff:DebuffId(zoneid, 50834, 1, 6, 6) --Static Charge
_G.GridStatusRaidDebuff:DebuffId(zoneid, 50841, 1, 6, 6) --Lightning Ring
_G.GridStatusRaidDebuff:DebuffId(zoneid, 51491, 1, 6, 6) --Unrelenting Strike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 51496, 1, 6, 6) --Chiseling Ray
_G.GridStatusRaidDebuff:DebuffId(zoneid, 50760, 1, 6, 6) --Shock of Sorrow