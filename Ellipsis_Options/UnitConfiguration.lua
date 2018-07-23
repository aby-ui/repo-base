local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LSM		= LibStub('LibSharedMedia-3.0')

local dropFontStyle = {
	['OUTLINE']			= L.UnitDropFontStyle_OUTLINE,
	['THICKOUTLINE']	= L.UnitDropFontStyle_THICKOUTLINE,
	['NONE']			= L.UnitDropFontStyle_NONE,
}

local dropHeaderColourBy = {
	['CLASS']			= L.UnitDropColourBy_CLASS,
	['REACTION']		= L.UnitDropColourBy_REACTION,
	['NONE']			= L.UnitDropColourBy_NONE,
}

local unitConfiguration = {
	colours = {
		name = L.Colours,
		type = 'group',
		order = -1,
		args = {
			groupBase = {
				name = L.UnitColoursBaseHeader,
				type = 'group',
				inline = true,
				order = 1,
				args = {
					colourHeader = {
						name = L.UnitColoursColourHeader,
						desc = L.UnitColoursColourHeaderDesc,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
				}
			},
			groupReaction = {
				name = L.UnitColoursReactionHeader,
				type = 'group',
				inline = true,
				order = 2,
				args = {
					colourFriendly = {
						name = L.UnitColoursColourFriendly,
						type = 'color',
						order = 1,
						hasAlpha = true,
					},
					colourHostile = {
						name = L.UnitColoursColourHostile,
						type = 'color',
						order = 2,
						hasAlpha = true,
					},
				}
			},
		}
	},
	width = {
		name = L.UnitWidth,
		desc = L.UnitWidthDesc,
		type = 'range',
		order = 1,
		min = 40,
		max = 400,
		step = 1,
		bigStep = 5,
		set = function(info, val) -- configuration alters Auras, Units and Anchors
			Ellipsis:AurasSet(info, val)
			Ellipsis:UnitsSet(info, val)

			for _, anchor in pairs(Ellipsis.anchors) do
				anchor:SetWidth(val) -- all anchors are set to the unit width
			end
		end
	},
	headerHeight = {
		name = L.UnitHeaderHeight,
		desc = L.UnitHeaderHeightDesc,
		type = 'range',
		order = 2,
		min = 10,
		max = 50,
		step = 1,
	},
	opacityFaded = {
		name = L.UnitOpacityFaded,
		desc = L.UnitOpacityFadedDesc,
		type = 'range',
		order = 3,
		min = 0,
		max = 1,
		step = 0.05,
	},
	opacityNoTarget = {
		name = L.UnitOpacityNoTarget,
		desc = L.UnitOpacityNoTargetDesc,
		type = 'range',
		order = 4,
		min = 0,
		max = 1,
		step = 0.05,
	},
	groupHeaderText = {
		name = L.UnitHeaderTextHeader,
		type = 'group',
		inline = true,
		order = 5,
		args = {
			headerFont = {
				name = L.UnitHeaderTextFont,
				desc = L.UnitHeaderTextDesc,
				type = 'select',
				order = 1,
				values = LSM:HashTable('font'),
				dialogControl = 'LSM30_Font',
			},
			headerFontSize = {
				name = L.UnitHeaderTextFontSize,
				desc = L.UnitHeaderTextDesc,
				type = 'range',
				order = 2,
				min = 4,
				max = 24,
				step = 1,
			},
			headerFontStyle = {
				name = L.UnitHeaderTextFontStyle,
				desc = L.UnitHeaderTextDesc,
				type = 'select',
				order = 3,
				values = dropFontStyle
			},
			headerColourBy = {
				name = L.UnitHeaderColourBy,
				desc = L.UnitHeaderColourByDesc,
				type = 'select',
				order = 4,
				values = dropHeaderColourBy,
			},
			headerShowLevel = {
				name = L.UnitHeaderShowLevel,
				desc = L.UnitHeaderShowLevelDesc,
				type = 'toggle',
				order = 5,
			},
			stripServer = {
				name = L.UnitStripServer,
				desc = L.UnitStripServerDesc,
				type = 'toggle',
				order = 6,
			},
		}
	},
	groupCollapse = {
		name = L.UnitCollapseHeader,
		type = 'group',
		inline = true,
		order = 6,
		args = {
			collapseAllUnits = {
				name = L.UnitCollapseAllUnits,
				desc = L.UnitCollapseAllUnitsDesc,
				type = 'toggle',
				order = 1,
				width = 'full',
			},
			collapsePlayer = {
				name = L.UnitCollapsePlayer,
				desc = L.UnitCollapsePlayerDesc,
				type = 'toggle',
				order = 2,
				disabled = function()
					return Ellipsis.db.profile.units.collapseAllUnits
				end,
			},
			collapseNoTarget = {
				name = L.UnitCollapseNoTarget,
				desc = L.UnitCollapseNoTargetDesc,
				type = 'toggle',
				order = 3,
				disabled = function()
					return Ellipsis.db.profile.units.collapseAllUnits
				end,
			},
		}
	},
}


-- ------------------------
-- DATA TABLE RETURN
-- ------------------------
function Ellipsis:GetUnitConfiguration()
	return unitConfiguration
end


-- ------------------------
-- GETTERS & SETTERS
-- ------------------------
function Ellipsis:UnitsGet(info)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.units[info[#info]]
		return colours[1], colours[2], colours[3], colours[4]
	else
		return self.db.profile.units[info[#info]]
	end
end

function Ellipsis:UnitsSet(info, val, val2, val3, val4)
	if (info.type == 'color') then -- special case for colour options
		local colours = self.db.profile.units[info[#info]]
		colours[1], colours[2], colours[3], colours[4] = val, val2, val3, val4
	else
		self.db.profile.units[info[#info]] = val
	end

	self:ConfigureUnits() -- configure localized unitObject settings

	self:UpdateExistingUnits() -- apply changes to all existing Units

	if (info[#info] == 'opacityFaded') then -- special case for setting opacity of units
		self:ConfigureControl()
	end
end
