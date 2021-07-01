--local zone = "Sanguine Depths"
local zoneid = 1675

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Kryxis the Voracious
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Kryxis the Voracious")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 340880, 11, 5, 5) --Prideful

--Executor Tarvold
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Executor Tarvold")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328494, 201, 5, 5) --Sintouched Anima
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322554, 202, 5, 5) --Castigate
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323573, 203, 5, 5) --Residue

--Grand Protector Beryllia
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Grand Protector Beryllia")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328593, 301, 5, 5) --Agonize
_G.GridStatusRaidDebuff:DebuffId(zoneid, 325885, 302, 5, 5) --Anguished Cries
_G.GridStatusRaidDebuff:DebuffId(zoneid, 325254, 303, 5, 5) --Iron Spikes

--General Kaal
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "General Kaal")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 331415, 401, 5, 5) --Wicked Gash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323845, 402, 5, 5) --Wicked Rush
