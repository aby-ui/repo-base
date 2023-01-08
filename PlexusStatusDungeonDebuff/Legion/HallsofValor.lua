--local zone = "Halls of Valor"
local zoneid = 704

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Whole Dungeon/Trash/Mythic Plus
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, false, true) --Necrotic Rot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, false, true) --Bursting
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, false, true) --Grievous
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6) --Sanguine Ichor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199050, 1, 6, 6) --Mortal Hew
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199652, 1, 6, 6) --Sever
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198944, 1, 6, 6) --Breach Armor
_G.GridStatusRaidDebuff:DebuffId(zoneid, 215430, 1, 6, 6) --Thunderstrike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199674, 1, 6, 6) --Wicked Dagger
_G.GridStatusRaidDebuff:DebuffId(zoneid, 199818, 1, 6, 6) --Crackle
_G.GridStatusRaidDebuff:DebuffId(zoneid, 198959, 1, 6, 6) --Etch
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193702, 1, 6, 6) --Infernal Flames

--Hymdall
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Hymdall")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193092, 11, 6, 6) --Bloodletting Sweep


--Hyrja
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Hyrja")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 154415, 21, 6, 6)


--Fenryr
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Fenryr")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 196497, 31, 6, 6) --Ravenous Leap


--God-King Skovald
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "God-King Skovald")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 156829, 41, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 193660, 41, 6, 6) --Felblaze Rush

--Odyn
--_G.GridStatusRaidDebuff:BossNameId(zoneid, 50, "Odyn")
--_G.GridStatusRaidDebuff:DebuffId(zoneid, 156829, 51, 6, 6)
