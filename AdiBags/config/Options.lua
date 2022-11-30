--[[
AdiBags - Adirelle's bag addon.
Copyright 2010-2021 Adirelle (adirelle@gmail.com)
All rights reserved.

This file is part of AdiBags.

AdiBags is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

AdiBags is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with AdiBags.  If not, see <http://www.gnu.org/licenses/>.
--]]

local addonName = "AdiBags"
local addon = LibStub('AceAddon-3.0'):GetAddon(addonName)
local L = addon.L

--<GLOBALS
local _G = _G
local HideUIPanel = _G.HideUIPanel
local InterfaceOptionsFrame = _G.InterfaceOptionsFrame
local setmetatable = _G.setmetatable
local strjoin = _G.strjoin
local type = _G.type
local unpack = _G.unpack
--GLOBALS>

local safecall = addon.safecall

local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local LSM = LibStub('LibSharedMedia-3.0')

local options

--------------------------------------------------------------------------------
-- Option handler prototype
--------------------------------------------------------------------------------

local handlerProto = {}
local handlerMeta = { __index = handlerProto }

function handlerProto:ResolvePath(info)
	local db = self.dbHolder.db.profile
	local path = info.arg or info[#info]
	if type(path) == "string" then
		return db, path, path
	elseif type(path) == "table" then
		local n = #path
		for i = 1, n-1 do
			db = db[path[i]]
		end
		return db, path[n], strjoin('.', unpack(path))
	end
end

function handlerProto:Get(info, ...)
	local db, key = self:ResolvePath(info)
	if info.type == "multiselect" then
		local subKey = ...
		return db[key] and db[key][subKey]
	elseif info.type == 'color' then
		return unpack(db[key], 1, 4)
	else
		return db[key]
	end
end

function handlerProto:Set(info, value, ...)
	local db, key, path = self:ResolvePath(info)
	if info.type == 'multiselect' then
		local subKey, value = value, ...
		db[key][subKey] = value
		path = strjoin('.', path, subKey)
	elseif info.type == 'color' then
		if db[key] then
			local color = db[key]
			color[1], color[2], color[3], color[4] = value, ...
		else
			db[key] = { value, ... }
		end
	else
		db[key] = value
	end
	self.dbHolder:Debug('ConfigSet', path, value, ...)
	if self.isFilter then
		self.dbHolder:SendMessage('AdiBags_ConfigChanged', 'filter')
	else
		self.dbHolder:SendMessage('AdiBags_ConfigChanged', path)
	end
	if type(self.PostSet) == "function" then
		self:PostSet(path, value, ...)
	end
end

function handlerProto:IsDisabled(info)
	return (info.option ~= options and info.option ~= options.args.core and not addon.db.profile.enabled) or (self.dbHolder ~= addon and not self.dbHolder:IsEnabled())
end

local handlers = {}
function addon:GetOptionHandler(dbHolder, isFilter, postSet)
	if not handlers[dbHolder] then
		handlers[dbHolder] = setmetatable({dbHolder = dbHolder, isFilter = isFilter, PostSet = postSet}, handlerMeta)
		dbHolder.SendMessage = LibStub('ABEvent-1.0').SendMessage
	end
	return handlers[dbHolder]
end

--------------------------------------------------------------------------------
-- Filter & plugin options
--------------------------------------------------------------------------------

local filterOptions, moduleOptions = {}, {}

local OnModuleCreated

do
	local filters = {
		options = filterOptions,
		count = 0,
		nameAttribute = "filterName",
		dbKey = "filters",
		optionPath = "filters",
	}
	local modules = {
		options = moduleOptions,
		count = 0,
		nameAttribute = "moduleName",
		dbKey = "modules",
		optionPath = "modules",
	}

	function OnModuleCreated(self, module)
		if module.isBag and not module.isFilter and not module.GetOptions then
			return
		end

		local data = module.isFilter and filters or modules
		local name = module[data.nameAttribute]

		local baseOptions = {
			name = module.uiName or L[name] or name,
			desc = module.uiDesc,
			type = 'group',
			inline = true,
			order = 100 + data.count,
			args = {
				enabled = {
					name = L['Enabled'],
					desc = L['Check to enable this module.'],
					type = 'toggle',
					order = 20,
					get = function(info) return addon.db.profile[data.dbKey][name] end,
					set = function(info, value)
						addon.db.profile[data.dbKey][name] = value
						if value then module:Enable() else module:Disable() end
						self:UpdateFilters()
					end,
				},
			}
		}
		local extendedOptions

		if module.cannotDisable then
			baseOptions.args.enabled.disabled = true
		end
		if module.uiDesc then
			baseOptions.args.description = {
				name = module.uiDesc,
				type = 'description',
				order = 10,
			}
		end
		if module.isFilter then
			baseOptions.args.priority = {
				name = L['Priority'],
				type = 'range',
				order = 30,
				min = 0,
				max = 100,
				step = 1,
				bigStep = 1,
				get = function(info) return module:GetPriority() end,
				set = function(info, value) module:SetPriority(value) end,
			}
		end

		if module.GetOptions then
			local opts, handler = safecall(module, "GetOptions")
			if opts then
				extendedOptions = {
					handler = handler,
					args = opts,
				}
			end
		end

		data.options[name..'Basic'] = baseOptions

		if extendedOptions then
			extendedOptions.name = module.uiName or L[name] or name
			extendedOptions.desc = module.uiDesc
			extendedOptions.type = "group"
			extendedOptions.order = 1000 + data.count
			data.options[name] = extendedOptions

			if module.uiDesc then
				extendedOptions.args.description = {
					name = module.uiDesc,
					type = 'description',
					order = 1,
				}
			end

			baseOptions.args.configure = {
				name = L["Configure"],
				type = 'execute',
				func = function() AceConfigDialog:SelectGroup(addonName, data.optionPath, name) end,
			}
		end
		data.count = data.count + 1
	end
end

local function UpdateFilterOrder()
	for index, filter in addon:IterateFilters() do
		filterOptions[filter.filterName .. 'Basic'].order = 100 + index
	end
end

--------------------------------------------------------------------------------
-- Core options
--------------------------------------------------------------------------------

local function GetOptions()
	if options then return options end

	local lockOption = {
		name = function()
			return addon.anchor:IsShown() and L["Lock anchor"] or L["Unlock anchor"]
		end,
		desc = L["Click to toggle the bag anchor."],
		type = 'execute',
		order = 110,
		func = function()
			addon:ToggleAnchor()
		end,
		disabled = function(info) return (info.handler and info.handler:IsDisabled(info)) or addon.db.profile.positionMode ~= 'anchored' end,
	}

	filterOptions._desc = {
		name = L['Filters are used to dispatch items in bag sections. One item can only appear in one section. If the same item is selected by several filters, the one with the highest priority wins.'],
		type = 'description',
		order = 1,
	}
	local profiles = LibStub('AceDBOptions-3.0'):GetOptionsTable(addon.db)
	profiles.order = 600
	profiles.disabled = false
	local bagList = {}
	for name, module in addon:IterateModules() do
		if module.isBag then
			bagList[module.bagName] = L[module.bagName]
		end
	end
	options = {
		--[===[@debug@
		name = addonName..' DEV',
		--@end-debug@]===]
		--@non-debug@
		name = addonName..' v1.9.50',
		--@end-non-debug@
		type = 'group',
		handler = addon:GetOptionHandler(addon),
		get = 'Get',
		set = 'Set',
		disabled = 'IsDisabled',
		args = {
			enabled = {
				name = L['Enabled'],
				desc = L['Uncheck this to disable AdiBags.'],
				type = 'toggle',
				order = 100,
				disabled = false,
			},
			rightClickConfig = {
				name = L['Right-click to open options'],
				desc = L['When checked, right-clicking on an empty space of a bag opens the configuration panel.'],
				width = 'double',
				type = 'toggle',
				order = 110,
			},
			bags = {
				name = L['Bags'],
				type = 'group',
				order = 120,
				args = {
					bags = {
						name = L['Enabled bags'],
						desc = L['Select which bags AdiBags should display.'],
						type = 'multiselect',
						order = 90,
						values = bagList,
					},
					automatically = {
						name = L['Automatically...'],
						type = 'group',
						inline = true,
						order = 95,
						args = {
							autoOpen = {
								name = L["Open"],
								desc = L["Automatically open the bags at merchant's, bank, ..."],
								type = 'toggle',
								order = 95,
							},
						}
					},
					position = {
						name = L['Position & size'],
						type = 'group',
						order = 100,
						inline = true,
						args = {
							positionMode = {
								name = L['Position mode'],
								desc = L['Select how the bags are positionned.'],
								type = 'select',
								order = 100,
								values = {
									anchored = L['Anchored'],
									manual = L['Manual'],
								}
							},
							toggleAnchor = lockOption,
							reset = {
								name = L['Reset position'],
								desc = L['Click there to reset the bag positions and sizes.'],
								type = 'execute',
								order = 120,
								func = function() addon:ResetBagPositions() end,
							},
							hideAnchor = {
								name = L['Do not show anchor point'],
								desc = L['Hide the colored corner shown when you move the bag.'],
								type = 'toggle',
								order = 125,
							},
							scale = {
								name = L['Scale'],
								desc = L['Use this to adjust the bag scale.'],
								type = 'range',
								order = 130,
								isPercent = true,
								min = 0.1,
								max = 3.0,
								step = 0.1,
								set = function(info, newScale)
									addon.db.profile.scale = newScale
									addon:LayoutBags()
									addon:SendMessage('AdiBags_LayoutChanged')
								end,
							},
							maxHeight = {
								name = L['Maximum bag height'],
								desc = L['Adjust the maximum height of the bags, relative to screen size.'],
								type = 'range',
								order = 150,
								isPercent = true,
								min = 0.30,
								max = 0.90,
								step = 0.01,
							},
						},
					},
					sections = {
						name = L['Section layout'],
						type = 'group',
						inline = true,
						args = {
							compactLayout = {
								name = L['Compact layout'],
								desc = L['When enabled, AdiBags reorder the section to achieve a more compact layout.'],
								type = 'toggle',
								order = 135,
								set = function(info, compactLayout)
									addon.db.profile.compactLayout = compactLayout
									addon:SendMessage('AdiBags_LayoutChanged')
								end,
							},
							--[[
							gridLayout = {
								name = L['(BETA) Grid Layout'],
								desc = L['When enabled, AdiBags switches to a grid layout with dragable sections.'],
								type = 'toggle',
								order = 135,
								set = function(info, gridLayout)
									addon.db.profile.gridLayout = gridLayout
									ReloadUI()
									addon:SendMessage('AdiBags_GridLayoutChanged')
								end,
							},
							--]]
							columnWidth = {
								name = L['Column width'],
								desc = L['Adjust the width of the bag columns.'],
								type = 'group',
								inline = true,
								order = 140,
								args = {
									Backpack = {
										name = L['Backpack'],
										type = 'range',
										min = 4,
										max = 20,
										step = 1,
										arg = { "columnWidth", "Backpack" },
									},
									Bank = {
										name = L['Bank'],
										type = 'range',
										min = 4,
										max = 20,
										step = 1,
										arg = { "columnWidth", "Bank" },
									},
								},
							},
						},
					},
				},
			},
			skin = {
				name = L['Skin'],
				type = 'group',
				order = 150,
				args = {
					bagFont = addon:CreateFontOptions(addon.bagFont, L["Bag title"], 10),
					sectionFont = addon:CreateFontOptions(addon.sectionFont, L["Section header"], 15),
					background = {
						name = L['Bag background'],
						type = 'group',
						inline = true,
						order = 20,
						args = {
							texture = {
								name = L['Texture'],
								type = 'select',
								dialogControl = 'LSM30_Background',
								values = AceGUIWidgetLSMlists.background,
								order = 10,
								arg = { "skin", "background" },
							},
							insets = {
								name = L['Insets'],
								type = 'range',
								order = 20,
								arg = { "skin", "insets" },
								min = -16,
								max = 16,
								step = 1,
							},
							border = {
								name = L['Border'],
								type = 'select',
								dialogControl = 'LSM30_Border',
								values = AceGUIWidgetLSMlists.border,
								order = 30,
								arg = { "skin", "border" },
							},
							borderWidth = {
								name = L['Border width'],
								type = 'range',
								order = 40,
								arg = { "skin", "borderWidth" },
								min = 1,
								max = 64,
								step = 1,
							},
							backpackColor = {
								name = L['Backpack color'],
								type = 'color',
								order = 50,
								hasAlpha = true,
								arg = { "skin", "BackpackColor" },
							},
							bankColor = {
								name = L['Bank color'],
								type = 'color',
								order = 60,
								hasAlpha = true,
								arg = { "skin", "BankColor" },
							},
							reagentBankColor = {
								name = L['Reagent bank color'],
								type = 'color',
								order = 70,
								hasAlpha = true,
								arg = { "skin", "ReagentBankColor" },
							},
						},
					}
				},
			},
			items = {
				name = L['Items'],
				type = 'group',
				order = 200,
				args = {
					sortingOrder = {
						name = L['Sorting order'],
						desc = L['Select how items should be sorted within each section.'],
						width = 'double',
						type = 'select',
						order = 100,
						values = {
							default = L['By category, subcategory, quality and item level (default)'],
							byName = L['By name'],
							byQualityAndLevel = L['By quality and item level'],
						}
					},
					quality = {
						name = L['Quality highlight'],
						type = 'group',
						inline = true,
						order = 100,
						args = {
							qualityHighlight = {
								name = L['Enabled'],
								desc = L['Check this to display a colored border around items, based on item quality.'],
								type = 'toggle',
								order = 210,
							},
							qualityOpacity = {
								name = L['Opacity'],
								desc = L['Use this to adjust the quality-based border opacity. 100% means fully opaque.'],
								type = 'range',
								order = 220,
								isPercent = true,
								min = 0.05,
								max = 1.0,
								step = 0.05,
								disabled = function(info)
									return info.handler:IsDisabled(info) or not addon.db.profile.qualityHighlight
								end,
							},
							dimJunk = {
								name = L['Dim junk'],
								desc = L['Check this to have poor quality items dimmed.'],
								type = 'toggle',
								order = 225,
								disabled = function(info)
									return info.handler:IsDisabled(info) or not addon.db.profile.qualityHighlight
								end,
							},
						},
					},
					questIndicator = {
						name = L['Quest indicator'],
						desc = L['Check this to display an indicator on quest items.'],
						type = 'toggle',
						order = 230,
					},
					showBagType = {
						name = L['Bag type'],
						desc = L['Check this to display a bag type tag in the top left corner of items.'],
						type = 'toggle',
						order = 240,
					},
					virtualStacks = {
						name = L['Virtual stacks'],
						type = 'group',
						inline = true,
						order = 300,
						args = {
							_desc = {
								name = L['Virtual stacks display in one place items that actually spread over several bag slots.'],
								type = 'description',
								order = 1,
							},
							freeSpace = {
								name = L['Merge free space'],
								desc = L['Show only one free slot for each kind of bags.'],
								order = 10,
								type = 'toggle',
								arg = {'virtualStacks', 'freeSpace'},
							},
							others = {
								name = L['Merge unstackable items'],
								desc = L['Show only one slot of items that cannot be stacked.'],
								order = 15,
								width = 'double',
								type = 'toggle',
								arg = {'virtualStacks', 'others'},
							},
							stackable = {
								name = L['Merge stackable items'],
								desc = L['Show only one slot of items that can be stacked.'],
								order = 20,
								width = 'double',
								type = 'toggle',
								arg = {'virtualStacks', 'stackable'},
							},
							incomplete = {
								name = L['... including incomplete stacks'],
								desc= L['Merge incomplete stacks with complete ones.'],
								order = 30,
								width = 'double',
								type = 'toggle',
								arg = {'virtualStacks', 'incomplete'},
								disabled = function(info)
									return info.handler:IsDisabled(info) or not addon.db.profile.virtualStacks.stackable
								end
							},
							notWhenTrading = {
								name = L["At mechants', bank, auction house, ..."],
								desc = L["Change stacking at merchants', auction house, bank, mailboxes or when trading."],
								order = 40,
								width = 'double',
								type = 'select',
								arg = {'virtualStacks', 'notWhenTrading'},
								values = {
									L['Keep all stacks together.'],
									L['Separate unstackable items.'],
									L['Separate incomplete stacks.'],
									L['Show every distinct item stacks.'],
								},
								disabled = function(info)
									return info.handler:IsDisabled(info) or not (addon.db.profile.virtualStacks.stackable or addon.db.profile.virtualStacks.others)
								end
							},
						}
					},
				},
			},
			filters = {
				name = L['Filters'],
				desc = L['Toggle and configure item filters.'],
				type = 'group',
				order = 400,
				args = filterOptions,
			},
			modules = {
				name = L['Plugins'],
				desc = L['Toggle and configure plugins.'],
				type = 'group',
				order = 500,
				args = moduleOptions,
			},
			profiles = profiles,
		},
		plugins = {}
	}
	if addon.isRetail then
		options["args"]["bags"]["args"]["automatically"]["args"]["autoDeposit"] = {
			name = L["Deposit reagents"],
			desc = L["Automtically deposit all reagents into the reagent bank when you talk to the banker."],
			type = 'toggle',
			order = 110,
			disabled = function() return not IsReagentBankUnlocked() end,
		}
	end
	hooksecurefunc(addon, "OnModuleCreated", OnModuleCreated)
	for name, module in addon:IterateModules() do
		OnModuleCreated(addon, module)
	end
	UpdateFilterOrder()

	LibStub('ABEvent-1.0').RegisterMessage(addonName.."_Config", 'AdiBags_FiltersChanged', UpdateFilterOrder)

	return options
end

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

LibStub('AceConfig-3.0'):RegisterOptionsTable(addonName, GetOptions)

function addon:OpenOptions(...)
	AceConfigDialog:SetDefaultSize(addonName, 800, 600)
	if select('#', ...) > 0 then
		self:Debug('OpenOptions =>', select('#', ...), ...)
		AceConfigDialog:Open(addonName)
		AceConfigDialog:SelectGroup(addonName, ...)
	elseif not AceConfigDialog:Close(addonName) then
		AceConfigDialog:Open(addonName)
	end
end
