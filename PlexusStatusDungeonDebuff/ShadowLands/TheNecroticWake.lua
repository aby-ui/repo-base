--local zone = "The Necrotic Wake"
local zoneid = 1666

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Blightbone
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Blightbone")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320717, 101, 5, 5) --Blood Hunger
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320596, 102, 5, 5) --Heaving Retch
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320646, 103, 5, 5) --Fetid Gas

--Amarth, the Harvester
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Amarth, the Harvester")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320170, 201, 5, 5) --Necrotic Bolt
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328664, 202, 5, 5, nil, true) --Chilled
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333492, 203, 5, 5) --Necrotic Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333489, 204, 5, 5) --Necrotic Breath

--Surgeon Stitchflesh
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Surgeon Stitchflesh")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333485, 301, 5, 5) --Disease Cloud
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320200, 302, 5, 5) --Stitchneedle
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322681, 303, 5, 5) --Meat Hook
_G.GridStatusRaidDebuff:DebuffId(zoneid, 343556, 304, 5, 5) --Morbid Fixation
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320366, 305, 5, 5) --Embalming Ichor

--Nalthor the Rimebinder
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "Nalthor the Rimebinder")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328181, 401, 4, 4) --Frigid Cold
_G.GridStatusRaidDebuff:DebuffId(zoneid, 321755, 402, 5, 5, nil, true) --Icebound Aegis
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320784, 403, 4, 4) --Comet Storm
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320788, 404, 5, 5) --Frozen Binds
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322274, 405, 5, 5) --Enfeeble
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328212, 406, 5, 5) --Razorshard Ice
