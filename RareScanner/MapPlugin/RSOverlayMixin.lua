-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- Textures
local BACKGROUND = "Interface\\AddOns\\RareScanner\\Media\\Icons\\Overlay.blp"

function RareScanner:SetUpOverlayPin(pin)
	pin.Texture:SetTexture(BACKGROUND)
end

RSOverlayMixin = CreateFromMixins(MapCanvasPinMixin);
 
function RSOverlayMixin:OnLoad()
	self:SetScalingLimits(1, 1.4, 2.5);
end

function RSOverlayMixin:OnAcquired(x, y, pin)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_DIG_SITE", self:GetMap():GetNumActivePinsByTemplate("RSOverlayTemplate"));
	
	-- Set attributes
	self.pin = pin
		
	-- Loads pin information
	RareScanner:SetUpOverlayPin(self)
	self:SetPosition(x, y);
end

function RSOverlayMixin:OnMouseEnter()
	if (not self.pin.ShowAnim:IsPlaying()) then
		self.pin.ShowAnim:Play();
	end
	
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	GameTooltip:SetText(self.pin.name)
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
		private.dbchar.overlayActive = nil
	
		-- Refresh minimap
		RareScanner:UpdateMinimap(true)
	end
end
