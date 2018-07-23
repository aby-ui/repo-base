local Ellipsis	= _G['Ellipsis']

-- ------------------------
-- DATA: NOTARGET
-- ------------------------
local dataNoTargetFake = {			-- auras that need to be faked due to lack of API feedback
	-- DEATH KNIGHT
	[43265]		= 10,	-- Death and Decay
	[152280]	= 10,	-- Defile
	-- DEMON HUNTER
	[196718]	= 8,	-- Darkness
	-- DRUID
	[78675]		= 8,	-- Solar Beam
	[204066]	= 8,	-- Lunar Beam
	[205636]	= 10,	-- Force of Nature
	-- HUNTER
	[1543]		= 20,	-- Flare
	[194277]	= 15,	-- Caltrops
	[201430]	= 12,	-- Stampede
	-- MAGE
	[55342]		= 40,	-- Mirror Image
	[190356]	= 8,	-- Blizzard
	-- MONK
	[132578]	= 45,	-- Invoke Niuzao, the Black Ox
	[166646]	= 45,	-- Invoke Xuen, the White Tiger
	[198664]	= 45,	-- Invoke Chi-Ji, the Red Crane
	-- PRIEST
	[34433]		= 12,	-- Shadowfiend
	[62618]		= 10,	-- Power Word: Barrier
	[68136]		= 12,	-- Shadowfiend
	[123040]	= 12,	-- Mindbender (Discipline)
	[200174]	= 15,	-- Mindbender (Shadow)
	-- ROGUE
	[1725]		= 10,	-- Distract
	-- SHAMAN
	[51533]		= 15,	-- Feral Spirit
	[192249]	= 60,	-- Storm Elemental
	[198067]	= 60,	-- Fire Elemental
	[198103]	= 60,	-- Earth Elemental
	-- WARLOCK
	[1122]		= 25,	-- Summon Infernal
	[5740]		= 8,	-- Rain of Fire
	[18540]		= 25,	-- Summon Doomguard
	[111859]	= 25,	-- Grimoire: Imp
	[111895]	= 25,	-- Grimoire: Voidwalker
	[111896]	= 25,	-- Grimoire: Succubus
	[111897]	= 25,	-- Grimoire: Felhunter
	[111898]	= 25,	-- Grimoire: Felguard
}

local dataNoTargetFakeHasted = {	-- faked auras affected by haste that need their durations corrected on spawn
	-- WARLOCK
	[5740]		= true,
}

local dataNoTargetRedirect = {		-- auras that need to be redirected from their spawning unit to notarget (eg, gtaoe with feedback)
	-- DRUID
	[191034]	= true,	-- Starfall
	-- SHAMAN
	[73920]		= true,	-- Healing Rain
	[215864]	= true,	-- Rainfall
}

function Ellipsis:GetDataNoTarget()
	return dataNoTargetFake, dataNoTargetFakeHasted, dataNoTargetRedirect
end


-- ------------------------
-- DATA: UNIQUE AURAS
-- ------------------------
local dataUniqueAuras = {
	-- DEMON HUNTER
	[217832]	= true,	-- Imprison
	-- DRUID
	[33763]		= true,	-- Lifebloom
	-- MAGE
	[118]		= true,	-- Polymorph
	[28272]		= true, -- Polymorph (Pig)
	[28271]		= true, -- Polymorph (Turtle)
	[161372]	= true, -- Polymorph (Turtle)
	[61305]		= true, -- Polymorph (Black Cat)
	[61780]		= true, -- Polymorph (Turkey)
	[161355]	= true, -- Polymorph (Penguin)
	[161353]	= true, -- Polymorph (Polar Bear Cub)
	[61721]		= true, -- Polymorph (Rabbit)
	[161354]	= true, -- Polymorph (Monkey)
	[126819]	= true, -- Polymorph (Pig)
	[114923]	= true, -- Nether Tempest
	-- MONK
	[115078]	= true,	-- Paralysis
	-- PRIEST
	[9484]		= true,	-- Shackle Undead
	-- ROGUE
	[6770]		= true,	-- Sap
	-- SHAMAN
	[51514]		= true,	-- Hex
	[210873]	= true,	-- Hex (Compy)
	[211004]	= true,	-- Hex (Spider)
	[211010]	= true,	-- Hex (Snake)
	[211015]	= true,	-- Hex (Cockroach)
	-- WARLOCK
	[710]		= true,	-- Banish
	[80240]		= true, -- Havoc
	[118699]	= true,	-- Fear
}

function Ellipsis:GetDataUniqueAuras()
	return dataUniqueAuras
end
