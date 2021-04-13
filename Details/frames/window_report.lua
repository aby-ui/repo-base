local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

local _detalhes = 		_G._detalhes
local gump = 			_detalhes.gump
local _

--lua locals
local _cstr = tostring --> lua local
local _math_ceil = math.ceil --> lua local
local _math_floor = math.floor --> lua local
local _string_len = string.len --> lua local
local _pairs = pairs --> lua local
local	_tinsert = tinsert --> lua local
local _IsInRaid = IsInRaid --> lua local

local _CreateFrame = CreateFrame --> wow api locals
local _IsInGuild = IsInGuild --> wow api locals
local _GetChannelList = GetChannelList --> wow api locals
local _UIParent = UIParent --> wow api locals

--> details API functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function _detalhes:FastReportWindow (window)
	
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end
		
		local instance = _detalhes:GetInstance (window)
		if (instance) then
		
			if (instance.atributo == 1) then
				_detalhes.report_lines = 14
			elseif (instance.atributo == 2) then
				_detalhes.report_lines = 6
			else
				_detalhes.report_lines = max (10, instance.rows_fit_in_window)
			end
			
			if (IsInRaid()) then
				_detalhes.report_where = "RAID"
			elseif (GetNumSubgroupMembers() > 0) then
				_detalhes.report_where = "PARTY"
			else
				_detalhes.report_where = "SAY"
			end
			
			instance:monta_relatorio()
			
		else
			_detalhes:Msg (Loc ["STRING_WINDOW_NOTFOUND"])
		end
	end

	function _detalhes.ReportFromLatest (_, _, index)
		local t = _detalhes.latest_report_table [index]
		
		if (t) then
			if (not DetailsReportWindow) then
				gump:CriaJanelaReport()
				DetailsReportWindow:Hide()
			end
			
			local id, attribute, subattribute, amt, report_where = unpack (t)
			local instance = _detalhes:GetInstance (id)
			_detalhes.report_lines = amt
			_detalhes.report_where = report_where
			
			local cattribute, csubattribute = instance:GetDisplay()
			instance:SetDisplay (nil, attribute, subattribute)

			instance:monta_relatorio()
			
			instance:SetDisplay (nil, cattribute, csubattribute)
			
			GameCooltip:Hide()
		end
	end

	function _detalhes:SendReportLines (lines)
		if (type (lines) == "string") then
			lines = {lines}
		elseif (type (lines) ~= "table") then
			return _detalhes:NewError ("SendReportLines parameter 1 must be a table or string.")
		end
		return _detalhes:envia_relatorio (lines, true)
	end

	function _detalhes:SendReportWindow (func, _current, _inverse, _slider)

		if (type (func) ~= "function") then
			return _detalhes:NewError ("SendReportWindow parameter 1 must be a function.")
		end

		if (not _detalhes.janela_report) then
			_detalhes.janela_report = gump:CriaJanelaReport()
		end

		if (_current) then
			_G ["Details_Report_CB_1"]:Enable()
			_G ["Details_Report_CB_1Text"]:SetTextColor (1, 1, 1, 1)
		else
			_G ["Details_Report_CB_1"]:Disable()
			_G ["Details_Report_CB_1Text"]:SetTextColor (.5, .5, .5, 1)
		end
		
		if (_inverse) then
			_G ["Details_Report_CB_2"]:Enable()
			_G ["Details_Report_CB_2Text"]:SetTextColor (1, 1, 1, 1)
		else
			_G ["Details_Report_CB_2"]:Disable()
			_G ["Details_Report_CB_2Text"]:SetTextColor (.5, .5, .5, 1)
		end
		
		if (_slider) then
			_detalhes.janela_report.slider:Enable()
			_detalhes.janela_report.slider.lockTexture:Hide()
			_detalhes.janela_report.slider.amt:Show()
		else
			_detalhes.janela_report.slider:Disable()
			_detalhes.janela_report.slider.lockTexture:Show()
			_detalhes.janela_report.slider.amt:Hide()
		end
		
		if (_detalhes.janela_report.ativa) then 
			_detalhes.janela_report:Flash (0.2, 0.2, 0.4, true, 0, 0, "NONE")
		end
		
		_detalhes.janela_report.ativa = true
		_detalhes.janela_report.enviar:SetScript ("OnClick", function() func (_G ["Details_Report_CB_1"]:GetChecked(), _G ["Details_Report_CB_2"]:GetChecked(), _detalhes.report_lines) end)
		
		gump:Fade (_detalhes.janela_report, 0)
		
		return true
	end
	
	function _detalhes:SendReportTextWindow (lines)
	
		if (not _detalhes.copypasteframe) then
			_detalhes.copypasteframe = CreateFrame ("frame", "DetailsCopyPasteFrame2", UIParent,"BackdropTemplate")
			_detalhes.copypasteframe:SetFrameStrata ("TOOLTIP")
			_detalhes.copypasteframe:SetPoint ("CENTER", UIParent, "CENTER", 0, 50)
			tinsert (UISpecialFrames, "DetailsCopyPasteFrame2")
			_detalhes.copypasteframe:SetSize (400, 400)
			_detalhes.copypasteframe:Hide()
			
			DetailsFramework:ApplyStandardBackdrop (_detalhes.copypasteframe)
			DetailsFramework:CreateTitleBar (_detalhes.copypasteframe, "Export Text")
			
			local editBox = CreateFrame ("editbox", nil, _detalhes.copypasteframe)
			editBox:SetPoint ("topleft", _detalhes.copypasteframe, "topleft", 2, -26)
			editBox:SetPoint ("bottomright", _detalhes.copypasteframe, "bottomright", -2, 2)
			editBox:SetAutoFocus (false)
			editBox:SetMultiLine (true)
			editBox:SetFontObject ("GameFontHighlightSmall")
			
			editBox:SetScript ("OnEditFocusGained", function() editBox:HighlightText() end)
			editBox:SetScript ("OnEditFocusLost", function() _detalhes.copypasteframe:Hide() end)
			editBox:SetScript ("OnEscapePressed", function() editBox:SetFocus (false); _detalhes.copypasteframe:Hide() end)
			editBox:SetScript ("OnChar", function() editBox:SetFocus (false); _detalhes.copypasteframe:Hide() end)
			
			_detalhes.copypasteframe.EditBox = editBox
		end
		
		local s = ""
		for _, line in ipairs (lines) do 
			s = s .. line .. "\n"
		end
		
		_detalhes.copypasteframe:Show()
		_detalhes.copypasteframe.EditBox:SetText (s)
		_detalhes.copypasteframe.EditBox:HighlightText()
		_detalhes.copypasteframe.EditBox:SetFocus (true)
	end

	
--> internal details report functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function _detalhes:Reportar (param2, options, arg3, id)

		GameCooltip2:Hide()
	
		if (not _detalhes.janela_report) then
			_detalhes.janela_report = gump:CriaJanelaReport()
		end
		
		if (options and options.meu_id) then
			self = options
		end
		
		if (type (param2) == "string") then
			id = param2
		end

		if (_detalhes.last_report_id and id and _detalhes.last_report_id == id) then
			_detalhes.last_report_id = nil
			_detalhes.janela_report.fechar:Click()
			return
		end
		
		_detalhes.last_report_id = id
		
		--> trabalha com as op��es:
		if (options and options._no_current) then
			_G ["Details_Report_CB_1"]:Disable()
			_G ["Details_Report_CB_1Text"]:SetTextColor (.5, .5, .5, 1)
		else
			_G ["Details_Report_CB_1"]:Enable()
			_G ["Details_Report_CB_1Text"]:SetTextColor (1, 1, 1, 1)
		end
		
		if (options and options._no_inverse) then
			_G ["Details_Report_CB_2"]:Disable()
			_G ["Details_Report_CB_2Text"]:SetTextColor (.5, .5, .5, 1)
		else
			_G ["Details_Report_CB_2"]:Enable()
			_G ["Details_Report_CB_2Text"]:SetTextColor (1, 1, 1, 1)
		end
		
		_detalhes.janela_report.slider:Enable()
		_detalhes.janela_report.slider.lockTexture:Hide()
		_detalhes.janela_report.slider.amt:Show()
		
		if (options) then
			_detalhes.janela_report.enviar:SetScript ("OnClick", function() self:monta_relatorio (param2, options._custom) end)
		else
			_detalhes.janela_report.enviar:SetScript ("OnClick", function() self:monta_relatorio (param2) end)
		end

		if (_detalhes.janela_report.ativa) then 
			_detalhes.janela_report:Flash (0.2, 0.2, 0.4, true, 0, 0, "NONE")
		end
		
		_detalhes.janela_report.ativa = true
		gump:Fade (_detalhes.janela_report, 0)
	end
	
--> build report frame gump -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--> script
	local savepos = function (self)
		local xofs, yofs = self:GetCenter() 
		local scale = self:GetEffectiveScale()
		local UIscale = UIParent:GetScale()
		xofs = xofs * scale - GetScreenWidth() * UIscale / 2
		yofs = yofs * scale - GetScreenHeight() * UIscale / 2
		local x = xofs / UIscale
		local y = yofs / UIscale
		_detalhes.report_pos [1] = x
		_detalhes.report_pos [2] = y
	end
	local restorepos = function (self)
		local x, y = _detalhes.report_pos [1], _detalhes.report_pos [2]
		local scale = self:GetEffectiveScale() 
		local UIscale = UIParent:GetScale()
		x = x * UIscale / scale
		y = y * UIscale / scale
		self:ClearAllPoints()
		self:SetPoint ("center", UIParent, "center", x, y)
	end
	local function seta_scripts (este_gump)
		--> Janela
		este_gump:SetScript ("OnMouseDown", 
						function (self, botao)
							if (botao == "LeftButton") then
								self:StartMoving()
								self.isMoving = true
							elseif (botao == "RightButton") then
								if (self.isMoving) then
									self:StopMovingOrSizing()
									savepos (self)
									self.isMoving = false
								end
								self:Hide()
							end
						end)
						
		este_gump:SetScript ("OnMouseUp", 
						function (self)
							if (self.isMoving) then
								self:StopMovingOrSizing()
								savepos (self)
								self.isMoving = false
							end
						end)
	end

--> dropdown menus

--[[
Emote: 255 251 255
Yell: 255 63 64
Guild Chat: 64 251 64
Officer Chat: 64 189 64
Achievement: 255 251 0
Whisper: 255 126 255
RealID: 0 251 246
Party: 170 167 255
Party Lead: 118 197 255
Raid: 255 125 0
Raid Warning: 255 71 0
Raid Lead: 255 71 9
BG Leader: 255 216 183
General/Trade: 255 189 192
--]]


local icons_and_colors = {
	["PARTY"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {0.66, 0.65, 1}},
	["RAID"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {1, 0.49, 0}},
	["GUILD"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.98, 0.25}},
	["OFFICER"] = {label = Loc ["STRING_REPORTFRAME_OFFICERS"], icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.74, 0.25}},
	["WHISPER"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}},
	["SAY"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0390625, 0.203125, 0.09375, 0.375}, color = {1, 1, 1}},
	["COPY"] = {icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], coords = {0, 1, 0, 1}, color = {1, 1, 1}},
}
function _detalhes.GetReportIconAndColor (report_where)
	local key = report_where:gsub ((".*|"), "")
	return icons_and_colors [key]
end

local function cria_drop_down (este_gump)

	local iconsize = {16, 16}

	local baseChannels = {
		{Loc ["STRING_REPORTFRAME_PARTY"], "PARTY", function() return GetNumSubgroupMembers() > 0 end, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {0.66, 0.65, 1}}},
		{Loc ["STRING_REPORTFRAME_RAID"], "RAID", _IsInRaid, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {1, 0.49, 0}}}, 
		{Loc ["STRING_REPORTFRAME_GUILD"], "GUILD", _IsInGuild, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.98, 0.25}}}, 
		{Loc ["STRING_REPORTFRAME_OFFICERS"], "OFFICER", _IsInGuild, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.74, 0.25}}}, 
		{Loc ["STRING_REPORTFRAME_WHISPER"], "WHISPER", nil, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}}, 
		{Loc ["STRING_REPORTFRAME_WHISPERTARGET"], "WHISPER2", nil, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}}, 
		{Loc ["STRING_REPORTFRAME_SAY"], "SAY", IsInInstance, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0390625, 0.203125, 0.09375, 0.375}, color = {1, 1, 1}}},
		{Loc ["STRING_REPORTFRAME_COPY"], "COPY", nil, {iconsize = iconsize, icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], coords = {0, 1, 0, 1}, color = {1, 1, 1}}},
	}

		local on_click = function (self, fixedParam, selectedOutput)
			_detalhes.report_where = selectedOutput
		end
	
		local build_list = function()
			local reportChannelsTable = {}
		
			for index, channelInfo in ipairs (baseChannels) do 
				if (not channelInfo [3] or channelInfo[3]()) then
					reportChannelsTable[#reportChannelsTable + 1] = {iconsize = channelInfo [4].iconsize, value = channelInfo [2], label = channelInfo [1], onclick = on_click, icon = channelInfo [4].icon, texcoord = channelInfo [4].coords, iconcolor = channelInfo [4].color}
				end
			end
			
			local channels = {_GetChannelList()} --> coloca o resultado em uma tabela .. {id1, canal1, id2, canal2}
			--09/august/2018: GetChannelList passed to return 3 values for each channel instead of 2
			for i = 1, #channels, 3 do --> total de canais
				reportChannelsTable [#reportChannelsTable + 1] = {iconsize = iconsize, value = "CHANNEL|"..channels [i+1], label = channels [i]..". "..channels [i+1], onclick = on_click, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], texcoord = {0.3046875, 0.4453125, 0.109375, 0.390625}, iconcolor = {149/255, 112/255, 112/255}}
			end
			
			if (not DetailsFramework.IsTimewalkWoW()) then
				local _, numBNetOnline = BNGetNumFriends()
				for i = 1, numBNetOnline do
					local accountInfo = C_BattleNet.GetFriendAccountInfo(i)
					local gameAccountInfo = accountInfo and accountInfo.gameAccountInfo

					if (gameAccountInfo) then
						local isOnline = gameAccountInfo.isOnline
						if (isOnline) then
							local bTag = accountInfo.battleTag
							local bTagNoNumber = bTag:gsub("#.*", "")
							reportChannelsTable[#reportChannelsTable + 1] = {iconsize = iconsize, value = "REALID|" .. accountInfo.bnetAccountID, label = bTagNoNumber, onclick = on_click, icon = [[Interface\FriendsFrame\Battlenet-Battleneticon]], texcoord = {0.125, 0.875, 0.125, 0.875}, iconcolor = {1, 1, 1}}
						end
					end
				end
			end

			return reportChannelsTable
		end
		este_gump.dropdown_func = build_list
	
		local select_output = gump:NewDropDown (este_gump, _, "$parentOutputDropdown", "select", 185, 20, build_list, 1)
		select_output:SetPoint ("topleft", este_gump, "topleft", 107, -55)
		este_gump.select = select_output.widget
		este_gump.dropdown = select_output
		
		function select_output:CheckValid()
			
			local last_selected = _detalhes.report_where
			local check_func
			for i, t in ipairs (baseChannels) do
				if (t[2] == last_selected) then
					check_func = t[3]
					break
				end
			end
			
			if (check_func) then
				local is_shown = check_func()
				if (is_shown) then
					select_output:Select (last_selected)
				else
					if (IsInRaid()) then
						select_output:Select ("RAID")
					elseif (GetNumSubgroupMembers() > 0) then
						select_output:Select ("PARTY")
					elseif (IsInGuild()) then
						select_output:Select ("GUILD")
					else
						select_output:Select ("SAY")
					end
				end
			else
				select_output:Select (last_selected)
			end
		end
		
		select_output:CheckValid()
	end

--> slider

	local function cria_slider (este_gump)

		este_gump.linhas_amt = este_gump:CreateFontString (nil, "OVERLAY", "GameFontHighlight")
		este_gump.linhas_amt:SetText (Loc ["STRING_REPORTFRAME_LINES"])
		este_gump.linhas_amt:SetTextColor (.9, .9, .9, 1)
		este_gump.linhas_amt:SetPoint ("bottomleft", este_gump, "bottomleft", 58, 12)
		_detalhes:SetFontSize (este_gump.linhas_amt, 10)
		
		local slider = _CreateFrame ("Slider", "Details_Report_Slider", este_gump,"BackdropTemplate")
		este_gump.slider = slider
		slider:SetPoint ("bottomleft", este_gump, "bottomleft", 58, -7)
		
		slider.thumb = slider:CreateTexture (nil, "artwork")
		slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
		slider.thumb:SetSize (30, 24)
		slider.thumb:SetAlpha (0.7)
		
		local lockTexture = slider:CreateTexture (nil, "overlay")
		lockTexture:SetPoint ("center", slider.thumb, "center", -1, -1)
		lockTexture:SetTexture ("Interface\\Buttons\\CancelButton-Up")
		lockTexture:SetWidth (29)
		lockTexture:SetHeight (24)
		lockTexture:Hide()
		slider.lockTexture = lockTexture

		slider:SetThumbTexture (slider.thumb) --depois 
		slider:SetOrientation ("HORIZONTAL")
		slider:SetMinMaxValues (1.0, 25.0)
		slider:SetValueStep (1.0)
		slider:SetWidth (232)
		slider:SetHeight (20)

		local last_value = _detalhes.report_lines or 5
		slider:SetValue (math.floor (last_value))
		
		slider.amt = slider:CreateFontString (nil, "OVERLAY", "GameFontHighlightSmall")
		local amt = slider:GetValue()
		if (amt < 10) then
			amt = "0"..amt
		end
		slider.amt:SetText (amt)
		slider.amt:SetTextColor (.8, .8, .8, 1)
		
		slider.amt:SetPoint ("center", slider.thumb, "center")
		
		slider:SetScript ("OnValueChanged", function (self) 
			local amt = math.floor (self:GetValue())
			_detalhes.report_lines = amt
			if (amt < 10) then
				amt = "0"..amt
			end
			self.amt:SetText (amt)
			end)
		
		slider:SetScript ("OnEnter", function (self)
				slider.thumb:SetAlpha (1)
		end)
		
		slider:SetScript ("OnLeave", function (self)
				slider.thumb:SetAlpha (0.7)
		end)
		
	end

--> whisper taget field

	local function cria_wisper_field (este_gump)
		
		este_gump.wisp_who = este_gump:CreateFontString (nil, "OVERLAY", "GameFontHighlight")
		este_gump.wisp_who:SetText (Loc ["STRING_REPORTFRAME_WHISPER"] .. ":")
		este_gump.wisp_who:SetTextColor (1, 1, 1, 1)
		
		este_gump.wisp_who:SetPoint ("topleft", este_gump.select, "topleft", 14, -30)
		
		_detalhes:SetFontSize (este_gump.wisp_who, 10)

		--editbox
		local editbox = _CreateFrame ("EditBox", nil, este_gump,"BackdropTemplate")
		este_gump.editbox = editbox
		
		editbox:SetAutoFocus (false)
		editbox:SetFontObject ("GameFontHighlightSmall")
		
		editbox:SetPoint ("TOPLEFT", este_gump.select, "TOPLEFT", 64, -28)
		
		editbox:SetHeight (14)
		editbox:SetWidth (120)
		editbox:SetJustifyH ("center")
		editbox:EnableMouse(true)
		editbox:SetBackdrop ({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			})
		editbox:SetBackdropColor(0, 0, 0, 0.0)
		editbox:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)
		
		local last_value = _detalhes.report_to_who or ""
		editbox:SetText (last_value)
		editbox.perdeu_foco = nil
		editbox.focus = false
		
		editbox:SetScript ("OnEnterPressed", function () 
			local texto = _detalhes:trim (editbox:GetText())
			if (_string_len (texto) > 0) then
				_detalhes.report_to_who = texto
				editbox:AddHistoryLine (texto)
				editbox:SetText (texto)
			else 
				_detalhes.report_to_who = ""
				editbox:SetText ("")
			end 
			editbox.perdeu_foco = true --> isso aqui pra quando estiver editando e clicar em outra caixa
			editbox:ClearFocus()
		end)
		
		editbox:SetScript ("OnEscapePressed", function() 
			editbox:SetText("") 
			_detalhes.report_to_who = ""
			editbox.perdeu_foco = true
			editbox:ClearFocus() 
		end)
		
		editbox:SetScript ("OnEnter", function() 
			editbox.mouse_over = true 
			--editbox:SetBackdropColor(0.1, 0.1, 0.1, 0.7)
			if (editbox:GetText() == "" and not editbox.focus) then
				editbox:SetText (Loc ["STRING_REPORTFRAME_INSERTNAME"])
			end 
		end)
		
		editbox:SetScript ("OnLeave", function() 
			editbox.mouse_over = false 
			--editbox:SetBackdropColor(0.0, 0.0, 0.0, 0.0)
			if (not editbox:HasFocus()) then 
				if (editbox:GetText() == Loc ["STRING_REPORTFRAME_INSERTNAME"]) then
					editbox:SetText("") 
				end 
			end 
		end)

		editbox:SetScript ("OnEditFocusGained", function()
			if (editbox:GetText() == Loc ["STRING_REPORTFRAME_INSERTNAME"]) then
				editbox:SetText("") 
			end
			
			if (editbox:GetText() ~= "") then
				--> selecionar todo o texto
				editbox:HighlightText (0, editbox:GetNumLetters())
			end
			
			editbox.focus = true
		end)
		
		editbox:SetScript ("OnEditFocusLost", function()
			if (editbox.perdeu_foco == nil) then
				local texto = _detalhes:trim (editbox:GetText())
				if (_string_len (texto) > 0) then 
					_detalhes.report_to_who = texto
				else
					_detalhes.report_to_who = ""
					editbox:SetText ("")
				end 
			else
				editbox.perdeu_foco = nil
			end
			
			editbox.focus = false
		end)
	end

--> both check buttons
		
	function cria_check_buttons (este_gump)
		local checkbox = _CreateFrame ("CheckButton", "Details_Report_CB_1", este_gump, "ChatConfigCheckButtonTemplate,BackdropTemplate")
		checkbox:SetPoint ("topleft", este_gump.wisp_who, "bottomleft", -25, -4)
		_G [checkbox:GetName().."Text"]:SetText (Loc ["STRING_REPORTFRAME_CURRENT"])
		_detalhes:SetFontSize (_G [checkbox:GetName().."Text"], 10)
		checkbox.tooltip = Loc ["STRING_REPORTFRAME_CURRENTINFO"]
		checkbox:SetHitRectInsets (0, -35, 0, 0)
		
		local checkbox2 = _CreateFrame ("CheckButton", "Details_Report_CB_2", este_gump, "ChatConfigCheckButtonTemplate,BackdropTemplate")
		checkbox2:SetPoint ("topleft", este_gump.wisp_who, "bottomleft", 35, -4)
		_G [checkbox2:GetName().."Text"]:SetText (Loc ["STRING_REPORTFRAME_REVERT"])
		_detalhes:SetFontSize (_G [checkbox2:GetName().."Text"], 10)
		checkbox2.tooltip = Loc ["STRING_REPORTFRAME_REVERTINFO"]
		checkbox2:SetHitRectInsets (0, -35, 0, 0)
	end

--> frame creation function


	local elvui_skin = function()
	
		local window = DetailsReportWindow
		
		local anchorX = 10
	
		local b_onenter = function (self)
			self:SetBackdropColor (0.4, 0.4, 0.4, 0.6)
			self.icon:SetBlendMode ("ADD")
			_detalhes:SetFontColor (self.text, "yellow")
		end
		local b_onleave = function (self)
			self:SetBackdropColor (0, 0, 0, 0.3)
			self.icon:SetBlendMode ("BLEND")
			_detalhes:SetFontColor (self.text, "white")
		end
	
		window.last_reported_label:SetPoint ("topleft", window, "topleft", 5, -28)
		gump:SetFontSize (window.last_reported_label, 10)
	
		for i = 1, 9 do --window.max_last_buttons
			local b = window.recently_report_buttons [i]
			
			b:SetSize (150, 16)
			b:SetPoint ("topleft", window, "topleft", 5, -28 + (i*17*-1))
			b:Show()
			b:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
			insets = {left = 0, right = 0, top = 0, bottom = 0}})
			b:SetBackdropColor (0, 0, 0, 0.3)
			b.text:SetTextColor (1, 1, 1, 1)
			_detalhes:SetFontSize (b.text, 9)
			
			b:SetScript ("OnEnter", b_onenter)
			b:SetScript ("OnLeave", b_onleave)
		end

		window.fechar:SetWidth (20)
		window.fechar:SetHeight (20)
		window.fechar:SetPoint ("TOPRIGHT", window, "TOPRIGHT", 0, -3)
		window.fechar:Show()
		window.fechar:GetNormalTexture():SetDesaturated (true)

		local b = window.recently_report_buttons [10]
		b:Hide()
		
		window.dropdown:ClearAllPoints()
		window.dropdown:SetWidth (155)
		window.dropdown:SetPoint ("topleft", window, "topleft", anchorX, -30)
		window.dropdown:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.dropdown:SetBackdropBorderColor (0, 0, 0, 0.5)
		window.dropdown:SetBackdropColor (0, 0, 0, 0.1)
		
		window.wisp_who:ClearAllPoints()
		window.editbox:ClearAllPoints()
		window.wisp_who:SetPoint ("topleft", window.dropdown.widget, "bottomleft", 0, -10)
		window.editbox:SetPoint ("topleft", window.wisp_who, "bottomleft", 0, -3)
		window.editbox:SetWidth (155)
		window.editbox:SetHeight (20)
		window.editbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.editbox:SetBackdropBorderColor (0, 0, 0, 0.5)
		window.editbox:SetBackdropColor (0, 0, 0, 0.3)
		
		window.linhas_amt:ClearAllPoints()
		window.linhas_amt:SetPoint ("topleft", window.editbox, "bottomleft", 0, -10)
		window.slider:ClearAllPoints()
		window.slider:SetWidth (155)
		window.slider:SetPoint ("topleft", window.linhas_amt, "bottomleft", 0, -3)
		window.slider:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.slider:SetBackdropBorderColor (0, 0, 0, 0.5)
		window.slider:SetBackdropColor (0, 0, 0, 0.3)
		
		window.slider.thumb:SetTexture ([[Interface\AddOns\Details\images\icons2]])
		window.slider.thumb:SetTexCoord (482/512, 492/512, 104/512, 120/512)
		window.slider.thumb:SetSize (16, 16)
		window.slider.thumb:SetVertexColor (0.6, 0.6, 0.6, 0.95)		
		
		Details_Report_CB_1:Hide()
		local reverse_checkbox = Details_Report_CB_2
		reverse_checkbox:Show()
		reverse_checkbox:ClearAllPoints()
		reverse_checkbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		reverse_checkbox:SetBackdropBorderColor (0, 0, 0, 0.5)
		reverse_checkbox:SetBackdropColor (0, 0, 0, 0.3)
		reverse_checkbox:SetPoint ("topleft", window.slider, "bottomleft", 0, -8)
		reverse_checkbox:SetSize (14, 14)
		reverse_checkbox:SetNormalTexture (nil)
		reverse_checkbox:SetPushedTexture (nil)
		reverse_checkbox:SetHighlightTexture (nil)
		_G [reverse_checkbox:GetName().."Text"]:ClearAllPoints()
		_G [reverse_checkbox:GetName().."Text"]:SetPoint ("left", reverse_checkbox, "right", 2, 0)
		
		window.enviar:ClearAllPoints()
		window.enviar:SetPoint ("bottom", window, "bottom", 0, 10)
		window.enviar:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.enviar:SetBackdropBorderColor (0, 0, 0, 0.5)
		window.enviar:SetBackdropColor (0, 0, 0, 0.3)
		window.enviar.Left:Hide()
		window.enviar.Middle:Hide()
		window.enviar.Right:Hide()
		
		window.enviar:SetSize (342/2 - 15, 20)
		
		window:SetWidth (342/2 + 5)
		window:SetHeight (195)
		window:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		window:SetBackdropColor (1, 1, 1, 1)
		window:SetBackdropBorderColor (0, 0, 0, 1)
	
		if (not window.elvui_widgets) then
			window.elvui_widgets = {}
			
			local titlebar = CreateFrame ("frame", window:GetName() .. "ElvUITitleBar", window,"BackdropTemplate")
			titlebar:SetPoint ("topleft", window, "topleft", 2, -3)
			titlebar:SetPoint ("topright", window, "topright", -2, -3)
			titlebar:SetHeight (20)
			titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar:SetBackdropColor (.5, .5, .5, 1)
			titlebar:SetBackdropBorderColor (0, 0, 0, 1)
			
			local bg1 = window:CreateTexture (nil, "background")
			bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
			bg1:SetAlpha (0.7)
			bg1:SetVertexColor (0.27, 0.27, 0.27)
			bg1:SetVertTile (true)
			bg1:SetHorizTile (true)
			bg1:SetAllPoints()
			
			tinsert (window.all_widgets, bg1)
			tinsert (window.elvui_widgets, bg1)
			tinsert (window.all_widgets, titlebar)
			tinsert (window.elvui_widgets, titlebar)
		end

		window.title:ClearAllPoints()
		window.title:SetPoint ("center", window, "center")
		window.title:SetPoint ("top", window, "top", 0, -7)
		window.title:SetParent (_G [window:GetName() .. "ElvUITitleBar"])
		window.title:SetTextColor (.8, .8, .8, 1)
		window.title:Show()
		
		
		window:SetClampedToScreen (true)
		
		for _, widget in ipairs (window.elvui_widgets) do
			widget:Show()
		end
		
	end
	
	local classic_skin = function()
	
		local window = DetailsReportWindow
	
		local b_onenter = function (self)
			self:SetBackdropColor (0.4, 0.4, 0.4, 0.6)
			self.icon:SetBlendMode ("ADD")
			_detalhes:SetFontColor (self.text, "yellow")
		end
		local b_onleave = function (self)
			self:SetBackdropColor (0, 0, 0, 0.3)
			self.icon:SetBlendMode ("BLEND")
			_detalhes:SetFontColor (self.text, "white")
		end
	
		window.last_reported_label:SetPoint ("topleft", window, "topleft", 10, -69)
		_detalhes:SetFontSize (window.last_reported_label, 10)
		
		for i = 1, 8 do --window.max_last_buttons
			local b = window.recently_report_buttons [i]
			
			b:SetSize (150, 16)
			b:SetPoint ("topleft", window, "topleft", 10, -67 + (i*17*-1))
			b:Show()
			b:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
			insets = {left = 0, right = 0, top = 0, bottom = 0}})
			b:SetBackdropColor (0, 0, 0, 0.3)
			b.text:SetTextColor (1, 1, 1, 1)
			_detalhes:SetFontSize (b.text, 9)
			
			b:SetScript ("OnEnter", b_onenter)
			b:SetScript ("OnLeave", b_onleave)
		end
		
		local b = window.recently_report_buttons [10]
		b:Hide()
		b = window.recently_report_buttons [9]
		b:Hide()
		
		Details_Report_CB_1:Hide()
		Details_Report_CB_2:Hide()
		
		window.dropdown:ClearAllPoints()
		window.dropdown:SetWidth (145)
		window.dropdown:SetPoint ("topleft", window, "topleft", 175, -68)
		
		window.wisp_who:ClearAllPoints()
		window.editbox:ClearAllPoints()
		window.wisp_who:SetPoint ("topleft", window.dropdown.widget, "bottomleft", 0, -10)
		window.editbox:SetPoint ("topleft", window.wisp_who, "bottomleft", 0, -3)
		window.editbox:SetWidth (145)
		window.editbox:SetHeight (20)
		window.editbox:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\AddOns\Details\images\border_3]], tile=true,
		edgeSize = 15, tileSize = 64, insets = {left = 3, right = 3, top = 4, bottom = 4}})
		
		window.linhas_amt:ClearAllPoints()
		window.linhas_amt:SetPoint ("topleft", window.editbox, "bottomleft", 0, -7)
		window.slider:ClearAllPoints()
		window.slider :SetWidth (145)
		window.slider:SetPoint ("topleft", window.linhas_amt, "bottomleft", 0, -3)
		window.slider:SetBackdrop ({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\AddOns\Details\images\border_3]], tile=true,
		edgeSize = 15, tileSize = 64, insets = {left = 3, right = 3, top = 4, bottom = 4}})
		
		window.slider.thumb:SetTexture ("Interface\\Buttons\\UI-ScrollBar-Knob")
		window.slider.thumb:SetSize (30, 24)
		window.slider.thumb:SetAlpha (0.7)
		
		Details_Report_CB_1:Hide()
		local reverse_checkbox = Details_Report_CB_2
		reverse_checkbox:Show()
		reverse_checkbox:ClearAllPoints()
		reverse_checkbox:SetBackdrop (nil)
		reverse_checkbox:SetPoint ("topleft", window.slider, "bottomleft", -1, -4)
		reverse_checkbox:SetSize (26, 26)
		reverse_checkbox:SetNormalTexture ([[Interface\Buttons\UI-CheckBox-Up]])
		reverse_checkbox:SetPushedTexture ([[Interface\Buttons\UI-CheckBox-Down]])
		reverse_checkbox:SetHighlightTexture ([[Interface\Buttons\UI-CheckBox-Highlight]])
		_G [reverse_checkbox:GetName().."Text"]:ClearAllPoints()
		_G [reverse_checkbox:GetName().."Text"]:SetPoint ("left", reverse_checkbox, "right", 2, 0)
		
		window.enviar:ClearAllPoints()
		window.enviar:SetPoint ("topleft", reverse_checkbox, "bottomleft", 0, -4)
		window.enviar.Left:Show()
		window.enviar.Middle:Show()
		window.enviar.Right:Show()
		
		window:SetWidth (342)
		window:SetHeight (255)
		window:SetBackdrop (nil)
		
		window.fechar:Hide()
		window.title:Hide()
		
		if (not window.classic_widgets) then
			window.classic_widgets = {}
			
			local f = CreateFrame ("frame", window:GetName() .. "F", window, "ButtonFrameTemplate")
			f:SetAllPoints()
			
			f.portrait:SetTexture ("Interface\\AddOns\\Details\\images\\report_frame_icons")
			f.portrait:SetTexCoord (1/256, 64/256, 1/256, 64/256)
			
			f.TitleText:SetText (Loc ["STRING_REPORTFRAME_WINDOW_TITLE"])
			f:SetFrameLevel (window:GetFrameLevel()-1)
			
			_G [window:GetName() .. "FCloseButton"]:SetFrameLevel (window:GetFrameLevel()+1)
			_G [window:GetName() .. "FCloseButton"]:SetScript ("OnClick", function()
				window:Hide()
			end)

			tinsert (window.classic_widgets, f)
			tinsert (window.all_widgets, f)
		end

		for _, widget in ipairs (window.classic_widgets) do
			widget:Show()
		end

	end

	
	function _detalhes:UpdateRecentlyReported()
		DetailsReportWindow:RefreshRecentlyReported()
	end
	function _detalhes:DelayUpdateReportWindowRecentlyReported()
		if (DetailsReportWindow) then
			_detalhes:ScheduleTimer ("UpdateRecentlyReported", 0.5)
		end
	end
	
	function _detalhes:CheckLastReportsIntegrity()
		local last_reports = _detalhes.latest_report_table or {}
		if (#last_reports > 0) then
			local i = 1
			for index = #last_reports, 1, -1 do
				local report = last_reports [index]
				local instance_id, atributo, sub_atributo, amt, where, custom_name = unpack (report)
				if (atributo == 5) then
					if (not custom_name) then
						tremove (last_reports, index)
					else
						local found
						for _, custom in ipairs (_detalhes.custom) do
							if (custom.name == custom_name) then
								found = true
								break
							end
						end
						if (not found) then
							tremove (last_reports, index)
						end
					end
				end
			end
		end
	end
	
	function gump:CriaJanelaReport()

		--> window
			local window = _CreateFrame ("Frame", "DetailsReportWindow", _UIParent,"BackdropTemplate")
			tinsert (UISpecialFrames, "DetailsReportWindow")
			window:SetPoint ("CENTER", UIParent, "CENTER")
			window:SetFrameStrata ("DIALOG")
			window.skins = {}
			window.all_widgets = {}
			window.max_last_buttons = 10
			
			window:EnableMouse (true)
			window:SetResizable (false)
			window:SetMovable (true)
			restorepos (window)

			_detalhes.janela_report = window
	
			_detalhes:InstallRPSkin ("WoWClassic", classic_skin)
			_detalhes:InstallRPSkin ("ElvUI", elvui_skin)
	
		--> all new widgets:
			
			--recently reported:
			window.recently_report_buttons = {}
			
			local history_Background = window:CreateTexture (nil, "background")
			history_Background:SetColorTexture (0, 0, 0, .3)
			history_Background:SetSize (160, 158)
			history_Background:SetPoint ("topleft", window, "topleft", 3, -25)
			
			local separador = window:CreateTexture (nil, "border")
			separador:SetColorTexture (0, 0, 0, .6)
			separador:SetSize (2, 158)
			separador:SetPoint ("topleft", history_Background, "topright", 0, 0)
			
			function window:RefreshRecentlyReported()
				for i = 1, window.max_last_buttons do
					local b = window.recently_report_buttons [i]
					b.icon:SetTexture (nil)
					b:Hide()
				end
				
				_detalhes:CheckLastReportsIntegrity()
				
				local last_reports = _detalhes.latest_report_table
				if (#last_reports > 0) then
					local i = 1
					for index = 1, min (#last_reports, 8) do
						local b = window.recently_report_buttons [i]
						local report = last_reports [index]
						local instance_number, attribute, subattribute, amt, report_where = unpack (report)
						local name = _detalhes:GetSubAttributeName (attribute, subattribute)
						local artwork =  _detalhes.GetReportIconAndColor (report_where)
						
						b.text:SetText (name .. " (#" .. amt .. ")")
						b.index = index
						if (artwork) then
							b.icon:SetTexture (artwork.icon)
							b.icon:SetTexCoord (artwork.coords[1], artwork.coords[2], artwork.coords[3], artwork.coords[4])
							b.icon:SetVertexColor (unpack (artwork.color or {}))
						end
						
						--b:Show()
						b:Hide()
						i = i + 1
					end
				end
			end
			
			local recently_on_click = function (self)
				if (self.index) then
					return _detalhes.ReportFromLatest (_, _, self.index)
				end 
			end
			
			local last_reported_label = window:CreateFontString (nil, "overlay", "GameFontNormal")
			window.last_reported_label = last_reported_label
			window.last_reported_label:SetText (Loc ["STRING_REPORTHISTORY"] .. ":") --this string could be removed from localization
			
			for i = 1, window.max_last_buttons do
				local b = CreateFrame ("button", "DetailsReportWindowRRB" .. i, window,"BackdropTemplate")
				local icon = b:CreateTexture (nil, "overlay")
				icon:SetPoint ("left", b, "left")
				icon:SetSize (16, 16)
				local text = b:CreateFontString (nil, "overlay", "GameFontNormal")
				text:SetPoint ("left", icon, "right", 2, 0)
				b.icon = icon
				b.text = text
				b:SetScript ("OnClick", recently_on_click)
				tinsert (window.recently_report_buttons, b)
			end
			
			history_Background:Hide()
			separador:Hide()
			window.last_reported_label:Hide()

		--> scritps
		
			local flashTexture = window:CreateTexture (nil, "background") 
			flashTexture:SetColorTexture (1, 1, 1)
			flashTexture:SetAllPoints()
			
			local onShowAnimation = DetailsFramework:CreateAnimationHub (flashTexture, function() flashTexture:Show() end, function() flashTexture:Hide() end)
			DetailsFramework:CreateAnimation (onShowAnimation, "ALPHA", 1, .2, 0, .10)
			DetailsFramework:CreateAnimation (onShowAnimation, "ALPHA", 2, .2, .10, 0)
		
			window:SetScript ("OnShow", function (self)
				local dropdown = window.select.MyObject
				local where = _detalhes.report_where
				
				local list = window.dropdown_func()
				local found
				
				onShowAnimation:Play()
				
				for index, option in ipairs (list) do
					if (option.value == where) then
						dropdown:Select (where)
						found = true
						break
					end
				end
				
				if (not found) then
					if (_IsInRaid()) then
						dropdown:Select ("RAID")
						_detalhes.report_where = "RAID"
						
					elseif (GetNumSubgroupMembers() > 0) then
						dropdown:Select ("PARTY")
						_detalhes.report_where = "PARTY"
						
					elseif (_IsInGuild()) then
						dropdown:Select ("GUILD")
						_detalhes.report_where = "GUILD"
						
					else
						dropdown:Select ("SAY")
						_detalhes.report_where = "SAY"
					end
				end
				
				window:RefreshRecentlyReported()
				
			end)

			window:SetScript ("OnHide", function (self)
				_detalhes.janela_report.ativa = false
				_detalhes.last_report_id = nil
			end)
	
		--> close button
		window.fechar = CreateFrame ("Button", nil, window, "UIPanelCloseButton")
		window.fechar:SetScript ("OnClick", function()
			gump:Fade (window, 1)
			_detalhes.janela_report.ativa = false
		end)	

		--> title
		window.title = window:CreateFontString (nil, "OVERLAY", "GameFontHighlightLeft")
		window.title:SetText (Loc ["STRING_REPORTFRAME_WINDOW_TITLE"])

		seta_scripts (window)
		cria_drop_down (window)
		cria_slider (window)
		cria_wisper_field (window)
		cria_check_buttons (window)

		window.enviar = _CreateFrame ("Button", nil, window, "OptionsButtonTemplate,BackdropTemplate")
		window.enviar:SetPoint ("topleft", window.editbox, "topleft", 61, -19)
		window.enviar:SetWidth (60)
		window.enviar:SetHeight (15)
		window.enviar:SetText (Loc ["STRING_REPORTFRAME_SEND"])

		gump:Fade (window, 1)
		gump:CreateFlashAnimation (window)
		
		--apply the current skin
		_detalhes:ApplyRPSkin()
		
		return window
		
	end
	
	function _detalhes:InstallRPSkin (skin_name, func)
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end
	
		if (not skin_name) then
			return false -- sem nome
		elseif (DetailsReportWindow.skins [skin_name]) then
			return false -- ja existe
		end
		
		DetailsReportWindow.skins [skin_name] = func
		return true
	end
	
	function _detalhes:ApplyRPSkin (skin_name)
	
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end
		
		if (not skin_name) then
			skin_name = _detalhes.player_details_window.skin
			if (not DetailsReportWindow.skins [skin_name]) then
				skin_name = "ElvUI"
			end
		end
	
		local skin = DetailsReportWindow.skins [skin_name]
		if (skin) then
		
			for _, widget in ipairs (DetailsReportWindow.all_widgets) do
				widget:Hide()
			end
		
			local successful, errortext = pcall (skin)
			if (not successful) then
				_detalhes:Msg ("error occurred on report window skin call():", errortext)
				pcall (DetailsReportWindow.skins["ElvUI"])
			end
		end
	end	
