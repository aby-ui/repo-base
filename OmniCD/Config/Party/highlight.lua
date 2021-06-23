local E, L, C = select(2, ...):unpack()

local P = E["Party"]
local HIGHLIGHTING = HIGHLIGHTING:gsub(":", "")

local markEnhancedDesc = {}

for k, v in pairs(E.spell_marked) do
	if not C_Spell.DoesSpellExist(k) or (v ~= true and not C_Spell.DoesSpellExist(v)) then
		E.spell_marked[k] = nil
		--E.Write("Removing Invalid ID (Enhanced): |cffffd200" .. k)
	else
		local id = v == true and k or v
		local name, _, icon = GetSpellInfo(id)
		name = format("|T%s:18|t %s", icon, name)
		markEnhancedDesc[#markEnhancedDesc + 1] = name
	end
end
markEnhancedDesc = E.FormatConcat(markEnhancedDesc, "%s\n")

local highlight = {
	name = HIGHLIGHTING,
	order = 35,
	type = "group",
	get = function(info) return E.DB.profile.Party[info[2]].highlight[info[#info]] end,
	set = function(info, value)
		local key = info[2]
		E.DB.profile.Party[key].highlight[info[#info]] = value

		if E.db == E.DB.profile.Party[key] then
			P:Refresh()
		end
	end,
	args = {
		glow = {
			name = L["Glow Icons"],
			order = 10,
			type = "group",
			inline = true,
			args = {
				glow = {
					name = ENABLE,
					desc = L["Display a glow animation around an icon when it is activated"],
					order = 1,
					type = "toggle",
				},
				--[[
				glowColor = {
					name = COLOR,
					order = 2,
					type = "select",
					values = E.L_GLOW_ATLAS,
				},
				]]
			}
		},
		highlight = {
			disabled = function(info) return info[5] and not E.DB.profile.Party[info[2]].highlight.glowBuffs end,
			name = L["Highlight Icons"],
			order = 20,
			type = "group",
			inline = true,
			args = {
				glowBuffs = {
					disabled = false,
					name = ENABLE,
					desc = L["Highlight the icon when a buffing spell is used until the buff falls off"],
					order = 1,
					type = "toggle",
				},
				glowType = {
					name = TYPE,
					order = 2,
					type = "select",
					values = {
						actionBar = L["Strong Yellow Glow"],
						wardrobe = L["Weak Purple Glow"],
					}
				},
				buffTypes = {
					name = L["Spell Types"],
					order = 3,
					type = "multiselect",
					get = function(info, k) return E.DB.profile.Party[info[2]].highlight.glowBuffTypes[k] end,
					set = function(info, k, value)
						local key = info[2]
						E.DB.profile.Party[key].highlight.glowBuffTypes[k] = value

						if E.db == E.DB.profile.Party[key] then
							P:Refresh()
						end
					end,
					values = E.L_HIGHLIGHTS,
					--descStyle = "inline",
				},
			}
		},
		markEnhanced = {
			disabled = function(info) return not E.DB.profile.Party[info[2]].icons.markEnhanced end,
			name = L["Mark Enhanced Spells"],
			order = 30,
			type = "group",
			inline = true,
			args = {
				markEnhanced = { -- exists under icons, not highlight
					disabled = false,
					name = ENABLE,
					desc = L["Mark icons with a red dot to indicate enhanced spells"] .. "\n\n" .. markEnhancedDesc,
					order = 1,
					type = "toggle",
					get = P.getIcons,
					set = P.setIcons,
				},
				markedSpells = {
					name = L["Add Spells"],
					desc = L["%d: spellID.\n%d-%d: spellID-talentID (Mark spell if talent is selected)."] .. "\n\n" .. L["Use a semi-colon(;) to seperate multiple IDs."],
					order = 2,
					type = "input",
					--multiline = 1, -- no support for this yet
					width = "full",
					get = function(info)
						local t = E.DB.profile.Party[info[2]].highlight.markedSpells.str
						return t and table.concat(t, ";")
					end,
					set = function(info, value)
						local key = info[2]
						local t = E.DB.profile.Party[key].highlight.markedSpells
						table.wipe(t)

						value = gsub(value, ("[^%d-;]"), "")
						local s, e, v = 1
						while true do
							s, e, v = strfind(value, "([^;]+)", s)
							if s == nil then break end
							s = e + 1
							local a, b = strsplit("-", v)
							if strlen(a) > 1 and strlen(a) < 9 and C_Spell.DoesSpellExist(a) then
								local a = tonumber(a)
								if not E.spell_marked[a] then -- overwrite t[a]
									t.str = t.str or {}
									if b then
										if strlen(b) > 1  and strlen(b) < 9 and C_Spell.DoesSpellExist(b) then
											t[a] = tonumber(b)
											table.insert(t.str, v)
										end
									else
										t[a] = true
										table.insert(t.str, v)
									end
								end
							end
						end

						P:ConfigIcons(key, "markEnhanced")
					end,
				}
			}
		},
	}
}

function P:AddHighlightOption(key)
	P.options.args[key].args.highlight = highlight
end
