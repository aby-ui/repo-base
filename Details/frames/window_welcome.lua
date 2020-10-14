local _detalhes = 		_G._detalhes
local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )
local SharedMedia = LibStub:GetLibrary("LibSharedMedia-3.0")

local g =	_detalhes.gump
local _
function _detalhes:OpenWelcomeWindow()

	GameCooltip:Close()
	local window = _G.DetailsWelcomeWindow

	if (not window) then
	
		--on first run, sincronize with guild
		_detalhes.storage:DBGuildSync()
	
		local index = 1
		local pages = {}
		
		local instance = _detalhes.tabela_instancias [1]
		
		window = _detalhes:CreateWelcomePanel ("DetailsWelcomeWindow", UIParent)
		window:SetPoint ("center", UIParent, "center", -200, 0)
		window:SetBackdropColor (0, 0, 0, 0.75)
		window:SetWidth (612)
		window:SetHeight (315)
		window:SetMovable (true)
		window:SetScript ("OnMouseDown", function() window:StartMoving() end)
		window:SetScript ("OnMouseUp", function() window:StopMovingOrSizing() end)
		window:SetScript ("OnHide", function()
			_detalhes.tabela_historico:resetar()
			
			if (DetailsFramework.IsClassicWow()) then
				local new_instance = Details:GetWindow (1)
				new_instance.row_info.use_spec_icons = false
				new_instance.row_info.icon_file = [[Interface\AddOns\Details\images\classes_small]]
				new_instance:SetBarSpecIconSettings (false)
			end
			
		end)

		local rodape_bg = window:CreateTexture (nil, "artwork")
		rodape_bg:SetPoint ("bottomleft", window, "bottomleft", 11, 12)
		rodape_bg:SetPoint ("bottomright", window, "bottomright", -11, 12)
		rodape_bg:SetTexture ([[Interface\Tooltips\UI-Tooltip-Background]])
		rodape_bg:SetHeight (25)
		rodape_bg:SetVertexColor (0, 0, 0, 1)
		
		local logotipo = window:CreateTexture (nil, "overlay")
		logotipo:SetPoint ("topleft", window, "topleft", 16, -20)
		logotipo:SetTexture ([[Interface\Addons\Details\images\logotipo]])
		logotipo:SetTexCoord (0.07421875, 0.73828125, 0.51953125, 0.890625)
		logotipo:SetWidth (186)
		logotipo:SetHeight (50)
		
		local cancel = CreateFrame ("Button", nil, window)
		cancel:SetWidth (22)
		cancel:SetHeight (22)
		cancel:SetPoint ("bottomleft", window, "bottomleft", 12, 14)
		cancel:SetFrameLevel (window:GetFrameLevel()+1)
		cancel:SetPushedTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Down]])
		cancel:SetHighlightTexture ([[Interface\Buttons\UI-GROUPLOOT-PASS-HIGHLIGHT]])
		cancel:SetNormalTexture ([[Interface\Buttons\UI-GroupLoot-Pass-Up]])
		cancel:SetScript ("OnClick", function() window:Hide() end)
		cancel:GetNormalTexture():SetDesaturated (true)
		cancel:Disable()
		
		local cancelText = cancel:CreateFontString (nil, "overlay", "GameFontNormal")
		cancelText:SetTextColor (1, 1, 1)
		cancelText:SetPoint ("left", cancel, "right", 2, 0)
		cancelText:SetText (Loc ["STRING_WELCOME_69"])
		
		local forward = CreateFrame ("button", nil, window)
		forward:SetWidth (26)
		forward:SetHeight (26)
		forward:SetPoint ("bottomright", window, "bottomright", -14, 13)
		forward:SetFrameLevel (window:GetFrameLevel()+1)
		forward:SetPushedTexture ([[Interface\Buttons\UI-SpellbookIcon-NextPage-Down]])
		forward:SetHighlightTexture ([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
		forward:SetNormalTexture ([[Interface\Buttons\UI-SpellbookIcon-NextPage-Up]])
		forward:SetDisabledTexture ([[Interface\Buttons\UI-SpellbookIcon-NextPage-Disabled]])
		
		local backward = CreateFrame ("button", nil, window)
		backward:SetWidth (26)
		backward:SetHeight (26)
		backward:SetPoint ("bottomright", window, "bottomright", -38, 13)
		backward:SetPushedTexture ([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Down]])
		backward:SetHighlightTexture ([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
		backward:SetNormalTexture ([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Up]])
		backward:SetDisabledTexture ([[Interface\Buttons\UI-SpellbookIcon-PrevPage-Disabled]])
		
		forward:SetScript ("OnClick", function()
			if (index < #pages) then
				for _, widget in ipairs (pages [index]) do 
					widget:Hide()
				end
				
				index = index + 1
				
				for _, widget in ipairs (pages [index]) do 
					widget:Show()
				end
				
				if (index == #pages) then
					forward:Disable()
				end
				backward:Enable()
			end
		end)
		
		backward:SetScript ("OnClick", function()
			if (index > 1) then
				for _, widget in ipairs (pages [index]) do 
					widget:Hide()
				end
				
				index = index - 1
				
				for _, widget in ipairs (pages [index]) do 
					widget:Show()
				end
				
				if (index == 1) then
					backward:Disable()
				end
				forward:Enable()
			end
		end)

		function _detalhes:WelcomeSetLoc()
			local instance = _detalhes.tabela_instancias [1]
			instance.baseframe:ClearAllPoints()
			instance.baseframe:SetPoint ("left", DetailsWelcomeWindow, "right", 10, 0)
			DetailsWelcomeWindow.SetLocTimer = nil
		end
		DetailsWelcomeWindow.SetLocTimer = _detalhes:ScheduleTimer ("WelcomeSetLoc", 12)

--/script local f=CreateFrame("frame");local g=false;f:SetScript("OnUpdate",function(s,e)if not g then local r=math.random for i=1,2500000 do local a=r(1,1000000);a=a+1 end g=true else print(string.format("cpu: %.3f",e));f:SetScript("OnUpdate",nil)end end)
	
	function _detalhes:CalcCpuPower()
		local f = CreateFrame ("frame")
		local got = false
		
		f:SetScript ("OnUpdate", function (self, elapsed)
			if (not got and not InCombatLockdown()) then
				local r = math.random
				for i = 1, 2500000 do 
					local a = r (1, 1000000)
					a = a + 1
				end
				got = true
				
			elseif (not InCombatLockdown()) then
				--print ("process time:", elapsed)
				
				if (elapsed < 0.295) then
					_detalhes.use_row_animations = true
					_detalhes.update_speed = 0.30
				
				elseif (elapsed < 0.375) then
					_detalhes.use_row_animations = true
					_detalhes.update_speed = 0.40
					
				elseif (elapsed < 0.475) then
					_detalhes.use_row_animations = true
					_detalhes.update_speed = 0.5
					
				elseif (elapsed < 0.525) then
					_detalhes.update_speed = 0.5
					
				end
			
				--> overriting the results
				_detalhes.update_speed = 0.3
				_detalhes.use_row_animations = true
				
				DetailsWelcomeWindowSliderUpdateSpeed.MyObject:SetValue (_detalhes.update_speed)
				DetailsWelcomeWindowAnimateSlider.MyObject:SetValue (_detalhes.use_row_animations)

				f:SetScript ("OnUpdate", nil)
			end
		end)
	end
	
	--deprecated
	--_detalhes:ScheduleTimer ("CalcCpuPower", 10)

	--detect ElvUI
	--[=[ --deprecated
	local ElvUI = _G.ElvUI
	if (ElvUI) then
		--active elvui skin
		local instance = _detalhes.tabela_instancias [1]
		if (instance and instance.ativa) then
			if (instance.skin ~= "ElvUI Frame Style") then
				instance:ChangeSkin ("ElvUI Frame Style")
			end
		end

		--save standard
		local savedObject = {}
		for key, value in pairs (instance) do
			if (_detalhes.instance_defaults [key] ~= nil) then	
				if (type (value) == "table") then
					savedObject [key] = table_deepcopy (value)
				else
					savedObject [key] = value
				end
			end
		end
		_detalhes.standard_skin = savedObject
		
		_detalhes:ApplyPDWSkin ("ElvUI")
		--_detalhes:SetTooltipBackdrop ("Details BarBorder 3", 14, {0, 0, 0, 1})
	end
	--]=]
	
-- frame alert
	
	local frame_alert = CreateFrame ("frame", nil, window)
	frame_alert:SetPoint ("topright", window)
	function _detalhes:StopPlayStretchAlert()
		frame_alert.alert.animIn:Stop()
		frame_alert.alert.animOut:Play()
		_detalhes.stopwelcomealert = nil
	end
	frame_alert.alert = CreateFrame ("frame", "DetailsWelcomeWindowAlert", UIParent, "ActionBarButtonSpellActivationAlert")
	frame_alert.alert:SetFrameStrata ("FULLSCREEN")
	frame_alert.alert:Hide()	
	
local window_openned_at = time()

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 1
		
		--> introduction
		
		local angel = window:CreateTexture (nil, "border")
		angel:SetPoint ("bottomright", window, "bottomright")
		angel:SetTexture ([[Interface\TUTORIALFRAME\UI-TUTORIALFRAME-SPIRITREZ]])
		angel:SetTexCoord (0.162109375, 0.591796875, 0, 1)
		angel:SetWidth (442)
		angel:SetHeight (256)
		angel:SetAlpha (.2)
		
		local texto1 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto1:SetPoint ("topleft", window, "topleft", 13, -220)
		texto1:SetText (Loc ["STRING_WELCOME_1"])
		texto1:SetJustifyH ("left")
		
		pages [#pages+1] = {texto1, angel}
		
		
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> Skins Page page 2

	--SKINS

		local bg55 = window:CreateTexture (nil, "overlay")
		bg55:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg55:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg55:SetHeight (125*3)
		bg55:SetWidth (89*3)
		bg55:SetAlpha (.05)
		bg55:SetTexCoord (1, 0, 0, 1)

		local texto55 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto55:SetPoint ("topleft", window, "topleft", 20, -80)
		texto55:SetText (Loc ["STRING_WELCOME_42"])

		local texto555 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto555:SetText (Loc ["STRING_WELCOME_45"])
		texto555:SetTextColor (1, 1, 1, 1)
		
		local changemind = g:NewLabel (window, _, "$parentChangeMind55Label", "changemind55Label", Loc ["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		window.changemind55Label:SetPoint ("center", window, "center")
		window.changemind55Label:SetPoint ("bottom", window, "bottom", 0, 19)
		window.changemind55Label.align = "|"
		
		local texto_appearance = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_appearance:SetPoint ("topleft", window, "topleft", 30, -110)
		texto_appearance:SetText (Loc ["STRING_WELCOME_43"])
		texto_appearance:SetWidth (460)
		texto_appearance:SetHeight (100)
		texto_appearance:SetJustifyH ("left")
		texto_appearance:SetJustifyV ("top")
		texto_appearance:SetTextColor (1, 1, 1, 1)
		
		local skins_image = window:CreateTexture (nil, "overlay")
		skins_image:SetTexture ([[Interface\Addons\Details\images\icons2]])
		skins_image:SetPoint ("topright", window, "topright", -50, -24)
		skins_image:SetWidth (214*0.7)
		skins_image:SetHeight (133*0.7)
		skins_image:SetTexCoord (0, 0.41796875, 0, 0.259765625) --0, 0, 214 133

		--skin
			local onSelectSkin = function (_, _, skin_name)
				local instance1 = _detalhes:GetInstance (1)
				if (instance1 and instance1:IsEnabled()) then
					instance1:ChangeSkin (skin_name)
					window.FontDropdown:Select (instance1.row_info.font_face)
					window.BarHeightSlider:SetValue (instance1.row_info.height)
					window.TextSizeSlider:SetValue (instance1.row_info.font_size)
					window.ShowPercentCheckBox:SetValue (instance1.row_info.textR_show_data [3])
				end
				local instance2 = _detalhes:GetInstance (2)
				if (instance2 and instance2:IsEnabled()) then
					instance2:ChangeSkin (skin_name)
				end
			end

			local buildSkinMenu = function()
				local skinOptions = {}
				for skin_name, skin_table in pairs (_detalhes.skins) do
					skinOptions [#skinOptions+1] = {value = skin_name, label = skin_name, onclick = onSelectSkin, icon = "Interface\\GossipFrame\\TabardGossipIcon", desc = skin_table.desc}
				end
				return skinOptions
			end
			
			local instance1 = _detalhes:GetInstance (1)
			local skin_dropdown = g:NewDropDown (window, _, "$parentSkinDropdown", "skinDropdown", 160, 20, buildSkinMenu, instance1.skin)
			skin_dropdown:SetTemplate (g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			skin_dropdown.tooltip = Loc ["STRING_WELCOME_58"]
			
			local skin_label = g:NewLabel (window, _, "$parentSkinLabel", "skinLabel", Loc ["STRING_OPTIONS_INSTANCE_SKIN"] .. ":", "GameFontNormal")
			skin_dropdown:SetPoint ("left", skin_label, "right", 2)
			skin_label:SetPoint ("topleft", window, "topleft", 30, -133)

		--> alphabet selection
		
			local texto_alphabet = window:CreateFontString (nil, "overlay", "GameFontNormal")
			texto_alphabet:SetPoint ("topleft", window, "topleft", 30, -110)
			texto_alphabet:SetText (Loc ["STRING_WELCOME_73"]) --"Select the Alphabet or Region:"
			texto_alphabet:SetJustifyH ("left")
			texto_alphabet:SetJustifyV ("top")
			texto_alphabet:SetTextColor (1, 1, 1)
			texto_alphabet:SetPoint ("topleft", skin_label.widget, "bottomleft", 0, -20)
		
			local allAlphabetCheckBoxes = {}
			local allAlphabetLabels = {}
		
			local onSelectAlphabet = function (self, fixedParameter, value)
			
				if (not value) then
					self:SetValue (true)
					return
				end
			
				for index, checkBox in ipairs (allAlphabetCheckBoxes) do
					if (checkBox ~= self) then
						checkBox:SetValue (false)
					end
				end
				
				local instance1 = Details:GetInstance (1)
				local instance2 = Details:GetInstance (2)
				
				_detalhes.tabela_historico:resetar()

				if (fixedParameter == 1) then --latin
					if (instance1 and instance1:IsEnabled()) then
						instance1:SetBarTextSettings (nil, "Accidental Presidency")
					end
					if (instance2 and instance2:IsEnabled()) then
						instance2:SetBarTextSettings (nil, "Accidental Presidency")
					end
					
					window.FontDropdown:Select ("Accidental Presidency")
					
					_detalhes:CreateTestBars ("en")
					
				elseif (fixedParameter == 2) then --russia
					if (instance1 and instance1:IsEnabled()) then
						instance1:SetBarTextSettings (nil, "Arial Narrow")
					end
					if (instance2 and instance2:IsEnabled()) then
						instance2:SetBarTextSettings (nil, "Arial Narrow")
					end
					
					window.FontDropdown:Select ("Arial Narrow")
					
					_detalhes:CreateTestBars ("ru")
					
				elseif (fixedParameter == 3) then --china
					if (instance1 and instance1:IsEnabled()) then
						instance1:SetBarTextSettings (nil, "AR CrystalzcuheiGBK Demibold")
					end
					if (instance2 and instance2:IsEnabled()) then
						instance2:SetBarTextSettings (nil, "AR CrystalzcuheiGBK Demibold")
					end
					
					window.FontDropdown:Select ("AR CrystalzcuheiGBK Demibold")
					
					_detalhes:CreateTestBars ("cn")
					
				elseif (fixedParameter == 4) then --korea
					if (instance1 and instance1:IsEnabled()) then
						instance1:SetBarTextSettings (nil, "2002")
					end
					if (instance2 and instance2:IsEnabled()) then
						instance2:SetBarTextSettings (nil, "2002")
					end
					
					window.FontDropdown:Select ("2002")
					
					_detalhes:CreateTestBars ("ko")
					
				elseif (fixedParameter == 5) then --taiwan
					if (instance1 and instance1:IsEnabled()) then
						instance1:SetBarTextSettings (nil, "AR CrystalzcuheiGBK Demibold")
					end
					if (instance2 and instance2:IsEnabled()) then
						instance2:SetBarTextSettings (nil, "AR CrystalzcuheiGBK Demibold")
					end
					
					window.FontDropdown:Select ("AR CrystalzcuheiGBK Demibold")
					
					_detalhes:CreateTestBars ("tw")
				end
				
			end
		
			--Latin Alphabet
			g:NewLabel (window, _, "$parentLatinAlphabetLabel", "LatinAlphabetLabel", Loc["STRING_WELCOME_74"], "GameFontHighlightLeft")
			g:NewSwitch (window, _, "$parentLatinAlphabetCheckBox", "LatinAlphabetCheckBox", 20, 20, _, _, true)
			window.LatinAlphabetCheckBox:SetAsCheckBox()
			window.LatinAlphabetCheckBox:SetFixedParameter (1)
			window.LatinAlphabetCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			window.LatinAlphabetCheckBox.OnSwitch = onSelectAlphabet
			window.LatinAlphabetLabel:SetPoint ("left", window.LatinAlphabetCheckBox, "right", 2, 0)
			
			tinsert (allAlphabetCheckBoxes, window.LatinAlphabetCheckBox)
			tinsert (allAlphabetLabels, window.LatinAlphabetLabel)
			
			--Russian
			g:NewLabel (window, _, "$parentCyrillicAlphabetLabel", "CyrillicAlphabetLabel", Loc["STRING_WELCOME_75"], "GameFontHighlightLeft")
			g:NewSwitch (window, _, "$parentCyrillicAlphabetCheckBox", "CyrillicAlphabetCheckBox", 20, 20, _, _, false)
			window.CyrillicAlphabetCheckBox:SetAsCheckBox()
			window.CyrillicAlphabetCheckBox:SetFixedParameter (2)
			window.CyrillicAlphabetCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			window.CyrillicAlphabetCheckBox.OnSwitch = onSelectAlphabet
			window.CyrillicAlphabetLabel:SetPoint ("left", window.CyrillicAlphabetCheckBox, "right", 2, 0)
			tinsert (allAlphabetCheckBoxes, window.CyrillicAlphabetCheckBox)
			tinsert (allAlphabetLabels, window.CyrillicAlphabetLabel)
			
			--Chinese
			g:NewLabel (window, _, "$parentChinaAlphabetLabel", "ChinaAlphabetLabel", Loc["STRING_WELCOME_76"], "GameFontHighlightLeft")
			g:NewSwitch (window, _, "$parentChinaCheckBox", "ChinaCheckBox", 20, 20, _, _, false)
			window.ChinaCheckBox:SetAsCheckBox()
			window.ChinaCheckBox:SetFixedParameter (3)
			window.ChinaCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			window.ChinaCheckBox.OnSwitch = onSelectAlphabet
			window.ChinaAlphabetLabel:SetPoint ("left", window.ChinaCheckBox, "right", 2, 0)
			tinsert (allAlphabetCheckBoxes, window.ChinaCheckBox)
			tinsert (allAlphabetLabels, window.ChinaAlphabetLabel)
			
			--Korea
			g:NewLabel (window, _, "$parentKoreanAlphabetLabel", "KoreanAlphabetLabel", Loc["STRING_WELCOME_77"], "GameFontHighlightLeft")
			g:NewSwitch (window, _, "$parentKoreanCheckBox", "KoreanCheckBox", 20, 20, _, _, false)
			window.KoreanCheckBox:SetAsCheckBox()
			window.KoreanCheckBox:SetFixedParameter (4)
			window.KoreanCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			window.KoreanCheckBox.OnSwitch = onSelectAlphabet
			window.KoreanAlphabetLabel:SetPoint ("left", window.KoreanCheckBox, "right", 2, 0)
			tinsert (allAlphabetCheckBoxes, window.KoreanCheckBox)
			tinsert (allAlphabetLabels, window.KoreanAlphabetLabel)
			
			--Taiwan
			g:NewLabel (window, _, "$parentTaiwanAlphabetLabel", "TaiwanAlphabetLabel", Loc["STRING_WELCOME_78"], "GameFontHighlightLeft")
			g:NewSwitch (window, _, "$parentTaiwanCheckBox", "TaiwanCheckBox", 20, 20, _, _, false)
			window.TaiwanCheckBox:SetAsCheckBox()
			window.TaiwanCheckBox:SetFixedParameter (5)
			window.TaiwanCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			window.TaiwanCheckBox.OnSwitch = onSelectAlphabet
			window.TaiwanAlphabetLabel:SetPoint ("left", window.TaiwanCheckBox, "right", 2, 0)
			tinsert (allAlphabetCheckBoxes, window.TaiwanCheckBox)
			tinsert (allAlphabetLabels, window.TaiwanAlphabetLabel)
		
			window.LatinAlphabetCheckBox:SetPoint ("topleft", texto_alphabet, "bottomleft", 0, -10)
			window.CyrillicAlphabetCheckBox:SetPoint ("topleft", window.LatinAlphabetCheckBox, "bottomleft", 0, -2)
			window.ChinaCheckBox:SetPoint ("topleft", window.CyrillicAlphabetCheckBox, "bottomleft", 0, -2)
			window.KoreanCheckBox:SetPoint ("topleft", texto_alphabet, "bottomleft", 175, -10)
			window.TaiwanCheckBox:SetPoint ("topleft", window.KoreanCheckBox, "bottomleft", 0, -2)
		
		--> buttons
		local padding = -4
		local buttonWidth = 160
			
		-- create second window button
			local new_window = function (self)
				if (#_detalhes.tabela_instancias == 1) then
					local newwindow = _detalhes:CreateInstance (true)
					newwindow.baseframe:SetPoint ("topleft", _detalhes.tabela_instancias[1].baseframe, "topright", 50, 0)
					newwindow.baseframe:SetPoint ("bottomleft", _detalhes.tabela_instancias[1].baseframe, "bottomright", 50, 0)
					newwindow:SaveMainWindowPosition()
					newwindow:RestoreMainWindowPosition()
				end
				self.MyObject:Disable()
			end
			
			local create_window_button = g:CreateButton (window, new_window, buttonWidth, 20, Loc["STRING_WELCOME_79"])
			create_window_button:SetTemplate (g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			create_window_button:SetIcon ([[Interface\FriendsFrame\UI-FriendsList-Large-Up]], nil, nil, nil, {5/32, 26/32, 6/32, 26/32}, nil, 4, 2)
			create_window_button:SetPoint ("topright", window, "topright", -100, -137)
		
			if (#_detalhes.tabela_instancias == 2) then
				create_window_button:Disable()
			end
		
		-- window color
			window.editing_window = nil
			local windowcolor_callback = function (button, r, g, b, a)
				local instance = window.editing_window
			
				if (instance.menu_alpha.enabled and a ~= instance.color[4]) then
					_detalhes:Msg (Loc ["STRING_OPTIONS_MENU_ALPHAWARNING"])
					instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
					
					if (_detalhes.options_group_edit) then
						for _, this_instance in ipairs (instance:GetInstanceGroup()) do
							if (this_instance ~= instance) then
								this_instance:InstanceColor (r, g, b, instance.menu_alpha.onleave, nil, true)
							end
						end
					end
					
					return
				end
				
				instance:InstanceColor (r, g, b, a, nil, true)
				if (_detalhes.options_group_edit) then
					for _, this_instance in ipairs (instance:GetInstanceGroup()) do
						if (this_instance ~= instance) then
							this_instance:InstanceColor (r, g, b, a, nil, true)
						end
					end
				end
				
				local instance2 = _detalhes:GetInstance (2)
				if (instance2 and instance2:IsEnabled()) then
					instance2:InstanceColor (r, g, b, a, nil, true)
				end
			end
			
			local change_color = function()
				window.editing_window = _detalhes:GetInstance (1)
				local r, g, b, a = unpack (window.editing_window.color)
				_detalhes.gump:ColorPick (window, r, g, b, a, windowcolor_callback)
			end
			
			local window_color = g:CreateButton (window, change_color, buttonWidth, 20, Loc ["STRING_OPTIONS_CHANGECOLOR"])
			window_color:SetTemplate (g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			window_color:SetPoint ("topleft", create_window_button, "bottomleft", 0, padding)
			window_color:SetIcon ([[Interface\AddOns\Details\images\icons]], 14, 14, nil, {434/512, 466/512, 277/512, 307/512}, nil, 4, 2)

		--bar height
			g:NewLabel (window, _, "$parentBarHeightLabel", "BarHeightLabel", Loc ["STRING_OPTIONS_BAR_HEIGHT"] .. ":", "GameFontNormal")
			window.BarHeightLabel:SetPoint ("topleft", window_color, "bottomleft", 0, -4 + padding)
			--
			g:NewSlider (window, _, "$parentBarHeightSpeed", "BarHeightSlider", 160, 20, 8, 24, 1, 14) --parent, container, name, member, w, h, min, max, step, defaultv
			window.BarHeightSlider:SetPoint ("left", window.BarHeightLabel, "right", 2, 0)
			window.BarHeightSlider:SetTemplate (g:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE"))
			
			window.BarHeightSlider:SetHook ("OnValueChange", function (self, _, amount) 
				local instance1 = Details:GetInstance (1)
				local instance2 = Details:GetInstance (2)
				
				if (instance1 and instance1:IsEnabled()) then
					instance1:SetBarSettings (amount)
				end
				if (instance2 and instance2:IsEnabled()) then
					instance2:SetBarSettings (amount)
				end
			end)

		--text size
			g:NewLabel (window, _, "$parentTextSizeLabel", "TextSizeLabel", Loc ["STRING_OPTIONS_TEXT_SIZE"] .. ":", "GameFontNormal")
			window.TextSizeLabel:SetPoint ("topleft", window.BarHeightLabel, "bottomleft", 0, -4 + padding)
			--
			g:NewSlider (window, _, "$parentTextSizeSpeed", "TextSizeSlider", 160, 20, 10, 20, 1, 14) --parent, container, name, member, w, h, min, max, step, defaultv
			window.TextSizeSlider:SetPoint ("left", window.TextSizeLabel, "right", 2, 0)
			window.TextSizeSlider:SetTemplate (g:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE"))
			
			window.TextSizeSlider:SetHook ("OnValueChange", function (self, _, amount) 
				local instance1 = Details:GetInstance (1)
				local instance2 = Details:GetInstance (2)
				
				if (instance1 and instance1:IsEnabled()) then
					instance1:SetBarTextSettings (amount)
				end
				if (instance2 and instance2:IsEnabled()) then
					instance2:SetBarTextSettings (amount)
				end
			end)

		--font
			local onSelectFont = function (_, instance, fontName)
				local instance1 = Details:GetInstance (1)
				local instance2 = Details:GetInstance (2)
				
				if (instance1 and instance1:IsEnabled()) then
					instance1:SetBarTextSettings (nil, fontName)
				end
				if (instance2 and instance2:IsEnabled()) then
					instance2:SetBarTextSettings (nil, fontName)
				end
			end

			local buildFontMenu = function()
				local fontObjects = SharedMedia:HashTable ("font")
				local fontTable = {}
				for name, fontPath in pairs (fontObjects) do 
					fontTable[#fontTable+1] = {value = name, label = name, icon = font_select_icon, texcoord = font_select_texcoord, onclick = onSelectFont, font = fontPath, descfont = name, desc = Loc ["STRING_MUSIC_DETAILS_ROBERTOCARLOS"]}
				end
				table.sort (fontTable, function (t1, t2) return t1.label < t2.label end)
				return fontTable 
			end
			
			local instance1 = _detalhes:GetInstance (1)
			local font_dropdown = g:NewDropDown (window, _, "$parentFontDropdown", "FontDropdown", 160, 20, buildFontMenu, instance1.row_info.font_face)
			font_dropdown:SetTemplate (g:GetTemplate ("dropdown", "OPTIONS_DROPDOWN_TEMPLATE"))
			font_dropdown.tooltip = Loc ["STRING_WELCOME_58"]
			
			local font_label = g:NewLabel (window, _, "$parentFontLabel", "FontLabel", Loc ["STRING_OPTIONS_TEXT_FONT"], "GameFontNormal")
			font_dropdown:SetPoint ("left", font_label, "right", 2)
			font_label:SetPoint ("topleft", window.TextSizeLabel, "bottomleft", 0, -4 + padding)
		
		--show percent
			g:NewLabel (window, _, "$parentShowPercentLabel", "ShowPercentLabel", Loc ["STRING_OPTIONS_TEXT_SHOW_PERCENT"], "GameFontNormal")
			g:NewSwitch (window, _, "$parentShowPercentCheckBox", "ShowPercentCheckBox", 20, 20, _, _, false)
			window.ShowPercentCheckBox:SetAsCheckBox()
			window.ShowPercentCheckBox:SetFixedParameter (1)
			window.ShowPercentCheckBox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
			
			window.ShowPercentCheckBox.OnSwitch = function (self, fixedParameter, value)
				local instance1 = Details:GetInstance (1)
				local instance2 = Details:GetInstance (2)
				
				if (instance1 and instance1:IsEnabled()) then
					instance1:SetBarRightTextSettings (nil, nil, value)
					if (not value) then
						instance1:SetBarRightTextSettings (nil, nil, nil, nil, "NONE")
					else
						instance1:SetBarRightTextSettings (nil, nil, nil, nil, ",")
					end
				end
				if (instance2 and instance2:IsEnabled()) then
					instance2:SetBarRightTextSettings (nil, nil, value)
					if (not value) then
						instance2:SetBarRightTextSettings (nil, nil, nil, nil, "NONE")
					else
						instance2:SetBarRightTextSettings (nil, nil, nil, nil, ",")
					end
				end
			end
			
			window.ShowPercentLabel:SetPoint ("topleft", font_label.widget, "bottomleft", 0, -4 + padding)
			window.ShowPercentCheckBox:SetPoint ("left", window.ShowPercentLabel, "right", 2, 0)

		local created_test_bars = 0
		
		local skins_frame_alert = CreateFrame ("frame", nil, window)
		skins_frame_alert:Hide()
		skins_frame_alert:SetScript ("OnShow", function()
			if (created_test_bars < 2) then
				_detalhes:CreateTestBars()
				created_test_bars = created_test_bars + 1
			end
			
			if (DetailsWelcomeWindow.SetLocTimer) then
				_detalhes:CancelTimer (DetailsWelcomeWindow.SetLocTimer)
				DetailsWelcomeWindow.SetLocTimer = nil
				_detalhes:WelcomeSetLoc()
			end
		end)

		pages [#pages+1] = {skins_frame_alert, bg55, texto55, texto_alphabet, texto555, skins_image, changemind, texto_appearance, font_label, font_dropdown, skin_dropdown, skin_label, create_window_button, window_color, window.BarHeightLabel, window.BarHeightSlider, window.TextSizeLabel, window.TextSizeSlider, window.ShowPercentLabel, window.ShowPercentCheckBox}
		for i, widget in ipairs (allAlphabetCheckBoxes) do
			tinsert (pages [#pages], widget)
		end
		for i, widget in ipairs (allAlphabetLabels) do
			tinsert (pages [#pages], widget)
		end
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> numeral system page 3

		local numeral_image = window:CreateTexture (nil, "overlay")
		
		numeral_image:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		numeral_image:SetPoint ("bottomright", window, "bottomright", -10, 10)
		numeral_image:SetHeight (125*3)--125
		numeral_image:SetWidth (89*3)--82
		numeral_image:SetAlpha (.05)
		numeral_image:SetTexCoord (1, 0, 0, 1)		
		
		g:NewLabel (window, _, "$parentChangeMindNumeralLabel", "changemindNumeralLabel", Loc ["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		window.changemindNumeralLabel:SetPoint ("center", window, "center")
		window.changemindNumeralLabel:SetPoint ("bottom", window, "bottom", 0, 19)
		window.changemindNumeralLabel.align = "|"

		local texto2Numeral = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto2Numeral:SetPoint ("topleft", window, "topleft", 20, -80)
		texto2Numeral:SetText (Loc ["STRING_NUMERALSYSTEM_DESC"] .. ":")
		
		--numeral 1 - western
		g:NewLabel (window, _, "$parentWesternNumbersLabel", "WesternNumbersLabel", Loc ["STRING_NUMERALSYSTEM_ARABIC_WESTERN"] .. ": " .. Loc ["STRING_NUMERALSYSTEM_ARABIC_WESTERN_DESC"], "GameFontHighlightLeft")
		local WesternNumbersCheckbox = g:NewSwitch (window, _, "WesternNumbersCheckbox", "WesternNumbersCheckbox", 20, 20, _, _, true)
		WesternNumbersCheckbox:SetAsCheckBox()
		WesternNumbersCheckbox:SetFixedParameter (1)
		WesternNumbersCheckbox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		WesternNumbersCheckbox:SetPoint ("topleft", window, "topleft", 40, -130)
		window.WesternNumbersLabel:SetPoint ("left", WesternNumbersCheckbox, "right", 2, 0)
		
		--numeral 2 asian
		g:NewLabel (window, _, "$parentAsianNumbersLabel", "AsianNumbersLabel", Loc ["STRING_NUMERALSYSTEM_MYRIAD_EASTASIA"] .. ": " .. Loc ["STRING_NUMERALSYSTEM_ARABIC_MYRIAD_EASTASIA"], "GameFontHighlightLeft")
		local AsianNumbersCheckbox = g:NewSwitch (window, _, "AsianNumbersCheckbox", "AsianNumbersCheckbox", 20, 20, _, _, true)
		AsianNumbersCheckbox:SetAsCheckBox()
		AsianNumbersCheckbox:SetFixedParameter (2)
		AsianNumbersCheckbox:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		AsianNumbersCheckbox:SetPoint ("topleft", window, "topleft", 40, -200)
		window.AsianNumbersLabel:SetPoint ("left", AsianNumbersCheckbox, "right", 2, 0)
		
		--western on clicks
		WesternNumbersCheckbox.OnSwitch = function() 
			WesternNumbersCheckbox:SetValue (true)
			AsianNumbersCheckbox:SetValue (false)
			_detalhes.numerical_system = 1
			_detalhes:SelectNumericalSystem()
		end	
		
		--asian on click
		AsianNumbersCheckbox.OnSwitch = function() 
			AsianNumbersCheckbox:SetValue (true)
			WesternNumbersCheckbox:SetValue (false)
			_detalhes.numerical_system = 2 
			_detalhes:SelectNumericalSystem()
		end	
		
		local sword_icon2 = window:CreateTexture (nil, "overlay")
		sword_icon2:SetTexture ([[Interface\Addons\Details\images\icons2]])
		sword_icon2:SetPoint ("topright", window, "topright", -30, -10)
		sword_icon2:SetSize (128*1.4, 64*1.4)
		sword_icon2:SetTexCoord (330/512, 509/512, 437/512, 509/512)
		sword_icon2:SetDrawLayer ("overlay", 2)
		
		local thedude2 = window:CreateTexture (nil, "overlay")
		--thedude2:SetTexture ([[Interface\TUTORIALFRAME\UI-TutorialFrame-TheDude]])
		thedude2:SetPoint ("bottomright", sword_icon, "bottomleft", 70, 19)
		thedude2:SetWidth (128*1.0)
		thedude2:SetHeight (128*1.0)
		thedude2:SetTexCoord (0, 1, 0, 1)
		thedude2:SetDrawLayer ("overlay", 3)
		
		local NumeralType1_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		NumeralType1_text:SetText ("1K = 1.000 |cFFFFCC00| |r10K = 10.000 |cFFFFCC00| |r100K = 100.000 |cFFFFCC00| |r1M = 1.000.000")
		NumeralType1_text:SetWidth (500)
		NumeralType1_text:SetHeight (40)
		NumeralType1_text:SetJustifyH ("left")
		NumeralType1_text:SetJustifyV ("top")
		NumeralType1_text:SetTextColor (.8, .8, .8, 1)
		NumeralType1_text:SetPoint ("topleft", window, "topleft", 40, -150)
		
		local NumeralType2_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		
		
		local asian1K, asian10K, asian1B = _detalhes.gump:GetAsianNumberSymbols()
		local asianNumerals = "1" .. asian1K .. " = 1.000 \n1" .. asian10K .. " = 10.000 \n10" .. asian10K .. " = 100.000 \n100" .. asian10K .. " = 1.000.000"
		
		--> if region is western it'll be using Korean symbols, set a font on the dropdown so it won't show ?????
		local clientRegion = _detalhes.gump:GetClientRegion()
		if (clientRegion == "western" or clientRegion == "russia") then
			_detalhes.gump:SetFontFace (NumeralType2_text, _detalhes.gump:GetBestFontForLanguage ("koKR"))
			
		else
			_detalhes.gump:SetFontFace (NumeralType2_text, _detalhes.gump:GetBestFontForLanguage())
		end		
	
		--> set the text
		NumeralType2_text:SetText (asianNumerals)
		
		NumeralType2_text:SetWidth (500)
		NumeralType2_text:SetHeight (80)
		NumeralType2_text:SetJustifyH ("left")
		NumeralType2_text:SetJustifyV ("top")
		NumeralType2_text:SetTextColor (.8, .8, .8, 1)
		NumeralType2_text:SetPoint ("topleft", window, "topleft", 40, -220)
		
		if (_detalhes.numerical_system == 1) then --> west
			WesternNumbersCheckbox:SetValue (true)
			AsianNumbersCheckbox:SetValue (false)
		elseif (_detalhes.numerical_system == 2) then --> east
			WesternNumbersCheckbox:SetValue (false)
			AsianNumbersCheckbox:SetValue (true)
		end
		
		pages [#pages+1] = {thedude2, sword_icon2, numeral_image, texto2Numeral, NumeralType1_text, NumeralType2_text, window.changemindNumeralLabel, window.AsianNumbersLabel, AsianNumbersCheckbox, window.WesternNumbersLabel, WesternNumbersCheckbox}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 4
	
	-- DPS effective or active
		
		local ampulheta = window:CreateTexture (nil, "overlay")
		ampulheta:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		ampulheta:SetPoint ("bottomright", window, "bottomright", -10, 10)
		ampulheta:SetHeight (125*3)--125
		ampulheta:SetWidth (89*3)--82
		ampulheta:SetAlpha (.05)
		ampulheta:SetTexCoord (1, 0, 0, 1)		
		
		g:NewLabel (window, _, "$parentChangeMind2Label", "changemind2Label", Loc ["STRING_WELCOME_2"], "GameFontNormal", 9, "orange")
		window.changemind2Label:SetPoint ("center", window, "center")
		window.changemind2Label:SetPoint ("bottom", window, "bottom", 0, 19)
		window.changemind2Label.align = "|"

		local texto2 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto2:SetPoint ("topleft", window, "topleft", 20, -80)
		texto2:SetText (Loc ["STRING_WELCOME_3"])
		
		--chronometer checkbox
		g:NewLabel (window, _, "$parentChronometerLabel", "ChronometerLabel", Loc ["STRING_WELCOME_4"], "GameFontHighlightLeft")
		local chronometer = g:NewSwitch (window, _, "WelcomeWindowChronometer", "WelcomeWindowChronometer", 20, 20, _, _, true)
		chronometer:SetAsCheckBox()
		chronometer:SetFixedParameter (1)
		chronometer:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		window.ChronometerLabel:SetPoint ("left", chronometer, "right", 2, 0)
		
		--continuouses checkbox
		g:NewLabel (window, _, "$parentContinuousLabel", "ContinuousLabel", Loc ["STRING_WELCOME_5"], "GameFontHighlightLeft")
		local continuous = g:NewSwitch (window, _, "WelcomeWindowContinuous", "WelcomeWindowContinuous", 20, 20, _, _, true)
		continuous:SetAsCheckBox()
		continuous:SetFixedParameter (1)
		continuous:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		window.ContinuousLabel:SetPoint ("left", continuous, "right", 2, 0)
		
		--on clkich chronomoeter checkbox
		chronometer.OnSwitch = function() 
			chronometer:SetValue (true)
			continuous:SetValue (false)
			_detalhes.time_type = 1 
		end		
		
		--on click continuous check box
		continuous.OnSwitch = function() 
			continuous:SetValue (true)
			chronometer:SetValue (false)
			_detalhes.time_type = 2 
		end

		chronometer:SetPoint ("topleft", window, "topleft", 40, -130)
		continuous:SetPoint ("topleft", window, "topleft", 40, -200)
		
		local sword_icon = window:CreateTexture (nil, "overlay")
		sword_icon:SetTexture ([[Interface\TUTORIALFRAME\UI-TutorialFrame-AttackCursor]])
		sword_icon:SetPoint ("topright", window, "topright", -15, -30)
		sword_icon:SetWidth (64*1.4)
		sword_icon:SetHeight (64*1.4)
		sword_icon:SetTexCoord (1, 0, 0, 1)
		sword_icon:SetDrawLayer ("overlay", 2)
		
		local thedude = window:CreateTexture (nil, "overlay")
		thedude:SetTexture ([[Interface\TUTORIALFRAME\UI-TutorialFrame-TheDude]])
		thedude:SetPoint ("bottomright", sword_icon, "bottomleft", 70, 19)
		thedude:SetWidth (128*1.0)
		thedude:SetHeight (128*1.0)
		thedude:SetTexCoord (0, 1, 0, 1)
		thedude:SetDrawLayer ("overlay", 3)
		
		local chronometer_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		chronometer_text:SetText (Loc ["STRING_WELCOME_6"])
		chronometer_text:SetWidth (360)
		chronometer_text:SetHeight (40)
		chronometer_text:SetJustifyH ("left")
		chronometer_text:SetJustifyV ("top")
		chronometer_text:SetTextColor (.8, .8, .8, 1)
		chronometer_text:SetPoint ("topleft", window.ChronometerLabel.widget, "topright", 20, 0)
		
		local continuous_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		continuous_text:SetText (Loc ["STRING_WELCOME_7"])
		continuous_text:SetWidth (340)
		continuous_text:SetHeight (40)
		continuous_text:SetJustifyH ("left")
		continuous_text:SetJustifyV ("top")
		continuous_text:SetTextColor (.8, .8, .8, 1)
		continuous_text:SetPoint ("topleft", window.ContinuousLabel.widget, "topright", 20, 0)

		if (_detalhes.time_type == 1) then --> chronometer
			chronometer:SetValue (true)
			continuous:SetValue (false)
		elseif (_detalhes.time_type == 2) then --> continuous
			chronometer:SetValue (false)
			continuous:SetValue (true)
		end

		local pleasewait = window:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
		pleasewait:SetPoint ("bottomright", forward, "topright")
		
		local free_frame3 = CreateFrame ("frame", nil, window)
		function _detalhes:FreeTutorialFrame3()
			if (window_openned_at+10 > time()) then
				pleasewait:Show()
				forward:Disable()
				pleasewait:SetText ("wait... " .. window_openned_at + 10 - time())
			else
				pleasewait:Hide()
				pleasewait:SetText ("")
				forward:Enable()
				_detalhes:CancelTimer (window.free_frame3_schedule)
				window.free_frame3_schedule = nil
			end
		end
		free_frame3:SetScript ("OnShow", function()
			if (window_openned_at-10 > time()) then
				forward:Disable()
				if (window.free_frame3_schedule) then
					_detalhes:CancelTimer (window.free_frame3_schedule)
					window.free_frame3_schedule = nil
				end
				window.free_frame3_schedule = _detalhes:ScheduleRepeatingTimer ("FreeTutorialFrame3", 1)
			end
		end)
		free_frame3:SetScript ("OnHide", function()
			if (window.free_frame3_schedule) then
				_detalhes:CancelTimer (window.free_frame3_schedule)
				window.free_frame3_schedule = nil
				pleasewait:SetText ("")
				pleasewait:Hide()
			end
		end)
		
		pages [#pages+1] = {pleasewait, free_frame3, thedude, sword_icon, ampulheta, texto2, chronometer, continuous, chronometer_text, continuous_text, window.changemind2Label, window.ContinuousLabel, window.ChronometerLabel}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end

		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 4

	-- UPDATE SPEED
		
		local bg = window:CreateTexture (nil, "overlay")
		bg:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg:SetHeight (125*3)--125
		bg:SetWidth (89*3)--82
		bg:SetAlpha (.05)
		bg:SetTexCoord (1, 0, 0, 1)
		
		g:NewLabel (window, _, "$parentChangeMind4Label", "changemind4Label", Loc ["STRING_WELCOME_11"], "GameFontNormal", 9, "orange")
		window.changemind4Label:SetPoint ("center", window, "center")
		window.changemind4Label:SetPoint ("bottom", window, "bottom", 0, 19)
		window.changemind4Label.align = "|"

		local texto4 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto4:SetPoint ("topleft", window, "topleft", 20, -80)
		texto4:SetText (Loc ["STRING_WELCOME_41"])
		
		local interval_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		interval_text:SetText (Loc ["STRING_WELCOME_12"])
		interval_text:SetWidth (460)
		interval_text:SetHeight (40)
		interval_text:SetJustifyH ("left")
		interval_text:SetJustifyV ("top")
		interval_text:SetTextColor (1, 1, 1, .9)
		interval_text:SetPoint ("topleft", window, "topleft", 30, -110)
		
		local dance_text = window:CreateFontString (nil, "overlay", "GameFontNormal")
		dance_text:SetText ("") --loc removed
		dance_text:SetWidth (460)
		dance_text:SetHeight (40)
		dance_text:SetJustifyH ("left")
		dance_text:SetJustifyV ("top")
		dance_text:SetTextColor (1, 1, 1, 1)
		dance_text:SetPoint ("topleft", window, "topleft", 30, -175)
		
	--------------- Update Speed
		g:NewLabel (window, _, "$parentUpdateSpeedLabel", "updatespeedLabel", Loc ["STRING_OPTIONS_WINDOWSPEED"] .. ":", "GameFontNormal")
		window.updatespeedLabel:SetPoint (31, -150)
		--
		
		g:NewSlider (window, _, "$parentSliderUpdateSpeed", "updatespeedSlider", 160, 20, 0.050, 3, 0.050, _detalhes.update_speed, true) --parent, container, name, member, w, h, min, max, step, defaultv
		window.updatespeedSlider:SetPoint ("left", window.updatespeedLabel, "right", 2, 0)
		window.updatespeedSlider:SetTemplate (g:GetTemplate ("slider", "OPTIONS_SLIDER_TEMPLATE"))
		window.updatespeedSlider:SetThumbSize (50)
		window.updatespeedSlider.useDecimals = true
		local updateColor = function (slider, value)
			if (value < 1) then
				slider.amt:SetTextColor (1, value, 0)
			elseif (value > 1) then
				slider.amt:SetTextColor (-(value-3), 1, 0)
			else
				slider.amt:SetTextColor (1, 1, 0)
			end
		end

		window.updatespeedSlider:SetHook("OnValueChange", function (self, _, amount)
			Details:SetWindowUpdateSpeed(amount)
			updateColor(self, amount)
		end)
		updateColor(window.updatespeedSlider, _detalhes.update_speed)
		
		window.updatespeedSlider:SetHook ("OnEnter", function()
			return true
		end)
		
		window.updatespeedSlider.tooltip = Loc ["STRING_WELCOME_15"]
		
	--------------- Animate Rows
		g:NewLabel (window, _, "$parentAnimateLabel", "animateLabel", Loc ["STRING_OPTIONS_ANIMATEBARS"] .. ":", "GameFontNormal")
		window.animateLabel:SetPoint (31, -170)
		--
		g:NewSwitch (window, _, "$parentAnimateSlider", "animateSlider", 60, 20, _, _, _detalhes.use_row_animations) -- ltext, rtext, defaultv
		window.animateSlider:SetPoint ("left",window.animateLabel, "right", 2, 0)
		window.animateSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
			_detalhes:SetUseAnimations (value)
		end	
		
		window.animateSlider:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		window.animateSlider:SetAsCheckBox()
		--window.animateSlider.tooltip = Loc ["STRING_WELCOME_17"] --removed
		
	--------------- Fast Hps/Dps Updates
	--[
		g:NewLabel (window, _, "$parentDpsHpsLabel", "DpsHpsLabel", Loc ["STRING_WELCOME_63"] .. ":", "GameFontNormal")
		window.DpsHpsLabel:SetPoint (31, -190)
		--
		g:NewSwitch (window, _, "$parentDpsHpsSlider", "DpsHpsSlider", 60, 20, _, _, _detalhes:GetInstance(1).row_info.fast_ps_update) -- ltext, rtext, defaultv
		window.DpsHpsSlider:SetPoint ("left",window.DpsHpsLabel, "right", 2, 0)
		window.DpsHpsSlider.OnSwitch = function (self, _, value) --> slider, fixedValue, sliderValue (false, true)
			_detalhes:GetInstance(1):FastPSUpdate (value)
		end
		
		window.DpsHpsSlider:SetTemplate (g:GetTemplate ("switch", "OPTIONS_CHECKBOX_TEMPLATE"))
		window.DpsHpsSlider:SetAsCheckBox()
		
		--window.DpsHpsSlider.tooltip = Loc ["STRING_WELCOME_64"]
	--]]
	--------------- Max Segments
	--	g:NewLabel (window, _, "$parentSliderLabel", "segmentsLabel", Loc ["STRING_WELCOME_21"] .. ":", "GameFontNormal")
	--	window.segmentsLabel:SetPoint (31, -210)
		--
	--	g:NewSlider (window, _, "$parentSlider", "segmentsSlider", 120, 20, 1, 25, 1, _detalhes.segments_amount) -- min, max, step, defaultv
	--	window.segmentsSlider:SetPoint ("left", window.segmentsLabel, "right", 2, 0)
	--	window.segmentsSlider:SetHook ("OnValueChange", function (self, _, amount) --> slider, fixedValue, sliderValue
	--		_detalhes.segments_amount = math.floor (amount)
	--	end)
	--	window.segmentsSlider.tooltip = Loc ["STRING_WELCOME_22"]
	
	--------------
		local mech_icon = window:CreateTexture (nil, "overlay")
		mech_icon:SetTexture ([[Interface\Vehicles\UI-Vehicles-Endcap-Alliance]])
		mech_icon:SetPoint ("topright", window, "topright", -15, -15)
		mech_icon:SetWidth (128*0.9)
		mech_icon:SetHeight (128*0.9)
		mech_icon:SetAlpha (0.8)
		
		local mech_icon2 = window:CreateTexture (nil, "overlay")
		mech_icon2:SetTexture ([[Interface\Vehicles\UI-Vehicles-Trim-Alliance]])
		mech_icon2:SetPoint ("topright", window, "topright", -10, -151)
		mech_icon2:SetWidth (128*1.0)
		mech_icon2:SetHeight (128*0.6)
		mech_icon2:SetAlpha (0.6)
		mech_icon2:SetTexCoord (0, 1, 40/128, 1)
		mech_icon2:SetDrawLayer ("overlay", 2)

		local update_frame_alert = CreateFrame ("frame", nil, window)
		update_frame_alert:SetScript ("OnShow", function()
		
			_detalhes.tabela_historico:resetar()
			created_test_bars = 0
			
			_detalhes.zone_type = "pvp"
			
			_detalhes:EntrarEmCombate()
			
			_detalhes:StartTestBarUpdate()
			
			if (created_test_bars < 2) then
				_detalhes:CreateTestBars()
				created_test_bars = created_test_bars + 1
			end
			
			local instance = _detalhes:GetInstance (1)
			instance:SetMode (3)
		end)
		
		update_frame_alert:SetScript ("OnHide", function()
			_detalhes:StopTestBarUpdate()
			
			_detalhes.parser_functions:ZONE_CHANGED_NEW_AREA()
			_detalhes:SairDoCombate()
			
			instance:SetMode (2)
		end)
	
	----------------
		-- window.segmentsLabel, window.segmentsSlider, 
		pages [#pages+1] = {update_frame_alert, mech_icon2, mech_icon, bg, texto4, interval_text, dance_text, window.updatespeedLabel, window.updatespeedSlider, window.animateLabel, window.animateSlider, window.changemind4Label, window.DpsHpsLabel, window.DpsHpsSlider}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 6
-- stretcher

		local bg6 = window:CreateTexture (nil, "overlay")
		bg6:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg6:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg6:SetHeight (125*3)--125
		bg6:SetWidth (89*3)--82
		bg6:SetAlpha (.1)
		bg6:SetTexCoord (1, 0, 0, 1)

		local texto5 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto5:SetPoint ("topleft", window, "topleft", 20, -80)
		texto5:SetText (Loc ["STRING_WELCOME_26"])
		
		local texto_stretch = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_stretch:SetPoint ("topleft", window, "topleft", 181, -105)
		texto_stretch:SetText (Loc ["STRING_WELCOME_27"])
		texto_stretch:SetWidth (310)
		texto_stretch:SetHeight (100)
		texto_stretch:SetJustifyH ("left")
		texto_stretch:SetJustifyV ("top")
		texto_stretch:SetTextColor (1, 1, 1, 1)
		
		local stretch_image = window:CreateTexture (nil, "overlay")
		stretch_image:SetTexture ([[Interface\Addons\Details\images\icons]])
		stretch_image:SetPoint ("right", texto_stretch, "left", -12, 0)
		stretch_image:SetWidth (144)
		stretch_image:SetHeight (61)
		stretch_image:SetTexCoord (0.716796875, 1, 0.876953125, 1)
		
		local stretch_frame_alert = CreateFrame ("frame", nil, window)
		stretch_frame_alert:SetScript ("OnHide", function()
			_detalhes:StopPlayStretchAlert()
		end)
		stretch_frame_alert:SetScript ("OnShow", function()
			local instance = _detalhes:GetInstance (1)
			_detalhes.OnEnterMainWindow (instance)
			instance.baseframe.button_stretch:SetAlpha (1)
			frame_alert.alert:SetPoint ("topleft", instance.baseframe.button_stretch, "topleft", -20, 6)
			frame_alert.alert:SetPoint ("bottomright", instance.baseframe.button_stretch, "bottomright", 20, -14)
			
			frame_alert.alert.animOut:Stop()
			frame_alert.alert.animIn:Play()
			if (_detalhes.stopwelcomealert) then
				_detalhes:CancelTimer (_detalhes.stopwelcomealert)
			end
			_detalhes.stopwelcomealert = _detalhes:ScheduleTimer ("StopPlayStretchAlert", 30)
		end)

		
		pages [#pages+1] = {bg6, texto5, stretch_image, texto_stretch, stretch_frame_alert}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 7
-- window button

		local bg6 = window:CreateTexture (nil, "overlay")
		bg6:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg6:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg6:SetHeight (125*3)--125
		bg6:SetWidth (89*3)--82
		bg6:SetAlpha (.1)
		bg6:SetTexCoord (1, 0, 0, 1)

		local texto6 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto6:SetPoint ("topleft", window, "topleft", 20, -80)
		texto6:SetText (Loc ["STRING_WELCOME_28"])
		
		local texto_instance_button = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_instance_button:SetPoint ("topleft", window, "topleft", 25, -105)
		texto_instance_button:SetText (Loc ["STRING_WELCOME_29"])
		texto_instance_button:SetWidth (270)
		texto_instance_button:SetHeight (100)
		texto_instance_button:SetJustifyH ("left")
		texto_instance_button:SetJustifyV ("top")
		texto_instance_button:SetTextColor (1, 1, 1, 1)
		
		local instance_button_image = window:CreateTexture (nil, "overlay")
		instance_button_image:SetTexture ([[Interface\Addons\Details\images\icons]])
		instance_button_image:SetPoint ("topright", window, "topright", -16, -70)
		instance_button_image:SetWidth (198)
		instance_button_image:SetHeight (141)
		instance_button_image:SetTexCoord (0.328125, 0.71484375, 0.724609375, 1)
		
		local instance_frame_alert = CreateFrame ("frame", nil, window)
		instance_frame_alert:SetScript ("OnHide", function()
			_detalhes:StopPlayStretchAlert()
		end)
		instance_frame_alert:SetScript ("OnShow", function()
			local instance = _detalhes:GetInstance (1)

			frame_alert.alert:SetPoint ("topleft", instance.baseframe.cabecalho.modo_selecao.widget, "topleft", -8, 6)
			frame_alert.alert:SetPoint ("bottomright", instance.baseframe.cabecalho.modo_selecao.widget, "bottomright", 8, -6)
			
			frame_alert.alert.animOut:Stop()
			frame_alert.alert.animIn:Play()
			if (_detalhes.stopwelcomealert) then
				_detalhes:CancelTimer (_detalhes.stopwelcomealert)
			end
			_detalhes.stopwelcomealert = _detalhes:ScheduleTimer ("StopPlayStretchAlert", 30)
		end)
		
		pages [#pages+1] = {bg6, texto6, instance_button_image, texto_instance_button, instance_frame_alert}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 8
-- bookmark

		local bg7 = window:CreateTexture (nil, "overlay")
		bg7:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg7:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg7:SetHeight (125*3)--125
		bg7:SetWidth (89*3)--82
		bg7:SetAlpha (.1)
		bg7:SetTexCoord (1, 0, 0, 1)

		local texto7 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto7:SetPoint ("topleft", window, "topleft", 20, -80)
		texto7:SetText (Loc ["STRING_WELCOME_30"])
		
		local texto_shortcut = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_shortcut:SetPoint ("topleft", window, "topleft", 25, -105)
		texto_shortcut:SetText (Loc ["STRING_WELCOME_31"])
		texto_shortcut:SetWidth (290)
		texto_shortcut:SetHeight (160)
		texto_shortcut:SetJustifyH ("left")
		texto_shortcut:SetJustifyV ("top")
		texto_shortcut:SetTextColor (1, 1, 1, 1)
		
		local shortcut_image2 = window:CreateTexture (nil, "overlay")
		shortcut_image2:SetTexture ([[Interface\Addons\Details\images\icons]])
		shortcut_image2:SetPoint ("topright", window, "topright", -22, -87)
		shortcut_image2:SetWidth (165)
		shortcut_image2:SetHeight (119)
		shortcut_image2:SetTexCoord (2/512, 167/512, 306/512, 425/512)

		
		local instance1 = _detalhes:GetInstance (1)
		
		local bookmark_frame = CreateFrame ("frame", "WelcomeBookmarkFrame", window,"BackdropTemplate")
		bookmark_frame:SetPoint ("topleft", instance1.baseframe, "topleft")
		bookmark_frame:SetPoint ("bottomright", instance1.baseframe, "bottomright")
		bookmark_frame:SetBackdrop ({bgFile = [[Interface\AddOns\Details\images\background]], tile = true, tileSize = 64})
		bookmark_frame:SetBackdropColor (0, 0, 0, 0.8)

		local desc_anchor_topleft = _detalhes.gump:NewImage (bookmark_frame, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.19921875, 0.2724609375, 0.6796875, 0.783203125}, "descAnchorBottomLeftImage", "$parentDescAnchorBottomLeftImage") --204 696 279 802
		desc_anchor_topleft:SetPoint ("topleft", bookmark_frame, "topleft", -5, 5)
		
		local desc_anchor_bottomleft = _detalhes.gump:NewImage (bookmark_frame, [[Interface\AddOns\Details\images\options_window]], 75, 106, "artwork", {0.2724609375, 0.19921875, 0.783203125, 0.6796875}, "descAnchorTopLeftImage", "$parentDescAnchorTopLeftImage") --204 696 279 802
		desc_anchor_bottomleft:SetPoint ("bottomright", bookmark_frame, "bottomright", 5, -5)
		
		local bmf_string = bookmark_frame:CreateFontString ("overlay", nil, "GameFontNormal")
		bmf_string:SetPoint ("center", bookmark_frame, "center")
		bmf_string:SetText (Loc ["STRING_WELCOME_65"])
		
		local bg_string = _detalhes.gump:NewImage (bookmark_frame, [[Interface\ACHIEVEMENTFRAME\UI-Achievement-RecentHeader]], 256, 32, "border", {0, 1, 0, 23/32})
		bg_string:SetPoint ("left", bookmark_frame, "left", 0, 0)
		bg_string:SetPoint ("right", bookmark_frame, "right", 0, 0)
		bg_string:SetPoint ("center", bmf_string, "center", 0, 0)
		
		bookmark_frame:SetScript ("OnMouseDown", function (self, button)
			if (button == "RightButton") then
				_detalhes.switch:ShowMe (instance1)
				self:Hide()
			end
		end)
		
		pages [#pages+1] = {bg7, texto7, shortcut_image2, texto_shortcut, bookmark_frame}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 9
-- group windows

		local bg77 = window:CreateTexture (nil, "overlay")
		bg77:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg77:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg77:SetHeight (125*3)--125
		bg77:SetWidth (89*3)--82
		bg77:SetAlpha (.1)
		bg77:SetTexCoord (1, 0, 0, 1)

		local texto77 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto77:SetPoint ("topleft", window, "topleft", 20, -80)
		texto77:SetText (Loc ["STRING_WELCOME_32"])
		
		local texto_snap = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_snap:SetPoint ("topleft", window, "topleft", 25, -101)
		texto_snap:SetText (Loc ["STRING_WELCOME_66"])
		texto_snap:SetWidth (160)
		texto_snap:SetHeight (110)
		texto_snap:SetJustifyH ("left")
		texto_snap:SetJustifyV ("top")
		texto_snap:SetTextColor (1, 1, 1, 1)
		local fonte, _, flags = texto_snap:GetFont()
		texto_snap:SetFont (fonte, 11, flags)
		
		local snap_image1 = window:CreateTexture (nil, "overlay")
		snap_image1:SetTexture ([[Interface\Addons\Details\images\icons]])
		snap_image1:SetPoint ("topright", window, "topright", -12, -95)
		snap_image1:SetWidth (310)
		snap_image1:SetHeight (102) 
		snap_image1:SetTexCoord (0, 0.60546875, 191/512, 293/512)

		local group_frame_alert = CreateFrame ("frame", nil, window)
		group_frame_alert:SetScript ("OnShow", function()
			_detalhes.tabela_historico:resetar()
			created_test_bars = 0
		end)
		
		pages [#pages+1] = {bg77, texto77, snap_image1, texto_snap, group_frame_alert}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 10
-- tooltip shift alt ctrl

		local bg88 = window:CreateTexture (nil, "overlay")
		bg88:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg88:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg88:SetHeight (125*3)--125
		bg88:SetWidth (89*3)--82
		bg88:SetAlpha (.1)
		bg88:SetTexCoord (1, 0, 0, 1)

		local texto88 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto88:SetPoint ("topleft", window, "topleft", 20, -80)
		texto88:SetText (Loc ["STRING_WELCOME_34"])

		local texto_micro_display = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_micro_display:SetPoint ("topleft", window, "topleft", 25, -101)
		texto_micro_display:SetText (Loc ["STRING_WELCOME_67"])
		texto_micro_display:SetWidth (300)
		texto_micro_display:SetHeight (110)
		texto_micro_display:SetJustifyH ("left")
		texto_micro_display:SetJustifyV ("top")
		texto_micro_display:SetTextColor (1, 1, 1, 1)
		
		local micro_image1 = window:CreateTexture (nil, "overlay")
		micro_image1:SetTexture ([[Interface\Addons\Details\images\icons]])
		micro_image1:SetPoint ("topright", window, "topright", -15, -70)
		micro_image1:SetWidth (186)
		micro_image1:SetHeight (100)
		micro_image1:SetTexCoord (326/512, 1, 85/512, 185/512)
		
		local tooltip_frame = CreateFrame ("frame", nil, window)
		tooltip_frame:SetScript ("OnShow", function (self)
		
			_detalhes.tabela_historico:resetar()
			created_test_bars = 0
			
			local current_combat = _detalhes:GetCombat ("current")
			local actors_classes = CLASS_SORT_ORDER
			local total_damage = 0
			local total_heal = 0
			
			local joe = current_combat[1]:PegarCombatente ("0x0000000000001", "Joe", 0x114, true)
			joe.grupo = true
			joe.classe = actors_classes [math.random (1, #actors_classes)]
			joe.total = 7500000
			joe.total_without_pet = 7500000
			joe.damage_taken = math.random (100000, 600000)
			joe.friendlyfire_total = math.random (100000, 600000)
			
			total_damage = total_damage + joe.total

			--local joe_death = current_combat[4]:PegarCombatente (0x0000000000000, joe.nome, 0x114, true)
			--joe_death.grupo = true
			--joe_death.classe = joe.classe
			--local esta_morte = {{true, 96648, 100000, time(), 0, "Lady Holenna"}, {true, 96648, 100000, time()-52, 100000, "Lady Holenna"}, {true, 96648, 100000, time()-86, 200000, "Lady Holenna"}, {true, 96648, 100000, time()-101, 300000, "Lady Holenna"}, {false, 55296, 400000, time()-54, 400000, "King Djoffrey"}, {true, 14185, 0, time()-59, 400000, "Lady Holenna"}, {false, 87351, 400000, time()-154, 400000, "King Djoffrey"}, {false, 56236, 400000, time()-158, 400000, "King Djoffrey"} } 
			--local t = {esta_morte, time(), joe.nome, joe.classe, 400000, "52m 12s",  ["dead"] = true}
			--table.insert (current_combat.last_events_tables, #current_combat.last_events_tables+1, t)
			
			rawset (_detalhes.spellcache, 300000, {"A Gun in Your Hand", 300000, [[Interface\ICONS\INV_Legendary_Gun]]})
			rawset (_detalhes.spellcache, 300001, {"Shot", 300001, [[Interface\ICONS\INV_Archaeology_Ogres_HarGunn_Eye]]})
			rawset (_detalhes.spellcache, 300002, {"Mexico Travel", 300002, [[Interface\ICONS\Achievement_Dungeon_Gundrak_Normal]]})
			rawset (_detalhes.spellcache, 300003, {"Rope", 300003, [[Interface\ICONS\Creatureportrait_RopeLadder01]]})
			rawset (_detalhes.spellcache, 300004, {"A Guitar Solo", 300004, [[Interface\ICONS\INV_Staff_2h_DraenorDungeon_C_05]]})
			rawset (_detalhes.spellcache, 300005, {"Watchtower", 300005, [[Interface\ICONS\Achievement_BG_DefendXtowers_AV]]})
			rawset (_detalhes.spellcache, 300006, {"Oh! Hey There!", 300006, [[Interface\ICONS\Spell_Shadow_SummonSuccubus]]})
			rawset (_detalhes.spellcache, 300007, {"I'm an Ability!", 300007, [[Interface\ICONS\Spell_Nature_Polymorph]]})
			
			joe.targets ["My Old Lady"] = 3500000
			joe.targets ["My Self"] = 2000000
			joe.targets ["Another Man"] = 1000001
			joe.targets ["Another Random Guy"] = 1000001
			
			joe.spells:PegaHabilidade (300000, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300000].total = 4500000
			joe.spells:PegaHabilidade (300001, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300001].total = 1000001
			joe.spells:PegaHabilidade (300002, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300002].total = 1000001
			joe.spells:PegaHabilidade (300003, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300003].total = 2000000
			joe.spells:PegaHabilidade (300004, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300004].total = 4100000
			joe.spells:PegaHabilidade (300005, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300005].total = 1000003
			joe.spells:PegaHabilidade (300006, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300006].total = 800000
			joe.spells:PegaHabilidade (300007, true, "SPELL_DAMAGE"); joe.spells._ActorTable [300007].total = 700000
			
		
			--current_combat.start_time = time()-360
			current_combat.start_time = GetTime() - 360
			--current_combat.end_time = time()
			current_combat.end_time = GetTime()
			
			current_combat.totals_grupo [1] = total_damage
			current_combat.totals [1] = total_damage
			
			for _, instance in ipairs (_detalhes.tabela_instancias) do 
				if (instance:IsEnabled()) then
					instance:InstanceReset()
				end
			end
			
			_detalhes:GetInstance(1):SetDisplay (0, 1, 1)
			
			local bar1 = _detalhes:GetInstance(1):GetRow(1)
			
			frame_alert.alert:SetPoint ("topleft", bar1, "topleft", -60, 8)
			frame_alert.alert:SetPoint ("bottomright", bar1, "bottomright", 60, -10)
			
			frame_alert.alert.animOut:Stop()
			frame_alert.alert.animIn:Play()
			if (_detalhes.stopwelcomealert) then
				_detalhes:CancelTimer (_detalhes.stopwelcomealert)
			end
			_detalhes.stopwelcomealert = _detalhes:ScheduleTimer ("StopPlayStretchAlert", 2)
			
		end)
		
		tooltip_frame:SetScript ("OnHide", function()
			_detalhes:StopPlayStretchAlert()
		end)
		
		pages [#pages+1] = {bg88, texto88, micro_image1, texto_micro_display, tooltip_frame}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 11

		local bg11 = window:CreateTexture (nil, "overlay")
		bg11:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg11:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg11:SetHeight (125*3)--125
		bg11:SetWidth (89*3)--82
		bg11:SetAlpha (.1)
		bg11:SetTexCoord (1, 0, 0, 1)

		local texto11 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto11:SetPoint ("topleft", window, "topleft", 20, -80)
		texto11:SetText (Loc ["STRING_WELCOME_36"])

		local texto_plugins = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto_plugins:SetPoint ("topleft", window, "topleft", 25, -101)
		texto_plugins:SetText (Loc ["STRING_WELCOME_68"])
		texto_plugins:SetWidth (220)
		texto_plugins:SetHeight (110)
		texto_plugins:SetJustifyH ("left")
		texto_plugins:SetJustifyV ("top")
		texto_plugins:SetTextColor (1, 1, 1, 1)
		--local fonte, _, flags = texto_plugins:GetFont()
		--texto_plugins:SetFont (fonte, 11, flags)
		
		local plugins_image1 = window:CreateTexture (nil, "overlay")
		plugins_image1:SetTexture ([[Interface\Addons\Details\images\icons2]])
		plugins_image1:SetPoint ("topright", window, "topright", -12, -90)
		plugins_image1:SetWidth (281)
		plugins_image1:SetHeight (81)
		plugins_image1:SetTexCoord (216/512, 497/512, 6/512, 95/512)
		
		pages [#pages+1] = {bg11, texto11, plugins_image1, texto_plugins}
		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end		
		
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> page 12

		local bg8 = window:CreateTexture (nil, "overlay")
		bg8:SetTexture ([[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]])
		bg8:SetPoint ("bottomright", window, "bottomright", -10, 10)
		bg8:SetHeight (125*3)--125
		bg8:SetWidth (89*3)--82
		bg8:SetAlpha (.1)
		bg8:SetTexCoord (1, 0, 0, 1)

		local texto8 = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto8:SetPoint ("topleft", window, "topleft", 20, -80)
		texto8:SetText (Loc ["STRING_WELCOME_38"])
		
		local texto = window:CreateFontString (nil, "overlay", "GameFontNormal")
		texto:SetPoint ("topleft", window, "topleft", 25, -110)
		texto:SetText (Loc ["STRING_WELCOME_39"])
		texto:SetWidth (410)
		texto:SetHeight (90)
		texto:SetJustifyH ("left")
		texto:SetJustifyV ("top")
		texto:SetTextColor (1, 1, 1, 1)
		
		local final_frame = CreateFrame ("frame", nil, window)
		final_frame:SetSize (1, 1)
		final_frame:SetPoint ("center")
		final_frame:Hide()
		final_frame:SetScript ("OnShow", function()
			cancel:Enable()
			cancel:GetNormalTexture():SetDesaturated (false)
		end)
		
		pages [#pages+1] = {bg8, texto8, texto, final_frame}
		

		
		for _, widget in ipairs (pages[#pages]) do 
			widget:Hide()
		end
		
------------------------------------------------------------------------------------------------------------------------------		
		
	 --[[
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		forward:Click()
		--forward:Click()
		--forward:Click()
		--forward:Click()
		--]]

	end
	
end
