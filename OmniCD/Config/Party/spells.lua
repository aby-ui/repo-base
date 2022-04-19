local E, L, C = select(2, ...):unpack()

local P = E["Party"]
local SPELLS = type(SPELLS) == "string" and SPELLS or L["Spells"]



P.getSpell = function(info)
	local tab = info[3] == "spells" and "spells" or "raidCDS"
	return E.DB.profile.Party[info[2]][tab][info[#info]]
end

P.setSpell = function(info, state)
	local tab = info[3] == "spells" and "spells" or "raidCDS"
	local sId = info[#info]
	local db = E.DB.profile.Party[info[2]]
	db[tab][sId] = state

	if db == E.db then
		P:UpdateEnabledSpells()

		P:Refresh()
	end
end

P.ClearAllDefault = function(info)
	local key = info[2]
	local isSpellsOption = info[3] == "spells"
	local tab = isSpellsOption and info[3] or info[4]
	local db = E.DB.profile.Party[key]
	local db_defaults = isSpellsOption and E.spellDefaults or E.raidDefaults

	if info[#info] == "default" then
		P:ResetOptions(key, tab)
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

local runClearAllDefault = function(info) E[info[1]].ClearAllDefault(info) end

local isSpellsOption = function(info) return info[3] == "spells" end
local isRaidCDOption = function(info) return info[4] == "raidCDS" end
local isntSpellsOption = function(info) return info[3] ~= "spells" end
local isntRaidCDOption = function(info) return info[4] ~= "raidCDS" end

P.setQuickSelect = function(info, value)
	local key = info[2]
	for _, v in pairs(E.spell_db) do
		for i = 1, #v do
			local spell = v[i]
			local spellID = spell.spellID
			local sId = tostring(spellID)
			local stype = spell.type
			if not spell.hide and value == stype then
				E.DB.profile.Party[key].raidCDS[sId] = true
			end
		end
	end

	if E.db == E.DB.profile.Party[key] then
		P:Refresh()
	end
end

P.getHideDisabledSpells = function(info) return E.DB.profile.Party[info[2]].extraBars.raidCDBar.hideDisabledSpells end
P.setHideDisabledSpells = function(info, state) E.DB.profile.Party[info[2]].extraBars.raidCDBar.hideDisabledSpells = state end

local isRaidOptDisabledID = function(info)
	local module = E[info[1]]
	return info[3] ~= "spells" and module.getHideDisabledSpells(info) and not module.IsEnabledSpell(info[#info], info[2])
end

local spells = {
	name = function(info) return isRaidCDOption(info) and L["Raid CD"] or SPELLS end,
	order = 60,
	type = "group",
	get = function(info) return E[info[1]].getSpell(info) end,
	set = function(info, state) E[info[1]].setSpell(info, state) end,
	args = {
		raidDesc = {


			name = function(info) return isntRaidCDOption(info) and "|cffff2020Ctrl click to edit spell.\n\n" or L["Assign Raid Cooldowns."] end,
			order = 0,
			type = "description",
		},
		clearAll = {
			name = CLEAR_ALL,
			order = 1,
			type = "execute",
			func = runClearAllDefault,
			confirm = E.ConfirmAction,
		},
		default = {
			hidden = function(info) return isntSpellsOption(info) and isntRaidCDOption(info) end,
			name = RESET_TO_DEFAULT,
			order = 2,
			type = "execute",
			func = runClearAllDefault,
			confirm = E.ConfirmAction,
		},














		showForbearanceCounter = {
			hidden = E.isClassic or isntSpellsOption,
			name = L["Show Forbearance CD"],
			desc = L["Show timer on spells while under the effect of Forbearance or Hypothermia. Spells castable to others will darken instead"],
			order = 4,
			type = "toggle",
			get = function(info) return E[info[1]].db.icons.showForbearanceCounter end,
			set = function(info, state) E[info[1]].db.icons.showForbearanceCounter = state end,
		},
		quickSelect = {
			hidden = isSpellsOption,
			name = L["Quick Select"],
			desc = L["Select a spell type to enable all spells in that category for all classes"],
			order = 5,
			type = "select",
			values = E.L_PRIORITY,
			get = E.Noop,
			set = function(info, state) E[info[1]].setQuickSelect(info, state) end,
		},
		hideDisabledSpells = {
			hidden = isSpellsOption,
			name = L["Hide Disabled Spells"],
			desc = L["Hide spells that are not enabled in the \'Spells\' menu."],
			order = 6,
			type = "toggle",
			get = function(info) return E[info[1]].getHideDisabledSpells(info) end,
			set = function(info, state) E[info[1]].setHideDisabledSpells(info, state) end,
		},
	}
}


local numOthers = #E.OTHER_SORT_ORDER
for i = 1, numOthers do
	local class = E.OTHER_SORT_ORDER[i]
	local icon = E.ICO[class]
	local name = E.L_CATAGORY_OTHER[class]
	spells.args[class] = {
		icon = icon,
		iconCoords = E.borderlessCoords,
		name = name,
		order = i,
		type = "group",
		args = {}
	}
end

spells.args.othersHeader = {
	disabled = true,
	name = "```",
	order = 10,
	type = "group",
	args = {}
}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]

	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	spells.args[class] = {

		icon = E.ICO.CLASS .. class,

		iconCoords = E.borderlessCoords,
		name = name,
		type = "group",
		args = {}
	}
end

local function SortClassSpells(t)
	sort(t, function(a, b)
		aPrio = C.Party.arena.priority[a.type]
		bPrio = C.Party.arena.priority[b.type]
		if aPrio == bPrio then
			return a.name < b.name
		end
		return aPrio > bPrio
	end)
end

local function SortSpellList()
	for class, t in pairs(E.spell_db) do
		SortClassSpells(t)
	end
end

function P:UpdateSpellsOption(id, oldClass, oldType, class, stype, force)
	local sId = tostring(id)

	if oldClass or force then
		if oldClass then
			spells.args[oldClass].args[oldType].args[sId] = nil
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

		SortClassSpells(classSpells)

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
						hidden = isRaidOptDisabledID,
						image =  icon,
						imageCoords = E.borderlessCoords,
						name = name,
						desc = link,
						order = order,
						type = "toggle",
						arg = spellID,
					}
				end

				if E.isClassic then
					local spell = Spell:CreateFromSpellID(spellID)
					spell:ContinueOnSpellLoad(function()
						local desc = spell:GetSpellDescription()
						t[sId].desc = desc
					end)
				end

				order = order + 1
			end
		end
	end

	for k in pairs(E.moduleOptions) do
		local module = E[k]
		if module.AddSpellPicker then
			module:Refresh()
		end
	end
end

function P:AddSpellPickerSpells()
	for j = 1, MAX_CLASSES + numOthers do
		local class = j > MAX_CLASSES and E.OTHER_SORT_ORDER[j - MAX_CLASSES] or CLASS_SORT_ORDER[j]
		local classSpells = E.spell_db[class]
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
					hidden = isRaidOptDisabledID,
					image = icon,
					imageCoords = E.borderlessCoords,
					name = name,
					desc = link,
					order = order,
					type = "toggle",
					arg = spellID,
				}










				if E.isClassic then
					local spell = Spell:CreateFromSpellID(spellID)
					spell:ContinueOnSpellLoad(function()
						local desc = spell:GetSpellDescription()
						t[vtype].args[sId].desc = desc
					end)
				end

				order = order + 1
			end
		end
	end
end

function P:AddSpellPicker()
	SortSpellList()
	self:AddSpellPickerSpells()

	for key in pairs(E.CFG_ZONE) do
		P.options.args[key].args.spells = spells
		P.options.args[key].args.extraBars.args.raidCDS = spells
	end
end

for key in pairs(E.CFG_ZONE) do
	P:AddGeneralOption(key)
	P:AddExBarOption(key)
	P:AddPositionOption(key)
	P:AddIconsOption(key)
	P:AddHighlightOption(key)
	P:AddPriorityOption(key)
end

E:RegisterModuleOptions("Party", P.options, "Party")

E.spellsOptionTbl = spells
