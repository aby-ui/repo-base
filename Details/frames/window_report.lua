
local Loc = LibStub("AceLocale-3.0"):GetLocale("Details")

local Details = _G._detalhes
local gump = Details.gump
local _

--details API functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	function Details:FastReportWindow(window)
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end

		local instance = Details:GetInstance(window)
		if (instance) then
			if (instance.atributo == 1) then
				Details.report_lines = 14

			elseif (instance.atributo == 2) then
				Details.report_lines = 6

			else
				Details.report_lines = max(10, instance.rows_fit_in_window)
			end

			if (IsInRaid()) then
				Details.report_where = "RAID"

			elseif (GetNumSubgroupMembers() > 0) then
				Details.report_where = "PARTY"

			else
				Details.report_where = "SAY"
			end

			instance:monta_relatorio()
		else
			Details:Msg(Loc ["STRING_WINDOW_NOTFOUND"])
		end
	end

	function Details.ReportFromLatest(_, _, index)
		local reportTable = Details.latest_report_table[index]
		if (reportTable) then
			if (not DetailsReportWindow) then
				gump:CriaJanelaReport()
				DetailsReportWindow:Hide()
			end

			local id, attribute, subattribute, amt, report_where = unpack(reportTable)
			local instance = Details:GetInstance(id)
			Details.report_lines = amt
			Details.report_where = report_where

			local cattribute, csubattribute = instance:GetDisplay()
			instance:SetDisplay(nil, attribute, subattribute)

			instance:monta_relatorio()
			instance:SetDisplay(nil, cattribute, csubattribute)
			GameCooltip:Hide()
		end
	end

	function Details:SendReportLines(lines)
		if (type(lines) == "string") then
			lines = {lines}
		end
		return Details:envia_relatorio(lines, true)
	end

	function Details:SendReportWindow(func, current, inverse, slider)
		if (type(func) ~= "function") then
			return
		end

		if (not Details.janela_report) then
			Details.janela_report = gump:CriaJanelaReport()
		end

		if (current) then
			_G["Details_Report_CB_1"]:Enable()
			_G["Details_Report_CB_1Text"]:SetTextColor(1, 1, 1, 1)
		else
			_G["Details_Report_CB_1"]:Disable()
			_G["Details_Report_CB_1Text"]:SetTextColor(.5, .5, .5, 1)
		end

		if (inverse) then
			_G["Details_Report_CB_2"]:Enable()
			_G["Details_Report_CB_2Text"]:SetTextColor(1, 1, 1, 1)
		else
			_G["Details_Report_CB_2"]:Disable()
			_G["Details_Report_CB_2Text"]:SetTextColor(.5, .5, .5, 1)
		end

		if (slider) then
			Details.janela_report.slider:Enable()
			Details.janela_report.slider.lockTexture:Hide()
			Details.janela_report.slider.amt:Show()
		else
			Details.janela_report.slider:Disable()
			Details.janela_report.slider.lockTexture:Show()
			Details.janela_report.slider.amt:Hide()
		end

		if (Details.janela_report.ativa) then
			Details.janela_report:Flash(0.2, 0.2, 0.4, true, 0, 0, "NONE")
		end

		Details.janela_report.ativa = true
		Details.janela_report.enviar:SetScript("OnClick", function() func(_G["Details_Report_CB_1"]:GetChecked(), _G["Details_Report_CB_2"]:GetChecked(), Details.report_lines) end)

		Details.FadeHandler.Fader(Details.janela_report, 0)
		return true
	end

	function Details:SendReportTextWindow(lines)
		if (not Details.copypasteframe) then
			Details.copypasteframe = CreateFrame("frame", "DetailsCopyPasteFrame2", UIParent, "BackdropTemplate")
			Details.copypasteframe:SetFrameStrata("TOOLTIP")
			Details.copypasteframe:SetPoint("CENTER", UIParent, "CENTER", 0, 50)
			tinsert(UISpecialFrames, "DetailsCopyPasteFrame2")
			Details.copypasteframe:SetSize(400, 400)
			Details.copypasteframe:Hide()

			DetailsFramework:ApplyStandardBackdrop(Details.copypasteframe)
			DetailsFramework:CreateTitleBar(Details.copypasteframe, "Export Text")

			local editBox = CreateFrame("editbox", nil, Details.copypasteframe)
			editBox:SetPoint("topleft", Details.copypasteframe, "topleft", 2, -26)
			editBox:SetPoint("bottomright", Details.copypasteframe, "bottomright", -2, 2)
			editBox:SetAutoFocus(false)
			editBox:SetMultiLine(true)
			editBox:SetFontObject("GameFontHighlightSmall")

			editBox:SetScript("OnEditFocusGained", function() editBox:HighlightText() end)
			editBox:SetScript("OnEditFocusLost", function() Details.copypasteframe:Hide() end)
			editBox:SetScript("OnEscapePressed", function() editBox:SetFocus(false); Details.copypasteframe:Hide() end)
			editBox:SetScript("OnChar", function() editBox:SetFocus(false); Details.copypasteframe:Hide() end)

			Details.copypasteframe.EditBox = editBox
		end

		local reportString = ""
		for _, line in ipairs(lines) do
			reportString = reportString .. line .. "\n"
		end

		Details.copypasteframe:Show()
		Details.copypasteframe.EditBox:SetText(reportString)
		Details.copypasteframe.EditBox:HighlightText()
		Details.copypasteframe.EditBox:SetFocus(true)
	end

--internal details report functions -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function Details:Reportar(param2, options, arg3, id)
		GameCooltip2:Hide()

		if (not Details.janela_report) then
			Details.janela_report = gump:CriaJanelaReport()
		end

		if (options and options.meu_id) then
			self = options
		end

		if (type(param2) == "string") then
			id = param2
		end

		if (Details.last_report_id and id and Details.last_report_id == id) then
			Details.last_report_id = nil
			Details.janela_report.fechar:Click()
			return
		end

		Details.last_report_id = id

		if (options and options._no_current) then
			_G["Details_Report_CB_1"]:Disable()
			_G["Details_Report_CB_1Text"]:SetTextColor(.5, .5, .5, 1)

		else
			_G["Details_Report_CB_1"]:Enable()
			_G["Details_Report_CB_1Text"]:SetTextColor(1, 1, 1, 1)
		end

		if (options and options._no_inverse) then
			_G["Details_Report_CB_2"]:Disable()
			_G["Details_Report_CB_2Text"]:SetTextColor(.5, .5, .5, 1)
		else
			_G["Details_Report_CB_2"]:Enable()
			_G["Details_Report_CB_2Text"]:SetTextColor(1, 1, 1, 1)
		end

		Details.janela_report.slider:Enable()
		Details.janela_report.slider.lockTexture:Hide()
		Details.janela_report.slider.amt:Show()

		if (options) then
			Details.janela_report.enviar:SetScript("OnClick", function() self:monta_relatorio(param2, options._custom) end)
		else
			Details.janela_report.enviar:SetScript("OnClick", function() self:monta_relatorio(param2) end)
		end

		if (Details.janela_report.ativa) then 
			Details.janela_report:Flash(0.2, 0.2, 0.4, true, 0, 0, "NONE")
		end

		Details.janela_report.ativa = true
		Details.FadeHandler.Fader(Details.janela_report, 0)
	end

--build report frame gump -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--script
	local savepos = function(self)
		local xofs, yofs = self:GetCenter()
		local scale = self:GetEffectiveScale()
		local UIscale = UIParent:GetScale()
		xofs = xofs * scale - GetScreenWidth() * UIscale / 2
		yofs = yofs * scale - GetScreenHeight() * UIscale / 2
		local x = xofs / UIscale
		local y = yofs / UIscale
		Details.report_pos[1] = x
		Details.report_pos[2] = y
	end

	local restorepos = function(self)
		local x, y = Details.report_pos[1], Details.report_pos[2]
		local scale = self:GetEffectiveScale()
		local UIscale = UIParent:GetScale()
		x = x * UIscale / scale
		y = y * UIscale / scale
		self:ClearAllPoints()
		self:SetPoint("center", UIParent, "center", x, y)
	end

	local function setScripts(este_gump)
		--Janela
		este_gump:SetScript("OnMouseDown", function(self, botao)
			if (botao == "LeftButton") then
				self:StartMoving()
				self.isMoving = true

			elseif (botao == "RightButton") then
				if (self.isMoving) then
					self:StopMovingOrSizing()
					savepos(self)
					self.isMoving = false
				end
				self:Hide()
			end
		end)

		este_gump:SetScript("OnMouseUp", function(self)
			if (self.isMoving) then
				self:StopMovingOrSizing()
				savepos (self)
				self.isMoving = false
			end
		end)
	end

local iconsAndColors = {
	["PARTY"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {0.66, 0.65, 1}},
	["RAID"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {1, 0.49, 0}},
	["GUILD"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.98, 0.25}},
	["OFFICER"] = {label = Loc ["STRING_REPORTFRAME_OFFICERS"], icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.74, 0.25}},
	["WHISPER"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}},
	["SAY"] = {icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0390625, 0.203125, 0.09375, 0.375}, color = {1, 1, 1}},
	["COPY"] = {icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], coords = {0, 1, 0, 1}, color = {1, 1, 1}},
}

function Details.GetReportIconAndColor(reportWhere)
	local key = reportWhere:gsub((".*|"), "")
	return iconsAndColors[key]
end

local createDropdown = function(thisFrame)
	local iconsize = {16, 16}

	local baseChannels = {
		{Loc ["STRING_REPORTFRAME_PARTY"], "PARTY", function() return GetNumSubgroupMembers() > 0 end, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {0.66, 0.65, 1}}},
		{Loc ["STRING_REPORTFRAME_RAID"], "RAID", IsInRaid, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.53125, 0.7265625, 0.078125, 0.40625}, color = {1, 0.49, 0}}},
		{Loc ["STRING_REPORTFRAME_GUILD"], "GUILD", IsInGuild, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.98, 0.25}}},
		{Loc ["STRING_REPORTFRAME_OFFICERS"], "OFFICER", IsInGuild, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.8046875, 0.96875, 0.125, 0.390625}, color = {0.25, 0.74, 0.25}}},
		{Loc ["STRING_REPORTFRAME_WHISPER"], "WHISPER", nil, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}}, 
		{Loc ["STRING_REPORTFRAME_WHISPERTARGET"], "WHISPER2", nil, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0546875, 0.1953125, 0.625, 0.890625}, color = {1, 0.49, 1}}},
		{Loc ["STRING_REPORTFRAME_SAY"], "SAY", IsInInstance, {iconsize = iconsize, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], coords = {0.0390625, 0.203125, 0.09375, 0.375}, color = {1, 1, 1}}},
		{Loc ["STRING_REPORTFRAME_COPY"], "COPY", nil, {iconsize = iconsize, icon = [[Interface\Buttons\UI-GuildButton-PublicNote-Disabled]], coords = {0, 1, 0, 1}, color = {1, 1, 1}}},
	}
	local onClick = function(self, fixedParam, selectedOutput)
		Details.report_where = selectedOutput
	end

	local buildList = function()
		local reportChannelsTable = {}

		for index, channelInfo in ipairs(baseChannels) do
			if (not channelInfo[3] or channelInfo[3]()) then
				reportChannelsTable[#reportChannelsTable + 1] = {iconsize = channelInfo[4].iconsize, value = channelInfo[2], label = channelInfo[1], onclick = onClick, icon = channelInfo[4].icon, texcoord = channelInfo[4].coords, iconcolor = channelInfo[4].color}
			end
		end

		local channels = {GetChannelList()} --coloca o resultado em uma tabela .. {id1, canal1, id2, canal2}
		--09/august/2018: GetChannelList passed to return 3 values for each channel instead of 2

		for i = 1, #channels, 3 do --total de canais
			reportChannelsTable[#reportChannelsTable + 1] = {iconsize = iconsize, value = "CHANNEL|" .. channels[i+1], label = channels[i] .. ". " .. channels[i+1], onclick = onClick, icon = [[Interface\FriendsFrame\UI-Toast-ToastIcons]], texcoord = {0.3046875, 0.4453125, 0.109375, 0.390625}, iconcolor = {149/255, 112/255, 112/255}}
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
						reportChannelsTable[#reportChannelsTable + 1] = {iconsize = iconsize, value = "REALID|" .. accountInfo.bnetAccountID, label = bTagNoNumber, onclick = onClick, icon = [[Interface\FriendsFrame\Battlenet-Battleneticon]], texcoord = {0.125, 0.875, 0.125, 0.875}, iconcolor = {1, 1, 1}}
					end
				end
			end
		end

		return reportChannelsTable
	end

	thisFrame.dropdown_func = buildList

	local selectOutputChannel = gump:NewDropDown(thisFrame, _, "$parentOutputDropdown", "select", 185, 20, buildList, 1)
	selectOutputChannel:SetPoint("topleft", thisFrame, "topleft", 107, -55)
	thisFrame.select = selectOutputChannel.widget
	thisFrame.dropdown = selectOutputChannel

	function selectOutputChannel:CheckValid()
		local lastSelected = Details.report_where
		local checkFunc

		for i, channelTable in ipairs(baseChannels) do
			if (channelTable[2] == lastSelected) then
				checkFunc = channelTable[3]
				break
			end
		end

		if (checkFunc) then
			local isShown = checkFunc()
			if (isShown) then
				selectOutputChannel:Select(lastSelected)
			else
				if (IsInRaid()) then
					selectOutputChannel:Select("RAID")

				elseif (GetNumSubgroupMembers() > 0) then
					selectOutputChannel:Select("PARTY")

				elseif (IsInGuild()) then
					selectOutputChannel:Select("GUILD")

				else
					selectOutputChannel:Select("SAY")
				end
			end
		else
			selectOutputChannel:Select(lastSelected)
		end
	end
		selectOutputChannel:CheckValid()
	end

--slider
	local createSlider = function(thisFrame)
		thisFrame.linhas_amt = thisFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		thisFrame.linhas_amt:SetText(Loc ["STRING_REPORTFRAME_LINES"])
		thisFrame.linhas_amt:SetTextColor(.9, .9, .9, 1)
		thisFrame.linhas_amt:SetPoint("bottomleft", thisFrame, "bottomleft", 58, 12)
		Details:SetFontSize(thisFrame.linhas_amt, 10)

		local slider = CreateFrame("Slider", "Details_Report_Slider", thisFrame, "BackdropTemplate")
		thisFrame.slider = slider
		slider:SetPoint("bottomleft", thisFrame, "bottomleft", 58, -7)

		slider.thumb = slider:CreateTexture(nil, "artwork")
		slider.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
		slider.thumb:SetSize(30, 24)
		slider.thumb:SetAlpha(0.7)

		local lockTexture = slider:CreateTexture(nil, "overlay")
		lockTexture:SetPoint("center", slider.thumb, "center", -1, -1)
		lockTexture:SetTexture("Interface\\Buttons\\CancelButton-Up")
		lockTexture:SetWidth(29)
		lockTexture:SetHeight(24)
		lockTexture:Hide()
		slider.lockTexture = lockTexture

		slider:SetThumbTexture(slider.thumb)
		slider:SetOrientation("HORIZONTAL")
		slider:SetMinMaxValues(1.0, 25.0)
		slider:SetValueStep(1.0)
		slider:SetWidth(232)
		slider:SetHeight(20)

		local lastValue = Details.report_lines or 5
		slider:SetValue(floor(lastValue))

		slider.amt = slider:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
		local amt = slider:GetValue()
		if (amt < 10) then
			amt = "0" .. amt
		end

		slider.amt:SetText(amt)
		slider.amt:SetTextColor(.8, .8, .8, 1)
		slider.amt:SetPoint("center", slider.thumb, "center")

		slider:SetScript("OnValueChanged", function(self)
			local amt = math.floor(self:GetValue())
			Details.report_lines = amt
			if (amt < 10) then
				amt = "0" .. amt
			end
			self.amt:SetText(amt)
		end)

		slider:SetScript("OnEnter", function(self)
			slider.thumb:SetAlpha(1)
		end)

		slider:SetScript("OnLeave", function(self)
			slider.thumb:SetAlpha(0.7)
		end)
	end

--whisper taget field
	local  createWisperField = function(thisFrame)
		thisFrame.wisp_who = thisFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		thisFrame.wisp_who:SetText(Loc ["STRING_REPORTFRAME_WHISPER"] .. ":")
		thisFrame.wisp_who:SetTextColor(1, 1, 1, 1)
		thisFrame.wisp_who:SetPoint("topleft", thisFrame.select, "topleft", 14, -30)

		Details:SetFontSize(thisFrame.wisp_who, 10)

		--editbox
		local editbox = CreateFrame("EditBox", nil, thisFrame, "BackdropTemplate")
		thisFrame.editbox = editbox

		editbox:SetAutoFocus(false)
		editbox:SetFontObject("GameFontHighlightSmall")

		editbox:SetPoint("TOPLEFT", thisFrame.select, "TOPLEFT", 64, -28)

		editbox:SetHeight(14)
		editbox:SetWidth(120)
		editbox:SetJustifyH("center")
		editbox:EnableMouse(true)
		editbox:SetBackdrop({
			bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
			edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
			tile = true, edgeSize = 1, tileSize = 5,
			})
		editbox:SetBackdropColor(0, 0, 0, 0.0)
		editbox:SetBackdropBorderColor(0.0, 0.0, 0.0, 0.0)

		local lastValue = Details.report_to_who or ""
		editbox:SetText(lastValue)
		editbox.perdeu_foco = nil
		editbox.focus = false

		editbox:SetScript("OnEnterPressed", function()
			local texto = Details:trim(editbox:GetText())
			if (string.len(texto) > 0) then
				Details.report_to_who = texto
				editbox:AddHistoryLine(texto)
				editbox:SetText(texto)
			else
				Details.report_to_who = ""
				editbox:SetText("")
			end

			editbox.perdeu_foco = true --isso aqui pra quando estiver editando e clicar em outra caixa
			editbox:ClearFocus()
		end)

		editbox:SetScript("OnEscapePressed", function()
			editbox:SetText("")
			Details.report_to_who = ""
			editbox.perdeu_foco = true
			editbox:ClearFocus()
		end)

		editbox:SetScript("OnEnter", function()
			editbox.mouse_over = true
			if (editbox:GetText() == "" and not editbox.focus) then
				editbox:SetText(Loc ["STRING_REPORTFRAME_INSERTNAME"])
			end
		end)

		editbox:SetScript("OnLeave", function()
			editbox.mouse_over = false
			if (not editbox:HasFocus()) then
				if (editbox:GetText() == Loc ["STRING_REPORTFRAME_INSERTNAME"]) then
					editbox:SetText("")
				end
			end
		end)

		editbox:SetScript("OnEditFocusGained", function()
			if (editbox:GetText() == Loc ["STRING_REPORTFRAME_INSERTNAME"]) then
				editbox:SetText("")
			end

			if (editbox:GetText() ~= "") then
				editbox:HighlightText(0, editbox:GetNumLetters())
			end

			editbox.focus = true
		end)

		editbox:SetScript("OnEditFocusLost", function()
			if (editbox.perdeu_foco == nil) then
				local text = Details:trim(editbox:GetText())

				if (string.len(text) > 0) then
					Details.report_to_who = text
				else
					Details.report_to_who = ""
					editbox:SetText("")
				end
			else
				editbox.perdeu_foco = nil
			end

			editbox.focus = false
		end)
	end

--both check buttons
	local createCheckButtons = function(thisFrame)
		local checkbox = CreateFrame("CheckButton", "Details_Report_CB_1", thisFrame, "ChatConfigCheckButtonTemplate,BackdropTemplate")
		checkbox:SetPoint("topleft", thisFrame.wisp_who, "bottomleft", -25, -4)
		_G[checkbox:GetName().."Text"]:SetText(Loc ["STRING_REPORTFRAME_CURRENT"])
		Details:SetFontSize(_G[checkbox:GetName().."Text"], 10)
		checkbox.tooltip = Loc ["STRING_REPORTFRAME_CURRENTINFO"]
		checkbox:SetHitRectInsets(0, -35, 0, 0)

		local checkbox2 = CreateFrame("CheckButton", "Details_Report_CB_2", thisFrame, "ChatConfigCheckButtonTemplate,BackdropTemplate")
		checkbox2:SetPoint("topleft", thisFrame.wisp_who, "bottomleft", 35, -4)
		_G[checkbox2:GetName().."Text"]:SetText(Loc ["STRING_REPORTFRAME_REVERT"])
		Details:SetFontSize(_G[checkbox2:GetName().."Text"], 10)
		checkbox2.tooltip = Loc ["STRING_REPORTFRAME_REVERTINFO"]
		checkbox2:SetHitRectInsets(0, -35, 0, 0)
	end

--frame creation function
	local defaultSkin = function()
		local window = DetailsReportWindow
		local anchorX = 10

		local recentReportButtonOnEnter = function(self)
			self:SetBackdropColor(0.4, 0.4, 0.4, 0.6)
			self.icon:SetBlendMode("ADD")
			Details:SetFontColor(self.text, "yellow")
		end

		local recentReportButtonOnLeave = function(self)
			self:SetBackdropColor(0, 0, 0, 0.3)
			self.icon:SetBlendMode("BLEND")
			Details:SetFontColor(self.text, "white")
		end

		window.last_reported_label:SetPoint("topleft", window, "topleft", 5, -28)
		gump:SetFontSize(window.last_reported_label, 10)

		for i = 1, 9 do --window.max_last_buttons
			local recentReportButton = window.recently_report_buttons[i]

			recentReportButton:SetSize(150, 16)
			recentReportButton:SetPoint("topleft", window, "topleft", 5, -28 + (i * 17 * -1))
			recentReportButton:Show()
			recentReportButton:SetBackdrop({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 16,
			insets = {left = 0, right = 0, top = 0, bottom = 0}})
			recentReportButton:SetBackdropColor(0, 0, 0, 0.3)
			recentReportButton.text:SetTextColor(1, 1, 1, 1)
			Details:SetFontSize(recentReportButton.text, 9)

			recentReportButton:SetScript("OnEnter", recentReportButtonOnEnter)
			recentReportButton:SetScript("OnLeave", recentReportButtonOnLeave)
		end

		window.fechar:SetWidth(20)
		window.fechar:SetHeight(20)
		window.fechar:SetPoint("TOPRIGHT", window, "TOPRIGHT", 0, -3)
		window.fechar:Show()
		window.fechar:GetNormalTexture():SetDesaturated(true)

		local recentReportButton = window.recently_report_buttons[10]
		recentReportButton:Hide()

		window.dropdown:ClearAllPoints()
		window.dropdown:SetWidth(155)
		window.dropdown:SetPoint("topleft", window, "topleft", anchorX, -30)
		window.dropdown:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.dropdown:SetBackdropBorderColor(0, 0, 0, 0.5)
		window.dropdown:SetBackdropColor(0, 0, 0, 0.1)

		window.wisp_who:ClearAllPoints()
		window.editbox:ClearAllPoints()
		window.wisp_who:SetPoint("topleft", window.dropdown.widget, "bottomleft", 0, -10)
		window.editbox:SetPoint("topleft", window.wisp_who, "bottomleft", 0, -3)
		window.editbox:SetWidth(155)
		window.editbox:SetHeight(20)
		window.editbox:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.editbox:SetBackdropBorderColor(0, 0, 0, 0.5)
		window.editbox:SetBackdropColor(0, 0, 0, 0.3)

		window.linhas_amt:ClearAllPoints()
		window.linhas_amt:SetPoint("topleft", window.editbox, "bottomleft", 0, -10)
		window.slider:ClearAllPoints()
		window.slider:SetWidth(155)
		window.slider:SetPoint("topleft", window.linhas_amt, "bottomleft", 0, -3)
		window.slider:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.slider:SetBackdropBorderColor(0, 0, 0, 0.5)
		window.slider:SetBackdropColor(0, 0, 0, 0.3)

		window.slider.thumb:SetTexture([[Interface\AddOns\Details\images\icons2]])
		window.slider.thumb:SetTexCoord(482/512, 492/512, 104/512, 120/512)
		window.slider.thumb:SetSize(16, 16)
		window.slider.thumb:SetVertexColor(0.6, 0.6, 0.6, 0.95)

		Details_Report_CB_1:Hide()
		local reverse_checkbox = Details_Report_CB_2
		reverse_checkbox:Show()
		reverse_checkbox:ClearAllPoints()
		reverse_checkbox:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		reverse_checkbox:SetBackdropBorderColor(0, 0, 0, 0.5)
		reverse_checkbox:SetBackdropColor(0, 0, 0, 0.3)
		reverse_checkbox:SetPoint("topleft", window.slider, "bottomleft", 0, -8)
		reverse_checkbox:SetSize(14, 14)
		reverse_checkbox:SetNormalTexture("")
		reverse_checkbox:SetPushedTexture("")
		reverse_checkbox:SetHighlightTexture("")
		_G[reverse_checkbox:GetName().."Text"]:ClearAllPoints()
		_G[reverse_checkbox:GetName().."Text"]:SetPoint("left", reverse_checkbox, "right", 2, 0)

		window.enviar:ClearAllPoints()
		window.enviar:SetPoint("bottom", window, "bottom", 0, 10)
		window.enviar:SetBackdrop({bgFile = [[Interface\DialogFrame\UI-DialogBox-Background-Dark]], edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, tile=true,
		tileSize = 64, insets = {left = 0, right = 0, top = 0, bottom = 0}})
		window.enviar:SetBackdropBorderColor(0, 0, 0, 0.5)
		window.enviar:SetBackdropColor(0, 0, 0, 0.3)
		window.enviar:SetSize(342/2 - 15, 20)

		window:SetWidth(342/2 + 5)
		window:SetHeight(195)
		window:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1})
		window:SetBackdropColor(1, 1, 1, 1)
		window:SetBackdropBorderColor(0, 0, 0, 1)

		if (not window.widgets) then
			window.widgets = {}

			local titlebar = CreateFrame("frame", window:GetName() .. "TitleBar", window, "BackdropTemplate")
			titlebar:SetPoint("topleft", window, "topleft", 2, -3)
			titlebar:SetPoint("topright", window, "topright", -2, -3)
			titlebar:SetHeight(20)
			titlebar:SetBackdrop({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
			titlebar:SetBackdropColor(.5, .5, .5, 1)
			titlebar:SetBackdropBorderColor(0, 0, 0, 1)

			local bg1 = window:CreateTexture(nil, "background")
			bg1:SetTexture([[Interface\AddOns\Details\images\background]], true)
			bg1:SetAlpha(0.7)
			bg1:SetVertexColor(0.27, 0.27, 0.27)
			bg1:SetVertTile(true)
			bg1:SetHorizTile(true)
			bg1:SetAllPoints()

			tinsert(window.all_widgets, bg1)
			tinsert(window.widgets, bg1)
			tinsert(window.all_widgets, titlebar)
			tinsert(window.widgets, titlebar)
		end

		window.title:ClearAllPoints()
		window.title:SetPoint("center", window, "center")
		window.title:SetPoint("top", window, "top", 0, -7)
		window.title:SetParent(_G[window:GetName() .. "TitleBar"])
		window.title:SetTextColor(.8, .8, .8, 1)
		window.title:Show()

		window:SetClampedToScreen(true)

		for _, widget in ipairs(window.widgets) do
			widget:Show()
		end

	end

	function Details:UpdateRecentlyReported()
		DetailsReportWindow:RefreshRecentlyReported()
	end

	function Details:DelayUpdateReportWindowRecentlyReported()
		if (DetailsReportWindow) then
			Details:ScheduleTimer("UpdateRecentlyReported", 0.5)
		end
	end

	function Details:CheckLastReportsIntegrity()
		local lastReports = Details.latest_report_table or {}
		if (#lastReports > 0) then
			local i = 1
			for index = #lastReports, 1, -1 do
				local report = lastReports[index]
				local instance_id, atributo, sub_atributo, amt, where, custom_name = unpack(report)
				if (atributo == 5) then
					if (not custom_name) then
						tremove(lastReports, index)
					else
						local found
						for _, custom in ipairs(Details.custom) do
							if (custom.name == custom_name) then
								found = true
								break
							end
						end
						if (not found) then
							tremove(lastReports, index)
						end
					end
				end
			end
		end
	end

	function gump:CriaJanelaReport()
		--window
		local window = CreateFrame("Frame", "DetailsReportWindow", UIParent, "BackdropTemplate")
		tinsert(UISpecialFrames, "DetailsReportWindow")
		window:SetPoint("CENTER", UIParent, "CENTER")
		window:SetFrameStrata("DIALOG")
		window.skins = {}
		window.all_widgets = {}
		window.max_last_buttons = 10

		window:EnableMouse(true)
		window:SetResizable(false)
		window:SetMovable(true)
		restorepos(window)

		Details.janela_report = window
		Details:InstallRPSkin("defaultSkin", defaultSkin)

		--recently reported:
		window.recently_report_buttons = {}

		local historyBlockBackground = window:CreateTexture(nil, "background")
		historyBlockBackground:SetColorTexture(0, 0, 0, .3)
		historyBlockBackground:SetSize(160, 158)
		historyBlockBackground:SetPoint("topleft", window, "topleft", 3, -25)

		local separator = window:CreateTexture(nil, "border")
		separator:SetColorTexture(0, 0, 0, .6)
		separator:SetSize(2, 158)
		separator:SetPoint("topleft", historyBlockBackground, "topright", 0, 0)

		function window:RefreshRecentlyReported()
			for i = 1, window.max_last_buttons do
				local b = window.recently_report_buttons[i]
				b.icon:SetTexture("")
				b:Hide()
			end

			Details:CheckLastReportsIntegrity()

			local lastReports = Details.latest_report_table
			if (#lastReports > 0) then
				local i = 1
				for index = 1, min(#lastReports, 8) do
					local recentReportButton = window.recently_report_buttons[i]
					local report = lastReports[index]
					local instanceId, attribute, subAttribute, amt, reportWhere = unpack(report)
					local name = Details:GetSubAttributeName(attribute, subAttribute)
					local artwork =  Details.GetReportIconAndColor(reportWhere)

					recentReportButton.text:SetText(name .. " (#" .. amt .. ")")
					recentReportButton.index = index

					if (artwork) then
						recentReportButton.icon:SetTexture(artwork.icon)
						recentReportButton.icon:SetTexCoord(artwork.coords[1], artwork.coords[2], artwork.coords[3], artwork.coords[4])
						recentReportButton.icon:SetVertexColor(unpack(artwork.color or {}))
					end

					recentReportButton:Hide()
					i = i + 1
				end
			end
		end

		local recentlyButtonOnClick = function(self)
			if (self.index) then
				return Details.ReportFromLatest(_, _, self.index)
			end
		end

		local lastReportedLabel = window:CreateFontString(nil, "overlay", "GameFontNormal")
		window.last_reported_label = lastReportedLabel
		window.last_reported_label:SetText(Loc ["STRING_REPORTHISTORY"] .. ":") --this string could be removed from localization

		for i = 1, window.max_last_buttons do
			local button = CreateFrame("button", "DetailsReportWindowRRB" .. i, window, "BackdropTemplate")
			local icon = button:CreateTexture(nil, "overlay")
			icon:SetPoint("left", button, "left")
			icon:SetSize(16, 16)

			local text = button:CreateFontString(nil, "overlay", "GameFontNormal")
			text:SetPoint("left", icon, "right", 2, 0)

			button.icon = icon
			button.text = text
			button:SetScript("OnClick", recentlyButtonOnClick)
			tinsert(window.recently_report_buttons, button)
		end

		historyBlockBackground:Hide()
		separator:Hide()
		window.last_reported_label:Hide()

	--scritps

		local flashTexture = window:CreateTexture(nil, "background")
		flashTexture:SetColorTexture(1, 1, 1)
		flashTexture:SetAllPoints()

		local onShowAnimation = DetailsFramework:CreateAnimationHub(flashTexture, function() flashTexture:Show() end, function() flashTexture:Hide() end)
		DetailsFramework:CreateAnimation(onShowAnimation, "ALPHA", 1, .2, 0, .10)
		DetailsFramework:CreateAnimation(onShowAnimation, "ALPHA", 2, .2, .10, 0)

		window:SetScript("OnShow", function(self)
			local dropdown = window.select.MyObject
			local where = Details.report_where

			local list = window.dropdown_func()
			local found

			onShowAnimation:Play()

			for index, option in ipairs(list) do
				if (option.value == where) then
					dropdown:Select(where)
					found = true
					break
				end
			end

			if (not found) then
				if (IsInRaid()) then
					dropdown:Select("RAID")
					Details.report_where = "RAID"

				elseif (GetNumSubgroupMembers() > 0) then
					dropdown:Select("PARTY")
					Details.report_where = "PARTY"

				elseif (IsInGuild()) then
					dropdown:Select("GUILD")
					Details.report_where = "GUILD"

				else
					dropdown:Select("SAY")
					Details.report_where = "SAY"
				end
			end

			window:RefreshRecentlyReported()
		end)

		window:SetScript("OnHide", function(self)
			Details.janela_report.ativa = false
			Details.last_report_id = nil
		end)

		--close button
		window.fechar = CreateFrame("Button", nil, window, "UIPanelCloseButton")
		window.fechar:SetScript("OnClick", function()
			Details.FadeHandler.Fader(window, 1)
			Details.janela_report.ativa = false
		end)

		--title
		window.title = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightLeft")
		window.title:SetText(Loc ["STRING_REPORTFRAME_WINDOW_TITLE"])

		setScripts(window)
		createDropdown(window)
		createSlider(window)
		createWisperField(window)
		createCheckButtons(window)

		window.enviar = CreateFrame("Button", nil, window, "BackdropTemplate")
		window.enviar:SetPoint("topleft", window.editbox, "topleft", 61, -19)
		window.enviar:SetWidth(60)
		window.enviar:SetHeight(15)
		DetailsFramework:ApplyStandardBackdrop(window.enviar)

		local sendButtonLabel = window.enviar:CreateFontString(nil, "overlay", "GameFontNormal")
		sendButtonLabel:SetPoint("center", 0, 0)
		sendButtonLabel:SetText(Loc ["STRING_REPORTFRAME_SEND"])

		Details.FadeHandler.Fader(window, 1)
		gump:CreateFlashAnimation(window)

		--apply the current skin
		Details:ApplyRPSkin()

		return window
	end

	function Details:InstallRPSkin(skinName, func)
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end

		if (not skinName) then
			return false
		elseif (DetailsReportWindow.skins[skinName]) then
			return false
		end

		DetailsReportWindow.skins[skinName] = func
		return true
	end

	function Details:ApplyRPSkin(skinName)
		if (not DetailsReportWindow) then
			gump:CriaJanelaReport()
			DetailsReportWindow:Hide()
		end

		if (not skinName) then
			skinName = Details.player_details_window.skin
			if (not DetailsReportWindow.skins[skinName]) then
				skinName = "defaultSkin"
			end
		end

		local skin = DetailsReportWindow.skins[skinName]
		if (skin) then
			for _, widget in ipairs(DetailsReportWindow.all_widgets) do
				widget:Hide()
			end

			local successful, errortext = pcall(skin)
			if (not successful) then
				Details:Msg("error occurred on report window skin call():", errortext)
				pcall(DetailsReportWindow.skins["defaultSkin"])
			end
		end
	end
