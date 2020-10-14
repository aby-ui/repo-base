-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

local HBD_Pins = LibStub("HereBeDragons-Pins-2.0")

-- RareScanner libraries
local RSConstants = private.ImportLib("RareScannerConstants")

-- RareScanner database libraries
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")

-- RareScanner services
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")
 
RSMinimapPinMixin = {}

function RSMinimapPinMixin:OnEnter()
	GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	if (self.POI.name) then
	 GameTooltip:SetText(self.POI.name)
	elseif (self.POI.tooltip) then
    if (self.POI.tooltip.title) then
      GameTooltip_SetTitle(GameTooltip, self.POI.tooltip.title);
    end
    
    if (self.POI.tooltip.comment) then
      GameTooltip_AddNormalLine(GameTooltip, self.POI.tooltip.comment);
    end
	end
	GameTooltip:Show()
end
 
function RSMinimapPinMixin:OnLeave()
	GameTooltip:Hide()
end

function RSMinimapPinMixin:ShowOverlay()
	if (not self.overlayFramesPool) then
		self.overlayFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
	end
	
	local overlay = nil
	if (self.POI.isNpc) then
	 overlay = RSNpcDB.GetInternalNpcOverlay(self.POI.entityID, self.POI.mapID)
	elseif (self.POI.isContainer) then
	 overlay = RSContainerDB.GetInternalContainerOverlay(self.POI.entityID, self.POI.mapID)
	end  
	
	if (overlay) then
		for _, coordinates in ipairs (overlay) do
			local x, y = strsplit("-", coordinates)
			local pin = self.overlayFramesPool:Acquire()
			pin.POI = self.POI
			pin.Texture:SetTexture(RSConstants.OVERLAY_SPOT_TEXTURE)
			HBD_Pins:AddMinimapIconMap(self, pin, self.POI.mapID, tonumber(x), tonumber(y), false, false)
		end
	end
end

function RSMinimapPinMixin:ShowGuide()
  if (not self.guideFramesPool) then
    self.guideFramesPool = CreateFramePool("FRAME", Minimap, "RSMinimapPinTemplate");
  end
  
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
      if (not info.questID or not C_QuestLog.IsQuestFlaggedCompleted(info.questID)) then
        local POI = RSGuidePOI.GetGuidePOI(self.POI.entityID, pinType, info)
        local pin = self.guideFramesPool:Acquire()
        pin.POI = POI
        pin.Texture:SetTexture(POI.texture)
        pin.Texture:SetScale(RSConfigDB.GetIconsMinimapScale())
        HBD_Pins:AddMinimapIconMap(self, pin, self.POI.mapID, POI.x, POI.y, false, false)
      end
    end
  end
end