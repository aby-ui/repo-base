-- local zone = "Neltharus"
local zoneid = 2080

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

GridStatusRaidDebuff:BossNameId(zoneid, 100, "Chargath, Bane of Scales")
GridStatusRaidDebuff:DebuffId(zoneid, 374471, 101, 5, 5, true) --erupted-ground
GridStatusRaidDebuff:DebuffId(zoneid, 374482, 102, 5, 5, true) --grounding-chain

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Forgemaster Gorek")
GridStatusRaidDebuff:DebuffId(zoneid, 381482, 201, 5, 5, true) --forgefire

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Magmatusk")
GridStatusRaidDebuff:DebuffId(zoneid, 375890, 301, 5, 5, true) --magma-eruption
GridStatusRaidDebuff:DebuffId(zoneid, 374410, 302, 5, 5, true) --magma-tentacle

GridStatusRaidDebuff:BossNameId(zoneid, 400, "Warlord Sargha")
GridStatusRaidDebuff:DebuffId(zoneid, 377522, 401, 5, 5, true) --burning-pursuit
GridStatusRaidDebuff:DebuffId(zoneid, 376784, 402, 5, 5, true) --flame-vulnerability
GridStatusRaidDebuff:DebuffId(zoneid, 377018, 403, 5, 5, true) --molten-gold
GridStatusRaidDebuff:DebuffId(zoneid, 377022, 404, 5, 5, true) --hardened-gold
GridStatusRaidDebuff:DebuffId(zoneid, 377542, 405, 5, 5, true) --burning-ground