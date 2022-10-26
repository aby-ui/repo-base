--local zone = "The Arcway"
local zoneid = 749

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 210645, 1, 6, 6) --Arcanic Bane
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211756, 1, 6, 6) --Searing Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226269, 1, 6, 6) --Torment
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211125, 1, 6, 6) --Parallel Dimension
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211000, 1, 6, 6) --Nether Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211543, 1, 6, 6) --Devour
_G.GridStatusRaidDebuff:DebuffId(zoneid, 202156, 1, 6, 6) --Corrosion
_G.GridStatusRaidDebuff:DebuffId(zoneid, 210750, 1, 6, 6) --Collapsing Rift
_G.GridStatusRaidDebuff:DebuffId(zoneid, 210684, 1, 6, 6) --Siphon Essence
_G.GridStatusRaidDebuff:DebuffId(zoneid, 203592, 1, 6, 6) --Black Plague
_G.GridStatusRaidDebuff:DebuffId(zoneid, 202232, 1, 6, 6) --Consume
_G.GridStatusRaidDebuff:DebuffId(zoneid, 194006, 1, 6, 6) --Ooze Puddle

--Corstilax
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Corstilax")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196074, 11, 6, 6) --Suppression Protocol
_G.GridStatusRaidDebuff:DebuffId(zoneid, 195804, 12, 6, 6) --Quarantine
_G.GridStatusRaidDebuff:DebuffId(zoneid, 220500, 13, 6, 6) --Destabilized Orb


--Ivanyr
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Ivanyr")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196562, 21, 6, 6) --Volatile Magic


--General Xakal
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "General Xakal")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 153234, 31, 6, 6)


--Nal'tira
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Nal'tira")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200284, 41, 6, 6) --Tangled Web
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200040, 42, 6, 6) --Nether Venom

--Advisor Vandros
_G.GridStatusRaidDebuff:BossNameId(zoneid, 50, "Advisor Vandros")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 203914, 51, 6, 6) --Banished In Time
_G.GridStatusRaidDebuff:DebuffId(zoneid, 203139, 52, 6, 6) --Force Nova
