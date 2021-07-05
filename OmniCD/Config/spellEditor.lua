local E, L, C = select(2, ...):unpack()

local GetNumSpecializationsForClassID = GetNumSpecializationsForClassID
local GetSpecializationInfoForClassID = GetSpecializationInfoForClassID
local GetSpecializationInfoByID = GetSpecializationInfoByID
if E.isBCC then
	GetNumSpecializationsForClassID = function() return 0 end
	GetSpecializationInfoForClassID = E.Noop
	GetSpecializationInfoByID = E.Noop
end

local spell_db = E.spell_db
local title = L["Spell Editor"]

local defaultBackup = {}
local classValues = {}
local specIDs = {}

for i = 1, MAX_CLASSES do
	local class = CLASS_SORT_ORDER[i]
	classValues[class] = format("|T%s:18|t %s", "Interface\\Icons\\ClassIcon_" .. class, LOCALIZED_CLASS_NAMES_MALE[class])
	for j = 1, GetNumSpecializationsForClassID(i) do
		local id = GetSpecializationInfoForClassID(i, j)
		specIDs[#specIDs + 1] = id
	end
end
classValues["TRINKET"] = format("|T%s:16|t %s (%s)", E.ICO.TRINKET, INVTYPE_TRINKET, ALL_CLASSES)

local function GetClassIndexBySpellID(id)
	for class, v in pairs(spell_db) do
		for i = 1, #v do
			local t = v[i]
			if (t.spellID == id) then
				return class, i
			end
		end
	end
end

-- TODO: clean this up. gives me a headache everytime.
function E:UpdateSpell(id, isInit, oldClass, oldType) -- [39]
	local class, i = GetClassIndexBySpellID(id)
	local v = OmniCDDB.cooldowns[id]
	local vclass, vtype, force
	if v then
		vclass, vtype = v.class, v.type
		if class ~= vclass then -- custom spell
			if class then -- class change custom
				tremove(spell_db[class], i)
			else -- add new custom
				force = true
			end
			spell_db[vclass][#spell_db[vclass] + 1] = v
		elseif not v.custom and not defaultBackup[id] then -- add new default spell
			defaultBackup[id] = self.DeepCopy(spell_db[class][i])
			spell_db[class][i] = v
			if E.L_HIGHLIGHTS[vtype] then
				self.Cooldowns:RegisterRemoveHighlightByCLEU(v.buff or id)
			end
			return
		else -- type change etc for default/custom
			spell_db[class][i] = v
		end

		if E.L_HIGHLIGHTS[vtype] then
			self.Cooldowns:RegisterRemoveHighlightByCLEU(v.buff or id)
		end
	else
		v = defaultBackup[id]
		if v then -- delete default
			vclass, vtype = v.class, v.type
			spell_db[class][i] = self.DeepCopy(v)
		else -- delete custom
			tremove(spell_db[class], i)
		end
	end

	if not isInit then
		for k in pairs(self.moduleOptions) do
			local func = self[k].UpdateSpellsOption
			if func then
				func(self[k], id, oldClass, oldType, vclass, vtype, force)
			end
		end
	end
end

local GetSpellID = function(info, n)
	n = n or 1
	local id = info[#info - n]
	return tonumber(id), id
end

local function GetSpecID(info, n)
	n = n or 1
	local id = info[#info - n]:gsub("spec", "")
	return tonumber(id)
end

local isOthersCategory = function(info)
	local id = GetSpellID(info)
	return E.L_CATAGORY_OTHER[OmniCDDB.cooldowns[id].class]
end

local isClassCategory = function(info)
	local id = GetSpellID(info)
	return OmniCDDB.cooldowns[id].class ~= "TRINKET" -- and OmniCDDB.cooldowns[id].class ~= "PVPTRINKET" -- 9.1 pvp-trinket itemID are merged
end

local getGlobalDurationCharge = function(info)
	local option = info[#info]
	local id = GetSpellID(info)
	return OmniCDDB.cooldowns[id][option].default
end

local setGlobalDurationCharge = function(info, value)
	local option = info[#info]
	local id = GetSpellID(info)
	OmniCDDB.cooldowns[id][option].default = value

	E:UpdateSpell(id)
end

local getItem = function(info)
	local option = info[#info]
	local id = GetSpellID(info)
	local v = OmniCDDB.cooldowns[id][option]
	if v then
		return tostring(v)
	end
end

local setItem = function(info, v)
	local option = info[#info]
	local id = GetSpellID(info)
	if v == "" then
		OmniCDDB.cooldowns[id][option] = nil
	else
		if ( string.match(v, "[^%d]+") or strlen(v) > 9 or not C_Item.DoesItemExistByID(v) ) then
			E.Write(L["Invalid ID"], v)
			return
		end
		OmniCDDB.cooldowns[id][option] = tonumber(v)
	end

	E:UpdateSpell(id)
end

local customSpellInfo = {
	spellName = {
		name = function(info)
			local id = GetSpellID(info)
			if defaultBackup[id] then
				return " |cffffd200" .. L["Spell ID"] .. "|r " .. id
			else
				return " |cffffd200" .. L["Spell ID"] .. "|r " .. id .. " |cff20ff20" .. CUSTOM
			end
		end,
		order = 0,
		type = "description",
	},
	delete = {
		name = DELETE,
		desc = L["Default spells are reverted back to original values and removed from the list only"],
		order = 1,
		type = "execute",
		func = function(info)
			local id, sId = GetSpellID(info)
			local oldClass, oldType = OmniCDDB.cooldowns[id].class, OmniCDDB.cooldowns[id].type
			if not defaultBackup[id] then
				for k in pairs(E.moduleOptions) do
					local t = E[k].spell_enabled
					if t then
						t[id] = nil
					end
				end
				for key in pairs(E.CFG_ZONE) do
					E.DB.profile.Party[key].spells[sId] = nil
					E.DB.profile.Party[key].raidCDS[sId] = nil
				end
			end
			OmniCDDB.cooldowns[id] = nil
			E.DB.profile.Party.customPriority[id] = nil
			E.options.args.SpellEditor.args.editor.args[sId] = nil

			E:UpdateSpell(id, nil, oldClass, oldType)
		end,
	},
	hd1 = {
		name = "", order = 2, type = "header",
	},
	class = {
		disabled = function(info) local id = GetSpellID(info) return defaultBackup[id] end,
		name = CLASS,
		order = 3,
		type = "select",
		values = classValues,
		set = function(info, value)
			local id = GetSpellID(info)
			local oldClass, oldType = OmniCDDB.cooldowns[id].class, OmniCDDB.cooldowns[id].type
			OmniCDDB.cooldowns[id].spec = nil
			OmniCDDB.cooldowns[id].duration = { default = OmniCDDB.cooldowns[id].duration.default }
			OmniCDDB.cooldowns[id].charges = { default = OmniCDDB.cooldowns[id].charges.default }
			OmniCDDB.cooldowns[id].class = value

			E:UpdateSpell(id, nil, oldClass, oldType)
		end,
	},
	type = {
		name = TYPE,
		desc = L["Set the spell type for sorting"],
		order = 4,
		type = "select",
		values = E.L_PRIORITY,
		set = function(info, value)
			local id = GetSpellID(info)
			local oldClass, oldType = OmniCDDB.cooldowns[id].class, OmniCDDB.cooldowns[id].type
			OmniCDDB.cooldowns[id][info[#info]] = value

			E:UpdateSpell(id, nil, oldClass, oldType)
		end,
	},
	duration = {
		name = L["Cooldown"],
		desc = E.STR.MAX_RANGE_3600,
		order = 5,
		type = "range",
		min = 1, max = 3600, softMax = 300, step = 1,
		get = getGlobalDurationCharge,
		set = setGlobalDurationCharge,
	},
	charges = {
		name = function(info)
			local id = GetSpellID(info)
			local value = OmniCDDB.cooldowns[id].charges.default
			return format(SPELL_MAX_CHARGES, value)
		end,
		order = 6,
		type = "range",
		min = 1, max = 10, step = 1,
		get = getGlobalDurationCharge,
		set = setGlobalDurationCharge,
	},
	lb1 = {
		name = "\n", order = 7, type = "description",
	},
	-- TODO:
	--[=[
	customPriority = {
		name = L["Custom Priority"],
		desc = L["Enter value to set a custom spell priority. This value is applied to all zones."],
		order = 8,
		type = "input",
		get = function(info)
			local id = GetSpellID(info)
			local v = E.DB.profile.Party.customPriority[id]
			if v then
				return tostring(v)
			end
		end,
		set = function(info, v)
			if not string.match(v, "[^%d.]+") then
				local id = GetSpellID(info)
				if v == "" then
					E.DB.profile.Party.customPriority[id] = nil
				else
					v = tonumber(v)
					if v then
						E.DB.profile.Party.customPriority[id] = v
					end
				end
			end
		end
	},
	lb2 = {
		name = "", order = 9, type = "description",
	},
	--]=]
	talentId = {
		hidden = isOthersCategory,
		name = L["Talent ID"],
		desc = L["Enter talent ID if the spell is a talent ability in any of the class specializations. This ensures proper spell detection."] .. "\n\n" .. L["Use a semi-colon(;) to seperate multiple IDs."],
		order = 10,
		type = "input",
		get = function(info)
			local id = GetSpellID(info)
			local spec = OmniCDDB.cooldowns[id].spec
			if spec then
				return table.concat(spec, ";")
			end
		end,
		set = function(info, value)
			local id = GetSpellID(info)
			local t = OmniCDDB.cooldowns[id].spec
			if t then
				table.wipe(t)
			else
				t = {}
				OmniCDDB.cooldowns[id].spec = t
			end

			value = gsub(value, ("[^%d;]"), "")
			local s, e, v = 1
			while true do
				s, e, v = strfind(value, "([^;]+)", s)
				if s == nil then break end
				s = e + 1
				if strlen(v) < 9 and (C_Spell.DoesSpellExist(v) or GetSpecializationInfoByID(v)) then
					table.insert(t, tonumber(v))
				end
			end

			E:UpdateSpell(id)
		end,
	},
	item = {
		hidden = isClassCategory,
		name = format("%s: %s", INVTYPE_TRINKET, L["Item ID (Optional)"]),
		desc = L["Enter item ID to enable spell when the item is equipped only"],
		order = 11,
		type = "input",
		get = getItem,
		set = setItem,
	},
	item2 = {
		disabled = function(info) local id = GetSpellID(info) return OmniCDDB.cooldowns[id].item == nil end,
		hidden = isClassCategory,
		name = L["Item ID (Optional)"] .. " 2",
		order = 12,
		type = "input",
		get = getItem,
		set = setItem,
	},
	--[[
	tt = {
		hidden = isClassCategory,
		name = "\n" .. L["Toggle \"Show Spell ID in Tooltips\" to retrieve item IDs"],
		order = 13,
		type = "description",
	},
	--]]
	lb3 = {
		name = "", order = 14, type = "description",
	},
	buff = {
		hidden = function(info)
			local id = GetSpellID(info)
			return not E.L_HIGHLIGHTS[OmniCDDB.cooldowns[id].type]
		end,
		name = L["Buff ID (Optional)"],
		desc = L["Enter buff ID if it differs from spell ID for Highlights to work"],
		order = 15,
		type = "input",
		get = function(info)
			local option = info[#info]
			local id = GetSpellID(info)
			local v = OmniCDDB.cooldowns[id][option]
			return v and tostring(v) or tostring(id)
		end,
		set = function(info, v)
			local option = info[#info]
			local id = GetSpellID(info)
			if v == "" then
				OmniCDDB.cooldowns[id][option] = id
			else
				if ( string.match(v, "[^%d]+") or strlen(v) > 9 or not C_Spell.DoesSpellExist(v) ) then
					E.Write(L["Invalid ID"], v)
					return
				end
				OmniCDDB.cooldowns[id][option] = tonumber(v)
			end

			E:UpdateSpell(id)
		end,
	},
	lb4 = {
		name = "\n", order = 16, type = "description",
	},
	-- TODO:
	--[=[
	addToAlerts = {
		disabled = true,
		name = "+ " .. L["Add to Alerts"],
		desc = L["Add spell to Spell Alerts"],
		order = 17,
		type = "execute",
		func = function(info)

		end,
	}
	--]=]
}

if not E.isBCC then
	local customSpellSpecInfo = {
		enabled = {
			name = ENABLE,
			desc = L["Enable if the spell is a base ability for this specialization"],
			order = 1,
			type = "toggle",
			get = function(info)
				local id = GetSpellID(info, 2)
				local specID = GetSpecID(info)
				local spec = OmniCDDB.cooldowns[id].spec
				if not spec then return true end
				for i = 1, #spec do
					if spec[i] == specID then return true end
				end
			end,
			set = function(info, value)
				local id = GetSpellID(info, 2)
				local specID = GetSpecID(info)
				if not OmniCDDB.cooldowns[id].spec then
					OmniCDDB.cooldowns[id].spec = {}
					for i = 1, #specIDs do
						local class = select(6, GetSpecializationInfoByID(specIDs[i]))
						if OmniCDDB.cooldowns[id].class == class then
							tinsert(OmniCDDB.cooldowns[id].spec, specIDs[i])
						end
					end
				end
				for i = #OmniCDDB.cooldowns[id].spec, 1, -1 do
					if not value and OmniCDDB.cooldowns[id].spec[i] == specID then
						tremove(OmniCDDB.cooldowns[id].spec, i)
						break
					end
				end
				if value then
					tinsert(OmniCDDB.cooldowns[id].spec, specID)
				end

				E:UpdateSpell(id)
			end,
		},
		hd1 = {
			name = "", order = 2, type = "header",
		},
		duration = {
			name = L["Cooldown"],
			desc = L["Set to override the global cooldown setting for this specialization"],
			order = 3,
			type = "range",
			min = 1, max = 999, softMax = 300, step = 1,
		},
		charges = {
			name = L["Charges"],
			order = 4,
			type = "range",
			min = 1, max = 10, step = 1,
		},
	}

	local customSpellSpecGroup = {
		hidden = function(info)
			local specID = GetSpecID(info, 0)
			if not specID then return end -- [77]

			local id = GetSpellID(info)
			local class = OmniCDDB.cooldowns[id].class
			if class == "TRINKET" then return true end
			if class ~= select(6, GetSpecializationInfoByID(specID)) then return true end
		end,
		icon = function(info) local specID = GetSpecID(info, 0) return select(4,GetSpecializationInfoByID(specID)) end,
		name = function(info) local specID = GetSpecID(info, 0) return select(2,GetSpecializationInfoByID(specID)) end,
		type = "group",
		get = function(info)
			local option = info[#info]
			local id = GetSpellID(info, 2)
			local specID = GetSpecID(info)
			return OmniCDDB.cooldowns[id][option][specID] or OmniCDDB.cooldowns[id][option].default
		end,
		set = function(info, value)
			local option = info[#info]
			local id = GetSpellID(info, 2)
			local specID = GetSpecID(info)
			if value == OmniCDDB.cooldowns[id][option].default then
				value = nil
			end
			OmniCDDB.cooldowns[id][option][specID] = value

			E:UpdateSpell(id)
		end,
		args = customSpellSpecInfo
	}

	for i = 1, #specIDs do
		local specID = specIDs[i]
		customSpellInfo["spec" .. specID] = customSpellSpecGroup
	end
end

local customSpellGroup = {
	icon = function(info) local id = GetSpellID(info,0) return select(2,GetSpellTexture(id)) end,
	name = function(info) local id = GetSpellID(info,0) return GetSpellInfo(id) end,
	type = "group",
	args = customSpellInfo,
}

E.EditSpell = function(_, value)
	if strlen(value) > 9 then
		return E.Write(L["Invalid ID"], value)
	end

	local id = tonumber(value)
	local name = GetSpellInfo(id)
	if not name then
		return E.Write(L["Invalid ID"], value)
	end

	if OmniCDDB.cooldowns[id] then
		return E.Libs.ACD:SelectGroup(E.AddOn, "SpellEditor", "editor", value)
	end

	local class, i = GetClassIndexBySpellID(id)
	local _, icon = GetSpellTexture(id)
	if class and i then
		OmniCDDB.cooldowns[id] = spell_db[class][i]
		local duration = OmniCDDB.cooldowns[id].duration
		if type(duration) == "number" then
			OmniCDDB.cooldowns[id].duration = { default = duration }
		end
		local charges = OmniCDDB.cooldowns[id].charges
		if type(charges) ~= "table" then
			OmniCDDB.cooldowns[id].charges = { default = charges or 1 }
		end
		local spec = OmniCDDB.cooldowns[id].spec
		spec = spec == true and id or (type(spec) == "number" and spec)
		if spec then
			OmniCDDB.cooldowns[id].spec = { spec }
		end
	else
		OmniCDDB.cooldowns[id] = {
			["spellID"] = id,
			["duration"] = {default = 30},
			["type"] = "trinket",
			["charges"] = {default = 1},
			["icon"] = icon, ["class"] = "TRINKET", ["custom"] = true,
			["buff"] = id,
			["name"] = name,
		}
	end

	E.options.args.SpellEditor.args.editor.args[value] = customSpellGroup

	E:UpdateSpell(id)
	E.Libs.ACD:SelectGroup(E.AddOn, "SpellEditor", "editor", value)
end

local SpellEditor = {
	name = title,
	order = 900,
	type = "group",
	childGroups = "tab",
	get = function(info)
		local option = info[#info]
		local id = GetSpellID(info)
		if id then
			return OmniCDDB.cooldowns[id][option]
		end
	end,
	set = function(info, value)
		local option = info[#info]
		local id = GetSpellID(info)
		OmniCDDB.cooldowns[id][option] = value

		E:UpdateSpell(id)
	end,
	args = {
		title = {
			name = "|cffffd200" .. title,
			order = 0,
			type = "description",
			fontSize = "large",
		},
		editor = {
			name = title,
			order = 10,
			type = "group",
			args ={
				spellId = {
					order = 0,
					name = L["Spell ID"],
					desc = L["Enter Spell ID to Add/Edit"],
					type = "input",
					set = E.EditSpell,
				},
			}
		},
		utils = {
			name = L["Utils"],
			order = 20,
			type = "group",
			args = {
				tooltipID = {
					order = 1,
					name = L["Show Spell ID in Tooltips"],
					type = "toggle",
					get = function() return E.DB.profile.tooltipID end,
					set = function(_, state)
						E.DB.profile.tooltipID = state
						E.TooltipID:SetHooks()
					end,
				},
			}
		},
	}
}

function E:AddSpellPickers()
	for k in pairs(self.moduleOptions) do
		local func = self[k].AddSpellPicker
		if func then
			func(self[k])
		end
	end
end

function E:AddSpellEditor()
	for id in pairs(OmniCDDB.cooldowns) do
		if not C_Spell.DoesSpellExist(id) then
			OmniCDDB.cooldowns[id] = nil
			--E.Write("Removing Invalid ID (User Added): |cffffd200" .. id)
		else
			id = tostring(id)
			SpellEditor.args.editor.args[id] = customSpellGroup
		end
	end

	self.options.args["SpellEditor"] = SpellEditor

	self:AddSpellPickers()
end

function E:UpdateSpellList(isInit)
	for id in pairs(OmniCDDB.cooldowns) do
		self:UpdateSpell(id, isInit)
	end
end
