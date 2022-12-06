-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local RSNotes = private.NewLib("RareScannerNotes")

-- RareScanner general libraries
local RSConstants = private.ImportLib("RareScannerConstants")
local RSUtils = private.ImportLib("RareScannerUtils")

---============================================================================
-- NPCs notes
---============================================================================

function RSNotes.GetNote(entityID, mapID)
	-- Crafting rare NPCs event
	if (RSUtils.Contains(RSConstants.CRAFTING_NPCS, entityID)) then
		return string.format(AL["NOTE_CRAFTING_NPCS"], AL[string.format("NOTE_%s", entityID)])
		
	-- Covenants rare NPCs
	elseif (entityID == RSConstants.WINGFLAYER_CRUEL) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_KYRIAN"], AL["NOTE_TEMPLE_COURAGE"], AL[string.format("NOTE_%s", entityID)])
	elseif (RSUtils.Contains(RSConstants.CITADEL_LOYALTY_NPCS, entityID)) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_KYRIAN"], AL["NOTE_CITADEL_LOYALTY"], AL["NOTE_CITADEL_LOYALTY_NPCS"])
	elseif (entityID == RSConstants.GIEGER) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_NECROLORDS"], AL["NOTE_HOUSE_CONSTRICTS"], AL[string.format("NOTE_%s", entityID)])
	elseif (RSUtils.Contains(RSConstants.THEATER_PAIN_NPCS, entityID)) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_NECROLORDS"], AL["NOTE_THEATER_PAIN"], AL["NOTE_THEATER_PAIN_NPCS"])
	elseif (entityID == RSConstants.FORGEMASTER_MADALAV) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_VENTHYR"], AL["NOTE_DOMINANCE_KEEP"], AL[string.format("NOTE_%s", entityID)])
	elseif (entityID == RSConstants.HARIKA_HORRID) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_VENTHYR"], AL["NOTE_WANECRYPT_HILL"], AL[string.format("NOTE_%s", entityID)])
	elseif (entityID == RSConstants.VALFIR_UNRELENTING) then
		return string.format(AL["NOTE_ANIMA_CONDUCTOR"], AL["NOTE_NIGHT_FAE"], AL["NOTE_TIRNA_SCITHE"], AL[string.format("NOTE_%s", entityID)])
	
	-- Individual note by entityID
	elseif (AL[string.format("NOTE_%s", entityID)] ~= string.format("NOTE_%s", entityID)) then
		return AL[string.format("NOTE_%s", entityID)]
	-- Individual note by entityID and mapID
	elseif (AL[string.format("NOTE_%s_%s", entityID, mapID)] ~= string.format("NOTE_%s_%s", entityID, mapID)) then
		return AL[string.format("NOTE_%s_%s", entityID, mapID)]
	end
	
	-- Notes for dragon glyphs
	if (AL[string.format("NOTE_GLYPH_%s", entityID)] ~= string.format("NOTE_GLYPH_%s", entityID)) then
		return AL[string.format("NOTE_GLYPH_%s", entityID)]
	end
	
	-- Orator Kloe NPCs
	if (RSUtils.Contains(RSConstants.ORATOR_KLOE_NPCS, entityID)) then
		return AL["NOTE_ORATOR_KLOE_NPCS"]
	-- Daffodil NPCs
	elseif (RSUtils.Contains(RSConstants.DAFFODIL_NPCS, entityID)) then
		return AL["NOTE_DAFFODIL_NPCS"]
	-- Abuse of power NPCs
	elseif (RSUtils.Contains(RSConstants.ABUSE_POWER_GI_NPCS, entityID)) then
		return string.format(AL["NOTE_ABUSE_POWER_NPCS"], AL["NOTE_GRAND_INQUISITOR"])
	elseif (RSUtils.Contains(RSConstants.ABUSE_POWER_I_NPCS, entityID)) then
		return string.format(AL["NOTE_ABUSE_POWER_NPCS"], AL["NOTE_INQUISITOR"])
	elseif (RSUtils.Contains(RSConstants.ABUSE_POWER_HI_NPCS, entityID)) then
		return string.format(AL["NOTE_ABUSE_POWER_NPCS"], AL["NOTE_HIGH_INQUISITOR"])
	-- Swelling tear NPCs
	elseif (RSUtils.Contains(RSConstants.SWELLING_TEAR_NPCS, entityID)) then
		return AL["NOTE_SWELLING_TEAR_NPCS"]
	-- Vesper repair NPCs
	elseif (RSUtils.Contains(RSConstants.VESPER_REPAIR_NPCS, entityID)) then
		return AL["NOTE_VESPER_REPAIR_NPCS"]
	-- Dapperdew NPCs
	elseif (RSUtils.Contains(RSConstants.DAPPERDEW_NPCS, entityID)) then
		return AL["NOTE_DAPPERDEW_NPCS"]
	-- Ascended council NPCs
	elseif (RSUtils.Contains(RSConstants.ASCENDED_COUNCIL_NPCS, entityID)) then
		return AL["NOTE_ASCENDED_COUNCIL_NPCS"]
	-- Requires 4 people to summon NPCs
	elseif (RSUtils.Contains(RSConstants.FOUR_PEOPLE_NPCS, entityID)) then
		return AL["NOTE_FOUR_PEOPLE_NPCS"]
	-- Requires entering the rift
	elseif (RSUtils.Contains(RSConstants.RIFT_NPCS, entityID)) then
		return AL["NOTE_RIFT_NPCS"]
	-- Requires entering the rift in the maw
	elseif (RSUtils.Contains(RSConstants.RIFT_NPCS_MAW, entityID)) then
		return AL["NOTE_RIFT_NPCS_MAW"]
	-- Requires elemental storms in Dragon Isles
	elseif (RSUtils.Contains(RSConstants.STORM_EVENTS_NPCS, entityID)) then
		return AL["NOTE_STORM_EVENTS"]
	-- Grand hunting party bosses
	elseif (RSUtils.Contains(RSConstants.HUNTING_PARTY_NPCS, entityID)) then
		return AL["NOTE_HUNTING_PARTY_NPCS"]
	-- Grand hunting party bosses
	elseif (RSUtils.Contains(RSConstants.OMINOUS_CONCHS_NPCS, entityID)) then
		return AL["NOTE_OMINOUS_CONCHS_NPCS"]
	end
	
	-- Rune of constructs Containers
	if (RSUtils.Contains(RSConstants.RUNE_CONSTRUCTS_CONTAINERS, entityID)) then
		return AL["NOTE_RUNE_CONSTRUCTS_CONTAINERS"]
	-- Grappling growth Containers
	elseif (RSUtils.Contains(RSConstants.GRAPPLING_GROWTH_CONTAINERS, entityID)) then
		return AL["NOTE_GRAPPLING_GROWTH_CONTAINERS"]
	-- Greedstone Containers
	elseif (RSUtils.Contains(RSConstants.GREEDSTONE_CONTAINERS, entityID)) then
		return AL["NOTE_GREEDSTONE_CONTAINERS"]
	-- Lunarlight Containers
	elseif (RSUtils.Contains(RSConstants.LUNARLIGHT_CONTAINERS, entityID)) then
		return AL["NOTE_LUNARLIGHT_CONTAINERS"]
	-- Bounding Shroom Containers
	elseif (RSUtils.Contains(RSConstants.BOUNDING_SHRROM_CONTAINERS, entityID)) then
		return AL["NOTE_BOUNDING_SHROOM"]
	-- Ripe purian Containers
	elseif (RSUtils.Contains(RSConstants.RIPE_PURIAN_CONTAINERS, entityID)) then
		return AL["NOTE_RIPE_PURIAN_CONTAINERS"]
	-- Rift hidden containers
	elseif (RSUtils.Contains(RSConstants.RIFT_HIDDEN_ENTITIES, entityID)) then
		return AL["NOTE_RIFT_HIDDEN_CONTAINERS"]
	-- Korthia caches found by Swagsnout gromit
	elseif (RSUtils.Contains(RSConstants.CACHES_SWAGSNOUT_GROMIT, entityID)) then
		return AL["NOTE_CACHEs_SWAGSNOUT_GROMIT"]
	-- The maw stolen anima vessels
	elseif (RSUtils.Contains(RSConstants.STOLEN_ANIMA_VESSEL, entityID)) then
		return AL["NOTE_STOLEN_ANIMA_VESSEL"]
	-- The maw stolen anima vessels (in the rift)
	elseif (RSUtils.Contains(RSConstants.STOLEN_ANIMA_VESSEL_RIFT, entityID)) then
		return AL["NOTE_STOLEN_ANIMA_VESSEL_RIFT"]
	-- Disturbed dirt
	elseif (RSUtils.Contains(RSConstants.DISTURBED_DIRT, entityID)) then
		return AL["NOTE_DISTURBED_DIRT"]
	end
end