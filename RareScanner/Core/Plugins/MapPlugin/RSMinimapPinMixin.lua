-----------------------------------------------------------------------
-- AddOn namespace.
-----------------------------------------------------------------------
local LibStub = _G.LibStub
local ADDON_NAME, private = ...

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