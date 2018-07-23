local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LSM		= LibStub('LibSharedMedia-3.0')

local blacklistCooldownToAdd	= false
local blacklistCooldownIsItem	= false
local blacklistCooldownToRemove	= false
local blacklistCooldownList		= {}

local function GetBlacklistedCooldowns()
	blacklistCooldownList = wipe(blacklistCooldownList)

	local name

	for spellID in pairs(Ellipsis.db.profile.cooldowns.blacklist.SPELL) do
		name = GetSpellInfo(spellID)
		name = name or ''
		blacklistCooldownList['SPELL_' .. spellID] = format('%s [|cffffd100%d|r] %s', L.CoolSpell, spellID, name)
	end

	for itemID in pairs(Ellipsis.db.profile.cooldowns.blacklist.ITEM) do
		name = GetItemInfo(itemID)
		name = name or ''
		blacklistCooldownList['ITEM_' .. itemID] = format('%s [|cffffd100%d|r] %s', L.CoolItem, itemID, name)
	end

	return blacklistCooldownList
end


local dropTooltips = {
	['FULL']		= L.AuraDropTooltip_FULL,
	['HELPER']		= L.AuraDropTooltip_HELPER,
	['OFF']			= L.AuraDropTooltip_OFF,
}

local cooldownOptions = {
	appearance = {
		name = L.Appearance,
		type = 'group',
		order = -2,
		args = {
			horizontal = {
				name = L.CoolHorizontal,
				desc = L.CoolHorizontalDesc,
				type = 'toggle',
				order = 1,
			},
			texture = {
				name = L.CoolTexture,
				desc = L.CoolTextureDesc,
				type = 'select',
				order = 2,
				values = LSM:HashTable('statusbar'),
				dialogControl = 'LSM30_Statusbar',
			},
			length = {
				name = L.CoolLength,
				desc = L.CoolLengthDesc,
				type = 'range',
				order = 3,
				min = 100,
				max = 500,
				step = 1,
				bigStep = 5,
			},
			thickness = {
				name = L.CoolThickness,
				desc = L.CoolThicknessDesc,
				type = 'range',
				order = 4,
				min = 12,
				max = 40,
				step = 1,
			},
			timeGroup = {
				name = L.CoolTimeHeader,
				type = 'group',
				inline = true,
				order = 5,
				args = {
					timeDisplayMax = {
						name = L.CoolTimeDisplayMax,
						desc = L.CoolTimeDisplayMaxDesc,
						type = 'range',
						order = 1,
						min = 60,
						max = 1800,
						step = 10,
						bigStep = 30,
					},
					timeDetailed = {
						name = L.CoolTimeDetailed,
						desc = L.CoolTimeDetailedDesc,
						type = 'toggle',
						order = 2,
					},
					timeFont = {
						name = L.CoolTimeFont,
						desc = L.CoolTimeFontDesc,
						type = 'select',
						order = 3,
						values = LSM:HashTable('font'),
						dialogControl = 'LSM30_Font',
					},
					timeFontSize = {
						name = L.CoolTimeFontSize,
						desc = L.CoolTimeFontDesc,
						type = 'range',
						order = 4,
						min = 4,
						max = 24,
						step = 1,
					},
				}
			},
			offsetGroup = {
				name = '',--L.CoolOffsetHeader,
				type = 'group',
				inline = true,
				order = 6,
				args = {
					offsetTags = {
						name = L.CoolOffsetTags,
						desc = L.CoolOffsetTagsDesc,
						type = 'toggle',
						order = 1,
					},
					offsetItem = {
						name = L.CoolOffsetItem,
						desc = L.CoolOffsetDesc,
						type = 'range',
						order = 2,
						min = -60,
						max = 60,
						step = 1,
						disabled = function()
							return not Ellipsis.db.profile.cooldowns.offsetTags
						end,
					},
					offsetPet = {
						name = L.CoolOffsetPet,
						desc = L.CoolOffsetDesc,
						type = 'range',
						order = 3,
						min = -60,
						max = 60,
						step = 1,
						disabled = function()
							return not Ellipsis.db.profile.cooldowns.offsetTags
						end,
					},
					offsetSpell = {
						name = L.CoolOffsetSpell,
						desc = L.CoolOffsetDesc,
						type = 'range',
						order = 4,
						min = -60,
						max = 60,
						step = 1,
						disabled = function()
							return not Ellipsis.db.profile.cooldowns.offsetTags
						end,
					},
				}
			},
		}
	},
	colours = {
		name = L.Colours,
		type = 'group',
		order = -1,
		args = {
			groupBase = {
				name = L.CoolColoursBase,
				type = 'group',
				inline = true,
				order = 1,
				args = {
					colourBar = {
						name = L.CoolColoursBar,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
					colourText = {
						name = L.CoolColoursText,
						type = 'color',
						order = 2,
						hasAlpha = true,
					},
					colourBackdrop = {
						name = L.CoolColoursBackdrop,
						desc = L.CoolColoursBackdropDesc,
						type = 'color',
						order = 3,
						hasAlpha = true,
					},
					colourBorder = {
						name = L.CoolColoursBorder,
						desc = L.CoolColoursBorderDesc,
						type = 'color',
						order = 4,
						hasAlpha = true,
					},

				}
			},
			groupGroups = {
				name = L.CoolColoursGroups,
				type = 'group',
				inline = true,
				order = 2,
				args = {
					colourItem = {
						name = L.CoolTrackItem,
						desc = L.CoolColoursGroupsDesc,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
					colourPet = {
						name = L.CoolTrackPet,
						desc = L.CoolColoursGroupsDesc,
						type = 'color',
						order = 2,
						hasAlpha = true,
					},
					colourSpell = {
						name = L.CoolTrackSpell,
						desc = L.CoolColoursGroupsDesc,
						type = 'color',
						order = 3,
						hasAlpha = true,
					},
				}
			}
		}
	},
	enabled = {
		name = L.Enabled,
		type = 'toggle',
		order = 1,
	},
	onlyWhenTracking = {
		name = L.CoolOnlyWhenTracking,
		desc = L.CoolOnlyWhenTrackingDesc,
		type = 'toggle',
		order = 2,
	},
	interactive = {
		name = L.CoolInteractive,
		desc = L.CoolInteractiveDesc,
		type = 'toggle',
		order = 3,
	},
	tooltips = {
		name = L.CoolTooltips,
		desc = L.CoolTooltipsDesc,
		type = 'select',
		order = 4,
		values = dropTooltips,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.cooldowns.interactive
		end,
	},
	groupControl = {
		name = L.CoolControlHeader,
		type = 'group',
		inline = true,
		order = 5,
		args = {
			trackingHeader = {
				name = L.CoolTrackingHeader,
				type = 'description',
				order = 1,
				width = 'half',
				fontSize = 'medium',
			},
			trackItem = {
				name = L.CoolTrackItem,
				desc = L.CoolTrackItemDesc,
				type = 'toggle',
				order = 2,
				width = 'half',
			},
			trackPet = {
				name = L.CoolTrackPet,
				desc = L.CoolTrackPetDesc,
				type = 'toggle',
				order = 3,
				width = 'half',
			},
			trackSpell = {
				name = L.CoolTrackSpell,
				desc = L.CoolTrackSpellDesc,
				type = 'toggle',
				order = 4,
				width = 'half',
			},
			timeMinLimit = {
				name = L.CoolTimeMinLimit,
				type = 'toggle',
				order = 5,
				disabled = true,
				get = function() return true end, -- is a fake, always set to enabled
			},
			timeMaxLimit = {
				name = L.CoolTimeMaxLimit,
				type = 'toggle',
				order = 6,
			},
			timeMinValue = {
				name = L.CoolTimeMinValue,
				desc = L.CoolTimeMinValueDesc,
				type = 'range',
				order = 7,
				min = 2,
				max = 60,
				step = 1,
			},
			timeMaxValue = {
				name = L.CoolTimeMaxValue,
				desc = L.CoolTimeMaxValueDesc,
				type = 'range',
				order = 8,
				min = 10,
				max = 300,
				step = 1,
				bigStep = 10,
				disabled = function()
					return not Ellipsis.db.profile.cooldowns.timeMaxLimit
				end
			},
			groupAdd = {
				name = '',
				type = 'group',
				inline = true,
				order = 9,
				args = {
					addInput = {
						name = L.CoolBlacklistAdd,
						desc = L.CoolBlacklistAddDesc,
						type = 'input',
						order = 1,
						multiline = false,
						get = function()
							if (blacklistCooldownToAdd) then
								return tostring(blacklistCooldownToAdd)
							else
								return ''
							end
						end,
						set = function(info, val)
							val = tonumber(val)

							if (val and val > 0) then
								blacklistCooldownToAdd = val
							end
						end
					},
					addIsItem = {
						name = L.CoolBlacklistAddItem,
						desc = L.CoolBlacklistAddItemDesc,
						type = 'toggle',
						order = 2,
						width = 'half',
						get = function()
							return blacklistCooldownIsItem
						end,
						set = function(info, val)
							blacklistCooldownIsItem = val
						end,
					},
					addExecute = {
						name = L.CoolBlacklistAddButton,
						type = 'execute',
						order = 3,
						width = 'half',
						func = function()
							Ellipsis:BlacklistCooldownAdd(blacklistCooldownIsItem and 'ITEM' or 'SPELL', blacklistCooldownToAdd)

							blacklistCooldownToAdd = false -- ID added, clear
						end,
						disabled = function() -- only enable if a valid ID is waiting to be added
							return not blacklistCooldownToAdd
						end
					},
				}
			},
			blacklistList = {
				name = L.CoolBlacklistList,
				desc = L.CoolBlacklistListDesc,
				type = 'select',
				order = 10,
				width = 'full',
				values = GetBlacklistedCooldowns,
				get = function()
					if (blacklistCooldownToRemove) then
						return blacklistCooldownToRemove
					else
						return nil
					end
				end,
				set = function(info, val)
					blacklistCooldownToRemove = val
				end
			},
			blacklistRemove = {
				name = L.CoolBlacklistRemoveButton,
				type = 'execute',
				order = 11,
				width = 'full',
				func = function()
					local group, timerID = strsplit('_', blacklistCooldownToRemove)

					timerID = tonumber(timerID) or nil

					Ellipsis:BlacklistCooldownRemove(group, timerID)

					blacklistCooldownToRemove = false -- ID removed, clear
				end,
				disabled = function () -- only allow removable once a valid ID has been chosen first
					return not blacklistCooldownToRemove
				end
			},
		}
	},
}

-- ------------------------
-- DATA TABLE RETURN
-- ------------------------
function Ellipsis:GetCooldownOptions()
	return cooldownOptions
end


-- ------------------------
-- GETTERS & SETTERS
-- ------------------------
function Ellipsis:CooldownsGet(info)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.cooldowns[info[#info]]

		return colours[1], colours[2], colours[3], colours[4]
	else
		return self.db.profile.cooldowns[info[#info]]
	end
end

function Ellipsis:CooldownsSet(info, val, val2, val3, val4)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.cooldowns[info[#info]]

		if (info.option.hasAlpha) then -- setting alpha value as well as rgb
			colours[1], colours[2], colours[3], colours[4] = val, val2, val3, val4
		else -- no alpha, just rgb
			colours[1], colours[2], colours[3] = val, val2, val3
		end
	else
		self.db.profile.cooldowns[info[#info]] = val
	end

	Ellipsis.Cooldown:Configure()
	Ellipsis.Cooldown:ApplyOptionsTimerRestrictions()
	Ellipsis.Cooldown:UpdateExistingTimers()
end
