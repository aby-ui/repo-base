--local zone = "Mists of Tirna Scithe"
local zoneid = 1669

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Ingra Maloch
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Ingra Maloch")
GridStatusRaidDebuff:DebuffId(zoneid, 323146, 101, 5, 5) --Death Shroud
GridStatusRaidDebuff:DebuffId(zoneid, 328756, 102, 5, 5) --Repulsive Visage
GridStatusRaidDebuff:DebuffId(zoneid, 323250, 103, 5, 5) --Anima Puddle

--Mistcaller
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Mistcaller")
GridStatusRaidDebuff:DebuffId(zoneid, 321891, 201, 4, 4) --Freeze Tag Fixation
GridStatusRaidDebuff:DebuffId(zoneid, 321893, 202, 5, 5) --Freezing Burst

--Tred'ova
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Tred'ova")
GridStatusRaidDebuff:DebuffId(zoneid, 322563, 301, 5, 5) --Marked Prey
GridStatusRaidDebuff:DebuffId(zoneid, 322648, 302, 5, 5) --Mind Link
GridStatusRaidDebuff:DebuffId(zoneid, 326309, 303, 5, 5) --Decomposing Acid
