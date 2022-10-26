--local zone = "Gate of the Setting Sun"
local zoneid = 437

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--Saboteur Kip'tilak
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "Saboteur Kip'tilak")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 107268, 11, 6, 6)

--Striker Ga'dok
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Striker Ga'dok")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 106934, 21, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 107047, 22, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 116297, 23, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 115458, 24, 6, 6)
--Commander Ri'mok
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Commander Ri'mok")
--Viscous Fluid
_G.GridStatusRaidDebuff:DebuffId(zoneid, 107120, 31, 6, 6)
--Raigonn
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Raigonn")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 107275, 41, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111600, 42, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111723, 43, 6, 6)
_G.GridStatusRaidDebuff:DebuffId(zoneid, 111725, 44, 6, 6)