-- local zone = "Castle Nathria"
local _, _, _, tocversion = GetBuildInfo() --luacheck: ignore 113
if tocversion < 90002 then
   return
end
local zoneid = 1735

-- Trash


-- Shriekwing
GridStatusRaidDebuff:BossNameId(zoneid, 100, "Shriekwing")
GridStatusRaidDebuff:DebuffId(zoneid, 328897, 110, 6, 6) -- Exsanguinated
GridStatusRaidDebuff:DebuffId(zoneid, 340324, 111, 6, 6) -- Sanguine Ichor
GridStatusRaidDebuff:DebuffId(zoneid, 329370, 112, 6, 6) -- Deadly Descent
GridStatusRaidDebuff:DebuffId(zoneid, 342077, 113, 6, 6) -- Scent of Blood

-- Huntsman Altimor
GridStatusRaidDebuff:BossNameId(zoneid, 200, "Huntsman Altimor")
GridStatusRaidDebuff:DebuffId(zoneid, 335304, 110, 6, 6) -- Sinseeker
GridStatusRaidDebuff:DebuffId(zoneid, 334852, 110, 6, 6) -- Petrifying Howl
GridStatusRaidDebuff:DebuffId(zoneid, 334971, 110, 6, 6) -- Jagged Claws
GridStatusRaidDebuff:DebuffId(zoneid, 335113, 110, 6, 6) -- Huntsman's Mark
GridStatusRaidDebuff:DebuffId(zoneid, 334893, 110, 6, 6) -- Stone Shards
GridStatusRaidDebuff:DebuffId(zoneid, 334708, 110, 6, 6) -- Deathly Roar
GridStatusRaidDebuff:DebuffId(zoneid, 334945, 110, 6, 6) -- Vicious Lunge
GridStatusRaidDebuff:DebuffId(zoneid, 334960, 110, 6, 6) -- Vicious Wound

-- Sun King's Salvation
GridStatusRaidDebuff:BossNameId(zoneid, 300, "Sun King's Salvation")

-- Artificer Xy'mox
GridStatusRaidDebuff:BossNameId(zoneid, 400, "Artificer Xy'mox")

-- Hungering Destroyer
GridStatusRaidDebuff:BossNameId(zoneid, 500, "Hungering Destroyer")
GridStatusRaidDebuff:DebuffId(zoneid, 329298, 511, 6, 6) -- Gluttonous Miasma
GridStatusRaidDebuff:DebuffId(zoneid, 334228, 512, 6, 6) -- Volatile Ejection

-- Lady Inerva Darkvein
GridStatusRaidDebuff:BossNameId(zoneid, 600, "Lady Inerva Darkvein")
GridStatusRaidDebuff:DebuffId(zoneid, 331573, 611, 6, 6) -- Unconscionable Guilt
GridStatusRaidDebuff:DebuffId(zoneid, 340477, 612, 6, 6) -- Concentrate Anima
GridStatusRaidDebuff:DebuffId(zoneid, 324982, 613, 6, 6) -- Shared Suffering
GridStatusRaidDebuff:DebuffId(zoneid, 325713, 614, 6, 6) -- Lingering Anima

-- The Council of Blood
GridStatusRaidDebuff:BossNameId(zoneid, 700, "The Council of Blood")

-- Sludgefist
GridStatusRaidDebuff:BossNameId(zoneid, 800, "Sludgefist")

-- Stone Legion Generals
GridStatusRaidDebuff:BossNameId(zoneid, 900, "Stone Legion Generals")

-- Sire Denathrius
GridStatusRaidDebuff:BossNameId(zoneid, 1000, "Sire Denathrius")

