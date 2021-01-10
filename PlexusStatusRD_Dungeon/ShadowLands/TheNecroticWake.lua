--local zone = "The Necrotic Wake"
local zoneid = 1666

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Blightbone
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Blightbone")
GridStatusRaidDebuff:DebuffId(zoneid, 320717, 101, 5, 5) --Blood Hunger
GridStatusRaidDebuff:DebuffId(zoneid, 320596, 102, 5, 5) --Heaving Retch
GridStatusRaidDebuff:DebuffId(zoneid, 320646, 103, 5, 5) --Fetid Gas

--Amarth, the Harvester
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Amarth, the Harvester")
GridStatusRaidDebuff:DebuffId(zoneid, 320170, 201, 5, 5) --Necrotic Bolt
GridStatusRaidDebuff:DebuffId(zoneid, 328664, 202, 5, 5, nil, true) --Chilled
GridStatusRaidDebuff:DebuffId(zoneid, 333492, 203, 5, 5) --Necrotic Ichor
GridStatusRaidDebuff:DebuffId(zoneid, 333489, 204, 5, 5) --Necrotic Breath

--Surgeon Stitchflesh
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Surgeon Stitchflesh")
GridStatusRaidDebuff:DebuffId(zoneid, 333485, 301, 5, 5) --Disease Cloud
GridStatusRaidDebuff:DebuffId(zoneid, 320200, 302, 5, 5) --Stitchneedle
GridStatusRaidDebuff:DebuffId(zoneid, 322681, 303, 5, 5) --Meat Hook
GridStatusRaidDebuff:DebuffId(zoneid, 343556, 304, 5, 5) --Morbid Fixation
GridStatusRaidDebuff:DebuffId(zoneid, 320366, 305, 5, 5) --Embalming Ichor

--Nalthor the Rimebinder
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Nalthor the Rimebinder")
GridStatusRaidDebuff:DebuffId(zoneid, 328181, 401, 4, 4) --Frigid Cold
GridStatusRaidDebuff:DebuffId(zoneid, 321755, 402, 5, 5, nil, true) --Icebound Aegis
GridStatusRaidDebuff:DebuffId(zoneid, 320784, 403, 4, 4) --Comet Storm
GridStatusRaidDebuff:DebuffId(zoneid, 320788, 404, 5, 5) --Frozen Binds
GridStatusRaidDebuff:DebuffId(zoneid, 322274, 405, 5, 5) --Enfeeble
GridStatusRaidDebuff:DebuffId(zoneid, 328212, 406, 5, 5) --Razorshard Ice
