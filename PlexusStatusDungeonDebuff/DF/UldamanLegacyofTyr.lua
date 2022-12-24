-- local zone = "Uldaman: Legacy of Tyr"
local zoneid = 2071

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

GridStatusRaidDebuff:BossNameId(zoneid, 100, "The Lost Dwarves")
GridStatusRaidDebuff:DebuffId(zoneid, 377825, 101, 5, 5, true) --burning-pitch
GridStatusRaidDebuff:DebuffId(zoneid, 375286, 102, 5, 5, true) --searing-cannonfire

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Bromach")
GridStatusRaidDebuff:DebuffId(zoneid, 369660, 201, 5, 5, true) --tremor

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Sentinel Talondras")
GridStatusRaidDebuff:DebuffId(zoneid, 372652, 301, 5, 5, true) --resonating-orb

GridStatusRaidDebuff:BossNameId(zoneid, 400, "Emberon")
GridStatusRaidDebuff:DebuffId(zoneid, 369110, 401, 5, 5, true) --unstable-embers
GridStatusRaidDebuff:DebuffId(zoneid, 369025, 402, 5, 5, true) --fire-wave

GridStatusRaidDebuff:BossNameId(zoneid, 500, "Chrono-Lord Deios")
GridStatusRaidDebuff:DebuffId(zoneid, 376325, 501, 5, 5, true) --eternity-zone
GridStatusRaidDebuff:DebuffId(zoneid, 377405, 502, 5, 5, true) --time-sink