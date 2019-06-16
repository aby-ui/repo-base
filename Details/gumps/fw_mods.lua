
local cstr = tostring
local _string_len = string.len
local ceil = math.ceil
local math_floor = math.floor
local CreateFrame = CreateFrame
local GetTime = GetTime
local GetCursorPosition = GetCursorPosition
local GameTooltip = GameTooltip
local _select = select

local _detalhes = 		_G._detalhes
local gump = 			_detalhes.gump


function gump:NewLabel2 (parent, container, member, text, font, size, color)

	font = font or "GameFontHighlightSmall"

	local newFontString = parent:CreateFontString (nil, "OVERLAY", font)
	if (member) then
		container [member] = newFontString
	end
	newFontString:SetText (text)
	
	if (size) then
		_detalhes:SetFontSize (newFontString, size)
	end
	
	if (color) then
		newFontString:SetTextColor (unpack (color))
	end
	
	newFontString:SetJustifyH ("LEFT")
	
	return newFontString
end

function gump:NewDetailsButton (parent, container, instancia, func, param1, param2, w, h, pic_up, pic_down, pic_disabled, pic_highlight, options, FrameName, inherits, ischeck)

	if (not parent) then
		return nil
	end
	
	w = w or 16
	h = h or 16
	options = options or {}

	local new_button
	if (ischeck) then
		new_button = CreateFrame ("CheckButton", FrameName, parent, inherits)
	else
		new_button = CreateFrame ("Button", FrameName, parent)
	end

	new_button:SetWidth (w)
	new_button:SetHeight (h)
	
	if (not pic_down and pic_up) then
		pic_down = pic_up
	end
	if (not pic_disabled and pic_up) then
		pic_disabled = pic_up
	end
	if (not pic_highlight and pic_up) then
		pic_highlight = pic_up
	end
	
	new_button:SetNormalTexture (pic_up)
	new_button:SetPushedTexture (pic_down)
	new_button:SetDisabledTexture (pic_disabled)
	new_button:SetHighlightTexture (pic_highlight, "ADD")

	local new_text = new_button:CreateFontString (nil, "OVERLAY", "GameFontNormal")
	new_text:SetPoint ("center", new_button, "center")
	new_button.text = new_text
	
	new_button.supportFrame = CreateFrame ("frame", nil, new_button)
	new_button.supportFrame:SetPoint ("topleft", new_button, "topleft")
	new_button.supportFrame:SetPoint ("bottomright", new_button, "bottomright")
	new_button.supportFrame:SetFrameLevel (new_button:GetFrameLevel()+1)

	new_button.supportFrame.disable_overlay = new_button.supportFrame:CreateTexture (nil, "overlay")
	new_button.supportFrame.disable_overlay:SetTexture ("Interface\\AddOns\\Details\\images\\button_disable_overlay")
	new_button.supportFrame.disable_overlay:SetPoint ("topleft", new_button.supportFrame, "topleft")
	new_button.supportFrame.disable_overlay:SetPoint ("bottomright", new_button.supportFrame, "bottomright")
	new_button.supportFrame.disable_overlay:Hide()
	
	local rightFunction = options.rightFunc

	new_button:SetScript ("OnDisable", function()
		new_button.supportFrame.disable_overlay:Show()
	end)
	new_button:SetScript ("OnEnable", function()
		new_button.supportFrame.disable_overlay:Hide()
	end)
	
	new_button.funcParam1 = param1
	new_button.funcParam2 = param2
	new_button.options = options
	
	function new_button:ChangeOptions (_table)
		options = _table
		rightFunction = options.rightFunc
	end
	
	new_button.enter = false
	
	new_button:SetScript ("OnMouseDown", function(self, button)
		if (not self:IsEnabled()) then
			return
		end

		self.mouse_down = GetTime()
		local x, y = GetCursorPosition()
		self.x = math_floor (x)
		self.y = math_floor (y)
	
		if (container) then
			if (container:IsMovable() and not container.isLocked) then
				container:StartMoving()
				container.isMoving = true
			end
		end
		
		if (new_button.texture) then
			new_button.texture:SetTexCoord (0, 1, 0.5, 0.74609375)
		end
		
		if (options.OnGrab and options.OnGrab == "PassClick") then
			if (rightFunction) then 
				if (button == "LeftButton") then
					func (new_button.funcParam1, new_button.funcParam2)
				else
					rightFunction.func (rightFunction.param1, rightFunction.param2)
				end
			else
				func (new_button.funcParam1, new_button.funcParam2)
			end
		end
	end)

	new_button:SetScript ("OnMouseUp", function (self, button)
		if (not self:IsEnabled()) then
			return
		end
		
		if (container) then
			if (container.isMoving) then
				container:StopMovingOrSizing()
				container.isMoving = false
				if (instancia) then
					instancia:SaveMainWindowPosition()
				end
			end
		end
		
		if (new_button.texture) then
			if (new_button.enter) then 
				new_button.texture:SetTexCoord (0, 1, 0.25, 0.49609375)
			else
				new_button.texture:SetTexCoord (0, 1, 0, 0.24609375)
			end
		end
		
		local x, y = GetCursorPosition()
		x = math_floor (x)
		y = math_floor (y)
		if ((self.mouse_down+0.4 > GetTime() and (x == self.x and y == self.y)) or (x == self.x and y == self.y)) then
			if (rightFunction) then 
				if (button == "LeftButton") then
					func (new_button.funcParam1, new_button.funcParam2)
				else
					rightFunction.func (rightFunction.param1, rightFunction.param2)
				end
			else
				func (new_button.funcParam1, new_button.funcParam2)
			end		
		end
	end)
	
	new_button.tooltip = nil
	
	new_button:SetScript ("OnEnter", function() 
	
		new_button.enter = true
	
		if (new_button.tooltip) then 
			GameCooltip:Reset()
			GameCooltip:SetType ("tooltip")
			GameCooltip:SetColor ("main", "transparent")
			GameCooltip:AddLine (new_button.tooltip)
			GameCooltip:SetOwner (new_button)
			GameCooltip:ShowCooltip()
		end
		
		if (new_button.texture) then
			new_button.texture:SetTexCoord (0, 1, 0.25+(0.0078125/2), 0.5+(0.0078125/2))
		end
		
		if (new_button.MouseOnEnterHook) then 
			new_button.MouseOnEnterHook (new_button)
		end
	end)
	
	new_button:SetScript ("OnLeave", function() 
	
		new_button.enter = false
	
		if (new_button.tooltip) then 
			_detalhes.popup:ShowMe (false)
		end
		
		if (new_button.texture) then
			new_button.texture:SetTexCoord (0, 1, 0, 0.24609375)
		end
		
		if (new_button.MouseOnLeaveHook) then 
			new_button.MouseOnLeaveHook (new_button)
		end
	end)
	
	function new_button:ChangeIcon (icon1, icon2, icon3, icon4)
		new_button:SetNormalTexture (icon1)
		new_button:SetPushedTexture (icon2)
		new_button:SetDisabledTexture (icon3)
		new_button:SetHighlightTexture (icon4, "ADD")
	end
	
	function new_button:InstallCustomTexture (texture, rect)
		new_button:SetNormalTexture(nil)
		new_button:SetPushedTexture(nil)
		new_button:SetDisabledTexture(nil)
		new_button:SetHighlightTexture(nil)
		texture = texture or "Interface\\AddOns\\Details\\images\\default_button"
		new_button.texture = new_button:CreateTexture (nil, "background")
		
		if (not rect) then 
			new_button.texture:SetAllPoints (new_button)
		else
			new_button.texture:SetPoint ("topleft", new_button, "topleft", rect.x1, rect.y1)
			new_button.texture:SetPoint ("bottomright", new_button, "bottomright", rect.x2, rect.y2)
		end
		
		new_button.texture:SetTexCoord (0, 1, 0, 0.24609375)
		new_button.texture:SetTexture (texture)
	end
	
	new_button.textColor = {}
	new_button.textColor.r, new_button.textColor.g, new_button.textColor.b = new_button.text:GetTextColor()
	
	return new_button
end

local EditBoxBackdrop = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = true, edgeSize = 1, tileSize = 5,
}

function gump:NewTextBox (parent, container, member, func, param1, param2, w, h, options)

	local editbox = CreateFrame ("EditBox", "DetailsEditBox1", parent)
	container [member] = editbox
	options = options or {}
	
	editbox:SetAutoFocus (false)
	editbox:SetFontObject (GameFontHighlightSmall)
	
	editbox:SetWidth (w)
	editbox:SetHeight (h)
	editbox:SetJustifyH("CENTER")
	editbox:EnableMouse (true)
	editbox:SetBackdrop (EditBoxBackdrop)
	editbox:SetBackdropColor (0, 0, 0, 0.5)
	editbox:SetBackdropBorderColor (0.3, 0.3, 0.30, 0.80)
	editbox:SetText ("") --localize-me
	
	editbox.perdeu_foco = nil
	
	editbox.text = ""
	editbox.next = options.next
	editbox.tooltip = options.tooltip
	editbox.tab_on_enter = options.TabOnEnterPress
	editbox.space = options.MySpace
	
	gump:NewLabel (editbox, editbox, nil, "label", "", "GameFontHighlightSmall")
	editbox ["label"]: SetPoint ("right", editbox, "left", -2, 0)
	editbox.label:SetTextColor (.8, .8, .8, 1)
	
	function editbox:SetPointAndSpace (MyAnchor, SnapTo, HisAnchor, x, y, Width)
	
		if (type (MyAnchor) == "boolean" and MyAnchor and editbox.space) then
			local textWidth = editbox ["label"]:GetStringWidth()+2
			editbox:SetWidth (editbox.space - textWidth - 15)
			return
			
		elseif (not editbox.space and not Width) then 
			return
		elseif (Width) then
			editbox.space = Width
		end
		
		if (editbox.space) then 
			editbox ["label"]:ClearAllPoints()
			editbox:ClearAllPoints()
			editbox ["label"]:SetPoint (MyAnchor, SnapTo, HisAnchor, x, y)
			editbox:SetPoint ("left", editbox["label"].widget, "right", 2, 0)
			
			local textWidth = editbox ["label"]:GetStringWidth()+2
			editbox:SetWidth (editbox.space - textWidth - 15)
		end
	end
	
	function editbox:SetLabelText (text)
		if (text) then
			editbox ["label"]:SetText (text)
		else
			editbox ["label"]:SetText ("")
		end
		
		if (editbox.space) then
			editbox:SetPointAndSpace (true) --> refresh
		end
	end

	local EnterPress = function (byScript) 
	
		if (editbox.EnterHook) then 
			editbox.EnterHook()
		end
	
		local texto = _detalhes:trim (editbox:GetText())
		if (_string_len (texto) > 0) then 
			editbox.text = texto
			if (func) then 
				func (param1, param2, texto, editbox, byScript)
			end
		else 
			editbox:SetText ("")
			editbox.text = ""
		end 
		editbox.perdeu_foco = true --> isso aqui pra quando estiver editando e clicar em outra caixa
		editbox:ClearFocus()
		
		if (editbox.tab_on_enter and editbox.next) then
			editbox.next:SetFocus()
		end
	end
	
	function editbox:PressEnter (byScript)
		EnterPress (byScript)
	end
	
	editbox:SetScript ("OnEnterPressed", EnterPress)
	
	editbox:SetScript ("OnEscapePressed", function() 
		editbox:SetText("") 
		editbox.text = ""
		editbox.perdeu_foco = true
		editbox:ClearFocus() 
		
		if (editbox.OnEscapeHook) then
			editbox.OnEscapeHook()
		end
	end)
	
	editbox:SetScript ("OnEnter", function() 
		editbox.mouse_over = true 
		if (editbox:IsEnabled()) then 
			editbox:SetBackdropBorderColor (0.5, 0.5, 0.5, 1)
		end
		if (editbox.tooltip) then 
			GameCooltip:Reset()
			GameCooltip:SetType ("tooltip")
			GameCooltip:SetColor ("main", "transparent")
			GameCooltip:AddLine (editbox.tooltip)
			GameCooltip:SetOwner (editbox)
			GameCooltip:ShowCooltip()
		end
		
		if (editbox.OnEnterHook) then
			editbox:OnEnterHook()
		end
	end)
	
	editbox:SetScript ("OnLeave", function() 
		editbox.mouse_over = false 
		if (editbox:IsEnabled()) then 
			editbox:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
		end
		
		if (not editbox:HasFocus()) then 
			--if (editbox:GetText() == "") then 
			--	editbox:SetText("insira o nome do buff") 
			--end 
		end 
		
		if (editbox.tooltip) then 
			if (not editbox.HaveMenu) then
				_detalhes.popup:ShowMe (false)
			end
		end
		
		if (editbox.OnLeaveHook) then
			editbox:OnLeaveHook()
		end
		
	end)

	editbox:SetScript ("OnEditFocusGained", function()
		if (editbox.label) then
			editbox.label:SetTextColor (1, 1, 1, 1)
		end
		if (editbox.OnFocusGainedHook) then
			editbox.OnFocusGainedHook()
		end
	end)
	
	editbox:SetScript ("OnEditFocusLost", function()

		if (editbox:IsShown()) then
			if (editbox.perdeu_foco == nil) then
				local texto = _detalhes:trim (editbox:GetText())
					if (_string_len (texto) > 0) then 
					editbox.text = texto
					if (func) then 
						func (param1, param2, texto, editbox, nil)
					end
				else 
					editbox:SetText ("") 
				end 
			else
				editbox.perdeu_foco = nil
			end
			
			if (editbox.label) then
				editbox.label:SetTextColor (.8, .8, .8, 1)
			end
			
			if (editbox.OnFocusLostHook) then
				editbox.OnFocusLostHook()
			end
		end
	end)
	
	editbox:SetScript ("OnChar", function (self, text) 
		if (editbox.InputHook) then 
			editbox:InputHook (text)
		end
	end)
	
	editbox:SetScript ("OnTextChanged", function (self, userChanged)
		if (editbox.TextChangeedHook and userChanged) then 
			editbox:TextChangeedHook (userChanged)
		end
	end)
	
	editbox:SetScript ("OnTabPressed", function() 
		if (editbox.next) then 
			EnterPress()
			editbox.next:SetFocus()
		end
	end)
	
	editbox.SetNext = function (_, NextBox)
		if (NextBox) then
			editbox.next = NextBox
		end
	end
	
	editbox.SetLabel = function (_, Label)
		if (Label) then
			editbox.label = Label
			editbox.label:SetTextColor (.8, .8, .8, 1)
		end
	end
	
	function editbox:Blink()
		editbox.label:SetTextColor (1, .2, .2, 1)
	end
	
	if (options.Label) then
		editbox:SetLabel (options.Label)
	end
	
	options = nil
	
	return editbox
end

function gump:NewScrollBar2 (master, slave, x, y)

	local slider_gump = CreateFrame ("Slider", master:GetName() and master:GetName() .. "SliderGump" or "DetailsSliderGump" .. math.random (1, 10000000), master)
	slider_gump.scrollMax = 560 --default - tamanho da janela de fundo

	-- ///// SLIDER /////
	slider_gump:SetPoint ("TOPLEFT", master, "TOPRIGHT", x, y)
	slider_gump.ativo = true
	
	slider_gump.bg = slider_gump:CreateTexture (nil, "BACKGROUND")
	slider_gump.bg:SetAllPoints (true)
	slider_gump.bg:SetTexture (0, 0, 0, 0)
	--coisinha do meio
	slider_gump.thumb = slider_gump:CreateTexture (nil, "OVERLAY")
	slider_gump.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider_gump.thumb:SetSize (29, 30)
	slider_gump:SetThumbTexture (slider_gump.thumb)
	
	slider_gump:SetOrientation ("VERTICAL")
	slider_gump:SetSize(16, 100)
	slider_gump:SetMinMaxValues(0, slider_gump.scrollMax)
	slider_gump:SetValue(0)
	slider_gump.ultimo = 0

	local botao_cima = CreateFrame ("Button", slider_gump:GetName() .. "UpButton", master)
	
	botao_cima:SetWidth (29)
	botao_cima:SetHeight (32)
	botao_cima:SetNormalTexture ([[Interface\Buttons\Arrow-Up-Up]])
	botao_cima:SetPushedTexture ([[Interface\Buttons\Arrow-Up-Down]])
	botao_cima:SetDisabledTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
	botao_cima:Show()
	botao_cima:Disable()

	botao_cima:SetPoint ("BOTTOM", slider_gump, "TOP", 0, -12)
	botao_cima.x = 0
	botao_cima.y = -12
	
	local botao_baixo = CreateFrame ("Button", slider_gump:GetName() .. "DownButton", master)
	botao_baixo:SetPoint ("TOP", slider_gump, "BOTTOM", 0, 12)
	botao_baixo.x = 0
	botao_baixo.y = 12
	
	botao_baixo:SetWidth (29)
	botao_baixo:SetHeight (32)
	botao_baixo:SetNormalTexture ([[Interface\Buttons\Arrow-Down-Up]])
	botao_baixo:SetPushedTexture ([[Interface\Buttons\Arrow-Down-Down]])
	botao_baixo:SetDisabledTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
	botao_baixo:Show()
	botao_baixo:Disable()

	master.baixo = botao_baixo
	master.cima = botao_cima
	master.slider = slider_gump
	
	botao_baixo:SetScript ("OnMouseDown", function(self)
		if (not slider_gump:IsEnabled()) then
			return
		end
		
		local current = slider_gump:GetValue()
		local minValue, maxValue = slider_gump:GetMinMaxValues()
		if (current+5 < maxValue) then
			slider_gump:SetValue (current+5)
		else
			slider_gump:SetValue (maxValue)
		end
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = slider_gump:GetValue()
				local minValue, maxValue = slider_gump:GetMinMaxValues()
				if (current+2 < maxValue) then
					slider_gump:SetValue (current+2)
				else
					slider_gump:SetValue (maxValue)
				end
			end
		end)
	end)
	botao_baixo:SetScript ("OnMouseUp", function(self) 
		self.precionado = false
		self:SetScript ("OnUpdate", nil)
	end)	
	
	botao_cima:SetScript ("OnMouseDown", function(self) 
		if (not slider_gump:IsEnabled()) then
			return
		end
		
		local current = slider_gump:GetValue()
		if (current-5 > 0) then
			slider_gump:SetValue (current-5)
		else
			slider_gump:SetValue (0)
		end	
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				local current = slider_gump:GetValue()
				if (current-2 > 0) then
					slider_gump:SetValue (current-2)
				else
					slider_gump:SetValue (0)
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
		local current = slider_gump:GetValue()
		if (current == 0) then
			botao_cima:Disable()
		end
	end)

	slider_gump:SetScript ("OnValueChanged", function (self)
		local current = self:GetValue()
		master:SetVerticalScroll (current)
		
		local minValue, maxValue = slider_gump:GetMinMaxValues()
		
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

	slider_gump:SetScript ("OnShow", function (self)
		botao_cima:Show()
		botao_baixo:Show()
	end)
	
	slider_gump:SetScript ("OnDisable", function (self)
		botao_cima:Disable()
		botao_baixo:Disable()
	end)
	
	slider_gump:SetScript ("OnEnable", function (self)
		botao_cima:Enable()
		botao_baixo:Enable()
	end)
	
	master:SetScript ("OnMouseWheel", function (self, delta)
		if (not slider_gump:IsEnabled()) then
			return
		end

		local current = slider_gump:GetValue()
		if (delta < 0) then 
			--baixo
			local minValue, maxValue = slider_gump:GetMinMaxValues()
			if (current + (master.wheel_jump or 20) < maxValue) then
				slider_gump:SetValue (current + (master.wheel_jump or 20))
			else
				slider_gump:SetValue (maxValue)
			end
		elseif (delta > 0) then
			--cima
			if (current + (master.wheel_jump or 20) > 0) then
				slider_gump:SetValue (current - (master.wheel_jump or 20))
			else
				slider_gump:SetValue (0)
			end
		end
	end)
	
	function slider_gump:Altura (h)
		self:SetHeight (h)
	end
	
	function slider_gump:Update (desativar)
	
		if (desativar) then
			slider_gump:Disable()
			slider_gump:SetValue(0)
			slider_gump.ativo = false
			master:EnableMouseWheel (false)
			return
		end
	
		self.scrollMax = slave:GetHeight()-master:GetHeight()
		if (self.scrollMax > 0) then
			slider_gump:SetMinMaxValues (0, self.scrollMax)
			if (not slider_gump.ativo) then
				slider_gump:Enable()
				slider_gump.ativo = true
				master:EnableMouseWheel (true)
			end
		else
			slider_gump:Disable()
			slider_gump:SetValue(0)
			slider_gump.ativo = false
			master:EnableMouseWheel (false)
		end
	end
	
	function slider_gump:cimaPoint (x, y)
		botao_cima:SetPoint ("BOTTOM", slider_gump, "TOP", x, (y)-12)
	end
	
	function slider_gump:baixoPoint (x, y)
		botao_baixo:SetPoint ("TOP", slider_gump, "BOTTOM", x, (y)+12)
	end
	
	return slider_gump
end
