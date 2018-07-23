-- local zone = "The Emerald Nightmare"
local zoneid = 777

-- Trash
-- Nythendra
GridStatusRaidDebuff:DebuffId(zoneid, 221028, 1, 2, 2, true) -- Unstable Decay

-- Nythendra
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Nythendra")
-- Infested (Heroic)
GridStatusRaidDebuff:DebuffId(zoneid, 204504, 11, 2, 2, false, true) -- Infested
-- Stage One
-- Infested Ground
GridStatusRaidDebuff:DebuffId(zoneid, 203045, 12, 5, 5) -- Infested Ground (standing in pool)
-- Rot
GridStatusRaidDebuff:DebuffId(zoneid, 203096, 13, 6, 6, true) -- Rot (AoE people around you)
-- Volatile Rot
GridStatusRaidDebuff:DebuffId(zoneid, 204463, 14, 6, 6, true) -- Volatile Rot (exploding tank)
-- Stage Two
-- Heart of the Swarm/Burst of Corruption
GridStatusRaidDebuff:DebuffId(zoneid, 203646, 15, 5, 5, true, true) -- Burst of Corruption

-- Il'gynoth, Heart of Corruption
GridStatusRaidDebuff:BossNameId(zoneid, 20, "Il'gynoth, Heart of Corruption")
-- Stage One
-- Nightmare Corruption
GridStatusRaidDebuff:DebuffId(zoneid, 212886, 21, 4, 4) -- Nightmare Corruption (standing in pool)
-- Dispersed Spores (dot, missed Death Blossom)
GridStatusRaidDebuff:DebuffId(zoneid, 215845, 22, 1, 1, true) -- Dispersed Spores (dot)
-- The Eye of Il'gynoth
-- Nightmare Ichor
-- Fixate
GridStatusRaidDebuff:DebuffId(zoneid, 210099, 23, 7, 7) -- Fixate (fixate)
-- Touch of Corruption
GridStatusRaidDebuff:DebuffId(zoneid, 209469, 24, 8, 8, true, true) -- (dot, stacks, magic)
-- Nightmare Explosion (Mythic dot)
GridStatusRaidDebuff:DebuffId(zoneid, 209471, 25, 1, 1, true, true) -- Nightmare Explosion (dot, stacks)
-- Forces of Corruption
-- Nightmare Horror
-- Eye of Fate (tank debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 210984, 26, 3, 3, true, true) -- Eye of Fate (tank debuff, stacks)
-- Deathglare Tentacle
-- Mind Flay (interruptable)
GridStatusRaidDebuff:DebuffId(zoneid, 208697, 27, 2, 2, true) -- Mind Flay (dot)
-- Spew Corruption (dot, player drops pools)
GridStatusRaidDebuff:DebuffId(zoneid, 208929, 28, 5, 5, true) -- Spew Corruption (dot, drops pools)
-- Dominator Tentacle
-- Nighmarish Fury (buff?, stacks)
-- Stage Two
-- Cursed Blood (dot, weak bomb)
GridStatusRaidDebuff:DebuffId(zoneid, 215128, 29, 5, 5, true) -- Cursed Blood (dot, weak bomb)

-- Elerethe Renferal
GridStatusRaidDebuff:BossNameId(zoneid, 30, "Erethe Renferal")
-- Spider Form
-- Web of Pain (linked with another player)
GridStatusRaidDebuff:DebuffId(zoneid, 215307, 31, 6, 6, true) -- Web of Pain (link)
-- Necrotic Venom (dot, drops pools)
GridStatusRaidDebuff:DebuffId(zoneid, 215460, 32, 5, 5, true) -- Necrotic Venom (dot, drops pools)
-- Venomous Pool
GridStatusRaidDebuff:DebuffId(zoneid, 213124, 33, 4, 4) -- Venomous Pool (standing in pool)
-- Roc Form
-- Shimmering Feather (buff?)
-- Twisting Shadows (dot, caught in tornado)
GridStatusRaidDebuff:DebuffId(zoneid, 210850, 34, 3, 3, true) -- Twisting Shadows (dot)
-- Raking Talons (tank debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 215582, 35, 3, 3, true, true) -- Raking Talons (tank debuff, stacks)
-- Wind Burn (debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 218519, 36, 1, 1, true, true) -- Wind Burn (debuff, stacks)
-- Venomous Spiderling
-- Dripping Fangs (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 210228, 37, 2, 2, true, true) -- Dripping Fangs (dot, stacks)

-- Ursoc
GridStatusRaidDebuff:BossNameId(zoneid, 40, "Ursoc")
-- Overwhelm
GridStatusRaidDebuff:DebuffId(zoneid, 197943, 41, 5, 5, true, true) -- Overwhelm (tank debuff, stacks)
-- Rend Flesh
GridStatusRaidDebuff:DebuffId(zoneid, 204859, 42, 3, 3, true) -- Rend Flesh (dot)
-- Focused Gaze
GridStatusRaidDebuff:DebuffId(zoneid, 198006, 43, 7, 7) -- Focused Gaze (fixate)
-- Momentum
GridStatusRaidDebuff:DebuffId(zoneid, 198108, 44, 1, 1, true) -- Momentum (debuff)
-- Nightmarish Cacophony (Fear)
GridStatusRaidDebuff:DebuffId(zoneid, 197980, 45, 2, 2, true) -- Nightmarish Cacophony (fear)
-- Miasma (standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 205611, 46, 4, 4, true) -- Miasma (standing in)

-- Dragons of Nightmare
GridStatusRaidDebuff:BossNameId(zoneid, 50, "Dragons of Nightmare")
-- Shared
-- Slumbering Nightmare (stun)
GridStatusRaidDebuff:DebuffId(zoneid, 203110, 51, 3, 3, true) -- Slumbering Nightmare (stun)
-- Ysondre
-- Mark of Ysondre (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 203102, 52, 2, 2, true, true) -- Mark of Ysondre (dot, stacks)
-- Nightmare Bloom (standing in, should be at least 1 player)
GridStatusRaidDebuff:DebuffId(zoneid, 207681, 53, 4, 4, true) -- Nightmare Bloom (standing in)
-- Dread Horror
-- Wasting Dread (debuff reduces dam 50%) (disabled)
GridStatusRaidDebuff:DebuffId(zoneid, 204731, 54, 1, 1, true, false, 0, true) -- Wasting Dread (debuff)
-- Defiled Spirit
-- Defiled Vines (root, magic)
GridStatusRaidDebuff:DebuffId(zoneid, 203770, 55, 8, 8, true) -- Defiled Vines (root, magic)
-- Emeriss
-- Mark of Emeriss (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 203125, 56, 2, 2, true, true) -- Mark of Emeriss (dot, stacks)
-- Volatile Infection (AoE dot)
GridStatusRaidDebuff:DebuffId(zoneid, 203787, 57, 5, 5, true) -- Volatile Infection (AoE dot)
-- Lethon
-- Mark of Lethon (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 203086, 58, 2, 2, true, true) -- Mark of Lethon (dot, stacks)
-- Shadow Burst (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 204044, 59, 4, 4, true, true) -- Shadow Burst (dot, stacks)
-- Taerar
-- Mark of Taerar (dot, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 203121, 60, 2, 2, true, true) -- Mark of Taerar (dot, stacks)
-- Seeping Fog (dot, sleep, magic)
GridStatusRaidDebuff:DebuffId(zoneid, 205341, 61, 6, 6, true) -- Seeping Fog (dot, sleep, magic)
-- Bellowing Roar (fear)
GridStatusRaidDebuff:DebuffId(zoneid, 204078, 62, 2, 2, true) -- Bellowing Roar (fear)
-- Lumbering Mindgorger
-- Collapsing Nightmare (debuff reduces dam 50%, missed interrupt) (disabled)
GridStatusRaidDebuff:DebuffId(zoneid, 214543, 63, 1, 1, true, false, 0, true) -- Collapsing Nightmare (debuff)

-- Cenarius
GridStatusRaidDebuff:BossNameId(zoneid, 70, "Cenarius")
-- Stage One
-- Malfurion Stormrage
-- Cleansed Ground (buff)
GridStatusRaidDebuff:DebuffId(zoneid, 212681, 71, 1, 1, true) -- Cleansed Ground (buff)
-- Cenarius
-- Creeping Nightmares (debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 210279, 72, 2, 2, true, true) -- Creeping Nightmares (debuff, stacks)
-- Nightmare Brambles (dot, root, magic)
GridStatusRaidDebuff:DebuffId(zoneid, 210315, 73, 8, 8, true) -- Nightmare Brambles (dot, root, magic)
-- Nightmare Blast (tank debuff, stacks) (Mythic)
GridStatusRaidDebuff:DebuffId(zoneid, 213162, 74, 5, 5, true, true) -- Nightmare Blast (tank debuff, stacks)
-- Forces of Nightmare
-- Corrupted Wisp
-- Nightmare Ancient
-- Desiccating Stomp (melee split damage debuf, stacksf)
GridStatusRaidDebuff:DebuffId(zoneid, 226821, 75, 4, 4, true, true) -- Desiccating Stomp (melee debuff, stacks)
-- Rotten Drake
-- Twisted Sister
-- Nightmare Javelin (dot, magic)
GridStatusRaidDebuff:DebuffId(zoneid, 211507, 76, 6, 6, true) -- Nightmare Javelin (dot, magic)
-- Scorned Touch (spreading dot, slow)
GridStatusRaidDebuff:DebuffId(zoneid, 211471, 77, 5, 5, true) -- Scorned Touch (dot, spreads)
-- Allies of Nature
-- Wisp
-- Cleansed Ancient
-- Emerald Drake
-- Ancient Dream (buff)
GridStatusRaidDebuff:DebuffId(zoneid, 216516, 78, 1, 1, true, false, 0, true) -- Ancient Dream (buff)
-- Redeemed Sister
-- Unbound Touch (buff, spread Unbound Essence after 4 sec)
GridStatusRaidDebuff:DebuffId(zoneid, 211989, 79, 5, 5, true) -- Unbound Touch (buff, spreads)
-- Unbound Essence
GridStatusRaidDebuff:DebuffId(zoneid, 211990, 80, 1, 1, true, false, 0, true) -- Unbound Essence (buff)
-- Stage Two
-- Cenarius
-- Spear of Nightmares (tank debuff, stacks)
GridStatusRaidDebuff:DebuffId(zoneid, 214529, 81, 5, 5, true, true) -- Spear of Nightmares (tank debuff, stacks)

-- Xavius
GridStatusRaidDebuff:BossNameId(zoneid, 90, "Xavius")
-- The Dream (95%, 60%)
-- Dream Simulacrum (buff)
GridStatusRaidDebuff:DebuffId(zoneid, 206005, 91, 1, 1, true) -- Dream Simulacrum (buff)
-- Awakening to the Nightmare
GridStatusRaidDebuff:DebuffId(zoneid, 206109, 92, 2, 2, true) -- Awakening to the Nightmare (buff)
-- Nightmare Corruption
-- Dread Abomination
-- Unfathomable Reality
-- Descent into Madness (buff before mind control)
GridStatusRaidDebuff:DebuffId(zoneid, 208431, 93, 3, 3, true) -- Descent into Madness (buff)
-- Madness (mind control)
GridStatusRaidDebuff:DebuffId(zoneid, 207409, 94, 6, 6) -- Madness (mind control)
-- Stage One
-- Darkening Soul (dot, magic, explosion on dispel)
GridStatusRaidDebuff:DebuffId(zoneid, 206651, 95, 8, 8, true, true) -- Darkening Soul (dot, magic)
-- Nightmare Blades (fixate)
GridStatusRaidDebuff:DebuffId(zoneid, 211802, 96, 7, 7, true) -- Nightmare Blades (fixate)
-- Corruption Horror
-- Lurking Terror
-- Tormenting Fixation (fixate)
GridStatusRaidDebuff:DebuffId(zoneid, 205771, 97, 7, 7) -- Tormenting Fixation (fixate)
-- Stage Two
-- Blackening Soul (dot, magic, debuff on dispel)
GridStatusRaidDebuff:DebuffId(zoneid, 209158, 98, 8, 8) -- Blackening Soul (dot, magic)
-- Blackened? (debuff)
GridStatusRaidDebuff:DebuffId(zoneid, 205612, 99, 2, 2, true) -- Blackened? (debuff)
-- Bonds of Terror (linked with another player)
GridStatusRaidDebuff:DebuffId(zoneid, 210451, 100, 6, 6) -- Bonds of Terror (link)
-- Inconceivable Horror
-- Tainted Discharge (standing in)
GridStatusRaidDebuff:DebuffId(zoneid, 208385, 101, 4, 4) -- Tainted Discharge (standing in)
-- Stage Three
-- Nightmare Tentacle
-- The Infinite Dark? (dot, standing in environment?)
GridStatusRaidDebuff:DebuffId(zoneid, 211634, 102, 4, 4) -- The Infinite Dark (standing in?)

