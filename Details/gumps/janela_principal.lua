
--note: this file need a major clean up especially on function creation.

local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
local _
local gump = 			_detalhes.gump
local SharedMedia = LibStub:GetLibrary ("LibSharedMedia-3.0")

local atributos = _detalhes.atributos
local sub_atributos = _detalhes.sub_atributos
local segmentos = _detalhes.segmentos

--lua locals
local _cstr = tostring
local _math_ceil = math.ceil
local _math_floor = math.floor
local _math_max = math.max
local _ipairs = ipairs
local _pairs = pairs
local _string_lower = string.lower
local _unpack = unpack
--api locals
local CreateFrame = CreateFrame
local _GetTime = GetTime
local _GetCursorPosition = GetCursorPosition
local _GameTooltip = GameTooltip
local _UIParent = UIParent
local _GetScreenWidth = GetScreenWidth
local _GetScreenHeight = GetScreenHeight
local _IsAltKeyDown = IsAltKeyDown
local _IsShiftKeyDown = IsShiftKeyDown
local _IsControlKeyDown = IsControlKeyDown
local modo_raid = _detalhes._detalhes_props["MODO_RAID"]
local modo_alone = _detalhes._detalhes_props["MODO_ALONE"]
local modo_grupo = _detalhes._detalhes_props["MODO_GROUP"]
local modo_all = _detalhes._detalhes_props["MODO_ALL"]

local tok_functions = _detalhes.ToKFunctions

--constants
local baseframe_strata = "LOW"
local gump_fundo_backdrop = {
	bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
	insets = {left = 0, right = 0, top = 0, bottom = 0}}


function  _detalhes:ScheduleUpdate (instancia)
	instancia.barraS = {nil, nil}
	instancia.update = true
	if (instancia.showing) then
		instancia.atributo = instancia.atributo or 1
		
		if (not instancia.showing [instancia.atributo]) then --> unknow very rare bug where showing transforms into a clean table
			instancia.showing = _detalhes.tabela_vigente
		end
		
		instancia.showing [instancia.atributo].need_refresh = true
	end
end

--> skins TCoords

--	0.00048828125
	
	local DEFAULT_SKIN = [[Interface\AddOns\Details\images\skins\classic_skin]]
	
	--local COORDS_LEFT_BALL = {0.15673828125, 0.27978515625, 0.08251953125, 0.20556640625} -- 160 84 287 211 (updated)
	--local COORDS_LEFT_BALL = {0.15576171875, 0.27978515625, 0.08251953125, 0.20556640625} -- 160 84 287 211 (updated)
	local COORDS_LEFT_BALL = {0.15625, 0.2802734375, 0.08203125, 0.2060546875} -- 160 287 84 211
	
	--local COORDS_LEFT_CONNECTOR = {0.29541015625, 0.30126953125, 0.08251953125, 0.20556640625} --302 84 309 211 (updated)
	local COORDS_LEFT_CONNECTOR = {0.294921875, 0.3017578125, 0.08203125, 0.2060546875} --302 84 309 211 (updated)
	
	--local COORDS_LEFT_CONNECTOR_NO_ICON = {0.58837890625, 0.59423828125, 0.08251953125, 0.20556640625} -- 602 84 609 211 (updated)
	local COORDS_LEFT_CONNECTOR_NO_ICON = {0.587890625+0.00048828125, 0.5947265625, 0.08203125, 0.2060546875} -- 602 609 x 84 211

	--local COORDS_TOP_BACKGROUND = {0.15673828125, 0.65478515625, 0.22314453125, 0.34619140625} -- 160 228 671 355 (updated)
	local COORDS_TOP_BACKGROUND = {0.15625, 0.6552734375, 0.22265625, 0.3466796875} -- 160 671 x 228 355
	
	--local COORDS_RIGHT_BALL = {0.31591796875, 0.43994140625, 0.08251953125, 0.20556640625} --324 84 451 211 (updated)
	--local COORDS_RIGHT_BALL = {0.3154296875+0.00048828125, 0.439453125+0.00048828125, 0.08203125, 0.2060546875-0.00048828125} --323 84 450 211 (updated)
	local COORDS_RIGHT_BALL = {0.3154296875, 0.439453125, 0.08203125, 0.2060546875} -- 323 450 x 84 211
	
	--local COORDS_LEFT_BALL_NO_ICON = {0.44970703125, 0.57275390625, 0.08251953125, 0.20556640625} --460 84 587 211 (updated)
	--local COORDS_LEFT_BALL_NO_ICON = {0.44921875, 0.57421875, 0.08203125, 0.20703125} --460 84 588 212 (updated)
	--local COORDS_LEFT_BALL_NO_ICON = {0.44970703125, 0.57275390625, 0.08251953125, 0.20556640625} --460 84 587 211 (updated) 588 212
	local COORDS_LEFT_BALL_NO_ICON = {0.44921875, 0.5732421875, 0.08203125, 0.2060546875} -- 460 587 84 211

	--local COORDS_LEFT_SIDE_BAR = {0.76611328125, 0.82763671875, 0.00244140625, 0.50146484375} -- 784 2 848 514 (updated)
	local COORDS_LEFT_SIDE_BAR = {0.765625, 0.828125, 0.001953125, 0.501953125} -- 784 2 848 514 (updated)

	--local COORDS_RIGHT_SIDE_BAR = {0.70068359375, 0.76220703125, 0.00244140625, 0.50146484375} -- 717 2 781 514 (updated)
	--local COORDS_RIGHT_SIDE_BAR = {0.7001953125, 0.763671875, 0.00244140625, 0.50146484375} -- 717 2 781 514 (updated)
	--local COORDS_RIGHT_SIDE_BAR = {0.7001953125+0.00048828125, 0.76171875, 0.001953125, 0.5009765625} -- --717 2 780 513
	local COORDS_RIGHT_SIDE_BAR = {0.7001953125, 0.7626953125, 0.001953125, 0.501953125} -- --717 2 781 513
	
	local COORDS_BOTTOM_SIDE_BAR = {0.32861328125, 0.82666015625, 0.50537109375, 0.56494140625} -- 336 517 847 579 (updated)
	
	local COORDS_SLIDER_TOP = {0.00146484375, 0.03076171875, 0.00244140625, 0.03173828125} -- 1 2 32 33 -ok
	local COORDS_SLIDER_MIDDLE = {0.00146484375, 0.03076171875, 0.03955078125, 0.10009765625} -- 1 40 32 103 -ok
	local COORDS_SLIDER_DOWN = {0.00146484375, 0.03076171875, 0.10986328125, 0.13916015625} -- 1 112 32 143 -ok

	--local COORDS_STRETCH = {0.00146484375, 0.03076171875, 0.21435546875, 0.22802734375} -- 1 219 32 234 -ok
	local COORDS_STRETCH = {0.0009765625, 0.03125, 0.2138671875, 0.228515625} -- 1 32 219 234
	
	local COORDS_RESIZE_RIGHT = {0.00146484375, 0.01513671875, 0.24560546875, 0.25927734375} -- 1 251 16 266 -ok
	local COORDS_RESIZE_LEFT = {0.02001953125, 0.03173828125, 0.24560546875, 0.25927734375} -- 20 251 33 266 -ok
	
	local COORDS_UNLOCK_BUTTON = {0.00146484375, 0.01513671875, 0.27197265625, 0.28564453125} -- 1 278 16 293 -ok
	
	local COORDS_BOTTOM_BACKGROUND = {0.15673828125, 0.65478515625, 0.35400390625, 0.47705078125} -- 160 362 671 489 -ok
	local COORDS_PIN_LEFT = {0.00146484375, 0.03076171875, 0.30126953125, 0.33056640625} -- 1 308 32 339 -ok
	local COORDS_PIN_RIGHT = {0.03564453125, 0.06494140625, 0.30126953125, 0.33056640625} -- 36 308 67 339 -ok
	
	-- icones: 365 = 0.35693359375 // 397 = 0.38720703125

	local menus_backdrop = {
		edgeFile = [[Interface\Buttons\WHITE8X8]],
		edgeSize=1,
		--bgFile="Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		--bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], 
		bgFile = [[Interface\AddOns\Details\images\background]],
		tileSize=16,
		tile=true,
		insets = {top=0, right=0, left=0, bottom=0}
	}
	local menus_backdropcolor = {.2, .2, .2, 0.85}
	local menus_backdropcolor_sec = {.2, .2, .2, 0.90}
	local menus_bordercolor = {0, 0, 0, .25}
	
	--menus are ignoring the value set on the profile
	
	_detalhes.menu_backdrop_config = {
		menus_backdrop = menus_backdrop,
		menus_backdropcolor = menus_backdropcolor,
		menus_backdropcolor_sec = menus_backdropcolor_sec,
		menus_bordercolor = menus_bordercolor,
	}
	
	
function _detalhes:AtualizarScrollBar (x) --> x = quantas barras esta sendo mostrado

	local cabe = self.rows_fit_in_window --> quantas barras cabem na janela

	if (not self.barraS[1]) then --primeira vez que as barras est�o aparecendo
		self.barraS[1] = 1 --primeira barra
		if (cabe < x) then --se a quantidade a ser mostrada for maior que o que pode ser mostrado
			self.barraS[2] = cabe -- B = o que pode ser mostrado
		else
			self.barraS[2] = x -- contr�rio B = o que esta sendo mostrado
		end
	end
	
	if (not self.rolagem) then
		if (x > cabe) then --> Ligar a ScrollBar
			self.rows_showing = x
			
			if (not self.baseframe.isStretching) then
				self:MostrarScrollBar()
			end
			self.need_rolagem = true
			
			self.barraS[2] = cabe --> B � o total que cabe na barra
		else --> Do contr�rio B � o total de barras
			self.rows_showing = x
			self.barraS[2] = x
		end
	else
		if (x > self.rows_showing) then --> tem mais barras mostrando agora do que na �ltima atualiza��o
			self.rows_showing = x
			local nao_mostradas = self.rows_showing - self.rows_fit_in_window
			local slider_height = nao_mostradas*self.row_height
			self.scroll.scrollMax = slider_height
			self.scroll:SetMinMaxValues (0, slider_height)
			
		else	--> diminuiu a quantidade, acontece depois de uma coleta de lixo
			self.rows_showing = x
			local nao_mostradas = self.rows_showing - self.rows_fit_in_window
			
			if (nao_mostradas < 1) then  --> se estiver mostrando menos do que realmente cabe n�o precisa scrollbar
				self:EsconderScrollBar()
			else
				--> contr�rio, basta atualizar o tamanho da scroll
				local slider_height = nao_mostradas*self.row_height
				self.scroll.scrollMax = slider_height
				self.scroll:SetMinMaxValues (0, slider_height)
			end
			
		end
	end
	
	if (self.update) then 
		self.update = false
		self.v_barras = true
		return _detalhes:EsconderBarrasNaoUsadas (self)
	end
end

--> self � a janela das barras
local function move_barras (self, elapsed)
	self._move_func.time = self._move_func.time+elapsed
	if (self._move_func.time > 0.01) then
		if (self._move_func.instancia.bgdisplay_loc == self._move_func._end) then --> se o tamanho atual � igual ao final declarado
			self:SetScript ("OnUpdate", nil)
			self._move_func = nil
		else
			self._move_func.time = 0
			self._move_func.instancia.bgdisplay_loc = self._move_func.instancia.bgdisplay_loc + self._move_func.inc --> inc � -1 ou 1 e ir� crescer ou diminuir a janela
			
			for index = 1, self._move_func.instancia.rows_fit_in_window do
				self._move_func.instancia.barras [index]:SetWidth (self:GetWidth()+self._move_func.instancia.bgdisplay_loc-3)
			end
			self._move_func.instancia.bgdisplay:SetPoint ("bottomright", self, "bottomright", self._move_func.instancia.bgdisplay_loc, 0)
			
			self._move_func.instancia.bar_mod = self._move_func.instancia.bgdisplay_loc+(-3)
			
			--> verifica o tamanho do text
			for i  = 1, #self._move_func.instancia.barras do
				local esta_barra = self._move_func.instancia.barras [i]
				_detalhes:name_space (esta_barra)
			end
		end
	end
end

--> self � a inst�ncia
function _detalhes:MoveBarrasTo (destino)
	local janela = self.baseframe

	janela._move_func = {
		window = self.baseframe,
		instancia = self,
		time = 0
	}
	
	if (destino > self.bgdisplay_loc) then
		janela._move_func.inc = 1
	else
		janela._move_func.inc = -1
	end
	janela._move_func._end = destino
	janela:SetScript ("OnUpdate", move_barras)
end

function _detalhes:MostrarScrollBar (sem_animacao)

	if (self.rolagem) then
		return
	end
	
	if (not _detalhes.use_scroll) then
		self.baseframe:EnableMouseWheel (true)
		self.scroll:Enable()
		self.scroll:SetValue (0)
		self.rolagem = true
		return
	end

	local main = self.baseframe
	local mover_para = self.largura_scroll*-1
	
	if (not sem_animacao and _detalhes.animate_scroll) then
		self:MoveBarrasTo (mover_para)
	else
		--> set size of rows
		for index = 1, self.rows_fit_in_window do
			self.barras [index]:SetWidth (self.baseframe:GetWidth()+mover_para -3) --> -3 distance between row end and scroll start
		end
		--> move the semi-background to the left (which moves the scroll)
		self.bgdisplay:SetPoint ("bottomright", self.baseframe, "bottomright", mover_para, 0)
		
		self.bar_mod = mover_para + (-3)
		self.bgdisplay_loc = mover_para
		
		--> cancel movement if any
		if (self.baseframe:GetScript ("OnUpdate") and self.baseframe:GetScript ("OnUpdate") == move_barras) then
			self.baseframe:SetScript ("OnUpdate", nil)
		end
	end
	
	local nao_mostradas = self.rows_showing - self.rows_fit_in_window
	local slider_height = nao_mostradas*self.row_height
	self.scroll.scrollMax = slider_height
	self.scroll:SetMinMaxValues (0, slider_height)
	
	self.rolagem = true
	self.scroll:Enable()
	main:EnableMouseWheel (true)

	self.scroll:SetValue (0) --> set value pode chamar o atualizador
	self.baseframe.button_down:Enable()
	main.resize_direita:SetPoint ("bottomright", main, "bottomright", self.largura_scroll*-1, 0)
	
	if (main.isLocked) then
		main.lock_button:SetPoint ("bottomright", main, "bottomright", self.largura_scroll*-1, 0)
	end

end

function _detalhes:EsconderScrollBar (sem_animacao, force)

	if (not self.rolagem) then
		return
	end
	
	if (not _detalhes.use_scroll and not force) then
		self.scroll:Disable()
		self.baseframe:EnableMouseWheel (false)
		self.rolagem = false
		return
	end
	
	local main = self.baseframe

	if (not sem_animacao and _detalhes.animate_scroll) then
		self:MoveBarrasTo (self.row_info.space.right + 3) --> 
	else
		for index = 1, self.rows_fit_in_window do
			self.barras [index]:SetWidth (self.baseframe:GetWidth() - 5) --> -5 space between row end and window right border
		end
		self.bgdisplay:SetPoint ("bottomright", self.baseframe, "bottomright", 0, 0) -- voltar o background na poci��o inicial
		self.bar_mod = 0 -- zera o bar mod, uma vez que as barras v�o estar na pocis�o inicial
		self.bgdisplay_loc = -2
		if (self.baseframe:GetScript ("OnUpdate") and self.baseframe:GetScript ("OnUpdate") == move_barras) then
			self.baseframe:SetScript ("OnUpdate", nil)
		end
	end

	self.rolagem = false
	self.scroll:Disable()
	main:EnableMouseWheel (false)
	
	main.resize_direita:SetPoint ("bottomright", main, "bottomright", 0, 0)
	if (main.isLocked) then
		main.lock_button:SetPoint ("bottomright", main, "bottomright", 0, 0)
	end
end

local function OnLeaveMainWindow (instancia, self)

	instancia.is_interacting = false
	instancia:SetMenuAlpha (nil, nil, nil, nil, true)
	instancia:SetAutoHideMenu (nil, nil, true)
	instancia:RefreshAttributeTextSize()
	
	if (instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and not instancia.baseframe.isLocked) then

		--> resizes, lock and ungroup buttons
		if (not _detalhes.disable_lock_ungroup_buttons) then
			instancia.baseframe.resize_direita:SetAlpha (0)
			instancia.baseframe.resize_esquerda:SetAlpha (0)
			instancia.baseframe.lock_button:SetAlpha (0)
			instancia.break_snap_button:SetAlpha (0)
		end
		
		--> stretch button
		gump:Fade (instancia.baseframe.button_stretch, "ALPHA", 0)
	
	elseif (instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and instancia.baseframe.isLocked) then
	
		--> resizes, lock and ungroup buttons
		if (not _detalhes.disable_lock_ungroup_buttons) then
			instancia.baseframe.lock_button:SetAlpha (0)
			instancia.break_snap_button:SetAlpha (0)
		end
		
		gump:Fade (instancia.baseframe.button_stretch, "ALPHA", 0)
		
	end
end
_detalhes.OnLeaveMainWindow = OnLeaveMainWindow

local function OnEnterMainWindow (instancia, self)
	instancia.is_interacting = true
	instancia:SetMenuAlpha (nil, nil, nil, nil, true)
	instancia:SetAutoHideMenu (nil, nil, true)
	instancia:RefreshAttributeTextSize()
	
	if (not instancia.last_interaction or instancia.last_interaction < _detalhes._tempo) then
		instancia.last_interaction = _detalhes._tempo or time()
	end

	if (instancia.baseframe:GetFrameLevel() > instancia.rowframe:GetFrameLevel()) then
		instancia.rowframe:SetFrameLevel (instancia.baseframe:GetFrameLevel())
	end
	
	if (instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and not instancia.baseframe.isLocked) then

		--> resize, lock and ungroup buttons
		if (not _detalhes.disable_lock_ungroup_buttons) then
			instancia.baseframe.resize_direita:SetAlpha (1)
			instancia.baseframe.resize_esquerda:SetAlpha (1)
			instancia.baseframe.lock_button:SetAlpha (1)
			
			--> ungroup
			for _, instancia_id in _pairs (instancia.snap) do
				if (instancia_id) then
					instancia.break_snap_button:SetAlpha (1)
					break
				end
			end
		end
		
		--> stretch button
		if (not _detalhes.disable_stretch_button) then
			gump:Fade (instancia.baseframe.button_stretch, "ALPHA", 0.6)
		end
		
	elseif (instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and instancia.baseframe.isLocked) then
	
		if (not _detalhes.disable_lock_ungroup_buttons) then
			instancia.baseframe.lock_button:SetAlpha (1)

			--> ungroup
			for _, instancia_id in _pairs (instancia.snap) do
				if (instancia_id) then
					instancia.break_snap_button:Show()
					instancia.break_snap_button:SetAlpha (1)
					break
				end
			end
		end
		
		if (not _detalhes.disable_stretch_button) then
			gump:Fade (instancia.baseframe.button_stretch, "ALPHA", 0.6)
		end
	end
end
_detalhes.OnEnterMainWindow = OnEnterMainWindow

local function VPL (instancia, esta_instancia)
	--> conferir esquerda
	if (instancia.ponto4.x-0.5 < esta_instancia.ponto1.x) then --> a janela esta a esquerda
		if (instancia.ponto4.x+20 > esta_instancia.ponto1.x) then --> a janela esta a menos de 20 pixels de dist�ncia
			if (instancia.ponto4.y < esta_instancia.ponto1.y + 100 and instancia.ponto4.y > esta_instancia.ponto1.y - 100) then --> a janela esta a +20 ou -20 pixels de dist�ncia na vertical
				return 1
			end
		end
	end
	return nil
end

local function VPB (instancia, esta_instancia)
	--> conferir baixo
	if (instancia.ponto1.y+(20 * instancia.window_scale) < esta_instancia.ponto2.y - (16 * esta_instancia.window_scale)) then --> a janela esta em baixo
		if (instancia.ponto1.x > esta_instancia.ponto2.x-100 and instancia.ponto1.x < esta_instancia.ponto2.x+100) then --> a janela esta a 20 pixels de dist�ncia para a esquerda ou para a direita
			if (instancia.ponto1.y+(20 * instancia.window_scale) > esta_instancia.ponto2.y - (36 * esta_instancia.window_scale)) then --> esta a 20 pixels de dist�ncia
				return 2
			end
		end
	end
	return nil
end

local function VPR (instancia, esta_instancia)
	--> conferir lateral direita
	if (instancia.ponto2.x+0.5 > esta_instancia.ponto3.x) then --> a janela esta a direita
		if (instancia.ponto2.x-20 < esta_instancia.ponto3.x) then --> a janela esta a menos de 20 pixels de dist�ncia
			if (instancia.ponto2.y < esta_instancia.ponto3.y + 100 and instancia.ponto2.y > esta_instancia.ponto3.y - 100) then --> a janela esta a +20 ou -20 pixels de dist�ncia na vertical
				return 3
			end
		end
	end
	return nil
end

local function VPT (instancia, esta_instancia)
	--> conferir cima
	if (instancia.ponto3.y - (16 * instancia.window_scale) > esta_instancia.ponto4.y + (20 * esta_instancia.window_scale)) then --> a janela esta em cima
		if (instancia.ponto3.x > esta_instancia.ponto4.x-100 and instancia.ponto3.x < esta_instancia.ponto4.x+100) then --> a janela esta a 20 pixels de dist�ncia para a esquerda ou para a direita
			if (esta_instancia.ponto4.y+(40 * esta_instancia.window_scale) > instancia.ponto3.y - (16 * instancia.window_scale)) then
				return 4
			end
		end
	end
	return nil
end

_detalhes.VPT, _detalhes.VPR, _detalhes.VPB, _detalhes.VPL = VPT, VPR, VPB, VPL

local color_red = {1, 0.2, 0.2}
local color_green = {0.2, 1, 0.2}

local update_line = function (self, target_frame)

	--> based on weak auras frame movement code
	--local selfX, selfY = target_frame:GetCenter()
	local selfX, selfY = target_frame.instance:GetPositionOnScreen()
	--local anchorX, anchorY = self:GetCenter()
	local anchorX, anchorY = self.instance:GetPositionOnScreen()
	
	selfX, selfY = selfX or 0, selfY or 0
	anchorX, anchorY = anchorX or 0, anchorY or 0
	
	local dX = selfX - anchorX
	local dY = selfY - anchorY
	local distance = sqrt (dX^2 + dY^2)

	local angle = atan2(dY, dX)
	local numInterim = floor(distance/40)
    
	local guide_balls = _detalhes.guide_balls
	if (not guide_balls) then
		_detalhes.guide_balls = {}
		guide_balls = _detalhes.guide_balls
	end
    
	for index, ball in ipairs (guide_balls) do
		ball:Hide()
	end
	
	self.instance:AtualizaPontos()
	target_frame.instance:AtualizaPontos()
	
	local color = color_red
	local _R, _T, _L, _B = VPL (self.instance, target_frame.instance), VPB (self.instance, target_frame.instance), VPR (self.instance, target_frame.instance), VPT (self.instance, target_frame.instance)
	if (_R or _T or _L or _B) then
		color = color_green
	end

	for i = 0, numInterim do
		local x = (distance - (i * 40)) * cos (angle)
		local y = (distance - (i * 40)) * sin (angle)

		local ball = guide_balls [i]
		if (not ball) then
			ball = _detalhes.overlay_frame:CreateTexture (nil, "Overlay")
			ball:SetTexture ([[Interface\AddOns\Details\images\icons]])
			ball:SetSize (16, 16)
			ball:SetAlpha (0.3)
			ball:SetTexCoord (410/512, 426/512, 2/512, 18/512)
			tinsert (guide_balls, ball)
		end
		
		ball:ClearAllPoints()
		ball:SetPoint("CENTER", self, "CENTER", x, y) --baseframse center
		ball:Show()
		ball:SetVertexColor (unpack (color))
	end

end

local show_instance_ids = function()

	for id, instance in _detalhes:ListInstances() do
		if (instance:IsEnabled()) then
			local id_texture1 = instance.baseframe.id_texture1
			if (not id_texture1) then
				--instancia.
				instance.baseframe.id_texture1 = instance.floatingframe:CreateTexture (nil, "overlay")
				instance.baseframe.id_texture2 = instance.floatingframe:CreateTexture (nil, "overlay")
				instance.baseframe.id_texture1:SetTexture ([[Interface\Timer\BigTimerNumbers]])
				instance.baseframe.id_texture2:SetTexture ([[Interface\Timer\BigTimerNumbers]])
			end
			
			local h = instance.baseframe:GetHeight() * 0.80
			instance.baseframe.id_texture1:SetSize (h, h)
			instance.baseframe.id_texture2:SetSize (h, h)
			
			local id = instance:GetId()
			
			local first, second = _math_floor (id/10), _math_floor (id%10)
			
			if (id >= 10) then
				instance.baseframe.id_texture1:SetPoint ("center", instance.baseframe, "center", -h/2/2, 0)
				instance.baseframe.id_texture2:SetPoint ("left", instance.baseframe.id_texture1, "right", -h/2, 0)
				
				first = first + 1
				local line = _math_ceil (first / 4)
				local x = ( first - ( (line-1) * 4 ) )  / 4
				local l, r, t, b = x-0.25, x, 0.33 * (line-1), 0.33 * line
				instance.baseframe.id_texture1:SetTexCoord (l, r, t, b)
				
				second = second + 1
				local line = _math_ceil (second / 4)
				local x = ( second - ( (line-1) * 4 ) )  / 4
				local l, r, t, b = x-0.25, x, 0.33 * (line-1), 0.33 * line
				instance.baseframe.id_texture2:SetTexCoord (l, r, t, b)
				
				instance.baseframe.id_texture1:Show()
				instance.baseframe.id_texture2:Show()
			else
				instance.baseframe.id_texture1:SetPoint ("center", instance.baseframe, "center")
				
				second = second + 1
				local line = _math_ceil (second / 4)
				local x = ( second - ( (line-1) * 4 ) )  / 4
				local l, r, t, b = x-0.25, x, 0.33 * (line-1), 0.33 * line
				instance.baseframe.id_texture1:SetTexCoord (l, r, t, b)
				
				instance.baseframe.id_texture1:Show()
				instance.baseframe.id_texture2:Hide()
			end

		end
	end
	
end

local tempo_movendo, precisa_ativar, instancia_alvo, tempo_fades, nao_anexados, flash_bounce, start_draw_lines, instance_ids_shown, need_show_group_guide

local movement_onupdate = function (self, elapsed) 

		if (start_draw_lines and start_draw_lines > 0.95) then
			update_line (self, instancia_alvo.baseframe)
		elseif (start_draw_lines) then
			start_draw_lines = start_draw_lines + elapsed
		end

		if (instance_ids_shown and instance_ids_shown > 0.95) then
			show_instance_ids()
			instance_ids_shown = nil
			
			if (need_show_group_guide and not DetailsFramework.IsClassicWow()) then
				_detalhes.MicroButtonAlert.Text:SetText (Loc ["STRING_WINDOW1ATACH_DESC"])
				_detalhes.MicroButtonAlert:SetPoint ("bottom", need_show_group_guide.baseframe, "top", 0, 30)
				_detalhes.MicroButtonAlert:SetHeight (320)
				_detalhes.MicroButtonAlert:Show()
			
				need_show_group_guide = nil
			end
		elseif (instance_ids_shown) then
			instance_ids_shown = instance_ids_shown + elapsed
		end
		
		if (tempo_movendo and tempo_movendo < 0) then

			if (precisa_ativar) then --> se a inst�ncia estiver fechada
				gump:Fade (instancia_alvo.baseframe, "ALPHA", 0.2)
				gump:Fade (instancia_alvo.baseframe.cabecalho.ball, "ALPHA", 0.2)
				gump:Fade (instancia_alvo.baseframe.cabecalho.atributo_icon, "ALPHA", 0.2)
				instancia_alvo:SaveMainWindowPosition()
				instancia_alvo:RestoreMainWindowPosition()
				precisa_ativar = false
				
			elseif (tempo_fades) then
			
				if (flash_bounce == 0) then
				
					flash_bounce = 1

					local tem_livre = false
					
					for lado, livre in _ipairs (nao_anexados) do
						if (livre) then
							if (lado == 1) then
							
								local texture = instancia_alvo.h_esquerda.texture
								texture:ClearAllPoints()
								
								if (instancia_alvo.toolbar_side == 1) then
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topright", instancia_alvo.baseframe, "topleft", 0, 20)
										texture:SetPoint ("bottomright", instancia_alvo.baseframe, "bottomleft", 0, -14)
									else
										texture:SetPoint ("topright", instancia_alvo.baseframe, "topleft", 0, 20)
										texture:SetPoint ("bottomright", instancia_alvo.baseframe, "bottomleft", 0, 0)
									end
								else
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topright", instancia_alvo.baseframe, "topleft", 0, 0)
										texture:SetPoint ("bottomright", instancia_alvo.baseframe, "bottomleft", 0, -34)
									else
										texture:SetPoint ("topright", instancia_alvo.baseframe, "topleft", 0, 0)
										texture:SetPoint ("bottomright", instancia_alvo.baseframe, "bottomleft", 0, -20)
									end
								end
							
								instancia_alvo.h_esquerda:Flash (1, 1, 2.0, false, 0, 0)
								tem_livre = true
								
							elseif (lado == 2) then
							
							
								local texture = instancia_alvo.h_baixo.texture
								texture:ClearAllPoints()
							
								if (instancia_alvo.toolbar_side == 1) then
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "bottomleft", 0, -14)
										texture:SetPoint ("topright", instancia_alvo.baseframe, "bottomright", 0, -14)
									else
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "bottomleft", 0, 0)
										texture:SetPoint ("topright", instancia_alvo.baseframe, "bottomright", 0, 0)
									end
								else
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "bottomleft", 0, -34)
										texture:SetPoint ("topright", instancia_alvo.baseframe, "bottomright", 0, -34)
									else
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "bottomleft", 0, -20)
										texture:SetPoint ("topright", instancia_alvo.baseframe, "bottomright", 0, -20)
									end
								end
							
								instancia_alvo.h_baixo:Flash (1, 1, 2.0, false, 0, 0)
								tem_livre = true
								
							elseif (lado == 3) then
							
								local texture = instancia_alvo.h_direita.texture
								texture:ClearAllPoints()
								
								if (instancia_alvo.toolbar_side == 1) then
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "topright", 0, 20)
										texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "bottomright", 0, -14)
									else
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "topright", 0, 20)
										texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "bottomright", 0, 0)
									end
								else
									if (instancia_alvo.show_statusbar) then
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "topright", 0, 0)
										texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "bottomright", 0, -34)
									else
										texture:SetPoint ("topleft", instancia_alvo.baseframe, "topright", 0, 0)
										texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "bottomright", 0, -20)
									end
								end
							
								instancia_alvo.h_direita:Flash (1, 1, 2.0, false, 0, 0)
								tem_livre = true
								
							elseif (lado == 4) then
							
								local texture = instancia_alvo.h_cima.texture
								texture:ClearAllPoints()
								
								if (instancia_alvo.toolbar_side == 1) then
									texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "topleft", 0, 20)
									texture:SetPoint ("bottomright", instancia_alvo.baseframe, "topright", 0, 20)
								else
									texture:SetPoint ("bottomleft", instancia_alvo.baseframe, "topleft", 0, 0)
									texture:SetPoint ("bottomright", instancia_alvo.baseframe, "topright", 0, 0)
								end
							
								instancia_alvo.h_cima:Flash (1, 1, 2.0, false, 0, 0)
								tem_livre = true
								
							end
						end
					end
					
					if (tem_livre) then
						if (not _detalhes.snap_alert.playing) then
							instancia_alvo:SnapAlert()
							_detalhes.snap_alert.playing = true
							
							if (not DetailsFramework.IsClassicWow()) then
								_detalhes.MicroButtonAlert.Text:SetText (string.format (Loc ["STRING_ATACH_DESC"], self.instance.meu_id, instancia_alvo.meu_id))
								_detalhes.MicroButtonAlert:SetPoint ("bottom", instancia_alvo.baseframe.cabecalho.modo_selecao.widget, "top", 0, 18)
								_detalhes.MicroButtonAlert:SetHeight (200)
								_detalhes.MicroButtonAlert:Show()
							end
						end
					end
				end
				
				tempo_movendo = 1
			else
				self:SetScript ("OnUpdate", nil)
				tempo_movendo = 1
			end
			
		elseif (tempo_movendo) then
			tempo_movendo = tempo_movendo - elapsed
		end
	end

local function move_janela (baseframe, iniciando, instancia, just_updating)

	instancia_alvo = _detalhes.tabela_instancias [instancia.meu_id-1]
	if (_detalhes.disable_window_groups) then
		instancia_alvo = nil
	end
	
	if (iniciando) then

		if (baseframe.isMoving) then
			--> ja esta em movimento
			return
		end
	
		baseframe.isMoving = true
		instancia:BaseFrameSnap()
		baseframe:StartMoving()
		
		local group = instancia:GetInstanceGroup()
		for _, this_instance in _ipairs (group) do
			this_instance.baseframe:SetClampRectInsets (0, 0, 0, 0)
			this_instance.isMoving = true
		end
		
		local _, ClampLeft, ClampRight = instancia:InstanciasHorizontais()
		local _, ClampBottom, ClampTop = instancia:InstanciasVerticais()
		
		baseframe:SetClampRectInsets (-ClampLeft, ClampRight, ClampTop, -ClampBottom)

		if (instancia_alvo and (instancia_alvo.ativa or not just_updating)) then
		
			tempo_fades = 1.0
			nao_anexados = {true, true, true, true}
			tempo_movendo = 1
			flash_bounce = 0
			instance_ids_shown = 0
			start_draw_lines = 0
			need_show_group_guide = nil
			
			for lado, snap_to in _pairs (instancia_alvo.snap) do
				if (snap_to == instancia.meu_id) then
					start_draw_lines = false
				end
			end
			
			for lado, snap_to in _pairs (instancia_alvo.snap) do
				if (snap_to) then
					if (snap_to == instancia.meu_id) then
						tempo_fades = nil
						break
					end
					nao_anexados [lado] = false
				end
			end
			
			for lado = 1, 4 do
				if (instancia_alvo.horizontalSnap and instancia.verticalSnap) then
					nao_anexados [lado] = false
				elseif (instancia_alvo.horizontalSnap and lado == 2) then
					nao_anexados [lado] = false
				elseif (instancia_alvo.horizontalSnap and lado == 4) then
					nao_anexados [lado] = false
				elseif (instancia_alvo.verticalSnap and lado == 1) then
					nao_anexados [lado] = false
				elseif (instancia_alvo.verticalSnap and lado == 3) then
					nao_anexados [lado] = false
				end
			end

			local need_start = not instancia_alvo.iniciada
			precisa_ativar = not instancia_alvo.ativa
			
			if (need_start) then --> se a inst�ncia n�o tiver sido aberta ainda

				local lower_instance = _detalhes:GetLowerInstanceNumber()
				--print (lower_instance, instancia_alvo.meu_id, DEATHGRAPHICS_BUTTON:GetParent():GetName())
			
				instancia_alvo:RestauraJanela (instancia_alvo.meu_id, true)
				if (instancia_alvo:IsSoloMode()) then
					_detalhes.SoloTables:switch()
				end
				
				instancia_alvo.ativa = false
				
				instancia_alvo:SaveMainWindowPosition()
				instancia_alvo:RestoreMainWindowPosition()
				
				gump:Fade (instancia_alvo.baseframe, 1)
				gump:Fade (instancia_alvo.rowframe, 1)
				gump:Fade (instancia_alvo.baseframe.cabecalho.ball, 1)
				
				need_start = false
			end
			
			baseframe:SetScript ("OnUpdate", movement_onupdate)
		else
			--> eh a instancia 1
			local got_snap
			for side, instance_id in _pairs (instancia.snap) do
				if (instance_id) then
					got_snap = true
				end
			end
			
			need_show_group_guide = nil
			
			if (not got_snap) then
				need_show_group_guide = instancia
			end
			
			tempo_movendo = nil
			start_draw_lines = nil
			instance_ids_shown = 0
			baseframe:SetScript ("OnUpdate", movement_onupdate)
		end
		
	else

		baseframe:StopMovingOrSizing()
		baseframe.isMoving = false
		baseframe:SetScript ("OnUpdate", nil)

		if (_detalhes.guide_balls) then
			for index, ball in ipairs (_detalhes.guide_balls) do
				ball:Hide()
			end
		end
		
		for _, ins in _detalhes:ListInstances() do
			if (ins.baseframe) then
				ins.baseframe:SetUserPlaced (false)
				if (ins.baseframe.id_texture1) then
					ins.baseframe.id_texture1:Hide()
					ins.baseframe.id_texture2:Hide()
				end
			end
		end

		--baseframe:SetClampRectInsets (unpack (_detalhes.window_clamp))

		if (instancia_alvo and not instancia.do_not_snap and not instancia_alvo.do_not_snap) then
			instancia:AtualizaPontos()
			
			local esquerda, baixo, direita, cima
			local meu_id = instancia.meu_id --> id da inst�ncia que esta sendo movida
			
			local isVertical = instancia_alvo.verticalSnap
			local isHorizontal = instancia_alvo.horizontalSnap
			
			local isSelfVertical = instancia.verticalSnap
			local isSelfHorizontal = instancia.horizontalSnap
			
			local _R, _T, _L, _B
			
			if (isVertical and not isSelfHorizontal) then
				_T, _B = VPB (instancia, instancia_alvo), VPT (instancia, instancia_alvo)
			elseif (isHorizontal and not isSelfVertical) then
				_R, _L = VPL (instancia, instancia_alvo), VPR (instancia, instancia_alvo)
			elseif (not isVertical and not isHorizontal) then
				_R, _T, _L, _B = VPL (instancia, instancia_alvo), VPB (instancia, instancia_alvo), VPR (instancia, instancia_alvo), VPT (instancia, instancia_alvo)
			end
			
			if (_L) then
				if (not instancia:EstaAgrupada (instancia_alvo, _L)) then
					esquerda = instancia_alvo.meu_id
					instancia.horizontalSnap = true
					instancia_alvo.horizontalSnap = true
				end
			end
			
			if (_B) then
				if (not instancia:EstaAgrupada (instancia_alvo, _B)) then
					baixo = instancia_alvo.meu_id
					instancia.verticalSnap = true
					instancia_alvo.verticalSnap = true
				end
			end
			
			if (_R) then
				if (not instancia:EstaAgrupada (instancia_alvo, _R)) then
					direita = instancia_alvo.meu_id
					instancia.horizontalSnap = true
					instancia_alvo.horizontalSnap = true
				end
			end
			
			if (_T) then
				if (not instancia:EstaAgrupada (instancia_alvo, _T)) then
					cima = instancia_alvo.meu_id
					instancia.verticalSnap = true
					instancia_alvo.verticalSnap = true
				end
			end
			
			if (esquerda or baixo or direita or cima) then
				instancia:agrupar_janelas ({esquerda, baixo, direita, cima})
				
				--> tutorial
				if (not _detalhes:GetTutorialCVar ("WINDOW_GROUP_MAKING1")) then
					_detalhes:SetTutorialCVar ("WINDOW_GROUP_MAKING1", true)
					
					local group_tutorial = CreateFrame ("frame", "DetailsWindowGroupPopUp1", instancia.baseframe, "DetailsHelpBoxTemplate")
					group_tutorial.ArrowUP:Show()
					group_tutorial.ArrowGlowUP:Show()
					group_tutorial.Text:SetText (Loc ["STRING_MINITUTORIAL_WINDOWS1"])
					group_tutorial:SetPoint ("bottom", instancia_alvo.break_snap_button, "top", 0, 24)
					group_tutorial:Show()
					_detalhes.OnEnterMainWindow (instancia_alvo)
					
				end
			end

			for _, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
				if (not esta_instancia:IsAtiva() and esta_instancia.iniciada) then
					esta_instancia:ResetaGump()
					
					gump:Fade (esta_instancia.baseframe, "in", 0.2)
					gump:Fade (esta_instancia.baseframe.cabecalho.ball, "in", 0.2)
					gump:Fade (esta_instancia.baseframe.cabecalho.atributo_icon, "in", 0.2)
					
					if (esta_instancia.modo == modo_raid) then
						_detalhes.raid = nil
					elseif (esta_instancia.modo == modo_alone) then
						_detalhes.SoloTables:switch()
						_detalhes.solo = nil
					end

				elseif (esta_instancia:IsAtiva()) then
					esta_instancia:SaveMainWindowPosition()
					esta_instancia:RestoreMainWindowPosition()
				end
			end

		end

		--> salva pos de todas as janelas
		for _, ins in _ipairs (_detalhes.tabela_instancias) do
			if (ins:IsEnabled()) then
				ins:SaveMainWindowPosition()
				ins:RestoreMainWindowPosition()
			end
		end
		
		local group = instancia:GetInstanceGroup()
		for _, this_instance in _ipairs (group) do
			this_instance.isMoving = false
		end

		_detalhes.snap_alert.playing = false
		_detalhes.snap_alert.animIn:Stop()
		_detalhes.snap_alert.animOut:Play()
		
		if (not DetailsFramework.IsClassicWow()) then
			_detalhes.MicroButtonAlert:Hide()
		end

		if (instancia_alvo and instancia_alvo.ativa and instancia_alvo.baseframe) then
			instancia_alvo.h_esquerda:Stop()
			instancia_alvo.h_baixo:Stop()
			instancia_alvo.h_direita:Stop()
			instancia_alvo.h_cima:Stop()
		end
		
	end
end
_detalhes.move_janela_func = move_janela

local BGFrame_scripts_onenter = function (self)
	OnEnterMainWindow (self._instance, self)
end

local BGFrame_scripts_onleave = function (self)
	OnLeaveMainWindow (self._instance, self)
end

local BGFrame_scripts_onmousedown = function (self, button)
	-- /run Details.disable_stretch_from_toolbar = true
	if (self.is_toolbar and self._instance.baseframe.isLocked and button == "LeftButton" and not _detalhes.disable_stretch_from_toolbar) then
		return self._instance.baseframe.button_stretch:GetScript ("OnMouseDown") (self._instance.baseframe.button_stretch, "LeftButton")
	end

	if (self._instance.baseframe.isMoving) then
		move_janela (self._instance.baseframe, false, self._instance)
		self._instance:SaveMainWindowPosition()
		return
	end
	
	if (not self._instance.baseframe.isLocked and button == "LeftButton") then
		move_janela (self._instance.baseframe, true, self._instance)
		if (self.is_toolbar) then
			if (self._instance.attribute_text.enabled and self._instance.attribute_text.side == 1 and self._instance.toolbar_side == 1) then
				self._instance.menu_attribute_string:SetPoint ("bottomleft", self._instance.baseframe.cabecalho.ball, "bottomright", self._instance.attribute_text.anchor [1]+1, self._instance.attribute_text.anchor [2]-1)
			end
		end
	elseif (button == "RightButton") then
		if (self.is_toolbar and not _detalhes.disable_alldisplays_window) then
			self._instance:ShowAllSwitch()
		else
			if (_detalhes.switch.current_instancia and _detalhes.switch.current_instancia == self._instance) then
				_detalhes.switch:CloseMe()
			else
				_detalhes.switch:ShowMe (self._instance)
			end
		end
	end
end

local BGFrame_scripts_onmouseup = function (self, button)

	if (self.is_toolbar and self._instance.baseframe.isLocked and button == "LeftButton") then
		if (DetailsWindowLockPopUp1 and DetailsWindowLockPopUp1:IsShown()) then
			_G ["DetailsWindowLockPopUp1"]:Hide()
		end
		return self._instance.baseframe.button_stretch:GetScript ("OnMouseUp") (self._instance.baseframe.button_stretch, "LeftButton")
	end
	
	if (self._instance.baseframe.isMoving) then
		move_janela (self._instance.baseframe, false, self._instance) --> novo movedor da janela
		self._instance:SaveMainWindowPosition()
		if (self.is_toolbar) then
			if (self._instance.attribute_text.enabled and self._instance.attribute_text.side == 1 and self._instance.toolbar_side == 1) then
				self._instance.menu_attribute_string:SetPoint ("bottomleft", self._instance.baseframe.cabecalho.ball, "bottomright", self._instance.attribute_text.anchor [1], self._instance.attribute_text.anchor [2])
			end
		end
	end
end

local function BGFrame_scripts (BG, baseframe, instancia)
	BG._instance = instancia
	BG:SetScript ("OnEnter", BGFrame_scripts_onenter)
	BG:SetScript ("OnLeave", BGFrame_scripts_onleave)
	BG:SetScript ("OnMouseDown", BGFrame_scripts_onmousedown)
	BG:SetScript ("OnMouseUp", BGFrame_scripts_onmouseup)
end

function gump:RegisterForDetailsMove (frame, instancia)

	frame:SetScript ("OnMouseDown", function (frame, button)
		if (not instancia.baseframe.isLocked and button == "LeftButton") then
			move_janela (instancia.baseframe, true, instancia) --> novo movedor da janela
		end
	end)

	frame:SetScript ("OnMouseUp", function (frame)
		if (instancia.baseframe.isMoving) then
			move_janela (instancia.baseframe, false, instancia) --> novo movedor da janela
			instancia:SaveMainWindowPosition()
		end
	end)	
end

--> scripts do base frame
local BFrame_scripts_onsizechange = function (self)
	self._instance:SaveMainWindowSize()
	self._instance:ReajustaGump()
	self._instance.oldwith = self:GetWidth()
	_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, self._instance)
	self._instance:RefreshAttributeTextSize()
end

local BFrame_scripts_onenter = function (self)
	OnEnterMainWindow (self._instance, self)
end

local BFrame_scripts_onleave = function (self)
	OnLeaveMainWindow (self._instance, self)
end

local BFrame_scripts_onmousedown = function (self, button)
	if (not self.isLocked and button == "LeftButton") then
		move_janela (self, true, self._instance)
	end
end

local BFrame_scripts_onmouseup = function (self, button)
	if (self.isMoving) then
		move_janela (self, false, self._instance) --> novo movedor da janela
		self._instance:SaveMainWindowPosition()
	end
end

local function BFrame_scripts (baseframe, instancia)
	baseframe._instance = instancia
	baseframe:SetScript("OnSizeChanged", BFrame_scripts_onsizechange)
	baseframe:SetScript("OnEnter", BFrame_scripts_onenter)
	baseframe:SetScript("OnLeave", BFrame_scripts_onleave)
	baseframe:SetScript ("OnMouseDown", BFrame_scripts_onmousedown)
	baseframe:SetScript ("OnMouseUp", BFrame_scripts_onmouseup)
end

local function backgrounddisplay_scripts (backgrounddisplay, baseframe, instancia)
	backgrounddisplay:SetScript ("OnEnter", function (self)
		OnEnterMainWindow (instancia, self)
	end)
	
	backgrounddisplay:SetScript ("OnLeave", function (self) 
		OnLeaveMainWindow (instancia, self)
	end)
end

local function instancias_horizontais (instancia, largura, esquerda, direita)
	if (esquerda) then
		for lado, esta_instancia in _pairs (instancia.snap) do 
			if (lado == 1) then --> movendo para esquerda
				local instancia = _detalhes.tabela_instancias [esta_instancia]
				instancia.baseframe:SetWidth (largura)
				instancia.auto_resize = true
				instancia:ReajustaGump()
				instancia.auto_resize = false
				instancias_horizontais (instancia, largura, true, false)
				_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, instancia)
			end
		end
	end
	
	if (direita) then
		for lado, esta_instancia in _pairs (instancia.snap) do 
			if (lado == 3) then --> movendo para esquerda
				local instancia = _detalhes.tabela_instancias [esta_instancia]
				instancia.baseframe:SetWidth (largura)
				instancia.auto_resize = true
				instancia:ReajustaGump()
				instancia.auto_resize = false
				instancias_horizontais (instancia, largura, false, true)
				_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, instancia)
			end
		end
	end
end

local function instancias_verticais (instancia, altura, esquerda, direita)
	if (esquerda) then
		for lado, esta_instancia in _pairs (instancia.snap) do 
			if (lado == 1) then --> movendo para esquerda
				local instancia = _detalhes.tabela_instancias [esta_instancia]
				instancia.baseframe:SetHeight (altura)
				instancia.auto_resize = true
				instancia:ReajustaGump()
				instancia.auto_resize = false
				instancias_verticais (instancia, altura, true, false)
				_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, instancia)
			end
		end
	end
	
	if (direita) then
		for lado, esta_instancia in _pairs (instancia.snap) do 
			if (lado == 3) then --> movendo para esquerda
				local instancia = _detalhes.tabela_instancias [esta_instancia]
				instancia.baseframe:SetHeight (altura)
				instancia.auto_resize = true
				instancia:ReajustaGump()
				instancia.auto_resize = false
				instancias_verticais (instancia, altura, false, true)
				_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, instancia)
			end
		end
	end
end

local check_snap_side = function (instanceid, snap, id, container)
	local instance = _detalhes:GetInstance (instanceid)
	if (instance and instance.snap [snap] and instance.snap [snap] == id) then
		tinsert (container, instance)
		return true
	end
end

function _detalhes:InstanciasVerticais (instance)

	instance = self or instance
	
	local on_top = {}
	local on_bottom = {}
	local id = instance:GetId()
	
	--lower instances
	local this_instance = _detalhes:GetInstance (id-1)
	if (this_instance) then
		--> top side
		if (this_instance.snap [2] and this_instance.snap [2] == id) then
			local cid = id
			local snapid = 2
			for i = cid-1, 1, -1 do
				if (check_snap_side (i, 2, cid, on_top)) then
					cid = cid - 1
				else
					break
				end
			end
		--> bottom side
		elseif (this_instance.snap [4] and this_instance.snap [4] == id) then
			local cid = id
			local snapid = 4
			for i = cid-1, 1, -1 do
				if (check_snap_side (i, 4, cid, on_bottom)) then
					cid = cid - 1
				else
					break
				end
			end
		end
	end

	--upper instances
	local this_instance = _detalhes:GetInstance (id+1)
	if (this_instance) then
		--> top side
		if (this_instance.snap [2] and this_instance.snap [2] == id) then
			local cid = id
			local snapid = 2
			for i = cid+1, _detalhes:GetNumInstancesAmount() do
				if (check_snap_side (i, 2, cid, on_top)) then
					cid = cid + 1
				else
					break
				end
			end
		--> bottom side
		elseif (this_instance.snap [4] and this_instance.snap [4] == id) then
			local cid = id
			local snapid = 4
			for i = cid+1, _detalhes:GetNumInstancesAmount() do
				if (check_snap_side (i, 4, cid, on_bottom)) then
					cid = cid + 1
				else
					break
				end
			end
		end
	end
	
	--> calc top clamp
	local top_clamp = 0
	local bottom_clamp = 0
	
	if (instance.toolbar_side == 1) then
		top_clamp = top_clamp + 20
	elseif (instance.toolbar_side == 2) then
		bottom_clamp = bottom_clamp + 20
	end
	if (instance.show_statusbar) then
		bottom_clamp = bottom_clamp + 14
	end
	
	for cid, this_instance in _ipairs (on_top) do
		if (this_instance.show_statusbar) then
			top_clamp = top_clamp + 14
		end
		top_clamp = top_clamp + 20
		top_clamp = top_clamp + this_instance.baseframe:GetHeight()
	end
	
	for cid, this_instance in _ipairs (on_bottom) do
		if (this_instance.show_statusbar) then
			bottom_clamp = bottom_clamp + 14
		end
		bottom_clamp = bottom_clamp + 20
		bottom_clamp = bottom_clamp + this_instance.baseframe:GetHeight()
		tinsert (on_top, this_instance)
	end

	return on_top, bottom_clamp, top_clamp
end

--[[
			lado 4
	-----------------------------------------
	|					|
lado 1	|					| lado 3
	|					|
	|					|
	-----------------------------------------
			lado 2
--]]

function _detalhes:InstanciasHorizontais (instancia)

	instancia = self or instancia

	local linha_horizontal, esquerda, direita = {}, 0, 0
	
	local top, bottom = 0, 0

	local checking = instancia
	
	local check_index_anterior = _detalhes.tabela_instancias [instancia.meu_id-1]
	if (check_index_anterior) then --> possiu uma inst�ncia antes de mim
		if (check_index_anterior.snap[3] and check_index_anterior.snap[3] == instancia.meu_id) then --> o index negativo vai para a esquerda
			for i = instancia.meu_id-1, 1, -1 do 
				local esta_instancia = _detalhes.tabela_instancias [i]
				if (esta_instancia.snap[3]) then
					if (esta_instancia.snap[3] == checking.meu_id) then
						linha_horizontal [#linha_horizontal+1] = esta_instancia
						esquerda = esquerda + esta_instancia.baseframe:GetWidth()
						checking = esta_instancia
					end
				else
					break
				end
			end
		elseif (check_index_anterior.snap[1] and check_index_anterior.snap[1] == instancia.meu_id) then --> o index negativo vai para a direita
			for i = instancia.meu_id-1, 1, -1 do 
				local esta_instancia = _detalhes.tabela_instancias [i]
				if (esta_instancia.snap[1]) then
					if (esta_instancia.snap[1] == checking.meu_id) then
						linha_horizontal [#linha_horizontal+1] = esta_instancia
						direita = direita + esta_instancia.baseframe:GetWidth()
						checking = esta_instancia
					end
				else
					break
				end
			end
		end
	end
	
	checking = instancia
	
	local check_index_posterior = _detalhes.tabela_instancias [instancia.meu_id+1]
	if (check_index_posterior) then
		if (check_index_posterior.snap[3] and check_index_posterior.snap[3] == instancia.meu_id) then --> o index posterior vai para a esquerda
			for i = instancia.meu_id+1, #_detalhes.tabela_instancias do 
				local esta_instancia = _detalhes.tabela_instancias [i]
				if (esta_instancia.snap[3]) then
					if (esta_instancia.snap[3] == checking.meu_id) then
						linha_horizontal [#linha_horizontal+1] = esta_instancia
						esquerda = esquerda + esta_instancia.baseframe:GetWidth()
						checking = esta_instancia
					end
				else
					break
				end
			end
		elseif (check_index_posterior.snap[1] and check_index_posterior.snap[1] == instancia.meu_id) then --> o index posterior vai para a direita
			for i = instancia.meu_id+1, #_detalhes.tabela_instancias do 
				local esta_instancia = _detalhes.tabela_instancias [i]
				if (esta_instancia.snap[1]) then
					if (esta_instancia.snap[1] == checking.meu_id) then
						linha_horizontal [#linha_horizontal+1] = esta_instancia
						direita = direita + esta_instancia.baseframe:GetWidth()
						checking = esta_instancia
					end
				else
					break
				end
			end
		end
	end

	return linha_horizontal, esquerda, direita, bottom, top
	
end

local resizeTooltip = {
	{text = "|cff33CC00Click|cffEEEEEE: ".. Loc ["STRING_RESIZE_COMMON"]},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc ["STRING_RESIZE_HORIZONTAL"]},
	{icon = [[Interface\AddOns\Details\images\key_shift]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc ["STRING_RESIZE_VERTICAL"]},
	{icon = [[Interface\AddOns\Details\images\key_alt]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625},
	
	{text = "+|cff33CC00 Click|cffEEEEEE: " .. Loc ["STRING_RESIZE_ALL"]},
	{icon = [[Interface\AddOns\Details\images\key_ctrl]], width = 24, height = 14, l = 0, r = 1, t = 0, b =0.640625}
}

--> search key: ~resizescript

local resize_scripts_onmousedown = function (self, button)
	_G.GameCooltip:ShowMe (false) --> Hide Cooltip
	
	if (_detalhes.disable_lock_ungroup_buttons) then
		return
	end
	
	if (not self:GetParent().isLocked and button == "LeftButton" and self._instance.modo ~= _detalhes._detalhes_props["MODO_ALONE"]) then 
		self:GetParent().isResizing = true
		self._instance:BaseFrameSnap()

		local isVertical = self._instance.verticalSnap
		local isHorizontal = self._instance.horizontalSnap
	
		local agrupadas
		if (self._instance.verticalSnap) then
			agrupadas = self._instance:InstanciasVerticais()
		elseif (self._instance.horizontalSnap) then
			agrupadas = self._instance:InstanciasHorizontais()
		end

		self._instance.stretchToo = agrupadas
		if (self._instance.stretchToo and #self._instance.stretchToo > 0) then
			for _, esta_instancia in ipairs (self._instance.stretchToo) do 
				esta_instancia.baseframe._place = esta_instancia:SaveMainWindowPosition()
				esta_instancia.baseframe.isResizing = true
			end
		end
		
	----------------
	
		if (self._myside == "<") then
			if (_IsShiftKeyDown()) then
				self._instance.baseframe:StartSizing("left")
				self._instance.eh_horizontal = true
			elseif (_IsAltKeyDown()) then
				self._instance.baseframe:StartSizing("top")
				self._instance.eh_vertical = true
			elseif (_IsControlKeyDown()) then
				self._instance.baseframe:StartSizing("bottomleft")
				self._instance.eh_tudo = true
			else
				self._instance.baseframe:StartSizing("bottomleft")
			end
			
			self:SetPoint ("bottomleft", self._instance.baseframe, "bottomleft", -1, -1)
			self.afundado = true
			
		elseif (self._myside == ">") then
			if (_IsShiftKeyDown()) then
				self._instance.baseframe:StartSizing ("right")
				self._instance.eh_horizontal = true
			elseif (_IsAltKeyDown()) then
				self._instance.baseframe:StartSizing ("top")
				self._instance.eh_vertical = true
			elseif (_IsControlKeyDown()) then
				self._instance.baseframe:StartSizing ("bottomright")
				self._instance.eh_tudo = true
			else
				self._instance.baseframe:StartSizing ("bottomright")
			end
			
			if (self._instance.rolagem and _detalhes.use_scroll) then
				self:SetPoint ("bottomright", self._instance.baseframe, "bottomright", (self._instance.largura_scroll*-1) + 1, -1)
			else
				self:SetPoint ("bottomright", self._instance.baseframe, "bottomright", 1, -1)
			end
			self.afundado = true
		end
		
		_detalhes:SendEvent ("DETAILS_INSTANCE_STARTRESIZE", nil, self._instance)

		if (_detalhes.update_speed > 0.3) then
			_detalhes:SetWindowUpdateSpeed (0.3, true)
			_detalhes.resize_changed_update_speed = true
		end
		
	end 
end

local resize_scripts_onmouseup = function (self, button)

	if (_detalhes.disable_lock_ungroup_buttons) then
		return
	end

	if (self.afundado) then
		self.afundado = false
		if (self._myside == ">") then
			if (self._instance.rolagem and _detalhes.use_scroll) then
				self:SetPoint ("bottomright", self._instance.baseframe, "bottomright", self._instance.largura_scroll*-1, 0)
			else
				self:SetPoint ("bottomright", self._instance.baseframe, "bottomright", 0, 0)
			end
		else
			self:SetPoint ("bottomleft", self._instance.baseframe, "bottomleft", 0, 0)
		end
	end

	if (self:GetParent().isResizing) then 
	
		self:GetParent():StopMovingOrSizing()
		self:GetParent().isResizing = false
		
		self._instance:RefreshBars()
		self._instance:InstanceReset()
		self._instance:ReajustaGump()
		
		if (self._instance.stretchToo and #self._instance.stretchToo > 0) then
			for _, esta_instancia in ipairs (self._instance.stretchToo) do 
				esta_instancia.baseframe:StopMovingOrSizing()
				esta_instancia.baseframe.isResizing = false
				esta_instancia:RefreshBars()
				esta_instancia:InstanceReset()
				esta_instancia:ReajustaGump()
				_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, esta_instancia)
			end
			self._instance.stretchToo = nil
		end	
		
		local largura = self._instance.baseframe:GetWidth()
		local altura = self._instance.baseframe:GetHeight()
		
		if (self._instance.eh_horizontal) then
			instancias_horizontais (self._instance, largura, true, true)
			self._instance.eh_horizontal = nil
		end
		
		--if (instancia.eh_vertical) then
			instancias_verticais (self._instance, altura, true, true)
			self._instance.eh_vertical = nil
		--end
		
		_detalhes:SendEvent ("DETAILS_INSTANCE_ENDRESIZE", nil, self._instance)
		
		if (self._instance.eh_tudo) then
			for _, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
				if (esta_instancia:IsAtiva() and esta_instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"]) then
					esta_instancia.baseframe:ClearAllPoints()
					esta_instancia:SaveMainWindowPosition()
					esta_instancia:RestoreMainWindowPosition()
				end
			end
			
			for _, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
				if (esta_instancia:IsAtiva() and esta_instancia ~= self._instance and esta_instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"]) then
					esta_instancia.baseframe:SetWidth (largura)
					esta_instancia.baseframe:SetHeight (altura)
					esta_instancia.auto_resize = true
					esta_instancia:RefreshBars()
					esta_instancia:InstanceReset()
					esta_instancia:ReajustaGump()
					esta_instancia.auto_resize = false
					_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, esta_instancia)
				end
			end

			self._instance.eh_tudo = nil
		end
		
		self._instance:BaseFrameSnap()
		
		for _, esta_instancia in _ipairs (_detalhes.tabela_instancias) do
			if (esta_instancia:IsAtiva()) then
				esta_instancia:SaveMainWindowPosition()
				esta_instancia:RestoreMainWindowPosition()
			end
		end
		
		if (_detalhes.resize_changed_update_speed) then
			_detalhes:SetWindowUpdateSpeed (false, true)
			_detalhes.resize_changed_update_speed = nil
		end
		
	end 
end

local resize_scripts_onhide = function (self)
	if (self.going_hide) then
		_G.GameCooltip:ShowMe (false)
		self.going_hide = nil
	end
end

local resize_scripts_onenter = function (self)

	if (_detalhes.disable_lock_ungroup_buttons) then
		return
	end

	if (self._instance.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and not self._instance.baseframe.isLocked and not self.mostrando) then

		OnEnterMainWindow (self._instance, self)
	
		self.texture:SetBlendMode ("ADD")
		self.mostrando = true
		
		_detalhes:CooltipPreset (2.1)
		GameCooltip:AddFromTable (resizeTooltip)

		GameCooltip:SetOwner (self)
		GameCooltip:ShowCooltip()
	end
end

local resize_scripts_onleave = function (self)
	if (self.mostrando) then
		self.going_hide = true
		if (not self.movendo) then
			OnLeaveMainWindow (self._instance, self)
		end

		self.texture:SetBlendMode ("BLEND")
		self.mostrando = false
		
		GameCooltip:ShowMe (false)
	end
end

local function resize_scripts (resizer, instancia, scrollbar, side, baseframe)
	resizer._instance = instancia
	resizer._myside = side

	resizer:SetScript ("OnMouseDown", resize_scripts_onmousedown)
	resizer:SetScript ("OnMouseUp", resize_scripts_onmouseup)
	resizer:SetScript ("OnHide", resize_scripts_onhide)
	resizer:SetScript ("OnEnter", resize_scripts_onenter)
	resizer:SetScript ("OnLeave", resize_scripts_onleave)
end

local lockButtonTooltip = {
	{text = Loc ["STRING_LOCK_DESC"]},
	{icon = [[Interface\PetBattles\PetBattle-LockIcon]], width = 14, height = 14, l = 0.0703125, r = 0.9453125, t = 0.0546875, b = 0.9453125, color = "orange"},
}

local lockFunctionOnEnter = function (self)

	if (_detalhes.disable_lock_ungroup_buttons) then
		return
	end

	if (self.instancia.modo ~= _detalhes._detalhes_props["MODO_ALONE"] and not self.mostrando) then
		OnEnterMainWindow (self.instancia, self)
		
		self.mostrando = true
		
		self.label:SetTextColor (1, 1, 1, .6)

		_detalhes:CooltipPreset (2.1)
		GameCooltip:SetOption ("FixedWidth", 180)
		GameCooltip:AddFromTable (lockButtonTooltip)

		GameCooltip:SetOwner (self)
		GameCooltip:ShowCooltip()
	end
end
 
local lockFunctionOnLeave = function (self)
	if (self.mostrando) then
		self.going_hide = true
		OnLeaveMainWindow (self.instancia, self)
		self.label:SetTextColor (.6, .6, .6, .7)
		self.mostrando = false
		GameCooltip:ShowMe (false)
	end
end

local lockFunctionOnHide = function (self)
	if (self.going_hide) then
		GameCooltip:ShowMe (false)
		self.going_hide = nil
	end
end

function _detalhes:DelayOptionsRefresh (instance, no_reopen)
	if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown()) then
		_detalhes:ScheduleTimer ("OpenOptionsWindow", 0.1, {instance or _G.DetailsOptionsWindow.instance, no_reopen})
	end
end

function _detalhes:RefreshLockedState()
	if (not self.baseframe and self.meu_id and self:IsEnabled()) then
		self:ScheduleTimer ("RefreshLockedState", 1)
		return
	elseif (not self.baseframe) then
		return
	end
	
	if (self.baseframe.isLocked) then
		self.baseframe.resize_direita:EnableMouse (false)
		self.baseframe.resize_esquerda:EnableMouse (false)
	else
		self.baseframe.resize_direita:EnableMouse (true)
		self.baseframe.resize_esquerda:EnableMouse (true)	
	end
	
	return true
end

local lockFunctionOnClick = function (button, button_type, button2, isFromOptionsButton)

	--isFromOptionsButton is true when the call if from the button in the display section of the options panel
	if (_detalhes.disable_lock_ungroup_buttons and isFromOptionsButton ~= true) then
		return
	end

	if (not button:GetParent().instance) then
		button = button2 --from any other button
	end

	local baseframe = button:GetParent()
	if (baseframe.isLocked) then
		baseframe.isLocked = false
		baseframe.instance.isLocked = false
		button.label:SetText (Loc ["STRING_LOCK_WINDOW"])
		button:SetWidth (button.label:GetStringWidth()+2)
		
		if (not _detalhes.disable_lock_ungroup_buttons) then
			baseframe.resize_direita:SetAlpha (1)
			baseframe.resize_esquerda:SetAlpha (1)
		end
		
		button:ClearAllPoints()
		button:SetPoint ("right", baseframe.resize_direita, "left", -1, 1.5)	
	else
		--> tutorial
		if (not _detalhes:GetTutorialCVar ("WINDOW_LOCK_UNLOCK1") and not _detalhes.initializing) then
			_detalhes:SetTutorialCVar ("WINDOW_LOCK_UNLOCK1", true)
			
			local lock_tutorial = CreateFrame ("frame", "DetailsWindowLockPopUp1", baseframe, "DetailsHelpBoxTemplate")
			lock_tutorial.ArrowUP:Show()
			lock_tutorial.ArrowGlowUP:Show()
			lock_tutorial.Text:SetText (Loc ["STRING_MINITUTORIAL_WINDOWS2"])
			lock_tutorial:SetPoint ("bottom", baseframe.UPFrame, "top", 0, 20)
			lock_tutorial:Show()
			
		end	
	
		baseframe.isLocked = true
		baseframe.instance.isLocked = true
		button.label:SetText (Loc ["STRING_UNLOCK_WINDOW"])
		button:SetWidth (button.label:GetStringWidth()+2)
		button:ClearAllPoints()
		button:SetPoint ("bottomright", baseframe, "bottomright", -3, 0)
		baseframe.resize_direita:SetAlpha (0)
		baseframe.resize_esquerda:SetAlpha (0)
	end
	
	baseframe.instance:RefreshLockedState()
	
	_detalhes:DelayOptionsRefresh()
end

_detalhes.lock_instance_function = lockFunctionOnClick

local unSnapButtonTooltip = {
	{text = Loc ["STRING_DETACH_DESC"]},
	{icon = [[Interface\AddOns\Details\images\icons]], width = 14, height = 14, l = 160/512, r = 179/512, t = 142/512, b = 162/512},
}

local unSnapButtonOnEnter = function (self)

	if (_detalhes.disable_lock_ungroup_buttons) then
		return
	end

	local have_snap = false
	for _, instancia_id in _pairs (self.instancia.snap) do
		if (instancia_id) then
			have_snap = true
			break
		end
	end
	
	if (not have_snap) then
		OnEnterMainWindow (self.instancia, self)
		self.mostrando = true
		return
	end

	OnEnterMainWindow (self.instancia, self)
	self.mostrando = true
	
	_detalhes:CooltipPreset (2.1)
	GameCooltip:SetOption ("FixedWidth", 180)
	GameCooltip:AddFromTable (unSnapButtonTooltip)
	
	GameCooltip:ShowCooltip (self, "tooltip")
	
end

local unSnapButtonOnLeave = function (self)
	if (self.mostrando) then
		OnLeaveMainWindow (self.instancia, self)
		self.mostrando = false
		GameCooltip:Hide()
	end
end

--> this should run only when the mouse is over a instance bar
local shift_monitor = function (self)

	if (not self:IsMouseOver()) then
		self:SetScript ("OnUpdate", shift_monitor)
		return
	end

	if (_IsShiftKeyDown()) then
		if (not self.showing_allspells) then
			self.showing_allspells = true
			local instancia = _detalhes:GetInstance (self.instance_id)
			instancia:MontaTooltip (self, self.row_id, "shift")
		end
		
	elseif (self.showing_allspells) then
		self.showing_allspells = false
		local instancia = _detalhes:GetInstance (self.instance_id)
		instancia:MontaTooltip (self, self.row_id)
	end
	
	if (_IsControlKeyDown()) then
		if (not self.showing_alltargets) then
			self.showing_alltargets = true
			local instancia = _detalhes:GetInstance (self.instance_id)
			instancia:MontaTooltip (self, self.row_id, "ctrl")
		end
		
	elseif (self.showing_alltargets) then
		self.showing_alltargets = false
		local instancia = _detalhes:GetInstance (self.instance_id)
		instancia:MontaTooltip (self, self.row_id)
	end
	
	if (_IsAltKeyDown()) then
		if (not self.showing_allpets) then
			self.showing_allpets = true
			local instancia = _detalhes:GetInstance (self.instance_id)
			instancia:MontaTooltip (self, self.row_id, "alt")
		end
		
	elseif (self.showing_allpets) then
		self.showing_allpets = false
		local instancia = _detalhes:GetInstance (self.instance_id)
		instancia:MontaTooltip (self, self.row_id)
	end
end

local barra_backdrop_onenter = {
	bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], 
	tile = true, tileSize = 16,
	insets = {left = 1, right = 1, top = 0, bottom = 1}
}
local barra_backdrop_onleave = {
	bgFile = "", 
	edgeFile = "", tile = true, tileSize = 16, edgeSize = 32,
	insets = {left = 1, right = 1, top = 0, bottom = 1}
}

--> pre creating the truncate frame
	_detalhes.left_anti_truncate = CreateFrame ("frame", "DetailsLeftTextAntiTruncate", UIParent)
	_detalhes.left_anti_truncate:SetBackdrop (gump_fundo_backdrop)
	_detalhes.left_anti_truncate:SetBackdropColor (0, 0, 0, 0.8)
	_detalhes.left_anti_truncate:SetFrameStrata ("FULLSCREEN")
	_detalhes.left_anti_truncate.text = _detalhes.left_anti_truncate:CreateFontString (nil, "overlay", "GameFontNormal")
	_detalhes.left_anti_truncate.text:SetPoint ("left", _detalhes.left_anti_truncate, "left", 3, 0) 

local barra_scripts_onenter = function (self)
	self.mouse_over = true
	OnEnterMainWindow (self._instance, self)

	self._instance:MontaTooltip (self, self.row_id)
	
	self:SetBackdrop (barra_backdrop_onenter)	
	self:SetBackdropColor (0.588, 0.588, 0.588, 0.7)

	if (not _detalhes.instances_disable_bar_highlight) then
		if (self._instance.bars_inverted) then
			self.right_to_left_texture:SetBlendMode ("ADD")
		else
			self.textura:SetBlendMode ("ADD")
		end
	end

	local lefttext = self.texto_esquerdo
	if (lefttext:IsTruncated()) then
		if (not _detalhes.left_anti_truncate) then
			
		end
		
		_detalhes:SetFontSize (_detalhes.left_anti_truncate.text, self._instance.row_info.font_size)
		_detalhes:SetFontFace (_detalhes.left_anti_truncate.text, self._instance.row_info.font_face_file)
		_detalhes:SetFontColor (_detalhes.left_anti_truncate.text, lefttext:GetTextColor())
		
		_detalhes.left_anti_truncate:SetPoint ("left", lefttext, "left", -3, 0)
		_detalhes.left_anti_truncate.text:SetText (lefttext:GetText())
		
		_detalhes.left_anti_truncate:SetSize (_detalhes.left_anti_truncate.text:GetStringWidth() + 3, self._instance.row_info.height)
		_detalhes.left_anti_truncate:Show()
		lefttext.untruncated = true
	end
	
	self:SetScript ("OnUpdate", shift_monitor)
end

local barra_scripts_onleave = function (self)
	self.mouse_over = false
	OnLeaveMainWindow (self._instance, self)
	
	--_GameTooltip:Hide()
	GameCooltip:ShowMe (false)
	
	self:SetBackdrop (barra_backdrop_onleave)	
	self:SetBackdropBorderColor (0, 0, 0, 0)
	self:SetBackdropColor (0, 0, 0, 0)
	
	if (self._instance.bars_inverted) then
		self.right_to_left_texture:SetBlendMode ("BLEND")
	else
		self.textura:SetBlendMode ("BLEND")
	end

	self.showing_allspells = false
	self:SetScript ("OnUpdate", nil)
	
	local lefttext = self.texto_esquerdo
	if (lefttext.untruncated) then
		lefttext.untruncated = nil
		_detalhes.left_anti_truncate:Hide()
	end
end

local barra_scripts_onmousedown = function (self, button)
	if (self.fading_in) then
		return
	end
	
	local lefttext = self.texto_esquerdo
	if (lefttext.untruncated) then
		lefttext.untruncated = nil
		_detalhes.left_anti_truncate:Hide()
	end
	
	if (button == "RightButton") then
		return _detalhes.switch:ShowMe (self._instance)
	
	--elseif (button == "MiddleButton") then

	elseif (button == "LeftButton") then

	end
	
	self._instance:HandleTextsOnMouseClick (self, "down")

	self.mouse_down = _GetTime()
	self.button = button
	local x, y = _GetCursorPosition()
	self.x = _math_floor (x)
	self.y = _math_floor (y)

	if (not self._instance.baseframe.isLocked) then
		GameCooltip:Hide()
		move_janela (self._instance.baseframe, true, self._instance)
	end
end

local barra_scripts_onmouseup = function (self, button)

	local is_shift_down = _IsShiftKeyDown()
	local is_control_down = _IsControlKeyDown()

	if (self._instance.baseframe.isMoving) then
		move_janela (self._instance.baseframe, false, self._instance)
		self._instance:SaveMainWindowPosition()

		if (self._instance:MontaTooltip (self, self.row_id)) then
			GameCooltip:Show (self, 1)
		end
	end

	self._instance:HandleTextsOnMouseClick (self, "up")
	
	local x, y = _GetCursorPosition()
	x = _math_floor (x)
	y = _math_floor (y)

	if (self.mouse_down and (self.mouse_down+0.4 > _GetTime() and (x == self.x and y == self.y)) or (x == self.x and y == self.y)) then
		if (self.button == "LeftButton" or self.button == "MiddleButton") then
			if (self._instance.atributo == 5 or is_shift_down) then 
				--> report
				if (self._instance.atributo == 5 and is_shift_down) then
					local custom = self._instance:GetCustomObject()
					if (custom and custom.on_shift_click) then
						local func = loadstring (custom.on_shift_click)
						if (func) then
							local successful, errortext = pcall (func, self, self.minha_tabela, self._instance)
							if (not successful) then
								_detalhes:Msg ("error occurred custom script shift+click:", errortext)
							end
							return
						end
					end
				end
				
				if (_detalhes.row_singleclick_overwrite [self._instance.atributo] and type (_detalhes.row_singleclick_overwrite [self._instance.atributo][self._instance.sub_atributo]) == "function") then
					return _detalhes.row_singleclick_overwrite [self._instance.atributo][self._instance.sub_atributo] (_, self.minha_tabela, self._instance, is_shift_down, is_control_down)
				end
				
				return _detalhes:ReportSingleLine (self._instance, self)
			end
			
			--print (self.minha_tabela)
			-- /dump DetailsBarra_1_1.minha_tabela
			if (not self.minha_tabela) then
				return _detalhes:Msg ("this bar is waiting update.")
			end
			
			self._instance:AbreJanelaInfo (self.minha_tabela, nil, nil, is_shift_down, is_control_down)
		end
	end
end

local barra_scripts_onclick = function (self, button)

end

local barra_scripts_onshow = function (self)
	-- search key: ~model
	if (self.using_upper_3dmodels) then
		self.modelbox_high:SetModel (self._instance.row_info.models.upper_model)
		self.modelbox_high:SetAlpha (self._instance.row_info.models.upper_alpha)
	end
	if (self.using_lower_3dmodels) then
		self.modelbox_low:SetModel (self._instance.row_info.models.lower_model)
		self.modelbox_low:SetAlpha (self._instance.row_info.models.lower_alpha)
	end
end

function _detalhes:HandleTextsOnMouseClick (row, type)

	if (self.bars_inverted) then
		if (type == "down") then
			row.texto_direita:SetPoint ("left", row.statusbar, "left", 2, -1)
			
			if (self.row_info.no_icon) then
				row.texto_esquerdo:SetPoint ("right", row.statusbar, "right", -1, -1)
			else
				row.texto_esquerdo:SetPoint ("right", row.icone_classe, "left", -1, -1)
			end
			
		elseif (type == "up") then
			row.texto_direita:SetPoint ("left", row.statusbar, "left", 1, 0)
			
			if (self.row_info.no_icon) then
				row.texto_esquerdo:SetPoint ("right", row.statusbar, "right", -2, 0)
			else
				row.texto_esquerdo:SetPoint ("right", row.icone_classe, "left", -2, 0)
			end
		end

	else
		if (type == "down") then
			row.texto_direita:SetPoint ("right", row.statusbar, "right", 1, -1)
			if (self.row_info.no_icon) then
				row.texto_esquerdo:SetPoint ("left", row.statusbar, "left", 3, -1)
			else
				row.texto_esquerdo:SetPoint ("left", row.icone_classe, "right", 4, -1)
			end
			
		elseif (type == "up") then
			row.texto_direita:SetPoint ("right", row.statusbar, "right")
			if (self.row_info.no_icon) then
				row.texto_esquerdo:SetPoint ("left", row.statusbar, "left", 2, 0)
			else
				row.texto_esquerdo:SetPoint ("left", row.icone_classe, "right", 3, 0)
			end
		end
	end
end

local set_bar_value = function (self, value)
	if (self._instance.bars_inverted) then
		self.statusbar:SetValue (0)
		
		local width = self._instance.cached_bar_width
		local inverse_bar_size = width / 100 * value
		local coord_inverse = inverse_bar_size / width
		
		inverse_bar_size = _math_max (inverse_bar_size, 0.00000001)
		
		self.right_to_left_texture:SetWidth (inverse_bar_size)
		self.right_to_left_texture:SetTexCoord (coord_inverse, 0, 0, 1)
	else
		self.statusbar:SetValue (value)
	end
	
	self.statusbar.value = value
	
	if (self.using_upper_3dmodels) then
		local width = self:GetWidth()
		local p = (width / 100) * value
		self.modelbox_high:SetPoint ("bottomright", self, "bottomright", p - width, 0)
	end
end

-- ~talent ~icon
local icon_frame_on_enter = function (self)
	local actor = self.row.minha_tabela
	
	if (self.row.icone_classe:GetTexture() ~= "") then
		--self.row.icone_classe:SetSize (self.row.icone_classe:GetWidth()+1, self.row.icone_classe:GetWidth()+1)
		--self.row.icone_classe:SetBlendMode ("ADD")
	end
	
	if (actor) then
		if (actor.frags) then
		
		
		elseif (actor.is_custom or actor.byspell or actor.damage_spellid) then
			local spellid = actor.damage_spellid or actor.id or actor[1]
			if (spellid) then
				GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT", 0, 10)
				_detalhes:GameTooltipSetSpellByID (spellid)
				GameTooltip:Show()
			end
		
		elseif (actor.dead_at) then
		
		
		elseif (actor.name) then --ensure it's an actor table
		
			local serial = actor.serial
			local name = actor:name()
			local class = actor:class()
			local spec = _detalhes.cached_specs [serial] or actor.spec
			local talents = _detalhes.cached_talents [serial]
			local ilvl = _detalhes.ilevel:GetIlvl (serial)
			
			local icon_size = 20
			
			local instance = _detalhes:GetInstance (self.row.instance_id)
			
			instance:BuildInstanceBarTooltip (self)
			
			local class_icon, class_L, class_R, class_T, class_B = _detalhes:GetClassIcon (class)
			
			local spec_id, spec_name, spec_description, spec_icon, spec_role, spec_class = DetailsFramework.GetSpecializationInfoByID (spec or 0) --thanks pas06
			local spec_L, spec_R, spec_T, spec_B 
			if (spec_id) then
				spec_L, spec_R, spec_T, spec_B  = unpack (_detalhes.class_specs_coords [spec])
			end
			
			GameCooltip:AddLine (name, spec_name)
			if (class == "UNKNOW" or class == "UNGROUPPLAYER") then
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], 1, 1, icon_size, icon_size, 0, 0.25, 0.75, 1)
			else
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\classes_small_alpha]], 1, 1, icon_size, icon_size, class_L, class_R, class_T, class_B)
			end
			
			if (spec_L) then
				GameCooltip:AddIcon ([[Interface\AddOns\Details\images\spec_icons_normal_alpha]], 1, 2, icon_size, icon_size, spec_L, spec_R, spec_T, spec_B)
			else
				GameCooltip:AddIcon ([[Interface\GossipFrame\IncompleteQuestIcon]], 1, 2, icon_size, icon_size)
			end
			_detalhes:AddTooltipHeaderStatusbar()
			
			local talent_string = ""
			if (talents) then
				for i = 1, #talents do
					local talentID, name, texture, selected, available = GetTalentInfoByID (talents [i])
					talent_string = talent_string ..  " |T" .. texture .. ":" .. 24 .. ":" .. 24 ..":0:0:64:64:4:60:4:60|t"
				end
			end
			
			local got_info
			if (ilvl) then
				GameCooltip:AddLine (STAT_AVERAGE_ITEM_LEVEL .. ":" , ilvl and "|T:" .. 24 .. ":" .. 24 ..":0:0:64:64:4:60:4:60|t" .. floor (ilvl.ilvl) or "|T:" .. 24 .. ":" .. 24 ..":0:0:64:64:4:60:4:60|t ??") --> Loc from GlobalStrings.lua
				GameCooltip:AddIcon ([[]], 1, 1, 1, 20)
				_detalhes:AddTooltipBackgroundStatusbar()
				got_info = true
			else
				GameCooltip:AddLine (STAT_AVERAGE_ITEM_LEVEL .. ":" , 0)
				GameCooltip:AddIcon ([[]], 1, 1, 1, 20)
				_detalhes:AddTooltipBackgroundStatusbar()
				got_info = true
			end
			
			if (talent_string ~= "") then
				GameCooltip:AddLine (TALENTS .. ":", talent_string) --> Loc from GlobalStrings.lua
				GameCooltip:AddIcon ([[]], 1, 1, 1, 24)
				_detalhes:AddTooltipBackgroundStatusbar()
				got_info = true
			elseif (got_info) then
				GameCooltip:AddLine (TALENTS .. ":", Loc ["STRING_QUERY_INSPECT_REFRESH"]) --> Loc from GlobalStrings.lua
				GameCooltip:AddIcon ([[]], 1, 1, 1, 24)
				_detalhes:AddTooltipBackgroundStatusbar()
			end
			
			GameCooltip:SetOption ("StatusBarTexture", [[Interface\AddOns\Details\images\bar_skyline]])
			GameCooltip:SetOption ("MinButtonHeight", 15)
			GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
			
			local height = 66
			if (not got_info) then
				GameCooltip:AddLine (Loc ["STRING_QUERY_INSPECT"], nil, 1, "orange")
				GameCooltip:AddIcon ([[Interface\TUTORIALFRAME\UI-TUTORIAL-FRAME]], 1, 1, 12, icon_size, 8/512, 70/512, 224/512, 306/512)
				height = 54
			end

			local combat = instance:GetShowingCombat()
			local diff = combat:GetDifficulty()
			local attribute, subattribute = instance:GetDisplay()
			
			--> check if is a raid encounter and if is heroic or mythic
			if (diff and (diff == 15 or diff == 16) and (attribute == 1 or attribute == 2)) then
				local db = _detalhes.OpenStorage()
				if (db) then
					local bestRank, encounterTable = _detalhes.storage:GetBestFromPlayer (diff, combat:GetBossInfo().id, attribute == 1 and "damage" or "healing", name, true)
					if (bestRank) then
						--GameCooltip:AddLine ("")
						
						--> discover which are the player position in the guild rank
						local playerTable, onEncounter, rankPosition = _detalhes.storage:GetPlayerGuildRank (diff, combat:GetBossInfo().id, attribute == 1 and "damage" or "healing", name, true)
						
						--" .. floor (bestRank[2] or 0) .. " ilvl" .. " | 
						GameCooltip:AddLine ("Best Score:", _detalhes:ToK2 ((bestRank[1] or 0) / encounterTable.elapsed) .. " [|cFFFFFF00Rank: " .. (rankPosition or "#") .. "|r]", 1, "white")
						_detalhes:AddTooltipBackgroundStatusbar()
						
						GameCooltip:AddLine ("|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:1:512:512:8:70:224:306|t Open Rank", "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:14:12:0:1:512:512:8:70:328:409|t Refresh Talents", 1, "white", "white")
						_detalhes:AddTooltipBackgroundStatusbar()
						
						--GameCooltip:AddLine ("On: " .. (encounterTable.date:gsub (".*%s", "")), , 1, "orange")
						--_detalhes:AddTooltipHeaderStatusbar()
						if (not got_info) then
							height = height + 25
						else
							height = height + 31
						end
					end
				end
			end
			
			local attribute, subAttribute = instance:GetDisplay()
			if (attribute == 1) then
				local realDps = actor.total / instance:GetShowingCombat():GetCombatTime()
				local dpsValue = _detalhes:comma_value_raw (realDps)
				if (dpsValue) then
					local total, decimal = strsplit (".", dpsValue)
					total = total-- .. "." .. (decimal and decimal:match("^%d"))
					GameCooltip:AddLine ("Dps:", total)
					_detalhes:AddTooltipBackgroundStatusbar()
					GameCooltip:AddIcon ("", 1, 1, 1, 20)
					height = height + 21
				end
			end
			
			--[=[
			if (RaiderIO and RaiderIO.GetScore) then
				local mythicPlusScore = RaiderIO.GetScore (name)
				if (mythicPlusScore and mythicPlusScore.allScore) then
					GameCooltip:AddLine ("Mythic+ Score:", mythicPlusScore.allScore, 1, "white", "white")
					_detalhes:AddTooltipBackgroundStatusbar()
				end
			end
			--]=]
			
			GameCooltip:SetOption ("FixedHeight", height)
			
			GameCooltip:ShowCooltip()
			
			self.unitname = name
			self.showing = "actor"
		end
	end

end
local icon_frame_on_leave = function (self)
	GameCooltip:Hide()
	
	if (GameTooltip and GameTooltip:IsShown()) then
		GameTooltip:Hide()
	end
	
	if (self.row.icone_classe:GetTexture() ~= "") then
		--self.row.icone_classe:SetSize (self.row.icone_classe:GetWidth()-1, self.row.icone_classe:GetWidth()-1)
		--self.row.icone_classe:SetBlendMode ("BLEND")
	end
end

local icon_frame_events = _detalhes:CreateEventListener()
function icon_frame_events:EnterCombat()
	for anim, _ in pairs (_detalhes.icon_animations.load.in_use) do
		anim.anim:Stop()
		anim:Hide()
		tinsert (_detalhes.icon_animations.load.available, anim)
		
		anim.icon_frame.icon_animation = nil
		anim.icon_frame = nil
	end
	wipe (_detalhes.icon_animations.load.in_use)
end

icon_frame_events:RegisterEvent ("COMBAT_PLAYER_ENTER", "EnterCombat")

function icon_frame_events:CancelAnim (anim)

	local anim, timeout = unpack (anim)

	if (_detalhes.icon_animations.load.in_use [anim]) then
	
		if (timeout) then
			local f = anim
			if (not f.question_icon) then
				f.question_icon = f.parent:GetParent():GetParent().border:CreateTexture (nil, "overlay")
				f.question_icon:SetTexture ([[Interface\GossipFrame\ActiveLegendaryQuestIcon]])
				f.question_icon:SetSize (16, 16)
			end
			f.question_icon:Show()
			f.question_icon:SetPoint ("center", f.parent, "center")
			
			if (not _detalhes.HideBarQuestionIcon) then
				function _detalhes:HideBarQuestionIcon (frame)
					frame.question_icon:Hide()
				end
			end
			_detalhes:ScheduleTimer ("HideBarQuestionIcon", 2, f)
		end
	
		_detalhes.icon_animations.load.in_use [anim] = nil
		tinsert (_detalhes.icon_animations.load.available, anim)
		anim.anim:Stop()
		anim:Hide()
		
		anim.icon_frame.icon_animation = nil
		anim.icon_frame = nil
	end
end

local icon_frame_inspect_callback = function (guid, unitid, icon_frame)
	if (icon_frame.icon_animation) then
		icon_frame.icon_animation.anim:Stop()
		icon_frame.icon_animation:Hide()
	end

	local is_in_use = _detalhes.icon_animations.load.in_use [icon_frame.icon_animation]
	if (is_in_use) then
		tinsert (_detalhes.icon_animations.load.available, icon_frame.icon_animation)
		_detalhes.icon_animations.load.in_use [icon_frame.icon_animation] = nil
	end
	
	if (icon_frame:IsMouseOver()) then
		icon_frame_on_enter (icon_frame)
	end
	
	if (icon_frame.icon_animation) then
		icon_frame.icon_animation.icon_frame = nil
		icon_frame.icon_animation = nil
	end
end

local icon_frame_create_animation = function()
	local f = CreateFrame ("frame", nil, UIParent)
	f:SetFrameStrata ("FULLSCREEN")
	f.anim = f:CreateAnimationGroup()
	f.rotate = f.anim:CreateAnimation ("Rotation")
	f.rotate:SetDegrees (360)
	f.rotate:SetDuration (2)
	f.anim:SetLooping ("repeat")
	
	local t = f:CreateTexture (nil, "overlay")
	t:SetTexture ([[Interface\COMMON\StreamCircle]])
	t:SetAlpha (0.7)
	t:SetAllPoints()
	
	tinsert (_detalhes.icon_animations.load.available, f)
end

local icon_frame_on_click_down = function (self)
	local instanceID = self.instance_id
	local instanceObject = Details:GetInstance (instanceID)
	self:GetParent():GetParent().icone_classe:SetPoint ("left", self:GetParent():GetParent(), "left", instanceObject.row_info.icon_offset[1] + 1, instanceObject.row_info.icon_offset[2] + -1)
end

local icon_frame_on_click_up = function (self, button)

	local instanceID = self.instance_id
	local instanceObject = Details:GetInstance (instanceID)
	self:GetParent():GetParent().icone_classe:SetPoint ("left", self:GetParent():GetParent(), "left", instanceObject.row_info.icon_offset[1], instanceObject.row_info.icon_offset[2])

	if (button == "LeftButton") then
		--> open the rank panel
		local instance = _detalhes:GetInstance (self.row.instance_id)
		if (instance) then
			local attribute, subattribute = instance:GetDisplay()
			local combat = instance:GetShowingCombat()
			local diff = combat:GetDifficulty()
			local bossInfo = combat:GetBossInfo()
			
			if ((attribute == 1 or attribute == 2) and bossInfo) then --if bossInfo is nil, means the combat isn't a boss
				local db = _detalhes.OpenStorage()
				if (db and bossInfo.id) then
					local haveData = _detalhes.storage:HaveDataForEncounter (diff, bossInfo.id, true) --attempt to index local 'bossInfo' (a nil value)
					if (haveData) then
						_detalhes:OpenRaidHistoryWindow (bossInfo.zone, bossInfo.id, diff, attribute == 1 and "damage" or "healing", true, 1, false, 2)
					end
				end
			end
		end
		return
	end
	
	if (_detalhes.in_combat) then
		_detalhes:Msg (Loc ["STRING_QUERY_INSPECT_FAIL1"])
		return
	end
	
	if (self.showing == "actor") then
	
		if (_detalhes.ilevel.core:HasQueuedInspec (self.unitname)) then
		
			--> icon animation
			local anim = tremove (_detalhes.icon_animations.load.available)
			if (not anim) then
				icon_frame_create_animation()
				anim = tremove (_detalhes.icon_animations.load.available)
			end
		
			local f = anim
			if (not f.question_icon) then
				f.question_icon = self:GetParent():GetParent().border:CreateTexture (nil, "overlay")
				f.question_icon:SetTexture ([[Interface\GossipFrame\ActiveLegendaryQuestIcon]])
				f.question_icon:SetSize (16, 16)
			end

			f.question_icon:ClearAllPoints()
			f.question_icon:SetPoint ("center", self, "center")
			f.question_icon:Show()
			
			if (not _detalhes.HideBarQuestionIcon) then
				function _detalhes:HideBarQuestionIcon (frame)
					frame.question_icon:Hide()
				end
			end
			_detalhes:ScheduleTimer ("HideBarQuestionIcon", 1, f)
		
			self.icon_animation = anim
			anim.icon_frame = self
			
			local pid
			pid = icon_frame_events:ScheduleTimer ("CancelAnim", 1, {anim})
			_detalhes.icon_animations.load.in_use [anim] = pid
			anim.parent = self
		
			return
		end

		local does_query = _detalhes.ilevel.core:QueryInspect (self.unitname, icon_frame_inspect_callback, self)
		
		if (self.icon_animation) then
			return
		end
		
		--> icon animation
		local anim = tremove (_detalhes.icon_animations.load.available)
		if (not anim) then
			icon_frame_create_animation()
			anim = tremove (_detalhes.icon_animations.load.available)
		end
		
		anim:Show()
		anim:SetParent (self)
		anim:ClearAllPoints()
		anim:SetFrameStrata ("TOOLTIP")
		anim:SetPoint ("center", self, "center")
		anim:SetSize (self:GetWidth()*1.7, self:GetHeight()*1.7)
		
		anim.anim:Play()
		
		self.icon_animation = anim
		anim.icon_frame = self
		
		local pid
		if (does_query) then
			pid = icon_frame_events:ScheduleTimer ("CancelAnim", 4, {anim, true})
		else
			pid = icon_frame_events:ScheduleTimer ("CancelAnim", 0.2, {anim})
		end
		_detalhes.icon_animations.load.in_use [anim] = pid
		anim.parent = self
		
		if (anim.question_icon) then
			anim.question_icon:Hide()
		end
	end
end

local set_frame_icon_scripts = function (row)
	row.icon_frame:SetScript ("OnEnter", icon_frame_on_enter)
	row.icon_frame:SetScript ("OnLeave", icon_frame_on_leave)
	row.icon_frame:SetScript ("OnMouseDown", icon_frame_on_click_down)
	row.icon_frame:SetScript ("OnMouseUp", icon_frame_on_click_up)
end

local function barra_scripts (esta_barra, instancia, i)
	esta_barra._instance = instancia

	esta_barra:SetScript ("OnEnter", barra_scripts_onenter) 
	esta_barra:SetScript ("OnLeave", barra_scripts_onleave) 
	esta_barra:SetScript ("OnMouseDown", barra_scripts_onmousedown)
	esta_barra:SetScript ("OnMouseUp", barra_scripts_onmouseup)
	esta_barra:SetScript ("OnClick", barra_scripts_onclick)
	
	esta_barra:SetScript ("OnShow", barra_scripts_onshow)
	
	set_frame_icon_scripts (esta_barra)
	
	esta_barra.SetValue = set_bar_value
end

function _detalhes:ReportSingleLine (instancia, barra)

	local reportar
	if (instancia.atributo == 5) then --> custom
	
		--> dump cooltip
		local GameCooltip = GameCooltip
		if (GameCooltipFrame1:IsShown()) then
			local actor_name = barra.texto_esquerdo:GetText() or ""
			actor_name = actor_name:gsub ((".*%."), "")
			
			if (instancia.segmento == -1) then --overall
				reportar = {"Details!: "  .. Loc ["STRING_OVERALL"] .. " " .. instancia.customName .. ": " .. actor_name .. " " .. Loc ["STRING_CUSTOM_REPORT"]}
			else
				reportar = {"Details!: " .. instancia.customName .. ": " .. actor_name .. " " .. Loc ["STRING_CUSTOM_REPORT"]}
			end
		
			local amt = GameCooltip.Indexes
			for i = 2, amt do
				local left_text, right_text = GameCooltip:GetText (i)
				reportar [#reportar+1] = (i-1) .. ". " .. left_text .. " ... " .. right_text
			end
		else
			reportar = {"Details!: " .. instancia.customName .. ": " .. Loc ["STRING_CUSTOM_REPORT"]}
			reportar [#reportar+1] = barra.texto_esquerdo:GetText() .. " " .. barra.texto_direita:GetText()
			
			--reportar [#reportar+1] = (i-1) .. ". " .. left_text .. " ... " .. right_text
		end
		
	else
		reportar = {"Details!: " .. Loc ["STRING_REPORT"] .. " " .. _detalhes.sub_atributos [instancia.atributo].lista [instancia.sub_atributo]}
		reportar [#reportar+1] = barra.texto_esquerdo:GetText() .. " " .. barra.texto_direita:GetText()
	end


	return _detalhes:Reportar (reportar, {_no_current = true, _no_inverse = true, _custom = true})
end

-- ~stretch
local function button_stretch_scripts (baseframe, backgrounddisplay, instancia)
	local button = baseframe.button_stretch

	button:SetScript ("OnEnter", function (self)
		self.mouse_over = true
		if (not _detalhes.disable_stretch_button) then
			gump:Fade (self, "ALPHA", 1)
		end
	end)
	button:SetScript ("OnLeave", function (self)
		self.mouse_over = false
		gump:Fade (self, "ALPHA", 0)
	end)	

	button:SetScript ("OnMouseDown", function (self, button)

		if (button ~= "LeftButton") then
			return
		end
	
		if (instancia:IsSoloMode()) then
			return
		end
	
		instancia:EsconderScrollBar (true)
		baseframe._place = instancia:SaveMainWindowPosition()
		baseframe.isResizing = true
		baseframe.isStretching = true
		baseframe:SetFrameStrata ("TOOLTIP")
		instancia.rowframe:SetFrameStrata ("TOOLTIP")
		
		local _r, _g, _b, _a = baseframe:GetBackdropColor()
		gump:GradientEffect ( baseframe, "frame", _r, _g, _b, _a, _r, _g, _b, 0.9, 1.5)
		if (instancia.wallpaper.enabled) then
			_r, _g, _b = baseframe.wallpaper:GetVertexColor()
			_a = baseframe.wallpaper:GetAlpha()
			gump:GradientEffect (baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, 0.05, 0.5)
		end
		
		if (instancia.stretch_button_side == 1) then
			baseframe:StartSizing ("top")
			baseframe.stretch_direction = "top"
		elseif (instancia.stretch_button_side == 2) then
			baseframe:StartSizing ("bottom")
			baseframe.stretch_direction = "bottom"
		end
		
		local linha_horizontal = {}
	
		local checking = instancia
		for i = instancia.meu_id-1, 1, -1 do 
			local esta_instancia = _detalhes.tabela_instancias [i]
			if ((esta_instancia.snap[1] and esta_instancia.snap[1] == checking.meu_id) or (esta_instancia.snap[3] and esta_instancia.snap[3] == checking.meu_id)) then
				linha_horizontal [#linha_horizontal+1] = esta_instancia
				checking = esta_instancia
			else
				break
			end
		end
		
		checking = instancia
		for i = instancia.meu_id+1, #_detalhes.tabela_instancias do 
			local esta_instancia = _detalhes.tabela_instancias [i]
			if ((esta_instancia.snap[1] and esta_instancia.snap[1] == checking.meu_id) or (esta_instancia.snap[3] and esta_instancia.snap[3] == checking.meu_id)) then
				linha_horizontal [#linha_horizontal+1] = esta_instancia
				checking = esta_instancia
			else
				break
			end
		end
		
		instancia.stretchToo = linha_horizontal
		if (#instancia.stretchToo > 0) then
			for _, esta_instancia in ipairs (instancia.stretchToo) do 
				esta_instancia:EsconderScrollBar (true)
				esta_instancia.baseframe._place = esta_instancia:SaveMainWindowPosition()
				esta_instancia.baseframe.isResizing = true
				esta_instancia.baseframe.isStretching = true
				esta_instancia.baseframe:SetFrameStrata ("TOOLTIP")
				esta_instancia.rowframe:SetFrameStrata ("TOOLTIP")
				
				local _r, _g, _b, _a = esta_instancia.baseframe:GetBackdropColor()
				gump:GradientEffect ( esta_instancia.baseframe, "frame", _r, _g, _b, _a, _r, _g, _b, 0.9, 1.5)
				_detalhes:SendEvent ("DETAILS_INSTANCE_STARTSTRETCH", nil, esta_instancia)
				
				if (esta_instancia.wallpaper.enabled) then
					_r, _g, _b = esta_instancia.baseframe.wallpaper:GetVertexColor()
					_a = esta_instancia.baseframe.wallpaper:GetAlpha()
					gump:GradientEffect (esta_instancia.baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, 0.05, 0.5)
				end
				
			end
		end
		
		_detalhes:SnapTextures (true)
		
		_detalhes:SendEvent ("DETAILS_INSTANCE_STARTSTRETCH", nil, instancia)
		
		--> change the update speed
		if (_detalhes.update_speed > 0.3) then
			_detalhes:SetWindowUpdateSpeed (0.3, true)
			_detalhes.stretch_changed_update_speed = true
		end
		
	end)
	
	button:SetScript ("OnMouseUp", function (self, button)
	
		if (button ~= "LeftButton") then
			return
		end
	
		if (instancia:IsSoloMode()) then
			return
		end
	
		if (baseframe.isResizing) then 
			baseframe:StopMovingOrSizing()
			baseframe.isResizing = false
			instancia:RestoreMainWindowPosition (baseframe._place)
			instancia:ReajustaGump()
			baseframe.isStretching = false
			if (instancia.need_rolagem) then
				instancia:MostrarScrollBar (true)
			end
			_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, instancia)
			
			instancia:RefreshBars()
			instancia:InstanceReset()
			instancia:ReajustaGump()
			
			baseframe.stretch_direction = nil
			
			if (instancia.stretchToo and #instancia.stretchToo > 0) then
				for _, esta_instancia in ipairs (instancia.stretchToo) do 
					esta_instancia.baseframe:StopMovingOrSizing()
					esta_instancia.baseframe.isResizing = false
					esta_instancia:RestoreMainWindowPosition (esta_instancia.baseframe._place)
					esta_instancia:ReajustaGump()
					esta_instancia.baseframe.isStretching = false
					if (esta_instancia.need_rolagem) then
						esta_instancia:MostrarScrollBar (true)
					end
					_detalhes:SendEvent ("DETAILS_INSTANCE_SIZECHANGED", nil, esta_instancia)
					
					local _r, _g, _b, _a = esta_instancia.baseframe:GetBackdropColor()
					gump:GradientEffect ( esta_instancia.baseframe, "frame", _r, _g, _b, _a, instancia.bg_r, instancia.bg_g, instancia.bg_b, instancia.bg_alpha, 0.5)
					
					if (esta_instancia.wallpaper.enabled) then
						_r, _g, _b = esta_instancia.baseframe.wallpaper:GetVertexColor()
						_a = esta_instancia.baseframe.wallpaper:GetAlpha()
						gump:GradientEffect (esta_instancia.baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, esta_instancia.wallpaper.alpha, 1.0)
					end
					
					esta_instancia.baseframe:SetFrameStrata (esta_instancia.strata)
					esta_instancia.rowframe:SetFrameStrata (esta_instancia.strata)
					esta_instancia:StretchButtonAlwaysOnTop()
					
					_detalhes:SendEvent ("DETAILS_INSTANCE_ENDSTRETCH", nil, esta_instancia.baseframe)
					
					esta_instancia:RefreshBars()
					esta_instancia:InstanceReset()
					esta_instancia:ReajustaGump()
				end
				instancia.stretchToo = nil
			end
			
		end 
		
		local _r, _g, _b, _a = baseframe:GetBackdropColor()
		gump:GradientEffect ( baseframe, "frame", _r, _g, _b, _a, instancia.bg_r, instancia.bg_g, instancia.bg_b, instancia.bg_alpha, 0.5)
		if (instancia.wallpaper.enabled) then
			_r, _g, _b = baseframe.wallpaper:GetVertexColor()
			_a = baseframe.wallpaper:GetAlpha()
			gump:GradientEffect (baseframe.wallpaper, "texture", _r, _g, _b, _a, _r, _g, _b, instancia.wallpaper.alpha, 1.0)
		end
		
		baseframe:SetFrameStrata (instancia.strata)
		instancia.rowframe:SetFrameStrata (instancia.strata)
		instancia:StretchButtonAlwaysOnTop()
		
		_detalhes:SnapTextures (false)
		
		_detalhes:SendEvent ("DETAILS_INSTANCE_ENDSTRETCH", nil, instancia)
		
		if (_detalhes.stretch_changed_update_speed) then
			_detalhes:SetWindowUpdateSpeed (false, true)
			_detalhes.stretch_changed_update_speed = nil
		end

	end)	
end

local function button_down_scripts (main_frame, backgrounddisplay, instancia, scrollbar)
	main_frame.button_down:SetScript ("OnMouseDown", function(self)
		if (not scrollbar:IsEnabled()) then
			return
		end
		
		local B = instancia.barraS[2]
		if (B < instancia.rows_showing) then
			scrollbar:SetValue (scrollbar:GetValue() + instancia.row_height)
		end
		
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function(self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				B = instancia.barraS[2]
				if (B < instancia.rows_showing) then
					scrollbar:SetValue (scrollbar:GetValue() + instancia.row_height)
				else
					self:Disable()
				end
			end
		end)
	end)
	
	main_frame.button_down:SetScript ("OnMouseUp", function (self) 
		self.precionado = false
		self:SetScript ("OnUpdate", nil)
	end)
end

local function button_up_scripts (main_frame, backgrounddisplay, instancia, scrollbar)

	main_frame.button_up:SetScript ("OnMouseDown", function(self) 

		if (not scrollbar:IsEnabled()) then
			return
		end
		
		local A = instancia.barraS[1]
		if (A > 1) then
			scrollbar:SetValue (scrollbar:GetValue() - instancia.row_height*2)
		end
		
		self.precionado = true
		self.last_up = -0.3
		self:SetScript ("OnUpdate", function (self, elapsed)
			self.last_up = self.last_up + elapsed
			if (self.last_up > 0.03) then
				self.last_up = 0
				A = instancia.barraS[1]
				if (A > 1) then
					scrollbar:SetValue (scrollbar:GetValue() + instancia.row_height*2)
				else
					self:Disable()
				end
			end
		end)
	end)
	
	main_frame.button_up:SetScript ("OnMouseUp", function (self) 
		self.precionado = false
		self:SetScript ("OnUpdate", nil)
	end)	

	main_frame.button_up:SetScript ("OnEnable", function (self)
		local current = scrollbar:GetValue()
		if (current == 0) then
			main_frame.button_up:Disable()
		end
	end)
end

function DetailsKeyBindScrollUp()

	local last_key_pressed = _detalhes.KeyBindScrollUpLastPressed or GetTime()-0.3
	
	local to_top = false
	if (last_key_pressed+0.2 > GetTime()) then
		to_top = true
	end
	
	_detalhes.KeyBindScrollUpLastPressed = GetTime()
	
	for index, instance in ipairs (_detalhes.tabela_instancias) do
		if (instance:IsEnabled()) then
			
			local scrollbar = instance.scroll
			
			local A = instance.barraS[1]
			if (A and A > 1) then
				if (to_top) then
					scrollbar:SetValue (0)
					scrollbar.ultimo = 0
					instance.baseframe.button_up:Disable()
				else
					scrollbar:SetValue (scrollbar:GetValue() - instance.row_height*2)
				end
			elseif (A) then
				scrollbar:SetValue (0)
				scrollbar.ultimo = 0
				instance.baseframe.button_up:Disable()
			end
			
		end
	end
end

function DetailsKeyBindScrollDown()
	for index, instance in ipairs (_detalhes.tabela_instancias) do
		if (instance:IsEnabled()) then
			
			local scrollbar = instance.scroll
			
			local B = instance.barraS[2]
			if (B and B < instance.rows_showing) then
				scrollbar:SetValue (scrollbar:GetValue() + instance.row_height*2)
			elseif (B) then
				local _, maxValue = scrollbar:GetMinMaxValues()
				scrollbar:SetValue (maxValue)
				scrollbar.ultimo = maxValue
				instance.baseframe.button_down:Disable()
			end
			
		end
	end
end

local function iterate_scroll_scripts (backgrounddisplay, backgroundframe, baseframe, scrollbar, instancia)

	baseframe:SetScript ("OnMouseWheel", 
		function (self, delta)
			if (delta > 0) then --> rolou pra cima
				local A = instancia.barraS[1]
				if (A) then
					if (A > 1) then
						scrollbar:SetValue (scrollbar:GetValue() - instancia.row_height * _detalhes.scroll_speed)
					else
						scrollbar:SetValue (0)
						scrollbar.ultimo = 0
						baseframe.button_up:Disable()
					end
				end
			elseif (delta < 0) then --> rolou pra baixo
				local B = instancia.barraS[2]
				if (B) then
					if (B < (instancia.rows_showing or 0)) then
						scrollbar:SetValue (scrollbar:GetValue() + instancia.row_height * _detalhes.scroll_speed)
					else
						local _, maxValue = scrollbar:GetMinMaxValues()
						scrollbar:SetValue (maxValue)
						scrollbar.ultimo = maxValue
						baseframe.button_down:Disable()
					end
				end
			end

		end)

	scrollbar:SetScript ("OnValueChanged", function (self)
		local ultimo = self.ultimo
		local meu_valor = self:GetValue()
		if (ultimo == meu_valor) then --> n�o mudou
			return
		end
		
		--> shortcut
		local minValue, maxValue = scrollbar:GetMinMaxValues()
		if (minValue == meu_valor) then
			instancia.barraS[1] = 1
			instancia.barraS[2] = instancia.rows_fit_in_window
			instancia:AtualizaGumpPrincipal (instancia, true)
			self.ultimo = meu_valor
			baseframe.button_up:Disable()
				return
		elseif (maxValue == meu_valor) then
			local min = (instancia.rows_showing or 0) -instancia.rows_fit_in_window
			min = min+1
			if (min < 1) then
				min = 1
			end
			instancia.barraS[1] = min
			instancia.barraS[2] = (instancia.rows_showing or 0)
			instancia:AtualizaGumpPrincipal (instancia, true)
			self.ultimo = meu_valor
			baseframe.button_down:Disable()
			return
		end
		
		if (not baseframe.button_up:IsEnabled()) then
			baseframe.button_up:Enable()
		end
		if (not baseframe.button_down:IsEnabled()) then
			baseframe.button_down:Enable()
		end
		
		if (meu_valor > ultimo) then --> scroll down
		
			local B = instancia.barraS[2]
			if (B < (instancia.rows_showing or 0)) then --> se o valor maximo n�o for o m�ximo de barras a serem mostradas	
				local precisa_passar = ((B+1) * instancia.row_height) - (instancia.row_height*instancia.rows_fit_in_window)
				--if (meu_valor > precisa_passar) then --> o valor atual passou o valor que precisa passar pra locomover
				if (true) then --> testing by pass row check
					local diff = meu_valor - ultimo --> pega a diferen�a de H
					diff = diff / instancia.row_height --> calcula quantas barras ele pulou
					diff = _math_ceil (diff) --> arredonda para cima
					if (instancia.barraS[2]+diff > (instancia.rows_showing or 0) and ultimo > 0) then
						instancia.barraS[1] = (instancia.rows_showing or 0) - (instancia.rows_fit_in_window-1)
						instancia.barraS[2] = (instancia.rows_showing or 0)
					else
						instancia.barraS[2] = instancia.barraS[2]+diff
						instancia.barraS[1] = instancia.barraS[1]+diff
					end
					instancia:AtualizaGumpPrincipal (instancia, true)
				end
			end
		else --> scroll up
			local A = instancia.barraS[1]
			if (A > 1) then
				local precisa_passar = (A-1) * instancia.row_height
				--if (meu_valor < precisa_passar) then
				if (true) then --> testing by pass row check
					--> calcula quantas barras passou
					local diff = ultimo - meu_valor
					diff = diff / instancia.row_height
					diff = _math_ceil (diff)
					if (instancia.barraS[1]-diff < 1) then
						instancia.barraS[2] = instancia.rows_fit_in_window
						instancia.barraS[1] = 1
					else
						instancia.barraS[2] = instancia.barraS[2]-diff
						instancia.barraS[1] = instancia.barraS[1]-diff
					end

					instancia:AtualizaGumpPrincipal (instancia, true)
				end
			end
		end
		self.ultimo = meu_valor
	end)		
end

function _detalhes:HaveInstanceAlert()
	return self.alert:IsShown()
end

function _detalhes:InstanceAlertTime (instance)
	instance.alert:Hide()
	instance.alert.rotate:Stop()
	instance.alert_time = nil
end

local hide_click_func = function()
	--empty
end

function _detalhes:InstanceAlert (msg, icon, time, clickfunc, doflash, forceAlert)
	
	if (not forceAlert and _detalhes.streamer_config.no_alerts) then
		return
	end
	
	if (not self.meu_id) then
		local lower = _detalhes:GetLowerInstanceNumber()
		if (lower) then
			self = _detalhes:GetInstance (lower)
		else
			return
		end
	end
	
	if (type (msg) == "boolean" and not msg) then
		self.alert:Hide()
		self.alert.rotate:Stop()
		self.alert_time = nil
		return
	end
	
	if (msg) then
		self.alert.text:SetText (msg)
	else
		self.alert.text:SetText ("")
	end
	
	if (icon) then
		if (type (icon) == "table") then
			local texture, w, h, animate, left, right, top, bottom, r, g, b, a = unpack (icon)
			
			self.alert.icon:SetTexture (texture)
			self.alert.icon:SetWidth (w or 14)
			self.alert.icon:SetHeight (h or 14)
			if (left and right and top and bottom) then
				self.alert.icon:SetTexCoord (left, right, top, bottom)
			end
			if (animate) then
				self.alert.rotate:Play()
			end
			if (r and g and b) then
				self.alert.icon:SetVertexColor (r, g, b, a or 1)
			end
		else
			self.alert.icon:SetWidth (14)
			self.alert.icon:SetHeight (14)
			self.alert.icon:SetTexture (icon)
			self.alert.icon:SetVertexColor (1, 1, 1, 1)
			self.alert.icon:SetTexCoord (0, 1, 0, 1)
		end
	else
		self.alert.icon:SetTexture (nil)
	end
	
	self.alert.button.func = nil
	wipe (self.alert.button.func_param)
	
	if (clickfunc) then
		self.alert.button.func = clickfunc[1]
		self.alert.button.func_param = {unpack (clickfunc, 2)}
	end

	time = time or 15
	self.alert_time = time
	_detalhes:ScheduleTimer ("InstanceAlertTime", time, self)
	
	self.alert:SetPoint ("bottom", self.baseframe, "bottom", 0, -12)
	self.alert:SetPoint ("left", self.baseframe, "left", 3, 0)
	self.alert:SetPoint ("right", self.baseframe, "right", -3, 0)
	
	self.alert:SetFrameStrata ("TOOLTIP")
	self.alert.button:SetFrameStrata ("TOOLTIP")
	
	self.alert:Show()
	
	if (doflash) then
		self.alert:DoFlash()
	end
	
	self.alert:Play()

end

local alert_on_click = function (self, button)
	if (self.func) then
		local okey, errortext = pcall (self.func, unpack (self.func_param))
		if (not okey) then
			_detalhes:Msg ("error on alert function:", errortext)
		end
	end
	self:GetParent():Hide()
end

local function CreateAlertFrame (baseframe, instancia)

	local frame_upper = CreateFrame ("scrollframe", "DetailsAlertFrameScroll" .. instancia.meu_id, baseframe)
	frame_upper:SetPoint ("bottom", baseframe, "bottom")
	frame_upper:SetPoint ("left", baseframe, "left", 3, 0)
	frame_upper:SetPoint ("right", baseframe, "right", -3, 0)
	frame_upper:SetHeight (13)
	frame_upper:SetFrameStrata ("TOOLTIP")
	
	local frame_lower = CreateFrame ("frame", "DetailsAlertFrameScrollChild" .. instancia.meu_id, frame_upper)
	frame_lower:SetHeight (25)
	frame_lower:SetPoint ("left", frame_upper, "left")
	frame_lower:SetPoint ("right", frame_upper, "right")
	frame_upper:SetScrollChild (frame_lower)

	local alert_bg = CreateFrame ("frame", "DetailsAlertFrame" .. instancia.meu_id, frame_lower)
	alert_bg:SetPoint ("bottom", baseframe, "bottom")
	alert_bg:SetPoint ("left", baseframe, "left", 3, 0)
	alert_bg:SetPoint ("right", baseframe, "right", -3, 0)
	alert_bg:SetHeight (12)
	alert_bg:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
	insets = {left = 0, right = 0, top = 0, bottom = 0}})
	alert_bg:SetBackdropColor (.1, .1, .1, 1)
	alert_bg:SetFrameStrata ("FULLSCREEN")
	alert_bg:SetFrameLevel (baseframe:GetFrameLevel() + 6)
	alert_bg:Hide()

	local toptexture = alert_bg:CreateTexture (nil, "background")
	toptexture:SetTexture ([[Interface\Challenges\challenges-main]])
	--toptexture:SetTexCoord (0.1921484375, 0.523671875, 0.234375, 0.160859375)
	toptexture:SetTexCoord (0.231171875, 0.4846484375, 0.0703125, 0.072265625)
	toptexture:SetPoint ("left", alert_bg, "left")
	toptexture:SetPoint ("right", alert_bg, "right")
	toptexture:SetPoint ("bottom", alert_bg, "top", 0, 0)
	toptexture:SetHeight (1)
	
	local text = alert_bg:CreateFontString (nil, "overlay", "GameFontNormal")
	text:SetPoint ("right", alert_bg, "right", -14, 0)
	_detalhes:SetFontSize (text, 10)
	text:SetTextColor (1, 1, 1, 0.8)
	
	local rotate_frame = CreateFrame ("frame", "DetailsAlertFrameRotate" .. instancia.meu_id, alert_bg)
	rotate_frame:SetWidth (12)
	rotate_frame:SetPoint ("right", alert_bg, "right", -2, 0)
	rotate_frame:SetHeight (alert_bg:GetWidth())
	rotate_frame:SetFrameStrata ("FULLSCREEN")
	
	local icon = rotate_frame:CreateTexture (nil, "overlay")
	icon:SetPoint ("center", rotate_frame, "center")
	icon:SetWidth (14)
	icon:SetHeight (14)
	
	local button = CreateFrame ("button", "DetailsInstance"..instancia.meu_id.."AlertButton", alert_bg)
	button:SetAllPoints()
	button:SetFrameStrata ("FULLSCREEN")
	button:SetScript ("OnClick", alert_on_click)
	button._instance = instancia
	button.func_param = {}
	
	local RotateAnimGroup = rotate_frame:CreateAnimationGroup()
	local rotate = RotateAnimGroup:CreateAnimation ("Rotation")
	rotate:SetDegrees (360)
	rotate:SetDuration (6)
	RotateAnimGroup:SetLooping ("repeat")
	
	alert_bg:Hide()
	
	local anime = alert_bg:CreateAnimationGroup()
	anime.group = anime:CreateAnimation ("Translation")
	anime.group:SetDuration (0.15)
	anime.group:SetOffset (0, 10)
	anime:SetScript ("OnFinished", function(self) 
		alert_bg:Show()
		alert_bg:SetPoint ("bottom", baseframe, "bottom", 0, 0)
		alert_bg:SetPoint ("left", baseframe, "left", 3, 0)
		alert_bg:SetPoint ("right", baseframe, "right", -3, 0)
	end)
	
	local on_enter_alert = function (self)
		text:SetTextColor (1, 0.8, 0.3, 1)
		icon:SetBlendMode ("ADD")
	end
	local on_leave_alert = function (self)
		text:SetTextColor (1, 1, 1, 0.8)
		icon:SetBlendMode ("BLEND")
	end
	
	button:SetScript ("OnEnter", on_enter_alert)
	button:SetScript ("OnLeave", on_leave_alert)

	function alert_bg:Play()
		anime:Play()
	end
	
	local flash_texture = button:CreateTexture (nil, "overlay")
	flash_texture:SetTexCoord (53/512, 347/512, 58/256, 120/256)
	flash_texture:SetTexture ([[Interface\AchievementFrame\UI-Achievement-Alert-Glow]])
	flash_texture:SetAllPoints()
	flash_texture:SetBlendMode ("ADD")
	local animation = flash_texture:CreateAnimationGroup()
	local anim1 = animation:CreateAnimation ("ALPHA")
	local anim2 = animation:CreateAnimation ("ALPHA")
	anim1:SetOrder (1)
	
	anim1:SetFromAlpha (0)
	anim1:SetToAlpha (1)
	
	anim1:SetDuration (0.1)
	anim2:SetOrder (2)
	
	anim1:SetFromAlpha (1)
	anim1:SetToAlpha (0)
	
	anim2:SetDuration (0.2)
	animation:SetScript ("OnFinished", function (self)
		flash_texture:Hide()
	end)
	flash_texture:Hide()
	
	local do_flash = function()
		flash_texture:Show()
		animation:Play()
	end
	
	function alert_bg:DoFlash()
		C_Timer.After (0.23, do_flash)
	end
	
	alert_bg.text = text
	alert_bg.icon = icon
	alert_bg.button = button
	alert_bg.rotate = RotateAnimGroup
	
	instancia.alert = alert_bg
	
	return alert_bg
end

function _detalhes:InstanceMsg (text, icon, textcolor, iconcoords, iconcolor)
	if (not text) then
		self.freeze_icon:Hide()
		return self.freeze_texto:Hide()
	end
	
	self.freeze_texto:SetText (text)
	self.freeze_icon:SetTexture (icon or [[Interface\CHARACTERFRAME\Disconnect-Icon]])

	self.freeze_icon:Show()
	self.freeze_texto:Show()
	
	if (textcolor) then
		local r, g, b, a = gump:ParseColors (textcolor)
		self.freeze_texto:SetTextColor (r, g, b, a)
	else
		self.freeze_texto:SetTextColor (1, 1, 1, 1)
	end
	
	if (iconcoords and type (iconcoords) == "table") then
		self.freeze_icon:SetTexCoord (_unpack (iconcoords))
	else
		self.freeze_icon:SetTexCoord (0, 1, 0, 1)
	end
	
	if (iconcolor) then
		local r, g, b, a = gump:ParseColors (iconcolor)
		self.freeze_icon:SetVertexColor (r, g, b, a)
	else
		self.freeze_icon:SetVertexColor (1, 1, 1, 1)
	end
end

function _detalhes:schedule_hide_anti_overlap (self)
	self:Hide()
	self.schdule = nil
end
local function hide_anti_overlap (self)
	if (self.schdule) then
		_detalhes:CancelTimer (self.schdule)
		self.schdule = nil
	end
	local schdule = _detalhes:ScheduleTimer ("schedule_hide_anti_overlap", 0.3, self)
	self.schdule = schdule
end

local function show_anti_overlap (instance, host, side)

	local anti_menu_overlap = instance.baseframe.anti_menu_overlap

	if (anti_menu_overlap.schdule) then
		_detalhes:CancelTimer (anti_menu_overlap.schdule)
		anti_menu_overlap.schdule = nil
	end

	anti_menu_overlap:ClearAllPoints()
	if (side == "top") then
		anti_menu_overlap:SetPoint ("bottom", host, "top")
	elseif (side == "bottom") then
		anti_menu_overlap:SetPoint ("top", host, "bottom")
	end
	anti_menu_overlap:Show()
end

_detalhes.snap_alert = CreateFrame ("frame", "DetailsSnapAlertFrame", UIParent, "ActionBarButtonSpellActivationAlert")
_detalhes.snap_alert:Hide()
_detalhes.snap_alert:SetFrameStrata ("FULLSCREEN")

function _detalhes:SnapAlert()
	_detalhes.snap_alert:ClearAllPoints()
	_detalhes.snap_alert:SetPoint ("topleft", self.baseframe.cabecalho.modo_selecao.widget, "topleft", -8, 6)
	_detalhes.snap_alert:SetPoint ("bottomright", self.baseframe.cabecalho.modo_selecao.widget, "bottomright", 8, -6)
	_detalhes.snap_alert.animOut:Stop()
	_detalhes.snap_alert.animIn:Play()
end

do

	--search key: ~tooltip
	local tooltip_anchor = CreateFrame ("frame", "DetailsTooltipAnchor", UIParent)
	tooltip_anchor:SetSize (140, 20)
	tooltip_anchor:SetAlpha (0)
	tooltip_anchor:SetMovable (false)
	tooltip_anchor:SetClampedToScreen (true)
	tooltip_anchor.locked = true
	tooltip_anchor:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]], edgeSize = 10, insets = {left = 1, right = 1, top = 2, bottom = 1}})
	tooltip_anchor:SetBackdropColor (0, 0, 0, 1)

	tooltip_anchor:SetScript ("OnEnter", function (self)
		tooltip_anchor.alert.animIn:Stop()
		tooltip_anchor.alert.animOut:Play()
		GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
		GameTooltip:ClearLines()
		GameTooltip:AddLine (Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT_DESC"])
		GameTooltip:Show()
	end)
	
	tooltip_anchor:SetScript ("OnLeave", function (self)
		GameTooltip:Hide()
	end)
	
	tooltip_anchor:SetScript ("OnMouseDown", function (self, button)
		if (not self.moving and button == "LeftButton") then
			self:StartMoving()
			self.moving = true
		end
	end)
	
	tooltip_anchor:SetScript ("OnMouseUp", function (self, button)
		if (self.moving) then
			self:StopMovingOrSizing()
			self.moving = false
			local xofs, yofs = self:GetCenter() 
			local scale = self:GetEffectiveScale()
			local UIscale = UIParent:GetScale()
			xofs = xofs * scale - GetScreenWidth() * UIscale / 2
			yofs = yofs * scale - GetScreenHeight() * UIscale / 2
			_detalhes.tooltip.anchor_screen_pos[1] = xofs / UIscale
			_detalhes.tooltip.anchor_screen_pos[2] = yofs / UIscale
			
		elseif (button == "RightButton" and not self.moving) then
			tooltip_anchor:MoveAnchor()
		end
	end)
	
	function tooltip_anchor:MoveAnchor()
		if (self.locked) then
			self:SetAlpha (1)
			self:EnableMouse (true)
			self:SetMovable (true)
			self:SetFrameStrata ("FULLSCREEN")
			self.locked = false
			tooltip_anchor.alert.animOut:Stop()
			tooltip_anchor.alert.animIn:Play()
		else
			self:SetAlpha (0)
			self:EnableMouse (false)
			self:SetFrameStrata ("MEDIUM")
			self:SetMovable (false)
			self.locked = true
			tooltip_anchor.alert.animIn:Stop()
			tooltip_anchor.alert.animOut:Play()
		end
	end
	
	function tooltip_anchor:Restore()
		local x, y = _detalhes.tooltip.anchor_screen_pos[1], _detalhes.tooltip.anchor_screen_pos[2]
		local scale = self:GetEffectiveScale() 
		local UIscale = UIParent:GetScale()
		x = x * UIscale / scale
		y = y * UIscale / scale
		self:ClearAllPoints()
		self:SetParent (UIParent)
		self:SetPoint ("center", UIParent, "center", x, y)
	end
	
	tooltip_anchor.alert = CreateFrame ("frame", "DetailsTooltipAnchorAlert", UIParent, "ActionBarButtonSpellActivationAlert")
	tooltip_anchor.alert:SetFrameStrata ("FULLSCREEN")
	tooltip_anchor.alert:Hide()
	tooltip_anchor.alert:SetPoint ("topleft", tooltip_anchor, "topleft", -60, 6)
	tooltip_anchor.alert:SetPoint ("bottomright", tooltip_anchor, "bottomright", 40, -6)

	local icon = tooltip_anchor:CreateTexture (nil, "overlay")
	icon:SetTexture ([[Interface\AddOns\Details\images\minimap]])
	icon:SetPoint ("left", tooltip_anchor, "left", 4, 0)
	icon:SetSize (18, 18)
	
	local text = tooltip_anchor:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
	text:SetPoint ("left", icon, "right", 6, 0)
	text:SetText (Loc ["STRING_OPTIONS_TOOLTIPS_ANCHOR_TEXT"])
	
	tooltip_anchor:EnableMouse (false)

end

--> ~inicio ~janela ~window ~nova ~start
function gump:CriaJanelaPrincipal (ID, instancia, criando)

-- main frames -----------------------------------------------------------------------------------------------------------------------------------------------

	--> create the base frame, everything connect in this frame except the rows.
	local baseframe = CreateFrame ("scrollframe", "DetailsBaseFrame"..ID, _UIParent) --
	baseframe:SetMovable (true)
	baseframe:SetResizable (true)
	baseframe:SetUserPlaced (false)
	baseframe:SetDontSavePosition (true)

	baseframe.instance = instancia
	baseframe:SetFrameStrata (baseframe_strata)
	baseframe:SetFrameLevel (2)

	--> background holds the wallpaper, alert strings ans textures, have setallpoints on baseframe
	--> backgrounddisplay is a scrollschild of backgroundframe
	local backgroundframe =  CreateFrame ("scrollframe", "Details_WindowFrame"..ID, baseframe)
	local backgrounddisplay = CreateFrame ("frame", "Details_GumpFrame"..ID, backgroundframe)
	backgroundframe:SetFrameLevel (3)
	backgrounddisplay:SetFrameLevel (3)
	backgroundframe.instance = instancia
	backgrounddisplay.instance = instancia
	instancia.windowBackgroundDisplay = backgrounddisplay
	
	--> row frame is the parent of rows, it have setallpoints on baseframe
	local rowframe = CreateFrame ("frame", "DetailsRowFrame"..ID, _UIParent)
	rowframe:SetAllPoints (baseframe)
	rowframe:SetFrameStrata (baseframe_strata)
	rowframe:SetFrameLevel (2)
	instancia.rowframe = rowframe
	
	--> right click bookmark
	local switchbutton = gump:NewDetailsButton (backgrounddisplay, baseframe, nil, function() end, nil, nil, 1, 1, "", "", "", "", 
	{rightFunc = {func = function() _detalhes.switch:ShowMe (instancia) end, param1 = nil, param2 = nil}}, "Details_SwitchButtonFrame" ..  ID)
	
	switchbutton:SetPoint ("topleft", backgrounddisplay, "topleft")
	switchbutton:SetPoint ("bottomright", backgrounddisplay, "bottomright")
	switchbutton:SetFrameLevel (backgrounddisplay:GetFrameLevel()+1)
	
	instancia.windowSwitchButton = switchbutton
	
	--> avoid mouse hover over a high window when the menu is open for a lower instance.
	local anti_menu_overlap = CreateFrame ("frame", "Details_WindowFrameAntiMenuOverlap" .. ID, UIParent)
	anti_menu_overlap:SetSize (100, 13)
	anti_menu_overlap:SetFrameStrata ("DIALOG")
	anti_menu_overlap:EnableMouse (true)
	anti_menu_overlap:Hide()
	--anti_menu_overlap:SetBackdrop (gump_fundo_backdrop) --debug
	baseframe.anti_menu_overlap = anti_menu_overlap
	
	--> floating frame is an anchor for widgets which should be overlaying the window
	local floatingframe = CreateFrame ("frame", "DetailsInstance"..ID.."BorderHolder", baseframe)
	floatingframe:SetFrameLevel (baseframe:GetFrameLevel()+7)
	instancia.floatingframe = floatingframe

-- scroll bar -----------------------------------------------------------------------------------------------------------------------------------------------
--> create the scrollbar, almost not used.

	local scrollbar = CreateFrame ("slider", "Details_ScrollBar"..ID, backgrounddisplay) --> scroll
	
	--> scroll image-node up
		baseframe.scroll_up = backgrounddisplay:CreateTexture (nil, "background")
		baseframe.scroll_up:SetPoint ("topleft", backgrounddisplay, "topright", 0, 0)
		baseframe.scroll_up:SetTexture (DEFAULT_SKIN)
		baseframe.scroll_up:SetTexCoord (unpack (COORDS_SLIDER_TOP))
		baseframe.scroll_up:SetWidth (32)
		baseframe.scroll_up:SetHeight (32)
	
	--> scroll image-node down
		baseframe.scroll_down = backgrounddisplay:CreateTexture (nil, "background")
		baseframe.scroll_down:SetPoint ("bottomleft", backgrounddisplay, "bottomright", 0, 0)
		baseframe.scroll_down:SetTexture (DEFAULT_SKIN)
		baseframe.scroll_down:SetTexCoord (unpack (COORDS_SLIDER_DOWN))
		baseframe.scroll_down:SetWidth (32)
		baseframe.scroll_down:SetHeight (32)
	
	--> scroll image-node middle
		baseframe.scroll_middle = backgrounddisplay:CreateTexture (nil, "background")
		baseframe.scroll_middle:SetPoint ("top", baseframe.scroll_up, "bottom", 0, 8)
		baseframe.scroll_middle:SetPoint ("bottom", baseframe.scroll_down, "top", 0, -11)
		baseframe.scroll_middle:SetTexture (DEFAULT_SKIN)
		baseframe.scroll_middle:SetTexCoord (unpack (COORDS_SLIDER_MIDDLE))
		baseframe.scroll_middle:SetWidth (32)
		baseframe.scroll_middle:SetHeight (64)
	
	--> scroll widgets
		baseframe.button_up = CreateFrame ("button", "DetailsScrollUp" .. instancia.meu_id, backgrounddisplay)
		baseframe.button_down = CreateFrame ("button", "DetailsScrollDown" .. instancia.meu_id, backgrounddisplay)
	
		baseframe.button_up:SetWidth (29)
		baseframe.button_up:SetHeight (32)
		baseframe.button_up:SetNormalTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Up]])
		baseframe.button_up:SetPushedTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Down]])
		baseframe.button_up:SetDisabledTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollUpButton-Disabled]])
		baseframe.button_up:Disable()

		baseframe.button_down:SetWidth (29)
		baseframe.button_down:SetHeight (32)
		baseframe.button_down:SetNormalTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Up]])
		baseframe.button_down:SetPushedTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Down]])
		baseframe.button_down:SetDisabledTexture ([[Interface\BUTTONS\UI-ScrollBar-ScrollDownButton-Disabled]])
		baseframe.button_down:Disable()

		baseframe.button_up:SetPoint ("topright", baseframe.scroll_up, "topright", -4, 3)
		baseframe.button_down:SetPoint ("bottomright", baseframe.scroll_down, "bottomright", -4, -6)

		scrollbar:SetPoint ("top", baseframe.button_up, "bottom", 0, 12)
		scrollbar:SetPoint ("bottom", baseframe.button_down, "top", 0, -12)
		scrollbar:SetPoint ("left", backgrounddisplay, "right", 3, 0)
		scrollbar:Show()

		--> config set
		scrollbar:SetOrientation ("VERTICAL")
		scrollbar.scrollMax = 0
		scrollbar:SetMinMaxValues (0, 0)
		scrollbar:SetValue (0)
		scrollbar.ultimo = 0
		
		--> thumb
		scrollbar.thumb = scrollbar:CreateTexture (nil, "overlay")
		scrollbar.thumb:SetTexture ([[Interface\Buttons\UI-ScrollBar-Knob]])
		scrollbar.thumb:SetSize (29, 30)
		scrollbar:SetThumbTexture (scrollbar.thumb)
		
		--> scripts
		button_down_scripts (baseframe, backgrounddisplay, instancia, scrollbar)
		button_up_scripts (baseframe, backgrounddisplay, instancia, scrollbar)
	
-- stretch button -----------------------------------------------------------------------------------------------------------------------------------------------

		baseframe.button_stretch = CreateFrame ("button", "DetailsButtonStretch" .. instancia.meu_id, baseframe)
		baseframe.button_stretch:SetPoint ("bottom", baseframe, "top", 0, 20)
		baseframe.button_stretch:SetPoint ("right", baseframe, "right", -27, 0)
		baseframe.button_stretch:SetFrameLevel (1)
		
		local stretch_texture = baseframe.button_stretch:CreateTexture (nil, "overlay")
		stretch_texture:SetTexture (DEFAULT_SKIN)
		stretch_texture:SetTexCoord (unpack (COORDS_STRETCH))
		stretch_texture:SetWidth (32)
		stretch_texture:SetHeight (16)
		stretch_texture:SetAllPoints (baseframe.button_stretch)
		baseframe.button_stretch.texture = stretch_texture
		
		baseframe.button_stretch:SetWidth (32)
		baseframe.button_stretch:SetHeight (16)
		
		baseframe.button_stretch:Show()
		gump:Fade (baseframe.button_stretch, "ALPHA", 0)

		button_stretch_scripts (baseframe, backgrounddisplay, instancia)

-- main window config -------------------------------------------------------------------------------------------------------------------------------------------------

		baseframe:SetClampedToScreen (true)
		baseframe:SetSize (_detalhes.new_window_size.width, _detalhes.new_window_size.height)
		
		baseframe:SetPoint ("center", _UIParent)
		baseframe:EnableMouseWheel (false)
		baseframe:EnableMouse (true)
		baseframe:SetMinResize (150, 7)
		baseframe:SetMaxResize (_detalhes.max_window_size.width, _detalhes.max_window_size.height)

		baseframe:SetBackdrop (gump_fundo_backdrop)
		baseframe:SetBackdropColor (instancia.bg_r, instancia.bg_g, instancia.bg_b, instancia.bg_alpha)
	
-- background window config -------------------------------------------------------------------------------------------------------------------------------------------------

		backgroundframe:SetAllPoints (baseframe)
		backgroundframe:SetScrollChild (backgrounddisplay)
		
		backgrounddisplay:SetResizable (true)
		backgrounddisplay:SetPoint ("topleft", baseframe, "topleft")
		backgrounddisplay:SetPoint ("bottomright", baseframe, "bottomright")
		backgrounddisplay:SetBackdrop (gump_fundo_backdrop)
		backgrounddisplay:SetBackdropColor (instancia.bg_r, instancia.bg_g, instancia.bg_b, instancia.bg_alpha)
	
-- instance mini widgets -------------------------------------------------------------------------------------------------------------------------------------------------

	--> overall data warning
		instancia.overall_data_warning = backgrounddisplay:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		instancia.overall_data_warning:SetHeight (64)
		instancia.overall_data_warning:SetPoint ("center", backgrounddisplay, "center")
		instancia.overall_data_warning:SetTextColor (.8, .8, .8, .5)
		instancia.overall_data_warning:Hide()
		instancia.overall_data_warning:SetText (Loc ["STRING_TUTORIAL_OVERALL1"])

	--> freeze icon
		instancia.freeze_icon = backgrounddisplay:CreateTexture (nil, "overlay")
			instancia.freeze_icon:SetWidth (64)
			instancia.freeze_icon:SetHeight (64)
			instancia.freeze_icon:SetPoint ("center", backgrounddisplay, "center")
			instancia.freeze_icon:SetPoint ("left", backgrounddisplay, "left")
			instancia.freeze_icon:Hide()
	
		instancia.freeze_texto = backgrounddisplay:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			instancia.freeze_texto:SetHeight (64)
			instancia.freeze_texto:SetPoint ("left", instancia.freeze_icon, "right", -18, 0)
			instancia.freeze_texto:SetTextColor (1, 1, 1)
			instancia.freeze_texto:Hide()
	
	--> details version
		instancia._version = baseframe:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			--instancia._version:SetPoint ("left", backgrounddisplay, "left", 20, 0)
			instancia._version:SetTextColor (1, 1, 1)
			instancia._version:SetText ("this is a alpha version of Details\nyou can help us sending bug reports\nuse the blue button.")
			if (not _detalhes.initializing) then
				
			end
			instancia._version:Hide()
			

	--> wallpaper
		baseframe.wallpaper = backgrounddisplay:CreateTexture (nil, "overlay")
		baseframe.wallpaper:Hide()
	
	--> alert frame
		baseframe.alert = CreateAlertFrame (baseframe, instancia)
	
-- resizers & lock button ~lock ------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> right resizer
		baseframe.resize_direita = CreateFrame ("button", "Details_Resize_Direita"..ID, baseframe)
		
		local resize_direita_texture = baseframe.resize_direita:CreateTexture (nil, "overlay")
		resize_direita_texture:SetWidth (16)
		resize_direita_texture:SetHeight (16)
		resize_direita_texture:SetTexture (DEFAULT_SKIN)
		resize_direita_texture:SetTexCoord (unpack (COORDS_RESIZE_RIGHT))
		resize_direita_texture:SetAllPoints (baseframe.resize_direita)
		baseframe.resize_direita.texture = resize_direita_texture

		baseframe.resize_direita:SetWidth (16)
		baseframe.resize_direita:SetHeight (16)
		baseframe.resize_direita:SetPoint ("bottomright", baseframe, "bottomright", 0, 0)
		baseframe.resize_direita:EnableMouse (true)
		baseframe.resize_direita:SetFrameStrata ("HIGH")
		baseframe.resize_direita:SetFrameLevel (baseframe:GetFrameLevel() + 6)
		baseframe.resize_direita.side = 2

	--> lock window button
		baseframe.lock_button = CreateFrame ("button", "Details_Lock_Button"..ID, baseframe)
		baseframe.lock_button:SetPoint ("right", baseframe.resize_direita, "left", -1, 1.5)
		baseframe.lock_button:SetFrameLevel (baseframe:GetFrameLevel() + 6)
		baseframe.lock_button:SetWidth (40)
		baseframe.lock_button:SetHeight (16)
		baseframe.lock_button.label = baseframe.lock_button:CreateFontString (nil, "overlay", "GameFontNormal")
		baseframe.lock_button.label:SetPoint ("right", baseframe.lock_button, "right")
		baseframe.lock_button.label:SetTextColor (.6, .6, .6, .7)
		baseframe.lock_button.label:SetJustifyH ("right")
		baseframe.lock_button.label:SetText (Loc ["STRING_LOCK_WINDOW"])
		baseframe.lock_button:SetWidth (baseframe.lock_button.label:GetStringWidth()+2)
		baseframe.lock_button:SetScript ("OnClick", lockFunctionOnClick)
		baseframe.lock_button:SetScript ("OnEnter", lockFunctionOnEnter)
		baseframe.lock_button:SetScript ("OnLeave", lockFunctionOnLeave)
		baseframe.lock_button:SetScript ("OnHide", lockFunctionOnHide)
		baseframe.lock_button:SetFrameStrata ("HIGH")
		baseframe.lock_button:SetFrameLevel (baseframe:GetFrameLevel() + 6)
		baseframe.lock_button.instancia = instancia
		
	--> left resizer
		baseframe.resize_esquerda = CreateFrame ("button", "Details_Resize_Esquerda"..ID, baseframe)
		
		local resize_esquerda_texture = baseframe.resize_esquerda:CreateTexture (nil, "overlay")
		resize_esquerda_texture:SetWidth (16)
		resize_esquerda_texture:SetHeight (16)
		resize_esquerda_texture:SetTexture (DEFAULT_SKIN)
		resize_esquerda_texture:SetTexCoord (unpack (COORDS_RESIZE_LEFT))
		resize_esquerda_texture:SetAllPoints (baseframe.resize_esquerda)
		baseframe.resize_esquerda.texture = resize_esquerda_texture

		baseframe.resize_esquerda:SetWidth (16)
		baseframe.resize_esquerda:SetHeight (16)
		baseframe.resize_esquerda:SetPoint ("bottomleft", baseframe, "bottomleft", 0, 0)
		baseframe.resize_esquerda:EnableMouse (true)
		baseframe.resize_esquerda:SetFrameStrata ("HIGH")
		baseframe.resize_esquerda:SetFrameLevel (baseframe:GetFrameLevel() + 6)
	
		baseframe.resize_esquerda:SetAlpha (0)
		baseframe.resize_direita:SetAlpha (0)
	
		if (instancia.isLocked) then
			instancia.isLocked = not instancia.isLocked
			lockFunctionOnClick (baseframe.lock_button, nil, nil, true)
		end
	
		gump:Fade (baseframe.lock_button, -1, 3.0)

-- scripts ------------------------------------------------------------------------------------------------------------------------------------------------------------

	BFrame_scripts (baseframe, instancia)

	BGFrame_scripts (switchbutton, baseframe, instancia)
	BGFrame_scripts (backgrounddisplay, baseframe, instancia)
	
	iterate_scroll_scripts (backgrounddisplay, backgroundframe, baseframe, scrollbar, instancia)
	

-- create toolbar ----------------------------------------------------------------------------------------------------------------------------------------------------------

	gump:CriaCabecalho (baseframe, instancia)
	
-- create statusbar ----------------------------------------------------------------------------------------------------------------------------------------------------------		

	gump:CriaRodape (baseframe, instancia)

-- left and right side bars ------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- ~barra ~bordas ~border

	--> left
		baseframe.barra_esquerda = floatingframe:CreateTexture (nil, "artwork")
		baseframe.barra_esquerda:SetTexture (DEFAULT_SKIN)
		baseframe.barra_esquerda:SetTexCoord (unpack (COORDS_LEFT_SIDE_BAR))
		baseframe.barra_esquerda:SetWidth (64)
		baseframe.barra_esquerda:SetHeight	(512)
		baseframe.barra_esquerda:SetPoint ("topleft", baseframe, "topleft", -56, 0)
		baseframe.barra_esquerda:SetPoint ("bottomleft", baseframe, "bottomleft", -56, -14)
	--> right
		baseframe.barra_direita = floatingframe:CreateTexture (nil, "artwork")
		baseframe.barra_direita:SetTexture (DEFAULT_SKIN)
		baseframe.barra_direita:SetTexCoord (unpack (COORDS_RIGHT_SIDE_BAR))
		baseframe.barra_direita:SetWidth (64)
		baseframe.barra_direita:SetHeight (512)
		baseframe.barra_direita:SetPoint ("topright", baseframe, "topright", 56, 0)
		baseframe.barra_direita:SetPoint ("bottomright", baseframe, "bottomright", 56, -14)
	--> bottom
		baseframe.barra_fundo = floatingframe:CreateTexture (nil, "artwork")
		baseframe.barra_fundo:SetTexture (DEFAULT_SKIN)
		baseframe.barra_fundo:SetTexCoord (unpack (COORDS_BOTTOM_SIDE_BAR))
		baseframe.barra_fundo:SetWidth (512)
		baseframe.barra_fundo:SetHeight (64)
		baseframe.barra_fundo:SetPoint ("bottomleft", baseframe, "bottomleft", 0, -56)
		baseframe.barra_fundo:SetPoint ("bottomright", baseframe, "bottomright", 0, -56)

-- break snap button ----------------------------------------------------------------------------------------------------------------------------------------------------------

		instancia.break_snap_button = CreateFrame ("button", "DetailsBreakSnapButton" .. ID, floatingframe)
		instancia.break_snap_button:SetPoint ("bottom", baseframe.resize_direita, "top", -1, 0)
		instancia.break_snap_button:SetFrameLevel (baseframe:GetFrameLevel() + 5)
		instancia.break_snap_button:SetSize (13, 13)
		instancia.break_snap_button:SetAlpha (0)
		
		instancia.break_snap_button.instancia = instancia
		
		instancia.break_snap_button:SetScript ("OnClick", function()
			if (_detalhes.disable_lock_ungroup_buttons) then
				return
			end
			instancia:Desagrupar (-1)
			--> hide tutorial
			if (DetailsWindowGroupPopUp1 and DetailsWindowGroupPopUp1:IsShown()) then
				DetailsWindowGroupPopUp1:Hide()
			end
		end)
		
		instancia.break_snap_button:SetScript ("OnEnter", unSnapButtonOnEnter)
		instancia.break_snap_button:SetScript ("OnLeave", unSnapButtonOnLeave)

		instancia.break_snap_button:SetNormalTexture (DEFAULT_SKIN)
		instancia.break_snap_button:SetDisabledTexture (DEFAULT_SKIN)
		instancia.break_snap_button:SetHighlightTexture (DEFAULT_SKIN, "ADD")
		instancia.break_snap_button:SetPushedTexture (DEFAULT_SKIN)
		
		instancia.break_snap_button:GetNormalTexture():SetTexCoord (unpack (COORDS_UNLOCK_BUTTON))
		instancia.break_snap_button:GetDisabledTexture():SetTexCoord (unpack (COORDS_UNLOCK_BUTTON))
		instancia.break_snap_button:GetHighlightTexture():SetTexCoord (unpack (COORDS_UNLOCK_BUTTON))
		instancia.break_snap_button:GetPushedTexture():SetTexCoord (unpack (COORDS_UNLOCK_BUTTON))
	
-- scripts ------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
		resize_scripts (baseframe.resize_direita, instancia, scrollbar, ">", baseframe)
		resize_scripts (baseframe.resize_esquerda, instancia, scrollbar, "<", baseframe)
	
-- side bars highlights ------------------------------------------------------------------------------------------------------------------------------------------------------------

	--> top
		local fcima = CreateFrame ("frame", "DetailsTopSideBarHighlight" .. instancia.meu_id, floatingframe)
		gump:CreateFlashAnimation (fcima)
		fcima:Hide()
		
		instancia.h_cima = fcima:CreateTexture (nil, "overlay")
		instancia.h_cima:SetTexture ([[Interface\AddOns\Details\images\highlight_updown]])
		instancia.h_cima:SetTexCoord (0, 1, 0.5, 1)
		instancia.h_cima:SetPoint ("topleft", baseframe.cabecalho.top_bg, "bottomleft", -10, 37)
		instancia.h_cima:SetPoint ("topright", baseframe.cabecalho.ball_r, "bottomright", -97, 37)
		instancia.h_cima:SetDesaturated (true)
		fcima.texture = instancia.h_cima
		instancia.h_cima = fcima
		
	--> bottom
		local fbaixo = CreateFrame ("frame", "DetailsBottomSideBarHighlight" .. instancia.meu_id, floatingframe)
		gump:CreateFlashAnimation (fbaixo)
		fbaixo:Hide()
		
		instancia.h_baixo = fbaixo:CreateTexture (nil, "overlay")
		instancia.h_baixo:SetTexture ([[Interface\AddOns\Details\images\highlight_updown]])
		instancia.h_baixo:SetTexCoord (0, 1, 0, 0.5)
		instancia.h_baixo:SetPoint ("topleft", baseframe.rodape.esquerdo, "bottomleft", 16, 17)
		instancia.h_baixo:SetPoint ("topright", baseframe.rodape.direita, "bottomright", -16, 17)
		instancia.h_baixo:SetDesaturated (true)
		fbaixo.texture = instancia.h_baixo
		instancia.h_baixo = fbaixo
		
	--> left
		local fesquerda = CreateFrame ("frame", "DetailsLeftSideBarHighlight" .. instancia.meu_id, floatingframe)
		gump:CreateFlashAnimation (fesquerda)
		fesquerda:Hide()
		
		instancia.h_esquerda = fesquerda:CreateTexture (nil, "overlay")
		instancia.h_esquerda:SetTexture ([[Interface\AddOns\Details\images\highlight_leftright]])
		instancia.h_esquerda:SetTexCoord (0.5, 1, 0, 1)
		instancia.h_esquerda:SetPoint ("topleft", baseframe.barra_esquerda, "topleft", 40, 0)
		instancia.h_esquerda:SetPoint ("bottomleft", baseframe.barra_esquerda, "bottomleft", 40, 0)
		instancia.h_esquerda:SetDesaturated (true)
		fesquerda.texture = instancia.h_esquerda
		instancia.h_esquerda = fesquerda
		
	--> right
		local fdireita = CreateFrame ("frame", "DetailsRightSideBarHighlight" .. instancia.meu_id, floatingframe)
		gump:CreateFlashAnimation (fdireita)	
		fdireita:Hide()
		
		instancia.h_direita = fdireita:CreateTexture (nil, "overlay")
		instancia.h_direita:SetTexture ([[Interface\AddOns\Details\images\highlight_leftright]])
		instancia.h_direita:SetTexCoord (0, 0.5, 1, 0)
		instancia.h_direita:SetPoint ("topleft", baseframe.barra_direita, "topleft", 8, 18)
		instancia.h_direita:SetPoint ("bottomleft", baseframe.barra_direita, "bottomleft", 8, 0)
		instancia.h_direita:SetDesaturated (true)
		fdireita.texture = instancia.h_direita
		instancia.h_direita = fdireita

--> done

	if (criando) then
		local CProps = {
			["altura"] = 100,
			["largura"] = 200,
			["barras"] = 50,
			["barrasvisiveis"] = 0,
			["x"] = 0,
			["y"] = 0,
			["w"] = 0,
			["h"] = 0
		}
		instancia.locs = CProps
	end

	return baseframe, backgroundframe, backgrounddisplay, scrollbar
	
end

function _detalhes:IsShowingOverallDataWarning()
	return self.overall_data_warning:IsShown()
end

function _detalhes:ShowOverallDataWarning (state)
	if (state) then
		self.overall_data_warning:Show()
		self.overall_data_warning:SetWidth (self:GetSize() - 20)
	else
		self.overall_data_warning:Hide()
	end
end


function _detalhes:SetBarFollowPlayer (follow)
	
	if (follow == nil) then
		follow = self.following.enabled
	end
	
	self.following.enabled = follow
	
	self:RefreshBars()
	self:InstanceReset()
	self:ReajustaGump()
end

function _detalhes:SetBarOrientationDirection (orientation)
	if (orientation == nil) then
		orientation = self.bars_inverted
	end

	self.bars_inverted = orientation
	
	self:InstanceRefreshRows()
	self:RefreshBars()
	self:InstanceReset()
	self:ReajustaGump()
end

function _detalhes:SetBarGrowDirection (direction)
	if (not direction) then
		direction = self.bars_grow_direction
	end
	
	self.bars_grow_direction = direction
	local x = self.row_info.space.left
	
	local bars = self.barras or self.Bars --> .Bars for third-party plugins
	local baseframe = self.baseframe or self.Frame --> .Frame for plugins
	local height = self.row_height
	
	if (direction == 1) then --> top to bottom
		for index, row in _ipairs (bars) do
			local y = height * (index - 1)
			y = y * -1
			row:ClearAllPoints()
			
			if (self.toolbar_side == 1) then 
				--> if titlebar is attached to the top side, don't add any midifiers
				row:SetPoint ("topleft", baseframe, "topleft", x, y)
			else
				--> if the titlebar is on the bottom side, remove the gap between the baseframe and the titlebar
				row:SetPoint ("topleft", baseframe, "topleft", x, y - 1)
			end
		end
		
	elseif (direction == 2) then --> bottom to top
		for index, row in _ipairs (bars) do
			local y = height * (index - 1)
			row:ClearAllPoints()
			if (self.toolbar_side == 1) then 
				--> if the titlebar is attached to the top side, we want to align bars a little above
				row:SetPoint ("bottomleft", baseframe, "bottomleft", x, y + 2)
			else
				--> the titlebar is on the bottom side, align bars on the bottom
				row:SetPoint ("bottomleft", baseframe, "bottomleft", x, y + 0)
			end
		end
	end
	
	--> update all row width
	if (self.bar_mod and self.bar_mod ~= 0) then
		for index = 1, #bars do
			bars [index]:SetWidth (baseframe:GetWidth() + self.bar_mod)
		end
	else
		for index = 1, #bars do
			bars [index]:SetWidth (baseframe:GetWidth() + self.row_info.space.right)
			--print (bars [index]:GetWidth(), baseframe:GetWidth())
		end
	end
end

--> Alias
function gump:NewRow (instancia, index)
	return gump:CriaNovaBarra (instancia, index)
end

_detalhes.barras_criadas = 0

--> search key: ~row ~barra
function gump:CriaNovaBarra (instancia, index)

	--> instancia = window object, index = row number
	local baseframe = instancia.baseframe
	local rowframe = instancia.rowframe
	
	--> create the bar with rowframe as parent
	local new_row = CreateFrame ("button", "DetailsBarra_"..instancia.meu_id.."_"..index, rowframe)
	
	new_row.row_id = index
	new_row.instance_id = instancia.meu_id
	new_row.animacao_fim = 0
	new_row.animacao_fim2 = 0
	
	--> set point, almost irrelevant here, it recalc this on SetBarGrowDirection()
	local y = instancia.row_height * (index-1)
	if (instancia.bars_grow_direction == 1) then
		y = y*-1
		new_row:SetPoint ("topleft", baseframe, "topleft", instancia.row_info.space.left, y)
		
	elseif (instancia.bars_grow_direction == 2) then
		new_row:SetPoint ("bottomleft", baseframe, "bottomleft", instancia.row_info.space.left, y + 2)
	end
	
	--> row height
	new_row:SetHeight (instancia.row_info.height)
	new_row:SetWidth (baseframe:GetWidth()+instancia.row_info.space.right)
	new_row:SetFrameLevel (baseframe:GetFrameLevel() + 4)
	new_row.last_value = 0
	new_row.w_mod = 0
	new_row:EnableMouse (true)
	new_row:RegisterForClicks ("LeftButtonDown", "RightButtonDown")
	
	--> statusbar
	new_row.statusbar = CreateFrame ("StatusBar", "DetailsBarra_Statusbar_"..instancia.meu_id.."_"..index, new_row)
	new_row.statusbar.value = 0
	--> right to left texture
	new_row.statusbar.right_to_left_texture = new_row.statusbar:CreateTexture (nil, "overlay")
	new_row.statusbar.right_to_left_texture:SetPoint ("topright", new_row.statusbar, "topright")
	new_row.statusbar.right_to_left_texture:SetPoint ("bottomright", new_row.statusbar, "bottomright")
	new_row.statusbar.right_to_left_texture:SetWidth (0.000000001)
	new_row.statusbar.right_to_left_texture:Hide()
	new_row.right_to_left_texture = new_row.statusbar.right_to_left_texture
	
	--> frame for hold the backdrop border
	new_row.border = CreateFrame ("Frame", "DetailsBarra_Border_" .. instancia.meu_id .. "_" .. index, new_row.statusbar)
	new_row.border:SetFrameLevel (new_row.statusbar:GetFrameLevel()+2)
	new_row.border:SetAllPoints (new_row)
	
	-- search key: ~model
	
	--low 3d bar
	new_row.modelbox_low = CreateFrame ("playermodel", "DetailsBarra_ModelBarLow_" .. instancia.meu_id .. "_" .. index, new_row) --rowframe
	new_row.modelbox_low:SetFrameLevel (new_row.statusbar:GetFrameLevel()-1)
	new_row.modelbox_low:SetPoint ("topleft", new_row, "topleft")
	new_row.modelbox_low:SetPoint ("bottomright", new_row, "bottomright")
	--high 3d bar
	new_row.modelbox_high = CreateFrame ("playermodel", "DetailsBarra_ModelBarHigh_" .. instancia.meu_id .. "_" .. index, new_row) --rowframe
	new_row.modelbox_high:SetFrameLevel (new_row.statusbar:GetFrameLevel()+1)
	new_row.modelbox_high:SetPoint ("topleft", new_row, "topleft")
	new_row.modelbox_high:SetPoint ("bottomright", new_row, "bottomright")
	
	--> create textures and icons
	new_row.textura = new_row.statusbar:CreateTexture (nil, "artwork")
	new_row.textura:SetHorizTile (false)
	new_row.textura:SetVertTile (false)
	
	--> row background texture
	new_row.background = new_row:CreateTexture (nil, "background")
	new_row.background:SetTexture()
	new_row.background:SetAllPoints (new_row)

	new_row.statusbar:SetStatusBarColor (0, 0, 0, 0)
	new_row.statusbar:SetStatusBarTexture (new_row.textura)
	new_row.statusbar:SetMinMaxValues (0, 100)
	new_row.statusbar:SetValue (0)

	--> class icon
	local icone_classe = new_row.border:CreateTexture (nil, "overlay")
	icone_classe:SetHeight (instancia.row_info.height)
	icone_classe:SetWidth (instancia.row_info.height)
	icone_classe:SetTexture (instancia.row_info.icon_file)
	icone_classe:SetTexCoord (.75, 1, .75, 1)
	new_row.icone_classe = icone_classe
	
	local icon_frame = CreateFrame ("frame", "DetailsBarra_IconFrame_" .. instancia.meu_id .. "_" .. index, new_row.statusbar)
	icon_frame:SetPoint ("topleft", icone_classe, "topleft")
	icon_frame:SetPoint ("bottomright", icone_classe, "bottomright")
	icon_frame:SetFrameLevel (new_row.statusbar:GetFrameLevel()+1)
	icon_frame.instance_id = instancia.meu_id
	icon_frame.row = new_row
	new_row.icon_frame = icon_frame
	
	icone_classe:SetPoint ("left", new_row, "left")
	new_row.statusbar:SetPoint ("topleft", icone_classe, "topright")
	new_row.statusbar:SetPoint ("bottomright", new_row, "bottomright")
	
	--> left text
	new_row.texto_esquerdo = new_row.border:CreateFontString (nil, "overlay", "GameFontHighlight")
	new_row.texto_esquerdo:SetPoint ("left", new_row.icone_classe, "right", 3, 0)
	new_row.texto_esquerdo:SetJustifyH ("left")
	new_row.texto_esquerdo:SetNonSpaceWrap (true)

	--> right text
	new_row.texto_direita = new_row.border:CreateFontString (nil, "overlay", "GameFontHighlight")
	new_row.texto_direita:SetPoint ("right", new_row.statusbar, "right")
	new_row.texto_direita:SetJustifyH ("right")

	--> set the onclick, on enter scripts
	barra_scripts (new_row, instancia, index)

	--> hide
	gump:Fade (new_row, 1) 

	--> adds the window container
	instancia.barras [index] = new_row
	
	--> set the left text
	new_row.texto_esquerdo:SetText (Loc ["STRING_NEWROW"])
	
	--> refresh rows
	instancia:InstanceRefreshRows()
	
	_detalhes:SendEvent ("DETAILS_INSTANCE_NEWROW", nil, instancia, new_row)
	
	return new_row
end

function _detalhes:SetBarTextSettings (size, font, fixedcolor, leftcolorbyclass, rightcolorbyclass, leftoutline, rightoutline, customrighttextenabled, customrighttext, percentage_type, showposition, customlefttextenabled, customlefttext, smalloutline_left, smalloutlinecolor_left, smalloutline_right, smalloutlinecolor_right, translittext)
	
	--> size
	if (size) then
		self.row_info.font_size = size
	end

	--> font
	if (font) then
		self.row_info.font_face = font
		self.row_info.font_face_file = SharedMedia:Fetch ("font", font)
	end

	--> fixed color
	if (fixedcolor) then
		local red, green, blue, alpha = gump:ParseColors (fixedcolor)
		local c = self.row_info.fixed_text_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end
	
	--> left color by class
	if (type (leftcolorbyclass) == "boolean") then
		self.row_info.textL_class_colors = leftcolorbyclass
	end
	
	--> right color by class
	if (type (rightcolorbyclass) == "boolean") then
		self.row_info.textR_class_colors = rightcolorbyclass
	end
	
	--> left text outline
	if (type (leftoutline) == "boolean") then
		self.row_info.textL_outline = leftoutline
	end
	
	--> right text outline
	if (type (rightoutline) == "boolean") then
		self.row_info.textR_outline = rightoutline
	end
	
	-- left text small outline and small outline color
	if (type (smalloutline_left) == "boolean") then
		self.row_info.textL_outline_small = smalloutline_left
	end
	if (smalloutlinecolor_left) then
		local red, green, blue, alpha = gump:ParseColors (smalloutlinecolor_left)
		local c = self.row_info.textL_outline_small_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end
	-- right text small outline and small outline color
	if (type (smalloutline_right) == "boolean") then
		self.row_info.textR_outline_small = smalloutline_right
	end
	if (smalloutlinecolor_right) then
		local red, green, blue, alpha = gump:ParseColors (smalloutlinecolor_right)
		local c = self.row_info.textR_outline_small_color
		c[1], c[2], c[3], c[4] = red, green, blue, alpha
	end
	
	--> custom left text
	if (type (customlefttextenabled) == "boolean") then
		self.row_info.textL_enable_custom_text = customlefttextenabled
	end
	if (customlefttext) then
		self.row_info.textL_custom_text = customlefttext
	end

	--> custom right text
	if (type (customrighttextenabled) == "boolean") then
		self.row_info.textR_enable_custom_text = customrighttextenabled
	end
	if (customrighttext) then
		self.row_info.textR_custom_text = customrighttext
	end
	
	--> percent type
	if (percentage_type) then
		self.row_info.percent_type = percentage_type
	end
	
	--> show position number
	if (type (showposition) == "boolean") then
		self.row_info.textL_show_number = showposition
	end

	--> translit text by Vardex (https://github.com/Vardex May 22, 2019)
	if (type (translittext) == "boolean") then
		self.row_info.textL_translit_text = translittext
	end
	
	self:InstanceReset()
	self:InstanceRefreshRows()
end

function _detalhes:SetBarBackdropSettings (enabled, size, color, texture)

	if (type (enabled) ~= "boolean") then
		enabled = self.row_info.backdrop.enabled
	end
	if (not size) then
		size = self.row_info.backdrop.size
	end
	if (not color) then
		color = self.row_info.backdrop.color
	end
	if (not texture) then
		texture = self.row_info.backdrop.texture
	end
	
	self.row_info.backdrop.enabled = enabled
	self.row_info.backdrop.size = size
	self.row_info.backdrop.color = color
	self.row_info.backdrop.texture = texture
	
	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReajustaGump()
end

function _detalhes:SetBarModel (upper_enabled, upper_model, upper_alpha, lower_enabled, lower_model, lower_alpha)
	
	--> is enabled
	if (type (upper_enabled) == "boolean") then
		self.row_info.models.upper_enabled = upper_enabled
	end
	if (type (lower_enabled) == "boolean") then
		self.row_info.models.lower_enabled = lower_enabled
	end
	
	--> models:
	if (upper_model) then
		self.row_info.models.upper_model = upper_model
	end
	if (lower_model) then
		self.row_info.models.lower_model = lower_model
	end
	
	--> alpha values:
	if (upper_alpha) then
		self.row_info.models.upper_alpha = upper_alpha
	end	
	if (lower_alpha) then
		self.row_info.models.lower_alpha = lower_alpha
	end
	
	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReajustaGump()
	_detalhes:AtualizaGumpPrincipal (-1, true)
end

-- ~spec ~icons
function _detalhes:SetBarSpecIconSettings (enabled, iconfile, fulltrack)
	
	if (type (enabled) ~= "boolean") then
		enabled = self.row_info.use_spec_icons
	end
	if (not iconfile) then
		iconfile = self.row_info.spec_file
	end
	
	self.row_info.use_spec_icons = enabled
	self.row_info.spec_file = iconfile
	
	if (enabled) then
		if (not _detalhes.track_specs) then
			_detalhes.track_specs = true
			_detalhes:TrackSpecsNow (fulltrack)
		end
	else
		local have_enabled
		for _, instance in _ipairs (_detalhes.tabela_instancias) do
			if (instance:IsEnabled() and instance.row_info.use_spec_icons) then
				have_enabled = true
				break
			end
		end
		if (not have_enabled) then
			_detalhes.track_specs = false
			_detalhes:ResetSpecCache (true) --> for�ar
		end
	end
	
	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReajustaGump()
	
end

function _detalhes:SetBarSettings (height, texture, colorclass, fixedcolor, backgroundtexture, backgroundcolorclass, backgroundfixedcolor, alpha, iconfile, barstart, spacement, texture_custom)
	
	--> bar start
	if (type (barstart) == "boolean") then
		self.row_info.start_after_icon = barstart
	end
	
	--> icon file
	if (iconfile) then
		self.row_info.icon_file = iconfile
		if (iconfile == "") then
			self.row_info.no_icon = true
		else
			self.row_info.no_icon = false
		end
	end
	
	--> alpha
	if (alpha) then
		self.row_info.alpha = alpha
	end
	
	--> height
	if (height) then
		self.row_info.height = height
		self.row_height = height + self.row_info.space.between
	end
	
	--> spacement
	if (spacement) then
		self.row_info.space.between = spacement
		self.row_height = self.row_info.height + spacement
	end
	
	--> texture
	if (texture) then
		self.row_info.texture = texture
		self.row_info.texture_file = SharedMedia:Fetch ("statusbar", texture)
	end
	
	if (texture_custom) then
		self.row_info.texture_custom = texture_custom
		self.row_info.texture_custom_file = "Interface\\" .. self.row_info.texture_custom
	end
	
	--> color by class
	if (type (colorclass) == "boolean") then
		self.row_info.texture_class_colors = colorclass
	end
	
	--> fixed color
	if (fixedcolor) then
		local red, green, blue = gump:ParseColors (fixedcolor)
		local c = self.row_info.fixed_texture_color
		c[1], c[2], c[3], c[4] = red, green, blue, self.row_info.alpha
	end
	
	--> background texture
	if (backgroundtexture) then
		self.row_info.texture_background = backgroundtexture
		self.row_info.texture_background_file = SharedMedia:Fetch ("statusbar", backgroundtexture)
	end
	
	--> background color by class
	if (type (backgroundcolorclass) == "boolean") then
		self.row_info.texture_background_class_color = backgroundcolorclass
	end
	
	--> background fixed color
	if (backgroundfixedcolor) then
		local red, green, blue, alpha = gump:ParseColors (backgroundfixedcolor)
		local c =  self.row_info.fixed_texture_background_color
		c [1], c [2], c [3], c [4] = red, green, blue, alpha
	end

	self:InstanceReset()
	self:InstanceRefreshRows()
	self:ReajustaGump()

end

local brackets = {
	["("] = {" (", ")"},
	["{"] = {" {", "}"},
	["["] = {" [", "]"},
	["<"] = {" <", ">"},
	["NONE"] = {" ", ""},
}

local separators = {
	[","] = ", ",
	["."] = ". ",
	[";"] = "; ",
	["-"] = " - ",
	["|"] = " | ",
	["/"] = " / ",
	["\\"] = " \\ ",
	["~"] = " ~ ",
	["NONE"] = "",
}

function _detalhes:GetBarBracket()
	return brackets [self.row_info.textR_bracket]
end

function _detalhes:GetBarSeparator()
	return separators [self.row_info.textR_separator]
end

function _detalhes:SetBarRightTextSettings (total, persecond, percent, bracket, separator)

	if (type (total) == "boolean") then
		self.row_info.textR_show_data [1] = total
	end
	if (type (persecond) == "boolean") then
		self.row_info.textR_show_data [2] = persecond
	end
	if (type (percent) == "boolean") then
		self.row_info.textR_show_data [3] = percent
	end
	
	if (bracket) then
		self.row_info.textR_bracket = bracket
	end
	if (separator) then
		self.row_info.textR_separator = separator
	end

	self:InstanceReset()
	
end

--/script _detalhes:InstanceRefreshRows (_detalhes.tabela_instancias[1])

--> on update function
local fast_ps_func = function (self)
	local instance = self.instance
	
	if (not instance.showing) then
		return
	end
	
	local combat_time = instance.showing:GetCombatTime()
	local ps_type = _detalhes.ps_abbreviation

	if (instance.rows_fit_in_window) then
		for i = 1, instance.rows_fit_in_window do --instance:GetNumRows()
			local row = instance.barras [i] --instance:GetRow (i)
			if (row and row:IsShown()) then
				local actor = row.minha_tabela
				if (actor) then
					local dps_text = row.ps_text
					if (dps_text) then
						local new_dps = _math_floor (actor.total / combat_time)
						local formated_dps = tok_functions [ps_type] (_, new_dps)

						--row.texto_direita:SetText (row.texto_direita:GetText():gsub (dps_text, formated_dps))
						row.texto_direita:SetText (( row.texto_direita:GetText() or "" ):gsub (dps_text, formated_dps))
						row.ps_text = formated_dps
					end
				end
			end
		end
	end
end

-- ~dps ~hps
--> check if can start or need to stop
function _detalhes:CheckPsUpdate()

	local is_enabled = self.row_info.fast_ps_update
	
	if (is_enabled) then
		--> check if the frame is created
		if (not self.ps_update_frame) then
			self.ps_update_frame = CreateFrame ("frame", "DetailsInstance" .. self.meu_id .. "PsUpdate", self.baseframe)
			self.ps_update_frame.instance = self
		end
		
		--> if isn't in combat, just stop
		if (not _detalhes.in_combat) then
			if (self.ps_update_frame.is_running) then
				self.ps_update_frame.is_running = nil
				self.ps_update_frame:Hide()
				self.ps_update_frame:SetScript ("OnUpdate", nil)
			end
			return
		end
		
		--> check if needs to start
		local attribute, sub_attribute = self:GetDisplay()
		
		--> check if the instance is showing damage done/dps or healing done/hps
		if ( (attribute == 1 and (sub_attribute == 1 or sub_attribute == 2)) or (attribute == 2 and (sub_attribute == 1 or sub_attribute == 2))) then
			if (not self.ps_update_frame.is_running) then
				self.ps_update_frame.is_running = true
				self.ps_update_frame:Show()
				self.ps_update_frame:SetScript ("OnUpdate", fast_ps_func)
			end
		else
			--> check if needs to stop
			if (self.ps_update_frame.is_running) then
				self.ps_update_frame.is_running = nil
				self.ps_update_frame:Hide()
				self.ps_update_frame:SetScript ("OnUpdate", nil)
			end
		end
		
	else
		if (self.ps_update_frame and self.ps_update_frame.is_running) then
			self.ps_update_frame.is_running = nil
			self.ps_update_frame:Hide()
			self.ps_update_frame:SetScript ("OnUpdate", nil)
		end
	end
end

--	/run _detalhes:GetInstance(1):FastPSUpdate (true)
--	/dump (_detalhes:GetInstance(1).fast_ps_update)

function _detalhes:FastPSUpdate (enabled)
	if (type (enabled) ~= "boolean") then
		enabled = self.row_info.fast_ps_update
	end
	
	self.row_info.fast_ps_update = enabled
	
	self:CheckPsUpdate()
end


-- search key: ~row ~bar ~updatebar
function _detalhes:InstanceRefreshRows (instancia)
	
	if (instancia) then
		self = instancia
	end
	
	if (not self.barras or not self.barras[1]) then
		return
	end
	
	--> mirror
		local is_mirror = self.bars_inverted
	
	--> texture
		local texture_file = SharedMedia:Fetch ("statusbar", self.row_info.texture)
		local texture_file2 = SharedMedia:Fetch ("statusbar", self.row_info.texture_background)
			--> update texture files
			self.row_info.texture_file = texture_file
			self.row_info.texture_background_file = texture_file2
		
		if (type (self.row_info.texture_custom) == "string" and self.row_info.texture_custom ~= "") then
			texture_file = "Interface\\" .. self.row_info.texture_custom
				--> update texture file
				self.row_info.texture_custom_file = texture_file
		end
		
	--> outline values
		local left_text_outline = self.row_info.textL_outline
		local right_text_outline = self.row_info.textR_outline
		local textL_outline_small = self.row_info.textL_outline_small
		local textL_outline_small_color = self.row_info.textL_outline_small_color
		local textR_outline_small = self.row_info.textR_outline_small
		local textR_outline_small_color = self.row_info.textR_outline_small_color
	
	--> texture color values
		local texture_class_color = self.row_info.texture_class_colors
		local texture_r, texture_g, texture_b
		if (not texture_class_color) then
			texture_r, texture_g, texture_b = _unpack (self.row_info.fixed_texture_color)
		end
	
	--text color
		local left_text_class_color = self.row_info.textL_class_colors
		local right_text_class_color = self.row_info.textR_class_colors
		local text_r, text_g, text_b
		if (not left_text_class_color or not right_text_class_color) then
			text_r, text_g, text_b = _unpack (self.row_info.fixed_text_color)
		end
		
		local height = self.row_info.height
	
	--alpha
		local alpha = self.row_info.alpha
	
	--icons
		local no_icon = self.row_info.no_icon
		local icon_texture = self.row_info.icon_file
		local start_after_icon = self.row_info.start_after_icon
	
		if (self.row_info.use_spec_icons) then
			icon_texture = self.row_info.spec_file
		end
		
		local icon_force_grayscale = self.row_info.icon_grayscale
		
		local icon_offset_x, icon_offset_y = unpack (self.row_info.icon_offset)
	
	--custom right text
		local custom_right_text_enabled = self.row_info.textR_enable_custom_text
		local custom_right_text = self.row_info.textR_custom_text

	--backdrop
		local backdrop = self.row_info.backdrop.enabled
		local backdrop_color
		if (backdrop) then
			backdrop = {edgeFile = SharedMedia:Fetch ("border", self.row_info.backdrop.texture), edgeSize = self.row_info.backdrop.size}
			backdrop_color = self.row_info.backdrop.color
		end
		
	--font face
		self.row_info.font_face_file = SharedMedia:Fetch ("font", self.row_info.font_face)
	
	--models
		local upper_model_enabled = self.row_info.models.upper_enabled
		local lower_model_enabled = self.row_info.models.lower_enabled
		
		local upper_model = self.row_info.models.upper_model
		local lower_model = self.row_info.models.lower_model
		
		local upper_model_alpha = self.row_info.models.upper_alpha
		local lower_model_alpha = self.row_info.models.lower_alpha
	
--using_upper_3dmodels using_lower_3dmodels	
	
	-- do it

	for _, row in _ipairs (self.barras) do 

		--> positioning and size
		row:SetHeight (height)
		row.icone_classe:SetHeight (height)
		row.icone_classe:SetWidth (height)
		
		if (icon_force_grayscale) then
			row.icone_classe:SetDesaturated (true)
		else
			row.icone_classe:SetDesaturated (false)
		end
		
		--> icon and texture anchors
		if (not is_mirror) then

			row.texto_esquerdo:ClearAllPoints()
			row.texto_direita:ClearAllPoints()
			row.texto_direita:SetJustifyH ("right")
			row.texto_esquerdo:SetJustifyH ("left")
			
			row.texto_direita:SetPoint ("right", row.statusbar, "right")

			if (no_icon) then
				row.statusbar:SetPoint ("topleft", row, "topleft")
				row.statusbar:SetPoint ("bottomright", row, "bottomright")
				row.texto_esquerdo:SetPoint ("left", row.statusbar, "left", 2, 0)
				row.icone_classe:Hide()
			else
				row.icone_classe:ClearAllPoints()
				row.icone_classe:SetPoint ("left", row, "left", icon_offset_x, icon_offset_y)
				row.icone_classe:Show()
				
				if (start_after_icon) then
					row.statusbar:SetPoint ("topleft", row.icone_classe, "topright")
				else
					row.statusbar:SetPoint ("topleft", row, "topleft")
				end
				
				row.statusbar:SetPoint ("bottomright", row, "bottomright")
				row.texto_esquerdo:SetPoint ("left", row.icone_classe, "right", 3, 0)
			end
		else
		
			row.texto_esquerdo:ClearAllPoints()
			row.texto_direita:ClearAllPoints()
			row.texto_direita:SetJustifyH ("left")
			row.texto_esquerdo:SetJustifyH ("right")
			
			row.texto_direita:SetPoint ("left", row.statusbar, "left", 1, 0)
		
			if (no_icon) then
				row.statusbar:SetPoint ("topleft", row, "topleft")
				row.statusbar:SetPoint ("bottomright", row, "bottomright")
				row.texto_esquerdo:SetPoint ("right", row.statusbar, "right", -2, 0)
				row.icone_classe:Hide()
				
				row.right_to_left_texture:SetPoint ("topright", row.statusbar, "topright")
				row.right_to_left_texture:SetPoint ("bottomright", row.statusbar, "bottomright")
			else
			
				row.icone_classe:ClearAllPoints()
				row.icone_classe:SetPoint ("right", row, "right", icon_offset_x, icon_offset_y)
				row.icone_classe:Show()
				
				if (start_after_icon) then
					row.statusbar:SetPoint ("bottomright", row.icone_classe, "bottomleft")
				else
					row.statusbar:SetPoint ("bottomright", row, "bottomright")
				end
				
				row.statusbar:SetPoint ("topleft", row, "topleft")

				row.texto_esquerdo:SetPoint ("right", row.icone_classe, "left", -2, 0)
			end
		end
	
		if (not self.row_info.texture_background_class_color) then
			local c = self.row_info.fixed_texture_background_color
			row.background:SetVertexColor (c[1], c[2], c[3], c[4])
		else
			local c = self.row_info.fixed_texture_background_color
			local r, g, b = row.background:GetVertexColor()
			row.background:SetVertexColor (r, g, b, c[4])
		end
	
		--> outline
		if (left_text_outline) then
			_detalhes:SetFontOutline (row.texto_esquerdo, left_text_outline)
		else
			_detalhes:SetFontOutline (row.texto_esquerdo, nil)
		end
		
		if (right_text_outline) then
			self:SetFontOutline (row.texto_direita, right_text_outline)
		else
			self:SetFontOutline (row.texto_direita, nil)
		end
		
		--> small outline
		if (textL_outline_small) then
			local c = textL_outline_small_color
			row.texto_esquerdo:SetShadowColor (c[1], c[2], c[3], c[4])
			--row.texto_esquerdo:SetShadowOffset (3, -2)
		else
			row.texto_esquerdo:SetShadowColor (0, 0, 0, 0)
		end
		if (textR_outline_small) then
			local c = textR_outline_small_color
			row.texto_direita:SetShadowColor (c[1], c[2], c[3], c[4])
		else
			row.texto_direita:SetShadowColor (0, 0, 0, 0)
		end
		
		--> texture:
		row.textura:SetTexture (texture_file)
		row.right_to_left_texture:SetTexture (texture_file)
		row.background:SetTexture (texture_file2)
		
		if (is_mirror) then
			row.right_to_left_texture:Show()
			else
			row.right_to_left_texture:Hide()
		end
		
		--> texture class color: if true color changes on the fly through class refresh
		if (not texture_class_color) then
			row.textura:SetVertexColor (texture_r, texture_g, texture_b, alpha)
			row.right_to_left_texture:SetVertexColor (texture_r, texture_g, texture_b, alpha)
		else
			--automatically color the bar by the actor class
			--forcing alpha 1 instead of use the alpha from the fixed color
			local r, g, b = row.textura:GetVertexColor()
			row.textura:SetVertexColor (r, g, b, 1) --alpha
		end
		
		--> text class color: if true color changes on the fly through class refresh
		if (not left_text_class_color) then
			row.texto_esquerdo:SetTextColor (text_r, text_g, text_b)
		end
		if (not right_text_class_color) then
			row.texto_direita:SetTextColor (text_r, text_g, text_b)
		end
		
		--> text size
		_detalhes:SetFontSize (row.texto_esquerdo, self.row_info.font_size or height * 0.75)
		_detalhes:SetFontSize (row.texto_direita, self.row_info.font_size or height * 0.75)
		
		--> text font
		_detalhes:SetFontFace (row.texto_esquerdo, self.row_info.font_face_file or "GameFontHighlight")
		_detalhes:SetFontFace (row.texto_direita, self.row_info.font_face_file or "GameFontHighlight")

		--backdrop
		if (backdrop) then
			row.border:SetBackdrop (backdrop)
			row.border:SetBackdropBorderColor (_unpack (backdrop_color))
		else
			row.border:SetBackdrop (nil)
		end
		
		--> models
		if (upper_model_enabled) then
			row.using_upper_3dmodels = true
			row.modelbox_high:Show()
			row.modelbox_high:SetModel (upper_model)
			row.modelbox_high:SetAlpha (upper_model_alpha)
		else
			row.using_upper_3dmodels = false
			row.modelbox_high:Hide()
		end
		
		if (lower_model_enabled) then
			row.using_lower_3dmodels = true
			row.modelbox_low:Show()
			row.modelbox_low:SetModel (lower_model)
			row.modelbox_low:SetAlpha (lower_model_alpha)
		else
			row.using_lower_3dmodels = false
			row.modelbox_low:Hide()
		end

	end
	
	self:SetBarGrowDirection()
	
	self:UpdateClickThrough()
	

end

-- search key: ~wallpaper
function _detalhes:InstanceWallpaper (texture, anchor, alpha, texcoord, width, height, overlay)

	local wallpaper = self.wallpaper
	
	if (type (texture) == "boolean" and texture) then
		texture, anchor, alpha, texcoord, width, height, overlay = wallpaper.texture, wallpaper.anchor, wallpaper.alpha, wallpaper.texcoord, wallpaper.width, wallpaper.height, wallpaper.overlay
		
	elseif (type (texture) == "boolean" and not texture) then
		self.wallpaper.enabled = false
		return gump:Fade (self.baseframe.wallpaper, "in")
		
	elseif (type (texture) == "table") then
		anchor = texture.anchor or wallpaper.anchor
		alpha = texture.alpha or wallpaper.alpha
		if (texture.texcoord) then
			texcoord = {unpack (texture.texcoord)}
		else
			texcoord = wallpaper.texcoord
		end
		width = texture.width or wallpaper.width
		height = texture.height or wallpaper.height
		if (texture.overlay) then
			overlay = {unpack (texture.overlay)}
		else
			overlay = wallpaper.overlay
		end
		
		if (type (texture.enabled) == "boolean") then
			if (not texture.enabled) then
				wallpaper.enabled = false
				wallpaper.texture = texture.texture or wallpaper.texture
				wallpaper.anchor = anchor
				wallpaper.alpha = alpha
				wallpaper.texcoord = texcoord
				wallpaper.width = width
				wallpaper.height = height
				wallpaper.overlay = overlay
				return self:InstanceWallpaper (false)
			end
		end
		
		texture = texture.texture or wallpaper.texture

	else
		texture = texture or wallpaper.texture
		anchor = anchor or wallpaper.anchor
		alpha = alpha or wallpaper.alpha
		texcoord = texcoord or wallpaper.texcoord
		width = width or wallpaper.width
		height = height or wallpaper.height
		overlay = overlay or wallpaper.overlay
	end
	
	if (not wallpaper.texture and not texture) then
		texture = "Interface\\AddOns\\Details\\images\\background"
		
		texcoord = {0, 1, 0, 0.7}
		alpha = 0.5
		width, height = self:GetSize()
		anchor = "all"
	end
	
	local t = self.baseframe.wallpaper

	t:ClearAllPoints()
	
	if (anchor == "all") then
		t:SetPoint ("topleft", self.baseframe, "topleft")
		t:SetPoint ("bottomright", self.baseframe, "bottomright")
	elseif (anchor == "center") then
		t:SetPoint ("center", self.baseframe, "center", 0, 4)
	elseif (anchor == "stretchLR") then
		t:SetPoint ("center", self.baseframe, "center")
		t:SetPoint ("left", self.baseframe, "left")
		t:SetPoint ("right", self.baseframe, "right")
	elseif (anchor == "stretchTB") then
		t:SetPoint ("center", self.baseframe, "center")
		t:SetPoint ("top", self.baseframe, "top")
		t:SetPoint ("bottom", self.baseframe, "bottom")
	else
		t:SetPoint (anchor, self.baseframe, anchor)
	end
	
	t:SetTexture (texture)
	t:SetTexCoord (unpack (texcoord))
	t:SetWidth (width)
	t:SetHeight (height)
	t:SetVertexColor (unpack (overlay))
	
	wallpaper.enabled = true
	wallpaper.texture = texture
	wallpaper.anchor = anchor
	wallpaper.alpha = alpha
	wallpaper.texcoord = texcoord
	wallpaper.width = width
	wallpaper.height = height
	wallpaper.overlay = overlay

	t:Show()
	--t:SetAlpha (alpha)
	gump:Fade (t, "ALPHAANIM", alpha)

end

function _detalhes:GetTextures()
	local t = {}
	t [1] = self.baseframe.rodape.esquerdo
	t [2] = self.baseframe.rodape.direita
	t [3] = self.baseframe.rodape.top_bg
	
	t [4] = self.baseframe.cabecalho.ball_r
	t [5] = self.baseframe.cabecalho.ball
	t [6] = self.baseframe.cabecalho.emenda
	t [7] = self.baseframe.cabecalho.top_bg
	
	t [8] = self.baseframe.barra_esquerda
	t [9] = self.baseframe.barra_direita
	t [10] = self.baseframe.UPFrame
	return t
	--atributo_icon � uma exce��o
end

function _detalhes:SetWindowAlphaForInteract (alpha)
	
	local ignorebars = self.menu_alpha.ignorebars
	
	if (self.is_interacting) then
		--> entrou
		self.baseframe:SetAlpha (alpha)
		self:InstanceAlpha (alpha)
		self:SetIconAlpha (alpha, nil, true)
		
		if (ignorebars) then
			self.rowframe:SetAlpha (1)
		else
			self.rowframe:SetAlpha (alpha)
		end
	else
		--> saiu
		if (self.combat_changes_alpha) then --> combat alpha
			self:InstanceAlpha (self.combat_changes_alpha)
			self:SetIconAlpha (self.combat_changes_alpha, nil, true)
			self.rowframe:SetAlpha (self.combat_changes_alpha) --alpha do combate � absoluta
			self.baseframe:SetAlpha (self.combat_changes_alpha) --alpha do combate � absoluta
		else
			self:InstanceAlpha (alpha)
			self:SetIconAlpha (alpha, nil, true)
			
			if (ignorebars) then
				self.rowframe:SetAlpha (1)
			else
				self.rowframe:SetAlpha (alpha)
			end
			
			self.baseframe:SetAlpha (alpha)
		end
	end
	
	if (_detalhes.debug) then
		_detalhes:Msg ("(debug) setting window alpha for SetWindowAlphaForInteract() -> ", alpha)
	end	
	
end

-- ~autohide �utohide
function _detalhes:SetWindowAlphaForCombat (entering_in_combat, true_hide)

	local amount, rowsamount, menuamount

	--get the values
	if (entering_in_combat) then
		amount = self.hide_in_combat_alpha / 100
		self.combat_changes_alpha = amount
		rowsamount = amount
		menuamount = amount
		if (_detalhes.pet_battle) then
			amount = 0
			rowsamount = 0
			menuamount = 0
		end
	else
		if (self.menu_alpha.enabled) then --auto transparency
			if (self.is_interacting) then
				amount = self.menu_alpha.onenter
				menuamount = self.menu_alpha.onenter
				if (self.menu_alpha.ignorebars) then
					rowsamount = 1
				else
					rowsamount = amount
				end
			else
				amount = self.menu_alpha.onleave
				menuamount = self.menu_alpha.onleave
				if (self.menu_alpha.ignorebars) then
					rowsamount = 1
				else
					rowsamount = amount
				end
			end
		else
			amount = self.color [4]
			menuamount = 1
			rowsamount = 1
		end
		self.combat_changes_alpha = nil
	end

	--print ("baseframe:",amount,"rowframe:",rowsamount,"menu:",menuamount)
	
	--apply
	if (true_hide and amount == 0) then
		gump:Fade (self.baseframe, _unpack (_detalhes.windows_fade_in))
		gump:Fade (self.rowframe, _unpack (_detalhes.windows_fade_in))
		self:SetIconAlpha (nil, true)
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) hiding window SetWindowAlphaForCombat()", amount, rowsamount, menuamount)
		end
	else
	
		self.baseframe:Show()
		self.baseframe:SetAlpha (1)
		
		self:InstanceAlpha (amount)
		gump:Fade (self.rowframe, "ALPHAANIM", rowsamount)
		gump:Fade (self.baseframe, "ALPHAANIM", rowsamount)
		self:SetIconAlpha (menuamount)
		
		if (_detalhes.debug) then
			_detalhes:Msg ("(debug) showing window SetWindowAlphaForCombat()", amount, rowsamount, menuamount)
		end
	end
	
	if (self.show_statusbar) then
		self.baseframe.barra_fundo:Hide()
	end
	if (self.hide_icon) then
		self.baseframe.cabecalho.atributo_icon:Hide()
	end

end

function _detalhes:InstanceButtonsColors (red, green, blue, alpha, no_save, only_left, only_right)
	
	if (not red) then
		red, green, blue, alpha = unpack (self.color_buttons)
	end
	
	if (type (red) ~= "number") then
		red, green, blue, alpha = gump:ParseColors (red)
	end
	
	if (not no_save) then
		self.color_buttons [1] = red
		self.color_buttons [2] = green
		self.color_buttons [3] = blue
		self.color_buttons [4] = alpha
	end
	
	local baseToolbar = self.baseframe.cabecalho
	

	if (only_left) then
	
		local icons = {baseToolbar.modo_selecao, baseToolbar.segmento, baseToolbar.atributo, baseToolbar.report, baseToolbar.fechar, baseToolbar.reset, baseToolbar.fechar}
		
		for _, button in _ipairs (icons) do 
			button:SetAlpha (alpha)
		end

		if (self:IsLowerInstance()) then
			for _, ThisButton in _ipairs (_detalhes.ToolBar.Shown) do
				ThisButton:SetAlpha (alpha)
			end
		end

	else
		
		local icons = {baseToolbar.modo_selecao, baseToolbar.segmento, baseToolbar.atributo, baseToolbar.report, baseToolbar.fechar, baseToolbar.reset, baseToolbar.fechar}
		
		for _, button in _ipairs (icons) do 
			button:SetAlpha (alpha)
		end

		if (self:IsLowerInstance()) then
			for _, ThisButton in _ipairs (_detalhes.ToolBar.Shown) do
				ThisButton:SetAlpha (alpha)
			end
		end
	
	end
end

function _detalhes:InstanceAlpha (alpha)
	self.baseframe.cabecalho.ball_r:SetAlpha (alpha)
	self.baseframe.cabecalho.ball:SetAlpha (alpha)
	
	local skin = _detalhes.skins [self.skin]
	if (not skin.icon_ignore_alpha) then
		self.baseframe.cabecalho.atributo_icon:SetAlpha (alpha)
	end	
	
	self.baseframe.cabecalho.emenda:SetAlpha (alpha)
	self.baseframe.cabecalho.top_bg:SetAlpha (alpha)
	self.baseframe.barra_esquerda:SetAlpha (alpha)
	self.baseframe.barra_direita:SetAlpha (alpha)
	self.baseframe.barra_fundo:SetAlpha (alpha)
	self.baseframe.UPFrame:SetAlpha (alpha)
end

function _detalhes:InstanceColor (red, green, blue, alpha, no_save, change_statusbar)

	if (not red) then
		red, green, blue, alpha = unpack (self.color)
		no_save = true
	end

	if (type (red) ~= "number") then
		red, green, blue, alpha = gump:ParseColors (red)
	end

	if (not no_save) then
		--> saving
		self.color [1] = red
		self.color [2] = green
		self.color [3] = blue
		self.color [4] = alpha
		if (change_statusbar) then
			self:StatusBarColor (red, green, blue, alpha)
		end
	else
		--> not saving
		self:StatusBarColor (nil, nil, nil, alpha, true)
	end

--	print (self.skin, self.meu_id)
	local skin = _detalhes.skins [self.skin]
	if (not skin) then --the skin isn't available any more
		Details:Msg ("Skin " .. (self.skin or "?") .. " not found, changing to 'Minimalistic'.")
		Details:Msg ("Recommended to change the skin in the option panel > Skin Selection.")
		skin = _detalhes.skins ["Minimalistic"]
		self.skin = "Minimalistic"
	end
	
	--[[
	self.baseframe.rodape.esquerdo:SetVertexColor (red, green, blue)
		self.baseframe.rodape.esquerdo:SetAlpha (alpha)
	self.baseframe.rodape.direita:SetVertexColor (red, green, blue)
		self.baseframe.rodape.direita:SetAlpha (alpha)
	self.baseframe.rodape.top_bg:SetVertexColor (red, green, blue)
		self.baseframe.rodape.top_bg:SetAlpha (alpha)
	--]]
	
	self.baseframe.cabecalho.ball_r:SetVertexColor (red, green, blue)
		self.baseframe.cabecalho.ball_r:SetAlpha (alpha)
		
	self.baseframe.cabecalho.ball:SetVertexColor (red, green, blue)
	self.baseframe.cabecalho.ball:SetAlpha (alpha)
	
	if (not skin.icon_ignore_alpha) then
		self.baseframe.cabecalho.atributo_icon:SetAlpha (alpha)
	end

	self.baseframe.cabecalho.emenda:SetVertexColor (red, green, blue)
		self.baseframe.cabecalho.emenda:SetAlpha (alpha)
	self.baseframe.cabecalho.top_bg:SetVertexColor (red, green, blue)
		self.baseframe.cabecalho.top_bg:SetAlpha (alpha)

	self.baseframe.barra_esquerda:SetVertexColor (red, green, blue)
		self.baseframe.barra_esquerda:SetAlpha (alpha)
	self.baseframe.barra_direita:SetVertexColor (red, green, blue)
		self.baseframe.barra_direita:SetAlpha (alpha)
	self.baseframe.barra_fundo:SetVertexColor (red, green, blue)
		self.baseframe.barra_fundo:SetAlpha (alpha)
		
	self.baseframe.UPFrame:SetAlpha (alpha)

	--self.color[1], self.color[2], self.color[3], self.color[4] = red, green, blue, alpha
end

function _detalhes:StatusBarAlertTime (instance)
	instance.baseframe.statusbar:Hide()
end

function _detalhes:StatusBarAlert (text, icon, color, time)

	local statusbar = self.baseframe.statusbar
	
	if (text) then
		if (type (text) == "table") then
			if (text.color) then
				statusbar.text:SetTextColor (gump:ParseColors (text.color))
			else
				statusbar.text:SetTextColor (1, 1, 1, 1)
			end
			
			statusbar.text:SetText (text.text or "")
			
			if (text.size) then
				_detalhes:SetFontSize (statusbar.text, text.size)
			else
				_detalhes:SetFontSize (statusbar.text, 9)
			end
		else
			statusbar.text:SetText (text)
			statusbar.text:SetTextColor (1, 1, 1, 1)
			_detalhes:SetFontSize (statusbar.text, 9)
		end
	else
		statusbar.text:SetText ("")
	end
	
	if (icon) then
		if (type (icon) == "table") then
			local texture, w, h, l, r, t, b = unpack (icon)
			statusbar.icon:SetTexture (texture)
			statusbar.icon:SetWidth (w or 14)
			statusbar.icon:SetHeight (h or 14)
			if (l and r and t and b) then
				statusbar.icon:SetTexCoord (l, r, t, b)
			end
		else
			statusbar.icon:SetTexture (icon)
			statusbar.icon:SetWidth (14)
			statusbar.icon:SetHeight (14)
			statusbar.icon:SetTexCoord (0, 1, 0, 1)
		end
	else
		statusbar.icon:SetTexture (nil)
	end
	
	if (color) then
		statusbar:SetBackdropColor (gump:ParseColors (color))
	else
		statusbar:SetBackdropColor (0, 0, 0, 1)
	end
	
	if (icon or text) then
		statusbar:Show()
		if (time) then
			_detalhes:ScheduleTimer ("StatusBarAlertTime", time, self)
		end
	else
		statusbar:Hide()
	end
end


function gump:CriaRodape (baseframe, instancia)

	baseframe.rodape = {}
	
	--> esquerdo com statusbar
	baseframe.rodape.esquerdo = instancia.floatingframe:CreateTexture (nil, "overlay")
	baseframe.rodape.esquerdo:SetPoint ("topright", baseframe, "bottomleft", 16, 0)
	baseframe.rodape.esquerdo:SetTexture (DEFAULT_SKIN)
	baseframe.rodape.esquerdo:SetTexCoord (unpack (COORDS_PIN_LEFT))
	baseframe.rodape.esquerdo:SetWidth (32)
	baseframe.rodape.esquerdo:SetHeight (32)
	
	--> esquerdo sem statusbar
	baseframe.rodape.esquerdo_nostatusbar = instancia.floatingframe:CreateTexture (nil, "overlay")
	baseframe.rodape.esquerdo_nostatusbar:SetPoint ("topright", baseframe, "bottomleft", 16, 14)
	baseframe.rodape.esquerdo_nostatusbar:SetTexture (DEFAULT_SKIN)
	baseframe.rodape.esquerdo_nostatusbar:SetTexCoord (unpack (COORDS_PIN_LEFT))
	baseframe.rodape.esquerdo_nostatusbar:SetWidth (32)
	baseframe.rodape.esquerdo_nostatusbar:SetHeight (32)
	
	--> direito com statusbar
	baseframe.rodape.direita = instancia.floatingframe:CreateTexture (nil, "overlay")
	baseframe.rodape.direita:SetPoint ("topleft", baseframe, "bottomright", -16, 0)
	baseframe.rodape.direita:SetTexture (DEFAULT_SKIN)
	baseframe.rodape.direita:SetTexCoord (unpack (COORDS_PIN_RIGHT))
	baseframe.rodape.direita:SetWidth (32)
	baseframe.rodape.direita:SetHeight (32)
	
	--> direito sem statusbar
	baseframe.rodape.direita_nostatusbar = instancia.floatingframe:CreateTexture (nil, "overlay")
	baseframe.rodape.direita_nostatusbar:SetPoint ("topleft", baseframe, "bottomright", -16, 14)
	baseframe.rodape.direita_nostatusbar:SetTexture (DEFAULT_SKIN)
	baseframe.rodape.direita_nostatusbar:SetTexCoord (unpack (COORDS_PIN_RIGHT))
	baseframe.rodape.direita_nostatusbar:SetWidth (32)
	baseframe.rodape.direita_nostatusbar:SetHeight (32)
	
	--> barra centro
	baseframe.rodape.top_bg = baseframe:CreateTexture (nil, "background")
	baseframe.rodape.top_bg:SetTexture (DEFAULT_SKIN)
	baseframe.rodape.top_bg:SetTexCoord (unpack (COORDS_BOTTOM_BACKGROUND))
	baseframe.rodape.top_bg:SetWidth (512)
	baseframe.rodape.top_bg:SetHeight (128)
	baseframe.rodape.top_bg:SetPoint ("left", baseframe.rodape.esquerdo, "right", -16, -48)
	baseframe.rodape.top_bg:SetPoint ("right", baseframe.rodape.direita, "left", 16, -48)
	
	local StatusBarLeftAnchor = CreateFrame ("frame", "DetailsStatusBarAnchorLeft" .. instancia.meu_id, baseframe)
	StatusBarLeftAnchor:SetPoint ("left", baseframe.rodape.top_bg, "left", 5, 57)
	StatusBarLeftAnchor:SetWidth (1)
	StatusBarLeftAnchor:SetHeight (1)
	baseframe.rodape.StatusBarLeftAnchor = StatusBarLeftAnchor
	
	local StatusBarCenterAnchor = CreateFrame ("frame", "DetailsStatusBarAnchorCenter" .. instancia.meu_id, baseframe)
	StatusBarCenterAnchor:SetPoint ("center", baseframe.rodape.top_bg, "center", 0, 57)
	StatusBarCenterAnchor:SetWidth (1)
	StatusBarCenterAnchor:SetHeight (1)
	baseframe.rodape.StatusBarCenterAnchor = StatusBarCenterAnchor
	
	--> display frame
		baseframe.statusbar = CreateFrame ("frame", "DetailsStatusBar" .. instancia.meu_id, instancia.floatingframe)
		baseframe.statusbar:SetFrameLevel (instancia.floatingframe:GetFrameLevel()+2)
		baseframe.statusbar:SetPoint ("left", baseframe.rodape.esquerdo, "right", -13, 10)
		baseframe.statusbar:SetPoint ("right", baseframe.rodape.direita, "left", 13, 10)
		baseframe.statusbar:SetHeight (14)
		
		local statusbar_icon = baseframe.statusbar:CreateTexture (nil, "overlay")
		statusbar_icon:SetWidth (14)
		statusbar_icon:SetHeight (14)
		statusbar_icon:SetPoint ("left", baseframe.statusbar, "left")
		
		local statusbar_text = baseframe.statusbar:CreateFontString (nil, "overlay", "GameFontNormal")
		statusbar_text:SetPoint ("left", statusbar_icon, "right", 2, 0)
		
		baseframe.statusbar:SetBackdrop ({
		bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
		insets = {left = 0, right = 0, top = 0, bottom = 0}})
		baseframe.statusbar:SetBackdropColor (0, 0, 0, 1)
		
		baseframe.statusbar.icon = statusbar_icon
		baseframe.statusbar.text = statusbar_text
		baseframe.statusbar.instancia = instancia
		
		baseframe.statusbar:Hide()
	
	--> frame invis�vel
	baseframe.DOWNFrame = CreateFrame ("frame", "DetailsDownFrame" .. instancia.meu_id, baseframe)
	baseframe.DOWNFrame:SetPoint ("left", baseframe.rodape.esquerdo, "right", 0, 10)
	baseframe.DOWNFrame:SetPoint ("right", baseframe.rodape.direita, "left", 0, 10)
	baseframe.DOWNFrame:SetHeight (14)
	
	baseframe.DOWNFrame:Show()
	baseframe.DOWNFrame:EnableMouse (true)
	baseframe.DOWNFrame:SetMovable (true)
	baseframe.DOWNFrame:SetResizable (true)
	
	BGFrame_scripts (baseframe.DOWNFrame, baseframe, instancia)
end

function _detalhes:GetMenuAnchorPoint()
	local toolbar_side = self.toolbar_side
	local menu_side = self.menu_anchor.side
	
	if (menu_side == 1) then --left
		if (toolbar_side == 1) then --top
			return self.menu_points [1], "bottomleft", "bottomright"
		elseif (toolbar_side == 2) then --bottom
			return self.menu_points [1], "topleft", "topright"
		end
	elseif (menu_side == 2) then --right
		if (toolbar_side == 1) then --top
			return self.menu_points [2], "topleft", "bottomleft"
		elseif (toolbar_side == 2) then --bottom
			return self.menu_points [2], "topleft", "topleft"
		end
	end
end

--> search key: ~icon
function _detalhes:ToolbarMenuButtonsSize (size)
	size = size or self.menu_icons_size
	self.menu_icons_size = size
	return self:ToolbarMenuButtons()
end

local SetIconAlphaCacheButtonsTable = {}
function _detalhes:SetIconAlpha (alpha, hide, no_animations)

	if (self.attribute_text.enabled) then
		if (not self.menu_attribute_string) then --> create on demand
			self:AttributeMenu()
		end
		
		if (hide) then
			gump:Fade (self.menu_attribute_string.widget, _unpack (_detalhes.windows_fade_in))
		else
			if (no_animations) then
				self.menu_attribute_string:SetAlpha (alpha)
			else
				gump:Fade (self.menu_attribute_string.widget, "ALPHAANIM", alpha)
			end
		end
	end
	
	table.wipe (SetIconAlphaCacheButtonsTable)
	SetIconAlphaCacheButtonsTable [1] = self.baseframe.cabecalho.modo_selecao
	SetIconAlphaCacheButtonsTable [2] = self.baseframe.cabecalho.segmento
	SetIconAlphaCacheButtonsTable [3] = self.baseframe.cabecalho.atributo
	SetIconAlphaCacheButtonsTable [4] = self.baseframe.cabecalho.report
	SetIconAlphaCacheButtonsTable [5] = self.baseframe.cabecalho.reset
	SetIconAlphaCacheButtonsTable [6] = self.baseframe.cabecalho.fechar

	for index, button in _ipairs (SetIconAlphaCacheButtonsTable) do
		if (self.menu_icons [index]) then
			if (hide) then
				gump:Fade (button, _unpack (_detalhes.windows_fade_in))	
			else
				if (no_animations) then
					button:SetAlpha (alpha)
				else
					gump:Fade (button, "ALPHAANIM", alpha)
				end
			end
		end
	end
	
	if (self:IsLowerInstance()) then
		if (#_detalhes.ToolBar.Shown > 0) then
			for index, button in ipairs (_detalhes.ToolBar.Shown) do
				if (hide) then
					gump:Fade (button, _unpack (_detalhes.windows_fade_in))		
				else
					if (no_animations) then
						button:SetAlpha (alpha)
					else
						gump:Fade (button, "ALPHAANIM", alpha)
					end
				end
			end
		end
	end
end

function _detalhes:ToolbarMenuSetButtonsOptions (spacement, shadow)
	if (type (spacement) ~= "number") then
		spacement = self.menu_icons.space
	end
	
	if (type (shadow) ~= "boolean") then
		shadow = self.menu_icons.shadow
	end
	
	self.menu_icons.space = spacement
	self.menu_icons.shadow = shadow
	
	return self:ToolbarMenuSetButtons()
end

-- search key: ~buttons ~icons

local tbuttons = {}
function _detalhes:ToolbarMenuSetButtons (_mode, _segment, _attributes, _report, _reset, _close)
	
	if (_mode == nil) then
		_mode = self.menu_icons[1]
	end
	if (_segment == nil) then
		_segment = self.menu_icons[2]
	end
	if (_attributes == nil) then
		_attributes = self.menu_icons[3]
	end
	if (_report == nil) then
		_report = self.menu_icons[4]
	end
	if (_reset == nil) then
		_reset = self.menu_icons[5]
	end
	if (_close == nil) then
		_close = self.menu_icons[6]
	end
	
	self.menu_icons[1] = _mode
	self.menu_icons[2] = _segment
	self.menu_icons[3] = _attributes
	self.menu_icons[4] = _report
	self.menu_icons[5] = _reset
	self.menu_icons[6] = _close
	
	table.wipe (tbuttons)
	
	tbuttons [1] = self.baseframe.cabecalho.modo_selecao
	tbuttons [2] = self.baseframe.cabecalho.segmento
	tbuttons [3] = self.baseframe.cabecalho.atributo
	tbuttons [4] = self.baseframe.cabecalho.report
	tbuttons [5] = self.baseframe.cabecalho.reset
	tbuttons [6] = self.baseframe.cabecalho.fechar

	local anchor_frame, point1, point2 = self:GetMenuAnchorPoint()
	local got_anchor = false

	self.lastIcon = nil
	self.firstIcon = nil
	
	local size = self.menu_icons_size
	local space = self.menu_icons.space
	local shadow = self.menu_icons.shadow
	
	local toolbar_icon_file = self.toolbar_icon_file
	
	local total_buttons_shown = 0
	
	--> normal buttons
	if (self.menu_anchor.side == 1) then
		for index, button in _ipairs (tbuttons) do
			if (self.menu_icons [index]) then
				button:ClearAllPoints()
				if (got_anchor) then
					button:SetPoint ("left", self.lastIcon.widget or self.lastIcon, "right", space, 0)
				else
					button:SetPoint (point1, anchor_frame, point2)
					got_anchor = button
					self.firstIcon = button
				end
				self.lastIcon = button
				button:SetParent (self.baseframe)
				button:SetFrameLevel (self.baseframe.UPFrame:GetFrameLevel()+1)
				button:Show()

				button:SetSize (16*size, 16*size)
				
				button:SetNormalTexture (toolbar_icon_file)
				button:SetHighlightTexture (toolbar_icon_file)
				button:SetPushedTexture (toolbar_icon_file)
				
				total_buttons_shown = total_buttons_shown + 1
			else
				button:Hide()
			end
		end
		
	elseif (self.menu_anchor.side == 2) then
		for index = #tbuttons, 1, -1 do
			local button = tbuttons [index]

			if (self.menu_icons [index]) then
				button:ClearAllPoints()
				if (got_anchor) then
					button:SetPoint ("right", self.lastIcon.widget or self.lastIcon, "left", -space, 0)
				else
					button:SetPoint (point1, anchor_frame, point2)
					got_anchor = button
					self.firstIcon = button
				end
				self.lastIcon = button
				button:SetParent (self.baseframe)
				button:SetFrameLevel (self.baseframe.UPFrame:GetFrameLevel()+1)
				button:Show()
				
				button:SetSize (16*size, 16*size)
				
				button:SetNormalTexture (toolbar_icon_file)
				button:SetHighlightTexture (toolbar_icon_file)
				button:SetPushedTexture (toolbar_icon_file)
				
				total_buttons_shown = total_buttons_shown + 1
			else
				button:Hide()
			end
		end
	end
	
	--> plugins buttons
	
	local pluginFirstIcon = true
	if (not self.baseframe.cabecalho.PluginIconsSeparator) then
		self.baseframe.cabecalho.PluginIconsSeparator = self.baseframe:CreateTexture (nil, "overlay")
		self.baseframe.cabecalho.PluginIconsSeparator:SetTexture ([[Interface\FriendsFrame\StatusIcon-Offline]])

		local color = 0
		self.baseframe.cabecalho.PluginIconsSeparator:SetVertexColor (color, color, color)
		self.baseframe.cabecalho.PluginIconsSeparator:SetAlpha (0.2)
		
		local scale = 0.4
		self.baseframe.cabecalho.PluginIconsSeparator:SetSize (16 * scale, 16 * scale)
	end
	
	self.baseframe.cabecalho.PluginIconsSeparator:Hide()
	
	if (self:IsLowerInstance()) then
		if (#_detalhes.ToolBar.Shown > 0) then
		
			local last_plugin_icon
			
			if (#_detalhes.ToolBar.Shown > 0) then
				self.baseframe.cabecalho.PluginIconsSeparator:Show()
				self.baseframe.cabecalho.PluginIconsSeparator:ClearAllPoints()
				self.baseframe.cabecalho.PluginIconsSeparator.widget = self.baseframe.cabecalho.PluginIconsSeparator
			end
			
			for index, button in ipairs (_detalhes.ToolBar.Shown) do 
				button:ClearAllPoints()
				
				if (got_anchor) then
					if (pluginFirstIcon) then
						-- space = space + 6 --was adding an extra padding between plugin icons
					end
				
					if (self.plugins_grow_direction == 2) then --right
						if (self.menu_anchor.side == 1) then --left
						
							local temp_space = space
						
							if (pluginFirstIcon) then
								temp_space = temp_space / 3
								self.baseframe.cabecalho.PluginIconsSeparator:SetPoint ("left", last_plugin_icon or self.lastIcon.widget or self.lastIcon, "right", temp_space, 0)
								self.lastIcon = self.baseframe.cabecalho.PluginIconsSeparator
							end
						
							button:SetPoint ("left", self.lastIcon.widget or self.lastIcon, "right", temp_space, 0)
							
						elseif (self.menu_anchor.side == 2) then --right
						
							local temp_space = space
						
							if (pluginFirstIcon) then
								temp_space = temp_space / 3
								self.baseframe.cabecalho.PluginIconsSeparator:SetPoint ("left", last_plugin_icon or self.firstIcon.widget or self.firstIcon, "right", temp_space, 0)
								self.lastIcon = self.baseframe.cabecalho.PluginIconsSeparator
							end

							button:SetPoint ("left", last_plugin_icon or self.lastIcon.widget or self.firstIcon, "right", temp_space, 0)

						end
						
					elseif (self.plugins_grow_direction == 1) then --left
						if (self.menu_anchor.side == 1) then --left
						
							local temp_space = space
						
							if (pluginFirstIcon) then
								temp_space = temp_space / 3
								self.baseframe.cabecalho.PluginIconsSeparator:SetPoint ("right", last_plugin_icon or self.firstIcon.widget or self.firstIcon, "left", -temp_space, 0)
								self.lastIcon = self.baseframe.cabecalho.PluginIconsSeparator
							end
						
							button:SetPoint ("right", last_plugin_icon or self.lastIcon.widget or self.firstIcon, "left", -temp_space, 0)
							
						elseif (self.menu_anchor.side == 2) then --right
						
							local temp_space = space
						
							if (pluginFirstIcon) then
								temp_space = temp_space / 3
								self.baseframe.cabecalho.PluginIconsSeparator:SetPoint ("right", last_plugin_icon or self.lastIcon.widget or self.lastIcon, "left", -temp_space, 0)
								self.lastIcon = self.baseframe.cabecalho.PluginIconsSeparator
								
							end
							
							button:SetPoint ("right", last_plugin_icon or self.lastIcon.widget or self.firstIcon, "left", -temp_space, 0)
						end
					end
					
					pluginFirstIcon = false
				else
					button:SetPoint (point1, anchor_frame, point2)
					self.firstIcon = button
					got_anchor = button
				end
				
				self.lastIcon = button
				last_plugin_icon = button 
				
				button:SetParent (self.baseframe)
				button:SetFrameLevel (self.baseframe.UPFrame:GetFrameLevel()+1)
				button:Show()
				
				button:SetSize (16*size, 16*size)
				
				if (shadow and button.shadow) then
					button:SetNormalTexture (button.__icon .. "_shadow")
					button:SetPushedTexture (button.__icon .. "_shadow")
					button:SetHighlightTexture (button.__icon .. "_shadow", "ADD")
				else
					button:SetNormalTexture (button.__icon)
					button:SetPushedTexture (button.__icon)
					button:SetHighlightTexture (button.__icon, "ADD")
				end
				
				total_buttons_shown = total_buttons_shown + 1
			end
		end
		
		if (self.baseframe.cabecalho.PluginIconsSeparator:IsShown()) then
			if (self.baseframe.cabecalho.modo_selecao:GetAlpha() == 0) then
				self.baseframe.cabecalho.PluginIconsSeparator:Hide()
			end
		end
		
	end
	
	self.total_buttons_shown = total_buttons_shown
	self:RefreshAttributeTextSize()
	
	return true
	
end

function _detalhes:ToolbarMenuButtons (_mode, _segment, _attributes, _report)
	return self:ToolbarMenuSetButtons (_mode, _segment, _attributes, _report)
end

local parameters_table = {}

local on_leave_menu = function (self, elapsed)
	parameters_table[2] = parameters_table[2] + elapsed
	if (parameters_table[2] > 0.3) then
		if (not _G.GameCooltip.mouseOver and not _G.GameCooltip.buttonOver and (not _G.GameCooltip:GetOwner() or _G.GameCooltip:GetOwner() == self)) then
			_G.GameCooltip:ShowMe (false)
		end
		self:SetScript ("OnUpdate", nil)
	end
end

local OnClickNovoMenu = function (_, _, id, instance)

	local is_new
	if (not _detalhes.tabela_instancias [id]) then
		--> esta criando uma nova
		is_new = true
	end

	local ninstance = _detalhes.CriarInstancia (_, _, id)
	instance.baseframe.cabecalho.modo_selecao:GetScript ("OnEnter")(instance.baseframe.cabecalho.modo_selecao, _, true)
	
	if (ninstance and is_new) then
		ninstance.baseframe.cabecalho.modo_selecao:GetScript ("OnEnter")(ninstance.baseframe.cabecalho.modo_selecao, _, true)
	end
end

function _detalhes:SetTooltipMinWidth()
	GameCooltip:SetOption ("MinWidth", 155)
end

function _detalhes:FormatCooltipBackdrop()

	local CoolTip = GameCooltip

	CoolTip:SetBackdrop (1, menus_backdrop, menus_backdropcolor, menus_bordercolor)
	CoolTip:SetBackdrop (2, menus_backdrop, menus_backdropcolor_sec, menus_bordercolor)
	--CoolTip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)

end

local build_mode_list = function (self, elapsed)

	local CoolTip = GameCooltip
	local instancia = parameters_table [1]
	parameters_table[2] = parameters_table[2] + elapsed
	
	if (parameters_table[2] > 0.15) then
		self:SetScript ("OnUpdate", nil)
		
		CoolTip:Reset()
		CoolTip:SetType ("menu")
		CoolTip:SetLastSelected ("main", parameters_table [3])
		CoolTip:SetFixedParameter (instancia)
		
		CoolTip:SetOption ("TextSize", _detalhes.font_sizes.menus)
		CoolTip:SetOption ("TextFont", _detalhes.font_faces.menus)		
		
		CoolTip:SetOption ("ButtonHeightModSub", -2)
		CoolTip:SetOption ("ButtonHeightMod", -5)
		
		CoolTip:SetOption ("ButtonsYModSub", -3)
		CoolTip:SetOption ("ButtonsYMod", -6)
		
		CoolTip:SetOption ("YSpacingModSub", -3)
		CoolTip:SetOption ("YSpacingMod", 1)
		
		CoolTip:SetOption ("HeighMod", 3)
		CoolTip:SetOption ("SubFollowButton", true)
		
		_detalhes:SetTooltipMinWidth()
		
		CoolTip:AddLine (Loc ["STRING_MODE_GROUP"])
		CoolTip:AddMenu (1, instancia.AlteraModo, 2, true)
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 32/256, 32/256*2, 0, 1)
		
		CoolTip:AddLine (Loc ["STRING_MODE_ALL"])
		CoolTip:AddMenu (1, instancia.AlteraModo, 3, true)
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 32/256*2, 32/256*3, 0, 1)
	
		CoolTip:AddLine (Loc ["STRING_MODE_RAID"])
		CoolTip:AddMenu (1, instancia.AlteraModo, 4, true)
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 32/256*3, 32/256*4, 0, 1)

		--build raid plugins list
		local available_plugins = _detalhes.RaidTables:GetAvailablePlugins()

		if (#available_plugins >= 0) then
			local amt = 0
			
			for index, ptable in _ipairs (available_plugins) do
				if (ptable [3].__enabled) then
					CoolTip:AddMenu (2, _detalhes.RaidTables.EnableRaidMode, instancia, ptable [4], true, ptable [1], ptable [2], true) --PluginName, PluginIcon, PluginObject, PluginAbsoluteName
					amt = amt + 1
				end
			end
			
			--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		end

		CoolTip:AddLine (Loc ["STRING_MODE_SELF"])
		CoolTip:AddMenu (1, instancia.AlteraModo, 1, true)
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 0, 32/256, 0, 1)
		
		--build self plugins list
		
		--pega a list de plugins solo:
		if (#_detalhes.SoloTables.Menu > 0) then
			for index, ptable in _ipairs (_detalhes.SoloTables.Menu) do 
				if (ptable [3].__enabled) then
					CoolTip:AddMenu (2, _detalhes.SoloTables.EnableSoloMode, instancia, ptable [4], true, ptable [1], ptable [2], true)
				end
			end
			--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		end
		
		--> window control
		GameCooltip:AddLine ("$div")
		CoolTip:AddLine (Loc ["STRING_MENU_INSTANCE_CONTROL"])
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 0.625, 0.75, 0, 1)
		
		local HaveClosedInstances = false
		for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount), 1 do 
			local _this_instance = _detalhes.tabela_instancias [index]
			if (not _this_instance.ativa) then
				HaveClosedInstances = true
				break
			end
		end
		
		if (_detalhes:GetNumInstancesAmount() < _detalhes:GetMaxInstancesAmount()) then
			CoolTip:AddMenu (2, OnClickNovoMenu, true, instancia, nil, Loc ["STRING_OPTIONS_WC_CREATE"], _, true)
			CoolTip:AddIcon ([[Interface\Buttons\UI-AttributeButton-Encourage-Up]], 2, 1, 16, 16)
			if (HaveClosedInstances) then
				GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
			end
		end
		
		local ClosedInstances = 0
		
		for index = 1, math.min (#_detalhes.tabela_instancias, _detalhes.instances_amount), 1 do 
		
			local _this_instance = _detalhes.tabela_instancias [index]
			
			if (not _this_instance.ativa) then --> s� reabre se ela estiver ativa
			
				--> pegar o que ela ta mostrando
				local atributo = _this_instance.atributo
				local sub_atributo = _this_instance.sub_atributo
				ClosedInstances = ClosedInstances + 1
				
				if (atributo == 5) then --> custom
				
					local CustomObject = _detalhes.custom [sub_atributo]
					
					if (not CustomObject) then
						_this_instance:ResetAttribute()
						atributo = _this_instance.atributo
						sub_atributo = _this_instance.sub_atributo
						CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], _, true)
						CoolTip:AddIcon (_detalhes.sub_atributos [atributo].icones[sub_atributo] [1], 2, 1, 16, 16, unpack (_detalhes.sub_atributos [atributo].icones[sub_atributo] [2]))
					else
						CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. CustomObject:GetName(), _, true)
						CoolTip:AddIcon (CustomObject.icon, 2, 1, 16, 16, 0, 1, 0, 1)
					end

				else
					local modo = _this_instance.modo
					
					if (modo == 1) then --alone
					
						atributo = _detalhes.SoloTables.Mode or 1
						local SoloInfo = _detalhes.SoloTables.Menu [atributo]
						if (SoloInfo) then
							CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. SoloInfo [1], _, true)
							CoolTip:AddIcon (SoloInfo [2], 2, 1, 16, 16, 0, 1, 0, 1)
						else
							CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " Unknown Plugin", _, true)
						end
						
					elseif (modo == 4) then --raid
					
						local plugin_name = _this_instance.current_raid_plugin or _this_instance.last_raid_plugin
						if (plugin_name) then
							local plugin_object = _detalhes:GetPlugin (plugin_name)
							if (plugin_object) then
								CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. plugin_object.__name, _, true)
								CoolTip:AddIcon (plugin_object.__icon, 2, 1, 16, 16, 0, 1, 0, 1)	
							else
								CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " Unknown Plugin", _, true)
							end
						else
							CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " Unknown Plugin", _, true)
						end
						
					else
					
						--CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. _detalhes.atributos.lista [atributo] .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], _, true)
						CoolTip:AddMenu (2, OnClickNovoMenu, index, instancia, nil, "#".. index .. " " .. _detalhes.sub_atributos [atributo].lista [sub_atributo], _, true)
						CoolTip:AddIcon (_detalhes.sub_atributos [atributo].icones[sub_atributo] [1], 2, 1, 16, 16, unpack (_detalhes.sub_atributos [atributo].icones[sub_atributo] [2]))
						
					end
				end

				CoolTip:SetOption ("TextSize", _detalhes.font_sizes.menus)
				CoolTip:SetOption ("TextFont", _detalhes.font_faces.menus)
			end
		end		
		
		if (ClosedInstances > 0 or _detalhes:GetNumInstancesAmount() < _detalhes:GetMaxInstancesAmount()) then
			GameCooltip:AddLine ("$div", nil, 2, nil, -5, -11)
		end

		GameCooltip:AddLine (Loc ["STRING_MENU_CLOSE_INSTANCE"], nil, 2, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\Buttons\UI-Panel-MinimizeButton-Up]], 2, 1, 14, 14, 0.2, 0.8, 0.2, 0.8)
		GameCooltip:AddMenu (2, _detalhes.close_instancia_func, instancia.baseframe.cabecalho.fechar)
		
		--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		
		--> space
		GameCooltip:AddLine ("$div")
		
		--> forge and history buttons
		CoolTip:AddLine (Loc ["STRING_SPELLLIST"])
		CoolTip:AddMenu (1, _detalhes.OpenForge)
		CoolTip:AddIcon ([[Interface\MINIMAP\Vehicle-HammerGold-3]], 1, 1, 16, 16, 0, 1, 0, 1)
		
		--> statistics
		CoolTip:AddLine (Loc ["STRING_STATISTICS"])
		CoolTip:AddMenu (1, _detalhes.OpenRaidHistoryWindow)
		CoolTip:AddIcon ([[Interface\PvPRankBadges\PvPRank08]], 1, 1, 16, 16, 0, 1, 0, 1)
		
		--> space
		GameCooltip:AddLine ("$div")
		
		--> options
		CoolTip:AddLine (Loc ["STRING_OPTIONS_WINDOW"])
		CoolTip:AddMenu (1, _detalhes.OpenOptionsWindow)
		CoolTip:AddIcon ([[Interface\AddOns\Details\images\modo_icones]], 1, 1, 20, 20, 0.5, 0.625, 0, 1)
		
		--> finishes the menu
		_detalhes:SetMenuOwner (self, instancia)
		
		--apply the backdrop settings to the menu
		_detalhes:FormatCooltipBackdrop()
		
		show_anti_overlap (instancia, self, "top")
		
		CoolTip:ShowCooltip()
	end
end



function _detalhes:SetMenuOwner (self, instance)

	local _, y = instance.baseframe:GetCenter()
	local screen_height = GetScreenHeight()

	if (instance.toolbar_side == 1) then
		if (y+300 > screen_height) then
			GameCooltip:SetOwner (self, "top", "bottom", 0, -10)
		else
			GameCooltip:SetOwner (self)
		end
		
	elseif (instance.toolbar_side == 2) then --> bottom
		
		local instance_height = instance.baseframe:GetHeight()
		
		if (y + math.max (instance_height, 250) > screen_height) then
			GameCooltip:SetOwner (self, "top", "bottom", 0, -10)
		else
			GameCooltip:SetOwner (self, "bottom", "top", 0, 0)
		end
		
	end
	
end

local empty_segment_color = {1, 1, 1, .4}

local segments_common_tex, segments_common_color = {0.5078125, 0.1171875, 0.017578125, 0.1953125}, {1, 1, 1, .5}
local unknown_boss_tex, unknown_boss_color = {0.14453125, 0.9296875, 0.2625, 0.6546875}, {1, 1, 1, 0.5}

local party_line_color = {170/255, 167/255, 255/255, 1}
local party_line_color_trash = {130/255, 130/255, 155/255, 1}
local party_line_color2 = {210/255, 200/255, 255/255, 1}
local party_line_color2_trash = {110/255, 110/255, 155/255, 1}

local party_wallpaper_tex, party_wallpaper_color, raid_wallpaper_tex = {0.09, 0.698125, 0, 0.833984375}, {1, 1, 1, 0.5}, {33/512, 361/512, 45/512, 295/512}

local segments_wallpaper_color = {1, 1, 1, 0.5}
local segment_color_lime = {0, 1, 0, 1}
local segment_color_red = {1, 0, 0, 1}

function _detalhes:GetSegmentInfo (index)
	local combat
	
	if (index == -1 or index == "overall") then
		combat = _detalhes.tabela_overall
	elseif (index == 0 or index == "current") then	
		combat = _detalhes.tabela_vigente
	else
		combat = _detalhes.tabela_historico.tabelas [index]
	end
	
	if (combat) then
	
		local enemy
		local color
		local raid_type
		local killed
		local portrait
		local background
		local background_coords
		local is_trash
		
		if (combat.is_boss and combat.is_boss.name) then
		
			if (combat.instance_type == "party") then
				raid_type = "party"
				enemy = combat.is_boss.name
				color = party_line_color

			elseif (combat.is_boss.killed) then
				raid_type = "raid"
				enemy = combat.is_boss.name
				color = segment_color_lime
				killed = true

			else
				raid_type = "raid"
				enemy = combat.is_boss.name
				color = segment_color_red
				killed = false

			end
			
			local p = _detalhes:GetBossPortrait (combat.is_boss.mapid, combat.is_boss.index)
			if (p) then
				portrait = p
			end
			
			local b = _detalhes:GetRaidIcon (combat.is_boss.mapid)
			if (b) then
				background = b
				background_coords = segment_color_lime

			elseif (combat.instance_type == "party") then
				local ej_id = combat.is_boss.ej_instance_id
				if (ej_id) then
					local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (ej_id)
					if (bgImage) then
						background = bgImage
						background_coords = party_wallpaper_tex
					end
				end
			end
		
		elseif (combat.is_arena) then
			enemy = combat.is_arena.name
			
			local file, coords = _detalhes:GetArenaInfo (combat.is_arena.mapid)

			if (file) then
				background = "Interface\\Glues\\LOADINGSCREENS\\" .. file
				background_coords = coords
			end
			
		else
			enemy = combat.enemy
			
			if (combat.is_trash) then
				is_trash = true
			end
		end
		
		return enemy, color, raid_type, killed, is_trash, portrait, background, background_coords
	end
	
end

function _detalhes:UnpackMythicDungeonInfo (t)
	return t.OverallSegment, t.SegmentID, t.Level, t.EJID, t.MapID, t.ZoneName, t.EncounterID, t.EncounterName, t.StartedAt, t.EndedAt, t.RunID
end

local segments_used = 0
local segments_filled = 0

-- search key: ~segments
local build_segment_list = function (self, elapsed)

	local CoolTip = GameCooltip
	local instancia = parameters_table [1]
	parameters_table[2] = parameters_table[2] + elapsed
	
	local battleground_color = {1, 0.666, 0, 1}
	
	if (parameters_table[2] > 0.15) then
		self:SetScript ("OnUpdate", nil)
	
		--> here we are using normal Add calls
		CoolTip:Reset()
		CoolTip:SetType ("menu")
		CoolTip:SetFixedParameter (instancia)
		CoolTip:SetColor ("main", "transparent")

		CoolTip:SetOption ("FixedWidthSub", 195)
		CoolTip:SetOption ("RightTextWidth", 105)
		CoolTip:SetOption ("RightTextHeight", 12)
		
		CoolTip:SetOption ("SubFollowButton", true)
	
		----------- segments
		local menuIndex = 0
		_detalhes.segments_amount = math.floor (_detalhes.segments_amount)
		
		local fight_amount = 0
		
		local filled_segments = 0
		for i = 1, _detalhes.segments_amount do
			if (_detalhes.tabela_historico.tabelas [i]) then
				filled_segments = filled_segments + 1
			else
				break
			end
		end

		filled_segments = _detalhes.segments_amount - filled_segments - 2
		local fill = math.abs (filled_segments - _detalhes.segments_amount)
		segments_used = 0
		segments_filled = fill
		
		local dungeon_color = party_line_color
		local dungeon_color_trash = party_line_color_trash
		local dungeon_run_id = false
		
		--> history table (segments container)
		local isMythicDungeon = false
		for i = _detalhes.segments_amount, 1, -1 do
			
			if (i <= fill) then

				local thisCombat = _detalhes.tabela_historico.tabelas [i]
				if (thisCombat) then
					local enemy = thisCombat.is_boss and thisCombat.is_boss.name
					local segment_info_added = false
					
					segments_used = segments_used + 1

					--print (thisCombat.is_boss.name, thisCombat.instance_type, _detalhes:GetRaidIcon (thisCombat.is_boss.mapid), thisCombat.is_boss.ej_instance_id)

					if (thisCombat.is_mythic_dungeon_segment) then
					
						if (not isMythicDungeon) then
							--GameCooltip:AddLine ("$div", nil, nil, -5, -13)
							isMythicDungeon = thisCombat.is_mythic_dungeon_run_id
						else
							if (isMythicDungeon ~= thisCombat.is_mythic_dungeon_run_id) then
							--	GameCooltip:AddLine ("$div", nil, nil, -5, -13)
								isMythicDungeon = thisCombat.is_mythic_dungeon_run_id
							end
						end
					
						local mythicDungeonInfo = thisCombat:GetMythicDungeonInfo()
					
						if (mythicDungeonInfo) then
							--> is a boss, trash overall or run overall segment
						
							local bossInfo = thisCombat.is_boss
							
							local isMythicOverallSegment, segmentID, mythicLevel, EJID, mapID, zoneName, encounterID, encounterName, startedAt, endedAt, runID = _detalhes:UnpackMythicDungeonInfo (mythicDungeonInfo)
							local combat_time = thisCombat:GetCombatTime()
							
							if (not dungeon_run_id) then
								dungeon_run_id = runID
							else
								if (dungeon_run_id ~= runID) then
									dungeon_color = dungeon_color == party_line_color and party_line_color2 or party_line_color
									dungeon_color_trash = dungeon_color_trash == party_line_color_trash and party_line_color2_trash or party_line_color_trash
									dungeon_run_id = runID
								end
							end

							--> is mythic overall
							if (isMythicOverallSegment) then
								--mostrar o tempo da dungeon
								local totalTime = combat_time
								--CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (overall)", _detalhes.gump:IntegerToTimer (totalTime), 1, dungeon_color)
								CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (" .. Loc ["STRING_SEGMENTS_LIST_OVERALL"] .. ")", _detalhes.gump:IntegerToTimer (endedAt - startedAt), 1, dungeon_color)
								CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512)
								CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (" .. Loc ["STRING_SEGMENTS_LIST_OVERALL"] .. ")", nil, 2, "white", "white")
								
							else
								if (segmentID == "trashoverall") then
									local trashIcon = "|TInterface\\AddOns\\Details\\images\\icons:16:16:0:0:512:512:14:58:98:160|t"
									CoolTip:AddLine (trashIcon .. "" .. (encounterName or Loc ["STRING_UNKNOW"]) .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")", _detalhes.gump:IntegerToTimer (endedAt - startedAt), 1, dungeon_color, "gray")
									CoolTip:AddLine ((encounterName or Loc ["STRING_UNKNOW"]) .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")", nil, 2, "white", "white")
								else
									local skull = "|TInterface\\AddOns\\Details\\images\\icons:16:16:0:0:512:512:496:512:0:16|t"
									CoolTip:AddLine (skull .. "" .. (encounterName or Loc ["STRING_UNKNOW"]) .. " (" .. Loc ["STRING_SEGMENTS_LIST_BOSS"] .. ")", _detalhes.gump:IntegerToTimer (combat_time), 1, dungeon_color, "gray")
									CoolTip:AddLine ((encounterName or Loc ["STRING_UNKNOW"]) .. " (" .. Loc ["STRING_SEGMENTS_LIST_BOSS"] .. ")", nil, 2, "white", "white")
								end
								CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512)
							end
							
							local portrait = (thisCombat.is_boss and thisCombat.is_boss.bossimage) or _detalhes:GetBossPortrait (nil, nil, encounterName, EJID)
							if (portrait) then
								CoolTip:AddIcon (portrait, 2, "top", 128, 64, 0, 1, 0, 0.96)
							end
							
							local backgroundImage = _detalhes:GetRaidIcon (mapID, EJID, "party")
							if (backgroundImage) then
								CoolTip:SetWallpaper (2, backgroundImage, {0.070, 0.695, 0.087, 0.566}, {1, 1, 1, 0.5}, true) -- party_wallpaper_tex -- {0.09, 0.698125, .17, 0.833984375}
							end
							
							--> sub menu
							local decorrido = thisCombat:GetCombatTime()
							local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
							--CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white")
							
							if (segmentID == "trashoverall") then
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TIMEINCOMBAT"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
								local totalRealTime = endedAt - startedAt
								local wasted = totalRealTime - decorrido
								
								--wasted time
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_WASTED_TIME"] .. ":", "|cFFFF3300" .. _detalhes.gump:IntegerToTimer (wasted) .. " (" .. floor (wasted / totalRealTime * 100) .. "%)|r", 2, "white", "white")
								CoolTip:AddStatusBar (100, 2, 0, 0, 0, 0.35, false, false, "Skyline")
								
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TOTALTIME"] .. ":", _detalhes.gump:IntegerToTimer (endedAt - startedAt), 2, "white", "white")
								
							elseif (isMythicOverallSegment) then
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TIMEINCOMBAT"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
								local totalRealTime = endedAt - startedAt
								local wasted = totalRealTime - decorrido
								
								--wasted time
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_WASTED_TIME"] .. ":", "|cFFFF3300" .. _detalhes.gump:IntegerToTimer (wasted) .. " (" .. floor (wasted / totalRealTime * 100) .. "%)|r", 2, "white", "white")
								CoolTip:AddStatusBar (100, 2, 0, 0, 0, 0.35, false, false, "Skyline")
								
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TOTALTIME"] .. ":", _detalhes.gump:IntegerToTimer (totalRealTime), 2, "white", "white")
								
							else
								CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
							end
							
							if (thisCombat.is_boss) then
								CoolTip:AddLine ("", "", 2, "white", "white")
							end
							
							CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", thisCombat.data_inicio, 2, "white", "white")
							CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", thisCombat.data_fim or "in progress", 2, "white", "white")
							
							CoolTip:AddStatusBar (100, 1, .3, .3, .3, 0.2, false, false, "Skyline")
						else
							--> the combat has mythic dungeon tag but doesn't have a mythic dungeon table information
							--> so this is a trash cleanup segment
							
							local trashInfo = thisCombat:GetMythicDungeonTrashInfo()
							
							CoolTip:AddLine (Loc ["STRING_SEGMENT_TRASH"] .. " (#" .. i .. ")", _detalhes.gump:IntegerToTimer (thisCombat:GetCombatTime()), 1, dungeon_color_trash, "gray")
							--CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.02734375, 0.11328125, 0.19140625, 0.3125, "red")
							CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512, nil, nil, true)
							
							--submenu
							CoolTip:AddLine (Loc ["STRING_SEGMENT_TRASH"], nil, 2, "white", "white")
							CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":",  _detalhes.gump:IntegerToTimer (thisCombat:GetCombatTime()), 2, "white", "white")
							CoolTip:AddLine ("", "", 2, "white", "white")
							CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", thisCombat.data_inicio, 2, "white", "white")
							CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", thisCombat.data_fim or "in progress", 2, "white", "white")
							
							if (trashInfo) then
								local backgroundImage = _detalhes:GetRaidIcon (trashInfo.MapID, trashInfo.EJID, "party")
								if (backgroundImage) then
									CoolTip:SetWallpaper (2, backgroundImage, {0.070, 0.695, 0.087, 0.566}, {1, 1, 1, 0.5}, true)
								end
							end
						end
						segment_info_added = true
						
					elseif (thisCombat.is_boss and thisCombat.is_boss.name) then
						
						isMythicDungeon = false
						local try_number = thisCombat.is_boss.try_number
						local combat_time = thisCombat:GetCombatTime()
					
						if (thisCombat.instance_type == "party") then
							CoolTip:AddLine (thisCombat.is_boss.name .." (#"..i..")", _, 1, dungeon_color)
						elseif (thisCombat.is_boss.killed) then
							if (try_number) then
								local m, s = _math_floor (combat_time/60), _math_floor (combat_time%60)
								if (s < 10) then
									s = "0" .. s
								end
								CoolTip:AddLine (thisCombat.is_boss.name .." (#"..try_number.." " .. m .. ":" .. s .. ")", _, 1, "lime")
							else
								CoolTip:AddLine (thisCombat.is_boss.name .." (#"..i..")", _, 1, "lime")
							end
						else
							if (try_number) then
								local m, s = _math_floor (combat_time/60), _math_floor (combat_time%60)
								if (s < 10) then
									s = "0" .. s
								end
								CoolTip:AddLine (thisCombat.is_boss.name .." (#"..try_number.." " .. m .. ":" .. s .. ")", _, 1, "red")
							else
								CoolTip:AddLine (thisCombat.is_boss.name .." (#"..i..")", _, 1, "red")
							end
						end

						local portrait = _detalhes:GetBossPortrait (thisCombat.is_boss.mapid, thisCombat.is_boss.index) or thisCombat.is_boss.bossimage
						if (portrait) then
							CoolTip:AddIcon (portrait, 2, "top", 128, 64)
						else
							local encounter_name = thisCombat.is_boss.encounter
							local instanceID = thisCombat.is_boss.ej_instance_id
							if (encounter_name and instanceID and instanceID ~= 0) then
								local index, name, description, encounterID, rootSectionID, link = _detalhes:GetEncounterInfoFromEncounterName (instanceID, encounter_name)
								if (index and name and encounterID) then
									--EJ_SelectInstance (instanceID)
									--creature info pode ser sempre 1, n�o usar o index do boss
									local id, name, description, displayInfo, iconImage = DetailsFramework.EncounterJournal.EJ_GetCreatureInfo (1, encounterID)
									if (iconImage) then
										CoolTip:AddIcon (iconImage, 2, "top", 128, 64)
									end
								end
							end
						end

						CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 16, 0.96875, 1, 0, 0.03125)
						
						if (_detalhes.tooltip.submenu_wallpaper) then
							local background = _detalhes:GetRaidIcon (thisCombat.is_boss.mapid)
							if (background) then
								CoolTip:SetWallpaper (2, background, nil, segments_wallpaper_color, true)
							else
								local ej_id = thisCombat.is_boss.ej_instance_id
								if (ej_id and ej_id ~= 0) then
									local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (ej_id)
									if (name) then
										if (thisCombat.instance_type == "party") then
											CoolTip:SetWallpaper (2, bgImage, party_wallpaper_tex, party_wallpaper_color, true)
										else
											CoolTip:SetWallpaper (2, loreImage, raid_wallpaper_tex, party_wallpaper_color, true)
										end
									end
								else
									--CoolTip:SetWallpaper (2, [[Interface\BlackMarket\HotItemBanner]], unknown_boss_tex, unknown_boss_color, true)
								end
							end
						else
							--> wallpaper = main window
							--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
						end
					
					elseif (thisCombat.is_pvp) then
						isMythicDungeon = false
						CoolTip:AddLine (thisCombat.is_pvp.name, _, 1, battleground_color)
						enemy = thisCombat.is_pvp.name
						CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.251953125, 0.306640625, 0.205078125, 0.248046875)
						
						if (_detalhes.tooltip.submenu_wallpaper) then
							local file, coords = _detalhes:GetBattlegroundInfo (thisCombat.is_pvp.mapid)
							if (file) then
								CoolTip:SetWallpaper (2, "Interface\\Glues\\LOADINGSCREENS\\" .. file, coords, empty_segment_color, true)
							end
						else
							--> wallpaper = main window
							--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
						end
					
					elseif (thisCombat.is_arena) then
						isMythicDungeon = false
						CoolTip:AddLine (thisCombat.is_arena.name, _, 1, "yellow")
						enemy = thisCombat.is_arena.name
						CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.251953125, 0.306640625, 0.205078125, 0.248046875)
						
						if (_detalhes.tooltip.submenu_wallpaper) then
							local file, coords = _detalhes:GetArenaInfo (thisCombat.is_arena.mapid)
							if (file) then
								CoolTip:SetWallpaper (2, "Interface\\Glues\\LOADINGSCREENS\\" .. file, coords, empty_segment_color, true)
							end
						else
							--> wallpaper = main window
							--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
						end
					else
						isMythicDungeon = false
						enemy = thisCombat.enemy
						if (enemy) then
							CoolTip:AddLine (thisCombat.enemy .." (#"..i..")", _, 1, "yellow")
						else
							CoolTip:AddLine (segmentos.past..i, _, 1, "silver")
						end
						
						if (thisCombat.is_trash) then
							CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.02734375, 0.11328125, 0.19140625, 0.3125)
						else
							CoolTip:AddIcon ([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16)
						end
						
						if (_detalhes.tooltip.submenu_wallpaper) then
							CoolTip:SetWallpaper (2, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsBackground]], segments_common_tex, segments_common_color, true)
						else
							--> wallpaper = main window
							--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
						end
						
					end
					
					CoolTip:AddMenu (1, instancia.TrocaTabela, i)
					
					if (not segment_info_added) then
						CoolTip:AddLine (Loc ["STRING_SEGMENT_ENEMY"] .. ":", enemy, 2, "white", "white")
						local decorrido = thisCombat:GetCombatTime()
						local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white")
						
						CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", thisCombat.data_inicio, 2, "white", "white")
						CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", thisCombat.data_fim or "in progress", 2, "white", "white")
					end
					
					fight_amount = fight_amount + 1
				else
					CoolTip:AddLine (Loc ["STRING_SEGMENT_LOWER"] .. " #" .. i, _, 1, "gray")
					CoolTip:AddMenu (1, instancia.TrocaTabela, i)
					CoolTip:AddIcon ([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, empty_segment_color)
					CoolTip:AddLine (Loc ["STRING_SEGMENT_EMPTY"], _, 2)
					CoolTip:AddIcon ([[Interface\CHARACTERFRAME\Disconnect-Icon]], 2, 1, 12, 12, 0.3125, 0.65625, 0.265625, 0.671875)
					--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
				end
				
				if (menuIndex) then
					menuIndex = menuIndex + 1
					if (instancia.segmento == i) then
						CoolTip:SetLastSelected ("main", menuIndex)
						menuIndex = nil
					end
				end
			
			end
			
		end
		
		GameCooltip:AddLine ("$div", nil, nil, -5, -13)
		
		----------- current
			local enemy = _detalhes.tabela_vigente.is_boss and _detalhes.tabela_vigente.is_boss.name or _detalhes.tabela_vigente.enemy or "--x--x--"
			local file, coords
			
			local thisCombat = _detalhes.tabela_vigente
			local segment_info_added
			
			--> add the new line
			CoolTip:AddLine (segmentos.current_standard, _, 1, "white")
			CoolTip:AddMenu (1, instancia.TrocaTabela, 0)
			CoolTip:AddIcon ([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, "orange")
			--
			
			--> current segment is a dungeon mythic+?
			if (thisCombat.is_mythic_dungeon_segment) then
				local mythicDungeonInfo = thisCombat:GetMythicDungeonInfo()
			
				if (mythicDungeonInfo) then
					--> is a boss, trash overall or run overall segment
				
					local bossInfo = thisCombat.is_boss
					
					local isMythicOverallSegment, segmentID, mythicLevel, EJID, mapID, zoneName, encounterID, encounterName, startedAt, endedAt, runID = _detalhes:UnpackMythicDungeonInfo (mythicDungeonInfo)
					local combat_time = thisCombat:GetCombatTime()
					
					if (not dungeon_run_id) then
						dungeon_run_id = runID
					else
						if (dungeon_run_id ~= runID) then
							dungeon_color = dungeon_color == party_line_color and party_line_color2 or party_line_color
							dungeon_color_trash = dungeon_color_trash == party_line_color_trash and party_line_color2_trash or party_line_color_trash
							dungeon_run_id = runID
						end
					end

					--> is mythic overall
					if (isMythicOverallSegment) then
						--mostrar o tempo da dungeon
						local totalTime = combat_time
						--CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (overall)", _detalhes.gump:IntegerToTimer (totalTime), 1, dungeon_color)
						--CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (overall)", _detalhes.gump:IntegerToTimer (endedAt - startedAt), 1, dungeon_color)
						--CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512)
						CoolTip:AddLine (zoneName .. " +" .. mythicLevel .. " (" .. Loc ["STRING_SEGMENTS_LIST_OVERALL"] .. ")", nil, 2, "white", "white")
						
					else
						if (segmentID == "trashoverall") then
							--CoolTip:AddLine (encounterName .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")", _detalhes.gump:IntegerToTimer (combat_time), 1, dungeon_color, "gray")
							--CoolTip:AddLine (encounterName .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")", _detalhes.gump:IntegerToTimer (endedAt - startedAt), 1, dungeon_color, "gray")
							CoolTip:AddLine (encounterName .. " (" .. Loc ["STRING_SEGMENTS_LIST_TRASH"] .. ")", nil, 2, "white", "white")
						else
							--CoolTip:AddLine (encounterName .. " (" .. Loc ["STRING_SEGMENTS_LIST_BOSS"] .. ")", _detalhes.gump:IntegerToTimer (combat_time), 1, dungeon_color, "gray")
							CoolTip:AddLine (encounterName .. " (" .. Loc ["STRING_SEGMENTS_LIST_BOSS"] .. ")", nil, 2, "white", "white")
						end
						--CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512)
					end
					
					local portrait = (thisCombat.is_boss and thisCombat.is_boss.bossimage) or _detalhes:GetBossPortrait (nil, nil, encounterName, EJID)
					if (portrait) then
						CoolTip:AddIcon (portrait, 2, "top", 128, 64, 0, 1, 0, 0.96)
					end
					
					local backgroundImage = _detalhes:GetRaidIcon (mapID, EJID, "party")
					if (backgroundImage) then
						CoolTip:SetWallpaper (2, backgroundImage, {0.070, 0.695, 0.087, 0.566}, {1, 1, 1, 0.5}, true) -- party_wallpaper_tex -- {0.09, 0.698125, .17, 0.833984375}
					end
					
					--> sub menu
					local decorrido = thisCombat:GetCombatTime()
					local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
					--CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white")
					
					if (segmentID == "trashoverall") then
						local totalRealTime = endedAt - startedAt
						local wasted = totalRealTime - decorrido
						
						CoolTip:AddLine (Loc["STRING_SEGMENTS_LIST_TIMEINCOMBAT"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
						
						--wasted time
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_WASTED_TIME"] .. ":", "|cFFFF3300" .. _detalhes.gump:IntegerToTimer (wasted) .. " (" .. floor (wasted / totalRealTime * 100) .. "%)|r", 2, "white", "white")
						CoolTip:AddStatusBar (100, 2, 0, 0, 0, 0.35, false, false, "Skyline")
						
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TOTALTIME"] .. ":", _detalhes.gump:IntegerToTimer (endedAt - startedAt) .. " [|cFFFF3300" .. _detalhes.gump:IntegerToTimer (totalRealTime - decorrido) .. "|r]", 2, "white", "white")
						
					elseif (isMythicOverallSegment) then
						CoolTip:AddLine (Loc["STRING_SEGMENTS_LIST_TIMEINCOMBAT"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
						local totalRealTime = endedAt - startedAt
						local wasted = totalRealTime - decorrido
						
						
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_TOTALTIME"] .. ":", _detalhes.gump:IntegerToTimer (totalRealTime), 2, "white", "white")
						
						--wasted time
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_WASTED_TIME"] .. ":", "|cFFFF3300" .. _detalhes.gump:IntegerToTimer (wasted) .. " (" .. floor (wasted / totalRealTime * 100) .. "%)|r", 2, "white", "white")
						CoolTip:AddStatusBar (100, 2, 0, 0, 0, 0.35, false, false, "Skyline")
						
					else
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":",  _detalhes.gump:IntegerToTimer (decorrido), 2, "white", "white")
					end
					
					if (thisCombat.is_boss) then
						CoolTip:AddLine ("", "", 2, "white", "white")
					end
					
					CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", thisCombat.data_inicio, 2, "white", "white")
					CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", thisCombat.data_fim or "in progress", 2, "white", "white")
					
				else
					--> the combat has mythic dungeon tag but doesn't have a mythic dungeon table information
					--> so this is a trash cleanup segment
					
					local trashInfo = thisCombat:GetMythicDungeonTrashInfo()
					
					--CoolTip:AddLine (Loc ["STRING_SEGMENT_TRASH"], _detalhes.gump:IntegerToTimer (thisCombat:GetCombatTime()), 1, dungeon_color_trash, "gray")
					--CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 16, 12, 0.02734375, 0.11328125, 0.19140625, 0.3125, "red")
					--CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], "main", "left", 14, 10, 479/512, 510/512, 24/512, 51/512, nil, nil, true)
					
					--submenu
					CoolTip:AddLine (Loc ["STRING_SEGMENT_TRASH"], nil, 2, "white", "white")
					CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":",  _detalhes.gump:IntegerToTimer (thisCombat:GetCombatTime()), 2, "white", "white")
					CoolTip:AddLine ("", "", 2, "white", "white")
					CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", thisCombat.data_inicio, 2, "white", "white")
					CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", thisCombat.data_fim or "in progress", 2, "white", "white")
					
					if (trashInfo) then
						local backgroundImage = _detalhes:GetRaidIcon (trashInfo.MapID, trashInfo.EJID, "party")
						if (backgroundImage) then
							CoolTip:SetWallpaper (2, backgroundImage, {0.070, 0.695, 0.087, 0.566}, {1, 1, 1, 0.5}, true)
						end
					end
				end
				
				segment_info_added = true

			elseif (_detalhes.tabela_vigente.is_boss and _detalhes.tabela_vigente.is_boss.name) then
				local portrait = _detalhes:GetBossPortrait (_detalhes.tabela_vigente.is_boss.mapid, _detalhes.tabela_vigente.is_boss.index) or _detalhes.tabela_vigente.is_boss.bossimage
				if (portrait) then
					CoolTip:AddIcon (portrait, 2, "top", 128, 64)
				else
					local thisCombat = _detalhes.tabela_vigente
					local encounter_name = thisCombat.is_boss.encounter
					local instanceID = thisCombat.is_boss.ej_instance_id
					instanceID = tonumber (instanceID)
					if (encounter_name and instanceID and instanceID ~= 0) then
						local index, name, description, encounterID, rootSectionID, link = _detalhes:GetEncounterInfoFromEncounterName (instanceID, encounter_name)
						if (index and name and encounterID) then
							local id, name, description, displayInfo, iconImage = DetailsFramework.EncounterJournal.EJ_GetCreatureInfo (index, encounterID)
							if (iconImage) then
								CoolTip:AddIcon (iconImage, 2, "top", 128, 64)
							end
						end
					end
				end
				
				if (_detalhes.tooltip.submenu_wallpaper) then
					local background = _detalhes:GetRaidIcon (_detalhes.tabela_vigente.is_boss.mapid)
					if (background) then
						CoolTip:SetWallpaper (2, background, nil, segments_wallpaper_color, true)
					else
						local ej_id = _detalhes.tabela_vigente.is_boss.ej_instance_id
						if (ej_id and ej_id ~= 0) then
							local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (ej_id)
							if (name) then
								if (_detalhes.tabela_vigente.instance_type == "party") then
									CoolTip:SetWallpaper (2, bgImage, party_wallpaper_tex, party_wallpaper_color, true)
								else
									CoolTip:SetWallpaper (2, loreImage, raid_wallpaper_tex, party_wallpaper_color, true)
								end
							end
						end
					end
				else
					--> wallpaper = main window
					--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
				end
				
			elseif (_detalhes.tabela_vigente.is_pvp) then
				enemy = _detalhes.tabela_vigente.is_pvp.name
				file, coords = _detalhes:GetBattlegroundInfo (_detalhes.tabela_vigente.is_pvp.mapid)
			elseif (_detalhes.tabela_vigente.is_arena) then
				enemy = _detalhes.tabela_vigente.is_arena.name
				file, coords = _detalhes:GetArenaInfo (_detalhes.tabela_vigente.is_arena.mapid)
			else
				if (_detalhes.tooltip.submenu_wallpaper) then
					CoolTip:SetWallpaper (2, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsBackground]], segments_common_tex, {1, 1, 1, 0.5}, true)
				else
					--> wallpaper = main window
					--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
				end
			end					

			if (_detalhes.tooltip.submenu_wallpaper) then
				if (file) then
					CoolTip:SetWallpaper (2, "Interface\\Glues\\LOADINGSCREENS\\" .. file, coords, empty_segment_color, true)
				end
			else
				--> wallpaper = main window
				--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
			end
			
			if (not segment_info_added) then
				CoolTip:AddLine (Loc ["STRING_SEGMENT_ENEMY"] .. ":", enemy, 2, "white", "white")
				
				if (not _detalhes.tabela_vigente:GetEndTime()) then
					if (_detalhes.in_combat) then
						local decorrido = _detalhes.tabela_vigente:GetCombatTime()
						local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white") 
					else
						CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", "--x--x--", 2, "white", "white")
					end
				else
					local decorrido = _detalhes.tabela_vigente:GetCombatTime()
					local minutos, segundos = _math_floor (decorrido/60), _math_floor (decorrido%60)
					CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white") 
				end

				CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", _detalhes.tabela_vigente.data_inicio, 2, "white", "white")
				CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", _detalhes.tabela_vigente.data_fim or "in progress", 2, "white", "white") 
			end
			
			--> fill � a quantidade de menu que esta sendo mostrada
			if (instancia.segmento == 0) then
				if (fill - 2 == menuIndex) then
					CoolTip:SetLastSelected ("main", fill + 0)
				elseif (fill - 1 == menuIndex) then
					CoolTip:SetLastSelected ("main", fill + 1)
				else
					CoolTip:SetLastSelected ("main", fill + 2)
				end

				menuIndex = nil
			end
		
		----------- overall
		--CoolTip:AddLine (segmentos.overall_standard, _, 1, "white") Loc ["STRING_REPORT_LAST"] .. " " .. fight_amount .. " " .. Loc ["STRING_REPORT_FIGHTS"]
		CoolTip:AddLine (Loc ["STRING_SEGMENT_OVERALL"], _, 1, "white")
		CoolTip:AddMenu (1, instancia.TrocaTabela, -1)
		CoolTip:AddIcon ([[Interface\QUESTFRAME\UI-Quest-BulletPoint]], "main", "left", 16, 16, nil, nil, nil, nil, "orange")
			
			local enemy_name = _detalhes.tabela_overall.overall_enemy_name
			
			CoolTip:AddLine (Loc ["STRING_SEGMENT_ENEMY"] .. ":", enemy_name, 2, "white", "white")
			
			local combat_time = _detalhes.tabela_overall:GetCombatTime()
			local minutos, segundos = _math_floor (combat_time / 60), _math_floor (combat_time % 60)
			
			CoolTip:AddLine (Loc ["STRING_SEGMENTS_LIST_COMBATTIME"] .. ":", minutos.."m "..segundos.."s", 2, "white", "white") 
			
			--CoolTip:SetWallpaper (2, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsComparisonBackground]], {0.085, 166/256, 0, 1}, {.42, .4, .4, 0.9}, true)
			
			if (_detalhes.tooltip.submenu_wallpaper) then
				--CoolTip:SetWallpaper (2, [[Interface\PetPaperDollFrame\PetStatsBG-Hunter]], {321/512, 0, 0, 190/512}, {1, 1, 1, 0.9}, true)
				--CoolTip:SetWallpaper (2, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-StatsComparisonBackground]], {166/256, 1, 0, 1}, {1, 1, 1, 0.9}, true)
			else
				--> wallpaper = main window
				--CoolTip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
			end
			
			CoolTip:AddLine (Loc ["STRING_SEGMENT_START"] .. ":", _detalhes.tabela_overall.data_inicio, 2, "white", "white")
			CoolTip:AddLine (Loc ["STRING_SEGMENT_END"] .. ":", _detalhes.tabela_overall.data_fim, 2, "white", "white")
			
			-- combats added
			local combats_added = _detalhes.tabela_overall.segments_added or _detalhes.empty_table
			CoolTip:AddLine (Loc ["STRING_SEGMENTS"] .. ":", #combats_added, 2, "white", "white")
			
			if (#combats_added > 0) then
				CoolTip:AddLine ("", "", 2, "white", "white")
			end
			
			for i, segment in _ipairs (combats_added) do
				local minutos, segundos = _math_floor (segment.elapsed/60), _math_floor (segment.elapsed%60)
				
				local name = segment.name
				if (name:len() > 20) then
					name = string.sub (name, 1, #name - (#name - 20))
				end
				
				CoolTip:AddLine ("" .. name, minutos.."m "..segundos.."s", 2, "white", "white")
				
				local segmentType = segment.type
				if (segmentType == DETAILS_SEGMENTTYPE_MYTHICDUNGEON_TRASH) then
					CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], 2, 1, 12, 8, 479/512, 510/512, 24/512, 51/512, nil, nil, true)
					
				elseif (segmentType == DETAILS_SEGMENTTYPE_MYTHICDUNGEON_BOSS) then
					CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], 2, 1, 12, 12, 0.96875, 1, 0, 0.03125, party_line_color)
					
				elseif (segmentType == DETAILS_SEGMENTTYPE_RAID_TRASH or segmentType == DETAILS_SEGMENTTYPE_DUNGEON_TRASH) then
					CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], 2, 1, 10, 8, 0.02734375, 0.11328125, 0.19140625, 0.3125)
					
				elseif (segmentType == DETAILS_SEGMENTTYPE_RAID_BOSS) then
					CoolTip:AddIcon ([[Interface\AddOns\Details\images\icons]], 2, 1, 12, 12, 0.96875, 1, 0, 0.03125)
					
				end
				
				--CoolTip:AddStatusBar (100, 2, 0, 0, 0, 0.2, false, false, "Skyline")
			end
			
			--> fill � a quantidade de menu que esta sendo mostrada
			if (instancia.segmento == -1) then
				if (fill - 2 == menuIndex) then
					CoolTip:SetLastSelected ("main", fill + 1)
				elseif (fill - 1 == menuIndex) then
					CoolTip:SetLastSelected ("main", fill + 2)
				else
					CoolTip:SetLastSelected ("main", fill + 3)
				end
				menuIndex = nil
			end
			
		---------------------------------------------
		
		_detalhes:SetMenuOwner (self, instancia)
		
		CoolTip:SetOption ("TextSize", _detalhes.font_sizes.menus)
		CoolTip:SetOption ("TextFont", _detalhes.font_faces.menus)
		
		CoolTip:SetOption ("SubMenuIsTooltip", true)
		
		CoolTip:SetOption ("ButtonHeightMod", -4)
		CoolTip:SetOption ("ButtonsYMod", -10)
		CoolTip:SetOption ("YSpacingMod", 1)
		
		CoolTip:SetOption ("ButtonHeightModSub", 4)
		CoolTip:SetOption ("ButtonsYModSub", 0)
		CoolTip:SetOption ("YSpacingModSub", -4)
		
		CoolTip:SetOption ("HeighMod", 12)
		
		_detalhes:SetTooltipMinWidth()

		--CoolTip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		--CoolTip:SetBackdrop (1, menus_backdrop, nil, menus_bordercolor)
		--CoolTip:SetBackdrop (2, menus_backdrop, nil, menus_bordercolor)
		
		_detalhes:FormatCooltipBackdrop()
		
		show_anti_overlap (instancia, self, "top")
		
		CoolTip:ShowCooltip()
		
		self:SetScript ("OnUpdate", nil)
	end	
	
end

-- ~skin

function _detalhes:SetUserCustomSkinFile (file)
	if (type (file) ~= "string") then
		error ("SetUserCustomSkinFile() file must be a string.")
	end
	
	if (file:find ("\\") or file:find ("/")) then
		error ("SetUserCustomSkinFile() file must be only the file name (with out up folders) and slashes.")
	end
	
	self.skin_custom = file
	self:ChangeSkin()
end

function _detalhes:RefreshMicroDisplays()
	_detalhes.StatusBar:UpdateOptions (self)
end


--from weakauras, list of functions to block on scripts
--source https://github.com/WeakAuras/WeakAuras2/blob/520951a4b49b64cb49d88c1a8542d02bbcdbe412/WeakAuras/AuraEnvironment.lua#L66
local blockedFunctions = {
	-- Lua functions that may allow breaking out of the environment
	getfenv = true,
	getfenv = true,
	loadstring = true,
	pcall = true,
	xpcall = true,
	getglobal = true,
	
	-- blocked WoW API
	SendMail = true,
	SetTradeMoney = true,
	AddTradeMoney = true,
	PickupTradeMoney = true,
	PickupPlayerMoney = true,
	TradeFrame = true,
	MailFrame = true,
	EnumerateFrames = true,
	RunScript = true,
	AcceptTrade = true,
	SetSendMailMoney = true,
	EditMacro = true,
	SlashCmdList = true,
	DevTools_DumpCommand = true,
	hash_SlashCmdList = true,
	CreateMacro = true,
	SetBindingMacro = true,
	GuildDisband = true,
	GuildUninvite = true,
	securecall = true,
	
	--additional
	setmetatable = true,
}

--function filter
local functionFilter = setmetatable ({}, {__index = function (env, key)
	if (key == "_G") then
		return env
		
	elseif (blockedFunctions [key]) then
		return nil
		
	else	
		return _G [key]
	end
end})

function _detalhes:ChangeSkin (skin_name)

	if (not skin_name) then
		skin_name = self.skin
	end

	local this_skin = _detalhes.skins [skin_name]

	if (not this_skin) then
		skin_name = _detalhes.default_skin_to_use
		this_skin = _detalhes.skins [skin_name]
	end
	
	local just_updating = false
	if (self.skin == skin_name) then
		just_updating = true
	end

	if (not just_updating) then

		--> skin updater
		--print ("debug", self.meu_id, self.iniciada, self.baseframe, self.bgframe)
		if (self.bgframe.skin_script) then
			self.bgframe:SetScript ("OnUpdate", nil)
			self.bgframe.skin_script = false
		end
	
		--> reset all config
			self:ResetInstanceConfigKeepingValues (true)
	
		--> overwrites
			local overwrite_cprops = this_skin.instance_cprops
			if (overwrite_cprops) then
				
				local copy = table_deepcopy (overwrite_cprops)
				
				for cprop, value in _pairs (copy) do
					if (not _detalhes.instance_skin_ignored_values [cprop]) then
						if (type (value) == "table") then
							for cprop2, value2 in _pairs (value) do
								self [cprop] [cprop2] = value2
							end
						else
							self [cprop] = value
						end
					end
				end
				
			end
			
		--> reset micro frames
			_detalhes.StatusBar:Reset (self)

		--> customize micro frames
			if (this_skin.micro_frames) then
				if (this_skin.micro_frames.left) then
					_detalhes.StatusBar:SetPlugin (self, this_skin.micro_frames.left, "left")
				end
				
				if (this_skin.micro_frames.textxmod) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "textxmod", this_skin.micro_frames.textxmod)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "textxmod", this_skin.micro_frames.textxmod)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "textxmod", this_skin.micro_frames.textxmod)
				end
				if (this_skin.micro_frames.textymod) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "textymod", this_skin.micro_frames.textymod)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "textymod", this_skin.micro_frames.textymod)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "textymod", this_skin.micro_frames.textymod)
				end
				if (this_skin.micro_frames.hidden) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "hidden", this_skin.micro_frames.hidden)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "hidden", this_skin.micro_frames.hidden)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "hidden", this_skin.micro_frames.hidden)
				end
				if (this_skin.micro_frames.color) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "textcolor", this_skin.micro_frames.color)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "textcolor", this_skin.micro_frames.color)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "textcolor", this_skin.micro_frames.color)
				end
				if (this_skin.micro_frames.font) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "textface", this_skin.micro_frames.font)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "textface", this_skin.micro_frames.font)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "textface", this_skin.micro_frames.font)
				end
				if (this_skin.micro_frames.size) then
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.left, "textsize", this_skin.micro_frames.size)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.center, "textsize", this_skin.micro_frames.size)
					_detalhes.StatusBar:ApplyOptions (self.StatusBar.right, "textsize", this_skin.micro_frames.size)
				end
			end
			
	end
	
	self.skin = skin_name

	local skin_file = this_skin.file

	--> set textures
		if (self.skin_custom ~= "") then
			skin_file = "Interface\\" .. self.skin_custom
		end
	
		self.baseframe.cabecalho.ball:SetTexture (skin_file) --> bola esquerda
		self.baseframe.cabecalho.emenda:SetTexture (skin_file) --> emenda que liga a bola a textura do centro
		
		self.baseframe.cabecalho.ball_r:SetTexture (skin_file) --> bola direita onde fica o bot�o de fechar
		self.baseframe.cabecalho.top_bg:SetTexture (skin_file) --> top background
		
		self.baseframe.barra_esquerda:SetTexture (skin_file) --> barra lateral
		self.baseframe.barra_direita:SetTexture (skin_file) --> barra lateral
		self.baseframe.barra_fundo:SetTexture (skin_file) --> barra inferior
		
		self.baseframe.scroll_up:SetTexture (skin_file) --> scrollbar parte de cima
		self.baseframe.scroll_down:SetTexture (skin_file) --> scrollbar parte de baixo
		self.baseframe.scroll_middle:SetTexture (skin_file) --> scrollbar parte do meio

		self.baseframe.rodape.top_bg:SetTexture (skin_file) --> rodape top background
		self.baseframe.rodape.esquerdo:SetTexture (skin_file) --> rodape esquerdo
		self.baseframe.rodape.direita:SetTexture (skin_file) --> rodape direito
		self.baseframe.rodape.esquerdo_nostatusbar:SetTexture (skin_file) --> rodape direito
		self.baseframe.rodape.direita_nostatusbar:SetTexture (skin_file) --> rodape direito
		
		self.baseframe.button_stretch.texture:SetTexture (skin_file) --> bot�o de esticar a janela
		
		self.baseframe.resize_direita.texture:SetTexture (skin_file) --> bot�o de redimencionar da direita
		self.baseframe.resize_esquerda.texture:SetTexture (skin_file) --> bot�o de redimencionar da esquerda
		
		self.break_snap_button:SetNormalTexture (skin_file) --> cadeado
		self.break_snap_button:SetDisabledTexture (skin_file)
		self.break_snap_button:SetHighlightTexture (skin_file, "ADD")
		self.break_snap_button:SetPushedTexture (skin_file)

	--> update toolbar icons
	local toolbar_buttons = {}
	
	do
		local toolbar_icon_file = self.toolbar_icon_file
		if (not toolbar_icon_file) then
			toolbar_icon_file = [[Interface\AddOns\Details\images\toolbar_icons]]
		end

		toolbar_buttons [1] = self.baseframe.cabecalho.modo_selecao
		toolbar_buttons [2] = self.baseframe.cabecalho.segmento
		toolbar_buttons [3] = self.baseframe.cabecalho.atributo
		toolbar_buttons [4] = self.baseframe.cabecalho.report
		toolbar_buttons [5] = self.baseframe.cabecalho.reset
		toolbar_buttons [6] = self.baseframe.cabecalho.fechar
		
		for i = 1, #toolbar_buttons do
			local button = toolbar_buttons [i]
			button:SetNormalTexture (toolbar_icon_file)
			button:SetHighlightTexture (toolbar_icon_file)
			button:SetPushedTexture (toolbar_icon_file)
		end
	end
		
----------> icon anchor and size
	
	if (self.modo == 1 or self.modo == 4 or self.atributo == 5) then -- alone e raid
		local icon_anchor = this_skin.icon_anchor_plugins
		self.baseframe.cabecalho.atributo_icon:SetPoint ("topright", self.baseframe.cabecalho.ball_point, "topright", icon_anchor[1], icon_anchor[2])
		if (self.modo == 1) then
			if (_detalhes.SoloTables.Plugins [1] and _detalhes.SoloTables.Mode) then
				local plugin_index = _detalhes.SoloTables.Mode
				if (plugin_index > 0 and _detalhes.SoloTables.Menu [plugin_index]) then
					self:ChangeIcon (_detalhes.SoloTables.Menu [plugin_index] [2])
				end
			end

		elseif (self.modo == 4) then
			--if (_detalhes.RaidTables.Plugins [1] and _detalhes.RaidTables.Mode) then
			--	local plugin_index = _detalhes.RaidTables.Mode
			--	if (plugin_index and _detalhes.RaidTables.Menu [plugin_index]) then
					--self:ChangeIcon (_detalhes.RaidTables.Menu [plugin_index] [2])
			--	end
			--end
		end
	else
		local icon_anchor = this_skin.icon_anchor_main --> ancora do icone do canto direito superior
		self.baseframe.cabecalho.atributo_icon:SetPoint ("topright", self.baseframe.cabecalho.ball_point, "topright", icon_anchor[1], icon_anchor[2])
		self:ChangeIcon()
	end
	
----------> lock alpha head	
	
	if (not this_skin.can_change_alpha_head) then
		self.baseframe.cabecalho.ball:SetAlpha (100)
	else
		self.baseframe.cabecalho.ball:SetAlpha (self.color[4])
	end
	
----------> update abbreviation function on the class files
	
	_detalhes.atributo_damage:UpdateSelectedToKFunction()
	_detalhes.atributo_heal:UpdateSelectedToKFunction()
	_detalhes.atributo_energy:UpdateSelectedToKFunction()
	_detalhes.atributo_misc:UpdateSelectedToKFunction()
	_detalhes.atributo_custom:UpdateSelectedToKFunction()
	
----------> call widgets handlers	
		self:SetBarSettings (self.row_info.height)
		self:SetBarBackdropSettings()
		self:SetBarSpecIconSettings()
		self:SetBarRightTextSettings()
	
	--> update toolbar
		self:ToolbarSide()
	
	--> update stretch button
		self:StretchButtonAnchor()
	
	--> update side bars
		if (self.show_sidebars) then
			self:ShowSideBars()
		else
			self:HideSideBars()
		end

	--> refresh the side of the micro displays and its lock state
		self:MicroDisplaysSide()
		self:MicroDisplaysLock()
		self:RefreshMicroDisplays()
		
	--> update statusbar
		if (self.show_statusbar) then
			self:ShowStatusBar()
		else
			self:HideStatusBar()
		end

	--> update wallpaper
		if (self.wallpaper.enabled) then
			self:InstanceWallpaper (true)
		else
			self:InstanceWallpaper (false)
		end
	
	--> update instance color
		self:InstanceColor()
		self:SetBackgroundColor()
		self:SetBackgroundAlpha()
		self:SetAutoHideMenu()
		self:SetBackdropTexture()

	--> refresh all bars
		self:InstanceRefreshRows()

	--> update menu saturation
		self:DesaturateMenu()
	
	--> update statusbar color
		self:StatusBarColor()
	
	--> update attribute string
		self:AttributeMenu()
	
	--> update top menus
		self:LeftMenuAnchorSide()
		
	--> update window strata level
		self:SetFrameStrata()
	
	--> update the combat alphas
		self:SetCombatAlpha (nil, nil, true)
		
	--> update icons
		_detalhes.ToolBar:ReorganizeIcons (true) --call self:SetMenuAlpha()
		
	--> refresh options panel if opened
		if (_G.DetailsOptionsWindow and _G.DetailsOptionsWindow:IsShown() and not _G.DetailsOptionsWindow.IsLoading) then
			_detalhes:OpenOptionsWindow (self)
		end

	--> auto interact
		if (self.menu_alpha.enabled) then
			self:SetMenuAlpha (nil, nil, nil, nil, self.is_interacting)
		end
		
	--> set the scale
		self:SetWindowScale()
	
	--> refresh lock buttons
		self:RefreshLockedState()
	
	--> clear any control sscript running in this instance
	self.bgframe:SetScript ("OnUpdate", nil)
	self.bgframe.skin_script = nil
	
	--> check if the skin has control scripts to run
	if (not just_updating or _detalhes.initializing) then
		local callbackFunc = this_skin.callback
		if (callbackFunc) then
			setfenv (callbackFunc, functionFilter)
			local okey, result = pcall (callbackFunc, this_skin, self, just_updating)
			if (not okey) then
				_detalhes:Msg ("|cFFFF9900error on skin callback function|r:", result)
			end
		end
		
		if (this_skin.control_script) then
			local onStartScript = this_skin.control_script_on_start
			if (onStartScript) then
				setfenv (onStartScript, functionFilter)
				local okey, result = pcall (onStartScript, this_skin, self)
				if (not okey) then
					_detalhes:Msg ("|cFFFF9900error on skin control on start function|r:", result)
				end
			end
			
			local controlFunc = this_skin.control_script
			setfenv (controlFunc, functionFilter)
			self.bgframe:SetScript ("OnUpdate", controlFunc)
			self.bgframe.skin_script = true
			self.bgframe.skin = this_skin
		end
	end
	
	self:UpdateClickThrough()
end

--update the window click through state
local updateClickThroughListener = _detalhes:CreateEventListener()
function updateClickThroughListener:EnterCombat()
	_detalhes:InstanceCall (function (instance)
		C_Timer.After (1.5, function()
			instance:UpdateClickThrough()
		end)
	end)
end

function updateClickThroughListener:LeaveCombat()
	_detalhes:InstanceCall (function (instance)
		C_Timer.After (1.5, function()
			instance:UpdateClickThrough()
		end)
	end)
end

updateClickThroughListener:RegisterEvent ("COMBAT_PLAYER_ENTER", "EnterCombat")
updateClickThroughListener:RegisterEvent ("COMBAT_PLAYER_LEAVE", "EnterCombat")

function _detalhes:UpdateClickThroughSettings (inCombat, window, bars, toolbaricons)
	if (inCombat ~= nil) then
		self.clickthrough_incombatonly = inCombat
	end
	
	if (window ~= nil) then
		self.clickthrough_window = window
	end
	
	if (bars ~= nil) then
		self.clickthrough_rows = bars
	end
	
	if (toolbaricons ~= nil) then
		self.clickthrough_toolbaricons = toolbaricons
	end
	
	self:UpdateClickThrough()
end

function _detalhes:UpdateClickThrough()
	
	local barsClickThrough = self.clickthrough_rows
	local windowClickThrough = self.clickthrough_window
	local onlyInCombat = self.clickthrough_incombatonly
	local toolbarIcons = not self.clickthrough_toolbaricons

	if (onlyInCombat) then

		if (InCombatLockdown()) then
			--player bars
			if (barsClickThrough) then
				for barIndex, barObject in _ipairs (self.barras) do 
					barObject:EnableMouse (false)
				end
			else
				for barIndex, barObject in _ipairs (self.barras) do 
					barObject:EnableMouse (true)
				end
			end
			
			--window frames
			if (windowClickThrough) then
				self.baseframe:EnableMouse (false)
				self.bgframe:EnableMouse (false)
				self.rowframe:EnableMouse (false)
				self.floatingframe:EnableMouse (false)
				self.windowSwitchButton:EnableMouse (false)
				self.windowBackgroundDisplay:EnableMouse (false)
				self.baseframe.UPFrame:EnableMouse (false)

			else
				self.baseframe:EnableMouse (true)
				self.bgframe:EnableMouse (true)
				self.rowframe:EnableMouse (true)
				self.floatingframe:EnableMouse (true)
				self.windowSwitchButton:EnableMouse (true)
				self.windowBackgroundDisplay:EnableMouse (true)
				self.baseframe.UPFrame:EnableMouse (true)
			end
			
			--titlebar icons
			local toolbar_buttons = {}
			toolbar_buttons [1] = self.baseframe.cabecalho.modo_selecao
			toolbar_buttons [2] = self.baseframe.cabecalho.segmento
			toolbar_buttons [3] = self.baseframe.cabecalho.atributo
			toolbar_buttons [4] = self.baseframe.cabecalho.report
			toolbar_buttons [5] = self.baseframe.cabecalho.reset
			toolbar_buttons [6] = self.baseframe.cabecalho.fechar
			
			for i, button in ipairs (toolbar_buttons) do
				button:EnableMouse (toolbar_buttons)
			end
			
		else
			--player bars
			for barIndex, barObject in _ipairs (self.barras) do
				barObject:EnableMouse (true)
			end
			
			--window frames
			self.baseframe:EnableMouse (true)
			self.bgframe:EnableMouse (true)
			self.rowframe:EnableMouse (true)
			self.floatingframe:EnableMouse (true)
			self.windowSwitchButton:EnableMouse (true)
			self.windowBackgroundDisplay:EnableMouse (true)
			self.baseframe.UPFrame:EnableMouse (true)
			
			--titlebar icons, forcing true because the player isn't in combat and the inCombat setting is enabled
			local toolbar_buttons = {}
			toolbar_buttons [1] = self.baseframe.cabecalho.modo_selecao
			toolbar_buttons [2] = self.baseframe.cabecalho.segmento
			toolbar_buttons [3] = self.baseframe.cabecalho.atributo
			toolbar_buttons [4] = self.baseframe.cabecalho.report
			toolbar_buttons [5] = self.baseframe.cabecalho.reset
			toolbar_buttons [6] = self.baseframe.cabecalho.fechar
			
			for i, button in ipairs (toolbar_buttons) do
				button:EnableMouse (true)
			end
		end
	else

		--player bars
		if (barsClickThrough) then
			for barIndex, barObject in _ipairs (self.barras) do 
				barObject:EnableMouse (false)
			end
		else
			for barIndex, barObject in _ipairs (self.barras) do 
				barObject:EnableMouse (true)
			end
		end
		
		--window frame
		if (windowClickThrough) then
			self.baseframe:EnableMouse (false)
			self.bgframe:EnableMouse (false)
			self.rowframe:EnableMouse (false)
			self.floatingframe:EnableMouse (false)
			self.windowSwitchButton:EnableMouse (false)
			self.windowBackgroundDisplay:EnableMouse (false)
			self.baseframe.UPFrame:EnableMouse (false)

		else
			self.baseframe:EnableMouse (true)
			self.bgframe:EnableMouse (true)
			self.rowframe:EnableMouse (true)
			self.floatingframe:EnableMouse (true)
			self.windowSwitchButton:EnableMouse (true)
			self.windowBackgroundDisplay:EnableMouse (true)
			self.baseframe.UPFrame:EnableMouse (true)
		end
		
		--titlebar icons
		local toolbar_buttons = {}
		toolbar_buttons [1] = self.baseframe.cabecalho.modo_selecao
		toolbar_buttons [2] = self.baseframe.cabecalho.segmento
		toolbar_buttons [3] = self.baseframe.cabecalho.atributo
		toolbar_buttons [4] = self.baseframe.cabecalho.report
		toolbar_buttons [5] = self.baseframe.cabecalho.reset
		toolbar_buttons [6] = self.baseframe.cabecalho.fechar
		
		for i, button in ipairs (toolbar_buttons) do
			button:EnableMouse (toolbarIcons)
		end
	end
end

--endd

function _detalhes:DelayedCheckCombatAlpha (instance)
	if (UnitAffectingCombat ("player") or InCombatLockdown()) then
		instance:SetWindowAlphaForCombat (true, true) --> hida a janela
	else
		instance:SetWindowAlphaForCombat (false) --> deshida a janela
	end
end

function _detalhes:DelayedCheckOutOfCombatAlpha (instance)
	if (UnitAffectingCombat ("player") or InCombatLockdown()) then
		instance:SetWindowAlphaForCombat (false) --> deshida a janela
	else
		instance:SetWindowAlphaForCombat (true, true) --> hida a janela
	end
end

function _detalhes:DelayedCheckOutOfCombatAndGroupAlpha (instance)
	if ((_detalhes.zone_type == "raid" or _detalhes.zone_type == "party") and IsInInstance()) then
		if (UnitAffectingCombat ("player") or InCombatLockdown()) then
			instance:SetWindowAlphaForCombat (true, true) --> hida a janela
		else
			instance:SetWindowAlphaForCombat (false) --> deshida a janela
		end
	else
		instance:SetWindowAlphaForCombat (true, true) --> hida a janela
	end
end

function _detalhes:SetCombatAlpha (modify_type, alpha_amount, interacting)

	if (interacting) then
		if (self.hide_in_combat_type == 1) then --None
			return
			
		elseif (self.hide_in_combat_type == 2) then --While In Combat
			_detalhes:ScheduleTimer ("DelayedCheckCombatAlpha", 0.3, self)
			
		elseif (self.hide_in_combat_type == 3) then --"While Out of Combat"
			_detalhes:ScheduleTimer ("DelayedCheckOutOfCombatAlpha", 0.3, self)
			
		elseif (self.hide_in_combat_type == 4) then --"While Out of a Group"
			if (_detalhes.in_group) then
				self:SetWindowAlphaForCombat (false) --> deshida a janela
			else
				self:SetWindowAlphaForCombat (true, true) --> hida a janela
			end
		
		elseif (self.hide_in_combat_type == 5) then --"While Not Inside Instance"
			local isInInstance = IsInInstance()
			if (isInInstance or _detalhes.zone_type == "raid" or _detalhes.zone_type == "party") then
				self:SetWindowAlphaForCombat (false) --> deshida a janela
			else
				self:SetWindowAlphaForCombat (true, true) --> hida a janela
			end
		
		elseif (self.hide_in_combat_type == 6) then --"While Inside Instance"
			local isInInstance = IsInInstance()
			if (isInInstance or _detalhes.zone_type == "raid" or _detalhes.zone_type == "party") then
				self:SetWindowAlphaForCombat (true, true) --> hida a janela
			else
				self:SetWindowAlphaForCombat (false) --> deshida a janela
			end
			
		elseif (self.hide_in_combat_type == 7) then --"Raid Debug" = Out of Combat and Inside Raid or Dungeon
			_detalhes:ScheduleTimer ("DelayedCheckOutOfCombatAndGroupAlpha", 0.3, self)
		
		elseif (self.hide_in_combat_type == 8) then --"In Battlegrounds"
			local isInInstance = IsInInstance()
			if (isInInstance and _detalhes.zone_type == "pvp") then
				self:SetWindowAlphaForCombat (true, true) --> hida a janela
			else
				self:SetWindowAlphaForCombat (false) --> deshida a janela
			end
		end
		
		return
	end

	if (not modify_type) then
		modify_type = self.hide_in_combat_type
	else
		if (modify_type == 1) then --> changed to none
			self:SetWindowAlphaForCombat (false)
		end
	end
	
	if (not alpha_amount) then
		alpha_amount = self.hide_in_combat_alpha
	end
	
	self.hide_in_combat_type = modify_type
	self.hide_in_combat_alpha = alpha_amount
	
	self:SetCombatAlpha (nil, nil, true)
	
end

function _detalhes:SetFrameStrata (strata)
	
	if (not strata) then
		strata = self.strata
	end
	
	self.strata = strata
	
	self.rowframe:SetFrameStrata (strata)
	self.baseframe:SetFrameStrata (strata)
	
	if (strata == "BACKGROUND") then
		self.break_snap_button:SetFrameStrata ("LOW")
		self.baseframe.resize_esquerda:SetFrameStrata ("LOW")
		self.baseframe.resize_direita:SetFrameStrata ("LOW")
		self.baseframe.lock_button:SetFrameStrata ("LOW")
		
	elseif (strata == "LOW") then
		self.break_snap_button:SetFrameStrata ("MEDIUM")
		self.baseframe.resize_esquerda:SetFrameStrata ("MEDIUM")
		self.baseframe.resize_direita:SetFrameStrata ("MEDIUM")
		self.baseframe.lock_button:SetFrameStrata ("MEDIUM")
		
	elseif (strata == "MEDIUM") then
		self.break_snap_button:SetFrameStrata ("HIGH")
		self.baseframe.resize_esquerda:SetFrameStrata ("HIGH")
		self.baseframe.resize_direita:SetFrameStrata ("HIGH")
		self.baseframe.lock_button:SetFrameStrata ("HIGH")
		
	elseif (strata == "HIGH") then
		self.break_snap_button:SetFrameStrata ("DIALOG")
		self.baseframe.resize_esquerda:SetFrameStrata ("DIALOG")
		self.baseframe.resize_direita:SetFrameStrata ("DIALOG")
		self.baseframe.lock_button:SetFrameStrata ("DIALOG")
		
	elseif (strata == "DIALOG") then
		self.break_snap_button:SetFrameStrata ("FULLSCREEN")
		self.baseframe.resize_esquerda:SetFrameStrata ("FULLSCREEN")
		self.baseframe.resize_direita:SetFrameStrata ("FULLSCREEN")
		self.baseframe.lock_button:SetFrameStrata ("FULLSCREEN")
		
	end
	
	self:StretchButtonAlwaysOnTop()
	
end

function _detalhes:LeftMenuAnchorSide (side)
	
	if (not side) then
		side = self.menu_anchor.side
	end
	
	self.menu_anchor.side = side
	
	return self:MenuAnchor()
	
end

-- ~attributemenu (text with attribute name)
function _detalhes:RefreshAttributeTextSize()
	if (self.attribute_text.enabled and self.total_buttons_shown and self.baseframe and self.menu_attribute_string) then
	
		local window_width = self:GetSize()
	
		if (self.auto_hide_menu.left and not self.is_interacting) then
			self.menu_attribute_string:SetWidth (window_width)
			self.menu_attribute_string:SetHeight (self.attribute_text.text_size + 2)
			return
		end
		
		local buttons_shown = self.total_buttons_shown
		local buttons_width, buttons_spacement = self.menu_icons_size * 16, self.menu_icons.space
		
		local width_by_buttons = (buttons_shown * buttons_width) + (buttons_spacement * (buttons_shown - 1))
		
		local text_size = window_width - width_by_buttons - 6
		self.menu_attribute_string:SetWidth (text_size)
		self.menu_attribute_string:SetHeight (self.attribute_text.text_size + 2)
	end
end

-- ~encounter ~timer
function _detalhes:CheckForTextTimeCounter (combat_start)
	if (combat_start) then
		if (_detalhes.tabela_vigente.is_boss) then
			local lower = _detalhes:GetLowerInstanceNumber()
			if (lower) then
				local instance = _detalhes:GetInstance (lower)
				if (instance.baseframe and instance:IsEnabled()) then
					if (instance.attribute_text.show_timer [1]) then
						if (_detalhes.instance_title_text_timer [instance.meu_id]) then
							_detalhes:CancelTimer (_detalhes.instance_title_text_timer [instance.meu_id])
						end
						_detalhes.instance_title_text_timer [instance.meu_id] = _detalhes:ScheduleRepeatingTimer ("TitleTextTickTimer", 1, instance)
					end
				end
			else
				return
			end
		else
			if (_detalhes.in_combat and _detalhes.zone_type == "raid") then
				_detalhes:ScheduleTimer ("CheckForTextTimeCounter", 3, true)
			end
		end
	else
		for _, instance in ipairs (_detalhes.tabela_instancias) do
			if (_detalhes.instance_title_text_timer [instance.meu_id] and instance.baseframe and instance:IsEnabled() and instance.menu_attribute_string) then
				_detalhes:CancelTimer (_detalhes.instance_title_text_timer [instance.meu_id])
				local current_text = instance.menu_attribute_string:GetText()
				current_text = current_text:gsub ("%[.*%] ", "")
				instance.menu_attribute_string:SetText (current_text)
			end
		end
	end
end

local format_timer = function (t)
	local m, s = _math_floor (t/60), _math_floor (t%60)
	if (m < 1) then
		m = "00"
	elseif (m < 10) then
		m = "0" .. m
	end
	if (s < 10) then
		s = "0" .. s
	end
	return "[" .. m .. ":" .. s .. "]"
end

function _detalhes:TitleTextTickTimer (instance)
	if (instance.attribute_text.enabled) then
		local current_text = instance.menu_attribute_string:GetText()
		if (not current_text:find ("%[.*%]")) then
			instance.menu_attribute_string:SetText ("[00:01] " .. current_text)
		else
			local timer = format_timer (_detalhes.tabela_vigente:GetCombatTime())
			current_text = current_text:gsub ("%[.*%]", timer)
			instance.menu_attribute_string:SetText (current_text)
		end
	end
end

function _detalhes:SetTitleBarText (text)
	if (self.attribute_text.enabled and self.menu_attribute_string) then
		self.menu_attribute_string:SetText (text)
	end
end

-- ~titletext
function _detalhes:AttributeMenu (enabled, pos_x, pos_y, font, size, color, side, shadow, timer_encounter, timer_bg, timer_arena)

	if (type (enabled) ~= "boolean") then
		enabled = self.attribute_text.enabled
	end
	
	if (not pos_x) then
		pos_x = self.attribute_text.anchor [1]
	end
	if (not pos_y) then
		pos_y = self.attribute_text.anchor [2]
	end
	
	if (not font) then
		font = self.attribute_text.text_face
	end
	
	if (not size) then
		size = self.attribute_text.text_size
	end
	
	if (not color) then
		color = self.attribute_text.text_color
	end
	
	if (not side) then
		side = self.attribute_text.side
	end
	
	if (type (shadow) ~= "boolean") then
		shadow = self.attribute_text.shadow
	end
	
	if (type (timer_encounter) ~= "boolean") then
		timer_encounter = self.attribute_text.show_timer [1]
	end
	if (type (timer_bg) ~= "boolean") then
		timer_bg = self.attribute_text.show_timer [2]
	end
	if (type (timer_arena) ~= "boolean") then
		timer_arena = self.attribute_text.show_timer [3]
	end
	
	self.attribute_text.enabled = enabled
	self.attribute_text.anchor [1] = pos_x
	self.attribute_text.anchor [2] = pos_y
	self.attribute_text.text_face = font
	self.attribute_text.text_size = size
	self.attribute_text.text_color = color
	self.attribute_text.side = side
	self.attribute_text.shadow = shadow
	self.attribute_text.show_timer [1] = timer_encounter
	self.attribute_text.show_timer [2] = timer_bg
	self.attribute_text.show_timer [3] = timer_arena
	
	--> enabled
	if (not enabled and self.menu_attribute_string) then
		return self.menu_attribute_string:Hide()
	elseif (not enabled) then
		return
	end
	
	--> protection against failed clean up framework table
	if (self.menu_attribute_string and not getmetatable (self.menu_attribute_string)) then
		self.menu_attribute_string = nil
	end
	
	if (not self.menu_attribute_string) then 

		local label = gump:NewLabel (self.floatingframe, nil, "DetailsAttributeStringInstance" .. self.meu_id, nil, "", "GameFontHighlightSmall")
		self.menu_attribute_string = label
		self.menu_attribute_string.text = _detalhes:GetSubAttributeName (self.atributo, self.sub_atributo)
		self.menu_attribute_string.owner_instance = self
		
		self.menu_attribute_string.Enabled = true
		self.menu_attribute_string.__enabled = true
		
		function self.menu_attribute_string:OnEvent (instance, attribute, subAttribute)
			if (instance == label.owner_instance) then
				local sName = instance:GetInstanceAttributeText()
				label.text = sName
			end
		end
		
		_detalhes:RegisterEvent (self.menu_attribute_string, "DETAILS_INSTANCE_CHANGEATTRIBUTE", self.menu_attribute_string.OnEvent)
		_detalhes:RegisterEvent (self.menu_attribute_string, "DETAILS_INSTANCE_CHANGEMODE", self.menu_attribute_string.OnEvent)

	end

	self.menu_attribute_string:Show()
	
	--> anchor
	if (side == 1) then --> a string esta no lado de cima
		if (self.toolbar_side == 1) then -- a toolbar esta em cima
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint ("bottomleft", self.baseframe.cabecalho.ball, "bottomright", self.attribute_text.anchor [1], self.attribute_text.anchor [2])
			
		elseif (self.toolbar_side == 2) then --a toolbar esta em baixo
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint ("bottomleft", self.baseframe, "topleft", self.attribute_text.anchor [1] + 21, self.attribute_text.anchor [2])

		end
		
	elseif (side == 2) then --> a string esta no lado de baixo
		if (self.toolbar_side == 1) then --toolbar esta em cima
			self.menu_attribute_string:ClearAllPoints()
			self.menu_attribute_string:SetPoint ("left", self.baseframe.rodape.StatusBarLeftAnchor, "left", self.attribute_text.anchor [1] + 16, self.attribute_text.anchor [2] - 6)

		elseif (self.toolbar_side == 2) then --toolbar esta em baixo
			self.menu_attribute_string:SetPoint ("bottomleft", self.baseframe.cabecalho.ball, "topright", self.attribute_text.anchor [1], self.attribute_text.anchor [2] - 19)

		end
	end
	
	--font face
	local fontPath = SharedMedia:Fetch ("font", font)
	_detalhes:SetFontFace (self.menu_attribute_string, fontPath)
	
	--font size
	_detalhes:SetFontSize (self.menu_attribute_string, size)
	
	--color
	_detalhes:SetFontColor (self.menu_attribute_string, color)
	
	--shadow
	_detalhes:SetFontOutline (self.menu_attribute_string, shadow)

	--refresh size
	self:RefreshAttributeTextSize()
end

-- ~backdrop
function _detalhes:SetBackdropTexture (texturename)
	
	if (not texturename) then
		texturename = self.backdrop_texture
	end
	
	self.backdrop_texture = texturename
	
	local texture_path = SharedMedia:Fetch ("background", texturename)
	
	self.baseframe:SetBackdrop ({
		bgFile = texture_path, tile = true, tileSize = 128,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
	)
	self.bgdisplay:SetBackdrop ({
		bgFile = texture_path, tile = true, tileSize = 128,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
	)
	
	self:SetBackgroundAlpha (self.bg_alpha)
	
end

-- ~alpha (transparency of buttons on the toolbar) ~autohide �utohide ~menuauto
function _detalhes:SetAutoHideMenu (left, right, interacting)

	--30/07/2018: the separation by left and right menu icons doesn't exists for years, but it was still active in the code making
	--the toolbar icons show on initialization even when the options to auto hide them enabled.
	--the code to set the alpha was already updated to only one anhor (left) but this function was still calling to update the right anchor (deprecated)

	if (interacting) then
		if (self.is_interacting) then
			if (self.auto_hide_menu.left) then
				local r, g, b = unpack (self.color_buttons)
				self:InstanceButtonsColors (r, g, b, 1, true, true) --no save, only left
				
				if (self.baseframe.cabecalho.PluginIconsSeparator) then
					self.baseframe.cabecalho.PluginIconsSeparator:Show()
				end
			end
--			if (self.auto_hide_menu.right) then
--				local r, g, b = unpack (self.color_buttons)
--				self:InstanceButtonsColors (r, g, b, 1, true, nil, true) --no save, only right
--			end
		else
			if (self.auto_hide_menu.left) then
				local r, g, b = unpack (self.color_buttons)
				self:InstanceButtonsColors (r, g, b, 0, true, true) --no save, only left
				
				if (self.baseframe.cabecalho.PluginIconsSeparator) then
					self.baseframe.cabecalho.PluginIconsSeparator:Hide()
				end
			end
--			if (self.auto_hide_menu.right) then
--				local r, g, b = unpack (self.color_buttons)
--				self:InstanceButtonsColors (r, g, b, 0, true, nil, true) --no save, only right
--			end
		end
		return
	end

	if (left == nil) then
		left = self.auto_hide_menu.left
	end
	if (right == nil) then
		right = self.auto_hide_menu.right
	end

	self.auto_hide_menu.left = left
	self.auto_hide_menu.right = right
	
	local r, g, b = unpack (self.color_buttons)

	if (not left) then
		--auto hide is off
		self:InstanceButtonsColors (r, g, b, 1, true, true) --no save, only left
		
		if (self.baseframe.cabecalho.PluginIconsSeparator) then
			self.baseframe.cabecalho.PluginIconsSeparator:Show()
		end
	else
		if (self.is_interacting) then
			self:InstanceButtonsColors (r, g, b, 1, true, true) --no save, only left
			
			if (self.baseframe.cabecalho.PluginIconsSeparator) then
				self.baseframe.cabecalho.PluginIconsSeparator:Show()
			end
		else
			self:InstanceButtonsColors (0, 0, 0, 0, true, true) --no save, only left
			
			if (self.baseframe.cabecalho.PluginIconsSeparator) then
				self.baseframe.cabecalho.PluginIconsSeparator:Hide()
			end
		end
	end

--[=[	
	if (not right) then
		--auto hide is off
		self:InstanceButtonsColors (r, g, b, 1, true, nil, true) --no save, only right
	else
		if (self.is_interacting) then
			self:InstanceButtonsColors (r, g, b, 1, true, nil, true) --no save, only right
		else
			self:InstanceButtonsColors (0, 0, 0, 0, true, nil, true) --no save, only right
		end
	end
--]=]

	self:RefreshAttributeTextSize()
	--auto_hide_menu = {left = false, right = false},

end

-- transparency for toolbar, borders and statusbar
function _detalhes:SetMenuAlpha (enabled, onenter, onleave, ignorebars, interacting)

	if (interacting) then --> called from a onenter or onleave script
		if (self.menu_alpha.enabled) then
			if (self.is_interacting) then
				return self:SetWindowAlphaForInteract (self.menu_alpha.onenter)
			else
				return self:SetWindowAlphaForInteract (self.menu_alpha.onleave)
			end
		end
		return
	end

	--ignorebars
	
	if (enabled == nil) then
		enabled = self.menu_alpha.enabled
	end
	if (not onenter) then
		onenter = self.menu_alpha.onenter
	end
	if (not onleave) then
		onleave = self.menu_alpha.onleave
	end
	if (ignorebars == nil) then
		ignorebars = self.menu_alpha.ignorebars
	end

	self.menu_alpha.enabled = enabled
	self.menu_alpha.onenter = onenter
	self.menu_alpha.onleave = onleave
	self.menu_alpha.ignorebars = ignorebars
	
	if (not enabled) then
		self.baseframe:SetAlpha (1)
		self.rowframe:SetAlpha (1)
		self:InstanceAlpha (self.color[4])
		self:SetIconAlpha (1, nil, true)
		return self:InstanceColor (unpack (self.color))
		--return self:SetWindowAlphaForInteract (self.color [4])
	else
		local r, g, b = unpack (self.color)
		self:InstanceColor (r, g, b, 1)
		r, g, b = unpack (self.statusbar_info.overlay)
		self:StatusBarColor (r, g, b, 1)
	end

	if (self.is_interacting) then
		return self:SetWindowAlphaForInteract (onenter) --> set alpha
	else
		return self:SetWindowAlphaForInteract (onleave) --> set alpha
	end
	
end

function _detalhes:GetInstanceCurrentAlpha()
	if (self.menu_alpha.enabled) then
		if (self:IsInteracting()) then
			return self.menu_alpha.onenter
		else
			return self.menu_alpha.onleave
		end
	else
		return self.color [4]
	end
end

function _detalhes:GetInstanceIconsCurrentAlpha()
	if (self.menu_alpha.enabled and self.menu_alpha.iconstoo) then
		if (self:IsInteracting()) then
			return self.menu_alpha.onenter
		else
			return self.menu_alpha.onleave
		end
	else
		return 1
	end
end

function _detalhes:MicroDisplaysLock (lockstate)
	if (lockstate == nil) then
		lockstate = self.micro_displays_locked
	end
	self.micro_displays_locked = lockstate
	
	if (lockstate) then --> is locked
		_detalhes.StatusBar:LockDisplays (self, true)
	else
		_detalhes.StatusBar:LockDisplays (self, false)
	end
end

function _detalhes:MicroDisplaysSide (side, fromuser)
	if (not side) then
		side = self.micro_displays_side
	end
	
	self.micro_displays_side = side
	
	_detalhes.StatusBar:ReloadAnchors (self)
	
	if (self.micro_displays_side == 2 and not self.show_statusbar) then --> bottom side
		_detalhes.StatusBar:Hide (self)
		if (fromuser) then
			_detalhes:Msg (Loc ["STRING_OPTIONS_MICRODISPLAYWARNING"])
		end
	elseif (self.micro_displays_side == 2) then
		_detalhes.StatusBar:Show (self)
	elseif (self.micro_displays_side == 1) then
		_detalhes.StatusBar:Show (self)
	end
	
end

function _detalhes:IsGroupedWith (instance)
	local id = instance:GetId()
	for side, instanceId in _pairs (self.snap) do
		if (instanceId == id) then
			return true
		end
	end
	return false
end

function _detalhes:GetInstanceGroup (instance_id)

	local instance = self
	
	if (instance_id) then
		instance = _detalhes:GetInstance (instance_id)
		if (not instance or not instance:IsEnabled()) then
			return
		end
	end
	
	local current_group = {instance}
	
	for side, insId in _pairs (instance.snap) do
		if (insId < instance:GetId()) then
			local last_id = instance:GetId()
			for i = insId, 1, -1 do
				local this_instance = _detalhes:GetInstance (i)
				local got = false
				if (this_instance and this_instance:IsEnabled()) then
					for side, id in _pairs (this_instance.snap) do
						if (id == last_id) then
							tinsert (current_group, this_instance)
							got = true
							last_id = i
						end
					end
				end
				if (not got) then
					break
				end
			end
		else
			local last_id = instance:GetId()
			for i = insId, _detalhes.instances_amount do
				local this_instance = _detalhes:GetInstance (i)
				local got = false
				if (this_instance and this_instance:IsEnabled()) then
					for side, id in _pairs (this_instance.snap) do
						if (id == last_id) then
							tinsert (current_group, this_instance)
							got = true
							last_id = i
						end
					end
				end
				if (not got) then
					break
				end
			end
		end
	end
	
	return current_group
end

function _detalhes:SetWindowScale (scale, from_options)
	if (not scale) then
		scale = self.window_scale
	end

	if (from_options) then
		local group = self:GetInstanceGroup()
		
		for _, instance in _ipairs (group) do
			instance.baseframe:SetScale (scale)
			instance.rowframe:SetScale (scale)
			instance.window_scale = scale
		end
		
		for _, instance in _ipairs (group) do
			_detalhes.move_janela_func (instance.baseframe, true, instance)
			_detalhes.move_janela_func (instance.baseframe, false, instance)
		end
		
		for _, instance in _ipairs (group) do
			instance:SaveMainWindowPosition()
		end
		
	else
		self.window_scale = scale
		self.baseframe:SetScale (scale)
		self.rowframe:SetScale (scale)
		--self:SaveMainWindowPosition() -- skin was replacing window_scale
	end
end

function _detalhes:ToolbarSide (side, only_update_anchors)
	
	if (not side) then
		side = self.toolbar_side
	end
	
	self.toolbar_side = side
	
	local skin = _detalhes.skins [self.skin]
	
	if (side == 1) then --> top
	
		local anchor_mod = not self.show_sidebars and skin.instance_cprops.show_sidebars_need_resize_by or 0
	
		--> icon (ball) point
		self.baseframe.cabecalho.ball_point:ClearAllPoints()

		local x, y = unpack (skin.icon_point_anchor)
		x = x + (anchor_mod)
		self.baseframe.cabecalho.ball_point:SetPoint ("bottomleft", self.baseframe, "topleft", x, y)
		
		--> ball
		if (self.hide_icon) then
			self.baseframe.cabecalho.ball:SetTexCoord (unpack (COORDS_LEFT_BALL_NO_ICON))
			self.baseframe.cabecalho.emenda:SetTexCoord (unpack (COORDS_LEFT_CONNECTOR_NO_ICON))
		else
			self.baseframe.cabecalho.ball:SetTexCoord (unpack (COORDS_LEFT_BALL))
			self.baseframe.cabecalho.emenda:SetTexCoord (unpack (COORDS_LEFT_CONNECTOR))
		end
		
		self.baseframe.cabecalho.ball:ClearAllPoints()
		
		local x, y = unpack (skin.left_corner_anchor)
		x = x + (anchor_mod)
		self.baseframe.cabecalho.ball:SetPoint ("bottomleft", self.baseframe, "topleft", x, y)

		--> ball r
		self.baseframe.cabecalho.ball_r:SetTexCoord (unpack (COORDS_RIGHT_BALL))
		self.baseframe.cabecalho.ball_r:ClearAllPoints()
		
		local x, y = unpack (skin.right_corner_anchor)
		x = x + ((anchor_mod) * -1)
		self.baseframe.cabecalho.ball_r:SetPoint ("bottomright", self.baseframe, "topright", x, y)

		--> tex coords
		self.baseframe.cabecalho.top_bg:SetTexCoord (unpack (COORDS_TOP_BACKGROUND))

		--> up frames
		self.baseframe.UPFrame:SetPoint ("left", self.baseframe.cabecalho.ball, "right", 0, -53)
		self.baseframe.UPFrame:SetPoint ("right", self.baseframe.cabecalho.ball_r, "left", 0, -53)
		
		self.baseframe.UPFrameConnect:ClearAllPoints()
		self.baseframe.UPFrameConnect:SetPoint ("bottomleft", self.baseframe, "topleft", 0, -1)
		self.baseframe.UPFrameConnect:SetPoint ("bottomright", self.baseframe, "topright", 0, -1)
		
		self.baseframe.UPFrameLeftPart:ClearAllPoints()
		self.baseframe.UPFrameLeftPart:SetPoint ("bottomleft", self.baseframe, "topleft", 0, 0)
		
		
	else --> bottom
	
		local y = 0
		if (self.show_statusbar) then
			y = -14
		end
		
		local anchor_mod = not self.show_sidebars and skin.instance_cprops.show_sidebars_need_resize_by or 0
	
		--> ball point
		self.baseframe.cabecalho.ball_point:ClearAllPoints()
		
		local _x, _y = unpack (skin.icon_point_anchor_bottom)
		_x = _x + (anchor_mod)
		self.baseframe.cabecalho.ball_point:SetPoint ("topleft", self.baseframe, "bottomleft", _x, _y + y)
		
		--> ball
		self.baseframe.cabecalho.ball:ClearAllPoints()
		
		local _x, _y = unpack (skin.left_corner_anchor_bottom)
		_x = _x + (anchor_mod)
		self.baseframe.cabecalho.ball:SetPoint ("topleft", self.baseframe, "bottomleft", _x, _y + y)
		local l, r, t, b = unpack (COORDS_LEFT_BALL)
		self.baseframe.cabecalho.ball:SetTexCoord (l, r, b, t)

		--> ball r
		self.baseframe.cabecalho.ball_r:ClearAllPoints()
		
		local _x, _y = unpack (skin.right_corner_anchor_bottom)
		_x = _x + ((anchor_mod) * -1)
		self.baseframe.cabecalho.ball_r:SetPoint ("topright", self.baseframe, "bottomright", _x, _y + y)
		local l, r, t, b = unpack (COORDS_RIGHT_BALL)
		self.baseframe.cabecalho.ball_r:SetTexCoord (l, r, b, t)
		
		--> tex coords
		local l, r, t, b = unpack (COORDS_LEFT_CONNECTOR)
		self.baseframe.cabecalho.emenda:SetTexCoord (l, r, b, t)
		local l, r, t, b = unpack (COORDS_TOP_BACKGROUND)
		self.baseframe.cabecalho.top_bg:SetTexCoord (l, r, b, t)

		--> up frames
		self.baseframe.UPFrame:SetPoint ("left", self.baseframe.cabecalho.ball, "right", 0, 53)
		self.baseframe.UPFrame:SetPoint ("right", self.baseframe.cabecalho.ball_r, "left", 0, 53)
		
		self.baseframe.UPFrameConnect:ClearAllPoints()
		self.baseframe.UPFrameConnect:SetPoint ("topleft", self.baseframe, "bottomleft", 0, 1)
		self.baseframe.UPFrameConnect:SetPoint ("topright", self.baseframe, "bottomright", 0, 1)
		
		self.baseframe.UPFrameLeftPart:ClearAllPoints()
		self.baseframe.UPFrameLeftPart:SetPoint ("topleft", self.baseframe, "bottomleft", 0, 0)

	end
	
	if (only_update_anchors) then
		--> ShowSideBars depends on this and creates a infinite loop
		return
	end
	
	--> update top menus
	self:LeftMenuAnchorSide()
	
	self:StretchButtonAnchor()
	
	self:HideMainIcon()
	
	if (self.show_sidebars) then
		self:ShowSideBars()
	end
	
	self:AttributeMenu()
	
	--> update the grow direction to update the gap between the titlebar and the baseframe
	self:SetBarGrowDirection()
end

function _detalhes:StretchButtonAlwaysOnTop (on_top)
	
	if (type (on_top) ~= "boolean") then
		on_top = self.grab_on_top
	end
	
	self.grab_on_top = on_top
	
	if (self.grab_on_top) then
		self.baseframe.button_stretch:SetFrameStrata ("FULLSCREEN")
	else
		self.baseframe.button_stretch:SetFrameStrata (self.strata)
	end
	
end

function _detalhes:StretchButtonAnchor (side)
	
	if (not side) then
		side = self.stretch_button_side
	end
	
	if (side == 1 or string.lower (side) == "top") then
	
		self.baseframe.button_stretch:ClearAllPoints()
		
		local y = 0
		if (self.toolbar_side == 2) then --bottom
			y = -20
		end
		
		self.baseframe.button_stretch:SetPoint ("bottom", self.baseframe, "top", 0, 20 + y)
		self.baseframe.button_stretch:SetPoint ("right", self.baseframe, "right", -27, 0)
		self.baseframe.button_stretch.texture:SetTexCoord (unpack (COORDS_STRETCH))
		self.stretch_button_side = 1
		
	elseif (side == 2 or string.lower (side) == "bottom") then
	
		self.baseframe.button_stretch:ClearAllPoints()
		
		local y = 0
		if (self.toolbar_side == 2) then --bottom
			y = y -20
		end
		if (self.show_statusbar) then
			y = y -14
		end
		
		self.baseframe.button_stretch:SetPoint ("center", self.baseframe, "center")
		self.baseframe.button_stretch:SetPoint ("top", self.baseframe, "bottom", 0, y)
		
		local l, r, t, b = unpack (COORDS_STRETCH)
		self.baseframe.button_stretch.texture:SetTexCoord (r, l, b, t)
		
		self.stretch_button_side = 2
		
	end
	
end

function _detalhes:MenuAnchor (x, y)

	if (self.toolbar_side == 1) then --top
		if (not x) then
			x = self.menu_anchor [1]
		end
		if (not y) then
			y = self.menu_anchor [2]
		end
		self.menu_anchor [1] = x
		self.menu_anchor [2] = y
		
	elseif (self.toolbar_side == 2) then --bottom
		if (not x) then
			x = self.menu_anchor_down [1]
		end
		if (not y) then
			y = self.menu_anchor_down [2]
		end
		self.menu_anchor_down [1] = x
		self.menu_anchor_down [2] = y
	end
	
	local menu_points = self.menu_points -- = {MenuAnchorLeft, MenuAnchorRight}
	
	if (self.menu_anchor.side == 1) then --> left
	
		menu_points [1]:ClearAllPoints()
		
		if (self.toolbar_side == 1) then --> top
			menu_points [1]:SetPoint ("bottomleft", self.baseframe.cabecalho.ball, "bottomright", x, y) -- y+2
			
		else --> bottom
			menu_points [1]:SetPoint ("topleft", self.baseframe.cabecalho.ball, "topright", x, (y*-1) - 4)

		end
	
	elseif (self.menu_anchor.side == 2) then --> right
	
		menu_points [2]:ClearAllPoints()
		
		if (self.toolbar_side == 1) then --> top
			menu_points [2]:SetPoint ("topleft", self.baseframe.cabecalho.ball_r, "bottomleft", x, y+16)
			
		else --> bottom
			menu_points [2]:SetPoint ("topleft", self.baseframe.cabecalho.ball_r, "topleft", x, (y*-1) - 4)

		end
	end
	
	self:ToolbarMenuButtons()
	
end

function _detalhes:HideMainIcon (value)

	if (type (value) ~= "boolean") then
		value = self.hide_icon
	end
	
	if (value) then
	
		self.hide_icon = true
		gump:Fade (self.baseframe.cabecalho.atributo_icon, 1)
		--self.baseframe.cabecalho.ball:SetParent (self.baseframe)
		
		if (self.toolbar_side == 1) then
			self.baseframe.cabecalho.ball:SetTexCoord (unpack (COORDS_LEFT_BALL_NO_ICON))
			self.baseframe.cabecalho.emenda:SetTexCoord (unpack (COORDS_LEFT_CONNECTOR_NO_ICON))
			
		elseif (self.toolbar_side == 2) then
			local l, r, t, b = unpack (COORDS_LEFT_BALL_NO_ICON)
			self.baseframe.cabecalho.ball:SetTexCoord (l, r, b, t)
			local l, r, t, b = unpack (COORDS_LEFT_CONNECTOR_NO_ICON)
			self.baseframe.cabecalho.emenda:SetTexCoord (l, r, b, t)
		
		end
		
		local skin = _detalhes.skins [self.skin]
		
		if (skin.icon_on_top) then
			self.baseframe.cabecalho.atributo_icon:SetParent (self.floatingframe)
		else
			self.baseframe.cabecalho.atributo_icon:SetParent (self.baseframe)
		end
		
	else
		self.hide_icon = false
		gump:Fade (self.baseframe.cabecalho.atributo_icon, 0)
		--self.baseframe.cabecalho.ball:SetParent (_detalhes.listener)
		
		if (self.toolbar_side == 1) then

			self.baseframe.cabecalho.ball:SetTexCoord (unpack (COORDS_LEFT_BALL))
			self.baseframe.cabecalho.emenda:SetTexCoord (unpack (COORDS_LEFT_CONNECTOR))
			
		elseif (self.toolbar_side == 2) then

			local l, r, t, b = unpack (COORDS_LEFT_BALL)
			self.baseframe.cabecalho.ball:SetTexCoord (l, r, b, t)
			local l, r, t, b = unpack (COORDS_LEFT_CONNECTOR)
			self.baseframe.cabecalho.emenda:SetTexCoord (l, r, b, t)
		end
	end
	
end

--> search key: ~desaturate
function _detalhes:DesaturateMenu (value)

	if (value == nil) then
		value = self.desaturated_menu
	end

	if (value) then
	
		self.desaturated_menu = true
		self.baseframe.cabecalho.modo_selecao:GetNormalTexture():SetDesaturated (true)
		self.baseframe.cabecalho.segmento:GetNormalTexture():SetDesaturated (true)
		self.baseframe.cabecalho.atributo:GetNormalTexture():SetDesaturated (true)
		self.baseframe.cabecalho.report:GetNormalTexture():SetDesaturated (true)
		self.baseframe.cabecalho.reset:GetNormalTexture():SetDesaturated (true)
		self.baseframe.cabecalho.fechar:GetNormalTexture():SetDesaturated (true)
		
		if (self.meu_id == _detalhes:GetLowerInstanceNumber()) then
			for _, button in _ipairs (_detalhes.ToolBar.AllButtons) do
				button:GetNormalTexture():SetDesaturated (true)
			end
		end
		
	else
	
		self.desaturated_menu = false
		self.baseframe.cabecalho.modo_selecao:GetNormalTexture():SetDesaturated (false)
		self.baseframe.cabecalho.segmento:GetNormalTexture():SetDesaturated (false)
		self.baseframe.cabecalho.atributo:GetNormalTexture():SetDesaturated (false)
		self.baseframe.cabecalho.report:GetNormalTexture():SetDesaturated (false)
		self.baseframe.cabecalho.reset:GetNormalTexture():SetDesaturated (false)
		self.baseframe.cabecalho.fechar:GetNormalTexture():SetDesaturated (false)
		
		if (self.meu_id == _detalhes:GetLowerInstanceNumber()) then
			for _, button in _ipairs (_detalhes.ToolBar.AllButtons) do
				button:GetNormalTexture():SetDesaturated (false)
			end
		end
		
	end
end

function _detalhes:ShowSideBars (instancia)
	if (instancia) then
		self = instancia
	end
	
	self.show_sidebars = true
	
	self.baseframe.barra_esquerda:Show()
	self.baseframe.barra_direita:Show()
	
	--> set default spacings
	local this_skin = _detalhes.skins [self.skin]
	if (this_skin.instance_cprops and this_skin.instance_cprops.row_info and this_skin.instance_cprops.row_info.space) then
		self.row_info.space.left = this_skin.instance_cprops.row_info.space.left
		self.row_info.space.right = this_skin.instance_cprops.row_info.space.right
	else
		self.row_info.space.left = 3
		self.row_info.space.right = -5
	end

	if (self.show_statusbar) then
		self.baseframe.barra_esquerda:SetPoint ("bottomleft", self.baseframe, "bottomleft", -56, -14)
		self.baseframe.barra_direita:SetPoint ("bottomright", self.baseframe, "bottomright", 56, -14)
		
		if (self.toolbar_side == 2) then
			self.baseframe.barra_fundo:Show()
			local l, r, t, b = unpack (COORDS_BOTTOM_SIDE_BAR)
			self.baseframe.barra_fundo:SetTexCoord (l, r, b, t)
			self.baseframe.barra_fundo:ClearAllPoints()
			self.baseframe.barra_fundo:SetPoint ("bottomleft", self.baseframe, "topleft", 0, -6)
			self.baseframe.barra_fundo:SetPoint ("bottomright", self.baseframe, "topright", -1, -6)
		else
			self.baseframe.barra_fundo:Hide()
		end
	else
		self.baseframe.barra_esquerda:SetPoint ("bottomleft", self.baseframe, "bottomleft", -56, 0)
		self.baseframe.barra_direita:SetPoint ("bottomright", self.baseframe, "bottomright", 56, 0)
		
		self.baseframe.barra_fundo:Show()
		
		if (self.toolbar_side == 2) then --tooltbar on bottom
			local l, r, t, b = unpack (COORDS_BOTTOM_SIDE_BAR)
			self.baseframe.barra_fundo:SetTexCoord (l, r, b, t)
			self.baseframe.barra_fundo:ClearAllPoints()
			self.baseframe.barra_fundo:SetPoint ("bottomleft", self.baseframe, "topleft", 0, -6)
			self.baseframe.barra_fundo:SetPoint ("bottomright", self.baseframe, "topright", -1, -6)
		else --tooltbar on top
			self.baseframe.barra_fundo:SetTexCoord (unpack (COORDS_BOTTOM_SIDE_BAR))
			self.baseframe.barra_fundo:ClearAllPoints()
			self.baseframe.barra_fundo:SetPoint ("bottomleft", self.baseframe, "bottomleft", 0, -56)
			self.baseframe.barra_fundo:SetPoint ("bottomright", self.baseframe, "bottomright", -1, -56)
		end
	end
	
	--self:SetBarGrowDirection()
	--passando true - apenas atulizar as anchors
	self:ToolbarSide (nil, true)
	
end

function _detalhes:HideSideBars (instancia)
	if (instancia) then
		self = instancia
	end
	
	self.show_sidebars = false
	
	local this_skin = _detalhes.skins [self.skin]
	local space_config = this_skin.instance_cprops and this_skin.instance_cprops.row_info and this_skin.instance_cprops.row_info.space
	if (space_config) then
		if (space_config.left_noborder) then
			self.row_info.space.left = space_config.left_noborder
		else
			self.row_info.space.left = 0
		end
		
		if (space_config.right_noborder) then
			self.row_info.space.right = space_config.right_noborder
		else
			self.row_info.space.right = 0
		end
	else
		self.row_info.space.left = 0
		self.row_info.space.right = 0
	end

	self.baseframe.barra_esquerda:Hide()
	self.baseframe.barra_direita:Hide()
	self.baseframe.barra_fundo:Hide()
	
	--self:SetBarGrowDirection() --j� � chamado no toolbarside
	--passando true - apenas atulizar as anchors
	self:ToolbarSide (nil, true)
end

function _detalhes:HideStatusBar (instancia)
	if (instancia) then
		self = instancia
	end
	
	self.show_statusbar = false
	
	self.baseframe.rodape.esquerdo:Hide()
	self.baseframe.rodape.direita:Hide()
	self.baseframe.rodape.top_bg:Hide()
	self.baseframe.rodape.StatusBarLeftAnchor:Hide()
	self.baseframe.rodape.StatusBarCenterAnchor:Hide()
	self.baseframe.DOWNFrame:Hide()
	
	--debug
	self.baseframe.rodape.direita_nostatusbar:Show()
	self.baseframe.rodape.esquerdo_nostatusbar:Show()
	--
	
	if (self.toolbar_side == 2) then
		self:ToolbarSide()
	end
	
	if (self.show_sidebars) then
		self:ShowSideBars()
	end
	
	self:StretchButtonAnchor()
	
	if (self.micro_displays_side == 2) then --> bottom side
		_detalhes.StatusBar:Hide (self) --> mini displays widgets
	end
end

function _detalhes:StatusBarColor (r, g, b, a, no_save)

	if (not r) then
		r, g, b = unpack (self.statusbar_info.overlay)
		a = a or self.statusbar_info.alpha
	end

	if (not no_save) then
		self.statusbar_info.overlay [1] = r
		self.statusbar_info.overlay [2] = g
		self.statusbar_info.overlay [3] = b
		self.statusbar_info.alpha = a
	end
	
	self.baseframe.rodape.esquerdo:SetVertexColor (r, g, b)
	self.baseframe.rodape.esquerdo:SetAlpha (a)
	self.baseframe.rodape.direita:SetVertexColor (r, g, b)
	self.baseframe.rodape.direita:SetAlpha (a)
	self.baseframe.rodape.direita_nostatusbar:SetVertexColor (r, g, b)
	self.baseframe.rodape.esquerdo_nostatusbar:SetVertexColor (r, g, b)
	self.baseframe.rodape.direita_nostatusbar:SetAlpha (a)
	self.baseframe.rodape.esquerdo_nostatusbar:SetAlpha (a)
	self.baseframe.rodape.top_bg:SetVertexColor (r, g, b)
	self.baseframe.rodape.top_bg:SetAlpha (a)
	
end

function _detalhes:ShowStatusBar (instancia)
	if (instancia) then
		self = instancia
	end
	
	self.show_statusbar = true
	
	self.baseframe.rodape.esquerdo:Show()
	self.baseframe.rodape.direita:Show()
	self.baseframe.rodape.top_bg:Show()
	self.baseframe.rodape.StatusBarLeftAnchor:Show()
	self.baseframe.rodape.StatusBarCenterAnchor:Show()
	self.baseframe.DOWNFrame:Show()
	
	--debug
	self.baseframe.rodape.direita_nostatusbar:Hide()
	self.baseframe.rodape.esquerdo_nostatusbar:Hide()
	--
	
	self:ToolbarSide()
	
	self:StretchButtonAnchor()
	
	if (self.micro_displays_side == 2) then --> bottom side
		_detalhes.StatusBar:Show (self) --> mini displays widgets
	end
end

function _detalhes:SetTooltipBackdrop (border_texture, border_size, border_color)

	if (not border_texture) then
		border_texture = _detalhes.tooltip.border_texture
	end
	if (not border_size) then
		border_size = _detalhes.tooltip.border_size
	end
	if (not border_color) then
		border_color = _detalhes.tooltip.border_color
	end

	_detalhes.tooltip.border_texture = border_texture
	_detalhes.tooltip.border_size = border_size

	local c = _detalhes.tooltip.border_color
	local cc = _detalhes.tooltip_border_color
	c[1], c[2], c[3], c[4] = border_color[1], border_color[2], border_color[3], border_color[4] or 1
	cc[1], cc[2], cc[3], cc[4] = border_color[1], border_color[2], border_color[3], border_color[4] or 1

	_detalhes.tooltip_backdrop.edgeFile = SharedMedia:Fetch ("border", border_texture)
	_detalhes.tooltip_backdrop.edgeSize = border_size

end

--> reset button functions
	local reset_button_onenter = function (self, _, forced, from_click)
	
		if (_detalhes.instances_menu_click_to_open and not forced) then
			return
		end

		local instancia = self._instance or self.widget._instance
		local baseframe = instancia.baseframe
	
		local GameCooltip = GameCooltip
	
		OnEnterMainWindow (self.instance, self)
		GameCooltip.buttonOver = true
		self.instance.baseframe.cabecalho.button_mouse_over = true
		
		if (self.instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated (false)
		end
		
		GameCooltip:Reset()
		GameCooltip:SetType ("menu")
		
		GameCooltip:SetOption ("ButtonsYMod", -6)
		GameCooltip:SetOption ("HeighMod", 6)
		GameCooltip:SetOption ("YSpacingMod", -3)
		GameCooltip:SetOption ("TextHeightMod", 0)
		GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
		
		_detalhes:SetTooltipMinWidth()
		
		GameCooltip:AddLine (Loc ["STRING_ERASE_DATA_OVERALL"], nil, 1, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\Buttons\UI-StopButton]], 1, 1, 14, 14, 0, 1, 0, 1, "orange")
		GameCooltip:AddMenu (1, _detalhes.tabela_historico.resetar_overall)
		
		GameCooltip:AddLine ("$div", nil, 1, nil, -5, -11)
		
		GameCooltip:AddLine (Loc ["STRING_ERASE_DATA"], nil, 1, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\Buttons\UI-StopButton]], 1, 1, 14, 14, 0, 1, 0, 1, "red")
		GameCooltip:AddMenu (1, _detalhes.tabela_historico.resetar)
		
		_detalhes:FormatCooltipBackdrop()
		
		--GameCooltip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		--GameCooltip:SetBackdrop (1, menus_backdrop, nil, menus_bordercolor)
		
		show_anti_overlap (self.instance, self, "top")
		
		_detalhes:SetMenuOwner (self, self.instance)
		GameCooltip:ShowCooltip()
	end
	
	local reset_button_onleave = function (self)
		OnLeaveMainWindow (self.instance, self)
		
		if (self.instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated (true)
		end
		
		hide_anti_overlap (self.instance.baseframe.anti_menu_overlap)
		
		GameCooltip.buttonOver = false
		self.instance.baseframe.cabecalho.button_mouse_over = false
		
		if (GameCooltip.active) then
			parameters_table [2] = 0
			self:SetScript ("OnUpdate", on_leave_menu)
		else
			self:SetScript ("OnUpdate", nil)
		end
		
	end
	
--> close button functions

	local close_button_onclick = function (self, button_type, button)
	
		if (self and not self.instancia and button and button.instancia) then
			self = button
		end
	
		self = self or button
	
		self:Disable()
		self.instancia:DesativarInstancia() 
		
		--> n�o h� mais inst�ncias abertas, ent�o manda msg alertando
		if (_detalhes.opened_windows == 0) then
			_detalhes:Msg (Loc ["STRING_CLOSEALL"])
		end
		
		--> tutorial, how to fully delete a window
		--_detalhes:SetTutorialCVar ("FULL_DELETE_WINDOW", false)
		
		if (not _detalhes:GetTutorialCVar ("FULL_DELETE_WINDOW")) then
			_detalhes:SetTutorialCVar ("FULL_DELETE_WINDOW", true)
			
			local panel = gump:Create1PxPanel (UIParent, 600, 100, "|cFFFFFFFFDetails!, the window hit the ground, bang bang...|r", nil, nil, nil, nil)
			panel:SetBackdropColor (0, 0, 0, 0.9)
			panel:SetPoint ("center", UIParent, "center")
			
			local s = panel:CreateFontString (nil, "overlay", "GameFontNormal")
			s:SetPoint ("center", panel, "center")
			s:SetText (Loc ["STRING_TUTORIAL_FULLY_DELETE_WINDOW"])
			
			panel:Show()
		end
		
		GameCooltip:Hide()
	end
	_detalhes.close_instancia_func = close_button_onclick

	local close_button_onenter = function (self)
		OnEnterMainWindow (self.instance, self, 3)

		if (self.instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated (false)
		end
		
		local GameCooltip = GameCooltip
		
		GameCooltip.buttonOver = true
		self.instance.baseframe.cabecalho.button_mouse_over = true
		
		GameCooltip:Reset()
		GameCooltip:SetType ("menu")
		GameCooltip:SetOption ("ButtonsYMod", -7)
		GameCooltip:SetOption ("ButtonsYModSub", -2)
		GameCooltip:SetOption ("YSpacingMod", 0)
		GameCooltip:SetOption ("YSpacingModSub", -3)
		GameCooltip:SetOption ("TextHeightMod", 0)
		GameCooltip:SetOption ("TextHeightModSub", 0)
		GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
		GameCooltip:SetOption ("IgnoreButtonAutoHeightSub", false)
		GameCooltip:SetOption ("SubMenuIsTooltip", true)
		GameCooltip:SetOption ("FixedWidthSub", 180)
		--GameCooltip:SetOption ("FixedHeight", 30)
		
		GameCooltip:SetOption ("HeighMod", 9)

		local font = SharedMedia:Fetch ("font", "Friz Quadrata TT")
		GameCooltip:AddLine (Loc ["STRING_MENU_CLOSE_INSTANCE"], nil, 1, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\Buttons\UI-Panel-MinimizeButton-Up]], 1, 1, 14, 14, 0.2, 0.8, 0.2, 0.8)
		GameCooltip:AddMenu (1, close_button_onclick, self)
		
		GameCooltip:AddLine (Loc ["STRING_MENU_CLOSE_INSTANCE_DESC"], nil, 2, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\CHATFRAME\UI-ChatIcon-Minimize-Up]], 2, 1, 18, 18)
		
		GameCooltip:AddLine (Loc ["STRING_MENU_CLOSE_INSTANCE_DESC2"], nil, 2, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
		GameCooltip:AddIcon ([[Interface\PaperDollInfoFrame\UI-GearManager-LeaveItem-Transparent]], 2, 1, 18, 18)
		
		GameCooltip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		GameCooltip:SetWallpaper (2, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
		GameCooltip:SetBackdrop (1, menus_backdrop, nil, menus_bordercolor)
		GameCooltip:SetBackdrop (2, menus_backdrop, nil, menus_bordercolor)
		
		show_anti_overlap (self.instance, self, "top")
		
		_detalhes:SetMenuOwner (self, self.instance)
		GameCooltip:ShowCooltip()
	end
	
	local close_button_onleave = function (self)
		OnLeaveMainWindow (self.instance, self, 3)

		if (self.instance.desaturated_menu) then
			self:GetNormalTexture():SetDesaturated (true)
		end
		
		hide_anti_overlap (self.instance.baseframe.anti_menu_overlap)
		
		GameCooltip.buttonOver = false
		self.instance.baseframe.cabecalho.button_mouse_over = false
		
		if (GameCooltip.active) then
			parameters_table [2] = 0
			self:SetScript ("OnUpdate", on_leave_menu)
		else
			self:SetScript ("OnUpdate", nil)
		end
		
	end
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> build upper menu bar

local menu_can_open = function()
	if (GameCooltip.active) then
		local owner = GameCooltip:GetOwner()
		if (owner and owner:GetScript ("OnUpdate") == on_leave_menu) then
			owner:SetScript ("OnUpdate", nil)
		end
		return true
	end
end

local report_on_enter = function (self, motion, forced, from_click)

	local is_cooltip_opened = menu_can_open() --  and not is_cooltip_opened
	if (_detalhes.instances_menu_click_to_open and not forced) then
		return
	end

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe

	OnEnterMainWindow (instancia, self, 3)
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (false)
	end
	
	GameCooltip.buttonOver = true
	baseframe.cabecalho.button_mouse_over = true
	
	GameCooltip:Reset()
	
	GameCooltip:SetType ("menu")
	GameCooltip:SetOption ("ButtonsYMod", -6)
	GameCooltip:SetOption ("HeighMod", 6)
	GameCooltip:SetOption ("YSpacingMod", -1)
	GameCooltip:SetOption ("TextHeightMod", 0)
	GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)

	_detalhes:SetTooltipMinWidth()
	
	_detalhes:CheckLastReportsIntegrity()
	
	local last_reports = _detalhes.latest_report_table
	if (#last_reports > 0) then
		local amountReports = #last_reports
		amountReports = math.min (amountReports, 10)
	
		for index = amountReports, 1, -1 do
			local report = last_reports [index]
			local instance_number, attribute, subattribute, amt, report_where, custom_name = unpack (report)
			
			local name = _detalhes:GetSubAttributeName (attribute, subattribute, custom_name)
			
			local artwork =  _detalhes.GetReportIconAndColor (report_where)
			
			GameCooltip:AddLine (name .. " (#" .. amt .. ")", nil, 1, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
			if (artwork) then
				GameCooltip:AddIcon (artwork.icon, 1, 1, 14, 14, artwork.coords[1], artwork.coords[2], artwork.coords[3], artwork.coords[4], artwork.color, nil, false)
			end
			GameCooltip:AddMenu (1, _detalhes.ReportFromLatest, index)
		end
		
		GameCooltip:AddLine ("$div", nil, nil, -4)
	end
	
	GameCooltip:AddLine (Loc ["STRING_REPORT_TOOLTIP"], nil, 1, "white", nil, _detalhes.font_sizes.menus, _detalhes.font_faces.menus)
	GameCooltip:AddIcon ([[Interface\Addons\Details\Images\report_button]], 1, 1, 12, 19)
	GameCooltip:AddMenu (1, _detalhes.Reportar, instancia, nil, "INSTANCE" .. instancia.meu_id)
	
	_detalhes:FormatCooltipBackdrop()
	
	--GameCooltip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
	--GameCooltip:SetBackdrop (1, menus_backdrop, nil, menus_bordercolor)
	
	show_anti_overlap (instancia, self, "top")
	_detalhes:SetMenuOwner (self, instancia)
	
	GameCooltip:ShowCooltip()
end

local report_on_leave = function (self, motion, forced, from_click)

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe

	OnLeaveMainWindow (instancia, self, 3)
	
	hide_anti_overlap (instancia.baseframe.anti_menu_overlap)
	
	GameCooltip.buttonOver = false
	baseframe.cabecalho.button_mouse_over = false
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (true)
	end
	
	if (GameCooltip.active) then
		parameters_table [2] = from_click and 1 or 0
		self:SetScript ("OnUpdate", on_leave_menu)
	else
		self:SetScript ("OnUpdate", nil)
	end
end

local atributo_on_enter = function (self, motion, forced, from_click)

	local is_cooltip_opened = menu_can_open() --  and not is_cooltip_opened
	if (_detalhes.instances_menu_click_to_open and not forced) then
		return
	end

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe
	
	OnEnterMainWindow (instancia, self, 3)

	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (false)
	end	

	GameCooltip.buttonOver = true
	baseframe.cabecalho.button_mouse_over = true
	
	show_anti_overlap (instancia, self, "top")

	GameCooltip:Reset()
	GameCooltip:SetType (3)
	GameCooltip:SetFixedParameter (instancia)
	
	if (_detalhes.solo and _detalhes.solo == instancia.meu_id) then
		_detalhes:MontaSoloOption (instancia)
		
	elseif (instancia:IsRaidMode()) then
	
		local have_plugins = _detalhes:MontaRaidOption (instancia)
		if (not have_plugins) then
			GameCooltip:SetType ("tooltip")
			GameCooltip:SetOption ("ButtonsYMod", 0)
			
			GameCooltip:SetOption ("TextHeightMod", 0)
			GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
			GameCooltip:AddLine ("All raid plugins already\nin use or disabled.", nil, 1, "white", nil, 10, SharedMedia:Fetch ("font", "Friz Quadrata TT"))
			GameCooltip:AddIcon ([[Interface\GROUPFRAME\UI-GROUP-ASSISTANTICON]], 1, 1)
			GameCooltip:SetWallpaper (1, _detalhes.tooltip.menus_bg_texture, _detalhes.tooltip.menus_bg_coords, _detalhes.tooltip.menus_bg_color, true)
			
		end
		
	else
		_detalhes:MontaAtributosOption (instancia)
		GameCooltip:SetOption ("YSpacingMod", -1)
		GameCooltip:SetOption ("YSpacingModSub", -2)
	end
	
	--GameCooltip:SetBackdrop (1, menus_backdrop, nil, menus_bordercolor)
	--GameCooltip:SetBackdrop (2, menus_backdrop, nil, menus_bordercolor)
	GameCooltip:SetOption ("TextSize", _detalhes.font_sizes.menus)
	
	_detalhes:FormatCooltipBackdrop()
	
	_detalhes:SetMenuOwner (self, instancia)
	if (instancia.toolbar_side == 2) then --bottom
		GameCooltip:SetOption ("HeightAnchorMod", 0)
	end
	
	GameCooltip:ShowCooltip (self)
end

local atributo_on_leave = function (self, motion, forced, from_click)
	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe
	
	OnLeaveMainWindow (instancia, self, 3)
	
	hide_anti_overlap (instancia.baseframe.anti_menu_overlap)
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (true)
	end
	
	GameCooltip.buttonOver = false
	baseframe.cabecalho.button_mouse_over = false
	
	if (GameCooltip.active) then
		parameters_table [2] = 0
		self:SetScript ("OnUpdate", on_leave_menu)
	else
		self:SetScript ("OnUpdate", nil)
	end
end

local segmento_on_enter = function (self, motion, forced, from_click) 

	local is_cooltip_opened = menu_can_open() --  and not is_cooltip_opened
	if (_detalhes.instances_menu_click_to_open and not forced) then
		return
	end

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe
	
	OnEnterMainWindow (instancia, self, 3)
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (false)
	end
	
	GameCooltip.buttonOver = true
	baseframe.cabecalho.button_mouse_over = true
	
	local passou = 0
	if (_G.GameCooltip.active) then
		passou = 0.15
	end

	parameters_table [1] = instancia
	parameters_table [2] = from_click and 1 or passou
	self:SetScript ("OnUpdate", build_segment_list)
end

local segmento_on_leave = function (self, motion, forced, from_click) 
	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe
	
	OnLeaveMainWindow (instancia, self, 3)

	hide_anti_overlap (instancia.baseframe.anti_menu_overlap)
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (true)
	end
	
	GameCooltip.buttonOver = false
	baseframe.cabecalho.button_mouse_over = false
	
	if (GameCooltip.active) then
		parameters_table [2] = 0
		self:SetScript ("OnUpdate", on_leave_menu)
	else
		self:SetScript ("OnUpdate", nil)
	end
end

local modo_selecao_on_enter = function (self, motion, forced, from_click)

	local is_cooltip_opened = menu_can_open() --  not is_cooltip_opened
	if (_detalhes.instances_menu_click_to_open and not forced) then
		return
	end

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe
	
	OnEnterMainWindow (instancia, self, 3)
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (false)
	end
	
	GameCooltip.buttonOver = true
	baseframe.cabecalho.button_mouse_over = true
	
	local passou = 0
	if (_G.GameCooltip.active) then
		passou = 0.15
	end

	local checked
	if (instancia.modo == 1) then
		checked = 4
	elseif (instancia.modo == 2) then
		checked = 1
	elseif (instancia.modo == 3) then
		checked = 2
	elseif (instancia.modo == 4) then
		checked = 3
	end

	parameters_table [1] = instancia
	parameters_table [2] = from_click and 1 or passou
	parameters_table [3] = checked
	
	self:SetScript ("OnUpdate", build_mode_list)
end

local modo_selecao_on_leave = function (self)

	local instancia = self._instance or self.widget._instance
	local baseframe = instancia.baseframe

	OnLeaveMainWindow (instancia, self, 3)
	
	hide_anti_overlap (instancia.baseframe.anti_menu_overlap)
	
	if (instancia.desaturated_menu) then
		self:GetNormalTexture():SetDesaturated (true)
	end
	
	GameCooltip.buttonOver = false
	baseframe.cabecalho.button_mouse_over = false
	
	if (GameCooltip.active) then
		parameters_table [2] = 0
		self:SetScript ("OnUpdate", on_leave_menu)
	else
		self:SetScript ("OnUpdate", nil)
	end
end



-- these can 
local title_bar_icons = {
	{texture = [[Interface\AddOns\Details\images\toolbar_icons]], texcoord = {0/256, 32/256, 0, 1}},
	{texture = [[Interface\AddOns\Details\images\toolbar_icons]], texcoord = {32/256, 64/256, 0, 1}},
	{texture = [[Interface\AddOns\Details\images\toolbar_icons]], texcoord = {66/256, 93/256, 0, 1}},
	{texture = [[Interface\AddOns\Details\images\toolbar_icons]], texcoord = {96/256, 128/256, 0, 1}},
	{texture = [[Interface\AddOns\Details\images\toolbar_icons]], texcoord = {128/256, 160/256, 0, 1}},
}
function _detalhes:GetTitleBarIconsTexture (button, instance)
	if (instance or self.meu_id) then
		local textureFile = self.toolbar_icon_file or instance.toolbar_icon_file
		local t = title_bar_icons [button]
		if (t and textureFile) then
			t.texture = textureFile
		end
		return t or title_bar_icons
	end
	return title_bar_icons [button] or title_bar_icons
end

function _detalhes:CreateFakeWindow()
	local t = CreateFrame ("frame")
	t:SetSize (200, 91)
	t:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
	t:SetBackdropColor (0.0941, 0.0941, 0.0941, 0.3)
	local tb = CreateFrame ("frame", nil, t)
	tb:SetPoint ("bottomleft", t, "topleft", 0, 0)
	tb:SetPoint ("bottomright", t, "topright", 0, 0)
	tb:SetHeight (16)
	tb:SetBackdrop ({bgFile = "Interface\\AddOns\\Details\\images\\background", tile = true, tileSize = 16 })
	tb:SetBackdropColor (0.7, 0.7, 0.7, 0.4)
	local tt = tb:CreateFontString (nil, "overlay", "GameFontNormal")
	_detalhes:SetFontColor (tt, "white")
	_detalhes:SetFontSize (tt, 10)
	_detalhes:SetFontFace (tt, LibStub:GetLibrary("LibSharedMedia-3.0"):Fetch ("font", "Accidental Presidency"))
	tt:SetPoint ("bottomleft", tb, 3, 4)
	tt:SetText ("Damage Done")
	
	t.TitleIcons = {}
	for i = 1, 5 do
		local b = tb:CreateTexture (nil, "overlay")
		b:SetSize (12, 12)
		b:SetPoint ("bottomright", tb, "bottomright", -((abs(i-6)-1)*11) - 1, 2)
		local button_texture_texcoord = _detalhes:GetTitleBarIconsTexture (i)
		b:SetTexture (button_texture_texcoord.texture)
		b:SetTexCoord (unpack (button_texture_texcoord.texcoord))
		tinsert (t.TitleIcons, b)
	end
	
	t.TitleBar = tb
	t.TitleText = tt
	
	return t
end

local function click_to_change_segment (instancia, buttontype)
	if (buttontype == "LeftButton") then
	
		local segmento_goal = instancia.segmento + 1
		if (segmento_goal > segments_used) then
			segmento_goal = -1
		elseif (segmento_goal > _detalhes.segments_amount) then
			segmento_goal = -1
		end
		
		local total_shown = segments_filled+2
		local goal = segmento_goal+1
		
		local select_ = math.abs (goal - total_shown)
		GameCooltip:Select (1, select_)
		
		instancia:TrocaTabela (segmento_goal)
		
		segmento_on_enter (instancia.baseframe.cabecalho.segmento.widget, _, true, true)
		
	elseif (buttontype == "RightButton") then
	
		local segmento_goal = instancia.segmento - 1
		if (segmento_goal < -1) then
			segmento_goal = segments_used
		end
		
		local total_shown = segments_filled+2
		local goal = segmento_goal+1
		
		local select_ = math.abs (goal - total_shown)
		GameCooltip:Select (1, select_)
		
		instancia:TrocaTabela (segmento_goal)
		segmento_on_enter (instancia.baseframe.cabecalho.segmento.widget, _, true, true)
	
	elseif (buttontype == "MiddleButton") then
		
		local segmento_goal = 0
		
		local total_shown = segments_filled+2
		local goal = segmento_goal+1
		
		local select_ = math.abs (goal - total_shown)
		GameCooltip:Select (1, select_)
		
		instancia:TrocaTabela (segmento_goal)
		segmento_on_enter (instancia.baseframe.cabecalho.segmento.widget, _, true, true)
		
	end
end

function gump:CriaCabecalho (baseframe, instancia)

	baseframe.cabecalho = {}
	
	--> FECHAR INSTANCIA ----------------------------------------------------------------------------------------------------------------------------------------------------
	baseframe.cabecalho.fechar = CreateFrame ("button", "DetailsCloseInstanceButton" .. instancia.meu_id, baseframe) --, "UIPanelCloseButton"
	baseframe.cabecalho.fechar:SetWidth (18)
	baseframe.cabecalho.fechar:SetHeight (18)
	baseframe.cabecalho.fechar:SetFrameLevel (5) --> altura mais alta que os demais frames
	baseframe.cabecalho.fechar:SetPoint ("bottomright", baseframe, "topright", 5, -6) --> seta o ponto dele fixando no base frame
	
	baseframe.cabecalho.fechar:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	baseframe.cabecalho.fechar:GetNormalTexture():SetTexCoord (160/256, 192/256, 0, 1)
	baseframe.cabecalho.fechar:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	baseframe.cabecalho.fechar:GetHighlightTexture():SetTexCoord (160/256, 192/256, 0, 1)
	baseframe.cabecalho.fechar:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	baseframe.cabecalho.fechar:GetPushedTexture():SetTexCoord (160/256, 192/256, 0, 1)

	--baseframe.cabecalho.fechar:SetNormalTexture ([[Interface\Buttons\UI-Panel-MinimizeButton-Up]])
	--baseframe.cabecalho.fechar:SetHighlightTexture ([[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]])
	--baseframe.cabecalho.fechar:SetPushedTexture ([[Interface\Buttons\UI-Panel-MinimizeButton-Down]])
	
	baseframe.cabecalho.fechar.instancia = instancia
	baseframe.cabecalho.fechar.instance = instancia
	
	baseframe.cabecalho.fechar:SetScript ("OnEnter", close_button_onenter)
	baseframe.cabecalho.fechar:SetScript ("OnLeave", close_button_onleave)
	
	baseframe.cabecalho.fechar:SetScript ("OnClick", close_button_onclick)
	
	--> bola do canto esquedo superior --> primeiro criar a arma��o para apoiar as texturas
	baseframe.cabecalho.ball_point = instancia.floatingframe:CreateTexture (nil, "overlay")
	baseframe.cabecalho.ball_point:SetPoint ("bottomleft", baseframe, "topleft", -37, 0)
	baseframe.cabecalho.ball_point:SetWidth (64)
	baseframe.cabecalho.ball_point:SetHeight (32)
	
	--> icone do atributo
	--baseframe.cabecalho.atributo_icon = _detalhes.listener:CreateTexture (nil, "artwork")
	baseframe.cabecalho.atributo_icon = baseframe:CreateTexture ("DetailsAttributeIcon" .. instancia.meu_id, "background")
	local icon_anchor = _detalhes.skins ["WoW Interface"].icon_anchor_main
	baseframe.cabecalho.atributo_icon:SetPoint ("topright", baseframe.cabecalho.ball_point, "topright", icon_anchor[1], icon_anchor[2])
	baseframe.cabecalho.atributo_icon:SetTexture (DEFAULT_SKIN)
	baseframe.cabecalho.atributo_icon:SetWidth (32)
	baseframe.cabecalho.atributo_icon:SetHeight (32)
	
	--> bola overlay
	--baseframe.cabecalho.ball = _detalhes.listener:CreateTexture (nil, "overlay")
	baseframe.cabecalho.ball = baseframe:CreateTexture (nil, "overlay")
	baseframe.cabecalho.ball:SetPoint ("bottomleft", baseframe, "topleft", -107, 0)
	baseframe.cabecalho.ball:SetWidth (128)
	baseframe.cabecalho.ball:SetHeight (128)
	
	baseframe.cabecalho.ball:SetTexture (DEFAULT_SKIN)
	baseframe.cabecalho.ball:SetTexCoord (unpack (COORDS_LEFT_BALL))

	--> emenda
	baseframe.cabecalho.emenda = baseframe:CreateTexture (nil, "background")
	baseframe.cabecalho.emenda:SetPoint ("bottomleft", baseframe.cabecalho.ball, "bottomright")
	baseframe.cabecalho.emenda:SetWidth (8)
	baseframe.cabecalho.emenda:SetHeight (128)
	baseframe.cabecalho.emenda:SetTexture (DEFAULT_SKIN)
	baseframe.cabecalho.emenda:SetTexCoord (unpack (COORDS_LEFT_CONNECTOR))

	baseframe.cabecalho.atributo_icon:Hide()
	baseframe.cabecalho.ball:Hide()

	--> bola do canto direito superior
	baseframe.cabecalho.ball_r = baseframe:CreateTexture (nil, "background")
	baseframe.cabecalho.ball_r:SetPoint ("bottomright", baseframe, "topright", 96, 0)
	baseframe.cabecalho.ball_r:SetWidth (128)
	baseframe.cabecalho.ball_r:SetHeight (128)
	baseframe.cabecalho.ball_r:SetTexture (DEFAULT_SKIN)
	baseframe.cabecalho.ball_r:SetTexCoord (unpack (COORDS_RIGHT_BALL))

	--> barra centro
	baseframe.cabecalho.top_bg = baseframe:CreateTexture (nil, "background")
	baseframe.cabecalho.top_bg:SetPoint ("left", baseframe.cabecalho.emenda, "right", 0, 0)
	baseframe.cabecalho.top_bg:SetPoint ("right", baseframe.cabecalho.ball_r, "left")
	baseframe.cabecalho.top_bg:SetTexture (DEFAULT_SKIN)
	baseframe.cabecalho.top_bg:SetTexCoord (unpack (COORDS_TOP_BACKGROUND))
	baseframe.cabecalho.top_bg:SetWidth (512)
	baseframe.cabecalho.top_bg:SetHeight (128)

	--> frame invis�vel
	baseframe.UPFrame = CreateFrame ("frame", "DetailsUpFrameInstance"..instancia.meu_id, baseframe)
	baseframe.UPFrame:SetPoint ("left", baseframe.cabecalho.ball, "right", 0, -53)
	baseframe.UPFrame:SetPoint ("right", baseframe.cabecalho.ball_r, "left", 0, -53)
	baseframe.UPFrame:SetHeight (20)
	baseframe.UPFrame.is_toolbar = true
	
	baseframe.UPFrame:Show()
	baseframe.UPFrame:EnableMouse (true)
	baseframe.UPFrame:SetMovable (true)
	baseframe.UPFrame:SetResizable (true)
	
	BGFrame_scripts (baseframe.UPFrame, baseframe, instancia)
	
	--> corrige o v�o entre o baseframe e o upframe
	baseframe.UPFrameConnect = CreateFrame ("frame", "DetailsAntiGap"..instancia.meu_id, baseframe)
	baseframe.UPFrameConnect:SetPoint ("bottomleft", baseframe, "topleft", 0, -1)
	baseframe.UPFrameConnect:SetPoint ("bottomright", baseframe, "topright", 0, -1)
	baseframe.UPFrameConnect:SetHeight (2)
	baseframe.UPFrameConnect:EnableMouse (true)
	baseframe.UPFrameConnect:SetMovable (true)
	baseframe.UPFrameConnect:SetResizable (true)
	baseframe.UPFrameConnect.is_toolbar = true
	
	BGFrame_scripts (baseframe.UPFrameConnect, baseframe, instancia)
	
	baseframe.UPFrameLeftPart = CreateFrame ("frame", "DetailsUpFrameLeftPart"..instancia.meu_id, baseframe)
	baseframe.UPFrameLeftPart:SetPoint ("bottomleft", baseframe, "topleft", 0, 0)
	baseframe.UPFrameLeftPart:SetSize (22, 20)
	baseframe.UPFrameLeftPart:EnableMouse (true)
	baseframe.UPFrameLeftPart:SetMovable (true)
	baseframe.UPFrameLeftPart:SetResizable (true)
	baseframe.UPFrameLeftPart.is_toolbar = true
	
	BGFrame_scripts (baseframe.UPFrameLeftPart, baseframe, instancia)

	--> anchors para os micro displays no lado de cima da janela
	local StatusBarLeftAnchor = CreateFrame ("frame", "DetailsStatusBarLeftAnchor" .. instancia.meu_id, baseframe)
	StatusBarLeftAnchor:SetPoint ("bottomleft", baseframe, "topleft", 0, 9)
	StatusBarLeftAnchor:SetWidth (1)
	StatusBarLeftAnchor:SetHeight (1)
	baseframe.cabecalho.StatusBarLeftAnchor = StatusBarLeftAnchor
	
	local StatusBarCenterAnchor = CreateFrame ("frame", "DetailsStatusBarCenterAnchor" .. instancia.meu_id, baseframe)
	StatusBarCenterAnchor:SetPoint ("center", baseframe, "center")
	StatusBarCenterAnchor:SetPoint ("bottom", baseframe, "top", 0, 9)
	StatusBarCenterAnchor:SetWidth (1)
	StatusBarCenterAnchor:SetHeight (1)
	baseframe.cabecalho.StatusBarCenterAnchor = StatusBarCenterAnchor	

	local StatusBarRightAnchor = CreateFrame ("frame", "DetailsStatusBarRightAnchor" .. instancia.meu_id, baseframe)
	StatusBarRightAnchor:SetPoint ("bottomright", baseframe, "topright", 0, 9)
	StatusBarRightAnchor:SetWidth (1)
	StatusBarRightAnchor:SetHeight (1)
	baseframe.cabecalho.StatusBarRightAnchor = StatusBarRightAnchor
	
	local MenuAnchorLeft = CreateFrame ("frame", "DetailsMenuAnchorLeft"..instancia.meu_id, baseframe)
	MenuAnchorLeft:SetSize (1, 1)
	
	local MenuAnchorRight = CreateFrame ("frame", "DetailsMenuAnchorRight"..instancia.meu_id, baseframe)
	MenuAnchorRight:SetSize (1, 1)
	
	local Menu2AnchorRight = CreateFrame ("frame", "DetailsMenu2AnchorRight"..instancia.meu_id, baseframe)
	Menu2AnchorRight:SetSize (1, 1)
	
	instancia.menu_points = {MenuAnchorLeft, MenuAnchorRight}
	instancia.menu2_points = {Menu2AnchorRight}
	
-- bot�es	
------------------------------------------------------------------------------------------------------------------------------------------------- 	

	local CoolTip = _G.GameCooltip

	--> SELE��O DO MODO ----------------------------------------------------------------------------------------------------------------------------------------------------
	local modo_selecao_button_click = function()
		if (_detalhes.instances_menu_click_to_open) then
			if (instancia.LastMenuOpened == "mode" and GameCooltipFrame1:IsShown()) then
				GameCooltip:ShowMe (false)
				instancia.LastMenuOpened = nil
			else		
				modo_selecao_on_enter (instancia.baseframe.cabecalho.modo_selecao.widget, _, true, true)
				instancia.LastMenuOpened = "mode"
			end
		else
			_detalhes:OpenOptionsWindow (instancia)
		end
	end
	
	baseframe.cabecalho.modo_selecao = gump:NewButton (baseframe, nil, "DetailsModeButton"..instancia.meu_id, nil, 16, 16, modo_selecao_button_click, nil, nil, [[Interface\AddOns\Details\images\modo_icone]])
	baseframe.cabecalho.modo_selecao:SetPoint ("bottomleft", baseframe.cabecalho.ball, "bottomright", instancia.menu_anchor [1], instancia.menu_anchor [2])
	baseframe.cabecalho.modo_selecao:SetFrameLevel (baseframe:GetFrameLevel()+5)
	baseframe.cabecalho.modo_selecao.widget._instance = instancia
	
	baseframe.cabecalho.modo_selecao:SetScript ("OnEnter", modo_selecao_on_enter)
	baseframe.cabecalho.modo_selecao:SetScript ("OnLeave", modo_selecao_on_leave)
	
	local b = baseframe.cabecalho.modo_selecao.widget
	b:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetNormalTexture():SetTexCoord (0/256, 32/256, 0, 1)
	b:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetHighlightTexture():SetTexCoord (0/256, 32/256, 0, 1)
	b:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetPushedTexture():SetTexCoord (0/256, 32/256, 0, 1)	
	
	
	--> SELECIONAR O SEGMENTO  ----------------------------------------------------------------------------------------------------------------------------------------------------
	local segmento_button_click = function (self, button, param1)
		if (_detalhes.instances_menu_click_to_open) then
			if (instancia.LastMenuOpened == "segments" and GameCooltipFrame1:IsShown()) then
				GameCooltip:ShowMe (false)
				instancia.LastMenuOpened = nil
			else
				segmento_on_enter (instancia.baseframe.cabecalho.segmento.widget, _, true, true)
				instancia.LastMenuOpened = "segments"
			end
		else
			click_to_change_segment (instancia, button)
		end
	end
	
	baseframe.cabecalho.segmento = gump:NewButton (baseframe, nil, "DetailsSegmentButton"..instancia.meu_id, nil, 16, 16, segmento_button_click, nil, nil, [[Interface\AddOns\Details\images\segmentos_icone]])
	baseframe.cabecalho.segmento:SetFrameLevel (baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.cabecalho.segmento.widget._instance = instancia
	baseframe.cabecalho.segmento:SetPoint ("left", baseframe.cabecalho.modo_selecao, "right", 0, 0)
	
	--> ativa bot�o do meio e direito
	baseframe.cabecalho.segmento:SetClickFunction (segmento_button_click, nil, nil, "rightclick")

	baseframe.cabecalho.segmento:SetScript ("OnEnter", segmento_on_enter)
	baseframe.cabecalho.segmento:SetScript ("OnLeave", segmento_on_leave)	
	
	local b = baseframe.cabecalho.segmento.widget
	b:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetNormalTexture():SetTexCoord (32/256, 64/256, 0, 1)
	b:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetHighlightTexture():SetTexCoord (32/256, 64/256, 0, 1)
	b:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetPushedTexture():SetTexCoord (32/256, 64/256, 0, 1)

	--> SELECIONAR O ATRIBUTO  ----------------------------------------------------------------------------------------------------------------------------------------------------
	local atributo_button_click = function()
		if (_detalhes.instances_menu_click_to_open) then
			if (instancia.LastMenuOpened == "attributes" and GameCooltipFrame1:IsShown()) then
				GameCooltip:ShowMe (false)
				instancia.LastMenuOpened = nil
			else
				atributo_on_enter (instancia.baseframe.cabecalho.atributo.widget, _, true, true)
				instancia.LastMenuOpened = "attributes"
			end
		end
	end
	
	baseframe.cabecalho.atributo = gump:NewButton (baseframe, nil, "DetailsAttributeButton"..instancia.meu_id, nil, 16, 16, atributo_button_click)
	baseframe.cabecalho.atributo:SetFrameLevel (baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.cabecalho.atributo.widget._instance = instancia
	baseframe.cabecalho.atributo:SetPoint ("left", baseframe.cabecalho.segmento.widget, "right", 0, 0)

	baseframe.cabecalho.atributo:SetScript ("OnEnter", atributo_on_enter)
	baseframe.cabecalho.atributo:SetScript ("OnLeave", atributo_on_leave)	
	
	local b = baseframe.cabecalho.atributo.widget
	b:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetNormalTexture():SetTexCoord (66/256, 93/256, 0, 1)
	b:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetHighlightTexture():SetTexCoord (68/256, 93/256, 0, 1)
	b:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetPushedTexture():SetTexCoord (68/256, 93/256, 0, 1)
	
	--> REPORTAR ~report ----------------------------------------------------------------------------------------------------------------------------------------------------
	local report_func = function()
		instancia:Reportar ("INSTANCE" .. instancia.meu_id)
		GameCooltip2:Hide()
	end
	baseframe.cabecalho.report = gump:NewButton (baseframe, nil, "DetailsReportButton"..instancia.meu_id, nil, 8, 16, report_func)
	baseframe.cabecalho.report:SetFrameLevel (baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.cabecalho.report.widget._instance = instancia
	baseframe.cabecalho.report:SetPoint ("left", baseframe.cabecalho.atributo, "right", -6, 0)

	baseframe.cabecalho.report:SetScript ("OnEnter", report_on_enter)
	baseframe.cabecalho.report:SetScript ("OnLeave", report_on_leave)

	local b = baseframe.cabecalho.report.widget
	b:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetNormalTexture():SetTexCoord (96/256, 128/256, 0, 1)
	b:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetHighlightTexture():SetTexCoord (96/256, 128/256, 0, 1)
	b:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetPushedTexture():SetTexCoord (96/256, 128/256, 0, 1)
			
			
	
-- ~delete ~erase ~reset
--> reset ----------------------------------------------------------------------------------------------------------------------------------------------------

	local reset_func = function()
		if (_detalhes.instances_menu_click_to_open) then
			if (instancia.LastMenuOpened == "reset" and GameCooltipFrame1:IsShown()) then
				GameCooltip:ShowMe (false)
				instancia.LastMenuOpened = nil
			else
				reset_button_onenter (instancia.baseframe.cabecalho.reset, _, true, true)
				instancia.LastMenuOpened = "reset"
			end
		else
			if (not _detalhes.disable_reset_button) then
				_detalhes.tabela_historico:resetar() 
			else
				_detalhes:Msg (Loc ["STRING_OPTIONS_DISABLED_RESET"])
			end
		end
	end

	baseframe.cabecalho.reset = CreateFrame ("button", "DetailsClearSegmentsButton" .. instancia.meu_id, baseframe)
	baseframe.cabecalho.reset:SetFrameLevel (baseframe.UPFrame:GetFrameLevel()+1)
	baseframe.cabecalho.reset:SetSize (10, 16)
	baseframe.cabecalho.reset:SetPoint ("right", baseframe.cabecalho.novo, "left")
	baseframe.cabecalho.reset.instance = instancia
	baseframe.cabecalho.reset._instance = instancia
	
	baseframe.cabecalho.reset:SetScript ("OnClick", reset_func)
	baseframe.cabecalho.reset:SetScript ("OnEnter", reset_button_onenter)
	baseframe.cabecalho.reset:SetScript ("OnLeave", reset_button_onleave)
	
	local b = baseframe.cabecalho.reset
	b:SetNormalTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetNormalTexture():SetTexCoord (128/256, 160/256, 0, 1)
	b:SetHighlightTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetHighlightTexture():SetTexCoord (128/256, 160/256, 0, 1)
	b:SetPushedTexture ([[Interface\AddOns\Details\images\toolbar_icons]])
	b:GetPushedTexture():SetTexCoord (128/256, 160/256, 0, 1)

end
