--local zone = "De Other Side"
local zoneid = 1679

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Hakkar the Soulflayer
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Hakkar the Soulflayer")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322746, 101, 5, 5) --Corrupted Blood
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328987, 102, 5, 5) --Zealous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323118, 103, 5, 5, nil, true) --Blood Barrage
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323569, 104, 5, 5) --Spilled Essence

--The Manastorms
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "The Manastorms")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320147, 201, 5, 5, nil, true) --Bleeding
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320786, 202, 5, 5, nil, true) --Power Overwhelming
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320008, 203, 4, 4) --Frostbolt
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323877, 204, 5, 5) --Echo Finger Laser X-treme
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320144, 205, 5, 5) --Buzz-Saw
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320142, 206, 5, 5, nil, true) --Diabolical Dooooooom!
_G.GridStatusRaidDebuff:DebuffId(zoneid, 324010, 207, 5, 5) --Eruption
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320132, 208, 5, 5) --Shadowfury

--Dealer Xy'exa
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Dealer Xy'exa")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323692, 301, 4, 4) --Arcane Vulnerability
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323687, 302, 5, 5) --Arcane Lightning
_G.GridStatusRaidDebuff:DebuffId(zoneid, 342961, 303, 5, 5) --Localized Explosive Contrivance
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320232, 304, 5, 5) --Explosive Contrivance

--Mueh'zala
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "Mueh'zala")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 325725, 401, 4, 4) --Cosmic Artifice
_G.GridStatusRaidDebuff:DebuffId(zoneid, 334913, 402, 5, 5, nil, true) --Master of Death
_G.GridStatusRaidDebuff:DebuffId(zoneid, 327649, 403, 4, 4) --Crushed Soul
