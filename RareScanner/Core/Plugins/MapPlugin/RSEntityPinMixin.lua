-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local RareScanner = LibStub("AceAddon-3.0"):GetAddon("RareScanner")
local ADDON_NAME, private = ...

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")

-- RareScanner service libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSTooltip = private.ImportLib("RareScannerTooltip")

-- RareScanner services
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")
local RSTomtom = private.ImportLib("RareScannerTomtom")
local RSWaypoints = private.ImportLib("RareScannerWaypoints")

RSEntityPinMixin = CreateFromMixins(MapCanvasPinMixin);

function RSEntityPinMixin:OnLoad()
	self:SetScalingLimits(1, 0.75, 1.0);
end

function RSEntityPinMixin:OnAcquired(POI)
	self:UseFrameLevelType("PIN_FRAME_LEVEL_VIGNETTE", self:GetMap():GetNumActivePinsByTemplate("RSEntityPinTemplate"));
	self.POI = POI
	self.Texture:SetTexture(POI.Texture)
	self.Texture:SetScale(RSConfigDB.GetIconsWorldMapScale())
	self:SetPosition(POI.x, POI.y);
end

function RSEntityPinMixin:OnMouseEnter()
	RSTooltip.ShowSimpleTooltip(self)
end

function RSEntityPinMixin:OnMouseLeave()
	if (RSTooltip.HideTooltip(self.tooltip)) then
		self.tooltip = nil
	end
end

function RSEntityPinMixin:OnMouseDown(button)
	if (button == "LeftButton") then
		--Toggle state
		if (IsShiftKeyDown() and IsAltKeyDown()) then
			if (self.POI.isNpc) then
				if (self.POI.isDead) then
					RSNpcDB.DeleteNpcKilled(self.POI.entityID)
				else
					RareScanner:ProcessKill(self.POI.entityID, true)
					self:Hide();
				end
			elseif (self.POI.isContainer) then
				if (self.POI.isOpened) then
					RSContainerDB.DeleteContainerOpened(self.POI.entityID)
				else
					RareScanner:ProcessOpenContainer(self.POI.entityID, true)
					self:Hide();
				end
			elseif (self.POI.isEvent) then
				if (self.POI.isCompleted) then
					RSEventDB.DeleteEventCompleted(self.POI.entityID)
				else
					RareScanner:ProcessCompletedEvent(self.POI.entityID, true)
					self:Hide();
				end
			end
			self:GetMap():RefreshAllDataProviders();
		-- Add waypoint
		elseif (IsShiftKeyDown()) then
			if (RSConfigDB.IsAddingWorldMapTomtomWaypoints()) then
				RSTomtom.AddWorldMapTomtomWaypoint(self.POI.mapID, self.POI.x, self.POI.y, self.POI.name)
			end
			if (RSConfigDB.IsAddingWorldMapIngameWaypoints()) then
				RSWaypoints.AddWorldMapWaypoint(self.POI.mapID, self.POI.x, self.POI.y)
			end
		-- Toggle overlay
		elseif (not IsShiftKeyDown() and not IsAltKeyDown()) then
			-- If overlay showing then hide it
			local overlayEntityID = RSGeneralDB.GetOverlayActive()
			if (overlayEntityID) then
				self:GetMap():RemoveAllPinsByTemplate("RSOverlayTemplate");
				if (overlayEntityID ~= self.POI.entityID) then
					self:ShowOverlay()
				else
					RSGeneralDB.RemoveOverlayActive()
				end
			else
				self:ShowOverlay()
			end
		end

		-- Refresh minimap
		RSMinimap.RefreshAllData(true)
	elseif (button == "RightButton") then
		-- If guide showing then hide it
		local guideEntityID = RSGeneralDB.GetGuideActive()
		if (guideEntityID) then
			self:GetMap():RemoveAllPinsByTemplate("RSGuideTemplate");
			if (guideEntityID ~= self.POI.entityID) then
				self:ShowGuide(true)
			else
				RSGeneralDB.RemoveGuideActive()
			end
		else
			self:ShowGuide(true)
		end

		-- Refresh minimap
		RSMinimap.RefreshAllData(true)
		
		-- Hide the tooltip
		if (RSTooltip.HideTooltip(self.tooltip)) then
			self.tooltip = nil
		end
	end
end

function RSEntityPinMixin:ShowOverlay()
	-- Overlay
	local overlay = nil
	if (self.POI.isNpc) then
		overlay = RSNpcDB.GetInternalNpcOverlay(self.POI.entityID, self.POI.mapID)
	elseif (self.POI.isContainer) then
		overlay = RSContainerDB.GetInternalContainerOverlay(self.POI.entityID, self.POI.mapID)
	end

	if (overlay) then
		for _, coordinates in ipairs (overlay) do
			local x, y = strsplit("-", coordinates)
			self:GetMap():AcquirePin("RSOverlayTemplate", tonumber(x), tonumber(y), self);
		end
		RSGeneralDB.SetOverlayActive(self.POI.entityID)
	else
		RSGeneralDB.RemoveOverlayActive()
	end
end

function RSEntityPinMixin:ShowGuide(onclick)
	-- Guide
	local guide = nil
	if (self.POI.isNpc) then
		guide = RSGuideDB.GetNpcGuide(self.POI.entityID)
	elseif (self.POI.isContainer) then
		guide = RSGuideDB.GetContainerGuide(self.POI.entityID)
	else
		guide = RSGuideDB.GetEventGuide(self.POI.entityID)
	end

	if (guide) then
		for pinType, info in pairs (guide) do
			-- Skip if quest completed
			if (not info.questID or not C_QuestLog.IsQuestFlaggedCompleted(info.questID)) then
				local POI = RSGuidePOI.GetGuidePOI(self.POI.entityID, pinType, info)
				local pin = self:GetMap():AcquirePin("RSGuideTemplate", POI, self);

				if (onclick) then
					pin.ShowPingAnim:Play()
				end
			end
		end
		RSGeneralDB.SetGuideActive(self.POI.entityID)
	else
		RSGeneralDB.RemoveGuideActive()
	end
end

function RSEntityPinMixin:OnReleased()
	RSTooltip.ReleaseTooltip(self.tooltip)
	self.tooltip = nil
end
