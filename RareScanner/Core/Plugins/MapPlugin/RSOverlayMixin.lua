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


RSOverlayMixin = CreateFromMixins(MapCanvasPinMixin);
 
function RSOverlayMixin:OnLoad()
	self:SetScalingLimits(1, 1.4, 2.5);
end

function RSOverlayMixin:OnAcquired(x, y, pin)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_DIG_SITE", self:GetMap():GetNumActivePinsByTemplate("RSOverlayTemplate"));
	
	-- Set attributes
	self.pin = pin
	self.Texture:SetTexture(RSConstants.OVERLAY_SPOT_TEXTURE)
	self:SetPosition(x, y);
end

function RSOverlayMixin:OnMouseEnter()
	if (not self.pin.ShowAnim:IsPlaying()) then
		self.pin.ShowAnim:Play();
	end
	
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(self.pin.POI.name)
	GameTooltip:Show()
end

function RSOverlayMixin:OnMouseLeave()
	if (self.pin.ShowAnim:IsPlaying()) then
		self.pin.ShowAnim:Stop();
	end
	
	GameTooltip:Hide()
end

function RSOverlayMixin:OnMouseDown(button)
	if (button == "RightButton") then
		self:GetMap():RemoveAllPinsByTemplate("RSOverlayTemplate");
		RSGeneralDB.RemoveOverlayActive()
	
		-- Refresh minimap
		RSMinimap.RefreshAllData(true)
	end
end
