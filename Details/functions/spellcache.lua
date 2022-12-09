--[[ Spell Cache store all spells shown on frames and make able to change spells name, icons, etc... ]]

do

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--On The Fly SpellCache

	local Details = 	_G._detalhes
	local Loc = LibStub("AceLocale-3.0"):GetLocale ( "Details" )
	local addonName, Details222 = ...
	local _
	local rawget	=	rawget
	local rawset	=	rawset
	local setmetatable =	setmetatable
	local _GetSpellInfo =	GetSpellInfo
	local _unpack	=	unpack

	--is this a timewalking exp?
	local is_classic_exp = DetailsFramework.IsClassicWow()

	--default container
	Details.spellcache =	{}
	local unknowSpell = {Loc ["STRING_UNKNOWSPELL"], _, "Interface\\Icons\\Ability_Druid_Eclipse"} --localize-me

	local AllSpellNames
	if (is_classic_exp) then
		AllSpellNames = {}
		local GetSpellInfo = GetSpellInfo
		for i = 1, 60000 do
			local name, _, icon = GetSpellInfo(i)
			if name and icon and icon ~= 136235 and not AllSpellNames[name] then
				AllSpellNames[name] = icon
			end
		end
	end

	local GetSpellInfoClassic = function(spell)
		local spellName, _, spellIcon

		if (spell == 0) then
			spellName = ATTACK or "It's Blizzard Fault!"
			spellIcon = [[Interface\ICONS\INV_Sword_04]]

		elseif (spell == "!Melee" or spell == 1) then
			spellName = ATTACK or "It's Blizzard Fault!"
			spellIcon = [[Interface\ICONS\INV_Sword_04]]

		elseif (spell == "!Autoshot" or spell == 2) then
			spellName = Loc ["STRING_AUTOSHOT"]
			spellIcon = [[Interface\ICONS\INV_Weapon_Bow_07]]

		else
			spellName, _, spellIcon = GetSpellInfo(spell)
		end

		if (not spellName) then
			return spell, _, AllSpellNames [spell] or defaultSpellIcon
		end

		return spellName, _, AllSpellNames [spell] or spellIcon
	end

	--reset spell cache
	function Details:ClearSpellCache()
		Details.spellcache = setmetatable({},
				{__index = function(tabela, valor)
					local esta_magia = rawget (tabela, valor)
					if (esta_magia) then
						return esta_magia
					end

					--should save only icon and name, other values are not used
					if (valor) then --check if spell is valid before
						local cache
						if (is_classic_exp) then
							cache = {GetSpellInfoClassic(valor)}
						else
							cache = {_GetSpellInfo(valor)}
						end
						tabela [valor] = cache
						return cache
					else
						return unknowSpell
					end

				end})

		--default overwrites
		--rawset (_detalhes.spellcache, 1, {Loc ["STRING_MELEE"], 1, "Interface\\AddOns\\Details\\images\\melee.tga"})
		--rawset (_detalhes.spellcache, 2, {Loc ["STRING_AUTOSHOT"], 1, "Interface\\AddOns\\Details\\images\\autoshot.tga"})

		--built-in overwrites
		for spellId, spellTable in pairs(Details.SpellOverwrite) do
			local name, _, icon = _GetSpellInfo(spellId)
			rawset (Details.spellcache, spellId, {spellTable.name or name, 1, spellTable.icon or icon})
		end

		--user overwrites
		-- [1] spellid [2] spellname [3] spellicon
		for index, spellTable in ipairs(Details.savedCustomSpells) do
			rawset (Details.spellcache, spellTable [1], {spellTable [2], 1, spellTable [3]})
		end
	end

	local lightOfTheMartyr_Name, _, lightOfTheMartyr_Icon = _GetSpellInfo(196917)
	lightOfTheMartyr_Name = lightOfTheMartyr_Name or "Deprecated Spell - Light of the Martyr"
	lightOfTheMartyr_Icon = lightOfTheMartyr_Icon or ""

	local defaultSpellCustomization = {}

	if (DetailsFramework.IsClassicWow()) then
		defaultSpellCustomization = {
			[1] = {name = Loc ["STRING_MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
		}

	elseif (DetailsFramework.IsTBCWow()) then
		defaultSpellCustomization = {
			[1] = {name = _G["MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
		}

	elseif (DetailsFramework.IsWotLKWow()) then
		defaultSpellCustomization = {
			[1] = {name = _G["MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
		}

	elseif (DetailsFramework.IsShadowlandsWow()) then
		defaultSpellCustomization = {
			[1] = {name = Loc ["STRING_MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
			[98021] = {name = Loc ["STRING_SPIRIT_LINK_TOTEM"]},
			[108271] = {name = GetSpellInfo(108271), icon = "Interface\\Addons\\Details\\images\\icon_astral_shift"},
			[196917] = {name = lightOfTheMartyr_Name .. " (" .. Loc ["STRING_DAMAGE"] .. ")", icon = lightOfTheMartyr_Icon},
			[77535] = {name = GetSpellInfo(77535), icon = "Interface\\Addons\\Details\\images\\icon_blood_shield"},

			--bfa trinkets (deprecated)
			[278155] = {name = GetSpellInfo(278155) .. " (Trinket)"}, --[Twitching Tentacle of Xalzaix]
			[279664] = {name = GetSpellInfo(279664) .. " (Trinket)"}, --[Vanquished Tendril of G'huun]
			[278227] = {name = GetSpellInfo(278227) .. " (Trinket)"}, --[T'zane's Barkspines]
			[278383] = {name = GetSpellInfo(278383) .. " (Trinket)"}, --[Azurethos' Singed Plumage]
			[278862] = {name = GetSpellInfo(278862) .. " (Trinket)"}, --[Drust-Runed Icicle]
			[278359] = {name = GetSpellInfo(278359) .. " (Trinket)"}, --[Doom's Hatred]
			[278812] = {name = GetSpellInfo(278812) .. " (Trinket)"}, --[Lion's Grace]
			[270827] = {name = GetSpellInfo(270827) .. " (Trinket)"}, --[Vessel of Skittering Shadows]
			[271071] = {name = GetSpellInfo(271071) .. " (Trinket)"}, --[Conch of Dark Whispers]
			[270925] = {name = GetSpellInfo(270925) .. " (Trinket)"}, --[Hadal's Nautilus]
			[271115] = {name = GetSpellInfo(271115) .. " (Trinket)"}, --[Ignition Mage's Fuse]
			[271462] = {name = GetSpellInfo(271462) .. " (Trinket)"}, --[Rotcrusted Voodoo Doll]
			[271465] = {name = GetSpellInfo(271465) .. " (Trinket)"}, --[Rotcrusted Voodoo Doll]
			[268998] = {name = GetSpellInfo(268998) .. " (Trinket)"}, --[Balefire Branch]
			[271671] = {name = GetSpellInfo(271671) .. " (Trinket)"}, --[Lady Waycrest's Music Box]
			[277179] = {name = GetSpellInfo(277179) .. " (Trinket)"}, --[Dread Gladiator's Medallion]
			[277187] = {name = GetSpellInfo(277187) .. " (Trinket)"}, --[Dread Gladiator's Emblem]
			[277181] = {name = GetSpellInfo(277181) .. " (Trinket)"}, --[Dread Gladiator's Insignia]
			[277185] = {name = GetSpellInfo(277185) .. " (Trinket)"}, --[Dread Gladiator's Badge]
			[278057] = {name = GetSpellInfo(278057) .. " (Trinket)"}, --[Vigilant's Bloodshaper]
		}

	else
		--retail
		local iconSize = 14 --icon size
		local coords = {0.14, 0.86, 0.14, 0.86}

		local formatTextForItem = function(itemId)
			local result = ""

			local itemIcon = C_Item.GetItemIconByID(itemId)
			local itemName = C_Item.GetItemNameByID(itemId)

			if (itemIcon and itemName) then
				result = " (" .. CreateTextureMarkup(itemIcon, iconSize, iconSize, iconSize, iconSize, unpack(coords)) .. " " .. itemName .. ")"
			end

			return result
		end

		defaultSpellCustomization = {
			[1] = {name = Loc ["STRING_MELEE"], icon = [[Interface\ICONS\INV_Sword_04]]},
			[2] = {name = Loc ["STRING_AUTOSHOT"], icon = [[Interface\ICONS\INV_Weapon_Bow_07]]},
			[3] = {name = Loc ["STRING_ENVIRONMENTAL_FALLING"], icon = [[Interface\ICONS\Spell_Magic_FeatherFall]]},
			[4] = {name = Loc ["STRING_ENVIRONMENTAL_DROWNING"], icon = [[Interface\ICONS\Ability_Suffocate]]},
			[5] = {name = Loc ["STRING_ENVIRONMENTAL_FATIGUE"], icon = [[Interface\ICONS\Spell_Arcane_MindMastery]]},
			[6] = {name = Loc ["STRING_ENVIRONMENTAL_FIRE"], icon = [[Interface\ICONS\INV_SummerFest_FireSpirit]]},
			[7] = {name = Loc ["STRING_ENVIRONMENTAL_LAVA"], icon = [[Interface\ICONS\Ability_Rhyolith_Volcano]]},
			[8] = {name = Loc ["STRING_ENVIRONMENTAL_SLIME"], icon = [[Interface\ICONS\Ability_Creature_Poison_02]]},
			[98021] = {name = Loc ["STRING_SPIRIT_LINK_TOTEM"]},
			[108271] = {name = GetSpellInfo(108271), icon = "Interface\\Addons\\Details\\images\\icon_astral_shift"},
			[196917] = {name = lightOfTheMartyr_Name .. " (" .. Loc ["STRING_DAMAGE"] .. ")", icon = lightOfTheMartyr_Icon},

			[77535] = {name = GetSpellInfo(77535), icon = "Interface\\Addons\\Details\\images\\icon_blood_shield"},
		}

		if (GetSpellInfo(394453)) then
			local dragonflightTrinkets = {
				[394453] = {name = GetSpellInfo(394453) .. formatTextForItem(195480), isPassive = true, itemId = 195480}, --ring: Seal of Diurna's Chosen

				[382135] = {name = GetSpellInfo(382135) .. formatTextForItem(194308)}, --trinket: Manic Grieftorch
				[382058] = {name = GetSpellInfo(382056) .. formatTextForItem(194299)}, --trinket: Decoration of Flame (shield)
				[382056] = {name = GetSpellInfo(382056) .. formatTextForItem(194299)}, --trinket: Decoration of Flame
				[382090] = {name = GetSpellInfo(382090) .. formatTextForItem(194302)}, --trinket: Storm-Eater's Boon
				[381967] = {name = GetSpellInfo(381967) .. formatTextForItem(194305)}, --trinket: Controlled Current Technique
				[382426] = {name = GetSpellInfo(382426) .. formatTextForItem(194309), isPassive = true, itemId = 194309}, --trinket: Spiteful Storm
				[377455] = {name = GetSpellInfo(377455) .. formatTextForItem(194304)}, --trinket: Iceblood Deathsnare
				[377451] = {name = GetSpellInfo(377451) .. formatTextForItem(194300)}, --trinket: Conjured Chillglobe
				[382097] = {name = GetSpellInfo(382097) .. formatTextForItem(194303)}, --trinket: Rumbling Ruby

				[385903] = {name = GetSpellInfo(385903) .. formatTextForItem(193639), isPassive = true, itemId = 193639}, --trinket: Umbrelskul's Fractured Heart
				[381475] = {name = GetSpellInfo(381475) .. formatTextForItem(193769)}, --trinket: Erupting Spear Fragment
				[388739] = {name = GetSpellInfo(388739) .. formatTextForItem(193660), isPassive = true, itemId = 193660}, --trinket: Idol of Pure Decay
				[388855] = {name = GetSpellInfo(388855) .. formatTextForItem(193678)}, --trinket: Miniature Singing Stone
				[388755] = {name = GetSpellInfo(388755) .. formatTextForItem(193677), isPassive = true, itemId = 193677}, --trinket: Furious Ragefeather
				[383934] = {name = GetSpellInfo(383934) .. formatTextForItem(193736)}, --trinket: Water's Beating Heart
				[214052] = {name = GetSpellInfo(214052) .. formatTextForItem(133641), isPassive = true, itemId = 133641}, --trinket: Eye of Skovald
				[214200] = {name = GetSpellInfo(214200) .. formatTextForItem(133646)}, --trinket: Mote of Sanctification
				[387036] = {name = GetSpellInfo(387036) .. formatTextForItem(193748)}, --trinket: Kyrakka's Searing Embers (heal)
				[397376] = {name = GetSpellInfo(397376) .. formatTextForItem(193748), isPassive = true, itemId = 193748}, --trinket: Kyrakka's Searing Embers (damage)
				--[] = {name = GetSpellInfo() .. formatTextForItem(193757), isPassive = true}, --trinket: Ruby Whelp Shell

				[214985] = {name = GetSpellInfo(214985) .. formatTextForItem(137486)}, --trinket: Windscar Whetstone
				[384004] = {name = GetSpellInfo(384004) .. formatTextForItem(193815)}, --trinket: Homeland Raid Horn
				--[] = {name = GetSpellInfo() .. formatTextForItem()}, --trinket: Mutated Magmammoth Scale - did no proc

				--/dump C_Item.GetItemNameByID(137486) --to check an item
				--default tooltip script gets the item id
			}

			for spellId, spellCustomization in pairs(dragonflightTrinkets) do
				defaultSpellCustomization[spellId] = spellCustomization
			end
		end
	end

	if (LIB_OPEN_RAID_SPELL_CUSTOM_NAMES) then
		for spellId, customTable in pairs(LIB_OPEN_RAID_SPELL_CUSTOM_NAMES) do
			local name = customTable.name
			if (name) then
				defaultSpellCustomization[spellId] = name
			end
		end
	end

	function Details:GetDefaultCustomSpellsList()
		return defaultSpellCustomization
	end

	function Details:UserCustomSpellUpdate (index, name, icon)
		local t = Details.savedCustomSpells[index]
		if (t) then
			t [2], t [3] = name or t [2], icon or t [3]
			return rawset (Details.spellcache, t [1], {t [2], 1, t [3]})
		else
			return false
		end
	end

	function Details:UserCustomSpellReset (index)
		local t = Details.savedCustomSpells[index]
		if (t) then
			local spellid = t [1]
			local name, _, icon = _GetSpellInfo(spellid)

			if (defaultSpellCustomization [spellid]) then
				name = defaultSpellCustomization [spellid].name
				icon = defaultSpellCustomization [spellid].icon or icon or [[Interface\InventoryItems\WoWUnknownItem01]]
			end

			if (not name) then
				name = "Unknown"
			end
			if (not icon) then
				icon = [[Interface\InventoryItems\WoWUnknownItem01]]
			end

			rawset (Details.spellcache, spellid, {name, 1, icon})

			t[2] = name
			t[3] = icon
		end
	end

	function Details:FillUserCustomSpells()
		for spellid, spellTable in pairs(defaultSpellCustomization) do
			local spellName, _, spellIcon = Details.GetSpellInfo(spellid)
			Details:UserCustomSpellAdd(spellid, spellTable.name or spellName or "Unknown", spellTable.icon or spellIcon or [[Interface\InventoryItems\WoWUnknownItem01]])
		end

		for i = #Details.savedCustomSpells, 1, -1 do
			local spelltable = Details.savedCustomSpells [i]
			local spellid = spelltable [1]
			if (spellid > 10) then
				local exists = _GetSpellInfo(spellid)
				if (not exists) then
					tremove(Details.savedCustomSpells, i)
				end
			end
		end
	end

	C_Timer.After(0, function()
		Details:FillUserCustomSpells()
	end)

	function Details:UserCustomSpellAdd(spellid, name, icon)
		local isOverwrite = false
		for index, spellTable in ipairs(Details.savedCustomSpells) do
			if (spellTable[1] == spellid) then
				spellTable[2] = name
				spellTable[3] = icon
				isOverwrite = true
				break
			end
		end

		if (not isOverwrite) then
			tinsert(Details.savedCustomSpells, {spellid, name, icon})
		end

		return rawset(Details.spellcache, spellid, {name, 1, icon})
	end

	function Details:UserCustomSpellRemove (index)
		local t = Details.savedCustomSpells [index]
		if (t) then
			local spellid = t [1]
			local name, _, icon = _GetSpellInfo(spellid)
			if (name) then
				rawset (Details.spellcache, spellid, {name, 1, icon})
			end
			return tremove(Details.savedCustomSpells, index)
		end

		return false
	end

	--overwrite for API GetSpellInfo function

	Details.getspellinfo = function(spellid) return _unpack(Details.spellcache[spellid]) end
	Details.GetSpellInfo = Details.getspellinfo

	--overwrite SpellInfo if the spell is a DoT, so Details.GetSpellInfo will return the name modified
	function Details:SpellIsDot(spellid)
		--do nothing if this spell already has a customization
		if (defaultSpellCustomization[spellid]) then
			return
		end
		local spellName, rank, spellIcon = _GetSpellInfo(spellid)

		if (spellName) then
			rawset (Details.spellcache, spellid, {spellName .. Loc ["STRING_DOT"], rank, spellIcon})
		else
			rawset (Details.spellcache, spellid, {"Unknown DoT Spell? " .. Loc ["STRING_DOT"], rank, [[Interface\InventoryItems\WoWUnknownItem01]]})
		end
	end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Cache All Spells

	function Details:BuildSpellListSlow()

		local load_frame = _G.DetailsLoadSpellCache
		if (load_frame and (load_frame.completed or load_frame.inprogress)) then
			return false
		end

		local step = 1
		local max = 160000

		if (not load_frame) then
			load_frame = CreateFrame("frame", "DetailsLoadSpellCache", UIParent)
			load_frame:SetFrameStrata("DIALOG")

			local progress_label = load_frame:CreateFontString("DetailsLoadSpellCacheProgress", "overlay", "GameFontHighlightSmall")
			progress_label:SetText("Loading Spells: 0%")
			function Details:BuildSpellListSlowTick()
				progress_label:SetText("Loading Spells: " .. load_frame:GetProgress() .. "%")
			end
			load_frame.tick = Details:ScheduleRepeatingTimer ("BuildSpellListSlowTick", 1)

			function load_frame:GetProgress()
				return math.floor(step / max * 100)
			end
		end

		local SpellCache = {a={}, b={}, c={}, d={}, e={}, f={}, g={}, h={}, i={}, j={}, k={}, l={}, m={}, n={}, o={}, p={}, q={}, r={}, s={}, t={}, u={}, v={}, w={}, x={}, y={}, z={}}
		local _string_lower = string.lower
		local _string_sub = string.sub
		local blizzGetSpellInfo = GetSpellInfo

		load_frame.inprogress = true

		Details.spellcachefull = SpellCache

		load_frame:SetScript("OnUpdate", function()
			for spellid = step, step+500 do
				local name, _, icon = blizzGetSpellInfo (spellid)
				if (name) then
					local LetterIndex = _string_lower (_string_sub (name, 1, 1)) --get the first letter
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
				Details:CancelTimer(_G.DetailsLoadSpellCache.tick)
				DetailsLoadSpellCacheProgress:Hide()
				load_frame:SetScript("OnUpdate", nil)
			end

		end)



		return true
	end

	function Details:BuildSpellList()

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

		Details.spellcachefull = SpellCache
		return true
	end

	function Details:ClearSpellList()
		Details.spellcachefull = nil
		collectgarbage()
	end



end
