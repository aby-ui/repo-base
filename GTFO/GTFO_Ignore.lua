--------------------------------------------------------------------------
-- GTFO_Ignore.lua 
--------------------------------------------------------------------------
--[[
GTFO Ignore List
]]--

GTFO.IgnoreSpellCategory["Fatigue"] = {
	spellID = 3271, -- Not really the spell, but a good placeholder
	desc = "Fatigue",
	tooltip = "Alert when entering a fatigue area",
	override = true
}

if (not (GTFO.ClassicMode or GTFO.BurningCrusadeMode)) then

	GTFO.IgnoreSpellCategory["HagaraWateryEntrenchment"] = {
		-- mobID = 55689; -- Hagara the Stormbinder
		spellID = 110317,
		desc = "Watery Entrenchment (Hagara)"
	}

	GTFO.IgnoreSpellCategory["GarroshDesecrated"] = {
		-- Garrosh Hellscream
		spellID = 144762,
		desc = "Desecrated Axe (Garrosh Phase 1 & 2)",
		tooltip = "Alert from the Desecrated Axe from Garrosh Hellscream (Phase 1 & 2)",
		override = true
	}

	GTFO.IgnoreSpellCategory["EyeOfCorruption2"] = {
		-- 8.3 Corruption
		spellID = 315161,
		desc = "Eye of Corruption (8.3 BFA)",
		isDefault = true,
	}
end

-- Scanner ignore list
GTFO.IgnoreScan["124255"] = true; -- Monk's Stagger
GTFO.IgnoreScan["124275"] = true; -- Monk's Light Stagger
GTFO.IgnoreScan["34650"] = true; -- Mana Leech
GTFO.IgnoreScan["123051"] = true; -- Mana Leech
GTFO.IgnoreScan["134821"] = true; -- Discharged Energy
GTFO.IgnoreScan["114216"] = true; -- Angelic Bulwark
GTFO.IgnoreScan["6788"] = true; -- Weakened Soul
GTFO.IgnoreScan["136193"] = true; -- Arcing Lightning
GTFO.IgnoreScan["139107"] = true; -- Mind Daggers
GTFO.IgnoreScan["156152"] = true; -- Gushing Wounds
GTFO.IgnoreScan["162510"] = true; -- Tectonic Upheavel
GTFO.IgnoreScan["98021"] = true; -- Spirit Link (Shaman)
GTFO.IgnoreScan["148760"] = true; -- Pheromone Cloud
GTFO.IgnoreScan["175982"] = true; -- Rain of Slag
GTFO.IgnoreScan["158519"] = true; -- Quake
GTFO.IgnoreScan["104330"] = true; -- Demonic Synergy
GTFO.IgnoreScan["1604"] = true; -- Dazed
GTFO.IgnoreScan["187464"] = true; -- Shadow Mend
GTFO.IgnoreScan["186439"] = true; -- Shadow Mend
GTFO.IgnoreScan["210279"] = true; -- Creeping Nightmares
GTFO.IgnoreScan["203121"] = true; -- Mark of Taerer
GTFO.IgnoreScan["203125"] = true; -- Mark of Emeriss
GTFO.IgnoreScan["203102"] = true; -- Mark of Ysondre
GTFO.IgnoreScan["203124"] = true; -- Mark of Lethon
GTFO.IgnoreScan["204766"] = true; -- Energy Surge (Skorpyron)
GTFO.IgnoreScan["218503"] = true; -- Recursive Strikes
GTFO.IgnoreScan["218508"] = true; -- Recursive Strikes
GTFO.IgnoreScan["186416"] = true; -- Torment of Flames
GTFO.IgnoreScan["80354"] = true; -- Time Warp
GTFO.IgnoreScan["258018"] = true; -- Sense of Dread
GTFO.IgnoreScan["294856"] = true; -- Unstable Mixture
GTFO.IgnoreScan["287769"] = true; -- N'Zoth's Awareness
GTFO.IgnoreScan["306583"] = true; -- Leaden Foot
GTFO.IgnoreScan["326788"] = true; -- Chilling Winds
GTFO.IgnoreScan["329961"] = true; -- Lycara's Bargain
GTFO.IgnoreScan["322757"] = true; -- Wrath of Zolramus
GTFO.IgnoreScan["325184"] = true; -- Loose Anima
GTFO.IgnoreScan["334909"] = true; -- Oppressive Atmosphere
GTFO.IgnoreScan["332444"] = true; -- Crumbling Foundation
GTFO.IgnoreScan["335298"] = true; -- Giant Fists
GTFO.IgnoreScan["326469"] = true; -- Torment: Soulforge heat
GTFO.IgnoreScan["347668"] = true; -- Grasp of Death
GTFO.IgnoreScan["358198"] = true; -- Black Heat
GTFO.IgnoreScan["355786"] = true; -- Blackened Armor
GTFO.IgnoreScan["356846"] = true; -- Lingering Flames
GTFO.IgnoreScan["357231"] = true; -- Anguish
GTFO.IgnoreScan["356253"] = true; -- Dreadbugs
GTFO.IgnoreScan["356447"] = true; -- Dreadbugs
GTFO.IgnoreScan["209858"] = true; -- Necrotic Wound
GTFO.IgnoreScan["355951"] = true; -- Unworthy



