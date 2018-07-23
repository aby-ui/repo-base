--[[--------------------------------------------------------------------
	Grid
	Compact party and raid unit frames.
	Copyright (c) 2006-2009 Kyle Smith (Pastamancer)
	Copyright (c) 2009-2018 Phanx <addons@phanx.net>
	All rights reserved. See the accompanying LICENSE file for details.
	https://github.com/Phanx/Grid
	https://www.curseforge.com/wow/addons/grid
	https://www.wowinterface.com/downloads/info5747-Grid.html
----------------------------------------------------------------------]]

local GRID, Grid = ...
local L = Grid.L
local GridRoster = Grid:GetModule("GridRoster")

local GridStatus = Grid:NewModule("GridStatus")

local format, next, pairs, type = format, next, pairs, type

GridStatus.modulePrototype = {
	core = GridStatus,
	Debug = Grid.Debug,
	StartTimer = GridStatus.StartTimer,
	StopTimer = GridStatus.StopTimer,
}

function GridStatus.modulePrototype:OnInitialize()
	if not self.db then
		self.db = Grid.db:RegisterNamespace(self.moduleName, { profile = self.defaultDB or { } })
	end

	Grid:SetDebuggingEnabled(self.moduleName)
	for name, module in self:IterateModules() do
		self:RegisterModule(name, module)
		Grid:SetDebuggingEnabled(name)
	end

	if type(self.PostInitialize) == "function" then
		self:PostInitialize()
	end
end

function GridStatus.modulePrototype:OnEnable()
	for status, module in GridStatus:RegisteredStatusIterator() do
		if module == self.moduleName and self.db.profile[status] then
			if self.db.profile[status].enable and self.OnStatusEnable then
				self:OnStatusEnable(status)
			end
		end
	end

	if type(self.PostEnable) == "function" then
		self:PostEnable()
	end
end

function GridStatus.modulePrototype:OnDisable()
	for status, module in GridStatus:RegisteredStatusIterator() do
		if module == self.moduleName and self.db.profile[status] then
			if self.db.profile[status].enable and self.OnStatusDisable then
				self:OnStatusDisable(status)
			end
		end
	end

	if type(self.PostDisable) == "function" then
		self:PostDisable()
	end
end

function GridStatus.modulePrototype:Reset()
	self:Debug("Reset")

	if type(self.PostReset) == "function" then
		self:PostReset()
	end
	if type(self.UpdateAllUnits) == "function" then
		self:UpdateAllUnits("Reset")
	end
end

function GridStatus.modulePrototype:InitializeOptions()
	GridStatus:Debug("InitializeOptions", self.moduleName)
	if not self.options then
		self.options = {
			name = self.menuName or self.moduleName,
			desc = format(L["Options for %s."], self.moduleName),
			type = "group",
			args = {},
		}
	end
	if self.extraOptions then
		for name, option in pairs(self.extraOptions) do
			self.options.args[name] = option
		end
	end
end

function GridStatus.modulePrototype:RegisterStatus(status, desc, options, inMainMenu, order)
	GridStatus:RegisterStatus(status, desc, self.moduleName or true)

	local optionMenu
	if inMainMenu then
		optionMenu = GridStatus.options.args
	else
		if not self.options then
			self:InitializeOptions()
		end
		GridStatus.options.args[self.moduleName] = self.options
		optionMenu = self.options.args
	end

	local module = self
	if not optionMenu[status] then
		optionMenu[status] = {
			name = desc,
			desc = format(L["Status: %s"], desc),
			order = inMainMenu and 111 or order,
			type = "group",
			args = {
				enable = {
					name = L["Enable"],
					order = 10,
					width = "full",
					type = "toggle",
					get = function()
						return module.db.profile[status].enable
					end,
					set = function(_, v)
						module.db.profile[status].enable = v
						if v then
							if module.OnStatusEnable then
								module:OnStatusEnable(status)
							end
						else
							if module.OnStatusDisable then
								module:OnStatusDisable(status)
							end
						end
					end,
				},
				color = {
					name = L["Color"],
					order = 20,
					type = "color", hasAlpha = true,
					get = function()
						local color = module.db.profile[status].color
						return color.r, color.g, color.b, color.a
					end,
					set = function(_, r, g, b, a)
						local color = module.db.profile[status].color
						color.r = r
						color.g = g
						color.b = b
						color.a = a or 1
					end,
				},
				priority = {
					name = L["Priority"],
					order = 30,
					type = "range", max = 99, min = 0, step = 1,
					get = function()
						return module.db.profile[status].priority
					end,
					set = function(_, v)
						module.db.profile[status].priority = v
					end,
				},
			},
		}

		if options then
			for name, option in pairs(options) do
				if not option then
					optionMenu[status].args[name] = nil
				else
					optionMenu[status].args[name] = option
				end
			end
		end
	end
end

function GridStatus.modulePrototype:UnregisterStatus(status)
	GridStatus:UnregisterStatus(status, (self.moduleName or true))
end

function GridStatus.modulePrototype:SendStatusGained(...)
	return GridStatus:SendStatusGained(...)
end

function GridStatus.modulePrototype:SendStatusLost(...)
	return GridStatus:SendStatusLost(...)
end

function GridStatus.modulePrototype:SendStatusLostAllUnits(...)
	return GridStatus:SendStatusLostAllUnits(...)
end

GridStatus:SetDefaultModulePrototype(GridStatus.modulePrototype)
GridStatus:SetDefaultModuleLibraries("AceEvent-3.0")

function Grid:NewStatusModule(name, ...)
	return GridStatus:NewModule(name, ...)
end

------------------------------------------------------------------------

GridStatus.defaultDB = {
	range = false,
	colors = {
		PetColorType = "Using Fallback color",
		UNKNOWN_UNIT = { r = 0.5, g = 0.5, b = 0.5, a = 1 },
		UNKNOWN_PET = { r = 0, g = 1, b = 0, a = 1 },
		[L["Beast"]] = { r = 0.93725490196078, g = 0.75686274509804, b = 0.27843137254902, a = 1 },
		[L["Demon"]] = { r = 0.54509803921569, g = 0.25490196078431, b = 0.68627450980392, a = 1 },
		[L["Humanoid"]] = { r = 0.91764705882353, g = 0.67450980392157, b = 0.84705882352941, a = 1 },
		[L["Undead"]] = { r = 0.8, g = 0.2, b = 0, a = 1 },
		[L["Dragonkin"]] = { r = 0.8, g = 0.8, b = 0.8, a = 1 },
		[L["Elemental"]] = { r = 0.8, g = 1, b = 1, a = 1 },
		-- I think this was flying carpets
		[L["Not specified"]] = { r = 0.4, g = 0.4, b = 0.4, a = 1 },
	},
}

------------------------------------------------------------------------

GridStatus.options = {
	name = L["Status"],
	order = 4,
	type = "group",
	--childGroups = "tab",
	args = {
		color = {
			order = -1,
			name = L["Colors"],
			type = "group",
			args = {
				class = {
					order = 100,
					name = L["Class colors"],
					type = "group", inline = true,
					args = {
						br = {
							order = 120,
							name = "",
							type = "header",
						},
						reset = {
							order = 130,
							name = L["Reset class colors"],
							type = "execute", width = "double",
							func = function() GridStatus:ResetClassColors() end,
						}
					},
				},
				petcolortype = {
					order = 200,
					name = L["Pet coloring"],
					type = "select", width = "double",
					values = {
						["By Owner Class"] = L["By Owner Class"],
						["By Creature Type"] = L["By Creature Type"],
						["Using Fallback color"] = L["Using Fallback color"],
					},
					get = function()
							return GridStatus.db.profile.colors.PetColorType
						end,
					set = function(_, v)
							GridStatus.db.profile.colors.PetColorType = v
							GridStatus:SendMessage("Grid_ColorsChanged")
						end,
				},
				creaturetype = {
					order = 300,
					name = L["Creature type colors"],
					type = "group", inline = true,
					args = {
					},
				},
				fallback = {
					order = 400,
					name = L["Fallback colors"],
					desc = L["Color of unknown units or pets."],
					type = "group", inline = true,
					args = {
						unit = {
							type = "color",
							name = L["Unknown Unit"],
							desc = L["The color of unknown units."],
							order = 410,
							get = function()
									local c = GridStatus.db.profile.colors.UNKNOWN_UNIT
									return c.r, c.g, c.b, c.a
								end,
							set = function(_, r, g, b, a)
									local c = GridStatus.db.profile.colors.UNKNOWN_UNIT
									c.r, c.g, c.b, c.a = r, g, b, a
									GridStatus:SendMessage("Grid_ColorsChanged")
								end,
							hasAlpha = false,
						},
						pet = {
							type = "color",
							name = L["Unknown Pet"],
							desc = L["The color of unknown pets."],
							order = 420,
							get = function()
									local c = GridStatus.db.profile.colors.UNKNOWN_PET
									return c.r, c.g, c.b, c.a
								end,
							set = function(_, r, g, b, a)
									local c = GridStatus.db.profile.colors.UNKNOWN_PET
									c.r, c.g, c.b, c.a = r, g, b, a
									GridStatus:SendMessage("Grid_ColorsChanged")
								end,
							hasAlpha = false,
						},
					},
				},
			},
		},
	},
}

------------------------------------------------------------------------

local creatureTypes = { L["Beast"], L["Demon"], L["Humanoid"], L["Undead"], L["Dragonkin"], L["Elemental"], L["Not specified"] }

function GridStatus:FillColorOptions(options)
	local classEnglishToLocal = {}
	FillLocalizedClassList(classEnglishToLocal, false)

	local classcolor = {}
	for class, color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		classcolor[class] = { r = color.r, g = color.g, b = color.b }
	end

	local colors = self.db.profile.colors
	for class in pairs(classcolor) do
		if not colors[class] then
			colors[class] = classcolor[class]
		end
		local classLocal = classEnglishToLocal[class]
		options.args.class.args[class] = {
			type = "color",
			name = classLocal,
			get = function()
				local c = colors[class]
				return c.r, c.g, c.b
			end,
			set = function(_, r, g, b)
				local c = colors[class]
				c.r, c.g, c.b = r, g, b
				GridStatus:SendMessage("Grid_ColorsChanged")
			end,
		}
	end

	for i = 1, #creatureTypes do
		local class = creatureTypes[i]
		options.args.creaturetype.args[class] = {
			type = "color",
			name = class,
			get = function()
				local c = colors[class]
				return c.r, c.g, c.b
			end,
			set = function(_, r, g, b)
				local c = colors[class]
				c.r, c.g, c.b = r, g, b
				GridStatus:SendMessage("Grid_ColorsChanged")
			end,
		}
	end
end

function GridStatus:ResetClassColors()
	local colors = self.db.profile.colors
	for class, class_color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		local c = colors[class]
		c.r, c.g, c.b = class_color.r, class_color.g, class_color.b
	end
	GridStatus:SendMessage("Grid_ColorsChanged")
end

------------------------------------------------------------------------

function GridStatus:OnInitialize()
	self.super.OnInitialize(self)

	self.registry = {}
	self.registryDescriptions = {}
	self.cache = {}

	self:FillColorOptions(self.options.args.color)
end

function GridStatus:OnEnable()
	self.super.OnEnable(self)

	self:RegisterMessage("Grid_UnitLeft", "RemoveFromCache")
end

function GridStatus:Reset()
	self.super.Reset(self)

	self:FillColorOptions(self.options.args.color)

	GridStatus:SendMessage("Grid_ColorsChanged")
end

function GridStatus:OnModuleCreated(module)
	module.super = self.modulePrototype
	self:Debug("OnModuleCreated", module.moduleName)
	if Grid.db then
		-- otherwise it will be caught in core OnInitialize
		Grid:SetDebuggingEnabled(module.moduleName)
	end
end

------------------------------------------------------------------------

function GridStatus:RegisterStatus(status, description, moduleName)
	if not self.registry[status] then
		self:Debug("Registered", status, "("..description..")", "for", moduleName)
		self.registry[status] = (moduleName or true)
		self.registryDescriptions[status] = description
		self:SendMessage("Grid_StatusRegistered", status, description, moduleName)
	else
		-- error if status is already registered?
		self:Debug("RegisterStatus:", status, "is already registered.")
	end
end

function GridStatus:UnregisterStatus(status, moduleName)
	local name

	if self:IsStatusRegistered(status) then
		self:Debug("Unregistered", status, "for", moduleName)
		-- need to remove from cache
		for guid in pairs(self.cache) do
			self:SendStatusLost(guid, status)
		end

		-- now we can remove from registry
		self.registry[status] = nil
		self.registryDescriptions[status] = nil
		self:SendMessage("Grid_StatusUnregistered", status)
	end
end

function GridStatus:IsStatusRegistered(status)
	return self.registry and self.registry[status] and true
end

function GridStatus:RegisteredStatusIterator()
	local status
	local registry = self.registry
	local registryDescriptions = self.registryDescriptions
	return function()
		status = next(registry, status)
		return status, registry[status], registryDescriptions[status]
	end
end

------------------------------------------------------------------------

function GridStatus:SendStatusGained(guid, status, priority, range, color, text, value, maxValue, texture, start, duration, count, texCoords)
	self:Debug("GridStatus", "SendStatusGained", guid, status, text, value, maxValue)
	if not guid then return end

	if type(priority) == "table" then
		-- support tables!
		local t = priority
		priority, range, color, text, value, maxValue, texture, start, duration, count, texCoords = t.priority, t.range, t.color, t.text, t.value, t.maxValue, t.texture, t.start, t.duration, t.count or t.stack, t.texCoords
	end

	local cache = self.cache
	local cached

	if type(color) ~= "table" then
		self:Debug("color is not a table for", status)
	end

	if type(texture) == "string" and (texCoords and type(texCoords) ~= "table") then
		self:Debug("texCoords is not a table for", status)
		texCoords = nil
	end

	if text == nil then
		text = ""
	end

	-- create cache for unit if needed
	if not cache[guid] then
		cache[guid] = {}
	end

	if not cache[guid][status] then
		cache[guid][status] = {}
	end

	cached = cache[guid][status]

	-- if no changes were made, return rather than triggering an event
	if cached
		and cached.priority == priority
		and cached.range == range
		and cached.color == color
		and cached.text == text
		and cached.value == value
		and cached.maxValue == maxValue
		and cached.texture == texture
		and cached.start == start
		and cached.duration == duration
		and cached.count == count
		and cached.texCoords == texCoords
	then
		return
	end

	-- update cache
	cached.priority = priority
	cached.range = range
	cached.color = color
	cached.text = text
	cached.value = value
	cached.maxValue = maxValue
	cached.texture = texture
	cached.start = start
	cached.duration = duration
	cached.count = count
	cached.texCoords = texCoords

	self:SendMessage("Grid_StatusGained", guid, status, priority, range, color, text, value, maxValue, texture, start, duration, count, texCoords)
end

function GridStatus:SendStatusLost(guid, status)
	if not guid then return end

	-- if status isn't cached, don't send status lost event
	if not self.cache[guid] or not self.cache[guid][status] then
		return
	end

	self.cache[guid][status] = nil

	self:SendMessage("Grid_StatusLost", guid, status)
end

function GridStatus:SendStatusLostAllUnits(status)
	for guid in pairs(self.cache) do
		self:SendStatusLost(guid, status)
	end
end

function GridStatus:RemoveFromCache(event, guid)
	self.cache[guid] = nil
end

function GridStatus:GetCachedStatus(guid, status)
	local cache = self.cache
	return cache[guid] and cache[guid][status]
end

function GridStatus:CachedStatusIterator(status)
	local cache = self.cache
	local guid

	if status then
		-- iterator for a specific status
		return function()
			guid = next(cache, guid)

			-- we reached the end early?
			if guid == nil then
				return nil
			end

			while cache[guid][status] == nil do
				guid = next(cache, guid)

				if guid == nil then
					return nil
				end
			end

			return guid, status, cache[guid][status]
		end
	else
		-- iterator for all units, all statuses
		return function()
			status = next(cache[guid], status)

			-- find the next unit with a status
			while not status do
				guid = next(cache, guid)

				if guid then
					status = next(cache[guid], status)
				else
					return nil
				end
			end

			return guid, status, cache[guid][status]
		end
	end
end

------------------------------------------------------------------------

function GridStatus:UnitColor(guid)
	local unitid = GridRoster:GetUnitidByGUID(guid)

	if not unitid then
		-- bad news if we can't get a unitid
		return
	end

	local colors = self.db.profile.colors

	local owner = GridRoster:GetOwnerUnitidByUnitid(unitid)

	if owner then
		-- if it has an owner, then it's a pet
		local color_type = colors.PetColorType
		if color_type == "By Owner Class" then
			local _, owner_class = UnitClass(owner)
			if owner_class then
				return colors[owner_class]
			end

		elseif color_type == "By Creature Type" then
			local creature_type = UnitCreatureType(unitid)

			-- note that creature_type is nil for Shadowfiends
			if creature_type and colors[creature_type] then
				return colors[creature_type]
			end
		end

		return colors.UNKNOWN_PET
	end

	local _, class = UnitClass(unitid)
	if class then
		return colors[class]
	end

	return colors.UNKNOWN_UNIT
end
