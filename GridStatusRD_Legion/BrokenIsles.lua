-- local zone = "Broken Isles"
local zoneid = 619

-- for i=1,1500,1 do
--    zone = GetMapNameByID(i)
--    if zone == "Broken Isles" then
--       print(i)
--    end
-- end

-- Ana-Mouz
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Ana-Mouz")

-- Calamir
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Calamir")
-- Ancient Rage: Fire
GridStatusRaidDebuff:DebuffId(zoneid, 218888, 21, 5, 5) -- Impish Flames (non-dispellable)
-- Burning Bomb (dispellable)(TODO)
-- Wrathful Flames Ground AoE(TODO)
-- Ancient Rage: Frost
GridStatusRaidDebuff:DebuffId(zoneid, 217925, 24, 5, 5) -- Icy Comet (non-dispellable) AoE Slow
GridStatusRaidDebuff:DebuffId(zoneid, 217966, 25, 5, 5) -- Howling Gale (non-dispellable)
-- Ancient Rage: Arcane
GridStatusRaidDebuff:DebuffId(zoneid, 218012, 25, 5, 5) -- Arcanopulse (non-dispellable) DMG + Stun

-- Drugon the Frostblood
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Drugon the Frostblood")
GridStatusRaidDebuff:DebuffId(zoneid, 219602, 31, 5, 5) -- Snow Plow (non-dispellable) Fixate

-- Flotsam
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Flotsam")
GridStatusRaidDebuff:DebuffId(zoneid, 223373, 41, 5, 5) -- Yaksam (non-dispellable) Cone AoE
-- Regurgitated Marshstomper
GridStatusRaidDebuff:DebuffId(zoneid, 223355, 42, 5, 5) -- Oozing Bile (non-dispellable)

-- Humongris
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Humongris")
GridStatusRaidDebuff:DebuffId(zoneid, 216430, 51, 5, 5) -- Earthshake Stomp (non-dispellable) DMG + Stun
GridStatusRaidDebuff:DebuffId(zoneid, 216467, 52, 5, 5) -- Make the Snow (non-dispellable) AoE Frost DMG + Slow
GridStatusRaidDebuff:DebuffId(zoneid, 216822, 53, 5, 5) -- You Go Bang! (non-dispellable) Fire Bomb + DMG Increase Debuff

-- Levantus
GridStatusRaidDebuff:BossNameId(zoneid, 60, "Levantus")
GridStatusRaidDebuff:DebuffId(zoneid, 170196, 61, 5, 5) -- Rending Whirl (non-dispellable) Rend
-- Electrify DMG + Stun Dispellable (TODO)
GridStatusRaidDebuff:DebuffId(zoneid, 217362, 63, 5, 5, true, false) -- Turbulent Vortex (dispellable)
GridStatusRaidDebuff:DebuffId(zoneid, 217362, 64, 5, 5, false, true) -- Rampaging Torrent (non-dispellable) DMG + DMG Increase Debuff Stacks

-- Na'zak the Fiend
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Na'zak the Fiend")
GridStatusRaidDebuff:DebuffId(zoneid, 219349, 71, 5, 5, false, true) -- Corroding Spray (non-dispellable) Cone AoE Stacks

-- Nithogg
GridStatusRaidDebuff:BossNameId(zoneid, 80, "Nithogg")
GridStatusRaidDebuff:DebuffId(zoneid, 212867, 81, 5, 5, false, true) -- Electrical Storm (non-dispellable) Ground AoE
GridStatusRaidDebuff:DebuffId(zoneid, 212852, 82, 5, 5, false, true) -- Storm Breath (non-dispellable) DMG + DMG Increase Debuff
-- Static Charge DMG after 5 Sec (TODO)

-- Shar'thos
GridStatusRaidDebuff:BossNameId(zoneid, 90, "Shar'thos")
-- Nightmare Breath Fire Cone AoE (TODO)
GridStatusRaidDebuff:DebuffId(zoneid, 215876, 92, 5, 5, false, true) -- Burning Earth (non-dispellable) Ground AoE
GridStatusRaidDebuff:DebuffId(zoneid, 216044, 93, 5, 5, false, true) -- Cry of the Tormented (non-dispellable) AoE Fear

-- The Soultakers
GridStatusRaidDebuff:BossNameId(zoneid, 100, "The Soultakers")
-- Reaver Jdorn
GridStatusRaidDebuff:DebuffId(zoneid, 213665, 93, 5, 5, false, true) -- Marauding Mists (non-dispellable) DMG + Disorient


-- Withered J'im
GridStatusRaidDebuff:BossNameId(zoneid, 110, "Withered J'im")

