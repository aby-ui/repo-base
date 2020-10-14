--[[ Attributes: Damage, Heal, Energy, Miscellaneous ]]

do 
	local _detalhes = _G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

	--> Globals
	--[[global]] DETAILS_ATTRIBUTE_DAMAGE = 1
	
		--[[global]] DETAILS_SUBATTRIBUTE_DAMAGEDONE = 1
		--[[global]] DETAILS_SUBATTRIBUTE_DPS = 2
		--[[global]] DETAILS_SUBATTRIBUTE_DAMAGETAKEN = 3
		--[[global]] DETAILS_SUBATTRIBUTE_FRIENDLYFIRE = 4
		--[[global]] DETAILS_SUBATTRIBUTE_FRAGS = 5
		--[[global]] DETAILS_SUBATTRIBUTE_ENEMIES = 6
		--[[global]] DETAILS_SUBATTRIBUTE_VOIDZONES = 7
		--[[global]] DETAILS_SUBATTRIBUTE_BYSPELLS = 8

	--[[global]] DETAILS_ATTRIBUTE_HEAL = 2
	
		--[[global]] DETAILS_SUBATTRIBUTE_HEALDONE = 1
		--[[global]] DETAILS_SUBATTRIBUTE_HPS = 2
		--[[global]] DETAILS_SUBATTRIBUTE_OVERHEAL = 3
		--[[global]] DETAILS_SUBATTRIBUTE_HEALTAKEN = 4
		--[[global]] DETAILS_SUBATTRIBUTE_HEALENEMY = 5
		--[[global]] DETAILS_SUBATTRIBUTE_HEALPREVENTED = 6
		--[[global]] DETAILS_SUBATTRIBUTE_HEALABSORBED = 7
	
	--[[global]] DETAILS_ATTRIBUTE_ENERGY = 3
	
		--[[global]] DETAILS_SUBATTRIBUTE_REGENMANA = 1
		--[[global]] DETAILS_SUBATTRIBUTE_REGENRAGE = 2
		--[[global]] DETAILS_SUBATTRIBUTE_REGENENERGY = 3
		--[[global]] DETAILS_SUBATTRIBUTE_REGENRUNE = 4
		--[[global]] DETAILS_SUBATTRIBUTE_RESOURCES = 5
		--[[global]] DETAILS_SUBATTRIBUTE_ALTERNATEPOWER = 6
	
	--[[global]] DETAILS_ATTRIBUTE_MISC = 4
	
		--[[global]] DETAILS_SUBATTRIBUTE_CCBREAK = 1
		--[[global]] DETAILS_SUBATTRIBUTE_RESS = 2
		--[[global]] DETAILS_SUBATTRIBUTE_INTERRUPT = 3
		--[[global]] DETAILS_SUBATTRIBUTE_DISPELL = 4
		--[[global]] DETAILS_SUBATTRIBUTE_DEATH = 5
		--[[global]] DETAILS_SUBATTRIBUTE_DCOOLDOWN = 6
		--[[global]] DETAILS_SUBATTRIBUTE_BUFFUPTIME = 7
		--[[global]] DETAILS_SUBATTRIBUTE_DEBUFFUPTIME = 8

	_detalhes.atributos_capture = {
		"damage", --damage done
		"damage", --dps
		"damage", --damage taken
		"damage", --friendly fire
		"miscdata", --frags
		"damage", --enemy damage
		"aura", --auras
		"damage", --damage taken by spell
		
		"heal", --healing done
		"heal", --hps
		"heal", --overhealing
		"heal", --healing taken
		"heal", --enemy healed
		"heal", --damage prevented
		"heal", --heal absorbed/denied
		
		"energy", --mana restored
		"energy", --rage gained
		"energy", --energy generated
		"energy", --runic power generated
		"energy", --resources
		"energy", --alternate power
		
		"miscdata", --cc breaks
		"miscdata", --ress
		"miscdata", --interrupts
		"miscdata", --dispells
		"miscdata", --deaths
		"miscdata", --cooldowns
		"aura", --buff uptime
		"aura", --debuff uptime
	}
	
	--> Main Attributes
	_detalhes.atributos = {

		--> Attributes amount = 4: damage / heal / energy / misc
		[0] = 4, 
		
		--[[ DAMAGE ]]
			dano = 1,	--> identifier
			[1] = 8,	-->  sub attributes 
		
		--[[ HEALING ]]
			cura = 2,	--> identifier
			[2] = 7,	-->  sub attributes 
		
		--[[ ENERGY ]]
			e_energy = 3,--> identifier
			[3] = 6,	-->  sub attributes 
		
		--[[ MISC ]]
			misc = 4,	--> identifier
			[4] = 8,	-->  sub attributes 
			
		--[[ CUSTOM ]]
			custom = 5,
			[5] = false,
		
		--[[ String Names ]]
		lista = {
			Loc ["STRING_ATTRIBUTE_DAMAGE"],--> Damage
			Loc ["STRING_ATTRIBUTE_HEAL"],	--> Healing
			Loc ["STRING_ATTRIBUTE_ENERGY"],	--> Energy
			Loc ["STRING_ATTRIBUTE_MISC"],	--> Misc
			Loc ["STRING_ATTRIBUTE_CUSTOM"]	--> Custom
		}
	}

	
	--> Sub Attributes
	_detalhes.sub_atributos = {
		{
			--> Damage sub classes information
			damage_done = 1,
			dps = 2,
			damage_taken = 3,
			friendly_fire = 4,
			frags = 5,
			enemies = 6,
			voidzones = 7,
			damage_taken_by_spells = 8,
			lista = {	--[[ String Names ]]
				Loc ["STRING_ATTRIBUTE_DAMAGE_DONE"], 
				Loc ["STRING_ATTRIBUTE_DAMAGE_DPS"],
				Loc ["STRING_ATTRIBUTE_DAMAGE_TAKEN"], 
				Loc ["STRING_ATTRIBUTE_DAMAGE_FRIENDLYFIRE"],
				Loc ["STRING_ATTRIBUTE_DAMAGE_FRAGS"],
				Loc ["STRING_ATTRIBUTE_DAMAGE_ENEMIES"],
				Loc ["STRING_ATTRIBUTE_DAMAGE_DEBUFFS"],
				Loc ["STRING_ATTRIBUTE_DAMAGE_BYSPELL"],
			},
			icones = {
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {0, .125, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {.125, .25, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {.25, .375, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {.375, .5, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {.5, 0.625, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {0.625, .75, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {.75, 0.875, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_damage", {0.875, 1, 0, 1}},
			},
			internal = {"total", "last_dps", "damage_taken", "friendlyfire_total", "frags", "enemies", "voidzones", "damage_taken_by_spells"}
		},

		{
			--> Healing sub classes information
			healing_done = 1,
			hps = 2, 
			overheal = 3,
			healing_tanken = 4,
			heal_enemy_amt = 5,
			totalabsorb = 6,
			totaldenied = 7,
			lista = {	--[[ String Names ]]
				Loc ["STRING_ATTRIBUTE_HEAL_DONE"],
				Loc ["STRING_ATTRIBUTE_HEAL_HPS"],
				Loc ["STRING_ATTRIBUTE_HEAL_OVERHEAL"],
				Loc ["STRING_ATTRIBUTE_HEAL_TAKEN"],
				Loc ["STRING_ATTRIBUTE_HEAL_ENEMY"],
				Loc ["STRING_ATTRIBUTE_HEAL_PREVENT"],
				Loc ["STRING_ATTRIBUTE_HEAL_ABSORBED"],
			},
		
			icones = {
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {0, .125, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {.125, .25, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {.25, .375, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {.375, .5, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {.5, 0.625, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {0.625, 0.75, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_heal", {0.75, 0.75+.125, 0, 1}},
			},
			internal = {"total", "last_hps", "totalover", "healing_taken", "heal_enemy_amt", "totalabsorb", "totaldenied"}
		},
		
		{
			--> Energy sub classes information
			mana_ganha = 1, -- id 0
			rage_ganha = 2, -- id 1
			energy_ganha = 3, --id 3
			rune_ganha = 4, --id 6
			resources = 5, --
			alternatepower = 6, --
			lista = {	--[[ String Names ]]
				Loc ["STRING_ATTRIBUTE_ENERGY_MANA"],
				Loc ["STRING_ATTRIBUTE_ENERGY_RAGE"],
				Loc ["STRING_ATTRIBUTE_ENERGY_ENERGY"],
				Loc ["STRING_ATTRIBUTE_ENERGY_RUNEPOWER"],
				Loc ["STRING_ATTRIBUTE_ENERGY_RESOURCES"],
				Loc ["STRING_ATTRIBUTE_ENERGY_ALTERNATEPOWER"],
			},
			icones = {
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {0, .125, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {.125, .25, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {.25, .375, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {.375, .5, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {.5, .625, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_energyze", {.625, .75, 0, 1}},
			},
			internal = {"mana", "e_rage", "e_energy", "runepower", "resource", "alternatepower"}
		},
		
		{
			--> Misc sub classes information
			cc_break = 1,
			ress = 2,
			kick = 3,
			dispell = 4,
			deaths = 5,
			cooldowns_defensive = 6,
			buff_uptime = 7,
			lista = {	--[[ String Names ]]
				Loc ["STRING_ATTRIBUTE_MISC_CCBREAK"],
				Loc ["STRING_ATTRIBUTE_MISC_RESS"],
				Loc ["STRING_ATTRIBUTE_MISC_INTERRUPT"],
				Loc ["STRING_ATTRIBUTE_MISC_DISPELL"],
				Loc ["STRING_ATTRIBUTE_MISC_DEAD"],
				Loc ["STRING_ATTRIBUTE_MISC_DEFENSIVE_COOLDOWNS"],
				Loc ["STRING_ATTRIBUTE_MISC_BUFF_UPTIME"],
				Loc ["STRING_ATTRIBUTE_MISC_DEBUFF_UPTIME"],
			},
			icones = {
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {0, .125, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {.125, .25, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {.25, .375, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {.375, .5, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {.5, .625, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {.625, 0.75, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {0.75, 0.875, 0, 1}},
				{"Interface\\AddOns\\Details\\images\\atributos_icones_misc", {0.875, 1, 0, 1}}
			},
			internal = {"cc_break", "ress", "interrupt", "dispell", "dead", "cooldowns_defensive", "buff_uptime", "debuff_uptime"}
		}
	}
	
	function _detalhes:GetAttributeName (attribute)
		return _detalhes.atributos.lista [attribute]
	end
	
	function _detalhes:GetSubAttributeName (attribute, subAttribute, customName)
		if (attribute == 5) then
		
			local CustomObject = _detalhes.custom [subAttribute]
			
			if (CustomObject and customName and CustomObject.name == customName) then
				return CustomObject.name
				
			elseif (CustomObject and customName and CustomObject.name ~= customName) then
				for _, custom in ipairs (_detalhes.custom) do
					if (custom.name == customName) then
						return custom.name
					end
				end
				return "--x--x--"
			elseif (CustomObject and not customName) then
				return CustomObject.name
			end
			
			if (not CustomObject) then
				return "--x--x--"
			end
		end
		return _detalhes.sub_atributos [attribute].lista [subAttribute]
	end
	
	function _detalhes:GetInternalSubAttributeName (attribute, subAttribute)
		return _detalhes.sub_atributos [attribute].internal [subAttribute]
	end
	
end
