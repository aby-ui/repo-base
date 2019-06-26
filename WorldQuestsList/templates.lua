WQL_AreaPOIPinMixin = CreateFromMixins(AreaPOIPinMixin)

function WQL_AreaPOIPinMixin:TryShowTooltip()
	local description = self.description;

	WorldMapTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
	GameTooltip_SetTitle(WorldMapTooltip, self.name, HIGHLIGHT_FONT_COLOR);

	if description then
		GameTooltip_AddNormalLine(WorldMapTooltip, description);
	end

	if type(self.itemID)=='number' then
		EmbeddedItemTooltip_SetItemByID(WorldMapTooltip.ItemTooltip, self.itemID)
	elseif type(self.itemID)=='table' then
		EmbeddedItemTooltip_SetItemByID(WorldMapTooltip.ItemTooltip, self.itemID[1])
	end

	WorldMapTooltip:Show();
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

	WorldMapTooltip:Hide();
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