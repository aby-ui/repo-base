local E, L, C = select(2, ...):unpack()

local P = E["Party"]
local SPELLS = type(SPELLS) == "string" and SPELLS or L["Spells"] -- TODO: remove

local isRaidCDOption = function(info) return info[3] ~= "spells" end -- cf:> info[3] == extraBars info[4] == raidCDS
local isSpellsOption = function(info) return not isRaidCDOption(info) end
local isRaidOptDisabledID = function(info)
	local key = info[2]
	return info[3] ~= "spells" and E.DB.profile.Party[key].extraBars.raidCDBar.hideDisabledSpells and not P.IsEnabledSpell(info[#info], key)
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
	--childGroups = "tab",
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
			--descStyle = "inline",
		},
		default = {
			hidden = isRaidCDOption,
			name = RESET_TO_DEFAULT,
			order = 2,
			type = "execute",
			func = runClearAllDefault,
			confirm = E.ConfirmAction,
			--descStyle = "inline",
		},
		-- TODO: Shows the type group of the searched spell. If we want to show a single spell we need to wrap it in a simple-group
		---[[
		searchBox = {
			hidden = isRaidCDOption,
			disabled = true,
			name = "",
			desc = "Enter spell name.",
			order = 3,
			type = "input",
			dialogControl = "SearchBox-OmniCD",
			get = function() return "    NYI" end,
			set = function()
				E.Libs.ACD:SelectGroup(E.AddOn, "Party", "arena", "spells", "DRUID", "cc")
			end,
		},
		--]]
		showForbearanceCounter = {
			hidden = function(info) return info[1] ~= "Party" or info[3] ~= "spells" end,
			name = L["Show Forbearance CD"],
			desc = L["Show timer on spells while under the effect of Forbearance or Hypothermia. Spells castable to others will darken instead"],
			order = 4,
			type = "toggle",
			get = P.getIcons,
			set = P.setIcons,
		},
		hideDisabledSpells = {
			hidden = isSpellsOption,
			name = L["Hide Disabled Spells"],
			desc = L["Hide spells that are not enabled in the \'Spells\' menu."],
			order = 5,
			type = "toggle",
			get = function(info) return E.DB.profile.Party[info[2]].extraBars.raidCDBar.hideDisabledSpells end,
			set = function(info, state) E.DB.profile.Party[info[2]].extraBars.raidCDBar.hideDisabledSpells = state end,
		},
	}
}

local borderlessCoords = {0.07, 0.93, 0.07, 0.93}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	--local iconCoords = CLASS_ICON_TCOORDS[class] -- back to individual class icons for tree frame
	local name = LOCALIZED_CLASS_NAMES_MALE[class]
	spells.args[class] = {
		--icon = E.ICO.CLASS,
		icon = E.ICO.CLASS .. class,
		--iconCoords = iconCoords,
		iconCoords = borderlessCoords,
		name = name,
		type = "group",
		args = {}
	}
end

spells.args.othersHeader = {
	---[[ Make the group a line break
	disabled = true,
	name = "```",
	--]]
	order = 2000, -- default: 1000
	type = "group",
	args = {}
}

local numOthers = #E.OTHER_SORT_ORDER
for i = 1, numOthers do
	local class = E.OTHER_SORT_ORDER[i]
	local icon = E.ICO[class]
	local name = E.L_CATAGORY_OTHER[class]
	spells.args[class] = {
		icon = icon,
		iconCoords = borderlessCoords,
		name = name,
		order = 2000 + i,
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

local getSpellType = function(info) end
local setSpellType = function(info) end

function P:UpdateSpellsOption(id, oldClass, oldType, class, stype, force)
	local sId = tostring(id)

	if oldClass or force then -- oldClass(delete, class/type change), force(add new custom)
		if oldClass then
			spells.args[oldClass].args[oldType].args[sId] = nil
			-- Edit
			--[[
			spells.args[oldClass].args[oldType].args[sId .. "E"] = nil
			--]]
			if next(spells.args[oldClass].args[oldType].args) == nil then
				spells.args[oldClass].args[oldType] = nil
			end
		end

		if not class then -- deleted custom only (default needs to be reverted)
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
					-- Edit
					--[[
					t[sId .. "E"].order = order + 1
					--]]
				else
					local icon, name = v.icon, v.name
					local link = GetSpellLink(spellID)

					t[sId] = {
						hidden = isRaidOptDisabledID,
						image =  icon,
						imageCoords = {0, 1, 0, 1},
						name = name,
						desc = link,
						order = order,
						type = "toggle",
						arg = spellID,
					}

					-- Edit
					--[[
					t[sId .. "E"] = {
						hidden = isRaidCDOption,
						name = "E",
						desc = "Edit spell",
						order = order + 2,
						type = "execute",
						func = function(info) E.EditSpell(nil, info[#info]:gsub("E", "")) end,
						width = 0.25,
					}
					--]]
				end

				order = order + 1
			end
		end
	end

	self:Refresh()
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
				local link = GetSpellLink(spellID)

				t[vtype].args[sId] = {
					hidden = isRaidOptDisabledID,
					image = icon,
					imageCoords = {0, 1, 0, 1}, -- values doesn't matter, just needs to be added
					name = name,
					desc = link,
					order = order,
					type = "toggle",
					arg = spellID,
				}

				-- Edit
				--[==[
				t[vtype].args[sId .. "E"] = {
					hidden = isRaidCDOption,
					name = "E",
					desc = "Edit spell",
					order = order + 2,
					type = "execute",
					func = function(info) E.EditSpell(nil, info[#info]:gsub("E", "")) end,
					width = 0.25, -- lags
				}
				--]==]

				if v.item then -- SpellMixin not working for Covenant and Trinkets has been Hotfixed
					local item = Item:CreateFromItemID(v.item)
					item:ContinueOnItemLoad(function()
						local itemName = item:GetItemName()
						t[vtype].args[sId].name = itemName
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

E.spellsOptionTbl = spells --> plugin
