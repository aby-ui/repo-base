--[[
HandyNotes
]]

-- This is the WoW 8.0 version
if select(4, GetBuildInfo()) < 80000 then
	return
end

---------------------------------------------------------
-- Addon declaration
HandyNotes = LibStub("AceAddon-3.0"):NewAddon("HandyNotes", "AceConsole-3.0", "AceEvent-3.0")
local HandyNotes = HandyNotes
local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes", false)

local HBD = LibStub("HereBeDragons-2.0")
local HBDPins = LibStub("HereBeDragons-Pins-2.0")
local HBDMigrate = LibStub("HereBeDragons-Migrate")

---------------------------------------------------------
-- Our db upvalue and db defaults
local db
local options
local defaults = {
	profile = {
		enabled       = true,
		icon_scale    = 1.0,
		icon_alpha    = 0.9,
		icon_scale_minimap = 0.75,
		icon_alpha_minimap = 0.9,
		enabledPlugins = {
			['*'] = true,
		},
	},
}


---------------------------------------------------------
-- Localize some globals
local floor = floor
local pairs, next, type = pairs, next, type
local CreateFrame = CreateFrame
local Minimap = Minimap


---------------------------------------------------------
-- xpcall safecall implementation
local xpcall = xpcall

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	-- we check to see if the func is passed is actually a function here and don't error when it isn't
	-- this safecall is used for optional functions like OnEnter OnLeave etc. When they are not
	-- present execution should continue without hinderance
	if type(func) == "function" then
		return xpcall(func, errorhandler, ...)
	end
end


---------------------------------------------------------
-- Our frames recycling code
local pinCache = {}
local minimapPins = {}
local worldmapPins = {}
local pinCount = 0

local function recyclePin(pin)
	pin:Hide()
	pinCache[pin] = true
end

local function clearAllPins(t)
	for key, pin in pairs(t) do
		recyclePin(pin)
		t[key] = nil
	end
end

local function getNewPin()
	local pin = next(pinCache)
	if pin then
		pinCache[pin] = nil -- remove it from the cache
		return pin
	end
	-- create a new pin
	pinCount = pinCount + 1
	pin = CreateFrame("Button", "HandyNotesPin"..pinCount, Minimap)
	pin:SetFrameLevel(5)
	pin:EnableMouse(true)
	pin:SetWidth(12)
	pin:SetHeight(12)
	pin:SetPoint("CENTER", Minimap, "CENTER")
	local texture = pin:CreateTexture(nil, "OVERLAY")
	pin.texture = texture
	texture:SetAllPoints(pin)
	pin:RegisterForClicks("AnyUp", "AnyDown")
	pin:SetMovable(true)
	pin:Hide()
	return pin
end


---------------------------------------------------------
-- Plugin handling
HandyNotes.plugins = {}
local pluginsOptionsText = {}

--[[ Documentation:
HandyNotes.plugins table contains every plugin which we will use to iterate over.
In this table, the format is:
	["Name of plugin"] = {table containing a set of standard functions, which we'll call pluginHandler}

Standard functions we require for every plugin:
	iter, state, value = pluginHandler:GetNodes2(uiMapID, minimap)
		Parameters
		- uiMapID: The zone we want data for
		- minimap: Boolean argument indicating that we want to get nodes to display for the minimap
		Returns:
		- iter: An iterator function that will loop over and return 5 values
			(coord, uiMapID, iconpath, scale, alpha)
			for every node in the requested zone. If the uiMapID return value is nil, we assume it is the
			same uiMapID as the argument passed in. Mainly used for continent uiMapID where the map passed
			in is a continent, and the return values are coords of subzone maps.
		- state, value: First 2 args to pass into iter() on the initial iteration

Legacy Alternative - You're strongly urged to update to GetNodes2!
	iter, state, value = pluginHandler:GetNodes(mapFile, minimap, dungeonLevel)
		Parameters
		- mapFile: The zone we want data for
		- minimap: Boolean argument indicating that we want to get nodes to display for the minimap
		- dungeonLevel: Level of the dungeon map. 0 indicates the zone has no dungeon levels
		Returns:
		- iter: An iterator function that will loop over and return 5 values
			(coord, mapFile, iconpath, scale, alpha, dungeonLevel)
			for every node in the requested zone. If the mapFile return value is nil, we assume it is the
			same mapFile as the argument passed in. Mainly used for continent mapFile where the map passed
			in is a continent, and the return values are coords of subzone maps. If the return dungeonLevel
			is nil, we assume it is the same as the argument passed in.
		- state, value: First 2 args to pass into iter() on the initial iteration

Standard functions you can provide optionally:
	pluginHandler:OnEnter(uiMapID/mapFile, coord)
		Function we will call when the mouse enters a HandyNote, you will generally produce a tooltip here.
	pluginHandler:OnLeave(uiMapID/mapFile, coord)
		Function we will call when the mouse leaves a HandyNote, you will generally hide the tooltip here.
	pluginHandler:OnClick(button, down, uiMapID/mapFile, coord)
		Function we will call when the user clicks on a HandyNote, you will generally produce a menu here on right-click.
]]

function HandyNotes:RegisterPluginDB(pluginName, pluginHandler, optionsTable)
	if self.plugins[pluginName] ~= nil then
		error(pluginName.." is already registered by another plugin.")
	else
		self.plugins[pluginName] = pluginHandler
	end
	worldmapPins[pluginName] = {}
	minimapPins[pluginName] = {}
	options.args.plugins.args[pluginName] = optionsTable
	pluginsOptionsText[pluginName] = optionsTable and optionsTable.name or pluginName
end


local pinsHandler = {}
function pinsHandler:OnEnter(motion)
	safecall(HandyNotes.plugins[self.pluginName].OnEnter, self, self.mapFile or self.uiMapID, self.coord)
end
function pinsHandler:OnLeave(motion)
	safecall(HandyNotes.plugins[self.pluginName].OnLeave, self, self.mapFile or self.uiMapID, self.coord)
end
function pinsHandler:OnClick(button, down)
	safecall(HandyNotes.plugins[self.pluginName].OnClick, self, button, down, self.mapFile or self.uiMapID, self.coord)
end


---------------------------------------------------------
-- Public functions

local continentZoneList = {
	[12]  = true, -- Kalimdor
	[13]  = true, -- Azeroth
	[101] = true, -- Outlands
	[113] = true, -- Northrend
	[424] = true, -- Pandaria
	[572] = true, -- Draenor
	[619] = true, -- Broken Isles
	[875] = true, -- Zandalar
	[876] = true, -- Kul Tiras
	
	-- mapFile compat entries
	["Kalimdor"]              = 12,
	["Azeroth"]               = 13,
	["Expansion01"]           = 101,
	["Northrend"]             = 113,
	["TheMaelstromContinent"] = 948,
	["Vashjir"]               = 203,
	["Pandaria"]              = 424,
	["Draenor"]               = 572,
	["BrokenIsles"]           = 619,
}

local function fillContinentZoneList(continent)
	continentZoneList[continent] = {}

	local children = C_Map.GetMapChildrenInfo(continent)
	if children then
		for _, child in ipairs(children) do
			if child.mapType == Enum.UIMapType.Zone then
				table.insert(continentZoneList[continent], child.mapID)
			end
		end
	end
end

-- Public function to get a list of zones in a continent
-- Can be called with a uiMapId, in which case it'll also return a list of uiMapIds,
-- or called with a legacy mapFile, in which case it'll return a list of legacy mapIDs
function HandyNotes:GetContinentZoneList(uiMapIdOrmapFile)
	if not continentZoneList[uiMapIdOrmapFile] then return nil end
	if type(continentZoneList[uiMapIdOrmapFile]) ~= "table" then
		if type(uiMapIdOrmapFile) == "string" then
			local uiMapIdContinent = continentZoneList[uiMapIdOrmapFile]
			if type(continentZoneList[uiMapIdContinent]) ~= "table" then
				fillContinentZoneList(uiMapIdContinent)
			end
			continentZoneList[uiMapIdOrmapFile] = {}
			for _, uiMapId in ipairs(continentZoneList[uiMapIdContinent]) do
				local mapId = HBDMigrate:GetLegacyMapInfo(uiMapId)
				if mapId then
					table.insert(continentZoneList[uiMapIdOrmapFile], mapId)
				end
			end
		else
			fillContinentZoneList(uiMapIdOrmapFile)
		end
	end
	return continentZoneList[uiMapIdOrmapFile]
end

-- Public functions for plugins to convert between coords <--> x,y
function HandyNotes:getCoord(x, y)
	return floor(x * 10000 + 0.5) * 10000 + floor(y * 10000 + 0.5)
end
function HandyNotes:getXY(id)
	return floor(id / 10000) / 10000, (id % 10000) / 10000
end

-- Public functions for plugins to convert between legacy MapFile <-> Map ID
-- DEPRECATED! Update your plugins to use the new "uiMapId" everywhere
function HandyNotes:GetMapFiletoMapID(mapFile)
	if not mapFile then return end
	local uiMapId = HBDMigrate:GetUIMapIDFromMapFile(mapFile)
	local mapID = HBDMigrate:GetLegacyMapInfo(uiMapId)
	return mapID
end
function HandyNotes:GetMapIDtoMapFile(mapID)
	if not mapID then return end
	local uiMapId = HBDMigrate:GetUIMapIDFromMapAreaId(mapID)
	local _, _, mapFile = HBDMigrate:GetLegacyMapInfo(uiMapId)
	return mapFile
end

---------------------------------------------------------
-- Core functions

local function LegacyNodeIterator(t, state)
	local coord, mapFile2, iconpath, scale, alpha, level2 = t.iter(t.data, state)
	local uiMapID = HBDMigrate:GetUIMapIDFromMapFile(mapFile2 or t.mapFile, level2 or t.level)
	return coord, uiMapID, iconpath, scale, alpha
end

local emptyTbl = {}
local function IterateNodes(pluginName, uiMapID, minimap)
	local handler = HandyNotes.plugins[pluginName]
	assert(handler)
	if handler.GetNodes2 then
		return handler:GetNodes2(uiMapID, minimap)
	elseif handler.GetNodes then
		local mapID, level, mapFile = HBDMigrate:GetLegacyMapInfo(uiMapID)
		if not mapFile then
			return next, emptyTbl
		end
		local iter, data, state = handler:GetNodes(mapFile, minimap, level)
		local t = { mapFile = mapFile, level, iter = iter, data = data }
		return LegacyNodeIterator, t, state
	else
		error(("Plugin %s does not have GetNodes or GetNodes2"):format(pluginName))
	end
end

---------------------------------------------------------
-- World Map Data Provider

HandyNotes.WorldMapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function HandyNotes.WorldMapDataProvider:RemoveAllData()
	if self:GetMap() then
		self:GetMap():RemoveAllPinsByTemplate("HandyNotesWorldMapPinTemplate")
	end
end

function HandyNotes.WorldMapDataProvider:RefreshAllData(fromOnShow)
	if not self:GetMap() then return end
	self:RemoveAllData()

	for pluginName in pairs(HandyNotes.plugins) do
		safecall(self.RefreshPlugin, self, pluginName)
	end
end

function HandyNotes.WorldMapDataProvider:RefreshPlugin(pluginName)
	for pin in self:GetMap():EnumeratePinsByTemplate("HandyNotesWorldMapPinTemplate") do
		if pin.pluginName == pluginName then
			self:GetMap():RemovePin(pin)
		end
	end
	
	if not db.enabledPlugins[pluginName] then return end
	local uiMapID = self:GetMap():GetMapID()
	if not uiMapID then return end
	
	for coord, uiMapID2, iconpath, scale, alpha in IterateNodes(pluginName, uiMapID, false) do
		local x, y = floor(coord / 10000) / 10000, (coord % 10000) / 10000
		if uiMapID2 and uiMapID ~= uiMapID2 then
			x, y = HBD:TranslateZoneCoordinates(x, y, uiMapID2, uiMapID)
		end
		local mapFile
		if not HandyNotes.plugins[pluginName].GetNodes2 then
			mapFile = select(3, HBDMigrate:GetLegacyMapInfo(uiMapID2 or uiMapID))
		end
		if x and y then
			self:GetMap():AcquirePin("HandyNotesWorldMapPinTemplate", pluginName, x, y, iconpath, scale, alpha, coord, uiMapID2 or uiMapID, mapFile)
		end
	end
end

--[[ Handy Notes WorldMap Pin ]]--
HandyNotesWorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin)

function HandyNotesWorldMapPinMixin:OnLoad()
	self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
	self:SetMovable(true)
	self:SetScalingLimits(1, 1.0, 1.2);
end

function HandyNotesWorldMapPinMixin:OnAcquired(pluginName, x, y, iconpath, scale, alpha, originalCoord, originalMapID, legacyMapFile)
	self.pluginName = pluginName
	self.coord = originalCoord
	self.uiMapID = originalMapID
	self.mapFile = legacyMapFile

	self:SetPosition(x, y)

	local size = 12 * db.icon_scale * scale
	self:SetSize(size, size)
	self:SetAlpha(db.icon_alpha * alpha)

	local t = self.texture
	if type(iconpath) == "table" then
		if iconpath.tCoordLeft then
			t:SetTexCoord(iconpath.tCoordLeft, iconpath.tCoordRight, iconpath.tCoordTop, iconpath.tCoordBottom)
		else
			t:SetTexCoord(0, 1, 0, 1)
		end
		if iconpath.r then
			t:SetVertexColor(iconpath.r, iconpath.g, iconpath.b, iconpath.a)
		else
			t:SetVertexColor(1, 1, 1, 1)
		end
		t:SetTexture(iconpath.icon)
	else
		t:SetTexCoord(0, 1, 0, 1)
		t:SetVertexColor(1, 1, 1, 1)
		t:SetTexture(iconpath)
	end
end

function HandyNotesWorldMapPinMixin:OnMouseEnter()
	pinsHandler.OnEnter(self)
end

function HandyNotesWorldMapPinMixin:OnMouseLeave()
	pinsHandler.OnLeave(self)
end

function HandyNotesWorldMapPinMixin:OnMouseDown(button)
	pinsHandler.OnClick(self, button, true)
end

function HandyNotesWorldMapPinMixin:OnMouseUp(button)
	pinsHandler.OnClick(self, button, false)
end

function HandyNotes:UpdateWorldMapPlugin(pluginName)
	if not HandyNotes:IsEnabled() then return end
	HandyNotes.WorldMapDataProvider:RefreshPlugin(pluginName)
end

-- This function updates all the icons on the world map for every plugin
function HandyNotes:UpdateWorldMap()
	if not HandyNotes:IsEnabled() then return end
	HandyNotes.WorldMapDataProvider:RefreshAllData()
end

---------------------------------------------------------
-- MiniMap Drawing

-- This function updates all the icons of one plugin on the world map
function HandyNotes:UpdateMinimapPlugin(pluginName)
	--if not Minimap:IsVisible() then return end

	HBDPins:RemoveAllMinimapIcons("HandyNotes" .. pluginName)
	clearAllPins(minimapPins[pluginName])
	if not db.enabledPlugins[pluginName] then return end

	local uiMapID = HBD:GetPlayerZone()
	if not uiMapID then return end 

	local ourScale, ourAlpha = 12 * db.icon_scale_minimap, db.icon_alpha_minimap
	local frameLevel = Minimap:GetFrameLevel() + 5
	local frameStrata = Minimap:GetFrameStrata()

	for coord, uiMapID2, iconpath, scale, alpha in IterateNodes(pluginName, uiMapID, true) do
		local icon = getNewPin()
		icon:SetParent(Minimap)
		icon:SetFrameStrata(frameStrata)
		icon:SetFrameLevel(frameLevel)
		scale = ourScale * scale
		icon:SetHeight(scale) -- Can't use :SetScale as that changes our positioning scaling as well
		icon:SetWidth(scale)
		icon:SetAlpha(ourAlpha * alpha)
		local t = icon.texture
		if type(iconpath) == "table" then
			if iconpath.tCoordLeft then
				t:SetTexCoord(iconpath.tCoordLeft, iconpath.tCoordRight, iconpath.tCoordTop, iconpath.tCoordBottom)
			else
				t:SetTexCoord(0, 1, 0, 1)
			end
			if iconpath.r then
				t:SetVertexColor(iconpath.r, iconpath.g, iconpath.b, iconpath.a)
			else
				t:SetVertexColor(1, 1, 1, 1)
			end
			t:SetTexture(iconpath.icon)
		else
			t:SetTexCoord(0, 1, 0, 1)
			t:SetVertexColor(1, 1, 1, 1)
			t:SetTexture(iconpath)
		end
		icon:SetScript("OnClick", nil)
		icon:SetScript("OnEnter", pinsHandler.OnEnter)
		icon:SetScript("OnLeave", pinsHandler.OnLeave)
		local x, y = floor(coord / 10000) / 10000, (coord % 10000) / 10000
		HBDPins:AddMinimapIconMap("HandyNotes" .. pluginName, icon, uiMapID2 or uiMapID, x, y, true)
		t:ClearAllPoints()
		t:SetAllPoints(icon) -- Not sure why this is necessary, but people are reporting weirdly sized textures
		minimapPins[pluginName][icon] = icon
		icon.pluginName = pluginName
		icon.coord = coord
		if not HandyNotes.plugins[pluginName].GetNodes2 then
			icon.mapFile = select(3, HBDMigrate:GetLegacyMapInfo(uiMapID2 or uiMapID))
		else
			icon.mapFile = nil
		end
		icon.uiMapID = uiMapID2 or uiMapID
	end
end

-- This function updates all the icons on the minimap for every plugin
function HandyNotes:UpdateMinimap()
	--if not Minimap:IsVisible() then return end
	for pluginName in pairs(self.plugins) do
		safecall(self.UpdateMinimapPlugin, self, pluginName)
	end
end

-- This function runs when we receive a "HandyNotes_NotifyUpdate"
-- notification from a plugin that its icons needs to be updated
-- Syntax is plugin:SendMessage("HandyNotes_NotifyUpdate", "pluginName")
function HandyNotes:UpdatePluginMap(message, pluginName)
	if self.plugins[pluginName] then
		self:UpdateMinimapPlugin(pluginName)
		self:UpdateWorldMapPlugin(pluginName)
	end
end

---------------------------------------------------------
-- Our options table

options = {
	type = "group",
	name = L["HandyNotes"],
	desc = L["HandyNotes"],
	args = {
		enabled = {
			type = "toggle",
			name = L["Enable HandyNotes"],
			desc = L["Enable or disable HandyNotes"],
			order = 1,
			get = function(info) return db.enabled end,
			set = function(info, v)
				db.enabled = v
				if v then HandyNotes:Enable() else HandyNotes:Disable() end
			end,
			disabled = false,
		},
		overall_settings = {
			type = "group",
			name = L["Overall settings"],
			desc = L["Overall settings that affect every database"],
			order = 10,
			get = function(info) return db[info.arg] end,
			set = function(info, v)
				local arg = info.arg
				db[arg] = v
				if arg == "icon_scale" or arg == "icon_alpha" then
					HandyNotes:UpdateWorldMap()
				else
					HandyNotes:UpdateMinimap()
				end
			end,
			disabled = function() return not db.enabled end,
			args = {
				desc = {
					name = L["These settings control the look and feel of HandyNotes globally. The icon's scale and alpha here are multiplied with the plugin's scale and alpha."],
					type = "description",
					order = 0,
				},
				icon_scale = {
					type = "range",
					name = L["World Map Icon Scale"],
					desc = L["The overall scale of the icons on the World Map"],
					min = 0.25, max = 2, step = 0.01,
					arg = "icon_scale",
					order = 10,
				},
				icon_alpha = {
					type = "range",
					name = L["World Map Icon Alpha"],
					desc = L["The overall alpha transparency of the icons on the World Map"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha",
					order = 20,
				},
				icon_scale_minimap = {
					type = "range",
					name = L["Minimap Icon Scale"],
					desc = L["The overall scale of the icons on the Minimap"],
					min = 0.25, max = 2, step = 0.01,
					arg = "icon_scale_minimap",
					order = 30,
				},
				icon_alpha_minimap = {
					type = "range",
					name = L["Minimap Icon Alpha"],
					desc = L["The overall alpha transparency of the icons on the Minimap"],
					min = 0, max = 1, step = 0.01,
					arg = "icon_alpha_minimap",
					order = 40,
				},
			},
		},
		plugins = {
			type = "group",
			name = L["Plugins"],
			desc = L["Plugin databases"],
			order = 20,
			args = {
				desc = {
					name = L["Configuration for each individual plugin database."],
					type = "description",
					order = 0,
				},
				show_plugins = {
					name = L["Show the following plugins on the map"], type = "multiselect",
					order = 20,
					values = pluginsOptionsText,
					get = function(info, k)
						return db.enabledPlugins[k]
					end,
					set = function(info, k, v)
						db.enabledPlugins[k] = v
						HandyNotes:UpdatePluginMap(nil, k)
					end,
				},
			},
		},
	},
}
options.args.plugins.disabled = options.args.overall_settings.disabled


---------------------------------------------------------
-- Addon initialization, enabling and disabling

function HandyNotes:OnInitialize()
    HandyNotesDB = HandyNotesDB or {}
    HandyNotesDB._mapData = nil
--[[
    local dataVersion = "v1.3.3"
    if U1CheckVersionedData(HandyNotesDB._mapData, dataVersion) then
        continentList, continentMapFile, mapFiletoMapID, mapIDtoMapFile, reverseMapFileC, reverseMapFileZ, reverseZoneC, reverseZoneZ, zoneList, zonetoMapID = unpack(HandyNotesDB._mapData.data)
    else
        initMapData()
        HandyNotesDB._mapData = {}
        HandyNotesDB._mapData.data = {continentList, continentMapFile, mapFiletoMapID, mapIDtoMapFile, reverseMapFileC, reverseMapFileZ, reverseZoneC, reverseZoneZ, zoneList, zonetoMapID}
        U1SaveVersionedData(HandyNotesDB._mapData, dataVersion)
    end
]]
	
	-- Set up our database
	self.db = LibStub("AceDB-3.0"):New("HandyNotesDB", defaults)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
	db = self.db.profile

	-- Register options table and slash command
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("HandyNotes", options)
	self:RegisterChatCommand("handynotes", function() LibStub("AceConfigDialog-3.0"):Open("HandyNotes") end)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HandyNotes", "HandyNotes")

	-- Get the option table for profiles
	options.args.profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	options.args.profiles.disabled = options.args.overall_settings.disabled
end

function HandyNotes:OnEnable()
	if not db.enabled then
		self:Disable()
		return
	end
	
	self:RegisterMessage("HandyNotes_NotifyUpdate", "UpdatePluginMap")
	self:UpdateMinimap()
	WorldMapFrame:AddDataProvider(HandyNotes.WorldMapDataProvider)
	self:UpdateWorldMap()
	HBD.RegisterCallback(self, "PlayerZoneChanged", "UpdateMinimap")
end

function HandyNotes:OnDisable()
	-- Remove all the pins
	for pluginName in pairs(self.plugins) do
		HBDPins:RemoveAllMinimapIcons("HandyNotes" .. pluginName)
		clearAllPins(minimapPins[pluginName])
	end
	WorldMapFrame:RemoveDataProvider(HandyNotes.WorldMapDataProvider)
	HBD.UnregisterCallback(self, "PlayerZoneChanged")
end

function HandyNotes:OnProfileChanged(event, database, newProfileKey)
	db = database.profile
	self:UpdateMinimap()
	self:UpdateWorldMap()
end


-- vim: ts=4 noexpandtab
