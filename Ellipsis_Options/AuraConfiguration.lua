local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LSM		= LibStub('LibSharedMedia-3.0')

local dropTooltips = {
	['FULL']		= L.AuraDropTooltip_FULL,
	['HELPER']		= L.AuraDropTooltip_HELPER,
	['OFF']			= L.AuraDropTooltip_OFF,
}
local dropStyle = {
	['BAR']			= L.AuraDropStyle_BAR,
	['ICON']		= L.AuraDropStyle_ICON,
}
local dropTextFormat = {
	['AURA']		= L.AuraDropTextFormat_AURA,
	['UNIT']		= L.AuraDropTextFormat_UNIT,
	['BOTH']		= L.AuraDropTextFormat_BOTH,
}
local dropTimeFormat = {
	['ABRV']		= L.AuraDropTimeFormat_ABRV,
	['TRUN']		= L.AuraDropTimeFormat_TRUN,
	['FULL']		= L.AuraDropTimeFormat_FULL,
}

local auraConfiguration = {
	colours = {
		name = L.Colours,
		type = 'group',
		order = -1,
		args = {
			groupText = {
				name = L.AuraColoursTextHeader,
				type = 'group',
				inline = true,
				order = 1,
				args = {
					colourText = {
						name = L.AuraColoursText,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
					colourStacks = {
						name = L.AuraColoursStacks,
						type = 'color',
						order = 2,
						hasAlpha = true,
					},
				}
			},
			groupWidget = {
				name = L.AuraColoursWidgetHeader,
				type = 'group',
				inline = true,
				order = 2,
				args = {
					colourGhosting = {
						name = L.AuraColoursWidgetGhosting,
						desc = L.AuraColoursWidgetGhostingDesc,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
					colourBarBackground = {
						name = L.AuraColoursWidgetBarBG,
						desc = L.AuraColoursWidgetBarBGDesc,
						type = 'color',
						order = 2,
						hasAlpha = true,
						disabled = function()
							return Ellipsis.db.profile.auras.style ~= 'BAR'
						end,
					},
					colourHigh = {
						name = L.AuraColoursWidgetHigh,
						desc = L.AuraColoursWidgetHighDesc,
						type = 'color',
						order = 3,
						hasAlpha = false,
					},
					colourMed = {
						name = L.AuraColoursWidgetMed,
						desc = L.AuraColoursWidgetMedDesc,
						type = 'color',
						order = 4,
						hasAlpha = false,
					},
					colourLow = {
						name = L.AuraColoursWidgetLow,
						desc = L.AuraColoursWidgetLowDesc,
						type = 'color',
						order = 5,
						hasAlpha = false,
					},
				}
			},
		}
	},
	style = {
		name = L.AuraStyle,
		desc = L.AuraStyleDesc,
		type = 'select',
		order = 1,
		width = 'half',
		values = dropStyle,
		set = function(info, val) -- configuration alters both Auras and Units
			Ellipsis:AurasSet(info, val)
			Ellipsis:UnitsSet(info, val)
		end,
	},
	spacer1 = {
		name = '',
		type = 'description',
		order = 2,
		width = 'half',
	},
	interactive = {
		name = L.AuraInteractive,
		desc = L.AuraInteractiveDesc,
		type = 'toggle',
		order = 3,
		width = 'half',
	},
	tooltips = {
		name = L.AuraTooltips,
		desc = L.AuraTooltipsDesc,
		type = 'select',
		order = 4,
		values = dropTooltips,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.auras.interactive
		end,
	},
	barSize = {
		name = L.AuraBarSize,
		desc = L.AuraBarSizeDesc,
		type = 'range',
		order = 5,
		min = 8,
		max = 40,
		step = 1,
		set = function(info, val) -- configuration alters both Auras and Units
			Ellipsis:AurasSet(info, val)
			Ellipsis:UnitsSet(info, val)
		end,
		hidden = function()
			return Ellipsis.db.profile.auras.style ~= 'BAR'
		end,
	},
	iconSize = {
		name = L.AuraIconSize,
		desc = L.AuraIconSizeDesc,
		type = 'range',
		order = 5,
		min = 8,
		max = 64,
		step = 1,
		set = function(info, val) -- configuration alters both Auras and Units
			Ellipsis:AurasSet(info, val)
			Ellipsis:UnitsSet(info, val)
		end,
		hidden = function()
			return Ellipsis.db.profile.auras.style ~= 'ICON'
		end,
	},
	timeFormat = {
		name = L.AuraTimeFormat,
		desc = L.AuraTimeFormatDesc,
		type = 'select',
		order = 6,
		values = dropTimeFormat,
	},
	barTexture = {
		name = L.AuraBarTexture,
		desc = L.AuraBarTextureDesc,
		type = 'select',
		order = 7,
		values = LSM:HashTable('statusbar'),
		dialogControl = 'LSM30_Statusbar',
		disabled = function()
			return Ellipsis.db.profile.auras.style ~= 'BAR'
		end,
	},
	textFormat = {
		name = L.AuraTextFormat,
		desc = L.AuraTextFormatDesc,
		type = 'select',
		order = 8,
		width = 'half',
		values = dropTextFormat,
		disabled = function()
			return Ellipsis.db.profile.auras.style ~= 'BAR'
		end,
	},
	flipIcon = {
		name = L.AuraFlipIcon,
		desc = L.AuraFlipIconDesc,
		type = 'toggle',
		order = 9,
		width = 'half',
		disabled = function()
			return Ellipsis.db.profile.auras.style ~= 'BAR'
		end,
	},
	groupGhosting = {
		name = L.AuraGhostingHeader,
		type = 'group',
		inline = true,
		order = 10,
		args = {
			ghosting = {
				name = L.Enabled,
				desc = L.AuraGhostingDesc,
				type = 'toggle',
				order = 1,
			},
			ghostDuration = {
				name = L.AuraGhostDuration,
				desc = L.AuraGhostDurationDesc,
				type = 'range',
				order = 2,
				min = 2,
				max = 20,
				step = 1,
				disabled = function()
					return not Ellipsis.db.profile.auras.ghosting
				end,
			},
		}
	},
	groupText = {
		name = '',
		type = 'group',
		inline = true,
		order = 11,
		args = {
			textFont = {
				name = L.AuraTextFont,
				desc = L.AuraTextDesc,
				type = 'select',
				order = 1,
				values = LSM:HashTable('font'),
				dialogControl = 'LSM30_Font',
			},
			textFontSize = {
				name = L.AuraTextFontSize,
				desc = L.AuraTextDesc,
				type = 'range',
				order = 2,
				min = 4,
				max = 24,
				step = 1,
			},
			stacksFont = {
				name = L.AuraStacksFont,
				desc = L.AuraStacksDesc,
				type = 'select',
				order = 3,
				values = LSM:HashTable('font'),
				dialogControl = 'LSM30_Font',
			},
			stacksFontSize = {
				name = L.AuraStacksFontSize,
				desc = L.AuraStacksDesc,
				type = 'range',
				order = 4,
				min = 4,
				max = 24,
				step = 1,
			},
		}
	},
}


-- ------------------------
-- DATA TABLE RETURN
-- ------------------------
function Ellipsis:GetAuraConfiguration()
	return auraConfiguration
end


-- ------------------------
-- GETTERS & SETTERS
-- ------------------------
function Ellipsis:AurasGet(info)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.auras[info[#info]]

		return colours[1], colours[2], colours[3], colours[4]
	else
		return self.db.profile.auras[info[#info]]
	end
end

function Ellipsis:AurasSet(info, val, val2, val3, val4)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.auras[info[#info]]

		if (info.option.hasAlpha) then -- setting alpha value as well as rgb
			colours[1], colours[2], colours[3], colours[4] = val, val2, val3, val4
		else -- no alpha, just rgb
			colours[1], colours[2], colours[3] = val, val2, val3
		end
	else
		self.db.profile.auras[info[#info]] = val
	end

	self:ConfigureAuras()		-- configure localized auraObject settings

	self:UpdateExistingAuras()	-- apply changes to all existing Auras
end
