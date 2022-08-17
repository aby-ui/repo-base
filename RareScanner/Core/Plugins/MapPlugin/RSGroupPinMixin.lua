-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

-- RareScanner database libraries
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")

-- RareScanner service libraries
local RSTooltip = private.ImportLib("RareScannerTooltip")
local RSMinimap = private.ImportLib("RareScannerMinimap")

-- RareScanner services
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")

RSGroupPinMixin = CreateFromMixins(MapCanvasPinMixin);

function RSGroupPinMixin:OnLoad()
	self:SetScalingLimits(1, 1, 1.0);
end

function RSGroupPinMixin:OnAcquired(POI)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE", self:GetMap():GetNumActivePinsByTemplate("RSGroupPinTemplate"));
	self.POI = POI
	if (POI.TopTexture) then
		self.TopTexture:SetTexture(POI.TopTexture)
		self.TopTexture:SetScale(RSConfigDB.GetIconsWorldMapScale())
	else
		self.TopTexture:SetTexture(nil)
	end
	if (POI.LeftTexture) then
		self.LeftTexture:SetTexture(POI.LeftTexture)
		self.LeftTexture:SetScale(RSConfigDB.GetIconsWorldMapScale())
	else
		self.LeftTexture:SetTexture(nil)
	end
	if (POI.RightTexture) then
		self.RightTexture:SetTexture(POI.RightTexture)
		self.RightTexture:SetScale(RSConfigDB.GetIconsWorldMapScale())
	else
		self.RightTexture:SetTexture(nil)
	end
	self:SetPosition(POI.x, POI.y);
end

function RSGroupPinMixin:OnMouseEnter()
	RSTooltip.ShowGroupTooltip(self)
end

function RSGroupPinMixin:OnMouseLeave()
	if (RSTooltip.HideTooltip(self.groupTooltip)) then
		self.groupTooltip = nil
	end
end

function RSGroupPinMixin:OnMouseDown(button)

end

function RSGroupPinMixin:OnReleased()
	RSTooltip.ReleaseTooltip(self.groupTooltip)
	self.groupTooltip = nil
end

function RSGroupPinMixin:ShowOverlay(childPOI)
	-- Overlay
	local overlay = nil
	if (childPOI.isNpc) then
		overlay = RSNpcDB.GetInternalNpcOverlay(childPOI.entityID, childPOI.mapID)
	elseif (childPOI.isContainer) then
		overlay = RSContainerDB.GetInternalContainerOverlay(childPOI.entityID, childPOI.mapID)
	end

	if (overlay) then
		-- Checks if the overlay is already shown, in which case is already active in the minimap
		local hasOverlayActive = RSGeneralDB.HasOverlayActive(childPOI.entityID);
		
		local r, g, b, replacedEntityID = RSGeneralDB.AddOverlayActive(childPOI.entityID)
		
		-- Cleans the replaced overlay
		if (replacedEntityID) then
			for pin in self:GetMap():EnumeratePinsByTemplate("RSOverlayTemplate") do
				if (pin:GetEntityID() == replacedEntityID) then
					self:GetMap():RemovePin(pin)
				end
			end
			
			-- Cleans the replaced overly in the minimap
			RSMinimap.RemoveOverlay(replacedEntityID)
		end
		
		-- Adds the new one
		for _, coordinates in ipairs (overlay) do
			local x, y = strsplit("-", coordinates)
			self:GetMap():AcquirePin("RSOverlayTemplate", tonumber(x), tonumber(y), r, g, b, childPOI);
		end
		
		-- Adds the new one to the minimap
		if (not hasOverlayActive) then
			RSMinimap.AddOverlay(childPOI.entityID)
		end
	end
end