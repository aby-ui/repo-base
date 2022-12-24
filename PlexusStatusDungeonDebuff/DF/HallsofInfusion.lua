-- local zone = "Halls of Infusion"
local zoneid = 2082

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--Trash
GridStatusRaidDebuff:DebuffId(zoneid, 374020, 1, 5, 5, true) -- containment-beam
GridStatusRaidDebuff:DebuffId(zoneid, 393444, 1, 5, 5, true) -- gushing-wound
GridStatusRaidDebuff:DebuffId(zoneid, 374706, 1, 5, 5, true) -- pyretic-burst
GridStatusRaidDebuff:DebuffId(zoneid, 374149, 1, 5, 5, true) -- tailwind
GridStatusRaidDebuff:DebuffId(zoneid, 374615, 1, 5, 5, true) -- cheap-shot
GridStatusRaidDebuff:DebuffId(zoneid, 374563, 1, 5, 5, true) -- dazzle
GridStatusRaidDebuff:DebuffId(zoneid, 374724, 1, 5, 5, true) -- molten-subduction

GridStatusRaidDebuff:BossNameId(zoneid, 100, "Watcher Irideus")
GridStatusRaidDebuff:DebuffId(zoneid, 384524, 101, 5, 5, true) -- titanic-fist
GridStatusRaidDebuff:DebuffId(zoneid, 383935, 102, 5, 5, true) -- spark-volley
GridStatusRaidDebuff:DebuffId(zoneid, 389179, 103, 5, 5, true) -- power-overload
GridStatusRaidDebuff:DebuffId(zoneid, 389181, 104, 5, 5, true) -- power-field

GridStatusRaidDebuff:BossNameId(zoneid, 200, "Gulping Goliath")
GridStatusRaidDebuff:DebuffId(zoneid, 374389, 201, 5, 5, true) -- gulp-swog-toxin
GridStatusRaidDebuff:DebuffId(zoneid, 385551, 202, 5, 5, true) -- gulp
GridStatusRaidDebuff:DebuffId(zoneid, 385451, 203, 5, 5, true) -- toxic-effluvia

GridStatusRaidDebuff:BossNameId(zoneid, 300, "Khajin the Unyielding")
GridStatusRaidDebuff:DebuffId(zoneid, 385963, 301, 5, 5, true) -- frost-shock
GridStatusRaidDebuff:DebuffId(zoneid, 386741, 302, 5, 5, true) -- polar-winds

GridStatusRaidDebuff:BossNameId(zoneid, 400, "Primal Tsunami")
GridStatusRaidDebuff:DebuffId(zoneid, 387359, 401, 5, 5, true) -- waterlogged
GridStatusRaidDebuff:DebuffId(zoneid, 387571, 402, 5, 5, true) -- focused-deluge
