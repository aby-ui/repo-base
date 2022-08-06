--local zone = "Maw of Souls"
local zoneid = 706

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194674, 1, 6, 6) --Barbed Spear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200208, 1, 6, 6) --Brackwater Blast
_G.GridStatusRaidDebuff:DebuffId(zoneid, 195279, 1, 6, 6) --Bind
_G.GridStatusRaidDebuff:DebuffId(zoneid, 185539, 1, 6, 6) --Rapid Rupture
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194640, 1, 6, 6) --Curse of Hope
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198374, 1, 6, 6) --Hamstring
_G.GridStatusRaidDebuff:DebuffId(zoneid, 225778, 1, 6, 6) --Backlash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194099, 1, 6, 6) --Bile Breath
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199185, 1, 6, 6) --Ravenous Bite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198944, 1, 6, 6) --Breach Armor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194102, 1, 6, 6) --Poisonous Sludge
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194657, 1, 6, 6) --Soul Siphon
_G.GridStatusRaidDebuff:DebuffId(zoneid, 201566, 1, 6, 6) --Swirling Muck

--Ymiron, the Fallen King
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Ymiron, the Fallen King")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 153480, 11, 6, 6)


--Harbaron
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Harbaron")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194327, 21, 6, 6) --Fragment
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194235, 22, 6, 6) --Nether Rip


--Helya
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Helya")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 197262, 31, 6, 6) --Taint of the Sea
