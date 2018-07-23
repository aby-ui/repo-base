--------------------------------------------------------------------------
-- GTFO_Spells_WOD.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Warlords of Draenor
Author: Zensunim of Malygos
]]--

-- ***********
-- * Draenor *
-- ***********


GTFO.SpellID["171406"] = {
	--desc = "Burning (Kargathar Proving Grounds)";
	sound = 1;
};

GTFO.SpellID["164177"] = {
	--desc = "Magma Pool (Blackrock Slaghauler)";
	sound = 1;
};


GTFO.SpellID["166031"] = {
	--desc = "Crush (Ogron Warcrusher)";
	sound = 1;
};

GTFO.SpellID["166534"] = {
	--desc = "Ruptured Earth (Gronn)";
	sound = 1;
};

GTFO.SpellID["161918"] = {
	--desc = "Fiery Ground (Blazing Pyreclaw)";
	sound = 1;
};

GTFO.SpellID["178601"] = {
	--desc = "Shocking Ground (Shadowmoon Ritualist)";
	sound = 1;
};

GTFO.SpellID["158238"] = {
	--desc = "Blaze";
	sound = 1;
};

GTFO.SpellID["176623"] = {
	--desc = "Sulfuric Acid Pool";
	sound = 1;
};

GTFO.SpellID["176623"] = {
	--desc = "Sulfur Cloud";
	sound = 1;
};

GTFO.SpellID["171040"] = {
	--desc = "Smoldering Charge (Crate Lord Igneous)";
	sound = 1;
};

GTFO.SpellID["171177"] = {
	--desc = "Immolating Embers (Charl Doomwing)";
	sound = 1;
};

GTFO.SpellID["175933"] = {
	--desc = "Fel Comet (Mongrethod)";
	sound = 1;
};

GTFO.SpellID["176573"] = {
	--desc = "Fel Firestorm (Mongrethod)";
	sound = 1;
};

GTFO.SpellID["159980"] = {
	--desc = "Fel Firebomb";
	sound = 1;
};

GTFO.SpellID["168352"] = {
	--desc = "Flame Crash (Gorebound Demonguard)";
	sound = 1;
};

GTFO.SpellID["171581"] = {
	--desc = "Firestorm Breath (Venombarb)";
	sound = 1;
};

GTFO.SpellID["172763"] = {
	--desc = "Firestorm Breath (Venombarb)";
	sound = 1;
};

GTFO.SpellID["147493"] = {
	--desc = "Blade Flurry (Shattered Hand Flayer)";
	sound = 1;
};

GTFO.SpellID["158103"] = {
	--desc = "Electrified Cloud (Sun-Talon Oberyx)";
	sound = 1;
};

GTFO.SpellID["158537"] = {
	--desc = "Toxic Pool (Darkhide Leaper)";
	sound = 1;
};

GTFO.SpellID["173210"] = {
	--desc = "Fel Firebomb (Vorpil Ribcleaver)";
	sound = 1;
};

GTFO.SpellID["173210"] = {
	--desc = "Noxious Bomb (Fervid Adherent)";
	sound = 1;
};

GTFO.SpellID["165823"] = {
	--desc = "Incinerator (The Burninator)";
	sound = 1;
};

GTFO.SpellID["173210"] = {
	--desc = "Fel Flames (Tezzakel)";
	sound = 1;
};

GTFO.SpellID["173968"] = {
	--desc = "Vile Poison (Gruesome Torturer)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["166002"] = {
	--desc = "Disintegration";
	sound = 1;
};

GTFO.SpellID["175294"] = {
	--desc = "Lava Burn";
	sound = 1;
};

GTFO.SpellID["173611"] = {
	--desc = "Lava";
	sound = 1;
	negatingDebuffSpellID = 170153; -- Lava Slimed
};

GTFO.SpellID["161894"] = {
	--desc = "Frosted Ground";
	sound = 1;
};

GTFO.SpellID["178583"] = {
	--desc = "Frosted Ground";
	sound = 1;
};

GTFO.SpellID["176119"] = {
	--desc = "Stinging Sands (Spirit of Kairozdormu)";
	sound = 1;
};

GTFO.SpellID["176473"] = {
	--desc = "Petrifying Breath (Spirit of Kairozdormu)";
	sound = 1;
};

GTFO.SpellID["151630"] = {
	--desc = "Blazing Shot (Commander Vorka)";
	sound = 1;
};

GTFO.SpellID["176037"] = {
	--desc = "Noxious Spit (Tarlna the Ageless)";
	sound = 1;
};

GTFO.SpellID["157623"] = {
	--desc = "Detected!";
	sound = 1;
};

GTFO.SpellID["170009"] = {
	--desc = "Soul Siphon";
	sound = 1;
	test = true;
};

GTFO.SpellID["173205"] = {
	--desc = "Shadow Beam";
	sound = 1;
};

GTFO.SpellID["169039"] = {
	--desc = "Fel Flames";
	sound = 2;
};

GTFO.SpellID["176726"] = {
	--desc = "Demonic Gateway";
	sound = 2;
};

GTFO.SpellID["174878"] = {
	--desc = "Fel Firebomb";
	sound = 1;
};

GTFO.SpellID["158441"] = {
	--desc = "Solar Zone (Solar Familiar)";
	sound = 2;
};

GTFO.SpellID["155963"] = {
	--desc = "Lavastrike (Slavemaster Ok'mok)";
	sound = 1;
};

GTFO.SpellID["162679"] = {
	--desc = "Wild Arcane (No'losh)";
	sound = 1;
};

GTFO.SpellID["162686"] = {
	--desc = "Wild Arcane (No'losh)";
	sound = 1;
};

GTFO.SpellID["176778"] = {
	--desc = "Energy Field (Spirit of Exarch Hataaru)";
	sound = 1;
};

GTFO.SpellID["176871"] = {
	--desc = "Heaven's Wrath (Spirit of Maraad)";
	sound = 1;
};

GTFO.SpellID["167687"] = {
	--desc = "Solar Breath (Rukhmar)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["188520"] = {
	--desc = "Fel Sludge";
	soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 188520) or 0;
		if (stacks < 2 or stacks >= 8) then -- < 2 covers fel sludge in Legion where it doesn't actually stack
			return 1;
		else
			return 2;
		end
	end;
};

GTFO.SpellID["183747"] = {
	--desc = "Pollen Cloud";
	sound = 2;
};

GTFO.SpellID["187671"] = {
	--desc = "Mark of Kazzak (Supreme Lord Kazzak)";
	sound = 4;
	ignoreSelfInflicted = true;
};

--TODO: Acid Breath (Drov the Ruiner) - avoidable?


-- **************
-- * Auchindoun *
-- **************

GTFO.SpellID["156746"] = {
	--desc = "Consecrated Light (Vigilant Kaathar)";
	sound = 1;
};

GTFO.SpellID["166749"] = {
	--desc = "Mind Sear (Sargerei Soulbinder)";
	sound = 4;
	negatingDebuffSpellID = 166749; -- Mind Sear?
	test = true; -- Verify negating debuff spell ID
};

GTFO.SpellID["153430"] = {
	--desc = "Sanctified Ground - Debuff (Soul Construct)";
	sound = 1;
};

GTFO.SpellID["161457"] = {
	--desc = "Sanctified Ground (Soul Construct)";
	sound = 1;
};

GTFO.SpellID["154773"] = {
	--desc = "Warden's Hammer (Sargerei Warden)";
	sound = 1;
};

GTFO.SpellID["154187"] = {
	--desc = "Soul Vessel (Soulbinder Nyami)";
	sound = 1;
};

GTFO.SpellID["153616"] = {
	--desc = "Fel Pool (Azzakel)";
	sound = 1;
};

GTFO.SpellID["153726"] = {
	--desc = "Fel Spark (Azzakel)";
	sound = 1;
};

GTFO.SpellID["156856"] = {
	--desc = "Rain of Fire (Teron'gor)";
	sound = 1;
};

-- ************************
-- * Bloodmaul Slag Mines *
-- ************************

GTFO.SpellID["151638"] = {
	--desc = "Suppression Field (Bloodmaul Overseer?)";
	sound = 1;
};

GTFO.SpellID["150011"] = {
	--desc = "Magma Barrage (Forgemaster Gog'duh)";
	sound = 1;
};

GTFO.SpellID["149996"] = {
	--desc = "Firestorm (Forgemaster Gog'duh)";
	sound = 1;
};

GTFO.SpellID["149963"] = {
	--desc = "Shatter Earth (Forgemaster Gog'duh)";
	sound = 1;
};

GTFO.SpellID["153227"] = {
	--desc = "Burning Slag (Roltall)";
	sound = 1;
};

GTFO.SpellID["152941"] = {
	--desc = "Molten Reach (Roltall)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["164616"] = {
	--desc = "Channel Flames (Bloodmaul Flamespeaker)";
	sound = 1;
};

GTFO.SpellID["150784"] = {
	--desc = "Magma Eruption (Gug'rokk)";
	sound = 1;
};

-- ******************
-- * Grimrail Depot *
-- ******************

GTFO.SpellID["161220"] = {
	--desc = "Slag Tanker";
	sound = 1;
	test = true; -- Spammy?
};

GTFO.SpellID["167038"] = {
	--desc = "Slag Tanker";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["176033"] = {
	--desc = "Flametongue (Iron Infantry)";
	sound = 1;
};

GTFO.SpellID["176039"] = {
	--desc = "Flametongue (Iron Infantry)";
	sound = 1;
};

GTFO.SpellID["176147"] = {
	--desc = "Ignite (Grom'kar Gunner)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["166340"] = {
	--desc = "Thunder Zone (Iron Horde Far Seer)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["171902"] = {
	--desc = "Thunderous Breath (Rakun)";
	sound = 1;
};

GTFO.SpellID["161588"] = {
	--desc = "Diffused Energy (Skylord Tov'osh)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["156303"] = {
	--desc = "Shrapnel Blast (Grom'kar Gunner)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["156303"] = {
	--desc = "Suppressive Fire (Nitrogg Thundertower)";
	sound = 2;
	test = true;
	-- TODO: Friendly fire sound when not targetted
};

GTFO.SpellID["163741"] = {
	--desc = "Blackrock Mortar (Nitrogg Thundertower)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["166570"] = {
	--desc = "Slag Blast (Nitrogg Thundertower)";
	sound = 1;
	applicationOnly = true;
};


-- **************
-- * Iron Docks *
-- **************

-- Lava Sweep (Makogg Emberblade) - Fail?
-- TODO: Shattering Blade (Koramar) - avoidable?
-- Barbed Arrow Barrage (Fleshrender Nok'gar)
-- Shredding Swipes (Fleshrender Nok'gar) - Fail?

GTFO.SpellID["164632"] = {
	--desc = "Burning Arrows (Fleshrender Nok'gar)";
	sound = 1;
};

GTFO.SpellID["168540"] = {
	--desc = "Cannon Barrage (Skulloc)";
	sound = 1;
};

GTFO.SpellID["168514"] = {
	--desc = "Cannon Barrage (Skulloc)";
	sound = 1;
};

GTFO.SpellID["173105"] = {
	--desc = "Whirling Chains";
	sound = 1;
};

GTFO.SpellID["173149"] = {
	--desc = "Flaming Arrows";
	sound = 1;
};

GTFO.SpellID["173324"] = {
	--desc = "Jagged Caltrops";
	sound = 1;
};

GTFO.SpellID["173489"] = {
	--desc = "Lava Barrage (Ironwing Flamespitter)";
	sound = 1;
};

GTFO.SpellID["173517"] = {
	--desc = "Lava Blast (Ironwing Flamespitter)";
	sound = 1;
};

GTFO.SpellID["172963"] = {
	--desc = "Gatecrasher (Siegemaster Rokra)";
	sound = 1;
};

GTFO.SpellID["178156"] = {
	--desc = "Acid Splash (Rylak Skyterror)";
	sound = 1;
};

GTFO.SpellID["168390"] = {
	--desc = "Cannon Barrage (Skulloc)";
	sound = 1;
};

GTFO.SpellID["168348"] = {
	--desc = "Rapid Fire (Zoggosh)";
	negatingDebuffSpellID = 168398; -- Rapid Fire Targetting
	negatingIgnoreTime = 7;
	sound = 4;
	test = true; -- A little weird at times
};


-- *****************************
-- * Shadowmoon Burial Grounds *
-- *****************************

GTFO.SpellID["152854"] = {
	--desc = "Void Sphere (Shadowmoon Loyalist)";
	sound = 1;
};

GTFO.SpellID["158061"] = {
	--desc = "Blessed Waters of Purity";
	sound = 2;
};

GTFO.SpellID["153224"] = {
	--desc = "Shadow Burn (Sadana Bloodfury)";
	sound = 1;
};

GTFO.SpellID["153070"] = {
	--desc = "Void Devastation (Nhallish)";
	sound = 1;
};

GTFO.SpellID["153501"] = {
	--desc = "Void Blast (Nhallish)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["152800"] = {
	--desc = "Void Vortex (Nhallish)";
	sound = 1;
};

GTFO.SpellID["153692"] = {
	--desc = "Necrotic Pitch (Bonemaw)";
	sound = 1;
};

GTFO.SpellID["154469"] = {
	--desc = "Ritual of Bones (Ner'zhul)";
	sound = 1;
};

GTFO.SpellID["159034"] = {
	--desc = "Wrathstorm (Shaddum)";
	sound = 1;
};

-- ************
-- * Skyreach *
-- ************

GTFO.SpellID["156841"] = {
	--desc = "Storm (Whirling Dervish)";
	sound = 1;
};

GTFO.SpellID["153139"] = {
	--desc = "Four Winds (Ranjit)";
	sound = 1;
};

GTFO.SpellID["153759"] = {
	--desc = "Windwall (Ranjit)";
	sound = 1;
};

GTFO.SpellID["159226"] = {
	--desc = "Solar Storm (Skyreach Arcanologist)";
	sound = 1;
};

GTFO.SpellID["159381"] = {
	--desc = "Quills (Rukhran)";
	sound = 1;
};

GTFO.SpellID["154043"] = {
	--desc = "Lens Flare (High Sage Viryx)";
	sound = 1;
};

-- *****************
-- * The Everbloom *
-- *****************

GTFO.SpellID["169424"] = {
	--desc = "Triple Attack (Twisted Abomination)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["172579"] = {
	--desc = "Bounding Whirl (Melded Berserker)";
	sound = 1;
};

GTFO.SpellID["169495"] = {
	--desc = "Living Leaves (Witherbark)";
	sound = 1;
};

GTFO.SpellID["164294"] = {
	--desc = "Unchecked Growth (Witherbark)";
	sound = 1;
};

GTFO.SpellID["167977"] = {
	--desc = "Bramble Patch (Earthshaper Telu)";
	sound = 1;
};

GTFO.SpellID["166726"] = {
	--desc = "Frozen Rain (Archmage Sol)";
	sound = 1;
};

GTFO.SpellID["169223"] = {
	--desc = "Toxic Gas (Xeri'tac)";
	sound = 1;
};

-- *************************
-- * Upper Blackrock Spire *
-- *************************

GTFO.SpellID["154345"] = {
	--desc = "Electric Pulse (Orebender Gor'ashan)";
	sound = 1;
};

GTFO.SpellID["161288"] = {
	--desc = "Vileblood pool (Kyrak)";
	sound = 1;
};

GTFO.SpellID["161772"] = {
	--desc = "Incinerating Breath (Ironbarb Skyreaver)";
	sound = 1;
};

GTFO.SpellID["161833"] = {
	--desc = "Noxious Spit (Ironbarb Skyreaver)";
	sound = 1;
};

GTFO.SpellID["162097"] = {
	--desc = "Imbued Iron Axe (Tharbek)";
	sound = 1;
};

GTFO.SpellID["155325"] = {
	--desc = "Fire Pool (Emberscale Adolescent)";
	sound = 1;
};

GTFO.SpellID["157420"] = {
	--desc = "Fiery Trail (Son of the Beast)";
	negatingDebuffSpellID = 157428; -- Terrifying Roar
	sound = 1;
};

GTFO.SpellID["155057"] = {
	--desc = "Magma Pool (Ragewing)";
	sound = 1;
};

GTFO.SpellID["155728"] = {
	--desc = "Black Iron Cyclone (Warlord Zaela)";
	sound = 1;
};

GTFO.SpellID["166041"] = {
	--desc = "Burning Breath (Warlord Zaela)";
	sound = 1;
};

GTFO.SpellID["166730"] = {
	--desc = "Burning Bridge (Warlord Zaela)";
	sound = 1;
};

GTFO.SpellID["162939"] = {
	--desc = "Flame Spit (Emberscale Ironflight)";
	sound = 1;
};

GTFO.SpellID["154764"] = {
	--desc = "Earthpounder (Black Iron Earthshaker)";
	sound = 1;
};

-- *********************
-- * Blackrock Foundry *
-- *********************

GTFO.SpellID["175643"] = {
	--desc = "Spinning Blade (Workshop Guardian)";
	sound = 1;
};

GTFO.SpellID["159686"] = {
	--desc = "Acidback Puddle (Darkshard Acidback)";
	sound = 1;
};

GTFO.SpellID["159520"] = {
	--desc = "Gripping Slag (Iron Slag-Shaper)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["175605"] = {
	--desc = "Gripping Slag (Iron Slag-Shaper)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["173192"] = {
	--desc = "Cave In (Gruul)";
	sound = 1;
};

GTFO.SpellID["156203"] = {
	--desc = "Retched Blackrock (Oregorger)";
	sound = 1;
};

GTFO.SpellID["156388"] = {
	--desc = "Explosive Shard - Initial Hit (Oregorger)";
	sound = 2;
};

GTFO.SpellID["156932"] = {
	--desc = "Rupture (Foreman Feldspar)";
	sound = 1;
};

GTFO.SpellID["155743"] = {
	--desc = "Slag Pool (Heart of the Mountain)";
	sound = 1;
};

GTFO.SpellID["155223"] = {
	--desc = "Melt (Heart of the Mountain)";
	sound = 1;
};

GTFO.SpellID["160260"] = {
	--desc = "Fire Bomb (Blackrock Enforcer)";
	sound = 1;
};

GTFO.SpellID["177806"] = {
	--desc = "Furnace Flame";
	sound = 1;
};

GTFO.SpellID["162663"] = {
	--desc = "Electrical Storm (Thunderlord Beast-Tender)";
	sound = 1;
};

-- Beastlord Darmac
-- TODO: Epicenter - avoidable?

GTFO.SpellID["154989"] = {
	--desc = "Inferno Breath (Beastlord Darmac)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["156824"] = {
	--desc = "Inferno Pyre (Beastlord Darmac)";
	sound = 1;
};

GTFO.SpellID["155718"] = {
	--desc = "Conflagration (Beastlord Darmac)";
	sound = 4;
	ignoreSelfInflicted = true;	
};

GTFO.SpellID["155499"] = {
	--desc = "Superheated Shrapnel (Beastlord Darmac)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["156823"] = {
	--desc = "Superheated Scrap (Beastlord Darmac)";
	sound = 1;
};

GTFO.SpellID["155657"] = {
	--desc = "Flame Infusion (Pack Beast)";
	sound = 1;
};

GTFO.SpellID["155049"] = {
	--desc = "Singe (Flamebender Ka'graz)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["155314"] = {
	--desc = "Lava Slash (Flamebender Ka'graz)";
	sound = 1;
};

GTFO.SpellID["156713"] = {
	--desc = "Unquenchable Flame (Flamebender Ka'graz)";
	sound = 1;
};

GTFO.SpellID["155484"] = {
	--desc = "Blazing Radiance (Flamebender Ka'graz)";
	sound = 4;
	ignoreSelfInflicted = true;	
};

GTFO.SpellID["155818"] = {
	--desc = "Scorching Burns (Hans'gar and Franzok)";
	sound = 1;
};

GTFO.SpellID["161570"] = {
	--desc = "Searing Plates (Hans'gar and Franzok)";
	sound = 1;
};

-- Operator Thogar
-- TODO: Lava Shock - avoidable?
-- TODO: Heat Blast - avoidable?

GTFO.SpellID["164380"] = {
	--desc = "Burning (Operator Thogar)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["174773"] = {
	--desc = "Exhaust Fumes (Operator Thogar)";
	sound = 1;
};

GTFO.SpellID["165195"] = {
	--desc = "Prototype Pulse Grenade (Operator Thogar)";
	sound = 1;
};

GTFO.SpellID["156932"] = {
	--desc = "Rupture (Foreman Feldspar)";
	sound = 1;
};

GTFO.SpellID["155223"] = {
	--desc = "Melt (Foreman Feldspar)";
	sound = 1;
};

-- The Iron Maidens
-- TODO: Convulsive Shadows, Lingering Shadows?

GTFO.SpellID["156637"] = {
	--desc = "Rapid Fire (Admiral Gar'an)";
	sound = 1;
};

GTFO.SpellID["158683"] = {
	--desc = "Corrupted Blood (The Iron Maidens)";
	sound = 1;
};

GTFO.SpellID["175585"] = {
	--desc = "Living Blaze (Forgemistress Flamehand)";
	sound = 4;
	ignoreSelfInflicted = true;	
};

GTFO.SpellID["175577"] = {
	--desc = "Flame Jets (Forgemistress Flamehand)";
	sound = 1;
};

-- Blackhand
GTFO.SpellID["156401"] = {
	--desc = "Molten Slag (Blackhand)";
	sound = 1;
};

GTFO.SpellID["156825"] = {
	--desc = "Molten Slag (Blackhand)";
	sound = 1;
};

GTFO.SpellID["162490"] = {
	--desc = "Blaze (Blackhand)";
	sound = 1;
};

GTFO.SpellID["156617"] = {
	--desc = "Blaze (Blackhand)";
	sound = 1;
};

GTFO.SpellID["156930"] = {
	--desc = "Slag Eruption (Blackhand)";
	sound = 1;
	test = true;
};

GTFO.SpellID["156948"] = {
	--desc = "Huge Slag Eruption (Blackhand)";
	sound = 1;
};

GTFO.SpellID["177377"] = {
	--desc = "Molten Slag";
	sound = 1;
};

-- ************
-- * Highmaul *
-- ************

GTFO.SpellID["175642"] = {
	--desc = "Rune of Destruction";
	sound = 4;
	negatingDebuffSpellID = 175636; -- Rune
	negatingIgnoreTime = 1;
};

GTFO.SpellID["175654"] = {
	--desc = "Rune of Disintegration";
	sound = 1;
};

GTFO.SpellID["161635"] = {
	--desc = "Molten Bomb (Vul'gor)";
	sound = 1;
};

GTFO.SpellID["159413"] = {
	--desc = "Mauling Brew (Kargath Bladefist)";
	sound = 1;
};

GTFO.SpellID["159311"] = {
	--desc = "Flame Jet (Kargath Bladefist)";
	sound = 1;
};

GTFO.SpellID["159002"] = {
	--desc = "Berserker Rush (Kargath Bladefist)";
	sound = 1;
};

GTFO.SpellID["156138"] = {
	--desc = "Heavy Handed (The Butcher)";
	sound = 1;
	tankSound = 0;
};

-- The Butcher
GTFO.SpellID["163046"] = {
	--desc = "Pale Vitorl (The Butcher)";
	sound = 1;
};

-- Tectus
-- TODO: Petrification (Tectus) -- How many stacks is too many?

GTFO.SpellID["172069"] = {
	--desc = "Radiating Poison (Tectus Trash)";
	sound = 4;
	negatingDebuffSpellID = 172066; -- Radiating Poison
};

GTFO.SpellID["162370"] = {
	--desc = "Crystalline Barrage (Tectus)";
	sound = 1;
};

GTFO.SpellID["173232"] = {
	--desc = "Flamethrower (Iron Flame Technician)";
	sound = 1;
};

GTFO.SpellID["163590"] = {
	--desc = "Creeping Moss (Brackenspore)";
	sound = 1;
};

GTFO.SpellID["159220"] = {
	--desc = "Necrotic Breath (Brackenspore)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["164642"] = {
	--desc = "Infested Waters (Brackenspore)";
	sound = 1;
};

GTFO.SpellID["160179"] = {
	--desc = "Mind Fungus (Brackenspore)";
	sound = 2;
	casterOnly = true;
};

GTFO.SpellID["166180"] = {
	--desc = "Shield Charge (Highmaul Conscript)";
	sound = 3;
};

GTFO.SpellID["166188"] = {
	--desc = "Decimate (Ogron Brute)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["157944"] = {
	--desc = "Whirlwind (Phemos)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["158241"] = {
	--desc = "Blaze (Phemos)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["173827"] = {
	--desc = "Wild Flames";
	sound = 1;
};

GTFO.SpellID["172917"] = {
	--desc = "Expel Magic: Fel (Ko'rgah, Mythic)";
	sound = 1;
};

GTFO.SpellID["175056"] = {
	--desc = "Arcane Residue (Warden Thul'tok)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["174470"] = {
	--desc = "Rampage (Gorian Royal Guardsman)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["174576"] = {
	--desc = "Arcane Damage (Councilor Magknor)";
	sound = 2;
};

GTFO.SpellID["162397"] = {
	--desc = "Expel Magic: Arcane (Ko'ragh)";
	soundFunction = function() 
		if (GTFO_HasDebuff("player", 162186)) then -- Expel Magic: Arcane
			return 1; -- Tank is hurting self
		end
		return 4;
	end;
};

GTFO.SpellID["161345"] = {
	--desc = "Suppression Field (Ko'ragh)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["157353"] = {
	--desc = "Force Nova (Imperator Mar'gok)";
	soundFunction = function() 
		-- Alert if hit more than 8 times
		if (not GTFO.VariableStore.ForceNovaHitCount) then
			GTFO.VariableStore.ForceNovaHitCount = 0;
		end
		if (GTFO.VariableStore.ForceNovaHitCount == 0) then
			GTFO_AddEvent("ResetForceNovaCounter", 5, function() GTFO.VariableStore.ForceNovaHitCount = 0; end);
		end
		GTFO.VariableStore.ForceNovaHitCount = GTFO.VariableStore.ForceNovaHitCount + 1;
		if (GTFO.VariableStore.ForceNovaHitCount > 8) then
			return 1;
		end
	end;
};

GTFO.SpellID["174405"] = {
	--desc = "Frozen Core (Breaker Ritualist)";
	sound = 4;
	damageMinimum = 1;
};


GTFO.SpellID["157769"] = {
	--desc = "Nether Blast (Imperator Mar'gok)";
	sound = 4;
	negatingDebuffSpellID = 157763; -- Fixate
	negatingIgnoreTime = 2;
};

GTFO.SpellID["157357"] = {
	--desc = "Force Nova: Replication (Imperator Mar'gok)";
	sound = 4;
};

-- ********************
-- * Hellfire Citadel *
-- ********************

GTFO.SpellID["180022"] = {
	--desc = "Bore (Felfire Crusher)";
	sound = 1;
};

GTFO.SpellID["185157"] = {
	--desc = "Burn (Felfire Crusher)";
	sound = 1;
};

GTFO.SpellID["182074"] = {
	--desc = "Immolation (Iron Reaver)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["182003"] = {
	--desc = "Fuel Streak (Iron Reaver)";
	sound = 2;
	applicationOnly = true;
};

GTFO.SpellID["182522"] = {
	--desc = "Flash Fire (Iron Reaver)";
	sound = 1;
};

GTFO.SpellID["182522"] = {
	--desc = "Flash Fire (Iron Reaver)";
	sound = 1;
};

GTFO.SpellID["188072"] = {
	--desc = "Fel Destruction (Orb of Destruction)";
	alwaysAlert = true;
	soundFunction = function() -- Slow down spam
		if (GTFO_FindEvent("FelFail")) then
			return 0;
		end
		GTFO_AddEvent("FelFail", 1.5);
		return 1;
	end	
	
};

GTFO.SpellID["187103"] = {
	--desc = "Residual Shadows (Shadow Infuser)";
	sound = 1;
};

GTFO.SpellID["185521"] = {
	--desc = "Foul Globule (Kormrok)";
	sound = 1;
};

GTFO.SpellID["185519"] = {
	--desc = "Fiery Globule (Kormrok)";
	sound = 1;
};

GTFO.SpellID["180270"] = {
	--desc = "Shadow Globule (Kormrok)";
	sound = 1;
};

GTFO.SpellID["186560"] = {
	--desc = "Foul Pool (Kormrok)";
	sound = 1;
};

GTFO.SpellID["186559"] = {
	--desc = "Fiery Pool (Kormrok)";
	sound = 1;
};

GTFO.SpellID["181082"] = {
	--desc = "Shadowy Pool (Kormrok)";
	sound = 1;
};

GTFO.SpellID["185686"] = {
	--desc = "Fiery Residue (Kormrok - Mythic)";
	sound = 1;
};

GTFO.SpellID["185687"] = {
	--desc = "Foul Residue (Kormrok - Mythic)";
	sound = 1;
};

GTFO.SpellID["181208"] = {
	--desc = "Shadow Residue (Kormrok - Mythic)";
	sound = 1;
};

GTFO.SpellID["180246"] = {
	--desc = "Pound (Kormrok)";
	soundFunction = function() -- Warn only on multiple hits
		if (GTFO_HasDebuff("player", 187819)) then -- Grasping Hand debuff
			return 0;
		end
		if (GTFO_FindEvent("PoundFail")) then
			return 4;
		end
		GTFO_AddEvent("PoundFail", .3);
		return 0;
	end
};

GTFO.SpellID["184652"] = {
	--desc = "Reap (Hellfire Council)";
	sound = 1;
};

GTFO.SpellID["184300"] = {
	--desc = "Fel Blaze (Gorebound Berserker)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["182601"] = {
	--desc = "Fel Fury (Gorebound Brute)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["179995"] = {
	--desc = "Doom Well (Gorefiend)";
	sound = 1;
};

GTFO.SpellID["186770"] = {
	--desc = "Pool of Souls (Gorefiend)";
	sound = 1;
};

GTFO.SpellID["182600"] = {
	--desc = "Fel Fire (Shadow-Lord Iskar)";
	sound = 1;
};

GTFO.SpellID["182218"] = {
	--desc = "Felblaze Residue (Socrethar)";
	sound = 1;
	vehicle = true;
};

GTFO.SpellID["181653"] = {
	--desc = "Fel Crystals (Fel Lord Zakuun)";
	sound = 1;
};

GTFO.SpellID["186063"] = {
	--desc = "Wasting Void (Xhul'horac)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["186073"] = {
	--desc = "Felsinged (Xhul'horac)";
	applicationOnly = true;
	sound = 1;
};

GTFO.SpellID["180252"] = {
	--desc = "Roaring Flames (Ancient Enforcer)";
	sound = 1;
};

GTFO.SpellID["180312"] = {
	--desc = "Infernal Tempest (Tyrant Velhari)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["180604"] = {
	--desc = "Despoiled Ground (Tyrant Velhari)";
	sound = 1;
};

GTFO.SpellID["181192"] = {
	--desc = "Fel Hellfire (Mannoroth)";
	sound = 1;
};

GTFO.SpellID["182171"] = {
	--desc = "Blood of Mannoroth (Mannoroth)";
	sound = 1;
};

GTFO.SpellID["183586"] = {
	--desc = "Doomfire (Archimonde)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["187255"] = {
	--desc = "Nether Storm (Archimonde)";
	sound = 1;
};

GTFO.SpellID["188796"] = {
	--desc = "Fel Corruption (Archimonde)";
	sound = 1;
};

GTFO.SpellID["186510"] = {
	--desc = "Smouldering";
	sound = 1;
};

GTFO.SpellID["189550"] = {
	--desc = "Rain of Fire (Azgalor)";
	sound = 1;
};
