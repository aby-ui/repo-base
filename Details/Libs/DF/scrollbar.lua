
--note: this scroll bar is using legacy code and shouldn't be used on creating new stuff

local DF = _G["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return
end

function DF:CreateScrollBar(master, scrollContainer, x, y)
	return DF:NewScrollBar(master, scrollContainer, x, y)
end

function DF:NewScrollBar(parent, scrollContainer, x, y)
	local newSlider = CreateFrame("Slider", nil, parent, "BackdropTemplate")
	newSlider.scrollMax = 560

	newSlider:SetPoint("TOPLEFT", parent, "TOPRIGHT", x, y)
	newSlider.ativo = true

	newSlider.bg = newSlider:CreateTexture(nil, "BACKGROUND")
	newSlider.bg:SetAllPoints(true)
	newSlider.bg:SetTexture(0, 0, 0, 0)

	newSlider.thumb = newSlider:CreateTexture(nil, "OVERLAY")
	newSlider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	newSlider.thumb:SetSize(29, 30)
	newSlider:SetThumbTexture(newSlider.thumb)
	newSlider:SetOrientation("VERTICAL")
	newSlider:SetSize(16, 100)
	newSlider:SetMinMaxValues(0, newSlider.scrollMax)
	newSlider:SetValue(0)
	newSlider.ultimo = 0

	local upButton = CreateFrame("Button", nil, parent,"BackdropTemplate")

	upButton:SetPoint("BOTTOM", newSlider, "TOP", 0, -12)
	upButton.x = 0
	upButton.y = -12

	upButton:SetWidth(29)
	upButton:SetHeight(32)
	upButton:SetNormalTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	upButton:SetPushedTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	upButton:SetDisabledTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	upButton:Show()
	upButton:Disable()

	local downDutton = CreateFrame("Button", nil, parent,"BackdropTemplate")
	downDutton:SetPoint("TOP", newSlider, "BOTTOM", 0, 12)
	downDutton.x = 0
	downDutton.y = 12

	downDutton:SetWidth(29)
	downDutton:SetHeight(32)
	downDutton:SetNormalTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Up")
	downDutton:SetPushedTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Down")
	downDutton:SetDisabledTexture("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Disabled")	
	downDutton:Show()
	downDutton:Disable()

	parent.baixo = downDutton
	parent.cima = upButton
	parent.slider = newSlider

	downDutton:SetScript("OnMouseDown", function(self)
		if (not newSlider:IsEnabled()) then
			return
		end

		local current = newSlider:GetValue()
		local minValue, maxValue = newSlider:GetMinMaxValues()
		if (current + 5 < maxValue) then
			newSlider:SetValue(current + 5)
		else
			newSlider:SetValue(maxValue)
		end
		self.precionado = true
		self.last_up = -0.3
		self:SetScript("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = newSlider:GetValue()
				local minValue, maxValue = newSlider:GetMinMaxValues()
				if (current + 2 < maxValue) then
					newSlider:SetValue(current + 2)
				else
					newSlider:SetValue(maxValue)
				end
			end
		end)
	end)

	downDutton:SetScript("OnMouseUp", function(self)
		self.precionado = false
		self:SetScript("OnUpdate", nil)
	end)

	upButton:SetScript("OnMouseDown", function(self)
		if (not newSlider:IsEnabled()) then
			return
		end

		local current = newSlider:GetValue()
		if (current - 5 > 0) then
			newSlider:SetValue(current - 5)
		else
			newSlider:SetValue(0)
		end

		self.precionado = true
		self.last_up = -0.3
		self:SetScript("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = newSlider:GetValue()
				if (current - 2 > 0) then
					newSlider:SetValue(current - 2)
				else
					newSlider:SetValue(0)
				end
			end
		end)
	end)

	upButton:SetScript("OnMouseUp", function(self)
		self.precionado = false
		self:SetScript("OnUpdate", nil)
	end)

	upButton:SetScript("OnEnable", function(self)
		local current = newSlider:GetValue()
		if (current == 0) then
			upButton:Disable()
		end
	end)

	newSlider:SetScript("OnValueChanged", function(self)
		local current = self:GetValue()
		parent:SetVerticalScroll(current)

		local minValue, maxValue = newSlider:GetMinMaxValues()

		if (current == minValue) then
			upButton:Disable()
		elseif (not upButton:IsEnabled()) then
			upButton:Enable()
		end

		if (current == maxValue) then
			downDutton:Disable()
		elseif (not downDutton:IsEnabled()) then
			downDutton:Enable()
		end
	end)

	newSlider:SetScript("OnShow", function(self)
		upButton:Show()
		downDutton:Show()
	end)

	newSlider:SetScript("OnDisable", function(self)
		upButton:Disable()
		downDutton:Disable()
	end)

	newSlider:SetScript("OnEnable", function(self)
		upButton:Enable()
		downDutton:Enable()
	end)

	parent:SetScript("OnMouseWheel", function(self, delta)
		if (not newSlider:IsEnabled()) then
			return
		end

		local current = newSlider:GetValue()
		if (delta < 0) then
			local minValue, maxValue = newSlider:GetMinMaxValues()
			if (current + (parent.wheel_jump or 20) < maxValue) then
				newSlider:SetValue(current + (parent.wheel_jump or 20))
			else
				newSlider:SetValue(maxValue)
			end
		elseif (delta > 0) then
			if (current + (parent.wheel_jump or 20) > 0) then
				newSlider:SetValue(current - (parent.wheel_jump or 20))
			else
				newSlider:SetValue(0)
			end
		end
	end)

	function newSlider:Altura(height)
		self:SetHeight(height)
	end

	function newSlider:Update(desativar)
		if (desativar) then
			newSlider:Disable()
			newSlider:SetValue(0)
			newSlider.ativo = false
			parent:EnableMouseWheel(false)
			return
		end

		self.scrollMax = scrollContainer:GetHeight() - parent:GetHeight()
		if (self.scrollMax > 0) then
			newSlider:SetMinMaxValues(0, self.scrollMax)
			if (not newSlider.ativo) then
				newSlider:Enable()
				newSlider.ativo = true
				parent:EnableMouseWheel(true)
			end
		else
			newSlider:Disable()
			newSlider:SetValue(0)
			newSlider.ativo = false
			parent:EnableMouseWheel(false)
		end
	end

	function newSlider:cimaPoint(x, y)
		upButton:SetPoint("BOTTOM", newSlider, "TOP", x, y - 12)
	end

	function newSlider:baixoPoint(x, y)
		downDutton:SetPoint("TOP", newSlider, "BOTTOM", x, y + 12)
	end

	return newSlider
end
