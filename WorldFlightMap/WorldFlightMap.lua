-- LoadAddOn("Blizzard_FlightMap")

local FlightmapCoordinates = { -- fairly accurate sizes for the different flight maps, these were calculated using very special maths and things
	[12] = { -- Kalimdor
		left = 10970,
		top = 12470,
		width = 24340,
	},
	
	[13] = { -- eastern kingdoms
		left = 12270,
		top = 12270,
		width = 28800,
	},
	
	[101] = { -- outland
		left = 10670,
		top = 6400,
		width = 12270,
	},
	
	[113] = { -- northrend
		left = 8533,
		top = 11730,
		width = 15466,
	},
	
	[424] = { -- pandaria
		left = 6770,
		top = 7461,
		width = 11892,
	},
	
	[572] = { -- Draenor
		left = 10120,
		top = 11630,
		bottom = -4771,
		width = 16396,
	},
	
	-- 13100.099609375 7262.1298828125 -5738.080078125 -5296.6899414063 18838.1796875 12558.819824219 993


	[619] = { -- Broken Isles, none of this makes any sense but let's do it anyway
		left = 13100.099609375,
		top = 7262.1298828125,
		right = -5738.080078125,
		bottom = -5296.6899414063,
		width = 18838.1796875,
		height = 12558.819824219,
		--id = 993

		--[[
		left = 6929,
		top = 4800, -- 9061 / 2,
		--right = 2665,
		--bottom = 533,
		width = 8528,
		height = 8528 / 2,
		--left = 13100.0996,
		--right = -5738.08,
		--top = 7262.129,
		--bottom = -5296.6899,
		--width = 18838.1796,
		--height = 12558.8189,
		--]]
	},
	
	[905] = { -- A.R.G.U.S. flight map doesn't actually line up with the continent map, so these don't mean anything
		left = 12266.700195313,
		top = 12266.700195313,
		right = -12266.700195313,
		bottom = -12266.700195313,
		width = 24533.400390626,
		height = 24533.400390626 / 2,
	},
}

--[[
	GetAllTaxiNodes() returns a table with every taxi node on the current continent
	{
		x = 0.5,
		y = 0.5,
		name = "Some Taxi Node",
		nodeID = 123,
		slotIndex = 29,
		type = 3,
	}
--]]

local TAXI_OPEN = false

local TaxiButtons = {}
TaxiFrame:UnregisterAllEvents() -- we should probably undo this if we're in an area that isn't supported somehow
UIParent:UnregisterEvent('TAXIMAP_OPENED')

local WorldMapButton = WorldMapFrame.ScrollContainer.Child


local f = CreateFrame('Frame', 'WorldFlightMapFrame', WorldMapButton)
f:SetAllPoints()
--C_Timer.After(1, function() f:SetFrameStrata('FULLSCREEN_DIALOG') end)
f:SetFrameStrata('FULLSCREEN_DIALOG')
f:SetFrameLevel(2000)

f:SetScript('OnEvent', function(self, event, ...) return self[event] and self[event](self, ...) end)

local WatchingWorldMap = false
local function WatchWorldMap()
	WatchingWorldMap = true
end

local function UnwatchWorldMap()
	WatchingWorldMap = false
end

local function TaxiNodeOnClick(self)
	TakeTaxiNode(self:GetID())
end

local lines = {}
local function CreateLine()
	local line = f:CreateLine(nil, "OVERLAY")
	line:SetVertexColor(0,0.8,1)
	line:SetNonBlocking(true)
	line:SetAtlas('_UI-Taxi-Line-horizontal')
	line:SetThickness(32)
	--line:SetBlendMode('ADD')
	tinsert(lines, line)
	return line
end

local function GetLine()
	for i,line in ipairs(lines) do
		if not line:IsShown() then return line end
	end
	return CreateLine()
end

--local function DrawLine(x1,y1,x2,y2,r,g,b,a)
local function DrawLine(button1, button2, r, g, b, a)
	if GetCurrentMapContinent() ~= 9 or (GetPlayerMapPosition('player') ~= 0) then
		local line = GetLine()
		--DrawRouteLine(line, "WorldMapButton", x1*1002, -y1*668, x2*1002, -y2*668, 32, 'TOPLEFT')
		--line:SetStartPoint('TOPLEFT', WorldMapButton, x1*1002, -y1*668)
		--line:SetEndPoint('TOPLEFT', WorldMapButton, x2*1002, -y2*668)
		line:SetStartPoint('CENTER', button1)
		line:SetEndPoint('CENTER', button2)
		line:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
		line:Show()
		return line
	end
end

--[[
local Transforms = {}
for _, transformID in ipairs(GetWorldMapTransforms()) do
	local mapID, displayMapID, _, _, bottom, top, right, left, y, x = GetWorldMapTransformInfo(transformID)
	tinsert(Transforms, {
		mapID = mapID, displayMapID = displayMapID,
		left = left, top = top,
		right = right, bottom = bottom,
		x = x, y = y,
	})
end

local function TransformCoordinates(mapID, left, top, right, bottom)
	for transformID, transformData in pairs(Transforms) do
		if transformData.mapID == mapID and transformData.left > left and right > transformData.right and transformData.top > top and bottom > transformData.bottom then
			mapID = transformData.displayMapID
			left, top = left + transformData.x, top + transformData.y
			right, bottom = right + transformData.x, bottom + transformData.y
			break
		end
	end
	
	--if MapContinents[mapID] then
		--mapID = MapContinents[mapID]
	--end
	
	return mapID, left, top, right, bottom
end
--]]

--[[
local function GetMapSize() -- Return dimensions and offset of current map
	local _, left, top, right, bottom = GetCurrentMapZone()
	local floorNum, dright, dbottom, dleft, dtop = GetCurrentMapDungeonLevel()
	if DungeonUsesTerrainMap() then floorNum = floorNum - 1 end
	if floorNum > 0 then left, top, right, bottom = dleft, dtop, dright, dbottom end
	
	if left and left ~= right then
		local width, height = left - right, top - bottom

		local mapID, _, displayMapID = GetAreaMapInfo(GetCurrentMapAreaID())
		if displayMapID ~= -1 then
			mapID, left, top, right, bottom = TransformCoordinates(mapID, left, top, right, bottom)
		end
		
		return left, top, right, bottom, width, height, format('%d.%d', GetCurrentMapAreaID(), floorNum)
	end
end
--]]

function GetMapSize(currentMapID) -- Return dimensions and offset of current map
	local currentMapID = currentMapID or WorldMapFrame:GetMapID()
	if not currentMapID then return end
	
	local mapID, topleft = C_Map.GetWorldPosFromMapPos(currentMapID, {x = 0, y = 0})
	local mapID, bottomright = C_Map.GetWorldPosFromMapPos(currentMapID, {x = 1, y = 1})
	if not mapID then return end
	
	local left, top = topleft.y, topleft.x
	local right, bottom = bottomright.y, bottomright.x
	local width, height = left - right, top - bottom
	-- return right, bottom, left, top, width, height, currentMapID
	return left, top, right, bottom, width, height, currentMapID
end

local function GetButtonFromSlot(slot)
	return TaxiButtons[slot]
end

taxiNodePositions = {}

-- Draw all flightpaths within one hop of current location
local function DrawOneHopLines()
	--local numSingleHops = 0
	
	--local left, top, right, bottom, width, height = GetMapSize()
	for i = 1, #taxiNodePositions do
		local node = taxiNodePositions[i]
		
		if GetNumRoutes(i) == 1 and node.type == 'REACHABLE' then -- node.type ~= 'NONE' then 
			local button1 = GetButtonFromSlot(TaxiGetNodeSlot(i, 1, true))
			local button2 = GetButtonFromSlot(TaxiGetNodeSlot(i, 1, false))
			if button1 and button2 and button1:IsShown() and button2:IsShown() then
				DrawLine(button1, button2)
			end
		end
	end
	-- It's possible to fly to a node without knowing intermediate nodes any more
	-- which means if you don't know any flight points you can reach directly, you can still
	-- fly to nodes that are farther out as long as you know them
	--[[
	if ( numSingleHops == 0 ) then
		UIErrorsFrame:AddMessage(ERR_TAXINOPATHS, 1.0, 0.1, 0.1, 1.0)
		CloseTaxiMap()
	end
	--]]
end



local GetButton

local function TaxiNodeOnButtonEnter(button) 
	local index = button:GetID()
	WorldMapTooltip:SetOwner(button, "ANCHOR_RIGHT")
	WorldMapTooltip:AddLine(TaxiNodeName(index), nil, nil, nil, true)
	
	SetCursor('TAXI_CURSOR')
	-- Setup variables
	local numRoutes = GetNumRoutes(index)
	local type = TaxiNodeGetType(index)
	
	if type == 'REACHABLE' or type == 'CURRENT' then
		for i = 1, #lines do
			lines[i]:Hide()
		end
		
		for slot, b in pairs(TaxiButtons) do -- hide nodes we can't fly to
			if TaxiNodeGetType(b:GetID()) == 'DISTANT' then
				b:Hide()
			end
		end
		
		--button:SetHighlightTexture([[Interface\TaxiFrame\UI-Taxi-Icon-Highlight]])
	else
		--button:SetHighlightTexture(nil)
	end
	
	if ( type == "REACHABLE" ) then
		local cost = TaxiNodeCost(button:GetID())
		if cost ~= 0 then
			SetTooltipMoney(WorldMapTooltip, cost)
		end
		
		for i = 1, numRoutes do
			local slot = TaxiGetNodeSlot(index, i, true)
			local button1 = GetButtonFromSlot(slot)
			
			if TaxiNodeGetType(slot) == 'DISTANT' then
				button1:Show()
			end
			
			slot = TaxiGetNodeSlot(index, i, false)
			local button2 = GetButtonFromSlot(slot)
			DrawLine(button1, button2)
			
			if TaxiNodeGetType(slot) == 'DISTANT' then
				button2:Show()
			end
		end
	elseif ( type == "CURRENT" ) then
		WorldMapTooltip:AddLine(TAXINODEYOUAREHERE, 1.0, 1.0, 1.0, true)
		DrawOneHopLines()
	end

	WorldMapTooltip:Show()
end


local function BounceAnimation(self) -- SetLooping('BOUNCE') is producing broken animations, so we're just simulating what it's supposed to do
	local tx, parent, bounce = self.tx, self.parent, self.bounce
	tx:ClearAllPoints()
	if self.up then
		tx:SetPoint('BOTTOM', parent, 'TOP', 0, 10)
		bounce:SetSmoothing('OUT')
	else
		tx:SetPoint('BOTTOM', parent, 'TOP')
		bounce:SetSmoothing('IN')
	end
	bounce:SetOffset(0, self.up and -10 or 10)
	self.up = not self.up
	self:Play()
end
--group:SetLooping('REPEAT')
--group:Play()

local function CreateButton(i)
	local button = CreateFrame("Button", nil, f)
	button:SetSize(16, 16)
	button:SetHighlightTexture([[Interface\TaxiFrame\UI-Taxi-Icon-Highlight]])
	button:SetNormalTexture('interface/icons/inv_mushroom_11')
	texture = button:GetNormalTexture()
	texture:ClearAllPoints()
	texture:SetPoint('CENTER')
	texture:SetSize(16, 16)
	--button.Texture = texture
	
	local highlight = button:GetHighlightTexture()
	highlight:ClearAllPoints()
	highlight:SetPoint('CENTER')
	highlight:SetSize(32, 32)
	--button.HighlightTexture = highlight
	
	local i = i or (#TaxiButtons + 1)
	button:SetScript('OnClick', TaxiNodeOnClick)
	button:SetID(i)
	TaxiButtons[i] = button
	
	button:SetScript('OnEnter', TaxiNodeOnButtonEnter)
	button:SetScript('OnLeave', function() WorldMapTooltip:Hide() ResetCursor() end)
	
	local tx = button:CreateTexture(nil, 'OVERLAY')
	tx:SetPoint('BOTTOM', button, 'TOP')
	tx:SetSize(32, 32)
	tx:SetTexture('interface/minimap/minimap-deadarrow')
	tx:SetTexCoord(0, 1, 1, 0)
	
	local group = tx:CreateAnimationGroup()
	group.tx = tx
	
	local bounce = group:CreateAnimation('Translation')
	bounce:SetOffset(0, 10)
	bounce:SetDuration(0.5)
	bounce:SetSmoothing('IN')
	group.bounce = bounce
	
	group.up = true
	
	group:SetScript('OnFinished', BounceAnimation)
	group.parent = button
	button.arrow = tx
	group:Play()
	return button
end

local function GetButton(i)
	return TaxiButtons[i] or CreateButton(i)
end

--local ContinentMaps = {GetMapContinents()}
--for i = #ContinentMaps, 2, -2 do tremove(ContinentMaps, i) end

--[[
local NodeTypeToName = {
	[LE_FLIGHT_PATH_TYPE_CURRENT] = 'CURRENT',
	[LE_FLIGHT_PATH_TYPE_REACHABLE] = 'REACHABLE',
	[LE_FLIGHT_PATH_TYPE_UNREACHABLE] = 'UNREACHABLE',
	-- [??] = 'DISTANT',
}
--]]

function GetCurrentMapContinent(mapID)
	-- fake news
	local mapID = mapID or WorldMapFrame:GetMapID()
	if mapID then
		local continent = MapUtil.GetMapParentInfo(mapID, Enum.UIMapType.Continent)
		if continent then
			return continent.mapID
		end
	end
end

local CurrentContinent, CurrentMap = -1
function f:WORLD_MAP_UPDATE()
	if not TAXI_OPEN then return UnwatchWorldMap() end
	local continentID = GetCurrentMapContinent() == CurrentContinent and CurrentContinent or -1
	local continent = FlightmapCoordinates[continentID]
	local left, top, right, bottom, width, height, mapID = GetMapSize()
	
	if mapID ~= CurrentMap or not mapID then
		for i = 1, #lines do -- only hide lines if the map has changed to a new map when this event fired
			lines[i]:Hide()
		end
		CurrentMap = mapID
	end
	
	if not continent then -- clear any buttons
		for i = 1, #TaxiButtons do
			TaxiButtons[i]:Hide()
		end
		return
	end
	
	local showArrows = false
	local currentMapID = WorldMapFrame:GetMapID()
	local mapStuff = C_Map.GetMapInfo(currentMapID)
	if mapStuff then
		showArrows = mapStuff.mapType == 3
	end
	
	local instanceID = select(8, GetInstanceInfo())
	
	--local showArrows = ContinentMaps[continentID] and GetCurrentMapAreaID() ~= ContinentMaps[continentID] -- only show arrows on zone maps
	
	local j = 1
	if continentID == 905 then
		--if GetCurrentMapZone() ~= 0 then
		if mapStuff.mapType == 3 then
			for i = 1, #taxiNodePositions do
				local node = taxiNodePositions[i]
				--if node.type ~= 'NONE' then
				if node.type ~= 'NONE' then
					--local mx, my = (left - node.x) / width, (top - node.y) / height
					
					local button = GetButton(j)
					button:SetID(i)
					button:ClearAllPoints()
					button:Hide()
					--C_TaxiMap.GetTaxiNodesForMap
					local taxiNodes = C_TaxiMap.GetTaxiNodesForMap(mapID)
					--for l = 1, GetNumMapLandmarks() do
					for _, landmark in pairs(taxiNodes) do
						-- landmark.nodeID = 1976
						-- local landmarkType, name, description, textureIndex, x, y, mapLinkID, inBattleMap, graveyardID, areaID, poiID, isObjectIcon, atlasName, displayAsBanner, mapFloor, textureKitPrefix = C_WorldMap.GetMapLandmarkInfo(l)
						if landmark.name == node.name then -- todo: use landmark.nodeID instead
							button:SetPoint('CENTER', f, 'TOPLEFT', landmark.position.x * 1002, landmark.position.y * -668)
							button:SetNormalTexture(TaxiButtonTypes[node.type].file)
							
							button:SetSize(24, 24)
							local texture = button:GetNormalTexture()
							texture:SetSize(34, 28)
							
							local highlightTexture = button:GetHighlightTexture()
							--highlightTexture:SetAtlas("FlightMaster_Argus-TaxiNode_Neutral", true)
							highlightTexture:SetSize(34, 28)
							--highlightTexture:SetTexture('interface/icons/inv_mushroom_11')
							
							--[[
							if (not atlasIcon) then
								local x1, x2, y1, y2;
								if (isObjectIcon) then
									x1, x2, y1, y2 = GetObjectIconTextureCoords(textureIndex);
								else
									x1, x2, y1, y2 = GetPOITextureCoords(textureIndex);
								end
								button.Texture:SetTexCoord(x1, x2, y1, y2);
								button.HighlightTexture:SetTexCoord(x1, x2, y1, y2);
							else
								button.Texture:SetTexCoord(0, 1, 0, 1);
								button.HighlightTexture:SetTexCoord(0, 1, 0, 1);
							end
							--]]
							
							
							--button:SetID(node.slotIndex)

							if node.type == 'REACHABLE' then
								button.arrow:SetShown(showArrows)
							else
								button.arrow:Hide()
							end
							
							if node.type == 'CURRENT' then
								--texture:SetVertexColor(0, 0.8, 0)
								--highlightTexture:SetVertexColor(0, 0.8, 0)
								texture:SetAtlas("FlightMaster_Argus-Taxi_Frame_Green")
								highlightTexture:SetAtlas("FlightMaster_Argus-Taxi_Frame_Green")
							else
								texture:SetAtlas("FlightMaster_Argus-Taxi_Frame_Gray")
								highlightTexture:SetAtlas("FlightMaster_Argus-Taxi_Frame_Gray")
								--texture:SetVertexColor(1, 1, 1)
								--highlightTexture:SetVertexColor(1, 1, 1)
							end
							
							if node.type == 'REACHABLE' or node.type == 'CURRENT' then
								button:Show()
							else
								button:Hide()
							end
							
							
							break
						end
					end
					j = j + 1
				end
			end
		end
	elseif mapID then
		for i = 1, #taxiNodePositions do
			local node = taxiNodePositions[i]
			--if node.type ~= 'NONE' then
			if node.type ~= 'NONE' then
				local mx, my = (left - node.x) / width, (top - node.y) / height
				local button = GetButton(j)
				button:ClearAllPoints()
				button:SetPoint('CENTER', f, 'TOPLEFT', mx * 1002, my * -668)
				-- HBDPins:AddWorldMapIconWorld(self, button, instanceID, node.x, node.y, 2)

				button:SetNormalTexture(TaxiButtonTypes[node.type].file)
				button:GetNormalTexture():SetSize(16, 16)
				--button.Texture:SetVertexColor(1, 1, 1)
				--button.HighlightTexture:SetVertexColor(1, 1, 1)
				button:GetHighlightTexture():SetSize(32, 32)
				button:SetID(i)
				--button:SetID(node.slotIndex)

				if node.type == 'REACHABLE' then
					button.arrow:SetShown(showArrows)
				else
					button.arrow:Hide()
				end
				
				if node.type == 'REACHABLE' or node.type == 'CURRENT' then
					button:SetHighlightTexture([[Interface\TaxiFrame\UI-Taxi-Icon-Highlight]])
					button:Show()
				else
					--button:SetHighlightTexture(nil)
					button:Hide()
				end
				
				
				j = j + 1
			end
		end
	end

	for i = j, #TaxiButtons do -- hide extra buttons
		TaxiButtons[i]:Hide()
	end
	
	if not showArrows then
		DrawOneHopLines()
	end
end

-- WORLD_MAP_UPDATE
hooksecurefunc(WorldMapFrame, 'OnMapChanged', function()
	if WatchingWorldMap then
		f:WORLD_MAP_UPDATE()
	end
end)

local function ZoomOutForNodes() -- Zoom map out until we can see at least one connecting node
	local left, top, right, bottom, width, height, mapID = GetMapSize()
	local nodeCount = 0
	if mapID then
		for i = 1, #taxiNodePositions do
			local node = taxiNodePositions[i]
			if node.type == 'REACHABLE' then -- node.type ~= 'NONE' and node.type ~= 'CURRENT' then
				if node.x < left and node.x > right and node.y > bottom and node.y < top then
					nodeCount = nodeCount + 1
				end
			end
		end
		local mapData = C_Map.GetMapInfo(mapID)
		if nodeCount < 1 and mapData and mapData.parentMapID and mapData.mapType > 2 then
			WorldMapFrame:SetMapID(mapData.parentMapID)
			ZoomOutForNodes()
		end
	end
	
	--if nodeCount < 1 and IsZoomOutAvailable() and ZoomOut() then
	
end

function f:TAXIMAP_OPENED()
	TAXI_OPEN = true
	if not WorldMapFrame:IsShown() then
		if InCombatLockdown() then -- Prevent the world map from opening in combat due to its action button
			print(ERR_TAXIPLAYERBUSY)
			CloseTaxiMap()
			TAXI_OPEN = false
			return
		end
		ToggleWorldMap()
		--SetMapToCurrentZone()
	-- elseif GetTaxiMapID() ~= select(2, GetCurrentMapContinent()) then
		-- map is open to a different continent, set it to current zone
		--SetMapToCurrentZone()
	end
	local continentID = GetCurrentMapContinent()
	local continent = FlightmapCoordinates[continentID]
	if continentID == 905 then -- A.R.G.U.S.
		CurrentContinent = continentID
		
		wipe(taxiNodePositions)
		for i = 1, NumTaxiNodes() do
			local type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			local x, y = TaxiNodePosition(i)
			taxiNodePositions[i] = {type = type, name = name, x = x, y = y}
		end
		
		--self:RegisterEvent('WORLD_MAP_UPDATE')
		WatchWorldMap()
		--SetMapZoom(continentID, (GetCurrentMapZone()))
		self:WORLD_MAP_UPDATE()
		local uiMapID = WorldMapFrame:GetMapID()
		if uiMapID then
			local mapInfo = C_Map.GetMapInfo(uiMapID)
			if mapInfo and mapInfo.mapType == 5 then
				-- zoom out if we're at the vindicaar
				WorldMapFrame:SetMapID(mapInfo.parentMapID)
			end
		end
		f:Show()
	elseif continent then
		CurrentContinent = continentID
		
		--[[
		local nodes = GetAllTaxiNodes(taxiNodePositions)
		
		for i = 1, #nodes do
			local node = nodes[i]
			node.type = TaxiNodeGetType(node.slotIndex)
			local x, y = TaxiNodePosition(node.slotIndex)
			if continent.height then
				node.x, node.y = continent.left - continent.width * x, (continent.top - continent.height) + continent.height * y
			else
				node.x, node.y = continent.left - continent.width * x, (continent.top - continent.width) + continent.width * y
			end
		end
		--]]
		
		wipe(taxiNodePositions)
		
		local left, top, right, bottom, width, height = GetMapSize(GetTaxiMapID())
		for i = 1, NumTaxiNodes() do
			local type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			local x, y = TaxiNodePosition(i)
			--local wx, wy = continent.left - continent.width * x, (continent.top - continent.width) + continent.width * y
			
			local wx, wy = left - width * x, top - height * y
			--[[
			if height then
				--wx, wy = continent.left - continent.width * x, (continent.top - continent.height) + continent.height * y
				wx, wy = left - width * x, top - height * y
			else
				wx, wy = left - width * x, top - width * y
			end
			--]]
			
			taxiNodePositions[i] = {type = type, name = name, x = wx, y = wy}
		end
		
		--self:RegisterEvent('WORLD_MAP_UPDATE')
		WatchWorldMap()
		--SetMapZoom(continentID)
		self:WORLD_MAP_UPDATE()
		ZoomOutForNodes() -- only zoom out if we don't have other flight points on the current map?
		
		f:Show()
	end
end
f:RegisterEvent('TAXIMAP_OPENED')

function f:TAXIMAP_CLOSED()
	TAXI_OPEN = false
	CurrentContinent = -1
	--self:UnregisterEvent('WORLD_MAP_UPDATE')
	UnwatchWorldMap()
	f:Hide()
	if WorldMapFrame:IsShown() and not InCombatLockdown() then
		ToggleWorldMap()
	end
end
f:RegisterEvent('TAXIMAP_CLOSED')

local timer = CreateFrame('Frame')
timer:Hide()

local TimeSince = 0
timer:SetScript('OnUpdate', function(self, elapsed) -- delayed close for the map frame
	TimeSince = TimeSince + elapsed
	if TimeSince >= 0.2 then
		self:Hide()
		if not WorldMapFrame:IsVisible() then
			CloseTaxiMap()
		end
	end
end)

WorldMapFrame:HookScript('OnHide', function() -- stop interaction with the flight master after a small timeout
	-- seems to trigger when switching between windowed and fullscreen mode
	TimeSince = 0
	timer:Show()
end)

--[[
["Krokul Hovel, Krokuun"] = {0.430222, 0.540183},
["Vindicaar, Krokuun"] = {0.440069, 0.520433},
["Shattered Fields, Krokuun"] = {0.407239, 0.544068},
["Destiny Point, Krokuun"] = {0.44113, 0.558593},
["Vindicaar, Mac'Aree"] = {0.0979987, 0.692741},
["Conservatory of the Arcane, Mac'Aree"] = {0.113026, 0.734981},
["Shadowguard Incursion, Mac'Aree"] = {0.0694441, 0.726062},
["Triumvirate's End, Mac'Aree"] = {0.0995879, 0.703123},
["[Hidden] Argus Ground Points Hub (Ground TP out to here, TP to Vindicaar from here)"] = {0.442798, 0.514645},
["[Hidden] Argus Vindicaar Ground Hub (Vindicaar TP out to here, TP to ground from here)"] = {0.443032, 0.51422},
["[Hidden] Argus Vindicaar No Load Hub (Vindicaar No Load transition goes through here)"] = {0.44324, 0.513804},
["Hope's Landing, Antoran Wastes"] = {0.141369, 0.380375},
["Prophet's Reflection, Mac'Aree"] = {0.0876438, 0.757092},
["The Veiled Den, Antoran Wastes"] = {0.138088, 0.403517},
["Vindicaar, Antoran Wastes"] = {0.145385, 0.392551},
["City Center, Mac'Aree"] = {0.0918503, 0.720801},	
--]]
--[[
function f:PLAYER_ENTERING_WORLD() -- Argus continent map doesn't line up with the real position of its zones, so we can't scale it properly
	SetMapToCurrentZone() -- bad, but probably not an issue
	local continentID = GetCurrentMapContinent()
	if FlightmapCoordinates[continentID] then -- we have data, so override default behavior
		TaxiFrame:UnregisterEvent('TAXIMAP_CLOSED')
		UIParent:UnregisterEvent('TAXIMAP_OPENED')
		f:RegisterEvent('TAXIMAP_OPENED')
	else -- no data, restore normal functionality
		TaxiFrame:RegisterEvent('TAXIMAP_CLOSED')
		UIParent:RegisterEvent('TAXIMAP_OPENED')
		f:UnregisterEvent('TAXIMAP_OPENED')
	end
end
f:RegisterEvent('PLAYER_ENTERING_WORLD')
--]]
do return end
-----------------
-- Replace World Map zoom function (WorldMapScrollFrame_OnMouseWheel)
local ScrollFrame = CreateFrame('ScrollFrame', nil, WorldMapScrollFrame:GetParent())
ScrollFrame:SetAllPoints(WorldMapScrollFrame)
ScrollFrame:SetFrameLevel(WorldMapScrollFrame:GetFrameLevel() - 1)

local ContinentFrame = CreateFrame('frame', nil, ScrollFrame)
ContinentFrame:SetSize(1002, 668)
ScrollFrame:SetScrollChild(ContinentFrame)

local tx = ContinentFrame:CreateTexture()
tx:SetAllPoints()
tx:SetTexture('interface/icons/inv_mushroom_11')

local MIN_ZOOM = 0.695; -- 0.695 WORLDMAP_SETTINGS.size
local MAX_ZOOM = 3;
WorldMapScrollFrame:SetScript('OnMouseWheel', function(self, delta)
  local scrollFrame = WorldMapScrollFrame;
  local oldScrollH = scrollFrame:GetHorizontalScroll();
  local oldScrollV = scrollFrame:GetVerticalScroll();
 
  -- get the mouse position on the frame, with 0,0 at top left
  local cursorX, cursorY = GetCursorPosition();
  local relativeFrame;
  if ( WorldMapFrame_InWindowedMode() ) then
    relativeFrame = UIParent;
  else
    relativeFrame = WorldMapFrame;
  end
  local frameX = cursorX / relativeFrame:GetScale() - scrollFrame:GetLeft();
  local frameY = scrollFrame:GetTop() - cursorY / relativeFrame:GetScale();
 
  local oldScale = WorldMapDetailFrame:GetScale();
  local newScale = oldScale + delta * 0.3;
  newScale = max(WORLDMAP_SETTINGS.size, newScale);
  newScale = min(MAX_ZOOM, newScale);
  WorldMapDetailFrame:SetScale(newScale);
  QUEST_POI_FRAME_WIDTH = WorldMapDetailFrame:GetWidth() * newScale;
  QUEST_POI_FRAME_HEIGHT = WorldMapDetailFrame:GetHeight() * newScale;
 
  scrollFrame.maxX = QUEST_POI_FRAME_WIDTH - 1002 * WORLDMAP_SETTINGS.size;
  scrollFrame.maxY = QUEST_POI_FRAME_HEIGHT - 668 * WORLDMAP_SETTINGS.size;
  scrollFrame.zoomedIn = abs(WorldMapDetailFrame:GetScale() - WORLDMAP_SETTINGS.size) > 0.05;
  scrollFrame.continent = GetCurrentMapContinent();
  scrollFrame.mapID = GetCurrentMapAreaID();
 
  -- figure out new scroll values
  local scaleChange = newScale / oldScale;
  local newScrollH = scaleChange * ( frameX + oldScrollH ) - frameX;
  local newScrollV = scaleChange * ( frameY + oldScrollV ) - frameY;
  -- clamp scroll values
  newScrollH = min(newScrollH, scrollFrame.maxX);
  newScrollH = max(0, newScrollH);
  newScrollV = min(newScrollV, scrollFrame.maxY);
  newScrollV = max(0, newScrollV);
  -- set scroll values
  scrollFrame:SetHorizontalScroll(newScrollH);
  scrollFrame:SetVerticalScroll(newScrollV);
 
  WorldMapFrame_Update();
  WorldMapScrollFrame_ReanchorQuestPOIs();
  WorldMapFrame_ResetPOIHitTranslations();
  WorldMapBlobFrame_DelayedUpdateBlobs();
end)
