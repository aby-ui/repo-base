local OmniBar = LibStub("AceAddon-3.0"):GetAddon("OmniBar")
local L = LibStub("AceLocale-3.0"):GetLocale("OmniBar")

local _

local points = {
	TOPLEFT = L["Top Left"],
	TOP = L["Top"],
	TOPRIGHT = L["Top Right"],
	LEFT = L["Left"],
	CENTER = L["Center"],
	RIGHT = L["Right"],
	BOTTOMLEFT = L["Bottom Left"],
	BOTTOM = L["Bottom"],
	BOTTOMRIGHT = L["Bottom Right"],
}

local tooltip = CreateFrame("GameTooltip", "OmniBarTooltip", UIParent, "GameTooltipTemplate")
local function GetSpellTooltipText(spellID)
	tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	tooltip:SetSpellByID(spellID)
	local lines = tooltip:NumLines()
	if lines < 1 then return end
	local line = _G["OmniBarTooltipTextLeft"..lines]:GetText()
	if not line then return end
	tooltip:Hide()
	return line
end

local function IsSpellEnabled(info)
	local key = info[2]
	return OmniBar_IsSpellEnabled(_G[key], OmniBar.options.args.bars.args[key].args.spells.args[info[4]].args[info[5]].arg)
end

StaticPopupDialogs["OMNIBAR_DELETE"] = {
	text = DELETE.." \"%s\"",
	button1 = YES,
	button2 = NO,
	OnAccept = function(self, data)
		OmniBar:Delete(data)
	end,
	timeout = 0,
	whileDead = true,
}


function OmniBar:ToggleLock(button)
	self.db.profile.bars[button.arg].locked = not self.db.profile.bars[button.arg].locked
	OmniBar_Position(_G[button.arg])
	self.options.args.bars.args[button.arg].args.lock.name = self.db.profile.bars[button.arg].locked and L["Unlock"] or L["Lock"]
end

local function GetSpells()
	local spells = {
		uncheck = {
			name = L["Uncheck All"],
			type = "execute",
			func = function(info)
				local key = info[#info-2]
				for option,_ in pairs(OmniBar.db.profile.bars[key]) do
					if option:match("^spell") then
						OmniBar.db.profile.bars[key][option] = false
					end
				end
				OmniBar.db.profile.bars[key].noDefault = true
				OmniBar:Refresh(true)
			end,
			order = 1,
		},
		check = {
			name = L["Check Default Spells"],
			type = "execute",
			func = function(info)
				local key = info[#info-2]
				local bar = _G[key]
				OmniBar.db.profile.bars[key].noDefault = nil
				for spellID, spell in pairs(OmniBar.cooldowns) do
					if spell.default then
						OmniBar_CreateIcon(bar)
						OmniBar.db.profile.bars[key]["spell"..spellID] = nil
					end
				end
				OmniBar:Refresh(true)
			end,
			order = 2,
		},
	}
	local descriptions = {}
	for i = 1, MAX_CLASSES do

		spells[CLASS_SORT_ORDER[i]] = {
			name = LOCALIZED_CLASS_NAMES_MALE[CLASS_SORT_ORDER[i]],
			type = "group",
			args = {},
			icon = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
			iconCoords = CLASS_ICON_TCOORDS[CLASS_SORT_ORDER[i]]
		}

		for spellID, spell in pairs(OmniBar.cooldowns) do

			if spell.class and spell.class == CLASS_SORT_ORDER[i] then
				local text = GetSpellInfo(spellID) or ""
				local spellTexture = GetSpellTexture(spellID) or ""
				if string.len(text) > 25 then
					text = string.sub(text, 0, 22) .. "..."
                end
                if not C_Spell.DoesSpellExist(spellID) then
                    print("OmniBar SpellID ", spellID, " not exists")
                else
				local s = Spell:CreateFromSpellID(spellID)
				s:ContinueOnSpellLoad(function()
					descriptions[spellID] = s:GetSpellDescription()
				end)
                end

				spells[CLASS_SORT_ORDER[i]].args["spell"..spellID] = {
					name = text,
					type = "toggle",
					get = IsSpellEnabled,
					width = "full",
					arg = spellID,
					desc = function()
						local duration = type(spell.duration) == "number" and spell.duration or spell.duration.default
						local spellDesc = descriptions[spellID] or ""
						local extra = "\n\n|cffffd700 "..L["Spell ID"].."|r "..spellID..
							"\n\n|cffffd700 "..L["Cooldown"].."|r "..SecondsToTime(duration)
						return spellDesc..extra
					end,
					name = function()
						return format("|T%s:20|t %s", spellTexture, text)
					end,
				}

			end

		end
	end
	return spells
end

function OmniBar:AddBarToOptions(key, refresh)
	self.options.args.bars.args[key] = {
		name = self.db.profile.bars[key].name,
		type = "group",
		order = self.index + 1,
		childGroups = "tab",
		get = function(info)
			local option = info[#info]
			return self.db.profile.bars[key][option]
		end,
		set = function(info, state)
			local option = info[#info]
			self.db.profile.bars[key][option] = state
			self:Refresh()
		end,
		args = {
			settings = {
				name = L["Settings"],
				type = "group",
				order = 10,
				args = {
					name = {
						name = L["Name"],
						desc = L["Set the name of the bar"],
						type = "input",
						width = "double",
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self.options.args.bars.args[key].name = state
							local f = _G[key.."AnchorText"]
							f:SetText(state)
							local width = f:GetWidth() + 28
							_G[key.."Anchor"]:SetSize(width, 30)
							self:Refresh()
						end,
						order = 1,
					},
					lb1 = {
						name = "",
						type = "description",
						order = 2,
					},
					center = {
						name = L["Center Lock"],
						desc = L["Keep the bar centered horizontally"],
						width = "normal",
						type = "toggle",
						order = 3,
					},
					showUnused = {
						name = L["Show Unused Icons"],
						desc = L["Icons will always remain visible"],
						width = "normal",
						type = "toggle",
						order = 4,
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
					},
					adaptive = {
						name = L["As Enemies Appear"],
						desc = L["Only show unused icons for arena opponents or enemies you target while in combat"],
						disabled = function()
							return not self.db.profile.bars[key].showUnused
						end,
						width = "normal",
						type = "toggle",
						order = 5,
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
					},
					growUpward = {
						name = L["Grow Rows Upward"],
						desc = L["Toggle the grow direction of the icons"],
						width = "normal",
						type = "toggle",
						order = 6,
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							OmniBar_Position(_G[key])
						end,
					},
					cooldownCount = {
						name = L["Countdown Count"],
						desc = L["Allow Blizzard and other addons to display countdown text on the icons"],
						width = "normal",
						type = "toggle",
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
						order = 7,
					},
					border = {
						name = L["Show Border"],
						desc = L["Draw a border around the icons"],
						width = "normal",
						type = "toggle",
						order = 8,
					},
					highlightTarget = {
						name = L["Highlight Target"],
						desc = L["Draw a border around your target"],
						width = "normal",
						type = "toggle",
						order = 9,
					},
					names = {
						name = L["Show Names"],
						desc = L["Show the player name of the spell"],
						width = "normal",
						type = "toggle",
						order = 11,
					},
					multiple = {
						name = L["Track Multiple Players"],
						desc = L["If another player is detected using the same ability, a duplicate icon will be created and tracked separately"],
						width = "normal",
						type = "toggle",
						order = 16,
					},
					glow = {
						name = L["Glow Icons"],
						desc = L["Display a glow animation around an icon when it is activated"],
						width = "normal",
						type = "toggle",
						order = 17,
					},
					tooltips = {
						name = L["Show Tooltips"],
						desc = L["Show spell information when mousing over the icons (the bar must be unlocked)"],
						width = "normal",
						type = "toggle",
						order = 18,
					},
					lb2 = {
						name = "",
						type = "description",
						order = 19,
					},
					align = {
						name = L["Alignment"],
						desc = L["Set the alignment of the icons to the anchor"],
						type = "select",
						values = {
							CENTER = L["Center"],
							LEFT = L["Left"],
							RIGHT = L["Right"],
						},
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
						order = 20,
					},
					lb5 = {
						name = "",
						type = "description",
						order = 21,
					},
					size = {
						name = L["Size"],
						desc = L["Set the size of the icons"],
						type = "range",
						min = 1,
						max = 100,
						step = 1,
						order = 100,
						width = "double",
					},
					sizeDesc = {
						name = L["Set the size of the icons"] .. "\n",
						type = "description",
						order = 101,
					},
					columns = {
						name = L["Columns"],
						desc = L["Set the maximum icons per row"],
						type = "range",
						min = 1,
						max = 100,
						step = 1,
						order = 102,
						width = "double",
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							OmniBar_Position(_G[key])
						end,
					},
					columnsDesc = {
						name = L["Set the maximum icons per row"] .. "\n",
						type = "description",
						order = 103,
					},
					maxIcons = {
						name = L["Icon Limit"],
						desc = L["Set the maximum number of icons displayed on the bar"],
						type = "range",
						min = 1,
						max = 500,
						step = 1,
						order = 104,
						width = "double",
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
					},
					maxIconsDesc = {
						name = L["Set the maximum number of icons displayed on the bar"] .. "\n",
						type = "description",
						order = 105,
					},
					padding = {
						name = L["Padding"],
						desc = L["Set the space between icons"],
						type = "range",
						min = 0,
						max = 100,
						step = 1,
						order = 106,
						width = "double",
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							OmniBar_Position(_G[key])
						end,
					},
					paddingDesc = {
						name = L["Set the space between icons"] .. "\n",
						type = "description",
						order = 107,
					},
					unusedAlpha = {
						name = L["Unused Icon Transparency"],
						desc = L["Set the transparency of unused icons"],
						isPercent = true,
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						order = 108,
						width = "double",
					},
					unusedAlphaDesc = {
						name = L["Set the transparency of unused icons"] .. "\n",
						type = "description",
						order = 109,
					},
					swipeAlpha = {
						name = L["Swipe Transparency"],
						desc = L["Set the transparency of the swipe animation"],
						isPercent = true,
						type = "range",
						min = 0,
						max = 1,
						step = 0.01,
						order = 110,
						width = "double",
					},
					swipeAlphaDesc = {
						name = L["Set the transparency of the swipe animation"] .. "\n",
						type = "description",
						order = 111,
					},

				},
			},
			position = {
				name = L["Position"],
				type = "group",
				order = 11,
				get = function(info)
					local option = info[#info]
					return self.db.profile.bars[key].position[option]
				end,
				set = function(info, state)
					local option = info[#info]
					local set = {}
					set[option] = state
					OmniBar_SavePosition(_G[key], set)
					OmniBar_LoadPosition(_G[key])
				end,
				args = {
					reset = {
						name = L["Reset"],
						desc = L["Reset the position of the bar"],
						type = "execute",
						func = function()
							OmniBar_SavePosition(_G[key], {
								point = "CENTER",
								relativeTo = "UIParent",
								relativePoint = "CENTER",
								xOfs = 0,
								yOfs = 0,
								frameStrata = "MEDIUM",
							})
							OmniBar_LoadPosition(_G[key])
						end,
						order = 1,
					},
					lb3 = {
						name = "",
						type = "description",
						order = 2,
					},
					point = {
						name = L["Point"],
						desc = L["Set the point of the bar that will anchor"],
						type = "select",
						values = points,
						order = 3,
					},
					lb4 = {
						name = "",
						type = "description",
						order = 4,
					},
					relativeTo = {
						type = "input",
						width = "double",
						name = L["Relative To"],
						desc = L["Set the name of the frame the bar will attach to"],
						order = 5,
					},
					relativePoint = {
						name = L["Relative Point"],
						desc = L["Set the point of the frame to attach the bar"],
						type = "select",
						values = points,
						order = 7,
					},
					lb6 = {
						name = "",
						type = "description",
						order = 8,
					},
					xOfs = {
						type = "range",
						name = L["X"],
						desc = L["Set the X offset of the bar"],
						min = -2560,
						max = 2560,
						bigStep = 4,
						order = 9,
					},
					yOfs = {
						type = "range",
						name = L["Y"],
						desc = L["Set the Y offset of the bar"],
						min = -1600,
						max = 1600,
						bigStep = 5,
						order = 10,
					},
					lb7 = {
						name = "",
						type = "description",
						order = 11,
					},
					frameStrata = {
						name = L["Frame Strata"],
						desc = L["Set the strata of the bar"],
						type = "select",
						values = {
							BACKGROUND = L["Background"],
							LOW = L["Low"],
							MEDIUM = L["Medium"],
							HIGH = L["High"],
							DIALOG = L["Dialog"],
							FULLSCREEN = L["Fullscreen"],
							FULLSCREEN_DIALOG = L["Fullscreen Dialog"],
							TOOLTIP = L["Tooltip"],
						},
						order = 12,
					},
				},
			},
			visibility = {
				name = L["Visibility"],
				type = "group",
				set = function(info, state)
					local option = info[#info]
					self.db.profile.bars[key][option] = state
					OmniBar_OnEvent(_G[key], "PLAYER_ENTERING_WORLD")
				end,
				order = 12,
				args = {
					battleground = {
						name = L["Show in Battlegrounds"],
						desc = L["Show the icons in battlegrounds"],
						width = "double",
						type = "toggle",
						order = 13,
					},
					world = {
						name = L["Show in World"],
						desc = L["Show the icons in the world"],
						width = "double",
						type = "toggle",
						order = 15,
					},
				},
			},
			spells = {
				name = L["Spells"],
				type = "group",
				order = 13,
				arg = key,
				args = GetSpells(),
				set = function(info, state)
					local option = info[#info]
					self.db.profile.bars[key][option] = state
					OmniBar_CreateIcon(_G[key])
					self:Refresh(true)
				end,
			},
			lock = {
				type = "execute",
				name = self.db.profile.bars[key].locked and L["Unlock"] or L["Lock"],
				desc = L["Lock the bar to prevent dragging"],
				arg = key,
				func = "ToggleLock",
				handler = OmniBar,
				order = 1,
			},
			delete = {
				type = "execute",
				name = L["Delete"],
				desc = L["Delete the bar"],
				func = function()
					local popup = StaticPopup_Show("OMNIBAR_DELETE", self.db.profile.bars[key].name)
					if popup then popup.data = key end
				end,
				arg = key,
				order = 2,
			},
		},
	}

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		self.options.args.bars.args[key].args.settings.args.highlightFocus = {
			name = L["Highlight Focus"],
			desc = L["Draw a border around your focus"],
			width = "normal",
			type = "toggle",
			order = 10,
		}

		self.options.args.bars.args[key].args.visibility.args.arena = {
			name = L["Show in Arena"],
			desc = L["Show the icons in arena"],
			width = "double",
			type = "toggle",
			order = 11,
		}

		self.options.args.bars.args[key].args.visibility.args.ratedBattleground = {
			name = L["Show in Rated Battlegrounds"],
			desc = L["Show the icons in rated battlegrounds"],
			width = "double",
			type = "toggle",
			order = 12,
		}

		self.options.args.bars.args[key].args.visibility.args.scenario = {
			name = L["Show in Scenarios"],
			desc = L["Show the icons in scenarios"],
			width = "double",
			type = "toggle",
			order = 14,
		}
	end

	if refresh then LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar") end
end

local specIDs = {
	62, 63, 64, 65, 66, 70, 71, 72, 73, 102, 103, 104, 105,
	250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260,
	261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 577, 581
}

local customSpellInfo = {
	spellId = {
		order = 1,
		type = "description",
		name = function(info)
			local spellId = info[#info-1]:gsub("spell", "")
			return "|cffffd700 ".."Spell ID".."|r ".. spellId .."\n"
		end,
	},
	delete = {
		type = "execute",
		name = L["Delete"],
		desc = L["Delete the cooldown"],
		func = function(info)
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId] = nil
			OmniBar.cooldowns[spellId] = nil
			OmniBar:AddCustomSpells()
			OmniBar.options.args.customSpells.args[info[#info-1]] = nil
			OmniBar:OnEnable() -- to refresh the bar spells tab
			LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
		end,
		order = 2,
	},
	lb = {
		name = "",
		type = "header",
		order = 3,
	},
	duration = {
		name = L["Duration"],
		width = "double",
		desc = L["Set the duration of the cooldown"],
		type = "range",
		min = 1,
		max = 600,
		step = 1,
		order = 4,
		set = function(info, state)
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId].duration.default = state
			OmniBar:AddCustomSpells()
		end,
		get = function(info)
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			return OmniBar.db.global.cooldowns[spellId].duration.default
		end,

	},
	charges = {
		order = 6,
		type = "range",
		min = 1,
		max = 10,
		step = 1,
		name = L["Charges"],
		desc = L["Set the charges of the cooldown"],
		set = function(info, state)
			local option = info[#info]
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			if state == 1 then state = nil end
			OmniBar.db.global.cooldowns[spellId][option] = state
			OmniBar:AddCustomSpells()
		end,
		get = function(info)
			local option = info[#info]
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			local value = OmniBar.db.global.cooldowns[spellId][option]
			if not value then return 1 end
			return OmniBar.db.global.cooldowns[spellId][option]
		end,
	},
	class = {
		name = L["Class"],
		desc = L["Set the class of the cooldown"],
		type = "select",
		values = LOCALIZED_CLASS_NAMES_MALE,
		order = 5,
		set = function(info, state)
			local option = info[#info]
			local spellId = info[#info-1]:gsub("spell", "")
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId].specID = nil
			OmniBar.db.global.cooldowns[spellId].duration = { default = OmniBar.db.global.cooldowns[spellId].duration.default }
			OmniBar.db.global.cooldowns[spellId][option] = state
			OmniBar:OnEnable() -- to refresh the bar spells tab
			OmniBar:AddCustomSpells()
		end,
	},
}

local customSpells = {
	spellId = {
		name = L["Spell ID"],
		type = "input",
		set = function(info, state)
			local spellId = tonumber(state)
			local name = GetSpellInfo(spellId)
			if OmniBar.db.global.cooldowns[spellId] then return end
			if spellId and name then
				OmniBar.db.global.cooldowns[spellId] = OmniBar.cooldowns[spellId] or { custom = true, duration = { default = 30 } , class = "DEATHKNIGHT" }

				local duration
				-- If it's a child convert it
				if OmniBar.db.global.cooldowns[spellId].parent then
					-- If the child has a custom duration, save it so we can restore it after we copy from parent
					if OmniBar.db.global.cooldowns[spellId].duration then
						duration = OmniBar.db.global.cooldowns[spellId].duration
					end

					OmniBar.db.global.cooldowns[spellId] = OmniBar:CopyCooldown(OmniBar.cooldowns[OmniBar.db.global.cooldowns[spellId].parent])

					-- Restore child's duration
					if duration then
						OmniBar.db.global.cooldowns[spellId].duration = duration
					end
				end

				-- convert duration to array
				if type(OmniBar.db.global.cooldowns[spellId].duration) == "number" then
					OmniBar.db.global.cooldowns[spellId].duration = { default = OmniBar.db.global.cooldowns[spellId].duration }
				end
				OmniBar:AddCustomSpells()

				OmniBar.options.args.customSpells.args["spell"..spellId] = {
					name = name,
					type = "group",
					childGroups = "tab",
					args = customSpellInfo,
					icon = GetSpellTexture(spellId),
				}
				OmniBar:OnEnable() -- to refresh the bar spells tab
				LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
			end
		end,
	},
}

if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
	for i = 1, #specIDs do
		local specID = specIDs[i]
		local _, name, _, icon = GetSpecializationInfoByID(specID)
		customSpellInfo["spec"..specID] = {
			name = format("|T%s:20|t %s", icon, name),
			hidden = function(info)
				local spellId = info[#info-1]:gsub("spell", "")
				spellId = tonumber(spellId)
				local specID = info[#info]:gsub("spec", "")
				specID = tonumber(specID)
				if not specID then return end
				if OmniBar.db.global.cooldowns[spellId].class ~= select(6, GetSpecializationInfoByID(specID)) then return true end
			end,
			desc = "",
			type = "group",
			args = {
				enabled = {
					name = L["Enabled"],
					desc = L["Enable the cooldown for this specialization"],
					type = "toggle",
					order = 1,
					get = function(info)
						local option = info[#info]
						local spellId = info[#info-2]:gsub("spell", "")
						spellId = tonumber(spellId)
						local specID = info[#info-1]:gsub("spec", "")
						specID = tonumber(specID)
						if not OmniBar.db.global.cooldowns[spellId].specID then return true end
						for i = 1, #OmniBar.db.global.cooldowns[spellId].specID do
							if OmniBar.db.global.cooldowns[spellId].specID[i] == specID then return true end
						end
						return false
					end,
					set = function(info, state)
						local option = info[#info]
						local spellId = info[#info-2]:gsub("spell", "")
						spellId = tonumber(spellId)
						local specID = info[#info-1]:gsub("spec", "")
						specID = tonumber(specID)

						-- check all specs first
						if not OmniBar.db.global.cooldowns[spellId].specID then
							OmniBar.db.global.cooldowns[spellId].specID = {}
							for i = 1, #specIDs do
								if OmniBar.db.global.cooldowns[spellId].class == select(6, GetSpecializationInfoByID(specIDs[i])) then
									table.insert(OmniBar.db.global.cooldowns[spellId].specID, specIDs[i])
								end
							end
						end

						-- then remove if we unchecked
						for i = #OmniBar.db.global.cooldowns[spellId].specID, 1, -1 do
							if not state and OmniBar.db.global.cooldowns[spellId].specID[i] == specID then
								table.remove(OmniBar.db.global.cooldowns[spellId].specID, i)
								break
							end
						end

						-- add if we checked it
						if state then
							table.insert(OmniBar.db.global.cooldowns[spellId].specID, specID)
						end

						OmniBar:AddCustomSpells()
					end,

				},
				duration = {
					name = L["Duration"],
					desc = L["Set the duration of the cooldown"],
					type = "range",
					min = 1,
					max = 600,
					step = 1,
					order = 2,
					set = function(info, state)
						local option = info[#info]
						local spellId = info[#info-2]:gsub("spell", "")
						spellId = tonumber(spellId)
						local specID = info[#info-1]:gsub("spec", "")
						specID = tonumber(specID)
						if state == OmniBar.db.global.cooldowns[spellId].duration.default then
							state = nil
						end
						OmniBar.db.global.cooldowns[spellId].duration[specID] = state
						OmniBar:AddCustomSpells()
					end,
					get = function(info)
						local option = info[#info]
						local spellId = info[#info-2]:gsub("spell", "")
						spellId = tonumber(spellId)
						local specID = info[#info-1]:gsub("spec", "")
						specID = tonumber(specID)
						return OmniBar.db.global.cooldowns[spellId].duration[specID] or OmniBar.db.global.cooldowns[spellId].duration.default
					end,
				},
			},
		}
	end
end

function OmniBar:SetupOptions()

	for spellId, spell in pairs(OmniBar.db.global.cooldowns) do
		customSpells["spell"..spellId] = {
			name = GetSpellInfo(spellId),
			type = "group",
			childGroups = "tab",
			args = customSpellInfo,
			icon = GetSpellTexture(spellId),
		}
	end

	self.options = {
		name = "OmniBar",
		descStyle = "inline",
		type = "group",
		plugins = {
			profiles = { profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db) }
		},
		childGroups = "tab",
		args = {
			vers = {
				order = 1,
				type = "description",
				name = "|cffffd700"..L["Version"].."|r "..GetAddOnMetadata("OmniBar", "Version").."\n",
				cmdHidden = true
			},
			desc = {
				order = 2,
				type = "description",
				name = "|cffffd700 "..L["Author"].."|r Jordon |cffffd700 翻译修改|r NGA-伊甸外\n",
				cmdHidden = true
			},
			test = {
				type = "execute",
				name = L["Test"],
				desc = L["Activate the icons for testing"],
				order = 3,
				func = "Test",
				handler = OmniBar,
			},

			bars = {
				name = L["Bars"],
				type = "group",
				order = 10,
				childGroups = "tab",
				args = {
					add = {
						type = "execute",
						name = L["Create Bar"],
						desc = L["Create a new bar"],
						order = 1,
						func = "Create",
						handler = OmniBar,
					},
				},
			},

			customSpells = {
				name = L["Custom Spells"],
				type = "group",
				order = 20,
				args = customSpells,
				set = function(info, state)
					local option = info[#info]
					local spellId = info[#info-1]:gsub("spell", "")
					spellId = tonumber(spellId)
					OmniBar.db.global.cooldowns[spellId][option] = state
					self:AddCustomSpells()
				end,
				get = function(info)
					local option = info[#info]
					local spellId = info[#info-1]:gsub("spell", "")
					spellId = tonumber(spellId)
					if not spellId then return end
					return OmniBar.db.global.cooldowns[spellId][option]
				end,
			},

		},
	}

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		local LibDualSpec = LibStub('LibDualSpec-1.0')
		LibDualSpec:EnhanceDatabase(self.db, "OmniBarDB")
		LibDualSpec:EnhanceOptions(self.options.plugins.profiles.profiles, self.db)
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("OmniBar", self.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("OmniBar", "OmniBar")
end
