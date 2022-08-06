--local zone = "Gate of the Setting Sun"
local zoneid = 323

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Lady Naz'jar
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Lady Naz'jar")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76001, 11, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 80564, 12, 6, 6)
--Water Vortexes
--Commander Ulthok, the Festering Prince
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Commander Ulthok, the Festering Prince")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76026, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76047, 22, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76094, 23, 6, 6)
--Mindbender Ghur'sha
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Mindbender Ghur'sha")
--Emberstrike
--Magma Splash
--Earth Shards
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76234, 31, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76339, 32, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 76207, 33, 6, 6)
--Ozumat
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Ozumat")
--Veil of Shadow
--Blight Spray
--Aura of Dread
_G.GridStatusRaidDebuff:DebuffId(zoneid, 83672, 41, 6, 6)