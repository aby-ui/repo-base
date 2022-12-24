-- local zone = "Brackenhide Hollow"
local zoneid = 2096

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

GridStatusRaidDebuff:BossNameId(zoneid, 100, "Hackclaw's War-Band")
GridStatusRaidDebuff:DebuffId(zoneid, 378020, 101, 5, 5, true) --gash-frenzy
GridStatusRaidDebuff:DebuffId(zoneid, 381379, 102, 5, 5, true) --decayed-senses

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Treemouth")
GridStatusRaidDebuff:DebuffId(zoneid, 377864, 201, 5, 5, true) --infectious-spit
GridStatusRaidDebuff:DebuffId(zoneid, 378054, 202, 5, 5, true) --withering-away
GridStatusRaidDebuff:DebuffId(zoneid, 378022, 203, 5, 5, true) --consuming
GridStatusRaidDebuff:DebuffId(zoneid, 376933, 204, 5, 5, true) --grasping-vines

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Gutshot")
GridStatusRaidDebuff:DebuffId(zoneid, 376997, 301, 5, 5, true) --savage-peck

GridStatusRaidDebuff:BossNameId(zoneid, 400, "Decatriarch Wratheye")
GridStatusRaidDebuff:DebuffId(zoneid, 373896, 401, 5, 5, true) --withering-rot
