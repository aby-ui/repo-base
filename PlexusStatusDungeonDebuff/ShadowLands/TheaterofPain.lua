--local zone = "Theater of Pain"
local zoneid = 1683

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--An Affront of Challengers
_G.GridStatusRaidDebuff:BossNameId(zoneid, 100, "An Affront of Challengers")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333231, 101, 5, 5) --Searing Death
_G.GridStatusRaidDebuff:DebuffId(zoneid, 326892, 102, 5, 5) --Fixate
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320069, 103, 5, 5) --Mortal Strike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 333540, 104, 5, 5) --Opportunity Strikes
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320248, 105, 5, 5) --Genetic Alteration
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320180, 106, 5, 5) --Noxious Spores

--Gorechop
_G.GridStatusRaidDebuff:BossNameId(zoneid, 200, "Gorechop")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323406, 201, 5, 5) --Jagged Gash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323130, 202, 5, 5) --Coagulating Ooze
_G.GridStatusRaidDebuff:DebuffId(zoneid, 321768, 203, 4, 4) --On the Hook
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323750, 204, 5, 5) --Vile Gas

--Xav the Unfallen
_G.GridStatusRaidDebuff:BossNameId(zoneid, 300, "Xav the Unfallen")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 331606, 301, 4, 4) --Oppressive Banner
_G.GridStatusRaidDebuff:DebuffId(zoneid, 320102, 302, 4, 4) --Blood and Glory
_G.GridStatusRaidDebuff:DebuffId(zoneid, 332670, 303, 4, 4) --Glorious Combat

--Kul'tharok"
_G.GridStatusRaidDebuff:BossNameId(zoneid, 400, "Kul'tharok")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 319567, 401, 5, 5) --Grasping Hands
_G.GridStatusRaidDebuff:DebuffId(zoneid, 319626, 402, 5, 5) --Phantasmal Parasite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 319539, 403, 5, 5) --Soulless

--Mordretha, the Endless Empress
_G.GridStatusRaidDebuff:BossNameId(zoneid, 500, "Mordretha, the Endless Empress")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323825, 501, 5, 5) --Grasping Rift
_G.GridStatusRaidDebuff:DebuffId(zoneid, 324449, 502, 5, 5) --Manifest Death
_G.GridStatusRaidDebuff:DebuffId(zoneid, 323831, 503, 5, 5) --Death Grasp
