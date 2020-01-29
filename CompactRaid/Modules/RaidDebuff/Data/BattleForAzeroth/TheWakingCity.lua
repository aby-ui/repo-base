------------------------------------------------------------
-- TheWakingCity.lua
--
-- Rowan
-- 2020/01/18
------------------------------------------------------------

local module = CompactRaid:GetModule("RaidDebuff")
if not module then end

local TIER = 8
local INSTANCE = 1180 -- the Waking City
local BOSS

BOSS = 2368 -- Wrathion
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306015) -- Searing Armor
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306111) -- Incineration
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307013) -- Burning Madness
module:RegisterDebuff(TIER, INSTANCE, BOSS, 314347) -- Noxious Choke

BOSS = 2365 -- Maut
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307805) -- Devour Magic
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307399) -- Shadow Wounds
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306301) -- Forbidden Mana
module:RegisterDebuff(TIER, INSTANCE, BOSS, 314992) -- Drain Essence

BOSS = 2369 -- The Prophet Skitra
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307937) -- Shred Psyche
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307977) -- Shadow Shock
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309687) -- Psychic Outburst
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307445) -- Illusionary Projection
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307784) -- Clouded Mind
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307785) -- Twisted Mind
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309657) -- Dark Ritual

BOSS = 2377 -- Dark Inquisitor
module:RegisterDebuff(TIER, INSTANCE, BOSS, 311551) -- Abyssal Strike 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 311383) -- Torment 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 312406) -- Voidwoken
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313198) -- Void-Touched

BOSS = 2372 -- The Hivemind
module:RegisterDebuff(TIER, INSTANCE, BOSS, 315311) -- Ravage
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307637) -- Accelerated Evolution
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313652) -- Mind-Numbing Nova
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313460) -- Nullification 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313461) -- Corrosion 

BOSS = 2367 -- Shad'har the Insatiable
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307471) -- Crush 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307472) -- Dissolve 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307358) -- Debilitating Spit 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 312099) -- Tasty Morsel 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 312332) -- Slimy Residue 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 308177) -- Entropic Buildup
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306934) -- Entropic Mantle
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306930) -- Entropic Breath 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306929) -- Bubbling Breath

BOSS = 2373 -- Drest'agath
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310277) -- Volatile Seed 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310406) -- Void Glare
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310358) -- Mutterings of Insanity
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310563) -- Mutterings of Betrayal
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310552) -- Mind Flay
module:RegisterDebuff(TIER, INSTANCE, BOSS, 308377) -- Void Infused Ichor
module:RegisterDebuff(TIER, INSTANCE, BOSS, 317001) -- Umbral Aversion
module:RegisterDebuff(TIER, INSTANCE, BOSS, 308377) -- Void Infused Ichor

BOSS = 2374 -- Il'gynoth
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309961) -- Eye of N'Zoth 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 318396) -- Reconstituted Blood 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 311159) -- Cursed Blood
module:RegisterDebuff(TIER, INSTANCE, BOSS, 312486) -- Recurring Nightmare

BOSS = 2370 -- Vexiona
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307359) -- Despair 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307019) -- Void Corruption  
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307421) -- Annihilation 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307284) -- Terrifying Presence 

BOSS = 2364 -- Ra-den
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306819) -- Nullifying Strike
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313227) -- Decaying Wound
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313109) -- Unstable Nightmare
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306257) -- Unstable Vita
module:RegisterDebuff(TIER, INSTANCE, BOSS, 315258) -- Dread Inferno
module:RegisterDebuff(TIER, INSTANCE, BOSS, 310019) -- Charged Bonds 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309852) -- Ruin
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306733) -- Void Empowered
module:RegisterDebuff(TIER, INSTANCE, BOSS, 316065) -- Corrupted Existence
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306279) -- Instability Exposure
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309777) -- Void Defilement
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306184) -- Unleashed Void

BOSS = 2366 -- Carapace of N'Zoth
module:RegisterDebuff(TIER, INSTANCE, BOSS, 315954) -- Black Scar
module:RegisterDebuff(TIER, INSTANCE, BOSS, 306984) -- Insanity Bomb 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 316847) -- Adaptive Membrane
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313330) -- Grace of the Black Prince
module:RegisterDebuff(TIER, INSTANCE, BOSS, 307044) -- Nightmare Antibody
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313334) -- Gift of N'Zoth 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313364) -- Mental Decay
module:RegisterDebuff(TIER, INSTANCE, BOSS, 317627) -- Infinite Void

BOSS = 2375 -- N'Zoth
module:RegisterDebuff(TIER, INSTANCE, BOSS, 316711) -- Mindwrack 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313184) -- Synaptic Shock 
module:RegisterDebuff(TIER, INSTANCE, BOSS, 317874) -- Stupefying Glare
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309980) -- Paranoia
module:RegisterDebuff(TIER, INSTANCE, BOSS, 309991) -- Anguish
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313609) -- Gift of N'Zoth
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313400) -- Corrupted Mind
module:RegisterDebuff(TIER, INSTANCE, BOSS, 313610) -- Mental Decay

BOSS = 0 -- Trash
