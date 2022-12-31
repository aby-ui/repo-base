-- local zone = "Algeth'ar Academy"
local zoneid = 2097

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--"Trash"
GridStatusRaidDebuff:DebuffId(zoneid, 390918, 1, 5, 5, true) -- Seed Detonation
GridStatusRaidDebuff:DebuffId(zoneid, 377344, 1, 5, 5, true) -- Peck
GridStatusRaidDebuff:DebuffId(zoneid, 388912, 1, 5, 5, true) -- Severing Slash
GridStatusRaidDebuff:DebuffId(zoneid, 388866, 1, 5, 5, true) -- Mana Void
GridStatusRaidDebuff:DebuffId(zoneid, 388984, 1, 5, 5, true) -- Vicious Ambush
GridStatusRaidDebuff:DebuffId(zoneid, 388392, 1, 5, 5, true) -- Monotonous Lecture
GridStatusRaidDebuff:DebuffId(zoneid, 387932, 1, 5, 5, true) -- Astral Whirlwind
GridStatusRaidDebuff:DebuffId(zoneid, 378011, 1, 5, 5, true) -- Deadly Winds
GridStatusRaidDebuff:DebuffId(zoneid, 387843, 1, 5, 5, true) -- Astral Bomb

GridStatusRaidDebuff:BossNameId(zoneid, 100, "Vexamus")
GridStatusRaidDebuff:DebuffId(zoneid, 391977, 101, 5, 5, true) -- Oversurge
GridStatusRaidDebuff:DebuffId(zoneid, 386181, 102, 5, 5, true) -- Mana Bomb
GridStatusRaidDebuff:DebuffId(zoneid, 386201, 103, 5, 5, true) -- Corrupted Mana

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Overgrown Ancient")
GridStatusRaidDebuff:DebuffId(zoneid, 388544, 201, 5, 5, true) -- Barkbreaker
GridStatusRaidDebuff:DebuffId(zoneid, 396716, 202, 5, 5, true) -- Splinterbark
GridStatusRaidDebuff:DebuffId(zoneid, 389033, 203, 5, 5, true) -- Lasher Toxin

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Crawth")
GridStatusRaidDebuff:DebuffId(zoneid, 397210, 301, 5, 5, true) -- Sonic Vulnerability
GridStatusRaidDebuff:DebuffId(zoneid, 376449, 302, 5, 5, true) -- Firestorm
GridStatusRaidDebuff:DebuffId(zoneid, 376997, 303, 5, 5, true) -- Savage Peck

GridStatusRaidDebuff:BossNameId(zoneid, 400, "Echo of Doragosa")
GridStatusRaidDebuff:DebuffId(zoneid, 374350, 401, 5, 5, true) -- Energy Bomb
GridStatusRaidDebuff:DebuffId(zoneid, 389011, 402, 6, 6, true, true) -- Overwhelming Power
