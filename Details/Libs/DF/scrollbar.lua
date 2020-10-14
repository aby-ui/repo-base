
local DF = _G ["DetailsFramework"]
if (not DF or not DetailsFrameworkCanLoad) then
	return 
end

function DF:CreateScrollBar (master, slave, x, y)
	return DF:NewScrollBar (master, slave, x, y)
end

function DF:NewScrollBar (master, slave, x, y)

	local new_slider = CreateFrame ("Slider", nil, master,"BackdropTemplate")
	new_slider.scrollMax = 560 --default - tamanho da janela de fundo

	-- ///// SLIDER /////
	new_slider:SetPoint ("TOPLEFT", master, "TOPRIGHT", x, y)
	new_slider.ativo = true
	
	new_slider.bg = new_slider:CreateTexture (nil, "BACKGROUND")
	new_slider.bg:SetAllPoints (true)
	new_slider.bg:SetTexture (0, 0, 0, 0)
	--coisinha do meio
	new_slider.thumb = new_slider:CreateTexture (nil, "OVERLAY")
	new_slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	new_slider.thumb:SetSize (29, 30)
	new_slider:SetThumbTexture (new_slider.thumb)
	
	new_slider:SetOrientation ("VERTICAL")
	new_slider:SetSize(16, 100)
	new_slider:SetMinMaxValues(0, new_slider.scrollMax)
	new_slider:SetValue(0)
	new_slider.ultimo = 0

	local botao_cima = CreateFrame ("Button", nil, master,"BackdropTemplate")
	
	botao_cima:SetPoint ("BOTTOM", new_slider, "TOP", 0, -12)
	botao_cima.x = 0
	botao_cima.y = -12
	
	botao_cima:SetWidth (29)
	botao_cima:SetHeight (32)
	botao_cima:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	botao_cima:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	botao_cima:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	botao_cima:Show()
	botao_cima:Disable()
	
	local botao_baixo = CreateFrame ("Button", nil, master,"BackdropTemplate")
	botao_baixo:SetPoint ("TOP", new_slider, "BOTTOM", 0, 12)
	botao_baixo.x = 0
	botao_baixo.y = 12
	
	botao_baixo:SetWidth (29)
	botao_baixo:SetHeight (32)
	botao_baixo:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Up")
	botao_baixo:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Down")
	botao_baixo:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollDownButton-Disabled")	
	botao_baixo:Show()
	botao_baixo:Disable()

	master.baixo = botao_baixo
	master.cima = botao_cima
	master.slider = new_slider
	
	botao_baixo:SetScript ("OnMouseDown", function(self)
		if (not new_slider:IsEnabled()) then
			return
		end
		
		local current = new_slider:GetValue()
		local minValue, maxValue = new_slider:GetMinMaxValues()
		if (current+5 < maxValue) then
			new_slider:SetValue (current+5)
		else
			new_slider:SetValue (maxValue)
		end
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = new_slider:GetValue()
				local minValue, maxValue = new_slider:GetMinMaxValues()
				if (current+2 < maxValue) then
					new_slider:SetValue (current+2)
				else
					new_slider:SetValue (maxValue)
				end
			end
		end)
	end)
	botao_baixo:SetScript ("OnMouseUp", function(self) 
		self.precionado = false
		self:SetScript ("OnUpdate", nil)
	end)	
	
	botao_cima:SetScript ("OnMouseDown", function(self) 
		if (not new_slider:IsEnabled()) then
			return
		end
		
		local current = new_slider:GetValue()
		if (current-5 > 0) then
			new_slider:SetValue (current-5)
		else
			new_slider:SetValue (0)
		end	
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = new_slider:GetValue()
				if (current-2 > 0) then
					new_slider:SetValue (current-2)
				else
					new_slider:SetValue (0)
				end
			end
		end)
	end)
	botao_cima:SetScript ("OnMouseUp", function(self) 
		self.precionado = false
		self:SetScript ("OnUpdate", nil)
	end)
	--> isso aqui pra quando o slider ativar, o scroll fica na  posi��o zero
	botao_cima:SetScript ("OnEnable", function (self)
		local current = new_slider:GetValue()
		if (current == 0) then
			botao_cima:Disable()
		end
	end)

	new_slider:SetScript ("OnValueChanged", function (self)
		local current = self:GetValue()
		master:SetVerticalScroll (current)
		
		local minValue, maxValue = new_slider:GetMinMaxValues()
		
		if (current == minValue) then
			botao_cima:Disable()
		elseif (not botao_cima:IsEnabled()) then
			botao_cima:Enable()
		end
		
		if (current == maxValue) then
			botao_baixo:Disable()
		elseif (not botao_baixo:IsEnabled()) then
			botao_baixo:Enable()
		end

	end)

	new_slider:SetScript ("OnShow", function (self)
		botao_cima:Show()
		botao_baixo:Show()
	end)
	
	new_slider:SetScript ("OnDisable", function (self)
		botao_cima:Disable()
		botao_baixo:Disable()
	end)
	
	new_slider:SetScript ("OnEnable", function (self)
		botao_cima:Enable()
		botao_baixo:Enable()
	end)
	
	master:SetScript ("OnMouseWheel", function (self, delta)
		if (not new_slider:IsEnabled()) then
			return
		end

		local current = new_slider:GetValue()
		if (delta < 0) then 
			--baixo
			local minValue, maxValue = new_slider:GetMinMaxValues()
			if (current + (master.wheel_jump or 20) < maxValue) then
				new_slider:SetValue (current + (master.wheel_jump or 20))
			else
				new_slider:SetValue (maxValue)
			end
		elseif (delta > 0) then
			--cima
			if (current + (master.wheel_jump or 20) > 0) then
				new_slider:SetValue (current - (master.wheel_jump or 20))
			else
				new_slider:SetValue (0)
			end
		end
	end)
	
	function new_slider:Altura (h)
		self:SetHeight (h)
	end
	
	function new_slider:Update (desativar)
	
		if (desativar) then
			new_slider:Disable()
			new_slider:SetValue(0)
			new_slider.ativo = false
			master:EnableMouseWheel (false)
			return
		end
	
		self.scrollMax = slave:GetHeight()-master:GetHeight()
		if (self.scrollMax > 0) then
			new_slider:SetMinMaxValues (0, self.scrollMax)
			if (not new_slider.ativo) then
				new_slider:Enable()
				new_slider.ativo = true
				master:EnableMouseWheel (true)
			end
		else
			new_slider:Disable()
			new_slider:SetValue(0)
			new_slider.ativo = false
			master:EnableMouseWheel (false)
		end
	end
	
	function new_slider:cimaPoint (x, y)
		botao_cima:SetPoint ("BOTTOM", new_slider, "TOP", x, (y)-12)
	end
	
	function new_slider:baixoPoint (x, y)
		botao_baixo:SetPoint ("TOP", new_slider, "BOTTOM", x, (y)+12)
	end
	
	return new_slider
end
