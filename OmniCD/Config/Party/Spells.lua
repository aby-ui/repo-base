local E, L, C = select(2, ...):unpack()
local P = E.Party

E.OTHER_SORT_ORDER = {
	[1] = "PVPTRINKET",
	[2] = "RACIAL",
	[3] = "TRINKET",
	[4] = "ESSENCES",
	[5] = "COVENANT",
	[6] = "CONSUMABLE",
	["PVPTRINKET"] = L["PvP Trinket"],
	["RACIAL"] = L["Racial Traits"],
	["TRINKET"] = L["Trinket, Main Hand"],
	["ESSENCES"] = L["Essence"],
	["COVENANT"] = L["Signature Ability"],
	["CONSUMABLE"] = L["Consumables"],
}
local MAX_OTHERS = #E.OTHER_SORT_ORDER



P.getSpell = function(info)
	local tab = info[3] == "spells" and "spells" or "raidCDS"
	return E.profile.Party[ info[2] ][tab][ info[#info] ]
end

P.setSpell = function(info, state)
	local tab = info[3] == "spells" and "spells" or "raidCDS"
	local sId = info[#info]
	local db = E.profile.Party[ info[2] ]
	db[tab][sId] = state

	if db == E.db then
		P:UpdateEnabledSpells()
		P:Refresh()
	end
end

P.clearAllDefault = function(info)
	local key = info[2]
	local isSpellsSubcategory = info[3] == "spells"
	local tab = isSpellsSubcategory and info[3] or info[4]
	local db = E.profile.Party[key]
	local db_defaults = isSpellsSubcategory and E.spellDefaults or E.raidDefaults
	if info[#info] == "default" then
		P:ResetOption(key, tab)
	else
		wipe(db[tab])
		for i = 1, #db_defaults do
			local id = db_defaults[i]
			id = tostring(id)
			db[tab][id] = false
		end
	end

	if db == E.db then
		P:UpdateEnabledSpells()
		P:Refresh()
	end
end

P.setQuickSelect = function(info, value)
	local key = info[2]
	for _, v in pairs(E.spell_db) do
		for i = 1, #v do
			local spell = v[i]
			local spellID = spell.spellID
			local sId = tostring(spellID)
			local stype = spell.type
			if not spell.hide and value == stype then
				E.profile.Party[key].raidCDS[sId] = true
			end
		end
	end

	if P:IsCurrentZone(key) then
		P:UpdateEnabledSpells()
		P:Refresh()
	end
end

P.getHideDisabledSpells = function(info) return E.profile.Party[ info[2] ].extraBars.hideDisabledSpells end
P.setHideDisabledSpells = function(info, state) E.profile.Party[ info[2] ].extraBars.hideDisabledSpells = state end



local function clearAllDefault(info)
	E[ info[1] ].clearAllDefault(info)
end

local function isSpellsSubcategory(info)
	return info[3] == "spells"
end

local function isRaidCdSubcategory(info)
	return info[4] == "raidCDS"
end

local function shouldHideDisabledSpell(info)
	local module = E[ info[1] ]
	return info[3] ~= "spells" and module.getHideDisabledSpells(info) and not module:IsEnabledSpell(info[#info], nil, info[2])
end

local spells = {
	name = function(info)
		return isSpellsSubcategory(info) and L["Spells"] or format("%s/%s",L["Interrupt"], L["Raid CD"])
	end,
	order = 60,
	type = "group",
	get = function(info) return E[ info[1] ].getSpell(info) end,
	set = function(info, state) E[ info[1] ].setSpell(info, state) end,
	args = {
		desc = {
			name = function(info)
				return isSpellsSubcategory(info) and L["CTRL+click to edit spell."] or L["Assign Raid Cooldowns."]
			end,
			order = 0,
			type = "description",
		},
		clearAll = {
			name = CLEAR_ALL,
			order = 1,
			type = "execute",
			func = clearAllDefault,
			confirm = E.ConfirmAction,
		},
		default = {
			name = RESET_TO_DEFAULT,
			order = 2,
			type = "execute",
			func = clearAllDefault,
			confirm = E.ConfirmAction,
		},
		showForbearanceCounter = {
			hidden = E.isClassic or isRaidCdSubcategory,
			name = L["Show Forbearance CD"],
			desc = L["Show timer on spells while under the effect of Forbearance or Hypothermia. Spells castable to others will darken instead"],
			order = 4,
			type = "toggle",
			get = function(info) return E[ info[1] ].db.icons.showForbearanceCounter end,
			set = function(info, state) E[ info[1] ].db.icons.showForbearanceCounter = state end,
		},
		quickSelect = {
			hidden = isSpellsSubcategory,
			name = L["Quick Select"],
			desc = L["Select a spell type to enable all spells in that category for all classes"],
			order = 5,
			type = "select",
			values = E.L_PRIORITY,
			get = E.Noop,
			set = function(info, state) E[ info[1] ].setQuickSelect(info, state) end,
		},
		hideDisabledSpells = {
			hidden = isSpellsSubcategory,
			name = L["Hide Disabled Spells"],
			desc = L["Hide spells that are not enabled in the \'Spells\' menu."],
			order = 6,
			type = "toggle",
			get = function(info) return E[ info[1] ].getHideDisabledSpells(info) end,
			set = function(info, state) E[ info[1] ].setHideDisabledSpells(info, state) end,
		},
	}
}

for i = 1, MAX_OTHERS do
	local class = E.OTHER_SORT_ORDER[i]
	if E.spell_db[class] then
		local icon = E.TEXTURES[class]
		local name = E.OTHER_SORT_ORDER[class]
		spells.args[class] = {
			icon = icon,
			iconCoords = E.BORDERLESS_TCOORDS,
			name = name,
			order = i,
			type = "group",
			args = {}
		}
	end
end

spells.args.othersHeader = {
	disabled = true,
	name = "```",
	order = MAX_OTHERS + 1,
	type = "group",
	args = {}
}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	if E.spell_db[class] then
		local name = LOCALIZED_CLASS_NAMES_MALE[class]



		local icon = E.isWOTLKC and class == "DEATHKNIGHT" and "Interface\\Icons\\spell_deathknight_classicon" or (E.TEXTURES.CLASS .. class)
		local iconCoords = E.BORDERLESS_TCOORDS
		spells.args[class] = {
			icon = icon,
			iconCoords = iconCoords,
			name = name,
			type = "group",
			args = {}
		}
	end
end

local sorter = function(a, b)
	local aPrio = C.Party.arena.priority[a.type]
	local bPrio = C.Party.arena.priority[b.type]
	if aPrio == bPrio then
		return a.name < b.name
	end
	return aPrio > bPrio
end

function P:SortSpellList()
	for _, t in pairs(E.spell_db) do
		sort(t, sorter)
	end
end

function P:UpdateSpellsOption(id, oldClass, oldType, class, stype, force)
	if oldClass or force then
		if oldClass then
			id = tostring(id)
			spells.args[oldClass].args[oldType].args[id] = nil
			if next(spells.args[oldClass].args[oldType].args) == nil then
				spells.args[oldClass].args[oldType] = nil
			end
		end

		if not class then
			self:Refresh()
			return
		end

		local classSpells = E.spell_db[class]
		local numClassSpells = #classSpells
		local order = 1

		sort(classSpells, sorter)

		local t = spells.args[class].args
		t[stype] = t[stype] or {
			name = "|cffffd200" .. E.L_PRIORITY[stype],
			order = 30 - C.Party.arena.priority[stype],
			type = "group",
			inline = true,
			args = {}
		}

		t = t[stype].args
		for k = 1, numClassSpells do
			local v = classSpells[k]
			local vtype = v.type
			if not v.hide and vtype == stype then
				local spellID = v.spellID
				local sId = tostring(spellID)

				if t[sId] then
					t[sId].order = order
				else
					local icon, name = v.icon, v.name
					local link = E.isClassic and GetSpellDescription(spellID) or GetSpellLink(spellID)

					t[sId] = {
						hidden = shouldHideDisabledSpell,
						image =	 icon,
						imageCoords = E.BORDERLESS_TCOORDS,
						name = name,
						desc = link,
						order = order,
						type = "toggle",
						arg = spellID,
					}
				end

				if E.isClassic or E.isDF then
					local spell = Spell:CreateFromSpellID(spellID)
					spell:ContinueOnSpellLoad(function()
						local desc = E.isClassic and spell:GetSpellDescription() or GetSpellLink(spellID)
						t[sId].desc = desc
					end)
				end

				order = order + 1
			end
		end
	end

	for moduleName in pairs(E.moduleOptions) do
		local module = E[moduleName]
		if module.AddSpellPicker then
			module:Refresh()
		end
	end
end

function P:AddSpellPickerSpells()
	for j = 1, MAX_CLASSES + MAX_OTHERS do
		local class = j > MAX_CLASSES and E.OTHER_SORT_ORDER[j - MAX_CLASSES] or CLASS_SORT_ORDER[j]
		local classSpells = E.spell_db[class]
		if classSpells then
			local numClassSpells = #classSpells
			local order = 1

			local t = spells.args[class].args
			for k = 1, numClassSpells do
				local v = classSpells[k]
				if not v.hide then
					local vtype = v.type
					t[vtype] = t[vtype] or {
						name = "|cffffd200" .. E.L_PRIORITY[vtype],
						order = 30 - C.Party.arena.priority[vtype],
						type = "group",
						inline = true,
						args = {}
					}

					local spellID, icon, name = v.spellID, v.icon, v.name
					local sId = tostring(spellID)
					local link = E.isClassic and GetSpellDescription(spellID) or GetSpellLink(spellID)

					t[vtype].args[sId] = {
						hidden = shouldHideDisabledSpell,
						image = icon,
						imageCoords = E.BORDERLESS_TCOORDS,
						name = name,
						desc = link,
						order = order,
						type = "toggle",
						arg = spellID,
					}


					if class == "TRINKET" and v.item then
						local item = Item:CreateFromItemID(v.item)
						if item then
							item:ContinueOnItemLoad(function()
								local itemName = item:GetItemName()
								if itemName then
									t[vtype].args[sId].name = itemName
								end
							end)
						end
					end

					if E.isClassic or E.isDF then
						local spell = Spell:CreateFromSpellID(spellID)
						spell:ContinueOnSpellLoad(function()
							local desc = E.isClassic and spell:GetSpellDescription() or GetSpellLink(spellID)
							t[vtype].args[sId].desc = desc
						end)
					end

					order = order + 1
				end
			end
		end
	end
end

function P:AddSpellPicker()
	self:SortSpellList()
	self:AddSpellPickerSpells()
	self:RegisterSubcategory("spells", spells)
end

E:RegisterModuleOptions("Party", P.options, "Party")

E.spellsOptionTbl = spells
