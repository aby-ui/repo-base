--local zone = "Highmaul"
local zoneid = 612

--zoneid, debuffID, order, icon_priority, colorpriority, timer, stackable, color, defaultdisable, noicon
--, true, true is for stackable

-- Check Compatibility
if GridStatusRD_WoD.rd_version < 600 then
	return
end

--Trash
GridStatusRaidDebuff:DebuffId(zoneid, 175601, 1, 5, 5) -- Trash TAINTED CLAWS
GridStatusRaidDebuff:DebuffId(zoneid, 175599, 1, 4, 4) -- Trash DEVOUR
GridStatusRaidDebuff:DebuffId(zoneid, 172069, 1, 5, 5) -- Trash RADIATING POISON
GridStatusRaidDebuff:DebuffId(zoneid, 172066, 1, 4, 4) -- Trash RADIATING POISON
GridStatusRaidDebuff:DebuffId(zoneid, 166779, 1, 5, 5) -- Trash STAGGERING BLOW
GridStatusRaidDebuff:DebuffId(zoneid, 56037, 1,  4, 4) -- Trash RUNE OF DESTRUCTION
GridStatusRaidDebuff:DebuffId(zoneid, 175654, 1, 5, 5) -- Trash RUNE OF DISINTEGRATION
GridStatusRaidDebuff:DebuffId(zoneid, 166185, 1, 5, 5) -- Trash RENDING SLASH
GridStatusRaidDebuff:DebuffId(zoneid, 166175, 1, 5, 5) -- Trash EARTHDEVASTATING SLAM
GridStatusRaidDebuff:DebuffId(zoneid, 174404, 1, 5, 5) -- Trash FROZEN CORE
GridStatusRaidDebuff:DebuffId(zoneid, 173763, 1, 5, 5) -- Trash WILD FLAMES
GridStatusRaidDebuff:DebuffId(zoneid, 174500, 1, 5, 5) -- Trash RENDING THROW
GridStatusRaidDebuff:DebuffId(zoneid, 174939, 1, 4, 4) -- Trash Time Stop
GridStatusRaidDebuff:DebuffId(zoneid, 172115, 1, 4, 4) -- Trash Earthen Thrust
GridStatusRaidDebuff:DebuffId(zoneid, 166200, 1, 4, 4) -- Trash ARCANEVOLATILITY
GridStatusRaidDebuff:DebuffId(zoneid, 174473, 1, 5, 5) -- Trash Corrupted Blood

--The Butcher
GridStatusRaidDebuff:BossNameId(zoneid, 10, "The Butcher")
GridStatusRaidDebuff:DebuffId(zoneid, 156152, 11, 5, 5, true, true) --GUSHING WOUNDS
GridStatusRaidDebuff:DebuffId(zoneid, 156151, 12, 6, 6) --THE TENDERIZER
GridStatusRaidDebuff:DebuffId(zoneid, 156143, 13, 5, 5, true, true) --THE CLEAVER
GridStatusRaidDebuff:DebuffId(zoneid, 163046, 14, 5, 5) --PALE VITRIOL

--Kargath Bladefist
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Kargath Bladefist")
GridStatusRaidDebuff:DebuffId(zoneid, 159113, 21, 5, 5) --IMPALE
GridStatusRaidDebuff:DebuffId(zoneid, 159178, 22, 6, 6) --OPENWOUNDS
GridStatusRaidDebuff:DebuffId(zoneid, 159213, 23, 7, 7) --MONSTERS BRAWL
GridStatusRaidDebuff:DebuffId(zoneid, 158986, 24, 4, 4) --BERSERKER RUSH
GridStatusRaidDebuff:DebuffId(zoneid, 159410, 25, 5, 5) --MAULING BREW
GridStatusRaidDebuff:DebuffId(zoneid, 160521, 26, 6, 6) --VILE BREATH
GridStatusRaidDebuff:DebuffId(zoneid, 159386, 27, 5, 5) --IRON BOMB
GridStatusRaidDebuff:DebuffId(zoneid, 159188, 28, 5, 5) --GRAPPLE
GridStatusRaidDebuff:DebuffId(zoneid, 162497, 29, 4, 4) --ON THE HUNT
GridStatusRaidDebuff:DebuffId(zoneid, 159202, 30, 5, 5) --FLAME JET

--Twin Ogron 
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Twin Ogron")
GridStatusRaidDebuff:DebuffId(zoneid, 158026, 41, 6, 6) --ENFEEBLING ROAR
GridStatusRaidDebuff:DebuffId(zoneid, 158241, 42, 5, 5, true, true) --BLAZE
GridStatusRaidDebuff:DebuffId(zoneid, 155569, 43, 5, 5) --INJURED
GridStatusRaidDebuff:DebuffId(zoneid, 167200, 44, 5, 5, true, true) --ARCANE WOUND
GridStatusRaidDebuff:DebuffId(zoneid, 159709, 45, 6, 6, true, true) --WEAKENED DEFENSES 159709 167179
GridStatusRaidDebuff:DebuffId(zoneid, 163374, 46, 4, 4) --ARCANE VOLATILITY
GridStatusRaidDebuff:DebuffId(zoneid, 158200, 47, 4, 4) --QUAKE

--Ko'ragh
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Ko'ragh")
GridStatusRaidDebuff:DebuffId(zoneid, 161242, 51, 4, 4) --CAUSTIC ENERGY
GridStatusRaidDebuff:DebuffId(zoneid, 161358, 52, 4, 4) --SUPPRESSION FIELD
GridStatusRaidDebuff:DebuffId(zoneid, 162184, 53, 6, 6) --EXPEL MAGIC SHADOW
GridStatusRaidDebuff:DebuffId(zoneid, 162186, 54, 6, 6) --EXPEL MAGIC ARCANE
GridStatusRaidDebuff:DebuffId(zoneid, 161411, 55, 6, 6) --EXPEL MAGIC FROST
GridStatusRaidDebuff:DebuffId(zoneid, 163472, 56, 4, 4) --DOMINATING POWER
GridStatusRaidDebuff:DebuffId(zoneid, 162185, 57, 7, 7) --EXPEL MAGIC FEL
--GridStatusRaidDebuff:DebuffId(zoneid, 156803, 57, 7, 7) --NULLIFICATION BARRIER

--Tectus
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Tectus")
GridStatusRaidDebuff:DebuffId(zoneid, 162346, 61, 5, 5) --CRYSTALLINE BARRAGE
GridStatusRaidDebuff:DebuffId(zoneid, 162892, 62, 5, 5) --PETRIFICATION
GridStatusRaidDebuff:DebuffId(zoneid, 162475, 63, 5, 5) --Tectonic Upheaval

--Brackenspore
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Brackenspore")
GridStatusRaidDebuff:DebuffId(zoneid, 163242, 71, 5, 5, true, true) --INFESTING SPORES
GridStatusRaidDebuff:DebuffId(zoneid, 163590, 72, 5, 5) --CREEPING MOSS
GridStatusRaidDebuff:DebuffId(zoneid, 163241, 73, 5, 5, true, true) --ROT
GridStatusRaidDebuff:DebuffId(zoneid, 159220, 74, 6, 6) --NECROTIC BREATH
GridStatusRaidDebuff:DebuffId(zoneid, 160179, 75, 6, 6) --MIND FUNGUS
GridStatusRaidDebuff:DebuffId(zoneid, 159972, 76, 6, 6, true, true) --FLESHEATER

--Imperator Mar'gok 
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Imperator Mar'gok")
GridStatusRaidDebuff:DebuffId(zoneid, 156238, 81, 4, 4) --BRANDED  156238 163990 163989 163988
GridStatusRaidDebuff:DebuffId(zoneid, 156467, 82, 5, 5) --DESTRUCTIVE RESONANCE  156467 164075 164076 164077
GridStatusRaidDebuff:DebuffId(zoneid, 158605, 83, 4, 4) --MARK OF CHAOS  158605 164176 164178 164191
GridStatusRaidDebuff:DebuffId(zoneid, 164004, 84, 4, 4) --BRANDED DISPLACEMENT
GridStatusRaidDebuff:DebuffId(zoneid, 164075, 85, 4, 4) --DESTRUCTIVE RESONANCE DISPLACEMENT
GridStatusRaidDebuff:DebuffId(zoneid, 164176, 86, 4, 4) --MARK OF CHAOS DISPLACEMENT
GridStatusRaidDebuff:DebuffId(zoneid, 164005, 87, 4, 4) --BRANDED FORTIFICATION
GridStatusRaidDebuff:DebuffId(zoneid, 164076, 88, 4, 4) --DESTRUCTIVE RESONANCE FORTIFICATION
GridStatusRaidDebuff:DebuffId(zoneid, 164178, 89, 4, 4) --MARK OF CHAOS FORTIFICATION
GridStatusRaidDebuff:DebuffId(zoneid, 164006, 90, 4, 4) --BRANDED REPLICATION
GridStatusRaidDebuff:DebuffId(zoneid, 164077, 91, 4, 4) --DESTRUCTIVE RESONANCE REPLICATION
GridStatusRaidDebuff:DebuffId(zoneid, 164191, 92, 4, 4) --MARK OF CHAOS REPLICATION
GridStatusRaidDebuff:DebuffId(zoneid, 157349, 93, 5, 5) --FORCE NOVA  157349 164232 164235 164240
GridStatusRaidDebuff:DebuffId(zoneid, 157763, 94, 4, 4) --FIXATE
GridStatusRaidDebuff:DebuffId(zoneid, 158553, 95, 6, 6, true, true) --CRUSH ARMOR
GridStatusRaidDebuff:DebuffId(zoneid, 165102, 96, 7, 7) --Infinite Darkness
GridStatusRaidDebuff:DebuffId(zoneid, 157801, 97, 7, 7) --Slow
