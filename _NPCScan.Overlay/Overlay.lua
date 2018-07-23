-------------------------------------------------------------------------------
-- Localized Lua globals.
-------------------------------------------------------------------------------
local _G = getfenv(0)

-- Functions
local next = _G.next
local pairs = _G.pairs
local tonumber = _G.tonumber
local tostring = _G.tostring
local type = _G.type

-- Libraries
local math = _G.math
local table = _G.table

-------------------------------------------------------------------------------
-- AddOn namespace.
-------------------------------------------------------------------------------
_NPCScan = _NPCScan or {}
local _NPCScan = _NPCScan
local FOLDER_NAME, private = ...
local L = private.L
_G._NPCScan.Overlay = private

local LibQTip = LibStub('LibQTip-1.0')
private.LDBI = LibStub("LibDBIcon-1.0")

private.Version = _G.GetAddOnMetadata(FOLDER_NAME, "Version"):match("^([%d.]+)")

_NPCScanOverlayOptions = {}

local OptionsDefault = {
	Version = private.Version,
	Modules = {},
	ModulesAlpha = {},
	ModulesExtra = {},
	MiniMapIcon = {
		hide = true
		},
	ShowAll = false,
	ShowKey = true,
	LockSwap = false,
	KeyAutoHide = false,
	KeyAutoHideAlpha = .25,
	KeyMaxSize = .75,
	MouseoverText = false,
	KeyFont = private.DEFAULT_FONT_NAME,
	KeyFontSize = private.DEFAULT_FONT_SIZE,
}

local RING_CLEAR_DELAY = 30

private.TextureTable = {}
private.CurrentTexture = nil
private.CurrentTextureMob = nil

private.NPCsEnabled = {}
private.NPCCounts = {} -- Number of enabled NPCs that use this NPC path
private.NPCMaps = {} -- [ NpcID ] = { [ MapID1 ] = (true|{FoundX,FoundY}) ... }
private.DetectionRadius = 100 -- yards

local TexturesUnused = _G.CreateFrame("Frame")

private.Events = _G.LibStub("AceEvent-3.0"):Embed({})
local MESSAGE_REGISTER = "NpcOverlay_RegisterScanner"
local MESSAGE_ADD = "NpcOverlay_Add"
local MESSAGE_REMOVE = "NpcOverlay_Remove"
local MESSAGE_FOUND = "NpcOverlay_Found"

-- Prepares an unused texture on the given frame.
-- @param Layer Draw layer for texture.
-- @param ... Color and optional alpha to set texture to.
local TextureCount = 0
function private:TextureCreate(drawLayer, R, G, B, A)
	TextureCount = TextureCount + 1

	local texture = #TexturesUnused > 0 and TexturesUnused[#TexturesUnused]
	if texture then
		TexturesUnused[#TexturesUnused] = nil
		texture.id = nil
		texture:SetParent(self)
		texture:SetDrawLayer(drawLayer)
		texture:ClearAllPoints()
		texture:SetAlpha(1)
	else
		texture = self:CreateTexture("ScannerOverlayMobTexture" .. TextureCount, drawLayer)
	end

	texture:SetVertexColor(R, G, B, A or 1)
	texture:SetBlendMode("BLEND")
	texture.id = private.CurrentTextureMob

	self[#self + 1] = texture
	return texture
end


do
	local ApplyTransform
	do
		-- Bounds to prevent "TexCoord out of range" errors
		local function NormalizeBounds(coordinate)
			if coordinate < -1e4 then
				coordinate = -1e4
			elseif coordinate > 1e4 then
				coordinate = 1e4
			end
			return coordinate
		end


		-- Applies an affine transformation to Texture.
		-- @param texture Texture to set TexCoords for.
		-- @param ... First 6 elements of transformation matrix.
		function ApplyTransform(texture, A, B, C, D, E, F)
			local det = A * E - B * D

			if det == 0 then
				return texture:Hide() -- Scaled infinitely small
			end
			local AF = A * F
			local BF = B * F
			local CD = C * D
			local CE = C * E

			local ULx = NormalizeBounds((BF - CE) / det)
			local ULy = NormalizeBounds((CD - AF) / det)

			local LLx = NormalizeBounds((BF - CE - B) / det)
			local LLy = NormalizeBounds((CD - AF + A) / det)

			local URx = NormalizeBounds((BF - CE + E) / det)
			local URy = NormalizeBounds((CD - AF - D) / det)

			local LRx = NormalizeBounds((BF - CE + E - B) / det)
			local LRy = NormalizeBounds((CD - AF - D + A) / det)

			return texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy)
		end
	end


	-- Removes one-pixel transparent border
	local BORDER_OFFSET = -1 / 512
	local BORDER_SCALE = 512 / 510
	local TRIANGLE_PATH = [[Interface\AddOns\]] .. FOLDER_NAME .. [[\Skin\Triangle]]

	-- Draw a triangle texture with vertices at relative coords.  (0,0) is top-left, (1,1) is bottom-right.
	function private:TextureAdd(layer, r, g, b, aX, aY, bX, bY, cX, cY)
		local abX = aX - bX
		local abY = aY - bY
		local bcX = bX - cX
		local bcY = bY - cY
		local scaleX = (bcX * bcX + bcY * bcY) ^ 0.5

		if scaleX == 0 then
			return -- Points B and C are the same
		end
		local scaleY = (abX * bcY - abY * bcX) / scaleX

		if scaleY == 0 then
			return -- Points are co-linear
		end
		local shearFactor = -(abX * bcX + abY * bcY) / (scaleX * scaleX)
		local sin = bcY / scaleX
		local cos = -bcX / scaleX

		-- Note: The texture region is made as small as possible to improve framerates.
		local minX = math.min(aX, bX, cX)
		local minY = math.min(aY, bY, cY)
		local windowX = math.max(aX, bX, cX) - minX
		local windowY = math.max(aY, bY, cY) - minY

		-- Get a texture
		local texture = private.TextureCreate(self, layer, r, g, b)
		texture:SetTexture(TRIANGLE_PATH)

		local width, height = self:GetSize()
		texture:SetPoint("TOPLEFT", minX * width, -minY * height)
		texture:SetSize(windowX * width, windowY * height)

		--[[ Transform parallelogram so its corners lie on the tri's points:
		local Matrix = Identity
		-- Remove transparent border
		Matrix = Matrix:Scale( BorderScale, BorderScale )
		Matrix = Matrix:Translate( BorderOffset, BorderOffset )

		Matrix = Matrix:Shear( ShearFactor ) -- Shear the image so its bottom left corner aligns with point A
		Matrix = Matrix:Scale( ScaleX, ScaleY ) -- Scale X by the length of line BC, and Y by the length of the perpendicular line from BC to point A
		Matrix = Matrix:Rotate( Sin, Cos ) -- Align the top of the triangle with line BC.

		Matrix = Matrix:Translate( Bx - MinX, By - MinY ) -- Move origin to overlap point B
		Matrix = Matrix:Scale( 1 / WindowX, 1 / WindowY ) -- Adjust for change in texture size

		ApplyTransform( unpack( Matrix, 1, 6 ) )
		]]

		-- Common operations
		local cosScaleX = cos * scaleX
		local cosScaleY = cos * scaleY
		local sinScaleX = -sin * scaleX
		local sinScaleY = sin * scaleY

		windowX = BORDER_SCALE / windowX
		windowY = BORDER_SCALE / windowY

		ApplyTransform(texture,
			windowX * cosScaleX,
			windowX * (sinScaleY + cosScaleX * shearFactor),
			windowX * ((sinScaleY + cosScaleX * (1 + shearFactor)) * BORDER_OFFSET + bX - minX) / BORDER_SCALE,
			windowY * sinScaleX,
			windowY * (cosScaleY + sinScaleX * shearFactor),
			windowY * ((cosScaleY + sinScaleX * (1 + shearFactor)) * BORDER_OFFSET + bY - minY) / BORDER_SCALE)

		return texture
	end
end


-- Recycles all textures added to a frame using TextureCreate.
function private:TextureRemoveAll()
	for index = #self, 1, -1 do
		local texture = self[index]
		texture:SetAlpha(0)

		self[index] = nil
		TexturesUnused[#TexturesUnused + 1] = texture
	end
end


do
	local DWORD_LENGTH = 4
	-- @return DWORD read from binary Data at Offset.
	local function ReadDWord(Data, Offset)
		local B1, B2, B3, B4 = Data:byte(Offset + 1, Offset + DWORD_LENGTH)
		return B1 * 2 ^ 24 + B2 * 2 ^ 16 + B3 * 2 ^ 8 + B4 -- Big-endian
	end


	-- @return Offset of points, lines, and triangles within PathData.
	function private.GetPathPrimitiveOffsets(PathData)
		return ReadDWord(PathData, 0) + 1, -- Points
		ReadDWord(PathData, DWORD_LENGTH) + 1, -- Lines
		ReadDWord(PathData, DWORD_LENGTH * 2) + 1 -- Triangles
	end
end


do
	local COORD_MAX = 2 ^ 16 - 1
	local BYTES_PER_TRIANGLE = 2 * 2 * 3
	local Ax1, Ax2, Ay1, Ay2, Bx1, Bx2, By1, By2, Cx1, Cx2, Cy1, Cy2

	-- Draws the given NPC's path onto a frame.
	-- @param PathData Binary path data string.
	function private:DrawPath(pathData, layer, r, g, b)
		local pointsOffset, linesOffset, trianglesOffset = private.GetPathPrimitiveOffsets(pathData)

		for index = trianglesOffset, #pathData, BYTES_PER_TRIANGLE do
			Ax1, Ax2, Ay1, Ay2, Bx1, Bx2, By1, By2, Cx1, Cx2, Cy1, Cy2 = pathData:byte(index, index + BYTES_PER_TRIANGLE - 1)

			local texture = private.TextureAdd(self, layer, r, g, b,
				(Ax1 * 256 + Ax2) / COORD_MAX, 1 - (Ay1 * 256 + Ay2) / COORD_MAX,
				(Bx1 * 256 + Bx2) / COORD_MAX, 1 - (By1 * 256 + By2) / COORD_MAX,
				(Cx1 * 256 + Cx2) / COORD_MAX, 1 - (Cy1 * 256 + Cy2) / COORD_MAX)

			local textureName = texture:GetName()
			if private.TextureTable[private.CurrentTextureMob] then
				private.TextureTable[private.CurrentTextureMob][textureName] = true
			else
				private.TextureTable[private.CurrentTextureMob] = {
					[textureName] = true
				}
			end
		end
	end
end


do
	local TEXTURE_INDEX_MAX = 3
	local GLOW_WIDTH = 1.25
	local RING_WIDTH = 1.14 -- Ratio of texture width to ring width

	local textureIndex = 0

	local FoundTextures = {}

	-- Adds a found NPC's range circle onto a frame.
	-- @param X..Y Relative coordinate to center circle on.  (0,0) is top-left, (1,1) is bottom-right.
	-- @param RadiusX Radius relative to the frame's width.  That is, 0.5 for a circle as wide as the frame.
	function private:DrawFound(x, y, radiusX, layer, r, g, b)
		local textureIndex = self.textureIndex or 0

		textureIndex = textureIndex + 1

		if textureIndex > TEXTURE_INDEX_MAX then
			textureIndex = 1
		end

		local oldTexture = FoundTextures[textureIndex]
		if oldTexture then
			oldTexture.ring:Hide()
			oldTexture.glow:Hide()
		end

		local width, height = self:GetSize()
		local Size = radiusX * 2 * width
		x = x * width
		y = -y * height

		local foundRing = private.TextureCreate(self, layer, r, g, b)
		foundRing:SetTexture([[Interface\Minimap\Ping\ping2]])
		foundRing:SetTexCoord(0, 1, 0, 1)
		foundRing:SetBlendMode("ADD")
		foundRing:SetPoint("CENTER", self, "TOPLEFT", x, y)
		foundRing:SetSize(Size * RING_WIDTH, Size * RING_WIDTH)
		foundRing:Show()

		local foundGlow = private.TextureCreate(self, layer, r, g, b, 0.5)
		foundGlow:SetTexture([[Textures\SunCenter]])
		foundGlow:SetTexCoord(0, 1, 0, 1)
		foundGlow:SetBlendMode("ADD")
		foundGlow:SetPoint("CENTER", self, "TOPLEFT", x, y)
		foundGlow:SetSize(Size * GLOW_WIDTH, Size * GLOW_WIDTH)
		foundGlow:Show()

		if oldTexture then
			oldTexture.ring = foundRing
			oldTexture.glow = foundGlow
		else
			FoundTextures[textureIndex] = {
				ring = foundRing,
				glow = foundGlow,
			}
		end

		self.textureIndex = textureIndex

		private.SetAutoHideDelay(self, FoundTextures[textureIndex], RING_CLEAR_DELAY)
	end
end


-- Cache achievement NPC names
local AchievementNPCNames = {}
for achievementID in pairs(private.Achievements) do
	for criteria = 1, _G.GetAchievementNumCriteria(achievementID) do
		local name, criteriaType, _, _, _, _, _, assetID = _G.GetAchievementCriteriaInfo(achievementID, criteria)
		if criteriaType == 0 then -- Mob kill type
			AchievementNPCNames[assetID] = name
		end
	end
end

-- Passes info for all enabled NPCs in a zone to a callback function.
-- @param Callback  Function( self, PathData, [FoundX], [FoundY], R, G, B, NpcID )
do
	local alphaList = {} -- List of mob names to sort
	local npcList = {} -- Index of Mob Name to MobIDs

	function private:ApplyZone(mapID, callbackFunc)
		local mapData = private.PathData[mapID]
		if not mapData then
			return
		end
		table.wipe(alphaList)
		table.wipe(npcList)

		local colorIndex = 0

		--Sorts Mobs in current zone by name
		for npcID, _ in pairs(mapData) do
			local npcName = AchievementNPCNames[npcID] or L.NPCs[tostring(npcID)] or npcID
			npcList[npcName] = npcID
			table.insert(alphaList, tostring(npcName))
		end

		table.sort(alphaList)

		for _, npcName in pairs(alphaList) do
			local npcID, pathData = npcList[npcName], mapData[npcList[npcName]]
			colorIndex = colorIndex + 1

			if private.Options.ShowAll or private.NPCCounts[npcID] then
				local color = assert(private.OverlayKeyColors[colorIndex], "Ran out of unique path colors.")
				local found = private.NPCMaps[npcID][mapID]
				local foundX, foundY

				if type(found) == "table" then
					foundX, foundY = unpack(found)
				end

				private.CurrentTextureMob = npcID;
				callbackFunc(self, pathData, foundX, foundY, color.r, color.g, color.b)
			end
		end
	end
end

-- @return Aliased NPC ID, or original if not aliased.
local function GetRealNpcID(NpcID)
	local aliasID = private.NPCAliases[NpcID]

	while (aliasID) do
		NpcID, aliasID = aliasID, private.NPCAliases[aliasID]
	end

	return NpcID
end


-- @return First Map ID that NpcID can be found on or nil if unknown.
function private.GetNPCMapID(NpcID)
	local maps = private.NPCMaps[GetRealNpcID(NpcID)]

	if maps then
		return (next(maps))
	end
end


-- Enables an NPC map overlay by NpcID.
local function NPCAdd(npcID)
	local aliasID, npcID = npcID, GetRealNpcID(npcID)
	if not private.NPCsEnabled[aliasID] and private.NPCMaps[npcID] then
		private.NPCsEnabled[aliasID] = true

		private.NPCCounts[npcID] = (private.NPCCounts[npcID] or 0) + 1
		if private.NPCCounts[npcID] == 1 and not private.Options.ShowAll then
			for mapID in pairs(private.NPCMaps[npcID]) do
				private.Modules.UpdateMap(mapID)
			end
		end
	end
end


-- Disables an NPC map overlay by NpcID.
local function NPCRemove(npcID)
	if not private.NPCsEnabled[npcID] then
		return
	end
	private.NPCsEnabled[npcID] = nil
	npcID = GetRealNpcID(npcID)

	local Count = assert(private.NPCCounts[npcID], "Enabled NPC wasn't active.")
	private.NPCCounts[npcID] = Count > 1 and Count - 1 or nil

	if not (Count > 1 or private.Options.ShowAll) then
		for Map in pairs(private.NPCMaps[npcID]) do
			private.Modules.UpdateMap(Map)
		end
	end
end


local NPCFound
do
	-- Saves the position of NpcID on Map and updates displays.
	local function SaveFound(npcID, mapID, X, Y)
		local found = private.NPCMaps[npcID][mapID]

		if type(found) ~= "table" then
			found = {}
			private.NPCMaps[npcID][mapID] = found
		end
		found[1], found[2] = X, Y

		if private.Options.ShowAll or private.NPCCounts[npcID] then
			private.Modules.UpdateMap(mapID)
		end
	end


	-- Saves an NPC's last seen position at the given position or the player.
	function NPCFound(npcID, mapID, x, y)
		npcID = GetRealNpcID(npcID)

		if not private.NPCMaps[npcID] or private.NPCsFoundIgnored[npcID] then
			return
		end

		if mapID and x and y then
			if private.NPCMaps[npcID][mapID] then
				SaveFound(npcID, mapID, x, y)

				local MapOld = _G.GetCurrentMapAreaID()
				_G.SetMapByID(mapID)

				local playerX, playerY = _G.GetPlayerMapPosition("player")
				if playerX == 0 and playerY == 0 then -- Player isn't on the same map
					_G.SetMapByID(MapOld) -- Undo map change if mob isn't nearby
				end
			end
		else
			local oldMapID = _G.GetCurrentMapAreaID()
			_G.SetMapToCurrentZone()

			local currentMapID = _G.GetCurrentMapAreaID()
			local newMapID

			for npcMapID in pairs(private.NPCMaps[npcID]) do
				_G.SetMapByID(npcMapID)

				local playerX, playerY = _G.GetPlayerMapPosition("player")
				if playerX ~= 0 or playerY ~= 0 then -- Found on this map
					SaveFound(npcID, npcMapID, playerX, playerY)

					if not newMapID or npcMapID == currentMapID then -- Current map has priority if found there
						newMapID = npcMapID -- Force map to view found rare
					end
				end
			end

			_G.SetMapByID(newMapID or oldMapID)
		end
	end
end


do
	-- See <http://www.wowace.com/addons/npcscan-overlay/pages/map-control-api/>
	-- for Overlay message documentation.
	local ScannerAddOn
	-- Grants exclusive control of mob path visibility to the first addon that registers.
	-- @param AddOn Logically true identifier for the controller addon.  Must be
	-- used in all subsequent messages.
	private.Events[MESSAGE_REGISTER] = function(self, Event, AddOn)
		self:UnregisterMessage(Event)
		self[Event] = nil
		ScannerAddOn = assert(AddOn, "Registration message must provide an addon identifier.")

		-- Quit showing all by default and let the scanning addon control visibility
		for NpcID in pairs(private.NPCsEnabled) do
			NPCRemove(NpcID)
		end

		self:RegisterMessage(MESSAGE_ADD)
		self:RegisterMessage(MESSAGE_REMOVE)
	end

	-- Shows a mob's path, if available.
	-- @param NpcID Numeric creature ID to add.
	-- @param AddOn Identifier used in registration message.
	private.Events[MESSAGE_ADD] = function(self, _, NpcID, AddOn)
		if ScannerAddOn and AddOn == ScannerAddOn then
			return NPCAdd(assert(tonumber(NpcID),
				"Add message NpcID must be numeric."))
		end
	end


	-- Removes a mob's path if it has already been shown.
	-- @param NpcID Numeric creature ID to remove.
	-- @param AddOn Identifier used in registration message.
	private.Events[MESSAGE_REMOVE] = function(self, _, NpcID, AddOn)
		if ScannerAddOn and AddOn == ScannerAddOn then
			return NPCRemove(assert(tonumber(NpcID),
				"Remove message NpcID must be numeric."))
		end
	end


	-- Saves an NPC's last seen position at the given position or at the player.
	-- Will fail if the given or current zone doesn't have path data.
	-- @param NpcID Numeric creature ID that was found.
	-- @param MapID Optional numeric map ID that the NPC was found on.
	-- @param X..Y Optional numeric coordinates of NPC on MapID.
	private.Events[MESSAGE_FOUND] = function(self, _, NpcID, MapID, X, Y)
		return NPCFound(assert(tonumber(NpcID), "Found message Npc ID must be a number."),
			tonumber(MapID), tonumber(X), tonumber(Y))
	end
end


--Creates LDB icon and click actions
local function ConfigEntry_OnMouseUp(tooltipCell, configEntry, button)
	if configEntry == "WorldMapKey" then
		private.WorldMapKey_ToggleOnClick()
	elseif configEntry == "MiniMap" then
		if private.Options.Modules["Minimap"] then
			private.Modules.Disable("Minimap")
		else
			private.Modules.Enable("Minimap")
		end
	elseif configEntry == "WorldMap" then
		if private.Options.Modules["WorldMap"] then
			private.Modules.Disable("WorldMap")
		else
			private.Modules.Enable("WorldMap")
		end
	elseif configEntry == "Maps" then
		if private.Options.Modules["Minimap"] then
			private.Modules.Disable("Minimap")
			private.Modules.Disable("WorldMap")
		else
			private.Modules.Enable("Minimap")
			private.Modules.Enable("WorldMap")
		end
	elseif configEntry == "Options" then
		_G.InterfaceOptionsFrame_OpenToCategory(private.Config)
	end
end


local LDB = _G.LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("_NPCScan.Overlay", {
	type = "data source",
	text = "_NPCScan.Overlay",
	icon = "Interface\\Icons\\INV_Misc_EngGizmos_20",
	OnClick = function(_, button)
		_G.InterfaceOptionsFrame_OpenToCategory(private.Config)
	end,
	OnEnter = function(self)
		if LibQTip:IsAcquired(FOLDER_NAME) then
			return
		end
		local tooltip = LibQTip:Acquire(FOLDER_NAME, 3)
		tooltip:SetAutoHideDelay(0.1, self)
		tooltip:SmartAnchorTo(self)
		tooltip:Clear()

		tooltip:SetCell(tooltip:AddLine(), 1, L.BUTTON_TOOLTIP_LINE1, "CENTER", 0)
		tooltip:AddSeparator()

		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, L.BUTTON_TOOLTIP_LINE2)
		tooltip:SetCellScript(line, 1, "OnMouseUp", ConfigEntry_OnMouseUp, "WorldMap")

		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, L.BUTTON_TOOLTIP_LINE3)
		tooltip:SetCellScript(line, 1, "OnMouseUp", ConfigEntry_OnMouseUp, "WorldMapKey")

		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, L.BUTTON_TOOLTIP_LINE4)
		tooltip:SetCellScript(line, 1, "OnMouseUp", ConfigEntry_OnMouseUp, "MiniMap")

		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, L.BUTTON_TOOLTIP_LINE5)
		tooltip:SetCellScript(line, 1, "OnMouseUp", ConfigEntry_OnMouseUp, "Maps")

		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, L.BUTTON_TOOLTIP_LINE6)
		tooltip:SetCellScript(line, 1, "OnMouseUp", ConfigEntry_OnMouseUp, "Options")

		tooltip:Show()
	end,
	OnLeave = function(self)
		-- Null operation: Some LDB displays get cranky if this method is missing.
	end,
})


do
	private.GetMapName = _G.GetMapNameByID -- For backwards compatibility with older versions of _NPCScan
	local MapIDs = {} -- [ LocalizedZoneName ] = MapID

	-- @return Map ID for localized zone name or nil if unknown.
	-- Note that only true continent sub-zones are supported.
	function private.GetMapID(Name)
		return MapIDs[Name]
	end


	local MapWidths, MapHeights = {}, {}
	-- @return Width and height of Map in yards or nil if unavailable.
	function private.GetMapSize(Map)
		return MapWidths[Map] or 0, MapHeights[Map] or 0
	end


	-- Loads defaults, validates settings, and begins listening for Overlay API messages.
	function private.Events:ADDON_LOADED(eventName, addonName)
		if addonName ~= FOLDER_NAME then
			return
		end
		self[eventName] = nil
		self:UnregisterEvent(eventName)

		private.Options = _G._NPCScanOverlayOptions
		private.OverlayKeyColors = _G._NPCScanOverlayKeyColors

	--Adds additional colors if saved ammount is less than what is needed
		if #private.OverlayKeyColors < private.KeyColorTotal then
			local needed = private.KeyColorTotal - #private.OverlayKeyColors
			local startingID = #private.OverlayKeyColors
			for i=1, needed do
				private.OverlayKeyColors[startingID + i] = private.OverlayKeyColors[i]
			end
		end

	--Updates Options table to add any missing
		for var, value in pairs(OptionsDefault) do
			private.Options[var] = private.Options[var] == nil and value or private.Options[var]
		end

		-- Build a reverse lookup of NpcIDs to zones, and add them all by default
		for mapID, mapData in pairs(private.PathData) do
			_G.SetMapByID(mapID)
			local _, X1, Y1, X2, Y2 = _G.GetCurrentMapZone()
			local Width, Height = X1 - X2, Y1 - Y2

			if Width == 0 or Height == 0 then
				error("Zone dimensions unavailable for map " .. mapID .. ".")
			end
			MapWidths[mapID], MapHeights[mapID] = Width, Height
			MapIDs[_G.GetMapNameByID(mapID)] = mapID

			for NpcID in pairs(mapData) do
				if not private.NPCMaps[NpcID] then
					private.NPCMaps[NpcID] = {}
				end
				private.NPCMaps[NpcID][mapID] = true
				NPCAdd(NpcID)
			end
		end

		if private.Options and not private.Options.ModulesExtra then -- 3.3.5.1: Moved module options to options sub-tables
			private.Options.ModulesExtra = {}
		end
		private.LDBI:Register(FOLDER_NAME, LDB, private.Options.MiniMapIcon)

		private.Config.ShowAll:SetChecked(private.Options.ShowAll)
		private.Config.LockSwap:SetChecked(private.Options.LockSwap)
		private.Config.KeyAutoHide:SetChecked(private.Options.KeyAutoHide)
		private.Config.KeySize.setFunc(private.Options.KeyMaxSize)
		private.Config.KeyAutoHideAlpha.setFunc(private.Options.KeyAutoHideAlpha)
		private.Config.MouseoverText:SetChecked(private.Options.MouseoverText)
		private.Config.MiniMapIcon:SetChecked(private.Options.MiniMapIcon.hide)
		private.Config.KeyFontSize:SetValue(private.Options.KeyFontSize)
		private.Modules.OnSynchronize(private.Options)
		private.SetKeyIconTexture()
		private.SetPathIconTexture()
		self:RegisterMessage(MESSAGE_REGISTER)
		self:RegisterMessage(MESSAGE_FOUND)
		private.SetPanelFont(private.Options.KeyFont, private.Options.KeyFontSize)
		_G.UIDropDownMenu_SetText(private.Config.KeyFont, private.Options.KeyFont == private.DEFAULT_FONT_NAME and "Default" or private.Options.KeyFont)
	end
end

local FlashTable = {}

--Flashes selected Mob route
function private.FlashRoute(npcID)
	wipe(FlashTable)
	for ID, npcData in pairs(private.TextureTable) do
		if npcID == ID then
			for text in pairs(npcData) do
				local flasher = _G[text]:CreateAnimationGroup()
				FlashTable[text] = flasher

				local fade1 = flasher:CreateAnimation("Alpha")
				fade1:SetDuration(0.25)
				fade1:SetFromAlpha(0)
				fade1:SetToAlpha(1)
				fade1:SetOrder(1)

				local fade2 = flasher:CreateAnimation("Alpha")
				fade2:SetDuration(0.25)
				fade2:SetFromAlpha(1)
				fade2:SetToAlpha(0)
				fade2:SetOrder(2)

				flasher:SetLooping("BOUNCE")
				flasher:SetScript("OnFinished", function() _G[text]:SetAlpha(1) end)

				flasher:Play()
			end
		end
	end
end


--Stops the Slected route from flashing
function private.FlashStop(MobID)
	for text, flash in pairs(FlashTable) do
		flash:Finish()
	end
end


function private.ShowTooltip(self, Message)
	local tooltip = LibQTip:Acquire(FOLDER_NAME, 3)
	tooltip:SetAutoHideDelay(0.1, self)
	tooltip:SmartAnchorTo(self)
	tooltip:Clear()
	tooltip:SetCell(tooltip:AddLine(), 1, Message, "CENTER", 0)
	tooltip:Show()
end


function private.HideTooltip(self)
	LibQTip:Release(self.tooltip)
	self.tooltip = nil
end

------------------------------------------------------------------------------
-- Frame cache
------------------------------------------------------------------------------
local frameHeap =  {}

local function AcquireFrame(parent)
	local frame = tremove(frameHeap) or CreateFrame("Frame")
	frame:SetParent(parent)
	return frame
end

local function ReleaseFrame(frame)
	frame:Hide()
	frame:SetParent(nil)
	frame:ClearAllPoints()
	frame:SetBackdrop(nil)
	frame:SetScript("OnUpdate", nil)
	tinsert(frameHeap, frame)
	--[===[@debug@
	--usedFrames = usedFrames - 1
	--@end-debug@]===]
end


-- Clears a NPC's saved Found status
local function ClearFound(NPCID)
	for map, found in pairs(private.NPCMaps[NPCID]) do
		private.NPCMaps[NPCID][map] = true
	end
	--print("clearing rings for "..NPCID)
end


-- Script of the auto-hiding child frame
local function AutoHideTimerFrame_OnUpdate(self, elapsed)
	self.checkElapsed = self.checkElapsed + elapsed
	if self.checkElapsed >= self.delay then
		self.checkElapsed = 0
		self.parent.autoHideTimerFrame = nil
		self:SetScript("OnUpdate", nil)
		ReleaseFrame(self)
		ClearFound(self.target.ring.id)
		private.Modules.UpdateMap(nil)
	end
end


--Sets an auto hide delay when displaying mob found rings.
function private.SetAutoHideDelay(self, target, delay)
	local timerFrame = self.autoHideTimerFrame
	delay = tonumber(delay) or 0

	if not timerFrame then
		timerFrame = AcquireFrame(self)

		self.autoHideTimerFrame = timerFrame
	end
	timerFrame:SetScript("OnUpdate", AutoHideTimerFrame_OnUpdate)
	timerFrame:SetParent(UIParent)
	timerFrame.parent = UIParent
	timerFrame.target = target
	timerFrame.checkElapsed = 0
	timerFrame.elapsed = 0
	timerFrame.delay = delay
	timerFrame:Show()
end


private.Events:RegisterEvent("ADDON_LOADED")
