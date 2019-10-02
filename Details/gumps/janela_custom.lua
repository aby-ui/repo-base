--> custom window

	local _detalhes = 		_G._detalhes
	local gump = 			_detalhes.gump
	local _
	
	local AceComm = LibStub ("AceComm-3.0")
	local AceSerializer = LibStub ("AceSerializer-3.0")
	local Loc = LibStub ("AceLocale-3.0"):GetLocale ( "Details" )

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> local pointers

	
	local _cstr = string.format --lua local
	local _math_ceil = math.ceil --lua local
	local _math_floor = math.floor --lua local
	local _ipairs = ipairs --lua local
	local _pairs = pairs --lua local
	local _string_lower = string.lower --lua local
	local _table_sort = table.sort --lua local
	local _table_insert = table.insert --lua local
	local _unpack = unpack --lua local
	local _setmetatable = setmetatable --lua local

	local _GetSpellInfo = _detalhes.getspellinfo --api local
	local _CreateFrame = CreateFrame --api local
	local _GetTime = GetTime --api local
	local _GetCursorPosition = GetCursorPosition --api local
	local _GameTooltip = GameTooltip --api local
	local _UIParent = UIParent --api local
	local _GetScreenWidth = GetScreenWidth --api local
	local _GetScreenHeight = GetScreenHeight --api local
	local _IsAltKeyDown = IsAltKeyDown --api local
	local _IsShiftKeyDown = IsShiftKeyDown --api local
	local _IsControlKeyDown = IsControlKeyDown --api local
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> constants
	
	local CONST_MENU_X_POSITION = 10
	local CONST_MENU_Y_POSITION = -40
	local CONST_MENU_WIDTH = 160
	local CONST_MENU_HEIGHT = 20
	
	local CONST_INFOBOX_X_POSITION = 220
	local CONST_EDITBUTTONS_X_POSITION = 560
	
	local CONST_EDITBOX_Y_POSITION = -200
	local CONST_EDITBOX_WIDTH = 900
	local CONST_EDITBOX_HEIGHT = 370
	
	local CONST_EDITBOX_BUTTON_WIDTH = 80
	local CONST_EDITBOX_BUTTON_HEIGHT = 20
	
	local CONST_BUTTON_TEMPLATE = gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	local CONST_TEXTENTRY_TEMPLATE = gump:GetTemplate ("button", "OPTIONS_BUTTON_TEMPLATE")
	
	gump:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BUTTONS", 
		{
			icon = {texture = [[Interface\BUTTONS\UI-GuildButton-PublicNote-Up]]},
			width = 160,
		}, 
		"DETAILS_PLUGIN_BUTTON_TEMPLATE"
	)
	
	gump:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_REGULAR_BUTTON", 
		{
			width = 130,
		}, 
		"DETAILS_PLUGIN_BUTTON_TEMPLATE"
	)
	
	gump:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, 0.6},
		backdropbordercolor = {0, 0, 0, 1},
	})
	gump:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_EXPANDED", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, 1},
		backdropbordercolor = {0, 0, 0, 1},
	})
	gump:InstallTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_BUTTON", {
		backdrop = {edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tileSize = 64, tile = true},
		backdropcolor = {.2, .2, .2, 1},
		backdropbordercolor = {0, 0, 0, 1},
	})
	
	gump:NewColor ("DETAILS_CUSTOMDISPLAY_ICON", .7, .6, .5, 1)
	
	local CONST_CODETEXTENTRY_TEMPLATE = gump:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX")
	local CONST_CODETEXTENTRYEXPANDED_TEMPLATE = gump:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_EXPANDED")
	local CONST_CODETEXTENTRYBUTTON_TEMPLATE = gump:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BOX_BUTTON")
	local CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE = gump:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_CODE_BUTTONS")
	local CONST_REGULAR_BUTTON_TEMPLATE = gump:GetTemplate ("button", "DETAILS_CUSTOMDISPLAY_REGULAR_BUTTON")
	
	local atributos = _detalhes.atributos
	local sub_atributos = _detalhes.sub_atributos

	local CLASS_ICON_TCOORDS = _G.CLASS_ICON_TCOORDS

	local class_type_dano = _detalhes.atributos.dano
	local class_type_misc = _detalhes.atributos.misc
	
	local object_keys = {
		["name"] = true,
		["icon"] = true,
		["attribute"] = true,
		["spellid"] = true,
		["author"] = true,
		["desc"] = true,
		["source"] = true,
		["target"] = true,
		["script"] = true,
		["tooltip"] = true,
	}
	
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--> create the window
	
	function _detalhes:CloseCustomDisplayWindow()
	
		--> cancel editing or creation
		if (DetailsCustomPanel.CodeEditing) then
			DetailsCustomPanel:CancelFunc()
		end
		if (DetailsCustomPanel.IsEditing) then
			DetailsCustomPanel:CancelFunc()
		end
		
		DetailsCustomPanel:Reset()
		DetailsCustomPanel:ClearFocus()
		
		--> hide the frame
		_G.DetailsCustomPanel:Hide()
	end
	
	function _detalhes:InitializeCustomDisplayWindow()
		local DetailsCustomPanel = CreateFrame ("frame", "DetailsCustomPanel", UIParent)
		DetailsCustomPanel.Frame = DetailsCustomPanel
		DetailsCustomPanel.__name = "Custom Displays"
		DetailsCustomPanel.real_name = "DETAILS_CUSTOMDISPLAY"
		--DetailsCustomPanel.__icon = [[Interface\FriendsFrame\UI-FriendsList-Small-Up]]
		DetailsCustomPanel.__icon = [[Interface\AddOns\Details\images\icons]]
		DetailsCustomPanel.__iconcoords = {412/512, 441/512, 43/512, 79/512}
		DetailsCustomPanel.__iconcolor = "DETAILS_CUSTOMDISPLAY_ICON"
		DetailsPluginContainerWindow.EmbedPlugin (DetailsCustomPanel, DetailsCustomPanel, true)
	
		function DetailsCustomPanel.RefreshWindow()
			_detalhes:OpenCustomDisplayWindow()
		end
	end
	
	function _detalhes:OpenCustomDisplayWindow()
	
		if (not _G.DetailsCustomPanel or not DetailsCustomPanel.Initialized) then
		
		DetailsPluginContainerWindow.OpenPlugin (DetailsCustomPanel)
	
			local GameCooltip = GameCooltip
			DetailsCustomPanel.Initialized = true
	
			--> main frame
			local custom_window = DetailsCustomPanel or _CreateFrame ("frame", "DetailsCustomPanel", UIParent)
			local f = custom_window
			
			custom_window:SetPoint ("center", UIParent, "center")
			custom_window:SetSize (850, 500)
			custom_window:EnableMouse (true)
			custom_window:SetMovable (true)
			custom_window:SetScript ("OnMouseDown", function (self, button)
				if (button == "LeftButton") then
					if (not self.moving) then
						self.moving = true
						self:StartMoving()
					end
				elseif (button == "RightButton") then
					if (not self.moving) then
						_detalhes:CloseCustomDisplayWindow()
					end
				end
			end)
			custom_window:SetScript ("OnMouseUp", function (self)
				if (self.moving) then
					self.moving = false
					self:StopMovingOrSizing()
				end
			end)
			custom_window:SetScript ("OnShow", function()
				GameCooltip:Hide()
			end)
			
			tinsert (UISpecialFrames, "DetailsCustomPanel")

			
			--> menu title bar
				local titlebar = CreateFrame ("frame", nil, f)
				titlebar:SetPoint ("topleft", f, "topleft", 2, -3)
				titlebar:SetPoint ("topright", f, "topright", -2, -3)
				titlebar:SetHeight (20)
				titlebar:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
				titlebar:SetBackdropColor (.5, .5, .5, 1)
				titlebar:SetBackdropBorderColor (0, 0, 0, 1)
				
			--> menu title
				local titleLabel = _detalhes.gump:NewLabel (titlebar, titlebar, nil, "titulo", "Details! Custom Displays", "GameFontNormal", 12)
				titleLabel:SetPoint ("center", titlebar , "center")
				titleLabel:SetPoint ("top", titlebar , "top", 0, -4)
				
			--> close button
				f.Close = CreateFrame ("button", "$parentCloseButton", f)
				f.Close:SetPoint ("right", titlebar, "right", -2, 0)
				f.Close:SetSize (16, 16)
				f.Close:SetNormalTexture (_detalhes.gump.folder .. "icons")
				f.Close:SetHighlightTexture (_detalhes.gump.folder .. "icons")
				f.Close:SetPushedTexture (_detalhes.gump.folder .. "icons")
				f.Close:GetNormalTexture():SetTexCoord (0, 16/128, 0, 1)
				f.Close:GetHighlightTexture():SetTexCoord (0, 16/128, 0, 1)
				f.Close:GetPushedTexture():SetTexCoord (0, 16/128, 0, 1)
				f.Close:SetAlpha (0.7)
				f.Close:SetScript ("OnClick", function() _detalhes:CloseCustomDisplayWindow() end)			
				f.Close:SetScript ("OnHide", function()
					_detalhes:CloseCustomDisplayWindow()
				end)
			
			--> background
				f.bg1 = f:CreateTexture (nil, "background")
				f.bg1:SetTexture ([[Interface\AddOns\Details\images\background]], true)
				f.bg1:SetAlpha (0.7)
				f.bg1:SetVertexColor (0.27, 0.27, 0.27)
				f.bg1:SetVertTile (true)
				f.bg1:SetHorizTile (true)
				f.bg1:SetAllPoints()
				
				f:SetBackdrop ({edgeFile = [[Interface\Buttons\WHITE8X8]], edgeSize = 1, bgFile = [[Interface\AddOns\Details\images\background]], tileSize = 64, tile = true})
				f:SetBackdropColor (.5, .5, .5, .5)
				f:SetBackdropBorderColor (0, 0, 0, 1)

			DetailsCustomPanel.BoxType = 1
			DetailsCustomPanel.IsEditing = false
			DetailsCustomPanel.IsImporting = false
			DetailsCustomPanel.CodeEditing = false
			DetailsCustomPanel.current_attribute = "damagedone"
			
			DetailsCustomPanel.code1_default = [[
							--get the parameters passed
							local Combat, CustomContainer, Instance = ...
							--declade the values to return
							local total, top, amount = 0, 0, 0
							
							--do the loop
								--CustomContainer:AddValue (actor, actor.value)
							--loop end
							
							--if not managed inside the loop, get the values of total, top and amount
							total, top = CustomContainer:GetTotalAndHighestValue()
							amount = CustomContainer:GetNumActors()
							
							--return the values
							return total, top, amount
						]]
			DetailsCustomPanel.code1 = DetailsCustomPanel.code1_default
			
			DetailsCustomPanel.code2_default = [[
							--get the parameters passed
							local actor, combat, instance = ...
							
							--get the cooltip object (we dont use the convencional GameTooltip here)
							local GameCooltip = GameCooltip
							
							--Cooltip code
						]]
			DetailsCustomPanel.code2 = DetailsCustomPanel.code2_default
			
			DetailsCustomPanel.code3_default = [[
							local value, top, total, combat, instance = ...
							return math.floor (value)
						]]
			DetailsCustomPanel.code3 = DetailsCustomPanel.code3_default
			
			DetailsCustomPanel.code4_default = [[
							local value, top, total, combat, instance = ...
							return string.format ("%.1f", value/total*100)
						]]
			DetailsCustomPanel.code4 = DetailsCustomPanel.code4_default
			
			function DetailsCustomPanel:ClearFocus()
				custom_window.desc_field:ClearFocus()
				custom_window.name_field:ClearFocus()
				custom_window.author_field:ClearFocus()
			end
			
			function DetailsCustomPanel:Reset()
				self.name_field:SetText ("")
				self.icon_image:SetTexture ([[Interface\ICONS\TEMP]])
				self.desc_field:SetText ("")
				
				self.author_field:SetText (UnitName ("player") .. "-" .. GetRealmName())
				self.author_field:Enable()
				
				self.source_dropdown:Select (1, true)
				self.source_field:SetText ("")
				
				self.target_dropdown:Select (1, true)
				self.target_field:SetText ("")
				
				self.spellid_entry:SetText ("")
				
				DetailsCustomPanel.code1 = DetailsCustomPanel.code1_default
				DetailsCustomPanel.code2 = DetailsCustomPanel.code2_default
				DetailsCustomPanel.code3 = DetailsCustomPanel.code3_default
				DetailsCustomPanel.code4 = DetailsCustomPanel.code4_default
				
				DetailsCustomPanel.current_attribute = "damagedone"
				DetailsCustomPanelAttributeMenu1:Click()
				
				DetailsCustomPanel:ClearFocus()
			end
			
			function DetailsCustomPanel:RemoveDisplay (custom_object, index)
				table.remove (_detalhes.custom, index)
				
				for _, instance in _ipairs (_detalhes.tabela_instancias) do 
					if (instance.atributo == 5 and instance.sub_atributo == index) then 
						instance:ResetAttribute()
					elseif (instance.atributo == 5 and instance.sub_atributo > index) then
						instance.sub_atributo = instance.sub_atributo - 1
						instance.sub_atributo_last [5] = 1
					else
						instance.sub_atributo_last [5] = 1
					end
				end
				
				_detalhes.switch:OnRemoveCustom (index)
				_detalhes:ResetCustomFunctionsCache()
			end
			
			function DetailsCustomPanel:StartEdit (custom_object, import)
				
				DetailsCustomPanel:Reset()
				DetailsCustomPanel:ClearFocus()
				
				DetailsCustomPanel.IsEditing = custom_object
				DetailsCustomPanel.IsImporting = import
				
				self.name_field:SetText (custom_object:GetName())
				self.desc_field:SetText (custom_object:GetDesc())
				self.icon_image:SetTexture (custom_object:GetIcon())
				
				self.author_field:SetText (custom_object:GetAuthor())
				self.author_field:Disable()
				
				custom_window.codeeditor:SetText ("")
				
				if (custom_object:IsScripted()) then
				
					custom_window.script_button_attribute:Click()
				
					DetailsCustomPanel.code1 = custom_object:GetScript()
					DetailsCustomPanel.code2 = custom_object:GetScriptToolip()
					DetailsCustomPanel.code3 = custom_object:GetScriptTotal() or DetailsCustomPanel.code3_default
					DetailsCustomPanel.code4 = custom_object:GetScriptPercent() or DetailsCustomPanel.code4_default
				
				else
				
					local attribute = custom_object:GetAttribute()
					if (attribute == "damagedone") then
						DetailsCustomPanelAttributeMenu1:Click()
					elseif (attribute == "healdone") then
						DetailsCustomPanelAttributeMenu2:Click()
					end
				
					local source = custom_object:GetSource()
					if (source == "[all]") then
						self.source_dropdown:Select (1, true)
						self.source_field:SetText ("")
						self.source_field:Disable()
					elseif (source == "[raid]") then
						self.source_dropdown:Select (2, true)
						self.source_field:SetText ("")
						self.source_field:Disable()
					elseif (source == "[player]") then
						self.source_dropdown:Select (3, true)
						self.source_field:SetText ("")
						self.source_field:Disable()
					else
						self.source_dropdown:Select (4, true)
						self.source_field:SetText (source)
						self.source_field:Enable()
					end
					
					local target = custom_object:GetTarget()
					
					if (not target) then
						self.target_dropdown:Select (5, true)
						self.target_field:SetText ("")
						self.target_field:Disable()
					elseif (target == "[all]") then
						self.target_dropdown:Select (1, true)
						self.target_field:SetText ("")
						self.target_field:Disable()
					elseif (target == "[raid]") then
						self.target_dropdown:Select (2, true)
						self.target_field:SetText ("")
						self.target_field:Disable()
					elseif (target == "[player]") then
						self.target_dropdown:Select (3, true)
						self.target_field:SetText ("")
						self.target_field:Disable()
					else
						self.target_dropdown:Select (4, true)
						self.target_field:SetText (target)
						self.target_field:Enable()
					end
					
					self.spellid_entry:SetText (custom_object:GetSpellId() or "")
					
				end
				
				if (import) then
					DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_IMPORT_BUTTON"])
				else
					DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_SAVE"])
				end
			end
			
			function DetailsCustomPanel:CreateNewCustom()
			
				local name = self.name_field:GetText()
				DetailsCustomPanel:ClearFocus()
				_detalhes.MicroButtonAlert:Hide()
				
				if (string.len (name) < 5) then
					return false, _detalhes:Msg (Loc ["STRING_CUSTOM_SHORTNAME"])
				elseif (string.len (name) > 32) then
					return false, _detalhes:Msg (Loc ["STRING_CUSTOM_LONGNAME"])
				end
				
				_detalhes:ResetCustomFunctionsCache()

				local icon = self.icon_image:GetTexture()
				local desc = self.desc_field:GetText()
				local author = self.author_field:GetText()
				
				if (DetailsCustomPanel.BoxType == 1) then
					local source = self.source_dropdown:GetValue()
					local target = self.target_dropdown:GetValue()
					local spellid = self.spellid_entry:GetText()
					
					if (not source) then
						source = self.source_field:GetText()
					end
					
					if (not target) then
						target = self.target_field:GetText()
					elseif (target == "[none]") then
						target = false
					end
					
					if (spellid == "") then
						spellid = false
					end

					if (DetailsCustomPanel.IsEditing) then
						local object = DetailsCustomPanel.IsEditing
						object.name = name
						object.icon = icon
						object.desc = desc
						object.author = author
						object.attribute = DetailsCustomPanel.current_attribute
						object.source = source
						object.target = target
						object.spellid = tonumber (spellid)
						object.script = false
						object.tooltip = false

						if (DetailsCustomPanel.IsImporting) then
							_detalhes:Msg (Loc ["STRING_CUSTOM_IMPORTED"])
						else
							_detalhes:Msg (Loc ["STRING_CUSTOM_SAVED"])
						end
						
						if (DetailsCustomPanel.IsImporting) then
							tinsert (_detalhes.custom, object)
						end
						
						DetailsCustomPanel.IsEditing = false
						DetailsCustomPanel.IsImporting = false
						self.author_field:Enable()
						return true
					else
						local new_custom_object = {
							["name"] = name,
							["icon"] = icon,
							["desc"] = desc,
							["author"] = author,
							["attribute"] = DetailsCustomPanel.current_attribute,
							["source"] = source,
							["target"] = target,
							["spellid"] = tonumber (spellid),
							["script"] = false,
							["tooltip"] = false,
						}

						tinsert (_detalhes.custom, new_custom_object)
						_setmetatable (new_custom_object, _detalhes.atributo_custom)
						new_custom_object.__index = _detalhes.atributo_custom
						_detalhes:Msg (Loc ["STRING_CUSTOM_CREATED"])
					end
					
					DetailsCustomPanel:Reset()
					
				elseif (DetailsCustomPanel.BoxType == 2) then
					
					local main_code = DetailsCustomPanel.code1
					local tooltip_code = DetailsCustomPanel.code2
					local total_code = DetailsCustomPanel.code3
					local percent_code = DetailsCustomPanel.code4
					
					if (DetailsCustomPanel.IsEditing) then
						local object = DetailsCustomPanel.IsEditing
						object.name = name
						object.icon = icon
						object.desc = desc
						object.author = author
						object.attribute = false
						object.source = false
						object.target = false
						object.spellid = false
						object.script = main_code
						object.tooltip = tooltip_code
						
						if (total_code ~= DetailsCustomPanel.code3_default) then
							object.total_script = total_code
						else
							object.total_script = false
						end
						
						if (percent_code ~= DetailsCustomPanel.code4_default) then
							object.percent_script = percent_code
						else
							object.percent_script = false
						end
						
						if (DetailsCustomPanel.IsImporting) then
							_detalhes:Msg (Loc ["STRING_CUSTOM_IMPORTED"])
						else
							_detalhes:Msg (Loc ["STRING_CUSTOM_SAVED"])
						end
						
						if (DetailsCustomPanel.IsImporting) then
							tinsert (_detalhes.custom, object)
						end
						
						DetailsCustomPanel.IsEditing = false
						DetailsCustomPanel.IsImporting = false
						self.author_field:Enable()
						return true
					else
						local new_custom_object = {
							["name"] = name,
							["icon"] = icon,
							["desc"] = desc,
							["author"] = author,
							["attribute"] = false,
							["source"] = false,
							["target"] = false,
							["spellid"] = false,
							["script"] = main_code,
							["tooltip"] = tooltip_code,
						}
						
						local total_code = DetailsCustomPanel.code3
						local percent_code = DetailsCustomPanel.code4
						
						if (total_code ~= DetailsCustomPanel.code3_default) then
							new_custom_object.total_script = total_code
						else
							new_custom_object.total_script = false
						end
						
						if (percent_code ~= DetailsCustomPanel.code4_default) then
							new_custom_object.percent_script = percent_code
						else
							new_custom_object.percent_script = false
						end
						
						tinsert (_detalhes.custom, new_custom_object)
						_setmetatable (new_custom_object, _detalhes.atributo_custom)
						new_custom_object.__index = _detalhes.atributo_custom
						_detalhes:Msg (Loc ["STRING_CUSTOM_CREATED"])
					end
					
					DetailsCustomPanel:Reset()
					
				end

			end
			
			function DetailsCustomPanel:AcceptFunc()
				
				_detalhes.MicroButtonAlert:Hide()
				
				if (DetailsCustomPanel.CodeEditing) then
					--> close the edit box saving the text
					if (DetailsCustomPanel.CodeEditing == 1) then
						DetailsCustomPanel.code1 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 2) then
						DetailsCustomPanel.code2 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 3) then
						DetailsCustomPanel.code3 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 4) then
						DetailsCustomPanel.code4 = custom_window.codeeditor:GetText()
					end
					
					DetailsCustomPanel.CodeEditing = false
					
					if (DetailsCustomPanel.IsImporting) then
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_IMPORT_BUTTON"])
					elseif (DetailsCustomPanel.IsEditing) then
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_SAVE"])
					else
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_CREATE"])
					end
					custom_window.codeeditor:Hide()
				
				elseif (DetailsCustomPanel.IsEditing) then
				
					local succesful_edit = DetailsCustomPanel:CreateNewCustom()
					if (succesful_edit) then
						DetailsCustomPanel.IsEditing = false
						DetailsCustomPanel.IsImporting = false
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_CREATE"])
						DetailsCustomPanel:Reset()
					end
				else
					DetailsCustomPanel:CreateNewCustom()
				end
				
			end
			
			function DetailsCustomPanel:CancelFunc()
				
				DetailsCustomPanel:ClearFocus()
				_detalhes.MicroButtonAlert:Hide()
				
				if (DetailsCustomPanel.CodeEditing) then
					--> close the edit box without save
					custom_window.codeeditor:Hide()
					DetailsCustomPanel.CodeEditing = false
					
					if (DetailsCustomPanel.IsImporting) then
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_IMPORT_BUTTON"])
					elseif (DetailsCustomPanel.IsEditing) then
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_SAVE"])
					else
						DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_CREATE"])
					end
					
				elseif (DetailsCustomPanel.IsEditing) then
					DetailsCustomPanel.IsEditing = false
					DetailsCustomPanel.IsImporting = false
					DetailsCustomPanel:SetAcceptButtonText (Loc ["STRING_CUSTOM_CREATE"])
					DetailsCustomPanel:Reset()
					
				else
					_detalhes:CloseCustomDisplayWindow()
				end
				
			end
			
			function DetailsCustomPanel:SetAcceptButtonText (text)
				custom_window.box0.acceptbutton:SetText (text)
			end

			function select_attribute (self)
			
				if (not self.attribute_table) then
					return
				end
				
				DetailsCustomPanel:ClearFocus()
				
				custom_window.selected_left:SetPoint ("topleft", self, "topleft")
				custom_window.selected_right:SetPoint ("topright", self, "topright")
				
				DetailsCustomPanel.current_attribute = self.attribute_table.attribute
			
				if (not self.attribute_table.attribute) then
					--is scripted
					DetailsCustomPanel.BoxType = 2
					custom_window.box1:Hide()
					custom_window.box2:Show()

				else
					--no scripted
					--> check if is editing the code
					if (DetailsCustomPanel.CodeEditing) then
						DetailsCustomPanel.AcceptFunc()
					end
					
					DetailsCustomPanel.BoxType = 1
					custom_window.box1:Show()
					custom_window.box2:Hide()
					custom_window.codeeditor:Hide()
				end
			end

			function DetailsCustomPanel.StartEditCode (_, _, code)
				if (code == 1) then --> edit main code
				
					custom_window.codeeditor:SetText (DetailsCustomPanel.code1)
					
				elseif (code == 2) then --> edit tooltip code
				
					custom_window.codeeditor:SetText (DetailsCustomPanel.code2)
				
				elseif (code == 3) then --> edit total code
				
					custom_window.codeeditor:SetText (DetailsCustomPanel.code3)
					
				elseif (code == 4) then --> edit percent code
				
					custom_window.codeeditor:SetText (DetailsCustomPanel.code4)
				
				end
				
				custom_window.codeeditor:Show()
				DetailsCustomPanel.CodeEditing = code
				
				DetailsCustomPanel:SetAcceptButtonText ("Save Code") --Loc ["STRING_CUSTOM_DONE"]
			end

			--> left menu
			custom_window.menu = {}
			local menu_start = -50
			local menu_up_frame = _CreateFrame ("frame", nil, custom_window)
			menu_up_frame:SetFrameLevel (custom_window:GetFrameLevel()+2)
			
			local onenter = function (self)
				--self.icontexture:SetVertexColor (1, 1, 1, 1)
			end
			local onleave = function (self)
				--self.icontexture:SetVertexColor (.9, .9, .9, 1)
			end
			
			function custom_window:CreateMenuButton (label, icon, clickfunc, param1, param2, tooltip, name, coords)
				local index = #custom_window.menu+1

				local button = gump:NewButton (self, nil, "$parent" .. name, nil, CONST_MENU_WIDTH, CONST_MENU_HEIGHT, clickfunc, param1, param2, nil, label)
				button:SetPoint ("topleft", self, "topleft", CONST_MENU_X_POSITION, CONST_MENU_Y_POSITION + ((index-1)*-23))
				
				--button:SetTemplate (CONST_BUTTON_TEMPLATE)
				button:SetTemplate (gump:GetTemplate ("button", "DETAILS_PLUGIN_BUTTON_TEMPLATE"))
				button:SetWidth (160)
				button:SetIcon (icon, CONST_MENU_HEIGHT-4, CONST_MENU_HEIGHT-4, "overlay", {.1, .9, .1, .9}, nil, 4)
				
				button:SetHook ("OnEnter", onenter)
				button:SetHook ("OnLeave", onleave)
				button.widget.icontexture = texture
				button.tooltip = tooltip

				custom_window.menu [index] = {circle = circle, icon = texture, button = button}
			end
			
			local build_menu = function (self, button, func, param2)
				GameCooltip:Reset()
				
				for index, custom_object in _ipairs (_detalhes.custom) do
					GameCooltip:AddLine (custom_object:GetName())
					GameCooltip:AddIcon (custom_object:GetIcon())
					GameCooltip:AddMenu (1, func, custom_object, index, true)
				end
				
				GameCooltip:SetOption ("ButtonsYMod", -2)
				GameCooltip:SetOption ("YSpacingMod", 0)
				GameCooltip:SetOption ("TextHeightMod", 0)
				GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
				GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
				
				GameCooltip:SetBackdrop (1, _detalhes.tooltip_backdrop, nil, _detalhes.tooltip_border_color)
				GameCooltip:SetBackdrop (2, _detalhes.tooltip_backdrop, nil, _detalhes.tooltip_border_color)
				
				GameCooltip:SetType ("menu")
				GameCooltip:SetHost (self, "left", "right", -7, 0)
				GameCooltip:Show()
			end
			
			--> edit button
			local start_edit = function (_, _, custom_object, index)
				GameCooltip:Hide()
				DetailsCustomPanel:StartEdit (custom_object)
			end
			custom_window:CreateMenuButton (Loc ["STRING_CUSTOM_EDIT"], "Interface\\ICONS\\INV_Inscription_RunescrollOfFortitude_Red", build_menu, start_edit, nil, nil, "Edit", {0.07, 0.93, 0.07, 0.93})
			
			--> remove button
			local remove_display = function (_, _, custom_object, index)
				GameCooltip:Hide()
				DetailsCustomPanel:RemoveDisplay (custom_object, index)
			end
			custom_window:CreateMenuButton (Loc ["STRING_CUSTOM_REMOVE"], "Interface\\ICONS\\Spell_BrokenHeart", build_menu, remove_display, nil, nil, "Remove", {1, 0, 0, 1})
			
			--> export button
			local export_display = function (_, _, custom_object, index)
				GameCooltip:Hide()

				local export_object = {}
				
				for key, value in pairs (custom_object) do
					if (object_keys [key]) then
						if (type (value) == "table") then
							export_object [key] = table_deepcopy (value)
						else
							export_object [key] = value
						end
					end
				end
				
				local encoded = Details:CompressData (export_object, "print")
				
				if (not custom_window.ExportBox) then
					local editbox = _detalhes.gump:NewTextEntry (custom_window, nil, "$parentExportBox", "ExportBox", CONST_EDITBOX_WIDTH, 20)
					editbox:SetPoint ("bottomleft", custom_window, "bottomleft", 10, 6)
					editbox:SetAutoFocus (false)
					editbox:SetTemplate (CONST_TEXTENTRY_TEMPLATE)
					editbox:SetHook ("OnEditFocusLost", function() 
						editbox:Hide()
					end)
					editbox:SetHook ("OnChar", function() 
						editbox:Hide()
					end)
					
					local flashTexture = editbox:CreateTexture (nil, "overlay")
					flashTexture:SetColorTexture (1, 1, 1)
					flashTexture:SetAllPoints()
					flashTexture:SetAlpha (0)
					
					local flashAnimHub = DetailsFramework:CreateAnimationHub (flashTexture)
					DetailsFramework:CreateAnimation (flashAnimHub, "alpha", 1, 0.2, 0, 1)
					DetailsFramework:CreateAnimation (flashAnimHub, "alpha", 2, 0.2, 1, 0)
					editbox.FlashAnimation = flashAnimHub
				end
				
				if (custom_window.ImportBox) then
					custom_window.ImportBox:Hide()
					custom_window.exportLabel:Hide()
					custom_window.ImportConfirm:Hide()
				end
				
				custom_window.ExportBox:Show()
				custom_window.ExportBox:SetText (encoded)
				custom_window.ExportBox:HighlightText()
				custom_window.ExportBox:SetFocus()
				
				custom_window.ExportBox.FlashAnimation:Play()
				
			end
			custom_window:CreateMenuButton (Loc ["STRING_CUSTOM_EXPORT"], "Interface\\ICONS\\INV_Misc_Gift_01", build_menu, export_display, nil, nil, "Export", {0.00, 0.9, 0.07, 0.93}) --> localize

			--> import buttonRaceChange
			local import_display = function (_, _, custom_object, index)
				GameCooltip:Hide()
				
				if (not custom_window.ImportBox) then
				
					local export_string = gump:NewLabel (custom_window, custom_window, "$parenImportLabel", "exportLabel", "Import String:", "GameFontNormal") --Loc ["STRING_CUSTOM_PASTE"]
					export_string:SetPoint ("bottomleft", DetailsCustomPanel, "bottomleft", 10, 8)
					
					local editbox = _detalhes.gump:NewTextEntry (custom_window, nil, "$parentImportBox", "ImportBox", CONST_EDITBOX_WIDTH - export_string.width - CONST_EDITBOX_BUTTON_WIDTH - 4, 20)
					editbox:SetPoint ("left", export_string, "right", 2, 0)
					editbox:SetAutoFocus (false)
					editbox:SetTemplate (CONST_TEXTENTRY_TEMPLATE)
					
					local import = function()
						local text = editbox:GetText()
						
						local deserialized_object = Details:DecompressData (text, "print")
						
						if (not deserialized_object) then
							_detalhes:Msg (Loc ["STRING_CUSTOM_IMPORT_ERROR"])
							return						
						end
						
						if (DetailsCustomPanel.CodeEditing) then
							DetailsCustomPanel:CancelFunc()
						end

						setmetatable (deserialized_object, _detalhes.atributo_custom)
						deserialized_object.__index = _detalhes.atributo_custom
						
						_detalhes.MicroButtonAlert.Text:SetText (Loc ["STRING_CUSTOM_IMPORT_ALERT"])
						_detalhes.MicroButtonAlert:SetPoint ("bottom", custom_window.box0.acceptbutton.widget, "top", 0, 20)
						_detalhes.MicroButtonAlert:SetHeight (200)
						_detalhes.MicroButtonAlert:Show()
						
						DetailsCustomPanel:StartEdit (deserialized_object, true)
						
						custom_window.ImportBox:ClearFocus()
						custom_window.ImportBox:Hide()
						custom_window.exportLabel:Hide()
						custom_window.ImportConfirm:Hide()
					end
					
					local okey_button = gump:NewButton (custom_window, nil, "$parentImportConfirm", "ImportConfirm", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, import, nil, nil, nil, Loc ["STRING_CUSTOM_IMPORT_BUTTON"])
					okey_button:SetTemplate (CONST_BUTTON_TEMPLATE)
					okey_button:SetPoint ("left", editbox, "right", 2, 0)
				end
				
				if (custom_window.ExportBox) then
					custom_window.ExportBox:Hide()
				end
				
				custom_window.ImportBox:SetText ("")
				custom_window.ImportBox:Show()
				custom_window.exportLabel:Show()
				custom_window.ImportConfirm:Show()
				custom_window.ImportBox:SetFocus()
				
			end
			custom_window:CreateMenuButton (Loc ["STRING_CUSTOM_IMPORT"], "Interface\\ICONS\\INV_MISC_NOTE_02", import_display, nil, nil, nil, "Import", {0.00, 0.9, 0.07, 0.93}) --> localize
			
			local box_types = {
				{}, --normal
				{}, --custom script
			}
			
			local attributes = {
				--{icon = [[Interface\ICONS\Spell_Fire_Fireball02]], label = Loc ["STRING_CUSTOM_ATTRIBUTE_DAMAGE"], box = 1, attribute = "damagedone", boxtype = 1},
				--{icon = [[Interface\ICONS\SPELL_NATURE_HEALINGTOUCH]], label = Loc ["STRING_CUSTOM_ATTRIBUTE_HEAL"], box = 1, attribute = "healdone", boxtype = 1},
				{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = Loc ["STRING_CUSTOM_ATTRIBUTE_SCRIPT"], box = 2, attribute = false, boxtype = 2},
				
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
				--{icon = [[Interface\ICONS\INV_Inscription_Scroll]], label = "Custom Script", box = 2, attribute = false, boxtype = 2},
			}
			
			--> create box
			local attribute_box = _CreateFrame ("frame", nil, custom_window)
			attribute_box:SetPoint ("topleft", custom_window, "topleft", 200, -60)
			attribute_box:SetSize (180, 260)
			attribute_box:Hide()
			
			local button_onenter = function (self)
				self:SetBackdropColor (.3, .3, .3, .3)
				self.icon:SetBlendMode ("ADD")
			end
			local button_onleave = function (self)
				self:SetBackdropColor (0, 0, 0, .2)
				self.icon:SetBlendMode ("BLEND")
			end
			
			local selected_left = attribute_box:CreateTexture (nil, "overlay")
			selected_left:SetTexture ([[Interface\Store\Store-Main]])
			selected_left:SetSize (50, 20)
			selected_left:SetVertexColor (1, .8, 0, 1)
			selected_left:SetTexCoord (960/1024, 1020/1024, 68/1024, 101/1024)
			custom_window.selected_left = selected_left
			
			local selected_right = attribute_box:CreateTexture (nil, "overlay")
			selected_right:SetTexture ([[Interface\Store\Store-Main]])
			selected_right:SetSize (31, 20)
			selected_right:SetVertexColor (1, .8, 0, 1)
			selected_right:SetTexCoord (270/1024, 311/1024, 873/1024, 906/1024)
			custom_window.selected_right = selected_right
			
			local selected_center = attribute_box:CreateTexture (nil, "overlay")
			selected_center:SetTexture ([[Interface\Store\Store-Main]])
			selected_center:SetSize (49, 20)
			selected_center:SetVertexColor (1, .8, 0, 1)
			selected_center:SetTexCoord (956/1024, 1004/1024, 164/1024, 197/1024)
			
			selected_center:SetPoint ("left", selected_left, "right")
			selected_center:SetPoint ("right", selected_right, "left")
			
			local p = 0.0625 --> 32/512
			
			for i = 1, 10 do
			
				if (attributes [i]) then
			
					local button = _CreateFrame ("button", "DetailsCustomPanelAttributeMenu" .. i, attribute_box)
					button:SetPoint ("topleft", attribute_box, "topleft", 2, ((i-1)*23*-1) + (-26))
					button:SetPoint ("topright", attribute_box, "topright", 2, ((i-1)*23*-1) + (-26))
					button:SetHeight (20)
					
					button:SetBackdrop ({bgFile = [[Interface\Tooltips\UI-Tooltip-Background]], tile = true, tileSize = 16})
					button:SetBackdropColor (0, 0, 0, .2)
					
					button:SetScript ("OnEnter", button_onenter)
					button:SetScript ("OnLeave", button_onleave)
					
					button.attribute_table = attributes [i]
					
					if (attributes [i] and not attributes [i].attribute) then
						custom_window.script_button_attribute = button
					end
					
					button:SetScript ("OnClick", select_attribute)
					
					button.icon = button:CreateTexture (nil, "overlay")
					button.icon:SetPoint ("left", button, "left", 6, 0)
					button.icon:SetSize (22, 22)
					button.icon:SetTexture ([[Interface\AddOns\Details\images\custom_icones]])
					button.icon:SetTexCoord (p*(i-1), p*(i), 0, 1)
					
					button.text = button:CreateFontString (nil, "overlay", "GameFontHighlightSmall")
					button.text:SetPoint ("left", button.icon, "right", 4, 0)
					button.text:SetText (attributes [i] and attributes [i].label or "")
					button.text:SetTextColor (.9, .9, .9, 1)
				
				end
			end
			
			--> create box 0, holds the name, author, desc and icon
			local box0 = _CreateFrame ("frame", "DetailsCustomPanelBox0", custom_window)
			custom_window.box0 = box0
			box0:SetSize (450, 360)

			box0:SetPoint ("topleft", custom_window, "topleft", CONST_INFOBOX_X_POSITION, CONST_MENU_Y_POSITION-4)
			
			--name
				local name_label = gump:NewLabel (box0, box0, "$parenNameLabel", "name", Loc ["STRING_CUSTOM_NAME"], "GameFontHighlightLeft") --> localize-me
				name_label:SetPoint ("topleft", box0, "topleft", 10, 0)
				
				local name_field = gump:NewTextEntry (box0, nil, "$parentNameEntry", "nameentry", 200, 20)
				name_field:SetPoint ("left", name_label, "left", 62, 0)
				name_field:SetTemplate (CONST_TEXTENTRY_TEMPLATE)
				name_field.tooltip = Loc ["STRING_CUSTOM_NAME_DESC"]
				custom_window.name_field = name_field
				
			--author
				local author_label = gump:NewLabel (box0, box0, "$parenAuthorLabel", "author", Loc ["STRING_CUSTOM_AUTHOR"], "GameFontHighlightLeft") --> localize-me
				author_label:SetPoint ("topleft", name_label, "bottomleft", 0, -12)
				
				local author_field = gump:NewTextEntry (box0, nil, "$parentAuthorEntry", "authorentry", 200, 20)
				author_field:SetPoint ("left", author_label, "left", 62, 0)
				author_field:SetTemplate (CONST_TEXTENTRY_TEMPLATE)
				author_field.tooltip = Loc ["STRING_CUSTOM_AUTHOR_DESC"]
				author_field:SetText (UnitName ("player") .. "-" .. GetRealmName())
				custom_window.author_field = author_field
				
			--description
				local desc_label = gump:NewLabel (box0, box0, "$parenDescLabel", "desc", Loc ["STRING_CUSTOM_DESCRIPTION"], "GameFontHighlightLeft") --> localize-me
				desc_label:SetPoint ("topleft", author_label, "bottomleft", 0, -12)
				
				local desc_field = gump:NewTextEntry (box0, nil, "$parentDescEntry", "descentry", 200, 20)
				desc_field:SetPoint ("left", desc_label, "left", 62, 0)
				desc_field:SetTemplate (CONST_TEXTENTRY_TEMPLATE)
				desc_field.tooltip = Loc ["STRING_CUSTOM_DESCRIPTION_DESC"]
				custom_window.desc_field = desc_field

			--icon
				local icon_label = gump:NewLabel (box0, box0, "$parenIconLabel", "icon", Loc ["STRING_CUSTOM_ICON"], "GameFontHighlightLeft") --> localize-me
				icon_label:SetPoint ("topleft", desc_label, "bottomleft", 0, -12)
				
				local pickicon_callback = function (texture)
					box0.icontexture:SetTexture (texture)
					
				end
				local pickicon = function()
					gump:IconPick (pickicon_callback, true)
				end
				local icon_image = gump:NewImage (box0, [[Interface\ICONS\TEMP]], 20, 20, nil, nil, "icontexture", "$parentIconTexture")
				local icon_button = gump:NewButton (box0, nil, "$parentIconButton", "IconButton", 20, 20, pickicon)
				icon_button:InstallCustomTexture()
				icon_button:SetPoint ("left", icon_label, "left", 64, 0)
				icon_image:SetPoint ("left", icon_label, "left", 64, 0)
				custom_window.icon_image = icon_image

			--cancel
				local cancel_button = gump:NewButton (box0, nil, "$parentCancelButton", "cancelbutton", 130, 20, DetailsCustomPanel.CancelFunc, nil, nil, nil, Loc ["STRING_CUSTOM_CANCEL"])
				--cancel_button:SetPoint ("bottomleft", attribute_box, "bottomleft", 2, 0)
				cancel_button:SetPoint ("topleft", icon_label, "bottomleft", 0, -10)
				cancel_button:SetTemplate (CONST_REGULAR_BUTTON_TEMPLATE)
				
			--accept
				local accept_button = gump:NewButton (box0, nil, "$parentAcceptButton", "acceptbutton", 130, 20, DetailsCustomPanel.AcceptFunc, nil, nil, nil, Loc ["STRING_CUSTOM_CREATE"])
				accept_button:SetPoint ("left", cancel_button, "right", 2, 0)
				accept_button:SetTemplate (CONST_REGULAR_BUTTON_TEMPLATE)
				
				cancel_button:SetFrameLevel (500)
				accept_button:SetFrameLevel (500)
			
			--> create box type 1
				local box1 = _CreateFrame ("frame", "DetailsCustomPanelBox1", custom_window)
				custom_window.box1 = box1
				box1:SetSize (450, 180)
				box1:SetPoint ("topleft", icon_label.widget, "bottomleft", -10, -20)
				box1:SetFrameLevel (box0:GetFrameLevel()+1)
			
				--source
					local source_label = gump:NewLabel (box1, box1, "$parenSourceLabel", "source", Loc ["STRING_CUSTOM_SOURCE"], "GameFontHighlightLeft") --> localize-me
					source_label:SetPoint ("topleft", box1, "topleft", 10, 0)
					
					local disable_source_field = function()
						box1.sourceentry:Disable()
					end
					local enable_source_field = function()
						box1.sourceentry:Enable()
						box1.sourceentry:SetFocus (true)
					end
					
					local source_icon = [[Interface\COMMON\Indicator-Yellow]]
					
					local targeting_options = {
						{value = "[all]", label = "All Characters", desc = "Search for matches in all characters.", onclick = disable_source_field, icon = source_icon},
						{value = "[raid]", label = "Raid or Party Group", desc = "Search for matches in all characters which is part of your party or raid group.", onclick = disable_source_field, icon = source_icon},
						{value = "[player]", label = "Only You", desc = "Search for matches only in your character.", onclick = disable_source_field, icon = source_icon},
						{value = false, label = "Specific Character", desc = "Type the name of the character used to search.", onclick = enable_source_field, icon = source_icon},
					}
					local build_source_list = function() return targeting_options end
					local source_dropdown = gump:NewDropDown (box1, nil, "$parentSourceDropdown", "sourcedropdown", 178, 20, build_source_list, 1)
					source_dropdown:SetPoint ("left", source_label, "left", 62, 0)
					source_dropdown.tooltip = Loc ["STRING_CUSTOM_SOURCE_DESC"]
					custom_window.source_dropdown = source_dropdown
					
					local source_field = gump:NewTextEntry (box1, nil, "$parentSourceEntry", "sourceentry", 201, 20)
					source_field:SetPoint ("topleft", source_dropdown, "bottomleft", 0, -2)
					source_field:Disable()
					custom_window.source_field = source_field
					
					local adds_boss = CreateFrame ("frame", nil, box1)
					adds_boss:SetPoint ("left", source_dropdown.widget, "right", 2, 0)
					adds_boss:SetSize (20, 20)
					
					local adds_boss_image = adds_boss:CreateTexture (nil, "overlay")
					adds_boss_image:SetPoint ("center", adds_boss)
					adds_boss_image:SetTexture ("Interface\\Buttons\\UI-MicroButton-Raid-Up")
					adds_boss_image:SetTexCoord (0.046875, 0.90625, 0.40625, 0.953125)
					adds_boss_image:SetWidth (20)
					adds_boss_image:SetHeight (16)

					local actorsFrame = gump:NewPanel (custom_window, _, "DetailsCustomActorsFrame2", "actorsFrame", 1, 1)
					actorsFrame:SetPoint ("topleft", custom_window, "topright", 5, -60)
					actorsFrame:Hide()
					
					local modelFrame = _CreateFrame ("playermodel", "DetailsCustomActorsFrame2Model", custom_window)
					modelFrame:SetSize (138, 261)
					modelFrame:SetPoint ("topright", actorsFrame.widget, "topleft", -15, -8)
					modelFrame:Hide()
					local modelFrameTexture = modelFrame:CreateTexture (nil, "background")
					modelFrameTexture:SetAllPoints()
					
					local modelFrameBackground = custom_window:CreateTexture (nil, "artwork")
					modelFrameBackground:SetSize (138, 261)
					modelFrameBackground:SetPoint ("topright", actorsFrame.widget, "topleft", -15, -8)
					modelFrameBackground:SetTexture ([[Interface\ACHIEVEMENTFRAME\UI-GuildAchievement-Parchment-Horizontal-Desaturated]])
					modelFrameBackground:SetRotation (90)
					modelFrameBackground:SetVertexColor (.5, .5, .5, 0.5)
					
					local modelFrameBackgroundIcon = custom_window:CreateTexture (nil, "overlay")
					modelFrameBackgroundIcon:SetPoint ("center", modelFrameBackground, "center")
					modelFrameBackgroundIcon:SetTexture ([[Interface\CHARACTERFRAME\Disconnect-Icon]])
					modelFrameBackgroundIcon:SetVertexColor (.5, .5, .5, 0.7)
					modelFrameBackground:Hide()
					modelFrameBackgroundIcon:Hide()
					
					local selectedEncounterActor = function (actorName, model)
						source_field:SetText (actorName)
						source_dropdown:Select (4, true)
						box1.sourceentry:Enable()
						actorsFrame:Hide()
						GameCooltip:Hide()
					end
					
					local actorsFrameButtons = {}

					local buttonMouseOver = function (button)
						button.MyObject.image:SetBlendMode ("ADD")
						button.MyObject.line:SetBlendMode ("ADD")
						button.MyObject.label:SetTextColor (1, 1, 1, 1)
						GameTooltip:SetOwner (button, "ANCHOR_TOPLEFT")
						GameTooltip:AddLine (button.MyObject.actor)
						GameTooltip:Show()
						
						local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (button.MyObject.ej_id)
						
						modelFrameTexture:SetTexture (bgImage)
						modelFrameTexture:SetTexCoord (3/512, 370/512, 5/512, 429/512)
						modelFrame:Show()
						
						modelFrame:SetDisplayInfo (button.MyObject.model)
					end
					local buttonMouseOut = function (button)
						button.MyObject.image:SetBlendMode ("BLEND")
						button.MyObject.line:SetBlendMode ("BLEND")
						button.MyObject.label:SetTextColor (.8, .8, .8, .8)
						GameTooltip:Hide()
						modelFrame:Hide()
					end
					
					local EncounterSelect = function (_, _, instanceId, bossIndex, ej_id)
						
						DetailsCustomSpellsFrame:Hide()
						DetailsCustomActorsFrame:Hide()
						DetailsCustomActorsFrame2:Show()
						GameCooltip:Hide()
						
						local encounterID = _detalhes:GetEncounterIdFromBossIndex (instanceId, bossIndex)
						
						if (encounterID) then
							local actors = _detalhes:GetEncounterActorsName (encounterID)

							local x = 10
							local y = 10
							local i = 1
							
							for actor, actorTable in pairs (actors) do 
							
								local thisButton = actorsFrameButtons [i]
								
								if (not thisButton) then
									thisButton = gump:NewButton (actorsFrame.frame, actorsFrame.frame, "DetailsCustomActorsFrame2Button"..i, "button"..i, 130, 20, selectedEncounterSpell)
									thisButton:SetPoint ("topleft", "DetailsCustomActorsFrame2", "topleft", x, -y)
									thisButton:SetHook ("OnEnter", buttonMouseOver)
									thisButton:SetHook ("OnLeave", buttonMouseOut)
									
									local t = gump:NewImage (thisButton, nil, 20, 20, nil, nil, "image", "DetailsCustomActors2EncounterImageButton"..i)
									t:SetPoint ("left", thisButton)
									t:SetTexture ([[Interface\MINIMAP\TRACKING\Target]])
									t:SetDesaturated (true)
									t:SetSize (20, 20)
									t:SetAlpha (0.7)
									
									local text = gump:NewLabel (thisButton, nil, "DetailsCustomActorsFrame2Button"..i.."Label", "label", "Spell", nil, 9.5, {.8, .8, .8, .8})
									text:SetPoint ("left", t.image, "right", 2, 0)
									text:SetWidth (123)
									text:SetHeight (10)
									
									local border = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 40, 38, nil, nil, "border", "DetailsCustomActors2EncounterBorderButton"..i)
									border:SetTexCoord (0.00390625, 0.27734375, 0.44140625,0.69531250)
									border:SetDrawLayer ("background")
									border:SetPoint ("topleft", thisButton.button, "topleft", -9, 9)
									
									local line = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 134, 25, nil, nil, "line", "DetailsCustomActors2EncounterLineButton"..i)
									line:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
									line:SetDrawLayer ("background")
									line:SetPoint ("left", thisButton.button, "right", -110, -3)
									
									table.insert (actorsFrameButtons, #actorsFrameButtons+1, thisButton)
								end
								
								y = y + 20
								if (y >= 260) then
									y = 10
									x = x + 150
								end
								
								thisButton.label:SetText (actor)
								thisButton:SetClickFunction (selectedEncounterActor, actor, actorTable.model)
								thisButton.actor = actor
								thisButton.ej_id = ej_id
								thisButton.model = actorTable.model
								thisButton:Show()
								i = i + 1
							end
							
							for maxIndex = i, #actorsFrameButtons do
								actorsFrameButtons [maxIndex]:Hide()
							end
							
							i = i-1
							actorsFrame:SetSize (math.ceil (i/13)*160, math.min (i*20 + 20, 280))
						
						end
					end
					
					local BuildEncounterMenu = function()
					
						GameCooltip:Reset()
						GameCooltip:SetType ("menu")
						GameCooltip:SetOwner (adds_boss)

						for instanceId, instanceTable in pairs (_detalhes.EncounterInformation) do 
						
							if (_detalhes:InstanceIsRaid (instanceId)) then
						
								GameCooltip:AddLine (instanceTable.name, _, 1, "white")
								GameCooltip:AddIcon (instanceTable.icon, 1, 1, 64, 32)

								for index, encounterName in ipairs (instanceTable.boss_names) do 
									GameCooltip:AddMenu (2, EncounterSelect, instanceId, index, instanceTable.ej_id, encounterName, nil, true)
									local L, R, T, B, Texture = _detalhes:GetBossIcon (instanceId, index)
									GameCooltip:AddIcon (Texture, 2, 1, 20, 20, L, R, T, B)
								end
								
								GameCooltip:SetWallpaper (2, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
							
							end
						end
						
						GameCooltip:SetOption ("HeightAnchorMod", -10)
						GameCooltip:SetOption ("ButtonsYMod", -2)
						GameCooltip:SetOption ("YSpacingMod", 0)
						GameCooltip:SetOption ("TextHeightMod", 0)
						GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
						GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
						
						GameCooltip:ShowCooltip()
					end
					
					adds_boss:SetScript ("OnEnter", function() 
						adds_boss_image:SetBlendMode ("ADD")
						BuildEncounterMenu()
					end)
					
					adds_boss:SetScript ("OnLeave", function() 
						adds_boss_image:SetBlendMode ("BLEND")
					end)
					
				--target
					local target_label = gump:NewLabel (box1, box1, "$parenTargetLabel", "target", Loc ["STRING_CUSTOM_TARGET"], "GameFontHighlightLeft")
					target_label:SetPoint ("topleft", source_label, "bottomleft", 0, -40)
					
					local disable_target_field = function()
						box1.targetentry:Disable()
					end
					local enable_target_field = function()
						box1.targetentry:Enable()
						box1.targetentry:SetFocus (true)
					end
					
					local target_icon = [[Interface\COMMON\Indicator-Yellow]]
					local target_icon2 = [[Interface\COMMON\Indicator-Gray]]
					
					local targeting_options = {
						{value = "[all]", label = "All Characters", desc = "Search for matches in all characters.", onclick = disable_target_field, icon = target_icon},
						{value = "[raid]", label = "Raid or Party Group", desc = "Search for matches in all characters which is part of your party or raid group.", onclick = disable_target_field, icon = target_icon},
						{value = "[player]", label = "Only You", desc = "Search for matches only in your character.", onclick = disable_target_field, icon = target_icon},
						{value = false, label = "Specific Character", desc = "Type the name of the character used to search.", onclick = enable_target_field, icon = target_icon},
						{value = "[none]", label = "No Target", desc = "Do not search for targets.", onclick = disable_target_field, icon = target_icon2},
					}
					local build_target_list = function() return targeting_options end
					local target_dropdown = gump:NewDropDown (box1, nil, "$parentTargetDropdown", "targetdropdown", 178, 20, build_target_list, 1)
					target_dropdown:SetPoint ("left", target_label, "left", 62, 0)
					target_dropdown.tooltip = Loc ["STRING_CUSTOM_TARGET_DESC"]
					custom_window.target_dropdown = target_dropdown
					
					local target_field = gump:NewTextEntry (box1, nil, "$parentTargetEntry", "targetentry", 201, 20)
					target_field:SetPoint ("topleft", target_dropdown, "bottomleft", 0, -2)
					target_field:Disable()
					custom_window.target_field = target_field
					--
					
					local adds_boss = CreateFrame ("frame", nil, box1)
					adds_boss:SetPoint ("left", target_dropdown.widget, "right", 2, 0)
					adds_boss:SetSize (20, 20)
					local adds_boss_image = adds_boss:CreateTexture (nil, "overlay")
					adds_boss_image:SetPoint ("center", adds_boss)
					adds_boss_image:SetTexture ("Interface\\Buttons\\UI-MicroButton-Raid-Up")
					adds_boss_image:SetTexCoord (0.046875, 0.90625, 0.40625, 0.953125)
					adds_boss_image:SetWidth (20)
					adds_boss_image:SetHeight (16)
					
					local actorsFrame = gump:NewPanel (custom_window, _, "DetailsCustomActorsFrame", "actorsFrame", 1, 1)
					actorsFrame:SetPoint ("topleft", custom_window, "topright", 5, -60)
					actorsFrame:Hide()
					
					local modelFrame = _CreateFrame ("playermodel", "DetailsCustomActorsFrameModel", custom_window)
					modelFrame:SetSize (138, 261)
					modelFrame:SetPoint ("topright", actorsFrame.widget, "topleft", -15, -8)
					modelFrame:Hide()
					local modelFrameTexture = modelFrame:CreateTexture (nil, "background")
					modelFrameTexture:SetAllPoints()
					
					local selectedEncounterActor = function (actorName)
						target_field:SetText (actorName)
						target_dropdown:Select (4, true)
						box1.targetentry:Enable()
						actorsFrame:Hide()
						GameCooltip:Hide()
					end
					
					local actorsFrameButtons = {}

					local buttonMouseOver = function (button)
						button.MyObject.image:SetBlendMode ("ADD")
						button.MyObject.line:SetBlendMode ("ADD")
						button.MyObject.label:SetTextColor (1, 1, 1, 1)
						GameTooltip:SetOwner (button, "ANCHOR_TOPLEFT")
						GameTooltip:AddLine (button.MyObject.actor)
						GameTooltip:Show()
						
						local name, description, bgImage, buttonImage, loreImage, dungeonAreaMapID, link = DetailsFramework.EncounterJournal.EJ_GetInstanceInfo (button.MyObject.ej_id)
						
						modelFrameTexture:SetTexture (bgImage)
						modelFrameTexture:SetTexCoord (3/512, 370/512, 5/512, 429/512)
						modelFrame:Show()
						
						modelFrame:SetDisplayInfo (button.MyObject.model)
					end
					local buttonMouseOut = function (button)
						button.MyObject.image:SetBlendMode ("BLEND")
						button.MyObject.line:SetBlendMode ("BLEND")
						button.MyObject.label:SetTextColor (.8, .8, .8, .8)
						GameTooltip:Hide()
						
						modelFrame:Hide()
					end
					
					local EncounterSelect = function (_, _, instanceId, bossIndex, ej_id)
						
						DetailsCustomSpellsFrame:Hide()
						DetailsCustomActorsFrame:Show()
						DetailsCustomActorsFrame2:Hide()
						GameCooltip:Hide()
						
						local encounterID = _detalhes:GetEncounterIdFromBossIndex (instanceId, bossIndex)
						if (encounterID) then
							local actors = _detalhes:GetEncounterActorsName (encounterID)

							local x = 10
							local y = 10
							local i = 1
							
							for actor, actorTable in pairs (actors) do 
							
								local thisButton = actorsFrameButtons [i]
								
								if (not thisButton) then
									thisButton = gump:NewButton (actorsFrame.frame, actorsFrame.frame, "DetailsCustomActorsFrameButton"..i, "button"..i, 130, 20, selectedEncounterSpell)
									thisButton:SetPoint ("topleft", "DetailsCustomActorsFrame", "topleft", x, -y)
									thisButton:SetHook ("OnEnter", buttonMouseOver)
									thisButton:SetHook ("OnLeave", buttonMouseOut)
									
									local t = gump:NewImage (thisButton, nil, 20, 20, nil, nil, "image", "DetailsCustomActorsEncounterImageButton"..i)
									t:SetPoint ("left", thisButton)
									t:SetTexture ([[Interface\MINIMAP\TRACKING\Target]])
									t:SetDesaturated (true)
									t:SetSize (20, 20)
									t:SetAlpha (0.7)
									
									local text = gump:NewLabel (thisButton, nil, "DetailsCustomActorsFrameButton"..i.."Label", "label", "Spell", nil, 9.5, {.8, .8, .8, .8})
									text:SetPoint ("left", t.image, "right", 2, 0)
									text:SetWidth (123)
									text:SetHeight (10)
									
									local border = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 40, 38, nil, nil, "border", "DetailsCustomActorsEncounterBorderButton"..i)
									border:SetTexCoord (0.00390625, 0.27734375, 0.44140625,0.69531250)
									border:SetDrawLayer ("background")
									border:SetPoint ("topleft", thisButton.button, "topleft", -9, 9)
									
									local line = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 84, 25, nil, nil, "line", "DetailsCustomActorsEncounterLineButton"..i)
									line:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
									line:SetDrawLayer ("background")
									line:SetPoint ("left", thisButton.button, "right", -110, -3)
									
									table.insert (actorsFrameButtons, #actorsFrameButtons+1, thisButton)
								end
								
								y = y + 20
								if (y >= 260) then
									y = 10
									x = x + 150
								end
								
								thisButton.label:SetText (actor)
								thisButton:SetClickFunction (selectedEncounterActor, actor)
								thisButton.actor = actor
								thisButton.ej_id = ej_id
								thisButton.model = actorTable.model
								thisButton:Show()
								i = i + 1
							end
							
							for maxIndex = i, #actorsFrameButtons do
								actorsFrameButtons [maxIndex]:Hide()
							end
							
							i = i-1
							actorsFrame:SetSize (math.ceil (i/13)*160, math.min (i*20 + 20, 280))
						
						end
					end
					
					local BuildEncounterMenu = function()
					
						GameCooltip:Reset()
						GameCooltip:SetType ("menu")
						GameCooltip:SetOwner (adds_boss)
						
						for instanceId, instanceTable in pairs (_detalhes.EncounterInformation) do 
						
							if (_detalhes:InstanceIsRaid (instanceId)) then
						
								GameCooltip:AddLine (instanceTable.name, _, 1, "white")
								GameCooltip:AddIcon (instanceTable.icon, 1, 1, 64, 32)

								for index, encounterName in ipairs (instanceTable.boss_names) do 
									GameCooltip:AddMenu (2, EncounterSelect, instanceId, index, instanceTable.ej_id, encounterName, nil, true)
									local L, R, T, B, Texture = _detalhes:GetBossIcon (instanceId, index)
									GameCooltip:AddIcon (Texture, 2, 1, 20, 20, L, R, T, B)
								end
								
								GameCooltip:SetWallpaper (2, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
							
							end
						end
						
						GameCooltip:SetOption ("HeightAnchorMod", -10)
						GameCooltip:SetOption ("ButtonsYMod", -2)
						GameCooltip:SetOption ("YSpacingMod", 0)
						GameCooltip:SetOption ("TextHeightMod", 0)
						GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
						GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
						GameCooltip:ShowCooltip()
					end
					
					adds_boss:SetScript ("OnEnter", function() 
						adds_boss_image:SetBlendMode ("ADD")
						BuildEncounterMenu()
					end)
					
					adds_boss:SetScript ("OnLeave", function() 
						adds_boss_image:SetBlendMode ("BLEND")
					end)					
					
				--spellid
					local spellid_label = gump:NewLabel (box1, box1, "$parenSpellidLabel", "spellid", Loc ["STRING_CUSTOM_SPELLID"], "GameFontHighlightLeft") --> localize-me
					spellid_label:SetPoint ("topleft", target_label, "bottomleft", 0, -40)
					
					local spellid_entry = gump:NewSpellEntry (box1, function()end, 178, 20, nil, nil, "spellidentry", "$parentSpellIdEntry")
					spellid_entry:SetPoint ("left", spellid_label, "left", 62, 0)
					spellid_entry.tooltip = Loc ["STRING_CUSTOM_SPELLID_DESC"]
					custom_window.spellid_entry = spellid_entry
			
					local spell_id_boss = CreateFrame ("frame", nil, box1)
					spell_id_boss:SetPoint ("left", spellid_entry.widget, "right", 2, 0)
					spell_id_boss:SetSize (20, 20)
					local spell_id_boss_image = spell_id_boss:CreateTexture (nil, "overlay")
					spell_id_boss_image:SetPoint ("center", spell_id_boss)
					spell_id_boss_image:SetTexture ("Interface\\Buttons\\UI-MicroButton-Raid-Up")
					spell_id_boss_image:SetTexCoord (0.046875, 0.90625, 0.40625, 0.953125)
					spell_id_boss_image:SetWidth (20)
					spell_id_boss_image:SetHeight (16)
					
					local spellsFrame = gump:NewPanel (custom_window, _, "DetailsCustomSpellsFrame", "spellsFrame", 1, 1)
					spellsFrame:SetPoint ("topleft", custom_window, "topright", 5, 0)
					spellsFrame:Hide()
					
					local selectedEncounterSpell = function (spellId)
						local _, _, icon = _GetSpellInfo (spellId)
						spellid_entry:SetText (spellId)
						box0.icontexture:SetTexture (icon)
						spellsFrame:Hide()
						GameCooltip:Hide()
					end
					
					local spellsFrameButtons = {}

					local buttonMouseOver = function (button)
						button.MyObject.image:SetBlendMode ("ADD")
						button.MyObject.line:SetBlendMode ("ADD")
						button.MyObject.label:SetTextColor (1, 1, 1, 1)

						GameTooltip:SetOwner (button, "ANCHOR_TOPLEFT")
						_detalhes:GameTooltipSetSpellByID (button.MyObject.spellid)
						GameTooltip:Show()
					end
					local buttonMouseOut = function (button)
						button.MyObject.image:SetBlendMode ("BLEND")
						button.MyObject.line:SetBlendMode ("BLEND")
						button.MyObject.label:SetTextColor (.8, .8, .8, .8)
						GameTooltip:Hide()
					end
					
					local EncounterSelect = function (_, _, instanceId, bossIndex)
						
						DetailsCustomSpellsFrame:Show()
						DetailsCustomActorsFrame:Hide()
						DetailsCustomActorsFrame2:Hide()
						
						GameCooltip:Hide()
						
						local spells = _detalhes:GetEncounterSpells (instanceId, bossIndex)
						
						local x = 10
						local y = 10
						local i = 1
						
						for spell, _ in pairs (spells) do 
						
							local thisButton = spellsFrameButtons [i]
							
							if (not thisButton) then
								thisButton = gump:NewButton (spellsFrame.frame, spellsFrame.frame, "DetailsCustomSpellsFrameButton"..i, "button"..i, 80, 20, selectedEncounterSpell)
								thisButton:SetPoint ("topleft", "DetailsCustomSpellsFrame", "topleft", x, -y)
								thisButton:SetHook ("OnEnter", buttonMouseOver)
								thisButton:SetHook ("OnLeave", buttonMouseOut)
								
								local t = gump:NewImage (thisButton, nil, 20, 20, nil, nil, "image", "DetailsCustomEncounterImageButton"..i)
								t:SetPoint ("left", thisButton)
								
								local text = gump:NewLabel (thisButton, nil, "DetailsCustomSpellsFrameButton"..i.."Label", "label", "Spell", nil, 9.5, {.8, .8, .8, .8})
								text:SetPoint ("left", t.image, "right", 2, 0)
								text:SetWidth (73)
								text:SetHeight (10)
								
								local border = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 40, 38, nil, nil, "border", "DetailsCustomEncounterBorderButton"..i)
								border:SetTexCoord (0.00390625, 0.27734375, 0.44140625,0.69531250)
								border:SetDrawLayer ("background")
								border:SetPoint ("topleft", thisButton.button, "topleft", -9, 9)
								
								local line = gump:NewImage (thisButton, "Interface\\SPELLBOOK\\Spellbook-Parts", 84, 25, nil, nil, "line", "DetailsCustomEncounterLineButton"..i)
								line:SetTexCoord (0.31250000, 0.96484375, 0.37109375, 0.52343750)
								line:SetDrawLayer ("background")
								line:SetPoint ("left", thisButton.button, "right", -60, -3)
								
								table.insert (spellsFrameButtons, #spellsFrameButtons+1, thisButton)
							end
							
							y = y + 20
							if (y >= 400) then
								y = 10
								x = x + 100
							end
							
							local nome_magia, _, icone_magia = _GetSpellInfo (spell)
							thisButton.image:SetTexture (icone_magia)
							thisButton.label:SetText (nome_magia)
							thisButton:SetClickFunction (selectedEncounterSpell, spell)
							thisButton.spellid = spell
							thisButton:Show()
							i = i + 1
						end
						
						for maxIndex = i, #spellsFrameButtons do
							spellsFrameButtons [maxIndex]:Hide()
						end
						
						i = i-1
						spellsFrame:SetSize (math.ceil (i/20)*110, math.min (i*20 + 20, 420))
						
					end
					
					local BuildEncounterMenu = function()
					
						GameCooltip:Reset()
						GameCooltip:SetType ("menu")
						GameCooltip:SetOwner (spell_id_boss)
						
						for instanceId, instanceTable in pairs (_detalhes.EncounterInformation) do 
						
							if (_detalhes:InstanceisRaid (instanceId)) then
						
								GameCooltip:AddLine (instanceTable.name, _, 1, "white")
								GameCooltip:AddIcon (instanceTable.icon, 1, 1, 64, 32)

								for index, encounterName in ipairs (instanceTable.boss_names) do 
									GameCooltip:AddMenu (2, EncounterSelect, instanceId, index, nil, encounterName, nil, true)
									local L, R, T, B, Texture = _detalhes:GetBossIcon (instanceId, index)
									GameCooltip:AddIcon (Texture, 2, 1, 20, 20, L, R, T, B)
								end
							
								GameCooltip:SetWallpaper (2, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
							
							end
						end
						
						GameCooltip:SetOption ("ButtonsYMod", -2)
						GameCooltip:SetOption ("YSpacingMod", 0)
						GameCooltip:SetOption ("TextHeightMod", 0)
						GameCooltip:SetOption ("IgnoreButtonAutoHeight", false)
						GameCooltip:SetWallpaper (1, [[Interface\SPELLBOOK\Spellbook-Page-1]], {.6, 0.1, 0, 0.64453125}, {1, 1, 1, 0.1}, true)
						
						GameCooltip:SetOption ("HeightAnchorMod", -10)
						GameCooltip:ShowCooltip()
					end
					
					spell_id_boss:SetScript ("OnEnter", function() 
						spell_id_boss_image:SetBlendMode ("ADD")
						BuildEncounterMenu()
					end)
					
					spell_id_boss:SetScript ("OnLeave", function() 
						spell_id_boss_image:SetBlendMode ("BLEND")
					end)
			
			--select target
			--select spell
			
			--> create box type 2
				local box2 = _CreateFrame ("frame", "DetailsCustomPanelBox2", custom_window)
				custom_window.box2 = box2
				box2:SetSize (450, 180)
				box2:SetPoint ("topleft", icon_label.widget, "bottomleft", -10, -20)
				
				box2:SetFrameLevel (box0:GetFrameLevel()+1)
			
				--edit main code
				local maincode_button = gump:NewButton (box2, nil, "$parentMainCodeButton", "maiccodebutton", 160, 20, DetailsCustomPanel.StartEditCode, 1, nil, nil, Loc ["STRING_CUSTOM_EDIT_SEARCH_CODE"])
				maincode_button:SetPoint ("topleft", custom_window, "topleft", CONST_EDITBUTTONS_X_POSITION, CONST_MENU_Y_POSITION)
				maincode_button.tooltip = Loc ["STRING_CUSTOM_EDITCODE_DESC"]
				maincode_button:SetTemplate (CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE)
				
				--edit tooltip code
				local tooltipcode_button = gump:NewButton (box2, nil, "$parentTooltipCodeButton", "tooltipcodebutton", 160, 20, DetailsCustomPanel.StartEditCode, 2, nil, nil, Loc ["STRING_CUSTOM_EDIT_TOOLTIP_CODE"])
				tooltipcode_button:SetPoint ("topleft", maincode_button, "bottomleft", 0, -8)
				tooltipcode_button.tooltip = Loc ["STRING_CUSTOM_EDITTOOLTIP_DESC"]
				tooltipcode_button:SetTemplate (CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE)
				
				--edit total code
				local totalcode_button = gump:NewButton (box2, nil, "$parentTotalCodeButton", "totalcodebutton", 160, 20, DetailsCustomPanel.StartEditCode, 3, nil, nil, "Edit Total Code")
				totalcode_button:SetPoint ("topleft", tooltipcode_button, "bottomleft", 0, -8)
				totalcode_button.tooltip = "This code is responsible for edit the total number shown in the player bar.\n\nThis is not necessary if you want show exactly the value gotten in the search code."
				totalcode_button:SetTemplate (CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE)
				
				--edit percent code
				local percentcode_button = gump:NewButton (box2, nil, "$parentPercentCodeButton", "percentcodebutton", 160, 20, DetailsCustomPanel.StartEditCode, 4, nil, nil, "Edit Percent Code")
				percentcode_button:SetPoint ("topleft", totalcode_button, "bottomleft", 0, -8)
				percentcode_button.tooltip = "Edit the code responsible for the percent number in the player bar.\n\nThis is not required if you want to use simple percentage (comparing with total)."
				percentcode_button:SetTemplate (CONST_CODETEXTENTRY_OPENCODEBUTTONS_TEMPLATE)
				
				box2:Hide()
			
			--> create the code editbox
				local code_editor = gump:NewSpecialLuaEditorEntry (custom_window, CONST_EDITBOX_WIDTH, CONST_EDITBOX_HEIGHT, "codeeditor", "$parentCodeEditor")
				code_editor:SetPoint ("topleft", custom_window, "topleft", CONST_MENU_X_POSITION, CONST_EDITBOX_Y_POSITION)
				code_editor:SetFrameLevel (custom_window:GetFrameLevel()+4)
				code_editor:SetBackdrop (nil)
				code_editor:HookScript ("OnUpdate", function()
					local script = code_editor:GetText()
					local func, errortext = loadstring (script)
					if (not func) then
						local firstLine = strsplit ("\n", script, 2)
						errortext = errortext:gsub (firstLine, "")
						errortext = errortext:gsub ("%[string \"", "")
						errortext = errortext:gsub ("...\"]:", "")
						errortext = "Line " .. errortext
						DetailsCustomPanel.ErrorString.text = errortext
					else
						DetailsCustomPanel.ErrorString.text = ""
					end
					--
				end)
				
				--> create a background area where the code editor is
				local codeEditorBackground = gump:NewButton (custom_window, nil, nil, nil, 1, 1, function()end)
				codeEditorBackground:SetAllPoints (code_editor)
				codeEditorBackground:SetTemplate (CONST_CODETEXTENTRY_TEMPLATE)
				
				code_editor:Hide()
				code_editor.font_size = 11
				
				local file, size, flags = code_editor.editbox:GetFont()
				code_editor.editbox:SetFont (file, 11, flags)
				
				local expand_func = function()
					if (code_editor.expanded) then
						code_editor:SetSize (CONST_EDITBOX_WIDTH, CONST_EDITBOX_HEIGHT)
						code_editor.expanded = nil
						codeEditorBackground:SetTemplate (CONST_CODETEXTENTRY_TEMPLATE)
						
						--custom_window.box0.cancelbutton:SetPoint ("bottomleft", attribute_box, "bottomright", 37, -10)
						--custom_window.box0.acceptbutton:SetPoint ("left", cancel_button, "right", 2, 0)
					else
						code_editor:SetSize (CONST_EDITBOX_WIDTH, CONST_EDITBOX_HEIGHT*1.9)
						code_editor.expanded = true
						codeEditorBackground:SetTemplate (CONST_CODETEXTENTRYEXPANDED_TEMPLATE)
						
						--custom_window.box0.cancelbutton:SetPoint ("bottomleft", attribute_box, "bottomright", -237, -10)
						--custom_window.box0.acceptbutton:SetPoint
					end
				end
				
				local font_change = function (_, _, increase)
					if (increase) then
						local file, size, flags = code_editor.editbox:GetFont()
						code_editor.font_size = code_editor.font_size + 1
						code_editor.editbox:SetFont (file, code_editor.font_size, flags)
					else
						local file, size, flags = code_editor.editbox:GetFont()
						code_editor.font_size = code_editor.font_size - 1
						code_editor.editbox:SetFont (file, code_editor.font_size, flags)
					end
				end
				
				local apply_code = function()
				
					_detalhes:ResetCustomFunctionsCache()
				
					if (DetailsCustomPanel.CodeEditing == 1) then
						DetailsCustomPanel.code1 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 2) then
						DetailsCustomPanel.code2 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 3) then
						DetailsCustomPanel.code3 = custom_window.codeeditor:GetText()
					elseif (DetailsCustomPanel.CodeEditing == 4) then
						DetailsCustomPanel.code4 = custom_window.codeeditor:GetText()
					end
					
					local main_code = DetailsCustomPanel.code1
					local tooltip_code = DetailsCustomPanel.code2
					local total_code = DetailsCustomPanel.code3
					local percent_code = DetailsCustomPanel.code4
					
					local object = DetailsCustomPanel.IsEditing
					
					if (type (object) ~= "table") then
						return _detalhes:Msg ("This object need to be saved before.")
					end
					
					object.script = main_code
					object.tooltip = tooltip_code
					
					if (total_code ~= DetailsCustomPanel.code3_default) then
						object.total_script = total_code
					else
						object.total_script = false
					end
					
					if (percent_code ~= DetailsCustomPanel.code4_default) then
						object.percent_script = percent_code
					else
						object.percent_script = false
					end

					return true
				end
				
				local supportFrame = CreateFrame ("frame", "$parentSupportFrame", custom_window)
				supportFrame:SetFrameLevel (500)
				
				local expand = gump:NewButton (supportFrame, nil, "$parentExpand", "expandbutton", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, expand_func, 4, nil, nil, "Expand")
				expand:SetPoint ("bottomleft", code_editor, "topleft", 0, 1)
				expand:SetTemplate (CONST_CODETEXTENTRYBUTTON_TEMPLATE)
				
				local font_size1 = gump:NewButton (supportFrame, nil, "$parentFont1", "font1button", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, font_change, nil, nil, nil, "Aa")
				font_size1:SetPoint ("left", expand, "right", 2, 0)
				font_size1:SetTemplate (CONST_CODETEXTENTRYBUTTON_TEMPLATE)
				
				local font_size2 = gump:NewButton (supportFrame, nil, "$parentFont2", "font2button", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, font_change, true, nil, nil, "aA")
				font_size2:SetPoint ("left", font_size1, "right", 2, 0)
				font_size2:SetTemplate (CONST_CODETEXTENTRYBUTTON_TEMPLATE)
				
				local apply1 = gump:NewButton (supportFrame, nil, "$parentApply", "applybutton", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, apply_code, nil, nil, nil, "Apply")
				apply1:SetPoint ("left", font_size2, "right", 2, 0)
				apply1:SetTemplate (CONST_CODETEXTENTRYBUTTON_TEMPLATE)
				
				local open_API = gump:NewButton (supportFrame, nil, "$parentOpenAPI", "openAPIbutton", CONST_EDITBOX_BUTTON_WIDTH, CONST_EDITBOX_BUTTON_HEIGHT, _detalhes.OpenAPI, nil, nil, nil, "API")
				open_API:SetPoint ("left", apply1, "right", 2, 0)
				open_API:SetTemplate (CONST_CODETEXTENTRYBUTTON_TEMPLATE)
				
				local errorString = gump:CreateLabel (supportFrame)
				errorString:SetPoint ("left", open_API, "right", 10, 0)
				errorString.color = "red"
				DetailsCustomPanel.ErrorString = errorString
				
				code_editor:SetScript ("OnShow", function()
					expand:Show()
					font_size1:Show()
					font_size2:Show()
					apply1:Show()
					open_API:Show()
				end)
				code_editor:SetScript ("OnHide", function()
					expand:Hide()
					font_size1:Hide()
					font_size2:Hide()
					apply1:Hide()
					open_API:Hide()
				end)
				
				expand:Hide()
				font_size1:Hide()
				font_size2:Hide()
				apply1:Hide()
				open_API:Hide()
				
			--> select damage
				DetailsCustomPanelAttributeMenu1:Click()
		else
			DetailsPluginContainerWindow.OpenPlugin (DetailsCustomPanel)
			--_G.DetailsCustomPanel:Show()
		end
	end
	
