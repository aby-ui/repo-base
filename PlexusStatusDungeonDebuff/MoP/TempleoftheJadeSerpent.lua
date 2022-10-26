--local zone = "Temple of the Jade Serpent"
local zoneid = 429

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

_G.GridStatusRaidDebuff:DebuffId(zoneid, 118714, 1, 6, 6) --Purified Water
_G.GridStatusRaidDebuff:DebuffId(zoneid, 110125, 1, 6, 6) --Shattered Resolve
_G.GridStatusRaidDebuff:DebuffId(zoneid, 128051, 1, 6, 6) --Serrated Slash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 114826, 1, 6, 6) --Songbird Serenade
_G.GridStatusRaidDebuff:DebuffId(zoneid, 110099, 1, 6, 6) --Shadows of Doubt

--Wise Mari
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Wise Mari")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 115167, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 143459, 12, 6, 6)
--Lorewalker Stonestep
--Liu Flameheart
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Liu Flameheart")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 106823, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 106841, 22, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 107045, 23, 6, 6)
--Sha of Doubt
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Sha of Doubt")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 106113, 31, 6, 6)