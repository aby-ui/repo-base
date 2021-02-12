local E, L, C = select(2, ...):unpack()

local P = E["Party"]

local SPELLS = type(SPELLS) == "string" and SPELLS or L["Spells"] -- TODO: remove
local ICO_NAME = "|T%s:18|t %s"
local ICO_TALENT_ID = "|T%s:18|t %s %s"
local NEWLINE_ICO_NAME = "\n|T%s:18|t %s"

local function FormatSpellDesc(spellID, spec, vtype, desc, icon, duration, charges, parent, class)
	local tmp = {}

	tmp[#tmp+1] = false
	tmp[#tmp+1] = desc
	tmp[#tmp+1] = L["Spell ID"]
	tmp[#tmp+1] = spellID

	local t, t2 = {}, {}

	if not spec and E.BOOKTYPE_CATEGORY[class] then
		tmp[#tmp+1] = SPECIALIZATION
		tmp[#tmp+1] = ALL
	elseif type(spec) == "table" then
		for i = 1, #spec do
			local specID = spec[i]
			if specID < 599 then -- TODO:
				local _, name, _, icon = GetSpecializationInfoByID(specID)
				if name then
					t[#t+1] = format(ICO_NAME, icon, name)
				end
			else
				local name, _, icon = GetSpellInfo(specID)
				local hexColor = E.COVENANT_HEX_COLOR[specID]
				if E.runeforge_descToPowerID[specID] then
					name = "|cffff8000" .. name .. "|r"
				elseif hexColor then
					name = hexColor .. name .. "|r"
				end
				t2[#t2+1] = format(ICO_TALENT_ID, icon, name, (specID == spellID or hexColor) and "" or specID)
			end
		end

		if #t > 0 then
			tmp[#tmp+1] = SPECIALIZATION
			tmp[#tmp+1] = E.FormatConcat(t, "\n%s")
		end

		if #t2 > 0 then
			tmp[#tmp+1] = TALENT
			tmp[#tmp+1] = E.FormatConcat(t2, "\n%s")
		end
	elseif E.COVENANT_HEX_COLOR[spec] then
		local name, _, icon = GetSpellInfo(spec)
		name = E.COVENANT_HEX_COLOR[spec] .. name .. "|r"
		tmp[#tmp+1] = L["Covenant"]
		tmp[#tmp+1] = format(NEWLINE_ICO_NAME, icon, name)
	elseif spec then
		local talentID = type(spec) == "number" and spec or spellID
		local name, _, icon = GetSpellInfo(talentID)
		local isRuneforge = E.runeforge_descToPowerID[talentID]
		if isRuneforge then
			name = "|cffff8000" .. name .. "|r"
		end

		if parent then
			local name, _, icon = GetSpellInfo(parent)
			parent = format(ICO_NAME, icon, name)
			parent = format("\n" .. REPLACES_SPELL, parent)
		end

		tmp[#tmp+1] = isRuneforge and RUNEFORGE_LEGENDARY_POWER_TOOLTIP_PREAMBLE or TALENT
		tmp[#tmp+1] = talentID == spellID and (parent or "") or format("\n|T%s:18|t %s %s%s", icon, name, talentID, parent or "")
	end

	local cd
	if type(duration) == "table" then
		wipe(t)

		for k, v in pairs(duration) do
			if k == "default" then
				cd = SecondsToTime(v)
			else
				local _, name, _, icon = GetSpecializationInfoByID(k)
				if name then
					t[#t+1] = format(ICO_NAME, icon, name)
					t[#t+1] = SecondsToTime(v)
				else
					local name, _,_,_,_,_,_,_,_, icon = GetItemInfo(k) -- Requires item data to be loaded
					local icon = GetItemIcon(k)
					t[#t+1] = format(ICO_NAME, icon, name or k)
					t[#t+1] = SecondsToTime(v)
				end
			end
		end

		cd = cd or ""
		cd = cd .. E.FormatConcat(t, "\n%s: ", "%s")
	else
		cd = SecondsToTime(duration)
	end

	tmp[#tmp+1] = L["Cooldown"]
	tmp[#tmp+1] = cd

	if charges then
		local ch
		if type(charges) == "table" then
			wipe(t)

			for k, v in pairs(charges) do
				if k == "default" then
					ch = format(SPELL_MAX_CHARGES, v)
				else
					local _, name, _, icon = GetSpecializationInfoByID(k)
					t[#t+1] = format(ICO_NAME, icon, name)
					t[#t+1] = format(SPELL_MAX_CHARGES, v)
				end
			end

			ch = ch or ""
			ch = ch .. E.FormatConcat(t, "\n%s: ", "%s")
		else
			ch = format(SPELL_MAX_CHARGES, charges)
		end

		tmp[#tmp+1] = L["Charges"]
		tmp[#tmp+1] = ch
	end

	return E.FormatConcat(tmp, "\n\n|cffffd200%s|r ", "%s")
end

local isRaidCDOption = function(info) return info[3] ~= "spells" end -- cf:> info[3] == extraBars info[4] == raidCDS
local isSpellsOption = function(info) return not isRaidCDOption(info) end
local isRaidOptDisabledID = function(info)
	local key = info[2]
	return info[3] ~= "spells" and E.DB.profile.Party[key].raidCDS.hideDiabledSpells and not P.IsEnabledSpell(info[#info]:gsub("E", ""), key)
end

local runClearAllDefault = function(info)
	local modName = info[1]
	local module = E[modName]
	local key = info[2]
	local db = modName == "Party" and E.DB.profile.Party[key] or module.profile[key]
	if isRaidCDOption(info) then
		if info[#info] == "default" then
			P:ResetOptions(key, "raidCDS")
		else
			wipe(db.raidCDS)
			for i = 1, #E.raidDefaults do
				local id = E.raidDefaults[i]
				id = tostring(id)
				db.raidCDS[id] = false
			end
		end
	else
		if info[#info] == "default" then
			module:ResetOptions(key, "spells")
		else
			wipe(db.spells)
			for i = 1, #E.spellDefaults do
				local id = E.spellDefaults[i]
				id = tostring(id)
				db.spells[id] = false
			end
		end
	end

	if db == E.db then
		E.UpdateEnabledSpells(P)
		P:Refresh()
	elseif db == module.db then
		E.UpdateEnabledSpells(module)
		module:Refresh()
	end
end

local spells = {
	name = function(info) return isRaidCDOption(info) and L["Raid CD"] or SPELLS end,
	order = 60,
	type = "group",
	childGroups = "tab",
	get = function(info)
		local modName = info[1]
		local module = E[modName]
		if isRaidCDOption(info) then
			return E.DB.profile.Party[info[2]].raidCDS[info[#info]]
		else
			return module.IsEnabledSpell(info[#info], info[2])
		end
	end,
	set = function(info, state)
		local modName = info[1]
		local module = E[modName]
		local key = info[2]
		local db = modName == "Party" and E.DB.profile.Party[key] or module.profile[key]
		if isRaidCDOption(info) then
			E.DB.profile.Party[key].raidCDS[info[#info]] = state
		else
			db.spells[info[#info]] = state
		end

		if db == E.db then
			E.UpdateEnabledSpells(P)
			P:Refresh()
		elseif db == module.db then
			E.UpdateEnabledSpells(module)
			module:Refresh()
		end
	end,
	args = {
		raidDesc = {
			hidden = isSpellsOption,
			name = L["Assign Raid Cooldowns."],
			order = 0,
			type = "description",
		},
		clearAll = {
			name = CLEAR_ALL,
			order = 1,
			type = "execute",
			func = runClearAllDefault,
			confirm = E.ConfirmAction,
			descStyle = "inline",
		},
		default = {
			hidden = isRaidCDOption,
			name = RESET_TO_DEFAULT,
			order = 2,
			type = "execute",
			func = runClearAllDefault,
			confirm = E.ConfirmAction,
			descStyle = "inline",
		},
		showForbearanceCounter = {
			hidden = function(info) return info[1] ~= "Party" or info[3] ~= "spells" end,
			name = L["Show Forbearance CD"],
			desc = L["Show timer on spells while under the effect of Forbearance or Hypothermia. Spells castable to others will darken instead"],
			order = 3,
			type = "toggle",
			get = P.getIcons,
			set = P.setIcons,
		},
		hideDiabledSpells = {
			hidden = isSpellsOption,
			name = L["Hide Disabled Spells"],
			desc = L["Hide spells that are not enabled in the \'Spells\' menu."],
			order = 4,
			type = "toggle",
			set = function(info, state)
				E.DB.profile.Party[info[2]].raidCDS.hideDiabledSpells = state
			end,
		},
		class = {
			name = CLASS,
			order = 10,
			type = "group",
			args = {}
		},
		other = {
			name = OTHER,
			order = 20,
			type = "group",
			args = {}
		},
	}
}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	local iconCoords = CLASS_ICON_TCOORDS[class]
	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	spells.args.class.args[class] = {
		icon = E.ICO.CLASS,
		iconCoords = iconCoords,
		name = name,
		type = "group",
		args = {}
	}
end

for i = 1, #E.OTHER_SORT_ORDER do
	local class = E.OTHER_SORT_ORDER[i]
	local icon = E.ICO[class]
	local name = E.L_CATAGORY_OTHER[class]
	spells.args.other.args[class] = {
		icon = icon,
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

local function GetSpellTab(class)
	return E.L_CATAGORY_OTHER[class] and "other" or "class"
end

function P:UpdateSpellsOption(id, oldClass, oldType, class, stype, force)
	local oldTab = oldClass and GetSpellTab(oldClass)
	local sId = tostring(id)

	if oldClass or force then
		if oldClass then
			spells.args[oldTab].args[oldClass].args[oldType].args[sId] = nil
			spells.args[oldTab].args[oldClass].args[oldType].args[sId .. "E"] = nil
			if next(spells.args[oldTab].args[oldClass].args[oldType].args) == nil then
				spells.args[oldTab].args[oldClass].args[oldType] = nil
			end
		end

		if not class then
			return
		end

		local tab = GetSpellTab(class)
		local classSpells = E.spell_db[class]
		local numClassSpells = #classSpells
		local order = 1

		SortClassSpells(classSpells)

		local t = spells.args[tab].args[class].args
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
				local spellID, icon = v.spellID, v.icon
				local name = format("|T%s:20:20:0:0|t %s", icon, v.name)
				local sId = tostring(spellID)

				if t[sId] then
					t[sId].order = order
					t[sId .. "E"].order = order + 1
				else
					t[sId] = {
						hidden = isRaidOptDisabledID,
						name = name,
						order = order,
						type = "toggle",
					}

					t[sId .. "E"] = {
						hidden = isRaidOptDisabledID,
						name = "+",
						desc = "Edit spell",
						order = order + 1,
						type = "execute",
						func = function(info) E.EditSpell(nil, info[#info]:gsub("E", "")) end,
						width = 0.25,
					}
				end

				local spell = Spell:CreateFromSpellID(spellID)
				spell:ContinueOnSpellLoad(function()
					local desc = spell:GetSpellDescription()
					t[sId].desc = FormatSpellDesc(spellID, v.spec, vtype, desc, icon, v.duration, v.charges, v.parent, class)
				end)

				order = order + 2

			end
		end
	else
		local tbl = OmniCDDB.cooldowns[id]
		local class, stype = tbl.class, tbl.type
		local tab = GetSpellTab(class)

		local spell = Spell:CreateFromSpellID(id)
		spell:ContinueOnSpellLoad(function()
			local desc = spell:GetSpellDescription()
			spells.args[tab].args[class].args[stype].args[sId].desc = FormatSpellDesc(id, tbl.spec, stype, desc, tbl.icon, tbl.duration, tbl.charges, tbl.parent, class)
		end)
	end

	self:Refresh()
end

function P:AddSpellPickerSpells()
	for i = 1, 2 do
		local tab = i == 1 and "class" or "other"
		local numClasses = i == 1 and MAX_CLASSES or 4
		for j = 1, numClasses do
			local class = i == 1 and CLASS_SORT_ORDER[j] or E.OTHER_SORT_ORDER[j]
			local classSpells = E.spell_db[class]
			local numClassSpells = #classSpells
			local order = 1

			local t = spells.args[tab].args[class].args
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

					local spellID, icon = v.spellID, v.icon
					local name = format("|T%s:20:20:0:0|t %s", icon, v.name)
					local sId = tostring(spellID)

					t[vtype].args[sId] = {
						hidden = isRaidOptDisabledID,
						name = name,
						order = order,
						type = "toggle",
					}

					t[vtype].args[sId .. "E"] = {
						hidden = isRaidOptDisabledID,
						name = "+",
						desc = "Edit spell",
						order = order + 1,
						type = "execute",
						func = function(info) E.EditSpell(nil, info[#info]:gsub("E", "")) end,
						width = 0.25, -- lags
					}

					local spell = Spell:CreateFromSpellID(spellID)
					spell:ContinueOnSpellLoad(function()
						local desc = spell:GetSpellDescription()
						t[vtype].args[sId].desc = FormatSpellDesc(spellID, v.spec, vtype, desc, icon, v.duration, v.charges, v.parent, v.class)
					end)

					if v.item then -- SpellMixin not working for Covenant and Trinkets has been Hotfixed
						local item = Item:CreateFromItemID(v.item)
						item:ContinueOnItemLoad(function()
							local itemName = item:GetItemName()
							t[vtype].args[sId].name = format("|T%s:20:20:0:0|t %s", icon, itemName)
						end)
					end

					order = order + 2
				end
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
