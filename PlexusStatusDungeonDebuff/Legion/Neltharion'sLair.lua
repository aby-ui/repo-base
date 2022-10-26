--local zone = "Neltharion's Lair"
local zoneid = 731

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200154, 1, 6, 6) --Burning Hatred
_G.GridStatusRaidDebuff:DebuffId(zoneid, 202231, 1, 6, 6) --Leech
_G.GridStatusRaidDebuff:DebuffId(zoneid, 192800, 1, 6, 6) --Choking Dust
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193639, 1, 6, 6) --Bone Chomp
_G.GridStatusRaidDebuff:DebuffId(zoneid, 188494, 1, 6, 6) --Rancid Maw
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193941, 1, 6, 6) --Impaling Shard
_G.GridStatusRaidDebuff:DebuffId(zoneid, 183465, 1, 6, 6) --Viscid Bile
_G.GridStatusRaidDebuff:DebuffId(zoneid, 202181, 1, 6, 6) --Stone Gaze
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193585, 1, 6, 6) --Bound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226388, 1, 6, 6) --Rancid Ooze

--Rokmora
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Rokmora")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 215898, 11, 6, 6) --Crystalline Ground



--Ularogg Cragshaper
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Ularogg Cragshaper")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 196562, 21, 6, 6) --Volatile Magic


--Naraxas
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Naraxas")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 217851, 31, 6, 6) --Toxic Retch
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199178, 32, 6, 6) --Spiked Tongue


--Dargrul
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Dargrul")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 200284, 41, 6, 6) --Tangled Web

