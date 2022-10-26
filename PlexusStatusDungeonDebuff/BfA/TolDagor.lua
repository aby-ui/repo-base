--local zone = "Tol Dagor"
local zoneid = 974

--trash
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258313, 1, 6, 6, true)  --Handcuff
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258938, 1, 6, 6, true)  --Inner Flames
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258864, 1, 6, 6, true)  --Suppression Fire
_G.GridStatusRaidDebuff:DebuffId(zoneid, 185857, 1, 6, 6, true)  --Shoot
_G.GridStatusRaidDebuff:DebuffId(zoneid, 224125, 1, 6, 6, true)  --Molten Weapon
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258150, 1, 6, 6, true)  --Salt Blast
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257793, 1, 6, 6, true)  --Smoke Powder
_G.GridStatusRaidDebuff:DebuffId(zoneid, 265889, 1, 6, 6, true)  --Torch Strike
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256105, 1, 6, 6, true)  --Explosive Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258917, 1, 6, 6, true)  --Righteous Flames
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258128, 1, 6, 6, true)  --Debilitating Shout
_G.GridStatusRaidDebuff:DebuffId(zoneid, 259711, 1, 6, 6, true)  --Lockdown
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257777, 1, 6, 6, true)  --Crippling Shiv
_G.GridStatusRaidDebuff:DebuffId(zoneid, 272620, 1, 6, 6, true)  --Throw Rock
_G.GridStatusRaidDebuff:DebuffId(zoneid, 265271, 1, 6, 6, true) --Sewer Slime
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258134, 1, 6, 6, true) --Makeshift Shiv
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258058, 1, 6, 6, true) --Squeeze
_G.GridStatusRaidDebuff:DebuffId(zoneid, 258079, 1, 6, 6, true) --Massive Chomp
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256200, 1, 6, 6, true) --Heartstopper Venom
_G.GridStatusRaidDebuff:DebuffId(zoneid, 260016, 1, 6, 6, true) --Itchy Bite
_G.GridStatusRaidDebuff:DebuffId(zoneid, 224729, 1, 6, 6, true) --Bursting Shot

--M+
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240447, 1, 6, 6, true) --Quake
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240559, 1, 6, 6, true, true) --Grievous Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 209858, 1, 6, 6, true, true) --Necrotic Wound
_G.GridStatusRaidDebuff:DebuffId(zoneid, 240443, 1, 6, 6, true, true) --Burst
_G.GridStatusRaidDebuff:DebuffId(zoneid, 226512, 1, 6, 6, true) --Sanguine Ichor
-- 8.3
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314411, 1, 6, 6, true) --Lingering Doubt
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314392, 1, 6, 6, true) --Vile Corruption
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314592, 1, 6, 6, true) --Mind Flay
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314406, 1, 6, 6, true) --Crippling Pestilence
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314308, 1, 6, 6, true) --Spirit Breaker
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314478, 1, 6, 6, true) --Cascading Terror
_G.GridStatusRaidDebuff:DebuffId(zoneid, 314531, 1, 6, 6, true) --Tear Flesh
_G.GridStatusRaidDebuff:DebuffId(zoneid, 313445, 1, 1, 1, true) --Ny'alotha Incursion

--The Sand Queen
_G.GridStatusRaidDebuff:BossNameId(zoneid, 10, "The Sand Queen")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 259975, 11, 6, 6, true)  --Enrage
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257119, 12, 6, 6, true)  --Sand Trap
--Jes Howlis
_G.GridStatusRaidDebuff:BossNameId(zoneid, 20, "Jes Howlis")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257785, 21, 6, 6, true)  --Flashing Daggers
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257956, 22, 6, 6, true)  --Motivated
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257791, 23, 6, 6, true) --Howling Fear
_G.GridStatusRaidDebuff:DebuffId(zoneid, 260067, 24, 6, 6, true) --Vicious Mauling
--Knight Captain Valyri
_G.GridStatusRaidDebuff:BossNameId(zoneid, 30, "Knight Captain Valyri")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256710, 31, 6, 6, true)  --Burning Arsenal
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257033, 32, 6, 6, true)  --Fuselighter
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256976, 33, 6, 6, true)  --Ignition
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256955, 34, 6, 6, true)  --Cinderflame
_G.GridStatusRaidDebuff:DebuffId(zoneid, 257028, 35, 6, 6, true)  --Fuselighter
--Overseer Korgus
_G.GridStatusRaidDebuff:BossNameId(zoneid, 40, "Overseer Korgus")
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256201, 41, 6, 6, true, true)  --Incendiary Rounds
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256044, 42, 6, 6, true)  --Deadeye
_G.GridStatusRaidDebuff:DebuffId(zoneid, 263345, 43, 6, 6, true)  --Massive Blast
_G.GridStatusRaidDebuff:DebuffId(zoneid, 256083, 44, 6, 6, true)  --Cross Ignition