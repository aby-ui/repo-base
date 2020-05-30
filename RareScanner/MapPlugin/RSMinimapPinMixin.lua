-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local HBD_Pins = LibStub("HereBeDragons-Pins-2.0")
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

local BLUE_NPC_TEXTURE = "Interface\\AddOns\\RareScanner\\Media\\Icons\\BlueSkullDark.blp"
 
function RareScanner:UpdateMinimap(forzed)	
	-- Ignore if minimap not available
	if (not Minimap:IsVisible()) then 
		return
	end

	-- Add current zone ones
	local mapID = C_Map.GetBestMapForUnit("player")
	if (not mapID or mapID == 0) then
		return
	end
	
	-- Ignore if zone with vignettes
	if (not private.ZONES_WITHOUT_VIGNETTE[mapID] or not RS_tContains(private.ZONES_WITHOUT_VIGNETTE[mapID], C_Map.GetMapArtID(mapID))) then
		return
	end
	
	if (not self.pinFramesPool) then
		self.pinFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end
	
	-- If same zone ignore it
	if (not forzed and self.previousMapID and self.previousMapID == mapID) then
		return
	end
	
	-- Release current pins
	HBD_Pins:RemoveAllMinimapIcons(self)
	for pin in  self.pinFramesPool:EnumerateActive() do
		if (pin.overlayFramesPool) then
			HBD_Pins:RemoveAllMinimapIcons(pin)
			pin.overlayFramesPool:ReleaseAll()
		end
	end
	self.pinFramesPool:ReleaseAll()
	self.previousMapID = mapID
	
	-- Refresh data
	self:RefreshAllData(mapID)
end
 
RSMinimapPinMixin = {}

function RSMinimapPinMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(self.name)
	GameTooltip:Show()
end
 
function RSMinimapPinMixin:OnLeave()
	GameTooltip:Hide()
end

function RSMinimapPinMixin:ShowOverlay()
	if (not self.overlayFramesPool) then
		self.overlayFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end
	
	if (private.ZONE_IDS[self.npcID]) then
		if (private.ZONE_IDS[self.npcID].overlay) then
			for i, coordinates in ipairs (private.ZONE_IDS[self.npcID].overlay) do
				local x, y = strsplit("-", coordinates)
				local pin = self.overlayFramesPool:Acquire()
				pin.npcID = self.npcID
				RareScanner:SetUpOverlayPin(pin)
				HBD_Pins:AddMinimapIconMap(self, pin, self.mapID, tonumber(x), tonumber(y), false, false)
			end
			private.dbchar.overlayActive = self.npcID
		elseif (type(private.ZONE_IDS[self.npcID].zoneID) == "table" and private.ZONE_IDS[self.npcID].zoneID[self.mapID] and private.ZONE_IDS[self.npcID].zoneID[self.mapID].overlay) then
			for i, coordinates in ipairs (private.ZONE_IDS[self.npcID].zoneID[self.mapID].overlay) do
				local x, y = strsplit("-", coordinates)
				local pin = self.overlayFramesPool:Acquire()
				pin.npcID = self.npcID
				RareScanner:SetUpOverlayPin(pin)
				HBD_Pins:AddMinimapIconMap(self, pin, self.mapID, tonumber(x), tonumber(y), false, false)
			end
		end
	end
end