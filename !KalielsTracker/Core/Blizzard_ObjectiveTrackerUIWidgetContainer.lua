KT_ObjectiveTrackerUIWidgetContainerMixin = {};

local function WidgetsLayout(widgetContainer, sortedWidgets)
	DefaultWidgetLayout(widgetContainer, sortedWidgets);

	-- When the widgets in this container update we also need to update the KT_UI_WIDGET_TRACKER_MODULE (it needs to show or hide based on whether there are any widget showing)
	KT_ObjectiveTracker_Update(KT_OBJECTIVE_TRACKER_UPDATE_MODULE_UI_WIDGETS);
end

function KT_ObjectiveTrackerUIWidgetContainerMixin:OnLoad()
	UIWidgetContainerMixin.OnLoad(self);
	local setID = C_UIWidgetManager.GetObjectiveTrackerWidgetSetID();
	self:RegisterForWidgetSet(setID, WidgetsLayout);
end

-- SetParent to block, anchor and set alpha to 1
function KT_ObjectiveTrackerUIWidgetContainerMixin:AttachToBlockAndShow(block)
	self:SetParent(block);
	self:SetPoint("TOP", block, "TOP", 0, 0);
	self:SetAlpha(1);	-- Use alpha for showing and hiding the widget container because we still need to get updates when it is hidden (so we can add the block and re-parent again)
end

-- SetParent to UIParent and set alpha to 0. This is so we continue to get updates when widgets are shown, allowing us to add the tracker block again
function KT_ObjectiveTrackerUIWidgetContainerMixin:UnattachFromBlockAndHide()
	self:SetAlpha(0);
	self:SetParent(UIParent);
end

KT_UI_WIDGET_TRACKER_MODULE = KT_ObjectiveTracker_GetModuleInfoTable("KT_UI_WIDGET_TRACKER_MODULE", nil, "KT_ObjectiveTrackerUIWidgetBlock");
KT_UI_WIDGET_TRACKER_MODULE.updateReasonModule = KT_OBJECTIVE_TRACKER_UPDATE_MODULE_UI_WIDGETS;
KT_UI_WIDGET_TRACKER_MODULE:SetHeader(KT_ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader, GetRealZoneText(), KT_OBJECTIVE_TRACKER_UPDATE_MODULE_UI_WIDGETS);

function KT_UI_WIDGET_TRACKER_MODULE:Update()
	self:BeginLayout();

	-- We only ever use a single block for the widget container
	local block = self:GetBlock(1);

	-- We add or remove the block based on whether there are any widgets showing
	if KT_ObjectiveTrackerUIWidgetContainer:GetNumWidgetsShowing() > 0 then
		-- If there are widgets showing, add the block
		if not KT_ObjectiveTracker_AddBlock(block) then
			block.used = false;
		end
	else
		block.used = false;
	end

	if block.used then
		-- This means there ARE widgets showing...attach the widget container to the new block and "show" it (alpha to 1)
		KT_ObjectiveTrackerUIWidgetContainer:AttachToBlockAndShow(block);
		block:Show();
		block:MarkDirty();
		block.height = block:GetHeight();
	else
		-- This means there are no widgets showing or we could not add the block...unattach the widget container and "hide" it (alpha to 0 so we still get updates on it)
		KT_ObjectiveTrackerUIWidgetContainer:UnattachFromBlockAndHide();
	end

	self:EndLayout();
end

-- This is only needed to update the Header text when the zone changes
KT_ObjectiveTrackerUIWidgetBlockMixin = {};

function KT_ObjectiveTrackerUIWidgetBlockMixin:OnLoad()
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
end

function KT_ObjectiveTrackerUIWidgetBlockMixin:OnEvent(event, ...)
	KT_UI_WIDGET_TRACKER_MODULE:SetHeader(KT_ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader, GetRealZoneText(), KT_OBJECTIVE_TRACKER_UPDATE_MODULE_UI_WIDGETS);
end
