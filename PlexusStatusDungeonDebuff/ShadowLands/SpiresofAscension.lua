--local zone = "Sanguine Depths"
local zoneid = 1693

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Trash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328453, 1, 5, 5) --Oppression
_G.GridStatusRaidDebuff:DebuffId(zoneid, 317661, 1, 5, 5) --Insidious Venom
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328434, 1, 5, 5) --Intimidated
_G.GridStatusRaidDebuff:DebuffId(zoneid, 317963, 1, 5, 5) --Burden of Knowledge
_G.GridStatusRaidDebuff:DebuffId(zoneid, 327648, 1, 5, 5) --Internal Strife
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323744, 1, 5, 5) --Pounce
_G.GridStatusRaidDebuff:DebuffId(zoneid, 328331, 1, 5, 5) --Forced Confession
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323739, 1, 5, 5) --Residual Impact

--Kin-Tara
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "Kin-Tara")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 327481, 100, 5, 5) --Dark Lance
_G.GridStatusRaidDebuff:DebuffId(zoneid, 331251, 101, 5, 5) --Deep Connection
_G.GridStatusRaidDebuff:DebuffId(zoneid, 324662, 102, 5, 5) --Ionized Plasma

--Ventunax
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Ventunax")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 324154, 201, 5, 5) --Dark Stride

--Oryphrion
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Oryphrion")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323195, 301, 5, 5) --Purifying Blast

--Devos, Paragon of Doubt
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "Devos, Paragon of Doubt")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322818, 401, 5, 5) --Lost Confidence
_G.GridStatusRaidDebuff:DebuffId(zoneid, 322817, 402, 5, 5) --Lingering Doubt
