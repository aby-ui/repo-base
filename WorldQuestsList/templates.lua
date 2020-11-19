WQL_AreaPOIPinMixin = CreateFromMixins(AreaPOIPinMixin)

function WQL_AreaPOIPinMixin:TryShowTooltip()
	local description = self.description;

	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip_SetTitle(GameTooltip, self.name, HIGHLIGHT_FONT_COLOR);

	if description then
		GameTooltip_AddNormalLine(GameTooltip, description);
	end

	if type(self.itemID)=='number' then
		EmbeddedItemTooltip_SetItemByID(GameTooltip.ItemTooltip, self.itemID)
	elseif type(self.itemID)=='table' then
		EmbeddedItemTooltip_SetItemByID(GameTooltip.ItemTooltip, self.itemID[1])
	end

	GameTooltip:Show();
	return true;
end

function WQL_AreaPOIPinMixin:OnMouseEnter()
	if not self.name or #self.name == 0 then
		return;
	end

	self.UpdateTooltip = function() self:OnMouseEnter(); end;

	if not self:TryShowTooltip() then
		self:GetMap():TriggerEvent("SetAreaLabel", MAP_AREA_LABEL_TYPE.POI, self.name, self.description);
	end
end

function WQL_AreaPOIPinMixin:OnMouseLeave()
	self:GetMap():TriggerEvent("ClearAreaLabel", MAP_AREA_LABEL_TYPE.POI);

	GameTooltip:Hide();
end

function WQL_AreaPOIPinMixin:OnAcquired(poiInfo) -- override
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

	self.areaPoiID = poiInfo.areaPoiID;
	
	self.clickData = poiInfo.clickData;
	
	self.itemID = poiInfo.itemID
end

function WQL_AreaPOIPinMixin:OnClick(button)
	WorldQuestList.hookClickFunc(self,button)
end




WQL_WayPinMixin = CreateFromMixins(AreaPOIPinMixin)

function WQL_WayPinMixin:TryShowTooltip()
	return
end

function WQL_WayPinMixin:OnMouseEnter()

end

function WQL_WayPinMixin:OnMouseLeave()

end

function WQL_WayPinMixin:OnAcquired(poiInfo) -- override
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

	self.areaPoiID = poiInfo.areaPoiID;
	
	self.clickData = poiInfo.clickData;

	self.waypoint = poiInfo.data;
	
	self:SetSize(20*poiInfo.size,20*poiInfo.size)
	self.Texture:SetSize(20*poiInfo.size,20*poiInfo.size)
end

function WQL_WayPinMixin:OnClick(button)
	WorldQuestList:WaypointRemove(self.waypoint)
end



WQL_HolidayPinMixin = CreateFromMixins(WQL_WayPinMixin)

function WQL_HolidayPinMixin:OnMouseEnter()
	self:GetMap():TriggerEvent("SetAreaLabel", MAP_AREA_LABEL_TYPE.POI, self.name, self.description);
end

function WQL_HolidayPinMixin:OnMouseLeave()
	self:GetMap():TriggerEvent("ClearAreaLabel", MAP_AREA_LABEL_TYPE.POI);
end
function WQL_HolidayPinMixin:SetTexture(poiInfo)
	self.Texture:SetTexture(poiInfo.texture);

	local sizeX, sizeY = self.Texture:GetSize();
	self:SetSize(sizeX, sizeY);

	self.Texture:SetTexCoord(0, 1, 0, 1);
end
function WQL_HolidayPinMixin:OnAcquired(poiInfo) -- override
	BaseMapPoiPinMixin.OnAcquired(self, poiInfo);

	self.areaPoiID = poiInfo.areaPoiID;
	
	self.clickData = poiInfo.clickData;

	self.data = poiInfo.data;
	
	self:SetSize(20*poiInfo.size,20*poiInfo.size)
	self.Texture:SetSize(20*poiInfo.size,20*poiInfo.size)
end

function WQL_HolidayPinMixin:OnClick(button)
	local data = self.clickData
	local continentID, worldPos = C_Map.GetWorldPosFromMapPos(data.mapID, CreateVector2D(data.x, data.y))
	if worldPos then
		local wy,wx = worldPos:GetXY()
		if wx and wy then
			WorldQuestList.AddArrow(wx,wy,nil,self.data[8])
		end
	end
	WorldQuestList.AddArrowNWC(data.x,data.y,data.mapID,0,self.data[8])

	local uiMapPoint = UiMapPoint.CreateFromCoordinates(data.mapID, data.x, data.y)
	C_Map.SetUserWaypoint(uiMapPoint)
	C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end