--local zone = "Black Rook Hold"
local zoneid = 751

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 225963, 1, 6, 6) --Bloodthirsty Leap
_G.GridStatusRaidDebuff:DebuffId(zoneid, 225909, 1, 6, 6) --Soul Venom
_G.GridStatusRaidDebuff:DebuffId(zoneid, 214002, 1, 6, 6) --Raven's Dive
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200261, 1, 6, 6) --Bonebreaking Strike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200084, 1, 6, 6) --Soul Blade

--Amalgam of Souls
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Amalgam of Souls")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 153480, 11, 6, 6)


--Illysanna Ravencrest
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Illysanna Ravencrest")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 197546, 21, 6, 6) --Brutal Glaive


--Smashspite the Hateful
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Smashspite the Hateful")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 224188, 31, 6, 6) --Hateful Charge
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198245, 32, 6, 6) --Brutal Haymaker


--Lord Kur'talos Ravencrest
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Lord Kur'talos Ravencrest")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198635, 41, 6, 6) --Unerring Shear

--Latosius
_G.GridStatusRaidDebuff:BossNameId(zoneid, 50, "Latosius")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 201733, 51, 6, 6) --Stinging Swarm
