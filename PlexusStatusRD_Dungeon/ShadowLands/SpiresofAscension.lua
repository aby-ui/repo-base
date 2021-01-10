--local zone = "Sanguine Depths"
local zoneid = 1693

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Trash
GridStatusRaidDebuff:DebuffId(zoneid, 328453, 1, 5, 5) --Oppression
GridStatusRaidDebuff:DebuffId(zoneid, 317661, 1, 5, 5) --Insidious Venom
GridStatusRaidDebuff:DebuffId(zoneid, 328434, 1, 5, 5) --Intimidated
GridStatusRaidDebuff:DebuffId(zoneid, 317963, 1, 5, 5) --Burden of Knowledge
GridStatusRaidDebuff:DebuffId(zoneid, 327648, 1, 5, 5) --Internal Strife
GridStatusRaidDebuff:DebuffId(zoneid, 323744, 1, 5, 5) --Pounce
GridStatusRaidDebuff:DebuffId(zoneid, 328331, 1, 5, 5) --Forced Confession
GridStatusRaidDebuff:DebuffId(zoneid, 323739, 1, 5, 5) --Residual Impact

--Kin-Tara
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Kin-Tara")
GridStatusRaidDebuff:DebuffId(zoneid, 327481, 100, 5, 5) --Dark Lance
GridStatusRaidDebuff:DebuffId(zoneid, 331251, 101, 5, 5) --Deep Connection
GridStatusRaidDebuff:DebuffId(zoneid, 324662, 102, 5, 5) --Ionized Plasma

--Ventunax
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Ventunax")
GridStatusRaidDebuff:DebuffId(zoneid, 324154, 201, 5, 5) --Dark Stride

--Oryphrion
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Oryphrion")
GridStatusRaidDebuff:DebuffId(zoneid, 323195, 301, 5, 5) --Purifying Blast

--Devos, Paragon of Doubt
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Devos, Paragon of Doubt")
GridStatusRaidDebuff:DebuffId(zoneid, 322818, 401, 5, 5) --Lost Confidence
GridStatusRaidDebuff:DebuffId(zoneid, 322817, 402, 5, 5) --Lingering Doubt
