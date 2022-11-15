local AddonName, Data = ...

Data.Mixins = Data.Mixins or {}

local BackportedScrollBoxSelectorMixin = {};

function BackportedScrollBoxSelectorMixin:OnShow()
	if not self.initialized then
		self:Init();
	end
end

function BackportedScrollBoxSelectorMixin:Init()
	local view = CreateScrollBoxListGridView(self:GetStride());

	view:SetElementExtent(self:GetButtonHeight());
	view:SetPadding(self:GetPadding());

	local function InitializeGridSelectorScrollButton(button, selectionIndex)
		self:RunSetup(button, selectionIndex);
	end

	local templateType, buttonTemplate = self:GetButtonTemplate();
	--view:SetElementInitializer(buttonTemplate, InitializeGridSelectorScrollButton); this is the original, this results in CreateFrame("Buttontemplate") which is not what we watned
	view:SetElementInitializer(templateType, buttonTemplate, InitializeGridSelectorScrollButton);

	ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, view);

	self.initialized = true;

	self:UpdateSelections();
end

function BackportedScrollBoxSelectorMixin:UpdateSelections()
	if self.initialized then
		local dataProvider = CreateIndexRangeDataProvider(self:GetNumSelections());
		self.ScrollBox:SetDataProvider(dataProvider);
	end
end

function BackportedScrollBoxSelectorMixin:EnumerateButtons()
	local enumerateFramesIteratorFunction, table, initialIteratorKey = self.ScrollBox:EnumerateFrames();
	local savedKey = initialIteratorKey;
	local function GridSelectorScrollEnumerateButtons(tbl)
		local nextKey, nextValue = enumerateFramesIteratorFunction(tbl, savedKey);
		savedKey = nextKey;
		return nextValue;
	end

	return GridSelectorScrollEnumerateButtons, table, initialIteratorKey;
end

function BackportedScrollBoxSelectorMixin:SetCustomButtonHeight(customButtonHeight)
	self.customButtonHeight = customButtonHeight;
end

function BackportedScrollBoxSelectorMixin:GetButtonHeight()
	return self.customButtonHeight or 36;
end

function BackportedScrollBoxSelectorMixin:SetCustomStride(customStride)
	self.customStride = customStride;
end

function BackportedScrollBoxSelectorMixin:GetStride()
	return self.customStride or 10;
end

function BackportedScrollBoxSelectorMixin:SetCustomPadding(top, bottom, left, right, horizontalSpacing, verticalSpacing)
	self.top = top;
	self.bottom = bottom;
	self.left = left;
	self.right = right;
	self.horizontalSpacing = horizontalSpacing;
	self.verticalSpacing = verticalSpacing;
end

function BackportedScrollBoxSelectorMixin:GetPadding()
	return self.top or 5, self.bottom or 5, self.left or 5, self.right or 5, self.horizontalSpacing or 10, self.verticalSpacing or 10;
end

function BackportedScrollBoxSelectorMixin:AdjustScrollBarOffsets(offsetX, topOffset, bottomOffset)
	self.ScrollBar:SetPoint("TOPRIGHT", offsetX or 0, topOffset or 0);
	self.ScrollBar:SetPoint("BOTTOMRIGHT", offsetX or 0, bottomOffset or 0);
end

function BackportedScrollBoxSelectorMixin:ScrollToSelectedIndex()
	local targetIndex = self:GetSelectedIndex() or 1;
	self:ScrollToElementDataIndex(targetIndex, ScrollBoxConstants.AlignCenter, ScrollBoxConstants.NoScrollInterpolation);
end

function BackportedScrollBoxSelectorMixin:ScrollToElementDataIndex(...)
	self.ScrollBox:ScrollToElementDataIndex(...);
end

Data.Mixins.BackportedScrollBoxSelectorMixin = BackportedScrollBoxSelectorMixin