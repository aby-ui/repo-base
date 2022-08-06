--local zone = "Court of Stars"
local zoneid = 761

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 214692, 1, 6, 6) --Shadow Bolt Volley
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211464, 1, 6, 6) --Fel Detonation
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211473, 1, 6, 6) --Shadow Slash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 207981, 1, 6, 6) --Disintegration Beam
_G.GridStatusRaidDebuff:DebuffId(zoneid, 211391, 1, 6, 6) --Felblaze Puddle
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209036, 1, 6, 6) --Throw Torch
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209378, 1, 6, 6) --Whirling Blades
_G.GridStatusRaidDebuff:DebuffId(zoneid, 214690, 1, 6, 6) --Cripple
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209512, 1, 6, 6) --Disrupting Energy
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209516, 1, 6, 6) --Mana Fang
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209413, 1, 6, 6) --Suppress

--Patrol Captain Gerdo
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Patrol Captain Gerdo")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 207278, 11, 6, 6) --Arcane Lockdown


--Talixae Flamewreath
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Talixae Flamewreath")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 154415, 21, 6, 6)


--Advisor Melandrus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Advisor Melandrus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209667, 31, 6, 6) --Blade Surge
