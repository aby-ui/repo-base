--[[ Spell Cache store all spells shown on frames and make able to change spells name, icons, etc... ]]

do 

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> On The Fly SpellCache

	local _detalhes = 	_G._detalhes
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
	local _
	local _rawget	=	rawget
	local _rawset	=	rawset
	local _setmetatable =	setmetatable
	local _GetSpellInfo =	GetSpellInfo
	local _unpack	=	unpack

	--> default container
	_detalhes.spellcache =	{}
	local unknowSpell = {Loc ["STRING_UNKNOWSPELL"], _, "Interface\\Icons\\Ability_Druid_Eclipse"} --> localize-me
	
	--> reset spell cache
	function _detalhes:ClearSpellCache()
		_detalhes.spellcache = _setmetatable ({}, 
				{__index = function (tabela, valor) 
					local esta_magia = _rawget (tabela, valor)
					if (esta_magia) then
						return esta_magia
					end

					--> should save only icon and name, other values are not used
					if (valor) then --> check if spell is valid before
						local cache = {_GetSpellInfo (valor)}
						tabela [valor] = cache
						return cache
					else
						return unknowSpell
					end
					
				end})

		--> default overwrites
		--_rawset (_detalhes.spellcache, 1, {Loc ["STRING_MELEE"], 1, "Interface\\AddOns\\Details\\images\\melee.tga"})
		--_rawset (_detalhes.spellcache, 2, {Loc ["STRING_AUTOSHOT"], 1, "Interface\\AddOns\\Details\\images\\autoshot.tga"})
		
		--> built-in overwrites
		for spellId, spellTable in pairs (_detalhes.SpellOverwrite) do
			local name, _, icon = _GetSpellInfo (spellId)
			_rawset (_detalhes.spellcache, spellId, {spellTable.name or name, 1, spellTable.icon or icon})
		end
		
		--> user overwrites
		-- [1] spellid [2] spellname [3] spellicon
		for index, spellTable in ipairs (_detalhes.savedCustomSpells) do
			_rawset (_detalhes.spellcache, spellTable [1], {spellTable [2], 1, spellTable [3]})
		end
	end
	
	local lightOfTheMartyr_Name, _, lightOfTheMartyr_Icon = _GetSpellInfo (196917)
	lightOfTheMartyr_Name = lightOfTheMartyr_Name or "Deprecated Spell - Light of the Martyr"
	lightOfTheMartyr_Icon = lightOfTheMartyr_Icon or ""
	
	local default_user_spells
	
	if (DetailsFramework.IsClassicWow()) then
		default_user_spells = {
			[1] = {name = Loc ["STRING_MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
		}
	else
		default_user_spells = {
			[1] = {name = Loc ["STRING_MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
			
			[196917] = {name = lightOfTheMartyr_Name .. " (" .. Loc ["STRING_DAMAGE"] .. ")", icon = lightOfTheMartyr_Icon},
			
			[98021] = {name = Loc ["STRING_SPIRIT_LINK_TOTEM"]},
			
			[44461] = {name = GetSpellInfo (44461) .. " (" .. Loc ["STRING_EXPLOSION"] .. ")"}, --> Living Bomb (explosion)
		
			[59638] = {name = GetSpellInfo (59638) .. " (" .. Loc ["STRING_MIRROR_IMAGE"] .. ")"}, --> Mirror Image's Frost Bolt (mage)
			[88082] = {name = GetSpellInfo (88082) .. " (" .. Loc ["STRING_MIRROR_IMAGE"] .. ")"}, --> Mirror Image's Fireball (mage)
			
			[94472] = {name = GetSpellInfo (94472) .. " (" .. Loc ["STRING_CRITICAL_ONLY"] .. ")"}, --> Atonement critical hit (priest)
			
			[33778] = {name = GetSpellInfo (33778) .. " (Bloom)"}, --lifebloom (bloom)
			
			[121414] = {name = GetSpellInfo (121414) .. " (Glaive #1)"}, --> glaive toss (hunter)
			[120761] = {name = GetSpellInfo (120761) .. " (Glaive #2)"}, --> glaive toss (hunter)
			
			[212739] = {name = GetSpellInfo (212739) .. " (Main Target)"}, --DK Epidemic
			[215969] = {name = GetSpellInfo (215969) .. " (AoE)"}, --DK Epidemic
			
			[70890] = {name = GetSpellInfo (70890) .. " (Shadow)"}, --DK Scourge Strike
			[55090] = {name = GetSpellInfo (55090) .. " (Physical)"}, --DK Scourge Strike
			
			[49184] = {name = GetSpellInfo (49184) .. " (Main Target)"}, --DK Howling Blast
			[237680] = {name = GetSpellInfo (237680) .. " (AoE)"}, --DK Howling Blast
			
			[228649] = {name = GetSpellInfo (228649) .. " (Passive)"}, --Monk Mistweaver Blackout kick - Passive Teachings of the Monastery
			
			[339538] = {name = GetSpellInfo (224266) .. " (Templar's Vindication)"}, --

			[108271] = {name = GetSpellInfo (108271), icon = "Interface\\Addons\\Details\\images\\icon_astral_shift"}, --

			--> shadowlands trinkets
			[345020] = {name = GetSpellInfo (345020) .. " (Trinket)"},

			--> bfa trinkets
			[278155] = {name = GetSpellInfo (278155) .. " (Trinket)"}, --[Twitching Tentacle of Xalzaix]
			[279664] = {name = GetSpellInfo (279664) .. " (Trinket)"}, --[Vanquished Tendril of G'huun]
			[278227] = {name = GetSpellInfo (278227) .. " (Trinket)"}, --[T'zane's Barkspines]
			[278383] = {name = GetSpellInfo (278383) .. " (Trinket)"}, --[Azurethos' Singed Plumage]
			[278862] = {name = GetSpellInfo (278862) .. " (Trinket)"}, --[Drust-Runed Icicle]
			[278359] = {name = GetSpellInfo (278359) .. " (Trinket)"}, --[Doom's Hatred]
			[278812] = {name = GetSpellInfo (278812) .. " (Trinket)"}, --[Lion's Grace]
			[270827] = {name = GetSpellInfo (270827) .. " (Trinket)"}, --[Vessel of Skittering Shadows]
			[271071] = {name = GetSpellInfo (271071) .. " (Trinket)"}, --[Conch of Dark Whispers]
			[270925] = {name = GetSpellInfo (270925) .. " (Trinket)"}, --[Hadal's Nautilus]
			[271115] = {name = GetSpellInfo (271115) .. " (Trinket)"}, --[Ignition Mage's Fuse]
			[271462] = {name = GetSpellInfo (271462) .. " (Trinket)"}, --[Rotcrusted Voodoo Doll]
			[271465] = {name = GetSpellInfo (271465) .. " (Trinket)"}, --[Rotcrusted Voodoo Doll]
			[268998] = {name = GetSpellInfo (268998) .. " (Trinket)"}, --[Balefire Branch]
			[271671] = {name = GetSpellInfo (271671) .. " (Trinket)"}, --[Lady Waycrest's Music Box]
			[277179] = {name = GetSpellInfo (277179) .. " (Trinket)"}, --[Dread Gladiator's Medallion]
			[277187] = {name = GetSpellInfo (277187) .. " (Trinket)"}, --[Dread Gladiator's Emblem]
			[277181] = {name = GetSpellInfo (277181) .. " (Trinket)"}, --[Dread Gladiator's Insignia]
			[277185] = {name = GetSpellInfo (277185) .. " (Trinket)"}, --[Dread Gladiator's Badge]
			[278057] = {name = GetSpellInfo (278057) .. " (Trinket)"}, --[Vigilant's Bloodshaper]
			
		}
	end
	
	function _detalhes:UserCustomSpellUpdate (index, name, icon)
		local t = _detalhes.savedCustomSpells [index]
		if (t) then
			t [2], t [3] = name or t [2], icon or t [3]
			return _rawset (_detalhes.spellcache, t [1], {t [2], 1, t [3]})
		else
			return false
		end
	end
	
	function _detalhes:UserCustomSpellReset (index)
		local t = _detalhes.savedCustomSpells [index]
		if (t) then
			local spellid = t [1]
			local name, _, icon = _GetSpellInfo (spellid)
			
			if (default_user_spells [spellid]) then
				name = default_user_spells [spellid].name
				icon = default_user_spells [spellid].icon or icon or [[Interface\InventoryItems\WoWUnknownItem01]]
			end
			
			if (not name) then
				name = "Unknown"
			end
			if (not icon) then
				icon = [[Interface\InventoryItems\WoWUnknownItem01]]
			end
			
			_rawset (_detalhes.spellcache, spellid, {name, 1, icon})
			
			t[2] = name
			t[3] = icon
		end
	end
	
	function _detalhes:FillUserCustomSpells()
		for spellid, t in pairs (default_user_spells) do 
		
			local already_have
			for index, spelltable in ipairs (_detalhes.savedCustomSpells) do 
				if (spelltable [1] == spellid) then
					already_have = spelltable
				end
			end
		
			if (not already_have) then
				local name, _, icon = GetSpellInfo (spellid)
				_detalhes:UserCustomSpellAdd (spellid, t.name or name or "Unknown", t.icon or icon or [[Interface\InventoryItems\WoWUnknownItem01]])	
			end
			
		end
		
		for i = #_detalhes.savedCustomSpells, 1, -1 do
			local spelltable = _detalhes.savedCustomSpells [i]
			local spellid = spelltable [1]
			if (spellid > 10) then
				local exists = _GetSpellInfo (spellid)
				if (not exists) then
					tremove (_detalhes.savedCustomSpells, i)
				end
			end
		end
	end
	
	function _detalhes:UserCustomSpellAdd (spellid, name, icon)
		local is_overwrite = false
		for index, t in ipairs (_detalhes.savedCustomSpells) do 
			if (t [1] == spellid) then
				t[2] = name
				t[3] = icon
				is_overwrite = true
				break
			end
		end
		if (not is_overwrite) then
			tinsert (_detalhes.savedCustomSpells, {spellid, name, icon})
		end
		return _rawset (_detalhes.spellcache, spellid, {name, 1, icon})
	end
	
	function _detalhes:UserCustomSpellRemove (index)
		local t = _detalhes.savedCustomSpells [index]
		if (t) then
			local spellid = t [1]
			local name, _, icon = _GetSpellInfo (spellid)
			if (name) then
				_rawset (_detalhes.spellcache, spellid, {name, 1, icon})
			end
			return tremove (_detalhes.savedCustomSpells, index)
		end
		
		return false
	end
	
	--> overwrite for API GetSpellInfo function 
	_detalhes.getspellinfo = function (spellid) return _unpack (_detalhes.spellcache[spellid]) end 
	_detalhes.GetSpellInfo = _detalhes.getspellinfo

	--> overwrite SpellInfo if the spell is a DoT, so Details.GetSpellInfo will return the name modified
	function _detalhes:SpellIsDot (spellid)
		local spellName, rank, spellIcon = _GetSpellInfo (spellid)
		
		if (spellName) then
			_rawset (_detalhes.spellcache, spellid, {spellName .. Loc ["STRING_DOT"], rank, spellIcon})
		else
			_rawset (_detalhes.spellcache, spellid, {"Unknown DoT Spell? " .. Loc ["STRING_DOT"], rank, [[Interface\InventoryItems\WoWUnknownItem01]]})
		end
	end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Cache All Spells

	function _detalhes:BuildSpellListSlow()

		local load_frame = _G.DetailsLoadSpellCache
		if (load_frame and (load_frame.completed or load_frame.inprogress)) then
			return false
		end
	
		local step = 1
		local max = 160000
		
		if (not load_frame) then
			load_frame = CreateFrame ("frame", "DetailsLoadSpellCache", UIParent)
			load_frame:SetFrameStrata ("DIALOG")
			
			local progress_label = load_frame:CreateFontString ("DetailsLoadSpellCacheProgress", "overlay", "GameFontHighlightSmall")
			progress_label:SetText ("Loading Spells: 0%")
			function _detalhes:BuildSpellListSlowTick()
				progress_label:SetText ("Loading Spells: " .. load_frame:GetProgress() .. "%")
			end
			load_frame.tick = _detalhes:ScheduleRepeatingTimer ("BuildSpellListSlowTick", 1)
			
			function load_frame:GetProgress()
				return math.floor (step / max * 100)
			end
		end
		
		local SpellCache = {a={}, b={}, c={}, d={}, e={}, f={}, g={}, h={}, i={}, j={}, k={}, l={}, m={}, n={}, o={}, p={}, q={}, r={}, s={}, t={}, u={}, v={}, w={}, x={}, y={}, z={}}
		local _string_lower = string.lower
		local _string_sub = string.sub
		local blizzGetSpellInfo = GetSpellInfo
		
		load_frame.inprogress = true
		
		_detalhes.spellcachefull = SpellCache

		load_frame:SetScript ("OnUpdate", function()
			for spellid = step, step+500 do
				local name, _, icon = blizzGetSpellInfo (spellid)
				if (name) then
					local LetterIndex = _string_lower (_string_sub (name, 1, 1)) --> get the first letter
					local CachedIndex = SpellCache [LetterIndex]
					if (CachedIndex) then
						CachedIndex [spellid] = {name, icon}
					end
				end
			end
			
			step = step + 500
			
			if (step > max) then
				step = max
				_G.DetailsLoadSpellCache.completed = true
				_G.DetailsLoadSpellCache.inprogress = false
				_detalhes:CancelTimer (_G.DetailsLoadSpellCache.tick)
				DetailsLoadSpellCacheProgress:Hide()
				load_frame:SetScript ("OnUpdate", nil)
			end
			
		end)
		

		
		return true
	end

	function _detalhes:BuildSpellList()
	
		local SpellCache = {a={}, b={}, c={}, d={}, e={}, f={}, g={}, h={}, i={}, j={}, k={}, l={}, m={}, n={}, o={}, p={}, q={}, r={}, s={}, t={}, u={}, v={}, w={}, x={}, y={}, z={}}
		local _string_lower = string.lower
		local _string_sub = string.sub
		local blizzGetSpellInfo = GetSpellInfo

		for spellid = 1, 160000 do
			local name, rank, icon = blizzGetSpellInfo (spellid)
			if (name) then
				local index = _string_lower (_string_sub (name, 1, 1))
				local CachedIndex = SpellCache [index]
				if (CachedIndex) then
					CachedIndex [spellid] = {name, icon, rank}
				end
			end
		end

		_detalhes.spellcachefull = SpellCache
		return true
	end
	
	function _detalhes:ClearSpellList()
		_detalhes.spellcachefull = nil
		collectgarbage()
	end
	

	
end
