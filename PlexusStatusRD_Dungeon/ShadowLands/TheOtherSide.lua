--local zone = "De Other Side"
local zoneid = 1679

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Hakkar the Soulflayer
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Hakkar the Soulflayer")
GridStatusRaidDebuff:DebuffId(zoneid, 322746, 101, 5, 5) --Corrupted Blood
GridStatusRaidDebuff:DebuffId(zoneid, 328987, 102, 5, 5) --Zealous
GridStatusRaidDebuff:DebuffId(zoneid, 323118, 103, 5, 5, nil, true) --Blood Barrage
GridStatusRaidDebuff:DebuffId(zoneid, 323569, 104, 5, 5) --Spilled Essence

--The Manastorms
GridStatusRaidDebuff:BossNameId(zoneid, 200, "The Manastorms")
GridStatusRaidDebuff:DebuffId(zoneid, 320147, 201, 5, 5, nil, true) --Bleeding
GridStatusRaidDebuff:DebuffId(zoneid, 320786, 202, 5, 5, nil, true) --Power Overwhelming
GridStatusRaidDebuff:DebuffId(zoneid, 320008, 203, 4, 4) --Frostbolt
GridStatusRaidDebuff:DebuffId(zoneid, 323877, 204, 5, 5) --Echo Finger Laser X-treme
GridStatusRaidDebuff:DebuffId(zoneid, 320144, 205, 5, 5) --Buzz-Saw
GridStatusRaidDebuff:DebuffId(zoneid, 320142, 206, 5, 5, nil, true) --Diabolical Dooooooom!
GridStatusRaidDebuff:DebuffId(zoneid, 324010, 207, 5, 5) --Eruption
GridStatusRaidDebuff:DebuffId(zoneid, 320132, 208, 5, 5) --Shadowfury

--Dealer Xy'exa
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Dealer Xy'exa")
GridStatusRaidDebuff:DebuffId(zoneid, 323692, 301, 4, 4) --Arcane Vulnerability
GridStatusRaidDebuff:DebuffId(zoneid, 323687, 302, 5, 5) --Arcane Lightning
GridStatusRaidDebuff:DebuffId(zoneid, 342961, 303, 5, 5) --Localized Explosive Contrivance
GridStatusRaidDebuff:DebuffId(zoneid, 320232, 304, 5, 5) --Explosive Contrivance

--Mueh'zala
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Mueh'zala")
GridStatusRaidDebuff:DebuffId(zoneid, 325725, 401, 4, 4) --Cosmic Artifice
GridStatusRaidDebuff:DebuffId(zoneid, 334913, 402, 5, 5, nil, true) --Master of Death
GridStatusRaidDebuff:DebuffId(zoneid, 327649, 403, 4, 4) --Crushed Soul
