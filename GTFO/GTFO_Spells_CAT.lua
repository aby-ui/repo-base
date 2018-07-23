--------------------------------------------------------------------------
-- GTFO_Spells_CAT.lua 
--------------------------------------------------------------------------
--[[
GTFO Spell List - Cataclysm (New areas)
Author: Zensunim of Malygos
]]--

GTFO.SpellID["76628"] = {
	--desc = "Lava Drool (Blackrock Caverns)";
	sound = 1;
};

GTFO.SpellID["93666"] = {
	--desc = "Lava Drool (Blackrock Caverns, Heroic)";
	sound = 1;
};

GTFO.SpellID["79411"] = {
	--desc = "Foul Waters (Vashj'ir)";
	sound = 2;
};

GTFO.SpellID["76776"] = {
	--desc = "Noxious Mire (Throne of the Tides)";
	sound = 1;
};

GTFO.SpellID["91446"] = {
	--desc = "Noxious Mire (Throne of the Tides, Heroic)";
	sound = 1;
};

GTFO.SpellID["76085"] = {
	--desc = "Dark Fissure (Residual, Throne of the Tides)";
	sound = 1;
};

GTFO.SpellID["91375"] = {
	--desc = "Dark Fissure (Residual, Throne of the Tides Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["76593"] = {
	--desc = "Ground Pound (Throne of the Tides)";
	sound = 1;
};

GTFO.SpellID["91468"] = {
	--desc = "Ground Pound (Throne of the Tides, Heroic)";
	sound = 1;
};

GTFO.SpellID["84945"] = {
	--desc = "Earth Shards (Throne of the Tides)";
	sound = 1;
};

GTFO.SpellID["91491"] = {
	--desc = "Earth Shards (Throne of the Tides, Heroic)";
	sound = 1;
};

GTFO.SpellID["76230"] = {
	--desc = "Mind Fog (Throne of the Tides)";
	soundFunction = function() 
		-- Reduce the spam
		GTFO_AddEvent("MindFog", .75);
		return 1;
	end;
	ignoreEvent = "MindFog";
};

GTFO.SpellID["83971"] = {
	--desc = "Aura of Dread (Blight Beast, Throne of the Tides)";
	sound = 1;
	applicationOnly = true;
	negatingBuffSpellID = 76133; -- Tidal Surge
};

-- Need to do special handling because the Blizzard isn't sending SPELL_AURA_APPLIED_DOSE events for this spell
GTFO.SpellID["83561"] = {
	--desc = "Blight of Ozumat (Ozumat, Throne of the Tides)";
	negatingBuffSpellID = 76133; -- Tidal Surge
	alwaysAlert = true;
	soundFunction = function() -- Check to see if the debuff count of Blight has increased
		local stacks = GTFO_DebuffStackCount("player", 83561); 
		local x = 0;
		if (stacks > GTFO.VariableStore.StackCounter) then
			x = 1;
		end
		GTFO.VariableStore.StackCounter = stacks;
		return x;
	end
};

GTFO.SpellID["91495"] = {
	--desc = "Blight of Ozumat (Ozumat, Throne of the Tides, Heroic)";
	negatingBuffSpellID = 76133; -- Tidal Surge
	alwaysAlert = true;
	soundFunction = function() 
		local stacks = GTFO_DebuffStackCount("player", 91495); 
		local x = 0;
		if (stacks > GTFO.VariableStore.StackCounter) then
			x = 1;
		end
		GTFO.VariableStore.StackCounter = stacks;
		return x;
	end
};

GTFO.SpellID["86881"] = {
	--desc = "Crystal Barrage (Stonecore)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["92648"] = {
	--desc = "Crystal Barrage (Stonecore, Heroic)";
	sound = 1;
};

GTFO.SpellID["81569"] = {
	--desc = "Spinning Slash (Stonecore)";
	tankSound = 2;
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["92623"] = {
	--desc = "Spinning Slash (Stonecore, Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["79923"] = {
	--desc = "Flay (Stonecore)";
	tankSound = 0;
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["80801"] = {
	--desc = "Lava Pool (Stonecore)";
	sound = 1;
};

GTFO.SpellID["92658"] = {
	--desc = "Lava Pool (Stonecore, Heroic)";
	sound = 1;
};

GTFO.SpellID["79249"] = {
	--desc = "Gravity Well (Stonecore)";
	sound = 1;
};

GTFO.SpellID["76328"] = {
	--desc = "Fire Strike (Blackrock Caverns)";
	tankSound = 2;
	sound = 1;
};

GTFO.SpellID["93646"] = {
	--desc = "Fire Strike (Blackrock Caverns, Heroic)";
	sound = 1;
};

GTFO.SpellID["76665"] = {
	--desc = "Little Big Flame Breath (Blackrock Caverns)";
	tankSound = 0;
	sound = 1;
};

GTFO.SpellID["93667"] = {
	--desc = "Little Big Flame Breath (Blackrock Caverns, Heroic)";
	tankSound = 0;
	sound = 1;
};

GTFO.SpellID["76682"] = {
	--desc = "Frostbomb (Blackrock Caverns)";
	sound = 2;
};

GTFO.SpellID["93651"] = {
	--desc = "Frostbomb (Blackrock Caverns, Heroic)";
	sound = 2;
};

GTFO.SpellID["87553"] = {
	--desc = "Supremacy of the Storm (Asaad, Vortex Pinnacle)";
	sound = 1;
};

GTFO.SpellID["93994"] = {
	--desc = "Supremacy of the Storm (Asaad, Vortex Pinnacle Heroic)";
	sound = 1;
};

GTFO.SpellID["88073"] = {
	--desc = "Starfall (Cloud Prince, Vortex Pinnacle)";
	sound = 2;
};

GTFO.SpellID["92783"] = {
	--desc = "Starfall (Cloud Prince, Vortex Pinnacle Heroic)";
	sound = 2;
};

GTFO.SpellID["88171"] = {
	--desc = "Hurricane (Turbulent Squall, Vortex Pinnacle)";
	sound = 2;
};

GTFO.SpellID["92773"] = {
	--desc = "Hurricane (Turbulent Squall, Vortex Pinnacle Heroic)";
	sound = 2;
};

GTFO.SpellID["87660"] = {
	--desc = "Burning Gaze (Titanic Guardian, Uldum)";
	sound = 1;
};

GTFO.SpellID["75939"] = {
	--desc = "Twilight Flames (Twilight Drake, Grim Batol)";
	sound = 1;
};

GTFO.SpellID["90876"] = {
	--desc = "Twilight Flames (Twilight Drake, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["74986"] = {
	--desc = "Cave In (Forgemaster Throngus, Grim Batol)";
	sound = 1;
};

GTFO.SpellID["90722"] = {
	--desc = "Cave In (Forgemaster Throngus, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["76786"] = {
	--desc = "Fissure (Ascended Rockbreaker, Grim Batol)";
	sound = 1;
};

GTFO.SpellID["90863"] = {
	--desc = "Fissure (Ascended Rockbreaker, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["75692"] = {
	--desc = "Shadow Gale (Erudax, Grim Batol)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["91087"] = {
	--desc = "Shadow Gale (Erudax, Grim Batol)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["75117"] = {
	--desc = "Burning Light (Temple Guardian Anhuur, Halls of Origination)";
	sound = 1;
};

GTFO.SpellID["94951"] = {
	--desc = "Burning Light (Temple Guardian Anhuur, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["77262"] = {
	--desc = "Raging Inferno (Fire Warden, Halls of Origination)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["91159"] = {
	--desc = "Raging Inferno (Fire Warden, Halls of Origination Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["76956"] = {
	--desc = "Alpha Beams (Anraphet, Halls of Origination)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["91177"] = {
	--desc = "Alpha Beams (Anraphet, Halls of Origination Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["75547"] = {
	--desc = "Quicksand (Earthrager Ptah, Halls of Origination)";
	sound = 1;
};

GTFO.SpellID["89880"] = {
	--desc = "Quicksand (Earthrager Ptah, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["74045"] = {
	--desc = "Energy Flux (Isisit, Halls of Origination)";
	sound = 1;
};

GTFO.SpellID["89861"] = {
	--desc = "Energy Flux (Isisit, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["75702"] = {
	--desc = "Noxious Spores (Budding Spore, Halls of Origination)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["89889"] = {
	--desc = "Noxious Spores (Budding Spore, Halls of Origination Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["76684"] = {
	--desc = "Chaos Burn (Setesh, Halls of Origination)";
	sound = 1;
};

GTFO.SpellID["89874"] = {
	--desc = "Chaos Burn (Setesh, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["77030"] = {
	--desc = "Reign of Chaos (Setesh, Halls of Origination)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["89872"] = {
	--desc = "Reign of Chaos (Setesh, Halls of Origination Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["84251"] = {
	--desc = "Earthquake (Oathsworn Captain, Lost City)";
	sound = 1;
};

GTFO.SpellID["90017"] = {
	--desc = "Earthquake (Oathsworn Captain, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["81942"] = {
	--desc = "Heaven's Fury (High Prophet Barim, Lost City)";
	sound = 1;
};

GTFO.SpellID["90040"] = {
	--desc = "Heaven's Fury (High Prophet Barim, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["88814"] = {
	--desc = "Hallowed Ground (High Prophet Barim, Lost City)";
	sound = 1;
};

GTFO.SpellID["90010"] = {
	--desc = "Hallowed Ground (High Prophet Barim, Lost City)";
	sound = 1;
};

GTFO.SpellID["75317"] = {
	--desc = "Seeping Twilight (Drahga Shadowburner, Grim Batol)";
	sound = 1;
};

GTFO.SpellID["90964"] = {
	--desc = "Seeping Twilight (Drahga Shadowburner, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["92278"] = {
	--desc = "Spark (Vanessa VanCleef, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["92065"] = {
	--desc = "Rotten Aura (Captain Cookie, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["91716"] = {
	--desc = "Overdrive (Foe Reaper 5000, Deadmines Heroic)";
	sound = 1;
	vehicle = true;
};

GTFO.SpellID["91397"] = {
	--desc = "Fire Wall (Glubtok, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["94370"] = {
	--desc = "Desecration (Commander Springvale, Shadowfang Keep Heroic)";
	sound = 1;
};

GTFO.SpellID["93737"] = {
	--desc = "Shield of the Perfidious (Commander Springvale, Shadowfang Keep Heroic)";
	tankSound = 2;
	sound = 1;
};

GTFO.SpellID["90963"] = {
	--desc = "Whirling Blades (Defias Shadowguard, Deadmines Heroic)";
	sound = 2;
};

GTFO.SpellID["92171"] = {
	--desc = "Nightmare Flames (Vanessa VanCleef, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["91819"] = {
	--desc = "Molten Shield (Molten Slag, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["89000"] = {
	--desc = "Fel Flames (Argaloth, Baradin Hold 10)";
	sound = 1;
};

GTFO.SpellID["95177"] = {
	--desc = "Fel Flames (Argaloth, Baradin Hold 25)";
	sound = 1;
};

GTFO.SpellID["86844"] = {
	--desc = "Devouring Flames (Valiona, BoT - Twilight?)";
	sound = 1;
};

GTFO.SpellID["90949"] = {
	--desc = "Devouring Flames (Valiona, BoT 10)";
	sound = 1;
};

GTFO.SpellID["92872"] = {
	--desc = "Devouring Flames (Valiona, BoT 25)";
	sound = 1;
};

GTFO.SpellID["92873"] = {
	--desc = "Devouring Flames (Valiona, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92874"] = {
	--desc = "Devouring Flames (Valiona, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["86505"] = {
	--desc = "Fabulous Flames (Theralion, BoT 10)";
	sound = 1;
};

GTFO.SpellID["92907"] = {
	--desc = "Fabulous Flames (Theralion, BoT 25)";
	sound = 1;
};

GTFO.SpellID["92908"] = {
	--desc = "Fabulous Flames (Theralion, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92909"] = {
	--desc = "Fabulous Flames (Theralion, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["86631"] = {
	--desc = "Engulfing Magic - Friendly Fire (Theralion, BoT)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["88558"] = {
	--desc = "Flame Torrent (Ignacious, BoT 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["92516"] = {
	--desc = "Flame Torrent (Ignacious, BoT 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["92517"] = {
	--desc = "Flame Torrent (Ignacious, BoT 10H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["92518"] = {
	--desc = "Flame Torrent (Ignacious, BoT 25H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["82860"] = {
	--desc = "Inferno Rush (Ignacious, BoT 10)";
	sound = 1;
};

GTFO.SpellID["92523"] = {
	--desc = "Inferno Rush (Ignacious, BoT 25)";
	sound = 1;
};

GTFO.SpellID["92524"] = {
	--desc = "Inferno Rush (Ignacious, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92525"] = {
	--desc = "Inferno Rush (Ignacious, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["84915"] = {
	--desc = "Liquid Ice (Elementium Monstrosity, BoT 10)";
	sound = 1;
};

GTFO.SpellID["92497"] = {
	--desc = "Liquid Ice (Elementium Monstrosity, BoT 25)";
	sound = 1;
};

GTFO.SpellID["92498"] = {
	--desc = "Liquid Ice (Elementium Monstrosity, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92499"] = {
	--desc = "Liquid Ice (Elementium Monstrosity, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["79889"] = {
	--desc = "Lightning Conductor (Electron, BWD 10)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91438"] = {
	--desc = "Lightning Conductor (Electron, BWD 25)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91439"] = {
	--desc = "Lightning Conductor (Electron, BWD 10H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91440"] = {
	--desc = "Lightning Conductor (Electron, BWD 25H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["91472"] = {
	--desc = "Poison Cloud (Toxitron, BWD 10)";
	sound = 1;
};

GTFO.SpellID["91473"] = {
	--desc = "Poison Cloud (Toxitron, BWD 25)";
	sound = 1;
};

GTFO.SpellID["80097"] = {
	--desc = "Poison Puddle (Toxitron, BWD 10)";
	sound = 1;
};

GTFO.SpellID["91488"] = {
	--desc = "Poison Puddle (Toxitron, BWD 25)";
	sound = 1;
};

GTFO.SpellID["91489"] = {
	--desc = "Poison Puddle (Toxitron, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["91490"] = {
	--desc = "Poison Puddle (Toxitron, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["77763"] = {
	--desc = "Biting Chill (Maloriak, BWD 10)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 77760; -- Biting Chill
	negatingIgnoreTime = 1;
};

GTFO.SpellID["92975"] = {
	--desc = "Biting Chill (Maloriak, BWD 25)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 77760; -- Biting Chill
	negatingIgnoreTime = 1;
};

GTFO.SpellID["92976"] = {
	--desc = "Biting Chill (Maloriak, BWD 10H)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 77760; -- Biting Chill
	negatingIgnoreTime = 1;
};

GTFO.SpellID["92977"] = {
	--desc = "Biting Chill (Maloriak, BWD 25H)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 77760; -- Biting Chill
	negatingIgnoreTime = 1;
};

GTFO.SpellID["78124"] = {
	--desc = "Magma Jets (Maloriak, BWD 10)";
	sound = 1;
};

GTFO.SpellID["93038"] = {
	--desc = "Magma Jets (Maloriak, BWD 25)";
	sound = 1;
};

GTFO.SpellID["93039"] = {
	--desc = "Magma Jets (Maloriak, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["93040"] = {
	--desc = "Magma Jets (Maloriak, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["77675"] = {
	--desc = "Sonar Pulse (Atramedes, BWD 10)";
	sound = 1;
};

GTFO.SpellID["92417"] = {
	--desc = "Sonar Pulse (Atramedes, BWD 25)";
	sound = 1;
};

GTFO.SpellID["92418"] = {
	--desc = "Sonar Pulse (Atramedes, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92419"] = {
	--desc = "Sonar Pulse (Atramedes, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["78353"] = {
	--desc = "Roaring Flame Breath (Atramedes, BWD 10)";
	sound = 1;
};

GTFO.SpellID["92445"] = {
	--desc = "Roaring Flame Breath (Atramedes, BWD 25)";
	sound = 1;
};

GTFO.SpellID["92446"] = {
	--desc = "Roaring Flame Breath (Atramedes, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92447"] = {
	--desc = "Roaring Flame Breath (Atramedes, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["78555"] = {
	--desc = "Roaring Flame (Atramedes, BWD 10)";
	sound = 1;
};

GTFO.SpellID["92472"] = {
	--desc = "Roaring Flame (Atramedes, BWD 25)";
	sound = 1;
};

GTFO.SpellID["92473"] = {
	--desc = "Roaring Flame (Atramedes, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92474"] = {
	--desc = "Roaring Flame (Atramedes, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["78023"] = {
	--desc = "Roaring Flame - DoT (Atramedes, BWD 10)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["92483"] = {
	--desc = "Roaring Flame - DoT (Atramedes, BWD 25)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["92484"] = {
	--desc = "Roaring Flame - DoT (Atramedes, BWD 10H)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["92485"] = {
	--desc = "Roaring Flame - DoT (Atramedes, BWD 25H)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["78100"] = {
	--desc = "Sonic Breath (Atramedes, BWD 10)";
	sound = 1;
};

GTFO.SpellID["92407"] = {
	--desc = "Sonic Breath (Atramedes, BWD 25)";
	sound = 1;
};

GTFO.SpellID["92408"] = {
	--desc = "Sonic Breath (Atramedes, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92409"] = {
	--desc = "Sonic Breath (Atramedes, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["86111"] = {
	--desc = "Ice Patch (Nezir, T4W 10)";
	sound = 1;
};

GTFO.SpellID["93129"] = {
	--desc = "Ice Patch (Nezir, T4W 25)";
	sound = 1;
};

GTFO.SpellID["93130"] = {
	--desc = "Ice Patch (Nezir, T4W 10H)";
	sound = 1;
};

GTFO.SpellID["93131"] = {
	--desc = "Ice Patch (Nezir, T4W 25H)";
	sound = 1;
};

GTFO.SpellID["86081"] = {
	--desc = "Permafrost (Nezir, T4W 10)";
	tankSound = 0;
	sound = 1;
};

GTFO.SpellID["86082"] = {
	--desc = "Permafrost (Nezir, T4W 25)";
	tankSound = 0;
	sound = 1;
};

GTFO.SpellID["95217"] = {
	--desc = "Soothing Breeze (Anshal, T4W)";
	sound = 1;
};

GTFO.SpellID["91020"] = {
	--desc = "Ice Storm (Al'Akir, T4W 10)";
	sound = 1;
};

GTFO.SpellID["93258"] = {
	--desc = "Ice Storm (Al'Akir, T4W 25)";
	sound = 1;
};

GTFO.SpellID["93259"] = {
	--desc = "Ice Storm (Al'Akir, T4W 10H)";
	sound = 1;
};

GTFO.SpellID["93260"] = {
	--desc = "Ice Storm (Al'Akir, T4W 25H)";
	sound = 1;
};

GTFO.SpellID["87908"] = {
	--desc = "Stormling (Al'Akir, T4W 10)";
	tankSound = 0;
	sound = 2;
	ignoreEvent = "AlAkirIgnoreStormling";
};

GTFO.SpellID["93270"] = {
	--desc = "Stormling (Al'Akir, T4W 25)";
	tankSound = 0;
	sound = 2;
	ignoreEvent = "AlAkirIgnoreStormling";
};

GTFO.SpellID["93271"] = {
	--desc = "Stormling (Al'Akir, T4W 10H)";
	tankSound = 0;
	sound = 1;
	ignoreEvent = "AlAkirIgnoreStormling";
};

GTFO.SpellID["93272"] = {
	--desc = "Stormling (Al'Akir, T4W 25H)";
	tankSound = 0;
	sound = 1;
	ignoreEvent = "AlAkirIgnoreStormling";
};

GTFO.SpellID["89667"] = {
	--desc = "Lightning Rod (Al'Akir, T4W 10)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 89666; -- Lightning Rod
	negatingIgnoreTime = 1;
};

GTFO.SpellID["93293"] = {
	--desc = "Lightning Rod (Al'Akir, T4W 25)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 89666; -- Lightning Rod
	negatingIgnoreTime = 1;
};

GTFO.SpellID["93294"] = {
	--desc = "Lightning Rod (Al'Akir, T4W 10H)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 89666; -- Lightning Rod
	negatingIgnoreTime = 1;
};

GTFO.SpellID["93295"] = {
	--desc = "Lightning Rod (Al'Akir, T4W 25H)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 89666; -- Lightning Rod
	negatingIgnoreTime = 1;
};

GTFO.SpellID["91325"] = {
	--desc = "Shadow Vortex (Shadowy Attendant, Shadowfang Keep Heroic)";
	sound = 1;
};

GTFO.SpellID["91554"] = {
	--desc = "Fetid Cloud (Fetid Ghoul, Shadowfang Keep Heroic)";
	sound = 1;
};

GTFO.SpellID["93784"] = {
	--desc = "Pistol Barrage (Lord Godfrey, Shadowfang Keep Heroic)";
	sound = 1;
};

GTFO.SpellID["93703"] = {
	--desc = "Ice Shards (Lord Walden, Shadowfang Keep Heroic)";
	sound = 1;
};

GTFO.SpellID["93617"] = {
	--desc = "Toxic Coagulant (Lord Walden, Shadowfang Keep Heroic)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["64208"] = {
	--desc = "Consumption (Ick'thys the Unfathomable, Vashj'ir)";
	sound = 1;
};

GTFO.SpellID["90448"] = {
	--desc = "Poison (Cadaver Collage, Twilight Highlands)";
	sound = 1;
};

GTFO.SpellID["90406"] = {
	--desc = "Lava Pool (Emberscar the Devourer, Twilight Highlands)";
	sound = 1;
};

GTFO.SpellID["83446"] = {
	--desc = "Tempest Storm (Siamat, Lost City)";
	sound = 1;
};

GTFO.SpellID["90030"] = {
	--desc = "Tempest Storm (Siamat, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["64683"] = {
	--desc = "Focused Laser (Obsidian Colossus, Uldum)";
	sound = 1;
};

GTFO.SpellID["84448"] = {
	--desc = "Searing Breath (Aeosera, Deepholm)";
	sound = 1;
};

GTFO.SpellID["79607"] = {
	--desc = "Venom Splash (Darkwood Broodmother, Tol Barad)";
	sound = 2;
};

GTFO.SpellID["84785"] = {
	--desc = "Whirlwind (Augh, Lost City)";
	sound = 1;
};

GTFO.SpellID["90012"] = {
	--desc = "Whirlwind (Augh, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["81644"] = {
	--desc = "Dust Flail (Lockjaw, Lost City)";
	sound = 1;
};

GTFO.SpellID["90041"] = {
	--desc = "Dust Flail (Lockjaw, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["95249"] = {
	--desc = "Blaze of the Heavens - Bird Proximity (High Prophet Barim, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["91196"] = {
	--desc = "Blaze of the Heavens - Fire (High Prophet Barim, Lost City Heroic)";
	sound = 1;
};

GTFO.SpellID["74817"] = {
	--desc = "Inferno (Baron Geddon, Hyjal)";
	sound = 1;
};

GTFO.SpellID["89845"] = {
	--desc = "Void Infusion (Void Lord, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["89878"] = {
	--desc = "Solar Fire (Rajh, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["75697"] = {
	--desc = "Evolution (Corla, Blackrock Caverns)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 70;
};

GTFO.SpellID["87378"] = {
	--desc = "Evolution (Corla, Blackrock Caverns Heroic)";
	sound = 1;
	applicationOnly = true;
	minimumStacks = 70;
};

GTFO.SpellID["93519"] = {
	--desc = "Lava Pool (Karsh Steelbender, Blackrock Caverns Heroic)";
	sound = 1;
};

GTFO.SpellID["92300"] = {
	--desc = "Crystal Storm (Slabhide, Stonecore Heroic)";
	sound = 1;
};

GTFO.SpellID["90830"] = {
	--desc = "Flaming Shield (Forgemaster Throngus, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["90754"] = {
	--desc = "Lava Patch (Forgemaster Throngus, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["90664"] = {
	--desc = "Meat Grinder (Twilight Enforcer, Grim Batol Heroic)";
	sound = 2;
	tankSound = 0;
};

GTFO.SpellID["74987"] = {
	--desc = "Cave In (Forgemaster Throngus, Grim Batol Heroic)";
	sound = 1;
};

GTFO.SpellID["85506"] = {
	--desc = "Vermillion Strafe (Vermillion Sentinel, Twilight Highlands)";
	sound = 1;
};

GTFO.SpellID["85236"] = {
	--desc = "Corpse Rot (Forgotten Ghoul, Tol Barad)";
	sound = 2;
	trivialPercent = 0;	
};

GTFO.SpellID["93485"] = {
	--desc = "Fiery Blaze (Vanessa VanCleef, Deadmines Heroic)";
	sound = 1;
};

GTFO.SpellID["77030"] = {
	--desc = "Reign of Chaos (Setesh, Halls of Origination)";
	sound = 1;
};

GTFO.SpellID["89872"] = {
	--desc = "Reign of Chaos (Setesh, Halls of Origination Heroic)";
	sound = 1;
};

GTFO.SpellID["83986"] = {
	--desc = "Blight Spray (Unyielding Behemoth, Throne of the Tides)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["91511"] = {
	--desc = "Blight Spray (Unyielding Behemoth, Throne of the Tides Heroic)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["89588"] = {
	--desc = "Lightning Clouds (Al'Akir, T4W 10)";
	sound = 1;
};

GTFO.SpellID["93297"] = {
	--desc = "Lightning Clouds (Al'Akir, T4W 25)";
	sound = 1;
};

GTFO.SpellID["93298"] = {
	--desc = "Lightning Clouds (Al'Akir, T4W 10H)";
	sound = 1;
};

GTFO.SpellID["93299"] = {
	--desc = "Lightning Clouds (Al'Akir, T4W 25H)";
	sound = 1;
};

GTFO.SpellID["81118"] = {
	--desc = "Magma (Nefarian, BWD 10)";
	sound = 1;
	applicationOnly = true;
	ignoreEvent = "NefarianIgnoreMagma";
};

GTFO.SpellID["94073"] = {
	--desc = "Magma (Nefarian, BWD 25)";
	sound = 1;
	applicationOnly = true;
	ignoreEvent = "NefarianIgnoreMagma";
};

GTFO.SpellID["94074"] = {
	--desc = "Magma (Nefarian, BWD 10H)";
	sound = 1;
	applicationOnly = true;
	ignoreEvent = "NefarianIgnoreMagma";
	negatingDebuffSpellID = 79339; -- Explosive Cinders
};

GTFO.SpellID["94075"] = {
	--desc = "Magma (Nefarian, BWD 25H)";
	sound = 1;
	applicationOnly = true;
	ignoreEvent = "NefarianIgnoreMagma";
	negatingDebuffSpellID = 79339; -- Explosive Cinders
};

GTFO.SpellID["81007"] = {
	--desc = "Shadowblaze (Nefarian, BWD 10)";
	sound = 1;
};

GTFO.SpellID["94085"] = {
	--desc = "Shadowblaze (Nefarian, BWD 25)";
	sound = 1;
};

GTFO.SpellID["94086"] = {
	--desc = "Shadowblaze (Nefarian, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["94087"] = {
	--desc = "Shadowblaze (Nefarian, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["81067"] = {
	--desc = "Laser Strike (Golem Sentry, BWD)";
	sound = 1;
};

GTFO.SpellID["91884"] = {
	--desc = "Laser Strike (Golem Sentry, BWD Heroic)";
	sound = 1;
};

GTFO.SpellID["80161"] = {
	--desc = "Chemical Cloud (Toxitron, BWD 10)";
	sound = 1;
};

GTFO.SpellID["91471"] = {
	--desc = "Chemical Cloud (Toxitron, BWD 25)";
	sound = 1;
};

GTFO.SpellID["91472"] = {
	--desc = "Chemical Cloud (Toxitron, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["91473"] = {
	--desc = "Chemical Cloud (Toxitron, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["91903"] = {
	--desc = "Whirlwind (Drakonid Drudge, BWD)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["84853"] = {
	--desc = "Dark Pool (Twilight Soul Blade, BoT)";
	sound = 1;
};

GTFO.SpellID["88136"] = {
	--desc = "Whirling Blades (Twilight Brute, BoT 10)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["93358"] = {
	--desc = "Whirling Blades (Twilight Brute, BoT 25)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["88218"] = {
	--desc = "Burning Twilight (Crimsonborne Firestarter, BoT 10)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["93345"] = {
	--desc = "Burning Twilight (Crimsonborne Firestarter, BoT 25)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["87931"] = {
	--desc = "Tremors (Earth Ravager, BoT 10)";
	sound = 1;
};

GTFO.SpellID["93351"] = {
	--desc = "Tremors (Earth Ravager, BoT 25)";
	sound = 1;
};

GTFO.SpellID["80270"] = {
	--desc = "Shadowflame DoT (Ivoroc/Maimgor/Pyrecraw, BWD 10)";
	sound = 1;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["80272"] = {
	--desc = "Shadowflame (Ivoroc/Maimgor/Pyrecraw, BWD 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["91908"] = {
	--desc = "Shadowflame DoT (Ivoroc/Maimgor/Pyrecraw, BWD 25)";
	sound = 1;
	tankSound = 0;
	applicationOnly = true;
};

GTFO.SpellID["91899"] = {
	--desc = "Shadowflame (Ivoroc/Maimgor/Pyrecraw, BWD 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["80411"] = {
	--desc = "Flame Breath (Pyrecraw, BWD 10)";
	sound = 1;
};

GTFO.SpellID["91892"] = {
	--desc = "Flame Breath (Pyrecraw, BWD 25)";
	sound = 1;
};

GTFO.SpellID["80651"] = {
	--desc = "Whirlwind (Spirit of Burningeye, BWD 10)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["91888"] = {
	--desc = "Whirlwind (Spirit of Burningeye, BWD 25)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["88536"] = {
	--desc = "Lava Spout (Hyjal)";
	sound = 1;
	vehicle = true;
};

GTFO.SpellID["93372"] = {
	--desc = "Evolved Drakonaar (Blade Tempest)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["93362"] = {
	--desc = "Flamestrike (Bound Inferno, BoT 10)";
	sound = 1;
};

GTFO.SpellID["93364"] = {
	--desc = "Flamestrike (Residual, BoT 10)";
	sound = 1;
};

GTFO.SpellID["93383"] = {
	--desc = "Flamestrike (Bound Inferno, BoT 25)";
	sound = 1;
};

GTFO.SpellID["93384"] = {
	--desc = "Flamestrike (Residual, BoT 25)";
	sound = 1;
};

GTFO.SpellID["92467"] = {
	--desc = "Static Overload (Arion, BoT 10H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["92468"] = {
	--desc = "Static Overload (Arion, BoT 25H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["92987"] = {
	--desc = "Dark Sludge (Maloriak, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92988"] = {
	--desc = "Dark Sludge (Maloriak, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["83578"] = {
	--desc = "Gravity Well (Terrastra, BoT)";
	sound = 2;
};

GTFO.SpellID["86282"] = {
	--desc = "Toxic Spores (Ravenous Creeper, T4W 10)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
};

GTFO.SpellID["93120"] = {
	--desc = "Toxic Spores (Ravenous Creeper, T4W 25)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
};

GTFO.SpellID["93121"] = {
	--desc = "Toxic Spores (Ravenous Creeper, T4W 10H)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
};

GTFO.SpellID["93122"] = {
	--desc = "Toxic Spores (Ravenous Creeper, T4W 25H)";
	sound = 1;
	tankSound = 2;
	applicationOnly = true;
};

GTFO.SpellID["85471"] = {
	--desc = "Pooled Blood (Faceless Guardian, BoT 10)";
	sound = 1;
};

GTFO.SpellID["95773"] = {
	--desc = "Pooled Blood (Faceless Guardian, BoT 25)";
	sound = 1;
};

GTFO.SpellID["81538"] = {
	--desc = "Blaze (Cho'gall, BoT 10)";
	sound = 1;
};

GTFO.SpellID["93214"] = {
	--desc = "Blaze (Cho'gall, BoT 25)";
	sound = 1;
};

GTFO.SpellID["93212"] = {
	--desc = "Blaze (Cho'gall, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["93213"] = {
	--desc = "Blaze (Cho'gall, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["77939"] = {
	--desc = "Lightning Discharge 1 (Onyxia, BWD 10)";
	sound = 1;
};

GTFO.SpellID["77942"] = {
	--desc = "Lightning Discharge 2 (Onyxia, BWD 10)";
	sound = 1;
};

GTFO.SpellID["77943"] = {
	--desc = "Lightning Discharge 3 (Onyxia, BWD 10)";
	sound = 1;
};

GTFO.SpellID["77944"] = {
	--desc = "Lightning Discharge 4 (Onyxia, BWD 10)";
	sound = 1;
};

GTFO.SpellID["94107"] = {
	--desc = "Lightning Discharge 1 (Onyxia, BWD 25)";
	sound = 1;
};

GTFO.SpellID["94110"] = {
	--desc = "Lightning Discharge 2 (Onyxia, BWD 25)";
	sound = 1;
};

GTFO.SpellID["94113"] = {
	--desc = "Lightning Discharge 3 (Onyxia, BWD 25)";
	sound = 1;
};

GTFO.SpellID["94116"] = {
	--desc = "Lightning Discharge 4 (Onyxia, BWD 25)";
	sound = 1;
};

GTFO.SpellID["94108"] = {
	--desc = "Lightning Discharge 1 (Onyxia, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["94111"] = {
	--desc = "Lightning Discharge 2 (Onyxia, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["94114"] = {
	--desc = "Lightning Discharge 3 (Onyxia, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["94117"] = {
	--desc = "Lightning Discharge 4 (Onyxia, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["94109"] = {
	--desc = "Lightning Discharge 1 (Onyxia, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["94112"] = {
	--desc = "Lightning Discharge 2 (Onyxia, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["94115"] = {
	--desc = "Lightning Discharge 3 (Onyxia, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["94118"] = {
	--desc = "Lightning Discharge 4 (Onyxia, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["81831"] = {
	--desc = "Corruption: Sickness (Cho'gall, BoT 10)";
	sound = 4;
};

GTFO.SpellID["93200"] = {
	--desc = "Corruption: Sickness (Cho'gall, BoT 25)";
	sound = 4;
};

GTFO.SpellID["93201"] = {
	--desc = "Corruption: Sickness (Cho'gall, BoT 10H)";
	sound = 4;
};

GTFO.SpellID["93202"] = {
	--desc = "Corruption: Sickness (Cho'gall, BoT 25H)";
	sound = 4;
};

GTFO.SpellID["97368"] = {
	--desc = "Poison Cloud (ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97086"] = {
	--desc = "Tiki Torch (Tiki Lord Mu'Loa, ZG)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 96822; -- Tiki Torch
	negatingIgnoreTime = 2;
};

GTFO.SpellID["97092"] = {
	--desc = "Toxic Link (High Priest Venoxis, ZG)";
	sound = 4;
	ignoreSelfInflicted = true;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97084"] = {
	--desc = "Breath of Hethiss (Venomguard Destroyer, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97338"] = {
	--desc = "Venomous Effusion (High Priest Venoxis, ZG)";
	sound = 1;
};

GTFO.SpellID["97330"] = {
	--desc = "Breath of Hethiss (High Priest Venoxis, ZG)";
	sound = 1;
};

GTFO.SpellID["97085"] = {
	--desc = "Pool of Acrid Tears (High Priest Venoxis, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97089"] = {
	--desc = "Pool of Acrid Tears (High Priest Venoxis, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["96512"] = {
	--desc = "Pool of Acrid Tears (High Priest Venoxis, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["96755"] = {
	--desc = "Pool of Acrid Tears (High Priest Venoxis, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97104"] = {
	--desc = "Bloodvenom (High Priest Venoxis, ZG)";
	sound = 1;
};

GTFO.SpellID["97352"] = {
	--desc = "Yoga Flame (Tiki Torch, ZG)";
	sound = 1;
};

GTFO.SpellID["96953"] = {
	--desc = "Blood Leech (Gurubashi Blood Drinker, ZG)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["96957"] = {
	--desc = "Tears of Blood (High Priestess Kilnara, ZG)";
	sound = 1;
	tankSound = 2;
};

GTFO.SpellID["96916"] = {
	--desc = "Zanzili Fire (Zanzil, ZG)";
	sound = 1;
};

GTFO.SpellID["96434"] = {
	--desc = "Zanzil's Graveyard Gas (Zanzil, ZG)";
	sound = 1;
	negatingDebuffSpellID = 96328 -- Toxic Torment
};

GTFO.SpellID["97320"] = {
	--desc = "Sunder Rift (Gurubashi Spirit Warrior, ZG)";
	sound = 1;
};

GTFO.SpellID["97173"] = {
	--desc = "Shadow of Hakkar (Jin'do the Godbreaker, ZG)";
	sound = 1;
	negatingDebuffSpellID = 97170 -- Deadzone
};

GTFO.SpellID["79501"] = {
	--desc = "Acquiring Target (Magmatron, BWD 10)";
	soundFunction = function() 
		-- Magma
		GTFO_AddEvent("MagmatronFlame", 12);
		return 0;
	end
};

GTFO.SpellID["79504"] = {
	--desc = "Flamethrower (Magmatron, BWD 10)";
	sound = 1;
	ignoreEvent = "MagmatronFlame";
};

GTFO.SpellID["92035"] = {
	--desc = "Acquiring Target (Magmatron, BWD 25)";
	soundFunction = GTFO.SpellID["79501"].soundFunction;
};

GTFO.SpellID["91535"] = {
	--desc = "Flamethrower (Magmatron, BWD 25)";
	sound = 1;
	ignoreEvent = "MagmatronFlame";
};

GTFO.SpellID["92036"] = {
	--desc = "Acquiring Target (Magmatron, BWD 10H)";
	soundFunction = GTFO.SpellID["79501"].soundFunction;
};

GTFO.SpellID["91536"] = {
	--desc = "Flamethrower (Magmatron, BWD 10H)";
	sound = 1;
	ignoreEvent = "MagmatronFlame";
};

GTFO.SpellID["92037"] = {
	--desc = "Acquiring Target (Magmatron, BWD 25H)";
	soundFunction = GTFO.SpellID["79501"].soundFunction;
};

GTFO.SpellID["91537"] = {
	--desc = "Flamethrower (Magmatron, BWD 25H)";
	sound = 1;
	ignoreEvent = "MagmatronFlame";
};

GTFO.SpellID["77679"] = {
	--desc = "Scorching Blast (Maloriak, BWD 10)";
	sound = 1;
	tankSound = 0;
	affirmingDebuffSpellID = 77786 -- Consuming Flames
};

GTFO.SpellID["92968"] = {
	--desc = "Scorching Blast (Maloriak, BWD 25)";
	sound = 1;
	tankSound = 0;
	affirmingDebuffSpellID = 92971 -- Consuming Flames
};

GTFO.SpellID["92969"] = {
	--desc = "Scorching Blast (Maloriak, BWD 10H)";
	sound = 1;
	tankSound = 0;
	affirmingDebuffSpellID = 92972 -- Consuming Flames
};

GTFO.SpellID["92970"] = {
	--desc = "Scorching Blast (Maloriak, BWD 25H)";
	sound = 1;
	tankSound = 0;
	affirmingDebuffSpellID = 92973 -- Consuming Flames
};

GTFO.SpellID["97497"] = {
	--desc = "Flame Breath (Jin'alai, ZA)";
	sound = 1;
};

GTFO.SpellID["97300"] = {
	--desc = "Electrical Storm (Akil'zon, ZA)";
	sound = 1;
};

GTFO.SpellID["78862"] = {
	--desc = "Twilight Pulse (Halion, Heroic Ruby Sanctum)";
	sound = 1;
};

GTFO.SpellID["95822"] = {
	--desc = "Twilight Flames (Sinestra, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92958"] = {
	--desc = "Twilight Pulse (Sinestra, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92959"] = {
	--desc = "Twilight Pulse (Sinestra, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["92852"] = {
	--desc = "Twilight Slicer (Sinestra, BoT 10H)";
	sound = 1;
};

GTFO.SpellID["92954"] = {
	--desc = "Twilight Slicer (Sinestra, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["88146"] = {
	--desc = "Twilight Essence (Sinestra, BoT 10H)";
	sound = 2;
	negatingBuffSpellID = 87231 -- Fiery Barrier
};

GTFO.SpellID["92950"] = {
	--desc = "Twilight Essence (Sinestra, BoT 25H)";
	sound = 2;
	negatingBuffSpellID = 87231 -- Fiery Barrier
};

GTFO.SpellID["92950"] = {
	--desc = "Twilight Essence (Sinestra, BoT 25H)";
	sound = 2;
	negatingBuffSpellID = 87231 -- Fiery Barrier
};

GTFO.SpellID["92954"] = {
	--desc = "Twilight Slicer (Sinestra, BoT 25H)";
	sound = 1;
};

GTFO.SpellID["92134"] = {
	--desc = "Ignition (Magmaw, BWD H)";
	sound = 1;
};

GTFO.SpellID["92197"] = {
	--desc = "Ignition (Magmaw, BWD 10H)";
	sound = 1;
};

GTFO.SpellID["92198"] = {
	--desc = "Ignition (Magmaw, BWD 25H)";
	sound = 1;
};

GTFO.SpellID["92051"] = {
	--desc = "Shadow Conductor (Electron, BWD 10H)";
	sound = 1;
	tankSound = 2;
	damageMinimum = 20000;
	test = true; -- Needs verification
};

GTFO.SpellID["92135"] = {
	--desc = "Shadow Conductor (Electron, BWD 25H)";
	sound = 1;
	tankSound = 2;
	damageMinimum = 20000;
	test = true; -- Needs verification
};

GTFO.SpellID["81761"] = {
	--desc = "Spilled Blood of the Old God (Cho'gall, BoT 10)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["93172"] = {
	--desc = "Spilled Blood of the Old God (Cho'gall, BoT 25)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["93173"] = {
	--desc = "Spilled Blood of the Old God (Cho'gall, BoT 10H)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["93174"] = {
	--desc = "Spilled Blood of the Old God (Cho'gall, BoT 25H)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["97988"] = {
	--desc = "Minor Earthquake (Zandalari Juggernaut, ZA)";
	sound = 1;
};

GTFO.SpellID["97682"] = {
	--desc = "Burn (Daakara, ZA)";
	sound = 1;
};

GTFO.SpellID["43429"] = {
	--desc = "Consecration (Hex Lord Malacrass, ZA)";
	sound = 1;
};

GTFO.SpellID["61603"] = {
	--desc = "Death and Decay (Hex Lord Malacrass, ZA)";
	sound = 1;
};

GTFO.SpellID["43440"] = {
	--desc = "Rain of Fire (Hex Lord Malacrass, ZA)";
	sound = 1;
};

GTFO.SpellID["77826"] = {
	--desc = "Shadowflame Breath (Onyxia and Nefarian, BWD 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["94124"] = {
	--desc = "Shadowflame Breath (Onyxia and Nefarian, BWD 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["94125"] = {
	--desc = "Shadowflame Breath (Onyxia and Nefarian, BWD 10H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["94126"] = {
	--desc = "Shadowflame Breath (Onyxia and Nefarian, BWD 25H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["78495"] = {
	--desc = "Aura of Dread (Nefarian, BWD)";
	sound = 1;
};

GTFO.SpellID["79347"] = {
	--desc = "Explosive Cinders - Friendly Fire (Nefarian, BWD)";
	sound = 4;
};

GTFO.SpellID["96711"] = {
	--desc = "Lightning Cloud (Wushoolay, ZG)";
	sound = 1;
};

GTFO.SpellID["43114"] = {
	--desc = "Fire Wall (Jan'alai, ZA)";
	sound = 1;
};

GTFO.SpellID["97645"] = {
	--desc = "Feather Cyclone (Daakara, ZG)";
	sound = 1;
};

GTFO.SpellID["97644"] = {
	--desc = "Smoke Bomb (Hex Lord Malacrass, ZA)";
	sound = 2;
};

GTFO.SpellID["98463"] = {
	--desc = "Volcanic Fire (Alysrazor, FL)";
	sound = 1;
};

--[[
GTFO.SpellID["100745"] = {
	--desc = "Firestorm (Alysrazor, FL 10)";
	sound = 1;
};

GTFO.SpellID["101664"] = {
	--desc = "Firestorm (Alysrazor, FL 25)";
	sound = 1;
};
]]--

GTFO.SpellID["101665"] = {
	--desc = "Firestorm (Alysrazor, FL 10H)";
	sound = 1;
};

GTFO.SpellID["101666"] = {
	--desc = "Firestorm (Alysrazor, FL 25H)";
	sound = 1;
};

GTFO.SpellID["98885"] = {
	--desc = "Brushfire (Alysrazor, FL 10)";
	sound = 1;
};

GTFO.SpellID["100715"] = {
	--desc = "Brushfire (Alysrazor, FL 25)";
	sound = 1;
};

GTFO.SpellID["100716"] = {
	--desc = "Brushfire (Alysrazor, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100717"] = {
	--desc = "Brushfire (Alysrazor, FL 25H)";
	sound = 1;
};

GTFO.SpellID["99794"] = {
	--desc = "Fiery Vortex (Alysrazor, FL)";
	sound = 1;
};

GTFO.SpellID["99816"] = {
	--desc = "Fiery Tornado (Alysrazor, FL 10)";
	sound = 1;
};

GTFO.SpellID["100733"] = {
	--desc = "Fiery Tornado (Alysrazor, FL 25)";
	sound = 1;
};

GTFO.SpellID["100734"] = {
	--desc = "Fiery Tornado (Alysrazor, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100735"] = {
	--desc = "Fiery Tornado (Alysrazor, FL 25H)";
	sound = 1;
};

GTFO.SpellID["99224"] = {
	--desc = "Engulfing Flames (Ragnaros, FL 10)";
	sound = 1;
};

GTFO.SpellID["100187"] = {
	--desc = "Engulfing Flames (Ragnaros, FL 25)";
	sound = 1;
};

GTFO.SpellID["100188"] = {
	--desc = "Engulfing Flames (Ragnaros, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100189"] = {
	--desc = "Engulfing Flames (Ragnaros, FL 25H)";
	sound = 1;
};

GTFO.SpellID["79353"] = {
	--desc = "Shadow of Cowardice (Nefarian, BWD)";
	sound = 1;
};

GTFO.SpellID["97212"] = {
	--desc = "Focused Fire 10K (Occu'thar, BH)";
	sound = 1;
};

GTFO.SpellID["96883"] = {
	--desc = "Focused Fire 35K (Occu'thar, BH)";
	sound = 1;
};

GTFO.SpellID["99506"] = {
	--desc = "The Widow's Kiss (Beth'tilac, FL)";
	sound = 4;
	negatingDebuffSpellID = 99506; -- The Widow's Kiss
};

GTFO.SpellID["98472"] = {
	--desc = "Magma (Lord Rhyolith, FL)";
	sound = 1;
};

GTFO.SpellID["99427"] = {
	--desc = "Incendiary Cloud (Alysrazor, FL 10)";
	sound = 1;
};

GTFO.SpellID["100729"] = {
	--desc = "Incendiary Cloud (Alysrazor, FL 25)";
	sound = 1;
};

GTFO.SpellID["100730"] = {
	--desc = "Incendiary Cloud (Alysrazor, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100731"] = {
	--desc = "Incendiary Cloud (Alysrazor, FL 25H)";
	sound = 1;
};

GTFO.SpellID["99336"] = {
	--desc = "Lava Spew (Alysrazor, FL 10)";
	sound = 1;
};

GTFO.SpellID["100725"] = {
	--desc = "Lava Spew (Alysrazor, FL 25)";
	sound = 1;
};

GTFO.SpellID["100726"] = {
	--desc = "Lava Spew (Alysrazor, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100727"] = {
	--desc = "Lava Spew (Alysrazor, FL 25H)";
	sound = 1;
};

GTFO.SpellID["100640"] = {
	--desc = "Harsh Winds (Alysrazor, FL)";
	sound = 1;
};

GTFO.SpellID["99842"] = {
	--desc = "Magma Rupture (Shannox, FL 10)";
	sound = 1;
};

GTFO.SpellID["101205"] = {
	--desc = "Magma Rupture (Shannox, FL 25)";
	sound = 1;
};

GTFO.SpellID["101206"] = {
	--desc = "Magma Rupture (Shannox, FL 10H)";
	sound = 1;
};

GTFO.SpellID["101207"] = {
	--desc = "Magma Rupture (Shannox, FL 25H)";
	sound = 1;
};

GTFO.SpellID["91719"] = {
	--desc = "Harvest (Foe Reaper 5000, Deadmines Heroic)";
	sound = 1;
	vehicle = true;
};

GTFO.SpellID["92982"] = {
	--desc = "Engulfing Darkness (Maloriak, BWD 10H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["92983"] = {
	--desc = "Engulfing Darkness (Maloriak, BWD 25H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["99144"] = {
	--desc = "Blazing Heat (Ragnaros, FL 10)";
	sound = 1;
};

GTFO.SpellID["100303"] = {
	--desc = "Blazing Heat (Ragnaros, FL 25)";
	sound = 1;
};

GTFO.SpellID["100304"] = {
	--desc = "Blazing Heat (Ragnaros, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100305"] = {
	--desc = "Blazing Heat (Ragnaros, FL 25H)";
	sound = 1;
};

GTFO.SpellID["97151"] = {
	--desc = "Magma (Firelands)";
	sound = 1;
};

GTFO.SpellID["99758"] = {
	--desc = "Flame Breath (Ancient Core Hound, FL)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["98107"] = {
	--desc = "Lylagar's Breath (Lylagar, Hyjal)";
	sound = 1;
};

GTFO.SpellID["98111"] = {
	--desc = "Lylagar's Breath (Lylagar, Hyjal)";
	sound = 1;
};

GTFO.SpellID["86292"] = {
	--desc = "Cyclone Shield (Grand Vizier Ertan, VP)";
	sound = 1;
};

GTFO.SpellID["93991"] = {
	--desc = "Cyclone Shield (Grand Vizier Ertan, H VP)";
	sound = 1;
};

GTFO.SpellID["98598"] = {
	--desc = "Immolation (Lord Rhyolith, FL 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["100414"] = {
	--desc = "Immolation (Lord Rhyolith, FL 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["99899"] = {
	--desc = "Distant Flame (Lord Rhyolith, FR)";
	sound = 1;
};

GTFO.SpellID["100794"] = {
	--desc = "Flame Torrent (Flame Archon, FR 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["100794"] = {
	--desc = "Flame Torrent (Flame Archon, FR 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["99256"] = {
	--desc = "Torment (Baleroc, FR 10)";
	sound = 1;
	affirmingDebuffSpellID = 99257 -- Tormented
};

GTFO.SpellID["100230"] = {
	--desc = "Torment (Baleroc, FR 25)";
	sound = 1;
	affirmingDebuffSpellID = 99402 -- Tormented
};

GTFO.SpellID["100231"] = {
	--desc = "Torment (Baleroc, FR 10H)";
	sound = 1;
	affirmingDebuffSpellID = 99403 -- Tormented
};

GTFO.SpellID["100232"] = {
	--desc = "Torment (Baleroc, FR 25H)";
	sound = 1;
	affirmingDebuffSpellID = 99404 -- Tormented
};

GTFO.SpellID["98371"] = {
	--desc = "Wild Barrage (Flamewalker Hunter, MF)";
	sound = 1;
};

GTFO.SpellID["98659"] = {
	--desc = "Ember Pool (Emberspit Scorpion, MF)";
	sound = 2;
};

GTFO.SpellID["100070"] = {
	--desc = "Molten Barrage (Blazing Monstrosity, FL)";
	sound = 1;
};

GTFO.SpellID["99844"] = {
	--desc = "Blazing Claw (Alysrazor, FL 10)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["101729"] = {
	--desc = "Blazing Claw (Alysrazor, FL 25)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["101730"] = {
	--desc = "Blazing Claw (Alysrazor, FL 10H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["101731"] = {
	--desc = "Blazing Claw (Alysrazor, FL 25H)";
	sound = 1;
	tankSound = 0;
};

GTFO.SpellID["100262"] = {
	--desc = "Fire Torrent (Ancient Firelord, MF)";
	sound = 1;
};

GTFO.SpellID["101329"] = {
	--desc = "Chaotic Growth (Alysra, Hyjal)";
	sound = 1;
};

GTFO.SpellID["101322"] = {
	--desc = "Living Flame (Alysra, Hyjal)";
	sound = 1;
};

GTFO.SpellID["100222"] = {
	--desc = "Creeping Inferno (Devout Harbinger, MF)";
	sound = 1;
};

GTFO.SpellID["100237"] = {
	--desc = "Creeping Inferno - Incoming (Devout Harbinger, MF)";
	sound = 1;
};

GTFO.SpellID["100040"] = {
	--desc = "Groundfire (Ancient Smoldering Behemoth, MF)";
	sound = 1;
};

GTFO.SpellID["100154"] = {
	--desc = "Rain of Flame (Ancient Smoldering Behemoth, MF)";
	sound = 1;
};

GTFO.SpellID["98316"] = {
	--desc = "Line of Fire (Ancient Charscale, MF)";
	sound = 1;
};

GTFO.SpellID["99705"] = {
	--desc = "Kneel to the Flame (Druid of the Flame, FL 10)";
	sound = 1;
};

GTFO.SpellID["100101"] = {
	--desc = "Kneel to the Flame (Druid of the Flame, FL 25)";
	sound = 1;
};

GTFO.SpellID["98535"] = {
	--desc = "Leaping Flames (Majordomo Staghelm, FL 10)";
	sound = 1;
};

GTFO.SpellID["100206"] = {
	--desc = "Leaping Flames (Majordomo Staghelm, FL 25)";
	sound = 1;
};

GTFO.SpellID["100207"] = {
	--desc = "Leaping Flames (Majordomo Staghelm, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100208"] = {
	--desc = "Leaping Flames (Majordomo Staghelm, FL 25H)";
	sound = 1;
};

GTFO.SpellID["98620"] = {
	--desc = "Searing Seed (Majordomo Staghelm, FL 10)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["100215"] = {
	--desc = "Searing Seed (Majordomo Staghelm, FL 25)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["100216"] = {
	--desc = "Searing Seed (Majordomo Staghelm, FL 10H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["100217"] = {
	--desc = "Searing Seed (Majordomo Staghelm, FL 25H)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["99278"] = {
	--desc = "Volatile Poison (Beth'tilac, FL 10H)";
	sound = 1;
};

GTFO.SpellID["101133"] = {
	--desc = "Volatile Poison (Beth'tilac, FL 25H)";
	sound = 1;
};

GTFO.SpellID["99510"] = {
	--desc = "Lava (Lava Wielder, FL)";
	sound = 1;
};

GTFO.SpellID["99907"] = {
	--desc = "Magma (Ragnaros, FL 10)";
	sound = 1;
};

GTFO.SpellID["100388"] = {
	--desc = "Magma (Ragnaros, FL 10)";
	sound = 1;
};

GTFO.SpellID["100389"] = {
	--desc = "Magma (Ragnaros, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100390"] = {
	--desc = "Magma (Ragnaros, FL 25H)";
	sound = 1;
};

GTFO.SpellID["100247"] = {
	--desc = "Tormented by Flame (Branch of Nordrassil, FL)";
	sound = 1;
};

GTFO.SpellID["100193"] = {
	--desc = "Conflagration (Volcanus, FL)";
	sound = 1;
};

GTFO.SpellID["98870"] = {
	--desc = "Scorched Ground (Ragnaros, FL 10)";
	sound = 1;
};

GTFO.SpellID["100122"] = {
	--desc = "Scorched Ground (Ragnaros, FL 25)";
	sound = 1;
};

GTFO.SpellID["100123"] = {
	--desc = "Scorched Ground (Ragnaros, FL 10H)";
	sound = 1;
};

GTFO.SpellID["100124"] = {
	--desc = "Scorched Ground (Ragnaros, FL 25H)";
	sound = 1;
};

GTFO.SpellID["101004"] = {
	--desc = "Focused Fire (Occu'thar, BH 25)";
	sound = 1;
};

--[[
Need more information to implement this
GTFO.SpellID["100941"] = {
	--desc = "Dreadflame (Ragnaros, FL 10H)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["100998"] = {
	--desc = "Dreadflame (Ragnaros, FL 25H)";
	sound = 1;
	applicationOnly = true;
};
]]--

GTFO.SpellID["101984"] = {
	--desc = "Distortion Bomb (Murozond, ET)";
	sound = 1;
};

GTFO.SpellID["101221"] = {
	--desc = "Wracking Pain (Echo of Sylvanas, ET)";
	sound = 1;
};

GTFO.SpellID["101257"] = {
	--desc = "Wracking Pain (Echo of Sylvanas, ET)";
	sound = 1;
};

GTFO.SpellID["103171"] = {
	--desc = "Blighted Arrows (Echo of Sylvanas, ET)";
	sound = 1;
};

GTFO.SpellID["100763"] = {
	--desc = "Blighted Arrows (Echo of Sylvanas, ET)";
	sound = 1;
};

GTFO.SpellID["103790"] = {
	--desc = "Choking Smoke Bomb (Asira Dawnslayer, HoT)";
	sound = 1;
	alwaysAlert = true;
};

GTFO.SpellID["104528"] = {
	--desc = "Seaping Light (Archbishop Benedictus, HoT)";
	sound = 1;
};

GTFO.SpellID["104537"] = {
	--desc = "Seaping Twilight (Archbishop Benedictus, HoT)";
	sound = 1;
};

GTFO.SpellID["103161"] = {
	--desc = "Righteous Shear (Archbishop Benedictus, HoT)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["103526"] = {
	--desc = "Twilight Shear (Archbishop Benedictus, HoT)";
	sound = 4;
	ignoreSelfInflicted = true;
};

GTFO.SpellID["103653"] = {
	--desc = "Purified (Archbishop Benedictus, HoT)";
	sound = 1;
};

GTFO.SpellID["103775"] = {
	--desc = "Twilight (Archbishop Benedictus, HoT)";
	sound = 1;
};

GTFO.SpellID["104994"] = {
	--desc = "Blade Dance (Alizabal, BH)";
	sound = 1;
};

GTFO.SpellID["105857"] = {
	--desc = "Whirl of Blades (Disciple of Hate, BH)";
	sound = 1;
};

GTFO.SpellID["101819"] = {
	--desc = "Magma (Echo of Baine, ET)";
	sound = 1;
	minimumStacks = 5;
	applicationOnly = true;
};

GTFO.SpellID["100974"] = {
	--desc = "Unleashed Flame (Lord Rhyolith, FL H)";
	sound = 1;
};

GTFO.SpellID["99483"] = {
	--desc = "Twisting Twilight (Thyrinar, Nexus)";
	sound = 1;
};

GTFO.SpellID["108217"] = {
	--desc = "Fel Flames (Peroth'arn, WoE)";
	sound = 1;
};

GTFO.SpellID["108193"] = {
	--desc = "Fel Flames (Peroth'arn, WoE)";
	sound = 1;
};

GTFO.SpellID["107536"] = {
	--desc = "Punishing Flames (Peroth'arn, WoE)";
	sound = 1;
};

GTFO.SpellID["102267"] = {
	--desc = "Blizzard (Enchanted Highmistress, WoE)";
	sound = 1;
};

GTFO.SpellID["102466"] = {
	--desc = "Coldflame (Enchanted Magus, WoE)";
	sound = 1;
};

GTFO.SpellID["102455"] = {
	--desc = "Arcane Bomb (Enchanted Magus, WoE)";
	sound = 1;
};

GTFO.SpellID["103891"] = {
	--desc = "Fel Flames (Mannoroth, WoE)";
	soundFunction = function() 
		if (GTFO_HasDebuff("player", 103954) or GTFO_HasDebuff("player", 103952)) then
			-- Has Waters of Eternity protection
			return 2;
		else
			-- No protection!
			return 1;
		end
	end
};

GTFO.SpellID["103785"] = {
	--desc = "Black Blood of the Earth (Morchok, DS 10)";
	sound = 1;
};

GTFO.SpellID["108570"] = {
	--desc = "Black Blood of the Earth (Morchok, DS 25)";
	sound = 1;
};

GTFO.SpellID["110287"] = {
	--desc = "Black Blood of the Earth (Morchok, DS 10H)";
	sound = 1;
};

GTFO.SpellID["110288"] = {
	--desc = "Black Blood of the Earth (Morchok, DS 25H)";
	sound = 1;
};

GTFO.SpellID["107792"] = {
	--desc = "Flood (Ancient Water Lord, DS 25)";
	sound = 1;
	negatingDebuffSpellID = 107797; -- Flood
};

GTFO.SpellID["107677"] = {
	--desc = "Dust Storm (Earthen Destroyer, DS)";
	sound = 1;
};

GTFO.SpellID["109441"] = {
	--desc = "Tornado (Stormbinder Adept, DS)";
	sound = 1;
};

GTFO.SpellID["109360"] = {
	--desc = "Blizzard (Twilight Frost Evoker, DS)";
	sound = 1;
};

GTFO.SpellID["109296"] = {
	--desc = "Frozen Grasp (Lieutenant Shara, DS)";
	sound = 1;
};

GTFO.SpellID["110317"] = {
	--desc = "Watery Entrenchment (Hagara the Stormbinder, DS)";
	sound = 1;
	soundHeroic = 2;
	category = "HagaraWateryEntrenchment";
};

GTFO.SpellID["107850"] = {
	--desc = "Focused Assault (Hagara the Stormbinder, DS)";
	sound = 1;
};

GTFO.SpellID["102286"] = {
	--desc = "Dark Haze (HoT)";
	sound = 1;
};

GTFO.SpellID["105579"] = {
	--desc = "Twilight Flames (Twilight Assaulter, DS)";
	sound = 1;
};

GTFO.SpellID["105705"] = {
	--desc = "Twilight Flames - FF (Twilight Assaulter, DS)";
	sound = 4;
};

GTFO.SpellID["105579"] = {
	--desc = "Twilight Flames (Twilight Assaulter, DS)";
	sound = 1;
};

GTFO.SpellID["108076"] = {
	--desc = "Twilight Flames (Warmaster Blackhorn, DS 10)";
	sound = 1;
};

GTFO.SpellID["109222"] = {
	--desc = "Twilight Flames (Warmaster Blackhorn, DS 25)";
	sound = 1;
};

GTFO.SpellID["109223"] = {
	--desc = "Twilight Flames (Warmaster Blackhorn, DS 10H)";
	sound = 1;
};

GTFO.SpellID["109224"] = {
	--desc = "Twilight Flames (Warmaster Blackhorn, DS 25H)";
	sound = 1;
};

GTFO.SpellID["108051"] = {
	--desc = "Twilight Flames Residue (Warmaster Blackhorn, DS 10)";
	sound = 1;
};

GTFO.SpellID["109216"] = {
	--desc = "Twilight Flames Residue (Warmaster Blackhorn, DS 25)";
	sound = 1;
};

GTFO.SpellID["109217"] = {
	--desc = "Twilight Flames Residue (Warmaster Blackhorn, DS 10H)";
	sound = 1;
};

GTFO.SpellID["109218"] = {
	--desc = "Twilight Flames Residue (Warmaster Blackhorn, DS 25H)";
	sound = 1;
};

GTFO.SpellID["105238"] = {
	--desc = "Undying Flame (Time-Twisted Drake, HoT)";
	sound = 1;
	test = true; -- Needs verification
};

GTFO.SpellID["102131"] = {
	--desc = "Erupting Lava (Time-Twisted Breaker, HoT)";
	sound = 1;
	test = true; -- Needs verification
};

GTFO.SpellID["102130"] = {
	--desc = "Ruptured Ground (Time-Twisted Breaker, HoT)";
	sound = 1;
	test = true; -- Needs verification
};

GTFO.SpellID["103534"] = {
	--desc = "Danger (Morchok, DS)";
	sound = 1;
	applicationOnly = true;
};

GTFO.SpellID["110095"] = {
	--desc = "Deck Fire (Warmaster Blackhorn, DS H)";
	sound = 1;
};

GTFO.SpellID["108787"] = {
	--desc = "Parasitic Backlash (Deathwing, DS H)";
	sound = 4;
};

