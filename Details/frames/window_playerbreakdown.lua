--errors ~pet

local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local gump = 			_detalhes.gump
local _
--lua locals
--local _string_len = string.len
local _math_floor = math.floor
local _ipairs = ipairs
local _pairs = pairs
local _type = type
--api locals
local _CreateFrame = CreateFrame
local _GetTime = GetTime
local _GetSpellInfo = _detalhes.getspellinfo
local _GetCursorPosition = GetCursorPosition
local _unpack = unpack

local atributos = _detalhes.atributos
local sub_atributos = _detalhes.sub_atributos

local info = _detalhes.playerDetailWindow
local classe_icones = _G.CLASS_ICON_TCOORDS
local container3_bars_pointFunc

local SummaryWidgets = {}
local CurrentTab = "Summary"
local IconTexCoord = {5/64, 59/64, 5/64, 59/64}

local CONST_BAR_HEIGHT = 20
local CONST_TARGET_HEIGHT = 18

local PLAYER_DETAILS_WINDOW_WIDTH = 890
local PLAYER_DETAILS_WINDOW_HEIGHT = 574

local PLAYER_DETAILS_STATUSBAR_HEIGHT = 20
local PLAYER_DETAILS_STATUSBAR_ALPHA = 1

local containerSettings = {
	spells = {
		width = 419,
		height = 290,
		point = {"TOPLEFT", DetailsPlayerDetailsWindow, "TOPLEFT", 2, -76},
		scrollHeight = 264,
	},
	targets = {
		width = 418,
		height = 150,
		point = {"BOTTOMLEFT", DetailsPlayerDetailsWindow, "BOTTOMLEFT", 2, 6 + PLAYER_DETAILS_STATUSBAR_HEIGHT},
	},
}

local spellInfoSettings = {
	width = 430,
	amount = 6,
}

------------------------------------------------------------------------------------------------------------------------------
--self = instancia
--jogador = classe_damage ou classe_heal

--return the combat being used to show the data in the opened breakdown window
function Details:GetCombatFromBreakdownWindow()
	return info.instancia and info.instancia.showing
end

--return the window that requested to open the player breakdown window
function Details:GetActiveWindowFromBreakdownWindow()
	return info.instancia
end

--return if the breakdown window is showing damage or heal
function Details:GetDisplayTypeFromBreakdownWindow()
	return info.atributo, info.sub_atributo
end

--return the actor object in use by the breakdown window
function Details:GetPlayerObjectFromBreakdownWindow()
	return info.jogador
end

--english alias
--window object from Details:GetWindow(n) and playerObject from Details:GetPlayer(playerName, attribute)
function Details:OpenPlayerBreakdown (windowObject, playerObject)
	windowObject:AbreJanelaInfo (playerObject)
end

function _detalhes:AbreJanelaInfo (jogador, from_att_change, refresh, ShiftKeyDown, ControlKeyDown)

	--print (debugstack())

	if (not _detalhes.row_singleclick_overwrite [self.atributo] or not _detalhes.row_singleclick_overwrite [self.atributo][self.sub_atributo]) then
		_detalhes:FechaJanelaInfo()
		return
	elseif (_type (_detalhes.row_singleclick_overwrite [self.atributo][self.sub_atributo]) == "function") then
		if (from_att_change) then
			_detalhes:FechaJanelaInfo()
			return
		end
		return _detalhes.row_singleclick_overwrite [self.atributo][self.sub_atributo] (_, jogador, self, ShiftKeyDown, ControlKeyDown)
	end
	
	if (self.modo == _detalhes._detalhes_props["MODO_RAID"]) then
		_detalhes:FechaJanelaInfo()
		return
	end

	--> _detalhes.info_jogador armazena o jogador que esta sendo mostrado na janela de detalhes
	if (info.jogador and info.jogador == jogador and self and info.atributo and self.atributo == info.atributo and self.sub_atributo == info.sub_atributo and not refresh) then
		_detalhes:FechaJanelaInfo() --> se clicou na mesma barra ent�o fecha a janela de detalhes
		return
	elseif (not jogador) then
		_detalhes:FechaJanelaInfo()
		return
	end

	if (info.barras1) then
		for index, barra in ipairs (info.barras1) do 
			barra.other_actor = nil
		end
	end
	
	if (info.barras2) then
		for index, barra in ipairs (info.barras2) do 
			barra.icone:SetTexture (nil)
			barra.icone:SetTexCoord (0, 1, 0, 1)
		end
	end
	
	--> passar os par�metros para dentro da tabela da janela.

	info.ativo = true --> sinaliza o addon que a janela esta aberta
	info.atributo = self.atributo --> instancia.atributo -> grava o atributo (damage, heal, etc)
	info.sub_atributo = self.sub_atributo --> instancia.sub_atributo -> grava o sub atributo (damage done, dps, damage taken, etc)
	info.jogador = jogador --> de qual jogador (objeto classe_damage)
	info.instancia = self --> salva a refer�ncia da inst�ncia que pediu o info
	
	info.target_text = Loc ["STRING_TARGETS"] .. ":"
	info.target_member = "total"
	info.target_persecond = false
	
	info.mostrando = nil
	
	local nome = info.jogador.nome --> nome do jogador
	local atributo_nome = sub_atributos[info.atributo].lista [info.sub_atributo] .. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"] --> // nome do atributo // precisa ser o sub atributo correto???
	
	--> removendo o nome da realm do jogador
	if (nome:find ("-")) then
		nome = nome:gsub (("-.*"), "")
	end

	if (info.instancia.atributo == 1 and info.instancia.sub_atributo == 6) then --> enemy
		atributo_nome = sub_atributos [info.atributo].lista [1] .. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"]
	end

	info.nome:SetText (nome)
	info.atributo_nome:SetText (atributo_nome)

	local serial = jogador.serial
	local avatar
	if (serial ~= "") then
		avatar = NickTag:GetNicknameTable (serial)
	end
	
	if (avatar and avatar [1]) then
		info.nome:SetText ((not _detalhes.ignore_nicktag and avatar [1]) or nome)
	end
	
	if (avatar and avatar [2]) then

		info.avatar:SetTexture (avatar [2])
		info.avatar_bg:SetTexture (avatar [4])
		if (avatar [5]) then
			info.avatar_bg:SetTexCoord (unpack (avatar [5]))
		end
		if (avatar [6]) then
			info.avatar_bg:SetVertexColor (unpack (avatar [6]))
		end
		
		info.avatar_nick:SetText (avatar [1] or nome)
		info.avatar_attribute:SetText (atributo_nome)
		
		info.avatar_attribute:SetPoint ("CENTER", info.avatar_nick, "CENTER", 0, 14)
		info.avatar:Show()
		info.avatar_bg:Show()
		info.avatar_bg:SetAlpha (.65)
		info.avatar_nick:Show()
		info.avatar_attribute:Show()
		info.nome:Hide()
		info.atributo_nome:Hide()
		
	else
	
		info.avatar:Hide()
		info.avatar_bg:Hide()
		info.avatar_nick:Hide()
		info.avatar_attribute:Hide()
		
		info.nome:Show()
		info.atributo_nome:Show()
	end
	
	info.atributo_nome:SetPoint ("CENTER", info.nome, "CENTER", 0, 14)
	
	info.no_targets:Hide()
	info.no_targets.text:Hide()
	gump:TrocaBackgroundInfo (info)
	
	gump:HidaAllBarrasInfo()
	gump:HidaAllBarrasAlvo()
	gump:HidaAllDetalheInfo()
	
	gump:JI_AtualizaContainerBarras (-1)
	
	local classe = jogador.classe
	
	if (not classe) then
		classe = "monster"
	end
	
	--info.classe_icone:SetTexture ("Interface\\AddOns\\Details\\images\\"..classe:lower()) --> top left
	info.classe_icone:SetTexture ("Interface\\AddOns\\Details\\images\\classes") --> top left
	info.SetClassIcon (jogador, classe)

	if (_detalhes.player_details_window.skin == "WoWClassic") then
		if (jogador.grupo and IsInRaid() and not avatar) then
			for i = 1, GetNumGroupMembers() do
				local playerName, realmName = UnitName ("raid" .. i)
				if (realmName and realmName ~= "") then
					playerName = playerName .. "-" .. realmName
				end
				if (playerName == jogador.nome) then
					SetPortraitTexture (info.classe_icone, "raid" .. i)
					info.classe_icone:SetTexCoord (0, 1, 0, 1)
					break
				end
			end
		end
	end
	
	info:ShowTabs()
	gump:Fade (info, 0)
	
	--check which tab was selected and reopen that tab
	if (info.selectedTab == "Summary") then
		return jogador:MontaInfo()
	else
		--open tab
		for index = 1, #_detalhes.player_details_tabs do
			local tab = _detalhes.player_details_tabs [index]
			if (tab:condition (info.jogador, info.atributo, info.sub_atributo)) then
				if (tab.tabname == info.selectedTab) then
					--_detalhes.player_details_tabs [index]:Click()
					--_detalhes.player_details_tabs [index].onclick()
					_detalhes.player_details_tabs [index]:OnShowFunc()
				end
			end
		end
	end
end

-- for beta todo: info background need a major rewrite
function gump:TrocaBackgroundInfo()

	info.bg3_sec_texture:Hide()
	info.bg2_sec_texture:Hide()

	info.apoio_icone_esquerdo:Show()
	info.apoio_icone_direito:Show()
	
	info.report_direita:Hide()
	
	for i = 1, spellInfoSettings.amount do
		info ["right_background" .. i]:Show()
	end
	
	if (info.atributo == 1) then --> DANO
	
		if (info.sub_atributo == 1 or info.sub_atributo == 2) then --> damage done / dps
			info.bg1_sec_texture:SetTexture (nil)
			info.tipo = 1
			
			if (info.sub_atributo == 2) then
				info.targets:SetText (Loc ["STRING_TARGETS"] .. " " .. Loc ["STRING_ATTRIBUTE_DAMAGE_DPS"] .. ":")
				info.target_persecond = true
			else
				info.targets:SetText (Loc ["STRING_TARGETS"] .. ":")
			end
			
		elseif (info.sub_atributo == 3) then --> damage taken

			--info.bg1_sec_texture:SetTexture ([[Interface\AddOns\Details\images\info_window_damagetaken]])
			info.bg1_sec_texture:SetColorTexture (.05, .05, .05, .4)
			info.bg3_sec_texture:Show()
			info.bg2_sec_texture:Show()
			info.tipo = 2

			for i = 1, spellInfoSettings.amount do
				info ["right_background" .. i]:Hide()
			end
			
			info.targets:SetText (Loc ["STRING_TARGETS"] .. ":")
			info.no_targets:Show()
			info.no_targets.text:Show()
			
			info.apoio_icone_esquerdo:Hide()
			info.apoio_icone_direito:Hide()
			info.report_direita:Show()
			
		elseif (info.sub_atributo == 4) then --> friendly fire
			--info.bg1_sec_texture:SetTexture ([[Interface\AddOns\Details\images\info_window_damagetaken]])
			info.bg1_sec_texture:SetColorTexture (.05, .05, .05, .4)
			info.bg3_sec_texture:Show()
			info.bg2_sec_texture:Show()
			info.tipo = 3
			
			for i = 1, spellInfoSettings.amount do
				info ["right_background" .. i]:Hide()
			end
			
			info.targets:SetText (Loc ["STRING_SPELLS"] .. ":")
			
			info.apoio_icone_esquerdo:Hide()
			info.apoio_icone_direito:Hide()
			info.report_direita:Show()
			
		elseif (info.sub_atributo == 6) then --> enemies
			--info.bg1_sec_texture:SetTexture ([[Interface\AddOns\Details\images\info_window_damagetaken]])
			info.bg1_sec_texture:SetColorTexture (.05, .05, .05, .4)
			info.bg3_sec_texture:Show()
			info.bg2_sec_texture:Show()
			info.tipo = 3
			
			for i = 1, spellInfoSettings.amount do
				info ["right_background" .. i]:Hide()
			end
			
			info.targets:SetText (Loc ["STRING_DAMAGE_TAKEN_FROM"])
		end
		
	elseif (info.atributo == 2) then --> HEALING
		if (info.sub_atributo == 1 or info.sub_atributo == 2 or info.sub_atributo == 3) then --> damage done / dps
			info.bg1_sec_texture:SetTexture (nil)
			info.tipo = 1
			
			if (info.sub_atributo == 3) then
				info.targets:SetText (Loc ["STRING_OVERHEALED"] .. ":")
				info.target_member = "overheal"
				info.target_text = Loc ["STRING_OVERHEALED"] .. ":"
			elseif (info.sub_atributo == 2) then
				info.targets:SetText (Loc ["STRING_TARGETS"] .. " " .. Loc ["STRING_ATTRIBUTE_HEAL_HPS"] .. ":")
				info.target_persecond = true
			else
				info.targets:SetText (Loc ["STRING_TARGETS"] .. ":")
			end
			
		elseif (info.sub_atributo == 4) then --> Healing taken
			info.bg1_sec_texture:SetColorTexture (.05, .05, .05, .4)
			info.bg3_sec_texture:Show()
			info.bg2_sec_texture:Show()
			info.tipo = 2

			for i = 1, spellInfoSettings.amount do
				info ["right_background" .. i]:Hide()
			end
			
			info.targets:SetText (Loc ["STRING_TARGETS"] .. ":")
			info.no_targets:Show()
			info.no_targets.text:Show()
			
			info.apoio_icone_esquerdo:Hide()
			info.apoio_icone_direito:Hide()
			info.report_direita:Show()
		end
		
	elseif (info.atributo == 3) then --> REGEN
		info.bg1_sec_texture:SetTexture (nil)
		info.tipo = 2
		info.targets:SetText ("Vindo de:")
	
	elseif (info.atributo == 4) then --> MISC
		info.bg1_sec_texture:SetTexture (nil)
		info.tipo = 2

		info.targets:SetText (Loc ["STRING_TARGETS"] .. ":")
	end
end

--> self � qualquer coisa que chamar esta fun��o
------------------------------------------------------------------------------------------------------------------------------
-- � chamado pelo click no X e pelo reset do historico
function _detalhes:FechaJanelaInfo (fromEscape)
	if (info.ativo) then --> se a janela tiver aberta
		--playerDetailWindow:Hide()
		if (fromEscape) then
			gump:Fade (info, "in")
		else
			gump:Fade (info, 1)
		end
		info.ativo = false --> sinaliza o addon que a janela esta agora fechada
		
		--_detalhes.info_jogador.detalhes = nil
		info.jogador = nil
		info.atributo = nil
		info.sub_atributo = nil
		info.instancia = nil
		
		info.nome:SetText ("")
		info.atributo_nome:SetText ("")
		
		gump:JI_AtualizaContainerBarras (-1) --> reseta o frame das barras			
	end
end

--> esconde todas as barras das skills na janela de info
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllBarrasInfo()
	local barras = _detalhes.playerDetailWindow.barras1
	for index = 1, #barras, 1 do
		barras [index]:Hide()
		barras [index].textura:SetStatusBarColor (1, 1, 1, 1)
		barras [index].on_focus = false
	end
end

--> esconde todas as barras dos alvos do jogador
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllBarrasAlvo()
	local barras = _detalhes.playerDetailWindow.barras2
	for index = 1, #barras, 1 do
		barras [index]:Hide()
	end
end

--> esconde as 5 barras a direita na janela de info
------------------------------------------------------------------------------------------------------------------------------
function gump:HidaAllDetalheInfo()
	for i = 1, spellInfoSettings.amount do
		gump:HidaDetalheInfo (i)
	end
	for _, barra in _ipairs (info.barras3) do 
		barra:Hide()
	end
	_detalhes.playerDetailWindow.spell_icone:SetTexture ("")
end


--> seta os scripts da janela de informa��es
local mouse_down_func = function (self, button)
	if (button == "LeftButton") then
		info:StartMoving()
		info.isMoving = true
	elseif (button == "RightButton" and not self.isMoving) then
		_detalhes:FechaJanelaInfo()
	end
end

local mouse_up_func = function (self, button)
	if (info.isMoving) then
		info:StopMovingOrSizing()
		info.isMoving = false
	end
end

------------------------------------------------------------------------------------------------------------------------------
local function seta_scripts (este_gump)

	--> Janela
	este_gump:SetScript ("OnMouseDown", mouse_down_func)
	este_gump:SetScript ("OnMouseUp", mouse_up_func)

	este_gump.container_barras.gump:SetScript ("OnMouseDown", mouse_down_func)
	este_gump.container_barras.gump:SetScript ("OnMouseUp", mouse_up_func)
					
	este_gump.container_detalhes:SetScript ("OnMouseDown", mouse_down_func)
	este_gump.container_detalhes:SetScript ("OnMouseUp", mouse_up_func)

	este_gump.container_alvos.gump:SetScript ("OnMouseDown", mouse_down_func)
	este_gump.container_alvos.gump:SetScript ("OnMouseUp", mouse_up_func)

	--> bot�o fechar
	este_gump.close_button:SetScript ("OnClick", function (self) 
		_detalhes:FechaJanelaInfo()
	end)
end



------------------------------------------------------------------------------------------------------------------------------
function gump:HidaDetalheInfo (index)
	local info = _detalhes.playerDetailWindow.grupos_detalhes [index]
	info.nome:SetText ("")
	info.nome2:SetText ("")
	info.dano:SetText ("")
	info.dano_porcento:SetText ("")
	info.dano_media:SetText ("")
	info.dano_dps:SetText ("")
	info.bg:Hide()
end

--> cria a barra de detalhes a direita da janela de informa��es
------------------------------------------------------------------------------------------------------------------------------

local detalhe_infobg_onenter = function (self)
	gump:Fade (self.overlay, "OUT") 
	gump:Fade (self.reportar, "OUT")
end

local detalhe_infobg_onleave = function (self)
	gump:Fade (self.overlay, "IN")
	gump:Fade (self.reportar, "IN")
end

local detalhes_inforeport_onenter = function (self)
	gump:Fade (self:GetParent().overlay, "OUT")
	gump:Fade (self, "OUT")
end
local detalhes_inforeport_onleave = function (self)
	gump:Fade (self:GetParent().overlay, "IN")
	gump:Fade (self, "IN")
end

function gump:CriaDetalheInfo (index)
	local info = {}
	
	info.bg = _CreateFrame ("StatusBar", "DetailsPlayerDetailsWindow_DetalheInfoBG" .. index, _detalhes.playerDetailWindow.container_detalhes, "BackdropTemplate")
	info.bg:SetStatusBarTexture ("Interface\\AddOns\\Details\\images\\bar_detalhes2")
	info.bg:SetStatusBarColor (1, 1, 1, .84)
	info.bg:SetMinMaxValues (0, 100)
	info.bg:SetValue (100)
	info.bg:SetSize (320, 47)
	
	info.nome = info.bg:CreateFontString (nil, "OVERLAY", "GameFontNormal")
	info.nome2 = info.bg:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	info.dano = info.bg:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	info.dano_porcento = info.bg:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	info.dano_media = info.bg:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	info.dano_dps = info.bg:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	
	info.bg.overlay = info.bg:CreateTexture ("DetailsPlayerDetailsWindow_DetalheInfoBG_Overlay" .. index, "ARTWORK")
	info.bg.overlay:SetTexture ("Interface\\AddOns\\Details\\images\\overlay_detalhes")
	info.bg.overlay:SetWidth (341)
	info.bg.overlay:SetHeight (61)
	info.bg.overlay:SetPoint ("TOPLEFT", info.bg, "TOPLEFT", -7, 6)
	gump:Fade (info.bg.overlay, 1)
	
	info.bg.reportar = gump:NewDetailsButton (info.bg, nil, nil, _detalhes.Reportar, _detalhes.playerDetailWindow, 10+index, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsJanelaInfoReport1")
	info.bg.reportar:SetPoint ("BOTTOMLEFT", info.bg.overlay, "BOTTOMRIGHT",  -33, 10)
	gump:Fade (info.bg.reportar, 1)
	
	info.bg:SetScript ("OnEnter", detalhe_infobg_onenter)
	info.bg:SetScript ("OnLeave", detalhe_infobg_onleave)

	info.bg.reportar:SetScript ("OnEnter", detalhes_inforeport_onenter)
	info.bg.reportar:SetScript ("OnLeave", detalhes_inforeport_onleave)

	info.bg_end = info.bg:CreateTexture ("DetailsPlayerDetailsWindow_DetalheInfoBG_bg_end" .. index, "BACKGROUND")
	info.bg_end:SetHeight (47)
	info.bg_end:SetTexture ("Interface\\AddOns\\Details\\images\\bar_detalhes2_end")

	_detalhes.playerDetailWindow.grupos_detalhes [index] = info
end

function info:SetDetailInfoConfigs (texture, color, x, y)
	for i = 1, spellInfoSettings.amount do
		if (texture) then
			info.grupos_detalhes [i].bg:SetStatusBarTexture (texture)
		end
		
		if (color) then
			local texture = info.grupos_detalhes [i].bg:GetStatusBarTexture()
			texture:SetVertexColor (unpack (color))
		end
		
		if (x or y) then
			gump:SetaDetalheInfoAltura (i, x, y)
		end
	end
end

--> determina qual a pocis�o que a barra de detalhes vai ocupar
------------------------------------------------------------------------------------------------------------------------------
function gump:SetaDetalheInfoAltura (index, xmod, ymod)
	local info = _detalhes.playerDetailWindow.grupos_detalhes [index]
	local janela =  _detalhes.playerDetailWindow.container_detalhes
	
	local altura = {-10, -63, -118, -173, -228, -279}
	
	local x1 = 64 + (xmod or 0)
	local x2 = 00 + (ymod or 0)
	
	altura = altura [index]
	
	local background
	
	local y = -74 - ((index-1) * 79.5)
	
	if (index == 1) then
		_detalhes.playerDetailWindow.right_background1:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background1
		
	elseif (index == 2) then
		_detalhes.playerDetailWindow.right_background2:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background2
		
	elseif (index == 3) then
		_detalhes.playerDetailWindow.right_background3:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background3
		
	elseif (index == 4) then
		_detalhes.playerDetailWindow.right_background4:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background4
		
	elseif (index == 5) then
		_detalhes.playerDetailWindow.right_background5:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background5
		
	elseif (index == 6) then
		_detalhes.playerDetailWindow.right_background6:SetPoint ("topleft", _detalhes.playerDetailWindow, "topleft", 357 + (xmod or 0), y)
		background = _detalhes.playerDetailWindow.right_background6
		
	end
	
	background:SetHeight (75)
	
	--3 textos da esquerda e direita
	local y = -3
	local x = 3
	local right = -1
	
	info.nome:SetPoint ("TOPLEFT", background, "TOPLEFT", x, y + (-2))
	info.dano:SetPoint ("TOPLEFT", background, "TOPLEFT", x, y + (-24))
	info.dano_media:SetPoint ("TOPLEFT", background, "TOPLEFT", x, y + (-44))
	
	info.nome2:SetPoint ("TOPRIGHT", background, "TOPRIGHT", -x + right,  y + (-2))
	info.dano_porcento:SetPoint ("TOPRIGHT", background, "TOPRIGHT", -x + right, y + (-24))
	info.dano_dps:SetPoint ("TOPRIGHT", background, "TOPRIGHT", -x + right, y + (-44))
	
	info.bg:SetPoint ("TOPLEFT", background, "TOPLEFT", 1, -1)
	info.bg:SetHeight (background:GetHeight() - 2)
	info.bg:SetWidth (background:GetWidth())
	
	info.bg_end:SetPoint ("LEFT", info.bg, "LEFT", info.bg:GetValue()*2.19, 0)
	info.bg_end:SetHeight (background:GetHeight()+2)
	info.bg_end:SetWidth (6)
	info.bg_end:SetAlpha (.75)
	
	info.bg.overlay:SetWidth (background:GetWidth() + 24)
	info.bg.overlay:SetHeight (background:GetHeight() + 16)
	
	info.bg:Hide()
end

--> seta o conte�do da barra de detalhes
------------------------------------------------------------------------------------------------------------------------------
function gump:SetaDetalheInfoTexto (index, p, arg1, arg2, arg3, arg4, arg5, arg6)
	local info = _detalhes.playerDetailWindow.grupos_detalhes [index]
	
	if (p) then
		if (_type (p) == "table") then
			info.bg:SetValue (p.p)
			info.bg:SetStatusBarColor (p.c[1], p.c[2], p.c[3], p.c[4] or 1)
		else
			info.bg:SetValue (p)
			info.bg:SetStatusBarColor (1, 1, 1, .5)
		end

		info.bg_end:Show()
		info.bg_end:SetPoint ("LEFT", info.bg, "LEFT", (info.bg:GetValue() * (info.bg:GetWidth( ) / 100)) - 3, 0) -- 2.19
		info.bg:Show()
	end
	
	if (info.IsPet) then 
		info.bg.PetIcon:Hide()
		info.bg.PetText:Hide()
		info.bg.PetDps:Hide()
		gump:Fade (info.bg.overlay, "IN")
		info.IsPet = false
	end
	
	if (arg1) then
		info.nome:SetText (arg1)
	end
	
	if (arg2) then
		info.dano:SetText (arg2)
	end
	
	if (arg3) then
		info.dano_porcento:SetText (arg3)
	end
	
	if (arg4) then
		info.dano_media:SetText (arg4)
	end
	
	if (arg5) then
		info.dano_dps:SetText (arg5)
	end
	
	if (arg6) then
		info.nome2:SetText (arg6)
	end
	
	info.nome:Show()
	info.dano:Show()
	info.dano_porcento:Show()
	info.dano_media:Show()
	info.dano_dps:Show()
	info.nome2:Show()
	
end

--> cria as 5 caixas de detalhes infos que ser�o usados
------------------------------------------------------------------------------------------------------------------------------
local function cria_barras_detalhes()
	_detalhes.playerDetailWindow.grupos_detalhes = {}
	for i = 1, spellInfoSettings.amount do
		gump:CriaDetalheInfo (i)
		gump:SetaDetalheInfoAltura (i)
	end
end


--> cria os textos em geral da janela info
------------------------------------------------------------------------------------------------------------------------------
local function cria_textos (este_gump, SWW)
	este_gump.nome = este_gump:CreateFontString (nil, "OVERLAY", "QuestFont_Large")
	este_gump.nome:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 105, -54)
	
	este_gump.atributo_nome = este_gump:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	
	este_gump.targets = SWW:CreateFontString (nil, "OVERLAY", "QuestFont_Large")
	este_gump.targets:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 24, -273)
	este_gump.targets:SetText (Loc ["STRING_TARGETS"] .. ":")

	este_gump.avatar = este_gump:CreateTexture (nil, "overlay")
	este_gump.avatar_bg = este_gump:CreateTexture (nil, "overlay")
	este_gump.avatar_attribute = este_gump:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
	este_gump.avatar_nick = este_gump:CreateFontString (nil, "overlay", "QuestFont_Large")
	este_gump.avatar:SetDrawLayer ("overlay", 3)
	este_gump.avatar_bg:SetDrawLayer ("overlay", 2)
	este_gump.avatar_nick:SetDrawLayer ("overlay", 4)
	
	este_gump.avatar:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 60, -10)
	este_gump.avatar_bg:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 60, -12)
	este_gump.avatar_bg:SetSize (275, 60)
	
	este_gump.avatar_nick:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 195, -54)
	
	este_gump.avatar:Hide()
	este_gump.avatar_bg:Hide()
	este_gump.avatar_nick:Hide()
	
end


--> esquerdo superior
local function cria_container_barras (este_gump, SWW)

	local container_barras_window = _CreateFrame ("ScrollFrame", "Details_Info_ContainerBarrasScroll", SWW, "BackdropTemplate")
	local container_barras = _CreateFrame ("Frame", "Details_Info_ContainerBarras", container_barras_window, "BackdropTemplate")

	container_barras:SetAllPoints (container_barras_window)
	container_barras:SetWidth (300)
	container_barras:SetHeight (150)
	container_barras:EnableMouse (true)
	container_barras:SetMovable (true)
	
	container_barras_window:SetWidth (300)
	container_barras_window:SetHeight (145)
	container_barras_window:SetScrollChild (container_barras)
	container_barras_window:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 21, -76)

	container_barras_window:SetScript ("OnSizeChanged", function (self)
		container_barras:SetSize (self:GetSize())
	end)
	
	gump:NewScrollBar (container_barras_window, container_barras, 6, -17)
	container_barras_window.slider:Altura (117)
	container_barras_window.slider:cimaPoint (0, 1)
	container_barras_window.slider:baixoPoint (0, -3)

	container_barras_window.ultimo = 0
	
	container_barras_window.gump = container_barras
	--container_barras_window.slider = slider_gump
	este_gump.container_barras = container_barras_window
	
end

function gump:JI_AtualizaContainerBarras (amt)

	local container = _detalhes.playerDetailWindow.container_barras
	
	if (amt >= 9 and container.ultimo ~= amt) then
		local tamanho = (CONST_BAR_HEIGHT + 1) * amt
		container.gump:SetHeight (tamanho)
		container.slider:Update()
		container.ultimo = amt
		
	elseif (amt < 8 and container.slider.ativo) then
		container.slider:Update (true)
		container.gump:SetHeight (140)
		container.scroll_ativo = false
		container.ultimo = 0
	end
end

function gump:JI_AtualizaContainerAlvos (amt)

	local container = _detalhes.playerDetailWindow.container_alvos
	
	if (amt >= 6 and container.ultimo ~= amt) then
		local tamanho = (CONST_TARGET_HEIGHT + 1) * amt
		container.gump:SetHeight (tamanho)
		container.slider:Update()
		container.ultimo = amt
		
	elseif (amt <= 5 and container.slider.ativo) then
		container.slider:Update (true)
		container.gump:SetHeight (100)
		container.scroll_ativo = false
		container.ultimo = 0
	end
end

--> container direita
local function cria_container_detalhes (este_gump, SWW)
	local container_detalhes = _CreateFrame ("Frame", "Details_Info_ContainerDetalhes", SWW, "BackdropTemplate")
	
	container_detalhes:SetPoint ("TOPRIGHT", este_gump, "TOPRIGHT", -74, -76)
	container_detalhes:SetWidth (220)
	container_detalhes:SetHeight (270)
	container_detalhes:EnableMouse (true)
	container_detalhes:SetResizable (false)
	container_detalhes:SetMovable (true)
	
	este_gump.container_detalhes = container_detalhes
end

--> esquerdo inferior
local function cria_container_alvos (este_gump, SWW)
	local container_alvos_window = _CreateFrame ("ScrollFrame", "Details_Info_ContainerAlvosScroll", SWW, "BackdropTemplate")
	local container_alvos = _CreateFrame ("Frame", "Details_Info_ContainerAlvos", container_alvos_window, "BackdropTemplate")

	container_alvos:SetAllPoints (container_alvos_window)
	container_alvos:SetWidth (300)
	container_alvos:SetHeight (100)
	container_alvos:EnableMouse (true)
	container_alvos:SetMovable (true)
	
	container_alvos_window:SetWidth (300)
	container_alvos_window:SetHeight (100)
	container_alvos_window:SetScrollChild (container_alvos)
	container_alvos_window:SetPoint ("BOTTOMLEFT", este_gump, "BOTTOMLEFT", 20, 6) --56 default

	container_alvos_window:SetScript ("OnSizeChanged", function (self)
		container_alvos:SetSize (self:GetSize())
	end)
	
	gump:NewScrollBar (container_alvos_window, container_alvos, 7, 4)
	container_alvos_window.slider:Altura (88)
	container_alvos_window.slider:cimaPoint (0, 1)
	container_alvos_window.slider:baixoPoint (0, -3)
	
	container_alvos_window.gump = container_alvos
	este_gump.container_alvos = container_alvos_window
end


local default_icon_change = function (jogador, classe)
	if (classe ~= "UNKNOW" and classe ~= "UNGROUPPLAYER") then
		info.classe_icone:SetTexCoord (_detalhes.class_coords [classe][1], _detalhes.class_coords [classe][2], _detalhes.class_coords [classe][3], _detalhes.class_coords [classe][4])
		if (jogador.enemy) then 
			if (_detalhes.faction_against == "Horde") then
				info.nome:SetTextColor (1, 91/255, 91/255, 1)
			else
				info.nome:SetTextColor (151/255, 215/255, 1, 1)
			end
		else
			info.classe_iconePlus:SetTexture()
			info.nome:SetTextColor (1, 1, 1, 1)
		end
	else
		if (jogador.enemy) then 
			if (_detalhes.class_coords [_detalhes.faction_against]) then
				info.classe_icone:SetTexCoord (_unpack (_detalhes.class_coords [_detalhes.faction_against]))
				if (_detalhes.faction_against == "Horde") then
					info.nome:SetTextColor (1, 91/255, 91/255, 1)
				else
					info.nome:SetTextColor (151/255, 215/255, 1, 1)
				end
			else
				info.nome:SetTextColor (1, 1, 1, 1)
			end
		else
			info.classe_icone:SetTexCoord (_detalhes.class_coords ["MONSTER"][1], _detalhes.class_coords ["MONSTER"][2], _detalhes.class_coords ["MONSTER"][3], _detalhes.class_coords ["MONSTER"][4])
		end
		info.classe_iconePlus:SetTexture()
	end
end

function _detalhes:InstallPDWSkin (skin_name, func)
	if (not skin_name) then
		return false -- sem nome
	elseif (_detalhes.playerdetailwindow_skins [skin_name]) then
		return false -- ja existe
	end
	
	_detalhes.playerdetailwindow_skins [skin_name] = func
	return true
end

function _detalhes:ApplyPDWSkin (skin_name)

--already built
	if (not DetailsPlayerDetailsWindow.Loaded) then
		if (skin_name) then
			_detalhes.player_details_window.skin = skin_name
		end
		return
	end

--hide extra frames
	local window = DetailsPlayerDetailsWindow
	if (window.extra_frames) then
		for framename, frame in pairs (window.extra_frames) do
			frame:Hide()
		end
	end

--apply default first
	local default_skin = _detalhes.playerdetailwindow_skins ["WoWClassic"]
	pcall (default_skin.func)
	
--than do the change
	if (not skin_name) then
		skin_name = _detalhes.player_details_window.skin
	end
	
	local skin = _detalhes.playerdetailwindow_skins [skin_name]
	if (skin) then
		local successful, errortext = pcall (skin.func)
		if (not successful) then
			_detalhes:Msg ("error occurred on skin call():", errortext)
			local former_skin = _detalhes.playerdetailwindow_skins [_detalhes.player_details_window.skin]
			pcall (former_skin.func)
		else
			_detalhes.player_details_window.skin = skin_name
		end
	else
		_detalhes:Msg ("skin not found.")
	end
	
	if (info and info:IsShown() and info.jogador and info.jogador.classe) then
		info.SetClassIcon (info.jogador, info.jogador.classe)
	end
	
	_detalhes:ApplyRPSkin (skin_name)
end

function _detalhes:SetPlayerDetailsWindowTexture (texture)
	DetailsPlayerDetailsWindow.bg1:SetTexture (texture)
end

function _detalhes:SetPDWBarConfig (texture)
	local window = DetailsPlayerDetailsWindow

	if (texture) then
		_detalhes.player_details_window.bar_texture = texture
		local texture = SharedMedia:Fetch ("statusbar", texture)
		
		for _, bar in ipairs (window.barras1) do
			bar.textura:SetStatusBarTexture (texture)
		end
		for _, bar in ipairs (window.barras2) do
			bar.textura:SetStatusBarTexture (texture)
		end
		for _, bar in ipairs (window.barras3) do
			bar.textura:SetStatusBarTexture (texture)
		end
	end
end

local default_skin = function()
	local window = DetailsPlayerDetailsWindow
	window.bg1:SetTexture ([[Interface\AddOns\Details\images\info_window_background]])
	window.bg1:SetSize (1024, 512)
	window.bg1:SetAlpha (1)
	window.bg1:SetVertexColor (1, 1, 1)
	window:SetBackdrop (nil)
	window:SetBackdropColor (1, 1, 1, 1)
	window:SetBackdropBorderColor (1, 1, 1, 1)
	window.bg_icone_bg:Show()
	window.bg_icone:Show()
	
	window.leftbars1_backgound:SetPoint ("topleft", window.container_barras, "topleft", -3, 3)
	window.leftbars1_backgound:SetPoint ("bottomright", window.container_barras, "bottomright", 3, -3)
	window.leftbars2_backgound:SetPoint ("topleft", window.container_alvos, "topleft", -3, 23)
	window.leftbars2_backgound:SetPoint ("bottomright", window.container_alvos, "bottomright", 3, 0)
	window.leftbars1_backgound:SetAlpha (1)
	window.leftbars2_backgound:SetAlpha (1)
	window.right_background1:SetAlpha (1)
	window.right_background2:SetAlpha (1)
	window.right_background3:SetAlpha (1)
	window.right_background4:SetAlpha (1)
	window.right_background5:SetAlpha (1)
	
	window.close_button:GetNormalTexture():SetDesaturated (false)
	
	window.title_string:ClearAllPoints()
	window.title_string:SetPoint ("center", window, "center")
	window.title_string:SetPoint ("top", window, "top", 0, -18)
	window.title_string:SetParent (window)
	window.title_string:SetTextColor (.890, .729, .015, 1)
	
	window.classe_icone:SetParent (window)
	window.classe_icone:SetPoint ("TOPLEFT", window, "TOPLEFT", 4, 0)
	window.classe_icone:SetWidth (64)
	window.classe_icone:SetHeight (64)
	window.classe_icone:SetDrawLayer ("BACKGROUND", 1)
	window.classe_icone:SetAlpha (1)
	
	window.close_button:SetWidth (32)
	window.close_button:SetHeight (32)
	window.close_button:SetPoint ("TOPRIGHT", window, "TOPRIGHT", 5, -8)
	
	window.options_button:SetPoint ("topright", window, "topright", -26, -16)
	window.options_button:SetSize (16, 16)
	
	window.avatar:SetParent (window)
	
	_detalhes:SetPDWBarConfig ("Skyline")
	
	--bar container
	window.container_barras:SetSize (300, 145)
	window.container_barras:SetPoint ("TOPLEFT", window, "TOPLEFT", 20, -76)
	
	--target container
	window.container_alvos:SetPoint ("BOTTOMLEFT", window, "BOTTOMLEFT", 20, 6)
	window.container_alvos:SetSize (300, 100)
	
	--icons
	window.SetClassIcon = default_icon_change
	window.apoio_icone_direito:SetBlendMode ("BLEND")
	window.apoio_icone_esquerdo:SetBlendMode ("BLEND")
	
	--texts
	window.targets:SetPoint ("TOPLEFT", window, "TOPLEFT", 24, -273)
	window.nome:SetPoint ("TOPLEFT", window, "TOPLEFT", 105, -54)
	
	--report button
	window.topleft_report:SetPoint ("BOTTOMLEFT", window.container_barras, "TOPLEFT",  33, 3)

	--no targets texture
	window.no_targets:SetPoint ("BOTTOMLEFT", window, "BOTTOMLEFT", 20, 6)
	window.no_targets:SetSize (301, 100)
	window.no_targets:SetAlpha (1)
	
	--right panel textures
	window.bg2_sec_texture:SetPoint ("topleft", window.bg1_sec_texture, "topleft", 8, 0)
	window.bg2_sec_texture:SetPoint ("bottomright", window.bg1_sec_texture, "bottomright", -30, 0)
	window.bg2_sec_texture:SetTexture ([[Interface\Glues\CREDITS\Warlords\Shadowmoon_Color_jlo3]])
	window.bg2_sec_texture:SetDesaturated (true)
	window.bg2_sec_texture:SetAlpha (0.3)

	window.bg3_sec_texture:SetPoint ("topleft", window.bg2_sec_texture, "topleft", 0, 0)
	window.bg3_sec_texture:SetPoint ("bottomright", window.bg2_sec_texture, "bottomright", 0, 0)
	window.bg3_sec_texture:SetTexture (0, 0, 0, 1)
	
	--the 5 spell details blocks
	for i, infoblock in ipairs (_detalhes.playerDetailWindow.grupos_detalhes) do
		infoblock.bg:SetSize (219, 47) --219 original
	end
	local xLocation = {-85, -136, -191, -246, -301, -356}
	local heightTable = {43, 48, 48, 48, 48, 48}
	
	for i = 1, spellInfoSettings.amount do
		window ["right_background" .. i]:SetPoint ("topleft", window, "topleft", 357, xLocation [i]) --357 original
		window ["right_background" .. i]:SetSize (220, heightTable [i]) --220
	end
	
	--info container
	info:SetDetailInfoConfigs ("Interface\\AddOns\\Details\\images\\bar_detalhes2", {1, 1, 1, 0.5}, 0, 0)

	window.bg1_sec_texture:SetPoint ("topleft", window.bg1, "topleft", 348, -86)
	window.bg1_sec_texture:SetHeight (262)
	window.bg1_sec_texture:SetWidth (264)
	
	--container bars 3
	local x_start = 61
	local y_start = -10
	local janela = window.container_detalhes
	
	container3_bars_pointFunc = function (barra, index)
		local y = (index-1) * 17
		y = y*-1
		barra:SetPoint ("LEFT", janela, "LEFT", x_start, 0)
		barra:SetPoint ("RIGHT", janela, "RIGHT", 65, 0)
		barra:SetPoint ("TOP", janela, "TOP", 0, y+y_start)
	end
	
	for index, barra in ipairs (window.barras3) do
		local y = (index-1) * 17
		y = y*-1
		barra:SetPoint ("LEFT", janela, "LEFT", x_start, 0)
		barra:SetPoint ("RIGHT", janela, "RIGHT", 65, 0)
		barra:SetPoint ("TOP", janela, "TOP", 0, y+y_start)
	end

	--scrollbar
	window.container_barras.cima:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	window.container_barras.cima:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	window.container_barras.cima:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	window.container_barras.cima:GetNormalTexture():ClearAllPoints()
	window.container_barras.cima:GetPushedTexture():ClearAllPoints()
	window.container_barras.cima:GetDisabledTexture():ClearAllPoints()
	window.container_barras.cima:GetNormalTexture():SetPoint ("center", window.container_barras.cima, "center", 0, 0)
	window.container_barras.cima:GetPushedTexture():SetPoint ("center", window.container_barras.cima, "center", 0, 0)
	window.container_barras.cima:GetDisabledTexture():SetPoint ("center", window.container_barras.cima, "center", 0, 0)
	window.container_barras.cima:SetSize (29, 32)
	window.container_barras.cima:SetBackdrop (nil)
	
	window.container_barras.baixo:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	window.container_barras.baixo:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	window.container_barras.baixo:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	window.container_barras.baixo:GetNormalTexture():ClearAllPoints()
	window.container_barras.baixo:GetPushedTexture():ClearAllPoints()
	window.container_barras.baixo:GetDisabledTexture():ClearAllPoints()
	window.container_barras.baixo:GetNormalTexture():SetPoint ("center", window.container_barras.baixo, "center", 0, 0)
	window.container_barras.baixo:GetPushedTexture():SetPoint ("center", window.container_barras.baixo, "center", 0, 0)
	window.container_barras.baixo:GetDisabledTexture():SetPoint ("center", window.container_barras.baixo, "center", 0, 0)
	window.container_barras.baixo:SetSize (29, 32)
	window.container_barras.baixo:SetBackdrop (nil)
	
	window.container_barras.slider:SetBackdrop (nil)
	
	window.container_barras.slider:Altura (117)
	window.container_barras.slider:cimaPoint (0, 1)
	window.container_barras.slider:baixoPoint (0, -3)
	window.container_barras.slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	window.container_barras.slider.thumb:SetTexCoord (0, 1, 0, 1)
	window.container_barras.slider.thumb:SetSize (29, 30)
	window.container_barras.slider.thumb:SetVertexColor (1, 1, 1, 1)
	
	--
	window.container_alvos.cima:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	window.container_alvos.cima:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	window.container_alvos.cima:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	window.container_alvos.cima:GetNormalTexture():ClearAllPoints()
	window.container_alvos.cima:GetPushedTexture():ClearAllPoints()
	window.container_alvos.cima:GetDisabledTexture():ClearAllPoints()
	window.container_alvos.cima:GetNormalTexture():SetPoint ("center", window.container_alvos.cima, "center", 0, 0)
	window.container_alvos.cima:GetPushedTexture():SetPoint ("center", window.container_alvos.cima, "center", 0, 0)
	window.container_alvos.cima:GetDisabledTexture():SetPoint ("center", window.container_alvos.cima, "center", 0, 0)
	window.container_alvos.cima:SetSize (29, 32)
	window.container_alvos.cima:SetBackdrop (nil)
	
	window.container_alvos.baixo:SetNormalTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Up")
	window.container_alvos.baixo:SetPushedTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Down")
	window.container_alvos.baixo:SetDisabledTexture ("Interface\\BUTTONS\\UI-ScrollBar-ScrollUpButton-Disabled")
	window.container_alvos.baixo:GetNormalTexture():ClearAllPoints()
	window.container_alvos.baixo:GetPushedTexture():ClearAllPoints()
	window.container_alvos.baixo:GetDisabledTexture():ClearAllPoints()
	window.container_alvos.baixo:GetNormalTexture():SetPoint ("center", window.container_alvos.baixo, "center", 0, 0)
	window.container_alvos.baixo:GetPushedTexture():SetPoint ("center", window.container_alvos.baixo, "center", 0, 0)
	window.container_alvos.baixo:GetDisabledTexture():SetPoint ("center", window.container_alvos.baixo, "center", 0, 0)
	window.container_alvos.baixo:SetSize (29, 32)
	window.container_alvos.baixo:SetBackdrop (nil)

	window.container_alvos.slider:SetBackdrop (nil)

	window.container_alvos.slider:Altura (88)
	window.container_alvos.slider:cimaPoint (0, 1)
	window.container_alvos.slider:baixoPoint (0, -3)

	window.container_alvos.slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
	window.container_alvos.slider.thumb:SetTexCoord (0, 1, 0, 1)
	window.container_alvos.slider.thumb:SetSize (29, 30)
	window.container_alvos.slider.thumb:SetVertexColor (1, 1, 1, 1)

end
_detalhes:InstallPDWSkin ("WoWClassic", {func = default_skin, author = "Details! Team", version = "v1.0", desc = "Default skin."})

local elvui_skin = function()
	local window = DetailsPlayerDetailsWindow
	window.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
	window.bg1:SetAlpha (0.7)
	window.bg1:SetVertexColor (0.27, 0.27, 0.27)
	window.bg1:SetVertTile (true)
	window.bg1:SetHorizTile (true)
	window.bg1:SetSize (PLAYER_DETAILS_WINDOW_WIDTH, PLAYER_DETAILS_WINDOW_HEIGHT)
	
	window:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
	window:SetBackdropColor (1, 1, 1, 1)
	window:SetBackdropBorderColor (0, 0, 0, 1)
	window.bg_icone_bg:Hide()
	window.bg_icone:Hide()
	local bgs_alpha = 0.6
	
	window.leftbars1_backgound:SetPoint ("topleft", window.container_barras, "topleft", -2, 3)
	window.leftbars1_backgound:SetPoint ("bottomright", window.container_barras, "bottomright", 3, -3)
	window.leftbars2_backgound:SetPoint ("topleft", window.container_alvos, "topleft", -2, 23)
	window.leftbars2_backgound:SetPoint ("bottomright", window.container_alvos, "bottomright", 4, 0)
	
	window.leftbars1_backgound:SetAlpha (bgs_alpha)
	window.leftbars2_backgound:SetAlpha (bgs_alpha)
	
	window.right_background1:SetAlpha (bgs_alpha)
	window.right_background2:SetAlpha (bgs_alpha)
	window.right_background3:SetAlpha (bgs_alpha)
	window.right_background4:SetAlpha (bgs_alpha)
	window.right_background5:SetAlpha (bgs_alpha)
	
	window.close_button:GetNormalTexture():SetDesaturated (true)
	
	local titlebar = window.extra_frames ["ElvUITitleBar"]
	if (not titlebar) then
		titlebar = CreateFrame ("frame", nil, window, "BackdropTemplate")
		titlebar:SetPoint ("topleft", window, "topleft", 2, -3)
		titlebar:SetPoint ("topright", window, "topright", -2, -3)
		titlebar:SetHeight (20)
		titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
		titlebar:SetBackdropColor (.5, .5, .5, 1)
		titlebar:SetBackdropBorderColor (0, 0, 0, 1)
		window.extra_frames ["ElvUITitleBar"] = titlebar
		
		local name_bg_texture = window:CreateTexture (nil, "background")
		name_bg_texture:SetTexture ([[Interface\PetBattles\_PetBattleHorizTile]], true)
		name_bg_texture:SetHorizTile (true)
		name_bg_texture:SetTexCoord (0, 1, 126/256, 19/256)
		name_bg_texture:SetPoint ("topleft", window, "topleft", 2, -22)
		--name_bg_texture:SetPoint ("topright", window, "topright", -2, -22)
		name_bg_texture:SetPoint ("bottomright", window, "bottomright")
		name_bg_texture:SetHeight (54)
		name_bg_texture:SetVertexColor (0, 0, 0, 0.2)
		window.extra_frames ["ElvUINameTexture"] = name_bg_texture
	else
		titlebar:Show()
		window.extra_frames ["ElvUINameTexture"]:Show()
	end
	
	window.title_string:ClearAllPoints()
	window.title_string:SetPoint ("center", window, "center")
	window.title_string:SetPoint ("top", window, "top", 0, -7)
	window.title_string:SetParent (titlebar)
	window.title_string:SetTextColor (.8, .8, .8, 1)
	
	window.classe_icone:SetParent (titlebar)
	window.classe_icone:SetDrawLayer ("overlay")
	window.classe_icone:SetPoint ("TOPLEFT", window, "TOPLEFT", 2, -25)
	window.classe_icone:SetWidth (49)
	window.classe_icone:SetHeight (49)
	window.classe_icone:SetAlpha (1)
	
	window.close_button:SetWidth (20)
	window.close_button:SetHeight (20)
	window.close_button:SetPoint ("TOPRIGHT", window, "TOPRIGHT", 0, -3)
	
	window.options_button:SetPoint ("topright", window, "topright", -17, -7)
	window.options_button:SetSize (12, 12)
	
	window.avatar:SetParent (titlebar)
	
	--bar container
	window.container_barras:SetPoint (unpack (containerSettings.spells.point))
	window.container_barras:SetSize (containerSettings.spells.width, containerSettings.spells.height)
	
	--target container
	window.container_alvos:SetPoint (unpack (containerSettings.targets.point))
	window.container_alvos:SetSize (containerSettings.targets.width, containerSettings.targets.height)
	
	--texts
	window.targets:SetPoint ("topleft", window.container_alvos, "topleft", 3, 18)
	window.nome:SetPoint ("TOPLEFT", window, "TOPLEFT", 105, -48)
	
	--report button
	window.topleft_report:SetPoint ("BOTTOMLEFT", window.container_barras, "TOPLEFT",  43, 2)
	
	--icons
	window.apoio_icone_direito:SetBlendMode ("ADD")
	window.apoio_icone_esquerdo:SetBlendMode ("ADD")
	
	--no targets texture
	window.no_targets:SetPoint ("BOTTOMLEFT", window, "BOTTOMLEFT", 3, 6)
	window.no_targets:SetSize (418, 150)
	window.no_targets:SetAlpha (0.4)
	
	--right panel textures
	window.bg2_sec_texture:SetPoint ("topleft", window.bg1_sec_texture, "topleft", 7, 0)
	window.bg2_sec_texture:SetPoint ("bottomright", window.bg1_sec_texture, "bottomright", -30, 0)
	window.bg2_sec_texture:SetTexture ([[Interface\Glues\CREDITS\Warlords\Shadowmoon_Color_jlo3]])
	window.bg2_sec_texture:SetDesaturated (true)
	window.bg2_sec_texture:SetAlpha (0)
	
	window.bg3_sec_texture:SetPoint ("topleft", window.bg2_sec_texture, "topleft", 0, 0)
	window.bg3_sec_texture:SetPoint ("bottomright", window.bg2_sec_texture, "bottomright", 0, 0)
	window.bg3_sec_texture:SetTexture (0, 0, 0, 0.3)	
	
	--the 5 spell details blocks - not working
	for i, infoblock in ipairs (_detalhes.playerDetailWindow.grupos_detalhes) do
		infoblock.bg:SetSize (330, 47)
	end
	local xLocation = {-85, -136, -191, -246, -301}
	local heightTable = {50, 50, 50, 50, 50, 48}
	
	for i = 1, spellInfoSettings.amount do
		window ["right_background" .. i]:SetPoint ("topleft", window, "topleft", 351, xLocation [i])
		window ["right_background" .. i]:SetSize (spellInfoSettings.width, heightTable [i])
		
	end
	
	--seta configs dos 5 blocos da direita 
	info:SetDetailInfoConfigs ("Interface\\AddOns\\Details\\images\\bar_serenity", {1, 1, 1, 0.35}, -6 + 100, 0)

	window.bg1_sec_texture:SetPoint ("topleft", window.bg1, "topleft", 446, -86)
	window.bg1_sec_texture:SetWidth (337)
	window.bg1_sec_texture:SetHeight (362)

	--container 3 bars
	local x_start = 56
	local y_start = -10

	local janela = window.container_detalhes
	
	container3_bars_pointFunc = function (barra, index)
		local y = (index-1) * 17
		y = y*-1
		
		barra:SetPoint ("LEFT", info.bg1_sec_texture, "LEFT", 0, 0)
		barra:SetPoint ("RIGHT", info.bg1_sec_texture, "RIGHT", 0, 0)
		
		--barra:SetPoint ("LEFT", janela, "LEFT", x_start, 0)
		--barra:SetPoint ("RIGHT", janela, "RIGHT", 62, 0)
		barra:SetPoint ("TOP", janela, "TOP", 0, y+y_start)
	end
	
	for index, barra in ipairs (window.barras3) do
		local y = (index-1) * 17
		y = y*-1
		barra:SetPoint ("LEFT", janela, "LEFT", x_start, 0)
		barra:SetPoint ("RIGHT", janela, "RIGHT", 62, 0)
		barra:SetPoint ("TOP", janela, "TOP", 0, y+y_start)
	end
	
	--scrollbar
	do
		--get textures
		local normalTexture = window.container_barras.cima:GetNormalTexture()
		local pushedTexture = window.container_barras.cima:GetPushedTexture()
		local disabledTexture = window.container_barras.cima:GetDisabledTexture()
		
		--set the new textures
		normalTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Up]])
		pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Down]])
		disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
		
		normalTexture:SetPoint ("topleft", window.container_barras.cima, "topleft", 1, 0)
		normalTexture:SetPoint ("bottomright", window.container_barras.cima, "bottomright", 1, 0)
		pushedTexture:SetPoint ("topleft", window.container_barras.cima, "topleft", 1, 0)
		pushedTexture:SetPoint ("bottomright", window.container_barras.cima, "bottomright", 1, 0)
		disabledTexture:SetPoint ("topleft", window.container_barras.cima, "topleft", 1, 0)
		disabledTexture:SetPoint ("bottomright", window.container_barras.cima, "bottomright", 1, 0)
		
		disabledTexture:SetAlpha (0.5)

		window.container_barras.cima:SetSize (16, 16)
		window.container_barras.cima:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		window.container_barras.cima:SetBackdropColor (0, 0, 0, 0.3)
		window.container_barras.cima:SetBackdropBorderColor (0, 0, 0, 1)
	end
	
	do
		--get textures
		local normalTexture = window.container_barras.baixo:GetNormalTexture()
		local pushedTexture = window.container_barras.baixo:GetPushedTexture()
		local disabledTexture = window.container_barras.baixo:GetDisabledTexture()
		
		--set the new textures
		normalTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Up]])
		pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Down]])
		disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
		
		normalTexture:SetPoint ("topleft", window.container_barras.baixo, "topleft", 1, -4)
		normalTexture:SetPoint ("bottomright", window.container_barras.baixo, "bottomright", 1, -4)
		
		pushedTexture:SetPoint ("topleft", window.container_barras.baixo, "topleft", 1, -4)
		pushedTexture:SetPoint ("bottomright", window.container_barras.baixo, "bottomright", 1, -4)

		disabledTexture:SetPoint ("topleft", window.container_barras.baixo, "topleft", 1, -4)
		disabledTexture:SetPoint ("bottomright", window.container_barras.baixo, "bottomright", 1, -4)
		
		disabledTexture:SetAlpha (0.5)
		
		window.container_barras.baixo:SetSize (16, 16)
		window.container_barras.baixo:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		window.container_barras.baixo:SetBackdropColor (0, 0, 0, 0.3)
		window.container_barras.baixo:SetBackdropBorderColor (0, 0, 0, 1)
	end

	window.container_barras.slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
	window.container_barras.slider:SetBackdropColor (0, 0, 0, 0.35)
	window.container_barras.slider:SetBackdropBorderColor (0, 0, 0, 1)
	
	window.container_barras.slider:Altura (containerSettings.spells.scrollHeight)
	window.container_barras.slider:cimaPoint (0, 13)
	window.container_barras.slider:baixoPoint (0, -13)
	
	window.container_barras.slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
	window.container_barras.slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
	window.container_barras.slider.thumb:SetSize (12, 12)
	window.container_barras.slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)
	
	--
	
	
	do
		local f = window.container_alvos
		
		--get textures
		local normalTexture = f.cima:GetNormalTexture()
		local pushedTexture = f.cima:GetPushedTexture()
		local disabledTexture = f.cima:GetDisabledTexture()
		
		--set the new textures
		normalTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Up]])
		pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Down]])
		disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Up-Disabled]])
		
		normalTexture:SetPoint ("topleft", f.cima, "topleft", 1, 0)
		normalTexture:SetPoint ("bottomright", f.cima, "bottomright", 1, 0)
		pushedTexture:SetPoint ("topleft", f.cima, "topleft", 1, 0)
		pushedTexture:SetPoint ("bottomright", f.cima, "bottomright", 1, 0)
		disabledTexture:SetPoint ("topleft", f.cima, "topleft", 1, 0)
		disabledTexture:SetPoint ("bottomright", f.cima, "bottomright", 1, 0)
		
		disabledTexture:SetAlpha (0.5)

		f.cima:SetSize (16, 16)
		f.cima:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		f.cima:SetBackdropColor (0, 0, 0, 0.3)
		f.cima:SetBackdropBorderColor (0, 0, 0, 1)
	end
	
	do
		local f = window.container_alvos
		
		--get textures
		local normalTexture = f.baixo:GetNormalTexture()
		local pushedTexture = f.baixo:GetPushedTexture()
		local disabledTexture = f.baixo:GetDisabledTexture()
		
		--set the new textures
		normalTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Up]])
		pushedTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Down]])
		disabledTexture:SetTexture ([[Interface\Buttons\Arrow-Down-Disabled]])
		
		normalTexture:SetPoint ("topleft", f.baixo, "topleft", 1, -4)
		normalTexture:SetPoint ("bottomright", f.baixo, "bottomright", 1, -4)
		
		pushedTexture:SetPoint ("topleft", f.baixo, "topleft", 1, -4)
		pushedTexture:SetPoint ("bottomright", f.baixo, "bottomright", 1, -4)

		disabledTexture:SetPoint ("topleft", f.baixo, "topleft", 1, -4)
		disabledTexture:SetPoint ("bottomright", f.baixo, "bottomright", 1, -4)
		
		disabledTexture:SetAlpha (0.5)
		
		f.baixo:SetSize (16, 16)
		f.baixo:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
		f.baixo:SetBackdropColor (0, 0, 0, 0.3)
		f.baixo:SetBackdropBorderColor (0, 0, 0, 1)
	end

	window.container_alvos.slider:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]]})
	window.container_alvos.slider:SetBackdropColor (0, 0, 0, 0.35)
	window.container_alvos.slider:SetBackdropBorderColor (0, 0, 0, 1)
	
	window.container_alvos.slider:Altura (137)
	window.container_alvos.slider:cimaPoint (0, 13)
	window.container_alvos.slider:baixoPoint (0, -13)
	
	window.container_alvos.slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
	window.container_alvos.slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
	window.container_alvos.slider.thumb:SetSize (12, 12)
	window.container_alvos.slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)
	
	--class icon
	window.SetClassIcon = function (player, class)
	
		if (player.spec) then
			window.classe_icone:SetTexture ([[Interface\AddOns\Details\images\spec_icons_normal_alpha]])
			window.classe_icone:SetTexCoord (_unpack (_detalhes.class_specs_coords [player.spec]))
			--esta_barra.icone_classe:SetVertexColor (1, 1, 1)
		else
			local coords = CLASS_ICON_TCOORDS [class]
			if (coords) then
				info.classe_icone:SetTexture ([[Interface\Glues\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]])
				local l, r, t, b = unpack (coords)
				info.classe_icone:SetTexCoord (l+0.01953125, r-0.01953125, t+0.01953125, b-0.01953125)
			else
			
				local c = _detalhes.class_coords ["MONSTER"]
				info.classe_icone:SetTexture ("Interface\\AddOns\\Details\\images\\classes")
				info.classe_icone:SetTexCoord (c[1], c[2], c[3], c[4])
			end
		end
	end
end
_detalhes:InstallPDWSkin ("ElvUI", {func = elvui_skin, author = "Details! Team", version = "v1.0", desc = "Skin compatible with ElvUI addon."})

--> search key: ~create ~inicio ~start
function gump:CriaJanelaInfo()

	--> cria a janela em si
	local este_gump = info
	este_gump.Loaded = true
	
	este_gump:SetFrameStrata ("HIGH")
	este_gump:SetToplevel (true)
	
	este_gump.extra_frames = {}
	
	--> fehcar com o esc
	tinsert (UISpecialFrames, este_gump:GetName())

	--> propriedades da janela
	este_gump:SetPoint ("CENTER", UIParent)

	este_gump:SetWidth (PLAYER_DETAILS_WINDOW_WIDTH)
	este_gump:SetHeight (PLAYER_DETAILS_WINDOW_HEIGHT)
	
	este_gump:EnableMouse (true)
	este_gump:SetResizable (false)
	este_gump:SetMovable (true)

	este_gump.SummaryWindowWidgets = CreateFrame ("frame", "DetailsPlayerDetailsWindowSummaryWidgets", este_gump, "BackdropTemplate")
	local SWW = este_gump.SummaryWindowWidgets
	SWW:SetAllPoints()
	tinsert (SummaryWidgets, SWW)
	
	local scaleBar = Details.gump:CreateScaleBar (este_gump, Details.player_details_window)
	este_gump:SetScale (Details.player_details_window.scale)
	
	--classic:
	--este_gump:SetWidth (590)
	--este_gump:SetHeight (354)
	
	--> joga a janela para a global
	_detalhes.playerDetailWindow = este_gump

	--> icone da classe no canto esquerdo superior
	este_gump.classe_icone = este_gump:CreateTexture (nil, "BACKGROUND")
	este_gump.classe_icone:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 4, 0)
	este_gump.classe_icone:SetWidth (64)
	este_gump.classe_icone:SetHeight (64)
	este_gump.classe_icone:SetDrawLayer ("BACKGROUND", 1)
	--> complemento do icone
	este_gump.classe_iconePlus = este_gump:CreateTexture (nil, "BACKGROUND")
	este_gump.classe_iconePlus:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 4, 0)
	este_gump.classe_iconePlus:SetWidth (64)
	este_gump.classe_iconePlus:SetHeight (64)
	este_gump.classe_iconePlus:SetDrawLayer ("BACKGROUND", 2)
	
	--> top left
	este_gump.bg1 = este_gump:CreateTexture ("DetailsPSWBackground", "BORDER")
	este_gump.bg1:SetPoint ("TOPLEFT", este_gump, "TOPLEFT", 0, 0)
	este_gump.bg1:SetDrawLayer ("BORDER", 1)

	--> bot�o de fechar
	este_gump.close_button = _CreateFrame ("Button", nil, este_gump, "UIPanelCloseButton")
	este_gump.close_button:SetWidth (32)
	este_gump.close_button:SetHeight (32)
	este_gump.close_button:SetPoint ("TOPRIGHT", este_gump, "TOPRIGHT", 5, -8)
	este_gump.close_button:SetText ("X")
	este_gump.close_button:SetFrameLevel (este_gump:GetFrameLevel()+5)	
	
	
	--> �cone da magia selecionada para mais detalhes
	este_gump.bg_icone_bg = este_gump:CreateTexture (nil, "ARTWORK")
	este_gump.bg_icone_bg:SetPoint ("TOPRIGHT", este_gump, "TOPRIGHT",  -15, -12)
	este_gump.bg_icone_bg:SetTexture ("Interface\\AddOns\\Details\\images\\icone_bg_fundo")
	este_gump.bg_icone_bg:SetDrawLayer ("ARTWORK", -1)
	este_gump.bg_icone_bg:Show()
	
	este_gump.bg_icone = este_gump:CreateTexture (nil, "OVERLAY")
	este_gump.bg_icone:SetPoint ("TOPRIGHT", este_gump, "TOPRIGHT",  -15, -12)
	este_gump.bg_icone:SetTexture ("Interface\\AddOns\\Details\\images\\icone_bg")
	este_gump.bg_icone:Show()
	
	--> bot�o de op��es
	local open_options = function()
		_detalhes:OpenOptionsWindow (info.instancia, false, 6)
		_detalhes:OpenOptionsWindow (info.instancia, false, 6)
	end
	este_gump.options_button = gump:CreateButton (este_gump, open_options, 16, 16, nil, nil, nil, [[Interface\Buttons\UI-OptionsButton]])
	este_gump.options_button:SetPoint ("topright", este_gump, "topright", -26, -16)
	este_gump.options_button:SetAlpha (0.5)
	este_gump.options_button.button:GetNormalTexture():SetDesaturated (true)
	este_gump.options_button.tooltip = "Select Skin"
	
	--> desativando o bot�o de config
	este_gump.options_button:Hide()
	
	--> titulo
	gump:NewLabel (este_gump, este_gump, nil, "title_string", Loc ["STRING_PLAYER_DETAILS"], "GameFontHighlightLeft", 12, {227/255, 186/255, 4/255})
	este_gump.title_string:SetPoint ("center", este_gump, "center")
	este_gump.title_string:SetPoint ("top", este_gump, "top", 0, -18)
	
	este_gump.spell_icone = este_gump:CreateTexture (nil, "ARTWORK")
	este_gump.spell_icone:SetPoint ("BOTTOMRIGHT", este_gump.bg_icone, "BOTTOMRIGHT",  -19, 2)
	este_gump.spell_icone:SetWidth (35)
	este_gump.spell_icone:SetHeight (34)
	este_gump.spell_icone:SetDrawLayer ("ARTWORK", 0)
	este_gump.spell_icone:Show()
	este_gump.spell_icone:SetTexCoord (4/64, 60/64, 4/64, 60/64)
	
	--> coisinhas do lado do icone
	este_gump.apoio_icone_esquerdo = este_gump:CreateTexture (nil, "ARTWORK")
	este_gump.apoio_icone_direito = este_gump:CreateTexture (nil, "ARTWORK")
	este_gump.apoio_icone_esquerdo:SetTexture ("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
	este_gump.apoio_icone_direito:SetTexture ("Interface\\PaperDollInfoFrame\\PaperDollSidebarTabs")
	
	local apoio_altura = 13/256
	este_gump.apoio_icone_esquerdo:SetTexCoord (0, 1, 0, apoio_altura)
	este_gump.apoio_icone_direito:SetTexCoord (0, 1, apoio_altura+(1/256), apoio_altura+apoio_altura)
	
	este_gump.apoio_icone_esquerdo:SetPoint ("bottomright", este_gump.bg_icone, "bottomleft",  42, 0)
	este_gump.apoio_icone_direito:SetPoint ("bottomleft", este_gump.bg_icone, "bottomright",  -17, 0)
	
	este_gump.apoio_icone_esquerdo:SetWidth (64)
	este_gump.apoio_icone_esquerdo:SetHeight (13)
	este_gump.apoio_icone_direito:SetWidth (64)
	este_gump.apoio_icone_direito:SetHeight (13)
	
	
	este_gump.topright_text1 = este_gump:CreateFontString (nil, "overlay", "GameFontNormal")
	este_gump.topright_text1:SetPoint ("bottomright", este_gump, "topright",  -18 - (94 * (1-1)), -36)
	este_gump.topright_text1:SetJustifyH ("right")
	_detalhes.gump:SetFontSize (este_gump.topright_text1, 10)

	este_gump.topright_text2 = este_gump:CreateFontString (nil, "overlay", "GameFontNormal")
	este_gump.topright_text2:SetPoint ("bottomright", este_gump, "topright",  -18 - (94 * (1-1)), -48)
	este_gump.topright_text2:SetJustifyH ("right")	
	_detalhes.gump:SetFontSize (este_gump.topright_text2, 10)
	
	function este_gump:SetTopRightTexts (text1, text2, size, color, font)
		if (text1) then
			este_gump.topright_text1:SetText (text1)
		else
			este_gump.topright_text1:SetText ("")
		end
		if (text2) then
			este_gump.topright_text2:SetText (text2)
		else
			este_gump.topright_text2:SetText ("")
		end
		
		if (size and type (size) == "number") then
			_detalhes.gump:SetFontSize (este_gump.topright_text1, size)
			_detalhes.gump:SetFontSize (este_gump.topright_text2, size)
		end
		if (color) then
			_detalhes.gump:SetFontColor (este_gump.topright_text1, color)
			_detalhes.gump:SetFontColor (este_gump.topright_text2, color)
		end
		if (font) then
			_detalhes.gump:SetFontFace (este_gump.topright_text1, font)
			_detalhes.gump:SetFontFace (este_gump.topright_text2, font)
		end
	end
	
-------------------------------------------------

	local alpha_bgs = 1

	-- backgrounds das 5 boxes do lado direito
		local right_background_X = 457
		local right_background_Y = {-85, -136, -191, -246, -301}
		
		for i = 1, spellInfoSettings.amount do
			local right_background1 = CreateFrame ("frame", "DetailsPlayerDetailsWindow_right_background" .. i, SWW, "BackdropTemplate")
			right_background1:EnableMouse (false)
			right_background1:SetPoint ("topleft", este_gump, "topleft", right_background_X, right_background_Y [i])
			right_background1:SetSize (220, 43)
			Details.gump:ApplyStandardBackdrop (right_background1)
			este_gump ["right_background" .. i] = right_background1
		end

	-- fundos especiais de friendly fire e outros
		este_gump.bg1_sec_texture = SWW:CreateTexture ("DetailsPlayerDetailsWindow_BG1_SEC_Texture", "BORDER")
		este_gump.bg1_sec_texture:SetDrawLayer ("BORDER", 4)
		este_gump.bg1_sec_texture:SetPoint ("topleft", este_gump.bg1, "topleft", 450, -86)
		este_gump.bg1_sec_texture:SetHeight (462)
		este_gump.bg1_sec_texture:SetWidth (264)
		
		este_gump.bg2_sec_texture = SWW:CreateTexture ("DetailsPlayerDetailsWindow_BG2_SEC_Texture", "BORDER")
		este_gump.bg2_sec_texture:SetDrawLayer ("BORDER", 3)
		este_gump.bg2_sec_texture:SetPoint ("topleft", este_gump.bg1_sec_texture, "topleft", 8, 0)
		este_gump.bg2_sec_texture:SetPoint ("bottomright", este_gump.bg1_sec_texture, "bottomright", -30, 0)
		este_gump.bg2_sec_texture:SetTexture ([[Interface\Glues\CREDITS\Warlords\Shadowmoon_Color_jlo3]])
		este_gump.bg2_sec_texture:SetDesaturated (true)
		este_gump.bg2_sec_texture:SetAlpha (0.3)
		este_gump.bg2_sec_texture:Hide()

		este_gump.bg3_sec_texture = SWW:CreateTexture ("DetailsPlayerDetailsWindow_BG3_SEC_Texture", "BORDER")
		este_gump.bg3_sec_texture:SetDrawLayer ("BORDER", 2)
		este_gump.bg3_sec_texture:SetPoint ("topleft", este_gump.bg2_sec_texture, "topleft", 0, 0)
		este_gump.bg3_sec_texture:SetPoint ("bottomright", este_gump.bg2_sec_texture, "bottomright", 0, 0)
		--este_gump.bg3_sec_texture:SetColorTexture (0, 0, 0, 1)
		este_gump.bg3_sec_texture:Hide()
	
		este_gump.no_targets = SWW:CreateTexture ("DetailsPlayerDetailsWindow_no_targets", "overlay")
		este_gump.no_targets:SetPoint ("BOTTOMLEFT", este_gump, "BOTTOMLEFT", 20, 6)
		este_gump.no_targets:SetSize (301, 100)
		este_gump.no_targets:SetTexture ([[Interface\QUESTFRAME\UI-QUESTLOG-EMPTY-TOPLEFT]])
		este_gump.no_targets:SetTexCoord (0.015625, 1, 0.01171875, 0.390625)
		este_gump.no_targets:SetDesaturated (true)
		este_gump.no_targets:SetAlpha (.7)
		este_gump.no_targets.text = SWW:CreateFontString (nil, "overlay", "GameFontNormal")
		este_gump.no_targets.text:SetPoint ("center", este_gump.no_targets, "center")
		este_gump.no_targets.text:SetText (Loc ["STRING_NO_TARGET_BOX"])
		este_gump.no_targets.text:SetTextColor (1, 1, 1, .4)
		este_gump.no_targets:Hide()

	--> cria os textos da janela
	cria_textos (este_gump, SWW)	
	
	--> cria o frama que vai abrigar as barras das habilidades
	cria_container_barras (este_gump, SWW)
	
	--> cria o container que vai abrirgar as 5 barras de detalhes
	cria_container_detalhes (este_gump, SWW)
	
	--> cria o container onde vai abrigar os alvos do jogador
	cria_container_alvos (este_gump, SWW)

--	local leftbars1_backgound = SWW:CreateTexture (nil, "background")
--	leftbars1_backgound:SetTexture ([[Interface\DialogFrame\UI-DialogBox-Background-Dark]])
--	leftbars1_backgound:SetSize (303, 149)
--	leftbars1_backgound:SetAlpha (alpha_bgs)
--	este_gump.leftbars1_backgound = leftbars1_backgound
	
	local leftbars1_backgound = CreateFrame ("frame", "DetailsPlayerDetailsWindow_Left_SpellsBackground", SWW, "BackdropTemplate")
	leftbars1_backgound:EnableMouse (false)
	leftbars1_backgound:SetSize (303, 149)
	leftbars1_backgound:SetAlpha (alpha_bgs)
	leftbars1_backgound:SetFrameLevel (SWW:GetFrameLevel())
	Details.gump:ApplyStandardBackdrop (leftbars1_backgound)
	este_gump.leftbars1_backgound = leftbars1_backgound
	
	local leftbars2_backgound = CreateFrame ("frame", "DetailsPlayerDetailsWindow_Left_TargetBackground", SWW, "BackdropTemplate")
	leftbars2_backgound:EnableMouse (false)
	leftbars2_backgound:SetSize (303, 122)
	leftbars2_backgound:SetAlpha (alpha_bgs)
	leftbars2_backgound:SetFrameLevel (SWW:GetFrameLevel())
	Details.gump:ApplyStandardBackdrop (leftbars2_backgound)
	este_gump.leftbars2_backgound = leftbars2_backgound
	
	leftbars1_backgound:SetPoint ("topleft", este_gump.container_barras, "topleft", -3, 3)
	leftbars1_backgound:SetPoint ("bottomright", este_gump.container_barras, "bottomright", 3, -3)
	leftbars2_backgound:SetPoint ("topleft", este_gump.container_alvos, "topleft", -3, 23)
	leftbars2_backgound:SetPoint ("bottomright", este_gump.container_alvos, "bottomright", 3, 0)

	--> cria as 5 barras de detalhes a direita da janela
	cria_barras_detalhes()
	
	--> seta os scripts dos frames da janela
	seta_scripts (este_gump)

	--> vai armazenar os objetos das barras de habilidade
	este_gump.barras1 = {} 
	
	--> vai armazenar os objetos das barras de alvos
	este_gump.barras2 = {} 
	
	--> vai armazenar os objetos das barras da caixa especial da direita
	este_gump.barras3 = {} 

	este_gump.SetClassIcon = default_icon_change

	--> bot�o de reportar da caixa da esquerda, onde fica as barras principais
	este_gump.report_esquerda = gump:NewDetailsButton (SWW, este_gump, nil, _detalhes.Reportar, este_gump, 1, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsJanelaInfoReport2")
	--este_gump.report_esquerda:SetPoint ("BOTTOMLEFT", este_gump.container_barras, "TOPLEFT",  281, 3)
	este_gump.report_esquerda:SetPoint ("BOTTOMLEFT", este_gump.container_barras, "TOPLEFT",  33, 3)
	este_gump.report_esquerda:SetFrameLevel (este_gump:GetFrameLevel()+2)
	este_gump.topleft_report = este_gump.report_esquerda
	
	--> bot�o de reportar da caixa dos alvos
	este_gump.report_alvos = gump:NewDetailsButton (SWW, este_gump, nil, _detalhes.Reportar, este_gump, 3, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsJanelaInfoReport3")
	este_gump.report_alvos:SetPoint ("BOTTOMRIGHT", este_gump.container_alvos, "TOPRIGHT",  -2, -1)
	este_gump.report_alvos:SetFrameLevel (3) --> solved inactive problem

	--> bot�o de reportar da caixa da direita, onde est�o os 5 quadrados
	este_gump.report_direita = gump:NewDetailsButton (SWW, este_gump, nil, _detalhes.Reportar, este_gump, 2, 16, 16,
	"Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", "Interface\\COMMON\\VOICECHAT-ON", nil, "DetailsJanelaInfoReport4")
	este_gump.report_direita:SetPoint ("TOPRIGHT", este_gump, "TOPRIGHT",  -10, -70)	
	este_gump.report_direita:Show()
	
	--> statusbar
	local statusBar = CreateFrame ("frame", nil, este_gump, "BackdropTemplate")
	statusBar:SetPoint ("bottomleft", este_gump, "bottomleft")
	statusBar:SetPoint ("bottomright", este_gump, "bottomright")
	statusBar:SetHeight (PLAYER_DETAILS_STATUSBAR_HEIGHT)
	DetailsFramework:ApplyStandardBackdrop (statusBar)
	statusBar:SetAlpha (PLAYER_DETAILS_STATUSBAR_ALPHA)
	
	statusBar.Text = DetailsFramework:CreateLabel (statusBar)
	statusBar.Text:SetPoint ("left", 2, 0)
	
	function este_gump:SetStatusbarText (text, fontSize, fontColor)
		if (not text) then
			este_gump:SetStatusbarText ("Details! Damage Meter | Use '/details stats' for statistics", 10, "gray")
			return
		end
		statusBar.Text.text = text
		statusBar.Text.fontsize = fontSize
		statusBar.Text.fontcolor = fontColor
	end
	
	--set default text
	este_gump:SetStatusbarText()

	--> apply default skin
	_detalhes:ApplyPDWSkin()
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> tabs

	local red = "FFFFAAAA"
	local green = "FFAAFFAA"
	
	--> tabs:
	--> tab default
	
	local iconTableSummary = {
		texture = [[Interface\AddOns\Details\images\icons]],
		coords = {238/512, 255/512, 0, 18/512},
		width = 16,
		height = 16,
	}
	
	_detalhes:CreatePlayerDetailsTab ("Summary", Loc ["STRING_SPELLS"], --[1] tab name [2] localized name
			function (tabOBject, playerObject) --[2] condition
				if (playerObject) then 
					return true 
				else 
					return false 
				end
			end, 
			nil, --[3] fill function
			function() --[4] onclick
				for _, tab in _ipairs (_detalhes.player_details_tabs) do
					tab.frame:Hide()
				end
			end,
			nil, --[5] oncreate
			iconTableSummary --icon table
	)
		
		--> search key: ~avoidance --> begining of avoidance tab
		
		local avoidance_create = function (tab, frame)
	
		--> Percent Desc
			local percent_desc = frame:CreateFontString (nil, "artwork", "GameFontNormal")
			percent_desc:SetText ("Percent values are comparisons with the previous try.")
			percent_desc:SetPoint ("bottomleft", frame, "bottomleft", 13, 13 + PLAYER_DETAILS_STATUSBAR_HEIGHT)
			percent_desc:SetTextColor (.5, .5, .5, 1)
		
		--> SUMMARY
		
			local summaryBox = CreateFrame ("frame", nil, frame, "BackdropTemplate")
			_detalhes.gump:ApplyStandardBackdrop (summaryBox)
			summaryBox:SetPoint ("topleft", frame, "topleft", 10, -15)
			summaryBox:SetSize (200, 160)
			
			local y = -5
			local padding = 16

			local summary_text = summaryBox:CreateFontString (nil, "artwork", "GameFontNormal")
			summary_text:SetText ("Summary")
			summary_text :SetPoint ("topleft", summaryBox, "topleft", 5, y)
			
			y = y - padding
		
			--total damage received
			local damagereceived = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			damagereceived:SetPoint ("topleft", summaryBox, "topleft", 15, y)
			damagereceived:SetText ("Total Damage Taken:") --> localize-me
			damagereceived:SetTextColor (.8, .8, .8, 1)

			local damagereceived_amt = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			damagereceived_amt:SetPoint ("left", damagereceived,  "right", 2, 0)
			damagereceived_amt:SetText ("0")
			tab.damagereceived = damagereceived_amt
		
			y = y - padding
			
			--per second
			local damagepersecond = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			damagepersecond:SetPoint ("topleft", summaryBox, "topleft", 20, y)
			damagepersecond:SetText ("Per Second:") --> localize-me
			
			local damagepersecond_amt = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			damagepersecond_amt:SetPoint ("left", damagepersecond,  "right", 2, 0)
			damagepersecond_amt:SetText ("0")
			tab.damagepersecond = damagepersecond_amt
			
			y = y - padding		
			
			--total absorbs
			local absorbstotal = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			absorbstotal:SetPoint ("topleft", summaryBox, "topleft", 15, y)
			absorbstotal:SetText ("Total Absorbs:") --> localize-me
			absorbstotal:SetTextColor (.8, .8, .8, 1)
			
			local absorbstotal_amt = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			absorbstotal_amt:SetPoint ("left", absorbstotal,  "right", 2, 0)
			absorbstotal_amt:SetText ("0")
			tab.absorbstotal = absorbstotal_amt
			
			y = y - padding
			
			--per second
			local absorbstotalpersecond = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			absorbstotalpersecond:SetPoint ("topleft", summaryBox, "topleft", 20, y)
			absorbstotalpersecond:SetText ("Per Second:") --> localize-me
			
			local absorbstotalpersecond_amt = summaryBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			absorbstotalpersecond_amt:SetPoint ("left", absorbstotalpersecond,  "right", 2, 0)
			absorbstotalpersecond_amt:SetText ("0")
			tab.absorbstotalpersecond = absorbstotalpersecond_amt
		

		--> MELEE
		
			y = -5
		
			local meleeBox = CreateFrame ("frame", nil, frame, "BackdropTemplate")
			_detalhes.gump:ApplyStandardBackdrop (meleeBox)
			meleeBox:SetPoint ("topleft", summaryBox, "bottomleft", 0, -5)
			meleeBox:SetSize (200, 160)

			local melee_text = meleeBox:CreateFontString (nil, "artwork", "GameFontNormal")
			melee_text:SetText ("Melee")
			melee_text :SetPoint ("topleft", meleeBox, "topleft", 5, y)
			
			y = y - padding
			
			--dodge
			local dodge = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			dodge:SetPoint ("topleft", meleeBox, "topleft", 15, y)
			dodge:SetText ("Dodge:") --> localize-me
			dodge:SetTextColor (.8, .8, .8, 1)
			local dodge_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			dodge_amt:SetPoint ("left", dodge,  "right", 2, 0)
			dodge_amt:SetText ("0")
			tab.dodge = dodge_amt
			
			y = y - padding
			
			local dodgepersecond = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			dodgepersecond:SetPoint ("topleft", meleeBox, "topleft", 20, y)
			dodgepersecond:SetText ("Per Second:") --> localize-me
			
			local dodgepersecond_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			dodgepersecond_amt:SetPoint ("left", dodgepersecond,  "right", 2, 0)
			dodgepersecond_amt:SetText ("0")
			tab.dodgepersecond = dodgepersecond_amt
			
			y = y - padding
			
			-- parry
			local parry = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			parry:SetPoint ("topleft", meleeBox, "topleft", 15, y)
			parry:SetText ("Parry:") --> localize-me
			parry:SetTextColor (.8, .8, .8, 1)
			local parry_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			parry_amt:SetPoint ("left", parry,  "right", 2, 0)
			parry_amt:SetText ("0")
			tab.parry = parry_amt
			
			y = y - padding
			
			local parrypersecond = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			parrypersecond:SetPoint ("topleft", meleeBox, "topleft", 20, y)
			parrypersecond:SetText ("Per Second:") --> localize-me
			local parrypersecond_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			parrypersecond_amt:SetPoint ("left", parrypersecond,  "right", 2, 0)
			parrypersecond_amt:SetText ("0")
			tab.parrypersecond = parrypersecond_amt

			y = y - padding
			
			-- block
			local block = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			block:SetPoint ("topleft", meleeBox, "topleft", 15, y)
			block:SetText ("Block:") --> localize-me
			block:SetTextColor (.8, .8, .8, 1)
			local block_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			block_amt:SetPoint ("left", block,  "right", 2, 0)
			block_amt:SetText ("0")
			tab.block = block_amt
			
			y = y - padding
			
			local blockpersecond = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			blockpersecond:SetPoint ("topleft", meleeBox, "topleft", 20, y)
			blockpersecond:SetText ("Per Second:") --> localize-me
			local blockpersecond_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			blockpersecond_amt:SetPoint ("left", blockpersecond,  "right", 2, 0)
			blockpersecond_amt:SetText ("0")
			tab.blockpersecond = blockpersecond_amt
			
			y = y - padding
			
			local blockeddamage = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			blockeddamage:SetPoint ("topleft", meleeBox, "topleft", 20, y)
			blockeddamage:SetText ("Damage Blocked:") --> localize-me
			local blockeddamage_amt = meleeBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			blockeddamage_amt:SetPoint ("left", blockeddamage,  "right", 2, 0)
			blockeddamage_amt:SetText ("0")
			tab.blockeddamage_amt = blockeddamage_amt
			
			
		--> ABSORBS
		
			y = -5
			
			local absorbsBox = CreateFrame ("frame", nil, frame, "BackdropTemplate")
			_detalhes.gump:ApplyStandardBackdrop (absorbsBox)
			absorbsBox:SetPoint ("topleft", summaryBox, "topright", 10, 0)
			absorbsBox:SetSize (200, 160)
			
			local absorb_text = absorbsBox:CreateFontString (nil, "artwork", "GameFontNormal")
			absorb_text:SetText ("Absorb")
			absorb_text :SetPoint ("topleft", absorbsBox, "topleft", 5, y)
		
			y = y - padding
		
			--full absorbs
			local fullsbsorbed = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			fullsbsorbed:SetPoint ("topleft", absorbsBox, "topleft", 20, y)
			fullsbsorbed:SetText ("Full Absorbs:") --> localize-me
			fullsbsorbed:SetTextColor (.8, .8, .8, 1)
			local fullsbsorbed_amt = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			fullsbsorbed_amt:SetPoint ("left", fullsbsorbed,  "right", 2, 0)
			fullsbsorbed_amt:SetText ("0")
			tab.fullsbsorbed = fullsbsorbed_amt
			
			y = y - padding
			
			--partially absorbs
			local partiallyabsorbed = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			partiallyabsorbed:SetPoint ("topleft", absorbsBox, "topleft", 20, y)
			partiallyabsorbed:SetText ("Partially Absorbed:") --> localize-me
			partiallyabsorbed:SetTextColor (.8, .8, .8, 1)
			local partiallyabsorbed_amt = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			partiallyabsorbed_amt:SetPoint ("left", partiallyabsorbed,  "right", 2, 0)
			partiallyabsorbed_amt:SetText ("0")
			tab.partiallyabsorbed = partiallyabsorbed_amt
		
			y = y - padding
		
			--partially absorbs per second
			local partiallyabsorbedpersecond = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			partiallyabsorbedpersecond:SetPoint ("topleft", absorbsBox, "topleft", 25, y)
			partiallyabsorbedpersecond:SetText ("Average:") --> localize-me
			local partiallyabsorbedpersecond_amt = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			partiallyabsorbedpersecond_amt:SetPoint ("left", partiallyabsorbedpersecond,  "right", 2, 0)
			partiallyabsorbedpersecond_amt:SetText ("0")
			tab.partiallyabsorbedpersecond = partiallyabsorbedpersecond_amt
			
			y = y - padding
			
			--no absorbs
			local noabsorbs = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			noabsorbs:SetPoint ("topleft", absorbsBox, "topleft", 20, y)
			noabsorbs:SetText ("No Absorption:") --> localize-me
			noabsorbs:SetTextColor (.8, .8, .8, 1)
			local noabsorbs_amt = absorbsBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			noabsorbs_amt:SetPoint ("left", noabsorbs,  "right", 2, 0)
			noabsorbs_amt:SetText ("0")
			tab.noabsorbs = noabsorbs_amt
		
		
		--> HEALING
		
			y = -5
		
			local healingBox = CreateFrame ("frame", nil, frame,"BackdropTemplate")
			_detalhes.gump:ApplyStandardBackdrop (healingBox)
			healingBox:SetPoint ("topleft", absorbsBox, "bottomleft", 0, -5)
			healingBox:SetSize (200, 160)

			local healing_text = healingBox:CreateFontString (nil, "artwork", "GameFontNormal")
			healing_text:SetText ("Healing")
			healing_text :SetPoint ("topleft", healingBox, "topleft", 5, y)
			
			y = y - padding
			
			--self healing
			local selfhealing = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			selfhealing:SetPoint ("topleft", healingBox, "topleft", 20, y)
			selfhealing:SetText ("Self Healing:") --> localize-me
			selfhealing:SetTextColor (.8, .8, .8, 1)
			local selfhealing_amt = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			selfhealing_amt:SetPoint ("left", selfhealing,  "right", 2, 0)
			selfhealing_amt:SetText ("0")
			tab.selfhealing = selfhealing_amt

			y = y - padding
			
			--self healing per second
			local selfhealingpersecond = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			selfhealingpersecond:SetPoint ("topleft", healingBox, "topleft", 25, y)
			selfhealingpersecond:SetText ("Per Second:") --> localize-me
			local selfhealingpersecond_amt = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
			selfhealingpersecond_amt:SetPoint ("left", selfhealingpersecond,  "right", 2, 0)
			selfhealingpersecond_amt:SetText ("0")
			tab.selfhealingpersecond = selfhealingpersecond_amt
		
			y = y - padding
		
			for i = 1, 5 do 
				local healer = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
				healer:SetPoint ("topleft", healingBox, "topleft", 20, y + ((i-1)*15)*-1)
				healer:SetText ("healer name:") --> localize-me
				healer:SetTextColor (.8, .8, .8, 1)
				local healer_amt = healingBox:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
				healer_amt:SetPoint ("left", healer,  "right", 2, 0)
				healer_amt:SetText ("0")
				tab ["healer" .. i] = {healer, healer_amt}
			end
			
			
			
			
		--SPELLS
		
			y = -5
		
			local spellsBox = CreateFrame ("frame", nil, frame,"BackdropTemplate")
			_detalhes.gump:ApplyStandardBackdrop (spellsBox)
			spellsBox:SetPoint ("topleft", absorbsBox, "topright", 10, 0)
			spellsBox:SetSize (346, 160 * 2 + 5)
		
			local spells_text = spellsBox:CreateFontString (nil, "artwork", "GameFontNormal")
			spells_text:SetText ("Spells")
			spells_text :SetPoint ("topleft", spellsBox, "topleft", 5, y)
			
			local frame_tooltip_onenter = function (self)
				if (self.spellid) then
					--self:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 512, edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 8})
					self:SetBackdropColor (.5, .5, .5, .5)
					GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
					_detalhes:GameTooltipSetSpellByID (self.spellid)
					GameTooltip:Show()
				end
			end
			local frame_tooltip_onleave = function (self)
				if (self.spellid) then
					self:SetBackdropColor (.5, .5, .5, .1)
					GameTooltip:Hide()
				end
			end
			
			y = y - padding
			
			for i = 1, 40 do 
				local frame_tooltip = CreateFrame ("frame", nil, spellsBox,"BackdropTemplate")
				frame_tooltip:SetPoint ("topleft", spellsBox, "topleft", 5, y + ((i-1)*17)*-1)
				frame_tooltip:SetSize (spellsBox:GetWidth()-10, 16)
				frame_tooltip:SetScript ("OnEnter", frame_tooltip_onenter)
				frame_tooltip:SetScript ("OnLeave", frame_tooltip_onleave)
				frame_tooltip:Hide()
				
				frame_tooltip:SetBackdrop ({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 512})
				frame_tooltip:SetBackdropColor (.5, .5, .5, .1)
				
				local icon = frame_tooltip:CreateTexture (nil, "artwork")
				icon:SetSize (14, 14)
				icon:SetPoint ("left", frame_tooltip, "left")
				
				local spell = frame_tooltip:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
				spell:SetPoint ("left", icon, "right", 2, 0)
				spell:SetText ("spell name:") --> localize-me
				spell:SetTextColor (.8, .8, .8, 1)
				
				local spell_amt = frame_tooltip:CreateFontString (nil, "artwork", "GameFontHighlightSmall")
				spell_amt:SetPoint ("left", spell,  "right", 2, 0)
				spell_amt:SetText ("0")
				
				tab ["spell" .. i] = {spell, spell_amt, icon, frame_tooltip}
			end
		
		end
		
		local getpercent = function (value, lastvalue, elapsed_time, inverse)
			local ps = value / elapsed_time
			local diff
			
			if (lastvalue == 0) then
				diff = "+0%"
			else
				if (ps >= lastvalue) then
					local d = ps - lastvalue
					d = d / lastvalue * 100
					d = _math_floor (math.abs (d))

					if (d > 999) then
						d = "> 999"
					end
					
					if (inverse) then
						diff = "|c" .. green .. "+" .. d .. "%|r"
					else
						diff = "|c" .. red .. "+" .. d .. "%|r"
					end
				else
					local d = lastvalue - ps
					d = d / ps * 100
					d = _math_floor (math.abs (d))
					
					if (d > 999) then
						d = "> 999"
					end
					
					if (inverse) then
						diff = "|c" .. red .. "-" .. d .. "%|r"
					else
						diff = "|c" .. green .. "-" .. d .. "%|r"
					end
				end
			end
			
			return ps, diff
		end
		
		local avoidance_fill = function (tab, player, combat)

			local elapsed_time = combat:GetCombatTime()
			
			local last_combat = combat.previous_combat
			if (not last_combat or not last_combat [1]) then
				last_combat = combat
			end
			local last_actor = last_combat (1, player.nome)
			local n = player.nome
			if (n:find ("-")) then
				n = n:gsub (("-.*"), "")
			end

			--> damage taken
				local playerdamage = combat (1, player.nome)
			
				if (not playerdamage.avoidance) then
					playerdamage.avoidance = _detalhes:CreateActorAvoidanceTable()
				end
			
				local damagetaken = playerdamage.damage_taken
				local last_damage_received = 0
				if (last_actor) then
					last_damage_received = last_actor.damage_taken / last_combat:GetCombatTime()
				end
				
				tab.damagereceived:SetText (_detalhes:ToK2 (damagetaken))
				
				local ps, diff = getpercent (damagetaken, last_damage_received, elapsed_time)
				tab.damagepersecond:SetText (_detalhes:comma_value (_math_floor (ps)) .. " (" .. diff .. ")")

			--> absorbs
				local totalabsorbs = playerdamage.avoidance.overall.ABSORB_AMT
				local incomingtotal = damagetaken + totalabsorbs
				
				local last_total_absorbs = 0
				if (last_actor and last_actor.avoidance) then
					last_total_absorbs = last_actor.avoidance.overall.ABSORB_AMT / last_combat:GetCombatTime()
				end
				
				tab.absorbstotal:SetText (_detalhes:ToK2 (totalabsorbs) .. " (" .. _math_floor (totalabsorbs / incomingtotal * 100) .. "%)")
				
				local ps, diff = getpercent (totalabsorbs, last_total_absorbs, elapsed_time, true)
				tab.absorbstotalpersecond:SetText (_detalhes:comma_value (_math_floor (ps)) .. " (" .. diff .. ")")
				
			--> dodge
				local totaldodge = playerdamage.avoidance.overall.DODGE
				tab.dodge:SetText (totaldodge)
				
				local last_total_dodge = 0
				if (last_actor and last_actor.avoidance) then
					last_total_dodge = last_actor.avoidance.overall.DODGE / last_combat:GetCombatTime()
				end
				local ps, diff = getpercent (totaldodge, last_total_dodge, elapsed_time, true)
				tab.dodgepersecond:SetText ( string.format ("%.2f", ps) .. " (" .. diff .. ")")
			
			--> parry
				local totalparry = playerdamage.avoidance.overall.PARRY
				tab.parry:SetText (totalparry)
				
				local last_total_parry = 0
				if (last_actor and last_actor.avoidance) then
					last_total_parry = last_actor.avoidance.overall.PARRY / last_combat:GetCombatTime()
				end
				local ps, diff = getpercent (totalparry, last_total_parry, elapsed_time, true)
				tab.parrypersecond:SetText (string.format ("%.2f", ps) .. " (" .. diff .. ")")
				
			--> block
				local totalblock = playerdamage.avoidance.overall.BLOCKED_HITS
				tab.block:SetText (totalblock)
				
				local last_total_block = 0
				if (last_actor and last_actor.avoidance) then
					last_total_block = last_actor.avoidance.overall.BLOCKED_HITS / last_combat:GetCombatTime()
				end
				local ps, diff = getpercent (totalblock, last_total_block, elapsed_time, true)
				tab.blockpersecond:SetText (string.format ("%.2f", ps) .. " (" .. diff .. ")")
				
				tab.blockeddamage_amt:SetText (_detalhes:ToK2 (playerdamage.avoidance.overall.BLOCKED_AMT))
				
			--> absorb
				local fullabsorb = playerdamage.avoidance.overall.FULL_ABSORBED
				local halfabsorb = playerdamage.avoidance.overall.PARTIAL_ABSORBED
				local halfabsorb_amt = playerdamage.avoidance.overall.PARTIAL_ABSORB_AMT
				local noabsorb = playerdamage.avoidance.overall.FULL_HIT
				
				tab.fullsbsorbed:SetText (fullabsorb)
				tab.partiallyabsorbed:SetText (halfabsorb)
				tab.noabsorbs:SetText (noabsorb)
				
				if (halfabsorb_amt > 0) then
					local average = halfabsorb_amt / halfabsorb --tenho o average
					local last_average = 0
					if (last_actor and last_actor.avoidance and last_actor.avoidance.overall.PARTIAL_ABSORBED > 0) then
						last_average = last_actor.avoidance.overall.PARTIAL_ABSORB_AMT / last_actor.avoidance.overall.PARTIAL_ABSORBED
					end
					
					local ps, diff = getpercent (halfabsorb_amt, last_average, halfabsorb, true)
					tab.partiallyabsorbedpersecond:SetText (_detalhes:comma_value (_math_floor (ps)) .. " (" .. diff .. ")")
				else
					tab.partiallyabsorbedpersecond:SetText ("0.00 (0%)")
				end
				

				
			--> healing
			
				local actor_heal = combat (2, player.nome)
				if (not actor_heal) then
					tab.selfhealing:SetText ("0")
					tab.selfhealingpersecond:SetText ("0 (0%)")
				else
					local last_actor_heal = last_combat (2, player.nome)
					local este_alvo = actor_heal.targets [player.nome]
					if (este_alvo) then
						local heal_total = este_alvo
						tab.selfhealing:SetText (_detalhes:ToK2 (heal_total))
						
						if (last_actor_heal) then
							local este_alvo = last_actor_heal.targets [player.nome]
							if (este_alvo) then
								local heal = este_alvo
								
								local last_heal = heal / last_combat:GetCombatTime()
								
								local ps, diff = getpercent (heal_total, last_heal, elapsed_time, true)
								tab.selfhealingpersecond:SetText (_detalhes:comma_value (_math_floor (ps)) .. " (" .. diff .. ")")
								
							else
								tab.selfhealingpersecond:SetText ("0 (0%)")
							end
						else
							tab.selfhealingpersecond:SetText ("0 (0%)")
						end
						
					else
						tab.selfhealing:SetText ("0")
						tab.selfhealingpersecond:SetText ("0 (0%)")
					end
					
					
					-- taken from healer
					local heal_from = actor_heal.healing_from
					local myReceivedHeal = {}
					
					for actorName, _ in pairs (heal_from) do 
						local thisActor = combat (2, actorName)
						local targets = thisActor.targets --> targets is a container with target classes
						local amount = targets [player.nome] or 0
						myReceivedHeal [#myReceivedHeal+1] = {actorName, amount, thisActor.classe}
					end
					
					table.sort (myReceivedHeal, _detalhes.Sort2) --> Sort2 sort by second index
					
					for i = 1, 5 do 
						local label1, label2 = unpack (tab ["healer" .. i])
						if (myReceivedHeal [i]) then
							local name = myReceivedHeal [i][1]
							
							name = _detalhes:GetOnlyName (name)
							--name = _detalhes:RemoveOwnerName (name)
							
							label1:SetText (name .. ":")
							local class = myReceivedHeal [i][3]
							if (class) then
								local c = RAID_CLASS_COLORS [class]
								if (c) then
									label1:SetTextColor (c.r, c.g, c.b)
								end
							else
								label1:SetTextColor (.8, .8, .8, 1)
							end
							
							local last_actor = last_combat (2, myReceivedHeal [i][1])
							if (last_actor) then
								local targets = last_actor.targets
								local amount = targets [player.nome] or 0
								if (amount) then
									
									local last_heal = amount
									
									local ps, diff = getpercent (myReceivedHeal[i][2], last_heal, 1, true)
									label2:SetText ( _detalhes:ToK2 (myReceivedHeal[i][2] or 0) .. " (" .. diff .. ")")
									
								else
									label2:SetText ( _detalhes:ToK2 (myReceivedHeal[i][2] or 0))
								end
							else
								label2:SetText ( _detalhes:ToK2 (myReceivedHeal[i][2] or 0))
							end
							
							
						else
							label1:SetText ("-- -- -- --")
							label1:SetTextColor (.8, .8, .8, 1)
							label2:SetText ("")
						end
					end
				end
				
			--> Spells
				--> cooldowns
				local index_used = 1
				local misc_player = combat (4, player.nome)
				local encounter_time = combat:GetCombatTime()
				
				if (misc_player) then
					if (misc_player.cooldowns_defensive_spells) then
						local minha_tabela = misc_player.cooldowns_defensive_spells._ActorTable
						local buffUpdateSpells = misc_player.buff_uptime_spells -- ._ActorTable

						local cooldowns_usados = {}
						
						for _spellid, _tabela in pairs (minha_tabela) do
							cooldowns_usados [#cooldowns_usados+1] = {_spellid, _tabela.counter}
						end

						if (#cooldowns_usados > 0) then

							table.sort (cooldowns_usados, _detalhes.Sort2)
						
							for i = 1, #cooldowns_usados do
								local esta_habilidade = cooldowns_usados[i]
								local nome_magia, _, icone_magia = _GetSpellInfo (esta_habilidade[1])
								
								local label1, label2, icon1, framebg = unpack (tab ["spell" .. index_used])
								framebg.spellid = esta_habilidade[1]
								framebg:Show()
								
								--> attempt to get the buff update
								local spellInfo = buffUpdateSpells:GetSpell (framebg.spellid)
								if (spellInfo) then
									label2:SetText (esta_habilidade[2] .. " (" .. floor (spellInfo.uptime / encounter_time * 100) .. "% uptime)")
								else
									label2:SetText (esta_habilidade[2])
								end

								--> update the line
								label1:SetText (nome_magia .. ":")
								
								icon1:SetTexture (icone_magia)
								icon1:SetTexCoord (0.0625, 0.953125, 0.0625, 0.953125)
								
								index_used = index_used + 1
							end
						end
					end
				end
				
				local cooldownInfo = DetailsFramework.CooldownsInfo
				
				--> see cooldowns that other players used in this actor
				for playerName, _ in pairs (combat.raid_roster) do
					if (playerName ~= player.nome) then
						local miscPlayer = combat (4, playerName)
						if (miscPlayer) then
							if (miscPlayer.cooldowns_defensive_spells) then
								local cooldowns = miscPlayer.cooldowns_defensive_spells
								for spellID, spellTable in cooldowns:ListActors() do
									local targets = spellTable.targets
									if (targets) then
										for targetName, amountCasted in pairs (targets) do
											if (targetName == player.nome) then
												local spellName, _, spellIcon = _GetSpellInfo (spellID)
												local label1, label2, icon1, framebg = unpack (tab ["spell" .. index_used])
												framebg.spellid = spellID
												framebg:Show()
												
												--> attempt to get the buff update
												local info = cooldownInfo [spellID]
												local cooldownDuration = info and info.duration or 0
												
												if (cooldownDuration > 0) then
													label2:SetText (amountCasted .. " (" .. "|cFFFFFF00" .. miscPlayer.nome .. "|r " .. floor (cooldownDuration / encounter_time * 100) .. "% uptime)")
												else
													label2:SetText (amountCasted)
												end
												
												--> update the line
												label1:SetText (spellName .. ":")
												
												icon1:SetTexture (spellIcon)
												icon1:SetTexCoord (0.0625, 0.953125, 0.0625, 0.953125)
												
												index_used = index_used + 1
											end
										end
									end
								end
							end
						end
					end
				end
				
				
				for i = index_used, 40 do
					local label1, label2, icon1, framebg = unpack (tab ["spell" .. i])
					
					framebg.spellid = nil
					framebg:Hide()
					label1:SetText ("")
					label2:SetText ("")
					icon1:SetTexture (nil)
				end
				
			--> habilidade usada para interromper

				
				
			
--[[
			
--]]
		end
		
		local iconTableAvoidance = {
			texture = [[Interface\AddOns\Details\images\icons]],
			--coords = {363/512, 381/512, 0/512, 17/512},
			coords = {384/512, 402/512, 19/512, 38/512},
			width = 16,
			height = 16,
		}		
		
		_detalhes:CreatePlayerDetailsTab ("Avoidance", Loc ["STRING_INFO_TAB_AVOIDANCE"], --[1] tab name [2] localized name
			function (tabOBject, playerObject)  --[2] condition
				if (playerObject.isTank) then 
					return true 
				else 
					return false 
				end
			end, 
			
			avoidance_fill, --[3] fill function
			
			nil, --[4] onclick
			
			avoidance_create, --[5] oncreate
			iconTableAvoidance
		)
	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> ~auras

	local auras_tab_create = function (tab, frame)
		local DF = _detalhes.gump
		local scroll_line_amount = 22
		local scroll_line_height = 19
		local scroll_width = 410
		local scrollHeight = 445
		local scroll_line_height = 19
		local text_size = 10
		
		local debuffScrollStartX = 445
		
		local headerOffsetsBuffs = {
			--buff label, uptime, applications, refreshes, wa
			6, 190, 290, 336, 380
		}
		
		local headerOffsetsDebuffs = {
			--debuff label, uptime, applications, refreshes, wa
			426, 630, 729, 775, 820
		}		
		
		local line_onenter = function (self)
			GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
			_detalhes:GameTooltipSetSpellByID (self.spellID)
			GameTooltip:Show()
			self:SetBackdropColor (1, 1, 1, .2)
		end
		
		local line_onleave = function (self)
			GameTooltip:Hide()
			self:SetBackdropColor (unpack (self.BackgroundColor))
		end
		
		local line_onclick = function (self)
			
		end
		
		--buff scroll
		--icon - name - applications - refreshes - uptime
		--
		
		local wa_button = function (self, mouseButton, spellID, auraType)
			local spellName, _, spellIcon = GetSpellInfo (spellID)
			_detalhes:OpenAuraPanel (spellID, spellName, spellIcon, nil, auraType == "BUFF" and 4 or 2, 1)
		end
		
		local scroll_createline = function (self, index)
			local line = CreateFrame ("button", "$parentLine" .. index, self,"BackdropTemplate")
			line:SetPoint ("topleft", self, "topleft", 1, -((index-1)*(scroll_line_height+1)))
			line:SetSize (scroll_width -2, scroll_line_height)
			line:SetScript ("OnEnter", line_onenter)
			line:SetScript ("OnLeave", line_onleave)
			line:SetScript ("OnClick", line_onclick)
			
			line:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
			line:SetBackdropColor (0, 0, 0, 0.2)
			
			local icon = line:CreateTexture ("$parentIcon", "overlay")
			icon:SetSize (scroll_line_height -2 , scroll_line_height - 2)
			local name = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
			local uptime = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
			local apply = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
			local refresh = line:CreateFontString ("$parentName", "overlay", "GameFontNormal")
			
			local waButton = DF:CreateButton (line, wa_button, 18, 18)
			waButton:SetIcon ([[Interface\AddOns\WeakAuras\Media\Textures\icon]])
			
			DF:SetFontSize (name, text_size)
			DF:SetFontSize (uptime, text_size)
			DF:SetFontSize (apply, text_size)
			DF:SetFontSize (refresh, text_size)
			
			icon:SetPoint ("left", line, "left", 2, 0)
			name:SetPoint ("left", icon, "right", 2, 0)
			uptime:SetPoint ("left", line, "left", 186, 0)
			apply:SetPoint ("left", line, "left", 276, 0)
			refresh:SetPoint ("left", line, "left", 322, 0)
			waButton:SetPoint ("left", line, "left", 372, 0)
			
			line.Icon = icon
			line.Name = name
			line.Uptime = uptime
			line.Apply = apply
			line.Refresh = refresh
			line.WaButton = waButton

			name:SetJustifyH ("left")
			uptime:SetJustifyH ("left")
			
			apply:SetJustifyH ("center")
			refresh:SetJustifyH ("center")
			apply:SetWidth (26)
			refresh:SetWidth (26)
			
			return line
		end
		
		local line_bg_color = {{1, 1, 1, .1}, {1, 1, 1, 0}}
		
		local scroll_buff_refresh = function (self, data, offset, total_lines)
		
			local haveWA = _G.WeakAuras
		
			for i = 1, total_lines do
				local index = i + offset
				local aura = data [index]
				
				if (aura) then
					local line = self:GetLine (i)
					line.spellID = aura.spellID
					line.Icon:SetTexture (aura [1])
					
					line.Icon:SetTexCoord (.1, .9, .1, .9)

					line.Name:SetText (aura [2])
					line.Uptime:SetText (DF:IntegerToTimer (aura [3]) .. " (|cFFBBAAAA" .. floor (aura [6]) .. "%|r)")
					line.Apply:SetText (aura [4])
					line.Refresh:SetText (aura [5])
					
					if (haveWA) then
						line.WaButton:SetClickFunction (wa_button, aura.spellID, line.AuraType)
					else
						line.WaButton:Disable()
					end
					
					if (i%2 == 0) then
						line:SetBackdropColor (unpack (line_bg_color [1]))
						line.BackgroundColor = line_bg_color [1]
					else
						line:SetBackdropColor (unpack (line_bg_color [2]))
						line.BackgroundColor = line_bg_color [2]
					end
				end
			end
		end
		
		local create_titledesc_frame = function (anchorWidget, desc)
			local f = CreateFrame ("frame", nil, frame)
			f:SetSize (40, 20)
			f:SetPoint ("center", anchorWidget, "center")
			f:SetScript ("OnEnter", function()
				GameTooltip:SetOwner (f, "ANCHOR_TOPRIGHT")
				GameTooltip:AddLine (desc)
				GameTooltip:Show()
			end)
			f:SetScript ("OnLeave", function()
				GameTooltip:Hide()
			end)
			return f
		end
		

		
		local buffLabel = DF:CreateLabel (frame, "Buff Name")
		buffLabel:SetPoint (headerOffsetsBuffs[1], -10)
		local uptimeLabel = DF:CreateLabel (frame, "Uptime")
		uptimeLabel:SetPoint (headerOffsetsBuffs[2], -10)
		
		local appliedLabel = DF:CreateLabel (frame, "A")
		appliedLabel:SetPoint (headerOffsetsBuffs[3], -10)
		create_titledesc_frame (appliedLabel.widget, "applications")
		
		local refreshedLabel = DF:CreateLabel (frame, "R")
		refreshedLabel:SetPoint (headerOffsetsBuffs[4], -10)
		create_titledesc_frame (refreshedLabel.widget, "refreshes")
		
		local waLabel = DF:CreateLabel (frame, "WA")
		waLabel:SetPoint (headerOffsetsBuffs[5], -10)
		create_titledesc_frame (waLabel.widget, "create weak aura")
		
		local buffScroll = DF:CreateScrollBox (frame, "$parentBuffUptimeScroll", scroll_buff_refresh, {}, scroll_width, scrollHeight, scroll_line_amount, scroll_line_height)
		buffScroll:SetPoint ("topleft", frame, "topleft", 5, -30)
		for i = 1, scroll_line_amount do 
			local line = buffScroll:CreateLine (scroll_createline)
			line.AuraType = "BUFF"
		end
		DF:ReskinSlider (buffScroll)
		tab.BuffScroll = buffScroll
		
		--debuff scroll
		--icon - name - applications - refreshes - uptime
		--
		
		local debuffLabel = DF:CreateLabel (frame, "Debuff Name")
		debuffLabel:SetPoint (headerOffsetsDebuffs[1], -10)
		local uptimeLabel2 = DF:CreateLabel (frame, "Uptime")
		uptimeLabel2:SetPoint (headerOffsetsDebuffs[2], -10)
		
		local appliedLabel2 = DF:CreateLabel (frame, "A")
		appliedLabel2:SetPoint (headerOffsetsDebuffs[3], -10)
		create_titledesc_frame (appliedLabel2.widget, "applications")
		
		local refreshedLabel2 = DF:CreateLabel (frame, "R")
		refreshedLabel2:SetPoint (headerOffsetsDebuffs[4], -10)
		create_titledesc_frame (refreshedLabel2.widget, "refreshes")
		
		local waLabel2 = DF:CreateLabel (frame, "WA")
		waLabel2:SetPoint (headerOffsetsDebuffs[5], -10)
		create_titledesc_frame (waLabel2.widget, "create weak aura")

		
		
		local debuffScroll = DF:CreateScrollBox (frame, "$parentDebuffUptimeScroll", scroll_buff_refresh, {}, scroll_width, scrollHeight, scroll_line_amount, scroll_line_height)
		debuffScroll:SetPoint ("topleft", frame, "topleft", debuffScrollStartX, -30)
		for i = 1, scroll_line_amount do 
			local line = debuffScroll:CreateLine (scroll_createline)
			line.AuraType = "DEBUFF"
		end
		DF:ReskinSlider (debuffScroll)

		tab.DebuffScroll = debuffScroll
	end
	
	local auras_tab_fill = function (tab, player, combat)
		
		local miscActor = combat:GetActor (4, player:name())
		local combatTime = combat:GetCombatTime()
		
		do --buffs
			local newAuraTable = {}
			if (miscActor and miscActor.buff_uptime_spells) then
				for spellID, spellObject in pairs (miscActor.buff_uptime_spells._ActorTable) do
					local spellName, _, spellIcon = GetSpellInfo (spellID)
					tinsert (newAuraTable, {spellIcon, spellName, spellObject.uptime, spellObject.appliedamt, spellObject.refreshamt, spellObject.uptime/combatTime*100, spellID = spellID})
				end
			end
			table.sort (newAuraTable, _detalhes.Sort3)
			tab.BuffScroll:SetData (newAuraTable)
			tab.BuffScroll:Refresh()
		end
		
		do --debuffs
			local newAuraTable = {}
			if (miscActor and miscActor.debuff_uptime_spells) then
				for spellID, spellObject in pairs (miscActor.debuff_uptime_spells._ActorTable) do
					local spellName, _, spellIcon = GetSpellInfo (spellID)
					tinsert (newAuraTable, {spellIcon, spellName, spellObject.uptime, spellObject.appliedamt, spellObject.refreshamt, spellObject.uptime/combatTime*100, spellID = spellID})
				end
			end
			table.sort (newAuraTable, _detalhes.Sort3)
			tab.DebuffScroll:SetData (newAuraTable)
			tab.DebuffScroll:Refresh()
		end		
	end

	local iconTableAuras = {
		texture = [[Interface\AddOns\Details\images\icons]],
		coords = {257/512, 278/512, 0/512, 19/512},
		width = 16,
		height = 16,
	}	
	
	_detalhes:CreatePlayerDetailsTab ("Auras", "Auras", --[1] tab name [2] localized name
		function (tabOBject, playerObject)  --[2] condition
			return true
		end, 
		
		auras_tab_fill, --[3] fill function
		
		nil, --[4] onclick
		
		auras_tab_create, --[5] oncreate
		iconTableAuras --icon table
	)


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> ~compare 

		local target_texture = [[Interface\MINIMAP\TRACKING\Target]]
		local empty_text = ""
		
		local plus = red .. "-" 
		local minor = green .. "+"
		
		local bar_color = {.5, .5, .5, .4} -- bar of the second and 3rd player
		local bar_color_on_enter = {.9, .9, .9, .9}
		
		local frame_backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true}
		local frame_backdrop_color = {0, 0, 0, 0.35}
		local frame_backdrop_border_color = {0, 0, 0, 0}
		
		local spell_compare_frame_width = {298, 225, 226}
		local spell_compare_frame_height = 200
		local target_compare_frame_height = 142
		
		local xLocation = 2
		local yLocation = -20
		local targetBars = 9
		
		local fill_compare_targets = function (self, player, other_players, target_pool)
			
			local offset = FauxScrollFrame_GetOffset (self)
			
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
			
			local total = player.total_without_pet
			
			if (not target_pool [1]) then
				for i = 1, targetBars do 
					local bar = self.bars [i]
					local bar_2 = frame2.bars [i]
					local bar_3 = frame3.bars [i]
					
					bar [1]:SetTexture (nil)
					bar [2].lefttext:SetText (empty_text)
					bar [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar [2].righttext:SetText ("")
					bar [2].righttext2:SetText ("")
					bar [2]:SetValue (0)
					bar [2]:SetBackdropColor (1, 1, 1, 0)
					bar [3][4] = nil
					bar_2 [1]:SetTexture (nil)
					bar_2 [2].lefttext:SetText (empty_text)
					bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_2 [2].righttext:SetText ("")
					bar_2 [2].righttext2:SetText ("")
					bar_2 [2]:SetValue (0)
					bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
					bar_2 [3][4] = nil
					bar_3 [1]:SetTexture (nil)
					bar_3 [2].lefttext:SetText (empty_text)
					bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_3 [2].righttext:SetText ("")
					bar_3 [2].righttext2:SetText ("")
					bar_3 [2]:SetValue (0)
					bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
					bar_3 [3][4] = nil
				end
				
				return
			end
			
			local top = target_pool [1] [2]
			
			--player 2
			local player_2 = other_players [1]
			local player_2_target_pool
			local player_2_top
			if (player_2) then
				local player_2_target = player_2.targets
				player_2_target_pool = {}
				for target_name, amount in _pairs (player_2_target) do
					player_2_target_pool [#player_2_target_pool+1] = {target_name, amount}
				end
				table.sort (player_2_target_pool, _detalhes.Sort2)
				if (player_2_target_pool [1]) then
					player_2_top = player_2_target_pool [1] [2]
				else
					player_2_top = 0
				end
				--1 skill, 
			end

			--player 3
			local player_3 = other_players [2]
			local player_3_target_pool
			local player_3_top
			if (player_3) then
				local player_3_target = player_3.targets
				player_3_target_pool = {}
				for target_name, amount in _pairs (player_3_target) do 
					player_3_target_pool [#player_3_target_pool+1] = {target_name, amount}
				end
				table.sort (player_3_target_pool, _detalhes.Sort2)
				if (player_3_target_pool [1]) then
					player_3_top = player_3_target_pool [1] [2]
				else
					player_3_top = 0
				end
			end

			for i = 1, targetBars do 
				local bar = self.bars [i]
				local bar_2 = frame2.bars [i]
				local bar_3 = frame3.bars [i]
				
				local index = i + offset
				local data = target_pool [index]
				
				if (data) then --[name] [total]
				
					local target_name = data [1]
					
					bar [1]:SetTexture (target_texture)
					bar [1]:SetDesaturated (true)
					bar [1]:SetAlpha (.7)
					
					bar [2].lefttext:SetText (index .. ". " .. target_name)
					bar [2].lefttext:SetTextColor (1, 1, 1, 1)
					bar [2].righttext:SetText (_detalhes:ToK2Min (data [2])) -- .. " (" .. _math_floor (data [2] / total * 100) .. "%)"
					bar [2]:SetValue (data [2] / top * 100)
					--bar [2]:SetValue (100)
					bar [3][1] = player.nome --name
					bar [3][2] = target_name
					bar [3][3] = data [2] --total
					bar [3][4] = player
					
					-- 2
					if (player_2) then

						local player_2_target_total
						local player_2_target_index
						
						for index, t in _ipairs (player_2_target_pool) do
							if (t[1] == target_name) then
								player_2_target_total = t[2]
								player_2_target_index = index
								break
							end
						end
						
						if (player_2_target_total) then
							bar_2 [1]:SetTexture (target_texture)
							bar_2 [1]:SetDesaturated (true)
							bar_2 [1]:SetAlpha (.7)
							
							bar_2 [2].lefttext:SetText (player_2_target_index .. ". " .. target_name)
							bar_2 [2].lefttext:SetTextColor (1, 1, 1, 1)
							
							if (data [2] > player_2_target_total) then
								local diff = data [2] - player_2_target_total
								local up = diff / player_2_target_total * 100
								up = _math_floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								
								bar_2 [2].righttext2:SetText (_detalhes:ToK2Min (player_2_target_total))
								bar_2 [2].righttext:SetText (" |c" .. minor .. up .. "%|r")
							else
								local diff = player_2_target_total - data [2]
								local down = diff / data [2] * 100
								down = _math_floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								bar_2 [2].righttext2:SetText (_detalhes:ToK2Min (player_2_target_total))
								bar_2 [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
							end
							
							--bar_2 [2]:SetValue (player_2_target_total / player_2_top * 100)
							bar_2 [2]:SetValue (100)
							
							bar_2 [3][1] = player_2.nome
							bar_2 [3][2] = target_name
							bar_2 [3][3] = player_2_target_total
							bar_2 [3][4] = player_2
							
						else
							bar_2 [1]:SetTexture (nil)
							bar_2 [2].lefttext:SetText (empty_text)
							bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
							bar_2 [2].righttext:SetText ("")
							bar_2 [2].righttext2:SetText ("")
							bar_2 [2]:SetValue (0)
							bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
							bar_2 [3][4] = nil
						end
					else
						bar_2 [1]:SetTexture (nil)
						bar_2 [2].lefttext:SetText (empty_text)
						bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
						bar_2 [2].righttext:SetText ("")
						bar_2 [2].righttext2:SetText ("")
						bar_2 [2]:SetValue (0)
						bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
						bar_2 [3][4] = nil
					end
					
					-- 3
					if (player_3) then

						local player_3_target_total
						local player_3_target_index
						
						for index, t in _ipairs (player_3_target_pool) do
							if (t[1] == target_name) then
								player_3_target_total = t[2]
								player_3_target_index = index
								break
							end
						end
						
						if (player_3_target_total) then
							bar_3 [1]:SetTexture (target_texture)
							bar_3 [1]:SetDesaturated (true)
							bar_3 [1]:SetAlpha (.7)
							
							bar_3 [2].lefttext:SetText (player_3_target_index .. ". " .. target_name)
							bar_3 [2].lefttext:SetTextColor (1, 1, 1, 1)
							
							if (data [2] > player_3_target_total) then
								local diff = data [2] - player_3_target_total
								local up = diff / player_3_target_total * 100
								up = _math_floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								bar_3 [2].righttext2:SetText (_detalhes:ToK2Min (player_3_target_total))
								bar_3 [2].righttext:SetText (" |c" .. minor .. up .. "%|r")
							else
								local diff = player_3_target_total - data [2]
								local down = diff / data [2] * 100
								down = _math_floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								bar_3 [2].righttext:SetText (_detalhes:ToK2Min (player_3_target_total))
								bar_3 [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
							end
							
							--bar_3 [2]:SetValue (player_3_target_total / player_3_top * 100)
							bar_3 [2]:SetValue (100)
							
							bar_3 [3][1] = player_3.nome
							bar_3 [3][2] = target_name
							bar_3 [3][3] = player_3_target_total
							bar_3 [3][4] = player_3
							
						else
							bar_3 [1]:SetTexture (nil)
							bar_3 [2].lefttext:SetText (empty_text)
							bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
							bar_3 [2].righttext:SetText ("")
							bar_3 [2].righttext2:SetText ("")
							bar_3 [2]:SetValue (0)
							bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
							bar_3 [3][4] = nil
						end
					else
						bar_3 [1]:SetTexture (nil)
						bar_3 [2].lefttext:SetText (empty_text)
						bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
						bar_3 [2].righttext:SetText ("")
						bar_3 [2].righttext2:SetText ("")
						bar_3 [2]:SetValue (0)
						bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
						bar_3 [3][4] = nil
					end
					
				else
					bar [1]:SetTexture (nil)
					bar [2].lefttext:SetText (empty_text)
					bar [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar [2].righttext:SetText ("")
					bar [2].righttext2:SetText ("")
					bar [2]:SetValue (0)
					bar [2]:SetBackdropColor (1, 1, 1, 0)
					bar [3][4] = nil
					bar_2 [1]:SetTexture (nil)
					bar_2 [2].lefttext:SetText (empty_text)
					bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_2 [2].righttext:SetText ("")
					bar_2 [2].righttext2:SetText ("")
					bar_2 [2]:SetValue (0)
					bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
					bar_2 [3][4] = nil
					bar_3 [1]:SetTexture (nil)
					bar_3 [2].lefttext:SetText (empty_text)
					bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_3 [2].righttext:SetText ("")
					bar_3 [2].righttext2:SetText ("")
					bar_3 [2]:SetValue (0)
					bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
					bar_3 [3][4] = nil
				end
			end
			
		end

		local fill_compare_actors = function (self, player, other_players)
			
			--main player skills
			local spells_sorted = {}
			for spellid, spelltable in _pairs (player.spells._ActorTable) do
				spells_sorted [#spells_sorted+1] = {spelltable, spelltable.total}
			end
			
			--main player pets
			for petIndex, petName in _ipairs (player:Pets()) do
				local petActor = info.instancia.showing [player.tipo]:PegarCombatente (nil, petName)
				if (petActor) then
					for _spellid, _skill in _pairs (petActor:GetActorSpells()) do
						spells_sorted [#spells_sorted+1] = {_skill, _skill.total, petName}
					end
				end
			end
			table.sort (spells_sorted, _detalhes.Sort2)
		
			self.player = player:Name()
		
			local offset = FauxScrollFrame_GetOffset (self)
		
			local total = player.total_without_pet
			local top = spells_sorted [1] and spells_sorted [1] [2] or 0
			
			local frame2 = DetailsPlayerComparisonBox2
			local frame3 = DetailsPlayerComparisonBox3

			local player_2_total
			local player_2_spells_sorted
			local player_2_top
			local player_2_spell_info
			
			if (other_players [1]) then
				frame2.player = other_players [1]:Name()
				player_2_total = other_players [1].total_without_pet
				player_2_spells_sorted = {}
				
				--player 2 spells
				for spellid, spelltable in _pairs (other_players [1].spells._ActorTable) do
					player_2_spells_sorted [#player_2_spells_sorted+1] = {spelltable, spelltable.total}
				end
				--player 2 pets
				for petIndex, petName in _ipairs (other_players [1]:Pets()) do
					local petActor = info.instancia.showing [player.tipo]:PegarCombatente (nil, petName)
					if (petActor) then
						for _spellid, _skill in _pairs (petActor:GetActorSpells()) do
							player_2_spells_sorted [#player_2_spells_sorted+1] = {_skill, _skill.total, petName}
						end
					end
				end
				
				table.sort (player_2_spells_sorted, _detalhes.Sort2)
				player_2_top = (player_2_spells_sorted [1] and player_2_spells_sorted [1] [2]) or 0
				--se n�o existir uma magia no jogador e o jogador tiver um pet, ele n�o vai encontrar um valor em [1] e dar
				-- ~pet
				player_2_spell_info = {}
				for index, spelltable in _ipairs (player_2_spells_sorted) do 
					player_2_spell_info [spelltable[1].id] = index
				end
				
				frame2.NoPLayersToShow:Hide()
				frame3.NoPLayersToShow:Hide()
			else
				frame2.NoPLayersToShow:Show()
				frame3.NoPLayersToShow:Show()
			end
			
			local player_3_total
			local player_3_spells_sorted
			local player_3_spell_info
			local player_3_top
			
			if (other_players [2]) then
				frame3.player = other_players [2] and other_players [2]:Name()
				player_3_total = other_players [2] and other_players [2].total_without_pet
				player_3_spells_sorted = {}
				player_3_spell_info = {}
				
				if (other_players [2]) then
					--player 3 spells
					for spellid, spelltable in _pairs (other_players [2].spells._ActorTable) do
						player_3_spells_sorted [#player_3_spells_sorted+1] = {spelltable, spelltable.total}
					end
					--player 3 pets
					for petIndex, petName in _ipairs (other_players [2]:Pets()) do
						local petActor = info.instancia.showing [player.tipo]:PegarCombatente (nil, petName)
						if (petActor) then
							for _spellid, _skill in _pairs (petActor:GetActorSpells()) do
								player_3_spells_sorted [#player_3_spells_sorted+1] = {_skill, _skill.total, petName}
							end
						end
					end
					
					table.sort (player_3_spells_sorted, _detalhes.Sort2)
					player_3_top = player_3_spells_sorted [1] [2]
					for index, spelltable in _ipairs (player_3_spells_sorted) do 
						player_3_spell_info [spelltable[1].id] = index
					end
				end
			end

			for i = 1, 12 do 
				local bar = self.bars [i]
				local index = i + offset
				
				--main player spells
				local data = spells_sorted [index]
				
				if (data) then --if exists
				
					--main player - seta no primeiro box
						local spellid = data [1].id
						local name, _, icon = _GetSpellInfo (spellid)
						local petName = data [3]
						
						bar [1]:SetTexture (icon) --bar[1] = spellicon bar[2] = statusbar
						bar [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar

						bar [2]:SetBackdropColor (1, 1, 1, 0.1)
						
						if (petName) then
							bar [2].lefttext:SetText (index .. ". " .. name .. " (|cFFCCBBBB" .. petName:gsub (" <.*", "") .. "|r)")
						else
							bar [2].lefttext:SetText (index .. ". " .. name)
						end
						bar [2].lefttext:SetTextColor (1, 1, 1, 1)
						bar [2].righttext:SetText (_detalhes:ToK2Min (data [2])) -- .. " (" .. _math_floor (data [2] / total * 100) .. "%)"
						bar [2]:SetValue (data [2] / top * 100)
						--bar [2]:SetValue (100)
						bar [3][1] = data [1].counter --tooltip hits
						bar [3][2] = data [2] / data [1].counter --tooltip average
						bar [3][3] = _math_floor (data [1].c_amt / data [1].counter * 100) --tooltip critical
						bar [3][4] = spellid

					--player 2
					local player_2 = other_players [1]
					local spell = player_2 and player_2.spells._ActorTable [spellid]
					
					if (not spell and petName and player_2) then
						for _petIndex, _petName in _ipairs (player_2:Pets()) do
							if (_petName:gsub (" <.*", "") == petName:gsub (" <.*", "")) then
								local petActor = info.instancia.showing [player.tipo]:PegarCombatente (nil, _petName)
								spell = petActor and petActor.spells._ActorTable [spellid]
								name = name .. " (|cFFCCBBBB" .. _petName:gsub (" <.*", "") .. "|r)"
							end
						end
					end
					
					local bar_2 = frame2 and frame2.bars [i]
					
					-- ~compare
					if (spell) then
						bar_2 [1]:SetTexture (icon)
						bar_2 [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar
						bar_2 [2].lefttext:SetText (player_2_spell_info [spellid] .. ". " .. name)
						bar_2 [2].lefttext:SetTextColor (1, 1, 1, 1)
						bar_2 [2]:SetStatusBarColor (unpack (bar_color))
						bar_2 [2]:SetBackdropColor (1, 1, 1, 0.1)
						
						if (spell.total == 0 and data [2] == 0) then
							bar_2 [2].righttext2:SetText ("0")
							bar_2 [2].righttext:SetText ("+0%")
							
						elseif (data [2] > spell.total) then
							if (spell.total > 0) then
								local diff = data [2] - spell.total
								local up = diff / spell.total * 100
								up = _math_floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								bar_2 [2].righttext2:SetText (_detalhes:ToK2Min (spell.total))
								bar_2 [2].righttext:SetText (" |c" .. minor .. up .. "%|r")
							else
								bar_2 [2].righttext2:SetText ("0")
								bar_2 [2].righttext:SetText ("+0%")
							end
							
						else
							if (data [2] > 0) then
								local diff = spell.total - data [2]
								local down = diff / data [2] * 100
								down = _math_floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								bar_2 [2].righttext2:SetText (_detalhes:ToK2Min (spell.total))
								bar_2 [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
							else
								bar_2 [2].righttext2:SetText ("0")
								bar_2 [2].righttext:SetText ("+0%")
							end
						end
						
						bar_2 [2]:SetValue (spell.total / player_2_top * 100)
						bar_2 [2]:SetValue (100)
						bar_2 [3][1] = spell.counter --tooltip hits
						bar_2 [3][2] = spell.total / spell.counter --tooltip average
						bar_2 [3][3] = _math_floor (spell.c_amt / spell.counter * 100) --tooltip critical
						bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
					else
						bar_2 [1]:SetTexture (nil)
						bar_2 [2].lefttext:SetText (empty_text)
						bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
						bar_2 [2].righttext:SetText ("")
						bar_2 [2].righttext2:SetText ("")
						bar_2 [2]:SetValue (0)
						bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
					end
					
					--player 3
					local bar_3 = frame3 and frame3.bars [i]
					
					if (player_3_total) then
						local player_3 = other_players [2]
						local spell = player_3 and player_3.spells._ActorTable [spellid]
						
						if (not spell and petName and player_3) then
							for _petIndex, _petName in _ipairs (player_3:Pets()) do
								if (_petName:gsub (" <.*", "") == petName:gsub (" <.*", "")) then
									local petActor = info.instancia.showing [player.tipo]:PegarCombatente (nil, _petName)
									spell = petActor and petActor.spells._ActorTable [spellid]
									local name, _, icon = _GetSpellInfo (spellid)
									name = name .. " (|cFFCCBBBB" .. _petName:gsub (" <.*", "") .. "|r)"
								end
							end
						end
						
						if (spell) then
							bar_3 [1]:SetTexture (icon)
							bar_3 [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar
							bar_3 [2].lefttext:SetText (player_3_spell_info [spellid] .. ". " .. name)
							bar_3 [2].lefttext:SetTextColor (1, 1, 1, 1)
							bar_3 [2]:SetStatusBarColor (unpack (bar_color))
							bar_3 [2]:SetBackdropColor (1, 1, 1, 0.1)
							
							if (spell.total == 0 and data [2] == 0) then
								bar_3 [2].righttext2:SetText ("0")
								bar_3 [2].righttext:SetText ("+0%")
								
							elseif (data [2] > spell.total) then
								if (spell.total > 0) then
									local diff = data [2] - spell.total
									local up = diff / spell.total * 100
									up = _math_floor (up)
									if (up > 999) then
										up = "" .. 999
									end
									bar_3 [2].righttext2:SetText (_detalhes:ToK2Min (spell.total))
									bar_3 [2].righttext:SetText (" |c" .. minor .. up .. "%|r")
								else
									bar_3 [2].righttext2:SetText ("0")
									bar_3 [2].righttext:SetText ("0%")
								end
							else
								if (data [2] > 0) then
									local diff = spell.total - data [2]
									local down = diff / data [2] * 100
									down = _math_floor (down)
									if (down > 999) then
										down = "" .. 999
									end
									bar_3 [2].righttext2:SetText (_detalhes:ToK2Min (spell.total))
									bar_3 [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
								else
									bar_3 [2].righttext:SetText ("0")
									bar_3 [2].righttext:SetText ("+0%")
								end
							end
							
							bar_3 [2]:SetValue (spell.total / player_3_top * 100)
							bar_3 [2]:SetValue (100)
							bar_3 [3][1] = spell.counter --tooltip hits
							bar_3 [3][2] = spell.total / spell.counter --tooltip average
							bar_3 [3][3] = _math_floor (spell.c_amt / spell.counter * 100) --tooltip critical
						else
							bar_3 [1]:SetTexture (nil)
							bar_3 [2].lefttext:SetText (empty_text)
							bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
							bar_3 [2].righttext:SetText ("")
							bar_3 [2].righttext2:SetText ("")
							bar_3 [2]:SetValue (0)
							bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
						end
					else
						bar_3 [1]:SetTexture (nil)
						bar_3 [2].lefttext:SetText (empty_text)
						bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
						bar_3 [2].righttext:SetText ("")
						bar_3 [2].righttext2:SetText ("")
						bar_3 [2]:SetValue (0)
						bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
					end
				else
					bar [1]:SetTexture (nil)
					bar [2].lefttext:SetText (empty_text)
					bar [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar [2].righttext:SetText ("")
					bar [2]:SetValue (0)
					bar [2]:SetBackdropColor (1, 1, 1, 0)
					local bar_2 = frame2.bars [i]
					bar_2 [1]:SetTexture (nil)
					bar_2 [2].lefttext:SetText (empty_text)
					bar_2 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_2 [2].righttext:SetText ("")
					bar_2 [2].righttext2:SetText ("")
					bar_2 [2]:SetValue (0)
					bar_2 [2]:SetBackdropColor (1, 1, 1, 0)
					local bar_3 = frame3.bars [i]
					bar_3 [1]:SetTexture (nil)
					bar_3 [2].lefttext:SetText (empty_text)
					bar_3 [2].lefttext:SetTextColor (.5, .5, .5, 1)
					bar_3 [2].righttext:SetText ("")
					bar_3 [2].righttext2:SetText ("")
					bar_3 [2]:SetValue (0)
					bar_3 [2]:SetBackdropColor (1, 1, 1, 0)
				end
				
			end
			
			for index, spelltable in _ipairs (spells_sorted) do
				
			end
			
		end
	
		local refresh_comparison_box = function (self)
			--atualiza a scroll
			fill_compare_actors (self, self.tab.player, self.tab.players)
			FauxScrollFrame_Update (self, self.tab.spells_amt, 12, 15)
			self:Show()
		end
		
		local refresh_target_box = function (self)
			
			--player 1 targets
			local my_targets = self.tab.player.targets
			local target_pool = {}
			for target_name, amount in _pairs (my_targets) do 
				target_pool [#target_pool+1] = {target_name, amount}
			end
			table.sort (target_pool, _detalhes.Sort2)
			
			FauxScrollFrame_Update (self, #target_pool, targetBars, 14)
			self:Show()

			fill_compare_targets (self, self.tab.player, self.tab.players, target_pool)
		end
	
		local compare_fill = function (tab, player, combat)
			local players_to_compare = tab.players
			
			local defaultPlayerName = _detalhes:GetOnlyName (player:Name())
			DetailsPlayerComparisonBox1.name_label:SetText (defaultPlayerName)
			
			local label2 = _G ["DetailsPlayerComparisonBox2"].name_label
			local label3 = _G ["DetailsPlayerComparisonBox3"].name_label
			
			local label2_percent = _G ["DetailsPlayerComparisonBox2"].name_label_percent
			local label3_percent = _G ["DetailsPlayerComparisonBox3"].name_label_percent
			
			if (players_to_compare [1]) then
				local playerName = _detalhes:GetOnlyName (players_to_compare [1]:Name())
				label2:SetText (playerName)
				label2_percent:SetText (defaultPlayerName .. " %")
			else
				label2:SetText ("")
				label2_percent:SetText ("")
			end
			if (players_to_compare [2]) then
				local playerName = _detalhes:GetOnlyName (players_to_compare [2]:Name())
				label3:SetText (playerName)
				label3_percent:SetText (defaultPlayerName .. " %")
			else
				label3:SetText ("")
				label3_percent:SetText ("")
			end
			
			refresh_comparison_box (DetailsPlayerComparisonBox1)
			refresh_target_box (DetailsPlayerComparisonTarget1)
			
		end
	
		local on_enter_target = function (self)
		
			local frame1 = DetailsPlayerComparisonTarget1
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
		
			local bar1 = frame1.bars [self.index]
			local bar2 = frame2.bars [self.index]
			local bar3 = frame3.bars [self.index]

			local player_1 = bar1 [3] [4]
			if (not player_1) then
				return
			end
			local player_2 = bar2 [3] [4]
			local player_3 = bar3 [3] [4]
			
			local target_name = bar1 [3] [2]
			
			frame1.tooltip:SetPoint ("bottomleft", bar1[2], "topleft", -18, 5)
			frame2.tooltip:SetPoint ("bottomleft", bar2[2], "topleft", -18, 5)
			frame3.tooltip:SetPoint ("bottomleft", bar3[2], "topleft", -18, 5)

			local actor1_total = bar1 [3] [3]
			local actor2_total = bar1 [3] [3]
			local actor3_total = bar1 [3] [3]
			
			-- player 1
			local player_1_skills = {}
			for spellid, spell in _pairs (player_1.spells._ActorTable) do
				for name, amount in _pairs (spell.targets) do
					if (name == target_name) then
						player_1_skills [#player_1_skills+1] = {spellid, amount}
					end
				end
			end
			table.sort (player_1_skills, _detalhes.Sort2)
-- ~pet
			local player_1_top = player_1_skills [1] and player_1_skills [1][2] or 0
			bar1 [2]:SetStatusBarColor (1, 1, 1, 1)
			
			-- player 2
			local player_2_skills = {}
			local player_2_top
			if (player_2) then
				for spellid, spell in _pairs (player_2.spells._ActorTable) do
					for name, amount in _pairs (spell.targets) do
						if (name == target_name) then
							player_2_skills [#player_2_skills+1] = {spellid, amount}
						end
					end
				end
				table.sort (player_2_skills, _detalhes.Sort2)
				player_2_top = player_2_skills [1] and player_2_skills [1][2] or 0
				bar2 [2]:SetStatusBarColor (unpack (bar_color_on_enter))
			end
			
			-- player 3
			local player_3_skills = {}
			local player_3_top
			if (player_3) then
				for spellid, spell in _pairs (player_3.spells._ActorTable) do
					for name, amount in _pairs (spell.targets) do
						if (name == target_name) then
							player_3_skills [#player_3_skills+1] = {spellid, amount}
						end
					end
				end
				table.sort (player_3_skills, _detalhes.Sort2)
				player_3_top = player_3_skills [1] and player_3_skills [1][2] or 0
				bar3 [2]:SetStatusBarColor (unpack (bar_color_on_enter))
			end
			
			-- build tooltip
			frame1.tooltip:Reset()
			frame2.tooltip:Reset()
			frame3.tooltip:Reset()
			
			frame1.tooltip:Show()
			frame2.tooltip:Show()
			frame3.tooltip:Show()
			
			local frame2_gotresults = false
			local frame3_gotresults = false
			
			for index, spell in _ipairs (player_1_skills) do
				local bar = frame1.tooltip.bars [index]
				if (not bar) then
					bar = frame1.tooltip:CreateBar()
				end
				
				local name, _, icon = _GetSpellInfo (spell[1])
				bar [1]:SetTexture (icon)
				bar [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar
				bar [2].lefttext:SetText (index .. ". " .. name)
				bar [2].righttext:SetText (_detalhes:ToK2Min (spell [2]))
				bar [2]:SetValue (spell [2]/player_1_top*100)
				--bar [2]:SetValue (100)
				bar [2].bg:Show()
				
				if (player_2) then
				
					local player_2_skill
					local found_skill = false
					for this_index, this_spell in _ipairs (player_2_skills) do
						if (spell [1] == this_spell[1]) then
							local bar = frame2.tooltip.bars [index]
							if (not bar) then
								bar = frame2.tooltip:CreateBar (index)
							end
							
							bar [1]:SetTexture (icon)
							bar [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar
							bar [2].lefttext:SetText (this_index .. ". " .. name)
							bar [2].bg:Show()
							
							if (spell [2] > this_spell [2]) then
								local diff = spell [2] - this_spell [2]
								local up = diff / this_spell [2] * 100
								up = _math_floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								bar [2].righttext2:SetText (_detalhes:ToK2Min (this_spell [2]))
								bar [2].righttext:SetText (" |c" .. minor .. up .. "%|r")
							else
								local diff = this_spell [2] - spell [2]
								local down = diff / spell [2] * 100
								down = _math_floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								bar [2].righttext2:SetText (_detalhes:ToK2Min (this_spell [2]))
								bar [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
							end

							--bar [2]:SetValue (this_spell [2]/player_2_top*100)
							bar [2]:SetValue (100)
							found_skill = true
							frame2_gotresults = true
							break
						end
					end
					if (not found_skill) then
						local bar = frame2.tooltip.bars [index]
						if (not bar) then
							bar = frame2.tooltip:CreateBar (index)
						end
						bar [1]:SetTexture (nil)
						bar [2].lefttext:SetText ("")
						bar [2].righttext:SetText ("")
						bar [2].righttext2:SetText ("")
						bar [2].bg:Hide()
					end
				end
				
				if (player_3) then
					local player_3_skill
					local found_skill = false
					for this_index, this_spell in _ipairs (player_3_skills) do
						if (spell [1] == this_spell[1]) then
							local bar = frame3.tooltip.bars [index]
							if (not bar) then
								bar = frame3.tooltip:CreateBar (index)
							end
							
							bar [1]:SetTexture (icon)
							bar [1]:SetTexCoord (unpack (IconTexCoord)) --bar[1] = spellicon bar[2] = statusbar
							bar [2].lefttext:SetText (this_index .. ". " .. name)
							bar [2].bg:Show()
							
							if (spell [2] > this_spell [2]) then
								local diff = spell [2] - this_spell [2]
								local up = diff / this_spell [2] * 100
								up = _math_floor (up)
								if (up > 999) then
									up = "" .. 999
								end
								bar [2].righttext:SetText (_detalhes:ToK2Min (this_spell [2]) .. " |c" .. minor .. up .. "%|r")
							else
								local diff = this_spell [2] - spell [2]
								local down = diff / spell [2] * 100
								down = _math_floor (down)
								if (down > 999) then
									down = "" .. 999
								end
								bar [2].righttext2:SetText (_detalhes:ToK2Min (this_spell [2]))
								bar [2].righttext:SetText (" |c" .. plus .. down .. "%|r")
							end

							--bar [2]:SetValue (this_spell [2]/player_3_top*100)
							bar [2]:SetValue (100)
							found_skill = true
							frame3_gotresults = true
							break
						end
					end
					if (not found_skill) then
						local bar = frame3.tooltip.bars [index]
						if (not bar) then
							bar = frame3.tooltip:CreateBar (index)
						end
						bar [1]:SetTexture (nil)
						bar [2].lefttext:SetText ("")
						bar [2].righttext:SetText ("")
						bar [2].righttext2:SetText ("")
						bar [2].bg:Hide()
					end
				end
				
			end
			
			frame1.tooltip:SetHeight ( (#player_1_skills*15) + 2)
			frame2.tooltip:SetHeight ( (#player_1_skills*15) + 2)
			frame3.tooltip:SetHeight ( (#player_1_skills*15) + 2)
			
			if (not frame2_gotresults) then
				frame2.tooltip:Hide()
			end
			if (not frame3_gotresults) then
				frame3.tooltip:Hide()
			end

		end
		
		local on_leave_target = function (self)
			local frame1 = DetailsPlayerComparisonTarget1
			local frame2 = DetailsPlayerComparisonTarget2
			local frame3 = DetailsPlayerComparisonTarget3
		
			local bar1 = frame1.bars [self.index]
			local bar2 = frame2.bars [self.index]
			local bar3 = frame3.bars [self.index]
		
			bar1[2]:SetStatusBarColor (.5, .5, .5, 1)
			bar1[2].icon:SetTexCoord (0, 1, 0, 1)
			bar2[2]:SetStatusBarColor (unpack (bar_color))
			bar2[2].icon:SetTexCoord (0, 1, 0, 1)
			bar3[2]:SetStatusBarColor (unpack (bar_color))
			bar3[2].icon:SetTexCoord (0, 1, 0, 1)
			
			frame1.tooltip:Hide()
			frame2.tooltip:Hide()
			frame3.tooltip:Hide()
		end
	
		local on_enter = function (self)
		
			local frame1 = DetailsPlayerComparisonBox1
			local frame2 = DetailsPlayerComparisonBox2
			local frame3 = DetailsPlayerComparisonBox3
		
			local bar1 = frame1.bars [self.index]
			local bar2 = frame2.bars [self.index]
			local bar3 = frame3.bars [self.index]

			frame1.tooltip:SetPoint ("bottomleft", bar1[2], "topleft", -18, 5)
			frame2.tooltip:SetPoint ("bottomleft", bar2[2], "topleft", -18, 5)
			frame3.tooltip:SetPoint ("bottomleft", bar3[2], "topleft", -18, 5)

			local spellid = bar1[3][4]
			local player1 = frame1.player
			local player2 = frame2.player
			local player3 = frame3.player
			
			local hits = bar1[3][1]
			local average = bar1[3][2]
			local critical = bar1[3][3]
			
			local player1_misc = info.instancia.showing (4, player1)
			local player2_misc = info.instancia.showing (4, player2)
			local player3_misc = info.instancia.showing (4, player3)
			
			local player1_uptime
			local player1_casts
			
			local COMPARE_FIRSTPLAYER_PERCENT = "100%"
			local COMPARE_UNKNOWNDATA = "-"
			
			if (bar1[2].righttext:GetText()) then
				bar1[2]:SetStatusBarColor (1, 1, 1, 1)
				bar1[2].icon:SetTexCoord (.1, .9, .1, .9)
				
				frame1.tooltip.hits_label3:SetText (hits)
				frame1.tooltip.average_label3:SetText (_detalhes:ToK2Min (average))
				frame1.tooltip.crit_label3:SetText (critical .. "%")
				
				--2 = far left text (percent comparison)
				--3 = total in numbers
				
				_detalhes.gump:SetFontColor (frame1.tooltip.hits_label2, "gray")
				_detalhes.gump:SetFontColor (frame1.tooltip.average_label2, "gray")
				_detalhes.gump:SetFontColor (frame1.tooltip.crit_label2, "gray")
				_detalhes.gump:SetFontColor (frame1.tooltip.casts_label2, "gray")
				_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label2, "gray")
				
				frame1.tooltip.hits_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
				frame1.tooltip.average_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
				frame1.tooltip.crit_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
				
				if (player1_misc) then
				
					--uptime
					local spell = player1_misc.debuff_uptime_spells and player1_misc.debuff_uptime_spells._ActorTable and player1_misc.debuff_uptime_spells._ActorTable [spellid]
					if (spell) then
						local minutos, segundos = _math_floor (spell.uptime/60), _math_floor (spell.uptime%60)
						player1_uptime = spell.uptime
						frame1.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
						frame1.tooltip.uptime_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
						_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label2, "gray")
						_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label3, "white")
					else
						frame1.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
						frame1.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
						_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label2, "gray")
						_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label3, "gray")
					end
					
					--total casts
					local amt_casts = player1_misc.spell_cast and player1_misc.spell_cast [spellid]
					if (amt_casts) then
						frame1.tooltip.casts_label3:SetText (amt_casts)
						frame1.tooltip.casts_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
						
						_detalhes.gump:SetFontColor (frame1.tooltip.casts_label3, "white")
						
						player1_casts = amt_casts
					else
						local spellname = GetSpellInfo (spellid)
						local extra_search_found
						for casted_spellid, amount in _pairs (player1_misc.spell_cast or {}) do
							local casted_spellname = GetSpellInfo (casted_spellid)
							if (casted_spellname == spellname) then
								frame1.tooltip.casts_label3:SetText (amount)
								frame1.tooltip.casts_label2:SetText (COMPARE_FIRSTPLAYER_PERCENT)
								
								_detalhes.gump:SetFontColor (frame1.tooltip.casts_label3, "white")
								
								player1_casts = amount
								extra_search_found = true
								break
							end
						end
						
						if (not extra_search_found) then
							frame1.tooltip.casts_label3:SetText ("?")
							frame1.tooltip.casts_label2:SetText ("?")
							
							_detalhes.gump:SetFontColor (frame1.tooltip.casts_label3, "silver")
							_detalhes.gump:SetFontColor (frame1.tooltip.casts_label2, "silver")
						end
					end
				else
					frame1.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
					frame1.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
					_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label2, "gray")
					_detalhes.gump:SetFontColor (frame1.tooltip.uptime_label3, "gray")
					
					frame1.tooltip.casts_label3:SetText ("?")
					frame1.tooltip.casts_label2:SetText ("?")
					_detalhes.gump:SetFontColor (frame1.tooltip.casts_label3, "gray")
					_detalhes.gump:SetFontColor (frame1.tooltip.casts_label2, "gray")
				end
				
				frame1.tooltip:Show()
			end
			
			if (bar2[2].righttext:GetText()) then
			
				bar2 [2]:SetStatusBarColor (unpack (bar_color_on_enter))
				bar2[2].icon:SetTexCoord (.1, .9, .1, .9)
				
				-- hits
				if (hits > bar2[3][1]) then
					local diff = hits - bar2[3][1]
					local up = diff / bar2[3][1] * 100
					up = _math_floor (up)
					if (up > 999) then
						up = "" .. 999
					end
					frame2.tooltip.hits_label3:SetText (bar2[3][1])
					frame2.tooltip.hits_label2:SetText (" |c" .. minor .. up .. "%|r")
				else
					local diff = bar2[3][1] - hits
					local down = diff / hits * 100
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame2.tooltip.hits_label3:SetText (bar2[3][1])
					frame2.tooltip.hits_label2:SetText (" |c" .. plus .. down .. "%|r")
				end
				
				--average
				if (average > bar2[3][2]) then
					local diff = average - bar2[3][2]
					local up = diff / bar2[3][2] * 100
					up = _math_floor (up)
					if (up > 999) then
						up = "" .. 999
					end
					frame2.tooltip.average_label3:SetText (_detalhes:ToK2Min (bar2[3][2]))
					frame2.tooltip.average_label2:SetText (" |c" .. minor .. up .. "%|r")
				else
					local diff = bar2[3][2] - average
					local down = diff / average * 100
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame2.tooltip.average_label3:SetText (_detalhes:ToK2Min (bar2[3][2]))
					frame2.tooltip.average_label2:SetText (" |c" .. plus .. down .. "%|r")
				end
				
				--criticals
				if (critical > bar2[3][3]) then
					--[[
					local percent = abs ((bar2[3][3] / critical * 100) -100)
					percent = _math_floor (percent)
					if (percent > 999) then
						up = "" .. 999
					end
					frame2.tooltip.crit_label3:SetText (bar2[3][3] .. "%")
					frame2.tooltip.crit_label2:SetText (" |c" .. minor .. percent .. "%|r")
					--]]
					local diff = critical - bar2[3][3]
					diff = diff / bar2[3][3] * 100
					diff = _math_floor (diff)
					if (diff > 999) then
						diff = "" .. 999
					end
					frame2.tooltip.crit_label3:SetText (bar2[3][3] .. "%")
					frame2.tooltip.crit_label2:SetText (" |c" .. minor .. diff .. "%|r")
				else
					local diff = bar2[3][3] - critical
					local down = diff / math.max (critical, 0.1) * 100
					--bar2[3][3] = 62 critical = 53 diff = 9
					--print (diff, bar2[3][3], critical)
					--print (math.max (critical * 100, 0.1))
					
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame2.tooltip.crit_label3:SetText (bar2[3][3] .. "%")
					frame2.tooltip.crit_label2:SetText (" |c" .. plus .. down .. "%|r")
				end
				
				--update and total casts
				if (player2_misc) then
				
					--uptime
					local spell = player2_misc.debuff_uptime_spells and player2_misc.debuff_uptime_spells._ActorTable and player2_misc.debuff_uptime_spells._ActorTable [spellid]
					if (spell and spell.uptime) then
						local minutos, segundos = _math_floor (spell.uptime/60), _math_floor (spell.uptime%60)
						
						if (not player1_uptime) then
							frame2.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame2.tooltip.uptime_label2:SetText ("0%|r")
						
						elseif (player1_uptime > spell.uptime) then
							local diff = player1_uptime - spell.uptime
							local up = diff / spell.uptime * 100
							up = _math_floor (up)
							if (up > 999) then
								up = "" .. 999
							end
							frame2.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame2.tooltip.uptime_label2:SetText ("|c" .. minor .. up .. "%|r")
						else
							local diff = spell.uptime - player1_uptime
							local down = diff / player1_uptime * 100
							down = _math_floor (down)
							if (down > 999) then
								down = "" .. 999
							end
							frame2.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame2.tooltip.uptime_label2:SetText ("|c" .. plus .. down .. "%|r")
						end
						
						_detalhes.gump:SetFontColor (frame2.tooltip.uptime_label3, "white")
						_detalhes.gump:SetFontColor (frame2.tooltip.uptime_label2, "white")
						
					else
						frame2.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
						frame2.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
						_detalhes.gump:SetFontColor (frame2.tooltip.uptime_label3, "gray")
						_detalhes.gump:SetFontColor (frame2.tooltip.uptime_label2, "gray")
					end
					
					--total casts
					local amt_casts = player2_misc.spell_cast and player2_misc.spell_cast [spellid]
					if (not amt_casts) then
						local spellname = GetSpellInfo (spellid)
						for casted_spellid, amount in _pairs (player2_misc.spell_cast or {}) do
							local casted_spellname = GetSpellInfo (casted_spellid)
							if (casted_spellname == spellname) then
								amt_casts = amount
								break
							end
						end
					end
					if (amt_casts) then
						
						if (not player1_casts) then
							frame2.tooltip.casts_label3:SetText (amt_casts)
							frame2.tooltip.casts_label2:SetText (COMPARE_UNKNOWNDATA)
							
						elseif (player1_casts > amt_casts) then
							local diff = player1_casts - amt_casts
							local up = diff / amt_casts * 100
							up = _math_floor (up)
							if (up > 999) then
								up = "" .. 999
							end
							frame2.tooltip.casts_label3:SetText (amt_casts)
							frame2.tooltip.casts_label2:SetText ("|c" .. minor .. up .. "%|r")
						else
							local diff = amt_casts - player1_casts
							local down = diff / player1_casts * 100
							down = _math_floor (down)
							if (down > 999) then
								down = "" .. 999
							end
							frame2.tooltip.casts_label3:SetText (amt_casts)
							frame2.tooltip.casts_label2:SetText ("|c" .. plus .. down .. "%|r")
						end
						
						_detalhes.gump:SetFontColor (frame2.tooltip.casts_label3, "white")
						_detalhes.gump:SetFontColor (frame2.tooltip.casts_label2, "white")
					else
						frame2.tooltip.casts_label2:SetText ("?")
						frame2.tooltip.casts_label3:SetText ("?")
						_detalhes.gump:SetFontColor (frame2.tooltip.casts_label3, "gray")
						_detalhes.gump:SetFontColor (frame2.tooltip.casts_label2, "gray")
					end
				else
					frame2.tooltip.casts_label2:SetText (COMPARE_UNKNOWNDATA)
					frame2.tooltip.casts_label2:SetText (COMPARE_UNKNOWNDATA)
					frame2.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
					frame2.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
				end

				frame2.tooltip:Show()
			end
			
			---------------------------------------------------
			
			if (bar3[2].righttext:GetText()) then
				bar3 [2]:SetStatusBarColor (unpack (bar_color_on_enter))
				bar3[2].icon:SetTexCoord (.1, .9, .1, .9)
				
				--hits
				if (hits > bar3[3][1]) then
					local diff = hits - bar3[3][1]
					local up = diff / bar3[3][1] * 100
					up = _math_floor (up)
					if (up > 999) then
						up = "" .. 999
					end
					frame3.tooltip.hits_label3:SetText (bar3[3][1])
					frame3.tooltip.hits_label2:SetText (" |c" .. minor .. up .. "%|r")
				else
					local diff = bar3[3][1] - hits
					local down = diff / hits * 100
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame3.tooltip.hits_label3:SetText (bar3[3][1])
					frame3.tooltip.hits_label2:SetText (" |c" .. plus .. down .. "%|r")
				end

				--average
				if (average > bar3[3][2]) then
					local diff = average - bar3[3][2]
					local up = diff / bar3[3][2] * 100
					up = _math_floor (up)
					if (up > 999) then
						up = "" .. 999
					end
					frame3.tooltip.average_label3:SetText (_detalhes:ToK2Min (bar3[3][2]))
					frame3.tooltip.average_label2:SetText (" |c" .. minor .. up .. "%|r")
				else
					local diff = bar3[3][2] - average
					local down = diff / average * 100
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame3.tooltip.average_label3:SetText (_detalhes:ToK2Min (bar3[3][2]))
					frame3.tooltip.average_label2:SetText (" |c" .. plus .. down .. "%|r")
				end
				
				--critical
				if (critical > bar3[3][3]) then
					--[[
					local percent = abs ((bar3[3][3] / critical * 100) -100)
					--local diff = critical - bar3[3][3]
					--local up = diff / bar3[3][3] * 100
					percent = _math_floor (percent)
					if (percent > 999) then
						percent = "" .. 999
					end
					frame3.tooltip.crit_label3:SetText (bar3[3][3] .. "%")
					frame3.tooltip.crit_label2:SetText (" |c" .. minor .. percent .. "%|r")
					--]]
					local diff = critical - bar3[3][3]
					diff = diff / bar3[3][3] * 100
					diff = _math_floor (diff)
					if (diff > 999) then
						diff = "" .. 999
					end
					frame3.tooltip.crit_label3:SetText (bar3[3][3] .. "%")
					frame3.tooltip.crit_label2:SetText (" |c" .. minor .. diff .. "%|r")
				else
					local diff = bar3[3][3] - critical
					local down = diff / math.max (critical, 0.1) * 100
					down = _math_floor (down)
					if (down > 999) then
						down = "" .. 999
					end
					frame3.tooltip.crit_label3:SetText (bar3[3][3] .. "%")
					frame3.tooltip.crit_label2:SetText (" |c" .. plus .. down .. "%|r")
				end

				--uptime and casts
				if (player3_misc) then
				
					--uptime
					local spell = player3_misc.debuff_uptime_spells and player3_misc.debuff_uptime_spells._ActorTable and player3_misc.debuff_uptime_spells._ActorTable [spellid]
					if (spell and spell.uptime) then
						local minutos, segundos = _math_floor (spell.uptime/60), _math_floor (spell.uptime%60)
						
						if (not player1_uptime) then
							frame3.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame3.tooltip.uptime_label2:SetText ("0%|r")
							
						elseif (player1_uptime > spell.uptime) then
							local diff = player1_uptime - spell.uptime
							local up = diff / spell.uptime * 100
							up = _math_floor (up)
							if (up > 999) then
								up = "" .. 999
							end
							frame3.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame3.tooltip.uptime_label2:SetText ("|c" .. minor .. up .. "%|r")
						else
							local diff = spell.uptime - player1_uptime
							local down = diff / player1_uptime * 100
							down = _math_floor (down)
							if (down > 999) then
								down = "" .. 999
							end
							frame3.tooltip.uptime_label3:SetText (minutos .. "m" .. segundos .. "s")
							frame3.tooltip.uptime_label2:SetText ("|c" .. plus .. down .. "%|r")
						end
						
						_detalhes.gump:SetFontColor (frame3.tooltip.uptime_label3, "white")
						_detalhes.gump:SetFontColor (frame3.tooltip.uptime_label2, "white")
					else
						frame3.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
						frame3.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
						_detalhes.gump:SetFontColor (frame3.tooltip.uptime_label3, "gray")
						_detalhes.gump:SetFontColor (frame3.tooltip.uptime_label2, "gray")
					end
					
					--total casts
					local amt_casts = player3_misc.spell_cast and player3_misc.spell_cast [spellid]
					if (not amt_casts) then
						local spellname = GetSpellInfo (spellid)
						for casted_spellid, amount in _pairs (player3_misc.spell_cast or {}) do
							local casted_spellname = GetSpellInfo (casted_spellid)
							if (casted_spellname == spellname) then
								amt_casts = amount
								break
							end
						end
					end
					
					if (amt_casts) then
						
						if (not player1_casts) then
							frame3.tooltip.casts_label2:SetText (amt_casts)
						elseif (player1_casts > amt_casts) then
							local diff = player1_casts - amt_casts
							local up = diff / amt_casts * 100
							up = _math_floor (up)
							if (up > 999) then
								up = "" .. 999
							end
							frame3.tooltip.casts_label3:SetText (amt_casts)
							frame3.tooltip.casts_label2:SetText (" |c" .. minor .. up .. "%|r")
						else
							local diff = amt_casts - player1_casts
							local down = diff / player1_casts * 100
							down = _math_floor (down)
							if (down > 999) then
								down = "" .. 999
							end
							frame3.tooltip.casts_label3:SetText (amt_casts)
							frame3.tooltip.casts_label2:SetText (" |c" .. plus .. down .. "%|r")
						end
						
						_detalhes.gump:SetFontColor (frame3.tooltip.casts_label3, "white")
						_detalhes.gump:SetFontColor (frame3.tooltip.casts_label2, "white")
					else
						frame3.tooltip.casts_label2:SetText ("?")
						frame3.tooltip.casts_label3:SetText ("?")
						_detalhes.gump:SetFontColor (frame3.tooltip.casts_label3, "gray")
						_detalhes.gump:SetFontColor (frame3.tooltip.casts_label2, "gray")
					end					
					
				else
					frame3.tooltip.casts_label3:SetText (COMPARE_UNKNOWNDATA)
					frame3.tooltip.casts_label2:SetText (COMPARE_UNKNOWNDATA)
					frame3.tooltip.uptime_label3:SetText (COMPARE_UNKNOWNDATA)
					frame3.tooltip.uptime_label2:SetText (COMPARE_UNKNOWNDATA)
				end
				
				frame3.tooltip:Show()
			end
		end
		
		local on_leave = function (self)
			local frame1 = DetailsPlayerComparisonBox1
			local frame2 = DetailsPlayerComparisonBox2
			local frame3 = DetailsPlayerComparisonBox3
		
			local bar1 = frame1.bars [self.index]
			local bar2 = frame2.bars [self.index]
			local bar3 = frame3.bars [self.index]
		
			bar1[2]:SetStatusBarColor (.5, .5, .5, 1)
			bar1[2].icon:SetTexCoord (0, 1, 0, 1)
			bar2[2]:SetStatusBarColor (unpack (bar_color))
			bar2[2].icon:SetTexCoord (0, 1, 0, 1)
			bar3[2]:SetStatusBarColor (unpack (bar_color))
			bar3[2].icon:SetTexCoord (0, 1, 0, 1)
			
			frame1.tooltip:Hide()
			frame2.tooltip:Hide()
			frame3.tooltip:Hide()
		end
	
		local compare_create = function (tab, frame)
		
			local create_bar = function (name, parent, index, main, is_target)
				local y = ((index-1) * -15) - 7
		
				local spellicon = parent:CreateTexture (nil, "overlay")
				spellicon:SetSize (14, 14)
				spellicon:SetPoint ("topleft", parent, "topleft", 4, y)
				spellicon:SetTexture ([[Interface\InventoryItems\WoWUnknownItem01]])
		
				local bar = CreateFrame ("StatusBar", name, parent,"BackdropTemplate")
				bar.index = index
				bar:SetPoint ("topleft", spellicon, "topright", 0, 0)
				bar:SetPoint ("topright", parent, "topright", -4, y)
				bar:SetStatusBarTexture ([[Interface\AddOns\Details\images\bar_serenity]])
				bar:SetStatusBarColor (.5, .5, .5, 1)
				bar:SetAlpha (ALPHA_BLEND_AMOUNT)
				
				bar:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true})
				bar:SetBackdropColor (1, 1, 1, 0.1)
				
				bar:SetMinMaxValues (0, 100)
				bar:SetValue (100)
				bar:SetHeight (14)
				bar.icon = spellicon
		
				if (is_target) then
					bar:SetScript ("OnEnter", on_enter_target)
					bar:SetScript ("OnLeave", on_leave_target)
				else
					bar:SetScript ("OnEnter", on_enter)
					bar:SetScript ("OnLeave", on_leave)
				end
		
				bar.lefttext = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
		
				local _, size, flags = bar.lefttext:GetFont()
				local font = SharedMedia:Fetch ("font", "Arial Narrow")
				bar.lefttext:SetFont (font, 11)
				
				bar.lefttext:SetPoint ("left", bar, "left", 4, 0)
				bar.lefttext:SetJustifyH ("left")
				bar.lefttext:SetTextColor (1, 1, 1, 1)
				bar.lefttext:SetNonSpaceWrap (true)
				bar.lefttext:SetWordWrap (false)
				if (main) then
					bar.lefttext:SetWidth (180)
				else
					bar.lefttext:SetWidth (110)
				end
				
				bar.righttext = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
				
				local _, size, flags = bar.righttext:GetFont()
				local font = SharedMedia:Fetch ("font", "Arial Narrow")
				bar.righttext:SetFont (font, 11)
				
				bar.righttext:SetPoint ("right", bar, "right", -2, 0)
				bar.righttext:SetJustifyH ("right")
				bar.righttext:SetTextColor (1, 1, 1, 1)
				
				bar.righttext2 = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
				
				local _, size, flags = bar.righttext2:GetFont()
				local font = SharedMedia:Fetch ("font", "Arial Narrow")
				bar.righttext2:SetFont (font, 11)
				
				bar.righttext2:SetPoint ("right", bar, "right", -42, 0)
				bar.righttext2:SetJustifyH ("right")
				bar.righttext2:SetTextColor (1, 1, 1, 1)
				
				tinsert (parent.bars, {spellicon, bar, {0, 0, 0}})
			end
			
			local create_tooltip = function (name)
				local tooltip = CreateFrame ("frame", name, UIParent,"BackdropTemplate")
				
				_detalhes.gump:CreateBorder (tooltip)
				
				tooltip:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
				tooltip:SetBackdropColor (0, 0, 0, 1)
				tooltip:SetBackdropBorderColor (0, 0, 0, 1)
				tooltip:SetSize (275, 77)
				tooltip:SetFrameStrata ("tooltip")
				
				local y = -3
				local x_start = 2
				
				local background = tooltip:CreateTexture (nil, "border")
				background:SetTexture ([[Interface\SPELLBOOK\Spellbook-Page-1]])
				background:SetTexCoord (.6, 0.1, 0, 0.64453125)
				background:SetVertexColor (0, 0, 0, 0.2)
				background:SetPoint ("topleft", tooltip, "topleft", 0, 0)
				background:SetPoint ("bottomright", tooltip, "bottomright", 0, 0)
				
				tooltip.casts_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.casts_label:SetPoint ("topleft", tooltip, "topleft", x_start, -2 + (y*0))
				tooltip.casts_label:SetText ("Total Casts:")
				tooltip.casts_label:SetJustifyH ("left")
				tooltip.casts_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.casts_label2:SetPoint ("topright", tooltip, "topright", -x_start, -2 + (y*0))
				tooltip.casts_label2:SetText ("0")
				tooltip.casts_label2:SetJustifyH ("right")
				tooltip.casts_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.casts_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -2 + (y*0))
				tooltip.casts_label3:SetText ("0")
				tooltip.casts_label3:SetJustifyH ("right")
				
				tooltip.hits_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.hits_label:SetPoint ("topleft", tooltip, "topleft", x_start, -14 + (y*1))
				tooltip.hits_label:SetText ("Total Hits:")
				tooltip.hits_label:SetJustifyH ("left")
				tooltip.hits_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.hits_label2:SetPoint ("topright", tooltip, "topright", -x_start, -14 + (y*1))
				tooltip.hits_label2:SetText ("0")
				tooltip.hits_label2:SetJustifyH ("right")
				tooltip.hits_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.hits_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -14 + (y*1))
				tooltip.hits_label3:SetText ("0")
				tooltip.hits_label3:SetJustifyH ("right")
				
				tooltip.average_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.average_label:SetPoint ("topleft", tooltip, "topleft", x_start, -26 + (y*2))
				tooltip.average_label:SetText ("Average:")
				tooltip.average_label:SetJustifyH ("left")
				tooltip.average_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.average_label2:SetPoint ("topright", tooltip, "topright", -x_start, -26 + (y*2))
				tooltip.average_label2:SetText ("0")
				tooltip.average_label2:SetJustifyH ("right")
				tooltip.average_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.average_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -26 + (y*2))
				tooltip.average_label3:SetText ("0")
				tooltip.average_label3:SetJustifyH ("right")
				
				tooltip.crit_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.crit_label:SetPoint ("topleft", tooltip, "topleft", x_start, -38 + (y*3))
				tooltip.crit_label:SetText ("Critical:")
				tooltip.crit_label:SetJustifyH ("left")
				tooltip.crit_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.crit_label2:SetPoint ("topright", tooltip, "topright", -x_start, -38 + (y*3))
				tooltip.crit_label2:SetText ("0")
				tooltip.crit_label2:SetJustifyH ("right")
				tooltip.crit_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.crit_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -38 + (y*3))
				tooltip.crit_label3:SetText ("0")
				tooltip.crit_label3:SetJustifyH ("right")
				
				tooltip.uptime_label = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.uptime_label:SetPoint ("topleft", tooltip, "topleft", x_start, -50 + (y*4))
				tooltip.uptime_label:SetText ("Uptime:")
				tooltip.uptime_label:SetJustifyH ("left")
				tooltip.uptime_label2 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.uptime_label2:SetPoint ("topright", tooltip, "topright", -x_start, -50 + (y*4))
				tooltip.uptime_label2:SetText ("0")
				tooltip.uptime_label2:SetJustifyH ("right")
				tooltip.uptime_label3 = tooltip:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
				tooltip.uptime_label3:SetPoint ("topright", tooltip, "topright", -x_start - 46, -50 + (y*4))
				tooltip.uptime_label3:SetText ("0")
				tooltip.uptime_label3:SetJustifyH ("right")
				
				local bg_color = {0.5, 0.5, 0.5}
				local bg_texture = [[Interface\AddOns\Details\images\bar_background]]
				local bg_alpha = 1
				local bg_height = 12
				local colors = {{26/255, 26/255, 26/255}, {19/255, 19/255, 19/255}, {26/255, 26/255, 26/255}, {34/255, 39/255, 42/255}, {42/255, 51/255, 60/255}}
				
				for i = 1, 5 do
					local bg_line1 = tooltip:CreateTexture (nil, "artwork")
					bg_line1:SetTexture (bg_texture)
					bg_line1:SetPoint ("topleft", tooltip, "topleft", 0, -2 + (((i-1) * 12) * -1) + (y * (i-1)) + 2)
					bg_line1:SetPoint ("topright", tooltip, "topright", -0, -2 + (((i-1) * 12) * -1)  + (y * (i-1)) + 2)
					bg_line1:SetHeight (bg_height + 4)
					bg_line1:SetAlpha (bg_alpha)
					bg_line1:SetVertexColor (unpack (colors[i]))
				end
				
				return tooltip
			end

			local create_tooltip_target = function (name)
				local tooltip = CreateFrame ("frame", name, UIParent,"BackdropTemplate")
				tooltip:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
				tooltip:SetBackdropColor (0, 0, 0, 1)
				tooltip:SetBackdropBorderColor (0, 0, 0, 1)
				tooltip:SetSize (175, 67)
				tooltip:SetFrameStrata ("tooltip")
				tooltip.bars = {}
				
				_detalhes.gump:CreateBorder (tooltip)
				
				function tooltip:Reset()
					for index, bar in _ipairs (tooltip.bars) do 
						bar [1]:SetTexture (nil)
						bar [2].lefttext:SetText ("")
						bar [2].righttext:SetText ("")
						bar [2].righttext2:SetText ("")
						bar [2]:SetValue (0)
						bar [2].bg:Hide()
					end
				end
				
				local bars_colors = {{19/255, 19/255, 19/255}, {26/255, 26/255, 26/255}}
				
				function tooltip:CreateBar (index)
				
					if (index) then
						if (index > #tooltip.bars+1) then
							for i = #tooltip.bars+1, index-1 do
								tooltip:CreateBar()
							end
						end
					end
				
					local index = #tooltip.bars + 1
					local y = ((index-1) * -15) - 2
					local parent = tooltip
				
					local spellicon = parent:CreateTexture (nil, "overlay")
					spellicon:SetSize (14, 14)
					spellicon:SetPoint ("topleft", parent, "topleft", 1, y)
					spellicon:SetTexture ([[Interface\InventoryItems\WoWUnknownItem01]])
				
					local bar = CreateFrame ("StatusBar", name .. "Bar" .. index, parent, "BackdropTemplate")
					bar.index = index
					bar:SetPoint ("topleft", spellicon, "topright", 0, 0)
					bar:SetPoint ("topright", parent, "topright", -1, y)
					bar:SetStatusBarTexture ([[Interface\AddOns\Details\images\bar_serenity]])
					bar:SetStatusBarColor (unpack (bar_color))
					bar:SetMinMaxValues (0, 100)
					bar:SetValue (0)
					bar:SetHeight (14)
					bar.icon = spellicon
		
					bar.lefttext = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
					local _, size, flags = bar.lefttext:GetFont()
					local font = SharedMedia:Fetch ("font", "Arial Narrow")
					bar.lefttext:SetFont (font, 11)					
					bar.lefttext:SetPoint ("left", bar, "left", 2, 0)
					bar.lefttext:SetJustifyH ("left")
					bar.lefttext:SetTextColor (1, 1, 1, 1)
					bar.lefttext:SetNonSpaceWrap (true)
					bar.lefttext:SetWordWrap (false)
					
					if (name:find ("1")) then
						bar.lefttext:SetWidth (110)
					else
						bar.lefttext:SetWidth (80)
					end
					
					bar.righttext = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")	
					local _, size, flags = bar.righttext:GetFont()
					local font = SharedMedia:Fetch ("font", "Arial Narrow")
					bar.righttext:SetFont (font, 11)					
					bar.righttext:SetPoint ("right", bar, "right", -2, 0)
					bar.righttext:SetJustifyH ("right")
					bar.righttext:SetTextColor (1, 1, 1, 1)
					
					bar.righttext2 = bar:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")	
					local _, size, flags = bar.righttext2:GetFont()
					local font = SharedMedia:Fetch ("font", "Arial Narrow")
					bar.righttext2:SetFont (font, 11)					
					bar.righttext2:SetPoint ("right", bar, "right", -46, 0)
					bar.righttext2:SetJustifyH ("right")
					bar.righttext2:SetTextColor (1, 1, 1, 1)
					
					local bg_line1 = bar:CreateTexture (nil, "artwork")
					bg_line1:SetTexture ([[Interface\AddOns\Details\images\bar_background]])
					bg_line1:SetAllPoints()
					bg_line1:SetAlpha (0.7)
					if (index % 2 == 0) then
						bg_line1:SetVertexColor (_unpack (bars_colors [2]))
					else
						bg_line1:SetVertexColor (_unpack (bars_colors [2]))
					end
					bar.bg = bg_line1
					
					local object = {spellicon, bar}
					tinsert (tooltip.bars, object)
					return object
				end
				
				local background = tooltip:CreateTexture (nil, "artwork")
				background:SetTexture ([[Interface\SPELLBOOK\Spellbook-Page-1]])
				background:SetTexCoord (.6, 0.1, 0, 0.64453125)
				background:SetVertexColor (0, 0, 0, 0.6)
				background:SetPoint ("topleft", tooltip, "topleft", 2, -4)
				background:SetPoint ("bottomright", tooltip, "bottomright", -4, 2)
				
				return tooltip
			end
			
			local frame1 = CreateFrame ("scrollframe", "DetailsPlayerComparisonBox1", frame, "FauxScrollFrameTemplate,BackdropTemplate")
			frame1:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 14, refresh_comparison_box) end)			
			frame1:SetSize (spell_compare_frame_width[1], spell_compare_frame_height)
			frame1:SetPoint ("topleft", frame, "topleft", xLocation, yLocation)
			_detalhes.gump:ReskinSlider (frame1)
			
			frame1:SetBackdrop (frame_backdrop)
			frame1:SetBackdropColor (unpack (frame_backdrop_color))
			frame1:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (frame1)
			
			frame1.bars = {}
			frame1.tab = tab
			frame1.tooltip = create_tooltip ("DetailsPlayerComparisonBox1Tooltip")
			frame1.tooltip:SetWidth (spell_compare_frame_width[1])
			
			local playername1 = frame1:CreateFontString (nil, "overlay", "GameFontNormal")
			playername1:SetPoint ("bottomleft", frame1, "topleft", 2, 0)
			playername1:SetText ("Player 1")
			frame1.name_label = playername1
			
			--criar as barras do frame1
			for i = 1, 12 do
				create_bar ("DetailsPlayerComparisonBox1Bar"..i, frame1, i, true)
			end
			
			--cria o box dos targets
			local target1 = CreateFrame ("scrollframe", "DetailsPlayerComparisonTarget1", frame, "FauxScrollFrameTemplate,BackdropTemplate")
			target1:SetScript ("OnVerticalScroll", function (self, offset) FauxScrollFrame_OnVerticalScroll (self, offset, 14, refresh_target_box) end)			
			target1:SetSize (spell_compare_frame_width[1], target_compare_frame_height)
			target1:SetPoint ("topleft", frame1, "bottomleft", 0, -10)
			_detalhes.gump:ReskinSlider (target1)
			
			target1:SetBackdrop (frame_backdrop)
			target1:SetBackdropColor (unpack (frame_backdrop_color))
			target1:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			target1.bars = {}
			target1.tab = tab
			target1.tooltip = create_tooltip_target ("DetailsPlayerComparisonTarget1Tooltip")
			target1.tooltip:SetWidth (spell_compare_frame_width[1])
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (target1)
			
			--criar as barras do target1
			for i = 1, targetBars do
				create_bar ("DetailsPlayerComparisonTarget1Bar"..i, target1, i, true, true)
			end
			
--------------------------------------------

			local frame2 = CreateFrame ("frame", "DetailsPlayerComparisonBox2", frame,"BackdropTemplate")
			local frame3 = CreateFrame ("frame", "DetailsPlayerComparisonBox3", frame,"BackdropTemplate")
			
			frame2:SetPoint ("topleft", frame1, "topright", 27, 0)
			frame2:SetSize (spell_compare_frame_width[2], spell_compare_frame_height)
			
			frame2:SetBackdrop (frame_backdrop)
			frame2:SetBackdropColor (unpack (frame_backdrop_color))
			frame2:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (frame2)
			
			frame2.bars = {}
			frame2.tooltip = create_tooltip ("DetailsPlayerComparisonBox2Tooltip")
			frame2.tooltip:SetWidth (spell_compare_frame_width[2])
			
			local playername2 = frame2:CreateFontString (nil, "overlay", "GameFontNormal")
			playername2:SetPoint ("bottomleft", frame2, "topleft", 2, 0)
			playername2:SetText ("Player 2")
			frame2.name_label = playername2
			
			local playername2_percent = frame2:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			playername2_percent:SetPoint ("bottomright", frame2, "topright", -2, 0)
			playername2_percent:SetText ("Player 1 %")
			playername2_percent:SetTextColor (.6, .6, .6)
			
			local noPLayersToShow = frame2:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			noPLayersToShow:SetPoint ("center")
			noPLayersToShow:SetText ("There's no more players to compare (with the same class/spec)")
			noPLayersToShow:SetSize (spell_compare_frame_width[2] - 10, spell_compare_frame_height)
			noPLayersToShow:SetJustifyH ("center")
			noPLayersToShow:SetJustifyV ("center")
			_detalhes.gump:SetFontSize (noPLayersToShow, 14)
			_detalhes.gump:SetFontColor (noPLayersToShow, "gray")
			frame2.NoPLayersToShow = noPLayersToShow
			
			
			frame2.name_label_percent = playername2_percent
			
			--criar as barras do frame2
			for i = 1, 12 do
				create_bar ("DetailsPlayerComparisonBox2Bar"..i, frame2, i)
			end
			
			--cria o box dos targets
			local target2 = CreateFrame ("frame", "DetailsPlayerComparisonTarget2", frame,"BackdropTemplate")
			target2:SetSize (spell_compare_frame_width[2], target_compare_frame_height)
			target2:SetPoint ("topleft", frame2, "bottomleft", 0, -10)
			target2:SetBackdrop (frame_backdrop)
			target2:SetBackdropColor (unpack (frame_backdrop_color))
			target2:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			target2.bars = {}
			target2.tooltip = create_tooltip_target ("DetailsPlayerComparisonTarget2Tooltip")
			target2.tooltip:SetWidth (spell_compare_frame_width[2])
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (target2)
			
			--criar as barras do target2
			for i = 1, targetBars do
				create_bar ("DetailsPlayerComparisonTarget2Bar"..i, target2, i, nil, true)
			end
			
-----------------------------------------------------------------------
			
			frame3:SetPoint ("topleft", frame2, "topright", 5, 0)
			frame3:SetSize (spell_compare_frame_width[3], spell_compare_frame_height)
			frame3:SetBackdrop (frame_backdrop)
			frame3:SetBackdropColor (unpack (frame_backdrop_color))
			frame3:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (frame3)
			
			frame3.bars = {}
			frame3.tooltip = create_tooltip ("DetailsPlayerComparisonBox3Tooltip")
			frame3.tooltip:SetWidth (spell_compare_frame_width[3])
			
			local playername3 = frame3:CreateFontString (nil, "overlay", "GameFontNormal")
			playername3:SetPoint ("bottomleft", frame3, "topleft", 2, 0)
			playername3:SetText ("Player 3")
			frame3.name_label = playername3
			
			local playername3_percent = frame3:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			playername3_percent:SetPoint ("bottomright", frame3, "topright", -2, 0)
			playername3_percent:SetText ("Player 1 %")
			playername3_percent:SetTextColor (.6, .6, .6)
			frame3.name_label_percent = playername3_percent
			

			local noPLayersToShow = frame3:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
			noPLayersToShow:SetPoint ("center")
			noPLayersToShow:SetText ("There's no more players to compare (with the same class/spec)")
			noPLayersToShow:SetSize (spell_compare_frame_width[2] - 10, spell_compare_frame_height)
			noPLayersToShow:SetJustifyH ("center")
			noPLayersToShow:SetJustifyV ("center")
			_detalhes.gump:SetFontSize (noPLayersToShow, 14)
			_detalhes.gump:SetFontColor (noPLayersToShow, "gray")
			frame3.NoPLayersToShow = noPLayersToShow
			
			--criar as barras do frame3
			for i = 1, 12 do
				create_bar ("DetailsPlayerComparisonBox3Bar"..i, frame3, i)
			end
			
			--cria o box dos targets
			local target3 = CreateFrame ("frame", "DetailsPlayerComparisonTarget3", frame,"BackdropTemplate")
			target3:SetSize (spell_compare_frame_width[3], target_compare_frame_height)
			target3:SetPoint ("topleft", frame3, "bottomleft", 0, -10)
			target3:SetBackdrop (frame_backdrop)
			target3:SetBackdropColor (unpack (frame_backdrop_color))
			target3:SetBackdropBorderColor (unpack (frame_backdrop_border_color))
			target3.bars = {}
			target3.tooltip = create_tooltip_target ("DetailsPlayerComparisonTarget3Tooltip")
			target3.tooltip:SetWidth (spell_compare_frame_width[3])
			
			--override backdrop settings and use the framework defaults
			Details.gump:ApplyStandardBackdrop (target3)
			
			--criar as barras do target1
			for i = 1, targetBars do
				create_bar ("DetailsPlayerComparisonTarget3Bar"..i, target3, i, nil, true)
			end
		end
		
		
		-- ~compare
		local iconTableCompare = {
			texture = [[Interface\AddOns\Details\images\icons]],
			--coords = {363/512, 381/512, 0/512, 17/512},
			coords = {383/512, 403/512, 0/512, 15/512},
			width = 16,
			height = 14,
		}
		
		_detalhes:CreatePlayerDetailsTab ("Compare", Loc ["STRING_INFO_TAB_COMPARISON"], --[1] tab name [2] localized name
			function (tabOBject, playerObject)  --[2] condition
				
				if (info.atributo > 2) then
					return false
				end
				
				local same_class = {}
				local class = playerObject.classe
				local my_spells = {}
				local my_spells_total = 0
				--> build my spell list
				for spellid, _ in _pairs (playerObject.spells._ActorTable) do
					my_spells [spellid] = true
					my_spells_total = my_spells_total + 1
				end
				
				tabOBject.players = {}
				tabOBject.player = playerObject
				tabOBject.spells_amt = my_spells_total
				
				for index, actor in _ipairs (info.instancia.showing [info.atributo]._ActorTable) do 
					if (actor.classe == class and actor ~= playerObject) then

						local same_spells = 0
						for spellid, _ in _pairs (actor.spells._ActorTable) do
							if (my_spells [spellid]) then
								same_spells = same_spells + 1
							end
						end
						
						local match_percentage = same_spells / max (my_spells_total, 0.000001) * 100

						if (match_percentage > 30) then
							tinsert (tabOBject.players, actor)
						end
					end
				end
				
				if (#tabOBject.players > 0) then
					--tutorial flash
					local blink = _detalhes:GetTutorialCVar ("DETAILS_INFO_TUTORIAL2") or 0
					if (type (blink) == "number" and blink < 10) then
					
						if (not tabOBject.FlashAnimation) then
							local flashAnimation = tabOBject:CreateTexture (nil, "overlay")
							flashAnimation:SetPoint ("topleft", tabOBject.widget, "topleft", 1, -1)
							flashAnimation:SetPoint ("bottomright", tabOBject.widget, "bottomright", -1, 1)
							flashAnimation:SetColorTexture (1, 1, 1)

							local flashHub = DetailsFramework:CreateAnimationHub (flashAnimation, function() flashAnimation:Show() end, function() flashAnimation:Hide() end)
							DetailsFramework:CreateAnimation (flashHub, "alpha", 1, 1, 0, 0.3)
							DetailsFramework:CreateAnimation (flashHub, "alpha", 2, 1, 0.45, 0)
							flashHub:SetLooping ("REPEAT")
							
							tabOBject.FlashAnimation = flashHub
						end
						
						_detalhes:SetTutorialCVar ("DETAILS_INFO_TUTORIAL2", blink+1)

						tabOBject.FlashAnimation:Play()
					end
					
					return true
				end
				
				--return false
				return true --debug?
			end, 
			
			compare_fill, --[3] fill function
			
			nil, --[4] onclick
			
			compare_create, --[5] oncreate
			iconTableCompare --icon table
		)
		
		-- ~compare ~newcompare
		-- ~compare
		


		
	
	-- ~tab ~tabs
		function este_gump:ShowTabs()
			local tabsShown = 0
			local secondRowIndex = 1
			local breakLine = 6 --th tab it'll start the second line

			for index = 1, #_detalhes.player_details_tabs do
				
				local tab = _detalhes.player_details_tabs [index]
				
				if (tab:condition (info.jogador, info.atributo, info.sub_atributo)) then
				
					--test if can show the tutorial for the comparison tab
					if (tab.tabname == "Compare") then
						--_detalhes:SetTutorialCVar ("DETAILS_INFO_TUTORIAL1", false)
						if (not _detalhes:GetTutorialCVar ("DETAILS_INFO_TUTORIAL1")) then
							_detalhes:SetTutorialCVar ("DETAILS_INFO_TUTORIAL1", true)
							
							local alert = CreateFrame ("frame", "DetailsInfoPopUp1", info, "DetailsHelpBoxTemplate")
							alert.ArrowUP:Show()
							alert.ArrowGlowUP:Show()
							alert.Text:SetText (Loc ["STRING_INFO_TUTORIAL_COMPARISON1"])
							alert:SetPoint ("bottom", tab.widget or tab, "top", 5, 28)
							alert:Show()
						end
					end
				
					tab:Show()
					tabsShown = tabsShown + 1
					
					tab:ClearAllPoints()
					
					--get the button width
					local buttonTemplate = gump:GetTemplate ("button", "DETAILS_TAB_BUTTON_TEMPLATE")
					local buttonWidth = buttonTemplate.width + 1
					
					--pixelutil might not be compatible with classic wow
					if (PixelUtil) then
						PixelUtil.SetSize (tab, buttonTemplate.width, buttonTemplate.height)
						if (tabsShown >= breakLine) then --next row of icons
							PixelUtil.SetPoint (tab, "bottomright", info, "topright",  -514 + (buttonWidth * (secondRowIndex)), -50)
							secondRowIndex = secondRowIndex + 1
						else
							PixelUtil.SetPoint (tab, "bottomright", info, "topright",  -514 + (buttonWidth * tabsShown), -72)
						end
					else
						tab:SetSize (buttonTemplate.width, buttonTemplate.height)
						if (tabsShown >= breakLine) then --next row of icons
							tab:SetPoint ("bottomright", info, "topright",  -514 + (buttonWidth * (secondRowIndex)), -50)
							secondRowIndex = secondRowIndex + 1
						else
							tab:SetPoint ("bottomright", info, "topright", -514 + (buttonWidth * tabsShown), -72)
						end
					end
					
					tab:SetAlpha (0.8)
				else
					tab.frame:Hide()
					tab:Hide()
				end
			end
			
			if (tabsShown < 2) then
				_detalhes.player_details_tabs[1]:SetPoint ("BOTTOMLEFT", info.container_barras, "TOPLEFT",  490 - (94 * (1-0)), 1)
			end
			
			--selected by default
			_detalhes.player_details_tabs[1]:Click()
		end

		este_gump:SetScript ("OnHide", function (self)
			_detalhes:FechaJanelaInfo()
			for _, tab in _ipairs (_detalhes.player_details_tabs) do
				tab:Hide()
				tab.frame:Hide()
			end
		end)
	
	--DetailsInfoWindowTab1Text:SetText ("Avoidance")
	este_gump.tipo = 1 --> tipo da janela // 1 = janela normal
	
	return este_gump
	
end

info.selectedTab = "Summary"

_detalhes.player_details_tabs = {}

function _detalhes:CreatePlayerDetailsTab (tabname, localized_name, condition, fillfunction, onclick, oncreate, iconSettings)
	if (not tabname) then
		tabname = "unnamed"
	end

	--create a button for the tab
	local newTabButton = gump:CreateButton (info, onclick, 20, 20)
	newTabButton:SetTemplate ("DETAILS_TAB_BUTTON_TEMPLATE")
	if (tabname == "Summary") then
		newTabButton:SetTemplate ("DETAILS_TAB_BUTTONSELECTED_TEMPLATE")
	end
	newTabButton:SetText (localized_name)
	newTabButton:SetFrameStrata ("HIGH")
	newTabButton:SetFrameLevel (info:GetFrameLevel()+1)
	newTabButton:Hide()
	
	newTabButton.condition = condition
	newTabButton.tabname = tabname
	newTabButton.localized_name = localized_name
	newTabButton.onclick = onclick
	newTabButton.fillfunction = fillfunction
	newTabButton.last_actor = {}
	
	newTabButton.frame = CreateFrame ("frame", "DetailsPDWTabFrame" .. tabname, UIParent,"BackdropTemplate")
	newTabButton.frame:SetParent (info)
	newTabButton.frame:SetFrameStrata ("HIGH")
	newTabButton.frame:SetFrameLevel (info:GetFrameLevel()+5)
	newTabButton.frame:EnableMouse (true)
	
	if (iconSettings) then
		local texture = iconSettings.texture
		local coords = iconSettings.coords
		local width = iconSettings.width
		local height = iconSettings.height
		
		local overlay, textdistance, leftpadding, textheight, short_method --nil
		
		newTabButton:SetIcon (texture, width, height, "overlay", coords, overlay, textdistance, leftpadding, textheight, short_method)
		if (iconSettings.desaturated) then
			newTabButton.icon:SetDesaturated (true)
		end
	end
	
	if (newTabButton.fillfunction) then
		newTabButton.frame:SetScript ("OnShow", function()
			if (newTabButton.last_actor == info.jogador) then
				return
			end
			newTabButton.last_actor = info.jogador
			newTabButton:fillfunction (info.jogador, info.instancia.showing)
		end)
	end
	
	if (oncreate) then
		oncreate (newTabButton, newTabButton.frame)
	end
	
	newTabButton.frame:SetBackdrop({
		edgeFile = [[Interface\Buttons\WHITE8X8]], 
		edgeSize = 1, 
		bgFile = [[Interface\AddOns\Details\images\background]],
		tileSize = 64, 
		tile = true,
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
	)
	
	newTabButton.frame:SetBackdropColor (0, 0, 0, 0.3)
	newTabButton.frame:SetBackdropBorderColor (.3, .3, .3, 0)
	
	newTabButton.frame:SetPoint ("TOPLEFT", info.container_barras, "TOPLEFT", 0, 2)
	newTabButton.frame:SetPoint ("bottomright", info, "bottomright", -3, 3)
	newTabButton.frame:SetSize (569, 274)
	
	newTabButton.frame:Hide()
	
	_detalhes.player_details_tabs [#_detalhes.player_details_tabs+1] = newTabButton
	
	if (not onclick) then
		--> hide all tabs
		newTabButton.OnShowFunc = function (self) 
			self = self.MyObject or self
			
			for _, tab in _ipairs (_detalhes.player_details_tabs) do
				tab.frame:Hide()
				tab:SetTemplate ("DETAILS_TAB_BUTTON_TEMPLATE")
			end
			
			self:SetTemplate ("DETAILS_TAB_BUTTONSELECTED_TEMPLATE")
			self.frame:Show()
			info.selectedTab = self.tabname
		end
		
		newTabButton:SetScript ("OnClick", newTabButton.OnShowFunc)
	else
		--> custom
		newTabButton.OnShowFunc = function (self) 
			self = self.MyObject or self
			
			for _, tab in _ipairs (_detalhes.player_details_tabs) do
				tab.frame:Hide()
				tab:SetTemplate ("DETAILS_TAB_BUTTON_TEMPLATE")
			end
			
			self:SetTemplate ("DETAILS_TAB_BUTTONSELECTED_TEMPLATE")
			
			info.selectedTab = self.tabname
			
			--run onclick func
			local result, errorText = pcall (self.onclick)
			if (not result) then
				print (errorText)
			end
		end
		
		newTabButton:SetScript ("OnClick", newTabButton.OnShowFunc)
	end
	
	newTabButton:SetScript ("PostClick", function (self)
		CurrentTab = self.tabname or self.MyObject.tabname

		if (CurrentTab ~= "Summary") then
			for _, widget in ipairs (SummaryWidgets) do
				widget:Hide()
			end
		else
			for _, widget in ipairs (SummaryWidgets) do
				widget:Show()
			end
		end
	end)
	
end

function _detalhes.playerDetailWindow:monta_relatorio (botao)
	
	local atributo = info.atributo
	local sub_atributo = info.sub_atributo
	local player = info.jogador
	local instancia = info.instancia

	local amt = _detalhes.report_lines
	
	if (not player) then
		_detalhes:Msg ("Player not found.")
		return
	end
	
	local report_lines
	
	if (botao == 1) then --> bot�o da esquerda
		

		if (atributo == 1 and sub_atributo == 4) then --> friendly fire
			report_lines = {"Details!: " .. player.nome .. " " .. Loc ["STRING_ATTRIBUTE_DAMAGE_FRIENDLYFIRE"] .. ":"}
			
		elseif (atributo == 1 and sub_atributo == 3) then --> damage taken
			report_lines = {"Details!: " .. player.nome .. " " .. Loc ["STRING_ATTRIBUTE_DAMAGE_TAKEN"] .. ":"}
			
		else
		--	report_lines = {"Details! " .. Loc ["STRING_ACTORFRAME_SPELLSOF"] .. " " .. player.nome .. " (" .. _detalhes.sub_atributos [atributo].lista [sub_atributo] .. ")"}
			report_lines = {"Details!: " .. player.nome .. " - " .. _detalhes.sub_atributos [atributo].lista [sub_atributo] .. ""}
			
		end
		
		for index, barra in _ipairs (info.barras1) do 
			if (barra:IsShown()) then
				local spellid = barra.show
				if (atributo == 1 and sub_atributo == 4) then --> friendly fire
					report_lines [#report_lines+1] = barra.lineText1:GetText() .. ": " .. barra.lineText4:GetText()
					
				elseif (type (spellid) == "number" and spellid > 10) then
					local link = GetSpellLink (spellid)
					report_lines [#report_lines+1] = index .. ". " .. link .. ": " .. barra.lineText4:GetText()
				else
					local spellname = barra.lineText1:GetText():gsub ((".*%."), "")
					spellname = spellname:gsub ("|c%x%x%x%x%x%x%x%x", "")
					spellname = spellname:gsub ("|r", "")
					report_lines [#report_lines+1] = index .. ". " .. spellname .. ": " .. barra.lineText4:GetText()
				end
			end
			if (index == amt) then
				break
			end
		end
		
	elseif (botao == 3) then --> bot�o dos alvos
	
		if (atributo == 1 and sub_atributo == 3) then
			print (Loc ["STRING_ACTORFRAME_NOTHING"])
			return
		end
	
		report_lines = {"Details! " .. Loc ["STRING_ACTORFRAME_REPORTTARGETS"] .. " " .. _detalhes.sub_atributos [1].lista [1] .. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.nome}

		for index, barra in _ipairs (info.barras2) do
			if (barra:IsShown()) then
				report_lines [#report_lines+1] = barra.lineText1:GetText().." -> ".. barra.lineText4:GetText()
			end
			if (index == amt) then
				break
			end
		end
		
	elseif (botao == 2) then --> bot�o da direita
	
			--> diferentes tipos de amostragem na caixa da direita
		     --dano                       --damage done                 --dps                                 --heal
		if ((atributo == 1 and (sub_atributo == 1 or sub_atributo == 2)) or (atributo == 2)) then
			if (not player.detalhes) then
				print (Loc ["STRING_ACTORFRAME_NOTHING"])
				return
			end
			local nome = _GetSpellInfo (player.detalhes)
			report_lines = {"Details! " .. Loc ["STRING_ACTORFRAME_REPORTTO"] .. " " .. _detalhes.sub_atributos [atributo].lista [sub_atributo] .. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.nome, 
			Loc ["STRING_ACTORFRAME_SPELLDETAILS"] .. ": " .. nome}
			
			for i = 1, 5 do
			
				--> pega os dados dos quadrados --> Aqui mostra o resumo de todos os quadrados...
				local caixa = info.grupos_detalhes [i]
				if (caixa.bg:IsShown()) then
				
					local linha = ""

					local nome2 = caixa.nome2:GetText() --> golpes
					if (nome2 and nome2 ~= "") then
						if (i == 1) then
							linha = linha..nome2.." / "
						else
							linha = linha..caixa.nome:GetText().." "..nome2.." / "
						end
					end			
					
					local dano = caixa.dano:GetText() --> dano
					if (dano and dano ~= "") then
						linha = linha..dano.." / "
					end
					
					local media = caixa.dano_media:GetText() --> media
					if (media and media ~= "") then
						linha = linha..media.." / "
					end			
					
					local dano_dps = caixa.dano_dps:GetText()
					if (dano_dps and dano_dps ~= "") then
						linha = linha..dano_dps.." / "
					end
					
					local dano_porcento = caixa.dano_porcento:GetText()
					if (dano_porcento and dano_porcento ~= "") then
						linha = linha..dano_porcento.." "
					end
					
					report_lines [#report_lines+1] = linha
					
				end
				
				if (i == amt) then
					break
				end
				
			end
			
			--dano                       --damage tanken (mostra as magias que o alvo usou)
		elseif ( (atributo == 1 and sub_atributo == 3) or atributo == 3) then
			if (player.detalhes) then
				report_lines = {"Details! " .. Loc ["STRING_ACTORFRAME_REPORTTO"] .. " " .. _detalhes.sub_atributos [1].lista [1] .. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.detalhes.. " " .. Loc ["STRING_ACTORFRAME_REPORTAT"] .. " " .. player.nome}
				for index, barra in _ipairs (info.barras3) do 
					if (barra:IsShown()) then
						report_lines [#report_lines+1] = barra.lineText1:GetText().." ....... ".. barra.lineText4:GetText()
					end
					if (index == amt) then
						break
					end
				end
			else
				report_lines = {}
			end
		end
		
	elseif (botao >= 11) then --> primeira caixa dos detalhes
		
		botao =  botao - 10
		
		local nome
		if (_type (spellid) == "string") then
			--> is a pet
		else
			nome = _GetSpellInfo (player.detalhes)
			local spelllink = GetSpellLink (player.detalhes)
			if (spelllink) then
				nome = spelllink
			end
		end
		
		if (not nome) then
			nome = ""
		end
		report_lines = {"Details! " .. Loc ["STRING_ACTORFRAME_REPORTTO"] .. " " .. _detalhes.sub_atributos [atributo].lista [sub_atributo].. " " .. Loc ["STRING_ACTORFRAME_REPORTOF"] .. " " .. player.nome, 
		Loc ["STRING_ACTORFRAME_SPELLDETAILS"] .. ": " .. nome} 
		
		local caixa = info.grupos_detalhes [botao]
		
		local linha = ""
		local nome2 = caixa.nome2:GetText() --> golpes
		if (nome2 and nome2 ~= "") then
			if (i == 1) then
				linha = linha..nome2.." / "
			else
				linha = linha..caixa.nome:GetText().." "..nome2.." / "
			end
		end

		local dano = caixa.dano:GetText() --> dano
		if (dano and dano ~= "") then
			linha = linha..dano.." / "
		end

		local media = caixa.dano_media:GetText() --> media
		if (media and media ~= "") then
			linha = linha..media.." / "
		end

		local dano_dps = caixa.dano_dps:GetText()
		if (dano_dps and dano_dps ~= "") then
			linha = linha..dano_dps.." / "
		end

		local dano_porcento = caixa.dano_porcento:GetText()
		if (dano_porcento and dano_porcento ~= "") then
			linha = linha..dano_porcento.." "
		end

		--> remove a cor da school
		linha = linha:gsub ("|c%x?%x?%x?%x?%x?%x?%x?%x?", "")
		linha = linha:gsub ("|r", "")
		
		report_lines [#report_lines+1] = linha
		
	end
	
	--local report_lines = {"Details! Relatorio para ".._detalhes.sub_atributos [self.atributo].lista [self.sub_atributo]}

	
	--> pega o conte�do da janela da direita
	
	return instancia:envia_relatorio (report_lines)
end

local row_backdrop = {bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
		insets = {left = 0, right = 0, top = 0, bottom = 0}}
local row_backdrop_onleave = {bgFile = "", edgeFile = "", tile = true, tileSize = 16, edgeSize = 32,
		insets = {left = 1, right = 1, top = 0, bottom = 1}}

local row_on_enter = function (self)
	if (info.fading_in or info.faded) then
		return
	end
	
	self.mouse_over = true

	for index, block in pairs (_detalhes.playerDetailWindow.grupos_detalhes) do
		detalhe_infobg_onleave (block.bg)
	end
	
	--> aumenta o tamanho da barra
	self:SetHeight (CONST_BAR_HEIGHT + 1)
	--> poe a barra com alfa 1 ao inv�s de 0.9
	self:SetAlpha(1)

	--> troca a cor da barra enquanto o mouse estiver em cima dela
	self:SetBackdrop (row_backdrop)	
	self:SetBackdropColor (0.8, 0.8, 0.8, 0.3)
	
	if (self.isAlvo) then --> monta o tooltip do alvo
		--> talvez devesse escurecer a janela no fundo... pois o tooltip � transparente e pode confundir
		GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
		
		if (self.spellid == "enemies") then --> damage taken enemies
			if (not self.minha_tabela or not self.minha_tabela:MontaTooltipDamageTaken (self, self._index, info.instancia)) then  -- > poderia ser aprimerado para uma tailcall
				return
			end
			GameTooltip:Show()
			self:SetHeight (CONST_TARGET_HEIGHT + 1)
			return
		end

		if (not self.minha_tabela or not self.minha_tabela:MontaTooltipAlvos (self, self._index, info.instancia)) then  -- > poderia ser aprimerado para uma tailcall
			return
		end

	elseif (self.isMain) then
	
		if (IsShiftKeyDown()) then
			if (type (self.show) == "number") then
				GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
				GameTooltip:AddLine (Loc ["ABILITY_ID"] .. ": " .. self.show)
				GameTooltip:Show()	
			end
		end
		
		if (self.show == 98021) then
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			GameTooltip:AddLine (Loc ["STRING_SPIRIT_LINK_TOTEM_DESC"])
			GameTooltip:Show()	
		end
	
		--> da zoom no icone
		self.icone:SetWidth (CONST_BAR_HEIGHT + 2)
		self.icone:SetHeight (CONST_BAR_HEIGHT + 2)
		--> poe a alfa do icone em 1.0
		self.icone:SetAlpha (1)
		
		--> mostrar temporariamente o conteudo da barra nas caixas de detalhes
		if (not info.mostrando) then --> n�o esta mostrando nada na direita
			info.mostrando = self --> agora o mostrando � igual a esta barra
			info.mostrando_mouse_over = true --> o conteudo da direta esta sendo mostrado pq o mouse esta passando por cima do bagulho e n�o pq foi clicado
			info.showing = self._index --> diz  o index da barra que esta sendo mostrado na direita

			info.jogador.detalhes = self.show --> minha tabela = jogador = jogador.detales = spellid ou nome que esta sendo mostrado na direita
			info.jogador:MontaDetalhes (self.show, self, info.instancia) --> passa a spellid ou nome e a barra
		end
	end
end

local row_on_leave = function (self)
	if (self.fading_in or self.faded or not self:IsShown() or self.hidden) then
		return
	end

	self.mouse_over = false

	--> diminui o tamanho da barra
	self:SetHeight (CONST_BAR_HEIGHT)
	--> volta com o alfa antigo da barra que era de 0.9
	self:SetAlpha(0.9)
	
	--> volto o background ao normal
	self:SetBackdrop (row_backdrop_onleave)	
	self:SetBackdropBorderColor (0, 0, 0, 0)
	self:SetBackdropColor (0, 0, 0, 0)
	
	GameTooltip:Hide() 
	
	GameCooltip:Hide()
	
	if (self.isMain) then
		--> retira o zoom no icone
		self.icone:SetWidth (CONST_BAR_HEIGHT)
		self.icone:SetHeight (CONST_BAR_HEIGHT)
		--> volta com a alfa antiga da barra
		self.icone:SetAlpha (1)
		
		--> remover o conte�do que estava sendo mostrado na direita
		if (info.mostrando_mouse_over) then
			info.mostrando = nil
			info.mostrando_mouse_over = false
			info.showing = nil
			
			info.jogador.detalhes = nil
			gump:HidaAllDetalheInfo()
		end
	
	elseif (self.isAlvo) then
		self:SetHeight (CONST_TARGET_HEIGHT)
	end
end

local row_on_mousedown = function (self, button)
	if (self.fading_in) then
		return
	end

	self.mouse_down = _GetTime()
	local x, y = _GetCursorPosition()
	self.x = _math_floor (x)
	self.y = _math_floor (y)

	if (button == "RightButton" and not info.isMoving) then
		_detalhes:FechaJanelaInfo()
		
	elseif (not info.isMoving and button == "LeftButton" and not self.isDetalhe) then
		info:StartMoving()
		info.isMoving = true
	end
end

local row_on_mouseup = function (self, button)
	if (self.fading_in) then
		return
	end

	if (info.isMoving and button == "LeftButton" and not self.isDetalhe) then
		info:StopMovingOrSizing()
		info.isMoving = false
	end

	local x, y = _GetCursorPosition()
	x = _math_floor (x)
	y = _math_floor (y)
	if ((self.mouse_down+0.4 > _GetTime() and (x == self.x and y == self.y)) or (x == self.x and y == self.y)) then
		--> setar os textos
		
		if (self.isMain) then --> se n�o for uma barra de alvo
		
			local barra_antiga = info.mostrando			
			if (barra_antiga and not info.mostrando_mouse_over) then
			
				barra_antiga.textura:SetStatusBarColor (1, 1, 1, 1) --> volta a textura normal
				barra_antiga.on_focus = false --> n�o esta mais no foco

				--> clicou na mesma barra
				if (barra_antiga == self) then --> 
					info.mostrando_mouse_over = true
					return
					
				--> clicou em outra barra
				else --> clicou em outra barra e trocou o foco
					barra_antiga:SetAlpha (.9) --> volta a alfa antiga
				
					info.mostrando = self
					info.showing = i
					
					info.jogador.detalhes = self.show
					info.jogador:MontaDetalhes (self.show, self)
					
					self:SetAlpha (1)
					self.textura:SetStatusBarColor (129/255, 125/255, 69/255, 1)
					self.on_focus = true
					return
				end
			end
			
			--> nao tinha barras pressionadas
			info.mostrando_mouse_over = false
			self:SetAlpha (1)
			self.textura:SetStatusBarColor (129/255, 125/255, 69/255, 1)
			self.on_focus = true
		end
		
	end
end

local function SetBarraScripts (esta_barra, instancia, i)
	
	esta_barra._index = i
	
	esta_barra:SetScript ("OnEnter", row_on_enter)
	esta_barra:SetScript ("OnLeave", row_on_leave)

	esta_barra:SetScript ("OnMouseDown", row_on_mousedown)
	esta_barra:SetScript ("OnMouseUp", row_on_mouseup)

end

local function CriaTexturaBarra (instancia, barra)

	barra.textura = _CreateFrame ("StatusBar", nil, barra, "BackdropTemplate")
	
	barra.textura:SetFrameLevel (barra:GetFrameLevel()-1)
	
	barra.textura:SetAllPoints (barra)
	barra.textura:SetAlpha (0.5)
	
	local texture = SharedMedia:Fetch ("statusbar", _detalhes.player_details_window.bar_texture)
	barra.textura:SetStatusBarTexture (texture)
	barra.textura:SetStatusBarTexture (.6, .6, .6, 1)
	
	barra.textura:SetStatusBarColor (.5, .5, .5, 0)
	barra.textura:SetMinMaxValues (0,100)
	
	barra.textura.bg = barra.textura:CreateTexture (nil, "background")
	barra.textura.bg:SetAllPoints()
	barra.textura.bg:SetColorTexture (1, 1, 1, 0.08)
	
	if (barra.targets) then
		barra.targets:SetParent (barra.textura)
		barra.targets:SetFrameLevel (barra.textura:GetFrameLevel()+2)
	end
	
	barra.lineText1 = barra:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	barra.lineText1:SetPoint ("LEFT", barra.textura, "LEFT", CONST_BAR_HEIGHT + 6, 0)
	barra.lineText1:SetJustifyH ("LEFT")
	barra.lineText1:SetTextColor (1,1,1,1)
	
	barra.lineText1:SetNonSpaceWrap (true)
	barra.lineText1:SetWordWrap (false)
	
	barra.lineText4 = barra:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
	if (barra.targets) then
		barra.lineText4:SetPoint ("RIGHT", barra.targets, "LEFT", -2, 0)
	else
		barra.lineText4:SetPoint ("RIGHT", barra, "RIGHT", -2, 0)
	end
	barra.lineText4:SetJustifyH ("RIGHT")
	barra.lineText4:SetTextColor (1,1,1,1)
	
	barra.textura:Show()
end

local miniframe_func_on_enter = function (self)
	local barra = self:GetParent()
	if (barra.show and type (barra.show) == "number") then
		local spellname = _GetSpellInfo (barra.show)
		if (spellname) then
			GameTooltip:SetOwner (self, "ANCHOR_TOPLEFT")
			_detalhes:GameTooltipSetSpellByID (barra.show)
			GameTooltip:Show()
		end
	end
	barra:GetScript("OnEnter")(barra)
end

local miniframe_func_on_leave = function (self)
	GameTooltip:Hide()
	self:GetParent():GetScript("OnLeave")(self:GetParent())
end

local target_on_enter = function (self)

	local barra = self:GetParent():GetParent()
	
	if (barra.show and type (barra.show) == "number") then
		local actor = barra.other_actor or info.jogador
		local spell = actor.spells and actor.spells:PegaHabilidade (barra.show)
		if (spell) then
		
			local ActorTargetsSortTable = {}
			local ActorTargetsContainer
			local total = 0
			
			if (spell.isReflection) then
				ActorTargetsContainer = spell.extra
			else
				local attribute, sub_attribute = info.instancia:GetDisplay()
				if (attribute == 1 or attribute == 3) then
					ActorTargetsContainer = spell.targets
				else
					if (sub_attribute == 3) then --overheal
						ActorTargetsContainer = spell.targets_overheal
					elseif (sub_attribute == 6) then --absorbs
						ActorTargetsContainer = spell.targets_absorbs
					else
						ActorTargetsContainer = spell.targets
					end
				end
			end
			
			--add and sort
			for target_name, amount in _pairs (ActorTargetsContainer) do
				--print (target_name, amount)
				ActorTargetsSortTable [#ActorTargetsSortTable+1] = {target_name, amount or 0}
				total = total + (amount or 0)
			end
			table.sort (ActorTargetsSortTable, _detalhes.Sort2)
			
			local spellname = _GetSpellInfo (barra.show)
			
			GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine (barra.index .. ". " .. spellname)
			GameTooltip:AddLine (info.target_text)
			GameTooltip:AddLine (" ")
			
			--get time type
			local meu_tempo
			if (_detalhes.time_type == 1 or not actor.grupo) then
				meu_tempo = actor:Tempo()
			elseif (_detalhes.time_type == 2) then
				meu_tempo = info.instancia.showing:GetCombatTime()
			end
			
			local SelectedToKFunction = _detalhes.ToKFunctions [_detalhes.ps_abbreviation]
			
			if (spell.isReflection) then
				_detalhes:FormatCooltipForSpells()
				GameCooltip:SetOwner(self, "bottomright", "top", 4, -2)

				_detalhes:AddTooltipSpellHeaderText ("Spells Reflected", {1, 0.9, 0.0, 1}, 1, select(3, _GetSpellInfo(spell.id)), 0.1, 0.9, 0.1, 0.9) --localize-me
				_detalhes:AddTooltipHeaderStatusbar (1, 1, 1, 0.4)

				GameCooltip:AddIcon(select(3, _GetSpellInfo(spell.id)), 1, 1, 16, 16, .1, .9, .1, .9)
				_detalhes:AddTooltipHeaderStatusbar (1, 1, 1, 0.5)

				local topDamage = ActorTargetsSortTable[1] and ActorTargetsSortTable[1][2]

				for index, target in ipairs (ActorTargetsSortTable) do 
					if (target [2] > 0) then
						local spellId = target[1]
						local damageDone = target[2]
						local spellName, _, spellIcon = _GetSpellInfo(spellId)
						GameCooltip:AddLine(spellName, SelectedToKFunction (_, damageDone) .. " (" .. floor(damageDone / topDamage * 100) .. "%)")
						GameCooltip:AddIcon(spellIcon, 1, 1, 16, 16, .1, .9, .1, .9)
						_detalhes:AddTooltipBackgroundStatusbar (false, damageDone / topDamage * 100)
					end
				end

				GameCooltip:Show()

				self.texture:SetAlpha (1)
				self:SetAlpha (1)
				barra:GetScript("OnEnter")(barra)
				return
			else
				for index, target in ipairs (ActorTargetsSortTable) do 
					if (target [2] > 0) then
						local class = _detalhes:GetClass (target [1])
						if (class and _detalhes.class_coords [class]) then
							local cords = _detalhes.class_coords [class]
							if (info.target_persecond) then
								GameTooltip:AddDoubleLine (index .. ". |TInterface\\AddOns\\Details\\images\\classes_small_alpha:14:14:0:0:128:128:"..cords[1]*128 ..":"..cords[2]*128 ..":"..cords[3]*128 ..":"..cords[4]*128 .."|t " .. target [1], _detalhes:comma_value ( _math_floor (target [2] / meu_tempo) ), 1, 1, 1, 1, 1, 1)
							else
								GameTooltip:AddDoubleLine (index .. ". |TInterface\\AddOns\\Details\\images\\classes_small_alpha:14:14:0:0:128:128:"..cords[1]*128 ..":"..cords[2]*128 ..":"..cords[3]*128 ..":"..cords[4]*128 .."|t " .. target [1], SelectedToKFunction (_, target [2]), 1, 1, 1, 1, 1, 1)
							end
						else
							if (info.target_persecond) then
								GameTooltip:AddDoubleLine (index .. ". " .. target [1], _detalhes:comma_value ( _math_floor (target [2] / meu_tempo)), 1, 1, 1, 1, 1, 1)
							else
								GameTooltip:AddDoubleLine (index .. ". " .. target [1], SelectedToKFunction (_, target [2]), 1, 1, 1, 1, 1, 1)
							end
						end
					end
				end
			end
			
			GameTooltip:Show()
		else
			GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
			GameTooltip:AddLine (barra.index .. ". " .. barra.show)
			GameTooltip:AddLine (info.target_text)
			GameTooltip:AddLine (Loc ["STRING_NO_TARGET"], 1, 1, 1)
			GameTooltip:AddLine (Loc ["STRING_MORE_INFO"], 1, 1, 1)
			GameTooltip:Show()
		end
	else
		GameTooltip:SetOwner (self, "ANCHOR_TOPRIGHT")
		GameTooltip:AddLine (barra.index .. ". " .. barra.show)
		GameTooltip:AddLine (info.target_text)
		GameTooltip:AddLine (Loc ["STRING_NO_TARGET"], 1, 1, 1)
		GameTooltip:AddLine (Loc ["STRING_MORE_INFO"], 1, 1, 1)
		GameTooltip:Show()
	end
	
	self.texture:SetAlpha (1)
	self:SetAlpha (1)
	barra:GetScript("OnEnter")(barra)
end

local target_on_leave = function (self)
	GameTooltip:Hide()
	GameCooltip:Hide()
	self:GetParent():GetParent():GetScript("OnLeave")(self:GetParent():GetParent())
	self.texture:SetAlpha (.7)
	self:SetAlpha (.7)
end



function gump:CriaNovaBarraInfo1 (instancia, index)

	if (_detalhes.playerDetailWindow.barras1 [index]) then
		print ("erro a barra "..index.." ja existe na janela de detalhes...")
		return
	end

	local janela = info.container_barras.gump

	local esta_barra = _CreateFrame ("Button", "Details_infobox1_bar_"..index, info.container_barras.gump,"BackdropTemplate")
	esta_barra:SetHeight (CONST_BAR_HEIGHT)
	esta_barra.index = index

	local y = (index-1) * (CONST_BAR_HEIGHT + 1)
	y = y*-1 --> baixo
	
	esta_barra:SetPoint ("LEFT", janela, "LEFT")
	esta_barra:SetPoint ("RIGHT", janela, "RIGHT")
	esta_barra:SetPoint ("TOP", janela, "TOP", 0, y)
	esta_barra:SetFrameLevel (janela:GetFrameLevel() + 1)

	esta_barra:EnableMouse (true)
	esta_barra:RegisterForClicks ("LeftButtonDown","RightButtonUp")	
	
	esta_barra.targets = CreateFrame ("frame", "Details_infobox1_bar_"..index.."Targets", esta_barra, "BackdropTemplate")
	esta_barra.targets:SetPoint ("right", esta_barra, "right")
	esta_barra.targets:SetSize (CONST_BAR_HEIGHT-1, CONST_BAR_HEIGHT-1)
	esta_barra.targets.texture = esta_barra.targets:CreateTexture (nil, overlay)
	esta_barra.targets.texture:SetTexture ([[Interface\MINIMAP\TRACKING\Target]])
	esta_barra.targets.texture:SetAllPoints()
	esta_barra.targets.texture:SetDesaturated (true)
	esta_barra.targets:SetAlpha (.7)
	esta_barra.targets.texture:SetAlpha (.7)
	esta_barra.targets:SetScript ("OnEnter", target_on_enter)
	esta_barra.targets:SetScript ("OnLeave", target_on_leave)
	
	CriaTexturaBarra (instancia, esta_barra)
	
	--> icone
	esta_barra.miniframe = CreateFrame ("frame", nil, esta_barra, "BackdropTemplate")
	esta_barra.miniframe:SetSize (CONST_BAR_HEIGHT-2, CONST_BAR_HEIGHT-2)
	esta_barra.miniframe:SetPoint ("RIGHT", esta_barra.textura, "LEFT", CONST_BAR_HEIGHT + 2, 0)
	
	esta_barra.miniframe:SetScript ("OnEnter", miniframe_func_on_enter)
	esta_barra.miniframe:SetScript ("OnLeave", miniframe_func_on_leave)
	
	esta_barra.icone = esta_barra:CreateTexture (nil, "OVERLAY")
	esta_barra.icone:SetWidth (CONST_BAR_HEIGHT)
	esta_barra.icone:SetHeight (CONST_BAR_HEIGHT)
	esta_barra.icone:SetPoint ("RIGHT", esta_barra.textura, "LEFT", CONST_BAR_HEIGHT + 2, 0)
	
	esta_barra:SetAlpha(0.9)
	esta_barra.icone:SetAlpha (1)
	
	esta_barra.isMain = true
	
	SetBarraScripts (esta_barra, instancia, index)
	
	info.barras1 [index] = esta_barra --> barra adicionada
	
	esta_barra.textura:SetStatusBarColor (1, 1, 1, 1) --> isso aqui � a parte da sele��o e descele��o
	esta_barra.on_focus = false --> isso aqui � a parte da sele��o e descele��o
	
	return esta_barra
end

function gump:CriaNovaBarraInfo2 (instancia, index)

	if (_detalhes.playerDetailWindow.barras2 [index]) then
		print ("erro a barra "..index.." ja existe na janela de detalhes...")
		return
	end
	
	local janela = info.container_alvos.gump

	local esta_barra = _CreateFrame ("Button", "Details_infobox2_bar_"..index, info.container_alvos.gump, "BackdropTemplate")
	esta_barra:SetHeight (CONST_TARGET_HEIGHT)

	local y = (index-1) * (CONST_TARGET_HEIGHT + 1)
	y = y*-1 --> baixo
	
	esta_barra:SetPoint ("LEFT", janela, "LEFT")
	esta_barra:SetPoint ("RIGHT", janela, "RIGHT")
	esta_barra:SetPoint ("TOP", janela, "TOP", 0, y)
	esta_barra:SetFrameLevel (janela:GetFrameLevel() + 1)

	esta_barra:EnableMouse (true)
	esta_barra:RegisterForClicks ("LeftButtonDown","RightButtonUp")	
	
	CriaTexturaBarra (instancia, esta_barra)

	--> icone
	esta_barra.icone = esta_barra:CreateTexture (nil, "OVERLAY")
	esta_barra.icone:SetWidth (CONST_TARGET_HEIGHT)
	esta_barra.icone:SetHeight (CONST_TARGET_HEIGHT)
	esta_barra.icone:SetPoint ("RIGHT", esta_barra.textura, "LEFT", CONST_TARGET_HEIGHT + 2, 0)
	
	esta_barra:SetAlpha (ALPHA_BLEND_AMOUNT)
	esta_barra.icone:SetAlpha (1)
	
	esta_barra.isAlvo = true
	
	SetBarraScripts (esta_barra, instancia, index)
	
	info.barras2 [index] = esta_barra --> barra adicionada
	
	return esta_barra
end

local x_start = 61
local y_start = -10

function gump:CriaNovaBarraInfo3 (instancia, index)

	if (_detalhes.playerDetailWindow.barras3 [index]) then
		print ("erro a barra "..index.." ja existe na janela de detalhes...")
		return
	end

	local janela = info.container_detalhes

	local esta_barra = CreateFrame ("Button", "Details_infobox3_bar_"..index, janela, "BackdropTemplate")
	esta_barra:SetHeight (16)
	
	local y = (index-1) * 17
	y = y*-1
	
	--esta_barra:SetPoint ("LEFT", janela, "LEFT", x_start, 0)
	--esta_barra:SetPoint ("RIGHT", janela, "RIGHT", 65, 0)
	--esta_barra:SetPoint ("TOP", janela, "TOP", 0, y+y_start)
	
	container3_bars_pointFunc (esta_barra, index)
	
	esta_barra:EnableMouse (true)
	
	CriaTexturaBarra (instancia, esta_barra)

	--> icone
	esta_barra.icone = esta_barra:CreateTexture (nil, "OVERLAY")
	esta_barra.icone:SetWidth (14)
	esta_barra.icone:SetHeight (14)
	esta_barra.icone:SetPoint ("RIGHT", esta_barra.textura, "LEFT", 18, 0)
	
	esta_barra:SetAlpha (0.9)
	esta_barra.icone:SetAlpha (1)
	
	esta_barra.isDetalhe = true
	
	SetBarraScripts (esta_barra, instancia, index)
	
	info.barras3 [index] = esta_barra --> barra adicionada
	
	return esta_barra
end
