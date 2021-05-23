--[[
Copyright (c) 2009-2018, Hendrik "Nevcairiel" Leppkes < h.leppkes@gmail.com >
All rights reserved.
]]

local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster")
local L = LibStub("AceLocale-3.0"):GetLocale("Mapster")

local MODNAME = "FogClear"
local FogClear = Mapster:NewModule(MODNAME, "AceHook-3.0", "AceEvent-3.0")

local mod, floor, ceil, tonumber = math.fmod, math.floor, math.ceil, tonumber
local ipairs, pairs = ipairs, pairs

local db
local defaults = {
	profile = {
		colorR = 1,
		colorG = 1,
		colorB = 1,
		colorA = 1,
	},
}

local options

local function getOptions()
	if not options then
		options = {
			type = "group",
			name = L["FogClear"],
			arg = MODNAME,
			args = {
				intro = {
					order = 1,
					type = "description",
					name = L["The FogClear module removes the Fog of War from the World map, thus displaying the artwork for all the undiscovered zones, optionally with a color overlay on undiscovered areas."] .. "\n",
				},
				enabled = {
					order = 2,
					type = "toggle",
					name = L["Enable FogClear"],
					get = function() return Mapster:GetModuleEnabled(MODNAME) end,
					set = function(info, value) Mapster:SetModuleEnabled(MODNAME, value) end,
				},
				color = {
					order = 3,
					type = "color",
					name = L["Overlay Color"],
					get = "GetOverlayColor",
					set = "SetOverlayColor",
					handler = FogClear,
					hasAlpha = true,
				},
			}
		}
	end

	return options
end

function FogClear:OnInitialize()
	self.db = Mapster.db:RegisterNamespace(MODNAME, defaults)
	db = self.db.profile

	self.db.global.errata = nil

	self:SetEnabledState(Mapster:GetModuleEnabled(MODNAME))
	Mapster:RegisterModuleOptions(MODNAME, getOptions, L["FogClear"])
end

local function TexturePool_ResetVertexColor(pool, texture)
	texture:SetVertexColor(1,1,1)
	texture:SetAlpha(1)
	return TexturePool_HideAndClearAnchors(pool, texture)
end

function FogClear:OnEnable()
	for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		self:SecureHook(pin, "RefreshOverlays", "MapExplorationPin_RefreshOverlays")
		pin.overlayTexturePool.resetterFunc = TexturePool_ResetVertexColor
	end
end

function FogClear:OnDisable()
	self:UnhookAll()
end

function FogClear:Refresh()
	db = self.db.profile
	if not self:IsEnabled() then return end

	for pin in WorldMapFrame:EnumeratePinsByTemplate("MapExplorationPinTemplate") do
		pin:RefreshOverlays(true)
	end
end

local FogData = MapsterFogClearData or {}
function FogClear:MapExplorationPin_RefreshOverlays(pin, fullUpdate)
	local mapID = pin:GetMap():GetMapID()
	if not mapID then return end
	local artID = C_Map.GetMapArtID(mapID)
	if not artID or not FogData[artID] then return end
	local data = FogData[artID]

	local exploredTilesKeyed = {}
	local exploredMapTextures = C_MapExplorationInfo.GetExploredMapTextures(mapID)
	if exploredMapTextures then
		for _i, exploredTextureInfo in ipairs(exploredMapTextures) do
			local key = exploredTextureInfo.textureWidth * 2^39 + exploredTextureInfo.textureHeight * 2^26 + exploredTextureInfo.offsetX * 2^13 + exploredTextureInfo.offsetY
			exploredTilesKeyed[key] = true
		end
	end

	pin.layerIndex = pin:GetMap():GetCanvasContainer():GetCurrentLayerIndex()
	local layers = C_Map.GetMapArtLayers(mapID)
	local layerInfo = layers and layers[pin.layerIndex]
	if not layerInfo then return end
	local TILE_SIZE_WIDTH = layerInfo.tileWidth
	local TILE_SIZE_HEIGHT = layerInfo.tileHeight

	local r, g, b, a = self:GetOverlayColor()

	for key, files in pairs(data) do
		if not exploredTilesKeyed[key] then
			local width, height, offsetX, offsetY = mod(floor(key / 2^39), 2^13), mod(floor(key / 2^26), 2^13), mod(floor(key / 2^13), 2^13), mod(key, 2^13)
			local fileDataIDs = { strsplit(",", files) }
			local numTexturesWide = ceil(width/TILE_SIZE_WIDTH)
			local numTexturesTall = ceil(height/TILE_SIZE_HEIGHT)
			local texturePixelWidth, textureFileWidth, texturePixelHeight, textureFileHeight
			for j = 1, numTexturesTall do
				if ( j < numTexturesTall ) then
					texturePixelHeight = TILE_SIZE_HEIGHT
					textureFileHeight = TILE_SIZE_HEIGHT
				else
					texturePixelHeight = mod(height, TILE_SIZE_HEIGHT)
					if ( texturePixelHeight == 0 ) then
						texturePixelHeight = TILE_SIZE_HEIGHT
					end
					textureFileHeight = 16
					while(textureFileHeight < texturePixelHeight) do
						textureFileHeight = textureFileHeight * 2
					end
				end
				for k = 1, numTexturesWide do
					local texture = pin.overlayTexturePool:Acquire()
					if ( k < numTexturesWide ) then
						texturePixelWidth = TILE_SIZE_WIDTH
						textureFileWidth = TILE_SIZE_WIDTH
					else
						texturePixelWidth = mod(width, TILE_SIZE_WIDTH)
						if ( texturePixelWidth == 0 ) then
							texturePixelWidth = TILE_SIZE_WIDTH
						end
						textureFileWidth = 16
						while(textureFileWidth < texturePixelWidth) do
							textureFileWidth = textureFileWidth * 2
						end
					end
					texture:SetWidth(texturePixelWidth)
					texture:SetHeight(texturePixelHeight)
					texture:SetTexCoord(0, texturePixelWidth/textureFileWidth, 0, texturePixelHeight/textureFileHeight)
					texture:SetPoint("TOPLEFT", offsetX + (TILE_SIZE_WIDTH * (k-1)), -(offsetY + (TILE_SIZE_HEIGHT * (j - 1))))
					texture:SetTexture(tonumber(fileDataIDs[((j - 1) * numTexturesWide) + k]), nil, nil, "TRILINEAR")

					texture:SetVertexColor(r, g, b)
					texture:SetAlpha(a)
					texture:SetDrawLayer("ARTWORK", -1)
					texture:Show()

					if fullUpdate then
						pin.textureLoadGroup:AddTexture(texture)
					end
				end
			end
		end
	end
end

function FogClear:GetOverlayColor()
	return db.colorR, db.colorG, db.colorB, db.colorA
end

function FogClear:SetOverlayColor(info, r,g,b,a)
	db.colorR, db.colorG, db.colorB, db.colorA = r,g,b,a
	if self:IsEnabled() then self:Refresh() end
end

-- remove data from global scope
MapsterFogClearData = nil
