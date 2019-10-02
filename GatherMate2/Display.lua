local GatherMate = LibStub("AceAddon-3.0"):GetAddon("GatherMate2")
local Display = GatherMate:NewModule("Display","AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("GatherMate2")

local WoWClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)

-- Current minimap pin set
local minimapPins, minimapPinCount = {}, 0
-- Current worldmap pin set
local worldmapPins = {}
-- table for UIDropdownMenu info
local info = {}
-- cache of pins
local pinCache = {}
-- last x,y of the player.
-- total number of pins we have created
local lastXY, lastYY, pinCount = 0, 0, 0
-- reference to the pin generating the UIDropDown
local pinClickedOn
-- our current zone
local zone = -1
-- cache of table insert functions
local tinsert, tremove, next, pairs = tinsert, tremove, next, pairs
-- minimap rotation
local rotateMinimap = GetCVar("rotateMinimap") == "1"
-- shape of the minimap
local minimapShape
-- is the minimap indoors or outdoors
local indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
-- diameter of the minimap
local mapRadius, minimapWidth, minimapHeight, minimapScale, lastFacing, lastZoom
local minimapStrata, minimapFrameLevel
-- math function cache
local math_sin, math_cos, abs, max = math.sin, math.cos, math.abs, math.max
local sin, cos
-- API function cache
local GetRealZoneText = GetRealZoneText
local GetProfessionInfo = GetProfessionInfo
local strfind, format = string.find, string.format
local trackingCircle, nodeTextures
local db
local Minimap = Minimap
local inInstance
local nodeRange = 2
local forceNextUpdate
local trackShow = {}

local profession_to_skill = {}
local have_prof_skill = {}

local active_tracking = {}
local tracking_spells = {}

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
}

--[[
	recycle a pin
]]
local function recyclePin(pin)
	pin:Hide()
	pin.coords = nil
	pin.nodeType = nil
	pin.zone = nil
	pin.title = nil
	pin.worldmap = false
	pin.nodeID = 0
	pin.keep = nil
	pinCache[pin] = true
end
--[[
	clear a set of pins
]]
local function clearpins(t)
	for k,v in pairs(t) do
		recyclePin(v)
		t[k] = nil
	end
end
--[[
	Delete a pin from the DB, then call update to refresh both minimap and world map
]]
local function deletePin(button,pin)
	GatherMate:RemoveNodeByID(pin.zone, pin.nodeType, pin.coords)
	Display:UpdateWorldMap(true)
	Display:UpdateMiniMap(true)
end
--[[
	Pin OnEnter
]]
local tooltip_template = "|c%02x%02x%02x%02x%s|r"
local function showPin(self)
	if (self.title) then
		local pinset
		if self.worldmap then
			pinset = worldmapPins
		else
			pinset = minimapPins
		end
		local x, y = self:GetCenter()
		local parentX, parentY = UIParent:GetCenter()
		if ( x > parentX ) then
			GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		else
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		end

		local t = db.trackColors
		local text = format(tooltip_template, t[self.nodeType].Alpha*255, t[self.nodeType].Red*255, t[self.nodeType].Green*255, t[self.nodeType].Blue*255, self.title)
		for id, pin in pairs(pinset) do
			if pin:IsMouseOver() and pin.title and pin ~= self then
				text = text .. "\n" .. format(tooltip_template, t[pin.nodeType].Alpha*255, t[pin.nodeType].Red*255, t[pin.nodeType].Green*255, t[pin.nodeType].Blue*255, pin.title)
			end
		end
		GameTooltip:SetText(text)
		GameTooltip:Show()
	end
end
--[[
	Pin OnLeave
]]
local function hidePin(self)
	GameTooltip:Hide()
end
--[[
	Pin click handler
]]
local function pinClick(self, button)
	if button == "RightButton" and self.worldmap then
		pinClickedOn = self
		ToggleDropDownMenu(1, nil, GatherMate2_GenericDropDownMenu, self, 0, 0)
	elseif self.worldmap == false then
		-- This "simulates" clickthru on the minimap to ping the minimap, by roughknight
		if Minimap:GetObjectType() == "Minimap" then -- This is for SexyMap's HudMap, which reparents to a hud frame that isn't a minimap
			local point, parent, relPoint, x, y = self:GetPoint()
			Minimap:PingLocation(x, y)
		end
	end
end

--[[
	Add pin location to TomTom waypoints
]]
local function addTomTomWaypoint(button,pin)
	if TomTom then
		local x, y = GatherMate:DecodeLoc(pin.coords)
		TomTom:AddWaypoint(pin.zone, x, y, {
			title = pin.title,
			persistent = nil,
			minimap = true,
			world = true
		})
	end
end
--[[
	Generate a drop down menu for a pin
]]
local function generatePinMenu(self,level)
	if (not level) then return end
	for k in pairs(info) do info[k] = nil end
	if (level == 1) then
		-- Create the title of the menu
		info.isTitle      = 1
		info.text         = L["GatherMate Pin Options"]
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level)

		-- Generate a menu item for each pin the mouse is on
		info.disabled     = nil
		info.isTitle      = nil
		info.notCheckable = nil
		for id, pin in pairs(worldmapPins) do
			if pin:IsMouseOver() and pin.title then
				info.text = L["Delete"] .. " :" ..pin.title
				info.icon = nodeTextures[pin.nodeType][GatherMate:GetIDForNode(pin.nodeType, pin.title)]
				info.func = deletePin
				info.arg1 = pin
				UIDropDownMenu_AddButton(info, level);
			end
		end

		if TomTom then
			info.text = L["Add this location to TomTom waypoints"]
			info.icon = nil
			info.func = addTomTomWaypoint
			info.arg1 = pinClickedOn
			UIDropDownMenu_AddButton(info, level)
		end

		-- Close menu item
		info.text         = CLOSE
		info.icon         = nil
		info.func         = function() CloseDropDownMenus() end
		info.arg1         = nil
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level);
	end
end

--[[
	Setup the dropdown menu
]]
local GatherMate2_GenericDropDownMenu = CreateFrame("Frame", "GatherMate2_GenericDropDownMenu")
GatherMate2_GenericDropDownMenu.displayMode = "MENU"
GatherMate2_GenericDropDownMenu.initialize = generatePinMenu
local last_update = 0
local listening = false
--[[
	Enable the mod and add our event listeners and timers
]]
local fullInit = false
function Display:OnEnable()
	db = GatherMate.db.profile

	trackingCircle = self.trackingCircle
	nodeTextures = GatherMate.nodeTextures
	-- Recheck cvars after all addons are loaded.
	rotateMinimap = GetCVar("rotateMinimap") == "1"
	if not self.updateFrame then
		GatherMate.Visible = {}
		self.updateFrame = CreateFrame("Frame")
		self.updateFrame:SetScript("OnUpdate", function(frame, elapsed)
			last_update = last_update + elapsed
			if last_update > 2 or forceNextUpdate then
				Display:UpdateMiniMap(true)
				last_update = 0
				forceNextUpdate = false
			else
				Display:UpdateIconPositions()
			end
		end)
	end

	WorldMapFrame:AddDataProvider(Display.WorldMapDataProvider)

	self:RegisterMapEvents()
	self:RegisterEvent("SKILL_LINES_CHANGED")
	self:RegisterEvent("MINIMAP_UPDATE_TRACKING")
	self:RegisterEvent("PLAYER_ENTERING_WORLD","UpdateMaps")
	GatherMate.HBD.RegisterCallback(self, "PlayerZoneChanged")
	if WoWClassic then
		ExpandSkillHeader(0)
	else
		self:SKILL_LINES_CHANGED()
	end
	self:MINIMAP_UPDATE_TRACKING()
	self:PlayerZoneChanged()
	self:DigsitesChanged()
	--self:UpdateMaps()  -- already in DigsitesChanged()
	fullInit = true
end

function Display:RegisterMapEvents()
	self:RegisterEvent("MINIMAP_UPDATE_ZOOM", "MinimapZoom")
	self:RegisterEvent("CVAR_UPDATE", "ChangedVars")
	self:RegisterMessage("GatherMate2ConfigChanged","ConfigChanged")
	self:RegisterMessage("GatherMate2NodeAdded", "ScheduleUpdate")
	self:RegisterMessage("GatherMate2DataImport", "DataUpdate")
	self:RegisterMessage("GatherMate2Cleanup", "DataUpdate")
	--self:RegisterEvent("ARTIFACT_DIG_SITE_UPDATED","DigsitesChanged")
	self.updateFrame:Show()
	listening = true
end

function Display:UnregisterMapEvents()
	self:UnregisterEvent("MINIMAP_UPDATE_ZOOM")
	self:UnregisterEvent("CVAR_UPDATE")
	--self:UnregisterEvent("ARTIFACT_DIG_SITE_UPDATED")
	self:UnregisterMessage("GatherMate2ConfigChanged")
	self:UnregisterMessage("GatherMate2NodeAdded")
	self:UnregisterMessage("GatherMate2DataImport")
	self:UnregisterMessage("GatherMate2Cleanup")
	clearpins(worldmapPins)
	clearpins(minimapPins)
	self.updateFrame:Hide()
	listening = false
end

-- Disable the mod
function Display:OnDisable()
	self:UnregisterMapEvents()
	self:UnregisterEvent("SKILL_LINES_CHANGED")
	self:UnregisterEvent("MINIMAP_UPDATE_TRACKING")
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	GatherMate.HBD.UnregisterCallback(self, "PlayerZoneChanged")
	WorldMapFrame:RemoveDataProvider(Display.WorldMapDataProvider)
end

function Display:PlayerZoneChanged()
	local newZone = GatherMate.HBD:GetPlayerZone()
	if GatherMate.phasing[newZone] then newZone = GatherMate.phasing[newZone] end
	if newZone ~= zone then
		zone = newZone
		self:UpdateMiniMap(true)
	end
end

function Display:SKILL_LINES_CHANGED()
	for k,v in pairs(have_prof_skill) do
		have_prof_skill[k] = nil
	end

	if WoWClassic then
		local numSkills = GetNumSkillLines()
		for i = 1, numSkills do
			local skillName, header = GetSkillLineInfo(i)
				if profession_to_skill[skillName] then
					have_prof_skill[profession_to_skill[skillName]] = true
				end
		end
	else
		for index, key in pairs({GetProfessions()}) do
			local name, icon, rank, maxrank, numspells, spelloffset, skillline = GetProfessionInfo(key)
			if profession_to_skill[name] then
				have_prof_skill[profession_to_skill[name]] = true
			end
		end
	end
	self:UpdateMaps()
end

function Display:MINIMAP_UPDATE_TRACKING()
	if WoWClassic then
		table.wipe(active_tracking)
		local texture = GetTrackingTexture()
		if tracking_spells[texture] then
			active_tracking[tracking_spells[texture]] = true
		end
	else
		local count = GetNumTrackingTypes();
		local info;
		for id=1, count do
			local name, texture, active, category  = GetTrackingInfo(id);
			if tracking_spells[name] and active then
				active_tracking[tracking_spells[name]] = true
			else
				if tracking_spells[name] and not active then
					active_tracking[tracking_spells[name]] = false
				end
			end
		end
	end
	self:UpdateMaps()
end

local digSites = {}

function Display:DigsitesChanged()
	if WoWClassic then return end
	table.wipe(digSites)
	for continent in pairs(continentZoneList) do
		local digSites = C_ResearchInfo.GetDigSitesForMap(continent)
		for i, digSiteInfo in ipairs(digSites) do
			local positionMapInfo = C_Map.GetMapInfoAtPosition(continent, digSiteInfo.position.x, digSiteInfo.position.y)
			if positionMapInfo and positionMapInfo.mapID ~= continent then
				digSites[positionMapInfo.mapID] = true
			end
		end
	end
	self:UpdateMaps()
end

local function IsActiveDigSite()
	local showDig = _G.GetCVarBool("digSites")
	return digSites[zone] and showDig
end

function Display:UpdateVisibility()
	for k, v in pairs(GatherMate.db_types) do
		local visible = false
		local state = db.show[v]
		if state == "always" then
			visible = true
		elseif state == "with_profession" then
			visible = have_prof_skill[v]
		elseif state == "active" then
			visible = active_tracking[v] == true
			if not WoWClassic and v == "Archaeology" then
				visible = IsActiveDigSite()
			end
		end
		GatherMate.Visible[v] = visible

		-- For tracking circle
		visible = false
		state = db.trackShow
		if state == "always" then
			visible = true
		elseif state == "with_profession" then
			visible = have_prof_skill[v]
		elseif state == "active" then
			visible = (active_tracking[v] == true)
			if not WoWClassic and v == "Archaeology" then
				visible = IsActiveDigSite()
			end
		end
		trackShow[v] = visible
	end
end

function Display:SetTrackingSpell(skill,spell)
	local spellName, _, texture = GetSpellInfo(spell)
	if not spellName then return end
	if WoWClassic then
		tracking_spells[texture] = skill
	else
		tracking_spells[spellName] = skill
	end
	if fullInit then self:MINIMAP_UPDATE_TRACKING() end
end

function Display:SetSkillProfession(skill, profession)
	profession_to_skill[profession] = skill
	if fullInit then self:SKILL_LINES_CHANGED() end
end

function Display:ScheduleUpdate()
	forceNextUpdate = true
end

function Display:DataUpdate()
	forceNextUpdate = true
	self:UpdateMaps()
end

function Display:ConfigChanged()
	db = GatherMate.db.profile
	self:UpdateMaps()
	-- TODO filter prefs
end
--[[
	Get a Map pin
]]
function Display:getMapPin()
	local pin = next(pinCache)
	if pin then
		pinCache[pin] = nil -- remove it from the cache
		return pin
	end
	-- create a new pin
	pinCount = pinCount + 1
	pin = CreateFrame("Button", "GatherMatePin"..pinCount, Minimap)
	pin:SetFrameLevel(5)
	pin:EnableMouse(true)
	pin:SetWidth(16)
	pin:SetHeight(16)
	pin:SetPoint("CENTER", Minimap, "CENTER")
	local texture = pin:CreateTexture(nil, "OVERLAY")
	pin.texture = texture
	texture:SetAllPoints(pin)
	texture:SetTexture(trackingCircle)
	texture:SetTexCoord(0, 1, 0, 1)
	texture:SetTexelSnappingBias(0)
	texture:SetSnapToPixelGrid(false)
	pin:RegisterForClicks("LeftButtonUp", "RightButtonUp");
	pin:SetScript("OnEnter", showPin)
	pin:SetScript("OnLeave", hidePin)
	pin:SetScript("OnClick", pinClick)
	pin:Hide()
	return pin
end
--[[
	Add a new pin to the minimap
]]
function Display:getMiniPin(coord, nodeID, nodeType, zone, index)
	local pin = minimapPins[index]
	if not pin then
		pin = self:getMapPin()
		pin.coords = coord
		pin.title = GatherMate:GetNameForNode(nodeType, nodeID)
		pin.zone = zone
		pin.nodeID = nodeID
		pin.nodeType = nodeType
		pin.worldmap = false
		pin:SetParent(Minimap)
		pin:SetFrameStrata(minimapStrata)
		pin:SetFrameLevel(minimapFrameLevel)
		pin:SetHeight(12 * db.miniscale / minimapScale)
		pin:SetWidth(12 * db.miniscale / minimapScale)
		--pin:SetAlpha(db.alpha)
		pin:EnableMouse(db.minimapTooltips)
		pin.isCircle = false
		pin.texture:SetTexture(nodeTextures[nodeType][nodeID])
		pin.texture:SetTexCoord(0, 1, 0, 1)
		pin.texture:SetVertexColor(1, 1, 1, 1)
		pin.x, pin.y = GatherMate:DecodeLoc(coord)
		pin.x1, pin.y1 = GatherMate.HBD:GetWorldCoordinatesFromZone(pin.x,pin.y,zone)
		minimapPins[index] = pin
	end
	return pin
end

function Display:addMiniPin(pin, refresh)
	local xDist, yDist = lastXY - pin.x1, lastYY - pin.y1
	-- calculate relative position and distance to the player
	local dist_2 = xDist*xDist + yDist*yDist
	-- if distance <= db.trackDistance, convert to the circle texture
	if (not pin.isCircle or refresh) and trackShow[pin.nodeType] and dist_2 <= db.trackDistance^2 then
		pin.texture:SetTexture(trackingCircle)
		local t = db.trackColors[pin.nodeType]
		pin.texture:SetVertexColor(t.Red, t.Green, t.Blue, t.Alpha)
		pin:SetHeight(10 / minimapScale)
		pin:SetWidth(10 / minimapScale)
		pin.isCircle = true
		pin.texture:SetTexCoord(0, 1, 0, 1)
	-- if distance > 100, set back to the node texture
	elseif (pin.isCircle or refresh) and dist_2 > db.trackDistance^2 then
		pin:SetHeight(12 * db.miniscale / minimapScale)
		pin:SetWidth(12 * db.miniscale / minimapScale)
		pin.texture:SetTexture(nodeTextures[pin.nodeType][pin.nodeID])
		pin.texture:SetVertexColor(1, 1, 1, 1)
		pin.texture:SetTexCoord(0, 1, 0, 1)
		pin.isCircle = false
	end

	-- support for rotating minimap - transpose coordinates for the circular movement
	if rotateMinimap then
		local dx, dy = xDist, yDist
		xDist = dx*cos - dy*sin
		yDist = dx*sin + dy*cos
	end

	-- place pin on the map
	local diffX, diffY, alpha = 0, 0, 1
	-- adapt delta position to the map radius
	diffX = xDist / mapRadius
	diffY = yDist / mapRadius

	-- different minimap shapes
	local isRound = true
	if ( minimapShape and not (xDist == 0 or yDist == 0) ) then
		isRound = (xDist < 0) and 1 or 3
		if ( yDist < 0 ) then
			isRound = minimapShape[isRound]
		else
			isRound = minimapShape[isRound + 1]
		end
	end

	-- calculate distance from the center of the map
	local dist
	if isRound then
		dist = (diffX*diffX + diffY*diffY) / 0.9^2
	else
		dist = max(diffX*diffX, diffY*diffY) / 0.9^2
	end
	-- if distance > 1, then adapt node position to slide on the border, and set the node alpha accordingly
	if dist > 1 then
		dist = dist^0.5
		diffX = diffX/dist
		diffY = diffY/dist
		alpha = 2 - dist
		if alpha < 0 then
			pin.keep = nil
		end
	end
	-- finally show and SetPoint the pin
	if db.nodeRange or alpha >= 1 then
		pin:Show()
		pin:ClearAllPoints()
		pin:SetPoint("CENTER", Minimap, "CENTER", diffX * minimapWidth, -diffY * minimapHeight)
		pin:SetAlpha(min(alpha,db.alpha))
	else
		pin:Hide()
	end
end
--[[
	Minimap zoom changed
]]
function Display:UpdateMiniMapZoom()
	local zoom = Minimap:GetZoom()
	if GetCVar("minimapZoom") == GetCVar("minimapInsideZoom") then
		Minimap:SetZoom(zoom < 2 and zoom + 1 or zoom - 1)
	end
	indoors = GetCVar("minimapZoom")+0 == Minimap:GetZoom() and "outdoor" or "indoor"
	Minimap:SetZoom(zoom)
end
function Display:MinimapZoom()
	self:UpdateMiniMapZoom()
	self:UpdateMiniMap()
end
--[[
	Minimap rotation changed
]]
function Display:ChangedVars(event,cvar,value)
	if cvar == "ROTATE_MINIMAP" then
		rotateMinimap = value == "1"
	end
	forceNextUpdate = true
end

function Display:UpdateMaps()
	clearpins(minimapPins)
	-- recheck zoom on map update, as it seems on load you dont get the map zoom changed event
	self:UpdateMiniMapZoom()
	-- Ask to update the visiblity for archaeology updates to blobs
	self:UpdateVisibility()
	self:UpdateMiniMap(true)
	self:UpdateWorldMap(true)
end

function Display:UpdateIconPositions()
	if not db.showMinimap or not Minimap:IsVisible() or  not zone then return end

	-- get the current map  zoom
	local zoom = Minimap:GetZoom()
	local diffZoom = zoom ~= lastZoom
	-- if the map zoom changed, run a full update sweep
	if diffZoom then
		self:UpdateMiniMap()
		return
	end

	-- we have no active minimap pins, just return early
	if minimapPinCount == 0 then return end

	-- get current player position
	local x, y = GatherMate.HBD:GetPlayerWorldPosition()

	-- for rotating minimap support
	local facing
	if rotateMinimap then
		facing = GetPlayerFacing()
	else
		facing = lastFacing
	end

	if not x or not y or (rotateMinimap and not facing) then
		self:UpdateMiniMap()
		return
	end

	local refresh

	local newScale = Minimap:GetScale()
	if minimapScale ~= newScale then
		minimapScale = newScale
		refresh = true
	end

	-- if the player moved, or changed the facing (rotating map) - update nodes
	if x ~= lastXY or y ~= lastYY or facing ~= lastFacing or refresh then
		-- update radius of the map
		mapRadius = self.minimapSize[indoors][zoom] / 2
		-- update upvalues for icon placement
		lastXY, lastYY = x, y
		lastFacing = facing

		if rotateMinimap then
			sin = math_sin(facing)
			cos = math_cos(facing)
		end

		-- iterate all nodes and check if they are still in range of our minimap display, or even still existing
		for k,v in pairs(minimapPins) do
			-- update the position of the node
			self:addMiniPin(v, refresh)
		end
	end
end

--[[
	Update the minimap
	we only care about nodes 1000 yards away
]]
function Display:UpdateMiniMap(force)
	if not db.showMinimap or not Minimap:IsVisible() then return end

	if not zone or zone == 0 then
		zone = nil
		return
	end

	-- get current player position
	local x, y = GatherMate.HBD:GetPlayerWorldPosition()

	-- get data from the API for calculations
	local zoom = Minimap:GetZoom()
	local diffZoom = zoom ~= lastZoom

	-- for rotating minimap support
	local facing
	if rotateMinimap then
		facing = GetPlayerFacing()
	else
		facing = lastFacing
	end

	--  disable all pins if no position is available
	if not x or not y or (rotateMinimap and not facing) then
		minimapPinCount = 0
		for k,v in pairs(minimapPins) do
			recyclePin(v)
			minimapPins[k] = nil
		end
		return
	end

	local newScale = Minimap:GetScale()
	if minimapScale ~= newScale then
		minimapScale = newScale
		force = true
	end

	-- if the player moved, the zoom changed, or changed the facing (rotating map) - update nodes
	if x ~= lastXY or y ~= lastYY or diffZoom or facing ~= lastFacing or force then
		-- set upvalues to new settings
		minimapShape = GetMinimapShape and self.minimapShapes[GetMinimapShape() or "ROUND"]
		mapRadius = self.minimapSize[indoors][zoom] / 2
		minimapWidth = Minimap:GetWidth() / 2
		minimapHeight = Minimap:GetHeight() / 2
		minimapStrata = Minimap:GetFrameStrata()
		minimapFrameLevel = Minimap:GetFrameLevel() + 5

		local x1, y1 = GatherMate.HBD:GetZoneCoordinatesFromWorld(x,y,zone)
		if not x1 then
			x1, y1 = GatherMate.HBD:GetZoneCoordinatesFromWorld(x,y,zone)
			if not x1 then return end
		end

		-- update upvalues for icon placement
		lastZoom = zoom
		lastFacing = facing
		lastXY, lastYY = x, y

		if rotateMinimap then
			sin = math_sin(facing)
			cos = math_cos(facing)
		end
		-- iterate the node databases and add the nodes
		for i,db_type in pairs(GatherMate.db_types) do
			if GatherMate.Visible[db_type] then
				for coord, nodeID in GatherMate:FindNearbyNode(zone, x1, y1, db_type, mapRadius*nodeRange) do
					local pin = self:getMiniPin(coord, nodeID, db_type, zone, (i * 1e14) + coord)
					pin.keep = true
					self:addMiniPin(pin, force)
				end
			end
		end

		minimapPinCount = 0
		for k,v in pairs(minimapPins) do
			if not v.keep then
				recyclePin(v)
				minimapPins[k] = nil
			else
				minimapPinCount = minimapPinCount + 1
				v.keep = nil
			end
		end
	end
end

---------------------------------------------------------
-- World Map Data Provider

Display.WorldMapDataProvider = CreateFromMixins(MapCanvasDataProviderMixin)

function Display.WorldMapDataProvider:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate("GatherMate2WorldMapPinTemplate")
	wipe(worldmapPins)
end

function Display.WorldMapDataProvider:RefreshAllData(fromOnShow)
	self:RemoveAllData()

	if not db.showWorldMap then return end

	-- update visibility for archaeology blobs
	Display:UpdateVisibility()

	local uiMapID = self:GetMap():GetMapID()
	if not uiMapID then return end

	if GatherMate.phasing[uiMapID] then uiMapID = GatherMate.phasing[uiMapID] end

	-- iterate databases and add nodes
	for i,db_type in pairs(GatherMate.db_types) do
		if GatherMate.Visible[db_type] then
			for coord, nodeID in GatherMate:GetNodesForZone(uiMapID, db_type) do
				local pin = self:GetMap():AcquirePin("GatherMate2WorldMapPinTemplate", coord,  nodeID, db_type, uiMapID)
				table.insert(worldmapPins, pin)
			end
		end
	end
end

--[[ Handy Notes WorldMap Pin ]]--
GatherMate2WorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin)

function GatherMate2WorldMapPinMixin:OnLoad()
	self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
	self:SetScalingLimits(1, 1.0, 1.2);
end

function GatherMate2WorldMapPinMixin:OnAcquired(coord, nodeID, nodeType, zone)
	local x,y = GatherMate:DecodeLoc(coord)
	self:SetPosition(x, y)

	self.coords = coord
	self.title = GatherMate:GetNameForNode(nodeType, nodeID)
	self.zone = zone
	self.nodeID = nodeID
	self.nodeType = nodeType
	self.worldmap = true

	self:SetHeight(12 * db.scale)
	self:SetWidth(12 * db.scale)
	self:SetAlpha(db.alpha)
	self.texture:SetTexture(nodeTextures[nodeType][nodeID])
	self.texture:SetTexCoord(0, 1, 0, 1)
	self.texture:SetVertexColor(1, 1, 1, 1)
	self:EnableMouse(db.worldMapIconsInteractive)
end

function GatherMate2WorldMapPinMixin:OnMouseEnter()
	return showPin(self)
end

function GatherMate2WorldMapPinMixin:OnMouseLeave()
	return hidePin(self)
end

function GatherMate2WorldMapPinMixin:OnClick(button)
	return pinClick(self, button)
end

function Display:UpdateWorldMap()
	self.WorldMapDataProvider:RefreshAllData()
end

--[[
	This function is for external addons to call to reparent all existing
	minimap icons to a new minimap frame.
]]
function Display:ReparentMinimapPins(parent)
	Minimap = parent
	GameTooltip:SetFrameLevel(parent:GetFrameLevel()+2) -- Because Chinchilla_Expander_Minimap is on TOOLTIP strata too
	for k, v in pairs(minimapPins) do
		v:SetParent(parent)
	end
	self:UpdateIconPositions()
end
