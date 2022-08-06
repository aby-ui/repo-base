--local zone = "Darkheart Thicket"
local zoneid = 733

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200580, 1, 6, 6) --Maddening Roar
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200642, 1, 6, 6) --Despair
_G.GridStatusRaidDebuff:DebuffId(zoneid, 225484, 1, 6, 6) --Grievous Rip
_G.GridStatusRaidDebuff:DebuffId(zoneid, 201365, 1, 6, 6) --Darksoul Drain
_G.GridStatusRaidDebuff:DebuffId(zoneid, 204243, 1, 6, 6) --Tormenting Eye
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198904, 1, 6, 6) --Poison Spear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199063, 1, 6, 6) --Strangling Roots
_G.GridStatusRaidDebuff:DebuffId(zoneid, 204246, 1, 6, 6) --Tormenting Fear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 225568, 1, 6, 6) --Curse of Isolation

--Archdruid Glaidalis
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Archdruid Glaidalis")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196376, 11, 6, 6) --Grievous Tear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198408, 12, 6, 6) --Nightfall


--Oakheart
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Oakheart")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 204667, 21, 6, 6) --Nightmare Breath
_G.GridStatusRaidDebuff:DebuffId(zoneid, 204611, 22, 6, 6) --Crushing Grip


--Dresaron
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Dresaron")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 220855, 31, 6, 6) --Down Draft
_G.GridStatusRaidDebuff:DebuffId(zoneid, 191326, 32, 6, 6) --Breath of Corruption


--Shade of Xavius
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Shade of Xavius")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200289, 41, 6, 6) --Growing Paranoia
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200238, 42, 6, 6) --Feed on the Weak
_G.GridStatusRaidDebuff:DebuffId(zoneid, 200182, 43, 6, 6) --Festering Rip
