--local zone = "Eye of Azshara"
local zoneid = 713

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196064, 1, 6, 6) --Tearing Bite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 195105, 1, 6, 6) --Crunching Bite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196111, 1, 6, 6) --Jagged Claws
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196058, 1, 6, 6) --Lethargic Toxin
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196060, 1, 6, 6) --Numbing Toxin

--Lady Hatecoil
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Warlord Parjesh")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 192131, 11, 6, 6) --Throw Spear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 192094, 12, 6, 6) --Impaling Spear
--Hatecoil Warrior
_G.GridStatusRaidDebuff:DebuffId(zoneid, 195094, 13, 6, 6) --Coral Slash


--Lady Hatecoil
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Lady Hatecoil")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193698, 21, 6, 6) --Curse of the Witch


--Serpentrix
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Serpentrix")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 191855, 31, 6, 6) --toxic-wound
