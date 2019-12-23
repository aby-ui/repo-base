local Config = {}
local AceDialog, AceRegistry, AceGUI, SML, registered, options
local playerClass = select(2, UnitClass("player"))
local modifyUnits, globalConfig = {}, {}
local L = ShadowUF.L

ShadowUF.Config = Config

--[[
	The part that makes configuration a pain when you actually try is it gets unwieldly when you're adding special code to deal with
	showing help for certain cases, swapping tabs etc that makes it work smoothly.

	I'm going to have to split it out into separate files for each type to clean everything up but that takes time and I have other things
	I want to get done with first.

	-- dated 2009

	In reality, this will never be cleaned up because jesus christ, I am not refactoring 7,000 lines of configuration.

	*** HERE BE DRAGONS ***
]]

local unitCategories = {
	player = {"player", "pet"},
	general = {"target", "targettarget", "targettargettarget", "focus", "focustarget", "pettarget"},
	party = {"party", "partypet", "partytarget", "partytargettarget", "party"},
	raid = {"raid", "raidpet"},
	raidmisc = {"maintank", "maintanktarget", "maintanktargettarget", "mainassist", "mainassisttarget", "mainassisttargettarget"},
	boss = {"boss", "bosstarget", "bosstargettarget"},
	arena = {"arena", "arenapet", "arenatarget", "arenatargettarget"},
	battleground = {"battleground", "battlegroundpet", "battlegroundtarget", "battlegroundtargettarget"}
}

local UNIT_DESC = {
	["boss"] = L["Boss units are for only certain fights, such as Blood Princes or the Gunship battle, you will not see them for every boss fight."],
	["mainassist"] = L["Main Assists's are set by the Blizzard Main Assist system or mods that use it."],
	["maintank"] = L["Main Tank's are set through the Raid frames, or through selecting the Tank role."],
	["battleground"] = L["Currently used in battlegrounds for showing flag carriers."],
	["battlegroundpet"] = L["Current pet used by a battleground unit."],
	["battlegroundtarget"] = L["Current target of a battleground unit."],
	["battlegroundtargettarget"] = L["Current target of target of a battleground unit."]
}

local PAGE_DESC = {
	["general"] = L["General configuration to all enabled units."],
	["enableUnits"] = L["Various units can be enabled through this page, such as raid or party targets."],
	["hideBlizzard"] = L["Hiding and showing various aspects of the default UI such as the player buff frames."],
	["units"] = L["Configuration to specific unit frames."],
	["visibility"] = L["Disabling unit modules in various instances."],
	["tags"] = L["Advanced tag management, allows you to add your own custom tags."],
	["filter"] = L["Simple aura filtering by whitelists and blacklists."],
}
local INDICATOR_NAMES = {["questBoss"] = L["Quest Boss"], ["leader"] = L["Leader / Assist"], ["lfdRole"] = L["Class Role"], ["masterLoot"] = L["Master Looter"], ["pvp"] = L["PvP Flag"], ["raidTarget"] = L["Raid Target"], ["ready"] = L["Ready Status"], ["role"] = L["Raid Role"], ["status"] = L["Combat Status"], ["class"] = L["Class Icon"], ["resurrect"] = L["Resurrect Status"], ["sumPending"] = L["Summon Pending"], ["phase"] = L["Other Party/Phase Status"], ["petBattle"] = L["Pet Battle"], ["arenaSpec"] = L["Arena Spec"]}
local AREA_NAMES = {["arena"] = L["Arenas"],["none"] = L["Everywhere else"], ["party"] = L["Party instances"], ["pvp"] = L["Battleground"], ["raid"] = L["Raid instances"]}
local INDICATOR_DESC = {
		["leader"] = L["Crown indicator for group leader or assistants."], ["lfdRole"] = L["Role the unit is playing."],
		["masterLoot"] = L["Bag indicator for master looters."], ["pvp"] = L["PVP flag indicator, Horde for Horde flagged pvpers and Alliance for Alliance flagged pvpers."],
		["raidTarget"] = L["Raid target indicator."], ["ready"] = L["Ready status of group members."], ["phase"] = L["Shows when a party member is in a different phase or another group."],
		["questBoss"] = L["Shows that a NPC is a boss for a quest."], ["petBattle"] = L["Shows what kind of pet the unit is for pet battles."],
		["role"] = L["Raid role indicator, adds a shield indicator for main tanks and a sword icon for main assists."], ["status"] = L["Status indicator, shows if the unit is currently in combat. For the player it will also show if you are rested."], ["class"] = L["Class icon for players."],
		["arenaSpec"] = L["Talent spec of your arena opponents."]
}
local TAG_GROUPS = {["classification"] = L["Classifications"], ["health"] = L["Health"], ["misc"] = L["Miscellaneous"], ["playerthreat"] = L["Player threat"], ["power"] = L["Power"], ["status"] = L["Status"], ["threat"] = L["Threat"], ["raid"] = L["Raid"], ["classspec"] = L["Class Specific"], ["classtimer"] = L["Class Timer"]}

local pointPositions = {["BOTTOM"] = L["Bottom"], ["TOP"] = L["Top"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["TOPLEFT"] = L["Top Left"], ["TOPRIGHT"] = L["Top Right"], ["BOTTOMLEFT"] = L["Bottom Left"], ["BOTTOMRIGHT"] = L["Bottom Right"], ["CENTER"] = L["Center"]}
local positionList = {["C"] = L["Center"], ["RT"] = L["Right Top"], ["RC"] = L["Right Center"], ["RB"] = L["Right Bottom"], ["LT"] = L["Left Top"], ["LC"] = L["Left Center"], ["LB"] = L["Left Bottom"], ["BL"] = L["Bottom Left"], ["BC"] = L["Bottom Center"], ["BR"] = L["Bottom Right"], ["TR"] = L["Top Right"], ["TC"] = L["Top Center"], ["TL"] = L["Top Left"]}

local unitOrder = {}
for order, unit in pairs(ShadowUF.unitList) do unitOrder[unit] = order end
local fullReload = {["bars"] = true, ["auras"] = true, ["backdrop"] = true, ["font"] = true, ["classColors"] = true, ["powerColors"] = true, ["healthColors"] = true, ["xpColors"] = true, ["omnicc"] = true}
local quickIDMap = {}

-- Helper functions
local function getPageDescription(info)
	return PAGE_DESC[info[#(info)]]
end

local function getFrameName(unit)
	if( unit == "raidpet" or unit == "raid" or unit == "party" or unit == "maintank" or unit == "mainassist" or unit == "boss" or unit == "arena" ) then
		return string.format("#SUFHeader%s", unit)
	end

	return string.format("#SUFUnit%s", unit)
end

local anchorList = {}
local function getAnchorParents(info)
	local unit = info[2]
	for k in pairs(anchorList) do anchorList[k] = nil end

	if( ShadowUF.Units.childUnits[unit] ) then
		anchorList["$parent"] = string.format(L["%s member"], L.units[ShadowUF.Units.childUnits[unit]])
		return anchorList
	end

	anchorList["UIParent"] = L["Screen"]

	-- Don't let a frame anchor to a frame thats anchored to it already (Stop infinite loops-o-doom)
	local currentName = getFrameName(unit)
	for _, unitID in pairs(ShadowUF.unitList) do
		if( unitID ~= unit and ShadowUF.db.profile.positions[unitID] and ShadowUF.db.profile.positions[unitID].anchorTo ~= currentName ) then
			anchorList[getFrameName(unitID)] = string.format(L["%s frames"], L.units[unitID] or unitID)
		end
	end

	return anchorList
end

local function selectDialogGroup(group, key)
	AceDialog.Status.ShadowedUF.children[group].status.groups.selected = key
	AceRegistry:NotifyChange("ShadowedUF")
end

local function selectTabGroup(group, subGroup, key)
	AceDialog.Status.ShadowedUF.children[group].status.groups.selected = subGroup
	AceDialog.Status.ShadowedUF.children[group].children[subGroup].status.groups.selected = key
	AceRegistry:NotifyChange("ShadowedUF")
end

local function hideAdvancedOption(info)
	return not ShadowUF.db.profile.advanced
end

local function hideBasicOption(info)
	return ShadowUF.db.profile.advanced
end

local function isUnitDisabled(info)
	local unit = info[#(info)]
	local enabled = ShadowUF.db.profile.units[unit].enabled
	for _, visibility in pairs(ShadowUF.db.profile.visibility) do
		if( visibility[unit] ) then
			enabled = visibility[unit]
			break
		end
	end

	return not enabled
end

local function mergeTables(parent, child)
	for key, value in pairs(child) do
		if( type(parent[key]) == "table" ) then
			parent[key] = mergeTables(parent[key], value)
		elseif( type(value) == "table" ) then
			parent[key] = CopyTable(value)
		elseif( parent[key] == nil ) then
			parent[key] = value
		end
	end

	return parent
end

local function getName(info)
	local key = info[#(info)]
	if( ShadowUF.modules[key] and ShadowUF.modules[key].moduleName ) then
		return ShadowUF.modules[key].moduleName
	end

	return LOCALIZED_CLASS_NAMES_MALE[key] or INDICATOR_NAMES[key] or L.units[key] or TAG_GROUPS[key] or L[key]
end

local function getUnitOrder(info)
	return unitOrder[info[#(info)]]
end

local function isModifiersSet(info)
	if( info[2] ~= "global" ) then return false end
	for k in pairs(modifyUnits) do return false end
	return true
end

-- These are for setting simple options like bars.texture = "Default" or locked = true
local function set(info, value)
	local cat, key = string.split(".", info.arg)
	if( key == "$key" ) then key = info[#(info)] end

	if( not key ) then
		ShadowUF.db.profile[cat] = value
	else
		ShadowUF.db.profile[cat][key] = value
	end

	if( cat and fullReload[cat] ) then
		ShadowUF.Layout:CheckMedia()
		ShadowUF.Layout:Reload()
	end
end

local function get(info)
	local cat, key = string.split(".", info.arg)
	if( key == "$key" ) then key = info[#(info)] end
	if( not key ) then
		return ShadowUF.db.profile[cat]
	else
		return ShadowUF.db.profile[cat][key]
	end
end

local function setColor(info, r, g, b, a)
	local color = get(info) or {}
	color.r, color.g, color.b, color.a = r, g, b, a
	set(info, color)
end

local function getColor(info)
	local color = get(info) or {}
	return color.r, color.g, color.b, color.a
end

-- These are for setting complex options like units.player.auras.buffs.enabled = true or units.player.portrait.enabled = true
local function setVariable(unit, moduleKey, moduleSubKey, key, value)
	local configTable = unit == "global" and globalConfig or ShadowUF.db.profile.units[unit]

	-- For setting options like units.player.auras.buffs.enabled = true
	if( moduleKey and moduleSubKey and configTable[moduleKey][moduleSubKey] ) then
		configTable[moduleKey][moduleSubKey][key] = value
		ShadowUF.Layout:Reload(unit)
	-- For setting options like units.player.portrait.enabled = true
	elseif( moduleKey and not moduleSubKey and configTable[moduleKey] ) then
		configTable[moduleKey][key] = value
		ShadowUF.Layout:Reload(unit)
	-- For setting options like units.player.height = 50
	elseif( not moduleKey and not moduleSubKey ) then
		configTable[key] = value
		ShadowUF.Layout:Reload(unit)
	end
end

local function specialRestricted(unit, moduleKey, moduleSubKey, key)
	if( ShadowUF.fakeUnits[unit] and ( key == "colorAggro" or key == "aggro" or key == "colorDispel" or moduleKey == "incHeal" or moduleKey == "healAbsorb" or moduleKey == "incAbsorb" or moduleKey == "castBar" ) ) then
		return true
	elseif( moduleKey == "healthBar" and unit == "player" and key == "reaction" ) then
		return true
	end
end

local function setDirectUnit(unit, moduleKey, moduleSubKey, key, value)
	if( unit == "global" ) then
		for globalUnit in pairs(modifyUnits) do
			if( not specialRestricted(globalUnit, moduleKey, moduleSubKey, key) ) then
				setVariable(globalUnit, moduleKey, moduleSubKey, key, value)
			end
		end

		setVariable("global", moduleKey, moduleSubKey, key, value)
	else
		setVariable(unit, moduleKey, moduleSubKey, key, value)
	end
end

local function setUnit(info, value)
	local unit = info[2]
	-- auras, buffs, enabled / text, 1, text / portrait, enabled
	local moduleKey, moduleSubKey, key = string.split(".", info.arg)
	if( not moduleSubKey ) then key = moduleKey moduleKey = nil end
	if( moduleSubKey and not key ) then key = moduleSubKey moduleSubKey = nil end
	if( moduleSubKey == "$parent" ) then moduleSubKey = info[#(info) - 1] end
	if( moduleKey == "$parent" ) then moduleKey = info[#(info) - 1] end
	if( moduleSubKey == "$parentparent" ) then moduleSubKey = info[#(info) - 2] end
	if( moduleKey == "$parentparent" ) then moduleKey = info[#(info) - 2] end
	if( tonumber(moduleSubKey) ) then moduleSubKey = tonumber(moduleSubKey) end

	setDirectUnit(unit, moduleKey, moduleSubKey, key, value)
end

local function getVariable(unit, moduleKey, moduleSubKey, key)
	local configTbl = unit == "global" and globalConfig or ShadowUF.db.profile.units[unit]
	if( moduleKey and moduleSubKey ) then
		return configTbl[moduleKey][moduleSubKey] and configTbl[moduleKey][moduleSubKey][key]
	elseif( moduleKey and not moduleSubKey ) then
		return configTbl[moduleKey] and configTbl[moduleKey][key]
	end

	return configTbl[key]
end

local function getUnit(info)
	local moduleKey, moduleSubKey, key = string.split(".", info.arg)
	if( not moduleSubKey ) then key = moduleKey moduleKey = nil end
	if( moduleSubKey and not key ) then key = moduleSubKey moduleSubKey = nil end
	if( moduleSubKey == "$parent" ) then moduleSubKey = info[#(info) - 1] end
	if( moduleKey == "$parent" ) then moduleKey = info[#(info) - 1] end
	if( moduleSubKey == "$parentparent" ) then moduleSubKey = info[#(info) - 2] end
	if( moduleKey == "$parentparent" ) then moduleKey = info[#(info) - 2] end
	if( tonumber(moduleSubKey) ) then moduleSubKey = tonumber(moduleSubKey) end

	return getVariable(info[2], moduleKey, moduleSubKey, key)
end

-- Tag functions
local function getTagName(info)
	local tag = info[#(info)]
	if( ShadowUF.db.profile.tags[tag] and ShadowUF.db.profile.tags[tag].name ) then
		return ShadowUF.db.profile.tags[tag].name
	end

	return ShadowUF.Tags.defaultNames[tag] or tag
end

local function getTagHelp(info)
	local tag = info[#(info)]
	return ShadowUF.Tags.defaultHelp[tag] or ShadowUF.db.profile.tags[tag] and ShadowUF.db.profile.tags[tag].help
end

-- Module functions
local function hideRestrictedOption(info)
	local unit = type(info.arg) == "number" and info[#(info) - info.arg] or info[2]
	local key = info[#(info)]
	if( ShadowUF.modules[key] and ShadowUF.modules[key].moduleClass and ShadowUF.modules[key].moduleClass ~= playerClass ) then
		return true
	elseif( ( key == "incHeal" and not ShadowUF.modules.incHeal ) or ( key == "incAbsorb" and not ShadowUF.modules.incAbsorb ) or ( key == "healAbsorb" and not ShadowUF.modules.healAbsorb ) )  then
		return true
	-- Non-standard units do not support color by aggro or incoming heal
	elseif( key == "colorAggro" or key == "colorDispel" or key == "incHeal" or key == "incAbsorb" or key == "aggro" ) then
		return string.match(unit, "%w+target" )
	-- Fall back for indicators, no variable table so it shouldn't be shown
	elseif( info[#(info) - 1] == "indicators" ) then
		if( ( unit == "global" and not globalConfig.indicators[key] ) or ( unit ~= "global" and not ShadowUF.db.profile.units[unit].indicators[key] ) ) then
			return true
		end
	-- Fall back, no variable table so it shouldn't be shown
	elseif( ( unit == "global" and not globalConfig[key] ) or ( unit ~= "global" and not ShadowUF.db.profile.units[unit][key] ) ) then
		return true
	end

	return false
end

local function getModuleOrder(info)
	local key = info[#(info)]
	return key == "healthBar" and 1 or key == "powerBar" and 2 or key == "castBar" and 3 or 4
end

-- Expose these for modules
Config.getAnchorParents = getAnchorParents
Config.hideAdvancedOption = hideAdvancedOption
Config.isUnitDisabled = isUnitDisabled
Config.selectDialogGroup = selectDialogGroup
Config.selectTabGroup = selectTabGroup
Config.getName = getName
Config.getUnitOrder = getUnitOrder
Config.isModifiersSet = isModifiersSet
Config.set = set
Config.get = get
Config.setUnit = setUnit
Config.setVariable = setVariable
Config.getUnit = getUnit
Config.getVariable = getVariable
Config.hideRestrictedOption = hideRestrictedOption
Config.hideBasicOption = hideBasicOption


--------------------
-- GENERAL CONFIGURATION
---------------------

local function writeTable(tbl)
	local data = ""
	for key, value in pairs(tbl) do
		local valueType = type(value)

		-- Wrap the key in brackets if it's a number
		if( type(key) == "number" ) then
			key = string.format("[%s]", key)
		-- Wrap the string with quotes if it has a space in it
		elseif( string.match(key, "[%p%s%c]") or string.match(key, "^[0-9]+$") ) then
			key = string.format("['%s']", string.gsub(key, "'", "\\'"))
		end

		-- foo = {bar = 5}
		if( valueType == "table" ) then
			data = string.format("%s%s=%s;", data, key, writeTable(value))
		-- foo = true / foo = 5
		elseif( valueType == "number" or valueType == "boolean" ) then
			data = string.format("%s%s=%s;", data, key, tostring(value))
		-- foo = "bar"
		else
			value = tostring(value)
			if value and string.match(value, "[\n]") then
				local token = ""
				while string.find(value, "%["..token.."%[") or string.find(value, "%]"..token.."%]") do
					token = token .. "="
				end
				value = string.format("[%s[%s]%s]", token, value, token)
			else
				value = string.format("%q", value)
			end
			data = string.format("%s%s=%s;", data, key, value)
		end
	end

	return "{" .. data .. "}"
end

local function loadGeneralOptions()
	SML = SML or LibStub:GetLibrary("LibSharedMedia-3.0")

	local MediaList = {}
	local function getMediaData(info)
		local mediaType = info[#(info)]

		MediaList[mediaType] = MediaList[mediaType] or {}

		for k in pairs(MediaList[mediaType]) do	MediaList[mediaType][k] = nil end
		for _, name in pairs(SML:List(mediaType)) do
			MediaList[mediaType][name] = name
		end

		return MediaList[mediaType]
	end


	local barModules = {}
	for	key, module in pairs(ShadowUF.modules) do
		if( module.moduleHasBar ) then
			barModules["$" .. key] = module.moduleName
		end
	end

	local addTextParent = {
		order = 4,
		type = "group",
		inline = true,
		name = function(info) return barModules[info[#(info)]] or string.sub(info[#(info)], 2) end,
		hidden = function(info)
			for _, text in pairs(ShadowUF.db.profile.units.player.text) do
				if( text.anchorTo == info[#(info)] ) then
					return false
				end
			end

			return true
		end,
		args = {},
	}

	local addTextLabel = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) end,
		type = "description",
		width = "",
		fontSize = "medium",
		hidden = function(info)
			local id = tonumber(string.match(info[#(info)], "(%d+)"))
			if( not getVariable("player", "text", nil, id) ) then return true end
			return getVariable("player", "text", id, "anchorTo") ~= info[#(info) - 1]
		end,
		name = function(info)
			return getVariable("player", "text", tonumber(string.match(info[#(info)], "(%d+)")), "name")
		end,
	}

	local addTextSep = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) + 0.75 end,
		type = "description",
		width = "full",
		hidden = function(info)
			local id = tonumber(string.match(info[#(info)], "(%d+)"))
			if( not getVariable("player", "text", nil, id) ) then return true end
			return getVariable("player", "text", id, "anchorTo") ~= info[#(info) - 1]
		end,
		name = "",
	}

	local addText = {
		order = function(info) return info[#(info)] + 0.5 end,
		type = "execute",
		width = "half",
		name = L["Delete"],
		hidden = function(info)
			local id = tonumber(info[#(info)])
			if( not getVariable("player", "text", nil, id) ) then return true end
			return getVariable("player", "text", id, "anchorTo") ~= info[#(info) - 1]
		end,
		disabled = function(info)
			local id = tonumber(info[#(info)])
			for _, unit in pairs(ShadowUF.unitList) do
				if( ShadowUF.db.profile.units[unit].text[id] and ShadowUF.db.profile.units[unit].text[id].default ) then
					return true
				end
			end

			return false
		end,
		confirmText = L["Are you sure you want to delete this text? All settings for it will be deleted."],
		confirm = true,
		func = function(info)
			local id = tonumber(info[#(info)])
			for _, unit in pairs(ShadowUF.unitList) do
				table.remove(ShadowUF.db.profile.units[unit].text, id)
			end

			addTextParent.args[info[#(info)]] = nil
			ShadowUF.Layout:Reload()
		end,
	}

	local function validateSpell(info, spell)
		if( spell and spell ~= "" and not GetSpellInfo(spell) ) then
			return string.format(L["Invalid spell \"%s\" entered."], spell or "")
		end

		return true
	end

	local function setRange(info, spell)
		ShadowUF.db.profile.range[info[#(info)] .. playerClass] = spell and spell ~= "" and spell or nil
		ShadowUF.Layout:Reload()
	end

	local function getRange(info)
		return ShadowUF.db.profile.range[info[#(info)] .. playerClass]
	end

	local function rangeWithIcon(info)
		local name = getRange(info)
		local text = L["Spell Name"]
		if( string.match(info[#(info)], "Alt") ) then
			text = L["Alternate Spell Name"]
		end

		local icon = select(3, GetSpellInfo(name))
		if( not icon ) then
			icon = "Interface\\Icons\\Inv_misc_questionmark"
		end

		return "|T" .. icon .. ":18:18:0:0|t " .. text
	end

	local textData = {}

	local layoutData = {positions = true, visibility = true, modules = false}
	local layoutManager = {
		type = "group",
		order = 7,
		name = L["Layout manager"],
		childGroups = "tab",
		hidden = hideAdvancedOption,
		args = {
			import = {
				order = 1,
				type = "group",
				name = L["Import"],
				hidden = false,
				args = {
					help = {
						order = 1,
						type = "group",
						inline = true,
						name = function(info) return layoutData.error and L["Error"] or L["Help"] end,
						args = {
							help = {
								order = 1,
								type = "description",
								name = function(info)
									if( ShadowUF.db:GetCurrentProfile() == "Import Backup" ) then
										return L["Your active layout is the profile used for import backup, this cannot be overwritten by an import. Change your profiles to something else and try again."]
									end

									return layoutData.error or L["You can import another Shadowed Unit Frame users configuration by entering the export code they gave you below. This will backup your old layout to \"Import Backup\".|n|nIt will take 30-60 seconds for it to load your layout when you paste it in, please by patient."]
								end
							},
						},
					},
					positions = {
						order = 2,
						type = "toggle",
						name = L["Import unit frame positions"],
						set = function(info, value) layoutData[info[#(info)]] = value end,
						get = function(info) return layoutData[info[#(info)]] end,
						width = "double",
					},
					visibility = {
						order = 3,
						type = "toggle",
						name = L["Import visibility settings"],
						set = function(info, value) layoutData[info[#(info)]] = value end,
						get = function(info) return layoutData[info[#(info)]] end,
						width = "double",
					},
					import = {
						order = 5,
						type = "input",
						name = L["Code"],
						multiline = true,
						width = "full",
						get = false,
						disabled = function() return ShadowUF.db:GetCurrentProfile() == "Import Backup" end,
						set = function(info, import)
							local layout, err = loadstring(string.format([[return %s]], import))
							if( err ) then
								layoutData.error = string.format(L["Failed to import layout, error:|n|n%s"], err)
								return
							end

							layout = layout()

							-- Strip position settings
							if( not layoutData.positions ) then
								layout.positions = nil
							end

							-- Strip visibility settings
							if( not layoutData.visibility ) then
								layout.visibility = nil
							end

							-- Strip any units we don't have included by default
							for unit in pairs(layout.units) do
								if( not ShadowUF.defaults.profile.units[unit] ) then
									layout.units[unit] = nil
								end
							end

							-- Check if we need move over the visibility and positions info
							layout.positions = layout.positions or CopyTable(ShadowUF.db.profile.positions)
							layout.visibility = layout.visibility or CopyTable(ShadowUF.db.profile.positions)

							-- Now backup the profile
							local currentLayout = ShadowUF.db:GetCurrentProfile()
							ShadowUF.layoutImporting = true
							ShadowUF.db:SetProfile("Import Backup")
							ShadowUF.db:CopyProfile(currentLayout)
							ShadowUF.db:SetProfile(currentLayout)
							ShadowUF.db:ResetProfile()
							ShadowUF.layoutImporting = nil

							-- Overwrite everything we did import
							ShadowUF:LoadDefaultLayout()
							for key, data in pairs(layout) do
								if( type(data) == "table" ) then
									ShadowUF.db.profile[key] = CopyTable(data)
								else
									ShadowUF.db.profile[key] = data
								end
							end

							ShadowUF:ProfilesChanged()
						end,
					},
				},
			},
			export = {
				order = 2,
				type = "group",
				name = L["Export"],
				hidden = false,
				args = {
					help = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								order = 1,
								type = "description",
								name = L["After you hit export, you can give the below code to other Shadowed Unit Frames users and they will get your exact layout."],
							},
						},
					},
					doExport = {
						order = 2,
						type = "execute",
						name = L["Export"],
						func = function(info)
							layoutData.export = writeTable(ShadowUF.db.profile)
						end,
					},
					export = {
						order = 3,
						type = "input",
						name = L["Code"],
						multiline = true,
						width = "full",
						set = false,
						get = function(info) return layoutData[info[#(info)]] end,
					},
				},
			},
		},
	}

	options.args.general = {
		type = "group",
		childGroups = "tab",
		name = L["General"],
		args = {
			general = {
				type = "group",
				order = 1,
				name = L["General"],
				set = set,
				get = get,
				args = {
					general = {
						order = 1,
						type = "group",
						inline = true,
						name = L["General"],
						args = {
							locked = {
								order = 1,
								type = "toggle",
								name = L["Lock frames"],
								desc = L["Enables configuration mode, letting you move and giving you example frames to setup."],
								set = function(info, value)
									set(info, value)
									ShadowUF.modules.movers:Update()
								end,
								arg = "locked",
							},
							advanced = {
								order = 1.5,
								type = "toggle",
								name = L["Advanced"],
								desc = L["Enabling advanced settings will give you access to more configuration options. This is meant for people who want to tweak every single thing, and should not be enabled by default as it increases the options."],
								arg = "advanced",
							},
							sep = {
								order = 2,
								type = "description",
								name = "",
								width = "full",
							},
							omnicc = {
								order = 2.5,
								type = "toggle",
								name = L["Disable OmniCC Cooldown Count"],
								desc = L["Disables showing Cooldown Count timers in all Shadowed Unit Frame auras."],
								arg = "omnicc",
								width = "double",
							},
							blizzardcc = {
								order = 2.5,
								type = "toggle",
								name = L["Disable Blizzard Cooldown Count"],
								desc = L["Disables showing Cooldown Count timers in all Shadowed Unit Frame auras."],
								arg = "blizzardcc",
								width = "double",
							},
							hideCombat = {
								order = 3,
								type = "toggle",
								name = L["Hide tooltips in combat"],
								desc = L["Prevents unit tooltips from showing while in combat."],
								arg = "tooltipCombat",
								width = "double",
							},
							sep2 = {
								order = 3.5,
								type = "description",
								name = "",
								width = "full",
							},
							auraBorder = {
								order = 5,
								type = "select",
								name = L["Aura border style"],
								desc = L["Style of borders to show for all auras."],
								values = {["dark"] = L["Dark"], ["light"] = L["Light"], ["blizzard"] = L["Blizzard"], [""] = L["None"]},
								arg = "auras.borderType",
							},
							statusbar = {
								order = 6,
								type = "select",
								name = L["Bar texture"],
								dialogControl = "LSM30_Statusbar",
								values = getMediaData,
								arg = "bars.texture",
							},
							spacing = {
								order = 7,
								type = "range",
								name = L["Bar spacing"],
								desc = L["How much spacing should be provided between all of the bars inside a unit frame, negative values move them farther apart, positive values bring them closer together. 0 for no spacing."],
								min = -10, max = 10, step = 0.05, softMin = -5, softMax = 5,
								arg = "bars.spacing",
								hidden = hideAdvancedOption,
							},
						},
					},
					backdrop = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Background/border"],
						args = {
							backgroundColor = {
								order = 1,
								type = "color",
								name = L["Background color"],
								hasAlpha = true,
								set = setColor,
								get = getColor,
								arg = "backdrop.backgroundColor",
							},
							borderColor = {
								order = 2,
								type = "color",
								name = L["Border color"],
								hasAlpha = true,
								set = setColor,
								get = getColor,
								arg = "backdrop.borderColor",
							},
							sep = {
								order = 3,
								type = "description",
								name = "",
								width = "full",
							},
							background = {
								order = 4,
								type = "select",
								name = L["Background"],
								dialogControl = "LSM30_Background",
								values = getMediaData,
								arg = "backdrop.backgroundTexture",
							},
							border = {
								order = 5,
								type = "select",
								name = L["Border"],
								dialogControl = "LSM30_Border",
								values = getMediaData,
								arg = "backdrop.borderTexture",
							},
							inset = {
								order = 5.5,
								type = "range",
								name = L["Inset"],
								desc = L["How far the background should be from the unit frame border."],
								min = -10, max = 10, step = 1,
								hidden = hideAdvancedOption,
								arg = "backdrop.inset",
							},
							sep2 = {
								order = 6,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							edgeSize = {
								order = 7,
								type = "range",
								name = L["Edge size"],
								desc = L["How large the edges should be."],
								hidden = hideAdvancedOption,
								min = 0, max = 20, step = 1,
								arg = "backdrop.edgeSize",
							},
							tileSize = {
								order = 8,
								type = "range",
								name = L["Tile size"],
								desc = L["How large the background should tile"],
								hidden = hideAdvancedOption,
								min = 0, max = 20, step = 1,
								arg = "backdrop.tileSize",
							},
							clip = {
								order = 9,
								type = "range",
								name = L["Clip"],
								desc = L["How close the frame should clip with the border."],
								hidden = hideAdvancedOption,
								min = 0, max = 20, step = 1,
								arg = "backdrop.clip",
							},
						},
					},
					font = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Font"],
						args = {
							color = {
								order = 1,
								type = "color",
								name = L["Default color"],
								desc = L["Default font color, any color tags inside individual tag texts will override this."],
								hasAlpha = true,
								set = setColor,
								get = getColor,
								arg = "font.color",
								hidden = hideAdvancedOption,
							},
							sep = {order = 1.25, type = "description", name = "", hidden = hideAdvancedOption},
							font = {
								order = 1.5,
								type = "select",
								name = L["Font"],
								dialogControl = "LSM30_Font",
								values = getMediaData,
								arg = "font.name",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 1, max = 50, step = 1, softMin = 1, softMax = 20,
								arg = "font.size",
							},
							outline = {
								order = 3,
								type = "select",
								name = L["Outline"],
								values = {["OUTLINE"] = L["Thin outline"], ["THICKOUTLINE"] = L["Thick outline"], ["MONOCHROMEOUTLINE"] = L["Monochrome Outline"], [""] = L["None"]},
								arg = "font.extra",
								hidden = hideAdvancedOption,
							},
						},
					},
					bar = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Bars"],
						hidden = hideAdvancedOption,
						args = {
							override = {
								order = 0,
								type = "toggle",
								name = L["Override color"],
								desc = L["Forces a static color to be used for the background of all bars"],
								set = function(info, value)
									if( value and not ShadowUF.db.profile.bars.backgroundColor ) then
										ShadowUF.db.profile.bars.backgroundColor = {r = 0, g = 0, b = 0}
									elseif( not value ) then
										ShadowUF.db.profile.bars.backgroundColor = nil
									end

									ShadowUF.Layout:Reload()
								end,
								get = function(info)
									return ShadowUF.db.profile.bars.backgroundColor and true or false
								end,
							},
							color = {
								order = 1,
								type = "color",
								name = L["Background color"],
								desc = L["This will override all background colorings for bars including custom set ones."],
								set = setColor,
								get = function(info)
									if( not ShadowUF.db.profile.bars.backgroundColor ) then
										return {r = 0, g = 0, b = 0}
									end

									return getColor(info)
								end,
								disabled = function(info) return not ShadowUF.db.profile.bars.backgroundColor end,
								arg = "bars.backgroundColor",
							},
							sep = { order = 2, type = "description", name = "", width = "full"},
							barAlpha = {
								order = 3,
								type = "range",
								name = L["Bar alpha"],
								desc = L["Alpha to use for bar."],
								arg = "bars.alpha",
								min = 0, max = 1, step = 0.05,
								isPercent = true
							},
							backgroundAlpha = {
								order = 4,
								type = "range",
								name = L["Background alpha"],
								desc = L["Alpha to use for bar backgrounds."],
								arg = "bars.backgroundAlpha",
								min = 0, max = 1, step = 0.05,
								isPercent = true
							},
						},
					},
				},
			},
			color = {
				order = 2,
				type = "group",
				name = L["Colors"],
				args = {
					health = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Health"],
						set = setColor,
						get = getColor,
						args = {
							green = {
								order = 1,
								type = "color",
								name = L["High health"],
								desc = L["Health bar color used as the transitional color for 100% -> 50% on players, as well as when your pet is happy."],
								arg = "healthColors.green",
							},
							yellow = {
								order = 2,
								type = "color",
								name = L["Half health"],
								desc = L["Health bar color used as the transitional color for 100% -> 0% on players, as well as when your pet is mildly unhappy."],
								arg = "healthColors.yellow",
							},
							red = {
								order = 3,
								type = "color",
								name = L["Low health"],
								desc = L["Health bar color used as the transitional color for 50% -> 0% on players, as well as when your pet is very unhappy."],
								arg = "healthColors.red",
							},
							friendly = {
								order = 4,
								type = "color",
								name = L["Friendly"],
								desc = L["Health bar color for friendly units."],
								arg = "healthColors.friendly",
							},
							neutral = {
								order = 5,
								type = "color",
								name = L["Neutral"],
								desc = L["Health bar color for neutral units."],
								arg = "healthColors.neutral",
							},
							hostile = {
								order = 6,
								type = "color",
								name = L["Hostile"],
								desc = L["Health bar color for hostile units."],
								arg = "healthColors.hostile",
							},
							aggro = {
								order = 6.5,
								type = "color",
								name = L["Has Aggro"],
								desc = L["Health bar color for units with aggro."],
								arg = "healthColors.aggro",
							},
							static = {
								order = 7,
								type = "color",
								name = L["Static"],
								desc = L["Color to use for health bars that are set to be colored by a static color."],
								arg = "healthColors.static",
							},
							inc = {
								order = 8,
								type = "color",
								name = L["Incoming heal"],
								desc = L["Bar color to use to show how much healing someone is about to receive."],
								arg = "healthColors.inc",
							},
							incAbsorb = {
								order = 9,
								type = "color",
								name = L["Incoming absorb"],
								desc = L["Color to use to show how much damage will be absorbed."],
								arg = "healthColors.incAbsorb",
							},
							healAbsorb = {
								order = 10,
								type = "color",
								name = L["Heal absorb"],
								desc = L["Color to use to show how much healing will e absorbed."],
								arg = "healthColors.healAbsorb",
							},
							enemyUnattack = {
								order = 11,
								type = "color",
								name = L["Unattackable hostile"],
								desc = L["Health bar color to use for hostile units who you cannot attack, used for reaction coloring."],
								hidden = hideAdvancedOption,
								arg = "healthColors.enemyUnattack",
							}
						},
					},
					stagger = {
						order = 1.5,
						type = "group",
						inline = true,
						name = L["Stagger"],
						set = setColor,
						get = getColor,
						hidden = function() return select(2, UnitClass("player")) ~= "MONK" end,
						args = {
							STAGGER_GREEN = {
								order = 0,
								type = "color",
								name = L["Green (<30% HP)"],
								desc = L["Stagger bar color when the staggered amount is <30% of your HP."],
								arg = "powerColors.STAGGER_GREEN"
							},
							STAGGER_YELLOW = {
								order = 1,
								type = "color",
								name = L["Yellow (>30% HP)"],
								desc = L["Stagger bar color when the staggered amount is >30% of your HP."],
								arg = "powerColors.STAGGER_YELLOW"
							},
							STAGGER_RED = {
								order = 2,
								type = "color",
								name = L["Red (>70% HP)"],
								desc = L["Stagger bar color when the staggered amount is >70% of your HP."],
								arg = "powerColors.STAGGER_RED"
							}
						}
					},
					power = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Power"],
						set = setColor,
						get = getColor,
						args = {
							MANA = {
								order = 0,
								type = "color",
								name = L["Mana"],
								width = "half",
								arg = "powerColors.MANA",
							},
							RAGE = {
								order = 1,
								type = "color",
								name = L["Rage"],
								width = "half",
								arg = "powerColors.RAGE",
							},
							FOCUS = {
								order = 2,
								type = "color",
								name = L["Focus"],
								arg = "powerColors.FOCUS",
								width = "half",
							},
							ENERGY = {
								order = 3,
								type = "color",
								name = L["Energy"],
								arg = "powerColors.ENERGY",
								width = "half",
							},
							RUNIC_POWER = {
								order = 6,
								type = "color",
								name = L["Runic Power"],
								arg = "powerColors.RUNIC_POWER",
							},
							RUNES = {
								order = 7,
								type = "color",
								name = L["Runes"],
								arg = "powerColors.RUNES",
								hidden = function(info) return select(2, UnitClass("player")) ~= "DEATHKNIGHT" end,
							},
							AMMOSLOT = {
								order = 9,
								type = "color",
								name = L["Ammo"],
								arg = "powerColors.AMMOSLOT",
								hidden = hideAdvancedOption,
							},
							FUEL = {
								order = 10,
								type = "color",
								name = L["Fuel"],
								arg = "powerColors.FUEL",
								hidden = hideAdvancedOption,
							},
							COMBOPOINTS = {
								order = 11,
								type = "color",
								name = L["Combo Points"],
								arg = "powerColors.COMBOPOINTS",
							},
							AURAPOINTS = {
								order = 11.5,
								type = "color",
								name = L["Aura Combo Points"],
								arg = "powerColors.AURAPOINTS",
								hidden = function() return not ShadowUF.modules.auraPoints end
							},
							INSANITY = {
								order = 12,
								type = "color",
								name = L["Insanity"],
								arg = "powerColors.INSANITY",
								hidden = function(info) return select(2, UnitClass("player")) ~= "PRIEST" end,
							},
							MAELSTROM = {
								order = 12,
								type = "color",
								name = L["Maelstrom"],
								arg = "powerColors.MAELSTROM",
								hidden = function(info) return select(2, UnitClass("player")) ~= "SHAMAN" end,
							},
							HOLYPOWER = {
								order = 12,
								type = "color",
								name = L["Holy Power"],
								arg = "powerColors.HOLYPOWER",
								hidden = function(info) return select(2, UnitClass("player")) ~= "PALADIN" end,
							},
							SOULSHARDS = {
								order = 14,
								type = "color",
								name = L["Soul Shards"],
								hasAlpha = true,
								arg = "powerColors.SOULSHARDS",
								hidden = function(info) return select(2, UnitClass("player")) ~= "WARLOCK" end,
							},
							ARCANECHARGES = {
								order = 15,
								type = "color",
								name = L["Arcane Charges"],
								hasAlpha = true,
								arg = "powerColors.ARCANECHARGES",
								hidden = function(info) return select(2, UnitClass("player")) ~= "MAGE" end,
							},
							CHI = {
								order = 17,
								type = "color",
								name = L["Chi"],
								arg = "powerColors.CHI",
								hidden = function(info) return select(2, UnitClass("player")) ~= "MONK" end,
							},
							FURY = {
								order = 17,
								type = "color",
								name = L["Fury"],
								arg = "powerColors.FURY",
								hidden = function(info) return select(2, UnitClass("player")) ~= "DEMONHUNTER" end,
							},
							PAIN = {
								order = 17,
								type = "color",
								name = L["Pain"],
								arg = "powerColors.PAIN",
								hidden = function(info) return select(2, UnitClass("player")) ~= "DEMONHUNTER" end,
							},
							LUNAR_POWER = {
								order = 17,
								type = "color",
								name = L["Astral Power"],
								arg = "powerColors.LUNAR_POWER",
								hidden = function(info) return select(2, UnitClass("player")) ~= "DRUID" end,
							},
							MUSHROOMS = {
								order = 17,
								type = "color",
								name = L["Mushrooms"],
								arg = "powerColors.MUSHROOMS",
								hidden = function(info) return select(2, UnitClass("player")) ~= "DRUID" end,
							},
							STATUE = {
								order = 17,
								type = "color",
								name = L["Statue"],
								arg = "powerColors.STATUE",
								hidden = function(info) return select(2, UnitClass("player")) ~= "MONK" end,
							},
							RUNEOFPOWER = {
								order = 17.5,
								type = "color",
								name = L["Rune of Power"],
								arg = "powerColors.RUNEOFPOWER",
								hidden = function(info) return select(2, UnitClass("player")) ~= "MAGE" end,
							},
							ALTERNATE = {
								order = 19,
								type = "color",
								name = L["Alt. Power"],
								desc = L["Alternate power is used for things like quests and dungeons."],
								arg = "powerColors.ALTERNATE",
							},
						},
					},
					cast = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Cast"],
						set = setColor,
						get = getColor,
						args = {
							cast = {
								order = 0,
								type = "color",
								name = L["Casting"],
								desc = L["Color used when an unit is casting a spell."],
								arg = "castColors.cast",
							},
							channel = {
								order = 1,
								type = "color",
								name = L["Channelling"],
								desc = L["Color used when a cast is a channel."],
								arg = "castColors.channel",
							},
							sep = {
								order = 2,
								type = "description",
								name = "",
								hidden = hideAdvancedOption,
								width = "full",
							},
							finished = {
								order = 3,
								type = "color",
								name = L["Finished cast"],
								desc = L["Color used when a cast is successfully finished."],
								hidden = hideAdvancedOption,
								arg = "castColors.finished",
							},
							interrupted = {
								order = 4,
								type = "color",
								name = L["Cast interrupted"],
								desc = L["Color used when a cast is interrupted either by the caster themselves or by another unit."],
								hidden = hideAdvancedOption,
								arg = "castColors.interrupted",
							},
							uninterruptible = {
								order = 5,
								type = "color",
								name = L["Cast uninterruptible"],
								desc = L["Color used when a cast cannot be interrupted, this is only used for PvE mobs."],
								arg = "castColors.uninterruptible",
							},
						},
					},
					auras = {
						order = 3.5,
						type = "group",
						inline = true,
						name = L["Aura borders"],
						set = setColor,
						get = getColor,
						hidden = hideAdvancedOption,
						args = {
							removableColor = {
								order = 0,
								type = "color",
								name = L["Stealable/Curable/Dispellable"],
								desc = L["Border coloring of stealable, curable and dispellable auras."],
								arg = "auraColors.removable",
								width = "double"
							}
						}
					},
					classColors = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Classes"],
						set = setColor,
						get = getColor,
						args = {}
					},
				},
			},
			range = {
				order = 5,
				type = "group",
				name = L["Range Checker"],
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["This will be set for your current class only.\nIf no custom spells are set, defaults appropriate for your class will be used."],
							},
						},
					},
					friendly = {
						order = 1,
						inline = true,
						type = "group",
						name = L["On Friendly Units"],
						args = {
							friendly = {
								order = 1,
								type = "input",
								name = rangeWithIcon,
								desc = L["Name of a friendly spell to check range."],
								validate = validateSpell,
								set = setRange,
								get = getRange,
							},
							spacer = {
								order = 2,
								type = "description",
								width = "normal",
								name = ""
							},
							friendlyAlt = {
								order = 3,
								type = "input",
								name = rangeWithIcon,
								desc = L["Alternatively friendly spell to use to check range."],
								hidden = hideAdvancedOption,
								validate = validateSpell,
								set = setRange,
								get = getRange,
							},
						}
					},
					hostile = {
						order = 2,
						inline = true,
						type = "group",
						name = L["On Hostile Units"],
						args = {
							hostile = {
								order = 1,
								type = "input",
								name = rangeWithIcon,
								desc = L["Name of a friendly spell to check range."],
								validate = validateSpell,
								set = setRange,
								get = getRange,
							},
							spacer = {
								order = 2,
								type = "description",
								width = "normal",
								name = ""
							},
							hostileAlt = {
								order = 3,
								type = "input",
								name = rangeWithIcon,
								desc = L["Alternatively friendly spell to use to check range."],
								hidden = hideAdvancedOption,
								validate = validateSpell,
								set = setRange,
								get = getRange,
							},
						}
					},
				},
			},
			text = {
				type = "group",
				order = 6,
				name = L["Text Management"],
				hidden = false,
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can add additional text with tags enabled using this configuration, note that any additional text added (or removed) effects all units, removing text will reset their settings as well.|n|nKeep in mind, you cannot delete the default text included with the units."],
							},
						},
					},
					add = {
						order = 1,
						name = L["Add new text"],
						inline = true,
						type = "group",
						set = function(info, value) textData[info[#(info)] ] = value end,
						get = function(info, value) return textData[info[#(info)] ] end,
						args = {
							name = {
								order = 0,
								type = "input",
								name = L["Text name"],
								desc = L["Text name that you can use to identify this text from others when configuring."],
							},
							parent = {
								order = 1,
								type = "select",
								name = L["Text parent"],
								desc = L["Where inside the frame the text should be anchored to."],
								values = barModules,
							},
							add = {
								order = 2,
								type = "execute",
								name = L["Add"],
								disabled = function() return not textData.name or textData.name == "" or not textData.parent end,
								func = function(info)
									-- Verify we entered a good name
									textData.name = string.trim(textData.name)
									textData.name = textData.name ~= "" and textData.name or nil

									-- Add the new entry
									for _, unit in pairs(ShadowUF.unitList) do
										table.insert(ShadowUF.db.profile.units[unit].text, {enabled = true, name = textData.name or "??", text = "", anchorTo = textData.parent, x = 0, y = 0, anchorPoint = "C", size = 0, width = 0.50})
									end

									-- Add it to the GUI
									local id = tostring(#(ShadowUF.db.profile.units.player.text))
									addTextParent.args[id .. ":label"] = addTextLabel
									addTextParent.args[id] = addText
									addTextParent.args[id .. ":sep"] = addTextSep
									options.args.general.args.text.args[textData.parent] = options.args.general.args.text.args[textData.parent] or addTextParent

									local parent = string.sub(textData.parent, 2)
									Config.tagWizard[parent] = Config.tagWizard[parent] or Config.parentTable
									Config.tagWizard[parent].args[id] = Config.tagTextTable
									Config.tagWizard[parent].args[id .. ":adv"] = Config.advanceTextTable

									quickIDMap[id .. ":adv"] = #(ShadowUF.db.profile.units.player.text)

									-- Reset
									textData.name = nil
									textData.parent = nil

								end,
							},
						},
					},
				},
			},
			layout = layoutManager,
		},
	}

	-- Load text
	for id, text in pairs(ShadowUF.db.profile.units.player.text) do
		if( text.anchorTo ~= "" and not text.default ) then
			addTextParent.args[id .. ":label"] = addTextLabel
			addTextParent.args[tostring(id)] = addText
			addTextParent.args[id .. ":sep"] = addTextSep
			options.args.general.args.text.args[text.anchorTo] = addTextParent
		end
	end


	Config.classTable = {
		order = 0,
		type = "color",
		name = getName,
		hasAlpha = true,
		width = "half",
		arg = "classColors.$key",
	}

	for classToken in pairs(RAID_CLASS_COLORS) do
		options.args.general.args.color.args.classColors.args[classToken] = Config.classTable
	end

	options.args.general.args.color.args.classColors.args.PET = Config.classTable
	options.args.general.args.color.args.classColors.args.VEHICLE = Config.classTable
end

---------------------
-- HIDE BLIZZARD FRAMES CONFIGURATION
---------------------
local function loadHideOptions()
	Config.hideTable = {
		order = function(info) return info[#(info)] == "buffs" and 1 or 2 end,
		type = "toggle",
		name = function(info)
			local key = info[#(info)]
			if( key == "arena" ) then return string.format(L["Hide %s frames"], "arena/battleground") end
			return L.units[key] and string.format(L["Hide %s frames"], string.lower(L.units[key])) or string.format(L["Hide %s"], key == "cast" and L["player cast bar"] or key == "playerPower" and L["player power frames"] or key == "buffs" and L["buff frames"] or key == "playerAltPower" and L["player alt. power"])
		end,
		set = function(info, value)
			set(info, value)
			if( value ) then ShadowUF:HideBlizzardFrames() end
		end,
		hidden = false,
		get = get,
		arg = "hidden.$key",
	}

	options.args.hideBlizzard = {
		type = "group",
		name = L["Hide Blizzard"],
		desc = getPageDescription,
		args = {
			help = {
				order = 0,
				type = "group",
				name = L["Help"],
				inline = true,
				args = {
					description = {
						type = "description",
						name = L["You will need to do a /console reloadui before a hidden frame becomes visible again.|nPlayer and other unit frames are automatically hidden depending on if you enable the unit in Shadowed Unit Frames."],
						width = "full",
					},
				},
			},
			hide = {
				order = 1,
				type = "group",
				name = L["Frames"],
				inline = true,
				args = {
					buffs = Config.hideTable,
					cast = Config.hideTable,
					playerPower = Config.hideTable,
					party = Config.hideTable,
                    raid = Config.hideTable,
					player = Config.hideTable,
					pet = Config.hideTable,
					target = Config.hideTable,
					focus = Config.hideTable,
					boss = Config.hideTable,
					arena = Config.hideTable,
					playerAltPower = Config.hideTable,
				},
			},
		}
	}
end

---------------------
-- UNIT CONFIGURATION
---------------------
local function loadUnitOptions()
	-- This makes sure  we don't end up with any messed up positioning due to two different anchors being used
	local function fixPositions(info)
		local unit = info[2]
		local key = info[#(info)]

		if( key == "point" or key == "relativePoint" ) then
			ShadowUF.db.profile.positions[unit].anchorPoint = ""
			ShadowUF.db.profile.positions[unit].movedAnchor = nil
		elseif( key == "anchorPoint" ) then
			ShadowUF.db.profile.positions[unit].point = ""
			ShadowUF.db.profile.positions[unit].relativePoint = ""
		end

		-- Reset offset if it was a manually positioned frame, and it got anchored
		-- Why 100/-100 you ask? Because anything else requires some sort of logic applied to it
		-- and this means the frames won't directly overlap too which is a nice bonus
		if( key == "anchorTo" ) then
			ShadowUF.db.profile.positions[unit].x = 100
			ShadowUF.db.profile.positions[unit].y = -100
		end
	end

	-- Hide raid option in party config
	local function hideRaidOrAdvancedOption(info)
		if( info[2] == "party" and ShadowUF.db.profile.advanced ) then return false end

		return info[2] ~= "raid" and info[2] ~= "raidpet" and info[2] ~= "maintank" and info[2] ~= "mainassist"
	end

	local function hideRaidOption(info)
		return info[2] ~= "raid" and info[2] ~= "raidpet" and info[2] ~= "maintank" and info[2] ~= "mainassist"
	end

	local function hideSplitOrRaidOption(info)
		if( info[2] == "raid" and ShadowUF.db.profile.units.raid.frameSplit ) then
			return true
		end

		return hideRaidOption(info)
	end

	-- Not every option should be changed via global settings
	local function hideSpecialOptions(info)
		local unit = info[2]
		if( unit == "global" or unit == "partypet" ) then
			return true
		end

		return hideAdvancedOption(info)
	end

	local function checkNumber(info, value)
		return tonumber(value)
	end

	local function setPosition(info, value)
		ShadowUF.db.profile.positions[info[2]][info[#(info)]] = value
		fixPositions(info)

		if( info[2] == "raid" or info[2] == "raidpet" or info[2] == "maintank" or info[2] == "mainassist" or info[2] == "party" or info[2] == "boss" or info[2] == "arena" ) then
			ShadowUF.Units:ReloadHeader(info[2])
		else
			ShadowUF.Layout:Reload(info[2])
		end
	end

	local function getPosition(info)
		return ShadowUF.db.profile.positions[info[2]][info[#(info)]]
	end

	local function setNumber(info, value)
		local unit = info[2]
		local key = info[#(info)]
		local id = unit .. key

		-- Apply effective scaling if it's anchored to UIParent
		if( ShadowUF.db.profile.positions[unit].anchorTo == "UIParent" ) then
			value = value * (ShadowUF.db.profile.units[unit].scale * UIParent:GetScale())
		end

		setPosition(info, tonumber(value))
	end

	local function getString(info)
		local unit = info[2]
		local key = info[#(info)]
		local id = unit .. key
		local coord = getPosition(info)

		-- If the frame is created and it's anchored to UIParent, will return the number modified by scale
		if( ShadowUF.db.profile.positions[unit].anchorTo == "UIParent" ) then
			coord = coord / (ShadowUF.db.profile.units[unit].scale * UIParent:GetScale())
		end

		-- OCD, most definitely.
		-- Pain to check coord == math.floor(coord) because floats are handled oddly with frames and return 0.99999999999435
		return string.gsub(string.format("%.2f", coord), "%.00$", "")
	end


	-- TAG WIZARD
	local tagWizard = {}
	Config.tagWizard = tagWizard
	do
		-- Load tag list
		Config.advanceTextTable = {
			order = 1,
			name = function(info) return getVariable(info[2], "text", quickIDMap[info[#(info)]], "name") end,
			type = "group",
			inline = true,
			hidden = function(info)
				if( not getVariable(info[2], "text", nil, quickIDMap[info[#(info)]]) ) then return true end
				return string.sub(getVariable(info[2], "text", quickIDMap[info[#(info)]], "anchorTo"), 2) ~= info[#(info) - 1]
			end,
			set = function(info, value)
				info.arg = string.format("text.%s.%s", quickIDMap[info[#(info) - 1]], info[#(info)])
				setUnit(info, value)
			end,
			get = function(info)
				info.arg = string.format("text.%s.%s", quickIDMap[info[#(info) - 1]], info[#(info)])
				return getUnit(info)
			end,
			args = {
				anchorPoint = {
					order = 1,
					type = "select",
					name = L["Anchor point"],
					values = {["LC"] = L["Left Center"], ["RT"] = L["Right Top"], ["RB"] = L["Right Bottom"], ["LT"] = L["Left Top"], ["LB"] = L["Left Bottom"], ["RC"] = L["Right Center"],["TRI"] = L["Inside Top Right"], ["TLI"] = L["Inside Top Left"], ["CLI"] = L["Inside Center Left"], ["C"] = L["Inside Center"], ["CRI"] = L["Inside Center Right"], ["TR"] = L["Top Right"], ["TL"] = L["Top Left"], ["BR"] = L["Bottom Right"], ["BL"] = L["Bottom Left"]},
					hidden = hideAdvancedOption,
				},
				sep = {
					order = 2,
					type = "description",
					name = "",
					width = "full",
					hidden = hideAdvancedOption,
				},
				width = {
					order = 3,
					name = L["Width weight"],
					desc = L["How much weight this should use when figuring out the total text width."],
					type = "range",
					min = 0, max = 10, step = 0.1,
					hidden = function(info)
						return hideAdvancedOption(info) or getVariable(info[2], "text", quickIDMap[info[#(info) - 1]], "block")
					end,
				},
				size = {
					order = 4,
					name = L["Size"],
					desc = L["Let's you modify the base font size to either make it larger or smaller."],
					type = "range",
					min = -20, max = 20, step = 1, softMin = -5, softMax = 5,
					hidden = false,
				},
				sep2 = {
					order = 4.5,
					type = "description",
					name = "",
					width = "full",
					hidden = function(info)
						return hideAdvancedOption(info) or not getVariable(info[2], "text", quickIDMap[info[#(info) - 1]], "block")
					end
				},
				x = {
					order = 5,
					type = "range",
					name = L["X Offset"],
					min = -1000, max = 1000, step = 1, softMin = -100, softMax = 100,
					hidden = false,
				},
				y = {
					order = 6,
					type = "range",
					name = L["Y Offset"],
					min = -1000, max = 1000, step = 1, softMin = -100, softMax = 100,
					hidden = false,
				},
			},
		}

		Config.parentTable = {
			order = 0,
			type = "group",
			name = function(info) return getName(info) or string.sub(info[#(info)], 1) end,
			hidden = function(info) return not getVariable(info[2], info[#(info)], nil, "enabled") end,
			args = {}
		}

		local function hideBlacklistedTag(info)
			local unit = info[2]
			local id = tonumber(info[#(info) - 2])
			local tag = info[#(info)]
			local cat = info[#(info) - 1]

			if( unit == "global" ) then
				for modUnit in pairs(modifyUnits) do
					if( ShadowUF.Tags.unitRestrictions[tag] == modUnit ) then
						return false
					end
				end
			end

			if( ShadowUF.Tags.unitRestrictions[tag] and ShadowUF.Tags.unitRestrictions[tag] ~= unit ) then
				return true

			elseif( ShadowUF.Tags.anchorRestriction[tag] ) then
				if( ShadowUF.Tags.anchorRestriction[tag] ~= getVariable(unit, "text", id, "anchorTo") ) then
					return true
				else
					return false
				end
			end

			return false
		end

		local function hideBlacklistedGroup(info)
			local unit = info[2]
			local id = tonumber(info[#(info) - 1])
			local tagGroup = info[#(info)]

			if( unit ~= "global" ) then
				if( ShadowUF.Tags.unitBlacklist[tagGroup] and string.match(unit, ShadowUF.Tags.unitBlacklist[tagGroup]) ) then
					return true
				end
			else
				-- If the only units that are in the global configuration have the tag filtered, then don't bother showing it
				for modUnit in pairs(modifyUnits) do
					if( not ShadowUF.Tags.unitBlacklist[tagGroup] or not string.match(modUnit, ShadowUF.Tags.unitBlacklist[tagGroup]) ) then
						return false
					end
				end
			end

			local block = getVariable(unit, "text", id, "block")
			if( ( block and tagGroup ~= "classtimer" ) or ( not block and tagGroup == "classtimer" ) ) then
				return true
			end

			return false
		end

		local savedTagTexts = {}
		local function selectTag(info, value)
			local unit = info[2]
			local id = tonumber(info[#(info) - 2])
			local tag = info[#(info)]
			local text = getVariable(unit, "text", id, "text")
			local savedText

			if( value ) then
				if( unit == "global" ) then
					table.wipe(savedTagTexts)

					-- Set special tag texts based on the unit, so targettarget won't get a tag that will cause errors
					local tagGroup = ShadowUF.Tags.defaultCategories[tag]
					for modUnit in pairs(modifyUnits) do
						savedTagTexts[modUnit] = getVariable(modUnit, "text", id, "text")
						if( not ShadowUF.Tags.unitBlacklist[tagGroup] or not string.match(modUnit, ShadowUF.Tags.unitBlacklist[tagGroup]) ) then
							if( not ShadowUF.Tags.unitRestrictions[tag] or ShadowUF.Tags.unitRestrictions[tag] == modUnit ) then
								if( text == "" ) then
									savedTagTexts[modUnit] = string.format("[%s]", tag)
								else
									savedTagTexts[modUnit] = string.format("%s[( )%s]", savedTagTexts[modUnit], tag)
								end

								savedTagTexts.global = savedTagTexts[modUnit]
							end
						end
					end
				else
					if( text == "" ) then
						text = string.format("[%s]", tag)
					else
						text = string.format("%s[( )%s]", text, tag)
					end
				end

			-- Removing a tag from a single unit, super easy :<
			else
				-- Ugly, but it works
				for matchedTag in string.gmatch(text, "%[(.-)%]") do
					local safeTag = "[" .. matchedTag .. "]"
					if( string.match(safeTag, "%[" .. tag .. "%]") or string.match(safeTag, "%)" .. tag .. "%]") or string.match(safeTag, "%[" .. tag .. "%(") or string.match(safeTag, "%)" .. tag .. "%(") ) then
						text = string.gsub(text, "%[" .. string.gsub(string.gsub(matchedTag, "%)", "%%)"), "%(", "%%(") .. "%]", "")
						text = string.gsub(text, "  ", "")
						text = string.trim(text)
						break
					end
				end
			end

			if( unit == "global" ) then
				for modUnit in pairs(modifyUnits) do
					if( savedTagTexts[modUnit] ) then
						setVariable(modUnit, "text", id, "text", savedTagTexts[modUnit])
					end
				end

				setVariable("global", "text", id, "text", savedTagTexts.global)
			else
				setVariable(unit, "text", id, "text", text)
			end
		end

		local function getTag(info)
			local text = getVariable(info[2], "text", tonumber(info[#(info) - 2]), "text")
			local tag = info[#(info)]

			-- FUN WITH PATTERN MATCHING
			if( string.match(text, "%[" .. tag .. "%]") or string.match(text, "%)" .. tag .. "%]") or string.match(text, "%[" .. tag .. "%(") or string.match(text, "%)" .. tag .. "%(") ) then
				return true
			end

			return false
		end

		Config.tagTextTable = {
			type = "group",
			name = function(info) return getVariable(info[2], "text", nil, tonumber(info[#(info)])) and getVariable(info[2], "text", tonumber(info[#(info)]), "name") or "" end,
			hidden = function(info)
				if( not getVariable(info[2], "text", nil, tonumber(info[#(info)])) ) then return true end
				return string.sub(getVariable(info[2], "text", tonumber(info[#(info)]), "anchorTo"), 2) ~= info[#(info) - 1] end,
			set = false,
			get = false,
			args = {
				text = {
					order = 0,
					type = "input",
					name = L["Text"],
					width = "full",
					hidden = false,
					set = function(info, value) setUnit(info, string.gsub(value, "||", "|")) end,
					get = function(info) return string.gsub(getUnit(info), "|", "||") end,
					arg = "text.$parent.text",
				},
			},
		}


		local function getCategoryOrder(info)
			return info[#(info)] == "health" and 1 or info[#(info)] == "power" and 2 or info[#(info)] == "misc" and 3 or 4
		end

		for _, cat in pairs(ShadowUF.Tags.defaultCategories) do
			Config.tagTextTable.args[cat] = Config.tagTextTable.args[cat] or {
				order = getCategoryOrder,
				type = "group",
				inline = true,
				name = getName,
				hidden = hideBlacklistedGroup,
				set = selectTag,
				get = getTag,
				args = {},
			}
		end

		Config.tagTable = {
			order = 0,
			type = "toggle",
			hidden = hideBlacklistedTag,
			name = getTagName,
			desc = getTagHelp,
		}

		local tagList = {}
		for tag in pairs(ShadowUF.Tags.defaultTags) do
			local category = ShadowUF.Tags.defaultCategories[tag] or "misc"
			Config.tagTextTable.args[category].args[tag] = Config.tagTable
		end

		for tag, data in pairs(ShadowUF.db.profile.tags) do
			local category = data.category or "misc"
			Config.tagTextTable.args[category].args[tag] = Config.tagTable
		end

		local parentList = {}
		for id, text in pairs(ShadowUF.db.profile.units.player.text) do
			parentList[text.anchorTo] = parentList[text.anchorTo] or {}
			parentList[text.anchorTo][id] = text
		end

		local nagityNagNagTable = {
			order = 0,
			type = "group",
			name = L["Help"],
			inline = true,
			hidden = false,
			args = {
				help = {
					order = 0,
					type = "description",
					name = L["Selecting a tag text from the left panel to change tags. Truncating width, sizing, and offsets can be done in the current panel."],
				},
			},
		}

		for parent, list in pairs(parentList) do
			parent = string.sub(parent, 2)
			tagWizard[parent] = Config.parentTable
			Config.parentTable.args.help = nagityNagNagTable

			for id in pairs(list) do
				tagWizard[parent].args[tostring(id)] = Config.tagTextTable
				tagWizard[parent].args[tostring(id) .. ":adv"] = Config.advanceTextTable

				quickIDMap[tostring(id) .. ":adv"] = id
			end
		end
	end

	local function disableAnchoredTo(info)
		local auras = getVariable(info[2], "auras", nil, info[#(info) - 2])

		return auras.anchorOn or not auras.enabled
	end

	local function disableSameAnchor(info)
		local buffs = getVariable(info[2], "auras", nil, "buffs")
		local debuffs = getVariable(info[2], "auras", nil, "debuffs")
		local anchor = buffs.enabled and buffs.prioritize and "buffs" or "debuffs"

		if( not getVariable(info[2], "auras", info[#(info) - 2], "enabled") ) then
			return true
		end

		if( ( info[#(info)] == "x" or info[#(info)] == "y" ) and ( info[#(info) - 2] == "buffs" and buffs.anchorOn or info[#(info) - 2] == "debuffs" and debuffs.anchorOn ) ) then
			return true
		end

		if( anchor == info[#(info) - 2] or buffs.anchorOn or debuffs.anchorOn ) then
			return false
		end

		return buffs.anchorPoint == debuffs.anchorPoint
	end

	local defaultAuraList = {["BL"] = L["Bottom"], ["TL"] = L["Top"], ["LT"] = L["Left"], ["RT"] = L["Right"]}
	local advancedAuraList = {["BL"] = L["Bottom Left"], ["BR"] = L["Bottom Right"], ["TL"] = L["Top Left"], ["TR"] = L["Top Right"], ["RT"] = L["Right Top"], ["RB"] = L["Right Bottom"], ["LT"] = L["Left Top"], ["LB"] = L["Left Bottom"]}
	local function getAuraAnchors()
		return ShadowUF.db.profile.advanced and advancedAuraList or defaultAuraList
	end

	local function hideStealable(info)
		if( not ShadowUF.db.profile.advanced ) then return true end
		if( info[2] == "player" or info[2] == "pet" or info[#(info) - 2] == "debuffs" ) then return true end

		return false
	end

	local function hideBuffOption(info)
		return info[#(info) - 2] ~= "buffs"
	end

	local function hideDebuffOption(info)
		return info[#(info) - 2] ~= "debuffs"
	end

	local function reloadUnitAuras()
		for _, frame in pairs(ShadowUF.Units.unitFrames) do
			if( UnitExists(frame.unit) and frame.visibility.auras ) then
				ShadowUF.modules.auras:UpdateFilter(frame)
				frame:FullUpdate()
			end
		end
	end

	local aurasDisabled = function(info) return not getVariable(info[2], "auras", info[#(info) - 2], "enabled") end

	Config.auraTable = {
		type = "group",
		hidden = false,
		name = function(info) return info[#(info)] == "buffs" and L["Buffs"] or L["Debuffs"] end,
		order = function(info) return info[#(info)] == "buffs" and 1 or 2 end,
		disabled = false,
		args = {
			general = {
				type = "group",
				name = L["General"],
				order = 0,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = function(info) if( info[#(info) - 2] == "buffs" ) then return L["Enable buffs"] end return L["Enable debuffs"] end,
						disabled = false,
						width = "full",
						arg = "auras.$parentparent.enabled",
					},
					temporary = {
						order = 2,
						type = "toggle",
						name = L["Enable temporary enchants"],
						desc = L["Adds temporary enchants to the buffs for the player."],
						width = "full",
						hidden = function(info) return info[2] ~= "player" or info[#(info) - 2] ~= "buffs" end,
						disabled = function(info) return not getVariable(info[2], "auras", "buffs", "enabled") end,
						arg = "auras.buffs.temporary",
					}
				}
			},
			filters = {
				type = "group",
				name = L["Filters"],
				order = 1,
				set = function(info, value)
					getVariable(info[2], "auras", info[#(info) - 2], "show")[info[#(info)]] = value
					reloadUnitAuras()
				end,
				get = function(info)
					return getVariable(info[2], "auras", info[#(info) - 2], "show")[info[#(info)]]
				end,
				args = {
					player = {
						order = 1,
						type = "toggle",
						name = L["Show your auras"],
						desc = L["Whether auras you casted should be shown"],
						width = "full"
					},
					raid = {
						order = 2,
						type = "toggle",
						name = function(info) return info[#(info) - 2] == "buffs" and L["Show castable on other auras"] or L["Show curable/removable auras"] end,
						desc = function(info) return info[#(info) - 2] == "buffs" and L["Whether to show buffs that you cannot cast."] or L["Whether to show any debuffs you can remove, cure or steal."] end,
						width = "full"
					},
					boss = {
						order = 3,
						type = "toggle",
						name = L["Show casted by boss"],
						desc = L["Whether to show any auras casted by the boss"],
						width = "full"
					},
					misc = {
						order = 5,
						type = "toggle",
						name = L["Show any other auras"],
						desc = L["Whether to show auras that do not fall into the above categories."],
						width = "full"
					},
					relevant = {
						order = 6,
						type = "toggle",
						name = L["Smart Friendly/Hostile Filter"],
						desc = L["Only apply the selected filters to buffs on friendly units and debuffs on hostile units, and otherwise show all auras."],
						width = "full"
					},
				}
			},
			display = {
				type = "group",
				name = L["Display"],
				order = 2,
				args = {
					prioritize = {
						order = 1,
						type = "toggle",
						name = L["Prioritize buffs"],
						desc = L["Show buffs before debuffs when sharing the same anchor point."],
						hidden = hideBuffOption,
						disabled = function(info)
							if( not getVariable(info[2], "auras", info[#(info) - 2], "enabled") ) then return true end

							local buffs = getVariable(info[2], "auras", nil, "buffs")
							local debuffs = getVariable(info[2], "auras", nil, "debuffs")

							return buffs.anchorOn or debuffs.anchorOn or buffs.anchorPoint ~= debuffs.anchorPoint
						end,
						arg = "auras.$parentparent.prioritize"
					},
					sep1 = {order = 1.5, type = "description", name = "", width = "full"},
					selfScale = {
						order = 2,
						type = "range",
						name = L["Scaled aura size"],
						desc = L["Scale for auras that you casted or can Spellsteal, any number above 100% is bigger than default, any number below 100% is smaller than default."],
						min = 1, max = 3, step = 0.10,
						isPercent = true,
						hidden = hideAdvancedOption,
						arg = "auras.$parentparent.selfScale",
					},
					sep12 = {order = 2.5, type = "description", name = "", width = "full"},
					timers = {
						order = 3,
						type = "multiselect",
						name = L["Cooldown rings for"],
						desc = L["When to show cooldown rings on auras"],
						hidden = hideAdvancedOption,
						values = function(info)
							local tbl = {["ALL"] = L["All Auras"], ["SELF"] = L["Your Auras"]}
							local type = info[#(info) - 2]
							if( type == "debuffs" ) then
								tbl["BOSS"] = L["Boss Debuffs"]
							end

							return tbl;
						end,
						set = function(info, key, value)
							local tbl = getVariable(info[2], "auras", info[#(info) - 2], "timers")
							if( key == "ALL" and value ) then
								tbl = {["ALL"] = true}
							elseif( key ~= "ALL" and value ) then
								tbl["ALL"] = nil
								tbl[key] = value
							else
								tbl[key] = value
							end

							setVariable(info[2], "auras", info[#(info) - 2], "timers", tbl)
							reloadUnitAuras()
						end,
						get = function(info, key)
							return getVariable(info[2], "auras", info[#(info) - 2], "timers")[key]
						end
					},
					sep3 = {order = 3.5, type = "description", name = "", width = "full"},
					enlarge = {
						order = 4,
						type = "multiselect",
						name = L["Enlarge auras for"],
						desc = L["What type of auras should be enlarged, use the scaled aura size option to change the size."],
						values = function(info)
							local tbl = {["SELF"] = L["Your Auras"]}
							local type = info[#(info) - 2]
							if( type == "debuffs" ) then
								tbl["BOSS"] = L["Boss Debuffs"]
							end

							if( type == "debuffs" ) then
								tbl["REMOVABLE"] = L["Curable"]
							elseif( info[2] ~= "player" and info[2] ~= "pet" and info[2] ~= "party" and info[2] ~= "raid" and type == "buffs" ) then
								tbl["REMOVABLE"] = L["Dispellable/Stealable"]
							end

							return tbl;
						end,
						set = function(info, key, value)
							local tbl = getVariable(info[2], "auras", info[#(info) - 2], "enlarge")
							tbl[key] = value

							setVariable(info[2], "auras", info[#(info) - 2], "enlarge", tbl)
							reloadUnitAuras()
						end,
						get = function(info, key)
							return getVariable(info[2], "auras", info[#(info) - 2], "enlarge")[key]
						end
					}
				}
			},
			positioning = {
				type = "group",
				name = L["Positioning"],
				order = 3,
				args = {
					anchorOn = {
						order = 1,
						type = "toggle",
						name = function(info) return info[#(info) - 2] == "buffs" and L["Anchor to debuffs"] or L["Anchor to buffs"] end,
						desc = L["Allows you to anchor the aura group to another, you can then choose where it will be anchored using the position.|n|nUse this if you want to duplicate the default ui style where buffs and debuffs are separate groups."],
						set = function(info, value)
							setVariable(info[2], "auras", info[#(info) - 2] == "buffs" and "debuffs" or "buffs", "anchorOn", false)
							setUnit(info, value)
						end,
						width = "full",
						arg = "auras.$parentparent.anchorOn",
					},
					anchorPoint = {
						order = 1.5,
						type = "select",
						name = L["Position"],
						desc = L["How you want this aura to be anchored to the unit frame."],
						values = getAuraAnchors,
						disabled = disableAnchoredTo,
						arg = "auras.$parentparent.anchorPoint",
					},
					size = {
						order = 2,
						type = "range",
						name = L["Icon Size"],
						min = 1, max = 30, step = 1,
						arg = "auras.$parentparent.size",
					},
					sep1 = {order = 3, type = "description", name = "", width = "full"},
					perRow = {
						order = 13,
						type = "range",
						name = function(info)
							local anchorPoint = getVariable(info[2], "auras", info[#(info) - 2], "anchorPoint")
							if( ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "LEFT" or ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "RIGHT" ) then
								return L["Per column"]
							end

							return L["Per row"]
						end,
						desc = L["How many auras to show in a single row."],
						min = 1, max = 100, step = 1, softMin = 1, softMax = 50,
						disabled = disableSameAnchor,
						arg = "auras.$parentparent.perRow",
					},
					maxRows = {
						order = 14,
						type = "range",
						name = L["Max rows"],
						desc = L["How many rows total should be used, rows will be however long the per row value is set at."],
						min = 1, max = 10, step = 1, softMin = 1, softMax = 5,
						disabled = disableSameAnchor,
						hidden = function(info)
							local anchorPoint = getVariable(info[2], "auras", info[#(info) - 2], "anchorPoint")
							if( ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "LEFT" or ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "RIGHT" ) then
								return true
							end

							return false
						end,
						arg = "auras.$parentparent.maxRows",
					},
					maxColumns = {
						order = 14,
						type = "range",
						name = L["Max columns"],
						desc = L["How many auras per a column for example, entering two her will create two rows that are filled up to whatever per row is set as."],
						min = 1, max = 100, step = 1, softMin = 1, softMax = 50,
						hidden = function(info)
							local anchorPoint = getVariable(info[2], "auras", info[#(info) - 2], "anchorPoint")
							if( ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "LEFT" or ShadowUF.Layout:GetColumnGrowth(anchorPoint) == "RIGHT" ) then
								return false
							end

							return true
						end,
						disabled = disableSameAnchor,
						arg = "auras.$parentparent.maxRows",
					},
					x = {
						order = 18,
						type = "range",
						name = L["X Offset"],
						min = -1000, max = 1000, step = 1, softMin = -100, softMax = 100,
						disabled = disableSameAnchor,
						hidden = hideAdvancedOption,
						arg = "auras.$parentparent.x",
					},
					y = {
						order = 19,
						type = "range",
						name = L["Y Offset"],
						min = -1000, max = 1000, step = 1, softMin = -100, softMax = 100,
						disabled = disableSameAnchor,
						hidden = hideAdvancedOption,
						arg = "auras.$parentparent.y",
					},

				}
			}
		}
	}

	local function hideBarOption(info)
		local module = info[#(info) - 1]
		if( ShadowUF.modules[module].moduleHasBar or getVariable(info[2], module, nil, "isBar") ) then
			return false
		end

		return true
	end

	local function disableIfCastName(info)
		return not getVariable(info[2], "castBar", "name", "enabled")
	end


	Config.barTable = {
		order = getModuleOrder,
		name = getName,
		type = "group",
		inline = false,
		hidden = function(info) return hideRestrictedOption(info) or not getVariable(info[2], info[#(info)], nil, "enabled") end,
		args = {
			enableBar = {
				order = 1,
				type = "toggle",
				name = L["Show as bar"],
				desc = L["Turns this widget into a bar that can be resized and ordered just like health and power bars."],
				hidden = function(info) return ShadowUF.modules[info[#(info) - 1]].moduleHasBar end,
				arg = "$parent.isBar",
			},
			sep1 = {order = 1.25, type = "description", name = "", hidden = function(info) return (info[#(info) - 1] ~= "burningEmbersBar" or not getVariable(info[2], info[#(info) - 1], nil, "backgroundColor") or not getVariable(info[2], info[#(info) - 1], nil, "background")) end},
			background = {
				order = 1.5,
				type = "toggle",
				name = L["Show background"],
				desc = L["Show a background behind the bars with the same texture/color but faded out."],
				hidden = hideBarOption,
				arg = "$parent.background",
			},
			sep2 = {order = 1.55, type = "description", name = "", hidden = function(info) return not (not ShadowUF.modules[info[#(info) - 1]] or not ShadowUF.db.profile.advanced or ShadowUF.modules[info[#(info) - 1]].isComboPoints) end},
			overrideBackground = {
				order = 1.6,
				type = "toggle",
				name = L["Override background"],
				desc = L["Show a background behind the bars with the same texture/color but faded out."],
				disabled = function(info) return not getVariable(info[2], info[#(info) - 1], nil, "background") end,
				hidden = function(info) return info[#(info) - 1] ~= "burningEmbersBar" end,
				set = function(info, toggle)
					if( toggle ) then
						setVariable(info[2], info[#(info) - 1], nil, "backgroundColor", {r = 0, g = 0, b = 0, a = 0.70})
					else
						setVariable(info[2], info[#(info) - 1], nil, "backgroundColor", nil)
					end
				end,
				get = function(info)
					return not not getVariable(info[2], info[#(info) - 1], nil, "backgroundColor")
				end
			},
			overrideColor = {
				order = 1.65,
				type = "color",
				hasAlpha = true,
				name = L["Background color"],
				hidden = function(info) return info[#(info) - 1] ~= "burningEmbersBar" or not getVariable(info[2], info[#(info) - 1], nil, "backgroundColor") or not getVariable(info[2], info[#(info) - 1], nil, "background") end,
				set = function(info, r, g, b, a)
					local color = getUnit(info) or {}
					color.r = r
					color.g = g
					color.b = b
					color.a = a

					setUnit(info, color)
				end,
				get = function(info)
					local color = getUnit(info)
					if( not color ) then
						return 0, 0, 0, 1
					end

					return color.r, color.g, color.b, color.a

				end,
				arg = "$parent.backgroundColor",
			},
			vertical = {
				order = 1.70,
				type = "toggle",
				name = L["Vertical growth"],
				desc = L["Rather than bars filling from left -> right, they will fill from bottom -> top."],
				arg = "$parent.vertical",
				hidden = function(info) return not ShadowUF.db.profile.advanced or ShadowUF.modules[info[#(info) - 1]].isComboPoints end,
			},
			reverse = {
				order = 1.71,
				type = "toggle",
				name = L["Reverse fill"],
				desc = L["Will fill right -> left when using horizontal growth, or top -> bottom when using vertical growth."],
				arg = "$parent.reverse",
				hidden = function(info) return not ShadowUF.db.profile.advanced or ShadowUF.modules[info[#(info) - 1]].isComboPoints end,
			},
			invert = {
				order = 2,
				type = "toggle",
				name = L["Invert colors"],
				desc = L["Flips coloring so the bar color is shown as the background color and the background as the bar"],
				hidden = function(info) return not ShadowUF.modules[info[#(info) - 1]] or not ShadowUF.db.profile.advanced or ShadowUF.modules[info[#(info) - 1]].isComboPoints end,
				arg = "$parent.invert",
			},
			sep3 = {order = 3, type = "description", name = "", hidden = function(info) return not ShadowUF.modules[info[#(info) - 1]] or not ShadowUF.db.profile.advanced or ShadowUF.modules[info[#(info) - 1]].isComboPoints end,},
			order = {
				order = 4,
				type = "range",
				name = L["Order"],
				min = 0, max = 100, step = 5,
				hidden = hideBarOption,
				arg = "$parent.order",
			},
			height = {
				order = 5,
				type = "range",
				name = L["Height"],
				desc = L["How much of the frames total height this bar should get, this is a weighted value, the higher it is the more it gets."],
				min = 0, max = 10, step = 0.1,
				hidden = hideBarOption,
				arg = "$parent.height",
			}
		},
	}

	Config.indicatorTable = {
		order = 0,
		name = function(info)
			if( info[#(info)] == "status" and info[2] == "player" ) then
				return L["Combat/resting status"]
			end

			return getName(info)
		end,
		desc = function(info) return INDICATOR_DESC[info[#(info)]] end,
		type = "group",
		hidden = hideRestrictedOption,
		args = {
			enabled = {
				order = 0,
				type = "toggle",
				name = L["Enable indicator"],
				hidden = false,
				arg = "indicators.$parent.enabled",
			},
			sep1 = {
				order = 1,
				type = "description",
				name = "",
				width = "full",
				hidden = function() return not ShadowUF.db.profile.advanced end,
			},
			anchorPoint = {
				order = 2,
				type = "select",
				name = L["Anchor point"],
				values = positionList,
				hidden = false,
				arg = "indicators.$parent.anchorPoint",
			},
			size = {
				order = 4,
				type = "range",
				name = L["Size"],
				min = 1, max = 40, step = 1,
				hidden = hideAdvancedOption,
				arg = "indicators.$parent.size",
			},
			x = {
				order = 5,
				type = "range",
				name = L["X Offset"],
				min = -100, max = 100, step = 1, softMin = -50, softMax = 50,
				hidden = false,
				arg = "indicators.$parent.x",
			},
			y = {
				order = 6,
				type = "range",
				name = L["Y Offset"],
				min = -100, max = 100, step = 1, softMin = -50, softMax = 50,
				hidden = false,
				arg = "indicators.$parent.y",
			},
		},
	}

	Config.unitTable = {
		type = "group",
		childGroups = "tab",
		order = getUnitOrder,
		name = getName,
		hidden = isUnitDisabled,
		args = {
			general = {
				order = 1,
				name = L["General"],
				type = "group",
				hidden = isModifiersSet,
				set = setUnit,
				get = getUnit,
				args = {
					vehicle = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Vehicles"],
						hidden = function(info) return info[2] ~= "player" and info[2] ~= "party" or not ShadowUF.db.profile.advanced end,
						args = {
							disable = {
								order = 0,
								type = "toggle",
								name = L["Disable vehicle swap"],
								desc = L["Disables the unit frame from turning into a vehicle when the player enters one."],
								set = function(info, value)
									setUnit(info, value)
									local unit = info[2]
									if( unit == "player" ) then
										if( ShadowUF.Units.unitFrames.pet ) then
											ShadowUF.Units.unitFrames.pet:SetAttribute("disableVehicleSwap", ShadowUF.db.profile.units[unit].disableVehicle)
										end

										if( ShadowUF.Units.unitFrames.player ) then
											ShadowUF.Units:CheckVehicleStatus(ShadowUF.Units.unitFrames.player)
										end
									elseif( unit == "party" ) then
										for frame in pairs(ShadowUF.Units.unitFrames) do
											if( frame.unitType == "partypet" ) then
												frame:SetAttribute("disableVehicleSwap", ShadowUF.db.profile.units[unit].disableVehicle)
											elseif( frame.unitType == "party" ) then
												ShadowUF.Units:CheckVehicleStatus(frame)
											end
										end
									end
								end,
								arg = "disableVehicle",
							},
						},
					},
					portrait = {
						order = 2,
						type = "group",
						inline = true,
						hidden = false,
						name = L["Portrait"],
						args = {
							portrait = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Portrait"]),
								arg = "portrait.enabled",
							},
							portraitType = {
								order = 1,
								type = "select",
								name = L["Portrait type"],
								values = {["class"] = L["Class icon"], ["2D"] = L["2D"], ["3D"] = L["3D"]},
								arg = "portrait.type",
							},
							alignment = {
								order = 2,
								type = "select",
								name = L["Position"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								arg = "portrait.alignment",
							},
						},
					},
					fader = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Combat fader"],
						hidden = hideRestrictedOption,
						args = {
							fader = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Combat fader"]),
								desc = L["Combat fader will fade out all your frames while they are inactive and fade them back in once you are in combat or active."],
								hidden = false,
								arg = "fader.enabled"
							},
							combatAlpha = {
								order = 1,
								type = "range",
								name = L["Combat alpha"],
								desc = L["Frame alpha while this unit is in combat."],
								min = 0, max = 1.0, step = 0.1,
								arg = "fader.combatAlpha",
								hidden = false,
								isPercent = true,
							},
							inactiveAlpha = {
								order = 2,
								type = "range",
								name = L["Inactive alpha"],
								desc = L["Frame alpha when you are out of combat while having no target and 100% mana or energy."],
								min = 0, max = 1.0, step = 0.1,
								arg = "fader.inactiveAlpha",
								hidden = false,
								isPercent = true,
							},
						}
					},
					range = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Range indicator"],
						hidden = hideRestrictedOption,
						args = {
							fader = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Range indicator"]),
								desc = L["Fades out the unit frames of people who are not within range of you."],
								arg = "range.enabled",
								hidden = false,
							},
							inAlpha = {
								order = 1,
								type = "range",
								name = L["In range alpha"],
								desc = L["Frame alpha while this unit is in combat."],
								min = 0, max = 1.0, step = 0.05,
								arg = "range.inAlpha",
								hidden = false,
								isPercent = true,
							},
							oorAlpha = {
								order = 2,
								type = "range",
								name = L["Out of range alpha"],
								min = 0, max = 1.0, step = 0.05,
								arg = "range.oorAlpha",
								hidden = false,
								isPercent = true,
							},
						}
					},
					highlight = {
						order = 3.5,
						type = "group",
						inline = true,
						name = L["Border highlighting"],
						hidden = hideRestrictedOption,
						args = {
							mouseover = {
								order = 3,
								type = "toggle",
								name = L["On mouseover"],
								desc = L["Highlight units when you mouse over them."],
								arg = "highlight.mouseover",
								hidden = false,
							},
							attention = {
								order = 4,
								type = "toggle",
								name = L["For target/focus"],
								desc = L["Highlight units that you are targeting or have focused."],
								arg = "highlight.attention",
								hidden = function(info) return info[2] == "target" or info[2] == "focus" end,
							},
							aggro = {
								order = 5,
								type = "toggle",
								name = L["On aggro"],
								desc = L["Highlight units that have aggro on any mob."],
								arg = "highlight.aggro",
								hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or info[2] == "battlegroundpet" or info[2] == "arenapet" or ShadowUF.fakeUnits[info[2]] end,
							},
							debuff = {
								order = 6,
								type = "toggle",
								name = L["On curable debuff"],
								desc = L["Highlight units that are debuffed with something you can cure."],
								arg = "highlight.debuff",
								hidden = function(info) return info[2] ~= "boss" and ( ShadowUF.Units.zoneUnits[info[2]] or info[2] == "battlegroundpet" or info[2] == "arenapet" ) end,
							},
							raremob = {
								order = 6.10,
								type = "toggle",
								name = L["On rare mobs"],
								desc = L["Highlight units that are rare."],
								arg = "highlight.rareMob",
								hidden = function(info) return not (info[2] == "target" or info[2] == "focus" or info[2] == "targettarget" or info[3] == "focustarget") end,
							},
							elitemob = {
								order = 6.15,
								type = "toggle",
								name = L["On elite mobs"],
								desc = L["Highlight units that are "],
								arg = "highlight.eliteMob",
								hidden = function(info) return not (info[2] == "target" or info[2] == "focus" or info[2] == "targettarget" or info[3] == "focustarget") end,
							},
							sep = {
								order = 6.5,
								type = "description",
								name = "",
								width = "full",
								hidden = function(info) return not (ShadowUF.Units.zoneUnits[info[2]] or info[2] == "battlegroundpet" or info[2] == "arenapet" or ShadowUF.fakeUnits[info[2]]) and not (info[2] == "target" or info[2] == "focus" or info[2] == "targettarget" or info[3] == "focustarget") end,
							},
							alpha = {
								order = 7,
								type = "range",
								name = L["Border alpha"],
								min = 0, max = 1, step = 0.05,
								isPercent = true,
								hidden = false,
								arg = "highlight.alpha",
							},
							size = {
								order = 8,
								type = "range",
								name = L["Border thickness"],
								min = 0, max = 50, step = 1,
								arg = "highlight.size",
								hidden = false,
							},
						},
					},
					-- SOUL SHARDS
					barSouls = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Soul Shards"],
						hidden = function(info) return playerClass ~= "WARLOCK" or not getVariable(info[2], "soulShards", nil, "isBar") or not getVariable(info[2], nil, nil, "soulShards") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Soul Shards"]),
								hidden = false,
								arg = "soulShards.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "soulShards.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "soulShards.showAlways",
							},
						},
					},
					soulShards = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Soul Shards"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "soulShards", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Soul Shards"]),
								hidden = false,
								arg = "soulShards.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "soulShards.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "soulShards.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "soulShards.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "soulShards.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "soulShards.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "soulShards.y",
							},
						},
					},
					-- ARCANE CHARGES
					barArcane = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Arcane Charges"],
						hidden = function(info) return playerClass ~= "MAGE" or not getVariable(info[2], "arcaneCharges", nil, "isBar") or not getVariable(info[2], nil, nil, "arcaneCharges") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Arcane Charges"]),
								hidden = false,
								arg = "arcaneCharges.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "arcaneCharges.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "arcaneCharges.showAlways",
							},
						},
					},
					arcaneCharges = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Arcane Charges"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "arcaneCharges", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Arcane Charges"]),
								hidden = false,
								arg = "arcaneCharges.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "arcaneCharges.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "arcaneCharges.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "arcaneCharges.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "arcaneCharges.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "arcaneCharges.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "arcaneCharges.y",
							},
						},
					},
					-- HOLY POWER
					barHolyPower = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Holy Power"],
						hidden = function(info) return playerClass ~= "PALADIN" or not getVariable(info[2], "holyPower", nil, "isBar") or not getVariable(info[2], nil, nil, "holyPower") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Holy Power"]),
								hidden = false,
								arg = "holyPower.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "holyPower.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "holyPower.showAlways",
							},
						},
					},
					holyPower = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Holy Power"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "holyPower", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Holy Power"]),
								hidden = false,
								arg = "holyPower.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "holyPower.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "holyPower.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "holyPower.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "holyPower.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "holyPower.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "holyPower.y",
							},
						},
					},
					-- SHADOW ORBS
					barShadowOrbs = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Shadow Orbs"],
						hidden = function(info) return playerClass ~= "PRIEST" or not getVariable(info[2], "shadowOrbs", nil, "isBar") or not getVariable(info[2], nil, nil, "shadowOrbs") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Shadow Orbs"]),
								hidden = false,
								arg = "shadowOrbs.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "shadowOrbs.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "shadowOrbs.showAlways",
							},
						},
					},
					shadowOrbs = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Holy Power"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "shadowOrbs", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Shadow Orbs"]),
								hidden = false,
								arg = "shadowOrbs.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "shadowOrbs.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "shadowOrbs.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "shadowOrbs.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "shadowOrbs.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "shadowOrbs.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "shadowOrbs.y",
							},
						},
					},
					-- Chi
					barChi = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Chi"],
						hidden = function(info) return playerClass ~= "MONK" or not getVariable(info[2], "chi", nil, "isBar") or not getVariable(info[2], nil, nil, "chi") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Chi"]),
								hidden = false,
								arg = "chi.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "chi.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "chi.showAlways",
							},
						},
					},
					chi = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Chi"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "chi", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Chi"]),
								hidden = false,
								arg = "chi.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "chi.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "chi.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "chi.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "chi.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "chi.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "chi.y",
							},
						},
					},
					-- COMBO POINTS
					barComboPoints = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Combo points"],
						hidden = function(info) return not getVariable(info[2], "comboPoints", nil, "isBar") or not getVariable(info[2], nil, nil, "comboPoints") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Combo points"]),
								hidden = false,
								arg = "comboPoints.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "comboPoints.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "comboPoints.showAlways",
							},
						},
					},
					comboPoints = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Combo points"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "comboPoints", nil, "isBar") ) then return true end return hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Combo points"]),
								hidden = false,
								arg = "comboPoints.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "comboPoints.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "comboPoints.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "comboPoints.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "comboPoints.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "comboPoints.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "comboPoints.y",
							},
						},
					},
					-- COMBO POINTS
					barAuraPoints = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Aura Combo Points"],
						hidden = function(info) return not ShadowUF.modules.auraPoints or not getVariable(info[2], "auraPoints", nil, "isBar") or not getVariable(info[2], nil, nil, "auraPoints") end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Aura Combo Points"]),
								hidden = false,
								arg = "auraPoints.enabled",
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"]},
								hidden = false,
								arg = "auraPoints.growth",
							},
							showAlways = {
								order = 3,
								type = "toggle",
								name = L["Don't hide when empty"],
								hidden = false,
								arg = "auraPoints.showAlways",
							},
						},
					},
					auraPoints = {
						order = 4,
						type = "group",
						inline = true,
						name = L["Aura Combo Points"],
						hidden = function(info) if( info[2] == "global" or getVariable(info[2], "auraPoints", nil, "isBar") ) then return true end return not ShadowUF.modules.auraPoints or hideRestrictedOption(info) end,
						args = {
							enabled = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Aura Combo Points"]),
								hidden = false,
								arg = "auraPoints.enabled",
							},
							sep1 = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							growth = {
								order = 2,
								type = "select",
								name = L["Growth"],
								values = {["UP"] = L["Up"], ["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["DOWN"] = L["Down"]},
								hidden = false,
								arg = "auraPoints.growth",
							},
							size = {
								order = 2,
								type = "range",
								name = L["Size"],
								min = 0, max = 50, step = 1, softMin = 0, softMax = 20,
								hidden = hideAdvancedOption,
								arg = "auraPoints.size",
							},
							spacing = {
								order = 3,
								type = "range",
								name = L["Spacing"],
								min = -30, max = 30, step = 1, softMin = -15, softMax = 15,
								hidden = hideAdvancedOption,
								arg = "auraPoints.spacing",
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								arg = "auraPoints.anchorPoint",
							},
							x = {
								order = 6,
								type = "range",
								name = L["X Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "auraPoints.x",
							},
							y = {
								order = 7,
								type = "range",
								name = L["Y Offset"],
								min = -30, max = 30, step = 1,
								hidden = false,
								arg = "auraPoints.y",
							},
						},
					},
					combatText = {
						order = 5,
						type = "group",
						inline = true,
						name = L["Combat text"],
						hidden = hideRestrictedOption,
						args = {
							combatText = {
								order = 0,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Combat text"]),
								desc = L["Shows combat feedback, last healing the unit received, last hit did it miss, resist, dodged and so on."],
								arg = "combatText.enabled",
								hidden = false,
							},
							sep = {
								order = 1,
								type = "description",
								name = "",
								width = "full",
								hidden = hideAdvancedOption,
							},
							anchorPoint = {
								order = 3,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								arg = "combatText.anchorPoint",
								hidden = hideAdvancedOption,
							},
							x = {
								order = 4,
								type = "range",
								name = L["X Offset"],
								min = -50, max = 50, step = 1,
								arg = "combatText.x",
								hidden = hideAdvancedOption,
							},
							y = {
								order = 5,
								type = "range",
								name = L["Y Offset"],
								min = -50, max = 50, step = 1,
								arg = "combatText.y",
								hidden = hideAdvancedOption,
							},
						},
					},
				},
			},
			attributes = {
				order = 1.5,
				type = "group",
				name = function(info)
					return L.shortUnits[info[#(info) - 1]] or L.units[info[#(info) - 1]]
				end,
				hidden = function(info)
					local unit = info[#(info) - 1]
					return unit ~= "raid" and unit ~= "raidpet" and unit ~= "party" and unit ~= "mainassist" and unit ~= "maintank" and not ShadowUF.Units.zoneUnits[unit]
				end,
				set = function(info, value)
					setUnit(info, value)

					ShadowUF.Units:ReloadHeader(info[2])
					ShadowUF.modules.movers:Update()
				end,
				get = getUnit,
				args = {
					show = {
						order = 0.5,
						type = "group",
						inline = true,
						name = L["Visibility"],
						hidden = function(info) return info[2] ~= "party" and info[2] ~= "raid" end,
						args = {
							showPlayer = {
								order = 0,
								type = "toggle",
								name = L["Show player in party"],
								desc = L["The player frame will not be hidden regardless, you will have to manually disable it either entirely or per zone type."],
								hidden = function(info) return info[2] ~= "party" end,
								arg = "showPlayer",
							},
							hideSemiRaidParty = {
								order = 1,
								type = "toggle",
								name = L["Hide in >5-man raids"],
								desc = L["Party frames are hidden while in a raid group with more than 5 people inside."],
								hidden = function(info) return info[2] ~= "party" end,
								set = function(info, value)
									if( value ) then
										setVariable(info[2], nil, nil, "hideAnyRaid", false)
									end

									setVariable(info[2], nil, nil, "hideSemiRaid", value)
									ShadowUF.Units:ReloadHeader(info[#(info) - 3])
								end,
								arg = "hideSemiRaid",
							},
							hideRaid = {
								order = 2,
								type = "toggle",
								name = L["Hide in any raid"],
								desc = L["Party frames are hidden while in any sort of raid no matter how many people."],
								hidden = function(info) return info[2] ~= "party" end,
								set = function(info, value)
									if( value ) then
										setVariable(info[2], nil, nil, "hideSemiRaid", false)
									end

									setVariable(info[2], nil, nil, "hideAnyRaid", value)
									ShadowUF.Units:ReloadHeader(info[#(info) - 3])
								end,
								arg = "hideAnyRaid",
							},
							separateFrames = {
								order = 3,
								type = "toggle",
								name = L["Separate raid frames"],
								desc = L["Splits raid frames into individual frames for each raid group instead of one single frame.|nNOTE! You cannot drag each group frame individualy, but how they grow is set through the column and row growth options."],
								hidden = function(info) return info[2] ~= "raid" end,
								arg = "frameSplit",
							},
							hideSemiRaidRaid = {
								order = 3.5,
								type = "toggle",
								name = L["Hide in <=5-man raids"],
								desc = L["Raid frames are hidden while in a raid group with 5 or less people inside."],
								hidden = function(info) return info[2] ~= "raid" end,
								set = function(info, value)
									setVariable(info[2], nil, nil, "hideSemiRaid", value)
									ShadowUF.Units:ReloadHeader(info[#(info) - 3])
								end,
								arg = "hideSemiRaid"
							},
							showInRaid = {
								order = 4,
								type = "toggle",
								name = L["Show party as raid"],
								hidden = hideRaidOption,
								set = function(info, value)
									setUnit(info, value)

									ShadowUF.Units:ReloadHeader("party")
									ShadowUF.Units:ReloadHeader("raid")
									ShadowUF.modules.movers:Update()
								end,
								arg = "showParty",
							},
						},
					},
					general = {
						order = 1,
						type = "group",
						inline = true,
						name = L["General"],
						hidden = false,
						args = {
							offset = {
								order = 2,
								type = "range",
								name = L["Row offset"],
								desc = L["Spacing between each row"],
								min = -10, max = 100, step = 1,
								arg = "offset",
							},
							attribPoint = {
								order = 3,
								type = "select",
								name = L["Row growth"],
								desc = L["How the rows should grow when new group members are added."],
								values = {["TOP"] = L["Down"], ["BOTTOM"] = L["Up"], ["LEFT"] = L["Right"], ["RIGHT"] = L["Left"]},
								arg = "attribPoint",
								set = function(info, value)
									-- If you set the frames to grow left, the columns have to grow down or up as well
									local attribAnchorPoint = getVariable(info[2], nil, nil, "attribAnchorPoint")
									if( ( value == "LEFT" or value == "RIGHT" ) and attribAnchorPoint ~= "BOTTOM" and attribAnchorPoint ~= "TOP" ) then
										ShadowUF.db.profile.units[info[2]].attribAnchorPoint = "BOTTOM"
									elseif( ( value == "TOP" or value == "BOTTOM" ) and attribAnchorPoint ~= "LEFT" and attribAnchorPoint ~= "RIGHT" ) then
										ShadowUF.db.profile.units[info[2]].attribAnchorPoint = "RIGHT"
									end

									setUnit(info, value)

									local position = ShadowUF.db.profile.positions[info[2]]
									if( position.top and position.bottom ) then
										local point = ShadowUF.db.profile.units[info[2]].attribAnchorPoint == "RIGHT" and "RIGHT" or "LEFT"
										position.point = (ShadowUF.db.profile.units[info[2]].attribPoint == "BOTTOM" and "BOTTOM" or "TOP") .. point
										position.y = ShadowUF.db.profile.units[info[2]].attribPoint == "BOTTOM" and position.bottom or position.top
									end

									ShadowUF.Units:ReloadHeader(info[2])
									ShadowUF.modules.movers:Update()
								end,
							},
							sep2 = {
								order = 4,
								type = "description",
								name = "",
								width = "full",
								hidden = false,
							},
							columnSpacing = {
								order = 5,
								type = "range",
								name = L["Column spacing"],
								min = -30, max = 100, step = 1,
								hidden = hideRaidOrAdvancedOption,
								arg = "columnSpacing",
							},
							attribAnchorPoint = {
								order = 6,
								type = "select",
								name = L["Column growth"],
								desc = L["How the frames should grow when a new column is added."],
								values = function(info)
									local attribPoint = getVariable(info[2], nil, nil, "attribPoint")
									if( attribPoint == "LEFT" or attribPoint == "RIGHT" ) then
										return {["TOP"] = L["Down"], ["BOTTOM"] = L["Up"]}
									end

									return {["LEFT"] = L["Right"], ["RIGHT"] = L["Left"]}
								end,
								hidden = hideRaidOrAdvancedOption,
								set = function(info, value)
									-- If you set the frames to grow left, the columns have to grow down or up as well
									local attribPoint = getVariable(info[2], nil, nil, "attribPoint")
									if( ( value == "LEFT" or value == "RIGHT" ) and attribPoint ~= "BOTTOM" and attribPoint ~= "TOP" ) then
										ShadowUF.db.profile.units[info[2]].attribPoint = "BOTTOM"
									end

									setUnit(info, value)

									ShadowUF.Units:ReloadHeader(info[2])
									ShadowUF.modules.movers:Update()
								end,
								arg = "attribAnchorPoint",
							},
							sep3 = {
								order = 7,
								type = "description",
								name = "",
								width = "full",
								hidden = false,
							},
							maxColumns = {
								order = 8,
								type = "range",
								name = L["Max columns"],
								min = 1, max = 20, step = 1,
								arg = "maxColumns",
								hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or hideSplitOrRaidOption(info) end,
							},
							unitsPerColumn = {
								order = 8,
								type = "range",
								name = L["Units per column"],
								min = 1, max = 40, step = 1,
								arg = "unitsPerColumn",
								hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or hideSplitOrRaidOption(info) end,
							},
							partyPerColumn = {
								order = 9,
								type = "range",
								name = L["Units per column"],
								min = 1, max = 5, step = 1,
								arg = "unitsPerColumn",
								hidden = function(info) return info[2] ~= "party" or not ShadowUF.db.profile.advanced end,
							},
							groupsPerRow = {
								order = 8,
								type = "range",
								name = L["Groups per row"],
								desc = L["How many groups should be shown per row."],
								min = 1, max = 8, step = 1,
								arg = "groupsPerRow",
								hidden = function(info) return info[2] ~= "raid" or not ShadowUF.db.profile.units.raid.frameSplit end,
							},
							groupSpacing = {
								order = 9,
								type = "range",
								name = L["Group row spacing"],
								desc = L["How much spacing should be between each new row of groups."],
								min = -50, max = 50, step = 1,
								arg = "groupSpacing",
								hidden = function(info) return info[2] ~= "raid" or not ShadowUF.db.profile.units.raid.frameSplit end,
							},
						},
					},
					sort = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Sorting"],
						hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or ( info[2] ~= "raid" and not ShadowUF.db.profile.advanced ) end,
						args = {
							sortMethod = {
								order = 2,
								type = "select",
								name = L["Sort method"],
								values = {["INDEX"] = L["Index"], ["NAME"] = L["Name"]},
								arg = "sortMethod",
								hidden = false,
							},
							sortOrder = {
								order = 2,
								type = "select",
								name = L["Sort order"],
								values = {["ASC"] = L["Ascending"], ["DESC"] = L["Descending"]},
								arg = "sortOrder",
								hidden = false,
							},
						},
					},
					raid = {
						order = 3,
						type = "group",
						inline = true,
						name = L["Groups"],
						hidden = hideRaidOption,
						args = {
							groupBy = {
								order = 4,
								type = "select",
								name = L["Group by"],
								values = {["GROUP"] = L["Group number"], ["CLASS"] = L["Class"], ["ASSIGNEDROLE"] = L["Assigned Role (DPS/Tank/etc)"]},
								arg = "groupBy",
								hidden = hideSplitOrRaidOption,
							},
							selectedGroups = {
								order = 7,
								type = "multiselect",
								name = L["Groups to show"],
								values = {string.format(L["Group %d"], 1), string.format(L["Group %d"], 2), string.format(L["Group %d"], 3), string.format(L["Group %d"], 4), string.format(L["Group %d"], 5), string.format(L["Group %d"], 6), string.format(L["Group %d"], 7), string.format(L["Group %d"], 8)},
								set = function(info, key, value)
									local tbl = getVariable(info[2], nil, nil, "filters")
									tbl[key] = value

									setVariable(info[2], "filters", nil, tbl)
									ShadowUF.Units:ReloadHeader(info[2])
									ShadowUF.modules.movers:Update()
								end,
								get = function(info, key)
									return getVariable(info[2], nil, nil, "filters")[key]
								end,
								hidden = function(info) return info[2] ~= "raid" and info[2] ~= "raidpet" end,
							},
						},
					},
				},
			},
			frame = {
				order = 2,
				name = L["Frame"],
				type = "group",
				hidden = isModifiersSet,
				set = setUnit,
				get = getUnit,
				args = {
					size = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Size"],
						hidden = false,
						set = function(info, value)
							setUnit(info, value)
							ShadowUF.modules.movers:Update()
						end,
						args = {
							scale = {
								order = 0,
								type = "range",
								name = L["Scale"],
								min = 0.25, max = 2, step = 0.01,
								isPercent = true,
								arg = "scale",
							},
							height = {
								order = 1,
								type = "range",
								name = L["Height"],
								min = 0, softMax = 100, step = 1,
								arg = "height",
							},
							width = {
								order = 2,
								type = "range",
								name = L["Width"],
								min = 0, softMax = 300, step = 1,
								arg = "width",
							},
						},
					},
					anchor = {
						order = 1,
						type = "group",
						inline = true,
						hidden = function(info) return info[2] == "global" end,
						name = L["Anchor to another frame"],
						set = setPosition,
						get = getPosition,
						args = {
							anchorPoint = {
								order = 0.50,
								type = "select",
								name = L["Anchor point"],
								values = positionList,
								hidden = false,
								get = function(info)
									local position = ShadowUF.db.profile.positions[info[2]]
									if( ShadowUF.db.profile.advanced ) then
										return position[info[#(info)]]
									end


									return position.movedAnchor or position[info[#(info)]]
								end,
							},
							anchorTo = {
								order = 1,
								type = "select",
								name = L["Anchor to"],
								values = getAnchorParents,
								hidden = false,
							},
							sep = {
								order = 2,
								type = "description",
								name = "",
								width = "full",
								hidden = false,
							},
							x = {
								order = 3,
								type = "input",
								name = L["X Offset"],
								validate = checkNumber,
								set = setNumber,
								get = getString,
								hidden = false,
							},
							y = {
								order = 4,
								type = "input",
								name = L["Y Offset"],
								validate = checkNumber,
								set = setNumber,
								get = getString,
								hidden = false,
							},
						},
					},
					orHeader = {
						order = 1.5,
						type = "header",
						name = L["Or you can set a position manually"],
						hidden = function(info) if( info[2] == "global" or hideAdvancedOption() ) then return true else return false end end,
					},
					position = {
						order = 2,
						type = "group",
						hidden = function(info) if( info[2] == "global" or hideAdvancedOption() ) then return true else return false end end,
						inline = true,
						name = L["Manual position"],
						set = setPosition,
						get = getPosition,
						args = {
							point = {
								order = 0,
								type = "select",
								name = L["Point"],
								values = pointPositions,
								hidden = false,
							},
							anchorTo = {
								order = 0.50,
								type = "select",
								name = L["Anchor to"],
								values = getAnchorParents,
								hidden = false,
							},
							relativePoint = {
								order = 1,
								type = "select",
								name = L["Relative point"],
								values = pointPositions,
								hidden = false,
							},
							sep = {
								order = 2,
								type = "description",
								name = "",
								width = "full",
								hidden = false,
							},
							x = {
								order = 3,
								type = "input",
								name = L["X Offset"],
								validate = checkNumber,
								set = setNumber,
								get = getString,
								hidden = false,
							},
							y = {
								order = 4,
								type = "input",
								name = L["Y Offset"],
								validate = checkNumber,
								set = setNumber,
								get = getString,
								hidden = false,
							},
						},
					},
				},
			},
			bars = {
				order = 3,
				name = L["Bars"],
				type = "group",
				hidden = isModifiersSet,
				set = setUnit,
				get = getUnit,
				args = {
					powerbar = {
						order = 1,
						type = "group",
						inline = false,
						name = L["Power bar"],
						hidden = false,
						args = {
							powerBar = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Power bar"]),
								arg = "powerBar.enabled",
							},
							altPowerBar = {
								order = 3,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Alt. Power bar"]),
								desc = L["Shows a bar for alternate power info (used in some encounters)"],
								hidden = function(info) return ShadowUF.fakeUnits[info[2]] or hideRestrictedOption(info) end,
								arg = "altPowerBar.enabled",
							},
							colorType = {
								order = 5,
								type = "select",
								name = L["Color power by"],
								desc = L["Primary means of coloring the power bar. Coloring by class only applies to players, for non-players it will default to the power type."],
								values = {["class"] = L["Class"], ["type"] = L["Power Type"]},
								arg = "powerBar.colorType",
							},
							onlyMana = {
								order = 6,
								type = "toggle",
								name = L["Only show when mana"],
								desc = L["Hides the power bar unless the class has mana."],
								hidden = function(info) return not ShadowUF.Units.headerUnits[info[2]] end,
								arg = "powerBar.onlyMana",
							}
						},
					},
					classmiscbars = {
						order = 2,
						type = "group",
						inline = false,
						name = L["Class/misc bars"],
						hidden = function(info)
							local unit = info[2]
							if( unit == "global" ) then
								return not globalConfig.runeBar and not globalConfig.totemBar and not globalConfig.druidBar and not globalConfig.priestBar and not globalConfig.shamanBar and not globalConfig.xpBar and not globalConfig.staggerBar
							else
								return unit ~= "player" and unit ~= "pet"
							end
						end,
						args = {
							runeBar = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Rune bar"]),
								desc = L["Adds rune bars and timers before runes refresh to the player frame."],
								hidden = hideRestrictedOption,
								arg = "runeBar.enabled",
							},
							staggerBar = {
								order = 1.25,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Stagger bar"]),
								desc = L["Adds a Stagger bar for Brewmaster Monks."],
								hidden = hideRestrictedOption,
								arg = "staggerBar.enabled",
							},
							druidBar = {
								order = 3,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Druid mana bar"]),
								desc = L["Adds another mana bar to the player frame when you are in Bear or Cat form showing you how much mana you have."],
								hidden = hideRestrictedOption,
								arg = "druidBar.enabled",
							},
							priestBar = {
								order = 3,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Priest mana bar"]),
								desc = L["Adds a mana bar to the player frame for shadow priests."],
								hidden = hideRestrictedOption,
								arg = "priestBar.enabled",
							},
							shamanBar = {
								order = 3,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Shaman mana bar"]),
								desc = L["Adds a mana bar to the player frame for elemental and enhancement shamans."],
								hidden = hideRestrictedOption,
								arg = "shamanBar.enabled",
							},
							xpBar = {
								order = 4,
								type = "toggle",
								name = string.format(L["Enable %s"], L["XP/Rep bar"]),
								desc = L["This bar will automatically hide when you are at the level cap, or you do not have any reputations tracked."],
								hidden = hideRestrictedOption,
								arg = "xpBar.enabled",
							},
						},
					},
					healthBar = {
						order = 2,
						type = "group",
						inline = false,
						name = L["Health bar"],
						hidden = false,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Health bar"]),
								arg = "healthBar.enabled"
							},
							sep = {
								order = 3.5,
								type = "description",
								name = "",
								hidden = function(info) return not (info[2] == "player" or info[2] == "pet") end,
							},
							colorAggro = {
								order = 4,
								type = "toggle",
								name = L["Color on aggro"],
								desc = L["Changes the health bar to the set hostile color (Red by default) when the unit takes aggro."],
								arg = "healthBar.colorAggro",
								hidden = hideRestrictedOption,
							},
							colorDispel = {
								order = 5,
								type = "toggle",
								name = L["Color on curable debuff"],
								desc = L["Changes the health bar to the color of any curable debuff."],
								arg = "healthBar.colorDispel",
								hidden = hideRestrictedOption,
								width = "full",
							},
							healthColor = {
								order = 6,
								type = "select",
								name = L["Color health by"],
								desc = L["Primary means of coloring the health bar, color on aggro and color by reaction will override this if necessary."],
								values = function(info)
											if info[2] == "pet" or info[2] == "partypet" or info[2] == "raidpet" or info[2] == "arenapet" then
												return {["class"] = L["Class"], ["static"] = L["Static"], ["percent"] = L["Health percent"], ["playerclass"] = L["Player Class"]}
											else
												return {["class"] = L["Class"], ["static"] = L["Static"], ["percent"] = L["Health percent"]}
											end
										end,
								arg = "healthBar.colorType",
							},
							reaction = {
								order = 7,
								type = "select",
								name = L["Color by reaction on"],
								desc = L["When to color the health bar by the units reaction, overriding the color health by option."],
								arg = "healthBar.reactionType",
								values = {["none"] = L["Never (Disabled)"], ["player"] = L["Players only"], ["npc"] = L["NPCs only"], ["both"] = L["Both"]},
								hidden = function(info) return info[2] == "player" or info[2] == "pet" end,
							}
						},
					},
					healAbsorb = {
						order = 2.5,
						type = "group",
						inline = false,
						name = L["Heal absorbs"],
						hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or hideRestrictedOption(info) end,
						disabled = function(info) return not getVariable(info[2], "healthBar", nil, "enabled") end,
						args = {
							heals = {
								order = 1,
								type = "toggle",
								name = L["Show Heal Absorbs"],
								desc = L["Adds a bar inside the health bar indicating how much healing will be absorbed and not applied to the player."],
								arg = "healAbsorb.enabled",
								hidden = false,
								set = function(info, value)
									setUnit(info, value)
									setDirectUnit(info[2], "healAbsorb", nil, "enabled", getVariable(info[2], "healAbsorb", nil, "enabled"))
								end
							},
							cap = {
								order = 3,
								type = "range",
								name = L["Outside bar limit"],
								desc = L["Percentage value of how far outside the unit frame the absorbed health bar can go. 130% means it will go 30% outside the frame, 100% means it will not go outside."],
								min = 1, max = 1.50, step = 0.05, isPercent = true,
								arg = "healAbsorb.cap",
								hidden = false,
							},
						},
					},
					incHeal = {
						order = 3,
						type = "group",
						inline = false,
						name = L["Incoming heals"],
						hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or hideRestrictedOption(info) end,
						disabled = function(info) return not getVariable(info[2], "healthBar", nil, "enabled") end,
						args = {
							heals = {
								order = 1,
								type = "toggle",
								name = L["Show incoming heals"],
								desc = L["Adds a bar inside the health bar indicating how much healing someone will receive."],
								arg = "incHeal.enabled",
								hidden = false,
								set = function(info, value)
									setUnit(info, value)
									setDirectUnit(info[2], "incHeal", nil, "enabled", getVariable(info[2], "incHeal", nil, "enabled"))
								end
							},
							cap = {
								order = 3,
								type = "range",
								name = L["Outside bar limit"],
								desc = L["Percentage value of how far outside the unit frame the incoming heal bar can go. 130% means it will go 30% outside the frame, 100% means it will not go outside."],
								min = 1, max = 1.50, step = 0.05, isPercent = true,
								arg = "incHeal.cap",
								hidden = false,
							},
						},
					},
					incAbsorb = {
						order = 3.5,
						type = "group",
						inline = false,
						name = L["Incoming absorbs"],
						hidden = function(info) return ShadowUF.Units.zoneUnits[info[2]] or hideRestrictedOption(info) end,
						disabled = function(info) return not getVariable(info[2], "healthBar", nil, "enabled") end,
						args = {
							heals = {
								order = 1,
								type = "toggle",
								name = L["Show incoming absorbs"],
								desc = L["Adds a bar inside the health bar indicating how much damage will be absorbed."],
								arg = "incAbsorb.enabled",
								hidden = false,
								set = function(info, value)
									setUnit(info, value)
									setDirectUnit(info[2], "incAbsorb", nil, "enabled", getVariable(info[2], "incAbsorb", nil, "enabled"))
								end
							},
							cap = {
								order = 3,
								type = "range",
								name = L["Outside bar limit"],
								desc = L["Percentage value of how far outside the unit frame the incoming absorb bar can go. 130% means it will go 30% outside the frame, 100% means it will not go outside."],
								min = 1, max = 1.50, step = 0.05, isPercent = true,
								arg = "incAbsorb.cap",
								hidden = false,
							},
						},
					},
					totemBar = {
						order = 3.6,
						type = "group",
						inline = false,
						name = ShadowUF.modules.totemBar.moduleName,
						hidden = function(info)
							local unit = info[2]
							if( unit == "global" ) then
								return not globalConfig.totemBar
							else
								return unit ~= "player" and unit ~= "pet"
							end
						end,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], ShadowUF.modules.totemBar.moduleName),
								desc = function(info)
									return select(2, UnitClass("player")) == "SHAMAN" and L["Adds totem bars with timers before they expire to the player frame."] or select(2, UnitClass("player")) == "DEATHKNIGHT" and L["Adds a bar indicating how much time is left on your ghoul timer, only used if you do not have a permanent ghoul."] or select(2, UnitClass("player")) == "MAGE" and L["Adds a bar indicating how much time is left on your Rune of Power."] or L["Adds a bar indicating how much time is left on your mushrooms."]
								end,
								arg = "totemBar.enabled",
							},
							icon = {
								order = 2,
								type = "toggle",
								name = L["Show icon durations"],
								desc = L["Uses the icon of the totem being shown instead of a status bar."],
								arg = "totemBar.icon",
							},
							secure = {
								order = 3,
								type = "toggle",
								name = L["Dismissable Totem bars"],
								hidden = function()
									return not ShadowUF.modules.totemBar:SecureLockable()
								end,
								desc = function(info)
									return L["Allows you to disable the totem by right clicking it.|n|nWarning: Inner bars for this unit will not resize in combat if you enable this."]
								end,
								arg = "totemBar.secure",
							}
						},
					},
					emptyBar = {
						order = 4,
						type = "group",
						inline = false,
						name = L["Empty bar"],
						hidden = false,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Empty bar"]),
								desc = L["Adds an empty bar that you can put text into as a way of uncluttering other bars."],
								arg = "emptyBar.enabled",
								width = "full"
							},
							overrideColor = {
								order = 4,
								type = "color",
								name = L["Background color"],
								disabled = function(info)
									local emptyBar = getVariable(info[2], nil, nil, "emptyBar")
									return emptyBar.class and emptyBar.reaciton
								end,
								set = function(info, r, g, b)
									local color = getUnit(info) or {}
									color.r = r
									color.g = g
									color.b = b

									setUnit(info, color)
								end,
								get = function(info)
									local color = getUnit(info)
									if( not color ) then
										return 0, 0, 0
									end

									return color.r, color.g, color.b

								end,
								arg = "emptyBar.backgroundColor",
								width = "full"
							},
							reaction = {
								order = 2,
								type = "select",
								name = L["Color by reaction on"],
								desc = L["When to color the empty bar by reaction, overriding the default color by option."],
								arg = "emptyBar.reactionType",
								values = {["none"] = L["Never (Disabled)"], ["player"] = L["Players only"], ["npc"] = L["NPCs only"], ["both"] = L["Both"]},
							},
							colorType = {
								order = 3,
								type = "toggle",
								name = L["Color by class"],
								desc = L["Players will be colored by class."],
								arg = "emptyBar.class",
							},
						},
					},
					castBar = {
						order = 5,
						type = "group",
						inline = false,
						name = L["Cast bar"],
						hidden = hideRestrictedOption,
						args = {
							enabled = {
								order = 1,
								type = "toggle",
								name = string.format(L["Enable %s"], L["Cast bar"]),
								desc = function(info) return ShadowUF.fakeUnits[info[2]] and string.format(L["Due to the nature of fake units, cast bars for %s are not super efficient and can take at most 0.10 seconds to notice a change in cast."], L.units[info[2]] or info[2]) end,
								hidden = false,
								arg = "castBar.enabled",
								width = "full"
							},
							autoHide = {
								order = 2,
								type = "toggle",
								name = L["Hide bar when empty"],
								desc = L["Hides the cast bar if there is no cast active."],
								hidden = false,
								arg = "castBar.autoHide",
							},
							castIcon = {
								order = 2.5,
								type = "select",
								name = L["Cast icon"],
								arg = "castBar.icon",
								values = {["LEFT"] = L["Left"], ["RIGHT"] = L["Right"], ["HIDE"] = L["Disabled"]},
								hidden = false,
							},
							castName = {
								order = 3,
								type = "header",
								name = L["Cast name"],
								hidden = hideAdvancedOption,
							},
							nameEnabled = {
								order = 4,
								type = "toggle",
								name = L["Show cast name"],
								arg = "castBar.name.enabled",
								hidden = hideAdvancedOption,
							},
							nameAnchor = {
								order = 5,
								type = "select",
								name = L["Anchor point"],
								desc = L["Where to anchor the cast name text."],
								values = {["CLI"] = L["Inside Center Left"], ["CRI"] = L["Inside Center Right"]},
								hidden = hideAdvancedOption,
								arg = "castBar.name.anchorPoint",
							},
							nameSize = {
								order = 7,
								type = "range",
								name = L["Size"],
								desc = L["Let's you modify the base font size to either make it larger or smaller."],
								min = -10, max = 10, step = 1, softMin = -5, softMax = 5,
								hidden = hideAdvancedOption,
								arg = "castBar.name.size",
							},
							nameX = {
								order = 8,
								type = "range",
								name = L["X Offset"],
								min = -20, max = 20, step = 1,
								hidden = hideAdvancedOption,
								arg = "castBar.name.x",
							},
							nameY = {
								order = 9,
								type = "range",
								name = L["Y Offset"],
								min = -20, max = 20, step = 1,
								hidden = hideAdvancedOption,
								arg = "castBar.name.y",
							},
							castTime = {
								order = 10,
								type = "header",
								name = L["Cast time"],
								hidden = hideAdvancedOption,
							},
							timeEnabled = {
								order = 11,
								type = "toggle",
								name = L["Show cast time"],
								arg = "castBar.time.enabled",
								hidden = hideAdvancedOption,
								width = "full"
							},
							timeAnchor = {
								order = 12,
								type = "select",
								name = L["Anchor point"],
								desc = L["Where to anchor the cast time text."],
								values = {["CLI"] = L["Inside Center Left"], ["CRI"] = L["Inside Center Right"]},
								hidden = hideAdvancedOption,
								arg = "castBar.time.anchorPoint",
							},
							timeSize = {
								order = 14,
								type = "range",
								name = L["Size"],
								desc = L["Let's you modify the base font size to either make it larger or smaller."],
								min = -10, max = 10, step = 1, softMin = -5, softMax = 5,
								hidden = hideAdvancedOption,
								arg = "castBar.time.size",
							},
							timeX = {
								order = 15,
								type = "range",
								name = L["X Offset"],
								min = -20, max = 20, step = 1,
								hidden = hideAdvancedOption,
								arg = "castBar.time.x",
							},
							timeY = {
								order = 16,
								type = "range",
								name = L["Y Offset"],
								min = -20, max = 20, step = 1,
								hidden = hideAdvancedOption,
								arg = "castBar.time.y",
							},
						},
					},
				},
			},
			widgetSize = {
				order = 4,
				name = L["Widget Size"],
				type = "group",
				hidden = isModifiersSet,
				set = setUnit,
				get = getUnit,
				args = {
					help = {
						order = 0,
						type = "group",
						name = L["Help"],
						inline = true,
						hidden = false,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["Bars with an order higher or lower than the full size options will use the entire unit frame width.|n|nBar orders between those two numbers are shown next to the portrait."],
							},
						},
					},
					portrait = {
						order = 0.5,
						type = "group",
						name = L["Portrait"],
						inline = false,
						hidden = false,
						args = {
							enableBar = {
								order = 1,
								type = "toggle",
								name = L["Show as bar"],
								desc = L["Changes this widget into a bar, you will be able to change the height and ordering like you can change health and power bars."],
								arg = "$parent.isBar",
							},
							sep = {
								order = 1.5,
								type = "description",
								name = "",
								width = "full",
								hidden = function(info) return getVariable(info[2], "portrait", nil, "isBar") end,
							},
							width = {
								order = 2,
								type = "range",
								name = L["Width percent"],
								desc = L["Percentage of width the portrait should use."],
								min = 0, max = 1.0, step = 0.01, isPercent = true,
								hidden = function(info) return getVariable(info[2], "portrait", nil, "isBar") end,
								arg = "$parent.width",
							},
							before = {
								order = 3,
								type = "range",
								name = L["Full size before"],
								min = 0, max = 100, step = 5,
								hidden = function(info) return getVariable(info[2], "portrait", nil, "isBar") end,
								arg = "$parent.fullBefore",
							},
							after = {
								order = 4,
								type = "range",
								name = L["Full size after"],
								min = 0, max = 100, step = 5,
								hidden = function(info) return getVariable(info[2], "portrait", nil, "isBar") end,
								arg = "$parent.fullAfter",
							},
							order = {
								order = 3,
								type = "range",
								name = L["Order"],
								min = 0, max = 100, step = 5,
								hidden = hideBarOption,
								arg = "portrait.order",
							},
							height = {
								order = 4,
								type = "range",
								name = L["Height"],
								desc = L["How much of the frames total height this bar should get, this is a weighted value, the higher it is the more it gets."],
								min = 0, max = 10, step = 0.1,
								hidden = hideBarOption,
								arg = "portrait.height",
							},
						},
					},
				},
			},
			auras = {
				order = 5,
				name = L["Auras"],
				type = "group",
				hidden = isModifiersSet,
				set = setUnit,
				get = getUnit,
				childGroups = "tree",
				args = {
					buffs = Config.auraTable,
					debuffs = Config.auraTable,
				},
			},
			indicators = {
				order = 5.5,
				type = "group",
				name = L["Indicators"],
				hidden = isModifiersSet,
				childGroups = "tree",
				set = setUnit,
				get = getUnit,
				args = {
				},
			},
			tag = {
				order = 7,
				name = L["Text/Tags"],
				type = "group",
				hidden = isModifiersSet,
				childGroups = "tree",
				args = tagWizard,
			},
		},
	}

	for _, indicator in pairs(ShadowUF.modules.indicators.list) do
		Config.unitTable.args.indicators.args[indicator] = Config.indicatorTable
	end

	-- Check for unit conflicts
	local function hideZoneConflict()
		for _, zone in pairs(ShadowUF.db.profile.visibility) do
			for unit, status in pairs(zone) do
				if( L.units[unit] and ( not status and ShadowUF.db.profile.units[unit].enabled or status and not ShadowUF.db.profile.units[unit].enabled ) ) then
					return nil
				end
			end
		end

		return true
	end

	options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(ShadowUF.db, true)
	local LibDualSpec = LibStub("LibDualSpec-1.0", true)
	if LibDualSpec then LibDualSpec:EnhanceOptions(options.args.profile, ShadowUF.db) end

	options.args.enableUnits = {
		type = "group",
		name = L["Enabled Units"],
		desc = getPageDescription,
		args = {
			help = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Help"],
				hidden = function()
					if( not hideZoneConflict() or hideBasicOption() ) then
						return true
					end

					return nil
				end,
				args = {
					help = {
						order = 0,
						type = "description",
						name = L["The check boxes below will allow you to enable or disable units.|n|n|cffff2020Warning!|r Target of Target units have a higher performance cost compared to other units. If you have performance issues, please disable those units or reduce the features enabled for those units."],
					},
				},
			},
			zoneenabled = {
				order = 1.5,
				type = "group",
				inline = true,
				name = L["Zone configuration units"],
				hidden = hideZoneConflict,
				args = {
					help = {
						order = 1,
						type = "description",
						name = L["|cffff2020Warning!|r Some units have overrides set in zone configuration, and may show (or not show up) in certain zone. Regardless of the settings below."]
					},
					sep = {
						order = 2,
						type = "header",
						name = "",
					},
					units = {
						order = 3,
						type = "description",
						name = function()
							local text = {}

							for zoneType, zone in pairs(ShadowUF.db.profile.visibility) do
								local errors = {}
								for unit, status in pairs(zone) do
									if( L.units[unit] ) then
										if ( not status and ShadowUF.db.profile.units[unit].enabled ) then
											table.insert(errors, string.format(L["|cffff2020%s|r units disabled"], L.units[unit]))
										elseif( status and not ShadowUF.db.profile.units[unit].enabled ) then
											table.insert(errors, string.format(L["|cff20ff20%s|r units enabled"], L.units[unit]))
										end
									end
								end

								if( #(errors) > 1 ) then
									table.insert(text, string.format("|cfffed000%s|r have the following overrides: %s", AREA_NAMES[zoneType], table.concat(errors, ", ")))
								elseif( #(errors) == 1 ) then
									table.insert(text, string.format("|cfffed000%s|r has the override: %s", AREA_NAMES[zoneType], errors[1]))
								end
							end

							return #(text) > 0 and table.concat(text, "|n") or ""
						end,
					},
				},
			},
			enabled = {
				order = 2,
				type = "group",
				inline = true,
				name = L["Enable units"],
				args = {},
			},
		},
	}

	local sort_units = function(a, b)
		return a < b
	end

	options.args.units = {
		type = "group",
		name = L["Unit Configuration"],
		desc = getPageDescription,
		args = {
			help = {
				order = 1,
				type = "group",
				inline = true,
				name = L["Help"],
				args = {
					help = {
						order = 0,
						type = "description",
						name = L["Wondering what all of the tabs for the unit configuration mean? Here's some information:|n|n|cfffed000General:|r Portrait, range checker, combat fader, border highlighting|n|cfffed000Frame:|r Unit positioning and frame anchoring|n|cfffed000Bars:|r Health, power, empty and cast bar, and combo point configuration|n|cfffed000Widget size:|r All bar and portrait sizing and ordering options|n|cfffed000Auras:|r All aura configuration for enabling/disabling/enlarging self/etc|n|cfffed000Indicators:|r All indicator configuration|n|cfffed000Text/Tags:|r Tag management as well as text positioning and width settings.|n|n|n*** Frequently looked for options ***|n|n|cfffed000Raid frames by group|r - Unit configuration -> Raid -> Raid -> Separate raid frames|n|cfffed000Class coloring:|r Bars -> Color health by|n|cfffed000Timers on auras:|r You need OmniCC for that|n|cfffed000Showing/Hiding default buff frames:|r Hide Blizzard -> Hide buff frames|n|cfffed000Percentage HP/MP text:|r Tags/Text tab, use the [percenthp] or [percentpp] tags|n|cfffed000Hiding party based on raid|r - Unit configuration -> Party -> Party -> Hide in 6-man raid/Hide in any raid"],
						fontSize = "medium",
					},
				},
			},
			global = {
				type = "group",
				childGroups = "tab",
				order = 0,
				name = L["Global"],
				args = {
					test = {
						order = 0,
						type = "group",
						name = L["Currently modifying"],
						inline = true,
						hidden = function()
							for k in pairs(modifyUnits) do return false end
							return true
						end,
						args = {
							info = {
								order = 0,
								type = "description",
								name = function()
									local units = {};
									for unit, enabled in pairs(modifyUnits) do
										if( enabled ) then
											table.insert(units, L.units[unit])
										end
									end

									table.sort(units, sort_units)
									return table.concat(units, ", ")
								end,
							}
						}
					},
					units = {
						order = 1,
						type = "group",
						name = L["Units"],
						set = function(info, value)
							if( IsShiftKeyDown() ) then
								for _, unit in pairs(ShadowUF.unitList) do
									if( ShadowUF.db.profile.units[unit].enabled ) then
										modifyUnits[unit] = value and true or nil

										if( value ) then
											globalConfig = mergeTables(globalConfig, ShadowUF.db.profile.units[unit])
										end
									end
								end
							else
								local unit = info[#(info)]
								modifyUnits[unit] = value and true or nil

								if( value ) then
									globalConfig = mergeTables(globalConfig, ShadowUF.db.profile.units[unit])
								end
							end

							-- Check if we have nothing else selected, if so wipe it
							local hasUnit
							for k in pairs(modifyUnits) do hasUnit = true break end
							if( not hasUnit ) then
								globalConfig = {}
							end

							AceRegistry:NotifyChange("ShadowedUF")
						end,
						get = function(info) return modifyUnits[info[#(info)]] end,
						args = {
							help = {
								order = 0,
								type = "group",
								name = L["Help"],
								inline = true,
								args = {
									help = {
										order = 0,
										type = "description",
										name = L["Select the units that you want to modify, any settings changed will change every unit you selected. If you want to anchor or change raid/party unit specific settings you will need to do that through their options.|n|nShift click a unit to select all/unselect all."],
									},
								},
							},
							units = {
								order = 1,
								type = "group",
								name = L["Units"],
								inline = true,
								args = {},
							},
						},
					},
				},
			},
		},
	}

	-- Load modules into the unit table
	for key, module in pairs(ShadowUF.modules) do
		local canHaveBar = module.moduleHasBar
		for _, data in pairs(ShadowUF.defaults.profile.units) do
			if( data[key] and data[key].isBar ~= nil ) then
				canHaveBar = true
				break
			end
		end

		if( canHaveBar ) then
			Config.unitTable.args.widgetSize.args[key] = Config.barTable
		end
	end

	-- Load global unit
	for k, v in pairs(Config.unitTable.args) do
		options.args.units.args.global.args[k] = v
	end

	-- Load all of the per unit settings
	local perUnitList = {
		order = getUnitOrder,
		type = "toggle",
		name = getName,
		hidden = isUnitDisabled,
		desc = function(info)
			return string.format(L["Adds %s to the list of units to be modified when you change values in this tab."], L.units[info[#(info)]])
		end,
	}

	-- Enabled units list
	local unitCatOrder = {}
	local enabledUnits = {
		order = function(info) return unitCatOrder[info[#(info)]] + getUnitOrder(info) end,
		type = "toggle",
		name = getName,
		set = function(info, value)
			local unit = info[#(info)]
			for child, parent in pairs(ShadowUF.Units.childUnits) do
				if( unit == parent and not value ) then
					ShadowUF.db.profile.units[child].enabled = false
				end
			end

			ShadowUF.modules.movers:Update()
			ShadowUF.db.profile.units[unit].enabled = value
			ShadowUF:LoadUnits()

			-- Update party frame visibility
			if( unit == "raid" and ShadowUF.Units.headerFrames.party ) then
				ShadowUF.Units:SetHeaderAttributes(ShadowUF.Units.headerFrames.party, "party")
			end

			ShadowUF.modules.movers:Update()
		end,
		get = function(info)
			return ShadowUF.db.profile.units[info[#(info)]].enabled
		end,
		desc = function(info)
			local unit = info[#(info)]
			local unitDesc = UNIT_DESC[unit] or ""

			if( ShadowUF.db.profile.units[unit].enabled and ShadowUF.Units.childUnits[unit] ) then
				if( unitDesc ~= "" ) then unitDesc = unitDesc .. "\n\n" end
				return unitDesc .. string.format(L["This unit depends on another to work, disabling %s will disable %s."], L.units[ShadowUF.Units.childUnits[unit]], L.units[unit])
			elseif( not ShadowUF.db.profile.units[unit].enabled ) then
				for child, parent in pairs(ShadowUF.Units.childUnits) do
					if( parent == unit ) then
						if( unitDesc ~= "" ) then unitDesc = unitDesc .. "\n\n" end
						return unitDesc .. L["This unit has child units that depend on it, you need to enable this unit before you can enable its children."]
					end
				end
			end

			return unitDesc ~= "" and unitDesc
		end,
		disabled = function(info)
			local unit = info[#(info)]
			if( ShadowUF.Units.childUnits[unit] ) then
				return not ShadowUF.db.profile.units[ShadowUF.Units.childUnits[unit]].enabled
			end

			return false
		end,
	}

	local unitCategory = {
		order = function(info)
			local cat = info[#(info)]
			return cat == "playercat" and 50 or cat == "generalcat" and 100 or cat == "partycat" and 200 or cat == "raidcat" and 300 or cat == "raidmisccat" and 400 or cat == "bosscat" and 500 or cat == "arenacat" and 600 or 700
		end,
		type = "header",
		name = function(info)
			local cat = info[#(info)]
			return cat == "playercat" and L["Player"] or cat == "generalcat" and L["General"] or cat == "raidcat" and L["Raid"] or cat == "partycat" and L["Party"] or cat == "arenacat" and L["Arena"] or cat == "battlegroundcat" and L["Battlegrounds"] or cat == "raidmisccat" and L["Raid Misc"] or cat == "bosscat" and L["Boss"]
		end,
		width = "full",
	}

	for cat, list in pairs(unitCategories) do
		options.args.enableUnits.args.enabled.args[cat .. "cat"] = unitCategory

		for _, unit in pairs(list) do
			unitCatOrder[unit] = cat == "player" and 50 or cat == "general" and 100 or cat == "party" and 200 or cat == "raid" and 300 or cat == "raidmisc" and 400 or cat == "boss" and 500 or cat == "arena" and 600 or 700
		end
	end

	for order, unit in pairs(ShadowUF.unitList) do
		options.args.enableUnits.args.enabled.args[unit] = enabledUnits
		options.args.units.args.global.args.units.args.units.args[unit] = perUnitList
		options.args.units.args[unit] = Config.unitTable

		unitCatOrder[unit] = unitCatOrder[unit] or 100
	end
end

---------------------
-- FILTER CONFIGURATION
---------------------
local function loadFilterOptions()
	local hasWhitelist, hasBlacklist, hasOverridelist, rebuildFilters
	local filterMap, spellMap = {}, {}

	local manageFiltersTable = {
		order = function(info) return info[#(info)] == "whitelists" and 1 or info[#(info)] == "blacklists" and 2 or 3 end,
		type = "group",
		name = function(info) return info[#(info)] == "whitelists" and L["Whitelists"] or info[#(info)] == "blacklists" and L["Blacklists"] or L["Override lists"] end,
		args = {
		},
	}

	local function reloadUnitAuras()
		for _, frame in pairs(ShadowUF.Units.unitFrames) do
			if( UnitExists(frame.unit) and frame.visibility.auras ) then
				ShadowUF.modules.auras:UpdateFilter(frame)
				frame:FullUpdate()
			end
		end
	end

	local function setFilterType(info, value)
		local filter = filterMap[info[#(info) - 2]]
		local filterType = info[#(info) - 3]

		ShadowUF.db.profile.filters[filterType][filter][info[#(info)]] = value
		reloadUnitAuras()
	end

	local function getFilterType(info)
		local filter = filterMap[info[#(info) - 2]]
		local filterType = info[#(info) - 3]

		return ShadowUF.db.profile.filters[filterType][filter][info[#(info)]]
	end

	--- Container widget for the filter listing
	local filterEditTable = {
		order = 0,
		type = "group",
		name = function(info) return filterMap[info[#(info)]] end,
		hidden = function(info) return not ShadowUF.db.profile.filters[info[#(info) - 1]][filterMap[info[#(info)]]] end,
		args = {
			general = {
				order = 0,
				type = "group",
				name = function(info) return filterMap[info[#(info) - 1]] end,
				hidden = false,
				inline = true,
				args = {
					add = {
						order = 0,
						type = "input",
						name = L["Aura name or spell ID"],
						--dialogControl = "Aura_EditBox",
						hidden = false,
						set = function(info, value)
							local filterType = info[#(info) - 3]
							local filter = filterMap[info[#(info) - 2]]

							ShadowUF.db.profile.filters[filterType][filter][value] = true

							reloadUnitAuras()
							rebuildFilters()
						end,
					},
					delete = {
						order = 1,
						type = "execute",
						name = L["Delete filter"],
						hidden = false,
						confirmText = L["Are you sure you want to delete this filter?"],
						confirm = true,
						func = function(info, value)
							local filterType = info[#(info) - 3]
							local filter = filterMap[info[#(info) - 2]]

							ShadowUF.db.profile.filters[filterType][filter] = nil

							-- Delete anything that used this filter too
							local filterList = filterType == "whitelists" and ShadowUF.db.profile.filters.zonewhite or filterType == "blacklists" and ShadowUF.db.profile.filters.zoneblack or filterType == "overridelists" and ShadowUF.db.profile.filters.zoneoverride
							if filterList then
								for id, filterUsed in pairs(filterList) do
									if( filterUsed == filter ) then
										filterList[id] = nil
									end
								end
							end

							reloadUnitAuras()
							rebuildFilters()
						end,
					},
				},
			},
			filters = {
				order = 2,
				type = "group",
				inline = true,
				hidden = false,
				name = L["Aura types to filter"],
				args = {
					buffs = {
						order = 4,
						type = "toggle",
						name = L["Buffs"],
						desc = L["When this filter is active, apply the filter to buffs."],
						set = setFilterType,
						get = getFilterType,
					},
					debuffs = {
						order = 5,
						type = "toggle",
						name = L["Debuffs"],
						desc = L["When this filter is active, apply the filter to debuffs."],
						set = setFilterType,
						get = getFilterType,
					},
				},
			},
			spells = {
				order = 3,
				type = "group",
				inline = true,
				name = L["Auras"],
				hidden = false,
				args = {

				},
			},
		},
	}

	-- Spell list for manage aura filters
	local spellLabel = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) end,
		type = "description",
		width = "double",
		fontSize = "medium",
		name = function(info)
				local name = spellMap[info[#(info)]]
				if tonumber(name) then
					local spellName, _, icon = GetSpellInfo(name)
					name = string.format("|T%s:14:14:0:0|t %s (#%i)", icon or "Interface\\Icons\\Inv_misc_questionmark", spellName or L["Unknown"], name)
				end
				return name
			end,
	}

	local spellRow = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) + 0.5 end,
		type = "execute",
		name = L["Delete"],
		width = "half",
		func = function(info)
			local spell = spellMap[info[#(info)]]
			local filter = filterMap[info[#(info) - 2]]
			local filterType = info[#(info) - 3]

			ShadowUF.db.profile.filters[filterType][filter][spell] = nil

			reloadUnitAuras()
			rebuildFilters()
		end
	}

	local noSpells = {
		order = 0,
		type = "description",
		name = L["This filter has no auras in it, you will have to add some using the dialog above."],
	}

	-- The filter [View] widgets for manage aura filters
	local filterLabel = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) end,
		type = "description",
		width = "", -- Odd I know, AceConfigDialog-3.0 expands descriptions to full width if width is nil
		fontSize = "medium",
		name = function(info) return filterMap[info[#(info)]] end,
	}

	local filterRow = {
		order = function(info) return tonumber(string.match(info[#(info)], "(%d+)")) + 0.5 end,
		type = "execute",
		name = L["View"],
		width = "half",
		func = function(info)
			local filterType = info[#(info) - 2]

			AceDialog.Status.ShadowedUF.children.filter.children.filters.status.groups.groups[filterType] = true
			selectTabGroup("filter", "filters", filterType .. "\001" .. string.match(info[#(info)], "(%d+)"))
		end
	}

	local noFilters = {
		order = 0,
		type = "description",
		name = L["You do not have any filters of this type added yet, you will have to create one in the management panel before this page is useful."],
	}

	-- Container table for a filter zone
	local globalSettings = {}
	local zoneList = {"none", "pvp", "arena", "party", "raid"}
	local filterTable = {
		order = function(info) return info[#(info)] == "global" and 1 or info[#(info)] == "none" and 2 or 3 end,
		type = "group",
		inline = true,
		hidden = function() return not hasWhitelist and not hasBlacklist and not hasOverridelist end,
		name = function(info) return AREA_NAMES[info[#(info)]] or L["Global"] end,
		set = function(info, value)
			local filter = filterMap[info[#(info)]]
			local zone = info[#(info) - 1]
			local unit = info[#(info) - 2]
			local filterKey = ShadowUF.db.profile.filters.whitelists[filter] and "zonewhite" or ShadowUF.db.profile.filters.blacklists[filter] and "zoneblack" or "zoneoverride"

			for _, zoneConfig in pairs(zoneList) do
				if( zone == "global" or zoneConfig == zone ) then
					if( unit == "global" ) then
						globalSettings[zoneConfig .. filterKey] = value and filter or false

						for _, unitEntry in pairs(ShadowUF.unitList) do
							ShadowUF.db.profile.filters[filterKey][zoneConfig .. unitEntry] = value and filter or nil
						end
					else
						ShadowUF.db.profile.filters[filterKey][zoneConfig .. unit] = value and filter or nil
					end
				end
			end

			if( zone == "global" ) then
				globalSettings[zone .. unit .. filterKey] = value and filter or false
			end

			reloadUnitAuras()
		end,
		get = function(info)
			local filter = filterMap[info[#(info)]]
			local zone = info[#(info) - 1]
			local unit = info[#(info) - 2]

			if( unit == "global" or zone == "global" ) then
				local id = zone == "global" and zone .. unit or zone
				local filterKey = ShadowUF.db.profile.filters.whitelists[filter] and "zonewhite" or ShadowUF.db.profile.filters.blacklists[filter] and "zoneblack" or "zoneoverride"

				if( info[#(info)] == "nofilter" ) then
					return globalSettings[id .. "zonewhite"] == false and globalSettings[id .. "zoneblack"] == false and globalSettings[id .. "zoneoverride"] == false
				end

				return globalSettings[id .. filterKey] == filter
			end

			if( info[#(info)] == "nofilter" ) then
				return not ShadowUF.db.profile.filters.zonewhite[zone .. unit] and not ShadowUF.db.profile.filters.zoneblack[zone .. unit] and not ShadowUF.db.profile.filters.zoneoverride[zone .. unit]
			end

			return ShadowUF.db.profile.filters.zonewhite[zone .. unit] == filter or ShadowUF.db.profile.filters.zoneblack[zone .. unit] == filter or ShadowUF.db.profile.filters.zoneoverride[zone .. unit] == filter
		end,
		args = {
			nofilter = {
				order = 0,
				type = "toggle",
				name = L["Don't use a filter"],
				hidden = false,
				set = function(info, value)
					local filter = filterMap[info[#(info)]]
					local zone = info[#(info) - 1]
					local unit = info[#(info) - 2]

					for _, zoneConfig in pairs(zoneList) do
						if( zone == "global" or zoneConfig == zone ) then
							if( unit == "global" ) then
								globalSettings[zoneConfig .. "zonewhite"] = false
								globalSettings[zoneConfig .. "zoneblack"] = false
								globalSettings[zoneConfig .. "zoneoverride"] = false

								for _, unitEntry in pairs(ShadowUF.unitList) do
									ShadowUF.db.profile.filters.zonewhite[zoneConfig .. unitEntry] = nil
									ShadowUF.db.profile.filters.zoneblack[zoneConfig .. unitEntry] = nil
									ShadowUF.db.profile.filters.zoneoverride[zoneConfig .. unitEntry] = nil
								end
							else
								ShadowUF.db.profile.filters.zonewhite[zoneConfig .. unit] = nil
								ShadowUF.db.profile.filters.zoneblack[zoneConfig .. unit] = nil
								ShadowUF.db.profile.filters.zoneoverride[zoneConfig .. unit] = nil
							end
						end
					end

					if( zone == "global" ) then
						globalSettings[zone .. unit .. "zonewhite"] = false
						globalSettings[zone .. unit .. "zoneblack"] = false
						globalSettings[zone .. unit .. "zoneoverride"] = false
					end

					reloadUnitAuras()
				end,
			},
			white = {
				order = 1,
				type = "header",
				name = "|cffffffff" .. L["Whitelists"] .. "|r",
				hidden = function(info) return not hasWhitelist end
			},
			black = {
				order = 3,
				type = "header",
				name = L["Blacklists"], -- In theory I would make this black, but as black doesn't work with a black background I'll skip that
				hidden = function(info) return not hasBlacklist end
			},
			override = {
				order = 5,
				type = "header",
				name = L["Override lists"], -- In theory I would make this black, but as black doesn't work with a black background I'll skip that
				hidden = function(info) return not hasOverridelist end
			},
		},
	}

	-- Toggle used for set filter zones to enable filters
	local filterToggle = {
		order = function(info) return ShadowUF.db.profile.filters.whitelists[filterMap[info[#(info)]]] and 2 or ShadowUF.db.profile.filters.blacklists[filterMap[info[#(info)]]] and 4 or 6 end,
		type = "toggle",
		name = function(info) return filterMap[info[#(info)]] end,
		desc = function(info)
			local filter = filterMap[info[#(info)]]
			filter = ShadowUF.db.profile.filters.whitelists[filter] or ShadowUF.db.profile.filters.blacklists[filter] or ShadowUF.db.profile.filters.overridelists[filter]
			if( filter.buffs and filter.debuffs ) then
				return L["Filtering both buffs and debuffs"]
			elseif( filter.buffs ) then
				return L["Filtering buffs only"]
			elseif( filter.debuffs ) then
				return L["Filtering debuffs only"]
			end

			return L["This filter has no aura types set to filter out."]
		end,
	}

	-- Load existing filters in
	-- This needs to be cleaned up later
	local filterID, spellID = 0, 0
	local function buildList(type)
		local manageFiltersTableEntry = {
			order = type == "whitelists" and 1 or type == "blacklists" and 2 or 3,
			type = "group",
			name = type == "whitelists" and L["Whitelists"] or type == "blacklists" and L["Blacklists"] or L["Override lists"],
			args = {
				groups = {
					order = 0,
					type = "group",
					inline = true,
					name = function(info) return info[#(info) - 1] == "whitelists" and L["Whitelist filters"] or info[#(info) - 1] == "blacklists" and L["Blacklist filters"] or L["Override list filters"] end,
					args = {
					},
				},
			},
		}

		local hasFilters
		for name, spells in pairs(ShadowUF.db.profile.filters[type]) do
			hasFilters = true
			filterID = filterID + 1
			filterMap[tostring(filterID)] = name
			filterMap[filterID .. "label"] = name
			filterMap[filterID .. "row"] = name

			manageFiltersTableEntry.args[tostring(filterID)] = CopyTable(filterEditTable)
			manageFiltersTableEntry.args.groups.args[filterID .. "label"] = filterLabel
			manageFiltersTableEntry.args.groups.args[filterID .. "row"] = filterRow
			filterTable.args[tostring(filterID)] = filterToggle

			local hasSpells
			for spellName in pairs(spells) do
				if( spellName ~= "buffs" and spellName ~= "debuffs" ) then
					hasSpells = true
					spellID = spellID + 1
					spellMap[tostring(spellID)] = spellName
					spellMap[spellID .. "label"] = spellName

					manageFiltersTableEntry.args[tostring(filterID)].args.spells.args[spellID .. "label"] = spellLabel
					manageFiltersTableEntry.args[tostring(filterID)].args.spells.args[tostring(spellID)] = spellRow
				end
			end

			if( not hasSpells ) then
				manageFiltersTableEntry.args[tostring(filterID)].args.spells.args.noSpells = noSpells
			end
		end

		if( not hasFilters ) then
			if( type == "whitelists" ) then hasWhitelist = nil elseif( type == "blacklists" ) then hasBlacklist = nil else hasOverridelist = nil end
			manageFiltersTableEntry.args.groups.args.noFilters = noFilters
		end

		return manageFiltersTableEntry
	end

	rebuildFilters = function()
		for id in pairs(filterMap) do filterTable.args[id] = nil end

		spellID = 0
		filterID = 0
		hasBlacklist = true
		hasWhitelist = true
		hasOverridelist = true

		table.wipe(filterMap)
		table.wipe(spellMap)

		options.args.filter.args.filters.args.whitelists = buildList("whitelists")
		options.args.filter.args.filters.args.blacklists = buildList("blacklists")
		options.args.filter.args.filters.args.overridelists = buildList("overridelists")
	end

	local unitFilterSelection = {
		order = function(info) return info[#(info)] == "global" and 1 or (getUnitOrder(info) + 1) end,
		type = "group",
		name = function(info) return info[#(info)] == "global" and L["Global"] or getName(info) end,
		disabled = function(info)
			if( info[#(info)] == "global" ) then
				return false
			end

			return not hasWhitelist and not hasBlacklist
		end,
		args = {
			help = {
				order = 0,
				type = "group",
				inline = true,
				name = L["Help"],
				hidden = function() return hasWhitelist or hasBlacklist or hasOverridelist end,
				args = {
					help = {
						type = "description",
						name = L["You will need to create an aura filter before you can set which unit to enable aura filtering on."],
						width = "full",
					}
				},
			},
			header = {
				order = 0,
				type = "header",
				name = function(info) return (info[#(info) - 1] == "global" and L["Global"] or L.units[info[#(info) - 1]]) end,
				hidden = function() return not hasWhitelist and not hasBlacklist and not hasOverridelist end,
			},
			global = filterTable,
			none = filterTable,
			pvp = filterTable,
			arena = filterTable,
			battleground = filterTable,
			party = filterTable,
			raid = filterTable,
		}
	}

	local addFilter = {type = "whitelists"}

	options.args.filter = {
		type = "group",
		name = L["Aura Filters"],
		childGroups = "tab",
		desc = getPageDescription,
		args = {
			groups = {
				order = 1,
				type = "group",
				name = L["Set Filter Zones"],
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								type = "description",
								name = L["You can set what unit frame should use what filter group and in what zone type here, if you want to change what auras goes into what group then see the \"Manage aura groups\" option."],
								width = "full",
							}
						},
					},
				}
			},
			filters = {
				order = 2,
				type = "group",
				name = L["Manage Aura Filters"],
				childGroups = "tree",
				args = {
					manage = {
						order = 1,
						type = "group",
						name = L["Management"],
						args = {
							help = {
								order = 0,
								type = "group",
								inline = true,
								name = L["Help"],
								args = {
									help = {
										type = "description",
										name = L["Whitelists will hide any aura not in the filter group.|nBlacklists will hide auras that are in the filter group.|nOverride lists will bypass any filter and always be shown."],
										width = "full",
									}
								},
							},
							error = {
								order = 1,
								type = "group",
								inline = true,
								hidden = function() return not addFilter.error end,
								name = L["Error"],
								args = {
									error = {
										order = 0,
										type = "description",
										name = function() return addFilter.error end,
										width = "full",
									},
								},
							},
							add = {
								order = 2,
								type = "group",
								inline = true,
								name = L["New filter"],
								get = function(info) return addFilter[info[#(info)]] end,
								args = {
									name = {
										order = 0,
										type = "input",
										name = L["Name"],
										set = function(info, value)
											addFilter[info[#(info)]] = string.trim(value) ~= "" and value or nil
											addFilter.error = nil
										end,
										get = function(info) return addFilter.errorName or addFilter.name end,
										validate = function(info, value)
											local name = string.lower(string.trim(value))
											for filter in pairs(ShadowUF.db.profile.filters.whitelists) do
												if( string.lower(filter) == name ) then
													addFilter.error = string.format(L["The whitelist \"%s\" already exists."], value)
													addFilter.errorName = value
													AceRegistry:NotifyChange("ShadowedUF")
													return ""
												end
											end

											for filter in pairs(ShadowUF.db.profile.filters.blacklists) do
												if( string.lower(filter) == name ) then
													addFilter.error = string.format(L["The blacklist \"%s\" already exists."], value)
													addFilter.errorName = value
													AceRegistry:NotifyChange("ShadowedUF")
													return ""
												end
											end

											for filter in pairs(ShadowUF.db.profile.filters.overridelists) do
												if( string.lower(filter) == name ) then
													addFilter.error = string.format(L["The override list \"%s\" already exists."], value)
													addFilter.errorName = value
													AceRegistry:NotifyChange("ShadowedUF")
													return ""
												end
											end

											addFilter.error = nil
											addFilter.errorName = nil
											return true
										end,
									},
									type = {
										order = 1,
										type = "select",
										name = L["Filter type"],
										set = function(info, value) addFilter[info[#(info)]] = value end,
										values = {["whitelists"] = L["Whitelist"], ["blacklists"] = L["Blacklist"], ["overridelists"] = L["Override list"]},
									},
									add = {
										order = 2,
										type = "execute",
										name = L["Create"],
										disabled = function(info) return not addFilter.name end,
										func = function(info)
											ShadowUF.db.profile.filters[addFilter.type][addFilter.name] = {buffs = true, debuffs = true}
											rebuildFilters()

											local id
											for key, value in pairs(filterMap) do
												if( value == addFilter.name ) then
													id = key
													break
												end
											end

											AceDialog.Status.ShadowedUF.children.filter.children.filters.status.groups.groups[addFilter.type] = true
											selectTabGroup("filter", "filters", addFilter.type .. "\001" .. id)

											table.wipe(addFilter)
											addFilter.type = "whitelists"
										end,
									},
								},
							},
						},
					},
				},
			},
		},
	}


	options.args.filter.args.groups.args.global = unitFilterSelection
	for _, unit in pairs(ShadowUF.unitList) do
		options.args.filter.args.groups.args[unit] = unitFilterSelection
	end

	rebuildFilters()
end

---------------------
-- TAG CONFIGURATION
---------------------
local function loadTagOptions()
	local tagData = {search = ""}
	local function set(info, value, key)
		key = key or info[#(info)]
		if( ShadowUF.Tags.defaultHelp[tagData.name] ) then
			return
		end

		-- Reset loaded function + reload tags
		if( key == "funct" ) then
			ShadowUF.tagFunc[tagData.name] = nil
			ShadowUF.Tags:Reload()
		elseif( key == "category" ) then
			local cat = ShadowUF.db.profile.tags[tagData.name][key]
			if( cat and cat ~= value ) then
				Config.tagTextTable.args[cat].args[tagData.name] = nil
				Config.tagTextTable.args[value].args[tagData.name] = Config.tagTable
			end
		end

		ShadowUF.db.profile.tags[tagData.name][key] = value
	end

	local function stripCode(text)
		if( not text ) then
			return ""
		end

		return string.gsub(string.gsub(text, "|", "||"), "\t", "")
	end

	local function get(info, key)
		key = key or info[#(info)]

		if( key == "help" and ShadowUF.Tags.defaultHelp[tagData.name] ) then
			return ShadowUF.Tags.defaultHelp[tagData.name] or ""
		elseif( key == "events" and ShadowUF.Tags.defaultEvents[tagData.name] ) then
			return ShadowUF.Tags.defaultEvents[tagData.name] or ""
		elseif( key == "frequency" and ShadowUF.Tags.defaultFrequents[tagData.name] ) then
			return ShadowUF.Tags.defaultFrequents[tagData.name] or ""
		elseif( key == "category" and ShadowUF.Tags.defaultCategories[tagData.name] ) then
			return ShadowUF.Tags.defaultCategories[tagData.name] or ""
		elseif( key == "name" and ShadowUF.Tags.defaultNames[tagData.name] ) then
			return ShadowUF.Tags.defaultNames[tagData.name] or ""
		elseif( key == "funct" and ShadowUF.Tags.defaultTags[tagData.name] ) then
			return ShadowUF.Tags.defaultTags[tagData.name] or ""
		end

		return ShadowUF.db.profile.tags[tagData.name] and ShadowUF.db.profile.tags[tagData.name][key] or ""
	end

	local function isSearchHidden(info)
		return tagData.search ~= "" and not string.match(info[#(info)], tagData.search) or false
	end

	local function editTag(info)
		tagData.name = info[#(info)]

		if( ShadowUF.Tags.defaultHelp[tagData.name] ) then
			tagData.error = L["You cannot edit this tag because it is one of the default ones included in this mod. This function is here to provide an example for your own custom tags."]
		else
			tagData.error = nil
		end

		selectDialogGroup("tags", "edit")
	end

	-- Create all of the tag editor options, if it's a default tag will show it after any custom ones
	local tagTable = {
		type = "execute",
		order = function(info) return ShadowUF.Tags.defaultTags[info[#(info)]] and 100 or 1 end,
		name = getTagName,
		desc = getTagHelp,
		hidden = isSearchHidden,
		func = editTag,
	}

	local tagCategories = {}
	local function getTagCategories(info)
		for k in pairs(tagCategories) do tagCategories[k] = nil end

		for _, cat in pairs(ShadowUF.Tags.defaultCategories) do
			tagCategories[cat] = TAG_GROUPS[cat]
		end

		return tagCategories
	end

	-- Tag configuration
	options.args.tags = {
		type = "group",
		childGroups = "tab",
		name = L["Add Tags"],
		desc = getPageDescription,
		hidden = hideAdvancedOption,
		args = {
			general = {
				order = 0,
				type = "group",
				name = L["Tag list"],
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						hidden = function() return ShadowUF.db.profile.advanced end,
						args = {
							description = {
								order = 0,
								type = "description",
								name = L["You can add new custom tags through this page, if you're looking to change what tags are used in text look under the Text tab for an Units configuration."],
							},
						},
					},
					search = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Search"],
						args = {
							search = {
								order = 1,
								type = "input",
								name = L["Search tags"],
								set = function(info, text) tagData.search = text end,
								get = function(info) return tagData.search end,
							},
						},
					},
					list = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Tags"],
						args = {},
					},
				},
			},
			add = {
				order = 1,
				type = "group",
				name = L["Add new tag"],
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can find more information on creating your own custom tags in the \"Help\" tab above."],
							},
						},
					},
					add = {
						order = 1,
						type = "group",
						inline = true,
						name = L["Add new tag"],
						args = {
							error = {
								order = 0,
								type = "description",
								name = function() return tagData.addError or "" end,
								hidden = function() return not tagData.addError end,
							},
							errorHeader = {
								order = 0.50,
								type = "header",
								name = "",
								hidden = function() return not tagData.addError end,
							},
							tag = {
								order = 1,
								type = "input",
								name = L["Tag name"],
								desc = L["Tag that you will use to access this code, do not wrap it in brackets or parenthesis it's automatically done. For example, you would enter \"foobar\" and then access it with [foobar]."],
								validate = function(info, text)
									if( text == "" ) then
										tagData.addError = L["You must enter a tag name."]
									elseif( string.match(text, "[%[%]%(%)]") ) then
										tagData.addError = string.format(L["You cannot name a tag \"%s\", tag names should contain no brackets or parenthesis."], text)
									elseif( ShadowUF.tagFunc[text] ) then
										tagData.addError = string.format(L["The tag \"%s\" already exists."], text)
									else
										tagData.addError = nil
									end

									AceRegistry:NotifyChange("ShadowedUF")
									return tagData.addError and "" or true
								end,
								set = function(info, tag)
									tagData.name = tag
									tagData.error = nil
									tagData.addError = nil

									ShadowUF.db.profile.tags[tag] = {func = "function(unit, unitOwner)\n\nend", category = "misc"}
									options.args.tags.args.general.args.list.args[tag] = tagTable
									Config.tagTextTable.args.misc.args[tag] = Config.tagTable

									selectDialogGroup("tags", "edit")
								end,
							},
						},
					},
				},
			},
			edit = {
				order = 2,
				type = "group",
				name = L["Edit tag"],
				hidden = function() return not tagData.name end,
				args = {
					help = {
						order = 0,
						type = "group",
						inline = true,
						name = L["Help"],
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can find more information on creating your own custom tags in the \"Help\" tab above.|nSUF will attempt to automatically detect what events your tag will need, so you do not generally need to fill out the events field."],
							},
						},
					},
					tag = {
						order = 1,
						type = "group",
						inline = true,
						name = function() return string.format(L["Editing %s"], tagData.name or "") end,
						args = {
							error = {
								order = 0,
								type = "description",
								name = function()
									if( tagData.error ) then
										return "|cffff0000" .. tagData.error .. "|r"
									end
									return ""
								end,
								hidden = function() return not tagData.error end,
							},
							errorHeader = {
								order = 1,
								type = "header",
								name = "",
								hidden = function() return not tagData.error end,
							},
							discovery = {
								order = 1,
								type = "toggle",
								name = L["Disable event discovery"],
								desc = L["This will disable the automatic detection of what events this tag will need, you should leave this unchecked unless you know what you are doing."],
								set = function(info, value) tagData.discovery = value end,
								get = function() return tagData.discovery end,
								width = "full",
							},
							frequencyEnable = {
								order = 1.10,
								type = "toggle",
								name = L["Enable frequent updates"],
								desc = L["Flags the tag for frequent updating, it will update the tag on a timer regardless of any events firing."],
								set = function(info, value)
									tagData.frequency = value and 5 or nil
									set(info, tagData.frequency, "frequency")
								end,
								get = function(info) return get(info, "frequency") ~= "" and true or false end,
								width = "full",
							},
							frequency = {
								order = 1.20,
								type = "input",
								name = L["Update interval"],
								desc = L["How many seconds between updates.|n[WARNING] By setting the frequency to 0 it will update every single frame redraw, if you want to disable frequent updating uncheck it don't set this to 0."],
								disabled = function(info) return get(info) == "" end,
								validate = function(info, value)
									value = tonumber(value)
									if( not value ) then
										tagData.error = L["Invalid interval entered, must be a number."]
									elseif( value < 0 ) then
										tagData.error = L["You must enter a number that is 0 or higher, negative numbers are not allowed."]
									else
										tagData.error = nil
									end

									if( tagData.error ) then
										AceRegistry:NotifyChange("ShadowedUF")
										return ""
									end

									return true
								end,
								set = function(info, value)
									tagData.frequency = tonumber(value)
									tagData.frequency = tagData.frequency < 0 and 0 or tagData.frequency

									set(info, tagData.frequency)
								end,
								get = function(info) return tostring(get(info) or "") end,
								width = "half",
							},
							name = {
								order = 2,
								type = "input",
								name = L["Tag name"],
								set = set,
								get = get,
							},
							category = {
								order = 2.5,
								type = "select",
								name = L["Category"],
								values = getTagCategories,
								set = set,
								get = get,
							},

							sep = {
								order = 2.75,
								type = "description",
								name = "",
								width = "full",
							},
							events = {
								order = 3,
								type = "input",
								name = L["Events"],
								desc = L["Events that should be used to trigger an update of this tag. Separate each event with a single space."],
								width = "full",
								validate = function(info, text)
									if( ShadowUF.Tags.defaultTags[tagData.name] ) then
										return true
									end

									if( text == "" or string.match(text, "[^_%a%s]") ) then
										tagData.error = L["You have to set the events to fire, you can only enter letters and underscores, \"FOO_BAR\" for example is valid, \"APPLE_5_ORANGE\" is not because it contains a number."]
										tagData.eventError = text
										AceRegistry:NotifyChange("ShadowedUF")
										return ""
									end

									tagData.eventError = text
									tagData.error = nil
									return true
								end,
								set = set,
								get = function(info)
									if( tagData.eventError ) then
										return tagData.eventError
									end

									return get(info)
								end,
							},
							func = {
								order = 4,
								type = "input",
								multiline = true,
								name = L["Code"],
								desc = L["Your code must be wrapped in a function, for example, if you were to make a tag to return the units name you would do:|n|nfunction(unit, unitOwner)|nreturn UnitName(unitOwner)|nend"],
								width = "full",
								validate = function(info, text)
									if( ShadowUF.Tags.defaultTags[tagData.name] ) then
										return true
									end

									local funct, msg = loadstring("return " .. text)
									if( not string.match(text, "function") ) then
										tagData.error = L["You must wrap your code in a function."]
										tagData.funcError = text
									elseif( not funct and msg ) then
										tagData.error = string.format(L["Failed to save tag, error:|n %s"], msg)
										tagData.funcError = text
									else
										tagData.error = nil
										tagData.funcError = nil
									end

									AceRegistry:NotifyChange("ShadowedUF")
									return tagData.error and "" or true
								end,
								set = function(info, value)
									value = string.gsub(value, "||", "|")
									set(info, value)

									-- Try and automatically identify the events this tag is going to want to use
									if( not tagData.discovery ) then
										tagData.eventError = nil
										ShadowUF.db.profile.tags[tagData.name].events = ShadowUF.Tags:IdentifyEvents(value) or ""
									end

									ShadowUF.Tags:Reload(tagData.name)
								end,
								get = function(info)
									if( tagData.funcError ) then
										return stripCode(tagData.funcError)
									end
									return stripCode(ShadowUF.Tags.defaultTags[tagData.name] or ( ShadowUF.db.profile.tags[tagData.name] and ShadowUF.db.profile.tags[tagData.name].func))
								end,
							},
							delete = {
								order = 5,
								type = "execute",
								name = L["Delete"],
								hidden = function() return ShadowUF.Tags.defaultTags[tagData.name] end,
								confirm = true,
								confirmText = L["Are you sure you want to delete this tag?"],
								func = function(info)
									local category = ShadowUF.db.profile.tags[tagData.name].category
									if( category ) then
										Config.tagTextTable.args[category].args[tagData.name] = nil
									end

									options.args.tags.args.general.args.list.args[tagData.name] = nil

									ShadowUF.db.profile.tags[tagData.name] = nil
									ShadowUF.tagFunc[tagData.name] = nil
									ShadowUF.Tags:Reload(tagData.name)

									tagData.name = nil
									tagData.error = nil
									selectDialogGroup("tags", "general")
								end,
							},
						},
					},
				},
			},
			help = {
				order = 3,
				type = "group",
				name = L["Help"],
				args = {
					general = {
						order = 0,
						type = "group",
						name = L["General"],
						inline = true,
						args = {
							general = {
								order = 0,
								type = "description",
								name = L["See the documentation below for information and examples on creating tags, if you just want basic Lua or WoW API information then see the Programming in Lua and WoW Programming links."],
							},
						},
					},
					documentation = {
						order = 1,
						type = "group",
						name = L["Documentation"],
						inline = true,
						args = {
							doc = {
								order = 0,
								type = "input",
								name = L["Documentation"],
								set = false,
								get = function() return "http://wiki.github.com/Shadowed/ShadowedUnitFrames/tag-documentation" end,
								width = "full",
							},
						},
					},
					resources = {
						order = 2,
						type = "group",
						inline = true,
						name = L["Resources"],
						args = {
							lua = {
								order = 0,
								type = "input",
								name = L["Programming in Lua"],
								desc = L["This is a good guide on how to get started with programming in Lua, while you do not need to read the entire thing it is a helpful for understanding the basics of Lua syntax and API's."],
								set = false,
								get = function() return "http://www.lua.org/pil/" end,
								width = "full",
							},
							wow = {
								order = 1,
								type = "input",
								name = L["WoW Programming"],
								desc = L["WoW Programming is a good resource for finding out what difference API's do and how to call them."],
								set = false,
								get = function() return "http://wowprogramming.com/docs" end,
								width = "full",
							},
						},
					},
				},
			},
		},
	}

	-- Load the initial tag list
	for tag in pairs(ShadowUF.Tags.defaultTags) do
		options.args.tags.args.general.args.list.args[tag] = tagTable
	end

	for tag, data in pairs(ShadowUF.db.profile.tags) do
		options.args.tags.args.general.args.list.args[tag] = tagTable
	end
end

---------------------
-- VISIBILITY OPTIONS
---------------------
local function loadVisibilityOptions()
	-- As zone units are only enabled in a certain zone... it's pointless to provide visibility options for them
	local unitBlacklist = {}
	for unit in pairs(ShadowUF.Units.zoneUnits) do unitBlacklist[unit] = true end
	for unit, parent in pairs(ShadowUF.Units.childUnits) do
		if( ShadowUF.Units.zoneUnits[parent] ) then
			unitBlacklist[unit] = true
		end
	end

	local globalVisibility = {}
	local function set(info, value)
		local key = info[#(info)]
		local unit = info[#(info) - 1]
		local area = info[#(info) - 2]

		if( key == "enabled" ) then
			key = ""
		end

		if( value == nil ) then
			value = false
		elseif( value == false ) then
			value = nil
		end

		for _, configUnit in pairs(ShadowUF.unitList) do
			if( ( configUnit == unit or unit == "global" ) and not unitBlacklist[configUnit] ) then
				ShadowUF.db.profile.visibility[area][configUnit .. key] = value
			end
		end

		-- Annoying yes, but only way that works
		ShadowUF.Units:CheckPlayerZone(true)

		if( unit == "global" ) then
			globalVisibility[area .. key] = value
		end
	end

	local function get(info)
		local key = info[#(info)]
		local unit = info[#(info) - 1]
		local area = info[#(info) - 2]

		if( key == "enabled" ) then
			key = ""
		end

		if( unit == "global" ) then
			if( globalVisibility[area .. key] == false ) then
				return nil
			elseif( globalVisibility[area .. key] == nil ) then
				return false
			end

			return globalVisibility[area .. key]
		elseif( ShadowUF.db.profile.visibility[area][unit .. key] == false ) then
			return nil
		elseif( ShadowUF.db.profile.visibility[area][unit .. key] == nil ) then
			return false
		end

		return ShadowUF.db.profile.visibility[area][unit .. key]
	end

	local function getHelp(info)
		local unit = info[#(info) - 1]
		local area  = info[#(info) - 2]
		local key = info[#(info)]
		if( key == "enabled" ) then
			key = ""
		end

		local current
		if( unit == "global" ) then
			current = globalVisibility[area .. key]
		else
			current = ShadowUF.db.profile.visibility[area][unit .. key]
		end

		if( current == false ) then
			return string.format(L["Disabled in %s"], AREA_NAMES[area])
		elseif( current == true ) then
			return string.format(L["Enabled in %s"], AREA_NAMES[area])
		end

		return L["Using unit settings"]
	end

	local areaTable = {
		type = "group",
		order = function(info) return info[#(info)] == "none" and 2 or 1 end,
		childGroups = "tree",
		name = function(info)
			return AREA_NAMES[info[#(info)]]
		end,
		get = get,
		set = set,
		args = {},
	}

	Config.visibilityTable = {
		type = "group",
		order = function(info) return info[#(info)] == "global" and 1 or (getUnitOrder(info) + 1) end,
		name = function(info) return info[#(info)] == "global" and L["Global"] or getName(info) end,
		args = {
			help = {
				order = 0,
				type = "group",
				name = L["Help"],
				inline = true,
				hidden = hideBasicOption,
				args = {
					help = {
						order = 0,
						type = "description",
						name = function(info)
							return string.format(L["Disabling a module on this page disables it while inside %s. Do not disable a module here if you do not want this to happen!."], string.lower(AREA_NAMES[info[2]]))
						end,
					},
				},
			},
			enabled = {
				order = 0.25,
				type = "toggle",
				name = function(info)
					local unit = info[#(info) - 1]
					if( unit == "global" ) then return "" end
					return string.format(L["%s frames"], L.units[unit])
				end,
				hidden = function(info) return info[#(info) - 1] == "global" end,
				desc = getHelp,
				tristate = true,
				width = "double",
			},
			sep = {
				order = 0.5,
				type = "description",
				name = "",
				width = "full",
				hidden = function(info) return info[#(info) - 1] == "global" end,
			},
		}
	}

	local moduleTable = {
		order = 1,
		type = "toggle",
		name = getName,
		desc = getHelp,
		tristate = true,
		hidden = function(info)
			if( info[#(info) - 1] == "global" ) then return false end
			return hideRestrictedOption(info)
		end,
		arg = 1,
	}

	for key, module in pairs(ShadowUF.modules) do
		if( module.moduleName ) then
			Config.visibilityTable.args[key] = moduleTable
		end
	end

	areaTable.args.global = Config.visibilityTable
	for _, unit in pairs(ShadowUF.unitList) do
		if( not unitBlacklist[unit] ) then
			areaTable.args[unit] = Config.visibilityTable
		end
	end

	options.args.visibility = {
		type = "group",
		childGroups = "tab",
		name = L["Zone Configuration"],
		desc = getPageDescription,
		args = {
			start = {
				order = 0,
				type = "group",
				name = L["Help"],
				inline = true,
				hidden = hideBasicOption,
				args = {
					help = {
						order = 0,
						type = "description",
						name = L["Gold checkmark - Enabled in this zone / Grey checkmark - Disabled in this zone / No checkmark - Use the default unit settings"],
					},
				},
			},
			pvp = areaTable,
			arena = areaTable,
			party = areaTable,
			raid = areaTable,
		},
	}
end

---------------------
-- AURA INDICATORS OPTIONS
---------------------
local function loadAuraIndicatorsOptions()
	local Indicators = ShadowUF.modules.auraIndicators
	local auraFilters = Indicators.auraFilters

	local unitTable

	local groupAliases = {
		["pvpflags"] = L["PvP Flags"],
		["food"] = L["Food"],
		["miscellaneous"] = L["Miscellaneous"]
	}

	for token, name in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		groupAliases[string.lower(token)] = name
	end

	local groupList = {}
	local function getAuraGroup(info)
		for k in pairs(groupList) do groupList[k] = nil end
		for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
			local aura = Indicators.auraConfig[name]
			groupList[aura.group] = aura.group
		end

		return groupList
	end

	local auraList = {}
	local function getAuraList(info)
		for k in pairs(auraList) do auraList[k] = nil end
		for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
			if( tonumber(name) ) then
				local spellID = name
				name = GetSpellInfo(name) or L["Unknown"]
				auraList[name] = string.format("%s (#%i)", name, spellID)
			else
				auraList[name] = name
			end
		end

		return auraList
	end

	local indicatorList = {}
	local function getIndicatorList(info)
		for k in pairs(indicatorList) do indicatorList[k] = nil end
		indicatorList[""] = L["None (Disabled)"]
		for key, indicator in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
			indicatorList[key] = indicator.name
		end

		return indicatorList
	end

	local function writeAuraTable(name)
		ShadowUF.db.profile.auraIndicators.auras[name] = writeTable(Indicators.auraConfig[name])
		Indicators.auraConfig[name] = nil

		local spellID = tonumber(name)
		if( spellID ) then
			Indicators.auraConfig[spellID] = nil
		end
	end

	local groupMap, auraMap, linkMap = {}, {}, {}
	local groupID, auraID, linkID = 0, 0, 0

	local reverseClassMap = {}
	for token, text in pairs(LOCALIZED_CLASS_NAMES_MALE) do
		reverseClassMap[text] = token
	end

	local function groupName(name)
		local converted = string.lower(string.gsub(name, " ", ""))
		return groupAliases[converted] or name
	end

	-- Actual aura configuration
	local auraGroupTable = {
		order = function(info)
			return reverseClassMap[groupName(groupMap[info[#(info)]])] and 1 or 2
		end,
		type = "group",
		name = function(info)
			local name = groupName(groupMap[info[#(info)]])

			local token = reverseClassMap[name]
			if( not token ) then return name end

			return ShadowUF:Hex(ShadowUF.db.profile.classColors[token]) .. name .. "|r"
		end,
		desc = function(info)
			local group = groupMap[info[#(info)]]
			local totalInGroup = 0
			for _, aura in pairs(Indicators.auraConfig) do
				if( type(aura) == "table" and aura.group == group ) then
					totalInGroup = totalInGroup + 1
				end
			end

			return string.format(L["%d auras in group"], totalInGroup)
		end,
		args = {},
	}

	local auraConfigTable = {
		order = 0,
		type = "group",
		icon = function(info)
			local aura = auraMap[info[#(info)]]
			return tonumber(aura) and (select(3, GetSpellInfo(aura))) or nil
		end,
		name = function(info)
			local aura = auraMap[info[#(info)]]
			return tonumber(aura) and string.format("%s (#%i)", GetSpellInfo(aura) or "Unknown", aura) or aura
		end,
		hidden = function(info)
			local group = groupMap[info[#(info) - 1]]
			local aura = Indicators.auraConfig[auraMap[info[#(info)]]]
			return aura.group ~= group
		end,
		set = function(info, value, g, b, a)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]

			-- So I don't have to load every aura to see if it only triggers if it's missing
			if( key == "missing" ) then
				ShadowUF.db.profile.auraIndicators.missing[aura] = value and true or nil
			-- Changing the color
			elseif( key == "color" ) then
				Indicators.auraConfig[aura].r = value
				Indicators.auraConfig[aura].g = g
				Indicators.auraConfig[aura].b = b
				Indicators.auraConfig[aura].alpha = a

				writeAuraTable(aura)
				ShadowUF.Layout:Reload()
				return
			elseif( key == "selfColor" ) then
				Indicators.auraConfig[aura].selfColor = Indicators.auraConfig[aura].selfColor or {}
				Indicators.auraConfig[aura].selfColor.r = value
				Indicators.auraConfig[aura].selfColor.g = g
				Indicators.auraConfig[aura].selfColor.b = b
				Indicators.auraConfig[aura].selfColor.alpha = a

				writeAuraTable(aura)
				ShadowUF.Layout:Reload()
				return
			end

			Indicators.auraConfig[aura][key] = value
			writeAuraTable(aura)
			ShadowUF.Layout:Reload()
		end,
		get = function(info)
			local aura = auraMap[info[#(info) - 1]]
			local key = info[#(info)]
			local config = Indicators.auraConfig[aura]
			if( key == "color" ) then
				return config.r, config.g, config.b, config.alpha
			elseif( key == "selfColor" ) then
				if( not config.selfColor ) then return 0, 0, 0, 1 end
				return config.selfColor.r, config.selfColor.g, config.selfColor.b, config.selfColor.alpha
			end

			return config[key]
		end,
		args = {
			indicator = {
				order = 1,
				type = "select",
				name = L["Show inside"],
				desc = L["Indicator this aura should be displayed in."],
				values = getIndicatorList,
				hidden = false,
			},
			priority = {
				order = 2,
				type = "range",
				name = L["Priority"],
				desc = L["If multiple auras are shown in the same indicator, the higher priority one is shown first."],
				min = 0, max = 100, step = 1,
				hidden = false,
			},
			sep1 = {
				order = 3,
				type = "description",
				name = "",
				width = "full",
				hidden = false,
			},
			color = {
				order = 4,
				type = "color",
				name = L["Indicator color"],
				desc = L["Solid color to use in the indicator, only used if you do not have use aura icon enabled."],
				disabled = function(info) return Indicators.auraConfig[auraMap[info[#(info) - 1]]].icon end,
				hidden = false,
				hasAlpha = true,
			},
			selfColor = {
				order = 4.5,
				type = "color",
				name = L["Your aura color"],
				desc = L["This color will be used if the indicator shown is your own, only applies if icons are not used.\nHandy if you want to know if a target has a Rejuvenation on them, but you also want to know if you were the one who casted the Rejuvenation."],
				hidden = false,
				disabled = function(info)
					if( Indicators.auraConfig[auraMap[info[#(info) - 1]]].icon ) then return true end
					return Indicators.auraConfig[auraMap[info[#(info) - 1]]].player
				end,
				hasAlpha = true,
			},
			sep2 = {
				order = 5,
				type = "description",
				name = "",
				width = "full",
				hidden = false,
			},
			icon = {
				order = 6,
				type = "toggle",
				name = L["Show aura icon"],
				desc = L["Instead of showing a solid color inside the indicator, the icon of the aura will be shown."],
				hidden = false,
			},
			duration = {
				order = 7,
				type = "toggle",
				name = L["Show aura duration"],
				desc = L["Shows a cooldown wheel on the indicator with how much time is left on the aura."],
				hidden = false,
			},
			player = {
				order = 8,
				type = "toggle",
				name = L["Only show self cast auras"],
				desc = L["Only auras you specifically cast will be shown."],
				hidden = false,
			},
			missing = {
				order = 9,
				type = "toggle",
				name = L["Only show if missing"],
				desc = L["Only active this aura inside an indicator if the group member does not have the aura."],
				hidden = false,
			},
			delete = {
				order = 10,
				type = "execute",
				name = L["Delete"],
				hidden = function(info)
					return ShadowUF.db.defaults.profile.auraIndicators.auras[auraMap[info[#(info) - 1]]]
				end,
				confirm = true,
				confirmText = L["Are you sure you want to delete this aura?"],
				func = function(info)
					local key = info[#(info) - 1]
					local aura = auraMap[key]

					auraGroupTable.args[key] = nil
					ShadowUF.db.profile.auraIndicators.auras[aura] = nil
					ShadowUF.db.profile.auraIndicators.missing[aura] = nil
					Indicators.auraConfig[aura] = nil

					-- Check if the group should disappear
					local groupList = getAuraGroup(info)
					for groupID, name in pairs(groupMap) do
						if( not groupList[name] ) then
							unitTable.args[tostring(groupID)] = nil
							options.args.auraIndicators.args.units.args.global.args.groups.args[tostring(groupID)] = nil
							options.args.auraIndicators.args.auras.args.groups.args[tostring(groupID)] = nil
							groupMap[groupID] = nil
						end
					end

					ShadowUF.Layout:Reload()
				end,
			},
		},
	}

	local auraFilterConfigTable = {
		order = 0,
		type = "group",
		hidden = false,
		name = function(info)
			return ShadowUF.db.profile.auraIndicators.indicators[info[#(info)]].name
		end,
		set = function(info, value)
			local key = info[#(info)]
			local indicator = info[#(info) - 2]
			local filter = info[#(info) - 1]
			ShadowUF.db.profile.auraIndicators.filters[indicator][filter][key] = value
			ShadowUF.Layout:Reload()
		end,
		get = function(info)
			local key = info[#(info)]
			local indicator = info[#(info) - 2]
			local filter = info[#(info) - 1]
			if( not ShadowUF.db.profile.auraIndicators.filters[indicator][filter] ) then
				ShadowUF.db.profile.auraIndicators.filters[indicator][filter] = {}
			end

			return ShadowUF.db.profile.auraIndicators.filters[indicator][filter][key]
		end,
		args = {
			help = {
				order = 0,
				type = "group",
				name = L["Help"],
				inline = true,
				args = {
					help = {
						type = "description",
						name = L["Auras matching a criteria will automatically show up in the indicator when enabled."]
					}
				}
			},
			boss = {
				order = 1,
				type = "group",
				name = L["Boss Auras"],
				inline = true,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Show boss debuffs"],
						desc = L["Shows debuffs cast by a boss."]
					},
					duration = {
						order = 2,
						type = "toggle",
						name = L["Show aura duration"],
						desc = L["Shows a cooldown wheel on the indicator with how much time is left on the aura."]
					},
					priority = {
						order = 3,
						type = "range",
						name = L["Priority"],
						desc = L["If multiple auras are shown in the same indicator, the higher priority one is shown first."],
						min = 0, max = 100, step = 1
					}
				}
			},
			curable = {
				order = 2,
				type = "group",
				name = L["Curable Auras"],
				inline = true,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Show curable debuffs"],
						desc = L["Shows debuffs that you can cure."]
					},
					duration = {
						order = 2,
						type = "toggle",
						name = L["Show aura duration"],
						desc = L["Shows a cooldown wheel on the indicator with how much time is left on the aura."]
					},
					priority = {
						order = 3,
						type = "range",
						name = L["Priority"],
						desc = L["If multiple auras are shown in the same indicator, the higher priority one is shown first."],
						min = 0, max = 100, step = 1
					}
				}
			}
		}
	}

	local indicatorTable = {
		order = 1,
		type = "group",
		name = function(info) return ShadowUF.db.profile.auraIndicators.indicators[info[#(info)]].name end,
		args = {
			config = {
				order = 0,
				type = "group",
				inline = true,
				name = function(info) return ShadowUF.db.profile.auraIndicators.indicators[info[#(info) - 1]].name end,
				set = function(info, value)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]

					ShadowUF.db.profile.auraIndicators.indicators[indicator][key] = value
					ShadowUF.Layout:Reload()
				end,
				get = function(info)
					local indicator = info[#(info) - 2]
					local key = info[#(info)]
					return ShadowUF.db.profile.auraIndicators.indicators[indicator][key]
				end,
				args = {
					showStack = {
						order = 1,
						type = "toggle",
						name = L["Show auras stack"],
						desc = L["Any auras shown in this indicator will have their total stack displayed."],
						width = "full",
					},
					friendly = {
						order = 2,
						type = "toggle",
						name = L["Enable for friendlies"],
						desc = L["Checking this will show the indicator on friendly units."],
					},
					hostile = {
						order = 3,
						type = "toggle",
						name = L["Enable for hostiles"],
						desc = L["Checking this will show the indciator on hostile units."],
					},
					anchorPoint = {
						order = 4,
						type = "select",
						name = L["Anchor point"],
						values = {["BRI"] = L["Inside Bottom Right"], ["BLI"] = L["Inside Bottom Left"], ["TRI"] = L["Inside Top Right"], ["TLI"] = L["Inside Top Left"], ["CLI"] = L["Inside Center Left"], ["C"] = L["Center"], ["CRI"] = L["Inside Center Right"]},
					},
					size = {
						order = 5,
						name = L["Size"],
						type = "range",
						min = 0, max = 50, step = 1,
						set = function(info, value)
							local indicator = info[#(info) - 2]
							ShadowUF.db.profile.auraIndicators.indicators[indicator].height = value
							ShadowUF.db.profile.auraIndicators.indicators[indicator].width = value
							ShadowUF.Layout:Reload()
						end,
						get = function(info)
							local indicator = info[#(info) - 2]
							return ShadowUF.db.profile.auraIndicators.indicators[indicator].height
						end,
					},
					x = {
						order = 6,
						type = "range",
						name = L["X Offset"],
						min = -50, max = 50, step = 1,
					},
					y = {
						order = 7,
						type = "range",
						name = L["Y Offset"],
						min = -50, max = 50, step = 1,
					},
					delete = {
						order = 8,
						type = "execute",
						name = L["Delete"],
						confirm = true,
						confirmText = L["Are you sure you want to delete this indicator?"],
						func = function(info)
							local indicator = info[#(info) - 2]

							options.args.auraIndicators.args.indicators.args[indicator] = nil
							options.args.auraIndicators.args.auras.args.filters.args[indicator] = nil

							ShadowUF.db.profile.auraIndicators.indicators[indicator] = nil
							ShadowUF.db.profile.auraIndicators.filters[indicator] = nil

							-- Any aura that was set to us should be swapped back to none
							for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
								local aura = Indicators.auraConfig[name]
								if( aura.indicator == indicator ) then
									aura.indicator = ""
									writeAuraTable(name)
								end
							end

							ShadowUF.Layout:Reload()
						end,
					},
				},
			},
		},
	}

	local parentLinkTable = {
		order = 3,
		type = "group",
		icon = function(info)
			local aura = auraMap[info[#(info)]]
			return tonumber(aura) and (select(3, GetSpellInfo(aura))) or nil
		end,
		name = function(info)
			local aura = linkMap[info[#(info)]]
			return tonumber(aura) and string.format("%s (#%i)", GetSpellInfo(aura) or "Unknown", aura) or aura
		end,
		args = {},
	}

	local childLinkTable = {
		order = 1,
		icon = function(info)
			local aura = auraMap[info[#(info)]]
			return tonumber(aura) and (select(3, GetSpellInfo(aura))) or nil
		end,
		name = function(info)
			local aura = linkMap[info[#(info)]]
			return tonumber(aura) and string.format("%s (#%i)", GetSpellInfo(aura) or "Unknown", aura) or aura
		end,
		hidden = function(info)
			local aura = linkMap[info[#(info)]]
			local parent = linkMap[info[#(info) - 1]]

			return ShadowUF.db.profile.auraIndicators.linked[aura] ~= parent
		end,
		type = "group",
		inline = true,
		args = {
			delete = {
				type = "execute",
				name = L["Delete link"],
				hidden = false,
				func = function(info)
					local auraID = info[#(info) - 1]
					local aura = linkMap[auraID]
					local parent = ShadowUF.db.profile.auraIndicators.linked[aura]
					ShadowUF.db.profile.auraIndicators.linked[aura] = nil
					parentLinkTable.args[auraID] = nil

					local found
					for _, to in pairs(ShadowUF.db.profile.auraIndicators.linked) do
						if( to == parent ) then
							found = true
							break
						end
					end

					if( not found ) then
						for id, name in pairs(linkMap) do
							if( name == parent ) then
								options.args.auraIndicators.args.linked.args[tostring(id)] = nil
								linkMap[id] = nil
							end
						end
					end

					ShadowUF.Layout:Reload()
				end,
			},
		},
	}

	local addAura, addLink, setGlobalUnits, globalConfig = {}, {}, {}, {}

	-- Per unit enabled status
	unitTable = {
		order = ShadowUF.Config.getUnitOrder or 1,
		type = "group",
		name = function(info) return L.units[info[3]] end,
		hidden = function(info) return not ShadowUF.db.profile.units[info[3]].enabled end,
		desc = function(info)
			local totalDisabled = 0
			for key, enabled in pairs(ShadowUF.db.profile.units[info[3]].auraIndicators) do
				if( key ~= "enabled" and enabled ) then
					totalDisabled = totalDisabled + 1
				end
			end

			if( totalDisabled == 1 ) then return L["1 aura group disabled"] end
			return totalDisabled > 0 and string.format(L["%s aura groups disabled"], totalDisabled) or L["All aura groups enabled for unit."]
		end,
		args = {
			enabled = {
				order = 1,
				inline = true,
				type = "group",
				name = function(info) return string.format(L["On %s units"], L.units[info[3]]) end,
				args = {
					enabled = {
						order = 1,
						type = "toggle",
						name = L["Enable Indicators"],
						desc = function(info) return string.format(L["Unchecking this will completely disable aura indicators for %s."], L.units[info[3]]) end,
						set = function(info, value) ShadowUF.db.profile.units[info[3]].auraIndicators.enabled = value; ShadowUF.Layout:Reload() end,
						get = function(info) return ShadowUF.db.profile.units[info[3]].auraIndicators.enabled end,
					},
				},
			},
			filters = {
				order = 2,
				inline = true,
				type = "group",
				name = L["Aura Filters"],
				disabled = function(info) return not ShadowUF.db.profile.units[info[3]].auraIndicators.enabled end,
				args = {},
			},
			groups = {
				order = 3,
				inline = true,
				type = "group",
				name = L["Aura Groups"],
				disabled = function(info) return not ShadowUF.db.profile.units[info[3]].auraIndicators.enabled end,
				args = {},
			},
		}
	}

	local unitFilterTable = {
		order = 1,
		type = "toggle",
		name = function(info) return info[#(info)] == "boss" and L["Boss Auras"] or L["Curable Auras"] end,
		desc = function(info)
			local auraIndicators = ShadowUF.db.profile.units[info[3]].auraIndicators
			return auraIndicators["filter-" .. info[#(info)]] and string.format(L["Disabled for %s."], L.units[info[3]]) or string.format(L["Enabled for %s."], L.units[info[3]])
		end,
		set = function(info, value) ShadowUF.db.profile.units[info[3]].auraIndicators["filter-" .. info[#(info)]] = not value and true or nil end,
		get = function(info, value) return not ShadowUF.db.profile.units[info[3]].auraIndicators["filter-" .. info[#(info)]] end
	}

	local globalUnitFilterTable = {
		order = 1,
		type = "toggle",
		name = function(info) return info[#(info)] == "boss" and L["Boss Auras"] or L["Curable Auras"] end,
		disabled = function(info) for unit in pairs(setGlobalUnits) do return false end return true end,
		set = function(info, value)
			local key = "filter-" .. info[#(info)]
			globalConfig[key] = not value and true or nil

			for unit in pairs(setGlobalUnits) do
				ShadowUF.db.profile.units[unit].auraIndicators[key] = globalConfig[key]
			end
		end,
		get = function(info, value) return not globalConfig["filter-" .. info[#(info)]] end
	}

	local unitGroupTable = {
		order = function(info)
			return reverseClassMap[groupName(groupMap[info[#(info)]])] and 1 or 2
		end,
		type = "toggle",
		name = function(info)
			local name = groupName(groupMap[info[#(info)]])
			local token = reverseClassMap[name]
			if( not token ) then return name end
			return ShadowUF:Hex(ShadowUF.db.profile.classColors[token]) .. name .. "|r"
		end,
		desc = function(info)
			local auraIndicators = ShadowUF.db.profile.units[info[3]].auraIndicators
			local group = groupName(groupMap[info[#(info)]])

			return auraIndicators[group] and string.format(L["Disabled for %s."], L.units[info[3]]) or string.format(L["Enabled for %s."], L.units[info[3]])
		end,
		set = function(info, value) ShadowUF.db.profile.units[info[3]].auraIndicators[groupMap[info[#(info)]]] = not value and true or nil end,
		get = function(info, value) return not ShadowUF.db.profile.units[info[3]].auraIndicators[groupMap[info[#(info)]]] end
	}

	local globalUnitGroupTable = {
		type = "toggle",
		order = function(info)
			return reverseClassMap[groupName(groupMap[info[#(info)]])] and 1 or 2
		end,
		name = function(info)
			local name = groupName(groupMap[info[#(info)]])
			local token = reverseClassMap[name]
			if( not token ) then return name end
			return ShadowUF:Hex(ShadowUF.db.profile.classColors[token]) .. name .. "|r"
		end,
		disabled = function(info) for unit in pairs(setGlobalUnits) do return false end return true end,
		set = function(info, value)
			local auraGroup = groupMap[info[#(info)]]
			globalConfig[auraGroup] = not value and true or nil

			for unit in pairs(setGlobalUnits) do
				ShadowUF.db.profile.units[unit].auraIndicators[auraGroup] = globalConfig[auraGroup]
			end
		end,
		get = function(info, value) return not globalConfig[groupMap[info[#(info)]]] end
	}

	local enabledUnits = {}
	local function getEnabledUnits()
		table.wipe(enabledUnits)
		for unit, config in pairs(ShadowUF.db.profile.units) do
			if( config.enabled and config.auraIndicators.enabled ) then
				enabledUnits[unit] = L.units[unit]
			end
		end

		return enabledUnits
	end

	local widthReset

	-- Actual tab view thing
	options.args.auraIndicators = {
		order = 4.5,
		type = "group",
		name = L["Aura Indicators"],
		desc = L["For configuring aura indicators on unit frames."],
		childGroups = "tab",
		hidden = false,
		args = {
			indicators = {
				order = 1,
				type = "group",
				name = L["Indicators"],
				childGroups = "tree",
				args = {
					add = {
						order = 0,
						type = "group",
						name = L["Add Indicator"],
						args = {
							add = {
								order = 0,
								type = "group",
								inline = true,
								name = L["Add new indicator"],
								args = {
									name = {
										order = 0,
										type = "input",
										name = L["Indicator name"],
										width = "full",
										set = function(info, value)
											local id = string.format("%d", GetTime() + math.random(100))
											ShadowUF.db.profile.auraIndicators.indicators[id] = {enabled = true, friendly = true, hostile = true, name = value, anchorPoint = "C", anchorTo = "$parent", height = 10, width = 10, alpha = 1.0, x = 0, y = 0}
											ShadowUF.db.profile.auraIndicators.filters[id] = {boss = {}, curable = {}}

											options.args.auraIndicators.args.indicators.args[id] = indicatorTable
											options.args.auraIndicators.args.auras.args.filters.args[id] = auraFilterConfigTable

											AceDialog.Status.ShadowedUF.children.auraIndicators.children.indicators.status.groups.selected = id
											AceRegistry:NotifyChange("ShadowedUF")
										end,
										get = function() return "" end,
									},
								},
							},
						},
					},
				},
			},
			auras = {
				order = 2,
				type = "group",
				name = L["Auras"],
				hidden = function(info)
					if( not widthReset and AceDialog.Status.ShadowedUF.children.auraIndicators ) then
						if( AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras ) then
							widthReset = true

							AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.treewidth = 230

							AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.groups = {}
							AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.groups.filters = true
							AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.groups.groups = true

							AceRegistry:NotifyChange("ShadowedUF")
						end
					end

					return false
				end,
				args = {
					add = {
						order = 0,
						type = "group",
						name = L["Add Aura"],
						set = function(info, value) addAura[info[#(info)]] = value end,
						get = function(info) return addAura[info[#(info)]] end,
						args = {
							name = {
								order = 0,
								type = "input",
								name = L["Spell Name/ID"],
								desc = L["If name is entered, it must be exact as it is case sensitive. Alternatively, you can use spell id instead."]
							},
							group = {
								order = 1,
								type = "select",
								name = L["Aura group"],
								desc = L["What group this aura belongs to, this is where you will find it when configuring."],
								values = getAuraGroup,
							},
							custom = {
								order = 2,
								type = "input",
								name = L["New aura group"],
								desc = L["Allows you to enter a new aura group."],
							},
							create = {
								order = 3,
								type = "execute",
								name = L["Add aura"],
								disabled = function(info) return not addAura.name or (not addAura.group and not addAura.custom) end,
								func = function(info)
									local group = string.trim(addAura.custom or "")
									if( group == "" ) then group = string.trim(addAura.group or "") end
									if( group == "" ) then group = L["Miscellaneous"] end

									-- Don't overwrite an existing group, but don't tell them either, mostly because I don't want to add error reporting code
									if( not ShadowUF.db.profile.auraIndicators.auras[addAura.name] ) then
										-- Odds are, if they are saying to show it only if a buff is missing it's cause they want to know when their own class buff is not there
										-- so will cheat it, and jump start it by storing the texture if we find it from GetSpellInfo directly
										Indicators.auraConfig[addAura.name] = {indicator = "", group = group, iconTexture = select(3, GetSpellInfo(addAura.name)), priority = 0, r = 0, g = 0, b = 0}
										writeAuraTable(addAura.name)

										auraID = auraID + 1
										auraMap[tostring(auraID)] = addAura.name
										auraGroupTable.args[tostring(auraID)] = auraConfigTable
									end

									addAura.name = nil
									addAura.custom = nil
									addAura.group = nil

									-- Check if the group exists
									local gID
									for id, name in pairs(groupMap) do
										if( name == group ) then
											gID = id
											break
										end
									end

									if( not gID ) then
										groupID = groupID + 1
										groupMap[tostring(groupID)] = group

										unitTable.args.groups.args[tostring(groupID)] = unitGroupTable
										options.args.auraIndicators.args.units.args.global.args.groups.args[tostring(groupID)] = globalUnitGroupTable
										options.args.auraIndicators.args.auras.args.groups.args[tostring(groupID)] = auraGroupTable
									end

									-- Shunt the user to the this groups page
									AceDialog.Status.ShadowedUF.children.auraIndicators.children.auras.status.groups.selected = tostring(gID or groupID)
									AceRegistry:NotifyChange("ShadowedUF")

									ShadowUF.Layout:Reload()
								end,
							},
						},
					},
					filters = {
						order = 1,
						type = "group",
						name = L["Automatic Auras"],
						args = {}
					},
					groups = {
						order = 2,
						type = "group",
						name = L["Groups"],
						args = {}
					},
				},
			},
			linked = {
				order = 3,
				type = "group",
				name = L["Linked spells"],
				childGroups = "tree",
				hidden = true,
				args = {
					help = {
						order = 0,
						type = "group",
						name = L["Help"],
						inline = true,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can link auras together using this, for example you can link Mark of the Wild to Gift of the Wild so if the player has Mark of the Wild but not Gift of the Wild, it will still show Mark of the Wild as if they had Gift of the Wild."],
								width = "full",
							},
						},
					},
					add = {
						order = 1,
						type = "group",
						name = L["Add link"],
						inline = true,
						set = function(info, value)
							addLink[info[#(info)] ] = value
						end,
						get = function(info) return addLink[info[#(info)] ] end,
						args = {
							from = {
								order = 0,
								type = "input",
								name = L["Link from"],
								desc = L["Spell you want to link to a primary aura, the casing must be exact."],
							},
							to = {
								order = 1,
								type = "select",
								name = L["Link to"],
								values = getAuraList,
							},
							link = {
								order = 3,
								type = "execute",
								name = L["Link"],
								disabled = function() return not addLink.from or not addLink.to or addLink.from == "" end,
								func = function(info)
									local lID, pID
									for id, name in pairs(linkMap) do
										if( name == addLink.from ) then
											lID = id
										elseif( name == addLink.to ) then
											pID = id
										end
									end

									if( not pID ) then
										linkID = linkID + 1
										pID = linkID
										linkMap[tostring(linkID)] = addLink.to
									end

									if( not lID ) then
										linkID = linkID + 1
										lID = linkID
										linkMap[tostring(linkID)] = addLink.from
									end

									ShadowUF.db.profile.auraIndicators.linked[addLink.from] = addLink.to
									options.args.auraIndicators.args.linked.args[tostring(pID)] = parentLinkTable
									parentLinkTable.args[tostring(lID)] = childLinkTable

									addLink.from = nil
									addLink.to = nil

									ShadowUF.Layout:Reload()
								end,
							},
						},
					},
				},
			},
			units = {
				order = 4,
				type = "group",
				name = L["Enable Indicators"],
				args = {
					help = {
						order = 0,
						type = "group",
						name = L["Help"],
						inline = true,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can disable aura filters and groups for units here. For example, you could set an aura group that shows DPS debuffs to only show on the target."],
								width = "full",
							},
						},
					},
					global = {
						order = 0,
						type = "group",
						name = L["Global"],
						desc = L["Global configurating will let you mass enable or disable aura groups for multiple units at once."],
						args = {
							units = {
								order = 0,
								type = "multiselect",
								name = L["Units to change"],
								desc = L["Units that should have the aura groups settings changed below."],
								values = getEnabledUnits,
								set = function(info, unit, enabled) setGlobalUnits[unit] = enabled or nil end,
								get = function(info, unit) return setGlobalUnits[unit] end,
							},
							filters = {
								order = 1,
								type = "group",
								inline = true,
								name = L["Aura filters"],
								args = {}
							},
							groups = {
								order = 2,
								type = "group",
								inline = true,
								name = L["Aura groups"],
								args = {}
							},
						},
					},
				},
			},
			classes = {
				order = 5,
				type = "group",
				name = L["Disable Auras by Class"],
				childGroups = "tree",
				args = {
					help = {
						order = 0,
						type = "group",
						name = L["Help"],
						inline = true,
						args = {
							help = {
								order = 0,
								type = "description",
								name = L["You can override what aura is enabled on a per-class basis, note that if the aura is disabled through the main listing, then your class settings here will not matter."],
								width = "full",
							},
						},
					}
				},
			},
		},
	}

	local classTable = {
		order = 1,
		type = "group",
		name = function(info)
			return ShadowUF:Hex(ShadowUF.db.profile.classColors[info[#(info)]]) .. LOCALIZED_CLASS_NAMES_MALE[info[#(info)]] .. "|r"
		end,
		args = {},
	}

	local classAuraTable = {
		order = 1,
		type = "toggle",
		icon = function(info)
			local aura = auraMap[info[#(info)]]
			return tonumber(aura) and (select(3, GetSpellInfo(aura))) or nil
		end,
		name = function(info)
			local aura = tonumber(auraMap[info[#(info)]])
			if( not aura ) then	return auraMap[info[#(info)]] end

			local name, _, icon = GetSpellInfo(aura)
			if( not name ) then return name end

			return "|T" .. icon .. ":18:18:0:0|t " .. name
		end,
		desc = function(info)
			local aura = auraMap[info[#(info)]]
			if( tonumber(aura) ) then
				return string.format(L["Spell ID %s"], aura)
			else
				return aura
			end
		end,
		set = function(info, value)
			local aura = auraMap[info[#(info)]]
			local class = info[#(info) - 1]
			value = not value

			if( value == false ) then value = nil end
			ShadowUF.db.profile.auraIndicators.disabled[class][aura] = value
			ShadowUF.Layout:Reload()
		end,
		get = function(info)
			local aura = auraMap[info[#(info)]]
			local class = info[#(info) - 1]

			return not ShadowUF.db.profile.auraIndicators.disabled[class][aura]
		end,
	}

	-- Build links
	local addedFrom = {}
	for from, to in pairs(ShadowUF.db.profile.auraIndicators.linked) do
		local pID = addedFrom[to]
		if( not pID ) then
			linkID = linkID + 1
			pID = linkID

			addedFrom[to] = pID
		end

		linkID = linkID + 1

		ShadowUF.db.profile.auraIndicators.linked[from] = to
		options.args.auraIndicators.args.linked.args[tostring(pID)] = parentLinkTable
		parentLinkTable.args[tostring(linkID)] = childLinkTable

		linkMap[tostring(linkID)] = from
		linkMap[tostring(pID)] = to
	end

	-- Build the aura configuration
	local groups = {}
	for name in pairs(ShadowUF.db.profile.auraIndicators.auras) do
		local aura = Indicators.auraConfig[name]
		if( aura.group ) then
			auraMap[tostring(auraID)] = name
			auraGroupTable.args[tostring(auraID)] = auraConfigTable
			classTable.args[tostring(auraID)] = classAuraTable
			auraID = auraID + 1

			groups[aura.group] = true
		end
	end

	-- Now create all of the parent stuff
	for group in pairs(groups) do
		groupMap[tostring(groupID)] = group
		unitTable.args.groups.args[tostring(groupID)] = unitGroupTable

		options.args.auraIndicators.args.units.args.global.args.groups.args[tostring(groupID)] = globalUnitGroupTable
		options.args.auraIndicators.args.auras.args.groups.args[tostring(groupID)] = auraGroupTable

		groupID = groupID + 1
	end

	for _, type in pairs(auraFilters) do
		unitTable.args.filters.args[type] = unitFilterTable
		options.args.auraIndicators.args.units.args.global.args.filters.args[type] = globalUnitFilterTable
	end

	-- Aura status by unit
	for unit, config in pairs(ShadowUF.db.profile.units) do
		options.args.auraIndicators.args.units.args[unit] = unitTable
	end

	-- Build class status thing
	for classToken in pairs(RAID_CLASS_COLORS) do
		options.args.auraIndicators.args.classes.args[classToken] = classTable
	end

	-- Quickly build the indicator one
	for key in pairs(ShadowUF.db.profile.auraIndicators.indicators) do
		options.args.auraIndicators.args.indicators.args[key] = indicatorTable
		options.args.auraIndicators.args.auras.args.filters.args[key] = auraFilterConfigTable
	end

	-- Automatically unlock the advanced text configuration for raid frames, regardless of advanced being enabled
	local advanceTextTable = ShadowUF.Config.advanceTextTable
	local originalHidden = advanceTextTable.args.sep.hidden
	local function unlockRaidText(info)
		if( info[2] == "raid" ) then return false end
		return originalHidden(info)
	end

	advanceTextTable.args.anchorPoint.hidden = unlockRaidText
	advanceTextTable.args.sep.hidden = unlockRaidText
	advanceTextTable.args.x.hidden = unlockRaidText
	advanceTextTable.args.y.hidden = unlockRaidText
end

local function loadOptions()
	options = {
		type = "group",
		name = "Shadowed UF",
		args = {}
	}

	loadGeneralOptions()
	loadUnitOptions()
	loadHideOptions()
	loadTagOptions()
	loadFilterOptions()
	loadVisibilityOptions()
	loadAuraIndicatorsOptions()

	-- Ordering
	options.args.general.order = 1
	options.args.profile.order = 1.5
	options.args.enableUnits.order = 2
	options.args.units.order = 3
	options.args.filter.order = 4
	options.args.auraIndicators.order = 4.5
	options.args.hideBlizzard.order = 5
	options.args.visibility.order = 6
	options.args.tags.order = 7

	-- So modules can access it easier/debug
	Config.options = options

	-- Options finished loading, fire callback for any non-default modules that want to be included
	ShadowUF:FireModuleEvent("OnConfigurationLoad")
end

local defaultToggles
function Config:Open()
	AceDialog = AceDialog or LibStub("AceConfigDialog-3.0")
	AceRegistry = AceRegistry or LibStub("AceConfigRegistry-3.0")

	if( not registered ) then
		loadOptions()

		AceRegistry:RegisterOptionsTable("ShadowedUF", options, true)
		AceDialog:SetDefaultSize("ShadowedUF", 895, 570)
		registered = true
	end

	AceDialog:Open("ShadowedUF")

	if( not defaultToggles ) then
		defaultToggles = true

		AceDialog.Status.ShadowedUF.status.groups.groups.units = true
		AceRegistry:NotifyChange("ShadowedUF")
	end
end
