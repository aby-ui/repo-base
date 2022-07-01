-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

local LibStub = _G.LibStub

local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner", false)

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSMapDB = private.ImportLib("RareScannerMapDB")

-- RareScanner internal libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSConstants = private.ImportLib("RareScannerConstants")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSMap = private.ImportLib("RareScannerMap")

-----------------------------------------------------------------------
-- Config option functions.
-----------------------------------------------------------------------

private.CHANNELS = {
	["Master"] = AL["CHANNEL_MASTER"],
	["SFX"] = AL["CHANNEL_SFX"],
	["Music"] = AL["CHANNEL_MUSIC"],
	["Ambience"] = AL["CHANNEL_AMBIENCE"],
	["Dialog"] = AL["CHANNEL_DIALOG"],
}

private.MARKERS = {
	["Star"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_1",
	["Circle"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_2",
	["Diamond"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_3",
	["Triangle"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_4",
	["Moon"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_5",
	["Square"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_6",
	["Cross"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_7",
	["Skull"] = "Interface\\TARGETINGFRAME\\UI-RaidTargetingIcon_8",
}

private.TOOLTIP_POSITIONS = {
	["ANCHOR_LEFT"] = AL["TOOLTIP_LEFT"],
	["ANCHOR_RIGHT"] = AL["TOOLTIP_RIGHT"],
	["ANCHOR_CURSOR"] = AL["TOOLTIP_CURSOR"],
	["ANCHOR_TOPLEFT"] = AL["TOOLTIP_TOP"],
	["ANCHOR_BOTTOMLEFT"] = AL["TOOLTIP_BOTTOM"],
}

private.ITEM_QUALITY = {
	[Enum.ItemQuality.Poor] = ITEM_QUALITY0_DESC,
	[Enum.ItemQuality.Common] = ITEM_QUALITY1_DESC,
	[Enum.ItemQuality.Uncommon] = ITEM_QUALITY2_DESC,
	[Enum.ItemQuality.Rare] = ITEM_QUALITY3_DESC,
	[Enum.ItemQuality.Epic] = ITEM_QUALITY4_DESC,
	[Enum.ItemQuality.Legendary] = ITEM_QUALITY5_DESC,
	[Enum.ItemQuality.Artifact] = ITEM_QUALITY6_DESC,
	[Enum.ItemQuality.Heirloom] = ITEM_QUALITY7_DESC,
}

local SPEAR_ID = 17 --CHECK (none uses it)

private.ITEM_CLASSES = {
	[Enum.ItemClass.Consumable] = { 0, 1, 2, 3, 5, 7, 8, 9 }, --consumables
	[Enum.ItemClass.Container] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, --bags
	[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Bearclaw, Enum.ItemWeaponSubclass.Catclaw, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Generic, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Thrown, SPEAR_ID, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Wand, Enum.ItemWeaponSubclass.Fishingpole }, --weapons
	[Enum.ItemClass.Gem] = { Enum.ItemGemSubclass.Intellect, Enum.ItemGemSubclass.Agility, Enum.ItemGemSubclass.Strength, Enum.ItemGemSubclass.Stamina, Enum.ItemGemSubclass.Spirit, Enum.ItemGemSubclass.Criticalstrike, Enum.ItemGemSubclass.Mastery, Enum.ItemGemSubclass.Haste, Enum.ItemGemSubclass.Versatility, 9, Enum.ItemGemSubclass.Multiplestats, Enum.ItemGemSubclass.Artifactrelic }, --gemes
	[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Cloth, Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Shield, Enum.ItemArmorSubclass.Libram, Enum.ItemArmorSubclass.Idol, Enum.ItemArmorSubclass.Totem, Enum.ItemArmorSubclass.Sigil, Enum.ItemArmorSubclass.Relic }, --armor
	[Enum.ItemClass.Reagent] = { 0, 1 }, --consumable
	[Enum.ItemClass.Projectile] = { 2, 3 }, --projectile
	[Enum.ItemClass.Tradegoods] = { 1, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 16 }, --tradeables
	[Enum.ItemClass.ItemEnhancement] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 }, --object improvements
	[Enum.ItemClass.Recipe] = { Enum.ItemRecipeSubclass.Book, Enum.ItemRecipeSubclass.Leatherworking, Enum.ItemRecipeSubclass.Tailoring, Enum.ItemRecipeSubclass.Engineering, Enum.ItemRecipeSubclass.Blacksmithing, Enum.ItemRecipeSubclass.Cooking, Enum.ItemRecipeSubclass.Alchemy, Enum.ItemRecipeSubclass.FirstAid, Enum.ItemRecipeSubclass.Enchanting, Enum.ItemRecipeSubclass.Fishing, Enum.ItemRecipeSubclass.Jewelcrafting, Enum.ItemRecipeSubclass.Inscription }, --recipes
	-- [10] = { }, --money (obsolete)
	-- [Enum.ItemClass.Quiver] = { 0 }, --quiver  (obsolete)
	[Enum.ItemClass.Questitem] = { 0 }, --quests
	[Enum.ItemClass.Key] = { 0, 1 }, --keys
	-- [14] = { }, --permanent (obsolete)
	[Enum.ItemClass.Miscellaneous] = { Enum.ItemMiscellaneousSubclass.Junk, Enum.ItemMiscellaneousSubclass.Reagent, Enum.ItemMiscellaneousSubclass.CompanionPet, Enum.ItemMiscellaneousSubclass.Holiday, Enum.ItemMiscellaneousSubclass.Other, Enum.ItemMiscellaneousSubclass.Mount }, --miscellaneous
	--[Enum.ItemClass.Glyph] = { 0 }, --glyphs
	[Enum.ItemClass.Battlepet] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }, --battle pets
	--[Enum.ItemClass.WowToken] = { 0 }, --wow token
}

private.CLASS_PROFICIENCIES = {
	[1] = { --Warrior
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[2] = { --Paladin
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Shield, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[3] = { --Hunter
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[4] = { --Rogue
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Bows, Enum.ItemWeaponSubclass.Guns, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Crossbow, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[5] = { --Priest
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic, Enum.ItemWeaponSubclass.Wand },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Cloth, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[6] = { --DeathKnight
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Sword2H, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Plate, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[7] = { --Shaman
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Axe2H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Mail, Enum.ItemArmorSubclass.Shield, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[8] = { --Mage
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Generic, Enum.ItemWeaponSubclass.Wand },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Cloth, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[9] = { --Warlock
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Generic, Enum.ItemWeaponSubclass.Wand },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Cloth, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[10] = { --Monk
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[11] = { --Druid
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Polearm, Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Staff, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Bearclaw, Enum.ItemWeaponSubclass.Mace2H, Enum.ItemWeaponSubclass.Mace1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
	[12] = { --Demon Hunter
		[Enum.ItemClass.Weapon] = { Enum.ItemWeaponSubclass.Unarmed, Enum.ItemWeaponSubclass.Fishingpole, Enum.ItemWeaponSubclass.Dagger, Enum.ItemWeaponSubclass.Sword1H, Enum.ItemWeaponSubclass.Warglaive, Enum.ItemWeaponSubclass.Axe1H, Enum.ItemWeaponSubclass.Generic },
		[Enum.ItemClass.Armor] = { Enum.ItemArmorSubclass.Leather, Enum.ItemArmorSubclass.Cosmetic, Enum.ItemArmorSubclass.Generic, Enum.ItemArmorSubclass.Relic }
	};
}

local DEFAULT_MAIN_CATEGORY = 0

local general_options

local function RS_Set(list)
	local set = {}
	for k, _ in pairs(list) do
		set[k] = true
	end
	return set
end

local function GetGeneralOptions()
	local orderedMarkers = {}
	for k, v in pairs(private.MARKERS) do
		orderedMarkers[#orderedMarkers+1] = v
	end

	table.sort(orderedMarkers, function(a,b) return string.upper(a) < string.upper(b) end)
	local setMarker = function(value)
		if (value) then
			for k, m in pairs (private.MARKERS) do
				if (k == value) then
					for i, v in ipairs(orderedMarkers) do
						if (m == v) then
							private.db.general.marker = i
						end
					end
				end
			end
		end
	end

	local getMarker = function()
		for i, v in ipairs(orderedMarkers) do
			if (i == private.db.general.marker) then
				for k, m in pairs (private.MARKERS) do
					if (m == v) then
						return k
					end
				end
			end
		end
	end

	if not general_options then
		general_options = {
			type = "group",
			order = 1,
			name = _G.GENERAL_LABEL,
			handler = RareScanner,
			desc = AL["GENERAL_OPTIONS"],
			args = {
				rescanTimer = {
					order = 0,
					type = "range",
					name = AL["RESCAN_TIMER"],
					desc = AL["RESCAN_TIMER_DESC"],
					min	= 3,
					max	= 60,
					step = 1,
					bigStep = 1,
					get = function() return RSConfigDB.GetRescanTimer() end,
					set = function(_, value)
						RSConfigDB.SetRescanTimer(value)
					end,
					width = "full",
				},
				scanRares = {
					order = 1,
					name = AL["ENABLE_SCAN_RARES"],
					desc = AL["ENABLE_SCAN_RARES_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningForNpcs() end,
					set = function(_, value)
						RSConfigDB.SetScanningForNpcs(value)
					end,
					width = "full",
				},
				scanContainers = {
					order = 2,
					name = AL["ENABLE_SCAN_CONTAINERS"],
					desc = AL["ENABLE_SCAN_CONTAINERS_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningForContainers() end,
					set = function(_, value)
						RSConfigDB.SetScanningForContainers(value)
					end,
					width = "full",
				},
				scanEvents = {
					order = 3,
					name = AL["ENABLE_SCAN_EVENTS"],
					desc = AL["ENABLE_SCAN_EVENTS_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningForEvents() end,
					set = function(_, value)
						RSConfigDB.SetScanningForEvents(value)
					end,
					width = "full",
				},
				scanChatAlerts = {
					order = 4,
					name = AL["ENABLE_SCAN_CHAT"],
					desc = AL["ENABLE_SCAN_CHAT_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningChatAlerts() end,
					set = function(_, value)
						RSConfigDB.SetScanningChatAlerts(value)
					end,
					width = "full",
				},
				scanGarrison = {
					order = 5,
					name = AL["ENABLE_SCAN_GARRISON_CHEST"],
					desc = AL["ENABLE_SCAN_GARRISON_CHEST_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsShowingGarrisonCache() end,
					set = function(_, value)
						RSConfigDB.SetShowingGarrisonCache(value)
					end,
					width = "full",
				},
				scanInstances = {
					order = 6,
					name = AL["ENABLE_SCAN_IN_INSTANCE"],
					desc = AL["ENABLE_SCAN_IN_INSTANCE_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningInInstances() end,
					set = function(_, value)
						RSConfigDB.SetScanningInInstance(value)
					end,
					width = "full",
				},
				scanOnTaxi = {
					order = 7,
					name = AL["ENABLE_SCAN_ON_TAXI"],
					desc = AL["ENABLE_SCAN_ON_TAXI_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningWhileOnTaxi() end,
					set = function(_, value)
						RSConfigDB.SetScanningWhileOnTaxi(value)
					end,
					width = "full",
				},
				scanOnPetBattle = {
					order = 8,
					name = AL["ENABLE_SCAN_ON_PET_BATTLE"],
					desc = AL["ENABLE_SCAN_ON_PET_BATTLE_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningWhileOnPetBattle() end,
					set = function(_, value)
						RSConfigDB.SetScanningWhileOnPetBattle(value)
					end,
					width = "full",
				},
				scanWorldMapVignettes = {
					order = 9,
					name = AL["ENABLE_SCAN_WORLDMAP_VIGNETTES"],
					desc = AL["ENABLE_SCAN_WORLDMAP_VIGNETTES_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsScanningWorldMapVignettes() end,
					set = function(_, value)
						RSConfigDB.SetScanningWorldMapVignettes(value)
					end,
					width = "full",
				},
				showMaker = {
					order = 10,
					name = AL["ENABLE_MARKER"],
					desc = AL["ENABLE_MARKER_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsDisplayingMarkerOnTarget() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingMarkerOnTarget(value)
					end,
					width = "full",
				},
				marker = {
					order = 11,
					type = "select",
					dialogControl = 'RS_Markers',
					name = AL["MARKER"],
					desc = AL["MARKER_DESC"],
					values = private.MARKERS,
					get = function() return getMarker() end,
					set = function(_, value)
						setMarker(value)
					end,
					width = "normal",
					disabled = function() return not RSConfigDB.IsDisplayingMarkerOnTarget() end,
				},
				separatorIngameWaypoints = {
					order = 12,
					type = "header",
					name = AL["INGAME_WAYPOINTS"],
				},
				enableIngameWaypoints = {
					order = 13,
					name = AL["ENABLE_WAYPOINTS_SUPPORT"],
					desc = AL["ENABLE_WAYPOINTS_SUPPORT_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsWaypointsSupportEnabled() end,
					set = function(_, value)
						RSConfigDB.SetWaypointsSupportEnabled(value)
					end,
					width = "full",
				},
				autoIngameWaypoints = {
					order = 14,
					name = AL["ENABLE_AUTO_WAYPOINTS"],
					desc = AL["ENABLE_AUTO_WAYPOINTS_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsAddingWaypointsAutomatically() end,
					set = function(_, value)
						RSConfigDB.SetAddingWaypointsAutomatically(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsWaypointsSupportEnabled() end,
				},
				separatorTomtomWaypoints = {
					order = 15,
					type = "header",
					name = AL["TOMTOM_WAYPOINTS"],
				},
				enableTomtomSupport = {
					order = 16,
					name = AL["ENABLE_TOMTOM_SUPPORT"],
					desc = AL["ENABLE_TOMTOM_SUPPORT_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsTomtomSupportEnabled() end,
					set = function(_, value)
						RSConfigDB.SetTomtomSupportEnabled(value)
					end,
					width = "full",
					disabled = function() return not TomTom end,
				},
				autoTomtomWaypoints = {
					order = 17,
					name = AL["ENABLE_AUTO_TOMTOM_WAYPOINTS"],
					desc = AL["ENABLE_AUTO_TOMTOM_WAYPOINTS_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsAddingTomtomWaypointsAutomatically() end,
					set = function(_, value)
						RSConfigDB.SetAddingTomtomWaypointsAutomatically(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsTomtomSupportEnabled() end,
				}
			},
		}
	end

	return general_options
end

local sound_options

local function GetSoundOptions()	
	if not sound_options then
		local addNewSound = function(name)
			RSConfigDB.AddCustomSound(name)
			
			sound_options.args[name] = {
				type = "group",
				order = 1,
				name = name,
				handler = RareScanner,
				desc = name,
				args = {
					infoSound = {
						order = 1,
						type = "description",
						name = AL["SOUND_CUSTOM_FILE_INFO"],
					},
					infoSound1 = {
						order = 2,
						type = "description",
						name = function()
							return string.format(AL["SOUND_CUSTOM_FILE_INFO1"], RSConfigDB.GetCustomSoundsFolder())
						end,
					},
					infoSound2 = {
						order = 3,
						type = "description",
						name = AL["SOUND_CUSTOM_FILE_INFO2"],
					},
					infoSound3 = {
						order = 4,
						type = "description",
						name = string.format(AL["SOUND_CUSTOM_FILE_INFO3"], AL["SOUND_RELOAD"]),
					},
					infoSound4 = {
						order = 5,
						type = "description",
						name = AL["SOUND_CUSTOM_FILE_INFO4"],
					},
					infoSound5 = {
						order = 6,
						type = "description",
						name = AL["SOUND_CUSTOM_FILE_INFO5"],
					},
					file = {
						order = 7,
						type = "input",
						name = AL["SOUND_CUSTOM_FILE"],
						desc = function()
							return string.format(AL["SOUND_CUSTOM_FILE_DESC"], RSConfigDB.GetCustomSoundsFolder())
						end,
						get = function(_, value) 
							return RSConfigDB.GetCustomSound(name)
						end,
						set = function(_, value)
							RSConfigDB.AddCustomSound(name, value)
							
							-- Refresh lists
							sound_options.args.soundPlayed.values = RSConfigDB.GetSoundList()
							sound_options.args.soundObjectPlayed.values = RSConfigDB.GetSoundList()
						end,
						width = "full",
					},
					delete = {
						order = 8.1,
						name = AL["SOUND_DELETE"],
						desc = AL["SOUND_DELETE_DESC"],
						type = "execute",
						func = function()
							sound_options.args[name] = nil
							RSConfigDB.DeleteCustomSound(name)
							
							-- Refresh lists
							sound_options.args.soundPlayed.values = RSConfigDB.GetSoundList()
							sound_options.args.soundObjectPlayed.values = RSConfigDB.GetSoundList()
						end,
						width = 0.8,
					},
					play = {
						order = 8.2,
						name = AL["SOUND_PLAY"],
						desc = AL["SOUND_PLAY_DESC"],
						type = "execute",
						func = function()
							if (RSConfigDB.GetCustomSound(name)) then
								print(string.format(RSConstants.EXTERNAL_SOUND_FOLDER, RSConfigDB.GetCustomSoundsFolder(), RSConfigDB.GetCustomSound(name)))
								PlaySoundFile(string.format(RSConstants.EXTERNAL_SOUND_FOLDER, RSConfigDB.GetCustomSoundsFolder(), RSConfigDB.GetCustomSound(name)), "Master")
							end
						end,
						width = 0.8,
					},
					reload = {
						order = 8.3,
						name = AL["SOUND_RELOAD"],
						desc = AL["SOUND_RELOAD_DESC"],
						type = "execute",
						func = function()
							ReloadUI()
						end,
						width = 0.8,
					},
				}
			}
		end
		
		sound_options = {
			type = "group",
			order = 1,
			name = AL["SOUND"],
			handler = RareScanner,
			desc = AL["SOUND_OPTIONS"],
			args = {
				soundDisabled = {
					order = 1,
					name = AL["DISABLE_SOUND"],
					desc = AL["DISABLE_SOUND_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsPlayingSound() end,
					set = function(_, value)
						RSConfigDB.SetPlayingSound(value)
					end,
					width = "full",
				},
				soundObjectDisabled = {
					order = 2,
					name = AL["DISABLE_OBJECTS_SOUND"],
					desc = AL["DISABLE_OBJECTS_SOUND_DESC"],
					type = "toggle",
					get = function() return RSConfigDB.IsPlayingObjectsSound() end,
					set = function(_, value)
						RSConfigDB.SetPlayingObjectsSound(value)
					end,
					width = "full",
				},
				channel = {
					order = 3.1,
					type = "select",
					name = AL["SOUND_CHANNEL"],
					desc = AL["SOUND_CHANNEL_DESC"],
					values = private.CHANNELS,
					get = function() return RSConfigDB.GetSoundChannel() end,
					set = function(_, value)
						RSConfigDB.SetSoundChannel(value)
					end,
					width = 1.5,
					disabled = function() return RSConfigDB.IsPlayingSound() and RSConfigDB.IsPlayingObjectsSound() end,
				},
				soundVolume = {
					order = 3.2,
					type = "range",
					name = AL["SOUND_VOLUME"],
					desc = AL["SOUND_VOLUME_DESC"],
					min	= 1,
					max	= 4,
					step = 1,
					bigStep = 1,
					get = function() return RSConfigDB.GetSoundVolume() end,
					set = function(_, value)
						RSConfigDB.SetSoundVolume(value)
					end,
					width = 1.5,
					disabled = function() return true or RSConfigDB.IsPlayingSound() and RSConfigDB.IsPlayingObjectsSound() end,
				},
				soundsSeparator = {
					order = 4,
					type = "header",
					name = AL["SOUND_AUDIOS"],
				},
				soundPlayed = {
					order = 5.1,
					type = "select",
					dialogControl = 'LSM30_Sound',
					name = AL["ALARM_SOUND"],
					desc = AL["ALARM_SOUND_DESC"],
					values = RSConfigDB.GetSoundList(),
					get = function() return RSConfigDB.GetSoundPlayedWithNpcs() end,
					set = function(_, value)
						RSConfigDB.SetSoundPlayedWithNpcs(value)
					end,
					width = 1.5,
					disabled = function() return RSConfigDB.IsPlayingSound() end,
				},
				soundObjectPlayed = {
					order = 5.2,
					type = "select",
					dialogControl = 'LSM30_Sound',
					name = AL["ALARM_TREASURES_SOUND"],
					desc = AL["ALARM_TREASURES_SOUND_DESC"],
					values = RSConfigDB.GetSoundList(),
					get = function() return RSConfigDB.GetSoundPlayedWithObjects() end,
					set = function(_, value)
						RSConfigDB.SetSoundPlayedWithObjects(value)
					end,
					width = 1.5,
					disabled = function() return RSConfigDB.IsPlayingObjectsSound() end,
				},
				customSoundFolder = {
					order = 6,
					type = "input",
					name = AL["SOUND_CUSTOM_FOLDER"],
					desc = AL["SOUND_CUSTOM_FOLDER_DESC"],
					get = function(_, value) return RSConfigDB.GetCustomSoundsFolder() end,
					set = function(_, value)
						RSConfigDB.SetCustomSoundsFolder(value)
					end,
					width = "full",
					validate = function(_, value)
						if (not value or value == '') then
							return false
						end
						
						return true
					end,
					disabled = function() return true or RSConfigDB.IsPlayingSound() and RSConfigDB.IsPlayingObjectsSound() end,
				},
				newCustomSound = {
					order = 7,
					type = "input",
					name = AL["SOUND_ADD"],
					desc = AL["SOUND_ADD_DESC"],
					get = function(_, value) return private.sound_options_newCustomSound_input end,
					set = function(_, value)
						private.sound_options_newCustomSound_input = value
						addNewSound(private.sound_options_newCustomSound_input);
					end,
					width = 1.5,
					validate = function(_, value)
						if (not value or value == '') then
							return false
						end
						
						return true
					end,
					disabled = function() return true or RSConfigDB.IsPlayingSound() and RSConfigDB.IsPlayingObjectsSound() end,
				},
			},
		}
		
		-- Preload already added custom sounds
		if (RSConfigDB.GetCustomSounds()) then
			for name, _ in pairs (RSConfigDB.GetCustomSounds()) do
				addNewSound(name)
			end
		end
	end

	return sound_options
end

local display_options

local function GetDisplayOptions()
	if not display_options then
		display_options = {
			type = "group",
			order = 1,
			name = AL["DISPLAY"],
			handler = RareScanner,
			desc = AL["DISPLAY_OPTIONS"],
			args = {
				separatorMainButton = {
					order = 0,
					type = "header",
					name = AL["MAIN_BUTTON_OPTIONS"],
				},
				displayButton = {
					order = 1,
					type = "toggle",
					name = AL["DISPLAY_BUTTON"],
					desc = AL["DISPLAY_BUTTON_DESC"],
					get = function() return RSConfigDB.IsButtonDisplaying() end,
					set = function(_, value)
						RSConfigDB.SetButtonDisplaying(value)
					end,
					width = "full",
				},
				displayMiniature = {
					order = 2,
					type = "toggle",
					name = AL["DISPLAY_MINIATURE"],
					desc = AL["DISPLAY_MINIATURE_DESC"],
					get = function() return RSConfigDB.IsDisplayingModel() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingModel(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsButtonDisplaying() end,
				},
				displayButtonContainers = {
					order = 3,
					type = "toggle",
					name = AL["DISPLAY_BUTTON_CONTAINERS"],
					desc = AL["DISPLAY_BUTTON_CONTAINERS_DESC"],
					get = function() return RSConfigDB.IsButtonDisplayingForContainers() end,
					set = function(_, value)
						RSConfigDB.SetButtonDisplayingForContainers(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsButtonDisplaying() end,
				},
				autoHideButton = {
					order = 4,
					type = "range",
					name = AL["AUTO_HIDE_BUTTON"],
					desc = AL["AUTO_HIDE_BUTTON_DESC"],
					min	= 0,
					max	= 60,
					step	= 5,
					bigStep = 5,
					get = function() return RSConfigDB.GetAutoHideButtonTime() end,
					set = function(_, value)
						RSConfigDB.SetAutoHideButtonTime(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsButtonDisplaying() end,
				},
				separatorButtonPosition = {
					order = 5,
					type = "header",
					name = AL["DISPLAY_BUTTON_SCALE_POSITION"],
				},
				scale = {
					order = 6.1,
					type = "range",
					name = AL["DISPLAY_BUTTON_SCALE"],
					desc = AL["DISPLAY_BUTTON_SCALE_DESC"],
					min	= 0.4,
					max	= 1.1,
					step = 0.01,
					bigStep = 0.05,
					get = function() return RSConfigDB.GetButtonScale() end,
					set = function(_, value)
						RSConfigDB.SetButtonScale(value)
					end,
					width = "double",
					disabled = function() return not RSConfigDB.IsButtonDisplaying() end,
				},
				test = {
					order = 6.2,
					name = AL["TEST"],
					desc = AL["TEST_DESC"],
					type = "execute",
					func = function() RareScanner:Test() end,
					width = "normal",
				},
				lockPosition = {
					order = 7.1,
					type = "toggle",
					name = AL["LOCK_BUTTON_POSITION"],
					desc = AL["LOCK_BUTTON_POSITION_DESC"],
					get = function() return RSConfigDB.IsLockingPosition() end,
					set = function(_, value)
						RSConfigDB.SetLockingPosition(value)
					end,
					width = "double",
				},
				resetPosition = {
					order = 7.2,
					name = AL["RESET_POSITION"],
					desc = AL["RESET_POSITION_DESC"],
					type = "execute",
					func = function() RareScanner:ResetPosition() end,
					width = "normal",
				},
				separatorMessages = {
					order = 8,
					type = "header",
					name = AL["MESSAGE_OPTIONS"],
				},
				displayRaidWarning = {
					order = 9,
					type = "toggle",
					name = AL["SHOW_RAID_WARNING"],
					desc = AL["SHOW_RAID_WARNING_DESC"],
					get = function() return RSConfigDB.IsDisplayingRaidWarning() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingRaidWarning(value)
					end,
					width = "full",
				},
				displayChatMessage = {
					order = 10,
					type = "toggle",
					name = AL["SHOW_CHAT_ALERT"],
					desc = AL["SHOW_CHAT_ALERT_DESC"],
					get = function() return RSConfigDB.IsDisplayingChatMessages() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingChatMessages(value)
					end,
					width = "full",
				},
				separatorNavigation = {
					order = 11,
					type = "header",
					name = AL["NAVIGATION_OPTIONS"],
				},
				enableNavigation = {
					order = 12,
					type = "toggle",
					name = AL["NAVIGATION_ENABLE"],
					desc = AL["NAVIGATION_ENABLE_DESC"],
					get = function() return RSConfigDB.IsDisplayingNavigationArrows() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingNavigationArrows(value)
					end,
					width = "full",
				},
				navigationLockEntity = {
					order = 13,
					type = "toggle",
					name = AL["NAVIGATION_LOCK_ENTITY"],
					desc = AL["NAVIGATION_LOCK_ENTITY_DESC"],
					get = function() return RSConfigDB.IsNavigationLockEnabled() end,
					set = function(_, value)
						RSConfigDB.SetNavigationLockEnabled(value)
					end,
					width = "full",
					disabled = function() return not RSConfigDB.IsDisplayingNavigationArrows() end,
				},
				separatorMap = {
					order = 14,
					type = "header",
					name = AL["MAP_OPTIONS"],
				},
				minimapButton = {
					order = 15,
					type = "toggle",
					name = AL["DISPLAY_MINIMAP_BUTTON"],
					desc = AL["DISPLAY_MINIMAP_BUTTON_DESC"],
					get = function() return RSConfigDB.IsShowingMinimapButton() end,
					set = function(_, value)
						RSConfigDB.SetShowingMinimapButton(value)
						RSMinimap.ToggleMinimapButton() 
					end,
					width = "full",
				},
				worldmapButton = {
					order = 16,
					type = "toggle",
					name = AL["DISPLAY_WORLDMAP_BUTTON"],
					desc = AL["DISPLAY_WORLDMAP_BUTTON_DESC"],
					get = function() return RSConfigDB.IsShowingWorldmapButton() end,
					set = function(_, value)
						RSConfigDB.SetShowingWorldmapButton(value)
						RSMap.ToggleWorldmapButton() 
					end,
					width = "full",
				},
			},
		}
	end

	return display_options
end

local sortValues = function(list)
	local sortedValues = {}
	for key, value in pairs (list) do
		tinsert(sortedValues, value)
	end
	table.sort(sortedValues)

	local sortedKeys = {}
	for i, sortedValue in ipairs(sortedValues) do
		for key, value in pairs (list) do
			if (sortedValue == value) then
				tinsert(sortedKeys, key)
				break
			end
		end
	end

	return sortedKeys
end

local filter_options

local function GetFilterOptions()
	if not filter_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {}
		for continentID, continentInfo in pairs(RSMapDB.GetContinents()) do
			if (continentInfo.npcfilter) then
				if (continentInfo.id) then
					CONTINENT_MAP_IDS[continentID] = RSMap.GetMapName(continentID)
				else
					CONTINENT_MAP_IDS[continentID] = AL["ZONES_CONTINENT_LIST"][continentID]
				end
			end
		end

		local searchNpcByZoneID = function(zoneID, npcName)
			if (zoneID) then
				for npcID, name in pairs(RSNpcDB.GetAllNpcNames()) do
					local tempName = name
					if (RSNpcDB.IsInternalNpcInMap(npcID, zoneID, true) and ((npcName and RSUtils.Contains(name,npcName)) or not npcName)) then
						local i = 2
						local sameNPC = false
						while (filter_options.args.rareFilters.values[tempName]) do
							-- If same NPC skip
							if (filter_options.args.rareFilters.values[tempName] == npcID) then
								sameNPC = true
								break;
							end

							tempName = name..' ('..i..')'
							i = i+1
						end
						if (not sameNPC) then
							filter_options.args.rareFilters.values[tempName] = npcID
						end
					end
				end
			end
		end

		local searchNpcByContinentID = function(continentID, npcName)
			if (continentID) then
				table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, zoneID)
					-- filter checkboxes
					searchNpcByZoneID(zoneID, npcName)
				end)
			end
		end

		local loadSubmapsCombo = function(continentID)
			if (continentID) then
				filter_options.args.subzones.values = {}
				private.filter_options_subzones = nil
				table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, mapID)
					local mapName = RSMap.GetMapName(mapID)
					if (mapName) then
						filter_options.args.subzones.values[mapID] = mapName
					end
				end)
			end
		end

		filter_options = {
			type = "group",
			order = 1,
			name = AL["FILTER"],
			handler = RareScanner,
			desc = AL["FILTER"],
			args = {
				filterOnlyMap = {
					order = 1,
					type = "toggle",
					name = AL["FILTER_NPCS_ONLY_MAP"],
					desc = AL["FILTER_NPCS_ONLY_MAP_DESC"],
					get = function() return RSConfigDB.IsNpcFilteredOnlyOnWorldMap() end,
					set = function(_, value)
						RSConfigDB.SetNpcFilteredOnlyOnWorldMap(value)
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				rareFiltersSearch = {
					order = 2,
					type = "input",
					name = AL["FILTERS_SEARCH"],
					desc = AL["FILTERS_SEARCH_DESC"],
					get = function(_, value) return private.filter_options_input end,
					set = function(_, value)
						private.filter_options_input = value
						-- search
						filter_options.args.rareFilters.values = {}
						if (private.filter_options_subzones) then
							searchNpcByZoneID(private.filter_options_subzones, value)
						else
							searchNpcByContinentID(private.filter_options_continents, value)
						end
					end,
					width = "full",
				},
				continents = {
					order = 3.1,
					type = "select",
					name = AL["FILTER_CONTINENT"],
					desc = AL["FILTER_CONTINENT_DESC"],
					values = CONTINENT_MAP_IDS,
					sorting = sortValues(CONTINENT_MAP_IDS),
					get = function(_, key)
						-- initialize
						if (not private.filter_options_continents) then
							private.filter_options_continents = RSConstants.CURRENT_MAP_ID

							-- load submaps combo
							loadSubmapsCombo(private.filter_options_continents)

							-- launch first search zone filters
							searchNpcByContinentID(private.filter_options_continents)
						end

						return private.filter_options_continents
					end,
					set = function(_, key, value)
						private.filter_options_continents = key

						-- load subzones combo
						loadSubmapsCombo(key)

						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByContinentID(key, private.filter_options_input)
					end,
					width = 1.0,
				},
				subzones = {
					order = 3.2,
					type = "select",
					name = AL["FILTER_ZONE"],
					desc = AL["FILTER_ZONE_DESC"],
					values = {},
					sorting = function()
						if (next(filter_options.args.subzones.values)) then
							return sortValues(filter_options.args.subzones.values)
						end
						return nil;
					end,
					get = function(_, key) return private.filter_options_subzones end,
					set = function(_, key, value)
						private.filter_options_subzones = key

						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByZoneID(key, private.filter_options_input)
					end,
					width = 1.925,
					disabled = function() return (next(filter_options.args.subzones.values) == nil) end,
				},
				rareFiltersClear = {
					order = 3.3,
					name = AL["CLEAR_FILTERS_SEARCH"],
					desc = AL["CLEAR_FILTERS_SEARCH_DESC"],
					type = "execute",
					func = function()
						private.filter_options_input = nil
						filter_options.args.subzones.values = {}
						private.filter_options_subzones = nil
						private.filter_options_continents = RSConstants.CURRENT_MAP_ID
						-- load subzones combo
						loadSubmapsCombo(RSConstants.CURRENT_MAP_ID)
						-- search
						filter_options.args.rareFilters.values = {}
						searchNpcByContinentID(RSConstants.CURRENT_MAP_ID)
					end,
					width = 0.5,
				},
				separator = {
					order = 4,
					type = "header",
					name = AL["FILTERS"],
				},
				rareFiltersToogleAll = {
					order = 5,
					name = AL["TOGGLE_FILTERS"],
					desc = AL["TOGGLE_FILTERS_DESC"],
					type = "execute",
					func = function()
						if (next(filter_options.args.rareFilters.values) ~= nil) then
							if (private.db.rareFilters.filtersToggled) then
								private.db.rareFilters.filtersToggled = false
							else
								private.db.rareFilters.filtersToggled = true
							end

							for k, npcID in pairs(filter_options.args.rareFilters.values) do
								RSConfigDB.SetNpcFiltered(npcID, private.db.rareFilters.filtersToggled)
							end
						end
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				rareFilters = {
					order = 6,
					type = "multiselect",
					name = AL["FILTER_RARE_LIST"],
					desc = AL["FILTER_RARE_LIST_DESC"],
					values = {},
					get = function(_, npcID) return RSConfigDB.GetNpcFiltered(npcID) end,
					set = function(_, npcID, value)
						RSConfigDB.SetNpcFiltered(npcID, value)
						RSMinimap.RefreshAllData(true)
					end,
				}
			},
		}
	end

	return filter_options
end

local custom_npcs_options

local function GetCustomNpcOptions()
	if not custom_npcs_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {}
		for k, v in pairs(RSMapDB.GetContinents()) do
			if (v.zonefilter) then
				if (v.id) then
					CONTINENT_MAP_IDS[k] = RSMap.GetMapName(k)
				else
					CONTINENT_MAP_IDS[k] = AL["ZONES_CONTINENT_LIST"][k]
				end
			end
		end
		
		-- add wild zone
		CONTINENT_MAP_IDS[RSConstants.ALL_ZONES_CUSTOM_NPC] = AL["ALL_ZONES"]

		local loadSubmapsCombo = function(continentID, npcID)
			if (continentID) then
				custom_npcs_options.args[npcID].args.subzones.values = {}
				private.custom_npcs_options[npcID].subzone = nil
				
				if (continentID == RSConstants.ALL_ZONES_CUSTOM_NPC) then
					custom_npcs_options.args[npcID].args.subzones.values[RSConstants.ALL_ZONES_CUSTOM_NPC] = AL["ALL_ZONES"]
					private.custom_npcs_options[npcID].subzone = RSConstants.ALL_ZONES_CUSTOM_NPC
				else
					table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, zoneID)
						local zoneName = RSMap.GetMapName(zoneID)
						if (zoneName) then
							custom_npcs_options.args[npcID].args.subzones.values[zoneID] = zoneName
						end
					end)
				end
			end
		end
		
		local addNewCustomNpc = function(npcID)
			if (not private.custom_npcs_options) then
				private.custom_npcs_options = {}
			end
			
			private.custom_npcs_options[npcID] = {}
			
			if (not private.custom_npcs_options[npcID].zones) then
				private.custom_npcs_options[npcID].zones = {}
				private.custom_npcs_options[npcID].coordinates = {}
			end
			
			custom_npcs_options.args[npcID] = {
				type = "group",
				order = 2,
				name = RSNpcDB.GetNpcName(tonumber(npcID)),
				handler = RareScanner,
				desc = RSNpcDB.GetNpcName(tonumber(npcID)),
				args = {
					separatorFindZone = {
						order = 1,
						type = "header",
						name = AL["CUSTOM_NPC_FIND_ZONES"],
					},
					infoZone = {
						order = 2,
						type = "description",
						name = AL["CUSTOM_NPC_INFO"],
					},
					continents = {
						order = 3.1,
						type = "select",
						name = AL["FILTER_CONTINENT"],
						desc = AL["FILTER_CONTINENT_DESC"],
						values = CONTINENT_MAP_IDS,
						sorting = sortValues(CONTINENT_MAP_IDS),
						get = function(_, key)
							-- initialize
							if (not private.custom_npcs_options[npcID].continent) then
								private.custom_npcs_options[npcID].continent = RSConstants.CURRENT_MAP_ID
	
								-- load submaps combo
								loadSubmapsCombo(private.custom_npcs_options[npcID].continent, npcID)
							end
	
							return private.custom_npcs_options[npcID].continent
						end,
						set = function(_, key, value)
							private.custom_npcs_options[npcID].continent = key
	
							-- load subzones combo
							loadSubmapsCombo(key, npcID)
						end,
						width = 1.0,
					},
					subzones = {
						order = 3.2,
						type = "select",
						name = AL["FILTER_ZONE"],
						desc = AL["FILTER_ZONE_DESC"],
						values = {},
						sorting = function()
							if (next(custom_npcs_options.args[npcID].args.subzones.values)) then
								return sortValues(custom_npcs_options.args[npcID].args.subzones.values)
							end
							return nil;
						end,
						get = function(_, key) return private.custom_npcs_options[npcID].subzone end,
						set = function(_, key, value)
							private.custom_npcs_options[npcID].subzone = key
						end,
						width = 1.4,
						disabled = function() return (next(custom_npcs_options.args[npcID].args.subzones.values) == nil) end,
					},
					addZone = {
						order = 4,
						name = AL["CUSTOM_NPC_ADD_ZONE"],
						desc = AL["CUSTOM_NPC_ADD_ZONE_DESC"],
						type = "execute",
						func = function()
							-- if already selected ignore it
							if (not private.custom_npcs_options[npcID].zones[private.custom_npcs_options[npcID].subzone]) then
								if (private.custom_npcs_options[npcID].subzone == RSConstants.ALL_ZONES_CUSTOM_NPC) then
									private.custom_npcs_options[npcID].zones[private.custom_npcs_options[npcID].subzone] = AL["ALL_ZONES"]
								else
									private.custom_npcs_options[npcID].zones[private.custom_npcs_options[npcID].subzone] = RSMap.GetMapName(private.custom_npcs_options[npcID].subzone)
								end
								
								private.custom_npcs_options[npcID].zone = private.custom_npcs_options[npcID].subzone
								RSNpcDB.SetCustomNpcInfo(npcID, private.custom_npcs_options[npcID])
							end
						end,
						width = "normal",
						disabled = function() return (not private.custom_npcs_options[npcID].subzone) end,
					},
					separatorCurrentZones = {
						order = 5,
						type = "header",
						name = AL["CUSTOM_NPC_CURRENT_ZONES"],
					},
					zones = {
						order = 6.1,
						type = "select",
						name = AL["CUSTOM_NPC_CURRENT_ZONE"],
						desc = AL["CUSTOM_NPC_CURRENT_ZONE_DESC"],
						values = private.custom_npcs_options[npcID].zones,
						sorting = function()
							return sortValues(private.custom_npcs_options[npcID].zones)
						end,
						get = function(_, key) return private.custom_npcs_options[npcID].zone end,
						set = function(_, key, value)
							private.custom_npcs_options[npcID].zone = key
						end,
						width = 1.4,
						disabled = function() return (next(private.custom_npcs_options[npcID].zones) == nil) end,
					},
					deleteZone = {
						order = 6.2,
						name = AL["CUSTOM_NPC_DELETE_ZONE"],
						desc = AL["CUSTOM_NPC_DELETE_ZONE_DESC"],
						type = "execute",
						confirm = true,
						confirmText = AL["CUSTOM_NPC_DELETE_ZONE_CONFIRM"],
						func = function()
							private.custom_npcs_options[npcID].zones[private.custom_npcs_options[npcID].zone] = nil
							private.custom_npcs_options[npcID].coordinates[private.custom_npcs_options[npcID].zone] = nil
							
							if (RSNpcDB.DeleteCustomNpcZone(npcID, private.custom_npcs_options[npcID].zone)) then
								RSGeneralDB.RemoveAlreadyFoundEntity(tonumber(npcID))
							end
							
							private.custom_npcs_options[npcID].zone = next(private.custom_npcs_options[npcID].zones)
						end,
						width = 1.0,
						disabled = function() return (next(private.custom_npcs_options[npcID].zones) == nil) end,
					},
					coordinates = {
						order = 7,
						type = "input",
						name = AL["CUSTOM_NPC_COORDINATES"],
						desc = AL["CUSTOM_NPC_COORDINATES_DESC"],
						get = function(_, value) 
							if (private.custom_npcs_options[npcID].zone) then
								return private.custom_npcs_options[npcID].coordinates[private.custom_npcs_options[npcID].zone]
							end
							
							return nil
						end,
						set = function(_, value)
							private.custom_npcs_options[npcID].coordinates[private.custom_npcs_options[npcID].zone] = value
							RSNpcDB.SetCustomNpcInfo(npcID, private.custom_npcs_options[npcID])
						end,
						validate = function(_, value)
							-- Check if contains proper characters
							if (not string.match(value, "[0-9,%-]")) then
								return string.format(AL["CUSTOM_NPC_VALIDATION_CHAR"], "0123456789-,")
							end
							
							-- Check if the string is well formed
							local coordinatePairs = { strsplit(",", value) }
							for i, coordinatePair in ipairs(coordinatePairs) do
								local coordx, coordy = 	strsplit("-", coordinatePair)
								if (not coordx or string.match(coordx, "^%-?%d+$") == nil or not coordy or string.match(coordy, "^%-?%d+$") == nil) then
									return string.format(AL["CUSTOM_NPC_VALIDATION_COORD"], coordinatePair)
								end
							end
							
							return true
						end,
						width = "full",
						disabled = function() return (next(private.custom_npcs_options[npcID].zones) == nil or not private.custom_npcs_options[npcID].zone or private.custom_npcs_options[npcID].zone == RSConstants.ALL_ZONES_CUSTOM_NPC) end,
					},
					separatorExtraInfo = {
						order = 8,
						type = "header",
						name = AL["CUSTOM_NPC_EXTRA_INFO"],
					},
					displayID = {
						order = 9,
						type = "input",
						name = AL["CUSTOM_NPC_DISPLAY_ID"],
						desc = AL["CUSTOM_NPC_DISPLAY_ID_DESC"],
						get = function(_, value) 
							return private.custom_npcs_options[npcID].displayID
						end,
						set = function(_, value)
							private.custom_npcs_options[npcID].displayID = value
							RSNpcDB.SetCustomNpcInfo(npcID, private.custom_npcs_options[npcID])
						end,
						validate = function(_, value)
							-- Skips if empty
							if (not value or value == '') then
								return true
							end
							
							-- Check if number
							if (value and tonumber(value) == nil) then
								return AL["CUSTOM_NPC_VALIDATION_NUMBER"]
							end
							
							return true
						end,
						width = "full",
					},
					loot = {
						order = 10,
						type = "input",
						name = AL["CUSTOM_NPC_LOOT"],
						desc = AL["CUSTOM_NPC_LOOT_DESC"],
						get = function(_, value) 
							return private.custom_npcs_options[npcID].loot
						end,
						set = function(_, value)
							private.custom_npcs_options[npcID].loot = value
							
							if (value and value ~= '') then
								local itemIDs = {}
								for _, itemID in ipairs ({ strsplit(",", value) }) do
									tinsert(itemIDs, tonumber(itemID))
								end
								RSNpcDB.SetCustomNpcLoot(npcID, itemIDs)
							else
								RSNpcDB.SetCustomNpcLoot(npcID, nil)
							end
						end,
						validate = function(_, value)
							-- Skips if empty
							if (not value or value == '') then
								return true
							end
						
							-- Check if contains proper characters
							if (not string.match(value, "[0-9,]")) then
								return string.format(AL["CUSTOM_NPC_VALIDATION_CHAR"], "0123456789,")
							end
							
							-- Check if the string is well formed
							local itemIDs = { strsplit(",", value) }
							for _, itemID in ipairs (itemIDs) do
								if (not itemID or tonumber(itemID) == nil) then
									return AL["CUSTOM_NPC_VALIDATION_ITEM"]
								end
							end
							
							return true
						end,
						width = "full",
					},
					deleteNpc = {
						order = 11,
						name = AL["CUSTOM_NPC_DELETE_NPC"],
						desc = AL["CUSTOM_NPC_DELETE_NPC_DESC"],
						type = "execute",
						confirm = true,
						confirmText = string.format(AL["CUSTOM_NPC_DELETE_NPC_CONFIRM"], RSNpcDB.GetNpcName(tonumber(npcID))),
						func = function()
							private.custom_npcs_options[npcID] = nil
							custom_npcs_options.args[npcID] = nil
							RSNpcDB.DeleteCustomNpcInfo(npcID)
							RSGeneralDB.RemoveAlreadyFoundEntity(tonumber(npcID))
						end,
						width = "normal",
					},
				}
			}
		end

		custom_npcs_options = {
			type = "group",
			order = 1,
			name = AL["CUSTOM_NPCS"],
			handler = RareScanner,
			desc = AL["CUSTOM_NPCS"],
			args = {
				description = {
					order = 1,
					type = "description",
					name = AL["CUSTOM_NPC_TEXT"],
				},
				newNpcID = {
					order = 2,
					type = "input",
					name = AL["CUSTOM_NPC_ADD_NPC"],
					desc = AL["CUSTOM_NPC_ADD_NPC_DESC"],
					get = function(_, value) return private.custom_npcs_options_newNpcID_input end,
					set = function(_, value)
						private.custom_npcs_options_newNpcID_input = value
						addNewCustomNpc(private.custom_npcs_options_newNpcID_input);
					end,
					validate = function(_, value)
						-- Check if number
						if (tonumber(value) == nil) then
							return AL["CUSTOM_NPC_VALIDATION_NUMBER"]
						end
						
						-- Check if valid NPC
						-- Call several times to let the server load it
						RSNpcDB.GetNpcName(tonumber(value))
						RSNpcDB.GetNpcName(tonumber(value))
						local name = RSNpcDB.GetNpcName(tonumber(value))
						if (not name) then
							return AL["CUSTOM_NPC_ADD_NPC_NOEXIST"]
						end
						
						-- Check if already supported by RareScanner
						if (RSNpcDB.GetInternalNpcInfo(tonumber(value))) then
							return AL["CUSTOM_NPC_ADD_NPC_EXISTS_RS"]
						end
						
						return true
					end,
					width = "normal",
				}
			},
		}
		
		local extractCoordinates = function(overlay)
			local coordinates = ""
			if (overlay) then
				for i, coordinate in pairs (overlay) do
					local x, y = strsplit("-",coordinate)
					local pattern
					if (i > 1) then
						pattern = ",%s-%s"
					else
						pattern = "%s-%s"
					end
					
					if (tonumber(x) < 1) then
						coordinates = coordinates..string.format(pattern, string.sub(x, 3), string.sub(y, 3))
					else
						coordinates = coordinates..string.format(pattern, x, y)
					end
				end
			end
			
			return coordinates
		end
		
		-- Preload already added custom NPCs
		if (RSNpcDB.GetAllCustomNpcInfo()) then
			for npcID, npcInfo in pairs (RSNpcDB.GetAllCustomNpcInfo()) do
				local npcIDstring = tostring(npcID)
				addNewCustomNpc(npcIDstring)
				
				local npcInfo = RSNpcDB.GetCustomNpcInfo(npcID)
				if (npcInfo.displayID and npcInfo.displayID ~= 0) then
					private.custom_npcs_options[npcIDstring].displayID = tostring(npcInfo.displayID)
				end
				
				local npcLoot = RSNpcDB.GetCustomNpcLoot(npcID)
				if (npcLoot) then
					private.custom_npcs_options[npcIDstring].loot = table.concat(npcLoot, ",")
				end
				
				if (RSNpcDB.IsInternalNpcMultiZone(npcID)) then
					for zoneID, zoneInfo in pairs (npcInfo.zoneID) do
						if (zoneID == RSConstants.ALL_ZONES_CUSTOM_NPC) then
							private.custom_npcs_options[npcIDstring].zones[zoneID] = AL["ALL_ZONES"]
							private.custom_npcs_options[npcIDstring].zone = zoneID
						else
							private.custom_npcs_options[npcIDstring].zones[zoneID] = RSMap.GetMapName(zoneID)
							private.custom_npcs_options[npcIDstring].zone = zoneID
							private.custom_npcs_options[npcIDstring].coordinates[zoneID] = extractCoordinates(zoneInfo.overlay)
						end
					end
				else
					if (npcInfo.zoneID == RSConstants.ALL_ZONES_CUSTOM_NPC) then
						private.custom_npcs_options[npcIDstring].zones[npcInfo.zoneID] = AL["ALL_ZONES"]
						private.custom_npcs_options[npcIDstring].zone = npcInfo.zoneID
					else
						private.custom_npcs_options[npcIDstring].zones[npcInfo.zoneID] = RSMap.GetMapName(npcInfo.zoneID)
						private.custom_npcs_options[npcIDstring].zone = npcInfo.zoneID
						private.custom_npcs_options[npcIDstring].coordinates[npcInfo.zoneID] = extractCoordinates(npcInfo.overlay)
					end
				end
			end
		end
	end

	return custom_npcs_options
end

local container_filter_options

local function GetContainerFilterOptions()
	if not container_filter_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {}
		for k, v in pairs(RSMapDB.GetContinents()) do
			if (v.npcfilter) then
				if (v.id) then
					CONTINENT_MAP_IDS[k] = RSMap.GetMapName(k)
				else
					CONTINENT_MAP_IDS[k] = AL["ZONES_CONTINENT_LIST"][k]
				end
			end
		end

		local searchContainerByZoneID = function(zoneID, containerName)
			if (zoneID) then
				for containerID, info in pairs(RSContainerDB.GetAllInternalContainerInfo()) do
					local name = RSContainerDB.GetContainerName(containerID)
					if (not name) then
						name = AL["CONTAINER"]..' ('..containerID..')'
					else
						name = name..' ('..containerID..')'
					end
					if (not RSContainerDB.IsWorldMap(containerID) and RSContainerDB.IsInternalContainerInMap(containerID, zoneID, true) and ((containerName and RSUtils.Contains(name,containerName)) or not containerName)) then
						container_filter_options.args.containerFilters.values[name] = containerID
					end
				end
			end
		end

		local searchContainerByContinentID = function(continentID, npcName)
			if (continentID) then
				table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, zoneID)
					-- filter checkboxes
					searchContainerByZoneID(zoneID, npcName)
				end)
			end
		end

		local loadSubmapsCombo = function(continentID)
			if (continentID) then
				container_filter_options.args.subzones.values = {}
				private.container_filter_options_subzones = nil
				table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, zoneID)
					local zoneName = RSMap.GetMapName(zoneID)
					if (zoneName) then
						container_filter_options.args.subzones.values[zoneID] = zoneName
					end
				end)
			end
		end

		container_filter_options = {
			type = "group",
			order = 1,
			name = AL["CONTAINER_FILTER"],
			handler = RareScanner,
			desc = AL["CONTAINER_FILTER"],
			args = {
				filterOnlyMap = {
					order = 1,
					type = "toggle",
					name = AL["FILTER_NPCS_ONLY_MAP"],
					desc = AL["FILTER_CONTAINERS_ONLY_MAP_DESC"],
					get = function() return RSConfigDB.IsContainerFilteredOnlyOnWorldMap() end,
					set = function(_, value)
						RSConfigDB.SetContainerFilteredOnlyOnWorldMap(value)
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				containerFiltersSearch = {
					order = 2,
					type = "input",
					name = AL["FILTERS_SEARCH"],
					desc = AL["FILTERS_CONTAINERS_SEARCH_DESC"],
					get = function(_, value) return private.container_filter_options_input end,
					set = function(_, value)
						private.container_filter_options_input = value
						-- search
						container_filter_options.args.containerFilters.values = {}
						if (private.container_filter_options_subzones) then
							searchContainerByZoneID(private.container_filter_options_subzones, value)
						else
							searchContainerByContinentID(private.container_filter_options_continents, value)
						end
					end,
					width = "full",
				},
				continents = {
					order = 3.1,
					type = "select",
					name = AL["FILTER_CONTINENT"],
					desc = AL["FILTER_CONTINENT_DESC"],
					values = CONTINENT_MAP_IDS,
					sorting = sortValues(CONTINENT_MAP_IDS),
					get = function(_, key)
						-- initialize
						if (not private.container_filter_options_continents) then
							private.container_filter_options_continents = RSConstants.CURRENT_MAP_ID

							-- load submaps combo
							loadSubmapsCombo(private.container_filter_options_continents)

							-- launch first search zone filters
							searchContainerByContinentID(private.container_filter_options_continents)
						end

						return private.container_filter_options_continents
					end,
					set = function(_, key, value)
						private.container_filter_options_continents = key

						-- load subzones combo
						loadSubmapsCombo(key)

						-- search
						container_filter_options.args.containerFilters.values = {}
						searchContainerByContinentID(key, private.container_filter_options_input)
					end,
					width = 1.0,
				},
				subzones = {
					order = 3.2,
					type = "select",
					name = AL["FILTER_ZONE"],
					desc = AL["FILTER_ZONE_DESC"],
					values = {},
					sorting = function()
						if (next(container_filter_options.args.subzones.values)) then
							return sortValues(container_filter_options.args.subzones.values)
						end
						return nil;
					end,
					get = function(_, key) return private.container_filter_options_subzones end,
					set = function(_, key, value)
						private.container_filter_options_subzones = key

						-- search
						container_filter_options.args.containerFilters.values = {}
						searchContainerByZoneID(key, private.container_filter_options_input)
					end,
					width = 1.925,
					disabled = function() return (next(container_filter_options.args.subzones.values) == nil) end,
				},
				containerFiltersClear = {
					order = 3.3,
					name = AL["CLEAR_FILTERS_SEARCH"],
					desc = AL["CLEAR_FILTERS_SEARCH_DESC"],
					type = "execute",
					func = function()
						private.container_filter_options_input = nil
						container_filter_options.args.subzones.values = {}
						private.container_filter_options_subzones = nil
						private.container_filter_options_continents = RSConstants.CURRENT_MAP_ID
						-- load subzones combo
						loadSubmapsCombo(RSConstants.CURRENT_MAP_ID)
						-- search
						container_filter_options.args.containerFilters.values = {}
						searchContainerByContinentID(RSConstants.CURRENT_MAP_ID)
					end,
					width = 0.5,
				},
				separator = {
					order = 4,
					type = "header",
					name = AL["CONTAINER_FILTER"],
				},
				containerFiltersToogleAll = {
					order = 5,
					name = AL["TOGGLE_FILTERS"],
					desc = AL["TOGGLE_FILTERS_DESC"],
					type = "execute",
					func = function()
						if (next(container_filter_options.args.containerFilters.values) ~= nil) then
							if (private.db.containerFilters.filtersToggled) then
								private.db.containerFilters.filtersToggled = false
							else
								private.db.containerFilters.filtersToggled = true
							end

							for k, containerID in pairs(container_filter_options.args.containerFilters.values) do
								RSConfigDB.SetContainerFiltered(containerID, private.db.containerFilters.filtersToggled)
							end
						end
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				containerFilters = {
					order = 6,
					type = "multiselect",
					name = AL["FILTER_CONTAINER_LIST"],
					desc = AL["FILTER_CONTAINER_LIST_DESC"],
					values = {},
					get = function(_, containerID) return RSConfigDB.GetContainerFiltered(containerID) end,
					set = function(_, containerID, value)
						RSConfigDB.SetContainerFiltered(containerID, value)
						RSMinimap.RefreshAllData(true)
					end,
				}
			},
		}
	end

	return container_filter_options
end

local zones_filter_options

local function GetZonesFilterOptions()
	if not zones_filter_options then
		-- load continent combo
		local CONTINENT_MAP_IDS = {}
		for k, v in pairs(RSMapDB.GetContinents()) do
			if (v.zonefilter) then
				if (v.id) then
					CONTINENT_MAP_IDS[k] = RSMap.GetMapName(k)
				else
					CONTINENT_MAP_IDS[k] = AL["ZONES_CONTINENT_LIST"][k]
				end
			end
		end

		local searchZoneByContinentID = function(continentID, zoneName)
			if (continentID) then
				table.foreach(RSMapDB.GetContinents()[continentID].zones, function(index, zoneID)
					local tempName = nil
					if (zoneName) then
						local name = RSMap.GetMapName(zoneID)
						if (string.find(string.upper(name), string.upper(zoneName))) then
							tempName = name
						end
					else
						tempName = RSMap.GetMapName(zoneID)
					end

					if (tempName) then
						local i = 2
						local tempLoopName = tempName
						while (zones_filter_options.args.zoneFilters.values[tempLoopName]) do
							tempLoopName = tempName..' ('..i..')'
							i = i+1
						end

						zones_filter_options.args.zoneFilters.values[tempLoopName] = zoneID
					end
				end)
			end
		end

		zones_filter_options = {
			type = "group",
			order = 1,
			name = AL["ZONES_FILTER"],
			handler = RareScanner,
			desc = AL["ZONES_FILTER"],
			args = {
				filterOnlyMap = {
					order = 1,
					type = "toggle",
					name = AL["FILTER_ZONES_ONLY_MAP"],
					desc = AL["FILTER_ZONES_ONLY_MAP_DESC"],
					get = function() return RSConfigDB.IsZoneFilteredOnlyOnWorldMap() end,
					set = function(_, value)
						RSConfigDB.SetZoneFilteredOnlyOnWorldMap(value)
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				zoneFiltersSearch = {
					order = 2,
					type = "input",
					name = AL["FILTERS_SEARCH"],
					desc = AL["ZONES_FILTERS_SEARCH_DESC"],
					get = function(_, value) return private.zones_filter_input end,
					set = function(_, value)
						private.zones_filter_input = value
						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(private.zones_filter_options_continents, value)
					end,
					width = "full",
				},
				continents = {
					order = 3.1,
					type = "select",
					name = AL["FILTER_CONTINENT"],
					desc = AL["FILTER_CONTINENT_DESC"],
					values = CONTINENT_MAP_IDS,
					sorting = sortValues(CONTINENT_MAP_IDS),
					get = function(_, key)
						-- initialize
						if (not private.zones_filter_options_continents) then
							private.zones_filter_options_continents = RSConstants.CURRENT_MAP_ID

							-- launch first search zone filters
							searchZoneByContinentID(private.zones_filter_options_continents)
						end

						return private.zones_filter_options_continents
					end,
					set = function(_, key, value)
						private.zones_filter_options_continents = key

						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(key, private.zones_filter_input)
					end,
					width = "normal",
				},
				zoneFiltersClear = {
					order = 3.2,
					name = AL["CLEAR_FILTERS_SEARCH"],
					desc = AL["CLEAR_FILTERS_SEARCH_DESC"],
					type = "execute",
					func = function()
						private.zones_filter_input = nil
						private.zones_filter_options_continents = RSConstants.CURRENT_MAP_ID
						-- search
						zones_filter_options.args.zoneFilters.values = {}
						searchZoneByContinentID(RSConstants.CURRENT_MAP_ID)
					end,
					width = "normal",
				},
				separator = {
					order = 4,
					type = "header",
					name = AL["ZONES_FILTER"],
				},
				zoneFiltersToogleAll = {
					order = 5,
					name = AL["TOGGLE_FILTERS"],
					desc = AL["TOGGLE_FILTERS_DESC"],
					type = "execute",
					func = function()
						if (next(zones_filter_options.args.zoneFilters.values) ~= nil) then
							if (private.db.zoneFilters.filtersToggled) then
								private.db.zoneFilters.filtersToggled = false
							else
								private.db.zoneFilters.filtersToggled = true
							end

							for _, mapID in pairs(zones_filter_options.args.zoneFilters.values) do
								RSConfigDB:SetZoneFiltered(mapID, private.db.zoneFilters.filtersToggled)
							end
						end
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				zoneFilters = {
					order = 6,
					type = "multiselect",
					name = AL["FILTER_ZONES_LIST"],
					desc = AL["FILTER_ZONES_LIST_DESC"],
					values = {},
					get = function(_, mapID) return RSConfigDB:GetZoneFiltered(mapID) end,
					set = function(_, mapID, value)
						if (private.SUBZONES_IDS[mapID]) then
							for _, subZoneMapID in ipairs(private.SUBZONES_IDS[mapID]) do
								RSConfigDB:SetZoneFiltered(subZoneMapID, value)
								RSLogger:PrintDebugMessage(string.format("zoneFilters.subzona [%s]", subZoneMapID))
							end
						end
						RSConfigDB:SetZoneFiltered(mapID, value)
						RSLogger:PrintDebugMessage(string.format("zoneFilters [%s]", mapID))
						RSMinimap.RefreshAllData(true)
					end,
				}
			},
		}
	end

	return zones_filter_options
end

local loot_filter_options

local function GetLootFilterOptions()
	local MAIN_CATEGORIES = {}
	for k, v in pairs(private.ITEM_CLASSES) do
		MAIN_CATEGORIES[k] = GetItemClassInfo(k)
	end
	local mainCategoryID
	local toggleAll = true

	local loadSubCategory = function(mainClassID)
		if (loot_filter_options) then
			loot_filter_options.args.filters.args.category_filters.args.lootFilters.values = {}
			for i, subcategoryID in ipairs(private.ITEM_CLASSES[mainClassID]) do
				loot_filter_options.args.filters.args.category_filters.args.lootFilters.values[GetItemSubClassInfo(mainClassID, subcategoryID)] = subcategoryID
			end
		end
	end
	
	private.loadFilteredItems = function()
		if (loot_filter_options) then
			for itemID, value in pairs(RSConfigDB.GetAllFilteredItems()) do
				local itemLink, _, _, _, _, _ = RSGeneralDB.GetItemInfo(itemID)
				if (itemLink) then
					loot_filter_options.args.filters.args.individual.args.filteredItems.values[itemLink] = itemID
				end
			end
		end
	end
	
	local searchItem = function(name)
		if (name) then
			for itemID, value in pairs(RSConfigDB.GetAllFilteredItems()) do
				local itemLink, _, _, _, _, _ = RSGeneralDB.GetItemInfo(itemID)
				if ((itemLink and RSUtils.Contains(itemLink,name)) or not itemLink) then
					loot_filter_options.args.filters.args.individual.args.filteredItems.values[itemLink] = itemID
				end
			end
		else
			private.loadFilteredItems()
		end
	end

	if not loot_filter_options then
		loot_filter_options = {
			type = "group",
			order = 1,
			name = AL["LOOT_OPTIONS"],
			handler = RareScanner,
			desc = AL["LOOT_OPTIONS"],
			args = {
				displayLoot = {
					order = 1,
					type = "toggle",
					name = AL["DISPLAY_LOOT_PANEL"],
					desc = AL["DISPLAY_LOOT_PANEL_DESC"],
					get = function() return RSConfigDB.IsDisplayingLootBar() end,
					set = function(_, value)
						RSConfigDB.SetDisplayingLootBar(value)
					end,
					width = "full",
				},
				display_options = {
					type = "group",
					order = 2,
					name = AL["LOOT_DISPLAY_OPTIONS"],
					handler = RareScanner,
					desc = AL["LOOT_DISPLAY_OPTIONS_DESC"],
					args = {
						lootTooltipPosition = {
							order = 1,
							type = "select",
							name = AL["LOOT_TOOLTIP_POSITION"],
							desc = AL["LOOT_TOOLTIP_POSITION_DESC"],
							values = private.TOOLTIP_POSITIONS,
							get = function() return RSConfigDB:GetLootTooltipPosition() end,
							set = function(_, value)
								RSConfigDB:SetLootTooltipPosition(value)
							end,
							width = "double",
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
						itemsToShow = {
							order = 2,
							type = "range",
							name = AL["LOOT_MAX_ITEMS"],
							desc = AL["LOOT_MAX_ITEMS_DESC"],
							min	= 1,
							max	= 30,
							step	= 1,
							bigStep = 1,
							get = function() return RSConfigDB.GetMaxNumItemsToShow() end,
							set = function(_, value)
								RSConfigDB.SetMaxNumItemsToShow(value)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
						itemsPerRow = {
							order = 3,
							type = "range",
							name = AL["LOOT_ITEMS_PER_ROW"],
							desc = AL["LOOT_ITEMS_PER_ROW_DESC"],
							min	= 1,
							max	= 30,
							step	= 1,
							bigStep = 1,
							get = function() return RSConfigDB.GetNumItemsPerRow() end,
							set = function(_, value)
								RSConfigDB.SetNumItemsPerRow(value)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						}
					},
					disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
				},
				tooltips = {
					type = "group",
					order = 2,
					name = AL["MAP_TOOLTIPS"],
					handler = RareScanner,
					desc = AL["MAP_TOOLTIPS"],
					args = {
						commands = {
							order = 1,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_COMMANDS"],
							desc = AL["MAP_TOOLTIPS_COMMANDS_DESC"],
							get = function() return RSConfigDB.IsShowingLootTooltipsCommands() end,
							set = function(_, value)
								RSConfigDB.SetShowingLootTooltipsCommands(value)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
						covenantRequirement = {
							order = 2,
							type = "toggle",
							name = AL["LOOT_TOOLTIPS_COVENANT"],
							desc = AL["LOOT_TOOLTIPS_COVENANT_DESC"],
							get = function() return RSConfigDB.IsShowingCovenantRequirement() end,
							set = function(_, value)
								RSConfigDB.SetShowingCovenantRequirement(value)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
						canImogit = {
							order = 3,
							type = "toggle",
							name = AL["LOOT_TOOLTIPS_CANIMOGIT"],
							desc = AL["LOOT_TOOLTIPS_CANIMOGIT_DESC"],
							get = function() return RSConfigDB.IsShowingLootCanimogitTooltip() end,
							set = function(_, value)
								RSConfigDB.SetShowingLootCanimogitTooltip(value)
							end,
							width = "full",
							disabled = function() return (not CanIMogIt or (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap())) end,
						}
					},
					disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
				},
				filters = {
					type = "group",
					order = 3,
					name = AL["LOOT_FILTERS"],
					handler = RareScanner,
					desc = AL["LOOT_FILTERS_DESC"],
					args = {
						test = {
							order = 1,
							name = AL["LOOT_RESET"],
							desc = AL["LOOT_RESET_DESC"],
							type = "execute",
							func = function() 
								RSConfigDB.ResetLootFilters() 
								RSLogger:PrintMessage(AL["LOOT_RESET_DONE"])
							end,
							width = "normal",
						},
						category_filters = {
							type = "group",
							order = 2,
							name = AL["LOOT_CATEGORY_FILTERS"],
							handler = RareScanner,
							desc = AL["LOOT_CATEGORY_FILTERS_DESC"],
							args = {
								categories = {
									order = 1,
									type = "select",
									name = AL["LOOT_MAIN_CATEGORY"],
									desc = AL["LOOT_MAIN_CATEGORY"],
									values = MAIN_CATEGORIES,
									get = function(_, key)
										-- initialize
										if (not mainCategoryID) then
											mainCategoryID = DEFAULT_MAIN_CATEGORY
		
											-- load subcategory combo
											loadSubCategory(mainCategoryID)
										end
		
										return mainCategoryID
									end,
									set = function(_, key, value)
										mainCategoryID = key
		
										-- load subcategory combo
										loadSubCategory(key)
									end,
									width = "normal",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								separator = {
									order = 2,
									type = "header",
									name = AL["LOOT_SUBCATEGORY_FILTERS"],
								},
								lootFiltersToogleAll = {
									order = 3,
									name = AL["TOGGLE_FILTERS"],
									desc = AL["TOGGLE_FILTERS_DESC"],
									type = "execute",
									func = function()
										if (toggleAll) then
											toggleAll = false
										else
											toggleAll = true
										end
		
										for _, v in pairs(loot_filter_options.args.filters.args.category_filters.args.lootFilters.values) do
											RSConfigDB.SetLootFilterByCategory(mainCategoryID, v, toggleAll)
										end
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								lootFilters = {
									order = 4,
									type = "multiselect",
									name = AL["LOOT_FILTER_SUBCATEGORY_LIST"],
									desc = AL["LOOT_FILTER_SUBCATEGORY_DESC"],
									values = {},
									get = function(_, key) return RSConfigDB.GetLootFilterByCategory(mainCategoryID, key) end,
									set = function(_, key, value)
										RSLogger:PrintDebugMessage(string.format("Cambiando el valor de ClassID [%s], SubClassID [%s]", mainCategoryID, key))
										RSConfigDB.SetLootFilterByCategory(mainCategoryID, key, value);
									end,
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								}
							},
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
						individual = {
							type = "group",
							order = 3,
							name = AL["LOOT_INDIVIDUAL_FILTERS"],
							handler = RareScanner,
							desc = AL["LOOT_INDIVIDUAL_FILTERS_DESC"],
							args = {
								search = {
									order = 1,
									type = "input",
									name = AL["FILTERS_SEARCH"],
									desc = AL["LOOT_SEARCH_ITEMS_DESC"],
									get = function(_, value) return private.loot_individual_filter_input end,
									set = function(_, value)
										private.loot_individual_filter_input = value
										-- search
										loot_filter_options.args.filters.args.individual.args.filteredItems.values = {}
										searchItem(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filteredItems = {
									order = 2,
									type = "multiselect",
									name = AL["LOOT_FILTER_ITEM_LIST"],
									desc = "itemLink",
									values = {},
									get = function(_, itemID) return RSConfigDB.GetItemFiltered(itemID) end,
									set = function(_, itemID, value)
										RSConfigDB.SetItemFiltered(itemID, value)
									end,
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								}
							}
						},
						other_filters = {
							type = "group",
							order = 4,
							name = AL["LOOT_OTHER_FILTERS"],
							handler = RareScanner,
							desc = AL["LOOT_OTHER_FILTERS_DESC"],
							args = {
								lootMinQuality = {
									order = 1,
									type = "select",
									name = AL["LOOT_MIN_QUALITY"],
									desc = AL["LOOT_MIN_QUALITY_DESC"],
									values = private.ITEM_QUALITY,
									get = function() return RSConfigDB.GetLootFilterMinQuality() end,
									set = function(_, value)
										RSConfigDB.SetLootFilterMinQuality(value)
									end,
									width = "double",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterNotEquipableItems = {
									order = 2,
									type = "toggle",
									name = AL["LOOT_FILTER_NOT_EQUIPABLE"],
									desc = AL["LOOT_FILTER_NOT_EQUIPABLE_DESC"],
									get = function() return RSConfigDB.IsFilteringLootByNotEquipableItems() end,
									set = function(_, value)
										RSConfigDB.SetFilteringLootByNotEquipableItems(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								showOnlyTransmogItems = {
									order = 3,
									type = "toggle",
									name = AL["LOOT_FILTER_NOT_TRANSMOG"],
									desc = AL["LOOT_FILTER_NOT_TRANSMOG_DESC"],
									get = function() return RSConfigDB.IsFilteringLootByTransmog() end,
									set = function(_, value)
										RSConfigDB.SetFilteringLootByTransmog(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterCollectedItems = {
									order = 4,
									type = "toggle",
									name = AL["LOOT_FILTER_COLLECTED"],
									desc = AL["LOOT_FILTER_COLLECTED_DESC"],
									get = function() return RSConfigDB.IsFilteringByCollected() end,
									set = function(_, value)
										RSConfigDB.SetFilteringByCollected(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterItemsCompletedQuest = {
									order = 5,
									type = "toggle",
									name = AL["LOOT_FILTER_COMPLETED_QUEST"],
									desc = AL["LOOT_FILTER_COMPLETED_QUEST_DESC"],
									get = function() return RSConfigDB.IsFilteringLootByCompletedQuest() end,
									set = function(_, value)
										RSConfigDB.SetFilteringLootByCompletedQuest(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterNotMatchingClass = {
									order = 6,
									type = "toggle",
									name = AL["LOOT_FILTER_NOT_MATCHING_CLASS"],
									desc = AL["LOOT_FILTER_NOT_MATCHING_CLASS_DESC"],
									get = function() return RSConfigDB.IsFilteringLootByNotMatchingClass() end,
									set = function(_, value)
										RSConfigDB.SetFilteringLootByNotMatchingClass(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterNotMatchingFaction = {
									order = 7,
									type = "toggle",
									name = AL["LOOT_FILTER_NOT_MATCHING_FACTION"],
									desc = AL["LOOT_FILTER_NOT_MATCHING_FACTION_DESC"],
									get = function() return RSConfigDB.IsFilteringLootByNotMatchingFaction() end,
									set = function(_, value)
										RSConfigDB.SetFilteringLootByNotMatchingFaction(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterAnimaItems = {
									order = 8,
									type = "toggle",
									name = AL["LOOT_FILTER_ANIMA_ITEMS"],
									desc = AL["LOOT_FILTER_ANIMA_ITEMS_DESC"],
									get = function() return RSConfigDB.IsFilteringAnimaItems() end,
									set = function(_, value)
										RSConfigDB.SetFilteringAnimaItems(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
								filterNotUsableConduits = {
									order = 9,
									type = "toggle",
									name = AL["LOOT_FILTER_CONDUIT_ITEMS"],
									desc = AL["LOOT_FILTER_CONDUIT_ITEMS_DESC"],
									get = function() return RSConfigDB.IsFilteringConduitItems() end,
									set = function(_, value)
										RSConfigDB.SetFilteringConduitItems(value)
									end,
									width = "full",
									disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
								},
							},
							disabled = function() return (not RSConfigDB.IsDisplayingLootBar() and not RSConfigDB.IsShowingLootOnWorldMap()) end,
						},
					},
				},
			},
		}
		
		-- Load filtered items
		private.loadFilteredItems()
	end

	return loot_filter_options
end

local map_options

local function GetMapOptions()
	if not map_options then
		map_options = {
			type = "group",
			order = 1,
			name = AL["MAP_OPTIONS"],
			handler = RareScanner,
			desc = AL["MAP_OPTIONS"],
			args = {
				minimap = {
					order = 1,
					type = "toggle",
					name = AL["DISPLAY_MINIMAP_ICONS"],
					desc = AL["DISPLAY_MINIMAP_ICONS_DESC"],
					get = function() return RSConfigDB.IsShowingMinimapIcons() end,
					set = function(_, value)
						RSConfigDB.SetShowingMinimapIcons(value)
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
				},
				scale = {
					order = 2,
					type = "range",
					name = AL["MAP_SCALE_ICONS"],
					desc = AL["MAP_SCALE_ICONS_DESC"],
					min	= 0.3,
					max	= 1.4,
					step = 0.01,
					bigStep = 0.05,
					get = function() return RSConfigDB.GetIconsWorldMapScale() end,
					set = function(_, value)
						RSConfigDB.SetIconsWorldMapScale(value)
					end,
					width = "full",
					disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) end,
				},
				minimapscale = {
					order = 3,
					type = "range",
					name = AL["MINIMAP_SCALE_ICONS"],
					desc = AL["MINIMAP_SCALE_ICONS_DESC"],
					min	= 0.3,
					max	= 1.4,
					step = 0.01,
					bigStep = 0.05,
					get = function() return private.db.map.minimapscale end,
					set = function(_, value)
						private.db.map.minimapscale = value
						RSMinimap.RefreshAllData(true)
					end,
					width = "full",
					disabled = function() return (not RSConfigDB.IsShowingMinimapIcons() or (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents())) end,
				},
				icons = {
					type = "group",
					order = 1,
					name = AL["MAP_ICONS"],
					handler = RareScanner,
					desc = AL["MAP_ICONS_DESC"],
					args = {
						separatorNpcs = {
							order = 1,
							type = "header",
							name = AL["MAP_NPCS_ICONS"],
						},
						displayNpcIcons = {
							order = 2,
							type = "toggle",
							name = AL["DISPLAY_NPC_ICONS"],
							desc = AL["DISPLAY_NPC_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingNpcs() end,
							set = function(_, value)
								RSConfigDB.SetShowingNpcs(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
						},
						displayFriendlyNpcIcons = {
							order = 3,
							type = "toggle",
							name = AL["DISPLAY_FRIENDLY_NPC_ICONS"],
							desc = AL["DISPLAY_FRIENDLY_NPC_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingFriendlyNpcs() end,
							set = function(_, value)
								RSConfigDB.SetShowingFriendlyNpcs(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs()) end,
						},
						keepShowingAfterDead = {
							order = 4,
							type = "toggle",
							name = AL["MAP_SHOW_ICON_AFTER_DEAD"],
							desc = AL["MAP_SHOW_ICON_AFTER_DEAD_DESC"],
							get = function() return RSConfigDB.IsShowingDeadNpcs() end,
							set = function(_, value)
								RSConfigDB.SetShowingDeadNpcs(value)
								RSConfigDB.SetShowingDeadNpcsInReseteableZones(false)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) end,
						},
						keepShowingAfterDeadReseteable = {
							order = 5,
							type = "toggle",
							name = AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE"],
							desc = AL["MAP_SHOW_ICON_AFTER_DEAD_RESETEABLE_DESC"],
							get = function() return RSConfigDB.IsShowingDeadNpcsInReseteableZones() end,
							set = function(_, value)
								RSConfigDB.SetShowingDeadNpcsInReseteableZones(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) or private.db.map.keepShowingAfterDead end,
						},
						separatorContainers = {
							order = 6,
							type = "header",
							name = AL["MAP_CONTAINERS_ICONS"],
						},
						displayContainerIcons = {
							order = 7,
							type = "toggle",
							name = AL["DISPLAY_CONTAINER_ICONS"],
							desc = AL["DISPLAY_CONTAINER_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingContainers() end,
							set = function(_, value)
								RSConfigDB.SetShowingContainers(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
						},
						keepShowingAfterCollected = {
							order = 8,
							type = "toggle",
							name = AL["MAP_SHOW_ICON_AFTER_COLLECTED"],
							desc = AL["MAP_SHOW_ICON_AFTER_COLLECTED_DESC"],
							get = function() return RSConfigDB.IsShowingOpenedContainers() end,
							set = function(_, value)
								RSConfigDB.SetShowingOpenedContainers(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) end,
						},
						separatorEvents = {
							order = 9,
							type = "header",
							name = AL["MAP_EVENTS_ICONS"],
						},
						displayEventIcons = {
							order = 10,
							type = "toggle",
							name = AL["DISPLAY_EVENT_ICONS"],
							desc = AL["DISPLAY_EVENT_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingEvents() end,
							set = function(_, value)
								RSConfigDB.SetShowingEvents(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
						},
						keepShowingAfterCompleted = {
							order = 11,
							type = "toggle",
							name = AL["MAP_SHOW_ICON_AFTER_COMPLETED"],
							desc = AL["MAP_SHOW_ICON_AFTER_COMPLETED_DESC"],
							get = function() return RSConfigDB.IsShowingCompletedEvents() end,
							set = function(_, value)
								RSConfigDB.SetShowingCompletedEvents(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) end,
						},
						separatorNotDiscovered = {
							order = 12,
							type = "header",
							name = AL["MAP_NOT_DISCOVERED_ICONS"],
						},
						displayNotDiscoveredMapIcons = {
							order = 13,
							type = "toggle",
							name = AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS"],
							desc = AL["DISPLAY_MAP_NOT_DISCOVERED_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingNotDiscoveredMapIcons() end,
							set = function(_, value)
								RSConfigDB.SetShowingNotDiscoveredMapIcons(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) end,
						},
						displayOldNotDiscoveredMapIcons = {
							order = 14,
							type = "toggle",
							name = AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS"],
							desc = AL["DISPLAY_MAP_OLD_NOT_DISCOVERED_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingOldNotDiscoveredMapIcons() end,
							set = function(_, value)
								RSConfigDB.SetShowingOldNotDiscoveredMapIcons(value)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return ((not RSConfigDB.IsShowingNpcs() and not RSConfigDB.IsShowingContainers() and not RSConfigDB.IsShowingEvents()) or not private.db.map.displayNotDiscoveredMapIcons) end,
						},
					},
				},
				timers = {
					type = "group",
					order = 2,
					name = AL["MAP_TIMERS"],
					handler = RareScanner,
					desc = AL["MAP_TIMERS_DESC"],
					args = {
						maxSeenTime = {
							order = 1,
							type = "range",
							name = AL["MAP_SHOW_ICON_MAX_SEEN_TIME"],
							desc = AL["MAP_SHOW_ICON_MAX_SEEN_TIME_DESC"],
							min	= 0,
							max	= 30,
							step = 1,
							bigStep = 1,
							get = function() return RSConfigDB.GetMaxSeenTimeFilter() end,
							set = function(_, value)
								RSConfigDB.SetMaxSeenTimeFilter(value, true)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingNpcs()) end,
						},
						maxSeenTimeContainer = {
							order = 2,
							type = "range",
							name = AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME"],
							desc = AL["MAP_SHOW_ICON_CONTAINER_MAX_SEEN_TIME_DESC"],
							min	= 0,
							max	= 15,
							step = 1,
							bigStep = 1,
							get = function() return RSConfigDB.GetMaxSeenContainerTimeFilter() end,
							set = function(_, value)
								RSConfigDB.SetMaxSeenContainerTimeFilter(value, true)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingContainers()) end,
						},
						maxSeenTimeEvent = {
							order = 3,
							type = "range",
							name = AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME"],
							desc = AL["MAP_SHOW_ICON_EVENT_MAX_SEEN_TIME_DESC"],
							min	= 0,
							max	= 15,
							step = 1,
							bigStep = 1,
							get = function() return RSConfigDB.GetMaxSeenEventTimeFilter() end,
							set = function(_, value)
								RSConfigDB.SetMaxSeenEventTimeFilter(value, true)
								RSMinimap.RefreshAllData(true)
							end,
							width = "full",
							disabled = function() return (not RSConfigDB.IsShowingEvents()) end,
						}
					}
				},
				searcher = {
					type = "group",
					order = 3,
					name = AL["MAP_SEARCHER"],
					handler = RareScanner,
					desc = AL["MAP_SEARCHER_DESC"],
					args = {
						displaySearch = {
							order = 1,
							type = "toggle",
							name = AL["MAP_SEARCHER_DISPLAY"],
							desc = AL["MAP_SEARCHER_DISPLAY_DESC"],
							get = function() return RSConfigDB.IsShowingWorldMapSearcher() end,
							set = function(_, value)
								RSConfigDB.SetShowingWorldMapSearcher(value)
							end,
							width = "double",
						},
						clearValueOnChange = {
							order = 2,
							type = "toggle",
							name = AL["MAP_SEARCHER_CLEAR"],
							desc = AL["MAP_SEARCHER_CLEAR_DESC"],
							get = function() return RSConfigDB.IsClearingWorldMapSearcher() end,
							set = function(_, value)
								RSConfigDB.SetClearingWorldMapSearcher(value)
							end,
							width = "double",
						},
					}
				}, 
				waypoints = {
					type = "group",
					order = 4,
					name = AL["MAP_WAYPOINTS"],
					handler = RareScanner,
					desc = AL["MAP_WAYPOINTS_DESC"],
					args = {
						tomtom = {
							order = 1,
							type = "toggle",
							name = AL["MAP_WAYPOINT_TOMTOM"],
							desc = AL["MAP_WAYPOINT_TOMTOM_DESC"],
							get = function() return RSConfigDB.IsAddingWorldMapTomtomWaypoints() end,
							set = function(_, value)
								RSConfigDB.SetAddingWorldMapTomtomWaypoints(value)
							end,
							width = "double",
							disabled = function() return not TomTom end,
						},
						ingame = {
							order = 2,
							type = "toggle",
							name = AL["MAP_WAYPOINT_INGAME"],
							desc = AL["MAP_WAYPOINT_INGAME_DESC"],
							get = function() return RSConfigDB.IsAddingWorldMapIngameWaypoints() end,
							set = function(_, value)
								RSConfigDB.SetAddingWorldMapIngameWaypoints(value)
							end,
							width = "double",
						},
					}
				},
				tooltips = {
					type = "group",
					order = 1,
					name = AL["MAP_TOOLTIPS"],
					handler = RareScanner,
					desc = AL["MAP_TOOLTIPS_DESC"],
					args = {
						scale = {
							order = 1,
							type = "range",
							name = AL["MAP_TOOLTIPS_SCALE"],
							desc = AL["MAP_TOOLTIPS_SCALE_DESC"],
							min	= 0.1,
							max	= 1.5,
							step = 0.05,
							get = function() return RSConfigDB.GetWorldMapTooltipsScale() end,
							set = function(_, value)
								RSConfigDB.SetWorldMapTooltipsScale(value)
							end,
							width = "full",
						},
						worldmapTooltips = {
							order = 2,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_WORLDMAP_ICONS"],
							desc = AL["MAP_TOOLTIPS_WORLDMAP_ICONS_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsOnIngameIcons() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsOnIngameIcons(value)
							end,
							width = "full",
						},
						achievementsInfo = {
							order = 3,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_ACHIEVEMENT"],
							desc = AL["MAP_TOOLTIPS_ACHIEVEMENT_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsAchievements() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsAchievements(value)
							end,
							width = "full",
						},
						notes = {
							order = 4,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_NOTES"],
							desc = AL["MAP_TOOLTIPS_NOTES_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsNotes() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsNotes(value)
							end,
							width = "full",
						},
						loot = {
							order = 5,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_LOOT"],
							desc = AL["MAP_TOOLTIPS_LOOT_DESC"],
							get = function() return RSConfigDB.IsShowingLootOnWorldMap() end,
							set = function(_, value)
								RSConfigDB.SetShowingLootOnWorldMap(value)
							end,
							width = "full",
						},
						lastTimeSeen = {
							order = 6,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_SEEN"],
							desc = AL["MAP_TOOLTIPS_SEEN_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsSeen() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsSeen(value)
							end,
							width = "full",
						},
						state = {
							order = 7,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_STATE"],
							desc = AL["MAP_TOOLTIPS_STATE_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsState() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsState(value)
							end,
							width = "full",
						},
						commands = {
							order = 8,
							type = "toggle",
							name = AL["MAP_TOOLTIPS_COMMANDS"],
							desc = AL["MAP_TOOLTIPS_COMMANDS_DESC"],
							get = function() return RSConfigDB.IsShowingTooltipsCommands() end,
							set = function(_, value)
								RSConfigDB.SetShowingTooltipsCommands(value)
							end,
							width = "full",
						},
					},
				},
				spawnSpots = {
					type = "group",
					order = 1,
					name = AL["MAP_SPAWN_SPOTS"],
					handler = RareScanner,
					desc = AL["MAP_SPAWN_SPOTS_DESC"],
					args = {
					}
				}
			}
		}
		
		-- load spawning spots panel
		for i = 1, private.db.map.overlayMaxColours, 1 do
			map_options.args.spawnSpots.args["colour"..i] = {}
			map_options.args.spawnSpots.args["colour"..i].name = string.format(AL["MAP_SPAWN_SPOTS_COLOUR"], i)
			map_options.args.spawnSpots.args["colour"..i].desc = string.format(AL["MAP_SPAWN_SPOTS_COLOUR"], i)
			map_options.args.spawnSpots.args["colour"..i].order = i
			map_options.args.spawnSpots.args["colour"..i].type = "color"
			map_options.args.spawnSpots.args["colour"..i].get = function() 
				return RSConfigDB.GetWorldMapOverlayColour(i) 
			end
			map_options.args.spawnSpots.args["colour"..i].set = function(_, r, g, b)
				RSConfigDB.SetWorldMapOverlayColour(i, r, g, b)
			end
			map_options.args.spawnSpots.args["colour"..i].width = "full"
		end
	end

	return map_options
end

function RareScanner:RefreshOptions(event, database, newProfileKey)
	private.db = database.profile
end

function RareScanner:SetupOptions()
	local RSAC = LibStub("AceConfig-3.0")
	RSAC:RegisterOptionsTable("RareScanner General", GetGeneralOptions)
	RSAC:RegisterOptionsTable("RareScanner Sound", GetSoundOptions)
	RSAC:RegisterOptionsTable("RareScanner Display", GetDisplayOptions)
	RSAC:RegisterOptionsTable("RareScanner Custom NPCs", GetCustomNpcOptions)
	RSAC:RegisterOptionsTable("RareScanner NPC Filter", GetFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Container Filter", GetContainerFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Zone Filter", GetZonesFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Loot Options", GetLootFilterOptions)
	RSAC:RegisterOptionsTable("RareScanner Map", GetMapOptions)
	RSAC:RegisterOptionsTable("RareScanner Profiles", RareScanner:GetOptionsTable())

	local RSACD = LibStub("AceConfigDialog-3.0-RSmod")
	RSACD:AddToBlizOptions("RareScanner General", _G.GENERAL_LABEL, "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Sound", AL["SOUND"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Display", AL["DISPLAY"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Custom NPCs", AL["CUSTOM_NPCS"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner NPC Filter", AL["FILTER"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Container Filter", AL["CONTAINER_FILTER"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Zone Filter", AL["ZONES_FILTER"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Loot Options", AL["LOOT_OPTIONS"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Map", AL["MAP_OPTIONS"], "RareScanner")
	RSACD:AddToBlizOptions("RareScanner Profiles", AL["PROFILES"], "RareScanner")
end
