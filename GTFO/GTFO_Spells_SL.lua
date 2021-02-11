--------------------------------------------------------------------------
-- GTFO_Spells_SL.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Shadowlands
]]--

if (not GTFO.ClassicMode) then

--- ***********************
--- * Shadowlands (World) *
--- ***********************

GTFO.SpellID["330102"] = {
  --desc = "Rain of Arrows (Nathanos Blightcaller)";
  sound = 1;
};

GTFO.SpellID["330095"] = {
  --desc = "Plague-Tipped Arrows (Nathanos Blightcaller)";
  sound = 1;
};

GTFO.SpellID["320006"] = {
  --desc = "Crackling Anima";
  sound = 1;
};

GTFO.SpellID["324816"] = {
  --desc = "Necrotic Breath (Rotwing Construct)";
  sound = 1;
};

GTFO.SpellID["332956"] = {
  --desc = "Necrotic Spittle (Marrowjaw)";
  sound = 1;
};

GTFO.SpellID["321362"] = {
  --desc = "Necrotic Orb";
  sound = 1;
};

GTFO.SpellID["319920"] = {
  --desc = "Unraveling Abomination";
  sound = 1;
};

GTFO.SpellID["330605"] = {
  --desc = "Death Tempest (Leacher Cvan)";
  sound = 1;
};

GTFO.SpellID["333733"] = {
  --desc = "Cone of Death (Sharrex the Fleshcrafter)";
  sound = 1;
};

GTFO.SpellID["342582"] = {
  --desc = "Death Fog (Mi'kai, As Argus, the Unmaker)";
  sound = 1;
};

GTFO.SpellID["343421"] = {
  --desc = "Cursed Heart (Astra, As Azshara)";
  sound = 1;
};

GTFO.SpellID["340634"] = {
  --desc = "Fungistorm (Humon'gozz)";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["334562"] = {
  --desc = "Suppress (Leerok the Scryer)";
  sound = 2;
};

GTFO.SpellID["323811"] = {
  --desc = "Pulsing Bile (Bubbleblood)";
  sound = 1;
};

GTFO.SpellID["338789"] = {
  --desc = "Forge Exhaust (Anima Forge)";
  sound = 1;
};

GTFO.SpellID["344413"] = {
  --desc = "Acid Splash (Ikras the Devourer)";
  sound = 1;
};

GTFO.SpellID["328879"] = {
  --desc = "Hindering Soot";
  sound = 2;
};

GTFO.SpellID["339040"] = {
  --desc = "Withered Winds (Oranomonos the Everbranching)";
  sound = 1;
};

GTFO.SpellID["327471"] = {
  --desc = "Noxious Cloud (Custodian Thonar)";
  sound = 1;
};

GTFO.SpellID["344462"] = {
  --desc = "Soul Slag";
  sound = 1;
};

GTFO.SpellID["338085"] = {
  --desc = "Necrosis (Xantuth the Blighted)";
  sound = 1;
};

GTFO.SpellID["323800"] = {
  --desc = "Putrid Bile";
  sound = 1;
};

GTFO.SpellID["338410"] = {
  --desc = "Rain of Felfire (Mistress Dyrax)";
  sound = 1;
};

GTFO.SpellID["338367"] = {
  --desc = "Molten Stomp (Unbreakable Urtz)";
  sound = 1;
};

GTFO.SpellID["337874"] = {
  --desc = "Entropic Focus (Ti'or)";
  sound = 1;
};

GTFO.SpellID["308030"] = {
  --desc = "Fanning the Flames (Flameforge Enforcer)";
  sound = 1;
};

GTFO.SpellID["346597"] = {
  --desc = "Soul Bomb (Anima Devourer)";
  sound = 1;
};

--- **********************
--- * Halls of Atonement *
--- **********************

GTFO.SpellID["323001"] = {
  --desc = "Glass Shards (Halkias)";
  sound = 1;
};

GTFO.SpellID["324044"] = {
  --desc = "Refracted Sinlight (Halkias)";
  sound = 1;
};

GTFO.SpellID["319703"] = {
  --desc = "Blood Torrent (Echelon)";
  sound = 1;
};

GTFO.SpellID["323853"] = {
  --desc = "Pulse from Beyond (Ghastly Parishioner) -- Area damage version";
  sound = 0;
};

GTFO.SpellID["326891"] = {
  --desc = "Anguish (Inquisitor Sigar)";
  sound = 1;
};

GTFO.SpellID["324211"] = {
  --desc = "Gaseous Collapse";
  sound = 1;
};

--- **************
--- * Plaguefall *
--- **************

GTFO.SpellID["330069"] = {
  --desc = "Concentrated Plague";
  applicationOnly = true;
  soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 330069);
		if (stacks >= 3) then
			return 1;
		elseif (stacks > 1) then
			return 2;
		end
		return 0;
	end;
};

GTFO.SpellID["327552"] = {
  --desc = "Doom Shroom (Doom Shroom) - AOE Explosion - Unavoidable";
  sound = 0;
};

GTFO.SpellID["330513"] = {
  --desc = "Doom Shroom (Doom Shroom)";
  sound = 1;
};

GTFO.SpellID["320072"] = {
  --desc = "Toxic Pool (Decaying Flesh Giant)";
  sound = 1;
};

GTFO.SpellID["319120"] = {
  --desc = "Putrid Bile (Gushing Slime)";
  sound = 1;
};

GTFO.SpellID["330135"] = {
  --desc = "Fount of Pestilence (Margrave Stradama)";
  applicationOnly = true;
  sound = 1;
};

--- *******************
--- * Sanguine Depths *
--- *******************

GTFO.SpellID["334676"] = {
  --desc = "Sanctified Mists";
  sound = 1;
};

GTFO.SpellID["323573"] = {
  --desc = "Residue (Fleeting Manifestation)";
  sound = 1;
};

GTFO.SpellID["322212"] = {
  --desc = "Growing Mistrust (Vestige of Doubt)";
  sound = 1;
};

--- ***********************
--- * Spires of Ascension *
--- ***********************

GTFO.SpellID["324662"] = {
  --desc = "Charged Spear (Kin-Tara)";
  sound = 1;
};

GTFO.SpellID["317626"] = {
  --desc = "Maw-Touched Venom";
  sound = 1;
};

GTFO.SpellID["323739"] = {
  --desc = "Residual Impact (Forsworn Squad-Leader)";
  sound = 1;
};

GTFO.SpellID["323792"] = {
  --desc = "Volatile Anima";
  sound = 1;
};

GTFO.SpellID["339080"] = {
  --desc = "Surging Anima";
  sound = 1;
};

GTFO.SpellID["341215"] = {
  --desc = "Volatile Anima";
  sound = 1;
};

GTFO.SpellID["331251"] = {
  --desc = "Deep Connection (Azules)";
  applicationOnly = true;
  sound = 1;
};

--- *************************
--- * Mists of Tirna Scithe *
--- *************************

GTFO.SpellID["325027"] = {
  --desc = "Bramble Burst (Drust Boughbreaker)";
  sound = 1;
};

GTFO.SpellID["323250"] = {
  --desc = "Anima Puddle (Droman Oulfarran)";
  sound = 1;
};

GTFO.SpellID["331721"] = {
  --desc = "Spear Flurry";
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["326017"] = {
  --desc = "Decomposing Acid (Spinemaw Larva)";
  sound = 1;
};

GTFO.SpellID["326309"] = {
  --desc = "Decomposing Acid (Tred'ova)";
  sound = 1;
};

--- *******************
--- * Theater of Pain *
--- *******************

GTFO.SpellID["320180"] = {
  --desc = "Noxious Spore (Paceran the Virulent)";
  sound = 1;
};

GTFO.SpellID["337037"] = {
  --desc = "Whirling Blade (Nekthara the Mangler)";
  sound = 1;
};

GTFO.SpellID["323130"] = {
  --desc = "Coagulating Ooze (Gorechop)";
  sound = 1;
};

GTFO.SpellID["323681"] = {
  --desc = "Dark Devastation (Mordretha, the Endless Empress)";
  sound = 1;
};

GTFO.SpellID["323750"] = {
  --desc = "Vile Gas";
  sound = 1;
};

GTFO.SpellID["342103"] = {
  --desc = "Rancid Bile (Rancid Gasbag)";
  sound = 1;
};



--- *********************
--- * The Necrotic Wake *
--- *********************

GTFO.SpellID["320646"] = {
  --desc = "Fetid Gas (Blightbone)";
  sound = 1;
};

GTFO.SpellID["320614"] = {
  --desc = "Blood Gorge (Carrion Worm)";
  sound = 1;
};

GTFO.SpellID["320573"] = {
  --desc = "Shadow Well";
  sound = 1;
};

GTFO.SpellID["320574"] = {
  --desc = "Shadow Well";
  sound = 1;
};

GTFO.SpellID["327100"] = {
  --desc = "Noxious Fog";
  sound = 1;
};

GTFO.SpellID["320366"] = {
  --desc = "Embalming Ichor (Surgeon Stitchflesh)";
  sound = 1;
};

GTFO.SpellID["333485"] = {
  --desc = "Disease Cloud (Rotspew)";
  sound = 1;
  test = true;
};

GTFO.SpellID["321956"] = {
  --desc = "Comet Storm (Nalthor the Rimebinder)";
  sound = 1;
};

GTFO.SpellID["320784"] = {
  --desc = "Comet Storm (Nalthor the Rimebinder)";
  sound = 1;
};

--- *****************
--- * De Other Side *
--- *****************

GTFO.SpellID["334496"] = {
  --desc = "Soporific Shimmerdust (Weald Shimmermoth)";
  applicationOnly = true;
  minimumStacks = 6;
  sound = 1;
};

GTFO.SpellID["333250"] = {
  --desc = "Reaver (Risen Warlord)";
  sound = 1;
};

GTFO.SpellID["332729"] = {
  --desc = "Malefic Blast (Malefic Spirit)";
  sound = 1;
};

GTFO.SpellID["332332"] = {
  --desc = "Spilled Essence (Son of Hakkar)";
  sound = 1;
};

GTFO.SpellID["332672"] = {
  --desc = "Bladestorm (Atal'ai Deathwalker)";
  sound = 1;
  tankSound = 0;
  test = true;
};

GTFO.SpellID["323569"] = {
  --desc = "Spilled Essence (Son of Hakkar)";
  sound = 1;
};

GTFO.SpellID["333790"] = {
  --desc = "Enraged Mask (Enraged Spirit)";
  sound = 1;
  casterOnly = true;
};

GTFO.SpellID["331933"] = {
  --desc = "Haywire (Defunct Dental Drill)";
  sound = 0;
  soundHeroic = 2;
  soundChallenge = 1;
  soundMythic = 1;
};

GTFO.SpellID["331126"] = {
  --desc = "Super Icky Sticky";
  sound = 1;
};

--- ************
--- * Torghast *
--- ************

GTFO.SpellID["319837"] = {
  --desc = "Spike";
  sound = 1;
};

GTFO.SpellID["329377"] = {
  --desc = "Torturous Leer (Animimic)";
  sound = 1;
};

GTFO.SpellID["294607"] = {
  --desc = "Death Pool";
  sound = 1;
};

GTFO.SpellID["328879"] = {
  --desc = "Creeping Sins (Patrician Cromwell)";
  sound = 1;
};

--- ******************
--- * Castle Nathria *
--- ******************

GTFO.SpellID["340324"] = {
  --desc = "Sanguine Ichor (Shriekwing)";
  sound = 1;
};


GTFO.SpellID["334893"] = {
  --desc = "Stone Shards (Hecutis)";
  sound = 1;
};

GTFO.SpellID["328579"] = {
  --desc = "Smoldering Remnants (Kael'thas)";
  sound = 1;
};

GTFO.SpellID["346945"] = {
  --desc = "Manifest Pain (Baroness Frieda)";
  sound = 1;
};

GTFO.SpellID["327992"] = {
  --desc = "Desolation (Sire Denathrius)";
  sound = 1;
};

GTFO.SpellID["340630"] = {
  --desc = "Rotting";
  applicationOnly = true;
  sound = 1;
  tankSound = 0;
};

GTFO.SpellID["339553"] = {
  --desc = "Lingering Anima (Deplina)";
  sound = 1;
};

GTFO.SpellID["325713"] = {
  --desc = "Lingering Anima (Lady Inerva Darkvein)";
  sound = 1;
};

GTFO.SpellID["339603"] = {
  --desc = "Shared Suffering (Fara)";
  sound = 4;
  negatingDebuffSpellID = 324982; -- Shared Suffering
  --negatingDebuffSpellID = 339607; -- Shared Suffering 2
};

GTFO.SpellID["325004"] = {
  --desc = "Shared Suffering (Lady Inerva Darkvein)";
  sound = 4;
  negatingDebuffSpellID = 324982; -- Shared Suffering
  --negatingDebuffSpellID = 324983; -- Shared Suffering 2
};

GTFO.SpellID["326538"] = {
  --desc = "Anima Web (Lady Inerva Darkvein)";
  sound = 1;
  applicationOnly = true;
};

GTFO.SpellID["331637"] = {
  --desc = "Dark Recital (Lord Stavros)";
  negatingDebuffSpellID = 331637; -- Dark Recital
  sound = 1;
};

GTFO.SpellID["331638"] = {
  --desc = "Dark Recital (Lord Stavros) - Too far";
  sound = 4;
};

GTFO.SpellID["347425"] = {
  --desc = "Dark Recital (Lord Stavros) - successful";
  sound = 0;
};

GTFO.SpellID["334743"] = {
  --desc = "Dark Recital (Lord Stavros) - Empowered Circles?";
  sound = 1;
  test = true;
};

GTFO.SpellID["335361"] = {
  --desc = "Stonequake (Sludgefist)";
  sound = 1;
};

GTFO.SpellID["332734"] = {
  --desc = "Indignation (Sire Denathrius)";
  sound = 1;
};

GTFO.SpellID["335873"] = {
  --desc = "Rancor (Remornia)";
  sound = 1;
};

end
