--local zone = "Plaguefall"
local zoneid = 1674

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Globgrog
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Globgrog")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 324652, 101, 5, 5) --Debilitating Plague
_G.GridStatusRaidDebuff:DebuffId(zoneid, 326242, 102, 5, 5) --Slime Wave
_G.GridStatusRaidDebuff:DebuffId(zoneid, 330069, 103, 5, 5, nil, true) --Concentrated Plague

--Doctor Ickus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Doctor Ickus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 330069, 201, 5, 5, nil, true) --Concentrated Plague
_G.GridStatusRaidDebuff:DebuffId(zoneid, 329110, 202, 5, 5, nil, true) --Slime Injection
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322358, 203, 5, 5, nil, true) --Burning Strain
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322410, 204, 5, 5) --Withering Filth

--Domina Venomblade
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Domina Venomblade")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333406, 301, 5, 5) --Assassinate
_G.GridStatusRaidDebuff:DebuffId(zoneid, 325552, 302, 5, 5) --Cytotoxic Slash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 331818, 303, 5, 5) --Shadow Ambush
_G.GridStatusRaidDebuff:DebuffId(zoneid, 332397, 304, 5, 5) --Shroudweb

--Stradama Margrave
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "Stradama Margrave")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 331399, 401, 5, 5, nil, true) --Infectios Rain
_G.GridStatusRaidDebuff:DebuffId(zoneid, 330135, 402, 5, 5) --Fount of Pestilence
