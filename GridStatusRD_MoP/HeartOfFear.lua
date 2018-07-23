--local zone = "Heart of Fear"
local zoneid = 474

-- Check Compatibility
if GridStatusRD_MoP.rd_version < 502 then
	return
end

--zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon

--Trash

-- Imperial Vizier Zor'lok trash
-- Sra'thik Shield Master
GridStatusRaidDebuff:DebuffId(zoneid, 123417, 1, 1, 1, true, true) --Dismantled Armor (armor)
-- Kor'thik Slicer
GridStatusRaidDebuff:DebuffId(zoneid, 123422, 1, 1, 1) -- Arterial Bleeding (dot)
GridStatusRaidDebuff:DebuffId(zoneid, 123434, 1, 2, 2) -- Gouge Throat (silence)
-- Set'thik Swiftblade
GridStatusRaidDebuff:DebuffId(zoneid, 123436, 1, 1, 1) -- Riposte (disarm)
-- Set'thik Fanatic
GridStatusRaidDebuff:DebuffId(zoneid, 123497, 1, 1, 1) -- Gale Force Winds (slows casting)

-- Blade Lord Ta'yak trash
-- Instructor Kli'thak
GridStatusRaidDebuff:DebuffId(zoneid, 123180, 2, 1, 1) --Wind Step (dot)
-- Sra'thik Shield Master
GridStatusRaidDebuff:DebuffId(zoneid, 123420, 2, 2, 2) --Stunning Strike (stun)

-- Amber-Shaper trash
-- Amber-Ridden Mushan
GridStatusRaidDebuff:DebuffId(zoneid, 125081, 5, 1, 1) --Slam (stun)
-- Amber Searsting
GridStatusRaidDebuff:DebuffId(zoneid, 125490, 5, 1, 1) --Burning Sting (dot)
-- Kor'thik Fleshrender
GridStatusRaidDebuff:DebuffId(zoneid, 126901, 5, 2, 2, true, true) --Mortal Rend (tank, stackable healing debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 126912, 5, 6, 6) --Grievous Whirl (dot removed when target healed to 90%)

-- Grand Empress Trash
-- Kor'thik Warsinger
GridStatusRaidDebuff:DebuffId(zoneid, 125907, 6, 1, 1) --Cry Havoc

--Imperial Vizier Zor'lok
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Imperial Vizier Zor'lok")
GridStatusRaidDebuff:DebuffId(zoneid, 122761, 11, 4, 4) --Exhale
GridStatusRaidDebuff:DebuffId(zoneid, 123812, 12, 1, 1) --Pheromones of Zeal
GridStatusRaidDebuff:DebuffId(zoneid, 122740, 13, 6, 6) --Convert (MC)
GridStatusRaidDebuff:DebuffId(zoneid, 122706, 14, 3, 3) --Noise Cancelling (AMZ)

--Blade Lord Ta'yak
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Blade Lord Ta'yak")
GridStatusRaidDebuff:DebuffId(zoneid, 123474, 21, 1, 1, true, true) --Overwhelming Assault (tank stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 122949, 22, 6, 6) --Unseen Strike (group up on target)
GridStatusRaidDebuff:DebuffId(zoneid, 124783, 23, 4, 4) --Storm Unleashed
GridStatusRaidDebuff:DebuffId(zoneid, 123180, 24, 5, 5) --Windstep
--GridStatusRaidDebuff:DebuffId(zoneid, 123600, 24, 5, 5) --Storm Unleashed?

--Garalon
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Garalon")
GridStatusRaidDebuff:DebuffId(zoneid, 122835, 31, 5, 5) --Pheromones (fixate/dot/passable)
GridStatusRaidDebuff:DebuffId(zoneid, 123081, 32, 6, 6, true, true) --Pungency (Pheromones stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 122774, 33, 2, 2) --Crush (knocked down)
GridStatusRaidDebuff:DebuffId(zoneid, 123423, 34, 1, 1) --Weak Points (damage increase)
--GridStatusRaidDebuff:DebuffId(zoneid, 123120, 33, 4, 4) --Pheromone Trail

--Wind Lord Mel'jarak
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Wind Lord Mel'jarak")
-- Sra-thik Amber-Trappers
GridStatusRaidDebuff:DebuffId(zoneid, 121881, 41, 6, 6) --Amber Prison
GridStatusRaidDebuff:DebuffId(zoneid, 122055, 42, 1, 1) --Residue
GridStatusRaidDebuff:DebuffId(zoneid, 122064, 43, 3, 3, true, true) --Corrosive Resin
-- Kor'thik Elite Blademaster
GridStatusRaidDebuff:DebuffId(zoneid, 123963, 44, 7, 7) --Kor'thik Strike

--Amber-Shaper Un'sok
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Amber-Shaper Un'sok")
GridStatusRaidDebuff:DebuffId(zoneid, 121949, 51, 6, 6) --Parasitic Growth
GridStatusRaidDebuff:DebuffId(zoneid, 122784, 52, 3, 3) --Reshape Life
--GridStatusRaidDebuff:DebuffId(zoneid, 122504, 54, 5, 5) --Burning Amber (not a debuff)

--Grand Empress Shek'zeer
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Grand Empress Shek'zeer")
GridStatusRaidDebuff:DebuffId(zoneid, 123707, 61, 5, 5, true, true) --Eyes of the Empress (tank stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 125390, 62, 6, 6) --Fixate
GridStatusRaidDebuff:DebuffId(zoneid, 123788, 63, 5, 5) --Cry of Terror (debuff that causes AoE)
GridStatusRaidDebuff:DebuffId(zoneid, 124097, 64, 4, 4) --Sticky Resin
GridStatusRaidDebuff:DebuffId(zoneid, 123184, 65, 7, 7) --Dissonance Field (unhealable)
--GridStatusRaidDebuff:DebuffId(zoneid, 125824, 65, 3, 3) --Trapped!
GridStatusRaidDebuff:DebuffId(zoneid, 124777, 66, 4, 4) --Poison Bomb
GridStatusRaidDebuff:DebuffId(zoneid, 124821, 67, 3, 3) --Poison-Drenched Armor
--GridStatusRaidDebuff:DebuffId(zoneid, 124827, 68, 1, 1) --Poison Fumes Is actually a buff
GridStatusRaidDebuff:DebuffId(zoneid, 124849, 69, 6, 6) --Consuming Terror (fear, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 124863, 70, 6, 6) --Visions of Demise (fear/AoE, dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 124862, 71, 5, 5) --Visions of Demise: Target
GridStatusRaidDebuff:DebuffId(zoneid, 123845, 72, 5, 5) --Heart of Fear: Chosen
GridStatusRaidDebuff:DebuffId(zoneid, 123846, 73, 5, 5) --Heart of Fear: Lure
GridStatusRaidDebuff:DebuffId(zoneid, 125283, 74, 1, 1) --Sha Corruption

