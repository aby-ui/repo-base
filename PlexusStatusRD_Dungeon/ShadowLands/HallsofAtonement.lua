--local zone = "Halls of Atonement"
local zoneid = 1663

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Halkias, the Sin-Stained Goliath
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Halkias, the Sin-Stained Goliath")
GridStatusRaidDebuff:DebuffId(zoneid, 323001, 101, 5, 5) --Glass Shards
GridStatusRaidDebuff:DebuffId(zoneid, 339237, 102, 5, 5) --Sinlight Visions

--Echelon
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Echelon")
GridStatusRaidDebuff:DebuffId(zoneid, 344874, 201, 5, 5) --Shattered
GridStatusRaidDebuff:DebuffId(zoneid, 319603, 202, 5, 5) --Curse of Stone
GridStatusRaidDebuff:DebuffId(zoneid, 319611, 203, 4, 4) --Turned to Stone
GridStatusRaidDebuff:DebuffId(zoneid, 319703, 204, 5, 5) --Blood Torrent

--High Adjudicator Aleez
GridStatusRaidDebuff:BossNameId(zoneid, 300, "High Adjudicator Aleez")
GridStatusRaidDebuff:DebuffId(zoneid, 323650, 301, 4, 4) --Haunting Fixation

--Lord Chamberlain
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Lord Chamberlain")
GridStatusRaidDebuff:DebuffId(zoneid, 323437, 401, 5, 5, nil, true) --Stigma of Pride
GridStatusRaidDebuff:DebuffId(zoneid, 335338, 402, 5, 5) --Ritual of Woe
