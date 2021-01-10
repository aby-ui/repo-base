--local zone = "Theater of Pain"
local zoneid = 1683

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon
--true, true is for stackable

--M+
GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor

--An Affront of Challengers
GridStatusRaidDebuff:BossNameId(zoneid, 100, "An Affront of Challengers")
GridStatusRaidDebuff:DebuffId(zoneid, 333231, 101, 5, 5) --Searing Death
GridStatusRaidDebuff:DebuffId(zoneid, 326892, 102, 5, 5) --Fixate
GridStatusRaidDebuff:DebuffId(zoneid, 320069, 103, 5, 5) --Mortal Strike
GridStatusRaidDebuff:DebuffId(zoneid, 333540, 104, 5, 5) --Opportunity Strikes
GridStatusRaidDebuff:DebuffId(zoneid, 320248, 105, 5, 5) --Genetic Alteration
GridStatusRaidDebuff:DebuffId(zoneid, 320180, 106, 5, 5) --Noxious Spores

--Gorechop
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Gorechop")
GridStatusRaidDebuff:DebuffId(zoneid, 323406, 201, 5, 5) --Jagged Gash
GridStatusRaidDebuff:DebuffId(zoneid, 323130, 202, 5, 5) --Coagulating Ooze
GridStatusRaidDebuff:DebuffId(zoneid, 321768, 203, 4, 4) --On the Hook
GridStatusRaidDebuff:DebuffId(zoneid, 323750, 204, 5, 5) --Vile Gas

--Xav the Unfallen
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Xav the Unfallen")
GridStatusRaidDebuff:DebuffId(zoneid, 331606, 301, 4, 4) --Oppressive Banner
GridStatusRaidDebuff:DebuffId(zoneid, 320102, 302, 4, 4) --Blood and Glory
GridStatusRaidDebuff:DebuffId(zoneid, 332670, 303, 4, 4) --Glorious Combat

--Kul'tharok"
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Kul'tharok")
GridStatusRaidDebuff:DebuffId(zoneid, 319567, 401, 5, 5) --Grasping Hands
GridStatusRaidDebuff:DebuffId(zoneid, 319626, 402, 5, 5) --Phantasmal Parasite
GridStatusRaidDebuff:DebuffId(zoneid, 319539, 403, 5, 5) --Soulless

--Mordretha, the Endless Empress
GridStatusRaidDebuff:BossNameId(zoneid, 500, "Mordretha, the Endless Empress")
GridStatusRaidDebuff:DebuffId(zoneid, 323825, 501, 5, 5) --Grasping Rift
GridStatusRaidDebuff:DebuffId(zoneid, 324449, 502, 5, 5) --Manifest Death
GridStatusRaidDebuff:DebuffId(zoneid, 323831, 503, 5, 5) --Death Grasp
