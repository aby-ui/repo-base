local Addon = select(2, ...)
local ScrollableContainer = Addon:CreateClass('Frame')

ScrollableContainer.scrollBarSize = 8

function ScrollableContainer:New(parent)
	local panel = self:Bind(CreateFrame('Frame', nil, parent))
	panel:SetScript('OnSizeChanged', self.OnSizeChanged)

	local vScrollBar = panel:CreateVerticalScrollBar()
	vScrollBar:SetPoint('TOPLEFT', panel, 'TOPRIGHT', -self.scrollBarSize, 0)
	vScrollBar:SetPoint('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', 0, self.scrollBarSize)
	panel.vScrollBar = vScrollBar

	local hScrollBar = panel:CreateHorizontalScrollBar()
	hScrollBar:SetPoint('TOPLEFT', panel, 'BOTTOMLEFT', 0, self.scrollBarSize)
	hScrollBar:SetPoint('BOTTOMRIGHT', panel, 'BOTTOMRIGHT', -self.scrollBarSize, 0)
	panel.hScrollBar = hScrollBar

	local viewport = CreateFrame('ScrollFrame', nil, panel)
	viewport:SetPoint('TOPLEFT')
	viewport:SetPoint('BOTTOMRIGHT', -self.scrollBarSize, self.scrollBarSize)
	viewport:EnableMouseWheel(true)

	viewport:SetScript('OnMouseWheel', function(_, delta)
		local scrollBar = panel.vScrollBar
		if scrollBar:IsShown() then
			scrollBar:GetScript('OnMouseWheel')(scrollBar, delta)
		end
	end)

	panel.viewport = viewport
	return panel
end

function ScrollableContainer:OnSizeChanged()
	Addon:Render(self)
end

function ScrollableContainer:SetChild(child)
	self.viewport:SetScrollChild(child)
	self.viewport:SetHorizontalScroll(0)
	self.viewport:SetVerticalScroll(0)

	Addon:Render(self)
end

function ScrollableContainer:GetChildSize()
	local child = self.viewport:GetScrollChild()

	if child then
		return child:GetSize()
	end
	return 0, 0
end

function ScrollableContainer:OnRender()
	local maxWidth, maxHeight = self:GetSize()
	local childWidth, childHeight = self:GetChildSize()

	local viewportXOffset, viewportYOffset
	if childWidth > maxWidth then
		self.hScrollBar:SetMinMaxValues(0, childWidth - maxWidth)
		self.hScrollBar:SetValue(self.viewport:GetHorizontalScroll())
		self.hScrollBar:Show()
		viewportYOffset = self.scrollBarSize
	else
		self.hScrollBar:SetMinMaxValues(0, 0)
		self.hScrollBar:SetValue(0)
		self.hScrollBar:Hide()
		viewportYOffset = 0
	end

	if childHeight > maxHeight then
		self.vScrollBar:SetMinMaxValues(0, childHeight - maxHeight)
		self.vScrollBar:SetValue(self.viewport:GetVerticalScroll())
		self.vScrollBar:Show()
		viewportXOffset = -self.scrollBarSize
	else
		self.vScrollBar:SetMinMaxValues(0, 0)
		self.vScrollBar:SetValue(0)
		self.vScrollBar:Hide()
		viewportXOffset = 0
	end

	self.viewport:SetPoint('BOTTOMRIGHT', viewportXOffset, viewportYOffset)
end

do
	local function scrollBar_OnMouseWheel(self, delta)
		local min, max = self:GetMinMaxValues()
		local value = self:GetValue()
		local step = max/5

		if IsShiftKeyDown() and (delta > 0) then
			self:SetValue(min)
		elseif IsShiftKeyDown() and (delta < 0) then
			self:SetValue(max)
		elseif (delta < 0) and (value < max) then
			self:SetValue(math.min(value + step, max))
		elseif (delta > 0) and (value > min) then
			self:SetValue(math.max(value - step, min))
		end
	end

	function ScrollableContainer:CreateScrollBar(orientation)
		local scrollBar = CreateFrame('Slider', nil, self)
		scrollBar:EnableMouseWheel(true)

		local bg = scrollBar:CreateTexture(nil, 'BACKGROUND')
		bg:SetColorTexture(0.3, 0.3, 0.3, 0.5)
		bg:SetAllPoints(scrollBar)

		local tt = scrollBar:CreateTexture(nil, 'OVERLAY')
		tt:SetColorTexture(0.3, 0.3, 0.3, 1)
		tt:SetSize(self.scrollBarSize, self.scrollBarSize)
		scrollBar:SetThumbTexture(tt)

		scrollBar:EnableMouseWheel(true)
		scrollBar:SetScript('OnMouseWheel', scrollBar_OnMouseWheel)
		scrollBar:SetOrientation(orientation)
		scrollBar:Hide()

		return scrollBar
	end
end

do
	local function vScrollBar_OnValueChanged(self, value)
		self:GetParent().viewport:SetVerticalScroll(value)
	end

	local function vScrollBar_OnSizeChanged(self)
		local height = self:GetHeight()
		local viewportHeight = self:GetParent().viewport:GetHeight()
		local childHeight = select(2, self:GetParent():GetChildSize())

		if childHeight > 0 then
			self:GetThumbTexture():SetHeight(height * (viewportHeight / childHeight))
		else
			self:GetThumbTexture():SetHeight(height)
		end
	end

	function ScrollableContainer:CreateVerticalScrollBar()
		local vScrollBar = self:CreateScrollBar('VERTICAL')

		vScrollBar:SetScript('OnValueChanged', vScrollBar_OnValueChanged)
		vScrollBar:SetScript('OnSizeChanged', vScrollBar_OnSizeChanged)

		return vScrollBar
	end
end

do
	local function hScrollBar_OnValueChanged(self, value)
		self:GetParent().viewport:SetHorizontalScroll(value)
	end

	local function hScrollBar_OnSizeChanged(self)
		local width = self:GetWidth()
		local viewportWidth = self:GetParent().viewport:GetWidth()
		local childWidth = self:GetParent():GetChildSize()

		if childWidth > 0 then
			self:GetThumbTexture():SetWidth(width * (viewportWidth / childWidth))
		else
			self:GetThumbTexture():SetWidth(width)
		end
	end

	function ScrollableContainer:CreateHorizontalScrollBar()
		local hScrollBar = self:CreateScrollBar('HORIZONTAL')

		hScrollBar:SetScript('OnValueChanged', hScrollBar_OnValueChanged)
		hScrollBar:SetScript('OnSizeChanged', hScrollBar_OnSizeChanged)

		return hScrollBar
	end
end

--[[ exports ]]--

Addon.ScrollableContainer = ScrollableContainer