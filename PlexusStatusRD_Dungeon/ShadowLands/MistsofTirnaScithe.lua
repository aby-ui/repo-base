--local zone = "Mists of Tirna Scithe"
local zoneid = 1669

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Ingra Maloch
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Ingra Maloch")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323146, 101, 5, 5) --Death Shroud
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328756, 102, 5, 5) --Repulsive Visage
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323250, 103, 5, 5) --Anima Puddle

--Mistcaller
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Mistcaller")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 321891, 201, 4, 4) --Freeze Tag Fixation
_G.GridStatusRaidDebuff:DebuffId(zoneid, 321893, 202, 5, 5) --Freezing Burst

--Tred'ova
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Tred'ova")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322563, 301, 5, 5) --Marked Prey
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322648, 302, 5, 5) --Mind Link
_G.GridStatusRaidDebuff:DebuffId(zoneid, 326309, 303, 5, 5) --Decomposing Acid
