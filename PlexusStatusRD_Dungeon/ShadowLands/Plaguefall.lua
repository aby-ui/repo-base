--local zone = "Plaguefall"
local zoneid = 1674

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Globgrog
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Globgrog")
GridStatusRaidDebuff:DebuffId(zoneid, 324652, 101, 5, 5) --Debilitating Plague
GridStatusRaidDebuff:DebuffId(zoneid, 326242, 102, 5, 5) --Slime Wave
GridStatusRaidDebuff:DebuffId(zoneid, 330069, 103, 5, 5, nil, true) --Concentrated Plague

--Doctor Ickus
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Doctor Ickus")
GridStatusRaidDebuff:DebuffId(zoneid, 330069, 201, 5, 5, nil, true) --Concentrated Plague
GridStatusRaidDebuff:DebuffId(zoneid, 329110, 202, 5, 5, nil, true) --Slime Injection
GridStatusRaidDebuff:DebuffId(zoneid, 322358, 203, 5, 5, nil, true) --Burning Strain
GridStatusRaidDebuff:DebuffId(zoneid, 322410, 204, 5, 5) --Withering Filth

--Domina Venomblade
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Domina Venomblade")
GridStatusRaidDebuff:DebuffId(zoneid, 333406, 301, 5, 5) --Assassinate
GridStatusRaidDebuff:DebuffId(zoneid, 325552, 302, 5, 5) --Cytotoxic Slash
GridStatusRaidDebuff:DebuffId(zoneid, 331818, 303, 5, 5) --Shadow Ambush
GridStatusRaidDebuff:DebuffId(zoneid, 332397, 304, 5, 5) --Shroudweb

--Stradama Margrave
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Stradama Margrave")
GridStatusRaidDebuff:DebuffId(zoneid, 331399, 401, 5, 5, nil, true) --Infectios Rain
GridStatusRaidDebuff:DebuffId(zoneid, 330135, 402, 5, 5) --Fount of Pestilence
