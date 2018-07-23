local Ellipsis = _G['Ellipsis']
local L			= LibStub('AceLocale-3.0'):GetLocale('Ellipsis_Options')
local LUG		= LibStub('AceLocale-3.0'):GetLocale('Ellipsis') -- used to get UnitGroup locales
local LSM		= LibStub('LibSharedMedia-3.0')

local filterAuraToAdd		= false
local filterAuraToRemove	= false
local filterAuraList		= {}

local function GetFilteredAuras()
	filterAuraList = wipe(filterAuraList)

	local name
	local ctrl = Ellipsis.db.profile.control
	local filterList = ctrl.filterByBlacklist and ctrl.blacklist or ctrl.whitelist

	for spellID in pairs(filterList) do
		name = GetSpellInfo(spellID)
		name = name or LUG.Aura_Unknown
		filterAuraList[spellID] = format('[|cffffd100%d|r] %s', spellID, name)
	end

	return filterAuraList
end

--[[

local blacklistAuraToAdd	= false
local blacklistAuraToRemove	= false
local blacklistAuraList		= {}

local function GetBlacklistedAuras()
	blacklistAuraList = wipe(blacklistAuraList)

	local name

	for spellID in pairs(Ellipsis.db.profile.control.blacklist) do
		name = GetSpellInfo(spellID)
		name = name or ''
		blacklistAuraList[spellID] = format('[|cffffd100%d|r] %s', spellID, name)
	end

	return blacklistAuraList
end
]]


local dropUnitGroupAnchor = {			-- used for unitGroups that CANNOT be blocked from display
	[1]	= L.Control2Drop_1,
	[2]	= L.Control2Drop_2,
	[3]	= L.Control2Drop_3,
	[4]	= L.Control2Drop_4,
	[5]	= L.Control2Drop_5,
	[6]	= L.Control2Drop_6,
	[7]	= L.Control2Drop_7,
}

local dropUnitGroupAnchorCanHide = {	-- used for unitGroups that CAN be blocked from display
	[0]	= L.Control2Drop_0,
	[1]	= L.Control2Drop_1,
	[2]	= L.Control2Drop_2,
	[3]	= L.Control2Drop_3,
	[4]	= L.Control2Drop_4,
	[5]	= L.Control2Drop_5,
	[6]	= L.Control2Drop_6,
	[7]	= L.Control2Drop_7,
}

local dropUnitGroupPriority = {		-- used for unitGroups with configurable priority (excludes target|focus)
	[3]	= L.Control2Drop_3,
	[4]	= L.Control2Drop_4,
	[5]	= L.Control2Drop_5,
	[6]	= L.Control2Drop_6,
	[7]	= L.Control2Drop_7,
}

local dropAuraGrowthBar = {
	['DOWN']		= L.Control3DropGrow_DOWN,
	['UP']			= L.Control3DropGrow_UP,
}

local dropAuraGrowthIcon = {
	['CENTER']		= L.Control3DropGrow_CENTER,
	['LEFT']		= L.Control3DropGrow_LEFT,
	['RIGHT']		= L.Control3DropGrow_RIGHT,
}

local dropAuraSorting = {
	['CREATE_ASC']	= L.Control3DropSort_CREATE_ASC,
	['CREATE_DESC']	= L.Control3DropSort_CREATE_DESC,
	['EXPIRY_ASC']	= L.Control3DropSort_EXPIRY_ASC,
	['EXPIRY_DESC']	= L.Control3DropSort_EXPIRY_DESC,
	['NAME_ASC']	= L.Control3DropSort_NAME_ASC,
	['NAME_DESC']	= L.Control3DropSort_NAME_DESC,
}

local dropUnitGrowth = {
	['DOWN']		= L.Control3DropGrow_DOWN,
	['UP']			= L.Control3DropGrow_UP,
	['LEFT']		= L.Control3DropGrow_LEFT,
	['RIGHT']		= L.Control3DropGrow_RIGHT,
}

local dropUnitSorting = {
	['CREATE_ASC']	= L.Control3DropSort_CREATE_ASC,
	['CREATE_DESC']	= L.Control3DropSort_CREATE_DESC,
	['NAME_ASC']	= L.Control3DropSort_NAME_ASC,
	['NAME_DESC']	= L.Control3DropSort_NAME_DESC,
}


-- ------------------------
-- CONTROL 1 OPTIONS (Aura Restrictions)
-- ------------------------
local control1Options = {
	groupTime = {
		name = L.Control1TimeHeader,
		type = 'group',
		inline = true,
		order = 1,
		set = function(info, val)
			Ellipsis:ControlSet(info, val)
			Ellipsis:ApplyOptionsAuraRestrictions()
		end,
		args = {
			timeMinLimit = {
				name = L.Control1TimeMinLimit,
				type = 'toggle',
				order = 1,
			},
			timeMaxLimit = {
				name = L.Control1TimeMaxLimit,
				type = 'toggle',
				order = 2,
			},
			timeMinValue = {
				name = L.Control1TimeMinValue,
				desc = L.Control1TimeMinValueDesc,
				type = 'range',
				order = 3,
				min = 2,
				max = 60,
				step = 1,
				disabled = function()
					return not Ellipsis.db.profile.control.timeMinLimit
				end
			},
			timeMaxValue = {
				name = L.Control1TimeMaxValue,
				desc = L.Control1TimeMaxValueDesc,
				type = 'range',
				order = 4,
				min = 10,
				max = 300,
				step = 1,
				bigStep = 10,
				disabled = function()
					return not Ellipsis.db.profile.control.timeMaxLimit
				end
			},
			timeHelp = {
				name = L.Control1TimeHelp,
				type = 'description',
				order = 5,
			},
			showPassiveAuras = {
				name = L.Control1ShowPassiveAuras,
				type = 'toggle',
				order = 6,
				width = 'full',
			},
		}
	},
	groupFilterList = {
		name = L.Control1FilterHeader,
		type = 'group',
		inline = true,
		order = 2,
		args = {
			groupFilterSelect = {
				name = '',
				type = 'group',
				inline = true,
				order = 1,
				args = {
					restrictBy = {
						name = L.Control1FilterUsing,
						type = 'description',
						order = 1,
						width = 'normal',
						fontSize = 'medium',
					},
					blacklist = {
						name = L.Control1FilterBlacklist,
						desc = L.Control1FilterBlacklistDesc,
						type = 'toggle',
						order = 2,
						width = 'half',
						get = function()
							return Ellipsis.db.profile.control.filterByBlacklist
						end,
						set = function(info, val)
							if (not Ellipsis.db.profile.control.filterByBlacklist) then -- not already filtering by blacklist
								Ellipsis.db.profile.control.filterByBlacklist = true

 								-- clean out local store so as not to cross-contaminate lists
								filterAuraToAdd		= false
								filterAuraToRemove	= false

								Ellipsis:ConfigureControl()
								Ellipsis:ApplyOptionsAuraRestrictions()
								Ellipsis:UNIT_AURA('player')
							end
						end,
					},
					whitelist = {
						name = L.Control1FilterWhitelist,
						desc = L.Control1FilterWhitelistDesc,
						type = 'toggle',
						order = 3,
						width = 'half',
						get = function()
							return not Ellipsis.db.profile.control.filterByBlacklist
						end,
						set = function(info, val)
							if (Ellipsis.db.profile.control.filterByBlacklist) then -- already filtering by whitelist
								Ellipsis.db.profile.control.filterByBlacklist = false

 								-- clean out local store so as not to cross-contaminate lists
								filterAuraToAdd		= false
								filterAuraToRemove	= false

								Ellipsis:ConfigureControl()
								Ellipsis:ApplyOptionsAuraRestrictions()
								Ellipsis:UNIT_AURA('player')
							end
						end,
					},
				},
			},
			groupFilterAdd = {
				name = '',
				type = 'group',
				inline = true,
				order = 2,
				args = {
					addInput = {
						name = function()
							return Ellipsis.db.profile.control.filterByBlacklist and L.Control1FilterAddBlack or L.Control1FilterAddWhite
						end,
						desc = L.Control1FilterAddDesc,
						type = 'input',
						order = 1,
						multiline = false,
						get = function()
							if (filterAuraToAdd) then
								return tostring(filterAuraToAdd)
							else
								return ''
							end
						end,
						set = function(info, val)
							val = tonumber(val)

							if (val and val > 0) then
								filterAuraToAdd = val
							end
						end
					},
					addExecute = {
						name = L.Control1FilterAddBtn,
						type = 'execute',
						order = 2,
						func = function()
							Ellipsis:FilterAura(filterAuraToAdd)

							filterAuraToAdd = false -- spellID added, clear
						end,
						disabled = function() -- only enable if a valid spellID is waiting to be added
							return not filterAuraToAdd
						end
					},
				}
			},
			filterList = {
				name = function()
					return Ellipsis.db.profile.control.filterByBlacklist and L.Control1FilterListBlack or L.Control1FilterListWhite
				end,
				desc = L.Control1FilterListDesc,
				type = 'select',
				order = 3,
				width = 'full',
				values = GetFilteredAuras,
				get = function()
					if (filterAuraToRemove) then
						return filterAuraToRemove
					else
						return nil
					end
				end,
				set = function(info, val)
					val = tonumber(val)

					if (val and val > 0) then
						filterAuraToRemove = val
					end
				end
			},
			filterListRemove = {
				name = L.Control1FilterListRemoveBtn,
				type = 'execute',
				order = 4,
				width = 'full',
				func = function()
					Ellipsis:FilterAura(filterAuraToRemove)

					filterAuraToRemove = false -- spellID removed, clear
				end,
				disabled = function () -- only allow removable once a valid spellID has been chosen first
					return not filterAuraToRemove
				end
			}
		}
	},
}


-- ------------------------
-- CONTROL 2 OPTIONS (Grouping & Tracking)
-- ------------------------
local control2Options = {
	helpBase = {
		name = L.Control2HelpBase,
		type = 'description',
		order = 0,
	},
	ugPlayer = {
		name = LUG.UnitGroup_player,
		type = 'description',
		order = 1,
		fontSize = 'large',
		width = 'normal',
	},
	player_anchor = {
		name = L.Control2Display,
		desc = format('%s\n\n%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayCanHide, L.Control2DisplayPlayer),
		type = 'select',
		order = 2,
		values = dropUnitGroupAnchorCanHide,
		width = 'half',
	},
	player_priority = {
		name = L.Control2Priority,
		desc = function()
			return Ellipsis.db.profile.control.unitPrioritize and L.Control2PriorityDesc or L.Control2PriorityDisabled
		end,		type = 'select',
		order = 3,
		values = dropUnitGroupPriority,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.control.unitPrioritize
		end,
	},
	ugPet = {
		name = LUG.UnitGroup_pet,
		type = 'description',
		order = 4,
		fontSize = 'large',
		width = 'normal',
	},
	pet_anchor = {
		name = L.Control2Display,
		desc = format('%s\n\n%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayCanHide, L.Control2DisplayPet),
		type = 'select',
		order = 5,
		values = dropUnitGroupAnchorCanHide,
		width = 'half',
	},
	pet_priority = {
		name = L.Control2Priority,
		desc = function()
			return Ellipsis.db.profile.control.unitPrioritize and L.Control2PriorityDesc or L.Control2PriorityDisabled
		end,		type = 'select',
		order = 6,
		values = dropUnitGroupPriority,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.control.unitPrioritize
		end,
	},
	ugHarmful = {
		name = LUG.UnitGroup_harmful,
		type = 'description',
		order = 7,
		fontSize = 'large',
		width = 'normal',
	},
	harmful_anchor = {
		name = L.Control2Display,
		desc = format('%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayHarmful),
		type = 'select',
		order = 8,
		values = dropUnitGroupAnchor,
		width = 'half',
	},
	harmful_priority = {
		name = L.Control2Priority,
		desc = function()
			return Ellipsis.db.profile.control.unitPrioritize and L.Control2PriorityDesc or L.Control2PriorityDisabled
		end,		type = 'select',
		order = 9,
		values = dropUnitGroupPriority,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.control.unitPrioritize
		end,
	},
	ugHelpful = {
		name = LUG.UnitGroup_helpful,
		type = 'description',
		order = 10,
		fontSize = 'large',
		width = 'normal',
	},
	helpful_anchor = {
		name = L.Control2Display,
		desc = format('%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayHelpful),
		type = 'select',
		order = 11,
		values = dropUnitGroupAnchor,
		width = 'half',
	},
	helpful_priority = {
		name = L.Control2Priority,
		desc = function()
			return Ellipsis.db.profile.control.unitPrioritize and L.Control2PriorityDesc or L.Control2PriorityDisabled
		end,		type = 'select',
		order = 12,
		values = dropUnitGroupPriority,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.control.unitPrioritize
		end,
	},
	ugNoTarget = {
		name = LUG.UnitGroup_notarget,
		type = 'description',
		order = 13,
		fontSize = 'large',
		width = 'normal',
	},
	notarget_anchor = {
		name = L.Control2Display,
		desc = format('%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayNoTarget),
		type = 'select',
		order = 14,
		values = dropUnitGroupAnchor,
		width = 'half',
	},
	notarget_priority = {
		name = L.Control2Priority,
		desc = function()
			return Ellipsis.db.profile.control.unitPrioritize and L.Control2PriorityDesc or L.Control2PriorityDisabled
		end,
		type = 'select',
		order = 15,
		values = dropUnitGroupPriority,
		width = 'half',
		disabled = function()
			return not Ellipsis.db.profile.control.unitPrioritize
		end,
	},
	groupOverride = {
		name = '',
		type = 'group',
		inline = true,
		order = -1,
		args = {
			help = {
				name = L.Control2HelpOverride,
				type = 'description',
				order = 0,
			},
			ugTarget = {
				name = '  ' .. LUG.UnitGroup_target,
				type = 'description',
				order = 1,
				fontSize = 'large',
				width = 'half',
			},
			target_anchor = {
				name = L.Control2Display,
				desc = format('%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayTarget),
				type = 'select',
				order = 2,
				values = dropUnitGroupAnchor,
				width = 'half',
			},
			ugFocus = {
				name = '   ' .. LUG.UnitGroup_focus,
				type = 'description',
				order = 3,
				fontSize = 'large',
				width = 'half',
			},
			focus_anchor = {
				name = L.Control2Display,
				desc = format('%s\n\n%s', L.Control2DisplayDesc, L.Control2DisplayFocus),
				type = 'select',
				order = 4,
				values = dropUnitGroupAnchor,
				width = 'half',
			},
		}
	},
}


-- ------------------------
-- CONTROL 3 OPTIONS (Layout & Sorting)
-- ------------------------
local control3Options = {
	groupAura = {
		name = L.Control3AuraHeader,
		type = 'group',
		inline = true,
		order = 1,
		set = 'ControlSet_AuraLayout',
		args = {
			auraBarGrowth = {
				name = L.Control3AuraGrowth,
				desc = L.Control3AuraGrowthDesc,
				type = 'select',
				order = 1,
				values = dropAuraGrowthBar,
				width = 'half',
				hidden = function()
					return Ellipsis.db.profile.auras.style ~= 'BAR'
				end,
			},
			auraIconGrowth = {
				name = L.Control3AuraGrowth,
				desc = L.Control3AuraGrowthDesc,
				type = 'select',
				order = 1,
				values = dropAuraGrowthIcon,
				width = 'half',
				hidden = function()
					return Ellipsis.db.profile.auras.style ~= 'ICON'
				end,
			},
			auraIconWrapAuras = {
				name = L.Control3AuraWrapAuras,
				desc = L.Control3AuraWrapAurasDesc,
				type = 'toggle',
				order = 2,
				width = 'half',
				disabled = function()
					return Ellipsis.db.profile.auras.style ~= 'ICON'
				end,
			},
			auraSorting = {
				name = L.Control3AuraSorting,
				desc = L.Control3AuraSortingDesc,
				type = 'select',
				order = 3,
				values = dropAuraSorting,
			},
			auraIconPaddingX = {
				name = L.Control3AuraPaddingX,
				desc = L.Control3AuraPaddingXDesc,
				type = 'range',
				order = 4,
				min = 0,
				max = 20,
				step = 1,
				disabled = function()
					return Ellipsis.db.profile.auras.style ~= 'ICON'
				end,
			},
			auraBarPaddingY = {
				name = L.Control3AuraPaddingY,
				desc = L.Control3AuraPaddingYDesc,
				type = 'range',
				order = 5,
				min = 0,
				max = 20,
				step = 1,
				hidden = function()
					return Ellipsis.db.profile.auras.style ~= 'BAR'
				end,
			},
			auraIconPaddingY = {
				name = L.Control3AuraPaddingY,
				desc = L.Control3AuraPaddingYDesc,
				type = 'range',
				order = 5,
				min = 0,
				max = 60,
				step = 1,
				hidden = function()
					return Ellipsis.db.profile.auras.style ~= 'ICON'
				end,
			},
		}
	},
	groupUnit = {
		name = L.Control3UnitHeader,
		type = 'group',
		inline = true,
		order = 2,
		set = 'ControlSet_UnitLayout',
		args = {
			unitGrowth = {
				name = L.Control3UnitGrowth,
				desc = L.Control3UnitGrowthDesc,
				type = 'select',
				order = 1,
				values = dropUnitGrowth,
				width = 'half',
			},
			unitSorting = {
				name = L.Control3UnitSorting,
				desc = L.Control3UnitSortingDesc,
				type = 'select',
				order = 2,
				values = dropUnitSorting,
			},
			unitPrioritize = {
				name = L.Control3UnitPrioritize,
				desc = L.Control3UnitPrioritizeDesc,
				type = 'toggle',
				order = 3,
				width = 'half',
				set = function(info, val)
					Ellipsis:ControlSet(info, val)
					Ellipsis:ApplyOptionsUnitGroups()
				end,
			},
			unitPaddingX = {
				name = L.Control3UnitPaddingX,
				desc = L.Control3UnitPaddingXDesc,
				type = 'range',
				order = 4,
				min = 0,
				max = 20,
				step = 1,
				disabled = function()
					local growth = Ellipsis.db.profile.control.unitGrowth
					return (growth == 'DOWN' or growth == 'UP')
				end,
			},
			unitPaddingY = {
				name = L.Control3UnitPaddingY,
				desc = L.Control3UnitPaddingYDesc,
				type = 'range',
				order = 5,
				min = 0,
				max = 20,
				step = 1,
				disabled = function()
					local growth = Ellipsis.db.profile.control.unitGrowth
					return (growth == 'LEFT' or growth == 'RIGHT')
				end,
			},
		}
	},
}


-- ------------------------
-- DATA TABLE RETURNS
-- ------------------------
function Ellipsis:GetControl1Options()
	return control1Options
end

function Ellipsis:GetControl2Options()
	return control2Options
end

function Ellipsis:GetControl3Options()
	return control3Options
end


-- ------------------------
-- GETTERS & SETTERS
-- ------------------------
function Ellipsis:ControlGet(info)
	return self.db.profile.control[info[#info]]
end


function Ellipsis:ControlSet(info, val)
	self.db.profile.control[info[#info]] = val

	self:ConfigureControl()
end

function Ellipsis:ControlGet_UnitGroup(info)
	local group, setting = strsplit('_', info[#info])

	local anchor = self.db.profile.control.unitGroups[group][setting]

	if (anchor) then
		return anchor
	else
		return 0 -- no anchor set (internally = false)
	end
end

function Ellipsis:ControlSet_UnitGroup(info, val)
	local group, setting = strsplit('_', info[#info])

	self.db.profile.control.unitGroups[group][setting] = (val > 0) and tonumber(val) or false

	self:ConfigureControl()

	self:ApplyOptionsUnitGroups()
end

function Ellipsis:ControlSet_AuraLayout(info, val)
	self.db.profile.control[info[#info]] = val

	self:ConfigureUnits() -- configure localized unitObject settings

	self:UpdateExistingUnits() -- apply changes to all existing Units
end

function Ellipsis:ControlSet_UnitLayout(info, val)
	self.db.profile.control[info[#info]] = val

	self:ConfigureAnchors() -- configure localized unitAnchor settings

	for _, anchor in pairs(self.anchors) do
		anchor:UpdateDisplay(true) -- update display of all anchors (no internal settings to change)
	end
end
