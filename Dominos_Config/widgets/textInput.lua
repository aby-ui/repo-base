--[[ a textarea control implementation ]]--

local Addon = select(2, ...)

local EditBox = Addon:CreateClass('EditBox')

local function editBox_Save(self)
	self.owner:Save(self:GetText())
end

local function editBox_OnSizeChanged(self)
	self.owner:OnSizeChanged()
end

do
	function EditBox:New(parent, owner)
		local editBox = self:Bind(CreateFrame('EditBox', nil, parent))

		editBox.owner = owner or parent
		editBox:SetAutoFocus(false)
		editBox:SetMultiLine(true)
		editBox:SetFontObject('GameFontHighlight')
		editBox:SetJustifyH('LEFT')
		editBox:SetJustifyV('TOP')

		editBox.Save = Addon:Debounce(editBox_Save, 300)
		editBox.OnSizeChanged = Addon:Debounce(editBox_OnSizeChanged, 100)

		editBox:SetScript('OnShow', self.OnShow)
		editBox:SetScript('OnEscapePressed', self.OnEscapePressed)
		editBox:SetScript('OnEnterPressed', self.OnEnterPressed)
		editBox:SetScript('OnTextChanged', self.OnTextChanged)
		editBox:SetScript('OnEditFocusGained', self.OnEditFocusGained)
		editBox:SetScript('OnEditFocusLost', self.OnEditFocusLost)
		editBox:SetScript('OnSizeChanged', editBox.OnSizeChanged)

		return editBox
	end

	function EditBox:OnShow()
		self:SetText(self.owner:GetSavedValue() or '')
	end

	function EditBox:OnEnterPressed()
		self:Save()
	end

	function EditBox:OnTextChanged()
		self:Save()
	end

	function EditBox:OnEscapePressed()
		self:ClearFocus()
	end

	function EditBox:OnEditFocusGained()
		self:HighlightText()
		self.owner:OnEditFocusGained()
	end

	function EditBox:OnEditFocusLost()
		self:HighlightText(0, 0)
		self:Save()
	end
end


local TextInput = Addon:CreateClass('Frame')
do
	TextInput.inset = 4
	TextInput.scrollBarSize = 4

	function TextInput:New(options)
		local panel = self:Bind(CreateFrame('Frame', nil, options.parent))

		local label = panel:CreateFontString(nil, 'OVERLAY')
		label:SetFontObject('GameFontNormalLeft')
		label:SetText(options.name)
		label:SetPoint('TOPLEFT', self.inset, 0)
		label:SetPoint('TOPRIGHT', -self.inset, 0)
		panel.label = label

		local editBox = EditBox:New(panel)
		editBox:SetPoint('TOPLEFT', label, 'BOTTOMLEFT', 0, -2)
		editBox:SetPoint('TOPRIGHT', label, 'BOTTOMRIGHT', 0, -2)
		panel.editBox = editBox

		local viewport = CreateFrame('ScrollFrame', nil, panel)
		viewport:SetScrollChild(panel.editBox)
		viewport:SetPoint('TOPLEFT', label, 'BOTTOMLEFT', 0, -2)
		viewport:EnableMouse(true)
		viewport:SetScript('OnMouseUp', function() editBox:SetFocus() end)
		viewport:SetScript('OnMouseWheel', function(_, delta)
			local scrollBar = panel.vScrollBar
			if scrollBar:IsShown() then
				scrollBar:GetScript('OnMouseWheel')(scrollBar, delta)
			end
		end)
		panel.viewport = viewport

		local vScrollBar = panel:CreateVerticalScrollBar()
		vScrollBar:SetPoint('TOPRIGHT', label, 'BOTTOMRIGHT', 0, -2)
		panel.vScrollBar = vScrollBar

		local bg = panel:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(viewport)
		bg:SetColorTexture(0.2, 0.2, 0.2, 0.5)
		editBox.bg = bg

		-- set events
		panel.GetSavedValue = options.get
		panel.SetSavedValue = options.set
		panel:SetScript('OnSizeChanged', self.OnSizeChanged)

		return panel
	end

	function TextInput:OnRender()
		-- update the size of the scroll frame
		local viewportWidth, viewportHeight = self:GetSize()

		-- subtract insets
		viewportWidth = viewportWidth - (self.inset * 2)
		viewportHeight = viewportHeight - (self.inset * 2)

		-- subtract label height
		viewportHeight = viewportHeight - self.label:GetHeight()

		-- look at the editbox height to determine if we need to show scrollbars or not
		local editBoxHeight = self.editBox:GetHeight()
		local showVScrollBar = false
		if viewportHeight < editBoxHeight then
			viewportWidth = viewportWidth - self.scrollBarSize
			showVScrollBar = true
		end

		-- update scroll frame size
		self.viewport:SetSize(viewportWidth, viewportHeight)
		self.editBox:SetWidth(viewportWidth)

		-- update scroll bar visibility and bounds
		if showVScrollBar then
			self.vScrollBar:SetSize(self.scrollBarSize, viewportHeight)
			self.vScrollBar:SetMinMaxValues(0, editBoxHeight - viewportHeight)
			self.vScrollBar:SetValue(self.viewport:GetVerticalScroll())
			self.vScrollBar:Show()
			self.vScrollBar:SetValue(editBoxHeight - viewportHeight)
		elseif self.vScrollBar:IsShown() then
			self.vScrollBar:Hide()
			self.viewport:SetVerticalScroll(0)
		end
	end

	function TextInput:OnSizeChanged()
		Addon:Render(self)
	end

	function TextInput:OnEditFocusGained()
		self.vScrollBar:SetValue(0)
	end

	--[[ the values of values ]]--

	function TextInput:Save(value)
		self:SetSavedValue(value)
	end

	function TextInput:SetSavedValue(value) end

	function TextInput:GetSavedValue() end

	function TextInput:GetEffectiveSize()
		return self:GetSize()
	end

	--[[ helpers ]]--

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

		function TextInput:CreateScrollBar(orientation)
			local scrollBar = CreateFrame('Slider', nil, self)
			scrollBar:EnableMouseWheel(true)

			local bg = scrollBar:CreateTexture(nil, 'BACKGROUND')
			bg:SetColorTexture(0, 0, 0, 0.5)
			bg:SetAllPoints(scrollBar)

			local tt = scrollBar:CreateTexture(nil, 'OVERLAY')
			tt:SetColorTexture(0.3, 0.3, 0.3, 0.8)
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
			local editBoxHeight = self:GetParent().editBox:GetHeight()

			if editBoxHeight > 0 then
				self:GetThumbTexture():SetHeight(height * (viewportHeight / editBoxHeight))
			else
				self:GetThumbTexture():SetHeight(height)
			end
		end

		function TextInput:CreateVerticalScrollBar()
			local vScrollBar = self:CreateScrollBar('VERTICAL')

			vScrollBar:Hide()
			vScrollBar:SetScript('OnValueChanged', vScrollBar_OnValueChanged)
			vScrollBar:SetScript('OnSizeChanged', vScrollBar_OnSizeChanged)

			return vScrollBar
		end
	end
end
Addon.TextInput = TextInput