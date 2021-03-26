local Addon = select(2, ...)
local Slider = Addon:CreateClass('Slider')

do
	local nextName = Addon:CreateNameGenerator('Slider')

	local getOrCall = function(self, v, ...)
		if type(v) == 'function' then
			return v(self, ...)
		end
		return v
	end

	local function editBox_OnEditFocusGained(self)
		self:HighlightText(0, #self:GetText())
	end

	local function editBox_OnEditFocusLost(self)
		self:GetParent():UpdateText()
	end

	local function editBox_OnTextChanged(self)
		local value = tonumber(self:GetText())
		local current = self:GetParent():GetValue()

		if value and value ~= current then
			self:GetParent():TrySetValue(value, self:GetParent().softLimits)
		end
	end

	local function editBox_OnEscapePressed(self)
		self:ClearFocus()
	end

	-- a hacky way to go to the next edit box
	-- with the assumption we only care about edit boxes that are
	-- valText properties of other elements
	local function editBox_FocusNext(self, ...)
		local editBoxes = {}

		local index = nil
		for i = 1, select('#', ...) do
			local vt = select(i, ...).valText
			if vt and vt:GetObjectType() == 'EditBox' then
				table.insert(editBoxes, vt)

				if vt == self then
					index = i
				end
			end
		end

		editBoxes[index % #editBoxes + 1]:SetFocus()
	end

	local function editBox_OnTabPressed(self)
		editBox_FocusNext(self, self:GetParent():GetParent():GetChildren())

		local value = self:GetNumber()
		local current = self:GetParent():GetValue()

		if value and value ~= current then
			self:GetParent():TrySetValue(value, self:GetParent().softLimits)
		end
	end

	function Slider:New(options)
		local f = self:Bind(CreateFrame('Slider', nextName(), options.parent, 'HorizontalSliderTemplate'))

		f.min = options.min or 0
		f.max = options.max or 100
		f.step = options.step or 1
		f.softLimits = options.softLimits
		f.GetSavedValue = options.get
		f.SetSavedValue = options.set
		f.format = options.format

		f.text = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLeft')
		f.text:SetPoint('BOTTOMLEFT', f, 'TOPLEFT')
		f.text:SetText(options.name or '')

		f:SetSize(268, 18)
		f:EnableMouseWheel(true)
		f:SetValueStep(f.step)
		f:SetObeyStepOnDrag(true)

		local editBox = CreateFrame('EditBox', nil, f)
		editBox:SetPoint('BOTTOMRIGHT', f, 'TOPRIGHT')
		editBox:SetNumeric(false)
		editBox:SetAutoFocus(false)
		editBox:SetFontObject('GameFontHighlightRight')
		editBox:SetHeight(f.text:GetHeight() * 1.25)
		editBox:SetWidth(f.text:GetHeight() * 3)
		editBox:HighlightText(0, 0)
		editBox:SetScript('OnTextChanged', editBox_OnTextChanged)
		editBox:SetScript('OnEditFocusGained', editBox_OnEditFocusGained)
		editBox:SetScript('OnEditFocusLost', editBox_OnEditFocusLost)
		editBox:SetScript('OnEscapePressed', editBox_OnEscapePressed)

		-- clear focus when enter is pressed (minor quality of life preference)
		editBox:SetScript('OnEnterPressed', editBox_OnEscapePressed)
		editBox:SetScript('OnTabPressed', editBox_OnTabPressed)

		local bg = editBox:CreateTexture(nil, 'BACKGROUND')
		bg:SetAllPoints(bg:GetParent())
		bg:SetColorTexture(0.2, 0.2, 0.2, 0.5)
		editBox.bg = bg
		f.valText = editBox

		-- register Events
		f:SetScript('OnShow', f.OnShow)
		f:SetScript('OnValueChanged', f.OnValueChanged)
		f:SetScript('OnMouseWheel', f.OnMouseWheel)

		return f
	end

	--[[ Frame Events ]]--

	function Slider:TrySetValue(value, breakLimits)
		local min, max = self:GetMinMaxValues()

		if breakLimits then
			local changed = false
			if value < min then
				min = value
				changed = true
			elseif value > max then
				max = value
				changed = true
			end

			if changed then
				self:SetMinMaxValues(min, max)
			end
		else
			value = Clamp(value, min, max)
		end

		if value ~= self:GetValue() then
			self:SetValue(value)
		end
	end

	function Slider:OnShow()
		Addon:Render(self)
	end

	function Slider:OnRender()
		self:UpdateRange()
		self:UpdateValue()
	end

	function Slider:OnValueChanged(value)
		self:SetSavedValue(value)
		self:UpdateText(value)
	end

	function Slider:OnMouseWheel(direction)
		local value = self:GetValue()
		local step = self:GetValueStep() * direction

		self:TrySetValue(value + step, self.softLimits and IsModifierKeyDown())
	end

	--[[ Update Methods ]]--

	function Slider:GetEffectiveSize()
		local width, height = self:GetSize()

		height = height + self.text:GetHeight()

		return width, height
	end

	function Slider:SetSavedValue(value)
		assert(false, 'Hey, you forgot to set SetSavedValue for ' .. self:GetName())
	end

	function Slider:GetSavedValue()
		assert(false, 'Hey, you forgot to set GetSavedValue for ' .. self:GetName())
	end

	function Slider:UpdateRange()
		local min = getOrCall(self, self.min)
		local max = getOrCall(self, self.max)
		local value = self:GetSavedValue()

		if self.softLimits then
			min = math.min(value, min)
			max = math.max(value, max)
		end

		local oldMin, oldMax = self:GetMinMaxValues()
		if oldMin ~= min or oldMax ~= max then
			if min < max then
				self:SetEnabled(true)
				self:SetMinMaxValues(min, max)
			else
				self:SetEnabled(false)
				-- self:SetMinMaxValues(0, 1)
			end
		end

		local step = getOrCall(self, self.step)
		if step ~= self:GetValueStep() then
			self:SetValueStep(step)
		end
	end

	function Slider:UpdateValue()
		local min, max = self:GetMinMaxValues()
		local value = self:GetSavedValue()

		self:SetValue(Clamp(value, min, max))
		self:SetEnabled(min < max)
	end

	function Slider:UpdateText(value)
		value = value or self:GetSavedValue()

		if type(self.format) == "function" then
			self.valText:SetText(self:format(value))
		elseif type(self.format) == "string" then
			self.valText:SetText(self.format:format(value))
		else
			self.valText:SetText(value)
		end
	end

	function Slider:SetEnabled(enable)
		if enable then
			self.text:SetVertexColor(NORMAL_FONT_COLOR.r , NORMAL_FONT_COLOR.g , NORMAL_FONT_COLOR.b)
			self:Enable()
		else
			self.text:SetVertexColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
			self:Disable()
		end
	end
end

Addon.Slider = Slider
