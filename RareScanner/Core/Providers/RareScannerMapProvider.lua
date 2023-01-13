-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

-- Locales
local AL = LibStub("AceLocale-3.0"):GetLocale("RareScanner");

-- RareScanner database libraries
local RSGeneralDB = private.ImportLib("RareScannerGeneralDB")
local RSGuideDB = private.ImportLib("RareScannerGuideDB")
local RSContainerDB = private.ImportLib("RareScannerContainerDB")
local RSConfigDB = private.ImportLib("RareScannerConfigDB")
local RSNpcDB = private.ImportLib("RareScannerNpcDB")
local RSEventDB = private.ImportLib("RareScannerEventDB")

-- RareScanner general libraries
local RSLogger = private.ImportLib("RareScannerLogger")
local RSUtils = private.ImportLib("RareScannerUtils")
local RSConstants = private.ImportLib("RareScannerConstants")

-- RareScanner services libraries
local RSMinimap = private.ImportLib("RareScannerMinimap")
local RSMap = private.ImportLib("RareScannerMap")
local RSTooltip = private.ImportLib("RareScannerTooltip")
local RSGuidePOI = private.ImportLib("RareScannerGuidePOI")

RareScannerDataProviderMixin = CreateFromMixins(MapCanvasDataProviderMixin);

function RareScannerDataProviderMixin:OnAdded(mapCanvas)
	MapCanvasDataProviderMixin.OnAdded(self, mapCanvas);
	self:GetMap():RegisterCallback("SetBounty", self.SetBounty, self);
end

function RareScannerDataProviderMixin:OnRemoved(mapCanvas)
	self:GetMap():UnregisterCallback("SetBounty", self.SetBounty, self);
	MapCanvasDataProviderMixin.OnRemoved(self, mapCanvas);
end

function RareScannerDataProviderMixin:SetBounty(bountyQuestID, bountyFactionID, bountyFrameType)
	local changed = self.bountyQuestID ~= bountyQuestID;
	if (changed) then
		self.bountyQuestID = bountyQuestID;
		self.bountyFactionID = bountyFactionID;
		self.bountyFrameType = bountyFrameType;
		if (self:GetMap()) then
			self:RefreshAllData();
		end
	end
end

function RareScannerDataProviderMixin:GetBountyInfo()
	return self.bountyQuestID, self.bountyFactionID, self.bountyFrameType;
end

function RareScannerDataProviderMixin:OnMapChanged()
	self:RefreshAllData();
end

function RareScannerDataProviderMixin:OnHide()
	self:RemoveAllData()
end

function RareScannerDataProviderMixin:RemoveAllData()
	self:GetMap():RemoveAllPinsByTemplate("RSEntityPinTemplate");
	self:GetMap():RemoveAllPinsByTemplate("RSOverlayTemplate");
	self:GetMap():RemoveAllPinsByTemplate("RSGuideTemplate");
	self:GetMap():RemoveAllPinsByTemplate("RSGroupPinTemplate");
end

function RareScannerDataProviderMixin:ShowGuideLayer(entityID, mapID)
	-- Gets the information of the entity
	local guide = nil
	local isNpc = false
	local isContainer = false
	local isEvent = false
	if (RSNpcDB.GetInternalNpcInfo(entityID)) then
		guide = RSGuideDB.GetNpcGuide(entityID, mapID)
		isNpc = true
	elseif (RSContainerDB.GetInternalContainerInfo(entityID)) then
		guide = RSGuideDB.GetContainerGuide(entityID, mapID)
		isContainer = true
	else 
		guide = RSGuideDB.GetEventGuide(entityID, mapID)
		isEvent = true
	end

	if (guide) then
		for pinType, info in pairs (guide) do
			local POI = RSGuidePOI.GetGuidePOI(entityID, pinType, info)
			if (not info.questID or not C_QuestLog.IsQuestFlaggedCompleted(info.questID)) then
				local guidePin = self:GetMap():AcquirePin("RSGuideTemplate", POI);
				if ((isNpc and not RSNpcDB.IsInternalNpcInMap(entityID, mapID)) or (isContainer and not RSContainerDB.IsInternalContainerInMap(entityID, mapID)) or (isEvent and not RSEventDB.IsInternalEventInMap(entityID, mapID))) then
					guidePin.ShowPingAnim:SetLooping("REPEAT")
					guidePin.ShowPingAnim:Play()
				else
					guidePin.ShowPingAnim:SetLooping("NONE")
					guidePin.ShowPingAnim:Play()
				end
			end
		end
	end
end

function RareScannerDataProviderMixin:RefreshAllData(fromOnShow)
	self:RemoveAllData()

	local mapID = self:GetMap():GetMapID();
	RSLogger:PrintDebugMessage(string.format("MAPID [%s], ARTID [%s]", mapID, C_Map.GetMapArtID(mapID)))

	-- Loads new pins
	local POIs = RSMap.GetMapPOIs(mapID, true, false)
	if (not POIs) then
		return
	end

	-- Add tooltips to ingame vignettes
	local parentFrame = self
	for pin in self:GetMap():EnumeratePinsByTemplate("VignettePinTemplate") do
		if (pin:GetObjectGUID() and not pin.initialized) then
			-- Saves name if we dont have it
			if (pin:GetVignetteType() == Enum.VignetteType.Treasure) then
				local _, _, _, _, _, vignetteObjectID = strsplit("-", pin:GetObjectGUID())
				local containerID = tonumber(vignetteObjectID)
				if (not RSContainerDB.GetContainerName(containerID) and pin:GetVignetteName()) then
					RSContainerDB.SetContainerName(containerID, pin:GetVignetteName())
				end
			elseif (pin:GetVignetteType() == Enum.VignetteType.Normal) then
				-- If container
				if (RSConstants.IsContainerAtlas(pin.vignetteInfo.atlasName)) then
					local _, _, _, _, _, vignetteObjectID = strsplit("-", pin:GetObjectGUID())
					local containerID = tonumber(vignetteObjectID)
					if (not RSContainerDB.GetContainerName(containerID) and pin:GetVignetteName()) then
						RSContainerDB.SetContainerName(containerID, pin:GetVignetteName())
					end
				-- If NPC
				elseif (RSConstants.IsNpcAtlas(pin.vignetteInfo.atlasName)) then
					local _, _, _, _, _, vignetteObjectID = strsplit("-", pin:GetObjectGUID())
					local npcID = tonumber(vignetteObjectID)
					if (pin:GetVignetteName()) then
						RSNpcDB.SetNpcName(npcID, pin:GetVignetteName())
					end
				end
			end
			
			pin:HookScript("OnEnter", function(self)
				if (not RSConfigDB.IsShowingTooltipsOnIngameIcons()) then
					self.hasTooltip = true
					return
				end
				
				local POI = RSMap.GetWorldMapPOI(self:GetObjectGUID(), self:GetVignetteType(), pin.vignetteInfo.atlasName, self:GetMap():GetMapID())
				if (POI) then
					self.POI = POI
					-- Just in case the user didnt have the questID when he found it
					if (POI.isOpened) then
						RSContainerDB.DeleteContainerOpened(POI.entityID)
					elseif (POI.isDead) then
						RSNpcDB.DeleteNpcKilled(POI.entityID)
					end
					self.hasTooltip = false
					RSTooltip.ShowSimpleTooltip(self)
				else
					self.tooltip = nil
					self.POI = nil
				end
			end)
			pin:HookScript("OnLeave", function(self)
				if (not RSConfigDB.IsShowingTooltipsOnIngameIcons()) then
					return
				end
				
				pin.POI = nil
				if (RSTooltip.HideTooltip(self.tooltip)) then
					pin.tooltip = nil
				end
			end)
			pin:HookScript("OnMouseDown", function(self, button)		
				local POI = RSMap.GetWorldMapPOI(self:GetObjectGUID(), self:GetVignetteType(), pin.vignetteInfo.atlasName, self:GetMap():GetMapID())
				if (not POI) then	
					return
				end
						
				if (button == "LeftButton") then
					--Toggle state
					if (IsShiftKeyDown() and IsAltKeyDown()) then
						if (POI.isNpc) then
							RSConfigDB.SetNpcFiltered(POI.entityID, false)
							self:Hide();
						elseif (POI.isContainer) then
							RSConfigDB.SetContainerFiltered(POI.entityID, false)
							self:Hide();
						elseif (POI.isEvent) then
							RSConfigDB.SetEventFiltered(POI.entityID, false)
							self:Hide();
						end
						RSMinimap.RefreshEntityState(POI.entityID)
					end
				elseif (button == "RightButton") then
					-- If already showing a guide toggle it first
					if (self:GetMap():GetNumActivePinsByTemplate("RSGuideTemplate") > 0) then	
						self:GetMap():RemoveAllPinsByTemplate("RSGuideTemplate");
											
						local guideEntityID = RSGeneralDB.GetGuideActive()
						if (guideEntityID) then
							-- If same guide showing then disable it
							if (guideEntityID ~= POI.entityID) then
								RSGeneralDB.SetGuideActive(POI.entityID)
								parentFrame:ShowGuideLayer(POI.entityID, self:GetMap():GetMapID())
							else
								RSGeneralDB.RemoveGuideActive()
							end
						end
					-- Otherwise show it
					else
						RSGeneralDB.SetGuideActive(POI.entityID)
						parentFrame:ShowGuideLayer(POI.entityID, self:GetMap():GetMapID())
					end

					-- Refresh minimap
					RSMinimap.RefreshAllData(true)
				end
			end)
		
			pin:SetPassThroughButtons("MiddleButton");
			RSLogger:PrintDebugMessage(string.format("Sobreescrito contenedor del mapa del mundo: %s, [%s]", pin:GetObjectGUID(), pin:GetVignetteType()))
			pin.initialized = true
		end
	end

	-- Adds all the POIs to the WorldMap
	local currentGuideActive = nil
	for _, POI in ipairs (POIs) do
		-- Skip if an ingame vignette is already showing this entity (on AreaPOIPinTemplate)
		-- Only vignettes on WorldMap are actually shown in this layer
		-- If its a group it doesn't matter, because there are several entities inside
		local filtered = false
		if (POI.isNpc) then
			for pin in self:GetMap():EnumeratePinsByTemplate("AreaPOIPinTemplate") do
				if (pin.name == POI.name) then
					RSLogger:PrintDebugMessageEntityID(POI.entityID, string.format("Saltado NPC [%s]: Hay un vignette del juego mostrándolo (AreaPOI).", POI.entityID))
					filtered = true
				end
			end
		end

		-- If the entity is only available when shown in the world map, there is no need to fill the map with useless icons
		if (POI.worldmap) then
			filtered = true
		elseif (POI.isGroup) then
			for _, subPOI in ipairs(POI.POIs) do
				if (subPOI.isContainer and subPOI.worldmap) then
					filtered = true
					break
				end
			end
		end

		if (not filtered) then
			local pin
			if (POI.isGroup) then
				pin = self:GetMap():AcquirePin("RSGroupPinTemplate", POI, self);

				-- Animates the ping in case the filter is on
				if (RSGeneralDB.GetWorldMapTextFilter()) then
					pin.ShowPingAnim:Play();
				end

				-- Adds children overlay/guide
				for _, childPOI in ipairs (POI.POIs) do
					-- Adds overlay if active
					-- Avoids adding multiple spots if the entity spawns in multiple places at the same time
					if (RSGeneralDB.HasOverlayActive(childPOI.entityID) and (not currentGuideActive or currentGuideActive ~= childPOI.entityID)) then
						pin:ShowOverlay(childPOI)
						currentGuideActive = childPOI.entityID
					end
				end
			else
				RSLogger:PrintDebugMessageEntityID(POI.entityID, string.format("Mostrando Entidad [%s].", POI.entityID))
				pin = self:GetMap():AcquirePin("RSEntityPinTemplate", POI, self);

				-- Animates the ping in case the filter is on
				if (RSGeneralDB.GetWorldMapTextFilter()) then
					pin.ShowPingAnim:Play();
				end

				-- Adds overlay if active
				-- Avoids adding multiple spots if the entity spawns in multiple places at the same time
				if (RSGeneralDB.HasOverlayActive(POI.entityID) and (not currentGuideActive or currentGuideActive ~= POI.entityID)) then
					RSLogger:PrintDebugMessageEntityID(POI.entityID, string.format("Mostrando Overlay [%s].", POI.entityID))
					pin:ShowOverlay()
					currentGuideActive = POI.entityID
				end
			end
		end
	end
	
	-- Adds guidance icons to the WorldMap
	if (RSGeneralDB.GetGuideActive()) then
		self:ShowGuideLayer(RSGeneralDB.GetGuideActive(), mapID)
	end
end
