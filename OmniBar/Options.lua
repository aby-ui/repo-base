
-- OmniBar by Jordon

local addonName, addon = ...

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local CLASS_SORT_ORDER = CLASS_SORT_ORDER
local CreateFrame = CreateFrame
local DELETE = DELETE
local GENERAL = GENERAL
local GetAddOnMetadata = GetAddOnMetadata
local GetSpecializationInfoByID = GetSpecializationInfoByID
local GetSpellInfo = GetSpellInfo
local GetSpellTexture = GetSpellTexture
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local LibStub = LibStub
local MAX_CLASSES = MAX_CLASSES
local NO = NO
local OmniBar_CreateIcon = OmniBar_CreateIcon
local OmniBar_IsSpellEnabled = OmniBar_IsSpellEnabled
local OmniBar_LoadPosition = OmniBar_LoadPosition
local OmniBar_OnEvent = OmniBar_OnEvent
local OmniBar_Position = OmniBar_Position
local OmniBar_SavePosition = OmniBar_SavePosition
local SecondsToTime = SecondsToTime
local Spell = Spell
local StaticPopupDialogs = StaticPopupDialogs
local StaticPopup_Show = StaticPopup_Show
local UIParent = UIParent
local WOW_PROJECT_CLASSIC = WOW_PROJECT_CLASSIC
local WOW_PROJECT_ID = WOW_PROJECT_ID
local WOW_PROJECT_MAINLINE = WOW_PROJECT_MAINLINE
local YES = YES
local format = format
local nop = nop

local OmniBar = LibStub("AceAddon-3.0"):GetAddon("OmniBar")
local L = LibStub("AceLocale-3.0"):GetLocale("OmniBar")

local MAX_ARENA_SIZE = addon.MAX_ARENA_SIZE or 0

local LOCALIZED_CLASS_NAMES_MALE_WITH_GENERAL = {}
for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	LOCALIZED_CLASS_NAMES_MALE_WITH_GENERAL[k] = v
end
LOCALIZED_CLASS_NAMES_MALE_WITH_GENERAL["GENERAL"] = GENERAL

local CLASS_SORT_ORDER_WITH_GENERAL = {}
for k,v in pairs(CLASS_SORT_ORDER) do
	CLASS_SORT_ORDER_WITH_GENERAL[k] = v
end
CLASS_SORT_ORDER_WITH_GENERAL[0] = "GENERAL"

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
	local spellID = tonumber(info[#info])
	local key = info[2]
	return OmniBar_IsSpellEnabled(_G[key], spellID)
end

StaticPopupDialogs["OMNIBAR_DELETE"] = {
	text = DELETE.." \"%s\"",
	button1 = YES,
	button2 = NO,
	OnAccept = function(self, data)
		OmniBar:Delete(data)
		OmniBar:OnEnable()
	end,
	timeout = 0,
	whileDead = true,
}


function OmniBar:ToggleLock(button)
	self.db.profile.bars[button.arg].locked = not self.db.profile.bars[button.arg].locked
	OmniBar_Position(_G[button.arg])
	self.options.args.bars.args[button.arg].args.lock.name = self.db.profile.bars[button.arg].locked and L["Unlock"] or L["Lock"]
end

local function GetBars(key)
	local bars = {}
	for k in pairs(OmniBar.db.profile.bars) do if k ~= key then bars[k] = OmniBar.db.profile.bars[k].name end end
	return bars
end

local function GetSpells()
	local spells = {
		uncheck = {
			name = L["Uncheck All"],
			type = "execute",
			func = function(info)
				local key = info[#info-2]
				local bar = _G[key]
				bar.settings.spells = {}
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
				bar.settings.spells = nil
				OmniBar:Refresh(true)
			end,
			order = 2,
		},
		checkAll = {
			name = "Check All Spells",
			type = "execute",
			func = function(info)
				local key = info[#info-2]
				local bar = _G[key]

				bar.settings.spells = {}
				for k,v in pairs(addon.Cooldowns) do
					if (not v.parent) then
						bar.settings.spells[k] = true
					end
				end

				OmniBar:Refresh(true)
			end,
			order = 3,
		},
	}
	local descriptions = {}
	for i = 0, MAX_CLASSES do

		spells[CLASS_SORT_ORDER_WITH_GENERAL[i]] = {
			name = LOCALIZED_CLASS_NAMES_MALE_WITH_GENERAL[CLASS_SORT_ORDER_WITH_GENERAL[i]],
			type = "group",
			args = {},
			hidden = function(info)
				local bar = info[#info-2]
				local class = info[#info]
				return next(info.options.args.bars.args[bar].args.spells.args[class].args) == nil
			end,
			icon = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
			iconCoords = CLASS_ICON_TCOORDS[CLASS_SORT_ORDER_WITH_GENERAL[i]]
		}

		if i == 0 then
			spells[CLASS_SORT_ORDER_WITH_GENERAL[i]]["icon"] = "Interface\\Icons\\Trade_Engineering"
			spells[CLASS_SORT_ORDER_WITH_GENERAL[i]]["iconCoords"] = nil
			spells[CLASS_SORT_ORDER_WITH_GENERAL[i]]["order"] = 0
		end

		for spellID, spell in pairs(addon.Cooldowns) do
			if spell.class and spell.class == CLASS_SORT_ORDER_WITH_GENERAL[i] then
				local spellName = GetSpellInfo(spellID)
				if spellName then
					local spellTexture = OmniBar:GetSpellTexture(spellID) or ""
					if string.len(spellName) > 25 then
						spellName = string.sub(spellName, 0, 22) .. "..."
					end
					local s = Spell:CreateFromSpellID(spellID)
					s:ContinueOnSpellLoad(function()
						descriptions[spellID] = s:GetSpellDescription()
					end)

					spells[CLASS_SORT_ORDER_WITH_GENERAL[i]].args[tostring(spellID)] = {
						type = "toggle",
						get = IsSpellEnabled,
						width = "full",
						hidden = nop,
						arg = spellID,
						desc = function()
							local duration = type(spell.duration) == "number" and spell.duration or spell.duration.default
							local spellDesc = descriptions[spellID] or ""
							local extra = "\n\n|cffffd700 "..L["Spell ID"].."|r "..spellID..
								"\n\n|cffffd700 "..L["Cooldown"].."|r "..SecondsToTime(duration)
							return spellDesc..extra
						end,
						name = function()
							return format("|T%s:20|t %s", spellTexture, spellName)
						end,
					}
				end
			end
		end
	end
	return spells
end

function OmniBar:AddBarToOptions(key, refresh)
	local trackUnits = {
		ENEMY = "All Enemies",
		GROUP = "Group Members",
		PLAYER = PLAYER,
		TARGET = TARGET,
		FOCUS = FOCUS,
		party1 = PARTY .. " 1",
		party2 = PARTY .. " 2",
		party3 = PARTY .. " 3",
		party4 = PARTY .. " 4",
	}

	local trackUnitsOrder = {
		"ENEMY",
		"PLAYER",
		"TARGET",
		"FOCUS",
		"GROUP",
		"party1",
		"party2",
		"party3",
		"party4",
	}

	for i = 1, MAX_ARENA_SIZE do
		local unit = "arena" .. i
		trackUnits[unit] = ARENA .. " " .. i
		tinsert(trackUnitsOrder, unit)
	end

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
					trackUnit = {
						name = "Track",
						type = "select",
						values = trackUnits,
						sorting = trackUnitsOrder,
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
						order = 2,
					},
					lb1 = {
						name = "",
						type = "description",
						order = 3,
					},
					center = {
						name = L["Center Lock"],
						desc = L["Keep the bar centered horizontally"],
						width = "normal",
						type = "toggle",
						order = 4,
					},
					showUnused = {
						name = L["Show Unused Icons"],
						desc = L["Icons will always remain visible"],
						width = "normal",
						type = "toggle",
						order = 5,
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
							return (not self.db.profile.bars[key].showUnused) or self.db.profile.bars[key].trackUnit ~= "ENEMY"
						end,
						width = "normal",
						type = "toggle",
						order = 6,
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
						order = 7,
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
						order = 8,
					},
					border = {
						name = L["Show Border"],
						desc = L["Draw a border around the icons"],
						width = "normal",
						type = "toggle",
						order = 9,
					},
					highlightTarget = {
						name = L["Highlight Target"],
						desc = L["Draw a border around your target"],
						width = "normal",
						type = "toggle",
						order = 10,
						disabled = function()
							return self.db.profile.bars[key].trackUnit ~= "ENEMY"
						end,
						set = function(info, state)
							local option = info[#info]
							self.db.profile.bars[key][option] = state
							self:Refresh(true)
						end,
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
						disabled = function()
							return self.db.profile.bars[key].trackUnit ~= "ENEMY"
						end,
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
					OmniBar_Position(_G[key])
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
					local spellID = tonumber(info[#info])

					-- set default spells explicitly
					if (not self.db.profile.bars[key].spells) then
						self.db.profile.bars[key].spells = {}
						for k,v in pairs(addon.Cooldowns) do
							if v.default then
								self.db.profile.bars[key].spells[k] = true
							end
						end
					end

					self.db.profile.bars[key].spells[spellID] = state
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
				width = 0.75,
				order = 1,
			},
			test = {
				type = "execute",
				name = L["Test"],
				desc = L["Activate the icons for testing"],
				order = 2,
				width = 0.75,
				func = function(info)
					local key = info[#info-1]
					local bar = _G[key]
					OmniBar_Test(bar)
				end,
			},
			delete = {
				type = "execute",
				name = L["Delete"],
				width = 0.75,
				desc = L["Delete the bar"],
				func = function()
					local popup = StaticPopup_Show("OMNIBAR_DELETE", self.db.profile.bars[key].name)
					if popup then popup.data = key end
				end,
				arg = key,
				order = 3,
			},
		},
	}

	self.options.args.bars.args[key].args.spells.args.copy = {
		name = "Copy From: ",
		desc = "Copies spells from the selected OmniBar",
		type = "select",
		width = "normal",
		values = GetBars(key),
		set = function(info, state)
			local key = info[#info-2]
			local dst = _G[key]
			local src = _G[state]

			if (not src.settings.spells) then
				dst.settings.spells = nil
				return
			end

			dst.settings.spells = {}
			for k,v in pairs(src.settings.spells) do
				dst.settings.spells[k] = v
			end

			OmniBar:Refresh(true)
		end,
		order = 3,
	}

	if WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC then
		self.options.args.bars.args[key].args.settings.args.highlightFocus = {
			name = L["Highlight Focus"],
			desc = L["Draw a border around your focus"],
			width = "normal",
			type = "toggle",
			order = 10,
			disabled = function()
				return self.db.profile.bars[key].trackUnit ~= "ENEMY"
			end,
			set = function(info, state)
				local option = info[#info]
				self.db.profile.bars[key][option] = state
				self:Refresh(true)
			end,
		}

		self.options.args.bars.args[key].args.visibility.args.arena = {
			name = L["Show in Arena"],
			desc = L["Show the icons in arena"],
			width = "double",
			type = "toggle",
			order = 11,
		}
	end

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
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
	261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 577,
	581, 1467, 1468
}

local customSpellInfo = {
	spellId = {
		order = 1,
		type = "description",
		name = function(info)
			local spellId = info[#info-1]
			return "|cffffd700 ".."Spell ID".."|r ".. spellId .."\n"
		end,
	},
	delete = {
		type = "execute",
		name = L["Delete"],
		desc = L["Delete the cooldown"],
		func = function(info)
			local spellId = info[#info-1]
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId] = nil
			addon.Cooldowns[spellId] = nil
			OmniBar:AddCustomSpells()
			info.options.args.customSpells.args[info[#info-1]] = nil
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
		softMax = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC and 1200 or 600,
		step = 1,
		order = 4,
		set = function(info, state)
			local spellId = info[#info-1]
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId].duration.default = state
			OmniBar:AddCustomSpells()
		end,
		get = function(info)
			local spellId = info[#info-1]
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
			local spellId = info[#info-1]
			spellId = tonumber(spellId)
			if state == 1 then state = nil end
			OmniBar.db.global.cooldowns[spellId][option] = state
			OmniBar:AddCustomSpells()
		end,
		get = function(info)
			local option = info[#info]
			local spellId = info[#info-1]
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
		values = LOCALIZED_CLASS_NAMES_MALE_WITH_GENERAL,
		order = 5,
		set = function(info, state)
			local option = info[#info]
			local spellId = info[#info-1]
			spellId = tonumber(spellId)
			OmniBar.db.global.cooldowns[spellId].specID = nil
			OmniBar.db.global.cooldowns[spellId].duration = { default = OmniBar.db.global.cooldowns[spellId].duration.default }
			OmniBar.db.global.cooldowns[spellId][option] = state
			OmniBar:OnEnable() -- to refresh the bar spells tab
			OmniBar:AddCustomSpells()
		end,
	},
	icon = {
		name = "Icon",
		desc = "Set the icon of the cooldown",
		type = "input",
		get = function(info)
			local spellId = info[#info-1]
			return tostring(OmniBar:GetSpellTexture(spellId))
		end,
		set = function(info, state)
			local option = info[#info]
			local spellId = info[#info-1]
			OmniBar.db.global.cooldowns[tonumber(spellId)][option] = tonumber(state)
			OmniBar:OnEnable() -- to refresh the bar spells tab
			OmniBar:AddCustomSpells()
		end,
	},
}

local customSpells = {
	spellId = {
		name = L["Spell ID"],
		type = "input",
		set = function(info, state, data)
			local spellId = tonumber(state)
			local name = GetSpellInfo(spellId)
			if OmniBar.db.global.cooldowns[spellId] then return end
			if spellId and name then
				OmniBar.db.global.cooldowns[spellId] = data or addon.Cooldowns[spellId] or { custom = true, duration = { default = 30 } , class = "GENERAL" }

				local duration
				-- If it's a child convert it
				if OmniBar.db.global.cooldowns[spellId].parent then
					-- If the child has a custom duration, save it so we can restore it after we copy from parent
					if OmniBar.db.global.cooldowns[spellId].duration then
						duration = OmniBar.db.global.cooldowns[spellId].duration
					end

					OmniBar.db.global.cooldowns[spellId] = OmniBar:CopyCooldown(addon.Cooldowns[OmniBar.db.global.cooldowns[spellId].parent])

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

				OmniBar.options.args.customSpells.args[tostring(spellId)] = {
					name = name,
					type = "group",
					childGroups = "tab",
					args = customSpellInfo,
					icon = OmniBar:GetSpellTexture(spellId),
				}
				OmniBar:OnEnable() -- to refresh the bar spells tab
				LibStub("AceConfigRegistry-3.0"):NotifyChange("OmniBar")
			end
		end,
	},
}

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	for i = 1, #specIDs do
		local specID = specIDs[i]
		local _, name, _, icon = GetSpecializationInfoByID(specID)
		customSpellInfo["spec"..specID] = {
			name = format("|T%s:20|t %s", icon, name),
			hidden = function(info)
				local spellId = info[#info-1]
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
						local spellId = info[#info-2]
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
						local spellId = info[#info-2]
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
					softMax = 600,
					step = 1,
					order = 2,
					set = function(info, state)
						local option = info[#info]
						local spellId = info[#info-2]
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
						local spellId = info[#info-2]
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
		customSpells[tostring(spellId)] = {
			name = GetSpellInfo(spellId),
			type = "group",
			childGroups = "tab",
			args = customSpellInfo,
			icon = function() return OmniBar:GetSpellTexture(spellId) end,
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
				name = "|cffffd700"..L["Version"].."|r "..self.version.string.."\n",
				cmdHidden = true
			},
			desc = {
				order = 2,
				type = "description",
				name = "|cffffd700 "..L["Author"].."|r Jordon\n",
				cmdHidden = true
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
						width = 0.7,
					},
					test = {
						type = "execute",
						name = L["Test All"],
						desc = L["Activate the icons for testing"],
						order = 2,
						func = "Test",
						handler = OmniBar,
						width = 0.7,
					},
					import = {
						type = "execute",
						name = L["Import"],
						desc = L["Import an OmniBar profile"],
						order = 3,
						func = "ShowImport",
						handler = OmniBar,
						width = 0.7,
					},
					export = {
						type = "execute",
						name = L["Export"],
						desc = L["Export this profile"],
						order = 4,
						func = "ShowExport",
						handler = OmniBar,
						width = 0.7,
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
					local spellId = info[#info-1]
					spellId = tonumber(spellId)
					OmniBar.db.global.cooldowns[spellId][option] = state
					self:AddCustomSpells()
				end,
				get = function(info)
					local option = info[#info]
					local spellId = info[#info-1]
					spellId = tonumber(spellId)
					if not spellId then return end
					return OmniBar.db.global.cooldowns[spellId][option]
				end,
			},
		},
	}

	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		local LibDualSpec = LibStub('LibDualSpec-1.0')
		LibDualSpec:EnhanceDatabase(self.db, "OmniBarDB")
		LibDualSpec:EnhanceOptions(self.options.plugins.profiles.profiles, self.db)
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable("OmniBar", self.options)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("OmniBar", "OmniBar")
end

local AceGUI = LibStub("AceGUI-3.0")

-- Export
local export = AceGUI:Create("Frame")
export:SetWidth(550)
export:EnableResize(false)
export:SetStatusText("")
export:SetLayout("Flow")
export:SetTitle(L["Export"])
export:SetStatusText(L["Copy this code to share this OmniBar profile."])
export:Hide()
local exportEditBox = AceGUI:Create("MultiLineEditBox")
exportEditBox:SetLabel("")
exportEditBox:SetNumLines(29)
exportEditBox:SetText("")
exportEditBox:SetFullWidth(true)
exportEditBox:SetWidth(500)
exportEditBox.button:Hide()
exportEditBox.frame:SetClipsChildren(true)
export:AddChild(exportEditBox)
export.editBox = exportEditBox
OmniBar.export = export

-- Import
local import = AceGUI:Create("Frame")
import:SetWidth(550)
import:EnableResize(false)
import:SetStatusText("")
import:SetLayout("Flow")
import:SetTitle(L["Import"])
import:Hide()
local importEditBox = AceGUI:Create("MultiLineEditBox")
importEditBox:SetLabel("")
importEditBox:SetNumLines(25)
importEditBox:SetText("")
importEditBox:SetFullWidth(true)
importEditBox:SetWidth(500)
importEditBox.button:Hide()
importEditBox.frame:SetClipsChildren(true)
import:AddChild(importEditBox)
import.editBox = importEditBox
local importButton = AceGUI:Create("Button")
importButton:SetWidth(100)
importButton:SetText(L["Import"])
importButton:SetCallback("OnClick", function()
    local data = import.data
    if (not data) then return end
    if OmniBar:ImportProfile(data) then import:Hide() end
end)
import:AddChild(importButton)
import.button = importButton
importEditBox:SetCallback("OnTextChanged", function(widget)
    local data = OmniBar:Decode(widget:GetText())
    if (not data) then return end
    import.statustext:SetTextColor(0,1,0)
    import:SetStatusText(L["Ready to import"])
    importButton:SetDisabled(false)
    import.data = data
end)
OmniBar.import = import
