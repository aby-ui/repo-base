--local zone = "The Stonecore"
local zoneid = 324


-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

_G.GridStatusRaidDebuff:DebuffId(zoneid, 81441, 1, 6, 6) --Shadowfury
_G.GridStatusRaidDebuff:DebuffId(zoneid, 81440, 1, 6, 6) --Frostbolt Volley
_G.GridStatusRaidDebuff:DebuffId(zoneid, 81508, 1, 6, 6) --Dust Storm
_G.GridStatusRaidDebuff:DebuffId(zoneid, 81711, 1, 6, 6) --Fracture
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80221, 1, 6, 6) --Beat Down
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80913, 1, 6, 6) --Crystal Shards
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80151, 1, 6, 6) --Ignite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 81569, 1, 6, 6) --Spinning Slash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80028, 1, 6, 6) --Rock Bore
_G.GridStatusRaidDebuff:DebuffId(zoneid, 81442, 1, 6, 6) --Fear

--Corborus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Corborus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 86881, 11, 6, 6)
--Crystal Shard
_G.GridStatusRaidDebuff:DebuffId(zoneid, 82415, 12, 6, 6)
--Rock Borer
--Slabhide
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Slabhide")
--Lava Fissure
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80807, 21, 6, 6)
--Stalactite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 92265, 22, 6, 6)
--Ozruk
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Ozruk")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 78835, 31, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 78859, 32, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 92426, 33, 6, 6)
--High Priestess Azil
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "High Priestess Azil")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 79345, 41, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 79351, 42, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 42499, 43, 6, 6)