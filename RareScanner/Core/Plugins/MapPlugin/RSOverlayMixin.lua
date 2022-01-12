-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local ADDON_NAME, private = ...

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")

-- RareScanner general libraries
local RSUtils = private.ImportLib("RareScannerUtils")


RSOverlayMixin = CreateFromMixins(MapCanvasPinMixin);

function RSOverlayMixin:OnLoad()
	self:SetScalingLimits(1, 1.4, 2.5);
end

function RSOverlayMixin:OnAcquired(x, y, r, g, b, pin)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_DIG_SITE", self:GetMap():GetNumActivePinsByTemplate("RSOverlayTemplate"));

	-- Set attributes
	self.pin = pin
	self.Texture:SetTexture(RSConstants.OVERLAY_SPOT_TEXTURE)
	self.Texture:SetVertexColor(r, g, b, 0.9)
	self:SetPosition(RSUtils.FixCoord(x), RSUtils.FixCoord(y));
end

function RSOverlayMixin:OnMouseEnter()
	if (self.pin.ShowAnim and not self.pin.ShowAnim:IsPlaying()) then
		self.pin.ShowAnim:Play();
	end

	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	
	if (self.pin.POI) then
		GameTooltip:SetText(self.pin.POI.name)
	else
		GameTooltip:SetText(self.pin.name)
	end
	GameTooltip:Show()
end

function RSOverlayMixin:OnMouseLeave()
	if (self.pin.ShowAnim and self.pin.ShowAnim:IsPlaying()) then
		self.pin.ShowAnim:Stop();
	end

	GameTooltip:Hide()
end

function RSOverlayMixin:OnMouseDown(button)
	if (button == "RightButton") then
		for pin in self:GetMap():EnumeratePinsByTemplate("RSOverlayTemplate") do
			if (pin ~= self and pin:GetEntityID() == self:GetEntityID()) then
				self:GetMap():RemovePin(pin)
			end
		end
		
		self:GetMap():RemovePin(self)
		RSGeneralDB.RemoveOverlayActive(self:GetEntityID())

		-- Refresh minimap
		RSMinimap.RefreshAllData(true)
	end
end

function RSOverlayMixin:GetEntityID()
	if (self.pin.POI) then
		return self.pin.POI.entityID
	else
		return self.pin.entityID
	end
end